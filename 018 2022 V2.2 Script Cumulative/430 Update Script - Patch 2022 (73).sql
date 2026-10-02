DROP FUNCTION PREMIUM_CALCULATION_BASE
GO
CREATE FUNCTION PREMIUM_CALCULATION_BASE(@P_ANO int)                  

RETURNS @PCALC TABLE (ANO Int, Currency varchar(10), CANO int, Code varchar(10), SDate SmallDatetime, EDate SmallDatetime, PolicyYear Int, NoRefundF Int, MinimumPremiumF Bit, Premium Float)
AS
BEGIN

Declare @CalculationRoundingF Bit
Select @CalculationRoundingF=CalculationRoundingF from systab

DECLARE @ACCEPTANCE TABLE (ANO Int, CNO Int, SDate SmallDateTime, EDate SmallDateTime, STime Varchar(5), ETime varchar(5), NOREFUNDF Int, RefundType Varchar(255), EXCLUSIVEF Bit, AType varchar(10), PDate SmallDateTime, CPCT Float, QTY Int, PANO Int, EMethod varchar(1))
INSERT INTO @ACCEPTANCE
SELECT ANO, CNO, SDATE, EDate, STime, ETime, NOREFUNDF, RefundType, EXCLUSIVEF, ATYPE, PDATE, CPCT, QTY, PANO, EMETHOD 
FROM ACCEPTANCE WHERE ANO=@P_ANO

