DROP Procedure QREINSURANCE_DEPOSIT_USAGE
GO
CREATE Procedure QREINSURANCE_DEPOSIT_USAGE(@P_ANO integer, @P_ID as varchar(10), @P_Currency varchar(10)='', @P_Type varchar(10)='', @P_RefNo varchar(50)='')                
as                
Select     
AccAss.Currency,     
sum(Case When AccAss.DepositF=0 Then -AccAss.Amount else 0 end) as Total_Premium,    
sum(Case When AccAss.DepositF=1 Then AccAss.Amount else 0 end) as Deposit_Usage   
from Acceptance A1    
Inner Join Acceptance MA1 on (MA1.ANO=A1.LANO)    
Inner Join Acceptance MA2 on (MA2.OANO=MA1.OANO AND MA2.ANO<=MA1.ANO)    
Inner Join Acceptance A2 on (A2.LANO=MA2.LANO and A2.ANO<>A2.LANO)    
Inner Join AccAss on (AccAss.ANO=A2.ANO)    
Where A1.ANO=@P_ANO and AccAss.ID=@P_ID and (A2.AStatus Not in ('W','T') or A2.ANO=@P_ANO)
and (@P_Currency='' or AccAss.Currency=@P_Currency) 
and (@P_Type='' or AccAss.Type=@P_Type) 
--RefNo not applied
--and (@P_RefNo='' or AccAss.RefNo=@P_RefNo)
Group by AccAss.Currency 
having round(sum(Case When AccAss.DepositF=0 Then -AccAss.Amount else 0 end),2)<>0 or round(sum(Case When AccAss.DepositF=1 Then AccAss.Amount else 0 end),2)<>0



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
Where MA1.ANO=@P_LANO and MA2.ANO<=@P_LANO and AccAss.DepositF=1 and AccAss.Type in ('QS','QP','FO')
Group by AccAss.Currency, AccAss.ID, AccAss.Type
having sum(Case When AccAss.Code='P' Then -AccAss.Amount else 0 end)<>0




go




 insert into PatchVersioning
select '152 Update Script - Patch 2022 (7)',GETDATE()
go


Declare @PrevScript varchar(100)
Declare @CurrScript varchar(100)

Select @PrevScript=''
Select @CurrSCript='152 Update Script - Patch 2022 (7)'


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



