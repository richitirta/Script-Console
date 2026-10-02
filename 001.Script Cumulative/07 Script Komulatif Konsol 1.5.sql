--Tuning script

IF EXISTS ( SELECT * FROM   sysobjects WHERE  id = object_id(N'[dbo].[QInConsistent_LossItem]') and OBJECTPROPERTY(id, N'IsProcedure') = 1 )
begin
DROP Procedure QInConsistent_LossItem
end
GO

CREATE  procedure QInConsistent_LossItem(@P_CNO integer)     
as     
Declare @P_LossDate as smalldatetime        
Declare @P_LossTime as varchar(5)        
Declare @P_EventNo as int      
Declare @P_COL as varchar(10)        
        
Select @P_LossDate=LossDate, @P_LossTime=LossTime, @P_EventNo=EventNo, @P_Col=COL
from Claim Where CNO=@P_CNO        
                       
Select TOP 1 CLLOSS.INO,CLLOSS.NOC  
from CLLOSS Where CNO=@P_CNO And not Exists  
(  
Select ICOVER.INO,NOC.NOC  
From ICOVER WITH (INDEX(I_ICOVER)), ICOVERNOC, NOC, ACCEPTANCE  
Where ICOVER.INO=CLLOSS.INO AND ICOVERNOC.INO=ICOVER.INO AND NOC.NOC=ICOVERNOC.NOC AND NOC.TOI=ICOVER.TOI AND NOC.NOC=CLLOSS.NOC
AND ACCEPTANCE.ANO=ICOVER.ANO  
AND ((ICOVERNOC.SDATE<=@P_LOSSDATE AND ACCEPTANCE.ExclusiveF=1) or ((ICOVERNOC.SDATE<@P_LOSSDATE or (ICOVERNOC.SDATE=@P_LOSSDATE AND ACCEPTANCE.STIME<=@P_LOSSTIME)) AND ACCEPTANCE.ExclusiveF=0))                     
AND ((dbo.fn_Get_ExtPeriodDate(ACCEPTANCE.ExtPeriod, ACCEPTANCE.ExtPeriodInDaysF, ICOVERNOC.EDATE)>@P_LOSSDATE AND ACCEPTANCE.ExclusiveF=1) or ((dbo.fn_Get_ExtPeriodDate(ACCEPTANCE.ExtPeriod, ACCEPTANCE.ExtPeriodInDaysF, ICOVERNOC.EDATE)>@P_LOSSDATE or (dbo.fn_Get_ExtPeriodDate(ACCEPTANCE.ExtPeriod, ACCEPTANCE.ExtPeriodInDaysF, ICOVERNOC.EDATE)=@P_LOSSDATE AND ACCEPTANCE.ETIME>@P_LOSSTIME)) AND ACCEPTANCE.ExclusiveF=0))                              
AND
ABS(CASE 
WHEN ICOVERNOC.AMOUNT<>0 AND ICOVERNOC.PCT*ICOVER.AMOUNT/100<>0 THEN
	CASE WHEN ICOVERNOC.AMOUNT>ICOVERNOC.PCT*ICOVER.AMOUNT/100 THEN ICOVERNOC.PCT*ICOVER.AMOUNT/100 ELSE ICOVERNOC.AMOUNT END
WHEN ICOVERNOC.AMOUNT<>0 THEN ICOVERNOC.AMOUNT
ELSE ICOVERNOC.PCT*ICOVER.AMOUNT/100
END-CLLOSS.DECLARED)<=1
  
UNION ALL  
    
Select ICOVER.INO, NOC.NOC  
From ICOVER WITH (INDEX(I_ICOVER)), RCOVER, Col, RATECOV, PCLASS, NOC, ACCEPTANCE, COLNOCCLASS        
Where ICOVER.INO=CLLOSS.INO AND RCOVER.ANO=ICOVER.ANO AND ACCEPTANCE.ANO=RCOVER.ANO AND COL.COL=@P_COL      
AND ((RCOVER.SDATE<=@P_LOSSDATE AND ACCEPTANCE.ExclusiveF=1) or ((RCOVER.SDATE<@P_LOSSDATE or (RCOVER.SDATE=@P_LOSSDATE AND ACCEPTANCE.STIME<=@P_LOSSTIME)) AND ACCEPTANCE.ExclusiveF=0))                     
AND ((dbo.fn_Get_ExtPeriodDate(ACCEPTANCE.ExtPeriod, ACCEPTANCE.ExtPeriodInDaysF, RCOVER.EDATE)>@P_LOSSDATE AND ACCEPTANCE.ExclusiveF=1) or ((dbo.fn_Get_ExtPeriodDate(ACCEPTANCE.ExtPeriod, ACCEPTANCE.ExtPeriodInDaysF, RCOVER.EDATE)>@P_LOSSDATE or (dbo.fn_Get_ExtPeriodDate(ACCEPTANCE.ExtPeriod, ACCEPTANCE.ExtPeriodInDaysF, RCOVER.EDATE)=@P_LOSSDATE AND ACCEPTANCE.ETIME>@P_LOSSTIME)) AND ACCEPTANCE.ExclusiveF=0))                    
AND RATECOV.CODE=RCOVER.CODE AND RATECOV.TOR=COL.TOR AND PCLASS.TOR=COL.TOR AND PCLASS.TOI=ICOVER.TOI                        
AND NOC.TOI=ICOVER.TOI AND NOC.NOC=CLLOSS.NOC
AND NOT EXISTS (SELECT TOP 1 ICOVERNOC.NOC FROM ICOVERNOC WHERE ICOVERNOC.INO=CLLOSS.INO AND ICOVERNOC.NOC=NOC.NOC)                        
AND COLNOCCLASS.NOC=NOC.NOC AND COLNOCCLASS.COL=@P_COL
AND (PCLASS.CTLF=0 OR NOC.CTLF=PCLASS.CTLF)
AND
ABS(CASE                        
 WHEN @P_EVENTNO=-1 THEN                        
        CASE                        
        WHEN RCOVER.PCTLOSS=0 OR ICOVER.NOTDECRF=1 OR ICOVER.NOTFLF=1 THEN ICOVER.AMOUNT 
        ELSE ICOVER.AMOUNT*RCOVER.PCTLOSS/100 END                        
 Else                        
        CASE                        
        WHEN RCOVER.PCTLOSS=0 OR ICOVER.NOTDECRF=1 OR ICOVER.NOTFLF=1 THEN ICOVER.AMOUNT_AOE                
        ELSE ICOVER.AMOUNT_AOE*RCOVER.PCTLOSS/100 END                        
 END-CLLOSS.DECLARED)<=1
)  
          

