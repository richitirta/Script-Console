IF EXISTS ( SELECT * FROM   sysobjects WHERE  id = object_id(N'CLCostTo') and OBJECTPROPERTY(id, N'IsProcedure') = 1 )
BEGIN
DROP PROCEDURE CLCostTo 
end
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
end
GO
CREATE PROCEDURE CLItemLossTo (@P_CNO as integer, @P_Currency as varchar(255))       
AS
SELECT CNO, PAYMENT, CURRENCY, REFNO, SUM(CLAIM) AS CLAIM, SUM(TAX) AS TAX, SUM(DEDUCTIBLE) AS DEDUCTIBLE
FROM
(
	SELECT CLLOSS.CNO, CLLOSS.INO, CLLOSS.NOC, CLLOSS.Payment, CLLOSS.CURRENCY, CLLOSS.RefNo,  
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
	From CLLOSS, CLAIM, RCOVER, ICALC, ACCEPTANCE, COVER, COL    
	WHERE CLAIM.CNO=@P_CNO AND CLLOSS.CURRENCY=@P_CURRENCY AND CLAIM.CNO=CLLOSS.CNO 
	AND ACCEPTANCE.ANO=CLAIM.ANO AND COVER.CNO=ACCEPTANCE.CNO AND RCOVER.ANO=ACCEPTANCE.ANO            
	AND (RCover.RetroActiveF=1 or (RCOVER.SDATE<=CLAIM.LOSSDATE AND ACCEPTANCE.ExclusiveF=1) or ((RCOVER.SDATE<CLAIM.LOSSDATE or (RCOVER.SDATE=CLAIM.LOSSDATE AND ACCEPTANCE.STIME<=Claim.LossTime)) AND ACCEPTANCE.ExclusiveF=0))           
	AND ((dbo.fn_Get_ExtPeriodDate(ACCEPTANCE.ExtPeriod, ACCEPTANCE.ExtPeriodInDaysF, RCOVER.EDATE)>CLAIM.LOSSDATE AND ACCEPTANCE.ExclusiveF=1) or ((dbo.fn_Get_ExtPeriodDate(ACCEPTANCE.ExtPeriod, ACCEPTANCE.ExtPeriodInDaysF, RCOVER.EDATE)>CLAIM.LOSSDATE or (dbo.fn_Get_ExtPeriodDate(ACCEPTANCE.ExtPeriod, ACCEPTANCE.ExtPeriodInDaysF, RCOVER.EDATE)=CLAIM.LOSSDATE AND ACCEPTANCE.ETIME>Claim.LossTime)) AND ACCEPTANCE.ExclusiveF=0))          
	AND ICALC.ANO=RCOVER.ANO AND ICALC.CODE=RCOVER.CODE AND ICALC.SDATE=RCOVER.SDATE     
	AND ICALC.INO=CLLOSS.INO    
	AND COL.COL=CLAIM.COL AND COL.TOR=ICALC.TOR    
	Group By CLLOSS.CNO, CLLOSS.INO, CLLOSS.NOC, CLLOSS.Payment, CLLOSS.CURRENCY, CLLOSS.RefNo
) CLLOSS
Group BY CNO, PAYMENT, CURRENCY, REFNO

GO
IF EXISTS ( SELECT * FROM   sysobjects WHERE  id = object_id(N'CLSalvageTo') and OBJECTPROPERTY(id, N'IsProcedure') = 1 )
BEGIN
DROP PROCEDURE CLSalvageTo 
end
GO
CREATE PROCEDURE CLSalvageTo (@P_CNO as integer, @P_Currency as varchar(255))     
AS    
SELECT cno, id, currency, CSType, sum(clSAL.GrossAmount) as GrossAmount, sum(clsal.amount) AS amount, sum(clsal.TAX) as TAX, sum(clsal.NetAmount) as NetAmount
FROM clsal    
WHERE cno=@p_cno and currency=@p_currency and Status='P'  
GROUP BY cno, id, currency, CSType 


