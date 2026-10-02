DROP FUNCTION fn_SL_Payment_Nominal_Table
GO

DROP FUNCTION fn_SL_Payment_Nominal
GO
Create FUNCTION fn_SL_Payment_Nominal (@Nominal as float, @PSL_Cat as varchar(1), @PDebtorF as bit, @DebtorF as bit)  
RETURNS Float  
WITH SCHEMABINDING
AS   
BEGIN  
	Declare @ReturnValue Float
	Select @ReturnValue=
	case When @DebtorF=1 Then
		Case When @PSL_Cat in ('A','B','P') then
			Case When @PDebtorF=@DebtorF then @Nominal Else -@Nominal End
		else 
			Case When @PDebtorF=@DebtorF then -@Nominal Else @Nominal End
		End
	Else
		Case When @PSL_Cat in ('A','B','P') then
			Case When @PDebtorF=@DebtorF then -@Nominal Else @Nominal End
		else 
			Case When @PDebtorF=@DebtorF then @Nominal Else -@Nominal End
		End
	End
	return(@ReturnValue)  
END  
  
GO

CREATE FUNCTION fn_SL_Payment_Nominal_Table
(
    @Nominal AS FLOAT,
    @PSL_Cat AS VARCHAR(1),
    @PDebtorF AS BIT,
    @DebtorF AS BIT
)
RETURNS TABLE
WITH SCHEMABINDING
AS
RETURN
(
    Select dbo.fn_SL_Payment_Nominal(@Nominal, @PSL_Cat, @PDebtorF, @DebtorF) as Payment
);
 

