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
TOC.CashCallOnGrossF,
TOC.CashCallOnPartialPaymentF 
From CLAIM 
Left Join acceptance on (Acceptance.ANO=Claim.ANO) 
Left Join Cover on (Cover.CNO=Acceptance.CNO) 
Inner Join TOC on (TOC.TOC=Claim.TOC)
WHERE CLAIM.CNO=@P_CNO 

GO
DROP Procedure QGetIndemnityClaimForCashCall
GO
Create Procedure QGetIndemnityClaimForCashCall(@P_CNO as integer)                  
as     
Select sum(CCalc.Rate * ((CCalc.Claim - CCalc.Deductible - CCalc.Salvage + CCalc.Cost - CCalc.Subrogation)*CCalc.Share/100+(CCalc.RCost-CCalc.RSubrogation-CCalc.RSalvage))) 
      -sum(coalesce(pCCalc.Rate * ((pCCalc.Claim - pCCalc.Deductible - pCCalc.Salvage + pCCalc.Cost - pCCalc.Subrogation)*pCCalc.Share/100+(pCCalc.RCost-pCCalc.RSubrogation-pCCalc.RSalvage)),0)) 
as Indemnity 
from CCalc 
Inner Join Claim on (Claim.CNO=CCalc.CNO)
Inner Join TOC on (TOC.TOC=Claim.TOC)
Left Join CCalc pCCalc on (pCCalc.CNO=Claim.pCNO and pCCalc.Currency=CCalc.Currency and Claim.CSeqNo>0 and TOC.CashCallOnPartialPaymentF=1)
Where CCALC.CNO=@P_CNO


GO

DROP Procedure QGetConjunctionIndemnityClaimForCashCall
GO
Create Procedure QGetConjunctionIndemnityClaimForCashCall(@P_CNO as integer)    
as    
    
Select sum(CCalc.Rate * ((CCalc.Claim - CCalc.Deductible - CCalc.Salvage + CCalc.Cost - CCalc.Subrogation)*CCalc.Share/100+(CCalc.RCost-CCalc.RSubrogation-CCalc.RSalvage)))     
      -sum(coalesce(pCCalc.Rate * ((pCCalc.Claim - pCCalc.Deductible - pCCalc.Salvage + pCCalc.Cost - pCCalc.Subrogation)*pCCalc.Share/100+(pCCalc.RCost-pCCalc.RSubrogation-pCCalc.RSalvage)),0))     
as Indemnity     
from Claim C1    
Inner Join Acceptance A1 on (A1.ANO=C1.ANO)    
Left Join Acceptance A2 on (A2.CANO=A1.ANO)    
Left Join Acceptance A3 on (A3.ANO=A1.CANO)  
Inner Join Claim C2 on (C2.PolicyNo=coalesce(A2.PolicyNo, A3.PolicyNo) and C2.CERTIFICATENO=coalesce(A2.CERTIFICATENO, A3.CertificateNo))    
Inner Join CCalc on (CCALC.CNO=C2.CNO)    
Inner Join TOC on (TOC.TOC=C2.TOC)    
Left Join CCalc pCCalc on (pCCalc.CNO=C2.pCNO and pCCalc.Currency=CCalc.Currency and C2.CSeqNo>0 and TOC.CashCallOnPartialPaymentF=1)    
Where C1.CNO=@P_CNO     
and C2.CType<>'C' and C2.CStatus<>'R' and (C2.CStatus<>'C' or C2.PCstatus='A')     
and not exists (Select pCNO from Claim Where Claim.pCNO=C2.CNO and Claim.CStatus<>'R')     
  
GO
DROP Procedure QGetEstimateClaimForCashCall
GO
Create Procedure QGetEstimateClaimForCashCall(@P_CNO as integer)                    
as       
Select sum(CCalc.Rate * ((CCalc.Loss- CCalc.EDeductible - CCalc.Salvage + CCalc.ECost - CCalc.Subrogation)*CCalc.Share/100+(CCalc.ERCost-CCalc.ERSubrogation-CCalc.ERSalvage)))   
as Estimate  
from CCalc   
Where CCALC.CNO=@P_CNO  

