IF EXISTS ( SELECT * FROM   sysobjects WHERE  id = object_id(N'SList01') and OBJECTPROPERTY(id, N'IsProcedure') = 1 )
BEGIN
DROP PROCEDURE [dbo].[SList01]
END
GO
CREATE PROCEDURE [dbo].[SList01] (@P_UserID as Varchar(50)) 
AS 
SELECT Cast(0 as bit) as ProcessFlag, Service.* 
From Service 
WHERE Service.SStatus='R' and Service.LUserID Like @P_UserID 
go
if exists (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'ListDet05_a') AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) )
BEGIN
DROP function ListDet05_a 
END
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
END
GO
CREATE function ListDet05_b (@P_ANO as integer,     
@Value1 as varchar(255), @Value2 as varchar(255), @Value3 as varchar(255), @Value4 as varchar(255), @Value5 as varchar(255),     
@Value6 varchar(255), @Value7 as varchar(255), @Value8 as varchar(255), @Value9 as varchar(255), @Value10 as varchar(255),    
@Value11 as varchar(255),@Value12 as varchar(255), @Value13 as varchar(255),@Value14 as varchar(255),@Value15 as varchar(255),    
@Value16 as varchar(255),@Value17 as varchar(255),@Value18 as varchar(255),@Value19 as varchar(255),@Value20 as varchar(255),@Value21 as varchar(255), @Value22 as varchar(255), @Value23 as varchar(255), @Value24 as varchar(255)
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
FROM ListDet05_a (@P_ANO, @Value1, @Value2, @Value3, @Value4, @Value5, @Value6, @Value7, @Value8, @Value9, @Value10,@Value11, @Value12, @Value13,@Value14,@Value15,@Value16,@Value17,@Value18,@Value19, @Value20, @Value21, @Value22, @Value23,@Value24) q
Left Join ainfo a on (a.ANO=q.ANO)
Left Join Ainfo_Ext b on (b.ANO=q.ANO)
)      

GO
if exists (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'ListDet05_c') AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) )
BEGIN
DROP function ListDet05_c
END
GO
CREATE function ListDet05_c (@P_ANO as integer,     
@Value1 as varchar(255), @Value2 as varchar(255), @Value3 as varchar(255), @Value4 as varchar(255), @Value5 as varchar(255),     
@Value6 varchar(255), @Value7 as varchar(255), @Value8 as varchar(255), @Value9 as varchar(255), @Value10 as varchar(255),    
@Value11 as varchar(255),@Value12 as varchar(255), @Value13 as varchar(255),@Value14 as varchar(255),@Value15 as varchar(255),    
@Value16 as varchar(255),@Value17 as varchar(255),@Value18 as varchar(255),@Value19 as varchar(255),@Value20 as varchar(255),@Value21 as varchar(255), @Value22 as varchar(255), @Value23 as varchar(255), @Value24 as varchar(255), @Value25 as varchar(255)
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
FROM ListDet05_a (@P_ANO, @Value1, @Value2, @Value3, @Value4, @Value5, @Value6, @Value7, @Value8, @Value9, @Value10,@Value11, @Value12, @Value13,@Value14,@Value15,@Value16,@Value17,@Value18,@Value19, @Value20, @Value21, @Value22, @Value23,@Value24) q
Left Join ainfo a on (a.ANO=q.ANO)
Left Join Ainfo_Ext b on (b.ANO=q.ANO)
Where '|'+VALUEID1+'|'+VALUEDESC1+'|'+VALUEID2+'|'+VALUEDESC2+'|'+VALUEID3+'|'+VALUEDESC3+'|'+VALUEID4+'|'+VALUEDESC4+'|'+VALUEID5+'|'+VALUEDESC5+'|'+VALUEID6+'|'+VALUEDESC6+'|'+VALUEID7+'|'+VALUEDESC7+'|'+VALUEID8+'|'+VALUEDESC8+'|'+VALUEID9+'|'+VALUEDESC9+'|'+VALUEID10+'|'+VALUEDESC10+'|'+VALUEID11+'|'+VALUEDESC11+'|'+VALUEID12+'|'+VALUEDESC12+'|'+VALUEID13+'|'+VALUEDESC13+'|'+VALUEID14+'|'+VALUEDESC14+'|'+VALUEID15+'|'+VALUEDESC15 LIKE '|%'+@Value25+'%' 
)      


