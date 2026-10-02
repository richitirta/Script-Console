--2 May 2018

DROP FUNCTION fn_Calc_Prorata
GO
CREATE FUNCTION fn_Calc_Prorata(@P_PSDate as smalldatetime, @P_PEDate as smalldatetime, @P_SDate as smalldatetime, @P_EDate as smalldatetime, @P_PPeriod as integer)              
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
	Select @P_Prorata=@P_Prorata / cast(datediff(month,@P_SDate, @P_Edate) as Float)
End
Else 
Begin
	if day(@P_PSDate)=day(@P_PEdate) and day(@P_PSDate)=day(@P_Edate) and day(@P_SDate)=day(@P_Edate) and @P_PPeriod<>1 and datediff(month,@P_Sdate,@P_Edate)<>0
	Begin
		Select @P_Prorata=cast(datediff(month,@P_PSDate, @P_PEDate) as Float)/cast(datediff(month,@P_SDate, @P_EDate) as Float)
	End
	else
	Begin
		Select @P_Prorata=cast(datediff(day,@P_PSDate, @P_PEDate) as Float)/cast(datediff(day,@P_SDate, @P_EDate) as Float)
	End
End

Return @P_Prorata

END  

GO

DROP FUNCTION fn_Calc_SProrata
GO
CREATE FUNCTION fn_Calc_SProrata(@P_PSDate as smalldatetime, @P_PEDate as smalldatetime, @P_SDate as smalldatetime, @P_EDate as smalldatetime, @P_PPeriod as integer)              
RETURNS varchar(255)
AS               
BEGIN              

Declare @P_Prorata as Float
Declare @P_SProrata as varchar(255)

if @P_PPeriod=2
Begin
	Select @P_Prorata=cast(datediff(Month,@P_PSDate, @P_PEDate) as Float)
	if day(@P_PSDate)>day(@P_PEDate)
	Begin
		Select @P_Prorata=@P_Prorata-1
			if @P_Prorata<0
				Select @P_Prorata=0
	End

	if cast(@P_Prorata as integer)<>datediff(month,@P_SDate, @P_Edate)
		Select @P_SProrata= convert(varchar(25),cast(@P_Prorata as integer))+'/'+convert(varchar(25),datediff(month,@P_SDate, @P_Edate))
	else
		Select @P_SProrata=''
End
Else 
Begin
	if day(@P_PSDate)=day(@P_PEdate) and day(@P_PSDate)=day(@P_Edate) and day(@P_SDate)=day(@P_Edate) and @P_PPeriod<>1 and datediff(month,@P_Sdate,@P_Edate)<>0
	Begin
		if datediff(month,@P_PSDate, @P_PEDate)<>datediff(month,@P_SDate, @P_EDate)
			Select @P_SProrata= convert(varchar(25),datediff(month,@P_PSDate, @P_PEDate))+'/'+convert(varchar(25),datediff(month,@P_SDate, @P_EDate))
		else
			Select @P_SProrata=''
	End
	else
	Begin
		if datediff(day,@P_PSDate, @P_PEDate)<>datediff(day,@P_SDate, @P_EDate)
			Select @P_SProrata= convert(varchar(25),datediff(day,@P_PSDate, @P_PEDate))+'/'+convert(varchar(25),datediff(day,@P_SDate, @P_EDate))
		else
			Select @P_SProrata=''
	End
End

Return @P_SProrata

END  


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
   when DateDiff(day, acceptance.pdate, rcalc.SDate)>=0 then 1    
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
  and Acceptance.NoRefundF not in (2,4) and (Acceptance.AType='N' or ((RCover.NoRefundF=0 and Acceptance.NoRefundF in (0,3,5)) or (DateDiff(day, acceptance.pdate, RCalc.SDate) >= 0)))      
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
when DateDiff(day, acceptance.pdate, rcalc.SDate)>=0  and acceptance.pdate between pacceptance.sdate and pacceptance.edate then 1 
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
				dbo.fn_calc_prorata(acceptance.pDate, dateadd(day,1,RCalc.edate), RCalc.Sdate, dateadd(day,1,RCalc.edate), Cover.PPeriod)
			else
				dbo.fn_calc_prorata(acceptance.pDate, RCalc.Edate, RCalc.Sdate, RCalc.EDate, Cover.PPeriod)
			End			 
		Else 
		-- Endorsement Period 
			1 
		End 
	End 
End 
* (Case When pAcceptance.Qty=0 Then 1 else pAcceptance.Qty end) 
* (Case When PCalc.Description='Minimum Premium' Then RCalc.Gross else (Case When PCalc.Gross=0 then 0 else Case When PCalc.OGross=0 Then PCalc.Gross else RCalc.OGross*(case When Pcalc.TSI=0 then 1 else PCalc.Ourshare/PCalc.TSI end) *PCalc.Gross/PCalc.OGross end end) end+RCalc.Reinstatement) as Premium 
from Acceptance inner join Acceptance pAcceptance on (pAcceptance.ANO=Acceptance.pANO) inner Join Cover on (Cover.CNO=pAcceptance.CNO) 
inner join PCalc on (PCalc.ANO=pAcceptance.ANO) inner join RCalc on (RCalc.ANO=PCalc.ANO and RCalc.Currency=PCalc.Currency) 
Left Join RCover on (RCover.ANO=Acceptance.ANO and RCover.Code=RCalc.Code and RCover.SDate=RCalc.SDate) 
Where Acceptance.ANO=@P_ANO and Acceptance.AType<>'A' and Not (Acceptance.AType='C' and Acceptance.EMethod='A') and pAcceptance.AType not in ('A','C') 
and Acceptance.NoRefundF not in (2,4) and ((coalesce(RCover.NoRefundF,0)=0 and Acceptance.NoRefundF in (0,3,5,6)) or (DateDiff(day, acceptance.pdate, rcalc.SDate) >= 0 and acceptance.pdate between pacceptance.sdate and pacceptance.edate)) 
and RCalc.Gross<>0 
) T 
 
Group By ANO, Currency 
 
Union All 
 
select A1.ANO, AccAss.Currency_OC as Currency, 
sum(Case When AccAss.Code='P' then (Case When A1.AType='A' and AccAss.AdjMethod='OVERLIMIT' then -AccAss.CAmount*(Case When A1.CPCT<>0 Then A1.CPCT/100 else 1 end)/(Case When AccAss.PProrata<>0 Then AccAss.PProrata else 1 end) else -AccAss.Amount_OC end)*

(Case When AccAss.Type='DI' then 100/(100-coalesce(Coinsurance.MShare,0)) else 1 end) else 0 end) as Premium 
from Acceptance A1 
inner join Acceptance A2 on (A2.OANO=A1.OANO) 
inner join AccAss on (AccAss.ANO=A2.ANO) 
inner join Profile on (Profile.ID=AccAss.ID) 
inner join MParam on (MParam.Type=Accass.Type) 
Left Join (Select CNO, sum(Share) as MShare from Coinsurance Where PCollectionF=0 Group by CNO) Coinsurance on (Coinsurance.CNO=A2.CNO) 
Left join Acceptance pA2 on (pA2.ANO=A2.PANO) 
Where A1.ANO=@P_ANO 
and ( 
(A2.ANO<=A1.PANO AND A2.ANO<@P_ANO AND A1.PDate<=A2.PDate and A1.PPDate>=A2.PPDate and A1.AType='A' and AccAss.AdjustableF=1 and (AccAss.AdjMethod<>'OVERLIMIT' or AccAss.CAmount<>0) and NOT EXISTS (Select PANO from Acceptance A3 Where A3.PANO=A2.ANO and A3.AStatus<>'C' and A3.AType='A' and A3.ANO<>@P_ANO)) 
or (A2.ANO<@P_ANO AND A1.AType='C' and A1.EMethod='A' and A2.PDate>=A1.PDate and (coalesce(pA2.pDate,A2.PDate)>=A1.PDate or A2.ATYPE='A' or (coalesce(pA2.pDate,A2.PDate)<A1.PDate and AccAss.CAmount<>0))) 
or (A2.ANO=A1.PANO and A2.AType='A' and A1.AType='C')) 
and ((AccAss.Type in ('DI','IC','IR') and AccAss.Code='P') Or (AccAss.Type in ('BB','BA','BO') and AccAss.Code='C') or (AccAss.Type in ('DI','IC','IR') and AccAss.Code='O') or (A1.AType='C' and A1.EMethod='A' and AccAss.Type in ('DI') and AccAss.Code in (
'F','D'))) 
Group By A1.ANO, AccAss.Currency_OC 
) T 
 
