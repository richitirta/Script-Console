DROP FUNCTION DISPLAY_FACULTATIVE_PRORATA_CALCULATION
GO
CREATE FUNCTION DISPLAY_FACULTATIVE_PRORATA_CALCULATION(@P_ANO int, @P_FID varchar(20))            
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
When RArrDet.PCalc='P' and RArrDet.CPCT<>0 then convert(varchar(25),Cast(RArrDet.CPCT as float),0)+'%'     
When Cast(Datediff(month, RCalc.RSDate, RCalc.REDate) as Float)<>0 then    
 Case    
 When RArrDet.PCalc='F' then     
         convert(varchar(25),Cast(Datediff(month, RArrDet.FSDate, RArrDet.FEDate) as Float))+'/12'    
 else    
  Case    
  When RArrDet.NetRate=0 then    
   Case     
   When RArrDet.PCalc='P' then    
    Case    
    When day(RArrDet.FSDate)=day(RArrDet.FEDate) and day(RCalc.RSDate)=day(RCalc.REDate) and Cover.PPeriod<>1 then    
            convert(varchar(25),Cast(Datediff(month, RArrDet.FSDate, RArrDet.FEDate) as Float))+'/12'    
    else    
            convert(varchar(25),Cast(DateDiff(day, RArrDet.FSDate, RArrDet.FEDate) as Float))+'/'+convert(varchar(25),Cover.Prorata)    
    end    
   else    
    Case    
    When day(RArrDet.FSDate)=day(RArrDet.FEDate) and day(RCalc.RSDate)=day(RCalc.REDate) and Cover.PPeriod<>1 then    
            convert(varchar(25),Cast(Datediff(month, RArrDet.FSDate, RArrDet.FEDate) as Float))+'/'+convert(varchar(25),Cast(Datediff(month, RCalc.RSDate, RCalc.REDate) as Float))    
    else    
            convert(varchar(25),Cast(DateDiff(day, RArrDet.FSDate, RArrDet.FEDate) as Float))+'/'+convert(varchar(25),Cast(Datediff(Day, RCalc.RSDate, RCalc.REDate) as Float))    
    end    
   end    
  else    
   Case    
   When day(RArrDet.FSDate)=day(RArrDet.FEDate) and day(RCalc.RSDate)=day(RCalc.REDate) and Cover.PPeriod<>1 then    
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
end
,
FacProrata=    
Case    
When Cover.Voyage=1 then ICalc.Prorata    
When RArrDet.PCalc='F' and RArrDet.NetRate=0 then ICalc.Prorata    
When RArrDet.PCalc='P' and RArrDet.CPCT<>0 then RArrDet.CPCT/100    
When Cast(Datediff(month, RCalc.RSDate, RCalc.REDate) as Float)<>0 then    
 Case    
 When RArrDet.PCalc='F' then     
  Cast(Datediff(month, RArrDet.FSDate, RArrDet.FEDate) as Float) / 12    
 else    
  Case    
  When RArrDet.NetRate=0 then    
   Case     
   When RArrDet.PCalc='P' then    
    Case    
    When day(RArrDet.FSDate)=day(RArrDet.FEDate) and day(RCalc.RSDate)=day(RCalc.REDate) and Cover.PPeriod<>1 then    
     Cast(Datediff(month, RArrDet.FSDate, RArrDet.FEDate) as Float)/12    
    else    
     Cast(DateDiff(day, RArrDet.FSDate, RArrDet.FEDate) as Float) / Cover.Prorata    
    end    
   else    
    Case    
    When day(RArrDet.FSDate)=day(RArrDet.FEDate) and day(RCalc.RSDate)=day(RCalc.REDate) and Cover.PPeriod<>1 then    
     Cast(Datediff(month, RArrDet.FSDate, RArrDet.FEDate) as Float)/Cast(Datediff(month, RCalc.RSDate, RCalc.REDate) as Float)    
    else    
     Cast(DateDiff(day, RArrDet.FSDate, RArrDet.FEDate) as Float) /Cast(Datediff(Day, RCalc.RSDate, RCalc.REDate) as Float)    
    end    
   end    
  else    
   Case    
   When day(RArrDet.FSDate)=day(RArrDet.FEDate) and day(RCalc.RSDate)=day(RCalc.REDate) and Cover.PPeriod<>1 then    
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
end,
Case When RArrDet.Prorata<>0 then convert(varchar(25),RArrDet.Prorata) else '' end as sProrata,
Case When RArrDet.Prorata<>0 then RArrDet.Prorata else 1 end as Prorata
From acceptance            
inner Join Cover on (Cover.CNO=Acceptance.CNO)             
Cross Apply (
	Select RCalc.ANO, RCalc.Code, RCalc.Currency, RCalc.SDate, RCalc.EDate, RCalc.TOR, RCalc.Gross, RCalc.OGross,
	RCalc.SDate as RSDate,
	Case When Acceptance.EXCLUSIVEF=0 and Acceptance.STime<Acceptance.ETime and RCalc.EDate=Acceptance.EDate Then dateadd(day,1,RCalc.EDate) else RCalc.EDate end as REDate
	from RCalc Where RCalc.ANO=Acceptance.ANO
) RCalc
Cross Apply (
	Select ICALC.Prorata, ICALC.SProrata 
	from ICalc 
	Where ICalc.ANO=RCalc.ANO and ICalc.Currency=RCalc.Currency and ICalc.Code=RCalc.Code and ICalc.SDate=RCalc.SDate and ICalc.EDate=RCalc.EDate and ICalc.TOR=RCalc.TOR
) ICalc
Cross Apply (
	Select RArrDet.ANO, RCalc.Currency, Rcalc.Code, RArrDet.PCalc, RArrDet.CPCT, RArrDet.Prorata, FPart.NetRate, 
	Case When datediff(day, RCalc.SDate, RArrDet.SDate)>=0 then RArrDet.SDate else RCalc.SDate end as FSDate, 
	Case When Acceptance.EXCLUSIVEF=0 and Acceptance.STime<Acceptance.ETime and (Case When datediff(day, RArrDet.EDate, RCalc.EDate)>=0 then RArrDet.EDate else RCalc.EDate end)=RArrDet.EDate Then dateadd(day,1,RArrDet.EDate) else (Case When datediff(day, RArrDet.EDate, RCalc.EDate)>=0 then RArrDet.EDate else RCalc.EDate end) end as FEDate
	from RArrDet, FPart
	Where RArrDet.ANO=RCalc.ANO and RArrDet.FID=@P_FID and FPart.ANO=RArrDet.ANO and FPart.FID=RArrDet.FID and RArrDet.FullCoverF=1
) RArrDet 
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
When RArrDet.PCalc='P' and RArrDet.CPCT<>0 then convert(varchar(25),Cast(RArrDet.CPCT as float),0)+'%'     
When Cast(Datediff(month, RCalc.RSDate, RCalc.REDate) as Float)<>0 then    
 Case    
 When RArrDet.PCalc='F' then     
         convert(varchar(25),Cast(Datediff(month, RArrDet.FSDate, RArrDet.FEDate) as Float))+'/12'    
 else    
  Case    
  When RArrDet.NetRate=0 then    
   Case     
   When RArrDet.PCalc='P' then    
    Case    
    When day(RArrDet.FSDate)=day(RArrDet.FEDate) and day(RCalc.RSDate)=day(RCalc.REDate) and Cover.PPeriod<>1 then    
            convert(varchar(25),Cast(Datediff(month, RArrDet.FSDate, RArrDet.FEDate) as Float))+'/12'    
    else    
            convert(varchar(25),Cast(DateDiff(day, RArrDet.FSDate, RArrDet.FEDate) as Float))+'/'+convert(varchar(25),Cover.Prorata)    
    end    
   else    
    Case    
    When day(RArrDet.FSDate)=day(RArrDet.FEDate) and day(RCalc.RSDate)=day(RCalc.REDate) and Cover.PPeriod<>1 then    
            convert(varchar(25),Cast(Datediff(month, RArrDet.FSDate, RArrDet.FEDate) as Float))+'/'+convert(varchar(25),Cast(Datediff(month, RCalc.RSDate, RCalc.REDate) as Float))    
    else    
            convert(varchar(25),Cast(DateDiff(day, RArrDet.FSDate, RArrDet.FEDate) as Float))+'/'+convert(varchar(25),Cast(Datediff(Day, RCalc.RSDate, RCalc.REDate) as Float))    
    end    
   end    
  else    
   Case    
   When day(RArrDet.FSDate)=day(RArrDet.FEDate) and day(RCalc.RSDate)=day(RCalc.REDate) and Cover.PPeriod<>1 then    
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
end
,
FacProrata=    
Case    
When Cover.Voyage=1 then ICalc.Prorata    
When RArrDet.PCalc='F' and RArrDet.NetRate=0 then ICalc.Prorata    
When RArrDet.PCalc='P' and RArrDet.CPCT<>0 then RArrDet.CPCT/100    
When Cast(Datediff(month, RCalc.RSDate, RCalc.REDate) as Float)<>0 then    
 Case    
 When RArrDet.PCalc='F' then     
  Cast(Datediff(month, RArrDet.FSDate, RArrDet.FEDate) as Float) / 12    
 else    
  Case    
  When RArrDet.NetRate=0 then    
   Case     
   When RArrDet.PCalc='P' then    
    Case    
    When day(RArrDet.FSDate)=day(RArrDet.FEDate) and day(RCalc.RSDate)=day(RCalc.REDate) and Cover.PPeriod<>1 then    
     Cast(Datediff(month, RArrDet.FSDate, RArrDet.FEDate) as Float)/12    
    else    
     Cast(DateDiff(day, RArrDet.FSDate, RArrDet.FEDate) as Float) / Cover.Prorata    
    end    
   else    
    Case    
    When day(RArrDet.FSDate)=day(RArrDet.FEDate) and day(RCalc.RSDate)=day(RCalc.REDate) and Cover.PPeriod<>1 then    
     Cast(Datediff(month, RArrDet.FSDate, RArrDet.FEDate) as Float)/Cast(Datediff(month, RCalc.RSDate, RCalc.REDate) as Float)    
    else    
     Cast(DateDiff(day, RArrDet.FSDate, RArrDet.FEDate) as Float) /Cast(Datediff(Day, RCalc.RSDate, RCalc.REDate) as Float)    
    end    
   end    
  else    
   Case    
   When day(RArrDet.FSDate)=day(RArrDet.FEDate) and day(RCalc.RSDate)=day(RCalc.REDate) and Cover.PPeriod<>1 then    
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
end,
Case When RArrDet.Prorata<>0 then convert(varchar(25),RArrDet.Prorata) else '' end as sProrata,
Case When RArrDet.Prorata<>0 then RArrDet.Prorata else 1 end as Prorata
From acceptance pAcceptance           
inner join Acceptance on (Acceptance.ANO=pAcceptance.pANO)    
inner Join Cover on (Cover.CNO=Acceptance.CNO)             
Cross Apply (
	Select RCalc.ANO, RCalc.Code, RCalc.Currency, RCalc.SDate, RCalc.EDate, RCalc.TOR, RCalc.Gross, RCalc.OGross,
	RCalc.SDate as RSDate,
	Case When Acceptance.EXCLUSIVEF=0 and Acceptance.STime<Acceptance.ETime and RCalc.EDate=Acceptance.EDate Then dateadd(day,1,RCalc.EDate) else RCalc.EDate end as REDate
	from RCalc Where RCalc.ANO=Acceptance.ANO
) RCalc
Cross Apply (
	Select ICALC.Prorata, ICALC.SProrata 
	from ICalc 
	Where ICalc.ANO=RCalc.ANO and ICalc.Currency=RCalc.Currency and ICalc.Code=RCalc.Code and ICalc.SDate=RCalc.SDate and ICalc.EDate=RCalc.EDate and ICalc.TOR=RCalc.TOR
) ICalc
Cross Apply (
	Select RArrDet.ANO, RCalc.Currency, Rcalc.Code, RArrDet.PCalc, RArrDet.CPCT, RArrDet.Prorata, FPart.NetRate, 
	Case When datediff(day, RCalc.SDate, RArrDet.SDate)>=0 then RArrDet.SDate else RCalc.SDate end as FSDate, 
	Case When Acceptance.EXCLUSIVEF=0 and Acceptance.STime<Acceptance.ETime and (Case When datediff(day, RArrDet.EDate, RCalc.EDate)>=0 then RArrDet.EDate else RCalc.EDate end)=RArrDet.EDate Then dateadd(day,1,RArrDet.EDate) else (Case When datediff(day, RArrDet.EDate, RCalc.EDate)>=0 then RArrDet.EDate else RCalc.EDate end) end as FEDate
	from RArrDet, FPart
	Where RArrDet.ANO=RCalc.ANO and RArrDet.FID=@P_FID and FPart.ANO=RArrDet.ANO and FPart.FID=RArrDet.FID and RArrDet.FullCoverF=1
) RArrDet 
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
When RArrDet.PCalc='P' and RArrDet.CPCT<>0 then convert(varchar(25),Cast(RArrDet.CPCT as float),0)+'%'     
When Cast(Datediff(month, RCalc.RSDate, RCalc.REDate) as Float)<>0 then    
 Case    
 When RArrDet.PCalc='F' then     
         convert(varchar(25),Cast(Datediff(month, RArrDet.FSDate, RArrDet.FEDate) as Float))+'/12'    
 else    
  Case    
  When RArrDet.NetRate=0 then    
   Case     
   When RArrDet.PCalc='P' then    
 Case   
    When day(RArrDet.FSDate)=day(RArrDet.FEDate) and day(RCalc.RSDate)=day(RCalc.REDate) and Cover.PPeriod<>1 then    
            convert(varchar(25),Cast(Datediff(month, RArrDet.FSDate, RArrDet.FEDate) as Float))+'/12'    
    else    
            convert(varchar(25),Cast(DateDiff(day, RArrDet.FSDate, RArrDet.FEDate) as Float))+'/'+convert(varchar(25),Cover.Prorata)    
    end    
   else    
    Case    
    When day(RArrDet.FSDate)=day(RArrDet.FEDate) and day(RCalc.RSDate)=day(RCalc.REDate) and Cover.PPeriod<>1 then    
            convert(varchar(25),Cast(Datediff(month, RArrDet.FSDate, RArrDet.FEDate) as Float))+'/'+convert(varchar(25),Cast(Datediff(month, RCalc.RSDate, RCalc.REDate) as Float))    
    else    
            convert(varchar(25),Cast(DateDiff(day, RArrDet.FSDate, RArrDet.FEDate) as Float))+'/'+convert(varchar(25),Cast(Datediff(Day, RCalc.RSDate, RCalc.REDate) as Float))    
    end    
   end    
  else    
   Case    
   When day(RArrDet.FSDate)=day(RArrDet.FEDate) and day(RCalc.RSDate)=day(RCalc.REDate) and Cover.PPeriod<>1 then    
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
end
,
FacProrata=    
Case    
When Cover.Voyage=1 then ICalc.Prorata    
When RArrDet.PCalc='F' and RArrDet.NetRate=0 then ICalc.Prorata    
When RArrDet.PCalc='P' and RArrDet.CPCT<>0 then RArrDet.CPCT/100    
When Cast(Datediff(month, RCalc.RSDate, RCalc.REDate) as Float)<>0 then    
 Case    
 When RArrDet.PCalc='F' then     
  Cast(Datediff(month, RArrDet.FSDate, RArrDet.FEDate) as Float) / 12    
 else    
  Case    
  When RArrDet.NetRate=0 then    
   Case     
   When RArrDet.PCalc='P' then    
    Case    
    When day(RArrDet.FSDate)=day(RArrDet.FEDate) and day(RCalc.RSDate)=day(RCalc.REDate) and Cover.PPeriod<>1 then    
     Cast(Datediff(month, RArrDet.FSDate, RArrDet.FEDate) as Float)/12    
    else    
     Cast(DateDiff(day, RArrDet.FSDate, RArrDet.FEDate) as Float) / Cover.Prorata    
    end    
   else    
    Case    
    When day(RArrDet.FSDate)=day(RArrDet.FEDate) and day(RCalc.RSDate)=day(RCalc.REDate) and Cover.PPeriod<>1 then    
     Cast(Datediff(month, RArrDet.FSDate, RArrDet.FEDate) as Float)/Cast(Datediff(month, RCalc.RSDate, RCalc.REDate) as Float)    
    else    
     Cast(DateDiff(day, RArrDet.FSDate, RArrDet.FEDate) as Float) /Cast(Datediff(Day, RCalc.RSDate, RCalc.REDate) as Float)    
    end    
   end    
  else    
   Case    
   When day(RArrDet.FSDate)=day(RArrDet.FEDate) and day(RCalc.RSDate)=day(RCalc.REDate) and Cover.PPeriod<>1 then    
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
end,    
Case When RArrDet.Prorata<>0 then convert(varchar(25),RArrDet.Prorata) else '' end as sProrata,
Case When RArrDet.Prorata<>0 then RArrDet.Prorata else 1 end as Prorata
From acceptance 
inner Join Cover on (Cover.CNO=Acceptance.CNO)             
Cross Apply (
	Select RCalc.ANO, RCalc.Code, RCalc.Currency, RCalc.SDate, RCalc.EDate, RCalc.TOR, RCalc.Gross, RCalc.OGross,
	RCalc.SDate as RSDate,
	Case When Acceptance.EXCLUSIVEF=0 and Acceptance.STime<Acceptance.ETime and RCalc.EDate=Acceptance.EDate Then dateadd(day,1,RCalc.EDate) else RCalc.EDate end as REDate
	from RCalc Where RCalc.ANO=Acceptance.ANO
) RCalc
Cross Apply (
	Select ICALC.Prorata, ICALC.SProrata 
	from ICalc 
	Where ICalc.ANO=RCalc.ANO and ICalc.Currency=RCalc.Currency and ICalc.Code=RCalc.Code and ICalc.SDate=RCalc.SDate and ICalc.EDate=RCalc.EDate and ICalc.TOR=RCalc.TOR
) ICalc
Cross Apply (
	Select RArrDet.ANO, RCalc.Currency, Rcalc.Code, RArrDet.PCalc, RArrDet.CPCT, RArrDet.Prorata, FPart.NetRate, 
	Case When datediff(day, RCalc.SDate, RArrDet.SDate)>=0 then RArrDet.SDate else RCalc.SDate end as FSDate, 
	Case When Acceptance.EXCLUSIVEF=0 and Acceptance.STime<Acceptance.ETime and (Case When datediff(day, RArrDet.EDate, RCalc.EDate)>=0 then RArrDet.EDate else RCalc.EDate end)=RArrDet.EDate Then dateadd(day,1,RArrDet.EDate) else (Case When datediff(day, RArrDet.EDate, RCalc.EDate)>=0 then RArrDet.EDate else RCalc.EDate end) end as FEDate
	from RArrDet, FPartDet FPart, RateCov
	Where RArrDet.ANO=RCalc.ANO and RArrDet.FID=@P_FID and FPart.ANO=RArrDet.ANO and FPart.FID=RArrDet.FID and RArrDet.FullCoverF=0
	and RateCov.Code=FPart.Code and RateCov.TOR=RCalc.TOR 
) RArrDet 
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
When RArrDet.PCalc='P' and RArrDet.CPCT<>0 then convert(varchar(25),Cast(RArrDet.CPCT as float),0)+'%'     
When Cast(Datediff(month, RCalc.RSDate, RCalc.REDate) as Float)<>0 then    
 Case    
 When RArrDet.PCalc='F' then     
         convert(varchar(25),Cast(Datediff(month, RArrDet.FSDate, RArrDet.FEDate) as Float))+'/12'    
 else    
  Case    
  When RArrDet.NetRate=0 then    
   Case     
   When RArrDet.PCalc='P' then    
    Case    
    When day(RArrDet.FSDate)=day(RArrDet.FEDate) and day(RCalc.RSDate)=day(RCalc.REDate) and Cover.PPeriod<>1 then    
            convert(varchar(25),Cast(Datediff(month, RArrDet.FSDate, RArrDet.FEDate) as Float))+'/12'    
    else    
            convert(varchar(25),Cast(DateDiff(day, RArrDet.FSDate, RArrDet.FEDate) as Float))+'/'+convert(varchar(25),Cover.Prorata)    
    end    
   else    
    Case    
    When day(RArrDet.FSDate)=day(RArrDet.FEDate) and day(RCalc.RSDate)=day(RCalc.REDate) and Cover.PPeriod<>1 then    
            convert(varchar(25),Cast(Datediff(month, RArrDet.FSDate, RArrDet.FEDate) as Float))+'/'+convert(varchar(25),Cast(Datediff(month, RCalc.RSDate, RCalc.REDate) as Float))    
    else    
            convert(varchar(25),Cast(DateDiff(day, RArrDet.FSDate, RArrDet.FEDate) as Float))+'/'+convert(varchar(25),Cast(Datediff(Day, RCalc.RSDate, RCalc.REDate) as Float))    
    end    
   end    
  else    
   Case    
   When day(RArrDet.FSDate)=day(RArrDet.FEDate) and day(RCalc.RSDate)=day(RCalc.REDate) and Cover.PPeriod<>1 then    
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
end
,    
FacProrata=    
Case    
When Cover.Voyage=1 then ICalc.Prorata    
When RArrDet.PCalc='F' and RArrDet.NetRate=0 then ICalc.Prorata    
When RArrDet.PCalc='P' and RArrDet.CPCT<>0 then RArrDet.CPCT/100    
When Cast(Datediff(month, RCalc.RSDate, RCalc.REDate) as Float)<>0 then    
 Case    
 When RArrDet.PCalc='F' then     
  Cast(Datediff(month, RArrDet.FSDate, RArrDet.FEDate) as Float) / 12    
 else    
  Case    
  When RArrDet.NetRate=0 then    
   Case     
   When RArrDet.PCalc='P' then    
    Case    
    When day(RArrDet.FSDate)=day(RArrDet.FEDate) and day(RCalc.RSDate)=day(RCalc.REDate) and Cover.PPeriod<>1 then    
     Cast(Datediff(month, RArrDet.FSDate, RArrDet.FEDate) as Float)/12    
    else    
     Cast(DateDiff(day, RArrDet.FSDate, RArrDet.FEDate) as Float) / Cover.Prorata    
    end    
   else    
    Case    
    When day(RArrDet.FSDate)=day(RArrDet.FEDate) and day(RCalc.RSDate)=day(RCalc.REDate) and Cover.PPeriod<>1 then    
     Cast(Datediff(month, RArrDet.FSDate, RArrDet.FEDate) as Float)/Cast(Datediff(month, RCalc.RSDate, RCalc.REDate) as Float)    
    else    
     Cast(DateDiff(day, RArrDet.FSDate, RArrDet.FEDate) as Float) /Cast(Datediff(Day, RCalc.RSDate, RCalc.REDate) as Float)    
    end    
   end    
  else    
   Case    
   When day(RArrDet.FSDate)=day(RArrDet.FEDate) and day(RCalc.RSDate)=day(RCalc.REDate) and Cover.PPeriod<>1 then    
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
end,
Case When RArrDet.Prorata<>0 then convert(varchar(25),RArrDet.Prorata) else '' end as sProrata,
Case When RArrDet.Prorata<>0 then RArrDet.Prorata else 1 end as Prorata
From acceptance pAcceptance           
inner join Acceptance on (Acceptance.ANO=pAcceptance.pANO)    
inner Join Cover on (Cover.CNO=Acceptance.CNO)             
Cross Apply (
	Select RCalc.ANO, RCalc.Code, RCalc.Currency, RCalc.SDate, RCalc.EDate, RCalc.TOR, RCalc.Gross, RCalc.OGross,
	RCalc.SDate as RSDate,
	Case When Acceptance.EXCLUSIVEF=0 and Acceptance.STime<Acceptance.ETime and RCalc.EDate=Acceptance.EDate Then dateadd(day,1,RCalc.EDate) else RCalc.EDate end as REDate
	from RCalc Where RCalc.ANO=Acceptance.ANO
) RCalc
Cross Apply (
	Select ICALC.Prorata, ICALC.SProrata 
	from ICalc 
	Where ICalc.ANO=RCalc.ANO and ICalc.Currency=RCalc.Currency and ICalc.Code=RCalc.Code and ICalc.SDate=RCalc.SDate and ICalc.EDate=RCalc.EDate and ICalc.TOR=RCalc.TOR
) ICalc
Cross Apply (
	Select RArrDet.ANO, RCalc.Currency, Rcalc.Code, RArrDet.PCalc, RArrDet.CPCT, RArrDet.Prorata, FPart.NetRate, 
	Case When datediff(day, RCalc.SDate, RArrDet.SDate)>=0 then RArrDet.SDate else RCalc.SDate end as FSDate, 
	Case When Acceptance.EXCLUSIVEF=0 and Acceptance.STime<Acceptance.ETime and (Case When datediff(day, RArrDet.EDate, RCalc.EDate)>=0 then RArrDet.EDate else RCalc.EDate end)=RArrDet.EDate Then dateadd(day,1,RArrDet.EDate) else (Case When datediff(day, RArrDet.EDate, RCalc.EDate)>=0 then RArrDet.EDate else RCalc.EDate end) end as FEDate
	from RArrDet, FPartDet FPart, RateCov
	Where RArrDet.ANO=RCalc.ANO and RArrDet.FID=@P_FID and FPart.ANO=RArrDet.ANO and FPart.FID=RArrDet.FID and RArrDet.FullCoverF=0
	and RateCov.Code=FPart.Code and RateCov.TOR=RCalc.TOR 
) RArrDet 
Where pAcceptance.ANO=@P_ANO and RCalc.OGross<>0 and Cast(DateDiff(day, RArrDet.FSDate, RArrDet.FEDate) as Float) >  0    
    
)            

