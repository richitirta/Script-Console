--2 okt 2017
Alter Table AccRegDet Add RestrictedF bit
GO
Alter Table AccRegDet Add pRestrictedF bit
GO
Update AccRegDet set RestrictedF=0 Where RestrictedF is null
GO
Update AccRegDet set pRestrictedF=0 Where pRestrictedF is null

GO

DROP Procedure QSet_Object_Restriction
GO
CREATE Procedure QSet_Object_Restriction(@P_CNO as integer)
AS
UPDATE A1 SET pRestrictedF=RestrictedF, 
RestrictedF=CASE WHEN ((Select TOP 1 CLLOSS.CTLF from CLLOSS Where CLLOSS.CNO=CLAIM.CNO and CLLOSS.CTLF=1)=1 OR pRestrictedF=1) THEN 1 ELSE 0 END
from AccRegDet A1, Acceptance A2, Claim Where A2.ANO=Claim.ANO and A1.RegID=A2.RegID and A1.FLDID=A2.FLDID and A1.VALUEID=A2.VALUEID 
and A1.RType='Q' and Exists (Select TOP 1 CNO from CLLOSS Where CLLOSS.CNO=CLAIM.CNO and CLLOSS.CTLF=1)
and Claim.CNO=@P_CNO    

GO

DROP Procedure QReset_Object_Restriction
GO
CREATE Procedure QReset_Object_Restriction(@P_CNO as integer)
AS
UPDATE A1 SET RestrictedF=pRestrictedF
from AccRegDet A1, Acceptance A2, Claim Where A2.ANO=Claim.ANO and A1.RegID=A2.RegID and A1.FLDID=A2.FLDID and A1.VALUEID=A2.VALUEID 
and A1.RType='Q' and Exists (Select TOP 1 CNO from CLLOSS Where CLLOSS.CNO=CLAIM.CNO and CLLOSS.CTLF=1)
and Claim.CNO=@P_CNO

GO

DROP Procedure QGet_Object_Restriction
GO
CREATE Procedure QGet_Object_Restriction(@P_ANO as integer)
AS
Select A1.RestrictedF
from AccRegDet A1, Acceptance A2 Where A2.ANO=@P_ANO and A1.RegID=A2.RegID and A1.FLDID=A2.FLDID and A1.VALUEID=A2.VALUEID 
and A1.RType='Q' 
go

Alter Table AccRegDet Drop Column RestrictedF
GO
ALter Table AccRegDet Drop Column pRestrictedF
GO
DROP Procedure QSet_Object_Restriction
GO
DROP Procedure QReset_Object_Restriction
go


DROP Procedure QGet_Object_Restriction
GO
CREATE Procedure QGet_Object_Restriction(@P_ANO as integer)
AS

Select Top 1 Cast(1 as Bit) as RestrictedF
from Acceptance A1, Acceptance A2, Claim
Where A1.ANO=@P_ANO 
and A1.RegID=A2.RegID and A1.FLDID=A2.FLDID and A1.VALUEID=A2.VALUEID and A1.VALUEDESC=A2.VALUEDESC
and A2.ANO=Claim.ANO 
and Claim.CType not in ('C') and (Claim.CStatus in ('P','T','A') or Claim.PCStatus in ('A'))
and Exists (Select TOP 1 CNO from CLLOSS Where CLLOSS.CNO=CLAIM.CNO and CLLOSS.CTLF=1)

go




