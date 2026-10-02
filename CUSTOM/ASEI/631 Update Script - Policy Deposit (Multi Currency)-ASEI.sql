DROP Procedure QPOLICY_DEPOSIT
GO
CREATE Procedure QPOLICY_DEPOSIT(@P_LANO integer)                
as                
Select     
SysTab.Currency,
sum(AccAss.Amount*nVoucher.Rate) as Total_Deposit    
from Acceptance MA1     
Inner Join Acceptance MA2 on (MA2.OANO=MA1.OANO)    
Inner join AccAss on (AccAss.ANO=MA2.ANO)    
Inner Join Admlink on (Admlink.AdmNo=AccAss.AdmNO)
Inner Join nVoucher on (nVoucher.Voucher=Admlink.Voucher)
Inner Join SysTab on (1=1)
Where MA1.ANO=@P_LANO and MA2.ANO<=@P_LANO and AccAss.DepositF=1 and AccAss.Type in ('DI','IC','PD')
Group by SysTab.Currency

GO

DROP Procedure QPOLICY_DEPOSIT_USAGE
GO
CREATE Procedure QPOLICY_DEPOSIT_USAGE(@P_ANO integer, @P_Currency varchar(10)='')                
as                
Select     
SysTab.Currency,     
sum(Case When AccAss.DepositF=1 Then -AccAss.Amount*coalesce(nVoucher.Rate, dbo.get_Exchange(A2.ADate,AccAss.Currency)) else 0 end) as Deposit_Usage    
from Acceptance A1    
Inner Join Acceptance MA1 on (MA1.ANO=A1.LANO)    
Inner Join Acceptance MA2 on (MA2.OANO=MA1.OANO AND MA2.ANO<=MA1.ANO)    
Inner Join Acceptance A2 on (A2.LANO=MA2.LANO and A2.ANO<>A2.LANO)    
Inner Join AccAss on (AccAss.ANO=A2.ANO)    
Left join Admlink on (Admlink.AdmNo=AccAss.AdmNo)
Left Join nVoucher on (nVoucher.Voucher=Admlink.Voucher)
Inner Join SysTab on (1=1)
Where A1.ANO=@P_ANO and A2.ANO<@P_ANO and A2.AStatus not in ('W','T')
and ((AccAss.Type in ('DI','IC') and AccAss.Code in ('P','U','O','J')) or (AccAss.Type in ('IR','IT','IX') and AccAss.Code in ('P','O','J')))     
Group by SysTab.Currency   

GO

DROP Procedure QPOLICY_DEPOSIT_CURRENT
GO
CREATE Procedure QPOLICY_DEPOSIT_CURRENT(@P_ANO integer, @P_Currency varchar(10)='')                
as                

Declare @AStatus as varchar(1)

Select @AStatus=Acceptance.AStatus from Acceptance Where ANO=@P_ANO

if @AStatus='T' or @AStatus='I' 
	Select     
	AccAss.Currency,     
	sum(Case When AccAss.DepositF=0 Then AccAss.Amount else 0 end) as Total_Premium
	from AccAss    
	Where AccAss.ANO=@P_ANO 
	and ((AccAss.Type in ('DI','IC') and AccAss.Code in ('P','U','O','J')) or (AccAss.Type in ('IR','IT','IX') and AccAss.Code in ('P','O','J')))     
	Group by AccAss.Currency    
Else
	Select D.Currency, D.Premium-D.Discount as Total_Premium
	from Premium_calculation(@P_ANO) D 

go



 insert into PatchVersioning	
select '631 Update Script - Policy Deposit (Multi Currency)-ASEI',GETDATE()
go





Declare @PrevScript varchar(100)
Declare @CurrScript varchar(100)

Select @PrevScript=''
Select @CurrSCript='631 Update Script - Policy Deposit (Multi Currency)-ASEI'


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
