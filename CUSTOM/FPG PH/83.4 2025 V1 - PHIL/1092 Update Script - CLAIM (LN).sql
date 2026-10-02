DROP PROCEDURE CLCostTo 
GO
CREATE PROCEDURE CLCostTo (@P_CNO as integer, @P_Currency as varchar(10)) 
AS 
SELECT C2.cno, C2.id, coalesce(I.ID, C2.ID) as LeaderID, C2.currency, Case When C2.RefNo='' Then C1.RefNo else C2.RefNo end as RefNo, C2.CCType, 'L' as CodeExt,
Max(B.KPPID) as KPPID, 
cast(Max(cast(coalesce(C.DefaultF,0) as Int)) as bit) as LocalCountryF,
Max(C1.Payment) as Payment,
Max(Coalesce(CoShare.CoShare,0)) as CoShare,
Case When C1.ISType='I' or C2.CCOLLECTIONF=1 then cast(0 as Bit) else C2.ContributionF end as ContributionF, C2.CCollectionF, sum(C2.amount) AS amount, sum(C2.VAT) AS VAT, sum(C2.tax) as tax
From CLAIM C1 
INNER JOIN CLCOST C2 ON (C1.CNO=C2.CNO) 
OUTER APPLY (SELECT TOP 1 TOR, CODE AS RCODE FROM LCALC WHERE CNO=C2.CNO Order By Case When LCALC.Currency=C2.Currency Then 0 Else 1 End, Code, TOR) LCALC
INNER JOIN ACCEPTANCE A ON (A.ANO=C1.ANO) 
INNER JOIN PROFILE P ON (P.ID=C2.ID)
LEFT JOIN COUNTRY C ON (C.COUNTRY=P.COUNTRY)
INNER JOIN BRANCH B ON (B.BRANCH=A.BRANCH)
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

