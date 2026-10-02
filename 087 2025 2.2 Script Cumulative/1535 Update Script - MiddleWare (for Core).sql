DROP FUNCTION PREMIUM_CANCELLATION_SIMULATION
GO
CREATE FUNCTION PREMIUM_CANCELLATION_SIMULATION(@P_ANO int, @PDate as smalldatetime, @CPCT as Float)

RETURNS @PCALC TABLE (Currency varchar(10), Code varchar(10), SDate SmallDatetime, EDate SmallDatetime, Premium Float, Discount Float)
AS
BEGIN

Declare @NoRefundF as int
Declare @AType as varchar(1)
Declare @RefundType as varchar(100)
Declare @CPFORMULA as varchar(100)
Declare @SDate as smalldatetime

Select @NoRefundF=0
Select @AType='C'
Select @RefundType=''
Select @CPFormula=''


Select @SDate=A2.SDate 
from Acceptance A1, Acceptance A2 
Where A1.ANO=@P_ANO and A2.OANO=A1.OANO and A2.AStatus='I' and A2.AType in ('N','E')

insert into @PCalc
Select Currency, Code, SDate, EDate, sum(Premium) as Premium, sum(Premium*dbo.Premium_Discount(@P_ANO,Code,PolicyYear)/100) as Discount
 from (                  
  select RCalc.Currency, RCalc.Code, RCalc.SDate, RCalc.Edate, cast(datediff(Month,pAcceptance.SDate, RCalc.SDate) as integer) / 12 + 1  as PolicyYear,
  -case     
  When @AType<>'N' and @NoRefundF<>12 and not (@NoRefundF=13 and charindex((case when Cover.ISType in ('I','L') Then 'DI' else 'I'+Cover.ISType end),@RefundType)<>0) and (@NoRefundF in (2,4) or (@NoRefundF in (1) and DateDiff(day, @PDate, RCalc.SDate) <= 0)) Then 0
  when DateDiff(day, rcalc.Edate, @PDate)>=0 and @PDate between pAcceptance.SDate and pacceptance.edate then 0                  
  when DateDiff(day, @PDate, rcalc.SDate)>0 and @PDate between pAcceptance.SDate and pacceptance.edate then 1                  
  Else                  
   case                  
   when @CPCT<>0 or Cover.Voyage=1 then                  
    case                  
    when @CPCT<>0 then                  
		@CPCT/100                  
    Else                  
		1                  
    End                  
   Else                  
    case                  
    When @SDate<>@PDate or @NoRefundF=6 then                  
		--Prorata Calculation
		Case When pAcceptance.EXCLUSIVEF=0 and pAcceptance.STime<pAcceptance.ETime and RCalc.EDate=pAcceptance.EDate Then
			CASE WHEN @CPFORMULA='PRORATE SQ' and @AType='C' THEN
				POWER(dbo.fn_calc_prorata(dbo.fn_Get_Effective_Cancellation_By_Payor_Schedule(@P_ANO, @PDate,dateadd(day,1,RCalc.edate)), dateadd(day,1,RCalc.edate), RCalc.Sdate, dateadd(day,1,RCalc.edate), Cover.PPeriod), 2)
			ELSE
				CASE WHEN @AType='C' THEN
					dbo.fn_calc_prorata(dbo.fn_Get_Effective_Cancellation_By_Payor_Schedule(@P_ANO, @PDate,dateadd(day,1,RCalc.edate)), dateadd(day,1,RCalc.edate), RCalc.Sdate, dateadd(day,1,RCalc.edate), Cover.PPeriod)
				Else
					dbo.fn_calc_prorata(@PDate, dateadd(day,1,RCalc.edate), RCalc.Sdate, dateadd(day,1,RCalc.edate), Cover.PPeriod)
				End
			END			
		else
			CASE WHEN @CPFORMULA='PRORATE SQ' and @AType='C'  THEN
				POWER(dbo.fn_calc_prorata(dbo.fn_Get_Effective_Cancellation_By_Payor_Schedule(@P_ANO, @PDate,RCalc.Edate), RCalc.Edate, RCalc.Sdate, RCalc.EDate, Cover.PPeriod), 2)
			ELSE
				CASE WHEN @AType='C'  THEN
					dbo.fn_calc_prorata(dbo.fn_Get_Effective_Cancellation_By_Payor_Schedule(@P_ANO, @PDate,RCalc.Edate), RCalc.Edate, RCalc.Sdate, RCalc.EDate, Cover.PPeriod)
				Else
					dbo.fn_calc_prorata(@PDate, RCalc.Edate, RCalc.Sdate, RCalc.EDate, Cover.PPeriod)
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
  as Premium      
  from Acceptance pAcceptance 
  inner Join Cover on (Cover.CNO=pAcceptance.CNO)                  
  inner join PCalc on (PCalc.ANO=pAcceptance.ANO) 
  inner join RCalc on (RCalc.ANO=PCalc.ANO and RCalc.Currency=PCalc.Currency)                  
  Left Join ISource on (ISource.CNO=Cover.CNO)
  Where pAcceptance.ANO=@P_ANO and @AType<>'A' 
  and PCalc.Gross<>0                                            
) T                  
Group By Currency, Code, SDate, EDate

RETURN

END


GO

DROP Function fn_GetTotalPremiumByProduct
GO
CREATE Function fn_GetTotalPremiumByProduct(@P_AsAt as smalldatetime,@P_TOPRO as varchar(10),@P_RegID as varchar(10),@P_FLDID as varchar(255),@P_ValueID as varchar(255),@P_OANO as Int)
RETURNS Table            
AS RETURN            
(          
Select 
sum(Case When RCOVER.CATEGORY='M' and ICOVER.CATEGORY='M' THEN ICALC.GROSS-ICALC.LOADING else ICALC.GROSS end*PCALC.RATE) as Premium,
sum(Case When RCOVER.CATEGORY='M' and ICOVER.CATEGORY='M' THEN ICALC.LOADING else 0 end*PCALC.RATE) as ExtraPremium
from PCALC, ICALC, RCOVER, ICOVER
Where PCALC.ANO=ICALC.ANO and PCALC.CURRENCY=ICALC.CURRENCY AND ICOVER.INO=ICALC.INO AND RCOVER.ANO=ICALC.ANO AND RCOVER.CODE=ICALC.CODE AND RCOVER.SDATE=ICALC.SDATE
AND RCOVER.UNIT<>'L'
and exists (
Select Acceptance.ANO
from Acceptance, Cover
Where Cover.CNO=Acceptance.CNO and Acceptance.ANO=PCalc.ANO
and Acceptance.ADate<=@P_AsAt and ((Acceptance.AType in ('E') and Acceptance.AStatus not in ('W','T')) or (Acceptance.AType in ('N') and Acceptance.pStatus='C' and Acceptance.pAStatus<>'W' and Cover.CStatus<>'C' and Cover.ASource='UW'))
and @P_AsAt between Acceptance.PDate and Acceptance.EDate
and Acceptance.OANO<>@P_OANO and Acceptance.TOPRO=@P_TOPRO and Acceptance.RegID=@P_RegID and Acceptance.FLDID=@P_FLDID and Acceptance.ValueID=@P_VALUEID 
and not exists (
Select A.PANO
from Acceptance A, Cover C
Where A.PANO=Acceptance.ANO and C.CNO=A.CNO 
and A.ADate<=@P_AsAt and ((A.AType in ('E','C') and A.AStatus not in ('W','T')) or (A.AType in ('N') and A.pStatus='C' and A.pAStatus<>'W' and C.CStatus<>'C' and C.ASource='UW'))
and @P_AsAt between A.PDate and A.EDate
)
and not exists (
Select A.RANO
from Acceptance A, Cover C
Where A.RANO=Acceptance.ANO and C.CNO=A.CNO 
and A.ADate<=@P_AsAt and ((A.AType in ('E','C') and A.AStatus not in ('W','T')) or (A.AType in ('N') and A.pStatus='C' and A.pAStatus<>'W' and C.CStatus<>'C' and C.ASource='UW'))
and @P_AsAt between A.PDate and A.EDate
) 
and not exists (
Select Claim.ANO
from Claim, CLLOSS
WHere Claim.ANO=Acceptance.ANO and CLLOSS.CNO=Claim.CNO and CLLOSS.CTLF=1 
and Claim.RegDate<=@P_AsAt
and Claim.CStatus in ('P','T','A','C') and Claim.CType in ('N','E')
and Not (Claim.CStatus in ('C') and Claim.pCStatus in ('P') and Claim.CSDate<=@P_AsAt)
and Not Exists (Select pCNO from Claim C Where C.pCNO=Claim.CNO and C.CStatus in ('P','T','A','C') and Claim.RegDate<=@P_AsAt)
)
)
)


GO


DROP Function fn_GetTotalPremiumByPHolder
GO
CREATE Function fn_GetTotalPremiumByPHolder(@P_AsAt as smalldatetime, @P_PHolder as varchar(10),@P_RegID as varchar(10),@P_FLDID as varchar(255),@P_ValueID as varchar(255),@P_OANO as Int)
RETURNS Table            
AS RETURN            
(          
Select 
sum(Case When RCOVER.CATEGORY='M' and ICOVER.CATEGORY='M' THEN ICALC.GROSS-ICALC.LOADING else ICALC.GROSS end*PCALC.RATE) as Premium,
sum(Case When RCOVER.CATEGORY='M' and ICOVER.CATEGORY='M' THEN ICALC.LOADING else 0 end*PCALC.RATE) as ExtraPremium
from PCALC, ICALC, RCOVER, ICOVER
Where PCALC.ANO=ICALC.ANO and PCALC.CURRENCY=ICALC.CURRENCY AND ICOVER.INO=ICALC.INO AND RCOVER.ANO=ICALC.ANO AND RCOVER.CODE=ICALC.CODE AND RCOVER.SDATE=ICALC.SDATE
AND RCOVER.UNIT<>'L'
and exists (
Select Acceptance.ANO, (Select Top 1 RCover.PCTLOSS from RCover Where RCover.Category='M' and RCover.SDate<=@P_AsAt and ((RCover.EDate=Acceptance.EDate and @P_AsAt<=RCover.EDate) or (@P_AsAt<RCover.EDate))) as PCTLOSS
from Acceptance, Cover
Where Cover.CNO=Acceptance.CNO and Acceptance.ANO=PCalc.ANO
and Acceptance.ADate<=@P_AsAt and ((Acceptance.AType in ('E') and Acceptance.AStatus not in ('W','T')) or (Acceptance.AType in ('N') and Acceptance.pStatus='C' and Acceptance.pAStatus<>'W' and Cover.CStatus<>'C' and Cover.ASource='UW'))
and @P_AsAt between Acceptance.PDate and Acceptance.EDate
and Acceptance.OANO<>@P_OANO and Cover.PHolder=@P_PHolder and Acceptance.RegID=@P_RegID and Acceptance.FLDID=@P_FLDID and Acceptance.ValueID=@P_VALUEID 
and not exists (
Select A.PANO
from Acceptance A, Cover C
Where A.PANO=Acceptance.ANO and C.CNO=A.CNO 
and A.ADate<=@P_AsAt and ((A.AType in ('E','C') and A.AStatus not in ('W','T')) or (A.AType in ('N') and A.pStatus='C' and A.pAStatus<>'W' and C.CStatus<>'C' and C.ASource='UW'))
and @P_AsAt between A.PDate and A.EDate
)
and not exists (
Select A.RANO
from Acceptance A, Cover C
Where A.RANO=Acceptance.ANO and C.CNO=A.CNO 
and A.ADate<=@P_AsAt and ((A.AType in ('E','C') and A.AStatus not in ('W','T')) or (A.AType in ('N') and A.pStatus='C' and A.pAStatus<>'W' and C.CStatus<>'C' and C.ASource='UW'))
and @P_AsAt between A.PDate and A.EDate
) 
and not exists (
Select Claim.ANO
from Claim, CLLOSS
WHere Claim.ANO=Acceptance.ANO and CLLOSS.CNO=Claim.CNO and CLLOSS.CTLF=1 
and Claim.RegDate<=@P_AsAt
and Claim.CStatus in ('P','T','A','C') and Claim.CType in ('N','E')
and Not (Claim.CStatus in ('C') and Claim.pCStatus in ('P') and Claim.CSDate<=@P_AsAt)
and Not Exists (Select pCNO from Claim C Where C.pCNO=Claim.CNO and C.CStatus in ('P','T','A','C') and Claim.RegDate<=@P_AsAt)
)
)
)

GO

DROP Function fn_GetTotalPremium
GO
CREATE Function fn_GetTotalPremium(@P_AsAt as smalldatetime,@P_RegID as varchar(10),@P_FLDID as varchar(255),@P_ValueID as varchar(255),@P_OANO as Int)
RETURNS Table            
AS RETURN            
(    
Select 
sum(Case When RCOVER.CATEGORY='M' and ICOVER.CATEGORY='M' THEN ICALC.GROSS-ICALC.LOADING else ICALC.GROSS end*PCALC.RATE) as Premium,
sum(Case When RCOVER.CATEGORY='M' and ICOVER.CATEGORY='M' THEN ICALC.LOADING else 0 end*PCALC.RATE) as ExtraPremium
from PCALC, ICALC, RCOVER, ICOVER
Where PCALC.ANO=ICALC.ANO and PCALC.CURRENCY=ICALC.CURRENCY AND ICOVER.INO=ICALC.INO AND RCOVER.ANO=ICALC.ANO AND RCOVER.CODE=ICALC.CODE AND RCOVER.SDATE=ICALC.SDATE
AND RCOVER.UNIT<>'L'
and exists (      
Select Acceptance.ANO
from Acceptance, Cover
Where Cover.CNO=Acceptance.CNO and Acceptance.ANO=PCALC.ANO
and Acceptance.ADate<=@P_AsAt and ((Acceptance.AType in ('E') and Acceptance.AStatus not in ('W','T')) or (Acceptance.AType in ('N') and Acceptance.pStatus='C' and Acceptance.pAStatus<>'W' and Cover.CStatus<>'C' and Cover.ASource='UW'))
and @P_AsAt between Acceptance.PDate and Acceptance.EDate
and Acceptance.OANO<>@P_OANO and Acceptance.RegID=@P_RegID and Acceptance.FLDID=@P_FLDID and Acceptance.ValueID=@P_VALUEID 
and not exists (
Select A.PANO
from Acceptance A, Cover C
Where A.PANO=Acceptance.ANO and C.CNO=A.CNO 
and A.ADate<=@P_AsAt and ((A.AType in ('E','C') and A.AStatus not in ('W','T')) or (A.AType in ('N') and A.pStatus='C' and A.pAStatus<>'W' and C.CStatus<>'C' and C.ASource='UW'))
and @P_AsAt between A.PDate and A.EDate
)
and not exists (
Select A.RANO
from Acceptance A, Cover C
Where A.RANO=Acceptance.ANO and C.CNO=A.CNO 
and A.ADate<=@P_AsAt and ((A.AType in ('E','C') and A.AStatus not in ('W','T')) or (A.AType in ('N') and A.pStatus='C' and A.pAStatus<>'W' and C.CStatus<>'C' and C.ASource='UW'))
and @P_AsAt between A.PDate and A.EDate
) 
and not exists (
Select Claim.ANO
from Claim, CLLOSS
WHere Claim.ANO=Acceptance.ANO and CLLOSS.CNO=Claim.CNO and CLLOSS.CTLF=1 
and Claim.RegDate<=@P_AsAt
and Claim.CStatus in ('P','T','A','C') and Claim.CType in ('N','E')
and Not (Claim.CStatus in ('C') and Claim.pCStatus in ('P') and Claim.CSDate<=@P_AsAt)
and Not Exists (Select pCNO from Claim C Where C.pCNO=Claim.CNO and C.CStatus in ('P','T','A','C') and Claim.RegDate<=@P_AsAt)
)
)
)

GO

DROP PROCEDURE  GetTOPRatebyObjectInfo
GO
CREATE PROCEDURE  GetTOPRatebyObjectInfo(  
@P_TOPRO as varchar(10),
@P_Code as varchar(20),
@P_TSI as Float,  
@P_SDate as smalldatetime,   
@P_EDate as smalldatetime,  
@P_STime as varchar(5),
@P_ETime as varchar(5),
@P_VALUEID1 as varchar(15),  
@P_VALUEID2 as varchar(15),  
@P_VALUEID3 as varchar(15),  
@P_VALUEID4 as varchar(15),  
@P_VALUEID5 as varchar(15),  
@P_VALUEID6 as varchar(15),  
@P_VALUEID7 as varchar(15),  
@P_VALUEID8 as varchar(15),  
@P_VALUEID9 as varchar(15),  
@P_VALUEID10 as varchar(15),  
@P_VALUEID11 as varchar(15),  
@P_VALUEID12 as varchar(15),  
@P_VALUEID13 as varchar(15),  
@P_VALUEID14 as varchar(15),  
@P_VALUEID15 as varchar(15)  
)       
as   

Declare @SPeriod Int

Declare @ExclusiveF as Bit
Declare @PPeriod as Integer
Declare @Prorata as integer
Declare @PTerm as integer

Select @PPeriod=0

Select @PPeriod=0

Select 
@ExclusiveF=coalesce(TOC.ExclusiveF,0), 
@prorata=coalesce(TOC.prorata,0), 
@P_STime=case When @P_STime<>'' Then @P_STime When coalesce(TOC.DefSTime,'')<>'' then coalesce(TOC.DefSTime,'') else '12:00' end, 
@P_ETime=case When @P_ETime<>'' Then @P_ETime When coalesce(TOC.DefETime,'')<>'' then coalesce(TOC.DefETime,'') else '12:00' end,
@PTerm=coalesce(TOC.PTERM,0),
@SPeriod=coalesce(T.SPeriod,0)
from RateTab T Left Join TOC on (TOC.TOC=T.TOC) 
Where T.Code=@P_Code

if @PTerm=0 
	Select @PTerm=12

if @prorata=0
	Select @Prorata=datediff(day,@P_SDate, dateadd(month,@PTerm,@P_SDate))

Select Top 1 *
From
(
SELECT Top 1 @P_Code as Code, RateCon.CRate as CRate, RateCon.HoldF, RateCon.HoldMessage
From TOPRO_RateCon RateCon
WHERE RateCon.TOPRO=@P_TOPRO and RateCon.Code=@P_Code  
And ((Case When @P_TSI=0 Then 1 Else @P_TSI End)>=RateCon.MinTSI or RateCon.MinTSI=0) and ((Case When @P_TSI=0 Then 1 Else @P_TSI End)<=RateCon.MaxTSI or RateCon.MaxTSI=0)     
And RateCon.ALLOWEDF=1
And (
	 (@SPeriod=0 and (    
	 (ceiling(dbo.fn_Premium_Calc_Prorata(@P_SDate, case When @ExclusiveF=0 and @P_STime<@P_ETime Then dateadd(day,1,@P_EDate) else @P_EDate End,@Prorata,12,CASE WHEN @PPeriod in (0,1,2) Then 2 ELSE @PPeriod END)*12)>=RateCon.MinPeriod)     
	 or RateCon.MinPeriod=0)                               
	 And (    
	 (ceiling(dbo.fn_Premium_Calc_Prorata(@P_SDate, case When @ExclusiveF=0 and @P_STime<@P_ETime Then dateadd(day,1,@P_EDate) else @P_EDate End,@Prorata,12,CASE WHEN @PPeriod in (0,1,2) Then 2 ELSE @PPeriod END)*12)<=RateCon.MaxPeriod)     
	 or RateCon.MaxPeriod=0)) OR
	(@SPeriod=1 
	 and ((datediff(day, @P_SDate, case When @ExclusiveF=0 and @P_STime<@P_ETime Then dateadd(day,1,@P_EDate) else @P_EDate End)>=RateCon.MinPeriod) or RateCon.MinPeriod=0)
	 And ((datediff(day, @P_SDate, case When @ExclusiveF=0 and @P_STime<@P_ETime Then dateadd(day,1,@P_EDate) else @P_EDate End)<=RateCon.MaxPeriod) or RateCon.MaxPeriod=0))
	 ) 
And (coalesce(RateCon.ValueID1,'')='' or @P_VALUEID1 =RateCon.ValueID1)       
And (coalesce(RateCon.ValueID2,'')='' or @P_VALUEID2 =RateCon.ValueID2)       
And (coalesce(RateCon.ValueID3,'')='' or @P_VALUEID3 =RateCon.ValueID3)       
And (coalesce(RateCon.ValueID4,'')='' or @P_VALUEID4 =RateCon.ValueID4)       
And (coalesce(RateCon.ValueID5,'')='' or @P_VALUEID5 =RateCon.ValueID5)       
And (coalesce(RateCon.ValueID6,'')='' or @P_VALUEID6 =RateCon.ValueID6)       
And (coalesce(RateCon.ValueID7,'')='' or @P_VALUEID7 =RateCon.ValueID7)       
And (coalesce(RateCon.ValueID8,'')='' or @P_VALUEID8 =RateCon.ValueID8)       
And (coalesce(RateCon.ValueID9,'')='' or @P_VALUEID9 =RateCon.ValueID9)       
And (coalesce(RateCon.ValueID10,'')='' or @P_VALUEID10 =RateCon.ValueID10)       
And (coalesce(RateCon.ValueID11,'')='' or @P_VALUEID11 =RateCon.ValueID11)       
And (coalesce(RateCon.ValueID12,'')='' or @P_VALUEID12 =RateCon.ValueID12)       
And (coalesce(RateCon.ValueID13,'')='' or @P_VALUEID13 =RateCon.ValueID13)       
And (coalesce(RateCon.ValueID14,'')='' or @P_VALUEID14 =RateCon.ValueID14)       
And (coalesce(RateCon.ValueID15,'')='' or @P_VALUEID15 =RateCon.ValueID15)       
Order by       
RateCon.AllowedF Desc,       
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

) R

GO
DROP PROCEDURE  GetRatebyObjectInfo
GO
CREATE PROCEDURE  GetRatebyObjectInfo(  
@P_Code as varchar(20),
@P_TSI as Float,  
@P_SDate as smalldatetime,   
@P_EDate as smalldatetime,  
@P_STime as varchar(5),
@P_ETime as varchar(5),
@P_VALUEID1 as varchar(15),  
@P_VALUEID2 as varchar(15),  
@P_VALUEID3 as varchar(15),  
@P_VALUEID4 as varchar(15),  
@P_VALUEID5 as varchar(15),  
@P_VALUEID6 as varchar(15),  
@P_VALUEID7 as varchar(15),  
@P_VALUEID8 as varchar(15),  
@P_VALUEID9 as varchar(15),  
@P_VALUEID10 as varchar(15),  
@P_VALUEID11 as varchar(15),  
@P_VALUEID12 as varchar(15),  
@P_VALUEID13 as varchar(15),  
@P_VALUEID14 as varchar(15),  
@P_VALUEID15 as varchar(15)  
)       
as   

Declare @SPeriod Int

Declare @ExclusiveF as Bit
Declare @PPeriod as Integer
Declare @Prorata as integer
Declare @PTerm as integer
Declare @RateLoadingF as bit

Select @PPeriod=0

Select 
@ExclusiveF=coalesce(TOC.ExclusiveF,0), 
@prorata=coalesce(TOC.prorata,0), 
@P_STime=case When @P_STime<>'' Then @P_STime When coalesce(TOC.DefSTime,'')<>'' then coalesce(TOC.DefSTime,'') else '12:00' end, 
@P_ETime=case When @P_ETime<>'' Then @P_ETime When coalesce(TOC.DefETime,'')<>'' then coalesce(TOC.DefETime,'') else '12:00' end,
@PTerm=coalesce(TOC.PTERM,0),
@SPeriod=coalesce(T.SPeriod,0),
@RateLoadingF=coalesce(T.RateLoadingF,0)
from RateTab T Left Join TOC on (TOC.TOC=T.TOC) 
Where T.Code=@P_Code

if @PTerm=0 
	Select @PTerm=12

if @prorata=0
	Select @Prorata=datediff(day,@P_SDate, dateadd(month,@PTerm,@P_SDate))
	
Select Top 1 *
From
(
SELECT Top 1 @P_Code as Code, cast(0 as Bit) as ProgressiveF, RateCon.AllowedF, RateCon.PML, RateCon.TExcess, @RateLoadingF as RateLoadingF,       
Case When coalesce(RateCon.Loading,0)=0 Then 100 else RateCon.Loading end as Loading,       
Case When coalesce(RateCon.PCTLOSS,0)=0 Then 100 else RateCon.PCTLOSS end as PCTLOSS,       
--Rate Always in Percent       
Case       
When RateCon.Unit='F' then (Case When (Case When @P_TSI=0 Then 1 Else @P_TSI End)<>0 Then RateCon.Rate/(Case When @P_TSI=0 Then 1 Else @P_TSI End)*100 else 0 end)       
When RateCon.Unit='M' then RateCon.Rate/10       
else RateCon.Rate end as Rate,       
RateCon.CRate as CRate,
RateCon.MinTSI as MinTSI,
RateCon.MaxTSI as MaxTSI,
case 
When RateCon.minPeriod=0 and RateCon.MaxPeriod=0 then RateCon.MinRate 
Else 
	case 
	When RateTab.SPeriod=1 Then @Prorata/(RateCon.MaxPeriod-RateCon.MinPeriod+1)*RateCon.MinRate
	else Case When @PTerm=0 Then 12 else @PTerm End /(RateCon.MaxPeriod-RateCon.MinPeriod+1)*RateCon.MinRate
	End
End as MinRate,
case 
When RateCon.minPeriod=0 and RateCon.MaxPeriod=0 then RateCon.MaxRate
Else 
	case 
	When RateTab.SPeriod=1 Then @Prorata/(RateCon.MaxPeriod-RateCon.MinPeriod+1)*RateCon.MaxRate
	else Case When @PTerm=0 Then 12 else @PTerm End/(RateCon.MaxPeriod-RateCon.MinPeriod+1)*RateCon.MaxRate
	End
End as MaxRate
From RateTab 
Inner Join RateCon on (RateCon.Code=RateTab.Code)
WHERE RateTab.Code=@P_Code  
And ((Case When @P_TSI=0 Then 1 Else @P_TSI End)>=RateCon.MinTSI or RateCon.MinTSI=0) and ((Case When @P_TSI=0 Then 1 Else @P_TSI End)<=RateCon.MaxTSI or RateCon.MaxTSI=0)     
And RateCon.ALLOWEDF=1
And RateCon.ProgressiveF=0
And (
	 (@SPeriod=0 and (    
	 (ceiling(dbo.fn_Premium_Calc_Prorata(@P_SDate, case When @ExclusiveF=0 and @P_STime<@P_ETime Then dateadd(day,1,@P_EDate) else @P_EDate End,@Prorata,12,CASE WHEN @PPeriod in (0,1,2) Then 2 ELSE @PPeriod END)*12)>=RateCon.MinPeriod)     
	 or RateCon.MinPeriod=0)                               
	 And (    
	 (ceiling(dbo.fn_Premium_Calc_Prorata(@P_SDate, case When @ExclusiveF=0 and @P_STime<@P_ETime Then dateadd(day,1,@P_EDate) else @P_EDate End,@Prorata,12,CASE WHEN @PPeriod in (0,1,2) Then 2 ELSE @PPeriod END)*12)<=RateCon.MaxPeriod)     
	 or RateCon.MaxPeriod=0)) OR
	(@SPeriod=1 
	 and ((datediff(day, @P_SDate, case When @ExclusiveF=0 and @P_STime<@P_ETime Then dateadd(day,1,@P_EDate) else @P_EDate End)>=RateCon.MinPeriod) or RateCon.MinPeriod=0)
	 And ((datediff(day, @P_SDate, case When @ExclusiveF=0 and @P_STime<@P_ETime Then dateadd(day,1,@P_EDate) else @P_EDate End)<=RateCon.MaxPeriod) or RateCon.MaxPeriod=0))
	 ) 
And (coalesce(RateCon.ValueID1,'')='' or @P_VALUEID1 =RateCon.ValueID1)       
And (coalesce(RateCon.ValueID2,'')='' or @P_VALUEID2 =RateCon.ValueID2)       
And (coalesce(RateCon.ValueID3,'')='' or @P_VALUEID3 =RateCon.ValueID3)       
And (coalesce(RateCon.ValueID4,'')='' or @P_VALUEID4 =RateCon.ValueID4)       
And (coalesce(RateCon.ValueID5,'')='' or @P_VALUEID5 =RateCon.ValueID5)       
And (coalesce(RateCon.ValueID6,'')='' or @P_VALUEID6 =RateCon.ValueID6)       
And (coalesce(RateCon.ValueID7,'')='' or @P_VALUEID7 =RateCon.ValueID7)       
And (coalesce(RateCon.ValueID8,'')='' or @P_VALUEID8 =RateCon.ValueID8)       
And (coalesce(RateCon.ValueID9,'')='' or @P_VALUEID9 =RateCon.ValueID9)       
And (coalesce(RateCon.ValueID10,'')='' or @P_VALUEID10 =RateCon.ValueID10)       
And (coalesce(RateCon.ValueID11,'')='' or @P_VALUEID11 =RateCon.ValueID11)       
And (coalesce(RateCon.ValueID12,'')='' or @P_VALUEID12 =RateCon.ValueID12)       
And (coalesce(RateCon.ValueID13,'')='' or @P_VALUEID13 =RateCon.ValueID13)       
And (coalesce(RateCon.ValueID14,'')='' or @P_VALUEID14 =RateCon.ValueID14)       
And (coalesce(RateCon.ValueID15,'')='' or @P_VALUEID15 =RateCon.ValueID15)       
Order by       
RateCon.AllowedF Desc,       
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

Union All

SELECT @P_Code as Code, 
cast(1 as Bit) as ProgressiveF,
Cast(Max(Cast(RateCon.AllowedF as Int)) as Bit) as AllowedF, 
Max(RateCon.PML) as PML, 
Max(RateCon.TExcess) as TExcess, 
@RateLoadingF as RateLoadingF,       
Max(Case When coalesce(RateCon.Loading,0)=0 Then 100 else RateCon.Loading end) as Loading,       
Max(Case When coalesce(RateCon.PCTLOSS,0)=0 Then 100 else RateCon.PCTLOSS end) as PCTLOSS,       
--Rate Always in Percent       
sum(
Case       
When RateCon.Unit='F' then (Case When (Case When @P_TSI=0 Then 1 Else @P_TSI End)<>0 Then RateCon.Rate/(Case When @P_TSI=0 Then 1 Else @P_TSI End)*100 else 0 end)       
When RateCon.Unit='M' then 
Case When (Case When @P_TSI=0 Then 1 Else @P_TSI End)>=RateCon.MaxTSI Then RateCon.MaxTSI-RateCon.MinTSI+1 Else (Case When @P_TSI=0 Then 1 Else @P_TSI End)-RateCon.MinTSI+1 end*RateCon.Rate/10/(Case When @P_TSI=0 Then 1 Else @P_TSI End) 
else Case When (Case When @P_TSI=0 Then 1 Else @P_TSI End)>=RateCon.MaxTSI Then RateCon.MaxTSI-RateCon.MinTSI+1 Else (Case When @P_TSI=0 Then 1 Else @P_TSI End)-RateCon.MinTSI+1 end*RateCon.Rate/(Case When @P_TSI=0 Then 1 Else @P_TSI End) end 
)as Rate,
Max(RateCon.CRate) as CRate,
Min(RateCon.MinTSI) as MinTSI,
Max(RateCon.MaxTSI) as MaxTSI,
sum(Case When (Case When @P_TSI=0 Then 1 Else @P_TSI End)>=RateCon.MaxTSI Then RateCon.MaxTSI-RateCon.MinTSI+1 Else (Case When @P_TSI=0 Then 1 Else @P_TSI End)-RateCon.MinTSI+1 end*RateCon.MinRate/(Case When @P_TSI=0 Then 1 Else @P_TSI End)) as MinRate,
sum(Case When (Case When @P_TSI=0 Then 1 Else @P_TSI End)>=RateCon.MaxTSI Then RateCon.MaxTSI-RateCon.MinTSI+1 Else (Case When @P_TSI=0 Then 1 Else @P_TSI End)-RateCon.MinTSI+1 end*RateCon.MaxRate/(Case When @P_TSI=0 Then 1 Else @P_TSI End)) as MaxRate  
From RateCon
WHERE RateCon.Code=@P_Code  
And ((Case When @P_TSI=0 Then 1 Else @P_TSI End) Between RateCon.MinTSI and RateCon.MaxTSI or RateCon.MaxTSI<=(Case When @P_TSI=0 Then 1 Else @P_TSI End))
And RateCon.ALLOWEDF=1
And RateCon.ProgressiveF=1
And (
	 (@SPeriod=0 and (    
	 (ceiling(dbo.fn_Premium_Calc_Prorata(@P_SDate, case When @ExclusiveF=0 and @P_STime<@P_ETime Then dateadd(day,1,@P_EDate) else @P_EDate End,@Prorata,12,CASE WHEN @PPeriod in (0,1,2) Then 2 ELSE @PPeriod END)*12)>=RateCon.MinPeriod)     
	 or RateCon.MinPeriod=0)                               
	 And (    
	 (ceiling(dbo.fn_Premium_Calc_Prorata(@P_SDate, case When @ExclusiveF=0 and @P_STime<@P_ETime Then dateadd(day,1,@P_EDate) else @P_EDate End,@Prorata,12,CASE WHEN @PPeriod in (0,1,2) Then 2 ELSE @PPeriod END)*12)<=RateCon.MaxPeriod)     
	 or RateCon.MaxPeriod=0)) OR
	(@SPeriod=1 
	 and ((datediff(day, @P_SDate, case When @ExclusiveF=0 and @P_STime<@P_ETime Then dateadd(day,1,@P_EDate) else @P_EDate End)>=RateCon.MinPeriod) or RateCon.MinPeriod=0)
	 And ((datediff(day, @P_SDate, case When @ExclusiveF=0 and @P_STime<@P_ETime Then dateadd(day,1,@P_EDate) else @P_EDate End)<=RateCon.MaxPeriod) or RateCon.MaxPeriod=0))
	 )   
And (coalesce(RateCon.ValueID1,'')='' or @P_VALUEID1 =RateCon.ValueID1)       
And (coalesce(RateCon.ValueID2,'')='' or @P_VALUEID2 =RateCon.ValueID2)       
And (coalesce(RateCon.ValueID3,'')='' or @P_VALUEID3 =RateCon.ValueID3)       
And (coalesce(RateCon.ValueID4,'')='' or @P_VALUEID4 =RateCon.ValueID4)       
And (coalesce(RateCon.ValueID5,'')='' or @P_VALUEID5 =RateCon.ValueID5)       
And (coalesce(RateCon.ValueID6,'')='' or @P_VALUEID6 =RateCon.ValueID6)       
And (coalesce(RateCon.ValueID7,'')='' or @P_VALUEID7 =RateCon.ValueID7)       
And (coalesce(RateCon.ValueID8,'')='' or @P_VALUEID8 =RateCon.ValueID8)       
And (coalesce(RateCon.ValueID9,'')='' or @P_VALUEID9 =RateCon.ValueID9)       
And (coalesce(RateCon.ValueID10,'')='' or @P_VALUEID10 =RateCon.ValueID10)       
And (coalesce(RateCon.ValueID11,'')='' or @P_VALUEID11 =RateCon.ValueID11)       
And (coalesce(RateCon.ValueID12,'')='' or @P_VALUEID12 =RateCon.ValueID12)       
And (coalesce(RateCon.ValueID13,'')='' or @P_VALUEID13 =RateCon.ValueID13)       
And (coalesce(RateCon.ValueID14,'')='' or @P_VALUEID14 =RateCon.ValueID14)       
And (coalesce(RateCon.ValueID15,'')='' or @P_VALUEID15 =RateCon.ValueID15)         
Group By RATECON.CODE
) R