GO  
DROP Procedure QGetConjunctionEstimateClaimForCashCall
GO
Create Procedure QGetConjunctionEstimateClaimForCashCall(@P_CNO as integer)    
as        
Select sum(CCalc.Rate * ((CCalc.Loss- CCalc.EDeductible - CCalc.Salvage + CCalc.ECost - CCalc.Subrogation)*CCalc.Share/100+(CCalc.ERCost-CCalc.ERSubrogation-CCalc.ERSalvage)))     
as Estimate    
from Claim C1    
Inner Join Acceptance A1 on (A1.ANO=C1.ANO)    
Left Join Acceptance A2 on (A2.CANO=A1.ANO)    
Left Join Acceptance A3 on (A3.ANO=A1.CANO)  
Inner Join Claim C2 on (C2.PolicyNo=coalesce(A2.PolicyNo, A3.PolicyNo) and C2.CERTIFICATENO=coalesce(A2.CERTIFICATENO, A3.CertificateNo))    
Inner Join CCalc on (CCALC.CNO=C2.CNO)    
Where C1.CNO=@P_CNO     
and C2.CType<>'C' and C2.CStatus<>'R' and (C2.CStatus<>'C' or C2.PCstatus='A')     
and not exists (Select pCNO from Claim Where Claim.pCNO=C2.CNO and Claim.CStatus<>'R')     

GO

DROP Procedure QCLAIMRCESSION 
GO
CREATE Procedure QCLAIMRCESSION (@P_RID varchar(255), @P_CNO int)      
as      

Declare @ClaimEvents table(TOC varchar(10), RID varchar(20))

Declare @EventNo int
Declare @ANO int
Declare @TOC varchar(10)
Declare @Category varchar(1)

Select @EventNo=Claim.EventNo, @ANO=Claim.ANO, @TOC=Claim.TOC, @Category=coalesce(Event.Category,'R') from Claim Left Join Event on (Event.EventNo=Claim.EventNo) Where Claim.CNO=@P_CNO

if @EventNo>0
Begin
	insert into @ClaimEvents
	Select Distinct C1.TOC, 
	(
		Case 
		When Reinsurance.RType='X1' Then C2.XL1ID
		When Reinsurance.RType='X2' Then C2.XL2ID
		When Reinsurance.RType='X3' Then C2.XL3ID
		When Reinsurance.RType='X4' Then C2.XL4ID
		When Reinsurance.RType='X5' Then C2.XL5ID
		When Reinsurance.RType='X6' Then C2.XL6ID
		When Reinsurance.RType='X7' Then C2.XL7ID
		Else ''
		end) as RID
	from Claim C1
	Inner Join CArrHeader C2 on (C2.CNO=C1.CNO)
	Inner Join Reinsurance on (Reinsurance.RID=@P_RID)
	Where @EventNo>0 and C1.EventNo=@EventNo and C2.Status='A' 
end


