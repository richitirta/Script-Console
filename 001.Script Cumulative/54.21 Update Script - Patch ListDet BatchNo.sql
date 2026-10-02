
if exists (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'ListDet05_a') AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) )
BEGIN

DROP function ListDet05_a 
end
GO
CREATE function ListDet05_a (@P_ANO as integer,     
@Value1 as varchar(255), @Value2 as varchar(255), @Value3 as varchar(255), @Value4 as varchar(255), @Value5 as varchar(255),     
@Value6 varchar(255), @Value7 as varchar(255), @Value8 as varchar(255), @Value9 as varchar(255), @Value10 as varchar(255),    
@Value11 as varchar(255),@Value12 as varchar(255), @Value13 as varchar(255),@Value14 as varchar(255),@Value15 as varchar(255),    
@Value16 as varchar(255),@Value17 as varchar(255),@Value18 as varchar(255),@Value19 as varchar(255),@Value20 as varchar(255),@Value21 as varchar(255), @Value22 as varchar(255), @Value23 as varchar(255)    
)          
RETURNS Table        
AS RETURN        
(        
 SELECT Cast(0 as bit) as ProcessFlag,        
 Acceptance.CertificateNo,        
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
 RArrHeader,        
 Profile        
Where        
 cover.CNO = acceptance.CNO        
 and RArrHeader.ANO=Acceptance.ANO         
 And Acceptance.ANO<>Acceptance.LANO        
 And Acceptance.LANO=@P_ANO        
 And Cover.PHOLDER=Profile.ID        
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
if exists (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'ListDet05_b') AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) )
BEGIN
DROP function ListDet05_b 
end
GO
CREATE function ListDet05_b (@P_ANO as integer,     
@Value1 as varchar(255), @Value2 as varchar(255), @Value3 as varchar(255), @Value4 as varchar(255), @Value5 as varchar(255),     
@Value6 varchar(255), @Value7 as varchar(255), @Value8 as varchar(255), @Value9 as varchar(255), @Value10 as varchar(255),    
@Value11 as varchar(255),@Value12 as varchar(255), @Value13 as varchar(255),@Value14 as varchar(255),@Value15 as varchar(255),    
@Value16 as varchar(255),@Value17 as varchar(255),@Value18 as varchar(255),@Value19 as varchar(255),@Value20 as varchar(255),@Value21 as varchar(255), @Value22 as varchar(255), @Value23 as varchar(255)    
)          
RETURNS Table      
AS RETURN      
(      
SELECT Cast(0 as bit) as ProcessFlag,      
 q.CertificateNo,      
 q.ESeqNo,      
 q.AName,      
 q.ANO,      
 q.REGNO,      
 q.ADATE,      
 q.USERID,      
 q.Currency,      
 q.TSI,      
 q.OurShare,      
 q.Gross,      
 q.ASTATUS,      
 q.ATYPE,      
 q.SDate,      
 q.EDate,      
 q.RYear,      
 q.ValueID,       
 q.ValueDesc,      
 q.BatchNo,
 a.valueid1, a.valuedesc1,      
 a.valueid2, a.valuedesc2,      
 a.valueid3, a.valuedesc3,      
 a.valueid4, a.valuedesc4,      
 a.valueid5, a.valuedesc5,      
 a.valueid6, a.valuedesc6,      
 a.valueid7, a.valuedesc7,      
 a.valueid8, a.valuedesc8,      
 a.valueid9, a.valuedesc9,      
 a.valueid10, a.valuedesc10,      
 a.valueid11, a.valuedesc11,      
 a.valueid12, a.valuedesc12,      
 a.valueid13, a.valuedesc13,      
 a.valueid14, a.valuedesc14,      
 a.VALUEID15 , a.VALUEDESC15,
  b.valueid16, b.valuedesc16,  
  b.valueid17, b.valuedesc17,  
  b.valueid18, b.valuedesc18,  
  b.valueid19, b.valuedesc19,  
  b.valueid20, b.valuedesc20,  
  b.valueid21, b.valuedesc21,  
  b.valueid22, b.valuedesc22,  
  b.valueid23, b.valuedesc23,  
  b.valueid24, b.valuedesc24,  
  b.valueid25, b.valuedesc25,  
  b.valueid26, b.valuedesc26,  
  b.valueid27, b.valuedesc27,  
  b.valueid28, b.valuedesc28,  
  b.valueid29, b.valuedesc29,  
  b.VALUEID30 , b.VALUEDESC30
FROM ListDet05_a (@P_ANO, @Value1, @Value2, @Value3, @Value4, @Value5, @Value6, @Value7, @Value8, @Value9, @Value10,@Value11, @Value12, @Value13,@Value14,@Value15,@Value16,@Value17,@Value18,@Value19, @Value20, @Value21, @Value22, @Value23) q, ainfo a 
Left Join Ainfo_Ext b on (b.ANO=a.ANO)
Where q.ANO = a.ANO      
)      

GO
IF EXISTS ( SELECT * FROM   sysobjects WHERE  id = object_id(N'ListDet01') and OBJECTPROPERTY(id, N'IsProcedure') = 1 )
BEGIN
DROP PROCEDURE ListDet01 
end
GO
CREATE PROCEDURE ListDet01 (@P_ANO as integer) 
AS 
SELECT Cast(0 as bit) as ProcessFlag, Acceptance.CertificateNo, Acceptance.ESeqNo,Cast(Acceptance.AName as varchar(128)) as AName, Acceptance.ANO, Acceptance.REGNO, Acceptance.ADATE, Acceptance.LUSERID as USERID,SysTab.Currency, Acceptance.ASTATUS, Acceptance.ATYPE, Acceptance.SDate, Acceptance.EDate, Acceptance.ValueID, dbo.get_objectInfo(Acceptance.ANO) as ValueDesc, Acceptance.BatchNo,
Year(RArrHeader.RDate) as RYear,
(SELECT coalesce(SUM(PCALC.TSI*PCALC.RATE),0) FROM  PCALC WHERE PCALC.ANO=ACCEPTANCE.ANO AND ACCEPTANCE.PSTATUS='C')*CASE WHEN ACCEPTANCE.QTY=0 THEN 1 ELSE ACCEPTANCE.QTY END AS TSI,
(SELECT coalesce(SUM(PCALC.OURSHARE*PCALC.RATE),0) FROM  PCALC WHERE PCALC.ANO=ACCEPTANCE.ANO AND ACCEPTANCE.PSTATUS='C')*CASE WHEN ACCEPTANCE.QTY=0 THEN 1 ELSE ACCEPTANCE.QTY END AS OURSHARE, 
(SELECT coalesce(SUM(PCALC.GROSS*PCALC.RATE),0) FROM  PCALC WHERE PCALC.ANO=ACCEPTANCE.ANO AND ACCEPTANCE.PSTATUS='C')*CASE WHEN ACCEPTANCE.QTY=0 THEN 1 ELSE ACCEPTANCE.QTY END AS GROSS
FROM Acceptance left Join RArrHeader on (RArrHeader.ANO=Acceptance.ANO), Cover, SysTab, Acceptance MAcceptance 
WHERE MAcceptance.ANO=@P_ANO and Cover.CNO=MAcceptance.CNO 
And (Acceptance.LANO=MAcceptance.ANO And Acceptance.ANO<>Acceptance.LANO And Acceptance.LANO<>-1) 
 
Union 
 
SELECT Cast(0 as bit) as ProcessFlag, Acceptance.CertificateNo, Acceptance.ESeqNo,Cast(Acceptance.AName as varchar(128)) as AName, Acceptance.ANO, Acceptance.REGNO, Acceptance.ADATE, Acceptance.LUSERID as USERID,SysTab.Currency, Acceptance.ASTATUS, Acceptance.ATYPE, Acceptance.SDate, Acceptance.EDate, Acceptance.ValueID, dbo.get_objectInfo(Acceptance.ANO) as ValueDesc, Acceptance.BatchNo,
Year(RArrHeader.RDate) as RYear,
(SELECT coalesce(SUM(PCALC.TSI*PCALC.RATE),0) FROM  PCALC WHERE PCALC.ANO=ACCEPTANCE.ANO AND ACCEPTANCE.PSTATUS='C')*CASE WHEN ACCEPTANCE.QTY=0 THEN 1 ELSE ACCEPTANCE.QTY END AS TSI,
(SELECT coalesce(SUM(PCALC.OURSHARE*PCALC.RATE),0) FROM  PCALC WHERE PCALC.ANO=ACCEPTANCE.ANO AND ACCEPTANCE.PSTATUS='C')*CASE WHEN ACCEPTANCE.QTY=0 THEN 1 ELSE ACCEPTANCE.QTY END AS OURSHARE, 
(SELECT coalesce(SUM(PCALC.GROSS*PCALC.RATE),0) FROM  PCALC WHERE PCALC.ANO=ACCEPTANCE.ANO AND ACCEPTANCE.PSTATUS='C')*CASE WHEN ACCEPTANCE.QTY=0 THEN 1 ELSE ACCEPTANCE.QTY END AS GROSS
FROM Acceptance left Join RArrHeader on (RArrHeader.ANO=Acceptance.ANO), Cover, SysTab, Acceptance MAcceptance 
WHERE MAcceptance.ANO=@P_ANO and Cover.CNO=MAcceptance.CNO 
And (MAcceptance.RegNo<>'' and Acceptance.RegNo=MAcceptance.RegNo and Acceptance.PolicyNo<>'' and Acceptance.PolicyNo=MAcceptance.PolicyNo And Acceptance.ANO<>Acceptance.LANO And Acceptance.LANO<>-1) 
 