GO
DROP PROCEDURE GetRateLoadingByObjectInfo
GO
CREATE PROCEDURE GetRateLoadingByObjectInfo(
@P_TSI as Float, 
@P_SDate as smalldatetime, 
@P_EDate as smalldatetime,
@P_STime as varchar(5),
@P_ETime as varchar(5),
@P_TOPRO as varchar(10), 
@P_Code as varchar(20), 
@P_PHolder as varchar(10), 
@P_RegID as varchar(10), 
@P_FLDID as varchar(255),
@P_VALUEID as varchar(255),
@P_VALUEID1 as varchar(15),  
@P_VALUEID2 as varchar(15),  
@P_VALUEID3 as varchar(15),  
@P_VALUEID4 as varchar(15),  
@P_VALUEID5 as varchar(15),  
@P_VALUEID6 as varchar(15),  
@P_VALUEID7 as varchar(15),  
@P_VALUEID8 as varchar(15),  
@P_VALUEID9 as varchar(15),  
@P_VALUEID10 as varchar(15),  
@P_VALUEID11 as varchar(15),  
@P_VALUEID12 as varchar(15),  
@P_VALUEID13 as varchar(15),  
@P_VALUEID14 as varchar(15),  
@P_VALUEID15 as varchar(15)  
) 
AS        
  
Declare @Loading as Float
Declare @HoldF as Bit
Declare @HoldMessage as varchar(512)
Declare @CID as varchar(512)

Declare @Temp_Loading as Float
Declare @Temp_HoldF as Bit
Declare @Temp_HoldMessage as varchar(512)
Declare @Temp_CID as varchar(512)

Declare @P_PDate as smalldatetime

Select @P_PDate=cast(convert(varchar(10), getdate(),1) as smalldatetime)

Select @Loading=1
Select @HoldF=0
Select @HoldMessage=''
Select @CID=''

Declare @CheckRateConSIBy int
Declare @SPeriod Int

Declare @ExclusiveF as Bit
Declare @PPeriod as Integer
Declare @Prorata as integer
Declare @PTerm as integer

Select @PPeriod=0

Declare @P_TOC varchar(10) 

Select @P_TOC=T.TOC, @CheckRateConSIBy=T.CheckRateConSIBy
from TOPRO T
Where T.TOPRO=@P_TOPRO

if @P_TOC is null
	Select @P_TOC=@P_TOPRO

if @CheckRateConSIBy is null
	Select @CheckRateConSIBy=0

Select 
@ExclusiveF=TOC.ExclusiveF, 
@prorata=TOC.prorata, 
@P_STime=case When @P_STime<>'' Then @P_STime When coalesce(TOC.DefSTime,'')<>'' then coalesce(TOC.DefSTime,'') else '12:00' end, 
@P_ETime=case When @P_ETime<>'' Then @P_ETime When coalesce(TOC.DefETime,'')<>'' then coalesce(TOC.DefETime,'') else '12:00' end,
@PTerm=TOC.PTERM 
from TOC
Where TOC.TOC=@P_TOC

if @PTerm=0 
	Select @PTerm=12

if @prorata=0
	Select @Prorata=datediff(day,@P_SDate, dateadd(month,@PTerm,@P_SDate))

select @SPeriod=coalesce(R.SPeriod,0) From RateTab R Where R.Code=@P_Code

Select @P_TSI=@P_TSI+case 
When @CheckRateConSIBy=1 Then dbo.fn_GetTotalSumInsuredByProduct(@P_PDate,@P_TOPRO,@P_RegID, @P_FLDID, @P_VALUEID,-1)
When @CheckRateConSIBy=2 Then dbo.fn_GetTotalSumInsuredByPHolder(@P_PDate,@P_PHolder,@P_RegID, @P_FLDID, @P_VALUEID,-1)
When @CheckRateConSIBy=3 Then dbo.fn_GetTotalSumInsured(@P_PDate,@P_RegID, @P_FLDID, @P_VALUEID,-1)
When @CheckRateConSIBy=4 Then dbo.fn_GetTotalSumInsuredByProductAndPHolder(@P_PDate,@P_TOPRO, @P_PHolder, -1)
When @CheckRateConSIBy=5 Then dbo.fn_GetTotalSumInsuredByProductAndInsured(@P_PDate,@P_TOPRO, @P_PHolder, -1)	

else 0
end

--Rate Loading #1
Select @Temp_Loading=Null
Select @Temp_HoldF=Null
Select @Temp_HoldMessage=Null
Select @Temp_CID=Null

SELECT Top 1 @Temp_Loading=RateCon.Loading, @Temp_HoldF=RateCon.HoldF, @Temp_HoldMessage=RateCon.HoldMessage, @Temp_CID=RateCon.CID
From RateCon_M1 RateCon 
WHERE RateCon.Code=@P_Code and RateCon.AllowedF=1      
And ((Case When @P_TSI=0 Then 1 Else @P_TSI End)>=RateCon.MinTSI or RateCon.MinTSI=0) 
and ((Case When @P_TSI=0 Then 1 Else @P_TSI End)<=RateCon.MaxTSI or RateCon.MaxTSI=0)     
And (
	 (@SPeriod=0 and (    
	 (ceiling(dbo.fn_Premium_Calc_Prorata(@P_SDate, case When @ExclusiveF=0 and @P_STime<@P_ETime Then dateadd(day,1,@P_EDate) else @P_EDate End,@Prorata,12,CASE WHEN @PPeriod in (0,1,2) Then 2 ELSE @PPeriod END)*12)>=RateCon.MinPeriod)     
	 or RateCon.MinPeriod=0)                               
	 And (    
	 (ceiling(dbo.fn_Premium_Calc_Prorata(@P_SDate, case When @ExclusiveF=0 and @P_STime<@P_ETime Then dateadd(day,1,@P_EDate) else @P_EDate End,@Prorata,12,CASE WHEN @PPeriod in (0,1,2) Then 2 ELSE @PPeriod END)*12)<=RateCon.MaxPeriod)     
	 or RateCon.MaxPeriod=0)) OR
	(@SPeriod=1 
	 and ((datediff(day, @P_SDate, case When @ExclusiveF=0 and @P_STime<@P_ETime Then dateadd(day,1,@P_EDate) else @P_EDate End)>=RateCon.MinPeriod) or RateCon.MinPeriod=0)
	 And ((datediff(day, @P_SDate, case When @ExclusiveF=0 and @P_STime<@P_ETime Then dateadd(day,1,@P_EDate) else @P_EDate End)<=RateCon.MaxPeriod) or RateCon.MaxPeriod=0))
	 ) 
And (coalesce(RateCon.ValueID1,'')='' or @P_VALUEID1 =RateCon.ValueID1)       
And (coalesce(RateCon.ValueID2,'')='' or @P_VALUEID2 =RateCon.ValueID2)       
And (coalesce(RateCon.ValueID3,'')='' or @P_VALUEID3 =RateCon.ValueID3)       
And (coalesce(RateCon.ValueID4,'')='' or @P_VALUEID4 =RateCon.ValueID4)       
And (coalesce(RateCon.ValueID5,'')='' or @P_VALUEID5 =RateCon.ValueID5)       
And (coalesce(RateCon.ValueID6,'')='' or @P_VALUEID6 =RateCon.ValueID6)       
And (coalesce(RateCon.ValueID7,'')='' or @P_VALUEID7 =RateCon.ValueID7)       
And (coalesce(RateCon.ValueID8,'')='' or @P_VALUEID8 =RateCon.ValueID8)       
And (coalesce(RateCon.ValueID9,'')='' or @P_VALUEID9 =RateCon.ValueID9)       
And (coalesce(RateCon.ValueID10,'')='' or @P_VALUEID10 =RateCon.ValueID10)       
And (coalesce(RateCon.ValueID11,'')='' or @P_VALUEID11 =RateCon.ValueID11)       
And (coalesce(RateCon.ValueID12,'')='' or @P_VALUEID12 =RateCon.ValueID12)       
And (coalesce(RateCon.ValueID13,'')='' or @P_VALUEID13 =RateCon.ValueID13)       
And (coalesce(RateCon.ValueID14,'')='' or @P_VALUEID14 =RateCon.ValueID14)       
And (coalesce(RateCon.ValueID15,'')='' or @P_VALUEID15 =RateCon.ValueID15)       
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

if @Temp_CID is null
Select @Temp_CID=''

if @Temp_CID<>''
Begin
Select @CID=@CID+'|'+@Temp_CID
End

--Rate Loading #2
Select @Temp_Loading=Null
Select @Temp_HoldF=Null
Select @Temp_HoldMessage=Null
Select @Temp_CID=Null

SELECT Top 1 @Temp_Loading=RateCon.Loading, @Temp_HoldF=RateCon.HoldF, @Temp_HoldMessage=RateCon.HoldMessage, @Temp_CID=RateCon.CID
From RateCon_M2 RateCon 
WHERE RateCon.Code=@P_Code and RateCon.AllowedF=1      
And ((Case When @P_TSI=0 Then 1 Else @P_TSI End)>=RateCon.MinTSI or RateCon.MinTSI=0) 
and ((Case When @P_TSI=0 Then 1 Else @P_TSI End)<=RateCon.MaxTSI or RateCon.MaxTSI=0)     
And (
	 (@SPeriod=0 and (    
	 (ceiling(dbo.fn_Premium_Calc_Prorata(@P_SDate, case When @ExclusiveF=0 and @P_STime<@P_ETime Then dateadd(day,1,@P_EDate) else @P_EDate End,@Prorata,12,CASE WHEN @PPeriod in (0,1,2) Then 2 ELSE @PPeriod END)*12)>=RateCon.MinPeriod)     
	 or RateCon.MinPeriod=0)                               
	 And (    
	 (ceiling(dbo.fn_Premium_Calc_Prorata(@P_SDate, case When @ExclusiveF=0 and @P_STime<@P_ETime Then dateadd(day,1,@P_EDate) else @P_EDate End,@Prorata,12,CASE WHEN @PPeriod in (0,1,2) Then 2 ELSE @PPeriod END)*12)<=RateCon.MaxPeriod)     
	 or RateCon.MaxPeriod=0)) OR
	(@SPeriod=1 
	 and ((datediff(day, @P_SDate, case When @ExclusiveF=0 and @P_STime<@P_ETime Then dateadd(day,1,@P_EDate) else @P_EDate End)>=RateCon.MinPeriod) or RateCon.MinPeriod=0)
	 And ((datediff(day, @P_SDate, case When @ExclusiveF=0 and @P_STime<@P_ETime Then dateadd(day,1,@P_EDate) else @P_EDate End)<=RateCon.MaxPeriod) or RateCon.MaxPeriod=0))
	 )  
And (coalesce(RateCon.ValueID1,'')='' or @P_VALUEID1 =RateCon.ValueID1)       
And (coalesce(RateCon.ValueID2,'')='' or @P_VALUEID2 =RateCon.ValueID2)       
And (coalesce(RateCon.ValueID3,'')='' or @P_VALUEID3 =RateCon.ValueID3)       
And (coalesce(RateCon.ValueID4,'')='' or @P_VALUEID4 =RateCon.ValueID4)       
And (coalesce(RateCon.ValueID5,'')='' or @P_VALUEID5 =RateCon.ValueID5)       
And (coalesce(RateCon.ValueID6,'')='' or @P_VALUEID6 =RateCon.ValueID6)       
And (coalesce(RateCon.ValueID7,'')='' or @P_VALUEID7 =RateCon.ValueID7)       
And (coalesce(RateCon.ValueID8,'')='' or @P_VALUEID8 =RateCon.ValueID8)       
And (coalesce(RateCon.ValueID9,'')='' or @P_VALUEID9 =RateCon.ValueID9)       
And (coalesce(RateCon.ValueID10,'')='' or @P_VALUEID10 =RateCon.ValueID10)       
And (coalesce(RateCon.ValueID11,'')='' or @P_VALUEID11 =RateCon.ValueID11)       
And (coalesce(RateCon.ValueID12,'')='' or @P_VALUEID12 =RateCon.ValueID12)       
And (coalesce(RateCon.ValueID13,'')='' or @P_VALUEID13 =RateCon.ValueID13)       
And (coalesce(RateCon.ValueID14,'')='' or @P_VALUEID14 =RateCon.ValueID14)       
And (coalesce(RateCon.ValueID15,'')='' or @P_VALUEID15 =RateCon.ValueID15)       
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

if @Temp_CID is null
Select @Temp_CID=''

if @Temp_CID<>''
Begin
Select @CID=@CID+'|'+@Temp_CID
End

--Rate Loading #3
Select @Temp_Loading=Null
Select @Temp_HoldF=Null
Select @Temp_HoldMessage=Null
Select @Temp_CID=Null

SELECT Top 1 @Temp_Loading=RateCon.Loading,@Temp_HoldF=RateCon.HoldF, @Temp_HoldMessage=RateCon.HoldMessage, @Temp_CID=RateCon.CID
From RateCon_M3 RateCon 
WHERE RateCon.Code=@P_Code and RateCon.AllowedF=1      
And ((Case When @P_TSI=0 Then 1 Else @P_TSI End)>=RateCon.MinTSI or RateCon.MinTSI=0) 
and ((Case When @P_TSI=0 Then 1 Else @P_TSI End)<=RateCon.MaxTSI or RateCon.MaxTSI=0)     
And (
	 (@SPeriod=0 and (    
	 (ceiling(dbo.fn_Premium_Calc_Prorata(@P_SDate, case When @ExclusiveF=0 and @P_STime<@P_ETime Then dateadd(day,1,@P_EDate) else @P_EDate End,@Prorata,12,CASE WHEN @PPeriod in (0,1,2) Then 2 ELSE @PPeriod END)*12)>=RateCon.MinPeriod)     
	 or RateCon.MinPeriod=0)                               
	 And (    
	 (ceiling(dbo.fn_Premium_Calc_Prorata(@P_SDate, case When @ExclusiveF=0 and @P_STime<@P_ETime Then dateadd(day,1,@P_EDate) else @P_EDate End,@Prorata,12,CASE WHEN @PPeriod in (0,1,2) Then 2 ELSE @PPeriod END)*12)<=RateCon.MaxPeriod)     
	 or RateCon.MaxPeriod=0)) OR
	(@SPeriod=1 
	 and ((datediff(day, @P_SDate, case When @ExclusiveF=0 and @P_STime<@P_ETime Then dateadd(day,1,@P_EDate) else @P_EDate End)>=RateCon.MinPeriod) or RateCon.MinPeriod=0)
	 And ((datediff(day, @P_SDate, case When @ExclusiveF=0 and @P_STime<@P_ETime Then dateadd(day,1,@P_EDate) else @P_EDate End)<=RateCon.MaxPeriod) or RateCon.MaxPeriod=0))
	 ) 
And (coalesce(RateCon.ValueID1,'')='' or @P_VALUEID1 =RateCon.ValueID1)       
And (coalesce(RateCon.ValueID2,'')='' or @P_VALUEID2 =RateCon.ValueID2)       
And (coalesce(RateCon.ValueID3,'')='' or @P_VALUEID3 =RateCon.ValueID3)       
And (coalesce(RateCon.ValueID4,'')='' or @P_VALUEID4 =RateCon.ValueID4)       
And (coalesce(RateCon.ValueID5,'')='' or @P_VALUEID5 =RateCon.ValueID5)       
And (coalesce(RateCon.ValueID6,'')='' or @P_VALUEID6 =RateCon.ValueID6)       
And (coalesce(RateCon.ValueID7,'')='' or @P_VALUEID7 =RateCon.ValueID7)       
And (coalesce(RateCon.ValueID8,'')='' or @P_VALUEID8 =RateCon.ValueID8)       
And (coalesce(RateCon.ValueID9,'')='' or @P_VALUEID9 =RateCon.ValueID9)       
And (coalesce(RateCon.ValueID10,'')='' or @P_VALUEID10 =RateCon.ValueID10)       
And (coalesce(RateCon.ValueID11,'')='' or @P_VALUEID11 =RateCon.ValueID11)       
And (coalesce(RateCon.ValueID12,'')='' or @P_VALUEID12 =RateCon.ValueID12)       
And (coalesce(RateCon.ValueID13,'')='' or @P_VALUEID13 =RateCon.ValueID13)       
And (coalesce(RateCon.ValueID14,'')='' or @P_VALUEID14 =RateCon.ValueID14)       
And (coalesce(RateCon.ValueID15,'')='' or @P_VALUEID15 =RateCon.ValueID15)       
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

if @Temp_CID is null
Select @Temp_CID=''

if @Temp_CID<>''
Begin
Select @CID=@CID+'|'+@Temp_CID
End

--Rate Loading #4
Select @Temp_Loading=Null
Select @Temp_HoldF=Null
Select @Temp_HoldMessage=Null
Select @Temp_CID=Null

SELECT Top 1 @Temp_Loading=RateCon.Loading, @Temp_HoldF=RateCon.HoldF, @Temp_HoldMessage=RateCon.HoldMessage, @Temp_CID=RateCon.CID
From RateCon_M4 RateCon 
WHERE RateCon.Code=@P_Code and RateCon.AllowedF=1      
And ((Case When @P_TSI=0 Then 1 Else @P_TSI End)>=RateCon.MinTSI or RateCon.MinTSI=0) 
and ((Case When @P_TSI=0 Then 1 Else @P_TSI End)<=RateCon.MaxTSI or RateCon.MaxTSI=0)     
And (
	 (@SPeriod=0 and (    
	 (ceiling(dbo.fn_Premium_Calc_Prorata(@P_SDate, case When @ExclusiveF=0 and @P_STime<@P_ETime Then dateadd(day,1,@P_EDate) else @P_EDate End,@Prorata,12,CASE WHEN @PPeriod in (0,1,2) Then 2 ELSE @PPeriod END)*12)>=RateCon.MinPeriod)     
	 or RateCon.MinPeriod=0)                               
	 And (    
	 (ceiling(dbo.fn_Premium_Calc_Prorata(@P_SDate, case When @ExclusiveF=0 and @P_STime<@P_ETime Then dateadd(day,1,@P_EDate) else @P_EDate End,@Prorata,12,CASE WHEN @PPeriod in (0,1,2) Then 2 ELSE @PPeriod END)*12)<=RateCon.MaxPeriod)     
	 or RateCon.MaxPeriod=0)) OR
	(@SPeriod=1 
	 and ((datediff(day, @P_SDate, case When @ExclusiveF=0 and @P_STime<@P_ETime Then dateadd(day,1,@P_EDate) else @P_EDate End)>=RateCon.MinPeriod) or RateCon.MinPeriod=0)
	 And ((datediff(day, @P_SDate, case When @ExclusiveF=0 and @P_STime<@P_ETime Then dateadd(day,1,@P_EDate) else @P_EDate End)<=RateCon.MaxPeriod) or RateCon.MaxPeriod=0))
	 )      
And (coalesce(RateCon.ValueID1,'')='' or @P_VALUEID1 =RateCon.ValueID1)       
And (coalesce(RateCon.ValueID2,'')='' or @P_VALUEID2 =RateCon.ValueID2)       
And (coalesce(RateCon.ValueID3,'')='' or @P_VALUEID3 =RateCon.ValueID3)       
And (coalesce(RateCon.ValueID4,'')='' or @P_VALUEID4 =RateCon.ValueID4)       
And (coalesce(RateCon.ValueID5,'')='' or @P_VALUEID5 =RateCon.ValueID5)       
And (coalesce(RateCon.ValueID6,'')='' or @P_VALUEID6 =RateCon.ValueID6)       
And (coalesce(RateCon.ValueID7,'')='' or @P_VALUEID7 =RateCon.ValueID7)       
And (coalesce(RateCon.ValueID8,'')='' or @P_VALUEID8 =RateCon.ValueID8)       
And (coalesce(RateCon.ValueID9,'')='' or @P_VALUEID9 =RateCon.ValueID9)       
And (coalesce(RateCon.ValueID10,'')='' or @P_VALUEID10 =RateCon.ValueID10)       
And (coalesce(RateCon.ValueID11,'')='' or @P_VALUEID11 =RateCon.ValueID11)       
And (coalesce(RateCon.ValueID12,'')='' or @P_VALUEID12 =RateCon.ValueID12)       
And (coalesce(RateCon.ValueID13,'')='' or @P_VALUEID13 =RateCon.ValueID13)       
And (coalesce(RateCon.ValueID14,'')='' or @P_VALUEID14 =RateCon.ValueID14)       
And (coalesce(RateCon.ValueID15,'')='' or @P_VALUEID15 =RateCon.ValueID15)       
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

if @Temp_CID is null
Select @Temp_CID=''

if @Temp_CID<>''
Begin
Select @CID=@CID+'|'+@Temp_CID
End

--Rate Loading #5
Select @Temp_Loading=Null
Select @Temp_HoldF=Null
Select @Temp_HoldMessage=Null
Select @Temp_CID=Null

SELECT Top 1 @Temp_Loading=RateCon.Loading, @Temp_HoldF=RateCon.HoldF, @Temp_HoldMessage=RateCon.HoldMessage, @Temp_CID=RateCon.CID
From RateCon_M5 RateCon 
WHERE RateCon.Code=@P_Code and RateCon.AllowedF=1      
And ((Case When @P_TSI=0 Then 1 Else @P_TSI End)>=RateCon.MinTSI or RateCon.MinTSI=0) 
and ((Case When @P_TSI=0 Then 1 Else @P_TSI End)<=RateCon.MaxTSI or RateCon.MaxTSI=0)     
And (
	 (@SPeriod=0 and (    
	 (ceiling(dbo.fn_Premium_Calc_Prorata(@P_SDate, case When @ExclusiveF=0 and @P_STime<@P_ETime Then dateadd(day,1,@P_EDate) else @P_EDate End,@Prorata,12,CASE WHEN @PPeriod in (0,1,2) Then 2 ELSE @PPeriod END)*12)>=RateCon.MinPeriod)     
	 or RateCon.MinPeriod=0)                               
	 And (    
	 (ceiling(dbo.fn_Premium_Calc_Prorata(@P_SDate, case When @ExclusiveF=0 and @P_STime<@P_ETime Then dateadd(day,1,@P_EDate) else @P_EDate End,@Prorata,12,CASE WHEN @PPeriod in (0,1,2) Then 2 ELSE @PPeriod END)*12)<=RateCon.MaxPeriod)     
	 or RateCon.MaxPeriod=0)) OR
	(@SPeriod=1 
	 and ((datediff(day, @P_SDate, case When @ExclusiveF=0 and @P_STime<@P_ETime Then dateadd(day,1,@P_EDate) else @P_EDate End)>=RateCon.MinPeriod) or RateCon.MinPeriod=0)
	 And ((datediff(day, @P_SDate, case When @ExclusiveF=0 and @P_STime<@P_ETime Then dateadd(day,1,@P_EDate) else @P_EDate End)<=RateCon.MaxPeriod) or RateCon.MaxPeriod=0))
	 )      
And (coalesce(RateCon.ValueID1,'')='' or @P_VALUEID1 =RateCon.ValueID1)       
And (coalesce(RateCon.ValueID2,'')='' or @P_VALUEID2 =RateCon.ValueID2)       
And (coalesce(RateCon.ValueID3,'')='' or @P_VALUEID3 =RateCon.ValueID3)       
And (coalesce(RateCon.ValueID4,'')='' or @P_VALUEID4 =RateCon.ValueID4)       
And (coalesce(RateCon.ValueID5,'')='' or @P_VALUEID5 =RateCon.ValueID5)       
And (coalesce(RateCon.ValueID6,'')='' or @P_VALUEID6 =RateCon.ValueID6)       
And (coalesce(RateCon.ValueID7,'')='' or @P_VALUEID7 =RateCon.ValueID7)       
And (coalesce(RateCon.ValueID8,'')='' or @P_VALUEID8 =RateCon.ValueID8)       
And (coalesce(RateCon.ValueID9,'')='' or @P_VALUEID9 =RateCon.ValueID9)       
And (coalesce(RateCon.ValueID10,'')='' or @P_VALUEID10 =RateCon.ValueID10)       
And (coalesce(RateCon.ValueID11,'')='' or @P_VALUEID11 =RateCon.ValueID11)       
And (coalesce(RateCon.ValueID12,'')='' or @P_VALUEID12 =RateCon.ValueID12)       
And (coalesce(RateCon.ValueID13,'')='' or @P_VALUEID13 =RateCon.ValueID13)       
And (coalesce(RateCon.ValueID14,'')='' or @P_VALUEID14 =RateCon.ValueID14)       
And (coalesce(RateCon.ValueID15,'')='' or @P_VALUEID15 =RateCon.ValueID15)       
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

if @Temp_CID is null
Select @Temp_CID=''

if @Temp_CID<>''
Begin
Select @CID=@CID+'|'+@Temp_CID
End

--Rate Loading #6
Select @Temp_Loading=Null
Select @Temp_HoldF=Null
Select @Temp_HoldMessage=Null
Select @Temp_CID=Null

SELECT Top 1 @Temp_Loading=RateCon.Loading, @Temp_HoldF=RateCon.HoldF, @Temp_HoldMessage=RateCon.HoldMessage, @Temp_CID=RateCon.CID
From RateCon_M6 RateCon 
WHERE RateCon.Code=@P_Code and RateCon.AllowedF=1      
And ((Case When @P_TSI=0 Then 1 Else @P_TSI End)>=RateCon.MinTSI or RateCon.MinTSI=0) 
and ((Case When @P_TSI=0 Then 1 Else @P_TSI End)<=RateCon.MaxTSI or RateCon.MaxTSI=0)     
And (
	 (@SPeriod=0 and (    
	 (ceiling(dbo.fn_Premium_Calc_Prorata(@P_SDate, case When @ExclusiveF=0 and @P_STime<@P_ETime Then dateadd(day,1,@P_EDate) else @P_EDate End,@Prorata,12,CASE WHEN @PPeriod in (0,1,2) Then 2 ELSE @PPeriod END)*12)>=RateCon.MinPeriod)     
	 or RateCon.MinPeriod=0)                               
	 And (    
	 (ceiling(dbo.fn_Premium_Calc_Prorata(@P_SDate, case When @ExclusiveF=0 and @P_STime<@P_ETime Then dateadd(day,1,@P_EDate) else @P_EDate End,@Prorata,12,CASE WHEN @PPeriod in (0,1,2) Then 2 ELSE @PPeriod END)*12)<=RateCon.MaxPeriod)     
	 or RateCon.MaxPeriod=0)) OR
	(@SPeriod=1 
	 and ((datediff(day, @P_SDate, case When @ExclusiveF=0 and @P_STime<@P_ETime Then dateadd(day,1,@P_EDate) else @P_EDate End)>=RateCon.MinPeriod) or RateCon.MinPeriod=0)
	 And ((datediff(day, @P_SDate, case When @ExclusiveF=0 and @P_STime<@P_ETime Then dateadd(day,1,@P_EDate) else @P_EDate End)<=RateCon.MaxPeriod) or RateCon.MaxPeriod=0))
	 )      
And (coalesce(RateCon.ValueID1,'')='' or @P_VALUEID1 =RateCon.ValueID1)       
And (coalesce(RateCon.ValueID2,'')='' or @P_VALUEID2 =RateCon.ValueID2)       
And (coalesce(RateCon.ValueID3,'')='' or @P_VALUEID3 =RateCon.ValueID3)       
And (coalesce(RateCon.ValueID4,'')='' or @P_VALUEID4 =RateCon.ValueID4)       
And (coalesce(RateCon.ValueID5,'')='' or @P_VALUEID5 =RateCon.ValueID5)       
And (coalesce(RateCon.ValueID6,'')='' or @P_VALUEID6 =RateCon.ValueID6)       
And (coalesce(RateCon.ValueID7,'')='' or @P_VALUEID7 =RateCon.ValueID7)       
And (coalesce(RateCon.ValueID8,'')='' or @P_VALUEID8 =RateCon.ValueID8)       
And (coalesce(RateCon.ValueID9,'')='' or @P_VALUEID9 =RateCon.ValueID9)       
And (coalesce(RateCon.ValueID10,'')='' or @P_VALUEID10 =RateCon.ValueID10)       
And (coalesce(RateCon.ValueID11,'')='' or @P_VALUEID11 =RateCon.ValueID11)       
And (coalesce(RateCon.ValueID12,'')='' or @P_VALUEID12 =RateCon.ValueID12)       
And (coalesce(RateCon.ValueID13,'')='' or @P_VALUEID13 =RateCon.ValueID13)       
And (coalesce(RateCon.ValueID14,'')='' or @P_VALUEID14 =RateCon.ValueID14)       
And (coalesce(RateCon.ValueID15,'')='' or @P_VALUEID15 =RateCon.ValueID15)       
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

if @Temp_CID is null
Select @Temp_CID=''

if @Temp_CID<>''
Begin
Select @CID=@CID+'|'+@Temp_CID
End

--Rate Loading #7
Select @Temp_Loading=Null
Select @Temp_HoldF=Null
Select @Temp_HoldMessage=Null
Select @Temp_CID=Null

SELECT Top 1 @Temp_Loading=RateCon.Loading, @Temp_HoldF=RateCon.HoldF, @Temp_HoldMessage=RateCon.HoldMessage, @Temp_CID=RateCon.CID
From RateCon_M7 RateCon 
WHERE RateCon.Code=@P_Code and RateCon.AllowedF=1      
And ((Case When @P_TSI=0 Then 1 Else @P_TSI End)>=RateCon.MinTSI or RateCon.MinTSI=0) 
and ((Case When @P_TSI=0 Then 1 Else @P_TSI End)<=RateCon.MaxTSI or RateCon.MaxTSI=0)     
And (
	 (@SPeriod=0 and (    
	 (ceiling(dbo.fn_Premium_Calc_Prorata(@P_SDate, case When @ExclusiveF=0 and @P_STime<@P_ETime Then dateadd(day,1,@P_EDate) else @P_EDate End,@Prorata,12,CASE WHEN @PPeriod in (0,1,2) Then 2 ELSE @PPeriod END)*12)>=RateCon.MinPeriod)     
	 or RateCon.MinPeriod=0)                               
	 And (    
	 (ceiling(dbo.fn_Premium_Calc_Prorata(@P_SDate, case When @ExclusiveF=0 and @P_STime<@P_ETime Then dateadd(day,1,@P_EDate) else @P_EDate End,@Prorata,12,CASE WHEN @PPeriod in (0,1,2) Then 2 ELSE @PPeriod END)*12)<=RateCon.MaxPeriod)     
	 or RateCon.MaxPeriod=0)) OR
	(@SPeriod=1 
	 and ((datediff(day, @P_SDate, case When @ExclusiveF=0 and @P_STime<@P_ETime Then dateadd(day,1,@P_EDate) else @P_EDate End)>=RateCon.MinPeriod) or RateCon.MinPeriod=0)
	 And ((datediff(day, @P_SDate, case When @ExclusiveF=0 and @P_STime<@P_ETime Then dateadd(day,1,@P_EDate) else @P_EDate End)<=RateCon.MaxPeriod) or RateCon.MaxPeriod=0))
	 )      
And (coalesce(RateCon.ValueID1,'')='' or @P_VALUEID1 =RateCon.ValueID1)       
And (coalesce(RateCon.ValueID2,'')='' or @P_VALUEID2 =RateCon.ValueID2)       
And (coalesce(RateCon.ValueID3,'')='' or @P_VALUEID3 =RateCon.ValueID3)       
And (coalesce(RateCon.ValueID4,'')='' or @P_VALUEID4 =RateCon.ValueID4)       
And (coalesce(RateCon.ValueID5,'')='' or @P_VALUEID5 =RateCon.ValueID5)       
And (coalesce(RateCon.ValueID6,'')='' or @P_VALUEID6 =RateCon.ValueID6)       
And (coalesce(RateCon.ValueID7,'')='' or @P_VALUEID7 =RateCon.ValueID7)       
And (coalesce(RateCon.ValueID8,'')='' or @P_VALUEID8 =RateCon.ValueID8)       
And (coalesce(RateCon.ValueID9,'')='' or @P_VALUEID9 =RateCon.ValueID9)       
And (coalesce(RateCon.ValueID10,'')='' or @P_VALUEID10 =RateCon.ValueID10)       
And (coalesce(RateCon.ValueID11,'')='' or @P_VALUEID11 =RateCon.ValueID11)       
And (coalesce(RateCon.ValueID12,'')='' or @P_VALUEID12 =RateCon.ValueID12)       
And (coalesce(RateCon.ValueID13,'')='' or @P_VALUEID13 =RateCon.ValueID13)       
And (coalesce(RateCon.ValueID14,'')='' or @P_VALUEID14 =RateCon.ValueID14)       
And (coalesce(RateCon.ValueID15,'')='' or @P_VALUEID15 =RateCon.ValueID15)       
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

