IF EXISTS ( SELECT * FROM   sysobjects WHERE  id = object_id(N'PCALC02') and OBJECTPROPERTY(id, N'IsProcedure') = 1 )
BEGIN
DROP Procedure PCALC02
END
GO
CREATE Procedure PCALC02(@P_ANO integer)
AS
SELECT  ICOVER.CURRENCY, SUM(ICOVER.SI) AS TSI, SUM(ICOVER.AMOUNT) AS AMOUNT
From ICOVER
WHERE  ICOVER.ANO=@P_ANO AND ICOVER.CATEGORY='M'
AND EXISTS (SELECT TOP 1 ICALC.INO FROM ICALC WHERE ICALC.INO=ICOVER.INO)
GROUP BY ICOVER.CURRENCY
GO
DROP Procedure Reinsurance_Limit_Liability
GO
CREATE Procedure Reinsurance_Limit_Liability(@P_ANO integer, @P_RDate smalldatetime)       
AS       
Declare @PMLAmount as Float
Declare @PML as Float
Declare @PCTLOSS as Float

Select @PMLAmount=Max(RCover.PMLAmount), @PML=Max(RCover.PML), @PCTLOSS=Max(RCover.PCTLOSS)
from RCover, Acceptance
Where Acceptance.ANO=@P_ANO and RCover.ANO=Acceptance.ANO and RCover.SDate<=@P_RDate and ((RCover.EDate=Acceptance.EDate and @P_RDate<=RCover.EDate) or (@P_RDate<RCover.EDate))
and exists (Select Top 1 I2.Code from ICover I1, ICalc I2 Where I1.Category='M' and I1.INO=I2.INO and I2.Code=RCover.Code and I2.Sdate=RCover.Sdate)

SELECT  
SUM(
	CASE 
	WHEN COALESCE(R.LOLBASED,0)=0 THEN ICOVER.AMOUNT*coalesce(@PCTLOSS,100)/100*PCALC.RATE
	WHEN COALESCE(R.LOLBASED,0)=1 THEN ICOVER.SI*coalesce(@PCTLOSS,100)/100*PCALC.RATE
	WHEN COALESCE(R.LOLBASED,0)=2 THEN ICOVER.EML*PCALC.RATE
	ELSE 0 END
) AS AMOUNT, 
Case 
When Max(coalesce(@PMLAMOUNT,0))/sum(ICOVER.AMOUNT)*100=0 then Max(coalesce(@PML,100)) 
Else Max(coalesce(@PMLAMOUNT,0))/sum(ICOVER.AMOUNT)*100 
end as PML,
Max(coalesce(@PCTLOSS,100)) as PCTLOSS       
From ICOVER       
INNER JOIN PCALC ON (PCALC.ANO=ICOVER.ANO AND PCALC.CURRENCY=ICOVER.CURRENCY)
INNER JOIN RARRHEADER R ON (R.ANO=ICOVER.ANO)
WHERE  ICOVER.ANO=@P_ANO AND ICOVER.CATEGORY='M'       
AND EXISTS (SELECT TOP 1 ICALC.INO FROM ICALC WHERE ICALC.INO=ICOVER.INO)





GO

insert into PatchVersioning
select '55.6 Update Script - Patch 2020 (5)',GETDATE()
go


Declare @PrevScript varchar(100)
Declare @CurrScript varchar(100)

Select @PrevScript='55.5 Update Script - Patch 2020 (4)'
Select @CurrSCript='55.6 Update Script - Patch 2020 (5)'


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


