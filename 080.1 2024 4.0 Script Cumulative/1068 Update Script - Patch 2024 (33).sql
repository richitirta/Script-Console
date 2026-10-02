DROP Procedure QACCCOLLATERALCASHDEPOSIT 
GO
CREATE Procedure QACCCOLLATERALCASHDEPOSIT (@P_ANO integer)
as

Declare @P_OANO Int

Select @P_OANO=A.OANO from Acceptance A Where ANO=@P_ANO

Select D.ID, D.Currency, sum(D.Nominal) as Nominal
from 
(
Select A2.ID, A2.Currency, A2.Nominal as Nominal
from ACCCOLLATERAL A2 
INNER JOIN COLLATERALTYPE C on (C.COLLATERALTYPE=A2.COLLATERALTYPE and C.CashDepositF=1)
Where A2.ANO=@P_OANO

Union All

Select A3.ID, A3.Currency, -A3.Amount as Nominal
from Acceptance A2 
Inner Join AccAss A3 on (A3.ANO=A2.ANO and A3.Type='DR' and A3.Code='J')
Where A2.OANO=@P_OANO and A2.ANO<=@P_ANO
) D
Group by D.ID, D.Currency
go

 insert into PatchVersioning	
select 'Update Script - Patch 2024 (33)',GETDATE()
go

insert into PatchVersioning
select '1068 Update Script - Patch 2024 (33)',GETDATE()
go
	

Declare @PrevScript varchar(100)
Declare @CurrScript varchar(100)

Select @PrevScript=''
Select @CurrSCript='1068 Update Script - Patch 2024 (33)'


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