if @Temp_CID is null
Select @Temp_CID=''

if @Temp_CID<>''
Begin
Select @CID=@CID+'|'+@Temp_CID
End

Select @Loading as Loading, @HoldF as HoldF, @HoldMessage as HoldMessage, @CID as CID

GO

DROP PROCEDURE  GetStoredPolicy_Client
GO
CREATE PROCEDURE  GetStoredPolicy_Client(@P_ID as varchar(10), @P_Role as varchar(10),@P_StartDate as smalldatetime, @P_StartTime as varchar(5),@P_LastDate as smalldatetime, @P_LastTime as varchar(5),@P_LastANO as int, @P_ASource as varchar(10)='', @P_RefNo as varchar(50)='', @P_PolicyNo as varchar(50)='', @P_CertificateNo as varchar(50)='', @P_EMail as varchar(100)='', @P_ID_NO as varchar(100)='', @P_Info as varchar(100)='', @P_Branch as varchar(10)='')  
as   
	Select TOP 100
	A.ANO, 
	A.OANO,
	A.RANO,
	A.AName,
	Case When C.OpenFlag=1 and A.CertificateNo<>'' then A.PolicyNo+'-'+A.CertificateNo else A.PolicyNo end as A_PolicyNo,
	A.PolicyNo,
	A.CERTIFICATENO,
	A.RefNo as A_RefNo,
	COB.Description,
	A.Remarks,
	A.SDate, A.EDate, A.PDate, A.ADate, A.AType, A.ASource,
	Case When A.AStatus Not in ('W','T') Then 'INFORCED' else '' end as AStatus,
	A.AID as AID,
	C.MO,
	A.Branch,
	A.Source,
	TOC.TOC as RefTOC,
	TOC.Description as RefTOCDesc,
	A.AUserDate as Last_Update,
	A.AUserTime as Last_Time,
	A.ExclusiveF,
	PolicyType.SType,
	C.ISType,
	Case When TOC.FLDID1<>'' Then TOC.FLDTAG1+' : '+cast(A1.VALUEDESC1 as varchar(100))+char(13)+char(10) else '' end
	+Case When TOC.FLDID2<>'' Then TOC.FLDTAG2+' : '+cast(A1.VALUEDESC2 as varchar(100))+char(13)+char(10) else '' end
	+Case When TOC.FLDID3<>'' Then TOC.FLDTAG3+' : '+cast(A1.VALUEDESC3 as varchar(100))+char(13)+char(10) else '' end
	+Case When TOC.FLDID4<>'' Then TOC.FLDTAG4+' : '+cast(A1.VALUEDESC4 as varchar(100))+char(13)+char(10) else '' end
	+Case When TOC.FLDID5<>'' Then TOC.FLDTAG5+' : '+cast(A1.VALUEDESC5 as varchar(100))+char(13)+char(10) else '' end
	+Case When TOC.FLDID6<>'' Then TOC.FLDTAG6+' : '+cast(A1.VALUEDESC6 as varchar(100))+char(13)+char(10) else '' end
	+Case When TOC.FLDID7<>'' Then TOC.FLDTAG7+' : '+cast(A1.VALUEDESC7 as varchar(100))+char(13)+char(10) else '' end
	+Case When TOC.FLDID8<>'' Then TOC.FLDTAG8+' : '+cast(A1.VALUEDESC8 as varchar(100))+char(13)+char(10) else '' end
	+Case When TOC.FLDID9<>'' Then TOC.FLDTAG9+' : '+cast(A1.VALUEDESC9 as varchar(100))+char(13)+char(10) else '' end
	+Case When TOC.FLDID10<>'' Then TOC.FLDTAG10+' : '+cast(A1.VALUEDESC10 as varchar(100))+char(13)+char(10) else '' end
	+Case When TOC.FLDID11<>'' Then TOC.FLDTAG11+' : '+cast(A1.VALUEDESC11 as varchar(100))+char(13)+char(10) else '' end
	+Case When TOC.FLDID12<>'' Then TOC.FLDTAG12+' : '+cast(A1.VALUEDESC12 as varchar(100))+char(13)+char(10) else '' end
	+Case When TOC.FLDID13<>'' Then TOC.FLDTAG13+' : '+cast(A1.VALUEDESC13 as varchar(100))+char(13)+char(10) else '' end
	+Case When TOC.FLDID14<>'' Then TOC.FLDTAG14+' : '+cast(A1.VALUEDESC14 as varchar(100))+char(13)+char(10) else '' end
	+Case When TOC.FLDID15<>'' Then TOC.FLDTAG15+' : '+cast(A1.VALUEDESC15 as varchar(100))+char(13)+char(10) else '' end
	as INFO,
	A.CANO,
	A.LANO,
	TOPRO.TOPRO as RefTOPRO,
	TOPRO.DESCRIPTION as RefTOPRODESC,
	TOC.FLDID1, 
	TOC.FLDID2, 
	TOC.FLDID3, 
	TOC.FLDID4, 
	TOC.FLDID5, 
	TOC.FLDID6, 
	TOC.FLDID7, 
	TOC.FLDID8, 
	TOC.FLDID9, 
	TOC.FLDID10, 
	TOC.FLDID11, 
	TOC.FLDID12, 
	TOC.FLDID13, 
	TOC.FLDID14, 
	TOC.FLDID15, 
	TOC.FLDID1, 
	TOC.FLDID2, 
	TOC.FLDID3, 
	TOC.FLDID4, 
	TOC.FLDID5, 
	TOC.FLDID6, 
	TOC.FLDID7, 
	TOC.FLDID8, 
	TOC.FLDID9, 
	TOC.FLDID10, 
	TOC.FLDID11, 
	TOC.FLDID12, 
	TOC.FLDID13, 
	TOC.FLDID14, 
	TOC.FLDID15,
	A1.VALUEDESC1, 
	A1.VALUEDESC2, 
	A1.VALUEDESC3, 
	A1.VALUEDESC4, 
	A1.VALUEDESC5, 
	A1.VALUEDESC6, 
	A1.VALUEDESC7, 
	A1.VALUEDESC8, 
	A1.VALUEDESC9, 
	A1.VALUEDESC10, 
	A1.VALUEDESC11, 
	A1.VALUEDESC12, 
	A1.VALUEDESC13, 
	A1.VALUEDESC14, 
	A1.VALUEDESC15,
	P.Email,
	P.Email_2,
	P_Ext.ID_No
	from Acceptance A 
	Inner Join Profile P on (P.ID=A.AID) 
	Left Join Profile_Ext P_Ext on (P_Ext.ID=P.ID)
	Left Join TOPRO on (TOPRO.TOPRO=A.TOPRO)
	Inner Join AInfo A1 on (A1.ANO=A.ANO)
	Inner Join Cover C on (C.CNO=A.CNO)
	Inner Join TOC on (TOC.TOC=A.TOC)
	Inner Join COB on (COB.COB=TOC.COB)
	Inner Join PolicyType on (PolicyType.PolicyType=C.PolicyType)
	Inner Join (
		Select A.AID, A.ASource, min(Case When A.ANO>=@P_LastANO+1 Then @P_LastANO+1 else A.ANO end) as MinANO, max(A.ANO) as MaxANO
		from Acceptance A
		Inner Join Profile P on (P.ID=A.AID) 
		Left Join Profile_Ext P_Ext on (P_Ext.ID=P.ID)
		Inner Join AInfo A1 on (A1.ANO=A.ANO)
		Inner Join Cover C on (C.CNO=A.CNO)
		Inner Join TOC on (TOC.TOC=A.TOC)
		Where (@P_ID='' or A.AID=@P_ID)
		and (@P_ASource='<All>' or A.ASource=@P_ASource)
		and A.AStatus not in ('W','T') and C.CStatus<>'C' and A.pAStatus<>'W' 
		and (
			A.ANO>@P_LastANO 
			or ((A.AUserDate>@P_StartDate) or (A.AUserDate=@P_StartDate and A.AUserTime>@P_StartTime))
			or (A.PolicyNo=@P_PolicyNo and A.CertificateNo=@P_CertificateNo)
		)
		and (@P_PolicyNo='' or A.PolicyNo Like @P_PolicyNo +'%')
		and (@P_CertificateNo='' or A.CertificateNo Like @P_CertificateNo +'%')
		and (@P_RefNo='' or A.RefNo Like @P_RefNo+'%')
		and (@P_ID_NO='' or (P_Ext.ID_NO like @P_ID_NO+'%'))
		and (@P_Email='' or ((@P_EMail<>'' and P.Email=@P_EMail) or (@P_EMail<>'' and P.Email_2=@P_EMail)))
		and (@P_Branch='' or A.Branch=@P_Branch)
		and
		(
		@P_Info='' or
		replace(replace(
		Case When TOC.FLDID1<>'' Then TOC.FLDTAG1+' : '+cast(A1.VALUEDESC1 as varchar(100))+char(13)+char(10) else '' end
		+Case When TOC.FLDID2<>'' Then TOC.FLDTAG2+' : '+cast(A1.VALUEDESC2 as varchar(100))+char(13)+char(10) else '' end
		+Case When TOC.FLDID3<>'' Then TOC.FLDTAG3+' : '+cast(A1.VALUEDESC3 as varchar(100))+char(13)+char(10) else '' end
		+Case When TOC.FLDID4<>'' Then TOC.FLDTAG4+' : '+cast(A1.VALUEDESC4 as varchar(100))+char(13)+char(10) else '' end
		+Case When TOC.FLDID5<>'' Then TOC.FLDTAG5+' : '+cast(A1.VALUEDESC5 as varchar(100))+char(13)+char(10) else '' end
		+Case When TOC.FLDID6<>'' Then TOC.FLDTAG6+' : '+cast(A1.VALUEDESC6 as varchar(100))+char(13)+char(10) else '' end
		+Case When TOC.FLDID7<>'' Then TOC.FLDTAG7+' : '+cast(A1.VALUEDESC7 as varchar(100))+char(13)+char(10) else '' end
		+Case When TOC.FLDID8<>'' Then TOC.FLDTAG8+' : '+cast(A1.VALUEDESC8 as varchar(100))+char(13)+char(10) else '' end
		+Case When TOC.FLDID9<>'' Then TOC.FLDTAG9+' : '+cast(A1.VALUEDESC9 as varchar(100))+char(13)+char(10) else '' end
		+Case When TOC.FLDID10<>'' Then TOC.FLDTAG10+' : '+cast(A1.VALUEDESC10 as varchar(100))+char(13)+char(10) else '' end
		+Case When TOC.FLDID11<>'' Then TOC.FLDTAG11+' : '+cast(A1.VALUEDESC11 as varchar(100))+char(13)+char(10) else '' end
		+Case When TOC.FLDID12<>'' Then TOC.FLDTAG12+' : '+cast(A1.VALUEDESC12 as varchar(100))+char(13)+char(10) else '' end
		+Case When TOC.FLDID13<>'' Then TOC.FLDTAG13+' : '+cast(A1.VALUEDESC13 as varchar(100))+char(13)+char(10) else '' end
		+Case When TOC.FLDID14<>'' Then TOC.FLDTAG14+' : '+cast(A1.VALUEDESC14 as varchar(100))+char(13)+char(10) else '' end
		+Case When TOC.FLDID15<>'' Then TOC.FLDTAG15+' : '+cast(A1.VALUEDESC15 as varchar(100))+char(13)+char(10) else '' end
		,'-',''),' ','') Like '%'+Replace(Replace(@P_Info, '-', ''), ' ', '')+'%'
		)
		Group by A.AID, A.ASource

	) A2 on (1=1)
	Where A.ANO Between A2.MinANO and A2.MaxANO and A.ASource=A2.ASource
	and A.AStatus not in ('W','T') and C.CStatus<>'C' and A.pAStatus<>'W' 
	and A.AID=A2.AID
	Order by A.ANO

GO


DROP PROCEDURE  GetStoredPolicy_Agent
GO
CREATE PROCEDURE  GetStoredPolicy_Agent(@P_ID as varchar(10), @P_Role as varchar(10),@P_StartDate as smalldatetime, @P_StartTime as varchar(5),@P_LastDate as smalldatetime, @P_LastTime as varchar(5),@P_LastANO as int, @P_ASource as varchar(10)='', @P_RefNo as varchar(50)='', @P_PolicyNo as varchar(50)='', @P_CertificateNo as varchar(50)='', @P_EMail as varchar(100)='', @P_ID_NO as varchar(100)='', @P_Info as varchar(100)='', @P_Branch as varchar(10)='')  
as   
	Select TOP 100
	A.ANO, 
	A.OANO,
	A.RANO,
	A.AName,
	Case When C.OpenFlag=1 and A.CertificateNo<>'' then A.PolicyNo+'-'+A.CertificateNo else A.PolicyNo end as A_PolicyNo,
	A.PolicyNo,
	A.CERTIFICATENO,
	A.RefNo as A_RefNo,
	COB.Description,
	A.Remarks,
	A.SDate, A.EDate, A.PDate, A.ADate, A.AType, A.ASource,
	Case When A.AStatus Not in ('W','T') Then 'INFORCED' else '' end as AStatus,
	A.AID as AID,
	C.MO,
	A.Branch,
	A.Source,
	TOC.TOC as RefTOC,
	TOC.Description as RefTOCDesc,
	A.AUserDate as Last_Update,
	A.AUserTime as Last_Time,
	A.ExclusiveF,
	PolicyType.SType,
	C.ISType,
	Case When TOC.FLDID1<>'' Then TOC.FLDTAG1+' : '+cast(A1.VALUEDESC1 as varchar(100))+char(13)+char(10) else '' end
	+Case When TOC.FLDID2<>'' Then TOC.FLDTAG2+' : '+cast(A1.VALUEDESC2 as varchar(100))+char(13)+char(10) else '' end
	+Case When TOC.FLDID3<>'' Then TOC.FLDTAG3+' : '+cast(A1.VALUEDESC3 as varchar(100))+char(13)+char(10) else '' end
	+Case When TOC.FLDID4<>'' Then TOC.FLDTAG4+' : '+cast(A1.VALUEDESC4 as varchar(100))+char(13)+char(10) else '' end
	+Case When TOC.FLDID5<>'' Then TOC.FLDTAG5+' : '+cast(A1.VALUEDESC5 as varchar(100))+char(13)+char(10) else '' end
	+Case When TOC.FLDID6<>'' Then TOC.FLDTAG6+' : '+cast(A1.VALUEDESC6 as varchar(100))+char(13)+char(10) else '' end
	+Case When TOC.FLDID7<>'' Then TOC.FLDTAG7+' : '+cast(A1.VALUEDESC7 as varchar(100))+char(13)+char(10) else '' end
	+Case When TOC.FLDID8<>'' Then TOC.FLDTAG8+' : '+cast(A1.VALUEDESC8 as varchar(100))+char(13)+char(10) else '' end
	+Case When TOC.FLDID9<>'' Then TOC.FLDTAG9+' : '+cast(A1.VALUEDESC9 as varchar(100))+char(13)+char(10) else '' end
	+Case When TOC.FLDID10<>'' Then TOC.FLDTAG10+' : '+cast(A1.VALUEDESC10 as varchar(100))+char(13)+char(10) else '' end
	+Case When TOC.FLDID11<>'' Then TOC.FLDTAG11+' : '+cast(A1.VALUEDESC11 as varchar(100))+char(13)+char(10) else '' end
	+Case When TOC.FLDID12<>'' Then TOC.FLDTAG12+' : '+cast(A1.VALUEDESC12 as varchar(100))+char(13)+char(10) else '' end
	+Case When TOC.FLDID13<>'' Then TOC.FLDTAG13+' : '+cast(A1.VALUEDESC13 as varchar(100))+char(13)+char(10) else '' end
	+Case When TOC.FLDID14<>'' Then TOC.FLDTAG14+' : '+cast(A1.VALUEDESC14 as varchar(100))+char(13)+char(10) else '' end
	+Case When TOC.FLDID15<>'' Then TOC.FLDTAG15+' : '+cast(A1.VALUEDESC15 as varchar(100))+char(13)+char(10) else '' end
	as INFO,
	A.CANO,
	A.LANO,
	TOPRO.TOPRO as RefTOPRO,
	TOPRO.DESCRIPTION as RefTOPRODESC,
	TOC.FLDID1, 
	TOC.FLDID2, 
	TOC.FLDID3, 
	TOC.FLDID4, 
	TOC.FLDID5, 
	TOC.FLDID6, 
	TOC.FLDID7, 
	TOC.FLDID8, 
	TOC.FLDID9, 
	TOC.FLDID10, 
	TOC.FLDID11, 
	TOC.FLDID12, 
	TOC.FLDID13, 
	TOC.FLDID14, 
	TOC.FLDID15, 
	TOC.FLDID1, 
	TOC.FLDID2, 
	TOC.FLDID3, 
	TOC.FLDID4, 
	TOC.FLDID5, 
	TOC.FLDID6, 
	TOC.FLDID7, 
	TOC.FLDID8, 
	TOC.FLDID9, 
	TOC.FLDID10, 
	TOC.FLDID11, 
	TOC.FLDID12, 
	TOC.FLDID13, 
	TOC.FLDID14, 
	TOC.FLDID15,
	A1.VALUEDESC1, 
	A1.VALUEDESC2, 
	A1.VALUEDESC3, 
	A1.VALUEDESC4, 
	A1.VALUEDESC5, 
	A1.VALUEDESC6, 
	A1.VALUEDESC7, 
	A1.VALUEDESC8, 
	A1.VALUEDESC9, 
	A1.VALUEDESC10, 
	A1.VALUEDESC11, 
	A1.VALUEDESC12, 
	A1.VALUEDESC13, 
	A1.VALUEDESC14, 
	A1.VALUEDESC15,
	P.Email,
	P.Email_2,
	P_Ext.ID_No
	from Acceptance A 
	Inner Join Profile P on (P.ID=A.AID) 
	Left Join Profile_Ext P_Ext on (P_Ext.ID=P.ID)
	Left Join TOPRO on (TOPRO.TOPRO=A.TOPRO)
	Inner Join AInfo A1 on (A1.ANO=A.ANO)
	Inner Join Cover C on (C.CNO=A.CNO)
	Inner Join TOC on (TOC.TOC=A.TOC)
	Inner Join COB on (COB.COB=TOC.COB)
	Inner Join PolicyType on (PolicyType.PolicyType=C.PolicyType)
	Inner Join (
		Select A.Source, A.ASource, min(Case When A.ANO>=@P_LastANO+1 Then @P_LastANO+1 else A.ANO end) as MinANO, max(A.ANO) as MaxANO
		from Acceptance A
		Inner Join Cover C on (C.CNO=A.CNO)
		Where (A.Source=@P_ID)
		and (@P_ASource='<All>' or A.ASource=@P_ASource)
		and A.AStatus not in ('W','T') and C.CStatus<>'C' and A.pAStatus<>'W' 
		and (
			A.ANO>@P_LastANO 
			or ((A.AUserDate>@P_StartDate) or (A.AUserDate=@P_StartDate and A.AUserTime>@P_StartTime))
		)
		Group by A.Source, A.ASource
	) A2 on (1=1)
	Where A.ANO Between A2.MinANO and A2.MaxANO and A.ASource=A2.ASource
	and A.AStatus not in ('W','T') and C.CStatus<>'C' and A.pAStatus<>'W' 
	and A.Source=A2.Source
	Order by A.ANO
GO

DROP PROCEDURE  GetStoredPolicy_MO
GO
CREATE PROCEDURE  GetStoredPolicy_MO(@P_ID as varchar(10), @P_Role as varchar(10),@P_StartDate as smalldatetime, @P_StartTime as varchar(5),@P_LastDate as smalldatetime, @P_LastTime as varchar(5),@P_LastANO as int, @P_ASource as varchar(10)='', @P_RefNo as varchar(50)='', @P_PolicyNo as varchar(50)='', @P_CertificateNo as varchar(50)='', @P_EMail as varchar(100)='', @P_ID_NO as varchar(100)='', @P_Info as varchar(100)='', @P_Branch as varchar(10)='')  
as   
	Select TOP 100
	A.ANO, 
	A.OANO,
	A.RANO,
	A.AName,
	Case When C.OpenFlag=1 and A.CertificateNo<>'' then A.PolicyNo+'-'+A.CertificateNo else A.PolicyNo end as A_PolicyNo,
	A.PolicyNo,
	A.CERTIFICATENO,
	A.RefNo as A_RefNo,
	COB.Description,
	A.Remarks,
	A.SDate, A.EDate, A.PDate, A.ADate, A.AType, A.ASource,
	Case When A.AStatus Not in ('W','T') Then 'INFORCED' else '' end as AStatus,
	A.AID as AID,
	C.MO,
	A.Branch,
	A.Source,
	TOC.TOC as RefTOC,
	TOC.Description as RefTOCDesc,
	A.AUserDate as Last_Update,
	A.AUserTime as Last_Time,
	A.ExclusiveF,
	PolicyType.SType,
	C.ISType,
	Case When TOC.FLDID1<>'' Then TOC.FLDTAG1+' : '+cast(A1.VALUEDESC1 as varchar(100))+char(13)+char(10) else '' end
	+Case When TOC.FLDID2<>'' Then TOC.FLDTAG2+' : '+cast(A1.VALUEDESC2 as varchar(100))+char(13)+char(10) else '' end
	+Case When TOC.FLDID3<>'' Then TOC.FLDTAG3+' : '+cast(A1.VALUEDESC3 as varchar(100))+char(13)+char(10) else '' end
	+Case When TOC.FLDID4<>'' Then TOC.FLDTAG4+' : '+cast(A1.VALUEDESC4 as varchar(100))+char(13)+char(10) else '' end
	+Case When TOC.FLDID5<>'' Then TOC.FLDTAG5+' : '+cast(A1.VALUEDESC5 as varchar(100))+char(13)+char(10) else '' end
	+Case When TOC.FLDID6<>'' Then TOC.FLDTAG6+' : '+cast(A1.VALUEDESC6 as varchar(100))+char(13)+char(10) else '' end
	+Case When TOC.FLDID7<>'' Then TOC.FLDTAG7+' : '+cast(A1.VALUEDESC7 as varchar(100))+char(13)+char(10) else '' end
	+Case When TOC.FLDID8<>'' Then TOC.FLDTAG8+' : '+cast(A1.VALUEDESC8 as varchar(100))+char(13)+char(10) else '' end
	+Case When TOC.FLDID9<>'' Then TOC.FLDTAG9+' : '+cast(A1.VALUEDESC9 as varchar(100))+char(13)+char(10) else '' end
	+Case When TOC.FLDID10<>'' Then TOC.FLDTAG10+' : '+cast(A1.VALUEDESC10 as varchar(100))+char(13)+char(10) else '' end
	+Case When TOC.FLDID11<>'' Then TOC.FLDTAG11+' : '+cast(A1.VALUEDESC11 as varchar(100))+char(13)+char(10) else '' end
	+Case When TOC.FLDID12<>'' Then TOC.FLDTAG12+' : '+cast(A1.VALUEDESC12 as varchar(100))+char(13)+char(10) else '' end
	+Case When TOC.FLDID13<>'' Then TOC.FLDTAG13+' : '+cast(A1.VALUEDESC13 as varchar(100))+char(13)+char(10) else '' end
	+Case When TOC.FLDID14<>'' Then TOC.FLDTAG14+' : '+cast(A1.VALUEDESC14 as varchar(100))+char(13)+char(10) else '' end
	+Case When TOC.FLDID15<>'' Then TOC.FLDTAG15+' : '+cast(A1.VALUEDESC15 as varchar(100))+char(13)+char(10) else '' end
	as INFO,
	A.CANO,
	A.LANO,
	TOPRO.TOPRO as RefTOPRO,
	TOPRO.DESCRIPTION as RefTOPRODESC,
	TOC.FLDID1, 
	TOC.FLDID2, 
	TOC.FLDID3, 
	TOC.FLDID4, 
	TOC.FLDID5, 
	TOC.FLDID6, 
	TOC.FLDID7, 
	TOC.FLDID8, 
	TOC.FLDID9, 
	TOC.FLDID10, 
	TOC.FLDID11, 
	TOC.FLDID12, 
	TOC.FLDID13, 
	TOC.FLDID14, 
	TOC.FLDID15, 
	TOC.FLDID1, 
	TOC.FLDID2, 
	TOC.FLDID3, 
	TOC.FLDID4, 
	TOC.FLDID5, 
	TOC.FLDID6, 
	TOC.FLDID7, 
	TOC.FLDID8, 
	TOC.FLDID9, 
	TOC.FLDID10, 
	TOC.FLDID11, 
	TOC.FLDID12, 
	TOC.FLDID13, 
	TOC.FLDID14, 
	TOC.FLDID15,
	A1.VALUEDESC1, 
	A1.VALUEDESC2, 
	A1.VALUEDESC3, 
	A1.VALUEDESC4, 
	A1.VALUEDESC5, 
	A1.VALUEDESC6, 
	A1.VALUEDESC7, 
	A1.VALUEDESC8, 
	A1.VALUEDESC9, 
	A1.VALUEDESC10, 
	A1.VALUEDESC11, 
	A1.VALUEDESC12, 
	A1.VALUEDESC13, 
	A1.VALUEDESC14, 
	A1.VALUEDESC15,
	P.Email,
	P.Email_2,
	P_Ext.ID_No
	from Acceptance A 
	Inner Join Profile P on (P.ID=A.AID) 
	Left Join Profile_Ext P_Ext on (P_Ext.ID=P.ID)
	Left Join TOPRO on (TOPRO.TOPRO=A.TOPRO)
	Inner Join AInfo A1 on (A1.ANO=A.ANO)
	Inner Join Cover C on (C.CNO=A.CNO)
	Inner Join TOC on (TOC.TOC=A.TOC)
	Inner Join COB on (COB.COB=TOC.COB)
	Inner Join PolicyType on (PolicyType.PolicyType=C.PolicyType)
	Inner Join (
		Select C.MO, A.ASource, min(Case When A.ANO>=@P_LastANO+1 Then @P_LastANO+1 else A.ANO end) as MinANO, max(A.ANO) as MaxANO
		from Acceptance A
		Inner Join Cover C on (C.CNO=A.CNO)
		Where  
		(C.MO=@P_ID)
		and (@P_ASource='<All>' or A.ASource=@P_ASource)
		and A.AStatus not in ('W','T') and C.CStatus<>'C' and A.pAStatus<>'W' 
		and (
			A.ANO>@P_LastANO 
			or ((A.AUserDate>@P_StartDate) or (A.AUserDate=@P_StartDate and A.AUserTime>@P_StartTime))
		)
		Group By C.MO, A.ASource
	) A2 on (1=1)
	Where A.ANO Between A2.MinANO and A2.MaxANO and A.ASource=A2.ASource
	and A.AStatus not in ('W','T') and C.CStatus<>'C' and A.pAStatus<>'W' 
	and C.MO=A2.MO
	Order by A.ANO


GO

DROP PROCEDURE  GetStoredPolicy_User
GO
CREATE PROCEDURE  GetStoredPolicy_User(@P_ID as varchar(10), @P_Role as varchar(10),@P_StartDate as smalldatetime, @P_StartTime as varchar(5),@P_LastDate as smalldatetime, @P_LastTime as varchar(5),@P_LastANO as int, @P_ASource as varchar(10)='', @P_RefNo as varchar(50)='', @P_PolicyNo as varchar(50)='', @P_CertificateNo as varchar(50)='', @P_EMail as varchar(100)='', @P_ID_NO as varchar(100)='', @P_Info as varchar(100)='', @P_Branch as varchar(10)='')  
as   
	Select TOP 100
	A.ANO, 
	A.OANO,
	A.RANO,
	A.AName,
	Case When C.OpenFlag=1 and A.CertificateNo<>'' then A.PolicyNo+'-'+A.CertificateNo else A.PolicyNo end as A_PolicyNo,
	A.PolicyNo,
	A.CERTIFICATENO,
	A.RefNo as A_RefNo,
	COB.Description,
	A.Remarks,
	A.SDate, A.EDate, A.PDate, A.ADate, A.AType, A.ASource,
	Case When A.AStatus Not in ('W','T') Then 'INFORCED' else '' end as AStatus,
	A.AID as AID,
	C.MO,
	A.Branch,
	A.Source,
	TOC.TOC as RefTOC,
	TOC.Description as RefTOCDesc,
	A.AUserDate as Last_Update,
	A.AUserTime as Last_Time,
	A.ExclusiveF,
	PolicyType.SType,
	C.ISType,
	Case When TOC.FLDID1<>'' Then TOC.FLDTAG1+' : '+cast(A1.VALUEDESC1 as varchar(100))+char(13)+char(10) else '' end
	+Case When TOC.FLDID2<>'' Then TOC.FLDTAG2+' : '+cast(A1.VALUEDESC2 as varchar(100))+char(13)+char(10) else '' end
	+Case When TOC.FLDID3<>'' Then TOC.FLDTAG3+' : '+cast(A1.VALUEDESC3 as varchar(100))+char(13)+char(10) else '' end
	+Case When TOC.FLDID4<>'' Then TOC.FLDTAG4+' : '+cast(A1.VALUEDESC4 as varchar(100))+char(13)+char(10) else '' end
	+Case When TOC.FLDID5<>'' Then TOC.FLDTAG5+' : '+cast(A1.VALUEDESC5 as varchar(100))+char(13)+char(10) else '' end
	+Case When TOC.FLDID6<>'' Then TOC.FLDTAG6+' : '+cast(A1.VALUEDESC6 as varchar(100))+char(13)+char(10) else '' end
	+Case When TOC.FLDID7<>'' Then TOC.FLDTAG7+' : '+cast(A1.VALUEDESC7 as varchar(100))+char(13)+char(10) else '' end
	+Case When TOC.FLDID8<>'' Then TOC.FLDTAG8+' : '+cast(A1.VALUEDESC8 as varchar(100))+char(13)+char(10) else '' end
	+Case When TOC.FLDID9<>'' Then TOC.FLDTAG9+' : '+cast(A1.VALUEDESC9 as varchar(100))+char(13)+char(10) else '' end
	+Case When TOC.FLDID10<>'' Then TOC.FLDTAG10+' : '+cast(A1.VALUEDESC10 as varchar(100))+char(13)+char(10) else '' end
	+Case When TOC.FLDID11<>'' Then TOC.FLDTAG11+' : '+cast(A1.VALUEDESC11 as varchar(100))+char(13)+char(10) else '' end
	+Case When TOC.FLDID12<>'' Then TOC.FLDTAG12+' : '+cast(A1.VALUEDESC12 as varchar(100))+char(13)+char(10) else '' end
	+Case When TOC.FLDID13<>'' Then TOC.FLDTAG13+' : '+cast(A1.VALUEDESC13 as varchar(100))+char(13)+char(10) else '' end
	+Case When TOC.FLDID14<>'' Then TOC.FLDTAG14+' : '+cast(A1.VALUEDESC14 as varchar(100))+char(13)+char(10) else '' end
	+Case When TOC.FLDID15<>'' Then TOC.FLDTAG15+' : '+cast(A1.VALUEDESC15 as varchar(100))+char(13)+char(10) else '' end
	as INFO,
	A.CANO,
	A.LANO,
	TOPRO.TOPRO as RefTOPRO,
	TOPRO.DESCRIPTION as RefTOPRODESC,
	TOC.FLDID1, 
	TOC.FLDID2, 
	TOC.FLDID3, 
	TOC.FLDID4, 
	TOC.FLDID5, 
	TOC.FLDID6, 
	TOC.FLDID7, 
	TOC.FLDID8, 
	TOC.FLDID9, 
	TOC.FLDID10, 
	TOC.FLDID11, 
	TOC.FLDID12, 
	TOC.FLDID13, 
	TOC.FLDID14, 
	TOC.FLDID15, 
	TOC.FLDID1, 
	TOC.FLDID2, 
	TOC.FLDID3, 
	TOC.FLDID4, 
	TOC.FLDID5, 
	TOC.FLDID6, 
	TOC.FLDID7, 
	TOC.FLDID8, 
	TOC.FLDID9, 
	TOC.FLDID10, 
	TOC.FLDID11, 
	TOC.FLDID12, 
	TOC.FLDID13, 
	TOC.FLDID14, 
	TOC.FLDID15,
	A1.VALUEDESC1, 
	A1.VALUEDESC2, 
	A1.VALUEDESC3, 
	A1.VALUEDESC4, 
	A1.VALUEDESC5, 
	A1.VALUEDESC6, 
	A1.VALUEDESC7, 
	A1.VALUEDESC8, 
	A1.VALUEDESC9, 
	A1.VALUEDESC10, 
	A1.VALUEDESC11, 
	A1.VALUEDESC12, 
	A1.VALUEDESC13, 
	A1.VALUEDESC14, 
	A1.VALUEDESC15,
	P.Email,
	P.Email_2,
	P_Ext.ID_No
	from Acceptance A 
	Left Join Profile P on (P.ID=A.AID) 
	Left Join Profile_Ext P_Ext on (P_Ext.ID=P.ID)
	Left Join TOPRO on (TOPRO.TOPRO=A.TOPRO)
	Inner Join AInfo A1 on (A1.ANO=A.ANO)
	Inner Join Cover C on (C.CNO=A.CNO)
	Inner Join TOC on (TOC.TOC=A.TOC)
	Inner Join COB on (COB.COB=TOC.COB)
	Inner Join PolicyType on (PolicyType.PolicyType=C.PolicyType)
	Where 
	A.AStatus not in ('W','T') and C.CStatus<>'C' and A.pAStatus<>'W' 
	--and (A.UserID=@P_ID)
	and (@P_ASource='<All>' or A.ASource=@P_ASource)
	--and (A.ANO>@P_LastANO or (((A.AUserDate>@P_StartDate) or (A.AUserDate=@P_StartDate and A.AUserTime>@P_StartTime)) and ((A.AUserDate<@P_LastDate) or (A.AUserDate=@P_LastDate and A.AUserTime<=@P_LastTime))))
	--and (A.ANO>@P_LastANO)
	and (@P_PolicyNo='' or A.PolicyNo Like @P_PolicyNo +'%')
	and (@P_CertificateNo='' or A.CertificateNo Like @P_CertificateNo +'%')
	and (@P_RefNo='' or A.RefNo Like @P_RefNo+'%')
	and (@P_ID_NO='' or (P_Ext.ID_NO like @P_ID_NO+'%'))
	and (@P_Email='' or ((@P_EMail<>'' and P.Email=@P_EMail) or (@P_EMail<>'' and P.Email_2=@P_EMail)))
	and (@P_Branch='' or A.Branch=@P_Branch)
	and
	(
	@P_Info='' or
	replace(replace(
	Case When TOC.FLDID1<>'' Then TOC.FLDTAG1+' : '+cast(A1.VALUEDESC1 as varchar(100))+char(13)+char(10) else '' end
	+Case When TOC.FLDID2<>'' Then TOC.FLDTAG2+' : '+cast(A1.VALUEDESC2 as varchar(100))+char(13)+char(10) else '' end
	+Case When TOC.FLDID3<>'' Then TOC.FLDTAG3+' : '+cast(A1.VALUEDESC3 as varchar(100))+char(13)+char(10) else '' end
	+Case When TOC.FLDID4<>'' Then TOC.FLDTAG4+' : '+cast(A1.VALUEDESC4 as varchar(100))+char(13)+char(10) else '' end
	+Case When TOC.FLDID5<>'' Then TOC.FLDTAG5+' : '+cast(A1.VALUEDESC5 as varchar(100))+char(13)+char(10) else '' end
	+Case When TOC.FLDID6<>'' Then TOC.FLDTAG6+' : '+cast(A1.VALUEDESC6 as varchar(100))+char(13)+char(10) else '' end
	+Case When TOC.FLDID7<>'' Then TOC.FLDTAG7+' : '+cast(A1.VALUEDESC7 as varchar(100))+char(13)+char(10) else '' end
	+Case When TOC.FLDID8<>'' Then TOC.FLDTAG8+' : '+cast(A1.VALUEDESC8 as varchar(100))+char(13)+char(10) else '' end
	+Case When TOC.FLDID9<>'' Then TOC.FLDTAG9+' : '+cast(A1.VALUEDESC9 as varchar(100))+char(13)+char(10) else '' end
	+Case When TOC.FLDID10<>'' Then TOC.FLDTAG10+' : '+cast(A1.VALUEDESC10 as varchar(100))+char(13)+char(10) else '' end
	+Case When TOC.FLDID11<>'' Then TOC.FLDTAG11+' : '+cast(A1.VALUEDESC11 as varchar(100))+char(13)+char(10) else '' end
	+Case When TOC.FLDID12<>'' Then TOC.FLDTAG12+' : '+cast(A1.VALUEDESC12 as varchar(100))+char(13)+char(10) else '' end
	+Case When TOC.FLDID13<>'' Then TOC.FLDTAG13+' : '+cast(A1.VALUEDESC13 as varchar(100))+char(13)+char(10) else '' end
	+Case When TOC.FLDID14<>'' Then TOC.FLDTAG14+' : '+cast(A1.VALUEDESC14 as varchar(100))+char(13)+char(10) else '' end
	+Case When TOC.FLDID15<>'' Then TOC.FLDTAG15+' : '+cast(A1.VALUEDESC15 as varchar(100))+char(13)+char(10) else '' end
	,'-',''),' ','') Like '%'+Replace(Replace(@P_Info, '-', ''), ' ', '')+'%'
	)
	Order by A.ANO
