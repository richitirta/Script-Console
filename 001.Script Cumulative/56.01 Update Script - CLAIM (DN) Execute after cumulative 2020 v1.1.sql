IF EXISTS ( SELECT * FROM   sysobjects WHERE  id = object_id(N'QClaim_To_Adm') and OBJECTPROPERTY(id, N'IsProcedure') = 1 )
BEGIN
DROP Procedure QClaim_To_Adm
end
GO
CREATE Procedure QClaim_To_Adm(@P_CNO as int)                              
as   
Select C1.ID, C1.TOC, C1.Type, C1.Currency, C1.RefNo, 
Max(C1.CodeExt) as CodeExt,
Max(C1.Date) as Date,
Max(C1.BillDate) as BillDate,
Max(C1.DocNo) as DocNo,
Max(C1.Remarks) as Remarks, 
Cast(Max(cast(coalesce(PCLCOST.EXGRATIAF,coalesce(CLCOST.EXGRATIAF,0)) as Integer)) as Bit) as EXGRATIAF,
cast(Max(cast(C1.CashLossF as int)) as Bit) as CashLossF,
sum(Case When C1.Code='P' then C1.Amount else 0 end) as Amount_1,                              
sum(Case When C1.Code='A' then C1.Amount else 0 end) as Amount_6,                              
sum(Case When C1.Code='E' then C1.Amount else 0 end) as Amount_7,                              
sum(Case When C1.Code='S' then C1.Amount else 0 end) as Amount_8,                              
sum(Case When C1.Code='L' then C1.Amount else 0 end) as Amount_9,                              
sum(Case When C1.Code='R' then C1.Amount else 0 end) as Amount_10,                              
sum(Case When C1.Code='V' then C1.Amount else 0 end) as Amount_13,                              
sum(Case When C1.Code='T' then C1.Amount else 0 end) as Amount_14,                              
sum(Case When C1.Code='F' then C1.Amount else 0 end) as Amount_15,                              
sum(Case When C1.Code='D' then C1.Amount else 0 end) as Amount_16,                              
sum(Case When C1.Code='I' then C1.Amount else 0 end) as Amount_17
from ClaAss C1
INNER JOIN CLAIM C2 on (C2.CNO=C1.CNO)
LEFT JOIN CLAIM pC2 on (pC2.CNO=C2.PCNO)
Left Join (
	Select CLCOST.CNO, CLCOST.ID, CLCOST.Currency, CLCOST.CCTYPE as RefNo, cast(Max(cast(CLCOST.ExGratiaF as integer)) as Bit) as ExGratiaF 
	from CLAIM, CLCOST 
	WHERE CLAIM.CNO=@P_CNO AND CLCOST.CNO=CLAIM.CNO
	Group By CLCOST.CNO, CLCOST.ID, CLCOST.Currency, CLCOST.CCTYPE
) CLCOST ON (C1.CAMOUNT<>0 AND CLCOST.CNO=C2.CNO AND CLCOST.ID=C1.ID AND CASE WHEN CLCOST.REFNO<>'' THEN CLCOST.REFNO ELSE C2.REFNO END=C1.REFNO AND CLCOST.CURRENCY=C1.CURRENCY)
Left Join (
	Select CLCOST.CNO, CLCOST.ID, CLCOST.Currency, CLCOST.CCTYPE as RefNo, cast(Max(cast(CLCOST.ExGratiaF as integer)) as Bit) as ExGratiaF 
	from CLAIM, CLCOST 
	WHERE CLAIM.CNO=@P_CNO AND CLCOST.CNO=CLAIM.PCNO
	Group By CLCOST.CNO, CLCOST.ID, CLCOST.Currency, CLCOST.CCTYPE
) PCLCOST ON (C1.CAMOUNT=0 AND PCLCOST.CNO=C2.PCNO AND PCLCOST.ID=C1.ID AND CASE WHEN PCLCOST.REFNO<>'' THEN PCLCOST.REFNO ELSE PC2.REFNO END=C1.REFNO AND PCLCOST.CURRENCY=C1.CURRENCY)
Where C1.CNO=@P_CNO
Group by C1.ID, C1.TOC, C1.Type, C1.Currency, C1.RefNo



