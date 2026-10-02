DROP FUNCTION DISPLAY_GROSS_CALCULATION
GO
CREATE FUNCTION DISPLAY_GROSS_CALCULATION(@P_ANO int)      
RETURNS TABLE  AS      
RETURN (      
Select ICalc.ANO, ICalc.Currency, ICalc.Code, ICalc.SDate, ICalc.EDate, Max(ICalc.INO) as INO, sum(ICalc.Gross) as Gross, sum(ICalc.TSI) as TSI,     
Calculation=      
Case When Max(ICalc.SRate)<>'Flat' then convert(varchar(25),Cast(sum(ICalc.TSI) as Money),1) + ' x ' + (case When Max(RCover.Unit)='C' then convert(varchar(25), Cast(sum(ICalc.Rate*100)/Count(*) as Numeric(38,8)),2)+'%' else convert(varchar(25), Cast(sum(ICalc.Rate*1000)/Count(*) as Numeric(38,8)),3)+'‰' end) else convert(varchar(25), Cast(sum(ICalc.Rate) as Money),1) end +      
Case When Max(ICalc.sProrata)<>'' then ' x '+Max(ICalc.sProrata) else '' end +      
Case When Max(ICalc.SRate)<>'Flat' and ICalc.PCTAdj<>100 then ' x '+Cast(Icalc.PCTAdj as varchar(10))+'%' else '' end +
Case When Max(cast(Case When ICalc.LMFactor=0 Then 1 Else ICalc.LMFactor End as Numeric(38,8)))<>1 Then ' x '+cast(Max(cast(Case When ICalc.LMFactor=0 Then 1 Else ICalc.LMFactor End as Numeric(38,8))) as varchar(10)) else '' end
From      
(
Select ICalc.ANO, ICalc.INO, ICalc.Currency, ICalc.Code, ICalc.SDate, ICalc.EDate, Case When ICalc.SRate='Flat' then 100 else ICalc.PCTAdj end as PCTAdj, sum(ICalc.Gross) as Gross, Max(ICalc.SRate) as SRate, Max(ICalc.TSI) as TSI, sum(ICalc.Rate) as Rate, Max(ICalc.sProrata) as sProrata, Max(coalesce(ICALC.LMFACTOR,0)) as LMFACTOR      
from ICalc, Acceptance Where ICalc.ANO=Acceptance.ANO and Acceptance.ANO=@P_ANO and ICalc.Rate<>0      
Group By ICalc.ANO, ICalc.INO, ICalc.Currency, ICalc.Code, ICalc.SDate, ICalc.EDate, Case When ICalc.SRate='Flat' then 100 else ICalc.PCTAdj end      
) ICalc, RCover      
Where RCOVER.ANO = ICALC.ANO And RCOVER.Code = ICALC.Code And RCOVER.SDate = ICALC.SDate And RCOVER.EDate = ICALC.EDate      
Group By ICalc.ANO, ICalc.Currency, ICalc.Code, ICalc.SDate, ICalc.EDate, ICalc.PCTadj      
                
Union All      
                
Select ICalc.ANO, ICalc.Currency, ICalc.Code, ICalc.SDate, ICalc.EDate, Max(ICalc.INO) as INO, -sum(ICalc.Gross) as Gross, sum(ICalc.TSI) as TSI,     
Calculation='- '+      
Case When Max(ICalc.SRate)<>'Flat' then convert(varchar(25),Cast(sum(ICalc.TSI) as Money),1) + ' x ' + (case When Max(RCover.Unit)='C' then convert(varchar(25), Cast(sum(ICalc.Rate*100)/Count(*) as Numeric(38,8)),2)+'%' else convert(varchar(25), Cast(sum(ICalc.Rate*1000)/Count(*) as Numeric(38,8)),3)+'‰' end) else convert(varchar(25), Cast(sum(ICalc.Rate) as Money),1) end +      
Case When Max(ICalc.sProrata)<>'' then ' x '+Max(ICalc.sProrata) else '' end +      
Case When Max(ICalc.SRate)<>'Flat' and ICalc.PCTAdj<>100 then ' x '+Cast(Icalc.PCTAdj as varchar(10))+'%' else '' end +  
Case When Max(cast(Case When ICalc.LMFactor=0 Then 1 Else ICalc.LMFactor End as Numeric(38,8)))<>1 Then ' x '+cast(Max(cast(Case When ICalc.LMFactor=0 Then 1 Else ICalc.LMFactor End as Numeric(38,8))) as varchar(10)) else '' end 
From      
(
Select Acceptance.AType, Acceptance.EMethod, ICalc.ANO, ICalc.INO, ICalc.Currency, ICalc.Code, ICalc.SDate, ICalc.EDate, Case When ICalc.SRate='Flat' then 100 else ICalc.PCTAdj end as PCTAdj, sum(ICalc.Gross) as Gross, Max(ICalc.SRate) as SRate, Max(ICalc.TSI) as TSI, sum(ICalc.Rate) as Rate, Max(ICalc.sProrata) as sProrata, Max(coalesce(ICALC.LMFACTOR,0)) as LMFACTOR      
from ICalc, Acceptance Where ICalc.ANO=Acceptance.PANO and Acceptance.ANO=@P_ANO and ICalc.Rate<>0      
Group By Acceptance.AType, Acceptance.EMethod, ICalc.ANO, ICalc.INO, ICalc.Currency, ICalc.Code, ICalc.SDate, ICalc.EDate, Case When ICalc.SRate='Flat' then 100 else ICalc.PCTAdj end      
) ICalc, RCover      
Where RCOVER.ANO = ICALC.ANO And RCOVER.Code = ICALC.Code And RCOVER.SDate = ICALC.SDate And RCOVER.EDate = ICALC.EDate      
Group By ICalc.ANO, ICalc.Currency, ICalc.Code, ICalc.SDate, ICalc.EDate, ICalc.PCTadj      
      
Union All      
        
Select ICalc.ANO, ICalc.Currency, ICalc.Code, ICalc.SDate, ICalc.EDate, Max(ICalc.INO) as INO, sum(ICalc.Gross) as Gross, sum(ICalc.TSI) as TSI,     
Calculation=      
Case When Max(ICalc.SRate)<>'Flat' then convert(varchar(25),Cast(sum(ICalc.TSI) as Money),1) + ' x ' + (case When Max(RCover.Unit)='C' then convert(varchar(25), Cast(sum(ICalc.Rate*100)/Count(*) as Numeric(38,8)),2)+'%' else convert(varchar(25), Cast(sum(ICalc.Rate*1000)/Count(*) as Numeric(38,8)),3)+'‰' end) else convert(varchar(25), Cast(sum(ICalc.Rate) as Money),1) end +      
Case When Max(ICalc.sProrata)<>'' then ' x '+Max(ICalc.sProrata) else '' end +      
Case When Max(ICalc.SRate)<>'Flat' and ICalc.PCTAdj<>100 then ' x '+Cast(Icalc.PCTAdj as varchar(10))+'%' else '' end +
Case When Max(cast(Case When ICalc.LMFactor=0 Then 1 Else ICalc.LMFactor End as Numeric(38,8)))<>1 Then ' x '+cast(Max(cast(Case When ICalc.LMFactor=0 Then 1 Else ICalc.LMFactor End as Numeric(38,8))) as varchar(10)) else '' end
From      
(
Select ICalc.ANO, ICalc.INO, ICalc.Currency, ICalc.Code, ICalc.SDate, ICalc.EDate, Case When ICalc.SRate='Flat' then 100 else ICalc.PCTAdj end as PCTAdj, sum(ICalc.Reinstatement) as Gross, Max(ICalc.SRate) as SRate, Max(ICalc.Indemnity) as TSI, sum(ICalc.Rate) as Rate, Max(ICalc.sProrata) as sProrata, Max(coalesce(ICALC.LMFACTOR,0)) as LMFACTOR      
from ICalc, Acceptance Where Acceptance.EMethod='R' and ICalc.ANO=Acceptance.ANO and Acceptance.ANO=@P_ANO and ICalc.Rate<>0      
Group By ICalc.ANO, ICalc.INO, ICalc.Currency, ICalc.Code, ICalc.SDate, ICalc.EDate, Case When ICalc.SRate='Flat' then 100 else ICalc.PCTAdj end      
) ICalc, RCover      
Where RCOVER.ANO = ICALC.ANO And RCOVER.Code = ICALC.Code And RCOVER.SDate = ICALC.SDate And RCOVER.EDate = ICALC.EDate      
Group By ICalc.ANO, ICalc.Currency, ICalc.Code, ICalc.SDate, ICalc.EDate, ICalc.PCTadj      
)     