--2 okt 2017 (1)
DROP PROCEDURE PI01 
GO
CREATE PROCEDURE PI01 (@P_ANO AS INTEGER) 
AS 
( 
SELECT TOP 1 
A.POLICYNO, A.CERTIFICATENO, C.PHOLDER, P.PREFERREDF, P.RESTRICTEDF, P.NAME, A.ANAME, A.AID, 
(LTRIM(RTRIM(P.ADDRESS_1)) + ' ' + LTRIM(RTRIM(P.ADDRESS_2)) + ' ' + LTRIM(RTRIM(P.ADDRESS_3))) AS 'ADDRESS', 
(LTRIM(RTRIM(P.PHONE_1)) + ' ' + LTRIM(RTRIM(P.PHONE_2))) AS 'PHONE', 
(LTRIM(RTRIM(P.FAX_1)) + ' ' + LTRIM(RTRIM(P.FAX_2))) AS 'FAX', 
P.EMAIL, A.SDATE, A.EDATE, A.PDATE, A.PPDATE, A.NCDATE,
RA.POLICYNO as PPOLICYNO, RA.CERTIFICATENO as PCERTIFICATENO 
FROM COVER C 
INNER JOIN ACCEPTANCE A ON (A.CNO=C.CNO) 
LEFT JOIN ACCEPTANCE RA ON (RA.ANO=A.RANO) 
INNER JOIN PROFILE P ON (C.PHOLDER=P.ID) 
WHERE A.ANO=@P_ANO 
) 
 
 

go


insert into SysForm(FName, Description, FCode)
Select 'ALLOWCHANGEPML','Allow Change PML (UW)','ACTIVITIES'
go


--3 okt 2017
/* To prevent any potential data loss issues, you should review this script in detail before running it outside the context of the database designer.*/
BEGIN TRANSACTION
SET QUOTED_IDENTIFIER ON
SET ARITHABORT ON
SET NUMERIC_ROUNDABORT OFF
SET CONCAT_NULL_YIELDS_NULL ON
SET ANSI_NULLS ON
SET ANSI_PADDING ON
SET ANSI_WARNINGS ON
COMMIT
BEGIN TRANSACTION
GO
ALTER TABLE dbo.FDTAB ADD
	AMOUNTPCT float(53) NULL,
	AMOUNTPCTBASED int NULL
GO
DECLARE @v sql_variant 
SET @v = N'Fee and Duty in Percentage of Premium'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'FDTAB', N'COLUMN', N'AMOUNTPCT'
GO
DECLARE @v sql_variant 
SET @v = N'Percentage Based On (0 : % Of Premiu, 1 : % Of TSI)'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'FDTAB', N'COLUMN', N'AMOUNTPCTBASED'
GO
ALTER TABLE dbo.FDTAB ADD CONSTRAINT
	DF_FDTAB_AMOUNTPCT DEFAULT ((0)) FOR AMOUNTPCT
GO
ALTER TABLE dbo.FDTAB SET (LOCK_ESCALATION = TABLE)
GO
COMMIT


Update Request set AUserID='', AUserDate=Null where status='U'
GO

--penambahan noyears
ALTER TABLE dbo.SYSBATCHORIGINALSC ADD
	NofYears_1 VARCHAR(50) NULL,
	NofYears_2 VARCHAR(50) NULL,
	NofYears_3 VARCHAR(50) NULL,
	NofYears_4 VARCHAR(50) NULL,
	NofYears_5 VARCHAR(50) NULL,
	NofYears_6 VARCHAR(50) NULL,
	NofYears_7 VARCHAR(50) NULL,
	NofYears_8 VARCHAR(50) NULL,
	NofYears_9 VARCHAR(50) NULL,
	NofYears_10 VARCHAR(50) NULL
GO

ALTER TABLE dbo.SYSBATCHSC ADD
	NofYears_1 float(53) NULL,
	NofYears_2 float(53) NULL,
	NofYears_3 float(53) NULL,
	NofYears_4 float(53) NULL,
	NofYears_5 float(53) NULL,
	NofYears_6 float(53) NULL,
	NofYears_7 float(53) NULL,
	NofYears_8 float(53) NULL,
	NofYears_9 float(53) NULL,
	NofYears_10 float(53) NULL
GO

