SET QUOTED_IDENTIFIER ON
SET ARITHABORT ON
SET NUMERIC_ROUNDABORT OFF
SET CONCAT_NULL_YIELDS_NULL ON
SET ANSI_NULLS ON
SET ANSI_PADDING ON
SET ANSI_WARNINGS ON

IF NOT EXISTS(SELECT * FROM SYSFORM WHERE FNAME='Forceprofileverification')
BEGIN
insert into sysform(FName, Description, FCode, RequestF)
Select 'Forceprofileverification', 'Force Profile Verification','ACTIVITIES',0
end
go

IF NOT EXISTS(SELECT * FROM SYSFORM WHERE FNAME='AllowChangeDumpF')
BEGIN
insert into sysform(FName, Description, FCode, RequestF)
Select 'AllowChangeDumpF', 'Allow Change DumpF','ACTIVITIES',0
end
go




insert into PatchVersioning
select '1416 04 Script Forceprofileverification AllowChangeDumpF',GETDATE()
go	
  
Declare @PrevScript varchar(100)
Declare @CurrScript varchar(100)

Select @PrevScript=''
Select @CurrScript='1416 04 Script Forceprofileverification AllowChangeDumpF'


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