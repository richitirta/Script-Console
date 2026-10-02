IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'MinBackDatedPolicy' AND Object_ID = Object_ID(N'TOC'))
BEGIN
ALTER TABLE TOC ADD
	MinBackDatedPolicy int NULL
DECLARE @v sql_variant 
SET @v = N'Min Policy Backdated (in days)'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'TOC', N'COLUMN', N'MinBackDatedPolicy'
end
go

IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'MaxBackDatedPolicy' AND Object_ID = Object_ID(N'TOC'))
BEGIN
ALTER TABLE TOC ADD
	MaxBackDatedPolicy int NULL
DECLARE @v sql_variant 
SET @v = N'Max Policy Backdated (in days)'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'TOC', N'COLUMN', N'MaxBackDatedPolicy'
end
GO


insert into PatchVersioning
select '79 Update Script - 7 October 2021',GETDATE()
go