GO

DROP FUNCTION DISPLAY_GROSS_FACULTATIVE_CALCULATION
GO
CREATE FUNCTION DISPLAY_GROSS_FACULTATIVE_CALCULATION(@P_ANO int, @P_FID Varchar(20))      
RETURNS @PCALC TABLE (ANO Int, Currency varchar(10), Code varchar(10), FCode varchar(10), SDate SmallDateTime, EDate SmallDateTime, Gross Float, Calculation varchar(1024))
AS
BEGIN


DECLARE @ACCEPTANCE TABLE (ANO Int, CNO Int, PANO Int, ATYPE varchar(1), EMethod varchar(1), SDate Smalldatetime, EDate Smalldatetime, ExclusiveF Bit, STime varchar(8), ETime varchar(8))
INSERT INTO @ACCEPTANCE
SELECT ANO, CNO, PANO, ATYPE, EMethod, SDate, EDate, ExclusiveF, STime, ETime FROM ACCEPTANCE WHERE ANO=@P_ANO

DECLARE @RARRDET TABLE (ANO Int, ATYPE Varchar(1), FID varchar(20), RateL Float, Limit Float, PCalc varchar(1), SDate SmallDateTime, EDate SmallDateTime, Share Float, FLPCT Float, OnGrossAfterCommF Bit, FullCoverF Bit, NoRefundF Bit)
INSERT INTO @RARRDET
Select ANO, ATYPE, FID, RateL, Limit, PCalc, SDate, EDate, Share, FLPCT, OnGrossAfterCommF, FullCoverF, NOREFUNDF FROM RarrDet Where ANO=@P_ANO and FID=@P_FID