GO


--perbaikan breakdown dari Journal (Detail Journal Lihat report GL-08-002-E)
IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[FL_SL_ACCOUNT]') AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) ) 
begin
DROP FUNCTION FL_SL_ACCOUNT 
end
GO

CREATE FUNCTION FL_SL_ACCOUNT(@P_GID varchar(10), @P_Voucher varchar(20), @P_VType varchar(10), @P_ComAcc varchar(30), @P_Doc_No varchar(20),@P_CCY varchar(10), @P_Payment_Flag bit)                                    
RETURNS @TSL_Account TABLE (Account Varchar(10), Open_ItemF Bit, Branch Varchar(15), Hint Int, Description varchar(512), Currency varchar(10), AccGroup varchar(10), Outstanding Float)                                    
AS                                        
BEGIN                               
Declare @P_SL_Cat varchar(1)                
                       
if @P_Payment_Flag=1                       
Begin              
 Select @P_SL_Cat=SL_Cat from pVoucher Where Voucher=@P_Doc_No                
 if @P_SL_Cat is null                 
 Begin              
   Select @P_SL_Cat='N'                
 End                
 if @P_SL_Cat='P'                
 Begin                           
   insert into @TSL_Account                                    
   Select A1.Account, A2.Open_ItemF, A1.Branch, A1.Hint, A2.Description, V.Currency, A2.AccGroup,          
   (Case When VType.DebtorF=1 Then 1 Else -1 end)*(Case When V.DebtorF=1 then -(Max(A1.Nominal_OC)-sum(Case When SL_Alloc.Nominal_OC is null then 0 else SL_Alloc.Nominal_OC end)) else (Max(A1.Nominal_OC)-sum(Case When SL_Alloc.Nominal_OC is null then 0 else SL_Alloc.Nominal_OC end)) end) as Outstanding              
   from pVoucher V                                     
   Inner Join Get_Open_Item_Hint_P(@P_Doc_No,@P_VType) A1 on (A1.Voucher=V.Voucher)                                     
   Inner join VType on (VType.VType=@P_VType)          
   Inner Join Account A2 on (A2.Account=A1.Account)     
   Left Join ComAcc on (ComAcc.ComAcc=@P_ComAcc)    
   Left Join Open_Item_Allocated(@P_Doc_No) SL_Alloc on (SL_Alloc.Voucher<>@P_Voucher and SL_Alloc.Doc_no=A1.Voucher and SL_Alloc.Branch=A1.Branch and SL_Alloc.Account=A1.Account)                                     
   Where @P_Doc_No<>'' and A1.Voucher=V.Voucher                                     
   and ((coalesce(ComAcc.ComAcc,'')='' and A2.AccGroup='') or (coalesce(ComAcc.ComAcc,'')<>'' and (ComAcc.AccGroup='' or A2.AccGroup='' or ComAcc.AccGroup=A2.AccGroup)))     
   Group By A1.Account, A2.Open_ItemF, A1.Branch, A1.Hint, VType.DebtorF, V.DebtorF, V.SL_Cat, A2.Description, V.Currency , A2.AccGroup                                  
   Having round(Max(A1.Nominal_OC),2)<>round(sum(Case When SL_Alloc.Nominal_OC is null then 0 else SL_Alloc.Nominal_OC end),2)                                        
 End              
 else                
 Begin              
   insert into @TSL_Account                                    
   Select A1.Account, A2.Open_ItemF, A1.Branch, A1.Hint, A2.Description, V.Currency, A2.AccGroup,
   (Case When VType.DebtorF=1 Then 1 Else -1 end)*(Case When V.DebtorF=1 then (Max(A1.Nominal_OC)-sum(Case When SL_Alloc.Nominal_OC is null then 0 else SL_Alloc.Nominal_OC end)) else (Max(A1.Nominal_OC)-sum(Case When SL_Alloc.Nominal_OC is null then 0 else SL_Alloc.Nominal_OC end)) end) as Outstanding              
   from nVoucher V                                     
   Inner Join Get_Open_Item_Hint_N(@P_Doc_No,@P_VType) A1 on (A1.Voucher=V.Voucher)                                     
   Inner join VType on (VType.VType=@P_VType)          
   Inner Join Account A2 on (A2.Account=A1.Account)       
   Left Join ComAcc on (ComAcc.ComAcc=@P_ComAcc)
   Left Join Open_Item_Allocated(@P_Doc_No) SL_Alloc on (SL_Alloc.Voucher<>@P_Voucher and SL_Alloc.Doc_no=A1.Voucher and SL_Alloc.Branch=A1.Branch and SL_Alloc.Account=A1.Account)                                     
   Where @P_Doc_No<>'' and A1.Voucher=V.Voucher                                     
   and ((coalesce(ComAcc.ComAcc,'')='' and A2.AccGroup='') or (coalesce(ComAcc.ComAcc,'')<>'' and (ComAcc.AccGroup='' or A2.AccGroup='' or ComAcc.AccGroup=A2.AccGroup)))     
   Group By A1.Account, A2.Open_ItemF, A1.Branch, A1.Hint, VType.DebtorF, V.DebtorF, V.SL_Cat, A2.Description, V.Currency, A2.AccGroup                                   
   Having round(Max(A1.Nominal_OC),2)<>round(sum(Case When SL_Alloc.Nominal_OC is null then 0 else SL_Alloc.Nominal_OC end),2)                         
 End              
