SET QUOTED_IDENTIFIER ON
SET ARITHABORT ON
SET NUMERIC_ROUNDABORT OFF
SET CONCAT_NULL_YIELDS_NULL ON
SET ANSI_NULLS ON
SET ANSI_PADDING ON
SET ANSI_WARNINGS ON


IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'FN_PCalc') AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) )
BEGIN DROP FUNCTION FN_PCalc END
GO  

Create FUNCTION FN_PCalc (@P_ANO as integer)                
RETURNS Table                
AS RETURN (                
SELECT  Acceptance.ANO,                
 Count(PCalc.Currency) AS NUMCCY,              
 MAX(PCALC.LMFACTOR) AS LMFACTOR,    
 MAX(PCALC.RATE) AS RATE,              
 MAX(PCALC.CRATE) AS CRATE,             
 MAX(CASE When Acceptance.QTY=0 Then 1 Else Acceptance.QTY end) as NumRisk,    
 sum(PCalc.TSI*PCalc.Rate*Case When Acceptance.QTY=0 Then 1 Else Acceptance.QTY end) AS TSI,                
 sum(PCalc.OurShare*PCalc.Rate*Case When Acceptance.QTY=0 Then 1 Else Acceptance.QTY end) AS OurShare,                
 sum(PCalc.Amount*PCalc.Rate*Case When Acceptance.QTY=0 Then 1 Else Acceptance.QTY end) AS Amount,                
 sum(PCalc.Gross*PCalc.Rate*Case When Acceptance.QTY=0 Then 1 Else Acceptance.QTY end) AS Gross,                
 sum(PCalc.OGross*PCalc.Rate*Case When Acceptance.QTY=0 Then 1 Else Acceptance.QTY end/dbo.fn_Premium_Calc_Prorata(Acceptance.Sdate, case When Acceptance.EXCLUSIVEF=0 and Acceptance.STime<Acceptance.STime Then dateadd(day,1,Acceptance.EDate) else Acceptance.EDate End,Cover.Prorata, 12,CASE WHEN Cover.PPeriod in (0,1,2) Then 2 ELSE Cover.PPeriod END)) AS OGross,           
 sum(PCalc.Claim*PCalc.Rate*Case When Acceptance.QTY=0 Then 1 Else Acceptance.QTY end) AS Claim,                
 sum(case when PCalc.TSI=0 then 0 else PCalc.OurShare*PCalc.Rate*Case When Acceptance.QTY=0 Then 1 Else Acceptance.QTY end end)/                
 sum(case when PCalc.TSI=0 then 1 else PCalc.TSI*PCalc.Rate*Case When Acceptance.QTY=0 Then 1 Else Acceptance.QTY end end)*                
 sum(PCalc.Gross*PCalc.Rate*Case When Acceptance.QTY=0 Then 1 Else Acceptance.QTY end) as Premium,                
 MAX(CASE WHEN PCALC.TSI<>0 AND COALESCE(ISOURCE.LIMIT,0)<>0 THEN PCALC.OURSHARE/PCALC.TSI*100 ELSE COALESCE(ISOURCE.SHARE,100) END) as PCTSHARE,     
 MAX(RARRHEADER.MSHARE) as MSHARE,    
 MAX(REINSURANCE.RYEAR) as RYEAR,  
 MAX(PCALC.Description) as Description  
FROM  Acceptance with(NOLOCK)           
INNER JOIN COVER with(NOLOCK) ON (COVER.CNO=ACCEPTANCE.CNO)    
LEFT JOIN Pcalc with(NOLOCK) ON (Acceptance.ANO=PCalc.ANO and Acceptance.PStatus='C')           
LEFT JOIN RArrHeader with(NOLOCK) On (RArrHeader.ANO=Acceptance.ANO)          
LEFT JOIN Reinsurance on (Reinsurance.RID=RArrHeader.QID)
LEFT JOIN ISOURCE with (NOLOCK) ON (ISOURCE.CNO=ACCEPTANCE.CNO)                
Where Acceptance.ANO=@P_ANO                
GROUP BY Acceptance.ANO                
)                
    

GO

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'QAccumulation_Detail') AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) )
BEGIN DROP FUNCTION QAccumulation_Detail END
GO  

CREATE Function QAccumulation_Detail(@P_REGID as varchar(10), @P_FLDID as varchar(255), @P_VALUEID as varchar(255), @P_RYear as Int)        
RETURNS Table  
AS RETURN (  
Select A1.ANO, A1.LANO, A1.RegNo, A1.RefNo, A1.Branch, A1.AStatus, A1.AType, A1.TOC, C.OpenFlag, A1.PolicyNo, A1.CertificateNo, A1.ValueDesc, A1.SDate, A1.EDate, A1.PDate, A1.AName, R1.ManualF
from Acceptance A1
Inner Join Cover C on (C.CNO=A1.CNO)
Inner Join RArrHeader R1 on (R1.ANO=A1.ANO)
Inner Join Reinsurance R2 on (R2.RID=R1.QID)
Where A1.ANO<>A1.LANO and R1.ANO=A1.ANO and R1.Status='A' 
and A1.RegID=@P_REGID and A1.FLDID=@P_FLDID and A1.VALUEID=@P_VALUEID and (@P_RYear=0 or R2.RYear=@P_RYear)
)

GO

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'QACCUMULATION_CONTROL') AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) )
BEGIN DROP FUNCTION QACCUMULATION_CONTROL END
GO  

CREATE FUNCTION QACCUMULATION_CONTROL(@P_REGID as varchar(10), @P_FLDID as varchar(255), @P_VALUEID as varchar(255), @P_RYear as Int)        
RETURNS Table  
AS RETURN (  
SELECT G1.SFLDID, G1.SVALUEID, Max(G2.Description) as Description, sum(R1.TAmount*(100-R1.MShare)/100) as TSI  
from acceptance a1, RArrheader R1, Reinsurance R2, GenDTab G1, GenDTab G2
Where A1.RegID=@P_RegID and A1.FLDID=@P_FLDID and A1.VALUEID=@P_VALUEID and (@P_RYear=0 or R2.RYear=@P_RYear) and R1.ANO=A1.ANO and R1.Status='A' and R2.RID=R1.QID and G1.FLDID=A1.FLDID and G1.VALUEID=A1.VALUEID and G2.FLDID=G1.SFLDID and G2.VALUEID=G1.SVALUEID  
Group By G1.SFLDID, G1.SVALUEID
) 

GO