GO
if exists (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'CCALC01a') AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) )
BEGIN
DROP FUNCTION CCALC01a
end
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
end
GO
CREATE FUNCTION CCALC02a(@P_CNO as integer) 
RETURNS Table 
AS RETURN ( 
 
Select LCalc.Currency, LCalc.Loss,  LCalc.Indemnity as Claim, LCalc.EDEDUCTIBLE, LCalc.Deductible, LCalc.ESalvage, LCalc.Salvage, 0 as COST, 0 as RCOST, 0 as ECost, 0 as ERCost, 0 as TCOST, 0 as ETCOST, 0 as ESUBROGATION, 0 AS SUBROGATION 
From LCalc 
Where LCalc.CNO=@P_CNO 
 
Union All 
 
SELECT CLDED.CURRENCY, 0 AS LOSS, 0 AS CLAIM, 0 AS EDEDUCTIBLE, 0 AS DEDUCTIBLE, 0 as ESALVAGE, 0 AS SALVAGE,0 as COST, 0 as RCOST, 0 as ECost, 0 as ERCost, 0 AS TCOST, 0 as ETCOST, 0 as ESUBROGATION,0 AS SUBROGATION 
From CLFACDED CLDED 
WHERE CLDED.CNO=@P_CNO And (CLDED.AMOUNT<>0) 
 
Union All 
 
SELECT CLCOST.CURRENCY, 0 AS LOSS, 0 AS CLAIM, 0 AS EDEDUCTIBLE, 0 AS DEDUCTIBLE, 0 as ESALVAGE, 0 AS SALVAGE, 
case When ContributionF=1 then CLCOST.Amount else 0 end as COST, 
Case When ContributionF=0 and CessionF=1 then CLCOST.Amount else 0 end as RCOST, 
case When ContributionF=1 then CLCOST.EstAmount else 0 end as ECOST, 
Case When ContributionF=0 and CessionF=1 then CLCost.EstAmount else 0 end as ERCOST, 
CLCOST.AMOUNT as TCOST, 
CLCOST.ESTAMOUNT AS ETCOST, 0 as ESUBROGATION, 0 as SUBROGATION 
From CLCOST 
WHERE CLCOST.CNO=@P_CNO AND CLCOST.STATUS='P' 
 
Union All 
 
SELECT CLSUB.CURRENCY, 0 AS LOSS, 0 AS CLAIM, 0 AS EDEDUCTIBLE, 0 AS DEDUCTIBLE, 0 as ESALVAGE, 0 AS SALVAGE,0 AS COST, 0 as RCOST, 0 as ECost, 0 as ERCost, 0 as TCOST, 0 as ETCOST, CLSUB.EAMOUNT as ESUBROGATION, CLSUB.AMOUNT as SUBROGATION 
From CLSUB 
WHERE CLSUB.CNO=@P_CNO AND CLSUB.STATUS='P' 
) 
 

GO
IF EXISTS ( SELECT * FROM   sysobjects WHERE  id = object_id(N'QApproval_Claim') and OBJECTPROPERTY(id, N'IsProcedure') = 1 )
BEGIN
DROP procedure QApproval_Claim
end
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
end
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
end
GO
CREATE PROCEDURE CLDEDTO (@P_CNO as integer, @P_Currency as varchar(10))     
AS    
SELECT C.CNO, C.ID, C.CURRENCY, C.RefNo, sum(C.Amount) AS amount
FROM CLDED C INNER JOIN CLAIM ON (CLAIM.CNO=C.CNO) INNER JOIN PROFILE P ON (P.ID=(CASE WHEN C.ID='' THEN CLAIM.Payment ELSE C.ID END))
WHERE C.CNO=@P_CNO AND C.CURRENCY=@P_CURRENCY
GROUP BY C.CNO, C.ID, C.CURRENCY, C.RefNo


GO


  insert into PatchVersioning
select '54.25 Update Script - CLAIM (DN)',GETDATE()
go

Declare @PrevScript varchar(100)
Declare @CurrScript varchar(100)

Select @PrevScript='54.24 Update Script - ARBucket (Add Rev #1)'
Select @CurrSCript='54.25 Update Script - CLAIM (DN)'


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





