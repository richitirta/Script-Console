IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'RefundType' AND Object_ID = Object_ID(N'ACCEPTANCE'))
BEGIN
ALTER TABLE dbo.ACCEPTANCE ADD
	RefundType varchar(255) NULL
DECLARE @v sql_variant 
SET @v = N'List of Transaction Type to be refunded (see MPARAM)'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'ACCEPTANCE', N'COLUMN', N'RefundType'
end
GO

IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'AutoCancelF' AND Object_ID = Object_ID(N'Reason'))
BEGIN
ALTER TABLE dbo.Reason ADD
	AutoCancelF Bit Null
DECLARE @v sql_variant 
SET @v = N'Auto Cancel Flag (0 : Not Apply, 1 : Cancel Policy/Certificate)'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'Reason', N'COLUMN', N'AutoCancelF'
end
GO


IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'NOREFUNDF' AND Object_ID = Object_ID(N'Reason'))
BEGIN
ALTER TABLE dbo.Reason ADD
	NOREFUNDF smallint NULL
DECLARE @v sql_variant 
SET @v = N'No Refund Premium Flag (0 : Premium Refund If Cancelled, 1 : No Premium Refund, 2 : No Premium Refund All)'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'Reason', N'COLUMN', N'NOREFUNDF'
end
GO

IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'RefundType' AND Object_ID = Object_ID(N'Reason'))
BEGIN
ALTER TABLE dbo.Reason ADD
	RefundType varchar(255) NULL
DECLARE @v sql_variant 
SET @v = N'List of Transaction Type to be refunded (see MPARAM)'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'Reason', N'COLUMN', N'RefundType'
end

GO




DROP FUNCTION DISPLAY_PRORATA_CALCULATION
GO
CREATE FUNCTION DISPLAY_PRORATA_CALCULATION(@P_ANO int)        
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
When Acceptance.AType<>'N' then        

 case        
 when DateDiff(day, RCalc.Edate, acceptance.pdate)>=0 then ''
 when DateDiff(day, acceptance.pdate, RCalc.SDate)>0 then ''        
 Else        
  case        
  when acceptance.cpct<>0 or Cover.Voyage=1 then        
   case when acceptance.cpct<>0 and acceptance.cpct<>100 then convert(varchar(25),Cast(Acceptance.CPCT as float),0)+'%' else '' end        
  Else        
	--Prorata Calculation
	Case When Acceptance.EXCLUSIVEF=0 and Acceptance.STime<Acceptance.ETime and RCalc.EDate=Acceptance.EDate Then
		dbo.fn_calc_sprorata(acceptance.pDate, dateadd(day,1,RCalc.edate), RCalc.Sdate, dateadd(day,1,RCalc.edate), Cover.PPeriod)
	else
		dbo.fn_calc_sprorata(acceptance.pDate, RCalc.Edate, RCalc.Sdate, RCalc.EDate, Cover.PPeriod)
	End
  End
 End        
Else        
 ''        
end,        
          
Prorata=        
case        
When Acceptance.AType<>'N' then        
 case        
 when DateDiff(day, RCalc.Edate, acceptance.pdate)>=0 then 0        
 when DateDiff(day, acceptance.pdate, RCalc.SDate)>0 then 1        
 Else        
  case        
  when acceptance.cpct<>0 or Cover.Voyage=1 then        
   case when acceptance.cpct<>0 and acceptance.cpct<>100 then Acceptance.CPCT/100 else 1 end        
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
                                
From acceptance        
inner Join Cover on (Cover.CNO=Acceptance.CNO)        
inner join PCalc on (PCalc.ANO=Acceptance.ANO)        
inner join RCalc on (RCalc.ANO=PCalc.ANO and RCalc.Currency=PCalc.Currency)        
inner Join RCover on (RCover.ANO=Acceptance.ANO and RCover.Code=RCalc.Code and RCover.SDate=RCalc.SDate)        
Where Acceptance.AType not in ('A','C')        
and Not (Acceptance.Atype<>'N' and Acceptance.NoRefundF<>12 and not (Acceptance.NoRefundF=13 and charindex((case when Cover.ISType in ('I','L') Then 'DI' else 'I'+Cover.ISType end),Acceptance.RefundType)<>0) and (RCover.NoRefundF=1 or Acceptance.NoRefundF in (2,4) or (Acceptance.NoRefundF in (1) and DateDiff(day, acceptance.pdate, RCalc.SDate) <= 0)))
and Acceptance.ANO=@P_ANO        
    
Union All        
          
select        
Distinct        
RCalc.ANO,        
RCalc.Code,        
RCalc.Currency,        
RCalc.SDate,        
RCalc.EDate,        
Prorata_Calculation=        
case        
when DateDiff(day, rcalc.Edate, acceptance.pdate)>=0 and acceptance.pdate between pacceptance.sdate and pacceptance.edate then ''        
when DateDiff(day, acceptance.pdate, rcalc.SDate)>0 and acceptance.pdate between pacceptance.sdate and pacceptance.edate then ''        