Group By ANO, Currency 
) 
 
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
   case when acceptance.cpct<>0 and acceptance.cpct<>100 then convert(varchar(25),Cast(Acceptance.CPCT as float),3)+'%' else '' end        
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
and (Acceptance.AType='N' or (Acceptance.NoRefundF not in (2,4) and RCover.NoRefundF=0 and (Acceptance.NoRefundF in (0,3,5,6) or (DateDiff(day, acceptance.pdate, RCalc.SDate) > 0))))
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
    case when acceptance.cpct<>0 and acceptance.cpct<>100 then convert(varchar(25),Cast(Acceptance.CPCT as float),3)+'%' else '' end        
  Else        
    case        
		When Acceptance.SDate<>Acceptance.PDate or Acceptance.NoRefundF=6 then        
			--Prorata Calculation
			Case When pAcceptance.EXCLUSIVEF=0 and pAcceptance.STime<pAcceptance.ETime and RCalc.EDate=pAcceptance.EDate Then
				dbo.fn_Calc_SProrata(acceptance.pDate, dateadd(day,1,RCalc.edate), RCalc.Sdate, dateadd(day,1,RCalc.edate), Cover.PPeriod)
			else
				dbo.fn_Calc_SProrata(acceptance.pDate, RCalc.Edate, RCalc.Sdate, RCalc.EDate, Cover.PPeriod)
			End
		Else        
		 -- Endorsement Period        
			''        
		End        
	End        
End        
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
				dbo.fn_calc_prorata(acceptance.pDate, dateadd(day,1,RCalc.edate), RCalc.Sdate, dateadd(day,1,RCalc.edate), Cover.PPeriod)
			else
				dbo.fn_calc_prorata(acceptance.pDate, RCalc.Edate, RCalc.Sdate, RCalc.EDate, Cover.PPeriod)
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
and (Acceptance.NoRefundF in (0,3,5,6) or (DateDiff(day, acceptance.pdate, rcalc.SDate) > 0 and acceptance.pdate between pacceptance.sdate and pacceptance.edate))      
and Acceptance.ANO=@P_ANO        
)        
       





go

Alter Table RATECON Add HoldF bit
GO
Alter Table RATECON_M1 Add HoldF bit
GO
Alter Table RATECON_M2 Add HoldF bit 
GO
Alter Table RATECON_M3 Add HoldF bit
GO
Alter Table RATECON_M4 Add HoldF bit
GO
Alter Table RATECON_M5 Add HoldF bit
GO
Alter Table RATECON_M6 Add HoldF bit
GO
Alter Table RATECON_M7 Add HoldF bit
GO
Alter Table RATECON Add HoldMessage varchar(512)
GO
Alter Table RATECON_M1 Add HoldMessage varchar(512)
GO
Alter Table RATECON_M2 Add HoldMessage varchar(512) 
GO
Alter Table RATECON_M3 Add HoldMessage varchar(512)
GO
Alter Table RATECON_M4 Add HoldMessage varchar(512)
GO
Alter Table RATECON_M5 Add HoldMessage varchar(512)
GO
Alter Table RATECON_M6 Add HoldMessage varchar(512)
GO
Alter Table RATECON_M7 Add HoldMessage varchar(512)
GO
Alter Table RATECON_M1 Add MinTSI Float
GO
Alter Table RATECON_M2 Add MinTSI Float 
GO
Alter Table RATECON_M3 Add MinTSI Float
GO
Alter Table RATECON_M4 Add MinTSI Float
GO
Alter Table RATECON_M5 Add MinTSI Float
GO
Alter Table RATECON_M6 Add MinTSI Float
GO
Alter Table RATECON_M7 Add MinTSI Float
GO
Alter Table RATECON_M1 Add MaxTSI Float
GO
Alter Table RATECON_M2 Add MaxTSI Float 
GO
Alter Table RATECON_M3 Add MaxTSI Float
GO
Alter Table RATECON_M4 Add MaxTSI Float
GO
Alter Table RATECON_M5 Add MaxTSI Float
GO
Alter Table RATECON_M6 Add MaxTSI Float
GO
Alter Table RATECON_M7 Add MaxTSI Float
GO
Update RATECON Set HoldF=0 Where HoldF is null
Update RATECON_M1 Set HoldF=0 Where HoldF is null
Update RATECON_M2 Set HoldF=0 Where HoldF is null 
Update RATECON_M3 Set HoldF=0 Where HoldF is null
Update RATECON_M4 Set HoldF=0 Where HoldF is null
Update RATECON_M5 Set HoldF=0 Where HoldF is null
Update RATECON_M6 Set HoldF=0 Where HoldF is null
Update RATECON_M7 Set HoldF=0 Where HoldF is null
Update RATECON_M1 Set MinTSI=0 Where MinTSI is null
Update RATECON_M2 Set MinTSI=0 Where MinTSI is null 
Update RATECON_M3 Set MinTSI=0 Where MinTSI is null
Update RATECON_M4 Set MinTSI=0 Where MinTSI is null
Update RATECON_M5 Set MinTSI=0 Where MinTSI is null
Update RATECON_M6 Set MinTSI=0 Where MinTSI is null
Update RATECON_M7 Set MinTSI=0 Where MinTSI is null
Update RATECON_M1 Set MaxTSI=0 Where MaxTSI is null
Update RATECON_M2 Set MaxTSI=0 Where MaxTSI is null 
Update RATECON_M3 Set MaxTSI=0 Where MaxTSI is null
Update RATECON_M4 Set MaxTSI=0 Where MaxTSI is null
Update RATECON_M5 Set MaxTSI=0 Where MaxTSI is null
Update RATECON_M6 Set MaxTSI=0 Where MaxTSI is null
Update RATECON_M7 Set MaxTSI=0 Where MaxTSI is null


GO

DROP Function Get_RateLoading
GO
CREATE Function Get_RateLoading(@P_ANO as int,@P_Code as varchar(20), @P_PDate as datetime, @P_TSI as Float) 
RETURNS @RateCon TABLE (Loading Float, HoldF bit, HoldMessage varchar(512))   
AS     
BEGIN       
Declare @RateTab Table (
Code varchar(10),
ValueID1 varchar(15),
ValueID2 varchar(15),
ValueID3 varchar(15),
ValueID4 varchar(15),
ValueID5 varchar(15),
ValueID6 varchar(15),
ValueID7 varchar(15),
ValueID8 varchar(15),
ValueID9 varchar(15),
ValueID10 varchar(15),
ValueID11 varchar(15),
ValueID12 varchar(15),
ValueID13 varchar(15),
ValueID14 varchar(15),
ValueID15 varchar(15)
)

insert into @RateTab
SELECT Top 1 RateTab.Code, 
G1.ValueID as ValueID1,
G2.ValueID as ValueID2,
G3.ValueID as ValueID3,
G4.ValueID as ValueID4,
G5.ValueID as ValueID5,
G6.ValueID as ValueID6,
G7.ValueID as ValueID7,
G8.ValueID as ValueID8,
G9.ValueID as ValueID9,
G10.ValueID as ValueID10,
G11.ValueID as ValueID11,
G12.ValueID as ValueID12,
G13.ValueID as ValueID13,
G14.ValueID as ValueID14,
G15.ValueID as ValueID15

