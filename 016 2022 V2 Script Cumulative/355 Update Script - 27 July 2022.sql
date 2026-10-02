

IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'SDESCRIPTION' AND Object_ID = Object_ID(N'COMPLIANCES'))
BEGIN
ALTER TABLE dbo.COMPLIANCES ADD
	SDESCRIPTION varchar(255) NULL
DECLARE @v sql_variant 
SET @v = N'Default Scoring Description'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'COMPLIANCES', N'COLUMN', N'SDESCRIPTION'
END
GO


IF  NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'COMPLIANCEUI') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[COMPLIANCEUI](
	[CID] [varchar](10) NOT NULL,
	[ID] [varchar](10) NOT NULL,
	[INDICATOR] [varchar](10) NOT NULL,
	[LAST_UPDATE] [smalldatetime] NULL,
	[LAST_OPR] [varchar](50) NULL,
 CONSTRAINT [I_COMPLIANCEUI] PRIMARY KEY CLUSTERED 
(
	[CID] ASC,
	[ID] ASC,
	[INDICATOR] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]


SET ANSI_PADDING OFF

ALTER TABLE [dbo].[COMPLIANCEUI]  WITH NOCHECK ADD  CONSTRAINT [FK_COMPLIANCEUI_COMPLIANCEU] FOREIGN KEY([CID],[ID])
REFERENCES [dbo].[COMPLIANCEU] ([CID],[ID])
ON UPDATE CASCADE
ON DELETE CASCADE

ALTER TABLE [dbo].[COMPLIANCEUI] CHECK CONSTRAINT [FK_COMPLIANCEUI_COMPLIANCEU]


EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Compliance Risk ID (see COMPLIANCE)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'COMPLIANCEUI', @level2type=N'COLUMN',@level2name=N'CID'

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Compliance Risk User Authorized Approval' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'COMPLIANCEUI', @level2type=N'COLUMN',@level2name=N'ID'

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Last Update Date' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'COMPLIANCEUI', @level2type=N'COLUMN',@level2name=N'LAST_UPDATE'

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Last User Update ' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'COMPLIANCEUI', @level2type=N'COLUMN',@level2name=N'LAST_OPR'

END
GO







 insert into PatchVersioning
select '355 Update Script - 27 July 2022',GETDATE()
go


Declare @PrevScript varchar(100)
Declare @CurrScript varchar(100)

Select @PrevScript=''
Select @CurrSCript='355 Update Script - 27 July 2022'


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