DECLARE @ICALC TABLE (ANO Int, Currency varchar(10), SDate smalldatetime, EDate smalldatetime, Gross Float)

INSERT INTO @ICALC
Select A.ANO, I.Currency, I.SDate, I.EDate, Sum(I.Gross) as Gross
from ICalc I, @ACCEPTANCE A
Where I.ANO=A.ANO and I.Gross<>0 
Group By A.ANO, I.Currency, I.SDate, I.EDate

INSERT INTO @ICALC
Select A.pANO as ANO, I.Currency, I.SDate, I.EDate, Sum(I.Gross) as Gross
from ICalc I, @ACCEPTANCE A
Where I.ANO=A.PANO and I.Gross<>0 
Group By A.pANO, I.Currency, I.SDate, I.EDate

Declare @P_FullcoverF Bit
Declare @P_PANO Int

Select @P_PANO=PANO from @ACCEPTANCE 
Select @P_FullcoverF=FullCoverF from @RArrDet



if @P_FullcoverF=1
Begin
	--1
	Insert into @PCALC
	Select ICalc.ANO, ICalc.Currency, ICalc.Code, ICalc.FCode, ICalc.SDate, ICalc.EDate,   
	Gross=    
	Case     
	 When max(ICalc.NetRate)=0 then    
	  case When Max(ICalc.FLPCT)=0 Then    
		Case When Max(ICalc.Unit)='F' Then
			sum(ICalc.PCTShare/100*ICalc.Gross*(Case When ICalc.OnGrossAfterCommF=1 Then (100-dbo.Premium_Facultative_Commission(ICalc.ANO, ICalc.Code,0,0))/100 else 1 end)/Icalc.PProrata)*max(ICalc.FacProrata)
		Else
			sum(ICalc.PCTShare/100*ICalc.Gross*(Case When ICalc.OnGrossAfterCommF=1 Then (100-dbo.Premium_Facultative_Commission(ICalc.ANO, ICalc.Code,0,0))/100 else 1 end)/Icalc.PProrata)*max(ICalc.FacProrata)*max(ICalc.Share)/100*max(ICalc.RShare)/100
		End
	  else    
	   sum(ICalc.PCTShare/100*ICalc.Gross*(Case When ICalc.OnGrossAfterCommF=1 Then (100-dbo.Premium_Facultative_Commission(ICalc.ANO, ICalc.Code,0,0))/100 else 1 end)/Icalc.PProrata)*max(ICalc.FacProrata)    
	  end  
	 else    
	  case When Max(ICalc.FLPCT)=0 Then    
		   Case 
		   When Max(ICalc.Unit)='F' Then
			sum(ICalc.NetRate)*max(ICalc.FacProrata)
		   When Max(ICalc.Unit)='M' Then
			sum(ICalc.PCTShare/100*Icalc.TSI*ICalc.PCTADJ/100)*max(ICalc.NetRate)/1000*max(ICalc.FacProrata)*max(ICalc.Share)/100*max(ICalc.RShare)/100   
		   else
			sum(ICalc.PCTShare/100*Icalc.TSI*ICalc.PCTADJ/100)*max(ICalc.NetRate)/100*max(ICalc.FacProrata)*max(ICalc.Share)/100*max(ICalc.RShare)/100   			
		   end
	  else    
		   Case 
		   When Max(ICalc.Unit)='F' Then
			sum(ICalc.NetRate)*max(ICalc.FacProrata)       
		   When Max(ICalc.Unit)='M' Then
		    sum(ICalc.PCTShare/100*Icalc.TSI*ICalc.PCTADJ/100)*max(ICalc.NetRate)/1000*max(ICalc.FacProrata)       
		   else
			sum(ICalc.PCTShare/100*Icalc.TSI*ICalc.PCTADJ/100)*max(ICalc.NetRate)/100*max(ICalc.FacProrata)       
		   end  
	  end    
	 end,     
	Calculation=      
	Case     
	 When max(ICalc.NetRate)=0 Then    
	  case When Max(ICalc.FLPCT)=0 Then    
		Case 
		When Max(ICalc.Unit)='F' Then
			convert(varchar(25), cast(sum(ICalc.PCTShare/100*ICalc.Gross*(Case When ICalc.OnGrossAfterCommF=1 Then (100-dbo.Premium_Facultative_Commission(ICalc.ANO, ICalc.Code,0,0))/100 else 1 end)/ICalc.PProrata) as Money),1) + Case When max(ICalc.FacProrata_Calculation)='' or Max(ICalc.FacProrata)=1 Then '' Else ' x ' + max(ICalc.FacProrata_Calculation) End
		Else
			convert(varchar(25), cast(sum(ICalc.PCTShare/100*ICalc.Gross*(Case When ICalc.OnGrossAfterCommF=1 Then (100-dbo.Premium_Facultative_Commission(ICalc.ANO, ICalc.Code,0,0))/100 else 1 end)/ICalc.PProrata) as Money),1) + Case When max(ICalc.FacProrata_Calculation)='' or Max(ICalc.FacProrata)=1 Then '' Else ' x ' + max(ICalc.FacProrata_Calculation) End + ' x '+convert(varchar(25), Max(ICalc.Share),0)+'%' + ' x '+convert(varchar(25), Max(ICalc.RShare),0)+'%'    
		End
	  else    
	   convert(varchar(25), cast(sum(ICalc.PCTShare/100*ICalc.Gross*(Case When ICalc.OnGrossAfterCommF=1 Then (100-dbo.Premium_Facultative_Commission(ICalc.ANO, ICalc.Code,0,0))/100 else 1 end)/ICalc.PProrata) as Money),1) + Case When max(ICalc.FacProrata_Calculation)='' or Max(ICalc.FacProrata)=1 Then '' Else ' x ' + max(ICalc.FacProrata_Calculation) End    
	  end    
	 else    
	  Case When Max(ICalc.FacProrata*ICalc.NetRateProrata)=1 then    

	   case When Max(ICalc.FLPCT)=0 Then    
			case 
			When Max(ICalc.Unit)='F' Then
				convert(varchar(25), Cast(sum(ICalc.NetRate/ICalc.NetRateProrata) as Money),1) + Case When max(ICalc.FacProrata_Calculation)='' or Max(ICalc.FacProrata*ICalc.NetRateProrata)=1 Then '' Else ' x ' + max(ICalc.FacProrata_Calculation) End 
			When Max(ICalc.Unit)='M' Then
				convert(varchar(25), cast(sum(ICalc.PCTShare/100*Icalc.TSI*ICalc.PCTADJ/100) as Money),1) + ' x '+convert(varchar(25), cast(max(ICalc.NetRate/ICalc.NetRateProrata) as Money),2)+'‰' + Case When max(ICalc.FacProrata_Calculation)='' or Max(ICalc.FacProrata*ICalc.NetRateProrata)=1 Then '' Else ' x ' + max(ICalc.FacProrata_Calculation) End + ' x '+convert(varchar(25), Max(ICalc.Share),0)+'%' + ' x '+convert(varchar(25), Max(ICalc.RShare),0)+'%'    
			else
				convert(varchar(25), cast(sum(ICalc.PCTShare/100*Icalc.TSI*ICalc.PCTADJ/100) as Money),1) + ' x '+convert(varchar(25), cast(max(ICalc.NetRate/ICalc.NetRateProrata) as Money),2)+'%' + Case When max(ICalc.FacProrata_Calculation)='' or Max(ICalc.FacProrata*ICalc.NetRateProrata)=1 Then '' Else ' x ' + max(ICalc.FacProrata_Calculation) End + ' x '+convert(varchar(25), Max(ICalc.Share),0)+'%' + ' x '+convert(varchar(25), Max(ICalc.RShare),0)+'%'   
			end
	   else 
			Case 
			When Max(ICalc.Unit)='F' Then		   
				convert(varchar(25), Cast(sum(ICalc.NetRate/ICalc.NetRateProrata) as Money),1) + Case When max(ICalc.FacProrata_Calculation)='' or Max(ICalc.FacProrata*ICalc.NetRateProrata)=1 Then '' Else ' x ' + max(ICalc.FacProrata_Calculation) End     
			When Max(ICalc.Unit)='M' Then		   
				convert(varchar(25), cast(sum(ICalc.PCTShare/100*Icalc.TSI*ICalc.PCTADJ/100) as Money),1) + ' x '+convert(varchar(25), cast(max(ICalc.NetRate/ICalc.NetRateProrata) as Money),2)+'‰' + Case When max(ICalc.FacProrata_Calculation)='' or Max(ICalc.FacProrata*ICalc.NetRateProrata)=1 Then '' Else ' x ' + max(ICalc.FacProrata_Calculation) End 		
			else
				convert(varchar(25), cast(sum(ICalc.PCTShare/100*Icalc.TSI*ICalc.PCTADJ/100) as Money),1) + ' x '+convert(varchar(25), cast(max(ICalc.NetRate/ICalc.NetRateProrata) as Money),2)+'%' + Case When max(ICalc.FacProrata_Calculation)='' or Max(ICalc.FacProrata*ICalc.NetRateProrata)=1 Then '' Else ' x ' + max(ICalc.FacProrata_Calculation) End 		
			end
	   end    
	  
	  else    
	   case When Max(ICalc.FLPCT)=0 Then    
			Case 
			When Max(ICalc.Unit)='F' Then
				convert(varchar(25), sum(ICalc.NetRate),1) + Case When max(ICalc.FacProrata_Calculation)='' or Max(ICalc.FacProrata)=1 Then '' Else ' x ' + max(ICalc.FacProrata_Calculation) End
			When Max(ICalc.Unit)='M' Then
				convert(varchar(25), cast(sum(ICalc.PCTShare/100*Icalc.TSI*ICalc.PCTADJ/100) as Money),1) + ' x '+convert(varchar(25), max(ICalc.NetRate),0)+'‰' + Case When max(ICalc.FacProrata_Calculation)='' or Max(ICalc.FacProrata)=1 Then '' Else ' x ' + max(ICalc.FacProrata_Calculation) End + ' x '+convert(varchar(25), Max(ICalc.Share),0)+'%' + ' x '+convert(varchar(25), Max(ICalc.RShare),0)+'%'    		
			else
				convert(varchar(25), cast(sum(ICalc.PCTShare/100*Icalc.TSI*ICalc.PCTADJ/100) as Money),1) + ' x '+convert(varchar(25), max(ICalc.NetRate),0)+'%' + Case When max(ICalc.FacProrata_Calculation)='' or Max(ICalc.FacProrata)=1 Then '' Else ' x ' + max(ICalc.FacProrata_Calculation) End + ' x '+convert(varchar(25), Max(ICalc.Share),0)+'%' + ' x '+convert(varchar(25), Max(ICalc.RShare),0)+'%'    		
			end
	   else    
			Case 
			When Max(ICalc.Unit)='F' then
				convert(varchar(25), sum(ICalc.NetRate),1) + Case When max(ICalc.FacProrata_Calculation)='' or Max(ICalc.FacProrata)=1 Then '' Else ' x ' + max(ICalc.FacProrata_Calculation) End     
			When Max(ICalc.Unit)='M' then
				convert(varchar(25), cast(sum(ICalc.PCTShare/100*Icalc.TSI*ICalc.PCTADJ/100) as Money),1) + ' x '+convert(varchar(25), max(ICalc.NetRate),0)+'‰' + Case When max(ICalc.FacProrata_Calculation)='' or Max(ICalc.FacProrata)=1 Then '' Else ' x ' + max(ICalc.FacProrata_Calculation) End     		
			else
				convert(varchar(25), cast(sum(ICalc.PCTShare/100*Icalc.TSI*ICalc.PCTADJ/100) as Money),1) + ' x '+convert(varchar(25), max(ICalc.NetRate),0)+'%' + Case When max(ICalc.FacProrata_Calculation)='' or Max(ICalc.FacProrata)=1 Then '' Else ' x ' + max(ICalc.FacProrata_Calculation) End     		
			end
	   end      
	  end    
	 
	 End    
	From      
	(Select ICalc.ANO, ICalc.INO, ICalc.Currency, ICalc.Code, ICalc.Sdate, ICalc.Edate, ICalc.PCTAdj,    
	Max(FPart.Code) as FCode,
	Max(
		Case 
		When D.SProrata='' then D.FacProrata_Calculation 
		else 
			Case 
			When D.FacProrata_Calculation<>'' then D.FacProrata_Calculation+' x' +D.SProrata 
			else D.SProrata 
			End 
		End) as FacProrata_calculation,    
	Max(D.FacProrata*D.Prorata) as FacProrata,     
	SUM(Case When PCALC.Description<>'' and PCALC.Description<>'Minimum Premium' then ICALC.GROSS*PCALC.GROSS/PCALC.OGROSS else ICALC.GROSS*D.GROSS/D.OGROSS end*(Case When RArrDet.Limit<>0 Then RArrDet.Limit/RArrHeader.TAmount Else 1 end)) AS GROSS,         

	AVG(ICalc.Prorata) as PProrata,     
	Max(PCalc.Ourshare/PCalc.TSI*100) as PCTShare,     
	Max(ICalc.SRate) as SRate,     
	Max((Case When RArrDet.Limit<>0 Then RArrDet.Limit*RArrDet.RateL/RArrHeader.TAmount else 1 end)*ICalc.TSI) as TSI,     
	Max(Case When RArrDet.PCalc='P' or datediff(month,RArrDet.SDate, (Case When Acceptance.EXCLUSIVEF=0 and Acceptance.STime<Acceptance.ETime Then dateadd(day,1,RArrDet.EDate) else RArrDet.EDate end))=0 or Cover.Voyage=1 Then 1 else 12/cast(datediff(month,RArrDet.SDate, (Case When Acceptance.EXCLUSIVEF=0 and Acceptance.STime<Acceptance.ETime Then dateadd(day,1,RArrDet.EDate) else RArrDet.EDate end)) as Float) end) as NetRateProrata,    
	Case 
	When Max(FPart.Unit)='F' Then 
		Sum(FPart.NetRate*Case When RArrDet.PCalc='P' or datediff(month,RArrDet.SDate, (Case When Acceptance.EXCLUSIVEF=0 and Acceptance.STime<Acceptance.ETime Then dateadd(day,1,RArrDet.EDate) else RArrDet.EDate end))=0 or Cover.Voyage=1 Then 1 else 12/cast(datediff(month,RArrDet.SDate, (Case When Acceptance.EXCLUSIVEF=0 and Acceptance.STime<Acceptance.ETime Then dateadd(day,1,RArrDet.EDate) else RArrDet.EDate end)) as Float) end/(I.Gross/ICalc.Gross)) 
	Else
		Max(FPart.NetRate*Case When RArrDet.PCalc='P' or datediff(month,RArrDet.SDate, (Case When Acceptance.EXCLUSIVEF=0 and Acceptance.STime<Acceptance.ETime Then dateadd(day,1,RArrDet.EDate) else RArrDet.EDate end))=0 or Cover.Voyage=1 Then 1 else 12/cast(datediff(month,RArrDet.SDate, (Case When Acceptance.EXCLUSIVEF=0 and Acceptance.STime<Acceptance.ETime Then dateadd(day,1,RArrDet.EDate) else RArrDet.EDate end)) as Float) end) 
	End as NetRate,    
	Max(FPart.Unit) as Unit,
	Max(RArrDet.Share) as Share,    
	Max(FPart.Share) as RShare,    
	Max(RArrDet.FLPCT) as FLPCT,    
	Max(ICalc.sProrata) as sProrata,  
	Max(Cast(RArrDet.OnGrossAfterCommF as Integer)) as OnGrossAfterCommF  
		
	from @Acceptance Acceptance
	Inner Join RArrHeader on (RArrHeader.ANO=Acceptance.ANO)
	Inner Join ICalc on (ICalc.ANO=Acceptance.ANO and ICalc.Rate<>0)
	Inner Join PCalc on (PCalc.ANO=ICalc.ANO and PCalc.Currency=ICalc.Currency)
	Inner Join @ICALC I ON (I.ANO=ICALC.ANO AND I.Currency=ICALC.Currency and I.SDate=ICALC.SDATE and I.EDATE=ICALC.EDATE)
	Inner Join DISPLAY_FACULTATIVE_PRORATA_CALCULATION(@P_ANO, @P_FID) D on (D.ANO=ICalc.ANO and D.Currency=ICalc.Currency and D.Code=ICalc.Code and D.SDate=ICalc.Sdate and D.EDate=ICalc.EDate and D.TOR=ICalc.TOR    )
	Inner Join @RARRDET RArrDet on (RArrDet.AType<>'C' and RArrDet.FullCoverF=1 and RArrDet.ANO=D.ANO and RArrDet.FID=@P_FID)
	Inner Join FPart on (FPart.ANO=RArrDet.ANO and FPart.FID=RArrdet.FID and (FPart.Currency='' or FPart.Currency=ICalc.Currency))
	Inner Join Cover on (Cover.CNO=Acceptance.CNO)
	Where Acceptance.ANO=@P_ANO 
	Group By ICalc.ANO, ICalc.INO, ICalc.Currency, ICalc.Code, ICalc.SDate, ICalc.EDate, ICalc.PCTAdj    
	) ICalc    
	Group By ICalc.ANO, ICalc.Currency, ICalc.Code, ICalc.FCode, ICalc.SDate, ICalc.EDate, ICalc.SRate, ICalc.sProrata, ICalc.PCTadj      
