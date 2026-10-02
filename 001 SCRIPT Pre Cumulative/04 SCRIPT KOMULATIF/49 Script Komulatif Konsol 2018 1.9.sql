
--12 jun 2018
/* To prevent any potential data loss issues, you should review this script in detail before running it outside the context of the database designer.*/
BEGIN TRANSACTION
SET QUOTED_IDENTIFIER ON
SET ARITHABORT ON
SET NUMERIC_ROUNDABORT OFF
SET CONCAT_NULL_YIELDS_NULL ON
SET ANSI_NULLS ON
SET ANSI_PADDING ON
SET ANSI_WARNINGS ON
COMMIT
BEGIN TRANSACTION
GO
ALTER TABLE dbo.TOP_Interest ADD
	CURRENCY_OC varchar(10) NULL
GO
DECLARE @v sql_variant 
SET @v = N'If Filled, Fixed Interest Currency'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'TOP_Interest', N'COLUMN', N'CURRENCY_OC'
GO
UPDATE TOP_INTEREST SET CURRENCY_OC='' WHERE CURRENCY_OC IS NULL
COMMIT

--tuning app

alter table AccRegDet Drop Constraint I_ACCREGDET
GO
Drop Index AccRegDet.I_ACCREGDET_REGNO
GO
Alter Table ClaRegDet Drop Constraint I_CLAREGDET
GO
drop index CLAREGDET.I_CLAREGDET_REGNO
GO
Alter Table accregdet drop constraint I_ACCREGDET
GO
Drop index ACCREGDET.I_AccRegDet_RegID_FLDID_VALUEID_RTYPE
GO
Alter Table CLAREGDET drop constraint I_CLAREGDET
GO
Drop index CLAREGDET.I_CLAREGDET_REGNO

GO
Create Unique Index I_ACCREGDET on ACCREGDET(REGNO)
GO
Create Unique Index I_CLAREGDET on CLAREGDET(REGNO)
GO
Create Index I_AccRegDet_RegID_FLDID_VALUEID_RTYPE_RYear on ACCREGDET(REGID, FLDID, VALUEID, RTYPE, RYEAR)
GO
Create Index I_ClaRegDet_RTYPE_EVENTNO_RYEAR on ClaRegDet(RType, EventNo, RYear)
go

drop index claim.i_CLAIM_BCNO
GO
drop index RArrHeader.I_RArrHeader_ANO_NRDate
GO
drop index Cover.i_COVER_BCNO
GO
drop index Cover.i_COVER_TOC
GO
drop index renewal.I_Renewal_EDate
GO
drop index renewal.I_Renewal_NewANO
GO
drop index renewal.I_Renewal_PolicyNo_CertificateNo
GO
drop index renewal.I_Renewal_TOC
GO
drop index ProAcc.I_ProAcc_ID
GO
drop index ProAcc.I_ProAcc_Bank_BankBranch
GO
Create Index I_ProAcc_ID on ProAcc(ID)
GO
Create Index I_ProAcc_ID_Currency on ProAcc(ID,Currency)

go


--uPDATE SCRIPT TERKAIT TREATY REAL 
DROP PROCEDURE Treaty_Adjustment_Detail
GO
CREATE PROCEDURE Treaty_Adjustment_Detail (@P_ADATE as smallDatetime, @P_REGID as varchar(10), @P_FLDID as varchar(255), @P_VALUEID as varchar(255), @P_RYEAR as integer)
AS
SELECT ACCEPTANCE.ANO, RARRHEADER.STATUS, ACCEPTANCE.ASTATUS, ACCEPTANCE.ADATE
From acceptance, RARRHEADER
WHERE ACCEPTANCE.REGID=@P_REGID AND ACCEPTANCE.FLDID=@P_FLDID And ACCEPTANCE.VALUEID=@P_VALUEID And ACCEPTANCE.ANO=RARRHEADER.ANO And YEAR(RARRHEADER.RDATE)=@P_RYEAR And ACCEPTANCE.ASTATUS='W' AND RARRHEADER.STATUS='A'
    
GO  


DROP PROCEDURE TREATY_ADJUSTMENT_LIMIT 
GO
CREATE PROCEDURE TREATY_ADJUSTMENT_LIMIT (@P_REGID as varchar(10), @P_FLDID as varchar(255), @P_VALUEID as varchar(255))      
AS      
Select MIN(LIMIT) AS LIMIT, MAX(YEAR(RARRHEADER.RDATE)) as RYEAR    
From RARRHEADER, acceptance      
WHERE RARRHEADER.STATUS='A' AND RARRHEADER.ANO=ACCEPTANCE.ANO AND ACCEPTANCE.ASTATUS='W' and ACCEPTANCE.REGID=@P_REGID AND ACCEPTANCE.FLDID=@P_FLDID AND ACCEPTANCE.VALUEID=@P_VALUEID      
        
    
GO

DROP Procedure Treaty_Adjustment_Q
GO
CREATE Procedure Treaty_Adjustment_Q(@P_ADATE smalldatetime, @P_REGID varchar(10), @P_FLDID varchar ( 255 ), @P_VALUEID varchar ( 255 ))    
as    
SELECT YEAR(RARRHEADER.RDATE) AS RYEAR,     
SUM((RArrHeader.TAmount-RArrHeader.FAmount)-RARRHEADER.MAMOUNT) AS SI,    
MIN(CASE WHEN RECLASS.CESSIONF=1 THEN 1 ELSE 0 END) AS CLIMIT,    
MIN(CASE WHEN RECLASS.ASSESSMENTF=1 THEN 1 ELSE 0 END) AS RLIMIT,    
MIN(CASE WHEN RECLASS.LIMIT<>0 THEN RECLASS.LIMIT ELSE REINSURANCE.LIMIT END) AS LIMIT,    
MIN(RECLASS.PLIMIT) as PLIMIT,  
SUM((RARRHEADER.QAMOUNT+RARRHEADER.QSRAMOUNT)) as REGAMOUNT,
SUM((RARRHEADER.QAMOUNT+RARRHEADER.QSRAMOUNT)/(CASE WHEN RECLASS.CESSIONF=1 THEN RARRHEADER.CLIMIT ELSE 1 END)) as AMOUNT    
From RARRHEADER, acceptance, REINSURANCE, cover, RECLASS    
WHERE COVER.CNO=ACCEPTANCE.CNO AND RECLASS.TOC=ACCEPTANCE.TOC AND RECLASS.RNO=REINSURANCE.RNO AND    
ACCEPTANCE.REGID=@P_REGID AND ACCEPTANCE.FLDID=@P_FLDID And ACCEPTANCE.VALUEID=@P_VALUEID And ACCEPTANCE.ANO=RARRHEADER.ANO and ACCEPTANCE.ASTATUS='W' and RArrHeader.Status='A' And REINSURANCE.RID=RARRHEADER.QID    
And (CASE WHEN RECLASS.CESSIONF=1 THEN RARRHEADER.CLIMIT ELSE 1 END)<>0  
GROUP BY YEAR(RARRHEADER.RDATE)    
ORDER BY MIN(CASE WHEN RECLASS.LIMIT<>0 THEN RECLASS.LIMIT ELSE REINSURANCE.LIMIT END) DESC    


