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

DROP Procedure QREINSURANCE_DEPOSIT_USAGE
GO
CREATE Procedure QREINSURANCE_DEPOSIT_USAGE(@P_ANO integer, @P_ID as varchar(10), @P_Currency varchar(10)='', @P_Type varchar(10)='', @P_RefNo varchar(50)='')                
as          

Declare @GrossPremium as float
Declare @RComm as float
Declare @RShare as float
Declare @Deposit_Usage as Float

Select     
@GrossPremium=sum(Case When AccAss.DepositF=0 Then AccAss.Amount else 0 end)
from Acceptance A1    
Inner Join Acceptance MA1 on (MA1.ANO=A1.LANO)    
Inner Join Acceptance MA2 on (MA2.OANO=MA1.OANO AND MA2.ANO<=MA1.ANO)    
Inner Join Acceptance A2 on (A2.LANO=MA2.LANO and A2.ANO<>A2.LANO)    
Inner Join AccAss on (AccAss.ANO=A2.ANO)    
Where A1.ANO=@P_ANO and (A2.AStatus Not in ('W','T') or A2.ANO=@P_ANO)
and ((AccAss.Type in ('DI','IC') and AccAss.Code in ('P','U','O','J')) or (AccAss.Type in ('IR','IT','IX') and AccAss.Code in ('P','O','J')))     
and (AccAss.Currency=@P_Currency)

Select @RComm=RPart.Comm, @RShare=Reinsurance.Share*RPart.Share/100
from RPart 
Inner Join Reinsurance on (Reinsurance.RNO=RPart.RNO and Reinsurance.RType='Q')
Where RPart.DocNo=@P_RefNo and RPart.ID=@P_ID
     
Select     
--AccAss.Currency,     
--sum(Case When AccAss.DepositF=0 Then -AccAss.Amount else 0 end) as Total_Premium,    
@Deposit_Usage=sum(Case When AccAss.DepositF=1 Then AccAss.Amount else 0 end)
from Acceptance A1    
Inner Join Acceptance MA1 on (MA1.ANO=A1.LANO)    
Inner Join Acceptance MA2 on (MA2.OANO=MA1.OANO AND MA2.ANO<=MA1.ANO)    
Inner Join Acceptance A2 on (A2.LANO=MA2.LANO and A2.ANO<>A2.LANO)    
Inner Join AccAss on (AccAss.ANO=A2.ANO)    
Where A1.ANO=@P_ANO and AccAss.ID=@P_ID and (A2.AStatus Not in ('W','T') or A2.ANO=@P_ANO)
and AccAss.Code in ('P','C')
and (AccAss.Currency=@P_Currency) 
and (AccAss.Type=@P_Type) 
--RefNo not applied
--and (@P_RefNo='' or AccAss.RefNo=@P_RefNo)
--Group by AccAss.Currency 
--having round(sum(Case When AccAss.DepositF=0 Then -AccAss.Amount else 0 end),2)<>0 or round(sum(Case When AccAss.DepositF=1 Then AccAss.Amount else 0 end),2)<>0

if @GrossPremium is null
	Select @GrossPremium=0

if @RComm is null
	Select @RComm=0

if @RShare is null
	Select @RShare=0

if @Deposit_Usage is null
	Select @Deposit_Usage=0

Select @P_Currency as Currency, @GrossPremium*@RShare/100*(100-@RComm)/100 as Total_Premium, @Deposit_Usage as Deposit_Usage


GO



 insert into PatchVersioning
select '884 Update Script - Reinsurance Deposit (LPEI)',GETDATE()
go


Declare @PrevScript varchar(100)
Declare @CurrScript varchar(100)

Select @PrevScript=''
Select @CurrSCript='884 Update Script - Reinsurance Deposit (LPEI)'


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