Else        
  case        
  when acceptance.cpct<>0 or Cover.Voyage=1 then        
    case when acceptance.cpct<>0 and acceptance.cpct<>100 then convert(varchar(25),Cast(Acceptance.CPCT as float),0)+'%' else '' end        
  Else        
    case        
		When Acceptance.SDate<>Acceptance.PDate or Acceptance.NoRefundF=6 then        
			--Prorata Calculation
			Case When pAcceptance.EXCLUSIVEF=0 and pAcceptance.STime<pAcceptance.ETime and RCalc.EDate=pAcceptance.EDate Then
				CASE WHEN RCOVER.CPFORMULA = 'PRORATE SQ' and Acceptance.AType='C' and Acceptance.EMethod<>'A' THEN
					'('+dbo.fn_Calc_SProrata(dbo.fn_Get_Effective_Cancellation_By_Payor_Schedule(Acceptance.ANO, Acceptance.PDate,dateadd(day,1,RCalc.edate)), dateadd(day,1,RCalc.edate), RCalc.Sdate, dateadd(day,1,RCalc.edate), Cover.PPeriod)+') ^ 2'
				ELSE
					CASE WHEN Acceptance.AType='C' and Acceptance.EMethod<>'A' THEN
						dbo.fn_Calc_SProrata(dbo.fn_Get_Effective_Cancellation_By_Payor_Schedule(Acceptance.ANO, Acceptance.PDate,dateadd(day,1,RCalc.edate)), dateadd(day,1,RCalc.edate), RCalc.Sdate, dateadd(day,1,RCalc.edate), Cover.PPeriod)
					Else
						dbo.fn_Calc_SProrata(acceptance.pDate, dateadd(day,1,RCalc.edate), RCalc.Sdate, dateadd(day,1,RCalc.edate), Cover.PPeriod)
					End
				END				
			else
				CASE WHEN RCOVER.CPFORMULA = 'PRORATE SQ' and Acceptance.AType='C' and Acceptance.EMethod<>'A' THEN
					'('+dbo.fn_Calc_SProrata(dbo.fn_Get_Effective_Cancellation_By_Payor_Schedule(Acceptance.ANO, Acceptance.PDate,RCalc.Edate), RCalc.Edate, RCalc.Sdate, RCalc.EDate, Cover.PPeriod)+') ^ 2'
				ELSE
					CASE WHEN Acceptance.AType='C' and Acceptance.EMethod<>'A' THEN
						dbo.fn_Calc_SProrata(dbo.fn_Get_Effective_Cancellation_By_Payor_Schedule(Acceptance.ANO, Acceptance.PDate,RCalc.Edate), RCalc.Edate, RCalc.Sdate, RCalc.EDate, Cover.PPeriod)
					Else
						dbo.fn_Calc_SProrata(acceptance.pDate, RCalc.Edate, RCalc.Sdate, RCalc.EDate, Cover.PPeriod)
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
Case When Acceptance.CPCT=0 
and Acceptance.AType='C' and Acceptance.EMethod<>'A' 
and Acceptance.NoRefundF<>12 
and not (Acceptance.NoRefundF=13 and charindex((case when Cover.ISType in ('I','L') Then 'DI' else 'I'+Cover.ISType end),Acceptance.RefundType)<>0) 
and RCover.CPRefund<>0 
and not (DateDiff(day, acceptance.pdate, rcalc.SDate)>0 and acceptance.pdate between pacceptance.sdate and pacceptance.edate) 
Then ' x '+convert(varchar(25),RCover.CPRefund,0)+'%' else '' end
)
,        
Prorata=        
case        
when DateDiff(day, rcalc.Edate, acceptance.pdate)>=0 and acceptance.pdate between pacceptance.sdate and pacceptance.edate then 0        
when DateDiff(day, acceptance.pdate, rcalc.SDate)>0  and acceptance.pdate between pacceptance.sdate and pacceptance.edate then 1        

Else        
  case        
  when acceptance.cpct<>0 or Cover.Voyage=1 then        
    case when acceptance.cpct<>0 and acceptance.cpct<>100 then Acceptance.CPCT/100 else 1 end        
  Else        
    case        
		When Acceptance.SDate<>Acceptance.PDate or Acceptance.NoRefundF=6 then        
			--Prorata Calculation
			Case When pAcceptance.EXCLUSIVEF=0 and pAcceptance.STime<pAcceptance.ETime and RCalc.EDate=pAcceptance.EDate Then
				CASE WHEN RCOVER.CPFORMULA = 'PRORATE SQ' and Acceptance.AType='C' and Acceptance.EMethod<>'A' THEN
					POWER(dbo.fn_calc_prorata(dbo.fn_Get_Effective_Cancellation_By_Payor_Schedule(Acceptance.ANO, Acceptance.PDate,dateadd(day,1,RCalc.edate)), dateadd(day,1,RCalc.edate), RCalc.Sdate, dateadd(day,1,RCalc.edate), Cover.PPeriod),2)
				ELSE
					Case When Acceptance.AType='C' and Acceptance.EMethod<>'A' THEN
						dbo.fn_calc_prorata(dbo.fn_Get_Effective_Cancellation_By_Payor_Schedule(Acceptance.ANO, Acceptance.PDate,dateadd(day,1,RCalc.edate)), dateadd(day,1,RCalc.edate), RCalc.Sdate, dateadd(day,1,RCalc.edate), Cover.PPeriod)
					Else
						dbo.fn_calc_prorata(acceptance.pDate, dateadd(day,1,RCalc.edate), RCalc.Sdate, dateadd(day,1,RCalc.edate), Cover.PPeriod)
					End
				END				
			else
				CASE WHEN RCOVER.CPFORMULA = 'PRORATE SQ' and Acceptance.AType='C' and Acceptance.EMethod<>'A' THEN
					POWER(dbo.fn_calc_prorata(dbo.fn_Get_Effective_Cancellation_By_Payor_Schedule(Acceptance.ANO, Acceptance.PDate,RCalc.Edate), RCalc.Edate, RCalc.Sdate, RCalc.EDate, Cover.PPeriod),2)
				ELSE
					Case When Acceptance.AType='C' and Acceptance.EMethod<>'A' THEN
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
* (Case When Acceptance.CPCT=0 and Acceptance.AType='C' and Acceptance.EMethod<>'A' and Acceptance.NoRefundF<>12 and not (Acceptance.NoRefundF=13 and charindex((case when Cover.ISType in ('I','L') Then 'DI' else 'I'+Cover.ISType end),Acceptance.RefundType)<>0) and RCover.CPRefund<>0 and not (DateDiff(day, acceptance.pdate, rcalc.SDate)>0 and acceptance.pdate between pacceptance.sdate and pacceptance.edate) Then RCover.CPRefund/100 else 1 end)