Union 
 
SELECT Cast(0 as bit) as ProcessFlag, Acceptance.CertificateNo, Acceptance.ESeqNo,Cast(Acceptance.AName as varchar(128)) as AName, Acceptance.ANO, Acceptance.REGNO, Acceptance.ADATE, Acceptance.LUSERID as USERID,SysTab.Currency, Acceptance.ASTATUS, Acceptance.ATYPE, Acceptance.SDate, Acceptance.EDate, Acceptance.ValueID, dbo.get_objectInfo(Acceptance.ANO) as ValueDesc, Acceptance.BatchNo,
Year(RArrHeader.RDate) as RYear,
(SELECT coalesce(SUM(PCALC.TSI*PCALC.RATE),0) FROM  PCALC WHERE PCALC.ANO=ACCEPTANCE.ANO AND ACCEPTANCE.PSTATUS='C')*CASE WHEN ACCEPTANCE.QTY=0 THEN 1 ELSE ACCEPTANCE.QTY END AS TSI,
(SELECT coalesce(SUM(PCALC.OURSHARE*PCALC.RATE),0) FROM  PCALC WHERE PCALC.ANO=ACCEPTANCE.ANO AND ACCEPTANCE.PSTATUS='C')*CASE WHEN ACCEPTANCE.QTY=0 THEN 1 ELSE ACCEPTANCE.QTY END AS OURSHARE, 
(SELECT coalesce(SUM(PCALC.GROSS*PCALC.RATE),0) FROM  PCALC WHERE PCALC.ANO=ACCEPTANCE.ANO AND ACCEPTANCE.PSTATUS='C')*CASE WHEN ACCEPTANCE.QTY=0 THEN 1 ELSE ACCEPTANCE.QTY END AS GROSS
FROM Acceptance left Join RArrHeader on (RArrHeader.ANO=Acceptance.ANO), Cover, SysTab, Acceptance MAcceptance 
WHERE MAcceptance.ANO=@P_ANO and Cover.CNO=MAcceptance.CNO 
And (MAcceptance.AStatus='W' and MAcceptance.AType<>'N' and MAcceptance.PANO<>-1 and Acceptance.LANO=MAcceptance.PANO And Acceptance.ANO<>Acceptance.LANO And Acceptance.LANO<>-1) 
Order By Acceptance.CertificateNo 
GO
IF EXISTS ( SELECT * FROM   sysobjects WHERE  id = object_id(N'ListDet03') and OBJECTPROPERTY(id, N'IsProcedure') = 1 )
BEGIN
DROP PROCEDURE ListDet03 
end
GO
CREATE PROCEDURE ListDet03 (@P_ANO as integer,@P_SDATE as smalldatetime, @P_EDATE as smalldatetime) 
AS 
SELECT Cast(0 as bit) as ProcessFlag, Acceptance.CertificateNo, Acceptance.ESeqNo,Cast(Acceptance.AName as varchar(128)) as AName, Acceptance.ANO, Acceptance.REGNO, Acceptance.ADATE, Acceptance.LUSERID as USERID,  SysTab.Currency, Acceptance.ASTATUS, Acceptance.ATYPE, Acceptance.SDate, Acceptance.EDate, Acceptance.ValueID, dbo.get_objectInfo(Acceptance.ANO) as ValueDesc, Acceptance.BatchNo, Year(RArrHeader.RDate) as RYear, (SELECT coalesce(SUM(PCALC.TSI*PCALC.RATE),0) FROM  PCALC WHERE PCALC.ANO=ACCEPTANCE.ANO AND ACCEPTANCE.PSTATUS='C')*CASE WHEN ACCEPTANCE.QTY=0 THEN 1 ELSE ACCEPTANCE.QTY END AS TSI, (SELECT coalesce(SUM(PCALC.OURSHARE*PCALC.RATE),0) FROM  PCALC WHERE PCALC.ANO=ACCEPTANCE.ANO AND ACCEPTANCE.PSTATUS='C')*CASE WHEN ACCEPTANCE.QTY=0 THEN 1 ELSE ACCEPTANCE.QTY END AS OURSHARE, (SELECT coalesce(SUM(PCALC.GROSS*PCALC.RATE),0) FROM  PCALC WHERE PCALC.ANO=ACCEPTANCE.ANO AND ACCEPTANCE.PSTATUS='C')*CASE WHEN ACCEPTANCE.QTY=0 THEN 1 ELSE ACCEPTANCE.QTY END AS GROSS 
FROM Acceptance left Join RArrHeader on (RArrHeader.ANO=Acceptance.ANO) , Cover, SysTab, Acceptance MAcceptance 
WHERE MAcceptance.ANO=@P_ANO and Cover.CNO=MAcceptance.CNO 
And (Acceptance.LANO=MAcceptance.ANO And Acceptance.ANO<>Acceptance.LANO And Acceptance.LANO<>-1) 
And Acceptance.ADate Between @P_Sdate and @P_EDate 
 
Union 
 
SELECT Cast(0 as bit) as ProcessFlag, Acceptance.CertificateNo, Acceptance.ESeqNo,Cast(Acceptance.AName as varchar(128)) as AName, Acceptance.ANO, Acceptance.REGNO, Acceptance.ADATE, Acceptance.LUSERID as USERID,  SysTab.Currency, Acceptance.ASTATUS, Acceptance.ATYPE, Acceptance.SDate, Acceptance.EDate, Acceptance.ValueID, dbo.get_objectInfo(Acceptance.ANO) as ValueDesc, Acceptance.BatchNo, Year(RArrHeader.RDate) as RYear, (SELECT coalesce(SUM(PCALC.TSI*PCALC.RATE),0) FROM  PCALC WHERE PCALC.ANO=ACCEPTANCE.ANO AND ACCEPTANCE.PSTATUS='C')*CASE WHEN ACCEPTANCE.QTY=0 THEN 1 ELSE ACCEPTANCE.QTY END AS TSI, (SELECT coalesce(SUM(PCALC.OURSHARE*PCALC.RATE),0) FROM  PCALC WHERE PCALC.ANO=ACCEPTANCE.ANO AND ACCEPTANCE.PSTATUS='C')*CASE WHEN ACCEPTANCE.QTY=0 THEN 1 ELSE ACCEPTANCE.QTY END AS OURSHARE, (SELECT coalesce(SUM(PCALC.GROSS*PCALC.RATE),0) FROM  PCALC WHERE PCALC.ANO=ACCEPTANCE.ANO AND ACCEPTANCE.PSTATUS='C')*CASE WHEN ACCEPTANCE.QTY=0 THEN 1 ELSE ACCEPTANCE.QTY END AS GROSS 
FROM Acceptance left Join RArrHeader on (RArrHeader.ANO=Acceptance.ANO) , Cover, SysTab, Acceptance MAcceptance 
WHERE MAcceptance.ANO=@P_ANO and Cover.CNO=MAcceptance.CNO 
And (MAcceptance.RegNo<>'' and Acceptance.RegNo=MAcceptance.RegNo and Acceptance.PolicyNo<>'' and Acceptance.PolicyNo=MAcceptance.PolicyNo And Acceptance.ANO<>Acceptance.LANO And Acceptance.LANO<>-1) 
And Acceptance.ADate Between @P_Sdate and @P_EDate 
 
Union 
 
SELECT Cast(0 as bit) as ProcessFlag, Acceptance.CertificateNo, Acceptance.ESeqNo,Cast(Acceptance.AName as varchar(128)) as AName, Acceptance.ANO, Acceptance.REGNO, Acceptance.ADATE, Acceptance.LUSERID as USERID,  SysTab.Currency, Acceptance.ASTATUS, Acceptance.ATYPE, Acceptance.SDate, Acceptance.EDate, Acceptance.ValueID, dbo.get_objectInfo(Acceptance.ANO) as ValueDesc, Acceptance.BatchNo, Year(RArrHeader.RDate) as RYear, (SELECT coalesce(SUM(PCALC.TSI*PCALC.RATE),0) FROM  PCALC WHERE PCALC.ANO=ACCEPTANCE.ANO AND ACCEPTANCE.PSTATUS='C')*CASE WHEN ACCEPTANCE.QTY=0 THEN 1 ELSE ACCEPTANCE.QTY END AS TSI, (SELECT coalesce(SUM(PCALC.OURSHARE*PCALC.RATE),0) FROM  PCALC WHERE PCALC.ANO=ACCEPTANCE.ANO AND ACCEPTANCE.PSTATUS='C')*CASE WHEN ACCEPTANCE.QTY=0 THEN 1 ELSE ACCEPTANCE.QTY END AS OURSHARE, (SELECT coalesce(SUM(PCALC.GROSS*PCALC.RATE),0) FROM  PCALC WHERE PCALC.ANO=ACCEPTANCE.ANO AND ACCEPTANCE.PSTATUS='C')*CASE WHEN ACCEPTANCE.QTY=0 THEN 1 ELSE ACCEPTANCE.QTY END AS GROSS 
FROM Acceptance left Join RArrHeader on (RArrHeader.ANO=Acceptance.ANO) , Cover, SysTab, Acceptance MAcceptance 
WHERE MAcceptance.ANO=@P_ANO and Cover.CNO=MAcceptance.CNO 
And (MAcceptance.AStatus='W' and MAcceptance.AType<>'N' and MAcceptance.PANO<>-1 and Acceptance.LANO=MAcceptance.PANO And Acceptance.ANO<>Acceptance.LANO And Acceptance.LANO<>-1) 
And Acceptance.ADate Between @P_Sdate and @P_EDate 
Order By Acceptance.CertificateNo 
 
