-- 18 JUNI 2019 ENHANCEMENT XACCOUNT
IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'ShariaF' AND Object_ID = Object_ID(N'XACCOUNT'))
BEGIN
ALTER TABLE XACCOUNT ADD
	ShariaF bit NULL
DECLARE @v sql_variant 
SET @v = cast(N'-- New -- ShariaF' as varchar(25))
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'XACCOUNT', N'COLUMN', N'ShariaF'
end
GO

IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'GeneratedF' AND Object_ID = Object_ID(N'XACCOUNT'))
BEGIN
ALTER TABLE XACCOUNT ADD
	GeneratedF bit NULL
DECLARE @v sql_variant 
SET @v = cast(N'-- New -- GeneratedF' as varchar(25))
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'XACCOUNT', N'COLUMN', N'GeneratedF'
END
GO



--tambah panjang karakter

IF EXISTS(SELECT * FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS WHERE TABLE_NAME='EMPLOYMENT' AND CONSTRAINT_NAME='I_EMPLOYMENT')
begin   
ALTER TABLE EMPLOYMENT DROP CONSTRAINT I_EMPLOYMENT
end
GO

ALTER TABLE EMPLOYMENT ALTER COLUMN EMPLOYMENT VARCHAR(30) NOT NULL
GO

ALTER TABLE profile_ext ALTER COLUMN EMPLOYMENT VARCHAR(30)
GO

ALTER TABLE EMPLOYMENT ADD  CONSTRAINT I_EMPLOYMENT PRIMARY KEY CLUSTERED 
(
	EMPLOYMENT ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO

--28 jun 2019
IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'InvoiceNo' AND Object_ID = Object_ID(N'CLLOSS'))
BEGIN
ALTER TABLE CLLOSS ADD
	InvoiceNo varchar(50) NULL
DECLARE @v sql_variant 
SET @v = N'Invoice No from Payment To'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'CLLOSS', N'COLUMN', N'InvoiceNo'
END
GO

IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'InvoiceDate' AND Object_ID = Object_ID(N'CLLOSS'))
BEGIN
ALTER TABLE CLLOSS ADD
	InvoiceDate smalldatetime NULL
DECLARE @v sql_variant 
SET @v = N'Invoice Date from Payment To'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'CLLOSS', N'COLUMN', N'InvoiceDate'
END
GO

IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'InvoiceRemarks' AND Object_ID = Object_ID(N'CLLOSS'))
BEGIN
ALTER TABLE CLLOSS ADD
	InvoiceRemarks varchar(255) Null
DECLARE @v sql_variant 
SET @v = N'Invoice Remarks from Payment To'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'CLLOSS', N'COLUMN', N'InvoiceRemarks'
END
GO

IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'InvoiceRemarks' AND Object_ID = Object_ID(N'CLLOSS'))
BEGIN
ALTER TABLE CLLOSS ADD
		InvoiceNominal float(53) NULL
DECLARE @v sql_variant 
SET @v = N'Invoice Nominal from Payment To'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'CLLOSS', N'COLUMN', N'InvoiceNominal'
END
GO


IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'CLPaymentInvoiceF' AND Object_ID = Object_ID(N'TOC'))
BEGIN
ALTER TABLE TOC ADD
	CLPaymentInvoiceF bit NULL
DECLARE @v sql_variant 
SET @v = N'Claim Payment can be processed only When Invoice Received (0 : Not Apply, 1 : Apply)'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'TOC', N'COLUMN', N'CLPaymentInvoiceF'
END
GO

-- 2 jul 2019
IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'CASHLOSSCOMBINE' AND Object_ID = Object_ID(N'REINSURANCE'))
BEGIN
ALTER TABLE REINSURANCE ADD
	CASHLOSSCOMBINE float(53) NULL
DECLARE @v sql_variant 
SET @v = N'Cash Call Limit Combine (Apply for QS/S1/S2/S3) (0 : Not Apply)'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'REINSURANCE', N'COLUMN', N'CASHLOSSCOMBINE'
END
GO

IF EXISTS ( SELECT * FROM   sysobjects WHERE  id = object_id(N'QCLAIMRCESSION') and OBJECTPROPERTY(id, N'IsProcedure') = 1 ) 
BEGIN DROP PROCEDURE  QCLAIMRCESSION 
end
GO
CREATE Procedure QCLAIMRCESSION (@P_RID varchar(255), @P_CNO int)      
as      
SELECT RPART.ID, RPART.SHARE, RPART.JP, 
100 as RPORTION,
REINSURANCE.RID, REINSURANCE.CESSION, 
CASE WHEN COALESCE(RPART.DOCNO,'')='' THEN REINSURANCE.DOCNO ELSE RPART.DOCNO END AS DOCNO,
Case When Event.Category='E' and RECLASS.ELIMIT<>0 Then RECLASS.ELIMIT Else (Case WHEN RECLASS.Limit=0 THEN Reinsurance.Limit Else RECLASS.Limit end) End*Case When coalesce(ReRate.CRate,0)<>0 Then coalesce(ReRate.CRate,0) else coalesce(ReRate.Rate,1) end 
as Limit,
REINSURANCE.CASHLOSS*Case When coalesce(ReRate.CRate,0)<>0 Then coalesce(ReRate.CRate,0) else coalesce(ReRate.Rate,1) end as CASHLOSS, 
REINSURANCE.CASHLOSSCOMBINE*Case When coalesce(ReRate.CRate,0)<>0 Then coalesce(ReRate.CRate,0) else coalesce(ReRate.Rate,1) end as CASHLOSSCOMBINE, 
REINSURANCE.PRIORITYF,      
CASE WHEN EVENT.CATEGORY<>'E' OR REINSURANCE.EREINSTATEMENT=0 THEN REINSURANCE.REINSTATEMENT ELSE REINSURANCE.EREINSTATEMENT END AS REINSTATEMENT,     
CASE WHEN EVENT.CATEGORY<>'E' OR REINSURANCE.EREINSTATEMENT_1=0 THEN REINSURANCE.REINSTATEMENT_1 ELSE REINSURANCE.EREINSTATEMENT_1 END AS REINSTATEMENT_1,     
CASE WHEN EVENT.CATEGORY<>'E' OR REINSURANCE.EREINSTATEMENT_2=0 THEN REINSURANCE.REINSTATEMENT_2 ELSE REINSURANCE.EREINSTATEMENT_2 END AS REINSTATEMENT_2,     
CASE WHEN EVENT.CATEGORY<>'E' OR REINSURANCE.EREINSTATEMENT_3=0 THEN REINSURANCE.REINSTATEMENT_3 ELSE REINSURANCE.EREINSTATEMENT_3 END AS REINSTATEMENT_3,     
CASE WHEN EVENT.CATEGORY<>'E' OR REINSURANCE.EAP_1=0 THEN REINSURANCE.AP_1 ELSE REINSURANCE.EAP_1 END AS AP_1,     
CASE WHEN EVENT.CATEGORY<>'E' OR REINSURANCE.EAP_2=0 THEN REINSURANCE.AP_2 ELSE REINSURANCE.EAP_2 END AS AP_2,     
CASE WHEN EVENT.CATEGORY<>'E' OR REINSURANCE.EAP_3=0 THEN REINSURANCE.AP_3 ELSE REINSURANCE.EAP_3 END AS AP_3    
From REINSURANCE
INNER JOIN CLAIM ON (CLAIM.CNO=@P_CNO)
INNER JOIN RPART ON (RPART.RNO=REINSURANCE.RNO AND RPART.SHARE<>0)
INNER JOIN RECLASS ON (RECLASS.RNO=REINSURANCE.RNO AND RECLASS.TOC=CLAIM.TOC)
LEFT JOIN Event ON (Event.EventNo=Claim.EventNo)
Left Join ReRate on (ReRate.TOC=Claim.TOC and ReRate.RYear=REINSURANCE.RYEAR and ReRate.Currency=REINSURANCE.Currency)
Inner Join SysTab on (1=1)
WHERE REINSURANCE.RID=@P_RID 
-- If Risk is Excluded      
AND NOT EXISTS (SELECT TOP 1 1 FROM RPARTDET, LCALC WHERE LCALC.CNO=CLAIM.CNO AND RPARTDET.RNO=RPART.RNO AND RPARTDET.ID=RPART.ID AND RPARTDET.TOR=LCALC.TOR AND RPARTDET.EXCLUDEF=1)      
-- If Risk is Excluded      
AND NOT EXISTS (SELECT TOP 1 1 FROM RCALC, LCALC WHERE LCALC.CNO=CLAIM.CNO AND RCALC.ANO=CLAIM.ANO AND RCALC.TOR=LCALC.TOR AND RCALC.EXTREATYF=1)     
and (Case When coalesce(ReRate.CRate,0)<>0 Then coalesce(ReRate.CRate,0) else coalesce(ReRate.Rate,1) end<>1 or REINSURANCE.Currency=SysTab.Currency)


go

--3 July 2019
IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'IRate' AND Object_ID = Object_ID(N'PAYOR'))
BEGIN
ALTER TABLE PAYOR ADD
	IRate float(53) NULL
DECLARE @v sql_variant 
SET @v = N'Interest Rate (in %)'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'PAYOR', N'COLUMN', N'IRate'
END
GO

IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'IRate' AND Object_ID = Object_ID(N'APayor'))
BEGIN
ALTER TABLE APayor ADD
	IRate float(53) NULL
DECLARE @v sql_variant 
SET @v = N'Interest Rate (in %)'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'APayor', N'COLUMN', N'IRate'
END
GO

IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'InstSI' AND Object_ID = Object_ID(N'Payor_Schedule'))
BEGIN
ALTER TABLE Payor_Schedule ADD
	InstSI float(53) NULL
DECLARE @v sql_variant 
SET @v = N'Sum Insured'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'Payor_Schedule', N'COLUMN', N'InstSI'
END
GO

if exists (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'FN_PCalc') AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) ) 
BEGIN DROP FUNCTION FN_PCalc
end
GO
Create FUNCTION FN_PCalc (@P_ANO as integer)            
RETURNS Table            
AS RETURN (            
SELECT  Acceptance.ANO,            
 Count(PCalc.Currency) AS NUMCCY,          
 MAX(PCALC.RATE) AS RATE,          
 MAX(PCALC.CRATE) AS CRATE,         
 MAX(CASE When Acceptance.QTY=0 Then 1 Else Acceptance.QTY end) as NumRisk,
 sum(PCalc.TSI*PCalc.Rate*Case When Acceptance.QTY=0 Then 1 Else Acceptance.QTY end) AS TSI,            
 sum(PCalc.OurShare*PCalc.Rate*Case When Acceptance.QTY=0 Then 1 Else Acceptance.QTY end) AS OurShare,            
 sum(PCalc.Amount*PCalc.Rate*Case When Acceptance.QTY=0 Then 1 Else Acceptance.QTY end) AS Amount,            
 sum(PCalc.Gross*PCalc.Rate*Case When Acceptance.QTY=0 Then 1 Else Acceptance.QTY end) AS Gross,            
 sum(PCalc.Claim*PCalc.Rate*Case When Acceptance.QTY=0 Then 1 Else Acceptance.QTY end) AS Claim,            
 sum(case when PCalc.TSI=0 then 0 else PCalc.OurShare*PCalc.Rate*Case When Acceptance.QTY=0 Then 1 Else Acceptance.QTY end end)/            
 sum(case when PCalc.TSI=0 then 1 else PCalc.TSI*PCalc.Rate*Case When Acceptance.QTY=0 Then 1 Else Acceptance.QTY end end)*            
 sum(PCalc.Gross*PCalc.Rate*Case When Acceptance.QTY=0 Then 1 Else Acceptance.QTY end) as Premium,            
 MAX(CASE WHEN PCALC.TSI<>0 AND COALESCE(ISOURCE.LIMIT,0)<>0 THEN PCALC.OURSHARE/PCALC.TSI*100 ELSE COALESCE(ISOURCE.SHARE,100) END) as PCTSHARE, 
 MAX(RARRHEADER.MSHARE) as MSHARE
FROM  Acceptance with(NOLOCK)       
LEFT JOIN Pcalc with(NOLOCK) ON (Acceptance.ANO=PCalc.ANO and Acceptance.PStatus='C')       
LEFT JOIN RArrHeader with(NOLOCK) On (RArrHeader.ANO=Acceptance.ANO)      
LEFT JOIN ISOURCE with (NOLOCK) ON (ISOURCE.CNO=ACCEPTANCE.CNO)            
Where Acceptance.ANO=@P_ANO            
GROUP BY Acceptance.ANO            
)            

GO

IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'ScheduleF' AND Object_ID = Object_ID(N'APayor'))
BEGIN
ALTER TABLE APayor ADD
	ScheduleF bit NULL
DECLARE @v sql_variant 
SET @v = N'Refer to Payor Schedule (0 : No, 1 : Yes)'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'APayor', N'COLUMN', N'ScheduleF'
END
GO

IF EXISTS ( SELECT * FROM   sysobjects WHERE  id = object_id(N'QProduction_To_Adm') and OBJECTPROPERTY(id, N'IsProcedure') = 1 ) 
BEGIN DROP PROCEDURE  QProduction_To_Adm
end
GO
CREATE Procedure QProduction_To_Adm(@P_ANO as int)                              
as                              
Select A1.ID, A1.TOC, A1.Type, A1.Currency, A1.Date, Max(A1.DocNo) as DocNo, A1.RefNo,
Case When SysTab.SplitPremiumAndClaimF=1 and A1.Code in ('A','R') Then 'Claim' else 'Premium' end as Subject,       
Max(Case When coalesce(AL.RefNo,'')=A1.RefNo and C.ISType<>'T' Then coalesce(AL.AName,Case When A2.AName<>'' then A2.AName else A2.Remarks end) else Case When A2.AName<>'' then A2.AName else A2.Remarks end end) as Remarks,                                 
(Select Top 1 TreatyInstallmentF from reinsurance Where Reinsurance.docNo=A1.RefNo) as TreatyInstallmentF,
Case When (coalesce(APayor.ScheduleF, coalesce(Payor.ScheduleF,0))=1) Then (Case When A1.SDate>A1.BillDate Then A1.SDate else A1.BillDate End) Else A1.BillDate End as BillDate,
Case When (coalesce(APayor.ScheduleF, coalesce(Payor.ScheduleF,0))=1) or (Case When isnull(APayor.ANO,0)=0 Then (Case When isnull(MPayor.ANO,0)=0 Then Payor.PolicyYearF else MPayor.PolicyYearF end) else APayor.PolicyYearF end)=1 Then A1.SDate else A2.SDate end as SDate,                              
Case When (coalesce(APayor.ScheduleF, coalesce(Payor.ScheduleF,0))=1) or (Case When isnull(APayor.ANO,0)=0 Then (Case When isnull(MPayor.ANO,0)=0 Then Payor.PolicyYearF else MPayor.PolicyYearF end) else APayor.PolicyYearF end)=1 Then A1.EDate else A2.EDate end as EDate,               
case When coalesce(A1.Source,'')='' or A1.Source<>A1.ID then A2.Source else A1.Source end Source,                              
Case When A1.CAmount=0 and Coalesce(A3.Branch,'')<>'' Then A3.Branch Else A2.Branch end Branch,         
Max(Branch.VAT) as BVATPCT,
min (A1.SDate) as MINSDate, max(A1.SDate) as MAXSDate,                
min (A1.ACNO)  as MinACNO, min (A1.ACNO) as MaxACNO,                          
sum(Case When A1.Code='P' then A1.Amount else 0 end) as Amount_1,                              
sum(Case When A1.Code='C' then A1.Amount else 0 end) as Amount_2,                              
sum(Case When A1.Code='F' and coalesce(A1.CodeExt,'')='' then A1.Amount else 0 end) as Amount_3,                              
sum(Case When A1.Code='D' and coalesce(A1.CodeExt,'')='' then A1.Amount else 0 end) as Amount_4,                              
sum(Case When A1.Code='O' then A1.Amount else 0 end) as Amount_5,                              
sum(Case When A1.Code='A' then A1.Amount else 0 end) as Amount_6,                              
sum(Case When A1.Code='R' then A1.Amount else 0 end) as Amount_10,                              
sum(Case When A1.Code='T' then A1.Amount else 0 end) as Amount_14,                              
sum(Case When A1.Code in ('D','F') and coalesce(A1.CodeExt,'')='1' then A1.Amount else 0 end) as Amount_15,            
sum(Case When A1.Code in ('D','F') and coalesce(A1.CodeExt,'')='2' then A1.Amount else 0 end) as Amount_16,            
sum(Case When A1.Code='J' then A1.Amount else 0 end) as Amount_19,    
sum(Case When A1.Code='U' then A1.Amount else 0 end) as Amount_20                              
from AccAss A1                              
Inner Join Acceptance A2 on (A2.ANO=A1.ANO)                              
Inner Join Cover C on (C.CNO=A2.CNO)                  
Left Join Acceptance AL on (AL.ANO=A2.LANO and C.OpenFlag=0)                  
Left Join APayor on (APayor.ANO=A2.ANO and A2.LANO<>-1 and A2.ANO<>A2.LANO)                              
Left Join Payor on (Payor.ANO=A2.ANO and A2.LANO=-1)                 
Left Join Payor MPayor on (MPayor.ANO=A2.LANO and A2.LANO<>-1)                
Left join  Acceptance A3 on (A3.ANO=A2.pANO)    
Inner Join Branch on (Branch.Branch=Case When A1.CAmount=0 and Coalesce(A3.Branch,'')<>'' Then A3.Branch Else A2.Branch end)
Inner Join SysTab on (1=1)                          
Where A1.ANO=@P_ANO                              
Group By A1.ID, A1.TOC, A1.Type, A1.Currency, A1.Date, A1.BillDate, A1.RefNo,                     
Case When SysTab.SplitPremiumAndClaimF=1 and A1.Code in ('A','R') Then 'Claim' else 'Premium' end,
Case When (coalesce(APayor.ScheduleF, coalesce(Payor.ScheduleF,0))=1) Then (Case When A1.SDate>A1.BillDate Then A1.SDate else A1.BillDate End) Else A1.BillDate End,
Case When (coalesce(APayor.ScheduleF, coalesce(Payor.ScheduleF,0))=1) or (Case When isnull(APayor.ANO,0)=0 Then (Case When isnull(MPayor.ANO,0)=0 Then Payor.PolicyYearF else MPayor.PolicyYearF end) else APayor.PolicyYearF end)=1 Then A1.SDate else A2.SDate end,                
Case When (coalesce(APayor.ScheduleF, coalesce(Payor.ScheduleF,0))=1) or (Case When isnull(APayor.ANO,0)=0 Then (Case When isnull(MPayor.ANO,0)=0 Then Payor.PolicyYearF else MPayor.PolicyYearF end) else APayor.PolicyYearF end)=1 Then A1.EDate else A2.EDate end,
case When coalesce(A1.Source,'')='' or A1.Source<>A1.ID then A2.Source else A1.Source end,                              
Case When A1.CAmount=0 and Coalesce(A3.Branch,'')<>'' Then A3.Branch Else A2.Branch end 

