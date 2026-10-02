SET QUOTED_IDENTIFIER ON
SET ARITHABORT ON
SET NUMERIC_ROUNDABORT OFF
SET CONCAT_NULL_YIELDS_NULL ON
SET ANSI_NULLS ON
SET ANSI_PADDING ON
SET ANSI_WARNINGS ON

IF EXISTS ( SELECT * FROM   sysobjects WHERE  id = object_id(N'CLView06a') and OBJECTPROPERTY(id, N'IsProcedure') = 1 )
BEGIN DROP PROCEDURE CLView06a  END 
GO

CREATE PROCEDURE CLView06a (@P_CNO as integer)
AS
SELECT CLAIM.CLAIMNO, CLAIM.ANO, CLAIM.CNO, CLAIM.LOSSDATE, CLAIM.CTYPE,
CCalc.Currency,
CCALC.RATE, 
CCALC.SHARE AS PCTSHARE,
CCALC.LOSS AS ESTIMATE,
CCALC.CLAIM AS OURSHARE,
CCALC.EDEDUCTIBLE,
CCALC.DEDUCTIBLE,

CCALC.COST,
CCALC.RCOST,
CCALC.ECOST,
CCALC.ERCOST,

CCALC.SALVAGE,
CCALC.RSALVAGE,
CCALC.ESALVAGE,
CCALC.ERSALVAGE,

CCALC.SUBROGATION,
CCALC.RSUBROGATION,
CCALC.ESUBROGATION,
CCALC.ERSUBROGATION,
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

GO

insert into PatchVersioning
select '1343 Update Script - CLVIEW06A',GETDATE()
go	
  

Declare @PrevScript varchar(100)
Declare @CurrScript varchar(100)

Select @PrevScript=''
Select @CurrSCript='1343 Update Script - CLVIEW06A'


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