GO


DROP PROCEDURE  GetStoredPolicy
GO
CREATE PROCEDURE  GetStoredPolicy(@P_ID as varchar(10), @P_Role as varchar(10),@P_StartDate as smalldatetime, @P_StartTime as varchar(5),@P_LastDate as smalldatetime, @P_LastTime as varchar(5),@P_LastANO as int, @P_ASource as varchar(10)='', @P_RefNo as varchar(50)='', @P_PolicyNo as varchar(50)='', @P_CertificateNo as varchar(50)='', @P_EMail as varchar(100)='', @P_ID_NO as varchar(100)='', @P_Info as varchar(100)='', @P_Branch as varchar(10)='')  
as   
if @P_Role='CLIENT'
	Select TOP 100
	A.ANO, 
	A.OANO,
	A.RANO,
	A.AName,
	Case When C.OpenFlag=1 and A.CertificateNo<>'' then A.PolicyNo+'-'+A.CertificateNo else A.PolicyNo end as A_PolicyNo,
	A.PolicyNo,
	A.CERTIFICATENO,
	A.RefNo as A_RefNo,
	COB.Description,
	A.Remarks,
	A.SDate, A.EDate, A.PDate, A.ADate, A.AType, A.ASource,
	Case When A.AStatus Not in ('W','T') Then 'INFORCED' else '' end as AStatus,
	A.AID as AID,
	C.MO,
	A.Branch,
	A.Source,
	TOC.TOC as RefTOC,
	TOC.Description as RefTOCDesc,
	A.AUserDate as Last_Update,
	A.AUserTime as Last_Time,
	A.ExclusiveF,
	PolicyType.SType,
	C.ISType,
	Case When TOC.FLDID1<>'' Then TOC.FLDTAG1+' : '+cast(A1.VALUEDESC1 as varchar(100))+char(13)+char(10) else '' end
	+Case When TOC.FLDID2<>'' Then TOC.FLDTAG2+' : '+cast(A1.VALUEDESC2 as varchar(100))+char(13)+char(10) else '' end
	+Case When TOC.FLDID3<>'' Then TOC.FLDTAG3+' : '+cast(A1.VALUEDESC3 as varchar(100))+char(13)+char(10) else '' end
	+Case When TOC.FLDID4<>'' Then TOC.FLDTAG4+' : '+cast(A1.VALUEDESC4 as varchar(100))+char(13)+char(10) else '' end
	+Case When TOC.FLDID5<>'' Then TOC.FLDTAG5+' : '+cast(A1.VALUEDESC5 as varchar(100))+char(13)+char(10) else '' end
	+Case When TOC.FLDID6<>'' Then TOC.FLDTAG6+' : '+cast(A1.VALUEDESC6 as varchar(100))+char(13)+char(10) else '' end
	+Case When TOC.FLDID7<>'' Then TOC.FLDTAG7+' : '+cast(A1.VALUEDESC7 as varchar(100))+char(13)+char(10) else '' end
	+Case When TOC.FLDID8<>'' Then TOC.FLDTAG8+' : '+cast(A1.VALUEDESC8 as varchar(100))+char(13)+char(10) else '' end
	+Case When TOC.FLDID9<>'' Then TOC.FLDTAG9+' : '+cast(A1.VALUEDESC9 as varchar(100))+char(13)+char(10) else '' end
	+Case When TOC.FLDID10<>'' Then TOC.FLDTAG10+' : '+cast(A1.VALUEDESC10 as varchar(100))+char(13)+char(10) else '' end
	+Case When TOC.FLDID11<>'' Then TOC.FLDTAG11+' : '+cast(A1.VALUEDESC11 as varchar(100))+char(13)+char(10) else '' end
	+Case When TOC.FLDID12<>'' Then TOC.FLDTAG12+' : '+cast(A1.VALUEDESC12 as varchar(100))+char(13)+char(10) else '' end
	+Case When TOC.FLDID13<>'' Then TOC.FLDTAG13+' : '+cast(A1.VALUEDESC13 as varchar(100))+char(13)+char(10) else '' end
	+Case When TOC.FLDID14<>'' Then TOC.FLDTAG14+' : '+cast(A1.VALUEDESC14 as varchar(100))+char(13)+char(10) else '' end
	+Case When TOC.FLDID15<>'' Then TOC.FLDTAG15+' : '+cast(A1.VALUEDESC15 as varchar(100))+char(13)+char(10) else '' end
	as INFO,
	A.CANO,
	A.LANO,
	TOPRO.TOPRO as RefTOPRO,
	TOPRO.DESCRIPTION as RefTOPRODESC,
	TOC.FLDID1, 
	TOC.FLDID2, 
	TOC.FLDID3, 
	TOC.FLDID4, 
	TOC.FLDID5, 
	TOC.FLDID6, 
	TOC.FLDID7, 
	TOC.FLDID8, 
	TOC.FLDID9, 
	TOC.FLDID10, 
	TOC.FLDID11, 
	TOC.FLDID12, 
	TOC.FLDID13, 
	TOC.FLDID14, 
	TOC.FLDID15, 
	TOC.FLDID1, 
	TOC.FLDID2, 
	TOC.FLDID3, 
	TOC.FLDID4, 
	TOC.FLDID5, 
	TOC.FLDID6, 
	TOC.FLDID7, 
	TOC.FLDID8, 
	TOC.FLDID9, 
	TOC.FLDID10, 
	TOC.FLDID11, 
	TOC.FLDID12, 
	TOC.FLDID13, 
	TOC.FLDID14, 
	TOC.FLDID15,
	A1.VALUEDESC1, 
	A1.VALUEDESC2, 
	A1.VALUEDESC3, 
	A1.VALUEDESC4, 
	A1.VALUEDESC5, 
	A1.VALUEDESC6, 
	A1.VALUEDESC7, 
	A1.VALUEDESC8, 
	A1.VALUEDESC9, 
	A1.VALUEDESC10, 
	A1.VALUEDESC11, 
	A1.VALUEDESC12, 
	A1.VALUEDESC13, 
	A1.VALUEDESC14, 
	A1.VALUEDESC15,
	P.Email,
	P.Email_2,
	P_Ext.ID_No
	from Acceptance A 
	Inner Join Profile P on (P.ID=A.AID) 
	Left Join Profile_Ext P_Ext on (P_Ext.ID=P.ID)
	Left Join TOPRO on (TOPRO.TOPRO=A.TOPRO)
	Inner Join AInfo A1 on (A1.ANO=A.ANO)
	Inner Join Cover C on (C.CNO=A.CNO)
	Inner Join TOC on (TOC.TOC=A.TOC)
	Inner Join COB on (COB.COB=TOC.COB)
	Inner Join PolicyType on (PolicyType.PolicyType=C.PolicyType)
	Inner Join (
		Select A.AID, A.ASource, min(Case When A.ANO>=@P_LastANO+1 Then @P_LastANO+1 else A.ANO end) as MinANO, max(A.ANO) as MaxANO
		from Acceptance A
		Inner Join Profile P on (P.ID=A.AID) 
		Left Join Profile_Ext P_Ext on (P_Ext.ID=P.ID)
		Inner Join AInfo A1 on (A1.ANO=A.ANO)
		Inner Join Cover C on (C.CNO=A.CNO)
		Inner Join TOC on (TOC.TOC=A.TOC)
		Where (@P_ID='' or A.AID=@P_ID)
		and (@P_ASource='<All>' or A.ASource=@P_ASource)
		and A.AStatus not in ('W','T') and C.CStatus<>'C' and A.pAStatus<>'W' 
		and (
			A.ANO>@P_LastANO 
			or ((A.AUserDate>@P_StartDate) or (A.AUserDate=@P_StartDate and A.AUserTime>@P_StartTime))
			or (A.PolicyNo=@P_PolicyNo and A.CertificateNo=@P_CertificateNo)
		)
		and (@P_PolicyNo='' or A.PolicyNo Like @P_PolicyNo +'%')
		and (@P_CertificateNo='' or A.CertificateNo Like @P_CertificateNo +'%')
		and (@P_RefNo='' or A.RefNo Like @P_RefNo+'%')
		and (@P_ID_NO='' or (P_Ext.ID_NO like @P_ID_NO+'%'))
		and (@P_Email='' or ((@P_EMail<>'' and P.Email=@P_EMail) or (@P_EMail<>'' and P.Email_2=@P_EMail)))
		and (@P_Branch='' or A.Branch=@P_Branch)
		and
		(
		@P_Info='' or
		replace(replace(
		Case When TOC.FLDID1<>'' Then TOC.FLDTAG1+' : '+cast(A1.VALUEDESC1 as varchar(100))+char(13)+char(10) else '' end
		+Case When TOC.FLDID2<>'' Then TOC.FLDTAG2+' : '+cast(A1.VALUEDESC2 as varchar(100))+char(13)+char(10) else '' end
		+Case When TOC.FLDID3<>'' Then TOC.FLDTAG3+' : '+cast(A1.VALUEDESC3 as varchar(100))+char(13)+char(10) else '' end
		+Case When TOC.FLDID4<>'' Then TOC.FLDTAG4+' : '+cast(A1.VALUEDESC4 as varchar(100))+char(13)+char(10) else '' end
		+Case When TOC.FLDID5<>'' Then TOC.FLDTAG5+' : '+cast(A1.VALUEDESC5 as varchar(100))+char(13)+char(10) else '' end
		+Case When TOC.FLDID6<>'' Then TOC.FLDTAG6+' : '+cast(A1.VALUEDESC6 as varchar(100))+char(13)+char(10) else '' end
		+Case When TOC.FLDID7<>'' Then TOC.FLDTAG7+' : '+cast(A1.VALUEDESC7 as varchar(100))+char(13)+char(10) else '' end
		+Case When TOC.FLDID8<>'' Then TOC.FLDTAG8+' : '+cast(A1.VALUEDESC8 as varchar(100))+char(13)+char(10) else '' end
		+Case When TOC.FLDID9<>'' Then TOC.FLDTAG9+' : '+cast(A1.VALUEDESC9 as varchar(100))+char(13)+char(10) else '' end
		+Case When TOC.FLDID10<>'' Then TOC.FLDTAG10+' : '+cast(A1.VALUEDESC10 as varchar(100))+char(13)+char(10) else '' end
		+Case When TOC.FLDID11<>'' Then TOC.FLDTAG11+' : '+cast(A1.VALUEDESC11 as varchar(100))+char(13)+char(10) else '' end
		+Case When TOC.FLDID12<>'' Then TOC.FLDTAG12+' : '+cast(A1.VALUEDESC12 as varchar(100))+char(13)+char(10) else '' end
		+Case When TOC.FLDID13<>'' Then TOC.FLDTAG13+' : '+cast(A1.VALUEDESC13 as varchar(100))+char(13)+char(10) else '' end
		+Case When TOC.FLDID14<>'' Then TOC.FLDTAG14+' : '+cast(A1.VALUEDESC14 as varchar(100))+char(13)+char(10) else '' end
		+Case When TOC.FLDID15<>'' Then TOC.FLDTAG15+' : '+cast(A1.VALUEDESC15 as varchar(100))+char(13)+char(10) else '' end
		,'-',''),' ','') Like '%'+Replace(Replace(@P_Info, '-', ''), ' ', '')+'%'
		)
		Group by A.AID, A.ASource

	) A2 on (1=1)
	Where A.ANO Between A2.MinANO and A2.MaxANO and A.ASource=A2.ASource
	and A.AStatus not in ('W','T') and C.CStatus<>'C' and A.pAStatus<>'W' 
	and A.AID=A2.AID
	Order by A.ANO
else if @P_ROLE='AGENT'
	Select TOP 100
	A.ANO, 
	A.OANO,
	A.RANO,
	A.AName,
	Case When C.OpenFlag=1 and A.CertificateNo<>'' then A.PolicyNo+'-'+A.CertificateNo else A.PolicyNo end as A_PolicyNo,
	A.PolicyNo,
	A.CERTIFICATENO,
	A.RefNo as A_RefNo,
	COB.Description,
	A.Remarks,
	A.SDate, A.EDate, A.PDate, A.ADate, A.AType, A.ASource,
	Case When A.AStatus Not in ('W','T') Then 'INFORCED' else '' end as AStatus,
	A.AID as AID,
	C.MO,
	A.Branch,
	A.Source,
	TOC.TOC as RefTOC,
	TOC.Description as RefTOCDesc,
	A.AUserDate as Last_Update,
	A.AUserTime as Last_Time,
	A.ExclusiveF,
	PolicyType.SType,
	C.ISType,
	Case When TOC.FLDID1<>'' Then TOC.FLDTAG1+' : '+cast(A1.VALUEDESC1 as varchar(100))+char(13)+char(10) else '' end
	+Case When TOC.FLDID2<>'' Then TOC.FLDTAG2+' : '+cast(A1.VALUEDESC2 as varchar(100))+char(13)+char(10) else '' end
	+Case When TOC.FLDID3<>'' Then TOC.FLDTAG3+' : '+cast(A1.VALUEDESC3 as varchar(100))+char(13)+char(10) else '' end
	+Case When TOC.FLDID4<>'' Then TOC.FLDTAG4+' : '+cast(A1.VALUEDESC4 as varchar(100))+char(13)+char(10) else '' end
	+Case When TOC.FLDID5<>'' Then TOC.FLDTAG5+' : '+cast(A1.VALUEDESC5 as varchar(100))+char(13)+char(10) else '' end
	+Case When TOC.FLDID6<>'' Then TOC.FLDTAG6+' : '+cast(A1.VALUEDESC6 as varchar(100))+char(13)+char(10) else '' end
	+Case When TOC.FLDID7<>'' Then TOC.FLDTAG7+' : '+cast(A1.VALUEDESC7 as varchar(100))+char(13)+char(10) else '' end
	+Case When TOC.FLDID8<>'' Then TOC.FLDTAG8+' : '+cast(A1.VALUEDESC8 as varchar(100))+char(13)+char(10) else '' end
	+Case When TOC.FLDID9<>'' Then TOC.FLDTAG9+' : '+cast(A1.VALUEDESC9 as varchar(100))+char(13)+char(10) else '' end
	+Case When TOC.FLDID10<>'' Then TOC.FLDTAG10+' : '+cast(A1.VALUEDESC10 as varchar(100))+char(13)+char(10) else '' end
	+Case When TOC.FLDID11<>'' Then TOC.FLDTAG11+' : '+cast(A1.VALUEDESC11 as varchar(100))+char(13)+char(10) else '' end
	+Case When TOC.FLDID12<>'' Then TOC.FLDTAG12+' : '+cast(A1.VALUEDESC12 as varchar(100))+char(13)+char(10) else '' end
	+Case When TOC.FLDID13<>'' Then TOC.FLDTAG13+' : '+cast(A1.VALUEDESC13 as varchar(100))+char(13)+char(10) else '' end
	+Case When TOC.FLDID14<>'' Then TOC.FLDTAG14+' : '+cast(A1.VALUEDESC14 as varchar(100))+char(13)+char(10) else '' end
	+Case When TOC.FLDID15<>'' Then TOC.FLDTAG15+' : '+cast(A1.VALUEDESC15 as varchar(100))+char(13)+char(10) else '' end
	as INFO,
	A.CANO,
	A.LANO,
	TOPRO.TOPRO as RefTOPRO,
	TOPRO.DESCRIPTION as RefTOPRODESC,
	TOC.FLDID1, 
	TOC.FLDID2, 
	TOC.FLDID3, 
	TOC.FLDID4, 
	TOC.FLDID5, 
	TOC.FLDID6, 
	TOC.FLDID7, 
	TOC.FLDID8, 
	TOC.FLDID9, 
	TOC.FLDID10, 
	TOC.FLDID11, 
	TOC.FLDID12, 
	TOC.FLDID13, 
	TOC.FLDID14, 
	TOC.FLDID15, 
	TOC.FLDID1, 
	TOC.FLDID2, 
	TOC.FLDID3, 
	TOC.FLDID4, 
	TOC.FLDID5, 
	TOC.FLDID6, 
	TOC.FLDID7, 
	TOC.FLDID8, 
	TOC.FLDID9, 
	TOC.FLDID10, 
	TOC.FLDID11, 
	TOC.FLDID12, 
	TOC.FLDID13, 
	TOC.FLDID14, 
	TOC.FLDID15,
	A1.VALUEDESC1, 
	A1.VALUEDESC2, 
	A1.VALUEDESC3, 
	A1.VALUEDESC4, 
	A1.VALUEDESC5, 
	A1.VALUEDESC6, 
	A1.VALUEDESC7, 
	A1.VALUEDESC8, 
	A1.VALUEDESC9, 
	A1.VALUEDESC10, 
	A1.VALUEDESC11, 
	A1.VALUEDESC12, 
	A1.VALUEDESC13, 
	A1.VALUEDESC14, 
	A1.VALUEDESC15,
	P.Email,
	P.Email_2,
	P_Ext.ID_No
	from Acceptance A 
	Inner Join Profile P on (P.ID=A.AID) 
	Left Join Profile_Ext P_Ext on (P_Ext.ID=P.ID)
	Left Join TOPRO on (TOPRO.TOPRO=A.TOPRO)
	Inner Join AInfo A1 on (A1.ANO=A.ANO)
	Inner Join Cover C on (C.CNO=A.CNO)
	Inner Join TOC on (TOC.TOC=A.TOC)
	Inner Join COB on (COB.COB=TOC.COB)
	Inner Join PolicyType on (PolicyType.PolicyType=C.PolicyType)
	Inner Join (
		Select A.Source, A.ASource, min(Case When A.ANO>=@P_LastANO+1 Then @P_LastANO+1 else A.ANO end) as MinANO, max(A.ANO) as MaxANO
		from Acceptance A
		Inner Join Profile P on (P.ID=A.AID) 
		Left Join Profile_Ext P_Ext on (P_Ext.ID=P.ID)
		Inner Join AInfo A1 on (A1.ANO=A.ANO)
		Inner Join Cover C on (C.CNO=A.CNO)
		Inner Join TOC on (TOC.TOC=A.TOC)
		Where (A.Source=@P_ID)
		and (@P_ASource='<All>' or A.ASource=@P_ASource)
		and A.AStatus not in ('W','T') and C.CStatus<>'C' and A.pAStatus<>'W' 
		and (
			A.ANO>@P_LastANO 
			or ((A.AUserDate>@P_StartDate) or (A.AUserDate=@P_StartDate and A.AUserTime>@P_StartTime))
			or (A.PolicyNo=@P_PolicyNo and A.CertificateNo=@P_CertificateNo)
		)
		and (@P_PolicyNo='' or A.PolicyNo Like @P_PolicyNo +'%')
		and (@P_CertificateNo='' or A.CertificateNo Like @P_CertificateNo +'%')
		and (@P_RefNo='' or A.RefNo Like @P_RefNo+'%')
		and (@P_ID_NO='' or (P_Ext.ID_NO like @P_ID_NO+'%'))
		and (@P_Email='' or ((@P_EMail<>'' and P.Email=@P_EMail) or (@P_EMail<>'' and P.Email_2=@P_EMail)))
		and (@P_Branch='' or A.Branch=@P_Branch)
		and
		(
		@P_Info='' or
		replace(replace(
		Case When TOC.FLDID1<>'' Then TOC.FLDTAG1+' : '+cast(A1.VALUEDESC1 as varchar(100))+char(13)+char(10) else '' end
		+Case When TOC.FLDID2<>'' Then TOC.FLDTAG2+' : '+cast(A1.VALUEDESC2 as varchar(100))+char(13)+char(10) else '' end
		+Case When TOC.FLDID3<>'' Then TOC.FLDTAG3+' : '+cast(A1.VALUEDESC3 as varchar(100))+char(13)+char(10) else '' end
		+Case When TOC.FLDID4<>'' Then TOC.FLDTAG4+' : '+cast(A1.VALUEDESC4 as varchar(100))+char(13)+char(10) else '' end
		+Case When TOC.FLDID5<>'' Then TOC.FLDTAG5+' : '+cast(A1.VALUEDESC5 as varchar(100))+char(13)+char(10) else '' end
		+Case When TOC.FLDID6<>'' Then TOC.FLDTAG6+' : '+cast(A1.VALUEDESC6 as varchar(100))+char(13)+char(10) else '' end
		+Case When TOC.FLDID7<>'' Then TOC.FLDTAG7+' : '+cast(A1.VALUEDESC7 as varchar(100))+char(13)+char(10) else '' end
		+Case When TOC.FLDID8<>'' Then TOC.FLDTAG8+' : '+cast(A1.VALUEDESC8 as varchar(100))+char(13)+char(10) else '' end
		+Case When TOC.FLDID9<>'' Then TOC.FLDTAG9+' : '+cast(A1.VALUEDESC9 as varchar(100))+char(13)+char(10) else '' end
		+Case When TOC.FLDID10<>'' Then TOC.FLDTAG10+' : '+cast(A1.VALUEDESC10 as varchar(100))+char(13)+char(10) else '' end
		+Case When TOC.FLDID11<>'' Then TOC.FLDTAG11+' : '+cast(A1.VALUEDESC11 as varchar(100))+char(13)+char(10) else '' end
		+Case When TOC.FLDID12<>'' Then TOC.FLDTAG12+' : '+cast(A1.VALUEDESC12 as varchar(100))+char(13)+char(10) else '' end
		+Case When TOC.FLDID13<>'' Then TOC.FLDTAG13+' : '+cast(A1.VALUEDESC13 as varchar(100))+char(13)+char(10) else '' end
		+Case When TOC.FLDID14<>'' Then TOC.FLDTAG14+' : '+cast(A1.VALUEDESC14 as varchar(100))+char(13)+char(10) else '' end
		+Case When TOC.FLDID15<>'' Then TOC.FLDTAG15+' : '+cast(A1.VALUEDESC15 as varchar(100))+char(13)+char(10) else '' end
		,'-',''),' ','') Like '%'+Replace(Replace(@P_Info, '-', ''), ' ', '')+'%'
		)
		Group by A.Source, A.ASource
	) A2 on (1=1)
	Where A.ANO Between A2.MinANO and A2.MaxANO and A.ASource=A2.ASource
	and A.AStatus not in ('W','T') and C.CStatus<>'C' and A.pAStatus<>'W' 
	and A.Source=A2.Source
	Order by A.ANO
else if @P_ROLE='USER'
	Select TOP 100
	A.ANO, 
	A.OANO,
	A.RANO,
	A.AName,
	Case When C.OpenFlag=1 and A.CertificateNo<>'' then A.PolicyNo+'-'+A.CertificateNo else A.PolicyNo end as A_PolicyNo,
	A.PolicyNo,
	A.CERTIFICATENO,
	A.RefNo as A_RefNo,
	COB.Description,
	A.Remarks,
	A.SDate, A.EDate, A.PDate, A.ADate, A.AType, A.ASource,
	Case When A.AStatus Not in ('W','T') Then 'INFORCED' else '' end as AStatus,
	A.AID as AID,
	C.MO,
	A.Branch,
	A.Source,
	TOC.TOC as RefTOC,
	TOC.Description as RefTOCDesc,
	A.AUserDate as Last_Update,
	A.AUserTime as Last_Time,
	A.ExclusiveF,
	PolicyType.SType,
	C.ISType,
	Case When TOC.FLDID1<>'' Then TOC.FLDTAG1+' : '+cast(A1.VALUEDESC1 as varchar(100))+char(13)+char(10) else '' end
	+Case When TOC.FLDID2<>'' Then TOC.FLDTAG2+' : '+cast(A1.VALUEDESC2 as varchar(100))+char(13)+char(10) else '' end
	+Case When TOC.FLDID3<>'' Then TOC.FLDTAG3+' : '+cast(A1.VALUEDESC3 as varchar(100))+char(13)+char(10) else '' end
	+Case When TOC.FLDID4<>'' Then TOC.FLDTAG4+' : '+cast(A1.VALUEDESC4 as varchar(100))+char(13)+char(10) else '' end
	+Case When TOC.FLDID5<>'' Then TOC.FLDTAG5+' : '+cast(A1.VALUEDESC5 as varchar(100))+char(13)+char(10) else '' end
	+Case When TOC.FLDID6<>'' Then TOC.FLDTAG6+' : '+cast(A1.VALUEDESC6 as varchar(100))+char(13)+char(10) else '' end
	+Case When TOC.FLDID7<>'' Then TOC.FLDTAG7+' : '+cast(A1.VALUEDESC7 as varchar(100))+char(13)+char(10) else '' end
	+Case When TOC.FLDID8<>'' Then TOC.FLDTAG8+' : '+cast(A1.VALUEDESC8 as varchar(100))+char(13)+char(10) else '' end
	+Case When TOC.FLDID9<>'' Then TOC.FLDTAG9+' : '+cast(A1.VALUEDESC9 as varchar(100))+char(13)+char(10) else '' end
	+Case When TOC.FLDID10<>'' Then TOC.FLDTAG10+' : '+cast(A1.VALUEDESC10 as varchar(100))+char(13)+char(10) else '' end
	+Case When TOC.FLDID11<>'' Then TOC.FLDTAG11+' : '+cast(A1.VALUEDESC11 as varchar(100))+char(13)+char(10) else '' end
	+Case When TOC.FLDID12<>'' Then TOC.FLDTAG12+' : '+cast(A1.VALUEDESC12 as varchar(100))+char(13)+char(10) else '' end
	+Case When TOC.FLDID13<>'' Then TOC.FLDTAG13+' : '+cast(A1.VALUEDESC13 as varchar(100))+char(13)+char(10) else '' end
	+Case When TOC.FLDID14<>'' Then TOC.FLDTAG14+' : '+cast(A1.VALUEDESC14 as varchar(100))+char(13)+char(10) else '' end
	+Case When TOC.FLDID15<>'' Then TOC.FLDTAG15+' : '+cast(A1.VALUEDESC15 as varchar(100))+char(13)+char(10) else '' end
	as INFO,
	A.CANO,
	A.LANO,
	TOPRO.TOPRO as RefTOPRO,
	TOPRO.DESCRIPTION as RefTOPRODESC,
	TOC.FLDID1, 
	TOC.FLDID2, 
	TOC.FLDID3, 
	TOC.FLDID4, 
	TOC.FLDID5, 
	TOC.FLDID6, 
	TOC.FLDID7, 
	TOC.FLDID8, 
	TOC.FLDID9, 
	TOC.FLDID10, 
	TOC.FLDID11, 
	TOC.FLDID12, 
	TOC.FLDID13, 
	TOC.FLDID14, 
	TOC.FLDID15, 
	TOC.FLDID1, 
	TOC.FLDID2, 
	TOC.FLDID3, 
	TOC.FLDID4, 
	TOC.FLDID5, 
	TOC.FLDID6, 
	TOC.FLDID7, 
	TOC.FLDID8, 
	TOC.FLDID9, 
	TOC.FLDID10, 
	TOC.FLDID11, 
	TOC.FLDID12, 
	TOC.FLDID13, 
	TOC.FLDID14, 
	TOC.FLDID15,
	A1.VALUEDESC1, 
	A1.VALUEDESC2, 
	A1.VALUEDESC3, 
	A1.VALUEDESC4, 
	A1.VALUEDESC5, 
	A1.VALUEDESC6, 
	A1.VALUEDESC7, 
	A1.VALUEDESC8, 
	A1.VALUEDESC9, 
	A1.VALUEDESC10, 
	A1.VALUEDESC11, 
	A1.VALUEDESC12, 
	A1.VALUEDESC13, 
	A1.VALUEDESC14, 
	A1.VALUEDESC15,
	P.Email,
	P.Email_2,
	P_Ext.ID_No
	from Acceptance A 
	Left Join Profile P on (P.ID=A.AID) 
	Left Join Profile_Ext P_Ext on (P_Ext.ID=P.ID)
	Left Join TOPRO on (TOPRO.TOPRO=A.TOPRO)
	Inner Join AInfo A1 on (A1.ANO=A.ANO)
	Inner Join Cover C on (C.CNO=A.CNO)
	Inner Join TOC on (TOC.TOC=A.TOC)
	Inner Join COB on (COB.COB=TOC.COB)
	Inner Join PolicyType on (PolicyType.PolicyType=C.PolicyType)
	Where 
	A.AStatus not in ('W','T') and C.CStatus<>'C' and A.pAStatus<>'W' 
	--and (A.UserID=@P_ID)
	and (@P_ASource='<All>' or A.ASource=@P_ASource)
	--and (A.ANO>@P_LastANO or (((A.AUserDate>@P_StartDate) or (A.AUserDate=@P_StartDate and A.AUserTime>@P_StartTime)) and ((A.AUserDate<@P_LastDate) or (A.AUserDate=@P_LastDate and A.AUserTime<=@P_LastTime))))
	--and (A.ANO>@P_LastANO)
	and (@P_PolicyNo='' or A.PolicyNo Like @P_PolicyNo +'%')
	and (@P_CertificateNo='' or A.CertificateNo Like @P_CertificateNo +'%')
	and (@P_RefNo='' or A.RefNo Like @P_RefNo+'%')
	and (@P_ID_NO='' or (P_Ext.ID_NO like @P_ID_NO+'%'))
	and (@P_Email='' or ((@P_EMail<>'' and P.Email=@P_EMail) or (@P_EMail<>'' and P.Email_2=@P_EMail)))
	and (@P_Branch='' or A.Branch=@P_Branch)
	and
	(
	@P_Info='' or
	replace(replace(
	Case When TOC.FLDID1<>'' Then TOC.FLDTAG1+' : '+cast(A1.VALUEDESC1 as varchar(100))+char(13)+char(10) else '' end
	+Case When TOC.FLDID2<>'' Then TOC.FLDTAG2+' : '+cast(A1.VALUEDESC2 as varchar(100))+char(13)+char(10) else '' end
	+Case When TOC.FLDID3<>'' Then TOC.FLDTAG3+' : '+cast(A1.VALUEDESC3 as varchar(100))+char(13)+char(10) else '' end
	+Case When TOC.FLDID4<>'' Then TOC.FLDTAG4+' : '+cast(A1.VALUEDESC4 as varchar(100))+char(13)+char(10) else '' end
	+Case When TOC.FLDID5<>'' Then TOC.FLDTAG5+' : '+cast(A1.VALUEDESC5 as varchar(100))+char(13)+char(10) else '' end
	+Case When TOC.FLDID6<>'' Then TOC.FLDTAG6+' : '+cast(A1.VALUEDESC6 as varchar(100))+char(13)+char(10) else '' end
	+Case When TOC.FLDID7<>'' Then TOC.FLDTAG7+' : '+cast(A1.VALUEDESC7 as varchar(100))+char(13)+char(10) else '' end
	+Case When TOC.FLDID8<>'' Then TOC.FLDTAG8+' : '+cast(A1.VALUEDESC8 as varchar(100))+char(13)+char(10) else '' end
	+Case When TOC.FLDID9<>'' Then TOC.FLDTAG9+' : '+cast(A1.VALUEDESC9 as varchar(100))+char(13)+char(10) else '' end
	+Case When TOC.FLDID10<>'' Then TOC.FLDTAG10+' : '+cast(A1.VALUEDESC10 as varchar(100))+char(13)+char(10) else '' end
	+Case When TOC.FLDID11<>'' Then TOC.FLDTAG11+' : '+cast(A1.VALUEDESC11 as varchar(100))+char(13)+char(10) else '' end
	+Case When TOC.FLDID12<>'' Then TOC.FLDTAG12+' : '+cast(A1.VALUEDESC12 as varchar(100))+char(13)+char(10) else '' end
	+Case When TOC.FLDID13<>'' Then TOC.FLDTAG13+' : '+cast(A1.VALUEDESC13 as varchar(100))+char(13)+char(10) else '' end
	+Case When TOC.FLDID14<>'' Then TOC.FLDTAG14+' : '+cast(A1.VALUEDESC14 as varchar(100))+char(13)+char(10) else '' end
	+Case When TOC.FLDID15<>'' Then TOC.FLDTAG15+' : '+cast(A1.VALUEDESC15 as varchar(100))+char(13)+char(10) else '' end
	,'-',''),' ','') Like '%'+Replace(Replace(@P_Info, '-', ''), ' ', '')+'%'
	)
	Order by A.ANO
