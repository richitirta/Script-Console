--2 okt 2017
IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'RestrictedF' AND Object_ID = Object_ID(N'AccRegDet'))
BEGIN
Alter Table AccRegDet Add RestrictedF bit
END
GO
IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'pRestrictedF' AND Object_ID = Object_ID(N'AccRegDet'))
BEGIN
Alter Table AccRegDet Add pRestrictedF bit
END
GO

IF EXISTS ( SELECT * FROM   sysobjects WHERE  id = object_id(N'QSet_Object_Restriction') and OBJECTPROPERTY(id, N'IsProcedure') = 1 )
BEGIN
DROP Procedure QSet_Object_Restriction
END
GO
CREATE Procedure QSet_Object_Restriction(@P_CNO as integer)
AS
UPDATE A1 SET pRestrictedF=RestrictedF, 
RestrictedF=CASE WHEN ((Select TOP 1 CLLOSS.CTLF from CLLOSS Where CLLOSS.CNO=CLAIM.CNO and CLLOSS.CTLF=1)=1 OR pRestrictedF=1) THEN 1 ELSE 0 END
from AccRegDet A1, Acceptance A2, Claim Where A2.ANO=Claim.ANO and A1.RegID=A2.RegID and A1.FLDID=A2.FLDID and A1.VALUEID=A2.VALUEID 
and A1.RType='Q' and Exists (Select TOP 1 CNO from CLLOSS Where CLLOSS.CNO=CLAIM.CNO and CLLOSS.CTLF=1)
and Claim.CNO=@P_CNO    

GO

IF EXISTS ( SELECT * FROM   sysobjects WHERE  id = object_id(N'QReset_Object_Restriction') and OBJECTPROPERTY(id, N'IsProcedure') = 1 )
BEGIN
DROP Procedure QReset_Object_Restriction
END
GO
CREATE Procedure QReset_Object_Restriction(@P_CNO as integer)
AS
UPDATE A1 SET RestrictedF=pRestrictedF
from AccRegDet A1, Acceptance A2, Claim Where A2.ANO=Claim.ANO and A1.RegID=A2.RegID and A1.FLDID=A2.FLDID and A1.VALUEID=A2.VALUEID 
and A1.RType='Q' and Exists (Select TOP 1 CNO from CLLOSS Where CLLOSS.CNO=CLAIM.CNO and CLLOSS.CTLF=1)
and Claim.CNO=@P_CNO

GO

IF EXISTS ( SELECT * FROM   sysobjects WHERE  id = object_id(N'QGet_Object_Restriction') and OBJECTPROPERTY(id, N'IsProcedure') = 1 )
BEGIN
DROP Procedure QGet_Object_Restriction
END
GO
CREATE Procedure QGet_Object_Restriction(@P_ANO as integer)
AS
Select A1.RestrictedF
from AccRegDet A1, Acceptance A2 Where A2.ANO=@P_ANO and A1.RegID=A2.RegID and A1.FLDID=A2.FLDID and A1.VALUEID=A2.VALUEID 
and A1.RType='Q' 
go

IF EXISTS(SELECT * FROM sys.columns WHERE Name = N'RestrictedF' AND Object_ID = Object_ID(N'AccRegDet'))
BEGIN
Alter Table AccRegDet Drop Column RestrictedF
END
GO
IF EXISTS(SELECT * FROM sys.columns WHERE Name = N'pRestrictedF' AND Object_ID = Object_ID(N'AccRegDet'))
BEGIN
ALter Table AccRegDet Drop Column pRestrictedF
END
GO

IF EXISTS ( SELECT * FROM   sysobjects WHERE  id = object_id(N'QSet_Object_Restriction') and OBJECTPROPERTY(id, N'IsProcedure') = 1 )
BEGIN
DROP Procedure QSet_Object_Restriction
END
GO
IF EXISTS ( SELECT * FROM   sysobjects WHERE  id = object_id(N'QReset_Object_Restriction') and OBJECTPROPERTY(id, N'IsProcedure') = 1 )
BEGIN
DROP Procedure QReset_Object_Restriction
END
go

IF EXISTS ( SELECT * FROM   sysobjects WHERE  id = object_id(N'QGet_Object_Restriction') and OBJECTPROPERTY(id, N'IsProcedure') = 1 )
BEGIN
DROP Procedure QGet_Object_Restriction
END
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
IF EXISTS ( SELECT * FROM   sysobjects WHERE  id = object_id(N'PI01') and OBJECTPROPERTY(id, N'IsProcedure') = 1 )
BEGIN
DROP PROCEDURE PI01 
END
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
GO

