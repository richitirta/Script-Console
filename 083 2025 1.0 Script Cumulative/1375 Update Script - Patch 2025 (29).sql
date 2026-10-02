BEGIN TRANSACTION
SET QUOTED_IDENTIFIER ON
SET ARITHABORT ON
SET NUMERIC_ROUNDABORT OFF
SET CONCAT_NULL_YIELDS_NULL ON
SET ANSI_NULLS ON
SET ANSI_PADDING ON
SET ANSI_WARNINGS ON
COMMIT


IF EXISTS ( SELECT * FROM   sysobjects WHERE  id = object_id(N'PCALC01_ADJ') and OBJECTPROPERTY(id, N'IsProcedure') = 1 )
BEGIN DROP PROCEDURE PCALC01_ADJ END
GO

CREATE Procedure PCALC01_ADJ(@P_ANO integer)     
As     
SELECT  A1.TOC,     
COVER.PPERIOD,     
DATEDIFF(DAY,A1.SDATE, A1.EDATE) as PRORATA,     
COVER.VOYAGE,     
CASE WHEN RCOVER.UNIT='L' Then 'C' ELSE RCOVER.UNIT END AS UNIT,      
RCOVER.CODE,     
RATECOV.TOR,     
RCOVER.DISCOUNT+RCOVER.DISCOUNT_EXT AS DISCOUNT,      
RCOVER.LOADING*CASE WHEN RCOVER.CATEGORY='M' AND ICOVER.CATEGORY='M' THEN DBO.FN_RATE_LOADING(RCOVER.ANO) ELSE 1 END AS LOADING,  
CASE   
WHEN RCOVER.UNIT='L' Then 0   
ELSE RCOVER.RATE*RATECOV.PORTION/RCOVER.PORTION  
END AS RATE,     
case when RCOVER.SDATE<A2.PDATE then A2.PDATE Else RCOVER.SDATE end as SDATE,     
Case When RCOVER.EDATE>A2.PPDATE then A2.PPDATE ELSE RCOVER.EDATE end as EDATE,     
Case WHEN ICOVER.NOTDECRF=1 then 100 else RCOVER.PCTLOSS end as PCTLOSS,     
Case WHEN ICOVER.NOTDECRF=1 then 0 else RCOVER.PADDITION end as PADDITION,     
Case When (Case when RCOVER.SDATE<A2.PDATE then A2.PDATE Else RCOVER.SDATE end)=A1.SDATE AND (Case When RCOVER.EDATE>A2.PPDATE then A2.PPDATE ELSE RCOVER.EDATE end)=A1.EDATE Then RCover.PCalc Else 'P' End as PCalc,     
Case 
WHEN TOI.ADJMETHOD='OVERLIMIT' then A1.CPCT 
ELSE 
	(
		Case 
		When A1.CPCT<>0 then A1.CPCT 
		else 100 
		end
		*
		Cast(datediff(day, case when RCOVER.SDATE<A2.PDATE then A2.PDATE Else RCOVER.SDATE end, Case When RCOVER.EDATE>A2.PPDATE then A2.PPDATE ELSE RCOVER.EDATE end) as float)
		/
		Cast(datediff(day,RCOVER.SDATE, RCOVER.EDATE) as float)
	)
	* RCalc.Prorata
	end as PPRORATA,     
Case 
WHEN TOI.ADJMETHOD='OVERLIMIT' then ''
WHEN 
	(
		Case 
		When A1.CPCT<>0 then A1.CPCT 
		else 100 
		end
	)=100