GO



DROP PROCEDURE CLCostTo 
GO
CREATE PROCEDURE CLCostTo (@P_CNO as integer, @P_Currency as varchar(10)) 
AS 
SELECT C2.cno, C2.id, coalesce(I.ID, C2.ID) as LeaderID, C2.currency, C2.CCtype as RefNo, C2.CCType,
Case When C1.ISType='I' or C2.CCOLLECTIONF=1 then cast(0 as Bit) else C2.ContributionF end as ContributionF, C2.CCollectionF, sum(C2.amount) AS amount, sum(C2.tax) as tax 
From CLAIM C1 
INNER JOIN CLCOST C2 ON (C1.CNO=C2.CNO) 
INNER JOIN ACCEPTANCE A ON (A.ANO=C1.ANO) 
LEFT JOIN ISOURCE I ON (I.CNO=A.CNO) 
WHERE C2.CNO=@p_cno and C2.currency=@p_currency and C2.Status='P' 
GROUP BY C2.cno, C2.id, I.ID, C2.currency, C2.CCtype, Case When C1.ISType='I' or C2.CCOLLECTIONF=1 then cast(0 as Bit) else C2.ContributionF end, C2.CCollectionF 

GO
IF EXISTS ( SELECT * FROM   sysobjects WHERE  id = object_id(N'CLItemLossTo') and OBJECTPROPERTY(id, N'IsProcedure') = 1 )
BEGIN
DROP PROCEDURE CLItemLossTo 
END
GO
CREATE PROCEDURE CLItemLossTo (@P_CNO as integer, @P_Currency as varchar(255))       
AS
SELECT CNO, PAYMENT, CURRENCY, REFNO, CODEEXT, MAX(RCODE) AS RCODE, MAX(TOR) AS TOR, SUM(CLAIM) AS CLAIM, SUM(TAX) AS TAX, SUM(DEDUCTIBLE) AS DEDUCTIBLE
FROM
(
	SELECT CLLOSS.CNO, CLLOSS.INO, CLLOSS.NOC, CLLOSS.Payment, CLLOSS.CURRENCY, CLLOSS.RefNo, MAX(NOCTAB.CODEEXT) AS CODEEXT, Max(RCOVER.CODE) AS RCODE, MAX(ICALC.TOR) AS TOR,
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
	 ) +
	 Max(    
	  CASE            
	   WHEN CLLOSS.STATUS<>'P' THEN 0
	   WHEN CLLOSS.VAR<=CLLOSS.DECLARED THEN CLLOSS.DEPRECIATION            
	   ELSE (CLLOSS.DECLARED/CLLOSS.VAR) * CLLOSS.DEPRECIATION
	  END
	 ) 
	 as DEDUCTIBLE
	From CLLOSS, CLAIM, RCOVER, ICALC, ACCEPTANCE, COVER, COL, NOCTAB    
	WHERE CLLOSS.CNO=@P_CNO AND CLLOSS.CURRENCY=@P_CURRENCY AND CLAIM.CNO=CLLOSS.CNO 
	AND ACCEPTANCE.ANO=CLAIM.ANO AND COVER.CNO=ACCEPTANCE.CNO AND RCOVER.ANO=ACCEPTANCE.ANO            
	AND (RCover.RetroActiveF=1 or (RCOVER.SDATE<=CLAIM.LOSSDATE AND ACCEPTANCE.ExclusiveF=1) or ((RCOVER.SDATE<CLAIM.LOSSDATE or (RCOVER.SDATE=CLAIM.LOSSDATE AND ACCEPTANCE.STIME<=Claim.LossTime)) AND ACCEPTANCE.ExclusiveF=0))           
	AND ((dbo.fn_Get_ExtPeriodDate(ACCEPTANCE.ExtPeriod, ACCEPTANCE.ExtPeriodInDaysF, RCOVER.EDATE)>CLAIM.LOSSDATE AND ACCEPTANCE.ExclusiveF=1) or ((dbo.fn_Get_ExtPeriodDate(ACCEPTANCE.ExtPeriod, ACCEPTANCE.ExtPeriodInDaysF, RCOVER.EDATE)>CLAIM.LOSSDATE or (dbo.fn_Get_ExtPeriodDate(ACCEPTANCE.ExtPeriod, ACCEPTANCE.ExtPeriodInDaysF, RCOVER.EDATE)=CLAIM.LOSSDATE AND ACCEPTANCE.ETIME>Claim.LossTime)) AND ACCEPTANCE.ExclusiveF=0))          
	AND ICALC.ANO=RCOVER.ANO AND ICALC.CODE=RCOVER.CODE AND ICALC.SDATE=RCOVER.SDATE     
	AND ICALC.INO=CLLOSS.INO    
	AND COL.COL=CLAIM.COL AND COL.TOR=ICALC.TOR    
	AND NOCTAB.NOC=CLLOSS.NOC
	Group By CLLOSS.CNO, CLLOSS.INO, CLLOSS.NOC, CLLOSS.Payment, CLLOSS.CURRENCY, CLLOSS.RefNo
) CLLOSS
Group BY CNO, PAYMENT, CURRENCY, REFNO, CODEEXT
GO
IF EXISTS ( SELECT * FROM   sysobjects WHERE  id = object_id(N'CLSalvageTo') and OBJECTPROPERTY(id, N'IsProcedure') = 1 )
BEGIN
DROP PROCEDURE CLSalvageTo 
END
GO
CREATE PROCEDURE CLSalvageTo (@P_CNO as integer, @P_Currency as varchar(10))     
AS    