else-- ROLE = 'MARKETING OFFICER'
	Select TOP 100
	A.ANO, 
	A.OANO,
	A.RANO,
	A.AName,
	Case When C.OpenFlag=1 and A.CertificateNo<>'' then A.PolicyNo+'-'+A.CertificateNo else A.PolicyNo end as A_PolicyNo,
	A.PolicyNo,
	A.CERTIFICATENO,
	A.RefNo as A_RefNo,
	COB.Description,
	A.Remarks,
	A.SDate, A.EDate, A.PDate, A.ADate, A.AType, A.ASource,
	Case When A.AStatus Not in ('W','T') Then 'INFORCED' else '' end as AStatus,
	A.AID as AID,
	C.MO,
	A.Branch,
	A.Source,
	TOC.TOC as RefTOC,
	TOC.Description as RefTOCDesc,
	A.AUserDate as Last_Update,
	A.AUserTime as Last_Time,
	A.ExclusiveF,
	PolicyType.SType,
	C.ISType,
	Case When TOC.FLDID1<>'' Then TOC.FLDTAG1+' : '+cast(A1.VALUEDESC1 as varchar(100))+char(13)+char(10) else '' end
	+Case When TOC.FLDID2<>'' Then TOC.FLDTAG2+' : '+cast(A1.VALUEDESC2 as varchar(100))+char(13)+char(10) else '' end
	+Case When TOC.FLDID3<>'' Then TOC.FLDTAG3+' : '+cast(A1.VALUEDESC3 as varchar(100))+char(13)+char(10) else '' end
	+Case When TOC.FLDID4<>'' Then TOC.FLDTAG4+' : '+cast(A1.VALUEDESC4 as varchar(100))+char(13)+char(10) else '' end
	+Case When TOC.FLDID5<>'' Then TOC.FLDTAG5+' : '+cast(A1.VALUEDESC5 as varchar(100))+char(13)+char(10) else '' end
	+Case When TOC.FLDID6<>'' Then TOC.FLDTAG6+' : '+cast(A1.VALUEDESC6 as varchar(100))+char(13)+char(10) else '' end
	+Case When TOC.FLDID7<>'' Then TOC.FLDTAG7+' : '+cast(A1.VALUEDESC7 as varchar(100))+char(13)+char(10) else '' end
	+Case When TOC.FLDID8<>'' Then TOC.FLDTAG8+' : '+cast(A1.VALUEDESC8 as varchar(100))+char(13)+char(10) else '' end
	+Case When TOC.FLDID9<>'' Then TOC.FLDTAG9+' : '+cast(A1.VALUEDESC9 as varchar(100))+char(13)+char(10) else '' end
	+Case When TOC.FLDID10<>'' Then TOC.FLDTAG10+' : '+cast(A1.VALUEDESC10 as varchar(100))+char(13)+char(10) else '' end
	+Case When TOC.FLDID11<>'' Then TOC.FLDTAG11+' : '+cast(A1.VALUEDESC11 as varchar(100))+char(13)+char(10) else '' end
	+Case When TOC.FLDID12<>'' Then TOC.FLDTAG12+' : '+cast(A1.VALUEDESC12 as varchar(100))+char(13)+char(10) else '' end
	+Case When TOC.FLDID13<>'' Then TOC.FLDTAG13+' : '+cast(A1.VALUEDESC13 as varchar(100))+char(13)+char(10) else '' end
	+Case When TOC.FLDID14<>'' Then TOC.FLDTAG14+' : '+cast(A1.VALUEDESC14 as varchar(100))+char(13)+char(10) else '' end
	+Case When TOC.FLDID15<>'' Then TOC.FLDTAG15+' : '+cast(A1.VALUEDESC15 as varchar(100))+char(13)+char(10) else '' end
	as INFO,
	A.CANO,
	A.LANO,
	TOPRO.TOPRO as RefTOPRO,
	TOPRO.DESCRIPTION as RefTOPRODESC,
	TOC.FLDID1, 
	TOC.FLDID2, 
	TOC.FLDID3, 
	TOC.FLDID4, 
	TOC.FLDID5, 
	TOC.FLDID6, 
	TOC.FLDID7, 
	TOC.FLDID8, 
	TOC.FLDID9, 
	TOC.FLDID10, 
	TOC.FLDID11, 
	TOC.FLDID12, 
	TOC.FLDID13, 
	TOC.FLDID14, 
	TOC.FLDID15, 
	TOC.FLDID1, 
	TOC.FLDID2, 
	TOC.FLDID3, 
	TOC.FLDID4, 
	TOC.FLDID5, 
	TOC.FLDID6, 
	TOC.FLDID7, 
	TOC.FLDID8, 
	TOC.FLDID9, 
	TOC.FLDID10, 
	TOC.FLDID11, 
	TOC.FLDID12, 
	TOC.FLDID13, 
	TOC.FLDID14, 
	TOC.FLDID15,
	A1.VALUEDESC1, 
	A1.VALUEDESC2, 
	A1.VALUEDESC3, 
	A1.VALUEDESC4, 
	A1.VALUEDESC5, 
	A1.VALUEDESC6, 
	A1.VALUEDESC7, 
	A1.VALUEDESC8, 
	A1.VALUEDESC9, 
	A1.VALUEDESC10, 
	A1.VALUEDESC11, 
	A1.VALUEDESC12, 
	A1.VALUEDESC13, 
	A1.VALUEDESC14, 
	A1.VALUEDESC15,
	P.Email,
	P.Email_2,
	P_Ext.ID_No
	from Acceptance A 
	Inner Join Profile P on (P.ID=A.AID) 
	Left Join Profile_Ext P_Ext on (P_Ext.ID=P.ID)
	Left Join TOPRO on (TOPRO.TOPRO=A.TOPRO)
	Inner Join AInfo A1 on (A1.ANO=A.ANO)
	Inner Join Cover C on (C.CNO=A.CNO)
	Inner Join TOC on (TOC.TOC=A.TOC)
	Inner Join COB on (COB.COB=TOC.COB)
	Inner Join PolicyType on (PolicyType.PolicyType=C.PolicyType)
	Inner Join (
		Select C.MO, A.ASource, min(Case When A.ANO>=@P_LastANO+1 Then @P_LastANO+1 else A.ANO end) as MinANO, max(A.ANO) as MaxANO
		from Acceptance A
		Inner Join Profile P on (P.ID=A.AID) 
		Left Join Profile_Ext P_Ext on (P_Ext.ID=P.ID)
		Inner Join AInfo A1 on (A1.ANO=A.ANO)
		Inner Join Cover C on (C.CNO=A.CNO)
		Inner Join TOC on (TOC.TOC=A.TOC)
		Where  
		(C.MO=@P_ID)
		and (@P_ASource='<All>' or A.ASource=@P_ASource)
		and A.AStatus not in ('W','T') and C.CStatus<>'C' and A.pAStatus<>'W' 
		and (
			A.ANO>@P_LastANO 
			or ((A.AUserDate>@P_StartDate) or (A.AUserDate=@P_StartDate and A.AUserTime>@P_StartTime))
			or (A.PolicyNo=@P_PolicyNo and A.CertificateNo=@P_CertificateNo)
		)
		and (@P_PolicyNo='' or A.PolicyNo Like @P_PolicyNo +'%')
		and (@P_CertificateNo='' or A.CertificateNo Like @P_CertificateNo +'%')
		and (@P_RefNo='' or A.RefNo Like @P_RefNo+'%')
		and (@P_ID_NO='' or (P_Ext.ID_NO like @P_ID_NO+'%'))
		and (@P_Email='' or ((@P_EMail<>'' and P.Email=@P_EMail) or (@P_EMail<>'' and P.Email_2=@P_EMail)))
		and (@P_Branch='' or A.Branch=@P_Branch)
		and
		(
		@P_Info='' or
		replace(replace(
		Case When TOC.FLDID1<>'' Then TOC.FLDTAG1+' : '+cast(A1.VALUEDESC1 as varchar(100))+char(13)+char(10) else '' end
		+Case When TOC.FLDID2<>'' Then TOC.FLDTAG2+' : '+cast(A1.VALUEDESC2 as varchar(100))+char(13)+char(10) else '' end
		+Case When TOC.FLDID3<>'' Then TOC.FLDTAG3+' : '+cast(A1.VALUEDESC3 as varchar(100))+char(13)+char(10) else '' end
		+Case When TOC.FLDID4<>'' Then TOC.FLDTAG4+' : '+cast(A1.VALUEDESC4 as varchar(100))+char(13)+char(10) else '' end
		+Case When TOC.FLDID5<>'' Then TOC.FLDTAG5+' : '+cast(A1.VALUEDESC5 as varchar(100))+char(13)+char(10) else '' end
		+Case When TOC.FLDID6<>'' Then TOC.FLDTAG6+' : '+cast(A1.VALUEDESC6 as varchar(100))+char(13)+char(10) else '' end
		+Case When TOC.FLDID7<>'' Then TOC.FLDTAG7+' : '+cast(A1.VALUEDESC7 as varchar(100))+char(13)+char(10) else '' end
		+Case When TOC.FLDID8<>'' Then TOC.FLDTAG8+' : '+cast(A1.VALUEDESC8 as varchar(100))+char(13)+char(10) else '' end
		+Case When TOC.FLDID9<>'' Then TOC.FLDTAG9+' : '+cast(A1.VALUEDESC9 as varchar(100))+char(13)+char(10) else '' end
		+Case When TOC.FLDID10<>'' Then TOC.FLDTAG10+' : '+cast(A1.VALUEDESC10 as varchar(100))+char(13)+char(10) else '' end
		+Case When TOC.FLDID11<>'' Then TOC.FLDTAG11+' : '+cast(A1.VALUEDESC11 as varchar(100))+char(13)+char(10) else '' end
		+Case When TOC.FLDID12<>'' Then TOC.FLDTAG12+' : '+cast(A1.VALUEDESC12 as varchar(100))+char(13)+char(10) else '' end
		+Case When TOC.FLDID13<>'' Then TOC.FLDTAG13+' : '+cast(A1.VALUEDESC13 as varchar(100))+char(13)+char(10) else '' end
		+Case When TOC.FLDID14<>'' Then TOC.FLDTAG14+' : '+cast(A1.VALUEDESC14 as varchar(100))+char(13)+char(10) else '' end
		+Case When TOC.FLDID15<>'' Then TOC.FLDTAG15+' : '+cast(A1.VALUEDESC15 as varchar(100))+char(13)+char(10) else '' end
		,'-',''),' ','') Like '%'+Replace(Replace(@P_Info, '-', ''), ' ', '')+'%'
		)
		Group By C.MO, A.ASource
	) A2 on (1=1)
	Where A.ANO Between A2.MinANO and A2.MaxANO and A.ASource=A2.ASource
	and A.AStatus not in ('W','T') and C.CStatus<>'C' and A.pAStatus<>'W' 
	and C.MO=A2.MO
	Order by A.ANO

GO

DROP PROCEDURE  GetStoredClaim
GO
CREATE PROCEDURE  GetStoredClaim(@P_ID as varchar(10), @P_Role as varchar(10),@P_StartDate as smalldatetime, @P_StartTime as varchar(5),@P_LastDate as smalldatetime, @P_LastTime as varchar(5), @P_LastCNO as int, @P_ASource as varchar(10)='', @P_PolicyNo as varchar(50)='', @P_ClaimNo as varchar(50)='', @P_RefNo as varchar(50)='', @P_EMail as varchar(100)='', @P_ID_NO as varchar(100)='', @P_Branch as varchar(10)='', @P_ClaimRefNo as varchar(50)='')  
as   

Declare @P_CertificateNo as varchar(50)

if charindex('-', @P_PolicyNo)<>0
Begin
	Select @P_CertificateNo=substring(@P_PolicyNO,charindex('-', @P_PolicyNo)+1,len(@P_PolicyNo)-charindex('-', @P_PolicyNo))
	Select @P_PolicyNo=left(@P_PolicyNO,charindex('-', @P_PolicyNo)-1)
end
else
Begin
	Select @P_CertificateNo=''
End

if @P_Role='CLIENT'
	Select TOP 100
	C.CNO, 
	C.ANO,
	C.OCNO,
	C.CLaimantInfo, 
	C.ClaimNo, 
	Case When C1.OpenFlag=1 and A.CertificateNo<>'' then A.PolicyNo+'-'+A.CertificateNo else A.PolicyNo end as A_PolicyNo,
	A.PolicyNo,
	A.CERTIFICATENO,
	A.RefNo as A_RefNo,
	C.RefNo as C_RefNo,
	C.LossDate, 
	C.LossPlace, 
	C.Description, 
	C.Remarks, 
	C.CType, 
	Case When C.CStatus='R' Then 'REQUEST' When C.CStatus='A'or C.PCStatus='A' Then 'APPROVED' When C.CStatus in ('P','T') Then 'IN-PROCESS' Else 'DECLINED' end as CStatus,
	A.AID as AID,
	C1.MO,
	A.Branch,
	A.Source,
	TOC.TOC as RefTOC,
	TOC.Description as RefTOCDesc,
	TOPRO.Description as RefTOPRODESC,
	C.COL as RefCOL,
	COL.Description as RefCOLDesc,
	C.AUserDate as Last_Update,
	C.AUserTime as Last_Time,
	P.Email,
	P.Email_2,
	P_Ext.ID_No
	from Claim C 
	Inner Join Acceptance A on (A.ANO=C.ANO)
	Inner Join Cover C1 on (C1.CNO=A.CNO)
	Inner Join TOC on (TOC.TOC=A.TOC)
	Inner Join COLTAB COL on (COL.COL=C.COL)
	Left Join Profile P on (P.ID=A.AID) 
	Left Join Profile_Ext P_Ext on (P_Ext.ID=P.ID)
	Left Join TOPRO on (TOPRO.TOPRO=A.TOPRO) 
	Inner Join (
		Select A.AID, A.ASource, min(Case When C.CNO>=@P_LastCNO+1 Then @P_LastCNO+1 else C.CNO end) as MinCNO, max(C.CNO) as MaxCNO
		from Claim C
		Inner Join Acceptance A on (A.ANO=C.ANO)
		Inner Join Cover C1 on (C1.CNO=A.CNO)
		Left Join Profile P on (P.ID=A.AID) 
		Left Join Profile_Ext P_Ext on (P_Ext.ID=P.ID)
		Where (@P_ID='' or A.AID=@P_ID)
		and (@P_ASource='<All>' or A.ASource=@P_ASource)
		and (C.CStatus='R') and (C.CNO>@P_LastCNO or ((C.LDate>@P_StartDate) or (C.LDate=@P_StartDate and C.LTime>@P_StartTime)))
		and (@P_ClaimNo='' or C.ClaimNo Like @P_ClaimNo+'%')
		and (@P_RefNo='' or A.RefNo like @P_RefNo+'%')
		and (@P_ClaimRefNo='' or C.RefNo Like @P_ClaimRefNo+'%')
		and (@P_PolicyNo='' or C.PolicyNo like @P_PolicyNo+'%')
		and (@P_CertificateNo='' or C.CertificateNo like @P_CertificateNo+'%')
		and (@P_Branch='' or A.Branch=@P_Branch)
		and (@P_ID_NO='' or (P_Ext.ID_NO like @P_ID_NO+'%'))
		and (@P_Email='' or ((@P_EMail<>'' and P.Email=@P_EMail) or (@P_EMail<>'' and P.Email_2=@P_EMail)))
		Group by A.AID, A.ASource
	) C2 on (1=1)
	Where C.CNO Between C2.MinCNO and C2.MaxCNO and A.ASource=C2.ASource
	and (C.CStatus='R')	
	and A.AID=C2.AID

	Union All

	Select TOP 100
	C.CNO, 
	C.ANO,
	C.OCNO,
	C.CLaimantInfo, 
	C.ClaimNo, 
	Case When C1.OpenFlag=1 and A.CertificateNo<>'' then A.PolicyNo+'-'+A.CertificateNo else A.PolicyNo end as A_PolicyNo,
	A.PolicyNo,
	A.CERTIFICATENO,
	A.RefNo as A_RefNo,
	C.RefNo as C_RefNo,
	C.LossDate, 
	C.LossPlace, 
	C.Description, 
	C.Remarks, 
	C.CType, 
	Case When C.CStatus='R' Then 'REQUEST' When C.CStatus='A'or C.PCStatus='A' Then 'APPROVED' When C.CStatus in ('P','T') Then 'IN-PROCESS' Else 'DECLINED' end as CStatus,
	A.AID as AID,
	C1.MO,
	A.Branch,
	A.Source,
	TOC.TOC as RefTOC,
	TOC.Description as RefTOCDesc,
	TOPRO.Description as RefTOPRODESC,
	C.COL as RefCOL,
	COL.Description as RefCOLDesc,
	C.AUserDate as Last_Update,
	C.AUserTime as Last_Time,
	P.Email,
	P.Email_2,
	P_Ext.ID_No
	from Claim C 
	Inner Join Acceptance A on (A.ANO=C.ANO)
	Inner Join Cover C1 on (C1.CNO=A.CNO)
	Inner Join TOC on (TOC.TOC=A.TOC)
	Inner Join COLTAB COL on (COL.COL=C.COL)
	Left Join Profile P on (P.ID=A.AID) 
	Left Join Profile_Ext P_Ext on (P_Ext.ID=P.ID)
	Left Join TOPRO on (TOPRO.TOPRO=A.TOPRO) 
	Inner Join (
		Select A.AID, A.ASource, min(Case When C.CNO>=@P_LastCNO+1 Then @P_LastCNO+1 else C.CNO end) as MinCNO, max(C.CNO) as MaxCNO
		from Claim C
		Inner Join Acceptance A on (A.ANO=C.ANO)
		Inner Join Cover C1 on (C1.CNO=A.CNO)
		Left Join Profile P on (P.ID=A.AID) 
		Left Join Profile_Ext P_Ext on (P_Ext.ID=P.ID)
		Where (@P_ID='' or A.AID=@P_ID)
		and (@P_ASource='<All>' or A.ASource=@P_ASource)
		and (C.CStatus='A' or C.PCStatus='A')
		and (C.CNO>@P_LastCNO or ((C.AUserDate>@P_StartDate) or (C.AUserDate=@P_StartDate and C.AUserTime>@P_StartTime)))
		and (@P_ClaimNo='' or C.ClaimNo Like @P_ClaimNo+'%')
		and (@P_RefNo='' or A.RefNo like @P_RefNo+'%')
		and (@P_ClaimRefNo='' or C.RefNo Like @P_ClaimRefNo+'%')
		and (@P_PolicyNo='' or C.PolicyNo like @P_PolicyNo+'%')
		and (@P_CertificateNo='' or C.CertificateNo like @P_CertificateNo+'%')
		and (@P_Branch='' or A.Branch=@P_Branch)
		and (@P_ID_NO='' or (P_Ext.ID_NO like @P_ID_NO+'%'))
		and (@P_Email='' or ((@P_EMail<>'' and P.Email=@P_EMail) or (@P_EMail<>'' and P.Email_2=@P_EMail)))
		Group by A.AID, A.ASource
	) C2 on (1=1)
	Where C.CNO Between C2.MinCNO and C2.MaxCNO and A.ASource=C2.ASource
	and (C.CStatus='A' or C.PCStatus='A')
	and A.AID=C2.AID

	Union All

	Select TOP 100
	C.CNO, 
	C.ANO,
	C.OCNO,
	C.CLaimantInfo, 
	C.ClaimNo, 
	Case When C1.OpenFlag=1 and A.CertificateNo<>'' then A.PolicyNo+'-'+A.CertificateNo else A.PolicyNo end as A_PolicyNo,
	A.PolicyNo,
	A.CERTIFICATENO,
	A.RefNo as A_RefNo,
	C.RefNo as C_RefNo,
	C.LossDate, 
	C.LossPlace, 
	C.Description, 
	C.Remarks, 
	C.CType, 
	Case When C.CStatus='R' Then 'REQUEST' When C.CStatus='A'or C.PCStatus='A' Then 'APPROVED' When C.CStatus in ('P','T') Then 'IN-PROCESS' Else 'DECLINED' end as CStatus,
	A.AID as AID,
	C1.MO,
	A.Branch,
	A.Source,
	TOC.TOC as RefTOC,
	TOC.Description as RefTOCDesc,
	TOPRO.Description as RefTOPRODESC,
	C.COL as RefCOL,
	COL.Description as RefCOLDesc,
	C.PUserDate as Last_Update,
	C.PUserTime as Last_Time,
	P.Email,
	P.Email_2,
	P_Ext.ID_No
	from Claim C 
	Inner Join Acceptance A on (A.ANO=C.ANO)
	Inner Join Cover C1 on (C1.CNO=A.CNO)
	Inner Join TOC on (TOC.TOC=A.TOC)
	Inner Join COLTAB COL on (COL.COL=C.COL)
	Left Join Profile P on (P.ID=A.AID) 
	Left Join Profile_Ext P_Ext on (P_Ext.ID=P.ID)
	Left Join TOPRO on (TOPRO.TOPRO=A.TOPRO) 
	Inner Join (
		Select A.AID, A.ASource, min(Case When C.CNO>=@P_LastCNO+1 Then @P_LastCNO+1 else C.CNO end) as MinCNO, max(C.CNO) as MaxCNO
		from Claim C
		Inner Join Acceptance A on (A.ANO=C.ANO)
		Inner Join Cover C1 on (C1.CNO=A.CNO)
		Left Join Profile P on (P.ID=A.AID) 
		Left Join Profile_Ext P_Ext on (P_Ext.ID=P.ID)
		Where (@P_ID='' or A.AID=@P_ID)
		and (@P_ASource='<All>' or A.ASource=@P_ASource)
		and (C.CStatus in ('P','T'))
		and (C.CNO>@P_LastCNO or ((C.PUserDate>@P_StartDate) or (C.PUserDate=@P_StartDate and C.PUserTime>@P_StartTime)))
		and (@P_ClaimNo='' or C.ClaimNo Like @P_ClaimNo+'%')
		and (@P_RefNo='' or A.RefNo like @P_RefNo+'%')
		and (@P_ClaimRefNo='' or C.RefNo Like @P_ClaimRefNo+'%')
		and (@P_PolicyNo='' or C.PolicyNo like @P_PolicyNo+'%')
		and (@P_CertificateNo='' or C.CertificateNo like @P_CertificateNo+'%')
		and (@P_Branch='' or A.Branch=@P_Branch)
		and (@P_ID_NO='' or (P_Ext.ID_NO like @P_ID_NO+'%'))
		and (@P_Email='' or ((@P_EMail<>'' and P.Email=@P_EMail) or (@P_EMail<>'' and P.Email_2=@P_EMail)))
		Group by A.AID, A.ASource
	) C2 on (1=1)
	Where C.CNO Between C2.MinCNO and C2.MaxCNO and A.ASource=C2.ASource
	and (C.CStatus in ('P','T'))
	and A.AID=C2.AID

	Union All

	Select TOP 100
	C.CNO, 
	C.ANO,
	C.OCNO,
	C.CLaimantInfo, 
	C.ClaimNo, 
	Case When C1.OpenFlag=1 and A.CertificateNo<>'' then A.PolicyNo+'-'+A.CertificateNo else A.PolicyNo end as A_PolicyNo,
	A.PolicyNo,
	A.CERTIFICATENO,
	A.RefNo as A_RefNo,
	C.RefNo as C_RefNo,
	C.LossDate, 
	C.LossPlace, 
	C.Description, 
	C.Remarks, 
	C.CType, 
	Case When C.CStatus='R' Then 'REQUEST' When C.CStatus='A'or C.PCStatus='A' Then 'APPROVED' When C.CStatus in ('P','T') Then 'IN-PROCESS' Else 'DECLINED' end as CStatus,
	A.AID as AID,
	C1.MO,
	A.Branch,
	A.Source,
	TOC.TOC as RefTOC,
	TOC.Description as RefTOCDesc,
	TOPRO.Description as RefTOPRODESC,
	C.COL as RefCOL,
	COL.Description as RefCOLDesc,
	C.CloseDate as Last_Update,
	C.CloseTime as Last_Time,
	P.Email,
	P.Email_2,
	P_Ext.ID_No
	from Claim C 
	Inner Join Acceptance A on (A.ANO=C.ANO)
	Inner Join Cover C1 on (C1.CNO=A.CNO)
	Inner Join TOC on (TOC.TOC=A.TOC)
	Inner Join COLTAB COL on (COL.COL=C.COL)
	Left Join Profile P on (P.ID=A.AID) 
	Left Join Profile_Ext P_Ext on (P_Ext.ID=P.ID)
	Left Join TOPRO on (TOPRO.TOPRO=A.TOPRO) 
	Inner Join (
		Select A.AID, A.ASource, min(Case When C.CNO>=@P_LastCNO+1 Then @P_LastCNO+1 else C.CNO end) as MinCNO, max(C.CNO) as MaxCNO
		from Claim C
		Inner Join Acceptance A on (A.ANO=C.ANO)
		Inner Join Cover C1 on (C1.CNO=A.CNO)
		Left Join Profile P on (P.ID=A.AID) 
		Left Join Profile_Ext P_Ext on (P_Ext.ID=P.ID)
		Where (@P_ID='' or A.AID=@P_ID)
		and (@P_ASource='<All>' or A.ASource=@P_ASource)
		and (C.CStatus='C' and C.PCSTATUS='P')
		and (C.CNO>@P_LastCNO or ((C.CloseDate>@P_StartDate) or (C.CloseDate=@P_StartDate and C.CloseTime>@P_StartTime)))
		and (@P_ClaimNo='' or C.ClaimNo Like @P_ClaimNo+'%')
		and (@P_RefNo='' or A.RefNo like @P_RefNo+'%')
		and (@P_ClaimRefNo='' or C.RefNo Like @P_ClaimRefNo+'%')
		and (@P_PolicyNo='' or C.PolicyNo like @P_PolicyNo+'%')
		and (@P_CertificateNo='' or C.CertificateNo like @P_CertificateNo+'%')
		and (@P_Branch='' or A.Branch=@P_Branch)
		and (@P_ID_NO='' or (P_Ext.ID_NO like @P_ID_NO+'%'))
		and (@P_Email='' or ((@P_EMail<>'' and P.Email=@P_EMail) or (@P_EMail<>'' and P.Email_2=@P_EMail)))
		Group by A.AID, A.ASource
	) C2 on (1=1)
	Where C.CNO Between C2.MinCNO and C2.MaxCNO and A.ASource=C2.ASource
	and (C.CStatus='C' and C.PCSTATUS='P')
	and A.AID=C2.AID
	Order by C.CNO
