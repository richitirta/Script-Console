DROP Procedure QRFACDET 
GO
Create Procedure QRFACDET (@P_SANO integer, @P_ANO integer,@P_FID varchar(255), @P_CCY varchar(255), @P_SDate DateTime, @P_EDate DateTime, @P_Code varchar(10),@P_AdjustableF bit)      
as      
Select sum(Gross) as Gross
from
(   
	SELECT 
	CASE
	WHEN SUM(FPART.NETRATE)<>0 THEN
		(Case 
		When MAX(FPart.Unit)='F' Then 
			SUM(FPart.NetRate/I.RiskNum*100/coalesce(ISource.Share,100))
		When MAX(FPart.Unit)='M' Then 
			SUM(FPart.NetRate/PCALC.RiskNum/1000*(Case When RArrDet.Limit*100/coalesce(ISource.Share,100)<>0 Then RArrDet.Limit*100/coalesce(ISource.Share,100) else ICALC.TSI end)*ICALC.PCTADJ/100*ICALC.GROSS/PCALC.GROSS) 
		else 
			SUM(FPart.NetRate/PCALC.RiskNum/100*(Case When RArrDet.Limit*100/coalesce(ISource.Share,100)<>0 Then RArrDet.Limit*100/coalesce(ISource.Share,100) else ICALC.TSI end)*ICALC.PCTADJ/100*ICALC.GROSS/PCALC.GROSS) 
		end)
		*Max(
			Case 
			When Acceptance.AType<>'A' Then
				(Case When RArrDet.PCalc='P' or datediff(month,RArrDet.SDate, RArrDet.EDate)=0 or Cover.Voyage=1 Then 1 else 12/cast(datediff(month,RArrDet.SDate, RArrDet.EDate) as float) end)
			else
				(
					Case 
					When RArrDet.PCalc<>'P' Then 1 
					else 
						case when day(RARRDET.SDate)=day(RARRDET.EDate) and day(Acceptance.SDate)=day(Acceptance.EDate) and Cover.PPeriod<>1 then
							cast(datediff(month, RArrDet.Sdate, RArrdet.Edate) as Float)/12
						else
							cast(datediff(day, RArrDet.Sdate, RArrdet.Edate) as Float)/Cover.Prorata
						End						
					end
				)
			End
		)
	ELSE
		sum((ICALC.GROSS/PCALC.POGROSS*PCALC.PGROSS)/ICALC.PRORATA) 
	END AS GROSS

	FROM RARRDET
	INNER JOIN FPART ON (FPART.ANO=RARRDET.ANO AND FPART.FID=RARRDET.FID)
	INNER JOIN ACCEPTANCE on (ACCEPTANCE.ANO=@P_ANO)
	INNER JOIN COVER on (COVER.CNO=ACCEPTANCE.CNO)
	LEFT JOIN ISOURCE ON (ISOURCE.CNO=ACCEPTANCE.CNO)
	INNER JOIN ICALC on (ICALC.ANO=@P_ANO AND ICALC.SDATE=@P_SDATE AND ICALC.EDATE=@P_EDATE AND ICALC.CODE=@P_CODE AND ICALC.CURRENCY=@P_CCY)     
	INNER JOIN ICOVER on (ICOVER.INO=ICALC.INO AND (ICOVER.ADJUSTABLE=@P_ADJUSTABLEF OR ACCEPTANCE.ATYPE='A'))
	INNER JOIN PCALC_ANNUM(@P_ANO) PCALC ON (PCALC.ANO=ICALC.ANO AND PCALC.CODE=ICALC.CODE AND PCALC.SDATE=ICALC.SDATE AND PCALC.EDATE=ICALC.EDATE AND PCALC.INO=ICALC.INO AND PCALC.CURRENCY=ICALC.CURRENCY)	

	CROSS APPLY (
		Select I.ANO, I.Currency, I.SDate, I.EDate, 
		Sum(I.Gross)
		/
		(
			Select Sum(Ic.Gross) as RiskNum 
			from ICalc Ic 
			Where Ic.ANO=ICALC.ANO and Ic.Currency=ICalc.Currency and Ic.Code=ICalc.Code and Ic.TOR=ICalc.TOR and Ic.INO=ICalc.INO and Ic.SDate=ICalc.SDate and Ic.SANO=ICalc.SANO
		) as RiskNum
		from ICalc I 
		Where I.Gross<>0 and I.ANO=ICALC.ANO AND I.Currency=ICALC.Currency and I.SDate=ICALC.SDATE and I.EDATE=ICALC.EDATE
		Group By I.ANO, I.Currency, I.SDate, I.EDate
	) I

    WHERE RARRDET.ANO=@P_SANO AND RARRDET.FID=@P_FID 
    AND PCALC.GROSS<>0 AND ICALC.GROSS<>0 AND RARRDET.STATUS<>'O'      
	AND (FPART.Currency='' or FPart.Currency=ICalc.Currency)   
    AND RARRDET.FULLCOVERF=1      
	Group by ICalc.INO
  
	Union All      

	SELECT 
	CASE
	WHEN SUM(FPART.NETRATE)<>0 THEN
		(Case 
		When MAX(FPart.Unit)='F' Then 
			SUM(FPart.NetRate/I.RiskNum*100/coalesce(ISource.Share,100))
		When MAX(FPart.Unit)='M' Then 
			Max(FPart.NetRate/1000*(Case When RArrDet.Limit*100/coalesce(ISource.Share,100)<>0 Then RArrDet.Limit*100/coalesce(ISource.Share,100) else ICALC.TSI end)*ICALC.PCTADJ/100) 
		else 
			Max(FPart.NetRate/100*(Case When RArrDet.Limit*100/coalesce(ISource.Share,100)<>0 Then RArrDet.Limit*100/coalesce(ISource.Share,100) else ICALC.TSI end)*ICALC.PCTADJ/100) 
		end)
		*Max(
			Case 
			When Acceptance.AType<>'A' Then
				(Case When RArrDet.PCalc='P' or datediff(month,RArrDet.SDate, RArrDet.EDate)=0 or Cover.Voyage=1 Then 1 else 12/cast(datediff(month,RArrDet.SDate, RArrDet.EDate) as float) end)
			else
				(
					Case 
					When RArrDet.PCalc<>'P' Then 1 
					else 
						case when day(RARRDET.SDate)=day(RARRDET.EDate) and day(Acceptance.SDate)=day(Acceptance.EDate) and Cover.PPeriod<>1 then
							cast(datediff(month, RArrDet.Sdate, RArrdet.Edate) as Float)/12
						else
							cast(datediff(day, RArrDet.Sdate, RArrdet.Edate) as Float)/Cover.Prorata
						End						
					end
				)
			End
		)
	ELSE
		sum((ICALC.GROSS/PCALC.POGROSS*PCALC.PGROSS)/ICALC.PRORATA) 
	END AS GROSS
	
	FROM RARRDET
	INNER JOIN  FPARTDET FPART ON (FPART.ANO=RARRDET.ANO AND FPART.FID=RARRDET.FID)
	INNER JOIN ACCEPTANCE on (ACCEPTANCE.ANO=@P_ANO)
	INNER JOIN COVER ON (COVER.CNO=ACCEPTANCE.CNO)
	LEFT JOIN ISOURCE ON (ISOURCE.CNO=ACCEPTANCE.CNO)
	INNER JOIN ICALC ON (ICALC.ANO=@P_ANO AND ICALC.SDATE=@P_SDATE AND ICALC.EDATE=@P_EDATE AND ICALC.CODE=@P_CODE AND ICALC.CURRENCY=@P_CCY)
	INNER JOIN ICOVER on (ICOVER.INO=ICALC.INO AND (ICOVER.ADJUSTABLE=@P_ADJUSTABLEF OR ACCEPTANCE.ATYPE='A'))
	INNER JOIN PCALC_ANNUM(@P_ANO) PCALC ON (PCALC.ANO=ICALC.ANO AND PCALC.CODE=ICALC.CODE AND PCALC.SDATE=ICALC.SDATE AND PCALC.EDATE=ICALC.EDATE AND PCALC.INO=ICALC.INO AND PCALC.CURRENCY=ICALC.CURRENCY)
	INNER JOIN RATECOV ON (RATECOV.CODE=FPART.CODE AND RATECOV.TOR=ICALC.TOR)
	INNER JOIN (
		Select I.ANO, I.Currency, I.Code, I.SDate, I.EDate, Count(*) as RiskNum 
		from ICalc I
		Inner Join FPartDet FPart on (FPart.ANO=@P_SANO and FPart.FID=@P_FID)
		Inner Join RateCov on (RateCov.Code=FPart.Code and RateCov.TOR=I.TOR)
		Where I.Gross<>0 and I.ANO=@P_ANO and I.Code=@P_Code 
		Group By I.ANO, I.Currency, I.Code, I.SDate, I.EDate
	) I ON (I.ANO=ICALC.ANO AND I.Currency=ICALC.Currency and I.Code=ICalc.Code and I.SDate=ICALC.SDATE and I.EDATE=ICALC.EDATE)

	WHERE RARRDET.ANO=@P_SANO AND RARRDET.FID=@P_FID 
	AND PCALC.GROSS<>0 AND ICALC.GROSS<>0 AND RARRDET.STATUS<>'O'      
	AND RARRDET.FULLCOVERF=0           
	Group by ICalc.INO
) F  