From AInfo 
 INNER JOIN RateTab ON (RateTab.Code=@P_Code)     
 Left Join GenHTab H1 on (H1.FLDID=AInfo.FLDID1)
 Left Join GenHTab H2 on (H2.FLDID=AInfo.FLDID2)
 Left Join GenHTab H3 on (H3.FLDID=AInfo.FLDID3)
 Left Join GenHTab H4 on (H4.FLDID=AInfo.FLDID4)
 Left Join GenHTab H5 on (H5.FLDID=AInfo.FLDID5)
 Left Join GenHTab H6 on (H6.FLDID=AInfo.FLDID6)
 Left Join GenHTab H7 on (H7.FLDID=AInfo.FLDID7)
 Left Join GenHTab H8 on (H8.FLDID=AInfo.FLDID8)
 Left Join GenHTab H9 on (H9.FLDID=AInfo.FLDID9)
 Left Join GenHTab H10 on (H10.FLDID=AInfo.FLDID10)
 Left Join GenHTab H11 on (H11.FLDID=AInfo.FLDID11)
 Left Join GenHTab H12 on (H12.FLDID=AInfo.FLDID12)
 Left Join GenHTab H13 on (H13.FLDID=AInfo.FLDID13)
 Left Join GenHTab H14 on (H14.FLDID=AInfo.FLDID14)
 Left Join GenHTab H15 on (H15.FLDID=AInfo.FLDID15)           
 Left Join GenDTab G1 on (G1.FLDID=AInfo.FLDID1 and ((G1.Formula='AGE' and cast(dbo.fn_Age(AInfo.ValueDesc1,@P_PDate, H1.AGEMETHOD) as varchar(10)) Between G1.FLower and G1.FUpper) or (G1.Formula<>'AGE' and G1.ValueID=AInfo.ValueID1)))            
 Left Join GenDTab G2 on (G2.FLDID=AInfo.FLDID2 and ((G2.Formula='AGE' and cast(dbo.fn_Age(AInfo.ValueDesc2,@P_PDate, H2.AGEMETHOD) as varchar(10)) Between G2.FLower and G2.FUpper) or (G2.Formula<>'AGE' and G2.ValueID=AInfo.ValueID2)))             
 Left Join GenDTab G3 on (G3.FLDID=AInfo.FLDID3 and ((G3.Formula='AGE' and cast(dbo.fn_Age(AInfo.ValueDesc3,@P_PDate, H3.AGEMETHOD) as varchar(10)) Between G3.FLower and G3.FUpper) or (G3.Formula<>'AGE' and G3.ValueID=AInfo.ValueID3)))          
 Left Join GenDTab G4 on (G4.FLDID=AInfo.FLDID4 and ((G4.Formula='AGE' and cast(dbo.fn_Age(AInfo.ValueDesc4,@P_PDate, H4.AGEMETHOD) as varchar(10)) Between G4.FLower and G4.FUpper) or (G4.Formula<>'AGE' and G4.ValueID=AInfo.ValueID4)))          
 Left Join GenDTab G5 on (G5.FLDID=AInfo.FLDID5 and ((G5.Formula='AGE' and cast(dbo.fn_Age(AInfo.ValueDesc5,@P_PDate, H5.AGEMETHOD) as varchar(10)) Between G5.FLower and G5.FUpper) or (G5.Formula<>'AGE' and G5.ValueID=AInfo.ValueID5)))          
 Left Join GenDTab G6 on (G6.FLDID=AInfo.FLDID6 and ((G6.Formula='AGE' and cast(dbo.fn_Age(AInfo.ValueDesc6,@P_PDate, H6.AGEMETHOD) as varchar(10)) Between G6.FLower and G6.FUpper) or (G6.Formula<>'AGE' and G6.ValueID=AInfo.ValueID6)))          
 Left Join GenDTab G7 on (G7.FLDID=AInfo.FLDID7 and ((G7.Formula='AGE' and cast(dbo.fn_Age(AInfo.ValueDesc7,@P_PDate, H7.AGEMETHOD) as varchar(10)) Between G7.FLower and G7.FUpper) or (G7.Formula<>'AGE' and G7.ValueID=AInfo.ValueID7)))          
 Left Join GenDTab G8 on (G8.FLDID=AInfo.FLDID8 and ((G8.Formula='AGE' and cast(dbo.fn_Age(AInfo.ValueDesc8,@P_PDate, H8.AGEMETHOD) as varchar(10)) Between G8.FLower and G8.FUpper) or (G8.Formula<>'AGE' and G8.ValueID=AInfo.ValueID8)))          
 Left Join GenDTab G9 on (G9.FLDID=AInfo.FLDID9 and ((G9.Formula='AGE' and cast(dbo.fn_Age(AInfo.ValueDesc9,@P_PDate, H9.AGEMETHOD) as varchar(10)) Between G9.FLower and G9.FUpper) or (G9.Formula<>'AGE' and G9.ValueID=AInfo.ValueID9)))          
 Left Join GenDTab G10 on (G10.FLDID=AInfo.FLDID10 and ((G10.Formula='AGE' and cast(dbo.fn_Age(AInfo.ValueDesc10,@P_PDate, H10.AGEMETHOD) as varchar(10)) Between G10.FLower and G10.FUpper) or (G10.Formula<>'AGE' and G10.ValueID=AInfo.ValueID10)))          
 Left Join GenDTab G11 on (G11.FLDID=AInfo.FLDID11 and ((G11.Formula='AGE' and cast(dbo.fn_Age(AInfo.ValueDesc11,@P_PDate, H11.AGEMETHOD) as varchar(10)) Between G11.FLower and G11.FUpper) or (G11.Formula<>'AGE' and G11.ValueID=AInfo.ValueID11)))          
 Left Join GenDTab G12 on (G12.FLDID=AInfo.FLDID12 and ((G12.Formula='AGE' and cast(dbo.fn_Age(AInfo.ValueDesc12,@P_PDate, H12.AGEMETHOD) as varchar(10)) Between G12.FLower and G12.FUpper) or (G12.Formula<>'AGE' and G12.ValueID=AInfo.ValueID12)))          
 Left Join GenDTab G13 on (G13.FLDID=AInfo.FLDID13 and ((G13.Formula='AGE' and cast(dbo.fn_Age(AInfo.ValueDesc13,@P_PDate, H13.AGEMETHOD) as varchar(10)) Between G13.FLower and G13.FUpper) or (G13.Formula<>'AGE' and G13.ValueID=AInfo.ValueID13)))          
 Left Join GenDTab G14 on (G14.FLDID=AInfo.FLDID14 and ((G14.Formula='AGE' and cast(dbo.fn_Age(AInfo.ValueDesc14,@P_PDate, H14.AGEMETHOD) as varchar(10)) Between G14.FLower and G14.FUpper) or (G14.Formula<>'AGE' and G14.ValueID=AInfo.ValueID14)))          
 Left Join GenDTab G15 on (G15.FLDID=AInfo.FLDID15 and ((G15.Formula='AGE' and cast(dbo.fn_Age(AInfo.ValueDesc15,@P_PDate, H15.AGEMETHOD) as varchar(10)) Between G15.FLower and G15.FUpper) or (G15.Formula<>'AGE' and G15.ValueID=AInfo.ValueID15)))         
 
WHERE AINFO.ANO=@P_ANO                       
Order by RateTab.Effective Desc

Declare @Loading as Float
Declare @HoldF as Bit
Declare @HoldMessage as varchar(512)

Declare @Temp_Loading as Float
Declare @Temp_HoldF as Bit
Declare @Temp_HoldMessage as varchar(512)


Select @Loading=1
Select @HoldF=0
Select @HoldMessage=''

--Rate Loading #1
Select @Temp_Loading=Null
Select @Temp_HoldF=Null
Select @Temp_HoldMessage=Null

SELECT Top 1 @Temp_Loading=RateCon.Loading, @Temp_HoldF=RateCon.HoldF, @Temp_HoldMessage=RateCon.HoldMessage
From @RateTab RateTab
INNER JOIN RateCon_M1 RateCon  on (
RateCon.Code=RateTab.Code and RateCon.AllowedF=1
And ((Case When @P_TSI=0 Then 1 Else @P_TSI End)>=RateCon.MinTSI or RateCon.MinTSI=0) 
and ((Case When @P_TSI=0 Then 1 Else @P_TSI End)<=RateCon.MaxTSI or RateCon.MaxTSI=0)     
and (coalesce(RateCon.ValueID1,'')='' or RateTab.ValueID1 =RateCon.ValueID1)                
And (coalesce(RateCon.ValueID2,'')='' or RateTab.ValueID2 =RateCon.ValueID2)                
And (coalesce(RateCon.ValueID3,'')='' or RateTab.ValueID3 =RateCon.ValueID3)                
And (coalesce(RateCon.ValueID4,'')='' or RateTab.ValueID4 =RateCon.ValueID4)                
And (coalesce(RateCon.ValueID5,'')='' or RateTab.ValueID5 =RateCon.ValueID5)                
And (coalesce(RateCon.ValueID6,'')='' or RateTab.ValueID6 =RateCon.ValueID6)                
And (coalesce(RateCon.ValueID7,'')='' or RateTab.ValueID7 =RateCon.ValueID7)                
And (coalesce(RateCon.ValueID8,'')='' or RateTab.ValueID8 =RateCon.ValueID8)                
And (coalesce(RateCon.ValueID9,'')='' or RateTab.ValueID9 =RateCon.ValueID9)                
And (coalesce(RateCon.ValueID10,'')='' or RateTab.ValueID10 =RateCon.ValueID10)                
And (coalesce(RateCon.ValueID11,'')='' or RateTab.ValueID11 =RateCon.ValueID11)                
And (coalesce(RateCon.ValueID12,'')='' or RateTab.ValueID12 =RateCon.ValueID12)                
And (coalesce(RateCon.ValueID13,'')='' or RateTab.ValueID13 =RateCon.ValueID13)                
And (coalesce(RateCon.ValueID14,'')='' or RateTab.ValueID14 =RateCon.ValueID14)                
And (coalesce(RateCon.ValueID15,'')='' or RateTab.ValueID15 =RateCon.ValueID15)                       
)
Order by   
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