else if @P_Role='AGENT'
	Select TOP 100
	C.CNO, 
	C.ANO,
	C.OCNO,
	C.CLaimantInfo, 
	C.ClaimNo, 
	Case When C1.OpenFlag=1 and A.CertificateNo<>'' then A.PolicyNo+'-'+A.CertificateNo else A.PolicyNo end as A_PolicyNo,
	A.PolicyNo,
	A.CERTIFICATENO,
	A.RefNo as A_RefNo,
	C.RefNo as C_RefNo,
	C.LossDate, 
	C.LossPlace, 
	C.Description, 
	C.Remarks, 
	C.CType, 
	Case When C.CStatus='R' Then 'REQUEST' When C.CStatus='A'or C.PCStatus='A' Then 'APPROVED' When C.CStatus in ('P','T') Then 'IN-PROCESS' Else 'DECLINED' end as CStatus,
	A.AID as AID,
	C1.MO,
	A.Branch,
	A.Source,
	TOC.TOC as RefTOC,
	TOC.Description as RefTOCDesc,
	TOPRO.Description as RefTOPRODESC,
	C.COL as RefCOL,
	COL.Description as RefCOLDesc,
	C.AUserDate as Last_Update,
	C.AUserTime as Last_Time,
	P.Email,
	P.Email_2,
	P_Ext.ID_No
	from Claim C 
	Inner Join Acceptance A on (A.ANO=C.ANO)
	Inner Join Cover C1 on (C1.CNO=A.CNO)
	Inner Join TOC on (TOC.TOC=A.TOC)
	Inner Join COLTAB COL on (COL.COL=C.COL)
	Left Join Profile P on (P.ID=A.AID) 
	Left Join Profile_Ext P_Ext on (P_Ext.ID=P.ID)
	Left Join TOPRO on (TOPRO.TOPRO=A.TOPRO) 
	Inner Join (
		Select A.Source, A.ASource, min(Case When C.CNO>=@P_LastCNO+1 Then @P_LastCNO+1 else C.CNO end) as MinCNO, max(C.CNO) as MaxCNO
		from Claim C
		Inner Join Acceptance A on (A.ANO=C.ANO)
		Inner Join Cover C1 on (C1.CNO=A.CNO)
		Left Join Profile P on (P.ID=A.AID) 
		Left Join Profile_Ext P_Ext on (P_Ext.ID=P.ID)
		Where (A.Source=@P_ID)
		and (@P_ASource='<All>' or A.ASource=@P_ASource)
		and (C.CStatus='R') and (C.CNO>@P_LastCNO or ((C.LDate>@P_StartDate) or (C.LDate=@P_StartDate and C.LTime>@P_StartTime)))
		and (@P_ClaimNo='' or C.ClaimNo Like @P_ClaimNo+'%')
		and (@P_RefNo='' or A.RefNo like @P_RefNo+'%')
		and (@P_ClaimRefNo='' or C.RefNo Like @P_ClaimRefNo+'%')
		and (@P_PolicyNo='' or C.PolicyNo like @P_PolicyNo+'%')
		and (@P_CertificateNo='' or C.CertificateNo like @P_CertificateNo+'%')
		and (@P_Branch='' or A.Branch=@P_Branch)
		and (@P_ID_NO='' or (P_Ext.ID_NO like @P_ID_NO+'%'))
		and (@P_Email='' or ((@P_EMail<>'' and P.Email=@P_EMail) or (@P_EMail<>'' and P.Email_2=@P_EMail)))
		and (@P_Branch='' or A.Branch=@P_Branch)
		Group By A.Source, A.ASource
	) C2 on (1=1)
	Where C.CNO Between C2.MinCNO and C2.MaxCNO and A.ASource=C2.ASource
	and (C.CStatus='R')
	and A.Source=C2.Source

	Union All

	Select TOP 100
	C.CNO, 
	C.ANO,
	C.OCNO,
	C.CLaimantInfo, 
	C.ClaimNo, 
	Case When C1.OpenFlag=1 and A.CertificateNo<>'' then A.PolicyNo+'-'+A.CertificateNo else A.PolicyNo end as A_PolicyNo,
	A.PolicyNo,
	A.CERTIFICATENO,
	A.RefNo as A_RefNo,
	C.RefNo as C_RefNo,
	C.LossDate, 
	C.LossPlace, 
	C.Description, 
	C.Remarks, 
	C.CType, 
	Case When C.CStatus='R' Then 'REQUEST' When C.CStatus='A'or C.PCStatus='A' Then 'APPROVED' When C.CStatus in ('P','T') Then 'IN-PROCESS' Else 'DECLINED' end as CStatus,
	A.AID as AID,
	C1.MO,
	A.Branch,
	A.Source,
	TOC.TOC as RefTOC,
	TOC.Description as RefTOCDesc,
	TOPRO.Description as RefTOPRODESC,
	C.COL as RefCOL,
	COL.Description as RefCOLDesc,
	C.AUserDate as Last_Update,
	C.AUserTime as Last_Time,
	P.Email,
	P.Email_2,
	P_Ext.ID_No
	from Claim C 
	Inner Join Acceptance A on (A.ANO=C.ANO)
	Inner Join Cover C1 on (C1.CNO=A.CNO)
	Inner Join TOC on (TOC.TOC=A.TOC)
	Inner Join COLTAB COL on (COL.COL=C.COL)
	Left Join Profile P on (P.ID=A.AID) 
	Left Join Profile_Ext P_Ext on (P_Ext.ID=P.ID)
	Left Join TOPRO on (TOPRO.TOPRO=A.TOPRO) 
	Inner Join (
		Select A.Source, A.ASource, min(Case When C.CNO>=@P_LastCNO+1 Then @P_LastCNO+1 else C.CNO end) as MinCNO, max(C.CNO) as MaxCNO
		from Claim C
		Inner Join Acceptance A on (A.ANO=C.ANO)
		Inner Join Cover C1 on (C1.CNO=A.CNO)
		Left Join Profile P on (P.ID=A.AID) 
		Left Join Profile_Ext P_Ext on (P_Ext.ID=P.ID)
		Where (A.Source=@P_ID)
		and (@P_ASource='<All>' or A.ASource=@P_ASource)
		and (C.CStatus='A' or C.PCStatus='A')
		and (C.CNO>@P_LastCNO or ((C.AUserDate>@P_StartDate) or (C.AUserDate=@P_StartDate and C.AUserTime>@P_StartTime)))
		and (@P_ClaimNo='' or C.ClaimNo Like @P_ClaimNo+'%')
		and (@P_RefNo='' or A.RefNo like @P_RefNo+'%')
		and (@P_ClaimRefNo='' or C.RefNo Like @P_ClaimRefNo+'%')
		and (@P_PolicyNo='' or C.PolicyNo like @P_PolicyNo+'%')
		and (@P_CertificateNo='' or C.CertificateNo like @P_CertificateNo+'%')
		and (@P_Branch='' or A.Branch=@P_Branch)
		and (@P_ID_NO='' or (P_Ext.ID_NO like @P_ID_NO+'%'))
		and (@P_Email='' or ((@P_EMail<>'' and P.Email=@P_EMail) or (@P_EMail<>'' and P.Email_2=@P_EMail)))
		and (@P_Branch='' or A.Branch=@P_Branch)
		Group by A.Source, A.ASource
	) C2 on (1=1)
	Where C.CNO Between C2.MinCNO and C2.MaxCNO and A.ASource=C2.ASource
	and (C.CStatus='A' or C.PCStatus='A')
	and A.Source=C2.Source

	Union All

	Select TOP 100
	C.CNO, 
	C.ANO,
	C.OCNO,
	C.CLaimantInfo, 
	C.ClaimNo, 
	Case When C1.OpenFlag=1 and A.CertificateNo<>'' then A.PolicyNo+'-'+A.CertificateNo else A.PolicyNo end as A_PolicyNo,
	A.PolicyNo,
	A.CERTIFICATENO,
	A.RefNo as A_RefNo,
	C.RefNo as C_RefNo,
	C.LossDate, 
	C.LossPlace, 
	C.Description, 
	C.Remarks, 
	C.CType, 
	Case When C.CStatus='R' Then 'REQUEST' When C.CStatus='A'or C.PCStatus='A' Then 'APPROVED' When C.CStatus in ('P','T') Then 'IN-PROCESS' Else 'DECLINED' end as CStatus,
	A.AID as AID,
	C1.MO,
	A.Branch,
	A.Source,
	TOC.TOC as RefTOC,
	TOC.Description as RefTOCDesc,
	TOPRO.Description as RefTOPRODESC,
	C.COL as RefCOL,
	COL.Description as RefCOLDesc,
	C.PUserDate as Last_Update,
	C.PUserTime as Last_Time,
	P.Email,
	P.Email_2,
	P_Ext.ID_No
	from Claim C 
	Inner Join Acceptance A on (A.ANO=C.ANO)
	Inner Join Cover C1 on (C1.CNO=A.CNO)
	Inner Join TOC on (TOC.TOC=A.TOC)
	Inner Join COLTAB COL on (COL.COL=C.COL)
	Left Join Profile P on (P.ID=A.AID) 
	Left Join Profile_Ext P_Ext on (P_Ext.ID=P.ID)
	Left Join TOPRO on (TOPRO.TOPRO=A.TOPRO) 
	Inner Join (
		Select A.Source, A.ASource, min(Case When C.CNO>=@P_LastCNO+1 Then @P_LastCNO+1 else C.CNO end) as MinCNO, max(C.CNO) as MaxCNO
		from Claim C
		Inner Join Acceptance A on (A.ANO=C.ANO)
		Inner Join Cover C1 on (C1.CNO=A.CNO)
		Left Join Profile P on (P.ID=A.AID) 
		Left Join Profile_Ext P_Ext on (P_Ext.ID=P.ID)
		Where (A.Source=@P_ID)
		and (@P_ASource='<All>' or A.ASource=@P_ASource)
		and (C.CStatus in ('P','T'))
		and (C.CNO>@P_LastCNO or ((C.PUserDate>@P_StartDate) or (C.PUserDate=@P_StartDate and C.PUserTime>@P_StartTime)))
		and (@P_ClaimNo='' or C.ClaimNo Like @P_ClaimNo+'%')
		and (@P_RefNo='' or A.RefNo like @P_RefNo+'%')
		and (@P_ClaimRefNo='' or C.RefNo Like @P_ClaimRefNo+'%')
		and (@P_PolicyNo='' or C.PolicyNo like @P_PolicyNo+'%')
		and (@P_CertificateNo='' or C.CertificateNo like @P_CertificateNo+'%')
		and (@P_Branch='' or A.Branch=@P_Branch)
		and (@P_ID_NO='' or (P_Ext.ID_NO like @P_ID_NO+'%'))
		and (@P_Email='' or ((@P_EMail<>'' and P.Email=@P_EMail) or (@P_EMail<>'' and P.Email_2=@P_EMail)))
		and (@P_Branch='' or A.Branch=@P_Branch)
		Group by A.Source, A.ASource
	) C2 on (1=1)
	Where C.CNO Between C2.MinCNO and C2.MaxCNO and A.ASource=C2.ASource
	and (C.CStatus in ('P','T'))
	and A.Source=C2.Source

	Union All

	Select TOP 100
	C.CNO, 
	C.ANO,
	C.OCNO,
	C.CLaimantInfo, 
	C.ClaimNo, 
	Case When C1.OpenFlag=1 and A.CertificateNo<>'' then A.PolicyNo+'-'+A.CertificateNo else A.PolicyNo end as A_PolicyNo,
	A.PolicyNo,
	A.CERTIFICATENO,
	A.RefNo as A_RefNo,
	C.RefNo as C_RefNo,
	C.LossDate, 
	C.LossPlace, 
	C.Description, 
	C.Remarks, 
	C.CType, 
	Case When C.CStatus='R' Then 'REQUEST' When C.CStatus='A'or C.PCStatus='A' Then 'APPROVED' When C.CStatus in ('P','T') Then 'IN-PROCESS' Else 'DECLINED' end as CStatus,
	A.AID as AID,
	C1.MO,
	A.Branch,
	A.Source,
	TOC.TOC as RefTOC,
	TOC.Description as RefTOCDesc,
	TOPRO.Description as RefTOPRODESC,
	C.COL as RefCOL,
	COL.Description as RefCOLDesc,
	C.CloseDate as Last_Update,
	C.CloseTime as Last_Time,
	P.Email,
	P.Email_2,
	P_Ext.ID_No
	from Claim C 
	Inner Join Acceptance A on (A.ANO=C.ANO)
	Inner Join Cover C1 on (C1.CNO=A.CNO)
	Inner Join TOC on (TOC.TOC=A.TOC)
	Inner Join COLTAB COL on (COL.COL=C.COL)
	Left Join Profile P on (P.ID=A.AID) 
	Left Join Profile_Ext P_Ext on (P_Ext.ID=P.ID)
	Left Join TOPRO on (TOPRO.TOPRO=A.TOPRO) 
	Inner Join (
		Select A.Source, A.ASource, min(Case When C.CNO>=@P_LastCNO+1 Then @P_LastCNO+1 else C.CNO end) as MinCNO, max(C.CNO) as MaxCNO
		from Claim C
		Inner Join Acceptance A on (A.ANO=C.ANO)
		Inner Join Cover C1 on (C1.CNO=A.CNO)
		Left Join Profile P on (P.ID=A.AID) 
		Left Join Profile_Ext P_Ext on (P_Ext.ID=P.ID)
		Where (A.Source=@P_ID)
		and (@P_ASource='<All>' or A.ASource=@P_ASource)
		and (C.CStatus='C' and C.PCSTATUS='P')
		and (C.CNO>@P_LastCNO or ((C.CloseDate>@P_StartDate) or (C.CloseDate=@P_StartDate and C.CloseTime>@P_StartTime)))
		and (@P_ClaimNo='' or C.ClaimNo Like @P_ClaimNo+'%')
		and (@P_RefNo='' or A.RefNo like @P_RefNo+'%')
		and (@P_ClaimRefNo='' or C.RefNo Like @P_ClaimRefNo+'%')
		and (@P_PolicyNo='' or C.PolicyNo like @P_PolicyNo+'%')
		and (@P_CertificateNo='' or C.CertificateNo like @P_CertificateNo+'%')
		and (@P_Branch='' or A.Branch=@P_Branch)
		and (@P_ID_NO='' or (P_Ext.ID_NO like @P_ID_NO+'%'))
		and (@P_Email='' or ((@P_EMail<>'' and P.Email=@P_EMail) or (@P_EMail<>'' and P.Email_2=@P_EMail)))
		and (@P_Branch='' or A.Branch=@P_Branch)
		Group By A.Source, A.ASource
	) C2 on (1=1)
	Where C.CNO Between C2.MinCNO and C2.MaxCNO and A.ASource=C2.ASource
	and (C.CStatus='C' and C.PCSTATUS='P')
	and A.Source=C2.Source
	Order by C.CNO
else if @P_Role='USER'
	Select TOP 100
	C.CNO, 
	C.ANO,
	C.OCNO,
	C.CLaimantInfo, 
	C.ClaimNo, 
	Case When C1.OpenFlag=1 and A.CertificateNo<>'' then A.PolicyNo+'-'+A.CertificateNo else A.PolicyNo end as A_PolicyNo,
	A.PolicyNo,
	A.CERTIFICATENO,
	A.RefNo as A_RefNo,
	C.RefNo as C_RefNo,
	C.LossDate, 
	C.LossPlace, 
	C.Description, 
	C.Remarks, 
	C.CType, 
	Case When C.CStatus='R' Then 'REQUEST' When C.CStatus='A'or C.PCStatus='A' Then 'APPROVED' When C.CStatus in ('P','T') Then 'IN-PROCESS' Else 'DECLINED' end as CStatus,
	A.AID as AID,
	C1.MO,
	A.Branch,
	A.Source,
	TOC.TOC as RefTOC,
	TOC.Description as RefTOCDesc,
	TOPRO.Description as RefTOPRODESC,
	C.COL as RefCOL,
	COL.Description as RefCOLDesc,
	C.AUserDate as Last_Update,
	C.AUserTime as Last_Time,
	P.Email,
	P.Email_2,
	P_Ext.ID_No
	from Claim C 
	Inner Join Acceptance A on (A.ANO=C.ANO)
	Inner Join Cover C1 on (C1.CNO=A.CNO)
	Inner Join TOC on (TOC.TOC=A.TOC)
	Inner Join COLTAB COL on (COL.COL=C.COL)
	Left Join Profile P on (P.ID=A.AID) 
	Left Join Profile_Ext P_Ext on (P_Ext.ID=P.ID)
	Left Join TOPRO on (TOPRO.TOPRO=A.TOPRO) 
	Where (@P_ASource='<All>' or A.ASource=@P_ASource)
	and (C.CStatus='R')
	--and (C.CNO>@P_LastCNO or (((C.AUserDate>@P_StartDate) or (C.AUserDate=@P_StartDate and C.AUserTime>@P_StartTime)) and ((C.AUserDate<@P_LastDate) or (C.AUserDate=@P_LastDate and C.AUserTime<=@P_LastTime))))
	--and (C.CNO>@P_LastCNO)
	and (@P_ClaimNo='' or C.ClaimNo Like @P_ClaimNo+'%')
	and (@P_RefNo='' or A.RefNo like @P_RefNo+'%')
	and (@P_ClaimRefNo='' or C.RefNo Like @P_ClaimRefNo+'%')
	and (@P_PolicyNo='' or C.PolicyNo like @P_PolicyNo+'%')
	and (@P_CertificateNo='' or C.CertificateNo like @P_CertificateNo+'%')
	and (@P_ID_NO='' or (P_Ext.ID_NO like @P_ID_NO+'%'))
	and (@P_Email='' or ((@P_EMail<>'' and P.Email=@P_EMail) or (@P_EMail<>'' and P.Email_2=@P_EMail)))
	and (@P_Branch='' or A.Branch=@P_Branch)

	Union All

	Select TOP 100
	C.CNO, 
	C.ANO,
	C.OCNO,
	C.CLaimantInfo, 
	C.ClaimNo, 
	Case When C1.OpenFlag=1 and A.CertificateNo<>'' then A.PolicyNo+'-'+A.CertificateNo else A.PolicyNo end as A_PolicyNo,
	A.PolicyNo,
	A.CERTIFICATENO,
	A.RefNo as A_RefNo,
	C.RefNo as C_RefNo,
	C.LossDate, 
	C.LossPlace, 
	C.Description, 
	C.Remarks, 
	C.CType, 
	Case When C.CStatus='R' Then 'REQUEST' When C.CStatus='A'or C.PCStatus='A' Then 'APPROVED' When C.CStatus in ('P','T') Then 'IN-PROCESS' Else 'DECLINED' end as CStatus,
	A.AID,
	C1.MO,
	A.Branch,
	A.Source,
	TOC.TOC as RefTOC,
	TOC.Description as RefTOCDesc,
	TOPRO.Description as RefTOPRODESC,
	C.COL as RefCOL,
	COL.Description as RefCOLDesc,
	C.AUserDate as Last_Update,
	C.AUserTime as Last_Time,
	P.Email,
	P.Email_2,
	P_Ext.ID_No
	from Claim C 
	Inner Join Acceptance A on (A.ANO=C.ANO)
	Inner Join Cover C1 on (C1.CNO=A.CNO)
	Inner Join TOC on (TOC.TOC=A.TOC)
	Inner Join COLTAB COL on (COL.COL=C.COL)
	Left Join Profile P on (P.ID=A.AID) 
	Left Join Profile_Ext P_Ext on (P_Ext.ID=P.ID)
	Left Join TOPRO on (TOPRO.TOPRO=A.TOPRO) 
	Where (@P_ASource='<All>' or A.ASource=@P_ASource)
	and (C.CStatus='A' or C.PCStatus='A')
	--and (C.CNO>@P_LastCNO or (((C.AUserDate>@P_StartDate) or (C.AUserDate=@P_StartDate and C.AUserTime>@P_StartTime)) and ((C.AUserDate<@P_LastDate) or (C.AUserDate=@P_LastDate and C.AUserTime<=@P_LastTime))))
	--and (C.CNO>@P_LastCNO)
	and (@P_ClaimNo='' or C.ClaimNo Like @P_ClaimNo+'%')
	and (@P_RefNo='' or A.RefNo like @P_RefNo+'%')
	and (@P_ClaimRefNo='' or C.RefNo Like @P_ClaimRefNo+'%')
	and (@P_PolicyNo='' or C.PolicyNo like @P_PolicyNo+'%')
	and (@P_CertificateNo='' or C.CertificateNo like @P_CertificateNo+'%')
	and (@P_ID_NO='' or (P_Ext.ID_NO like @P_ID_NO+'%'))
	and (@P_Email='' or ((@P_EMail<>'' and P.Email=@P_EMail) or (@P_EMail<>'' and P.Email_2=@P_EMail)))
	and (@P_Branch='' or A.Branch=@P_Branch)

	Union All

	Select TOP 100
	C.CNO, 
	C.ANO,
	C.OCNO,
	C.CLaimantInfo, 
	C.ClaimNo, 
	Case When C1.OpenFlag=1 and A.CertificateNo<>'' then A.PolicyNo+'-'+A.CertificateNo else A.PolicyNo end as A_PolicyNo,
	A.PolicyNo,
	A.CERTIFICATENO,
	A.RefNo as A_RefNo,
	C.RefNo as C_RefNo,
	C.LossDate, 
	C.LossPlace, 
	C.Description, 
	C.Remarks, 
	C.CType, 
	Case When C.CStatus='R' Then 'REQUEST' When C.CStatus='A'or C.PCStatus='A' Then 'APPROVED' When C.CStatus in ('P','T') Then 'IN-PROCESS' Else 'DECLINED' end as CStatus,
	A.AID,
	C1.MO,
	A.Branch,
	A.Source,
	TOC.TOC as RefTOC,
	TOC.Description as RefTOCDesc,
	TOPRO.Description as RefTOPRODESC,
	C.COL as RefCOL,
	COL.Description as RefCOLDesc,
	C.PUserDate as Last_Update,
	C.PUserTime as Last_Time,
	P.Email,
	P.Email_2,
	P_Ext.ID_No
	from Claim C 
	Inner Join Acceptance A on (A.ANO=C.ANO)
	Inner Join Cover C1 on (C1.CNO=A.CNO)
	Inner Join TOC on (TOC.TOC=A.TOC)
	Inner Join COLTAB COL on (COL.COL=C.COL)
	Left Join Profile P on (P.ID=A.AID) 
	Left Join Profile_Ext P_Ext on (P_Ext.ID=P.ID)
	Left Join TOPRO on (TOPRO.TOPRO=A.TOPRO) 
	Where (@P_ASource='<All>' or A.ASource=@P_ASource)
	and (C.CStatus in ('P','T'))
	--and (C.CNO>@P_LastCNO or (((C.PUserDate>@P_StartDate) or (C.PUserDate=@P_StartDate and C.PUserTime>@P_StartTime)) and ((C.PUserDate<@P_LastDate) or (C.PUserDate=@P_LastDate and C.PUserTime<=@P_LastTime))))
	--and (C.CNO>@P_LastCNO)
	and (@P_ClaimNo='' or C.ClaimNo Like @P_ClaimNo+'%')
	and (@P_RefNo='' or A.RefNo like @P_RefNo+'%')
	and (@P_ClaimRefNo='' or C.RefNo Like @P_ClaimRefNo+'%')
	and (@P_PolicyNo='' or C.PolicyNo like @P_PolicyNo+'%')
	and (@P_CertificateNo='' or C.CertificateNo like @P_CertificateNo+'%')
	and (@P_ID_NO='' or (P_Ext.ID_NO like @P_ID_NO+'%'))
	and (@P_Email='' or ((@P_EMail<>'' and P.Email=@P_EMail) or (@P_EMail<>'' and P.Email_2=@P_EMail)))
	and (@P_Branch='' or A.Branch=@P_Branch)

	Union All

	Select TOP 100
	C.CNO, 
	C.ANO,
	C.OCNO,
	C.CLaimantInfo, 
	C.ClaimNo, 
	Case When C1.OpenFlag=1 and A.CertificateNo<>'' then A.PolicyNo+'-'+A.CertificateNo else A.PolicyNo end as A_PolicyNo,
	A.PolicyNo,
	A.CERTIFICATENO,
	A.RefNo as A_RefNo,
	C.RefNo as C_RefNo,
	C.LossDate, 
	C.LossPlace, 
	C.Description, 
	C.Remarks, 
	C.CType, 
	Case When C.CStatus='R' Then 'REQUEST' When C.CStatus='A'or C.PCStatus='A' Then 'APPROVED' When C.CStatus in ('P','T') Then 'IN-PROCESS' Else 'DECLINED' end as CStatus,
	A.AID,
	C1.MO,
	A.Branch,
	A.Source,
	TOC.TOC as RefTOC,
	TOC.Description as RefTOCDesc,
	TOPRO.Description as RefTOPRODESC,
	C.COL as RefCOL,
	COL.Description as RefCOLDesc,
	C.CloseDate as Last_Update,
	C.CloseTime as Last_Time,
	P.Email,
	P.Email_2,
	P_Ext.ID_No
	from Claim C 
	Inner Join Acceptance A on (A.ANO=C.ANO)
	Inner Join Cover C1 on (C1.CNO=A.CNO)
	Inner Join TOC on (TOC.TOC=A.TOC)
	Inner Join COLTAB COL on (COL.COL=C.COL)
	Left Join Profile P on (P.ID=A.AID) 
	Left Join Profile_Ext P_Ext on (P_Ext.ID=P.ID)
	Left Join TOPRO on (TOPRO.TOPRO=A.TOPRO) 
	Where (@P_ASource='<All>' or A.ASource=@P_ASource)
	and (C.CStatus='C' and C.PCSTATUS='P')
	--and (C.CNO>@P_LastCNO or (((C.CloseDate>@P_StartDate) or (C.CloseDate=@P_StartDate and C.CloseTime>@P_StartTime)) and ((C.CloseDate<@P_LastDate) or (C.CloseDate=@P_LastDate and C.CloseTime<=@P_LastTime))))
	--and (C.CNO>@P_LastCNO)
	and (@P_ClaimNo='' or C.ClaimNo Like @P_ClaimNo+'%')
	and (@P_RefNo='' or A.RefNo like @P_RefNo+'%')
	and (@P_ClaimRefNo='' or C.RefNo Like @P_ClaimRefNo+'%')
	and (@P_PolicyNo='' or C.PolicyNo like @P_PolicyNo+'%')
	and (@P_CertificateNo='' or C.CertificateNo like @P_CertificateNo+'%')
	and (@P_ID_NO='' or (P_Ext.ID_NO like @P_ID_NO+'%'))
	and (@P_Email='' or ((@P_EMail<>'' and P.Email=@P_EMail) or (@P_EMail<>'' and P.Email_2=@P_EMail)))
	and (@P_Branch='' or A.Branch=@P_Branch)

	Order by C.CNO
else -- ROLE = 'MARKETING OFFICER'
	Select TOP 100
	C.CNO, 
	C.ANO,
	C.OCNO,
	C.CLaimantInfo, 
	C.ClaimNo, 
	Case When C1.OpenFlag=1 and A.CertificateNo<>'' then A.PolicyNo+'-'+A.CertificateNo else A.PolicyNo end as A_PolicyNo,
	A.PolicyNo,
	A.CERTIFICATENO,
	A.RefNo as A_RefNo,
	C.RefNo as C_RefNo,
	C.LossDate, 
	C.LossPlace, 
	C.Description, 
	C.Remarks, 
	C.CType, 
	Case When C.CStatus='R' Then 'REQUEST' When C.CStatus='A'or C.PCStatus='A' Then 'APPROVED' When C.CStatus in ('P','T') Then 'IN-PROCESS' Else 'DECLINED' end as CStatus,
	A.AID as AID,
	C1.MO,
	A.Branch,
	A.Source,
	TOC.TOC as RefTOC,
	TOC.Description as RefTOCDesc,
	TOPRO.Description as RefTOPRODESC,
	C.COL as RefCOL,
	COL.Description as RefCOLDesc,
	C.AUserDate as Last_Update,
	C.AUserTime as Last_Time,
	P.Email,
	P.Email_2,
	P_Ext.ID_No
	from Claim C 
	Inner Join Acceptance A on (A.ANO=C.ANO)
	Inner Join Cover C1 on (C1.CNO=A.CNO)
	Inner Join TOC on (TOC.TOC=A.TOC)
	Inner Join COLTAB COL on (COL.COL=C.COL)
	Left Join Profile P on (P.ID=A.AID) 
	Left Join Profile_Ext P_Ext on (P_Ext.ID=P.ID)
	Left Join TOPRO on (TOPRO.TOPRO=A.TOPRO) 
	Inner Join (
		Select C1.MO, A.ASource, min(Case When C.CNO>=@P_LastCNO+1 Then @P_LastCNO+1 else C.CNO end) as MinCNO, max(C.CNO) as MaxCNO
		from Claim C
		Inner Join Acceptance A on (A.ANO=C.ANO)
		Inner Join Cover C1 on (C1.CNO=A.CNO)
		Left Join Profile P on (P.ID=A.AID) 
		Left Join Profile_Ext P_Ext on (P_Ext.ID=P.ID)
		Where (C1.MO=@P_ID)
		and (@P_ASource='<All>' or A.ASource=@P_ASource)
		and (C.CStatus='R') and (C.CNO>@P_LastCNO or ((C.LDate>@P_StartDate) or (C.LDate=@P_StartDate and C.LTime>@P_StartTime)))
		and (@P_ClaimNo='' or C.ClaimNo Like @P_ClaimNo+'%')
		and (@P_RefNo='' or A.RefNo like @P_RefNo+'%')
		and (@P_ClaimRefNo='' or C.RefNo Like @P_ClaimRefNo+'%')
		and (@P_PolicyNo='' or C.PolicyNo like @P_PolicyNo+'%')
		and (@P_CertificateNo='' or C.CertificateNo like @P_CertificateNo+'%')
		and (@P_Branch='' or A.Branch=@P_Branch)
		and (@P_ID_NO='' or (P_Ext.ID_NO like @P_ID_NO+'%'))
		and (@P_Email='' or ((@P_EMail<>'' and P.Email=@P_EMail) or (@P_EMail<>'' and P.Email_2=@P_EMail)))
		and (@P_Branch='' or A.Branch=@P_Branch)
		Group by C1.MO, A.ASource
	) C2 on (1=1)
	Where C.CNO Between C2.MinCNO and C2.MaxCNO and A.ASource=C2.ASource
	and (C.CStatus='R')
	and C1.MO=C2.MO

	Union All

	Select TOP 100
	C.CNO, 
	C.ANO,
	C.OCNO,
	C.CLaimantInfo, 
	C.ClaimNo, 
	Case When C1.OpenFlag=1 and A.CertificateNo<>'' then A.PolicyNo+'-'+A.CertificateNo else A.PolicyNo end as A_PolicyNo,
	A.PolicyNo,
	A.CERTIFICATENO,
	A.RefNo as A_RefNo,
	C.RefNo as C_RefNo,
	C.LossDate, 
	C.LossPlace, 
	C.Description, 
	C.Remarks, 
	C.CType, 
	Case When C.CStatus='R' Then 'REQUEST' When C.CStatus='A'or C.PCStatus='A' Then 'APPROVED' When C.CStatus in ('P','T') Then 'IN-PROCESS' Else 'DECLINED' end as CStatus,
	A.AID as AID,
	C1.MO,
	A.Branch,
	A.Source,
	TOC.TOC as RefTOC,
	TOC.Description as RefTOCDesc,
	TOPRO.Description as RefTOPRODESC,
	C.COL as RefCOL,
	COL.Description as RefCOLDesc,
	C.AUserDate as Last_Update,
	C.AUserTime as Last_Time,
	P.Email,
	P.Email_2,
	P_Ext.ID_No
	from Claim C 
	Inner Join Acceptance A on (A.ANO=C.ANO)
	Inner Join Cover C1 on (C1.CNO=A.CNO)
	Inner Join TOC on (TOC.TOC=A.TOC)
	Inner Join COLTAB COL on (COL.COL=C.COL)
	Left Join Profile P on (P.ID=A.AID) 
	Left Join Profile_Ext P_Ext on (P_Ext.ID=P.ID)
	Left Join TOPRO on (TOPRO.TOPRO=A.TOPRO) 
	Inner Join (
		Select C1.MO, A.ASource, min(Case When C.CNO>=@P_LastCNO+1 Then @P_LastCNO+1 else C.CNO end) as MinCNO, max(C.CNO) as MaxCNO
		from Claim C
		Inner Join Acceptance A on (A.ANO=C.ANO)
		Inner Join Cover C1 on (C1.CNO=A.CNO)
		Left Join Profile P on (P.ID=A.AID) 
		Left Join Profile_Ext P_Ext on (P_Ext.ID=P.ID)
		Where (C1.MO=@P_ID)
		and (@P_ASource='<All>' or A.ASource=@P_ASource)
		and (C.CStatus='A' or C.PCStatus='A')
		and (C.CNO>@P_LastCNO or ((C.AUserDate>@P_StartDate) or (C.AUserDate=@P_StartDate and C.AUserTime>@P_StartTime)))
		and (@P_ClaimNo='' or C.ClaimNo Like @P_ClaimNo+'%')
		and (@P_RefNo='' or A.RefNo like @P_RefNo+'%')
		and (@P_ClaimRefNo='' or C.RefNo Like @P_ClaimRefNo+'%')
		and (@P_PolicyNo='' or C.PolicyNo like @P_PolicyNo+'%')
		and (@P_CertificateNo='' or C.CertificateNo like @P_CertificateNo+'%')
		and (@P_Branch='' or A.Branch=@P_Branch)
		and (@P_ID_NO='' or (P_Ext.ID_NO like @P_ID_NO+'%'))
		and (@P_Email='' or ((@P_EMail<>'' and P.Email=@P_EMail) or (@P_EMail<>'' and P.Email_2=@P_EMail)))
		and (@P_Branch='' or A.Branch=@P_Branch)
		Group By C1.MO, A.ASource
	) C2 on (1=1)
	Where C.CNO Between C2.MinCNO and C2.MaxCNO and A.ASource=C2.ASource
	and (C.CStatus='A' or C.PCStatus='A')
	and C1.MO=C2.MO

	Union All

	Select TOP 100
	C.CNO, 
	C.ANO,
	C.OCNO,
	C.CLaimantInfo, 
	C.ClaimNo, 
	Case When C1.OpenFlag=1 and A.CertificateNo<>'' then A.PolicyNo+'-'+A.CertificateNo else A.PolicyNo end as A_PolicyNo,
	A.PolicyNo,
	A.CERTIFICATENO,
	A.RefNo as A_RefNo,
	C.RefNo as C_RefNo,
	C.LossDate, 
	C.LossPlace, 
	C.Description, 
	C.Remarks, 
	C.CType, 
	Case When C.CStatus='R' Then 'REQUEST' When C.CStatus='A'or C.PCStatus='A' Then 'APPROVED' When C.CStatus in ('P','T') Then 'IN-PROCESS' Else 'DECLINED' end as CStatus,
	A.AID as AID,
	C1.MO,
	A.Branch,
	A.Source,
	TOC.TOC as RefTOC,
	TOC.Description as RefTOCDesc,
	TOPRO.Description as RefTOPRODESC,
	C.COL as RefCOL,
	COL.Description as RefCOLDesc,
	C.PUserDate as Last_Update,
	C.PUserTime as Last_Time,
	P.Email,
	P.Email_2,
	P_Ext.ID_No
	from Claim C 
	Inner Join Acceptance A on (A.ANO=C.ANO)
	Inner Join Cover C1 on (C1.CNO=A.CNO)
	Inner Join TOC on (TOC.TOC=A.TOC)
	Inner Join COLTAB COL on (COL.COL=C.COL)
	Left Join Profile P on (P.ID=A.AID) 
	Left Join Profile_Ext P_Ext on (P_Ext.ID=P.ID)
	Left Join TOPRO on (TOPRO.TOPRO=A.TOPRO) 
	Inner Join (
		Select C1.MO, A.ASource, min(Case When C.CNO>=@P_LastCNO+1 Then @P_LastCNO+1 else C.CNO end) as MinCNO, max(C.CNO) as MaxCNO
		from Claim C
		Inner Join Acceptance A on (A.ANO=C.ANO)
		Inner Join Cover C1 on (C1.CNO=A.CNO)
		Left Join Profile P on (P.ID=A.AID) 
		Left Join Profile_Ext P_Ext on (P_Ext.ID=P.ID)
		Where (C1.MO=@P_ID)
		and (@P_ASource='<All>' or A.ASource=@P_ASource)
		and (C.CStatus in ('P','T'))
		and (C.CNO>@P_LastCNO or ((C.PUserDate>@P_StartDate) or (C.PUserDate=@P_StartDate and C.PUserTime>@P_StartTime)))
		and (@P_ClaimNo='' or C.ClaimNo Like @P_ClaimNo+'%')
		and (@P_RefNo='' or A.RefNo like @P_RefNo+'%')
		and (@P_ClaimRefNo='' or C.RefNo Like @P_ClaimRefNo+'%')
		and (@P_PolicyNo='' or C.PolicyNo like @P_PolicyNo+'%')
		and (@P_CertificateNo='' or C.CertificateNo like @P_CertificateNo+'%')
		and (@P_Branch='' or A.Branch=@P_Branch)
		and (@P_ID_NO='' or (P_Ext.ID_NO like @P_ID_NO+'%'))
		and (@P_Email='' or ((@P_EMail<>'' and P.Email=@P_EMail) or (@P_EMail<>'' and P.Email_2=@P_EMail)))
		and (@P_Branch='' or A.Branch=@P_Branch)
		Group By C1.MO, A.ASource
	) C2 on (1=1)
	Where C.CNO Between C2.MinCNO and C2.MaxCNO and A.ASource=C2.ASource
	and (C.CStatus in ('P','T'))
	and C1.MO=C2.MO

	Union All

	Select TOP 100
	C.CNO, 
	C.ANO,
	C.OCNO,
	C.CLaimantInfo, 
	C.ClaimNo, 
	Case When C1.OpenFlag=1 and A.CertificateNo<>'' then A.PolicyNo+'-'+A.CertificateNo else A.PolicyNo end as A_PolicyNo,
	A.PolicyNo,
	A.CERTIFICATENO,
	A.RefNo as A_RefNo,
	C.RefNo as C_RefNo,
	C.LossDate, 
	C.LossPlace, 
	C.Description, 
	C.Remarks, 
	C.CType, 
	Case When C.CStatus='R' Then 'REQUEST' When C.CStatus='A'or C.PCStatus='A' Then 'APPROVED' When C.CStatus in ('P','T') Then 'IN-PROCESS' Else 'DECLINED' end as CStatus,
	A.AID as AID,
	C1.MO,
	A.Branch,
	A.Source,
	TOC.TOC as RefTOC,
	TOC.Description as RefTOCDesc,
	TOPRO.Description as RefTOPRODESC,
	C.COL as RefCOL,
	COL.Description as RefCOLDesc,
	C.CloseDate as Last_Update,
	C.CloseTime as Last_Time,
	P.Email,
	P.Email_2,
	P_Ext.ID_No
	from Claim C 
	Inner Join Acceptance A on (A.ANO=C.ANO)
	Inner Join Cover C1 on (C1.CNO=A.CNO)
	Inner Join TOC on (TOC.TOC=A.TOC)
	Inner Join COLTAB COL on (COL.COL=C.COL)
	Left Join Profile P on (P.ID=A.AID) 
	Left Join Profile_Ext P_Ext on (P_Ext.ID=P.ID)
	Left Join TOPRO on (TOPRO.TOPRO=A.TOPRO) 
	Inner Join (
		Select C1.MO, A.ASource, min(Case When C.CNO>=@P_LastCNO+1 Then @P_LastCNO+1 else C.CNO end) as MinCNO, max(C.CNO) as MaxCNO
		from Claim C
		Inner Join Acceptance A on (A.ANO=C.ANO)
		Inner Join Cover C1 on (C1.CNO=A.CNO)
		Left Join Profile P on (P.ID=A.AID) 
		Left Join Profile_Ext P_Ext on (P_Ext.ID=P.ID)
		Where (C1.MO=@P_ID)
		and (@P_ASource='<All>' or A.ASource=@P_ASource)
		and (C.CStatus='C' and C.PCSTATUS='P')
		and (C.CNO>@P_LastCNO or ((C.CloseDate>@P_StartDate) or (C.CloseDate=@P_StartDate and C.CloseTime>@P_StartTime)))
		and (@P_ClaimNo='' or C.ClaimNo Like @P_ClaimNo+'%')
		and (@P_RefNo='' or A.RefNo like @P_RefNo+'%')
		and (@P_ClaimRefNo='' or C.RefNo Like @P_ClaimRefNo+'%')
		and (@P_PolicyNo='' or C.PolicyNo like @P_PolicyNo+'%')
		and (@P_CertificateNo='' or C.CertificateNo like @P_CertificateNo+'%')
		and (@P_Branch='' or A.Branch=@P_Branch)
		and (@P_ID_NO='' or (P_Ext.ID_NO like @P_ID_NO+'%'))
		and (@P_Email='' or ((@P_EMail<>'' and P.Email=@P_EMail) or (@P_EMail<>'' and P.Email_2=@P_EMail)))
		and (@P_Branch='' or A.Branch=@P_Branch)
		Group By C1.MO, A.ASource
	) C2 on (1=1)
	Where C.CNO Between C2.MinCNO and C2.MaxCNO and A.ASource=C2.ASource
	and (C.CStatus='C' and C.PCSTATUS='P')
	and C1.MO=C2.MO
	Order by C.CNO