INSERT INTO @PCALC
Select ANO, Currency, CANO, Code, SDate, EDate, PolicyYear, NoRefundF, Cast(Max(MinimumPremiumF) as Bit) as MinimumPremiumF, sum(Premium) as Premium
 from (                  
  select Acceptance.ANO, RCalc.Currency, @P_ANO as CANO, RCalc.Code,  RCalc.SDate, RCalc.Edate, cast(datediff(Month,Acceptance.SDate, RCalc.SDate) as integer) / 12 + 1  as PolicyYear,          
  Acceptance.NoRefundF,   
  Case When Upper(PCALC.DESCRIPTION) in ('MINIMUM PREMIUM','POLICY MINIMUM PREMIUM') Then 1 else 0 end as MinimumPremiumF,                                       
  case                  
  When Acceptance.Atype<>'N' and Acceptance.NoRefundF<>12 and not (Acceptance.NoRefundF=13 and charindex((case when Cover.ISType in ('I','L') Then 'DI' else 'I'+Cover.ISType end),Acceptance.RefundType)<>0) and (RCover.NoRefundF=1 or Acceptance.NoRefundF in (2,4) or (Acceptance.NoRefundF in (1) and DateDiff(day, acceptance.pdate, RCalc.SDate) <= 0)) Then 0
  When Acceptance.AType<>'N' then                  
   case                  
   when DateDiff(day, rcalc.Edate, acceptance.pdate)>=0 then 0                  
   when DateDiff(day, acceptance.pdate, rcalc.SDate)>0 then 1                  
   Else                  
    case                  
    when acceptance.cpct<>0 or Cover.Voyage=1 then                  
     case                  
     when acceptance.cpct<>0 then                  
		acceptance.cpct/100                  
     Else                  
		1                  
     End                  
    Else                  
		--Prorata Calculation
		Case When Acceptance.EXCLUSIVEF=0 and Acceptance.STime<Acceptance.ETime and RCalc.EDate=Acceptance.EDate Then
			dbo.fn_calc_prorata(acceptance.pDate, dateadd(day,1,RCalc.edate), RCalc.Sdate, dateadd(day,1,RCalc.edate), Cover.PPeriod)
		else
			dbo.fn_calc_prorata(acceptance.pDate, RCalc.Edate, RCalc.Sdate, RCalc.EDate, Cover.PPeriod)
		End
    End                  
   End                  
  Else                  
	1                  
  End                  
  * (Case When Acceptance.Qty=0 Then 1 else Acceptance.Qty end)                  
  * (Case When PCALC.DESCRIPTION='Minimum Premium' Then RCALC.GROSS else (Case When PCALC.OGROSS<>0 THEN RCALC.OGROSS*PCALC.GROSS/PCALC.OGROSS ELSE PCALC.GROSS END) END+RCalc.Reinstatement)  
  * coalesce(case When ISource.Limit<>0 then ISource.Limit/(ISource.Limit+ISource.Excess) else 1 end*ISource.Share/100,1) as Premium
  From @Acceptance acceptance
  Inner Join cover on (Cover.CNO=Acceptance.CNO)
  Inner Join RCalc on (RCalc.ANO=Acceptance.ANO)
  Inner Join RCover on (RCOVER.ANO=RCALC.ANO AND RCOVER.CODE=RCALC.CODE AND RCOVER.SDATE=RCALC.SDATE)
  Inner Join PCalc on (PCalc.ANO=RCalc.ANO and PCalc.Currency=RCalc.Currency)
  Left Join ISource on (ISource.CNO=Cover.CNO)
  Where Acceptance.ANO=@P_ANO 
  and Acceptance.AType not in ('A','C')                  
  and PCalc.Gross<>0          
                                                    
  Union All                  
                                                                                             
  select Acceptance.ANO, RCalc.Currency, Acceptance.PANO as CANO, RCalc.Code, RCalc.SDate, RCalc.Edate, cast(datediff(Month,pAcceptance.SDate, RCalc.SDate) as integer) / 12 + 1 as PolicyYear,          
  Acceptance.NoRefundF,   
  Case When Upper(PCALC.DESCRIPTION) in ('MINIMUM PREMIUM','POLICY MINIMUM PREMIUM') Then 1 else 0 end as MinimumPremiumF,                                       
  -case     
  When Acceptance.Atype<>'N' and Acceptance.NoRefundF<>12 and not (Acceptance.NoRefundF=13 and charindex((case when Cover.ISType in ('I','L') Then 'DI' else 'I'+Cover.ISType end),Acceptance.RefundType)<>0) and (coalesce(RCover.NoRefundF,0)=1 or Acceptance.NoRefundF in (2,4) or (Acceptance.NoRefundF in (1) and DateDiff(day, acceptance.pdate, RCalc.SDate) <= 0)) Then 0
  when DateDiff(day, rcalc.Edate, acceptance.pdate)>=0 and acceptance.pdate between pacceptance.sdate and pacceptance.edate then 0                  
  when DateDiff(day, acceptance.pdate, rcalc.SDate)>0 and acceptance.pdate between pacceptance.sdate and pacceptance.edate then 1                  
  Else                  
   case                  
   when acceptance.cpct<>0 or Cover.Voyage=1 then                  
    case                  
    when acceptance.cpct<>0 then                  
		acceptance.cpct/100                  
    Else                  
		1                  
    End                  
   Else                  
    case                  
    When Acceptance.SDate<>Acceptance.PDate or Acceptance.NoRefundF=6 then                  
		--Prorata Calculation
		Case When pAcceptance.EXCLUSIVEF=0 and pAcceptance.STime<pAcceptance.ETime and RCalc.EDate=pAcceptance.EDate Then
			CASE WHEN RCOVER.CPFORMULA='PRORATE SQ' and Acceptance.AType='C' and Acceptance.EMethod<>'A' THEN
				POWER(dbo.fn_calc_prorata(dbo.fn_Get_Effective_Cancellation_By_Payor_Schedule(Acceptance.ANO, Acceptance.PDate,dateadd(day,1,RCalc.edate)), dateadd(day,1,RCalc.edate), RCalc.Sdate, dateadd(day,1,RCalc.edate), Cover.PPeriod), 2)
			ELSE
				CASE WHEN Acceptance.AType='C' and Acceptance.EMethod<>'A' THEN
					dbo.fn_calc_prorata(dbo.fn_Get_Effective_Cancellation_By_Payor_Schedule(Acceptance.ANO, Acceptance.PDate,dateadd(day,1,RCalc.edate)), dateadd(day,1,RCalc.edate), RCalc.Sdate, dateadd(day,1,RCalc.edate), Cover.PPeriod)
				Else
					dbo.fn_calc_prorata(acceptance.pDate, dateadd(day,1,RCalc.edate), RCalc.Sdate, dateadd(day,1,RCalc.edate), Cover.PPeriod)
				End
			END			
		else
			CASE WHEN RCOVER.CPFORMULA='PRORATE SQ' and Acceptance.AType='C' and Acceptance.EMethod<>'A' THEN
				POWER(dbo.fn_calc_prorata(dbo.fn_Get_Effective_Cancellation_By_Payor_Schedule(Acceptance.ANO, Acceptance.PDate,RCalc.Edate), RCalc.Edate, RCalc.Sdate, RCalc.EDate, Cover.PPeriod), 2)
			ELSE
				CASE WHEN Acceptance.AType='C' and Acceptance.EMethod<>'A' THEN
					dbo.fn_calc_prorata(dbo.fn_Get_Effective_Cancellation_By_Payor_Schedule(Acceptance.ANO, Acceptance.PDate,RCalc.Edate), RCalc.Edate, RCalc.Sdate, RCalc.EDate, Cover.PPeriod)
				Else
					dbo.fn_calc_prorata(acceptance.pDate, RCalc.Edate, RCalc.Sdate, RCalc.EDate, Cover.PPeriod)
				End
			END			
		End
    Else                  
    -- Endorsement Period                  
		1                  
    End                  
   End                  
  End                  
  * (Case When pAcceptance.Qty=0 Then 1 else pAcceptance.Qty end)                  
  * (Case When PCALC.DESCRIPTION='Minimum Premium' Then RCALC.GROSS else (Case When PCALC.OGROSS<>0 THEN RCALC.OGROSS*PCALC.GROSS/PCALC.OGROSS ELSE PCALC.GROSS END) END+RCalc.Reinstatement)
  * coalesce(case When ISource.Limit<>0 then ISource.Limit/(ISource.Limit+ISource.Excess) else 1 end*ISource.Share/100,1) 
  * (Case When Acceptance.CPCT=0 and Acceptance.AType='C' and Acceptance.EMethod<>'A' and Acceptance.NoRefundF<>12 and not (Acceptance.NoRefundF=13 and charindex((case when Cover.ISType in ('I','L') Then 'DI' else 'I'+Cover.ISType end),Acceptance.RefundType)<>0) and RCover.CPRefund<>0 and Not (DateDiff(day, acceptance.pdate, rcalc.SDate)>0 and acceptance.pdate between pacceptance.sdate and pacceptance.edate) Then RCover.CPRefund/100 else 1 end) as Premium      
  from @Acceptance Acceptance 
  inner join Acceptance pAcceptance on (pAcceptance.ANO=Acceptance.pANO) 
  inner Join Cover on (Cover.CNO=pAcceptance.CNO)                  
  inner join PCalc on (PCalc.ANO=pAcceptance.ANO) 
  inner join RCalc on (RCalc.ANO=PCalc.ANO and RCalc.Currency=PCalc.Currency)                  
  Left Join ISource on (ISource.CNO=Cover.CNO)
  Left Join RCover on (RCover.ANO=Acceptance.ANO and RCover.Code=RCalc.Code and ((RCover.SDate=Acceptance.SDate and RCover.EDate=Acceptance.EDate and RCalc.SDate=pAcceptance.SDate and RCalc.EDate=pAcceptance.EDate) or (RCover.SDate=RCalc.SDate)))
  Where Acceptance.ANO=@P_ANO and Acceptance.AType<>'A' and Not (Acceptance.AType='C' and Acceptance.EMethod='A') and pAcceptance.AType not in ('A','C')                  
  and PCalc.Gross<>0                    
                                                    
  Union All                  
        
  select Acceptance.ANO, RCalc.Currency, @P_ANO as CANO, RCalc.Code, RCalc.SDate, RCalc.Edate, cast(datediff(Month,Acceptance.SDate, RCalc.SDate) as integer) / 12 + 1 as PolicyYear,      
  Acceptance.NoRefundF,       
  Case When Upper(PCALC.DESCRIPTION) in ('MINIMUM PREMIUM','POLICY MINIMUM PREMIUM') Then 1 else 0 end as MinimumPremiumF,                                       
  (Case When PCALC.DESCRIPTION='Minimum Premium' Then RCALC.GROSS else (Case When PCALC.OGROSS<>0 THEN RCALC.OGROSS*PCALC.GROSS/PCALC.OGROSS ELSE PCALC.GROSS END) END+RCalc.Reinstatement)
  * coalesce(case When ISource.Limit<>0 then ISource.Limit/(ISource.Limit+ISource.Excess) else 1 end*ISource.Share/100,1) as Premium
  From @Acceptance acceptance
  Inner Join RCALC on (RCalc.ANO=Acceptance.ANO)
  Inner Join PCalc on (PCalc.ANO=RCalc.ANO and PCalc.Currency=RCalc.Currency)
  Left Join Acceptance sAcceptance on (sAcceptance.ANO=RCalc.SANO) 
  Left Join ISource on (ISource.CNO=sAcceptance.CNO)
  Where Acceptance.ANO=@P_ANO 
  and Acceptance.AType='A'                  
  and PCalc.Gross<>0   
        
) T                  
                                      