End              
Else            
Begin           
 if @P_GID=''       
 Begin                        
  insert into @TSL_Account                                
  Select A1.Account, A1.Open_ItemF, '' as Branch, max(CASE WHEN vtype.debtorf=1 THEN vPattern.Credit ELSE vpattern.debit end) as Hint, A1.Description, Case When @P_CCY='' then SysTab.Currency else @P_CCY end as Currency, A1.AccGroup, 0 as Outstanding                 
  from Account A1 
  Left Join ComAcc on (ComAcc.ComAcc=@P_ComAcc), Account a2, vPattern, SysTab, VType              
  Where A1.AllowedF=1 and a1.post_flag=1 and a1.parent=a2.parent and a2.account=vPattern.account and vPattern.Constant_Flag=1 and ((vPattern.Credit<0 AND VType.DebtorF = 1) or (vPattern.Debit<0 AND VType.CreditorF = 1)) and VType.Vtype=@P_VType AND VType.VType = VPattern.VType and (A1.Hold_Flag<>1 or A1.Suspend_Flag=1)                                    
  and ((coalesce(ComAcc.ComAcc,'')='' and A1.AccGroup='') or (coalesce(ComAcc.ComAcc,'')<>'' and (ComAcc.AccGroup='' or A1.AccGroup='' or ComAcc.AccGroup=A1.AccGroup)))     
  Group By A1.Account, A1.Open_ItemF, A1.Description, SysTab.Currency, A1.AccGroup                                   
 End      
 Else      
 Begin      
  insert into @TSL_Account                                    
  Select A1.Account, A1.Open_ItemF, '' as Branch, max(CASE WHEN vtype.debtorf=1 THEN vPattern.Credit ELSE vpattern.debit end) as Hint, B.Description, Case When @P_CCY='' then SysTab.Currency else @P_CCY end as Currency, A1.AccGroup, 0 as Outstanding                   
  from Budget_AccountDetail B, Account A1 
  Left Join ComAcc on (ComAcc.ComAcc=@P_ComAcc), Account a2, vPattern, SysTab, VType                                       
  Where B.GID=@P_GID and B.ID=@P_Doc_No and (A1.Account=B.Account_Dr or A1.Account=B.Account_Cr) and A1.AllowedF=1 and a1.post_flag=1 and a1.parent=a2.parent and a2.account=vPattern.account and vPattern.Constant_Flag=1 and ((vPattern.Credit<0 AND VType.DebtorF = 1) or (vPattern.Debit<0 AND VType.CreditorF = 1)) and VType.Vtype=@P_VType AND VType.VType = VPattern.VType and (A1.Hold_Flag<>1 or A1.Suspend_Flag=1)                                      
  and ((coalesce(ComAcc.ComAcc,'')='' and A1.AccGroup='') or (coalesce(ComAcc.ComAcc,'')<>'' and (ComAcc.AccGroup='' or A1.AccGroup='' or ComAcc.AccGroup=A1.AccGroup)))     
  Group By A1.Account, A1.Open_ItemF, B.Description, SysTab.Currency, A1.AccGroup            
 End      