GO

if exists (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'MListQry_3') AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) )
BEGIN
DROP function MListQry_3
END
GO
CREATE function MListQry_3 (@value1 as varchar(255) ,@value2 as varchar(255) ,@value3 as varchar(255) ,@value4 as varchar(255) ,@value5 as varchar(255) ,@value6 as varchar(255) ,@value7 as varchar(255) ,@value8 as varchar(255) ,@value9 as varchar(255),@Value10 as varchar(255), @Value11 as varchar(255), @Value12 as varchar(255), @Value13 as varchar(255))   
RETURNS Table   
AS return   
(   
SELECT   
Cast(0 as bit) as ProcessFlag,   
Cover.COVERNO,   
Cover.Insured,   
Cover.CNO,   
Cover.CStatus,   
Cover.VSeqNo,   
Acceptance.lANO,   
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
Year(Coalesce(RArrHeader.RDate,Acceptance.SDate)) AS RYear,   
Cover.ISType,   
Acceptance.Renewal,   
Acceptance.ESeqNo,   
Acceptance.PolicyNo,   
acceptance.ano as ano_info   
FROM  Acceptance 
Inner Join Cover on (Cover.CNO=Acceptance.CNO)
Left Join RArrHeader on (RArrHeader.ANO=Acceptance.ANO)
Inner Join Profile on (Profile.ID=Cover.PHolder), SysTab
Where (Acceptance.AName Like @Value1)   
And (Cover.CoverNo Like @Value2 Or (Cover.CoverNo is null))   
and (Cover.CoverDate = @Value3 Or (Cover.CoverDate is null) or @Value3 = '')   
And (Cover.ExpDate = @Value4 Or (Cover.ExpDate is null) or @Value4 = '')   
And (Acceptance.PolicyNo Like @Value5 Or (Acceptance.PolicyNo is null))   
And (Acceptance.CertificateNo Like @Value6 Or (Acceptance.CertificateNo is null))   
and (Acceptance.PolicyDate = @Value7 Or (Acceptance.PolicyDate is null) or @Value7 = '')   
And (Cover.CStatus Like @Value8)   
And (Acceptance.RegNo Like @Value9)   
And (Profile.Name Like @Value10 or Profile.ID is null)   
and Acceptance.toc like @Value11   
And (Acceptance.RefNo Like @Value13)   
And (Acceptance.LANO = -1)   
And Cover.ISType<>'T'   
   
Union All   
   
SELECT   
Cast(0 as bit) as ProcessFlag,   
Cover.COVERNO,   
Cover.Insured,   
Cover.CNO,   
Cover.CStatus,   
Cover.VSeqNo,   
Acceptance.lANO,   
Acceptance.ANO,   
Acceptance.REGNO,   
Acceptance.ADATE,   
Acceptance.USERID,   
SysTab.Currency,   
0 as TSI,   
0 as OurShare,   
0 as Gross,   
Acceptance.ASTATUS,   
Acceptance.ATYPE,   
Acceptance.SDate,   
Acceptance.EDate,   
Year(Coalesce(RArrHeader.RDate,Acceptance.SDate)) AS RYear,   
Cover.ISType,   
Acceptance.Renewal,   
Acceptance.ESeqNo,   
Acceptance.PolicyNo,   
acceptance_detail.ano as ano_info   
FROM  
acceptance as acceptance_detail   
Inner Join Acceptance on (Acceptance.ANO=Acceptance_Detail.LANO)
Inner Join Cover on (Cover.CNO=Acceptance.CNO)
Left Join RArrHeader on (RArrHeader.ANO=Acceptance.ANO)
Inner Join Profile on (Profile.ID=Cover.PHolder), SysTab
Where (Acceptance_Detail.AName Like @Value1)   
And (Cover.CoverNo Like @Value2 Or (Cover.CoverNo is null))   
and (Cover.CoverDate = @Value3 Or (Cover.CoverDate is null) or @Value3 = '')   
And (Cover.ExpDate = @Value4 Or (Cover.ExpDate is null) or @Value4 = '')   
And (Acceptance_Detail.PolicyNo Like @Value5 Or (Acceptance_Detail.PolicyNo is null))   
And (Acceptance_Detail.CertificateNo Like @Value6 Or (Acceptance_Detail.CertificateNo is null))   
and (Acceptance_Detail.PolicyDate = @Value7 Or (Acceptance_Detail.PolicyDate is null) or @Value7 = '')   
And (Cover.CStatus Like @Value8)   
And (Acceptance_Detail.RegNo Like @Value9)   
And (Profile.Name Like @Value10 or Profile.ID is null)   
and Acceptance_Detail.toc like @Value11   
And (Acceptance_Detail.RefNo Like @Value13)   
And (Acceptance_detail.ANO <> Acceptance_detail.LANO and Acceptance_detail.LANO <> -1)   
And Cover.ISType<>'T'   
)   
   