GO

DROP Procedure Treaty_Adjustment_A
GO
CREATE Procedure Treaty_Adjustment_A(@P_ADATE smalldatetime, @P_REGID varchar(10), @P_FLDID varchar ( 255 ), @P_VALUEID varchar ( 255 ))    
as    
SELECT YEAR(RARRHEADER.RDATE) AS RYEAR,     
SUM((RArrHeader.TAmount-RArrHeader.FAmount)-RARRHEADER.MAMOUNT) AS SI,    
MIN(CASE WHEN RECLASS.CESSIONF=1 THEN 1 ELSE 0 END) AS CLIMIT,    
MIN(CASE WHEN RECLASS.ASSESSMENTF=1 THEN 1 ELSE 0 END) AS RLIMIT,    
MIN(CASE WHEN RECLASS.LIMIT<>0 THEN RECLASS.LIMIT ELSE REINSURANCE.LIMIT END) AS LIMIT,    
MIN(RECLASS.PLIMIT) as PLIMIT,  
SUM((RARRHEADER.AAMOUNT)) as REGAMOUNT,
SUM((RARRHEADER.AAMOUNT)/(CASE WHEN RECLASS.CESSIONF=1 THEN RARRHEADER.CLIMIT ELSE 1 END)) as AMOUNT    
From RARRHEADER, acceptance, REINSURANCE, cover, RECLASS    
WHERE COVER.CNO=ACCEPTANCE.CNO AND RECLASS.TOC=ACCEPTANCE.TOC AND RECLASS.RNO=REINSURANCE.RNO AND    
ACCEPTANCE.REGID=@P_REGID AND  ACCEPTANCE.FLDID=@P_FLDID And ACCEPTANCE.VALUEID=@P_VALUEID And ACCEPTANCE.ANO=RARRHEADER.ANO and ACCEPTANCE.ASTATUS='W' and RArrHeader.Status='A' And REINSURANCE.RID=RARRHEADER.AID    
And (CASE WHEN RECLASS.CESSIONF=1 THEN RARRHEADER.CLIMIT ELSE 1 END)<>0  
GROUP BY YEAR(RARRHEADER.RDATE)    
ORDER BY MIN(CASE WHEN RECLASS.LIMIT<>0 THEN RECLASS.LIMIT ELSE REINSURANCE.LIMIT END) DESC    
    

GO

DROP Procedure Treaty_Adjustment_XP
GO
CREATE Procedure Treaty_Adjustment_XP(@P_ADATE smalldatetime, @P_REGID varchar(10), @P_FLDID varchar ( 255 ), @P_VALUEID varchar ( 255 ))      
as      
SELECT YEAR(RARRHEADER.RDATE) AS RYEAR,       
SUM((RArrHeader.TAmount-RArrHeader.FAmount)/(RARRHEADER.PCTShare/100)) AS SI,      
MIN(0) AS RLIMIT,      
MIN(0) AS CLIMIT,      
MIN(CASE WHEN RECLASS.LIMIT<>0 THEN RECLASS.LIMIT ELSE REINSURANCE.LIMIT END*CASE WHEN Cover.ISType<>'R' and Cover.ISType<>'T' Then 1 Else 0 End) AS LIMIT,      
MIN(RECLASS.PLIMIT) as PLIMIT,  
SUM(RARRHEADER.XPAmount / (RARRHEADER.PctShare / 100 * RARRHEADER.PCTLOSS/100 * (100 - RARRHEADER.MShare) / 100)) As REGAMOUNT,
SUM(RARRHEADER.XPAmount / (RARRHEADER.PctShare / 100 * RARRHEADER.PCTLOSS/100 * (100 - RARRHEADER.MShare) / 100)) As Amount      
FROM RARRHEADER, ACCEPTANCE, REINSURANCE, RECLASS, COVER LEFT JOIN ISOURCE ON (ISOURCE.CNO=COVER.CNO)      
WHERE COVER.CNO=ACCEPTANCE.CNO AND RECLASS.TOC=ACCEPTANCE.TOC AND RECLASS.RNO=REINSURANCE.RNO AND      
ACCEPTANCE.REGID=@P_REGID AND ACCEPTANCE.FLDID=@P_FLDID And ACCEPTANCE.VALUEID=@P_VALUEID And ACCEPTANCE.ANO=RARRHEADER.ANO and ACCEPTANCE.ASTATUS='W' and RArrHeader.Status='A' And REINSURANCE.RID=RARRHEADER.XPID      
AND RARRHEADER.PCTShare<>0    
GROUP BY YEAR(RARRHEADER.RDATE)      
ORDER BY MIN(CASE WHEN RECLASS.LIMIT<>0 THEN RECLASS.LIMIT ELSE REINSURANCE.LIMIT END*CASE WHEN Cover.ISType<>'R' and Cover.ISType<>'T' Then 1 Else 0 End) DESC      

GO