/* To prevent any potential data loss issues, you should review this script in detail before running it outside the context of the database designer.*/
BEGIN TRANSACTION
SET QUOTED_IDENTIFIER ON
SET ARITHABORT ON
SET NUMERIC_ROUNDABORT OFF
SET CONCAT_NULL_YIELDS_NULL ON
SET ANSI_NULLS ON
SET ANSI_PADDING ON
SET ANSI_WARNINGS ON
COMMIT
BEGIN TRANSACTION
GO
ALTER TABLE dbo.Scheme_Transaction ADD
	NofYears_3 float(53) NULL,
	NofYears_4 float(53) NULL,
	NofYears_5 float(53) NULL,
	NofYears_6 float(53) NULL,
	NofYears_7 float(53) NULL,
	NofYears_8 float(53) NULL,
	NofYears_9 float(53) NULL,
	NofYears_10 float(53) NULL
GO
DECLARE @v sql_variant 
SET @v = N'Total Number Of Year for Coverage #1'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'Scheme_Transaction', N'COLUMN', N'NofYears_3'
GO
DECLARE @v sql_variant 
SET @v = N'Total Number Of Year for Coverage #1'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'Scheme_Transaction', N'COLUMN', N'NofYears_4'
GO
DECLARE @v sql_variant 
SET @v = N'Total Number Of Year for Coverage #1'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'Scheme_Transaction', N'COLUMN', N'NofYears_5'
GO
DECLARE @v sql_variant 
SET @v = N'Total Number Of Year for Coverage #1'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'Scheme_Transaction', N'COLUMN', N'NofYears_6'
GO
DECLARE @v sql_variant 
SET @v = N'Total Number Of Year for Coverage #1'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'Scheme_Transaction', N'COLUMN', N'NofYears_7'
GO
DECLARE @v sql_variant 
SET @v = N'Total Number Of Year for Coverage #1'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'Scheme_Transaction', N'COLUMN', N'NofYears_8'
GO
DECLARE @v sql_variant 
SET @v = N'Total Number Of Year for Coverage #1'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'Scheme_Transaction', N'COLUMN', N'NofYears_9'
GO
DECLARE @v sql_variant 
SET @v = N'Total Number Of Year for Coverage #1'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'Scheme_Transaction', N'COLUMN', N'NofYears_10'
GO
ALTER TABLE dbo.Scheme_Transaction SET (LOCK_ESCALATION = TABLE)
GO
COMMIT

--3 OKT 2017(1)
/* To prevent any potential data loss issues, you should review this script in detail before running it outside the context of the database designer.*/
BEGIN TRANSACTION
SET QUOTED_IDENTIFIER ON
SET ARITHABORT ON
SET NUMERIC_ROUNDABORT OFF
SET CONCAT_NULL_YIELDS_NULL ON
SET ANSI_NULLS ON
SET ANSI_PADDING ON
SET ANSI_WARNINGS ON
COMMIT
BEGIN TRANSACTION
GO
ALTER TABLE dbo.APBucket ADD
	BookDate smalldatetime NULL
GO
DECLARE @v sql_variant 
SET @v = N'Payment/Request Booking Date'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'APBucket', N'COLUMN', N'BookDate'
GO
ALTER TABLE dbo.APBucket SET (LOCK_ESCALATION = TABLE)
GO
Update APBucket set BookDate=PDate Where BookDate is null
COMMIT


--3 OKT 2017 (2)
/* To prevent any potential data loss issues, you should review this script in detail before running it outside the context of the database designer.*/
BEGIN TRANSACTION
SET QUOTED_IDENTIFIER ON
SET ARITHABORT ON
SET NUMERIC_ROUNDABORT OFF
SET CONCAT_NULL_YIELDS_NULL ON
SET ANSI_NULLS ON
SET ANSI_PADDING ON
SET ANSI_WARNINGS ON
COMMIT
BEGIN TRANSACTION
GO
ALTER TABLE dbo.CLDED ADD
	VAT float(53) NULL,
	TAX float(53) NULL,
	TaxAmount float(53) NULL,
	VatAmount float(53) NULL