End
    

--2 (Refund from Endorsement)    
If @P_PANO<>-1 AND @P_FullcoverF=1
BEGIN
	Insert into @PCALC
	Select ICalc.ANO, ICalc.Currency, ICalc.Code, ICalc.FCode, ICalc.SDate, ICalc.EDate,   
	Gross=-    
	Case     
	 When max(ICalc.NetRate)=0 then    
	  case When Max(ICalc.FLPCT)=0 Then    
		Case 
		When Max(ICalc.Unit)='F' Then
			sum(ICalc.PCTShare/100*ICalc.Gross*(Case When ICalc.OnGrossAfterCommF=1 Then (100-dbo.Premium_Facultative_Commission(ICalc.ANO, ICalc.Code,0,0))/100 else 1 end)/Icalc.PProrata)*max(ICalc.FacProrata)
		Else
			sum(ICalc.PCTShare/100*ICalc.Gross*(Case When ICalc.OnGrossAfterCommF=1 Then (100-dbo.Premium_Facultative_Commission(ICalc.ANO, ICalc.Code,0,0))/100 else 1 end)/Icalc.PProrata)*max(ICalc.FacProrata)*max(ICalc.Share)/100*max(ICalc.RShare)/100    
		End
	  else    
		sum(ICalc.PCTShare/100*ICalc.Gross*(Case When ICalc.OnGrossAfterCommF=1 Then (100-dbo.Premium_Facultative_Commission(ICalc.ANO, ICalc.Code,0,0))/100 else 1 end)/Icalc.PProrata)*max(ICalc.FacProrata)    
	  end    
	 else    
	  case When Max(ICalc.FLPCT)=0 Then    
		   Case 
		   When Max(ICalc.Unit)='F' Then
			sum(ICalc.NetRate)*max(ICalc.FacProrata)
		   When Max(ICalc.Unit)='M' Then
		    sum(ICalc.PCTShare/100*Icalc.TSI*ICalc.PCTADJ/100)*max(ICalc.NetRate)/1000*max(ICalc.FacProrata)*max(ICalc.Share)/100*max(ICalc.RShare)/100       
		   else
			sum(ICalc.PCTShare/100*Icalc.TSI*ICalc.PCTADJ/100)*max(ICalc.NetRate)/100*max(ICalc.FacProrata)*max(ICalc.Share)/100*max(ICalc.RShare)/100       
		   end
	  else    
		   Case 
		   When Max(ICalc.Unit)='F' Then
			sum(ICalc.NetRate)*max(ICalc.FacProrata)       
		   When Max(ICalc.Unit)='M' Then
		    sum(ICalc.PCTShare/100*Icalc.TSI*ICalc.PCTADJ/100)*max(ICalc.NetRate)/1000*max(ICalc.FacProrata)       
		   else
			sum(ICalc.PCTShare/100*Icalc.TSI*ICalc.PCTADJ/100)*max(ICalc.NetRate)/100*max(ICalc.FacProrata)       
		   end  
	  end  
	 end,
	 
	Calculation=      
	Case     
	 When max(ICalc.NetRate)=0 Then    
	  case When Max(ICalc.FLPCT)=0 Then    
		Case When Max(ICalc.Unit)='F' Then
			'- ' + convert(varchar(25), cast(sum(ICalc.PCTShare/100*ICalc.Gross*(Case When ICalc.OnGrossAfterCommF=1 Then (100-dbo.Premium_Facultative_Commission(ICalc.ANO, ICalc.Code,0,0))/100 else 1 end)/ICalc.PProrata) as Money),1) + Case When max(ICalc.FacProrata_Calculation)='' or Max(ICalc.FacProrata)=1 Then '' Else ' x ' + max(ICalc.FacProrata_Calculation) End
		Else
			'- ' + convert(varchar(25), cast(sum(ICalc.PCTShare/100*ICalc.Gross*(Case When ICalc.OnGrossAfterCommF=1 Then (100-dbo.Premium_Facultative_Commission(ICalc.ANO, ICalc.Code,0,0))/100 else 1 end)/ICalc.PProrata) as Money),1) + Case When max(ICalc.FacProrata_Calculation)='' or Max(ICalc.FacProrata)=1 Then '' Else ' x ' + max(ICalc.FacProrata_Calculation) End + ' x '+convert(varchar(25), Max(ICalc.Share),0)+'%' + ' x '+convert(varchar(25), Max(ICalc.RShare),0)+'%'        
		End
	  else    
	   '- ' + convert(varchar(25), cast(sum(ICalc.PCTShare/100*ICalc.Gross*(Case When ICalc.OnGrossAfterCommF=1 Then (100-dbo.Premium_Facultative_Commission(ICalc.ANO, ICalc.Code,0,0))/100 else 1 end)/ICalc.PProrata) as Money),1) + Case When max(ICalc.FacProrata_Calculation)='' or Max(ICalc.FacProrata)=1 Then '' Else ' x ' + max(ICalc.FacProrata_Calculation) End    
	  end    
	 else    
	  Case When Max(ICalc.FacProrata*ICalc.NetRateProrata)=1 then    
	   case When Max(ICalc.FLPCT)=0 Then    
			case 
			When Max(ICalc.Unit)='F' Then
				'- ' + convert(varchar(25), Cast(sum(ICalc.NetRate/ICalc.NetRateProrata) as Money),1) + Case When max(ICalc.FacProrata_Calculation)='' or Max(ICalc.FacProrata*ICalc.NetRateProrata)=1 Then '' Else ' x ' + max(ICalc.FacProrata_Calculation) End
			When Max(ICalc.Unit)='M' Then
				'- ' + convert(varchar(25), cast(sum(ICalc.PCTShare/100*Icalc.TSI*ICalc.PCTADJ/100) as Money),1) + ' x '+convert(varchar(25), cast(max(ICalc.NetRate/ICalc.NetRateProrata) as Money),2)+'‰' + Case When max(ICalc.FacProrata_Calculation)='' or Max(ICalc.FacProrata*ICalc.NetRateProrata)=1 Then '' Else ' x ' + max(ICalc.FacProrata_Calculation) End + ' x '+convert(varchar(25), Max(ICalc.Share),0)+'%' + ' x '+convert(varchar(25), Max(ICalc.RShare),0)+'%'        
			else
				'- ' + convert(varchar(25), cast(sum(ICalc.PCTShare/100*Icalc.TSI*ICalc.PCTADJ/100) as Money),1) + ' x '+convert(varchar(25), cast(max(ICalc.NetRate/ICalc.NetRateProrata) as Money),2)+'%' + Case When max(ICalc.FacProrata_Calculation)='' or Max(ICalc.FacProrata*ICalc.NetRateProrata)=1 Then '' Else ' x ' + max(ICalc.FacProrata_Calculation) End + ' x '+convert(varchar(25), Max(ICalc.Share),0)+'%' + ' x '+convert(varchar(25), Max(ICalc.RShare),0)+'%'           
			end
	   else 
			Case 
			When Max(ICalc.Unit)='F' Then		   
				'- ' + convert(varchar(25), Cast(sum(ICalc.NetRate/ICalc.NetRateProrata) as Money),1) + Case When max(ICalc.FacProrata_Calculation)='' or Max(ICalc.FacProrata*ICalc.NetRateProrata)=1 Then '' Else ' x ' + max(ICalc.FacProrata_Calculation) End     
			When Max(ICalc.Unit)='M' Then		   
				'- ' + convert(varchar(25), cast(sum(ICalc.PCTShare/100*Icalc.TSI*ICalc.PCTADJ/100) as Money),1) + ' x '+convert(varchar(25), cast(max(ICalc.NetRate/ICalc.NetRateProrata) as Money),2)+'‰' + Case When max(ICalc.FacProrata_Calculation)='' or Max(ICalc.FacProrata*ICalc.NetRateProrata)=1 Then '' Else ' x ' + max(ICalc.FacProrata_Calculation) End 		
			else
				'- ' + convert(varchar(25), cast(sum(ICalc.PCTShare/100*Icalc.TSI*ICalc.PCTADJ/100) as Money),1) + ' x '+convert(varchar(25), cast(max(ICalc.NetRate/ICalc.NetRateProrata) as Money),2)+'%' + Case When max(ICalc.FacProrata_Calculation)='' or Max(ICalc.FacProrata*ICalc.NetRateProrata)=1 Then '' Else ' x ' + max(ICalc.FacProrata_Calculation) End 		
			end
	   end    
	  else    
	   case When Max(ICalc.FLPCT)=0 Then    
			Case 
			When Max(ICalc.Unit)='F' Then
				'- ' + convert(varchar(25), sum(ICalc.NetRate),1) + Case When max(ICalc.FacProrata_Calculation)='' or Max(ICalc.FacProrata)=1 Then '' Else ' x ' + max(ICalc.FacProrata_Calculation) End
			When Max(ICalc.Unit)='M' Then
				'- ' + convert(varchar(25), cast(sum(ICalc.PCTShare/100*Icalc.TSI*ICalc.PCTADJ/100) as Money),1) + ' x '+convert(varchar(25), max(ICalc.NetRate),0)+'‰' + Case When max(ICalc.FacProrata_Calculation)='' or Max(ICalc.FacProrata)=1 Then '' Else ' x ' + max(ICalc.FacProrata_Calculation) End + ' x '+convert(varchar(25), Max(ICalc.Share),0)+'%' + ' x '+convert(varchar(25), Max(ICalc.RShare),0)+'%'            		
			else
				'- ' + convert(varchar(25), cast(sum(ICalc.PCTShare/100*Icalc.TSI*ICalc.PCTADJ/100) as Money),1) + ' x '+convert(varchar(25), max(ICalc.NetRate),0)+'%' + Case When max(ICalc.FacProrata_Calculation)='' or Max(ICalc.FacProrata)=1 Then '' Else ' x ' + max(ICalc.FacProrata_Calculation) End + ' x '+convert(varchar(25), Max(ICalc.Share),0)+'%' + ' x '+convert(varchar(25), Max(ICalc.RShare),0)+'%'    		
			end
	   else    
			Case 
			When Max(ICalc.Unit)='F' then
				'- ' + convert(varchar(25), sum(ICalc.NetRate),1) + Case When max(ICalc.FacProrata_Calculation)='' or Max(ICalc.FacProrata)=1 Then '' Else ' x ' + max(ICalc.FacProrata_Calculation) End     
			When Max(ICalc.Unit)='M' then
				'- ' + convert(varchar(25), cast(sum(ICalc.PCTShare/100*Icalc.TSI*ICalc.PCTADJ/100) as Money),1) + ' x '+convert(varchar(25), max(ICalc.NetRate),0)+'‰' + Case When max(ICalc.FacProrata_Calculation)='' or Max(ICalc.FacProrata)=1 Then '' Else ' x ' + max(ICalc.FacProrata_Calculation) End     		
			else
				'- ' + convert(varchar(25), cast(sum(ICalc.PCTShare/100*Icalc.TSI*ICalc.PCTADJ/100) as Money),1) + ' x '+convert(varchar(25), max(ICalc.NetRate),0)+'%' + Case When max(ICalc.FacProrata_Calculation)='' or Max(ICalc.FacProrata)=1 Then '' Else ' x ' + max(ICalc.FacProrata_Calculation) End     		
			end
	   end      
	  end     
	 End    

	From      
	(Select ICalc.ANO, ICalc.INO, ICalc.Currency, ICalc.Code, ICalc.Sdate, ICalc.Edate, ICalc.PCTAdj,    
	Max(FPart.Code) as FCode,
		Max(
		Case 
		When D.SProrata='' then D.FacProrata_Calculation 
		else 
			Case 
			When D.FacProrata_Calculation<>'' then D.FacProrata_Calculation+' x' +D.SProrata 
			else D.SProrata 
			End 
		End) as FacProrata_calculation,    
	Max(D.FacProrata*D.Prorata) as FacProrata,     
	SUM(Case When PCALC.Description<>'' and PCALC.Description<>'Minimum Premium' then ICALC.GROSS*PCALC.GROSS/PCALC.OGROSS else ICALC.GROSS*D.GROSS/D.OGROSS end*(Case When RArrDet.Limit<>0 Then RArrDet.Limit/RArrHeader.TAmount Else 1 end)) AS GROSS,         

	AVG(ICalc.Prorata) as PProrata,     
	Max(PCalc.Ourshare/PCalc.TSI*100) as PCTShare,     
	Max(ICalc.SRate) as SRate,     
	Max((Case When RArrDet.Limit<>0 Then RArrDet.Limit*RArrDet.RateL/RArrHeader.TAmount else 1 end)*ICalc.TSI) as TSI,     
	Max(Case When RArrDet.PCalc='P' or datediff(month,RArrDet.SDate, (Case When Acceptance.EXCLUSIVEF=0 and Acceptance.STime<Acceptance.ETime Then dateadd(day,1,RArrDet.EDate) else RArrDet.EDate end))=0 or Cover.Voyage=1 Then 1 else 12/cast(datediff(month,RArrDet.SDate, (Case When Acceptance.EXCLUSIVEF=0 and Acceptance.STime<Acceptance.ETime Then dateadd(day,1,RArrDet.EDate) else RArrDet.EDate end)) as Float) end) as NetRateProrata,    
	Case 
	When Max(FPart.Unit)='F' Then 
		Sum(FPart.NetRate*Case When RArrDet.PCalc='P' or datediff(month,RArrDet.SDate, (Case When Acceptance.EXCLUSIVEF=0 and Acceptance.STime<Acceptance.ETime Then dateadd(day,1,RArrDet.EDate) else RArrDet.EDate end))=0 or Cover.Voyage=1 Then 1 else 12/cast(datediff(month,RArrDet.SDate, (Case When Acceptance.EXCLUSIVEF=0 and Acceptance.STime<Acceptance.ETime Then dateadd(day,1,RArrDet.EDate) else RArrDet.EDate end)) as Float) end/(I.Gross/ICalc.Gross)) 
	Else
		Max(FPart.NetRate*Case When RArrDet.PCalc='P' or datediff(month,RArrDet.SDate, (Case When Acceptance.EXCLUSIVEF=0 and Acceptance.STime<Acceptance.ETime Then dateadd(day,1,RArrDet.EDate) else RArrDet.EDate end))=0 or Cover.Voyage=1 Then 1 else 12/cast(datediff(month,RArrDet.SDate, (Case When Acceptance.EXCLUSIVEF=0 and Acceptance.STime<Acceptance.ETime Then dateadd(day,1,RArrDet.EDate) else RArrDet.EDate end)) as Float) end) 
	End as NetRate,    
	Max(FPart.Unit) as Unit,
	Max(RArrDet.Share) as Share,    
	Max(FPart.Share) as RShare,    
	Max(RArrDet.FLPCT) as FLPCT,    
	Max(pAcceptance.AType) as AType,
	Max(pAcceptance.EMethod) as EMethod,
	Max(ICalc.sProrata) as sProrata,  
	Max(Cast(RArrDet.OnGrossAfterCommF as Integer)) as OnGrossAfterCommF  
	from @Acceptance pAcceptance
	Inner Join Acceptance on (Acceptance.ANO=pAcceptance.pANO)
	Inner Join RArrHeader on (RArrHeader.ANO=Acceptance.ANO)
	Inner Join ICalc on (ICalc.ANO=Acceptance.ANO and ICalc.Rate<>0)
	Inner Join PCalc on (PCalc.ANO=ICalc.ANO and PCalc.Currency=ICalc.Currency)
	Inner Join @ICALC I ON (I.ANO=ICALC.ANO AND I.Currency=ICALC.Currency and I.SDate=ICALC.SDATE and I.EDATE=ICALC.EDATE)
	Inner Join DISPLAY_FACULTATIVE_PRORATA_CALCULATION(@P_ANO, @P_FID) D on (D.ANO=ICalc.ANO and D.Currency=ICalc.Currency and D.Code=ICalc.Code and D.SDate=ICalc.Sdate and D.EDate=ICalc.EDate and D.TOR=ICalc.TOR)
	Inner Join RArrDet on (RArrDet.AType<>'C' and RArrDet.Status in ('A','R') and RArrDet.FullCoverF=1 and RArrDet.ANO=D.ANO and RArrDet.FID=@P_FID)
	Inner Join FPart on (FPart.ANO=RArrDet.ANO and FPart.FID=RArrdet.FID and (FPart.Currency='' or FPart.Currency=ICalc.Currency))
	Inner Join @RARRDET nRArrDet on (nRArrDet.ANO=pAcceptance.ANO and nRArrDet.FID=@P_FID)
	Inner Join Cover on (Cover.CNO=Acceptance.CNO)
	Where pAcceptance.ANO=@P_ANO 
	Group By ICalc.ANO, ICalc.INO, ICalc.Currency, ICalc.Code, ICalc.SDate, ICalc.EDate, ICalc.PCTAdj    
	) ICalc    
	Group By ICalc.ANO, ICalc.Currency, ICalc.Code, ICalc.FCode, ICalc.SDate, ICalc.EDate, ICalc.SRate, ICalc.sProrata, ICalc.PCTadj                  
