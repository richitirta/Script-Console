DROP PROCEDURE List03
GO
CREATE  PROCEDURE List03(@P_USERID as varchar(255))   
AS   
SELECT Cast(0 as bit) as ProcessFlag,   
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
PCALC.TSI, 
PCALC.OURSHARE, 
PCALC.GROSS, 
Acceptance.ASTATUS,   
Acceptance.ATYPE,   
Acceptance.SDate,   
Acceptance.EDate,   
Year(Coalesce(RArrHeader.RDate,Acceptance.SDate)) AS RYear,   
Cover.ISType,   
Acceptance.Renewal,   
Acceptance.ESeqNo,   
Acceptance.PolicyNo,   
Acceptance.CertificateNo   
FROM  Acceptance 
Left Join RArrHeader on (RArrHeader.ANO=Acceptance.ANO)
Inner Join Cover on (Cover.CNO=Acceptance.CNO)
Inner Join SysTab on (1=1)
Outer Apply (
	Select 
	coalesce(SUM(PCALC.TSI*PCALC.RATE),0)*CASE WHEN ACCEPTANCE.QTY=0 THEN 1 ELSE ACCEPTANCE.QTY END as TSI,
	coalesce(SUM(PCALC.OURSHARE*PCALC.RATE),0)*CASE WHEN ACCEPTANCE.QTY=0 THEN 1 ELSE ACCEPTANCE.QTY END as OURSHARE,
	coalesce(SUM(PCALC.GROSS*PCALC.RATE),0)*CASE WHEN ACCEPTANCE.QTY=0 THEN 1 ELSE ACCEPTANCE.QTY END as GROSS
	FROM PCALC WHERE PCALC.ANO=ACCEPTANCE.ANO AND ACCEPTANCE.PSTATUS='C'
) PCALC
WHERE  (Acceptance.ANO=Acceptance.LANO Or Acceptance.LANO=-1)   
And Acceptance.AStatus in ('W','T')   
And Cover.ISType<>'T'   
And Acceptance.LUserID Like @P_UserID   
   
union   
   
SELECT Cast(0 as bit) as ProcessFlag,   
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
cast(0 as Float) as TSI,
cast(0 as Float) as OurShare,
cast(0 as Float) as Gross,
Acceptance.ASTATUS,   
Acceptance.ATYPE,   
Acceptance.SDate,   
Acceptance.EDate,   
Year(Coalesce(RArrHeader.RDate,Acceptance.SDate)) AS RYear,   
Cover.ISType,   
Acceptance.Renewal,   
Acceptance.ESeqNo,   
Acceptance.PolicyNo,   
Acceptance.CertificateNo   
FROM  Acceptance 
Left Join RArrHeader on (RArrHeader.ANO=Acceptance.ANO)
Inner Join Cover on (Cover.CNO=Acceptance.CNO)
Inner Join SysTab on (1=1)
WHERE  Exists   
(   
Select Top 1 Acceptance_Detail.LANO from Acceptance as Acceptance_Detail   
Where Acceptance_Detail.LANO=Acceptance.ANO and Acceptance_Detail.LANO<>Acceptance_Detail.ANO 
And Acceptance_Detail.AStatus in ('W','T')   
And Cover.ISType<>'T'  
and Acceptance_Detail.LUserID Like @P_UserID  
)   
   
        
GO


