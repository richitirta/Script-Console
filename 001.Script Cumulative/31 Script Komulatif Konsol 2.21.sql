--6 nov 2017 (1)
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'ACCCNC') AND type in (N'U'))
BEGIN
CREATE TABLE ACCCNC(
	ANO int NULL,
	CNCNO varchar(50) NULL,
	CNCTYPE varchar(10) NULL,
	CNCISSUEDBY varchar(150) NULL,
	CNCISSUEDDATE smalldatetime NULL
) ON [PRIMARY]
END
GO


IF NOT EXISTS (SELECT *  FROM sys.indexes WHERE name='I_ACCCNC' AND object_id = OBJECT_ID('ACCCNC'))
BEGIN
CREATE UNIQUE INDEX I_ACCCNC ON ACCCNC(ANO, CNCNO)
END
GO

IF NOT EXISTS (SELECT *  FROM sys.indexes WHERE name='I_ACCCNC_ANO' AND object_id = OBJECT_ID('ACCCNC'))
BEGIN
CREATE INDEX I_ACCCNC_ANO ON ACCCNC(ANO)
END
GO



IF NOT EXISTS(SELECT * FROM SYSFORM WHERE FNAME='FORCECHECKCOFNOCLAIM')
BEGIN
insert into sysform(FName, Description, FCode)
Select 'FORCECHECKCOFNOCLAIM','FORCE CHECK CERTIFICATE OF NO CLAIM','ACTIVITIES'
END
GO

IF EXISTS ( SELECT * FROM   sysobjects WHERE  id = object_id(N'Drop_Acceptance_Link') and OBJECTPROPERTY(id, N'IsProcedure') = 1 )
BEGIN
DROP Procedure Drop_Acceptance_Link
END
GO
Create Procedure Drop_Acceptance_Link(@P_ANO as Int)    
AS     
Delete from RCALC Where ANO=@P_ANO    
Delete from AccDocStat Where ANO=@P_ANO    
Delete from AccSurplus Where ANO=@P_ANO    
Delete from ICalc Where ANO=@P_ANO    
Delete from AINFO Where ANO=@P_ANO    
Delete from AINFO_EXT Where ANO=@P_ANO  
Delete from AAccBS Where ANO=@P_ANO    
Delete from ACCDED Where ANO=@P_ANO    
Delete from ACCBS Where ANO=@P_ANO    
Delete from ACCASS Where ANO=@P_ANO    
Delete from ACCCON Where ANO=@P_ANO    
Delete from ACCPIC Where ANO=@P_ANO    
Delete from PCALC Where ANO=@P_ANO    
Delete from BusinessResult Where ANO=@P_ANO    
Delete from ACCEX Where ANO=@P_ANO    
Delete from RCOVER Where ANO=@P_ANO    
Delete from AccCA Where ANO=@P_ANO    
Delete from AccDA Where ANO=@P_ANO    
Delete from AccSgn Where ANO=@P_ANO    
Delete from ACCCLA Where ANO=@P_ANO    
Delete from ACCCOMPSHEETH Where ANO=@P_ANO    
Delete from ICOVER Where ANO=@P_ANO    
Delete from ACCSECTION Where ANO=@P_ANO    
Delete from ACCFD Where ANO=@P_ANO    
Delete from RARRHEADER Where ANO=@P_ANO    
Delete from ACCDEPOSIT Where ANO=@P_ANO    
Delete from PPrintLog Where ANO=@P_ANO    
Delete from RARRDET Where ANO=@P_ANO    
Delete from ACCSEARCH Where ANO=@P_ANO    
Delete from ACCDOCLIST Where ANO=@P_ANO    
Delete from ACCDOCLISTPIC Where ANO=@P_ANO    
Delete from PAYOR Where ANO=@P_ANO    
Delete from ACCCOLLATERAL Where ANO=@P_ANO    
Delete from APayor Where ANO=@P_ANO    
Delete from AccCard Where ANO=@P_ANO    
Delete from ACCEMPCONTH Where ANO=@P_ANO       
Delete from PNOTIFY Where ANO=@P_ANO      
Delete from PAYOR_SCHEDULE Where ANO=@P_ANO       
Delete from ACCDISCOUNT Where ANO=@P_ANO       
Delete from ACCCNC Where ANO=@P_ANO   
go

--6 nov 2017 (4)

IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'RefNo' AND Object_ID = Object_ID(N'CLDED'))
BEGIN
ALTER TABLE CLDED ADD RefNo varchar(50) NULL
END
GO



