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
ALTER TABLE dbo.ARBucket ADD
	FutureMatchingF bit NULL,
	A_DocNo varchar(50) NULL
GO
DECLARE @v sql_variant 
SET @v = N'Future Matching Flag (0 : Not Allow, 1 : Yes Allow)'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'ARBucket', N'COLUMN', N'FutureMatchingF'
GO
DECLARE @v sql_variant 
SET @v = N'Voucher / Admlink DocNo'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'ARBucket', N'COLUMN', N'A_DocNo'
GO
UPDATE ARBUCKET SET FutureMatchingF=1, A_DocNo='' Where A_DocNo Is null
GO
COMMIT

