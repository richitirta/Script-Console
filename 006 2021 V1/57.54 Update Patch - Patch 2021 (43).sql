IF EXISTS ( SELECT * FROM   sysobjects WHERE  id = object_id(N'[dbo].[QPREMIUMAMOUNT]') and OBJECTPROPERTY(id, N'IsProcedure') = 1 )
begin
DROP Procedure QPREMIUMAMOUNT
end
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
	Where Admlink.A_PolicyNo=@P_APolicyNo and Admlink.Subject='Premium' and Admlink.Type in ('DI','IC','IR') and Admlink.Date<=@P_PDate
	and (@P_MinAdmNo=0 or Admlink.AdmNo>=@P_MinAdmNo)
	and (@P_MaxAdmno=0 or Admlink.AdmNo<=@P_MaxAdmNo)
) Voucher 

GO


IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ICPS_PolicyPayment]') AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) ) 
begin
DROP FUNCTION ICPS_PolicyPayment 
end
GO
CREATE FUNCTION ICPS_PolicyPayment(@P_A_PolicyNo as varchar(50),@P_PDate as smalldatetime)       
RETURNS Table       
AS return       
(     
Select
	sum(PremiumPaid) as PremiumPaid,
	Min(PremiumPaidDate) as PremiumPaidDate,
	sum(PremiumOutstanding) as PremiumOutstanding,
	sum(PremiumDue) as PremiumDue,
	Min(PremiumDueDate) as PremiumDueDate,
	Max(WPC) as WPC
from
(
	Select 
	nVoucher.Voucher, 
	Admlink.WPC,
	case when nVoucher.DebtorF=1 Then nVoucher.Payment_CC else -nVoucher.Payment_CC end as PremiumPaid, 
	(   Select Max(coalesce(pVoucher.RefDate, coalesce(OVoucher.RefDate, Voucher.RefDate)))     
		from pSL 
		Inner Join pVoucher Voucher on (Voucher.Voucher=pSL.Voucher)     
		Left Join pVoucher oVoucher on (oVoucher.Voucher=Voucher.RefNo and Voucher.SL_Cat in ('A','B') and oVoucher.SL_Cat in ('P','B'))     
		Left Join pVoucher pVoucher on (pVoucher.Voucher=oVoucher.RefNo and oVoucher.SL_Cat='B' and pvoucher.SL_Cat='P')
		Where pSL.PaymentF=1 and pSL.Doc_No=nVoucher.Voucher       
	) as PremiumPaidDate, 
	case when nVoucher.DebtorF=1 Then (nVoucher.Nominal_CC-nVoucher.Diff_CC-nVoucher.Payment_CC) else -(nVoucher.Nominal_CC-nVoucher.Diff_CC-nVoucher.Payment_CC) end as PremiumOutstanding,  
	case when nVoucher.DebtorF=1 Then coalesce(Voucher_Due.AmountDue, nVoucher.Nominal_CC-nVoucher.Diff_CC) else -coalesce(Voucher_Due.AmountDue, nVoucher.Nominal_CC-nVoucher.Diff_CC) end as PremiumDue,
	Case When Round(nVoucher.Payment_CC,2)<round((Case When Voucher_Due.Voucher is null then nVoucher.Nominal_CC-nVoucher.Diff_CC else Voucher_Due.AmountDue end),2) Then isnull(Voucher_Due.DueDate, nVoucher.DueDate) else Null end AS PremiumDueDate
	FROM Admlink 
	Inner Join nVoucher on (nVoucher.Voucher=Admlink.Voucher)   
	Left Join Voucher_AmountDue(@P_PDate) Voucher_Due on (Voucher_Due.Voucher=nVoucher.Voucher)   
	Where Admlink.Subject='Premium' and Admlink.Type in ('DI','IC','IR') 
	and nVoucher.Date<=@P_PDate
	and Admlink.A_PolicyNo=@P_A_PolicyNo
) P
)          


GO


