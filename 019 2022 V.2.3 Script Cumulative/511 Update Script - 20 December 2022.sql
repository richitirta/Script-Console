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
ALTER TABLE dbo.BusinessResult ADD
	OPFee float(53) NULL
GO
Update BusinessResult set OPFEe=0 Where OPFEE is null
GO
COMMIT


 insert into PatchVersioning
select '511 Update Script - 20 December 2022',GETDATE()
go
