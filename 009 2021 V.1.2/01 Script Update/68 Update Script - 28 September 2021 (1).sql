
IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'AutoGenerateRenewalF' AND Object_ID = Object_ID(N'ACCEPTANCE'))
BEGIN
ALTER TABLE ACCEPTANCE ADD
	AutoGenerateRenewalF bit NULL
DECLARE @v sql_variant 
SET @v = N'Auto Generate Renewal Policy (0 : No, 1 : Yes)'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'ACCEPTANCE', N'COLUMN', N'AutoGenerateRenewalF'
end
GO

insert into PatchVersioning
select '68 Update Script - 28 September 2021 (1)',GETDATE()
go
