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
ALTER TABLE dbo.SysUser ADD
	AccountNo varchar(150) NULL,
	BankAccount varchar(150) NULL,
	BankName varchar(255) NULL
GO
DECLARE @v sql_variant 
SET @v = N'Bank Account No.'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'SysUser', N'COLUMN', N'AccountNo'
GO
DECLARE @v sql_variant 
SET @v = N'Bank Account'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'SysUser', N'COLUMN', N'BankAccount'
GO
DECLARE @v sql_variant 
SET @v = N'Bank Name'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'SysUser', N'COLUMN', N'BankName'
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
ALTER TABLE dbo.SysUser ADD
	BankCurrency varchar(10) NULL
GO
DECLARE @v sql_variant 
SET @v = N'Bank Currency (see MW_Currency)'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'SysUser', N'COLUMN', N'BankCurrency'
GO
COMMIT

