
insert into PatchVersioning
select '57.22 Update Patch - Patch 2021 (15)',GETDATE()
go

Declare @PrevScript varchar(100)
Declare @CurrScript varchar(100)

Select @PrevScript='57.21 Update Patch - Patch 2021 (6)'
Select @CurrSCript='57.22 Update Patch - Patch 2021 (15)'


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
			DROP Procedure Facultative_Premium
			DROP Procedure QRFACDET 
       END TRY  
       BEGIN CATCH  
       END CATCH;


       Update SysTab Set ExecScript=@CurrScript, ExecScriptStatus='DONE'         
End


GO
CREATE Procedure Facultative_Premium(@P_ANO integer,@P_Code varchar(10), @P_CCY varchar(10), @P_SDate smalldatetime, @P_EDate smalldatetime, @P_FID varchar(255),@P_AdjustableF bit)    
as    
Select sum(Premium) as Premium    
From    
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
	END*MAX(PCalc.Rate) AS PREMIUM

	FROM RARRDET
	INNER JOIN FPART ON (FPART.ANO=RARRDET.ANO AND FPART.FID=RARRDET.FID)
	INNER JOIN ACCEPTANCE on (ACCEPTANCE.ANO=@P_ANO)
	INNER JOIN COVER on (COVER.CNO=ACCEPTANCE.CNO)
	LEFT JOIN ISOURCE ON (ISOURCE.CNO=ACCEPTANCE.CNO)
	INNER JOIN ICALC on (ICALC.ANO=@P_ANO AND ICALC.SDATE=@P_SDATE AND ICALC.EDATE=@P_EDATE AND ICALC.CODE=@P_CODE AND ICALC.CURRENCY=@P_CCY)     
	INNER JOIN ICOVER on (ICOVER.INO=ICALC.INO AND (ICOVER.ADJUSTABLE=@P_ADJUSTABLEF OR ACCEPTANCE.ATYPE='A'))
	INNER JOIN PCALC_ANNUM(@P_ANO) PCALC ON (PCALC.ANO=ICALC.ANO AND PCALC.CODE=ICALC.CODE AND PCALC.SDATE=ICALC.SDATE AND PCALC.EDATE=ICALC.EDATE AND PCALC.INO=ICALC.INO AND PCALC.CURRENCY=ICALC.CURRENCY)
	INNER JOIN (
		Select I.ANO, I.Currency, I.SDate, I.EDate, Count(*) as RiskNum 
		from ICalc I 
		Where I.Gross<>0 and I.ANO=@P_ANO 
		Group By I.ANO, I.Currency, I.SDate, I.EDate
	) I ON (I.ANO=ICALC.ANO AND I.Currency=ICALC.Currency and I.SDate=ICALC.SDATE and I.EDATE=ICALC.EDATE)
    WHERE RARRDET.ANO=@P_ANO AND RARRDET.FID=@P_FID 
    AND PCALC.GROSS<>0 AND ICALC.GROSS<>0 
    AND RARRDET.FULLCOVERF=1  
	AND (FPART.Currency='' or FPart.Currency=ICalc.Currency)   
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
	END*MAX(PCalc.Rate) AS PREMIUM
	
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
		Inner Join FPartDet FPart on (FPart.ANO=@P_ANO and FPart.FID=@P_FID)
		Inner Join RateCov on (RateCov.Code=FPart.Code and RateCov.TOR=I.TOR)
		Where I.Gross<>0 and I.ANO=@P_ANO and I.Code=@P_Code 
		Group By I.ANO, I.Currency, I.Code, I.SDate, I.EDate
	) I ON (I.ANO=ICALC.ANO AND I.Currency=ICALC.Currency and I.Code=ICalc.Code and I.SDate=ICALC.SDATE and I.EDATE=ICALC.EDATE)
	WHERE RARRDET.ANO=@P_ANO AND RARRDET.FID=@P_FID 
	AND PCALC.GROSS<>0 AND ICALC.GROSS<>0 
	AND RARRDET.FULLCOVERF=0           
	Group by ICalc.INO
) F    

GO


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
	INNER JOIN (
		Select I.ANO, I.Currency, I.SDate, I.EDate, Count(*) as RiskNum 
		from ICalc I 
		Where I.Gross<>0 and I.ANO=@P_ANO 
		Group By I.ANO, I.Currency, I.SDate, I.EDate
	) I ON (I.ANO=ICALC.ANO AND I.Currency=ICALC.Currency and I.SDate=ICALC.SDATE and I.EDATE=ICALC.EDATE)

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