GO
DECLARE @v sql_variant 
SET @v = N'VAT Amount'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'CLDED', N'COLUMN', N'VAT'
GO
DECLARE @v sql_variant 
SET @v = N'TAX AMOUNT'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'CLDED', N'COLUMN', N'TAX'
GO
DECLARE @v sql_variant 
SET @v = N'TAXABLE AMOUNT'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'CLDED', N'COLUMN', N'TaxAmount'
GO
DECLARE @v sql_variant 
SET @v = N'Vatable AMOUNT'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'CLDED', N'COLUMN', N'VatAmount'
GO
ALTER TABLE dbo.CLDED ADD CONSTRAINT
	DF_CLDED_TAX DEFAULT ((0)) FOR TAX
GO
ALTER TABLE dbo.CLDED SET (LOCK_ESCALATION = TABLE)
GO
UPDATE CLDED SET VATAMOUNT=AMOUNT, TAXAMOUNT=AMOUNT, VAT=0, TAX=0 WHERE VATAMOUNT IS NULL
COMMIT


GO

DROP PROCEDURE QCLACC02 
GO
CREATE PROCEDURE QCLACC02 (@P_CNO AS INTEGER)   
AS   
SELECT DISTINCT CLAIM.CNO, CLAIM.REGDATE, CLAIM.ISTYPE, ACCDED.TOR, ACCDED.DCODE, CLAIM.PAYMENT, ACCDED.REMARKS, ACCDED.REMARKS_1, ACCDED.CURRENCY   
From CLAIM, ACCDED, COL, ACCEPTANCE   
WHERE CLAIM.CNO=@P_CNO   
AND ACCDED.ANO=CLAIM.ANO AND ACCEPTANCE.ANO=ACCDED.ANO   
AND ((ACCDED.SDATE<=CLAIM.LOSSDATE AND ACCEPTANCE.ExclusiveF=1) or ((ACCDED.SDATE<CLAIM.LOSSDATE or (ACCDED.SDATE=CLAIM.LOSSDATE AND '12:00'<=Claim.LossTime)) AND ACCEPTANCE.ExclusiveF=0))   
AND ((dbo.fn_Get_ExtPeriodDate(ACCEPTANCE.ExtPeriod, ACCEPTANCE.ExtPeriodInDaysF, ACCDED.EDATE)>CLAIM.LOSSDATE AND ACCEPTANCE.ExclusiveF=1) or ((dbo.fn_Get_ExtPeriodDate(ACCEPTANCE.ExtPeriod, ACCEPTANCE.ExtPeriodInDaysF, ACCDED.EDATE)>CLAIM.LOSSDATE or (dbo.fn_Get_ExtPeriodDate(ACCEPTANCE.ExtPeriod, ACCEPTANCE.ExtPeriodInDaysF, ACCDED.EDATE)=CLAIM.LOSSDATE AND '12:00'>Claim.LossTime)) AND ACCEPTANCE.ExclusiveF=0))   
AND COL.COL=CLAIM.COL AND ACCDED.TOR=COL.TOR   
   

GO

-- f2 claimant/payment to
DROP PROCEDURE QCLACC_3_1
go
CREATE PROCEDURE QCLACC_3_1 (@P_POLICYNO AS VARCHAR(255), @P_CERTIFICATENO VARCHAR(255))             
AS             
SELECT TOP 1 ACCEPTANCE.ANO,ACCEPTANCE.POLICYNO, ACCEPTANCE.CERTIFICATENO, ACCEPTANCE.AID, COVER.INSURED, COVER.ISTYPE, COVER.TOC, ACCEPTANCE.SDATE, ACCEPTANCE.EDATE, Cover.PHolder, ACCEPTANCE.BRANCH, 
ACCEPTANCE.ANAME, PROFILE.RESTRICTEDF, PROFILE.NAME, ACCEPTANCE.PDATe, ACCEPTANCE.PPDATE, ACCEPTANCE.NCDATE,  ACCEPTANCE.EXTPERIOD,             
Case When GenDTab.Description is not null then Acceptance.ValueDesc else '' end as Description,             
coalesce(InParty.ID, coalesce(ISource.ID, Acceptance.AID)) as Payment,
coalesce(IProfile.Name, coalesce(PProfile.Name, Profile.Name)) as Payment_Name
FROM ACCEPTANCE Left Join GenDTab On (GenDTab.FLDID=Acceptance.FLDID and GenDTab.ValueID=Acceptance.ValueID),
 COVER Left Join ISource On (ISource.CNO=Cover.CNO) 
 Left Join InParty on (InParty.CNO=Cover.CNO and InParty.IType in ('MORTGAGE'))
 Left Join Profile PProfile On (PProfile.ID=ISource.ID)
 Left Join Profile IProfile On (IProfile.ID=InParty.ID)  , 
 Profile             