IF EXISTS ( SELECT * FROM   sysobjects WHERE  id = object_id(N'[dbo].[PI11_P]') and OBJECTPROPERTY(id, N'IsProcedure') = 1 )
begin
DROP Procedure PI11_P
end
GO
CREATE PROCEDURE PI11_P (@P_ANO as integer)
AS
Select Voucher.Voucher, Voucher.Date, 
coalesce(pVoucher.RefDate, coalesce(OVoucher.RefDate, Voucher.RefDate)) as RefDate, Policy.DocNo, ProAcc.Description as Name, SL.Doc_No, SL.Doc_CCY, 
Case When nVoucher.DebtorF=1 Then 1 else -1 end*dbo.fn_SL_Payment_Nominal(SL.Nominal_OC, pVoucher.SL_Cat, pVoucher.DebtorF, nVoucher.DebtorF) as Nominal_OC
from (Select Distinct Admlink.DocNo, Admlink.Voucher, Admlink.Type from AccAss, Admlink, Acceptance A1, Acceptance A2 Where Admlink.AdmNo=AccAss.AdmNo and AccAss.Type in ('DI','IR','IC','OP') and AccAss.ANO=A1.ANO and A1.OANO=A2.OANO and A2.ANO=@P_ANO) Policy
Inner join nVoucher on (nVoucher.Voucher=Policy.Voucher)
Inner Join pSL SL on (SL.Doc_No=nVoucher.Voucher and SL.PaymentF=1)
Inner Join pVoucher Voucher on (Voucher.Voucher=SL.Voucher)     
Left Join pVoucher oVoucher on (oVoucher.Voucher=Voucher.RefNo and Voucher.SL_Cat in ('A','B') and oVoucher.SL_Cat in ('P','B'))     
Left Join pVoucher pVoucher on (pVoucher.Voucher=oVoucher.RefNo and oVoucher.SL_Cat='B' and pvoucher.SL_Cat='P')
Inner Join ProAcc on (ProAcc.ProAcc=Voucher.ProAcc)

GO
IF EXISTS ( SELECT * FROM   sysobjects WHERE  id = object_id(N'[dbo].[PI11_C]') and OBJECTPROPERTY(id, N'IsProcedure') = 1 )
begin
DROP Procedure PI11_C
end
GO
CREATE PROCEDURE PI11_C (@P_ANO as integer)
AS
Select Voucher.Voucher, Voucher.Date, 
coalesce(pVoucher.RefDate, coalesce(OVoucher.RefDate, Voucher.RefDate)) as RefDate, Claim.DocNo, ProAcc.Description as Name, SL.Doc_No, SL.Doc_CCY, 
Case When nVoucher.DebtorF=1 Then 1 else -1 end*dbo.fn_SL_Payment_Nominal(SL.Nominal_OC, pVoucher.SL_Cat, pVoucher.DebtorF, nVoucher.DebtorF) as Nominal_OC
from (Select Distinct Admlink.DocNo, Admlink.Voucher, Admlink.Type from ClaAss, Admlink, Claim C1, Acceptance A1, Acceptance A2 Where Admlink.AdmNo=ClaAss.AdmNo and ClaAss.Type in ('DI','IR','IC','OP') and ClaAss.CNO=C1.CNO and C1.ANO=A2.ANO and A2.OANO=A1.OANO and A1.ANO=@P_ANO) Claim
Inner join nVoucher on (nVoucher.Voucher=Claim.Voucher)
Inner Join pSL SL on (SL.Doc_No=nVoucher.Voucher and SL.PaymentF=1)
Inner Join pVoucher Voucher on (Voucher.Voucher=SL.Voucher)     
Left Join pVoucher oVoucher on (oVoucher.Voucher=Voucher.RefNo and Voucher.SL_Cat in ('A','B') and oVoucher.SL_Cat in ('P','B'))     
Left Join pVoucher pVoucher on (pVoucher.Voucher=oVoucher.RefNo and oVoucher.SL_Cat='B' and pvoucher.SL_Cat='P')
Inner Join ProAcc on (ProAcc.ProAcc=Voucher.ProAcc)

GO