DROP function ListQry_3b 
GO
CREATE function ListQry_3b (            
@Value1 as varchar(255), @Value2 as varchar(255), @Value3 as varchar(255), @Value4 as varchar(255), @Value5 as varchar(255),             
@Value6 varchar(255), @Value7 as varchar(255), @Value8 as varchar(255), @Value9 as varchar(255), @Value10 as varchar(255),            
@Value11 as varchar(255),@Value12 as varchar(255), @Value13 as varchar(255),@Value14 as varchar(255),@Value15 as varchar(255),            
@Value16 as varchar(255),@Value17 as varchar(255),@Value18 as varchar(255),@Value19 as varchar(255),@Value20 as varchar(255),@Value21 as varchar(255), @Value22 as varchar(255), @Value23 as varchar(255), @Value24 as varchar(255)            
)                  
RETURNS Table                  
AS RETURN                  
(                  
SELECT       
 Cover.COVERNO,                  
 Cast(Acceptance.AName as varchar(128)) as Insured,                  
 Cover.CNO,                  
 Cover.CStatus,                  
 Acceptance.lANO,                  
 Acceptance.ANO,                  
 Acceptance.REGNO,                  
 Acceptance.ADATE,                  
 Acceptance.LUSERID as USERID,                  
 SysTab.Currency,                  
 Acceptance.ASTATUS,                  
 Acceptance.ATYPE,                  
 Acceptance.SDate,                  
 Acceptance.EDate,                  
 Year(Coalesce(RArrHeader.RDate,Acceptance.SDate)) AS RYear,                  
 Cover.ISType,                  
 Acceptance.Renewal,                  
 Acceptance.ESeqNo,                  
 Acceptance.PolicyNo,                  
 Acceptance.CertificateNo,                  
 Acceptance.RefNo,                  
 cover.ProformaF    
FROM  Acceptance
Inner Join Cover on (Cover.CNO=Acceptance.CNO)
Left Join RArrHeader on (RArrHeader.ANO=Acceptance.ANO)
Inner Join Profile on (Profile.ID=Cover.PHolder), systab    
Where (@Value1='%' or Acceptance.AName Like @Value1)                
 And (@Value2='%' or Cover.CoverNo Like @Value2)                  
 and (Cover.CoverDate = @Value3 or @Value3='')                  
 And (Cover.ExpDate = @Value4 or @Value4='')                  
 And (@Value5='%' or Acceptance.PolicyNo Like @Value5)                  
 And (@Value6='%' or Acceptance.CertificateNo Like @Value6)                  
 And (Acceptance.PolicyDate = @Value7 or @Value7='' or Acceptance.PolicyDate Between @Value7 and @Value16)                  
 And (Acceptance.RegDate = @Value17 or @Value17='' or Acceptance.RegDate Between @Value17 and @Value18)                  
 And Acceptance.AType Like @Value8                  
 And Acceptance.AStatus Like @Value9                  
 And (@Value10='%' or Acceptance.RegNo Like @Value10)    
 And (@Value11='%' or Profile.Name Like @Value11)    
 and (@Value12='%' or Acceptance.toc like @Value12)    
 and (@Value13='%' or Acceptance.RefNo like @Value13)                  
 and (acceptance.ano = acceptance.lano or acceptance.lano = -1)                  
 and (Acceptance.Matters=@Value14 or @Value14='')                  
 And (Cover.ISType<>'T' or Cover.ProformaF=1 or Acceptance.LANO=-1)                  
 And (Acceptance.BatchNo Like @Value19)             
 And ((Acceptance.BackDatedF=1 and @Value20='1') or @Value20='')            
 And (@Value21<>'1' or (@Value21='1' and Exists (Select CAcceptance.CANO from Acceptance CAcceptance Where CAcceptance.CANO=Acceptance.ANO)))              
 And ((Cover.TBAF=1 and @Value22='1') or @Value22='')            
 And (@Value23<>'1' or (@Value23='1' and Not Exists (Select Top 1 ANO from PPrintLog Where PPrintLog.ANO=Acceptance.ANO)))               
 And (@Value24='%' or Acceptance.ASource Like @Value24)
             
 Union All
             
 SELECT       
 CCover.COVERNO,                  
 Cast(CAcceptance.AName as varchar(128)) as Insured,                  
 CCover.CNO,                  
 CCover.CStatus,                  
 CAcceptance.lANO,                  
 CAcceptance.ANO,     
 CAcceptance.REGNO,                  
 CAcceptance.ADATE,                  
 CAcceptance.LUSERID as USERID,                  
 SysTab.Currency,                  
 CAcceptance.ASTATUS,       
 CAcceptance.ATYPE,                  
 CAcceptance.SDate,                  
 CAcceptance.EDate,                  
 Year(Coalesce(CRArrHeader.RDate,CAcceptance.SDate)) AS RYear,                  
 CCover.ISType,                  
 CAcceptance.Renewal,                  
 CAcceptance.ESeqNo,                  
 CAcceptance.PolicyNo,                  
 CAcceptance.CertificateNo,                  
 CAcceptance.RefNo,              
 Ccover.ProformaF    
FROM  Acceptance
Inner Join Cover on (Cover.CNO=Acceptance.CNO)
Inner Join Acceptance CAcceptance on (CAcceptance.CANO=Acceptance.ANO)
Inner Join Cover CCover on (CCOver.CNO=CAcceptance.CNO)
left Join RArrHeader CRArrHeader on (CRArrHeader.ANO=CAcceptance.ANO)     
Inner Join Profile on (Profile.ID=Cover.PHolder), SysTab
Where @Value21='1' 
 And (@Value1='%' or Acceptance.AName Like @Value1)                
 And (@Value2='%' or Cover.CoverNo Like @Value2)                  
 and (Cover.CoverDate = @Value3 or @Value3='')                  
 And (Cover.ExpDate = @Value4 or @Value4='')                  
 And (@Value5='%' or Acceptance.PolicyNo Like @Value5)                  
 And (@Value6='%' or Acceptance.CertificateNo Like @Value6)                  
 And (Acceptance.PolicyDate = @Value7 or @Value7='' or Acceptance.PolicyDate Between @Value7 and @Value16)                  
 And (Acceptance.RegDate = @Value17 or @Value17='' or Acceptance.RegDate Between @Value17 and @Value18)                  
 And Acceptance.AType Like @Value8                  
 And Acceptance.AStatus Like @Value9                  
 And (@Value10='%' or Acceptance.RegNo Like @Value10)    
 And (@Value11='%' or Profile.Name Like @Value11)    
 and (@Value12='%' or Acceptance.toc like @Value12)    
 and (@Value13='%' or Acceptance.RefNo like @Value13)                  
 and (acceptance.ano = acceptance.lano or acceptance.lano = -1)                  
 and (Acceptance.Matters=@Value14 or @Value14='')                  
 And (Cover.ISType<>'T' or Cover.ProformaF=1 or Acceptance.LANO=-1)                  
 And (Acceptance.BatchNo Like @Value19)             
 And ((Acceptance.BackDatedF=1 and @Value20='1') or @Value20='')            
 And ((Cover.TBAF=1 and @Value22='1') or @Value22='')            
 And (@Value23<>'1' or (@Value23='1' and Not Exists (Select Top 1 ANO from PPrintLog Where PPrintLog.ANO=Acceptance.ANO)))              
 And (@Value24='%' or Acceptance.ASource Like @Value24)
)