GO
IF EXISTS ( SELECT * FROM   sysobjects WHERE  id = object_id(N'ListDet04') and OBJECTPROPERTY(id, N'IsProcedure') = 1 )
BEGIN
DROP PROCEDURE ListDet04 
end
GO
CREATE PROCEDURE ListDet04 (@P_ANO as integer,@P_FCERTNO as varchar(20), @P_LCERTNO as varchar(20)) 
AS 
SELECT Cast(0 as bit) as ProcessFlag, Acceptance.CertificateNo, Acceptance.ESeqNo,Cast(Acceptance.AName as varchar(128)) as AName, Acceptance.ANO, Acceptance.REGNO, Acceptance.ADATE, Acceptance.LUSERID as USERID,  SysTab.Currency, Acceptance.ASTATUS, Acceptance.ATYPE, Acceptance.SDate, Acceptance.EDate, Acceptance.ValueID, dbo.get_objectInfo(Acceptance.ANO) as ValueDesc, Acceptance.BatchNo, Year(RArrHeader.RDate) as RYear, (SELECT coalesce(SUM(PCALC.TSI*PCALC.RATE),0) FROM  PCALC WHERE PCALC.ANO=ACCEPTANCE.ANO AND ACCEPTANCE.PSTATUS='C')*CASE WHEN ACCEPTANCE.QTY=0 THEN 1 ELSE ACCEPTANCE.QTY END AS TSI, (SELECT coalesce(SUM(PCALC.OURSHARE*PCALC.RATE),0) FROM  PCALC WHERE PCALC.ANO=ACCEPTANCE.ANO AND ACCEPTANCE.PSTATUS='C')*CASE WHEN ACCEPTANCE.QTY=0 THEN 1 ELSE ACCEPTANCE.QTY END AS OURSHARE, (SELECT coalesce(SUM(PCALC.GROSS*PCALC.RATE),0) FROM  PCALC WHERE PCALC.ANO=ACCEPTANCE.ANO AND ACCEPTANCE.PSTATUS='C')*CASE WHEN ACCEPTANCE.QTY=0 THEN 1 ELSE ACCEPTANCE.QTY END AS GROSS 
FROM Acceptance left Join RArrHeader on (RArrHeader.ANO=Acceptance.ANO) , Cover, SysTab, Acceptance MAcceptance 
WHERE MAcceptance.ANO=@P_ANO and Cover.CNO=MAcceptance.CNO 
And (Acceptance.LANO=MAcceptance.ANO And Acceptance.ANO<>Acceptance.LANO And Acceptance.LANO<>-1) 
And Acceptance.CertificateNo Between @P_FCertNo and @P_LCertNo 
 
Union 
 
SELECT Cast(0 as bit) as ProcessFlag, Acceptance.CertificateNo, Acceptance.ESeqNo,Cast(Acceptance.AName as varchar(128)) as AName, Acceptance.ANO, Acceptance.REGNO, Acceptance.ADATE, Acceptance.LUSERID as USERID,  SysTab.Currency, Acceptance.ASTATUS, Acceptance.ATYPE, Acceptance.SDate, Acceptance.EDate, Acceptance.ValueID, dbo.get_objectInfo(Acceptance.ANO) as ValueDesc, Acceptance.BatchNo, Year(RArrHeader.RDate) as RYear, (SELECT coalesce(SUM(PCALC.TSI*PCALC.RATE),0) FROM  PCALC WHERE PCALC.ANO=ACCEPTANCE.ANO AND ACCEPTANCE.PSTATUS='C')*CASE WHEN ACCEPTANCE.QTY=0 THEN 1 ELSE ACCEPTANCE.QTY END AS TSI, (SELECT coalesce(SUM(PCALC.OURSHARE*PCALC.RATE),0) FROM  PCALC WHERE PCALC.ANO=ACCEPTANCE.ANO AND ACCEPTANCE.PSTATUS='C')*CASE WHEN ACCEPTANCE.QTY=0 THEN 1 ELSE ACCEPTANCE.QTY END AS OURSHARE, (SELECT coalesce(SUM(PCALC.GROSS*PCALC.RATE),0) FROM  PCALC WHERE PCALC.ANO=ACCEPTANCE.ANO AND ACCEPTANCE.PSTATUS='C')*CASE WHEN ACCEPTANCE.QTY=0 THEN 1 ELSE ACCEPTANCE.QTY END AS GROSS 
FROM Acceptance left Join RArrHeader on (RArrHeader.ANO=Acceptance.ANO) , Cover, SysTab, Acceptance MAcceptance 
WHERE MAcceptance.ANO=@P_ANO and Cover.CNO=MAcceptance.CNO 
And (MAcceptance.RegNo<>'' and Acceptance.RegNo=MAcceptance.RegNo and Acceptance.PolicyNo<>'' and Acceptance.PolicyNo=MAcceptance.PolicyNo And Acceptance.ANO<>Acceptance.LANO And Acceptance.LANO<>-1) 
And Acceptance.CertificateNo Between @P_FCertNo and @P_LCertNo 
 
Union 
 
SELECT Cast(0 as bit) as ProcessFlag, Acceptance.CertificateNo, Acceptance.ESeqNo,Cast(Acceptance.AName as varchar(128)) as AName, Acceptance.ANO, Acceptance.REGNO, Acceptance.ADATE, Acceptance.LUSERID as USERID,  SysTab.Currency, Acceptance.ASTATUS, Acceptance.ATYPE, Acceptance.SDate, Acceptance.EDate, Acceptance.ValueID, dbo.get_objectInfo(Acceptance.ANO) as ValueDesc, Acceptance.BatchNo, Year(RArrHeader.RDate) as RYear, (SELECT coalesce(SUM(PCALC.TSI*PCALC.RATE),0) FROM  PCALC WHERE PCALC.ANO=ACCEPTANCE.ANO AND ACCEPTANCE.PSTATUS='C')*CASE WHEN ACCEPTANCE.QTY=0 THEN 1 ELSE ACCEPTANCE.QTY END AS TSI, (SELECT coalesce(SUM(PCALC.OURSHARE*PCALC.RATE),0) FROM  PCALC WHERE PCALC.ANO=ACCEPTANCE.ANO AND ACCEPTANCE.PSTATUS='C')*CASE WHEN ACCEPTANCE.QTY=0 THEN 1 ELSE ACCEPTANCE.QTY END AS OURSHARE, (SELECT coalesce(SUM(PCALC.GROSS*PCALC.RATE),0) FROM  PCALC WHERE PCALC.ANO=ACCEPTANCE.ANO AND ACCEPTANCE.PSTATUS='C')*CASE WHEN ACCEPTANCE.QTY=0 THEN 1 ELSE ACCEPTANCE.QTY END AS GROSS 
FROM Acceptance left Join RArrHeader on (RArrHeader.ANO=Acceptance.ANO) , Cover, SysTab, Acceptance MAcceptance 
WHERE MAcceptance.ANO=@P_ANO and Cover.CNO=MAcceptance.CNO 
And (MAcceptance.AStatus='W' and MAcceptance.AType<>'N' and MAcceptance.PANO<>-1 and Acceptance.LANO=MAcceptance.PANO And Acceptance.ANO<>Acceptance.LANO And Acceptance.LANO<>-1) 
And Acceptance.CertificateNo Between @P_FCertNo and @P_LCertNo 
Order By Acceptance.CertificateNo 
 
 
GO
IF EXISTS ( SELECT * FROM   sysobjects WHERE  id = object_id(N'ListDet05') and OBJECTPROPERTY(id, N'IsProcedure') = 1 )
BEGIN
DROP PROCEDURE ListDet05 
end
GO
CREATE PROCEDURE ListDet05 (@P_ANO as integer,@P_FBATCHNO as varchar(20), @P_LBATCHNO as varchar(20)) 
AS 
SELECT Cast(0 as bit) as ProcessFlag, Acceptance.CertificateNo, Acceptance.ESeqNo,Cast(Acceptance.AName as varchar(128)) as AName, Acceptance.ANO, Acceptance.REGNO, Acceptance.ADATE, Acceptance.LUSERID as USERID,  SysTab.Currency, Acceptance.ASTATUS, Acceptance.ATYPE, Acceptance.SDate, Acceptance.EDate, Acceptance.ValueID, dbo.get_objectInfo(Acceptance.ANO) as ValueDesc, Acceptance.BatchNo, Year(RArrHeader.RDate) as RYear, (SELECT coalesce(SUM(PCALC.TSI*PCALC.RATE),0) FROM  PCALC WHERE PCALC.ANO=ACCEPTANCE.ANO AND ACCEPTANCE.PSTATUS='C')*CASE WHEN ACCEPTANCE.QTY=0 THEN 1 ELSE ACCEPTANCE.QTY END AS TSI, (SELECT coalesce(SUM(PCALC.OURSHARE*PCALC.RATE),0) FROM  PCALC WHERE PCALC.ANO=ACCEPTANCE.ANO AND ACCEPTANCE.PSTATUS='C')*CASE WHEN ACCEPTANCE.QTY=0 THEN 1 ELSE ACCEPTANCE.QTY END AS OURSHARE, (SELECT coalesce(SUM(PCALC.GROSS*PCALC.RATE),0) FROM  PCALC WHERE PCALC.ANO=ACCEPTANCE.ANO AND ACCEPTANCE.PSTATUS='C')*CASE WHEN ACCEPTANCE.QTY=0 THEN 1 ELSE ACCEPTANCE.QTY END AS GROSS 
FROM Acceptance left Join RArrHeader on (RArrHeader.ANO=Acceptance.ANO) , Cover, SysTab, Acceptance MAcceptance 
WHERE MAcceptance.ANO=@P_ANO and Cover.CNO=MAcceptance.CNO 
And (Acceptance.LANO=MAcceptance.ANO And Acceptance.ANO<>Acceptance.LANO And Acceptance.LANO<>-1) 
And Acceptance.BatchNo Between @P_FBatchNo and @P_LBatchNo 
 
