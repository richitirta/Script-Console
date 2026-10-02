DROP Procedure QCertificate_Data
GO
CREATE Procedure QCertificate_Data(@P_ANO integer)                                  
as                                  
SELECT                                  
A1.ANO, C.CNO, A1.OANO, A1.LANO, A1.CANO, A1.RANO, A1.REGNO, A1.REGDATE, A1.BRANCH, A1.CT, A1.ATYPE, A1.AStatus, A1.POLICYNO, A1.CERTIFICATENO, A1.POLICYDATE, A1.CPOLICYNO, A1.REFNO, A1.REFDATE, A1.RENEWABLEF, A1.CONJUNCTIONF, A1.EXCLUSIVEF, 
C.COVERNO, C.SEGMENT, C.ISType, C.OpenFlag, C.Voyage, C.PolicyType, C.PPeriod,
A1.SDATE, A1.EDATE, A1.STIME, A1.ETIME,           
A1.NCDate,            
A1.EXTPERIOD, A1.EXTPERIODINDAYSF,            
A1.ASource, A1.TOC, C.MO, A1.Location,                   
A1.Remarks, A1.ADate, A1.PDate, A1.PPDate, A1.AID, A1.ANAME,A1.BUSINESS, A1.DISCOUNT, A1.QTY, A1.TOPRO, A1.Ujroh, A1.WeightedAvgUjrohF,      
A1.ERSeqNo, A1.ESeqNo, A1.EESeqNo, A1.Renewal, A1.BatchNo, A1.BankersID, A1.BankersClause,         
A1.UserID, A1.CDate, A1.CTime,                                   
A1.CUserID, A1.CloseDate, A1.CloseTime,                             
A1.LUSERID, A1.LDate, A1.LTime,     
A1.RUSERID, A1.RUserDate, A1.RUserTime,                  
A1.AUSERID, A1.AUserDate, A1.AUserTime,                  
CACCEPTANCE.REGNO as CREGNO, 
CCOVER.COVERNO AS CCOVERNO, A1.PWordingID,     
A1.CPCT, A1.SYSUSERID, A1.BizMapID, A1.BID,
Interest.Currency, Interest.TSI, Interest.ATSI,                            
A2.FLDID1, A2.VALUEID1, A2.VALUEDESC1, 0 as FLDSEARCH1,                                  
A2.FLDID2, A2.VALUEID2, A2.VALUEDESC2, 0 as FLDSEARCH2,                                  
A2.FLDID3, A2.VALUEID3, A2.VALUEDESC3, 0 as FLDSEARCH3,                                  
A2.FLDID4, A2.VALUEID4, A2.VALUEDESC4, 0 as FLDSEARCH4,                                  
A2.FLDID5, A2.VALUEID5, A2.VALUEDESC5, 0 as FLDSEARCH5,                                  
A2.FLDID6, A2.VALUEID6, A2.VALUEDESC6, 0 as FLDSEARCH6,                                  
A2.FLDID7, A2.VALUEID7, A2.VALUEDESC7, 0 as FLDSEARCH7,                                  
A2.FLDID8, A2.VALUEID8, A2.VALUEDESC8, 0 as FLDSEARCH8,                                  
A2.FLDID9, A2.VALUEID9, A2.VALUEDESC9, 0 as FLDSEARCH9,                                  
A2.FLDID10, A2.VALUEID10, A2.VALUEDESC10, 0 as FLDSEARCH10,                                  
A2.FLDID11, A2.VALUEID11, A2.VALUEDESC11, 0 as FLDSEARCH11,                                  
A2.FLDID12, A2.VALUEID12, A2.VALUEDESC12, 0 as FLDSEARCH12,                                  
A2.FLDID13, A2.VALUEID13, A2.VALUEDESC13, 0 as FLDSEARCH13,                                  
A2.FLDID14, A2.VALUEID14, A2.VALUEDESC14, 0 as FLDSEARCH14,                                  
A2.FLDID15, A2.VALUEID15, A2.VALUEDESC15, 0 as FLDSEARCH15              
FROM ACCEPTANCE A1                     
Inner Join Cover C On (C.CNO=A1.CNO)                 
LEFT JOIN ACCEPTANCE CACCEPTANCE ON (CACCEPTANCE.ANO=A1.CANO)                    
LEFT JOIN COVER CCOVER ON (CCOVER.CNO=CACCEPTANCE.CNO)                    
Left Join AINFO A2 On (A2.ANO=A1.ANO)                     
Left Join FN_SumInsured(@P_ANO) Interest On (Interest.ANO=A1.ANO and Interest.TSI<>0)                            
WHERE A1.ANO=@P_ANO       


GO


DROP FUNCTION List_By_Ano_Det 
GO
CREATE  FUNCTION List_By_Ano_Det (@P_ANO AS INTEGER,@P_CANO AS INTEGER) 
RETURNS TABLE
AS RETURN(
SELECT Cast(0 as bit) as ProcessFlag,
	Acceptance.CertificateNo, 
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
Inner Join SysTab on (1=1)
WHERE Acceptance.ANO<>Acceptance.LANO 
	And Acceptance.LANO=@P_ANO
	And Acceptance.ANO=@P_CANO
)


GO

DROP FUNCTION List_Spc_01_Det 
GO
CREATE  FUNCTION List_Spc_01_Det (@P_ANO AS INTEGER) 
RETURNS TABLE
AS RETURN(
SELECT Cast(0 as bit) as ProcessFlag,
	Acceptance.CertificateNo, 
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
Inner Join SysTab on (1=1)
WHERE 
	Acceptance.ANO<>Acceptance.LANO 
	And Acceptance.LANO=@P_ANO
	And Acceptance.AStatus='I' and Acceptance.AType<>'C'
	And Cover.ISType not in ('C','L','I','T')
	And RArrHeader.TreatyF=1 and (RArrHeader.CAmount<>0 or RArrHeader.DAmount<>0 or RArrHeader.QAmount<>0 or RArrHeader.SP1Amount<>0 or RArrHeader.SP2Amount<>0 or RArrHeader.SP3Amount<>0 or RArrHeader.XPAmount<>0 or RArrHeader.AAmount<>0)
)


GO
DROP FUNCTION List_Spc_02_Det
GO
CREATE  FUNCTION List_Spc_02_Det (@P_ANO AS INTEGER) 
RETURNS TABLE
AS RETURN(
SELECT Cast(0 as bit) as ProcessFlag,
	Acceptance.CertificateNo, 
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
Inner Join SysTab on (1=1)
WHERE 
	Acceptance.ANO<>Acceptance.LANO 
	And Acceptance.LANO=@P_ANO
	And Acceptance.AStatus='I' and Acceptance.AType<>'C'
	And not exists (SELECT ANO from Classified_Object() C Where C.ANO=Acceptance.ANO)
	And RArrHeader.TreatyF=1 and (RArrHeader.CAmount<>0 or RArrHeader.DAmount<>0 or RArrHeader.QAmount<>0 or RArrHeader.SP1Amount<>0 or RArrHeader.SP2Amount<>0 or RArrHeader.SP3Amount<>0 or RArrHeader.XPAmount<>0 or RArrHeader.AAmount<>0)
)

GO

DROP FUNCTION List_Spc_03_Det
GO
CREATE  FUNCTION List_Spc_03_Det (@P_ANO AS INTEGER)   
RETURNS TABLE  
AS RETURN(  
SELECT Cast(0 as bit) as ProcessFlag,
	Acceptance.CertificateNo, 
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
Inner Join SysTab on (1=1)
WHERE   
 Acceptance.ANO<>Acceptance.LANO   
 And Acceptance.LANO=@P_ANO  
 And Acceptance.AStatus in ('I','W') and Acceptance.AType<>'C'  
 And RArrHeader.FAmount=0  
)  
   

GO

DROP FUNCTION List01_Det
GO
CREATE  FUNCTION List01_Det (@P_ANO AS INTEGER, @P_UserID as varchar(255)) 
RETURNS TABLE 
AS RETURN( 
SELECT Cast(0 as bit) as ProcessFlag,
	Acceptance.CertificateNo, 
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
Inner Join SysTab on (1=1)
WHERE 
Acceptance.ANO<>Acceptance.LANO 
And Acceptance.LANO=@P_ANO 
And Acceptance.AStatus='W' 
And Cover.ISType<>'T' 
And Cover.CStatus='A' 
And Acceptance.LuserID Like @P_UserID 
) 
 
 
GO
DROP FUNCTION List02_Det
GO
CREATE FUNCTION List02_Det (@P_ANO as integer,@P_UserID as varchar(255), @pEDate as smalldatetime) 
RETURNS TABLE 
AS RETURN( 
SELECT Cast(0 as bit) as ProcessFlag,
	Acceptance.CertificateNo, 
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
Inner Join SysTab on (1=1)
WHERE 
Acceptance.ANO<>Acceptance.LANO 
And Acceptance.LANO=@P_ANO 
And Acceptance.AStatus='W' 
And Cover.ISType<>'T' 
And Cover.CStatus='A' 
And Cover.CDate+Cover.Validation<=@pEDate 
And Acceptance.LUserID like @P_UserID 
) 
 
GO 

DROP FUNCTION List02A_Det
GO
CREATE   FUNCTION List02A_Det (@P_ANO as integer,@P_UserID as varchar(255), @pEDate as smalldatetime) 
RETURNS TABLE 
AS RETURN( 
SELECT Cast(0 as bit) as ProcessFlag,
	Acceptance.CertificateNo, 
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
Inner Join SysTab on (1=1)
WHERE 
Acceptance.ANO<>Acceptance.LANO 
And Acceptance.LANO=@P_ANO 
And Acceptance.AStatus='W' 
And Cover.ISType<>'T' 
And Cover.CStatus='A' 
And Cover.CDate+Cover.Validation<=@pEDate 
And RArrHeader.FShare<>0 
And Acceptance.LUserID Like @P_UserID 
) 

GO
DROP FUNCTION List03_Det
GO
CREATE FUNCTION List03_Det (@P_ANO as integer, @P_USERID as varchar(255)) 
RETURNS TABLE 
AS RETURN( 
 
SELECT Cast(0 as bit) as ProcessFlag,
	Acceptance.CertificateNo, 
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
Inner Join SysTab on (1=1)
WHERE 
Acceptance.ANO<>Acceptance.LANO 
And Acceptance.LANO=@P_ANO 
And Acceptance.AStatus Not in ('W','T') 
And Cover.ISType<>'T' 
And Acceptance.LUserID Like @P_UserID 
 
) 
 
 
GO

DROP FUNCTION List04_Det
GO
CREATE   FUNCTION List04_Det (@P_ANO as integer,@P_UserID as varchar(255)) 
RETURNS TABLE 
AS RETURN( 
 
SELECT Cast(0 as bit) as ProcessFlag,
	Acceptance.CertificateNo, 
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
Inner Join SysTab on (1=1)
WHERE 
Acceptance.ANO<>Acceptance.LANO 
And Acceptance.LANO=@P_ANO 
And Acceptance.AStatus='W' 
And Cover.ISType<>'T' 
And Cover.CoverNoteF=1 
And Acceptance.LUserID Like @P_UserID 
) 
 
