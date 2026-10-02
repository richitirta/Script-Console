
IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'VATSubsidiesF' AND Object_ID = Object_ID(N'Profile'))
BEGIN
ALTER TABLE dbo.Profile ADD
	VATSubsidiesF bit NULL
DECLARE @v sql_variant 
SET @v = N'Apply VAT Subsidies for WH VAT (0 : No, 1 : Yes)'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'Profile', N'COLUMN', N'VATSubsidiesF'
end
GO

