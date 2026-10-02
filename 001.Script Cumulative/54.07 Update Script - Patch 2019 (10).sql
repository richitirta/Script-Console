IF EXISTS ( SELECT * FROM   sysobjects WHERE  id = object_id(N'Reinsurance_Limit_Liability') and OBJECTPROPERTY(id, N'IsProcedure') = 1 )
BEGIN
DROP Procedure Reinsurance_Limit_Liability
end
GO
CREATE Procedure Reinsurance_Limit_Liability(@P_ANO integer, @P_RDate smalldatetime)       
AS       
Declare @PMLAmount as Float
Declare @PML as Float
Declare @PCTLOSS as Float

Select Top 1 @PMLAmount=RCover.PMLAmount, @PML=RCover.PML, @PCTLOSS=RCover.PCTLOSS
from RCover, Acceptance
Where Acceptance.ANO=@P_ANO and RCover.ANO=Acceptance.ANO and RCover.Category='M' and RCover.SDate<=@P_RDate and ((RCover.EDate=Acceptance.EDate and @P_RDate<=RCover.EDate) or (@P_RDate<RCover.EDate))

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
Left JOIN RARRHEADER R ON (R.ANO=ICOVER.ANO)
inner join PCALC On (PCalc.ANO=ICover.ANO and PCalc.Currency=ICover.Currency)       
WHERE  ICOVER.ANO=@P_ANO AND ICOVER.CATEGORY='M'       

go


  insert into PatchVersioning
select '54.7 Update Script - Patch 2019 (10)',GETDATE()
go

Declare @PrevScript varchar(100)
Declare @CurrScript varchar(100)

Select @PrevScript='54.6 Update Script - Patch 2019 (9)'
Select @CurrSCript='54.7 Update Script - Patch 2019 (10)'


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