End       
       
Return                                    
END                

GO

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[FN_NJOURNAL_SL]') AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) ) 
begin
DROP FUNCTION FN_NJOURNAL_SL 
end
GO

CREATE FUNCTION FN_NJOURNAL_SL( @P_SDate as  smalldatetime,@P_EDate as smalldatetime)      
RETURNS TABLE         
AS RETURN ( 
Select
Distinct
SL.Voucher,
SL.Doc_No,
SL.Doc_Date,
SL.Remarks,
SL.Account, 
Case When Type.BS_Flag=1 Then '' When SL.CT='' Then Voucher.CT else SL.CT end as CT,
(Case When Type.PL_Flag=1 then SysTab.Currency else Voucher.Currency end) as Doc_CCY,
Case When Type.PL_FLAG=1 Then 
	Case When Voucher.DebtorF=1 then SL.Nominal*Voucher.Rate else -SL.Nominal*Voucher.Rate end
else
	Case When Voucher.DebtorF=1 then SL.Nominal else -SL.Nominal end
end as Nominal_OC,
Case When Type.PL_FLAG=1 Then 
	1
else
	Voucher.Rate
end as Rate,
Case When Type.PL_FLAG=1 Then 
	Case When Voucher.DebtorF=1 then SL.Nominal*Voucher.Rate else -SL.Nominal*Voucher.Rate end
else
	Case When Voucher.DebtorF=1 then SL.Nominal*Voucher.Rate else -SL.Nominal*Voucher.Rate end
end as Nominal
from nSL SL, nVoucher Voucher, nJournal Journal, Account, Type, SysTab
Where Voucher.Voucher=SL.Voucher and Account.Account=SL.Account and Type.Type=Account.Type
and Journal.Voucher=SL.Voucher and Journal.Account=SL.Account 
and Journal.Currency=(Case When Type.PL_Flag=1 then SysTab.Currency else Voucher.Currency end)
and Journal.CT=(Case When Type.BS_Flag=1 Then '' When SL.CT='' Then Voucher.CT else SL.CT end)
and Voucher.Date Between @P_SDate and @P_EDate
)