IF EXISTS ( SELECT * FROM   sysobjects WHERE  id = object_id(N'QAccReg') and OBJECTPROPERTY(id, N'IsProcedure') = 1 )
BEGIN DROP PROCEDURE QAccReg END
GO

CREATE PROCEDURE QAccReg(@P_PANO as Integer) 
AS 
SELECT ACCEPTANCE.REGID, ACCEPTANCE.FLDID, ACCEPTANCE.VALUEID, ACCEPTANCE.ATYPE, ACCEPTANCE.ASTATUS, ACCEPTANCE.PANO, ACCEPTANCE.AnnualTreatyF, ACCEPTANCE.NORISKACCUMULATIONF, REINSURANCE.RYEAR
FROM ACCEPTANCE, RARRHEADER, REINSURANCE
WHERE ACCEPTANCE.ANO=@P_PANO AND RARRHEADER.ANO=ACCEPTANCE.ANO AND REINSURANCE.RID=RARRHEADER.QID
 
GO

IF EXISTS ( SELECT * FROM   sysobjects WHERE  id = object_id(N'Treaty_Adjustment_Detail') and OBJECTPROPERTY(id, N'IsProcedure') = 1 )
BEGIN DROP PROCEDURE Treaty_Adjustment_Detail END
GO

CREATE PROCEDURE Treaty_Adjustment_Detail (@P_ADATE as smallDatetime, @P_REGID as varchar(10), @P_FLDID as varchar(255), @P_VALUEID as varchar(255), @P_RYEAR as integer)
AS
SELECT ACCEPTANCE.ANO, RARRHEADER.STATUS, ACCEPTANCE.ASTATUS, ACCEPTANCE.ADATE
From acceptance, RARRHEADER, REINSURANCE
WHERE REINSURANCE.RID=RARRHEADER.QID AND ACCEPTANCE.REGID=@P_REGID AND ACCEPTANCE.FLDID=@P_FLDID And ACCEPTANCE.VALUEID=@P_VALUEID And ACCEPTANCE.ANO=RARRHEADER.ANO And REINSURANCE.RYEAR=@P_RYEAR And ACCEPTANCE.ASTATUS='W' AND RARRHEADER.STATUS='A'
    
GO  


IF EXISTS ( SELECT * FROM   sysobjects WHERE  id = object_id(N'TREATY_ADJUSTMENT_LIMIT') and OBJECTPROPERTY(id, N'IsProcedure') = 1 )
BEGIN DROP PROCEDURE TREATY_ADJUSTMENT_LIMIT END
GO

CREATE PROCEDURE TREATY_ADJUSTMENT_LIMIT (@P_REGID as varchar(10), @P_FLDID as varchar(255), @P_VALUEID as varchar(255), @P_RYEAR as integer=0)      
AS      
Select MIN(RARRHEADER.LIMIT) AS LIMIT, MAX(REINSURANCE.RYEAR) as RYEAR    
From RARRHEADER, acceptance, REINSURANCE
WHERE REINSURANCE.RID=RARRHEADER.QID AND RARRHEADER.STATUS='A' AND RARRHEADER.ANO=ACCEPTANCE.ANO AND ACCEPTANCE.ASTATUS='W' and ACCEPTANCE.REGID=@P_REGID AND ACCEPTANCE.FLDID=@P_FLDID AND ACCEPTANCE.VALUEID=@P_VALUEID      
and (@P_RYear=0 or Reinsurance.RYear=@P_RYear)
        
GO

IF EXISTS ( SELECT * FROM   sysobjects WHERE  id = object_id(N'List11E') and OBJECTPROPERTY(id, N'IsProcedure') = 1 )
BEGIN DROP PROCEDURE List11E END
GO

CREATE PROCEDURE List11E(@P_SDate as smalldatetime, @P_EDate as smalldatetime,@P_RegID as varchar(10))
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
 Year(RArrheader.RDate) AS RYear,
 Cover.ISType,
 Acceptance.Renewal,
 Acceptance.ESeqNo,
 Acceptance.PolicyNo,
 acceptance.CertificateNo
FROM  Acceptance, Cover, SysTab, RArrHeader, Reinsurance, AccRegDet
Where cover.CNO = acceptance.CNO
 And Acceptance.REGID=@P_REGID
 And RArrHeader.ANO=Acceptance.ANO
 and Reinsurance.RID=RArrHeader.QID
 And (Acceptance.ANO=Acceptance.LANO Or Acceptance.LANO=-1)
 And Cover.CStatus<>'C'
 And Acceptance.ADate Between @P_SDate and @P_EDate
 And RArrHeader.Status<>'R' And RArrHeader.TAmount<>0
 And Acceptance.AStatus in ('W','I')
 And Cover.ISType<>'T'
 And AccRegDet.RYear=Reinsurance.RYear and AccRegDet.RegID=Acceptance.RegID and AccRegDet.FLDID=Acceptance.FLDID and AccRegDet.VALUEID=Acceptance.ValueID and AccRegDet.TSI<>0 and RArrHeader.ManualF=0 and AccRegDet.ReAllocF=1
 And ((Rarrheader.CID<>'' or RArrHeader.XPID<>'' or RArrheader.SP1ID<>'' or RArrHeader.SP2ID<>'' or RArrHeader.SP3ID<>'' or (RArrHeader.QID<>'' and RArrHeader.QSRet<>100)))
                  
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
FROM  Acceptance, Cover, SysTab, RArrHeader, Reinsurance, Acceptance As Acceptance_Detail, AccRegDet
Where cover.CNO = acceptance.CNO
 And Acceptance.REGID=@P_REGID
 And Acceptance.ANO=Acceptance_Detail.LANO  And Acceptance_Detail.LANO<>Acceptance_Detail.ANO
 And RArrHeader.ANO=Acceptance_Detail.ANO
 and Reinsurance.RID=RArrHeader.QID
 And Cover.CStatus<>'C'
 And Acceptance_Detail.ADate Between @P_SDate and @P_EDate
 And RArrHeader.Status<>'R' And RArrHeader.TAmount<>0
 And Acceptance_Detail.AStatus in ('W','I')
 And Cover.ISType<>'T'
 And AccRegDet.RYear=Reinsurance.RYear and AccRegDet.RegID=Acceptance_Detail.RegID and AccRegDet.FLDID=Acceptance_Detail.FLDID and AccRegDet.VALUEID=Acceptance_Detail.ValueID and AccRegDet.TSI<>0 and RArrHeader.ManualF=0 and AccRegDet.ReAllocF=1
 And ((Rarrheader.CID<>'' or RArrHeader.XPID<>'' or RArrheader.SP1ID<>'' or RArrHeader.SP2ID<>'' or RArrHeader.SP3ID<>'' or (RArrHeader.QID<>'' and RArrHeader.QSRet<>100)))