SELECT cno, id, currency, CSType, Max(RCODE) as RCODE, MAX(TOR) AS TOR, sum(clSAL.GrossAmount) as GrossAmount, sum(clsal.amount) AS amount, sum(clsal.TAX) as TAX, sum(clsal.NetAmount) as NetAmount
FROM
(
SELECT CLSAL.CNO, CLSAL.INO, CLSAL.ID, CLSAL.Currency, Max(CLSal.CSType) as CSType, Max(RCOVER.CODE) as RCode, Max(ICALC.TOR) AS TOR, Max(CLSAL.GROSSAMOUNT) AS GROSSAMOUNT, Max(CLSAL.AMOUNT) AS AMOUNT, Max(CLSAL.TAX) AS TAX, Max(CLSAL.NETAMOUNT) AS NETAMOUNT
From CLSAL, CLAIM, RCOVER, ICALC, ACCEPTANCE, Cover, COL            
WHERE CLSAL.CNO=@P_CNO AND CLSAL.CURRENCY=@P_CURRENCY AND CLAIM.CNO=CLSAL.CNO AND CLSAL.Status='P'        
AND ACCEPTANCE.ANO=CLAIM.ANO AND COVER.CNO=ACCEPTANCE.CNO AND RCOVER.ANO=ACCEPTANCE.ANO            
AND (RCover.RetroActiveF=1 or (RCOVER.SDATE<=CLAIM.LOSSDATE AND ACCEPTANCE.ExclusiveF=1) or ((RCOVER.SDATE<CLAIM.LOSSDATE or (RCOVER.SDATE=CLAIM.LOSSDATE AND ACCEPTANCE.STIME<=Claim.LossTime)) AND ACCEPTANCE.ExclusiveF=0))           
AND ((dbo.fn_Get_ExtPeriodDate(ACCEPTANCE.ExtPeriod, ACCEPTANCE.ExtPeriodInDaysF, RCOVER.EDATE)>CLAIM.LOSSDATE AND ACCEPTANCE.ExclusiveF=1) or ((dbo.fn_Get_ExtPeriodDate(ACCEPTANCE.ExtPeriod, ACCEPTANCE.ExtPeriodInDaysF, RCOVER.EDATE)>CLAIM.LOSSDATE or (dbo.fn_Get_ExtPeriodDate(ACCEPTANCE.ExtPeriod, ACCEPTANCE.ExtPeriodInDaysF, RCOVER.EDATE)=CLAIM.LOSSDATE AND ACCEPTANCE.ETIME>Claim.LossTime)) AND ACCEPTANCE.ExclusiveF=0))          AND ICALC.ANO=RCOVER.ANO AND ICALC.CODE=RCOVER.CODE AND ICALC.SDATE=RCOVER.SDATE     
AND ICALC.INO=CLSAL.INO    
AND COL.COL=CLAIM.COL AND COL.TOR=ICALC.TOR    
Group By CLSAL.CNO, CLSAL.INO, CLSAL.ID, CLSAL.Currency    
) CLSAL
GROUP BY cno, id, currency, CSType 



