--17 jul 2017 :Penambahan Setting Template Policy No pada TOPRO, sehingga untuk setiap QUotation/Policy/Certificate yang menggunakan TOPRO dengan Templace Policy,
-- maka pada saat pembuatan awal (New) Template Policy akan di aplikasikan terlebih dahulu

IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'POLICYNO' AND Object_ID = Object_ID(N'TOPRO'))
BEGIN
ALTER TABLE TOPRO ADD	POLICYNO varchar(20) NULL
DECLARE @v sql_variant 
SET @v = N'Template Policy No'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'TOPRO', N'COLUMN', N'POLICYNO'
end
go


--21 jul 2017 : Penambahan Kolom ASource (Application Source) di Admlink yang dapat digunakan untuk Query
--Penambahan Kolom ASource untuk Search Voucher dan Search Document di WebFinance
IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'ASOURCE' AND Object_ID = Object_ID(N'AdmLink'))
BEGIN
ALTER TABLE AdmLink ADD	ASOURCE varchar(10) NULL
DECLARE @v sql_variant 
SET @v = N'Application Source'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'AdmLink', N'COLUMN', N'ASOURCE'
end
go

--21 jul 2017 (1):Penambahan Kolom ASource untuk Search Poilcy 
IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ListQry_3]') AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) ) 
begin
DROP FUNCTION ListQry_3 
end
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
FROM  Cover, Acceptance   
left Join RArrHeader on (RArrHeader.ANO=Acceptance.ANO), Profile, SysTab  
WHERE  Cover.CNO=Acceptance.CNO     
 and cover.PHolder = Profile.ID              
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
 And (@Value21<>'1' or (@Value21='1' and Exists (Select CAcceptance.CANO from Acceptance CAcceptance Where CAcceptance.CANO=Acceptance.ANO)))            
 And ((Cover.TBAF=1 and @Value22='1') or @Value22='')        
 And (@Value23<>'1' or (@Value23='1' and Exists (Select ANO from PPrintLog Where PPrintLog.ANO=Acceptance.ANO)))            
 And (Acceptance.ASource Like @Value24)
        
Union              
        
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
FROM  Cover, Acceptance   
left Join RArrHeader on (RArrHeader.ANO=Acceptance.ANO), Profile, acceptance as acceptance_detail, SysTab  
Where cover.CNO = acceptance.CNO     
 And cover.PHolder = Profile.ID              
 and acceptance.ano = acceptance_detail.lano              
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
 And (@Value21<>'1' or (@Value21='1' and Exists (Select CAcceptance_Detail.CANO from Acceptance CAcceptance_Detail Where CAcceptance_Detail.CANO=Acceptance_Detail.ANO)))              
 And ((Cover.TBAF=1 and @Value22='1') or @Value22='')        
 And (@Value23<>'1' or (@Value23='1' and Exists (Select ANO from PPrintLog Where PPrintLog.ANO=Acceptance_Detail.ANO)))            
 And (Acceptance_Detail.ASource Like @Value24) 
         
 Union        
         
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
FROM  Cover, Acceptance, Profile, SysTab, Cover CCover, Acceptance CAcceptance   
left Join RArrHeader CRArrHeader on (CRArrHeader.ANO=CAcceptance.ANO)   
WHERE @Value21='1' and CAcceptance.CANO=Acceptance.ANO and CCover.CNO=CAcceptance.CNO          
 And (CAcceptance.ano = Cacceptance.lano or CAcceptance.LANO=-1)              
 and Cover.CNO=Acceptance.CNO and cover.PHolder = Profile.ID              
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
 And (@Value23<>'1' or (@Value23='1' and Exists (Select ANO from PPrintLog Where PPrintLog.ANO=Acceptance.ANO)))            
 And (Acceptance.ASource Like @Value24)         
        
Union              
        
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
FROM  Cover, Acceptance, Profile, systab, acceptance as acceptance_detail, Acceptance as Cacceptance_detail, Cover CCover, Acceptance CAcceptance   
left Join RArrHeader CRArrheader on (CRArrHeader.ANO=CAcceptance.ANO)   
Where  @Value21='1' and CAcceptance_Detail.CANO=Acceptance_Detail.ANO and CAcceptance.ANO=CAcceptance_Detail.LANO and CCover.CNO=CAcceptance.CNO        
 and cover.CNO = acceptance.CNO And cover.PHolder = Profile.ID               
 and acceptance.ano = acceptance_detail.lano              
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
 And (@Value23<>'1' or (@Value23='1' and Exists (Select ANO from PPrintLog Where PPrintLog.ANO=Acceptance_Detail.ANO)))            
 And (Acceptance_Detail.ASource Like @Value24)         
)              
   