GO
IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'DecreaseF' AND Object_ID = Object_ID(N'PAYOR'))
BEGIN
ALTER TABLE PAYOR ADD
	DecreaseF bit NULL
DECLARE @v sql_variant 
SET @v = N'Decreasing Flag (0 : No, 1 : Yes)'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'PAYOR', N'COLUMN', N'DecreaseF'
END
GO

IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'DecreaseF' AND Object_ID = Object_ID(N'APAYOR'))
BEGIN
ALTER TABLE APAYOR ADD
	DecreaseF bit NULL
DECLARE @v sql_variant 
SET @v = N'Decreasing Flag (0 : No, 1 : Yes)'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'APAYOR', N'COLUMN', N'DecreaseF'
END
GO


IF EXISTS ( SELECT * FROM   sysobjects WHERE  id = object_id(N'QPCALC_ACCASS') and OBJECTPROPERTY(id, N'IsProcedure') = 1 )
 BEGIN DROP PROCEDURE  QPCALC_ACCASS
end
GO
CREATE Procedure QPCALC_ACCASS (@P_ANO integer)     
AS     
SELECT ICALC.CURRENCY, ICALC.CODE, 
coalesce(P.InstDate, ICalc.SDate) as SDate,
coalesce(P.InstLDate, ICalc.EDate) as EDate,
(Case When A1.AType='A' Then 0 else ICover.Adjustable end) as AdjustableF, ICALC.SANO, A2.LANO,     
Cast(Max(cast(RCover.NoRefundF as Integer)) as Bit) as NoRefundF,     
Max(Case When ICover.Adjustable=1 Then TOI.AdjMethod else '' end) as AdjMethod,     
AVG(ICALC.PRORATA) AS PPRORATA, 
MAX(CASE WHEN PCALC.TSI<>0 AND COALESCE(ISOURCE.LIMIT,0)<>0 THEN PCALC.OURSHARE/PCALC.TSI*100 ELSE COALESCE(ISOURCE.SHARE,100) END) as SHARE, 
SUM(coalesce(P.InstAmount,Case When PCALC.Description<>'' and PCALC.Description<>'Minimum Premium' then ICALC.GROSS*PCALC.GROSS/PCALC.OGROSS else ICALC.GROSS*RCALC.GROSS/RCALC.OGROSS end)) AS GROSS,     
CAST(MAX(Case When Upper(PCALC.DESCRIPTION) in ('MINIMUM PREMIUM','POLICY MINIMUM PREMIUM') Then 1 else 0 end) as Bit) as MinimumPremiumF,     
SUM(ICALC.REINSTATEMENT) AS REINSTATEMENT,     
SUM(ICALC.DISCOUNT) AS DISCOUNT,     
SUM(ICALC.LOADING) AS LOADING,     
MAX(PCALC.TSI) as TSI,      --100% Sum Insured for Reinsurance Rate     
MAX(PCALC.Rate) As Rate     
FROM ICover     
inner join ICALC on (ICALC.INO=ICOVER.INO and ICALC.ANO=ICOVER.ANO)     
inner join TOI on (TOI.TOI=ICOVER.TOI)     
inner join RCALC on (ICALC.ANO=RCALC.ANO AND ICALC.CURRENCY=RCALC.CURRENCY AND ICALC.CODE=RCALC.CODE AND ICALC.TOR=RCALC.TOR AND ICALC.SDATE=RCALC.SDATE AND ICALC.EDATE=RCALC.EDATE AND ICALC.SANO=RCALC.SANO)     
inner join PCALC on (PCALC.ANO=ICALC.ANO AND PCALC.CURRENCY=ICALC.CURRENCY)     
Left join RCover on (RCover.ANO=RCalc.ANO and RCover.Code=RCalc.Code and RCover.SDate=RCalc.SDate)     
inner join ACCEPTANCE A1 On (A1.ANO=ICALC.ANO)     
inner join ACCEPTANCE A2 on (A2.ANO=ICALC.SANO)     
Inner Join RArrHeader R on (R.ANO=ICalc.ANO)     
left join ISource on (ISource.CNO=A2.CNO)     
Left Join Payor_Schedule P on (P.ANO=@P_ANO)
WHERE ICover.ANO=@P_ANO and ICALC.GROSS<>0 AND ICALC.SDATE<>ICALC.EDATE  
GROUP BY ICALC.CURRENCY, ICALC.CODE, coalesce(P.InstDate, ICalc.SDate), coalesce(P.InstLDate, ICalc.EDate), (Case When A1.AType='A' Then 0 else ICover.Adjustable end), ICalc.SANO, A2.LANO     


go
--4 jul 2019
IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'FundingF' AND Object_ID = Object_ID(N'pSL'))
BEGIN
ALTER TABLE pSL ADD
	FundingF bit NULL
DECLARE @v sql_variant 
SET @v = N'Flag Indicating this Payment Transaction is funding (0 : No, 1 : Yes)'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'pSL', N'COLUMN', N'FundingF'
END
GO

if exists (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'oSL') AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) )
 BEGIN DROP FUNCTION oSL
end
GO
CREATE Function oSL(@P_Voucher varchar(20)) 
RETURNS Table 
as Return 
( 
Select pSL.Voucher, pSL.Doc_No, pSL.Doc_Date, pSL.Doc_CCY, pSL.Nominal_OC, pSL.CT, pSL.Nominal, pSL.Remarks, pSL.Hint, 
Case 
When VType.Code<>'MATCHING' and pVoucher.SL_Cat='P' and pSL.Doc_No<>pSL.Account and (Case When OSL.PaymentF is null then pSL.PaymentF else OSL.PaymentF end)=0 then
	Case When exists(Select Top 1 R.PID from RPBucket R Where R.Voucher=pVoucher.Voucher and R.NVoucher=pSL.Doc_No and R.NVoucher<>'' and R.Status<>'C') Then cast(1 as Bit) else cast(0 as Bit) end
else
	cast(0 as bit)
end
as BucketF, 
Case When OSL.PaymentF is null then pSL.PaymentF else OSL.PaymentF end as PaymentF, 
Case When OSL.Account is null then pSL.Account else OSL.Account end as Account, 
Case When OVoucher.Branch is null then pVoucher.Branch else OVoucher.Branch end as Branch, pSL.Nominator, pSL.Denominator, pSL.Rate, pSL.SortNo, pSL.pVoucher, pSL.LockedF, pSL.FundingF
From pVoucher 
Inner Join VType on (VType.VType=pVoucher.VType)
Inner Join pSL on (pSL.Voucher=pVoucher.Voucher) 
Left Join Branch OBranch on (OBranch.IO_Account=pSL.Account)
Left Join pVoucher OVoucher on (OVoucher.RefNo=pSL.Voucher and OVoucher.Branch=OBranch.Branch and OVoucher.SL_Cat='B' and OVoucher.RefType='INTEROFFICE') 
Left join pSL OSL on (OSL.Voucher=OVoucher.Voucher and OSL.Doc_No=pSL.Doc_No and OSL.Nominal=pSL.Nominal and (oSL.SortNo=0 or oSL.SortNo=pSL.SortNo)) 
Where (pVoucher.Voucher=@P_Voucher) 
) 


GO
IF NOT EXISTS(SELECT * FROM SYSFORM WHERE FNAME='ALLOWFUNDING')
BEGIN
insert into SysForm(FName, Description, FCode, RequestF) Select 'ALLOWFUNDING', 'Allow Funding', 'ACTIVITIES',0
END

GO

IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'FundingF' AND Object_ID = Object_ID(N'SL_Request'))
BEGIN
ALTER TABLE SL_Request ADD
       FundingF bit NULL
DECLARE @v sql_variant 
SET @v = N'Flag Indicating this Payment Transaction is funding (0 : No, 1 : Yes)'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'SL_Request', N'COLUMN', N'FundingF'
END
GO


--update scirpt
if exists (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'R_SL_ALLOCATED_BY_VOUCHER') AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) )
 BEGIN DROP FUNCTION R_SL_ALLOCATED_BY_VOUCHER
end
GO
CREATE FUNCTION R_SL_ALLOCATED_BY_VOUCHER(@P_Voucher as varchar(20)='')                               
RETURNS TABLE  AS                                 
RETURN (                               
--SL from Payment Voucher                                       
Select pSL.Voucher, pVoucher.Branch, pVoucher.Currency as Doc_CCY, pSL.Voucher as Doc_No, pSL.Account, Max(pSL.Hint) as Hint, sum(pSL.Nominal) as Nominal_OC, cast(1 as Bit) as PaymentF, cast(1 as Float) as Rate                                    
From pSL                      
Inner Join pVoucher on (pVoucher.Voucher=pSL.Voucher)                      
Where pVoucher.SL_Cat in ('P') and pSL.PaymentF=1 
and (pVoucher.Voucher=@P_Voucher or @P_Voucher='')      
Group By pSL.Voucher, pVoucher.Branch, pVoucher.Currency, pSL.Account
    
Union All    
    
--SL from InterOffice Overbooking Voucher                                       
Select pVoucher.RefNo as Voucher, pVoucher.Branch, OVoucher.Currency as Doc_CCY, pVoucher.RefNo as Doc_No, pSL.Account, Max(pSL.Hint) as Hint, sum(pSL.Nominal) as Nominal_OC, cast(1 as Bit) as PaymentF, cast(1 as Float) as Rate
From pSL                      
Inner Join pVoucher on (pVoucher.Voucher=pSL.Voucher)              
Inner Join pVoucher OVoucher on (OVoucher.Voucher=pVoucher.RefNo)            
Where pVoucher.SL_Cat in ('B') and pVoucher.RefType='INTEROFFICE' and pSL.PaymentF=1                 
and (pVoucher.RefNo=@P_Voucher or @P_Voucher='')      
Group by pVoucher.RefNo, pVoucher.Branch, OVoucher.Currency, pSL.Account
                                       
union all                                       
                                       
--SL from Overbooking Payment and Adjustment Payment                                       
Select SL.Voucher, VoucherR.Branch, VoucherP.Currency as Doc_CCY, VoucherP.Voucher as Doc_No, SL.SAccount as Account, MAX(SL.Hint) AS HINT,  
sum((case When VoucherR.DebtorF=VoucherP.DebtorF Then SL.Nominal else -SL.Nominal end)) as Nominal_OC, cast(1 as Bit) as PaymentF, cast(1 as Float) as Rate                                       
from pSL SL, pVoucher VoucherP, pVoucher VoucherR  
Where VoucherR.RefType<>'INTEROFFICE' and VoucherR.SL_Cat in ('B','A') and VoucherP.SL_Cat='P' and VoucherR.RefNo=VoucherP.Voucher and SL.Voucher=VoucherR.Voucher                        
and (VoucherP.Voucher=@P_Voucher or @P_Voucher='')  
Group By SL.Voucher, VoucherR.Branch, VoucherP.Currency, VoucherP.Voucher, SL.SAccount  
                                 
union all                                       
                                       
--SL from Adjustment Overbooking                                       
Select SL.Voucher, VoucherR.Branch, VoucherP.Currency as Doc_CCY, VoucherP.RefNo as Doc_No, SL.SAccount as Account, MAX(SL.Hint) AS HINT,  
sum((case When VoucherR.DebtorF=VoucherP.DebtorF Then SL.Nominal else -SL.Nominal end)) as Nominal_OC, cast(1 as Bit) as PaymentF, cast(1 as Float) as Rate
from pSL SL, pVoucher VoucherP, pVoucher VoucherR  
Where VoucherR.RefType<>'INTEROFFICE' and VoucherR.SL_Cat in ('A') and VoucherP.SL_Cat in ('B') and VoucherR.RefNo=VoucherP.Voucher and SL.Voucher=VoucherR.Voucher                 
and (VoucherP.RefNo=@P_Voucher or @P_Voucher='')  
Group By SL.Voucher, VoucherR.Branch, VoucherP.Currency, VoucherP.RefNo, SL.SAccount  

                                       
union all                                       
                                       
--SL from Sub Ledger Payment Voucher and OverPaid                                       
Select SL.Voucher, VoucherR.Branch, VoucherP.Currency as Doc_CCY, SL.Doc_No as Doc_No, SL.Account, SL.Hint,  
(Case When VoucherR.SL_Cat='O'                                        
then (case when VoucherR.DebtorF=VoucherP.DebtorF then SL.Nominal_OC else -SL.Nominal_OC end)                                        
else (case when VoucherR.DebtorF<>VoucherP.DebtorF then SL.Nominal_OC else -SL.Nominal_OC end)                                       
end) as Nominal_OC, cast(1 as Bit) as PaymentF, cast(1 as Float) as Rate
from pSL SL, pVoucher VoucherP, pVoucher VoucherR                                       
Where VoucherR.SL_Cat in ('O','P','A','B') and VoucherP.SL_Cat in ('P') and VoucherR.Voucher=SL.Voucher and SL.Doc_No=VoucherP.Voucher and SL.PaymentF=1                                       
and (SL.Doc_No=@P_Voucher or @P_Voucher='')                         
                               
)         

go

IF EXISTS ( SELECT * FROM   sysobjects WHERE  id = object_id(N'CLLIST00') and OBJECTPROPERTY(id, N'IsProcedure') = 1 )
 BEGIN DROP PROCEDURE  CLLIST00
end
go
CREATE PROCEDURE CLLIST00(@P_CNO as integer) AS  
SELECT  Cast(0 as bit) as ProcessFlag,
[CLAIM].[CLAIMNO],  
 [CLAIM].[REGDATE],  
 [CLAIM].[REFNO],  
 [CLAIM].[COL],  
 [COLTAB].[DESCRIPTION],  
 [CLAIM].[LOSSDATE],  
 [CLAIM].[TOC],  
 [CLAIM].[CSDATE],  
 [CLAIM].[PUserDATE],  
 [CLAIM].[LOSSPLACE],  
 [CLAIM].[CTYPE],  
 [CLAIM].[CSTATUS],  
 [CLAIM].[CNO],  
 [CLAIM].[ANO],  
 [CLAIM].[PCNO],  
 [CLAIM].[LUSERID] + '/' + [CLAIM].[AUSERID] AS USERID,  
 [SYSTAB].[CURRENCY],  
 [CCALC].[LOSS] AS ESTIMATE,  
 [CCALC].[CLAIM] AS CLAIM,  
 [CCALC].[DEDUCTIBLE] AS DEDUCTIBLE,  
 [CCALC].[SALVAGE] AS SALVAGE,  
 [CCALC].[COST] AS COST,  
 [CCALC].[SUBROGATION] AS SUBROGATION,  
 CCALC.RESERVED AS OUTSTANDING,
([CARRHEADER].[TAMOUNT]-[CARRHEADER].[RAMOUNT]) AS RECOVERIES,  
 [CLAIM].[VSEQNO],  
 [CLAIM].[CSEQNO],  
 ACCEPTANCE.ANAME,  
 CLAIM.POLICYNO,  
 CLAIM.CERTIFICATENO,  
 CLAIM.SETTLEDF  
FROM  CLAIM LEFT JOIN ACCEPTANCE ON (ACCEPTANCE.ANO=CLAIM.ANO), QCLAIM_CCALC() AS CCALC, SYSTAB, CARRHEADER,COLTAB  
Where [CARRHEADER].[CNO] = [CLAIM].[CNO]  
 And [CCALC].[CNO]=[CLAIM].[CNO]  
 And CLAIM.COL=COLTAB.COL  
 And [CLAIM].[CNO]=@P_CNO
go

if exists (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'FN_UserMO') AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) ) 
BEGIN DROP FUNCTION FN_UserMO
end
GO
CREATE function FN_UserMO(@P_USERID varchar(50))          
RETURNS Table            
AS RETURN            
(          
SELECT S1.*      
from SysUser S1    
Left join SysUserMO S on (S.MO=S1.ID and S.ID=@P_UserID)
Where  
(
not exists(Select Top 1 MO from SysUserMO S Where S.ID=@P_UserID)
or coalesce(S.ID,'')=@P_UserID
)
)              
go

