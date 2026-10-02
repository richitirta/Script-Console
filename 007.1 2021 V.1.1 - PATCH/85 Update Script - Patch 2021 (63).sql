DROP Function FN_Currency
GO
Create Function FN_Currency(@P_ANO as integer)
RETURNS Table 
AS RETURN ( 
Select Currency.Currency, Currency.Description
from Currency 
Inner Join SysTab on (1=1)
Left Join (Select Distinct ANO, Currency from ICover Where ANO=@P_ANO) ICover on (ICover.ANO=@P_ANO)
Where Currency.AllowedF=1 
and (Currency.Currency=SysTab.Currency or Currency.Currency=ICover.Currency)
) 

go

insert into PatchVersioning
select '85 Update Script - Patch 2021 (63)',GETDATE()
go

