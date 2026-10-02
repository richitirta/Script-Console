
insert into PatchVersioning
select '57.03 Update Patch - Patch 2020 (64)  (Execute after 2020 v.1.2 Claim Accumulation)',GETDATE()
go

Declare @PrevScript varchar(100)
Declare @CurrScript varchar(100)

Select @PrevScript='57.02 Update Patch - Patch 2020 (62)'
Select @CurrSCript='57.03 Update Patch - Patch 2020 (64)  (Execute after 2020 v.1.2 Claim Accumulation)'


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
			
		DROP PROCEDURE QCHECKDECLAREDVALUE 
		DROP PROCEDURE QCLNOC
		DROP procedure QInConsistent_LossItem
		DROP Function FL_CL_NOC 
		DROP Function FL_GetPolicyNOC 
		DROP FUNCTION ICPS_PolicyInterestLimit
       END TRY  
       BEGIN CATCH  
       END CATCH;


       Update SysTab Set ExecScript=@CurrScript, ExecScriptStatus='DONE'         
End

GO
CREATE PROCEDURE QCHECKDECLAREDVALUE (@PCNO AS INTEGER)   
AS
Select *
from
(
Select 
SUM(CLLOSS.Estimate/CLLOSS.Rate) as Estimate, 
SUM(CLLOSS.Amount/CLLOSS.Rate) as Amount, 
MAX(Case When ICOVER.AMOUNT<>0 and ICOVER.AMOUNT_AOE<>0 THEN CLLOSS.DECLARED*ICOVER.AMOUNT_AOE/ICOVER.AMOUNT ELSE CLLOSS.DECLARED END) as DECLARED,
MAX(ICOVER.AMOUNT) as LOL
from CLLOSS 
INNER JOIN CLAIM ON (CLAIM.CNO=CLLOSS.CNO)
INNER JOIN ACCEPTANCE ON (ACCEPTANCE.ANO=CLAIM.ANO)
INNER JOIN NOCTAB ON (NOCTAB.NOC=CLLOSS.NOC) 
INNER JOIN ICOVER ON (ICOVER.INO=CLLOSS.INO)
LEFT JOIN ICOVERNOC ON ((ICoverNOC.PCT<>0 or ICoverNOC.Amount<>0) And ICOVERNOC.INO=CLLOSS.INO and ICOVERNOC.NOC=CLLOSS.NOC
AND ((Select Top 1 RCover.RetroActiveF from RCover Where RCover.ANO=Acceptance.ANO Order by RCover.RetroActiveF Desc)=1 or (ICOVERNOC.SDATE<=CLAIM.LossDate AND ACCEPTANCE.ExclusiveF=1) or ((ICOVERNOC.SDATE<CLAIM.LossDate or (ICOVERNOC.SDATE=CLAIM.LossDate AND ACCEPTANCE.STIME<=CLAIM.LossTime)) AND ACCEPTANCE.ExclusiveF=0))                     
AND ((dbo.fn_Get_ExtPeriodDate(ACCEPTANCE.ExtRPeriod, 0, dbo.fn_Get_ExtPeriodDate(ACCEPTANCE.ExtPeriod, ACCEPTANCE.ExtPeriodInDaysF, ICOVERNOC.EDATE))>CLAIM.LossDate AND ACCEPTANCE.ExclusiveF=1) or ((dbo.fn_Get_ExtPeriodDate(ACCEPTANCE.ExtRPeriod, 0, dbo.fn_Get_ExtPeriodDate(ACCEPTANCE.ExtPeriod, ACCEPTANCE.ExtPeriodInDaysF, ICOVERNOC.EDATE))>CLAIM.LossDate or (dbo.fn_Get_ExtPeriodDate(ACCEPTANCE.ExtRPeriod, 0, dbo.fn_Get_ExtPeriodDate(ACCEPTANCE.ExtPeriod, ACCEPTANCE.ExtPeriodInDaysF, ICOVERNOC.EDATE))=CLAIM.LossDate AND ACCEPTANCE.ETIME>CLAIM.LossTime)) AND ACCEPTANCE.ExclusiveF=0))                              
) 
Where CLLOSS.Declared>1 and CLLoss.CNO=@PCNO and (NOCTAB.SubLimitF=0 or coalesce(ICoverNOC.NOC,'')<>'') 
Group by CLLOSS.CNO, CLLOSS.INO, coalesce(ICoverNOC.NOC,'') 
) C
WHere Estimate>Declared or Amount>declared or Estimate>LOL or Amount>LOL


GO

GO
CREATE PROCEDURE QCLNOC (@P_CNO as Integer, @P_INO AS INTEGER, @P_NOC AS VARCHAR(255))                        
AS                        
Declare @P_LossDate as smalldatetime      
Declare @P_LossTime as varchar(5)      
Declare @P_EventNo as int      
Declare @P_COL as varchar(10)      
Declare @P_Value as float      
      
Select @P_LossDate=LossDate, @P_LossTime=LossTime, @P_EventNo=EventNo, @P_Col=COL from Claim Where CNO=@P_CNO      
Select @P_Value=Value from fn_ObjectValuation(@P_INO, @P_LOSSDATE)    
if @P_Value is null     
 Select @P_Value=0    
                      
Select Distinct NOC.NOC, ICOVERNOC.DESCRIPTION, NOC.CTLF, 
ICOVERNOC.CURRENCY, 

CASE 
WHEN ICOVERNOC.AMOUNT<>0 AND ICOVERNOC.PCT/100*ICOVER.AMOUNT*coalesce(P.InstSIPCT,100)/100<>0 THEN
	CASE WHEN ICOVERNOC.AMOUNT>ICOVERNOC.PCT/100*ICOVER.AMOUNT*coalesce(P.InstSIPCT,100)/100 THEN ICOVERNOC.PCT/100*ICOVER.AMOUNT*coalesce(P.InstSIPCT,100)/100 ELSE ICOVERNOC.AMOUNT END