if @Temp_Loading is null
	Select @Temp_Loading=1
	
Select @Loading=@Loading*@Temp_Loading

if @Temp_HoldF is null
	Select @Temp_HoldF=0

if @Temp_HoldF=1 
Begin
	Select @HoldF=@Temp_HoldF
	Select @HoldMessage=@HoldMessage+char(13)+char(10)+@Temp_HoldMessage 
End
	
--Rate Loading #2
Select @Temp_Loading=Null
Select @Temp_HoldF=Null
Select @Temp_HoldMessage=Null

SELECT Top 1 @Temp_Loading=RateCon.Loading, @Temp_HoldF=RateCon.HoldF, @Temp_HoldMessage=RateCon.HoldMessage
From @RateTab RateTab
INNER JOIN RateCon_M2 RateCon  on (
RateCon.Code=RateTab.Code and RateCon.AllowedF=1                 
And ((Case When @P_TSI=0 Then 1 Else @P_TSI End)>=RateCon.MinTSI or RateCon.MinTSI=0) 
and ((Case When @P_TSI=0 Then 1 Else @P_TSI End)<=RateCon.MaxTSI or RateCon.MaxTSI=0)     
and (coalesce(RateCon.ValueID1,'')='' or RateTab.ValueID1 =RateCon.ValueID1)                
And (coalesce(RateCon.ValueID2,'')='' or RateTab.ValueID2 =RateCon.ValueID2)                
And (coalesce(RateCon.ValueID3,'')='' or RateTab.ValueID3 =RateCon.ValueID3)                
And (coalesce(RateCon.ValueID4,'')='' or RateTab.ValueID4 =RateCon.ValueID4)                
And (coalesce(RateCon.ValueID5,'')='' or RateTab.ValueID5 =RateCon.ValueID5)                
And (coalesce(RateCon.ValueID6,'')='' or RateTab.ValueID6 =RateCon.ValueID6)                
And (coalesce(RateCon.ValueID7,'')='' or RateTab.ValueID7 =RateCon.ValueID7)                
And (coalesce(RateCon.ValueID8,'')='' or RateTab.ValueID8 =RateCon.ValueID8)                
And (coalesce(RateCon.ValueID9,'')='' or RateTab.ValueID9 =RateCon.ValueID9)                
And (coalesce(RateCon.ValueID10,'')='' or RateTab.ValueID10 =RateCon.ValueID10)                
And (coalesce(RateCon.ValueID11,'')='' or RateTab.ValueID11 =RateCon.ValueID11)                
And (coalesce(RateCon.ValueID12,'')='' or RateTab.ValueID12 =RateCon.ValueID12)                
And (coalesce(RateCon.ValueID13,'')='' or RateTab.ValueID13 =RateCon.ValueID13)                
And (coalesce(RateCon.ValueID14,'')='' or RateTab.ValueID14 =RateCon.ValueID14)                
And (coalesce(RateCon.ValueID15,'')='' or RateTab.ValueID15 =RateCon.ValueID15)                       
)
Order by   
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

if @Temp_Loading is null
	Select @Temp_Loading=1
	
Select @Loading=@Loading*@Temp_Loading

if @Temp_HoldF is null
	Select @Temp_HoldF=0

if @Temp_HoldF=1 
Begin
	Select @HoldF=@Temp_HoldF
	Select @HoldMessage=@HoldMessage+char(13)+char(10)+@Temp_HoldMessage 
End

--Rate Loading #3
Select @Temp_Loading=Null
Select @Temp_HoldF=Null
Select @Temp_HoldMessage=Null

SELECT Top 1 @Temp_Loading=RateCon.Loading, @Temp_HoldF=RateCon.HoldF, @Temp_HoldMessage=RateCon.HoldMessage
From @RateTab RateTab
INNER JOIN RateCon_M3 RateCon  on (
RateCon.Code=RateTab.Code and RateCon.AllowedF=1                 
And ((Case When @P_TSI=0 Then 1 Else @P_TSI End)>=RateCon.MinTSI or RateCon.MinTSI=0) 
and ((Case When @P_TSI=0 Then 1 Else @P_TSI End)<=RateCon.MaxTSI or RateCon.MaxTSI=0)     
and (coalesce(RateCon.ValueID1,'')='' or RateTab.ValueID1 =RateCon.ValueID1)                
And (coalesce(RateCon.ValueID2,'')='' or RateTab.ValueID2 =RateCon.ValueID2)                
And (coalesce(RateCon.ValueID3,'')='' or RateTab.ValueID3 =RateCon.ValueID3)                
And (coalesce(RateCon.ValueID4,'')='' or RateTab.ValueID4 =RateCon.ValueID4)                
And (coalesce(RateCon.ValueID5,'')='' or RateTab.ValueID5 =RateCon.ValueID5)                
And (coalesce(RateCon.ValueID6,'')='' or RateTab.ValueID6 =RateCon.ValueID6)                
And (coalesce(RateCon.ValueID7,'')='' or RateTab.ValueID7 =RateCon.ValueID7)                
And (coalesce(RateCon.ValueID8,'')='' or RateTab.ValueID8 =RateCon.ValueID8)                
And (coalesce(RateCon.ValueID9,'')='' or RateTab.ValueID9 =RateCon.ValueID9)                
And (coalesce(RateCon.ValueID10,'')='' or RateTab.ValueID10 =RateCon.ValueID10)                
And (coalesce(RateCon.ValueID11,'')='' or RateTab.ValueID11 =RateCon.ValueID11)                
And (coalesce(RateCon.ValueID12,'')='' or RateTab.ValueID12 =RateCon.ValueID12)                
And (coalesce(RateCon.ValueID13,'')='' or RateTab.ValueID13 =RateCon.ValueID13)                
And (coalesce(RateCon.ValueID14,'')='' or RateTab.ValueID14 =RateCon.ValueID14)                
And (coalesce(RateCon.ValueID15,'')='' or RateTab.ValueID15 =RateCon.ValueID15)                       
)
Order by   
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

if @Temp_Loading is null
	Select @Temp_Loading=1
	
Select @Loading=@Loading*@Temp_Loading

if @Temp_HoldF is null
	Select @Temp_HoldF=0

if @Temp_HoldF=1 
Begin
	Select @HoldF=@Temp_HoldF
	Select @HoldMessage=@HoldMessage+char(13)+char(10)+@Temp_HoldMessage 
End


--Rate Loading #4
Select @Temp_Loading=Null
Select @Temp_HoldF=Null
Select @Temp_HoldMessage=Null

SELECT Top 1 @Temp_Loading=RateCon.Loading, @Temp_HoldF=RateCon.HoldF, @Temp_HoldMessage=RateCon.HoldMessage
From @RateTab RateTab
INNER JOIN RateCon_M4 RateCon  on (
RateCon.Code=RateTab.Code and RateCon.AllowedF=1                 
And ((Case When @P_TSI=0 Then 1 Else @P_TSI End)>=RateCon.MinTSI or RateCon.MinTSI=0) 
and ((Case When @P_TSI=0 Then 1 Else @P_TSI End)<=RateCon.MaxTSI or RateCon.MaxTSI=0)     
and (coalesce(RateCon.ValueID1,'')='' or RateTab.ValueID1 =RateCon.ValueID1)                
And (coalesce(RateCon.ValueID2,'')='' or RateTab.ValueID2 =RateCon.ValueID2)                
And (coalesce(RateCon.ValueID3,'')='' or RateTab.ValueID3 =RateCon.ValueID3)                
And (coalesce(RateCon.ValueID4,'')='' or RateTab.ValueID4 =RateCon.ValueID4)                
And (coalesce(RateCon.ValueID5,'')='' or RateTab.ValueID5 =RateCon.ValueID5)                
And (coalesce(RateCon.ValueID6,'')='' or RateTab.ValueID6 =RateCon.ValueID6)                
And (coalesce(RateCon.ValueID7,'')='' or RateTab.ValueID7 =RateCon.ValueID7)                
And (coalesce(RateCon.ValueID8,'')='' or RateTab.ValueID8 =RateCon.ValueID8)                
And (coalesce(RateCon.ValueID9,'')='' or RateTab.ValueID9 =RateCon.ValueID9)                
And (coalesce(RateCon.ValueID10,'')='' or RateTab.ValueID10 =RateCon.ValueID10)                
And (coalesce(RateCon.ValueID11,'')='' or RateTab.ValueID11 =RateCon.ValueID11)                
And (coalesce(RateCon.ValueID12,'')='' or RateTab.ValueID12 =RateCon.ValueID12)                
And (coalesce(RateCon.ValueID13,'')='' or RateTab.ValueID13 =RateCon.ValueID13)                
And (coalesce(RateCon.ValueID14,'')='' or RateTab.ValueID14 =RateCon.ValueID14)                
And (coalesce(RateCon.ValueID15,'')='' or RateTab.ValueID15 =RateCon.ValueID15)                       
)
Order by   
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

