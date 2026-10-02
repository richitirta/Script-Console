DROP FUNCTION FN_PCalc
GO
Create FUNCTION FN_PCalc (@P_ANO as integer)                
RETURNS Table                
AS RETURN (                
SELECT  
	Acceptance.ANO,                
	PCALC.NUMCCY,
	PCALC.LMFACTOR,
	PCALC.RATE,
	PCALC.CRATE,
	(CASE When Acceptance.QTY=0 Then 1 Else Acceptance.QTY end) as NumRisk,
	PCALC.TSI*(CASE When Acceptance.QTY=0 Then 1 Else Acceptance.QTY end) as TSI,
	PCALC.OURSHARE*(CASE When Acceptance.QTY=0 Then 1 Else Acceptance.QTY end) as OURSHARE,
	PCALC.AMOUNT*(CASE When Acceptance.QTY=0 Then 1 Else Acceptance.QTY end) as AMOUNT,
	PCALC.GROSS*(CASE When Acceptance.QTY=0 Then 1 Else Acceptance.QTY end) as GROSS,
	PCALC.OGROSS/dbo.fn_Premium_Calc_Prorata(Acceptance.Sdate, case When Acceptance.EXCLUSIVEF=0 and Acceptance.STime<Acceptance.ETime Then dateadd(day,1,Acceptance.EDate) else Acceptance.EDate End,Cover.Prorata, 12,CASE WHEN Cover.PPeriod in (0,1,2) Then 2 ELSE Cover.PPeriod END)*(CASE When Acceptance.QTY=0 Then 1 Else Acceptance.QTY end) as OGROSS,
	PCALC.CLAIM*(CASE When Acceptance.QTY=0 Then 1 Else Acceptance.QTY end) as CLAIM, 
	PCALC.GROSS*(CASE WHEN COALESCE(ISOURCE.TSI,0)<>0 THEN (ISOURCE.RAMOUNT/ISOURCE.TSI)*100 WHEN PCALC.TSI<>0 AND COALESCE(ISOURCE.LIMIT,0)<>0 THEN PCALC.OURSHARE/PCALC.TSI*100 ELSE COALESCE(ISOURCE.SHARE,100) END)/100*(CASE When Acceptance.QTY=0 Then 1 Else Acceptance.QTY end) as PREMIUM,
	(CASE WHEN COALESCE(ISOURCE.TSI,0)<>0 THEN (ISOURCE.RAMOUNT/ISOURCE.TSI)*100 WHEN PCALC.TSI<>0 AND COALESCE(ISOURCE.LIMIT,0)<>0 THEN PCALC.OURSHARE/PCALC.TSI*100 ELSE COALESCE(ISOURCE.SHARE,100) END) as PCTSHARE,
	RARRHEADER.MSHARE,
	YEAR(RARRHEADER.RDATE) as RYEAR, 
	PCALC.DESCRIPTION 
FROM  Acceptance            
INNER JOIN COVER ON (COVER.CNO=ACCEPTANCE.CNO)    
LEFT JOIN RArrHeader On (RArrHeader.ANO=Acceptance.ANO)          
LEFT JOIN AISOURCE ISOURCE ON (ISOURCE.ANO=ACCEPTANCE.ANO)                
Outer Apply (
	Select
	 Count(PCalc.Currency) AS NUMCCY,              
	 MAX(PCALC.LMFACTOR) AS LMFACTOR,    
	 MAX(PCALC.RATE) AS RATE,              
	 MAX(PCALC.CRATE) AS CRATE,             
	 sum(PCalc.TSI*PCalc.Rate) AS TSI,                
	 sum(PCalc.OurShare*PCalc.Rate) AS OurShare,                
	 sum(PCalc.Amount*PCalc.Rate) AS Amount,                
	 sum(PCalc.Gross*PCalc.Rate) AS Gross,                
	 sum(PCalc.OGross*PCalc.Rate) AS OGross,           
	 sum(PCalc.Claim*PCalc.Rate) AS Claim,
	 MAX(PCALC.Description) as Description  
	from PCALC
	Where PCALC.ANO=Acceptance.ANO and Acceptance.PStatus='C'
) PCALC
Where Acceptance.ANO=@P_ANO                          
)                

GO