GO
if exists (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'CCALC01a') AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) )
BEGIN
DROP FUNCTION CCALC01a
END
GO
CREATE FUNCTION CCALC01a(@P_CNO as integer)            
RETURNS Table            
AS RETURN (            
SELECT CLLOSS.CURRENCY, Max(RCOVER.CODE) as Code, max(ICALC.TOR) as TOR,            
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
 ) +
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
 ) +
 Max(    
  CASE            
   WHEN CLLOSS.STATUS<>'P' THEN 0
   WHEN CLLOSS.VAR<=CLLOSS.DECLARED THEN CLLOSS.DEPRECIATION            
   ELSE (CLLOSS.DECLARED/CLLOSS.VAR) * CLLOSS.DEPRECIATION
  END
 ) 
 as DEDUCTIBLE,            
 0 as ESALVAGE, 0 AS SALVAGE
From CLLOSS, CLAIM, RCOVER, ICALC, ACCEPTANCE, cover, COL    
WHERE CLAIM.CNO=@P_CNO AND CLAIM.CNO=CLLOSS.CNO 
AND ACCEPTANCE.ANO=CLAIM.ANO AND COVER.CNO=ACCEPTANCE.CNO AND RCOVER.ANO=ACCEPTANCE.ANO            
AND (RCover.RetroActiveF=1 or (RCOVER.SDATE<=CLAIM.LOSSDATE AND ACCEPTANCE.ExclusiveF=1) or ((RCOVER.SDATE<CLAIM.LOSSDATE or (RCOVER.SDATE=CLAIM.LOSSDATE AND ACCEPTANCE.STIME<=Claim.LossTime)) AND ACCEPTANCE.ExclusiveF=0))           
AND ((dbo.fn_Get_ExtPeriodDate(ACCEPTANCE.ExtPeriod, ACCEPTANCE.ExtPeriodInDaysF, RCOVER.EDATE)>CLAIM.LOSSDATE AND ACCEPTANCE.ExclusiveF=1) or ((dbo.fn_Get_ExtPeriodDate(ACCEPTANCE.ExtPeriod, ACCEPTANCE.ExtPeriodInDaysF, RCOVER.EDATE)>CLAIM.LOSSDATE or (dbo.fn_Get_ExtPeriodDate(ACCEPTANCE.ExtPeriod, ACCEPTANCE.ExtPeriodInDaysF, RCOVER.EDATE)=CLAIM.LOSSDATE AND ACCEPTANCE.ETIME>Claim.LossTime)) AND ACCEPTANCE.ExclusiveF=0))          
AND ICALC.ANO=RCOVER.ANO AND ICALC.CODE=RCOVER.CODE AND ICALC.SDATE=RCOVER.SDATE     
AND ICALC.INO=CLLOSS.INO    
AND COL.COL=CLAIM.COL AND COL.TOR=ICALC.TOR    
Group By CLLOSS.CNO, CLLOSS.INO, CLLOSS.PAYMENT, CLLOSS.NOC, CLLOSS.Currency, CLLOSS.RefNo  
    
Union All            
                      
