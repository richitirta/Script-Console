BEGIN TRANSACTION
SET QUOTED_IDENTIFIER ON
SET ARITHABORT ON
SET NUMERIC_ROUNDABORT OFF
SET CONCAT_NULL_YIELDS_NULL ON
SET ANSI_NULLS ON
SET ANSI_PADDING ON
SET ANSI_WARNINGS ON
COMMIT

IF EXISTS ( SELECT * FROM   sysobjects WHERE  id = object_id(N'List02') and OBJECTPROPERTY(id, N'IsProcedure') = 1 )
BEGIN DROP PROCEDURE List02 END
GO

CREATE  PROCEDURE List02 (@P_UserID as varchar(255), @pEDate as smalldatetime) 
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
And Cover.ISType<>'T' And Cover.CStatus='A' 
And Cover.CDate+Cover.Validation<=@pEDate  
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
	And Cover.ISType<>'T' And Cover.CStatus='A' 
	And Cover.CDate+Cover.Validation<=@pEDate 
	And Acceptance_Detail.LUserID Like @P_UserID 
)   


GO

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'List02_Det') AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) )
BEGIN DROP FUNCTION List02_Det END
GO 

CREATE FUNCTION List02_Det (@P_ANO as integer,@P_UserID as varchar(255), @pEDate as smalldatetime)
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
And Cover.ISType<>'T' And Cover.CStatus='A' 
And Cover.CDate+Cover.Validation<=@pEDate 
And Acceptance.LUserID Like @P_UserID 
 
)

GO

IF EXISTS ( SELECT * FROM   sysobjects WHERE  id = object_id(N'List02A') and OBJECTPROPERTY(id, N'IsProcedure') = 1 )
BEGIN DROP PROCEDURE List02A END
GO

CREATE  PROCEDURE List02A (@P_UserID as varchar(255), @pEDate as smalldatetime) 
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
And Cover.ISType<>'T' And Cover.CStatus='A' 
And Cover.CDate+Cover.Validation<=@pEDate 
And RArrHeader.FShare<>0 
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
	And Cover.ISType<>'T' And Cover.CStatus='A' 
	And Cover.CDate+Cover.Validation<=@pEDate 
	And RArrHeader.FShare<>0 
	And Acceptance_Detail.LUserID Like @P_UserID 
)   


GO

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'List02A_Det') AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) )
BEGIN DROP FUNCTION List02A_Det END
GO 

CREATE FUNCTION List02A_Det (@P_ANO as integer,@P_UserID as varchar(255), @pEDate as smalldatetime)
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
And Cover.ISType<>'T' And Cover.CStatus='A' 
And Cover.CDate+Cover.Validation<=@pEDate 
And RArrHeader.FShare<>0 
And Acceptance.LUserID Like @P_UserID 
 
)

GO


IF EXISTS ( SELECT * FROM   sysobjects WHERE  id = object_id(N'List02B') and OBJECTPROPERTY(id, N'IsProcedure') = 1 )
BEGIN DROP PROCEDURE List02B END
GO

CREATE  PROCEDURE List02B (@P_UserID as varchar(255), @pEDate as smalldatetime) 
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
And Cover.ISType<>'T' And Cover.CStatus='A' 
And Cover.CDate+Cover.Validation<=@pEDate 
And RArrHeader.FShare<>0 
   
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
	And Cover.ISType<>'T' And Cover.CStatus='A' 
	And Cover.CDate+Cover.Validation<=@pEDate 
	And RArrHeader.FShare<>0 
)   


GO

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'List02B_Det') AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) )
BEGIN DROP FUNCTION List02B_Det END
GO 

CREATE FUNCTION List02B_Det (@P_ANO as integer,@P_UserID as varchar(255), @pEDate as smalldatetime)
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
And Cover.ISType<>'T' And Cover.CStatus='A' 
And Cover.CDate+Cover.Validation<=@pEDate 
And RArrHeader.FShare<>0  
)

GO

insert into PatchVersioning
select '1378 Update Script - Patch 2025 (32)',GETDATE()
go	
  
Declare @PrevScript varchar(100)
Declare @CurrScript varchar(100)

Select @PrevScript=''
Select @CurrSCript='1378 Update Script - Patch 2025 (32)'


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