GO


IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[FN_PJOURNAL_SL]') AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) ) 
begin
DROP FUNCTION FN_PJOURNAL_SL 
end
GO

CREATE FUNCTION FN_PJOURNAL_SL( @P_SDate as  smalldatetime,@P_EDate as smalldatetime)            
RETURNS TABLE               
AS RETURN (       
Select      
Distinct      
SL.SortNo,
SL.Voucher,      
SL.Doc_No,      
SL.Doc_Date,      
SL.Remarks,      
SL.Account,       
Case When Type.BS_Flag=1 Then '' When SL.CT='' Then Voucher.CT else SL.CT end as CT,      
Case When Type.PL_Flag=1 then SysTab.Currency When SL.PaymentF=1 Then SL.Doc_CCY else Voucher.Currency end as Doc_CCY,      
Case When Voucher.SL_Cat IN ('A','B','P') then      
  Case       
   When SL.PaymentF=1 Then Case When Voucher.DebtorF=1 Then -SL.Nominal_OC else SL.Nominal_OC end      
   When Type.PL_Flag=1 Then Case When Voucher.DebtorF=1 then -SL.Nominal*Voucher.Rate else SL.Nominal*Voucher.Rate end      
   else Case When Voucher.DebtorF=1 Then -SL.Nominal else SL.Nominal end      
   end      
  else      
  Case       
   When SL.PaymentF=1 Then Case When Voucher.DebtorF=1 Then SL.Nominal_OC else -SL.Nominal_OC end      
   When Type.PL_Flag=1 Then Case When Voucher.DebtorF=1 then SL.Nominal*Voucher.Rate else -SL.Nominal*Voucher.Rate end      
   else Case When Voucher.DebtorF=1 Then SL.Nominal else -SL.Nominal end      
   end      
  end AS Nominal_OC,        
Case When Voucher.SL_Cat IN ('A','B','P') then      
  Case       
   When SL.PaymentF=1 Then (Case When (Journal.Debit_OC+Journal.Credit_OC)<>0 Then (Journal.Debit+Journal.Credit)/(Journal.Debit_OC+Journal.Credit_OC) else 0 End)  
   When Type.PL_Flag=1 Then 1      
   else Voucher.Rate end      
  else      
  Case       
   When SL.PaymentF=1 Then (Case When (Journal.Debit_OC+Journal.Credit_OC)<>0 Then (Journal.Debit+Journal.Credit)/(Journal.Debit_OC+Journal.Credit_OC) else 0 End)      
   When Type.PL_Flag=1 Then 1      
   else Voucher.Rate end         
  end AS Rate,        
Case When Voucher.SL_Cat IN ('A','B','P') then      
  Case       
   When SL.PaymentF=1 Then Case When Voucher.DebtorF=1 Then -SL.Nominal_OC else SL.Nominal_OC end *(Case When (Journal.Debit_OC+Journal.Credit_OC)<>0 Then (Journal.Debit+Journal.Credit)/(Journal.Debit_OC+Journal.Credit_OC) else 0 End)      
   When Type.PL_Flag=1 Then Case When Voucher.DebtorF=1 then -SL.Nominal*Voucher.Rate else SL.Nominal*Voucher.Rate end      
   else Case When Voucher.DebtorF=1 Then -SL.Nominal else SL.Nominal end*Voucher.Rate       
   end      
  else      
  Case       
   When SL.PaymentF=1 Then Case When Voucher.DebtorF=1 Then SL.Nominal_OC else -SL.Nominal_OC end *(Case When (Journal.Debit_OC+Journal.Credit_OC)<>0 Then (Journal.Debit+Journal.Credit)/(Journal.Debit_OC+Journal.Credit_OC) else 0 End)      
   When Type.PL_Flag=1 Then Case When Voucher.DebtorF=1 then SL.Nominal*Voucher.Rate else -SL.Nominal*Voucher.Rate end      
   else Case When Voucher.DebtorF=1 Then SL.Nominal else -SL.Nominal end*Voucher.Rate       
   end      
  end AS Nominal      
from pSL SL, pVoucher Voucher, pJournal Journal, Account, Type, SysTab      
Where Voucher.Voucher=SL.Voucher and Account.Account=SL.Account and Type.Type=Account.Type      
and Journal.Voucher=SL.Voucher and Journal.Account=SL.Account       
and Journal.Currency=(Case When Type.PL_Flag=1 then SysTab.Currency When SL.PaymentF=1 Then SL.Doc_CCY else Voucher.Currency end)      
and Journal.CT=(Case When Type.BS_Flag=1 Then '' When SL.CT='' Then Voucher.CT else SL.CT end)      
and Voucher.Date Between @P_SDate and @P_EDate      
) 
go


