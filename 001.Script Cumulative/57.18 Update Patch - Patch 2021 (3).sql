
insert into PatchVersioning
select '57.18 Update Patch - Patch 2021 (3)',GETDATE()
go

Declare @PrevScript varchar(100)
Declare @CurrScript varchar(100)

Select @PrevScript=''
Select @CurrSCript='57.18 Update Patch - Patch 2021 (3)'


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
			DROP Procedure Reinsurance_Limit_Liability
       END TRY  
       BEGIN CATCH  
       END CATCH;


       Update SysTab Set ExecScript=@CurrScript, ExecScriptStatus='DONE'         
End


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
When Max(coalesce(@PMLAMOUNT,0))/sum(ICOVER.AMOUNT)*100=0 then Max(coalesce(@PML,100)) 
Else Max(coalesce(@PMLAMOUNT,0))/sum(ICOVER.AMOUNT)*100 
end as PML,
Max(coalesce(@PCTLOSS,100)) as PCTLOSS       
From ICOVER       
INNER JOIN PCALC ON (PCALC.ANO=ICOVER.ANO AND PCALC.CURRENCY=ICOVER.CURRENCY)
INNER JOIN RARRHEADER R ON (R.ANO=ICOVER.ANO)
WHERE  ICOVER.ANO=@P_ANO AND ICOVER.CATEGORY='M'       

GO
