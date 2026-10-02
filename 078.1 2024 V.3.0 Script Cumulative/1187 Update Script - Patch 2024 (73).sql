DROP procedure PI08
GO
CREATE procedure PI08(@P_ANO as integer)     
as     
Begin     
Declare @P_PDate as smalldatetime     
Declare @A_PolicyNo varchar(50)

Select @P_PDate = cast(convert(varchar(10), getdate(),1) as smalldatetime)     
     
Select 
@A_PolicyNo=
Case 
When A.LANO<>-1 then
	Case
	When A.ANO<>A.LANO and ((C.OpenFlag=1 and A.BulkF=0) or (C.OpenFlag=0 and A.RefNo<>mA.RefNo)) then
		A.PolicyNo+'-'+A.CertificateNo
	else
		A.PolicyNo
	end
Else
	A.PolicyNo
end
from Acceptance A
Left join Acceptance mA on (mA.ANO=A.LANO)
Inner Join Cover C on (C.CNO=A.CNO)
Where A.ANO=@P_ANO     

Select Distinct Voucher.Voucher, Voucher.DueDate, Voucher.DocNo, Voucher_Due.DueDate as NDueDate, Profile.Name, Voucher.Currency,     
Policy.RefType,    
Policy.AccountNo, Policy.Bank, Policy.BankName,     
Policy.AccountNo_Ext, Policy.Bank_Ext, Policy.BankName_Ext,     
case when Voucher.debtorf=1 then Voucher.Nominal_CC-Voucher.Diff_CC else -(Voucher.Nominal_CC-Voucher.Diff_CC) end  as Nominal,     
case when Voucher.debtorf=1 then (Case When coalesce(Voucher_Due.AmountDue, Voucher.AmountDue)-Voucher.Payment_CC<0 Then 0 else coalesce(Voucher_Due.AmountDue, Voucher.AmountDue)-Voucher.Payment_CC End) else -(Case When coalesce(Voucher_Due.AmountDue, Voucher.AmountDue)-Voucher.Payment_CC<0 Then 0 else coalesce(Voucher_Due.AmountDue, Voucher.AmountDue)-Voucher.Payment_CC End) end as AmountDue,     
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
from 
(
	Select Distinct Admlink.Voucher, Admlink.RefType, Admlink.AccountNo, Admlink.Bank, Admlink.BankName, Admlink.AccountNo_Ext, Admlink.Bank_Ext, Admlink.BankName_Ext
	from Admlink
	Where Admlink.A_policyNo=@A_Policyno and Admlink.Subject='Premium' and Admlink.Type in ('DI','IR','IT','IX','IC','OP') 
) Policy
Inner join nVoucher Voucher on (Voucher.Voucher=Policy.Voucher)
Inner Join Voucher_AmountDue(@P_PDate) Voucher_Due on (Voucher_Due.Voucher=Voucher.Voucher)  
Inner Join ProAcc on (ProAcc.ProAcc=Voucher.ProAcc)  
Inner Join Profile on (Profile.ID=ProAcc.ID)  
End     
     
  
GO

DROP procedure PI09
GO
CREATE procedure PI09(@P_ANO as integer)     
as     
Begin     
Declare @P_PDate as smalldatetime     
Declare @A_PolicyNo varchar(50)

Select @P_PDate = cast(convert(varchar(10), getdate(),1) as smalldatetime)     
     
Select 
@A_PolicyNo=
Case 
When A.LANO<>-1 then
	Case
	When A.ANO<>A.LANO and ((C.OpenFlag=1 and A.BulkF=0) or (C.OpenFlag=0 and A.RefNo<>mA.RefNo)) then
		A.PolicyNo+'-'+A.CertificateNo
	else
		A.PolicyNo
	end
Else
	A.PolicyNo
end
from Acceptance A
Left join Acceptance mA on (mA.ANO=A.LANO)
Inner Join Cover C on (C.CNO=A.CNO)
Where A.ANO=@P_ANO     

