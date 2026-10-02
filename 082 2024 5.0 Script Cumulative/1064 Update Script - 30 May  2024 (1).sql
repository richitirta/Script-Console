IF  NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'FINDICATOR') AND type in (N'U'))
BEGIN
/****** Object:  Table [dbo].[FINDICATOR]    Script Date: 6/3/2024 4:27:20 PM ******/
SET ANSI_NULLS ON
 

SET QUOTED_IDENTIFIER ON
 

CREATE TABLE [dbo].[FINDICATOR](
	[FID] [varchar](10) NOT NULL,
	[DESCRIPTION] [varchar](255) NULL,
	[ALLOWEDF] [bit] NULL,
	[LAST_UPDATE] [smalldatetime] NULL,
	[LAST_OPR] [varchar](50) NULL,
	[MAXFPOINT] [int] NULL,
	[EFFECTIVE] [smalldatetime] NULL,
 CONSTRAINT [I_FINDICATOR] PRIMARY KEY CLUSTERED 
(
	[FID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = OFF) ON [PRIMARY]
) ON [PRIMARY]
 
ALTER TABLE [dbo].[FINDICATOR] SET (LOCK_ESCALATION = DISABLE)
end
go

IF  NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'FINDICATORI') AND type in (N'U'))
BEGIN
/****** Object:  Table [dbo].[FINDICATORI]    Script Date: 6/3/2024 4:27:20 PM ******/
SET ANSI_NULLS ON
 

SET QUOTED_IDENTIFIER ON
 

CREATE TABLE [dbo].[FINDICATORI](
	[FID] [varchar](10) NOT NULL,
	[INDICATOR] [varchar](10) NOT NULL,
	[SLOWER] [int] NULL,
	[SUPPER] [int] NULL,
	[LAST_UPDATE] [smalldatetime] NULL,
	[LAST_OPR] [varchar](50) NULL,
 CONSTRAINT [I_FINDICATORI] PRIMARY KEY CLUSTERED 
(
	[FID] ASC,
	[INDICATOR] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = OFF) ON [PRIMARY]
) ON [PRIMARY]
 
ALTER TABLE [dbo].[FINDICATORI] SET (LOCK_ESCALATION = DISABLE)

end
go


IF  NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'FINDICATORR') AND type in (N'U'))
BEGIN
/****** Object:  Table [dbo].[FINDICATORR]    Script Date: 6/3/2024 4:27:20 PM ******/
SET ANSI_NULLS ON
 

SET QUOTED_IDENTIFIER ON
 

CREATE TABLE [dbo].[FINDICATORR](
	[FID] [varchar](10) NOT NULL,
	[RISKNO] [varchar](10) NOT NULL,
	[DESCRIPTION] [varchar](255) NULL,
	[FPOINT] [int] NULL,
	[SPNAME] [varchar](255) NOT NULL,
	[LAST_UPDATE] [smalldatetime] NULL,
	[LAST_OPR] [varchar](50) NULL,
	[CATEGORY] [varchar](10) NULL,
 CONSTRAINT [I_FINDICATORR] PRIMARY KEY CLUSTERED 
(
	[FID] ASC,
	[RISKNO] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = OFF) ON [PRIMARY]
) ON [PRIMARY]
 

ALTER TABLE [dbo].[FINDICATORR] SET (LOCK_ESCALATION = DISABLE)

end
go


IF  NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'FINDICATORT') AND type in (N'U'))
BEGIN
/****** Object:  Table [dbo].[FINDICATORT]    Script Date: 6/3/2024 4:27:20 PM ******/
SET ANSI_NULLS ON
 

SET QUOTED_IDENTIFIER ON
 

CREATE TABLE [dbo].[FINDICATORT](
	[FID] [varchar](10) NOT NULL,
	[TOC] [varchar](10) NOT NULL,
	[MINTSI] [float] NULL,
	[MAXTSI] [float] NULL,
	[LAST_UPDATE] [smalldatetime] NULL,
	[LAST_OPR] [varchar](50) NULL,
	[BType] [varchar](1) NULL,
 CONSTRAINT [I_FINDICATORT] PRIMARY KEY CLUSTERED 
(
	[FID] ASC,
	[TOC] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = OFF) ON [PRIMARY]
) ON [PRIMARY]
 

