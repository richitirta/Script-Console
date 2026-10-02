DROP FUNCTION CCALC01a
GO
CREATE FUNCTION CCALC01a(@P_CNO as integer)            
RETURNS Table            
AS RETURN (            
SELECT CLLoss.Currency as Currency, Max(RCOVER.CODE) as Code, max(ICALC.TOR) as TOR,            
 Max(    
  CASE            
   WHEN CLLOSS.VAR<=CLLOSS.DECLARED THEN (CLLOSS.ESTIMATE)
   ELSE (CLLOSS.DECLARED/CLLOSS.VAR) * (CLLOSS.ESTIMATE) 
  END    
 ) as LOSS,            
 Max(    
  CASE            
   WHEN CLLOSS.STATUS<>'P' THEN 0
   WHEN CLLOSS.VAR<=CLLOSS.DECLARED THEN (CLLOSS.AMOUNT)             
   ELSE (CLLOSS.DECLARED/CLLOSS.VAR) * (CLLOSS.AMOUNT)             
  END    
 ) as INDEMNITY,            
 Max(    
  CASE            
   WHEN CLLOSS.VAR<=CLLOSS.DECLARED THEN CLLOSS.ESTIMATE            
   ELSE (CLLOSS.DECLARED/CLLOSS.VAR) * CLLOSS.ESTIMATE            
  END*(RCOVER.COSHARE)/100    
 ) 
 +
 Max(    
  CASE            
   WHEN CLLOSS.VAR<=CLLOSS.DECLARED THEN CLLOSS.EDEPRECIATION            
   ELSE (CLLOSS.DECLARED/CLLOSS.VAR) * CLLOSS.EDEPRECIATION
  END
 ) 
 as EDEDUCTIBLE,            
 Max(    
  CASE            
   WHEN CLLOSS.STATUS<>'P' THEN 0
   WHEN CLLOSS.VAR<=CLLOSS.DECLARED THEN CLLOSS.AMOUNT            
   ELSE (CLLOSS.DECLARED/CLLOSS.VAR) * CLLOSS.AMOUNT            
  END*(RCOVER.COSHARE)/100    
 ) 
 +
 Max(    
  CASE            
   WHEN CLLOSS.STATUS<>'P' THEN 0
   WHEN CLLOSS.VAR<=CLLOSS.DECLARED THEN CLLOSS.DEPRECIATION            
   ELSE (CLLOSS.DECLARED/CLLOSS.VAR) * CLLOSS.DEPRECIATION
  END
 ) 
 as DEDUCTIBLE,            
 0 as ESALVAGE, 0 AS SALVAGE
From CLAIM
INNER JOIN CLLOSS ON (CLLOSS.CNO=CLAIM.CNO)
INNER JOIN ACCEPTANCE ON (ACCEPTANCE.ANO=CLAIM.ANO)
INNER JOIN COVER ON (COVER.CNO=ACCEPTANCE.CNO)
INNER JOIN RCOVER ON (RCOVER.ANO=ACCEPTANCE.ANO)
INNER JOIN ICALC ON (ICALC.ANO=RCOVER.ANO AND ICALC.CODE=RCOVER.CODE AND ICALC.SDATE=RCOVER.SDATE AND ICALC.INO=CLLOSS.INO)
INNER JOIN COL ON (COL.COL=CLAIM.COL AND COL.TOR=ICALC.TOR)
WHERE CLAIM.CNO=@P_CNO 
AND (RCover.RetroActiveF=1 or (RCOVER.SDATE<=CLAIM.LOSSDATE AND ACCEPTANCE.ExclusiveF=1) or ((RCOVER.SDATE<CLAIM.LOSSDATE or (RCOVER.SDATE=CLAIM.LOSSDATE AND ACCEPTANCE.STIME<=Claim.LossTime)) AND ACCEPTANCE.ExclusiveF=0))           
AND ((dbo.fn_Get_ExtPeriodDate(ACCEPTANCE.ExtRPeriod, 0, dbo.fn_Get_ExtPeriodDate(ACCEPTANCE.ExtPeriod, ACCEPTANCE.ExtPeriodInDaysF, RCOVER.EDATE))>CLAIM.LOSSDATE AND ACCEPTANCE.ExclusiveF=1) or ((dbo.fn_Get_ExtPeriodDate(ACCEPTANCE.ExtRPeriod, 0, dbo.fn_Get_ExtPeriodDate(ACCEPTANCE.ExtPeriod, ACCEPTANCE.ExtPeriodInDaysF, RCOVER.EDATE))>CLAIM.LOSSDATE or (dbo.fn_Get_ExtPeriodDate(ACCEPTANCE.ExtRPeriod, 0, dbo.fn_Get_ExtPeriodDate(ACCEPTANCE.ExtPeriod, ACCEPTANCE.ExtPeriodInDaysF, RCOVER.EDATE))=CLAIM.LOSSDATE AND ACCEPTANCE.ETIME>Claim.LossTime)) AND ACCEPTANCE.ExclusiveF=0))          
Group By CLLOSS.CNO, CLLOSS.INO, CLLOSS.PAYMENT, CLLOSS.NOC, CLLOSS.Currency, CLLOSS.RefNo  
    
Union All            
                      
SELECT CLDed.Currency as Currency, 
Max(RCOVER.CODE) as Code, 
Max(RCALC.TOR) as TOR, 
0 AS LOSS, 
0 AS INDEMNITY, 
Max(CLDED.ESTAMOUNT) AS EDEDUCTIBLE, 
Max(CLDED.AMOUNT) AS DEDUCTIBLE, 
0 as ESALVAGE, 
0 AS SALVAGE            
From CLAIM
INNER JOIN CLDED ON (CLDED.CNO=CLAIM.CNO)
INNER JOIN ACCEPTANCE ON (ACCEPTANCE.ANO=CLAIM.ANO)
INNER JOIN COVER ON (COVER.CNO=ACCEPTANCE.CNO)
INNER JOIN RCOVER ON (RCOVER.ANO=ACCEPTANCE.ANO)
INNER JOIN RCALC ON (RCALC.ANO=RCOVER.ANO AND RCALC.CODE=RCOVER.CODE AND RCALC.SDATE=RCOVER.SDATE)
INNER JOIN COL ON (COL.COL=CLAIM.COL AND COL.TOR=RCALC.TOR )
INNER JOIN DEDTAB ON (DEDTAB.DCODE=CLDED.DCODE AND DEDTAB.TOR=COL.TOR)
WHERE CLAIM.CNO=@P_CNO AND (CLDED.ESTAMOUNT<>0 or CLDED.AMOUNT<>0)            
AND (RCover.RetroActiveF=1 or (RCOVER.SDATE<=CLAIM.LOSSDATE AND ACCEPTANCE.ExclusiveF=1) or ((RCOVER.SDATE<CLAIM.LOSSDATE or (RCOVER.SDATE=CLAIM.LOSSDATE AND ACCEPTANCE.STIME<=Claim.LossTime)) AND ACCEPTANCE.ExclusiveF=0))           
AND ((dbo.fn_Get_ExtPeriodDate(ACCEPTANCE.ExtRPeriod, 0, dbo.fn_Get_ExtPeriodDate(ACCEPTANCE.ExtPeriod, ACCEPTANCE.ExtPeriodInDaysF, RCOVER.EDATE))>CLAIM.LOSSDATE AND ACCEPTANCE.ExclusiveF=1) or ((dbo.fn_Get_ExtPeriodDate(ACCEPTANCE.ExtRPeriod, 0, dbo.fn_Get_ExtPeriodDate(ACCEPTANCE.ExtPeriod, ACCEPTANCE.ExtPeriodInDaysF, RCOVER.EDATE))>CLAIM.LOSSDATE or (dbo.fn_Get_ExtPeriodDate(ACCEPTANCE.ExtRPeriod, 0, dbo.fn_Get_ExtPeriodDate(ACCEPTANCE.ExtPeriod, ACCEPTANCE.ExtPeriodInDaysF, RCOVER.EDATE))=CLAIM.LOSSDATE AND ACCEPTANCE.ETIME>Claim.LossTime)) AND ACCEPTANCE.ExclusiveF=0))     
Group by CLDED.CNO, CLDED.DCode, CLDED.ID, CLDED.Currency    
    
                      
Union All            
                      
SELECT CLSAL.CURRENCY, 
Max(RCOVER.CODE) as Code, 
Max(ICALC.TOR) as TOR, 
0 AS LOSS, 
0 AS INDEMNITY, 
0 AS EDEDUCTIBLE, 
0 AS DEDUCTIBLE, 
Max(CLSAL.AMOUNT-CLSAL.VAT) AS ESALVAGE, 
Max(CLSAL.EAMOUNT-Case When CLSAL.Amount<>0 Then CLSAL.EAmount/CLSAL.Amount*CLSAL.VAT Else 0 end) AS SALVAGE
From CLAIM
INNER JOIN CLSAL ON (CLSAL.CNO=CLAIM.CNO)
INNER JOIN ACCEPTANCE ON (ACCEPTANCE.ANO=CLAIM.ANO)
INNER JOIN COVER ON (COVER.CNO=ACCEPTANCE.CNO)
INNER JOIN RCOVER ON (RCOVER.ANO=ACCEPTANCE.ANO)
INNER JOIN ICALC ON (ICALC.ANO=RCOVER.ANO AND ICALC.CODE=RCOVER.CODE AND ICALC.SDATE=RCOVER.SDATE AND ICALC.INO=CLSAL.INO)
INNER JOIN COL ON (COL.COL=CLAIM.COL AND COL.TOR=ICALC.TOR)
WHERE CLAIM.CNO=@P_CNO AND CLSAL.Status='P'        
AND (RCover.RetroActiveF=1 or (RCOVER.SDATE<=CLAIM.LOSSDATE AND ACCEPTANCE.ExclusiveF=1) or ((RCOVER.SDATE<CLAIM.LOSSDATE or (RCOVER.SDATE=CLAIM.LOSSDATE AND ACCEPTANCE.STIME<=Claim.LossTime)) AND ACCEPTANCE.ExclusiveF=0))           
AND ((dbo.fn_Get_ExtPeriodDate(ACCEPTANCE.ExtRPeriod, 0, dbo.fn_Get_ExtPeriodDate(ACCEPTANCE.ExtPeriod, ACCEPTANCE.ExtPeriodInDaysF, RCOVER.EDATE))>CLAIM.LOSSDATE AND ACCEPTANCE.ExclusiveF=1) or ((dbo.fn_Get_ExtPeriodDate(ACCEPTANCE.ExtRPeriod, 0, dbo.fn_Get_ExtPeriodDate(ACCEPTANCE.ExtPeriod, ACCEPTANCE.ExtPeriodInDaysF, RCOVER.EDATE))>CLAIM.LOSSDATE or (dbo.fn_Get_ExtPeriodDate(ACCEPTANCE.ExtRPeriod, 0, dbo.fn_Get_ExtPeriodDate(ACCEPTANCE.ExtPeriod, ACCEPTANCE.ExtPeriodInDaysF, RCOVER.EDATE))=CLAIM.LOSSDATE AND ACCEPTANCE.ETIME>Claim.LossTime)) AND ACCEPTANCE.ExclusiveF=0))          
Group By CLSAL.CNO, CLSAL.INO, CLSAL.ID, CLSAL.Currency    
)            

