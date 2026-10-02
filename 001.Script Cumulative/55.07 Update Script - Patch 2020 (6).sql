IF EXISTS ( SELECT * FROM   sysobjects WHERE  id = object_id(N'QCLNOC') and OBJECTPROPERTY(id, N'IsProcedure') = 1 )
BEGIN
DROP PROCEDURE QCLNOC
END
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
END*ICOVERNOC.MAXQTY AS AMOUNT_1,
Cast(0 as Float) as AMOUNT_2, 
CASE 
WHEN ICOVERNOC.LIMIT=0 THEN
	CASE 
	WHEN ICOVERNOC.AMOUNT<>0 AND ICOVERNOC.PCT/100*ICOVER.AMOUNT*coalesce(P.InstSIPCT,100)/100<>0 THEN
		CASE WHEN ICOVERNOC.AMOUNT>ICOVERNOC.PCT/100*ICOVER.AMOUNT*coalesce(P.InstSIPCT,100)/100 THEN ICOVERNOC.PCT/100*ICOVER.AMOUNT*coalesce(P.InstSIPCT,100)/100 ELSE ICOVERNOC.AMOUNT END
	WHEN ICOVERNOC.AMOUNT<>0 THEN ICOVERNOC.AMOUNT
	ELSE ICOVERNOC.PCT/100*ICOVER.AMOUNT*coalesce(P.InstSIPCT,100)/100
	END*ICOVERNOC.MAXQTY 
ELSE
	ICOVERNOC.LIMIT
END AS LIMIT,
ICOVERNOC.INDEMNITY, ICOVERNOC.ESTIMATE                  
from ICOVER, ICOVERNOC, NOC, ACCEPTANCE Left Join Payor_Schedule P on (P.ANO=Acceptance.ANO and P.InstDate<=@P_LossDate and (P.InstLDate>@P_LossDate or (P.InstLDate=@P_LossDate and P.InstLDate=Acceptance.EDate)))        
Where ICOVERNOC.INO=ICOVER.INO AND NOC.NOC=ICOVERNOC.NOC AND NOC.TOI=ICOVER.TOI AND ICOVER.INO=@P_INO AND NOC.NOC LIKE @P_NOC                        
AND ACCEPTANCE.ANO=ICOVER.ANO  
AND ((Select Top 1 RCover.RetroActiveF from RCover Where RCover.ANO=Acceptance.ANO Order by RCover.RetroActiveF Desc)=1 or (ICOVERNOC.SDATE<=@P_LOSSDATE AND ACCEPTANCE.ExclusiveF=1) or ((ICOVERNOC.SDATE<@P_LOSSDATE or (ICOVERNOC.SDATE=@P_LOSSDATE AND ACCEPTANCE.STIME<=@P_LOSSTIME)) AND ACCEPTANCE.ExclusiveF=0))                     
AND ((dbo.fn_Get_ExtPeriodDate(ACCEPTANCE.ExtPeriod, ACCEPTANCE.ExtPeriodInDaysF, ICOVERNOC.EDATE)>@P_LOSSDATE AND ACCEPTANCE.ExclusiveF=1) or ((dbo.fn_Get_ExtPeriodDate(ACCEPTANCE.ExtPeriod, ACCEPTANCE.ExtPeriodInDaysF, ICOVERNOC.EDATE)>@P_LOSSDATE or (dbo.fn_Get_ExtPeriodDate(ACCEPTANCE.ExtPeriod, ACCEPTANCE.ExtPeriodInDaysF, ICOVERNOC.EDATE)=@P_LOSSDATE AND ACCEPTANCE.ETIME>@P_LOSSTIME)) AND ACCEPTANCE.ExclusiveF=0))                              

          
Union All                        
                                                    
