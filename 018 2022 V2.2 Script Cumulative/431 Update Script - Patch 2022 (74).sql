DROP Procedure Reinsurance_Limit_Liability
GO
CREATE Procedure Reinsurance_Limit_Liability(@P_ANO integer, @P_RDate smalldatetime)       
AS       
Declare @Acceptance table (ANO int, LANO Int, EDate Smalldatetime)
Declare @ICover table (ANO int, INO int, Currency varchar(10), Amount Float, SI Float, EML Float, PMLAmount Float, PML Float, PCTLOSS Float)
Declare @ICoverPOL table (ANO int, Currency varchar(10), Amount_POL Float)

insert into @Acceptance
Select ANO, LANO, EDate from Acceptance Where ANO=@P_ANO

insert into @ICoverPOL
Select Acceptance.ANO, coalesce(I3.Currency, mI3.Currency) as Currency, coalesce(I3.Amount, mI3.Amount) as Amount_POL
from @Acceptance Acceptance
Left Join  ICoverPOL I3 on (Acceptance.LANO=-1 and I3.ANO=Acceptance.ANO and I3.Amount<>0)
Left Join  ICoverPOL mI3 on (Acceptance.LANO<>-1 and mI3.ANO=Acceptance.LANO and mI3.Amount<>0)
Where Acceptance.ANO=@P_ANO

insert into @ICover
Select I2.ANO, I2.INO, Max(I2.Currency) as Currency, Max(I2.Amount) as Amount, Max(I2.SI) as SI, Max(I2.EML) as EML, Max(RCover.PMLAmount) as PMLAmount, Max(RCover.PML) as PML, Max(RCover.PCTLOSS) as PCTLOSS
from @Acceptance Acceptance
Inner Join ICover I2 on (I2.ANO=Acceptance.ANO and I2.Category='M')
Inner Join ICalc I1 on (I1.INO=I2.INO and I1.SDate<=@P_RDate and ((I1.EDate=Acceptance.EDate and @P_RDate<=I1.EDate) or (@P_RDate<I1.EDate)))
Inner Join RCover on (RCover.ANO=I1.ANO and RCover.Code=I1.Code and RCover.SDate=I1.SDate)
Where Acceptance.ANO=@P_ANO
Group By I2.ANO, I2.INO

SELECT  
CASE 
	WHEN MAX(COALESCE(R.LOLBASED,0))=0 THEN (CASE WHEN MAX(COALESCE(ICOVERPOL.AMOUNT_POL*PCALC.RATE,0))<>0 AND MAX(COALESCE(ICOVERPOL.AMOUNT_POL*PCALC.RATE,0))<SUM(ICOVER.AMOUNT*ICOVER.PCTLOSS/100*PCALC.RATE) THEN MAX(COALESCE(ICOVERPOL.AMOUNT_POL*PCALC.RATE,0)) ELSE SUM(ICOVER.AMOUNT*ICOVER.PCTLOSS/100*PCALC.RATE) END)
	WHEN MAX(COALESCE(R.LOLBASED,0))=1 THEN SUM(ICOVER.SI*ICOVER.PCTLOSS/100*PCALC.RATE)
	WHEN MAX(COALESCE(R.LOLBASED,0))=2 THEN SUM(ICOVER.EML*PCALC.RATE)
ELSE 0 
END AS AMOUNT,
Case 
When sum(ICOVER.AMOUNT)=0 Then Max(ICOVER.PML) 
When Max(ICOVER.PMLAMOUNT)/sum(ICOVER.AMOUNT)*100=0 then Max(ICOVER.PML) 
Else Max(ICOVER.PMLAMOUNT)/sum(ICOVER.AMOUNT)*100 
end as PML,
Max(ICOVER.PCTLOSS) as PCTLOSS       
From @ICover ICover
INNER JOIN PCALC ON (PCALC.ANO=ICOVER.ANO AND PCALC.CURRENCY=ICOVER.CURRENCY)
INNER JOIN RARRHEADER R ON (R.ANO=ICOVER.ANO)
LEFT JOIN @ICoverPOL ICOVERPOL ON (ICOVERPOL.ANO=PCALC.ANO AND ICOVERPOL.Currency=PCALC.CURRENCY)



go




 insert into PatchVersioning
select '431 Update Script - Patch 2022 (74)',GETDATE()
go


Declare @PrevScript varchar(100)
Declare @CurrScript varchar(100)

Select @PrevScript=''
Select @CurrSCript='431 Update Script - Patch 2022 (74)'


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




go