WHEN ICOVERNOC.AMOUNT<>0 THEN ICOVERNOC.AMOUNT
ELSE ICOVERNOC.PCT/100*ICOVER.AMOUNT*coalesce(P.InstSIPCT,100)/100
END*(CASE WHEN ICOVERNOC.MAXQTY=0 THEN 1 ELSE ICOVERNOC.MAXQTY END) AS AMOUNT_1,
Cast(0 as Float) as AMOUNT_2, 
CASE 
WHEN ICOVERNOC.LIMIT=0 THEN
	CASE 
	WHEN ICOVERNOC.AMOUNT<>0 AND ICOVERNOC.PCT/100*ICOVER.AMOUNT*coalesce(P.InstSIPCT,100)/100<>0 THEN
		CASE WHEN ICOVERNOC.AMOUNT>ICOVERNOC.PCT/100*ICOVER.AMOUNT*coalesce(P.InstSIPCT,100)/100 THEN ICOVERNOC.PCT/100*ICOVER.AMOUNT*coalesce(P.InstSIPCT,100)/100 ELSE ICOVERNOC.AMOUNT END
	WHEN ICOVERNOC.AMOUNT<>0 THEN ICOVERNOC.AMOUNT
	ELSE ICOVERNOC.PCT/100*ICOVER.AMOUNT*coalesce(P.InstSIPCT,100)/100
	END*(CASE WHEN ICOVERNOC.MAXQTY=0 THEN 1 ELSE ICOVERNOC.MAXQTY END) 
ELSE
	ICOVERNOC.LIMIT
END AS LIMIT,
ICOVERNOC.INDEMNITY, ICOVERNOC.ESTIMATE                  
from ICOVER, ICOVERNOC, NOC, ACCEPTANCE Left Join Payor_Schedule P on (P.ANO=Acceptance.ANO and P.InstDate<=@P_LossDate and (P.InstLDate>@P_LossDate or (P.InstLDate=@P_LossDate and P.InstLDate=Acceptance.EDate)))        
Where ICOVERNOC.INO=ICOVER.INO AND NOC.NOC=ICOVERNOC.NOC AND NOC.TOI=ICOVER.TOI AND ICOVER.INO=@P_INO AND NOC.NOC LIKE @P_NOC                        
AND ACCEPTANCE.ANO=ICOVER.ANO  
AND ((Select Top 1 RCover.RetroActiveF from RCover Where RCover.ANO=Acceptance.ANO Order by RCover.RetroActiveF Desc)=1 or (ICOVERNOC.SDATE<=@P_LOSSDATE AND ACCEPTANCE.ExclusiveF=1) or ((ICOVERNOC.SDATE<@P_LOSSDATE or (ICOVERNOC.SDATE=@P_LOSSDATE AND ACCEPTANCE.STIME<=@P_LOSSTIME)) AND ACCEPTANCE.ExclusiveF=0))                     
AND ((dbo.fn_Get_ExtPeriodDate(ACCEPTANCE.ExtRPeriod, 0, dbo.fn_Get_ExtPeriodDate(ACCEPTANCE.ExtPeriod, ACCEPTANCE.ExtPeriodInDaysF, ICOVERNOC.EDATE))>@P_LOSSDATE AND ACCEPTANCE.ExclusiveF=1) or ((dbo.fn_Get_ExtPeriodDate(ACCEPTANCE.ExtRPeriod, 0, dbo.fn_Get_ExtPeriodDate(ACCEPTANCE.ExtPeriod, ACCEPTANCE.ExtPeriodInDaysF, ICOVERNOC.EDATE))>@P_LOSSDATE or (dbo.fn_Get_ExtPeriodDate(ACCEPTANCE.ExtRPeriod, 0, dbo.fn_Get_ExtPeriodDate(ACCEPTANCE.ExtPeriod, ACCEPTANCE.ExtPeriodInDaysF, ICOVERNOC.EDATE))=@P_LOSSDATE AND ACCEPTANCE.ETIME>@P_LOSSTIME)) AND ACCEPTANCE.ExclusiveF=0))                              
          
Union All                        
                                                    
Select Distinct NOC.NOC, NOC.DESCRIPTION, NOC.CTLF, ICOVER.CURRENCY,                      
CASE                        
 WHEN @P_EVENTNO=-1 THEN                        
        CASE                        
        WHEN RCOVER.PCTLOSS=0 OR ICOVER.NOTDECRF=1 OR ICOVER.NOTFLF=1 THEN ICOVER.AMOUNT*coalesce(P.InstSIPCT,100)/100 * (100+(dbo.fn_Get_UWYear(Acceptance.Sdate, Acceptance.Edate, @P_LossDate)-Year(Acceptance.SDate))*RCover.PCTEscalation)/100
        ELSE ICOVER.AMOUNT*coalesce(P.InstSIPCT,100)/100*RCOVER.PCTLOSS/100 * (100+(dbo.fn_Get_UWYear(Acceptance.Sdate, Acceptance.Edate, @P_LossDate)-Year(Acceptance.SDate))*RCover.PCTEscalation)/100 
		END        
 Else                        
        CASE                        
        WHEN RCOVER.PCTLOSS=0 OR ICOVER.NOTDECRF=1 OR ICOVER.NOTFLF=1 THEN ICOVER.AMOUNT_AOE*coalesce(P.InstSIPCT,100)/100 * (100+(dbo.fn_Get_UWYear(Acceptance.Sdate, Acceptance.Edate, @P_LossDate)-Year(Acceptance.SDate))*RCover.PCTEscalation)/100
        ELSE ICOVER.AMOUNT_AOE*coalesce(P.InstSIPCT,100)/100*RCOVER.PCTLOSS/100 * (100+(dbo.fn_Get_UWYear(Acceptance.Sdate, Acceptance.Edate, @P_LossDate)-Year(Acceptance.SDate))*RCover.PCTEscalation)/100 
		END        
 END AS AMOUNT_1,                        
