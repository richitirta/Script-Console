--SCRIPT DISPLAY
if exists (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[DISPLAY_FACULTATIVE_BALANCE_PRORATA_CALCULATION]') AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) ) BEGIN DROP FUNCTION [dbo].[DISPLAY_FACULTATIVE_BALANCE_PRORATA_CALCULATION] END
if exists (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[DISPLAY_FACULTATIVE_CALCULATION]') AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) ) BEGIN DROP FUNCTION [dbo].[DISPLAY_FACULTATIVE_CALCULATION] END
if exists (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[DISPLAY_FACULTATIVE_PRORATA_CALCULATION]') AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) ) BEGIN DROP FUNCTION [dbo].[DISPLAY_FACULTATIVE_PRORATA_CALCULATION] END
if exists (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[DISPLAY_GROSS_CALCULATION]') AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) ) BEGIN DROP FUNCTION [dbo].[DISPLAY_GROSS_CALCULATION] END
if exists (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[DISPLAY_GROSS_FACULTATIVE_CALCULATION]') AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) ) BEGIN DROP FUNCTION [dbo].[DISPLAY_GROSS_FACULTATIVE_CALCULATION] END
if exists (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[DISPLAY_PRORATA_CALCULATION]') AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) ) BEGIN DROP FUNCTION [dbo].[DISPLAY_PRORATA_CALCULATION] END
GO





CREATE FUNCTION [dbo].[DISPLAY_FACULTATIVE_PRORATA_CALCULATION](@P_ANO int, @P_FID varchar(20)) 
RETURNS TABLE  AS 
RETURN ( 
select 
Distinct 
RCalc.ANO, 
RCalc.Code, 
RCalc.Currency, 
RCalc.SDate, 
RCalc.EDate, 
RCalc.TOR, 
RCalc.Gross, 
RCalc.OGross, 
FacProrata_Calculation= 
Case 
When Cover.Voyage=1 then ICalc.sProrata 
When RArrDet.PCalc='F' and RArrDet.NetRate=0 then ICalc.sProrata 
When RArrDet.PCalc='P' and RArrDet.CPCT<>0 then convert(varchar(25),Cast(RArrDet.CPCT as float),3)+'%' 
When Cast(Datediff(month, RCalc.Sdate, RCalc.EDate) as Float)<>0 then 
Case 
When RArrDet.PCalc='F' then 
convert(varchar(25),Cast(Datediff(month, RArrDet.FSDate, RArrDet.FEDate) as Float))+'/12' 
else 
Case 
When RArrDet.NetRate=0 then 
Case 
When RArrDet.PCalc='P' then 
Case 
When day(RArrDet.FSDate)=day(RArrDet.FEDate) and day(RCalc.SDate)=day(RCalc.EDate) and Cover.PPeriod<>1 then 
convert(varchar(25),Cast(Datediff(month, RArrDet.FSDate, RArrDet.FEDate) as Float))+'/12' 
else 
convert(varchar(25),Cast(DateDiff(day, RArrDet.FSDate, RArrDet.FEDate) as Float))+'/'+convert(varchar(25),Cover.Prorata) 
end 
else 
Case 
When day(RArrDet.FSDate)=day(RArrDet.FEDate) and day(RCalc.SDate)=day(RCalc.EDate) and Cover.PPeriod<>1 then 
convert(varchar(25),Cast(Datediff(month, RArrDet.FSDate, RArrDet.FEDate) as Float))+'/'+convert(varchar(25),Cast(Datediff(month, RCalc.Sdate, RCalc.EDate) as Float)) 
else 
convert(varchar(25),Cast(DateDiff(day, RArrDet.FSDate, RArrDet.FEDate) as Float))+'/'+convert(varchar(25),Cast(Datediff(Day, RCalc.Sdate, RCalc.EDate) as Float)) 
end 
end 
else 
Case 
When day(RArrDet.FSDate)=day(RArrDet.FEDate) and day(RCalc.SDate)=day(RCalc.EDate) and Cover.PPeriod<>1 then 
convert(varchar(25),Cast(Datediff(month, RArrDet.FSDate, RArrDet.FEDate) as Float))+'/12' 
else 
convert(varchar(25),Cast(DateDiff(day, RArrDet.FSDate, RArrDet.FEDate) as Float))+'/'+convert(varchar(25),Cover.Prorata) 
end 
end 
 
end 
Else 
Case 
When RArrDet.PCalc='P' then 
convert(varchar(25),Cast(DateDiff(day, RArrDet.FSDate, RArrDet.FEDate) as Float))+'/'+convert(varchar(25),Cover.Prorata) 
else 
ICalc.sProrata 
end 
end, 
FacProrata= 
Case 
When Cover.Voyage=1 then ICalc.Prorata 
When RArrDet.PCalc='F' and RArrDet.NetRate=0 then ICalc.Prorata 
When RArrDet.PCalc='P' and RArrDet.CPCT<>0 then RArrDet.CPCT/100 
When Cast(Datediff(month, RCalc.Sdate, RCalc.EDate) as Float)<>0 then 
Case 
When RArrDet.PCalc='F' then 
Cast(Datediff(month, RArrDet.FSDate, RArrDet.FEDate) as Float) / 12 
else 
Case 
When RArrDet.NetRate=0 then 
Case 
When RArrDet.PCalc='P' then 
Case 
When day(RArrDet.FSDate)=day(RArrDet.FEDate) and day(RCalc.SDate)=day(RCalc.EDate) and Cover.PPeriod<>1 then 
Cast(Datediff(month, RArrDet.FSDate, RArrDet.FEDate) as Float)/12 
else 
Cast(DateDiff(day, RArrDet.FSDate, RArrDet.FEDate) as Float) / Cover.Prorata 
end 
else 
Case 
When day(RArrDet.FSDate)=day(RArrDet.FEDate) and day(RCalc.SDate)=day(RCalc.EDate) and Cover.PPeriod<>1 then 
Cast(Datediff(month, RArrDet.FSDate, RArrDet.FEDate) as Float)/Cast(Datediff(month, RCalc.Sdate, RCalc.EDate) as Float) 
else 
Cast(DateDiff(day, RArrDet.FSDate, RArrDet.FEDate) as Float) /Cast(Datediff(Day, RCalc.Sdate, RCalc.EDate) as Float) 
end 
end 
else 
Case 
When day(RArrDet.FSDate)=day(RArrDet.FEDate) and day(RCalc.SDate)=day(RCalc.EDate) and Cover.PPeriod<>1 then 
Cast(Datediff(month, RArrDet.FSDate, RArrDet.FEDate) as Float)/12 
else 
Cast(DateDiff(day, RArrDet.FSDate, RArrDet.FEDate) as Float) / Cover.Prorata 
end 
end 
 
end 
Else 
Case 
When RArrDet.PCalc='P' then 
Cast(DateDiff(day, RArrDet.FSDate, RArrDet.FEDate) as Float) / Cover.Prorata 
else 
ICalc.Prorata 
end 
end 
From acceptance 
inner Join Cover on (Cover.CNO=Acceptance.CNO) 
inner join RCalc on (RCalc.ANO=Acceptance.ANO) 
inner join ICalc on (ICalc.ANO=RCalc.ANO and ICalc.Currency=RCalc.Currency and ICalc.Code=RCalc.Code and ICalc.SDate=RCalc.SDate and ICalc.EDate=RCalc.EDate and ICalc.TOR=RCalc.TOR) 
inner join (Select RArrDet.ANO, RCalc.Currency, Rcalc.Code, RCalc.SDate, RCalc.EDate, RArrDet.PCalc, RArrDet.CPCT, FPart.NetRate, Case When datediff(day, RCalc.SDate, RArrDet.SDate)>=0 then RArrDet.SDate else RCalc.SDate end as FSDate, Case When datediff( 
day, RArrDet.EDate, RCalc.EDate)>=0 then RArrDet.EDate else RCalc.EDate end as FEDate from RArrDet, FPart, RCalc, Acceptance Where Acceptance.ANO=@P_ANO and RArrDet.ANO=Acceptance.ANO and RArrDet.FID=@P_FID and FPart.ANO=RArrDet.ANO and FPart.FID=RArrDet. 
FID and RCalc.ANO=RArrDet.ANO and RArrDet.FullCoverF=1) RArrDet  on (RArrDet.ANO=RCalc.ANO and RArrDet.Currency=RCalc.Currency and RArrDet.Code=RCalc.Code and RArrDet.SDate=RCalc.SDate and RArrDet.EDate=RCalc.EDate) 
Where Acceptance.ANO=@P_ANO and RCalc.OGross<>0 and Cast(DateDiff(day, RArrDet.FSDate, RArrDet.FEDate) as Float) >  0 
 
union all 
 
select 
Distinct 
RCalc.ANO, 
RCalc.Code, 
RCalc.Currency, 
RCalc.SDate, 
RCalc.EDate, 
RCalc.TOR, 
RCalc.Gross, 
RCalc.OGross, 
FacProrata_Calculation= 
Case 
When Cover.Voyage=1 then ICalc.sProrata 
When RArrDet.PCalc='F' and RArrDet.NetRate=0 then ICalc.sProrata 
When RArrDet.PCalc='P' and RArrDet.CPCT<>0 then convert(varchar(25),Cast(RArrDet.CPCT as float),3)+'%' 
When Cast(Datediff(month, RCalc.Sdate, RCalc.EDate) as Float)<>0 then 
Case 
When RArrDet.PCalc='F' then 
convert(varchar(25),Cast(Datediff(month, RArrDet.FSDate, RArrDet.FEDate) as Float))+'/12' 
else 
Case 
When RArrDet.NetRate=0 then 
Case 
When RArrDet.PCalc='P' then 
Case 
When day(RArrDet.FSDate)=day(RArrDet.FEDate) and day(RCalc.SDate)=day(RCalc.EDate) and Cover.PPeriod<>1 then 
convert(varchar(25),Cast(Datediff(month, RArrDet.FSDate, RArrDet.FEDate) as Float))+'/12' 
else 
convert(varchar(25),Cast(DateDiff(day, RArrDet.FSDate, RArrDet.FEDate) as Float))+'/'+convert(varchar(25),Cover.Prorata) 
end 
else 
Case 
When day(RArrDet.FSDate)=day(RArrDet.FEDate) and day(RCalc.SDate)=day(RCalc.EDate) and Cover.PPeriod<>1 then 
convert(varchar(25),Cast(Datediff(month, RArrDet.FSDate, RArrDet.FEDate) as Float))+'/'+convert(varchar(25),Cast(Datediff(month, RCalc.Sdate, RCalc.EDate) as Float)) 
else 
convert(varchar(25),Cast(DateDiff(day, RArrDet.FSDate, RArrDet.FEDate) as Float))+'/'+convert(varchar(25),Cast(Datediff(Day, RCalc.Sdate, RCalc.EDate) as Float)) 
end 
end 
else 
Case 
When day(RArrDet.FSDate)=day(RArrDet.FEDate) and day(RCalc.SDate)=day(RCalc.EDate) and Cover.PPeriod<>1 then 
convert(varchar(25),Cast(Datediff(month, RArrDet.FSDate, RArrDet.FEDate) as Float))+'/12' 
else 
convert(varchar(25),Cast(DateDiff(day, RArrDet.FSDate, RArrDet.FEDate) as Float))+'/'+convert(varchar(25),Cover.Prorata) 
end 
end 
 
end 
Else 
Case 
When RArrDet.PCalc='P' then 
convert(varchar(25),Cast(DateDiff(day, RArrDet.FSDate, RArrDet.FEDate) as Float))+'/'+convert(varchar(25),Cover.Prorata) 
else 
ICalc.sProrata 
end 
end, 
FacProrata= 
Case 
When Cover.Voyage=1 then ICalc.Prorata 
When RArrDet.PCalc='F' and RArrDet.NetRate=0 then ICalc.Prorata 
When RArrDet.PCalc='P' and RArrDet.CPCT<>0 then RArrDet.CPCT/100 
When Cast(Datediff(month, RCalc.Sdate, RCalc.EDate) as Float)<>0 then 
Case 
When RArrDet.PCalc='F' then 
Cast(Datediff(month, RArrDet.FSDate, RArrDet.FEDate) as Float) / 12 
else 
Case 
When RArrDet.NetRate=0 then 
Case 
When RArrDet.PCalc='P' then 
Case 
When day(RArrDet.FSDate)=day(RArrDet.FEDate) and day(RCalc.SDate)=day(RCalc.EDate) and Cover.PPeriod<>1 then 
Cast(Datediff(month, RArrDet.FSDate, RArrDet.FEDate) as Float)/12 
else 
Cast(DateDiff(day, RArrDet.FSDate, RArrDet.FEDate) as Float) / Cover.Prorata 
end 
else 
Case 
When day(RArrDet.FSDate)=day(RArrDet.FEDate) and day(RCalc.SDate)=day(RCalc.EDate) and Cover.PPeriod<>1 then 
Cast(Datediff(month, RArrDet.FSDate, RArrDet.FEDate) as Float)/Cast(Datediff(month, RCalc.Sdate, RCalc.EDate) as Float) 
else 
Cast(DateDiff(day, RArrDet.FSDate, RArrDet.FEDate) as Float) /Cast(Datediff(Day, RCalc.Sdate, RCalc.EDate) as Float) 
end 
end 
else 
Case 
When day(RArrDet.FSDate)=day(RArrDet.FEDate) and day(RCalc.SDate)=day(RCalc.EDate) and Cover.PPeriod<>1 then 
Cast(Datediff(month, RArrDet.FSDate, RArrDet.FEDate) as Float)/12 
else 
Cast(DateDiff(day, RArrDet.FSDate, RArrDet.FEDate) as Float) / Cover.Prorata 
end 
end 
 
end 
Else 
Case 
When RArrDet.PCalc='P' then 
Cast(DateDiff(day, RArrDet.FSDate, RArrDet.FEDate) as Float) / Cover.Prorata 
else 
ICalc.Prorata 
end 
end 
From acceptance pAcceptance 
inner join Acceptance on (Acceptance.ANO=pAcceptance.pANO) 
inner Join Cover on (Cover.CNO=Acceptance.CNO) 
inner join RCalc on (RCalc.ANO=Acceptance.ANO) 
inner join ICalc on (ICalc.ANO=RCalc.ANO and ICalc.Currency=RCalc.Currency and ICalc.Code=RCalc.Code and ICalc.SDate=RCalc.SDate and ICalc.EDate=RCalc.EDate and ICalc.TOR=RCalc.TOR) 
inner join (Select RArrDet.ANO, RCalc.Currency, Rcalc.Code, RCalc.SDate, RCalc.EDate, RArrDet.PCalc, RArrDet.CPCT, FPart.NetRate, Case When datediff(day, RCalc.SDate, RArrDet.SDate)>=0 then RArrDet.SDate else RCalc.SDate end as FSDate, Case When datediff(day, RArrDet.EDate, RCalc.EDate)>=0 then RArrDet.EDate else RCalc.EDate end as FEDate from RArrDet, FPart, RCalc, Acceptance Where Acceptance.ANO=@P_ANO and RArrDet.ANO=Acceptance.pANO and RArrDet.FID=@P_FID and FPart.ANO=RArrDet.ANO and FPart.FID=RArrDet.FID and RCalc.ANO=RArrDet.ANO and RArrDet.FullCoverF=1) RArrDet  on (RArrDet.ANO=RCalc.ANO and RArrDet.Currency=RCalc.Currency and RArrDet.Code=RCalc.Code and RArrDet.SDate=RCalc.SDate and RArrDet.EDate=RCalc.EDate) 
Where pAcceptance.ANO=@P_ANO and RCalc.OGross<>0 and Cast(DateDiff(day, RArrDet.FSDate, RArrDet.FEDate) as Float) >  0 
 
UNION ALL 
 
select 
Distinct 
RCalc.ANO, 
RCalc.Code, 
RCalc.Currency, 
RCalc.SDate, 
RCalc.EDate, 
RCalc.TOR, 
RCalc.Gross, 
RCalc.OGross, 
FacProrata_Calculation= 
Case 
When Cover.Voyage=1 then ICalc.sProrata 
When RArrDet.PCalc='F' and RArrDet.NetRate=0 then ICalc.sProrata 
When RArrDet.PCalc='P' and RArrDet.CPCT<>0 then convert(varchar(25),Cast(RArrDet.CPCT as float),3)+'%' 
When Cast(Datediff(month, RCalc.Sdate, RCalc.EDate) as Float)<>0 then 
Case 
When RArrDet.PCalc='F' then 
convert(varchar(25),Cast(Datediff(month, RArrDet.FSDate, RArrDet.FEDate) as Float))+'/12' 
else 
Case 
When RArrDet.NetRate=0 then 
Case 
When RArrDet.PCalc='P' then 
Case 
When day(RArrDet.FSDate)=day(RArrDet.FEDate) and day(RCalc.SDate)=day(RCalc.EDate) and Cover.PPeriod<>1 then 
convert(varchar(25),Cast(Datediff(month, RArrDet.FSDate, RArrDet.FEDate) as Float))+'/12' 
else 
convert(varchar(25),Cast(DateDiff(day, RArrDet.FSDate, RArrDet.FEDate) as Float))+'/'+convert(varchar(25),Cover.Prorata) 
end 
else 
Case 
When day(RArrDet.FSDate)=day(RArrDet.FEDate) and day(RCalc.SDate)=day(RCalc.EDate) and Cover.PPeriod<>1 then 
convert(varchar(25),Cast(Datediff(month, RArrDet.FSDate, RArrDet.FEDate) as Float))+'/'+convert(varchar(25),Cast(Datediff(month, RCalc.Sdate, RCalc.EDate) as Float)) 
else 
convert(varchar(25),Cast(DateDiff(day, RArrDet.FSDate, RArrDet.FEDate) as Float))+'/'+convert(varchar(25),Cast(Datediff(Day, RCalc.Sdate, RCalc.EDate) as Float)) 
end 
end 
else 
Case 
When day(RArrDet.FSDate)=day(RArrDet.FEDate) and day(RCalc.SDate)=day(RCalc.EDate) and Cover.PPeriod<>1 then 
convert(varchar(25),Cast(Datediff(month, RArrDet.FSDate, RArrDet.FEDate) as Float))+'/12' 
else 
convert(varchar(25),Cast(DateDiff(day, RArrDet.FSDate, RArrDet.FEDate) as Float))+'/'+convert(varchar(25),Cover.Prorata) 
end 
end 
 
end 
Else 
Case 
When RArrDet.PCalc='P' then 
convert(varchar(25),Cast(DateDiff(day, RArrDet.FSDate, RArrDet.FEDate) as Float))+'/'+convert(varchar(25),Cover.Prorata) 
else 
ICalc.sProrata 
end 
end, 
FacProrata= 
Case 
When Cover.Voyage=1 then ICalc.Prorata 
When RArrDet.PCalc='F' and RArrDet.NetRate=0 then ICalc.Prorata 
When RArrDet.PCalc='P' and RArrDet.CPCT<>0 then RArrDet.CPCT/100 
When Cast(Datediff(month, RCalc.Sdate, RCalc.EDate) as Float)<>0 then 
Case 
When RArrDet.PCalc='F' then 
Cast(Datediff(month, RArrDet.FSDate, RArrDet.FEDate) as Float) / 12 
else 
Case 
When RArrDet.NetRate=0 then 
Case 
When RArrDet.PCalc='P' then 
Case 
When day(RArrDet.FSDate)=day(RArrDet.FEDate) and day(RCalc.SDate)=day(RCalc.EDate) and Cover.PPeriod<>1 then 
Cast(Datediff(month, RArrDet.FSDate, RArrDet.FEDate) as Float)/12 
else 
Cast(DateDiff(day, RArrDet.FSDate, RArrDet.FEDate) as Float) / Cover.Prorata 
end 
else 
Case 
When day(RArrDet.FSDate)=day(RArrDet.FEDate) and day(RCalc.SDate)=day(RCalc.EDate) and Cover.PPeriod<>1 then 
Cast(Datediff(month, RArrDet.FSDate, RArrDet.FEDate) as Float)/Cast(Datediff(month, RCalc.Sdate, RCalc.EDate) as Float) 
else 
Cast(DateDiff(day, RArrDet.FSDate, RArrDet.FEDate) as Float) /Cast(Datediff(Day, RCalc.Sdate, RCalc.EDate) as Float) 
end 
end 
else 
Case 
When day(RArrDet.FSDate)=day(RArrDet.FEDate) and day(RCalc.SDate)=day(RCalc.EDate) and Cover.PPeriod<>1 then 
Cast(Datediff(month, RArrDet.FSDate, RArrDet.FEDate) as Float)/12 
else 
Cast(DateDiff(day, RArrDet.FSDate, RArrDet.FEDate) as Float) / Cover.Prorata 
end 
end 
 
end 
Else 
Case 
When RArrDet.PCalc='P' then 
Cast(DateDiff(day, RArrDet.FSDate, RArrDet.FEDate) as Float) / Cover.Prorata 
else 
ICalc.Prorata 
end 
end 
From acceptance 
inner Join Cover on (Cover.CNO=Acceptance.CNO) 
inner join RCalc on (RCalc.ANO=Acceptance.ANO) 
inner join ICalc on (ICalc.ANO=RCalc.ANO and ICalc.Currency=RCalc.Currency and ICalc.Code=RCalc.Code and ICalc.SDate=RCalc.SDate and ICalc.EDate=RCalc.EDate and ICalc.TOR=RCalc.TOR) 
inner join ( 
Select RArrDet.ANO, RCalc.Currency, Rcalc.TOR, RCalc.SDate, RCalc.EDate, RArrDet.PCalc, RArrDet.CPCT, FPart.NetRate, Case When datediff(day, RCalc.SDate, RArrDet.SDate)>=0 then RArrDet.SDate else RCalc.SDate end as FSDate, Case When datediff(day, RArrDet.EDate, RCalc.EDate)>=0 then RArrDet.EDate else RCalc.EDate end as FEDate 
from RArrDet, FPartDet FPart, RateCov, RCalc, Acceptance 
Where Acceptance.ANO=@P_ANO and RArrDet.ANO=Acceptance.ANO and RArrDet.FID=@P_FID and FPart.ANO=RArrDet.ANO and FPart.FID=RArrDet.FID 
and RateCov.Code=FPart.Code and RateCov.TOR=RCalc.TOR and RCalc.ANO=RArrDet.ANO and RArrDet.FullCoverF=0 
) RArrDet  on (RArrDet.ANO=RCalc.ANO and RArrDet.Currency=RCalc.Currency and RArrDet.TOR=RCalc.TOR and RArrDet.SDate=RCalc.SDate and RArrDet.EDate=RCalc.EDate) 
Where Acceptance.ANO=@P_ANO and RCalc.OGross<>0 and Cast(DateDiff(day, RArrDet.FSDate, RArrDet.FEDate) as Float) >  0 
 
union all 
 
select 
Distinct 
RCalc.ANO, 
RCalc.Code, 
RCalc.Currency, 
RCalc.SDate, 
RCalc.EDate, 
RCalc.TOR, 
RCalc.Gross, 
RCalc.OGross, 
FacProrata_Calculation= 
Case 
When Cover.Voyage=1 then ICalc.sProrata 
When RArrDet.PCalc='F' and RArrDet.NetRate=0 then ICalc.sProrata 
When RArrDet.PCalc='P' and RArrDet.CPCT<>0 then convert(varchar(25),Cast(RArrDet.CPCT as float),3)+'%' 
When Cast(Datediff(month, RCalc.Sdate, RCalc.EDate) as Float)<>0 then 
Case 
When RArrDet.PCalc='F' then 
convert(varchar(25),Cast(Datediff(month, RArrDet.FSDate, RArrDet.FEDate) as Float))+'/12' 
else 
Case 
When RArrDet.NetRate=0 then 
Case 
When RArrDet.PCalc='P' then 
Case 
When day(RArrDet.FSDate)=day(RArrDet.FEDate) and day(RCalc.SDate)=day(RCalc.EDate) and Cover.PPeriod<>1 then 
convert(varchar(25),Cast(Datediff(month, RArrDet.FSDate, RArrDet.FEDate) as Float))+'/12' 
else 
convert(varchar(25),Cast(DateDiff(day, RArrDet.FSDate, RArrDet.FEDate) as Float))+'/'+convert(varchar(25),Cover.Prorata) 
end 
else 
Case 
When day(RArrDet.FSDate)=day(RArrDet.FEDate) and day(RCalc.SDate)=day(RCalc.EDate) and Cover.PPeriod<>1 then 
convert(varchar(25),Cast(Datediff(month, RArrDet.FSDate, RArrDet.FEDate) as Float))+'/'+convert(varchar(25),Cast(Datediff(month, RCalc.Sdate, RCalc.EDate) as Float)) 
else 
convert(varchar(25),Cast(DateDiff(day, RArrDet.FSDate, RArrDet.FEDate) as Float))+'/'+convert(varchar(25),Cast(Datediff(Day, RCalc.Sdate, RCalc.EDate) as Float)) 
end 
end 
else 
Case 
When day(RArrDet.FSDate)=day(RArrDet.FEDate) and day(RCalc.SDate)=day(RCalc.EDate) and Cover.PPeriod<>1 then 
convert(varchar(25),Cast(Datediff(month, RArrDet.FSDate, RArrDet.FEDate) as Float))+'/12' 
else 
convert(varchar(25),Cast(DateDiff(day, RArrDet.FSDate, RArrDet.FEDate) as Float))+'/'+convert(varchar(25),Cover.Prorata) 
end 
end 
 
end 
Else 
Case 
When RArrDet.PCalc='P' then 
convert(varchar(25),Cast(DateDiff(day, RArrDet.FSDate, RArrDet.FEDate) as Float))+'/'+convert(varchar(25),Cover.Prorata) 
else 
ICalc.sProrata 
end 
end, 
FacProrata= 
Case 
When Cover.Voyage=1 then ICalc.Prorata 
When RArrDet.PCalc='F' and RArrDet.NetRate=0 then ICalc.Prorata 
When RArrDet.PCalc='P' and RArrDet.CPCT<>0 then RArrDet.CPCT/100 
When Cast(Datediff(month, RCalc.Sdate, RCalc.EDate) as Float)<>0 then 
Case 
When RArrDet.PCalc='F' then 
Cast(Datediff(month, RArrDet.FSDate, RArrDet.FEDate) as Float) / 12 
else 
Case 
When RArrDet.NetRate=0 then 
Case 
When RArrDet.PCalc='P' then 
Case 
When day(RArrDet.FSDate)=day(RArrDet.FEDate) and day(RCalc.SDate)=day(RCalc.EDate) and Cover.PPeriod<>1 then 
Cast(Datediff(month, RArrDet.FSDate, RArrDet.FEDate) as Float)/12 
else 
Cast(DateDiff(day, RArrDet.FSDate, RArrDet.FEDate) as Float) / Cover.Prorata 
end 
else 
Case 
When day(RArrDet.FSDate)=day(RArrDet.FEDate) and day(RCalc.SDate)=day(RCalc.EDate) and Cover.PPeriod<>1 then 
Cast(Datediff(month, RArrDet.FSDate, RArrDet.FEDate) as Float)/Cast(Datediff(month, RCalc.Sdate, RCalc.EDate) as Float) 
else 
Cast(DateDiff(day, RArrDet.FSDate, RArrDet.FEDate) as Float) /Cast(Datediff(Day, RCalc.Sdate, RCalc.EDate) as Float) 
end 
end 
else 
Case 
When day(RArrDet.FSDate)=day(RArrDet.FEDate) and day(RCalc.SDate)=day(RCalc.EDate) and Cover.PPeriod<>1 then 
Cast(Datediff(month, RArrDet.FSDate, RArrDet.FEDate) as Float)/12 
else 
Cast(DateDiff(day, RArrDet.FSDate, RArrDet.FEDate) as Float) / Cover.Prorata 
end 
end 
 
end 
Else 
Case 
When RArrDet.PCalc='P' then 
Cast(DateDiff(day, RArrDet.FSDate, RArrDet.FEDate) as Float) / Cover.Prorata 
else 
ICalc.Prorata 
end 
end 
From acceptance pAcceptance 
inner join Acceptance on (Acceptance.ANO=pAcceptance.pANO) 
inner Join Cover on (Cover.CNO=Acceptance.CNO) 
inner join RCalc on (RCalc.ANO=Acceptance.ANO) 
inner join ICalc on (ICalc.ANO=RCalc.ANO and ICalc.Currency=RCalc.Currency and ICalc.Code=RCalc.Code and ICalc.SDate=RCalc.SDate and ICalc.EDate=RCalc.EDate and ICalc.TOR=RCalc.TOR) 
inner join ( 
Select RArrDet.ANO, RCalc.Currency, Rcalc.TOR, RCalc.SDate, RCalc.EDate, RArrDet.PCalc, RArrDet.CPCT, FPart.NetRate, Case When datediff(day, RCalc.SDate, RArrDet.SDate)>=0 then RArrDet.SDate else RCalc.SDate end as FSDate, Case When datediff(day, RArrDet.EDate, RCalc.EDate)>=0 then RArrDet.EDate else RCalc.EDate end as FEDate 
from RArrDet, FPartDet FPart, RateCov, RCalc, Acceptance 
Where Acceptance.ANO=@P_ANO and RArrDet.ANO=Acceptance.pANO and RArrDet.FID=@P_FID and FPart.ANO=RArrDet.ANO and FPart.FID=RArrDet.FID 
and RateCov.Code=FPart.Code and RateCov.TOR=RCalc.TOR and RCalc.ANO=RArrDet.ANO and RArrDet.FullCoverF=0 
) RArrDet  on (RArrDet.ANO=RCalc.ANO and RArrDet.Currency=RCalc.Currency and RArrDet.TOR=RCalc.TOR and RArrDet.SDate=RCalc.SDate and RArrDet.EDate=RCalc.EDate) 
Where pAcceptance.ANO=@P_ANO and RCalc.OGross<>0 and Cast(DateDiff(day, RArrDet.FSDate, RArrDet.FEDate) as Float) >  0 
 
) 
 

GO


CREATE FUNCTION [dbo].[DISPLAY_GROSS_FACULTATIVE_CALCULATION](@P_ANO int, @P_FID Varchar(20)) 
RETURNS TABLE  AS 
RETURN ( 
--1 
Select ICalc.ANO, ICalc.Currency, ICalc.Code, ICalc.FCode, ICalc.SDate, ICalc.EDate, 
Gross= 
Case 
When Max(ICalc.NetRate)=0 then 
case When Max(ICalc.FLPCT)=0 Then 
sum(ICalc.PCTShare/100*ICalc.Gross*(Case When ICalc.OnGrossAfterCommF=1 Then (100-dbo.Premium_Commission(ICalc.ANO, ICalc.Code,0,0))/100 else 1 end)/Icalc.PProrata)*max(ICalc.FacProrata)*max(ICalc.Share)/100 
else 
sum(ICalc.PCTShare/100*ICalc.Gross*(Case When ICalc.OnGrossAfterCommF=1 Then (100-dbo.Premium_Commission(ICalc.ANO, ICalc.Code,0,0))/100 else 1 end)/Icalc.PProrata)*max(ICalc.FacProrata) 
end 
else 
case When Max(ICalc.FLPCT)=0 Then 
	   Case When Max(ICalc.Unit)='F' Then 
		sum(ICalc.PCTShare/100)*Max(ICalc.NetRate)*max(ICalc.FacProrata) 
	   else 
		sum(ICalc.PCTShare/100*Icalc.TSI*ICalc.PCTADJ/100)*Max(ICalc.NetRate)/100*max(ICalc.FacProrata)*max(ICalc.Share)/100 
	   end 
else 
	   Case When Max(ICalc.Unit)='F' Then 
		sum(ICalc.PCTShare/100)*Max(ICalc.NetRate)*max(ICalc.FacProrata) 
	   else 
		sum(ICalc.PCTShare/100*Icalc.TSI*ICalc.PCTADJ/100)*Max(ICalc.NetRate)/100*max(ICalc.FacProrata) 
	   end 
end 
end, 
Calculation= 
Case 
When Max(ICalc.NetRate)=0 Then 
case When Max(ICalc.FLPCT)=0 Then 
convert(varchar(25), cast(sum(ICalc.PCTShare/100*ICalc.Gross*(Case When ICalc.OnGrossAfterCommF=1 Then (100-dbo.Premium_Commission(ICalc.ANO, ICalc.Code,0,0))/100 else 1 end)/ICalc.PProrata) as Money),1) + Case When max(ICalc.FacProrata_Calculation)='' or Max(ICalc.FacProrata)=1 Then '' Else ' x ' + max(ICalc.FacProrata_Calculation) End + ' x '+convert(varchar(25), Max(ICalc.Share),3)+'%' 
else 
convert(varchar(25), cast(sum(ICalc.PCTShare/100*ICalc.Gross*(Case When ICalc.OnGrossAfterCommF=1 Then (100-dbo.Premium_Commission(ICalc.ANO, ICalc.Code,0,0))/100 else 1 end)/ICalc.PProrata) as Money),1) + Case When max(ICalc.FacProrata_Calculation)='' or Max(ICalc.FacProrata)=1 Then '' Else ' x ' + max(ICalc.FacProrata_Calculation) End 
end 
else 
Case When Max(ICalc.FacProrata*ICalc.NetRateProrata)=1 then 
case When Max(ICalc.FLPCT)=0 Then 
		case When Max(ICalc.Unit)='F' Then 
			Case When sum(ICalc.PCTShare)<>100 Then convert(varchar(25), cast(sum(ICalc.PCTShare) as Money),1) + ' x ' else '' end +convert(varchar(25), Cast(Max(ICalc.NetRate/ICalc.NetRateProrata) as Money),1) + Case When max(ICalc.FacProrata_Calculation)='' or Max(ICalc.FacProrata*ICalc.NetRateProrata)=1 Then '' Else ' x ' + max(ICalc.FacProrata_Calculation) End 
		else 
			convert(varchar(25), cast(sum(ICalc.PCTShare/100*Icalc.TSI*ICalc.PCTADJ/100) as Money),1) + ' x '+convert(varchar(25), cast(Max(ICalc.NetRate/ICalc.NetRateProrata) as Money),2)+'%' + Case When max(ICalc.FacProrata_Calculation)='' or Max(ICalc.FacProrata*ICalc.NetRateProrata)=1 Then '' Else ' x ' + max(ICalc.FacProrata_Calculation) End + ' x '+convert(varchar(25), Max(ICalc.Share),3)+'%' 
		end 
else 
		Case When Max(ICalc.Unit)='F' Then		 
			Case When sum(ICalc.PCTShare)<>100 Then convert(varchar(25), cast(sum(ICalc.PCTShare) as Money),1) + ' x ' else '' end +convert(varchar(25), Cast(Max(ICalc.NetRate/ICalc.NetRateProrata) as Money),1) + Case When max(ICalc.FacProrata_Calculation)='' or Max(ICalc.FacProrata*ICalc.NetRateProrata)=1 Then '' Else ' x ' + max(ICalc.FacProrata_Calculation) End 
		else 
			convert(varchar(25), cast(sum(ICalc.PCTShare/100*Icalc.TSI*ICalc.PCTADJ/100) as Money),1) + ' x '+convert(varchar(25), cast(Max(ICalc.NetRate/ICalc.NetRateProrata) as Money),2)+'%' + Case When max(ICalc.FacProrata_Calculation)='' or Max(ICalc.FacProrata*ICalc.NetRateProrata)=1 Then '' Else ' x ' + max(ICalc.FacProrata_Calculation) End 		 
		end 
end 
else 
case When Max(ICalc.FLPCT)=0 Then 
		Case When Max(ICalc.Unit)='F' Then 
			Case When sum(ICalc.PCTShare)<>100 Then convert(varchar(25), cast(sum(ICalc.PCTShare) as Money),1) + ' x ' else '' end +convert(varchar(25), Max(ICalc.NetRate),1) + Case When max(ICalc.FacProrata_Calculation)='' or Max(ICalc.FacProrata)=1 Then '' Else ' x ' + max(ICalc.FacProrata_Calculation) End 
		else 
			convert(varchar(25), cast(sum(ICalc.PCTShare/100*Icalc.TSI*ICalc.PCTADJ/100) as Money),1) + ' x '+convert(varchar(25), Max(ICalc.NetRate),3)+'%' + Case When max(ICalc.FacProrata_Calculation)='' or Max(ICalc.FacProrata)=1 Then '' Else ' x ' + max(ICalc.FacProrata_Calculation) End + ' x '+convert(varchar(25), Max(ICalc.Share),3)+'%'    		 
		end 
else 
		Case When Max(ICalc.Unit)='F' then 
			Case When sum(ICalc.PCTShare)<>100 Then convert(varchar(25), cast(sum(ICalc.PCTShare) as Money),1) + ' x ' else '' end +convert(varchar(25), Max(ICalc.NetRate),1) + Case When max(ICalc.FacProrata_Calculation)='' or Max(ICalc.FacProrata)=1 Then '' Else ' x ' + max(ICalc.FacProrata_Calculation) End 
		else 
			convert(varchar(25), cast(sum(ICalc.PCTShare/100*Icalc.TSI*ICalc.PCTADJ/100) as Money),1) + ' x '+convert(varchar(25), Max(ICalc.NetRate),3)+'%' + Case When max(ICalc.FacProrata_Calculation)='' or Max(ICalc.FacProrata)=1 Then '' Else ' x ' + max(ICalc.FacProrata_Calculation) End     		 
		end 
end 
end 
End 
From 
(Select ICalc.ANO, ICalc.INO, ICalc.Currency, ICalc.Code, ICalc.Sdate, ICalc.Edate, ICalc.PCTAdj, 
Max(FPart.Code) as FCode, 
Max(D.FacProrata_Calculation) as FacProrata_calculation, 
Max(D.FacProrata) as FacProrata, 
SUM(Case When PCALC.Description<>'' and PCALC.Description<>'Minimum Premium' then ICALC.GROSS*PCALC.GROSS/PCALC.OGROSS else ICALC.GROSS*D.GROSS/D.OGROSS end) AS GROSS, 
AVG(ICalc.Prorata) as PProrata, 
Max(PCalc.Ourshare/PCalc.TSI*100) as PCTShare, 
Max(ICalc.SRate) as SRate, 
Max(ICalc.TSI) as TSI, 
SUM(ICalc.Rate) as Rate, 
Max(Case When RArrDet.PCalc='P' or datediff(month,RArrDet.SDate, RArrDet.EDate)=0 or Cover.Voyage=1 Then 1 else 12/cast(datediff(month,RArrDet.SDate, RArrDet.EDate) as float) end) as NetRateProrata, 
Max(FPart.NetRate*Case When RArrDet.PCalc='P' or datediff(month,RArrDet.SDate, RArrDet.EDate)=0 or Cover.Voyage=1 Then 1 else 12/cast(datediff(month,RArrDet.SDate, RArrDet.EDate) as float) end)/Max(I.RiskNum) as NetRate, 
Max(FPart.Unit) as Unit, 
Max(RArrDet.Share) as Share, 
Max(RArrDet.FLPCT) as FLPCT, 
Max(ICalc.sProrata) as sProrata, 
Max(Cast(RArrDet.OnGrossAfterCommF as Integer)) as OnGrossAfterCommF 
from ICalc, PCalc, (Select ANO, INO, Currency, SDate, EDate, Count(Distinct Code) as RiskNum from ICalc Where Gross<>0 and ANO=@P_ANO Group By ANO, INO, Currency, SDate, EDate) I, DISPLAY_FACULTATIVE_PRORATA_CALCULATION(@P_ANO, @P_FID) D, FPart, RArrDet, Acceptance, Cover 
Where Acceptance.ANO=@P_ANO and Cover.CNO=Acceptance.CNO and ICalc.ANO=Acceptance.ANO and ICalc.Rate<>0 and PCalc.ANO=ICalc.ANO and PCalc.Currency=ICalc.Currency 
and I.ANO=ICalc.ANO and I.INO=ICalc.INO and I.Currency=ICalc.Currency and I.SDate=ICalc.SDate and I.EDate=ICalc.EDate 
and D.ANO=ICalc.ANO and D.Currency=ICalc.Currency and D.Code=ICalc.Code and D.SDate=ICalc.Sdate and D.EDate=ICalc.EDate and D.TOR=ICalc.TOR 
and RArrDet.FullCoverF=1 and RArrDet.ANO=D.ANO and RArrDet.FID=@P_FID and FPart.ANO=RArrDet.ANO and FPart.FID=RArrdet.FID 
and RArrDet.NoRefundF=0 
Group By ICalc.ANO, ICalc.INO, ICalc.Currency, ICalc.Code, ICalc.SDate, ICalc.EDate, ICalc.PCTAdj 
) ICalc 
Group By ICalc.ANO, ICalc.Currency, ICalc.Code, ICalc.FCode, ICalc.SDate, ICalc.EDate, ICalc.SRate, ICalc.sProrata, ICalc.PCTadj 
 
UNION ALL 
 
 
--2 (Refund from Endorsement) 
Select ICalc.ANO, ICalc.Currency, ICalc.Code, ICalc.FCode, ICalc.SDate, ICalc.EDate, 
Gross=- 
Case 
When Max(ICalc.NetRate)=0 then 
case When Max(ICalc.FLPCT)=0 Then 
sum(ICalc.PCTShare/100*ICalc.Gross*(Case When ICalc.OnGrossAfterCommF=1 Then (100-dbo.Premium_Commission(ICalc.ANO, ICalc.Code,0,0))/100 else 1 end)/Icalc.PProrata)*max(ICalc.FacProrata)*max(ICalc.Share)/100 
else 
sum(ICalc.PCTShare/100*ICalc.Gross*(Case When ICalc.OnGrossAfterCommF=1 Then (100-dbo.Premium_Commission(ICalc.ANO, ICalc.Code,0,0))/100 else 1 end)/Icalc.PProrata)*max(ICalc.FacProrata) 
end 
else 
case When Max(ICalc.FLPCT)=0 Then 
	   Case When Max(ICalc.Unit)='F' Then 
		sum(ICalc.PCTShare/100)*Max(ICalc.NetRate)*max(ICalc.FacProrata) 
	   else 
		sum(ICalc.PCTShare/100*Icalc.TSI*ICalc.PCTADJ/100)*Max(ICalc.NetRate)/100*max(ICalc.FacProrata)*max(ICalc.Share)/100 
	   end 
else 
	   Case When Max(ICalc.Unit)='F' Then 
		sum(ICalc.PCTShare/100)*Max(ICalc.NetRate)*max(ICalc.FacProrata) 
	   else 
		sum(ICalc.PCTShare/100*Icalc.TSI*ICalc.PCTADJ/100)*Max(ICalc.NetRate)/100*max(ICalc.FacProrata) 
	   end 
end 
end 
* Case When Max(ICalc.AType)='C' and Max(ICalc.EMethod)<>'A' and Max(ICalc.CPRefund)<>0 then Max(ICalc.CPRefund)/100 else 1 end, 
Calculation= 
Case 
When Max(ICalc.NetRate)=0 Then 
case When Max(ICalc.FLPCT)=0 Then 
'- ' + convert(varchar(25), cast(sum(ICalc.PCTShare/100*ICalc.Gross*(Case When ICalc.OnGrossAfterCommF=1 Then (100-dbo.Premium_Commission(ICalc.ANO, ICalc.Code,0,0))/100 else 1 end)/ICalc.PProrata) as Money),1) + Case When max(ICalc.FacProrata_Calculation)='' or Max(ICalc.FacProrata)=1 Then '' Else ' x ' + max(ICalc.FacProrata_Calculation) End + ' x '+convert(varchar(25), Max(ICalc.Share),3)+'%' 
else 
'- ' + convert(varchar(25), cast(sum(ICalc.PCTShare/100*ICalc.Gross*(Case When ICalc.OnGrossAfterCommF=1 Then (100-dbo.Premium_Commission(ICalc.ANO, ICalc.Code,0,0))/100 else 1 end)/ICalc.PProrata) as Money),1) + Case When max(ICalc.FacProrata_Calculation)='' or Max(ICalc.FacProrata)=1 Then '' Else ' x ' + max(ICalc.FacProrata_Calculation) End 
end 
else 
Case When Max(ICalc.FacProrata*ICalc.NetRateProrata)=1 then 
case When Max(ICalc.FLPCT)=0 Then 
		case When Max(ICalc.Unit)='F' Then 
			'- ' + Case When sum(ICalc.PCTShare)<>100 Then convert(varchar(25), cast(sum(ICalc.PCTShare) as Money),1) + ' x ' else '' end +convert(varchar(25), Cast(Max(ICalc.NetRate/ICalc.NetRateProrata) as Money),1) + Case When max(ICalc.FacProrata_Calculation)='' or Max(ICalc.FacProrata*ICalc.NetRateProrata)=1 Then '' Else ' x ' + max(ICalc.FacProrata_Calculation) End 
		else 
			'- ' + convert(varchar(25), cast(sum(ICalc.PCTShare/100*Icalc.TSI*ICalc.PCTADJ/100) as Money),1) + ' x '+convert(varchar(25), cast(Max(ICalc.NetRate/ICalc.NetRateProrata) as Money),2)+'%' + Case When max(ICalc.FacProrata_Calculation)='' or Max(ICalc.FacProrata*ICalc.NetRateProrata)=1 Then '' Else ' x ' + max(ICalc.FacProrata_Calculation) End + ' x '+convert(varchar(25), Max(ICalc.Share),3)+'%' 
		end 
else 
		Case When Max(ICalc.Unit)='F' Then		 
			'- ' + Case When sum(ICalc.PCTShare)<>100 Then convert(varchar(25), cast(sum(ICalc.PCTShare) as Money),1) + ' x ' else '' end +convert(varchar(25), Cast(Max(ICalc.NetRate/ICalc.NetRateProrata) as Money),1) + Case When max(ICalc.FacProrata_Calculation)='' or Max(ICalc.FacProrata*ICalc.NetRateProrata)=1 Then '' Else ' x ' + max(ICalc.FacProrata_Calculation) End 
		else 
			'- ' + convert(varchar(25), cast(sum(ICalc.PCTShare/100*Icalc.TSI*ICalc.PCTADJ/100) as Money),1) + ' x '+convert(varchar(25), cast(Max(ICalc.NetRate/ICalc.NetRateProrata) as Money),2)+'%' + Case When max(ICalc.FacProrata_Calculation)='' or Max(ICalc.FacProrata*ICalc.NetRateProrata)=1 Then '' Else ' x ' + max(ICalc.FacProrata_Calculation) End 		 
		end 
end 
else 
case When Max(ICalc.FLPCT)=0 Then 
		Case When Max(ICalc.Unit)='F' Then 
			'- ' + Case When sum(ICalc.PCTShare)<>100 Then convert(varchar(25), cast(sum(ICalc.PCTShare) as Money),1) + ' x ' else '' end +convert(varchar(25), Max(ICalc.NetRate),1) + Case When max(ICalc.FacProrata_Calculation)='' or Max(ICalc.FacProrata)=1 Then '' Else ' x ' + max(ICalc.FacProrata_Calculation) End 
		else 
			'- ' + convert(varchar(25), cast(sum(ICalc.PCTShare/100*Icalc.TSI*ICalc.PCTADJ/100) as Money),1) + ' x '+convert(varchar(25), Max(ICalc.NetRate),3)+'%' + Case When max(ICalc.FacProrata_Calculation)='' or Max(ICalc.FacProrata)=1 Then '' Else ' x ' + max(ICalc.FacProrata_Calculation) End + ' x '+convert(varchar(25), Max(ICalc.Share),3)+'%'    		 
		end 
else 
		Case When Max(ICalc.Unit)='F' then 
			'- ' + Case When sum(ICalc.PCTShare)<>100 Then convert(varchar(25), cast(sum(ICalc.PCTShare) as Money),1) + ' x ' else '' end +convert(varchar(25), Max(ICalc.NetRate),1) + Case When max(ICalc.FacProrata_Calculation)='' or Max(ICalc.FacProrata)=1 Then '' Else ' x ' + max(ICalc.FacProrata_Calculation) End 
		else 
			'- ' + convert(varchar(25), cast(sum(ICalc.PCTShare/100*Icalc.TSI*ICalc.PCTADJ/100) as Money),1) + ' x '+convert(varchar(25), Max(ICalc.NetRate),3)+'%' + Case When max(ICalc.FacProrata_Calculation)='' or Max(ICalc.FacProrata)=1 Then '' Else ' x ' + max(ICalc.FacProrata_Calculation) End     		 
		end 
end 
end 
End 
+ 
Case When Max(ICalc.AType)='C' and Max(ICalc.EMethod)<>'A' and Max(ICalc.CPRefund)<>0 then ' x '+convert(varchar(25),Max(ICalc.CPRefund),3)+'%' else '' end 
From 
(Select ICalc.ANO, ICalc.INO, ICalc.Currency, ICalc.Code, ICalc.Sdate, ICalc.Edate, ICalc.PCTAdj, 
Max(FPart.Code) as FCode, 
Max(D.FacProrata_Calculation) as FacProrata_calculation, 
Max(D.FacProrata) as FacProrata, 
SUM(Case When PCALC.Description<>'' and PCALC.Description<>'Minimum Premium' then ICALC.GROSS*PCALC.GROSS/PCALC.OGROSS else ICALC.GROSS*D.GROSS/D.OGROSS end) AS GROSS, 
AVG(ICalc.Prorata) as PProrata, 
Max(PCalc.Ourshare/PCalc.TSI*100) as PCTShare, 
Max(ICalc.SRate) as SRate, 
Max(ICalc.TSI) as TSI, 
SUM(ICalc.Rate) as Rate, 
Max(Case When RArrDet.PCalc='P' or datediff(month,RArrDet.SDate, RArrDet.EDate)=0 or Cover.Voyage=1 Then 1 else 12/cast(datediff(month,RArrDet.SDate, RArrDet.EDate) as float) end) as NetRateProrata, 
Max(FPart.NetRate*Case When RArrDet.PCalc='P' or datediff(month,RArrDet.SDate, RArrDet.EDate)=0 or Cover.Voyage=1 Then 1 else 12/cast(datediff(month,RArrDet.SDate, RArrDet.EDate) as float) end)/Max(I.RiskNum) as NetRate, 
Max(FPart.Unit) as Unit, 
Max(RArrDet.Share) as Share, 
Max(RArrDet.FLPCT) as FLPCT, 
Max(RArrDet.CPRefund) as CPRefund, 
Max(pAcceptance.AType) as AType, 
Max(pAcceptance.EMethod) as EMethod, 
Max(ICalc.sProrata) as sProrata, 
Max(Cast(RArrDet.OnGrossAfterCommF as Integer)) as OnGrossAfterCommF 
from ICalc, PCalc, (Select I.ANO, I.INO, I.Currency, I.SDate, I.EDate, Count(Distinct I.Code) as RiskNum from ICalc I, Acceptance A Where I.Gross<>0 and I.ANO=A.PANO and A.ANO=@P_ANO Group By I.ANO, I.INO, I.Currency, I.SDate, I.EDate) I, DISPLAY_FACULTATIVE_PRORATA_CALCULATION(@P_ANO, @P_FID) D, FPart, RArrDet, RArrDet pRArrDet, Acceptance pAcceptance, Acceptance, Cover 
Where pAcceptance.ANO=@P_ANO and Acceptance.ANO=pAcceptance.PANO and Cover.CNO=Acceptance.CNO and ICalc.ANO=Acceptance.ANO and ICalc.Rate<>0 and PCalc.ANO=ICalc.ANO and PCalc.Currency=ICalc.Currency 
and I.ANO=ICalc.ANO and I.INO=ICalc.INO and I.Currency=ICalc.Currency and I.SDate=ICalc.SDate and I.EDate=ICalc.EDate 
and D.ANO=ICalc.ANO and D.Currency=ICalc.Currency and D.Code=ICalc.Code and D.SDate=ICalc.Sdate and D.EDate=ICalc.EDate and D.TOR=ICalc.TOR 
and RArrDet.Status in ('A','R') and RArrDet.FullCoverF=1 and RArrDet.ANO=D.ANO and RArrDet.FID=@P_FID and FPart.ANO=RArrDet.ANO and FPart.FID=RArrdet.FID 
and pRArrDet.ANO=pAcceptance.ANO and pRArrDet.FID=@P_FID and pRArrDet.NoRefundF=0 
Group By ICalc.ANO, ICalc.INO, ICalc.Currency, ICalc.Code, ICalc.SDate, ICalc.EDate, ICalc.PCTAdj 
) ICalc 
Group By ICalc.ANO, ICalc.Currency, ICalc.Code, ICalc.FCode, ICalc.SDate, ICalc.EDate, ICalc.SRate, ICalc.sProrata, ICalc.PCTadj 
 
UNION ALL 
 
--3 Detail 
Select ICalc.ANO, ICalc.Currency, ICalc.Code, ICalc.FCode, ICalc.SDate, ICalc.EDate, 
Gross= 
Case 
When Max(ICalc.NetRate)=0 then 
case When Max(ICalc.FLPCT)=0 Then 
sum(ICalc.PCTShare/100*ICalc.Gross*(Case When ICalc.OnGrossAfterCommF=1 Then (100-dbo.Premium_Commission(ICalc.ANO, ICalc.Code,0,0))/100 else 1 end)/Icalc.PProrata)*max(ICalc.FacProrata)*max(ICalc.Share)/100 
else 
sum(ICalc.PCTShare/100*ICalc.Gross*(Case When ICalc.OnGrossAfterCommF=1 Then (100-dbo.Premium_Commission(ICalc.ANO, ICalc.Code,0,0))/100 else 1 end)/Icalc.PProrata)*max(ICalc.FacProrata) 
end 
else 
case When Max(ICalc.FLPCT)=0 Then 
	   Case When Max(ICalc.Unit)='F' Then 
		sum(ICalc.PCTShare/100)*Max(ICalc.NetRate)*max(ICalc.FacProrata) 
	   else 
		sum(ICalc.PCTShare/100*Icalc.TSI*ICalc.PCTADJ/100)*Max(ICalc.NetRate)/100*max(ICalc.FacProrata)*max(ICalc.Share)/100 
	   end 
else 
	   Case When Max(ICalc.Unit)='F' Then 
		sum(ICalc.PCTShare/100)*Max(ICalc.NetRate)*max(ICalc.FacProrata) 
	   else 
		sum(ICalc.PCTShare/100*Icalc.TSI*ICalc.PCTADJ/100)*Max(ICalc.NetRate)/100*max(ICalc.FacProrata) 
	   end 
end 
end, 
Calculation= 
Case 
When Max(ICalc.NetRate)=0 Then 
case When Max(ICalc.FLPCT)=0 Then 
convert(varchar(25), cast(sum(ICalc.PCTShare/100*ICalc.Gross*(Case When ICalc.OnGrossAfterCommF=1 Then (100-dbo.Premium_Commission(ICalc.ANO, ICalc.Code,0,0))/100 else 1 end)/ICalc.PProrata) as Money),1) + Case When max(ICalc.FacProrata_Calculation)='' or Max(ICalc.FacProrata)=1 Then '' Else ' x ' + max(ICalc.FacProrata_Calculation) End + ' x '+convert(varchar(25), Max(ICalc.Share),3)+'%' 
else 
convert(varchar(25), cast(sum(ICalc.PCTShare/100*ICalc.Gross*(Case When ICalc.OnGrossAfterCommF=1 Then (100-dbo.Premium_Commission(ICalc.ANO, ICalc.Code,0,0))/100 else 1 end)/ICalc.PProrata) as Money),1) + Case When max(ICalc.FacProrata_Calculation)='' or Max(ICalc.FacProrata)=1 Then '' Else ' x ' + max(ICalc.FacProrata_Calculation) End 
end 
else 
Case When Max(ICalc.FacProrata*ICalc.NetRateProrata)=1 then 
case When Max(ICalc.FLPCT)=0 Then 
		case When Max(ICalc.Unit)='F' Then 
			Case When sum(ICalc.PCTShare)<>100 Then convert(varchar(25), cast(sum(ICalc.PCTShare) as Money),1) + ' x ' else '' end +convert(varchar(25), Cast(Max(ICalc.NetRate/ICalc.NetRateProrata) as Money),1) + Case When max(ICalc.FacProrata_Calculation)='' or Max(ICalc.FacProrata*ICalc.NetRateProrata)=1 Then '' Else ' x ' + max(ICalc.FacProrata_Calculation) End 
		else 
			convert(varchar(25), cast(sum(ICalc.PCTShare/100*Icalc.TSI*ICalc.PCTADJ/100) as Money),1) + ' x '+convert(varchar(25), cast(Max(ICalc.NetRate/ICalc.NetRateProrata) as Money),2)+'%' + Case When max(ICalc.FacProrata_Calculation)='' or Max(ICalc.FacProrata*ICalc.NetRateProrata)=1 Then '' Else ' x ' + max(ICalc.FacProrata_Calculation) End + ' x '+convert(varchar(25), Max(ICalc.Share),3)+'%' 
		end 
else 
		Case When Max(ICalc.Unit)='F' Then		 
			Case When sum(ICalc.PCTShare)<>100 Then convert(varchar(25), cast(sum(ICalc.PCTShare) as Money),1) + ' x ' else '' end +convert(varchar(25), Cast(Max(ICalc.NetRate/ICalc.NetRateProrata) as Money),1) + Case When max(ICalc.FacProrata_Calculation)='' or Max(ICalc.FacProrata*ICalc.NetRateProrata)=1 Then '' Else ' x ' + max(ICalc.FacProrata_Calculation) End 
		else 
			convert(varchar(25), cast(sum(ICalc.PCTShare/100*Icalc.TSI*ICalc.PCTADJ/100) as Money),1) + ' x '+convert(varchar(25), cast(Max(ICalc.NetRate/ICalc.NetRateProrata) as Money),2)+'%' + Case When max(ICalc.FacProrata_Calculation)='' or Max(ICalc.FacProrata*ICalc.NetRateProrata)=1 Then '' Else ' x ' + max(ICalc.FacProrata_Calculation) End 		 
		end 
end 
else 
case When Max(ICalc.FLPCT)=0 Then 
		Case When Max(ICalc.Unit)='F' Then 
			Case When sum(ICalc.PCTShare)<>100 Then convert(varchar(25), cast(sum(ICalc.PCTShare) as Money),1) + ' x ' else '' end +convert(varchar(25), Max(ICalc.NetRate),1) + Case When max(ICalc.FacProrata_Calculation)='' or Max(ICalc.FacProrata)=1 Then '' Else ' x ' + max(ICalc.FacProrata_Calculation) End 
		else 
			convert(varchar(25), cast(sum(ICalc.PCTShare/100*Icalc.TSI*ICalc.PCTADJ/100) as Money),1) + ' x '+convert(varchar(25), Max(ICalc.NetRate),3)+'%' + Case When max(ICalc.FacProrata_Calculation)='' or Max(ICalc.FacProrata)=1 Then '' Else ' x ' + max(ICalc.FacProrata_Calculation) End + ' x '+convert(varchar(25), Max(ICalc.Share),3)+'%'    		 
		end 
else 
		Case When Max(ICalc.Unit)='F' then 
			Case When sum(ICalc.PCTShare)<>100 Then convert(varchar(25), cast(sum(ICalc.PCTShare) as Money),1) + ' x ' else '' end +convert(varchar(25), Max(ICalc.NetRate),1) + Case When max(ICalc.FacProrata_Calculation)='' or Max(ICalc.FacProrata)=1 Then '' Else ' x ' + max(ICalc.FacProrata_Calculation) End 
		else 
			convert(varchar(25), cast(sum(ICalc.PCTShare/100*Icalc.TSI*ICalc.PCTADJ/100) as Money),1) + ' x '+convert(varchar(25), Max(ICalc.NetRate),3)+'%' + Case When max(ICalc.FacProrata_Calculation)='' or Max(ICalc.FacProrata)=1 Then '' Else ' x ' + max(ICalc.FacProrata_Calculation) End     		 
		end 
end 
end 
End 
From 
(Select ICalc.ANO, ICalc.INO, ICalc.Currency, ICalc.Code, ICalc.Sdate, ICalc.Edate, ICalc.PCTAdj, 
Max(FPart.Code) as FCode, 
Max(D.FacProrata_Calculation) as FacProrata_calculation, 
Max(D.FacProrata) as FacProrata, 
SUM(Case When PCALC.Description<>'' and PCALC.Description<>'Minimum Premium' then ICALC.GROSS*PCALC.GROSS/PCALC.OGROSS else ICALC.GROSS*D.GROSS/D.OGROSS end) AS GROSS, 
AVG(ICalc.Prorata) as PProrata, 
Max(PCalc.Ourshare/PCalc.TSI*100) as PCTShare, 
Max(ICalc.SRate) as SRate, 
Max(ICalc.TSI) as TSI, 
SUM(ICalc.Rate) as Rate, 
Max(Case When RArrDet.PCalc='P' or datediff(month,RArrDet.SDate, RArrDet.EDate)=0 or Cover.Voyage=1 Then 1 else 12/cast(datediff(month,RArrDet.SDate, RArrDet.EDate) as float) end) as NetRateProrata, 
Max(FPart.NetRate*Case When RArrDet.PCalc='P' or datediff(month,RArrDet.SDate, RArrDet.EDate)=0 or Cover.Voyage=1 Then 1 else 12/cast(datediff(month,RArrDet.SDate, RArrDet.EDate) as float) end) as NetRate, 
Max(FPart.Unit) as Unit, 
Max(RArrDet.Share) as Share, 
Max(RArrDet.FLPCT) as FLPCT, 
Max(ICalc.sProrata) as sProrata, 
Max(Cast(RArrDet.OnGrossAfterCommF as Integer)) as OnGrossAfterCommF 
from ICalc, PCalc, DISPLAY_FACULTATIVE_PRORATA_CALCULATION(@P_ANO, @P_FID) D, FPartDet FPart, RateCov, RArrDet, Acceptance, Cover 
Where Acceptance.ANO=@P_ANO and Cover.CNO=Acceptance.CNO and ICalc.ANO=Acceptance.ANO and ICalc.Rate<>0 and PCalc.ANO=ICalc.ANO and PCalc.Currency=ICalc.Currency 
and D.ANO=ICalc.ANO and D.Currency=ICalc.Currency and D.SDate=ICalc.Sdate and D.EDate=ICalc.EDate and D.TOR=ICalc.TOR 
and RArrDet.FullCoverF=0 and RArrDet.ANO=D.ANO 
and RArrDet.FID=@P_FID and FPart.ANO=RArrDet.ANO and FPart.FID=RArrdet.FID and RateCov.Code=FPart.Code and RateCov.TOR=ICalc.TOR 
and RArrDet.NoRefundF=0 
Group By ICalc.ANO, ICalc.INO, ICalc.Currency, ICalc.Code, ICalc.SDate, ICalc.EDate, ICalc.PCTAdj 
) ICalc 
Group By ICalc.ANO, ICalc.Currency, ICalc.Code, ICalc.FCode, ICalc.SDate, ICalc.EDate, ICalc.SRate, ICalc.sProrata, ICalc.PCTadj 
 
UNION ALL 
 
--4 Refund/Endorsement Detail 
Select ICalc.ANO, ICalc.Currency, ICalc.Code, ICalc.FCode, ICalc.SDate, ICalc.EDate, 
Gross=- 
Case 
When Max(ICalc.NetRate)=0 then 
case When Max(ICalc.FLPCT)=0 Then 
sum(ICalc.PCTShare/100*ICalc.Gross*(Case When ICalc.OnGrossAfterCommF=1 Then (100-dbo.Premium_Commission(ICalc.ANO, ICalc.Code,0,0))/100 else 1 end)/Icalc.PProrata)*max(ICalc.FacProrata)*max(ICalc.Share)/100 
else 
sum(ICalc.PCTShare/100*ICalc.Gross*(Case When ICalc.OnGrossAfterCommF=1 Then (100-dbo.Premium_Commission(ICalc.ANO, ICalc.Code,0,0))/100 else 1 end)/Icalc.PProrata)*max(ICalc.FacProrata) 
end 
else 
case When Max(ICalc.FLPCT)=0 Then 
	   Case When Max(ICalc.Unit)='F' Then 
		sum(ICalc.PCTShare/100)*Max(ICalc.NetRate)*max(ICalc.FacProrata) 
	   else 
		sum(ICalc.PCTShare/100*Icalc.TSI*ICalc.PCTADJ/100)*Max(ICalc.NetRate)/100*max(ICalc.FacProrata)*max(ICalc.Share)/100 
	   end 
else 
	   Case When Max(ICalc.Unit)='F' Then 
		sum(ICalc.PCTShare/100)*Max(ICalc.NetRate)*max(ICalc.FacProrata) 
	   else 
		sum(ICalc.PCTShare/100*Icalc.TSI*ICalc.PCTADJ/100)*Max(ICalc.NetRate)/100*max(ICalc.FacProrata) 
	   end 
end 
end 
* Case When Max(ICalc.AType)='C' and Max(ICalc.EMethod)<>'A' and Max(ICalc.CPRefund)<>0 then Max(ICalc.CPRefund)/100 else 1 end, 
Calculation= 
Case 
When Max(ICalc.NetRate)=0 Then 
case When Max(ICalc.FLPCT)=0 Then 
'- ' + convert(varchar(25), cast(sum(ICalc.PCTShare/100*ICalc.Gross*(Case When ICalc.OnGrossAfterCommF=1 Then (100-dbo.Premium_Commission(ICalc.ANO, ICalc.Code,0,0))/100 else 1 end)/ICalc.PProrata) as Money),1) + Case When max(ICalc.FacProrata_Calculation)='' or Max(ICalc.FacProrata)=1 Then '' Else ' x ' + max(ICalc.FacProrata_Calculation) End + ' x '+convert(varchar(25), Max(ICalc.Share),3)+'%' 
else 
'- ' + convert(varchar(25), cast(sum(ICalc.PCTShare/100*ICalc.Gross*(Case When ICalc.OnGrossAfterCommF=1 Then (100-dbo.Premium_Commission(ICalc.ANO, ICalc.Code,0,0))/100 else 1 end)/ICalc.PProrata) as Money),1) + Case When max(ICalc.FacProrata_Calculation)='' or Max(ICalc.FacProrata)=1 Then '' Else ' x ' + max(ICalc.FacProrata_Calculation) End 
end 
else 
Case When Max(ICalc.FacProrata*ICalc.NetRateProrata)=1 then 
case When Max(ICalc.FLPCT)=0 Then 
		case When Max(ICalc.Unit)='F' Then 
			'- ' + Case When sum(ICalc.PCTShare)<>100 Then convert(varchar(25), cast(sum(ICalc.PCTShare) as Money),1) + ' x ' else '' end +convert(varchar(25), Cast(Max(ICalc.NetRate/ICalc.NetRateProrata) as Money),1) + Case When max(ICalc.FacProrata_Calculation)='' or Max(ICalc.FacProrata*ICalc.NetRateProrata)=1 Then '' Else ' x ' + max(ICalc.FacProrata_Calculation) End 
		else 
			'- ' + convert(varchar(25), cast(sum(ICalc.PCTShare/100*Icalc.TSI*ICalc.PCTADJ/100) as Money),1) + ' x '+convert(varchar(25), cast(Max(ICalc.NetRate/ICalc.NetRateProrata) as Money),2)+'%' + Case When max(ICalc.FacProrata_Calculation)='' or Max(ICalc.FacProrata*ICalc.NetRateProrata)=1 Then '' Else ' x ' + max(ICalc.FacProrata_Calculation) End + ' x '+convert(varchar(25), Max(ICalc.Share),3)+'%' 
		end 
else 
		Case When Max(ICalc.Unit)='F' Then		 
			'- ' + Case When sum(ICalc.PCTShare)<>100 Then convert(varchar(25), cast(sum(ICalc.PCTShare) as Money),1) + ' x ' else '' end +convert(varchar(25), Cast(Max(ICalc.NetRate/ICalc.NetRateProrata) as Money),1) + Case When max(ICalc.FacProrata_Calculation)='' or Max(ICalc.FacProrata*ICalc.NetRateProrata)=1 Then '' Else ' x ' + max(ICalc.FacProrata_Calculation) End 
		else 
			'- ' + convert(varchar(25), cast(sum(ICalc.PCTShare/100*Icalc.TSI*ICalc.PCTADJ/100) as Money),1) + ' x '+convert(varchar(25), cast(Max(ICalc.NetRate/ICalc.NetRateProrata) as Money),2)+'%' + Case When max(ICalc.FacProrata_Calculation)='' or Max(ICalc.FacProrata*ICalc.NetRateProrata)=1 Then '' Else ' x ' + max(ICalc.FacProrata_Calculation) End 		 
		end 
end 
else 
case When Max(ICalc.FLPCT)=0 Then 
		Case When Max(ICalc.Unit)='F' Then 
			'- ' + Case When sum(ICalc.PCTShare)<>100 Then convert(varchar(25), cast(sum(ICalc.PCTShare) as Money),1) + ' x ' else '' end +convert(varchar(25), Max(ICalc.NetRate),1) + Case When max(ICalc.FacProrata_Calculation)='' or Max(ICalc.FacProrata)=1 Then '' Else ' x ' + max(ICalc.FacProrata_Calculation) End 
		else 
			'- ' + convert(varchar(25), cast(sum(ICalc.PCTShare/100*Icalc.TSI*ICalc.PCTADJ/100) as Money),1) + ' x '+convert(varchar(25), Max(ICalc.NetRate),3)+'%' + Case When max(ICalc.FacProrata_Calculation)='' or Max(ICalc.FacProrata)=1 Then '' Else ' x ' + max(ICalc.FacProrata_Calculation) End + ' x '+convert(varchar(25), Max(ICalc.Share),3)+'%'    		 
		end 
else 
		Case When Max(ICalc.Unit)='F' then 
			'- ' + Case When sum(ICalc.PCTShare)<>100 Then convert(varchar(25), cast(sum(ICalc.PCTShare) as Money),1) + ' x ' else '' end +convert(varchar(25), Max(ICalc.NetRate),1) + Case When max(ICalc.FacProrata_Calculation)='' or Max(ICalc.FacProrata)=1 Then '' Else ' x ' + max(ICalc.FacProrata_Calculation) End 
		else 
			'- ' + convert(varchar(25), cast(sum(ICalc.PCTShare/100*Icalc.TSI*ICalc.PCTADJ/100) as Money),1) + ' x '+convert(varchar(25), Max(ICalc.NetRate),3)+'%' + Case When max(ICalc.FacProrata_Calculation)='' or Max(ICalc.FacProrata)=1 Then '' Else ' x ' + max(ICalc.FacProrata_Calculation) End     		 
		end 
end 
end 
End 
+ 
Case When Max(ICalc.AType)='C' and Max(ICalc.EMethod)<>'A' and Max(ICalc.CPRefund)<>0 then ' x '+convert(varchar(25),Max(ICalc.CPRefund),3)+'%' else '' end 
From 
(Select ICalc.ANO, ICalc.INO, ICalc.Currency, ICalc.Code, ICalc.Sdate, ICalc.Edate, ICalc.PCTAdj, 
Max(FPart.Code) as FCode, 
Max(D.FacProrata_Calculation) as FacProrata_calculation, 
Max(D.FacProrata) as FacProrata, 
SUM(Case When PCALC.Description<>'' and PCALC.Description<>'Minimum Premium' then ICALC.GROSS*PCALC.GROSS/PCALC.OGROSS else ICALC.GROSS*D.GROSS/D.OGROSS end) AS GROSS, 
AVG(ICalc.Prorata) as PProrata, 
Max(PCalc.Ourshare/PCalc.TSI*100) as PCTShare, 
Max(ICalc.SRate) as SRate, 
Max(ICalc.TSI) as TSI, 
SUM(ICalc.Rate) as Rate, 
Max(Case When RArrDet.PCalc='P' or datediff(month,RArrDet.SDate, RArrDet.EDate)=0 or Cover.Voyage=1 Then 1 else 12/cast(datediff(month,RArrDet.SDate, RArrDet.EDate) as float) end) as NetRateProrata, 
Max(FPart.NetRate*Case When RArrDet.PCalc='P' or datediff(month,RArrDet.SDate, RArrDet.EDate)=0 or Cover.Voyage=1 Then 1 else 12/cast(datediff(month,RArrDet.SDate, RArrDet.EDate) as float) end) as NetRate, 
Max(FPart.Unit) as Unit, 
Max(RArrDet.Share) as Share, 
Max(RArrDet.FLPCT) as FLPCT, 
Max(RArrDet.CPRefund) as CPRefund, 
Max(pAcceptance.AType) as AType, 
Max(pAcceptance.EMethod) as EMethod, 
Max(ICalc.sProrata) as sProrata, 
Max(Cast(RArrDet.OnGrossAfterCommF as Integer)) as OnGrossAfterCommF 
from ICalc, PCalc, DISPLAY_FACULTATIVE_PRORATA_CALCULATION(@P_ANO, @P_FID) D, FPartDet FPart, RateCov, RArrDet, RArrDet pRArrDet, Acceptance pAcceptance, Acceptance, Cover 
Where pAcceptance.ANO=@P_ANO and Acceptance.ANO=pAcceptance.PANO and Cover.CNO=Acceptance.CNO and ICalc.ANO=Acceptance.ANO and ICalc.Rate<>0 and PCalc.ANO=ICalc.ANO and PCalc.Currency=ICalc.Currency 
and D.ANO=ICalc.ANO and D.Currency=ICalc.Currency and D.SDate=ICalc.Sdate and D.EDate=ICalc.EDate and D.TOR=ICalc.TOR 
and RArrDet.Status in ('A','R') and RArrDet.FullCoverF=0 and RArrDet.ANO=D.ANO 
and RArrDet.FID=@P_FID and FPart.ANO=RArrDet.ANO and FPart.FID=RArrdet.FID and RateCov.Code=FPart.Code and RateCov.TOR=ICalc.TOR 
and pRArrDet.ANO=pAcceptance.ANO and pRArrDet.FID=@P_FID and pRArrDet.NoRefundF=0 
Group By ICalc.ANO, ICalc.INO, ICalc.Currency, ICalc.Code, ICalc.SDate, ICalc.EDate, ICalc.PCTAdj 
) ICalc 
Group By ICalc.ANO, ICalc.Currency, ICalc.Code, ICalc.FCode, ICalc.SDate, ICalc.EDate, ICalc.SRate, ICalc.sProrata, ICalc.PCTadj 
 
) 
 
 

GO
CREATE FUNCTION [dbo].[DISPLAY_FACULTATIVE_BALANCE_PRORATA_CALCULATION](@P_ANO int, @P_FID Varchar(20))          
-- From Display_Prorata Calculation   
-- RCalc.Sdate Replaced with RArrDet.SDate  
-- Rcalc.EDate Replaced with RArrDet.EDate  
-- Acceptance.AType Replaced with RArrDet.AType  
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
When RArrDet.AType<>'N' then          
 case          
 when DateDiff(day, (Case When Datediff(day, RCalc.EDate, RArrDet.EDate)>=0 Then RCalc.EDate else RArrDet.EDate end), acceptance.pdate)>=0 then ''
 when DateDiff(day, acceptance.pdate, (Case When Datediff(day, RArrDet.SDate, RCalc.SDate)>=0 Then RCalc.SDate else RArrDet.SDate end))>=0 then ''          
 Else          
  case          
  when acceptance.cpct<>0 or Cover.Voyage=1 then          
   case when acceptance.cpct<>0 and acceptance.cpct<>100 then convert(varchar(25),Cast(Acceptance.CPCT as float),3)+'%' else '' end          
  Else          
    case          
     when day(acceptance.pdate)=day((Case When Datediff(day, RCalc.EDate, RArrDet.EDate)>=0 Then RCalc.EDate else RArrDet.EDate end)) and day((Case When Datediff(day, RArrDet.SDate, RCalc.SDate)>=0 Then RCalc.SDate else RArrDet.SDate end))=day((Case When Datediff(day, RCalc.EDate, RArrDet.EDate)>=0 Then RCalc.EDate else RArrDet.EDate end)) and Cover.PPeriod<>1 and datediff(month,(Case When Datediff(day, RArrDet.SDate, RCalc.SDate)>=0 Then RCalc.SDate else RArrDet.SDate end),(Case When Datediff(day, RCalc.EDate, RArrDet.EDate)>=0 Then RCalc.EDate else RArrDet.EDate end))<>0 then          
  Case When DateDiff(month, acceptance.pdate, (Case When Datediff(day, RCalc.EDate, RArrDet.EDate)>=0 Then RCalc.EDate else RArrDet.EDate end))<>datediff(month,(Case When Datediff(day, RArrDet.SDate, RCalc.SDate)>=0 Then RCalc.SDate else RArrDet.SDate end),(Case When Datediff(day, RCalc.EDate, RArrDet.EDate)>=0 Then RCalc.EDate else RArrDet.EDate end)) then          
       convert(varchar(25),DateDiff(month, acceptance.pdate, (Case When Datediff(day, RCalc.EDate, RArrDet.EDate)>=0 Then RCalc.EDate else RArrDet.EDate end)))+'/'+convert(varchar(25),datediff(month,(Case When Datediff(day, RArrDet.SDate, RCalc.SDate)>=0 Then RCalc.SDate else RArrDet.SDate end),(Case When Datediff(day, RCalc.EDate, RArrDet.EDate)>=0 Then RCalc.EDate else RArrDet.EDate end)))          
  Else          
   ''          
  End          
    Else          
  Case When DateDiff(day, acceptance.pdate, (Case When Datediff(day, RCalc.EDate, RArrDet.EDate)>=0 Then RCalc.EDate else RArrDet.EDate end))<>datediff(day,(Case When Datediff(day, RArrDet.SDate, RCalc.SDate)>=0 Then RCalc.SDate else RArrDet.SDate end),(Case When Datediff(day, RCalc.EDate, RArrDet.EDate)>=0 Then RCalc.EDate else RArrDet.EDate end)) then          
       convert(varchar(25),DateDiff(day, acceptance.pdate, (Case When Datediff(day, RCalc.EDate, RArrDet.EDate)>=0 Then RCalc.EDate else RArrDet.EDate end)))+'/'+convert(varchar(25),datediff(day,(Case When Datediff(day, RArrDet.SDate, RCalc.SDate)>=0 Then RCalc.SDate else RArrDet.SDate end),(Case When Datediff(day, RCalc.EDate, RArrDet.EDate)>=0 Then RCalc.EDate else RArrDet.EDate end)))          
  Else          
   ''          
  End          
            
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
 when DateDiff(day, acceptance.pdate, (Case When Datediff(day, RArrDet.SDate, RCalc.SDate)>=0 Then RCalc.SDate else RArrDet.SDate end))>=0 then 1          
 Else          
  case          
  when acceptance.cpct<>0 or Cover.Voyage=1 then          
   case when acceptance.cpct<>0 and acceptance.cpct<>100 then Acceptance.CPCT/100 else 1 end          
  Else          
    case          
     when day(acceptance.pdate)=day((Case When Datediff(day, RCalc.EDate, RArrDet.EDate)>=0 Then RCalc.EDate else RArrDet.EDate end)) and day((Case When Datediff(day, RArrDet.SDate, RCalc.SDate)>=0 Then RCalc.SDate else RArrDet.SDate end))=day((Case When Datediff(day, RCalc.EDate, RArrDet.EDate)>=0 Then RCalc.EDate else RArrDet.EDate end)) and Cover.PPeriod<>1 and datediff(month,(Case When Datediff(day, RArrDet.SDate, RCalc.SDate)>=0 Then RCalc.SDate else RArrDet.SDate end),(Case When Datediff(day, RCalc.EDate, RArrDet.EDate)>=0 Then RCalc.EDate else RArrDet.EDate end))<>0 then          
  Case When DateDiff(month, acceptance.pdate, (Case When Datediff(day, RCalc.EDate, RArrDet.EDate)>=0 Then RCalc.EDate else RArrDet.EDate end))<>datediff(month,(Case When Datediff(day, RArrDet.SDate, RCalc.SDate)>=0 Then RCalc.SDate else RArrDet.SDate end),(Case When Datediff(day, RCalc.EDate, RArrDet.EDate)>=0 Then RCalc.EDate else RArrDet.EDate end)) then          
       Cast(DateDiff(month, acceptance.pdate, (Case When Datediff(day, RCalc.EDate, RArrDet.EDate)>=0 Then RCalc.EDate else RArrDet.EDate end)) as Float)/Cast(datediff(month,(Case When Datediff(day, RArrDet.SDate, RCalc.SDate)>=0 Then RCalc.SDate else RArrDet.SDate end),(Case When Datediff(day, RCalc.EDate, RArrDet.EDate)>=0 Then RCalc.EDate else RArrDet.EDate end)) as Float)          
  Else          
1          
  End          
    Else          
  Case When DateDiff(day, acceptance.pdate, (Case When Datediff(day, RCalc.EDate, RArrDet.EDate)>=0 Then RCalc.EDate else RArrDet.EDate end))<>datediff(day,(Case When Datediff(day, RArrDet.SDate, RCalc.SDate)>=0 Then RCalc.SDate else RArrDet.SDate end),(Case When Datediff(day, RCalc.EDate, RArrDet.EDate)>=0 Then RCalc.EDate else RArrDet.EDate end)) then          
       Cast(DateDiff(Day, acceptance.pdate, (Case When Datediff(day, RCalc.EDate, RArrDet.EDate)>=0 Then RCalc.EDate else RArrDet.EDate end)) as Float)/Cast(datediff(Day,(Case When Datediff(day, RArrDet.SDate, RCalc.SDate)>=0 Then RCalc.SDate else RArrDet.SDate end),(Case When Datediff(day, RCalc.EDate, RArrDet.EDate)>=0 Then RCalc.EDate else RArrDet.EDate end)) as Float)          
  Else          
1          
  End          
            
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
and (RArrDet.AType='N' or (Acceptance.NoRefundF not in (2) and RCover.NoRefundF=0 and RArrDet.NoRefundF=0 and (Acceptance.NoRefundF in (0,3,4,5,6) or (DateDiff(day, acceptance.pdate, (Case When Datediff(day, RArrDet.SDate, RCalc.SDate)>=0 Then RCalc.SDate else RArrDet.SDate end))>=0))))
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
when DateDiff(day, (Case When Datediff(day, RCalc.EDate, RArrDet.EDate)>=0 Then RCalc.EDate else RArrDet.EDate end), acceptance.pdate)>=0 and acceptance.pdate between pacceptance.sdate and pacceptance.edate then ''
when DateDiff(day, acceptance.pdate, (Case When Datediff(day, RArrDet.SDate, RCalc.SDate)>=0 Then RCalc.SDate else RArrDet.SDate end))>=0 and acceptance.pdate between pacceptance.sdate and pacceptance.edate then ''          
Else          
  case          
  when acceptance.cpct<>0 or Cover.Voyage=1 then          
    case when acceptance.cpct<>0 and acceptance.cpct<>100 then convert(varchar(25),Cast(Acceptance.CPCT as float),3)+'%' else '' end        Else          
    case          
  When Acceptance.SDate<>Acceptance.PDate or Acceptance.NoRefundF=6 then          
      case          
       when day(acceptance.pdate)=day((Case When Datediff(day, RCalc.EDate, RArrDet.EDate)>=0 Then RCalc.EDate else RArrDet.EDate end)) and day((Case When Datediff(day, RArrDet.SDate, RCalc.SDate)>=0 Then RCalc.SDate else RArrDet.SDate end))=day((Case When Datediff(day, RCalc.EDate, RArrDet.EDate)>=0 Then RCalc.EDate else RArrDet.EDate end)) and Cover.PPeriod<>1 and datediff(month,(Case When Datediff(day, RArrDet.SDate, RCalc.SDate)>=0 Then RCalc.SDate else RArrDet.SDate end),(Case When Datediff(day, RCalc.EDate, RArrDet.EDate)>=0 Then RCalc.EDate else RArrDet.EDate end))<>0 then          
    Case When DateDiff(month, acceptance.pdate, (Case When Datediff(day, RCalc.EDate, RArrDet.EDate)>=0 Then RCalc.EDate else RArrDet.EDate end))<>datediff(month,(Case When Datediff(day, RArrDet.SDate, RCalc.SDate)>=0 Then RCalc.SDate else RArrDet.SDate end),(Case When Datediff(day, RCalc.EDate, RArrDet.EDate)>=0 Then RCalc.EDate else RArrDet.EDate end)) then          
         convert(varchar(25),DateDiff(month, acceptance.pdate, (Case When Datediff(day, RCalc.EDate, RArrDet.EDate)>=0 Then RCalc.EDate else RArrDet.EDate end)))+'/'+convert(varchar(25),datediff(month,(Case When Datediff(day, RArrDet.SDate, RCalc.SDate)>=0 Then RCalc.SDate else RArrDet.SDate end),(Case When Datediff(day, RCalc.EDate, RArrDet.EDate)>=0 Then RCalc.EDate else RArrDet.EDate end)))          
    Else          
     ''          
    End          
      Else          
    Case When DateDiff(day, acceptance.pdate, (Case When Datediff(day, RCalc.EDate, RArrDet.EDate)>=0 Then RCalc.EDate else RArrDet.EDate end))<>datediff(day,(Case When Datediff(day, RArrDet.SDate, RCalc.SDate)>=0 Then RCalc.SDate else RArrDet.SDate end),(Case When Datediff(day, RCalc.EDate, RArrDet.EDate)>=0 Then RCalc.EDate else RArrDet.EDate end)) then          
         convert(varchar(25),DateDiff(day, acceptance.pdate, (Case When Datediff(day, RCalc.EDate, RArrDet.EDate)>=0 Then RCalc.EDate else RArrDet.EDate end)))+'/'+convert(varchar(25),datediff(day,(Case When Datediff(day, RArrDet.SDate, RCalc.SDate)>=0 Then RCalc.SDate else RArrDet.SDate end),(Case When Datediff(day, RCalc.EDate, RArrDet.EDate)>=0 Then RCalc.EDate else RArrDet.EDate end)))          
    Else          
     ''          
    End          
              
      End          
    Else          
     -- Endorsement Period          
      ''          
    End          
  End          
end,          
Prorata=          
case          
when DateDiff(day, (Case When Datediff(day, RCalc.EDate, RArrDet.EDate)>=0 Then RCalc.EDate else RArrDet.EDate end), acceptance.pdate)>=0 and acceptance.pdate between pacceptance.sdate and pacceptance.edate then 0          
when DateDiff(day, acceptance.pdate, (Case When Datediff(day, RArrDet.SDate, RCalc.SDate)>=0 Then RCalc.SDate else RArrDet.SDate end))>=0  and acceptance.pdate between pacceptance.sdate and pacceptance.edate then 1          
Else          
  case          
  when acceptance.cpct<>0 or Cover.Voyage=1 then          
    case when acceptance.cpct<>0 and acceptance.cpct<>100 then Acceptance.CPCT/100 else 1 end          
  Else          
    case          
  When Acceptance.SDate<>Acceptance.PDate or Acceptance.NoRefundF=6 then          
      case          
       when day(acceptance.pdate)=day((Case When Datediff(day, RCalc.EDate, RArrDet.EDate)>=0 Then RCalc.EDate else RArrDet.EDate end)) and day((Case When Datediff(day, RArrDet.SDate, RCalc.SDate)>=0 Then RCalc.SDate else RArrDet.SDate end))=day((Case When Datediff(day, RCalc.EDate, RArrDet.EDate)>=0 Then RCalc.EDate else RArrDet.EDate end)) and Cover.PPeriod<>1 and datediff(month,(Case When Datediff(day, RArrDet.SDate, RCalc.SDate)>=0 Then RCalc.SDate else RArrDet.SDate end),(Case When Datediff(day, RCalc.EDate, RArrDet.EDate)>=0 Then RCalc.EDate else RArrDet.EDate end))<>0 then          
    Case When DateDiff(month, acceptance.pdate, (Case When Datediff(day, RCalc.EDate, RArrDet.EDate)>=0 Then RCalc.EDate else RArrDet.EDate end))<>datediff(month,(Case When Datediff(day, RArrDet.SDate, RCalc.SDate)>=0 Then RCalc.SDate else RArrDet.SDate end),(Case When Datediff(day, RCalc.EDate, RArrDet.EDate)>=0 Then RCalc.EDate else RArrDet.EDate end)) then          
         Cast(DateDiff(month, acceptance.pdate, (Case When Datediff(day, RCalc.EDate, RArrDet.EDate)>=0 Then RCalc.EDate else RArrDet.EDate end)) as Float)/Cast(datediff(month,(Case When Datediff(day, RArrDet.SDate, RCalc.SDate)>=0 Then RCalc.SDate else RArrDet.SDate end),(Case When Datediff(day, RCalc.EDate, RArrDet.EDate)>=0 Then RCalc.EDate else RArrDet.EDate end)) as Float)          
    Else          
 1          
    End          
      Else          
    Case When DateDiff(day, acceptance.pdate, (Case When Datediff(day, RCalc.EDate, RArrDet.EDate)>=0 Then RCalc.EDate else RArrDet.EDate end))<>datediff(day,(Case When Datediff(day, RArrDet.SDate, RCalc.SDate)>=0 Then RCalc.SDate else RArrDet.SDate end),(Case When Datediff(day, RCalc.EDate, RArrDet.EDate)>=0 Then RCalc.EDate else RArrDet.EDate end)) then          
         Cast(DateDiff(Day, acceptance.pdate, (Case When Datediff(day, RCalc.EDate, RArrDet.EDate)>=0 Then RCalc.EDate else RArrDet.EDate end)) as Float)/Cast(datediff(Day,(Case When Datediff(day, RArrDet.SDate, RCalc.SDate)>=0 Then RCalc.SDate else RArrDet.SDate end),(Case When Datediff(day, RCalc.EDate, RArrDet.EDate)>=0 Then RCalc.EDate else RArrDet.EDate end)) as Float)          
    Else          
 1          
    End          
              
      End          
    Else          
     -- Endorsement Period          
 1          
    End          
  End          
End          
            
From acceptance          
inner Join Cover on (Cover.CNO=Acceptance.CNO)          
inner join Acceptance pAcceptance on (pAcceptance.ANO=Acceptance.pANO)          
inner join PCalc on (PCalc.ANO=pAcceptance.ANO)          
inner join RCalc on (RCalc.ANO=PCalc.ANO and RCalc.Currency=PCalc.Currency)     
inner join RArrDet on (RArrDet.ANO=Acceptance.ANO and RArrDet.FID=@P_FID)         
Left Join RCover on (RCover.ANO=Acceptance.ANO and RCover.Code=RCalc.Code and RCover.SDate=RCalc.SDate)          
Where Acceptance.AType<>'A' and Not (Acceptance.AType='C' and Acceptance.EMethod='A') and pAcceptance.AType not in ('A','C')        
and Acceptance.NoRefundF Not in (2) and coalesce(RCover.NoRefundF,0)=0 and coalesce(RArrDet.NoRefundF,0)=0
and (Acceptance.NoRefundF in (0,3,4,5,6) or (DateDiff(day, acceptance.pdate, (Case When Datediff(day, RArrDet.SDate, RCalc.SDate)>=0 Then RCalc.SDate else RArrDet.SDate end))>=0  and acceptance.pdate between pacceptance.sdate and pacceptance.edate))      
and Acceptance.ANO=@P_ANO        


)





            

GO






CREATE FUNCTION [dbo].[DISPLAY_PRORATA_CALCULATION](@P_ANO int)        
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
 when DateDiff(day, acceptance.pdate, RCalc.SDate)>=0 then ''        
 Else        
  case        
  when acceptance.cpct<>0 or Cover.Voyage=1 then        
   case when acceptance.cpct<>0 and acceptance.cpct<>100 then convert(varchar(25),Cast(Acceptance.CPCT as float),3)+'%' else '' end        
  Else        
    case        
     when day(acceptance.pdate)=day(RCalc.edate) and day(RCalc.sdate)=day(RCalc.edate) and Cover.PPeriod<>1 and datediff(month,RCalc.sdate,RCalc.edate)<>0 then        
  Case When DateDiff(month, acceptance.pdate, RCalc.edate)<>datediff(month,RCalc.sdate,RCalc.edate) then        
       convert(varchar(25),DateDiff(month, acceptance.pdate, RCalc.edate))+'/'+convert(varchar(25),datediff(month,RCalc.sdate,RCalc.edate))        
  Else        
   ''        
  End        
    Else        
  Case When DateDiff(day, acceptance.pdate, RCalc.edate)<>datediff(day,RCalc.sdate,RCalc.edate) then        
       convert(varchar(25),DateDiff(day, acceptance.pdate, RCalc.edate))+'/'+convert(varchar(25),datediff(day,RCalc.sdate,RCalc.edate))        
  Else        
   ''        
  End        
          
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
 when DateDiff(day, acceptance.pdate, RCalc.SDate)>=0 then 1        
 Else        
  case        
  when acceptance.cpct<>0 or Cover.Voyage=1 then        
   case when acceptance.cpct<>0 and acceptance.cpct<>100 then Acceptance.CPCT/100 else 1 end        
  Else        
    case        
     when day(acceptance.pdate)=day(RCalc.edate) and day(RCalc.sdate)=day(RCalc.edate) and Cover.PPeriod<>1 and datediff(month,RCalc.sdate,RCalc.edate)<>0 then        
  Case When DateDiff(month, acceptance.pdate, RCalc.edate)<>datediff(month,RCalc.sdate,RCalc.edate) then        
       Cast(DateDiff(month, acceptance.pdate, RCalc.edate) as Float)/Cast(datediff(month,RCalc.sdate,RCalc.edate) as Float)        
  Else        
1        
  End        
    Else        
  Case When DateDiff(day, acceptance.pdate, RCalc.edate)<>datediff(day,RCalc.sdate,RCalc.edate) then        
       Cast(DateDiff(Day, acceptance.pdate, RCalc.edate) as Float)/Cast(datediff(Day,RCalc.sdate,RCalc.edate) as Float)        
  Else        
1        
  End        
          
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
and (Acceptance.AType='N' or (Acceptance.NoRefundF not in (2,4) and RCover.NoRefundF=0 and (Acceptance.NoRefundF in (0,3,5,6) or (DateDiff(day, acceptance.pdate, RCalc.SDate) >= 0))))
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
when DateDiff(day, acceptance.pdate, rcalc.SDate)>=0 and acceptance.pdate between pacceptance.sdate and pacceptance.edate then ''        
Else        
  case        
  when acceptance.cpct<>0 or Cover.Voyage=1 then        
    case when acceptance.cpct<>0 and acceptance.cpct<>100 then convert(varchar(25),Cast(Acceptance.CPCT as float),3)+'%' else '' end        Else        
    case        
  When Acceptance.SDate<>Acceptance.PDate or Acceptance.NoRefundF=6 then        
      case        
       when day(acceptance.pdate)=day(RCalc.edate) and day(RCalc.sdate)=day(RCalc.edate) and Cover.PPeriod<>1 and datediff(month,RCalc.sdate,RCalc.edate)<>0 then        
    Case When DateDiff(month, acceptance.pdate, RCalc.edate)<>datediff(month,RCalc.sdate,RCalc.edate) then        
         convert(varchar(25),DateDiff(month, acceptance.pdate, RCalc.edate))+'/'+convert(varchar(25),datediff(month,RCalc.sdate,RCalc.edate))        
    Else        
     ''        
    End        
      Else        
    Case When DateDiff(day, acceptance.pdate, RCalc.edate)<>datediff(day,RCalc.sdate,RCalc.edate) then        
         convert(varchar(25),DateDiff(day, acceptance.pdate, RCalc.edate))+'/'+convert(varchar(25),datediff(day,RCalc.sdate,RCalc.edate))        
    Else        
     ''        
    End        
            
      End        
    Else        
     -- Endorsement Period        
      ''        
    End        
  End        
end,        
Prorata=        
case        
when DateDiff(day, rcalc.Edate, acceptance.pdate)>=0 and acceptance.pdate between pacceptance.sdate and pacceptance.edate then 0        
when DateDiff(day, acceptance.pdate, rcalc.SDate)>=0  and acceptance.pdate between pacceptance.sdate and pacceptance.edate then 1        
Else        
  case        
  when acceptance.cpct<>0 or Cover.Voyage=1 then        
    case when acceptance.cpct<>0 and acceptance.cpct<>100 then Acceptance.CPCT/100 else 1 end        
  Else        
    case        
  When Acceptance.SDate<>Acceptance.PDate or Acceptance.NoRefundF=6 then        
      case        
       when day(acceptance.pdate)=day(RCalc.edate) and day(RCalc.sdate)=day(RCalc.edate) and Cover.PPeriod<>1 and datediff(month,RCalc.sdate,RCalc.edate)<>0 then        
    Case When DateDiff(month, acceptance.pdate, RCalc.edate)<>datediff(month,RCalc.sdate,RCalc.edate) then        
         Cast(DateDiff(month, acceptance.pdate, RCalc.edate) as Float)/Cast(datediff(month,RCalc.sdate,RCalc.edate) as Float)        
    Else        
 1        
    End        
      Else        
    Case When DateDiff(day, acceptance.pdate, RCalc.edate)<>datediff(day,RCalc.sdate,RCalc.edate) then        
         Cast(DateDiff(Day, acceptance.pdate, RCalc.edate) as Float)/Cast(datediff(Day,RCalc.sdate,RCalc.edate) as Float)        
    Else        
 1        
    End        
            
      End        
    Else        
     -- Endorsement Period        
 1        
    End        
  End        
End        
          
From acceptance        
inner Join Cover on (Cover.CNO=Acceptance.CNO)        
inner join Acceptance pAcceptance on (pAcceptance.ANO=Acceptance.pANO)        
inner join PCalc on (PCalc.ANO=pAcceptance.ANO)        
inner join RCalc on (RCalc.ANO=PCalc.ANO and RCalc.Currency=PCalc.Currency)        
Left Join RCover on (RCover.ANO=Acceptance.ANO and RCover.Code=RCalc.Code and RCover.SDate=RCalc.SDate)        
Where Acceptance.AType<>'A' and Not (Acceptance.AType='C' and Acceptance.EMethod='A') and pAcceptance.AType not in ('A','C')        
and Acceptance.NoRefundF Not in (2,4) and coalesce(RCover.NoRefundF,0)=0
and (Acceptance.NoRefundF in (0,3,5,6) or (DateDiff(day, acceptance.pdate, rcalc.SDate) >= 0 and acceptance.pdate between pacceptance.sdate and pacceptance.edate))      
and Acceptance.ANO=@P_ANO        
)        
       

GO






 
CREATE FUNCTION [dbo].[DISPLAY_GROSS_CALCULATION](@P_ANO int) 
RETURNS TABLE  AS 
RETURN ( 
Select ICalc.ANO, ICalc.Currency, ICalc.Code, ICalc.SDate, ICalc.EDate, sum(ICalc.Gross) as Gross, 
Calculation= 
Case When ICalc.SRate<>'Flat' then convert(varchar(25),Cast(sum(ICalc.TSI) as Money),1) + ' x ' + (case When RCover.Unit='C' then convert(varchar(25), Cast(sum(ICalc.Rate*100)/Count(*) as Numeric(38,6)),2)+'%' else convert(varchar(25), Cast(sum(ICalc.Rate*1000)/Count(*) as Numeric(38,6)),3)+'‰' end) else convert(varchar(25), Cast(sum(ICalc.Rate) as Money),1) end + 
Case When ICalc.sProrata<>'' then ' x '+ICalc.sProrata else '' end + 
Case When ICalc.SRate<>'Flat' and ICalc.PCTAdj<>100 then ' x '+convert(varchar(25),ICalc.PCTadj,3)+'%' else '' end 
From 
(Select ICalc.ANO, ICalc.INO, ICalc.Currency, ICalc.Code, ICalc.SDate, ICalc.EDate, Case When ICalc.SRate='Flat' then 100 else ICalc.PCTAdj end as PCTAdj, sum(ICalc.Gross) as Gross, Max(ICalc.SRate) as SRate, Max(ICalc.TSI) as TSI, sum(ICalc.Rate) as Rate, Max(ICalc.sProrata) as sProrata 
from ICalc, Acceptance Where ICalc.ANO=Acceptance.ANO and Acceptance.ANO=@P_ANO and ICalc.Rate<>0 
Group By ICalc.ANO, ICalc.INO, ICalc.Currency, ICalc.Code, ICalc.SDate, ICalc.EDate, Case When ICalc.SRate='Flat' then 100 else ICalc.PCTAdj end 
) ICalc, RCover 
Where RCOVER.ANO = ICALC.ANO And RCOVER.Code = ICALC.Code And RCOVER.SDate = ICALC.SDate And RCOVER.EDate = ICALC.EDate 
Group By ICalc.ANO, ICalc.Currency, ICalc.Code, ICalc.SDate, ICalc.EDate, ICalc.SRate, RCover.Unit, ICalc.sProrata, ICalc.PCTadj 
 
Union All 
 
Select ICalc.ANO, ICalc.Currency, ICalc.Code, ICalc.SDate, ICalc.EDate, -sum(ICalc.Gross)*Case When Max(ICalc.AType)='C' and Max(ICalc.EMethod)<>'A' and Max(RCover.CPRefund)<>0 then Max(RCover.CPRefund)/100 else 1 end as Gross, Calculation='- '+ 
Case When ICalc.SRate<>'Flat' then convert(varchar(25),Cast(sum(ICalc.TSI) as Money),1) + ' x ' + (case When RCover.Unit='C' then convert(varchar(25), Cast(sum(ICalc.Rate*100)/Count(*) as Numeric(38,6)),2)+'%' else convert(varchar(25), Cast(sum(ICalc.Rate*1000)/Count(*) as Numeric(38,6)),3)+'‰' end) else convert(varchar(25), Cast(sum(ICalc.Rate) as Money),1) end + 
Case When ICalc.sProrata<>'' then ' x '+ICalc.sProrata else '' end + 
Case When ICalc.SRate<>'Flat' and ICalc.PCTAdj<>100 then ' x '+convert(varchar(25),ICalc.PCTadj,3)+'%' else '' end + 
Case When Max(ICalc.AType)='C' and Max(ICalc.EMethod)<>'A' and Max(RCover.CPRefund)<>0 then ' x '+convert(varchar(25),Max(RCover.CPRefund),3)+'%' else '' end 
From 
(Select Acceptance.AType, Acceptance.EMethod, ICalc.ANO, ICalc.INO, ICalc.Currency, ICalc.Code, ICalc.SDate, ICalc.EDate, Case When ICalc.SRate='Flat' then 100 else ICalc.PCTAdj end as PCTAdj, sum(ICalc.Gross) as Gross, Max(ICalc.SRate) as SRate, Max(ICalc.TSI) as TSI, sum(ICalc.Rate) as Rate, Max(ICalc.sProrata) as sProrata 
from ICalc, Acceptance Where ICalc.ANO=Acceptance.PANO and Acceptance.ANO=@P_ANO and ICalc.Rate<>0 
Group By Acceptance.AType, Acceptance.EMethod, ICalc.ANO, ICalc.INO, ICalc.Currency, ICalc.Code, ICalc.SDate, ICalc.EDate, Case When ICalc.SRate='Flat' then 100 else ICalc.PCTAdj end 
) ICalc, RCover 
Where RCOVER.ANO = ICALC.ANO And RCOVER.Code = ICALC.Code And RCOVER.SDate = ICALC.SDate And RCOVER.EDate = ICALC.EDate 
Group By ICalc.ANO, ICalc.Currency, ICalc.Code, ICalc.SDate, ICalc.EDate, ICalc.SRate, RCover.Unit, ICalc.sProrata, ICalc.PCTadj 
 
Union All 
 
Select ICalc.ANO, ICalc.Currency, ICalc.Code, ICalc.SDate, ICalc.EDate, sum(ICalc.Gross) as Gross, 
Calculation= 
Case When ICalc.SRate<>'Flat' then convert(varchar(25),Cast(sum(ICalc.TSI) as Money),1) + ' x ' + (case When RCover.Unit='C' then convert(varchar(25), Cast(sum(ICalc.Rate*100)/Count(*) as Numeric(38,6)),2)+'%' else convert(varchar(25), Cast(sum(ICalc.Rate*1000)/Count(*) as Numeric(38,6)),3)+'‰' end) else convert(varchar(25), Cast(sum(ICalc.Rate) as Money),1) end + 
Case When ICalc.sProrata<>'' then ' x '+ICalc.sProrata else '' end + 
Case When ICalc.SRate<>'Flat' and ICalc.PCTAdj<>100 then ' x '+convert(varchar(25),ICalc.PCTadj,3)+'%' else '' end 
From 
(Select ICalc.ANO, ICalc.INO, ICalc.Currency, ICalc.Code, ICalc.SDate, ICalc.EDate, Case When ICalc.SRate='Flat' then 100 else ICalc.PCTAdj end as PCTAdj, sum(ICalc.Reinstatement) as Gross, Max(ICalc.SRate) as SRate, Max(ICalc.Indemnity) as TSI, sum(ICalc.Rate) as Rate, Max(ICalc.sProrata) as sProrata 
from ICalc, Acceptance Where Acceptance.EMethod='R' and ICalc.ANO=Acceptance.ANO and Acceptance.ANO=@P_ANO and ICalc.Rate<>0 
Group By ICalc.ANO, ICalc.INO, ICalc.Currency, ICalc.Code, ICalc.SDate, ICalc.EDate, Case When ICalc.SRate='Flat' then 100 else ICalc.PCTAdj end 
) ICalc, RCover 
Where RCOVER.ANO = ICALC.ANO And RCOVER.Code = ICALC.Code And RCOVER.SDate = ICALC.SDate And RCOVER.EDate = ICALC.EDate 
Group By ICalc.ANO, ICalc.Currency, ICalc.Code, ICalc.SDate, ICalc.EDate, ICalc.SRate, RCover.Unit, ICalc.sProrata, ICalc.PCTadj 
) 
 
 
 
 

GO











CREATE FUNCTION [dbo].[DISPLAY_FACULTATIVE_CALCULATION](@P_ANO int, @P_FID varchar(20)) 
RETURNS TABLE  AS 
RETURN ( 
Select A.ANO, CASE WHEN D1.FCODE<>'' THEN D1.FCODE ELSE D1.CODE END Code, D1.SDate, D1.EDate, D1.Gross, D2.Prorata, D1.Currency,  D1.Calculation as Premium_Calculation, D2.Prorata_Calculation, D1.Calculation + Case When D2.Prorata=0 or D2.Prorata_Calculation='' Then '' else ' x '+D2.Prorata_Calculation end 
+ Case When A.Qty>1 Then ' x '+ Convert(varchar(25), Cast(A.Qty as Int),1) Else '' end 
+ ' = ' + Convert(varchar(50), Cast(D1.Gross*(Case When D2.Prorata<>0 or D2.Prorata_Calculation<>'' Then D2.Prorata else 1 end)*Case When A.Qty>1 Then A.Qty Else 1 End as Money),1) as Calculation 
from Display_Gross_Facultative_Calculation(@P_ANO, @P_FID) D1, DISPLAY_FACULTATIVE_BALANCE_PRORATA_CALCULATION(@P_ANO, @P_FID) D2, Acceptance A 
Where a.ANO = D1.ANO And D1.ANO = D2.ANO And D1.Currency = D2.Currency And D1.Code = D2.Code And D1.SDate = D2.SDate And D1.EDate = D2.EDate and D2.Prorata<>0 
) 
 
 

GO

-- Update Script - 18 May 2016 (2) - Rev 1
IF EXISTS ( SELECT * FROM   sysobjects WHERE  id = object_id(N'[dbo].[QInConsistent_LossItem]') and OBJECTPROPERTY(id, N'IsProcedure') = 1 ) BEGIN    DROP PROCEDURE [dbo].[QInConsistent_LossItem] END 
go
CREATE  procedure QInConsistent_LossItem(@P_CNO integer)   
as   
Declare @P_LossDate as smalldatetime      
Declare @P_LossTime as varchar(5)      
Declare @P_EventNo as int      
Declare @P_COL as varchar(10)      
Declare @P_ANO as int
Declare @P_Value as float      
      
Select @P_LossDate=LossDate, @P_LossTime=LossTime, @P_EventNo=EventNo, @P_Col=COL, @P_ANO=ANO 
from Claim Where CNO=@P_CNO      
                     
Select TOP 1 CLLOSS.INO,CLLOSS.NOC
from CLLOSS Where CNO=@P_CNO And not Exists
(
Select ICOVER.INO,NOC.NOC
from ICOVER, ICOVERNOC, NOC, ACCEPTANCE  
Where ICOVERNOC.INO=ICOVER.INO AND NOC.NOC=ICOVERNOC.NOC AND NOC.TOI=ICOVER.TOI 
AND ACCEPTANCE.ANO=ICOVER.ANO  
AND ((ICOVERNOC.SDATE<=@P_LOSSDATE AND ACCEPTANCE.ExclusiveF=1) or ((ICOVERNOC.SDATE<@P_LOSSDATE or (ICOVERNOC.SDATE=@P_LOSSDATE AND '12:00'<=@P_LOSSTIME)) AND ACCEPTANCE.ExclusiveF=0))                     
AND ((dbo.fn_Get_ExtPeriodDate(ACCEPTANCE.ExtPeriod, ACCEPTANCE.ExtPeriodInDaysF, ICOVERNOC.EDATE)>@P_LOSSDATE AND ACCEPTANCE.ExclusiveF=1) or ((dbo.fn_Get_ExtPeriodDate(ACCEPTANCE.ExtPeriod, ACCEPTANCE.ExtPeriodInDaysF, ICOVERNOC.EDATE)>@P_LOSSDATE or (dbo.fn_Get_ExtPeriodDate(ACCEPTANCE.ExtPeriod, ACCEPTANCE.ExtPeriodInDaysF, ICOVERNOC.EDATE)=@P_LOSSDATE AND '12:00'>@P_LOSSTIME)) AND ACCEPTANCE.ExclusiveF=0))                              
AND ACCEPTANCE.ANO=@P_ANO
AND CLLOSS.INO=ICOVER.INO AND CLLOSS.NOC=NOC.NOC
AND (
(ICOVERNOC.PCT*ICOVER.AMOUNT/100=0 or ICOVERNOC.AMOUNT=CLLOSS.DECLARED) OR
(ICOVERNOC.AMOUNT=0 or ICOVERNOC.PCT*ICOVER.AMOUNT/100=CLLOSS.DECLARED) OR
(ICOVERNOC.PCT*ICOVER.AMOUNT/100>ICOVERNOC.AMOUNT or ICOVERNOC.AMOUNT=CLLOSS.DECLARED) OR
(ICOVERNOC.PCT*ICOVER.AMOUNT/100<ICOVERNOC.AMOUNT or ICOVERNOC.PCT*ICOVER.AMOUNT/100=CLLOSS.DECLARED)
)

UNION ALL


Select ICOVER.INO, NOC.NOC
From RCOVER, Col, RATECOV, PCLASS, ICOVER, NOC, ACCEPTANCE, COLNOCCLASS        
Where RCOVER.ANO=ICOVER.ANO AND ACCEPTANCE.ANO=RCOVER.ANO AND COL.COL=@P_COL      
AND ((RCOVER.SDATE<=@P_LOSSDATE AND ACCEPTANCE.ExclusiveF=1) or ((RCOVER.SDATE<@P_LOSSDATE or (RCOVER.SDATE=@P_LOSSDATE AND '12:00'<=@P_LOSSTIME)) AND ACCEPTANCE.ExclusiveF=0))                     
AND ((dbo.fn_Get_ExtPeriodDate(ACCEPTANCE.ExtPeriod, ACCEPTANCE.ExtPeriodInDaysF, RCOVER.EDATE)>@P_LOSSDATE AND ACCEPTANCE.ExclusiveF=1) or ((dbo.fn_Get_ExtPeriodDate(ACCEPTANCE.ExtPeriod, ACCEPTANCE.ExtPeriodInDaysF, RCOVER.EDATE)>@P_LOSSDATE or (dbo.fn_Get_ExtPeriodDate(ACCEPTANCE.ExtPeriod, ACCEPTANCE.ExtPeriodInDaysF, RCOVER.EDATE)=@P_LOSSDATE AND '12:00'>@P_LOSSTIME)) AND ACCEPTANCE.ExclusiveF=0))                    
AND RATECOV.CODE=RCOVER.CODE AND RATECOV.TOR=COL.TOR AND PCLASS.TOR=COL.TOR AND PCLASS.TOI=ICOVER.TOI                        
AND NOC.TOI=ICOVER.TOI AND COLNOCCLASS.NOC=NOC.NOC AND COLNOCCLASS.COL=@P_COL      
AND (PCLASS.CTLF=0 OR NOC.CTLF=PCLASS.CTLF)       
AND ACCEPTANCE.ANO=@P_ANO
AND CLLOSS.INO=ICOVER.INO AND CLLOSS.NOC=NOC.NOC
AND
CASE
 WHEN @P_EVENTNO=-1 THEN                        
        CASE                        
        WHEN RCOVER.PCTLOSS=0 OR ICOVER.NOTDECRF=1 OR ICOVER.NOTFLF=1 THEN CASE WHEN @P_VALUE<>0 THEN @P_VALUE ELSE ICOVER.AMOUNT END      
        ELSE CASE WHEN @P_VALUE<>0 THEN @P_VALUE ELSE ICOVER.AMOUNT END*RCOVER.PCTLOSS/100 END                        
 Else                        
        CASE                        
        WHEN RCOVER.PCTLOSS=0 OR ICOVER.NOTDECRF=1 OR ICOVER.NOTFLF=1 THEN ICOVER.AMOUNT_AOE                
        ELSE ICOVER.AMOUNT_AOE*RCOVER.PCTLOSS/100 END                        
 END=CLLOSS.DECLARED 
 
)
go

update SysTab Set versionNo='20160617 V1.4.2',versionUpdate=getdate()
go