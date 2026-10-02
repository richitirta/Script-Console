if exists (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'ListQry_3b') AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) )
BEGIN
DROP function ListQry_3b
END
GO
CREATE function ListQry_3b (            
@Value1 as varchar(255), @Value2 as varchar(255), @Value3 as varchar(255), @Value4 as varchar(255), @Value5 as varchar(255),             
@Value6 varchar(255), @Value7 as varchar(255), @Value8 as varchar(255), @Value9 as varchar(255), @Value10 as varchar(255),            
@Value11 as varchar(255),@Value12 as varchar(255), @Value13 as varchar(255),@Value14 as varchar(255),@Value15 as varchar(255),            
@Value16 as varchar(255),@Value17 as varchar(255),@Value18 as varchar(255),@Value19 as varchar(255),@Value20 as varchar(255),@Value21 as varchar(255), @Value22 as varchar(255), @Value23 as varchar(255), @Value24 as varchar(255)            
)                  
RETURNS Table                  
AS RETURN                  
(                  
SELECT       
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
 Acceptance.RefNo,                  
 cover.ProformaF    
FROM  Acceptance
Inner Join Cover on (Cover.CNO=Acceptance.CNO)
Left Join RArrHeader on (RArrHeader.ANO=Acceptance.ANO)
Inner Join Profile on (Profile.ID=Cover.PHolder), systab    
Where (@Value1='%' or Acceptance.AName Like @Value1)                
 And (@Value2='%' or Cover.CoverNo Like @Value2)                  
 and (Cover.CoverDate = @Value3 or @Value3='')                  
 And (Cover.ExpDate = @Value4 or @Value4='')                  
 And (@Value5='%' or Acceptance.PolicyNo Like @Value5)                  
 And (@Value6='%' or Acceptance.CertificateNo Like @Value6)                  
 And (Acceptance.PolicyDate = @Value7 or @Value7='' or Acceptance.PolicyDate Between @Value7 and @Value16)                  
 And (Acceptance.RegDate = @Value17 or @Value17='' or Acceptance.RegDate Between @Value17 and @Value18)                  
 And Acceptance.AType Like @Value8                  
 And Acceptance.AStatus Like @Value9                  
 And (@Value10='%' or Acceptance.RegNo Like @Value10)    
 And (@Value11='%' or Profile.Name Like @Value11)    
 and (@Value12='%' or Acceptance.toc like @Value12)    
 and (@Value13='%' or Acceptance.RefNo like @Value13)                  
 and (acceptance.ano = acceptance.lano or acceptance.lano = -1)                  
 and (Acceptance.Matters=@Value14 or @Value14='')                  
 And (Cover.ISType<>'T' or Cover.ProformaF=1)                  
 And (Acceptance.BatchNo Like @Value19)             
 And ((Acceptance.BackDatedF=1 and @Value20='1') or @Value20='')            
 And (@Value21<>'1' or (@Value21='1' and Exists (Select CAcceptance.CANO from Acceptance CAcceptance Where CAcceptance.CANO=Acceptance.ANO)))              
 And ((Cover.TBAF=1 and @Value22='1') or @Value22='')            
 And (@Value23<>'1' or (@Value23='1' and Not Exists (Select Top 1 ANO from PPrintLog Where PPrintLog.ANO=Acceptance.ANO)))               
 And (@Value24='%' or Acceptance.ASource Like @Value24)
             
 Union All
             
 SELECT       
 CCover.COVERNO,                  
 Cast(CAcceptance.AName as varchar(128)) as Insured,                  
 CCover.CNO,                  
 CCover.CStatus,                  
 CAcceptance.lANO,                  
 CAcceptance.ANO,                  
 CAcceptance.REGNO,                  
 CAcceptance.ADATE,                  
 CAcceptance.LUSERID as USERID,                  
 SysTab.Currency,                  
 CAcceptance.ASTATUS,       
 CAcceptance.ATYPE,                  
 CAcceptance.SDate,                  
 CAcceptance.EDate,                  
 Year(Coalesce(CRArrHeader.RDate,CAcceptance.SDate)) AS RYear,                  
 CCover.ISType,                  
 CAcceptance.Renewal,                  
 CAcceptance.ESeqNo,                  
 CAcceptance.PolicyNo,                  
 CAcceptance.CertificateNo,                  
 CAcceptance.RefNo,              
 Ccover.ProformaF    
FROM  Acceptance
Inner Join Cover on (Cover.CNO=Acceptance.CNO)
Inner Join Acceptance CAcceptance on (CAcceptance.CANO=Acceptance.ANO)
Inner Join Cover CCover on (CCOver.CNO=CAcceptance.CNO)
left Join RArrHeader CRArrHeader on (CRArrHeader.ANO=CAcceptance.ANO)     
Inner Join Profile on (Profile.ID=Cover.PHolder), SysTab
Where @Value21='1' 
 And (@Value1='%' or Acceptance.AName Like @Value1)                
 And (@Value2='%' or Cover.CoverNo Like @Value2)                  
 and (Cover.CoverDate = @Value3 or @Value3='')                  
 And (Cover.ExpDate = @Value4 or @Value4='')                  
 And (@Value5='%' or Acceptance.PolicyNo Like @Value5)                  
 And (@Value6='%' or Acceptance.CertificateNo Like @Value6)                  
 And (Acceptance.PolicyDate = @Value7 or @Value7='' or Acceptance.PolicyDate Between @Value7 and @Value16)                  
 And (Acceptance.RegDate = @Value17 or @Value17='' or Acceptance.RegDate Between @Value17 and @Value18)                  
 And Acceptance.AType Like @Value8                  
 And Acceptance.AStatus Like @Value9                  
 And (@Value10='%' or Acceptance.RegNo Like @Value10)    
 And (@Value11='%' or Profile.Name Like @Value11)    
 and (@Value12='%' or Acceptance.toc like @Value12)    
 and (@Value13='%' or Acceptance.RefNo like @Value13)                  
 and (acceptance.ano = acceptance.lano or acceptance.lano = -1)                  
 and (Acceptance.Matters=@Value14 or @Value14='')                  
 And (Cover.ISType<>'T' or Cover.ProformaF=1)                  
 And (Acceptance.BatchNo Like @Value19)             
 And ((Acceptance.BackDatedF=1 and @Value20='1') or @Value20='')            
 And ((Cover.TBAF=1 and @Value22='1') or @Value22='')            
 And (@Value23<>'1' or (@Value23='1' and Not Exists (Select Top 1 ANO from PPrintLog Where PPrintLog.ANO=Acceptance.ANO)))              
 And (@Value24='%' or Acceptance.ASource Like @Value24)
)


