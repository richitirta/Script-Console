DROP PROCEDURE QCHECKDECLAREDVALUE 
GO
CREATE PROCEDURE QCHECKDECLAREDVALUE (@P_CNO AS INTEGER)   
AS

Declare @CLLOSS table(CNO int, INO int, NOC varchar(10), Estimate Float, Amount Float, Declared Float, LOL_AOE Float, LOL Float)

Insert into @CLLOSS
Select	
CLLOSS.CNO, 
CLLOSS.INO,
CLLOSS.NOC,
CLLOSS.Estimate/CLLOSS.Rate as Estimate, 
CLLOSS.Amount/CLLOSS.Rate as Amount, 
CLLOSS.Declared as Declared, 
Case When ICOVER.EUnit='a.o.y' Then ICOVER.AMOUNT Else ICOVER.AMOUNT_AOE End as LOL_AOE,
ICOVER.AMOUNT as LOL
from CLLOSS 
INNER JOIN ICOVER ON (ICOVER.INO=CLLOSS.INO)
Where CLLOSS.CNO=@P_CNO

Select *
from
(
	-- By Limit Of Liability
	Select 
	CLLOSS.NOC, 
	CLLOSS.Estimate, 
	CLLOSS.Amount, 
	CLLOSS.Declared,
	Case When CLLOSS.LOL<CLLOSS.Declared Then CLLOSS.Declared Else CLLOSS.LOL END as LOL
	from @CLLOSS CLLOSS

	Union All

	-- By Max Liability
	Select 
	coalesce(ICoverNOC.NOC,'') as NOC,
	SUM(CLLOSS.Estimate) as Estimate, 
	SUM(CLLOSS.Amount) as Amount, 
	MAX(Case When CLLOSS.LOL<>0 and CLLOSS.LOL_AOE<>0 THEN CLLOSS.DECLARED*CLLOSS.LOL_AOE/CLLOSS.LOL ELSE CLLOSS.DECLARED END) as DECLARED,
	MAX(Case When CLLOSS.LOL<>0 and CLLOSS.LOL_AOE<>0 THEN CLLOSS.DECLARED*CLLOSS.LOL_AOE/CLLOSS.LOL ELSE CLLOSS.DECLARED END) as LOL
	from @CLLOSS CLLOSS 
	INNER JOIN CLAIM ON (CLAIM.CNO=CLLOSS.CNO)
	INNER JOIN ACCEPTANCE ON (ACCEPTANCE.ANO=CLAIM.ANO)
	INNER JOIN NOCTAB ON (NOCTAB.NOC=CLLOSS.NOC) 
	LEFT JOIN ICOVERNOC ON (
	(ICoverNOC.PCT<>0 or ICoverNOC.Amount<>0) And ICOVERNOC.INO=CLLOSS.INO and ICOVERNOC.NOC=CLLOSS.NOC
	AND ((Select Top 1 RCover.RetroActiveF from RCover Where RCover.ANO=Acceptance.ANO Order by RCover.RetroActiveF Desc)=1 or (ICOVERNOC.SDATE<=CLAIM.LossDate AND ACCEPTANCE.ExclusiveF=1) or ((ICOVERNOC.SDATE<CLAIM.LossDate or (ICOVERNOC.SDATE=CLAIM.LossDate AND ACCEPTANCE.STIME<=CLAIM.LossTime)) AND ACCEPTANCE.ExclusiveF=0))                     
	AND ((dbo.fn_Get_ExtPeriodDate(ACCEPTANCE.ExtRPeriod, 0, dbo.fn_Get_ExtPeriodDate(ACCEPTANCE.ExtPeriod, ACCEPTANCE.ExtPeriodInDaysF, ICOVERNOC.EDATE))>CLAIM.LossDate AND ACCEPTANCE.ExclusiveF=1) or ((dbo.fn_Get_ExtPeriodDate(ACCEPTANCE.ExtRPeriod, 0, dbo.fn_Get_ExtPeriodDate(ACCEPTANCE.ExtPeriod, ACCEPTANCE.ExtPeriodInDaysF, ICOVERNOC.EDATE))>CLAIM.LossDate or (dbo.fn_Get_ExtPeriodDate(ACCEPTANCE.ExtRPeriod, 0, dbo.fn_Get_ExtPeriodDate(ACCEPTANCE.ExtPeriod, ACCEPTANCE.ExtPeriodInDaysF, ICOVERNOC.EDATE))=CLAIM.LossDate AND ACCEPTANCE.ETIME>CLAIM.LossTime)) AND ACCEPTANCE.ExclusiveF=0))
	) 
	Where (NOCTAB.SubLimitF=0 or coalesce(ICoverNOC.NOC,'')<>'') 
	Group by CLLOSS.CNO, CLLOSS.INO, coalesce(ICoverNOC.NOC,'') 
) C
Where Estimate>=Declared or Amount>=Declared or Estimate>LOL or Amount>LOL




go

 insert into PatchVersioning
select '514 Update Script - Patch 2022 (95)',GETDATE()
go



Declare @PrevScript varchar(100)
Declare @CurrScript varchar(100)

Select @PrevScript=''
Select @CurrSCript='514 Update Script - Patch 2022 (95)'


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