if @Temp_Loading is null
	Select @Temp_Loading=1
	
Select @Loading=@Loading*@Temp_Loading

if @Temp_HoldF is null
	Select @Temp_HoldF=0

if @Temp_HoldF=1 
Begin
	Select @HoldF=@Temp_HoldF
	Select @HoldMessage=@HoldMessage+char(13)+char(10)+@Temp_HoldMessage 
End


--Rate Loading #5
Select @Temp_Loading=Null
Select @Temp_HoldF=Null
Select @Temp_HoldMessage=Null

SELECT Top 1 @Temp_Loading=RateCon.Loading, @Temp_HoldF=RateCon.HoldF, @Temp_HoldMessage=RateCon.HoldMessage
From @RateTab RateTab
INNER JOIN RateCon_M5 RateCon  on (
RateCon.Code=RateTab.Code and RateCon.AllowedF=1                 
And ((Case When @P_TSI=0 Then 1 Else @P_TSI End)>=RateCon.MinTSI or RateCon.MinTSI=0) 
and ((Case When @P_TSI=0 Then 1 Else @P_TSI End)<=RateCon.MaxTSI or RateCon.MaxTSI=0)     
and (coalesce(RateCon.ValueID1,'')='' or RateTab.ValueID1 =RateCon.ValueID1)                
And (coalesce(RateCon.ValueID2,'')='' or RateTab.ValueID2 =RateCon.ValueID2)                
And (coalesce(RateCon.ValueID3,'')='' or RateTab.ValueID3 =RateCon.ValueID3)                
And (coalesce(RateCon.ValueID4,'')='' or RateTab.ValueID4 =RateCon.ValueID4)                
And (coalesce(RateCon.ValueID5,'')='' or RateTab.ValueID5 =RateCon.ValueID5)                
And (coalesce(RateCon.ValueID6,'')='' or RateTab.ValueID6 =RateCon.ValueID6)                
And (coalesce(RateCon.ValueID7,'')='' or RateTab.ValueID7 =RateCon.ValueID7)                
And (coalesce(RateCon.ValueID8,'')='' or RateTab.ValueID8 =RateCon.ValueID8)                
And (coalesce(RateCon.ValueID9,'')='' or RateTab.ValueID9 =RateCon.ValueID9)                
And (coalesce(RateCon.ValueID10,'')='' or RateTab.ValueID10 =RateCon.ValueID10)                
And (coalesce(RateCon.ValueID11,'')='' or RateTab.ValueID11 =RateCon.ValueID11)                
And (coalesce(RateCon.ValueID12,'')='' or RateTab.ValueID12 =RateCon.ValueID12)                
And (coalesce(RateCon.ValueID13,'')='' or RateTab.ValueID13 =RateCon.ValueID13)                
And (coalesce(RateCon.ValueID14,'')='' or RateTab.ValueID14 =RateCon.ValueID14)                
And (coalesce(RateCon.ValueID15,'')='' or RateTab.ValueID15 =RateCon.ValueID15)                       
)
Order by   
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

if @Temp_Loading is null
	Select @Temp_Loading=1
	
Select @Loading=@Loading*@Temp_Loading

if @Temp_HoldF is null
	Select @Temp_HoldF=0

if @Temp_HoldF=1 
Begin
	Select @HoldF=@Temp_HoldF
	Select @HoldMessage=@HoldMessage+char(13)+char(10)+@Temp_HoldMessage 
End

--Rate Loading #6
Select @Temp_Loading=Null
Select @Temp_HoldF=Null
Select @Temp_HoldMessage=Null

SELECT Top 1 @Temp_Loading=RateCon.Loading, @Temp_HoldF=RateCon.HoldF, @Temp_HoldMessage=RateCon.HoldMessage
From @RateTab RateTab
INNER JOIN RateCon_M6 RateCon  on (
RateCon.Code=RateTab.Code and RateCon.AllowedF=1                 
And ((Case When @P_TSI=0 Then 1 Else @P_TSI End)>=RateCon.MinTSI or RateCon.MinTSI=0) 
and ((Case When @P_TSI=0 Then 1 Else @P_TSI End)<=RateCon.MaxTSI or RateCon.MaxTSI=0)     
and (coalesce(RateCon.ValueID1,'')='' or RateTab.ValueID1 =RateCon.ValueID1)                
And (coalesce(RateCon.ValueID2,'')='' or RateTab.ValueID2 =RateCon.ValueID2)                
And (coalesce(RateCon.ValueID3,'')='' or RateTab.ValueID3 =RateCon.ValueID3)                
And (coalesce(RateCon.ValueID4,'')='' or RateTab.ValueID4 =RateCon.ValueID4)                
And (coalesce(RateCon.ValueID5,'')='' or RateTab.ValueID5 =RateCon.ValueID5)                
And (coalesce(RateCon.ValueID6,'')='' or RateTab.ValueID6 =RateCon.ValueID6)                
And (coalesce(RateCon.ValueID7,'')='' or RateTab.ValueID7 =RateCon.ValueID7)                
And (coalesce(RateCon.ValueID8,'')='' or RateTab.ValueID8 =RateCon.ValueID8)                
And (coalesce(RateCon.ValueID9,'')='' or RateTab.ValueID9 =RateCon.ValueID9)                
And (coalesce(RateCon.ValueID10,'')='' or RateTab.ValueID10 =RateCon.ValueID10)                
And (coalesce(RateCon.ValueID11,'')='' or RateTab.ValueID11 =RateCon.ValueID11)                
And (coalesce(RateCon.ValueID12,'')='' or RateTab.ValueID12 =RateCon.ValueID12)                
And (coalesce(RateCon.ValueID13,'')='' or RateTab.ValueID13 =RateCon.ValueID13)                
And (coalesce(RateCon.ValueID14,'')='' or RateTab.ValueID14 =RateCon.ValueID14)                
And (coalesce(RateCon.ValueID15,'')='' or RateTab.ValueID15 =RateCon.ValueID15)                       
)
Order by   
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

if @Temp_Loading is null
	Select @Temp_Loading=1
	
Select @Loading=@Loading*@Temp_Loading

if @Temp_HoldF is null
	Select @Temp_HoldF=0

if @Temp_HoldF=1 
Begin
	Select @HoldF=@Temp_HoldF
	Select @HoldMessage=@HoldMessage+char(13)+char(10)+@Temp_HoldMessage 
End


--Rate Loading #7
Select @Temp_Loading=Null
Select @Temp_HoldF=Null
Select @Temp_HoldMessage=Null

SELECT Top 1 @Temp_Loading=RateCon.Loading, @Temp_HoldF=RateCon.HoldF, @Temp_HoldMessage=RateCon.HoldMessage
From @RateTab RateTab
INNER JOIN RateCon_M7 RateCon  on (
RateCon.Code=RateTab.Code and RateCon.AllowedF=1                 
And ((Case When @P_TSI=0 Then 1 Else @P_TSI End)>=RateCon.MinTSI or RateCon.MinTSI=0) 
and ((Case When @P_TSI=0 Then 1 Else @P_TSI End)<=RateCon.MaxTSI or RateCon.MaxTSI=0)     
and (coalesce(RateCon.ValueID1,'')='' or RateTab.ValueID1 =RateCon.ValueID1)                
And (coalesce(RateCon.ValueID2,'')='' or RateTab.ValueID2 =RateCon.ValueID2)                
And (coalesce(RateCon.ValueID3,'')='' or RateTab.ValueID3 =RateCon.ValueID3)                
And (coalesce(RateCon.ValueID4,'')='' or RateTab.ValueID4 =RateCon.ValueID4)                
And (coalesce(RateCon.ValueID5,'')='' or RateTab.ValueID5 =RateCon.ValueID5)                
And (coalesce(RateCon.ValueID6,'')='' or RateTab.ValueID6 =RateCon.ValueID6)                
And (coalesce(RateCon.ValueID7,'')='' or RateTab.ValueID7 =RateCon.ValueID7)                
And (coalesce(RateCon.ValueID8,'')='' or RateTab.ValueID8 =RateCon.ValueID8)                
And (coalesce(RateCon.ValueID9,'')='' or RateTab.ValueID9 =RateCon.ValueID9)                
And (coalesce(RateCon.ValueID10,'')='' or RateTab.ValueID10 =RateCon.ValueID10)                
And (coalesce(RateCon.ValueID11,'')='' or RateTab.ValueID11 =RateCon.ValueID11)                
And (coalesce(RateCon.ValueID12,'')='' or RateTab.ValueID12 =RateCon.ValueID12)                
And (coalesce(RateCon.ValueID13,'')='' or RateTab.ValueID13 =RateCon.ValueID13)                
And (coalesce(RateCon.ValueID14,'')='' or RateTab.ValueID14 =RateCon.ValueID14)                
And (coalesce(RateCon.ValueID15,'')='' or RateTab.ValueID15 =RateCon.ValueID15)                       
)
Order by   
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

