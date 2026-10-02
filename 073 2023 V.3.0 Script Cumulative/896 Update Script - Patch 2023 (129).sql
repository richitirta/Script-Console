DROP PROCEDURE BALANCE_CLAASS
GO
CREATE PROCEDURE BALANCE_CLAASS(@P_CNO as Integer)
AS
Select CLAASS.*, F.CPDAYS
FROM CLAASS
INNER JOIN CLAIM on (CLAIM.CNO=CLAASS.CNO)
Outer Apply (Select Top 1 CPDays from FPart F Where F.ANO=CLAIM.ANO and F.SlipNo=CLAASS.RefNo and F.ID=CLAASS.ID) F
WHERE CLAASS.CNO=@P_CNO AND CLAASS.CAMOUNT<>0
and not (
	CLAASS.CODE IN ('F','D') 
	or 
	exists
	(
	Select CLFD.FDID 
	from CLFD
	Inner Join FDTAB on (FDTAB.FDID=CLFD.FDID)
	Where ClaAss.RefNo=Claim.RefNo and ClaAss.Type='OP' and Left(FDTAB.FDTYPE,1)='O' and CLFD.CNO=ClaAss.CNO and CLFD.Payment=ClaAss.ID and CLFD.Currency=ClaAss.CURRENCY_OC
	)
)

go


 insert into PatchVersioning
select '896 Update Script - Patch 2023 (129)',GETDATE()
go


Declare @PrevScript varchar(100)
Declare @CurrScript varchar(100)

Select @PrevScript=''
Select @CurrSCript='896 Update Script - Patch 2023 (129)'


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