CASE                        
 WHEN @P_EVENTNO=-1 THEN                        
        @P_VALUE
 Else                        
        0
 END AS AMOUNT_2,                           
 0 as Limit,       
 0 as Indemnity,
 0 as Estimate
From RCOVER, Col, RATECOV, PCLASS, ICOVER, NOC, COLNOCCLASS, ACCEPTANCE Left Join Payor_Schedule P on (P.ANO=Acceptance.ANO and P.InstDate<=@P_LossDate and (P.InstLDate>@P_LossDate or (P.InstLDate=@P_LossDate and P.InstLDate=Acceptance.EDate)))          
      
Where ICOVER.INO=@P_INO AND RCOVER.ANO=ICOVER.ANO AND ACCEPTANCE.ANO=RCOVER.ANO AND COL.COL=@P_COL      
AND (RCover.RetroActiveF=1 Or (RCOVER.SDATE<=@P_LOSSDATE AND ACCEPTANCE.ExclusiveF=1) or ((RCOVER.SDATE<@P_LOSSDATE or (RCOVER.SDATE=@P_LOSSDATE AND ACCEPTANCE.STIME<=@P_LOSSTIME)) AND ACCEPTANCE.ExclusiveF=0))                     
AND ((dbo.fn_Get_ExtPeriodDate(ACCEPTANCE.ExtRPeriod, 0, dbo.fn_Get_ExtPeriodDate(ACCEPTANCE.ExtPeriod, ACCEPTANCE.ExtPeriodInDaysF, RCOVER.EDATE))>@P_LOSSDATE AND ACCEPTANCE.ExclusiveF=1) or ((dbo.fn_Get_ExtPeriodDate(ACCEPTANCE.ExtRPeriod, 0, dbo.fn_Get_ExtPeriodDate(ACCEPTANCE.ExtPeriod, ACCEPTANCE.ExtPeriodInDaysF, RCOVER.EDATE))>@P_LOSSDATE or (dbo.fn_Get_ExtPeriodDate(ACCEPTANCE.ExtPeriod, ACCEPTANCE.ExtPeriodInDaysF, RCOVER.EDATE)=@P_LOSSDATE AND ACCEPTANCE.ETIME>@P_LOSSTIME)) AND ACCEPTANCE.ExclusiveF=0))                    
AND RATECOV.CODE=RCOVER.CODE AND RATECOV.TOR=COL.TOR AND PCLASS.TOR=COL.TOR AND PCLASS.TOI=ICOVER.TOI                        
AND NOC.TOI=ICOVER.TOI AND NOC.NOC LIKE @P_NOC                       
AND NOT EXISTS (SELECT TOP 1 ICOVERNOC.NOC FROM ICOVERNOC WHERE ICOVERNOC.INO=@P_INO AND ICOVERNOC.NOC=NOC.NOC)                        
AND COLNOCCLASS.NOC=NOC.NOC AND COLNOCCLASS.COL=@P_COL      
AND (PCLASS.CTLF=0 OR NOC.CTLF=PCLASS.CTLF)           
          
GO

GO
CREATE  procedure QInConsistent_LossItem(@P_CNO integer)     
as     
Declare @P_LossDate as smalldatetime        
Declare @P_LossTime as varchar(5)        
Declare @P_EventNo as int      
Declare @P_COL as varchar(10)       
Declare @P_ANO as int 
        
Select @P_LossDate=LossDate, @P_LossTime=LossTime, @P_EventNo=EventNo, @P_Col=COL, @P_ANO=ANO
from Claim Where CNO=@P_CNO        
                       
