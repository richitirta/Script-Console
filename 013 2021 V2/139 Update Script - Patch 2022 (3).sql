DROP PROCEDURE QClaim_1 
GO
CREATE PROCEDURE QClaim_1 (@P_CNO as integer) 
AS 
SELECT 
CLAIM.ClaimNo, 
Claim.TOC,
Claim.ANO, 
Claim.pCNO, 
Claim.OCNO,
Claim.CType, 
Claim.LossDate,
Claim.LossTime,
Claim.Branch,
Claim.ISType, 
Claim.RCNO,
Claim.EventNo,
Claim.CSeqNo, 
Claim.CStatus,
Claim.pCStatus,
Claim.RefNo, 
Claim.Payment,
Claim.Claimant, 
Claim.PSettledF,
Claim.LUserID, 
Claim.ADate,
Claim.CSDate,
Claim.RequestF,
Claim.RequestName,
Acceptance.AName, 
Acceptance.policyno, 
Acceptance.certificateno, 
Acceptance.REGNO, 
Acceptance.CNO AS COVERCNO, 
Acceptance.BIZMAPID, 
Acceptance.Source, 
Acceptance.MSCode, 
Cover.MO,
TOC.CashCallOnEstimateF, 
TOC.CashCallOnGrossF
From CLAIM 
Left Join acceptance on (Acceptance.ANO=Claim.ANO) 
Left Join Cover on (Cover.CNO=Acceptance.CNO) 
Inner Join TOC on (TOC.TOC=Claim.TOC)
WHERE CLAIM.CNO=@P_CNO 
go




 insert into PatchVersioning
select '139 Update Script - Patch 2022 (3)',GETDATE()
go


Declare @PrevScript varchar(100)
Declare @CurrScript varchar(100)

Select @PrevScript=''
Select @CurrSCript='139 Update Script - Patch 2022 (3)'


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