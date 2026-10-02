
insert into PatchVersioning
select '57.21 Update Patch - Patch 2021 (6)',GETDATE()
go

Declare @PrevScript varchar(100)
Declare @CurrScript varchar(100)

Select @PrevScript='57.20 Update Patch - Patch 2021 (5)'
Select @CurrSCript='57.21 Update Patch - Patch 2021 (6)'


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
			DROP PROCEDURE QCHECKDECLAREDVALUE 
       END TRY  
       BEGIN CATCH  
       END CATCH;


       Update SysTab Set ExecScript=@CurrScript, ExecScriptStatus='DONE'         
End

GO
CREATE PROCEDURE QCHECKDECLAREDVALUE (@PCNO AS INTEGER)   
AS
Select *
from
(
Select 
	coalesce(ICoverNOC.NOC,'') as NOC,
	SUM(CLLOSS.Estimate/CLLOSS.Rate) as Estimate, 
	SUM(CLLOSS.Amount/CLLOSS.Rate) as Amount, 
	MAX(Case When ICOVER.AMOUNT<>0 and ICOVER.AMOUNT_AOE<>0 THEN CLLOSS.DECLARED*ICOVER.AMOUNT_AOE/ICOVER.AMOUNT ELSE CLLOSS.DECLARED END) as DECLARED,
	MAX(ICOVER.AMOUNT) as LOL
	from CLLOSS 
	INNER JOIN CLAIM ON (CLAIM.CNO=CLLOSS.CNO)
	INNER JOIN ACCEPTANCE ON (ACCEPTANCE.ANO=CLAIM.ANO)
	INNER JOIN NOCTAB ON (NOCTAB.NOC=CLLOSS.NOC) 
	INNER JOIN ICOVER ON (ICOVER.INO=CLLOSS.INO)
	LEFT JOIN ICOVERNOC ON ((ICoverNOC.PCT<>0 or ICoverNOC.Amount<>0) And ICOVERNOC.INO=CLLOSS.INO and ICOVERNOC.NOC=CLLOSS.NOC
	AND ((Select Top 1 RCover.RetroActiveF from RCover Where RCover.ANO=Acceptance.ANO Order by RCover.RetroActiveF Desc)=1 or (ICOVERNOC.SDATE<=CLAIM.LossDate AND ACCEPTANCE.ExclusiveF=1) or ((ICOVERNOC.SDATE<CLAIM.LossDate or (ICOVERNOC.SDATE=CLAIM.LossDate AND ACCEPTANCE.STIME<=CLAIM.LossTime)) AND ACCEPTANCE.ExclusiveF=0))                     
	AND ((dbo.fn_Get_ExtPeriodDate(ACCEPTANCE.ExtRPeriod, 0, dbo.fn_Get_ExtPeriodDate(ACCEPTANCE.ExtPeriod, ACCEPTANCE.ExtPeriodInDaysF, ICOVERNOC.EDATE))>CLAIM.LossDate AND ACCEPTANCE.ExclusiveF=1) or ((dbo.fn_Get_ExtPeriodDate(ACCEPTANCE.ExtRPeriod, 0, dbo.fn_Get_ExtPeriodDate(ACCEPTANCE.ExtPeriod, ACCEPTANCE.ExtPeriodInDaysF, ICOVERNOC.EDATE))>CLAIM.LossDate or (dbo.fn_Get_ExtPeriodDate(ACCEPTANCE.ExtRPeriod, 0, dbo.fn_Get_ExtPeriodDate(ACCEPTANCE.ExtPeriod, ACCEPTANCE.ExtPeriodInDaysF, ICOVERNOC.EDATE))=
CLAIM.LossDate AND ACCEPTANCE.ETIME>CLAIM.LossTime)) AND ACCEPTANCE.ExclusiveF=0))                              
) 
Where CLLOSS.Declared>0 and CLLoss.CNO=@PCNO and (NOCTAB.SubLimitF=0 or coalesce(ICoverNOC.NOC,'')<>'') 
Group by CLLOSS.CNO, CLLOSS.INO, coalesce(ICoverNOC.NOC,'') 
) C
Where Estimate>=Declared or Amount>=declared or Estimate>LOL or Amount>LOL