Select TOP 1 CLLOSS.INO,CLLOSS.NOC  
from CLLOSS Where CNO=@P_CNO And not Exists  
(  
Select ICOVER.INO,NOC.NOC  
From ICOVER WITH (INDEX(I_ICOVER)), ICOVERNOC, NOC, ACCEPTANCE Left Join Payor_Schedule P on (P.ANO=Acceptance.ANO and P.InstDate<=@P_LossDate and (P.InstLDate>@P_LossDate or (P.InstLDate=@P_LossDate and P.InstLDate=Acceptance.EDate))) 
Where ICOVER.INO=CLLOSS.INO AND ICOVERNOC.INO=ICOVER.INO AND NOC.NOC=ICOVERNOC.NOC AND NOC.TOI=ICOVER.TOI AND NOC.NOC=CLLOSS.NOC
AND ACCEPTANCE.ANO=ICOVER.ANO  
AND ((ICOVERNOC.SDATE<=@P_LOSSDATE AND ACCEPTANCE.ExclusiveF=1) or ((ICOVERNOC.SDATE<@P_LOSSDATE or (ICOVERNOC.SDATE=@P_LOSSDATE AND ACCEPTANCE.STIME<=@P_LOSSTIME)) AND ACCEPTANCE.ExclusiveF=0))                     
AND ((dbo.fn_Get_ExtPeriodDate(ACCEPTANCE.ExtRPeriod, 0, dbo.fn_Get_ExtPeriodDate(ACCEPTANCE.ExtPeriod, ACCEPTANCE.ExtPeriodInDaysF, ICOVERNOC.EDATE))>@P_LOSSDATE AND ACCEPTANCE.ExclusiveF=1) or ((dbo.fn_Get_ExtPeriodDate(ACCEPTANCE.ExtRPeriod, 0, dbo.fn_Get_ExtPeriodDate(ACCEPTANCE.ExtPeriod, ACCEPTANCE.ExtPeriodInDaysF, ICOVERNOC.EDATE))>@P_LOSSDATE or (dbo.fn_Get_ExtPeriodDate(ACCEPTANCE.ExtRPeriod, 0, dbo.fn_Get_ExtPeriodDate(ACCEPTANCE.ExtPeriod, ACCEPTANCE.ExtPeriodInDaysF, ICOVERNOC.EDATE))=@P_LOSSDATE AND ACCEPTANCE.ETIME>@P_LOSSTIME)) AND ACCEPTANCE.ExclusiveF=0))                              
AND
ABS(
CASE 
WHEN ICOVERNOC.AMOUNT<>0 AND ICOVERNOC.PCT/100*ICOVER.AMOUNT*coalesce(P.InstSIPCT,100)/100<>0 THEN
	CASE WHEN ICOVERNOC.AMOUNT>ICOVERNOC.PCT/100*ICOVER.AMOUNT*coalesce(P.InstSIPCT,100)/100 THEN ICOVERNOC.PCT/100*ICOVER.AMOUNT*coalesce(P.InstSIPCT,100)/100 ELSE ICOVERNOC.AMOUNT END
WHEN ICOVERNOC.AMOUNT<>0 THEN ICOVERNOC.AMOUNT
ELSE ICOVERNOC.PCT/100*ICOVER.AMOUNT*coalesce(P.InstSIPCT,100)/100
END*(CASE WHEN ICOVERNOC.MAXQTY=0 THEN 1 ELSE ICOVERNOC.MAXQTY END)-CLLOSS.DECLARED)<=1

UNION ALL  
    
Select ICOVER.INO, NOC.NOC  
From ICOVER WITH (INDEX(I_ICOVER)), RCOVER, Col, RATECOV, PCLASS, NOC, COLNOCCLASS, ACCEPTANCE Left Join Payor_Schedule P on (P.ANO=Acceptance.ANO and P.InstDate<=@P_LossDate and (P.InstLDate>@P_LossDate or (P.InstLDate=@P_LossDate and P.InstLDate=Acceptance.EDate)))
Where ICOVER.INO=CLLOSS.INO AND RCOVER.ANO=ICOVER.ANO AND ACCEPTANCE.ANO=RCOVER.ANO AND COL.COL=@P_COL      
AND ((RCOVER.SDATE<=@P_LOSSDATE AND ACCEPTANCE.ExclusiveF=1) or ((RCOVER.SDATE<@P_LOSSDATE or (RCOVER.SDATE=@P_LOSSDATE AND ACCEPTANCE.STIME<=@P_LOSSTIME)) AND ACCEPTANCE.ExclusiveF=0))                     
AND ((dbo.fn_Get_ExtPeriodDate(ACCEPTANCE.ExtRPeriod, 0, dbo.fn_Get_ExtPeriodDate(ACCEPTANCE.ExtPeriod, ACCEPTANCE.ExtPeriodInDaysF, RCOVER.EDATE))>@P_LOSSDATE AND ACCEPTANCE.ExclusiveF=1) or ((dbo.fn_Get_ExtPeriodDate(ACCEPTANCE.ExtRPeriod, 0, dbo.fn_Get_ExtPeriodDate(ACCEPTANCE.ExtPeriod, ACCEPTANCE.ExtPeriodInDaysF, RCOVER.EDATE))>@P_LOSSDATE or (dbo.fn_Get_ExtPeriodDate(ACCEPTANCE.ExtPeriod, ACCEPTANCE.ExtPeriodInDaysF, RCOVER.EDATE)=@P_LOSSDATE AND ACCEPTANCE.ETIME>@P_LOSSTIME)) AND ACCEPTANCE.ExclusiveF=0))                    
AND RATECOV.CODE=RCOVER.CODE AND RATECOV.TOR=COL.TOR AND PCLASS.TOR=COL.TOR AND PCLASS.TOI=ICOVER.TOI                        
AND NOC.TOI=ICOVER.TOI AND NOC.NOC=CLLOSS.NOC
AND NOT EXISTS (SELECT TOP 1 ICOVERNOC.NOC FROM ICOVERNOC WHERE ICOVERNOC.INO=CLLOSS.INO AND ICOVERNOC.NOC=NOC.NOC)                        
AND COLNOCCLASS.NOC=NOC.NOC AND COLNOCCLASS.COL=@P_COL
AND (PCLASS.CTLF=0 OR NOC.CTLF=PCLASS.CTLF)
AND
ABS(
CASE                        
 WHEN @P_EVENTNO=-1 THEN                        
        CASE                        
        WHEN RCOVER.PCTLOSS=0 OR ICOVER.NOTDECRF=1 OR ICOVER.NOTFLF=1 THEN ICOVER.AMOUNT*coalesce(P.InstSIPCT,100)/100 * (100+(dbo.fn_Get_UWYear(Acceptance.Sdate, Acceptance.Edate, @P_LossDate)-Year(Acceptance.SDate))*RCover.PCTEscalation)/100
        ELSE ICOVER.AMOUNT*coalesce(P.InstSIPCT,100)/100*RCOVER.PCTLOSS/100 * (100+(dbo.fn_Get_UWYear(Acceptance.Sdate, Acceptance.Edate, @P_LossDate)-Year(Acceptance.SDate))*RCover.PCTEscalation)/100 
		END        
 Else                        
        CASE                        
        WHEN RCOVER.PCTLOSS=0 OR ICOVER.NOTDECRF=1 OR ICOVER.NOTFLF=1 THEN ICOVER.AMOUNT_AOE*coalesce(P.InstSIPCT,100)/100 * (100+(dbo.fn_Get_UWYear(Acceptance.Sdate, Acceptance.Edate, @P_LossDate)-Year(Acceptance.SDate))*RCover.PCTEscalation)/100
        ELSE ICOVER.AMOUNT_AOE*coalesce(P.InstSIPCT,100)/100*RCOVER.PCTLOSS/100 * (100+(dbo.fn_Get_UWYear(Acceptance.Sdate, Acceptance.Edate, @P_LossDate)-Year(Acceptance.SDate))*RCover.PCTEscalation)/100 
		END        
 END-CLLOSS.DECLARED)<=1
)  
          
GO

