--4 AGST 2017 : 

IF  NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'ID_TYPE') AND type in (N'U'))
BEGIN
CREATE TABLE ID_TYPE(
	ID_TYPE varchar(20) NOT NULL,
 CONSTRAINT I_ID_TYPE PRIMARY KEY CLUSTERED 
(
	ID_TYPE ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
END
GO

IF NOT EXISTS(SELECT * FROM ID_TYPE WHERE ID_TYPE in('KTP','SIM','KITAS(P)','KIMS','OTHERS','ID Card','Driving License','Passport'))
BEGIN
INSERT INTO ID_TYPE 
SELECT 'KTP' 
UNION ALL 
SELECT 'SIM'
UNION ALL
SELECT 'KITAS(P)'
UNION ALL
SELECT 'KIMS'
UNION ALL
SELECT 'OTHERS'
UNION ALL
SELECT 'ID Card'
UNION ALL
SELECT 'Driving License'
UNION ALL
SELECT 'Passport'
END
GO

IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'ID_TYPE' AND Object_ID = Object_ID(N'Profile_Ext'))
BEGIN
ALTER TABLE Profile_Ext ADD ID_TYPE VARCHAR(20)
END
GO
IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'ID_TYPE' AND Object_ID = Object_ID(N'Scheme_beneficiary'))
BEGIN
ALTER TABLE Scheme_beneficiary ADD ID_TYPE VARCHAR(20)
END
GO

IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'ID_TYPE' AND Object_ID = Object_ID(N'Beneficiaries'))
BEGIN
ALTER TABLE Beneficiaries ADD ID_TYPE VARCHAR(20)
END
GO

IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'ID_TYPE' AND Object_ID = Object_ID(N'inparty'))
BEGIN
ALTER TABLE inparty ADD ID_TYPE VARCHAR(20)
END
GO

IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'PassPortNo' AND Object_ID = Object_ID(N'Profile_Ext'))
BEGIN
ALTER TABLE Profile_Ext ADD PassPortNo varchar(30) NULL
END
GO


IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'PassPortNo' AND Object_ID = Object_ID(N'INPARTY'))
BEGIN
ALTER TABLE INPARTY ADD PassPortNo varchar(30) NULL
END
GO
IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'Beneficiary_Name' AND Object_ID = Object_ID(N'INPARTY'))
BEGIN
ALTER TABLE INPARTY ADD Beneficiary_Name varchar(255) NULL
END
GO
IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'Beneficiary_Relation' AND Object_ID = Object_ID(N'INPARTY'))
BEGIN
ALTER TABLE INPARTY ADD Beneficiary_Relation varchar(30) NULL
END
GO


IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'WNIF' AND Object_ID = Object_ID(N'INPARTY'))
BEGIN
ALTER TABLE INPARTY ADD WNIF bit NULL
DECLARE @v sql_variant 
SET @v = N'CitizenShip Flag (0 : Non WNI/Asing, 1 : WNI)'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'INPARTY', N'COLUMN', N'WNIF'
END
GO

IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'Citizen' AND Object_ID = Object_ID(N'INPARTY'))
BEGIN
ALTER TABLE INPARTY ADD Citizen varchar(50) NULL
DECLARE @v sql_variant 
SET @v = N'Citizen Name'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'INPARTY', N'COLUMN', N'Citizen'
END
GO



IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'PIC_TITLE_1' AND Object_ID = Object_ID(N'Profile_Ext'))
BEGIN
ALTER TABLE Profile_Ext ADD	PIC_TITLE_1 varchar(50) NULL
END
GO
IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'ADDPIC_NAME_1' AND Object_ID = Object_ID(N'Profile_Ext'))
BEGIN
ALTER TABLE Profile_Ext ADD	ADDPIC_NAME_1 varchar(50) NULL
END
GO
IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'ADDPIC_TITLE_2' AND Object_ID = Object_ID(N'Profile_Ext'))
BEGIN
ALTER TABLE Profile_Ext ADD	ADDPIC_TITLE_2 varchar(50) NULL
END
GO
IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'ADDPIC_NAME_2' AND Object_ID = Object_ID(N'Profile_Ext'))
BEGIN
ALTER TABLE Profile_Ext ADD ADDPIC_NAME_2 varchar(50) NULL
END
GO
IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'ADDPIC_TITLE_3' AND Object_ID = Object_ID(N'Profile_Ext'))
BEGIN
ALTER TABLE Profile_Ext ADD ADDPIC_TITLE_3 varchar(50) NULL
END
GO
IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'ADDPIC_NAME_3' AND Object_ID = Object_ID(N'Profile_Ext'))
BEGIN
ALTER TABLE Profile_Ext ADD ADDPIC_NAME_3 varchar(50) NULL
END
GO
IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'ADDHOMEPAGE' AND Object_ID = Object_ID(N'Profile_Ext'))
BEGIN
ALTER TABLE Profile_Ext ADD ADDHOMEPAGE varchar(50) NULL
END
GO


IF EXISTS ( SELECT * FROM   sysobjects WHERE  id = object_id(N'[dbo].[QProfile_Data]') and OBJECTPROPERTY(id, N'IsProcedure') = 1 )
begin
DROP Procedure QProfile_Data
end
GO
CREATE Procedure QProfile_Data(@P_ID varchar(10))    
AS     
Select P1.*, P2.*
from Profile P1 Left Join Profile_Ext P2 on (P2.ID=P1.ID)    
Where P1.ID=@P_ID    
go