Select Distinct NOC.NOC, NOC.DESCRIPTION, NOC.CTLF, ICOVER.CURRENCY,                      
CASE                        
 WHEN @P_EVENTNO=-1 THEN                        
        CASE                        
        WHEN RCOVER.PCTLOSS=0 OR ICOVER.NOTDECRF=1 OR ICOVER.NOTFLF=1 THEN ICOVER.AMOUNT*coalesce(P.InstSIPCT,100)/100 
        ELSE ICOVER.AMOUNT*coalesce(P.InstSIPCT,100)/100*RCOVER.PCTLOSS/100 END                        
 Else                        
        CASE                        
        WHEN RCOVER.PCTLOSS=0 OR ICOVER.NOTDECRF=1 OR ICOVER.NOTFLF=1 THEN ICOVER.AMOUNT_AOE*coalesce(P.InstSIPCT,100)/100
        ELSE ICOVER.AMOUNT_AOE*coalesce(P.InstSIPCT,100)/100*RCOVER.PCTLOSS/100 END                        
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
AND ((dbo.fn_Get_ExtPeriodDate(ACCEPTANCE.ExtPeriod, ACCEPTANCE.ExtPeriodInDaysF, RCOVER.EDATE)>@P_LOSSDATE AND ACCEPTANCE.ExclusiveF=1) or ((dbo.fn_Get_ExtPeriodDate(ACCEPTANCE.ExtPeriod, ACCEPTANCE.ExtPeriodInDaysF, RCOVER.EDATE)>@P_LOSSDATE or (dbo.fn_Get_ExtPeriodDate(ACCEPTANCE.ExtPeriod, ACCEPTANCE.ExtPeriodInDaysF, RCOVER.EDATE)=@P_LOSSDATE AND ACCEPTANCE.ETIME>@P_LOSSTIME)) AND ACCEPTANCE.ExclusiveF=0))                    
AND RATECOV.CODE=RCOVER.CODE AND RATECOV.TOR=COL.TOR AND PCLASS.TOR=COL.TOR AND PCLASS.TOI=ICOVER.TOI                        
AND NOC.TOI=ICOVER.TOI AND NOC.NOC LIKE @P_NOC                       
AND NOT EXISTS (SELECT TOP 1 ICOVERNOC.NOC FROM ICOVERNOC WHERE ICOVERNOC.INO=@P_INO AND ICOVERNOC.NOC=NOC.NOC)                        
AND COLNOCCLASS.NOC=NOC.NOC AND COLNOCCLASS.COL=@P_COL      
AND (PCLASS.CTLF=0 OR NOC.CTLF=PCLASS.CTLF)           
          
GO

DROP Function FL_CL_NOC 
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
END*ICOVERNOC.MAXQTY AS AMOUNT_1,
Cast(0 as Float) as AMOUNT_2,
CASE 
WHEN ICOVERNOC.LIMIT=0 THEN
	CASE 
	WHEN ICOVERNOC.AMOUNT<>0 AND ICOVERNOC.PCT/100*ICOVER.AMOUNT*coalesce(P.InstSIPCT,100)/100<>0 THEN
		CASE WHEN ICOVERNOC.AMOUNT>ICOVERNOC.PCT/100*ICOVER.AMOUNT*coalesce(P.InstSIPCT,100)/100 THEN ICOVERNOC.PCT/100*ICOVER.AMOUNT*coalesce(P.InstSIPCT,100)/100 ELSE ICOVERNOC.AMOUNT END
	WHEN ICOVERNOC.AMOUNT<>0 THEN ICOVERNOC.AMOUNT
	ELSE ICOVERNOC.PCT/100*ICOVER.AMOUNT*coalesce(P.InstSIPCT,100)/100
	END*ICOVERNOC.MAXQTY 
ELSE
	ICOVERNOC.LIMIT
END AS LIMIT,
ICOVERNOC.INDEMNITY, ICOVERNOC.ESTIMATE                  
from ICOVER, ICOVERNOC, NOC, ACCEPTANCE Left Join Payor_Schedule P on (P.ANO=Acceptance.ANO and P.InstDate<=@P_LossDate and (P.InstLDate>@P_LossDate or (P.InstLDate=@P_LossDate and P.InstLDate=Acceptance.EDate)))        
Where ICOVERNOC.INO=ICOVER.INO AND NOC.NOC=ICOVERNOC.NOC AND NOC.TOI=ICOVER.TOI AND ICOVER.INO=@P_INO AND NOC.NOC LIKE @P_NOC                          
AND ACCEPTANCE.ANO=ICOVER.ANO    
AND ((Select Top 1 RCover.RetroActiveF from RCover Where RCover.ANO=Acceptance.ANO Order by RCover.RetroActiveF Desc)=1 or (ICOVERNOC.SDATE<=@P_LOSSDATE AND ACCEPTANCE.ExclusiveF=1) or ((ICOVERNOC.SDATE<@P_LOSSDATE or (ICOVERNOC.SDATE=@P_LOSSDATE AND ACCEPTANCE.STIME<=@P_LOSSTIME)) AND ACCEPTANCE.ExclusiveF=0))                       
AND ((dbo.fn_Get_ExtPeriodDate(ACCEPTANCE.ExtPeriod, ACCEPTANCE.ExtPeriodInDaysF, ICOVERNOC.EDATE)>@P_LOSSDATE AND ACCEPTANCE.ExclusiveF=1) or ((dbo.fn_Get_ExtPeriodDate(ACCEPTANCE.ExtPeriod, ACCEPTANCE.ExtPeriodInDaysF, ICOVERNOC.EDATE)>@P_LOSSDATE or (dbo.fn_Get_ExtPeriodDate(ACCEPTANCE.ExtPeriod, ACCEPTANCE.ExtPeriodInDaysF, ICOVERNOC.EDATE)=@P_LOSSDATE AND ACCEPTANCE.ETIME>@P_LOSSTIME)) AND ACCEPTANCE.ExclusiveF=0))                                
      