SELECT CLDED.CURRENCY, Max(RCOVER.CODE) as Code, max(RCALC.TOR) as TOR, 0 AS LOSS, 0 AS INDEMNITY, Max(CLDED.ESTAMOUNT) AS EDEDUCTIBLE, Max(CLDED.AMOUNT) AS DEDUCTIBLE, 0 as ESALVAGE, 0 AS SALVAGE            
From CLDED, CLAIM, RCOVER, RCALC, ACCEPTANCE, cover, COL, DedTAB    
WHERE CLAIM.CNO=@P_CNO AND CLAIM.CNO=CLDED.CNO AND (CLDED.ESTAMOUNT<>0 or CLDED.AMOUNT<>0)            
AND ACCEPTANCE.ANO=CLAIM.ANO AND COVER.CNO=ACCEPTANCE.CNO AND RCOVER.ANO=ACCEPTANCE.ANO            
AND (RCover.RetroActiveF=1 or (RCOVER.SDATE<=CLAIM.LOSSDATE AND ACCEPTANCE.ExclusiveF=1) or ((RCOVER.SDATE<CLAIM.LOSSDATE or (RCOVER.SDATE=CLAIM.LOSSDATE AND ACCEPTANCE.STIME<=Claim.LossTime)) AND ACCEPTANCE.ExclusiveF=0))           
AND ((dbo.fn_Get_ExtPeriodDate(ACCEPTANCE.ExtPeriod, ACCEPTANCE.ExtPeriodInDaysF, RCOVER.EDATE)>CLAIM.LOSSDATE AND ACCEPTANCE.ExclusiveF=1) or ((dbo.fn_Get_ExtPeriodDate(ACCEPTANCE.ExtPeriod, ACCEPTANCE.ExtPeriodInDaysF, RCOVER.EDATE)>CLAIM.LOSSDATE or (dbo.fn_Get_ExtPeriodDate(ACCEPTANCE.ExtPeriod, ACCEPTANCE.ExtPeriodInDaysF, RCOVER.EDATE)=CLAIM.LOSSDATE AND ACCEPTANCE.ETIME>Claim.LossTime)) AND ACCEPTANCE.ExclusiveF=0))     
AND RCALC.ANO=RCOVER.ANO AND RCALC.CODE=RCOVER.CODE AND RCALC.SDATE=RCOVER.SDATE     
AND COL.COL=CLAIM.COL AND COL.TOR=RCALC.TOR    
And DEDTAB.DCODE=CLDED.DCODE AND DEDTAB.TOR=COL.TOR    
Group by CLDED.CNO, CLDED.DCode, CLDED.ID, CLDED.Currency    
    
                      
Union All            
                      
SELECT CLSAL.CURRENCY, Max(RCOVER.CODE) as Code, Max(ICALC.TOR) as TOR, 0 AS LOSS, 0 AS INDEMNITY, 0 AS EDEDUCTIBLE, 0 AS DEDUCTIBLE, MAX(CLSAL.EAMOUNT) AS ESALVAGE, Max(CLSAL.AMOUNT) AS SALVAGE
From CLSAL, CLAIM, RCOVER, ICALC, ACCEPTANCE, Cover, COL            
WHERE CLAIM.CNO=@P_CNO AND CLAIM.CNO=CLSAL.CNO AND CLSAL.Status='P'        
AND ACCEPTANCE.ANO=CLAIM.ANO AND COVER.CNO=ACCEPTANCE.CNO AND RCOVER.ANO=ACCEPTANCE.ANO            
AND (RCover.RetroActiveF=1 or (RCOVER.SDATE<=CLAIM.LOSSDATE AND ACCEPTANCE.ExclusiveF=1) or ((RCOVER.SDATE<CLAIM.LOSSDATE or (RCOVER.SDATE=CLAIM.LOSSDATE AND ACCEPTANCE.STIME<=Claim.LossTime)) AND ACCEPTANCE.ExclusiveF=0))           
AND ((dbo.fn_Get_ExtPeriodDate(ACCEPTANCE.ExtPeriod, ACCEPTANCE.ExtPeriodInDaysF, RCOVER.EDATE)>CLAIM.LOSSDATE AND ACCEPTANCE.ExclusiveF=1) or ((dbo.fn_Get_ExtPeriodDate(ACCEPTANCE.ExtPeriod, ACCEPTANCE.ExtPeriodInDaysF, RCOVER.EDATE)>CLAIM.LOSSDATE or (dbo.fn_Get_ExtPeriodDate(ACCEPTANCE.ExtPeriod, ACCEPTANCE.ExtPeriodInDaysF, RCOVER.EDATE)=CLAIM.LOSSDATE AND ACCEPTANCE.ETIME>Claim.LossTime)) AND ACCEPTANCE.ExclusiveF=0))          AND ICALC.ANO=RCOVER.ANO AND ICALC.CODE=RCOVER.CODE AND ICALC.SDATE=RCOVER.SDATE     
AND ICALC.INO=CLSAL.INO    
AND COL.COL=CLAIM.COL AND COL.TOR=ICALC.TOR    
Group By CLSAL.CNO, CLSAL.INO, CLSAL.ID, CLSAL.Currency    
)            


