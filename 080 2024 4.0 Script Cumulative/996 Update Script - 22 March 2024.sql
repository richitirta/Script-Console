
if exists (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'DISPLAY_PRORATA_CANCELLATION_CALCULATION') AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) )
BEGIN
DROP FUNCTION DISPLAY_PRORATA_CANCELLATION_CALCULATION
end
GO
CREATE FUNCTION DISPLAY_PRORATA_CANCELLATION_CALCULATION(@P_ANO int, @P_PDate as smalldatetime, @P_CPCT Float, @P_NoRefundF Int, @P_RefundType varchar(255))          
RETURNS TABLE  AS          
RETURN (                   
select          
Distinct          
RCalc.ANO,          
RCalc.Code,          
RCalc.Currency,          
RCalc.SDate,          
RCalc.EDate,          
Prorata_Calculation=          
case          
when DateDiff(day, rcalc.Edate, @P_PDate)>=0 and @P_PDate between pacceptance.sdate and pacceptance.edate then ''          
when DateDiff(day, @P_PDate, rcalc.SDate)>0 and @P_PDate between pacceptance.sdate and pacceptance.edate then ''          
  
Else          
  case          
  when @P_CPCT<>0 or Cover.Voyage=1 then          
    case when @P_CPCT<>0 and @P_CPCT<>100 then convert(varchar(25),Cast(@P_CPCT as float),0)+'%' else '' end          
  Else          
    case          
  When Acceptance.SDate<>@P_PDate or @P_NoRefundF=6 then          
   --Prorata Calculation  
   Case When pAcceptance.EXCLUSIVEF=0 and pAcceptance.STime<pAcceptance.ETime and RCalc.EDate=pAcceptance.EDate Then  
    CASE WHEN RCOVER.CPFORMULA = 'PRORATE SQ' and Acceptance.AType='C' and Acceptance.EMethod<>'A' THEN  
     '('+dbo.fn_Calc_SProrata(dbo.fn_Get_Effective_Cancellation_By_Payor_Schedule(Acceptance.ANO, @P_PDate,dateadd(day,1,RCalc.edate)), dateadd(day,1,RCalc.edate), RCalc.Sdate, dateadd(day,1,RCalc.edate), Cover.PPeriod)+') ^ 2'  
    ELSE  
     CASE WHEN Acceptance.AType='C' and Acceptance.EMethod<>'A' THEN  
      dbo.fn_Calc_SProrata(dbo.fn_Get_Effective_Cancellation_By_Payor_Schedule(Acceptance.ANO, @P_PDate,dateadd(day,1,RCalc.edate)), dateadd(day,1,RCalc.edate), RCalc.Sdate, dateadd(day,1,RCalc.edate), Cover.PPeriod)  
     Else  
      dbo.fn_Calc_SProrata(@P_PDate, dateadd(day,1,RCalc.edate), RCalc.Sdate, dateadd(day,1,RCalc.edate), Cover.PPeriod)  
     End  
    END      
   else  
    CASE WHEN RCOVER.CPFORMULA = 'PRORATE SQ' and Acceptance.AType='C' and Acceptance.EMethod<>'A' THEN  
     '('+dbo.fn_Calc_SProrata(dbo.fn_Get_Effective_Cancellation_By_Payor_Schedule(Acceptance.ANO, @P_PDate,RCalc.Edate), RCalc.Edate, RCalc.Sdate, RCalc.EDate, Cover.PPeriod)+') ^ 2'  
    ELSE  
     CASE WHEN Acceptance.AType='C' and Acceptance.EMethod<>'A' THEN  
      dbo.fn_Calc_SProrata(dbo.fn_Get_Effective_Cancellation_By_Payor_Schedule(Acceptance.ANO, @P_PDate,RCalc.Edate), RCalc.Edate, RCalc.Sdate, RCalc.EDate, Cover.PPeriod)  
     Else  
      dbo.fn_Calc_SProrata(@P_PDate, RCalc.Edate, RCalc.Sdate, RCalc.EDate, Cover.PPeriod)  
     End  
    END      
   End  
  
  Else          
   -- Endorsement Period          
   ''          
  End         
 End          
End          
+   
(  
Case When @P_CPCT=0   
and Acceptance.AType='C' and Acceptance.EMethod<>'A'   
and @P_NoRefundF<>12   
and not (@P_NoRefundF=13 and charindex((case when Cover.ISType in ('I','L') Then 'DI' else 'I'+Cover.ISType end),@P_RefundType)<>0)   
and RCover.CPRefund<>0   
and not (DateDiff(day, @P_PDate, rcalc.SDate)>0 and @P_PDate between pacceptance.sdate and pacceptance.edate)   
Then ' x '+convert(varchar(25),RCover.CPRefund,0)+'%' else '' end  
)  
,          
Prorata=          
case          
when DateDiff(day, rcalc.Edate, @P_PDate)>=0 and @P_PDate between pacceptance.sdate and pacceptance.edate then 0          
when DateDiff(day, @P_PDate, rcalc.SDate)>0  and @P_PDate between pacceptance.sdate and pacceptance.edate then 1          
  
Else          
  case          
  when @P_CPCT<>0 or Cover.Voyage=1 then          
    case when @P_CPCT<>0 and @P_CPCT<>100 then @P_CPCT/100 else 1 end          
  Else          
    case          
  When Acceptance.SDate<>@P_PDate or @P_NoRefundF=6 then          
   --Prorata Calculation  
   Case When pAcceptance.EXCLUSIVEF=0 and pAcceptance.STime<pAcceptance.ETime and RCalc.EDate=pAcceptance.EDate Then  
    CASE WHEN RCOVER.CPFORMULA = 'PRORATE SQ' and Acceptance.AType='C' and Acceptance.EMethod<>'A' THEN  
     POWER(dbo.fn_calc_prorata(dbo.fn_Get_Effective_Cancellation_By_Payor_Schedule(Acceptance.ANO, @P_PDate,dateadd(day,1,RCalc.edate)), dateadd(day,1,RCalc.edate), RCalc.Sdate, dateadd(day,1,RCalc.edate), Cover.PPeriod),2)  
    ELSE  
     Case When Acceptance.AType='C' and Acceptance.EMethod<>'A' THEN  
      dbo.fn_calc_prorata(dbo.fn_Get_Effective_Cancellation_By_Payor_Schedule(Acceptance.ANO, @P_PDate,dateadd(day,1,RCalc.edate)), dateadd(day,1,RCalc.edate), RCalc.Sdate, dateadd(day,1,RCalc.edate), Cover.PPeriod)  
     Else  
      dbo.fn_calc_prorata(@P_PDate, dateadd(day,1,RCalc.edate), RCalc.Sdate, dateadd(day,1,RCalc.edate), Cover.PPeriod)  
     End  
    END      
   else  
    CASE WHEN RCOVER.CPFORMULA = 'PRORATE SQ' and Acceptance.AType='C' and Acceptance.EMethod<>'A' THEN  
     POWER(dbo.fn_calc_prorata(dbo.fn_Get_Effective_Cancellation_By_Payor_Schedule(Acceptance.ANO, @P_PDate,RCalc.Edate), RCalc.Edate, RCalc.Sdate, RCalc.EDate, Cover.PPeriod),2)  
    ELSE  
     Case When Acceptance.AType='C' and Acceptance.EMethod<>'A' THEN  
      dbo.fn_calc_prorata(dbo.fn_Get_Effective_Cancellation_By_Payor_Schedule(Acceptance.ANO, @P_PDate,RCalc.Edate), RCalc.Edate, RCalc.Sdate, RCalc.EDate, Cover.PPeriod)  
     Else  
      dbo.fn_calc_prorata(@P_PDate, RCalc.Edate, RCalc.Sdate, RCalc.EDate, Cover.PPeriod)  
     End  
    END      
   End  
  Else          
   -- Endorsement Period          
   1          
  End          
 End          
End          
* (Case When @P_CPCT=0 and Acceptance.AType='C' and Acceptance.EMethod<>'A' and @P_NoRefundF<>12 and not (@P_NoRefundF=13 and charindex((case when Cover.ISType in ('I','L') Then 'DI' else 'I'+Cover.ISType end),@P_RefundType)<>0) and RCover.CPRefund<>0 and not (DateDiff(day, @P_PDate, rcalc.SDate)>0 and @P_PDate between pacceptance.sdate and pacceptance.edate) Then RCover.CPRefund/100 else 1 end)  
  
From acceptance          
inner Join Cover on (Cover.CNO=Acceptance.CNO)          
inner join Acceptance pAcceptance on (pAcceptance.ANO=@P_ANO)          
inner join PCalc on (PCalc.ANO=pAcceptance.ANO)          
inner join RCalc on (RCalc.ANO=PCalc.ANO and RCalc.Currency=PCalc.Currency)          
Left Join RCover on (RCover.ANO=Acceptance.ANO and RCover.Code=RCalc.Code and ((RCover.SDate=Acceptance.SDate and RCover.EDate=Acceptance.EDate and RCalc.SDate=pAcceptance.SDate and RCalc.EDate=pAcceptance.EDate) or (RCover.SDate=RCalc.SDate)))  
Where Acceptance.AType<>'A' and Not (Acceptance.AType='C' and Acceptance.EMethod='A') and Not (Acceptance.AType='E' and Acceptance.EMethod='S') and pAcceptance.AType not in ('A','C')          
and Not (Acceptance.Atype<>'N' and @P_NoRefundF<>12 and not (@P_NoRefundF=13 and charindex((case when Cover.ISType in ('I','L') Then 'DI' else 'I'+Cover.ISType end),@P_RefundType)<>0) and (coalesce(RCover.NoRefundF,0)=1 or @P_NoRefundF in (2,4) or (@P_NoRefundF in (1) and DateDiff(day, @P_PDate, RCalc.SDate) <= 0)))  
and Not (DateDiff(day, rcalc.Edate, @P_PDate)>=0 and @P_PDate between pacceptance.sdate and pacceptance.edate)  
and Acceptance.ANO=@P_ANO          
)          
         
