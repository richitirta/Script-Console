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
IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'A_RefNo' AND Object_ID = Object_ID(N'ARBucket'))

ALTER TABLE dbo.ARBucket ADD
	A_RefNo varchar(50) NULL
GO
DECLARE @v sql_variant 
SET @v = N'Policy Reference No. '
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'ARBucket', N'COLUMN', N'A_RefNo'
GO
Update ARBucket Set A_RefNo='' Where A_RefNo is null
GO
COMMIT