GO
IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ListQry_3_A]') AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) ) 
begin
DROP FUNCTION ListQry_3_A 
end
GO
Create function ListQry_3_A (    
@Value1 as varchar(255), @Value2 as varchar(255), @Value3 as varchar(255), @Value4 as varchar(255), @Value5 as varchar(255),     
@Value6 varchar(255), @Value7 as varchar(255), @Value8 as varchar(255), @Value9 as varchar(255), @Value10 as varchar(255),    
@Value11 as varchar(255),@Value12 as varchar(255), @Value13 as varchar(255),@Value14 as varchar(255),@Value15 as varchar(255),    
@Value16 as varchar(255),@Value17 as varchar(255),@Value18 as varchar(255),@Value19 as varchar(255),@Value20 as varchar(255),@Value21 as varchar(255), @Value22 as varchar(255), @Value23 as varchar(255), @Value24 as varchar(255)      
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
 A.FLDID1,      
 A.VALUEID1,      
 A.VALUEDESC1,      
 A.FLDID2,      
 A.VALUEID2,      
 A.VALUEDESC2,      
 A.FLDID3,      
 A.VALUEID3,      
 A.VALUEDESC3,      
 A.FLDID4,      
 A.VALUEID4,      
 A.VALUEDESC4,      
 A.FLDID5,      
 A.VALUEID5,      
 A.VALUEDESC5,      
 A.FLDID6,      
 A.VALUEID6,      
 A.VALUEDESC6,      
 A.FLDID7,      
 A.VALUEID7,      
 A.VALUEDESC7,      
 A.FLDID8,      
 A.VALUEID8,      
 A.VALUEDESC8,      
 A.FLDID9,      
 A.VALUEID9,      
 A.VALUEDESC9,      
 A.FLDID10,      
 A.VALUEID10,      
 A.VALUEDESC10,      
 A.FLDID11,      
 A.VALUEID11,      
 A.VALUEDESC11,      
 A.FLDID12,      
 A.VALUEID12,      
 A.VALUEDESC12,      
 A.FLDID13,      
 A.VALUEID13,      
 A.VALUEDESC13,      
 A.FLDID14,      
 A.VALUEID14,      
 A.VALUEDESC14,      
 A.FLDID15,      
 A.VALUEID15,      
 a.VALUEDESC15      
From      
 LISTQRY_3(@Value1, @Value2, @Value3, @Value4, @Value5, @Value6, @Value7, @Value8, @Value9, @Value10, @Value11, @Value12, @Value13,@Value14,@Value15,@Value16,@Value17,@Value18, @Value19, @Value20, @Value21, @Value22, @Value23, @Value24) AS Q, AINFO AS A      
Where q.ano_info = a.ANO      
)      

GO

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ListQry_3b]') AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) ) 
begin
DROP FUNCTION ListQry_3b 
end
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
FROM  Cover, Acceptance     
left Join RArrHeader on (RArrHeader.ANO=Acceptance.ANO), Profile, systab    
Where cover.CNO = acceptance.CNO       
 And cover.PHolder = Profile.ID                         
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
 And (@Value21<>'1' or (@Value21='1' and Exists (Select CAcceptance.CANO from Acceptance CAcceptance Where CAcceptance.CANO=Acceptance.ANO)))              
 And ((Cover.TBAF=1 and @Value22='1') or @Value22='')            
 And (@Value23<>'1' or (@Value23='1' and Exists (Select ANO from PPrintLog Where PPrintLog.ANO=Acceptance.ANO)))               
 And (Acceptance.ASource Like @Value24)             
             
 union            
             
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
FROM  Cover, Acceptance, Profile, systab, Cover CCover, Acceptance CAcceptance     
left Join RArrHeader CRArrHeader on (CRArrHeader.ANO=CAcceptance.ANO)     
Where @Value21='1' and CAcceptance.CANO=Acceptance.ANO and CCover.CNO=CAcceptance.CNO              
 and (Cacceptance.ano = Cacceptance.lano or Cacceptance.lano = -1)                           
 and cover.CNO = acceptance.CNO And cover.PHolder = Profile.ID                  
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
 And (@Value23<>'1' or (@Value23='1' and Exists (Select ANO from PPrintLog Where PPrintLog.ANO=Acceptance.ANO)))              
 And (Acceptance.ASource Like @Value24)                        
)

GO


IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ListQry_3b_a]') AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) ) 
begin
DROP FUNCTION ListQry_3b_a 
end
GO

Create function ListQry_3b_a (  
@Value1 as varchar(255), @Value2 as varchar(255), @Value3 as varchar(255), @Value4 as varchar(255), @Value5 as varchar(255),   
@Value6 varchar(255), @Value7 as varchar(255), @Value8 as varchar(255), @Value9 as varchar(255), @Value10 as varchar(255),  
@Value11 as varchar(255),@Value12 as varchar(255), @Value13 as varchar(255),@Value14 as varchar(255),@Value15 as varchar(255),  
@Value16 as varchar(255),@Value17 as varchar(255),@Value18 as varchar(255),@Value19 as varchar(255),@Value20 as varchar(255),@Value21 as varchar(255), @Value22 as varchar(255), @Value23 as varchar(255), @Value24 as varchar(255)    
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
 a.VALUEID15 , a.VALUEDESC15    
FROM  ListQry_3b (@Value1, @Value2, @Value3, @Value4, @Value5, @Value6, @Value7, @Value8, @Value9, @Value10,@Value11, @Value12, @Value13,@Value14,@Value15,@Value16,@Value17,@Value18,@Value19,@Value20,@Value21, @Value22, @Value23, @Value24) as q, ainfo as a    
Where [q].[ANO] = [a].[ANO]    
        
)    



go