IF EXISTS ( SELECT * FROM   sysobjects WHERE  id = object_id(N'[dbo].[PI09]') and OBJECTPROPERTY(id, N'IsProcedure') = 1 )
begin
DROP Procedure PI09
end
GO

CREATE procedure PI09 (@P_ANO as integer) 
as 
Begin 
Declare @P_Date as smalldatetime 
Declare @P_PolicyNo as varchar(20) 
Declare @P_CertificateNo as varchar(20) 
Declare @P_OpenFLag as Bit 
Declare @P_LANO as int 
Declare @P_A_PolicyNo as varchar(50) 
Select @P_Date = Getdate() 
 
Select @P_LANO=A1.LANO, @P_PolicyNo=A1.PolicyNo, @P_CertificateNo=A1.CertificateNo, @P_OpenFlag=C1.OpenFlag from Acceptance A1, Cover C1 Where C1.CNO=A1.CNO and A1.ANO=@P_ANO 
 
if @P_LANO<>-1 
if @P_OpenFlag=1 and @P_ANO<>@P_LANO 
Select @P_A_PolicyNo=@P_PolicyNo + '-' + @P_CertificateNo 
else 
Select @P_A_PolicyNo=@P_PolicyNo 
else 
Select @P_A_PolicyNo=@P_PolicyNo 
 
Select Voucher.Voucher, Voucher.DueDate, Voucher.DocNo, Profile.Name, Voucher.Currency, 
case when Voucher.debtorf=1 then Voucher.Nominal_CC-Voucher.Diff_CC else -(Voucher.Nominal_CC-Voucher.Diff_CC) end  as Nominal, 
case when Voucher.debtorf=1 then (Voucher.AmountDue-Voucher.Payment_CC) else -(Voucher.AmountDue-Voucher.Payment_CC) end as AmountDue, 
case when Voucher.debtorf=1 then Voucher.Payment_CC else -Voucher.Payment_CC end as Payment, 
case when Voucher.debtorf=1 then Voucher.Nominal_CC-Voucher.Diff_CC - Voucher.Payment_CC else -(Voucher.Nominal_CC-Voucher.Diff_CC - Voucher.Payment_CC) end as Outstanding 
 
from nVoucher Voucher, Profile, ProAcc, Admlink 
Where Profile.ID=ProAcc.ID and ProAcc.ProAcc=Voucher.ProAcc and Admlink.Voucher=Voucher.Voucher 
and Admlink.Subject='Claim' and Admlink.Type in ('DI','IC','IR','OP') and Admlink.A_PolicyNo<>'' and Admlink.A_PolicyNo=@P_A_PolicyNo and (Admlink.Extra_1='' or Admlink.Extra_1 is null) 
and round(Voucher.AmountDue,0)>round(Voucher.Payment_CC,0) 
End 
 
 
GO

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Premium_MaxOutGo]') AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) ) 
begin
DROP FUNCTION Premium_MaxOutGo 
end
GO

CREATE Function Premium_MaxOutGo(@P_ANO as int,@P_Code as varchar(10),@P_Period int=0)        
RETURNS Float        
AS        

BEGIN        
 --Return (dbo.premium_discount(@P_ANO, @P_Code,@P_Period)-dbo.Payor_Group_Discount(@P_ANO, @P_Code,@P_Period)+dbo.Premium_Commission(@P_ANO, @P_Code,@P_Period,0)+dbo.Premium_Commission_Vat(@P_ANO, @P_Code,@P_Period,0))        
 --Return (dbo.Premium_Commission(@P_ANO, @P_Code,@P_Period,0)-dbo.Premium_Commission_UpFee(@P_ANO, @P_Code,@P_Period,0))  
 --Return (100/(100-dbo.premium_discount(@P_ANO, @P_Code,@P_Period))*(dbo.Premium_Commission(@P_ANO, @P_Code,@P_Period,0)-dbo.Premium_Commission_UpFee(@P_ANO, @P_Code,@P_Period,0)))
 Return (dbo.premium_discount(@P_ANO, @P_Code,@P_Period)+dbo.Premium_Commission(@P_ANO, @P_Code,@P_Period,0)-dbo.Premium_Commission_UpFee(@P_ANO, @P_Code,@P_Period,0))  
