DROP Function FL_CL_NOC
GO
Create Function FL_CL_NOC (@P_CNO as Integer, @P_INO AS INTEGER, @P_NOC AS VARCHAR(255))              
RETURNS @CLNOC TABLE (NOC varchar(10), Description varchar(255), CTLF bit, Currency varchar(5), Amount_1 Float, Amount_2 Float, limit Float, Indemnity Float, Estimate Float)      
AS      
BEGIN          
Declare @P_LossDate as smalldatetime      
Declare @P_LossTime as varchar(5)      
Declare @P_COL as varchar(10)      
Declare @P_Value as float      
      
Select @P_LossDate=LossDate, @P_LossTime=LossTime, @P_Col=COL from Claim Where CNO=@P_CNO      
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
ICOVERNOC.LIMIT,
ICOVERNOC.INDEMNITY, ICOVERNOC.ESTIMATE                  
from ICOVER
Inner Join ICOVERNOC on (ICOVERNOC.INO=ICOVER.INO)
Inner Join NOC on (NOC.TOI=ICOVER.TOI AND NOC.NOC=ICOVERNOC.NOC) 
Inner Join COLNOCCLASS on (COLNOCCLASS.NOC=NOC.NOC AND COLNOCCLASS.COL=@P_COL)
Inner Join Acceptance on (Acceptance.ANO=ICover.ANO)
Left Join Payor_Schedule P on (P.ANO=Acceptance.ANO and P.InstDate<=@P_LossDate and (P.InstLDate>@P_LossDate or (P.InstLDate=@P_LossDate and P.InstLDate=Acceptance.EDate)))        
Where  ICOVER.INO=@P_INO AND NOC.NOC LIKE @P_NOC                          
AND ((Select Top 1 RCover.RetroActiveF from RCover Where RCover.ANO=Acceptance.ANO Order by RCover.RetroActiveF Desc)=1 or (ICOVERNOC.SDATE<=@P_LOSSDATE AND ACCEPTANCE.ExclusiveF=1) or ((ICOVERNOC.SDATE<@P_LOSSDATE or (ICOVERNOC.SDATE=@P_LOSSDATE AND ACCEPTANCE.STIME<=@P_LOSSTIME)) AND ACCEPTANCE.ExclusiveF=0))                       
AND ((dbo.fn_Get_ExtPeriodDate(ACCEPTANCE.ExtRPeriod, 0, dbo.fn_Get_ExtPeriodDate(ACCEPTANCE.ExtPeriod, ACCEPTANCE.ExtPeriodInDaysF, ICOVERNOC.EDATE))>@P_LOSSDATE AND ACCEPTANCE.ExclusiveF=1) or ((dbo.fn_Get_ExtPeriodDate(ACCEPTANCE.ExtRPeriod, 0, dbo.fn_Get_ExtPeriodDate(ACCEPTANCE.ExtPeriod, ACCEPTANCE.ExtPeriodInDaysF, ICOVERNOC.EDATE))>@P_LOSSDATE or (dbo.fn_Get_ExtPeriodDate(ACCEPTANCE.ExtRPeriod, 0, dbo.fn_Get_ExtPeriodDate(ACCEPTANCE.ExtPeriod, ACCEPTANCE.ExtPeriodInDaysF, ICOVERNOC.EDATE))=@P_LOSSDATE AND ACCEPTANCE.ETIME>@P_LOSSTIME)) AND ACCEPTANCE.ExclusiveF=0))                                
      