GO

DROP FUNCTION List05_Det
GO
CREATE FUNCTION List05_Det (@P_ANO as integer, @P_UserID as varchar(50), @pSDate as smallDateTime, @pEDate as smallDateTime, @pBranch as varchar(10), @pTOC as varchar(10), @pMO as varchar(10))      
RETURNS Table      
AS RETURN(      
SELECT Cast(0 as bit) as ProcessFlag,
	Acceptance.CertificateNo, 
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
Inner Join SysTab on (1=1)
Where      
 Acceptance.ANO<>Acceptance.LANO      
 And Acceptance.LANO=@P_ANO            
 And Cover.CStatus<>'C'      
 And Acceptance.AStatus='I' and Acceptance.AType not in ('A','C')      
 And Acceptance.EDate between @PSDate and @PEDate      
 And Acceptance.RenewableF=1      
 And Cover.ISType in ('I','C','L')      
 And Acceptance.Branch like @pBranch+'%'    
 And Acceptance.TOC Like @pTOC+'%'      
 And Cover.MO like @pMO+'%'    
 And not Exists (SELECT ANO from Claim, CLLOSS Where CLLOSS.CNO=Claim.CNO and CLLOSS.CTLF=1 and Claim.ANO=Acceptance.ANO)      
 and Exists (Select S1.ID from SysUser S1 Left Join SysUserBranch S2 on (S2.ID=S1.ID and S2.AllowedF=1 and S2.Branch=Acceptance.Branch) Where S1.ID=@P_UserID and (coalesce(S2.Branch,'')<>'' or S1.Type='SUPERVISOR'))      
)      
       
GO
DROP FUNCTION List06_Det
GO
CREATE FUNCTION List06_Det (@P_ANO as integer, @P_UserID as varchar(50), @pSDate as smalldatetime, @pEDate as smallDateTime, @pBranch as varchar(10), @pTOC as varchar(10), @pMO as varchar(10))      
RETURNS TABLE      
AS RETURN(      
      
SELECT Cast(0 as bit) as ProcessFlag,
	Acceptance.CertificateNo, 
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
Inner Join SysTab on (1=1)
WHERE       
 Acceptance.ANO<>Acceptance.LANO       
 And Acceptance.LANO=@P_ANO      
 And Acceptance.AStatus='I'       
 And Acceptance.AType<>'C'       
 And Cover.ISType<>'T'       
 And Acceptance.Branch like @pBranch+'%'    
 And Acceptance.TOC Like @pTOC+'%'      
 And Cover.MO like @pMO+'%'    
 And Acceptance.EDate between @pSDate and @pEDate       
 And Exists (Select S1.ID from SysUser S1 Left Join SysUserBranch S2 on (S2.ID=S1.ID and S2.AllowedF=1 and S2.Branch=Acceptance.Branch) Where S1.ID=@P_UserID and (coalesce(S2.Branch,'')<>'' or S1.Type='SUPERVISOR'))       
)      

GO
DROP FUNCTION List07_Det
GO
CREATE FUNCTION List07_Det (@P_ANO as integer, @PSDate as SmallDateTime, @pEDAte as smallDateTime,@P_COB as varchar(10))  
RETURNS Table  
AS RETURN(  
    
SELECT Cast(0 as bit) as ProcessFlag,
	Acceptance.CertificateNo, 
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
Inner Join SysTab on (1=1)
Inner Join TOC on (TOC.TOC=Acceptance.TOC)
Where  
 Acceptance.ANO<>Acceptance.LANO  
 And Acceptance.LANO=@P_ANO  
 And ((Acceptance.AType='C' and Acceptance.AStatus='I' and Acceptance.PPDate between @PSdate and @pEDate)  
 or (Acceptance.AType<>'C' and Acceptance.AStatus='C' And Acceptance.CloseDate between @PSdate and @pEDate)  
 or (Acceptance.AType<>'C' and Acceptance.AStatus='I' and Acceptance.EDate between @PSdate and @pEDate))  
 And Cover.ISType<>'T'  
 And Acceptance.AdjustableF=1  
 And TOC.COB=@P_COB  
)  

GO
DROP FUNCTION List08_Det
GO
CREATE  FUNCTION List08_Det (@P_ANO as integer, @pSDate as smallDatetime, @pEDate as smalldatetime)
RETURNS TABLE
AS RETURN(

SELECT Cast(0 as bit) as ProcessFlag,
	Acceptance.CertificateNo, 
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
Inner Join SysTab on (1=1)
WHERE 
	Acceptance.ANO<>Acceptance.LANO 
	And Acceptance.LANO=@P_ANO
	And Acceptance.AType='A' 
	And Cover.ISType<>'T' 
	And Acceptance.ADate>=@pSDate 
	And Acceptance.ADate<=@pEDate
)

GO
DROP FUNCTION List09_Det
GO
CREATE  FUNCTION List09_Det (@P_ANO as integer, @pSDate as smalldatetime, @pEDate as smalldatetime)
RETURNS TABLE
AS RETURN(

SELECT Cast(0 as bit) as ProcessFlag,
	Acceptance.CertificateNo, 
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
Inner Join SysTab on (1=1)
WHERE 
	Acceptance.ANO<>Acceptance.LANO 
	And Acceptance.LANO=@P_ANO 
	And Acceptance.AType='C' 
	And Cover.ISType<>'T' 
	And Acceptance.ADate>=@pSDate 
	And Acceptance.ADate<=@pEDate
)

GO
DROP FUNCTION List11_Det
GO
CREATE FUNCTION List11_Det (@P_ANO as integer,@P_SDate as smalldatetime, @P_EDate as smalldatetime)
RETURNS Table
AS RETURN(
        
SELECT Cast(0 as bit) as ProcessFlag,
 Acceptance.CertificateNo,
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
Inner Join SysTab on (1=1)
Where
 Acceptance.ANO<>Acceptance.LANO
 And Acceptance.LANO=@P_ANO
 And Cover.CStatus<>'C'
 And (Acceptance.AType Not in ('C','A') and Acceptance.AStatus='I' And RArrHeader.Status='R')
 And Cover.ISType<>'T'
 And Acceptance.ADate Between @P_SDate and @P_EDate
)
  