SELECT RPART.ID, (RPART.SHARE-RPART.JP) as SHARE, cast(0 as Float) as JP, 
100 as RPORTION,
REINSURANCE.RID, REINSURANCE.CESSION, REINSURANCE.RYEAR, REINSURANCE.CPDAYS,
Case When REINSURANCE.TreatyLimitType=0 or REINSURANCE.Share=0 or REINSURANCE.RType not in ('Q','A') Then 1 else 100/REINSURANCE.Share end as TreatyLimitMult,
CASE WHEN COALESCE(RPART.DOCNO,'')='' THEN REINSURANCE.DOCNO ELSE RPART.DOCNO END AS DOCNO,
Case When @Category='E' and RECLASS.ELIMIT<>0 Then RECLASS.ELIMIT Else (Case WHEN RECLASS.Limit=0 THEN Reinsurance.Limit Else RECLASS.Limit end) End*Case When coalesce(R1.CRate,coalesce(R1.Rate,0))=0 Then (Case When Reinsurance.Currency='' or Reinsurance.
Currency=SysTab.Currency Then 1 Else dbo.get_Exchange(Acceptance.SDate, Reinsurance.Currency) End) else coalesce(R1.CRate,coalesce(R1.Rate,1))*coalesce(R2.CRate,coalesce(R2.Rate,1)) End as Limit,
CASE WHEN RPART.CASHLOSS<>0 THEN RPART.CASHLOSS ELSE REINSURANCE.CASHLOSS END*Case When coalesce(R1.CRate,coalesce(R1.Rate,0))=0 Then (Case When Reinsurance.Currency='' or Reinsurance.Currency=SysTab.Currency Then 1 Else dbo.get_Exchange(Acceptance.SDate, Reinsurance.Currency) End) else coalesce(R1.CRate,coalesce(R1.Rate,1))*coalesce(R2.CRate,coalesce(R2.Rate,1)) End as CASHLOSS, 
REINSURANCE.CASHLOSSE*Case When coalesce(R1.CRate,coalesce(R1.Rate,0))=0 Then (Case When Reinsurance.Currency='' or Reinsurance.Currency=SysTab.Currency Then 1 Else dbo.get_Exchange(Acceptance.SDate, Reinsurance.Currency) End) else coalesce(R1.CRate,coalesce(R1.Rate,1))*coalesce(R2.CRate,coalesce(R2.Rate,1)) End as CASHLOSSE, 
REINSURANCE.CASHLOSSCOMBINE*Case When coalesce(R1.CRate,coalesce(R1.Rate,0))=0 Then (Case When Reinsurance.Currency='' or Reinsurance.Currency=SysTab.Currency Then 1 Else dbo.get_Exchange(Acceptance.SDate, Reinsurance.Currency) End) else coalesce(R1.CRate,coalesce(R1.Rate,1))*coalesce(R2.CRate,coalesce(R2.Rate,1)) End as CASHLOSSCOMBINE, 
REINSURANCE.PRIORITYF,      
CASE WHEN @Category<>'E' OR REINSURANCE.EREINSTATEMENT=0 THEN REINSURANCE.REINSTATEMENT ELSE REINSURANCE.EREINSTATEMENT END AS REINSTATEMENT,     
CASE WHEN @Category<>'E' OR REINSURANCE.EREINSTATEMENT_1=0 THEN REINSURANCE.REINSTATEMENT_1 ELSE REINSURANCE.EREINSTATEMENT_1 END AS REINSTATEMENT_1,     
CASE WHEN @Category<>'E' OR REINSURANCE.EREINSTATEMENT_2=0 THEN REINSURANCE.REINSTATEMENT_2 ELSE REINSURANCE.EREINSTATEMENT_2 END AS REINSTATEMENT_2,     
CASE WHEN @Category<>'E' OR REINSURANCE.EREINSTATEMENT_3=0 THEN REINSURANCE.REINSTATEMENT_3 ELSE REINSURANCE.EREINSTATEMENT_3 END AS REINSTATEMENT_3,     
CASE WHEN @Category<>'E' OR REINSURANCE.EAP_1=0 THEN REINSURANCE.AP_1 ELSE REINSURANCE.EAP_1 END AS AP_1,     
CASE WHEN @Category<>'E' OR REINSURANCE.EAP_2=0 THEN REINSURANCE.AP_2 ELSE REINSURANCE.EAP_2 END AS AP_2,     
CASE WHEN @Category<>'E' OR REINSURANCE.EAP_3=0 THEN REINSURANCE.AP_3 ELSE REINSURANCE.EAP_3 END AS AP_3    
From REINSURANCE
INNER JOIN ACCEPTANCE ON (ACCEPTANCE.ANO=@ANO)
INNER JOIN RPART ON (RPART.RNO=REINSURANCE.RNO AND (RPART.SHARE-RPART.JP)<>0)
Inner Join ReClass on (
	ReClass.RNO=Reinsurance.RNO 
	and 
	ReClass.TOC=
	(
		Select Top 1 R.TOC
		from ReClass R
		Where R.RNO=Reinsurance.RNO 
		and exists (
			Select @TOC Where R.TOC=@TOC
			
			union All

			Select Distinct C.TOC 
			from @ClaimEvents C
			Where C.TOC=R.TOC and C.RID=@P_RID
		)
		Order by Case When @Category='E' and R.ELIMIT<>0 Then R.ELIMIT Else (Case WHEN R.Limit=0 THEN Reinsurance.Limit Else R.Limit end) End
	)
	)          
Left Join ReRate R1 on (R1.TOC=@TOC and R1.RYear=Reinsurance.RYEAR and R1.Currency=Reinsurance.Currency)
Left Join ReRate R2 on (R2.TOC=R1.TOC and R2.RYear=R1.RYear and R2.Currency=R1.CCYTo and R1.Currency<>R1.CCYTO)
Inner Join SysTab on (1=1)
WHERE REINSURANCE.RID=@P_RID 
-- If Risk is Excluded      
AND NOT EXISTS (SELECT TOP 1 1 FROM RPARTDET Inner Join LCALC on (LCALC.CNO=@P_CNO AND LCALC.TOR=RPARTDET.TOR) WHERE RPARTDET.RNO=RPART.RNO AND RPARTDET.ID=RPART.ID AND RPARTDET.DOCNO=RPART.DOCNO AND RPARTDET.EXCLUDEF=1)      
-- If Risk is Excluded      
AND NOT EXISTS (SELECT TOP 1 1 FROM RCALC Inner Join LCALC on (LCALC.CNO=@P_CNO AND LCALC.TOR=RCALC.TOR) WHERE RCALC.ANO=@ANO AND RCALC.EXTREATYF=1)     
GO


	
insert into PatchVersioning
select '1522 Update Script - patch 2025 (68).sql',GETDATE()
go	
  
Declare @PrevScript varchar(100)
Declare @CurrScript varchar(100)

Select @PrevScript=''
Select @CurrSCript='1522 Update Script - patch 2025 (68).sql'


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



