
insert into PatchVersioning
select '57.9 Update Patch - Patch 2020 (78)',GETDATE()
go

Declare @PrevScript varchar(100)
Declare @CurrScript varchar(100)

Select @PrevScript='57.8 Update Script - Functions (Execute After 2020 v.1.2)'
Select @CurrSCript='57.9 Update Patch - Patch 2020 (78)'


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
			DROP Function FL_CL_COLTAB
			DROP PROCEDURE QAcceptance_Col
			DROP Function FL_CL_TOI
			DROP PROCEDURE QCLACC01 
       END TRY  
       BEGIN CATCH  
       END CATCH;


       Update SysTab Set ExecScript=@CurrScript, ExecScriptStatus='DONE'         
End


GO
Create Function FL_CL_COLTAB(@P_COL as varchar(10), @P_PolicyNo as varchar(50), @P_CERTIFICATENO AS varchar(20))    
Returns Table  
As Return  
(  
SELECT Distinct COLTAB.COL, COLTAB.description    
From Acceptance, RCALC, COL, COLTAB    
WHERE ACCEPTANCE.ANO=RCalc.ANO And RCalc.TOR=COL.TOR AND COLTAB.COL=COL.COL AND    
ACCEPTANCE.POLICYNO=@P_POLICYNO And ACCEPTANCE.CERTIFICATENO=@P_CERTIFICATENO And COL.COL LIKE @P_COL+'%' AND COL.ALLOWEDF=1
)

GO


GO
CREATE PROCEDURE QAcceptance_Col(@P_COL as varchar(10), @P_PolicyNo as varchar(50), @P_CERTIFICATENO AS varchar(20))
AS
SELECT DISTINCT TOP 50 COLTAB.COL, COLTAB.description
From acceptance, RCALC, Col, COLTAB
WHERE ACCEPTANCE.POLICYNO LIKE @P_POLICYNO And ACCEPTANCE.CERTIFICATENO LIKE @P_CERTIFICATENO And ACCEPTANCE.ANO=RCalc.ANO 
And RCalc.TOR=COL.TOR AND COL.COL LIKE @P_COL AND COLTAB.COL=COL.COL AND COL.ALLOWEDF=1

GO


GO
Create Function FL_CL_TOI(@PCNO As Integer)    
Returns Table    
As Return    
(    
SELECT Distinct cast(ICOVER.REMARK as varchar(255)) AS REMARK, ICOVER.CURRENCY,        
CASE        
 WHEN CLAIM.EVENTNO=-1 THEN        
        CASE        
        WHEN ICOVER.NOTDECRF=1 OR RCOVER.PCTLOSS=0 THEN ICOVER.AMOUNT*coalesce(P.InstSIPCT,100)/100 * (100+(dbo.fn_Get_UWYear(Acceptance.Sdate, Acceptance.Edate, Claim.LossDate)-Year(Acceptance.SDate))*RCover.PCTEscalation)/100 
        ELSE ICOVER.AMOUNT*coalesce(P.InstSIPCT,100)/100*RCOVER.PCTLOSS/100 * (100+(dbo.fn_Get_UWYear(Acceptance.Sdate, Acceptance.Edate, Claim.LossDate)-Year(Acceptance.SDate))*RCover.PCTEscalation)/100 
		END        
 Else        
        CASE        
        WHEN ICOVER.NOTDECRF=1 OR RCOVER.PCTLOSS=0 THEN ICOVER.AMOUNT_AOE*coalesce(P.InstSIPCT,100)/100 * (100+(dbo.fn_Get_UWYear(Acceptance.Sdate, Acceptance.Edate, Claim.LossDate)-Year(Acceptance.SDate))*RCover.PCTEscalation)/100 
        ELSE ICOVER.AMOUNT_AOE*coalesce(P.InstSIPCT,100)/100*RCOVER.PCTLOSS/100 * (100+(dbo.fn_Get_UWYear(Acceptance.Sdate, Acceptance.Edate, Claim.LossDate)-Year(Acceptance.SDate))*RCover.PCTEscalation)/100 
		END        
 END AS SI, ICOVER.INO, ICOVER.TOI, ICOVER.TOTAL, ICOVER.INDEMNITY, ICOVER.ESTIMATE, TOI.AGREEDVALF, ICOVER.CURRENCY_OC, ICOVER.RATE_OC       
From ICOVER, Col, ICALC, RCOVER, TOI, CLAIM 
Inner Join ACCEPTANCE ON (ACCEPTANCE.ANO=Claim.ANO)
Left Join Payor_Schedule P on (P.ANO=Acceptance.ANO and P.InstDate<=Claim.LossDate and (P.InstLDate>Claim.LossDate or (P.InstLDate=Claim.LossDate and P.InstLDate=Acceptance.EDate)))        
WHERE CLAIM.CNO=@PCNO AND ICOVER.ANO=CLAIM.ANO AND RCOVER.ANO=CLAIM.ANO AND ACCEPTANCE.ANO=CLAIM.ANO        
AND ICALC.ANO=CLAIM.ANO AND ICOVER.INO=ICALC.INO AND RCOVER.CODE=ICALC.CODE        
AND (RCover.RetroActiveF=1 or (RCOVER.SDATE<=CLAIM.LOSSDATE AND ACCEPTANCE.ExclusiveF=1) or ((RCOVER.SDATE<CLAIM.LOSSDATE or (RCOVER.SDATE=CLAIM.LOSSDATE AND ACCEPTANCE.STIME<=Claim.LossTime)) AND ACCEPTANCE.ExclusiveF=0))       
AND ((dbo.fn_Get_ExtPeriodDate(ACCEPTANCE.ExtRPeriod, 0, dbo.fn_Get_ExtPeriodDate(ACCEPTANCE.ExtPeriod, ACCEPTANCE.ExtPeriodInDaysF, RCOVER.EDATE))>CLAIM.LOSSDATE AND ACCEPTANCE.ExclusiveF=1) or ((dbo.fn_Get_ExtPeriodDate(ACCEPTANCE.ExtRPeriod, 0, dbo.fn_Get_ExtPeriodDate(ACCEPTANCE.ExtPeriod, ACCEPTANCE.ExtPeriodInDaysF, RCOVER.EDATE))>CLAIM.LOSSDATE or (dbo.fn_Get_ExtPeriodDate(ACCEPTANCE.ExtPeriod, ACCEPTANCE.ExtPeriodInDaysF, RCOVER.EDATE)=CLAIM.LOSSDATE AND ACCEPTANCE.ETIME>Claim.LossTime)) AND ACCEPTANCE.ExclusiveF=0))      
AND COL.COL=CLAIM.COL AND ICALC.TOR=COL.TOR AND TOI.TOI=ICOVER.TOI AND COL.AllowedF=1
)   