DROP PROCEDURE CLItemLossTo 
GO
CREATE PROCEDURE CLItemLossTo (@P_CNO as integer, @P_Currency as varchar(255))       
AS
SELECT CLLOSS.CNO, CLLOSS.PAYMENT, CLLOSS.CURRENCY, CLLOSS.REFNO, CLLOSS.CURRENCY_OC, CLLOSS.CODEEXT, 
Max(B.KPPID) as KPPID, 
cast(Max(cast(coalesce(C.DefaultF,0) as Int)) as bit) as LocalCountryF,
MAX(CLLOSS.RATE) AS RATE, MAX(CLLOSS.RCODE) AS RCODE, MAX(CLLOSS.TOR) AS TOR, SUM(CLLOSS.CLAIM)/MAX(CLLOSS.RATE) AS CLAIM, SUM(CLLOSS.VAT)/MAX(CLLOSS.RATE) AS VAT , SUM(CLLOSS.TAX)/MAX(CLLOSS.RATE) AS TAX, SUM(CLLOSS.DEDUCTIBLE)/MAX(CLLOSS.RATE) AS DEDUCTIBLE
FROM
(
	SELECT CLLOSS.CNO, CLLOSS.INO, CLLOSS.NOC, CLLOSS.Payment, CLLOSS.CURRENCY, Case When CLLOSS.RefNo='' Then Claim.RefNo else CLLOSS.RefNo end as RefNo, 
	 MAX(CLLOSS.CURRENCY) as CURRENCY_OC, 
	 MAX(cast(1 as Float)) as RATE,
	 MAX(case When coalesce(NOCTAB.CODEEXT,'')='' then 'A' Else NOCTAB.CODEEXT End) AS CODEEXT, Max(RCOVER.CODE) AS RCODE, MAX(ICALC.TOR) AS TOR,
	 Max(    
	  CASE            
	   WHEN CLLOSS.STATUS<>'P' THEN 0
	   WHEN CLLOSS.VAR<=CLLOSS.DECLARED THEN (CLLOSS.AMOUNT)             
	   ELSE (CLLOSS.DECLARED/CLLOSS.VAR) * (CLLOSS.AMOUNT)             
	  END    
	 ) as CLAIM,            
	 Max(    
	  CASE            
	   WHEN CLLOSS.STATUS<>'P' THEN 0
	   WHEN CLLOSS.VAR<=CLLOSS.DECLARED THEN (CLLOSS.VAT)             
	   ELSE (CLLOSS.DECLARED/CLLOSS.VAR) * (CLLOSS.VAT)             
	  END    
	 )as VAT,         
	 Max(    
	  CASE            
	   WHEN CLLOSS.STATUS<>'P' THEN 0
	   WHEN CLLOSS.VAR<=CLLOSS.DECLARED THEN (CLLOSS.TAX)             
	   ELSE (CLLOSS.DECLARED/CLLOSS.VAR) * (CLLOSS.TAX)             
	  END    
	 )as TAX,            
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
	WHERE CLLOSS.CNO=@P_CNO AND CLLOSS.CURRENCY=@P_CURRENCY 
	AND (RCover.RetroActiveF=1 or (RCOVER.SDATE<=CLAIM.LOSSDATE AND ACCEPTANCE.ExclusiveF=1) or ((RCOVER.SDATE<CLAIM.LOSSDATE or (RCOVER.SDATE=CLAIM.LOSSDATE AND ACCEPTANCE.STIME<=Claim.LossTime)) AND ACCEPTANCE.ExclusiveF=0))           
	AND ((dbo.fn_Get_ExtPeriodDate(ACCEPTANCE.ExtRPeriod, 0, dbo.fn_Get_ExtPeriodDate(ACCEPTANCE.ExtPeriod, ACCEPTANCE.ExtPeriodInDaysF, RCOVER.EDATE))>CLAIM.LOSSDATE AND ACCEPTANCE.ExclusiveF=1) or ((dbo.fn_Get_ExtPeriodDate(ACCEPTANCE.ExtRPeriod, 0, dbo.fn_Get_ExtPeriodDate(ACCEPTANCE.ExtPeriod, ACCEPTANCE.ExtPeriodInDaysF, RCOVER.EDATE))>CLAIM.LOSSDATE or (dbo.fn_Get_ExtPeriodDate(ACCEPTANCE.ExtRPeriod, 0, dbo.fn_Get_ExtPeriodDate(ACCEPTANCE.ExtPeriod, ACCEPTANCE.ExtPeriodInDaysF, RCOVER.EDATE))=CLAIM.LOSSDATE AND ACCEPTANCE.ETIME>Claim.LossTime)) AND ACCEPTANCE.ExclusiveF=0))          
	Group By CLLOSS.CNO, CLLOSS.INO, CLLOSS.NOC, CLLOSS.Payment, CLLOSS.CURRENCY, Case When CLLOSS.RefNo='' Then Claim.RefNo else CLLOSS.RefNo end
) CLLOSS
INNER JOIN CLAIM C1 ON (C1.CNO=CLLOSS.CNO)
INNER JOIN ACCEPTANCE A ON (A.ANO=C1.ANO)
INNER JOIN PROFILE P ON (P.ID=CLLOSS.PAYMENT)
LEFT JOIN COUNTRY C ON (C.COUNTRY=P.COUNTRY)
INNER JOIN BRANCH B ON (B.BRANCH=A.BRANCH)
Group BY CLLOSS.CNO, CLLOSS.PAYMENT, CLLOSS.CURRENCY, CLLOSS.REFNO, CLLOSS.CURRENCY_OC, CLLOSS.CODEEXT

GO