--4 agst 2017 : AUTORECEIPTPAYMENT_PROCESS
IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'Status' AND Object_ID = Object_ID(N'RPBucket'))
BEGIN
ALTER TABLE RPBucket ADD Status	varchar(1)
END
GO
IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'PID' AND Object_ID = Object_ID(N'RPBucket'))
BEGIN
ALTER TABLE RPBucket ADD PID INT
END
GO

IF EXISTS ( SELECT * FROM   sysobjects WHERE  id = object_id(N'[dbo].[AUTORECEIPTPAYMENT_PROCESS]') and OBJECTPROPERTY(id, N'IsProcedure') = 1 )
begin
DROP Procedure AUTORECEIPTPAYMENT_PROCESS
end
GO
CREATE Procedure AUTORECEIPTPAYMENT_PROCESS(@P_PDate as smalldatetime, @P_BatchNo as varchar(10))                                        
as                               
Select * from RPBucket         
where Status='R' and 
(Batchno = @P_BatchNo or @P_BatchNo = '')
order by PID ASC

GO

----ubah PNO jadi PID 

IF EXISTS(SELECT * FROM sys.columns WHERE Name = N'PNO' AND Object_ID = Object_ID(N'RPBucket'))
BEGIN
EXECUTE sp_rename N'dbo.RPBucket.PNO', N'Tmp_PID', 'COLUMN' 
END
GO
IF EXISTS(SELECT * FROM sys.columns WHERE Name = N'Tmp_PID' AND Object_ID = Object_ID(N'RPBucket'))
BEGIN
EXECUTE sp_rename N'dbo.RPBucket.Tmp_PID', N'Tmp_PID', 'COLUMN'
END
GO

