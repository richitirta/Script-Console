DROP PROCEDURE List11a
GO
CREATE PROCEDURE List11a(@P_UserID as varchar(255), @P_TOC as varchar(10), @P_Branch as varchar(10), @P_AStatus as varchar(1))   
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
(SELECT coalesce(SUM(PCALC.TSI*PCALC.RATE),0) FROM  PCALC WHERE PCALC.ANO=ACCEPTANCE.ANO AND ACCEPTANCE.PSTATUS='C')*CASE WHEN ACCEPTANCE.QTY=0 THEN 1 ELSE ACCEPTANCE.QTY END AS TSI,  
(SELECT coalesce(SUM(PCALC.OURSHARE*PCALC.RATE),0) FROM  PCALC WHERE PCALC.ANO=ACCEPTANCE.ANO AND ACCEPTANCE.PSTATUS='C')*CASE WHEN ACCEPTANCE.QTY=0 THEN 1 ELSE ACCEPTANCE.QTY END AS OURSHARE,   
(SELECT coalesce(SUM(PCALC.GROSS*PCALC.RATE),0) FROM  PCALC WHERE PCALC.ANO=ACCEPTANCE.ANO AND ACCEPTANCE.PSTATUS='C')*CASE WHEN ACCEPTANCE.QTY=0 THEN 1 ELSE ACCEPTANCE.QTY END AS GROSS,  
Acceptance.ASTATUS,   
Acceptance.ATYPE,   
Acceptance.SDate,   
Acceptance.EDate,   
Year(Acceptance.SDate) AS RYear,   
Cover.ISType,   
Acceptance.Renewal,   
Acceptance.ESeqNo,   
Acceptance.PolicyNo,   
acceptance.CertificateNo   
FROM  Acceptance, Cover, SysTab, RArrHeader, SysUser   
Where cover.CNO = acceptance.CNO   
And RArrHeader.ANO=Acceptance.ANO   
And (Acceptance.ANO=Acceptance.LANO Or Acceptance.LANO=-1)   
And Cover.CStatus<>'C'   
And (round(RArrHeader.RAmount,0)<>0 or RArrHeader.HoldF=1)   
And Cover.ISType<>'T'   
And Acceptance.TOC Like @P_TOC and Acceptance.Branch Like @P_Branch and (Acceptance.AStatus=@P_AStatus or @P_AStatus='')   
And SysUser.ID=@P_UserID   
and (SysUser.Type='SUPERVISOR' or   
(   
EXISTS (Select Branch from SysUserBranch S Where S.ID=@P_UserID and S.Branch=Acceptance.Branch)   
and   
EXISTS (Select TOC from SysUserTOC S Where S.ID=@P_UserID and S.TOC=Acceptance.TOC)   
))   
   
Union   
   
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
Year(Acceptance.SDate) AS RYear,   
Cover.ISType,   
Acceptance.Renewal,   
Acceptance.ESeqNo,   
Acceptance.PolicyNo,   
acceptance.CertificateNo   
FROM  Acceptance, Cover, SysTab, RArrHeader, Acceptance As Acceptance_Detail, SysUser   
Where cover.CNO = acceptance.CNO   
And Acceptance.ANO=Acceptance_Detail.LANO  And Acceptance_Detail.LANO<>Acceptance_Detail.ANO   
And RArrHeader.ANO=Acceptance_Detail.ANO   
And Cover.CStatus<>'C'   
And (round(RArrHeader.RAmount,0)<>0 or RArrHeader.HoldF=1)   
And Cover.ISType<>'T'   
And Acceptance_Detail.TOC Like @P_TOC and Acceptance_Detail.Branch Like @P_Branch and (Acceptance_Detail.AStatus=@P_AStatus or @P_AStatus='')   
And SysUser.ID=@P_UserID   
and (SysUser.Type='SUPERVISOR' or   
(   
EXISTS (Select Branch from SysUserBranch S Where S.ID=@P_UserID and S.Branch=Acceptance_Detail.Branch)   
and   
EXISTS (Select TOC from SysUserTOC S Where S.ID=@P_UserID and S.TOC=Acceptance_Detail.TOC)   
))   


GO


DROP FUNCTION List11A_Det
GO
CREATE FUNCTION List11A_Det(@P_ANO as integer, @P_UserID as varchar(255), @P_TOC as varchar(10), @P_Branch as varchar(10), @P_AStatus as varchar(1))   
RETURNS Table   
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
	(SELECT coalesce(SUM(PCALC.TSI*PCALC.RATE),0) FROM  PCALC WHERE PCALC.ANO=ACCEPTANCE.ANO AND ACCEPTANCE.PSTATUS='C')*CASE WHEN ACCEPTANCE.QTY=0 THEN 1 ELSE ACCEPTANCE.QTY END AS TSI, 
	(SELECT coalesce(SUM(PCALC.OURSHARE*PCALC.RATE),0) FROM  PCALC WHERE PCALC.ANO=ACCEPTANCE.ANO AND ACCEPTANCE.PSTATUS='C')*CASE WHEN ACCEPTANCE.QTY=0 THEN 1 ELSE ACCEPTANCE.QTY END AS OURSHARE, 
	(SELECT coalesce(SUM(PCALC.GROSS*PCALC.RATE),0) FROM  PCALC WHERE PCALC.ANO=ACCEPTANCE.ANO AND ACCEPTANCE.PSTATUS='C')*CASE WHEN ACCEPTANCE.QTY=0 THEN 1 ELSE ACCEPTANCE.QTY END AS GROSS, 
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
Inner Join SysTab on (1=1),
SysUser   
Where   
Acceptance.ANO<>Acceptance.LANO   
And Acceptance.LANO=@P_ANO   
And Cover.CStatus<>'C'   
And (round(RArrHeader.RAmount,0)<>0 or RArrHeader.HoldF=1)   
And Cover.ISType<>'T'   
And Acceptance.TOC Like @P_TOC and Acceptance.Branch Like @P_Branch and (Acceptance.AStatus=@P_AStatus or @P_AStatus='')   
And SysUser.ID=@P_UserID   
and (SysUser.Type='SUPERVISOR' or   
(   
EXISTS (Select Branch from SysUserBranch S Where S.ID=@P_UserID and S.Branch=Acceptance.Branch)   
and   
EXISTS (Select TOC from SysUserTOC S Where S.ID=@P_UserID and S.TOC=Acceptance.TOC)   
))   
) 

go



insert into PatchVersioning
select '1050 Update Script - Patch 2024 (28)',GETDATE()
go
	

Declare @PrevScript varchar(100)
Declare @CurrScript varchar(100)

Select @PrevScript=''
Select @CurrSCript='1050 Update Script - Patch 2024 (28)'


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