GO
if exists (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'CCALC02a') AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) )
BEGIN
DROP FUNCTION CCALC02a
END
GO
CREATE FUNCTION CCALC02a(@P_CNO as integer) 
RETURNS Table 
AS RETURN ( 
 
Select LCalc.Currency, LCalc.Loss,  LCalc.Indemnity as Claim, LCalc.EDEDUCTIBLE, LCalc.Deductible, LCalc.ESalvage, LCalc.Salvage, 0 as COST, 0 as RCOST, 0 as ECost, 0 as ERCost, 0 as TCOST, 0 as ETCOST, 
0 as ESUBROGATION, 0 as SUBROGATION,
0 as ETSUBROGATION, 0 as TSUBROGATION 
From LCalc 
Where LCalc.CNO=@P_CNO 
 
Union All 
 
SELECT CLDED.CURRENCY, 0 AS LOSS, 0 AS CLAIM, 0 AS EDEDUCTIBLE, 0 AS DEDUCTIBLE, 0 as ESALVAGE, 0 AS SALVAGE,0 as COST, 0 as RCOST, 0 as ECost, 0 as ERCost, 0 AS TCOST, 0 as ETCOST, 
0 as ESUBROGATION, 0 as SUBROGATION,
0 as ETSUBROGATION, 0 as TSUBROGATION 
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
0 as ESUBROGATION, 0 as SUBROGATION,
0 as ETSUBROGATION, 0 as TSUBROGATION 
From CLCOST 
WHERE CLCOST.CNO=@P_CNO AND CLCOST.STATUS='P' 
 
Union All 
 
SELECT CLSUB.CURRENCY, 0 AS LOSS, 0 AS CLAIM, 0 AS EDEDUCTIBLE, 0 AS DEDUCTIBLE, 0 as ESALVAGE, 0 AS SALVAGE,0 AS COST, 0 as RCOST, 0 as ECost, 0 as ERCost, 0 as TCOST, 0 as ETCOST, 
case When ContributionF=1 then CLSUB.EAMOUNT else 0 end as ESUBROGATION, 
case When ContributionF=1 then CLSUB.AMOUNT else 0 end as SUBROGATION,
CLSUB.EAMOUNT as ETSUBROGATION, 
CLSUB.AMOUNT as TSUBROGATION
From CLSUB 
WHERE CLSUB.CNO=@P_CNO AND CLSUB.STATUS='P'

) 
 

GO
IF EXISTS ( SELECT * FROM   sysobjects WHERE  id = object_id(N'CCALC02') and OBJECTPROPERTY(id, N'IsProcedure') = 1 )
BEGIN
DROP PROCEDURE CCALC02 
END
GO
CREATE PROCEDURE CCALC02 (@P_CNO as integer)
AS
SELECT
      CURRENCY,
      SUM(LOSS) AS LOSS,
      SUM(CLAIM) AS CLAIM,
      SUM(EDEDUCTIBLE) AS EDEDUCTIBLE,
      SUM(DEDUCTIBLE) AS DEDUCTIBLE,
      SUM(SALVAGE) AS SALVAGE,
      SUM(COST) AS COST,
      SUM(RCOST) AS RCOST,
      SUM(ECOST) AS ECOST,
      SUM(ERCOST) AS ERCOST,
      SUM(TCOST) AS TCOST,
      SUM(ETCOST) AS ETCOST,
      SUM(SUBROGATION) As SUBROGATION,
	  SUM(ESUBROGATION) As ESUBROGATION,
      SUM(TSUBROGATION) As TSUBROGATION,
	  SUM(ETSUBROGATION) As ETSUBROGATION
FROM CCALC02A(@P_CNO)
GROUP BY CURRENCY


