DROP PROCEDURE CLItemLossTo 
GO
CREATE PROCEDURE CLItemLossTo (@P_CNO as integer, @P_Currency as varchar(255))       
AS
SELECT CNO, PAYMENT, CURRENCY, REFNO, CURRENCY_OC, CODEEXT, MAX(RATE) AS RATE, MAX(RCODE) AS RCODE, MAX(TOR) AS TOR, SUM(CLAIM)/MAX(RATE) AS CLAIM, SUM(TAX)/MAX(RATE) AS TAX, SUM(DEDUCTIBLE)/MAX(RATE) AS DEDUCTIBLE
FROM
(
	SELECT CLLOSS.CNO, CLLOSS.INO, CLLOSS.NOC, CLLOSS.Payment, CLLOSS.CURRENCY, Case When CLLOSS.RefNo='' Then Claim.RefNo else CLLoss.RefNo end as RefNo, 
	 MAX(CLLOSS.CURRENCY) as CURRENCY_OC, 
	 MAX(cast(1 as Float)) as RATE,
	 MAX(case When coalesce(NOCTAB.CODEEXT,'')='' then 'A' Else NOCTAB.CODEEXT End) AS CODEEXT, Max(RCOVER.CODE) AS RCODE, MAX(ICALC.TOR) AS TOR,
	 Max(    
	  CASE            
	   WHEN CLLOSS.STATUS<>'P' THEN 0
	   WHEN CLLOSS.VAR<=CLLOSS.DECLARED THEN (CLLOSS.AMOUNT)             
	   ELSE (CLLOSS.DECLARED/CLLOSS.VAR) * (CLLOSS.AMOUNT)             
	  END    
	 )  as CLAIM,            
	 Max(    
	  CASE            
	   WHEN CLLOSS.STATUS<>'P' THEN 0
	   WHEN CLLOSS.VAR<=CLLOSS.DECLARED THEN (CLLOSS.TAX)             
	   ELSE (CLLOSS.DECLARED/CLLOSS.VAR) * (CLLOSS.TAX)             
	  END    
	 ) as TAX,            
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
	 as DEDUCTIBLE
	From CLLOSS
	INNER JOIN CLAIM ON (CLAIM.CNO=CLLOSS.CNO)
	INNER JOIN ACCEPTANCE ON (ACCEPTANCE.ANO=CLAIM.ANO)
	INNER JOIN COVER ON (COVER.CNO=ACCEPTANCE.CNO)
	INNER JOIN RCOVER ON (RCOVER.ANO=ACCEPTANCE.ANO)
	INNER JOIN ICALC ON (ICALC.ANO=RCOVER.ANO AND ICALC.CODE=RCOVER.CODE AND ICALC.SDATE=RCOVER.SDATE AND ICALC.INO=CLLOSS.INO)
	INNER JOIN COL ON (COL.COL=CLAIM.COL AND COL.TOR=ICALC.TOR)
	INNER JOIN NOCTAB ON (NOCTAB.NOC=CLLOSS.NOC)
	WHERE CLLOSS.CNO=@P_CNO AND CLLOSS.Currency=@P_CURRENCY 
	AND (RCover.RetroActiveF=1 or (RCOVER.SDATE<=CLAIM.LOSSDATE AND ACCEPTANCE.ExclusiveF=1) or ((RCOVER.SDATE<CLAIM.LOSSDATE or (RCOVER.SDATE=CLAIM.LOSSDATE AND ACCEPTANCE.STIME<=Claim.LossTime)) AND ACCEPTANCE.ExclusiveF=0))           
	AND ((dbo.fn_Get_ExtPeriodDate(ACCEPTANCE.ExtRPeriod, 0, dbo.fn_Get_ExtPeriodDate(ACCEPTANCE.ExtPeriod, ACCEPTANCE.ExtPeriodInDaysF, RCOVER.EDATE))>CLAIM.LOSSDATE AND ACCEPTANCE.ExclusiveF=1) or ((dbo.fn_Get_ExtPeriodDate(ACCEPTANCE.ExtRPeriod, 0, dbo.fn_Get_ExtPeriodDate(ACCEPTANCE.ExtPeriod, ACCEPTANCE.ExtPeriodInDaysF, RCOVER.EDATE))>CLAIM.LOSSDATE or (dbo.fn_Get_ExtPeriodDate(ACCEPTANCE.ExtRPeriod, 0, dbo.fn_Get_ExtPeriodDate(ACCEPTANCE.ExtPeriod, ACCEPTANCE.ExtPeriodInDaysF, RCOVER.EDATE))=CLAIM.LOSSDATE AND ACCEPTANCE.ETIME>Claim.LossTime)) AND ACCEPTANCE.ExclusiveF=0))          
	Group By CLLOSS.CNO, CLLOSS.INO, CLLOSS.NOC, CLLOSS.Payment, CLLOSS.CURRENCY, Case When CLLOSS.RefNo='' Then Claim.RefNo else CLLoss.RefNo end 
) CLLOSS
Group BY CNO, PAYMENT, CURRENCY, REFNO, CURRENCY_OC, CODEEXT
GO

