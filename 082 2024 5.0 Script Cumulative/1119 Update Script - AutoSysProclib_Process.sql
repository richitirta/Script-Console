IF EXISTS ( SELECT * FROM   sysobjects WHERE  id = object_id(N'AutoSysProclib_Process') and OBJECTPROPERTY(id, N'IsProcedure') = 1 )
BEGIN 
DROP Procedure AutoSysProclib_Process
END
GO
Create Procedure AutoSysProclib_Process(@P_PDate as smalldatetime)            
as            
Select S1.*   
from SysProcLib S1 with (readCommitted)   
Inner Join SysProcess S2 on (S2.ProcName=S1.ProcName)  
Where S1.PDate<=@P_PDate and S1.Status='W'   
and not exists (Select Top 1 objname from syslockedobject Where ObjName='SYSPROCLIB'+cast(S1.PID as varchar(10)) and Status='L')  
Order By S1.PID  
GO


  insert into PatchVersioning
select '1119 Update Script - AutoSysProclib_Process',GETDATE()
go
  
Declare @PrevScript varchar(100)
Declare @CurrScript varchar(100)

Select @PrevScript=''
Select @CurrSCript='1119 Update Script - AutoSysProclib_Process'


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