GO


IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'List11E_Det') AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) )
BEGIN DROP FUNCTION List11E_Det END
GO  

CREATE FUNCTION List11E_Det (@P_ANO as integer,@P_SDate as smalldatetime, @P_EDate as smalldatetime,@P_REGID as varchar(10))
RETURNS Table
AS RETURN(
              
SELECT Cast(0 as bit) as ProcessFlag,
 Acceptance.CertificateNo,
 Acceptance.RefNo,
 Acceptance.ESeqNo,
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
From
 Acceptance,
 Cover,
 SysTab, 
 Rarrheader,
 Reinsurance,
 AccRegDet
Where
 cover.CNO = acceptance.CNO
 and RArrHeader.ANO=Acceptance.ANO
 and Reinsurance.RID=RArrHeader.QID
 and Acceptance.REGID=@P_REGID
 And Acceptance.ANO<>Acceptance.LANO
 And Acceptance.LANO=@P_ANO
 And Acceptance.ADate Between @P_SDate and @P_EDate
 And RArrHeader.Status<>'R' And RArrHeader.TAmount<>0
 And Acceptance.AStatus in ('W','I')
 And Cover.ISType<>'T'
 And AccRegDet.RYear=Reinsurance.RYear and AccRegDet.RegID=Acceptance.RegID and AccRegDet.FLDID=Acceptance.FLDID and AccRegDet.VALUEID=Acceptance.ValueID and AccRegDet.TSI<>0 and RArrHeader.ManualF=0 and AccRegDet.ReAllocF=1
 And ((Rarrheader.CID<>'' or RArrHeader.XPID<>'' or RArrheader.SP1ID<>'' or RArrHeader.SP2ID<>'' or RArrHeader.SP3ID<>'' or (RArrHeader.QID<>'' and RArrHeader.QSRet<>100)))
)
              
GO

IF EXISTS ( SELECT * FROM   sysobjects WHERE  id = object_id(N'List15_BLANK') and OBJECTPROPERTY(id, N'IsProcedure') = 1 )
BEGIN DROP PROCEDURE List15_BLANK END
GO

CREATE PROCEDURE List15_BLANK(@P_REGID varchar(10), @P_FLDID varchar(255), @P_VALUEID varchar(255), @P_RYear integer=0)
as

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
	Year(RArrheader.RDate) AS RYear,
	Cover.ISType, 
	Acceptance.Renewal, 
	Acceptance.ESeqNo, 
	Acceptance.PolicyNo, 
	Acceptance.CertificateNo
FROM 	Acceptance, Cover, SysTab, RArrHeader, Reinsurance
WHERE 	Cover.CNO=Acceptance.CNO 
	And (Acceptance.ANO=Acceptance.LANO Or Acceptance.LANO=-1) 
	And Cover.ISType<>'T' 
	And RArrHeader.Status='A' 
	And RArrHeader.ANO=Acceptance.ANO 
	And Reinsurance.RID=RArrHeader.QID
	And Acceptance.REGID=@P_REGID
	And Acceptance.FLDID=@P_FLDID
	And Acceptance.ValueID Like @P_ValueID + '%'
	and (@P_RYear=0 or Reinsurance.RYear=@P_RYear)

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
	Year(Acceptance.SDate) AS RYear, 
	Cover.ISType, 
	Acceptance.Renewal, 
	Acceptance.ESeqNo, 
	Acceptance.PolicyNo, 
	Acceptance.CertificateNo
FROM 	Acceptance, Cover, SysTab, Acceptance As Acceptance_Detail, RArrHeader, Reinsurance
WHERE 	Cover.CNO=Acceptance.CNO 
	And Acceptance.ANO=Acceptance_Detail.LANO And Acceptance_Detail.LANO<>Acceptance_Detail.ANO
	And Cover.ISType<>'T' 
	And RArrHeader.Status='A' 
	And RArrHeader.ANO=Acceptance_Detail.ANO 
	and Reinsurance.RID=RArrHeader.QID
	And Acceptance_Detail.REGID=@P_REGID
	And Acceptance_Detail.FLDID=@P_FLDID
	And Acceptance_Detail.ValueID Like @P_ValueID + '%'
	and (@P_RYear=0 or Reinsurance.RYear=@P_RYear)

GO

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'List15_Blank_Det') AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) )
BEGIN DROP FUNCTION List15_Blank_Det END
GO 

CREATE FUNCTION List15_Blank_Det (@P_ANO as integer,@P_REGID varchar(10), @P_FLDID varchar(255), @P_VALUEID varchar(255), @P_RYear integer=0)
RETURNS Table
as RETURN(
SELECT Cast(0 as bit) as ProcessFlag,
 Acceptance.CertificateNo,
 Acceptance.RefNo,
 Acceptance.ESeqNo,
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
 Year(RArrheader.RDate) AS RYear,
 Acceptance.ValueID,
 dbo.get_objectInfo(Acceptance.ANO) as ValueDesc,
 Acceptance.BatchNo
From
 Acceptance,
 Cover,
 SysTab,
 RArrHeader, 
 Reinsurance
Where
 [cover].[CNO] = [acceptance].[CNO]
 And [Acceptance].[ANO]<>[Acceptance].[LANO]
 And [Acceptance].[LANO]=@P_ANO
 And [Cover].[ISType]<>'T'
 And [RArrHeader].[Status]='A'
 And [RArrHeader].[ANO]=[Acceptance].[ANO]
 And Reinsurance.RID=RArrHeader.QID
 And Acceptance.REGID=@P_REGID
 And [Acceptance].[FLDID]=@P_FLDID
 And [Acceptance].[ValueID] Like @P_ValueID + '%'
 and (@P_RYear=0 or Reinsurance.RYear=@P_RYear)
)
  

GO

IF EXISTS ( SELECT * FROM   sysobjects WHERE  id = object_id(N'QREINSURANCE_CESSION') and OBJECTPROPERTY(id, N'IsProcedure') = 1 )
BEGIN DROP PROCEDURE QREINSURANCE_CESSION END
GO

CREATE Procedure QREINSURANCE_CESSION (@P_ANO integer, @P_ADate smalldatetime, @P_RType varchar(255), @P_TSI Float=0, @P_RID varchar(20)='', @P_ManualF Bit=0, @P_GROSS Float=0)                                
as                                                          

