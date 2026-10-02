DROP PROCEDURE List_Next 
GO
CREATE PROCEDURE List_Next (@P_ANO as integer)  
AS  

Declare @P_CNO as Int
Declare @P_PolicyNo as varchar(50)
Declare @P_CertificateNo as varchar(20)
Select @P_CNO=CNO, @P_PolicyNo=PolicyNo, @P_CertificateNo=CERTIFICATENO from Acceptance Where ANO=@P_ANO

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
 Acceptance.CertificateNo  
FROM Acceptance, Cover, SysTab
WHERE Cover.CNO=Acceptance.CNO And (Acceptance.ANO=Acceptance.LANO Or Acceptance.LANO=-1) And Cover.ISType<>'T' 
and (Acceptance.PANO<>-1 and Acceptance.PANO=@P_ANO)

Union All

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
 Acceptance.CertificateNo  
FROM Acceptance, Cover, SysTab
WHERE Cover.CNO=Acceptance.CNO And (Acceptance.ANO=Acceptance.LANO Or Acceptance.LANO=-1) And Cover.ISType<>'T' 
and (Acceptance.RANO<>-1 and Acceptance.RANO=@P_ANO)
and not (Acceptance.PANO<>-1 and Acceptance.PANO=@P_ANO)

Union All

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
 Acceptance.CertificateNo  
FROM Acceptance, Cover, SysTab
WHERE Cover.CNO=Acceptance.CNO And (Acceptance.ANO=Acceptance.LANO Or Acceptance.LANO=-1) And Cover.ISType<>'T' 
and (Cover.pCNO<>-1 and Cover.pCNO=@P_CNO and Acceptance.PolicyNo=@P_PolicyNo and Acceptance.CERTIFICATENO=@P_CertificateNo)
and not (Acceptance.RANO<>-1 and Acceptance.RANO=@P_ANO)
and not (Acceptance.PANO<>-1 and Acceptance.PANO=@P_ANO)
Order by Acceptance.ANO Asc
GO  

DROP PROCEDURE List_Prev 
GO
CREATE PROCEDURE List_Prev (@P_ANO as integer)   
AS  
Declare @P_PCNO as Int
Declare @P_PANO as Int
Declare @P_RANO as Int
Declare @P_PolicyNo as varchar(50)
Declare @P_CertificateNo as varchar(20)
Select @P_RANO=Acceptance.RANO, @P_PCNO=Cover.PCNO, @P_PANO=Acceptance.PANO, @P_PolicyNo=PolicyNo, @P_CertificateNo=CERTIFICATENO from Acceptance, Cover Where Cover.CNO=Acceptance.CNO and Acceptance.ANO=@P_ANO

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
 Acceptance.CertificateNo  
FROM Acceptance, Cover, SysTab
WHERE Cover.CNO=Acceptance.CNO And (Acceptance.ANO=Acceptance.LANO Or Acceptance.LANO=-1) And Cover.ISType<>'T' 
And (@P_PANO<>-1 and Acceptance.ANO=@P_PANO)

Union All

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
 Acceptance.CertificateNo  
FROM Acceptance, Cover, SysTab
WHERE Cover.CNO=Acceptance.CNO And (Acceptance.ANO=Acceptance.LANO Or Acceptance.LANO=-1) And Cover.ISType<>'T' 
And (@P_RANO<>-1 and Acceptance.ANO=@P_RANO)
And Not (@P_PANO<>-1 and Acceptance.ANO=@P_PANO)

Union All

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
 Acceptance.CertificateNo  
FROM Acceptance, Cover, SysTab
WHERE Cover.CNO=Acceptance.CNO And (Acceptance.ANO=Acceptance.LANO Or Acceptance.LANO=-1) And Cover.ISType<>'T' 
And (@P_PCNO<>-1 and Cover.CNO=@P_PCNO and Acceptance.PolicyNo=@P_PolicyNo and Acceptance.CERTIFICATENO=@P_CertificateNo)
And not (@P_RANO<>-1 and Acceptance.ANO=@P_RANO)
And Not (@P_PANO<>-1 and Acceptance.ANO=@P_PANO)
Order by Acceptance.ANO Desc

go


 insert into PatchVersioning
select '446 Update Script - Patch 2022 (77)',GETDATE()
go


Declare @PrevScript varchar(100)
Declare @CurrScript varchar(100)

Select @PrevScript=''
Select @CurrSCript='446 Update Script - Patch 2022 (77)'


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