GO
Create Function FL_CL_NOC (@P_CNO as Integer, @P_INO AS INTEGER, @P_NOC AS VARCHAR(255))              
RETURNS @CLNOC TABLE (NOC varchar(10), Description varchar(255), CTLF bit, Currency varchar(5), Amount_1 Float, Amount_2 Float, limit Float, Indemnity Float, Estimate Float)      
AS      
BEGIN          
Declare @P_LossDate as smalldatetime      
Declare @P_LossTime as varchar(5)      
Declare @P_EventNo as int      
Declare @P_COL as varchar(10)      
Declare @P_Value as float      
      
Select @P_LossDate=LossDate, @P_LossTime=LossTime, @P_EventNo=EventNo, @P_Col=COL from Claim Where CNO=@P_CNO      
Select @P_Value=Value from fn_ObjectValuation(@P_INO, @P_LOSSDATE)      
    
if @P_Value is null     
 Select @P_Value=0    
      
Insert into @CLNOC      
  
Select Distinct NOC.NOC, ICOVERNOC.DESCRIPTION, NOC.CTLF, ICOVERNOC.CURRENCY, 
CASE 
WHEN ICOVERNOC.AMOUNT<>0 AND ICOVERNOC.PCT/100*ICOVER.AMOUNT*coalesce(P.InstSIPCT,100)/100<>0 THEN
	CASE WHEN ICOVERNOC.AMOUNT>ICOVERNOC.PCT/100*ICOVER.AMOUNT*coalesce(P.InstSIPCT,100)/100 THEN ICOVERNOC.PCT/100*ICOVER.AMOUNT*coalesce(P.InstSIPCT,100)/100 ELSE ICOVERNOC.AMOUNT END
WHEN ICOVERNOC.AMOUNT<>0 THEN ICOVERNOC.AMOUNT
ELSE ICOVERNOC.PCT/100*ICOVER.AMOUNT*coalesce(P.InstSIPCT,100)/100
END*(CASE WHEN ICOVERNOC.MAXQTY=0 THEN 1 ELSE ICOVERNOC.MAXQTY END) AS AMOUNT_1,
Cast(0 as Float) as AMOUNT_2,
CASE 
WHEN ICOVERNOC.LIMIT=0 THEN
	CASE 
	WHEN ICOVERNOC.AMOUNT<>0 AND ICOVERNOC.PCT/100*ICOVER.AMOUNT*coalesce(P.InstSIPCT,100)/100<>0 THEN
		CASE WHEN ICOVERNOC.AMOUNT>ICOVERNOC.PCT/100*ICOVER.AMOUNT*coalesce(P.InstSIPCT,100)/100 THEN ICOVERNOC.PCT/100*ICOVER.AMOUNT*coalesce(P.InstSIPCT,100)/100 ELSE ICOVERNOC.AMOUNT END
	WHEN ICOVERNOC.AMOUNT<>0 THEN ICOVERNOC.AMOUNT
	ELSE ICOVERNOC.PCT/100*ICOVER.AMOUNT*coalesce(P.InstSIPCT,100)/100
	END*(CASE WHEN ICOVERNOC.MAXQTY=0 THEN 1 ELSE ICOVERNOC.MAXQTY END) 
ELSE
	ICOVERNOC.LIMIT
END AS LIMIT,
ICOVERNOC.INDEMNITY, ICOVERNOC.ESTIMATE                  
from ICOVER, ICOVERNOC, NOC, ACCEPTANCE Left Join Payor_Schedule P on (P.ANO=Acceptance.ANO and P.InstDate<=@P_LossDate and (P.InstLDate>@P_LossDate or (P.InstLDate=@P_LossDate and P.InstLDate=Acceptance.EDate)))        
Where ICOVERNOC.INO=ICOVER.INO AND NOC.NOC=ICOVERNOC.NOC AND NOC.TOI=ICOVER.TOI AND ICOVER.INO=@P_INO AND NOC.NOC LIKE @P_NOC                          
AND ACCEPTANCE.ANO=ICOVER.ANO    
AND ((Select Top 1 RCover.RetroActiveF from RCover Where RCover.ANO=Acceptance.ANO Order by RCover.RetroActiveF Desc)=1 or (ICOVERNOC.SDATE<=@P_LOSSDATE AND ACCEPTANCE.ExclusiveF=1) or ((ICOVERNOC.SDATE<@P_LOSSDATE or (ICOVERNOC.SDATE=@P_LOSSDATE AND ACCEPTANCE.STIME<=@P_LOSSTIME)) AND ACCEPTANCE.ExclusiveF=0))                       
AND ((dbo.fn_Get_ExtPeriodDate(ACCEPTANCE.ExtRPeriod, 0, dbo.fn_Get_ExtPeriodDate(ACCEPTANCE.ExtPeriod, ACCEPTANCE.ExtPeriodInDaysF, ICOVERNOC.EDATE))>@P_LOSSDATE AND ACCEPTANCE.ExclusiveF=1) or ((dbo.fn_Get_ExtPeriodDate(ACCEPTANCE.ExtRPeriod, 0, dbo.fn_Get_ExtPeriodDate(ACCEPTANCE.ExtPeriod, ACCEPTANCE.ExtPeriodInDaysF, ICOVERNOC.EDATE))>@P_LOSSDATE or (dbo.fn_Get_ExtPeriodDate(ACCEPTANCE.ExtRPeriod, 0, dbo.fn_Get_ExtPeriodDate(ACCEPTANCE.ExtPeriod, ACCEPTANCE.ExtPeriodInDaysF, ICOVERNOC.EDATE))=@P_LOSSDATE AND ACCEPTANCE.ETIME>@P_LOSSTIME)) AND ACCEPTANCE.ExclusiveF=0))                                
      
