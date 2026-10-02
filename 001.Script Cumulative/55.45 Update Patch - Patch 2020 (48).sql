
IF EXISTS(SELECT * FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS WHERE TABLE_NAME='RCalc' AND CONSTRAINT_NAME='I_RCALC')
BEGIN
Alter Table RCalc drop Constraint I_RCALC
--DROP INDEX I_RCALC ON RCalc
END
GO
IF NOT EXISTS (SELECT *  FROM sys.indexes WHERE name='I_RCALC' AND object_id = OBJECT_ID('RCalc'))
BEGIN
Create Unique Index I_RCALC on RCALC(ANO,CODE,SDATE, Currency, TOR, SANO)
END
GO

IF EXISTS (SELECT *  FROM sys.indexes WHERE name='I_ICALC' AND object_id = OBJECT_ID('ICALC'))
BEGIN
Alter Table ICALC drop Constraint I_ICALC
--DROP INDEX I_ICALC ON ICALC 
END
GO
IF EXISTS (SELECT *  FROM sys.indexes WHERE name='I_ICALC' AND object_id = OBJECT_ID('ICALC'))
BEGIN
Create Unique Index I_ICALC on ICALC(ANO,CODE,SDATE, INO, Currency, TOR, SANO)
END
GO
IF EXISTS ( SELECT * FROM   sysobjects WHERE  id = object_id(N'Reinsurance_Limit_Liability') and OBJECTPROPERTY(id, N'IsProcedure') = 1 )
BEGIN
DROP Procedure Reinsurance_Limit_Liability
END
GO
CREATE Procedure Reinsurance_Limit_Liability(@P_ANO integer, @P_RDate smalldatetime)       
AS       
Declare @PMLAmount as Float
Declare @PML as Float
Declare @PCTLOSS as Float

Select @PMLAmount=Max(RCover.PMLAmount), @PML=Max(RCover.PML), @PCTLOSS=Max(RCover.PCTLOSS)
from RCover, Acceptance
Where Acceptance.ANO=@P_ANO and RCover.ANO=Acceptance.ANO and RCover.SDate<=@P_RDate and ((RCover.EDate=Acceptance.EDate and @P_RDate<=RCover.EDate) or (@P_RDate<RCover.EDate))
and exists (
	Select Top 1 I1.Code 
	from ICALC I1, ICOVER I2
	Where I1.ANO=RCover.ANO and I1.Code=RCover.Code and I1.SDate=RCover.SDate 
	and I2.INO=I1.INO and I2.Category='M'
)
	
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


GO


insert into PatchVersioning
select '55.45 Update Patch - Patch 2020 (48)',GETDATE()
go


Declare @PrevScript varchar(100)
Declare @CurrScript varchar(100)

Select @PrevScript=''
Select @CurrSCript='55.45 Update Patch - Patch 2020 (48)'


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