DROP Procedure Treaty_Adjustment_S1
GO
CREATE Procedure Treaty_Adjustment_S1(@P_ADATE smalldatetime, @P_REGID varchar(10), @P_FLDID varchar ( 255 ), @P_VALUEID varchar ( 255 ))    
as    
SELECT YEAR(RARRHEADER.RDATE) AS RYEAR,     
SUM((RArrHeader.TAmount-RArrHeader.FAmount)-RARRHEADER.MAMOUNT) AS SI,    
MIN(CASE WHEN RECLASS.CESSIONF=1 THEN 1 ELSE 0 END) AS CLIMIT,    
MIN(CASE WHEN RECLASS.ASSESSMENTF=1 THEN 1 ELSE 0 END) AS RLIMIT,    
MIN(CASE WHEN RECLASS.LIMIT<>0 THEN RECLASS.LIMIT ELSE REINSURANCE.LIMIT END) AS LIMIT,    
MIN(RECLASS.PLIMIT) as PLIMIT,  
SUM((RARRHEADER.SP1AMOUNT)) as REGAMOUNT,
SUM((RARRHEADER.SP1AMOUNT)/(CASE WHEN RECLASS.CESSIONF=1 THEN RARRHEADER.CLIMIT ELSE 1 END)) as AMOUNT    
From RARRHEADER, acceptance, REINSURANCE, cover, RECLASS    
WHERE COVER.CNO=ACCEPTANCE.CNO AND RECLASS.TOC=ACCEPTANCE.TOC AND RECLASS.RNO=REINSURANCE.RNO AND    
ACCEPTANCE.REGID=@P_REGID AND ACCEPTANCE.FLDID=@P_FLDID And ACCEPTANCE.VALUEID=@P_VALUEID And ACCEPTANCE.ANO=RARRHEADER.ANO and ACCEPTANCE.ASTATUS='W' and RArrHeader.Status='A' And REINSURANCE.RID=RARRHEADER.SP1ID    
And (CASE WHEN RECLASS.CESSIONF=1 THEN RARRHEADER.CLIMIT ELSE 1 END)<>0  
GROUP BY YEAR(RARRHEADER.RDATE)    
ORDER BY MIN(CASE WHEN RECLASS.LIMIT<>0 THEN RECLASS.LIMIT ELSE REINSURANCE.LIMIT END) DESC    
          

GO

DROP Procedure Treaty_Adjustment_S2
GO
CREATE Procedure Treaty_Adjustment_S2(@P_ADATE smalldatetime, @P_REGID varchar(10), @P_FLDID varchar ( 255 ), @P_VALUEID varchar ( 255 ))    
as    
SELECT YEAR(RARRHEADER.RDATE) AS RYEAR,     
SUM((RArrHeader.TAmount-RArrHeader.FAmount)-RARRHEADER.MAMOUNT) AS SI,    
MIN(CASE WHEN RECLASS.CESSIONF=1 THEN 1 ELSE 0 END) AS CLIMIT,    
MIN(CASE WHEN RECLASS.ASSESSMENTF=1 THEN 1 ELSE 0 END) AS RLIMIT,    
MIN(CASE WHEN RECLASS.LIMIT<>0 THEN RECLASS.LIMIT ELSE REINSURANCE.LIMIT END) AS LIMIT,    
MIN(RECLASS.PLIMIT) as PLIMIT,  
SUM((RARRHEADER.SP2AMOUNT)) as REGAMOUNT,
SUM((RARRHEADER.SP2AMOUNT)/(CASE WHEN RECLASS.CESSIONF=1 THEN RARRHEADER.CLIMIT ELSE 1 END)) as AMOUNT    
From RARRHEADER, acceptance, REINSURANCE, cover, RECLASS    
WHERE COVER.CNO=ACCEPTANCE.CNO AND RECLASS.TOC=ACCEPTANCE.TOC AND RECLASS.RNO=REINSURANCE.RNO AND    
ACCEPTANCE.REGID=@P_REGID AND ACCEPTANCE.FLDID=@P_FLDID And ACCEPTANCE.VALUEID=@P_VALUEID And ACCEPTANCE.ANO=RARRHEADER.ANO and ACCEPTANCE.ASTATUS='W' and RArrHeader.Status='A' And REINSURANCE.RID=RARRHEADER.SP2ID    
And (CASE WHEN RECLASS.CESSIONF=1 THEN RARRHEADER.CLIMIT ELSE 1 END)<>0  
GROUP BY YEAR(RARRHEADER.RDATE)    
ORDER BY MIN(CASE WHEN RECLASS.LIMIT<>0 THEN RECLASS.LIMIT ELSE REINSURANCE.LIMIT END) DESC    


GO

DROP Procedure Treaty_Adjustment_S3
GO
CREATE Procedure Treaty_Adjustment_S3(@P_ADATE smalldatetime, @P_REGID varchar(10), @P_FLDID varchar ( 255 ), @P_VALUEID varchar ( 255 ))    
as    
SELECT YEAR(RARRHEADER.RDATE) AS RYEAR,     
SUM((RArrHeader.TAmount-RArrHeader.FAmount)-RARRHEADER.MAMOUNT) AS SI,    
MIN(CASE WHEN RECLASS.CESSIONF=1 THEN 1 ELSE 0 END) AS CLIMIT,    
MIN(CASE WHEN RECLASS.ASSESSMENTF=1 THEN 1 ELSE 0 END) AS RLIMIT,    
MIN(CASE WHEN RECLASS.LIMIT<>0 THEN RECLASS.LIMIT ELSE REINSURANCE.LIMIT END) AS LIMIT,    
MIN(RECLASS.PLIMIT) as PLIMIT,  
SUM((RARRHEADER.SP3AMOUNT)) as REGAMOUNT,
SUM((RARRHEADER.SP3AMOUNT)/(CASE WHEN RECLASS.CESSIONF=1 THEN RARRHEADER.CLIMIT ELSE 1 END)) as AMOUNT    
From RARRHEADER, acceptance, REINSURANCE, cover, RECLASS    
WHERE COVER.CNO=ACCEPTANCE.CNO AND RECLASS.TOC=ACCEPTANCE.TOC AND RECLASS.RNO=REINSURANCE.RNO AND    
ACCEPTANCE.REGID=@P_REGID AND ACCEPTANCE.FLDID=@P_FLDID And ACCEPTANCE.VALUEID=@P_VALUEID And ACCEPTANCE.ANO=RARRHEADER.ANO and ACCEPTANCE.ASTATUS='W' and RArrHeader.Status='A' And REINSURANCE.RID=RARRHEADER.SP3ID    
And (CASE WHEN RECLASS.CESSIONF=1 THEN RARRHEADER.CLIMIT ELSE 1 END)<>0  
GROUP BY YEAR(RARRHEADER.RDATE)    
ORDER BY MIN(CASE WHEN RECLASS.LIMIT<>0 THEN RECLASS.LIMIT ELSE REINSURANCE.LIMIT END) DESC    


