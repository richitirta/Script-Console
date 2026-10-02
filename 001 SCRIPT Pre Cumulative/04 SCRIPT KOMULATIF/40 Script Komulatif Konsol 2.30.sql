--23 jan 2018
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
ALTER TABLE dbo.ACCCNC ADD
	USERID varchar(50) NULL,
	PDATE smalldatetime NULL,
	PTIME varchar(5) NULL
GO
ALTER TABLE dbo.ACCCNC SET (LOCK_ESCALATION = TABLE)
GO
COMMIT

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
ALTER TABLE dbo.RATETAB ADD
	COMPULSORYF bit NULL
GO
DECLARE @v sql_variant 
SET @v = N'Compulsory Cover'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'RATETAB', N'COLUMN', N'COMPULSORYF'
GO
ALTER TABLE dbo.RATETAB SET (LOCK_ESCALATION = TABLE)
GO
UPDATE RATETAB SET COMPULSORYF=0 WHERE COMPULSORYF IS NULL
COMMIT



ALTER TABLE ACCDED ALTER COLUMN REMARKS Varchar(900)
GO
ALTER TABLE ACCDED ALTER COLUMN REMARKS_1 Varchar(900)
GO
ALTER TABLE CLDED ALTER COLUMN REMARK Varchar(900)
GO
ALTER TABLE CLDED ALTER COLUMN REMARKS_1 Varchar(900)
GO


alter table sysbatchd drop constraint fk_sysBatchD_SysBatchH
GO
Alter Table SysBatchH drop constraint I_SysBatchH
go
create unique index I_SysBatchH on SysBatchH(BatchNo)
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
ALTER TABLE dbo.PettyCashType ADD
	MaxAmount float(53) NULL
GO
DECLARE @v sql_variant 
SET @v = N'Max Request Amount'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'PettyCashType', N'COLUMN', N'MaxAmount'
GO
ALTER TABLE dbo.PettyCashType SET (LOCK_ESCALATION = TABLE)
GO
UPDATE PettycashType Set MaxAmount=0 Where MaxAmount is null
COMMIT


insert into sysform(FName, Description, FCode)
Select 'FORCECHECKCOC','FORCE CHECK CERTIFICATE OF COVER','ACTIVITIES'
GO

ALTER TABLE [RPBucket] ADD
	[A_PolicyNo] [varchar](50) NULL,
	[Rate] [float] NULL,
	[MVOUCHER] [varchar](20) NULL
GO

Create Index I_RPBUCKET_VOUCHER on RPBUCKET(VOUCHER)
GO
Create Index I_RPBUCKET_VOUCHER_NVOUCHER on RPBUCKET(VOUCHER,NVOUCHER)
GO


Create index I_AccAss_ANO_ID_TOC_TYPE_CURRENCY_REFNO_SDATE_DATE_BILLDATE on AccAss(ANO, ID, TOC, TYPE, CURRENCY, REFNO, SDATE, DATE, BILLDATE)
go

--VERSIONING
insert into versioning
select '2017 V.2.30.0',GETDATE(),'2017 V.2.0.0',GETDATE(),'K: 2017 V.2.0.0',GETDATE()
go