End

--3 Detail    
IF @P_FullcoverF=0
BEGIN
	Insert into @PCALC
	Select ICalc.ANO, ICalc.Currency, ICalc.Code, ICalc.FCode, ICalc.SDate, ICalc.EDate,   
	Gross=    
	Case     
	 When max(ICalc.NetRate)=0 then    
	  case When Max(ICalc.FLPCT)=0 Then    
		Case When Max(ICalc.Unit)='F' Then
			sum(ICalc.PCTShare/100*ICalc.Gross*(Case When ICalc.OnGrossAfterCommF=1 Then (100-dbo.Premium_Facultative_Commission(ICalc.ANO, ICalc.Code,0,0))/100 else 1 end)/Icalc.PProrata)*max(ICalc.FacProrata)
		Else
			sum(ICalc.PCTShare/100*ICalc.Gross*(Case When ICalc.OnGrossAfterCommF=1 Then (100-dbo.Premium_Facultative_Commission(ICalc.ANO, ICalc.Code,0,0))/100 else 1 end)/Icalc.PProrata)*max(ICalc.FacProrata)*max(ICalc.Share)/100*max(ICalc.RShare)/100    
		End
	  else    
	   sum(ICalc.PCTShare/100*ICalc.Gross*(Case When ICalc.OnGrossAfterCommF=1 Then (100-dbo.Premium_Facultative_Commission(ICalc.ANO, ICalc.Code,0,0))/100 else 1 end)/Icalc.PProrata)*max(ICalc.FacProrata)    
	  end  
	 else    
	  case When Max(ICalc.FLPCT)=0 Then    
		   Case 
		   When Max(ICalc.Unit)='F' Then
			max(ICalc.NetRate)*max(ICalc.FacProrata)
		   When Max(ICalc.Unit)='M' Then
		    sum(ICalc.PCTShare/100*Icalc.TSI*ICalc.PCTADJ/100)*max(ICalc.NetRate)/1000*max(ICalc.FacProrata)*max(ICalc.Share)/100*max(ICalc.RShare)/100       
		   else
			sum(ICalc.PCTShare/100*Icalc.TSI*ICalc.PCTADJ/100)*max(ICalc.NetRate)/100*max(ICalc.FacProrata)*max(ICalc.Share)/100*max(ICalc.RShare)/100       
		   end
	  else    
		   Case 
		   When Max(ICalc.Unit)='F' Then
			max(ICalc.NetRate)*max(ICalc.FacProrata)       
		   When Max(ICalc.Unit)='M' Then
		    sum(ICalc.PCTShare/100*Icalc.TSI*ICalc.PCTADJ/100)*max(ICalc.NetRate)/1000*max(ICalc.FacProrata)       
		   else
			sum(ICalc.PCTShare/100*Icalc.TSI*ICalc.PCTADJ/100)*max(ICalc.NetRate)/100*max(ICalc.FacProrata)       
		   end  
	  end    
	 end,     
	Calculation=      
	Case     
	 When max(ICalc.NetRate)=0 Then    
	  case When Max(ICalc.FLPCT)=0 Then    
		Case When Max(ICalc.Unit)='F' Then
			   convert(varchar(25), cast(sum(ICalc.PCTShare/100*ICalc.Gross*(Case When ICalc.OnGrossAfterCommF=1 Then (100-dbo.Premium_Facultative_Commission(ICalc.ANO, ICalc.Code,0,0))/100 else 1 end)/ICalc.PProrata) as Money),1) + Case When max(ICalc.FacProrata_Calculation)='' or Max(ICalc.FacProrata)=1 Then '' Else ' x ' + max(ICalc.FacProrata_Calculation) End
		Else
			convert(varchar(25), cast(sum(ICalc.PCTShare/100*ICalc.Gross*(Case When ICalc.OnGrossAfterCommF=1 Then (100-dbo.Premium_Facultative_Commission(ICalc.ANO, ICalc.Code,0,0))/100 else 1 end)/ICalc.PProrata) as Money),1) + Case When max(ICalc.FacProrata_Calculation)='' or Max(ICalc.FacProrata)=1 Then '' Else ' x ' + max(ICalc.FacProrata_Calculation) End + ' x '+convert(varchar(25), Max(ICalc.Share),0)+'%' + ' x '+convert(varchar(25), Max(ICalc.RShare),0)+'%'    
		End
	  else    
	   convert(varchar(25), cast(sum(ICalc.PCTShare/100*ICalc.Gross*(Case When ICalc.OnGrossAfterCommF=1 Then (100-dbo.Premium_Facultative_Commission(ICalc.ANO, ICalc.Code,0,0))/100 else 1 end)/ICalc.PProrata) as Money),1) + Case When max(ICalc.FacProrata_Calculation)='' or Max(ICalc.FacProrata)=1 Then '' Else ' x ' + max(ICalc.FacProrata_Calculation) End    
	  end    
	 else    
	  Case When Max(ICalc.FacProrata*ICalc.NetRateProrata)=1 then    

	   case When Max(ICalc.FLPCT)=0 Then    
			case 
			When Max(ICalc.Unit)='F' Then
				convert(varchar(25), Cast(max(ICalc.NetRate/ICalc.NetRateProrata) as Money),1) + Case When max(ICalc.FacProrata_Calculation)='' or Max(ICalc.FacProrata*ICalc.NetRateProrata)=1 Then '' Else ' x ' + max(ICalc.FacProrata_Calculation) End 
			When Max(ICalc.Unit)='M' Then
				convert(varchar(25), cast(sum(ICalc.PCTShare/100*Icalc.TSI*ICalc.PCTADJ/100) as Money),1) + ' x '+convert(varchar(25), cast(max(ICalc.NetRate/ICalc.NetRateProrata) as Money),2)+'‰' + Case When max(ICalc.FacProrata_Calculation)='' or Max(ICalc.FacProrata*ICalc.NetRateProrata)=1 Then '' Else ' x ' + max(ICalc.FacProrata_Calculation) End + ' x '+convert(varchar(25), Max(ICalc.Share),0)+'%' + ' x '+convert(varchar(25), Max(ICalc.RShare),0)+'%'        
			else
				convert(varchar(25), cast(sum(ICalc.PCTShare/100*Icalc.TSI*ICalc.PCTADJ/100) as Money),1) + ' x '+convert(varchar(25), cast(max(ICalc.NetRate/ICalc.NetRateProrata) as Money),2)+'%' + Case When max(ICalc.FacProrata_Calculation)='' or Max(ICalc.FacProrata*ICalc.NetRateProrata)=1 Then '' Else ' x ' + max(ICalc.FacProrata_Calculation) End + ' x '+convert(varchar(25), Max(ICalc.Share),0)+'%' + ' x '+convert(varchar(25), Max(ICalc.RShare),0)+'%'       
			end
	   else 
			Case 
			When Max(ICalc.Unit)='F' Then		   
				convert(varchar(25), Cast(max(ICalc.NetRate/ICalc.NetRateProrata) as Money),1) + Case When max(ICalc.FacProrata_Calculation)='' or Max(ICalc.FacProrata*ICalc.NetRateProrata)=1 Then '' Else ' x ' + max(ICalc.FacProrata_Calculation) End     
			When Max(ICalc.Unit)='M' Then		   
				convert(varchar(25), cast(sum(ICalc.PCTShare/100*Icalc.TSI*ICalc.PCTADJ/100) as Money),1) + ' x '+convert(varchar(25), cast(max(ICalc.NetRate/ICalc.NetRateProrata) as Money),2)+'‰' + Case When max(ICalc.FacProrata_Calculation)='' or Max(ICalc.FacProrata*ICalc.NetRateProrata)=1 Then '' Else ' x ' + max(ICalc.FacProrata_Calculation) End 		
			else
				convert(varchar(25), cast(sum(ICalc.PCTShare/100*Icalc.TSI*ICalc.PCTADJ/100) as Money),1) + ' x '+convert(varchar(25), cast(max(ICalc.NetRate/ICalc.NetRateProrata) as Money),2)+'%' + Case When max(ICalc.FacProrata_Calculation)='' or Max(ICalc.FacProrata*ICalc.NetRateProrata)=1 Then '' Else ' x ' + max(ICalc.FacProrata_Calculation) End 		
			end
	   end    
	  
	  else    
	   case When Max(ICalc.FLPCT)=0 Then    
			Case 
			When Max(ICalc.Unit)='F' Then
				convert(varchar(25), max(ICalc.NetRate),1) + Case When max(ICalc.FacProrata_Calculation)='' or Max(ICalc.FacProrata)=1 Then '' Else ' x ' + max(ICalc.FacProrata_Calculation) End
			When Max(ICalc.Unit)='M' Then
				convert(varchar(25), cast(sum(ICalc.PCTShare/100*Icalc.TSI*ICalc.PCTADJ/100) as Money),1) + ' x '+convert(varchar(25), max(ICalc.NetRate),0)+'‰' + Case When max(ICalc.FacProrata_Calculation)='' or Max(ICalc.FacProrata)=1 Then '' Else ' x ' + max(ICalc.FacProrata_Calculation) End + ' x '+convert(varchar(25), Max(ICalc.Share),0)+'%' + ' x '+convert(varchar(25), Max(ICalc.RShare),0)+'%'       		
			else
				convert(varchar(25), cast(sum(ICalc.PCTShare/100*Icalc.TSI*ICalc.PCTADJ/100) as Money),1) + ' x '+convert(varchar(25), max(ICalc.NetRate),0)+'%' + Case When max(ICalc.FacProrata_Calculation)='' or Max(ICalc.FacProrata)=1 Then '' Else ' x ' + max(ICalc.FacProrata_Calculation) End + ' x '+convert(varchar(25), Max(ICalc.Share),0)+'%' + ' x '+convert(varchar(25), Max(ICalc.RShare),0)+'%'       		
			end
	   else    
			Case 
			When Max(ICalc.Unit)='F' then
				convert(varchar(25), max(ICalc.NetRate),1) + Case When max(ICalc.FacProrata_Calculation)='' or Max(ICalc.FacProrata)=1 Then '' Else ' x ' + max(ICalc.FacProrata_Calculation) End     
			When Max(ICalc.Unit)='M' then
				convert(varchar(25), cast(sum(ICalc.PCTShare/100*Icalc.TSI*ICalc.PCTADJ/100) as Money),1) + ' x '+convert(varchar(25), max(ICalc.NetRate),0)+'‰' + Case When max(ICalc.FacProrata_Calculation)='' or Max(ICalc.FacProrata)=1 Then '' Else ' x ' + max(ICalc.FacProrata_Calculation) End     		
			else
				convert(varchar(25), cast(sum(ICalc.PCTShare/100*Icalc.TSI*ICalc.PCTADJ/100) as Money),1) + ' x '+convert(varchar(25), max(ICalc.NetRate),0)+'%' + Case When max(ICalc.FacProrata_Calculation)='' or Max(ICalc.FacProrata)=1 Then '' Else ' x ' + max(ICalc.FacProrata_Calculation) End     		
			end
	   end      
	  end    
	 
	 End    
	From      
	(
	Select ICalc.ANO, ICalc.INO, ICalc.Currency, ICalc.Code, ICalc.Sdate, ICalc.Edate, ICalc.PCTAdj,    
	Max(FPartDet.Code) as FCode,
		Max(
		Case 
		When D.SProrata='' then D.FacProrata_Calculation 
		else 
			Case 
			When D.FacProrata_Calculation<>'' then D.FacProrata_Calculation+' x' +D.SProrata 
			else D.SProrata 
			End 
		End) as FacProrata_calculation,    
	Max(D.FacProrata*D.Prorata) as FacProrata,     
	Max(Case When PCALC.Description<>'' and PCALC.Description<>'Minimum Premium' then ICALC.GROSS*PCALC.GROSS/PCALC.OGROSS else ICALC.GROSS*D.GROSS/D.OGROSS end*(Case When RArrDet.Limit<>0 Then RArrDet.Limit/RArrHeader.TAmount Else 1 end)) AS GROSS,         
 
	Max(ICalc.Prorata) as PProrata,     
	Max(PCalc.Ourshare/PCalc.TSI*100) as PCTShare,     
	Max(ICalc.SRate) as SRate,     
	Max((Case When RArrDet.Limit<>0 Then RArrDet.Limit*RArrDet.RateL/RArrHeader.TAmount else 1 end)*ICalc.TSI) as TSI,     
	Max(Case When RArrDet.PCalc='P' or datediff(month,RArrDet.SDate, (Case When Acceptance.EXCLUSIVEF=0 and Acceptance.STime<Acceptance.ETime Then dateadd(day,1,RArrDet.EDate) else RArrDet.EDate end))=0 or Cover.Voyage=1 Then 1 else 12/cast(datediff(month,RArrDet.SDate, (Case When Acceptance.EXCLUSIVEF=0 and Acceptance.STime<Acceptance.ETime Then dateadd(day,1,RArrDet.EDate) else RArrDet.EDate end)) as Float) end) as NetRateProrata,    
	Max(FPartDet.NetRate*Case When RArrDet.PCalc='P' or datediff(month,RArrDet.SDate, (Case When Acceptance.EXCLUSIVEF=0 and Acceptance.STime<Acceptance.ETime Then dateadd(day,1,RArrDet.EDate) else RArrDet.EDate end))=0 or Cover.Voyage=1 Then 1 else 12/cast(datediff(month,RArrDet.SDate, (Case When Acceptance.EXCLUSIVEF=0 and Acceptance.STime<Acceptance.ETime Then dateadd(day,1,RArrDet.EDate) else RArrDet.EDate end)) as Float) end) as NetRate,    
	Max(FPartDet.Unit) as Unit,
	Max(RArrDet.Share) as Share,    
	Max(FPart.Share) as RShare,    
	Max(RArrDet.FLPCT) as FLPCT,    
	Max(ICalc.sProrata) as sProrata,  
	Max(Cast(RArrDet.OnGrossAfterCommF as Integer)) as OnGrossAfterCommF  
	from @Acceptance Acceptance
	Inner Join RArrheader on (RArrHeader.ANO=Acceptance.ANO)
	Inner Join ICalc on (ICalc.ANO=Acceptance.ANO and ICalc.Rate<>0)
	Inner Join PCalc on (PCalc.ANO=ICalc.ANO and PCalc.Currency=ICalc.Currency)
	Inner Join DISPLAY_FACULTATIVE_PRORATA_CALCULATION(@P_ANO, @P_FID) D on (D.ANO=ICalc.ANO and D.Currency=ICalc.Currency and D.SDate=ICalc.Sdate and D.EDate=ICalc.EDate and D.TOR=ICalc.TOR    )
	Inner Join @RARRDET RArrDet on (RArrDet.AType<>'C' and RArrDet.FullCoverF=0 and RArrDet.ANO=D.ANO and RArrDet.FID=@P_FID)
	Inner Join FPart on (FPart.ANO=RArrDet.ANO and FPart.FID=RArrdet.FID and (FPart.Currency='' or FPart.Currency=ICalc.Currency))
	Inner Join FPartDet on (FPartDet.ANO=RArrDet.ANO and FPartDet.FID=RArrdet.FID)
	Inner Join RateCov on (RateCov.Code=FPartDet.Code and RateCov.TOR=ICalc.TOR)
	Inner Join Cover on (Cover.CNO=Acceptance.CNO)
	Where Acceptance.ANO=@P_ANO 
	Group By ICalc.ANO, ICalc.INO, ICalc.Currency, ICalc.Code, ICalc.SDate, ICalc.EDate, ICalc.PCTAdj 
	) ICalc    
	Group By ICalc.ANO, ICalc.Currency, ICalc.Code, ICalc.FCode, ICalc.SDate, ICalc.EDate, ICalc.SRate, ICalc.sProrata, ICalc.PCTadj      