GO

DROP FUNCTION CCALC02a
GO
CREATE FUNCTION CCALC02a(@P_CNO as integer) 
RETURNS Table 
AS RETURN ( 
 
Select LCalc.Currency, LCalc.Loss,  LCalc.Indemnity as Claim, LCalc.EDEDUCTIBLE, LCalc.Deductible, 
0 as COST, 0 as RCOST, 0 as ECost, 0 as ERCost, 0 as TCOST, 0 as ETCOST, 
0 as SUBROGATION, 0 as RSUBROGATION, 0 as ESUBROGATION, 0 as ERSUBROGATION, 0 as ETSUBROGATION, 0 as TSUBROGATION,
0 as SALVAGE, 0 as RSALVAGE, 0 as ESALVAGE, 0 as ERSALVAGE, 0 as ETSALVAGE, 0 as TSALVAGE
From LCalc 
Where LCalc.CNO=@P_CNO 
 
Union All 
 
SELECT CLDED.CURRENCY, 0 AS LOSS, 0 AS CLAIM, 0 AS EDEDUCTIBLE, 0 AS DEDUCTIBLE, 
0 as COST, 0 as RCOST, 0 as ECost, 0 as ERCost, 0 AS TCOST, 0 as ETCOST, 
0 as SUBROGATION, 0 as RSUBROGATION, 0 as ESUBROGATION, 0 as ERSUBROGATION, 0 as ETSUBROGATION, 0 as TSUBROGATION,
0 as SALVAGE, 0 as RSALVAGE, 0 as ESALVAGE, 0 as ERSALVAGE, 0 as ETSALVAGE, 0 as TSALVAGE
From CLFACDED CLDED 
WHERE CLDED.CNO=@P_CNO And (CLDED.AMOUNT<>0) 
 
Union All 
 
SELECT CLCOST.CURRENCY, 0 AS LOSS, 0 AS CLAIM, 0 AS EDEDUCTIBLE, 0 AS DEDUCTIBLE,
case When ContributionF=1 then CLCOST.Amount*(100-Coalesce(CoShare.CoShare,0))/100 else 0 end as COST, 
Case When ContributionF=0 and CessionF=1 then CLCOST.Amount*(100-Coalesce(CoShare.CoShare,0))/100 else 0 end as RCOST, 
case When ContributionF=1 then CLCOST.EstAmount*(100-Coalesce(CoShare.CoShare,0))/100 else 0 end as ECOST, 
Case When ContributionF=0 and CessionF=1 then CLCost.EstAmount*(100-Coalesce(CoShare.CoShare,0))/100 else 0 end as ERCOST, 
CLCOST.AMOUNT*(100-Coalesce(CoShare.CoShare,0))/100 as TCOST, 
CLCOST.ESTAMOUNT*(100-Coalesce(CoShare.CoShare,0))/100 AS ETCOST, 
0 as SUBROGATION, 0 as RSUBROGATION, 0 as ESUBROGATION, 0 as ERSUBROGATION, 0 as ETSUBROGATION, 0 as TSUBROGATION,
0 as SALVAGE, 0 as RSALVAGE, 0 as ESALVAGE, 0 as ERSALVAGE, 0 as ETSALVAGE, 0 as TSALVAGE
From CLCOST 
OUTER APPLY (SELECT TOP 1 TOR, CODE AS RCODE FROM LCALC WHERE CNO=CLCOST.CNO Order By Case When LCALC.Currency=CLCOST.Currency Then 0 Else 1 End, Code, TOR) LCALC
Inner Join Claim on (Claim.CNO=CLCOST.CNO)
Inner Join Acceptance on (Acceptance.ANO=Claim.ANO)
Outer Apply (
	Select Top 1 RCover.CoShare 
	from RCover 
	Where RCover.ANO=Claim.ANO and RCover.Code=LCALC.RCODE
	AND (RCover.RetroActiveF=1 or (RCOVER.SDATE<=CLAIM.LOSSDATE AND ACCEPTANCE.ExclusiveF=1) or ((RCOVER.SDATE<CLAIM.LOSSDATE or (RCOVER.SDATE=CLAIM.LOSSDATE AND ACCEPTANCE.STIME<=Claim.LossTime)) AND ACCEPTANCE.ExclusiveF=0))           
	AND ((dbo.fn_Get_ExtPeriodDate(ACCEPTANCE.ExtRPeriod, 0, dbo.fn_Get_ExtPeriodDate(ACCEPTANCE.ExtPeriod, ACCEPTANCE.ExtPeriodInDaysF, RCOVER.EDATE))>CLAIM.LOSSDATE AND ACCEPTANCE.ExclusiveF=1) or ((dbo.fn_Get_ExtPeriodDate(ACCEPTANCE.ExtRPeriod, 0, dbo.fn_Get_ExtPeriodDate(ACCEPTANCE.ExtPeriod, ACCEPTANCE.ExtPeriodInDaysF, RCOVER.EDATE))>CLAIM.LOSSDATE or (dbo.fn_Get_ExtPeriodDate(ACCEPTANCE.ExtRPeriod, 0, dbo.fn_Get_ExtPeriodDate(ACCEPTANCE.ExtPeriod, ACCEPTANCE.ExtPeriodInDaysF, RCOVER.EDATE))=CLAIM.LOSSDATE AND ACCEPTANCE.ETIME>Claim.LossTime)) AND ACCEPTANCE.ExclusiveF=0))          	
	And (Claim.ISType in ('I','L') or (Claim.ISType in ('C') and CLCOST.ContributionF=0))
	And CLCOST.ApplyCoShareF=1
	) CoShare
WHERE CLCOST.CNO=@P_CNO AND CLCOST.STATUS='P' 
 
Union All 
 
SELECT CLSUB.CURRENCY, 
0 AS LOSS, 0 AS CLAIM, 0 AS EDEDUCTIBLE, 0 AS DEDUCTIBLE, 
0 AS COST, 0 as RCOST, 0 as ECost, 0 as ERCost, 0 as TCOST, 0 as ETCOST, 
case When ContributionF=1 then CLSub.Amount*(100-Coalesce(CoShare.CoShare,0))/100 else 0 end as SUBROGATION, 
Case When ContributionF=0 and CessionF=1 then CLSub.Amount*(100-Coalesce(CoShare.CoShare,0))/100 else 0 end as RSUBROGATION, 
case When ContributionF=1 then CLSub.EAmount*(100-Coalesce(CoShare.CoShare,0))/100 else 0 end as ESUBROGATION, 
Case When ContributionF=0 and CessionF=1 then CLSub.EAmount*(100-Coalesce(CoShare.CoShare,0))/100 else 0 end as ERSUBROGATION, 
CLSUB.EAMOUNT*(100-Coalesce(CoShare.CoShare,0))/100 as ETSUBROGATION, 
CLSUB.AMOUNT*(100-Coalesce(CoShare.CoShare,0))/100 as TSUBROGATION,
0 as SALVAGE, 0 as RSALVAGE, 0 as ESALVAGE, 0 as ERSALVAGE, 0 as ETSALVAGE, 0 as TSALVAGE
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
	And (Claim.ISType in ('I','L') or (Claim.ISType in ('C') and CLSub.ContributionF=0))
	) CoShare
