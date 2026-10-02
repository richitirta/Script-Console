DROP procedure QApproval_Claim 
GO
Create procedure QApproval_Claim (@P_CNO integer)            
AS            
Select Claim.Branch, Claim.TOC, Claim.ISType, 
Max(Claim.RCode) as RCode,
sum(GrossEstimate-MemberEstimate) as Estimate, 
sum(PrevGrossEstimate-PrevMemberEstimate) as PrevEstimate, 
sum(GrossAmount-MemberAmount) as Amount,
sum(PrevGrossAmount-PrevMemberAmount) as PrevAmount  
from   
(  
	Select Claim.Branch, Claim.TOC, Claim.ISType, CCalc.Currency, Max(LCalc.RCode) as RCode,

	Max(((CCalc.Loss+CCalc.ECost)*CCalc.Share/100+CCALC.ERCOST+(CCALC.ETCOST-CCALC.ECOST-CCALC.ERCOST))*CCalc.Rate) as GrossEstimate,   
	Max(((pCCALC.Loss+pCCALC.ECost)*pCCALC.Share/100+pCCALC.ERCOST+(pCCALC.ETCOST-pCCALC.ECOST-pCCALC.ERCOST))*pCCALC.Rate) as PrevGrossEstimate,   
  
	Sum(
	Case When Coalesce(Coinsurance.CCollectionF,1)=1 Then   
	 0  
	 else  
	 (((CCalc.Loss+CCalc.ECost)*CCalc.Share/100+CCALC.ERCOST)*coalesce(Coinsurance.Share,0)/100*CCalc.Rate)
	End) as MemberEstimate,  

	Sum(
	Case When Coalesce(Coinsurance.CCollectionF,1)=1 Then   
	 0  
	 else  
	 (((pCCALC.Loss+pCCALC.ECost)*pCCALC.Share/100+pCCALC.ERCOST)*coalesce(Coinsurance.Share,0)/100*pCCALC.Rate)
	End) as PrevMemberEstimate,  
  
	Max(((CCalc.Claim+CCalc.Cost)*CCalc.Share/100+CCALC.RCOST+(CCALC.TCOST-CCALC.COST-CCALC.RCOST))*CCalc.Rate) as GrossAmount,   
	Max(Case When Claim.CSeqNo>0 then ((pCCalc.Claim+pCCalc.Cost)*pCCalc.Share/100+pCCalc.RCOST+(pCCalc.TCOST-pCCalc.COST-pCCalc.RCOST))*pCCalc.Rate else 0 end) as PrevGrossAmount,  
  
	Sum(
	Case When Coalesce(Coinsurance.CCollectionF,1)=1 Then   
	 0  
	 else  
	 (((CCalc.Claim+CCalc.Cost)*CCalc.Share/100+CCALC.RCOST)*coalesce(Coinsurance.Share,0)/100*CCalc.Rate)
	End) as MemberAmount,

	Sum(
	Case When Coalesce(Coinsurance.CCollectionF,1)=1 Then   
	 0  
	 else  
	 Case When Claim.CSeqNo>0 then ((pCCalc.Claim+pCCalc.Cost)*pCCalc.Share/100+pCCalc.RCOST)*coalesce(Coinsurance.Share,0)/100*pCCalc.Rate else 0 end
	End) as PrevMemberAmount
  
	From Claim  
	inner join CCALC on (CCalc.CNO=Claim.CNO)  
	inner join Acceptance on (Acceptance.ANO=Claim.ANO)  
	Left Join Coinsurance on (Coinsurance.CNO=Acceptance.CNO and Claim.ISType='L')  
	Left join CCalc pCCalc on (pCCalc.CNO=Claim.pCNO and pCCalc.Currency=CCalc.Currency)
	OUTER APPLY (SELECT TOP 1 CODE AS RCODE FROM LCALC WHERE CNO=CCALC.CNO Order By Case When LCALC.Currency=CCALC.Currency Then 0 Else 1 End, Code) LCALC
	WHERE Claim.CNO=@P_CNO   
	Group By Claim.Branch, Claim.TOC, Claim.ISType, CCalc.Currency
) Claim  
  
Group by Claim.Branch, Claim.TOC, Claim.ISType      

GO



  insert into PatchVersioning
select '1271 Update Script - QApproval_Claim (AIG INDO)',GETDATE()
go	
  
Declare @PrevScript varchar(100)
Declare @CurrScript varchar(100)

Select @PrevScript=''
Select @CurrSCript='1271 Update Script - QApproval_Claim (AIG INDO)'


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