GO
if exists (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'ListQry_3b_a') AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) )
BEGIN
DROP function ListQry_3b_a
END
GO
CREATE function ListQry_3b_a (  
@Value1 as varchar(255), @Value2 as varchar(255), @Value3 as varchar(255), @Value4 as varchar(255), @Value5 as varchar(255),   
@Value6 varchar(255), @Value7 as varchar(255), @Value8 as varchar(255), @Value9 as varchar(255), @Value10 as varchar(255),  
@Value11 as varchar(255),@Value12 as varchar(255), @Value13 as varchar(255),@Value14 as varchar(255),@Value15 as varchar(255),  
@Value16 as varchar(255),@Value17 as varchar(255),@Value18 as varchar(255),@Value19 as varchar(255),@Value20 as varchar(255),
@Value21 as varchar(255), @Value22 as varchar(255), @Value23 as varchar(255), @Value24 as varchar(255)    
)        
RETURNS Table    
AS RETURN    
(    
SELECT Cast(0 as bit) as ProcessFlag,    
 [q].[COVERNO],    
 [q].[Insured],    
 [q].[CNO],    
 [q].[CStatus],    
 [q].[lANO],    
 [q].[ANO],    
 [q].[REGNO],    
 [q].[ADATE],    
 [q].[USERID],    
 [q].[Currency],     
 [q].[ASTATUS],    
 [q].[ATYPE],    
 [q].[SDate],    
 [q].[EDate],    
 [q].RYear,    
 [q].[ISType],    
 [q].[Renewal],    
 [q].[ESeqNo],    
 [q].[PolicyNo],    
 [q].[CertificateNo],    
 [q].[RefNo],    
 [q].[ProformaF],    
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
FROM  ListQry_3b (@Value1, @Value2, @Value3, @Value4, @Value5, @Value6, @Value7, @Value8, @Value9, @Value10,@Value11, @Value12, @Value13,@Value14,@Value15,@Value16,@Value17,@Value18,@Value19,@Value20,@Value21, @Value22, @Value23, @Value24) q
Inner Join AInfo A on (a.ANO=q.ANO)
Left Join Ainfo_Ext b on (b.ANO=a.ANO)            
)    