GO


DROP FUNCTION DISPLAY_GROSS_FACULTATIVE_CALCULATION
GO
CREATE FUNCTION DISPLAY_GROSS_FACULTATIVE_CALCULATION(@P_ANO int, @P_FID Varchar(20))      
RETURNS @PCALC TABLE (ANO Int, Currency varchar(10), Code varchar(10), FCode varchar(10), SDate SmallDateTime, EDate SmallDateTime, Gross Float, Calculation varchar(1024))
AS
BEGIN

DECLARE @ACCEPTANCE TABLE (ANO Int, CNO Int, PANO Int, ATYPE varchar(1), EMethod varchar(1), SDate Smalldatetime, EDate Smalldatetime)
INSERT INTO @ACCEPTANCE
SELECT ANO, CNO, PANO, ATYPE, EMethod, SDate, EDate FROM ACCEPTANCE WHERE ANO=@P_ANO

DECLARE @RARRDET TABLE (ANO Int, ATYPE Varchar(1), FID varchar(20), Limit Float, PCalc varchar(1), SDate SmallDateTime, EDate SmallDateTime, Share Float, FLPCT Float, OnGrossAfterCommF Bit, FullCoverF Bit, NoRefundF Bit)
INSERT INTO @RARRDET
Select ANO, ATYPE, FID, Limit, PCalc, SDate, EDate, Share, FLPCT, OnGrossAfterCommF, FullCoverF, NOREFUNDF FROM RarrDet Where ANO=@P_ANO and FID=@P_FID

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
			sum(ICalc.PCTShare/100*ICalc.Gross*(Case When ICalc.OnGrossAfterCommF=1 Then (100-dbo.Premium_Facultative_Commission(ICalc.ANO, ICalc.Code,0,0))/100 else 1 end)/Icalc.PProrata)*max(ICalc.FacProrata)*max(ICalc.Share)/100    
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
			sum(ICalc.PCTShare/100*Icalc.TSI*ICalc.PCTADJ/100)*max(ICalc.NetRate)/1000*max(ICalc.FacProrata)*max(ICalc.Share)/100   
		   else
			sum(ICalc.PCTShare/100*Icalc.TSI*ICalc.PCTADJ/100)*max(ICalc.NetRate)/100*max(ICalc.FacProrata)*max(ICalc.Share)/100   			
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
			convert(varchar(25), cast(sum(ICalc.PCTShare/100*ICalc.Gross*(Case When ICalc.OnGrossAfterCommF=1 Then (100-dbo.Premium_Facultative_Commission(ICalc.ANO, ICalc.Code,0,0))/100 else 1 end)/ICalc.PProrata) as Money),1) + Case When max(ICalc.FacProrata_Calculation)='' or Max(ICalc.FacProrata)=1 Then '' Else ' x ' + max(ICalc.FacProrata_Calculation) End + ' x '+convert(varchar(25), Max(ICalc.Share),0)+'%'    
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
				convert(varchar(25), cast(sum(ICalc.PCTShare/100*Icalc.TSI*ICalc.PCTADJ/100) as Money),1) + ' x '+convert(varchar(25), cast(max(ICalc.NetRate/ICalc.NetRateProrata) as Money),2)+'‰' + Case When max(ICalc.FacProrata_Calculation)='' or Max(ICalc.FacProrata*ICalc.NetRateProrata)=1 Then '' Else ' x ' + max(ICalc.FacProrata_Calculation) End + ' x '+convert(varchar(25), Max(ICalc.Share),0)+'%'    
			else
				convert(varchar(25), cast(sum(ICalc.PCTShare/100*Icalc.TSI*ICalc.PCTADJ/100) as Money),1) + ' x '+convert(varchar(25), cast(max(ICalc.NetRate/ICalc.NetRateProrata) as Money),2)+'%' + Case When max(ICalc.FacProrata_Calculation)='' or Max(ICalc.FacProrata*ICalc.NetRateProrata)=1 Then '' Else ' x ' + max(ICalc.FacProrata_Calculation) End + ' x '+convert(varchar(25), Max(ICalc.Share),0)+'%'    
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
				convert(varchar(25), cast(sum(ICalc.PCTShare/100*Icalc.TSI*ICalc.PCTADJ/100) as Money),1) + ' x '+convert(varchar(25), max(ICalc.NetRate),0)+'‰' + Case When max(ICalc.FacProrata_Calculation)='' or Max(ICalc.FacProrata)=1 Then '' Else ' x ' + max(ICalc.FacProrata_Calculation) End + ' x '+convert(varchar(25), Max(ICalc.Share),0)+'%'    		
			else
				convert(varchar(25), cast(sum(ICalc.PCTShare/100*Icalc.TSI*ICalc.PCTADJ/100) as Money),1) + ' x '+convert(varchar(25), max(ICalc.NetRate),0)+'%' + Case When max(ICalc.FacProrata_Calculation)='' or Max(ICalc.FacProrata)=1 Then '' Else ' x ' + max(ICalc.FacProrata_Calculation) End + ' x '+convert(varchar(25), Max(ICalc.Share),0)+'%'    		
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
	Max(D.FacProrata_Calculation) as FacProrata_calculation,    
	Max(D.FacProrata) as FacProrata,     
	SUM(Case When PCALC.Description<>'' and PCALC.Description<>'Minimum Premium' then ICALC.GROSS*PCALC.GROSS/PCALC.OGROSS else ICALC.GROSS*D.GROSS/D.OGROSS end*(Case When RArrDet.Limit<>0 Then RArrDet.Limit/RArrHeader.TAmount Else 1 end)) AS GROSS,         
	AVG(ICalc.Prorata) as PProrata,     
	Max(PCalc.Ourshare/PCalc.TSI*100) as PCTShare,     
	Max(ICalc.SRate) as SRate,     
	Max((Case When RArrDet.Limit*PCalc.TSI/PCalc.OurShare<>0 Then RArrDet.Limit*PCalc.TSI/PCalc.OurShare else ICalc.TSI end)) as TSI,     
	Max(Case When RArrDet.PCalc='P' or datediff(month,RArrDet.SDate, RArrDet.EDate)=0 or Cover.Voyage=1 Then 1 else 12/cast(datediff(month,case WHen RArrDet.SDate>ICalc.SDate Then RArrDet.Sdate else ICalc.SDate end, Case When RArrDet.EDate<ICalc.EDate then RArrDet.EDate else ICalc.EDate end) as float) end) as NetRateProrata,    
	Case 
	When Max(FPart.Unit)='F' Then 
		Sum(FPart.NetRate*Case When RArrDet.PCalc='P' or datediff(month,RArrDet.SDate, RArrDet.EDate)=0 or Cover.Voyage=1 Then 1 else 12/cast(datediff(month,case WHen RArrDet.SDate>ICalc.SDate Then RArrDet.Sdate else ICalc.SDate end, Case When RArrDet.EDate<ICalc.EDate then RArrDet.EDate else ICalc.EDate end) as float) end/I.RiskNum) 
	Else
		Max(FPart.NetRate*Case When RArrDet.PCalc='P' or datediff(month,RArrDet.SDate, RArrDet.EDate)=0 or Cover.Voyage=1 Then 1 else 12/cast(datediff(month,case WHen RArrDet.SDate>ICalc.SDate Then RArrDet.Sdate else ICalc.SDate end, Case When RArrDet.EDate<ICalc.EDate then RArrDet.EDate else ICalc.EDate end) as float) end) 
	End as NetRate,    
	Max(FPart.Unit) as Unit,
	Max(RArrDet.Share) as Share,    
	Max(RArrDet.FLPCT) as FLPCT,    
	Max(ICalc.sProrata) as sProrata,  
	Max(Cast(RArrDet.OnGrossAfterCommF as Integer)) as OnGrossAfterCommF  
		
	from @Acceptance Acceptance
	Inner Join RArrHeader on (RArrHeader.ANO=Acceptance.ANO)
	Inner Join ICalc on (ICalc.ANO=Acceptance.ANO and ICalc.Rate<>0)
	Inner Join PCalc on (PCalc.ANO=ICalc.ANO and PCalc.Currency=ICalc.Currency)
	CROSS APPLY (
		Select I.ANO, I.Currency, I.SDate, I.EDate, 
		Sum(I.Gross)
		/
		(
			Select Sum(Ic.Gross) as RiskNum 
			from ICalc Ic 
			Where Ic.ANO=ICALC.ANO and Ic.Currency=ICalc.Currency and Ic.Code=ICalc.Code and Ic.TOR=ICalc.TOR and Ic.INO=ICalc.INO and Ic.SDate=ICalc.SDate and Ic.SANO=ICalc.SANO
		) as RiskNum
		from ICalc I 
		Where I.Gross<>0 and I.ANO=ICALC.ANO AND I.Currency=ICALC.Currency and I.SDate=ICALC.SDATE and I.EDATE=ICALC.EDATE
		Group By I.ANO, I.Currency, I.SDate, I.EDate
	) I
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
			sum(ICalc.PCTShare/100*ICalc.Gross*(Case When ICalc.OnGrossAfterCommF=1 Then (100-dbo.Premium_Facultative_Commission(ICalc.ANO, ICalc.Code,0,0))/100 else 1 end)/Icalc.PProrata)*max(ICalc.FacProrata)*max(ICalc.Share)/100    
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
		    sum(ICalc.PCTShare/100*Icalc.TSI*ICalc.PCTADJ/100)*max(ICalc.NetRate)/1000*max(ICalc.FacProrata)*max(ICalc.Share)/100   
		   else
			sum(ICalc.PCTShare/100*Icalc.TSI*ICalc.PCTADJ/100)*max(ICalc.NetRate)/100*max(ICalc.FacProrata)*max(ICalc.Share)/100   
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
			'- ' + convert(varchar(25), cast(sum(ICalc.PCTShare/100*ICalc.Gross*(Case When ICalc.OnGrossAfterCommF=1 Then (100-dbo.Premium_Facultative_Commission(ICalc.ANO, ICalc.Code,0,0))/100 else 1 end)/ICalc.PProrata) as Money),1) + Case When max(ICalc.FacProrata_Calculation)='' or Max(ICalc.FacProrata)=1 Then '' Else ' x ' + max(ICalc.FacProrata_Calculation) End + ' x '+convert(varchar(25), Max(ICalc.Share),0)+'%'    
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
				'- ' + convert(varchar(25), cast(sum(ICalc.PCTShare/100*Icalc.TSI*ICalc.PCTADJ/100) as Money),1) + ' x '+convert(varchar(25), cast(max(ICalc.NetRate/ICalc.NetRateProrata) as Money),2)+'‰' + Case When max(ICalc.FacProrata_Calculation)='' or Max(ICalc.FacProrata*ICalc.NetRateProrata)=1 Then '' Else ' x ' + max(ICalc.FacProrata_Calculation) End + ' x '+convert(varchar(25), Max(ICalc.Share),0)+'%'    
			else
				'- ' + convert(varchar(25), cast(sum(ICalc.PCTShare/100*Icalc.TSI*ICalc.PCTADJ/100) as Money),1) + ' x '+convert(varchar(25), cast(max(ICalc.NetRate/ICalc.NetRateProrata) as Money),2)+'%' + Case When max(ICalc.FacProrata_Calculation)='' or Max(ICalc.FacProrata*ICalc.NetRateProrata)=1 Then '' Else ' x ' + max(ICalc.FacProrata_Calculation) End + ' x '+convert(varchar(25), Max(ICalc.Share),0)+'%'    
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
				'- ' + convert(varchar(25), cast(sum(ICalc.PCTShare/100*Icalc.TSI*ICalc.PCTADJ/100) as Money),1) + ' x '+convert(varchar(25), max(ICalc.NetRate),0)+'‰' + Case When max(ICalc.FacProrata_Calculation)='' or Max(ICalc.FacProrata)=1 Then '' Else ' x ' + max(ICalc.FacProrata_Calculation) End + ' x '+convert(varchar(25), Max(ICalc.Share),0)+'%'    		
			else
				'- ' + convert(varchar(25), cast(sum(ICalc.PCTShare/100*Icalc.TSI*ICalc.PCTADJ/100) as Money),1) + ' x '+convert(varchar(25), max(ICalc.NetRate),0)+'%' + Case When max(ICalc.FacProrata_Calculation)='' or Max(ICalc.FacProrata)=1 Then '' Else ' x ' + max(ICalc.FacProrata_Calculation) End + ' x '+convert(varchar(25), Max(ICalc.Share),0)+'%'    		
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
	Max(D.FacProrata_Calculation) as FacProrata_calculation,    
	Max(D.FacProrata) as FacProrata,     
	SUM(Case When PCALC.Description<>'' and PCALC.Description<>'Minimum Premium' then ICALC.GROSS*PCALC.GROSS/PCALC.OGROSS else ICALC.GROSS*D.GROSS/D.OGROSS end*(Case When RArrDet.Limit<>0 Then RArrDet.Limit/RArrHeader.TAmount Else 1 end)) AS GROSS,         

	AVG(ICalc.Prorata) as PProrata,     
	Max(PCalc.Ourshare/PCalc.TSI*100) as PCTShare,     
	Max(ICalc.SRate) as SRate,     
	Max((Case When RArrDet.Limit*PCalc.TSI/PCalc.OurShare<>0 Then RArrDet.Limit*PCalc.TSI/PCalc.OurShare else ICalc.TSI end)) as TSI,     
	Max(Case When RArrDet.PCalc='P' or datediff(month,RArrDet.SDate, RArrDet.EDate)=0 or Cover.Voyage=1 Then 1 else 12/cast(datediff(month,case WHen RArrDet.SDate>ICalc.SDate Then RArrDet.Sdate else ICalc.SDate end, Case When RArrDet.EDate<ICalc.EDate then RArrDet.EDate else ICalc.EDate end) as float) end) as NetRateProrata,    
	Case 
	When Max(FPart.Unit)='F' Then 
		Sum(FPart.NetRate*Case When RArrDet.PCalc='P' or datediff(month,RArrDet.SDate, RArrDet.EDate)=0 or Cover.Voyage=1 Then 1 else 12/cast(datediff(month,case WHen RArrDet.SDate>ICalc.SDate Then RArrDet.Sdate else ICalc.SDate end, Case When RArrDet.EDate<ICalc.EDate then RArrDet.EDate else ICalc.EDate end) as float) end/I.RiskNum) 
	Else
		Max(FPart.NetRate*Case When RArrDet.PCalc='P' or datediff(month,RArrDet.SDate, RArrDet.EDate)=0 or Cover.Voyage=1 Then 1 else 12/cast(datediff(month,case WHen RArrDet.SDate>ICalc.SDate Then RArrDet.Sdate else ICalc.SDate end, Case When RArrDet.EDate<ICalc.EDate then RArrDet.EDate else ICalc.EDate end) as float) end) 
	End as NetRate,    
	Max(FPart.Unit) as Unit,
	Max(RArrDet.Share) as Share,    
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
	CROSS APPLY (
		Select I.ANO, I.Currency, I.SDate, I.EDate, 
		Sum(I.Gross)
		/
		(
			Select Sum(Ic.Gross) as RiskNum 
			from ICalc Ic 
			Where Ic.ANO=ICALC.ANO and Ic.Currency=ICalc.Currency and Ic.Code=ICalc.Code and Ic.TOR=ICalc.TOR and Ic.INO=ICalc.INO and Ic.SDate=ICalc.SDate and Ic.SANO=ICalc.SANO
		) as RiskNum
		from ICalc I 
		Where I.Gross<>0 and I.ANO=ICALC.ANO AND I.Currency=ICALC.Currency and I.SDate=ICALC.SDATE and I.EDATE=ICALC.EDATE
		Group By I.ANO, I.Currency, I.SDate, I.EDate
	) I
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
			sum(ICalc.PCTShare/100*ICalc.Gross*(Case When ICalc.OnGrossAfterCommF=1 Then (100-dbo.Premium_Facultative_Commission(ICalc.ANO, ICalc.Code,0,0))/100 else 1 end)/Icalc.PProrata)*max(ICalc.FacProrata)*max(ICalc.Share)/100    
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
		    sum(ICalc.PCTShare/100*Icalc.TSI*ICalc.PCTADJ/100)*max(ICalc.NetRate)/1000*max(ICalc.FacProrata)*max(ICalc.Share)/100   
		   else
			sum(ICalc.PCTShare/100*Icalc.TSI*ICalc.PCTADJ/100)*max(ICalc.NetRate)/100*max(ICalc.FacProrata)*max(ICalc.Share)/100   
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
			convert(varchar(25), cast(sum(ICalc.PCTShare/100*ICalc.Gross*(Case When ICalc.OnGrossAfterCommF=1 Then (100-dbo.Premium_Facultative_Commission(ICalc.ANO, ICalc.Code,0,0))/100 else 1 end)/ICalc.PProrata) as Money),1) + Case When max(ICalc.FacProrata_Calculation)='' or Max(ICalc.FacProrata)=1 Then '' Else ' x ' + max(ICalc.FacProrata_Calculation) End + ' x '+convert(varchar(25), Max(ICalc.Share),0)+'%'    
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
				convert(varchar(25), cast(sum(ICalc.PCTShare/100*Icalc.TSI*ICalc.PCTADJ/100) as Money),1) + ' x '+convert(varchar(25), cast(max(ICalc.NetRate/ICalc.NetRateProrata) as Money),2)+'‰' + Case When max(ICalc.FacProrata_Calculation)='' or Max(ICalc.FacProrata*ICalc.NetRateProrata)=1 Then '' Else ' x ' + max(ICalc.FacProrata_Calculation) End + ' x '+convert(varchar(25), Max(ICalc.Share),0)+'%'    
			else
				convert(varchar(25), cast(sum(ICalc.PCTShare/100*Icalc.TSI*ICalc.PCTADJ/100) as Money),1) + ' x '+convert(varchar(25), cast(max(ICalc.NetRate/ICalc.NetRateProrata) as Money),2)+'%' + Case When max(ICalc.FacProrata_Calculation)='' or Max(ICalc.FacProrata*ICalc.NetRateProrata)=1 Then '' Else ' x ' + max(ICalc.FacProrata_Calculation) End + ' x '+convert(varchar(25), Max(ICalc.Share),0)+'%'    
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
				convert(varchar(25), cast(sum(ICalc.PCTShare/100*Icalc.TSI*ICalc.PCTADJ/100) as Money),1) + ' x '+convert(varchar(25), max(ICalc.NetRate),0)+'‰' + Case When max(ICalc.FacProrata_Calculation)='' or Max(ICalc.FacProrata)=1 Then '' Else ' x ' + max(ICalc.FacProrata_Calculation) End + ' x '+convert(varchar(25), Max(ICalc.Share),0)+'%'    		
			else
				convert(varchar(25), cast(sum(ICalc.PCTShare/100*Icalc.TSI*ICalc.PCTADJ/100) as Money),1) + ' x '+convert(varchar(25), max(ICalc.NetRate),0)+'%' + Case When max(ICalc.FacProrata_Calculation)='' or Max(ICalc.FacProrata)=1 Then '' Else ' x ' + max(ICalc.FacProrata_Calculation) End + ' x '+convert(varchar(25), Max(ICalc.Share),0)+'%'    		
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
	Max(FPart.Code) as FCode,
	Max(D.FacProrata_Calculation) as FacProrata_calculation,    
	Max(D.FacProrata) as FacProrata,     
	Max(Case When PCALC.Description<>'' and PCALC.Description<>'Minimum Premium' then ICALC.GROSS*PCALC.GROSS/PCALC.OGROSS else ICALC.GROSS*D.GROSS/D.OGROSS end*(Case When RArrDet.Limit<>0 Then RArrDet.Limit/RArrHeader.TAmount Else 1 end)) AS GROSS,         
 
	Max(ICalc.Prorata) as PProrata,     
	Max(PCalc.Ourshare/PCalc.TSI*100) as PCTShare,     
	Max(ICalc.SRate) as SRate,     
	Max((Case When RArrDet.Limit*PCalc.TSI/PCalc.OurShare<>0 Then RArrDet.Limit*PCalc.TSI/PCalc.OurShare else ICalc.TSI end)) as TSI,     
	Max(Case When RArrDet.PCalc='P' or datediff(month,RArrDet.SDate, RArrDet.EDate)=0 or Cover.Voyage=1 Then 1 else 12/cast(datediff(month,case WHen RArrDet.SDate>ICalc.SDate Then RArrDet.Sdate else ICalc.SDate end, Case When RArrDet.EDate<ICalc.EDate then RArrDet.EDate else ICalc.EDate end) as float) end) as NetRateProrata,    
	Max(FPart.NetRate*Case When RArrDet.PCalc='P' or datediff(month,RArrDet.SDate, RArrDet.EDate)=0 or Cover.Voyage=1 Then 1 else 12/cast(datediff(month,case WHen RArrDet.SDate>ICalc.SDate Then RArrDet.Sdate else ICalc.SDate end, Case When RArrDet.EDate<ICalc.EDate then RArrDet.EDate else ICalc.EDate end) as float) end) as NetRate,    
	Max(FPart.Unit) as Unit,
	Max(RArrDet.Share) as Share,    
	Max(RArrDet.FLPCT) as FLPCT,    
	Max(ICalc.sProrata) as sProrata,  
	Max(Cast(RArrDet.OnGrossAfterCommF as Integer)) as OnGrossAfterCommF  
	from @Acceptance Acceptance
	Inner Join RArrheader on (RArrHeader.ANO=Acceptance.ANO)
	Inner Join ICalc on (ICalc.ANO=Acceptance.ANO and ICalc.Rate<>0)
	Inner Join PCalc on (PCalc.ANO=ICalc.ANO and PCalc.Currency=ICalc.Currency)
	Inner Join DISPLAY_FACULTATIVE_PRORATA_CALCULATION(@P_ANO, @P_FID) D on (D.ANO=ICalc.ANO and D.Currency=ICalc.Currency and D.SDate=ICalc.Sdate and D.EDate=ICalc.EDate and D.TOR=ICalc.TOR    )
	Inner Join @RARRDET RArrDet on (RArrDet.AType<>'C' and RArrDet.FullCoverF=0 and RArrDet.ANO=D.ANO and RArrDet.FID=@P_FID)
	Inner Join FPartDet FPart on (FPart.ANO=RArrDet.ANO and FPart.FID=RArrdet.FID)
	Inner Join RateCov on (RateCov.Code=FPart.Code and RateCov.TOR=ICalc.TOR)
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
			sum(ICalc.PCTShare/100*ICalc.Gross*(Case When ICalc.OnGrossAfterCommF=1 Then (100-dbo.Premium_Facultative_Commission(ICalc.ANO, ICalc.Code,0,0))/100 else 1 end)/Icalc.PProrata)*max(ICalc.FacProrata)*max(ICalc.Share)/100    
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
		    sum(ICalc.PCTShare/100*Icalc.TSI*ICalc.PCTADJ/100)*max(ICalc.NetRate)/1000*max(ICalc.FacProrata)*max(ICalc.Share)/100   
		   else
			sum(ICalc.PCTShare/100*Icalc.TSI*ICalc.PCTADJ/100)*max(ICalc.NetRate)/100*max(ICalc.FacProrata)*max(ICalc.Share)/100   
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
			'- ' + convert(varchar(25), cast(sum(ICalc.PCTShare/100*ICalc.Gross*(Case When ICalc.OnGrossAfterCommF=1 Then (100-dbo.Premium_Facultative_Commission(ICalc.ANO, ICalc.Code,0,0))/100 else 1 end)/ICalc.PProrata) as Money),1) + Case When max(ICalc.FacProrata_Calculation)='' or Max(ICalc.FacProrata)=1 Then '' Else ' x ' + max(ICalc.FacProrata_Calculation) End + ' x '+convert(varchar(25), Max(ICalc.Share),0)+'%'    
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
				'- ' + convert(varchar(25), cast(sum(ICalc.PCTShare/100*Icalc.TSI*ICalc.PCTADJ/100) as Money),1) + ' x '+convert(varchar(25), cast(max(ICalc.NetRate/ICalc.NetRateProrata) as Money),2)+'‰' + Case When max(ICalc.FacProrata_Calculation)='' or Max(ICalc.FacProrata*ICalc.NetRateProrata)=1 Then '' Else ' x ' + max(ICalc.FacProrata_Calculation) End + ' x '+convert(varchar(25), Max(ICalc.Share),0)+'%'    
			else
				'- ' + convert(varchar(25), cast(sum(ICalc.PCTShare/100*Icalc.TSI*ICalc.PCTADJ/100) as Money),1) + ' x '+convert(varchar(25), cast(max(ICalc.NetRate/ICalc.NetRateProrata) as Money),2)+'%' + Case When max(ICalc.FacProrata_Calculation)='' or Max(ICalc.FacProrata*ICalc.NetRateProrata)=1 Then '' Else ' x ' + max(ICalc.FacProrata_Calculation) End + ' x '+convert(varchar(25), Max(ICalc.Share),0)+'%'    
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
				'- ' + convert(varchar(25), cast(sum(ICalc.PCTShare/100*Icalc.TSI*ICalc.PCTADJ/100) as Money),1) + ' x '+convert(varchar(25), max(ICalc.NetRate),0)+'‰' + Case When max(ICalc.FacProrata_Calculation)='' or Max(ICalc.FacProrata)=1 Then '' Else ' x ' + max(ICalc.FacProrata_Calculation) End + ' x '+convert(varchar(25), Max(ICalc.Share),0)+'%'    		
			else
				'- ' + convert(varchar(25), cast(sum(ICalc.PCTShare/100*Icalc.TSI*ICalc.PCTADJ/100) as Money),1) + ' x '+convert(varchar(25), max(ICalc.NetRate),0)+'%' + Case When max(ICalc.FacProrata_Calculation)='' or Max(ICalc.FacProrata)=1 Then '' Else ' x ' + max(ICalc.FacProrata_Calculation) End + ' x '+convert(varchar(25), Max(ICalc.Share),0)+'%'    		
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
	Max(FPart.Code) as FCode,
	Max(D.FacProrata_Calculation) as FacProrata_calculation,    
	Max(D.FacProrata) as FacProrata,     
	Max(Case When PCALC.Description<>'' and PCALC.Description<>'Minimum Premium' then ICALC.GROSS*PCALC.GROSS/PCALC.OGROSS else ICALC.GROSS*D.GROSS/D.OGROSS end*(Case When RArrDet.Limit<>0 Then RArrDet.Limit/RArrHeader.TAmount Else 1 end)) AS GROSS,         
 
	Max(ICalc.Prorata) as PProrata,     
	Max(PCalc.Ourshare/PCalc.TSI*100) as PCTShare,     
	Max(ICalc.SRate) as SRate,     
	Max((Case When RArrDet.Limit*PCalc.TSI/PCalc.OurShare<>0 Then RArrDet.Limit*PCalc.TSI/PCalc.OurShare else ICalc.TSI end)) as TSI,     
	Max(Case When RArrDet.PCalc='P' or datediff(month,RArrDet.SDate, RArrDet.EDate)=0 or Cover.Voyage=1 Then 1 else 12/cast(datediff(month,case WHen RArrDet.SDate>ICalc.SDate Then RArrDet.Sdate else ICalc.SDate end, Case When RArrDet.EDate<ICalc.EDate then RArrDet.EDate else ICalc.EDate end) as float) end) as NetRateProrata,    
	Max(FPart.NetRate*Case When RArrDet.PCalc='P' or datediff(month,RArrDet.SDate, RArrDet.EDate)=0 or Cover.Voyage=1 Then 1 else 12/cast(datediff(month,case WHen RArrDet.SDate>ICalc.SDate Then RArrDet.Sdate else ICalc.SDate end, Case When RArrDet.EDate<ICalc.EDate then RArrDet.EDate else ICalc.EDate end) as float) end) as NetRate,    
	Max(FPart.Unit) as Unit,
	Max(RArrDet.Share) as Share,    
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
	Inner Join FPartDet FPart on (FPart.ANO=RArrDet.ANO and FPart.FID=RArrdet.FID)
	Inner Join RateCov on (RateCov.Code=FPart.Code and RateCov.TOR=ICalc.TOR)
	Inner Join @RARRDET nRArrDet on (nRArrDet.ANO=pAcceptance.ANO and nRArrDet.FID=@P_FID)
	Inner Join Cover on (Cover.CNO=Acceptance.CNO)
	Where pAcceptance.ANO=@P_ANO 
	Group By ICalc.ANO, ICalc.INO, ICalc.Currency, ICalc.Code, ICalc.SDate, ICalc.EDate, ICalc.PCTAdj 
	) ICalc
	Group By ICalc.ANO, ICalc.Currency, ICalc.Code, ICalc.FCode, ICalc.SDate, ICalc.EDate, ICalc.SRate, ICalc.sProrata, ICalc.PCTadj        
END
    
RETURN
END






go





 insert into PatchVersioning	
select '691 Update Script - Patch 2023 (64)',GETDATE()
go





Declare @PrevScript varchar(100)
Declare @CurrScript varchar(100)

Select @PrevScript=''
Select @CurrSCript='691 Update Script - Patch 2023 (64)'


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









