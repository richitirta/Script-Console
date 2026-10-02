IF not EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[FK_CLDED_Profile]') AND parent_object_id = OBJECT_ID(N'[CLDED]'))
begin
ALTER TABLE [dbo].[CLDED]  WITH NOCHECK ADD  CONSTRAINT [FK_CLDED_Profile] FOREIGN KEY([ID])
REFERENCES [dbo].[Profile] ([ID])
ALTER TABLE [dbo].[CLDED] CHECK CONSTRAINT [FK_CLDED_Profile]
end
GO


IF not EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[FK_CLSAL_Profile]') AND parent_object_id = OBJECT_ID(N'[CLSAL]'))
begin
ALTER TABLE [dbo].[CLSAL]  WITH NOCHECK ADD  CONSTRAINT [FK_CLSAL_Profile] FOREIGN KEY([ID])
REFERENCES [dbo].[Profile] ([ID])
ALTER TABLE [dbo].[CLSAL] CHECK CONSTRAINT [FK_CLSAL_Profile]
end
GO



insert into PatchVersioning
select '55.43 Update Script - Patch 2020 (45)',GETDATE()
go


Declare @PrevScript varchar(100)
Declare @CurrScript varchar(100)

Select @PrevScript='55.42 Update Script - Patch 2020 (44)'
Select @CurrSCript='55.43 Update Script - Patch 2020 (45)'


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


