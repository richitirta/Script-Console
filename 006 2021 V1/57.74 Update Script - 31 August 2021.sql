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

IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'CPCT' AND Object_ID = Object_ID(N'ALBucket'))
BEGIN
ALTER TABLE ALBucket ADD
	CPCT float(53) NULL
	end
GO
DECLARE @v sql_variant 
SET @v = N'Cancellation Percentage'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'ALBucket', N'COLUMN', N'CPCT'
GO
GO
COMMIT


  insert into PatchVersioning
select '57.74 Update Script - 31 August 2021',GETDATE()
go