--10 jul 2019
if exists (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'Get_Payment_Percentage') AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) ) 
BEGIN DROP FUNCTION Get_Payment_Percentage
end
GO
CREATE Function Get_Payment_Percentage(@P_A_PolicyNo varchar(50), @P_Type varchar(10), @P_DocNO varchar(50), @P_Date smalldatetime)
RETURNS Float AS        
  
BEGIN       
Declare @PCT as Float

Select 
@PCT=
sum(case When V.DebtorF=1 Then (V.Payment_CC) Else -(V.Payment_CC) end)/sum(case When V.DebtorF=1 Then (V.Nominal_CC) Else -(V.Nominal_CC) end)*100

from (

	Select V.Voucher, 
	cast(Max(Cast(V.DebtorF as Int)) as Bit) as DebtorF,
	Case 
	When @P_TYPE in ('PI','PL') Then Max(V.Payment_CC)
	When Max(V.Payment_CC)<sum((case When V.DebtorF=1 Then 1 else -1 end)*(A.LAmount)) Then 0
	Else Max(V.Payment_CC)-sum((case When V.DebtorF=1 Then 1 else -1 end)*(A.LAmount))
	End as Payment_CC,

	sum(
		(case When V.DebtorF=1 Then 1 else -1 end)*
		Case
		When @P_Type in ('PI','PL') then (A.Amount)
		Else (A.Amount-A.LAmount)
		End
	) as Nominal_CC
	from nVoucher V, Admlink A
	Where A.Voucher=V.Voucher
	and A.Date<=@P_Date and A.A_PolicyNo=@P_A_PolicyNo and A.DocNo<=@P_DocNo and A.Subject='Premium' and V.DebtorF=1 and A.Type in ('DI','IC','IR')
	Group By V.Voucher
) V

Having sum(case When V.DebtorF=1 Then (V.Nominal_CC) Else -(V.Nominal_CC) end)<>0

if @PCT IS NULL 
	SELECT @PCT=100

Return @PCT
End





go

--16 jul 2019

IF  NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'Port') AND type in (N'U'))
BEGIN
CREATE TABLE Port(
	Port varchar(10) NULL,
	Description varchar(255) NULL,
	Country varchar(10) NULL,
	Last_Update smalldatetime NULL,
	Last_Opr varchar(50) NULL,
	AllowedF bit NULL
) ON [PRIMARY]
ALTER TABLE Port  WITH CHECK ADD  CONSTRAINT FK_Port_Country FOREIGN KEY(Country)
REFERENCES Country (Country)
ON UPDATE CASCADE
ON DELETE CASCADE
ALTER TABLE Port CHECK CONSTRAINT FK_Port_Country
END
GO

IF Not EXISTS (SELECT *  FROM sys.indexes WHERE name='I_Port' AND object_id = OBJECT_ID('Port'))
BEGIN
Create Unique Index I_Port on Port(Port)
END
go

--23 jul 2019

IF NOT EXISTS(SELECT * FROM SYSFORM WHERE FNAME='ALLOWBILLINGBYPOLICYYEAR')
BEGIN
insert into sysForm(FName, Description, FCode, RequestF)
Select 'ALLOWBILLINGBYPOLICYYEAR','ALLOW SET BILLING BY POLICY YEAR (PAYOR)','ACTIVITIES',0
END
go

-- QUery Ainfo_Ext
if exists (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'MListQry_3_a') AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) )
 BEGIN DROP FUNCTION MListQry_3_a
end
GO
CREATE function MListQry_3_a(@value1 as varchar(255) ,@value2 as varchar(255) ,@value3 as varchar(255) ,@value4 as varchar(255) ,@value5 as varchar(255) ,@value6 as varchar(255) ,@value7 as varchar(255) ,@value8 as varchar(255) ,@value9 as varchar(255),@Value10 as varchar(255), @Value11 as varchar(255), @Value12 as varchar(255))     
returns table    
as return    
(    
SELECT   Cast(0 as bit) as ProcessFlag,     
  q.[CoverNo],     
  q.[Insured],     
  q.[CNO],     
  q.[CStatus],     
  q.VSeqNo,     
  q.[lANO],     
  q.[ANO],     
  q.[REGNO],     
  q.[ADATE],     
  q.[USERID],     
  q.[Currency],     
  q.[TSI],     
  q.[OurShare],     
  q.[Gross],     
  q.[ASTATUS],     
  q.[ATYPE],     
  q.[SDate],     
  q.[EDate],     
  q.RYear,     
  q.[ISType],     
  q.[Renewal],     
  q.[ESeqNo],     
  q.[PolicyNo],    
  a.valueid1, a.valuedesc1,    
  a.valueid2, a.valuedesc2,    
  a.valueid3, a.valuedesc3,    
  a.valueid4, a.valuedesc4,    
  a.valueid5, a.valuedesc5,    
  a.valueid6, a.valuedesc6,    
  a.valueid7, a.valuedesc7,    
  a.valueid8, a.valuedesc8,    
  a.valueid9, a.valuedesc9,    
  a.valueid10, a.valuedesc10,    
  a.valueid11, a.valuedesc11,    
  a.valueid12, a.valuedesc12,    
  a.valueid13, a.valuedesc13,    
  a.valueid14, a.valuedesc14,    
  a.valueid15, a.valuedesc15,
  b.valueid16, b.valuedesc16,  
  b.valueid17, b.valuedesc17,  
  b.valueid18, b.valuedesc18,  
  b.valueid19, b.valuedesc19,  
  b.valueid20, b.valuedesc20,  
  b.valueid21, b.valuedesc21,  
  b.valueid22, b.valuedesc22,  
  b.valueid23, b.valuedesc23,  
  b.valueid24, b.valuedesc24,  
  b.valueid25, b.valuedesc25,  
  b.valueid26, b.valuedesc26,  
  b.valueid27, b.valuedesc27,  
  b.valueid28, b.valuedesc28,  
  b.valueid29, b.valuedesc29,  
  b.VALUEID30 , b.VALUEDESC30           
FROM  MListQry_3(@Value1, @Value2, @Value3, @Value4, @Value5, @Value6, @Value7, @Value8, @Value9, @Value10, @Value11, @Value12) q, ainfo a Left Join Ainfo_Ext b on (b.ANO=a.ANO)  
WHERE  q.ano_info = a.ano    
)  



GO
if exists (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'CLLISTQRY') AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) ) 
BEGIN DROP FUNCTION CLLISTQRY 
end
GO
CREATE FUNCTION CLLISTQRY (@VALUE1 AS VARCHAR(255), @VALUE2 AS VARCHAR(255), @VALUE5 AS VARCHAR(255), @VALUE6 AS VARCHAR(255), @VALUE7 AS VARCHAR(255), @VALUE8 AS VARCHAR(255), @VALUE9 AS VARCHAR(255), @VALUE10 AS VARCHAR(255), @VALUE11 AS VARCHAR(255), @VALUE12 AS VARCHAR(255), @VALUE13 AS VARCHAR(255),@VALUE14 as Varchar(10), @VALUE15 as Varchar(10),@VALUE16 as Varchar(255),@VALUE17 as Varchar(255),@VALUE18 as Varchar(255),@VALUE21 as Varchar(255))              
RETURNS Table              
AS RETURN (              

SELECT Distinct Claim.CNO,              
  Claim.ClaimNo,              
  Claim.refno,              
  Claim.PolicyNo,              
  Claim.RegDate,              
  Claim.LossDate,              
  Claim.LossPlace,              
  COLTAB.Description,              
  Claim.ClaimantInfo as Claimant,              
  Payment.Name as Payment,              
  Claim.EventName,              
  Claim.CType,              
  Claim.CStatus,              
  Claim.LargeF,              
  Claim.UniqueF,              
  Claim.TBAF_1,              
  Claim.TBAF_2,              
  Claim.SurveyF,              
  CLLOSS.TOI,              
  Claim.Branch,       
  Claim.TOC,              
  Cover.MO,      
  Case When CLInfo.CNO is null then AInfo.ValueID1 else CLInfo.ValueID1 end as ValueID1,              
  Case When CLInfo.CNO is null then AInfo.ValueID2 else CLInfo.ValueID2 end as ValueID2,              
  Case When CLInfo.CNO is null then AInfo.ValueID3 else CLInfo.ValueID3 end as ValueID3,              
  Case When CLInfo.CNO is null then AInfo.ValueID4 else CLInfo.ValueID4 end as ValueID4,              
  Case When CLInfo.CNO is null then AInfo.ValueID5 else CLInfo.ValueID5 end as ValueID5,              
  Case When CLInfo.CNO is null then AInfo.ValueID6 else CLInfo.ValueID6 end as ValueID6,              
  Case When CLInfo.CNO is null then AInfo.ValueID7 else CLInfo.ValueID7 end as ValueID7,              
  Case When CLInfo.CNO is null then AInfo.ValueID8 else CLInfo.ValueID8 end as ValueID8,              
  Case When CLInfo.CNO is null then AInfo.ValueID9 else CLInfo.ValueID9 end as ValueID9,              
  Case When CLInfo.CNO is null then AInfo.ValueID10 else CLInfo.ValueID10 end as ValueID10,              
  Case When CLInfo.CNO is null then AInfo.ValueID11 else CLInfo.ValueID11 end as ValueID11,              
  Case When CLInfo.CNO is null then AInfo.ValueID12 else CLInfo.ValueID12 end as ValueID12,              
  Case When CLInfo.CNO is null then AInfo.ValueID13 else CLInfo.ValueID13 end as ValueID13,              
  Case When CLInfo.CNO is null then AInfo.ValueID14 else CLInfo.ValueID14 end as ValueID14,              
  Case When CLInfo.CNO is null then AInfo.ValueID15 else CLInfo.ValueID15 end as ValueID15,              
  Case When CLInfo.CNO is null then AInfo.ValueDesc1 else CLInfo.ValueDesc1 end as ValueDesc1,              
  Case When CLInfo.CNO is null then AInfo.ValueDesc2 else CLInfo.ValueDesc2 end as ValueDesc2,              
  Case When CLInfo.CNO is null then AInfo.ValueDesc3 else CLInfo.ValueDesc3 end as ValueDesc3,              
  Case When CLInfo.CNO is null then AInfo.ValueDesc4 else CLInfo.ValueDesc4 end as ValueDesc4,              
  Case When CLInfo.CNO is null then AInfo.ValueDesc5 else CLInfo.ValueDesc5 end as ValueDesc5,              
  Case When CLInfo.CNO is null then AInfo.ValueDesc6 else CLInfo.ValueDesc6 end as ValueDesc6,              
  Case When CLInfo.CNO is null then AInfo.ValueDesc7 else CLInfo.ValueDesc7 end as ValueDesc7,              
  Case When CLInfo.CNO is null then AInfo.ValueDesc8 else CLInfo.ValueDesc8 end as ValueDesc8,              
  Case When CLInfo.CNO is null then AInfo.ValueDesc9 else CLInfo.ValueDesc9 end as ValueDesc9,              
  Case When CLInfo.CNO is null then AInfo.ValueDesc10 else CLInfo.ValueDesc10 end as ValueDesc10,            
  Case When CLInfo.CNO is null then AInfo.ValueDesc11 else CLInfo.ValueDesc11 end as ValueDesc11,              
  Case When CLInfo.CNO is null then AInfo.ValueDesc12 else CLInfo.ValueDesc12 end as ValueDesc12,              
  Case When CLInfo.CNO is null then AInfo.ValueDesc13 else CLInfo.ValueDesc13 end as ValueDesc13,              
  Case When CLInfo.CNO is null then AInfo.ValueDesc14 else CLInfo.ValueDesc14 end as ValueDesc14,              
  Case When CLInfo.CNO is null then AInfo.ValueDesc15 else CLInfo.ValueDesc15 end as ValueDesc15,              
  AINFO_EXT.ValueDesc16, 
  AINFO_EXT.ValueDesc17, 
  AINFO_EXT.ValueDesc18, 
  AINFO_EXT.ValueDesc19, 
  AINFO_EXT.ValueDesc20, 
  AINFO_EXT.ValueDesc21, 
  AINFO_EXT.ValueDesc22, 
  AINFO_EXT.ValueDesc23, 
  AINFO_EXT.ValueDesc24, 
  AINFO_EXT.ValueDesc25, 
  AINFO_EXT.ValueDesc26, 
  AINFO_EXT.ValueDesc27, 
  AINFO_EXT.ValueDesc28, 
  AINFO_EXT.ValueDesc29, 
  AINFO_EXT.ValueDesc30, 
  Acceptance.AName , Acceptance.CertificateNo, Acceptance.RefNo as ARefNo            
From CLAIM              
Inner Join Profile Payment on (Payment.ID=Claim.Payment)        
Left Join CLLoss on (CLLoss.CNO=Claim.CNO)
Left Join CLCOST on (CLCOST.CNO=Claim.CNO)
Left Join CLInfo on (CLInfo.CNO=Claim.CNO)        
Left Join Acceptance on (Acceptance.ANO=Claim.ANO)              
Left Join AInfo on (AInfo.ANO=Acceptance.ANO)              
Left Join Cover on (Cover.CNO=Acceptance.CNO)              
Left Join COLTab on (COLTAB.COL=Claim.COL)              
Left Join AINFO_EXT on (AINFO_EXT.ANO=Acceptance.ANO)
Where           
  (@Value1='%' or Claim.ClaimNo Like @Value1+'%')    
  And (@Value2='%' or Claim.PolicyNo Like @Value2+'%')    
  And (@Value5='%' or Claim.LossPlace Like @Value5+'%')    
  And (@Value7='%' or Claim.ClaimantInfo Like @Value7+'%' or exists (Select P.ID from CLLoss C, Profile P Where C.CNO=Claim.CNO and P.ID=C.Claimant and P.Name Like @Value7+'%'))      
  And (@Value8='%' or Payment.Name Like @Value8+'%' or exists (Select P.ID from CLLoss C, Profile P Where C.CNO=Claim.CNO and P.ID=C.Payment and P.Name Like @Value8+'%'))    
  And (@Value9='%' or Claim.EventName Like @Value9+'%')     
  And (@Value12='%' or Claim.Refno Like @Value12+'%' or CLLOSS.Refno Like @Value12+'%' or CLCOST.Refno Like @Value12+'%')    
  And (@Value10='%' or Claim.CType Like @Value10+'%')    
  And (@Value11='%' or Claim.CStatus Like @Value11+'%')    
  And ((Claim.LargeF=1 and @Value14='Large') or @Value14='')              
  And ((Claim.UniqueF=1 and @Value15='Unique') or @Value15='')              
  And (((Claim.TBAF_1=1 or Claim.TBAF_2=1) and @Value17='TBA') or @Value17='')              
  And ((Claim.SurveyF=1 and @Value18='Survey') or @Value18='')              
  And (@Value16='%' or Claim.TOC Like @Value16+'%')   
  And (@Value13='%' or CLLOSS.TOI Like @Value13+'%')    
  And (@Value6='%' or COLTAB.Description Like @Value6+'%')    
  And (@Value21='%' or COVER.RefNo Like @Value21+'%')    
)              

GO

if exists (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'MListQry_3b_a') AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) ) 
BEGIN DROP FUNCTION MListQry_3b_a
end
GO
CREATE function MListQry_3b_a (@value1 as varchar(255) ,@value2 as varchar(255) ,@value3 as varchar(255) ,@value4 as varchar(255) ,@value5 as varchar(255) ,@value6 as varchar(255) ,@value7 as varchar(255) ,@value8 as varchar(255) ,@value9 as varchar(255),@Value10 as varchar(255), @Value11 as varchar(255), @Value12 as varchar(255)) 
returns table
as return
(
SELECT               Cast(0 as bit) as ProcessFlag, 
              q.[COVERNO], 
              q.[Insured], 
              q.[CNO], 
              q.[CStatus], 
              q.VSeqNo, 
              q.[lANO], 
              q.[ANO], 
              q.[REGNO], 
              q.[ADATE], 
              q.[USERID], 
              q.[Currency], 
              q.[TSI], 
              q.[OurShare], 
              q.[Gross], 
              q.[ASTATUS], 
              q.[ATYPE], 
              q.[SDate], 
              q.[EDate], 
              q.RYear, 
              q.[ISType], 
              q.[Renewal], 
              q.[ESeqNo], 
              q.[PolicyNo],
              a.valueid1, a.valuedesc1,
              a.valueid2, a.valuedesc2,
              a.valueid3, a.valuedesc3,
              a.valueid4, a.valuedesc4,
              a.valueid5, a.valuedesc5,
              a.valueid6, a.valuedesc6,
              a.valueid7, a.valuedesc7,
              a.valueid8, a.valuedesc8,
              a.valueid9, a.valuedesc9,
              a.valueid10, a.valuedesc10,
              a.valueid11, a.valuedesc11,
              a.valueid12, a.valuedesc12,
              a.valueid13, a.valuedesc13,
              a.valueid14, a.valuedesc14,
              a.valueid15, a.valuedesc15,
              b.valueid16, b.valuedesc16,  
              b.valueid17, b.valuedesc17,  
              b.valueid18, b.valuedesc18,  
              b.valueid19, b.valuedesc19,  
              b.valueid20, b.valuedesc20,  
              b.valueid21, b.valuedesc21,  
              b.valueid22, b.valuedesc22,  
              b.valueid23, b.valuedesc23,  
              b.valueid24, b.valuedesc24,  
              b.valueid25, b.valuedesc25,  
              b.valueid26, b.valuedesc26,  
              b.valueid27, b.valuedesc27,  
              b.valueid28, b.valuedesc28,  
              b.valueid29, b.valuedesc29,  
              b.VALUEID30 , b.VALUEDESC30   
FROM        MListQry_3b(@Value1,@Value2,@Value3,@Value4,@Value5,@Value6,@Value7,@Value8,@Value9,@Value10,@Value11,@Value12) q, ainfo a Left Join Ainfo_Ext b on (b.ANO=a.ANO) 
WHERE q.ano = a.ano
)

