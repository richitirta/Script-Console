DROP Procedure QOverlapped_Risk
GO
CREATE Procedure QOverlapped_Risk(@P_ANO integer) 
as 
Select Top 1 A1.ANO 
from Acceptance A1 
Inner Join RCover R1 on (R1.ANO=A1.ANO)
Where A1.ANO=@P_ANO and R1.Category='M' 
and not ((R1.SDate=A1.SDate or  R1.SDate=A1.PDate) and R1.EDate=A1.EDate) 
and Exists
( 
Select Top 1 R2.ANO 
from RCover R2 
Where R2.ANO=R1.ANO and R2.Category='M' 
and not (R2.Code=R1.Code and R2.Sdate=R1.Sdate) 
and not (R2.SDate=R1.SDate and R2.EDate=R1.EDate)
and 
( 
(R2.Sdate<R1.Edate and R2.Edate>=R1.Edate) or (R2.Sdate<=R1.Sdate and R2.Edate>R1.Sdate) or 
(R1.Sdate<=R2.Sdate and R1.Edate>R2.Sdate) or (R1.Sdate<R2.Edate and R1.Edate>=R2.Edate) 
) 
) 
go



 insert into PatchVersioning
select '416 Update Script - Patch 2022 (72)',GETDATE()
go


Declare @PrevScript varchar(100)
Declare @CurrScript varchar(100)

Select @PrevScript=''
Select @CurrSCript='416 Update Script - Patch 2022 (72)'


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