Union 
 
SELECT Cast(0 as bit) as ProcessFlag, Acceptance.CertificateNo, Acceptance.ESeqNo,Cast(Acceptance.AName as varchar(128)) as AName, Acceptance.ANO, Acceptance.REGNO, Acceptance.ADATE, Acceptance.LUSERID as USERID,  SysTab.Currency, Acceptance.ASTATUS, Acceptance.ATYPE, Acceptance.SDate, Acceptance.EDate, Acceptance.ValueID, dbo.get_objectInfo(Acceptance.ANO) as ValueDesc, Acceptance.BatchNo, Year(RArrHeader.RDate) as RYear, (SELECT coalesce(SUM(PCALC.TSI*PCALC.RATE),0) FROM  PCALC WHERE PCALC.ANO=ACCEPTANCE.ANO AND ACCEPTANCE.PSTATUS='C')*CASE WHEN ACCEPTANCE.QTY=0 THEN 1 ELSE ACCEPTANCE.QTY END AS TSI, (SELECT coalesce(SUM(PCALC.OURSHARE*PCALC.RATE),0) FROM  PCALC WHERE PCALC.ANO=ACCEPTANCE.ANO AND ACCEPTANCE.PSTATUS='C')*CASE WHEN ACCEPTANCE.QTY=0 THEN 1 ELSE ACCEPTANCE.QTY END AS OURSHARE, (SELECT coalesce(SUM(PCALC.GROSS*PCALC.RATE),0) FROM  PCALC WHERE PCALC.ANO=ACCEPTANCE.ANO AND ACCEPTANCE.PSTATUS='C')*CASE WHEN ACCEPTANCE.QTY=0 THEN 1 ELSE ACCEPTANCE.QTY END AS GROSS 
FROM Acceptance left Join RArrHeader on (RArrHeader.ANO=Acceptance.ANO) , Cover, SysTab, Acceptance MAcceptance 
WHERE MAcceptance.ANO=@P_ANO and Cover.CNO=MAcceptance.CNO 
And (MAcceptance.RegNo<>'' and Acceptance.RegNo=MAcceptance.RegNo and Acceptance.PolicyNo<>'' and Acceptance.PolicyNo=MAcceptance.PolicyNo And Acceptance.ANO<>Acceptance.LANO And Acceptance.LANO<>-1) 
And Acceptance.BatchNo Between @P_FBatchNo and @P_LBatchNo 
 
Union 
 
SELECT Cast(0 as bit) as ProcessFlag, Acceptance.CertificateNo, Acceptance.ESeqNo,Cast(Acceptance.AName as varchar(128)) as AName, Acceptance.ANO, Acceptance.REGNO, Acceptance.ADATE, Acceptance.LUSERID as USERID,  SysTab.Currency, Acceptance.ASTATUS, Acceptance.ATYPE, Acceptance.SDate, Acceptance.EDate, Acceptance.ValueID, dbo.get_objectInfo(Acceptance.ANO) as ValueDesc, Acceptance.BatchNo, Year(RArrHeader.RDate) as RYear, (SELECT coalesce(SUM(PCALC.TSI*PCALC.RATE),0) FROM  PCALC WHERE PCALC.ANO=ACCEPTANCE.ANO AND ACCEPTANCE.PSTATUS='C')*CASE WHEN ACCEPTANCE.QTY=0 THEN 1 ELSE ACCEPTANCE.QTY END AS TSI, (SELECT coalesce(SUM(PCALC.OURSHARE*PCALC.RATE),0) FROM  PCALC WHERE PCALC.ANO=ACCEPTANCE.ANO AND ACCEPTANCE.PSTATUS='C')*CASE WHEN ACCEPTANCE.QTY=0 THEN 1 ELSE ACCEPTANCE.QTY END AS OURSHARE, (SELECT coalesce(SUM(PCALC.GROSS*PCALC.RATE),0) FROM  PCALC WHERE PCALC.ANO=ACCEPTANCE.ANO AND ACCEPTANCE.PSTATUS='C')*CASE WHEN ACCEPTANCE.QTY=0 THEN 1 ELSE ACCEPTANCE.QTY END AS GROSS 
FROM Acceptance left Join RArrHeader on (RArrHeader.ANO=Acceptance.ANO) , Cover, SysTab, Acceptance MAcceptance 
WHERE MAcceptance.ANO=@P_ANO and Cover.CNO=MAcceptance.CNO 
And (MAcceptance.AStatus='W' and MAcceptance.AType<>'N' and MAcceptance.PANO<>-1 and Acceptance.LANO=MAcceptance.PANO And Acceptance.ANO<>Acceptance.LANO And Acceptance.LANO<>-1) 
And Acceptance.BatchNo Between @P_FBatchNo and @P_LBatchNo 
Order By Acceptance.CertificateNo 
 
GO
if exists (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'ListSR_Det') AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) )
BEGIN
DROP function ListSR_Det
end
GO
CREATE  function ListSR_Det(@P_ANO AS INTEGER, @value1 as varchar(255) ,@value2 as varchar(255) ,@value3 as varchar(255) ,@value4 as varchar(255) ,@value5 as varchar(255) ,@value6 as varchar(255) ,@Value7 as varchar(255) ,@value8 as varchar(255) ,@value9 as varchar(255),@Value10 as varchar(255), @Value11 as varchar(255))    
returns table    
AS return    
(    
SELECT     
 Cast(0 as bit) as ProcessFlag,     
 Cover.COVERNO,     
 Cast(Acceptance.AName as varchar(128)) as AName,     
 Acceptance.CertificateNo,     
 Cover.CNO,     
 Cover.CStatus,     
 Cover.VSeqNo,     
 Acceptance.LANO,     
 Acceptance.ANO,     
 Acceptance.REGNO,     
 Acceptance.ADATE,     
 Acceptance.USERID,     
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
FROM     
 Acceptance,     
 Cover,     
 RArrHeader,     
 SysTab,          
 Profile    
WHERE     
 Cover.CNO=Acceptance.CNO     
 And RArrHeader.ANO=Acceptance.ANO     
      
 And Acceptance.ANO<>Acceptance.LANO     
 And Acceptance.LANO=@P_ANO    
  And Cover.PHOLDER=Profile.ID    
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
 And Cover.ISType<>'T'    
)  

GO
if exists (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'List22_Det') AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) )
BEGIN
DROP FUNCTION List22_Det 
end
GO
CREATE FUNCTION List22_Det (@P_ANO as integer,@P_SDate as smalldatetime, @P_EDate as smalldatetime)
RETURNS Table
AS RETURN(
    
SELECT Cast(0 as bit) as ProcessFlag,
 Acceptance.CertificateNo,
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
 RARRHEADER
Where
 cover.CNO = acceptance.CNO
 And Rarrheader.ANO = Acceptance.ANO 
 And Acceptance.ANO<>Acceptance.LANO
 And Acceptance.LANO=@P_ANO
 And Acceptance.AStatus='I'
)
    
GO
if exists (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'List21_Det') AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) )
BEGIN
DROP FUNCTION List21_Det 
end
GO
CREATE FUNCTION List21_Det (@P_ANO as integer,@P_UserID varchar(255)) 
RETURNS TABLE 
AS RETURN( 
 
SELECT Cast(0 as bit) as ProcessFlag, 
Acceptance.CertificateNo, 
Acceptance.ESeqNo, 
Acceptance.AName, 
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
FROM 
Acceptance, 
Cover, 
SysTab,
RArrHeader
WHERE 
Cover.CNO=Acceptance.CNO 
and RArrHeader.ANO=Acceptance.ANO
And Acceptance.ANO<>Acceptance.LANO 
And Acceptance.LANO=@P_ANO 
And Acceptance.RequestF=1 and Acceptance.RequestName Like @P_UserID 
) 
 