GO
if exists (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'ListQry_3b_b') AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) )
BEGIN
DROP function ListQry_3b_b
END
GO
CREATE function ListQry_3b_b (  
@Value1 as varchar(255), @Value2 as varchar(255), @Value3 as varchar(255), @Value4 as varchar(255), @Value5 as varchar(255),   
@Value6 varchar(255), @Value7 as varchar(255), @Value8 as varchar(255), @Value9 as varchar(255), @Value10 as varchar(255),  
@Value11 as varchar(255),@Value12 as varchar(255), @Value13 as varchar(255),@Value14 as varchar(255),@Value15 as varchar(255),  
@Value16 as varchar(255),@Value17 as varchar(255),@Value18 as varchar(255),@Value19 as varchar(255),@Value20 as varchar(255),
@Value21 as varchar(255), @Value22 as varchar(255), @Value23 as varchar(255), @Value24 as varchar(255), @Value25 as varchar(255)    
)        
RETURNS Table    
AS RETURN    
(    
SELECT Cast(0 as bit) as ProcessFlag,    
 [q].[COVERNO],    
 [q].[Insured],    
 [q].[CNO],    
 [q].[CStatus],    
 [q].[lANO],    
 [q].[ANO],    
 [q].[REGNO],    
 [q].[ADATE],    
 [q].[USERID],    
 [q].[Currency],     
 [q].[ASTATUS],    
 [q].[ATYPE],    
 [q].[SDate],    
 [q].[EDate],    
 [q].RYear,    
 [q].[ISType],    
 [q].[Renewal],    
 [q].[ESeqNo],    
 [q].[PolicyNo],    
 [q].[CertificateNo],    
 [q].[RefNo],    
 [q].[ProformaF],    
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
FROM  ListQry_3b (@Value1, @Value2, @Value3, @Value4, @Value5, @Value6, @Value7, @Value8, @Value9, @Value10,@Value11, @Value12, @Value13,@Value14,@Value15,@Value16,@Value17,@Value18,@Value19,@Value20,@Value21, @Value22, @Value23, @Value24) q
Inner Join AInfo A on (a.ANO=q.ANO)
Left Join Ainfo_Ext b on (b.ANO=a.ANO)            
Where '|'+VALUEID1+'|'+VALUEDESC1+'|'+VALUEID2+'|'+VALUEDESC2+'|'+VALUEID3+'|'+VALUEDESC3+'|'+VALUEID4+'|'+VALUEDESC4+'|'+VALUEID5+'|'+VALUEDESC5+'|'+VALUEID6+'|'+VALUEDESC6+'|'+VALUEID7+'|'+VALUEDESC7+'|'+VALUEID8+'|'+VALUEDESC8+'|'+VALUEID9+'|'+VALUEDESC9+'|'+VALUEID10+'|'+VALUEDESC10+'|'+VALUEID11+'|'+VALUEDESC11+'|'+VALUEID12+'|'+VALUEDESC12+'|'+VALUEID13+'|'+VALUEDESC13+'|'+VALUEID14+'|'+VALUEDESC14+'|'+VALUEID15+'|'+VALUEDESC15 LIKE '|%'+@Value25+'%'
)    