GO
DROP FUNCTION List11A_Det
GO
CREATE FUNCTION List11A_Det (@P_ANO as integer, @P_UserID as varchar(255), @P_TOC as varchar(10), @P_Branch as varchar(10), @P_AStatus as varchar(1))   
RETURNS Table   
AS RETURN(   
   
SELECT Cast(0 as bit) as ProcessFlag,
	Acceptance.CertificateNo, 
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
And (RArrHeader.RAmount<>0 or RArrHeader.HoldF=1)   
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


GO
DROP FUNCTION List11B_Det
GO
CREATE FUNCTION List11B_Det (@P_ANO as integer)
RETURNS Table
AS RETURN(
  
SELECT Cast(0 as bit) as ProcessFlag,
	Acceptance.CertificateNo, 
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
Inner Join SysTab on (1=1)
Where
 Acceptance.ANO<>Acceptance.LANO
 And Acceptance.LANO=@P_ANO
 And Cover.CStatus<>'C'
 And Acceptance.AStatus='W'
 And Cover.ISType<>'T'
 And Exists (SELECT Top 1 ANO from RArrDet Where RArrDet.Status<>'O' and RArrDet.ANO=RarrHeader.ANO)
)

GO
DROP FUNCTION List11C_Det
GO
CREATE FUNCTION List11C_Det (@P_ANO as integer) 
RETURNS TABLE
AS RETURN(

SELECT Cast(0 as bit) as ProcessFlag,
	Acceptance.CertificateNo, 
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
Inner Join SysTab on (1=1)
WHERE 
	Acceptance.ANO<>Acceptance.LANO 
	And Acceptance.LANO=@P_ANO 
	And Cover.CStatus<>'C'
        And Acceptance.AStatus='W'   
        And Acceptance.EMethod='T'  
)


GO
DROP FUNCTION List11D_Det
GO
CREATE FUNCTION List11D_Det (@P_ANO as integer,@P_SDate as smalldatetime, @P_EDate as smalldatetime) 
RETURNS TABLE
AS RETURN(

SELECT Cast(0 as bit) as ProcessFlag,
	Acceptance.CertificateNo, 
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
Inner Join SysTab on (1=1)
WHERE 
	Acceptance.ANO<>Acceptance.LANO 
	And Acceptance.LANO=@P_ANO 
        And Acceptance.ADate Between @P_SDate and @P_EDate
        And RArrHeader.Status<>'R'   
        And RArrHeader.SAmount<>0
        And Cover.ISType<>'T'
)

GO
DROP FUNCTION List11E_Det
GO
CREATE FUNCTION List11E_Det (@P_ANO as integer,@P_SDate as smalldatetime, @P_EDate as smalldatetime,@P_REGID as varchar(10))
RETURNS Table
AS RETURN(
              
SELECT Cast(0 as bit) as ProcessFlag,
	Acceptance.CertificateNo, 
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
 AccRegDet
Where
 Acceptance.REGID=@P_REGID
 And Acceptance.ANO<>Acceptance.LANO
 And Acceptance.LANO=@P_ANO
 And Acceptance.ADate Between @P_SDate and @P_EDate
 And RArrHeader.Status<>'R' And RArrHeader.TAmount<>0
 And Acceptance.AStatus in ('W','I')
 And Cover.ISType<>'T'
 And AccRegDet.RYear=Year(RArrHeader.RDate) and AccRegDet.RegID=Acceptance.RegID and AccRegDet.FLDID=Acceptance.FLDID and AccRegDet.VALUEID=Acceptance.ValueID and AccRegDet.TSI<>0 and RArrHeader.ManualF=0 and AccRegDet.ReAllocF=1
 And ((Rarrheader.CID<>'' or RArrHeader.XPID<>'' or RArrheader.SP1ID<>'' or RArrHeader.SP2ID<>'' or RArrHeader.SP3ID<>'' or (RArrHeader.QID<>'' and RArrHeader.QSRet<>100)))
)
GO              

DROP FUNCTION List11F_Det
GO
CREATE FUNCTION List11F_Det (@P_ANO as integer,@P_UserID as varchar(10), @P_TOC as varchar(10), @P_Branch as varchar(10), @P_PDate as smalldatetime, @P_ManualF as bit)      
RETURNS Table      
AS RETURN(      
          
SELECT Cast(0 as bit) as ProcessFlag,
	Acceptance.CertificateNo, 
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
 SysUserTOC,   
 SysUserBranch  
Where       
 Acceptance.ANO<>Acceptance.LANO      
 And Acceptance.LANO=@P_ANO      
 And Cover.CStatus<>'C'      
 And Acceptance.AStatus='I' and Acceptance.AType not in ('A','C')      
 And RArrHeader.NRDate<Acceptance.EDate And RArrHeader.NRDate<=@P_PDate      
 And (@P_ManualF=0 or RArrHeader.ManualF=@P_ManualF)    
 And Cover.ISType<>'T'      
 And SysUserTOC.ID=@P_UserID and Acceptance.TOC=SysUserTOC.TOC and (SysUserTOC.TOC Like @P_TOC+'%' or @P_TOC='')    
 And SysUserBranch.ID=@P_UserID and Acceptance.BRanch=SysUserBranch.Branch and (SysUserBranch.Branch=@P_Branch or @P_Branch='')     
) 
GO

DROP FUNCTION List11G_Det
GO
CREATE FUNCTION List11G_Det(@P_ANO as integer,@P_SDate as smalldatetime, @P_EDate as smalldatetime)
RETURNS Table
AS RETURN(
    
SELECT Cast(0 as bit) as ProcessFlag,
	Acceptance.CertificateNo, 
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
Inner Join SysTab on (1=1)
Where
 Acceptance.ANO<>Acceptance.LANO
 And Acceptance.LANO=@P_ANO
 And Acceptance.AStatus<>'W'
 And Acceptance.ANO in
(SELECT AccAss.ANO from AccAss, RArrDet, FPart Where AccAss.ANO=Acceptance.ANO and AccAss.Type='FO' and FPart.ANO=RArrDet.ANO and FPart.FID=RArrDet.FID and AccAss.ANO=RArrDet.ANO and AccAss.ID=FPart.ID and AccAss.RefNo=FPart.SlipNo and (Acceptance.AType='C' or RArrDet.Status='O'))
)

GO
DROP FUNCTION List12_Det
GO
CREATE  FUNCTION List12_Det (@P_ANO as integer) 
RETURNS TABLE
AS RETURN(

SELECT Cast(0 as bit) as ProcessFlag,
	Acceptance.CertificateNo, 
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
Inner Join SysTab on (1=1)
WHERE 
	Acceptance.ANO<>Acceptance.LANO 
	And Acceptance.LANO=@P_ANO 
	And Cover.CStatus<>'C'
	And Acceptance.AStatus='W' 
	And RArrHeader.TreatyF=1 And RArrHeader.Status='A'
	And Cover.ISType<>'T'
)

GO
DROP FUNCTION List13_Det
GO
CREATE  FUNCTION List13_Det (@P_ANO as integer, @pSDate as smalldatetime, @pEDate as smalldatetime)
RETURNS TABLE
as RETURN(

SELECT Cast(0 as bit) as ProcessFlag,
	Acceptance.CertificateNo, 
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
Inner Join SysTab on (1=1)
WHERE 
	Acceptance.ANO<>Acceptance.LANO 
	And Acceptance.LANO=@P_ANO
     	And Acceptance.AStatus='I'
      	And Cover.ISType<>'T' 
      	And Acceptance.ADate>=@pSDate 
      	And Acceptance.ADate<=@pEDate
)

GO

DROP FUNCTION List14_Det
GO
CREATE  FUNCTION List14_Det (@P_ANO as integer) 
RETURNS TABLE
as RETURN(

SELECT Cast(0 as bit) as ProcessFlag,
	Acceptance.CertificateNo, 
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
Inner Join SysTab on (1=1)
WHERE 
	Acceptance.ANO<>Acceptance.LANO 
	And Acceptance.LANO=@P_ANO
	and Cover.OpenFlag=1
    And Acceptance.AStatus='I' 
    And Cover.ISType<>'T' 
)

GO
DROP FUNCTION List15_Blank_Det
GO
CREATE FUNCTION List15_Blank_Det (@P_ANO as integer,@P_REGID varchar(10), @P_FLDID varchar(255), @P_VALUEID varchar(255), @P_RYear integer=0)
RETURNS Table
as RETURN(
SELECT Cast(0 as bit) as ProcessFlag,
	Acceptance.CertificateNo, 
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
Inner Join SysTab on (1=1)
Where 
 Acceptance.ANO<>Acceptance.LANO
 And Acceptance.LANO=@P_ANO
 And Cover.ISType<>'T'
 And RArrHeader.Status='A'
 And Acceptance.REGID=@P_REGID
 And Acceptance.FLDID=@P_FLDID
 And Acceptance.ValueID Like @P_ValueID + '%'
 and (@P_RYear=0 or Year(RArrHeader.RDate)=@P_RYear)
)
                    

GO 


DROP FUNCTION List15_Det 
GO
CREATE  FUNCTION List15_Det (@P_ANO as integer,@P_REGID varchar(10), @P_FLDID varchar(255), @P_VALUEID varchar(255), @P_VALUEID1 varchar(255), @P_VALUEID2 varchar(255), @P_VALUEID3 varchar(255), @P_VALUEID4 varchar(255), @P_VALUEID5 varchar(255), @P_VALUEID6 varchar(255)) 
RETURNS TABLE
as RETURN(

SELECT Cast(0 as bit) as ProcessFlag,
	Acceptance.CertificateNo, 
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
	GenDTab
WHERE 
	Acceptance.ANO<>Acceptance.LANO 
	And Acceptance.LANO=@P_ANO
	And RArrHeader.Status='A'  
	And Acceptance.REGID=@P_REGID
	And Acceptance.FLDID=GenDTab.FLDID 
	And Acceptance.ValueID=GenDTab.ValueID 
	And GenDTab.FLDID=@P_FLDID 
	And GenDTab.ValueID Like @P_ValueID + '%' 
	And (GenDTab.ValueID1 Like @P_ValueID1 + '%' or GenDTab.ValueDesc1 Like @P_ValueID1 + '%')
	And (GenDTab.ValueID2 Like @P_ValueID2 + '%' or GenDTab.ValueDesc2 Like @P_ValueID2 + '%')
	And (GenDTab.ValueID3 Like @P_ValueID3 + '%' or GenDTab.ValueDesc3 Like @P_ValueID3 + '%')
	And (GenDTab.ValueID4 Like @P_ValueID4 + '%' or GenDTab.ValueDesc4 Like @P_ValueID4 + '%')
	And (GenDTab.ValueID5 Like @P_ValueID5 + '%' or GenDTab.ValueDesc5 Like @P_ValueID5 + '%')
	And (GenDTab.ValueID6 Like @P_ValueID6 + '%' or GenDTab.ValueDesc6 Like @P_ValueID6 + '%')
)


GO
DROP FUNCTION List16_Det 
GO
CREATE  FUNCTION List16_Det (@P_ANO as integer, @pSDate as smalldatetime,@pEDate as smalldatetime,@P_COB as varchar(10))  
RETURNS TABLE   
as RETURN(  
  
SELECT Cast(0 as bit) as ProcessFlag,
	Acceptance.CertificateNo, 
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
Inner Join SysTab on (1=1)
Inner Join TOC on (TOC.TOC=Acceptance.TOC)
WHERE   
 Acceptance.ANO<>Acceptance.LANO   
 And Acceptance.LANO=@P_ANO   
 And Cover.ISType<>'T'   
 And Acceptance.ADate>=@pSDate   
 And Acceptance.ADate<=@pEDate  
 And TOC.COB=@P_COB  
)  

GO

DROP FUNCTION list16SC_Det 
GO
CREATE  FUNCTION list16SC_Det (@P_ANO as integer, @P_SDate as smalldatetime, @P_EDate as smalldatetime,@P_COB as varchar(10),@P_ServiceNo as varchar(20))  
RETURNS Table  
AS RETURN(  
    
SELECT Cast(0 as bit) as ProcessFlag,
	Acceptance.CertificateNo, 
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
Inner Join SysTab on (1=1)
Inner Join TOC on (TOC.TOC=Acceptance.TOC),
 Service  
Where  
 Acceptance.ANO<>Acceptance.LANO  
 And Acceptance.LANO=@P_ANO  
 And Service.SType='CANCELLATION'  
 And Service.PANO=Acceptance.ANO  
 And Service.Cdate Between @P_Sdate and @P_EDate  
 And Service.SStatus='P'  
 And TOC.COB Like @P_COB+'%'  
 And Service.ServiceNo Like @P_ServiceNo+'%'  
)  
    

GO
DROP FUNCTION list16SD_Det
GO
CREATE FUNCTION list16SD_Det (@P_ANO as integer, @P_SDate as smalldatetime, @P_EDate as smalldatetime,@P_COB as varchar(10),@P_ServiceNo as varchar(20))  
RETURNS Table  
AS RETURN(  
      
SELECT Cast(0 as bit) as ProcessFlag,
	Acceptance.CertificateNo, 
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
Inner Join SysTab on (1=1)
Inner Join TOC on (TOC.TOC=Acceptance.TOC),
 Service  
Where  
 Acceptance.ANO<>Acceptance.LANO  
 And Acceptance.LANO=@P_ANO  
 And ((Service.PANO=Acceptance.ANO and Service.SType<>'NEW') or (Service.ANO=Acceptance.ANO and Service.SType='NEW'))  
 And Service.Cdate Between @P_Sdate and @P_EDate  
 And Acceptance.AStatus='W'  
 And Service.SStatus='C'  
 And TOC.COB Like @P_COB+'%'  
 And Service.ServiceNo Like @P_ServiceNo+'%'  
)  

GO
DROP FUNCTION list16SE_Det
GO
CREATE  FUNCTION list16SE_Det (@P_ANO as integer, @P_SDate as smalldatetime, @P_EDate as smalldatetime,@P_COB as varchar(10),@P_ServiceNo as varchar(20))  
RETURNS Table  
AS RETURN(  
    
SELECT Cast(0 as bit) as ProcessFlag,
	Acceptance.CertificateNo, 
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
Inner Join SysTab on (1=1)
Inner Join TOC on (TOC.TOC=Acceptance.TOC),
 Service  
Where  
 Acceptance.ANO<>Acceptance.LANO  
 And Acceptance.LANO=@P_ANO  
 And Service.SType='ENDORSEMENT'  
 And Service.PANO=Acceptance.ANO  
 And Service.Cdate Between @P_Sdate and @P_EDate  
 And Service.SStatus='P'  
 And TOC.COB Like @P_COB+'%'  
 And Service.ServiceNo Like @P_ServiceNo+'%'  
)  


GO
DROP FUNCTION list16SL_Det
GO
CREATE FUNCTION list16SL_Det (@P_ANO as integer, @P_SDate as smalldatetime, @P_EDate as smalldatetime,@P_COB as varchar(10),@P_ServiceNo as varchar(20))  
RETURNS Table  
AS RETURN(  
      
SELECT Cast(0 as bit) as ProcessFlag,
	Acceptance.CertificateNo, 
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
Inner Join SysTab on (1=1)
Inner Join TOC on (TOC.TOC=Acceptance.TOC),
 Service  
Where  
 Acceptance.ANO<>Acceptance.LANO  
 And Acceptance.LANO=@P_ANO  
 And Service.SType='EXPIRED'  
 And Service.PANO=Acceptance.ANO  
 And Service.Cdate Between @P_Sdate and @P_EDate  
 And Service.SStatus='P'  
 And TOC.COB Like @P_COB+'%'  
 And Service.ServiceNo Like @P_ServiceNo+'%'  
)  

GO
DROP FUNCTION list16SR_Det
GO
CREATE FUNCTION list16SR_Det (@P_ANO as integer, @P_SDate as smalldatetime, @P_EDate as smalldatetime,@P_COB as varchar(10),@P_ServiceNo as varchar(20))  
RETURNS Table  
AS RETURN(  
    
SELECT Cast(0 as bit) as ProcessFlag,
	Acceptance.CertificateNo, 
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
Inner Join SysTab on (1=1)
Inner Join TOC on (TOC.TOC=Acceptance.TOC),
 Service  
Where  
 Acceptance.ANO<>Acceptance.LANO  
 And Acceptance.LANO=@P_ANO  
 And Service.SType='RENEWAL'  
 And Service.PANO=Acceptance.ANO  
 And Service.Cdate Between @P_Sdate and @P_EDate  
 And Service.SStatus='P'  
 And TOC.COB Like @P_COB+'%'  
 And Service.ServiceNo Like @P_ServiceNo+'%'  
)  

GO
DROP FUNCTION List17_Det
GO
CREATE  FUNCTION List17_Det (@P_ANO as integer, @pSDate as smalldatetime,@pEDate as smalldatetime,@P_SEGMENT as varchar(10))
RETURNS TABLE
as RETURN(

SELECT Cast(0 as bit) as ProcessFlag,
	Acceptance.CertificateNo, 
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
Inner Join SysTab on (1=1)
WHERE 
	Acceptance.ANO<>Acceptance.LANO 
	And Acceptance.LANO=@P_ANO 
	And Cover.ISType<>'T' 
	And Acceptance.ADate>=@pSDate 
	And Acceptance.ADate<=@pEDate
	And Cover.Segment=@P_SEGMENT
)


GO
DROP FUNCTION List18_Det
GO
CREATE FUNCTION List18_Det (@P_ANO as integer, @P_UserID as varchar(10), @P_TOC as varchar(10), @P_Branch as varchar(10), @P_PDate as smalldatetime)      
RETURNS Table      
AS RETURN(      
          
SELECT Cast(0 as bit) as ProcessFlag,
	Acceptance.CertificateNo, 
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
 SysUserTOC,     
 SysUserBranch    
Where      
 Acceptance.ANO<>Acceptance.LANO      
 And Acceptance.LANO=@P_ANO      
 And Acceptance.AStatus='I'      
 And Acceptance.AType Not in ('C','A')      
And Cover.ISType<>'T'      
AND @P_PDate between Acceptance.PDate and Acceptance.PPDate      
 And SysUserTOC.ID=@P_UserID and Acceptance.TOC=SysUserTOC.TOC and (SysUserTOC.TOC=@P_TOC or @P_TOC='')    
 And SysUserBranch.ID=@P_UserID and Acceptance.BRanch=SysUserBranch.Branch and (SysUserBranch.Branch=@P_Branch or @P_Branch='')    
 And Exists (SELECT Top 1 ANO from Claim, CLLOSS Where (Claim.CSTATUS IN ('R','P','T','A') OR Claim.PCSTATUS IN ('A')) and Claim.CNO=CLLOSS.CNO and CLLOSS.CTLF=1 And Claim.ANO=Acceptance.ANO)      
)      
                 
GO
DROP FUNCTION List19_Det
GO
CREATE FUNCTION List19_Det (@P_ANO as integer, @P_Days as smallint, @P_Date as Smalldatetime,@P_COB as varchar(10),@P_Branch as varchar(10), @P_UnPaidOpt as Bit)   
RETURNS TABLE   
as RETURN(   
   
SELECT Cast(0 as bit) as ProcessFlag,
	Acceptance.CertificateNo, 
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
Inner Join SysTab on (1=1)
Inner Join TOC on (TOC.TOC=Acceptance.TOC)
WHERE   
Acceptance.ANO<>Acceptance.LANO   
And Acceptance.LANO=@P_ANO   
And Cover.ISType<>'T'   
And Acceptance.AStatus='I'  And Acceptance.AType<>'C'   
and TOC.COB=@P_COB And Acceptance.Branch Like @P_Branch+'%'   
And EXISTS (SELECT A1.OANO from Acceptance A1, AccAss, Admlink, nVoucher Voucher Where A1.ANO=AccAss.ANO and A1.OANO=Acceptance.OANO and Voucher.Voucher=Admlink.Voucher and Admlink.AdmNo=AccAss.AdmNo and AccAss.Type in ('DI','IC','IR') and Voucher.nDueDate+@P_Days<@P_Date and Voucher.Nominal_CC-Voucher.Diff_CC-Voucher.Payment_CC-Voucher.Payment_OC<>0 and (@P_UnPaidOpt=0 or Voucher.Payment_CC=0))   
)  

GO
DROP FUNCTION List20_Det
GO
CREATE FUNCTION List20_Det(@P_ANO as integer, @P_USERID as varchar(255), @P_SDate as smalldatetime, @P_EDate as smalldatetime, @P_AStatus as varchar(1)) 
RETURNS TABLE 
AS RETURN( 
 
SELECT 
Cast(0 as bit) as ProcessFlag, 
Acceptance.CertificateNo, 
Acceptance.ESeqNo, 
Acceptance.ERSeqNo,
Cast(Acceptance.AName as varchar(128)) as AName,  
Acceptance.ANO, 
Acceptance.REGNO, 
Acceptance.ADATE, 
Acceptance.LUSERID as UserID, 
SysTab.Currency, 
Acceptance.ASTATUS, 
Acceptance.ATYPE, 
Acceptance.SDate, 
Acceptance.EDate, 
(SELECT coalesce(SUM(PCALC.TSI*PCALC.RATE),0) FROM  PCALC WHERE PCALC.ANO=ACCEPTANCE.ANO AND ACCEPTANCE.PSTATUS='C')*CASE WHEN ACCEPTANCE.QTY=0 THEN 1 ELSE ACCEPTANCE.QTY END AS TSI, 
(SELECT coalesce(SUM(PCALC.OURSHARE*PCALC.RATE),0) FROM  PCALC WHERE PCALC.ANO=ACCEPTANCE.ANO AND ACCEPTANCE.PSTATUS='C')*CASE WHEN ACCEPTANCE.QTY=0 THEN 1 ELSE ACCEPTANCE.QTY END AS OURSHARE, 
(SELECT coalesce(SUM(PCALC.GROSS*PCALC.RATE),0) FROM  PCALC WHERE PCALC.ANO=ACCEPTANCE.ANO AND ACCEPTANCE.PSTATUS='C')*CASE WHEN ACCEPTANCE.QTY=0 THEN 1 ELSE ACCEPTANCE.QTY END AS GROSS,
Year(RArrHeader.RDate) AS RYear, 
Acceptance.ValueID, 
dbo.get_objectInfo(Acceptance.ANO) as ValueDesc, 
Acceptance.BatchNo
FROM Acceptance
Inner Join RArrHeader on (RArrHeader.ANO=Acceptance.ANO)
Inner Join Cover on (Cover.CNO=Acceptance.CNO)
Inner Join SysTab on (1=1)
WHERE 
Acceptance.ANO<>Acceptance.LANO 
And Acceptance.LANO=@P_ANO 
And Cover.ISType<>'T' 
And Acceptance.LUserID Like @P_UserID 
And Acceptance.LDate between @P_SDate and @P_EDate 
And (Acceptance.AStatus=@P_AStatus or @P_AStatus='') 
) 
 
GO
DROP FUNCTION List21_Det
GO
CREATE FUNCTION List21_Det (@P_ANO as integer,@P_UserID varchar(255)) 
RETURNS TABLE 
AS RETURN( 
 
SELECT Cast(0 as bit) as ProcessFlag,
	Acceptance.CertificateNo, 
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
Inner Join SysTab on (1=1)
WHERE 
Acceptance.ANO<>Acceptance.LANO 
And Acceptance.LANO=@P_ANO 
And Acceptance.RequestF=1 and Acceptance.RequestName Like @P_UserID 
) 
 
GO
DROP FUNCTION List22_Det
GO
CREATE FUNCTION List22_Det (@P_ANO as integer,@P_SDate as smalldatetime, @P_EDate as smalldatetime)
RETURNS Table
AS RETURN(
    
SELECT Cast(0 as bit) as ProcessFlag,
	Acceptance.CertificateNo, 
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
Inner Join SysTab on (1=1)
Where
 Acceptance.ANO<>Acceptance.LANO
 And Acceptance.LANO=@P_ANO
 And Acceptance.AStatus='I'
)
    
GO
DROP function ListDet05_a
GO
CREATE function ListDet05_a (@P_ANO as integer,     
@Value1 as varchar(255), @Value2 as varchar(255), @Value3 as varchar(255), @Value4 as varchar(255), @Value5 as varchar(255),     
@Value6 varchar(255), @Value7 as varchar(255), @Value8 as varchar(255), @Value9 as varchar(255), @Value10 as varchar(255),    
@Value11 as varchar(255),@Value12 as varchar(255), @Value13 as varchar(255),@Value14 as varchar(255),@Value15 as varchar(255),    
@Value16 as varchar(255),@Value17 as varchar(255),@Value18 as varchar(255),@Value19 as varchar(255),@Value20 as varchar(255),@Value21 as varchar(255), @Value22 as varchar(255), @Value23 as varchar(255), @Value24 as varchar(255)    
)          
RETURNS Table        
AS RETURN        
(        
 SELECT Cast(0 as bit) as ProcessFlag,
	Acceptance.CertificateNo, 
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
Inner Join SysTab on (1=1)
Inner Join Profile on (Profile.ID=Cover.PHolder) 
Where        
 Acceptance.ANO<>Acceptance.LANO        
 And Acceptance.LANO=@P_ANO        
 And ((Cover.Insured Like @Value1 Or Cover.Insured is null) or (Acceptance.AName Like @Value1 Or Acceptance.AName is null))        
 And (Cover.CoverNo Like @Value2 Or Cover.CoverNo is null)        
 and (Cover.CoverDate = @Value3 Or Cover.CoverDate is null or @Value7 = '')        
 And (Cover.ExpDate = @Value4 Or Cover.ExpDate is null or @Value7 = '')        
 And (Acceptance.PolicyNo Like @Value5 Or Acceptance.PolicyNo is null)        
 And (Acceptance.CertificateNo Like @Value6 Or Acceptance.CertificateNo is null)        
 And (Acceptance.PolicyDate = @Value7 Or Acceptance.PolicyDate is null or @Value7 = '' or Acceptance.PolicyDate Between @Value7 and @Value16)        
 And (Acceptance.RegDate = @Value17 Or Acceptance.RegDate is null or @Value17 = '' or Acceptance.RegDate Between @Value17 and @Value18)        
 And Acceptance.AType Like @Value8        
 And Acceptance.AStatus Like @Value9        
 And Acceptance.RegNo Like @Value10        
 And Profile.Name Like @Value11       
 and acceptance.toc like @Value12        
 and (acceptance.refno like @Value13 or acceptance.refno is null)        
 and (Acceptance.Matters=@Value14 or @Value14='')        
 And Cover.ISType<>'T'        
 And (@Value15='%' or @Value15='' or Exists (SELECT top 1 1 from Service Where ((Service.ANO=Acceptance.pANO and Service.ANO<>-1) or Service.ANO=Acceptance.ANO) and SStatus<>'R' and ServiceNo Like @Value15))        
 And (Acceptance.BatchNo Like @Value19 or (Acceptance.BatchNo is null and @Value19='%'))     
 And ((Acceptance.BackDatedF=1 and @Value20='1') or @Value20='')    
 And ((Cover.TBAF=1 and @Value22='1') or @Value22='')    
 And (@Value23<>'1' or (@Value23='1' and Exists (Select ANO from PPrintLog Where PPrintLog.ANO=Acceptance.ANO)))    
)        
GO  
DROP function ListSR_Det
GO
CREATE  function ListSR_Det(@P_ANO as int, @P_ID as int)  
returns table    
AS return    
(    
SELECT Cast(0 as bit) as ProcessFlag,
	Acceptance.CertificateNo, 
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
SysRequest
Where Acceptance.ANO<>Acceptance.LANO    
 And Acceptance.LANO=@P_ANO    
 And SysRequest.ID=@P_ID    
 And SysRequest.Param2 in ('MAR','UND','CLM')    
 And SysRequest.Param3=Acceptance.ANO        
)  

GO


DROP PROCEDURE ListDet_By_ANO
GO
CREATE PROCEDURE ListDet_By_ANO (@P_ANO as integer) 
AS 
SELECT Cast(0 as bit) as ProcessFlag,
	Acceptance.CertificateNo, 
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
Inner Join SysTab on (1=1)
WHERE Acceptance.ANO=@P_ANO 

GO 

DROP PROCEDURE ListDet_Next
GO
CREATE PROCEDURE ListDet_Next (@P_ANO as integer)     
AS    
Declare @P_CNO as Int
Declare @P_CertificateNo as varchar(10)
Select @P_CNO=CNO, @P_CertificateNo=CERTIFICATENO from Acceptance Where ANO=@P_ANO

SELECT Cast(0 as bit) as ProcessFlag,
	Acceptance.CertificateNo, 
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
Inner Join SysTab on (1=1)
WHERE Acceptance.LANO<>-1 
and (Acceptance.PANO<>-1 and Acceptance.PANO=@P_ANO)

Union All

SELECT Cast(0 as bit) as ProcessFlag,
	Acceptance.CertificateNo, 
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
Inner Join SysTab on (1=1)
WHERE Acceptance.LANO<>-1 
and (Acceptance.RANO<>-1 and Acceptance.RANO=@P_ANO)
and Not (Acceptance.PANO<>-1 and Acceptance.PANO=@P_ANO)

Union All

SELECT Cast(0 as bit) as ProcessFlag,
	Acceptance.CertificateNo, 
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
Inner Join SysTab on (1=1)
WHERE Acceptance.LANO<>-1 
and (Cover.pCNO<>-1 and Cover.pCNO=@P_CNO and Acceptance.CERTIFICATENO=@P_CertificateNo)
and Not (Acceptance.RANO<>-1 and Acceptance.RANO=@P_ANO)
and Not (Acceptance.PANO<>-1 and Acceptance.PANO=@P_ANO)
GO

DROP PROCEDURE ListDet_Prev
GO
CREATE PROCEDURE ListDet_Prev (@P_ANO as integer)   
AS  
Declare @P_PCNO as Int
Declare @P_PANO as Int
Declare @P_RANO as Int
Declare @P_CertificateNo as varchar(10)
Select @P_RANO=Acceptance.RANO, @P_PCNO=Cover.PCNO, @P_PANO=Acceptance.PANO, @P_CertificateNo=CERTIFICATENO from Acceptance, Cover Where Cover.CNO=Acceptance.CNO and Acceptance.ANO=@P_ANO

SELECT Cast(0 as bit) as ProcessFlag,
	Acceptance.CertificateNo, 
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
Inner Join SysTab on (1=1)
WHERE Acceptance.LANO<>-1 
And (@P_PANO<>-1 and Acceptance.ANO=@P_PANO)

Union All

SELECT Cast(0 as bit) as ProcessFlag,
	Acceptance.CertificateNo, 
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
Inner Join SysTab on (1=1)
WHERE Acceptance.LANO<>-1 
And (@P_RANO<>-1 and Acceptance.ANO=@P_RANO)
And Not (@P_PANO<>-1 and Acceptance.ANO=@P_PANO)

Union All

SELECT Cast(0 as bit) as ProcessFlag,
	Acceptance.CertificateNo, 
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
Inner Join SysTab on (1=1)
WHERE Acceptance.LANO<>-1 
And (@P_PCNO<>-1 and Cover.CNO=@P_PCNO and Acceptance.CERTIFICATENO=@P_CertificateNo)
And Not (@P_RANO<>-1 and Acceptance.ANO=@P_RANO)
And Not (@P_PANO<>-1 and Acceptance.ANO=@P_PANO)


GO

DROP PROCEDURE ListDet01
GO
CREATE PROCEDURE ListDet01 (@P_ANO as integer) 
AS 
SELECT Cast(0 as bit) as ProcessFlag,
	Acceptance.CertificateNo, 
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
FROM Acceptance left Join RArrHeader on (RArrHeader.ANO=Acceptance.ANO), Cover, SysTab, Acceptance MAcceptance 
WHERE MAcceptance.ANO=@P_ANO and Cover.CNO=MAcceptance.CNO 
And (Acceptance.LANO=MAcceptance.ANO And Acceptance.ANO<>Acceptance.LANO And Acceptance.LANO<>-1) 
 
Union 
 
SELECT Cast(0 as bit) as ProcessFlag,
	Acceptance.CertificateNo, 
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
FROM Acceptance left Join RArrHeader on (RArrHeader.ANO=Acceptance.ANO), Cover, SysTab, Acceptance MAcceptance 
WHERE MAcceptance.ANO=@P_ANO and Cover.CNO=MAcceptance.CNO 
And (MAcceptance.RegNo<>'' and Acceptance.RegNo=MAcceptance.RegNo and Acceptance.PolicyNo<>'' and Acceptance.PolicyNo=MAcceptance.PolicyNo And Acceptance.ANO<>Acceptance.LANO And Acceptance.LANO<>-1) 
 
Union 
 
SELECT Cast(0 as bit) as ProcessFlag,
	Acceptance.CertificateNo, 
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
FROM Acceptance left Join RArrHeader on (RArrHeader.ANO=Acceptance.ANO), Cover, SysTab, Acceptance MAcceptance 
WHERE MAcceptance.ANO=@P_ANO and Cover.CNO=MAcceptance.CNO 
And (MAcceptance.AStatus='W' and MAcceptance.AType<>'N' and MAcceptance.PANO<>-1 and Acceptance.LANO=MAcceptance.PANO And Acceptance.ANO<>Acceptance.LANO And Acceptance.LANO<>-1) 
Order By Acceptance.CertificateNo 

GO
DROP PROCEDURE dbo.ListDet02
GO
CREATE PROCEDURE dbo.ListDet02 (@P_ANO as integer) 
AS 
SELECT Cast(0 as bit) as ProcessFlag,
	Acceptance.CertificateNo, 
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
Inner Join SysTab on (1=1)
WHERE Acceptance.ANO=@P_ANO 
Order By Acceptance.CertificateNo 
 

GO
DROP PROCEDURE ListDet03
GO
CREATE PROCEDURE ListDet03 (@P_ANO as integer,@P_SDATE as smalldatetime, @P_EDATE as smalldatetime) 
AS 
SELECT Cast(0 as bit) as ProcessFlag,
	Acceptance.CertificateNo, 
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
FROM Acceptance left Join RArrHeader on (RArrHeader.ANO=Acceptance.ANO) , Cover, SysTab, Acceptance MAcceptance 
WHERE MAcceptance.ANO=@P_ANO and Cover.CNO=MAcceptance.CNO 
And (Acceptance.LANO=MAcceptance.ANO And Acceptance.ANO<>Acceptance.LANO And Acceptance.LANO<>-1) 
And Acceptance.ADate Between @P_Sdate and @P_EDate 
 
Union 
 
SELECT Cast(0 as bit) as ProcessFlag,
	Acceptance.CertificateNo, 
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
FROM Acceptance left Join RArrHeader on (RArrHeader.ANO=Acceptance.ANO) , Cover, SysTab, Acceptance MAcceptance 
WHERE MAcceptance.ANO=@P_ANO and Cover.CNO=MAcceptance.CNO 
And (MAcceptance.RegNo<>'' and Acceptance.RegNo=MAcceptance.RegNo and Acceptance.PolicyNo<>'' and Acceptance.PolicyNo=MAcceptance.PolicyNo And Acceptance.ANO<>Acceptance.LANO And Acceptance.LANO<>-1) 
And Acceptance.ADate Between @P_Sdate and @P_EDate 
 
Union 
 
SELECT Cast(0 as bit) as ProcessFlag,
	Acceptance.CertificateNo, 
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
FROM Acceptance left Join RArrHeader on (RArrHeader.ANO=Acceptance.ANO) , Cover, SysTab, Acceptance MAcceptance 
WHERE MAcceptance.ANO=@P_ANO and Cover.CNO=MAcceptance.CNO 
And (MAcceptance.AStatus='W' and MAcceptance.AType<>'N' and MAcceptance.PANO<>-1 and Acceptance.LANO=MAcceptance.PANO And Acceptance.ANO<>Acceptance.LANO And Acceptance.LANO<>-1) 
And Acceptance.ADate Between @P_Sdate and @P_EDate 
Order By Acceptance.CertificateNo 
 
GO
DROP PROCEDURE ListDet04
GO
CREATE PROCEDURE ListDet04 (@P_ANO as integer,@P_FCERTNO as varchar(20), @P_LCERTNO as varchar(20)) 
AS 
SELECT Cast(0 as bit) as ProcessFlag,
	Acceptance.CertificateNo, 
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
FROM Acceptance left Join RArrHeader on (RArrHeader.ANO=Acceptance.ANO) , Cover, SysTab, Acceptance MAcceptance 
WHERE MAcceptance.ANO=@P_ANO and Cover.CNO=MAcceptance.CNO 
And (Acceptance.LANO=MAcceptance.ANO And Acceptance.ANO<>Acceptance.LANO And Acceptance.LANO<>-1) 
And Acceptance.CertificateNo Between @P_FCertNo and @P_LCertNo 
 
Union 
 
SELECT Cast(0 as bit) as ProcessFlag,
	Acceptance.CertificateNo, 
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
FROM Acceptance left Join RArrHeader on (RArrHeader.ANO=Acceptance.ANO) , Cover, SysTab, Acceptance MAcceptance 
WHERE MAcceptance.ANO=@P_ANO and Cover.CNO=MAcceptance.CNO 
And (MAcceptance.RegNo<>'' and Acceptance.RegNo=MAcceptance.RegNo and Acceptance.PolicyNo<>'' and Acceptance.PolicyNo=MAcceptance.PolicyNo And Acceptance.ANO<>Acceptance.LANO And Acceptance.LANO<>-1) 
And Acceptance.CertificateNo Between @P_FCertNo and @P_LCertNo 
 
Union 
 
SELECT Cast(0 as bit) as ProcessFlag,
	Acceptance.CertificateNo, 
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
FROM Acceptance left Join RArrHeader on (RArrHeader.ANO=Acceptance.ANO) , Cover, SysTab, Acceptance MAcceptance 
WHERE MAcceptance.ANO=@P_ANO and Cover.CNO=MAcceptance.CNO 
And (MAcceptance.AStatus='W' and MAcceptance.AType<>'N' and MAcceptance.PANO<>-1 and Acceptance.LANO=MAcceptance.PANO And Acceptance.ANO<>Acceptance.LANO And Acceptance.LANO<>-1) 
And Acceptance.CertificateNo Between @P_FCertNo and @P_LCertNo 
Order By Acceptance.CertificateNo 
 
GO 

DROP PROCEDURE ListDet05
GO
CREATE PROCEDURE ListDet05 (@P_ANO as integer,@P_FBATCHNO as varchar(20), @P_LBATCHNO as varchar(20)) 
AS 
SELECT Cast(0 as bit) as ProcessFlag,
	Acceptance.CertificateNo, 
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
FROM Acceptance left Join RArrHeader on (RArrHeader.ANO=Acceptance.ANO) , Cover, SysTab, Acceptance MAcceptance 
WHERE MAcceptance.ANO=@P_ANO and Cover.CNO=MAcceptance.CNO 
And (Acceptance.LANO=MAcceptance.ANO And Acceptance.ANO<>Acceptance.LANO And Acceptance.LANO<>-1) 
And Acceptance.BatchNo Between @P_FBatchNo and @P_LBatchNo 
 
Union 
 
SELECT Cast(0 as bit) as ProcessFlag,
	Acceptance.CertificateNo, 
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
FROM Acceptance left Join RArrHeader on (RArrHeader.ANO=Acceptance.ANO) , Cover, SysTab, Acceptance MAcceptance 
WHERE MAcceptance.ANO=@P_ANO and Cover.CNO=MAcceptance.CNO 
And (MAcceptance.RegNo<>'' and Acceptance.RegNo=MAcceptance.RegNo and Acceptance.PolicyNo<>'' and Acceptance.PolicyNo=MAcceptance.PolicyNo And Acceptance.ANO<>Acceptance.LANO And Acceptance.LANO<>-1) 
And Acceptance.BatchNo Between @P_FBatchNo and @P_LBatchNo 
 
Union 
 
SELECT Cast(0 as bit) as ProcessFlag,
	Acceptance.CertificateNo, 
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
FROM Acceptance left Join RArrHeader on (RArrHeader.ANO=Acceptance.ANO) , Cover, SysTab, Acceptance MAcceptance 
WHERE MAcceptance.ANO=@P_ANO and Cover.CNO=MAcceptance.CNO 
And (MAcceptance.AStatus='W' and MAcceptance.AType<>'N' and MAcceptance.PANO<>-1 and Acceptance.LANO=MAcceptance.PANO And Acceptance.ANO<>Acceptance.LANO And Acceptance.LANO<>-1) 
And Acceptance.BatchNo Between @P_FBatchNo and @P_LBatchNo 
Order By Acceptance.CertificateNo 
 

GO


DROP FUNCTION SListSR_Det
GO
CREATE FUNCTION SListSR_Det (@P_ANO as int, @P_ID as int)    
RETURNS Table    
AS RETURN(    
          
SELECT Cast(0 as bit) as ProcessFlag,
	Acceptance.CertificateNo, 
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
 SysRequest,    
 Service    
Where    
 Acceptance.ANO<>Acceptance.LANO    
 And Acceptance.LANO=@P_ANO    
 And SysRequest.ID=@P_ID    
 And SysRequest.Param2 in ('SVC')    
 And SysRequest.Param3=Service.SNO    
 And Acceptance.ANO=Service.PANO    
 ) 
GO 

---Marketing

GO


DROP FUNCTION SMListSR_Det
GO
CREATE FUNCTION SMListSR_Det (@P_ANO as int, @P_ID as int)  
RETURNS Table  
AS RETURN(  
        
SELECT 
	Cast(0 as bit) as ProcessFlag, 
	Cover.COVERNO, 
	Cast(Acceptance.AName as varchar(128)) as AName, 
	Acceptance.CertificateNo, 
	Acceptance.ERSeqNo, 
	Cover.CNO, 
	Cover.CStatus, 
	Cover.VSeqNo, 
	Acceptance.LANO, 
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
	Acceptance.ValueID, 
	dbo.get_objectInfo(Acceptance.ANO) as ValueDesc,
	Year(RArrHeader.RDate) as RYear
FROM Acceptance
Inner Join RArrHeader on (RArrHeader.ANO=Acceptance.ANO)
Inner Join Cover on (Cover.CNO=Acceptance.CNO)
Inner Join SysTab on (1=1),
 SysRequest  
Where  
 Acceptance.ANO<>Acceptance.LANO  
 And Acceptance.LANO=@P_ANO  
 And SysRequest.ID=@P_ID  
 And SysRequest.Param2 in ('SVC')    
 And SysRequest.Param3=Acceptance.ANO  
 )  
 
GO

DROP FUNCTION MList01_DET
GO
CREATE FUNCTION MList01_DET(@P_ANO AS INTEGER,@P_USERID as varchar(50)) 
RETURNS TABLE
AS RETURN(
SELECT 
	Cast(0 as bit) as ProcessFlag, 
	Cover.COVERNO, 
	Cast(Acceptance.AName as varchar(128)) as AName, 
	Acceptance.CertificateNo, 
	Acceptance.ERSeqNo, 
	Cover.CNO, 
	Cover.CStatus, 
	Cover.VSeqNo, 
	Acceptance.LANO, 
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
	Acceptance.ValueID, 
	dbo.get_objectInfo(Acceptance.ANO) as ValueDesc,
	Year(RArrHeader.RDate) as RYear
FROM Acceptance 
left Join RArrHeader on (RArrHeader.ANO=Acceptance.ANO) 
Inner Join Cover on (Cover.CNO=Acceptance.CNO)
Inner Join SysTab on (1=1)
WHERE 
	Acceptance.ANO<>Acceptance.LANO 
	And Acceptance.LANO=@P_ANO
	And Acceptance.LUserID Like @P_UserID
	And Cover.CStatus='R'
)



GO



DROP FUNCTION MList01A_DET
GO
CREATE FUNCTION MList01A_DET(@P_ANO AS INTEGER,@P_DATE as SmallDatetime) 
RETURNS TABLE
AS RETURN (
SELECT 
	Cast(0 as bit) as ProcessFlag, 
	Cover.COVERNO, 
	Cast(Acceptance.AName as varchar(128)) as AName, 
	Acceptance.CertificateNo, 
	Acceptance.ERSeqNo, 
	Cover.CNO, 
	Cover.CStatus, 
	Cover.VSeqNo, 
	Acceptance.LANO, 
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
	Acceptance.ValueID, 
	dbo.get_objectInfo(Acceptance.ANO) as ValueDesc,
	Year(RArrHeader.RDate) as RYear
FROM Acceptance 
left Join RArrHeader on (RArrHeader.ANO=Acceptance.ANO) 
Inner Join Cover on (Cover.CNO=Acceptance.CNO)
Inner Join SysTab on (1=1)
WHERE 
	Acceptance.ANO<>Acceptance.LANO 
	And Acceptance.LANO=@P_ANO
	And Cover.CStatus='R'
	And Cover.CDate+Cover.Validation<=@p_Date
)

GO

DROP FUNCTION MLIST02_DET
GO
CREATE FUNCTION MLIST02_DET (@P_ANO AS INTEGER) 
RETURNS TABLE
AS RETURN(
SELECT 
	Cast(0 as bit) as ProcessFlag, 
	Cover.COVERNO, 
	Cast(Acceptance.AName as varchar(128)) as AName, 
	Acceptance.CertificateNo, 
	Acceptance.ERSeqNo, 
	Cover.CNO, 
	Cover.CStatus, 
	Cover.VSeqNo, 
	Acceptance.LANO, 
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
	Acceptance.ValueID, 
	dbo.get_objectInfo(Acceptance.ANO) as ValueDesc,
	Year(RArrHeader.RDate) as RYear
FROM Acceptance 
left Join RArrHeader on (RArrHeader.ANO=Acceptance.ANO) 
Inner Join Cover on (Cover.CNO=Acceptance.CNO)
Inner Join SysTab on (1=1)
WHERE 
	Acceptance.ANO<>Acceptance.LANO 
	And Acceptance.LANO=@P_ANO 
	And Acceptance.AType='N' 
	And Acceptance.AStatus='W' 
	And Cover.CStatus='A'
)


GO
DROP FUNCTION MList03_DET 
GO
CREATE FUNCTION MList03_DET (@P_ANO AS INTEGER,@P_USERID as varchar(50)) 
RETURNS TABLE
AS RETURN(
SELECT 
	Cast(0 as bit) as ProcessFlag, 
	Cover.COVERNO, 
	Cast(Acceptance.AName as varchar(128)) as AName, 
	Acceptance.CertificateNo, 
	Acceptance.ERSeqNo, 
	Cover.CNO, 
	Cover.CStatus, 
	Cover.VSeqNo, 
	Acceptance.LANO, 
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
	Acceptance.ValueID, 
	dbo.get_objectInfo(Acceptance.ANO) as ValueDesc,
	Year(RArrHeader.RDate) as RYear
FROM Acceptance 
left Join RArrHeader on (RArrHeader.ANO=Acceptance.ANO) 
Inner Join Cover on (Cover.CNO=Acceptance.CNO)
Inner Join SysTab on (1=1)
WHERE 
	Acceptance.ANO<>Acceptance.LANO 
	And Acceptance.LANO=@P_ANO 
	And Acceptance.AType='N' 
	And Acceptance.AStatus='C' 
	And Cover.CStatus='C'
	And Acceptance.LUserID Like @P_UserID
)

GO
DROP FUNCTION MList04_DET
GO
CREATE FUNCTION MList04_DET(@P_ANO AS INTEGER,@P_USERID as varchar(50))
RETURNS Table
AS RETURN(
SELECT 
	Cast(0 as bit) as ProcessFlag, 
	Cover.COVERNO, 
	Cast(Acceptance.AName as varchar(128)) as AName, 
	Acceptance.CertificateNo, 
	Acceptance.ERSeqNo, 
	Cover.CNO, 
	Cover.CStatus, 
	Cover.VSeqNo, 
	Acceptance.LANO, 
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
	Acceptance.ValueID, 
	dbo.get_objectInfo(Acceptance.ANO) as ValueDesc,
	Year(RArrHeader.RDate) as RYear
FROM Acceptance 
left Join RArrHeader on (RArrHeader.ANO=Acceptance.ANO) 
Inner Join Cover on (Cover.CNO=Acceptance.CNO)
Inner Join SysTab on (1=1)
Where
 Acceptance.ANO<>Acceptance.LANO
 And Acceptance.LANO=@P_ANO
 And Acceptance.LUserID Like @P_UserID
 And Cover.CStatus='R'
)
  
  
GO  

DROP FUNCTION MList04a_Det
GO

CREATE FUNCTION MList04a_Det (@P_ANO AS INTEGER, @p_date as smalldatetime)
RETURNS TABLE
AS RETURN(
SELECT 
	Cast(0 as bit) as ProcessFlag, 
	Cover.COVERNO, 
	Cast(Acceptance.AName as varchar(128)) as AName, 
	Acceptance.CertificateNo, 
	Acceptance.ERSeqNo, 
	Cover.CNO, 
	Cover.CStatus, 
	Cover.VSeqNo, 
	Acceptance.LANO, 
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
	Acceptance.ValueID, 
	dbo.get_objectInfo(Acceptance.ANO) as ValueDesc,
	Year(RArrHeader.RDate) as RYear
FROM Acceptance 
left Join RArrHeader on (RArrHeader.ANO=Acceptance.ANO) 
Inner Join Cover on (Cover.CNO=Acceptance.CNO)
Inner Join SysTab on (1=1)
WHERE 
	Acceptance.ANO<>Acceptance.LANO 
	And Acceptance.LANO=@P_ANO
	And Cover.CStatus='P' 
	And Cover.CDate+Cover.Validation<=@p_Date
)


GO
DROP FUNCTION MList04b_DET
GO

CREATE FUNCTION MList04b_DET(@P_ANO AS INTEGER, @p_date as smalldatetime)
RETURNS TABLE
AS RETURN(
SELECT 
	Cast(0 as bit) as ProcessFlag, 
	Cover.COVERNO, 
	Cast(Acceptance.AName as varchar(128)) as AName, 
	Acceptance.CertificateNo, 
	Acceptance.ERSeqNo, 
	Cover.CNO, 
	Cover.CStatus, 
	Cover.VSeqNo, 
	Acceptance.LANO, 
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
	Acceptance.ValueID, 
	dbo.get_objectInfo(Acceptance.ANO) as ValueDesc,
	Year(RArrHeader.RDate) as RYear
FROM Acceptance 
left Join RArrHeader on (RArrHeader.ANO=Acceptance.ANO) 
Inner Join Cover on (Cover.CNO=Acceptance.CNO)
Inner Join SysTab on (1=1)
WHERE 
	Acceptance.ANO<>Acceptance.LANO 
	And Acceptance.LANO=@P_ANO
	And Acceptance.AType='N' 
	And Acceptance.AStatus='W' 
	And Cover.CStatus='A' 
	And Cover.CDate+Cover.Validation<=@p_Date
)

GO


DROP FUNCTION MList04c_DET
GO

CREATE FUNCTION MList04c_DET(@P_ANO AS INTEGER, @p_date as smalldatetime)
RETURNS TABLE
AS RETURN(
SELECT 
	Cast(0 as bit) as ProcessFlag, 
	Cover.COVERNO, 
	Cast(Acceptance.AName as varchar(128)) as AName, 
	Acceptance.CertificateNo, 
	Acceptance.ERSeqNo, 
	Cover.CNO, 
	Cover.CStatus, 
	Cover.VSeqNo, 
	Acceptance.LANO, 
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
	Acceptance.ValueID, 
	dbo.get_objectInfo(Acceptance.ANO) as ValueDesc,
	Year(RArrHeader.RDate) as RYear
FROM Acceptance 
left Join RArrHeader on (RArrHeader.ANO=Acceptance.ANO) 
Inner Join Cover on (Cover.CNO=Acceptance.CNO)
Inner Join SysTab on (1=1)
WHERE 
	Acceptance.ANO<>Acceptance.LANO 
	And Acceptance.LANO=@P_ANO
	And Acceptance.AType='N' 
	And Acceptance.AStatus='W' 
	And Cover.CStatus='C' 
	And Cover.CDate+Cover.Validation=@p_Date
	And Cover.Validation<>0 
)


GO

DROP FUNCTION MList05_DET
GO


CREATE FUNCTION MList05_DET (@P_ANO AS INTEGER,@P_USERID as varchar(50)) 
RETURNS TABLE
AS RETURN(
SELECT 
	Cast(0 as bit) as ProcessFlag, 
	Cover.COVERNO, 
	Cast(Acceptance.AName as varchar(128)) as AName, 
	Acceptance.CertificateNo, 
	Acceptance.ERSeqNo, 
	Cover.CNO, 
	Cover.CStatus, 
	Cover.VSeqNo, 
	Acceptance.LANO, 
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
	Acceptance.ValueID, 
	dbo.get_objectInfo(Acceptance.ANO) as ValueDesc,
	Year(RArrHeader.RDate) as RYear
FROM Acceptance 
left Join RArrHeader on (RArrHeader.ANO=Acceptance.ANO) 
Inner Join Cover on (Cover.CNO=Acceptance.CNO)
Inner Join SysTab on (1=1)
WHERE 
	Acceptance.ANO<>Acceptance.LANO 
	And Acceptance.LANO=@P_ANO
	And Acceptance.AType='N' 
	And Acceptance.AStatus='W' 
	And Acceptance.LUserID Like @P_UserID
	And Cover.CStatus='P'
)


GO

DROP FUNCTION MList06_DET 
GO

CREATE FUNCTION MList06_DET (@P_ANO AS INTEGER,@P_USERID as varchar(50)) 
RETURNS TABLE
AS RETURN(
SELECT 
	Cast(0 as bit) as ProcessFlag, 
	Cover.COVERNO, 
	Cast(Acceptance.AName as varchar(128)) as AName, 
	Acceptance.CertificateNo, 
	Acceptance.ERSeqNo, 
	Cover.CNO, 
	Cover.CStatus, 
	Cover.VSeqNo, 
	Acceptance.LANO, 
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
	Acceptance.ValueID, 
	dbo.get_objectInfo(Acceptance.ANO) as ValueDesc,
	Year(RArrHeader.RDate) as RYear
FROM Acceptance 
left Join RArrHeader on (RArrHeader.ANO=Acceptance.ANO) 
Inner Join Cover on (Cover.CNO=Acceptance.CNO)
Inner Join SysTab on (1=1)
WHERE 
	Acceptance.ANO<>Acceptance.LANO 
	And Acceptance.LANO=@P_ANO
	And Acceptance.AType='N' 
	And Acceptance.AStatus='W' 
	And Cover.CStatus='V'
	And Acceptance.LUserID Like @P_UserID 
)

GO
DROP FUNCTION MList07_DET  
GO

CREATE FUNCTION MList07_DET (@P_ANO AS INTEGER,@P_USERID as varchar(50)) 
RETURNS TABLE
AS RETURN(
SELECT 
	Cast(0 as bit) as ProcessFlag, 
	Cover.COVERNO, 
	Cast(Acceptance.AName as varchar(128)) as AName, 
	Acceptance.CertificateNo, 
	Acceptance.ERSeqNo, 
	Cover.CNO, 
	Cover.CStatus, 
	Cover.VSeqNo, 
	Acceptance.LANO, 
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
	Acceptance.ValueID, 
	dbo.get_objectInfo(Acceptance.ANO) as ValueDesc,
	Year(RArrHeader.RDate) as RYear
FROM Acceptance 
left Join RArrHeader on (RArrHeader.ANO=Acceptance.ANO) 
Inner Join Cover on (Cover.CNO=Acceptance.CNO)
Inner Join SysTab on (1=1)
WHERE 
	Acceptance.ANO<>Acceptance.LANO 
	And Acceptance.LANO=@P_ANO 
	And Acceptance.AType='N' 
	And Acceptance.AStatus='W' 
	And Acceptance.Renewal>0
	And Acceptance.LUserID Like @P_UserID  
)

GO

DROP function MList11D
GO
CREATE function MList11D(@P_ANO AS INTEGER, @value1 as varchar(255) ,@value2 as varchar(255) ,@value3 as varchar(255) ,@value4 as varchar(255) ,@value5 as varchar(255) ,@value6 as varchar(255) ,@Value7 as varchar(255) ,@value8 as varchar(255) ,@value9 as varchar(255),@Value10 as varchar(255), @Value11 as varchar(255), @Value12 as varchar(255), @Value13 as varchar(255))  
returns table  
AS return  
(  
SELECT 
	Cast(0 as bit) as ProcessFlag, 
	Cover.COVERNO, 
	Cast(Acceptance.AName as varchar(128)) as AName, 
	Acceptance.CertificateNo, 
	Acceptance.ERSeqNo, 
	Cover.CNO, 
	Cover.CStatus, 
	Cover.VSeqNo, 
	Acceptance.LANO, 
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
	Acceptance.ValueID, 
	dbo.get_objectInfo(Acceptance.ANO) as ValueDesc,
	Year(RArrHeader.RDate) as RYear
FROM Acceptance 
left Join RArrHeader on (RArrHeader.ANO=Acceptance.ANO) 
Inner Join Cover on (Cover.CNO=Acceptance.CNO)
Inner Join SysTab on (1=1)
Inner join Profile on (Profile.ID=Cover.PHolder)
WHERE   
 Acceptance.ANO<>Acceptance.LANO   
 And Acceptance.LANO=@P_ANO  
 And (Cover.Insured Like @Value1 Or (Cover.Insured is null))   
 And (Cover.CoverNo Like @Value2 Or (Cover.CoverNo is null))   
 And (cover.coverdate=@Value3 Or (cover.coverdate IS NULL) Or cover.coverdate='' or @Value3='')  
 And (cover.expdate=@Value4 Or (cover.expdate IS NULL) Or cover.expdate='' or @Value4='')    
 And (Acceptance.PolicyNo Like @Value5 Or (Acceptance.PolicyNo is null))   
 And (Acceptance.CertificateNo Like @Value6 Or (Acceptance.CertificateNo is null))   
 And (acceptance.policydate=@Value7 Or (acceptance.policydate IS NULL) Or acceptance.policydate='' or @Value7='')  
 And (Cover.CStatus Like @Value8)   
 And (Acceptance.RegNo Like @Value9)   
 And (Profile.Name like @Value10 or Profile.Name is null)  
 and Acceptance.toc like @Value11  
 And (Acceptance.RefNo Like @Value13)   
 And Cover.ISType<>'T'  
)  
  

GO

DROP FUNCTION MList14_DET 
GO
CREATE FUNCTION MList14_DET (@P_ANO AS INTEGER,@P_USERID as varchar(50)) 
RETURNS TABLE
AS RETURN(
SELECT 
	Cast(0 as bit) as ProcessFlag, 
	Cover.COVERNO, 
	Cast(Acceptance.AName as varchar(128)) as AName, 
	Acceptance.CertificateNo, 
	Acceptance.ERSeqNo, 
	Cover.CNO, 
	Cover.CStatus, 
	Cover.VSeqNo, 
	Acceptance.LANO, 
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
	Acceptance.ValueID, 
	dbo.get_objectInfo(Acceptance.ANO) as ValueDesc,
	Year(RArrHeader.RDate) as RYear
FROM Acceptance 
left Join RArrHeader on (RArrHeader.ANO=Acceptance.ANO) 
Inner Join Cover on (Cover.CNO=Acceptance.CNO)
Inner Join SysTab on (1=1)
WHERE 
	Acceptance.ANO<>Acceptance.LANO 
	And Acceptance.LANO=@P_ANO
	And ((RArrHeader.TreatyF=1 And (RArrheader.TShare<>100 or RArrHeader.RAmount<>0)) or RArrHeader.HoldF=1)
	And Acceptance.AStatus='W'
	And Acceptance.LUserID Like @P_UserID
)

GO

DROP FUNCTION MList15_DET 
GO
CREATE FUNCTION MList15_DET (@P_ANO AS INTEGER, @P_ID as varchar(10)) 
RETURNS TABLE
AS RETURN(
SELECT 
	Cast(0 as bit) as ProcessFlag, 
	Cover.COVERNO, 
	Cast(Acceptance.AName as varchar(128)) as AName, 
	Acceptance.CertificateNo, 
	Acceptance.ERSeqNo, 
	Cover.CNO, 
	Cover.CStatus, 
	Cover.VSeqNo, 
	Acceptance.LANO, 
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
	Acceptance.ValueID, 
	dbo.get_objectInfo(Acceptance.ANO) as ValueDesc,
	Year(RArrHeader.RDate) as RYear
FROM Acceptance 
left Join RArrHeader on (RArrHeader.ANO=Acceptance.ANO) 
Inner Join Cover on (Cover.CNO=Acceptance.CNO)
Inner Join SysTab on (1=1)
Left Join APayor on (APayor.ANO=Acceptance.ANO)
Left Join Payor on (Payor.ANO=Acceptance.LANO)
WHERE 
	Acceptance.ANO<>Acceptance.LANO 
	And Acceptance.LANO=@P_ANO 
	And coalesce(APayor.ID,Payor.ID)=@P_ID
	And Acceptance.AType='N' 
	And Acceptance.AStatus='W' 
	And Cover.CStatus in ('R' ,'P','A')
)

GO
DROP FUNCTION MList20_DET
GO
CREATE FUNCTION MList20_DET(@P_ANO AS INTEGER,@P_USERID as varchar(255),@P_SDate as smalldatetime, @P_EDate as smalldatetime,@P_CStatus as varchar(1))
RETURNS Table
AS RETURN(
SELECT 
	Cast(0 as bit) as ProcessFlag, 
	Cover.COVERNO, 
	Cast(Acceptance.AName as varchar(128)) as AName, 
	Acceptance.CertificateNo, 
	Acceptance.ERSeqNo, 
	Cover.CNO, 
	Cover.CStatus, 
	Cover.VSeqNo, 
	Acceptance.LANO, 
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
	Acceptance.ValueID, 
	dbo.get_objectInfo(Acceptance.ANO) as ValueDesc,
	Year(RArrHeader.RDate) as RYear
FROM Acceptance 
left Join RArrHeader on (RArrHeader.ANO=Acceptance.ANO) 
Inner Join Cover on (Cover.CNO=Acceptance.CNO)
Inner Join SysTab on (1=1)
Where
 Acceptance.ANO<>Acceptance.LANO
 And Acceptance.LANO=@P_ANO
 And Cover.LUserID Like @P_UserID
 And Cover.LDate Between @P_SDate and @P_EDate
 And (Cover.CStatus=@P_CStatus or @P_CStatus='') 
)


GO
DROP FUNCTION MListSR_Det
GO

CREATE FUNCTION MListSR_Det (@P_ANO as int, @P_ID as int)    
RETURNS Table    
AS RETURN(    
          
SELECT 
	Cast(0 as bit) as ProcessFlag, 
	Cover.COVERNO, 
	Cast(Acceptance.AName as varchar(128)) as AName, 
	Acceptance.CertificateNo, 
	Acceptance.ERSeqNo, 
	Cover.CNO, 
	Cover.CStatus, 
	Cover.VSeqNo, 
	Acceptance.LANO, 
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
	Acceptance.ValueID, 
	dbo.get_objectInfo(Acceptance.ANO) as ValueDesc,
	Year(RArrHeader.RDate) as RYear
FROM Acceptance 
left Join RArrHeader on (RArrHeader.ANO=Acceptance.ANO) 
Inner Join Cover on (Cover.CNO=Acceptance.CNO)
Inner Join SysTab on (1=1),
 SysRequest    
Where    
 Acceptance.ANO<>Acceptance.LANO    
 And Acceptance.LANO=@P_ANO    
 And SysRequest.ID=@P_ID    
 And SysRequest.Param2 in ('MAR','UND','CLM')    
 And SysRequest.Param3=Acceptance.ANO     
 )
 
GO

DROP PROCEDURE MListDet_By_ANO
GO
CREATE PROCEDURE MListDet_By_ANO (@P_ANO as integer) 
AS 
SELECT 
	Cast(0 as bit) as ProcessFlag, 
	Cover.COVERNO, 
	Cast(Acceptance.AName as varchar(128)) as AName, 
	Acceptance.CertificateNo, 
	Acceptance.ERSeqNo, 
	Cover.CNO, 
	Cover.CStatus, 
	Cover.VSeqNo, 
	Acceptance.LANO, 
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
	Acceptance.ValueID, 
	dbo.get_objectInfo(Acceptance.ANO) as ValueDesc,
	Year(RArrHeader.RDate) as RYear
FROM Acceptance 
left Join RArrHeader on (RArrHeader.ANO=Acceptance.ANO) 
Inner Join Cover on (Cover.CNO=Acceptance.CNO)
Inner Join SysTab on (1=1)
WHERE Acceptance.ANO=@P_ANO 
 
 
GO

DROP PROCEDURE MListDet01
GO
CREATE PROCEDURE MListDet01(@P_ANO as Integer) 
AS 
SELECT 
	Cast(0 as bit) as ProcessFlag, 
	Cover.COVERNO, 
	Cast(Acceptance.AName as varchar(128)) as AName, 
	Acceptance.CertificateNo, 
	Acceptance.ERSeqNo, 
	Cover.CNO, 
	Cover.CStatus, 
	Cover.VSeqNo, 
	Acceptance.LANO, 
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
	Acceptance.ValueID, 
	dbo.get_objectInfo(Acceptance.ANO) as ValueDesc,
	Year(RArrHeader.RDate) as RYear
FROM Acceptance 
left Join RArrHeader on (RArrHeader.ANO=Acceptance.ANO) 
Inner Join Cover on (Cover.CNO=Acceptance.CNO)
Inner Join SysTab on (1=1)
Where Acceptance.ANO<>Acceptance.LANO 
And Acceptance.LANO=@P_ANO 
Order By Acceptance.CertificateNo 
 
 

GO

DROP PROCEDURE MLISTDET02
GO
CREATE PROCEDURE MLISTDET02(@P_ANO as Integer) 
AS 
SELECT 
	Cast(0 as bit) as ProcessFlag, 
	Cover.COVERNO, 
	Cast(Acceptance.AName as varchar(128)) as AName, 
	Acceptance.CertificateNo, 
	Acceptance.ERSeqNo, 
	Cover.CNO, 
	Cover.CStatus, 
	Cover.VSeqNo, 
	Acceptance.LANO, 
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
	Acceptance.ValueID, 
	dbo.get_objectInfo(Acceptance.ANO) as ValueDesc,
	Year(RArrHeader.RDate) as RYear
FROM Acceptance 
left Join RArrHeader on (RArrHeader.ANO=Acceptance.ANO) 
Inner Join Cover on (Cover.CNO=Acceptance.CNO)
Inner Join SysTab on (1=1)
Where Acceptance.ANO<>Acceptance.LANO 
And Acceptance.ANO=@P_ANO 
Order By Acceptance.CertificateNo 
 
GO 

DROP PROCEDURE MLISTDET03
GO
CREATE PROCEDURE MLISTDET03(@P_ANO as Integer, @P_SDATE AS SMALLDATETIME, @P_EDATE AS SMALLDATETIME) 
AS 
SELECT 
	Cast(0 as bit) as ProcessFlag, 
	Cover.COVERNO, 
	Cast(Acceptance.AName as varchar(128)) as AName, 
	Acceptance.CertificateNo, 
	Acceptance.ERSeqNo, 
	Cover.CNO, 
	Cover.CStatus, 
	Cover.VSeqNo, 
	Acceptance.LANO, 
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
	Acceptance.ValueID, 
	dbo.get_objectInfo(Acceptance.ANO) as ValueDesc,
	Year(RArrHeader.RDate) as RYear
FROM Acceptance 
left Join RArrHeader on (RArrHeader.ANO=Acceptance.ANO) 
Inner Join Cover on (Cover.CNO=Acceptance.CNO)
Inner Join SysTab on (1=1)
Where Acceptance.ANO<>Acceptance.LANO 
And Acceptance.LANO=@P_ANO 
AND (ACCEPTANCE.SDATE BETWEEN @P_SDATE AND @P_EDATE) 
Order By Acceptance.CertificateNo 
 

GO

DROP PROCEDURE MListDet04
GO
CREATE PROCEDURE MListDet04(@P_ANO as integer,@P_FCERTNO as varchar(20), @P_LCERTNO as varchar(20)) 
AS 
SELECT 
	Cast(0 as bit) as ProcessFlag, 
	Cover.COVERNO, 
	Cast(Acceptance.AName as varchar(128)) as AName, 
	Acceptance.CertificateNo, 
	Acceptance.ERSeqNo, 
	Cover.CNO, 
	Cover.CStatus, 
	Cover.VSeqNo, 
	Acceptance.LANO, 
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
	Acceptance.ValueID, 
	dbo.get_objectInfo(Acceptance.ANO) as ValueDesc,
	Year(RArrHeader.RDate) as RYear
FROM Acceptance 
left Join RArrHeader on (RArrHeader.ANO=Acceptance.ANO) 
Inner Join Cover on (Cover.CNO=Acceptance.CNO)
Inner Join SysTab on (1=1)
WHERE Acceptance.ANO<>Acceptance.LANO 
And Acceptance.LANO=@P_ANO 
And Acceptance.CertificateNo Between @P_FCertNo and @P_LCertNo 
Order By Acceptance.CertificateNo 
 
 
go



 insert into PatchVersioning
select '333 Update Script - Patch 2022 (51)',GETDATE()
go


Declare @PrevScript varchar(100)
Declare @CurrScript varchar(100)

Select @PrevScript=''
Select @CurrSCript='333 Update Script - Patch 2022 (51)'


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






