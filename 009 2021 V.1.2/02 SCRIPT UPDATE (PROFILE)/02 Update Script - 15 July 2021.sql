
IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'DeferralF' AND Object_ID = Object_ID(N'Profile'))
BEGIN
ALTER TABLE dbo.Profile ADD
	DeferralF bit NULL
DECLARE @v sql_variant 
SET @v = N'Deferral Profile (0 : No, 1 : Yes); Ex Because Of Incomplete Profile Document Attachment'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'Profile', N'COLUMN', N'DeferralF'
end
GO