GO
if exists (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'MList11D') AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) )
BEGIN
DROP function MList11D
END
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
 Cover.CNO,   
 Cover.CStatus,   
 Cover.VSeqNo,   
 Acceptance.LANO,   
 Acceptance.ANO,   
 Acceptance.REGNO,   
 Acceptance.ADATE,   
 Acceptance.USERID,   
 SysTab.Currency,   
 QPCalc.TSI,   
 QPCalc.OurShare,   
 QPCalc.Gross,   
 Acceptance.ASTATUS,   
 Acceptance.ATYPE,   
 Acceptance.SDate,   
 Acceptance.EDate,   
 Year(RArrheader.Rdate) AS RYear  
FROM   
 Acceptance,   
 Cover,   
 RArrHeader,   
 SysTab,   
 QMasterAcceptance_PCalc() AS QPCalc,  
 Profile  
WHERE   
 Cover.CNO=Acceptance.CNO   
 And RArrHeader.ANO=Acceptance.ANO   
 And QPCalc.ANO=Acceptance.ANO   
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
 and cover.toc like @Value11  
 And (Acceptance.RefNo Like @Value13)   
 And Cover.ISType<>'T'  
)  
  
GO
if exists (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'MList11E') AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) )
BEGIN
DROP function MList11E
END
GO
create function MList11E(@P_ANO AS INTEGER, @value1 as varchar(255) ,@value2 as varchar(255) ,@value3 as varchar(255) ,@value4 as varchar(255) ,@value5 as varchar(255) ,@value6 as varchar(255) ,@Value7 as varchar(255) ,@value8 as varchar(255) ,@value9 as 
varchar(255),@Value10 as varchar(255), @Value11 as varchar(255), @Value12 as varchar(255), @Value13 as varchar(255))  
returns table  
AS return  
(  
SELECT   
 Cast(0 as bit) as ProcessFlag,   
 Q.COVERNO,   
 Q.AName,   
 Q.CertificateNo,   
 Q.CNO,   
 Q.CStatus,   
 Q.VSeqNo,   
 Q.LANO,   
 Q.ANO,   
 Q.REGNO,   
 Q.ADATE,   
 Q.USERID,   
 Q.Currency,   
 Q.TSI,   
 Q.OurShare,   
 Q.Gross,   
 Q.ASTATUS,   
 Q.ATYPE,   
 Q.SDate,   
 Q.EDate,   
 Q.RYear,  
 A.VALUEID1, A.VALUEDESC1,  
 A.VALUEID2, A.VALUEDESC2,  
 A.VALUEID3, A.VALUEDESC3,  
 A.VALUEID4, A.VALUEDESC4,  
 A.VALUEID5, A.VALUEDESC5,  
 A.VALUEID6, A.VALUEDESC6,  
 A.VALUEID7, A.VALUEDESC7,  
 A.VALUEID8, A.VALUEDESC8,  
 A.VALUEID9, A.VALUEDESC9,  
 A.VALUEID10, A.VALUEDESC10,  
 A.VALUEID11, A.VALUEDESC11,  
 A.VALUEID12, A.VALUEDESC12,  
 A.VALUEID13, A.VALUEDESC13,  
 A.VALUEID14, A.VALUEDESC14,  
 A.VALUEID15, A.VALUEDESC15,
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
FROM MList11D(@P_ANO, @value1, @value2, @value3, @value4, @value5, @value6, @Value7, @value8, @value9, @Value10, @Value11, @Value12, @Value13) q
Left Join ainfo a on (a.ANO=q.ANO)
Left Join Ainfo_Ext b on (b.ANO=q.ANO) 
)  
  