WHERE CLSUB.CNO=@P_CNO AND CLSUB.STATUS='P'

Union All            
                      
SELECT CLSAL.CURRENCY, 0 AS LOSS, 0 AS CLAIM, 0 AS EDEDUCTIBLE, 0 AS DEDUCTIBLE, 
0 as COST, 0 as RCOST, 0 as ECost, 0 as ERCost, 0 AS TCOST, 0 as ETCOST, 
0 as SUBROGATION, 0 as RSUBROGATION, 0 as ESUBROGATION, 0 as ERSUBROGATION, 0 as ETSUBROGATION, 0 as TSUBROGATION,
case When ContributionF=1 then (CLSAL.Amount-CLSAL.VAT) else 0 end as SALVAGE, 
Case When ContributionF=0 and CessionF=1 then (CLSAL.Amount-CLSAL.VAT) else 0 end as RSALVAGE, 
case When ContributionF=1 then (CLSAL.EAMOUNT-Case When CLSAL.Amount<>0 Then CLSAL.EAmount/CLSAL.Amount*CLSAL.VAT Else 0 end) else 0 end as ESALVAGE, 
Case When ContributionF=0 and CessionF=1 then (CLSAL.EAMOUNT-Case When CLSAL.Amount<>0 Then CLSAL.EAmount/CLSAL.Amount*CLSAL.VAT Else 0 end) else 0 end as ERSALVAGE, 
(CLSAL.EAMOUNT-Case When CLSAL.Amount<>0 Then CLSAL.EAmount/CLSAL.Amount*CLSAL.VAT Else 0 end) as ETSALVAGE, 
(CLSAL.Amount-CLSAL.VAT) as TSALVAGE
From CLAIM
INNER JOIN CLSAL ON (CLSAL.CNO=CLAIM.CNO)
INNER JOIN ACCEPTANCE ON (ACCEPTANCE.ANO=CLAIM.ANO)
CROSS APPLY (
	Select TOP 1 RCOVER.ANO
	from RCOVER
	INNER JOIN ICALC ON (ICALC.ANO=RCOVER.ANO AND ICALC.CODE=RCOVER.CODE AND ICALC.SDATE=RCOVER.SDATE AND ICALC.INO=CLSAL.INO)
	INNER JOIN COL ON (COL.COL=CLAIM.COL AND COL.TOR=ICALC.TOR)
	WHERE RCOVER.ANO=CLAIM.ANO
	and (RCover.RetroActiveF=1 or (RCOVER.SDATE<=CLAIM.LOSSDATE AND ACCEPTANCE.ExclusiveF=1) or ((RCOVER.SDATE<CLAIM.LOSSDATE or (RCOVER.SDATE=CLAIM.LOSSDATE AND ACCEPTANCE.STIME<=Claim.LossTime)) AND ACCEPTANCE.ExclusiveF=0))           
	AND ((dbo.fn_Get_ExtPeriodDate(ACCEPTANCE.ExtRPeriod, 0, dbo.fn_Get_ExtPeriodDate(ACCEPTANCE.ExtPeriod, ACCEPTANCE.ExtPeriodInDaysF, RCOVER.EDATE))>CLAIM.LOSSDATE AND ACCEPTANCE.ExclusiveF=1) or ((dbo.fn_Get_ExtPeriodDate(ACCEPTANCE.ExtRPeriod, 0, dbo.fn_Get_ExtPeriodDate(ACCEPTANCE.ExtPeriod, ACCEPTANCE.ExtPeriodInDaysF, RCOVER.EDATE))>CLAIM.LOSSDATE or (dbo.fn_Get_ExtPeriodDate(ACCEPTANCE.ExtRPeriod, 0, dbo.fn_Get_ExtPeriodDate(ACCEPTANCE.ExtPeriod, ACCEPTANCE.ExtPeriodInDaysF, RCOVER.EDATE))=CLAIM.LOSSDATE AND ACCEPTANCE.ETIME>Claim.LossTime)) AND ACCEPTANCE.ExclusiveF=0))          
	Order By RCover.SDate Desc
) RCOVER
WHERE CLAIM.CNO=@P_CNO AND CLSAL.Status='P'        
) 
go





insert into PatchVersioning
select '1091 Update Script - Patch 2024 (29)',GETDATE()
go
	

Declare @PrevScript varchar(100)
Declare @CurrScript varchar(100)

Select @PrevScript=''
Select @CurrSCript='1091 Update Script - Patch 2024 (29)'


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