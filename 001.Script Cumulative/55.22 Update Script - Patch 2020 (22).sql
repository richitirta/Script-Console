
if exists (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'fn_RateCon') AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) )
BEGIN
DROP FUNCTION fn_RateCon
END
GO
CREATE FUNCTION fn_RateCon(@P_ANO as int,@P_Code as varchar(20),@P_TSI as Float, @P_SDate as smalldatetime)       
RETURNS Table       
AS RETURN (       
Select Top 1 *
From
(
	SELECT Top 1 cast(0 as Bit) as ProgressiveF, RateTab.Code, RateCon.AllowedF, 
	case 
	When RateCon.minPeriod=0 and RateCon.MaxPeriod=0 then RateCon.MinRate 
	Else 
		case 
		When RateTab.SPeriod=1 Then Cover.Prorata/(RateCon.MaxPeriod-RateCon.MinPeriod+1)*RateCon.MinRate
		else Case When TOC.PTerm=0 Then 12 else TOC.PTerm End /(RateCon.MaxPeriod-RateCon.MinPeriod+1)*RateCon.MinRate
		End
	End as MinRate,
	case 
	When RateCon.minPeriod=0 and RateCon.MaxPeriod=0 then RateCon.MaxRate
	Else 
		case 
		When RateTab.SPeriod=1 Then Cover.Prorata/(RateCon.MaxPeriod-RateCon.MinPeriod+1)*RateCon.MaxRate
		else Case When TOC.PTerm=0 Then 12 else TOC.PTerm End/(RateCon.MaxPeriod-RateCon.MinPeriod+1)*RateCon.MaxRate
		End
	End as MaxRate,
	RateCon.PML, RateCon.TExcess, RateTab.RateLoadingF,       
	Case When coalesce(RateCon.Loading,0)=0 Then 100 else RateCon.Loading end as Loading,       
	Case When coalesce(RateCon.PCTLOSS,0)=0 Then 100 else RateCon.PCTLOSS end as PCTLOSS,       
	--Rate Always in Percent       
	Case       
	When RateCon.Unit='F' then (Case When (Case When @P_TSI=0 Then 1 Else @P_TSI End)<>0 Then RateCon.Rate/(Case When @P_TSI=0 Then 1 Else @P_TSI End)*100 else 0 end)       
	When RateCon.Unit='M' then RateCon.Rate/10       
	else RateCon.Rate end as Rate,       
	RateCon.MaxTSI as MaxTSI,
	RateCon.PCalc     
	From Acceptance       
	INNER JOIN TOC on (TOC.TOC=Acceptance.TOC)
	INNER JOIN AInfo on (AInfo.ANO=Acceptance.ANO)       
	INNER JOIN COVER ON (COVER.CNO=ACCEPTANCE.CNO)       
	INNER JOIN RateTab ON ((RateTab.TOC=substring(Acceptance.TOC,1,len(RateTab.TOC))) and RateTab.Effective<=@P_SDate and RateTab.Code=@P_Code) 
	INNER JOIN RateCon on (    
	 RateCon.Code=RateTab.Code And ((Case When @P_TSI=0 Then 1 Else @P_TSI End)>=RateCon.MinTSI or RateCon.MinTSI=0) and ((Case When @P_TSI=0 Then 1 Else @P_TSI End)<=RateCon.MaxTSI or RateCon.MaxTSI=0)     
	 And RateCon.ALLOWEDF=1
	 And RateCon.ProgressiveF=0
	 And (
	 (RateTab.SPeriod=0 and (    
	 (datediff(month, @P_SDate, acceptance.edate)>=RateCon.MinPeriod)     
	 or (datediff(month, @P_SDate, acceptance.edate)=RateCon.MinPeriod-1 and day(@P_SDate)<day(acceptance.edate))     
	 or RateCon.MinPeriod=0)                               
	 And (    
	 (datediff(month, @P_SDate, acceptance.edate)<RateCon.MaxPeriod)     
	 or (datediff(month, @P_SDate, acceptance.edate)=RateCon.MaxPeriod and day(@P_SDate)>=day(acceptance.edate))     
	 or RateCon.MaxPeriod=0)) OR
	(RateTab.SPeriod=1 
	 and ((datediff(day, @P_SDate, acceptance.edate)>=RateCon.MinPeriod) or RateCon.MinPeriod=0)
	 And ((datediff(day, @P_SDate, acceptance.edate)<=RateCon.MaxPeriod) or RateCon.MaxPeriod=0))
	 )     
	) 
	WHERE Acceptance.ANO=@P_ANO       
	And (coalesce(RateCon.ValueID1,'')='' or AINFO.VALUEID1 =RateCon.ValueID1)       
	And (coalesce(RateCon.ValueID2,'')='' or AINFO.VALUEID2 =RateCon.ValueID2)       
	And (coalesce(RateCon.ValueID3,'')='' or AINFO.VALUEID3 =RateCon.ValueID3)       
	And (coalesce(RateCon.ValueID4,'')='' or AINFO.VALUEID4 =RateCon.ValueID4)       
	And (coalesce(RateCon.ValueID5,'')='' or AINFO.VALUEID5 =RateCon.ValueID5)       
	And (coalesce(RateCon.ValueID6,'')='' or AINFO.VALUEID6 =RateCon.ValueID6)       
	And (coalesce(RateCon.ValueID7,'')='' or AINFO.VALUEID7 =RateCon.ValueID7)       
	And (coalesce(RateCon.ValueID8,'')='' or AINFO.VALUEID8 =RateCon.ValueID8)       
	And (coalesce(RateCon.ValueID9,'')='' or AINFO.VALUEID9 =RateCon.ValueID9)       
	And (coalesce(RateCon.ValueID10,'')='' or AINFO.VALUEID10 =RateCon.ValueID10)       
	And (coalesce(RateCon.ValueID11,'')='' or AINFO.VALUEID11 =RateCon.ValueID11)       
	And (coalesce(RateCon.ValueID12,'')='' or AINFO.VALUEID12 =RateCon.ValueID12)       
	And (coalesce(RateCon.ValueID13,'')='' or AINFO.VALUEID13 =RateCon.ValueID13)       
	And (coalesce(RateCon.ValueID14,'')='' or AINFO.VALUEID14 =RateCon.ValueID14)       
	And (coalesce(RateCon.ValueID15,'')='' or AINFO.VALUEID15 =RateCon.ValueID15)       
	Order by       
	RateTab.Effective Desc,       
	len(coalesce(RateCon.ValueID1,'')) Desc,       
	len(coalesce(RateCon.ValueID2,'')) Desc,       
	len(coalesce(RateCon.ValueID3,'')) Desc,       
	len(coalesce(RateCon.ValueID4,'')) Desc,       
	len(coalesce(RateCon.ValueID5,'')) Desc,       
	len(coalesce(RateCon.ValueID6,'')) Desc,       
	len(coalesce(RateCon.ValueID7,'')) Desc,       
	len(coalesce(RateCon.ValueID8,'')) Desc,       
	len(coalesce(RateCon.ValueID9,'')) Desc,       
	len(coalesce(RateCon.ValueID10,'')) Desc,       
	len(coalesce(RateCon.ValueID11,'')) Desc,       
	len(coalesce(RateCon.ValueID12,'')) Desc,       
	len(coalesce(RateCon.ValueID13,'')) Desc,       
	len(coalesce(RateCon.ValueID14,'')) Desc,       
	len(coalesce(RateCon.ValueID15,'')) Desc       

	UNION ALL

	SELECT 
	cast(1 as Bit) as ProgressiveF,
	RateTab.Code, 
	Cast(Max(Cast(RateCon.AllowedF as Int)) as Bit) as AllowedF, 
	sum(Case When (Case When @P_TSI=0 Then 1 Else @P_TSI End)>=RateCon.MaxTSI Then RateCon.MaxTSI-RateCon.MinTSI Else (Case When @P_TSI=0 Then 1 Else @P_TSI End)-RateCon.MinTSI end*RateCon.MinRate/(Case When @P_TSI=0 Then 1 Else @P_TSI End)) as MinRate,
	sum(Case When (Case When @P_TSI=0 Then 1 Else @P_TSI End)>=RateCon.MaxTSI Then RateCon.MaxTSI-RateCon.MinTSI Else (Case When @P_TSI=0 Then 1 Else @P_TSI End)-RateCon.MinTSI end*RateCon.MaxRate/(Case When @P_TSI=0 Then 1 Else @P_TSI End)) as MaxRate,
	Max(RateCon.PML) as PML, 
	Max(RateCon.TExcess) as TExcess, 
	cast(Max(cast(RateTab.RateLoadingF as Int)) as Bit) as RateLoadingF,       
	Max(Case When coalesce(RateCon.Loading,0)=0 Then 100 else RateCon.Loading end) as Loading,       
	Max(Case When coalesce(RateCon.PCTLOSS,0)=0 Then 100 else RateCon.PCTLOSS end) as PCTLOSS,       
	--Rate Always in Percent       
	sum(
	Case       
	When RateCon.Unit='F' then (Case When (Case When @P_TSI=0 Then 1 Else @P_TSI End)<>0 Then RateCon.Rate/(Case When @P_TSI=0 Then 1 Else @P_TSI End)*100 else 0 end)       
	When RateCon.Unit='M' then 
		Case When (Case When @P_TSI=0 Then 1 Else @P_TSI End)>=RateCon.MaxTSI Then RateCon.MaxTSI-RateCon.MinTSI Else (Case When @P_TSI=0 Then 1 Else @P_TSI End)-RateCon.MinTSI end*RateCon.Rate/10/(Case When @P_TSI=0 Then 1 Else @P_TSI End) 
	else Case When (Case When @P_TSI=0 Then 1 Else @P_TSI End)>=RateCon.MaxTSI Then RateCon.MaxTSI-RateCon.MinTSI Else (Case When @P_TSI=0 Then 1 Else @P_TSI End)-RateCon.MinTSI end*RateCon.Rate/(Case When @P_TSI=0 Then 1 Else @P_TSI End) end 
	)as Rate,
	Max(RateCon.MaxTSI) as MaxTSI,
	Max(RateCon.PCalc) as PCalc
	From Acceptance       
	INNER JOIN TOC on (TOC.TOC=Acceptance.TOC)
	INNER JOIN AInfo on (AInfo.ANO=Acceptance.ANO)       
	INNER JOIN COVER ON (COVER.CNO=ACCEPTANCE.CNO)       
	INNER JOIN RateTab ON ((RateTab.TOC=substring(Acceptance.TOC,1,len(RateTab.TOC))) and RateTab.Effective<=@P_SDate and RateTab.Code=@P_Code)       
	INNER JOIN RateCon on (    
	 RateCon.Code=RateTab.Code 
	 And ((Case When @P_TSI=0 Then 1 Else @P_TSI End) Between RateCon.MinTSI and RateCon.MaxTSI or RateCon.MaxTSI<=(Case When @P_TSI=0 Then 1 Else @P_TSI End))
	 And RateCon.ALLOWEDF=1
	 And RateCon.ProgressiveF=1
	 And (
	 (RateTab.SPeriod=0 and (    
	 (datediff(month, @P_SDate, acceptance.edate)>=RateCon.MinPeriod)     
	 or (datediff(month, @P_SDate, acceptance.edate)=RateCon.MinPeriod-1 and day(@P_SDate)<day(acceptance.edate))     
	 or RateCon.MinPeriod=0)                               
	 And (    
	 (datediff(month, @P_SDate, acceptance.edate)<RateCon.MaxPeriod)     
	 or (datediff(month, @P_SDate, acceptance.edate)=RateCon.MaxPeriod and day(@P_SDate)>=day(acceptance.edate))     
	 or RateCon.MaxPeriod=0)) OR
	(RateTab.SPeriod=1 
	 and ((datediff(day, @P_SDate, acceptance.edate)>=RateCon.MinPeriod) or RateCon.MinPeriod=0)
	 And ((datediff(day, @P_SDate, acceptance.edate)<=RateCon.MaxPeriod) or RateCon.MaxPeriod=0))
	 )     
	) 
	WHERE Acceptance.ANO=@P_ANO       
	And (coalesce(RateCon.ValueID1,'')='' or AINFO.VALUEID1 =RateCon.ValueID1)       
	And (coalesce(RateCon.ValueID2,'')='' or AINFO.VALUEID2 =RateCon.ValueID2)       
	And (coalesce(RateCon.ValueID3,'')='' or AINFO.VALUEID3 =RateCon.ValueID3)       
	And (coalesce(RateCon.ValueID4,'')='' or AINFO.VALUEID4 =RateCon.ValueID4)       
	And (coalesce(RateCon.ValueID5,'')='' or AINFO.VALUEID5 =RateCon.ValueID5)       
	And (coalesce(RateCon.ValueID6,'')='' or AINFO.VALUEID6 =RateCon.ValueID6)       
	And (coalesce(RateCon.ValueID7,'')='' or AINFO.VALUEID7 =RateCon.ValueID7)       
	And (coalesce(RateCon.ValueID8,'')='' or AINFO.VALUEID8 =RateCon.ValueID8)       
	And (coalesce(RateCon.ValueID9,'')='' or AINFO.VALUEID9 =RateCon.ValueID9)       
	And (coalesce(RateCon.ValueID10,'')='' or AINFO.VALUEID10 =RateCon.ValueID10)       
	And (coalesce(RateCon.ValueID11,'')='' or AINFO.VALUEID11 =RateCon.ValueID11)       
	And (coalesce(RateCon.ValueID12,'')='' or AINFO.VALUEID12 =RateCon.ValueID12)       
	And (coalesce(RateCon.ValueID13,'')='' or AINFO.VALUEID13 =RateCon.ValueID13)       
	And (coalesce(RateCon.ValueID14,'')='' or AINFO.VALUEID14 =RateCon.ValueID14)       
	And (coalesce(RateCon.ValueID15,'')='' or AINFO.VALUEID15 =RateCon.ValueID15)       
	Group By RateTab.Code
) R
)       