Insert into @CLNOC      
Select Distinct NOC.NOC, NOC.DESCRIPTION, NOC.CTLF, ICOVER.CURRENCY,                      
CASE                        
 WHEN @P_EVENTNO=-1 THEN                        
        CASE                        
        WHEN RCOVER.PCTLOSS=0 OR ICOVER.NOTDECRF=1 OR ICOVER.NOTFLF=1 THEN ICOVER.AMOUNT*coalesce(P.InstSIPCT,100)/100 
        ELSE ICOVER.AMOUNT*coalesce(P.InstSIPCT,100)/100*RCOVER.PCTLOSS/100 END                        
 Else                        
        CASE                        
        WHEN RCOVER.PCTLOSS=0 OR ICOVER.NOTDECRF=1 OR ICOVER.NOTFLF=1 THEN ICOVER.AMOUNT_AOE*coalesce(P.InstSIPCT,100)/100                
        ELSE ICOVER.AMOUNT_AOE*coalesce(P.InstSIPCT,100)/100*RCOVER.PCTLOSS/100 END                        
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
AND ((dbo.fn_Get_ExtPeriodDate(ACCEPTANCE.ExtPeriod, ACCEPTANCE.ExtPeriodInDaysF, RCOVER.EDATE)>@P_LOSSDATE AND ACCEPTANCE.ExclusiveF=1) or ((dbo.fn_Get_ExtPeriodDate(ACCEPTANCE.ExtPeriod, ACCEPTANCE.ExtPeriodInDaysF, RCOVER.EDATE)>@P_LOSSDATE or (dbo.fn_Get_ExtPeriodDate(ACCEPTANCE.ExtPeriod, ACCEPTANCE.ExtPeriodInDaysF, RCOVER.EDATE)=@P_LOSSDATE AND ACCEPTANCE.ETIME>@P_LOSSTIME)) AND ACCEPTANCE.ExclusiveF=0))        
AND RATECOV.CODE=RCOVER.CODE AND RATECOV.TOR=COL.TOR AND PCLASS.TOR=COL.TOR AND PCLASS.TOI=ICOVER.TOI                        
AND NOC.TOI=ICOVER.TOI AND NOC.NOC LIKE @P_NOC                       
AND NOT EXISTS (SELECT TOP 1 ICOVERNOC.NOC FROM ICOVERNOC WHERE ICOVERNOC.INO=@P_INO AND ICOVERNOC.NOC=NOC.NOC)                        
AND COLNOCCLASS.NOC=NOC.NOC AND COLNOCCLASS.COL=@P_COL      
AND (PCLASS.CTLF=0 OR NOC.CTLF=PCLASS.CTLF)             
      
RETURN      
END      

GO