Insert into @CLNOC      
Select Distinct NOC.NOC, NOC.DESCRIPTION, NOC.CTLF, ICOVER.CURRENCY,                      
CASE                        
WHEN RCOVER.PCTLOSS=0 OR ICOVER.NOTDECRF=1 OR ICOVER.NOTFLF=1 THEN ICOVER.AMOUNT*coalesce(P.InstSIPCT,100)/100 * (100+(dbo.fn_Get_UWYear(Acceptance.Sdate, Acceptance.Edate, @P_LossDate)-Year(Acceptance.SDate))*RCover.PCTEscalation)/100
ELSE ICOVER.AMOUNT*coalesce(P.InstSIPCT,100)/100*RCOVER.PCTLOSS/100 * (100+(dbo.fn_Get_UWYear(Acceptance.Sdate, Acceptance.Edate, @P_LossDate)-Year(Acceptance.SDate))*RCover.PCTEscalation)/100 
END AS AMOUNT_1,                        
@P_VALUE AS AMOUNT_2,                                                
Cast(0 as Float) as Limit,                  
Cast(0 as Float) as Indemnity,
Cast(0 as Float) as Estimate
From ICOVER
Inner Join RCover on (RCover.ANO=ICover.ANO)
Inner Join Acceptance on (Acceptance.ANO=ICover.ANO)
Inner JOin COL on (COL.COL=@P_COL)
Inner Join RateCov on (RateCov.Code=RCover.Code and RateCov.TOR=COL.TOR)
Inner Join PClass on (PClass.TOR=COL.TOR and PClass.TOI=ICover.TOI)
Inner join NOC on (NOC.TOI=ICOVER.TOI)
Inner Join COLNOCCLASS on (COLNOCCLASS.NOC=NOC.NOC AND COLNOCCLASS.COL=COL.COL)
Left Join Payor_Schedule P on (P.ANO=Acceptance.ANO and P.InstDate<=@P_LossDate and (P.InstLDate>@P_LossDate or (P.InstLDate=@P_LossDate and P.InstLDate=Acceptance.EDate)))        
Where ICOVER.INO=@P_INO AND NOC.NOC LIKE @P_NOC
AND (RCover.RetroActiveF=1 or (RCOVER.SDATE<=@P_LOSSDATE AND ACCEPTANCE.ExclusiveF=1) or ((RCOVER.SDATE<@P_LOSSDATE or (RCOVER.SDATE=@P_LOSSDATE AND ACCEPTANCE.STIME<=@P_LOSSTIME)) AND ACCEPTANCE.ExclusiveF=0))                     
AND ((dbo.fn_Get_ExtPeriodDate(ACCEPTANCE.ExtRPeriod, 0, dbo.fn_Get_ExtPeriodDate(ACCEPTANCE.ExtPeriod, ACCEPTANCE.ExtPeriodInDaysF, RCOVER.EDATE))>@P_LOSSDATE AND ACCEPTANCE.ExclusiveF=1) or ((dbo.fn_Get_ExtPeriodDate(ACCEPTANCE.ExtRPeriod, 0, dbo.fn_Get_ExtPeriodDate(ACCEPTANCE.ExtPeriod, ACCEPTANCE.ExtPeriodInDaysF, RCOVER.EDATE))>@P_LOSSDATE or (dbo.fn_Get_ExtPeriodDate(ACCEPTANCE.ExtPeriod, ACCEPTANCE.ExtPeriodInDaysF, RCOVER.EDATE)=@P_LOSSDATE AND ACCEPTANCE.ETIME>@P_LOSSTIME)) AND ACCEPTANCE.ExclusiveF=0))        
AND NOT EXISTS (SELECT TOP 1 ICOVERNOC.NOC FROM ICOVERNOC WHERE ICOVERNOC.INO=@P_INO AND ICOVERNOC.NOC=NOC.NOC)                        
AND (PCLASS.CTLF=0 OR NOC.CTLF=PCLASS.CTLF)             
      
RETURN      
END      

GO



DROP PROCEDURE QCLNOC 

GO

CREATE PROCEDURE QCLNOC (@P_CNO as Integer, @P_INO AS INTEGER, @P_NOC AS VARCHAR(255))                        
AS                        
Declare @P_LossDate as smalldatetime      
Declare @P_LossTime as varchar(5)      
Declare @P_COL as varchar(10)      
Declare @P_Value as float      
      
Select @P_LossDate=LossDate, @P_LossTime=LossTime, @P_Col=COL from Claim Where CNO=@P_CNO      
Select @P_Value=Value from fn_ObjectValuation(@P_INO, @P_LOSSDATE)    
if @P_Value is null     
 Select @P_Value=0    
                      