GO

DROP PROCEDURE QPREMIUMAMOUNT 
GO
CREATE PROCEDURE QPREMIUMAMOUNT (@P_ANO AS INTEGER,@P_PDate as smalldatetime)                      

AS                     

Declare @P_APolicyNo as varchar(50)        
Declare @P_OANO int
Declare @P_MOANO int
Declare @P_LANO int
Declare @P_WPC as int  
Declare @P_BillDate as smalldatetime  
Declare @P_MinAdmNo as int
Declare @P_MaxAdmNo as int
Declare @P_BackdatedF as bit
Declare @P_Grace as Int

Select 
@P_APolicyNo=Case When Cover.OpenFlag=1 and Acceptance.BulkF=0 Then Acceptance.PolicyNo+Case When Acceptance.CertificateNo<>'' Then '-'+Acceptance.CertificateNo else '' end else Acceptance.PolicyNo end,  
@P_OANO=Acceptance.OANO,
@P_LANO=Acceptance.LANO,
@P_MOANO=MAcceptance.OANO,
@P_WPC=coalesce(APayor.WPC, Payor.WPC),  
@P_Grace=coalesce(APayor.Grace, Payor.Grace),
@P_BillDate=  
dateadd(day,coalesce(APayor.Grace, Payor.Grace),
Case   
When Acceptance.AType='A' Then Acceptance.ADate   
else   
 Case When Cover.OpenFlag=0 Then   
  Case When SysTab.DueByEffectiveF=0 Then coalesce(mAcceptance.ADate,Acceptance.ADate) else coalesce(mAcceptance.PDate,Acceptance.PDate) end  
 else  
  Case When SysTab.DueByEffectiveF=0 Then Acceptance.ADate else Acceptance.PDate end  
 end  
end)
,  
@P_BackdatedF=Acceptance.BackDatedF
from Acceptance
Inner Join Cover on (Cover.CNO=Acceptance.CNO)
Left Join Acceptance mAcceptance on (mAcceptance.ANO=mAcceptance.LANO and mAcceptance.ANO=Acceptance.LANO)  
Left Join APayor on (APayor.ANO=Acceptance.ANO)  
Left Join Payor on (Payor.ANO=coalesce(mAcceptance.ANO, Acceptance.ANO))  
Inner Join SysTab on (1=1)  
Where Acceptance.ANO=@P_ANO 