GO

DROP FUNCTION DISPLAY_CALCULATION
GO
CREATE FUNCTION DISPLAY_CALCULATION(@P_ANO int)                
RETURNS @PCALC TABLE (ANO Int, INO Int, Code varchar(10), SDate smalldatetime, EDate smalldatetime, Gross Float, TSI Float, Prorata Float, Currency varchar(10), Premium_Calculation Varchar(Max), Prorata_Calculation Varchar(Max), Calculation Varchar(Max), Discount Float, Commission Float)
AS
BEGIN
Declare @CalculationRoundingF Bit
Select @CalculationRoundingF=CalculationRoundingF from systab

if @CalculationRoundingF=0
	insert into @PCalc
	Select A.ANO, D1.INO, D1.Code, D1.SDate, D1.EDate, D1.Gross, D1.TSI, D2.Prorata, D1.Currency,  D1.Calculation as Premium_Calculation, D2.Prorata_Calculation,                
	D1.Calculation     
	+ Case When D2.Prorata=0 or D2.Prorata_Calculation='' Then '' else ' x '+D2.Prorata_Calculation end                
	+ Case When A.Qty>1 Then ' x '+ Convert(varchar(25), Cast(A.Qty as Int),1) Else '' end                
	+ ' = '     
	+ 
	Case 
	When convert(varchar(50), cast(D1.Gross*(Case When D2.Prorata<>0 or D2.Prorata_Calculation<>'' Then D2.Prorata else 1 end)*Case When A.Qty>1 Then A.Qty Else 1 End as Money),1)<>'0.00' Then
		convert(varchar(50), cast(D1.Gross*(Case When D2.Prorata<>0 or D2.Prorata_Calculation<>'' Then D2.Prorata else 1 end)*Case When A.Qty>1 Then A.Qty Else 1 End as Money),1)
	else
		convert(varchar(50), D1.Gross*(Case When D2.Prorata<>0 or D2.Prorata_Calculation<>'' Then D2.Prorata else 1 end)*Case When A.Qty>1 Then A.Qty Else 1 End,1)
	end
	as Calculation,                
	dbo.Premium_Discount(D1.ANO, D1.Code,cast(datediff(Month,A.SDate, D1.SDate) as integer) / 12 + 1) as Discount, dbo.Premium_Commission(D1.ANO, D1.Code,cast(datediff(Month,A.SDate, D1.SDate) as integer) / 12 + 1,0) as Commission                
	from Display_Gross_Calculation(@P_ANO) D1, Display_Prorata_Calculation(@P_ANO) D2, Acceptance A                
	Where a.ANO = D1.ANO And D1.ANO = D2.ANO And D1.Currency = D2.Currency And D1.Code = D2.Code And D1.SDate = D2.SDate And D1.EDate = D2.EDate and D2.Prorata<>0                 