GO
if exists (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'MList11F') AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) )
BEGIN  
DROP function MList11F
END
GO
create function MList11F(@P_ANO AS INTEGER, @value1 as varchar(255) ,@value2 as varchar(255) ,@value3 as varchar(255) ,@value4 as varchar(255) ,@value5 as varchar(255) ,@value6 as varchar(255) ,@Value7 as varchar(255) ,@value8 as varchar(255) ,@value9 as 
varchar(255),@Value10 as varchar(255), @Value11 as varchar(255), @Value12 as varchar(255), @Value13 as varchar(255), @Value14 as varchar(255))  
returns table  
AS return  
(  
SELECT   
 Cast(0 as bit) as ProcessFlag,   
 Q.COVERNO,   
 Q.AName,   
 Q.CertificateNo,   
 Q.CNO,   
 Q.CStatus,   
 Q.VSeqNo,   
 Q.LANO,   
 Q.ANO,   
 Q.REGNO,   
 Q.ADATE,   
 Q.USERID,   
 Q.Currency,   
 Q.TSI,   
 Q.OurShare,   
 Q.Gross,   
 Q.ASTATUS,   
 Q.ATYPE,   
 Q.SDate,   
 Q.EDate,   
 Q.RYear,  
 A.VALUEID1, A.VALUEDESC1,  
 A.VALUEID2, A.VALUEDESC2,  
 A.VALUEID3, A.VALUEDESC3,  
 A.VALUEID4, A.VALUEDESC4,  
 A.VALUEID5, A.VALUEDESC5,  
 A.VALUEID6, A.VALUEDESC6,  
 A.VALUEID7, A.VALUEDESC7,  
 A.VALUEID8, A.VALUEDESC8,  
 A.VALUEID9, A.VALUEDESC9,  
 A.VALUEID10, A.VALUEDESC10,  
 A.VALUEID11, A.VALUEDESC11,  
 A.VALUEID12, A.VALUEDESC12,  
 A.VALUEID13, A.VALUEDESC13,  
 A.VALUEID14, A.VALUEDESC14,  
 A.VALUEID15, A.VALUEDESC15,
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
FROM MList11D(@P_ANO, @value1, @value2, @value3, @value4, @value5, @value6, @Value7, @value8, @value9, @Value10, @Value11, @Value12, @Value13) q
Left Join ainfo a on (a.ANO=q.ANO)
Left Join Ainfo_Ext b on (b.ANO=q.ANO) 
Where '|'+VALUEID1+'|'+VALUEDESC1+'|'+VALUEID2+'|'+VALUEDESC2+'|'+VALUEID3+'|'+VALUEDESC3+'|'+VALUEID4+'|'+VALUEDESC4+'|'+VALUEID5+'|'+VALUEDESC5+'|'+VALUEID6+'|'+VALUEDESC6+'|'+VALUEID7+'|'+VALUEDESC7+'|'+VALUEID8+'|'+VALUEDESC8+'|'+VALUEID9+'|'+VALUEDESC9+'|'+VALUEID10+'|'+VALUEDESC10+'|'+VALUEID11+'|'+VALUEDESC11+'|'+VALUEID12+'|'+VALUEDESC12+'|'+VALUEID13+'|'+VALUEDESC13+'|'+VALUEID14+'|'+VALUEDESC14+'|'+VALUEID15+'|'+VALUEDESC15 LIKE '|%'+@Value14+'%' 
)  
  
  GO
  
insert into PatchVersioning
select '55.44 Update Patch - Patch 2020 (47)',GETDATE()
go


Declare @PrevScript varchar(100)
Declare @CurrScript varchar(100)

Select @PrevScript='55.43 Update Script - Patch 2020 (45)'
Select @CurrSCript='55.44 Update Patch - Patch 2020 (47)'


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



  
  
  
  
  
  
  
  
  
  
  
  
  
    
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
                                              

