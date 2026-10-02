IF EXISTS ( SELECT * FROM   sysobjects WHERE  id = object_id(N'QCLACC02') and OBJECTPROPERTY(id, N'IsProcedure') = 1 )
BEGIN
DROP PROCEDURE QCLACC02 
END
GO
CREATE PROCEDURE QCLACC02 (@P_CNO AS INTEGER)   
AS   
SELECT DISTINCT CLAIM.CNO, CLAIM.REGDATE, CLAIM.ISTYPE, ACCDED.TOR, ACCDED.DCODE, Claim.Payment as Payment, ACCDED.REMARKS, ACCDED.REMARKS_1, ACCDED.CURRENCY   
From CLAIM, ACCDED, COL, ACCEPTANCE, RCALC, RCOVER
WHERE CLAIM.CNO=@P_CNO 
AND ACCDED.ANO=CLAIM.ANO AND ACCEPTANCE.ANO=ACCDED.ANO 
and RCalc.ANO=ACCDED.ANO and ACCDED.TOR=RCalc.TOR
and RCover.ANO=RCalc.ANO and RCover.Code=RCalc.Code and RCover.SDate=Rcalc.Sdate  
AND (RCover.RetroActiveF=1 or (ACCDED.SDATE<=CLAIM.LOSSDATE AND ACCEPTANCE.ExclusiveF=1) or ((ACCDED.SDATE<CLAIM.LOSSDATE or (ACCDED.SDATE=CLAIM.LOSSDATE AND ACCEPTANCE.STIME<=Claim.LossTime)) AND ACCEPTANCE.ExclusiveF=0))     
AND ((dbo.fn_Get_ExtPeriodDate(ACCEPTANCE.ExtPeriod, ACCEPTANCE.ExtPeriodInDaysF, ACCDED.EDATE)>CLAIM.LOSSDATE AND ACCEPTANCE.ExclusiveF=1) or ((dbo.fn_Get_ExtPeriodDate(ACCEPTANCE.ExtPeriod, ACCEPTANCE.ExtPeriodInDaysF, ACCDED.EDATE)>CLAIM.LOSSDATE or (dbo.fn_Get_ExtPeriodDate(ACCEPTANCE.ExtPeriod, ACCEPTANCE.ExtPeriodInDaysF, ACCDED.EDATE)=CLAIM.LOSSDATE AND ACCEPTANCE.STIME>Claim.LossTime)) AND ACCEPTANCE.ExclusiveF=0)) 
AND (RCover.RetroActiveF=1 or (RCalc.SDATE<=CLAIM.LOSSDATE AND ACCEPTANCE.ExclusiveF=1) or ((RCalc.SDATE<CLAIM.LOSSDATE or (RCalc.SDATE=CLAIM.LOSSDATE AND ACCEPTANCE.STIME<=Claim.LossTime)) AND ACCEPTANCE.ExclusiveF=0))     
AND ((dbo.fn_Get_ExtPeriodDate(ACCEPTANCE.ExtPeriod, ACCEPTANCE.ExtPeriodInDaysF, RCalc.EDATE)>CLAIM.LOSSDATE AND ACCEPTANCE.ExclusiveF=1) or ((dbo.fn_Get_ExtPeriodDate(ACCEPTANCE.ExtPeriod, ACCEPTANCE.ExtPeriodInDaysF, RCalc.EDATE)>CLAIM.LOSSDATE or (dbo.fn_Get_ExtPeriodDate(ACCEPTANCE.ExtPeriod, ACCEPTANCE.ExtPeriodInDaysF, RCalc.EDATE)=CLAIM.LOSSDATE AND ACCEPTANCE.STIME>Claim.LossTime)) AND ACCEPTANCE.ExclusiveF=0)) 
AND COL.COL=CLAIM.COL AND ACCDED.TOR=COL.TOR    

GO
if exists (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'FL_CL_DED') AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) )
BEGIN
DROP Function FL_CL_DED 
END
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
AND ((dbo.fn_Get_ExtPeriodDate(ACCEPTANCE.ExtPeriod, ACCEPTANCE.ExtPeriodInDaysF, ACCDED.EDATE)>CLAIM.LOSSDATE AND ACCEPTANCE.ExclusiveF=1) or ((dbo.fn_Get_ExtPeriodDate(ACCEPTANCE.ExtPeriod, ACCEPTANCE.ExtPeriodInDaysF, ACCDED.EDATE)>CLAIM.LOSSDATE or (dbo.fn_Get_ExtPeriodDate(ACCEPTANCE.ExtPeriod, ACCEPTANCE.ExtPeriodInDaysF, ACCDED.EDATE)=CLAIM.LOSSDATE AND ACCEPTANCE.STIME>Claim.LossTime)) AND ACCEPTANCE.ExclusiveF=0)) 
AND (RCover.RetroActiveF=1 or (RCalc.SDATE<=CLAIM.LOSSDATE AND ACCEPTANCE.ExclusiveF=1) or ((RCalc.SDATE<CLAIM.LOSSDATE or (RCalc.SDATE=CLAIM.LOSSDATE AND ACCEPTANCE.STIME<=Claim.LossTime)) AND ACCEPTANCE.ExclusiveF=0))     
AND ((dbo.fn_Get_ExtPeriodDate(ACCEPTANCE.ExtPeriod, ACCEPTANCE.ExtPeriodInDaysF, RCalc.EDATE)>CLAIM.LOSSDATE AND ACCEPTANCE.ExclusiveF=1) or ((dbo.fn_Get_ExtPeriodDate(ACCEPTANCE.ExtPeriod, ACCEPTANCE.ExtPeriodInDaysF, RCalc.EDATE)>CLAIM.LOSSDATE or (dbo.fn_Get_ExtPeriodDate(ACCEPTANCE.ExtPeriod, ACCEPTANCE.ExtPeriodInDaysF, RCalc.EDATE)=CLAIM.LOSSDATE AND ACCEPTANCE.STIME>Claim.LossTime)) AND ACCEPTANCE.ExclusiveF=0)) 
AND COL.COL=CLAIM.COL AND ACCDED.TOR=COL.TOR    
) 


GO

insert into PatchVersioning
select '55.42 Update Script - Patch 2020 (44)',GETDATE()
go


Declare @PrevScript varchar(100)
Declare @CurrScript varchar(100)

Select @PrevScript='55.41 Update Script - Patch 2020 (42)'
Select @CurrSCript='55.42 Update Script - Patch 2020 (44)'


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