GO
if exists (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'fn_Premium_Calc_Prorata') AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) )
BEGIN
DROP FUNCTION fn_Premium_Calc_Prorata
END
GO
CREATE FUNCTION fn_Premium_Calc_Prorata(@P_PSDate as smalldatetime, @P_PEDate as smalldatetime, @DaysProrata as Int, @MonthsProrata as Int, @P_PPeriod as integer)              
RETURNS Float
AS               
BEGIN              

Declare @P_Prorata as Float

if @P_PPeriod=2
Begin
	Select @P_Prorata=cast(datediff(Month,@P_PSDate, @P_PEDate) as Float)
	if day(@P_PSDate)>day(@P_PEDate)
	Begin
		Select @P_Prorata=@P_Prorata-1
			if @P_Prorata<0
				Select @P_Prorata=0
	End
	Select @P_Prorata=@P_Prorata / @monthsProrata	
End
Else 
Begin
	if day(@P_PSDate)<>day(@P_PEdate) or @P_PPeriod=1 
	Begin
		Select @P_Prorata=cast(datediff(day,@P_PSDate, @P_PEDate) as Float)/@DaysProrata
	End
	else
	Begin
		Select @P_Prorata=cast(datediff(month,@P_PSDate, @P_PEDate) as Float)/@MonthsProrata
	End
