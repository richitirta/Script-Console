


IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'DOCGROUP' AND Object_ID = Object_ID(N'DOCTYPE'))
BEGIN
SET QUOTED_IDENTIFIER ON
SET ARITHABORT ON
SET NUMERIC_ROUNDABORT OFF
SET CONCAT_NULL_YIELDS_NULL ON
SET ANSI_NULLS ON
SET ANSI_PADDING ON
SET ANSI_WARNINGS ON

ALTER TABLE dbo.DOCTYPE ADD
	DOCGROUP varchar(10) NULL

DECLARE @v sql_variant 
SET @v = N'Document Group '
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'DOCTYPE', N'COLUMN', N'DOCGROUP'
end
go


IF NOT EXISTS(SELECT * FROM SYSFORM WHERE FNAME='CHECKDOCAVAILABILITYYONLYWITHATTACHMENT')
BEGIN
Insert into SysForm(FName, Description, FCode, RequestF)
Select 'CHECKDOCAVAILABILITYYONLYWITHATTACHMENT','CHECK DOCUMENT AVAILABILITY ONLY WITH ATTACHED DOCUMENT','ACTIVITIES',0
end
go



  insert into PatchVersioning
select '1185 Update Script - 15 October 2024',GETDATE()
go	
  
Declare @PrevScript varchar(100)
Declare @CurrScript varchar(100)

Select @PrevScript=''
Select @CurrSCript='1185 Update Script - 15 October 2024'


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