if @Temp_Loading is null
	Select @Temp_Loading=1
	
Select @Loading=@Loading*@Temp_Loading

if @Temp_HoldF is null
	Select @Temp_HoldF=0

if @Temp_HoldF=1 
Begin
	Select @HoldF=@Temp_HoldF
	Select @HoldMessage=@HoldMessage+char(13)+char(10)+@Temp_HoldMessage 
End

insert into @RateCon Select @Loading, @HoldF,@HoldMessage
Return
END  


go

--3 May 2018
Alter Table Country Add DefaultF Bit
GO
Update Country Set DefaultF=0 Where DefaultF is null
go

--Perubahan untuk License Expiry

insert into sysform(FName, Description, FCode)
Select 'FORCELICENSEEXPIRY','FORCE CHECK BUSINESS SOURCE LICENSE EXPIRY','ACTIVITIES'

GO
DROP FUNCTION FN_UserBusinessSource 
GO
CREATE FUNCTION FN_UserBusinessSource (@P_UserID as varchar(10), @P_PDate as smalldatetime)      
RETURNS TABLE      
as RETURN(      
Select P.*, S1.ID as SID, S1.Name as SName
From Profile P 
Left Join SysUserAssignment S on (S.AssType='SOURCE' and S.PID=P.ID and (S.ID=@P_UserID or @P_UserID=''))
Left join SysUser S1 on (S1.ID=S.ID and S1.AllowedF=1)
Where coalesce(P.DumpF,0)=0 and P.IntermediaryF=1
and (coalesce(P.LicenseExpiry,cast(convert(varchar(10), getdate(),1) as smalldatetime))>=cast(convert(varchar(10), @P_PDate,1) as smalldatetime))
and
(
@P_UserID='' 
or coalesce(S1.ID,'')=@P_UserID
or NOT EXISTS (Select PID from SysUserAssignment S Where S.PID=P.ID and S.AssType='SOURCE' and S.ID<>@P_UserID)
)
)    

go


alter table request alter column
AcceptedBy  varchar(255)
go
alter table pVoucher alter column
AcceptedBy  varchar(255)
go
alter table nVoucher alter column
AcceptedBy  varchar(255)
go
alter table COLLECTIOND alter column
AcceptedBy  varchar(255)
go

create index I_Profile_RefID on Profile(REFID)
GO
Create index I_Admlink_BillDate on Admlink(BillDate)
go


--Update 14 may 2018

DROP FUNCTION fn_Calc_Prorata
GO
CREATE FUNCTION fn_Calc_Prorata(@P_PSDate as smalldatetime, @P_PEDate as smalldatetime, @P_SDate as smalldatetime, @P_EDate as smalldatetime, @P_PPeriod as integer)              
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
	Select @P_Prorata=@P_Prorata / cast(datediff(month,@P_SDate, @P_Edate) as Float)
End
Else 
Begin
	if day(@P_PSDate)=day(@P_PEdate) and day(@P_PSDate)=day(@P_Edate) and day(@P_SDate)=day(@P_Edate) and @P_PPeriod<>1 and datediff(month,@P_Sdate,@P_Edate)<>0
	Begin
		Select @P_Prorata=cast(datediff(month,@P_PSDate, @P_PEDate) as Float)/cast(datediff(month,@P_SDate, @P_EDate) as Float)
	End
	else
	Begin
		Select @P_Prorata=cast(datediff(day,@P_PSDate, @P_PEDate) as Float)/cast(datediff(day,@P_SDate, @P_EDate) as Float)
	End
End

Return @P_Prorata

END  

GO

DROP FUNCTION fn_Calc_SProrata
GO
CREATE FUNCTION fn_Calc_SProrata(@P_PSDate as smalldatetime, @P_PEDate as smalldatetime, @P_SDate as smalldatetime, @P_EDate as smalldatetime, @P_PPeriod as integer)              
RETURNS varchar(255)
AS               
BEGIN              

Declare @P_Prorata as Float
Declare @P_SProrata as varchar(255)

if @P_PPeriod=2
Begin
	Select @P_Prorata=cast(datediff(Month,@P_PSDate, @P_PEDate) as Float)
	if day(@P_PSDate)>day(@P_PEDate)
	Begin
		Select @P_Prorata=@P_Prorata-1
			if @P_Prorata<0
				Select @P_Prorata=0
	End

	if cast(@P_Prorata as integer)<>datediff(month,@P_SDate, @P_Edate)
		Select @P_SProrata= convert(varchar(25),cast(@P_Prorata as integer))+'/'+convert(varchar(25),datediff(month,@P_SDate, @P_Edate))
	else
		Select @P_SProrata=''
End
Else 
Begin
	if day(@P_PSDate)=day(@P_PEdate) and day(@P_PSDate)=day(@P_Edate) and day(@P_SDate)=day(@P_Edate) and @P_PPeriod<>1 and datediff(month,@P_Sdate,@P_Edate)<>0
	Begin
		if datediff(month,@P_PSDate, @P_PEDate)<>datediff(month,@P_SDate, @P_EDate)
			Select @P_SProrata= convert(varchar(25),datediff(month,@P_PSDate, @P_PEDate))+'/'+convert(varchar(25),datediff(month,@P_SDate, @P_EDate))
		else
			Select @P_SProrata=''
	End
	else
	Begin
		if datediff(day,@P_PSDate, @P_PEDate)<>datediff(day,@P_SDate, @P_EDate)
			Select @P_SProrata= convert(varchar(25),datediff(day,@P_PSDate, @P_PEDate))+'/'+convert(varchar(25),datediff(day,@P_SDate, @P_EDate))
		else
			Select @P_SProrata=''
	End
End

Return @P_SProrata

END  


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
  and Acceptance.NoRefundF not in (2,4) and (Acceptance.AType='N' or ((RCover.NoRefundF=0 and Acceptance.NoRefundF in (0,3,5)) or (DateDiff(day, acceptance.pdate, RCalc.SDate) >= 0)))      
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
				dbo.fn_calc_prorata(acceptance.pDate, dateadd(day,1,RCalc.edate), RCalc.Sdate, dateadd(day,1,RCalc.edate), Cover.PPeriod)
			else
				dbo.fn_calc_prorata(acceptance.pDate, RCalc.Edate, RCalc.Sdate, RCalc.EDate, Cover.PPeriod)
			End			 
		Else 
		-- Endorsement Period 
			1 
		End 
	End 
End 
* (Case When pAcceptance.Qty=0 Then 1 else pAcceptance.Qty end) 
* (Case When PCalc.Description='Minimum Premium' Then RCalc.Gross else (Case When PCalc.Gross=0 then 0 else Case When PCalc.OGross=0 Then PCalc.Gross else RCalc.OGross*(case When Pcalc.TSI=0 then 1 else PCalc.Ourshare/PCalc.TSI end) *PCalc.Gross/PCalc.OGross end end) end+RCalc.Reinstatement) as Premium 
from Acceptance inner join Acceptance pAcceptance on (pAcceptance.ANO=Acceptance.pANO) inner Join Cover on (Cover.CNO=pAcceptance.CNO) 
inner join PCalc on (PCalc.ANO=pAcceptance.ANO) inner join RCalc on (RCalc.ANO=PCalc.ANO and RCalc.Currency=PCalc.Currency) 
Left Join RCover on (RCover.ANO=Acceptance.ANO and RCover.Code=RCalc.Code and RCover.SDate=RCalc.SDate) 
Where Acceptance.ANO=@P_ANO and Acceptance.AType<>'A' and Not (Acceptance.AType='C' and Acceptance.EMethod='A') and pAcceptance.AType not in ('A','C') 
and Acceptance.NoRefundF not in (2,4) and ((coalesce(RCover.NoRefundF,0)=0 and Acceptance.NoRefundF in (0,3,5,6)) or (DateDiff(day, acceptance.pdate, rcalc.SDate) >= 0 and acceptance.pdate between pacceptance.sdate and pacceptance.edate)) 
and RCalc.Gross<>0 
) T 
 
Group By ANO, Currency 
 
Union All 
 
