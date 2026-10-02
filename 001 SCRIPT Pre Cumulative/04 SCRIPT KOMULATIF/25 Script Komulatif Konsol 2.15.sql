--26 sept : script time
Alter Table ActionLog Alter Column ActionTime varchar(8)
GO
Alter Table CLAIM Alter Column RefTime varchar(8)
GO
Alter Table CLAIM Alter Column CTime varchar(8)
GO
Alter Table CLAIM Alter Column LossTime varchar(8)
GO
Alter Table CLAIM Alter Column ActionTime varchar(8)
GO
Alter Table CLAIM Alter Column PUserTime varchar(8)
GO
Alter Table CLAIM Alter Column LTime varchar(8)
GO
Alter Table CLAIM Alter Column CloseTime varchar(8)
GO
Alter Table CLAIM Alter Column AUserTime varchar(8)
GO
Alter Table Profile Alter Column RedFlagTime varchar(8)
GO
Alter Table Profile Alter Column Last_Time varchar(8)
GO
Alter Table Event Alter Column Time varchar(8)
GO
Alter Table Event Alter Column LastTime varchar(8)
GO
Alter Table VoucherLinkH Alter Column PTime varchar(8)
GO
Alter Table AccDocStat Alter Column ActionTime varchar(8)
GO
Alter Table AccDocStat Alter Column AcceptedTime varchar(8)
GO
Alter Table SysUserActivity Alter Column Last_Login_Time varchar(8)
GO
Alter Table SysUserActivity Alter Column Last_Logout_Time varchar(8)
GO
Alter Table SysUserActivity Alter Column Last_Activity_Time varchar(8)
GO
Alter Table SysLogObject Alter Column Last_Time varchar(8)
GO
Alter Table COLLRESULT Alter Column Last_Time varchar(8)
GO
Alter Table QPrintLog Alter Column Time varchar(8)
GO
Alter Table nVoucher Alter Column Last_Time varchar(8)
GO
Alter Table nVoucher Alter Column Posting_Time varchar(8)
GO
Alter Table SPrintLog Alter Column Time varchar(8)
GO
Alter Table SOV Alter Column RSTime varchar(8)
GO
Alter Table SOV Alter Column RETime varchar(8)
GO
Alter Table SysLogReport ADD PTime varchar(8)
GO
Alter Table ActionFlow Alter Column ActionLimitTime varchar(8)
GO
Alter Table mVoucher Alter Column Last_Time varchar(8)
GO
Alter Table mVoucher Alter Column Posting_Time varchar(8)
GO
Alter Table mJournal Alter Column Last_Time varchar(8)
GO
Alter Table AmortizationD Alter Column Last_Time varchar(8)
GO
Alter Table SysLogProcess Alter Column PTime varchar(8)
GO
Alter Table CLNotify Alter Column Time varchar(8)
GO
Alter Table AmortizationH Alter Column Last_Time varchar(8)
GO
Alter Table ORPrintLog Alter Column Time varchar(8)
GO
Alter Table PettyCashH Alter Column Last_Time varchar(8)
GO
Alter Table Request Alter Column Last_Time varchar(8)
GO
Alter Table CLPrintLog Alter Column Time varchar(8)
GO
Alter Table Cheque Alter Column Last_Time varchar(8)
GO
Alter Table pVoucher Alter Column Last_Time varchar(8)
GO
Alter Table pVoucher Alter Column Posting_Time varchar(8)
GO
Alter Table GL_FiscalH Alter Column Last_Time varchar(8)
GO
Alter Table CPrintLog Alter Column Time varchar(8)
GO
Alter Table AdmLink Alter Column LTime varchar(8)
GO
Alter Table SysUpload Alter Column UserTime varchar(8)
GO
Alter Table SysBatchH Alter Column PTime varchar(8)
GO
Alter Table CLSurvey Alter Column STIME varchar(8)
GO
Alter Table Service Alter Column PUserTime varchar(8)
GO
Alter Table Service Alter Column LTime varchar(8)
GO
Alter Table Service Alter Column CTime varchar(8)
GO
Alter Table Service Alter Column CloseTime varchar(8)
GO
Alter Table Service Alter Column AUserTime varchar(8)
GO
Alter Table GL_AuditH Alter Column Last_Time varchar(8)
GO
Alter Table PNotify Alter Column Time varchar(8)
GO
Alter Table BAssumption_Exchange Alter Column Last_Time varchar(8)
GO
Alter Table BAssumption_Growth Alter Column Last_Time varchar(8)
GO
Alter Table BAssumption_Rate Alter Column Last_Time varchar(8)
GO
Alter Table BAssumption_Ratio Alter Column Last_Time varchar(8)
GO
Alter Table COLLECTIONH Alter Column Last_Time varchar(8)
GO
Alter Table SURVEYOR Alter Column STIME varchar(8)
GO
Alter Table PPrintLog Alter Column Time varchar(8)
GO
Alter Table PettyCashType Alter Column Last_Time varchar(8)
GO
Alter Table RPrintLog Alter Column Time varchar(8)
GO
Alter Table ACCLOG Alter Column PTIME varchar(8)
GO
Alter Table Budget_Account Alter Column Last_Time varchar(8)
GO
Alter Table TOC Alter Column DEFSTIME varchar(8)
GO
Alter Table TOC Alter Column DEFETIME varchar(8)
GO
Alter Table SysRequest Alter Column UserTime varchar(8)
GO
Alter Table SysRequest Alter Column LUserTime varchar(8)
GO
Alter Table Budget_AccountDetail Alter Column Last_Time varchar(8)
GO
Alter Table Budget_AccountGroup Alter Column Last_Time varchar(8)
GO
Alter Table CLComplaint Alter Column CTIME varchar(8)
GO
Alter Table CLComplaint Alter Column LTime varchar(8)
GO
Alter Table Budget_Activity Alter Column Last_Time varchar(8)
GO
Alter Table PCSummary Alter Column Last_Time varchar(8)
GO
Alter Table Budget_Center Alter Column Last_Time varchar(8)
GO
Alter Table nJournal Alter Column Last_Time varchar(8)
GO
Alter Table SysProcH Alter Column Time varchar(8)
GO
Alter Table pJournal Alter Column Last_Time varchar(8)
GO
Alter Table SysInforce Alter Column UserTime varchar(8)
GO
Alter Table ActionNotification Alter Column ActionTime varchar(8)
GO
Alter Table COVER Alter Column LTime varchar(8)
GO
Alter Table COVER Alter Column CTime varchar(8)
GO
Alter Table COVER Alter Column AUserTime varchar(8)
GO
Alter Table COVER Alter Column CloseTime varchar(8)
GO
Alter Table COVER Alter Column PUserTime varchar(8)
GO
Alter Table SysProcess Alter Column StartTime varchar(8)
GO
Alter Table SysProcess Alter Column EndTime varchar(8)
GO
Alter Table SysProclib Alter Column CTime varchar(8)
GO
Alter Table SysProclib Alter Column PTime varchar(8)
GO
Alter Table SysLogDownload Alter Column PTIME varchar(8)
GO
Alter Table VPrintLog Alter Column Time varchar(8)
GO
Alter Table ACCLINK Alter Column LTime varchar(8)
GO
Alter Table BPP Alter Column Last_Time varchar(8)
GO
Alter Table ACCEPTANCE Alter Column ActionTime varchar(8)
GO
Alter Table ACCEPTANCE Alter Column LTime varchar(8)
GO
Alter Table ACCEPTANCE Alter Column CTime varchar(8)
GO
Alter Table ACCEPTANCE Alter Column CloseTime varchar(8)
GO
Alter Table ACCEPTANCE Alter Column AUserTime varchar(8)
GO
Alter Table ACCEPTANCE Alter Column STime varchar(8)
GO
Alter Table ACCEPTANCE Alter Column ETime varchar(8)
go

IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'ctime' AND Object_ID = Object_ID(N'pvoucher'))
BEGIN
alter table pvoucher add ctime varchar(8)
END
GO
IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'ctime' AND Object_ID = Object_ID(N'mvoucher'))
BEGIN
alter table mvoucher add ctime varchar(8)
END
GO
IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'ctime' AND Object_ID = Object_ID(N'nvoucher'))
BEGIN
alter table nvoucher add ctime varchar(8)
END
GO
--26 sept 2017 
/* To prevent any potential data loss issues, you should review this script in detail before running it outside the context of the database designer.*/
IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'BinderNo' AND Object_ID = Object_ID(N'FPART'))
BEGIN
ALTER TABLE dbo.FPART ADD
	BinderNo varchar(50) NULL
DECLARE @v sql_variant 
SET @v = N'Binder No.'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'FPART', N'COLUMN', N'BinderNo'
ALTER TABLE dbo.FPART SET (LOCK_ESCALATION = TABLE)
END
GO

DROP Procedure QFacultative_Data
GO
CREATE Procedure QFacultative_Data(@P_ANO integer, @P_FID varchar(20))                    
AS                                  
SELECT R.FID, R.AType, F.SLIPNO, R.SDATE, R.EDATE, R.RTYPE, F.ID, R.SHARE, R.FLPCT, R.AMOUNT, R.LIMIT, R.EXCESS, R.UJROHREINS, R.UJROHCEDANT,                    
R.UserID, R.CDate,                  
R.LUserID, R.LDate,                  
R.AUserID, R.AUserDate,            
R.AcceptedBy, R.AcceptedDate,             
R.ClaimCOOP, R.PrecedeFacCessionF, R.NoRefundF,   
F.Code, F.COMM, F.OCOMM, F.ACQCOST, F.NETRATE, F.Currency, F.Unit, R.PCALC, R.CPCT, R.Memo, F.REMARKS, F.WPC, F.BinderNo, F.BinderWarranty, R.FULLCOVERF, R.ORIGINALF, R.OnGrossAfterCommF, R.OnNetRateF, R.CPRefund, F.PERIOD, F.INSTALLMENT,       
F.GRACE, R.JPSLIPNO, R.JPSHARE, R.JPCOMM,                    
F.CommAmount, F.OCommAmount, F.ProfitSharing, F.Discount, F.BRID, F.BRComm,
F.IDATE_1, F.IPCT_1,                    
F.IDATE_2, F.IPCT_2,                    
F.IDATE_3, F.IPCT_3,                    
F.IDATE_4, F.IPCT_4,                    
F.IDATE_5, F.IPCT_5,                    
F.IDATE_6, F.IPCT_6,                    
F.IDATE_7, F.IPCT_7,                    
F.IDATE_8, F.IPCT_8,                    
F.IDATE_9, F.IPCT_9,                    
F.IDATE_10, F.IPCT_10,                    
F.IDATE_11, F.IPCT_11,                    
F.IDATE_12 , F.IPCT_12,      
F.IDATE_13 , F.IPCT_13,                    
F.IDATE_14 , F.IPCT_14,                    
F.IDATE_15 , F.IPCT_15,                    
F.IDATE_16 , F.IPCT_16,                    
F.IDATE_17 , F.IPCT_17,                    
F.IDATE_18 , F.IPCT_18,                    
F.IDATE_19 , F.IPCT_19,                    
F.IDATE_20 , F.IPCT_20,                    
F.IDATE_21 , F.IPCT_21,                    
F.IDATE_22 , F.IPCT_22,                    
F.IDATE_23 , F.IPCT_23,                    
F.IDATE_24 , F.IPCT_24      
FROM RARRDET R, FPART F                    
WHERE R.ANO=@P_ANO AND R.FID=@P_FID AND F.ANO=R.ANO AND F.FID=R.FID   
GO