GO
IF EXISTS ( SELECT * FROM   sysobjects WHERE  id = object_id(N'QApproval_Claim') and OBJECTPROPERTY(id, N'IsProcedure') = 1 )
BEGIN
DROP procedure QApproval_Claim
END
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
Max((CCalc.Loss-CCalc.EDeductible-CCalc.Salvage-CCalc.Subrogation+CCalc.ECost)*CCalc.Share/100*CCalc.Rate) as GrossEstimate,   
Max((pCCalc.Loss-pCCalc.EDeductible-pCCalc.Salvage-pCCalc.Subrogation+pCCalc.ECost)*pCCalc.Share/100*pCCalc.Rate) as PrevGrossEstimate,   
  
sum(Case When Coalesce(Coinsurance.CCollectionF,1)=1 Then   
 0  
 else  
 (CCalc.Loss-CCalc.EDeductible-CCalc.Salvage-CCalc.Subrogation+CCalc.ECost)*CCalc.Share/100*(coalesce(Coinsurance.Share,0)/100)*CCalc.Rate  
End) as MemberEstimate,  

sum(Case When Coalesce(Coinsurance.CCollectionF,1)=1 Then   
 0  
 else  
 (pCCalc.Loss-pCCalc.EDeductible-pCCalc.Salvage-pCCalc.Subrogation+pCCalc.ECost)*pCCalc.Share/100*(coalesce(Coinsurance.Share,0)/100)*pCCalc.Rate  
End) as PrevMemberEstimate,  
  
Max((CCalc.Claim-CCalc.Deductible-CCalc.Salvage-CCalc.Subrogation+CCalc.Cost)*CCalc.Share/100*CCalc.Rate) as GrossAmount,  
Max((pCCalc.Claim-pCCalc.Deductible-pCCalc.Salvage-pCCalc.Subrogation+pCCalc.Cost)*pCCalc.Share/100*pCCalc.Rate) as PrevGrossAmount,  
  
sum(Case When Coalesce(Coinsurance.CCollectionF,1)=1 Then   
 0  
 else  
 (CCalc.Claim-CCalc.Deductible-CCalc.Salvage-CCalc.Subrogation+CCalc.Cost)*CCalc.Share/100*(coalesce(Coinsurance.Share,0)/100)*CCalc.Rate  
End) as MemberAmount,

sum(Case When Coalesce(Coinsurance.CCollectionF,1)=1 Then   
 0  
 else  
 (pCCalc.Claim-pCCalc.Deductible-pCCalc.Salvage-pCCalc.Subrogation+pCCalc.Cost)*CCalc.Share/100*(coalesce(Coinsurance.Share,0)/100)*pCCalc.Rate  
End) as PrevMemberAmount
  
From Claim  
inner join CCALC on (CCalc.CNO=Claim.CNO)  
inner join CARRHEADER on (CARRHEADER.CNO=Claim.CNO)  
inner join Acceptance on (Acceptance.ANO=Claim.ANO)  
Left Join Coinsurance on (Coinsurance.CNO=Acceptance.CNO and Claim.ISType='L')  
Left Join Claim pClaim on (pClaim.CNO=Claim.pCNO)
Left join CCalc pCCalc on (pCCalc.CNO=pClaim.CNO and pCCalc.Currency=CCalc.Currency)
WHERE Claim.CNO=@P_CNO   
Group By Claim.Branch, Claim.TOC, Claim.ISType, CCalc.Currency  
) Claim  
  
Group by Claim.Branch, Claim.TOC, Claim.ISType      

GO
IF EXISTS ( SELECT * FROM   sysobjects WHERE  id = object_id(N'CLAIM_PAID_BY_POLICY') and OBJECTPROPERTY(id, N'IsProcedure') = 1 )
BEGIN
DROP PROCEDURE CLAIM_PAID_BY_POLICY
END
GO
CREATE PROCEDURE CLAIM_PAID_BY_POLICY(@P_POLICYNO as varchar(20),@P_CERTIFICATENO as varchar(20))  
AS  
SELECT SUM(CLAASS.AMOUNT*NVOUCHER.RATE) AS CLAIM_PAID  
FROM CLAASS, ADMLINK, NVOUCHER, CLAIM, ACCEPTANCE
WHERE ACCEPTANCE.POLICYNO=@P_POLICYNO AND ACCEPTANCE.CERTIFICATENO=@P_CERTIFICATENO AND CLAIM.ANO=ACCEPTANCE.ANO 
AND CLAASS.CNO=CLAIM.CNO AND CLAASS.TYPE IN ('DI','IC','IR','OP','CF','JP') 
AND CLAASS.CODE NOT IN ('T','F','D') AND ADMLINK.ADMNO=CLAASS.ADMNO AND NVOUCHER.VOUCHER=ADMLINK.VOUCHER