GO

DROP FUNCTION DISPLAY_GROSS_CANCELLATION_CALCULATION
GO
CREATE FUNCTION DISPLAY_GROSS_CANCELLATION_CALCULATION(@P_ANO int)        
RETURNS TABLE  AS        
RETURN (        
Select ICalc.ANO, ICalc.Currency, ICalc.Code, ICalc.SDate, ICalc.EDate, Max(ICalc.INO) as INO, -sum(ICalc.Gross) as Gross, sum(ICalc.TSI) as TSI,       
Calculation='- '+        
Case When Max(ICalc.SRate)<>'Flat' then convert(varchar(25),Cast(sum(ICalc.TSI) as Money),1) + ' x ' + (case When Max(RCover.Unit)='C' then convert(varchar(25), Cast(sum(ICalc.Rate*100)/Count(*) as Numeric(38,9)),2)+'%' else convert(varchar(25), Cast(sum(
ICalc.Rate*1000)/Count(*) as Numeric(38,9)),3)+'‰' end) else convert(varchar(25), Cast(sum(ICalc.Rate) as Money),1) end +        
Case When Max(ICalc.sProrata)<>'' then ' x '+Max(ICalc.sProrata) else '' end +        
Case When Max(ICalc.SRate)<>'Flat' and ICalc.PCTAdj<>100 then ' x '+Cast(Icalc.PCTAdj as varchar(10))+'%' else '' end +    
Case When Max(cast(Case When ICalc.LMFactor=0 Then 1 Else ICalc.LMFactor End as Numeric(38,9)))<>1 Then ' x '+cast(Max(cast(Case When ICalc.LMFactor=0 Then 1 Else ICalc.LMFactor End as Numeric(38,9))) as varchar(10)) else '' end   
From        
(  
Select Acceptance.AType, Acceptance.EMethod, ICalc.ANO, ICalc.INO, ICalc.Currency, ICalc.Code, ICalc.SDate, ICalc.EDate, Case When ICalc.SRate='Flat' then 100 else ICalc.PCTAdj end as PCTAdj, sum(ICalc.Gross) as Gross, Max(ICalc.SRate) as SRate, Max(ICalc.TSI) as TSI, sum(ICalc.Rate) as Rate, Max(ICalc.sProrata) as sProrata, Max(coalesce(ICALC.LMFACTOR,0)) as LMFACTOR        
from ICalc, Acceptance Where ICalc.ANO=Acceptance.ANO and Acceptance.ANO=@P_ANO and ICalc.Rate<>0        
Group By Acceptance.AType, Acceptance.EMethod, ICalc.ANO, ICalc.INO, ICalc.Currency, ICalc.Code, ICalc.SDate, ICalc.EDate, Case When ICalc.SRate='Flat' then 100 else ICalc.PCTAdj end        
) ICalc, RCover        
Where RCOVER.ANO = ICALC.ANO And RCOVER.Code = ICALC.Code And RCOVER.SDate = ICALC.SDate And RCOVER.EDate = ICALC.EDate        
Group By ICalc.ANO, ICalc.Currency, ICalc.Code, ICalc.SDate, ICalc.EDate, ICalc.PCTadj            
)       
  
