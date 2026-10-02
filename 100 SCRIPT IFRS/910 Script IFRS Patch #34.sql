IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'RefFKNo' AND Object_ID = Object_ID(N'IFRS_Initial'))
BEGIN
ALTER TABLE IFRS_Initial ADD RefFKNo int NULL
DECLARE @v sql_variant 
SET @v = N'Reference Foreign Key No (see Acceptance.ANO or Policy.ANO)'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'IFRS_Initial', N'COLUMN', N'RefFKNo'
END
GO

IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'RefFKType' AND Object_ID = Object_ID(N'IFRS_Initial'))
BEGIN
ALTER TABLE IFRS_Initial ADD RefFKType varchar(10) NULL
DECLARE @v sql_variant 
SET @v = N'Reference Foreign Key Type (''CGISS'', ''CHISS, ''UPLOAD'')'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'IFRS_Initial', N'COLUMN', N'RefFKType'
END
GO

ALTER TABLE dbo.IFRS_Initial SET (LOCK_ESCALATION = TABLE)
GO

INSERT INTO PatchVersioning
SELECT '840 Update Script - IFRS Patch #34',GETDATE()
GO