--21 jul 2017 (2): penambahan AUTO INFORCE PADA INFORCE
IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'AutoInforceF' AND Object_ID = Object_ID(N'APDRuleH'))
BEGIN
ALTER TABLE APDRuleH ADD	AutoInforceF bit NULL
DECLARE @v sql_variant 
SET @v = N'Auto Inforce Flag (0 : No, 1 : Yes, Must Use Auto Inforce)'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'APDRuleH', N'COLUMN', N'AutoInforceF'
end
GO

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Get_Policy_APRule]') AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) ) 
begin
DROP FUNCTION Get_Policy_APRule 
end
GO

Create function Get_Policy_APRule(@P_ANO as int)      
RETURNS Table      
AS RETURN      
(      
Select AD.RuleID, AD.Class, AD.RepName, AD.ExeName, AH.AutoInforceF   
from APDRuleH AH 
INNER JOIN APDRULED AD ON (AH.RULEID=AD.RULEID) INNER JOIN SYSCLASS S ON (S.CLASS=AD.CLASS)  
Where AH.AllowedF=1 AND AH.APPTYPE='POLICY'  
and 1 in   
(  
Select 1 from Acceptance A, Cover C   
Where A.ANO=@P_ANO and C.CNO=A.CNO and C.PolicyType=AH.PolicyType and C.ISType=AH.ISType and (C.Segment=AH.Segment or AH.Segment='<All>') and A.TOC=AH.TOC and (A.TOPRO=AH.TOPRO or AH.TOPRO='<All>')  
and charindex(A.AType,S.AccAType)<>0  
and charindex(A.AStatus,S.AccAStatus)<>0  
and charindex(C.CStatus,S.CoverCStatus)<>0  
)  
)       

go

--25 JUL 2017 : PENAMBAHAN AUTO GENERATE COLLECTION DI  INFORCE
IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'CollNo' AND Object_ID = Object_ID(N'nVoucher'))
BEGIN
ALTER TABLE nVoucher ADD
	CollNo varchar(20) NULL
end
GO

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'CL_I_COLLECT_PERIOD_GROSS_ALL_BYPOLICYNO') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
DROP FUNCTION CL_I_COLLECT_PERIOD_GROSS_ALL_BYPOLICYNO
GO
Create function CL_I_COLLECT_PERIOD_GROSS_ALL_BYPOLICYNO(@P_ANO as Int)  
RETURNS TABLE
AS RETURN
(
select distinct  Voucher.RefNo, Voucher.Voucher,Admlink.Type, Admlink.Date, Admlink.Subject, Voucher.DocNo, Voucher.StatID, Voucher.ActionBy, Voucher.ActionDate, Voucher.AcceptedBy, Voucher.AcceptedDate, 
Voucher.[Currency],  0 as Installment, Voucher.DueDate as DueDate, Voucher.Nominal_CC-Voucher.Diff_CC as Nominal,
AdmLink.Remarks as AName, Profile.Name, Voucher.debtorF,Voucher.CreditorF,AdmLink.BatchNo, Admlink.RefType, Admlink.A_PolicyNo, Voucher.Branch, Admlink.Code
from ProAcc,[Profile],nVoucher Voucher,AdmLink, AccAss, Acceptance
where Acceptance.ANO=@P_ANO and Acceptance.ANO<>Acceptance.LANO and AccAss.ANO=Acceptance.ANO and Admlink.AdmNo=AccAss.AdmNo and Voucher.Voucher=AdmLink.Voucher   
and ProAcc.ProAcc=Voucher.ProAcc 
and ProAcc.[ID]=[Profile].[ID] 
and Admlink.Type in ('DI','IC','CF','JP','SO')
and Admlink.ISType in ('I','L','C')

Union All

select distinct  Voucher.RefNo, Voucher.Voucher,Admlink.Type, Admlink.Date, Admlink.Subject, Voucher.DocNo, Voucher.StatID, Voucher.ActionBy, Voucher.ActionDate, Voucher.AcceptedBy, Voucher.AcceptedDate, 
Voucher.[Currency],  0 as Installment, Voucher.DueDate as DueDate, Voucher.Nominal_CC-Voucher.Diff_CC as Nominal,
AdmLink.Remarks as AName, Profile.Name, Voucher.debtorF,Voucher.CreditorF,AdmLink.BatchNo, Admlink.RefType, Admlink.A_PolicyNo, Voucher.Branch, Admlink.Code
from ProAcc,[Profile],nVoucher Voucher,AdmLink, AccAss, Acceptance
where Acceptance.LANO=@P_ANO and Acceptance.ANO=Acceptance.LANO and AccAss.ANO=Acceptance.ANO and Admlink.AdmNo=AccAss.AdmNo and Voucher.Voucher=AdmLink.Voucher   
and ProAcc.ProAcc=Voucher.ProAcc 
and ProAcc.[ID]=[Profile].[ID] 
and Admlink.Type in ('DI','IC','CF','JP','SO')
and Admlink.ISType in ('I','L','C')
)


