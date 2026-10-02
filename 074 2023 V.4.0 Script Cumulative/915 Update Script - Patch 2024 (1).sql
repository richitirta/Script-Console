DROP Function FL_CL_DED 
GO
Create Function FL_CL_DED (@P_CNO AS INTEGER)   
RETURNS TABLE   
AS RETURN  (   
--QCLACC02   
SELECT DISTINCT CLAIM.CNO, CLAIM.REGDATE, CLAIM.ISTYPE, ACCDED.TOR, ACCDED.DCODE, Claim.Payment as Payment, ACCDED.REMARKS, ACCDED.REMARKS_1, ACCDED.CURRENCY     
From CLAIM, ACCDED, COL, ACCEPTANCE, RCALC, RCOVER  
WHERE CLAIM.CNO=@P_CNO   
AND ACCDED.ANO=CLAIM.ANO AND ACCEPTANCE.ANO=ACCDED.ANO   
and RCalc.ANO=ACCDED.ANO and ACCDED.TOR=RCalc.TOR  
and RCover.ANO=RCalc.ANO and RCover.Code=RCalc.Code and RCover.SDate=Rcalc.Sdate    
AND (RCover.RetroActiveF=1 or (ACCDED.SDATE<=CLAIM.LOSSDATE AND ACCEPTANCE.ExclusiveF=1) or ((ACCDED.SDATE<CLAIM.LOSSDATE or (ACCDED.SDATE=CLAIM.LOSSDATE AND ACCEPTANCE.STIME<=Claim.LossTime)) AND ACCEPTANCE.ExclusiveF=0))       
AND ((dbo.fn_Get_ExtPeriodDate(ACCEPTANCE.ExtRPeriod, 0, dbo.fn_Get_ExtPeriodDate(ACCEPTANCE.ExtPeriod, ACCEPTANCE.ExtPeriodInDaysF, ACCDED.EDATE))>CLAIM.LOSSDATE AND ACCEPTANCE.ExclusiveF=1) or ((dbo.fn_Get_ExtPeriodDate(ACCEPTANCE.ExtRPeriod, 0, dbo.fn_Get_ExtPeriodDate(ACCEPTANCE.ExtPeriod, ACCEPTANCE.ExtPeriodInDaysF, ACCDED.EDATE))>CLAIM.LOSSDATE or (dbo.fn_Get_ExtPeriodDate(ACCEPTANCE.ExtRPeriod, 0, dbo.fn_Get_ExtPeriodDate(ACCEPTANCE.ExtPeriod, ACCEPTANCE.ExtPeriodInDaysF, ACCDED.EDATE))=CLAIM.LOSSDATE AND ACCEPTANCE.ETime>Claim.LossTime)) AND ACCEPTANCE.ExclusiveF=0))   
AND (RCover.RetroActiveF=1 or (RCalc.SDATE<=CLAIM.LOSSDATE AND ACCEPTANCE.ExclusiveF=1) or ((RCalc.SDATE<CLAIM.LOSSDATE or (RCalc.SDATE=CLAIM.LOSSDATE AND ACCEPTANCE.STIME<=Claim.LossTime)) AND ACCEPTANCE.ExclusiveF=0))       
AND ((dbo.fn_Get_ExtPeriodDate(ACCEPTANCE.ExtRPeriod, 0, dbo.fn_Get_ExtPeriodDate(ACCEPTANCE.ExtPeriod, ACCEPTANCE.ExtPeriodInDaysF, RCalc.EDATE))>CLAIM.LOSSDATE AND ACCEPTANCE.ExclusiveF=1) or ((dbo.fn_Get_ExtPeriodDate(ACCEPTANCE.ExtRPeriod, 0, dbo.fn_Get_ExtPeriodDate(ACCEPTANCE.ExtPeriod, ACCEPTANCE.ExtPeriodInDaysF, RCalc.EDATE))>CLAIM.LOSSDATE or (dbo.fn_Get_ExtPeriodDate(ACCEPTANCE.ExtRPeriod, 0, dbo.fn_Get_ExtPeriodDate(ACCEPTANCE.ExtPeriod, ACCEPTANCE.ExtPeriodInDaysF, RCalc.EDATE))=CLAIM.LOSSDATE AND ACCEPTANCE.ETime>Claim.LossTime)) AND ACCEPTANCE.ExclusiveF=0))   
AND COL.COL=CLAIM.COL AND ACCDED.TOR=COL.TOR      
)   
GO