Select Voucher.Voucher, Voucher.DueDate, Voucher.DocNo, Profile.Name, Voucher.Currency,   
case when Voucher.debtorf=1 then Voucher.Nominal_CC-Voucher.Diff_CC else -(Voucher.Nominal_CC-Voucher.Diff_CC) end  as Nominal,     
case when Voucher.debtorf=1 then (Case When coalesce(Voucher_Due.AmountDue, Voucher.AmountDue)-Voucher.Payment_CC<0 Then 0 else coalesce(Voucher_Due.AmountDue, Voucher.AmountDue)-Voucher.Payment_CC End) else -(Case When coalesce(Voucher_Due.AmountDue, Voucher.AmountDue)-Voucher.Payment_CC<0 Then 0 else coalesce(Voucher_Due.AmountDue, Voucher.AmountDue)-Voucher.Payment_CC End) end as AmountDue,     
case when Voucher.debtorf=1 then Voucher.Payment_CC else -Voucher.Payment_CC end as Payment,     
case when Voucher.debtorf=1 then Voucher.Nominal_CC-Voucher.Diff_CC - Voucher.Payment_CC else -(Voucher.Nominal_CC-Voucher.Diff_CC - Voucher.Payment_CC) end as Outstanding  
from 
(
	Select Distinct Admlink.Voucher, Admlink.DocNo
	from Admlink
	Where Admlink.A_policyNo=@A_Policyno and Admlink.Subject='Claim' and Admlink.Type in ('DI','IR','IT','IX','IC','OP') 
) Claim
Inner join nVoucher Voucher on (Voucher.Voucher=Claim.Voucher)
Inner Join Voucher_AmountDue(@P_PDate) Voucher_Due on (Voucher_Due.Voucher=Voucher.Voucher)  
Inner Join ProAcc on (ProAcc.ProAcc=Voucher.ProAcc)  
Inner Join Profile on (Profile.ID=ProAcc.ID)  
End

GO
DROP PROCEDURE PI11_P 
GO
CREATE PROCEDURE PI11_P (@P_ANO as integer)
AS

Declare @A_PolicyNo varchar(50)

Select 
@A_PolicyNo=
Case 
When A.LANO<>-1 then
	Case
	When A.ANO<>A.LANO and ((C.OpenFlag=1 and A.BulkF=0) or (C.OpenFlag=0 and A.RefNo<>mA.RefNo)) then
		A.PolicyNo+'-'+A.CertificateNo
	else
		A.PolicyNo
	end
Else
	A.PolicyNo
end
from Acceptance A
Left join Acceptance mA on (mA.ANO=A.LANO)
Inner Join Cover C on (C.CNO=A.CNO)
Where A.ANO=@P_ANO


Select
coalesce(pVoucher.Voucher, Voucher.Voucher) as Voucher,
coalesce(pVoucher.Date, Voucher.Date) as Date,
coalesce(pVoucher.RefDate, Voucher.RefDate) as RefDate,
Policy.DocNo, ProAcc.Description as Name, SL.Doc_No, SL.Doc_CCY, 
Case When nVoucher.DebtorF=1 Then 1 else -1 end*dbo.fn_SL_Payment_Nominal(SL.Nominal_OC, pVoucher.SL_Cat, pVoucher.DebtorF, nVoucher.DebtorF) as Nominal_OC
from 
(
	Select Distinct Admlink.Voucher, Admlink.DocNo
	from Admlink
	Where Admlink.A_policyNo=@A_Policyno and Admlink.Subject='Premium' and Admlink.Type in ('DI','IR','IT','IX','IC','OP') 
) Policy
Inner join nVoucher on (nVoucher.Voucher=Policy.Voucher)
Inner Join pSL SL on (SL.Doc_No=nVoucher.Voucher and SL.PaymentF=1)
Inner Join pVoucher Voucher on (Voucher.Voucher=SL.Voucher)     
Left Join pVoucher pVoucher on (pVoucher.Voucher=Voucher.RefNo and Voucher.SL_Cat='B' and Voucher.RefType='INTEROFFICE' and pvoucher.SL_Cat='P')
Inner Join ProAcc on (ProAcc.ProAcc=Voucher.ProAcc)


GO

DROP PROCEDURE PI11_C 
GO
CREATE PROCEDURE PI11_C (@P_ANO as integer)  
AS  
Declare @A_PolicyNo varchar(50)

Select 
@A_PolicyNo=
Case 
When A.LANO<>-1 then
	Case
	When A.ANO<>A.LANO and ((C.OpenFlag=1 and A.BulkF=0) or (C.OpenFlag=0 and A.RefNo<>mA.RefNo)) then
		A.PolicyNo+'-'+A.CertificateNo
	else
		A.PolicyNo
	end
Else
	A.PolicyNo
end
from Acceptance A
Left join Acceptance mA on (mA.ANO=A.LANO)
Inner Join Cover C on (C.CNO=A.CNO)
Where A.ANO=@P_ANO