Insert into @CLNOC      
Select Distinct NOC.NOC, NOC.DESCRIPTION, NOC.CTLF, ICOVER.CURRENCY,                      
CASE                        
 WHEN @P_EVENTNO=-1 THEN                        
        CASE                        
        WHEN RCOVER.PCTLOSS=0 OR ICOVER.NOTDECRF=1 OR ICOVER.NOTFLF=1 THEN ICOVER.AMOUNT*coalesce(P.InstSIPCT,100)/100 * (100+(dbo.fn_Get_UWYear(Acceptance.Sdate, Acceptance.Edate, @P_LossDate)-Year(Acceptance.SDate))*RCover.PCTEscalation)/100
        ELSE ICOVER.AMOUNT*coalesce(P.InstSIPCT,100)/100*RCOVER.PCTLOSS/100 * (100+(dbo.fn_Get_UWYear(Acceptance.Sdate, Acceptance.Edate, @P_LossDate)-Year(Acceptance.SDate))*RCover.PCTEscalation)/100 
		END        
 Else             
        CASE                        
        WHEN RCOVER.PCTLOSS=0 OR ICOVER.NOTDECRF=1 OR ICOVER.NOTFLF=1 THEN ICOVER.AMOUNT_AOE*coalesce(P.InstSIPCT,100)/100 * (100+(dbo.fn_Get_UWYear(Acceptance.Sdate, Acceptance.Edate, @P_LossDate)-Year(Acceptance.SDate))*RCover.PCTEscalation)/100
        ELSE ICOVER.AMOUNT_AOE*coalesce(P.InstSIPCT,100)/100*RCOVER.PCTLOSS/100 * (100+(dbo.fn_Get_UWYear(Acceptance.Sdate, Acceptance.Edate, @P_LossDate)-Year(Acceptance.SDate))*RCover.PCTEscalation)/100 
		END        
 END AS AMOUNT_1,                        
CASE                        
 WHEN @P_EVENTNO=-1 THEN             
        @P_VALUE
 Else                        
        0
 END AS AMOUNT_2,                                                
 0 as Limit,                  
 0 as Indemnity,
 0 as Estimate
From RCOVER, Col, RATECOV, PCLASS, ICOVER, NOC, COLNOCCLASS, ACCEPTANCE Left Join Payor_Schedule P on (P.ANO=Acceptance.ANO and P.InstDate<=@P_LossDate and (P.InstLDate>@P_LossDate or (P.InstLDate=@P_LossDate and P.InstLDate=Acceptance.EDate)))        
Where ICOVER.INO=@P_INO AND RCOVER.ANO=ICOVER.ANO AND ACCEPTANCE.ANO=RCOVER.ANO AND COL.COL=@P_COL      
AND (RCover.RetroActiveF=1 or (RCOVER.SDATE<=@P_LOSSDATE AND ACCEPTANCE.ExclusiveF=1) or ((RCOVER.SDATE<@P_LOSSDATE or (RCOVER.SDATE=@P_LOSSDATE AND ACCEPTANCE.STIME<=@P_LOSSTIME)) AND ACCEPTANCE.ExclusiveF=0))                     
AND ((dbo.fn_Get_ExtPeriodDate(ACCEPTANCE.ExtRPeriod, 0, dbo.fn_Get_ExtPeriodDate(ACCEPTANCE.ExtPeriod, ACCEPTANCE.ExtPeriodInDaysF, RCOVER.EDATE))>@P_LOSSDATE AND ACCEPTANCE.ExclusiveF=1) or ((dbo.fn_Get_ExtPeriodDate(ACCEPTANCE.ExtRPeriod, 0, dbo.fn_Get_ExtPeriodDate(ACCEPTANCE.ExtPeriod, ACCEPTANCE.ExtPeriodInDaysF, RCOVER.EDATE))>@P_LOSSDATE or (dbo.fn_Get_ExtPeriodDate(ACCEPTANCE.ExtPeriod, ACCEPTANCE.ExtPeriodInDaysF, RCOVER.EDATE)=@P_LOSSDATE AND ACCEPTANCE.ETIME>@P_LOSSTIME)) AND ACCEPTANCE.ExclusiveF=0))        
AND RATECOV.CODE=RCOVER.CODE AND RATECOV.TOR=COL.TOR AND PCLASS.TOR=COL.TOR AND PCLASS.TOI=ICOVER.TOI                        
AND NOC.TOI=ICOVER.TOI AND NOC.NOC LIKE @P_NOC                       
AND NOT EXISTS (SELECT TOP 1 ICOVERNOC.NOC FROM ICOVERNOC WHERE ICOVERNOC.INO=@P_INO AND ICOVERNOC.NOC=NOC.NOC)                        
AND COLNOCCLASS.NOC=NOC.NOC AND COLNOCCLASS.COL=@P_COL      
AND (PCLASS.CTLF=0 OR NOC.CTLF=PCLASS.CTLF)             
      
RETURN      
END      

GO

GO
Create Function FL_GetPolicyNOC (@P_COL as varchar(10), @P_INO AS INTEGER)              
RETURNS @CLNOC TABLE (NOC varchar(10), Description varchar(255), Currency varchar(5), Amount Float)      
AS      
BEGIN          

Declare @P_LossDate as smalldatetime      
Declare @P_LossTime as varchar(5)      
      
Select 
@P_LossDate=Acceptance.SDate, 
@P_LossTime=Acceptance.STime
from Acceptance, ICover Where ICover.INO=@P_INO and Acceptance.ANO=ICover.ANO
      
Insert into @CLNOC      
  
Select Distinct NOC.NOC, ICOVERNOC.DESCRIPTION, ICOVERNOC.CURRENCY, 
CASE 
WHEN ICOVERNOC.AMOUNT<>0 AND ICOVERNOC.PCT/100*ICOVER.AMOUNT*coalesce(P.InstSIPCT,100)/100<>0 THEN
	CASE WHEN ICOVERNOC.AMOUNT>ICOVERNOC.PCT/100*ICOVER.AMOUNT*coalesce(P.InstSIPCT,100)/100 THEN ICOVERNOC.PCT/100*ICOVER.AMOUNT*coalesce(P.InstSIPCT,100)/100 ELSE ICOVERNOC.AMOUNT END