--26 sept 2017 (1)
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
IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'PEDATE' AND Object_ID = Object_ID(N'ACCLOG'))
BEGIN
ALTER TABLE dbo.ACCLOG ADD
	PEDATE smalldatetime NULL
END
GO
ALTER TABLE dbo.ACCLOG SET (LOCK_ESCALATION = TABLE)
GO
UPDATE ACCLOG SET PEDATE=dateadd(day,-1,PDATE) FROM ACCLOG WHERE PEDATE IS NULL
COMMIT

--26 sept 2017 (2)
DROP PROCEDURE QCLACC_3
GO
CREATE PROCEDURE QCLACC_3(@P_POLICYNO AS VARCHAR(255), @P_CERTIFICATENO VARCHAR(255), @P_REFNO varchar(50)='', @P_TOC varchar(10)='')     
AS     
SELECT TOP 10 ACCEPTANCE.ANO, ACCEPTANCE.POLICYNO, ACCEPTANCE.CERTIFICATENO, ACCEPTANCE.AID, COVER.INSURED, COVER.ISTYPE, ACCEPTANCE.TOC, ACCEPTANCE.SDATE, ACCEPTANCE.EDATE, Cover.PHolder, ACCEPTANCE.BRANCH, ACCEPTANCE.ANAME, PROFILE.RESTRICTEDF, PROFILE.NAME, ACCEPTANCE.PDATE, ACCEPTANCE.PPDATE, ACCEPTANCE.NCDATE,  ACCEPTANCE.EXTPERIOD,     
Case When GenDTab.Description is not null then ACCEPTANCE.ValueDesc else '' end as Description,     
coalesce(InParty.ID, coalesce(ISource.ID, Acceptance.AID)) as Payment,
coalesce(IProfile.Name, coalesce(PProfile.Name, Profile.Name)) as Payment_Name
FROM ACCEPTANCE WITH (INDEX(I_Acceptance_PolicyNo_CertificateNo))  
Left Join GenDTab On (GenDTab.FLDID=ACCEPTANCE.FLDID AND GenDTab.ValueID=ACCEPTANCE.ValueID)  
Inner Join COVER on (Cover.CNO=Acceptance.CNO)  
Left Join ISource On (ISource.CNO=Cover.CNO)   
Left Join InParty on (InParty.CNO=Cover.CNO and InParty.IType in ('MORTGAGE'))
Left Join Profile PProfile On (PProfile.ID=ISource.ID)  
Left Join Profile IProfile On (IProfile.ID=InParty.ID)  
Left Join Profile on (Profile.ID=Acceptance.AID)  
WHERE ACCEPTANCE.ATYPE Not In ('A','C') AND ACCEPTANCE.AStatus not in ('W','T') and COVER.CStatus not in ('R','P','C')     
AND ACCEPTANCE.PDATE<ACCEPTANCE.PPDATE AND ACCEPTANCE.ANO<>ACCEPTANCE.LANO   
AND ACCEPTANCE.POLICYNO<>'' AND ACCEPTANCE.POLICYNO LIKE @P_POLICYNO AND ACCEPTANCE.CERTIFICATENO LIKE @P_CERTIFICATENO     
AND ACCEPTANCE.TOC LIKE @P_TOC+'%' AND ACCEPTANCE.REFNO LIKE @P_REFNO+'%'  
ORDER BY ACCEPTANCE.ANO DESC     

go

--26 sept 2017 : comacc nominal
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
IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'Description' AND Object_ID = Object_ID(N'ComAcc_Cheque'))
BEGIN
ALTER TABLE dbo.ComAcc_Cheque ADD Description varchar(50) NULL
END
GO
IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'Nominal' AND Object_ID = Object_ID(N'ComAcc_Cheque'))
BEGIN
ALTER TABLE dbo.ComAcc_Cheque ADD Nominal float(53) NULL
END
GO
ALTER TABLE dbo.ComAcc_Cheque SET (LOCK_ESCALATION = TABLE)
GO
COMMIT


--27 sept 2017 
Update Profile Set Tax=5 Where TaxF=1 and TaxType='PASAL21'
go

--VERSIONING
insert into versioning
select '2017 V.2.15.0',GETDATE(),'2017 V.2.0.0',GETDATE(),'K: 2017 V.2.0.0',GETDATE()
go