IF EXISTS ( SELECT * FROM   sysobjects WHERE  id = object_id(N'QDEDUCTIBLE_CALC') and OBJECTPROPERTY(id, N'IsProcedure') = 1 )
BEGIN
DROP PROCEDURE QDEDUCTIBLE_CALC 
END
GO
CREATE PROCEDURE QDEDUCTIBLE_CALC (@P_CNO AS integer, @P_DCODE AS Varchar(10))   
AS   
SELECT CNO, DEDCCY, DCODE, CURRENCY, MAX(PAYMENT) AS PAYMENT, MAX(REMARKS) AS REMARKS, MAX(FIXEDMIN) AS FIXEDMIN, MAX(FIXEDMAX) AS FIXEDMAX, SUM(DEDTSI) AS DEDTSI, SUM(DEDEST) AS DEDEST, SUM(DEDCL) AS DEDCL, SUM(LOSSESTIMATE) as LOSSESTIMATE, SUM(LOSSCLAIM) AS LOSSCLAIM   
From   
(   
SELECT CLAIM.CNO,   
CLLOSS.CURRENCY AS DEDCCY,   
ACCDED.DCODE,   
ACCDED.CURRENCY,   
CLLOSS.INO,   
MAX(CASE WHEN RCOVER.CATEGORY='M' THEN CLAIM.PAYMENT ELSE '' END) as PAYMENT,   
MAX(ACCDED.REMARKS) AS REMARKS,   
MAX(ACCDED.FIXEDMIN) AS FIXEDMIN,   
MAX(ACCDED.FIXEDMAX) AS FIXEDMAX,   
MAX(Case When ACCDED.STRTSI='TSI' THEN PCALC.TSI ELSE CLLOSS.DECLARED END*ACCDED.PCTTSI*.01*CLLOSS.RATE*(1-RCOVER.COSHARE/100)) AS DEDTSI,   
SUM(CLLOSS.ESTIMATE*ACCDED.PCTCL*.01*(1-RCOVER.COSHARE/100)) AS DEDEST,   
SUM(CLLOSS.Amount * ACCDED.PCTCL * 0.01 * (1 - RCOVER.COSHARE / 100)) As DEDCL,   
SUM(CLLOSS.ESTIMATE) AS LOSSESTIMATE,   
SUM(CLLOSS.Amount) As LOSSCLAIM   
From CLAIM, ACCEPTANCE, ACCDED, CLLOSS, RCOVER, Col, PCLASS, RATECOV, PCALC, DEDTAB
Where   
CLAIM.CNO=@P_CNO   
AND ACCEPTANCE.ANO=CLAIM.ANO   
AND ACCDED.ANO=CLAIM.ANO   
AND ACCDED.DCODE=@P_DCODE   
AND DEDTAB.DCODE=@P_DCODE AND (DEDTAB.CTLF=CLLOSS.CTLF)
AND RCOVER.ANO=CLAIM.ANO   
AND ((ACCDED.SDATE<=CLAIM.LOSSDATE AND ACCEPTANCE.ExclusiveF=1) or ((ACCDED.SDATE<CLAIM.LOSSDATE or (ACCDED.SDATE=CLAIM.LOSSDATE AND '12:00'<=Claim.LossTime)) AND ACCEPTANCE.ExclusiveF=0))   
AND ((dbo.fn_Get_ExtPeriodDate(ACCEPTANCE.ExtPeriod, ACCEPTANCE.ExtPeriodInDaysF, ACCDED.EDATE)>CLAIM.LOSSDATE AND ACCEPTANCE.ExclusiveF=1) or ((dbo.fn_Get_ExtPeriodDate(ACCEPTANCE.ExtPeriod, ACCEPTANCE.ExtPeriodInDaysF, ACCDED.EDATE)>CLAIM.LOSSDATE or (dbo.fn_Get_ExtPeriodDate(ACCEPTANCE.ExtPeriod, ACCEPTANCE.ExtPeriodInDaysF, ACCDED.EDATE)=CLAIM.LOSSDATE AND '12:00'>Claim.LossTime)) AND ACCEPTANCE.ExclusiveF=0))   
AND ((RCOVER.SDATE<=CLAIM.LOSSDATE AND ACCEPTANCE.ExclusiveF=1) or ((RCOVER.SDATE<CLAIM.LOSSDATE or (RCOVER.SDATE=CLAIM.LOSSDATE AND '12:00'<=Claim.LossTime)) AND ACCEPTANCE.ExclusiveF=0))   
AND ((dbo.fn_Get_ExtPeriodDate(ACCEPTANCE.ExtPeriod, ACCEPTANCE.ExtPeriodInDaysF, RCOVER.EDATE)>CLAIM.LOSSDATE AND ACCEPTANCE.ExclusiveF=1) or ((dbo.fn_Get_ExtPeriodDate(ACCEPTANCE.ExtPeriod, ACCEPTANCE.ExtPeriodInDaysF, RCOVER.EDATE)>CLAIM.LOSSDATE or (dbo.fn_Get_ExtPeriodDate(ACCEPTANCE.ExtPeriod, ACCEPTANCE.ExtPeriodInDaysF, RCOVER.EDATE)=CLAIM.LOSSDATE AND '12:00'>Claim.LossTime)) AND ACCEPTANCE.ExclusiveF=0))   
AND CLLOSS.CNO=CLAIM.CNO   
AND RATECOV.CODE=RCOVER.CODE   
AND RATECOV.TOR=ACCDED.TOR   
AND COL.COL=CLAIM.COL   
AND COL.TOR=ACCDED.TOR   
AND PCLASS.TOR=COL.TOR   
AND PCLASS.TOI=CLLOSS.TOI   
AND PCALC.ANO=ACCDED.ANO   
AND PCALC.Currency=CLLOSS.Currency_OC   
AND (ACCDED.PCTTSI<>0 or ACCDED.PCTCL<>0 or (ACCDED.CURRENCY<>'' AND (ACCDED.FIXEDMIN<>0 or ACCDED.FIXEDMAX<>0)))   
GROUP BY CLAIM.CNO, CLLOSS.CURRENCY, ACCDED.DCODE, ACCDED.CURRENCY, CLLOSS.INO   
) DEDUCTIBLE   
GROUP BY CNO, DEDCCY, DCODE,CURRENCY   
   

go

--VERSIONING
insert into versioning
select '2017 V.2.21.0',GETDATE(),'2017 V.2.0.0',GETDATE(),'K: 2017 V.2.0.0',GETDATE()
go


Declare @PrevScript varchar(100)
Declare @CurrScript varchar(100)

Select @PrevScript='30 Script Komulatif Konsol 2.20'
Select @CurrSCript='31 Script Komulatif Konsol 2.21'


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