From acceptance        
inner Join Cover on (Cover.CNO=Acceptance.CNO)        
inner join Acceptance pAcceptance on (pAcceptance.ANO=Acceptance.pANO)        
inner join PCalc on (PCalc.ANO=pAcceptance.ANO)        
inner join RCalc on (RCalc.ANO=PCalc.ANO and RCalc.Currency=PCalc.Currency)        
Left Join RCover on (RCover.ANO=Acceptance.ANO and RCover.Code=RCalc.Code and ((RCover.SDate=Acceptance.SDate and RCover.EDate=Acceptance.EDate and RCalc.SDate=pAcceptance.SDate and RCalc.EDate=pAcceptance.EDate) or (RCover.SDate=RCalc.SDate)))
Where Acceptance.AType<>'A' and Not (Acceptance.AType='C' and Acceptance.EMethod='A') and pAcceptance.AType not in ('A','C')        
and Not (Acceptance.Atype<>'N' and Acceptance.NoRefundF<>12 and not (Acceptance.NoRefundF=13 and charindex((case when Cover.ISType in ('I','L') Then 'DI' else 'I'+Cover.ISType end),Acceptance.RefundType)<>0) and (coalesce(RCover.NoRefundF,0)=1 or Acceptance.NoRefundF in (2,4) or (Acceptance.NoRefundF in (1) and DateDiff(day, acceptance.pdate, RCalc.SDate) <= 0)))
and Not (DateDiff(day, rcalc.Edate, acceptance.pdate)>=0 and acceptance.pdate between pacceptance.sdate and pacceptance.edate)
and Acceptance.ANO=@P_ANO        
)        
       

GO