IF EXISTS ( SELECT * FROM   sysobjects WHERE  id = object_id(N'QInConsistent_LossItem') and OBJECTPROPERTY(id, N'IsProcedure') = 1 )
BEGIN
DROP procedure QInConsistent_LossItem
END
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
AND ((dbo.fn_Get_ExtPeriodDate(ACCEPTANCE.ExtPeriod, ACCEPTANCE.ExtPeriodInDaysF, ICOVERNOC.EDATE)>@P_LOSSDATE AND ACCEPTANCE.ExclusiveF=1) or ((dbo.fn_Get_ExtPeriodDate(ACCEPTANCE.ExtPeriod, ACCEPTANCE.ExtPeriodInDaysF, ICOVERNOC.EDATE)>@P_LOSSDATE or (dbo.fn_Get_ExtPeriodDate(ACCEPTANCE.ExtPeriod, ACCEPTANCE.ExtPeriodInDaysF, ICOVERNOC.EDATE)=@P_LOSSDATE AND ACCEPTANCE.ETIME>@P_LOSSTIME)) AND ACCEPTANCE.ExclusiveF=0))                              
AND
ABS(
CASE 
WHEN ICOVERNOC.AMOUNT<>0 AND ICOVERNOC.PCT/100*ICOVER.AMOUNT*coalesce(P.InstSIPCT,100)/100<>0 THEN
	CASE WHEN ICOVERNOC.AMOUNT>ICOVERNOC.PCT/100*ICOVER.AMOUNT*coalesce(P.InstSIPCT,100)/100 THEN ICOVERNOC.PCT/100*ICOVER.AMOUNT*coalesce(P.InstSIPCT,100)/100 ELSE ICOVERNOC.AMOUNT END
WHEN ICOVERNOC.AMOUNT<>0 THEN ICOVERNOC.AMOUNT
ELSE ICOVERNOC.PCT/100*ICOVER.AMOUNT*coalesce(P.InstSIPCT,100)/100
END*ICOVERNOC.MAXQTY-CLLOSS.DECLARED)<=1

UNION ALL  
    
Select ICOVER.INO, NOC.NOC  
From ICOVER WITH (INDEX(I_ICOVER)), RCOVER, Col, RATECOV, PCLASS, NOC, COLNOCCLASS, ACCEPTANCE Left Join Payor_Schedule P on (P.ANO=Acceptance.ANO and P.InstDate<=@P_LossDate and (P.InstLDate>@P_LossDate or (P.InstLDate=@P_LossDate and P.InstLDate=Acceptance.EDate)))
Where ICOVER.INO=CLLOSS.INO AND RCOVER.ANO=ICOVER.ANO AND ACCEPTANCE.ANO=RCOVER.ANO AND COL.COL=@P_COL      
AND ((RCOVER.SDATE<=@P_LOSSDATE AND ACCEPTANCE.ExclusiveF=1) or ((RCOVER.SDATE<@P_LOSSDATE or (RCOVER.SDATE=@P_LOSSDATE AND ACCEPTANCE.STIME<=@P_LOSSTIME)) AND ACCEPTANCE.ExclusiveF=0))                     
AND ((dbo.fn_Get_ExtPeriodDate(ACCEPTANCE.ExtPeriod, ACCEPTANCE.ExtPeriodInDaysF, RCOVER.EDATE)>@P_LOSSDATE AND ACCEPTANCE.ExclusiveF=1) or ((dbo.fn_Get_ExtPeriodDate(ACCEPTANCE.ExtPeriod, ACCEPTANCE.ExtPeriodInDaysF, RCOVER.EDATE)>@P_LOSSDATE or (dbo.fn_Get_ExtPeriodDate(ACCEPTANCE.ExtPeriod, ACCEPTANCE.ExtPeriodInDaysF, RCOVER.EDATE)=@P_LOSSDATE AND ACCEPTANCE.ETIME>@P_LOSSTIME)) AND ACCEPTANCE.ExclusiveF=0))                    
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
        WHEN RCOVER.PCTLOSS=0 OR ICOVER.NOTDECRF=1 OR ICOVER.NOTFLF=1 THEN ICOVER.AMOUNT*coalesce(P.InstSIPCT,100)/100 
        ELSE ICOVER.AMOUNT*coalesce(P.InstSIPCT,100)/100*RCOVER.PCTLOSS/100 END                        
 Else                        
        CASE                        
        WHEN RCOVER.PCTLOSS=0 OR ICOVER.NOTDECRF=1 OR ICOVER.NOTFLF=1 THEN ICOVER.AMOUNT_AOE*coalesce(P.InstSIPCT,100)/100
        ELSE ICOVER.AMOUNT_AOE*coalesce(P.InstSIPCT,100)/100*RCOVER.PCTLOSS/100 END                        
 END-CLLOSS.DECLARED)<=1
)  
GO

insert into PatchVersioning
select '55.7 Update Script - Patch 2020 (6)',GETDATE()
go


Declare @PrevScript varchar(100)
Declare @CurrScript varchar(100)

Select @PrevScript='55.6 Update Script - Patch 2020 (5)'
Select @CurrSCript='55.7 Update Script - Patch 2020 (6)'


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

          