Select Distinct NOC.NOC, ICOVERNOC.DESCRIPTION, NOC.CTLF, ICOVERNOC.CURRENCY, 

CASE 
WHEN ICOVERNOC.AMOUNT<>0 AND ICOVERNOC.PCT/100*ICOVER.AMOUNT*coalesce(P.InstSIPCT,100)/100<>0 THEN
	CASE WHEN ICOVERNOC.AMOUNT>ICOVERNOC.PCT/100*ICOVER.AMOUNT*coalesce(P.InstSIPCT,100)/100 THEN ICOVERNOC.PCT/100*ICOVER.AMOUNT*coalesce(P.InstSIPCT,100)/100 ELSE ICOVERNOC.AMOUNT END
WHEN ICOVERNOC.AMOUNT<>0 THEN ICOVERNOC.AMOUNT
ELSE ICOVERNOC.PCT/100*ICOVER.AMOUNT*coalesce(P.InstSIPCT,100)/100
END*(CASE WHEN ICOVERNOC.MAXQTY=0 THEN 1 ELSE ICOVERNOC.MAXQTY END) AS AMOUNT_1,
Cast(0 as Float) as AMOUNT_2, 
ICOVERNOC.LIMIT,
ICOVERNOC.INDEMNITY, ICOVERNOC.ESTIMATE                  
from ICOVER
Inner Join ICOVERNOC on (ICOVERNOC.INO=ICOVER.INO)
Inner Join NOC on (NOC.TOI=ICOVER.TOI AND NOC.NOC=ICOVERNOC.NOC) 
Inner Join COLNOCCLASS on (COLNOCCLASS.NOC=NOC.NOC AND COLNOCCLASS.COL=@P_COL)
Inner Join Acceptance on (Acceptance.ANO=ICover.ANO)
Left Join Payor_Schedule P on (P.ANO=Acceptance.ANO and P.InstDate<=@P_LossDate and (P.InstLDate>@P_LossDate or (P.InstLDate=@P_LossDate and P.InstLDate=Acceptance.EDate)))        
Where  ICOVER.INO=@P_INO AND NOC.NOC LIKE @P_NOC                          
AND ((Select Top 1 RCover.RetroActiveF from RCover Where RCover.ANO=Acceptance.ANO Order by RCover.RetroActiveF Desc)=1 or (ICOVERNOC.SDATE<=@P_LOSSDATE AND ACCEPTANCE.ExclusiveF=1) or ((ICOVERNOC.SDATE<@P_LOSSDATE or (ICOVERNOC.SDATE=@P_LOSSDATE AND ACCEPTANCE.STIME<=@P_LOSSTIME)) AND ACCEPTANCE.ExclusiveF=0))                       
AND ((dbo.fn_Get_ExtPeriodDate(ACCEPTANCE.ExtRPeriod, 0, dbo.fn_Get_ExtPeriodDate(ACCEPTANCE.ExtPeriod, ACCEPTANCE.ExtPeriodInDaysF, ICOVERNOC.EDATE))>@P_LOSSDATE AND ACCEPTANCE.ExclusiveF=1) or ((dbo.fn_Get_ExtPeriodDate(ACCEPTANCE.ExtRPeriod, 0, dbo.fn_Get_ExtPeriodDate(ACCEPTANCE.ExtPeriod, ACCEPTANCE.ExtPeriodInDaysF, ICOVERNOC.EDATE))>@P_LOSSDATE or (dbo.fn_Get_ExtPeriodDate(ACCEPTANCE.ExtRPeriod, 0, dbo.fn_Get_ExtPeriodDate(ACCEPTANCE.ExtPeriod, ACCEPTANCE.ExtPeriodInDaysF, ICOVERNOC.EDATE))=@P_LOSSDATE AND ACCEPTANCE.ETIME>@P_LOSSTIME)) AND ACCEPTANCE.ExclusiveF=0))                                
          
Union All                        
                                                    
