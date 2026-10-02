IF  NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'Division') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[Division](
	[Division] [varchar](10) NOT NULL,
	[Description] [varchar](255) NULL,
	[Last_Opr] [varchar](50) NULL,
	[Last_Update] [smalldatetime] NULL,
 CONSTRAINT [I_Division] PRIMARY KEY CLUSTERED 
(
	[Division] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = OFF) ON [PRIMARY]
) ON [PRIMARY]
end

GO
IF  NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'Department') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[Department](
	[Department] [varchar](10) NOT NULL,
	[Description] [varchar](255) NULL,
	[Last_Opr] [varchar](50) NULL,
	[Last_Update] [smalldatetime] NULL,
 CONSTRAINT [I_Department] PRIMARY KEY CLUSTERED 
(
	[Department] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = OFF) ON [PRIMARY]
) ON [PRIMARY]
end
GO
IF  NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'RCCode') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[RCCode](
	[RCCode] [varchar](10) NOT NULL,
	[Description] [varchar](255) NULL,
	[Last_Opr] [varchar](50) NULL,
	[Last_Update] [smalldatetime] NULL,
 CONSTRAINT [I_RCCode] PRIMARY KEY CLUSTERED 
(
	[RCCode] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = OFF) ON [PRIMARY]
) ON [PRIMARY]
end
GO

IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'Division' AND Object_ID = Object_ID(N'CT'))
BEGIN
SET QUOTED_IDENTIFIER ON
SET ARITHABORT ON
SET NUMERIC_ROUNDABORT OFF
SET CONCAT_NULL_YIELDS_NULL ON
SET ANSI_NULLS ON
SET ANSI_PADDING ON
SET ANSI_WARNINGS ON
 
ALTER TABLE dbo.CT ADD
	Division varchar(10) NULL
	DECLARE @v sql_variant 
SET @v = N'Refer to Division Table'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'CT', N'COLUMN', N'Division'
end
go

IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'Department' AND Object_ID = Object_ID(N'CT'))
BEGIN
SET QUOTED_IDENTIFIER ON
SET ARITHABORT ON
SET NUMERIC_ROUNDABORT OFF
SET CONCAT_NULL_YIELDS_NULL ON
SET ANSI_NULLS ON
SET ANSI_PADDING ON
SET ANSI_WARNINGS ON
 
ALTER TABLE dbo.CT ADD
	Department varchar(10) NULL
	DECLARE @v sql_variant 
SET @v = N'Refer to Department'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'CT', N'COLUMN', N'Department'
end
go

IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'RCCode' AND Object_ID = Object_ID(N'CT'))
BEGIN
SET QUOTED_IDENTIFIER ON
SET ARITHABORT ON
SET NUMERIC_ROUNDABORT OFF
SET CONCAT_NULL_YIELDS_NULL ON
SET ANSI_NULLS ON
SET ANSI_PADDING ON
SET ANSI_WARNINGS ON
 
ALTER TABLE dbo.CT ADD
	RCCode varchar(10) NULL
	DECLARE @v sql_variant 
SET @v = N'Refer to Responsibility Center Code (RCCode Table)'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'CT', N'COLUMN', N'RCCode'
end
GO



  insert into PatchVersioning
select '1306 Update Script - 25 March 2025',GETDATE()
go	
  

Declare @PrevScript varchar(100)
Declare @CurrScript varchar(100)

Select @PrevScript=''
Select @CurrSCript='1306 Update Script - 25 March 2025'


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