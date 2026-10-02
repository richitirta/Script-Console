IF EXISTS ( SELECT * FROM   sysobjects WHERE  id = object_id(N'[dbo].[Reinsurance_Limit_Liability]') and OBJECTPROPERTY(id, N'IsProcedure') = 1 )
begin
DROP Procedure Reinsurance_Limit_Liability
end
GO
CREATE Procedure Reinsurance_Limit_Liability(@P_ANO integer, @P_RDate smalldatetime)       
AS       
Declare @PMLAmount as Float
Declare @PML as Float
Declare @PCTLOSS as Float


Select @PMLAmount=Max(RCover.PMLAmount), @PML=Max(RCover.PML), @PCTLOSS=Max(RCover.PCTLOSS)
from Acceptance
Inner Join ICover I2 on (I2.ANO=Acceptance.ANO and I2.Category='M')
Inner Join ICalc I1 on (I1.INO=I2.INO and I1.SDate<=@P_RDate and ((I1.EDate=Acceptance.EDate and @P_RDate<=I1.EDate) or (@P_RDate<I1.EDate)))
Inner Join RCover on (RCover.ANO=I1.ANO and RCover.Code=I1.Code and RCover.SDate=I1.SDate)
Where Acceptance.ANO=@P_ANO

SELECT  
SUM(
	CASE 
	WHEN COALESCE(R.LOLBASED,0)=0 THEN ICOVER.AMOUNT*coalesce(@PCTLOSS,100)/100*PCALC.RATE
	WHEN COALESCE(R.LOLBASED,0)=1 THEN ICOVER.SI*coalesce(@PCTLOSS,100)/100*PCALC.RATE
	WHEN COALESCE(R.LOLBASED,0)=2 THEN ICOVER.EML*PCALC.RATE
	ELSE 0 END
) AS AMOUNT, 
Case 
When sum(ICOVER.AMOUNT)=0 Then Max(coalesce(@PML,100)) 
When Max(coalesce(@PMLAMOUNT,0))/sum(ICOVER.AMOUNT)*100=0 then Max(coalesce(@PML,100)) 
Else Max(coalesce(@PMLAMOUNT,0))/sum(ICOVER.AMOUNT)*100 
end as PML,
Max(coalesce(@PCTLOSS,100)) as PCTLOSS       
From ICOVER       
INNER JOIN PCALC ON (PCALC.ANO=ICOVER.ANO AND PCALC.CURRENCY=ICOVER.CURRENCY)
INNER JOIN RARRHEADER R ON (R.ANO=ICOVER.ANO)
WHERE  ICOVER.ANO=@P_ANO AND ICOVER.CATEGORY='M'       


go