GO
if exists (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'List20_Det') AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) )
BEGIN
DROP FUNCTION List20_Det
end
GO
CREATE FUNCTION List20_Det(@P_ANO as integer, @P_USERID as varchar(255), @P_SDate as smalldatetime, @P_EDate as smalldatetime, @P_AStatus as varchar(1)) 
RETURNS TABLE 
AS RETURN( 
 
SELECT 
Cast(0 as bit) as ProcessFlag, 
Acceptance.CertificateNo, 
Acceptance.ESeqNo, 
Acceptance.AName, 
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
FROM 
Acceptance,
Cover, 
SysTab,
RArrHeader
WHERE 
Cover.CNO=Acceptance.CNO 
and RArrHeader.ANO=Acceptance.ANO
And Acceptance.ANO<>Acceptance.LANO 
And Acceptance.LANO=@P_ANO 
And Cover.ISType<>'T' 
And Acceptance.LUserID Like @P_UserID 
And Acceptance.LDate between @P_SDate and @P_EDate 
And (Acceptance.AStatus=@P_AStatus or @P_AStatus='') 
) 
 
GO
if exists (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'List19_Det') AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) )
BEGIN
DROP FUNCTION List19_Det 
end
GO
CREATE FUNCTION List19_Det (@P_ANO as integer, @P_Days as smallint, @P_Date as Smalldatetime,@P_COB as varchar(10),@P_Branch as varchar(10), @P_UnPaidOpt as Bit)   
RETURNS TABLE   
as RETURN(   
   
SELECT Cast(0 as bit) as ProcessFlag,   
Acceptance.CertificateNo,   
Acceptance.ESeqNo,   
Acceptance.AName,   
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
FROM   
Acceptance,   
Cover,   
SysTab,   
RArrHeader,   
TOC   
WHERE   
Cover.CNO=Acceptance.CNO   
and RArrHeader.ANO=Acceptance.ANO
And TOC.TOC=Acceptance.TOC and TOC.COB=@P_COB And Acceptance.Branch Like @P_Branch+'%'   
   
And Acceptance.ANO<>Acceptance.LANO   
And Acceptance.LANO=@P_ANO   
And Cover.ISType<>'T'   
And Acceptance.AStatus='I'  And Acceptance.AType<>'C'   
And EXISTS (SELECT A1.OANO from Acceptance A1, AccAss, Admlink, nVoucher Voucher Where A1.ANO=AccAss.ANO and A1.OANO=Acceptance.OANO and Voucher.Voucher=Admlink.Voucher and Admlink.AdmNo=AccAss.AdmNo and AccAss.Type in ('DI','IC','IR') and Voucher.nDueDate+@P_Days<@P_Date and Voucher.Nominal_CC-Voucher.Diff_CC-Voucher.Payment_CC-Voucher.Payment_OC<>0 and (@P_UnPaidOpt=0 or Voucher.Payment_CC=0))   
)  

GO
if exists (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'List18_Det') AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) )
BEGIN
DROP FUNCTION List18_Det 
end
GO
CREATE FUNCTION List18_Det (@P_ANO as integer, @P_UserID as varchar(10), @P_TOC as varchar(10), @P_Branch as varchar(10), @P_PDate as smalldatetime)      
RETURNS Table      
AS RETURN(      
          
SELECT Cast(0 as bit) as ProcessFlag,     
 Acceptance.CertificateNo,      
 Acceptance.ESeqNo,      
 Acceptance.AName,      
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
 RArrHeader,      
 SysUserTOC,     
 SysUserBranch    
Where      
 cover.CNO = acceptance.CNO      
 and RArrHeader.ANO=Acceptance.ANO       
 And Acceptance.ANO<>Acceptance.LANO      
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
if exists (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'List17_Det') AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) )
BEGIN
DROP FUNCTION List17_Det 
end
GO
CREATE  FUNCTION List17_Det (@P_ANO as integer, @pSDate as smalldatetime,@pEDate as smalldatetime,@P_SEGMENT as varchar(10))
RETURNS TABLE
as RETURN(

SELECT Cast(0 as bit) as ProcessFlag,
	Acceptance.CertificateNo, 
	Acceptance.ESeqNo,
	Acceptance.AName, 
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
FROM 
	Acceptance, 
	Cover, 
	SysTab,
	RArrHeader	
WHERE 
	Cover.CNO=Acceptance.CNO 
	and RArrHeader.ANO=Acceptance.ANO	 
	And Acceptance.ANO<>Acceptance.LANO 
	And Acceptance.LANO=@P_ANO 
	And Cover.ISType<>'T' 
	And Acceptance.ADate>=@pSDate 
	And Acceptance.ADate<=@pEDate
	And Cover.Segment=@P_SEGMENT
)

GO
if exists (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'list16SR_Det') AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) )
BEGIN
DROP FUNCTION list16SR_Det 
end
GO
CREATE FUNCTION list16SR_Det (@P_ANO as integer, @P_SDate as smalldatetime, @P_EDate as smalldatetime,@P_COB as varchar(10),@P_ServiceNo as varchar(20))  
RETURNS Table  
AS RETURN(  
    
SELECT Cast(0 as bit) as ProcessFlag,  
 Acceptance.CertificateNo,  
 Acceptance.ESeqNo,  
 Acceptance.AName,  
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
 RArrHeader,
 TOC,  
 Service  
Where  
 cover.CNO = acceptance.CNO  
 and RArrHeader.ANO=Acceptance.ANO   
 And Acceptance.ANO<>Acceptance.LANO  
 And Acceptance.LANO=@P_ANO  
 And Service.SType='RENEWAL'  
 And Service.PANO=Acceptance.ANO  
 And Service.Cdate Between @P_Sdate and @P_EDate  
 And Service.SStatus='P'  
 And TOC.TOC=Acceptance.TOC  
 And TOC.COB Like @P_COB+'%'  
 And Service.ServiceNo Like @P_ServiceNo+'%'  
)  

GO
if exists (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'list16SL_Det') AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) )
BEGIN
DROP FUNCTION list16SL_Det
end 
GO
CREATE FUNCTION list16SL_Det (@P_ANO as integer, @P_SDate as smalldatetime, @P_EDate as smalldatetime,@P_COB as varchar(10),@P_ServiceNo as varchar(20))  
RETURNS Table  
AS RETURN(  
      
SELECT Cast(0 as bit) as ProcessFlag,  
 Acceptance.CertificateNo,  
 Acceptance.ESeqNo,  
 Acceptance.AName,  
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
 RArrHeader,
 TOC,  
 Service  
Where  
 cover.CNO = acceptance.CNO  
 and RArrHeader.ANO=Acceptance.ANO   
 And Acceptance.ANO<>Acceptance.LANO  
 And Acceptance.LANO=@P_ANO  
 And Service.SType='EXPIRED'  
 And Service.PANO=Acceptance.ANO  
 And Service.Cdate Between @P_Sdate and @P_EDate  
 And Service.SStatus='P'  
 And TOC.TOC=Acceptance.TOC  
 And TOC.COB Like @P_COB+'%'  
 And Service.ServiceNo Like @P_ServiceNo+'%'  
)  

GO
if exists (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'list16SE_Det') AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) )
BEGIN
DROP FUNCTION list16SE_Det
end
GO
CREATE  FUNCTION list16SE_Det (@P_ANO as integer, @P_SDate as smalldatetime, @P_EDate as smalldatetime,@P_COB as varchar(10),@P_ServiceNo as varchar(20))  
RETURNS Table  
AS RETURN(  
    
SELECT Cast(0 as bit) as ProcessFlag,  
 Acceptance.CertificateNo,  
 Acceptance.ESeqNo,  
 Acceptance.AName,  
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
 dbo.get_objectInfo(Acceptance.ANO) as ValueDesc ,
 Acceptance.BatchNo
From  
 Acceptance,  
 Cover,  
 SysTab,  
 RArrHeader,
 TOC,  
 Service  
Where  
 cover.CNO = acceptance.CNO  
 and RArrHeader.ANO=Acceptance.ANO   
 And Acceptance.ANO<>Acceptance.LANO  
 And Acceptance.LANO=@P_ANO  
 And Service.SType='ENDORSEMENT'  
 And Service.PANO=Acceptance.ANO  
 And Service.Cdate Between @P_Sdate and @P_EDate  
 And Service.SStatus='P'  
 And TOC.TOC=Acceptance.TOC  
 And TOC.COB Like @P_COB+'%'  
 And Service.ServiceNo Like @P_ServiceNo+'%'  
)  

GO
if exists (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'list16SD_Det') AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) )
BEGIN
DROP FUNCTION list16SD_Det
end
GO
CREATE FUNCTION list16SD_Det (@P_ANO as integer, @P_SDate as smalldatetime, @P_EDate as smalldatetime,@P_COB as varchar(10),@P_ServiceNo as varchar(20))  
RETURNS Table  
AS RETURN(  
      
SELECT Cast(0 as bit) as ProcessFlag,  
 Acceptance.CertificateNo,  
 Acceptance.ESeqNo,  
 Acceptance.AName,  
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
 RArrHeader,
 TOC,  
 Service  
Where  
 cover.CNO = acceptance.CNO  
 and RArrHeader.ANO=Acceptance.ANO  
 And Acceptance.ANO<>Acceptance.LANO  
 And Acceptance.LANO=@P_ANO  
 And ((Service.PANO=Acceptance.ANO and Service.SType<>'NEW') or (Service.ANO=Acceptance.ANO and Service.SType='NEW'))  
 And Service.Cdate Between @P_Sdate and @P_EDate  
 And Acceptance.AStatus='W'  
 And Service.SStatus='C'  
 And TOC.TOC=Acceptance.TOC  
 And TOC.COB Like @P_COB+'%'  
 And Service.ServiceNo Like @P_ServiceNo+'%'  
)  