GO


GO
CREATE PROCEDURE QCLACC01 (@PCNO AS INTEGER,@PINO AS INTEGER=0)        
AS        
SELECT Distinct cast(ICOVER.REMARK as varchar(255)) AS REMARK, ICOVER.CURRENCY,        
CASE        
 WHEN CLAIM.EVENTNO=-1 THEN        
        CASE        
        WHEN ICOVER.NOTDECRF=1 OR RCOVER.PCTLOSS=0 THEN ICOVER.AMOUNT*coalesce(P.InstSIPCT,100)/100 * (100+(dbo.fn_Get_UWYear(Acceptance.Sdate, Acceptance.Edate, Claim.LossDate)-Year(Acceptance.SDate))*RCover.PCTEscalation)/100
        ELSE ICOVER.AMOUNT*coalesce(P.InstSIPCT,100)/100*RCOVER.PCTLOSS/100 * (100+(dbo.fn_Get_UWYear(Acceptance.Sdate, Acceptance.Edate, Claim.LossDate)-Year(Acceptance.SDate))*RCover.PCTEscalation)/100 
		END        
 Else        
        CASE        
        WHEN ICOVER.NOTDECRF=1 OR RCOVER.PCTLOSS=0 THEN ICOVER.AMOUNT_AOE*coalesce(P.InstSIPCT,100)/100 * (100+(dbo.fn_Get_UWYear(Acceptance.Sdate, Acceptance.Edate, Claim.LossDate)-Year(Acceptance.SDate))*RCover.PCTEscalation)/100
        ELSE ICOVER.AMOUNT_AOE*coalesce(P.InstSIPCT,100)/100*RCOVER.PCTLOSS/100 * (100+(dbo.fn_Get_UWYear(Acceptance.Sdate, Acceptance.Edate, Claim.LossDate)-Year(Acceptance.SDate))*RCover.PCTEscalation)/100 
		END        
 END AS SI, ICOVER.INO, ICOVER.TOI, ICOVER.TOTAL, ICOVER.INDEMNITY, ICOVER.ESTIMATE, TOI.AGREEDVALF, ICOVER.CURRENCY_OC, ICOVER.RATE_OC       
From ICOVER, Col, ICALC, RCOVER, TOI, CLAIM 
Inner Join ACCEPTANCE ON (ACCEPTANCE.ANO=Claim.ANO)
Left Join Payor_Schedule P on (P.ANO=Acceptance.ANO and P.InstDate<=Claim.LossDate and (P.InstLDate>Claim.LossDate or (P.InstLDate=Claim.LossDate and P.InstLDate=Acceptance.EDate)))        
WHERE CLAIM.CNO=@PCNO AND ICOVER.ANO=CLAIM.ANO AND (@PINO=0 or ICOVER.INO=@PINO) AND RCOVER.ANO=CLAIM.ANO AND ACCEPTANCE.ANO=CLAIM.ANO        
AND ICALC.ANO=CLAIM.ANO AND ICOVER.INO=ICALC.INO AND RCOVER.CODE=ICALC.CODE        
AND (RCover.RetroActiveF=1 or (RCOVER.SDATE<=CLAIM.LOSSDATE AND ACCEPTANCE.ExclusiveF=1) or ((RCOVER.SDATE<CLAIM.LOSSDATE or (RCOVER.SDATE=CLAIM.LOSSDATE AND ACCEPTANCE.STIME<=Claim.LossTime)) AND ACCEPTANCE.ExclusiveF=0))       
AND ((dbo.fn_Get_ExtPeriodDate(ACCEPTANCE.ExtRPeriod, 0, dbo.fn_Get_ExtPeriodDate(ACCEPTANCE.ExtPeriod, ACCEPTANCE.ExtPeriodInDaysF, RCOVER.EDATE))>CLAIM.LOSSDATE AND ACCEPTANCE.ExclusiveF=1) or ((dbo.fn_Get_ExtPeriodDate(ACCEPTANCE.ExtRPeriod, 0, dbo.fn_Get_ExtPeriodDate(ACCEPTANCE.ExtPeriod, ACCEPTANCE.ExtPeriodInDaysF, RCOVER.EDATE))>CLAIM.LOSSDATE or (dbo.fn_Get_ExtPeriodDate(ACCEPTANCE.ExtPeriod, ACCEPTANCE.ExtPeriodInDaysF, RCOVER.EDATE)=CLAIM.LOSSDATE AND ACCEPTANCE.ETIME>Claim.LossTime)) AND ACCEPTANCE.ExclusiveF=0))      
AND COL.COL=CLAIM.COL AND ICALC.TOR=COL.TOR AND TOI.TOI=ICOVER.TOI AND COL.AllowedF=1

GO





