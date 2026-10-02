/* To prevent any potential data loss issues, you should review this script in detail before running it outside the context of the database designer.*/
BEGIN TRANSACTION
SET QUOTED_IDENTIFIER ON
SET ARITHABORT ON
SET NUMERIC_ROUNDABORT OFF
SET CONCAT_NULL_YIELDS_NULL ON
SET ANSI_NULLS ON
SET ANSI_PADDING ON
SET ANSI_WARNINGS ON
COMMIT

IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'ClaimNotFullCoverF' AND Object_ID = Object_ID(N'Coinsurance'))

BEGIN
ALTER TABLE dbo.Coinsurance ADD
	ClaimNotFullCoverF bit NULL
END
GO
DECLARE @v sql_variant 
SET @v = N'Claim Not Full Cover (0 : No, 1 : No refer to Coinsurance Det for Risk Coverage)'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'Coinsurance', N'COLUMN', N'ClaimNotFullCoverF'
GO


/* To prevent any potential data loss issues, you should review this script in detail before running it outside the context of the database designer.*/
BEGIN TRANSACTION
SET QUOTED_IDENTIFIER ON
SET ARITHABORT ON
SET NUMERIC_ROUNDABORT OFF
SET CONCAT_NULL_YIELDS_NULL ON
SET ANSI_NULLS ON
SET ANSI_PADDING ON
SET ANSI_WARNINGS ON
COMMIT


IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'Share' AND Object_ID = Object_ID(N'CoinsuranceDet'))

BEGIN
ALTER TABLE dbo.CoinsuranceDet ADD
	Share float(53) NULL

END
GO
DECLARE @v sql_variant 
SET @v = N'Claim Share if Coinsurance Claim Full Cover is No'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'CoinsuranceDet', N'COLUMN', N'Share'
GO


DROP Procedure QClaimCoinsurance
GO
CREATE Procedure QClaimCoinsurance(@P_ANO integer, @P_Code varchar(10))    
as     
SELECT C.CNO, C.ID, C.DocNo, C.CCollectionF, C.Share, C.JP
FROM Acceptance A
Inner Join Coinsurance C on (C.CNO=A.CNO)
WHERE A.ANO=@P_ANO and C.ClaimNotFullCoverF=0

Union All

Select C.CNO, C.ID, C.DocNo, C.CCollectionF, Cd.Share, C.JP
From Acceptance A
Inner Join Coinsurance C on (C.CNO=A.CNO)
Inner Join CoinsuranceDet Cd on (Cd.CNO=C.CNO and Cd.ID=C.ID)
Where A.ANO=@P_ANO and C.ClaimNotFullCoverF=1
And (
	Cd.Code=@P_Code   
	or   
	Exists (Select Top 1 RCalc.Code from RCalc Inner Join RateCov on (RateCov.Code=Cd.Code and RateCov.TOR=RCalc.TOR) Where RCalc.ANO=A.ANO and RCalc.Code=@P_Code)      
)  

GO

DROP Procedure QGetListClaimCoinsurance
GO
CREATE Procedure QGetListClaimCoinsurance(@P_CNO Integer)      
as       

Declare @Coinsurance as table(CNO Int, ID varchar(10), Share Float, DocNo varchar(20), CCOLLECTIONF bit)

Insert into @Coinsurance
Select Coinsurance.CNO, Coinsurance.ID, Coinsurance.SHARE, Coinsurance.DOCNO, Coinsurance.CCOLLECTIONF
FROM CLAIM
INNER JOIN ACCEPTANCE ON (ACCEPTANCE.ANO=CLAIM.ANO)
INNER JOIN Coinsurance ON (Coinsurance.CNO=ACCEPTANCE.CNO)
WHERE Coinsurance.ClaimNotFullCoverF=0 and CLAIM.CNO=@P_CNO

Union All

Select Coinsurance.CNO, Coinsurance.ID, CoinsuranceDET.SHARE, Coinsurance.DOCNO, Coinsurance.CCOLLECTIONF
FROM CLAIM
INNER JOIN ACCEPTANCE ON (ACCEPTANCE.ANO=CLAIM.ANO)
INNER JOIN Coinsurance ON (Coinsurance.CNO=ACCEPTANCE.CNO)
INNER JOIN CoinsuranceDET on (CoinsuranceDET.CNO=Coinsurance.CNO and CoinsuranceDET.ID=Coinsurance.ID)
INNER JOIN PROFILE ON (PROFILE.ID=Coinsurance.ID)
OUTER APPLY (SELECT TOP 1 LCALC.TOR, LCALC.CODE AS RCODE FROM CCALC, LCALC WHERE CCALC.CNO=CLAIM.CNO AND LCALC.CNO=CCALC.CNO Order By Case When LCALC.Currency=CCALC.Currency Then 0 Else 1 End, Code, TOR) LCALC
WHERE Coinsurance.ClaimNotFullCoverF=1 and CLAIM.CNO=@P_CNO
And (
	CoinsuranceDET.Code=LCALC.RCODE   
	or   
	Exists (Select Top 1 RCalc.Code from RCalc Inner Join RateCov on (RateCov.Code=CoinsuranceDET.Code and RateCov.TOR=RCalc.TOR) Where RCalc.ANO=ACCEPTANCE.ANO and RCalc.Code=LCALC.RCODE)      
)  



SELECT Cast(0 as bit) as ProcessFlag, 'Member' as Type, PROFILE.ID, PROFILE.Salutation + ' ' + PROFILE.NAME as Name, Coinsurance.DOCNO, Coinsurance.SHARE, Coinsurance.CCOLLECTIONF
FROM CLAIM
INNER JOIN ACCEPTANCE ON (ACCEPTANCE.ANO=CLAIM.ANO)
INNER JOIN @Coinsurance Coinsurance ON (Coinsurance.CNO=ACCEPTANCE.CNO)
INNER JOIN PROFILE ON (PROFILE.ID=Coinsurance.ID)
WHERE CLAIM.CNO=@P_CNO


