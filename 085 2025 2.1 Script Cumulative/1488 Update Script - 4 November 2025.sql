IF  NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'SFSecurity') AND type in (N'U'))

BEGIN
CREATE TABLE [dbo].[SFSecurity](
	[SNO] [int] NOT NULL,
	[FID] [varchar](20) NOT NULL,
	[ID] [varchar](10) NOT NULL,
	[SHARE] [float] NULL,
	[COMM] [float] NULL,
	[REMARKS] [varchar](255) NULL,
	[Memo] [varchar](max) NULL,
 CONSTRAINT [I_SFSecurity] UNIQUE NONCLUSTERED 
(
	[SNO] ASC,
	[FID] ASC,
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
END
GO

ALTER TABLE [dbo].[SFSecurity] SET (LOCK_ESCALATION = DISABLE)
GO

ALTER TABLE [dbo].[SFSecurity]  WITH CHECK ADD  CONSTRAINT [FK_SFSecurity_Profile] FOREIGN KEY([ID])
REFERENCES [dbo].[Profile] ([ID])
GO

ALTER TABLE [dbo].[SFSecurity] CHECK CONSTRAINT [FK_SFSecurity_Profile]
GO

ALTER TABLE [dbo].[SFSecurity]  WITH CHECK ADD  CONSTRAINT [FK_SFSecurity_SRARRDET] FOREIGN KEY([SNO], [FID])
REFERENCES [dbo].[SRARRDET] ([SNO], [FID])
ON UPDATE CASCADE
ON DELETE CASCADE
GO

ALTER TABLE [dbo].[SFSecurity] CHECK CONSTRAINT [FK_SFSecurity_SRARRDET]
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Service No. (see Service)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'SFSecurity', @level2type=N'COLUMN',@level2name=N'SNO'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Facultative ID (see SRArrDet)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'SFSecurity', @level2type=N'COLUMN',@level2name=N'FID'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Reinsurance Profile ID' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'SFSecurity', @level2type=N'COLUMN',@level2name=N'ID'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'% Security Share' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'SFSecurity', @level2type=N'COLUMN',@level2name=N'SHARE'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'% Security Commission' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'SFSecurity', @level2type=N'COLUMN',@level2name=N'COMM'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Remarks' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'SFSecurity', @level2type=N'COLUMN',@level2name=N'REMARKS'
GO




insert into PatchVersioning
select '1488 Update Script - 4 November 2025.sql',GETDATE()
go	
  
Declare @PrevScript varchar(100)
Declare @CurrScript varchar(100)

Select @PrevScript=''
Select @CurrSCript='1488 Update Script - 4 November 2025.sql'


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

GO 