-- Tambah kolom NVoucher
IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'NVoucher' AND Object_ID = Object_ID(N'RPBucket'))
ALTER TABLE RPBucket add NVoucher varchar(20)
GO
--10 agst 2017 : perbaikan inward busines
DROP PROCEDURE QRiskAssLimit
GO
CREATE PROCEDURE QRiskAssLimit (@PANO as integer, @RType as varchar(10)='')                    
AS                    
SELECT top 1 RiskAss.RiskAss, Case When ReClass.AssessmentExInwardF=1 and Cover.ISType in ('R','T') Then 100 else RiskAss.PLimit end PLimit, Case When ReClass.AssessmentExInwardF=1 and Cover.ISType in ('R','T') Then 100 else RiskAss.Limit end Limit,
Cover.ISType, RiskAss.Code, RiskAss.HoldF, RiskAss.Share, RiskAss.Rate, RiskAss.Loading, RiskAss.RType                    
From Acceptance
Inner Join Cover on (Cover.CNO=Acceptance.CNO)
Inner Join AInfo on (AInfo.ANO=Acceptance.ANO)
Inner Join RArrHeader on (RArrHeader.ANO=Acceptance.ANO)
Inner Join Reinsurance on (Reinsurance.RType In ('D','Q','S1','S2','S3','A') and RArrHeader.RDate Between Reinsurance.SDate and Reinsurance.EDate)
Inner Join ReClass on (ReClass.RNO=Reinsurance.RNO and ReClass.TOC=Acceptance.TOC and ReClass.AssessmentF=1)
Left Join RiskAss on (
	(RiskAss.RType='' or RiskAss.RType=@RType)
	And Riskass.RYear=Reinsurance.RYear And RiskAss.TOC=ReClass.TOC        
	and (RiskAss.TSILimit=0 or RArrHeader.TAmount-RArrHeader.MAmount<=RiskAss.TSILimit)                  
	And ((RiskAss.ValueID1='' and Ainfo.ValueDesc1 Like RiskAss.ValueDesc1+'%') or (RiskAss.ValueID1<>'' and AInfo.ValueID1 Like RiskAss.ValueID1+'%') or (RiskAss.ValueID1 is null))                    
	And ((RiskAss.ValueID2='' and Ainfo.ValueDesc2 Like RiskAss.ValueDesc2+'%') or (RiskAss.ValueID2<>'' and AInfo.ValueID2 Like RiskAss.ValueID2+'%') or (RiskAss.ValueID2 is null))                    
	And ((RiskAss.ValueID3='' and Ainfo.ValueDesc3 Like RiskAss.ValueDesc3+'%') or (RiskAss.ValueID3<>'' and AInfo.ValueID3 Like RiskAss.ValueID3+'%') or (RiskAss.ValueID3 is null))                    
	And ((RiskAss.ValueID4='' and Ainfo.ValueDesc4 Like RiskAss.ValueDesc4+'%') or (RiskAss.ValueID4<>'' and AInfo.ValueID4 Like RiskAss.ValueID4+'%') or (RiskAss.ValueID4 is null))                    
	And ((RiskAss.ValueID5='' and Ainfo.ValueDesc5 Like RiskAss.ValueDesc5+'%') or (RiskAss.ValueID5<>'' and AInfo.ValueID5 Like RiskAss.ValueID5+'%') or (RiskAss.ValueID5 is null))                    
	And ((RiskAss.ValueID6='' and Ainfo.ValueDesc6 Like RiskAss.ValueDesc6+'%') or (RiskAss.ValueID6<>'' and AInfo.ValueID6 Like RiskAss.ValueID6+'%') or (RiskAss.ValueID6 is null))                    
	And ((RiskAss.ValueID7='' and Ainfo.ValueDesc7 Like RiskAss.ValueDesc7+'%') or (RiskAss.ValueID7<>'' and AInfo.ValueID7 Like RiskAss.ValueID7+'%') or (RiskAss.ValueID7 is null))                    
	And ((RiskAss.ValueID8='' and Ainfo.ValueDesc8 Like RiskAss.ValueDesc8+'%') or (RiskAss.ValueID8<>'' and AInfo.ValueID8 Like RiskAss.ValueID8+'%') or (RiskAss.ValueID8 is null))                    
	And ((RiskAss.ValueID9='' and Ainfo.ValueDesc9 Like RiskAss.ValueDesc9+'%') or (RiskAss.ValueID9<>'' and AInfo.ValueID9 Like RiskAss.ValueID9+'%') or (RiskAss.ValueID9 is null))                    
	And ((RiskAss.ValueID10='' and Ainfo.ValueDesc10 Like RiskAss.ValueDesc10+'%') or (RiskAss.ValueID10<>'' and AInfo.ValueID10 Like RiskAss.ValueID10+'%') or (RiskAss.ValueID10 is null))                    
	And ((RiskAss.ValueID11='' and Ainfo.ValueDesc11 Like RiskAss.ValueDesc11+'%') or (RiskAss.ValueID11<>'' and AInfo.ValueID11 Like RiskAss.ValueID11+'%') or (RiskAss.ValueID11 is null))                    
	And ((RiskAss.ValueID12='' and Ainfo.ValueDesc12 Like RiskAss.ValueDesc12+'%') or (RiskAss.ValueID12<>'' and AInfo.ValueID12 Like RiskAss.ValueID12+'%') or (RiskAss.ValueID12 is null))                    
	And ((RiskAss.ValueID13='' and Ainfo.ValueDesc13 Like RiskAss.ValueDesc13+'%') or (RiskAss.ValueID13<>'' and AInfo.ValueID13 Like RiskAss.ValueID13+'%') or (RiskAss.ValueID13 is null))                    
	And ((RiskAss.ValueID14='' and Ainfo.ValueDesc14 Like RiskAss.ValueDesc14+'%') or (RiskAss.ValueID14<>'' and AInfo.ValueID14 Like RiskAss.ValueID14+'%') or (RiskAss.ValueID14 is null))                    
	And ((RiskAss.ValueID15='' and Ainfo.ValueDesc15 Like RiskAss.ValueDesc15+'%') or (RiskAss.ValueID15<>'' and AInfo.ValueID15 Like RiskAss.ValueID15+'%') or (RiskAss.ValueID15 is null))      
)
WHERE Acceptance.ANO=@PANO 
Order by                   
RiskAss.RYear Desc,        
RiskAss.RType Desc,            
RiskAss.PriorityF Desc,                  
len(coalesce(RiskAss.ValueID1,'')) Desc, len(coalesce(RiskAss.ValueID2,'')) Desc, len(coalesce(RiskAss.ValueID3,'')) Desc, len(coalesce(RiskAss.ValueID4,'')) Desc, len(coalesce(RiskAss.ValueID5,'')) Desc,                   
len(coalesce(RiskAss.ValueID6,'')) Desc, len(coalesce(RiskAss.ValueID7,'')) Desc, len(coalesce(RiskAss.ValueID8,'')) Desc, len(coalesce(RiskAss.ValueID9,'')) Desc, len(coalesce(RiskAss.ValueID10,'')) Desc,                   
len(coalesce(RiskAss.ValueID11,'')) Desc, len(coalesce(RiskAss.ValueID12,'')) Desc, len(coalesce(RiskAss.ValueID13,'')) Desc, len(coalesce(RiskAss.ValueID14,'')) Desc, len(coalesce(RiskAss.ValueID15,'')) Desc,                   
RiskAss.Limit Desc, RiskAss.Loading, RiskAss.HoldF        