DROP PROCEDURE QCLACC02 
GO
CREATE PROCEDURE QCLACC02 (@P_CNO AS INTEGER)     
AS     
SELECT DISTINCT CLAIM.CNO, CLAIM.REGDATE, CLAIM.ISTYPE, ACCDED.TOR, ACCDED.DCODE, Claim.Payment as Payment, ACCDED.REMARKS, ACCDED.REMARKS_1, CASE WHEN ACCDED.CURRENCY='' THEN RCALC.CURRENCY ELSE ACCDED.CURRENCY END as CURRENCY  
From CLAIM  
Inner Join COL on (COL.COL=Claim.COL)  
Inner Join Acceptance on (Acceptance.ANO=Claim.ANO)  
Inner Join RCover on (RCover.ANO=Claim.ANO)  
Inner Join RCalc on (RCalc.ANO=RCover.ANO and RCalc.Code=RCover.Code and Rcalc.SDate=RCover.Sdate and RCalc.TOR=COL.TOR)  
Inner Join AccDed on (AccDed.ANO=Claim.ANO and ACCDED.TOR=COL.TOR)  
WHERE CLAIM.CNO=@P_CNO   
AND (RCover.RetroActiveF=1 or (ACCDED.SDATE<=CLAIM.LOSSDATE AND ACCEPTANCE.ExclusiveF=1) or ((ACCDED.SDATE<CLAIM.LOSSDATE or (ACCDED.SDATE=CLAIM.LOSSDATE AND ACCEPTANCE.STIME<=Claim.LossTime)) AND ACCEPTANCE.ExclusiveF=0))       
AND ((dbo.fn_Get_ExtPeriodDate(ACCEPTANCE.ExtRPeriod, 0, dbo.fn_Get_ExtPeriodDate(ACCEPTANCE.ExtPeriod, ACCEPTANCE.ExtPeriodInDaysF, ACCDED.EDATE))>CLAIM.LOSSDATE AND ACCEPTANCE.ExclusiveF=1) or ((dbo.fn_Get_ExtPeriodDate(ACCEPTANCE.ExtRPeriod, 0, dbo.fn_Get_ExtPeriodDate(ACCEPTANCE.ExtPeriod, ACCEPTANCE.ExtPeriodInDaysF, ACCDED.EDATE))>CLAIM.LOSSDATE or (dbo.fn_Get_ExtPeriodDate(ACCEPTANCE.ExtRPeriod, 0, dbo.fn_Get_ExtPeriodDate(ACCEPTANCE.ExtPeriod, ACCEPTANCE.ExtPeriodInDaysF, ACCDED.EDATE))=CLAIM.LOSSDATE AND ACCEPTANCE.ETime>Claim.LossTime)) AND ACCEPTANCE.ExclusiveF=0))   
AND (RCover.RetroActiveF=1 or (RCalc.SDATE<=CLAIM.LOSSDATE AND ACCEPTANCE.ExclusiveF=1) or ((RCalc.SDATE<CLAIM.LOSSDATE or (RCalc.SDATE=CLAIM.LOSSDATE AND ACCEPTANCE.STIME<=Claim.LossTime)) AND ACCEPTANCE.ExclusiveF=0))       
AND ((dbo.fn_Get_ExtPeriodDate(ACCEPTANCE.ExtRPeriod, 0, dbo.fn_Get_ExtPeriodDate(ACCEPTANCE.ExtPeriod, ACCEPTANCE.ExtPeriodInDaysF, RCalc.EDATE))>CLAIM.LOSSDATE AND ACCEPTANCE.ExclusiveF=1) or ((dbo.fn_Get_ExtPeriodDate(ACCEPTANCE.ExtRPeriod, 0, dbo.fn_Get_ExtPeriodDate(ACCEPTANCE.ExtPeriod, ACCEPTANCE.ExtPeriodInDaysF, RCalc.EDATE))>CLAIM.LOSSDATE or (dbo.fn_Get_ExtPeriodDate(ACCEPTANCE.ExtRPeriod, 0, dbo.fn_Get_ExtPeriodDate(ACCEPTANCE.ExtPeriod, ACCEPTANCE.ExtPeriodInDaysF, RCalc.EDATE))=CLAIM.LOSSDATE AND ACCEPTANCE.ETime>Claim.LossTime)) AND ACCEPTANCE.ExclusiveF=0))   
  
GO  



insert into PatchVersioning
select '915 Update Script - Patch 2024 (1)',GETDATE()
go


Declare @PrevScript varchar(100)
Declare @CurrScript varchar(100)

Select @PrevScript=''
Select @CurrSCript='915 Update Script - Patch 2024 (1)'


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

