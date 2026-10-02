IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'Currency' AND Object_ID = Object_ID(N'ARBUCKET'))
BEGIN
alter table ARBUCKET Add Currency varchar(10)
END
GO
Update ARBucket Set Currency='' Where Currency is null
GO

IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'Subject' AND Object_ID = Object_ID(N'ARBUCKET'))
BEGIN
alter table ARBUCKET Add Subject varchar(10)
END
GO
Update ARBucket Set Subject='' Where Subject is null
GO

IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'ProcName' AND Object_ID = Object_ID(N'ARBUCKET'))
BEGIN
alter table ARBUCKET Add ProcName varchar(100)
END
GO
Update ARBucket Set ProcName='' Where ProcName is null
GO

IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'Type' AND Object_ID = Object_ID(N'ARBUCKET'))
BEGIN
alter table ARBUCKET Add Type varchar(10)
END
GO
Update ARBucket Set Type='' Where Type is null
GO


  insert into PatchVersioning
select '54.24 Update Script - ARBucket (Add Rev #1)',GETDATE()
go

Declare @PrevScript varchar(100)
Declare @CurrScript varchar(100)

Select @PrevScript='54.23 Update Script - AFDA_PROCESS'
Select @CurrSCript='54.24 Update Script - ARBucket (Add Rev #1)'


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





