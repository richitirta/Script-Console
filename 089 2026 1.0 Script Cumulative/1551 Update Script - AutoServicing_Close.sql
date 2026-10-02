DROP Procedure AutoServicing_Close
GO
CREATE Procedure AutoServicing_Close(@P_PDate as smalldatetime)                  
as                  
Select S.SNO, S.ServiceNo
from Service S
Inner Join TOC on (TOC.TOC=S.TOC)
Where TOC.Validation<>0
and 
(
	(S.SStatus='R' and datediff(day,dateadd(day, TOC.Validation, S.LDate),@P_PDate)>0)
	or
	(S.SStatus='T' and datediff(day,dateadd(day, TOC.Validation, S.RUserDate),@P_PDate)>0)
	or
	(S.SStatus='P' and datediff(day,dateadd(day, TOC.Validation, S.PUserDate),@P_PDate)>0)
)

GO

insert into PatchVersioning
select '1551 Update Script - AutoServicing_Close.sql',GETDATE()
go	
  
Declare @PrevScript varchar(100)
Declare @CurrScript varchar(100)

Select @PrevScript=''
Select @CurrSCript='1551 Update Script - AutoServicing_Close.sql'


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