select A1.ANO, AccAss.Currency_OC as Currency, 
sum(Case When AccAss.Code='P' then (Case When A1.AType='A' and AccAss.AdjMethod='OVERLIMIT' then -AccAss.CAmount*(Case When A1.CPCT<>0 Then A1.CPCT/100 else 1 end)/(Case When AccAss.PProrata<>0 Then AccAss.PProrata else 1 end) else -AccAss.Amount_OC end)*

(Case When AccAss.Type='DI' then 100/(100-coalesce(Coinsurance.MShare,0)) else 1 end) else 0 end) as Premium 
from Acceptance A1 
inner join Acceptance A2 on (A2.OANO=A1.OANO) 
inner join AccAss on (AccAss.ANO=A2.ANO) 
inner join Profile on (Profile.ID=AccAss.ID) 
inner join MParam on (MParam.Type=Accass.Type) 
Left Join (Select CNO, sum(Share) as MShare from Coinsurance Where PCollectionF=0 Group by CNO) Coinsurance on (Coinsurance.CNO=A2.CNO) 
Left join Acceptance pA2 on (pA2.ANO=A2.PANO) 
Where A1.ANO=@P_ANO 
and ( 
(A2.ANO<=A1.PANO AND A2.ANO<@P_ANO AND A1.PDate<=A2.PDate and A1.PPDate>=A2.PPDate and A1.AType='A' and AccAss.AdjustableF=1 and (AccAss.AdjMethod<>'OVERLIMIT' or AccAss.CAmount<>0) and NOT EXISTS (Select PANO from Acceptance A3 Where A3.PANO=A2.ANO and A3.AStatus<>'C' and A3.AType='A' and A3.ANO<>@P_ANO)) 
or (A2.ANO<@P_ANO AND A1.AType='C' and A1.EMethod='A' and A2.PDate>=A1.PDate and (coalesce(pA2.pDate,A2.PDate)>=A1.PDate or A2.ATYPE='A' or (coalesce(pA2.pDate,A2.PDate)<A1.PDate and AccAss.CAmount<>0))) 
or (A2.ANO=A1.PANO and A2.AType='A' and A1.AType='C')) 
and ((AccAss.Type in ('DI','IC','IR') and AccAss.Code='P') Or (AccAss.Type in ('BB','BA','BO') and AccAss.Code='C') or (AccAss.Type in ('DI','IC','IR') and AccAss.Code='O') or (A1.AType='C' and A1.EMethod='A' and AccAss.Type in ('DI') and AccAss.Code in (
'F','D'))) 
Group By A1.ANO, AccAss.Currency_OC 
) T 
 
Group By ANO, Currency 
) 
 
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
   case when acceptance.cpct<>0 and acceptance.cpct<>100 then convert(varchar(25),Cast(Acceptance.CPCT as float),3)+'%' else '' end        
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
and (Acceptance.AType='N' or (Acceptance.NoRefundF not in (2,4) and RCover.NoRefundF=0 and (Acceptance.NoRefundF in (0,3,5,6) or (DateDiff(day, acceptance.pdate, RCalc.SDate) > 0))))
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
    case when acceptance.cpct<>0 and acceptance.cpct<>100 then convert(varchar(25),Cast(Acceptance.CPCT as float),3)+'%' else '' end        
  Else        
    case        
		When Acceptance.SDate<>Acceptance.PDate or Acceptance.NoRefundF=6 then        
			--Prorata Calculation
			Case When pAcceptance.EXCLUSIVEF=0 and pAcceptance.STime<pAcceptance.ETime and RCalc.EDate=pAcceptance.EDate Then
				dbo.fn_Calc_SProrata(acceptance.pDate, dateadd(day,1,RCalc.edate), RCalc.Sdate, dateadd(day,1,RCalc.edate), Cover.PPeriod)
			else
				dbo.fn_Calc_SProrata(acceptance.pDate, RCalc.Edate, RCalc.Sdate, RCalc.EDate, Cover.PPeriod)
			End
		Else        
		 -- Endorsement Period        
			''        
		End        
	End        
End        
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
				dbo.fn_calc_prorata(acceptance.pDate, dateadd(day,1,RCalc.edate), RCalc.Sdate, dateadd(day,1,RCalc.edate), Cover.PPeriod)
			else
				dbo.fn_calc_prorata(acceptance.pDate, RCalc.Edate, RCalc.Sdate, RCalc.EDate, Cover.PPeriod)
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
and (Acceptance.NoRefundF in (0,3,5,6) or (DateDiff(day, acceptance.pdate, rcalc.SDate) > 0 and acceptance.pdate between pacceptance.sdate and pacceptance.edate))      
and Acceptance.ANO=@P_ANO        
)        
       





go

Drop Procedure qPolicy_Data
GO
Create Procedure qPolicy_Data(@P_ANO integer)                                    
as                                    
SELECT                                    
C.CNO, C.COVERNO, A1.TOC, C.MO, C.SEGMENT, A1.Location, C.VALIDATION, C.REFNO as CREFNO, C.PRORATA, C.PHOLDER, C.PPERIOD, C.CStatus,                                    
A1.ASource, P.ID as PayorID, C.ISType, C.OpenFlag, C.Voyage, C.PolicyType, C.VSeqNo, C.TBAF,          
A1.ANO, A1.OANO, A1.LANO, A1.CANO, A1.PANO, A1.RANO, A1.REGNO, A1.REGDATE, A1.BRANCH, A1.CT, A1.AStatus, A1.ATYPE, A1.POLICYNO, A1.POLICYDATE, A1.CPOLICYNO, A1.REFNO, A1.REFDATE, A1.RENEWABLEF, A1.CONJUNCTIONF, A1.EXCLUSIVEF, 
A1.SDATE, A1.EDATE, A1.STIME, A1.ETIME,         
          
A1.REMARKS, A1.EXTPERIOD, A1.ExtPeriodInDaysF, A1.ADATE, A1.PDATE, A1.PPDATE, A1.AID, A1.ANAME, A1.BUSINESS, A1.TOPRO, A1.Ujroh, A1.WeightedAvgUjrohF,                           
A1.ESeqNo, A1.EESeqNo, A1.Renewal, A1.BatchNo, A1.BankersClause,               
C.PUserID, C.PUserDate, C.PUserTime,                           
C.AUSERID as CAUserID, C.AUserDate as CAUserDate, C.AUserTime as CAUserTime,                        
C.CUSERID as CCUserID, C.CLOSEDATE as CCLOSEDATE, C.CloseTime as CCloseTime,    
A1.UserID, A1.CDate, A1.CTime,                                   
A1.CUserID, A1.CloseDate, A1.CloseTime,                             
A1.LUSERID, A1.LDate, A1.LTime,     
A1.AUSERID, A1.AUserDate, A1.AUserTime,                
CACCEPTANCE.REGNO as CREGNO,              
CCOVER.COVERNO AS CCOVERNO, A1.PWordingID,                   
A1.CPCT, A1.SYSUSERID,             
Interest.Currency, Interest.TSI, Interest.ATSI,   
icoverpol.CURRENCY as Currency_POL,icoverpol.Amount   as Amount_POL,                        
A2.FLDID1, A2.VALUEID1, A2.VALUEDESC1, 0 as FLDSEARCH1,                                    
A2.FLDID2, A2.VALUEID2, A2.VALUEDESC2, 0 as FLDSEARCH2,                                    
A2.FLDID3, A2.VALUEID3, A2.VALUEDESC3, 0 as FLDSEARCH3,                                    
A2.FLDID4, A2.VALUEID4, A2.VALUEDESC4, 0 as FLDSEARCH4,                                    
A2.FLDID5, A2.VALUEID5, A2.VALUEDESC5, 0 as FLDSEARCH5,                                    
A2.FLDID6, A2.VALUEID6, A2.VALUEDESC6, 0 as FLDSEARCH6,                                    
A2.FLDID7, A2.VALUEID7, A2.VALUEDESC7, 0 as FLDSEARCH7,                                    
A2.FLDID8, A2.VALUEID8, A2.VALUEDESC8, 0 as FLDSEARCH8,                                    
A2.FLDID9, A2.VALUEID9, A2.VALUEDESC9, 0 as FLDSEARCH9,                                    
A2.FLDID10, A2.VALUEID10, A2.VALUEDESC10, 0 as FLDSEARCH10,                                    
A2.FLDID11, A2.VALUEID11, A2.VALUEDESC11, 0 as FLDSEARCH11,                                    
A2.FLDID12, A2.VALUEID12, A2.VALUEDESC12, 0 as FLDSEARCH12,                                    
A2.FLDID13, A2.VALUEID13, A2.VALUEDESC13, 0 as FLDSEARCH13,                                    
A2.FLDID14, A2.VALUEID14, A2.VALUEDESC14, 0 as FLDSEARCH14,                                    
A2.FLDID15, A2.VALUEID15, A2.VALUEDESC15, 0 as FLDSEARCH15                                    
FROM COVER C                        
INNER JOIN ACCEPTANCE A1 ON (C.CNO=A1.CNO)                         
INNER JOIN PAYOR P on (P.ANO=A1.ANO)
LEFT JOIN ACCEPTANCE CACCEPTANCE ON (CACCEPTANCE.ANO=A1.CANO)                        
LEFT JOIN COVER CCOVER ON (CCOVER.CNO=CACCEPTANCE.CNO)                        
Left Join AINFO A2 On (A2.ANO=A1.ANO)                         
Left Join FN_SumInsured(@P_ANO) Interest On (Interest.ANO=A1.ANO and Interest.TSI<>0)      
Left Join IcoverPol On (IcoverPol.ANO=A1.ANO)                             
WHERE A1.ANO=@P_ANO 
go