GO

DROP Procedure Treaty_Adjustment_D
GO
CREATE Procedure Treaty_Adjustment_D(@P_ADATE smalldatetime, @P_REGID varchar(10), @P_FLDID varchar ( 255 ), @P_VALUEID varchar ( 255 ))    
as    
SELECT YEAR(RARRHEADER.RDATE) AS RYEAR,     
SUM((RArrHeader.TAmount-RArrHeader.FAmount)-RARRHEADER.MAMOUNT) AS SI,    
MIN(CASE WHEN RECLASS.CESSIONF=1 THEN 1 ELSE 0 END) AS CLIMIT,    
MIN(CASE WHEN RECLASS.ASSESSMENTF=1 THEN 1 ELSE 0 END) AS RLIMIT,    
MIN(CASE WHEN RECLASS.LIMIT<>0 THEN RECLASS.LIMIT ELSE REINSURANCE.LIMIT END) AS LIMIT,    
MIN(RECLASS.PLIMIT) as PLIMIT,  
SUM((RARRHEADER.DAMOUNT)) as REGAMOUNT,
SUM((RARRHEADER.DAMOUNT)/(CASE WHEN RECLASS.CESSIONF=1 THEN RARRHEADER.CLIMIT ELSE 1 END)) as AMOUNT    
From RARRHEADER, acceptance, REINSURANCE, cover, RECLASS    
WHERE COVER.CNO=ACCEPTANCE.CNO AND RECLASS.TOC=ACCEPTANCE.TOC AND RECLASS.RNO=REINSURANCE.RNO AND    
ACCEPTANCE.REGID=@P_REGID AND ACCEPTANCE.FLDID=@P_FLDID And ACCEPTANCE.VALUEID=@P_VALUEID And ACCEPTANCE.ANO=RARRHEADER.ANO and ACCEPTANCE.ASTATUS='W' and RArrHeader.Status='A' And REINSURANCE.RID=RARRHEADER.DID    
And (CASE WHEN RECLASS.CESSIONF=1 THEN RARRHEADER.CLIMIT ELSE 1 END)<>0  
GROUP BY YEAR(RARRHEADER.RDATE)    
ORDER BY MIN(CASE WHEN RECLASS.LIMIT<>0 THEN RECLASS.LIMIT ELSE REINSURANCE.LIMIT END) DESC    


GO

DROP Procedure Treaty_Adjustment_C
GO
CREATE Procedure Treaty_Adjustment_C(@P_ADATE smalldatetime, @P_REGID varchar(10), @P_FLDID varchar ( 255 ), @P_VALUEID varchar ( 255 ))      
as      
SELECT YEAR(RARRHEADER.RDATE) AS RYEAR,       
SUM((RArrHeader.TAmount-RArrHeader.FAmount)/(RARRHEADER.PCTShare/100)) AS SI,      
MIN(0) AS RLIMIT,      
MIN(0) AS CLIMIT,      
MIN(CASE WHEN RECLASS.LIMIT<>0 THEN RECLASS.LIMIT ELSE REINSURANCE.LIMIT END*CASE WHEN Cover.ISType<>'R' and Cover.ISType<>'T' Then 1 Else 0 End) AS LIMIT,      
MIN(RECLASS.PLIMIT) as PLIMIT,  
SUM(RARRHEADER.CAmount / (RARRHEADER.PctShare / 100 * (100 - RARRHEADER.MShare) / 100)) As REGAmount,
SUM(RARRHEADER.CAmount / (RARRHEADER.PctShare / 100 * (100 - RARRHEADER.MShare) / 100)) As Amount      
FROM RARRHEADER, ACCEPTANCE, REINSURANCE, RECLASS, COVER LEFT JOIN ISOURCE ON (ISOURCE.CNO=COVER.CNO)      
WHERE COVER.CNO=ACCEPTANCE.CNO AND RECLASS.TOC=ACCEPTANCE.TOC AND RECLASS.RNO=REINSURANCE.RNO AND      
ACCEPTANCE.REGID=@P_REGID AND ACCEPTANCE.FLDID=@P_FLDID And ACCEPTANCE.VALUEID=@P_VALUEID And ACCEPTANCE.ANO=RARRHEADER.ANO and ACCEPTANCE.ASTATUS='W' and RArrHeader.Status='A' And REINSURANCE.RID=RARRHEADER.CID   
AND RARRHEADER.PCTShare<>0    
GROUP BY YEAR(RARRHEADER.RDATE)      
ORDER BY MIN(CASE WHEN RECLASS.LIMIT<>0 THEN RECLASS.LIMIT ELSE REINSURANCE.LIMIT END*CASE WHEN Cover.ISType<>'R' and Cover.ISType<>'T' Then 1 Else 0 End) DESC      

GO

--3 JULY

Create Index I_Renewal_NewAno on Renewal(NewANO)
GO
Create Index I_Renewal_PolicyNo_CertificateNo on Renewal(PolicyNo, CertificateNo)
GO

DROP PROCEDURE ListDet_Next
GO
CREATE PROCEDURE ListDet_Next (@P_ANO as integer)     
AS    
SELECT Cast(0 as bit) as ProcessFlag,Acceptance.CertificateNo, Acceptance.ESeqNo, Cast(Acceptance.AName as varchar(128)) as AName, Acceptance.ANO, Acceptance.REGNO, Acceptance.ADATE, Acceptance.LUSERID as USERID, SysTab.Currency, 
(SELECT coalesce(SUM(PCALC.TSI*PCALC.RATE),0) FROM  PCALC WHERE PCALC.ANO=ACCEPTANCE.ANO AND ACCEPTANCE.PSTATUS='C')*CASE WHEN ACCEPTANCE.QTY=0 THEN 1 ELSE ACCEPTANCE.QTY END AS TSI,
(SELECT coalesce(SUM(PCALC.OURSHARE*PCALC.RATE),0) FROM  PCALC WHERE PCALC.ANO=ACCEPTANCE.ANO AND ACCEPTANCE.PSTATUS='C')*CASE WHEN ACCEPTANCE.QTY=0 THEN 1 ELSE ACCEPTANCE.QTY END AS OURSHARE, 
(SELECT coalesce(SUM(PCALC.GROSS*PCALC.RATE),0) FROM  PCALC WHERE PCALC.ANO=ACCEPTANCE.ANO AND ACCEPTANCE.PSTATUS='C')*CASE WHEN ACCEPTANCE.QTY=0 THEN 1 ELSE ACCEPTANCE.QTY END AS GROSS,
Year(Acceptance.SDate) as RYear, Acceptance.ASTATUS, Acceptance.ATYPE, Acceptance.SDate, Acceptance.EDate, Acceptance.ValueID, Acceptance.ValueDesc    
FROM Acceptance, Cover, SysTab
WHERE Cover.CNO=Acceptance.CNO and Acceptance.LANO<>-1 and ((Acceptance.PANO<>-1 and Acceptance.PANO=@P_ANO) or (Acceptance.RANO<>-1 and Acceptance.RANO=@P_ANO))