Select Distinct NOC.NOC, NOC.DESCRIPTION, NOC.CTLF, ICOVER.CURRENCY,                      
CASE                        
WHEN RCOVER.PCTLOSS=0 OR ICOVER.NOTDECRF=1 OR ICOVER.NOTFLF=1 THEN ICOVER.AMOUNT*coalesce(P.InstSIPCT,100)/100 * (100+(dbo.fn_Get_UWYear(Acceptance.Sdate, Acceptance.Edate, @P_LossDate)-Year(Acceptance.SDate))*RCover.PCTEscalation)/100
ELSE ICOVER.AMOUNT*coalesce(P.InstSIPCT,100)/100*RCOVER.PCTLOSS/100 * (100+(dbo.fn_Get_UWYear(Acceptance.Sdate, Acceptance.Edate, @P_LossDate)-Year(Acceptance.SDate))*RCover.PCTEscalation)/100 
END AS AMOUNT_1,                        
@P_VALUE AS AMOUNT_2,                           
Cast(0 as Float) as Limit,       
Cast(0 as Float) as Indemnity,
Cast(0 as Float) as Estimate
From ICOVER
Inner Join RCover on (RCover.ANO=ICover.ANO)
Inner Join Acceptance on (Acceptance.ANO=ICover.ANO)
Inner JOin COL on (COL.COL=@P_COL)
Inner Join RateCov on (RateCov.Code=RCover.Code and RateCov.TOR=COL.TOR)
Inner Join PClass on (PClass.TOR=COL.TOR and PClass.TOI=ICover.TOI)
Inner join NOC on (NOC.TOI=ICOVER.TOI)
Inner Join COLNOCCLASS on (COLNOCCLASS.NOC=NOC.NOC AND COLNOCCLASS.COL=COL.COL)
Left Join Payor_Schedule P on (P.ANO=Acceptance.ANO and P.InstDate<=@P_LossDate and (P.InstLDate>@P_LossDate or (P.InstLDate=@P_LossDate and P.InstLDate=Acceptance.EDate)))        
Where ICOVER.INO=@P_INO AND NOC.NOC LIKE @P_NOC
AND (RCover.RetroActiveF=1 or (RCOVER.SDATE<=@P_LOSSDATE AND ACCEPTANCE.ExclusiveF=1) or ((RCOVER.SDATE<@P_LOSSDATE or (RCOVER.SDATE=@P_LOSSDATE AND ACCEPTANCE.STIME<=@P_LOSSTIME)) AND ACCEPTANCE.ExclusiveF=0))                     
AND ((dbo.fn_Get_ExtPeriodDate(ACCEPTANCE.ExtRPeriod, 0, dbo.fn_Get_ExtPeriodDate(ACCEPTANCE.ExtPeriod, ACCEPTANCE.ExtPeriodInDaysF, RCOVER.EDATE))>@P_LOSSDATE AND ACCEPTANCE.ExclusiveF=1) or ((dbo.fn_Get_ExtPeriodDate(ACCEPTANCE.ExtRPeriod, 0, dbo.fn_Get_ExtPeriodDate(ACCEPTANCE.ExtPeriod, ACCEPTANCE.ExtPeriodInDaysF, RCOVER.EDATE))>@P_LOSSDATE or (dbo.fn_Get_ExtPeriodDate(ACCEPTANCE.ExtPeriod, ACCEPTANCE.ExtPeriodInDaysF, RCOVER.EDATE)=@P_LOSSDATE AND ACCEPTANCE.ETIME>@P_LOSSTIME)) AND ACCEPTANCE.ExclusiveF=0))        
AND NOT EXISTS (SELECT TOP 1 ICOVERNOC.NOC FROM ICOVERNOC WHERE ICOVERNOC.INO=@P_INO AND ICOVERNOC.NOC=NOC.NOC)                        
AND (PCLASS.CTLF=0 OR NOC.CTLF=PCLASS.CTLF)             

GO




 insert into PatchVersioning
select '220 Update Script - Patch 2022 (23)',GETDATE()
go


Declare @PrevScript varchar(100)
Declare @CurrScript varchar(100)

Select @PrevScript=''
Select @CurrSCript='220 Update Script - Patch 2022 (23)'


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
