-- Update 24 May 2016
--Cleansing Script
Update A2 Set PolicyNo=A1.PolicyNo
from Acceptance A1, Acceptance A2, Cover C
Where C.CNO=A1.CNO and A1.ANO=A1.LANO and A2.LANO<>A2.ANO and A2.LANO=A1.ANO and C.OpenFlag=1 and A1.PolicyNo<>''
and A1.PolicyNo<>A2.PolicyNo
go

--Penambahan Profile untuk Fee Duty
--IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'Fee_ProfileID' AND Object_ID = Object_ID(N'sysbatchoriginalup')) BEGIN Alter table SysBatchOriginalup add  Fee_ProfileID varchar(10) end
--IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'Duty_ProfileID' AND Object_ID = Object_ID(N'sysbatchoriginalup')) BEGIN Alter table SysBatchOriginalup add  Duty_ProfileID varchar(10) end
--IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'OP_ProfileID1' AND Object_ID = Object_ID(N'sysbatchoriginalup')) BEGIN Alter table SysBatchOriginalup add  OP_ProfileID1 varchar(10) end
--IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'OP_ID1' AND Object_ID = Object_ID(N'sysbatchoriginalup')) BEGIN Alter table SysBatchOriginalup add  OP_ID1 varchar(10) end
--IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'OP_REMARK1' AND Object_ID = Object_ID(N'sysbatchoriginalup')) BEGIN Alter table SysBatchOriginalup add  OP_REMARK1 varchar(50) end
--IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'OP_CURRENCY1' AND Object_ID = Object_ID(N'sysbatchoriginalup')) BEGIN Alter table SysBatchOriginalup add  OP_CURRENCY1 varchar(5) end
--IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'OP_AMOUNT1' AND Object_ID = Object_ID(N'sysbatchoriginalup')) BEGIN Alter table SysBatchOriginalup add  OP_AMOUNT1 float end
--IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'OP_ProfileID2' AND Object_ID = Object_ID(N'sysbatchoriginalup')) BEGIN Alter table SysBatchOriginalup add  OP_ProfileID2 varchar(10) end
--IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'OP_ID2' AND Object_ID = Object_ID(N'sysbatchoriginalup')) BEGIN Alter table SysBatchOriginalup add  OP_ID2 varchar(10) end
--IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'OP_REMARK2' AND Object_ID = Object_ID(N'sysbatchoriginalup')) BEGIN Alter table SysBatchOriginalup add  OP_REMARK2 varchar(50) end
--IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'OP_CURRENCY2' AND Object_ID = Object_ID(N'sysbatchoriginalup')) BEGIN Alter table SysBatchOriginalup add  OP_CURRENCY2 varchar(5) end
--IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'OP_AMOUNT2' AND Object_ID = Object_ID(N'sysbatchoriginalup')) BEGIN Alter table SysBatchOriginalup add  OP_AMOUNT2 float end

--IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'Fee_ProfileID' AND Object_ID = Object_ID(N'sysbatchup')) BEGIN Alter table sysbatchup add  Fee_ProfileID varchar(10) end
--IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'Duty_ProfileID' AND Object_ID = Object_ID(N'sysbatchup')) BEGIN Alter table sysbatchup add  Duty_ProfileID varchar(10) end
--IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'OP_ProfileID1' AND Object_ID = Object_ID(N'sysbatchup')) BEGIN Alter table sysbatchup add  OP_ProfileID1 varchar(10) end
--IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'OP_ID1' AND Object_ID = Object_ID(N'sysbatchup')) BEGIN Alter table sysbatchup add  OP_ID1 varchar(10) end
--IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'OP_REMARK1' AND Object_ID = Object_ID(N'sysbatchup')) BEGIN Alter table sysbatchup add  OP_REMARK1 varchar(50) end
--IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'OP_CURRENCY1' AND Object_ID = Object_ID(N'sysbatchup')) BEGIN Alter table sysbatchup add  OP_CURRENCY1 varchar(5) end
--IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'OP_AMOUNT1' AND Object_ID = Object_ID(N'sysbatchup')) BEGIN Alter table sysbatchup add  OP_AMOUNT1 float end
--IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'OP_ProfileID2' AND Object_ID = Object_ID(N'sysbatchup')) BEGIN Alter table sysbatchup add  OP_ProfileID2 varchar(10) end
--IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'OP_ID2' AND Object_ID = Object_ID(N'sysbatchup')) BEGIN Alter table sysbatchup add  OP_ID2 varchar(10) end
--IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'OP_REMARK2' AND Object_ID = Object_ID(N'sysbatchup')) BEGIN Alter table sysbatchup add  OP_REMARK2 varchar(50) end
--IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'OP_CURRENCY2' AND Object_ID = Object_ID(N'sysbatchup')) BEGIN Alter table sysbatchup add  OP_CURRENCY2 varchar(5) end
--IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'OP_AMOUNT2' AND Object_ID = Object_ID(N'sysbatchup')) BEGIN Alter table sysbatchup add  OP_AMOUNT2 float end
--go


--Update 25 May 2016
IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'AnnualTreatyF' AND Object_ID = Object_ID(N'ACCEPTANCE'))
BEGIN
ALTER TABLE dbo.ACCEPTANCE ADD	AnnualTreatyF bit NULL
DECLARE @v sql_variant 
SET @v = N'Annual Treaty Cession Flag (0 : No, 1 : Yes)'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'ACCEPTANCE', N'COLUMN', N'AnnualTreatyF'
END
GO

Update Acceptance Set AnnualTreatyF=1  
from Acceptance, Cover,RArrHeader, TOC 
Where Cover.CNO=Acceptance.CNO and TOC.TOC=Cover.TOC and TOC.AnnualTreatyF=1 and RArrHeader.NRDate<Acceptance.EDate
go

-- Update 26 May 2016
if exists (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[DISPLAY_PRORATA_CALCULATION]') AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) ) BEGIN DROP FUNCTION [dbo].[DISPLAY_PRORATA_CALCULATION] END
if exists (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[DISPLAY_FACULTATIVE_BALANCE_PRORATA_CALCULATION]') AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) ) BEGIN DROP FUNCTION [dbo].[DISPLAY_FACULTATIVE_BALANCE_PRORATA_CALCULATION] END
go


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
       

CREATE FUNCTION DISPLAY_FACULTATIVE_BALANCE_PRORATA_CALCULATION(@P_ANO int, @P_FID Varchar(20))          
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

update SysTab Set versionNo='20160527 V1.3.0',versionUpdate=getdate()
go