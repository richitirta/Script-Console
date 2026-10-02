
IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'FixedLength' AND Object_ID = Object_ID(N'ID_TYPE'))
BEGIN
ALTER TABLE dbo.ID_TYPE ADD
	FixedLength INT
DECLARE @v sql_variant 
SET @v = N'Fixed Length for validation maximum length of ID TYPE'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'ID_TYPE', N'COLUMN', N'FixedLength'
end
GO

