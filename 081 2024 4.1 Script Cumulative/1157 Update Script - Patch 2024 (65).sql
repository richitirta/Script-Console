DROP FUNCTION fn_Exchange
GO
CREATE FUNCTION fn_Exchange(@PDate as smalldatetime) 
RETURNS @EXCHANGE TABLE (Currency varchar(10), Effective smalldatetime, Rate float, TRate Float, BIRate Float, RRate Float, VRate Float, Rate_RC Float, VRate_RC Float) 
AS 
BEGIN 
insert into @EXCHANGE 
Select Currency.Currency, Currency.Effective, Currency.Rate, Currency.TRate, Currency.BIRate, Currency.RRate, Currency.VRate, Currency.Rate_RC, Currency.VRate_RC 
from Currency
Inner Join SysTab on (1=1)
Where (Currency.Currency<>SysTab.Currency or (Currency.Currency<>SysTab.Currency_1 and SysTab.Currency_1<>''))
and Currency.Effective<=@PDate 
 
insert into @EXCHANGE 
Select E1.Currency, E1.Effective, E1.Rate, E1.TRate, E1.BIRate, E1.RRate, E1.VRate, E1.Rate_RC, E1.VRate_RC 
from Exchange E1
Inner Join Currency on (Currency.Currency=E1.Currency)
Where E1.Effective<=@PDate and Currency.Effective>@PDate 
and E1.Effective=coalesce((Select Top 1 E2.Effective from Exchange E2 Where E2.Currency=E1.Currency and E2.Effective<=@PDate Order By E2.Effective Desc),'01/01/1900') 
 
insert into @EXCHANGE 
Select Currency, @PDate as Effective, 1 as Rate, 1 as TRate, 1 as BIRate, 1 as RRate, 1 as VRate, 1 as Rate_RC, 1 as VRate_RC
from Currency 
Where NOT EXISTS (Select Currency from @Exchange E Where E.Currency=Currency.Currency) 
 
RETURN 
END 

go



  insert into PatchVersioning
select '1157 Update Script - Patch 2024 (65)',GETDATE()
go	
  
Declare @PrevScript varchar(100)
Declare @CurrScript varchar(100)

Select @PrevScript=''
Select @CurrSCript='1157 Update Script - Patch 2024 (65)'


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

 