GO

if exists (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'MList11E') AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) ) 
BEGIN DROP FUNCTION MList11E
end
GO
create function MList11E(@P_ANO AS INTEGER, @value1 as varchar(255) ,@value2 as varchar(255) ,@value3 as varchar(255) ,@value4 as varchar(255) ,@value5 as varchar(255) ,@value6 as varchar(255) ,@Value7 as varchar(255) ,@value8 as varchar(255) ,@value9 as varchar(255),@Value10 as varchar(255), @Value11 as varchar(255))  
returns table  
AS return  
(  
SELECT   
 Cast(0 as bit) as ProcessFlag,   
 Q.COVERNO,   
 Q.AName,   
 Q.CertificateNo,   
 Q.CNO,   
 Q.CStatus,   
 Q.VSeqNo,   
 Q.LANO,   
 Q.ANO,   
 Q.REGNO,   
 Q.ADATE,   
 Q.USERID,   
 Q.Currency,   
 Q.TSI,   
 Q.OurShare,   
 Q.Gross,   
 Q.ASTATUS,   
 Q.ATYPE,   
 Q.SDate,   
 Q.EDate,   
 Q.RYear,  
 A.VALUEID1, A.VALUEDESC1,  
 A.VALUEID2, A.VALUEDESC2,  
 A.VALUEID3, A.VALUEDESC3,  
 A.VALUEID4, A.VALUEDESC4,  
 A.VALUEID5, A.VALUEDESC5,  
 A.VALUEID6, A.VALUEDESC6,  
 A.VALUEID7, A.VALUEDESC7,  
 A.VALUEID8, A.VALUEDESC8,  
 A.VALUEID9, A.VALUEDESC9,  
 A.VALUEID10, A.VALUEDESC10,  
 A.VALUEID11, A.VALUEDESC11,  
 A.VALUEID12, A.VALUEDESC12,  
 A.VALUEID13, A.VALUEDESC13,  
 A.VALUEID14, A.VALUEDESC14,  
 A.VALUEID15, A.VALUEDESC15,
b.valueid16, b.valuedesc16,  
 b.valueid17, b.valuedesc17,  
 b.valueid18, b.valuedesc18,  
 b.valueid19, b.valuedesc19,  
 b.valueid20, b.valuedesc20,  
 b.valueid21, b.valuedesc21,  
 b.valueid22, b.valuedesc22,  
 b.valueid23, b.valuedesc23,  
 b.valueid24, b.valuedesc24,  
 b.valueid25, b.valuedesc25,  
 b.valueid26, b.valuedesc26,  
 b.valueid27, b.valuedesc27,  
 b.valueid28, b.valuedesc28,  
 b.valueid29, b.valuedesc29,  
 b.VALUEID30 , b.VALUEDESC30   
FROM MList11D(@P_ANO, @value1, @value2, @value3, @value4, @value5, @value6, @Value7, @value8, @value9, @Value10, @Value11) q, ainfo a Left Join Ainfo_Ext b on (b.ANO=a.ANO) 
WHERE Q.ANO = A.ANO  
)  
  
go

--2 AGST 2019 : Penambahan BizmapID di tampilan Polis
IF EXISTS ( SELECT * FROM   sysobjects WHERE  id = object_id(N'qPolicy_Data') and OBJECTPROPERTY(id, N'IsProcedure') = 1 )
 BEGIN DROP PROCEDURE  qPolicy_Data
end
GO
CREATE Procedure qPolicy_Data(@P_ANO integer)                                    
as                                    
SELECT                                    
C.CNO, C.COVERNO, A1.TOC, C.MO, C.SEGMENT, A1.Location, C.VALIDATION, C.REFNO as CREFNO, C.PRORATA, C.PHOLDER, C.PPERIOD, C.CStatus,                                    
A1.ASource, P.ID as PayorID, C.ISType, C.OpenFlag, C.Voyage, C.PolicyType, C.VSeqNo, C.TBAF,          
A1.ANO, A1.OANO, A1.LANO, A1.CANO, A1.PANO, A1.RANO, A1.REGNO, A1.REGDATE, A1.BRANCH, A1.CT, A1.AStatus, A1.ATYPE, A1.POLICYNO, A1.POLICYDATE, A1.CPOLICYNO, A1.REFNO, A1.REFDATE, A1.RENEWABLEF, A1.CONJUNCTIONF, A1.EXCLUSIVEF, 
A1.SDATE, A1.EDATE, A1.STIME, A1.ETIME,         
          
A1.REMARKS, A1.EXTPERIOD, A1.ExtPeriodInDaysF, A1.ADATE, A1.PDATE, A1.PPDATE, A1.AID, A1.ANAME, A1.BUSINESS, A1.TOPRO, A1.Ujroh, A1.WeightedAvgUjrohF,                           
A1.ESeqNo, A1.EESeqNo, A1.Renewal, A1.BatchNo, A1.BankersClause,               
C.PUserID, C.PUserDate, C.PUserTime,                           
C.AUSERID as CAUserID, C.AUserDate as CAUserDate, C.AUserTime as CAUserTime,                        
C.CUSERID as CCUserID, C.CLOSEDATE as CCLOSEDATE, C.CloseTime as CCloseTime,    
A1.UserID, A1.CDate, A1.CTime,                                   
A1.CUserID, A1.CloseDate, A1.CloseTime,                             
A1.LUSERID, A1.LDate, A1.LTime,     
A1.AUSERID, A1.AUserDate, A1.AUserTime,                
CACCEPTANCE.REGNO as CREGNO,              
CCOVER.COVERNO AS CCOVERNO, A1.PWordingID,                   
A1.CPCT, A1.SYSUSERID, A1.BizMapID,            
Interest.Currency, Interest.TSI, Interest.ATSI,          
ICoverPol.CURRENCY as Currency_POL, ICoverPol.Amount as Amount_POL,
A2.FLDID1, A2.VALUEID1, A2.VALUEDESC1, 0 as FLDSEARCH1,                                    
A2.FLDID2, A2.VALUEID2, A2.VALUEDESC2, 0 as FLDSEARCH2,                                    
A2.FLDID3, A2.VALUEID3, A2.VALUEDESC3, 0 as FLDSEARCH3,                                    
A2.FLDID4, A2.VALUEID4, A2.VALUEDESC4, 0 as FLDSEARCH4,                                    
A2.FLDID5, A2.VALUEID5, A2.VALUEDESC5, 0 as FLDSEARCH5,                                    
A2.FLDID6, A2.VALUEID6, A2.VALUEDESC6, 0 as FLDSEARCH6,                                    
A2.FLDID7, A2.VALUEID7, A2.VALUEDESC7, 0 as FLDSEARCH7,                                    
A2.FLDID8, A2.VALUEID8, A2.VALUEDESC8, 0 as FLDSEARCH8,                                    
A2.FLDID9, A2.VALUEID9, A2.VALUEDESC9, 0 as FLDSEARCH9,                                    
A2.FLDID10, A2.VALUEID10, A2.VALUEDESC10, 0 as FLDSEARCH10,                                    
A2.FLDID11, A2.VALUEID11, A2.VALUEDESC11, 0 as FLDSEARCH11,                                    
A2.FLDID12, A2.VALUEID12, A2.VALUEDESC12, 0 as FLDSEARCH12,                                    
A2.FLDID13, A2.VALUEID13, A2.VALUEDESC13, 0 as FLDSEARCH13,                                    
A2.FLDID14, A2.VALUEID14, A2.VALUEDESC14, 0 as FLDSEARCH14,                                    
A2.FLDID15, A2.VALUEID15, A2.VALUEDESC15, 0 as FLDSEARCH15                                    
FROM COVER C                        
INNER JOIN ACCEPTANCE A1 ON (C.CNO=A1.CNO)                         
INNER JOIN PAYOR P on (P.ANO=A1.ANO)
LEFT JOIN ACCEPTANCE CACCEPTANCE ON (CACCEPTANCE.ANO=A1.CANO)                        
LEFT JOIN COVER CCOVER ON (CCOVER.CNO=CACCEPTANCE.CNO)                        
Left Join AINFO A2 On (A2.ANO=A1.ANO)                         
Left Join FN_SumInsured(@P_ANO) Interest On (Interest.ANO=A1.ANO and Interest.TSI<>0)                              
Left Join ICoverPOL on (ICoverPOL.ANO=A1.ANO)
WHERE A1.ANO=@P_ANO 

GO
IF EXISTS ( SELECT * FROM   sysobjects WHERE  id = object_id(N'QCertificate_Data') and OBJECTPROPERTY(id, N'IsProcedure') = 1 ) 
BEGIN DROP PROCEDURE  QCertificate_Data
end
GO
CREATE Procedure QCertificate_Data(@P_ANO integer)                                  
as                                  
SELECT                                  
A1.ANO, C.CNO, A1.OANO, A1.LANO, A1.CANO, A1.RANO, A1.REGNO, A1.REGDATE, A1.BRANCH, A1.CT, A1.ATYPE, A1.AStatus, A1.POLICYNO, A1.CERTIFICATENO, A1.POLICYDATE, A1.CPOLICYNO, A1.REFNO, A1.REFDATE, A1.RENEWABLEF, A1.CONJUNCTIONF, A1.EXCLUSIVEF, 
C.COVERNO, C.SEGMENT, C.ISType, C.OpenFlag, C.Voyage, C.PolicyType,
A1.SDATE, A1.EDATE, A1.STIME, A1.ETIME,           
A1.NCDate,            
A1.EXTPERIOD, A1.EXTPERIODINDAYSF,            
A1.ASource, A1.TOC, C.MO, A1.Location,                   
A1.Remarks, A1.ADate, A1.PDate, A1.PPDate, A1.AID, A1.ANAME,A1.BUSINESS, A1.DISCOUNT, A1.QTY, A1.TOPRO, A1.Ujroh, A1.WeightedAvgUjrohF,      
A1.ESeqNo, A1.EESeqNo, A1.Renewal, A1.BatchNo, A1.BankersClause,         
A1.UserID, A1.CDate, A1.CTime,                                   
A1.CUserID, A1.CloseDate, A1.CloseTime,                             
A1.LUSERID, A1.LDate, A1.LTime,     
A1.AUSERID, A1.AUserDate, A1.AUserTime,                  
CACCEPTANCE.REGNO as CREGNO, 
CCOVER.COVERNO AS CCOVERNO, A1.PWordingID,     
A1.CPCT, A1.SYSUSERID, A1.BizMapID,
Interest.Currency, Interest.TSI, Interest.ATSI,                            
A2.FLDID1, A2.VALUEID1, A2.VALUEDESC1, 0 as FLDSEARCH1,                                  
A2.FLDID2, A2.VALUEID2, A2.VALUEDESC2, 0 as FLDSEARCH2,                                  
A2.FLDID3, A2.VALUEID3, A2.VALUEDESC3, 0 as FLDSEARCH3,                                  
A2.FLDID4, A2.VALUEID4, A2.VALUEDESC4, 0 as FLDSEARCH4,                                  
A2.FLDID5, A2.VALUEID5, A2.VALUEDESC5, 0 as FLDSEARCH5,                                  
A2.FLDID6, A2.VALUEID6, A2.VALUEDESC6, 0 as FLDSEARCH6,                                  
A2.FLDID7, A2.VALUEID7, A2.VALUEDESC7, 0 as FLDSEARCH7,                                  
A2.FLDID8, A2.VALUEID8, A2.VALUEDESC8, 0 as FLDSEARCH8,                                  
A2.FLDID9, A2.VALUEID9, A2.VALUEDESC9, 0 as FLDSEARCH9,                                  
A2.FLDID10, A2.VALUEID10, A2.VALUEDESC10, 0 as FLDSEARCH10,                                  
A2.FLDID11, A2.VALUEID11, A2.VALUEDESC11, 0 as FLDSEARCH11,                                  
A2.FLDID12, A2.VALUEID12, A2.VALUEDESC12, 0 as FLDSEARCH12,                                  
A2.FLDID13, A2.VALUEID13, A2.VALUEDESC13, 0 as FLDSEARCH13,                                  
A2.FLDID14, A2.VALUEID14, A2.VALUEDESC14, 0 as FLDSEARCH14,                                  
A2.FLDID15, A2.VALUEID15, A2.VALUEDESC15, 0 as FLDSEARCH15              
FROM ACCEPTANCE A1                     
Inner Join Cover C On (C.CNO=A1.CNO)                 
LEFT JOIN ACCEPTANCE CACCEPTANCE ON (CACCEPTANCE.ANO=A1.CANO)                    
LEFT JOIN COVER CCOVER ON (CCOVER.CNO=CACCEPTANCE.CNO)                    
Left Join AINFO A2 On (A2.ANO=A1.ANO)                     
Left Join FN_SumInsured(@P_ANO) Interest On (Interest.ANO=A1.ANO and Interest.TSI<>0)                            
WHERE A1.ANO=@P_ANO       

GO

if exists (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'fn_BizMap') AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) )
 BEGIN DROP FUNCTION fn_BizMap
end
GO
CREATE Function fn_BizMap(@P_ANO as int, @P_Source as varchar(10)='') 
RETURNS VarChar(10) 
AS 
 
BEGIN 
Declare @CType varchar(20) 
Declare @PType varchar(20) 
Declare @IType varchar(10) 
Declare @CGroup varchar(10) 
Declare @Segment varchar(10) 
Declare @ISType varchar(10) 
Declare @Payor_LOB varchar(10) 
Declare @PHolder_LOB varchar(10) 
Declare @Insured_LOB varchar(10) 
Declare @Source_LOB varchar(10) 
Declare @SegmentGroup varchar(10) 
Declare @BizmapID varchar(10) 
Declare @ID varchar(10) 
 
if @P_ANO>0 
Begin 
        if @P_Source='' 
        Begin 
         Select 
         @CType=Source.CType, 
         @PType=case When Source.PType='C' Then 'CAPTIVE' When Source.PType='D' Then 'DIRECT INSURED' else 'OTHERS' end, 
         @IType=I.IType, 
         @CGroup=PHolder.CGroup, 
         @Segment=C.Segment, 
         @ISType=C.ISType, 
         @Payor_LOB=Payor.LOB, 
         @PHolder_LOB=PHolder.LOB, 
         @Insured_LOB=Insured.LOB, 
         @Source_LOB=Source.LOB, 
         @SegmentGroup=SegmentGroup.SegmentGroup, 
         @BizmapID=A.BizmapID
         from Cover C 
         Left Join Segment on (Segment.Segment=C.Segment) 
         Left join SegmentGroup on (Segment.SegmentGroup=SegmentGroup.SegmentGroup) 
         Left Join InParty I On (I.CNO=C.CNO), Acceptance A, Payor APayor, Profile Payor, Profile Insured, Profile Source, Profile  PHolder Left Join CGroup on (CGroup.CGroup=PHolder.CGroup) 
         Where C.CNO=A.CNO and (APayor.ANO=A.LANO or APayor.ANO=A.ANO) and Payor.ID=APayor.ID and PHolder.ID=C.PHolder and Insured.ID=A.AID and Source.ID=A.Source and A.ANO=@P_ANO 
        End 
        Else 
        Begin 
         Select 
         @CType=Source.CType, 
         @PType=case When Source.PType='C' Then 'CAPTIVE' When Source.PType='D' Then 'DIRECT INSURED' else 'OTHERS' end, 
         @IType=I.IType, 
         @CGroup=PHolder.CGroup, 
         @Segment=C.Segment, 
         @ISType=C.ISType, 
         @Payor_LOB=Payor.LOB, 
         @PHolder_LOB=PHolder.LOB, 
         @Insured_LOB=Insured.LOB, 
         @Source_LOB=Source.LOB, 
         @SegmentGroup=SegmentGroup.SegmentGroup 
         from Cover C 
         Left Join Segment on (Segment.Segment=C.Segment) 
         Left join SegmentGroup on (Segment.SegmentGroup=SegmentGroup.SegmentGroup) 
         Left Join InParty I On (I.CNO=C.CNO), Acceptance A, Payor APayor, Profile Payor, Profile Insured, Profile Source, Profile  PHolder Left Join CGroup on (CGroup.CGroup=PHolder.CGroup) 
         Where C.CNO=A.CNO and (APayor.ANO=A.LANO or APayor.ANO=A.ANO) and Payor.ID=APayor.ID and PHolder.ID=C.PHolder and Insured.ID=A.AID and Source.ID=@P_Source and A.ANO=@P_ANO 
        End 
End 
ELSE 
BEGIN 
       SELECT 
              @CType=Source.CType, 
              @PType=case When Source.PType='C' Then 'CAPTIVE' When Source.PType='D' Then 'DIRECT INSURED' else 'OTHERS' end, 
              @Source_LOB=Source.LOB, 
              @Segment='DIRECT', 
           @ISType='I' 
       from Profile Source 
       Where Source.ID=@P_Source  
END 
 
Select Top 1 @ID=B.ID 
from BizMap B 
Where b.Post_Flag = 1 and b.AllowedF=1
and (CType='<ANY>' or CType=@CType) 
and (PType='<ANY>' or PType=@PType) 
and (IType='<ANY>' or IType=@IType) 
and (Cgroup='<ANY>' or CGroup=@CGroup) 
and (Segment='<ANY>' or Segment=@Segment) 
and (ISType='<ANY>' or ISType=@ISType) 
and (Payor_LOB='<ANY>' or Payor_LOB=@Payor_LOB) 
and (PHolder_LOB='<ANY>' or PHolder_LOB=@PHolder_LOB) 
and (Insured_LOB='<ANY>' or Insured_LOB=@Insured_LOB) 
and (Source_LOB='<ANY>' or Source_LOB=@Source_LOB) 
and (SegmentGroup='<ANY>' or SegmentGroup=SegmentGroup) 
Order By OrderNo, ID 