GO
IF EXISTS ( SELECT * FROM   sysobjects WHERE  id = object_id(N'[dbo].[QREINSURANCE_CESSION]') and OBJECTPROPERTY(id, N'IsProcedure') = 1 )
begin
DROP Procedure QREINSURANCE_CESSION
end
GO
CREATE Procedure QREINSURANCE_CESSION (@P_ANO integer, @P_ADate smalldatetime, @P_RType varchar(255), @P_TSI Float=0, @P_RID varchar(20)='', @P_ManualF Bit=0, @P_GROSS Float=0)                                
as                                                          
SELECT (Case When ReClass.PriorityF=1 Then ReClass.PriorityF else Reinsurance.PriorityF end) as PriorityF, Reinsurance.RID, Reinsurance.RType,                                
ReClass.PLimit*coalesce(ReRate.Rate,1) as PLimit, 
Case RECLASS.Limit WHEN 0 then Reinsurance.Limit Else RECLASS.Limit end*coalesce(ReRate.Rate,1) as limit, 
ReClass.ShortFallLimit*coalesce(ReRate.Rate,1) as ShortFallLimit,              
ReClass.MinTSI*coalesce(ReRate.Rate,1) as MinTI, 
ReClass.AssessmentExInwardF,
Reinsurance.UjrohReins, Reinsurance.UjrohCedant, Reinsurance.Share, Reinsurance.PShare, Acceptance.FLDID, Acceptance.ValueID, ReClass.CessionF, ReClass.AssessmentF, ReClass.DirectF                                
From Acceptance       
Inner Join Cover on (Cover.CNO=Acceptance.CNO)      
Left Join RArrHeader on (RArrHeader.ANO=Acceptance.ANO)      
Inner Join Reinsurance on (Reinsurance.RType=@P_RType)      
Inner Join ReClass on (ReClass.RNO=Reinsurance.RNO and ReClass.TOC=Acceptance.TOC)      
Left Join RePolicy on (RePolicy.RNO=Reinsurance.RNO)      
Left Join ReRate on (ReRate.TOC=Acceptance.TOC and ReRate.RYear=Reinsurance.RYEAR and ReRate.Currency=Reinsurance.Currency)
Inner Join SysTab on (1=1)
WHERE ACCEPTANCE.ANO=@P_ANO         
And Case When Reinsurance.PolicyRunOffF=1 Then Acceptance.SDate else @P_ADATE end Between Reinsurance.SDate And Reinsurance.EDate         
And (@P_RID='' or Reinsurance.RID=@P_RID or RArrHeader.ManualF=0 or Acceptance.EMethod='T')                            
And (coalesce(RePolicy.ID,'')='' or  coalesce(RePolicy.ID,'')=Cover.PHolder)    
And (@P_ManualF=1 or RArrHeader.ManualF=1 or       
(      
 (Reinsurance.ORBusinessF=RArrHeader.ORBusinessF)      
 And (@P_TSI>=ReClass.MinTSI*coalesce(ReRate.Rate,1) or ReClass.MinTSI*coalesce(ReRate.Rate,1)=0) and (@P_TSI<=ReClass.MaxTSI*coalesce(ReRate.Rate,1) or ReClass.MaxTSI*coalesce(ReRate.Rate,1)=0) 
 and (@P_GROSS>=ReClass.MinGross*coalesce(ReRate.Rate,1) or ReClass.MinGross*coalesce(ReRate.Rate,1)=0) and (@P_GROSS<=ReClass.MaxGross*coalesce(ReRate.Rate,1) or ReClass.MaxGross*coalesce(ReRate.Rate,1)=0)                 
 And (    
 (datediff(month, Case When Reinsurance.PolicyRunOffF=1 then Acceptance.SDate else coalesce(RArrHeader.RDate,acceptance.sdate) end, Case When Reinsurance.PolicyRunOffF=1 then Acceptance.EDate else coalesce(RArrHeader.NRDate,Acceptance.EDate) end)>=ReClass.MinPeriod)     
 or (datediff(month, Case When Reinsurance.PolicyRunOffF=1 then Acceptance.SDate else coalesce(RArrHeader.RDate,acceptance.sdate) end, Case When Reinsurance.PolicyRunOffF=1 then Acceptance.EDate else coalesce(RArrHeader.NRDate,Acceptance.EDate) end)=ReClass.MinPeriod-1 and day(Case When Reinsurance.PolicyRunOffF=1 then Acceptance.SDate else coalesce(RArrHeader.RDate,acceptance.sdate) end)<day(Case When Reinsurance.PolicyRunOffF=1 then Acceptance.EDate else coalesce(RArrHeader.NRDate,Acceptance.EDate) end)
)     
 or ReClass.MinPeriod=0)                               
 And (    
 (datediff(month, Case When Reinsurance.PolicyRunOffF=1 then Acceptance.SDate else coalesce(RArrHeader.RDate,acceptance.sdate) end, Case When Reinsurance.PolicyRunOffF=1 then Acceptance.EDate else coalesce(RArrHeader.NRDate,Acceptance.EDate) end)<ReClass.MaxPeriod)     
 or (datediff(month, Case When Reinsurance.PolicyRunOffF=1 then Acceptance.SDate else coalesce(RArrHeader.RDate,acceptance.sdate) end, Case When Reinsurance.PolicyRunOffF=1 then Acceptance.EDate else coalesce(RArrHeader.NRDate,Acceptance.EDate) end)=ReClass.MaxPeriod and day(Case When Reinsurance.PolicyRunOffF=1 then Acceptance.SDate else coalesce(RArrHeader.RDate,acceptance.sdate) end)>=day(Case When Reinsurance.PolicyRunOffF=1 then Acceptance.EDate else coalesce(RArrHeader.NRDate,Acceptance.EDate) end))
 or ReClass.MaxPeriod=0))      
)                    
And Exists (Select Top 1 RCalc.ANO from RCalc Left Join RPartDet on (RPartDet.RNO=Reinsurance.RNO and RPartDet.TOR=RCalc.TOR) Where RCalc.ANO=Acceptance.ANO and coalesce(RPartDet.ExcludeF,0)=0)  
And (coalesce(ReRate.Rate,1)<>1 or Reinsurance.Currency=SysTab.Currency)
Order By coalesce(RePolicy.ID,'') Desc, (Case When ReClass.PriorityF=1 Then ReClass.PriorityF else Reinsurance.PriorityF end) Desc                   
  