Select   
coalesce(pVoucher.Voucher, Voucher.Voucher) as Voucher,  
coalesce(pVoucher.Date, Voucher.Date) as Date,  
coalesce(pVoucher.RefDate, Voucher.RefDate) as RefDate,  
Claim.DocNo, ProAcc.Description as Name, SL.Doc_No, SL.Doc_CCY,   
Case When nVoucher.DebtorF=1 Then 1 else -1 end*dbo.fn_SL_Payment_Nominal(SL.Nominal_OC, pVoucher.SL_Cat, pVoucher.DebtorF, nVoucher.DebtorF) as Nominal_OC  
from   
(
	Select Distinct Admlink.Voucher, Admlink.DocNo
	from Admlink
	Where Admlink.A_policyNo=@A_Policyno and Admlink.Subject='Claim' and Admlink.Type in ('DI','IR','IT','IX','IC','OP') 
) Claim
Inner join nVoucher on (nVoucher.Voucher=Claim.Voucher)  
Inner Join pSL SL on (SL.Doc_No=nVoucher.Voucher and SL.PaymentF=1)  
Inner Join pVoucher Voucher on (Voucher.Voucher=SL.Voucher)       
Left Join pVoucher pVoucher on (pVoucher.Voucher=Voucher.RefNo and Voucher.SL_Cat='B' and Voucher.RefType='INTEROFFICE' and pvoucher.SL_Cat='P')  
Inner Join ProAcc on (ProAcc.ProAcc=Voucher.ProAcc)  

GO

DROP procedure PI13
GO
CREATE procedure PI13(@P_ANO as integer)   
as   
Begin   
Declare @P_PDate as smalldatetime     
Declare @A_PolicyNo varchar(50)

Select @P_PDate = cast(convert(varchar(10), getdate(),1) as smalldatetime)     
     
Select 
@A_PolicyNo=
Case 
When A.LANO<>-1 then
	Case
	When A.ANO<>A.LANO and ((C.OpenFlag=1 and A.BulkF=0) or (C.OpenFlag=0 and A.RefNo<>mA.RefNo)) then
		A.PolicyNo+'-'+A.CertificateNo
	else
		A.PolicyNo
	end
Else
	A.PolicyNo
end
from Acceptance A
Left join Acceptance mA on (mA.ANO=A.LANO)
Inner Join Cover C on (C.CNO=A.CNO)
Where A.ANO=@P_ANO     
   
Select Policy.Subject, Voucher.Voucher, Voucher.DueDate, Voucher.DocNo, Voucher_Due.DueDate as NDueDate,   
Profile.Name, Voucher.Currency, Policy.RefType, Policy.BankName, Policy.AccountNo,   
case when Voucher.debtorf=1 then Voucher.Nominal_CC-Voucher.Diff_CC else -(Voucher.Nominal_CC-Voucher.Diff_CC) end  as Nominal,   
case when Voucher.debtorf=1 then (coalesce(Voucher_Due.AmountDue, Voucher.AmountDue)-Voucher.Payment_CC) else -(coalesce(Voucher_Due.AmountDue, Voucher.AmountDue)-Voucher.Payment_CC) end as AmountDue,   
case when Voucher.debtorf=1 then Voucher.Payment_CC else -Voucher.Payment_CC end as Payment,   
case when Voucher.debtorf=1 then Voucher.Nominal_CC-Voucher.Diff_CC - Voucher.Payment_CC else -(Voucher.Nominal_CC-Voucher.Diff_CC - Voucher.Payment_CC) end as Outstanding    
from 
(
	Select Distinct Admlink.Voucher, Admlink.Subject, Admlink.RefType, Admlink.AccountNo, Admlink.Bank, Admlink.BankName, Admlink.AccountNo_Ext, Admlink.Bank_Ext, Admlink.BankName_Ext
	from Admlink
	Where Admlink.A_policyNo=@A_Policyno and Admlink.Type in ('DI','IC','IR','IT','IX','CF','JP','BB','BA','BO','BC','BP','BD','OP','FO') 
) Policy
Inner join nVoucher Voucher on (Voucher.Voucher=Policy.Voucher)
Left Join Voucher_AmountDue(@P_PDate) Voucher_Due on (Voucher_Due.Voucher=Voucher.Voucher)  
Inner Join ProAcc on (ProAcc.ProAcc=Voucher.ProAcc)  
Inner Join Profile on (Profile.ID=ProAcc.ID)  
   
end   
   
GO

DROP PROCEDURE QPREMIUMAMOUNT 
GO
CREATE PROCEDURE QPREMIUMAMOUNT (@P_ANO AS INTEGER,@P_PDate as smalldatetime)                        
  