Declare @Amount as float
Declare @SDate as smalldatetime
Declare @EDate as smalldatetime
Declare @RegID as varchar(10)
Declare @FLDID as varchar(255)
Declare @VALUEID as varchar(255)
Declare @EMethod as varchar(1)
Declare @ISType as varchar(1)
Declare @PHolder as varchar(10)
Declare @CGroup as varchar(10)
Declare @Segment as varchar(10)
Declare @TOC as varchar(10)
Declare @BrCurrency as varchar(10)
Declare @RYear as integer
Declare @ManualF as bit
Declare @ORBusinessF as Bit
Declare @RDate as smalldatetime
Declare @NRDate as smalldatetime

Declare @Reinsurance as table(RNO int, TOC varchar(10), ExcRate Float)

Select 
@SDate=Acceptance.SDate, 
@EDate=Acceptance.EDate,
@RegID=Acceptance.RegID, 
@FLDID=Acceptance.FLDID, 
@VALUEID=Acceptance.VALUEID, 
@EMethod=Acceptance.EMethod, 
@ISType=Cover.ISType,
@PHolder=Cover.PHOLDER,
@Segment=Cover.Segment,
@CGroup=PHolder.CGroup,
@TOC=Acceptance.TOC,
@BrCurrency=SysTab.Currency,
@RYear=Case When SysTab.RiskAccumulationByTreatyYearF=0 Then 0 else Reinsurance.RYear end,
@ManualF=coalesce(RArrHeader.ManualF,0),
@ORBusinessF=coalesce(RArrHeader.ORBusinessF,0),
@RDate=RArrHeader.RDate,
@NRDate=RArrHeader.NRDate
from Acceptance
Inner Join Cover on (Cover.CNO=Acceptance.CNO)      
Inner Join Profile PHolder on (PHolder.ID=Cover.PHolder)
Inner Join SysTab on (1=1)
Left Join RArrHeader on (RArrHeader.ANO=Acceptance.ANO)
LEFT JOIN Reinsurance on (Reinsurance.RID=RArrHeader.QID)
Where Acceptance.ANO=@P_ANO

if @P_RID=''
	-- from QAccumulation
	Select @Amount=coalesce(sum(AccRegDet.Amount),0)
	from AccRegDet 
	Where (AccRegDet.RegID=@RegID and AccRegDet.FLDID=@FLDID and AccRegDet.ValueID=@ValueID and AccRegDet.RType=@P_RType AND ACCREGDET.TSI<>0 AND (ACCREGDET.RYEAR=@RYear OR @RYear=0))
else
	Select @Amount=0

Insert into @Reinsurance
Select Reinsurance.RNO, ReClass.TOC, Case When coalesce(R1.Rate,0)=0 Then (Case When Reinsurance.Currency='' or Reinsurance.Currency=@BrCurrency Then 1 Else dbo.get_Exchange(@SDate, Reinsurance.Currency) End) else coalesce(R1.Rate,1)*coalesce(R2.Rate,1) end as ExcRate
From Reinsurance 
Inner Join ReClass on (ReClass.RNO=Reinsurance.RNO and ReClass.TOC=@TOC and (ReClass.DirectF=0 or @ISType in ('I','L','C')))      
Left Join ReRate R1 on (R1.TOC=@TOC and R1.RYear=Reinsurance.RYEAR and R1.Currency=Reinsurance.Currency)
left Join ReRate R2 on (R2.TOC=R1.TOC and R2.RYear=R1.RYear and R2.Currency=R1.CCYTo and R1.Currency<>R1.CCYTO)
WHERE Reinsurance.RType=@P_RType And @P_ADATE Between Reinsurance.SDate And Reinsurance.EDate    

SELECT (Case When ReClass.PriorityF=1 Then ReClass.PriorityF else Reinsurance.PriorityF end) as PriorityF, Reinsurance.RID, Reinsurance.RType,                                
ReClass.PLimit*R.ExcRate as PLimit, 
Case RECLASS.Limit WHEN 0 then Reinsurance.Limit Else RECLASS.Limit end*R.ExcRate as limit, 
ReClass.ShortFallLimit*R.ExcRate  as ShortFallLimit,              
ReClass.MinTSI*R.ExcRate  as MinTSI, 
ReClass.AssessmentExInwardF,
Reinsurance.UjrohReins, Reinsurance.UjrohCedant, Reinsurance.Share, Reinsurance.PShare, @FLDID as FLDID, @VALUEID as VALUEID, ReClass.CessionF, ReClass.AssessmentF, ReClass.DirectF,
Reinsurance.SDate, Reinsurance.EDate, Reinsurance.CleanCutF, Reinsurance.RShare                               
From @Reinsurance R
Inner Join Reinsurance on (Reinsurance.RNO=R.RNO)
Inner Join ReClass on (ReClass.RNO=R.RNO and ReClass.TOC=R.TOC)
Left Join RePolicy on (RePolicy.RNO=Reinsurance.RNO)      
WHERE Reinsurance.RType=@P_RType
And (@P_RID='' or Reinsurance.RID=@P_RID or @ManualF=0 or @EMethod='T')                            
And (coalesce(RePolicy.ID,'')='' or  coalesce(RePolicy.ID,'')=@PHolder)    
And (@P_ManualF=1 or @ManualF=1 or  
(
	(      
	 (Reinsurance.ORBusinessF=@ORBusinessF)      
	 And (@P_TSI>=ReClass.MinTSI*R.ExcRate  or ReClass.MinTSI*R.ExcRate =0) 
	 and (@P_TSI<=ReClass.MaxTSI*R.ExcRate  or ReClass.MaxTSI*R.ExcRate =0) 
	 and (@P_GROSS>=ReClass.MinGross*R.ExcRate  or ReClass.MinGross*R.ExcRate =0) 
	 and (@P_GROSS<=ReClass.MaxGross*R.ExcRate  or ReClass.MaxGross*R.ExcRate =0)                 
	 And (    
	 (datediff(month, coalesce(@RDate,@SDate), coalesce(@NRDate,@EDate))>=ReClass.MinPeriod)     
	 or (datediff(month, coalesce(@RDate,@SDate), coalesce(@NRDate,@EDate))=ReClass.MinPeriod-1 and day(coalesce(@RDate,@SDate))<day(coalesce(@NRDate,@EDate)))     
	 or ReClass.MinPeriod=0)                               
	 And (    
	 (datediff(month, coalesce(@RDate,@SDate), coalesce(@NRDate,@EDate))<ReClass.MaxPeriod)     
	 or (datediff(month, coalesce(@RDate,@SDate), coalesce(@NRDate,@EDate))=ReClass.MaxPeriod and day(coalesce(@RDate,@SDate))>=day(coalesce(@NRDate,@EDate)))
	 or ReClass.MaxPeriod=0)
	)      
	And 
	(
	 Reinsurance.ApplySegmentF=0 or (exists (Select Segment from ReSegment Where ReSegment.RNO=Reinsurance.RNO and ReSegment.Segment=@Segment))
	)
	And 
	(
	 Reinsurance.ApplyCGroupF=0 or (exists (Select CGroup from ReCGroup Where ReCGroup.RNO=Reinsurance.RNO and ReCGroup.CGroup=@CGroup))
	 )))                    
