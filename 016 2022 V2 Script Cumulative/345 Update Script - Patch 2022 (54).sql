DROP PROCEDURE QCLACC04 
GO
CREATE PROCEDURE QCLACC04 (@PCNO AS INTEGER) 
AS
SELECT CLLOSS.REMARK, CLLOSS.TOI, CLLOSS.INO, CLLOSS.NOC, CLLOSS.Payment, CLLOSS.CURRENCY, CLLOSS.RefNo
FROM CLLOSS
WHERE CLLOSS.CNO=@PCNO
go


 insert into PatchVersioning
select '345 Update Script - Patch 2022 (54)',GETDATE()
go


Declare @PrevScript varchar(100)
Declare @CurrScript varchar(100)

Select @PrevScript=''
Select @CurrSCript='345 Update Script - Patch 2022 (54)'


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