GO
if exists (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'ListQry_3') AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) )
BEGIN
DROP function ListQry_3
END
GO
CREATE function ListQry_3 (        
@Value1 as varchar(255), @Value2 as varchar(255), @Value3 as varchar(255), @Value4 as varchar(255), @Value5 as varchar(255),         
@Value6 varchar(255), @Value7 as varchar(255), @Value8 as varchar(255), @Value9 as varchar(255), @Value10 as varchar(255),        
@Value11 as varchar(255),@Value12 as varchar(255), @Value13 as varchar(255),@Value14 as varchar(255),@Value15 as varchar(255),        
@Value16 as varchar(255),@Value17 as varchar(255),@Value18 as varchar(255),@Value19 as varchar(255),@Value20 as varchar(255),@Value21 as varchar(255), @Value22 as varchar(255), @Value23 as varchar(255), @Value24 as varchar(255)        
)              
RETURNS Table              
AS RETURN              
(              
SELECT     
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
 Acceptance.RefNo,              
 Cover.ProformaF,              
 Acceptance.ANO as ANO_INFO   
FROM  Acceptance
Inner Join Cover on (Cover.CNO=Acceptance.CNO)
left Join RArrHeader on (RArrHeader.ANO=Acceptance.ANO)
Inner Join Profile on (Profile.ID=Cover.PHolder), systab    
WHERE  (@Value1='%' or Acceptance.AName Like @Value1)             
 And (@Value2='%' or Cover.CoverNo Like @Value2)              
 And (Cover.CoverDate = @Value3 or @Value3='')              
 And (Cover.ExpDate = @Value4 or @Value4='')              
 And (@Value5='%' or Acceptance.PolicyNo Like @Value5)              
 And (@Value6='%' or Acceptance.CertificateNo Like @Value6)              
 And (Acceptance.PolicyDate = @Value7 or @Value7='' or Acceptance.PolicyDate Between @Value7 and @Value16)              
 And (Acceptance.RegDate = @Value17 or @Value17='' or Acceptance.RegDate Between @Value17 and @Value18)              
 And Acceptance.AType Like @Value8              
 And Acceptance.AStatus Like @Value9              
 And (@Value10='%' or Acceptance.RegNo Like @Value10)  
 And (@Value11='%' or Profile.Name Like @Value11)             
 and (@Value12='%' or Acceptance.toc like @Value12)              
 and (@Value13='%' or acceptance.refno like @Value13)              
 and (Acceptance.ano = acceptance.lano or Acceptance.LANO=-1)              
 and (Acceptance.Matters=@Value14 or @Value14='')              
 And (Cover.ISType<>'T' or Cover.ProformaF=1)              
 And (Acceptance.BatchNo Like @Value19)         
 And ((Acceptance.BackDatedF=1 and @Value20='1') or @Value20='')        
 And (@Value21<>'1' or (@Value21='1' and Exists (Select CAcceptance.CANO from Acceptance CAcceptance Where CAcceptance.CANO=Acceptance.ANO)))            
 And ((Cover.TBAF=1 and @Value22='1') or @Value22='')        
 And (@Value23<>'1' or (@Value23='1' and Not Exists (Select Top 1 ANO from PPrintLog Where PPrintLog.ANO=Acceptance.ANO)))            
 And (@Value24='%' or Acceptance.ASource Like @Value24)
        
Union all
        
SELECT     
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
 Acceptance.RefNo,              
 Cover.ProformaF,              
 acceptance_detail.ANO as ANO_INFO  
FROM  Acceptance acceptance_detail
Inner Join Acceptance on (Acceptance.ANO=Acceptance_Detail.LANO)
Inner Join Cover on (Cover.CNO=Acceptance.CNO)
left Join RArrHeader on (RArrHeader.ANO=Acceptance.ANO)
Inner Join Profile on (Profile.ID=Cover.PHolder), systab    
Where (@Value1='%' or Acceptance_Detail.AName Like @Value1)            
 And (@Value2='%' or Cover.CoverNo Like @Value2)             
 and (Cover.CoverDate = @Value3 or @Value3='')              
 And (Cover.ExpDate = @Value4 or @Value4='')              
 And (@Value5='%' or Acceptance_Detail.PolicyNo Like @Value5)              
 And (@Value6='%' or Acceptance_Detail.CertificateNo Like @Value6)              
 And (Acceptance_Detail.PolicyDate = @Value7 or @Value7='' or Acceptance_Detail.PolicyDate Between @Value7 and @Value16)              
 And (Acceptance_Detail.RegDate = @Value17 or @Value17='' or Acceptance_Detail.RegDate Between @Value17 and @Value18)              
 And Acceptance_Detail.AType Like @Value8              
 And Acceptance_Detail.AStatus Like @Value9              
 And (@Value10='%' or Acceptance_Detail.RegNo Like @Value10)  
 And (@Value11='%' or Profile.Name Like @Value11)  
 and (@Value12='%' or Acceptance.toc like @Value12)  
 and (@Value13='%' or acceptance_detail.refno like @Value13)              
 and (Acceptance_detail.Matters=@Value14 or @Value14='')              
 and acceptance_detail.ano <> acceptance_detail.lano and acceptance_detail.lano <> -1              
 And (Cover.ISType<>'T' or Cover.ProformaF=1)              
 And (Acceptance_Detail.BatchNo Like @Value19)         
 And ((Acceptance_Detail.BackDatedF=1 and @Value20='1') or @Value20='')      
 And (@Value21<>'1' or (@Value21='1' and Exists (Select CAcceptance_Detail.CANO from Acceptance CAcceptance_Detail Where CAcceptance_Detail.CANO=Acceptance_Detail.ANO)))              
 And ((Cover.TBAF=1 and @Value22='1') or @Value22='')        
 And (@Value23<>'1' or (@Value23='1' and Not Exists (Select Top 1 ANO from PPrintLog Where PPrintLog.ANO=Acceptance_Detail.ANO)))            
 And (@Value24='%' or Acceptance_Detail.ASource Like @Value24)
         
 Union all
         
 SELECT     
 CCover.COVERNO,              
 Cast(CAcceptance.AName as varchar(128)) as Insured,              
 CCover.CNO,              
 CCover.CStatus,              
 CAcceptance.lANO,              
 CAcceptance.ANO,              
 CAcceptance.REGNO,              
 CAcceptance.ADATE,              
 CAcceptance.LUSERID as USERID,              
 SysTab.Currency,              
 CAcceptance.ASTATUS,              
 CAcceptance.ATYPE,              
 CAcceptance.SDate,              
 CAcceptance.EDate,              
 Year(Coalesce(CRArrHeader.RDate,CAcceptance.SDate)) AS RYear,              
 CCover.ISType,              
 CAcceptance.Renewal,              
 CAcceptance.ESeqNo,              
 CAcceptance.PolicyNo,              
 CAcceptance.CertificateNo,              
 CAcceptance.RefNo,              
 CCover.ProformaF,              
 CAcceptance.ANO as ANO_INFO  
FROM  Acceptance
Inner Join Cover on (Cover.CNO=Acceptance.CNO)
Inner Join Acceptance CAcceptance on (CAcceptance.CANO=Acceptance.ANO)
Inner Join Cover CCover on (CCOver.CNO=CAcceptance.CNO)
left Join RArrHeader CRArrHeader on (CRArrHeader.ANO=CAcceptance.ANO)     
Inner Join Profile on (Profile.ID=Cover.PHolder), SysTab
WHERE @Value21='1'
 And (@Value1='%' or Acceptance.AName Like @Value1)             
 And (@Value2='%' or Cover.CoverNo Like @Value2)              
 And (Cover.CoverDate = @Value3 or @Value3='')              
 And (Cover.ExpDate = @Value4 or @Value4='')              
 And (@Value5='%' or Acceptance.PolicyNo Like @Value5)              
 And (@Value6='%' or Acceptance.CertificateNo Like @Value6)              
 And (Acceptance.PolicyDate = @Value7 or @Value7='' or Acceptance.PolicyDate Between @Value7 and @Value16)              
 And (Acceptance.RegDate = @Value17 or @Value17='' or Acceptance.RegDate Between @Value17 and @Value18)              
 And Acceptance.AType Like @Value8              
 And Acceptance.AStatus Like @Value9              
 And (@Value10='%' or Acceptance.RegNo Like @Value10)  
 And (@Value11='%' or Profile.Name Like @Value11)  
 and (@Value12='%' or Acceptance.toc like @Value12)  
 and (@Value13='%' or acceptance.refno like @Value13)              
 and (Acceptance.ano = acceptance.lano or Acceptance.LANO=-1)              
 and (Acceptance.Matters=@Value14 or @Value14='')              
 And (Cover.ISType<>'T' or Cover.ProformaF=1)              
 And (Acceptance.BatchNo Like @Value19)         
 And ((Acceptance.BackDatedF=1 and @Value20='1') or @Value20='')        
 And ((Cover.TBAF=1 and @Value22='1') or @Value22='')        
 And (@Value23<>'1' or (@Value23='1' and Not Exists (Select top 1 ANO from PPrintLog Where PPrintLog.ANO=Acceptance.ANO)))            
 And (@Value24='%' or Acceptance.ASource Like @Value24)
        
 Union all
        
SELECT     
 CCover.COVERNO,              
 Cast(CAcceptance.AName as varchar(128)) as Insured,              
 CCover.CNO,              
 CCover.CStatus,              
 CAcceptance.lANO,              
 CAcceptance.ANO,              
 CAcceptance.REGNO,              
 CAcceptance.ADATE,              
 CAcceptance.LUSERID as USERID,              
 SysTab.Currency,              
 CAcceptance.ASTATUS,              
 CAcceptance.ATYPE,              
 CAcceptance.SDate,              
 CAcceptance.EDate,              
 Year(Coalesce(CRArrHeader.RDate,CAcceptance.SDate)) AS RYear,              
 CCover.ISType,              
 CAcceptance.Renewal,              
 CAcceptance.ESeqNo,              
 CAcceptance.PolicyNo,              
 CAcceptance.CertificateNo,              
 CAcceptance.RefNo,              
 CCover.ProformaF,              
 Cacceptance_detail.ANO as ANO_INFO  
FROM  Acceptance Acceptance_Detail 
Inner join Acceptance on (Acceptance.ANO=Acceptance_Detail.LANO)
Inner Join Cover on (Cover.CNO=Acceptance.CNO)
Inner Join Acceptance CAcceptance_Detail on (CAcceptance_Detail.CANO=Acceptance_Detail.ANO)
Inner join Acceptance CAcceptance on (CAcceptance.ANO=CAcceptance_Detail.LANO)
Inner Join Cover CCover on (CCOver.CNO=CAcceptance.CNO)
Left Join RArrHeader CRArrHeader on (CRArrHeader.ANO=CAcceptance.ANO)     
Inner Join Profile on (Profile.ID=Cover.PHolder), SysTab
Where  @Value21='1' 
 And (@Value1='%' or Acceptance_Detail.AName Like @Value1)            
 And (@Value2='%' or Cover.CoverNo Like @Value2)             
 and (Cover.CoverDate = @Value3 or @Value3='')              
 And (Cover.ExpDate = @Value4 or @Value4='')              
 And (@Value5='%' or Acceptance_Detail.PolicyNo Like @Value5)              
 And (@Value6='%' or Acceptance_Detail.CertificateNo Like @Value6)              
 And (Acceptance_Detail.PolicyDate = @Value7 or @Value7='' or Acceptance_Detail.PolicyDate Between @Value7 and @Value16)              
 And (Acceptance_Detail.RegDate = @Value17 or @Value17='' or Acceptance_Detail.RegDate Between @Value17 and @Value18)              
 And Acceptance_Detail.AType Like @Value8              
 And Acceptance_Detail.AStatus Like @Value9              
 And (@Value10='%' or Acceptance_Detail.RegNo Like @Value10)  
 And (@Value11='%' or Profile.Name Like @Value11)  
 and (@Value12='%' or Acceptance.toc like @Value12)  
 and (@Value13='%' or acceptance_detail.refno like @Value13)              
 and (Acceptance_detail.Matters=@Value14 or @Value14='')              
 and acceptance_detail.ano <> acceptance_detail.lano and acceptance_detail.lano <> -1              
 And (Cover.ISType<>'T' or Cover.ProformaF=1)              
 And (Acceptance_Detail.BatchNo Like @Value19)         
 And ((Acceptance_Detail.BackDatedF=1 and @Value20='1') or @Value20='')         
 And ((Cover.TBAF=1 and @Value22='1') or @Value22='')        
 And (@Value23<>'1' or (@Value23='1' and Not Exists (Select Top 1 ANO from PPrintLog Where PPrintLog.ANO=Acceptance_Detail.ANO)))            
 And (@Value24='%' or Acceptance_Detail.ASource Like @Value24)
)              
   