And Exists (Select Top 1 RCalc.ANO from RCalc Left Join RPartDet on (RPartDet.RNO=Reinsurance.RNO and RPartDet.TOR=RCalc.TOR) Where RCalc.ANO=@P_ANO and coalesce(RPartDet.ExcludeF,0)=0)  
Order By 
Case When Case RECLASS.Limit WHEN 0 then Reinsurance.Limit Else RECLASS.Limit end*R.ExcRate>@Amount then 0 else 1 End,
Case When (@P_ManualF=1 or @ManualF=1) and (Reinsurance.RID=@P_RID or Reinsurance.PRID=@P_RID) Then 0 Else 1 end, 
coalesce(RePolicy.ID,'') Desc, 
(Case When ReClass.PriorityF=1 Then ReClass.PriorityF else Reinsurance.PriorityF end) Desc,
Case RECLASS.Limit WHEN 0 then Reinsurance.Limit Else RECLASS.Limit end*R.ExcRate-@Amount

GO

IF EXISTS ( SELECT * FROM   sysobjects WHERE  id = object_id(N'Treaty_Adjustment_XP') and OBJECTPROPERTY(id, N'IsProcedure') = 1 )
BEGIN DROP PROCEDURE Treaty_Adjustment_XP END
GO

CREATE Procedure Treaty_Adjustment_XP(@P_ADATE smalldatetime, @P_REGID varchar(10), @P_FLDID varchar ( 255 ), @P_VALUEID varchar ( 255 ), @P_RYEAR as integer=0)      
as      
SELECT Reinsurance.RYear AS RYEAR,       
MAX(REINSURANCE.RSHARE) as RSHARE,     
SUM((RArrHeader.TAmount-RArrHeader.FAmount)/(RARRHEADER.PCTShare/100 * RARRHEADER.PCTLOSS/100)) AS SI,      
MIN(0) AS RLIMIT,      
MIN(0) AS CLIMIT,      
MIN(CASE WHEN RECLASS.LIMIT<>0 THEN RECLASS.LIMIT ELSE REINSURANCE.LIMIT END*CASE WHEN Cover.ISType not in ('R','T') Then 1 Else 0 End) AS LIMIT,      
MIN(RECLASS.PLIMIT) as PLIMIT,  
SUM(RARRHEADER.XPAmount / (RARRHEADER.PctShare / 100 * RARRHEADER.PCTLOSS/100 * (100 - RARRHEADER.MShare) / 100)) As REGAMOUNT,
SUM(RARRHEADER.XPAmount / (RARRHEADER.PctShare / 100 * RARRHEADER.PCTLOSS/100 * (100 - RARRHEADER.MShare) / 100)) As Amount      
FROM RARRHEADER, ACCEPTANCE, REINSURANCE, RECLASS, COVER LEFT JOIN ISOURCE ON (ISOURCE.CNO=COVER.CNO)      
WHERE COVER.CNO=ACCEPTANCE.CNO AND RECLASS.TOC=ACCEPTANCE.TOC AND RECLASS.RNO=REINSURANCE.RNO AND      
ACCEPTANCE.REGID=@P_REGID AND ACCEPTANCE.FLDID=@P_FLDID And ACCEPTANCE.VALUEID=@P_VALUEID And ACCEPTANCE.ANO=RARRHEADER.ANO and ACCEPTANCE.ASTATUS='W' and RArrHeader.Status='A' And REINSURANCE.RID=RARRHEADER.XPID      
AND RARRHEADER.PCTShare<>0    
and (@P_RYEAR=0 or Reinsurance.RYear=@P_RYear)
GROUP BY Reinsurance.RYear      
ORDER BY MIN(CASE WHEN RECLASS.LIMIT<>0 THEN RECLASS.LIMIT ELSE REINSURANCE.LIMIT END*CASE WHEN Cover.ISType not in ('R','T') Then 1 Else 0 End) DESC      

GO

IF EXISTS ( SELECT * FROM   sysobjects WHERE  id = object_id(N'Treaty_Adjustment_D') and OBJECTPROPERTY(id, N'IsProcedure') = 1 )
BEGIN DROP PROCEDURE Treaty_Adjustment_D END
GO

CREATE Procedure Treaty_Adjustment_D(@P_ADATE smalldatetime, @P_REGID varchar(10), @P_FLDID varchar ( 255 ), @P_VALUEID varchar ( 255 ), @P_RYEAR as integer=0)    
as    
SELECT Reinsurance.RYear AS RYEAR,     
MAX(REINSURANCE.RSHARE) as RSHARE,     
SUM((RArrHeader.TAmount-RArrHeader.FAmount)/(RARRHEADER.PCTShare/100 * RARRHEADER.PCTLOSS/100)) AS SI,     
MIN(CASE WHEN RECLASS.CESSIONF=1 THEN 1 ELSE 0 END) AS CLIMIT,    
MIN(CASE WHEN RECLASS.ASSESSMENTF=1 THEN 1 ELSE 0 END) AS RLIMIT,    
MIN(CASE WHEN RECLASS.LIMIT<>0 THEN RECLASS.LIMIT ELSE REINSURANCE.LIMIT END*CASE WHEN (Cover.ISType not in ('R','T')) or (ReClass.DirectF=0) Then 1 Else 0 End) AS LIMIT,      
MIN(RECLASS.PLIMIT) as PLIMIT,  
SUM(RARRHEADER.DAMOUNT / (RARRHEADER.PctShare / 100 * RARRHEADER.PCTLOSS/100 * (100 - RARRHEADER.MShare) / 100)) As REGAMOUNT,
SUM(RARRHEADER.DAMOUNT/(CASE WHEN RECLASS.CESSIONF=1 THEN RARRHEADER.CLIMIT ELSE 1 END) / (RARRHEADER.PctShare / 100 * RARRHEADER.PCTLOSS/100 * (100 - RARRHEADER.MShare) / 100)) As Amount      
From RARRHEADER, acceptance, REINSURANCE, cover, RECLASS    
WHERE COVER.CNO=ACCEPTANCE.CNO AND RECLASS.TOC=ACCEPTANCE.TOC AND RECLASS.RNO=REINSURANCE.RNO AND    
ACCEPTANCE.REGID=@P_REGID AND ACCEPTANCE.FLDID=@P_FLDID And ACCEPTANCE.VALUEID=@P_VALUEID And ACCEPTANCE.ANO=RARRHEADER.ANO and ACCEPTANCE.ASTATUS='W' and RArrHeader.Status='A' And REINSURANCE.RID=RARRHEADER.DID    
And (CASE WHEN RECLASS.CESSIONF=1 THEN RARRHEADER.CLIMIT ELSE 1 END)<>0  
and (@P_RYEAR=0 or Reinsurance.RYear=@P_RYear)
GROUP BY Reinsurance.RYear    
ORDER BY MIN(CASE WHEN RECLASS.LIMIT<>0 THEN RECLASS.LIMIT ELSE REINSURANCE.LIMIT END*CASE WHEN (Cover.ISType not in ('R','T')) or (ReClass.DirectF=0) Then 1 Else 0 End) DESC    


