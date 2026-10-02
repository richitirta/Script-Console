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
	Max((CCalc.Loss-CCalc.EDeductible-CCalc.ESalvage-CCalc.ESubrogation+CCalc.ECost)*CCalc.Share/100*CCalc.Rate) as GrossEstimate,   
	Max((pCCalc.Loss-pCCalc.EDeductible-pCCalc.ESalvage-pCCalc.ESubrogation+pCCalc.ECost)*pCCalc.Share/100*pCCalc.Rate) as PrevGrossEstimate,   
  
	Sum(
	Case When Coalesce(Coinsurance.CCollectionF,1)=1 Then   
	 0  
	 else  
	 (CCalc.Loss-CCalc.EDeductible-CCalc.ESalvage-CCalc.ESubrogation+CCalc.ECost)*CCalc.Share/100*(coalesce(Coinsurance.Share,0)/100)*CCalc.Rate  
	End) as MemberEstimate,  

	Sum(
	Case When Coalesce(Coinsurance.CCollectionF,1)=1 Then   
	 0  
	 else  
	 (pCCalc.Loss-pCCalc.EDeductible-pCCalc.ESalvage-pCCalc.ESubrogation+pCCalc.ECost)*pCCalc.Share/100*(coalesce(Coinsurance.Share,0)/100)*pCCalc.Rate  
	End) as PrevMemberEstimate,  
  
	Max((CCalc.Claim-CCalc.Deductible-CCalc.Salvage-CCalc.Subrogation+CCalc.Cost)*CCalc.Share/100*CCalc.Rate) as GrossAmount,  
	Max(Case When Claim.CSeqNo>0 then (pCCalc.Claim-pCCalc.Deductible-pCCalc.Salvage-pCCalc.Subrogation+pCCalc.Cost)*pCCalc.Share/100*pCCalc.Rate else 0 end) as PrevGrossAmount,  
  
	Sum(
	Case When Coalesce(Coinsurance.CCollectionF,1)=1 Then   
	 0  
	 else  
	 (CCalc.Claim-CCalc.Deductible-CCalc.Salvage-CCalc.Subrogation+CCalc.Cost)*CCalc.Share/100*(coalesce(Coinsurance.Share,0)/100)*CCalc.Rate  
	End) as MemberAmount,

	Sum(
	Case When Coalesce(Coinsurance.CCollectionF,1)=1 Then   
	 0  
	 else  
	 Case When Claim.CSeqNo>0 then (pCCalc.Claim-pCCalc.Deductible-pCCalc.Salvage-pCCalc.Subrogation+pCCalc.Cost)*pCCalc.Share/100*(coalesce(Coinsurance.Share,0)/100)*pCCalc.Rate else 0 end
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



go


 insert into PatchVersioning	
select '718 Update Script - Patch 2023 (76)',GETDATE()
go





Declare @PrevScript varchar(100)
Declare @CurrScript varchar(1004)

Select @PrevScript=''
Select @CurrSCript='718 Update Script - Patch 2023 (76)'


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