DROP FUNCTION List03_Det
GO
CREATE FUNCTION List03_Det (@P_ANO as integer, @P_USERID as varchar(255)) 
RETURNS TABLE 
AS RETURN( 
 
SELECT Cast(0 as bit) as ProcessFlag,
Acceptance.CertificateNo, 
Acceptance.RefNo, 
Acceptance.ESeqNo,
Acceptance.ERSeqNo,
Cast(Acceptance.AName as varchar(128)) as AName,  
Acceptance.ANO, 
Acceptance.REGNO, 
Acceptance.ADATE, 
Acceptance.LUSERID as UserID, 
SysTab.Currency, 
PCALC.TSI, 
PCALC.OURSHARE, 
PCALC.GROSS, 
Acceptance.ASTATUS, 
Acceptance.ATYPE, 
Acceptance.SDate, 
Acceptance.EDate, 
Year(RArrheader.Rdate) AS RYear,
Acceptance.ValueID,
dbo.get_objectInfo(Acceptance.ANO) as ValueDesc,
Acceptance.BatchNo
FROM Acceptance
Inner Join RArrHeader on (RArrHeader.ANO=Acceptance.ANO)
Inner Join Cover on (Cover.CNO=Acceptance.CNO)
Inner Join SysTab on (1=1)
Outer Apply (
	Select 
	coalesce(SUM(PCALC.TSI*PCALC.RATE),0)*CASE WHEN ACCEPTANCE.QTY=0 THEN 1 ELSE ACCEPTANCE.QTY END as TSI,
	coalesce(SUM(PCALC.OURSHARE*PCALC.RATE),0)*CASE WHEN ACCEPTANCE.QTY=0 THEN 1 ELSE ACCEPTANCE.QTY END as OURSHARE,
	coalesce(SUM(PCALC.GROSS*PCALC.RATE),0)*CASE WHEN ACCEPTANCE.QTY=0 THEN 1 ELSE ACCEPTANCE.QTY END as GROSS
	FROM PCALC WHERE PCALC.ANO=ACCEPTANCE.ANO AND ACCEPTANCE.PSTATUS='C'
) PCALC
WHERE 
Acceptance.ANO<>Acceptance.LANO 
And Acceptance.LANO=@P_ANO 
And Acceptance.AStatus in ('W','T') 
And Cover.ISType<>'T' 
And Acceptance.LUserID Like @P_UserID 
 
) 
 
GO 

DROP PROCEDURE List_Spc_03
GO
CREATE PROCEDURE List_Spc_03
AS  
SELECT Cast(0 as bit) as ProcessFlag,   
 Cover.COVERNO,   
 Cast(Acceptance.AName as varchar(128)) as Insured,   
 Cover.CNO,   
 Cover.CStatus,   
 Acceptance.lANO,   
 Acceptance.ANO,   
 Acceptance.REGNO,   
 Acceptance.ADATE,   
 Acceptance.USERID,   
 SysTab.Currency,   
 PCALC.TSI, 
 PCALC.OURSHARE, 
 PCALC.GROSS, 
 Acceptance.ASTATUS,   
 Acceptance.ATYPE,   
 Acceptance.SDate,   
 Acceptance.EDate,   
 Year(Acceptance.SDate) AS RYear,   
 Cover.ISType,   
 Acceptance.Renewal,   
 Acceptance.ESeqNo,   
 Acceptance.PolicyNo,   
 Acceptance.CertificateNo  
FROM  Acceptance 
Left Join RArrHeader on (RArrHeader.ANO=Acceptance.ANO)
Inner Join Cover on (Cover.CNO=Acceptance.CNO)
Inner Join TOC on (TOC.TOC=Acceptance.TOC)
Inner Join SysTab on (1=1)
Outer Apply (
	Select 
	coalesce(SUM(PCALC.TSI*PCALC.RATE),0)*CASE WHEN ACCEPTANCE.QTY=0 THEN 1 ELSE ACCEPTANCE.QTY END as TSI,
	coalesce(SUM(PCALC.OURSHARE*PCALC.RATE),0)*CASE WHEN ACCEPTANCE.QTY=0 THEN 1 ELSE ACCEPTANCE.QTY END as OURSHARE,
	coalesce(SUM(PCALC.GROSS*PCALC.RATE),0)*CASE WHEN ACCEPTANCE.QTY=0 THEN 1 ELSE ACCEPTANCE.QTY END as GROSS
	FROM PCALC WHERE PCALC.ANO=ACCEPTANCE.ANO AND ACCEPTANCE.PSTATUS='C'
) PCALC
WHERE    
 (Acceptance.ANO=Acceptance.LANO Or Acceptance.LANO=-1)   
 And Acceptance.AStatus in ('W','T','I') and Acceptance.AType<>'C'  
 and TOC.ConsortiumF=1
 And RArrHeader.FAmount=0  
  
  
union  
  