DROP PROCEDURE CLSalvageTo
GO
CREATE PROCEDURE CLSalvageTo (@P_CNO as integer, @P_Currency as varchar(10))     
AS    
SELECT cno, id, currency, CSType, 'S' as CodeExt, cast(Max(cast(CLSAL.ContributionF as Int)) as Bit) as ContributionF, Max(RCODE) as RCODE, MAX(TOR) AS TOR, sum(clSAL.GrossAmount) as GrossAmount, sum(clsal.VAT) as VAT, sum(clsal.amount) AS amount, sum(clsal.TAX) as TAX, sum(clsal.NetAmount) as NetAmount
FROM
(
SELECT CLSAL.CNO, CLSAL.INO, CLSAL.ID, CLSAL.Currency, cast(Max(cast(CLSAL.ContributionF as Int)) as Bit) as ContributionF, Max(CLSal.CSType) as CSType, Max(RCOVER.CODE) as RCode, Max(ICALC.TOR) AS TOR, Max(CLSAL.GROSSAMOUNT) AS GROSSAMOUNT, Max(CLSAL.VAT) AS VAT, Max(CLSAL.AMOUNT) AS AMOUNT, Max(CLSAL.TAX) AS TAX, Max(CLSAL.NETAMOUNT) AS NETAMOUNT

From CLSAL
INNER JOIN CLAIM ON (CLAIM.CNO=CLSAL.CNO)
INNER JOIN ACCEPTANCE ON (ACCEPTANCE.ANO=CLAIM.ANO)
INNER JOIN COVER ON (COVER.CNO=ACCEPTANCE.CNO)
INNER JOIN RCOVER ON (RCOVER.ANO=ACCEPTANCE.ANO)
INNER JOIN ICALC ON (ICALC.ANO=RCOVER.ANO AND ICALC.CODE=RCOVER.CODE AND ICALC.SDATE=RCOVER.SDATE AND ICALC.INO=CLSAL.INO)
INNER JOIN COL ON (COL.COL=CLAIM.COL AND COL.TOR=ICALC.TOR)
WHERE CLSAL.CNO=@P_CNO AND CLSAL.CURRENCY=@P_CURRENCY AND CLSAL.Status='P'        
AND (RCover.RetroActiveF=1 or (RCOVER.SDATE<=CLAIM.LOSSDATE AND ACCEPTANCE.ExclusiveF=1) or ((RCOVER.SDATE<CLAIM.LOSSDATE or (RCOVER.SDATE=CLAIM.LOSSDATE AND ACCEPTANCE.STIME<=Claim.LossTime)) AND ACCEPTANCE.ExclusiveF=0))           
AND ((dbo.fn_Get_ExtPeriodDate(ACCEPTANCE.ExtRPeriod, 0, dbo.fn_Get_ExtPeriodDate(ACCEPTANCE.ExtPeriod, ACCEPTANCE.ExtPeriodInDaysF, RCOVER.EDATE))>CLAIM.LOSSDATE AND ACCEPTANCE.ExclusiveF=1) or ((dbo.fn_Get_ExtPeriodDate(ACCEPTANCE.ExtRPeriod, 0, dbo.fn_Get_ExtPeriodDate(ACCEPTANCE.ExtPeriod, ACCEPTANCE.ExtPeriodInDaysF, RCOVER.EDATE))>CLAIM.LOSSDATE or (dbo.fn_Get_ExtPeriodDate(ACCEPTANCE.ExtRPeriod, 0, dbo.fn_Get_ExtPeriodDate(ACCEPTANCE.ExtPeriod, ACCEPTANCE.ExtPeriodInDaysF, RCOVER.EDATE))=CLAIM.LOSSDATE AND ACCEPTANCE.ETIME>Claim.LossTime)) AND ACCEPTANCE.ExclusiveF=0))          
Group By CLSAL.CNO, CLSAL.INO, CLSAL.ID, CLSAL.Currency    
) CLSAL
GROUP BY cno, id, currency, CSType 


GO


