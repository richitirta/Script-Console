IF EXISTS(SELECT * FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS WHERE TABLE_NAME='ALRule' AND CONSTRAINT_NAME='I_ALRule')
begin 
ALTER TABLE ALRule DROP CONSTRAINT I_ALRule
end
GO


IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'Source' AND Object_ID = Object_ID(N'ALRule'))
BEGIN
ALTER TABLE ALRule ADD
	Source varchar(10) NULL
DECLARE @v sql_variant 
SET @v = N'Business Source'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'ALRule', N'COLUMN', N'Source'
end
GO

update alrule set source='' where source is null
go

Alter Table ALRule Alter COlumn Source varchar(10) Not Null
GO

IF NOT EXISTS(SELECT * FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS WHERE TABLE_NAME='ALRule' AND CONSTRAINT_NAME='I_ALRule')
begin 
ALTER TABLE ALRule ADD CONSTRAINT
	I_ALRule PRIMARY KEY CLUSTERED 
	(
	TOC,
	Branch,
	Segment,
	Source
	) WITH( STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
end
GO

IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'Source' AND Object_ID = Object_ID(N'ALBucket'))
BEGIN
ALTER TABLE dbo.ALBucket ADD
	Source varchar(10) NULL
DECLARE @v sql_variant 
SET @v = N'Business Source'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'ALBucket', N'COLUMN', N'Source'
end
GO

insert into PatchVersioning
select '67 Update Script - 28 September 2021',GETDATE()
go