AS                       
  
Declare @P_APolicyNo as varchar(50)          
Declare @P_WPC as int    
Declare @P_BillDate as smalldatetime    
Declare @P_BackdatedF as bit  
Declare @P_Grace as Int  
  
Select   
@P_APolicyNo=
Case 
When A.LANO<>-1 then
	Case
	When A.ANO<>A.LANO and ((C.OpenFlag=1 and A.BulkF=0) or (C.OpenFlag=0 and A.RefNo<>mA.RefNo)) then
		A.PolicyNo+'-'+A.CertificateNo
	else
		A.PolicyNo
	end
Else
	A.PolicyNo
end,
@P_WPC=coalesce(APayor.WPC, coalesce(MPayor.WPC, Payor.WPC)),    
@P_Grace=coalesce(APayor.Grace, coalesce(MPayor.Grace, Payor.Grace)),  
@P_BillDate= dateadd(day,coalesce(APayor.Grace, coalesce(MPayor.Grace, Payor.Grace)),  
Case     
When A.AType='A' Then A.ADate     
else     
 Case When C.OpenFlag=0 Then     
  Case When SysTab.DueByEffectiveF=0 Then coalesce(mA.ADate,A.ADate) else coalesce(mA.PDate,A.PDate) end    
 else    
  Case When SysTab.DueByEffectiveF=0 Then A.ADate else A.PDate end    
 end    
end)  
,    
@P_BackdatedF=A.BackDatedF  
from Acceptance A
Inner Join Cover C on (C.CNO=A.CNO)  
Left Join Acceptance mA on (mA.ANO=A.LANO)    
Left Join APayor on (APayor.ANO=A.ANO)    
Left Join Payor on (Payor.ANO=A.ANO)  
Left Join Payor MPayor on (MPayor.ANO=mA.ANO)  
Inner Join SysTab on (1=1)    
Where A.ANO=@P_ANO   
  
Select             
@P_BackdatedF as BackdatedF,  
sum(Voucher.PremiumAmount) as PremiumAmount,            
sum(Voucher.PremiumDue) as PremiumDue,     
Min(Voucher.DueDate) as DueDate,        
coalesce(datediff(day,Min(Voucher.DueDate),@P_PDate),0) as Lapse,  
sum(Voucher.PremiumPaid) as PremiumPaid,            
sum(Voucher.PremiumOutstanding) as PremiumOutstanding,            
@P_WPC as WPC,    
@P_Grace as Grace,  
@P_BillDate as BillDate,    
Min(Voucher.PDate) as Date            
From            
(             
 SELECT                        
 DISTINCT    
 nVoucher.Voucher,    
 CASE WHEN nVoucher.DEBTORF=1 THEN (Case When Voucher_Due.Voucher is null then nVoucher.Nominal_CC-nVoucher.Diff_CC else Voucher_Due.AmountDue end) ELSE -(Case When Voucher_Due.Voucher is null then nVoucher.Nominal_CC-nVoucher.Diff_CC else Voucher_Due.AmountDue end) END*nVoucher.RATE as PremiumAmount,                         
 CASE WHEN nVoucher.DEBTORF=1 THEN (CASE WHEN coalesce(Voucher_Due.AmountDue,0)-nVoucher.Payment_CC<0 Then 0 Else coalesce(Voucher_Due.AmountDue,0)-nVoucher.Payment_CC End) ELSE -(CASE WHEN coalesce(Voucher_Due.AmountDue,0)-nVoucher.Payment_CC<0 Then 0 Else coalesce(Voucher_Due.AmountDue,0)-nVoucher.Payment_CC End) END*nVoucher.RATE as PremiumDue,                        
 Case When Round(nVoucher.Payment_CC,2)<round((Case When Voucher_Due.Voucher is null then nVoucher.Nominal_CC-nVoucher.Diff_CC else Voucher_Due.AmountDue end),2) Then isnull(Voucher_Due.DueDate, nVoucher.DueDate) else Null end AS DUEDATE,                  
 CASE WHEN nVoucher.DEBTORF=1 THEN nVoucher.Nominal_CC-nVOucher.Diff_CC-nVoucher.PAYMENT_CC ELSE -(nVoucher.Nominal_CC-nVOucher.Diff_CC-nVoucher.PAYMENT_CC) END*nVoucher.RATE as PremiumOutstanding,     
 CASE WHEN nVoucher.DEBTORF=1 THEN nVoucher.PAYMENT_CC ELSE -nVoucher.PAYMENT_CC END*nVoucher.RATE as PremiumPaid,                        
 Payment.PDate                  
 FROM (
	Select Distinct Admlink.Voucher
	from Admlink
	Where Admlink.A_policyNo=@P_APolicyNo and Admlink.Subject='Premium' and Admlink.Type in ('DI','IC','IR','IT','IX') 
 ) Admlink
 Inner Join nVoucher on (nVoucher.Voucher=Admlink.Voucher)     
 Left Join Voucher_AmountWPCDue(@P_PDate) Voucher_Due on (Voucher_Due.Voucher=nVoucher.Voucher)     
 Outer Apply (  
  Select Max(coalesce(pVoucher.RefDate, coalesce(OVoucher.RefDate, Voucher.RefDate))) as PDate  
  from pSL   
  Inner Join pVoucher Voucher on (Voucher.Voucher=pSL.Voucher)       
  Left Join pVoucher oVoucher on (oVoucher.Voucher=Voucher.RefNo and Voucher.SL_Cat in ('A','B') and oVoucher.SL_Cat in ('P','B'))       
  Left Join pVoucher pVoucher on (pVoucher.Voucher=oVoucher.RefNo and oVoucher.SL_Cat='B' and pvoucher.SL_Cat='P')  
  Where pSL.PaymentF=1 and pSL.Doc_No=nVoucher.Voucher      
 ) Payment  
) Voucher   
  
