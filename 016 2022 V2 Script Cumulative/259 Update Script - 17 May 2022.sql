IF  NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'ISSecurity') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[ISSecurity](
	[CNO] [int] NOT NULL,
	[ID] [varchar](10) NOT NULL,
	[SHARE] [float] NULL
) ON [PRIMARY]
SET ANSI_PADDING OFF

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Cover No. (see Cover)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'ISSecurity', @level2type=N'COLUMN',@level2name=N'CNO'
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Source Profile ID' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'ISSecurity', @level2type=N'COLUMN',@level2name=N'ID'
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'% Security Share' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'ISSecurity', @level2type=N'COLUMN',@level2name=N'SHARE'

end
GO


IF NOT EXISTS(SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID('FK_ISSecurity_Profile') AND parent_object_id = OBJECT_ID('ISSecurity'))
BEGIN
ALTER TABLE [dbo].[ISSecurity]  WITH NOCHECK ADD  CONSTRAINT [FK_ISSecurity_Profile] FOREIGN KEY([ID])
REFERENCES [dbo].[Profile] ([ID])
end
GO

ALTER TABLE [dbo].[ISSecurity] CHECK CONSTRAINT [FK_ISSecurity_Profile]
GO

IF NOT EXISTS(SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID('FK_ISSecurity_ISource') AND parent_object_id = OBJECT_ID('ISSecurity'))
BEGIN
ALTER TABLE [dbo].[ISSecurity]  WITH NOCHECK ADD  CONSTRAINT [FK_ISSecurity_ISource] FOREIGN KEY([CNO])
REFERENCES [dbo].[ISource] ([CNO])
ON UPDATE CASCADE
ON DELETE CASCADE
end
GO

ALTER TABLE [dbo].[ISSecurity] CHECK CONSTRAINT [FK_ISSecurity_ISource]
GO





 insert into PatchVersioning
select '259 Update Script - 17 May 2022',GETDATE()
go


Declare @PrevScript varchar(100)
Declare @CurrScript varchar(100)

Select @PrevScript=''
Select @CurrSCript='259 Update Script - 17 May 2022'


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