WHEN ICOVERNOC.AMOUNT<>0 THEN ICOVERNOC.AMOUNT
ELSE ICOVERNOC.PCT/100*ICOVER.AMOUNT*coalesce(P.InstSIPCT,100)/100
END*(CASE WHEN ICOVERNOC.MAXQTY=0 THEN 1 ELSE ICOVERNOC.MAXQTY END) AS AMOUNT
from ICOVER, ICOVERNOC, NOC, ACCEPTANCE Left Join Payor_Schedule P on (P.ANO=Acceptance.ANO and P.InstDate<=@P_LossDate and (P.InstLDate>@P_LossDate or (P.InstLDate=@P_LossDate and P.InstLDate=Acceptance.EDate)))        
Where ICOVERNOC.INO=ICOVER.INO AND NOC.NOC=ICOVERNOC.NOC AND NOC.TOI=ICOVER.TOI AND ICOVER.INO=@P_INO 
AND ACCEPTANCE.ANO=ICOVER.ANO    
      
Insert into @CLNOC      
Select Distinct NOC.NOC, NOC.DESCRIPTION, ICOVER.CURRENCY,                      
CASE                        
WHEN RCOVER.PCTLOSS=0 OR ICOVER.NOTDECRF=1 OR ICOVER.NOTFLF=1 THEN ICOVER.AMOUNT*coalesce(P.InstSIPCT,100)/100 * (100+(dbo.fn_Get_UWYear(Acceptance.Sdate, Acceptance.Edate, @P_LossDate)-Year(Acceptance.SDate))*RCover.PCTEscalation)/100
ELSE ICOVER.AMOUNT*coalesce(P.InstSIPCT,100)/100*RCOVER.PCTLOSS/100 * (100+(dbo.fn_Get_UWYear(Acceptance.Sdate, Acceptance.Edate, @P_LossDate)-Year(Acceptance.SDate))*RCover.PCTEscalation)/100 
END AS AMOUNT
From RCOVER, Col, RATECOV, PCLASS, ICOVER, NOC, COLNOCCLASS, ACCEPTANCE Left Join Payor_Schedule P on (P.ANO=Acceptance.ANO and P.InstDate<=@P_LossDate and (P.InstLDate>@P_LossDate or (P.InstLDate=@P_LossDate and P.InstLDate=Acceptance.EDate)))        
Where ICOVER.INO=@P_INO AND RCOVER.ANO=ICOVER.ANO AND ACCEPTANCE.ANO=RCOVER.ANO AND COL.COL=@P_COL      
AND (RCover.RetroActiveF=1 or (RCOVER.SDATE<=@P_LOSSDATE AND ACCEPTANCE.ExclusiveF=1) or ((RCOVER.SDATE<@P_LOSSDATE or (RCOVER.SDATE=@P_LOSSDATE AND ACCEPTANCE.STIME<=@P_LOSSTIME)) AND ACCEPTANCE.ExclusiveF=0))                     
AND ((dbo.fn_Get_ExtPeriodDate(ACCEPTANCE.ExtRPeriod, 0, dbo.fn_Get_ExtPeriodDate(ACCEPTANCE.ExtPeriod, ACCEPTANCE.ExtPeriodInDaysF, RCOVER.EDATE))>@P_LOSSDATE AND ACCEPTANCE.ExclusiveF=1) or ((dbo.fn_Get_ExtPeriodDate(ACCEPTANCE.ExtRPeriod, 0, dbo.fn_Get_ExtPeriodDate(ACCEPTANCE.ExtPeriod, ACCEPTANCE.ExtPeriodInDaysF, RCOVER.EDATE))>@P_LOSSDATE or (dbo.fn_Get_ExtPeriodDate(ACCEPTANCE.ExtPeriod, ACCEPTANCE.ExtPeriodInDaysF, RCOVER.EDATE)=@P_LOSSDATE AND ACCEPTANCE.ETIME>@P_LOSSTIME)) AND ACCEPTANCE.ExclusiveF=0))        
AND RATECOV.CODE=RCOVER.CODE AND RATECOV.TOR=COL.TOR AND PCLASS.TOR=COL.TOR AND PCLASS.TOI=ICOVER.TOI                        
AND NOC.TOI=ICOVER.TOI 
AND NOT EXISTS (SELECT TOP 1 ICOVERNOC.NOC FROM ICOVERNOC WHERE ICOVERNOC.INO=@P_INO AND ICOVERNOC.NOC=NOC.NOC)                        
AND COLNOCCLASS.NOC=NOC.NOC AND COLNOCCLASS.COL=@P_COL      
AND (PCLASS.CTLF=0 OR NOC.CTLF=PCLASS.CTLF)             
      
RETURN      
END      


GO



GO
CREATE FUNCTION ICPS_PolicyInterestLimit(@P_ANO as Int, @P_COL as varchar(10), @P_CTLF as bit, @P_LossDate as smalldatetime, @P_LossTime as varchar(5),@P_ICPSTPL as varchar(50), @P_ICPSPADRIVER as varchar(50), @P_ICPSPAPASSENGER as varchar(50))   
       