GO

DROP PROCEDURE ListDet_Prev
GO
CREATE PROCEDURE ListDet_Prev (@P_ANO as integer)   
AS  
SELECT Cast(0 as bit) as ProcessFlag,Acceptance.CertificateNo, Acceptance.ESeqNo, Cast(Acceptance.AName as varchar(128)) as AName, Acceptance.ANO, Acceptance.REGNO, Acceptance.ADATE,Acceptance.LUSERID as USERID, SysTab.Currency, 
(SELECT coalesce(SUM(PCALC.TSI*PCALC.RATE),0) FROM  PCALC WHERE PCALC.ANO=ACCEPTANCE.ANO AND ACCEPTANCE.PSTATUS='C')*CASE WHEN ACCEPTANCE.QTY=0 THEN 1 ELSE ACCEPTANCE.QTY END AS TSI,
(SELECT coalesce(SUM(PCALC.OURSHARE*PCALC.RATE),0) FROM  PCALC WHERE PCALC.ANO=ACCEPTANCE.ANO AND ACCEPTANCE.PSTATUS='C')*CASE WHEN ACCEPTANCE.QTY=0 THEN 1 ELSE ACCEPTANCE.QTY END AS OURSHARE, 
(SELECT coalesce(SUM(PCALC.GROSS*PCALC.RATE),0) FROM  PCALC WHERE PCALC.ANO=ACCEPTANCE.ANO AND ACCEPTANCE.PSTATUS='C')*CASE WHEN ACCEPTANCE.QTY=0 THEN 1 ELSE ACCEPTANCE.QTY END AS GROSS,
Year(Acceptance.SDate) as RYear, Acceptance.ASTATUS, Acceptance.ATYPE, Acceptance.SDate, Acceptance.EDate, Acceptance.ValueID, Acceptance.ValueDesc    
FROM Acceptance, Cover, SysTab, Acceptance AS A1  
WHERE Cover.CNO=Acceptance.CNO And Acceptance.LANO<>-1 and ((A1.PANO<>-1 and Acceptance.ANO=A1.PANO) or (A1.RANO<>-1 and Acceptance.ANO=A1.RANO)) And A1.ANO=@P_ANO  
  GO

--22 jun 2018
insert into sysform(FName, Description, FCode) 
Select 'ALLOWCHANGEVOUCHERWITHPRINTLOG','ALLOW CHANGE (EDIT/DROP) VOUCHER WITH PRINT LOG','ACTIVITIES'
go



--inisialisasi
update sysuser set CCODE='15-DEMO' where ccode is null or ccode=''
go