if @P_ANO<>@P_LANO
	Select   
	@P_MinAdmNo=coalesce(Min(Admlink.AdmNo),0),
	@P_MaxAdmNo=coalesce(Max(Admlink.AdmNo),0)
	from Admlink
	Inner Join AccAss on (AccAss.AdmNo=Admlink.AdmNo)
	Inner Join Acceptance on (Acceptance.ANO=AccAss.ANO)
	Inner Join Acceptance oAcceptance on (oAcceptance.oANO=Acceptance.oANO)
	Where OAcceptance.OANO=@P_OANO and Admlink.A_PolicyNo=@P_APolicyNo and Admlink.Subject='Premium' and Admlink.Type in ('DI','IC','IR') and Admlink.Date<=@P_PDate
else
	Select   
	@P_MinAdmNo=coalesce(Min(Admlink.AdmNo),0),
	@P_MaxAdmNo=coalesce(Max(Admlink.AdmNo),0)
	from Admlink
	Inner Join AccAss on (AccAss.AdmNo=Admlink.AdmNo)
	Inner Join Acceptance on (Acceptance.ANO=AccAss.ANO)
	Inner Join Acceptance oAcceptance on (oAcceptance.oANO=Acceptance.oANO)
	Inner Join Acceptance mAcceptance on (mAcceptance.ANO=oAcceptance.LANO)
	Where mAcceptance.OANO=@P_MOANO and Admlink.A_PolicyNo=@P_APolicyNo and Admlink.Subject='Premium' and Admlink.Type in ('DI','IC','IR') and Admlink.Date<=@P_PDate
Select           
@P_BackdatedF as BackdatedF,
sum(Voucher.PremiumAmount) as PremiumAmount,          
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
	CASE WHEN nVoucher.DEBTORF=1 THEN (Case When coalesce(Voucher_Due.AmountDue,0)=0 then nVoucher.Nominal_CC-nVoucher.Diff_CC else Voucher_Due.AmountDue end) ELSE -(Case When Voucher_Due.Voucher is null then nVoucher.Nominal_CC-nVoucher.Diff_CC else Voucher_Due.AmountDue end) END*nVoucher.RATE as PremiumAmount,                      
	Case When Round(nVoucher.Payment_CC,2)<round((Case When Voucher_Due.Voucher is null then nVoucher.Nominal_CC-nVoucher.Diff_CC else Voucher_Due.AmountDue end),2) Then isnull(Voucher_Due.DueDate, nVoucher.DueDate) else Null end AS DUEDATE,                
	CASE WHEN nVoucher.DEBTORF=1 THEN nVoucher.Nominal_CC-nVOucher.Diff_CC-nVoucher.PAYMENT_CC ELSE -(nVoucher.Nominal_CC-nVOucher.Diff_CC-nVoucher.PAYMENT_CC) END*nVoucher.RATE as PremiumOutstanding,   
	CASE WHEN nVoucher.DEBTORF=1 THEN nVoucher.PAYMENT_CC ELSE -nVoucher.PAYMENT_CC END*nVoucher.RATE as PremiumPaid,                      
	(
	Select Max(coalesce(pVoucher.RefDate, coalesce(OVoucher.RefDate, Voucher.RefDate)))     
	from pSL 
	Inner Join pVoucher Voucher on (Voucher.Voucher=pSL.Voucher)     
	Left Join pVoucher oVoucher on (oVoucher.Voucher=Voucher.RefNo and Voucher.SL_Cat in ('A','B') and oVoucher.SL_Cat in ('P','B'))     
	Left Join pVoucher pVoucher on (pVoucher.Voucher=oVoucher.RefNo and oVoucher.SL_Cat='B' and pvoucher.SL_Cat='P')
	Where pSL.PaymentF=1 and pSL.Doc_No=nVoucher.Voucher    
	) as PDate                
	FROM Admlink 
	Inner Join nVoucher on (nVoucher.Voucher=Admlink.Voucher)   
	Left Join Voucher_AmountWPCDue(@P_PDate) Voucher_Due on (Voucher_Due.Voucher=nVoucher.Voucher)   
	Where Admlink.A_PolicyNo=@P_APolicyNo and Admlink.Subject='Premium' and Admlink.Type in ('DI','IC','IR','IT') and Admlink.Date<=@P_PDate
	and (@P_MinAdmNo=0 or Admlink.AdmNo>=@P_MinAdmNo)
	and (@P_MaxAdmno=0 or Admlink.AdmNo<=@P_MaxAdmNo)
) Voucher 



