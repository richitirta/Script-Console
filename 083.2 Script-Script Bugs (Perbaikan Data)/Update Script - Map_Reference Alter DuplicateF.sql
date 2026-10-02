/* To prevent any potential data loss issues, you should review this script in detail before running it outside the context of the database designer. */

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
/* To prevent any potential data loss issues, you should review this script in detail before running it outside the context of the database designer. */

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
IF EXISTS(SELECT * FROM sys.columns WHERE Name = N'DuplicateF' AND Object_ID = Object_ID(N'MAP_Reference'))
BEGIN
    ALTER TABLE MAP_Reference ALTER COLUMN DuplicateF Smallint
END
GO
COMMIT
DECLARE @v sql_variant
SET @v = N'Check Duplicate Data (0 : No, 1 : Yes, Accumulation Register or Unique RefNo, 2 : Yes, Unique RefNo Only)'
EXECUTE sp_updateextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'MAP_REFERENCE', N'COLUMN', N'DuplicateF'
GO


DECLARE @v sql_variant
SET @v = N'Check Duplicate Data (0 : No, 1 : Yes, Accumulation Register or Unique RefNo, 2 : Yes, Unique RefNo Only)'
EXECUTE sp_updateextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'MAP_REFERENCE', N'COLUMN', N'DuplicateF'
GO

COMMIT