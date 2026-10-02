SET ARITHABORT ON
SET NUMERIC_ROUNDABORT OFF
SET CONCAT_NULL_YIELDS_NULL ON
SET ANSI_NULLS ON
SET ANSI_PADDING ON
SET ANSI_WARNINGS ON

BEGIN TRANSACTION
GO

ALTER TABLE dbo.ProAcc ADD
    Last_Time varchar(8) NULL
GO

DECLARE @v sql_variant
SET @v = N'Last Update Time'

EXECUTE sp_addextendedproperty
    N'MS_Description', @v,
    N'SCHEMA', N'dbo',
    N'TABLE', N'ProAcc',
    N'COLUMN', N'Last_Time'
GO

Update ProAcc Set Last_Time='' Where Last_Time is null
GO

COMMIT