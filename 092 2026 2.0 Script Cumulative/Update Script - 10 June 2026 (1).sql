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
ALTER TABLE dbo.TOP_Interest ADD
	HoldF bit NULL
GO
DECLARE @v sql_variant 
SET @v = N'Hold for Max Amount Checking (0 : No, 1 : Yes)'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'TOP_Interest', N'COLUMN', N'HoldF'
GO
Update TOP_Interest Set HoldF=0 Where HoldF is null
GO
COMMIT