DROP PROCEDURE QTOI_1 
GO
CREATE PROCEDURE QTOI_1 (@P_ANO as integer, @P_TOI as varchar(255), @P_Category as varchar(1)='') 
AS 
SELECT TOI.TOI, MAX(TOI.DESCRIPTION) as DESCRIPTION,  MAX(SYSTAB.CURRENCY) as CURRENCY, 
MAX(CAST(TOI.ADJUSTABLE as INT)) AS ADJUSTABLE, 
MAX(TOI.PCTADJ) as PCTADJ, 
MAX(TOI.DISPMODEL) AS DISPMODEL, 
MAX(PCLASS.CATEGORY) AS CATEGORY, 
MAX(PCLASS.LIMIT) AS LIMIT, 
CASE WHEN MAX(PCLASS.CATEGORY)='M' THEN MAX(TOIVALUE.VALUE) ELSE 0 END AS VALUE 
From RCOVER 
INNER JOIN SYSTAB ON (1=1) 
INNER JOIN ACCEPTANCE ON (ACCEPTANCE.ANO=RCOVER.ANO) 
INNER JOIN RATECOV ON (RATECOV.CODE=RCOVER.CODE) 
INNER JOIN PCLASS ON (PCLASS.TOR=RATECOV.TOR AND (PClass.Category=@P_Category or @P_Category='')) 
INNER JOIN TOI ON (TOI.TOI=PCLASS.TOI AND TOI.ALLOWEDF=1 AND (TOI.TOI Like @P_TOI OR TOI.DESCRIPTION Like @P_TOI)) 
LEFT JOIN AINFO ON (AINFO.ANO=RCOVER.ANO) 
LEFT JOIN TOIVALUE ON ( 
TOIVALUE.TOI=TOI.TOI AND TOIVALUE.YEAR=YEAR(ACCEPTANCE.SDATE) AND TOIVALUE.MONTH=MONTH(ACCEPTANCE.SDATE) 
And ((TOIValue.ValueID1='' and AINFO.ValueDesc1 Like TOIValue.ValueDesc1+'%') or (TOIValue.ValueID1<>'' and AINFO.ValueID1 Like TOIValue.ValueID1) or (TOIValue.ValueID1 is null)) 
And ((TOIValue.ValueID2='' and AINFO.ValueDesc2 Like TOIValue.ValueDesc2+'%') or (TOIValue.ValueID2<>'' and AINFO.ValueID2 Like TOIValue.ValueID2) or (TOIValue.ValueID2 is null)) 
And ((TOIValue.ValueID3='' and AINFO.ValueDesc3 Like TOIValue.ValueDesc3+'%') or (TOIValue.ValueID3<>'' and AINFO.ValueID3 Like TOIValue.ValueID3) or (TOIValue.ValueID3 is null)) 
And ((TOIValue.ValueID4='' and AINFO.ValueDesc4 Like TOIValue.ValueDesc4+'%') or (TOIValue.ValueID4<>'' and AINFO.ValueID4 Like TOIValue.ValueID4) or (TOIValue.ValueID4 is null)) 
And ((TOIValue.ValueID5='' and AINFO.ValueDesc5 Like TOIValue.ValueDesc5+'%') or (TOIValue.ValueID5<>'' and AINFO.ValueID5 Like TOIValue.ValueID5) or (TOIValue.ValueID5 is null)) 
And ((TOIValue.ValueID6='' and AINFO.ValueDesc6 Like TOIValue.ValueDesc6+'%') or (TOIValue.ValueID6<>'' and AINFO.ValueID6 Like TOIValue.ValueID6) or (TOIValue.ValueID6 is null)) 
And ((TOIValue.ValueID7='' and AINFO.ValueDesc7 Like TOIValue.ValueDesc7+'%') or (TOIValue.ValueID7<>'' and AINFO.ValueID7 Like TOIValue.ValueID7) or (TOIValue.ValueID7 is null)) 
And ((TOIValue.ValueID8='' and AINFO.ValueDesc8 Like TOIValue.ValueDesc8+'%') or (TOIValue.ValueID8<>'' and AINFO.ValueID8 Like TOIValue.ValueID8) or (TOIValue.ValueID8 is null)) 
And ((TOIValue.ValueID9='' and AINFO.ValueDesc9 Like TOIValue.ValueDesc9+'%') or (TOIValue.ValueID9<>'' and AINFO.ValueID9 Like TOIValue.ValueID9) or (TOIValue.ValueID9 is null)) 
And ((TOIValue.ValueID10='' and AINFO.ValueDesc10 Like TOIValue.ValueDesc10+'%') or (TOIValue.ValueID10<>'' and AINFO.ValueID10 Like TOIValue.ValueID10) or (TOIValue.ValueID10 is null)) 
And ((TOIValue.ValueID11='' and AINFO.ValueDesc11 Like TOIValue.ValueDesc11+'%') or (TOIValue.ValueID11<>'' and AINFO.ValueID11 Like TOIValue.ValueID11) or (TOIValue.ValueID11 is null)) 
And ((TOIValue.ValueID12='' and AINFO.ValueDesc12 Like TOIValue.ValueDesc12+'%') or (TOIValue.ValueID12<>'' and AINFO.ValueID12 Like TOIValue.ValueID12) or (TOIValue.ValueID12 is null)) 
And ((TOIValue.ValueID13='' and AINFO.ValueDesc13 Like TOIValue.ValueDesc13+'%') or (TOIValue.ValueID13<>'' and AINFO.ValueID13 Like TOIValue.ValueID13) or (TOIValue.ValueID13 is null)) 
And ((TOIValue.ValueID14='' and AINFO.ValueDesc14 Like TOIValue.ValueDesc14+'%') or (TOIValue.ValueID14<>'' and AINFO.ValueID14 Like TOIValue.ValueID14) or (TOIValue.ValueID14 is null)) 
And ((TOIValue.ValueID15='' and AINFO.ValueDesc15 Like TOIValue.ValueDesc15+'%') or (TOIValue.ValueID15<>'' and AINFO.ValueID15 Like TOIValue.ValueID15) or (TOIValue.ValueID15 is null)) 
) 
WHERE RCOVER.ANO=@P_ANO 
Group By TOI.TOI 
ORDER BY TOI.TOI 
 
GO