RETURNS TABLE               
AS RETURN (      
Select   
Max(Case When Category='M' Then Amount_1 else 0 end) as MainLimit,  
Max(Case When charindex(TOI, @P_ICPSTPL)<>0 Then Amount_1 else 0 end) as AddLimitTPL,  
Max(Case When charindex(TOI, @P_ICPSPADRIVER)<>0 Then Amount_1 else 0 end) as AddLimitPADRIVER,  
Max(Case When charindex(TOI, @P_ICPSPAPASSENGER)<>0 Then Amount_1 else 0 end) as AddLimitPAPASSENGER  
from  
(  
       Select Distinct   
       ICOVER.CATEGORY,   
       TOI.TOI,  
       ICOVERNOC.CURRENCY,   
       CASE   
       WHEN ICOVERNOC.AMOUNT<>0 AND ICOVERNOC.PCT/100*ICOVER.AMOUNT<>0 THEN  
              CASE WHEN ICOVERNOC.AMOUNT>ICOVERNOC.PCT/100*ICOVER.AMOUNT THEN ICOVERNOC.PCT/100*ICOVER.AMOUNT ELSE ICOVERNOC.AMOUNT END  
       WHEN ICOVERNOC.AMOUNT<>0 THEN ICOVERNOC.AMOUNT  
       ELSE ICOVERNOC.PCT/100*ICOVER.AMOUNT  
       END*(CASE WHEN ICOVERNOC.MAXQTY=0 THEN 1 ELSE ICOVERNOC.MAXQTY END) AS AMOUNT_1  
  
       from ICOVER, TOI, ICOVERNOC, NOC, NOCTAB, ACCEPTANCE           
       Where ICOVERNOC.INO=ICOVER.INO AND NOC.NOC=ICOVERNOC.NOC AND NOC.TOI=ICOVER.TOI  
       AND ACCEPTANCE.ANO=ICOVER.ANO    
       AND ((Select Top 1 RCover.RetroActiveF from RCover Where RCover.ANO=Acceptance.ANO Order by RCover.RetroActiveF Desc)=1 or (ICOVERNOC.SDATE<=@P_LOSSDATE AND ACCEPTANCE.ExclusiveF=1) or ((ICOVERNOC.SDATE<@P_LOSSDATE or (ICOVERNOC.SDATE=@P_LOSSDATE AND ACCEPTANCE.STIME<=@P_LOSSTIME)) AND ACCEPTANCE.ExclusiveF=0))                       
       AND ((dbo.fn_Get_ExtPeriodDate(ACCEPTANCE.ExtPeriod, ACCEPTANCE.ExtPeriodInDaysF, ICOVERNOC.EDATE)>@P_LOSSDATE AND ACCEPTANCE.ExclusiveF=1) or ((dbo.fn_Get_ExtPeriodDate(ACCEPTANCE.ExtPeriod, ACCEPTANCE.ExtPeriodInDaysF, ICOVERNOC.EDATE)>@P_LOSSDATE or (dbo.fn_Get_ExtPeriodDate(ACCEPTANCE.ExtPeriod, ACCEPTANCE.ExtPeriodInDaysF, ICOVERNOC.EDATE)=@P_LOSSDATE AND ACCEPTANCE.ETIME>@P_LOSSTIME)) AND ACCEPTANCE.ExclusiveF=0))                                
       AND ICOVER.ANO=@P_ANO AND TOI.TOI=ICOVER.TOI AND TOI.ICPSF=1           
       and NOCTAB.NOC=NOC.NOC and NOCTAB.ICPSF=1 and NOC.CTLF=@P_CTLF  
  
       Union All                          
                                                      
       Select Distinct   
       ICOVER.CATEGORY,   
       TOI.TOI,  
       ICOVER.CURRENCY,                        
       CASE                          
       WHEN RCOVER.PCTLOSS=0 OR ICOVER.NOTDECRF=1 OR ICOVER.NOTFLF=1 THEN ICOVER.AMOUNT   
       ELSE ICOVER.AMOUNT*RCOVER.PCTLOSS/100    
       END  AS AMOUNT_1  
       From RCOVER, Col, RATECOV, PCLASS, ICOVER, TOI, NOC, NOCTAB, COLNOCCLASS, ACCEPTANCE                   
       Where RCOVER.ANO=ICOVER.ANO AND ACCEPTANCE.ANO=RCOVER.ANO AND COL.COL=@P_COL        
       AND (RCover.RetroActiveF=1 Or (RCOVER.SDATE<=@P_LOSSDATE AND ACCEPTANCE.ExclusiveF=1) or ((RCOVER.SDATE<@P_LOSSDATE or (RCOVER.SDATE=@P_LOSSDATE AND ACCEPTANCE.STIME<=@P_LOSSTIME)) AND ACCEPTANCE.ExclusiveF=0))                       
       AND ((dbo.fn_Get_ExtPeriodDate(ACCEPTANCE.ExtPeriod, ACCEPTANCE.ExtPeriodInDaysF, RCOVER.EDATE)>@P_LOSSDATE AND ACCEPTANCE.ExclusiveF=1) or ((dbo.fn_Get_ExtPeriodDate(ACCEPTANCE.ExtPeriod, ACCEPTANCE.ExtPeriodInDaysF, RCOVER.EDATE)>@P_LOSSDATE or (dbo.fn_Get_ExtPeriodDate(ACCEPTANCE.ExtPeriod, ACCEPTANCE.ExtPeriodInDaysF, RCOVER.EDATE)=@P_LOSSDATE AND ACCEPTANCE.ETIME>@P_LOSSTIME)) AND ACCEPTANCE.ExclusiveF=0))                      
       AND RATECOV.CODE=RCOVER.CODE AND RATECOV.TOR=COL.TOR AND PCLASS.TOR=COL.TOR AND PCLASS.TOI=ICOVER.TOI                        
       AND NOC.TOI=ICOVER.TOI   
       AND NOT EXISTS (SELECT TOP 1 ICOVERNOC.NOC FROM ICOVERNOC WHERE ICOVERNOC.INO=ICOVER.INO AND ICOVERNOC.NOC=NOC.NOC)                          
	   AND COLNOCCLASS.NOC=NOC.NOC AND COLNOCCLASS.COL=@P_COL        
       AND (PCLASS.CTLF=0 OR NOC.CTLF=PCLASS.CTLF)             
       AND ICOVER.ANO=@P_ANO AND TOI.TOI=ICOVER.TOI AND TOI.ICPSF=1   
       and NOCTAB.NOC=NOC.NOC and NOCTAB.ICPSF=1 and NOC.CTLF=@P_CTLF  
       ) C  
)