return(coalesce(@ID,@BizMapID)) 
End 


GO

--Update 31 jul 2019
IF  NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'CSTALLOCATIONH') AND type in (N'U'))
begin
CREATE TABLE CSTALLOCATIONH
	(
	Branch varchar(10) NULL,
	Account varchar(10) NULL,
	AMethod varchar(10) NULL,
	TotalUnit FLoat NULL,
	Last_Opr varchar(50) NULL,
	Last_Update smalldatetime NULL
	)  ON [PRIMARY]
DECLARE @v sql_variant 
SET @v = N'Allocation Method (''DIRECT'',''BYPCTSQM'',''BYHEADCNT'')'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'CSTALLOCATIONH', N'COLUMN', N'AMethod'
CREATE UNIQUE INDEX I_CSTALLOCATIONH ON CSTALLOCATIONH
	(
	Branch,
	Account
	) WITH( STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
ALTER TABLE CSTALLOCATIONH SET (LOCK_ESCALATION = TABLE)
END
GO

IF  NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'CSTALLOCATIOND') AND type in (N'U'))
begin
CREATE TABLE CSTALLOCATIOND
	(
	Branch varchar(10) NULL,
	Account varchar(10) NULL,
	CT varchar(10) NULL,
	NumUnit float(53) NULL
	)  ON [PRIMARY]
CREATE UNIQUE INDEX I_CSTALLOCATIOND ON CSTALLOCATIOND
	(
	Branch, Account, CT
	) WITH( STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
ALTER TABLE CSTALLOCATIOND SET (LOCK_ESCALATION = TABLE)
ALTER TABLE CSTALLOCATIOND  WITH NOCHECK ADD  CONSTRAINT FK_CSTALLOCATIOND_CSTALLOCATIONH FOREIGN KEY(Branch,Account)
REFERENCES CSTALLOCATIONH (Branch,Account)
ON UPDATE CASCADE
ON DELETE CASCADE
END
GO

--5 Agst 2019

IF NOT EXISTS(SELECT * FROM SYSFORM WHERE FNAME='FORCEUSECSTALLOCATION')
BEGIN
insert into sysform(FName, Description, FCode, RequestF) Select 'FORCEUSECSTALLOCATION','FORCE USE COST ALLOCATION TABLE','ACTIVITIES',0
END
GO
if exists (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'FL_UserBranchAccountIO') AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) )
 BEGIN DROP FUNCTION FL_UserBranchAccountIO
end
GO
Create function FL_UserBranchAccountIO(@P_USERID varchar(50), @P_Branch varchar(10), @P_Account varchar(10), @P_DebtorF Bit)            
RETURNS Table              
AS RETURN              
(            
SELECT Branch.Branch, Branch.Name, Branch.Active_Flag, Branch.ShariaF, 
Case When Type.PL_Flag=1 and Type.Type=5 and dbo.GetPrivileges(@P_UserID,'FORCEUSECSTALLOCATION')=1 Then
	(Select Top 1 CT from CSTALLOCATIOND C Where C.Branch=Branch.Branch and C.Account=@P_Account) 
Else
	(Select Top 1 CT from CT Where CT.Branch=Branch.Branch) 
End as CT
from Branch, SysUser, Account, Type          
Where SysUser.ID=@P_UserID and Account.Account=@P_Account and Account.Inter_Flag=1 and Type.Type=Account.Type       
and Branch.Branch Like @P_Branch+'%' and Branch.Op_Flag=1       
and (
SysUser.Type='SUPERVISOR' or 
	(
	EXISTS (
		Select S.Branch 
		from SysUserBranch S 
		Where S.Branch=Branch.Branch and S.ID=SysUser.ID
		and (
			(Type.PL_Flag=1 and S.IncomeReceiveF=1 and @P_DebtorF=1) or 
			(Type.PL_Flag=1 and S.ExpensePaymentF=1 and @P_DebtorF=0) or 
			(Type.BS_Flag=1 and S.SuspendReceiveF=1 and @P_DebtorF=1) or 
			(Type.BS_Flag=1 and S.SuspendPaymentF=1 and @P_DebtorF=0))
			)
	 and (not(Type.PL_Flag=1 and Type.Type=5) or dbo.GetPrivileges(@P_UserID,'FORCEUSECSTALLOCATION')=0 or EXISTS (Select C.Account from CSTALLOCATIONH C Where C.Branch=Branch.Branch and C.Account=Account.Account))
	)
)        

)      

GO

if exists (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'FN_UserCT') AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) )
 BEGIN DROP FUNCTION FN_UserCT
end
GO
Create function FN_UserCT(@P_USERID varchar(50), @P_Branch varchar(10), @P_Account varchar(10))  
RETURNS Table    
AS RETURN    
(  
SELECT CT.*
from CT
Inner Join SysUser on (SysUser.ID=@P_UserID)
Left Join Account on (Account.Account=@P_Account)
Left Join Type on (Type.Type=Account.Type)
Where (CT.Branch is null or CT.Branch='' or CT.Branch=@P_Branch)
and (
	SysUser.Type='SUPERVISOR' or 
	(not(coalesce(Type.PL_Flag,0)=1 and coalesce(Type.Type,0)=5) or dbo.GetPrivileges(@P_UserID,'FORCEUSECSTALLOCATION')=0 or EXISTS (Select C.Account from CSTALLOCATIOND C Where C.Branch=@P_Branch and C.Account=@P_Account and C.CT=CT.CT))
)        

)  


GO


if exists (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'FL_UserAccount') AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) ) 
BEGIN DROP FUNCTION FL_UserAccount
end
GO
Create function FL_UserAccount(@P_USERID varchar(50), @P_Branch varchar(10), @P_Account varchar(10))            
RETURNS Table              
AS RETURN              
(            

Select Account.Account, Account.Description, Systab.Currency, Account.AccGroup, Account.Hold_Flag,
Case When Type.PL_Flag=1 and Type.Type=5 and dbo.GetPrivileges(@P_UserID,'FORCEUSECSTALLOCATION')=1 Then
	(Select Top 1 CT from CSTALLOCATIOND C Where C.Branch=@P_Branch and C.Account=Account.Account) 
Else
	(Select Top 1 CT from CT Where CT.Branch=@P_Branch) 
End as CT
from Account
Inner Join SysTab on (1=1)
Inner Join SysUser on (SysUser.ID=@P_UserID)
Inner Join Type on (Type.type=Account.Type)
Where
(
	SysUser.Type='SUPERVISOR' or 
	(not(Type.PL_Flag=1 and Type.Type=5) or dbo.GetPrivileges(@P_UserID,'FORCEUSECSTALLOCATION')=0 or EXISTS (Select C.Account from CSTALLOCATIONH C Where C.Branch=@P_Branch and C.Account=Account.Account))
)   
and Account.Account Like @P_Account+'%' and Account.Post_Flag=1 and Account.AllowedF=1
)


go

--9 Agst 2019
Alter Table Profile Alter Column XProfileID varchar(100)
go

IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'LIMIT' AND Object_ID = Object_ID(N'FSecurity'))
BEGIN
ALTER TABLE FSecurity ADD
	LIMIT float(53) NULL
DECLARE @v sql_variant 
SET @v = N'Total Limit Of Liability'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'FSecurity', N'COLUMN', N'LIMIT'
END
GO


IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'EXCESS' AND Object_ID = Object_ID(N'FSecurity'))
BEGIN
ALTER TABLE FSecurity ADD
	EXCESS float(53) NULL
DECLARE @v sql_variant 
SET @v = N'In Excess Of '
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'FSecurity', N'COLUMN', N'EXCESS'
END
GO