GO
if exists (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'ListQry_3_A') AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) )
BEGIN
DROP function ListQry_3_A 
END
GO
CREATE function ListQry_3_A (    
@Value1 as varchar(255), @Value2 as varchar(255), @Value3 as varchar(255), @Value4 as varchar(255), @Value5 as varchar(255),     
@Value6 varchar(255), @Value7 as varchar(255), @Value8 as varchar(255), @Value9 as varchar(255), @Value10 as varchar(255),    
@Value11 as varchar(255),@Value12 as varchar(255), @Value13 as varchar(255),@Value14 as varchar(255),@Value15 as varchar(255),    
@Value16 as varchar(255),@Value17 as varchar(255),@Value18 as varchar(255),@Value19 as varchar(255),@Value20 as varchar(255),
@Value21 as varchar(255), @Value22 as varchar(255), @Value23 as varchar(255), @Value24 as varchar(255)
)          
RETURNS Table      
AS RETURN      
(      
SELECT Cast(0 as bit) as ProcessFlag,      
 Q.[COVERNO],      
 Q.[Insured],      
 Q.[CNO],      
 Q.[CStatus],      
 Q.[lANO],      
 Q.[ANO],      
 Q.[REGNO],      
 Q.[ADATE],      
 Q.[USERID],      
 Q.[Currency],       
 Q.[ASTATUS],      
 Q.[ATYPE],      
 Q.[SDate],      
 Q.[EDate],      
 Q.RYear,      
 Q.[ISType],      
 Q.[Renewal],      
 Q.[ESeqNo],      
 Q.[PolicyNo],      
 Q.[CertificateNo],      
 Q.RefNo,      
 Q.ProformaF,      
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
From      
 LISTQRY_3(@Value1, @Value2, @Value3, @Value4, @Value5, @Value6, @Value7, @Value8, @Value9, @Value10, @Value11, @Value12, @Value13,@Value14,@Value15,@Value16,@Value17,@Value18, @Value19, @Value20, @Value21, @Value22, @Value23, @Value24) q
 Inner Join ainfo a on (a.ANO=q.ANO_INFO)
 Left Join Ainfo_Ext b on (b.ANO=q.ANO_INFO)      
)      