DROP FUNCTION DISPLAY_FACULTATIVE_BALANCE_PRORATA_CALCULATION
GO
CREATE FUNCTION DISPLAY_FACULTATIVE_BALANCE_PRORATA_CALCULATION(@P_ANO int, @P_FID Varchar(20))          
-- From Display_Prorata Calculation   
-- RCalc.Sdate Replaced with (Case When Datediff(day, RArrDet.SDate, RCalc.SDate)>=0 Then RCalc.SDate else RArrDet.SDate end) 
-- RCalc.Edate Replaced with (Case When Datediff(day, RCalc.EDate, RArrDet.EDate)>=0 Then RCalc.EDate else RArrDet.EDate end) 
-- Acceptance.AType Replaced with RArrDet.AType  
RETURNS TABLE  AS          
RETURN (          
select          
Distinct          
RCalc.ANO,          
RCalc.Code,          
RCalc.Currency,          
RCalc.Sdate,
RCalc.EDate,
Prorata_Calculation=        
case        
When RArrDet.AType<>'N' then        

 case        
 when DateDiff(day, (Case When Datediff(day, RCalc.EDate, RArrDet.EDate)>=0 Then RCalc.EDate else RArrDet.EDate end), acceptance.pdate)>=0 then ''
 when DateDiff(day, acceptance.pdate, (Case When Datediff(day, RArrDet.SDate, RCalc.SDate)>=0 Then RCalc.SDate else RArrDet.SDate end))>0 then ''        
 Else        
  case        
  when acceptance.cpct<>0 or Cover.Voyage=1 then        
   case when acceptance.cpct<>0 and acceptance.cpct<>100 then convert(varchar(25),Cast(Acceptance.CPCT as float),0)+'%' else '' end        
  Else        
	--Prorata Calculation
	Case When Acceptance.EXCLUSIVEF=0 and Acceptance.STime<Acceptance.ETime and (Case When Datediff(day, RCalc.EDate, RArrDet.EDate)>=0 Then RCalc.EDate else RArrDet.EDate end)=Acceptance.EDate Then
		dbo.fn_calc_sprorata(acceptance.pDate, dateadd(day,1,(Case When Datediff(day, RCalc.EDate, RArrDet.EDate)>=0 Then RCalc.EDate else RArrDet.EDate end)), (Case When Datediff(day, RArrDet.SDate, RCalc.SDate)>=0 Then RCalc.SDate else RArrDet.SDate end), dateadd(day,1,(Case When Datediff(day, RCalc.EDate, RArrDet.EDate)>=0 Then RCalc.EDate else RArrDet.EDate end)), Cover.PPeriod)
	else
		dbo.fn_calc_sprorata(acceptance.pDate, (Case When Datediff(day, RCalc.EDate, RArrDet.EDate)>=0 Then RCalc.EDate else RArrDet.EDate end), (Case When Datediff(day, RArrDet.SDate, RCalc.SDate)>=0 Then RCalc.SDate else RArrDet.SDate end), (Case When Datediff(day, RCalc.EDate, RArrDet.EDate)>=0 Then RCalc.EDate else RArrDet.EDate end), Cover.PPeriod)
	End
  End
 End        
Else        
 ''        
end,        
          
Prorata=        
case        
When RArrDet.AType<>'N' then        
 case        
 when DateDiff(day, (Case When Datediff(day, RCalc.EDate, RArrDet.EDate)>=0 Then RCalc.EDate else RArrDet.EDate end), acceptance.pdate)>=0 then 0        
 when DateDiff(day, acceptance.pdate, (Case When Datediff(day, RArrDet.SDate, RCalc.SDate)>=0 Then RCalc.SDate else RArrDet.SDate end))>0 then 1        
 Else        
  case        
  when acceptance.cpct<>0 or Cover.Voyage=1 then        
   case when acceptance.cpct<>0 and acceptance.cpct<>100 then Acceptance.CPCT/100 else 1 end        
  Else        
	--Prorata Calculation
	Case When Acceptance.EXCLUSIVEF=0 and Acceptance.STime<Acceptance.ETime and (Case When Datediff(day, RCalc.EDate, RArrDet.EDate)>=0 Then RCalc.EDate else RArrDet.EDate end)=Acceptance.EDate Then
		dbo.fn_calc_prorata(acceptance.pDate, dateadd(day,1,(Case When Datediff(day, RCalc.EDate, RArrDet.EDate)>=0 Then RCalc.EDate else RArrDet.EDate end)), (Case When Datediff(day, RArrDet.SDate, RCalc.SDate)>=0 Then RCalc.SDate else RArrDet.SDate end), dateadd(day,1,(Case When Datediff(day, RCalc.EDate, RArrDet.EDate)>=0 Then RCalc.EDate else RArrDet.EDate end)), Cover.PPeriod)
	else
		dbo.fn_calc_prorata(acceptance.pDate, (Case When Datediff(day, RCalc.EDate, RArrDet.EDate)>=0 Then RCalc.EDate else RArrDet.EDate end), (Case When Datediff(day, RArrDet.SDate, RCalc.SDate)>=0 Then RCalc.SDate else RArrDet.SDate end), (Case When Datediff(day, RCalc.EDate, RArrDet.EDate)>=0 Then RCalc.EDate else RArrDet.EDate end), Cover.PPeriod)
	End
  End
 End        

Else        
	1        
End        

From acceptance          
inner Join Cover on (Cover.CNO=Acceptance.CNO)          
inner join PCalc on (PCalc.ANO=Acceptance.ANO)          
inner join RCalc on (RCalc.ANO=PCalc.ANO and RCalc.Currency=PCalc.Currency)          
inner join RArrDet on (RArrDet.ANO=Acceptance.ANO and RArrDet.FID=@P_FID)    
inner Join RCover on (RCover.ANO=Acceptance.ANO and RCover.Code=RCalc.Code and RCover.SDate=RCalc.SDate)        
Where RArrDet.AType not in ('A','C')   
and Not (RArrDet.Atype<>'N' and Acceptance.NoRefundF<>12 and not (Acceptance.NoRefundF=13 and charindex('FO',Acceptance.RefundType)<>0) and (RCover.NoRefundF=1 or RArrDet.NoRefundF=1 or Acceptance.NoRefundF in (2) or (Acceptance.NoRefundF in (1) and DateDiff(day, acceptance.pdate, (Case When Datediff(day, RArrDet.SDate, RCalc.SDate)>=0 Then RCalc.SDate else RArrDet.SDate end)) <= 0)))     
and Acceptance.ANO=@P_ANO        
            
Union All          
            
select          
Distinct          
RCalc.ANO,          
RCalc.Code,          
RCalc.Currency,          
RCalc.Sdate,
RCalc.EDate,
Prorata_Calculation=        
case        
when DateDiff(day, (Case When Datediff(day, RCalc.EDate, RArrDet.EDate)>=0 Then RCalc.EDate else RArrDet.EDate end), acceptance.pdate)>=0 and acceptance.pdate between pacceptance.sdate and pacceptance.edate then ''        
when DateDiff(day, acceptance.pdate, (Case When Datediff(day, RArrDet.SDate, RCalc.SDate)>=0 Then RCalc.SDate else RArrDet.SDate end))>0 and acceptance.pdate between pacceptance.sdate and pacceptance.edate then ''        

Else        
  case        
  when acceptance.cpct<>0 or Cover.Voyage=1 then        
    case when acceptance.cpct<>0 and acceptance.cpct<>100 then convert(varchar(25),Cast(Acceptance.CPCT as float),0)+'%' else '' end        
  Else        
    case        
		When Acceptance.SDate<>Acceptance.PDate or Acceptance.NoRefundF=6 then        
			--Prorata Calculation
			Case When pAcceptance.EXCLUSIVEF=0 and pAcceptance.STime<pAcceptance.ETime and (Case When Datediff(day, RCalc.EDate, RArrDet.EDate)>=0 Then RCalc.EDate else RArrDet.EDate end)=pAcceptance.EDate Then
				CASE WHEN RCOVER.CPFORMULA = 'PRORATE SQ' and RArrDet.AType='C' and Acceptance.EMethod<>'A' THEN
					'('+dbo.fn_Calc_SProrata(dbo.fn_Get_Effective_Cancellation_By_Payor_Schedule(Acceptance.ANO, Acceptance.PDate,dateadd(day,1,(Case When Datediff(day, RCalc.EDate, RArrDet.EDate)>=0 Then RCalc.EDate else RArrDet.EDate end))), dateadd(day,1,(Case When Datediff(day, RCalc.EDate, RArrDet.EDate)>=0 Then RCalc.EDate else RArrDet.EDate end)), (Case When Datediff(day, RArrDet.SDate, RCalc.SDate)>=0 Then RCalc.SDate else RArrDet.SDate end), dateadd(day,1,(Case When Datediff(day, RCalc.EDate, RArrDet.EDate)>=0 Then RCalc.EDate else RArrDet.EDate end)), Cover.PPeriod)+') ^ 2'
				ELSE
					CASE WHEN RArrDet.AType='C' and Acceptance.EMethod<>'A' THEN
						dbo.fn_Calc_SProrata(dbo.fn_Get_Effective_Cancellation_By_Payor_Schedule(Acceptance.ANO, Acceptance.PDate,dateadd(day,1,(Case When Datediff(day, RCalc.EDate, RArrDet.EDate)>=0 Then RCalc.EDate else RArrDet.EDate end))), dateadd(day,1,(Case When Datediff(day, RCalc.EDate, RArrDet.EDate)>=0 Then RCalc.EDate else RArrDet.EDate end)), (Case When Datediff(day, RArrDet.SDate, RCalc.SDate)>=0 Then RCalc.SDate else RArrDet.SDate end), dateadd(day,1,(Case When Datediff(day, RCalc.EDate, RArrDet.EDate)>=0 Then RCalc.EDate else RArrDet.EDate end)), Cover.PPeriod)
					Else
						dbo.fn_Calc_SProrata(acceptance.pDate, dateadd(day,1,(Case When Datediff(day, RCalc.EDate, RArrDet.EDate)>=0 Then RCalc.EDate else RArrDet.EDate end)), (Case When Datediff(day, RArrDet.SDate, RCalc.SDate)>=0 Then RCalc.SDate else RArrDet.SDate end), dateadd(day,1,(Case When Datediff(day, RCalc.EDate, RArrDet.EDate)>=0 Then RCalc.EDate else RArrDet.EDate end)), Cover.PPeriod)
					End
				END				
			else
				CASE WHEN RCOVER.CPFORMULA = 'PRORATE SQ' and RArrDet.AType='C' and Acceptance.EMethod<>'A' THEN
					'('+dbo.fn_Calc_SProrata(dbo.fn_Get_Effective_Cancellation_By_Payor_Schedule(Acceptance.ANO, Acceptance.PDate,(Case When Datediff(day, RCalc.EDate, RArrDet.EDate)>=0 Then RCalc.EDate else RArrDet.EDate end)), (Case When Datediff(day, RCalc.EDate, RArrDet.EDate)>=0 Then RCalc.EDate else RArrDet.EDate end), (Case When Datediff(day, RArrDet.SDate, RCalc.SDate)>=0 Then RCalc.SDate else RArrDet.SDate end), (Case When Datediff(day, RCalc.EDate, RArrDet.EDate)>=0 Then RCalc.EDate else RArrDet.EDate end), Cover.PPeriod)+') ^ 2'
				ELSE
					CASE WHEN RArrDet.AType='C' and Acceptance.EMethod<>'A' THEN
						dbo.fn_Calc_SProrata(dbo.fn_Get_Effective_Cancellation_By_Payor_Schedule(Acceptance.ANO, Acceptance.PDate,(Case When Datediff(day, RCalc.EDate, RArrDet.EDate)>=0 Then RCalc.EDate else RArrDet.EDate end)), (Case When Datediff(day, RCalc.EDate, RArrDet.EDate)>=0 Then RCalc.EDate else RArrDet.EDate end), (Case When Datediff(day, RArrDet.SDate, RCalc.SDate)>=0 Then RCalc.SDate else RArrDet.SDate end), (Case When Datediff(day, RCalc.EDate, RArrDet.EDate)>=0 Then RCalc.EDate else RArrDet.EDate end), Cover.PPeriod)
					Else
						dbo.fn_Calc_SProrata(acceptance.pDate, (Case When Datediff(day, RCalc.EDate, RArrDet.EDate)>=0 Then RCalc.EDate else RArrDet.EDate end), (Case When Datediff(day, RArrDet.SDate, RCalc.SDate)>=0 Then RCalc.SDate else RArrDet.SDate end), (Case When Datediff(day, RCalc.EDate, RArrDet.EDate)>=0 Then RCalc.EDate else RArrDet.EDate end), Cover.PPeriod)
					End
				END				
			End

		Else        
		 -- Endorsement Period        
			''        
		End       
	End        
End        
+ (
Case When Acceptance.CPCT=0 
and Acceptance.AType='C' and Acceptance.EMethod<>'A' 
and Acceptance.NoRefundF<>12 
and not (Acceptance.NoRefundF=13 and charindex('FO',Acceptance.RefundType)<>0) 
and NRarrDet.CPRefund<>0 
and not (DateDiff(day, acceptance.pdate, (Case When Datediff(day, RArrDet.SDate, RCalc.SDate)>=0 Then RCalc.SDate else RArrDet.SDate end) )>0 and acceptance.pdate between pacceptance.sdate and pacceptance.edate) 
Then ' x '+convert(varchar(25),NRarrDet.CPRefund,0)+'%' else '' end
)

,        
Prorata=        
case        
when DateDiff(day, (Case When Datediff(day, RCalc.EDate, RArrDet.EDate)>=0 Then RCalc.EDate else RArrDet.EDate end), acceptance.pdate)>=0 and acceptance.pdate between pacceptance.sdate and pacceptance.edate then 0        
when DateDiff(day, acceptance.pdate, (Case When Datediff(day, RArrDet.SDate, RCalc.SDate)>=0 Then RCalc.SDate else RArrDet.SDate end))>0  and acceptance.pdate between pacceptance.sdate and pacceptance.edate then 1        

Else        
  case        
  when acceptance.cpct<>0 or Cover.Voyage=1 then        
    case when acceptance.cpct<>0 and acceptance.cpct<>100 then Acceptance.CPCT/100 else 1 end        
  Else        
    case        
		When Acceptance.SDate<>Acceptance.PDate or Acceptance.NoRefundF=6 then        
			--Prorata Calculation
			Case When pAcceptance.EXCLUSIVEF=0 and pAcceptance.STime<pAcceptance.ETime and (Case When Datediff(day, RCalc.EDate, RArrDet.EDate)>=0 Then RCalc.EDate else RArrDet.EDate end)=pAcceptance.EDate Then
				CASE WHEN RCOVER.CPFORMULA = 'PRORATE SQ' and RArrDet.AType='C' and Acceptance.EMethod<>'A' THEN
					POWER(dbo.fn_calc_prorata(dbo.fn_Get_Effective_Cancellation_By_Payor_Schedule(Acceptance.ANO, Acceptance.PDate,dateadd(day,1,(Case When Datediff(day, RCalc.EDate, RArrDet.EDate)>=0 Then RCalc.EDate else RArrDet.EDate end))), dateadd(day,1,(Case When Datediff(day, RCalc.EDate, RArrDet.EDate)>=0 Then RCalc.EDate else RArrDet.EDate end)), (Case When Datediff(day, RArrDet.SDate, RCalc.SDate)>=0 Then RCalc.SDate else RArrDet.SDate end), dateadd(day,1,(Case When Datediff(day, RCalc.EDate, RArrDet.EDate)>=0 Then RCalc.EDate else RArrDet.EDate end)), Cover.PPeriod),2)
				ELSE
					CASE WHEN RArrDet.AType='C' and Acceptance.EMethod<>'A' THEN
						dbo.fn_calc_prorata(dbo.fn_Get_Effective_Cancellation_By_Payor_Schedule(Acceptance.ANO, Acceptance.PDate,dateadd(day,1,(Case When Datediff(day, RCalc.EDate, RArrDet.EDate)>=0 Then RCalc.EDate else RArrDet.EDate end))), dateadd(day,1,(Case When Datediff(day, RCalc.EDate, RArrDet.EDate)>=0 Then RCalc.EDate else RArrDet.EDate end)), (Case When Datediff(day, RArrDet.SDate, RCalc.SDate)>=0 Then RCalc.SDate else RArrDet.SDate end), dateadd(day,1,(Case When Datediff(day, RCalc.EDate, RArrDet.EDate)>=0 Then RCalc.EDate else RArrDet.EDate end)), Cover.PPeriod)
					Else
						dbo.fn_calc_prorata(acceptance.pDate, dateadd(day,1,(Case When Datediff(day, RCalc.EDate, RArrDet.EDate)>=0 Then RCalc.EDate else RArrDet.EDate end)), (Case When Datediff(day, RArrDet.SDate, RCalc.SDate)>=0 Then RCalc.SDate else RArrDet.SDate end), dateadd(day,1,(Case When Datediff(day, RCalc.EDate, RArrDet.EDate)>=0 Then RCalc.EDate else RArrDet.EDate end)), Cover.PPeriod)
					End
				END				
			else
				CASE WHEN RCOVER.CPFORMULA = 'PRORATE SQ' and RArrDet.AType='C' and Acceptance.EMethod<>'A' THEN
					POWER(dbo.fn_calc_prorata(dbo.fn_Get_Effective_Cancellation_By_Payor_Schedule(Acceptance.ANO, Acceptance.PDate,(Case When Datediff(day, RCalc.EDate, RArrDet.EDate)>=0 Then RCalc.EDate else RArrDet.EDate end)), (Case When Datediff(day, RCalc.EDate, RArrDet.EDate)>=0 Then RCalc.EDate else RArrDet.EDate end), (Case When Datediff(day, RArrDet.SDate, RCalc.SDate)>=0 Then RCalc.SDate else RArrDet.SDate end), (Case When Datediff(day, RCalc.EDate, RArrDet.EDate)>=0 Then RCalc.EDate else RArrDet.EDate end), Cover.PPeriod),2)
				ELSE
					CASE WHEN RArrDet.AType='C' and Acceptance.EMethod<>'A' THEN
						dbo.fn_calc_prorata(dbo.fn_Get_Effective_Cancellation_By_Payor_Schedule(Acceptance.ANO, Acceptance.PDate,(Case When Datediff(day, RCalc.EDate, RArrDet.EDate)>=0 Then RCalc.EDate else RArrDet.EDate end)), (Case When Datediff(day, RCalc.EDate, RArrDet.EDate)>=0 Then RCalc.EDate else RArrDet.EDate end), (Case When Datediff(day, RArrDet.SDate, RCalc.SDate)>=0 Then RCalc.SDate else RArrDet.SDate end), (Case When Datediff(day, RCalc.EDate, RArrDet.EDate)>=0 Then RCalc.EDate else RArrDet.EDate end), Cover.PPeriod)
					Else
						dbo.fn_calc_prorata(acceptance.pDate, (Case When Datediff(day, RCalc.EDate, RArrDet.EDate)>=0 Then RCalc.EDate else RArrDet.EDate end), (Case When Datediff(day, RArrDet.SDate, RCalc.SDate)>=0 Then RCalc.SDate else RArrDet.SDate end), (Case When Datediff(day, RCalc.EDate, RArrDet.EDate)>=0 Then RCalc.EDate else RArrDet.EDate end), Cover.PPeriod)
					End
				END				
			End
		Else        
		 -- Endorsement Period        
			1        
		End        
	End        
End        
*
(
Case When Acceptance.CPCT=0 
and Acceptance.AType='C' and Acceptance.EMethod<>'A' 
and Acceptance.NoRefundF<>12 
and not (Acceptance.NoRefundF=13 and charindex('FO',Acceptance.RefundType)<>0) 
and NRarrDet.CPRefund<>0 
and not (DateDiff(day, acceptance.pdate, (Case When Datediff(day, RArrDet.SDate, RCalc.SDate)>=0 Then RCalc.SDate else RArrDet.SDate end) )>0 and acceptance.pdate between pacceptance.sdate and pacceptance.edate) 
Then NRarrDet.CPRefund/100 else 1 end
)
	             
From acceptance          
inner Join Cover on (Cover.CNO=Acceptance.CNO)          
inner join Acceptance pAcceptance on (pAcceptance.ANO=Acceptance.pANO)          
inner join PCalc on (PCalc.ANO=pAcceptance.ANO)          
inner join RCalc on (RCalc.ANO=PCalc.ANO and RCalc.Currency=PCalc.Currency)     
inner join RArrDet NRArrDet on (NRArrDet.ANO=Acceptance.ANO and NRArrDet.FID=@P_FID)         
inner join RArrDet on (RArrDet.ANO=pAcceptance.ANO and RArrDet.FID=@P_FID)         
Left Join RCover on (RCover.ANO=Acceptance.ANO and RCover.Code=Rcalc.Code and ((RCover.SDate=Acceptance.SDate and RCover.EDate=Acceptance.EDate and RCalc.SDate=pAcceptance.SDate and RCalc.EDate=pAcceptance.EDate) or (RCover.SDate=RCalc.SDate)))
Where NRArrDet.AType<>'A' and Not (NRArrDet.AType='C' and Acceptance.EMethod='A') and RArrDet.AType not in ('A','C')        
and Not (NRarrDet.Atype<>'N' and Acceptance.NoRefundF<>12 and not (Acceptance.NoRefundF=13 and charindex('FO',Acceptance.RefundType)<>0) and (coalesce(RCover.NoRefundF,0)=1 or NRArrDet.NoRefundF=1 or Acceptance.NoRefundF in (2) or (Acceptance.NoRefundF in (1) and DateDiff(day, acceptance.pdate, (Case When Datediff(day, RArrDet.SDate, RCalc.SDate)>=0 Then RCalc.SDate else RArrDet.SDate end)) <= 0)))
and Not (DateDiff(day, (Case When Datediff(day, RCalc.EDate, RArrDet.EDate)>=0 Then RCalc.EDate else RArrDet.EDate end), acceptance.pdate)>=0 and acceptance.pdate between pacceptance.sdate and pacceptance.edate)
and Acceptance.ANO=@P_ANO        
)

