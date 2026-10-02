SET QUOTED_IDENTIFIER ON
SET ARITHABORT ON
SET NUMERIC_ROUNDABORT OFF
SET CONCAT_NULL_YIELDS_NULL ON
SET ANSI_NULLS ON
SET ANSI_PADDING ON
SET ANSI_WARNINGS ON


SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

IF  NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Consent]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[Consent](
	[ConsentID] [varchar](10) NOT NULL,
	[Description] [varchar](512) NULL,
	[AllowedF] [bit] NULL,
	[Last_OPR] [varchar](50) NULL,
	[Last_Update] [smalldatetime] NULL,
 CONSTRAINT [i_Consent] PRIMARY KEY CLUSTERED 
(
	[ConsentID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = OFF) ON [PRIMARY]
) ON [PRIMARY]
END
GO

ALTER TABLE [dbo].[Consent] SET (LOCK_ESCALATION = DISABLE)
GO


SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

IF  NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Profile_Consent]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[Profile_Consent](
	[ID] [varchar](10) NOT NULL,
	[ConsentID] [varchar](10) NOT NULL,
	[AgreedF] [Bit] NOT NULL,
	[Last_Opr] [varchar](50) NULL,
	[Last_Update] smalldatetime NULL,
 CONSTRAINT [I_Profile_Consent]  UNIQUE NONCLUSTERED
(
	[ID] ASC,
	[ConsentID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = OFF) ON [PRIMARY]
) ON [PRIMARY]
END
GO

ALTER TABLE [dbo].[Profile_Consent]  ADD  CONSTRAINT [FK_Profile_Consent_Profile] FOREIGN KEY([ID])
REFERENCES [dbo].[Profile] ([ID])
ON UPDATE CASCADE
ON DELETE CASCADE
GO

ALTER TABLE [dbo].[Profile_Consent]  ADD  CONSTRAINT [FK_Profile_Consent_Consent] FOREIGN KEY([ConsentID])
REFERENCES [dbo].[Consent] ([ConsentID])
GO

SET ANSI_PADDING OFF
GO

ALTER TABLE [dbo].[Profile_Consent] SET (LOCK_ESCALATION = DISABLE)
GO

insert into PatchVersioning
select '1366 Update Script - 25 June 2025',GETDATE()
go	
  

Declare @PrevScript varchar(100)
Declare @CurrScript varchar(100)

Select @PrevScript=''
Select @CurrSCript='1366 Update Script - 25 June 2025'


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