GO

IF EXISTS ( SELECT * FROM   sysobjects WHERE  id = object_id(N'Treaty_Adjustment_C') and OBJECTPROPERTY(id, N'IsProcedure') = 1 )
BEGIN DROP PROCEDURE Treaty_Adjustment_C END
GO

CREATE Procedure Treaty_Adjustment_C(@P_ADATE smalldatetime, @P_REGID varchar(10), @P_FLDID varchar ( 255 ), @P_VALUEID varchar ( 255 ), @P_RYEAR as integer=0)      
as      
SELECT Reinsurance.RYear AS RYEAR,       
MAX(REINSURANCE.RSHARE) as RSHARE,     
SUM((RArrHeader.TAmount-RArrHeader.FAmount)/(RARRHEADER.PCTShare/100 * RARRHEADER.PCTLOSS/100)) AS SI,      
MIN(0) AS RLIMIT,      
MIN(0) AS CLIMIT,      
MIN(CASE WHEN RECLASS.LIMIT<>0 THEN RECLASS.LIMIT ELSE REINSURANCE.LIMIT END*CASE WHEN Cover.ISType not in ('R','T') Then 1 Else 0 End) AS LIMIT,      
MIN(RECLASS.PLIMIT) as PLIMIT,  
SUM(RARRHEADER.CAmount / (RARRHEADER.PctShare / 100 * RARRHEADER.PCTLOSS/100 * (100 - RARRHEADER.MShare) / 100)) As REGAMOUNT,
SUM(RARRHEADER.CAmount / (RARRHEADER.PctShare / 100 * RARRHEADER.PCTLOSS/100 * (100 - RARRHEADER.MShare) / 100)) As Amount      
FROM RARRHEADER, ACCEPTANCE, REINSURANCE, RECLASS, COVER LEFT JOIN ISOURCE ON (ISOURCE.CNO=COVER.CNO)      
WHERE COVER.CNO=ACCEPTANCE.CNO AND RECLASS.TOC=ACCEPTANCE.TOC AND RECLASS.RNO=REINSURANCE.RNO AND      
ACCEPTANCE.REGID=@P_REGID AND ACCEPTANCE.FLDID=@P_FLDID And ACCEPTANCE.VALUEID=@P_VALUEID And ACCEPTANCE.ANO=RARRHEADER.ANO and ACCEPTANCE.ASTATUS='W' and RArrHeader.Status='A' And REINSURANCE.RID=RARRHEADER.CID   
AND RARRHEADER.PCTShare<>0    
and (@P_RYEAR=0 or Reinsurance.RYear=@P_RYear)
GROUP BY Reinsurance.RYear      
ORDER BY MIN(CASE WHEN RECLASS.LIMIT<>0 THEN RECLASS.LIMIT ELSE REINSURANCE.LIMIT END*CASE WHEN Cover.ISType not in ('R','T') Then 1 Else 0 End) DESC      

GO

IF EXISTS ( SELECT * FROM   sysobjects WHERE  id = object_id(N'Treaty_Adjustment_Q') and OBJECTPROPERTY(id, N'IsProcedure') = 1 )
BEGIN DROP PROCEDURE Treaty_Adjustment_Q END
GO

CREATE Procedure Treaty_Adjustment_Q(@P_ADATE smalldatetime, @P_REGID varchar(10), @P_FLDID varchar ( 255 ), @P_VALUEID varchar ( 255 ), @P_RYEAR as integer=0)    
as    
SELECT Reinsurance.RYear AS RYEAR,     
MAX(REINSURANCE.RSHARE) as RSHARE,     
SUM((RArrHeader.TAmount-RArrHeader.FAmount)-RARRHEADER.MAMOUNT) AS SI,    
MIN(CASE WHEN RECLASS.CESSIONF=1 THEN 1 ELSE 0 END) AS CLIMIT,    
MIN(CASE WHEN RECLASS.ASSESSMENTF=1 THEN 1 ELSE 0 END) AS RLIMIT,    
MIN(CASE WHEN RECLASS.LIMIT<>0 THEN RECLASS.LIMIT ELSE REINSURANCE.LIMIT END*CASE WHEN (Cover.ISType not in ('R','T')) or (ReClass.DirectF=0) Then 1 Else 0 End) AS LIMIT,    
MIN(RECLASS.PLIMIT) as PLIMIT,  
SUM((RARRHEADER.QAMOUNT+RARRHEADER.QSRAMOUNT)) as REGAMOUNT,
SUM((RARRHEADER.QAMOUNT+RARRHEADER.QSRAMOUNT)/(CASE WHEN RECLASS.CESSIONF=1 THEN RARRHEADER.CLIMIT ELSE 1 END)) as AMOUNT    
From RARRHEADER, acceptance, REINSURANCE, cover, RECLASS    
WHERE COVER.CNO=ACCEPTANCE.CNO AND RECLASS.TOC=ACCEPTANCE.TOC AND RECLASS.RNO=REINSURANCE.RNO AND    
ACCEPTANCE.REGID=@P_REGID AND ACCEPTANCE.FLDID=@P_FLDID And ACCEPTANCE.VALUEID=@P_VALUEID And ACCEPTANCE.ANO=RARRHEADER.ANO and ACCEPTANCE.ASTATUS='W' and RArrHeader.Status='A' And REINSURANCE.RID=RARRHEADER.QID    
And (CASE WHEN RECLASS.CESSIONF=1 THEN RARRHEADER.CLIMIT ELSE 1 END)<>0  
and (@P_RYEAR=0 or Reinsurance.RYear=@P_RYear)
GROUP BY Reinsurance.RYear    
ORDER BY MIN(CASE WHEN RECLASS.LIMIT<>0 THEN RECLASS.LIMIT ELSE REINSURANCE.LIMIT END*CASE WHEN (Cover.ISType not in ('R','T')) or (ReClass.DirectF=0) Then 1 Else 0 End) DESC    
GO