DROP Procedure QPCALC_ACCASS
GO
CREATE Procedure QPCALC_ACCASS (@P_ANO integer)     
AS     
SELECT ICALC.CURRENCY, ICALC.CODE, 
Min(ICalc.SDATE) as ISDate,
Max(ICalc.EDate) as IEDate,
(Case When coalesce(APayor.PolicyYearF,Payor.PolicyYearF)=1 then ICalc.SDate else coalesce(P.InstDate, ICalc.SDate) end) as SDate,
(Case When coalesce(APayor.PolicyYearF,Payor.PolicyYearF)=1 then ICalc.EDate else coalesce(P.InstLDate, ICalc.EDate) end) as EDate,
(Case When A1.AType='A' Then 0 else ICover.Adjustable end) as AdjustableF, 
ICALC.SANO, A2.LANO,     
Cast(Max(cast(RCover.NoRefundF as Integer)) as Bit) as NoRefundF,     
Max(Case When ICover.Adjustable=1 Then TOI.AdjMethod else '' end) as AdjMethod,     
AVG(ICALC.PRORATA) AS PPRORATA, 
MAX(CASE WHEN COALESCE(ISOURCE.TSI,0)<>0 THEN (ISOURCE.RAMOUNT/ISOURCE.TSI)*100 WHEN PCALC.TSI<>0 AND COALESCE(ISOURCE.LIMIT,0)<>0 THEN PCALC.OURSHARE/PCALC.TSI*100 ELSE COALESCE(ISOURCE.SHARE,100) END) as SHARE,
MAX(Case When PCalc.Description='Premium by Decreasing SI' then coalesce(P.InstSIPCT,100) else 100 end) AS InstSIPCT,     
SUM(
Case 
When (coalesce(APayor.ScheduleF,Payor.ScheduleF)=1 or (coalesce(APayor.PolicyYearF,Payor.PolicyYearF)=1 and coalesce(APayor.DecreasePremiumF,Payor.DecreasePremiumF)=1)) then coalesce(P.InstAmount,0)
else (Case When (PCALC.Description<>'' and PCALC.Description<>'Minimum Premium') then ICALC.GROSS*PCALC.GROSS/PCALC.OGROSS else ICALC.GROSS*RCALC.GROSS/RCALC.OGROSS end)
End
) as GROSS,
MAX(PCALC.GROSS) as TOTALGROSS,
SUM(ICALC.EGROSS*PCALC.EGROSS/PCALC.OEGROSS) as EGROSS,
MAX(PCALC.EGROSS) as TOTALEGROSS,
CAST(MAX(Case When Upper(PCALC.DESCRIPTION) in ('MINIMUM PREMIUM','POLICY MINIMUM PREMIUM') Then 1 else 0 end) as Bit) as MinimumPremiumF,     
SUM(ICALC.REINSTATEMENT) AS REINSTATEMENT,     
SUM(ICALC.DISCOUNT) AS DISCOUNT,     
SUM(ICALC.LOADING) AS LOADING,     
MAX(PCALC.TSI) as TSI,      --100% Sum Insured for Reinsurance Rate     
MAX(PCALC.Rate) As Rate,
MAX(RateTab.BPComm) as BPComm
FROM ICover     
inner join ICALC on (ICALC.INO=ICOVER.INO and ICALC.ANO=ICOVER.ANO)     
inner join TOI on (TOI.TOI=ICOVER.TOI)     
inner join RCALC on (ICALC.ANO=RCALC.ANO AND ICALC.CURRENCY=RCALC.CURRENCY AND ICALC.CODE=RCALC.CODE AND ICALC.TOR=RCALC.TOR AND ICALC.SDATE=RCALC.SDATE AND ICALC.EDATE=RCALC.EDATE AND ICALC.SANO=RCALC.SANO)     
inner join PCALC on (PCALC.ANO=ICALC.ANO AND PCALC.CURRENCY=ICALC.CURRENCY)     
Left join RCover on (RCover.ANO=RCalc.ANO and RCover.Code=RCalc.Code and RCover.SDate=RCalc.SDate)     
Inner Join RateTab on (RateTab.Code=ICalc.Code)
inner join ACCEPTANCE A1 On (A1.ANO=ICALC.ANO)     
inner join ACCEPTANCE A2 on (A2.ANO=ICALC.SANO)     
Inner Join RArrHeader R on (R.ANO=ICalc.ANO)     
left join AISource ISource on (ISource.ANO=A2.ANO)   
Left Join Payor on (Payor.ANO=@P_ANO)
Left Join APayor on (APayor.ANO=@P_ANO)  
Left Join Payor_Schedule P on (
	P.ANO=@P_ANO 
	and coalesce(APayor.SIScheduleF,Payor.SIScheduleF)=1
	and 
	(
	((coalesce(APayor.ScheduleF,Payor.ScheduleF)=1 or (coalesce(APayor.PolicyYearF,Payor.PolicyYearF)=1 and coalesce(APayor.DecreasePremiumF,Payor.DecreasePremiumF)=1)) and P.InstDate Between ICalc.SDate and dateadd(day,-1,ICalc.EDate)) 
	or
	((coalesce(APayor.RiskScheduleF,Payor.RiskScheduleF)=1) and ICalc.SDate Between P.InstDate and dateadd(day,-1,P.InstLDate))
	)
	)
WHERE ICover.ANO=@P_ANO and ICALC.GROSS<>0
GROUP BY ICALC.CURRENCY, ICALC.CODE, 
(Case When coalesce(APayor.PolicyYearF,Payor.PolicyYearF)=1 then ICalc.SDate else coalesce(P.InstDate, ICalc.SDate) end),
(Case When coalesce(APayor.PolicyYearF,Payor.PolicyYearF)=1 then ICalc.EDate else coalesce(P.InstLDate, ICalc.EDate) end),
(Case When A1.AType='A' Then 0 else ICover.Adjustable end), ICalc.SANO, A2.LANO     

