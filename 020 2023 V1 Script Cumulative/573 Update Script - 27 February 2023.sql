DROP FUNCTION CCALC02a
GO
CREATE FUNCTION CCALC02a(@P_CNO as integer) 
RETURNS Table 
AS RETURN ( 
 
Select LCalc.Currency, LCalc.Loss,  LCalc.Indemnity as Claim, LCalc.EDEDUCTIBLE, LCalc.Deductible, LCalc.ESalvage, LCalc.Salvage, 
0 as COST, 0 as RCOST, 0 as ECost, 0 as ERCost, 0 as TCOST, 0 as ETCOST, 
0 as SUBROGATION, 0 as RSUBROGATION, 0 as ESUBROGATION, 0 as ERSUBROGATION, 0 as ETSUBROGATION, 0 as TSUBROGATION 
From LCalc 
Where LCalc.CNO=@P_CNO 
 
Union All 
 
SELECT CLDED.CURRENCY, 0 AS LOSS, 0 AS CLAIM, 0 AS EDEDUCTIBLE, 0 AS DEDUCTIBLE, 0 as ESALVAGE, 0 AS SALVAGE,
0 as COST, 0 as RCOST, 0 as ECost, 0 as ERCost, 0 AS TCOST, 0 as ETCOST, 
0 as SUBROGATION, 0 as RSUBROGATION, 0 as ESUBROGATION, 0 as ERSUBROGATION, 0 as ETSUBROGATION, 0 as TSUBROGATION 
From CLFACDED CLDED 
WHERE CLDED.CNO=@P_CNO And (CLDED.AMOUNT<>0) 
 
Union All 
 
SELECT CLCOST.CURRENCY, 0 AS LOSS, 0 AS CLAIM, 0 AS EDEDUCTIBLE, 0 AS DEDUCTIBLE, 0 as ESALVAGE, 0 AS SALVAGE, 
case When ContributionF=1 then CLCOST.Amount else 0 end as COST, 
Case When ContributionF=0 and CessionF=1 then CLCOST.Amount else 0 end as RCOST, 
case When ContributionF=1 then CLCOST.EstAmount else 0 end as ECOST, 
Case When ContributionF=0 and CessionF=1 then CLCost.EstAmount else 0 end as ERCOST, 
CLCOST.AMOUNT as TCOST, 
CLCOST.ESTAMOUNT AS ETCOST, 
0 as SUBROGATION, 0 as RSUBROGATION, 0 as ESUBROGATION, 0 as ERSUBROGATION, 0 as ETSUBROGATION, 0 as TSUBROGATION 
From CLCOST 
WHERE CLCOST.CNO=@P_CNO AND CLCOST.STATUS='P' 
 
Union All 
 
SELECT CLSUB.CURRENCY, 0 AS LOSS, 0 AS CLAIM, 0 AS EDEDUCTIBLE, 0 AS DEDUCTIBLE, 0 as ESALVAGE, 0 AS SALVAGE,
0 AS COST, 0 as RCOST, 0 as ECost, 0 as ERCost, 0 as TCOST, 0 as ETCOST, 
case When ContributionF=1 then CLSub.Amount*(100-Coalesce(CoShare.CoShare,0))/100 else 0 end as SUBROGATION, 
Case When ContributionF=0 and CessionF=1 then CLSub.Amount*(100-Coalesce(CoShare.CoShare,0))/100 else 0 end as RSUBROGATION, 
case When ContributionF=1 then CLSub.EAmount*(100-Coalesce(CoShare.CoShare,0))/100 else 0 end as ESUBROGATION, 
Case When ContributionF=0 and CessionF=1 then CLSub.EAmount*(100-Coalesce(CoShare.CoShare,0))/100 else 0 end as ERSUBROGATION, 
CLSUB.EAMOUNT*(100-Coalesce(CoShare.CoShare,0))/100 as ETSUBROGATION, 
CLSUB.AMOUNT*(100-Coalesce(CoShare.CoShare,0))/100 as TSUBROGATION
From CLSUB 
OUTER APPLY (SELECT TOP 1 TOR, CODE AS RCODE FROM LCALC WHERE CNO=CLSUB.CNO Order By Case When LCALC.Currency=CLSUB.Currency Then 0 Else 1 End, Code, TOR) LCALC
Inner Join Claim on (Claim.CNO=CLSUB.CNO)
Inner Join Acceptance on (Acceptance.ANO=Claim.ANO)
Outer Apply (
	Select Top 1 RCover.CoShare 
	from RCover 
	Where RCover.ANO=Claim.ANO and RCover.Code=LCALC.RCODE
	AND (RCover.RetroActiveF=1 or (RCOVER.SDATE<=CLAIM.LOSSDATE AND ACCEPTANCE.ExclusiveF=1) or ((RCOVER.SDATE<CLAIM.LOSSDATE or (RCOVER.SDATE=CLAIM.LOSSDATE AND ACCEPTANCE.STIME<=Claim.LossTime)) AND ACCEPTANCE.ExclusiveF=0))           
	AND ((dbo.fn_Get_ExtPeriodDate(ACCEPTANCE.ExtRPeriod, 0, dbo.fn_Get_ExtPeriodDate(ACCEPTANCE.ExtPeriod, ACCEPTANCE.ExtPeriodInDaysF, RCOVER.EDATE))>CLAIM.LOSSDATE AND ACCEPTANCE.ExclusiveF=1) or ((dbo.fn_Get_ExtPeriodDate(ACCEPTANCE.ExtRPeriod, 0, dbo.fn_Get_ExtPeriodDate(ACCEPTANCE.ExtPeriod, ACCEPTANCE.ExtPeriodInDaysF, RCOVER.EDATE))>CLAIM.LOSSDATE or (dbo.fn_Get_ExtPeriodDate(ACCEPTANCE.ExtRPeriod, 0, dbo.fn_Get_ExtPeriodDate(ACCEPTANCE.ExtPeriod, ACCEPTANCE.ExtPeriodInDaysF, RCOVER.EDATE))=CLAIM.LOSSDATE AND ACCEPTANCE.ETIME>Claim.LossTime)) AND ACCEPTANCE.ExclusiveF=0))          	
	And Claim.ISType in ('I','L')
	) CoShare
WHERE CLSUB.CNO=@P_CNO AND CLSUB.STATUS='P'

) 