WHERE COVER.CNO=ACCEPTANCE.CNO And ACCEPTANCE.ATYPE Not In ('A','C') And ACCEPTANCE.AStatus not in ('W','T')  
And ACCEPTANCE.PDATE<ACCEPTANCE.PPDATE AND ACCEPTANCE.ANO<>ACCEPTANCE.LANO And ACCEPTANCE.AID=PROFILE.ID            
AND ACCEPTANCE.POLICYNO LIKE @P_POLICYNO AND ACCEPTANCE.CERTIFICATENO LIKE @P_CERTIFICATENO             
ORDER BY ACCEPTANCE.POLICYNO, ACCEPTANCE.CERTIFICATENO, ACCEPTANCE.PDATE DESC 
GO



--perbaikan pemeriksaan QGET_OBJECT_RESTRICTION 

DROP Procedure QGet_Object_Restriction
GO
CREATE Procedure QGet_Object_Restriction(@P_ANO as integer)
AS

Select Top 1 Cast(1 as Bit) as RestrictedF
from Acceptance A1, Acceptance A2, Claim
Where A1.ANO=@P_ANO 
and A2.OANO<>A1.OANO and A1.RegID=A2.RegID and A1.FLDID=A2.FLDID and A1.VALUEID=A2.VALUEID and A1.VALUEDESC=A2.VALUEDESC
and A2.ANO=Claim.ANO 
and Claim.CType not in ('C') and (Claim.CStatus in ('P','T','A') or Claim.PCStatus in ('A'))
and Exists (Select TOP 1 CNO from CLLOSS Where CLLOSS.CNO=CLAIM.CNO and CLLOSS.CTLF=1)
go

--6 OKT 2017
DROP PROCEDURE MList20 
GO 
CREATE  PROCEDURE MList20  (@P_USERID as varchar(255),@P_SDate as smalldatetime, @P_EDate as smalldatetime,@P_CStatus as varchar(1))   
AS 
SELECT Cast(0 as bit) as ProcessFlag, Cover.COVERNO, Cover.Insured, Cover.CNO, Cover.CStatus, Cover.VSeqNo, Acceptance.lANO, Acceptance.ANO, Acceptance.REGNO, Acceptance.ADATE,Acceptance.LUSERID as USERID,  
SysTab.Currency, 
(SELECT coalesce(SUM(PCALC.TSI*PCALC.RATE),0) FROM  PCALC WHERE PCALC.ANO=ACCEPTANCE.ANO AND ACCEPTANCE.PSTATUS='C')*CASE WHEN ACCEPTANCE.QTY=0 THEN 1 ELSE ACCEPTANCE.QTY END AS TSI,
(SELECT coalesce(SUM(PCALC.OURSHARE*PCALC.RATE),0) FROM  PCALC WHERE PCALC.ANO=ACCEPTANCE.ANO AND ACCEPTANCE.PSTATUS='C')*CASE WHEN ACCEPTANCE.QTY=0 THEN 1 ELSE ACCEPTANCE.QTY END AS OURSHARE, 
(SELECT coalesce(SUM(PCALC.GROSS*PCALC.RATE),0) FROM  PCALC WHERE PCALC.ANO=ACCEPTANCE.ANO AND ACCEPTANCE.PSTATUS='C')*CASE WHEN ACCEPTANCE.QTY=0 THEN 1 ELSE ACCEPTANCE.QTY END AS GROSS,
Acceptance.ASTATUS, Acceptance.ATYPE, Acceptance.SDate, Acceptance.EDate, 
Year(Coalesce(RArrHeader.RDate,Acceptance.SDate)) AS RYear, 
Cover.ISType, 
Acceptance.Renewal, 
Acceptance.ESeqNo, 
Acceptance.PolicyNo 
FROM Acceptance 
Left Join RArrHeader on (RArrHeader.ANO=Acceptance.ANO), Cover, SysTab 
Where cover.CNO = acceptance.CNO 
And (Acceptance.LANO=-1 Or Acceptance.ANO=Acceptance.LANO) 
And Cover.LUserID Like @P_UserID
And Cover.LDate Between @P_SDate and @P_EDate
And (Cover.CStatus=@P_CStatus or @P_CStatus='') 
 
 
 
 