IF EXISTS ( SELECT * FROM   sysobjects WHERE  id = object_id(N'Treaty_Adjustment_S1') and OBJECTPROPERTY(id, N'IsProcedure') = 1 )
BEGIN DROP PROCEDURE Treaty_Adjustment_S1 END
GO

CREATE Procedure Treaty_Adjustment_S1(@P_ADATE smalldatetime, @P_REGID varchar(10), @P_FLDID varchar ( 255 ), @P_VALUEID varchar ( 255 ), @P_RYEAR as integer=0)    
as    
SELECT Reinsurance.RYear AS RYEAR,     
MAX(REINSURANCE.RSHARE) as RSHARE,     
SUM((RArrHeader.TAmount-RArrHeader.FAmount)-RARRHEADER.MAMOUNT) AS SI,    
MIN(CASE WHEN RECLASS.CESSIONF=1 THEN 1 ELSE 0 END) AS CLIMIT,    
MIN(CASE WHEN RECLASS.ASSESSMENTF=1 THEN 1 ELSE 0 END) AS RLIMIT,    
MIN(CASE WHEN RECLASS.LIMIT<>0 THEN RECLASS.LIMIT ELSE REINSURANCE.LIMIT END*CASE WHEN (Cover.ISType not in ('R','T')) or (ReClass.DirectF=0) Then 1 Else 0 End) AS LIMIT,    
MIN(RECLASS.PLIMIT) as PLIMIT,  
SUM((RARRHEADER.SP1AMOUNT)) as REGAMOUNT,
SUM((RARRHEADER.SP1AMOUNT)/(CASE WHEN RECLASS.CESSIONF=1 THEN RARRHEADER.CLIMIT ELSE 1 END)) as AMOUNT    
From RARRHEADER, acceptance, REINSURANCE, cover, RECLASS    
WHERE COVER.CNO=ACCEPTANCE.CNO AND RECLASS.TOC=ACCEPTANCE.TOC AND RECLASS.RNO=REINSURANCE.RNO AND    
ACCEPTANCE.REGID=@P_REGID AND ACCEPTANCE.FLDID=@P_FLDID And ACCEPTANCE.VALUEID=@P_VALUEID And ACCEPTANCE.ANO=RARRHEADER.ANO and ACCEPTANCE.ASTATUS='W' and RArrHeader.Status='A' And REINSURANCE.RID=RARRHEADER.SP1ID    
And (CASE WHEN RECLASS.CESSIONF=1 THEN RARRHEADER.CLIMIT ELSE 1 END)<>0  
and (@P_RYEAR=0 or Reinsurance.RYear=@P_RYear)
GROUP BY Reinsurance.RYear    
ORDER BY MIN(CASE WHEN RECLASS.LIMIT<>0 THEN RECLASS.LIMIT ELSE REINSURANCE.LIMIT END*CASE WHEN (Cover.ISType not in ('R','T')) or (ReClass.DirectF=0) Then 1 Else 0 End) DESC    
GO          

IF EXISTS ( SELECT * FROM   sysobjects WHERE  id = object_id(N'Treaty_Adjustment_S2') and OBJECTPROPERTY(id, N'IsProcedure') = 1 )
BEGIN DROP PROCEDURE Treaty_Adjustment_S2 END
GO

CREATE Procedure Treaty_Adjustment_S2(@P_ADATE smalldatetime, @P_REGID varchar(10), @P_FLDID varchar ( 255 ), @P_VALUEID varchar ( 255 ), @P_RYEAR as integer=0)    
as    
SELECT Reinsurance.RYear AS RYEAR,     
MAX(REINSURANCE.RSHARE) as RSHARE,     
SUM((RArrHeader.TAmount-RArrHeader.FAmount)-RARRHEADER.MAMOUNT) AS SI,    
MIN(CASE WHEN RECLASS.CESSIONF=1 THEN 1 ELSE 0 END) AS CLIMIT,    
MIN(CASE WHEN RECLASS.ASSESSMENTF=1 THEN 1 ELSE 0 END) AS RLIMIT,    
MIN(CASE WHEN RECLASS.LIMIT<>0 THEN RECLASS.LIMIT ELSE REINSURANCE.LIMIT END*CASE WHEN (Cover.ISType not in ('R','T')) or (ReClass.DirectF=0) Then 1 Else 0 End) AS LIMIT,    
MIN(RECLASS.PLIMIT) as PLIMIT,  
SUM((RARRHEADER.SP2AMOUNT)) as REGAMOUNT,
SUM((RARRHEADER.SP2AMOUNT)/(CASE WHEN RECLASS.CESSIONF=1 THEN RARRHEADER.CLIMIT ELSE 1 END)) as AMOUNT    
From RARRHEADER, acceptance, REINSURANCE, cover, RECLASS    
WHERE COVER.CNO=ACCEPTANCE.CNO AND RECLASS.TOC=ACCEPTANCE.TOC AND RECLASS.RNO=REINSURANCE.RNO AND    
ACCEPTANCE.REGID=@P_REGID AND ACCEPTANCE.FLDID=@P_FLDID And ACCEPTANCE.VALUEID=@P_VALUEID And ACCEPTANCE.ANO=RARRHEADER.ANO and ACCEPTANCE.ASTATUS='W' and RArrHeader.Status='A' And REINSURANCE.RID=RARRHEADER.SP2ID    
And (CASE WHEN RECLASS.CESSIONF=1 THEN RARRHEADER.CLIMIT ELSE 1 END)<>0  
and (@P_RYEAR=0 or Reinsurance.RYear=@P_RYear)
GROUP BY Reinsurance.RYear    
ORDER BY MIN(CASE WHEN RECLASS.LIMIT<>0 THEN RECLASS.LIMIT ELSE REINSURANCE.LIMIT END*CASE WHEN (Cover.ISType not in ('R','T')) or (ReClass.DirectF=0) Then 1 Else 0 End) DESC    
GO