GO
if exists (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'ListQry_3_b') AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) )
BEGIN
DROP function ListQry_3_b
END
GO
CREATE function ListQry_3_b (    
@Value1 as varchar(255), @Value2 as varchar(255), @Value3 as varchar(255), @Value4 as varchar(255), @Value5 as varchar(255),     
@Value6 varchar(255), @Value7 as varchar(255), @Value8 as varchar(255), @Value9 as varchar(255), @Value10 as varchar(255),    
@Value11 as varchar(255),@Value12 as varchar(255), @Value13 as varchar(255),@Value14 as varchar(255),@Value15 as varchar(255),    
@Value16 as varchar(255),@Value17 as varchar(255),@Value18 as varchar(255),@Value19 as varchar(255),@Value20 as varchar(255),
@Value21 as varchar(255), @Value22 as varchar(255), @Value23 as varchar(255), @Value24 as varchar(255), @Value25 as varchar(255)
)          
RETURNS Table      
AS RETURN      
(      
SELECT Cast(0 as bit) as ProcessFlag,      
 Q.[COVERNO],      
 Q.[Insured],      
 Q.[CNO],      
 Q.[CStatus],      
 Q.[lANO],      
 Q.[ANO],      
 Q.[REGNO],      
 Q.[ADATE],      
 Q.[USERID],      
 Q.[Currency],       
 Q.[ASTATUS],      
 Q.[ATYPE],      
 Q.[SDate],      
 Q.[EDate],      
 Q.RYear,      
 Q.[ISType],      
 Q.[Renewal],      
 Q.[ESeqNo],      
 Q.[PolicyNo],      
 Q.[CertificateNo],      
 Q.RefNo,      
 Q.ProformaF,      
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
From      
 LISTQRY_3(@Value1, @Value2, @Value3, @Value4, @Value5, @Value6, @Value7, @Value8, @Value9, @Value10, @Value11, @Value12, @Value13,@Value14,@Value15,@Value16,@Value17,@Value18, @Value19, @Value20, @Value21, @Value22, @Value23, @Value24) q
 Inner Join ainfo a on (a.ANO=q.ANO_INFO)
 Left Join Ainfo_Ext b on (b.ANO=q.ANO_INFO)      
Where '|'+VALUEID1+'|'+VALUEDESC1+'|'+VALUEID2+'|'+VALUEDESC2+'|'+VALUEID3+'|'+VALUEDESC3+'|'+VALUEID4+'|'+VALUEDESC4+'|'+VALUEID5+'|'+VALUEDESC5+'|'+VALUEID6+'|'+VALUEDESC6+'|'+VALUEID7+'|'+VALUEDESC7+'|'+VALUEID8+'|'+VALUEDESC8+'|'+VALUEID9+'|'+VALUEDESC9+'|'+VALUEID10+'|'+VALUEDESC10+'|'+VALUEID11+'|'+VALUEDESC11+'|'+VALUEID12+'|'+VALUEDESC12+'|'+VALUEID13+'|'+VALUEDESC13+'|'+VALUEID14+'|'+VALUEDESC14+'|'+VALUEID15+'|'+VALUEDESC15 LIKE '|%'+@Value25+'%' 
)      


GO

insert into PatchVersioning
select '55.35 Update Script - Patch 2020 (35)',GETDATE()
go


Declare @PrevScript varchar(100)
Declare @CurrScript varchar(100)

Select @PrevScript='55.34 Update Script - Patch 2020 (34)'
Select @CurrSCript='55.35 Update Script - Patch 2020 (35)'


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