IF  NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'ObjectRegister') AND type in (N'U'))
BEGIN
CREATE TABLE ObjectRegister(
	[ObjID] int NOT NULL,
	TOC varchar(10) NULL,
	RestrictedF Bit NULL,
	FLDID1 varchar(10) NULL,
	VALUEID1 varchar(15) NULL,
	VALUEDESC1 varchar(255) NULL,
	FLDID2 varchar(10) NULL,
	VALUEID2 varchar(15) NULL,
	VALUEDESC2 varchar(255) NULL,
	FLDID3 varchar(10) NULL,
	VALUEID3 varchar(15) NULL,
	VALUEDESC3 varchar(255) NULL,
	FLDID4 varchar(10) NULL,
	VALUEID4 varchar(15) NULL,
	VALUEDESC4 varchar(255) NULL,
	FLDID5 varchar(10) NULL,
	VALUEID5 varchar(15) NULL,
	VALUEDESC5 varchar(255) NULL,
	FLDID6 varchar(10) NULL,
	VALUEID6 varchar(15) NULL,
	VALUEDESC6 varchar(255) NULL,
	FLDID7 varchar(10) NULL,
	VALUEID7 varchar(15) NULL,
	VALUEDESC7 varchar(255) NULL,
	FLDID8 varchar(10) NULL,
	VALUEID8 varchar(15) NULL,
	VALUEDESC8 varchar(255) NULL,
	FLDID9 varchar(10) NULL,
	VALUEID9 varchar(15) NULL,
	VALUEDESC9 varchar(255) NULL,
	FLDID10 varchar(10) NULL,
	VALUEID10 varchar(15) NULL,
	VALUEDESC10 varchar(255) NULL,
	FLDID11 varchar(10) NULL,
	VALUEID11 varchar(15) NULL,
	VALUEDESC11 varchar(255) NULL,
	FLDID12 varchar(10) NULL,
	VALUEID12 varchar(15) NULL,
	VALUEDESC12 varchar(255) NULL,
	FLDID13 varchar(10) NULL,
	VALUEID13 varchar(15) NULL,
	VALUEDESC13 varchar(255) NULL,
	FLDID14 varchar(50) NULL,
	VALUEID14 varchar(15) NULL,
	VALUEDESC14 varchar(255) NULL,
	FLDID15 varchar(10) NULL,
	VALUEID15 varchar(15) NULL,
	VALUEDESC15 varchar(255) NULL,
	Last_Opr varchar(50) NULL,
	Last_Update smalldatetime NULL,
 CONSTRAINT I_ObjectRegister PRIMARY KEY CLUSTERED 
(
	[ObjID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
ALTER TABLE ObjectRegister  WITH NOCHECK ADD  CONSTRAINT FK_ObjectRegister_TOC FOREIGN KEY(TOC)
REFERENCES TOC (TOC)
ON UPDATE CASCADE
ON DELETE CASCADE
ALTER TABLE ObjectRegister CHECK CONSTRAINT FK_ObjectRegister_TOC
END
GO



IF EXISTS ( SELECT * FROM   sysobjects WHERE  id = object_id(N'QGet_Object_Restriction') and OBJECTPROPERTY(id, N'IsProcedure') = 1 ) 
BEGIN DROP PROCEDURE  QGet_Object_Restriction
end
GO
CREATE Procedure QGet_Object_Restriction(@P_ANO as integer)
AS

SELECT top 1 ObjectRegister.RestrictedF, 'Restricted Object Register, Policy No : ' + Acceptance.PolicyNo + '-' + Acceptance.CertificateNo as Remarks
From Acceptance
Inner Join AInfo on (AInfo.ANO=Acceptance.ANO)
Inner Join ObjectRegister on (
	ObjectRegister.TOC=Acceptance.TOC        
	And ((ObjectRegister.ValueID1='' and Ainfo.ValueDesc1 Like ObjectRegister.ValueDesc1+'%') or (ObjectRegister.ValueID1<>'' and AInfo.ValueID1 Like ObjectRegister.ValueID1+'%') or (ObjectRegister.ValueID1 is null))                    
	And ((ObjectRegister.ValueID2='' and Ainfo.ValueDesc2 Like ObjectRegister.ValueDesc2+'%') or (ObjectRegister.ValueID2<>'' and AInfo.ValueID2 Like ObjectRegister.ValueID2+'%') or (ObjectRegister.ValueID2 is null))                    
	And ((ObjectRegister.ValueID3='' and Ainfo.ValueDesc3 Like ObjectRegister.ValueDesc3+'%') or (ObjectRegister.ValueID3<>'' and AInfo.ValueID3 Like ObjectRegister.ValueID3+'%') or (ObjectRegister.ValueID3 is null))                    
	And ((ObjectRegister.ValueID4='' and Ainfo.ValueDesc4 Like ObjectRegister.ValueDesc4+'%') or (ObjectRegister.ValueID4<>'' and AInfo.ValueID4 Like ObjectRegister.ValueID4+'%') or (ObjectRegister.ValueID4 is null))                    
	And ((ObjectRegister.ValueID5='' and Ainfo.ValueDesc5 Like ObjectRegister.ValueDesc5+'%') or (ObjectRegister.ValueID5<>'' and AInfo.ValueID5 Like ObjectRegister.ValueID5+'%') or (ObjectRegister.ValueID5 is null))                    
	And ((ObjectRegister.ValueID6='' and Ainfo.ValueDesc6 Like ObjectRegister.ValueDesc6+'%') or (ObjectRegister.ValueID6<>'' and AInfo.ValueID6 Like ObjectRegister.ValueID6+'%') or (ObjectRegister.ValueID6 is null))                    
	And ((ObjectRegister.ValueID7='' and Ainfo.ValueDesc7 Like ObjectRegister.ValueDesc7+'%') or (ObjectRegister.ValueID7<>'' and AInfo.ValueID7 Like ObjectRegister.ValueID7+'%') or (ObjectRegister.ValueID7 is null))                    
	And ((ObjectRegister.ValueID8='' and Ainfo.ValueDesc8 Like ObjectRegister.ValueDesc8+'%') or (ObjectRegister.ValueID8<>'' and AInfo.ValueID8 Like ObjectRegister.ValueID8+'%') or (ObjectRegister.ValueID8 is null))                    
	And ((ObjectRegister.ValueID9='' and Ainfo.ValueDesc9 Like ObjectRegister.ValueDesc9+'%') or (ObjectRegister.ValueID9<>'' and AInfo.ValueID9 Like ObjectRegister.ValueID9+'%') or (ObjectRegister.ValueID9 is null))                    
	And ((ObjectRegister.ValueID10='' and Ainfo.ValueDesc10 Like ObjectRegister.ValueDesc10+'%') or (ObjectRegister.ValueID10<>'' and AInfo.ValueID10 Like ObjectRegister.ValueID10+'%') or (ObjectRegister.ValueID10 is null))                    
	And ((ObjectRegister.ValueID11='' and Ainfo.ValueDesc11 Like ObjectRegister.ValueDesc11+'%') or (ObjectRegister.ValueID11<>'' and AInfo.ValueID11 Like ObjectRegister.ValueID11+'%') or (ObjectRegister.ValueID11 is null))                    
	And ((ObjectRegister.ValueID12='' and Ainfo.ValueDesc12 Like ObjectRegister.ValueDesc12+'%') or (ObjectRegister.ValueID12<>'' and AInfo.ValueID12 Like ObjectRegister.ValueID12+'%') or (ObjectRegister.ValueID12 is null))                    
	And ((ObjectRegister.ValueID13='' and Ainfo.ValueDesc13 Like ObjectRegister.ValueDesc13+'%') or (ObjectRegister.ValueID13<>'' and AInfo.ValueID13 Like ObjectRegister.ValueID13+'%') or (ObjectRegister.ValueID13 is null))                    
	And ((ObjectRegister.ValueID14='' and Ainfo.ValueDesc14 Like ObjectRegister.ValueDesc14+'%') or (ObjectRegister.ValueID14<>'' and AInfo.ValueID14 Like ObjectRegister.ValueID14+'%') or (ObjectRegister.ValueID14 is null))     
	And ((ObjectRegister.ValueID15='' and Ainfo.ValueDesc15 Like ObjectRegister.ValueDesc15+'%') or (ObjectRegister.ValueID15<>'' and AInfo.ValueID15 Like ObjectRegister.ValueID15+'%') or (ObjectRegister.ValueID15 is null))      
)
WHERE Acceptance.ANO=@P_ANO

Union All

Select Top 1 Cast(1 as Bit) as RestrictedF, 'Insured Object already has Total Loss, Policy No : ' + A2.PolicyNo + '-' + A2.CertificateNo as Remarks
from Acceptance A1, Acceptance A2, Claim C1
Where A1.ANO=@P_ANO 
and A2.ANO<>A2.LANO and A2.OANO<>A1.OANO and A1.RegID=A2.RegID and A1.FLDID=A2.FLDID and A1.VALUEID=A2.VALUEID and A1.VALUEDESC=A2.VALUEDESC
and A2.ANO=C1.ANO 
and C1.CType not in ('C') and (C1.CStatus in ('P','T','A') or C1.PCStatus in ('A')) and not exists (Select pCNO from Claim Where Claim.pCNO=C1.CNO and Claim.CStatus<>'R')
and Exists (Select TOP 1 CNO from CLLOSS Where CLLOSS.CNO=C1.CNO and CLLOSS.CTLF=1)

Union All

Select Top 1 Cast(1 as Bit) as RestrictedF, 'Insured Object is already registered, Policy No : ' + A2.PolicyNo + '-' + A2.CertificateNo as Remarks
from Acceptance A1, Cover C1, Acceptance A2, Cover C2
Where A1.ANO=@P_ANO and C1.CNO=A1.CNO 
and A2.ANO<>A2.LANO and A2.RANO=-1 and A2.OANO<>A1.OANO and C2.CNO=A2.CNO 
and A2.AType in ('N','E') and A2.AStatus not in ('W','T')
and Not Exists (Select Top 1 pANO from Acceptance A3 WHere A3.pANO=A2.ANO and A3.AType<>'A')
and A1.RegID=A2.RegID and A1.FLDID=A2.FLDID and A1.VALUEID=A2.VALUEID and A1.VALUEDESC=A2.VALUEDESC
and C1.PHolder=C2.PHolder and C1.TOC=C2.TOC and A2.SDate=A1.EDate

go

--20 agustus 2019 : update Websetup Object Register

IF EXISTS ( SELECT * FROM   sysobjects WHERE  id = object_id(N'[Q_TOC_ObjectRegister]') and OBJECTPROPERTY(id, N'IsProcedure') = 1 ) BEGIN DROP PROCEDURE  
[dbo].[Q_TOC_ObjectRegister]
end
go

Create procedure [dbo].[Q_TOC_ObjectRegister] (@ObjID Varchar(10))
as
SELECT  TOP 1   
ObjectRegister.ObjID, ObjectRegister.TOC,

 isnull(ObjectRegister.FLDID1, '') AS FLDID1,isnull(ObjectRegister.VALUEID1, '') AS VALUEID1,isnull(ObjectRegister.VALUEDESC1, '') AS VALUEDESC1, isnull(GENHTAB_1.FLDTAB, 0) AS FLDTAB1, isnull(GENHTAB_1.FLDCOM, 0) AS FLDCOM1, isnull(GENHTAB_1.FLDDFORMAT, '') AS FLDDFORMAT1, isnull(GENHTAB_1.FLDIFORMAT, '') AS FLDIFORMAT1, isnull(GENHTAB_1.FLDTYPE, '') AS FLDTYPE1, isnull(GENHTAB_1.SUBLINKF, 0) AS SUBLINKF1,  isnull(GENHTAB_1.FLDSEARCH, '') AS FLDSEARCH1, isnull(GENHTAB_1.FLDCRITERIA, 0) AS FLDCRITERIA1, isnull(GENHTAB_1.FLDVALUATION, 0) AS FLDVALUATION1, isnull(GENHTAB_1.FLDCHGINF,0) as FLDCHGINF1,isnull(GENHTAB_1.FLDTAG,'') AS FLDTAG1,
 isnull(ObjectRegister.FLDID2, '') AS FLDID2,isnull(ObjectRegister.VALUEID2, '') AS VALUEID2,isnull(ObjectRegister.VALUEDESC2, '') AS VALUEDESC2, isnull(GENHTAB_2.FLDTAB, 0) AS FLDTAB2, isnull(GENHTAB_2.FLDCOM, 0) AS FLDCOM2, isnull(GENHTAB_2.FLDDFORMAT, '') AS FLDDFORMAT2, isnull(GENHTAB_2.FLDIFORMAT, '') AS FLDIFORMAT2, isnull(GENHTAB_2.FLDTYPE, '') AS FLDTYPE2, isnull(GENHTAB_2.SUBLINKF, 0) AS SUBLINKF2,  isnull(GENHTAB_2.FLDSEARCH, '') AS FLDSEARCH2, isnull(GENHTAB_2.FLDCRITERIA, 0) AS FLDCRITERIA2, isnull(GENHTAB_2.FLDVALUATION, 0) AS FLDVALUATION2, isnull(GENHTAB_2.FLDCHGINF,0) as FLDCHGINF2,isnull(GENHTAB_2.FLDTAG,'') AS FLDTAG2,    
 isnull(ObjectRegister.FLDID3, '') AS FLDID3,isnull(ObjectRegister.VALUEID3, '') AS VALUEID3,isnull(ObjectRegister.VALUEDESC3, '') AS VALUEDESC3,isnull(GENHTAB_3.FLDTAB, 0) AS FLDTAB3, isnull(GENHTAB_3.FLDCOM, 0) AS FLDCOM3, isnull(GENHTAB_3.FLDDFORMAT, '') AS FLDDFORMAT3, isnull(GENHTAB_3.FLDIFORMAT, '') AS FLDIFORMAT3, isnull(GENHTAB_3.FLDTYPE, '') AS FLDTYPE3, isnull(GENHTAB_3.SUBLINKF, 0) AS SUBLINKF3,  isnull(GENHTAB_3.FLDSEARCH, '') AS FLDSEARCH3, isnull(GENHTAB_3.FLDCRITERIA, 0) AS FLDCRITERIA3, isnull(GENHTAB_3.FLDVALUATION, 0) AS FLDVALUATION3, isnull(GENHTAB_3.FLDCHGINF,0) as FLDCHGINF3,isnull(GENHTAB_3.FLDTAG,'') AS FLDTAG3,
 isnull(ObjectRegister.FLDID4, '') AS FLDID4,isnull(ObjectRegister.VALUEID4, '') AS VALUEID4,isnull(ObjectRegister.VALUEDESC4, '') AS VALUEDESC4,isnull(GENHTAB_4.FLDTAB, 0) AS FLDTAB4, isnull(GENHTAB_4.FLDCOM, 0) AS FLDCOM4, isnull(GENHTAB_4.FLDDFORMAT, '') AS FLDDFORMAT4, isnull(GENHTAB_4.FLDIFORMAT, '') AS FLDIFORMAT4, isnull(GENHTAB_4.FLDTYPE, '') AS FLDTYPE4, isnull(GENHTAB_4.SUBLINKF, 0) AS SUBLINKF4,  isnull(GENHTAB_4.FLDSEARCH, '') AS FLDSEARCH4, isnull(GENHTAB_4.FLDCRITERIA, 0) AS FLDCRITERIA4, isnull(GENHTAB_4.FLDVALUATION, 0) AS FLDVALUATION4,isnull(GENHTAB_4.FLDCHGINF,0) as FLDCHGINF4,isnull(GENHTAB_4.FLDTAG,'') AS FLDTAG4,   
 isnull(ObjectRegister.FLDID5, '') AS FLDID5,isnull(ObjectRegister.VALUEID5, '') AS VALUEID5,isnull(ObjectRegister.VALUEDESC5, '') AS VALUEDESC5, isnull(GENHTAB_5.FLDTAB, 0) AS FLDTAB5, isnull(GENHTAB_5.FLDCOM, 0) AS FLDCOM5, isnull(GENHTAB_5.FLDDFORMAT, '') AS FLDDFORMAT5, isnull(GENHTAB_5.FLDIFORMAT, '') AS FLDIFORMAT5, isnull(GENHTAB_5.FLDTYPE, '') AS FLDTYPE5, isnull(GENHTAB_5.SUBLINKF, 0) AS SUBLINKF5,  isnull(GENHTAB_5.FLDSEARCH, '') AS FLDSEARCH5, isnull(GENHTAB_5.FLDCRITERIA, 0) AS FLDCRITERIA5, isnull(GENHTAB_5.FLDVALUATION, 0) AS FLDVALUATION5, isnull(GENHTAB_5.FLDCHGINF,0) as FLDCHGINF5,isnull(GENHTAB_5.FLDTAG,'') AS FLDTAG5,    
 isnull(ObjectRegister.FLDID6, '') AS FLDID6,isnull(ObjectRegister.VALUEID6, '') AS VALUEID6,isnull(ObjectRegister.VALUEDESC6, '') AS VALUEDESC6, isnull(GENHTAB_6.FLDTAB, 0) AS FLDTAB6, isnull(GENHTAB_6.FLDCOM, 0) AS FLDCOM6, isnull(GENHTAB_6.FLDDFORMAT, '') AS FLDDFORMAT6, isnull(GENHTAB_6.FLDIFORMAT, '') AS FLDIFORMAT6, isnull(GENHTAB_6.FLDTYPE, '') AS FLDTYPE6, isnull(GENHTAB_6.SUBLINKF, 0) AS SUBLINKF6,  isnull(GENHTAB_6.FLDSEARCH, '') AS FLDSEARCH6, isnull(GENHTAB_6.FLDCRITERIA, 0) AS FLDCRITERIA6, isnull(GENHTAB_6.FLDVALUATION, 0) AS FLDVALUATION6, isnull(GENHTAB_6.FLDCHGINF,0) as FLDCHGINF6,isnull(GENHTAB_6.FLDTAG,'') AS FLDTAG6,   
 isnull(ObjectRegister.FLDID7, '') AS FLDID7,isnull(ObjectRegister.VALUEID7, '') AS VALUEID7,isnull(ObjectRegister.VALUEDESC7, '') AS VALUEDESC7, isnull(GENHTAB_7.FLDTAB, 0) AS FLDTAB7, isnull(GENHTAB_7.FLDCOM, 0) AS FLDCOM7, isnull(GENHTAB_7.FLDDFORMAT, '') AS FLDDFORMAT7, isnull(GENHTAB_7.FLDIFORMAT, '') AS FLDIFORMAT7, isnull(GENHTAB_7.FLDTYPE, '') AS FLDTYPE7, isnull(GENHTAB_7.SUBLINKF, 0) AS SUBLINKF7,  isnull(GENHTAB_7.FLDSEARCH, '') AS FLDSEARCH7, isnull(GENHTAB_7.FLDCRITERIA, 0) AS FLDCRITERIA7, isnull(GENHTAB_7.FLDVALUATION, 0) AS FLDVALUATION7,isnull(GENHTAB_7.FLDCHGINF,0) as FLDCHGINF7,isnull(GENHTAB_7.FLDTAG,'') AS FLDTAG7,    
 isnull(ObjectRegister.FLDID8, '') AS FLDID8,isnull(ObjectRegister.VALUEID8, '') AS VALUEID8,isnull(ObjectRegister.VALUEDESC8, '') AS VALUEDESC8, isnull(GENHTAB_8.FLDTAB, 0) AS FLDTAB8, isnull(GENHTAB_8.FLDCOM, 0) AS FLDCOM8, isnull(GENHTAB_8.FLDDFORMAT, '') AS FLDDFORMAT8, isnull(GENHTAB_8.FLDIFORMAT, '') AS FLDIFORMAT8, isnull(GENHTAB_8.FLDTYPE, '') AS FLDTYPE8, isnull(GENHTAB_8.SUBLINKF, 0) AS SUBLINKF8,  isnull(GENHTAB_8.FLDSEARCH, '') AS FLDSEARCH8, isnull(GENHTAB_8.FLDCRITERIA, 0) AS FLDCRITERIA8, isnull(GENHTAB_8.FLDVALUATION, 0) AS FLDVALUATION8,isnull(GENHTAB_8.FLDCHGINF,0) as FLDCHGINF8,isnull(GENHTAB_8.FLDTAG,'') AS FLDTAG8,    
 isnull(ObjectRegister.FLDID9, '') AS FLDID9,isnull(ObjectRegister.VALUEID9, '') AS VALUEID9,isnull(ObjectRegister.VALUEDESC9, '') AS VALUEDESC9, isnull(GENHTAB_9.FLDTAB, 0) AS FLDTAB9, isnull(GENHTAB_9.FLDCOM, 0) AS FLDCOM9, isnull(GENHTAB_9.FLDDFORMAT, '') AS FLDDFORMAT9, isnull(GENHTAB_9.FLDIFORMAT, '') AS FLDIFORMAT9, isnull(GENHTAB_9.FLDTYPE, '') AS FLDTYPE9, isnull(GENHTAB_9.SUBLINKF, 0) AS SUBLINKF9,  isnull(GENHTAB_9.FLDSEARCH, '') AS FLDSEARCH9, isnull(GENHTAB_9.FLDCRITERIA, 0) AS FLDCRITERIA9, isnull(GENHTAB_9.FLDVALUATION, 0) AS FLDVALUATION9,isnull(GENHTAB_9.FLDCHGINF,0) as FLDCHGINF9,isnull(GENHTAB_9.FLDTAG,'') AS FLDTAG9,   
 isnull(ObjectRegister.FLDID10, '') AS FLDID10,isnull(ObjectRegister.VALUEID10, '') AS VALUEID10,isnull(ObjectRegister.VALUEDESC10, '') AS VALUEDESC10,  isnull(GENHTAB_10.FLDTAB, 0) AS FLDTAB10, isnull(GENHTAB_10.FLDCOM, 0) AS FLDCOM10, isnull(GENHTAB_10.FLDDFORMAT, '') AS FLDDFORMAT10, isnull(GENHTAB_10.FLDIFORMAT, '') AS FLDIFORMAT10, isnull(GENHTAB_10.FLDTYPE, '') AS FLDTYPE10, isnull(GENHTAB_10.SUBLINKF, 0) AS SUBLINKF10,  isnull(GENHTAB_10.FLDSEARCH, '') AS FLDSEARCH10, isnull(GENHTAB_10.FLDCRITERIA, 0) AS FLDCRITERIA10, isnull(GENHTAB_10.FLDVALUATION, 0) AS FLDVALUATION10,isnull(GENHTAB_10.FLDCHGINF,0) as FLDCHGINF10,isnull(GENHTAB_10.FLDTAG,'') AS FLDTAG10,     
 isnull(ObjectRegister.FLDID11, '') AS FLDID11,isnull(ObjectRegister.VALUEID11, '') AS VALUEID11,isnull(ObjectRegister.VALUEDESC11, '') AS VALUEDESC11, isnull(GENHTAB_11.FLDTAB, 0) AS FLDTAB11, isnull(GENHTAB_11.FLDCOM, 0) AS FLDCOM11, isnull(GENHTAB_11.FLDDFORMAT, '') AS FLDDFORMAT11, isnull(GENHTAB_11.FLDIFORMAT, '') AS FLDIFORMAT11, isnull(GENHTAB_11.FLDTYPE, '') AS FLDTYPE11, isnull(GENHTAB_11.SUBLINKF, 0) AS SUBLINKF11,  isnull(GENHTAB_11.FLDSEARCH, '') AS FLDSEARCH11, isnull(GENHTAB_11.FLDCRITERIA, 0) AS FLDCRITERIA11, isnull(GENHTAB_11.FLDVALUATION, 0) AS FLDVALUATION11,isnull(GENHTAB_11.FLDCHGINF,0) as FLDCHGINF11,isnull(GENHTAB_11.FLDTAG,'') AS FLDTAG11,
 isnull(ObjectRegister.FLDID12, '') AS FLDID12,isnull(ObjectRegister.VALUEID12, '') AS VALUEID12,isnull(ObjectRegister.VALUEDESC12, '') AS VALUEDESC12,isnull(GENHTAB_12.FLDTAB, 0) AS FLDTAB12, isnull(GENHTAB_12.FLDCOM, 0) AS FLDCOM12, isnull(GENHTAB_12.FLDDFORMAT, '') AS FLDDFORMAT12, isnull(GENHTAB_12.FLDIFORMAT, '') AS FLDIFORMAT12, isnull(GENHTAB_12.FLDTYPE, '') AS FLDTYPE12, isnull(GENHTAB_12.SUBLINKF, 0) AS SUBLINKF12,  isnull(GENHTAB_12.FLDSEARCH, '') AS FLDSEARCH12, isnull(GENHTAB_12.FLDCRITERIA, 0) AS FLDCRITERIA12, isnull(GENHTAB_12.FLDVALUATION, 0) AS FLDVALUATION12,isnull(GENHTAB_12.FLDCHGINF,0) as FLDCHGINF12,isnull(GENHTAB_12.FLDTAG,'') AS FLDTAG12,    
 isnull(ObjectRegister.FLDID13, '') AS FLDID13,isnull(ObjectRegister.VALUEID13, '') AS VALUEID13,isnull(ObjectRegister.VALUEDESC13, '') AS VALUEDESC13,  isnull(GENHTAB_13.FLDTAB, 0) AS FLDTAB13, isnull(GENHTAB_13.FLDCOM, 0) AS FLDCOM13, isnull(GENHTAB_13.FLDDFORMAT, '') AS FLDDFORMAT13, isnull(GENHTAB_13.FLDIFORMAT, '') AS FLDIFORMAT13, isnull(GENHTAB_13.FLDTYPE, '') AS FLDTYPE13, isnull(GENHTAB_13.SUBLINKF, 0) AS SUBLINKF13,  isnull(GENHTAB_13.FLDSEARCH, '') AS FLDSEARCH13, isnull(GENHTAB_13.FLDCRITERIA, 0) AS FLDCRITERIA13, isnull(GENHTAB_13.FLDVALUATION, 0) AS FLDVALUATION13,isnull(GENHTAB_13.FLDCHGINF,0) as FLDCHGINF13,isnull(GENHTAB_13.FLDTAG,'') AS FLDTAG13,    
 isnull(ObjectRegister.FLDID14, '') AS FLDID14,isnull(ObjectRegister.VALUEID14, '') AS VALUEID14,isnull(ObjectRegister.VALUEDESC14, '') AS VALUEDESC14, isnull(GENHTAB_14.FLDTAB, 0) AS FLDTAB14, isnull(GENHTAB_14.FLDCOM, 0) AS FLDCOM14, isnull(GENHTAB_14.FLDDFORMAT, '') AS FLDDFORMAT14, isnull(GENHTAB_14.FLDIFORMAT, '') AS FLDIFORMAT14, isnull(GENHTAB_14.FLDTYPE, '') AS FLDTYPE14, isnull(GENHTAB_14.SUBLINKF, 0) AS SUBLINKF14,  isnull(GENHTAB_14.FLDSEARCH, '') AS FLDSEARCH14, isnull(GENHTAB_14.FLDCRITERIA, 0) AS FLDCRITERIA14, isnull(GENHTAB_14.FLDVALUATION, 0) AS FLDVALUATION14,isnull(GENHTAB_14.FLDCHGINF,0) as FLDCHGINF14,isnull(GENHTAB_14.FLDTAG,'') AS FLDTAG14,    
 isnull(ObjectRegister.FLDID15, '') AS FLDID15,isnull(ObjectRegister.VALUEID15, '') AS VALUEID15,isnull(ObjectRegister.VALUEDESC15, '') AS VALUEDESC15,  isnull(GENHTAB_15.FLDTAB, 0) AS FLDTAB15, isnull(GENHTAB_15.FLDCOM, 0) AS FLDCOM15, isnull(GENHTAB_15.FLDDFORMAT, '') AS FLDDFORMAT15, isnull(GENHTAB_15.FLDIFORMAT, '') AS FLDIFORMAT15, isnull(GENHTAB_15.FLDTYPE, '') AS FLDTYPE15, isnull(GENHTAB_15.SUBLINKF, 0) AS SUBLINKF15,  isnull(GENHTAB_15.FLDSEARCH, '') AS FLDSEARCH15, isnull(GENHTAB_15.FLDCRITERIA, 0) AS FLDCRITERIA15, isnull(GENHTAB_15.FLDVALUATION, 0) AS FLDVALUATION15,isnull(GENHTAB_15.FLDCHGINF,0) as FLDCHGINF15,isnull(GENHTAB_15.FLDTAG,'') AS FLDTAG15
FROM               
 ObjectRegister       
 LEFT OUTER JOIN GENHTAB as GENHTAB_1 ON ObjectRegister.FLDID1 = GENHTAB_1.FLDID      
 LEFT OUTER JOIN GENHTAB as GENHTAB_2 ON ObjectRegister.FLDID2 = GENHTAB_2.FLDID      
 LEFT OUTER JOIN GENHTAB as GENHTAB_3 ON ObjectRegister.FLDID3 = GENHTAB_3.FLDID      
 LEFT OUTER JOIN GENHTAB as GENHTAB_4 ON ObjectRegister.FLDID4 = GENHTAB_4.FLDID      
 LEFT OUTER JOIN GENHTAB as GENHTAB_5 ON ObjectRegister.FLDID5 = GENHTAB_5.FLDID      
 LEFT OUTER JOIN GENHTAB as GENHTAB_6 ON ObjectRegister.FLDID6 = GENHTAB_6.FLDID      
 LEFT OUTER JOIN GENHTAB as GENHTAB_7 ON ObjectRegister.FLDID7 = GENHTAB_7.FLDID      
 LEFT OUTER JOIN GENHTAB as GENHTAB_8 ON ObjectRegister.FLDID8 = GENHTAB_8.FLDID      
 LEFT OUTER JOIN GENHTAB as GENHTAB_9 ON ObjectRegister.FLDID9 = GENHTAB_9.FLDID      
 LEFT OUTER JOIN GENHTAB as GENHTAB_10 ON ObjectRegister.FLDID10 = GENHTAB_10.FLDID      
 LEFT OUTER JOIN GENHTAB as GENHTAB_11 ON ObjectRegister.FLDID11 = GENHTAB_11.FLDID      
 LEFT OUTER JOIN GENHTAB as GENHTAB_12 ON ObjectRegister.FLDID12 = GENHTAB_12.FLDID      
 LEFT OUTER JOIN GENHTAB as GENHTAB_13 ON ObjectRegister.FLDID13 = GENHTAB_13.FLDID      
 LEFT OUTER JOIN GENHTAB as GENHTAB_14 ON ObjectRegister.FLDID14 = GENHTAB_14.FLDID      
 LEFT OUTER JOIN GENHTAB as GENHTAB_15 ON ObjectRegister.FLDID15 = GENHTAB_15.FLDID 
      
WHERE  ObjectRegister.ObjID=@ObjID

GO


IF EXISTS ( SELECT * FROM   sysobjects WHERE  id = object_id(N'[SP_Drop_ObjectRegister]') and OBJECTPROPERTY(id, N'IsProcedure') = 1 )
 BEGIN DROP PROCEDURE  [dbo].[SP_Drop_ObjectRegister] 
end
go

Create Procedure [dbo].[SP_Drop_ObjectRegister] (@TOC varchar(10),@ObjID varchar(10))    

as    

 begin    

  Delete From ObjectRegister Where TOC=@TOC AND ObjID=@ObjID ;    

 end 


 go


IF EXISTS ( SELECT * FROM   sysobjects WHERE  id = object_id(N'[SP_Search_ObjectRegister]') and OBJECTPROPERTY(id, N'IsProcedure') = 1 ) BEGIN 
DROP PROCEDURE   [dbo].[SP_Search_ObjectRegister]
end
go
 CREATE Procedure [dbo].[SP_Search_ObjectRegister](@TOC varchar(10), @Description varchar(50))          
as          
Select CAST(0 As Bit) ProcessFlag,  
O.ObjID,O.TOC,T.DESCRIPTION,O.RestrictedF,O.Last_Opr,O.Last_Update
From ObjectRegister O LEFT JOIN TOC T ON T.TOC = O.TOC
Where (T.TOC like @TOC + '%') And (T.Description like @Description + '%' )   
GO

--17 AGST 2019 : CUSTOMIZE REPORT
IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'CT_Row' AND Object_ID = Object_ID(N'Excel'))
BEGIN
ALTER TABLE Excel ADD
	CT_Row smallint NULL
DECLARE @v sql_variant 
SET @v = N'Row Position, Where CT Name will be shown'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'Excel', N'COLUMN', N'CT_Row'
END
GO


--17 AGST 2019 : CUSTOMIZE REPORT
IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'CT_Col' AND Object_ID = Object_ID(N'Excel'))
BEGIN
ALTER TABLE Excel ADD
	CT_Col smallint NULL
DECLARE @v sql_variant 
SET @v = N'Col Position, Where CT Name will be shown'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'Excel', N'COLUMN', N'CT_Col'
END
GO


--27 AGst 2019
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'I_APDRuleD') AND parent_object_id = OBJECT_ID(N'APDRuleD'))
Alter Table APDRuleD Drop Constraint I_APDRuleD
GO

IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'version' AND Object_ID = Object_ID(N'APDRuleD'))
BEGIN
Alter Table APDRuleD add version varchar(50)
END
GO


IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'PrintLogoF' AND Object_ID = Object_ID(N'APDRuleD'))
BEGIN
Alter Table APDRuleD Add PrintLogoF bit
END
GO

IF Not EXISTS (SELECT *  FROM sys.indexes WHERE name='I_APDRuleD' AND object_id = OBJECT_ID('APDRuleD'))
BEGIN
Create Unique Index I_APDRuleD on APDRuleD(RuleID, Class, Version)
end
GO

IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'PrintLogoF' AND Object_ID = Object_ID(N'APDBucket'))
BEGIN
Alter Table APDBucket Add PrintLogoF bit
END
GO
if exists (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'Get_Policy_APRule') AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) )
 BEGIN DROP FUNCTION Get_Policy_APRule
end
GO
Create function Get_Policy_APRule(@P_ANO as int)      
RETURNS Table      
AS RETURN      
(   
Select AD.RuleID, AD.Class, AD.Version, AD.RepName, AD.ExeName, AH.AutoInforceF, TOC.ApplyeStampDutyF, AD.NeedEmailF,AD.NeedPrintF, AD.PrintLogoF
from APDRuleH AH 
INNER JOIN APDRULED AD ON (AH.RULEID=AD.RULEID AND AD.AllowedF=1) 
INNER JOIN TOC ON (TOC.TOC=AH.TOC)
INNER JOIN 
(
	Select Top 1 AH.RuleID
	from APDRuleH AH 
	Where AH.AllowedF=1 AND AH.APPTYPE='POLICY'  
	and exists
	(  
		Select 1 
		from Acceptance A, Cover C, Profile P
		Where A.ANO=@P_ANO and C.CNO=A.CNO and P.ID=C.PHolder 
		and C.PolicyType=AH.PolicyType and C.ISType=AH.ISType 
		and (C.Segment=AH.Segment or AH.Segment='<All>') and A.TOC=AH.TOC and (A.TOPRO=AH.TOPRO or AH.TOPRO='<All>')  
		and (P.PType=AH.PType or AH.PType='<All>')
	)  
	Order by AH.RuleID
) R ON (AH.RULEID=R.RULEID)
INNER JOIN ACCEPTANCE A ON (A.ANO=@P_ANO)
INNER JOIN COVER C ON (C.CNO=A.CNO)
WHERE charindex(A.AType,AD.AccAType)<>0  and charindex(A.AStatus,AD.AccAStatus)<>0  and charindex(C.CStatus,AD.CoverCStatus)<>0  
)       


go

--23 agustus 2019 update terkait MW
IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'FilterCode' AND Object_ID = Object_ID(N'TOP_Rate'))
BEGIN
ALTER TABLE TOP_Rate ADD
	FilterCode varchar(20) NULL
DECLARE @v sql_variant 
SET @v = N'Filter Code (Code +''/''+PolicyYear)'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'TOP_Rate', N'COLUMN', N'FilterCode'
END
GO
IF NOT EXISTS(SELECT * FROM sysform WHERE Fname='FORCEUSECSTALLOCATION')
BEGIN
insert into sysform(FName, Description, FCode, RequestF) Select 'FORCEUSECSTALLOCATION','FORCE USE COST ALLOCATION TABLE','ACTIVITIES',0
END
GO
if exists (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'FL_UserBranchAccountIO') AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) )
 BEGIN DROP FUNCTION FL_UserBranchAccountIO
end
GO
Create function FL_UserBranchAccountIO(@P_USERID varchar(50), @P_Branch varchar(10), @P_Account varchar(10), @P_DebtorF Bit)            
RETURNS Table              
AS RETURN              
(            
SELECT Branch.Branch, Branch.Name, Branch.Active_Flag, Branch.ShariaF, 
Case When Type.PL_Flag=1 and Type.Type=5 and dbo.GetPrivileges(@P_UserID,'FORCEUSECSTALLOCATION')=1 Then
	(Select Top 1 CT from CSTALLOCATIOND C Where C.Branch=Branch.Branch and C.Account=@P_Account and (SysUser.CT='' or SysUser.CT=C.CT)) 
Else
	(Select Top 1 CT from CT Where CT.Branch=Branch.Branch) 
End as CT
from Branch, SysUser, Account, Type          
Where SysUser.ID=@P_UserID and Account.Account=@P_Account and Account.Inter_Flag=1 and Type.Type=Account.Type       
and Branch.Branch Like @P_Branch+'%' and Branch.Op_Flag=1       
and (
SysUser.Type='SUPERVISOR' or 
	(
	EXISTS (
		Select S.Branch 
		from SysUserBranch S 
		Where S.Branch=Branch.Branch and S.ID=SysUser.ID
		and (
			(Type.PL_Flag=1 and S.IncomeReceiveF=1 and @P_DebtorF=1) or 
			(Type.PL_Flag=1 and S.ExpensePaymentF=1 and @P_DebtorF=0) or 
			(Type.BS_Flag=1 and S.SuspendReceiveF=1 and @P_DebtorF=1) or 
			(Type.BS_Flag=1 and S.SuspendPaymentF=1 and @P_DebtorF=0))
			)
	 and (not(Type.PL_Flag=1 and Type.Type=5) or dbo.GetPrivileges(@P_UserID,'FORCEUSECSTALLOCATION')=0 or EXISTS (Select C.Account from CSTALLOCATIONH C Where C.Branch=Branch.Branch and C.Account=Account.Account))
	)
)        

)      

GO

if exists (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'FN_UserCT') AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) ) 
BEGIN DROP FUNCTION FN_UserCT
end
GO
Create function FN_UserCT(@P_USERID varchar(50), @P_Branch varchar(10), @P_Account varchar(10))  
RETURNS Table    
AS RETURN    
(  
SELECT CT.*
from CT
Inner Join SysUser on (SysUser.ID=@P_UserID)
Left Join Account on (Account.Account=@P_Account)
Left Join Type on (Type.Type=Account.Type)
Where (CT.Branch is null or CT.Branch='' or CT.Branch=@P_Branch)
and (
	SysUser.Type='SUPERVISOR' or 
	(not(coalesce(Type.PL_Flag,1)=1 and coalesce(Type.Type,5)=5) or dbo.GetPrivileges(@P_UserID,'FORCEUSECSTALLOCATION')=0 or EXISTS (Select C.Account from CSTALLOCATIOND C Where C.Branch=@P_Branch and (@P_Account='' or C.Account=@P_Account) and (SysUser.CT='' or SysUser.CT=C.CT) and C.CT=CT.CT))
)        

)  


GO


if exists (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'FL_UserAccount') AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) ) 
BEGIN DROP FUNCTION FL_UserAccount
end
GO
Create function FL_UserAccount(@P_USERID varchar(50), @P_Branch varchar(10), @P_Account varchar(10))            
RETURNS Table              
AS RETURN              
(            

Select Account.Account, Account.Description, Systab.Currency, Account.AccGroup, Account.Hold_Flag,
Case When Type.PL_Flag=1 and Type.Type=5 and dbo.GetPrivileges(@P_UserID,'FORCEUSECSTALLOCATION')=1 Then
	(Select Top 1 CT from CSTALLOCATIOND C Where C.Branch=@P_Branch and C.Account=Account.Account and (SysUser.CT='' or SysUser.CT=C.CT)) 
Else
	(Select Top 1 CT from CT Where CT.Branch=@P_Branch) 
End as CT
from Account
Inner Join SysTab on (1=1)
Inner Join SysUser on (SysUser.ID=@P_UserID)
Inner Join Type on (Type.type=Account.Type)
Where
(
	SysUser.Type='SUPERVISOR' or 
	(not(Type.PL_Flag=1 and Type.Type=5) or dbo.GetPrivileges(@P_UserID,'FORCEUSECSTALLOCATION')=0 or EXISTS (Select C.Account from CSTALLOCATIONH C Where C.Branch=@P_Branch and C.Account=Account.Account))
)   
and Account.Account Like @P_Account+'%' and Account.Post_Flag=1 and Account.AllowedF=1
)


GO

if exists (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'FL_SL_ACCOUNT') AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) )
 BEGIN DROP FUNCTION FL_SL_ACCOUNT
end
GO
CREATE FUNCTION FL_SL_ACCOUNT(@P_USERID varchar(50), @P_Branch varchar(10), @P_GID varchar(10), @P_Voucher varchar(20), @P_VType varchar(10), @P_ComAcc varchar(30), @P_Doc_No varchar(20),@P_CCY varchar(10), @P_Payment_Flag bit)                                    
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
   and ((coalesce(ComAcc.ComAcc,'')='' ) or (coalesce(ComAcc.ComAcc,'')<>'' and (Coalesce(ComAcc.AccGroup,'')='' or A2.AccGroup='' or Coalesce(ComAcc.AccGroup,'')=A2.AccGroup)))     
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
   and ((coalesce(ComAcc.ComAcc,'')='' ) or (coalesce(ComAcc.ComAcc,'')<>'' and (Coalesce(ComAcc.AccGroup,'')='' or A2.AccGroup='' or Coalesce(ComAcc.AccGroup,'')=A2.AccGroup)))     
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
  Inner Join SysUser on (SysUser.ID=@P_UserID)
  Inner Join Type on (Type.type=A1.Type)
  Left Join ComAcc on (ComAcc.ComAcc=@P_ComAcc), Account a2, vPattern, SysTab, VType              
  Where A1.AllowedF=1 and a1.post_flag=1 and a1.parent=a2.parent and a2.account=vPattern.account and vPattern.Constant_Flag=1 and ((vPattern.Credit<0 AND VType.DebtorF = 1) or (vPattern.Debit<0 AND VType.CreditorF = 1)) and VType.Vtype=@P_VType AND VType.VType = VPattern.VType and (A1.Hold_Flag<>1 or A1.Suspend_Flag=1)                                    
  and ((coalesce(ComAcc.ComAcc,'')='' ) or (coalesce(ComAcc.ComAcc,'')<>'' and (Coalesce(ComAcc.AccGroup,'')='' or A1.AccGroup='' or Coalesce(ComAcc.AccGroup,'')=A1.AccGroup)))  
  and
  (
	SysUser.Type='SUPERVISOR' or 
	(not(Type.PL_Flag=1 and Type.Type=5) or dbo.GetPrivileges(@P_UserID,'FORCEUSECSTALLOCATION')=0 or EXISTS (Select Top 1 C.Account from CSTALLOCATIONH C Where C.Branch=@P_Branch and C.Account=A1.Account))
  )        
  Group By A1.Account, A1.Open_ItemF, A1.Description, SysTab.Currency, A1.AccGroup                                   
 End      
 Else      
 Begin      
  insert into @TSL_Account                                    
  Select A1.Account, A1.Open_ItemF, '' as Branch, max(CASE WHEN vtype.debtorf=1 THEN vPattern.Credit ELSE vpattern.debit end) as Hint, B.Description, Case When @P_CCY='' then SysTab.Currency else @P_CCY end as Currency, A1.AccGroup, 0 as Outstanding      
  from Budget_AccountDetail B, Account A1 
  Left Join ComAcc on (ComAcc.ComAcc=@P_ComAcc), Account a2, vPattern, SysTab, VType                                       
  Where B.GID=@P_GID and B.ID=@P_Doc_No and (A1.Account=B.Account_Dr or A1.Account=B.Account_Cr) and A1.AllowedF=1 and a1.post_flag=1 and a1.parent=a2.parent and a2.account=vPattern.account and vPattern.Constant_Flag=1 and ((vPattern.Credit<0 AND VType.DebtorF = 1) or (vPattern.Debit<0 AND VType.CreditorF = 1)) and VType.Vtype=@P_VType AND VType.VType = VPattern.VType and (A1.Hold_Flag<>1 or A1.Suspend_Flag=1)                                      
  and ((coalesce(ComAcc.ComAcc,'')='' ) or (coalesce(ComAcc.ComAcc,'')<>'' and (Coalesce(ComAcc.AccGroup,'')='' or A1.AccGroup='' or Coalesce(ComAcc.AccGroup,'')=A1.AccGroup)))     
  Group By A1.Account, A1.Open_ItemF, B.Description, SysTab.Currency, A1.AccGroup            
 End      
