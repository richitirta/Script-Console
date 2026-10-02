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
	Inner Join FDTAB on (FDTAB.FDID=CLFD.FDID and Left(FDTAB.FDTYPE,1)='O')
	Where ClaAss.CNO=CLFD.CNO 
	and ClaAss.RefNo=Claim.RefNo 
	and ClaAss.Type='OP' and ClaAss.Code='F'
	and ClaAss.ID=Case When CLFD.Payment='<Payor>' Then Claim.Payment Else CLFD.Payment end
	and CLFD.Currency=ClaAss.CURRENCY_OC
	)
)

GO


 insert into PatchVersioning
select '1238 Update Script - Patch 2024 (87)',GETDATE()
go	
  
Declare @PrevScript varchar(100)
Declare @CurrScript varchar(100)

Select @PrevScript=''
Select @CurrSCript='1238 Update Script - Patch 2024 (87)'


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

