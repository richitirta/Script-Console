
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

--11 okt 2017
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
ALTER TABLE dbo.Profile ADD
	BVATF bit NULL,
	TVATF bit NULL
GO
DECLARE @v sql_variant 
SET @v = N'Apply Branch VAT (0 : No, 1 : Yes)'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'Profile', N'COLUMN', N'BVATF'
GO
DECLARE @v sql_variant 
SET @v = N'Apply TOC VAT (0 : No, 1 : Yes)'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'Profile', N'COLUMN', N'TVATF'
GO
ALTER TABLE dbo.Profile SET (LOCK_ESCALATION = TABLE)
GO
UPDATE PROFILE SET BVATF=0 Where BVATF IS NULL
UPDATE PROFILE SET TVATF=0 Where TVATF IS NULL
COMMIT


insert into SysForm(FName, Description, FCode, RequestF)
Select 'ALLOWPASSOBJRESTRICTION','ALLOW PASS OBJECT RESTRICTION','ACTIVITIES',0
go

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
ALTER TABLE dbo.TOC ADD
	ObjectRestrictionF bit NULL,
	EachAccRegF bit NULL
GO
DECLARE @v sql_variant 
SET @v = N'Check Object Restriction (0 : No, 1 : Yes, See QGet_Object_Restriction)'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'TOC', N'COLUMN', N'ObjectRestrictionF'
GO
DECLARE @v sql_variant 
SET @v = N'Check Duplicate Object For Each Accumulation Register (0 : No, 1 : Yes)'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'TOC', N'COLUMN', N'EachAccRegF'
GO
ALTER TABLE dbo.TOC SET (LOCK_ESCALATION = TABLE)
GO
Update TOC Set ObjectRestrictionF=0 Where ObjectRestrictionF is null
Update TOC Set EachAccRegF=0 Where EachAccRegF is null
COMMIT


Create Unique Index I_RPBUCKET on RPBUCKET(PID)
go


ALTER TABLE [dbo].[Service] DROP CONSTRAINT [FK_Service_Profile]
GO

Select * into #SysProcess from sysprocess where procname='AUTORECEIPT_PROCESS'
GO
Update #SysProcess set ProcName='AUTORECEIPTREQUEST_PROCESS', ScheduleF=0
GO
insert into SysProcess Select * from #SysProcess
GO


Alter Table ORPrintLog Add AmountVersion int
 go
 Alter Table ORPrintLog Add PrintVersion int 
 go
 update ORPrintLog set AmountVersion = 0 where AmountVersion is null 
 go
  update ORPrintLog set PrintVersion = 0 where PrintVersion is null
  go


  --
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
	AgreedF bit NULL
GO
DECLARE @v sql_variant 
SET @v = N'Deductible Amount Already Agreed (0 : No, 1 : Yes)'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'CLDED', N'COLUMN', N'AgreedF'
GO
ALTER TABLE dbo.CLDED SET (LOCK_ESCALATION = TABLE)
UPDATE CLDED Set AgreedF=0 Where AgreedF is null
GO
COMMIT
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
ALTER TABLE dbo.CLFACDED ADD
	AgreedF bit NULL
GO
DECLARE @v sql_variant 
SET @v = N'Deductible Amount Already Agreed (0 : No, 1 : Yes)'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'CLFACDED', N'COLUMN', N'AgreedF'
GO
ALTER TABLE dbo.CLFACDED SET (LOCK_ESCALATION = TABLE)
UPDATE CLFACDED Set AgreedF=0 Where AgreedF is null
GO
COMMIT

--VERSIONING
insert into versioning
select '2017 V.2.17.0',GETDATE(),'2017 V.2.0.0',GETDATE(),'K: 2017 V.2.0.0',GETDATE()
go
