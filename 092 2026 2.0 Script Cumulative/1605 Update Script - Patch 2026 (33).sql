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
IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'OTPInterval' AND Object_ID = Object_ID(N'SysUserActivity'))

ALTER TABLE dbo.SysUserActivity ADD
	OTPInterval int NULL
GO
DECLARE @v sql_variant 
SET @v = N'OTP Interval Request No (0 : Start, 1 : dst-nya)'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'SysUserActivity', N'COLUMN', N'OTPInterval'
GO
Update SysUserActivity Set OTPInterval=0 Where OTPInterval Is null
GO
COMMIT