GO

IF EXISTS ( SELECT * FROM   sysobjects WHERE  id = object_id(N'CLDEDTO') and OBJECTPROPERTY(id, N'IsProcedure') = 1 )
BEGIN
DROP PROCEDURE CLDEDTO 
END
GO
CREATE PROCEDURE CLDEDTO (@P_CNO as integer, @P_Currency as varchar(10))     
AS    
SELECT C.CNO, C.ID, C.CURRENCY, C.RefNo, Max(RCODE) as RCODE, MAX(TOR) AS TOR, sum(C.Amount) AS amount
FROM
(
SELECT CLDED.CNO, CLDED.DCode, CLDED.ID, CLDED.CURRENCY, MAX(CLDED.REFNO) AS REFNO, Max(CLDED.AMOUNT) AS AMOUNT, Max(RCOVER.CODE) as RCode, MAX(RCALC.TOR) AS TOR
From CLDED, CLAIM, RCOVER, RCALC, ACCEPTANCE, cover, COL, DedTAB    
WHERE CLDED.CNO=@P_CNO AND CLDED.CURRENCY=@P_CUrrency AND CLAIM.CNO=CLDED.CNO AND (CLDED.ESTAMOUNT<>0 or CLDED.AMOUNT<>0)            
AND ACCEPTANCE.ANO=CLAIM.ANO AND COVER.CNO=ACCEPTANCE.CNO AND RCOVER.ANO=ACCEPTANCE.ANO            
AND (RCover.RetroActiveF=1 or (RCOVER.SDATE<=CLAIM.LOSSDATE AND ACCEPTANCE.ExclusiveF=1) or ((RCOVER.SDATE<CLAIM.LOSSDATE or (RCOVER.SDATE=CLAIM.LOSSDATE AND ACCEPTANCE.STIME<=Claim.LossTime)) AND ACCEPTANCE.ExclusiveF=0))           
AND ((dbo.fn_Get_ExtPeriodDate(ACCEPTANCE.ExtPeriod, ACCEPTANCE.ExtPeriodInDaysF, RCOVER.EDATE)>CLAIM.LOSSDATE AND ACCEPTANCE.ExclusiveF=1) or ((dbo.fn_Get_ExtPeriodDate(ACCEPTANCE.ExtPeriod, ACCEPTANCE.ExtPeriodInDaysF, RCOVER.EDATE)>CLAIM.LOSSDATE or (dbo.fn_Get_ExtPeriodDate(ACCEPTANCE.ExtPeriod, ACCEPTANCE.ExtPeriodInDaysF, RCOVER.EDATE)=CLAIM.LOSSDATE AND ACCEPTANCE.ETIME>Claim.LossTime)) AND ACCEPTANCE.ExclusiveF=0))     
AND RCALC.ANO=RCOVER.ANO AND RCALC.CODE=RCOVER.CODE AND RCALC.SDATE=RCOVER.SDATE     
AND COL.COL=CLAIM.COL AND COL.TOR=RCALC.TOR    
And DEDTAB.DCODE=CLDED.DCODE AND DEDTAB.TOR=COL.TOR    
Group by CLDED.CNO, CLDED.DCode, CLDED.ID, CLDED.Currency    
) C
GROUP BY C.CNO, C.ID, C.CURRENCY, C.RefNo

GO


insert into PatchVersioning
select '56.1 Update Script - CLAIM (DN) Execute after cumulative 2020 v1.1',GETDATE()
go

Declare @PrevScript varchar(100)
Declare @CurrScript varchar(100)

Select @PrevScript='56 Script Komulatif Konsol 2020 V.1.1'
Select @CurrSCript='56.1 Update Script - CLAIM (DN) Execute after cumulative 2020 v1.1'


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