DROP FUNCTION CCALC01a
GO
CREATE FUNCTION CCALC01a(@P_CNO as integer)            
RETURNS Table            
AS RETURN (            
SELECT CLLOSS.CURRENCY AS CURRENCY, Max(RCOVER.CODE) as Code, max(ICALC.TOR) as TOR,                 
  CASE              
   WHEN MAX(CLLOSS.VAR)<=MAX(CLLOSS.DECLARED) THEN (Select sum(C.Estimate*Case When C.Amount<>0 Then 100/(100 + (C.VAT/C.DiscAmount*100)) When C.VatF=1 and P.VatF=1 Then 100/(100+P.VAT) Else 1 end) from CLItem C Inner Join Profile P on (P.ID=C.Payment) Where C.CNO=CLLOSS.CNO and C.INO=CLLOSS.INO and C.NOC=CLLOSS.NOC and C.Payment=CLLOSS.Payment and C.Currency=CLLOSS.Currency and C.RefNo=CLLOSS.RefNo)
   ELSE MAX(CLLOSS.DECLARED/CLLOSS.VAR) * (Select sum(C.Estimate*Case When C.Amount<>0 Then 100/(100 + (C.VAT/C.DiscAmount*100)) When C.VatF=1 and P.VatF=1 Then 100/(100+P.VAT) Else 1 end) from CLItem C Inner Join Profile P on (P.ID=C.Payment) Where C.CNO=CLLOSS.CNO and C.INO=CLLOSS.INO and C.NOC=CLLOSS.NOC and C.Payment=CLLOSS.Payment and C.Currency=CLLOSS.Currency and C.RefNo=CLLOSS.RefNo)
  END    
 as LOSS,            
 Max(    
  CASE            
   WHEN CLLOSS.STATUS<>'P' THEN 0
   WHEN CLLOSS.VAR<=CLLOSS.DECLARED THEN (CLLOSS.AMOUNT-CLLOSS.VAT)             
   ELSE (CLLOSS.DECLARED/CLLOSS.VAR) * (CLLOSS.AMOUNT-CLLOSS.VAT)             
  END    
 ) as INDEMNITY,            
 CASE              
   WHEN MAX(CLLOSS.VAR)<=MAX(CLLOSS.DECLARED) THEN (Select sum(C.Estimate*Case When C.Amount<>0 Then 100/(100 + (C.VAT/C.DiscAmount*100)) When C.VatF=1 and P.VatF=1 Then 100/(100+P.VAT) Else 1 end) from CLItem C Inner Join Profile P on (P.ID=C.Payment) Where C.CNO=CLLOSS.CNO and C.INO=CLLOSS.INO and C.NOC=CLLOSS.NOC and C.Payment=CLLOSS.Payment and C.Currency=CLLOSS.Currency and C.RefNo=CLLOSS.RefNo)
   ELSE MAX(CLLOSS.DECLARED/CLLOSS.VAR) * (Select sum(C.Estimate*Case When C.Amount<>0 Then 100/(100 + (C.VAT/C.DiscAmount*100)) When C.VatF=1 and P.VatF=1 Then 100/(100+P.VAT) Else 1 end) from CLItem C Inner Join Profile P on (P.ID=C.Payment) Where C.CNO=CLLOSS.CNO and C.INO=CLLOSS.INO and C.NOC=CLLOSS.NOC and C.Payment=CLLOSS.Payment and C.Currency=CLLOSS.Currency and C.RefNo=CLLOSS.RefNo)
  END*MAX(RCOVER.COSHARE)/100      
  +
 CASE              
   WHEN MAX(CLLOSS.VAR)<=MAX(CLLOSS.DECLARED) THEN (Select sum(C.EDepreciation*Case When C.Amount<>0 Then 100/(100 + (C.VAT/C.DiscAmount*100)) When C.VatF=1 and P.VatF=1 Then 100/(100+P.VAT) Else 1 end) from CLItem C Inner Join Profile P on (P.ID=C.Payment) Where C.CNO=CLLOSS.CNO and C.INO=CLLOSS.INO and C.NOC=CLLOSS.NOC and C.Payment=CLLOSS.Payment and C.Currency=CLLOSS.Currency and C.RefNo=CLLOSS.RefNo)
   ELSE MAX(CLLOSS.DECLARED/CLLOSS.VAR) * (Select sum(C.EDepreciation*Case When C.Amount<>0 Then 100/(100 + (C.VAT/C.DiscAmount*100)) When C.VatF=1 and P.VatF=1 Then 100/(100+P.VAT) Else 1 end) from CLItem C Inner Join Profile P on (P.ID=C.Payment) Where C.CNO=CLLOSS.CNO and C.INO=CLLOSS.INO and C.NOC=CLLOSS.NOC and C.Payment=CLLOSS.Payment and C.Currency=CLLOSS.Currency and C.RefNo=CLLOSS.RefNo)
  END  
 as EDEDUCTIBLE,            
 Max(    
  CASE            
   WHEN CLLOSS.STATUS<>'P' THEN 0
   WHEN CLLOSS.VAR<=CLLOSS.DECLARED THEN (CLLOSS.AMOUNT-CLLOSS.VAT)
   ELSE (CLLOSS.DECLARED/CLLOSS.VAR) * (CLLOSS.AMOUNT-CLLOSS.VAT)
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
                      
SELECT CLDED.Currency as Currency, Max(RCOVER.CODE) as Code, max(RCALC.TOR) as TOR, 0 AS LOSS, 0 AS INDEMNITY, Max(CLDED.ESTAMOUNT-Case When CLDED.AMOUNT<>0 THEN CLDED.ESTAMOUNT/CLDED.AMOUNT*CLDED.VAT ELSE 0 END) AS EDEDUCTIBLE, Max(CLDED.AMOUNT-CLDED.VAT) AS DEDUCTIBLE, 0 as ESALVAGE, 0 AS SALVAGE            
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
                      
SELECT CLSAL.CURRENCY, Max(RCOVER.CODE) as Code, Max(ICALC.TOR) as TOR, 0 AS LOSS, 0 AS INDEMNITY, 0 AS EDEDUCTIBLE, 0 AS DEDUCTIBLE, MAX(CLSAL.EAMOUNT-Case When CLSAL.Amount<>0 Then CLSAL.EAmount/CLSAL.Amount*CLSAL.VAT Else 0 end) AS ESALVAGE, Max(CLSAL.AMOUNT-CLSAL.VAT) AS SALVAGE
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
0 as COST, 
0 as RCOST, 
0 as ECost, 
0 as ERCost, 
0 AS TCOST, 
0 as ETCOST, 
0 as SUBROGATION, 
0 as RSUBROGATION, 
0 as ESUBROGATION, 
0 as ERSUBROGATION, 
0 as ETSUBROGATION, 
0 as TSUBROGATION,
0 as SALVAGE, 
0 as RSALVAGE, 
0 as ESALVAGE, 
0 as ERSALVAGE, 
0 as ETSALVAGE, 
0 as TSALVAGE
From LCalc 
Where LCalc.CNO=@P_CNO 
 
Union All 
 
SELECT CLDED.CURRENCY, 0 AS LOSS, 0 AS CLAIM, 0 AS EDEDUCTIBLE, 0 AS DEDUCTIBLE, 
0 as COST, 
0 as RCOST, 
0 as ECost, 
0 as ERCost, 
0 AS TCOST, 
0 as ETCOST, 
0 as SUBROGATION, 
0 as RSUBROGATION, 
0 as ESUBROGATION, 
0 as ERSUBROGATION, 
0 as ETSUBROGATION, 
0 as TSUBROGATION,
0 as SALVAGE, 
0 as RSALVAGE, 
0 as ESALVAGE, 
0 as ERSALVAGE, 
0 as ETSALVAGE, 
0 as TSALVAGE
From CLFACDED CLDED 
WHERE CLDED.CNO=@P_CNO And (CLDED.AMOUNT<>0) 

 
Union All 
 
SELECT CLCOST.CURRENCY, 0 AS LOSS, 0 AS CLAIM, 0 AS EDEDUCTIBLE, 0 AS DEDUCTIBLE, 
case When ContributionF=1 then (CLCOST.Amount-CLCOST.VAT)*(100-Coalesce(CoShare.CoShare,0))/100 else 0 end as COST, 
Case When ContributionF=0 and CessionF=1 then (CLCOST.Amount-CLCOST.VAT)*(100-Coalesce(CoShare.CoShare,0))/100 else 0 end as RCOST, 
case When ContributionF=1 then (CLCOST.EstAmount-Case When CLCOST.Amount<>0 THEN CLCOST.EstAmount/CLCOST.Amount*CLCOST.VAT ELSE 0 END)*(100-Coalesce(CoShare.CoShare,0))/100 else 0 end as ECOST, 
Case When ContributionF=0 and CessionF=1 then (CLCOST.EstAmount-Case When CLCOST.Amount<>0 THEN CLCOST.EstAmount/CLCOST.Amount*CLCOST.VAT ELSE 0 END)*(100-Coalesce(CoShare.CoShare,0))/100 else 0 end as ERCOST, 
(CLCOST.AMOUNT-CLCOST.VAT)*(100-Coalesce(CoShare.CoShare,0))/100 as TCOST, 
(CLCOST.EstAmount-Case When CLCOST.Amount<>0 THEN CLCOST.EstAmount/CLCOST.Amount*CLCOST.VAT ELSE 0 END)*(100-Coalesce(CoShare.CoShare,0))/100 AS ETCOST, 
0 as SUBROGATION, 
0 as RSUBROGATION, 
0 as ESUBROGATION, 
0 as ERSUBROGATION, 
0 as ETSUBROGATION, 
0 as TSUBROGATION,
0 as SALVAGE, 
0 as RSALVAGE, 
0 as ESALVAGE, 
0 as ERSALVAGE, 
0 as ETSALVAGE, 
0 as TSALVAGE
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

GO

DROP PROCEDURE CCALC02
GO
CREATE PROCEDURE CCALC02 (@P_CNO as integer)
AS
SELECT
      CURRENCY,
      SUM(LOSS) AS LOSS,
      SUM(CLAIM) AS CLAIM,
      SUM(EDEDUCTIBLE) AS EDEDUCTIBLE,
      SUM(DEDUCTIBLE) AS DEDUCTIBLE,
      SUM(COST) AS COST,
      SUM(RCOST) AS RCOST,
      SUM(ECOST) AS ECOST,
      SUM(ERCOST) AS ERCOST,
      SUM(TCOST) AS TCOST,
      SUM(ETCOST) AS ETCOST,
      SUM(SUBROGATION) As SUBROGATION,
	  SUM(RSUBROGATION) As RSUBROGATION,
	  SUM(ESUBROGATION) As ESUBROGATION,
	  SUM(ERSUBROGATION) As ERSUBROGATION,
      SUM(TSUBROGATION) As TSUBROGATION,
	  SUM(ETSUBROGATION) As ETSUBROGATION,
	  SUM(SALVAGE) As SALVAGE,
	  SUM(RSALVAGE) As RSALVAGE,
	  SUM(ESALVAGE) As ESALVAGE,
	  SUM(ERSALVAGE) As ERSALVAGE,
      SUM(TSALVAGE) As TSALVAGE,
	  SUM(ETSALVAGE) As ETSALVAGE
FROM CCALC02A(@P_CNO)
GROUP BY CURRENCY


GO
DROP procedure QApproval_Claim 
GO
Create procedure QApproval_Claim (@P_CNO integer)            
AS            
Select Claim.Branch, Claim.TOC, Claim.ISType, 
sum(GrossEstimate-MemberEstimate) as Estimate, 
sum(PrevGrossEstimate-PrevMemberEstimate) as PrevEstimate, 
sum(GrossAmount-MemberAmount) as Amount,
sum(PrevGrossAmount-PrevMemberAmount) as PrevAmount  
from   
(  
	Select Claim.Branch, Claim.TOC, Claim.ISType, CCalc.Currency, 
	Max((CCalc.Loss+CCalc.ECost)*CCalc.Share/100*CCalc.Rate) as GrossEstimate,   
	Max((pCCalc.Loss+pCCalc.ECost)*pCCalc.Share/100*pCCalc.Rate) as PrevGrossEstimate,   
  
	Sum(
	Case When Coalesce(Coinsurance.CCollectionF,1)=1 Then   
	 0  
	 else  
	 (CCalc.Loss+CCalc.ECost)*CCalc.Share/100*(coalesce(Coinsurance.Share,0)/100)*CCalc.Rate  
	End) as MemberEstimate,  

	Sum(
	Case When Coalesce(Coinsurance.CCollectionF,1)=1 Then   
	 0  
	 else  
	 (pCCalc.Loss+pCCalc.ECost)*pCCalc.Share/100*(coalesce(Coinsurance.Share,0)/100)*pCCalc.Rate  
	End) as PrevMemberEstimate,  
  
	Max((CCalc.Claim+CCalc.Cost)*CCalc.Share/100*CCalc.Rate) as GrossAmount,  
	Max(Case When Claim.CSeqNo>0 then (pCCalc.Claim+pCCalc.Cost)*pCCalc.Share/100*pCCalc.Rate else 0 end) as PrevGrossAmount,  
  
	Sum(
	Case When Coalesce(Coinsurance.CCollectionF,1)=1 Then   
	 0  
	 else  
	 (CCalc.Claim+CCalc.Cost)*CCalc.Share/100*(coalesce(Coinsurance.Share,0)/100)*CCalc.Rate  
	End) as MemberAmount,

	Sum(
	Case When Coalesce(Coinsurance.CCollectionF,1)=1 Then   
	 0  
	 else  
	 Case When Claim.CSeqNo>0 then (pCCalc.Claim+pCCalc.Cost)*pCCalc.Share/100*(coalesce(Coinsurance.Share,0)/100)*pCCalc.Rate else 0 end
	End) as PrevMemberAmount
  
	From Claim  
	inner join CCALC on (CCalc.CNO=Claim.CNO)  
	inner join Acceptance on (Acceptance.ANO=Claim.ANO)  
	Left Join Coinsurance on (Coinsurance.CNO=Acceptance.CNO and Claim.ISType='L')  
	Left join CCalc pCCalc on (pCCalc.CNO=Claim.pCNO and pCCalc.Currency=CCalc.Currency)
	WHERE Claim.CNO=@P_CNO   
	Group By Claim.Branch, Claim.TOC, Claim.ISType, CCalc.Currency
) Claim  
  
Group by Claim.Branch, Claim.TOC, Claim.ISType      


   




GO

DROP PROCEDURE CLAIM_PAID_BY_POLICY
GO
CREATE PROCEDURE CLAIM_PAID_BY_POLICY(@P_POLICYNO as varchar(20),@P_CERTIFICATENO as varchar(20))  
AS  
SELECT SUM(CLAASS.AMOUNT*NVOUCHER.RATE) AS CLAIM_PAID  
FROM ACCEPTANCE
INNER JOIN CLAIM ON (CLAIM.ANO=ACCEPTANCE.ANO)
INNER JOIN CLAASS ON (CLAASS.CNO=CLAIM.CNO)
INNER JOIN ADMLINK ON (ADMLINK.ADMNO=CLAASS.ADMNO)
INNER JOIN NVOUCHER ON (NVOUCHER.VOUCHER=ADMLINK.VOUCHER)
WHERE ACCEPTANCE.POLICYNO=@P_POLICYNO AND ACCEPTANCE.CERTIFICATENO=@P_CERTIFICATENO 
AND CLAASS.TYPE IN ('DI','IC','IR','OP','CF','JP') 
AND CLAASS.CODE NOT IN ('V','T','F','D') 
GO



DROP PROCEDURE CLDEDTO 
GO
CREATE PROCEDURE CLDEDTO (@P_CNO as integer, @P_Currency as varchar(10))     
AS    
SELECT C.CNO, C.ID, C.CURRENCY, C.RefNo, Max(C.Currency_OC) as Currency_OC, Max(C.Rate) as Rate, Max(RCODE) as RCODE, MAX(TOR) AS TOR, sum(C.Amount)/Max(C.Rate) AS amount, sum(C.VAT)/Max(C.Rate) AS VAT, sum(C.TAX)/Max(C.Rate) AS TAX
FROM
(
	SELECT CLDED.CNO, CLDED.DCode, CLDED.ID, CLDED.Currency, Max(CLDED.Currency) as Currency_OC, Max(cast(1 as Float)) as Rate, MAX(Case When CLDED.RefNo='' Then Claim.RefNo else CLDED.RefNo end) AS REFNO, Max(CLDED.AMOUNT) AS AMOUNT, Max(CLDED.VAT) AS VAT, Max(CLDED.TAX) AS TAX, Max(RCOVER.CODE) as RCode, MAX(RCALC.TOR) AS TOR
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



go


insert into PatchVersioning
select '1092 Update Script - CLAIM (LN)',GETDATE()
go
	

Declare @PrevScript varchar(100)
Declare @CurrScript varchar(100)

Select @PrevScript=''
Select @CurrSCript='1051 Update Script - CLAIM (LN)'


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