GO

DROP PROCEDURE GetStoredClaim_Loss
GO
CREATE PROCEDURE GetStoredClaim_Loss(@P_CNO as int)  
as   
Select C1.CNO, C1.INO, C1.Remark as Remarks, C1.Currency, C1.Estimate, C1.Amount, C1.CTLF, 
Case When TOI.FLDID1<>'' Then TOI.FLDTAG1+' : '+cast(C2.VALUEDESC1 as varchar(100))+char(13)+char(10) else '' end
+Case When TOI.FLDID2<>'' Then TOI.FLDTAG2+' : '+cast(C2.VALUEDESC2 as varchar(100))+char(13)+char(10) else '' end
+Case When TOI.FLDID3<>'' Then TOI.FLDTAG3+' : '+cast(C2.VALUEDESC3 as varchar(100))+char(13)+char(10) else '' end
+Case When TOI.FLDID4<>'' Then TOI.FLDTAG4+' : '+cast(C2.VALUEDESC4 as varchar(100))+char(13)+char(10) else '' end
+Case When TOI.FLDID5<>'' Then TOI.FLDTAG5+' : '+cast(C2.VALUEDESC5 as varchar(100))+char(13)+char(10) else '' end
+Case When TOI.FLDID6<>'' Then TOI.FLDTAG6+' : '+cast(C2.VALUEDESC6 as varchar(100))+char(13)+char(10) else '' end
+Case When TOI.FLDID7<>'' Then TOI.FLDTAG7+' : '+cast(C2.VALUEDESC7 as varchar(100))+char(13)+char(10) else '' end
+Case When TOI.FLDID8<>'' Then TOI.FLDTAG8+' : '+cast(C2.VALUEDESC8 as varchar(100))+char(13)+char(10) else '' end
+Case When TOI.FLDID9<>'' Then TOI.FLDTAG9+' : '+cast(C2.VALUEDESC9 as varchar(100))+char(13)+char(10) else '' end
+Case When TOI.FLDID10<>'' Then TOI.FLDTAG10+' : '+cast(C2.VALUEDESC10 as varchar(100))+char(13)+char(10) else '' end
+Case When TOI.FLDID11<>'' Then TOI.FLDTAG11+' : '+cast(C2.VALUEDESC11 as varchar(100))+char(13)+char(10) else '' end
+Case When TOI.FLDID12<>'' Then TOI.FLDTAG12+' : '+cast(C2.VALUEDESC12 as varchar(100))+char(13)+char(10) else '' end
+Case When TOI.FLDID13<>'' Then TOI.FLDTAG13+' : '+cast(C2.VALUEDESC13 as varchar(100))+char(13)+char(10) else '' end
+Case When TOI.FLDID14<>'' Then TOI.FLDTAG14+' : '+cast(C2.VALUEDESC14 as varchar(100))+char(13)+char(10) else '' end
+Case When TOI.FLDID15<>'' Then TOI.FLDTAG15+' : '+cast(C2.VALUEDESC15 as varchar(100))+char(13)+char(10) else '' end
as INFO
from CLLOSS C1 
Left Join CLINFO C2 on (C2.CNO=C1.CNO and C2.INO=C1.INO and C2.NOC=C1.NOC) 
INNER JOIN TOI ON (TOI.TOI=C1.TOI)
Where C1.CNO=@P_CNO

GO

DROP PROCEDURE GetStoredClaim_Deductible
GO
CREATE PROCEDURE GetStoredClaim_Deductible(@P_CNO as int)  
as   
Select C1.CNO, C1.Remark as Remarks, C1.Currency, C1.ESTAMOUNT as Estimate, C1.Amount
from CLDED C1 
Where C1.CNO=@P_CNO

GO

DROP PROCEDURE  GetStoredPolicy_Interest
GO
CREATE PROCEDURE  GetStoredPolicy_Interest(@P_ANO as int)  
as   
Select I1.ANO, I1.INO, I1.TOI as RefTOI, I1.Remark as Remarks, I1.Currency, I1.Amount, I1.RefNo, I1.RefDate, I1.DocNo, I1.DocDate, I1.RefDueDate,
Case When TOI.FLDID1<>'' Then TOI.FLDTAG1+' : '+cast(I2.VALUEDESC1 as varchar(100))+char(13)+char(10) else '' end
+Case When TOI.FLDID2<>'' Then TOI.FLDTAG2+' : '+cast(I2.VALUEDESC2 as varchar(100))+char(13)+char(10) else '' end
+Case When TOI.FLDID3<>'' Then TOI.FLDTAG3+' : '+cast(I2.VALUEDESC3 as varchar(100))+char(13)+char(10) else '' end
+Case When TOI.FLDID4<>'' Then TOI.FLDTAG4+' : '+cast(I2.VALUEDESC4 as varchar(100))+char(13)+char(10) else '' end
+Case When TOI.FLDID5<>'' Then TOI.FLDTAG5+' : '+cast(I2.VALUEDESC5 as varchar(100))+char(13)+char(10) else '' end
+Case When TOI.FLDID6<>'' Then TOI.FLDTAG6+' : '+cast(I2.VALUEDESC6 as varchar(100))+char(13)+char(10) else '' end
+Case When TOI.FLDID7<>'' Then TOI.FLDTAG7+' : '+cast(I2.VALUEDESC7 as varchar(100))+char(13)+char(10) else '' end
+Case When TOI.FLDID8<>'' Then TOI.FLDTAG8+' : '+cast(I2.VALUEDESC8 as varchar(100))+char(13)+char(10) else '' end
+Case When TOI.FLDID9<>'' Then TOI.FLDTAG9+' : '+cast(I2.VALUEDESC9 as varchar(100))+char(13)+char(10) else '' end
+Case When TOI.FLDID10<>'' Then TOI.FLDTAG10+' : '+cast(I2.VALUEDESC10 as varchar(100))+char(13)+char(10) else '' end
+Case When TOI.FLDID11<>'' Then TOI.FLDTAG11+' : '+cast(I2.VALUEDESC11 as varchar(100))+char(13)+char(10) else '' end
+Case When TOI.FLDID12<>'' Then TOI.FLDTAG12+' : '+cast(I2.VALUEDESC12 as varchar(100))+char(13)+char(10) else '' end
+Case When TOI.FLDID13<>'' Then TOI.FLDTAG13+' : '+cast(I2.VALUEDESC13 as varchar(100))+char(13)+char(10) else '' end
+Case When TOI.FLDID14<>'' Then TOI.FLDTAG14+' : '+cast(I2.VALUEDESC14 as varchar(100))+char(13)+char(10) else '' end
+Case When TOI.FLDID15<>'' Then TOI.FLDTAG15+' : '+cast(I2.VALUEDESC15 as varchar(100))+char(13)+char(10) else '' end
as INFO
from ICover I1 Left Join IINFO I2 on (I2.INO=I1.INO) INNER JOIN TOI ON (TOI.TOI=I1.TOI)
Where I1.ANO=@P_ANO

GO

DROP PROCEDURE  GetStoredPolicy_Risk
GO
CREATE PROCEDURE  GetStoredPolicy_Risk(@P_ANO as int)  
as   
Select R1.ANO, R1.Code, R1.Remark as Remarks, R1.SDate, R1.EDate, R1.CONSIGNEE, R1.CAddress, R1.DepartDate, R1.ArrivalDate, R1.VoyageFrom, R1.PortFrom, R1.VoyageTo, R1.PortTo, R1.TranshipMent, coalesce(R2.Vessel, R1.Vessel) as Vessel, coalesce(R2.AtAndFrom, R1.AtAndFrom) as AtAndFrom, coalesce(R2.TransTo, R1.TransTo) as TransTo, coalesce(R2.TransDate, R1.TransDate) as TransDate, coalesce(R2.CONVEYANCE, R1.CONVEYANCE) as CONVEYANCE
from RCover R1
Left Join RCoverDet R2 on (R2.ANO=R1.ANO and R2.Code=R1.Code and R2.SDate=R1.Sdate)
Where R1.ANO=@P_ANO

GO

DROP PROCEDURE  GetPolicyLapseNotification
GO
CREATE PROCEDURE  GetPolicyLapseNotification(@P_ID as varchar(10), @P_Role as varchar(10),@P_StartDate as smalldatetime, @P_StartTime as varchar(5),@P_LastDate as smalldatetime, @P_LastTime as varchar(5))  
as   

if @P_Role='CLIENT'
Select 
'POLICY' as AppType, 
Acceptance.ANO as APPID,
Case When Cover.OpenFlag=1 and Acceptance.CertificateNo<>'' then Acceptance.PolicyNo+'-'+Acceptance.CertificateNo else Acceptance.PolicyNo end as DocNo,
Acceptance.AName as Name,
TOC.Description,
Acceptance.AID, 
Acceptance.SOURCE,
'Policy Lapse On ' + convert(varchar(10),Acceptance.EDate,6) as Message
from Acceptance Inner Join Renewal on (Renewal.ANO=Acceptance.ANO), Cover, TOC 
Where TOC.RNDays<>0 and TOC.TOC=Acceptance.TOC and ((Cover.OpenFlag=0 and Acceptance.ANO=Acceptance.LANO) or (Acceptance.LANO=-1) or (Cover.OpenFlag=1 and Acceptance.ANO<>Acceptance.LANO))
and Cover.ISType in ('I') and Cover.CNO=Acceptance.CNO and Acceptance.RenewableF=1 
and Acceptance.AStatus in ('I') and Acceptance.AType not in ('C','A')             
and Acceptance.EDate Between @P_LastDate and dateadd(day,TOC.RNDays,@P_LastDate)           
and Acceptance.AID=@P_ID
and coalesce(Renewal.LossRatio,0)<=20
else if @P_Role='AGENT'
Select 
'POLICY' as AppType, 
Acceptance.ANO as APPID,
Case When Cover.OpenFlag=1 and Acceptance.CertificateNo<>'' then Acceptance.PolicyNo+'-'+Acceptance.CertificateNo else Acceptance.PolicyNo end as DocNo,
Acceptance.AName as Name,
TOC.Description,
Acceptance.AID, 
Acceptance.SOURCE,
'Policy Lapse On ' + convert(varchar(10),Acceptance.EDate,6) as Message
from Acceptance Inner Join Renewal on (Renewal.ANO=Acceptance.ANO), Cover, TOC 
Where TOC.RNDays<>0 and TOC.TOC=Acceptance.TOC and ((Cover.OpenFlag=0 and Acceptance.ANO=Acceptance.LANO) or (Acceptance.LANO=-1) or (Cover.OpenFlag=1 and Acceptance.ANO<>Acceptance.LANO))
and Cover.ISType in ('I') and Cover.CNO=Acceptance.CNO and Acceptance.RenewableF=1 
and Acceptance.AStatus in ('I') and Acceptance.AType not in ('C','A')             
and Acceptance.EDate Between @P_LastDate and dateadd(day,TOC.RNDays,@P_LastDate)           
and Acceptance.Source=@P_ID
and coalesce(Renewal.LossRatio,0)<=20
else
Select 
'POLICY' as AppType, 
Acceptance.ANO as APPID,
Case When Cover.OpenFlag=1 and Acceptance.CertificateNo<>'' then Acceptance.PolicyNo+'-'+Acceptance.CertificateNo else Acceptance.PolicyNo end as DocNo,
Acceptance.AName as Name,
TOC.Description,
Acceptance.AID, 
Acceptance.SOURCE,
'Policy Lapse On ' + convert(varchar(10),Acceptance.EDate,6) as Message
from Acceptance Inner Join Renewal on (Renewal.ANO=Acceptance.ANO), Cover, TOC 
Where TOC.RNDays<>0 and TOC.TOC=Acceptance.TOC and ((Cover.OpenFlag=0 and Acceptance.ANO=Acceptance.LANO) or (Acceptance.LANO=-1) or (Cover.OpenFlag=1 and Acceptance.ANO<>Acceptance.LANO))
and Cover.ISType in ('I') and Cover.CNO=Acceptance.CNO and Acceptance.RenewableF=1 
and Acceptance.AStatus in ('I') and Acceptance.AType not in ('C','A')             
and Acceptance.EDate Between @P_LastDate and dateadd(day,TOC.RNDays,@P_LastDate)           
and Acceptance.UserID=@P_ID
and coalesce(Renewal.LossRatio,0)<=20

GO


DROP PROCEDURE  GetValuationByObjectInfo
GO
CREATE PROCEDURE  GetValuationByObjectInfo(  
@P_TOI as varchar(10),  
@P_CCY as varchar(10),
@P_VDate as smalldatetime,   
@P_VALUEID1 as varchar(15),  
@P_VALUEID2 as varchar(15),  
@P_VALUEID3 as varchar(15),  
@P_VALUEID4 as varchar(15),  
@P_VALUEID5 as varchar(15),  
@P_VALUEID6 as varchar(15),  
@P_VALUEID7 as varchar(15),  
@P_VALUEID8 as varchar(15),  
@P_VALUEID9 as varchar(15),  
@P_VALUEID10 as varchar(15),  
@P_VALUEID11 as varchar(15),  
@P_VALUEID12 as varchar(15),  
@P_VALUEID13 as varchar(15),  
@P_VALUEID14 as varchar(15),  
@P_VALUEID15 as varchar(15)  
)       
as   
Select TOP 1 TOIVALUE.VALUE/Currency.Rate as Value, TOIVALUE.VALUEPCT
from TOIValue, fn_Exchange(@P_VDate) as Currency   
WHERE Currency.Currency=@P_CCY
AND TOIValue.TOI=@P_TOI AND TOIVALUE.Status='A' and TOIVALUE.YEAR=YEAR(@P_VDATE) AND TOIVALUE.MONTH=MONTH(@P_VDATE)         
And (coalesce(TOIVALUE.ValueID1,'')='' or @P_VALUEID1 =TOIVALUE.ValueID1)       
And (coalesce(TOIVALUE.ValueID2,'')='' or @P_VALUEID2 =TOIVALUE.ValueID2)       
And (coalesce(TOIVALUE.ValueID3,'')='' or @P_VALUEID3 =TOIVALUE.ValueID3)       
And (coalesce(TOIVALUE.ValueID4,'')='' or @P_VALUEID4 =TOIVALUE.ValueID4)       
And (coalesce(TOIVALUE.ValueID5,'')='' or @P_VALUEID5 =TOIVALUE.ValueID5)       
And (coalesce(TOIVALUE.ValueID6,'')='' or @P_VALUEID6 =TOIVALUE.ValueID6)       
And (coalesce(TOIVALUE.ValueID7,'')='' or @P_VALUEID7 =TOIVALUE.ValueID7)       
And (coalesce(TOIVALUE.ValueID8,'')='' or @P_VALUEID8 =TOIVALUE.ValueID8)       
And (coalesce(TOIVALUE.ValueID9,'')='' or @P_VALUEID9 =TOIVALUE.ValueID9)       
And (coalesce(TOIVALUE.ValueID10,'')='' or @P_VALUEID10 =TOIVALUE.ValueID10)       
And (coalesce(TOIVALUE.ValueID11,'')='' or @P_VALUEID11 =TOIVALUE.ValueID11)       
And (coalesce(TOIVALUE.ValueID12,'')='' or @P_VALUEID12 =TOIVALUE.ValueID12)       
And (coalesce(TOIVALUE.ValueID13,'')='' or @P_VALUEID13 =TOIVALUE.ValueID13)       
And (coalesce(TOIVALUE.ValueID14,'')='' or @P_VALUEID14 =TOIVALUE.ValueID14)       
And (coalesce(TOIVALUE.ValueID15,'')='' or @P_VALUEID15 =TOIVALUE.ValueID15)       
Order by          
len(coalesce(TOIVALUE.ValueID1,'')) Desc,       
len(coalesce(TOIVALUE.ValueID2,'')) Desc,       
len(coalesce(TOIVALUE.ValueID3,'')) Desc,       
len(coalesce(TOIVALUE.ValueID4,'')) Desc,       
len(coalesce(TOIVALUE.ValueID5,'')) Desc,       
len(coalesce(TOIVALUE.ValueID6,'')) Desc,       
len(coalesce(TOIVALUE.ValueID7,'')) Desc,       
len(coalesce(TOIVALUE.ValueID8,'')) Desc,       
len(coalesce(TOIVALUE.ValueID9,'')) Desc,       
len(coalesce(TOIVALUE.ValueID10,'')) Desc,       
len(coalesce(TOIVALUE.ValueID11,'')) Desc,       
len(coalesce(TOIVALUE.ValueID12,'')) Desc,       
len(coalesce(TOIVALUE.ValueID13,'')) Desc,       
len(coalesce(TOIVALUE.ValueID14,'')) Desc,       
len(coalesce(TOIVALUE.ValueID15,'')) Desc,
TOIVALUE.TOIVALUEID Desc



GO

DROP PROCEDURE  GetStoredPolicy_Payment
GO
CREATE PROCEDURE  GetStoredPolicy_Payment(@P_ANO as int)  
as   

SELECT ACCEPTANCE.ANO, ADMLINK.VOUCHER, ADMLINK.CURRENCY, ADMLINK.DATE,
Max(Admlink.AccountNo) as AccountNo, 
Max(Admlink.BankName) as BankName, 
Max(Admlink.BankAccount) as BankAccount,
MAX(ADMLINK.WPC) as WPC,
SUM(CASE WHEN ACCASS.CODE IN ('P','U') THEN ACCASS.AMOUNT ELSE 0 END) AS PREMIUM,
SUM(CASE WHEN ACCASS.CODE IN ('F') THEN ACCASS.AMOUNT ELSE 0 END) AS POLICYFEE,
SUM(CASE WHEN ACCASS.CODE IN ('D') THEN ACCASS.AMOUNT ELSE 0 END) AS STAMPDUTY,
SUM(CASE WHEN ACCASS.CODE IN ('O') THEN ACCASS.AMOUNT ELSE 0 END) AS DISCOUNT,
MAX(COALESCE(CASE WHEN NVOUCHER.DEBTORF=1 THEN NVOUCHER.NOMINAL_CC-NVOUCHER.DIFF_CC ELSE -(NVOUCHER.NOMINAL_CC-NVOUCHER.DIFF_CC) END,0)) AS AMOUNT_TOTAL,
MAX(COALESCE(VOUCHER.DUEDATE,ADMLINK.DATE)) AS DATE_DUE,
MAX(COALESCE(CASE WHEN NVOUCHER.DEBTORF=1 THEN VOUCHER.AMOUNTDUE ELSE -(VOUCHER.AMOUNTDUE) END,0)) AS AMOUNT_DUE,
MAX(COALESCE(CASE WHEN NVOUCHER.DEBTORF=1 THEN NVOUCHER.PAYMENT_CC ELSE -NVOUCHER.PAYMENT_CC END,0)) AS TOTAL_PAID,
MAX(COALESCE(CASE WHEN NVOUCHER.PAYMENT_CC<>0 THEN NVOUCHER.PDATE ELSE NULL END,NULL)) AS LAST_PAID, 
MAX(NVOUCHER.RATE) as RATE
FROM ACCEPTANCE
INNER JOIN ACCEPTANCE dA on (dA.RegNo=Acceptance.RegNo)
INNER JOIN ACCASS ON (ACCASS.ANO=dA.ANO)
INNER JOIN ADMLINK ON (ADMLINK.ADMNO=ACCASS.ADMNO)
LEFT JOIN NVOUCHER ON (NVOUCHER.VOUCHER=ADMLINK.VOUCHER)
LEFT JOIN Voucher_AmountWPCDUE(cast(convert(varchar(10), getdate(),1) as smalldatetime)) VOUCHER ON (VOUCHER.VOUCHER=ADMLINK.VOUCHER)
WHERE ACCEPTANCE.ANO=ACCEPTANCE.LANO AND ACCEPTANCE.ANO=@P_ANO AND ACCASS.TYPE in ('DI','IC','IR') 
GROUP BY ACCEPTANCE.ANO, ADMLINK.VOUCHER, ADMLINK.CURRENCY, ADMLINK.DATE

UNION ALL 

SELECT ACCEPTANCE.ANO, ADMLINK.VOUCHER, ADMLINK.CURRENCY, ADMLINK.DATE,
Max(Admlink.AccountNo) as AccountNo, 
Max(Admlink.BankName) as BankName, 
Max(Admlink.BankAccount) as BankAccount,
MAX(ADMLINK.WPC) as WPC,
SUM(CASE WHEN ACCASS.CODE IN ('P','U') THEN ACCASS.AMOUNT ELSE 0 END) AS PREMIUM,
SUM(CASE WHEN ACCASS.CODE IN ('F') THEN ACCASS.AMOUNT ELSE 0 END) AS POLICYFEE,
SUM(CASE WHEN ACCASS.CODE IN ('D') THEN ACCASS.AMOUNT ELSE 0 END) AS STAMPDUTY,
SUM(CASE WHEN ACCASS.CODE IN ('O') THEN ACCASS.AMOUNT ELSE 0 END) AS DISCOUNT,
MAX(COALESCE(CASE WHEN NVOUCHER.DEBTORF=1 THEN NVOUCHER.NOMINAL_CC-NVOUCHER.DIFF_CC ELSE -(NVOUCHER.NOMINAL_CC-NVOUCHER.DIFF_CC) END,0)) AS AMOUNT_TOTAL,
MAX(COALESCE(VOUCHER.DUEDATE,ADMLINK.DATE)) AS DATE_DUE,
MAX(COALESCE(CASE WHEN NVOUCHER.DEBTORF=1 THEN VOUCHER.AMOUNTDUE ELSE -(VOUCHER.AMOUNTDUE) END,0)) AS AMOUNT_DUE,
MAX(COALESCE(CASE WHEN NVOUCHER.DEBTORF=1 THEN NVOUCHER.PAYMENT_CC ELSE -NVOUCHER.PAYMENT_CC END,0)) AS TOTAL_PAID,
MAX(COALESCE(CASE WHEN NVOUCHER.PAYMENT_CC<>0 THEN NVOUCHER.PDATE ELSE NULL END,NULL)) AS LAST_PAID, 
MAX(NVOUCHER.RATE) as RATE
FROM ACCEPTANCE
INNER JOIN ACCASS ON (ACCASS.ANO=ACCEPTANCE.ANO)
INNER JOIN ADMLINK ON (ADMLINK.ADMNO=ACCASS.ADMNO)
LEFT JOIN NVOUCHER ON (NVOUCHER.VOUCHER=ADMLINK.VOUCHER)
LEFT JOIN Voucher_AmountWPCDUE(cast(convert(varchar(10), getdate(),1) as smalldatetime)) VOUCHER ON (VOUCHER.VOUCHER=ADMLINK.VOUCHER)
WHERE ACCEPTANCE.ANO<>ACCEPTANCE.LANO AND ACCEPTANCE.ANO=@P_ANO AND ACCASS.TYPE in ('DI','IC','IR') 
GROUP BY ACCEPTANCE.ANO, ADMLINK.VOUCHER, ADMLINK.CURRENCY, ADMLINK.DATE

GO

DROP PROCEDURE  GetStoredClaim_Payment
GO
CREATE PROCEDURE  GetStoredClaim_Payment(@P_CNO as int)  
as   

SELECT CLAIM.CNO, ADMLINK.VOUCHER, ADMLINK.CURRENCY, ADMLINK.DATE,
Sum(Case When Claass.Code in ('A') Then ClaAss.Amount else 0 end) as Claim,
Sum(Case When Claass.Code in ('E') Then ClaAss.Amount else 0 end) as Deductible,
MAX(COALESCE(CASE WHEN NVOUCHER.CREDITORF=1 THEN NVOUCHER.NOMINAL_CC-NVOUCHER.DIFF_CC ELSE -(NVOUCHER.NOMINAL_CC-NVOUCHER.DIFF_CC) END,0)) AS AMOUNT_TOTAL,
MAX(COALESCE(VOUCHER.DUEDATE,ADMLINK.DATE)) AS DATE_DUE,
MAX(COALESCE(CASE WHEN NVOUCHER.CREDITORF=1 THEN VOUCHER.AMOUNTDUE ELSE -(VOUCHER.AMOUNTDUE) END,0)) AS AMOUNT_DUE,
MAX(COALESCE(CASE WHEN NVOUCHER.CREDITORF=1 THEN NVOUCHER.PAYMENT_CC ELSE -NVOUCHER.PAYMENT_CC END,0)) AS TOTAL_PAID,
MAX(COALESCE(CASE WHEN NVOUCHER.PAYMENT_CC<>0 THEN NVOUCHER.PDATE ELSE NULL END,NULL)) AS LAST_PAID,
MAX(NVOUCHER.RATE) as RATE
FROM CLAIM
INNER JOIN CLAASS ON (CLAASS.CNO=CLAIM.CNO)
INNER JOIN ADMLINK ON (ADMLINK.ADMNO=CLAASS.ADMNO)
LEFT JOIN NVOUCHER ON (NVOUCHER.VOUCHER=ADMLINK.VOUCHER)
LEFT JOIN Voucher_AmountWPCDUE(cast(convert(varchar(10), getdate(),1) as smalldatetime)) VOUCHER ON (VOUCHER.VOUCHER=ADMLINK.VOUCHER)
WHERE CLAIM.CNO=@P_CNO AND CLAASS.TYPE in ('DI','IC','IR') 
GROUP BY CLAIM.CNO, ADMLINK.VOUCHER, ADMLINK.CURRENCY, ADMLINK.DATE



GO

DROP PROCEDURE  GetStoredPolicy_Commission
GO
CREATE PROCEDURE  GetStoredPolicy_Commission(@P_ANO as int)  
as   

SELECT ACCEPTANCE.ANO, ADMLINK.VOUCHER, ADMLINK.CURRENCY,
SUM(CASE WHEN ACCASS.CODE in ('C','O') THEN ACCASS.AMOUNT ELSE 0 END) AS COMMISSION,
SUM(ACCASS.AMOUNT*ADMLINK.AMOUNT_13/(ADMLINK.AMOUNT-ADMLINK.AMOUNT_11-ADMLINK.AMOUNT_12-ADMLINK.AMOUNT_13-ADMLINK.AMOUNT_14)) AS VAT,
SUM(ACCASS.AMOUNT*ADMLINK.AMOUNT_14/(ADMLINK.AMOUNT-ADMLINK.AMOUNT_11-ADMLINK.AMOUNT_12-ADMLINK.AMOUNT_13-ADMLINK.AMOUNT_14)) AS TAX,
MAX(COALESCE(CASE WHEN NVOUCHER.DEBTORF=1 THEN NVOUCHER.NOMINAL_CC-NVOUCHER.DIFF_CC ELSE -(NVOUCHER.NOMINAL_CC-NVOUCHER.DIFF_CC) END,0)) AS AMOUNT_TOTAL,
MAX(COALESCE(VOUCHER.DUEDATE,ADMLINK.DATE)) AS DATE_DUE,
MAX(COALESCE(CASE WHEN NVOUCHER.DEBTORF=1 THEN VOUCHER.AMOUNTDUE ELSE -(VOUCHER.AMOUNTDUE) END,0)) AS AMOUNT_DUE,
MAX(COALESCE(CASE WHEN NVOUCHER.DEBTORF=1 THEN NVOUCHER.PAYMENT_CC ELSE -NVOUCHER.PAYMENT_CC END,0)) AS TOTAL_PAID,
MAX(COALESCE(CASE WHEN NVOUCHER.PAYMENT_CC<>0 THEN NVOUCHER.PDATE ELSE NULL END,NULL)) AS LAST_PAID,
MAX(NVOUCHER.RATE) AS RATE
FROM ACCEPTANCE
INNER JOIN ACCASS ON (ACCASS.ANO=ACCEPTANCE.ANO)
INNER JOIN ADMLINK ON (ADMLINK.ADMNO=ACCASS.ADMNO)
LEFT JOIN NVOUCHER ON (NVOUCHER.VOUCHER=ADMLINK.VOUCHER)
LEFT JOIN Voucher_AmountWPCDUE(cast(convert(varchar(10), getdate(),1) as smalldatetime)) VOUCHER ON (VOUCHER.VOUCHER=ADMLINK.VOUCHER)
WHERE ACCEPTANCE.ANO=@P_ANO AND ACCASS.TYPE in ('BB','BA','BC','BO') 
AND (ADMLINK.AMOUNT-ADMLINK.AMOUNT_11-ADMLINK.AMOUNT_12-ADMLINK.AMOUNT_13-ADMLINK.AMOUNT_14)<>0
GROUP BY ACCEPTANCE.ANO, ADMLINK.VOUCHER, ADMLINK.CURRENCY

GO

DROP PROCEDURE GetStoredPolicy_Deductible
GO
CREATE PROCEDURE GetStoredPolicy_Deductible(@P_ANO as int)  
as   
Select A1.ANO, A1.REMARKS 
from ACCDED A1 
Where A1.ANO=@P_ANO
GO

DROP PROCEDURE GetStoredPolicy_Clauses
GO
CREATE PROCEDURE GetStoredPolicy_Clauses(@P_ANO as int)  
as   
Select A1.ANO, 'CLA' as Type, A1.ORDERNO, A1.SHORTDESC
from ACCCLA A1 
Where A1.ANO=@P_ANO

Union All

Select A1.ANO, 'CON' as Type, A1.ORDERNO, A1.SHORTDESC
from ACCCON A1 
Where A1.ANO=@P_ANO

Union All

Select A1.ANO, 'EX' as Type, A1.ORDERNO, A1.SHORTDESC
from ACCEX A1 
Where A1.ANO=@P_ANO



GO

DROP PROCEDURE GetStoredPolicy_InParty
GO
CREATE PROCEDURE GetStoredPolicy_InParty(@P_ANO as int)  
as   
Select A.ANO, I.*
from ACCEPTANCE A, COVER C, INPARTY I
Where I.CNO=C.CNO and C.CNO=A.CNO and A.ANO=@P_ANO

GO

DROP PROCEDURE  GetPolicyPaidProduction
GO
CREATE PROCEDURE  GetPolicyPaidProduction(@P_ID as varchar(10), @P_Role as varchar(10),@P_StartDate as smalldatetime, @P_LastDate as smalldatetime, @P_ASource as varchar(10)='')  
as   