GO

DROP PROCEDURE PI11_C 
GO
CREATE PROCEDURE PI11_C (@P_ANO as integer)
AS
Select 
coalesce(pVoucher.Voucher, Voucher.Voucher) as Voucher,
coalesce(pVoucher.Date, Voucher.Date) as Date,
coalesce(pVoucher.RefDate, Voucher.RefDate) as RefDate,
Claim.DocNo, ProAcc.Description as Name, SL.Doc_No, SL.Doc_CCY, 
Case When nVoucher.DebtorF=1 Then 1 else -1 end*dbo.fn_SL_Payment_Nominal(SL.Nominal_OC, pVoucher.SL_Cat, pVoucher.DebtorF, nVoucher.DebtorF) as Nominal_OC
from (Select Distinct Admlink.DocNo, Admlink.Voucher, Admlink.Type from ClaAss, Admlink, Claim C1, Acceptance A1, Acceptance A2 Where Admlink.AdmNo=ClaAss.AdmNo and ClaAss.Type in ('DI','IR','IT','IC','OP') and ClaAss.CNO=C1.CNO and C1.ANO=A2.ANO and A2.OANO=A1.OANO and A1.ANO=@P_ANO) Claim
Inner join nVoucher on (nVoucher.Voucher=Claim.Voucher)
Inner Join pSL SL on (SL.Doc_No=nVoucher.Voucher and SL.PaymentF=1)
Inner Join pVoucher Voucher on (Voucher.Voucher=SL.Voucher)     
Left Join pVoucher pVoucher on (pVoucher.Voucher=Voucher.RefNo and Voucher.SL_Cat='B' and Voucher.RefType='INTEROFFICE' and pvoucher.SL_Cat='P')
Inner Join ProAcc on (ProAcc.ProAcc=Voucher.ProAcc)

GO
DROP PROCEDURE PI11_P 
GO
CREATE PROCEDURE PI11_P (@P_ANO as integer)
AS
Select
coalesce(pVoucher.Voucher, Voucher.Voucher) as Voucher,
coalesce(pVoucher.Date, Voucher.Date) as Date,
coalesce(pVoucher.RefDate, Voucher.RefDate) as RefDate,
Policy.DocNo, ProAcc.Description as Name, SL.Doc_No, SL.Doc_CCY, 
Case When nVoucher.DebtorF=1 Then 1 else -1 end*dbo.fn_SL_Payment_Nominal(SL.Nominal_OC, pVoucher.SL_Cat, pVoucher.DebtorF, nVoucher.DebtorF) as Nominal_OC
from (Select Distinct Admlink.DocNo, Admlink.Voucher, Admlink.Type from AccAss, Admlink, Acceptance A1, Acceptance A2 Where Admlink.AdmNo=AccAss.AdmNo and AccAss.Type in ('DI','IR','IT','IC','OP') and AccAss.ANO=A1.ANO and A1.OANO=A2.OANO and A2.ANO=@P_ANO) Policy
Inner join nVoucher on (nVoucher.Voucher=Policy.Voucher)
Inner Join pSL SL on (SL.Doc_No=nVoucher.Voucher and SL.PaymentF=1)
Inner Join pVoucher Voucher on (Voucher.Voucher=SL.Voucher)     
Left Join pVoucher pVoucher on (pVoucher.Voucher=Voucher.RefNo and Voucher.SL_Cat='B' and Voucher.RefType='INTEROFFICE' and pvoucher.SL_Cat='P')
Inner Join ProAcc on (ProAcc.ProAcc=Voucher.ProAcc)


GO