GO
if exists (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'list16SC_Det') AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) )
BEGIN
DROP FUNCTION list16SC_Det 
end
GO
CREATE  FUNCTION list16SC_Det (@P_ANO as integer, @P_SDate as smalldatetime, @P_EDate as smalldatetime,@P_COB as varchar(10),@P_ServiceNo as varchar(20))  
RETURNS Table  
AS RETURN(  
    
SELECT Cast(0 as bit) as ProcessFlag,  
 Acceptance.CertificateNo,  
 Acceptance.ESeqNo,  
 Acceptance.AName,  
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
 RArrHeader,
 TOC,  
 Service  
Where  
 cover.CNO = acceptance.CNO  
 and RArrHeader.ANO=Acceptance.ANO  
 And Acceptance.ANO<>Acceptance.LANO  
 And Acceptance.LANO=@P_ANO  
 And Service.SType='CANCELLATION'  
 And Service.PANO=Acceptance.ANO  
 And Service.Cdate Between @P_Sdate and @P_EDate  
 And Service.SStatus='P'  
 And TOC.TOC=Acceptance.TOC  
 And TOC.COB Like @P_COB+'%'  
 And Service.ServiceNo Like @P_ServiceNo+'%'  
)  
    

GO
if exists (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'List16_Det') AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) )
BEGIN
DROP FUNCTION List16_Det 
end
GO
CREATE  FUNCTION List16_Det (@P_ANO as integer, @pSDate as smalldatetime,@pEDate as smalldatetime,@P_COB as varchar(10))  
RETURNS TABLE   
as RETURN(  
  
SELECT Cast(0 as bit) as ProcessFlag,  
 Acceptance.CertificateNo,   
 Acceptance.ESeqNo,  
 Acceptance.AName,   
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
FROM   
 Acceptance,   
 Cover,   
 SysTab,   
 RArrHeader,
 TOC  
WHERE   
 Cover.CNO=Acceptance.CNO   
 and RArrHeader.ANO=Acceptance.ANO
 And Acceptance.TOC = TOC.TOC       
 And Acceptance.ANO<>Acceptance.LANO   
 And Acceptance.LANO=@P_ANO   
 And Cover.ISType<>'T'   
 And Acceptance.ADate>=@pSDate   
 And Acceptance.ADate<=@pEDate  
 And TOC.TOC=Acceptance.TOC  
 And TOC.COB=@P_COB  
)  


GO
if exists (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'List15_Det') AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) )
BEGIN
DROP FUNCTION List15_Det
end
GO
CREATE  FUNCTION List15_Det (@P_ANO as integer,@P_REGID varchar(10), @P_FLDID varchar(255), @P_VALUEID varchar(255), @P_VALUEID1 varchar(255), @P_VALUEID2 varchar(255), @P_VALUEID3 varchar(255), @P_VALUEID4 varchar(255), @P_VALUEID5 varchar(255), @P_VALUEID6 varchar(255)) 
RETURNS TABLE
as RETURN(

SELECT Cast(0 as bit) as ProcessFlag,
	Acceptance.CertificateNo, 
	Acceptance.ESeqNo,
	Acceptance.AName, 
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
FROM 
	Acceptance, 
	Cover, 
	SysTab, 
	RArrHeader, 
	GenDTab
WHERE 
	Cover.CNO=Acceptance.CNO 
	and RArrHeader.ANO=Acceptance.ANO 
	And Acceptance.ANO<>Acceptance.LANO 
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
if exists (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'List14_Det') AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) )
BEGIN
DROP FUNCTION List14_Det 
end
GO
CREATE  FUNCTION List14_Det (@P_ANO as integer) 
RETURNS TABLE
as RETURN(

SELECT Cast(0 as bit) as ProcessFlag,
	Acceptance.CertificateNo, 
	Acceptance.ESeqNo,
	Acceptance.AName, 
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
FROM 
	Acceptance, 
	Cover, 
	SysTab,
	RArrHeader
WHERE 
	Cover.CNO=Acceptance.CNO 
    and RArrHeader.ANO=Acceptance.ANO	 
	And Acceptance.ANO<>Acceptance.LANO 
	And Acceptance.LANO=@P_ANO
	and Cover.OpenFlag=1
    And Acceptance.AStatus='I' 
    And Cover.ISType<>'T' 
)

GO
if exists (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'List13_Det') AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) )
BEGIN
DROP FUNCTION List13_Det
end
GO
CREATE  FUNCTION List13_Det (@P_ANO as integer, @pSDate as smalldatetime, @pEDate as smalldatetime)
RETURNS TABLE
as RETURN(

SELECT Cast(0 as bit) as ProcessFlag,
	Acceptance.CertificateNo, 
	Acceptance.ESeqNo,
	Acceptance.AName, 
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
FROM 
	Acceptance, 
	Cover, 
	SysTab,
	RArrHeader
WHERE 
	Cover.CNO=Acceptance.CNO 
    and RArrHeader.ANO=Acceptance.ANO	 
	And Acceptance.ANO<>Acceptance.LANO 
	And Acceptance.LANO=@P_ANO
     	And Acceptance.AStatus='I'
      	And Cover.ISType<>'T' 
      	And Acceptance.ADate>=@pSDate 
      	And Acceptance.ADate<=@pEDate
)

GO
if exists (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'List12_Det') AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) )
BEGIN
DROP FUNCTION List12_Det 
end
GO
CREATE  FUNCTION List12_Det (@P_ANO as integer) 
RETURNS TABLE
AS RETURN(

SELECT Cast(0 as bit) as ProcessFlag,
	Acceptance.CertificateNo, 
	Acceptance.ESeqNo,
	Acceptance.AName, 
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
FROM 
	Acceptance, 
	Cover, 
	SysTab, 	
	Rarrheader
WHERE 
	Cover.CNO=Acceptance.CNO 
	And Rarrheader.ANO = Acceptance.ANO	 
	And Acceptance.ANO<>Acceptance.LANO 
	And Acceptance.LANO=@P_ANO 
	And Cover.CStatus<>'C'
	And Acceptance.AStatus='W' 
	And RArrHeader.TreatyF=1 And RArrHeader.Status='A'
	And Cover.ISType<>'T'
)

GO
if exists (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'List11G_Det') AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) )
BEGIN
DROP FUNCTION List11G_Det 
end
GO
CREATE FUNCTION List11G_Det (@P_ANO as integer,@P_SDate as smalldatetime, @P_EDate as smalldatetime)
RETURNS Table
AS RETURN(
    
SELECT Cast(0 as bit) as ProcessFlag,
 Acceptance.CertificateNo,
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
 RARRHEADER
Where
 cover.CNO = acceptance.CNO
 And Rarrheader.ANO = Acceptance.ANO 
 And Acceptance.ANO<>Acceptance.LANO
 And Acceptance.LANO=@P_ANO
 And Acceptance.AStatus<>'W'
 And Acceptance.ANO in
(SELECT AccAss.ANO from AccAss, RArrDet, FPart Where AccAss.ANO=Acceptance.ANO and AccAss.Type='FO' and FPart.ANO=RArrDet.ANO and FPart.FID=RArrDet.FID and AccAss.ANO=RArrDet.ANO and AccAss.ID=FPart.ID and AccAss.RefNo=FPart.SlipNo and (Acceptance.AType='C' or RArrDet.Status='O'))
)

GO
if exists (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'List11F_Det') AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) )
BEGIN    
DROP FUNCTION List11F_Det
end 
GO
CREATE FUNCTION List11F_Det (@P_ANO as integer,@P_UserID as varchar(10), @P_TOC as varchar(10), @P_Branch as varchar(10), @P_PDate as smalldatetime, @P_ManualF as bit)      
RETURNS Table      
AS RETURN(      
          
SELECT Cast(0 as bit) as ProcessFlag,      
 Acceptance.CertificateNo,      
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
 RARRHEADER,   
 SysUserTOC,   
 SysUserBranch  
Where      
 cover.CNO = acceptance.CNO      
 And Rarrheader.ANO = Acceptance.ANO             
 And Acceptance.ANO<>Acceptance.LANO      
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

if exists (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'List11E_Det') AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) )
BEGIN    
DROP FUNCTION List11E_Det 
end
GO
CREATE FUNCTION List11E_Det (@P_ANO as integer,@P_SDate as smalldatetime, @P_EDate as smalldatetime,@P_REGID as varchar(10))
RETURNS Table
AS RETURN(
              
SELECT Cast(0 as bit) as ProcessFlag,
 Acceptance.CertificateNo,
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
 AccRegDet
Where
 cover.CNO = acceptance.CNO
 and RArrHeader.ANO=Acceptance.ANO
 and Acceptance.REGID=@P_REGID
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
if exists (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'List11D_Det') AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) )
BEGIN      
DROP FUNCTION List11D_Det 
end
GO
CREATE FUNCTION List11D_Det (@P_ANO as integer,@P_SDate as smalldatetime, @P_EDate as smalldatetime) 
RETURNS TABLE
AS RETURN(

SELECT Cast(0 as bit) as ProcessFlag,
	Acceptance.CertificateNo, 
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
FROM 
	Acceptance, 
	Cover, 
	SysTab, 	
	Rarrheader
WHERE 
	Cover.CNO=Acceptance.CNO 
	And Rarrheader.ANO = Acceptance.ANO	 
	And Acceptance.ANO<>Acceptance.LANO 
	And Acceptance.LANO=@P_ANO 
        And Acceptance.ADate Between @P_SDate and @P_EDate
        And RArrHeader.Status<>'R'   
        And RArrHeader.SAmount<>0
        And Cover.ISType<>'T'
)