GO 


DROP PROCEDURE CLSubrogationTo 
GO
CREATE PROCEDURE CLSubrogationTo (@P_Cno as integer, @P_Currency as varchar(255))
AS
SELECT CLSUB.CNO, CLSUB.ID, CLSUB.Currency, CLSUB.RefNo, 'R' as CodeExt, 
cast(Max(cast(CLSub.ContributionF as Int)) as Bit) as ContributionF, 
sum(clsub.amount) AS amount,
Max(Claim.Payment) as Payment,
Max(Coalesce(CoShare.CoShare,0)) as CoShare
From CLSUB
OUTER APPLY (SELECT TOP 1 TOR, CODE AS RCODE FROM LCALC WHERE CNO=CLSUB.CNO Order By Case When LCALC.Currency=CLSUB.Currency Then 0 Else 1 End, Code, TOR) LCALC
Inner Join Claim on (Claim.CNO=CLSUB.CNO)
Inner Join Acceptance on (Acceptance.ANO=Claim.ANO)
Outer Apply (
	Select Top 1 RCover.CoShare 
	from RCover 
	Where RCover.ANO=Claim.ANO and RCover.Code=LCALC.RCODE
	AND (RCover.RetroActiveF=1 or (RCOVER.SDATE<=CLAIM.LOSSDATE AND ACCEPTANCE.ExclusiveF=1) or ((RCOVER.SDATE<CLAIM.LOSSDATE or (RCOVER.SDATE=CLAIM.LOSSDATE AND ACCEPTANCE.STIME<=Claim.LossTime)) AND ACCEPTANCE.ExclusiveF=0))           
	AND ((dbo.fn_Get_ExtPeriodDate(ACCEPTANCE.ExtRPeriod, 0, dbo.fn_Get_ExtPeriodDate(ACCEPTANCE.ExtPeriod, ACCEPTANCE.ExtPeriodInDaysF, RCOVER.EDATE))>CLAIM.LOSSDATE AND ACCEPTANCE.ExclusiveF=1) or ((dbo.fn_Get_ExtPeriodDate(ACCEPTANCE.ExtRPeriod, 0, dbo.fn_Get_ExtPeriodDate(ACCEPTANCE.ExtPeriod, ACCEPTANCE.ExtPeriodInDaysF, RCOVER.EDATE))>CLAIM.LOSSDATE or (dbo.fn_Get_ExtPeriodDate(ACCEPTANCE.ExtRPeriod, 0, dbo.fn_Get_ExtPeriodDate(ACCEPTANCE.ExtPeriod, ACCEPTANCE.ExtPeriodInDaysF, RCOVER.EDATE))=CLAIM.LOSSDATE AND ACCEPTANCE.ETIME>Claim.LossTime)) AND ACCEPTANCE.ExclusiveF=0))          	
	And Claim.ISType in ('I','L')
	) CoShare
WHERE CLSUB.CNO=@P_Cno and CLSUB.currency=@P_Currency and CLSUB.Status='P'
GROUP BY CLSUB.CNO, CLSUB.ID, CLSUB.Currency, CLSUB.RefNo



go



 insert into PatchVersioning	
select '573 Update Script - 27 February 2023',GETDATE()
go





Declare @PrevScript varchar(100)
Declare @CurrScript varchar(100)

Select @PrevScript=''
Select @CurrSCript='573 Update Script - 27 February 2023'


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