Update pVoucher Set RefCCYDate=Date Where RefCCYDate is null
GO
Update nVoucher Set RefCCYDate=Date Where RefCCYDate is null
GO

DROP PROCEDURE QTOC_RRule
GO
CREATE PROCEDURE QTOC_RRule (@P_TOC AS VARCHAR(10),@RID AS int)       
AS       
SELECT  TOP 1           
TOC.RFLDID1, TOC.FLDTAG1, RenewalRule.ValueID1L AS ValueID1L,RenewalRule.ValueID1U AS ValueID1U,
TOC.RFLDID2, TOC.FLDTAG2,RenewalRule.ValueID2L AS ValueID2L,RenewalRule.ValueID2U AS ValueID2U,
TOC.RFLDID3, TOC.FLDTAG3, RenewalRule.ValueID3L AS ValueID3L,RenewalRule.ValueID3U AS ValueID3U,
TOC.RFLDID4, TOC.FLDTAG4, RenewalRule.ValueID4L AS ValueID4L,RenewalRule.ValueID4U AS ValueID4U,
TOC.RFLDID5, TOC.FLDTAG5, RenewalRule.ValueID5L AS ValueID5L,RenewalRule.ValueID5U AS ValueID5U
FROM       
RenewalRule, TOC      
LEFT OUTER JOIN GENHTAB as GENHTAB_1 ON TOC.RFLDID1<>'' AND TOC.RFLDID1 = GENHTAB_1.FLDID       
LEFT OUTER JOIN GENHTAB as GENHTAB_2 ON TOC.RFLDID2<>'' AND TOC.RFLDID2 = GENHTAB_2.FLDID       
LEFT OUTER JOIN GENHTAB as GENHTAB_3 ON TOC.RFLDID3<>'' AND TOC.RFLDID3 = GENHTAB_3.FLDID       
LEFT OUTER JOIN GENHTAB as GENHTAB_4 ON TOC.RFLDID4<>'' AND TOC.RFLDID4 = GENHTAB_4.FLDID       
LEFT OUTER JOIN GENHTAB as GENHTAB_5 ON TOC.RFLDID5<>'' AND TOC.RFLDID5 = GENHTAB_5.FLDID       
WHERE  
RenewalRule.TOC=TOC.TOC and 
TOC.TOC = @P_TOC and 
RenewalRule.RID=@RID
go


-- A menjadi B
DELETE OneCardD Where ID='B' and exists (Select * from OneCardD Where ID='A')
GO


DROP FUNCTION fn_check_Digit
GO
CREATE FUNCTION fn_check_Digit(@ValueS as varchar(50))              
RETURNS Bit
AS               
BEGIN              
Declare @Len as int
Declare @Cnt as int
Declare @Value as int
Declare @Ch as varchar(10)
Declare @NewValueS as varchar(50)
Declare @CheckDigit as varchar(1)
Declare @Digit as int
Declare @Result as bit
 
Select @CheckDigit = right(@ValueS,1)
 
Select @NewValueS=''
Select @Len=Len(@ValueS)-1 --exclude check digit
Select @Cnt=1
 
WHILE @cnt <= @Len 
BEGIN   
   Select @Ch=substring(@valueS,@Cnt,1)
   if charindex(@ch,'0123456789')<>0
   Begin
             Select @Digit = cast(@ch as int)
   End
   else 
       if charindex(@ch,'ABCDEFGHIJKLMNOPQRSTUVWXYZ')<>0
       Begin
             Select @Digit=ascii(@Ch)-55
       End
   else
   Begin
       Select @Digit=0
   End
 
   if @cnt % 2<>0   --Odd
   Begin
             Select @Digit=@Digit * 1
   End
   else
   Begin
             Select @Digit=@Digit * 2
   End
 
   Select @NewValueS = @NewValueS + cast(@Digit as varchar(2))
 
   SET @cnt = @cnt + 1
END;
 
 
Select @ValueS=@NewValueS
 
 
Select @NewValueS=''
Select @Len=Len(@ValueS) 
Select @Cnt=1
Select @Digit=0
 
WHILE @cnt <= @Len 
BEGIN   
   Select @Ch=substring(@valueS,@Cnt,1)
 
   Select @Digit=@Digit + cast(@CH as int)
 
   SET @cnt = @cnt + 1
END;
 
if @Digit % 10=0 
       Select @Digit=0
else
       Select @Digit=@Digit/10*10+10-@Digit
 
if @Digit=cast(@CheckDigit as int) 
Begin
       Select @Result=cast(1 as Bit)
End
else
Begin
       Select @Result=cast(0 as Bit)
End
 
Return @Result
 
END  
 
 
go

--tuning
Create Unique Index I_ActionFlow on ACtionFlow(ActionCodeSrc, ActionCodeDest)
GO
Create Index I_ActionLog_PID on ActionLog(PID)
GO
Create Index I_Admlink_Bank_AccountNo on Admlink(Bank, AccountNo)
GO
Create Index I_CollectionV_CollNo on CollectionV(CollNo)
GO
Create Index I_KOL_Description on KOL(Description)
GO
Create Index I_RateCon_M1_Code on RATECON_M1(Code)
GO
Create Index I_RateCon_M2_Code on RATECON_M2(Code)
GO
Create Index I_RateCon_M3_Code on RATECON_M3(Code)
GO
Create Index I_Scheme_Transaction_PolicyNo_ContractNo on Scheme_Transaction(PolicyNo, ContractNo)
GO
Create Unique Index I_Scheme_Detail on scheme_Detail(TrNo, IntNo, DESCRIPTION)
GO
Create Unique Index I_Scheme_Transhipment on Scheme_Transhipment(TrNo, Code, SDate)
GO
Create Index I_SysBatchSC_BatchNo_ContractNo on SysBatchSC(BatchNo, ContractNo)
GO
Create Index I_VAccount_Bank on VAccount(Bank)
GO
Create Index I_VType_Code_SL_Cat_CodeExt on vType(Code, SL_Cat, CodeExt)
GO


Update nVoucher Set CollNo='' Where CollNo is null
go

DROP Procedure QScheme_Verify_5  
GO
CREATE Procedure QScheme_Verify_5  
@p_TSI as float,  
@P_Coverage as varchar(255),  
@p_SchemeNo as varchar (10),  
@p_Description as varchar (255)  
as  
Select S1.DCode, S1.PCTTSI, S1.PCTCL, S1.FIXEDMIN, S1.FIXEDMAX, S1.Currency, S1.IUNIT, S1.Remarks, S1.TOR, S1.STRTSI  
from Scheme_Deductible S1, Scheme_Class S2, Scheme_Coverage S3, RateCov  
Where  
S1.Coverage=@P_Coverage  
and S1.Lower<=@p_TSI  
and S1.Upper>=@p_TSI  
and S2.ClassNo=S1.ClassNo  
and S2.SchemeNo=@p_SchemeNO  
and @p_Description Like S2.Description  
and S3.Coverage=@P_Coverage  
and S3.ClassNo=S2.ClassNo  
and RateCov.Code=S3.Code  
and S1.TOR=RateCov.TOR  
and S2.Priority in (Select Max(S3.Priority) from Scheme_Class S3 Where S3.SchemeNo=@P_SchemeNo and @P_Description like S3.Description)  
      
go

--tuning withholdingtax
drop Index nSL.I_nSL_pVoucher
GO
drop Index nSL.I_SL_Doc_No
GO
drop index nSL.IX_nSL_PVoucher
GO
Create Index I_nSL_Doc_No_PVoucher on nSL(Doc_No, PVoucher)
go
--VERSIONING
insert into versioning
select '2018 V.1.7.0',GETDATE(),'2018 V.1.7.0',GETDATE(),'K: 2018 V.1.7.0',GETDATE()
go