End       
       
Return                                    
END                


GO





IF EXISTS ( SELECT * FROM   sysobjects WHERE  id = object_id(N'SP_Search_CSTALLOCATIOND') and OBJECTPROPERTY(id, N'IsProcedure') = 1 ) 
BEGIN DROP PROCEDURE  SP_Search_CSTALLOCATIOND
end
go
CREATE procedure SP_Search_CSTALLOCATIOND (@Branch varchar(10))  
as  
Select Cast(0 as bit) as ProcessFlag, C1.*, C2.Description from CSTALLOCATIOND C1, CT C2 where C2.CT=C1.CT and 
C1.Branch=@Branch
go

IF EXISTS ( SELECT * FROM   sysobjects WHERE  id = object_id(N'QTOR_Rule') and OBJECTPROPERTY(id, N'IsProcedure') = 1 ) 
BEGIN DROP PROCEDURE  QTOR_Rule
end
GO
create PROCEDURE QTOR_Rule (@P_TOR AS VARCHAR(10),@DCODE AS VARCHAR(10))       
AS 
select top 1 
TOR.RFLDID1, '' AS ValueID1L,'' AS ValueID1U,
TOR.RFLDID2, '' AS ValueID2L,'' AS ValueID2U,
TOR.RFLDID3, '' AS ValueID3L,'' AS ValueID3U,
TOR.RFLDID4, '' AS ValueID4L,'' AS ValueID4U,
TOR.RFLDID5, '' AS ValueID5L,'' AS ValueID5U
FROM       
TOR left join DEDTAB on (DEDTAB.TOR=TOR.TOR)
LEFT OUTER JOIN GENHTAB as GENHTAB_1 ON TOR.RFLDID1<>'' AND TOR.RFLDID1 = GENHTAB_1.FLDID       
LEFT OUTER JOIN GENHTAB as GENHTAB_2 ON TOR.RFLDID2<>'' AND TOR.RFLDID2 = GENHTAB_2.FLDID       
LEFT OUTER JOIN GENHTAB as GENHTAB_3 ON TOR.RFLDID3<>'' AND TOR.RFLDID3 = GENHTAB_3.FLDID       
LEFT OUTER JOIN GENHTAB as GENHTAB_4 ON TOR.RFLDID4<>'' AND TOR.RFLDID4 = GENHTAB_4.FLDID       
LEFT OUTER JOIN GENHTAB as GENHTAB_5 ON TOR.RFLDID5<>'' AND TOR.RFLDID5 = GENHTAB_5.FLDID       
WHERE TOR.TOR = @P_TOR and @DCODE=''
union all
SELECT  top 1         
TOR.RFLDID1, DEDTAB.ValueID1L AS ValueID1L,DEDTAB.ValueID1U AS ValueID1U,
TOR.RFLDID2, DEDTAB.ValueID2L AS ValueID2L,DEDTAB.ValueID2U AS ValueID2U,
TOR.RFLDID3, DEDTAB.ValueID3L AS ValueID3L,DEDTAB.ValueID3U AS ValueID3U,
TOR.RFLDID4, DEDTAB.ValueID4L AS ValueID4L,DEDTAB.ValueID4U AS ValueID4U,
TOR.RFLDID5, DEDTAB.ValueID5L AS ValueID5L,DEDTAB.ValueID5U AS ValueID5U
FROM       
DEDTAB, TOR
LEFT OUTER JOIN GENHTAB as GENHTAB_1 ON TOR.RFLDID1<>'' AND TOR.RFLDID1 = GENHTAB_1.FLDID       
LEFT OUTER JOIN GENHTAB as GENHTAB_2 ON TOR.RFLDID2<>'' AND TOR.RFLDID2 = GENHTAB_2.FLDID       
LEFT OUTER JOIN GENHTAB as GENHTAB_3 ON TOR.RFLDID3<>'' AND TOR.RFLDID3 = GENHTAB_3.FLDID       
LEFT OUTER JOIN GENHTAB as GENHTAB_4 ON TOR.RFLDID4<>'' AND TOR.RFLDID4 = GENHTAB_4.FLDID       
LEFT OUTER JOIN GENHTAB as GENHTAB_5 ON TOR.RFLDID5<>'' AND TOR.RFLDID5 = GENHTAB_5.FLDID       
WHERE DEDTAB.TOR=TOR.TOR and 
TOR.TOR = @P_TOR and DEDTAB.DCODE=@DCODE
GO

-- 26 SEPTEMBER 2019
  IF EXISTS ( SELECT * FROM   sysobjects WHERE  id = object_id(N'QRate_Ratcon') and OBJECTPROPERTY(id, N'IsProcedure') = 1 )
   BEGIN DROP PROCEDURE  QRate_Ratcon
  end
  go
CREATE PROCEDURE QRate_Ratcon (@CODE Varchar(10) )            
AS            
 BEGIN                    
 SELECT CAST(0 As Bit) ProcessFlag, RATECON, RATECON.CODE AS CODE,MinTSI,MaxTSI,      
 cast(coalesce(MinTSI, '0') as varchar(30)) +' - '+ cast(coalesce(MaxTSI, '0')as varchar(30)) as TSI,       
 cast(coalesce(RATECON.MinRate, '0')  as varchar(30)) + ' - ' + cast(coalesce(RATECON.MaxRate, '0') as varchar(30)) as 'RATEP',       
 cast(coalesce(MINPERIOD, '0')  as varchar(30)) + ' - ' + cast(coalesce(MAXPERIOD, '0') as varchar(30)) as 'Coverage',      
 RATETAB.SPERIOD,TEXCESS, RATECON.ALLOWEDF, LOADING       
 from RateCon   
 LEFT JOIN RATETAB ON RATETAB.CODE = RATECON.CODE  
   
 where RATECON.CODE=@CODE   
 end
 GO  
 
 --02 OKTOBER 2019
 IF EXISTS ( SELECT * FROM   sysobjects WHERE  id = object_id(N'SP_Drop_RateTab') and OBJECTPROPERTY(id, N'IsProcedure') = 1 ) 
 
BEGIN DROP PROCEDURE  SP_Drop_RateTab
end
GO

 Create Procedure [dbo].SP_Drop_RateTab (@CODE varchar(10))    
as    
 begin    
  Delete From RATETAB Where CODE=@CODE;    
 end 
 GO
  

 --iNDEX RPBUCKET
 
/****** Object:  Index [I_RPBUCKET]    Script Date: 10/29/2019 11:19:33 AM ******/
DROP INDEX [I_RPBUCKET] ON [dbo].[RPBucket]
GO

/****** Object:  Index [I_RPBUCKET]    Script Date: 10/29/2019 11:19:33 AM ******/
CREATE UNIQUE NONCLUSTERED INDEX [I_RPBUCKET] ON [dbo].[RPBucket]
(
	[PID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO


/****** Object:  Index [I_RPBUCKET_VOUCHER]    Script Date: 10/29/2019 11:19:45 AM ******/
DROP INDEX [I_RPBUCKET_VOUCHER] ON [dbo].[RPBucket]
GO

/****** Object:  Index [I_RPBUCKET_VOUCHER]    Script Date: 10/29/2019 11:19:45 AM ******/
CREATE NONCLUSTERED INDEX [I_RPBUCKET_VOUCHER] ON [dbo].[RPBucket]
(
	[Voucher] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO


/****** Object:  Index [I_RPBUCKET_VOUCHER_NVOUCHER]    Script Date: 10/29/2019 11:19:52 AM ******/
DROP INDEX [I_RPBUCKET_VOUCHER_NVOUCHER] ON [dbo].[RPBucket]
GO

/****** Object:  Index [I_RPBUCKET_VOUCHER_NVOUCHER]    Script Date: 10/29/2019 11:19:52 AM ******/
CREATE NONCLUSTERED INDEX [I_RPBUCKET_VOUCHER_NVOUCHER] ON [dbo].[RPBucket]
(
	[Voucher] ASC,
	[NVoucher] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO


--Update terkait Setting Treaty MAIPARK
IF EXISTS ( SELECT * FROM   sysobjects WHERE  id = object_id(N'QRiskAssLimit') and OBJECTPROPERTY(id, N'IsProcedure') = 1 ) 
BEGIN DROP PROCEDURE  QRiskAssLimit 
end
GO
CREATE PROCEDURE QRiskAssLimit (@PANO as integer, @RType as varchar(10)='')                    
AS                    
SELECT top 1 RiskAss.RiskAss, Case When ReClass.AssessmentExInwardF=1 and Cover.ISType in ('R','T') Then 100 else RiskAss.PLimit end PLimit, Case When ReClass.AssessmentExInwardF=1 and Cover.ISType in ('R','T') Then 100 else RiskAss.Limit end Limit,
Cover.ISType, RiskAss.Code, RiskAss.HoldF, RiskAss.Share, RiskAss.Rate, RiskAss.Loading, RiskAss.RType                    
From Acceptance
Inner Join Cover on (Cover.CNO=Acceptance.CNO)
Inner Join AInfo on (AInfo.ANO=Acceptance.ANO)
Inner Join RArrHeader on (RArrHeader.ANO=Acceptance.ANO)
Inner Join Reinsurance on (((@RType='' and Reinsurance.RType In ('Q')) or Reinsurance.RType=@RType) and RArrHeader.RDate Between Reinsurance.SDate and Reinsurance.EDate)
Inner Join ReClass on (ReClass.RNO=Reinsurance.RNO and ReClass.TOC=Acceptance.TOC and ReClass.AssessmentF=1)
Left Join RiskAss on (
	(RiskAss.RType='' or RiskAss.RType=@RType or @RType='')
	And Riskass.RYear=Reinsurance.RYear And RiskAss.TOC=ReClass.TOC        
	and (RiskAss.TSILimit=0 or RArrHeader.TAmount-RArrHeader.MAmount<=RiskAss.TSILimit)                  
	And ((RiskAss.ValueID1='' and Ainfo.ValueDesc1 Like RiskAss.ValueDesc1+'%') or (RiskAss.ValueID1<>'' and AInfo.ValueID1 Like RiskAss.ValueID1+'%') or (RiskAss.ValueID1 is null))                    
	And ((RiskAss.ValueID2='' and Ainfo.ValueDesc2 Like RiskAss.ValueDesc2+'%') or (RiskAss.ValueID2<>'' and AInfo.ValueID2 Like RiskAss.ValueID2+'%') or (RiskAss.ValueID2 is null))                    
	And ((RiskAss.ValueID3='' and Ainfo.ValueDesc3 Like RiskAss.ValueDesc3+'%') or (RiskAss.ValueID3<>'' and AInfo.ValueID3 Like RiskAss.ValueID3+'%') or (RiskAss.ValueID3 is null))                    
	And ((RiskAss.ValueID4='' and Ainfo.ValueDesc4 Like RiskAss.ValueDesc4+'%') or (RiskAss.ValueID4<>'' and AInfo.ValueID4 Like RiskAss.ValueID4+'%') or (RiskAss.ValueID4 is null))                    
	And ((RiskAss.ValueID5='' and Ainfo.ValueDesc5 Like RiskAss.ValueDesc5+'%') or (RiskAss.ValueID5<>'' and AInfo.ValueID5 Like RiskAss.ValueID5+'%') or (RiskAss.ValueID5 is null))                    
	And ((RiskAss.ValueID6='' and Ainfo.ValueDesc6 Like RiskAss.ValueDesc6+'%') or (RiskAss.ValueID6<>'' and AInfo.ValueID6 Like RiskAss.ValueID6+'%') or (RiskAss.ValueID6 is null))                    
	And ((RiskAss.ValueID7='' and Ainfo.ValueDesc7 Like RiskAss.ValueDesc7+'%') or (RiskAss.ValueID7<>'' and AInfo.ValueID7 Like RiskAss.ValueID7+'%') or (RiskAss.ValueID7 is null))                    
	And ((RiskAss.ValueID8='' and Ainfo.ValueDesc8 Like RiskAss.ValueDesc8+'%') or (RiskAss.ValueID8<>'' and AInfo.ValueID8 Like RiskAss.ValueID8+'%') or (RiskAss.ValueID8 is null))                    
	And ((RiskAss.ValueID9='' and Ainfo.ValueDesc9 Like RiskAss.ValueDesc9+'%') or (RiskAss.ValueID9<>'' and AInfo.ValueID9 Like RiskAss.ValueID9+'%') or (RiskAss.ValueID9 is null))                    
	And ((RiskAss.ValueID10='' and Ainfo.ValueDesc10 Like RiskAss.ValueDesc10+'%') or (RiskAss.ValueID10<>'' and AInfo.ValueID10 Like RiskAss.ValueID10+'%') or (RiskAss.ValueID10 is null))                    
	And ((RiskAss.ValueID11='' and Ainfo.ValueDesc11 Like RiskAss.ValueDesc11+'%') or (RiskAss.ValueID11<>'' and AInfo.ValueID11 Like RiskAss.ValueID11+'%') or (RiskAss.ValueID11 is null))                    
	And ((RiskAss.ValueID12='' and Ainfo.ValueDesc12 Like RiskAss.ValueDesc12+'%') or (RiskAss.ValueID12<>'' and AInfo.ValueID12 Like RiskAss.ValueID12+'%') or (RiskAss.ValueID12 is null))                    
	And ((RiskAss.ValueID13='' and Ainfo.ValueDesc13 Like RiskAss.ValueDesc13+'%') or (RiskAss.ValueID13<>'' and AInfo.ValueID13 Like RiskAss.ValueID13+'%') or (RiskAss.ValueID13 is null))                    
	And ((RiskAss.ValueID14='' and Ainfo.ValueDesc14 Like RiskAss.ValueDesc14+'%') or (RiskAss.ValueID14<>'' and AInfo.ValueID14 Like RiskAss.ValueID14+'%') or (RiskAss.ValueID14 is null))     
	And ((RiskAss.ValueID15='' and Ainfo.ValueDesc15 Like RiskAss.ValueDesc15+'%') or (RiskAss.ValueID15<>'' and AInfo.ValueID15 Like RiskAss.ValueID15+'%') or (RiskAss.ValueID15 is null))      
)
WHERE Acceptance.ANO=@PANO 
Order by                   
RiskAss.RYear Desc,        
Case When RiskAss.RType=@RType Then 1 Else 0 end Desc,
RiskAss.PriorityF Desc,                  
len(coalesce(RiskAss.ValueID1,'')) Desc, len(coalesce(RiskAss.ValueID2,'')) Desc, len(coalesce(RiskAss.ValueID3,'')) Desc, len(coalesce(RiskAss.ValueID4,'')) Desc, len(coalesce(RiskAss.ValueID5,'')) Desc,                   
len(coalesce(RiskAss.ValueID6,'')) Desc, len(coalesce(RiskAss.ValueID7,'')) Desc, len(coalesce(RiskAss.ValueID8,'')) Desc, len(coalesce(RiskAss.ValueID9,'')) Desc, len(coalesce(RiskAss.ValueID10,'')) Desc,                   
len(coalesce(RiskAss.ValueID11,'')) Desc, len(coalesce(RiskAss.ValueID12,'')) Desc, len(coalesce(RiskAss.ValueID13,'')) Desc, len(coalesce(RiskAss.ValueID14,'')) Desc, len(coalesce(RiskAss.ValueID15,'')) Desc,                   
RiskAss.Limit Desc, RiskAss.Loading, RiskAss.HoldF        


go

if exists (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'FL_UserTopro') AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) ) 
BEGIN DROP FUNCTION FL_UserTopro
end
go
CREATE function FL_UserTopro(@P_USERID varchar(50), @P_TOPRO varchar(10),@P_TOC varchar(10),@P_SEGMENT varchar(10))    
RETURNS Table      
AS RETURN      
(    
SELECT Distinct TOPRO.TOPRO, TOPRO.Description, TOPRO.TOC, TOPRO.Expiry, TOPRO.CustomizableF, TOPRO.IncludeExtCoverF        
from TOPRO Left Join TOP_Segment on (TOP_Segment.TOPRO=TOPRO.TOPRO)           
Where (TOPRO.TOPRO Like @P_TOPRO+'%' or TOPRO.Description like  @P_TOPRO+'%')
and TOPRO.TOC=Substring(@P_TOC, 1, len(TOPRO.TOC))
and TOPRO.AllowedF=1           
and (TOPRO.SegmentF=0 or TOP_Segment.Segment like @P_SEGMENT)   
)
go

--VERSIONING
insert into versioning
select '2019 V.2.0.0',GETDATE(),'2019 V.2.0.1',GETDATE(),'K: 2019 V.2.0.1',GETDATE()
go



  insert into PatchVersioning
select '54 Script Komulatif Konsol 2019 2.0',GETDATE()
go
Declare @PrevScript varchar(100)
Declare @CurrScript varchar(100)

Select @PrevScript='53.4 Update Script - Patch 2019 (3) (Execute Before kom 2019 v.2)'
Select @CurrSCript='54 Script Komulatif Konsol 2019 2.0'


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