GO

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[FL_RateCode]') AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) ) 
begin
DROP FUNCTION FL_RateCode 
end
GO
CREATE Function FL_RateCode(@P_ANO as integer, @P_Code as varchar(10),@P_AllowedF as bit=0, @P_TSI as float=0, @P_TOPF as bit=0)   
RETURNS @RateCon TABLE (Code varchar(10), AllowedF Bit, NoRefundF Bit, SIBasedID Int, Description varchar(255), Unit varchar(10), Category varchar(10), Rate Float, MinRate Float, MaxRate Float, PML Float, Portion Float, Loading Float, TExcess Float)
AS
BEGIN
Declare @Temp Table (ANO int, Code varchar(20), SIBasedID Int, Rate Float, PML Float, TExcess Int, Loading Float, AllowedF bit)  

Select @P_TSI = case When @P_TSI=0 Then 1 else @P_TSI end

Insert into @Temp  
Select Acceptance.ANO, RateTab.Code,  RateTab.SIBasedID,
(Select Top 1 Rate from fn_RateCon(Acceptance.ANO,RateTab.Code,@P_TSI) F) as Rate,  
(Select Top 1 PML from fn_RateCon(Acceptance.ANO,RateTab.Code,@P_TSI) F) as PML,  
(Select Top 1 TExcess from fn_RateCon(Acceptance.ANO,RateTab.Code,@P_TSI) F) as TExcess,  
(Select Top 1 Loading from fn_RateCon(Acceptance.ANO,RateTab.Code,@P_TSI) F) as Loading,  
(Select Top 1 AllowedF from fn_RateCon(Acceptance.ANO,RateTab.Code,@P_TSI) F) as AllowedF  
FROM  Acceptance          
Inner join Cover on (Cover.CNO=Acceptance.CNO)          
Inner join RateTab on ((RateTab.TOC=substring(Acceptance.TOC,1,len(RateTab.TOC))) and RateTab.Effective<=Acceptance.SDate and (@P_Code='%' or RateTab.Code Like @P_Code OR RateTab.Description Like @P_Code) And (RateTab.AllowedF=@P_AllowedF or @P_AllowedF=0
))            
Where Acceptance.ANO=@P_ANO  

insert into @RateCon
SELECT  RateTab.Code, RateTab.AllowedF, RateTab.NoRefundF,  RateTab.SIBasedID,            
 max(RateTab.Description) as Description,              
 max(RateTab.Unit) as Unit,              
 max(RClass.Category) AS Category,           
 sum(    
 case     
 When coalesce(Case When RateTab.Unit='F' then (Case When @P_TSI<>0 then F.Rate*@P_TSI/100 else 0 end) When RateTab.Unit='M' then F.Rate*10 else F.Rate end,0)<>0 then    
       Case When RateTab.Unit='F' then (Case When @P_TSI<>0 then F.Rate*@P_TSI/100 else 0 end) When RateTab.Unit='M' then F.Rate*10 else F.Rate end    
 else     
       RateTab.Rate    
 end*RateCov.Portion/100) as Rate,     
 cast(0 as Float) as MinRate,
 cast(0 as Float) as MaxRate,
  --in Percentage          
 max(F.PML) as PML,              
 sum(RateCov.Portion) AS Portion,              
 MAX(Case When coalesce(F.Loading,0)=0 Then 1 else F.Loading/100 end) As Loading,    
 Max(F.TExcess) as TExcess    
FROM  Acceptance          
Inner join Cover on (Cover.CNO=Acceptance.CNO)          
Inner join RateTab on ((RateTab.TOC=substring(Acceptance.TOC,1,len(RateTab.TOC))) and RateTab.Effective<=Acceptance.SDate and (@P_Code='%' or RateTab.Code Like @P_Code OR RateTab.Description Like @P_Code) And (RateTab.AllowedF=@P_AllowedF or @P_AllowedF=0
))            
Inner join RateCov on (RateCov.Code=RateTab.Code)          
Inner join RClass on (RClass.TOC=Acceptance.TOC And RClass.TOR=RateCov.TOR)          
Left Join @Temp F on (F.Code=RateTab.Code)        
Left join TOP_RATE on (TOP_RATE.TOPRO=Acceptance.TOPRO and (TOP_Rate.Code=RateTab.Code or TOP_Rate.Code=RateTab.PCode) and RateTab.effective<=Acceptance.pDate)     
WHERE  Acceptance.ANO=@P_ANO
and 
(
not exists (Select Top 1 RateCon.Code from RateCon Where RateCon.Code=RateTab.Code) or not F.Rate is null
)
and (@P_TOPF=0 or coalesce(TOP_RATE.TOPRO,'')=Acceptance.TOPRO)
GROUP BY RateTab.Code, RateTab.AllowedF, RateTab.NoRefundF  , RateTab.SIBasedID  

RETURN
END

go

-- perbaikan Setup Ratetab
 IF EXISTS ( SELECT * FROM   sysobjects WHERE  id = object_id(N'QRate_Ratcon') and OBJECTPROPERTY(id, N'IsProcedure') = 1 ) BEGIN DROP PROCEDURE QRate_Ratcon END
 GO
 CREATE PROCEDURE QRate_Ratcon (@CODE Varchar(10) )      