ALTER TABLE [dbo].[FINDICATORT] SET (LOCK_ESCALATION = DISABLE)

end
go

IF  NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'FINDICATORU') AND type in (N'U'))
BEGIN
/****** Object:  Table [dbo].[FINDICATORU]    Script Date: 6/3/2024 4:27:20 PM ******/
SET ANSI_NULLS ON
 

SET QUOTED_IDENTIFIER ON
 

CREATE TABLE [dbo].[FINDICATORU](
	[FID] [varchar](10) NOT NULL,
	[ID] [varchar](10) NOT NULL,
	[LAST_UPDATE] [smalldatetime] NULL,
	[LAST_OPR] [varchar](50) NULL,
 CONSTRAINT [I_FINDICATORU] PRIMARY KEY CLUSTERED 
(
	[FID] ASC,
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
 

ALTER TABLE [dbo].[FINDICATORU] SET (LOCK_ESCALATION = DISABLE)
end
go

IF  NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'FINDICATORUI') AND type in (N'U'))
BEGIN
/****** Object:  Table [dbo].[FINDICATORUI]    Script Date: 6/3/2024 4:27:20 PM ******/
SET ANSI_NULLS ON
 

SET QUOTED_IDENTIFIER ON
 

CREATE TABLE [dbo].[FINDICATORUI](
	[FID] [varchar](10) NOT NULL,
	[ID] [varchar](10) NOT NULL,
	[INDICATOR] [varchar](10) NOT NULL,
	[LAST_UPDATE] [smalldatetime] NULL,
	[LAST_OPR] [varchar](50) NULL,
 CONSTRAINT [I_FINDICATORUI] PRIMARY KEY CLUSTERED 
(
	[FID] ASC,
	[ID] ASC,
	[INDICATOR] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = OFF) ON [PRIMARY]
) ON [PRIMARY]
 

ALTER TABLE [dbo].[FINDICATORUI] SET (LOCK_ESCALATION = DISABLE)
end
go

ALTER TABLE [dbo].[FINDICATOR] ADD  CONSTRAINT [DF_FINDICATOR_PASSGRADE]  DEFAULT ((0)) FOR [MAXFPOINT]
go

ALTER TABLE [dbo].[FINDICATORI]  WITH NOCHECK ADD  CONSTRAINT [FK_FINDICATORI_FINDICATOR] FOREIGN KEY([FID])
REFERENCES [dbo].[FINDICATOR] ([FID])
ON UPDATE CASCADE
ON DELETE CASCADE
GO

ALTER TABLE [dbo].[FINDICATORI] CHECK CONSTRAINT [FK_FINDICATORI_FINDICATOR]
GO

ALTER TABLE [dbo].[FINDICATORR]  WITH NOCHECK ADD  CONSTRAINT [FK_FINDICATORR_FINDICATOR] FOREIGN KEY([FID])
REFERENCES [dbo].[FINDICATOR] ([FID])
ON UPDATE CASCADE
ON DELETE CASCADE
GO

ALTER TABLE [dbo].[FINDICATORR] CHECK CONSTRAINT [FK_FINDICATORR_FINDICATOR]
GO

ALTER TABLE [dbo].[FINDICATORT]  WITH NOCHECK ADD  CONSTRAINT [FK_FINDICATORT_FINDICATOR] FOREIGN KEY([FID])
REFERENCES [dbo].[FINDICATOR] ([FID])
ON UPDATE CASCADE
ON DELETE CASCADE
GO

ALTER TABLE [dbo].[FINDICATORT] CHECK CONSTRAINT [FK_FINDICATORT_FINDICATOR]
GO

ALTER TABLE [dbo].[FINDICATORU]  WITH NOCHECK ADD  CONSTRAINT [FK_FINDICATORU_FINDICATOR] FOREIGN KEY([FID])
REFERENCES [dbo].[FINDICATOR] ([FID])
ON UPDATE CASCADE
ON DELETE CASCADE
GO

