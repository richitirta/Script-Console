IF  NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'CLNStatus') AND type in (N'U'))
BEGIN

CREATE TABLE [dbo].[CLNStatus](
	[Status] [varchar](10) NOT NULL,
	[Description] [varchar](255) NOT NULL,
	[Category] [varchar](50) NOT NULL,
	[Last_Opr] varchar(50) NULL,
	[Last_Update] smalldatetime NULL,
	[AllowedF] [bit] NULL,
 CONSTRAINT [I_CLNStatus] PRIMARY KEY CLUSTERED 
(
	[Status] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]



SET ANSI_PADDING OFF
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Refer to CLNCategory' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'CLNStatus', @level2type=N'COLUMN',@level2name=N'Category'
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Allow Selection Flag (0  : No, 1 : Yes)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'CLNStatus', @level2type=N'COLUMN',@level2name=N'AllowedF'
end
go

IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS WHERE TABLE_NAME='CLNStatus' AND CONSTRAINT_NAME='I_CLNStatus')
Begin
ALTER TABLE [dbo].[CLNStatus] DROP CONSTRAINT [I_CLNStatus]
end
GO

alter table  CLNStatus alter column Status varchar(10) not null
go
IF not EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS WHERE TABLE_NAME='CLNStatus' AND CONSTRAINT_NAME='I_CLNStatus')
Begin
ALTER TABLE [dbo].[CLNStatus] ADD  CONSTRAINT [I_CLNStatus] PRIMARY KEY CLUSTERED 
(
	[Status] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
end
GO


IF  NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'PNStatus') AND type in (N'U'))
BEGIN

CREATE TABLE [dbo].[PNStatus](
	[Status] [varchar](10) NOT NULL,
	[Description] [varchar](255) NOT NULL,
	[Category] [varchar](50) NOT NULL,
	[Last_Opr] varchar(50) NULL,
	[Last_Update] smalldatetime NULL,
	[AllowedF] [bit] NULL,
 CONSTRAINT [I_PNStatus] PRIMARY KEY CLUSTERED 
(
	[Status] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]


SET ANSI_PADDING OFF

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Refer to PNCategory' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PNStatus', @level2type=N'COLUMN',@level2name=N'Category'

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Allow Selection Flag (0  : No, 1 : Yes)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PNStatus', @level2type=N'COLUMN',@level2name=N'AllowedF'
end
go

IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS WHERE TABLE_NAME='PNStatus' AND CONSTRAINT_NAME='I_PNStatus')
Begin
ALTER TABLE [dbo].[PNStatus] DROP CONSTRAINT [I_PNStatus]
end
GO
alter table  PNStatus alter column Status varchar(10) not null
go
IF not EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS WHERE TABLE_NAME='PNStatus' AND CONSTRAINT_NAME='I_PNStatus')
Begin
ALTER TABLE [dbo].[PNStatus] ADD  CONSTRAINT [I_PNStatus] PRIMARY KEY CLUSTERED 
(
	[Status] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
end
GO


IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'Status' AND Object_ID = Object_ID(N'CLNOTES'))
BEGIN
ALTER TABLE dbo.CLNOTES ADD
	Status varchar(10) NULL
DECLARE @v sql_variant 
SET @v = N'Refer to CLNStatus'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'CLNOTES', N'COLUMN', N'Status'
end
GO

alter table  CLNOTES alter column Status varchar(10)
go

IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'Status' AND Object_ID = Object_ID(N'PNOTES'))
BEGIN
ALTER TABLE dbo.PNOTES ADD
	Status varchar(10) NULL
DECLARE @v sql_variant 
SET @v = N'Refer to PNStatus'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'PNOTES', N'COLUMN', N'Status'
end
GO

alter table  PNOTES alter column Status varchar(10)
go

 insert into PatchVersioning
select '286 Update Script - 3 June 2022 (1)',GETDATE()
go


Declare @PrevScript varchar(100)
Declare @CurrScript varchar(100)

Select @PrevScript=''
Select @CurrSCript='286 Update Script - 3 June 2022 (1)'


Declare @ExecScript varchar(100)
Declare @ExecScriptStatus varchar(100)
Declare @Error varchar(200)

Select @Error=''

Begin 
       Select @ExecScript=Execscript,  @ExecScriptStatus=ExecScriptStatus from systab 
       if @PrevScript<>'' and @ExecSCript<>@PrevScript
              THROW 51000, 'Not the Next Sequence Script', 1;
       else 
              if @ExecScriptStatus<>'' and @ExecScriptStatus<>'DONE'
              THROW 51000, 'Pending Script Execution', 1;

       Update SysTab Set ExecScript=@CurrScript, ExecScriptStatus='PENDING'             
       
       BEGIN TRY            
			PRINT '--EXECUTE DONE--'
       END TRY  
       BEGIN CATCH  
       END CATCH;


       Update SysTab Set ExecScript=@CurrScript, ExecScriptStatus='DONE'         
End




go