GO

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'CL_I_COLLECT_PERIOD_NET_ALL_BYPOLICYNO') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
DROP FUNCTION CL_I_COLLECT_PERIOD_NET_ALL_BYPOLICYNO
GO
Create function CL_I_COLLECT_PERIOD_NET_ALL_BYPOLICYNO(@P_ANO as int)  
RETURNS TABLE  
AS RETURN  
(  
select distinct  Voucher.RefNo, Voucher.Voucher,Admlink.Type, Admlink.Date, Admlink.Subject, Voucher.DocNo, Voucher.StatID, Voucher.ActionBy, Voucher.ActionDate, Voucher.AcceptedBy, Voucher.AcceptedDate, 
Voucher.[Currency],  0 as Installment, Voucher.DueDate as DueDate, Voucher.Nominal_CC-Voucher.Diff_CC as Nominal,
AdmLink.Remarks as AName, Profile.Name, Voucher.debtorF,Voucher.CreditorF,AdmLink.BatchNo, Admlink.RefType, Admlink.A_PolicyNo, Voucher.Branch, Admlink.Code
from ProAcc,[Profile],nVoucher Voucher,AdmLink, AccAss, Acceptance
where Acceptance.ANO=@P_ANO and Acceptance.ANO<>Acceptance.LANO and AccAss.ANO=Acceptance.ANO and Admlink.AdmNo=AccAss.AdmNo and Voucher.Voucher=AdmLink.Voucher   
and ProAcc.ProAcc=Voucher.ProAcc   
and ProAcc.[ID]=[Profile].[ID]   
and Admlink.Type in ('BB','BO','BA','DI','IC','CF','JP','SO')   
and Admlink.ISType in ('I','L','C')
and Exists (Select Top 1 Source from Acceptance A Where A.ANO=@P_ANO and A.Source=Admlink.Source)

Union All

select distinct  Voucher.RefNo, Voucher.Voucher,Admlink.Type, Admlink.Date, Admlink.Subject, Voucher.DocNo, Voucher.StatID, Voucher.ActionBy, Voucher.ActionDate, Voucher.AcceptedBy, Voucher.AcceptedDate, 
Voucher.[Currency],  0 as Installment, Voucher.DueDate as DueDate, Voucher.Nominal_CC-Voucher.Diff_CC as Nominal,
AdmLink.Remarks as AName, Profile.Name, Voucher.debtorF,Voucher.CreditorF,AdmLink.BatchNo, Admlink.RefType, Admlink.A_PolicyNo, Voucher.Branch, Admlink.Code
from ProAcc,[Profile],nVoucher Voucher,AdmLink, AccAss, Acceptance
where Acceptance.LANO=@P_ANO and Acceptance.ANO=Acceptance.LANO and AccAss.ANO=Acceptance.ANO and Admlink.AdmNo=AccAss.AdmNo and Voucher.Voucher=AdmLink.Voucher   
and ProAcc.ProAcc=Voucher.ProAcc   
and ProAcc.[ID]=[Profile].[ID]   
and Admlink.Type in ('BB','BO','BA','DI','IC','CF','JP','SO')   
and Admlink.ISType in ('I','L','C')
and Exists (Select Top 1 Source from Acceptance A Where A.ANO=@P_ANO and A.Source=Admlink.Source)
)  



GO

--25 JUL 2017 : PEMERIKSAAN CEK OBJ CLAIM TIDAK HANYA UNTUK pCStatus = ‘P’ SAJA
IF EXISTS ( SELECT * FROM   sysobjects WHERE  id = object_id(N'[dbo].[QCheckObjectClaimed]') and OBJECTPROPERTY(id, N'IsProcedure') = 1 )
begin
DROP Procedure QCheckObjectClaimed
end
GO
CREATE Procedure QCheckObjectClaimed(@P_ClaimNo varchar(20), @P_PolicyNo varchar(20), @P_CertificateNo varchar(20),@P_LossDate smalldatetime='01/01/2007', @P_COL varchar(10)='', @P_Location varchar(10)='')   
as   
select C1.ClaimNo, C1.LossDate,  C1.PolicyNo+case When C1.CertificateNo='' then '' else '-'+C1.CertificateNo end as PolicyNo, C1.CStatus, C1.CNO, C1.ANO, P1.Name as Claimant, c2.DESCRIPTION as 'COL', L.location   
FROM   
(   
 select C1.OCNO, Max(C1.CNO) as CNO   
 from Claim C1   
 Where C1.ClaimNo<>@P_ClaimNo and C1.PolicyNo=@P_PolicyNo and C1.CertificateNo=@P_CertificateNo and C1.LossDate between dateadd(day,-14,@P_LossDate) and dateadd(day,14,@P_LossDate)   
 and not (C1.CStatus='C') -- not Close Claim
 and not ((C1.CStatus='A' or C1.pCStatus='A') and C1.CType='C')  --not Claim Cancellation
 and (@P_COL='' or C1.COL=@P_COL)   
 and (@P_Location='' or C1.location=@P_Location)   
 Group By C1.OCNO   
) C   
Inner Join Claim C1 on (C1.CNO=C.CNO)   
Inner Join Profile P1 on (P1.ID=C1.Claimant)   
Inner Join COLTAB C2 on (C2.COL=C1.COL)   
Left Join Location L on (L.Location=C1.Location)   
GO

--26 jul 2017 : PENAMBAHAN JP SHARE DAN JP COMM DI FACULTATIVE (FACULTATIVE JOINT PLACEMENT)
IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'JPSLIPNO' AND Object_ID = Object_ID(N'RArrDet'))
BEGIN
ALTER TABLE RArrDet ADD	JPSLIPNO varchar(50) NULL
DECLARE @v sql_variant 
SET @v = N'Facultative Joint Placement Slip No '
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'RArrDet', N'COLUMN', N'JPSLIPNO'
end
GO

IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'JPSHARE' AND Object_ID = Object_ID(N'RArrDet'))
BEGIN
ALTER TABLE RArrDet ADD	JPSHARE float(53) NULL
DECLARE @v sql_variant 
SET @v = N'Facultative Joint Placement Share (in %) '
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'RArrDet', N'COLUMN', N'JPSHARE'
end
GO

IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'JPCOMM' AND Object_ID = Object_ID(N'RArrDet'))
BEGIN
ALTER TABLE RArrDet ADD	JPCOMM float(53) NULL
DECLARE @v sql_variant 
SET @v = N'Facultative Joint Placement Comm (in %)'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'RArrDet', N'COLUMN', N'JPCOMM'
end
go

IF EXISTS ( SELECT * FROM   sysobjects WHERE  id = object_id(N'[dbo].[QFacultative_Data]') and OBJECTPROPERTY(id, N'IsProcedure') = 1 )
begin
DROP Procedure QFacultative_Data
end
GO
CREATE Procedure QFacultative_Data(@P_ANO integer, @P_FID varchar(20))                    
AS                                  
SELECT R.FID, R.AType, F.SLIPNO, R.SDATE, R.EDATE, R.RTYPE, F.ID, R.SHARE, R.FLPCT, R.AMOUNT, R.LIMIT, R.EXCESS, R.UJROHREINS, R.UJROHCEDANT,                    
R.UserID, R.CDate,                  
R.LUserID, R.LDate,                  
R.AUserID, R.AUserDate,            
R.AcceptedBy, R.AcceptedDate,             
R.ClaimCOOP, R.PrecedeFacCessionF, R.NoRefundF,   
F.Code, F.COMM, F.OCOMM, F.ACQCOST, F.NETRATE, F.Currency, F.Unit, R.PCALC, R.CPCT, R.Memo, F.REMARKS, F.WPC, F.BinderWarranty, R.FULLCOVERF, R.ORIGINALF, R.OnGrossAfterCommF, R.OnNetRateF, R.CPRefund, F.PERIOD, F.INSTALLMENT,       
F.GRACE, R.JPSLIPNO, R.JPSHARE, R.JPCOMM,                    
F.IDATE_1, F.IPCT_1,                    
F.IDATE_2, F.IPCT_2,                    
F.IDATE_3, F.IPCT_3,                    
F.IDATE_4, F.IPCT_4,                    
F.IDATE_5, F.IPCT_5,                    
F.IDATE_6, F.IPCT_6,                    
F.IDATE_7, F.IPCT_7,                    
F.IDATE_8, F.IPCT_8,                    
F.IDATE_9, F.IPCT_9,                    
F.IDATE_10, F.IPCT_10,                    
F.IDATE_11, F.IPCT_11,                    
F.IDATE_12 , F.IPCT_12,      
F.IDATE_13 , F.IPCT_13,                    
F.IDATE_14 , F.IPCT_14,                    
F.IDATE_15 , F.IPCT_15,                    
F.IDATE_16 , F.IPCT_16,                    
F.IDATE_17 , F.IPCT_17,                    
F.IDATE_18 , F.IPCT_18,                    
F.IDATE_19 , F.IPCT_19,                    
F.IDATE_20 , F.IPCT_20,                    
F.IDATE_21 , F.IPCT_21,                    
F.IDATE_22 , F.IPCT_22,                    
F.IDATE_23 , F.IPCT_23,                    
F.IDATE_24 , F.IPCT_24      
FROM RARRDET R, FPART F                    
WHERE R.ANO=@P_ANO AND R.FID=@P_FID AND F.ANO=R.ANO AND F.FID=R.FID   

GO

IF EXISTS ( SELECT * FROM   sysobjects WHERE  id = object_id(N'[dbo].[QFACOUTDET]') and OBJECTPROPERTY(id, N'IsProcedure') = 1 )
begin
DROP Procedure QFACOUTDET
end
GO
CREATE Procedure QFACOUTDET(@P_ANO integer,@P_CODE varchar(10))        
as        
SELECT FPartDet.Code, RArrDet.FID, RArrDet.FLPct, RArrDet.Status, RArrDet.AType, RArrDet.RType, RArrDet.SDate, RArrDet.EDate, RArrDet.Share, RArrDet.Amount, RArrDet.Prorata, Profile.Name, FPart.SlipNo, FPart.ID, FPart.Share AS RShare, FPart.ACQCOST, FPartDet.Comm, FPartDet.OComm, FPart.WPC,        
FPart.Currency, FPartDet.NetRate , FPartDet.Unit, RArrDet.PCALC, RArrDet.CPct, RArrDet.CPRefund, RArrDet.NoRefundF, RArrDet.OnGrossAfterCommF, RArrDet.FullCoverF, FPart.Remarks, RArrDet.UJROHREINS, RArrDet.UJROHCEDANT,
RArrDet.JPSLIPNO, RArrDet.JPShare, RArrDet.JPComm
From RArrDet, FPart, Profile, FPartDet        
WHERE RArrDet.ANO=@P_ANO And FPart.ANO=RArrDet.ANO And FPart.FID=RArrDet.FID And Profile.ID=FPart.ID AND RArrDet.FullCoverF=0        
AND FPartDet.ANO=RArrDet.ANO and FPartDet.FID=RArrDet.FID And FPartDet.ID=FPart.ID   
And (FPartDet.Code=@P_Code or Exists (Select Top 1 RCalc.Code from RCalc, RateCov Where RCalc.ANO=RArrDet.ANO and RateCov.Code=FPartDet.Code and RCalc.TOR=RateCov.TOR and RCalc.Code=@P_Code))  
          