End      

GO

IF EXISTS ( SELECT * FROM   sysobjects WHERE  id = object_id(N'[dbo].[PI08]') and OBJECTPROPERTY(id, N'IsProcedure') = 1 )
begin
DROP Procedure PI08
end
GO

CREATE procedure PI08 (@P_ANO as integer)   
as   
Begin   
Declare @P_Date as smalldatetime   
Declare @P_PolicyNo as varchar(20)   
Declare @P_CertificateNo as varchar(20)   
Declare @P_OpenFLag as Bit   
Declare @P_LANO as int   
Declare @P_A_PolicyNo as varchar(50)   
Select @P_Date = Getdate()   
   
Select @P_LANO=A1.LANO, @P_PolicyNo=A1.PolicyNo, @P_CertificateNo=A1.CertificateNo, @P_OpenFlag=C1.OpenFlag from Acceptance A1, Cover C1 Where C1.CNO=A1.CNO and A1.ANO=@P_ANO   
   
if @P_LANO<>-1   
if @P_OpenFlag=1 and @P_ANO<>@P_LANO   
Select @P_A_PolicyNo=@P_PolicyNo + '-' + @P_CertificateNo   
else   
Select @P_A_PolicyNo=@P_PolicyNo   
else   
Select @P_A_PolicyNo=@P_PolicyNo   
   