DROP FUNCTION FL_UW_TOI
GO
CREATE FUNCTION FL_UW_TOI(@P_ANO as integer, @P_TOI as varchar(255), @P_TOPF as bit=0)
RETURNS TABLE
As Return (
SELECT 
TOI.TOI,
MAX(TOI.DESCRIPTION) as DESCRIPTION,  
MAX(SYSTAB.CURRENCY) as CURRENCY, 
MAX(CAST(TOI.ADJUSTABLE as INT)) AS ADJUSTABLE, 
MAX(TOI.PCTADJ) as PCTADJ, 
MAX(TOI.DISPMODEL) AS DISPMODEL, 
MAX(PCLASS.CATEGORY) AS CATEGORY, 
MAX(PCLASS.LIMIT) AS LIMIT, 
CASE WHEN MAX(PCLASS.CATEGORY)='M' THEN MAX(TOIVALUE.VALUE) ELSE 0 END AS VALUE 
From TOI
INNER JOIN SYSTAB ON (1=1) 
Inner join PCLASS on PCLASS.TOI=TOI.TOI
Inner join RATECOV on RATECOV.TOR=PCLASS.TOR
Inner join RCOVER on RATECOV.CODE=RCOVER.CODE
Inner join Acceptance on Acceptance.ANO=RCOVER.ANO
LEFT JOIN AINFO ON (AINFO.ANO=RCOVER.ANO) 
LEFT JOIN TOIVALUE ON ( 
TOIVALUE.TOI=TOI.TOI AND TOIVALUE.YEAR=YEAR(ACCEPTANCE.SDATE) AND TOIVALUE.MONTH=MONTH(ACCEPTANCE.SDATE) 
And ((TOIValue.ValueID1='' and AINFO.ValueDesc1 Like TOIValue.ValueDesc1+'%') or (TOIValue.ValueID1<>'' and AINFO.ValueID1 Like TOIValue.ValueID1) or (TOIValue.ValueID1 is null)) 
And ((TOIValue.ValueID2='' and AINFO.ValueDesc2 Like TOIValue.ValueDesc2+'%') or (TOIValue.ValueID2<>'' and AINFO.ValueID2 Like TOIValue.ValueID2) or (TOIValue.ValueID2 is null)) 
And ((TOIValue.ValueID3='' and AINFO.ValueDesc3 Like TOIValue.ValueDesc3+'%') or (TOIValue.ValueID3<>'' and AINFO.ValueID3 Like TOIValue.ValueID3) or (TOIValue.ValueID3 is null)) 
And ((TOIValue.ValueID4='' and AINFO.ValueDesc4 Like TOIValue.ValueDesc4+'%') or (TOIValue.ValueID4<>'' and AINFO.ValueID4 Like TOIValue.ValueID4) or (TOIValue.ValueID4 is null)) 
And ((TOIValue.ValueID5='' and AINFO.ValueDesc5 Like TOIValue.ValueDesc5+'%') or (TOIValue.ValueID5<>'' and AINFO.ValueID5 Like TOIValue.ValueID5) or (TOIValue.ValueID5 is null)) 
And ((TOIValue.ValueID6='' and AINFO.ValueDesc6 Like TOIValue.ValueDesc6+'%') or (TOIValue.ValueID6<>'' and AINFO.ValueID6 Like TOIValue.ValueID6) or (TOIValue.ValueID6 is null)) 
And ((TOIValue.ValueID7='' and AINFO.ValueDesc7 Like TOIValue.ValueDesc7+'%') or (TOIValue.ValueID7<>'' and AINFO.ValueID7 Like TOIValue.ValueID7) or (TOIValue.ValueID7 is null)) 
And ((TOIValue.ValueID8='' and AINFO.ValueDesc8 Like TOIValue.ValueDesc8+'%') or (TOIValue.ValueID8<>'' and AINFO.ValueID8 Like TOIValue.ValueID8) or (TOIValue.ValueID8 is null)) 
And ((TOIValue.ValueID9='' and AINFO.ValueDesc9 Like TOIValue.ValueDesc9+'%') or (TOIValue.ValueID9<>'' and AINFO.ValueID9 Like TOIValue.ValueID9) or (TOIValue.ValueID9 is null)) 
And ((TOIValue.ValueID10='' and AINFO.ValueDesc10 Like TOIValue.ValueDesc10+'%') or (TOIValue.ValueID10<>'' and AINFO.ValueID10 Like TOIValue.ValueID10) or (TOIValue.ValueID10 is null)) 
And ((TOIValue.ValueID11='' and AINFO.ValueDesc11 Like TOIValue.ValueDesc11+'%') or (TOIValue.ValueID11<>'' and AINFO.ValueID11 Like TOIValue.ValueID11) or (TOIValue.ValueID11 is null)) 
And ((TOIValue.ValueID12='' and AINFO.ValueDesc12 Like TOIValue.ValueDesc12+'%') or (TOIValue.ValueID12<>'' and AINFO.ValueID12 Like TOIValue.ValueID12) or (TOIValue.ValueID12 is null)) 
And ((TOIValue.ValueID13='' and AINFO.ValueDesc13 Like TOIValue.ValueDesc13+'%') or (TOIValue.ValueID13<>'' and AINFO.ValueID13 Like TOIValue.ValueID13) or (TOIValue.ValueID13 is null)) 
And ((TOIValue.ValueID14='' and AINFO.ValueDesc14 Like TOIValue.ValueDesc14+'%') or (TOIValue.ValueID14<>'' and AINFO.ValueID14 Like TOIValue.ValueID14) or (TOIValue.ValueID14 is null)) 
And ((TOIValue.ValueID15='' and AINFO.ValueDesc15 Like TOIValue.ValueDesc15+'%') or (TOIValue.ValueID15<>'' and AINFO.ValueID15 Like TOIValue.ValueID15) or (TOIValue.ValueID15 is null)) 
) 
Left join TOP_Interest on TOP_Interest.TOPRO=Acceptance.TOPRO and TOP_Interest.TOI=TOI.TOI 
WHERE RCOVER.ANO=@P_ANO and TOI.ALLOWEDF=1 AND (TOI.TOI Like @P_TOI OR TOI.DESCRIPTION Like @P_TOI+'%') and (@P_TOPF=0 or coalesce(TOP_Interest.TOPRO,'')=Acceptance.TOPRO) 
Group By TOI.TOI  
)

go