Union All        
          
SELECT FPart.Code, RArrDet.FID, RArrDet.FLPct, RArrDet.Status, RArrDet.AType, RArrDet.RType, RArrDet.SDate, RArrDet.EDate, RArrDet.Share, RArrDet.Amount, RArrDet.Prorata, Profile.Name, FPart.SlipNo, FPart.ID, FPart.Share AS RShare, FPart.ACQCOST, FPart.Comm, FPart.OComm, FPart.WPC,        
FPart.Currency, FPart.NetRate , FPart.Unit, RArrDet.PCALC, RArrDet.CPct,  RArrDet.CPRefund, RArrDet.NoRefundF, RArrDet.OnGrossAfterCommF, RArrDet.FullCoverF, FPart.Remarks, RArrDet.UJROHREINS, RArrDet.UJROHCEDANT,
RArrDet.JPSLIPNO, RArrDet.JPShare, RArrDet.JPComm
From RArrDet, FPart, Profile        
WHERE RArrDet.ANO=@P_ANO And FPart.ANO=RArrDet.ANO And FPart.FID=RArrDet.FID And Profile.ID=FPart.ID AND RArrDet.FullCoverF=1      

GO

IF EXISTS ( SELECT * FROM   sysobjects WHERE  id = object_id(N'[dbo].[QGetPreCedeFacCessionAmount]') and OBJECTPROPERTY(id, N'IsProcedure') = 1 )
begin
DROP Procedure QGetPreCedeFacCessionAmount
end
GO
CREATE Procedure QGetPreCedeFacCessionAmount(@P_ANO integer)     
as     
Select sum(
Case 
When RArrDet.Amount<>0 Then RArrDet.Amount
When RArrDet.Limit<>0 Then (RArrDet.Share-RArrDet.JPShare)/100*RArrDet.Limit
When RArrHeader.TAmount<>0 then (RArrDet.Share-RArrDet.JPShare)/100*RArrHeader.TAmount
else (RArrDet.Share-RArrDet.JPShare)/100*P.OurShare/P.NUMRISK
end) as Amount   
from RArrDet     
Inner Join RArrHeader on (RArrHeader.ANO=RArrDet.ANO)
Inner Join FN_PCalc(@P_ANO) P on (P.ANO=RArrDet.ANO)
Inner Join Acceptance on (Acceptance.ANO=RArrDet.ANO)     
Inner Join Cover on (Cover.CNO=Acceptance.CNO)     
Inner Join TOC on (TOC.TOC=Acceptance.TOC)     
Where (RArrDet.FullCoverF=1 or Exists (Select RCover.Category from FPartDet, RCover Where RCover.ANO=FPartDet.ANO and RCover.Code=FPartDet.Code and RCover.Category='M' and FPartDet.ANO=RArrDet.ANO and FPartDet.FID=RArrDet.FID))     
and RArrDet.Status<>'O' and (RArrDet.PrecedeFacCessionF=1 or TOC.PrecedeFacCessionF=1)     
and RArrDet.ANO=@P_ANO     


GO

IF EXISTS ( SELECT * FROM   sysobjects WHERE  id = object_id(N'[dbo].[QCLAIMFACOUT]') and OBJECTPROPERTY(id, N'IsProcedure') = 1 )
begin
DROP Procedure QCLAIMFACOUT
end
GO
CREATE Procedure QCLAIMFACOUT(@P_CNO integer)                    
as                    
SELECT Distinct RArrDet.FID, RArrDet.FLPct, RArrDet.Status, RArrDet.AType, RArrDet.RType, RArrDet.SDate, RArrDet.EDate, (Case When RArrDet.Limit<>0 Then (RArrDet.Limit+RArrDet.Excess)/RArrHeader.TAmount*100*(RArrDet.Share-RArrDet.JPShare)/100 else (RArrDet.Share-RArrDet.JPShare) end) as Share, RArrDet.Amount, RArrDet.Limit, RArrDet.Excess, Profile.Name, FPart.SlipNo, FPart.ID, FPart.Share AS RShare, RArrDet.FullCoverF, RArrDet.OriginalF, Cast(FPart.Remarks as varchar(512)) as Remarks, RArrDet.ClaimCoop, RArrHeader.TAmount,

Case When RArrDet.Excess<>0 Then   
 Case When CArrHeader.ETAmount>RArrDet.Excess Then CArrHeader.ETAmount-RArrDet.Excess else 0 end  
 else CArrHeader.ETAmount  
end *(Case When RArrDet.Limit<>0 Then (RArrDet.Limit+RArrDet.Excess)/RArrHeader.TAmount*(RArrDet.Share-RArrDet.JPShare)/100 else (RArrDet.Share-RArrDet.JPShare)/100 end)*FPart.Share/100 as Estimate,        