Group By ANO, Currency, CANO, Code, SDate, EDate, PolicyYear, NoRefundF  

if @CalculationRoundingF=1 
	update @PCALC set Premium=dbo.RoundCCY(Premium,Currency)


RETURN

END

GO



DROP FUNCTION DISPLAY_CALCULATION
GO
CREATE FUNCTION DISPLAY_CALCULATION(@P_ANO int)                
RETURNS @PCALC TABLE (ANO Int, Code varchar(10), SDate smalldatetime, EDate smalldatetime, Gross Float, Prorata Float, Currency varchar(10), Premium_Calculation Varchar(Max), Prorata_Calculation Varchar(Max), Calculation Varchar(Max), Discount Float, Commission Float)
AS
BEGIN
Declare @CalculationRoundingF Bit
Select @CalculationRoundingF=CalculationRoundingF from systab

if @CalculationRoundingF=0
	insert into @PCalc
	Select A.ANO, D1.Code, D1.SDate, D1.EDate, D1.Gross, D2.Prorata, D1.Currency,  D1.Calculation as Premium_Calculation, D2.Prorata_Calculation,                
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
	Select A.ANO, D1.Code, D1.SDate, D1.EDate, D1.Gross, D2.Prorata, D1.Currency,  D1.Calculation as Premium_Calculation, D2.Prorata_Calculation,                
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