THEN
	CASE
	WHEN	
		(
		Cast(datediff(day, case when RCOVER.SDATE<A2.PDATE then A2.PDATE Else RCOVER.SDATE end, Case When RCOVER.EDATE>A2.PPDATE then A2.PPDATE ELSE RCOVER.EDATE end) as float)
		/
		Cast(datediff(day,RCOVER.SDATE, RCOVER.EDATE) as float)
		)=1
	Then 
		ICALC.SPRORATA
	ELSE
		CASE 
		WHEN ICALC.SPRORATA<>'' THEN ICALC.SPRORATA + ' x '
		ELSE ''
		END
		+ convert(varchar(25), Cast(datediff(day, case when RCOVER.SDATE<A2.PDATE then A2.PDATE Else RCOVER.SDATE end, Case When RCOVER.EDATE>A2.PPDATE then A2.PPDATE ELSE RCOVER.EDATE end) as int),1) 
		+ '/'
		+ convert(varchar(25), Cast(datediff(day,RCOVER.SDATE, RCOVER.EDATE) as int),1) 
	END
ELSE 
	''
end AS SPRORATA,
ICOVER.CURRENCY,     
ICOVER.SI,     
(Select sum(DDiscount) from AccDed Where ANO=ICover.ANO and (Currency='' or Currency=ICover.Currency) and TOR=RateCov.TOR) as DDISCOUNT,  
ICOVER.Adjustable,     
ICOVER.PCTADJ,     
TOI.ADJMETHOD,     
ICOVER.INO,     
A2.ANO AS SANO,     
PolicyType.SType     
FROM  ACCEPTANCE A1  
INNER JOIN ACCEPTANCE A2 ON (A2.OANO=A1.OANO and A2.ANO<=A1.PANO and A2.ANO<@P_ANO and A2.AType not in ('A','C'))  
INNER JOIN COVER ON (COVER.CNO=A1.CNO)  
Left Join PolicyType on (PolicyType.PolicyType=Cover.PolicyType)  
INNER JOIN ICOVER ON (ICOVER.ANO=A1.ANO AND ICOVER.ADJUSTABLE=1)  
INNER JOIN RCOVER ON (RCOVER.ANO=A2.ANO)  
INNER JOIN RATECOV ON (RATECOV.CODE=RCOVER.CODE)  
INNER JOIN RCLASS ON (RCLASS.TOC=A1.TOC AND RCLASS.TOR=RATECOV.TOR)  
INNER JOIN PCLASS ON (PCLASS.TOR=RATECOV.TOR AND PCLASS.TOI=ICOVER.TOI)  
INNER JOIN TOI ON (TOI.TOI=ICOVER.TOI)  
INNER JOIN RCALC ON (RCalc.ANO=A2.ANO and RCalc.Currency=ICover.Currency and RCalc.Code=RCover.Code and RCalc.TOR=RateCov.TOR and RCalc.SDate=RCover.SDate)  
CROSS APPLY (
	SELECT TOP 1 ICALC.SPRORATA
	FROM ICALC WHERE ICALC.ANO=RCALC.ANO AND ICALC.CURRENCY=RCALC.CURRENCY AND ICALC.CODE=RCALC.CODE AND ICALC.TOR=RCALC.TOR AND ICALC.SDATE=RCALC.SDATE AND ICALC.SANO=RCALC.SANO
) ICALC
Where A1.ANO=@P_ANO AND A1.PDate <= A2.PDate And A1.PPDate >= A2.PPDate And A2.PDate <= A2.PPDate     
and NOT EXISTS (Select PANO from Acceptance A3 Where A3.PANO=A2.ANO and A3.AStatus<>'C' and A3.AType='A' and A3.ANO<>@P_ANO)     
and A2.AdjustableF=1  
and (TOI.ADJMETHOD<>'OVERLIMIT' or A2.ANO=A1.PANO)     
and datediff(day, case when RCOVER.SDATE<A2.PDATE then A2.PDATE Else RCOVER.SDATE end, Case When RCOVER.EDATE>A2.PPDATE then A2.PPDATE ELSE RCOVER.EDATE end)>0  
ORDER BY ICOVER.CURRENCY, RCOVER.CODE, RATECOV.TOR, RCOVER.SDATE, A2.ANO

GO

insert into PatchVersioning
select '1375 Update Script - Patch 2025 (29)',GETDATE()
go	
  
Declare @PrevScript varchar(100)
Declare @CurrScript varchar(100)

Select @PrevScript=''
Select @CurrSCript='1375 Update Script - Patch 2025 (29)'


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