Case When RArrDet.Excess<>0 Then   
 Case When CArrHeader.TAmount>RArrDet.Excess Then CArrHeader.TAmount-RArrDet.Excess else 0 end  
 else CArrHeader.TAmount  
end *(Case When RArrDet.Limit<>0 Then (RArrDet.Limit+RArrDet.Excess)/RArrHeader.TAmount*(RArrDet.Share-RArrDet.JPShare)/100 else (RArrDet.Share-RArrDet.JPShare)/100 end)*FPart.Share/100 as Claim,        

Case When RArrDet.ClaimCoop>0 and (RArrDet.ClaimCoop<=CArrHeader.ETAmount*(Case When RArrDet.Limit<>0 Then (RArrDet.Limit+RArrDet.Excess)/RArrHeader.TAmount*(RArrDet.Share-RArrDet.JPShare)/100 else (RArrDet.Share-RArrDet.JPShare)/100 end)*FPart.Share/100) Then Cast(1 as Bit) else Cast(0 as Bit) end as ClaimCoopF        
From ACCEPTANCE, RArrHeader, RArrDet, FPart, Profile, CLAIM, CArrHeader        
WHERE Claim.CNO=@P_CNO AND CArrHeader.CNO=Claim.CNO AND ACCEPTANCE.ANO=Claim.ANO AND RArrDet.ANO=Claim.ANO AND RArrHeader.ANO=Acceptance.ANO
AND ((RARRDET.SDATE<=CLAIM.LOSSDATE AND ACCEPTANCE.ExclusiveF=1) or ((RARRDET.SDATE<CLAIM.LOSSDATE or (RARRDET.SDATE=CLAIM.LOSSDATE AND ACCEPTANCE.STIME<=Claim.LossTime)) AND ACCEPTANCE.ExclusiveF=0))                   
AND ((dbo.fn_Get_ExtPeriodDate(ACCEPTANCE.ExtPeriod, ACCEPTANCE.ExtPeriodInDaysF, RARRDET.EDATE)>CLAIM.LOSSDATE AND ACCEPTANCE.ExclusiveF=1) or ((dbo.fn_Get_ExtPeriodDate(ACCEPTANCE.ExtPeriod, ACCEPTANCE.ExtPeriodInDaysF, RARRDET.EDATE)>CLAIM.LOSSDATE or (dbo.fn_Get_ExtPeriodDate(ACCEPTANCE.ExtPeriod, ACCEPTANCE.ExtPeriodInDaysF, RARRDET.EDATE)=CLAIM.LOSSDATE AND ACCEPTANCE.ETIME>Claim.LossTime)) AND ACCEPTANCE.ExclusiveF=0))                  
AND FPart.ANO=RArrDet.ANO AND FPart.FID=RArrDet.FID AND Profile.ID=FPart.ID AND RArrDet.FullCoverF=1               
AND (FPart.Code='' or EXISTS (Select RateCov.Code from RateCov, COL Where RateCov.Code=FPart.Code AND RateCov.TOR=COL.TOR AND COL.COL=Claim.COL))                    
AND RArrDet.Status='A'           
                          
Union All                    
                          
SELECT Distinct RArrDet.FID, RArrDet.FLPct, RArrDet.Status, RArrDet.AType, RArrDet.RType, RArrDet.SDate, RArrDet.EDate, (Case When RArrDet.Limit<>0 Then (RArrDet.Limit+RArrDet.Excess)/RArrHeader.TAmount*100*(RArrDet.Share-RArrDet.JPShare)/100 else (RArrDet.Share-RArrDet.JPShare) end)*(CASE 

WHEN CCALC.LOSS<>0 THEN LCALC.LOSS/CCALC.LOSS WHEN CCALC.INDEMNITY<>0 THEN LCALC.INDEMNITY/CCALC.INDEMNITY ELSE 0 END) as Share, 
RArrDet.Amount, RArrDet.Limit, RArrDet.Excess, Profile.Name, FPart.SlipNo, FPart.ID, FPart.Share AS RShare, RArrDet.FullCoverF, RArrDet.OriginalF, 
Cast(FPart.Remarks as varchar(512)) as Remarks, RArrDet.ClaimCoop, RArrHeader.TAmount,

Case When RArrDet.Excess<>0 Then   
 Case When CArrHeader.ETAmount*(CASE WHEN CCALC.LOSS<>0 THEN LCALC.LOSS/CCALC.LOSS ELSE 0 END)>RArrDet.Excess Then CArrHeader.ETAmount*(CASE WHEN CCALC.LOSS<>0 THEN LCALC.LOSS/CCALC.LOSS ELSE 0 END)-RArrDet.Excess else 0 end  
 else CArrHeader.ETAmount*(CASE WHEN CCALC.LOSS<>0 THEN LCALC.LOSS/CCALC.LOSS ELSE 0 END)  
end *(Case When RArrDet.Limit<>0 Then (RArrDet.Limit+RArrDet.Excess)/RArrHeader.TAmount*(RArrDet.Share-RArrDet.JPShare)/100 else (RArrDet.Share-RArrDet.JPShare)/100 end)*FPart.Share/100 as Estimate,     