DROP FUNCTION DISPLAY_FACULTATIVE_CALCULATION
GO
CREATE FUNCTION DISPLAY_FACULTATIVE_CALCULATION(@P_ANO int, @P_FID varchar(20))            
RETURNS @PCALC TABLE (ANO Int, Code varchar(10), SDate smalldatetime, EDate smalldatetime, Gross Float, Prorata Float, Currency varchar(10), Premium_Calculation Varchar(Max), Prorata_Calculation Varchar(Max), Calculation Varchar(Max))
AS
BEGIN

Declare @CalculationRoundingF Bit
Select @CalculationRoundingF=CalculationRoundingF from systab

if @CalculationRoundingF=0
	INSERT INTO @PCALC
	Select A.ANO, CASE WHEN D1.FCODE<>'' THEN D1.FCODE ELSE D1.CODE END Code, D1.SDate, D1.EDate, D1.Gross, D2.Prorata, D1.Currency,  D1.Calculation as Premium_Calculation, D2.Prorata_Calculation,            
	D1.Calculation + Case When D2.Prorata=0 or D2.Prorata_Calculation='' Then '' else ' x '+D2.Prorata_Calculation end            
	+ Case When A.Qty>1 Then ' x '+ Convert(varchar(25), Cast(A.Qty as Int),1) Else '' end            
	+ ' = ' + Convert(varchar(50), Cast(D1.Gross*(Case When D2.Prorata<>0 or D2.Prorata_Calculation<>'' Then D2.Prorata else 1 end)*Case When A.Qty>1 Then A.Qty Else 1 End as Money),1) as Calculation      
	from Display_Gross_Facultative_Calculation(@P_ANO, @P_FID) D1, DISPLAY_FACULTATIVE_BALANCE_PRORATA_CALCULATION(@P_ANO, @P_FID) D2, Acceptance A 
	Where a.ANO = D1.ANO And D1.ANO = D2.ANO And D1.Currency = D2.Currency And D1.Code = D2.Code And D1.SDate = D2.SDate And D1.EDate = D2.EDate and D2.Prorata<>0 
Else
	INSERT INTO @PCALC
	Select A.ANO, CASE WHEN D1.FCODE<>'' THEN D1.FCODE ELSE D1.CODE END Code, D1.SDate, D1.EDate, D1.Gross, D2.Prorata, D1.Currency,  D1.Calculation as Premium_Calculation, D2.Prorata_Calculation,            
	D1.Calculation + Case When D2.Prorata=0 or D2.Prorata_Calculation='' Then '' else ' x '+D2.Prorata_Calculation end            
	+ Case When A.Qty>1 Then ' x '+ Convert(varchar(25), Cast(A.Qty as Int),1) Else '' end            
	+ ' = ' + Convert(varchar(50), Cast(dbo.RoundCCY(D1.Gross*(Case When D2.Prorata<>0 or D2.Prorata_Calculation<>'' Then D2.Prorata else 1 end)*Case When A.Qty>1 Then A.Qty Else 1 End, D1.Currency) as Money),1) as Calculation      
	from Display_Gross_Facultative_Calculation(@P_ANO, @P_FID) D1, DISPLAY_FACULTATIVE_BALANCE_PRORATA_CALCULATION(@P_ANO, @P_FID) D2, Acceptance A 
	Where a.ANO = D1.ANO And D1.ANO = D2.ANO And D1.Currency = D2.Currency And D1.Code = D2.Code And D1.SDate = D2.SDate And D1.EDate = D2.EDate and D2.Prorata<>0 

RETURN 

END
go



 insert into PatchVersioning
select '430 Update Script - Patch 2022 (73)',GETDATE()
go


Declare @PrevScript varchar(100)
Declare @CurrScript varchar(100)

Select @PrevScript=''
Select @CurrSCript='430 Update Script - Patch 2022 (73)'


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