GO

DROP FUNCTION MList20_DET
GO
CREATE  FUNCTION MList20_DET(@P_ANO AS INTEGER,@P_USERID as varchar(255),@P_SDate as smalldatetime, @P_EDate as smalldatetime,@P_CStatus as varchar(1))
RETURNS Table
AS RETURN(
SELECT
 Cast(0 as bit) as ProcessFlag, 
 Cover.COVERNO,
 Acceptance.AName,
 Acceptance.CertificateNo,
 Cover.CNO,
 Cover.CStatus,
 Cover.VSeqNo,
 Acceptance.LANO,
 Acceptance.ANO,
 Acceptance.REGNO,
 Acceptance.ADATE,
 Acceptance.USERID,
 SysTab.Currency,
 QPCalc.TSI,
 QPCalc.OurShare,
 QPCalc.Gross,
 Acceptance.ASTATUS,
 Acceptance.ATYPE,
 Acceptance.SDate,
 Acceptance.EDate,
 Year(RARRHEADER.RDATE) As RYear
From
 Acceptance
 Left Join QDetail_PCalc() QPCalc on (qPCalc.ANO=Acceptance.ANO and Acceptance.PStatus='C'), 
 Cover,
 RArrHeader,
 SysTab 
Where
 cover.CNO = acceptance.CNO
 And RArrHeader.ANO=Acceptance.ANO
 And QPCalc.ANO=Acceptance.ANO
 And Acceptance.ANO<>Acceptance.LANO
 And Acceptance.LANO=@P_ANO
 And Cover.LUserID Like @P_UserID
 And Cover.LDate Between @P_SDate and @P_EDate
 And (Cover.CStatus=@P_CStatus or @P_CStatus='') 
)

GO

--6 OKT 2017
/* To prevent any potential data loss issues, you should review this script in detail before running it outside the context of the database designer.*/
BEGIN TRANSACTION
SET QUOTED_IDENTIFIER ON
SET ARITHABORT ON
SET NUMERIC_ROUNDABORT OFF
SET CONCAT_NULL_YIELDS_NULL ON
SET ANSI_NULLS ON
SET ANSI_PADDING ON
SET ANSI_WARNINGS ON
COMMIT
BEGIN TRANSACTION
GO
ALTER TABLE dbo.TOP_Deductible ADD
	NotApplyRateLoadingF bit NULL
GO
DECLARE @v sql_variant 
SET @v = N'Not apply Rate Loading (0 : Apply Rate Loading, 1 : Not Apply) see Rate Condition Multiplier'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'TOP_Deductible', N'COLUMN', N'NotApplyRateLoadingF'
GO
ALTER TABLE dbo.TOP_Deductible SET (LOCK_ESCALATION = TABLE)
GO
UPDATE TOP_DEDUCTIBLE SET NotApplyRateLoadingF=0 Where NotApplyRateLoadingF IS NULL
COMMIT

--VERSIONING
insert into versioning
select '2017 V.2.16.0',GETDATE(),'2017 V.2.0.0',GETDATE(),'K: 2017 V.2.0.0',GETDATE()
go
