DROP PROCEDURE List20 
GO
CREATE PROCEDURE List20 (@P_USERID as varchar(255),@P_SDate as smalldatetime, @P_EDate as smalldatetime,@P_AStatus as varchar(1))     
AS     
SELECT     
Cast(0 as bit) as ProcessFlag,     
Cover.COVERNO,     
Cast(Acceptance.AName as varchar(128)) as Insured,     
Cover.CNO,     
Cover.CStatus,     
Acceptance.lANO,     
Acceptance.ANO,     
Acceptance.REGNO,     
Acceptance.ADATE,     
Acceptance.LUSERID as USERID,     
SysTab.Currency,     
Acceptance.ASTATUS,     
Acceptance.ATYPE,     
Acceptance.SDate,     
Acceptance.EDate,     
Year(Coalesce(RArrHeader.RDate,Acceptance.SDate)) AS RYear,     
Cover.ISType,     
Acceptance.Renewal,     
Acceptance.ESeqNo,     
Acceptance.PolicyNo,     
Acceptance.CertificateNo,     
PCALC.TSI,  
PCALC.OURSHARE,  
PCALC.GROSS
FROM  Acceptance   
left Join RArrHeader on (RArrHeader.ANO=Acceptance.ANO)  
Inner join Cover on (Cover.CNO=Acceptance.CNO)  
Inner Join SysTab on (1=1)  
Outer Apply (
	SELECT 
	coalesce(SUM(PCALC.TSI*PCALC.RATE),0)*CASE WHEN ACCEPTANCE.QTY=0 THEN 1 ELSE ACCEPTANCE.QTY END as TSI,
	coalesce(SUM(PCALC.OURSHARE*PCALC.RATE),0)*CASE WHEN ACCEPTANCE.QTY=0 THEN 1 ELSE ACCEPTANCE.QTY END as OURSHARE,
	coalesce(SUM(PCALC.GROSS*PCALC.RATE),0)*CASE WHEN ACCEPTANCE.QTY=0 THEN 1 ELSE ACCEPTANCE.QTY END as GROSS
	FROM  PCALC 
	WHERE PCALC.ANO=ACCEPTANCE.ANO AND ACCEPTANCE.PSTATUS='C'
) PCALC
WHERE Cover.ISType<>'T'  and (Acceptance.ANO=Acceptance.LANO or Acceptance.LANO=-1)   
And Acceptance.LUserID Like @P_UserID  
And Acceptance.LDate between @P_SDate and @P_EDate 
And (Acceptance.AStatus=@P_AStatus or @P_AStatus='')

Union

SELECT  
Cast(0 as bit) as ProcessFlag,     
Cover.COVERNO,     
Cast(Acceptance.AName as varchar(128)) as Insured,     
Cover.CNO,     
Cover.CStatus,     
Acceptance.lANO,     
Acceptance.ANO,     
Acceptance.REGNO,     
Acceptance.ADATE,     
Acceptance.LUSERID as USERID,     
SysTab.Currency,     
Acceptance.ASTATUS,     
Acceptance.ATYPE,     
Acceptance.SDate,     
Acceptance.EDate,     
Year(Coalesce(RArrHeader.RDate,Acceptance.SDate)) AS RYear,     
Cover.ISType,     
Acceptance.Renewal,     
Acceptance.ESeqNo,     
Acceptance.PolicyNo,     
Acceptance.CertificateNo,     
cast(0 as Float) as TSI,
cast(0 as Float) as OurShare,
cast(0 as Float) as Gross
FROM  Acceptance   
left Join RArrHeader on (RArrHeader.ANO=Acceptance.ANO)  
Inner join Cover on (Cover.CNO=Acceptance.CNO)  
Inner Join SysTab on (1=1)  
WHERE Cover.ISType<>'T'
And Exists   
(   
  Select Top 1 Acceptance_Detail.LANO   
  from Acceptance as Acceptance_Detail     
  Where Acceptance_Detail.LANO=Acceptance.ANO and Acceptance_Detail.LANO<>Acceptance_Detail.ANO   
  And Acceptance_Detail.LUserID Like @P_UserID     
  And Acceptance_Detail.LDate between @P_SDate and @P_EDate     
  And (Acceptance_Detail.AStatus=@P_AStatus or @P_AStatus='')     
)   
GO



insert into PatchVersioning
select '1090 Update Script - Patch 2024 (41)',GETDATE()
go
	

Declare @PrevScript varchar(100)
Declare @CurrScript varchar(100)

Select @PrevScript=''
Select @CurrSCript='1090 Update Script - Patch 2024 (41)'


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
