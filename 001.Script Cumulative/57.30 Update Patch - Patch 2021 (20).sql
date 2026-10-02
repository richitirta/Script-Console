
insert into PatchVersioning
select '57.30 Update Patch - Patch 2021 (20)',GETDATE()
go

Declare @PrevScript varchar(100)
Declare @CurrScript varchar(100)

Select @PrevScript=''
Select @CurrSCript='57.30 Update Patch - Patch 2021 (20)'


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
			DROP Procedure PCALC02
       END TRY  
       BEGIN CATCH  
       END CATCH;


       Update SysTab Set ExecScript=@CurrScript, ExecScriptStatus='DONE'         
End


GO
CREATE Procedure PCALC02(@P_ANO integer)
AS
SELECT I.CURRENCY, SUM(SI) as TSI, SUM(AMOUNT) AS AMOUNT
FROM
(
SELECT DISTINCT I1.INO, I1.CURRENCY, 
CASE WHEN I1.CATEGORY='M' THEN I1.SI ELSE 0 END as SI, 
CASE WHEN I1.CATEGORY='M' THEN I1.AMOUNT ELSE 0 END as AMOUNT
FROM ICOVER I1
INNER JOIN ICALC I2 ON (I2.INO=I1.INO)
WHERE I1.ANO=@P_ANO
) I
GROUP BY I.CURRENCY