SELECT Cast(0 as bit) as ProcessFlag,   
 Cover.COVERNO,   
 Cast(Acceptance.AName as varchar(128)) as Insured,   
 Cover.CNO,   
 Cover.CStatus,   
 Acceptance.lANO,   
 Acceptance.ANO,   
 Acceptance.REGNO,   
 Acceptance.ADATE,   
 Acceptance.USERID,   
 SysTab.Currency,   
 cast(0 as Float) as TSI,
 cast(0 as Float) as OurShare,
 cast(0 as Float) as Gross,
 Acceptance.ASTATUS,   
 Acceptance.ATYPE,   
 Acceptance.SDate,   
 Acceptance.EDate,   
 Year(Acceptance.SDate) AS RYear,   
 Cover.ISType,   
 Acceptance.Renewal,   
 Acceptance.ESeqNo,   
 Acceptance.PolicyNo,   
 Acceptance.CertificateNo  
FROM  Acceptance 
Left Join RArrHeader on (RArrHeader.ANO=Acceptance.ANO)
Inner Join Cover on (Cover.CNO=Acceptance.CNO)
Inner Join SysTab on (1=1)
WHERE Exists (   
	Select Top 1 Acceptance_Detail.LANO 
	from Acceptance as Acceptance_Detail
	Inner Join RarrHeader on (RArrHeader.ANO=Acceptance_Detail.ANO)
	Inner Join TOC on (TOC.TOC=Acceptance_Detail.TOC)
	Where Acceptance_Detail.LANO=Acceptance.ANO and Acceptance_Detail.LANO<>Acceptance_Detail.ANO 
	 And Acceptance_Detail.AStatus in ('W','T','I') and Acceptance_Detail.AType<>'C'  
	 and TOC.ConsortiumF=1
	 And RArrHeader.FAmount=0  
)  
GO

DROP FUNCTION List_Spc_03_Det
GO
CREATE  FUNCTION List_Spc_03_Det (@P_ANO AS INTEGER)   
RETURNS TABLE  
AS RETURN(  
SELECT Cast(0 as bit) as ProcessFlag,
	Acceptance.CertificateNo, 
	Acceptance.RefNo, 
	Acceptance.ESeqNo,
	Acceptance.ERSeqNo,
	Cast(Acceptance.AName as varchar(128)) as AName,  
	Acceptance.ANO, 
	Acceptance.REGNO, 
	Acceptance.ADATE, 
	Acceptance.LUSERID as UserID, 
	SysTab.Currency, 
	PCALC.TSI, 
	PCALC.OURSHARE, 
	PCALC.GROSS, 
	Acceptance.ASTATUS, 
	Acceptance.ATYPE, 
	Acceptance.SDate, 
	Acceptance.EDate, 
	Year(RArrheader.Rdate) AS RYear,
 	Acceptance.ValueID,
 	dbo.get_objectInfo(Acceptance.ANO) as ValueDesc,
	Acceptance.BatchNo
FROM Acceptance
Inner Join RArrHeader on (RArrHeader.ANO=Acceptance.ANO)
Inner Join Cover on (Cover.CNO=Acceptance.CNO)
Inner Join TOC on (TOC.TOC=Acceptance.TOC)
Inner Join SysTab on (1=1)
Outer Apply (
	Select 
	coalesce(SUM(PCALC.TSI*PCALC.RATE),0)*CASE WHEN ACCEPTANCE.QTY=0 THEN 1 ELSE ACCEPTANCE.QTY END as TSI,
	coalesce(SUM(PCALC.OURSHARE*PCALC.RATE),0)*CASE WHEN ACCEPTANCE.QTY=0 THEN 1 ELSE ACCEPTANCE.QTY END as OURSHARE,
	coalesce(SUM(PCALC.GROSS*PCALC.RATE),0)*CASE WHEN ACCEPTANCE.QTY=0 THEN 1 ELSE ACCEPTANCE.QTY END as GROSS
	FROM PCALC WHERE PCALC.ANO=ACCEPTANCE.ANO AND ACCEPTANCE.PSTATUS='C'
) PCALC
WHERE   
 Acceptance.ANO<>Acceptance.LANO   
 And Acceptance.LANO=@P_ANO  
 And Acceptance.AStatus in ('W','T','I') and Acceptance.AType<>'C'  
 and TOC.ConsortiumF=1
 And RArrHeader.FAmount=0   
)  
   
GO



  insert into PatchVersioning
select '1122 Update Script - Patch 2024 (51)',GETDATE()
go
  
Declare @PrevScript varchar(100)
Declare @CurrScript varchar(100)

Select @PrevScript=''
Select @CurrSCript='1122 Update Script - Patch 2024 (51)'


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


