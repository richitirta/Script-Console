DROP FUNCTION ICPS_PolicyInterestLimit
GO
CREATE FUNCTION ICPS_PolicyInterestLimit(@P_ANO as Int, @P_COL as varchar(10), @P_CTLF as bit, @P_LossDate as smalldatetime, @P_LossTime as varchar(5), @P_ICPSCASCO as varchar(50), @P_ICPSTPL as varchar(50), @P_ICPSPADRIVER as varchar(50), @P_ICPSPAPASSENGER as varchar(50))         
             
RETURNS TABLE                     
AS RETURN (            
Select 
Min(COL) as COL,        
Max(Case When Category='M' or (charindex(TOI, @P_ICPSCASCO)<>0 or @P_ICPSCASCO='') Then Amount_1 else 0 end) as MainLimit,        
Max(Case When charindex(TOI, @P_ICPSTPL)<>0 Then Amount_1 else 0 end) as AddLimitTPL,        
Max(Case When charindex(TOI, @P_ICPSPADRIVER)<>0 Then Amount_1 else 0 end) as AddLimitPADRIVER,        
Max(Case When charindex(TOI, @P_ICPSPAPASSENGER)<>0 Then Amount_1 else 0 end) as AddLimitPAPASSENGER        
from        
(        
       Select Distinct         
          COLTAB.COL,
       ICOVER.CATEGORY,         
       TOI.TOI,        
       ICOVERNOC.CURRENCY,         
       CASE         
       WHEN ICOVERNOC.AMOUNT<>0 AND ICOVERNOC.PCT/100*ICOVER.AMOUNT<>0 THEN        
              CASE WHEN ICOVERNOC.AMOUNT>ICOVERNOC.PCT/100*ICOVER.AMOUNT THEN ICOVERNOC.PCT/100*ICOVER.AMOUNT ELSE ICOVERNOC.AMOUNT END        
       WHEN ICOVERNOC.AMOUNT<>0 THEN ICOVERNOC.AMOUNT        
       ELSE ICOVERNOC.PCT/100*ICOVER.AMOUNT        
       END*(CASE WHEN ICOVERNOC.MAXQTY=0 THEN 1 ELSE ICOVERNOC.MAXQTY END) AS AMOUNT_1        
        
       from ICOVER, TOI, ICOVERNOC, NOC, COLNOCCLASS, NOCTAB, ACCEPTANCE, COLTAB                 
       Where ICOVERNOC.INO=ICOVER.INO AND NOC.NOC=ICOVERNOC.NOC AND NOC.TOI=ICOVER.TOI        
          AND COLTAB.ICPSF=1 AND (COLTAB.COL=@P_COL or @P_COL='')
          AND COLNOCCLASS.NOC=NOC.NOC AND (COLNOCCLASS.COL=COLTAB.COL)
       AND ACCEPTANCE.ANO=ICOVER.ANO          
       AND ((Select Top 1 RCover.RetroActiveF from RCover Where RCover.ANO=Acceptance.ANO Order by RCover.RetroActiveF Desc)=1 or (ICOVERNOC.SDATE<=@P_LOSSDATE AND ACCEPTANCE.ExclusiveF=1) or ((ICOVERNOC.SDATE<@P_LOSSDATE or (ICOVERNOC.SDATE=@P_LOSSDATE AND ACCEPTANCE.STIME<=@P_LOSSTIME)) AND ACCEPTANCE.ExclusiveF=0))                             
       AND ((dbo.fn_Get_ExtPeriodDate(ACCEPTANCE.ExtPeriod, ACCEPTANCE.ExtPeriodInDaysF, ICOVERNOC.EDATE)>@P_LOSSDATE AND ACCEPTANCE.ExclusiveF=1) or ((dbo.fn_Get_ExtPeriodDate(ACCEPTANCE.ExtPeriod, ACCEPTANCE.ExtPeriodInDaysF, ICOVERNOC.EDATE)>@P_LOSSDATE or (dbo.fn_Get_ExtPeriodDate(ACCEPTANCE.ExtPeriod, ACCEPTANCE.ExtPeriodInDaysF, ICOVERNOC.EDATE)=@P_LOSSDATE AND ACCEPTANCE.ETIME>@P_LOSSTIME)) AND ACCEPTANCE.ExclusiveF=0))                                      
       AND ICOVER.ANO=@P_ANO AND TOI.TOI=ICOVER.TOI AND TOI.ICPSF=1                 
       and NOCTAB.NOC=NOC.NOC and NOCTAB.ICPSF=1 and NOC.CTLF=@P_CTLF                

       Union All                                
                                                            
       Select Distinct         
          COLTAB.COL,
       ICOVER.CATEGORY,         
       TOI.TOI,        
       ICOVER.CURRENCY,                              
       CASE                                
       WHEN RCOVER.PCTLOSS=0 OR ICOVER.NOTDECRF=1 OR ICOVER.NOTFLF=1 THEN ICOVER.AMOUNT         
       ELSE ICOVER.AMOUNT*RCOVER.PCTLOSS/100          
       END  AS AMOUNT_1        
       From RCOVER, Col, RATECOV, PCLASS, ICOVER, TOI, NOC, NOCTAB, COLNOCCLASS, ACCEPTANCE, COLTAB
       Where RCOVER.ANO=ICOVER.ANO AND ACCEPTANCE.ANO=RCOVER.ANO 
       AND (RCover.RetroActiveF=1 Or (RCOVER.SDATE<=@P_LOSSDATE AND ACCEPTANCE.ExclusiveF=1) or ((RCOVER.SDATE<@P_LOSSDATE or (RCOVER.SDATE=@P_LOSSDATE AND ACCEPTANCE.STIME<=@P_LOSSTIME)) AND ACCEPTANCE.ExclusiveF=0))                             
       AND ((dbo.fn_Get_ExtPeriodDate(ACCEPTANCE.ExtPeriod, ACCEPTANCE.ExtPeriodInDaysF, RCOVER.EDATE)>@P_LOSSDATE AND ACCEPTANCE.ExclusiveF=1) or ((dbo.fn_Get_ExtPeriodDate(ACCEPTANCE.ExtPeriod, ACCEPTANCE.ExtPeriodInDaysF, RCOVER.EDATE)>@P_LOSSDATE or (dbo.fn_Get_ExtPeriodDate(ACCEPTANCE.ExtPeriod, ACCEPTANCE.ExtPeriodInDaysF, RCOVER.EDATE)=@P_LOSSDATE AND ACCEPTANCE.ETIME>@P_LOSSTIME)) AND ACCEPTANCE.ExclusiveF=0))                            
       AND NOC.TOI=ICOVER.TOI         
       AND NOT EXISTS (SELECT TOP 1 ICOVERNOC.NOC FROM ICOVERNOC WHERE ICOVERNOC.INO=ICOVER.INO AND ICOVERNOC.NOC=NOC.NOC)                                
          AND COLTAB.ICPSF=1 AND (COLTAB.COL=@P_COL or @P_COL='')
          AND COLNOCCLASS.NOC=NOC.NOC AND (COLNOCCLASS.COL=COLTAB.COL)
          AND COL.COL=COLTAB.COL AND RATECOV.CODE=RCOVER.CODE AND RATECOV.TOR=COL.TOR AND PCLASS.TOR=COL.TOR AND PCLASS.TOI=ICOVER.TOI                          
       AND (PCLASS.CTLF=0 OR NOC.CTLF=PCLASS.CTLF)                   
       AND ICOVER.ANO=@P_ANO AND TOI.TOI=ICOVER.TOI AND TOI.ICPSF=1         
       and NOCTAB.NOC=NOC.NOC and NOCTAB.ICPSF=1 and NOC.CTLF=@P_CTLF        
       ) C        
) 
go



 insert into PatchVersioning
select '331 Update Script - ICPS_PolicyInterestLimit',GETDATE()
go


Declare @PrevScript varchar(100)
Declare @CurrScript varchar(100)

Select @PrevScript=''
Select @CurrSCript='331 Update Script - ICPS_PolicyInterestLimit'


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