AS      
 BEGIN      
 SELECT CAST(0 As Bit) ProcessFlag, RATECON, CODE, 
  coalesce(CAST(MinTSI AS INT), 0)+' - '+coalesce(CAST(MaxTSI AS INT), 0) as TSI, 
 coalesce(CAST(MinRate AS INT), 0) + ' - ' + coalesce(CAST(MaxRate AS INT), 0) as 'RATEP', 
 coalesce(CAST(MINPERIOD AS INT), 0) + ' - ' + coalesce(CAST(MAXPERIOD AS INT), 0) as 'Coverage',
 TEXCESS, ALLOWEDF, LOADING from RateCon where CODE = @CODE 
 END
 GO

 -- 10 agst 2017 : update claim controller
IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'FL_Controller') AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) ) 
BEGIN DROP FUNCTION FL_Controller END
GO
CREATE function FL_Controller(@P_CNO int)        
RETURNS Table          
AS RETURN          
(        
 Select SysUser.*
 From sysuser,  Claim
 Where (SysUser.Role in ('COMMON','CONTROLLER') Or SysUser.ARole in ('COMMON','CONTROLLER')) and SysUser.AllowedF=1 and Claim.CNO=@P_CNO
 and (SysUser.Type='SUPERVISOR' or Claim.Branch in (Select S.Branch from SysUserBranch S Where  S.AllowedF=1 and S.ID=SysUser.ID))    
) 

GO


IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'CT' AND Object_ID = Object_ID(N'CLAIM'))
BEGIN
ALTER TABLE CLAIM ADD CT varchar(10) NULL
DECLARE @v sql_variant 
SET @v = N'Profit/Cost Center Handling (see Claim.Branch Handling)'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'CLAIM', N'COLUMN', N'CT'
END
GO
IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'SysUserID' AND Object_ID = Object_ID(N'CLAIM'))
BEGIN
ALTER TABLE CLAIM ADD SysUserID varchar(50) NULL
DECLARE @v sql_variant 
SET @v = N'Claim Controller (see SysUser with Role Controller/Common)'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'CLAIM', N'COLUMN', N'SysUserID'
END
GO

IF EXISTS ( SELECT * FROM   sysobjects WHERE  id = object_id(N'[dbo].[QClaim_Data]') and OBJECTPROPERTY(id, N'IsProcedure') = 1 )
begin
DROP Procedure QClaim_Data
end
GO
CREATE Procedure QClaim_Data(@P_CNO integer) 
as 
SELECT CNO, ANO, EVENTNO, CLAIMNO, REGDATE,REFNO,REFDATE,REFTIME, POLICYNO, CERTIFICATENO, CLAIMANT, CLAIMANTINFO, PAYMENT, TOC, COL, EVENTNAME, LOCATION, LOSSPLACE, LOSSDATE, LOSSTIME, DESCRIPTION, SURVEYOR, ASSESSOR, BRANCH, 
UserID, CDate, CTime, 
LUSERID, LDate, LTime, 
PUSERID, PUserDate, PUserTime, 
AUSERID, AUserDate, AUserTime, 
CUserID, CloseDate, CloseTime, 
EXGRATIAF, TBAF_1, TBAF_2, (TBAF_1 | TBAF_2) as TBAF, CSTATUS, 
CType, PCSTATUS, VSEQNO, CSEQNO, ISTYPE, 
ASource, BackDatedF, SettledF, CT, SysUserID
FROM CLAIM C1 
WHERE C1.CNO=@P_CNO 
go

IF EXISTS ( SELECT * FROM   sysobjects WHERE  id = object_id(N'[dbo].[QClaimInfo_Data]') and OBJECTPROPERTY(id, N'IsProcedure') = 1 )
begin
DROP Procedure QClaimInfo_Data
end
GO
CREATE PROCEDURE QClaimInfo_Data(@P_CNO integer)              
as              
SELECT     
C1.CNO, C1.ANO, C1.ClaimNo, C1.PolicyNo, C1.CertificateNo, C1.Description, C1.Remarks, C1.Comment,        
C1.UniqueF, C1.LargeF, C1.SurveyF, C1.Reason,
C3.Loss,         
C3.Deductible,        
C3.Salvage,        
C3.Cost,        
C3.Subrogation,        
C3.Claim,         
C3.Reserved,        
C4.ETShare,        
C4.ERetention,        
C2.FLDID1, C2.VALUEID1, C2.VALUEDESC1, 0 as FLDSEARCH1,                
C2.FLDID2, C2.VALUEID2, C2.VALUEDESC2, 0 as FLDSEARCH2,                
C2.FLDID3, C2.VALUEID3, C2.VALUEDESC3, 0 as FLDSEARCH3,                
C2.FLDID4, C2.VALUEID4, C2.VALUEDESC4, 0 as FLDSEARCH4,                
C2.FLDID5, C2.VALUEID5, C2.VALUEDESC5, 0 as FLDSEARCH5,                
C2.FLDID6, C2.VALUEID6, C2.VALUEDESC6, 0 as FLDSEARCH6,                
C2.FLDID7, C2.VALUEID7, C2.VALUEDESC7, 0 as FLDSEARCH7,                
C2.FLDID8, C2.VALUEID8, C2.VALUEDESC8, 0 as FLDSEARCH8,                
C2.FLDID9, C2.VALUEID9, C2.VALUEDESC9, 0 as FLDSEARCH9,                
C2.FLDID10, C2.VALUEID10, C2.VALUEDESC10, 0 as FLDSEARCH10,                
C2.FLDID11, C2.VALUEID11, C2.VALUEDESC11, 0 as FLDSEARCH11,                
C2.FLDID12, C2.VALUEID12, C2.VALUEDESC12, 0 as FLDSEARCH12,                
C2.FLDID13, C2.VALUEID13, C2.VALUEDESC13, 0 as FLDSEARCH13,                
C2.FLDID14, C2.VALUEID14, C2.VALUEDESC14, 0 as FLDSEARCH14,                
C2.FLDID15, C2.VALUEID15, C2.VALUEDESC15, 0 as FLDSEARCH15,
C1.SysUserID       
FROM CLAIM C1         
Left Join CINFO C2 on (C2.CNO=C1.CNO)         
Left Join QClaim_CCalc() C3 on (C3.CNO=C1.CNO)         
Left Join CArrHeader C4 on (C4.CNO=C1.CNO)        
WHERE C1.CNO=@P_CNO    
go