if @P_Role='CLIENT'
Select Distinct A1.ANO, A3.Currency, COB.DESCRIPTION, Voucher.Voucher as nVoucher, pSL.Voucher as pVoucher, dbo.fn_SL_Payment_Nominal(pSL.Nominal_OC, pVoucher.SL_Cat, pVoucher.DebtorF, Voucher.DebtorF) *(A3.Amount_1+A3.Amount_5+A3.Amount_11+A3.Amount_20)/A3.Amount as PaidPremium
from Cover C, Acceptance A1, AccAss A2, Admlink A3, nVoucher Voucher, pSL, pVoucher, TOC, COB
Where C.CNO=A1.CNO and A1.ANO=A2.ANO and A3.AdmNO=A2.AdmNo and Voucher.Voucher=A3.Voucher and pSL.Doc_No=Voucher.Voucher and pSL.PaymentF=1 and pVoucher.Voucher=pSL.VOucher
and C.ISType in ('I') and A2.Code in ('P')
and A1.AID=@P_ID and (@P_ASource='' or A1.ASource=@P_ASource)
and TOC.TOC=A1.TOC and COB.COB=TOC.COB
and pVoucher.Date Between @P_StartDate and @P_LastDate
else if @P_Role='AGENT'
Select Distinct A1.ANO, A3.Currency, COB.DESCRIPTION, Voucher.Voucher as nVoucher, pSL.Voucher as pVoucher, dbo.fn_SL_Payment_Nominal(pSL.Nominal_OC, pVoucher.SL_Cat, pVoucher.DebtorF, Voucher.DebtorF) *(A3.Amount_1+A3.Amount_5+A3.Amount_11+A3.Amount_20)/A3.Amount as PaidPremium
from Cover C, Acceptance A1, AccAss A2, Admlink A3, nVoucher Voucher, pSL, pVoucher, TOC, COB
Where C.CNO=A1.CNO and A1.ANO=A2.ANO and A3.AdmNO=A2.AdmNo and Voucher.Voucher=A3.Voucher and pSL.Doc_No=Voucher.Voucher and pSL.PaymentF=1 and pVoucher.Voucher=pSL.VOucher
and C.ISType in ('I') and A2.Code in ('P')
and A1.Source=@P_ID and (@P_ASource='' or A1.ASource=@P_ASource)
and TOC.TOC=A1.TOC and COB.COB=TOC.COB
and pVoucher.Date Between @P_StartDate and @P_LastDate
else
Select Distinct A1.ANO, A3.Currency, COB.DESCRIPTION, Voucher.Voucher as nVoucher, pSL.Voucher as pVoucher, dbo.fn_SL_Payment_Nominal(pSL.Nominal_OC, pVoucher.SL_Cat, pVoucher.DebtorF, Voucher.DebtorF) *(A3.Amount_1+A3.Amount_5+A3.Amount_11+A3.Amount_20)/A3.Amount as PaidPremium
from Cover C, Acceptance A1, AccAss A2, Admlink A3, nVoucher Voucher, pSL, pVoucher, TOC, COB
Where C.CNO=A1.CNO and A1.ANO=A2.ANO and A3.AdmNO=A2.AdmNo and Voucher.Voucher=A3.Voucher and pSL.Doc_No=Voucher.Voucher and pSL.PaymentF=1 and pVoucher.Voucher=pSL.VOucher
and C.ISType in ('I') and A2.Code in ('P')
and A1.UserID=@P_ID and (@P_ASource='' or A1.ASource=@P_ASource)
and TOC.TOC=A1.TOC and COB.COB=TOC.COB
and pVoucher.Date Between @P_StartDate and @P_LastDate

GO

DROP PROCEDURE GetStoredQuotation
GO
CREATE PROCEDURE GetStoredQuotation(@P_ID as varchar(10), @P_Role as varchar(10),@P_StartDate as smalldatetime, @P_StartTime as varchar(5),@P_LastDate as smalldatetime, @P_LastTime as varchar(5),@P_LastANO as int, @P_ASource as varchar(10)='', @P_RefNo as varchar(50)='', @P_EMail as varchar(100)='', @P_Info as varchar(100)='')  
as   

if @P_Role='CLIENT'
Select TOP 100
A.ANO, 
A.OANO,
A.AName,
C.CoverNo, 
A.RefNo,
COB.Description,
A.Remarks,
A.SDate, A.EDate, A.PDate, A.AType, A.ASource,
Case When C.CStatus in ('C') Then 'DECLINED' When C.CStatus in ('A') Then 'CONFIRMED' else '' end AStatus,
A.AID as AID,
A.Source,
TOC.TOC as RefTOC,
TOC.Description as RefTOCDesc,
C.PUserDate as Last_Update,
C.PUserTime as Last_Time,
A.ExclusiveF,
PolicyType.SType,
C.ISType,
Case When TOC.FLDID1<>'' Then TOC.FLDID1+' : '+cast(A1.VALUEDESC1 as varchar(100))+char(13)+char(10) else '' end
+Case When TOC.FLDID2<>'' Then TOC.FLDID2+' : '+cast(A1.VALUEDESC2 as varchar(100))+char(13)+char(10) else '' end
+Case When TOC.FLDID3<>'' Then TOC.FLDID3+' : '+cast(A1.VALUEDESC3 as varchar(100))+char(13)+char(10) else '' end
+Case When TOC.FLDID4<>'' Then TOC.FLDID4+' : '+cast(A1.VALUEDESC4 as varchar(100))+char(13)+char(10) else '' end
+Case When TOC.FLDID5<>'' Then TOC.FLDID5+' : '+cast(A1.VALUEDESC5 as varchar(100))+char(13)+char(10) else '' end
+Case When TOC.FLDID6<>'' Then TOC.FLDID6+' : '+cast(A1.VALUEDESC6 as varchar(100))+char(13)+char(10) else '' end
+Case When TOC.FLDID7<>'' Then TOC.FLDID7+' : '+cast(A1.VALUEDESC7 as varchar(100))+char(13)+char(10) else '' end
+Case When TOC.FLDID8<>'' Then TOC.FLDID8+' : '+cast(A1.VALUEDESC8 as varchar(100))+char(13)+char(10) else '' end
+Case When TOC.FLDID9<>'' Then TOC.FLDID9+' : '+cast(A1.VALUEDESC9 as varchar(100))+char(13)+char(10) else '' end
+Case When TOC.FLDID10<>'' Then TOC.FLDID10+' : '+cast(A1.VALUEDESC10 as varchar(100))+char(13)+char(10) else '' end
+Case When TOC.FLDID11<>'' Then TOC.FLDID11+' : '+cast(A1.VALUEDESC11 as varchar(100))+char(13)+char(10) else '' end
+Case When TOC.FLDID12<>'' Then TOC.FLDID12+' : '+cast(A1.VALUEDESC12 as varchar(100))+char(13)+char(10) else '' end
+Case When TOC.FLDID13<>'' Then TOC.FLDID13+' : '+cast(A1.VALUEDESC13 as varchar(100))+char(13)+char(10) else '' end
+Case When TOC.FLDID14<>'' Then TOC.FLDID14+' : '+cast(A1.VALUEDESC14 as varchar(100))+char(13)+char(10) else '' end
+Case When TOC.FLDID15<>'' Then TOC.FLDID15+' : '+cast(A1.VALUEDESC15 as varchar(100))+char(13)+char(10) else '' end
as INFO,
A.CANO,
A.LANO,
TOPRO.TOPRO as RefTOPRO,
TOPRO.DESCRIPTION as RefTOPRODESC,
TOC.FLDID1, 
TOC.FLDID2, 
TOC.FLDID3, 
TOC.FLDID4, 
TOC.FLDID5, 
TOC.FLDID6, 
TOC.FLDID7, 
TOC.FLDID8, 
TOC.FLDID9, 
TOC.FLDID10, 
TOC.FLDID11, 
TOC.FLDID12, 
TOC.FLDID13, 
TOC.FLDID14, 
TOC.FLDID15, 
TOC.FLDID1, 
TOC.FLDID2, 
TOC.FLDID3, 
TOC.FLDID4, 
TOC.FLDID5, 
TOC.FLDID6, 
TOC.FLDID7, 
TOC.FLDID8, 
TOC.FLDID9, 
TOC.FLDID10, 
TOC.FLDID11, 
TOC.FLDID12, 
TOC.FLDID13, 
TOC.FLDID14, 
TOC.FLDID15,
A1.VALUEDESC1, 
A1.VALUEDESC2, 
A1.VALUEDESC3, 
A1.VALUEDESC4, 
A1.VALUEDESC5, 
A1.VALUEDESC6, 
A1.VALUEDESC7, 
A1.VALUEDESC8, 
A1.VALUEDESC9, 
A1.VALUEDESC10, 
A1.VALUEDESC11, 
A1.VALUEDESC12, 
A1.VALUEDESC13, 
A1.VALUEDESC14, 
A1.VALUEDESC15
from Acceptance A Left Join Profile P on (P.ID=A.AID) Left Join TOPRO on (TOPRO.TOPRO=A.TOPRO), AInfo A1, Cover C, TOC, COB, PolicyType
Where C.CNO=A.CNO and A.AType='N' and C.CStatus='P' and C.ASource='MKT' and A.Astatus='W'-- Quotation Released
and COB.COB=TOC.COB and TOC.TOC=A.TOC and A1.ANO=A.ANO
and (A.AID=@P_ID or (@P_EMail<>'' and P.Email=@P_EMail) or (@P_EMail<>'' and P.Email_2=@P_EMail))
and (@P_ASource='<All>' or A.ASource=@P_ASource)
--and (A.ANO>@P_LastANO or (((C.PUserDate>@P_StartDate) or (C.PUserDate=@P_StartDate and C.PUserTime>@P_StartTime)) and ((C.PUserDate<@P_LastDate) or (C.PUserDate=@P_LastDate and C.PUserTime<=@P_LastTime))))
and (A.ANO>@P_LastANO)
and (A.RefNo Like @P_RefNo+'%')
and PolicyType.PolicyType=C.PolicyType
and (A.LANO=-1 or A.ANO=A.LANO)
and
(
@P_Info='' or
replace(replace(
Case When TOC.FLDID1<>'' Then TOC.FLDID1+' : '+cast(A1.VALUEDESC1 as varchar(100))+char(13)+char(10) else '' end
+Case When TOC.FLDID2<>'' Then TOC.FLDID2+' : '+cast(A1.VALUEDESC2 as varchar(100))+char(13)+char(10) else '' end
+Case When TOC.FLDID3<>'' Then TOC.FLDID3+' : '+cast(A1.VALUEDESC3 as varchar(100))+char(13)+char(10) else '' end
+Case When TOC.FLDID4<>'' Then TOC.FLDID4+' : '+cast(A1.VALUEDESC4 as varchar(100))+char(13)+char(10) else '' end
+Case When TOC.FLDID5<>'' Then TOC.FLDID5+' : '+cast(A1.VALUEDESC5 as varchar(100))+char(13)+char(10) else '' end
+Case When TOC.FLDID6<>'' Then TOC.FLDID6+' : '+cast(A1.VALUEDESC6 as varchar(100))+char(13)+char(10) else '' end
+Case When TOC.FLDID7<>'' Then TOC.FLDID7+' : '+cast(A1.VALUEDESC7 as varchar(100))+char(13)+char(10) else '' end
+Case When TOC.FLDID8<>'' Then TOC.FLDID8+' : '+cast(A1.VALUEDESC8 as varchar(100))+char(13)+char(10) else '' end
+Case When TOC.FLDID9<>'' Then TOC.FLDID9+' : '+cast(A1.VALUEDESC9 as varchar(100))+char(13)+char(10) else '' end
+Case When TOC.FLDID10<>'' Then TOC.FLDID10+' : '+cast(A1.VALUEDESC10 as varchar(100))+char(13)+char(10) else '' end
+Case When TOC.FLDID11<>'' Then TOC.FLDID11+' : '+cast(A1.VALUEDESC11 as varchar(100))+char(13)+char(10) else '' end
+Case When TOC.FLDID12<>'' Then TOC.FLDID12+' : '+cast(A1.VALUEDESC12 as varchar(100))+char(13)+char(10) else '' end
+Case When TOC.FLDID13<>'' Then TOC.FLDID13+' : '+cast(A1.VALUEDESC13 as varchar(100))+char(13)+char(10) else '' end
+Case When TOC.FLDID14<>'' Then TOC.FLDID14+' : '+cast(A1.VALUEDESC14 as varchar(100))+char(13)+char(10) else '' end
+Case When TOC.FLDID15<>'' Then TOC.FLDID15+' : '+cast(A1.VALUEDESC15 as varchar(100))+char(13)+char(10) else '' end
,'-',''),' ','') Like '%'+Replace(Replace(@P_Info, '-', ''), ' ', '')+'%'
)
Order by A.ANO

else if @P_ROLE='AGENT'
Select TOP 100
A.ANO, 
A.OANO,
A.AName,
C.CoverNo, 
A.RefNo,
COB.Description,
A.Remarks,
A.SDate, A.EDate, A.PDate, A.AType, A.ASource,
Case When C.CStatus in ('C') Then 'DECLINED' When C.CStatus in ('A') Then 'CONFIRMED' else '' end AStatus,
A.AID,
A.Source as Source,
TOC.TOC as RefTOC,
TOC.Description as RefTOCDesc,
C.PUserDate as Last_Update,
C.PUserTime as Last_Time,
A.ExclusiveF,
PolicyType.SType,
C.ISType,
Case When TOC.FLDID1<>'' Then TOC.FLDID1+' : '+cast(A1.VALUEDESC1 as varchar(100))+char(13)+char(10) else '' end
+Case When TOC.FLDID2<>'' Then TOC.FLDID2+' : '+cast(A1.VALUEDESC2 as varchar(100))+char(13)+char(10) else '' end
+Case When TOC.FLDID3<>'' Then TOC.FLDID3+' : '+cast(A1.VALUEDESC3 as varchar(100))+char(13)+char(10) else '' end
+Case When TOC.FLDID4<>'' Then TOC.FLDID4+' : '+cast(A1.VALUEDESC4 as varchar(100))+char(13)+char(10) else '' end
+Case When TOC.FLDID5<>'' Then TOC.FLDID5+' : '+cast(A1.VALUEDESC5 as varchar(100))+char(13)+char(10) else '' end
+Case When TOC.FLDID6<>'' Then TOC.FLDID6+' : '+cast(A1.VALUEDESC6 as varchar(100))+char(13)+char(10) else '' end
+Case When TOC.FLDID7<>'' Then TOC.FLDID7+' : '+cast(A1.VALUEDESC7 as varchar(100))+char(13)+char(10) else '' end
+Case When TOC.FLDID8<>'' Then TOC.FLDID8+' : '+cast(A1.VALUEDESC8 as varchar(100))+char(13)+char(10) else '' end
+Case When TOC.FLDID9<>'' Then TOC.FLDID9+' : '+cast(A1.VALUEDESC9 as varchar(100))+char(13)+char(10) else '' end
+Case When TOC.FLDID10<>'' Then TOC.FLDID10+' : '+cast(A1.VALUEDESC10 as varchar(100))+char(13)+char(10) else '' end
+Case When TOC.FLDID11<>'' Then TOC.FLDID11+' : '+cast(A1.VALUEDESC11 as varchar(100))+char(13)+char(10) else '' end
+Case When TOC.FLDID12<>'' Then TOC.FLDID12+' : '+cast(A1.VALUEDESC12 as varchar(100))+char(13)+char(10) else '' end
+Case When TOC.FLDID13<>'' Then TOC.FLDID13+' : '+cast(A1.VALUEDESC13 as varchar(100))+char(13)+char(10) else '' end
+Case When TOC.FLDID14<>'' Then TOC.FLDID14+' : '+cast(A1.VALUEDESC14 as varchar(100))+char(13)+char(10) else '' end
+Case When TOC.FLDID15<>'' Then TOC.FLDID15+' : '+cast(A1.VALUEDESC15 as varchar(100))+char(13)+char(10) else '' end
as INFO,
A.CANO,
A.LANO,
TOPRO.TOPRO as RefTOPRO,
TOPRO.DESCRIPTION as RefTOPRODESC,
TOC.FLDID1, 
TOC.FLDID2, 
TOC.FLDID3, 
TOC.FLDID4, 
TOC.FLDID5, 
TOC.FLDID6, 
TOC.FLDID7, 
TOC.FLDID8, 
TOC.FLDID9, 
TOC.FLDID10, 
TOC.FLDID11, 
TOC.FLDID12, 
TOC.FLDID13, 
TOC.FLDID14, 
TOC.FLDID15, 
TOC.FLDID1, 
TOC.FLDID2, 
TOC.FLDID3, 
TOC.FLDID4, 
TOC.FLDID5, 
TOC.FLDID6, 
TOC.FLDID7, 
TOC.FLDID8, 
TOC.FLDID9, 
TOC.FLDID10, 
TOC.FLDID11, 
TOC.FLDID12, 
TOC.FLDID13, 
TOC.FLDID14, 
TOC.FLDID15,
A1.VALUEDESC1, 
A1.VALUEDESC2, 
A1.VALUEDESC3, 
A1.VALUEDESC4, 
A1.VALUEDESC5, 
A1.VALUEDESC6, 
A1.VALUEDESC7, 
A1.VALUEDESC8, 
A1.VALUEDESC9, 
A1.VALUEDESC10, 
A1.VALUEDESC11, 
A1.VALUEDESC12, 
A1.VALUEDESC13, 
A1.VALUEDESC14, 
A1.VALUEDESC15
from Acceptance A Left Join Profile P on (P.ID=A.Source) Left Join TOPRO on (TOPRO.TOPRO=A.TOPRO), AInfo A1, Cover C, TOC, COB, PolicyType
Where C.CNO=A.CNO and A.AType='N' and C.CStatus='P' and C.ASource='MKT' and A.Astatus='W'-- Quotation Released
and COB.COB=TOC.COB and TOC.TOC=A.TOC and A1.ANO=A.ANO
and (A.Source=@P_ID or (@P_EMail<>'' and P.Email=@P_EMail) or (@P_EMail<>'' and P.Email_2=@P_EMail))
and (@P_ASource='<All>' or A.ASource=@P_ASource)
--and (A.ANO>@P_LastANO or (((C.PUserDate>@P_StartDate) or (C.PUserDate=@P_StartDate and C.PUserTime>@P_StartTime)) and ((C.PUserDate<@P_LastDate) or (C.PUserDate=@P_LastDate and C.PUserTime<=@P_LastTime))))
and (A.ANO>@P_LastANO)
and (A.RefNo Like @P_RefNo+'%')
and PolicyType.PolicyType=C.PolicyType
and (A.LANO=-1 or A.ANO=A.LANO)
and
(
@P_Info='' or
replace(replace(
Case When TOC.FLDID1<>'' Then TOC.FLDID1+' : '+cast(A1.VALUEDESC1 as varchar(100))+char(13)+char(10) else '' end
+Case When TOC.FLDID2<>'' Then TOC.FLDID2+' : '+cast(A1.VALUEDESC2 as varchar(100))+char(13)+char(10) else '' end
+Case When TOC.FLDID3<>'' Then TOC.FLDID3+' : '+cast(A1.VALUEDESC3 as varchar(100))+char(13)+char(10) else '' end
+Case When TOC.FLDID4<>'' Then TOC.FLDID4+' : '+cast(A1.VALUEDESC4 as varchar(100))+char(13)+char(10) else '' end
+Case When TOC.FLDID5<>'' Then TOC.FLDID5+' : '+cast(A1.VALUEDESC5 as varchar(100))+char(13)+char(10) else '' end
+Case When TOC.FLDID6<>'' Then TOC.FLDID6+' : '+cast(A1.VALUEDESC6 as varchar(100))+char(13)+char(10) else '' end
+Case When TOC.FLDID7<>'' Then TOC.FLDID7+' : '+cast(A1.VALUEDESC7 as varchar(100))+char(13)+char(10) else '' end
+Case When TOC.FLDID8<>'' Then TOC.FLDID8+' : '+cast(A1.VALUEDESC8 as varchar(100))+char(13)+char(10) else '' end
+Case When TOC.FLDID9<>'' Then TOC.FLDID9+' : '+cast(A1.VALUEDESC9 as varchar(100))+char(13)+char(10) else '' end
+Case When TOC.FLDID10<>'' Then TOC.FLDID10+' : '+cast(A1.VALUEDESC10 as varchar(100))+char(13)+char(10) else '' end
+Case When TOC.FLDID11<>'' Then TOC.FLDID11+' : '+cast(A1.VALUEDESC11 as varchar(100))+char(13)+char(10) else '' end
+Case When TOC.FLDID12<>'' Then TOC.FLDID12+' : '+cast(A1.VALUEDESC12 as varchar(100))+char(13)+char(10) else '' end
+Case When TOC.FLDID13<>'' Then TOC.FLDID13+' : '+cast(A1.VALUEDESC13 as varchar(100))+char(13)+char(10) else '' end
+Case When TOC.FLDID14<>'' Then TOC.FLDID14+' : '+cast(A1.VALUEDESC14 as varchar(100))+char(13)+char(10) else '' end
+Case When TOC.FLDID15<>'' Then TOC.FLDID15+' : '+cast(A1.VALUEDESC15 as varchar(100))+char(13)+char(10) else '' end
,'-',''),' ','') Like '%'+Replace(Replace(@P_Info, '-', ''), ' ', '')+'%'
)
Order by A.ANO
else-- ROLE = 'USER'
Select TOP 100
A.ANO, 
A.OANO,
A.AName,
C.CoverNo, 
A.RefNo,
COB.Description,
A.Remarks,
A.SDate, A.EDate, A.PDate, A.AType, A.ASource,
Case When C.CStatus in ('C') Then 'DECLINED' When C.CStatus in ('A') Then 'CONFIRMED' else '' end AStatus,
A.AID as AID,
A.Source,
TOC.TOC as RefTOC,
TOC.Description as RefTOCDesc,
C.PUserDate as Last_Update,
C.PUserTime as Last_Time,
A.ExclusiveF,
PolicyType.SType,
C.ISType,
Case When TOC.FLDID1<>'' Then TOC.FLDID1+' : '+cast(A1.VALUEDESC1 as varchar(100))+char(13)+char(10) else '' end
+Case When TOC.FLDID2<>'' Then TOC.FLDID2+' : '+cast(A1.VALUEDESC2 as varchar(100))+char(13)+char(10) else '' end
+Case When TOC.FLDID3<>'' Then TOC.FLDID3+' : '+cast(A1.VALUEDESC3 as varchar(100))+char(13)+char(10) else '' end
+Case When TOC.FLDID4<>'' Then TOC.FLDID4+' : '+cast(A1.VALUEDESC4 as varchar(100))+char(13)+char(10) else '' end
+Case When TOC.FLDID5<>'' Then TOC.FLDID5+' : '+cast(A1.VALUEDESC5 as varchar(100))+char(13)+char(10) else '' end
+Case When TOC.FLDID6<>'' Then TOC.FLDID6+' : '+cast(A1.VALUEDESC6 as varchar(100))+char(13)+char(10) else '' end
+Case When TOC.FLDID7<>'' Then TOC.FLDID7+' : '+cast(A1.VALUEDESC7 as varchar(100))+char(13)+char(10) else '' end
+Case When TOC.FLDID8<>'' Then TOC.FLDID8+' : '+cast(A1.VALUEDESC8 as varchar(100))+char(13)+char(10) else '' end
+Case When TOC.FLDID9<>'' Then TOC.FLDID9+' : '+cast(A1.VALUEDESC9 as varchar(100))+char(13)+char(10) else '' end
+Case When TOC.FLDID10<>'' Then TOC.FLDID10+' : '+cast(A1.VALUEDESC10 as varchar(100))+char(13)+char(10) else '' end
+Case When TOC.FLDID11<>'' Then TOC.FLDID11+' : '+cast(A1.VALUEDESC11 as varchar(100))+char(13)+char(10) else '' end
+Case When TOC.FLDID12<>'' Then TOC.FLDID12+' : '+cast(A1.VALUEDESC12 as varchar(100))+char(13)+char(10) else '' end
+Case When TOC.FLDID13<>'' Then TOC.FLDID13+' : '+cast(A1.VALUEDESC13 as varchar(100))+char(13)+char(10) else '' end
+Case When TOC.FLDID14<>'' Then TOC.FLDID14+' : '+cast(A1.VALUEDESC14 as varchar(100))+char(13)+char(10) else '' end
+Case When TOC.FLDID15<>'' Then TOC.FLDID15+' : '+cast(A1.VALUEDESC15 as varchar(100))+char(13)+char(10) else '' end
as INFO,
A.CANO,
A.LANO,
TOPRO.TOPRO as RefTOPRO,
TOPRO.DESCRIPTION as RefTOPRODESC,
TOC.FLDID1, 
TOC.FLDID2, 
TOC.FLDID3, 
TOC.FLDID4, 
TOC.FLDID5, 
TOC.FLDID6, 
TOC.FLDID7, 
TOC.FLDID8, 
TOC.FLDID9, 
TOC.FLDID10, 
TOC.FLDID11, 
TOC.FLDID12, 
TOC.FLDID13, 
TOC.FLDID14, 
TOC.FLDID15, 
TOC.FLDID1, 
TOC.FLDID2, 
TOC.FLDID3, 
TOC.FLDID4, 
TOC.FLDID5, 
TOC.FLDID6, 
TOC.FLDID7, 
TOC.FLDID8, 
TOC.FLDID9, 
TOC.FLDID10, 
TOC.FLDID11, 
TOC.FLDID12, 
TOC.FLDID13, 
TOC.FLDID14, 
TOC.FLDID15,
A1.VALUEDESC1, 
A1.VALUEDESC2, 
A1.VALUEDESC3, 
A1.VALUEDESC4, 
A1.VALUEDESC5, 
A1.VALUEDESC6, 
A1.VALUEDESC7, 
A1.VALUEDESC8, 
A1.VALUEDESC9, 
A1.VALUEDESC10, 
A1.VALUEDESC11, 
A1.VALUEDESC12, 
A1.VALUEDESC13, 
A1.VALUEDESC14, 
A1.VALUEDESC15
from Acceptance A Left Join Profile P on (P.ID=A.AID) Left Join TOPRO on (TOPRO.TOPRO=A.TOPRO), AInfo A1, Cover C, TOC, COB, PolicyType
Where C.CNO=A.CNO and A.AType='N' and C.CStatus='P' and C.ASource='MKT' and A.Astatus='W'-- Quotation Released
and COB.COB=TOC.COB and TOC.TOC=A.TOC and A1.ANO=A.ANO
--and (A.UserID=@P_ID or (@P_EMail<>'' and P.Email=@P_EMail) or (@P_EMail<>'' and P.Email_2=@P_EMail))
and (@P_ASource='<All>' or A.ASource=@P_ASource)
--and (A.ANO>@P_LastANO or (((C.PUserDate>@P_StartDate) or (C.PUserDate=@P_StartDate and C.PUserTime>@P_StartTime)) and ((C.PUserDate<@P_LastDate) or (C.PUserDate=@P_LastDate and C.PUserTime<=@P_LastTime))))
--and (A.ANO>@P_LastANO)
and (A.RefNo Like @P_RefNo+'%')
and PolicyType.PolicyType=C.PolicyType
and (A.LANO=-1 or A.ANO=A.LANO)
and
(
@P_Info='' or
replace(replace(
Case When TOC.FLDID1<>'' Then TOC.FLDID1+' : '+cast(A1.VALUEDESC1 as varchar(100))+char(13)+char(10) else '' end
+Case When TOC.FLDID2<>'' Then TOC.FLDID2+' : '+cast(A1.VALUEDESC2 as varchar(100))+char(13)+char(10) else '' end
+Case When TOC.FLDID3<>'' Then TOC.FLDID3+' : '+cast(A1.VALUEDESC3 as varchar(100))+char(13)+char(10) else '' end
+Case When TOC.FLDID4<>'' Then TOC.FLDID4+' : '+cast(A1.VALUEDESC4 as varchar(100))+char(13)+char(10) else '' end
+Case When TOC.FLDID5<>'' Then TOC.FLDID5+' : '+cast(A1.VALUEDESC5 as varchar(100))+char(13)+char(10) else '' end
+Case When TOC.FLDID6<>'' Then TOC.FLDID6+' : '+cast(A1.VALUEDESC6 as varchar(100))+char(13)+char(10) else '' end
+Case When TOC.FLDID7<>'' Then TOC.FLDID7+' : '+cast(A1.VALUEDESC7 as varchar(100))+char(13)+char(10) else '' end
+Case When TOC.FLDID8<>'' Then TOC.FLDID8+' : '+cast(A1.VALUEDESC8 as varchar(100))+char(13)+char(10) else '' end
+Case When TOC.FLDID9<>'' Then TOC.FLDID9+' : '+cast(A1.VALUEDESC9 as varchar(100))+char(13)+char(10) else '' end
+Case When TOC.FLDID10<>'' Then TOC.FLDID10+' : '+cast(A1.VALUEDESC10 as varchar(100))+char(13)+char(10) else '' end
+Case When TOC.FLDID11<>'' Then TOC.FLDID11+' : '+cast(A1.VALUEDESC11 as varchar(100))+char(13)+char(10) else '' end
+Case When TOC.FLDID12<>'' Then TOC.FLDID12+' : '+cast(A1.VALUEDESC12 as varchar(100))+char(13)+char(10) else '' end
+Case When TOC.FLDID13<>'' Then TOC.FLDID13+' : '+cast(A1.VALUEDESC13 as varchar(100))+char(13)+char(10) else '' end
+Case When TOC.FLDID14<>'' Then TOC.FLDID14+' : '+cast(A1.VALUEDESC14 as varchar(100))+char(13)+char(10) else '' end
+Case When TOC.FLDID15<>'' Then TOC.FLDID15+' : '+cast(A1.VALUEDESC15 as varchar(100))+char(13)+char(10) else '' end
,'-',''),' ','') Like '%'+Replace(Replace(@P_Info, '-', ''), ' ', '')+'%'
)
Order by A.ANO


GO

DROP Procedure QProcessSyncProfile
GO
Create Procedure QProcessSyncProfile(@Start_Update as smalldatetime, @Start_Time as varchar(8), @Last_Update as smalldatetime, @Last_Time as varchar(8))
as

Select P.ID, P.Last_Update, P.Last_Time 
from Profile P 
Where
(P.ASource='CAREMW' and 
((P.Last_Update>@Start_Update) or (P.Last_Update=@Start_Update and P.Last_Time>@Start_Time))
and 
((P.Last_Update<@Last_Update) or (P.Last_Update=@Last_Update and P.Last_Time<=@Last_Time)))

Order by Last_Update, Last_Time

GO

DROP PROCEDURE  GetTOPDeductibleByObjectInfo
GO
CREATE PROCEDURE  GetTOPDeductibleByObjectInfo(  
@P_TOPRO as varchar(10),
@P_Code as varchar(20),
@P_FLDID1 as varchar(10),  
@P_VALUEID1 as varchar(15),  
@P_FLDID2 as varchar(10),  
@P_VALUEID2 as varchar(15),  
@P_FLDID3 as varchar(10),  
@P_VALUEID3 as varchar(15),  
@P_FLDID4 as varchar(10),  
@P_VALUEID4 as varchar(15),  
@P_FLDID5 as varchar(10),  
@P_VALUEID5 as varchar(15)
)       
as   

Declare @AccSearch Table (FLDID varchar(10), VALUEID varchar(15))
insert into @AccSearch(FLDID, VALUEID)
Select @P_FLDID1, @P_VALUEID1 Where @P_FLDID1<>''
Union All
Select @P_FLDID2, @P_VALUEID2 Where @P_FLDID2<>''
Union All
Select @P_FLDID3, @P_VALUEID3 Where @P_FLDID3<>''
Union All
Select @P_FLDID4, @P_VALUEID4 Where @P_FLDID4<>''
Union All
Select @P_FLDID5, @P_VALUEID5 Where @P_FLDID5<>''

Select T.* 
from TOP_Deductible T
Inner Join DedTab D on (D.DCode=T.DCode)
Inner Join TOR on (TOR.TOR=D.TOR)
Where T.TOPRO=@P_TOPRO
and (@P_Code='' or Exists (Select RateCov.TOR from RateCov Where RateCov.Code=@P_Code and RateCov.TOR=T.TOR))
and (coalesce(ValueID1L,'') in ('<All>','') OR EXISTS (SELECT TOP 1 * FROM @ACCSEARCH ACCSEARCH WHERE TOR.RFLDID1=ACCSEARCH.FLDID and right(space(15)+ACCSEARCH.VALUEID,15) Between right(space(15)+ValueID1L,15) and (Case When ValueID1U in ('') then right(space(15)+ValueID1L,15) else right(space(15)+ValueID1U,15) end)))  
and (coalesce(ValueID2L,'') in ('<All>','') OR EXISTS (SELECT TOP 1 * FROM @ACCSEARCH ACCSEARCH WHERE TOR.RFLDID2=ACCSEARCH.FLDID and right(space(15)+ACCSEARCH.VALUEID,15) Between right(space(15)+ValueID2L,15) and (Case When ValueID2U in ('') then right(space(15)+ValueID2L,15) else right(space(15)+ValueID2U,15) end)))  
and (coalesce(ValueID3L,'') in ('<All>','') OR EXISTS (SELECT TOP 1 * FROM @ACCSEARCH ACCSEARCH WHERE TOR.RFLDID3=ACCSEARCH.FLDID and right(space(15)+ACCSEARCH.VALUEID,15) Between right(space(15)+ValueID3L,15) and (Case When ValueID3U in ('') then right(space(15)+ValueID3L,15) else right(space(15)+ValueID3U,15) end)))  
and (coalesce(ValueID4L,'') in ('<All>','') OR EXISTS (SELECT TOP 1 * FROM @ACCSEARCH ACCSEARCH WHERE TOR.RFLDID4=ACCSEARCH.FLDID and right(space(15)+ACCSEARCH.VALUEID,15) Between right(space(15)+ValueID4L,15) and (Case When ValueID4U in ('') then right(space(15)+ValueID4L,15) else right(space(15)+ValueID4U,15) end)))  
and (coalesce(ValueID5L,'') in ('<All>','') OR EXISTS (SELECT TOP 1 * FROM @ACCSEARCH ACCSEARCH WHERE TOR.RFLDID5=ACCSEARCH.FLDID and right(space(15)+ACCSEARCH.VALUEID,15) Between right(space(15)+ValueID5L,15) and (Case When ValueID5U in ('') then right(space(15)+ValueID5L,15) else right(space(15)+ValueID5U,15) end)))  



GO



insert into PatchVersioning
select '1535 Update Script - MiddleWare (for Core).sql',GETDATE()
go	
  
Declare @PrevScript varchar(100)
Declare @CurrScript varchar(100)

Select @PrevScript=''
Select @CurrSCript='1535 Update Script - MiddleWare (for Core).sql'


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