GO

DROP PROCEDURE QCLAIMAMOUNT
GO
CREATE PROCEDURE QCLAIMAMOUNT (@P_CNO AS INTEGER,@P_PDate as smalldatetime)   
AS   

Declare @P_APolicyNo as varchar(50)    
Select 
@P_APolicyNo=
Case 
When A.LANO<>-1 then
	Case
	When A.ANO<>A.LANO and ((C.OpenFlag=1 and A.BulkF=0) or (C.OpenFlag=0 and A.RefNo<>mA.RefNo)) then
		A.PolicyNo+'-'+A.CertificateNo
	else
		A.PolicyNo
	end
Else
	A.PolicyNo
end
from Claim
Inner Join Acceptance A on (A.ANO=Claim.ANO)
Left join Acceptance mA on (mA.ANO=A.LANO)
Inner Join Cover C on (C.CNO=A.CNO)
Where Claim.CNO=@P_CNO

SELECT   
Admlink.A_PolicyNo,  
sum(CASE WHEN nVoucher.DEBTORF=1 THEN (Case When coalesce(Voucher_Due.AmountDue,0)=0 then nVoucher.Nominal_CC-nVoucher.Diff_CC else Voucher_Due.AmountDue end) ELSE -(Case When Voucher_Due.Voucher is null then nVoucher.Nominal_CC-nVoucher.Diff_CC else Voucher_Due.AmountDue end) END*nVoucher.RATE) as ClaimAmount,   
MIN(Case When Round(nVoucher.Payment_CC,2)<round((Case When Voucher_Due.Voucher is null then nVoucher.Nominal_CC-nVoucher.Diff_CC else Voucher_Due.AmountDue end),2) Then isnull(Voucher_Due.DueDate, nVoucher.DueDate) else Null end) AS DUEDATE,   
sum(CASE WHEN nVoucher.DEBTORF=1 THEN nVoucher.PAYMENT_CC ELSE -nVoucher.PAYMENT_CC END*nVoucher.RATE) as ClaimPaid,   
MAX(Case When nVoucher.Payment_CC<>0 then nVoucher.PDATE else Null end) AS DATE,   
MAX(Admlink.WPC) As WPC   
FROM  (
	Select Distinct Admlink.Voucher, Admlink.WPC, Admlink.A_PolicyNo
	from Admlink
	Where Admlink.A_policyNo=@P_APolicyNo and Admlink.Subject='Claim' and Admlink.Type in ('DI','IC','IR','OP') 
 ) Admlink
Inner Join nVoucher on (nVoucher.Voucher=Admlink.Voucher)
Left Join Voucher_AmountDue(@P_PDate) Voucher_Due on (Voucher_Due.Voucher=nVoucher.Voucher)  
Group By Admlink.A_PolicyNo  
   
   

go



  insert into PatchVersioning
select '1187 Update Script - Patch 2024 (73)',GETDATE()
go	
  
Declare @PrevScript varchar(100)
Declare @CurrScript varchar(100)

Select @PrevScript=''
Select @CurrSCript='1187 Update Script - Patch 2024 (73)'


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




go	

