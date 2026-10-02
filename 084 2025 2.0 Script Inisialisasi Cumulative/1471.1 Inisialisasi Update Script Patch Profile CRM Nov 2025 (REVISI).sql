Update Profile Set CRM_NO='' Where CRM_NO is null
GO

Update Profile Set RequestF=0 Where RequestF is null
GO

Update Profile Set RequestMessage='' Where RequestMessage is null
GO

Update Profile Set RequestName='' Where RequestName is null
GO

Update Profile Set CTime='' Where CTime is null
GO

Update Profile Set CTime='' Where CTime is null
GO


insert into PatchVersioning
select '1471.1 Inisialisasi Update Script Patch Profile CRM Nov 2025 (REVISI).sql',GETDATE()
go	
  
Declare @PrevScript varchar(100)
Declare @CurrScript varchar(100)

Select @PrevScript=''
Select @CurrSCript='1471.1 Inisialisasi Update Script Patch Profile CRM Nov 2025 (REVISI).sql'


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