DROP procedure PI08
GO
CREATE procedure PI08(@P_ANO as integer)   
as   
Begin   
Declare @P_Date as smalldatetime   
Declare @P_PolicyNo as varchar(50)   
Declare @P_CertificateNo as varchar(20)   
Declare @P_OpenFLag as Bit   
Declare @P_LANO as int   
Declare @P_A_PolicyNo as varchar(50)   
Select @P_Date = cast(convert(varchar(10), getdate(),1) as smalldatetime)   
   
Select @P_LANO=A1.LANO, @P_PolicyNo=A1.PolicyNo, @P_CertificateNo=A1.CertificateNo, @P_OpenFlag=C1.OpenFlag from Acceptance A1, Cover C1 Where C1.CNO=A1.CNO and A1.ANO=@P_ANO   
   
if @P_LANO<>-1   
if @P_OpenFlag=1 and @P_ANO<>@P_LANO   
Select @P_A_PolicyNo=@P_PolicyNo + '-' + @P_CertificateNo   
else   
Select @P_A_PolicyNo=@P_PolicyNo   
else   
Select @P_A_PolicyNo=@P_PolicyNo   
   
Select Distinct Voucher.Voucher, Voucher.DueDate, Voucher.DocNo, Voucher_Due.DueDate as NDueDate, Profile.Name, Voucher.Currency,   
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
and Admlink.Subject='Premium' and Admlink.Type in ('DI','IC','IR','IT') and Admlink.A_PolicyNo<>'' and Admlink.A_PolicyNo=@P_A_PolicyNo and (Admlink.Extra_1='' or Admlink.Extra_1 is null)   
End   
   

GO

DROP procedure PI09
GO
CREATE procedure PI09(@P_ANO as integer) 
as 
Begin 
Declare @P_Date as smalldatetime 
Declare @P_PolicyNo as varchar(50) 
Declare @P_CertificateNo as varchar(20) 
Declare @P_OpenFLag as Bit 
Declare @P_LANO as int 
Declare @P_A_PolicyNo as varchar(50) 
Select @P_Date = cast(convert(varchar(10), getdate(),1) as smalldatetime) 
 
Select @P_LANO=A1.LANO, @P_PolicyNo=A1.PolicyNo, @P_CertificateNo=A1.CertificateNo, @P_OpenFlag=C1.OpenFlag from Acceptance A1, Cover C1 Where C1.CNO=A1.CNO and A1.ANO=@P_ANO 
 
if @P_LANO<>-1 
if @P_OpenFlag=1 and @P_ANO<>@P_LANO 
Select @P_A_PolicyNo=@P_PolicyNo + '-' + @P_CertificateNo 
else 
Select @P_A_PolicyNo=@P_PolicyNo 
else 
Select @P_A_PolicyNo=@P_PolicyNo 
 
Select Distinct Voucher.Voucher, Voucher.DueDate, Voucher.DocNo, Profile.Name, Voucher.Currency, 
case when Voucher.debtorf=1 then Voucher.Nominal_CC-Voucher.Diff_CC else -(Voucher.Nominal_CC-Voucher.Diff_CC) end  as Nominal, 
case when Voucher.debtorf=1 then (Voucher.AmountDue-Voucher.Payment_CC) else -(Voucher.AmountDue-Voucher.Payment_CC) end as AmountDue, 
case when Voucher.debtorf=1 then Voucher.Payment_CC else -Voucher.Payment_CC end as Payment, 
case when Voucher.debtorf=1 then Voucher.Nominal_CC-Voucher.Diff_CC - Voucher.Payment_CC else -(Voucher.Nominal_CC-Voucher.Diff_CC - Voucher.Payment_CC) end as Outstanding 
 
from nVoucher Voucher, Profile, ProAcc, Admlink 
Where Profile.ID=ProAcc.ID and ProAcc.ProAcc=Voucher.ProAcc and Admlink.Voucher=Voucher.Voucher 
and Admlink.Subject='Claim' and Admlink.Type in ('DI','IC','IR','IT','OP') and Admlink.A_PolicyNo<>'' and Admlink.A_PolicyNo=@P_A_PolicyNo and (Admlink.Extra_1='' or Admlink.Extra_1 is null) 
and round(Voucher.AmountDue,0)>round(Voucher.Payment_CC,0) 
End 



go






 insert into PatchVersioning
select '386 Update Script - Patch 2022 (63)',GETDATE()
go


Declare @PrevScript varchar(100)
Declare @CurrScript varchar(100)

Select @PrevScript=''
Select @CurrSCript='386 Update Script - Patch 2022 (63)'


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