ALTER TABLE [dbo].[FINDICATORU] CHECK CONSTRAINT [FK_FINDICATORU_FINDICATOR]
GO

ALTER TABLE [dbo].[FINDICATORUI]  WITH NOCHECK ADD  CONSTRAINT [FK_FINDICATORUI_FINDICATORU] FOREIGN KEY([FID], [ID])
REFERENCES [dbo].[FINDICATORU] ([FID], [ID])
ON UPDATE CASCADE
ON DELETE CASCADE
GO

ALTER TABLE [dbo].[FINDICATORUI] CHECK CONSTRAINT [FK_FINDICATORUI_FINDICATORU]
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Fraud Group Indicator' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'FINDICATOR', @level2type=N'COLUMN',@level2name=N'FID'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Fraud Description ex. ''Fraud Indicator for MW''' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'FINDICATOR', @level2type=N'COLUMN',@level2name=N'DESCRIPTION'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Allow Flag (0 : No, 1 : Yes)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'FINDICATOR', @level2type=N'COLUMN',@level2name=N'ALLOWEDF'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Maxium Fraud Point Claim can be Proceed' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'FINDICATOR', @level2type=N'COLUMN',@level2name=N'MAXFPOINT'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Effective Date for Applying Compliance Risk' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'FINDICATOR', @level2type=N'COLUMN',@level2name=N'EFFECTIVE'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Fraud Group ID (see FINDICATOR)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'FINDICATORI', @level2type=N'COLUMN',@level2name=N'FID'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Fraud Group ID (see FINDICATOR)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'FINDICATORR', @level2type=N'COLUMN',@level2name=N'FID'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Fraud Risk ID' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'FINDICATORR', @level2type=N'COLUMN',@level2name=N'RISKNO'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Fraud Risk Description' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'FINDICATORR', @level2type=N'COLUMN',@level2name=N'DESCRIPTION'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Fraud Point' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'FINDICATORR', @level2type=N'COLUMN',@level2name=N'FPOINT'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Stored Process Name Execute by System Fraud (Param1 : CNO, Param2 : Date)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'FINDICATORR', @level2type=N'COLUMN',@level2name=N'SPNAME'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Category (''LOW'',''MEDIUM'',''HIGH'')' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'FINDICATORR', @level2type=N'COLUMN',@level2name=N'CATEGORY'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Fraud Group ID (see FINDICATOR)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'FINDICATORT', @level2type=N'COLUMN',@level2name=N'FID'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Sub Class Of Business (see TOC)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'FINDICATORT', @level2type=N'COLUMN',@level2name=N'TOC'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Minimum TSI for Compliance' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'FINDICATORT', @level2type=N'COLUMN',@level2name=N'MINTSI'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Maximum TSI for Compliance' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'FINDICATORT', @level2type=N'COLUMN',@level2name=N'MAXTSI'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Last Update Date' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'FINDICATORT', @level2type=N'COLUMN',@level2name=N'LAST_UPDATE'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Last User Update ' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'FINDICATORT', @level2type=N'COLUMN',@level2name=N'LAST_OPR'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Business Type ('''' All, ''D''irect, ''I''ndirect)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'FINDICATORT', @level2type=N'COLUMN',@level2name=N'BType'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Fraud Group ID (see FINDICATOR)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'FINDICATORU', @level2type=N'COLUMN',@level2name=N'FID'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'FINDICATOR Risk ID (see FINDICATOR)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'FINDICATORUI', @level2type=N'COLUMN',@level2name=N'FID'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'FINDICATOR Risk User Authorized Approval' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'FINDICATORUI', @level2type=N'COLUMN',@level2name=N'ID'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Last Update Date' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'FINDICATORUI', @level2type=N'COLUMN',@level2name=N'LAST_UPDATE'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Last User Update ' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'FINDICATORUI', @level2type=N'COLUMN',@level2name=N'LAST_OPR'
GO


insert into PatchVersioning
select '1064 Update Script - 30 May  2024 (1)',GETDATE()
go
	

Declare @PrevScript varchar(100)
Declare @CurrScript varchar(100)

Select @PrevScript=''
Select @CurrSCript='1064 Update Script - 30 May  2024 (1)'


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

