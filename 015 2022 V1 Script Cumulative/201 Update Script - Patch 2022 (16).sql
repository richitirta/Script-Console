DROP Procedure QDEPOSIT_REINSURANCE_CESSION
GO
CREATE Procedure QDEPOSIT_REINSURANCE_CESSION (@P_ANO integer, @P_RType varchar(255))     
AS                           
SELECT Top 1 Reinsurance.RID, Reinsurance.SHARE
From Acceptance       
Inner Join Cover on (Cover.CNO=Acceptance.CNO)      
Inner Join Reinsurance on (Reinsurance.RType='Q')      
Inner Join ReClass on (ReClass.RNO=Reinsurance.RNO and ReClass.TOC=ACCEPTANCE.TOC)      
Left Join RePolicy on (RePolicy.RNO=Reinsurance.RNO)      
WHERE ACCEPTANCE.ANO=@P_ANO
-- Master Polis Reinsurance Deposit by Effective Date
And Acceptance.PDate Between Reinsurance.SDate And Reinsurance.EDate    
And (coalesce(RePolicy.ID,'')='' or  coalesce(RePolicy.ID,'')=Cover.PHolder)    
Order By coalesce(RePolicy.ID,'') Desc, (Case When ReClass.PriorityF=1 Then ReClass.PriorityF else Reinsurance.PriorityF end) Desc                   
  
GO
DROP Procedure QREINSURANCE_DEPOSIT
GO
CREATE Procedure QREINSURANCE_DEPOSIT(@P_LANO integer)                
as                
Select     
AccAss.Currency,
AccAss.ID, 
AccAss.Type as Type,
Max(Accass.RefNo) as RefNo,
sum(-AccAss.Amount) as Total_Deposit, 
sum(Case When AccAss.Code='P' Then -AccAss.Amount else 0 end) as Total_Deposit_Premium, 
sum(Case When AccAss.Code='C' Then -AccAss.Amount else 0 end) as Total_Deposit_Commission,
-sum(Case When AccAss.Code='C' Then -AccAss.Amount else 0 end)/sum(Case When AccAss.Code='P' Then -AccAss.Amount else 0 end)*100 as Comm
from Acceptance MA1     
Inner Join Acceptance MA2 on (MA2.OANO=MA1.OANO)    
Inner join AccAss on (AccAss.ANO=MA2.ANO)    
Left Join RPart on (AccAss.Type in ('QS','QP') and RPart.DocNo=Accass.RefNo and RPart.ID=Accass.ID)
Left Join (
	-- see QDEPOSIT_REINSURANCE_CESSION
	SELECT Top 1 Reinsurance.RNO
	From Acceptance       
	Inner Join Cover on (Cover.CNO=Acceptance.CNO)      
	Inner Join Reinsurance on (Reinsurance.RType='Q')      
	Inner Join ReClass on (ReClass.RNO=Reinsurance.RNO and ReClass.TOC=ACCEPTANCE.TOC)      
	Left Join RePolicy on (RePolicy.RNO=Reinsurance.RNO)      
	WHERE ACCEPTANCE.ANO=@P_LANO
	-- Master Polis Reinsurance Deposit by Effective Date
	And Acceptance.PDate Between Reinsurance.SDate And Reinsurance.EDate       
	And (coalesce(RePolicy.ID,'')='' or  coalesce(RePolicy.ID,'')=Cover.PHolder)    
	Order By coalesce(RePolicy.ID,'') Desc, (Case When ReClass.PriorityF=1 Then ReClass.PriorityF else Reinsurance.PriorityF end) Desc                   
) Reinsurance on (Reinsurance.RNO=RPart.RNO)
Where MA1.ANO=@P_LANO and MA2.ANO<=@P_LANO and AccAss.DepositF=1 
and (AccAss.Type='FO' or (AccAss.Type in ('QS','QP') and Coalesce(RPart.RNO,0)<>0))
Group by AccAss.Currency, AccAss.ID, AccAss.Type
having sum(Case When AccAss.Code='P' Then -AccAss.Amount else 0 end)<>0



GO



 insert into PatchVersioning
select '201 Update Script - Patch 2022 (16)',GETDATE()
go


Declare @PrevScript varchar(100)
Declare @CurrScript varchar(100)

Select @PrevScript=''
Select @CurrSCript='201 Update Script - Patch 2022 (16)'


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