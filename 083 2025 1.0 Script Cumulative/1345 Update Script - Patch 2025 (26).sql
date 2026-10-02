SET QUOTED_IDENTIFIER ON
SET ARITHABORT ON
SET NUMERIC_ROUNDABORT OFF
SET CONCAT_NULL_YIELDS_NULL ON
SET ANSI_NULLS ON
SET ANSI_PADDING ON
SET ANSI_WARNINGS ON

IF EXISTS ( SELECT * FROM   sysobjects WHERE  id = object_id(N'QCLACC_4') and OBJECTPROPERTY(id, N'IsProcedure') = 1 )
BEGIN DROP PROCEDURE QCLACC_4  END 
GO

CREATE PROCEDURE QCLACC_4 (@P_POLICYNO AS VARCHAR(255), @P_CERTIFICATENO AS VARCHAR(255), @P_DATE AS DATETIME, @P_LOSSTIME as varchar(5)='12:00')   
AS   
SELECT top 10 Acceptance.ANO, Acceptance.AName, Acceptance.PDate, Acceptance.PPDate, Acceptance.NCDate, Acceptance.TOC, Acceptance.Branch, Cover.IStype
From ACCEPTANCE
Inner Join COVER on (COVER.CNO=ACCEPTANCE.CNO)
Left Join Acceptance mA on (mA.ANO=Acceptance.lANO)
WHERE ACCEPTANCE.POLICYNO LIKE @P_POLICYNO AND ACCEPTANCE.CERTIFICATENO LIKE @P_CERTIFICATENO 
AND COVER.CStatus not in ('R','P','C') AND ACCEPTANCE.AType Not in ('A','C') AND ACCEPTANCE.AStatus not in ('W','T') AND ACCEPTANCE.ANO<>ACCEPTANCE.LANO   
and coalesce(mA.AStatus, Acceptance.AStatus) not in ('W','T') 
AND 
(
	(Select Top 1 RCover.RetroActiveF from RCover Where RCover.ANO=Acceptance.ANO Order by RCover.RetroActiveF Desc)=1 or
	(ACCEPTANCE.PDATE<=@P_DATE AND ACCEPTANCE.ExclusiveF=1) or 
	((ACCEPTANCE.PDATE<@P_DATE or (ACCEPTANCE.PDATE=@P_DATE AND ACCEPTANCE.STIME<=@P_LOSSTIME)) AND ACCEPTANCE.ExclusiveF=0)
)             
AND 
(
	(dbo.fn_Get_ExtPeriodDate(ACCEPTANCE.ExtRPeriod, 0, dbo.fn_Get_ExtPeriodDate(ACCEPTANCE.ExtPeriod, ACCEPTANCE.ExtPeriodInDaysF, ACCEPTANCE.PPDATE))>@P_DATE AND ACCEPTANCE.ExclusiveF=1) or 
	((dbo.fn_Get_ExtPeriodDate(ACCEPTANCE.ExtRPeriod, 0, dbo.fn_Get_ExtPeriodDate(ACCEPTANCE.ExtPeriod, ACCEPTANCE.ExtPeriodInDaysF, ACCEPTANCE.PPDATE))>@P_DATE or 
	(dbo.fn_Get_ExtPeriodDate(ACCEPTANCE.ExtRPeriod, 0, dbo.fn_Get_ExtPeriodDate(ACCEPTANCE.ExtPeriod, ACCEPTANCE.ExtPeriodInDaysF, ACCEPTANCE.PPDATE))=@P_DATE AND ACCEPTANCE.ETIME>@P_LOSSTIME)) AND ACCEPTANCE.ExclusiveF=0)
) 
AND
(
	Acceptance.PDate<Acceptance.PPDate
)
Order By ACCEPTANCE.ANO Desc   
GO

insert into PatchVersioning
select '1345 Update Script - Patch 2025 (26)',GETDATE()
go	
  

Declare @PrevScript varchar(100)
Declare @CurrScript varchar(100)

Select @PrevScript=''
Select @CurrSCript='1345 Update Script - Patch 2025 (26)'


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