GO
if exists (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'List11C_Det') AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) )
BEGIN
DROP FUNCTION List11C_Det 
end
GO
CREATE FUNCTION List11C_Det (@P_ANO as integer) 
RETURNS TABLE
AS RETURN(

SELECT Cast(0 as bit) as ProcessFlag,
	Acceptance.CertificateNo, 
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
FROM 
	Acceptance, 
	Cover, 
	SysTab, 	
	Rarrheader
WHERE 
	Cover.CNO=Acceptance.CNO 
	And Rarrheader.ANO = Acceptance.ANO	 
	And Acceptance.ANO<>Acceptance.LANO 
	And Acceptance.LANO=@P_ANO 
	And Cover.CStatus<>'C'
        And Acceptance.AStatus='W'   
        And Acceptance.EMethod='T'  
)


GO
if exists (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'List11B_Det') AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) )
BEGIN
DROP FUNCTION List11B_Det 
end
GO
CREATE FUNCTION List11B_Det (@P_ANO as integer)
RETURNS Table
AS RETURN(
  
SELECT Cast(0 as bit) as ProcessFlag,
 Acceptance.CertificateNo,
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
 RARRHEADER
Where
 cover.CNO = acceptance.CNO
 And Rarrheader.ANO = Acceptance.ANO 
 And Acceptance.ANO<>Acceptance.LANO
 And Acceptance.LANO=@P_ANO
 And Cover.CStatus<>'C'
 And Acceptance.AStatus='W'
 And Cover.ISType<>'T'
 And Exists (SELECT Top 1 ANO from RArrDet Where RArrDet.Status<>'O' and RArrDet.ANO=RarrHeader.ANO)
)

GO
if exists (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'List11A_Det') AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) )
BEGIN
DROP FUNCTION List11A_Det
end
GO
CREATE FUNCTION List11A_Det (@P_ANO as integer, @P_UserID as varchar(255), @P_TOC as varchar(10), @P_Branch as varchar(10), @P_AStatus as varchar(1))   
RETURNS Table   
AS RETURN(   
   
SELECT Cast(0 as bit) as ProcessFlag,   
Acceptance.CertificateNo,   
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
RARRHEADER,   
SysUser   
Where   
cover.CNO = acceptance.CNO   
And Rarrheader.ANO = Acceptance.ANO      
And Acceptance.ANO<>Acceptance.LANO   
And Acceptance.LANO=@P_ANO   
And Cover.CStatus<>'C'   
And Acceptance.AStatus='W'   
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

if exists (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'List11_Det') AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) )
BEGIN
DROP FUNCTION List11_Det 
end
GO
CREATE FUNCTION List11_Det (@P_ANO as integer,@P_SDate as smalldatetime, @P_EDate as smalldatetime)
RETURNS Table
AS RETURN(
        
SELECT Cast(0 as bit) as ProcessFlag,
 Acceptance.CertificateNo,
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
 RARRHEADER
Where
 cover.CNO = acceptance.CNO
 And Rarrheader.ANO = Acceptance.ANO 
 And Acceptance.ANO<>Acceptance.LANO
 And Acceptance.LANO=@P_ANO
 And Cover.CStatus<>'C'
 And (Acceptance.AType Not in ('C','A') and Acceptance.AStatus='I' And RArrHeader.Status='R')
 And Cover.ISType<>'T'
 And Acceptance.ADate Between @P_SDate and @P_EDate
)
  
GO
if exists (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'List09_Det') AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) )
BEGIN        
DROP FUNCTION List09_Det     
end  
GO      
CREATE  FUNCTION List09_Det (@P_ANO as integer, @pSDate as smalldatetime, @pEDate as smalldatetime)
RETURNS TABLE
AS RETURN(

SELECT Cast(0 as bit) as ProcessFlag,
	Acceptance.CertificateNo, 
	Acceptance.ESeqNo,
	Acceptance.AName, 
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
FROM 
	Acceptance, 
	Cover, 
	SysTab,
	RArrHeader
WHERE 
	Cover.CNO=Acceptance.CNO 
    and RArrHeader.ANO=Acceptance.ANO	 
	And Acceptance.ANO<>Acceptance.LANO 
	And Acceptance.LANO=@P_ANO 
	And Acceptance.AType='C' 
	And Cover.ISType<>'T' 
	And Acceptance.ADate>=@pSDate 
	And Acceptance.ADate<=@pEDate
)

GO
if exists (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'List08_Det') AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) )
BEGIN
DROP FUNCTION List08_Det
end
GO
CREATE  FUNCTION List08_Det (@P_ANO as integer, @pSDate as smallDatetime, @pEDate as smalldatetime)
RETURNS TABLE
AS RETURN(

SELECT Cast(0 as bit) as ProcessFlag,
	Acceptance.CertificateNo, 
	Acceptance.ESeqNo,
	Acceptance.AName, 
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
FROM 
	Acceptance, 
	Cover, 
	SysTab,
	RArrHeader
WHERE 
	Cover.CNO=Acceptance.CNO 
	and RArrHeader.ANO=Acceptance.ANO
	And Acceptance.ANO<>Acceptance.LANO 
	And Acceptance.LANO=@P_ANO
	And Acceptance.AType='A' 
	And Cover.ISType<>'T' 
	And Acceptance.ADate>=@pSDate 
	And Acceptance.ADate<=@pEDate
)

GO
if exists (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'List07_Det') AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) )
BEGIN
DROP FUNCTION List07_Det 
end
GO
CREATE FUNCTION List07_Det (@P_ANO as integer, @PSDate as SmallDateTime, @pEDAte as smallDateTime,@P_COB as varchar(10))  
RETURNS Table  
AS RETURN(  
    
SELECT Cast(0 as bit) as ProcessFlag,  
 Acceptance.CertificateNo,  
 Acceptance.ESeqNo,  
 Acceptance.AName,  
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
 RArrHeader,
 TOC  
Where  
 cover.CNO = acceptance.CNO  
 and RArrHeader.ANO=Acceptance.ANO  
 And Acceptance.ANO<>Acceptance.LANO  
 And Acceptance.LANO=@P_ANO  
 And ((Acceptance.AType='C' and Acceptance.AStatus='I' and Acceptance.PPDate between @PSdate and @pEDate)  
 or (Acceptance.AType<>'C' and Acceptance.AStatus='C' And Acceptance.CloseDate between @PSdate and @pEDate)  
 or (Acceptance.AType<>'C' and Acceptance.AStatus='I' and Acceptance.EDate between @PSdate and @pEDate))  
 And Cover.ISType<>'T'  
 And Acceptance.AdjustableF=1  
 And TOC.TOC=Acceptance.TOC  
 And TOC.COB=@P_COB  
)  

GO
if exists (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'List06_Det') AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) )
BEGIN
DROP FUNCTION List06_Det 
end
GO
CREATE FUNCTION List06_Det (@P_ANO as integer, @P_UserID as varchar(50), @pSDate as smalldatetime, @pEDate as smallDateTime, @pBranch as varchar(10), @pTOC as varchar(10), @pMO as varchar(10))      
RETURNS TABLE      
AS RETURN(      
      
SELECT Cast(0 as bit) as ProcessFlag,      
 Acceptance.CertificateNo,       
 Acceptance.ESeqNo,      
 Acceptance.AName,       
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
FROM       
 Acceptance,       
 Cover,       
 SysTab,
 RArrHeader
WHERE       
 Cover.CNO=Acceptance.CNO       
 and RArrHeader.ANO=Acceptance.ANO        
 And Acceptance.ANO<>Acceptance.LANO       
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
if exists (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'List05_Det') AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) )
BEGIN
DROP FUNCTION List05_Det
end 
GO
CREATE FUNCTION List05_Det (@P_ANO as integer, @P_UserID as varchar(50), @pSDate as smallDateTime, @pEDate as smallDateTime, @pBranch as varchar(10), @pTOC as varchar(10), @pMO as varchar(10))      
RETURNS Table      
AS RETURN(      
SELECT Cast(0 as bit) as ProcessFlag,      
 Acceptance.CertificateNo,      
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
 RARRHEADER      
Where      
 cover.CNO = acceptance.CNO      
 And Rarrheader.ANO = Acceptance.ANO             
 And Acceptance.ANO<>Acceptance.LANO      
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
if exists (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'List04_Det') AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) )
BEGIN
DROP FUNCTION List04_Det 
end
GO
CREATE   FUNCTION List04_Det (@P_ANO as integer,@P_UserID as varchar(255)) 
RETURNS TABLE 
AS RETURN( 
 
SELECT Cast(0 as bit) as ProcessFlag, 
Acceptance.CertificateNo, 
Acceptance.ESeqNo, 
Acceptance.AName, 
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

FROM 
Acceptance, 
Cover, 
SysTab,
RArrHeader
WHERE 
Cover.CNO=Acceptance.CNO 
and RArrHeader.ANO=Acceptance.ANO
And Acceptance.ANO<>Acceptance.LANO 
And Acceptance.LANO=@P_ANO 
And Acceptance.AStatus='W' 
And Cover.ISType<>'T' 
And Cover.CoverNoteF=1 
And Acceptance.LUserID Like @P_UserID 
) 
 