IF NOT EXISTS(SELECT * FROM SYSFORM WHERE FNAME='ALLOWCHANGEPML')
BEGIN
insert into SysForm(FName, Description, FCode)
Select 'ALLOWCHANGEPML','Allow Change PML (UW)','ACTIVITIES'
END
GO

--3 okt 2017
IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'AMOUNTPCT' AND Object_ID = Object_ID(N'FDTAB'))
BEGIN
ALTER TABLE FDTAB ADD AMOUNTPCT float(53) NULL
DECLARE @v sql_variant 
SET @v = N'Fee and Duty in Percentage of Premium'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'FDTAB', N'COLUMN', N'AMOUNTPCT'
END
GO
IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'AMOUNTPCTBASED' AND Object_ID = Object_ID(N'FDTAB'))
BEGIN
ALTER TABLE FDTAB ADD AMOUNTPCTBASED int NULL
DECLARE @v sql_variant 
SET @v = N'Percentage Based On (0 : % Of Premiu, 1 : % Of TSI)'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'FDTAB', N'COLUMN', N'AMOUNTPCTBASED'
END
GO

IF NOT EXISTS(SELECT * FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS WHERE TABLE_NAME='FDTAB' AND CONSTRAINT_NAME='DF_FDTAB_AMOUNTPCT')
begin 
ALTER TABLE FDTAB ADD CONSTRAINT
	DF_FDTAB_AMOUNTPCT DEFAULT ((0)) FOR AMOUNTPCT
END
GO


--penambahan noyears
IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'NofYears_1' AND Object_ID = Object_ID(N'SYSBATCHORIGINALSC'))
BEGIN
ALTER TABLE SYSBATCHORIGINALSC ADD NofYears_1 VARCHAR(50) NULL
END
GO
IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'NofYears_2' AND Object_ID = Object_ID(N'SYSBATCHORIGINALSC'))
BEGIN
ALTER TABLE SYSBATCHORIGINALSC ADD NofYears_2 VARCHAR(50) NULL
END
GO
IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'NofYears_3' AND Object_ID = Object_ID(N'SYSBATCHORIGINALSC'))
BEGIN
ALTER TABLE SYSBATCHORIGINALSC ADD NofYears_3 VARCHAR(50) NULL
END
GO
IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'NofYears_4' AND Object_ID = Object_ID(N'SYSBATCHORIGINALSC'))
BEGIN
ALTER TABLE SYSBATCHORIGINALSC ADD NofYears_4 VARCHAR(50) NULL
END
GO
IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'NofYears_5' AND Object_ID = Object_ID(N'SYSBATCHORIGINALSC'))
BEGIN
ALTER TABLE SYSBATCHORIGINALSC ADD NofYears_5 VARCHAR(50) NULL
END
GO
IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'NofYears_6' AND Object_ID = Object_ID(N'SYSBATCHORIGINALSC'))
BEGIN
ALTER TABLE SYSBATCHORIGINALSC ADD NofYears_6 VARCHAR(50) NULL
END
GO
IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'NofYears_7' AND Object_ID = Object_ID(N'SYSBATCHORIGINALSC'))
BEGIN
ALTER TABLE SYSBATCHORIGINALSC ADD NofYears_7 VARCHAR(50) NULL
END
GO
IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'NofYears_8' AND Object_ID = Object_ID(N'SYSBATCHORIGINALSC'))
BEGIN
ALTER TABLE SYSBATCHORIGINALSC ADD NofYears_8 VARCHAR(50) NULL
END
GO
IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'NofYears_9' AND Object_ID = Object_ID(N'SYSBATCHORIGINALSC'))
BEGIN
ALTER TABLE SYSBATCHORIGINALSC ADD NofYears_9 VARCHAR(50) NULL
END
GO
IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'NofYears_10' AND Object_ID = Object_ID(N'SYSBATCHORIGINALSC'))
BEGIN
ALTER TABLE SYSBATCHORIGINALSC ADD NofYears_10 VARCHAR(50) NULL
END
GO

IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'NofYears_1' AND Object_ID = Object_ID(N'SYSBATCHSC'))
BEGIN
ALTER TABLE SYSBATCHSC ADD NofYears_1 float(53) NULL
END
GO
IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'NofYears_2' AND Object_ID = Object_ID(N'SYSBATCHSC'))
BEGIN
ALTER TABLE SYSBATCHSC ADD NofYears_2 float(53) NULL
END
GO
IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'NofYears_3' AND Object_ID = Object_ID(N'SYSBATCHSC'))
BEGIN
ALTER TABLE SYSBATCHSC ADD NofYears_3 float(53) NULL
END
GO
IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'NofYears_4' AND Object_ID = Object_ID(N'SYSBATCHSC'))
BEGIN
ALTER TABLE SYSBATCHSC ADD NofYears_4 float(53) NULL
END
GO
IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'NofYears_5' AND Object_ID = Object_ID(N'SYSBATCHSC'))
BEGIN
ALTER TABLE SYSBATCHSC ADD NofYears_5 float(53) NULL
END
GO
IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'NofYears_6' AND Object_ID = Object_ID(N'SYSBATCHSC'))
BEGIN
ALTER TABLE SYSBATCHSC ADD NofYears_6 float(53) NULL
END
GO
IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'NofYears_7' AND Object_ID = Object_ID(N'SYSBATCHSC'))
BEGIN
ALTER TABLE SYSBATCHSC ADD NofYears_7 float(53) NULL
END
GO
IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'NofYears_8' AND Object_ID = Object_ID(N'SYSBATCHSC'))
BEGIN
ALTER TABLE SYSBATCHSC ADD NofYears_8 float(53) NULL
END
GO
IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'NofYears_9' AND Object_ID = Object_ID(N'SYSBATCHSC'))
BEGIN
ALTER TABLE SYSBATCHSC ADD NofYears_9 float(53) NULL
END
GO
IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'NofYears_10' AND Object_ID = Object_ID(N'SYSBATCHSC'))
BEGIN
ALTER TABLE SYSBATCHSC ADD NofYears_10 float(53) NULL
END
GO

IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'NofYears_3' AND Object_ID = Object_ID(N'Scheme_Transaction'))
BEGIN
ALTER TABLE Scheme_Transaction ADD NofYears_3 float(53) NULL
DECLARE @v sql_variant 
SET @v = N'Total Number Of Year for Coverage #1'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'Scheme_Transaction', N'COLUMN', N'NofYears_3'
END
GO
IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'NofYears_4' AND Object_ID = Object_ID(N'Scheme_Transaction'))
BEGIN
ALTER TABLE Scheme_Transaction ADD NofYears_4 float(53) NULL
DECLARE @v sql_variant 
SET @v = N'Total Number Of Year for Coverage #1'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'Scheme_Transaction', N'COLUMN', N'NofYears_4'
END
GO
IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'NofYears_5' AND Object_ID = Object_ID(N'Scheme_Transaction'))
BEGIN
ALTER TABLE Scheme_Transaction ADD NofYears_5 float(53) NULL
DECLARE @v sql_variant 
SET @v = N'Total Number Of Year for Coverage #1'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'Scheme_Transaction', N'COLUMN', N'NofYears_5'
END
GO
IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'NofYears_6' AND Object_ID = Object_ID(N'Scheme_Transaction'))
BEGIN
ALTER TABLE Scheme_Transaction ADD NofYears_6 float(53) NULL
DECLARE @v sql_variant 
SET @v = N'Total Number Of Year for Coverage #1'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'Scheme_Transaction', N'COLUMN', N'NofYears_6'
END
GO
IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'NofYears_7' AND Object_ID = Object_ID(N'Scheme_Transaction'))
BEGIN
ALTER TABLE Scheme_Transaction ADD NofYears_7 float(53) NULL
DECLARE @v sql_variant 
SET @v = N'Total Number Of Year for Coverage #1'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'Scheme_Transaction', N'COLUMN', N'NofYears_7'
END
GO
IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'NofYears_8' AND Object_ID = Object_ID(N'Scheme_Transaction'))
BEGIN
ALTER TABLE Scheme_Transaction ADD NofYears_8 float(53) NULL
DECLARE @v sql_variant 
SET @v = N'Total Number Of Year for Coverage #1'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'Scheme_Transaction', N'COLUMN', N'NofYears_8'
END
GO
IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'NofYears_9' AND Object_ID = Object_ID(N'Scheme_Transaction'))
BEGIN
ALTER TABLE Scheme_Transaction ADD NofYears_9 float(53) NULL
DECLARE @v sql_variant 
SET @v = N'Total Number Of Year for Coverage #1'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'Scheme_Transaction', N'COLUMN', N'NofYears_9'
END
GO
IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'NofYears_10' AND Object_ID = Object_ID(N'Scheme_Transaction'))
BEGIN
ALTER TABLE Scheme_Transaction ADD NofYears_10 float(53) NULL
DECLARE @v sql_variant 
SET @v = N'Total Number Of Year for Coverage #1'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'Scheme_Transaction', N'COLUMN', N'NofYears_10'

