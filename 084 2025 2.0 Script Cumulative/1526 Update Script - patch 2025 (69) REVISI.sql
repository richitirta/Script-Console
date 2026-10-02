DROP PROCEDURE QCLACC_5 
GO
CREATE PROCEDURE QCLACC_5 (@P_POLICYNO AS VARCHAR(255), @P_CERTIFICATENO AS VARCHAR(255), @P_DATE AS SMALLDATETIME)   
AS   
SELECT TOP 1  A.PolicyNo, A.CERTIFICATENO, A.PDate  
From Acceptance A  
Left Join Acceptance mA on (mA.ANO=A.LANO)  
WHERE A.PolicyNo=@P_PolicyNo and A.CertificateNo LIKE @P_CertificateNo   
and A.AType in ('C') and A.AStatus in ('I') and A.ANO<>A.LANO 
and (A.PDate<@P_Date or (A.PDate=@P_Date and A.NOREFUNDF not in (1,2,3)))
and coalesce(mA.AStatus, A.AStatus) not in ('W','T')   

GO

DROP PROCEDURE QCLACC_4 
GO
CREATE PROCEDURE QCLACC_4 (@P_POLICYNO AS VARCHAR(255), @P_CERTIFICATENO AS VARCHAR(255), @P_DATE AS DATETIME, @P_LOSSTIME as varchar(5)='12:00')   
AS   
SELECT top 10 Acceptance.ANO, Acceptance.AName, Acceptance.PDate, Acceptance.PPDate, Acceptance.NCDate, Acceptance.TOC, Acceptance.Branch, Cover.IStype
From ACCEPTANCE
Inner Join COVER on (COVER.CNO=ACCEPTANCE.CNO)
Left Join Acceptance mA on (mA.ANO=Acceptance.lANO)
Left Join Acceptance nA on (nA.pANO=Acceptance.ANO and nA.AStatus not in ('W','T') and nA.AType not in ('A') and not (nA.AType='C' and nA.NOREFUNDF in (1,2,4) and nA.PDate=@P_Date))
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
	(dbo.fn_Get_ExtPeriodDate(ACCEPTANCE.ExtRPeriod, 0, dbo.fn_Get_ExtPeriodDate(ACCEPTANCE.ExtPeriod, ACCEPTANCE.ExtPeriodInDaysF, coalesce(nA.PDate, Acceptance.EDate)))>@P_DATE AND ACCEPTANCE.ExclusiveF=1) or 
	((dbo.fn_Get_ExtPeriodDate(ACCEPTANCE.ExtRPeriod, 0, dbo.fn_Get_ExtPeriodDate(ACCEPTANCE.ExtPeriod, ACCEPTANCE.ExtPeriodInDaysF, coalesce(nA.PDate, Acceptance.EDate)))>@P_DATE or 
	(dbo.fn_Get_ExtPeriodDate(ACCEPTANCE.ExtRPeriod, 0, dbo.fn_Get_ExtPeriodDate(ACCEPTANCE.ExtPeriod, ACCEPTANCE.ExtPeriodInDaysF, coalesce(nA.PDate, Acceptance.EDate)))=@P_DATE AND ACCEPTANCE.ETIME>@P_LOSSTIME)) AND ACCEPTANCE.ExclusiveF=0)
) 
AND
(
	Acceptance.PDate<Acceptance.PPDate
)
Order By ACCEPTANCE.ANO Desc   

GO


insert into PatchVersioning
select '1526 Update Script - patch 2025 (69) REVISI.sql',GETDATE()
go	
  
Declare @PrevScript varchar(100)
Declare @CurrScript varchar(100)

Select @PrevScript=''
Select @CurrSCript='1526 Update Script - patch 2025 (69) REVISI.sql'


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

