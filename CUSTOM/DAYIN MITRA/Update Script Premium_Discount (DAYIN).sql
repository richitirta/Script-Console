DROP Function [dbo].[Premium_Discount]

GO

CREATE Function [dbo].[Premium_Discount](@P_ANO as int,@P_Code as varchar(10),@P_Period int=0) 
RETURNS Float 
AS 
BEGIN 
Declare @GDiscount Float 
Declare @PDiscount Float 
Declare @Discount Float 
Declare @ADiscount Float 
Select @GDiscount=GDiscount, @PDiscount=PDiscount, @Discount=Discount from Payor_Discount(@P_ANO,@P_Code,@P_Period) 
if @Discount is null 
Select @Discount=0 
--Agent Discount is Not Longer Used 
--Select @ADiscount=dbo.agent_discount(@P_ANO,@P_Code,@P_Period) 
if @ADiscount is null 
Select @ADiscount=0 
return(@Discount+@ADiscount) 
End 