Select Voucher.Voucher, Voucher.DueDate, Voucher.DocNo, Voucher_Due.DueDate as NDueDate, Profile.Name, Voucher.Currency,   
Admlink.RefType,  
Admlink.AccountNo, Admlink.Bank, Admlink.BankName,   
Admlink.AccountNo_Ext, Admlink.Bank_Ext, Admlink.BankName_Ext,   
case when Voucher.debtorf=1 then Voucher.Nominal_CC-Voucher.Diff_CC else -(Voucher.Nominal_CC-Voucher.Diff_CC) end  as Nominal,   
case when Voucher.debtorf=1 then (coalesce(Voucher_Due.AmountDue, Voucher.AmountDue)-Voucher.Payment_CC) else -(coalesce(Voucher_Due.AmountDue, Voucher.AmountDue)-Voucher.Payment_CC) end as AmountDue,   
case when Voucher.debtorf=1 then Voucher.Payment_CC else -Voucher.Payment_CC end as Payment,   
case when Voucher.debtorf=1 then Voucher.Nominal_CC-Voucher.Diff_CC - Voucher.Payment_CC else -(Voucher.Nominal_CC-Voucher.Diff_CC - Voucher.Payment_CC) end as Outstanding,   
Voucher.Installment,   
Voucher.DueDate_1, case when Voucher.debtorf=1 then Voucher.AmountDue_1 else -Voucher.AmountDue_1 end AmountDue_1,   
Voucher.DueDate_2, case when Voucher.debtorf=1 then Voucher.AmountDue_2 else -Voucher.AmountDue_2 end AmountDue_2,   
Voucher.DueDate_3, case when Voucher.debtorf=1 then Voucher.AmountDue_3 else -Voucher.AmountDue_3 end AmountDue_3,   
Voucher.DueDate_4, case when Voucher.debtorf=1 then Voucher.AmountDue_4 else -Voucher.AmountDue_4 end AmountDue_4,   
Voucher.DueDate_5, case when Voucher.debtorf=1 then Voucher.AmountDue_5 else -Voucher.AmountDue_5 end AmountDue_5,   
Voucher.DueDate_6, case when Voucher.debtorf=1 then Voucher.AmountDue_6 else -Voucher.AmountDue_6 end AmountDue_6,   
Voucher.DueDate_7, case when Voucher.debtorf=1 then Voucher.AmountDue_7 else -Voucher.AmountDue_7 end AmountDue_7,   
Voucher.DueDate_8, case when Voucher.debtorf=1 then Voucher.AmountDue_8 else -Voucher.AmountDue_8 end AmountDue_8,   
Voucher.DueDate_9, case when Voucher.debtorf=1 then Voucher.AmountDue_9 else -Voucher.AmountDue_9 end AmountDue_9,   
Voucher.DueDate_10, case when Voucher.debtorf=1 then Voucher.AmountDue_10 else -Voucher.AmountDue_10 end AmountDue_10,   
Voucher.DueDate_11, case when Voucher.debtorf=1 then Voucher.AmountDue_11 else -Voucher.AmountDue_11 end AmountDue_11,   
Voucher.DueDate_12, case when Voucher.debtorf=1 then Voucher.AmountDue_12 else -Voucher.AmountDue_12 end AmountDue_12,   
Voucher.DueDate_13, case when Voucher.debtorf=1 then Voucher.AmountDue_13 else -Voucher.AmountDue_13 end AmountDue_13,   
Voucher.DueDate_14, case when Voucher.debtorf=1 then Voucher.AmountDue_14 else -Voucher.AmountDue_14 end AmountDue_14,   
Voucher.DueDate_15, case when Voucher.debtorf=1 then Voucher.AmountDue_15 else -Voucher.AmountDue_15 end AmountDue_15,   
Voucher.DueDate_16, case when Voucher.debtorf=1 then Voucher.AmountDue_16 else -Voucher.AmountDue_16 end AmountDue_16,   
Voucher.DueDate_17, case when Voucher.debtorf=1 then Voucher.AmountDue_17 else -Voucher.AmountDue_17 end AmountDue_17,   
Voucher.DueDate_18, case when Voucher.debtorf=1 then Voucher.AmountDue_18 else -Voucher.AmountDue_18 end AmountDue_18,   
Voucher.DueDate_19, case when Voucher.debtorf=1 then Voucher.AmountDue_19 else -Voucher.AmountDue_19 end AmountDue_19,   
Voucher.DueDate_20, case when Voucher.debtorf=1 then Voucher.AmountDue_20 else -Voucher.AmountDue_20 end AmountDue_20,   
Voucher.DueDate_21, case when Voucher.debtorf=1 then Voucher.AmountDue_21 else -Voucher.AmountDue_21 end AmountDue_21,   
Voucher.DueDate_22, case when Voucher.debtorf=1 then Voucher.AmountDue_22 else -Voucher.AmountDue_22 end AmountDue_22,   
Voucher.DueDate_23, case when Voucher.debtorf=1 then Voucher.AmountDue_23 else -Voucher.AmountDue_23 end AmountDue_23,   
Voucher.DueDate_24, case when Voucher.debtorf=1 then Voucher.AmountDue_24 else -Voucher.AmountDue_24 end AmountDue_24   
from nVoucher Voucher Inner Join Voucher_AmountDue(@P_Date) Voucher_Due on (Voucher_Due.Voucher=Voucher.Voucher), Profile, ProAcc, Admlink   
Where Profile.ID=ProAcc.ID and ProAcc.ProAcc=Voucher.ProAcc and Admlink.Voucher=Voucher.Voucher   
and Admlink.Subject='Premium' and Admlink.Type in ('DI','IC','IR') and Admlink.A_PolicyNo<>'' and Admlink.A_PolicyNo=@P_A_PolicyNo and (Admlink.Extra_1='' or Admlink.Extra_1 is null)   
End   
   

go



Declare @PrevScript varchar(100)
Declare @CurrScript varchar(100)

Select @PrevScript='06 Script Komulatif Konsol 1.4'
Select @CurrSCript='07 Script Komulatif Konsol 1.5'


Declare @ExecScript varchar(100)
Declare @ExecScriptStatus varchar(100)
Declare @Error varchar(200)

Select @Error=''

Begin 
       Select @ExecScript=Execscript,  @ExecScriptStatus=ExecScriptStatus from systab 
       if @PrevScript<>'' and @ExecSCript<>@PrevScript
              THROW 51000, 'Not the Next Sequence Script', 1;
       else 
              if @ExecScriptStatus<>'' and @ExecScriptStatus<>'DONE'
              THROW 51000, 'Pending Script Execution', 1;

       Update SysTab Set ExecScript=@CurrScript, ExecScriptStatus='PENDING'             
       
       BEGIN TRY            
			PRINT '--EXECUTE DONE--'
       END TRY  
       BEGIN CATCH  
       END CATCH;


       Update SysTab Set ExecScript=@CurrScript, ExecScriptStatus='DONE'         
End