GO

DROP FUNCTION DISPLAY_CANCELLATION_CALCULATION
GO
CREATE FUNCTION DISPLAY_CANCELLATION_CALCULATION(@P_ANO int, @P_PDate as smalldatetime, @P_CPCT Float, @P_NoRefundF Int, @P_RefundType varchar(255))          
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
	from Display_Gross_Cancellation_Calculation(@P_ANO) D1, Display_Prorata_Cancellation_Calculation(@P_ANO, @P_PDate, @P_CPCT, @P_NoRefundF, @P_RefundType) D2, Acceptance A                
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
	from Display_Gross_Cancellation_Calculation(@P_ANO) D1, Display_Prorata_Cancellation_Calculation(@P_ANO, @P_PDate, @P_CPCT, @P_NoRefundF, @P_RefundType) D2, Acceptance A                
	Where a.ANO = D1.ANO And D1.ANO = D2.ANO And D1.Currency = D2.Currency And D1.Code = D2.Code And D1.SDate = D2.SDate And D1.EDate = D2.EDate and D2.Prorata<>0                 


RETURN 

END


go







insert into PatchVersioning
select '996 Update Script - 22 March 2024',GETDATE()
go
	

Declare @PrevScript varchar(100)
Declare @CurrScript varchar(100)

Select @PrevScript=''
Select @CurrSCript='996 Update Script - 22 March 2024'


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