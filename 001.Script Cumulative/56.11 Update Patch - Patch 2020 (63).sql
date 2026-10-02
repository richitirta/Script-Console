
insert into PatchVersioning
select '56.11 Update Patch - Patch 2020 (63)',GETDATE()
go

Declare @PrevScript varchar(100)
Declare @CurrScript varchar(100)

Select @PrevScript='56.10 Update Patch - Patch 2020 (60)'
Select @CurrSCript='56.11 Update Patch - Patch 2020 (63)'


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
			DROP Procedure QPolicy_Rate
       END TRY  
       BEGIN CATCH  
       END CATCH;


       Update SysTab Set ExecScript=@CurrScript, ExecScriptStatus='DONE'         
End


GO
CREATE Procedure QPolicy_Rate(@P_ANO as int)     
as     
Select ICALC.Code, ICALC.SDate, SUM(ICALC.TSI) as TSI, Max(ICALC.PrevMinRate) as PrevMinRate, Max(ICALC.PrevMaxRate) as PrevMaxRate, Max(ICALC.MinRate) as MinRate, Max(ICALC.MaxRate) as MaxRate     
from     
(     
Select ICALC.Code, ICALC.SDate,     
MAX(ICALC.TSI*(CASE WHEN RCOVER.PCTLOSS=0 THEN 100 ELSE RCOVER.PCTLOSS END)/(CASE WHEN RCOVER.PCTLOSS=0 THEN 100 ELSE RCOVER.PCTLOSS END+RCOVER.PAddition)) as TSI,     
CAST(0 as FLOAT) as PREVMINRATE,     
CAST(0 as FLOAT) as PREVMAXRATE,     
SUM(ICALC.GROSS*100/(100-RCover.Discount)/ICALC.TSI/(Case When RCOVER.LOADING=0 THEN 1 ELSE RCOVER.LOADING END)*Case When ICalc.PCTADJ<>0 Then cast(100 as Float)/ICALC.PCTADJ else 1 end
*Case When RCover.PCalc='F' and Cover.Voyage=0 then 
(
	Case When Acceptance.EXCLUSIVEF=0 and Acceptance.STime<Acceptance.ETime and ICalc.EDate=Acceptance.EDate Then
		1/dbo.fn_Premium_calc_prorata(ICalc.sDate, dateadd(day,1,ICalc.edate), datediff(day,ICalc.SDate,dateadd(month,(Case When TOC.PTerm=0 Then 12 else TOC.PTerm End),ICalc.sDate)), (Case When TOC.PTerm=0 Then 12 else TOC.PTerm End), Cover.PPeriod)
	else
		1/dbo.fn_Premium_calc_prorata(ICalc.sDate, ICalc.EDate, datediff(day,ICalc.SDate,dateadd(month,(Case When TOC.PTerm=0 Then 12 else TOC.PTerm End),ICalc.sDate)), (Case When TOC.PTerm=0 Then 12 else TOC.PTerm End), Cover.PPeriod)
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
		1/ICALC.Prorata 
	end
) 
end
)*100+0.0000000001 as MINRATE,     

SUM(ICALC.GROSS*100/(100-RCover.Discount)/ICALC.TSI/(Case When RCOVER.LOADING=0 THEN 1 ELSE RCOVER.LOADING END)*Case When ICalc.PCTADJ<>0 Then cast(100 as Float)/ICALC.PCTADJ else 1 end
*Case When RCover.PCalc='F' and Cover.Voyage=0 then 
(
	Case When Acceptance.EXCLUSIVEF=0 and Acceptance.STime<Acceptance.ETime and ICalc.EDate=Acceptance.EDate Then
		1/dbo.fn_Premium_calc_prorata(ICalc.sDate, dateadd(day,1,ICalc.edate), datediff(day,ICalc.SDate,dateadd(month,(Case When TOC.PTerm=0 Then 12 else TOC.PTerm End),ICalc.sDate)), (Case When TOC.PTerm=0 Then 12 else TOC.PTerm End), Cover.PPeriod)
	else
		1/dbo.fn_Premium_calc_prorata(ICalc.sDate, ICalc.EDate, datediff(day,ICalc.SDate,dateadd(month,(Case When TOC.PTerm=0 Then 12 else TOC.PTerm End),ICalc.sDate)), (Case When TOC.PTerm=0 Then 12 else TOC.PTerm End), Cover.PPeriod)
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
		1/ICALC.Prorata 
	end
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
*Case When RCover.PCalc='F' and Cover.Voyage=0 then 
(
	Case When Acceptance.EXCLUSIVEF=0 and Acceptance.STime<Acceptance.ETime and ICalc.EDate=Acceptance.EDate Then
		1/dbo.fn_Premium_calc_prorata(ICalc.sDate, dateadd(day,1,ICalc.edate), datediff(day,ICalc.SDate,dateadd(month,(Case When TOC.PTerm=0 Then 12 else TOC.PTerm End),ICalc.sDate)), (Case When TOC.PTerm=0 Then 12 else TOC.PTerm End), Cover.PPeriod)
	else
		1/dbo.fn_Premium_calc_prorata(ICalc.sDate, ICalc.EDate, datediff(day,ICalc.SDate,dateadd(month,(Case When TOC.PTerm=0 Then 12 else TOC.PTerm End),ICalc.sDate)), (Case When TOC.PTerm=0 Then 12 else TOC.PTerm End), Cover.PPeriod)
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
		1/ICALC.Prorata 
	end
) 
end
)*100+0.0000000001 as PREVMINRATE,     

SUM(ICALC.GROSS*100/(100-RCover.Discount)/ICALC.TSI/(Case When RCOVER.LOADING=0 THEN 1 ELSE RCOVER.LOADING END)*Case When ICalc.PCTADJ<>0 Then cast(100 as Float)/ICALC.PCTADJ else 1 end
*Case When RCover.PCalc='F' and Cover.Voyage=0 then 
(
	Case When Acceptance.EXCLUSIVEF=0 and Acceptance.STime<Acceptance.ETime and ICalc.EDate=Acceptance.EDate Then
		1/dbo.fn_Premium_calc_prorata(ICalc.sDate, dateadd(day,1,ICalc.edate), datediff(day,ICalc.SDate,dateadd(month,(Case When TOC.PTerm=0 Then 12 else TOC.PTerm End),ICalc.sDate)), (Case When TOC.PTerm=0 Then 12 else TOC.PTerm End), Cover.PPeriod)
	else
		1/dbo.fn_Premium_calc_prorata(ICalc.sDate, ICalc.EDate, datediff(day,ICalc.SDate,dateadd(month,(Case When TOC.PTerm=0 Then 12 else TOC.PTerm End),ICalc.sDate)), (Case When TOC.PTerm=0 Then 12 else TOC.PTerm End), Cover.PPeriod)
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
		1/ICALC.Prorata 
	end
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