UNION ALL

SELECT Cast(0 as bit) as ProcessFlag, 'Member' as Type, '' AS ID, SYSTAB.COMPANY AS NAME, ''  AS DOCNO, ISOURCE.SHARE, Cast(0 as bit) as CCOLLECTIONF
FROM CLAIM
INNER JOIN ACCEPTANCE ON (ACCEPTANCE.ANO=CLAIM.ANO)
INNER JOIN COVER ON (COVER.CNO=ACCEPTANCE.CNO)
INNER JOIN ISOURCE ON (ISOURCE.CNO=COVER.CNO)
INNER JOIN SYSTAB ON (1=1)
WHERE COVER.ISTYPE='C' AND CLAIM.CNO=@P_CNO

UNION ALL

SELECT Cast(0 as bit) as ProcessFlag, 'LEADER' as Type, Max(PROFILE.ID) as ID, MAX(PROFILE.Salutation + ' ' + PROFILE.NAME) as Name, ''  AS DOCNO, 100-MAX(ISOURCE.SHARE)-coalesce(SUM(Coinsurance.SHARE),0) as share, Cast(0 as bit) as CCOLLECTIONF
FROM CLAIM
INNER JOIN ACCEPTANCE ON (ACCEPTANCE.ANO=CLAIM.ANO)
INNER JOIN COVER ON (COVER.CNO=ACCEPTANCE.CNO)
INNER JOIN ISOURCE ON (ISOURCE.CNO=COVER.CNO)
INNER JOIN PROFILE ON (PROFILE.ID=ISOURCE.ID)
LEFT JOIN @Coinsurance Coinsurance ON (Coinsurance.CNO=COVER.CNO)
WHERE COVER.ISTYPE='C' AND CLAIM.CNO=@P_CNO
HAVING MAX(COVER.ISTYPE)='C'

UNION ALL

SELECT Cast(0 as bit) as ProcessFlag, 'LEADER' as Type, '' AS ID, Max(SYSTAB.COMPANY) AS NAME, ''  AS DOCNO, 100-coalesce(SUM(Coinsurance.SHARE),0) as Share, Cast(0 as bit) as CCOLLECTIONF
FROM CLAIM
INNER JOIN ACCEPTANCE ON (ACCEPTANCE.ANO=CLAIM.ANO)
INNER JOIN COVER ON (COVER.CNO=ACCEPTANCE.CNO)
INNER JOIN @Coinsurance Coinsurance ON (Coinsurance.CNO=COVER.CNO)
INNER JOIN SYSTAB ON (1=1)
WHERE COVER.ISTYPE='L' AND CLAIM.CNO=@P_CNO
HAVING MAX(COVER.ISTYPE)='L'  

GO

DROP PROCEDURE CLView06a 
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
TOC.CashCallOnPartialPaymentF, TOC.CashCallOnEstimateF, TOC.CashCallOnGrossF, 

coalesce(Coinsurance.MShare,0) as MShare
From CCALC   
INNER JOIN CLAIM ON (CLAIM.CNO=CCALC.CNO)   
INNER JOIN ACCEPTANCE ON (ACCEPTANCE.ANO=CLAIM.ANO)   
INNER JOIN COVER ON (COVER.CNO=ACCEPTANCE.CNO)   
INNER JOIN TOC on (TOC.TOC=CLAIM.TOC)  
LEFT JOIN ISOURCE ON (ISOURCE.CNO=ACCEPTANCE.CNO)  
Left Join CCalc pCCalc on (pCCalc.CNO=Claim.pCNO and pCCalc.Currency=CCalc.Currency and Claim.CSeqNo>0)  
Outer Apply (
	Select sum(Share) as MShare
	from
	(
		Select Coinsurance.SHARE
		FROM Coinsurance
		WHERE COVER.ISTYPE='L' and Coinsurance.ClaimNotFullCoverF=0 and Coinsurance.CNO=COVER.CNO

		Union All

		Select CoinsuranceDET.SHARE
		from Coinsurance 
		INNER JOIN CoinsuranceDET on (CoinsuranceDET.CNO=Coinsurance.CNO and CoinsuranceDET.ID=Coinsurance.ID)
		OUTER APPLY (SELECT TOP 1 LCALC.TOR, LCALC.CODE AS RCODE FROM LCALC WHERE LCALC.CNO=CCALC.CNO Order By Case When LCALC.Currency=CCALC.Currency Then 0 Else 1 End, Code, TOR) LCALC
		WHERE COVER.ISTYPE='L' and Coinsurance.ClaimNotFullCoverF=1 and Coinsurance.CNO=COVER.CNO
		And (
			CoinsuranceDET.Code=LCALC.RCODE   
			or   
			Exists (Select Top 1 RCalc.Code from RCalc Inner Join RateCov on (RateCov.Code=CoinsuranceDET.Code and RateCov.TOR=RCalc.TOR) Where RCalc.ANO=ACCEPTANCE.ANO and RCalc.Code=LCALC.RCODE)      
		)  
	) Coinsurance
) Coinsurance
WHERE CCALC.CNO=@P_CNO  
  
GO




insert into PatchVersioning
select '1553 Update Script - 2 March 2026.sql',GETDATE()
go	
  
Declare @PrevScript varchar(100)
Declare @CurrScript varchar(100)

Select @PrevScript=''
Select @CurrSCript='1553 Update Script - 2 March 2026.sql'


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

GO 
  
  
  