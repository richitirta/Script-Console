IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'ApplyCoShareF' AND Object_ID = Object_ID(N'CLCOST'))
BEGIN
ALTER TABLE dbo.CLCOST ADD
	ApplyCoShareF bit NULL
DECLARE @v sql_variant 
SET @v = N'Apply Co Share (0 : No, 1 : Yes)'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'CLCOST', N'COLUMN', N'ApplyCoShareF'
end
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
	And (Claim.ISType in ('I','L') or (Claim.ISType in ('C') and CLSub.ContributionF=0))
	) CoShare
WHERE CLSUB.CNO=@P_Cno and CLSUB.currency=@P_Currency and CLSUB.Status='P'
GROUP BY CLSUB.CNO, CLSUB.ID, CLSUB.Currency, CLSUB.RefNo


GO

DROP PROCEDURE CLCostTo
GO
CREATE PROCEDURE CLCostTo (@P_CNO as integer, @P_Currency as varchar(10)) 
AS 
SELECT C2.cno, C2.id, coalesce(I.ID, C2.ID) as LeaderID, C2.currency, C2.RefNo, C2.CCType, 'L' as CodeExt,
Max(C1.Payment) as Payment,
Max(Coalesce(CoShare.CoShare,0)) as CoShare,
Case When C1.ISType='I' or C2.CCOLLECTIONF=1 then cast(0 as Bit) else C2.ContributionF end as ContributionF, C2.CCollectionF, sum(C2.amount) AS amount, sum(C2.tax) as tax
From CLAIM C1 
INNER JOIN CLCOST C2 ON (C1.CNO=C2.CNO) 
OUTER APPLY (SELECT TOP 1 TOR, CODE AS RCODE FROM LCALC WHERE CNO=C2.CNO Order By Case When LCALC.Currency=C2.Currency Then 0 Else 1 End, Code, TOR) LCALC
INNER JOIN ACCEPTANCE A ON (A.ANO=C1.ANO) 
LEFT JOIN ISOURCE I ON (I.CNO=A.CNO) 
Outer Apply (
	Select Top 1 RCover.CoShare 
	from RCover 
	Where RCover.ANO=C1.ANO and RCover.Code=LCALC.RCODE
	AND (RCover.RetroActiveF=1 or (RCOVER.SDATE<=C1.LOSSDATE AND A.ExclusiveF=1) or ((RCOVER.SDATE<C1.LOSSDATE or (RCOVER.SDATE=C1.LOSSDATE AND A.STIME<=C1.LossTime)) AND A.ExclusiveF=0))           
	AND ((dbo.fn_Get_ExtPeriodDate(A.ExtRPeriod, 0, dbo.fn_Get_ExtPeriodDate(A.ExtPeriod, A.ExtPeriodInDaysF, RCOVER.EDATE))>C1.LOSSDATE AND A.ExclusiveF=1) or ((dbo.fn_Get_ExtPeriodDate(A.ExtRPeriod, 0, dbo.fn_Get_ExtPeriodDate(A.ExtPeriod, A.ExtPeriodInDaysF, RCOVER.EDATE))>C1.LOSSDATE or (dbo.fn_Get_ExtPeriodDate(A.ExtRPeriod, 0, dbo.fn_Get_ExtPeriodDate(A.ExtPeriod, A.ExtPeriodInDaysF, RCOVER.EDATE))=C1.LOSSDATE AND A.ETIME>C1.LossTime)) AND A.ExclusiveF=0))          	
	And (C1.ISType in ('I','L') or (C1.ISType in ('C') and C2.ContributionF=0))
	And C2.ApplyCoShareF=1
	) CoShare
WHERE C2.CNO=@p_cno and C2.currency=@p_currency and C2.Status='P' 
GROUP BY C2.cno, C2.id, I.ID, C2.currency, C2.RefNo, C2.CCtype, Case When C1.ISType='I' or C2.CCOLLECTIONF=1 then cast(0 as Bit) else C2.ContributionF end, C2.CCollectionF 

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
case When ContributionF=1 then (CLSAL.Amount-CLSAL.VAT) else 0 end as ESALVAGE, 
Case When ContributionF=0 and CessionF=1 then (CLSAL.Amount-CLSAL.VAT) else 0 end as ERSALVAGE, 
(CLSAL.Amount-CLSAL.VAT) as ETSALVAGE, 
(CLSAL.Amount-CLSAL.VAT) as TSALVAGE
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
) 


go




 insert into PatchVersioning	
select '593 Update Script - 24 Maret 2023',GETDATE()
go





Declare @PrevScript varchar(100)
Declare @CurrScript varchar(100)

Select @PrevScript=''
Select @CurrSCript='593 Update Script - 24 Maret 2023'


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