END

--4 Refund/Endorsement Detail    
IF @P_PANO<>-1 AND @P_FullcoverF=0    
BEGIN
	Insert into @PCALC
	Select ICalc.ANO, ICalc.Currency, ICalc.Code, ICalc.FCode, ICalc.SDate, ICalc.EDate,   
	Gross=-    
	Case     
	 When max(ICalc.NetRate)=0 then    
	  case When Max(ICalc.FLPCT)=0 Then    
		Case When Max(ICalc.Unit)='F' Then
			sum(ICalc.PCTShare/100*ICalc.Gross*(Case When ICalc.OnGrossAfterCommF=1 Then (100-dbo.Premium_Facultative_Commission(ICalc.ANO, ICalc.Code,0,0))/100 else 1 end)/Icalc.PProrata)*max(ICalc.FacProrata)
		Else
			sum(ICalc.PCTShare/100*ICalc.Gross*(Case When ICalc.OnGrossAfterCommF=1 Then (100-dbo.Premium_Facultative_Commission(ICalc.ANO, ICalc.Code,0,0))/100 else 1 end)/Icalc.PProrata)*max(ICalc.FacProrata)*max(ICalc.Share)/100*max(ICalc.RShare)/100    
		End
	  else    
		sum(ICalc.PCTShare/100*ICalc.Gross*(Case When ICalc.OnGrossAfterCommF=1 Then (100-dbo.Premium_Facultative_Commission(ICalc.ANO, ICalc.Code,0,0))/100 else 1 end)/Icalc.PProrata)*max(ICalc.FacProrata)    
	  end    
	 else    
	  case When Max(ICalc.FLPCT)=0 Then    
		   Case 
		   When Max(ICalc.Unit)='F' Then
			max(ICalc.NetRate)*max(ICalc.FacProrata)
		   When Max(ICalc.Unit)='M' Then
		    sum(ICalc.PCTShare/100*Icalc.TSI*ICalc.PCTADJ/100)*max(ICalc.NetRate)/1000*max(ICalc.FacProrata)*max(ICalc.Share)/100*max(ICalc.RShare)/100       
		   else
			sum(ICalc.PCTShare/100*Icalc.TSI*ICalc.PCTADJ/100)*max(ICalc.NetRate)/100*max(ICalc.FacProrata)*max(ICalc.Share)/100*max(ICalc.RShare)/100       
		   end
	  else    
		   Case 
		   When Max(ICalc.Unit)='F' Then
			max(ICalc.NetRate)*max(ICalc.FacProrata)       
		   When Max(ICalc.Unit)='M' Then
		    sum(ICalc.PCTShare/100*Icalc.TSI*ICalc.PCTADJ/100)*max(ICalc.NetRate)/1000*max(ICalc.FacProrata)       
		   else
			sum(ICalc.PCTShare/100*Icalc.TSI*ICalc.PCTADJ/100)*max(ICalc.NetRate)/100*max(ICalc.FacProrata)       
		   end  
	  end  
	 end,

	Calculation=      
	Case     
	 When max(ICalc.NetRate)=0 Then    
	  case When Max(ICalc.FLPCT)=0 Then    
		Case When Max(ICalc.Unit)='F' Then
			'- ' + convert(varchar(25), cast(sum(ICalc.PCTShare/100*ICalc.Gross*(Case When ICalc.OnGrossAfterCommF=1 Then (100-dbo.Premium_Facultative_Commission(ICalc.ANO, ICalc.Code,0,0))/100 else 1 end)/ICalc.PProrata) as Money),1) + Case When max(ICalc.FacProrata_Calculation)='' or Max(ICalc.FacProrata)=1 Then '' Else ' x ' + max(ICalc.FacProrata_Calculation) End
		Else
			'- ' + convert(varchar(25), cast(sum(ICalc.PCTShare/100*ICalc.Gross*(Case When ICalc.OnGrossAfterCommF=1 Then (100-dbo.Premium_Facultative_Commission(ICalc.ANO, ICalc.Code,0,0))/100 else 1 end)/ICalc.PProrata) as Money),1) + Case When max(ICalc.FacProrata_Calculation)='' or Max(ICalc.FacProrata)=1 Then '' Else ' x ' + max(ICalc.FacProrata_Calculation) End + ' x '+convert(varchar(25), Max(ICalc.Share),0)+'%' + ' x '+convert(varchar(25), Max(ICalc.RShare),0)+'%'    
		End
	  else    
	   '- ' + convert(varchar(25), cast(sum(ICalc.PCTShare/100*ICalc.Gross*(Case When ICalc.OnGrossAfterCommF=1 Then (100-dbo.Premium_Facultative_Commission(ICalc.ANO, ICalc.Code,0,0))/100 else 1 end)/ICalc.PProrata) as Money),1) + Case When max(ICalc.FacProrata_Calculation)='' or Max(ICalc.FacProrata)=1 Then '' Else ' x ' + max(ICalc.FacProrata_Calculation) End    
	  end    
	 else    
	  Case When Max(ICalc.FacProrata*ICalc.NetRateProrata)=1 then    
	   case When Max(ICalc.FLPCT)=0 Then    
			case 
			When Max(ICalc.Unit)='F' Then
				'- ' + convert(varchar(25), Cast(max(ICalc.NetRate/ICalc.NetRateProrata) as Money),1) + Case When max(ICalc.FacProrata_Calculation)='' or Max(ICalc.FacProrata*ICalc.NetRateProrata)=1 Then '' Else ' x ' + max(ICalc.FacProrata_Calculation) End
			When Max(ICalc.Unit)='M' Then
				'- ' + convert(varchar(25), cast(sum(ICalc.PCTShare/100*Icalc.TSI*ICalc.PCTADJ/100) as Money),1) + ' x '+convert(varchar(25), cast(max(ICalc.NetRate/ICalc.NetRateProrata) as Money),2)+'‰' + Case When max(ICalc.FacProrata_Calculation)='' or Max(ICalc.FacProrata*ICalc.NetRateProrata)=1 Then '' Else ' x ' + max(ICalc.FacProrata_Calculation) End + ' x '+convert(varchar(25), Max(ICalc.Share),0)+'%' + ' x '+convert(varchar(25), Max(ICalc.RShare),0)+'%'        
			else
				'- ' + convert(varchar(25), cast(sum(ICalc.PCTShare/100*Icalc.TSI*ICalc.PCTADJ/100) as Money),1) + ' x '+convert(varchar(25), cast(max(ICalc.NetRate/ICalc.NetRateProrata) as Money),2)+'%' + Case When max(ICalc.FacProrata_Calculation)='' or Max(ICalc.FacProrata*ICalc.NetRateProrata)=1 Then '' Else ' x ' + max(ICalc.FacProrata_Calculation) End + ' x '+convert(varchar(25), Max(ICalc.Share),0)+'%' + ' x '+convert(varchar(25), Max(ICalc.RShare),0)+'%'       
			end
	   else 
			Case 
			When Max(ICalc.Unit)='F' Then		   
				'- ' + convert(varchar(25), Cast(max(ICalc.NetRate/ICalc.NetRateProrata) as Money),1) + Case When max(ICalc.FacProrata_Calculation)='' or Max(ICalc.FacProrata*ICalc.NetRateProrata)=1 Then '' Else ' x ' + max(ICalc.FacProrata_Calculation) End     
			When Max(ICalc.Unit)='M' Then		   
				'- ' + convert(varchar(25), cast(sum(ICalc.PCTShare/100*Icalc.TSI*ICalc.PCTADJ/100) as Money),1) + ' x '+convert(varchar(25), cast(max(ICalc.NetRate/ICalc.NetRateProrata) as Money),2)+'‰' + Case When max(ICalc.FacProrata_Calculation)='' or Max(ICalc.FacProrata*ICalc.NetRateProrata)=1 Then '' Else ' x ' + max(ICalc.FacProrata_Calculation) End 		
			else
				'- ' + convert(varchar(25), cast(sum(ICalc.PCTShare/100*Icalc.TSI*ICalc.PCTADJ/100) as Money),1) + ' x '+convert(varchar(25), cast(max(ICalc.NetRate/ICalc.NetRateProrata) as Money),2)+'%' + Case When max(ICalc.FacProrata_Calculation)='' or Max(ICalc.FacProrata*ICalc.NetRateProrata)=1 Then '' Else ' x ' + max(ICalc.FacProrata_Calculation) End 		
			end
	   end    
	  else    
	   case When Max(ICalc.FLPCT)=0 Then    
			Case 
			When Max(ICalc.Unit)='F' Then
				'- ' + convert(varchar(25), max(ICalc.NetRate),1) + Case When max(ICalc.FacProrata_Calculation)='' or Max(ICalc.FacProrata)=1 Then '' Else ' x ' + max(ICalc.FacProrata_Calculation) End
			When Max(ICalc.Unit)='M' Then
				'- ' + convert(varchar(25), cast(sum(ICalc.PCTShare/100*Icalc.TSI*ICalc.PCTADJ/100) as Money),1) + ' x '+convert(varchar(25), max(ICalc.NetRate),0)+'‰' + Case When max(ICalc.FacProrata_Calculation)='' or Max(ICalc.FacProrata)=1 Then '' Else ' x ' + max(ICalc.FacProrata_Calculation) End + ' x '+convert(varchar(25), Max(ICalc.Share),0)+'%' + ' x '+convert(varchar(25), Max(ICalc.RShare),0)+'%'       		
			else
				'- ' + convert(varchar(25), cast(sum(ICalc.PCTShare/100*Icalc.TSI*ICalc.PCTADJ/100) as Money),1) + ' x '+convert(varchar(25), max(ICalc.NetRate),0)+'%' + Case When max(ICalc.FacProrata_Calculation)='' or Max(ICalc.FacProrata)=1 Then '' Else ' x ' + max(ICalc.FacProrata_Calculation) End + ' x '+convert(varchar(25), Max(ICalc.Share),0)+'%' + ' x '+convert(varchar(25), Max(ICalc.RShare),0)+'%'       		
			end
	   else    
			Case 
			When Max(ICalc.Unit)='F' then
				'- ' + convert(varchar(25), max(ICalc.NetRate),1) + Case When max(ICalc.FacProrata_Calculation)='' or Max(ICalc.FacProrata)=1 Then '' Else ' x ' + max(ICalc.FacProrata_Calculation) End     
			When Max(ICalc.Unit)='M' then
				'- ' + convert(varchar(25), cast(sum(ICalc.PCTShare/100*Icalc.TSI*ICalc.PCTADJ/100) as Money),1) + ' x '+convert(varchar(25), max(ICalc.NetRate),0)+'‰' + Case When max(ICalc.FacProrata_Calculation)='' or Max(ICalc.FacProrata)=1 Then '' Else ' x ' + max(ICalc.FacProrata_Calculation) End     		
			else
				'- ' + convert(varchar(25), cast(sum(ICalc.PCTShare/100*Icalc.TSI*ICalc.PCTADJ/100) as Money),1) + ' x '+convert(varchar(25), max(ICalc.NetRate),0)+'%' + Case When max(ICalc.FacProrata_Calculation)='' or Max(ICalc.FacProrata)=1 Then '' Else ' x ' + max(ICalc.FacProrata_Calculation) End     		
			end
	   end      
	  end     
	 End    

	From      
	(
	Select ICalc.ANO, ICalc.INO, ICalc.Currency, ICalc.Code, ICalc.Sdate, ICalc.Edate, ICalc.PCTAdj,    
	Max(FPartDet.Code) as FCode,
		Max(
		Case 
		When D.SProrata='' then D.FacProrata_Calculation 
		else 
			Case 
			When D.FacProrata_Calculation<>'' then D.FacProrata_Calculation+' x' +D.SProrata 
			else D.SProrata 
			End 
		End) as FacProrata_calculation,    
	Max(D.FacProrata*D.Prorata) as FacProrata,     
	Max(Case When PCALC.Description<>'' and PCALC.Description<>'Minimum Premium' then ICALC.GROSS*PCALC.GROSS/PCALC.OGROSS else ICALC.GROSS*D.GROSS/D.OGROSS end*(Case When RArrDet.Limit<>0 Then RArrDet.Limit/RArrHeader.TAmount Else 1 end)) AS GROSS,         

	Max(ICalc.Prorata) as PProrata,     
	Max(PCalc.Ourshare/PCalc.TSI*100) as PCTShare,     
	Max(ICalc.SRate) as SRate,     
	Max((Case When RArrDet.Limit<>0 Then RArrDet.Limit*RArrDet.RateL/RArrHeader.TAmount else 1 end)*ICalc.TSI) as TSI,     
	Max(Case When RArrDet.PCalc='P' or datediff(month,RArrDet.SDate, (Case When Acceptance.EXCLUSIVEF=0 and Acceptance.STime<Acceptance.ETime Then dateadd(day,1,RArrDet.EDate) else RArrDet.EDate end))=0 or Cover.Voyage=1 Then 1 else 12/cast(datediff(month,RArrDet.SDate, (Case When Acceptance.EXCLUSIVEF=0 and Acceptance.STime<Acceptance.ETime Then dateadd(day,1,RArrDet.EDate) else RArrDet.EDate end)) as Float) end) as NetRateProrata,    
	Max(FPartDet.NetRate*Case When RArrDet.PCalc='P' or datediff(month,RArrDet.SDate, (Case When Acceptance.EXCLUSIVEF=0 and Acceptance.STime<Acceptance.ETime Then dateadd(day,1,RArrDet.EDate) else RArrDet.EDate end))=0 or Cover.Voyage=1 Then 1 else 12/cast(datediff(month,RArrDet.SDate, (Case When Acceptance.EXCLUSIVEF=0 and Acceptance.STime<Acceptance.ETime Then dateadd(day,1,RArrDet.EDate) else RArrDet.EDate end)) as Float) end) as NetRate,    
	Max(FPartDet.Unit) as Unit,
	Max(RArrDet.Share) as Share,    
	Max(FPart.Share) as RShare,    
	Max(RArrDet.FLPCT) as FLPCT,    
	Max(pAcceptance.AType) as AType,
	Max(pAcceptance.EMethod) as EMethod,
	Max(ICalc.sProrata) as sProrata,  
	Max(Cast(RArrDet.OnGrossAfterCommF as Integer)) as OnGrossAfterCommF  
	from @Acceptance pAcceptance
	Inner Join Acceptance on (Acceptance.ANO=pAcceptance.pANO)
	Inner Join RArrheader on (RArrHeader.ANO=Acceptance.ANO)
	Inner Join ICalc on (ICalc.ANO=Acceptance.ANO and ICalc.Rate<>0)
	Inner Join PCalc on (PCalc.ANO=ICalc.ANO and PCalc.Currency=ICalc.Currency)
	Inner Join DISPLAY_FACULTATIVE_PRORATA_CALCULATION(@P_ANO, @P_FID) D on (D.ANO=ICalc.ANO and D.Currency=ICalc.Currency and D.SDate=ICalc.Sdate and D.EDate=ICalc.EDate and D.TOR=ICalc.TOR)
	Inner Join RArrDet on (RArrDet.AType<>'C' and RArrDet.Status in ('A','R') and RArrDet.FullCoverF=0 and RArrDet.ANO=D.ANO and RArrDet.FID=@P_FID)
	Inner Join FPart on (FPart.ANO=RArrDet.ANO and FPart.FID=RArrdet.FID and (FPart.Currency='' or FPart.Currency=ICalc.Currency))
	Inner Join FPartDet on (FPartDet.ANO=RArrDet.ANO and FPartDet.FID=RArrdet.FID)
	Inner Join RateCov on (RateCov.Code=FPartDet.Code and RateCov.TOR=ICalc.TOR)
	Inner Join @RARRDET nRArrDet on (nRArrDet.ANO=pAcceptance.ANO and nRArrDet.FID=@P_FID)
	Inner Join Cover on (Cover.CNO=Acceptance.CNO)
	Where pAcceptance.ANO=@P_ANO 
	Group By ICalc.ANO, ICalc.INO, ICalc.Currency, ICalc.Code, ICalc.SDate, ICalc.EDate, ICalc.PCTAdj 
	) ICalc
	Group By ICalc.ANO, ICalc.Currency, ICalc.Code, ICalc.FCode, ICalc.SDate, ICalc.EDate, ICalc.SRate, ICalc.sProrata, ICalc.PCTadj        
END
    
RETURN
END

GO


insert into PatchVersioning
select '1569 Update Script - Patch 2026 (15).sql',GETDATE()
go	
  
Declare @PrevScript varchar(100)
Declare @CurrScript varchar(100)

Select @PrevScript=''
Select @CurrSCript='1569 Update Script - Patch 2026 (15).sql'


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

GO 