End

Return @P_Prorata

END  

GO
IF EXISTS ( SELECT * FROM   sysobjects WHERE  id = object_id(N'QPolicy_Rate') and OBJECTPROPERTY(id, N'IsProcedure') = 1 )
BEGIN
DROP Procedure QPolicy_Rate
END
GO
CREATE Procedure QPolicy_Rate(@P_ANO as int)     
as     
Select ICALC.Code, ICALC.SDate, SUM(ICALC.TSI) as TSI, Max(ICALC.PrevMinRate) as PrevMinRate, Max(ICALC.PrevMaxRate) as PrevMaxRate, Max(ICALC.MinRate) as MinRate, Max(ICALC.MaxRate) as MaxRate     
from     
(     
Select ICALC.Code, ICALC.SDate,     
MAX((Case When ICover.Category='M' then ICALC.TSI else 0 end)*(CASE WHEN RCOVER.PCTLOSS=0 THEN 100 ELSE RCOVER.PCTLOSS END)/(CASE WHEN RCOVER.PCTLOSS=0 THEN 100 ELSE RCOVER.PCTLOSS END+RCOVER.PAddition)) as TSI,     
CAST(0 as FLOAT) as PREVMINRATE,     
CAST(0 as FLOAT) as PREVMAXRATE,     
SUM(ICALC.GROSS*100/(100-RCover.Discount)/ICALC.TSI/(Case When RCOVER.LOADING=0 THEN 1 ELSE RCOVER.LOADING END)*Case When ICalc.PCTADJ<>0 Then cast(100 as Float)/ICALC.PCTADJ else 1 end
*Case When ICALC.Prorata=1 then 
(
	Case When Acceptance.EXCLUSIVEF=0 and Acceptance.STime<Acceptance.ETime and ICalc.EDate=Acceptance.EDate Then
		1/dbo.fn_Premium_calc_prorata(ICalc.sDate, dateadd(day,1,ICalc.edate), Cover.Prorata, (Case When TOC.PTerm=0 Then 12 else TOC.PTerm End), Cover.PPeriod)
	else
		1/dbo.fn_Premium_calc_prorata(ICalc.sDate, ICalc.EDate, Cover.Prorata, (Case When TOC.PTerm=0 Then 12 else TOC.PTerm End), Cover.PPeriod)
	End
) 
else 
(
Case When RCover.PCalc='P' and Cover.Voyage=0 then 
	Case When Acceptance.EXCLUSIVEF=0 and Acceptance.STime<Acceptance.ETime and ICalc.EDate=Acceptance.EDate Then
		1/dbo.fn_Premium_calc_prorata(ICalc.sDate, dateadd(day,1,ICalc.edate), Cover.Prorata, (Case When TOC.PTerm=0 Then 12 else TOC.PTerm End), Cover.PPeriod)
	else
		1/dbo.fn_Premium_calc_prorata(ICalc.sDate, ICalc.EDate, Cover.Prorata, (Case When TOC.PTerm=0 Then 12 else TOC.PTerm End), Cover.PPeriod)
	End
else 
	1/ICALC.Prorata end
) 
end
)*100+0.0000000001 as MINRATE,     

SUM(ICALC.GROSS*100/(100-RCover.Discount)/ICALC.TSI/(Case When RCOVER.LOADING=0 THEN 1 ELSE RCOVER.LOADING END)*Case When ICalc.PCTADJ<>0 Then cast(100 as Float)/ICALC.PCTADJ else 1 end
*Case When ICALC.Prorata=1 then 
(
	Case When Acceptance.EXCLUSIVEF=0 and Acceptance.STime<Acceptance.ETime and ICalc.EDate=Acceptance.EDate Then
		1/dbo.fn_Premium_calc_prorata(ICalc.sDate, dateadd(day,1,ICalc.edate), Cover.Prorata, (Case When TOC.PTerm=0 Then 12 else TOC.PTerm End), Cover.PPeriod)
	else
		1/dbo.fn_Premium_calc_prorata(ICalc.sDate, ICalc.EDate, Cover.Prorata, (Case When TOC.PTerm=0 Then 12 else TOC.PTerm End), Cover.PPeriod)
	End
) 
else 
(
Case When RCover.PCalc='P' and Cover.Voyage=0 then 
	Case When Acceptance.EXCLUSIVEF=0 and Acceptance.STime<Acceptance.ETime and ICalc.EDate=Acceptance.EDate Then
		1/dbo.fn_Premium_calc_prorata(ICalc.sDate, dateadd(day,1,ICalc.edate), Cover.Prorata, (Case When TOC.PTerm=0 Then 12 else TOC.PTerm End), Cover.PPeriod)
	else
		1/dbo.fn_Premium_calc_prorata(ICalc.sDate, ICalc.EDate, Cover.Prorata, (Case When TOC.PTerm=0 Then 12 else TOC.PTerm End), Cover.PPeriod)
	End
else 
	1/ICALC.Prorata end
) 
end
)*100-0.0000000001 as MAXRATE     
from COVER, ACCEPTANCE, ICover, ICALC, RCover, TOC
Where ACCEPTANCE.ANO=@P_ANO and COVER.CNO=ACCEPTANCE.CNO and COVER.ISType in ('I','C','L') and RCover.ANO=Acceptance.ANO     
and RCover.ANO=ICALC.ANO and RCover.Code=ICALC.Code and RCover.SDate=ICALC.SDate and RCover.EDate=ICALC.EDate and datediff(month, ICALC.SDate, ICALC.EDate)<>0     
and ICover.INO=ICalc.INO and ICALC.TSI<>0     
and TOC.TOC=ACCEPTANCE.TOC
and Cover.PROFORMAF=0
Group By ICalc.INO, ICALC.Code, ICALC.SDate     
     
Union All     
     
Select ICALC.Code, ICALC.SDate,     
0 as TSI,     
SUM(ICALC.GROSS*100/(100-RCover.Discount)/ICALC.TSI/(Case When RCOVER.LOADING=0 THEN 1 ELSE RCOVER.LOADING END)*Case When ICalc.PCTADJ<>0 Then cast(100 as Float)/ICALC.PCTADJ else 1 end
*Case When ICALC.Prorata=1 then 
(
	Case When pAcceptance.EXCLUSIVEF=0 and pAcceptance.STime<pAcceptance.ETime and ICalc.EDate=pAcceptance.EDate Then
		1/dbo.fn_Premium_calc_prorata(ICalc.sDate, dateadd(day,1,ICalc.edate), Cover.Prorata, (Case When TOC.PTerm=0 Then 12 else TOC.PTerm End), Cover.PPeriod)
	else
		1/dbo.fn_Premium_calc_prorata(ICalc.sDate, ICalc.EDate, Cover.Prorata, (Case When TOC.PTerm=0 Then 12 else TOC.PTerm End), Cover.PPeriod)
	End
) 
else 
(
Case When RCover.PCalc='P' and Cover.Voyage=0 then 
	Case When pAcceptance.EXCLUSIVEF=0 and pAcceptance.STime<pAcceptance.ETime and ICalc.EDate=pAcceptance.EDate Then
		1/dbo.fn_Premium_calc_prorata(ICalc.sDate, dateadd(day,1,ICalc.edate), Cover.Prorata, (Case When TOC.PTerm=0 Then 12 else TOC.PTerm End), Cover.PPeriod)
	else
		1/dbo.fn_Premium_calc_prorata(ICalc.sDate, ICalc.EDate, Cover.Prorata, (Case When TOC.PTerm=0 Then 12 else TOC.PTerm End), Cover.PPeriod)
	End
else 
	1/ICALC.Prorata end
) 
end
)*100+0.0000000001 as PREVMINRATE,     

SUM(ICALC.GROSS*100/(100-RCover.Discount)/ICALC.TSI/(Case When RCOVER.LOADING=0 THEN 1 ELSE RCOVER.LOADING END)*Case When ICalc.PCTADJ<>0 Then cast(100 as Float)/ICALC.PCTADJ else 1 end
*Case When ICALC.Prorata=1 then 
(
	Case When pAcceptance.EXCLUSIVEF=0 and pAcceptance.STime<pAcceptance.ETime and ICalc.EDate=pAcceptance.EDate Then
		1/dbo.fn_Premium_calc_prorata(ICalc.sDate, dateadd(day,1,ICalc.edate), Cover.Prorata, (Case When TOC.PTerm=0 Then 12 else TOC.PTerm End), Cover.PPeriod)
	else
		1/dbo.fn_Premium_calc_prorata(ICalc.sDate, ICalc.EDate, Cover.Prorata, (Case When TOC.PTerm=0 Then 12 else TOC.PTerm End), Cover.PPeriod)
	End
) 
else 
(
Case When RCover.PCalc='P' and Cover.Voyage=0 then 
	Case When pAcceptance.EXCLUSIVEF=0 and pAcceptance.STime<pAcceptance.ETime and ICalc.EDate=pAcceptance.EDate Then
		1/dbo.fn_Premium_calc_prorata(ICalc.sDate, dateadd(day,1,ICalc.edate), Cover.Prorata, (Case When TOC.PTerm=0 Then 12 else TOC.PTerm End), Cover.PPeriod)
	else
		1/dbo.fn_Premium_calc_prorata(ICalc.sDate, ICalc.EDate, Cover.Prorata, (Case When TOC.PTerm=0 Then 12 else TOC.PTerm End), Cover.PPeriod)
	End
else 
	1/ICALC.Prorata end
) 
end
)*100-0.0000000001 as PREVMAXRATE,
CAST(0 as FLOAT) as MINRATE,     
CAST(0 as FLOAT) as MAXRATE     
from COVER, ACCEPTANCE, ACCEPTANCE PACCEPTANCE, ICover, ICALC, RCover, TOC
Where ACCEPTANCE.ANO=@P_ANO and COVER.CNO=ACCEPTANCE.CNO and COVER.ISType in ('I','C','L') and PACCEPTANCE.ANO=ACCEPTANCE.PANO and RCOVER.ANO=PACCEPTANCE.ANO     
and RCover.ANO=ICALC.ANO and RCover.Code=ICALC.Code and RCover.SDate=ICALC.SDate and RCover.EDate=ICALC.EDate and datediff(month, ICALC.SDate, ICALC.EDate)<>0     
and ICover.INO=ICalc.INO and ICALC.TSI<>0     
and TOC.TOC=ACCEPTANCE.TOC
and Cover.PROFORMAF=0
Group By ICalc.INO, ICALC.Code, ICALC.SDate     
) ICALC     
Group By ICALC.Code, ICALC.SDate     
Having SUM(ICALC.TSI)<>0     

GO


insert into PatchVersioning
select '55.22 Update Script - Patch 2020 (22)',GETDATE()
go


Declare @PrevScript varchar(100)
Declare @CurrScript varchar(100)

Select @PrevScript='55.21 Update Script - Patch 2020 (21)'
Select @CurrSCript='55.22 Update Script - Patch 2020 (22)'


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




