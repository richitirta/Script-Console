--koreksi roundccy before 2018 v.1
DROP FUNCTION RoundCCY
GO
CREATE FUNCTION RoundCCY(@P_Nominal as Float, @P_CCY as varchar(10))              
RETURNS Float
AS               
BEGIN              
Declare @P_Decimal as int

Select @P_Decimal=2

return round(@P_Nominal,@P_Decimal)
END  

go