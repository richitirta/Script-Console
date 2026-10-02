DROP Procedure QGetConjunctionIndemnityClaimForCashCall
GO
Create Procedure QGetConjunctionIndemnityClaimForCashCall(@P_CNO as integer)  
as  
  
Select sum(CCalc.Rate * ((CCalc.Claim - CCalc.Deductible - CCalc.Salvage + CCalc.Cost - CCalc.Subrogation)*CCalc.Share/100+CCalc.RCost))   
      -sum(coalesce(pCCalc.Rate * ((pCCalc.Claim - pCCalc.Deductible - pCCalc.Salvage + pCCalc.Cost - pCCalc.Subrogation)*pCCalc.Share/100+pCCalc.RCost),0))   
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
Drop Procedure QGetConjunctionEstimateClaimForCashCall
GO
Create Procedure QGetConjunctionEstimateClaimForCashCall(@P_CNO as integer)  
as  
  
Select sum(CCalc.Rate * ((CCalc.Loss- CCalc.EDeductible - CCalc.Salvage + CCalc.ECost - CCalc.Subrogation)*CCalc.Share/100+CCalc.ERCost))   
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
go



 insert into PatchVersioning
select '1235 Update Script - Patch 2024 (84)',GETDATE()
go	
  
Declare @PrevScript varchar(100)
Declare @CurrScript varchar(100)

Select @PrevScript=''
Select @CurrSCript='1235 Update Script - Patch 2024 (84)'


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