-- Immediate inforce
IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'ImmediateInforceF' AND Object_ID = Object_ID(N'SysBatchOriginalSC'))
BEGIN
ALTER TABLE SysBatchOriginalSC ADD ImmediateInforceF varchar(255) NULL
END
GO
IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'InforceF' AND Object_ID = Object_ID(N'SysBatchOriginalSC'))
BEGIN
ALTER TABLE SysBatchOriginalSC ADD InforceF varchar(255) NULL
END
GO
IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'InforceBulkF' AND Object_ID = Object_ID(N'SysBatchOriginalSC'))
BEGIN
ALTER TABLE SysBatchOriginalSC ADD InforceBulkF varchar(255) NULL
END
GO
IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'ImmediateInforceF' AND Object_ID = Object_ID(N'SysBatchSC'))
BEGIN
ALTER TABLE SysBatchSC ADD ImmediateInforceF varchar(255) NULL
END
GO
IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'InforceF' AND Object_ID = Object_ID(N'SysBatchSC'))
BEGIN
ALTER TABLE SysBatchSC ADD InforceF varchar(255) NULL
END
GO
IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'InforceBulkF' AND Object_ID = Object_ID(N'SysBatchSC'))
BEGIN
ALTER TABLE SysBatchSC ADD InforceBulkF varchar(255) NULL
END
GO

ALTER TABLE SysBatchOriginalSC ALTER COLUMN ImmediateInforceF varchar(255) NULL
GO
ALTER TABLE SysBatchOriginalSC ALTER COLUMN InforceF varchar(255) NULL
GO
ALTER TABLE SysBatchOriginalSC ALTER COLUMN InforceBulkF varchar(255) NULL
GO
ALTER TABLE SysBatchSC ALTER COLUMN ImmediateInforceF varchar(255) NULL
GO
ALTER TABLE SysBatchSC ALTER COLUMN InforceF varchar(255) NULL
GO
ALTER TABLE SysBatchSC ALTER COLUMN InforceBulkF varchar(255) NULL
go


-- 11 agst 2017 

IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'NOCANCELF' AND Object_ID = Object_ID(N'TOC'))
BEGIN
ALTER TABLE TOC ADD	NOCANCELF bit NULL
DECLARE @v sql_variant 
SET @v = N'No Data Cancellation of This Policy Coverage (0 : No, 1 : Yes) Except Authorized (ALLOWCANCELDATA)'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'TOC', N'COLUMN', N'NOCANCELF'
END
GO


IF NOT EXISTS(SELECT * FROM SysForm WHERE FNAME='ALLOWCANCELDATA')
BEGIN
insert into SysForm(FName, Description, FCode)
Select 'ALLOWCANCELDATA', 'Allow Cancel Data - See No Cancel Data Option (UW)','ACTIVITIES'
END
GO

--11 agst 2017 (1)

IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'DOCNO' AND Object_ID = Object_ID(N'RPART'))
BEGIN
ALTER TABLE RPART ADD DOCNO varchar(20) NULL
DECLARE @v sql_variant 
SET @v = N'Reinsurance Document Number (For SOA Grouping)'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'RPART', N'COLUMN', N'DOCNO'
END
GO

IF NOT EXISTS (SELECT *  FROM sys.indexes WHERE name='I_RPart_DocNo_ID' AND object_id = OBJECT_ID('RPart'))
BEGIN
Create Index I_RPart_DocNo_ID on RPart(DocNo, ID)
END
GO
IF EXISTS ( SELECT * FROM   sysobjects WHERE  id = object_id(N'[dbo].[QRCESSION]') and OBJECTPROPERTY(id, N'IsProcedure') = 1 )
begin
DROP Procedure QRCESSION
end
GO
CREATE Procedure QRCESSION (@P_RID varchar(255))      
as      
Select R1.ID, R1.SHARE, R1.COMM, R1.COMMI, R1.COMMN, R1.JP,
R2.RID, R2.CESSION, CASE WHEN COALESCE(R1.DOCNO,'')='' THEN R2.DOCNO ELSE R1.DOCNO END AS DOCNO, R2.LIMIT, R2.MDP, R2.CASHLOSS, R2.PRIORITYF, R2.STATEMENT, R2.UJROHREINS, R2.UJROHCEDANT, R2.TPPERIOD, R2.POLICYRUNOFFF  
from RPart R1, Reinsurance R2
WHERE R1.RNO = R2.RNO and R2.RID=@P_RID AND R1.SHARE<>0      
GO