DROP PROCEDURE CLCostTo
GO
CREATE PROCEDURE CLCostTo (@P_CNO as integer, @P_Currency as varchar(10)) 
AS 
SELECT C2.cno, C2.id, coalesce(I.ID, C2.ID) as LeaderID, C2.currency, Case When C2.RefNo='' Then C1.RefNo else C2.RefNo end as RefNo, C2.CCType, 'L' as CodeExt,
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
GROUP BY C2.cno, C2.id, I.ID, C2.currency, Case When C2.RefNo='' Then C1.RefNo else C2.RefNo end, C2.CCtype, Case When C1.ISType='I' or C2.CCOLLECTIONF=1 then cast(0 as Bit) else C2.ContributionF end, C2.CCollectionF 
GO

DROP PROCEDURE CLDEDTO 
GO
CREATE PROCEDURE CLDEDTO (@P_CNO as integer, @P_Currency as varchar(10))     
AS    
SELECT C.CNO, C.ID, C.CURRENCY, C.RefNo, Max(C.Currency_OC) as Currency_OC, Max(C.Rate) as Rate, Max(RCODE) as RCODE, MAX(TOR) AS TOR, sum(C.Amount)/Max(C.Rate) AS amount
FROM
(
	SELECT CLDED.CNO, CLDED.DCode, CLDED.ID, CLDED.Currency, Max(CLDED.Currency) as Currency_OC, Max(cast(1 as Float)) as Rate, MAX(Case When CLDED.RefNo='' Then Claim.RefNo else CLDed.RefNo end) AS REFNO, Max(CLDED.AMOUNT) AS AMOUNT, Max(RCOVER.CODE) as RCode, MAX(RCALC.TOR) AS TOR
	From CLDED
	INNER JOIN CLAIM ON (CLAIM.CNO=CLDED.CNO)
	INNER JOIN ACCEPTANCE ON (ACCEPTANCE.ANO=CLAIM.ANO)
	INNER JOIN COVER ON (COVER.CNO=ACCEPTANCE.CNO)
	INNER JOIN RCOVER ON (RCOVER.ANO=ACCEPTANCE.ANO)
	INNER JOIN RCALC ON (RCALC.ANO=RCOVER.ANO AND RCALC.CODE=RCOVER.CODE AND RCALC.SDATE=RCOVER.SDATE)
	INNER JOIN COL ON (COL.COL=CLAIM.COL AND COL.TOR=RCALC.TOR)
	INNER JOIN DEDTAB ON (DEDTAB.DCODE=CLDED.DCODE AND DEDTAB.TOR=COL.TOR)
	WHERE CLDED.CNO=@P_CNO AND CLDED.Currency=@P_Currency AND (CLDED.ESTAMOUNT<>0 or CLDED.AMOUNT<>0)            
	AND (RCover.RetroActiveF=1 or (RCOVER.SDATE<=CLAIM.LOSSDATE AND ACCEPTANCE.ExclusiveF=1) or ((RCOVER.SDATE<CLAIM.LOSSDATE or (RCOVER.SDATE=CLAIM.LOSSDATE AND ACCEPTANCE.STIME<=Claim.LossTime)) AND ACCEPTANCE.ExclusiveF=0))           
	AND ((dbo.fn_Get_ExtPeriodDate(ACCEPTANCE.ExtRPeriod, 0, dbo.fn_Get_ExtPeriodDate(ACCEPTANCE.ExtPeriod, ACCEPTANCE.ExtPeriodInDaysF, RCOVER.EDATE))>CLAIM.LOSSDATE AND ACCEPTANCE.ExclusiveF=1) or ((dbo.fn_Get_ExtPeriodDate(ACCEPTANCE.ExtRPeriod, 0, dbo.fn_Get_ExtPeriodDate(ACCEPTANCE.ExtPeriod, ACCEPTANCE.ExtPeriodInDaysF, RCOVER.EDATE))>CLAIM.LOSSDATE or (dbo.fn_Get_ExtPeriodDate(ACCEPTANCE.ExtRPeriod, 0, dbo.fn_Get_ExtPeriodDate(ACCEPTANCE.ExtPeriod, ACCEPTANCE.ExtPeriodInDaysF, RCOVER.EDATE))=CLAIM.LOSSDATE AND ACCEPTANCE.ETIME>Claim.LossTime)) AND ACCEPTANCE.ExclusiveF=0))     
	Group by CLDED.CNO, CLDED.DCode, CLDED.ID, CLDED.Currency
) C
GROUP BY C.CNO, C.ID, C.CURRENCY, C.RefNo
GO

DROP PROCEDURE CLSubrogationTo 
GO
CREATE PROCEDURE CLSubrogationTo (@P_Cno as integer, @P_Currency as varchar(255))
AS
SELECT CLSUB.CNO, CLSUB.ID, CLSUB.Currency, Case When CLSUB.RefNo='' Then Claim.RefNo else CLSub.RefNo end as Refno, 'R' as CodeExt, 
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
GROUP BY CLSUB.CNO, CLSUB.ID, CLSUB.Currency, Case When CLSUB.RefNo='' Then Claim.RefNo else CLSub.RefNo end

go






 insert into PatchVersioning
select '807 Update Script - Patch 2023 (102)',GETDATE()
go


Declare @PrevScript varchar(100)
Declare @CurrScript varchar(100)

Select @PrevScript=''
Select @CurrSCript='807 Update Script - Patch 2023 (102)'


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