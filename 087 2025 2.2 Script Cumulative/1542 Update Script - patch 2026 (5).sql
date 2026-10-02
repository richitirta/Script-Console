
Alter Table RCover Alter Column VESSEL varchar(8000) Null
GO
Alter Table RCover Alter Column VOYAGEFROM varchar(8000) Null
GO
Alter Table RCover Alter Column VOYAGETO varchar(8000) Null
GO
Alter Table RCover Alter Column PORTFROM varchar(8000) Null
GO
Alter Table RCover Alter Column PORTTO varchar(8000) Null
GO



insert into PatchVersioning
select '1542 Update Script - patch 2026 (5).sql',GETDATE()
go	
  
Declare @PrevScript varchar(100)
Declare @CurrScript varchar(100)

Select @PrevScript=''
Select @CurrSCript='1542 Update Script - patch 2026 (5).sql'


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