IF EXISTS ( SELECT * FROM   sysobjects WHERE  id = object_id(N'[dbo].[QCLAIMRCESSION]') and OBJECTPROPERTY(id, N'IsProcedure') = 1 )
begin
DROP Procedure QCLAIMRCESSION
end
GO
CREATE Procedure QCLAIMRCESSION (@P_RID varchar(255), @P_CNO int)      
as      
SELECT RPART.ID, RPART.SHARE, RPART.JP, 
REINSURANCE.RID, REINSURANCE.CESSION, 
CASE WHEN COALESCE(RPART.DOCNO,'')='' THEN REINSURANCE.DOCNO ELSE RPART.DOCNO END AS DOCNO,
Case When Event.Category='E' and RECLASS.ELIMIT<>0 Then RECLASS.ELIMIT Else (Case WHEN RECLASS.Limit=0 THEN Reinsurance.Limit Else RECLASS.Limit end) End*Case When coalesce(ReRate.CRate,0)<>0 Then coalesce(ReRate.CRate,0) else coalesce(ReRate.Rate,1) end as Limit,
REINSURANCE.CASHLOSS*Case When coalesce(ReRate.CRate,0)<>0 Then coalesce(ReRate.CRate,0) else coalesce(ReRate.Rate,1) end as CASHLOSS, 
REINSURANCE.PRIORITYF,      
CASE WHEN EVENT.CATEGORY<>'E' OR REINSURANCE.EREINSTATEMENT=0 THEN REINSURANCE.REINSTATEMENT ELSE REINSURANCE.EREINSTATEMENT END AS REINSTATEMENT,     
CASE WHEN EVENT.CATEGORY<>'E' OR REINSURANCE.EREINSTATEMENT_1=0 THEN REINSURANCE.REINSTATEMENT_1 ELSE REINSURANCE.EREINSTATEMENT_1 END AS REINSTATEMENT_1,     
CASE WHEN EVENT.CATEGORY<>'E' OR REINSURANCE.EREINSTATEMENT_2=0 THEN REINSURANCE.REINSTATEMENT_2 ELSE REINSURANCE.EREINSTATEMENT_2 END AS REINSTATEMENT_2,     
CASE WHEN EVENT.CATEGORY<>'E' OR REINSURANCE.EREINSTATEMENT_3=0 THEN REINSURANCE.REINSTATEMENT_3 ELSE REINSURANCE.EREINSTATEMENT_3 END AS REINSTATEMENT_3,     
CASE WHEN EVENT.CATEGORY<>'E' OR REINSURANCE.EAP_1=0 THEN REINSURANCE.AP_1 ELSE REINSURANCE.EAP_1 END AS AP_1,     
CASE WHEN EVENT.CATEGORY<>'E' OR REINSURANCE.EAP_2=0 THEN REINSURANCE.AP_2 ELSE REINSURANCE.EAP_2 END AS AP_2,     
CASE WHEN EVENT.CATEGORY<>'E' OR REINSURANCE.EAP_3=0 THEN REINSURANCE.AP_3 ELSE REINSURANCE.EAP_3 END AS AP_3    
From REINSURANCE
INNER JOIN CLAIM ON (CLAIM.CNO=@P_CNO)
INNER JOIN RPART ON (RPART.RNO=REINSURANCE.RNO AND RPART.SHARE<>0)
INNER JOIN RECLASS ON (RECLASS.RNO=REINSURANCE.RNO AND RECLASS.TOC=CLAIM.TOC)
LEFT JOIN Event ON (Event.EventNo=Claim.EventNo)
Left Join ReRate on (ReRate.TOC=Claim.TOC and ReRate.RYear=REINSURANCE.RYEAR and ReRate.Currency=REINSURANCE.Currency)
Inner Join SysTab on (1=1)
WHERE REINSURANCE.RID=@P_RID 
-- If Risk is Excluded      
AND NOT EXISTS (SELECT TOP 1 1 FROM RPARTDET, LCALC WHERE LCALC.CNO=CLAIM.CNO AND RPARTDET.RNO=RPART.RNO AND RPARTDET.ID=RPART.ID AND RPARTDET.TOR=LCALC.TOR AND RPARTDET.EXCLUDEF=1)      
-- If Risk is Excluded      
AND NOT EXISTS (SELECT TOP 1 1 FROM RCALC, LCALC WHERE LCALC.CNO=CLAIM.CNO AND RCALC.ANO=CLAIM.ANO AND RCALC.TOR=LCALC.TOR AND RCALC.EXTREATYF=1)     
and (Case When coalesce(ReRate.CRate,0)<>0 Then coalesce(ReRate.CRate,0) else coalesce(ReRate.Rate,1) end<>1 or REINSURANCE.Currency=SysTab.Currency)

go

--VERSIONING
insert into versioning
select '2017 V.2.5.0',GETDATE(),'2017 V.2.0.0',GETDATE(),'K: 2017 V.2.0.0',GETDATE()
go



Declare @PrevScript varchar(100)
Declare @CurrScript varchar(100)

Select @PrevScript='13 Script Komulatif Konsol 2.4'
Select @CurrSCript='14 Script Komulatif Konsol 2.5'


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
