IF EXISTS ( SELECT * FROM   sysobjects WHERE  id = object_id(N'[dbo].[QCLACC01_1]') and OBJECTPROPERTY(id, N'IsProcedure') = 1 )
begin
DROP Procedure QCLACC01_1
end
GO
CREATE PROCEDURE QCLACC01_1 (@PCNO AS INTEGER, @PTOI AS Nvarchar(10))        
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
WHERE CLAIM.CNO=@PCNO AND ICOVER.ANO=CLAIM.ANO AND RCOVER.ANO=CLAIM.ANO AND ACCEPTANCE.ANO=CLAIM.ANO          
AND ICALC.ANO=CLAIM.ANO AND ICOVER.INO=ICALC.INO AND RCOVER.CODE=ICALC.CODE          
AND (RCover.RetroActiveF=1 or (RCOVER.SDATE<=CLAIM.LOSSDATE AND ACCEPTANCE.ExclusiveF=1) or ((RCOVER.SDATE<CLAIM.LOSSDATE or (RCOVER.SDATE=CLAIM.LOSSDATE AND ACCEPTANCE.STIME<=Claim.LossTime)) AND ACCEPTANCE.ExclusiveF=0))         
AND ((dbo.fn_Get_ExtPeriodDate(ACCEPTANCE.ExtRPeriod, 0, dbo.fn_Get_ExtPeriodDate(ACCEPTANCE.ExtPeriod, ACCEPTANCE.ExtPeriodInDaysF, RCOVER.EDATE))>CLAIM.LOSSDATE AND ACCEPTANCE.ExclusiveF=1) or ((dbo.fn_Get_ExtPeriodDate(ACCEPTANCE.ExtRPeriod, 0, dbo.fn_Get_ExtPeriodDate(ACCEPTANCE.ExtPeriod, ACCEPTANCE.ExtPeriodInDaysF, RCOVER.EDATE))>CLAIM.LOSSDATE or (dbo.fn_Get_ExtPeriodDate(ACCEPTANCE.ExtPeriod, ACCEPTANCE.ExtPeriodInDaysF, RCOVER.EDATE)=CLAIM.LOSSDATE AND ACCEPTANCE.ETIME>Claim.LossTime)) AND ACCEPTANCE.ExclusiveF=0))        
AND COL.COL=CLAIM.COL AND ICALC.TOR=COL.TOR AND TOI.TOI=ICOVER.TOI AND COL.AllowedF=1  
AND ICOVER.TOI=@PTOI  
  

GO