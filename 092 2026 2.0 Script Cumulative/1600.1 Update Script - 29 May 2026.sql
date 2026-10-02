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
IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'ShowEmailF' AND Object_ID = Object_ID(N'pVoucher'))
ALTER TABLE dbo.pVoucher ADD
	ShowEmailF bit NULL
GO
DECLARE @v sql_variant 
SET @v = N'Allow Show Email to External (0 : No, 1 : Yes)'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'pVoucher', N'COLUMN', N'ShowEmailF'
GO
Update pVoucher Set ShowEmailF=1 Where ShowEmailF is null
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
IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'ShowEmailF' AND Object_ID = Object_ID(N'Request'))

ALTER TABLE dbo.Request ADD
	ShowEmailF bit NULL
GO
DECLARE @v sql_variant 
SET @v = N'Allow Show Email to External (0 : No, 1 : Yes)'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'Request', N'COLUMN', N'ShowEmailF'
GO
Update Request Set ShowEmailF=1 Where ShowEmailF is null
GO
COMMIT
