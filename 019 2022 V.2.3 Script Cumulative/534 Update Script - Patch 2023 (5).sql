DROP PROCEDURE QCCALC_1 
GO
CREATE PROCEDURE QCCALC_1 (@PCNO as integer) 
AS
SELECT CCALC.*, LCALC.RCODE, LCALC.TOR, ISOURCE.LIMIT, ISOURCE.EXCESS
FROM CCALC 
INNER JOIN CLAIM ON (CLAIM.CNO=CCALC.CNO) 
INNER JOIN ACCEPTANCE ON (ACCEPTANCE.ANO=CLAIM.ANO ) 
LEFT JOIN ISOURCE ON (ISOURCE.CNO=ACCEPTANCE.CNO)
OUTER APPLY (SELECT TOP 1 TOR, CODE AS RCODE FROM LCALC WHERE CNO=CCALC.CNO Order By Case When LCALC.Currency=CCALC.Currency Then 0 Else 1 End, Code, TOR) LCALC
WHERE CCALC.CNO=@PCNO   
go



 insert into PatchVersioning	
select '534 Update Script - Patch 2023 (5)',GETDATE()
go





Declare @PrevScript varchar(100)
Declare @CurrScript varchar(100)

Select @PrevScript=''
Select @CurrSCript='534 Update Script - Patch 2023 (5)'


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