ALTER TABLE Scheme_Transaction SET (LOCK_ESCALATION = TABLE)
END
GO

--3 OKT 2017(1)
IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'BookDate' AND Object_ID = Object_ID(N'APBucket'))
BEGIN
ALTER TABLE APBucket ADD BookDate smalldatetime NULL

DECLARE @v sql_variant 
SET @v = N'Payment/Request Booking Date'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'APBucket', N'COLUMN', N'BookDate'
END
GO



--3 OKT 2017 (2)
IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'VAT' AND Object_ID = Object_ID(N'CLDED'))
BEGIN
ALTER TABLE CLDED ADD VAT float(53) NULL
DECLARE @v sql_variant 
SET @v = N'VAT Amount'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'CLDED', N'COLUMN', N'VAT'
END
GO

IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'TAX' AND Object_ID = Object_ID(N'CLDED'))
BEGIN
ALTER TABLE CLDED ADD TAX float(53) NULL
DECLARE @v sql_variant 
SET @v = N'TAX AMOUNT'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'CLDED', N'COLUMN', N'TAX'
END
GO

IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'TaxAmount' AND Object_ID = Object_ID(N'CLDED'))
BEGIN
ALTER TABLE CLDED ADD TaxAmount float(53) NULL
DECLARE @v sql_variant 
SET @v = N'TAXABLE AMOUNT'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'CLDED', N'COLUMN', N'TaxAmount'
END
GO

IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'VatAmount' AND Object_ID = Object_ID(N'CLDED'))
BEGIN
ALTER TABLE CLDED ADD VatAmount float(53) NULL
DECLARE @v sql_variant 
SET @v = N'Vatable AMOUNT'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'CLDED', N'COLUMN', N'VatAmount'
END
GO

IF NOT EXISTS(SELECT * FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS WHERE TABLE_NAME='CLDED' AND CONSTRAINT_NAME='DF_CLDED_TAX')
begin 
ALTER TABLE CLDED ADD CONSTRAINT
	DF_CLDED_TAX DEFAULT ((0)) FOR TAX
END
GO



IF EXISTS ( SELECT * FROM   sysobjects WHERE  id = object_id(N'QCLACC02') and OBJECTPROPERTY(id, N'IsProcedure') = 1 )
BEGIN
DROP PROCEDURE QCLACC02 
END
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

IF EXISTS ( SELECT * FROM   sysobjects WHERE  id = object_id(N'QCLACC_3_1') and OBJECTPROPERTY(id, N'IsProcedure') = 1 )
BEGIN
DROP PROCEDURE QCLACC_3_1
END
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
IF EXISTS ( SELECT * FROM   sysobjects WHERE  id = object_id(N'QGet_Object_Restriction') and OBJECTPROPERTY(id, N'IsProcedure') = 1 )
BEGIN
DROP Procedure QGet_Object_Restriction
END
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
IF EXISTS ( SELECT * FROM   sysobjects WHERE  id = object_id(N'MList20') and OBJECTPROPERTY(id, N'IsProcedure') = 1 )
BEGIN
DROP PROCEDURE MList20 
END
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

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'MList20_DET') AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) )
BEGIN
DROP FUNCTION MList20_DET
END
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
IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'NotApplyRateLoadingF' AND Object_ID = Object_ID(N'TOP_Deductible'))
BEGIN
ALTER TABLE TOP_Deductible ADD
	NotApplyRateLoadingF bit NULL

DECLARE @v sql_variant 
SET @v = N'Not apply Rate Loading (0 : Apply Rate Loading, 1 : Not Apply) see Rate Condition Multiplier'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'TOP_Deductible', N'COLUMN', N'NotApplyRateLoadingF'
END
GO


--VERSIONING
insert into versioning
select '2017 V.2.16.0',GETDATE(),'2017 V.2.0.0',GETDATE(),'K: 2017 V.2.0.0',GETDATE()
go


Declare @PrevScript varchar(100)
Declare @CurrScript varchar(100)

Select @PrevScript='25 Script Komulatif Konsol 2.15'
Select @CurrSCript='26 Script Komulatif Konsol 2.16'


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