DROP Function fn_ObjectValuation
GO
Create Function fn_ObjectValuation(@P_INO as int, @P_VDate as smalldatetime)        
RETURNS Table            
AS RETURN            
(          
  Select TOP 1 TOIVALUE.VALUE/dbo.get_Exchange(@P_VDate,ICover.Currency) as Value, TOIVALUE.VALUEPCT  
  From TOIVALUE, ICOVER, IINFO
  WHERE ICOVER.INO=@P_INO AND IINFO.INO=ICOVER.INO AND ICOVER.NOTDECRF=0
  AND TOIVALUE.Status='A' and TOIVALUE.TOI=ICOVER.TOI 
  AND (TOIVALUE.YEAR<YEAR(@P_VDATE) OR (TOIVALUE.YEAR=YEAR(@P_VDATE) AND TOIVALUE.MONTH<=MONTH(@P_VDATE)))
  And ((TOIValue.ValueID1='' and IINFO.ValueDesc1 Like TOIValue.ValueDesc1+'%') or (TOIValue.ValueID1<>'' and IINFO.ValueID1 Like TOIValue.ValueID1+'%') or (TOIValue.ValueID1 is null))            
  And ((TOIValue.ValueID2='' and IINFO.ValueDesc2 Like TOIValue.ValueDesc2+'%') or (TOIValue.ValueID2<>'' and IINFO.ValueID2 Like TOIValue.ValueID2+'%') or (TOIValue.ValueID2 is null))            
  And ((TOIValue.ValueID3='' and IINFO.ValueDesc3 Like TOIValue.ValueDesc3+'%') or (TOIValue.ValueID3<>'' and IINFO.ValueID3 Like TOIValue.ValueID3+'%') or (TOIValue.ValueID3 is null))            
  And ((TOIValue.ValueID4='' and IINFO.ValueDesc4 Like TOIValue.ValueDesc4+'%') or (TOIValue.ValueID4<>'' and IINFO.ValueID4 Like TOIValue.ValueID4+'%') or (TOIValue.ValueID4 is null))            
  And ((TOIValue.ValueID5='' and IINFO.ValueDesc5 Like TOIValue.ValueDesc5+'%') or (TOIValue.ValueID5<>'' and IINFO.ValueID5 Like TOIValue.ValueID5+'%') or (TOIValue.ValueID5 is null))            
  And ((TOIValue.ValueID6='' and IINFO.ValueDesc6 Like TOIValue.ValueDesc6+'%') or (TOIValue.ValueID6<>'' and IINFO.ValueID6 Like TOIValue.ValueID6+'%') or (TOIValue.ValueID6 is null))            
  And ((TOIValue.ValueID7='' and IINFO.ValueDesc7 Like TOIValue.ValueDesc7+'%') or (TOIValue.ValueID7<>'' and IINFO.ValueID7 Like TOIValue.ValueID7+'%') or (TOIValue.ValueID7 is null))            
  And ((TOIValue.ValueID8='' and IINFO.ValueDesc8 Like TOIValue.ValueDesc8+'%') or (TOIValue.ValueID8<>'' and IINFO.ValueID8 Like TOIValue.ValueID8+'%') or (TOIValue.ValueID8 is null))            
  And ((TOIValue.ValueID9='' and IINFO.ValueDesc9 Like TOIValue.ValueDesc9+'%') or (TOIValue.ValueID9<>'' and IINFO.ValueID9 Like TOIValue.ValueID9+'%') or (TOIValue.ValueID9 is null))            
  And ((TOIValue.ValueID10='' and IINFO.ValueDesc10 Like TOIValue.ValueDesc10+'%') or (TOIValue.ValueID10<>'' and IINFO.ValueID10 Like TOIValue.ValueID10+'%') or (TOIValue.ValueID10 is null))            
  And ((TOIValue.ValueID11='' and IINFO.ValueDesc11 Like TOIValue.ValueDesc11+'%') or (TOIValue.ValueID11<>'' and IINFO.ValueID11 Like TOIValue.ValueID11+'%') or (TOIValue.ValueID11 is null))            
  And ((TOIValue.ValueID12='' and IINFO.ValueDesc12 Like TOIValue.ValueDesc12+'%') or (TOIValue.ValueID12<>'' and IINFO.ValueID12 Like TOIValue.ValueID12+'%') or (TOIValue.ValueID12 is null))            
  And ((TOIValue.ValueID13='' and IINFO.ValueDesc13 Like TOIValue.ValueDesc13+'%') or (TOIValue.ValueID13<>'' and IINFO.ValueID13 Like TOIValue.ValueID13+'%') or (TOIValue.ValueID13 is null))            
  And ((TOIValue.ValueID14='' and IINFO.ValueDesc14 Like TOIValue.ValueDesc14+'%') or (TOIValue.ValueID14<>'' and IINFO.ValueID14 Like TOIValue.ValueID14+'%') or (TOIValue.ValueID14 is null))            
  And ((TOIValue.ValueID15='' and IINFO.ValueDesc15 Like TOIValue.ValueDesc15+'%') or (TOIValue.ValueID15<>'' and IINFO.ValueID15 Like TOIValue.ValueID15+'%') or (TOIValue.ValueID15 is null))            
  Order By  
  len(coalesce(TOIValue.ValueID1,'')) Desc, len(coalesce(TOIValue.ValueID2,'')) Desc, len(coalesce(TOIValue.ValueID3,'')) Desc, len(coalesce(TOIValue.ValueID4,'')) Desc, len(coalesce(TOIValue.ValueID5,'')) Desc,               
  len(coalesce(TOIValue.ValueID6,'')) Desc, len(coalesce(TOIValue.ValueID7,'')) Desc, len(coalesce(TOIValue.ValueID8,'')) Desc, len(coalesce(TOIValue.ValueID9,'')) Desc, len(coalesce(TOIValue.ValueID10,'')) Desc,     
  len(coalesce(TOIValue.ValueID11,'')) Desc, len(coalesce(TOIValue.ValueID12,'')) Desc, len(coalesce(TOIValue.ValueID13,'')) Desc, len(coalesce(TOIValue.ValueID14,'')) Desc, len(coalesce(TOIValue.ValueID15,'')) Desc,
  TOIVALUE.Year Desc, TOIVALUE.Month Desc, TOIVALUE.TOIVALUEID Desc  
) 


go
--20 jul penambahan bank account
DROP procedure PI13 
GO
CREATE procedure PI13 (@P_ANO as integer) 
as 
Begin 
Declare @P_Date as smalldatetime 
Declare @P_PolicyNo as varchar(20) 
Declare @P_CertificateNo as varchar(20) 
Declare @P_OpenFLag as Bit 
Declare @P_LANO as int 
Declare @P_A_PolicyNo as varchar(50) 
Select @P_Date = Getdate() 
 
Select @P_LANO=A1.LANO, @P_PolicyNo=A1.PolicyNo, @P_CertificateNo=A1.CertificateNo, @P_OpenFlag=C1.OpenFlag from Acceptance A1, Cover C1 Where C1.CNO=A1.CNO and A1.ANO=@P_ANO 
 
if @P_LANO<>-1 
if @P_OpenFlag=1 and @P_ANO<>@P_LANO 
Select @P_A_PolicyNo=@P_PolicyNo + '-' + @P_CertificateNo 
else 
Select @P_A_PolicyNo=@P_PolicyNo 
else 
Select @P_A_PolicyNo=@P_PolicyNo 
 
Select Distinct Admlink.Subject, Voucher.Voucher, Voucher.DueDate, Voucher.DocNo, Voucher_Due.DueDate as NDueDate, 
Profile.Name, Voucher.Currency, Admlink.RefType, Admlink.BankName, Admlink.AccountNo,
 
case when Voucher.debtorf=1 then Voucher.Nominal_CC-Voucher.Diff_CC else -(Voucher.Nominal_CC-Voucher.Diff_CC) end  as Nominal, 
case when Voucher.debtorf=1 then (coalesce(Voucher_Due.AmountDue, Voucher.AmountDue)-Voucher.Payment_CC) else -(coalesce(Voucher_Due.AmountDue, Voucher.AmountDue)-Voucher.Payment_CC) end as AmountDue, 
case when Voucher.debtorf=1 then Voucher.Payment_CC else -Voucher.Payment_CC end as Payment, 
case when Voucher.debtorf=1 then Voucher.Nominal_CC-Voucher.Diff_CC - Voucher.Payment_CC else -(Voucher.Nominal_CC-Voucher.Diff_CC - Voucher.Payment_CC) end as Outstanding 
 
from nVoucher Voucher Left Join Voucher_AmountDue(@P_Date) Voucher_Due on (Voucher_Due.Voucher=Voucher.Voucher), Profile, ProAcc, Admlink 
Where Profile.ID=ProAcc.ID and ProAcc.ProAcc=Voucher.ProAcc and Admlink.Voucher=Voucher.Voucher 
and Admlink.Type in ('DI','IC','IR','CF','JP','BB','BA','BO','OP','FO') and Admlink.A_PolicyNo=@P_A_PolicyNo and (Admlink.Extra_1='' or Admlink.Extra_1 is null) 
 
end 
 

go

--VERSIONING
insert into versioning
select '2018 V.1.9.0',GETDATE(),'2018 V.1.9.0',GETDATE(),'K: 2018 V.1.9.0',GETDATE()
go
