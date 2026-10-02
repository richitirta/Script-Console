IF EXISTS ( SELECT * FROM   sysobjects WHERE  id = object_id(N'QOverlapped_Risk') and OBJECTPROPERTY(id, N'IsProcedure') = 1 )
BEGIN
DROP Procedure QOverlapped_Risk
END
GO
CREATE Procedure QOverlapped_Risk(@P_ANO integer) 
as 
Select Top 1 A1.ANO 
from RCover R1, Acceptance A1 
Where A1.ANO=@P_ANO and A1.ANO=R1.ANO and R1.Category='M' 
and not ((R1.SDate=A1.SDate or  R1.SDate=A1.PDate) and R1.EDate=A1.EDate) 
and Exists
( 
Select Top 1 R2.ANO 
from RCover R2 
Where R2.ANO=R1.ANO and R2.Category='M' 
and not (R2.ANO=R1.ANO and R2.Code=R1.Code and R2.Sdate=R1.Sdate) 
and 
( 
(R2.Sdate<R1.Edate and R2.Edate>=R1.Edate) or (R2.Sdate<=R1.Sdate and R2.Edate>R1.Sdate) or 
(R1.Sdate<=R2.Sdate and R1.Edate>R2.Sdate) or (R1.Sdate<R2.Edate and R1.Edate>=R2.Edate) 
) 
) 


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
select '55.32 Update Script - Patch 2020 (32)',GETDATE()
go


Declare @PrevScript varchar(100)
Declare @CurrScript varchar(100)

Select @PrevScript='55.31 Update Script - Patch 2020 (31)'
Select @CurrSCript='55.32 Update Script - Patch 2020 (32)'


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