GO 
if exists (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'List03_Det') AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) )
BEGIN
DROP FUNCTION List03_Det 
end
GO
CREATE FUNCTION List03_Det (@P_ANO as integer, @P_USERID as varchar(255)) 
RETURNS TABLE 
AS RETURN( 
 
SELECT Cast(0 as bit) as ProcessFlag, 
Acceptance.CertificateNo, 
Acceptance.ESeqNo, 
Acceptance.AName, 
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
Year(RArrHeader.RDate) AS RYear, 
Acceptance.ValueID,
dbo.get_objectInfo(Acceptance.ANO) as ValueDesc,
Acceptance.BatchNo
FROM 
Acceptance, 
Cover, 
SysTab,
RArrHeader
WHERE 
Cover.CNO=Acceptance.CNO 
and RArrHeader.ANO=Acceptance.ANO
And Acceptance.ANO<>Acceptance.LANO 
And Acceptance.LANO=@P_ANO 
And Acceptance.AStatus Not in ('W','T') 
And Cover.ISType<>'T' 
And Acceptance.LUserID Like @P_UserID 
 
) 
 
 

GO
if exists (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'List02A_Det') AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) )
BEGIN
DROP FUNCTION List02A_Det
end 
GO
CREATE   FUNCTION List02A_Det (@P_ANO as integer,@P_UserID as varchar(255), @pEDate as smalldatetime) 
RETURNS TABLE 
AS RETURN( 
SELECT Cast(0 as bit) as ProcessFlag, 
Acceptance.CertificateNo, 
Acceptance.ESeqNo, 
Acceptance.AName, 
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

FROM 
Acceptance, 
Cover, 
SysTab,  
RArrHeader 
WHERE 
Cover.CNO=Acceptance.CNO 
and RArrHeader.ANO=Acceptance.ANO
And Acceptance.ANO<>Acceptance.LANO 
And Acceptance.LANO=@P_ANO 
And Acceptance.AStatus='W' 
And Cover.ISType<>'T' 
And Cover.CStatus='A' 
And Cover.CDate+Cover.Validation<=@pEDate 
And RArrHeader.FShare<>0 
And Acceptance.LUserID Like @P_UserID 
) 

GO
if exists (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'List02_Det') AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) )
BEGIN
DROP FUNCTION List02_Det 
end
GO
CREATE   FUNCTION List02_Det (@P_ANO as integer,@P_UserID as varchar(255), @pEDate as smalldatetime) 
RETURNS TABLE 
AS RETURN( 
SELECT Cast(0 as bit) as ProcessFlag, 
Acceptance.CertificateNo, 
Acceptance.ESeqNo, 
Acceptance.AName, 
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
FROM 
Acceptance, 
Cover, 
SysTab,
RArrHeader
WHERE 
Cover.CNO=Acceptance.CNO 
and RArrHeader.ANO=Acceptance.ANO
And Acceptance.ANO<>Acceptance.LANO 
And Acceptance.LANO=@P_ANO 
And Acceptance.AStatus='W' 
And Cover.ISType<>'T' 
And Cover.CStatus='A' 
And Cover.CDate+Cover.Validation<=@pEDate 
And Acceptance.LUserID like @P_UserID 
) 
 
 
GO
if exists (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'List01_Det') AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) )
BEGIN
DROP FUNCTION List01_Det
end 
GO
CREATE  FUNCTION List01_Det (@P_ANO AS INTEGER, @P_UserID as varchar(255)) 
RETURNS TABLE 
AS RETURN( 
SELECT Cast(0 as bit) as ProcessFlag, 
Acceptance.CertificateNo, 
Acceptance.ESeqNo, 
Acceptance.AName, 
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
FROM Acceptance, Cover, SysTab, RArrHeader
WHERE 
Cover.CNO=Acceptance.CNO 
and RArrHeader.ANO=Acceptance.ANO
And Acceptance.ANO<>Acceptance.LANO 
And Acceptance.LANO=@P_ANO 
And Acceptance.AStatus='W' 
And Cover.ISType<>'T' 
And Cover.CStatus='A' 
And Acceptance.LuserID Like @P_UserID 
) 
 
 
GO

if exists (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'List_Spc_03_Det') AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) )
BEGIN
DROP FUNCTION List_Spc_03_Det 
end
GO
CREATE  FUNCTION List_Spc_03_Det (@P_ANO AS INTEGER)   
RETURNS TABLE  
AS RETURN(  
SELECT Cast(0 as bit) as ProcessFlag,  
 Acceptance.CertificateNo,   
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
FROM Acceptance, Cover, SysTab,  RArrHeader  
WHERE   
 Cover.CNO=Acceptance.CNO   
 and RArrHeader.ANO=Acceptance.ANO    
 And Acceptance.ANO<>Acceptance.LANO   
 And Acceptance.LANO=@P_ANO  
 And Acceptance.AStatus in ('I','W') and Acceptance.AType<>'C'  
 And RArrHeader.FAmount=0  
)  
   


GO
if exists (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'List_Spc_02_Det') AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) )
BEGIN
DROP FUNCTION List_Spc_02_Det
end 
GO
CREATE  FUNCTION List_Spc_02_Det (@P_ANO AS INTEGER) 
RETURNS TABLE
AS RETURN(
SELECT Cast(0 as bit) as ProcessFlag,
	Acceptance.CertificateNo, 
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
FROM Acceptance, Cover, SysTab,  RArrHeader
WHERE 
	Cover.CNO=Acceptance.CNO 
	and RArrHeader.ANO=Acceptance.ANO	 
	And Acceptance.ANO<>Acceptance.LANO 
	And Acceptance.LANO=@P_ANO
	And Acceptance.AStatus='I' and Acceptance.AType<>'C'
	And not exists (SELECT ANO from Classified_Object() C Where C.ANO=Acceptance.ANO)
	And RArrHeader.TreatyF=1 and (RArrHeader.CAmount<>0 or RArrHeader.DAmount<>0 or RArrHeader.QAmount<>0 or RArrHeader.SP1Amount<>0 or RArrHeader.SP2Amount<>0 or RArrHeader.SP3Amount<>0 or RArrHeader.XPAmount<>0 or RArrHeader.AAmount<>0)
)

GO
if exists (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'List_Spc_01_Det') AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) )
BEGIN
DROP FUNCTION List_Spc_01_Det 
end
GO
CREATE  FUNCTION List_Spc_01_Det (@P_ANO AS INTEGER) 
RETURNS TABLE
AS RETURN(
SELECT Cast(0 as bit) as ProcessFlag,
	Acceptance.CertificateNo, 
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
FROM Acceptance, Cover, SysTab,  RArrHeader
WHERE 
	Cover.CNO=Acceptance.CNO 
    and RArrHeader.ANO=Acceptance.ANO	 
	And Acceptance.ANO<>Acceptance.LANO 
	And Acceptance.LANO=@P_ANO
	And Acceptance.AStatus='I' and Acceptance.AType<>'C'
	And Cover.ISType not in ('C','L','I','T')
	And RArrHeader.TreatyF=1 and (RArrHeader.CAmount<>0 or RArrHeader.DAmount<>0 or RArrHeader.QAmount<>0 or RArrHeader.SP1Amount<>0 or RArrHeader.SP2Amount<>0 or RArrHeader.SP3Amount<>0 or RArrHeader.XPAmount<>0 or RArrHeader.AAmount<>0)
)

GO
if exists (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'List_By_Ano_Det') AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) )
BEGIN
DROP FUNCTION List_By_Ano_Det
end
GO
CREATE  FUNCTION List_By_Ano_Det (@P_ANO AS INTEGER,@P_CANO AS INTEGER) 
RETURNS TABLE
AS RETURN(
SELECT Cast(0 as bit) as ProcessFlag,
	Acceptance.CertificateNo, 
	Acceptance.ESeqNo,
	Acceptance.AName, 
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
FROM Acceptance, RArrHeader, Cover, SysTab
WHERE 
	Cover.CNO=Acceptance.CNO 
	and RArrHeader.ANO=Acceptance.ANO	 
	And Acceptance.ANO<>Acceptance.LANO 
	And Acceptance.LANO=@P_ANO
	And Acceptance.ANO=@P_CANO
)




go


  insert into PatchVersioning
select '54.21 Update Script - Patch ListDet BatchNo',GETDATE()
go

Declare @PrevScript varchar(100)
Declare @CurrScript varchar(100)

Select @PrevScript='54.20 Update Script - Patch 2019 (26) QCheckObjectInsured_Upload'
Select @CurrSCript='54.21 Update Script - Patch ListDet BatchNo'


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