GO


DROP FUNCTION PREMIUM_CALCULATION_BASE
GO
CREATE FUNCTION PREMIUM_CALCULATION_BASE(@P_ANO int)                  

RETURNS @PCALC TABLE (ANO Int, Currency varchar(10), CANO int, Code varchar(10), SDate SmallDatetime, EDate SmallDatetime, PolicyYear Int, NoRefundF Int, MinimumPremiumF Bit, Premium Float)
AS
BEGIN

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

RETURN

END

GO

DROP FUNCTION PREMIUM_CALCULATION_CONSTANT
GO
CREATE FUNCTION PREMIUM_CALCULATION_CONSTANT(@P_ANO int) 
RETURNS TABLE  AS 
RETURN ( 
Select ANO, Currency, sum(Premium) as Premium 
 
from( 
Select ANO, Currency, sum(Premium) as Premium 
 
from ( 
select Acceptance.ANO,RCalc.Currency, 
-case 
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
					Case When Acceptance.AType='C' and Acceptance.EMethod<>'A' THEN
						dbo.fn_calc_prorata(dbo.fn_Get_Effective_Cancellation_By_Payor_Schedule(Acceptance.ANO, Acceptance.PDate,dateadd(day,1,RCalc.edate)), dateadd(day,1,RCalc.edate), RCalc.Sdate, dateadd(day,1,RCalc.edate), Cover.PPeriod)
					else
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
* (Case When PCalc.Description='Minimum Premium' Then RCalc.Gross else (Case When PCalc.Gross=0 then 0 else Case When PCalc.OGross=0 Then PCalc.Gross else RCalc.OGross*(case When Pcalc.TSI=0 then 1 else PCalc.Ourshare/PCalc.TSI end) *PCalc.Gross/PCalc.OGross end end) end+RCalc.Reinstatement)
* (Case When Acceptance.CPCT=0 and Acceptance.AType='C' and Acceptance.EMethod<>'A' and Acceptance.NoRefundF<>12 and not (Acceptance.NoRefundF=13 and charindex((case when Cover.ISType in ('I','L') Then 'DI' else 'I'+Cover.ISType end),Acceptance.RefundType)<>0) and RCover.CPRefund<>0 and not (DateDiff(day, acceptance.pdate, rcalc.SDate)>0 and acceptance.pdate between pacceptance.sdate and pacceptance.edate) Then RCover.CPRefund/100 else 1 end) as Premium      

from Acceptance inner join Acceptance pAcceptance on (pAcceptance.ANO=Acceptance.pANO) inner Join Cover on (Cover.CNO=Acceptance.CNO) 
inner join PCalc on (PCalc.ANO=pAcceptance.ANO) inner join RCalc on (RCalc.ANO=PCalc.ANO and RCalc.Currency=PCalc.Currency) 
Left Join RCover on (RCover.ANO=Acceptance.ANO and RCover.Code=RCalc.Code and ((RCover.SDate=Acceptance.SDate and RCover.EDate=Acceptance.EDate and RCalc.SDate=pAcceptance.SDate and RCalc.EDate=pAcceptance.EDate) or (RCover.SDate=RCalc.SDate)))
Where Acceptance.ANO=@P_ANO and Acceptance.AType<>'A' and Not (Acceptance.AType='C' and Acceptance.EMethod='A') and pAcceptance.AType not in ('A','C') 
and Not (Acceptance.Atype<>'N' and Acceptance.NoRefundF<>12 and not (Acceptance.NoRefundF=13 and charindex((case when Cover.ISType in ('I','L') Then 'DI' else 'I'+Cover.ISType end),Acceptance.RefundType)<>0) and (coalesce(RCover.NoRefundF,0)=1 or Acceptance.NoRefundF in (2,4) or (Acceptance.NoRefundF in (1) and DateDiff(day, acceptance.pdate, RCalc.SDate) <= 0)))
and Not (DateDiff(day, rcalc.Edate, acceptance.pdate)>=0 and acceptance.pdate between pacceptance.sdate and pacceptance.edate)
and RCalc.Gross<>0 
) T 
 
Group By ANO, Currency 
 
Union All 

select A3.ANO, AccAss.Currency_OC as Currency,                  
sum(Case When AccAss.Code in ('P') then (Case When A3.AType='A' and AccAss.AdjMethod='OVERLIMIT' then -AccAss.CAmount*(Case When A3.CPCT<>0 Then A3.CPCT/100 else 1 end)/(Case When AccAss.PProrata<>0 Then AccAss.PProrata else 1 end) else -AccAss.Amount_OC end)*(Case When AccAss.Type='DI' then 100/(100-coalesce(Coinsurance.MShare,0)) else 1 end) else 0 end) as Premium
From Acceptance A2 
inner join AccAss on (AccAss.ANO=A2.ANO)     
Left join Acceptance pA2  on (pA2.ANO=A2.pANO)     
Left Join (Select CNO, sum(Share) as MShare from Coinsurance Where PCollectionF=0 Group by CNO) Coinsurance on (Coinsurance.CNO=A2.CNO)      
Cross Apply (
	Select Top 1 A1.ANO, A1.OANO, A1.CPCT, A1.AType, A1.EMethod, A1.PANO, A1.PDate, A1.PPDate, A2.PDate as CPDate, coalesce(A2.ANO,0) as CANO
	from Acceptance A1
	Left Join RArrHeader R on (R.ANO=A1.ANO)
	Left Join Acceptance A2 on (A2.OANO=A1.OANO and A2.Atype='C' and A2.EMethod='A' and A2.ANO<@P_ANO)
	Where A1.ANO=@P_ANO
	Order By A1.OANO, A2.ANO Desc
) A3 
Where A2.OANO=A3.OANO and A2.ANO<@P_ANO
and 
( 
	(
	A3.AType='A' and
	(    
		(  
		pA2.ANO=A3.PANO and A3.PDate<=pA2.PDate and A3.PPDate>=pA2.PPDate and (A2.AType='E' and coalesce(pA2.AType,'') in ('N','E'))   
		and AccAss.AdjustableF=1 and AccAss.AdjMethod<>'OVERLIMIT' and AccAss.CAmount=0  
		and NOT EXISTS (Select Top 1 PANO from Acceptance A3 Where A3.OANO=A3.OANO and A3.PANO>=pA2.ANO and A3.Astatus<>'C' and A3.AType='A' and A3.ANO<@P_ANO)  
		)     
		or   
		(  
		A2.ANO<=A3.PANO and A3.PDate<=A2.PDate and A3.PPDate>=A2.PPDate and (A2.AType<>'A' and coalesce(pA2.AType,'')<>'A')   
		and AccAss.AdjustableF=1 and AccAss.AdjMethod<>'OVERLIMIT'  
		and NOT EXISTS (Select Top 1 PANO from Acceptance A3 Where A3.OANO=A3.OANO and A3.PANO>=A2.ANO and A3.Astatus<>'C' and A3.AType='A' and A3.ANO<@P_ANO)  
		)     
		or   
		(  
		A2.ANO<=A3.PANO and A3.PDate<=A2.PDate and A3.PPDate>=A2.PPDate and (A2.AType<>'A' and coalesce(pA2.AType,'')<>'A')   
		and AccAss.AdjustableF=1 and AccAss.AdjMethod='OVERLIMIT' and A2.PDATE<A2.PPDATE and AccAss.CAmount<>0  
		and NOT EXISTS (Select Top 1 PANO from Acceptance A3 Where A3.OANO=A3.OANO and A3.PANO=A2.ANO and A3.Astatus<>'C' and A3.AType='A' and A3.ANO<@P_ANO)  
		)     
	)
	)
	or    
	(  
	--Cancel All
	A3.AType='C' and A3.EMethod='A'and 
	(
	(
	case when A2.ANO<=A3.CANO and A2.PDate>coalesce(A3.CPDate,A2.PDate) Then coalesce(A3.CPDate,A2.PDate) else A2.PDate end>=A3.PDate and AccAss.CAmount<>0
	) 
	or 
	(
	case when A2.ANO<=A3.CANO and coalesce(pA2.pDate,A2.PDate)>coalesce(A3.CPDate,coalesce(pA2.pDate,A2.PDate)) Then coalesce(A3.CPDate,coalesce(pA2.pDate,A2.PDate)) else coalesce(pA2.pDate,A2.PDate) end>=A3.PDate and AccAss.CAmount=0
	)
	)
	)  
	or
	(
	--Adjustment Cancel
	A3.AType='C' and A2.AType='A' and A2.ANO=A3.PANO
	)
)     
and (AccAss.Type in ('DI','IC','IR') and AccAss.Code='P')
Group By A3.ANO, AccAss.Currency_OC

) T 
 
Group By ANO, Currency 
) 
 
