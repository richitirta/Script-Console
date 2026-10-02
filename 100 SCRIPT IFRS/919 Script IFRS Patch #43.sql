IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'AddMonths' AND Object_ID = Object_ID(N'IFRS_Calculation'))
BEGIN
ALTER TABLE IFRS_Calculation ADD AddMonths int NULL
DECLARE @v sql_variant 
SET @v = N'Add Month, Additional Month for PAA 24th Method'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'IFRS_Calculation', N'COLUMN', N'AddMonths'
END
GO

IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'AddMonths' AND Object_ID = Object_ID(N'IFRS_Initial'))
BEGIN
ALTER TABLE IFRS_Initial ADD AddMonths int NULL
DECLARE @v sql_variant 
SET @v = N'Add Month, Additional Month for PAA 24th Method'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'IFRS_Initial', N'COLUMN', N'AddMonths'
END
GO

 insert into PatchVersioning
select '919 Update Script - IFRS Patch #43',GETDATE()
go