Case When RArrDet.Excess<>0 Then   
 Case When CArrHeader.TAmount*(CASE WHEN CCALC.INDEMNITY<>0 THEN LCALC.Indemnity/CCALC.INDEMNITY ELSE 0 END)>RArrDet.Excess Then CArrHeader.TAmount*(CASE WHEN CCALC.INDEMNITY<>0 THEN LCALC.Indemnity/CCALC.INDEMNITY ELSE 0 END)-RArrDet.Excess else 0 end  
 else CArrHeader.TAmount*(CASE WHEN CCALC.INDEMNITY<>0 THEN LCALC.Indemnity/CCALC.INDEMNITY ELSE 0 END)  
end *(Case When RArrDet.Limit<>0 Then (RArrDet.Limit+RArrDet.Excess)/RArrHeader.TAmount*(RArrDet.Share-RArrDet.JPShare)/100 else (RArrDet.Share-RArrDet.JPShare)/100 end)*FPart.Share/100 as Claim,      

Case When RArrDet.ClaimCoop>0 and (RArrDet.ClaimCoop<=CArrHeader.ETAmount*(CASE WHEN CCALC.LOSS<>0 THEN LCALC.LOSS/CCALC.LOSS ELSE 0 END)*(Case When RArrDet.Limit<>0 Then (RArrDet.Limit+RArrDet.Excess)/RArrHeader.TAmount*(RArrDet.Share-RArrDet.JPShare)/100 else (RArrDet.Share-RArrDet.JPShare)/100 end)*FPart.Share/100) Then Cast(1 as Bit) else Cast(0 as Bit) end as ClaimCoopF        
From ACCEPTANCE, RArrHeader, RArrDet, FPart, Profile, CLAIM, COL, CArrHeader, FPartDet, 

(
SELECT L.CNO, L.TOR, SUM((L.LOSS-L.EDEDUCTIBLE-L.ESALVAGE)*C.RATE) AS LOSS, SUM((L.INDEMNITY-L.DEDUCTIBLE-L.SALVAGE)*C.RATE) AS INDEMNITY
FROM LCALC L, CCALC C 
WHERE C.CNO=L.CNO AND C.CURRENCY=L.CURRENCY AND C.CNO=@P_CNO
GROUP BY L.CNO, L.TOR
) LCALC,
(
SELECT C.CNO, SUM((C.LOSS-C.EDEDUCTIBLE-C.ESALVAGE)*C.RATE) AS LOSS, SUM((C.CLAIM-C.EDEDUCTIBLE-C.ESALVAGE)*C.RATE) AS INDEMNITY
FROM CCALC C
WHERE C.CNO=@P_CNO
GROUP BY C.CNO
) CCALC
WHERE Claim.CNO=@P_CNO AND CArrHeader.CNO=Claim.CNO AND COL.COL=CLAIM.COL
AND CCALC.CNO=CLAIM.CNO AND LCALC.CNO=CCALC.CNO AND LCALC.TOR=COL.TOR
AND ACCEPTANCE.ANO=Claim.ANO AND RArrDet.ANO=Claim.ANO AND RArrHeader.ANO=Acceptance.ANO             
AND ((RARRDET.SDATE<=CLAIM.LOSSDATE AND ACCEPTANCE.ExclusiveF=1) or ((RARRDET.SDATE<CLAIM.LOSSDATE or (RARRDET.SDATE=CLAIM.LOSSDATE AND ACCEPTANCE.STIME<=Claim.LossTime)) AND ACCEPTANCE.ExclusiveF=0))                   
AND ((dbo.fn_Get_ExtPeriodDate(ACCEPTANCE.ExtPeriod, ACCEPTANCE.ExtPeriodInDaysF, RARRDET.EDATE)>CLAIM.LOSSDATE AND ACCEPTANCE.ExclusiveF=1) or ((dbo.fn_Get_ExtPeriodDate(ACCEPTANCE.ExtPeriod, ACCEPTANCE.ExtPeriodInDaysF, RARRDET.EDATE)>CLAIM.LOSSDATE or 
(dbo.fn_Get_ExtPeriodDate(ACCEPTANCE.ExtPeriod, ACCEPTANCE.ExtPeriodInDaysF, RARRDET.EDATE)=CLAIM.LOSSDATE AND ACCEPTANCE.ETIME>Claim.LossTime)) AND ACCEPTANCE.ExclusiveF=0))                  
AND FPart.ANO=RArrDet.ANO AND FPart.FID=RArrDet.FID AND Profile.ID=FPart.ID AND RArrDet.FullCoverF=0                    
AND FPartDet.ANO=RArrDet.ANO AND FPartDet.FID=RArrDet.FID AND FPartDet.ID=FPart.ID             
AND EXISTS (Select RateCov.Code from RateCov Where RateCov.Code=FPartDet.Code AND RateCov.TOR=LCALC.TOR)                    
AND RArrDet.Status='A'     

                            

go

--VERSIONING
insert into versioning
select '2017 V.2.2.0',GETDATE(),'2017 V.2.0.0',GETDATE(),'K: 2017 V.2.0.0',GETDATE()
go


Declare @PrevScript varchar(100)
Declare @CurrScript varchar(100)

Select @PrevScript='10 Script Komulatif Konsol 2.1'
Select @CurrSCript='11 Script Komulatif Konsol 2.2'


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