GO

DROP FUNCTION PREMIUM_CALCULATION_FACTOR
GO
CREATE FUNCTION PREMIUM_CALCULATION_FACTOR(@P_ANO int)    
RETURNS TABLE  AS    
RETURN (    
Select ANO, Currency, sum(Premium) as Premium    
                                
from(    
 Select ANO, Currency, sum(Premium) as Premium    
                        
 from (    
  select Acceptance.ANO, RCalc.Currency,    
  case    
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
  * (Case When PCalc.Description='Minimum Premium' Then RCalc.Gross/PCalc.Gross else (Case When PCalc.Gross=0 then 0 else Case When PCalc.OGross=0 Then 1 else RCalc.OGross*(case When Pcalc.TSI=0 then 1 else PCalc.Ourshare/PCalc.TSI end) * 1/PCalc.OGross end end) end+RCalc.Reinstatement) as Premium         
  From RCALC, PCALC, acceptance, cover, RCOVER    
  Where Acceptance.ANO=@P_ANO AND Cover.CNO=Acceptance.CNO    
  and RCOVER.ANO=RCALC.ANO AND RCOVER.CODE=RCALC.CODE AND RCOVER.SDATE=RCALC.SDATE    
  and RCalc.ANO=Acceptance.ANO and PCalc.ANO=RCalc.ANO and PCalc.Currency=RCalc.Currency    
  and Acceptance.AType not in ('A','C')    
  and not (Acceptance.Atype<>'N' and Acceptance.NoRefundF<>12 and not (Acceptance.NoRefundF=13 and charindex((case when Cover.ISType in ('I','L') Then 'DI' else 'I'+Cover.ISType end),Acceptance.RefundType)<>0) and (RCover.NoRefundF=1 or Acceptance.NoRefundF in (2,4) or (Acceptance.NoRefundF in (1) and DateDiff(day, acceptance.pdate, RCalc.SDate) <= 0)))
  and RCalc.Gross<>0    
                                      
  Union All    
                                                                      
  select Acceptance.ANO, RCalc.Currency,    
  (Case When PCalc.Description='Minimum Premium' Then RCalc.Gross/PCalc.Gross else (Case When PCalc.Gross=0 then 0 else Case When PCalc.OGross=0 Then 1 else RCalc.OGross*1/PCalc.OGross end end) end+RCalc.Reinstatement)*coalesce(sISource.Share/100,(case When Pcalc.TSI=0 then 1 else PCalc.Ourshare/PCalc.TSI end)) as Premium
  From RCALC Left Join Acceptance sAcceptance on (sAcceptance.ANO=RCalc.SANO) Left Join ISource sISource on (sISource.CNO=sAcceptance.CNO), PCALC, acceptance
  Where Acceptance.ANO=@P_ANO and RCalc.ANO=Acceptance.ANO and PCalc.ANO=RCalc.ANO and PCalc.Currency=RCalc.Currency and Acceptance.AType='A'            
 ) T    
                        
 Group By ANO, Currency    
                                                                                   
) T    
                                
Group By ANO, Currency    
                                    
                                    
)    










GO



 insert into PatchVersioning
select '176 Update Script - 8 March 2022',GETDATE()
go


Declare @PrevScript varchar(100)
Declare @CurrScript varchar(100)

Select @PrevScript=''
Select @CurrSCript='176 Update Script - 8 March 2022'


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