else
	insert into @PCalc
	Select A.ANO, D1.INO, D1.Code, D1.SDate, D1.EDate, D1.Gross, D1.TSI, D2.Prorata, D1.Currency,  D1.Calculation as Premium_Calculation, D2.Prorata_Calculation,                
	D1.Calculation     
	+ Case When D2.Prorata=0 or D2.Prorata_Calculation='' Then '' else ' x '+D2.Prorata_Calculation end                
	+ Case When A.Qty>1 Then ' x '+ Convert(varchar(25), Cast(A.Qty as Int),1) Else '' end                
	+ ' = '     
	+ 
	Case 
	When convert(varchar(50), cast(dbo.RoundCCY(D1.Gross*(Case When D2.Prorata<>0 or D2.Prorata_Calculation<>'' Then D2.Prorata else 1 end)*Case When A.Qty>1 Then A.Qty Else 1 End, D1.Currency) as Money),1)<>'0.00' Then
		convert(varchar(50), cast(dbo.RoundCCY(D1.Gross*(Case When D2.Prorata<>0 or D2.Prorata_Calculation<>'' Then D2.Prorata else 1 end)*Case When A.Qty>1 Then A.Qty Else 1 End, D1.Currency) as Money),1)
	else
		convert(varchar(50), dbo.RoundCCY(D1.Gross*(Case When D2.Prorata<>0 or D2.Prorata_Calculation<>'' Then D2.Prorata else 1 end)*Case When A.Qty>1 Then A.Qty Else 1 End, D1.Currency),1)
	end
	as Calculation,                
	dbo.Premium_Discount(D1.ANO, D1.Code,cast(datediff(Month,A.SDate, D1.SDate) as integer) / 12 + 1) as Discount, dbo.Premium_Commission(D1.ANO, D1.Code,cast(datediff(Month,A.SDate, D1.SDate) as integer) / 12 + 1,0) as Commission                
	from Display_Gross_Calculation(@P_ANO) D1, Display_Prorata_Calculation(@P_ANO) D2, Acceptance A                
	Where a.ANO = D1.ANO And D1.ANO = D2.ANO And D1.Currency = D2.Currency And D1.Code = D2.Code And D1.SDate = D2.SDate And D1.EDate = D2.EDate and D2.Prorata<>0                 


RETURN 

END



GO


 insert into PatchVersioning	
select '708 Update Script - Patch 2023 (73)',GETDATE()
go





Declare @PrevScript varchar(100)
Declare @CurrScript varchar(1004)

Select @PrevScript=''
Select @CurrSCript='708 Update Script - Patch 2023 (73)'


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
