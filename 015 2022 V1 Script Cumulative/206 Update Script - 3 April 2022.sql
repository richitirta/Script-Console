IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'CessionF' AND Object_ID = Object_ID(N'CLSub'))
BEGIN
ALTER TABLE dbo.CLSub ADD
	CessionF bit NULL

DECLARE @v sql_variant 
SET @v = N'Reinsurance Cession Flag (Only If ContributionF=0)'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'CLSub', N'COLUMN', N'CessionF'
end
GO


IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'RSubrogation' AND Object_ID = Object_ID(N'CCALC'))
BEGIN
ALTER TABLE dbo.CCALC ADD
	RSubrogation float(53) NULL
DECLARE @v sql_variant 
SET @v = N'Amount Subrogation Ceded To Reinsurance'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'CCALC', N'COLUMN', N'RSubrogation'
end
GO
IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'ERSubrogation' AND Object_ID = Object_ID(N'CCALC'))
BEGIN
ALTER TABLE dbo.CCALC ADD
	ERSubrogation float(53) NULL
DECLARE @v sql_variant 
SET @v = N'Estimate Amount Subrogation Ceded To Reinsurance'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'CCALC', N'COLUMN', N'ERSubrogation'
end
GO


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
case When ContributionF=1 then CLSub.Amount else 0 end as SUBROGATION, 
Case When ContributionF=0 and CessionF=1 then CLSub.Amount else 0 end as RSUBROGATION, 
case When ContributionF=1 then CLSub.EAmount else 0 end as ESUBROGATION, 
Case When ContributionF=0 and CessionF=1 then CLSub.EAmount else 0 end as ERSUBROGATION, 
CLSUB.EAMOUNT as ETSUBROGATION, 
CLSUB.AMOUNT as TSUBROGATION
From CLSUB 
WHERE CLSUB.CNO=@P_CNO AND CLSUB.STATUS='P'

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
      SUM(SALVAGE) AS SALVAGE,
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
	  SUM(ETSUBROGATION) As ETSUBROGATION
FROM CCALC02A(@P_CNO)
GROUP BY CURRENCY

GO

DROP PROCEDURE CLView06a 
GO
CREATE PROCEDURE CLView06a (@P_CNO as integer)
AS
SELECT CLAIM.CLAIMNO, CLAIM.ANO, CLAIM.CNO, CLAIM.LOSSDATE, CLAIM.CTYPE,
CCALC.RATE, 
CCALC.SHARE AS PCTSHARE,
CCALC.LOSS AS ESTIMATE,
CCALC.CLAIM AS OURSHARE,
CCALC.EDEDUCTIBLE AS EDEDUCTIBLE,
CCALC.DEDUCTIBLE AS DEDUCTIBLE,
CCALC.COST,
CCALC.RCOST AS RCOST,
CCALC.ECOST,
CCALC.ERCOST AS ERCOST,
CCALC.SALVAGE AS SALVAGE,
CCALC.SUBROGATION As SUBROGATION,
CCALC.ESUBROGATION As ESUBROGATION,
COALESCE(ISOURCE.LIMIT,0) AS LIMIT,
COALESCE(ISOURCE.EXCESS,0) AS EXCESS,
PCCALC.CLAIM as PrevOURSHARE,
PCCALC.DEDUCTIBLE as PrevDEDUCTIBLE,
PCCALC.COST as PrevCost,
PCCALC.SALVAGE AS PrevSALVAGE,
PCCALC.SUBROGATION As PrevSUBROGATION,
TOC.CashCallOnPartialPaymentF, TOC.CashCallOnEstimateF, TOC.CashCallOnGrossF
From CCALC 
INNER JOIN CLAIM ON (CLAIM.CNO=CCALC.CNO) 
INNER JOIN ACCEPTANCE ON (ACCEPTANCE.ANO=CLAIM.ANO) 
INNER JOIN TOC on (TOC.TOC=CLAIM.TOC)
LEFT JOIN ISOURCE ON (ISOURCE.CNO=ACCEPTANCE.CNO)
Left Join CCalc pCCalc on (pCCalc.CNO=Claim.pCNO and pCCalc.Currency=CCalc.Currency and Claim.CSeqNo>0)
WHERE CCALC.CNO=@P_CNO

go







 insert into PatchVersioning
select '206 Update Script - 3 April 2022',GETDATE()
go


Declare @PrevScript varchar(100)
Declare @CurrScript varchar(100)

Select @PrevScript=''
Select @CurrSCript='206 Update Script - 3 April 2022'


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