IF EXISTS ( SELECT * FROM   sysobjects WHERE  id = object_id(N'Treaty_Adjustment_S3') and OBJECTPROPERTY(id, N'IsProcedure') = 1 )
BEGIN DROP PROCEDURE Treaty_Adjustment_S3 END
GO

CREATE Procedure Treaty_Adjustment_S3(@P_ADATE smalldatetime, @P_REGID varchar(10), @P_FLDID varchar ( 255 ), @P_VALUEID varchar ( 255 ), @P_RYEAR as integer=0)    
as    
SELECT Reinsurance.RYear AS RYEAR,     
MAX(REINSURANCE.RSHARE) as RSHARE,     
SUM((RArrHeader.TAmount-RArrHeader.FAmount)-RARRHEADER.MAMOUNT) AS SI,    
MIN(CASE WHEN RECLASS.CESSIONF=1 THEN 1 ELSE 0 END) AS CLIMIT,    
MIN(CASE WHEN RECLASS.ASSESSMENTF=1 THEN 1 ELSE 0 END) AS RLIMIT,    
MIN(CASE WHEN RECLASS.LIMIT<>0 THEN RECLASS.LIMIT ELSE REINSURANCE.LIMIT END*CASE WHEN (Cover.ISType not in ('R','T')) or (ReClass.DirectF=0) Then 1 Else 0 End) AS LIMIT,    
MIN(RECLASS.PLIMIT) as PLIMIT,  
SUM((RARRHEADER.SP3AMOUNT)) as REGAMOUNT,
SUM((RARRHEADER.SP3AMOUNT)/(CASE WHEN RECLASS.CESSIONF=1 THEN RARRHEADER.CLIMIT ELSE 1 END)) as AMOUNT    
From RARRHEADER, acceptance, REINSURANCE, cover, RECLASS    
WHERE COVER.CNO=ACCEPTANCE.CNO AND RECLASS.TOC=ACCEPTANCE.TOC AND RECLASS.RNO=REINSURANCE.RNO AND    
ACCEPTANCE.REGID=@P_REGID AND ACCEPTANCE.FLDID=@P_FLDID And ACCEPTANCE.VALUEID=@P_VALUEID And ACCEPTANCE.ANO=RARRHEADER.ANO and ACCEPTANCE.ASTATUS='W' and RArrHeader.Status='A' And REINSURANCE.RID=RARRHEADER.SP3ID    
And (CASE WHEN RECLASS.CESSIONF=1 THEN RARRHEADER.CLIMIT ELSE 1 END)<>0  
and (@P_RYEAR=0 or Reinsurance.RYear=@P_RYear)
GROUP BY Reinsurance.RYear    
ORDER BY MIN(CASE WHEN RECLASS.LIMIT<>0 THEN RECLASS.LIMIT ELSE REINSURANCE.LIMIT END*CASE WHEN (Cover.ISType not in ('R','T')) or (ReClass.DirectF=0) Then 1 Else 0 End) DESC    
GO

IF EXISTS ( SELECT * FROM   sysobjects WHERE  id = object_id(N'Treaty_Adjustment_A') and OBJECTPROPERTY(id, N'IsProcedure') = 1 )
BEGIN DROP PROCEDURE Treaty_Adjustment_A END
GO

CREATE Procedure Treaty_Adjustment_A(@P_ADATE smalldatetime, @P_REGID varchar(10), @P_FLDID varchar ( 255 ), @P_VALUEID varchar ( 255 ), @P_RYEAR as integer=0)    
as    
SELECT Reinsurance.RYear AS RYEAR,
MAX(REINSURANCE.RSHARE) as RSHARE,          
SUM((RArrHeader.TAmount-RArrHeader.FAmount)-RARRHEADER.MAMOUNT) AS SI,    
MIN(CASE WHEN RECLASS.CESSIONF=1 THEN 1 ELSE 0 END) AS CLIMIT,    
MIN(CASE WHEN RECLASS.ASSESSMENTF=1 THEN 1 ELSE 0 END) AS RLIMIT,    
MIN(CASE WHEN RECLASS.LIMIT<>0 THEN RECLASS.LIMIT ELSE REINSURANCE.LIMIT END*CASE WHEN (Cover.ISType not in ('R','T')) or (ReClass.DirectF=0) Then 1 Else 0 End) AS LIMIT,    
MIN(RECLASS.PLIMIT) as PLIMIT,  
SUM((RARRHEADER.AAMOUNT+RARRHEADER.AFRAmount)) as REGAMOUNT,
SUM((RARRHEADER.AAMOUNT+RARRHEADER.AFRAmount)/(CASE WHEN RECLASS.CESSIONF=1 THEN RARRHEADER.CLIMIT ELSE 1 END)) as AMOUNT    
From RARRHEADER, acceptance, REINSURANCE, cover, RECLASS    
WHERE COVER.CNO=ACCEPTANCE.CNO AND RECLASS.TOC=ACCEPTANCE.TOC AND RECLASS.RNO=REINSURANCE.RNO AND    
ACCEPTANCE.REGID=@P_REGID AND  ACCEPTANCE.FLDID=@P_FLDID And ACCEPTANCE.VALUEID=@P_VALUEID And ACCEPTANCE.ANO=RARRHEADER.ANO and ACCEPTANCE.ASTATUS='W' and RArrHeader.Status='A' And REINSURANCE.RID=RARRHEADER.AID    
And (CASE WHEN RECLASS.CESSIONF=1 THEN RARRHEADER.CLIMIT ELSE 1 END)<>0  
and (@P_RYEAR=0 or Reinsurance.RYear=@P_RYear)
GROUP BY Reinsurance.RYear    
ORDER BY MIN(CASE WHEN RECLASS.LIMIT<>0 THEN RECLASS.LIMIT ELSE REINSURANCE.LIMIT END*CASE WHEN (Cover.ISType not in ('R','T')) or (ReClass.DirectF=0) Then 1 Else 0 End) DESC    
    
	
Go

insert into PatchVersioning
select '1365 Update Script - Accumulation Register (By Treaty Year)',GETDATE()
go	
  

Declare @PrevScript varchar(100)
Declare @CurrScript varchar(100)

Select @PrevScript=''
Select @CurrSCript='1365 Update Script - Accumulation Register (By Treaty Year)'


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






                    

 

