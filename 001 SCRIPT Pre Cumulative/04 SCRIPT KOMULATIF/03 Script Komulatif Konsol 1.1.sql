IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[FL_UW_Ded]') AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) ) 
BEGIN DROP FUNCTION [dbo].[FL_UW_Ded] END
GO
CREATE FUNCTION FL_UW_Ded(@P_ANO as integer, @P_DCode as varchar(255), @P_TOPF as bit=0)  
RETURNS TABLE  
As Return (  
Select Distinct DedTab.*   
From RCOVER  
Inner Join RATECOV on RATECOV.CODE = RCOVER.CODE  
Inner Join DedTab on DeDTab.TOR = RateCov.TOR   
Inner Join TOR on (TOR.TOR=DedTab.TOR)
Inner Join Acceptance on Acceptance.ANO = RCover.ANO  
Left join TOP_Deductible on TOP_Deductible.TOPRO=Acceptance.TOPRO and TOP_Deductible.DCode=DedTab.DCode   
WHERE RCOVER.ANO=@P_ANO and DedTab.ALLOWEDF=1 
AND (DedTab.DCode Like @P_DCode OR DedTab.Remarks Like @P_DCode)  
and (@P_TOPF=0 or coalesce(TOP_Deductible.TOPRO,'')=Acceptance.TOPRO)   
AND (coalesce(ValueID1L,'') in ('<All>','') OR EXISTS (SELECT TOP 1 * FROM ACCSEARCH WHERE ACCSEARCH.ANO=@P_ANO AND TOR.RFLDID1=ACCSEARCH.FLDID and right(space(15)+ACCSEARCH.VALUEID,15) Between right(space(15)+ValueID1L,15) and (Case When ValueID1U in ('') then right(space(15)+ValueID1L,15) else right(space(15)+ValueID1U,15) end)))
AND (coalesce(ValueID2L,'') in ('<All>','') OR EXISTS (SELECT TOP 1 * FROM ACCSEARCH WHERE ACCSEARCH.ANO=@P_ANO AND TOR.RFLDID2=ACCSEARCH.FLDID and right(space(15)+ACCSEARCH.VALUEID,15) Between right(space(15)+ValueID2L,15) and (Case When ValueID2U in ('') then right(space(15)+ValueID2L,15) else right(space(15)+ValueID2U,15) end)))
AND (coalesce(ValueID3L,'') in ('<All>','') OR EXISTS (SELECT TOP 1 * FROM ACCSEARCH WHERE ACCSEARCH.ANO=@P_ANO AND TOR.RFLDID3=ACCSEARCH.FLDID and right(space(15)+ACCSEARCH.VALUEID,15) Between right(space(15)+ValueID3L,15) and (Case When ValueID3U in ('') then right(space(15)+ValueID3L,15) else right(space(15)+ValueID3U,15) end)))
AND (coalesce(ValueID4L,'') in ('<All>','') OR EXISTS (SELECT TOP 1 * FROM ACCSEARCH WHERE ACCSEARCH.ANO=@P_ANO AND TOR.RFLDID4=ACCSEARCH.FLDID and right(space(15)+ACCSEARCH.VALUEID,15) Between right(space(15)+ValueID4L,15) and (Case When ValueID4U in ('') then right(space(15)+ValueID4L,15) else right(space(15)+ValueID4U,15) end)))
AND (coalesce(ValueID5L,'') in ('<All>','') OR EXISTS (SELECT TOP 1 * FROM ACCSEARCH WHERE ACCSEARCH.ANO=@P_ANO AND TOR.RFLDID5=ACCSEARCH.FLDID and right(space(15)+ACCSEARCH.VALUEID,15) Between right(space(15)+ValueID5L,15) and (Case When ValueID5U in ('') then right(space(15)+ValueID5L,15) else right(space(15)+ValueID5U,15) end)))
) 

go

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[fn_RateCon]') AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) ) BEGIN DROP FUNCTION [dbo].[fn_RateCon] END
GO
CREATE FUNCTION fn_RateCon(@P_ANO as int,@P_Code as varchar(20),@P_TSI as Float=0)       
RETURNS Table       
AS RETURN (       
Select Top 1 *
From
(
       SELECT Top 1 RateTab.Code, RateCon.AllowedF, RateCon.MinRate, RateCon.MaxRate, RateCon.PML, RateCon.TExcess, RateTab.RateLoadingF,       
       Case When coalesce(RateCon.Loading,0)=0 Then 100 else RateCon.Loading end as Loading,       
       Case When coalesce(RateCon.PCTLOSS,0)=0 Then 100 else RateCon.PCTLOSS end as PCTLOSS,       
       --Rate Always in Percent       
       Case       
       When RateCon.Unit='F' then (Case When (Case When @P_TSI=0 Then 1 Else @P_TSI End)<>0 Then RateCon.Rate/(Case When @P_TSI=0 Then 1 Else @P_TSI End)*100 else 0 end)       
       When RateCon.Unit='M' then RateCon.Rate/10       
       else RateCon.Rate end as Rate       
       From Acceptance       
       INNER JOIN AInfo on (AInfo.ANO=Acceptance.ANO)       
       INNER JOIN COVER ON (COVER.CNO=ACCEPTANCE.CNO)       
       INNER JOIN RateTab ON (RateTab.Effective<=Acceptance.SDate and (@P_Code='%' or RateTab.Code Like @P_Code or RateTab.PCode Like @P_Code))       
       INNER JOIN RateCon on (    
        RateTab.TOC=Cover.TOC and RateCon.Code=RateTab.Code And ((Case When @P_TSI=0 Then 1 Else @P_TSI End)>=RateCon.MinTSI or RateCon.MinTSI=0) and ((Case When @P_TSI=0 Then 1 Else @P_TSI End)<=RateCon.MaxTSI or RateCon.MaxTSI=0)     
        And RateCon.ALLOWEDF=1
       And RateCon.ProgressiveF=0
       And (
       (RateTab.SPeriod=0 and (    
        (datediff(month, acceptance.sdate, acceptance.edate)>=RateCon.MinPeriod)     
        or (datediff(month, acceptance.sdate, acceptance.edate)=RateCon.MinPeriod-1 and day(acceptance.sdate)<day(acceptance.edate))     
        or RateCon.MinPeriod=0)                               
        And (    
        (datediff(month, acceptance.sdate, acceptance.edate)<RateCon.MaxPeriod)     
        or (datediff(month, acceptance.sdate, acceptance.edate)=RateCon.MaxPeriod and day(acceptance.sdate)>=day(acceptance.edate))     
        or RateCon.MaxPeriod=0)) OR
       (RateTab.SPeriod=1 
        and ((datediff(day, acceptance.sdate, acceptance.edate)>=RateCon.MinPeriod) or RateCon.MinPeriod=0)
       And ((datediff(day, acceptance.sdate, acceptance.edate)<=RateCon.MaxPeriod) or RateCon.MaxPeriod=0))
       )     
       ) 
       WHERE Acceptance.ANO=@P_ANO       
       And (coalesce(RateCon.ValueID1,'')='' or AINFO.VALUEID1 =RateCon.ValueID1)       
       And (coalesce(RateCon.ValueID2,'')='' or AINFO.VALUEID2 =RateCon.ValueID2)       
       And (coalesce(RateCon.ValueID3,'')='' or AINFO.VALUEID3 =RateCon.ValueID3)       
       And (coalesce(RateCon.ValueID4,'')='' or AINFO.VALUEID4 =RateCon.ValueID4)       
       And (coalesce(RateCon.ValueID5,'')='' or AINFO.VALUEID5 =RateCon.ValueID5)       
       And (coalesce(RateCon.ValueID6,'')='' or AINFO.VALUEID6 =RateCon.ValueID6)       
       And (coalesce(RateCon.ValueID7,'')='' or AINFO.VALUEID7 =RateCon.ValueID7)       
       And (coalesce(RateCon.ValueID8,'')='' or AINFO.VALUEID8 =RateCon.ValueID8)       
       And (coalesce(RateCon.ValueID9,'')='' or AINFO.VALUEID9 =RateCon.ValueID9)       
       And (coalesce(RateCon.ValueID10,'')='' or AINFO.VALUEID10 =RateCon.ValueID10)       
       And (coalesce(RateCon.ValueID11,'')='' or AINFO.VALUEID11 =RateCon.ValueID11)       
       And (coalesce(RateCon.ValueID12,'')='' or AINFO.VALUEID12 =RateCon.ValueID12)       
       And (coalesce(RateCon.ValueID13,'')='' or AINFO.VALUEID13 =RateCon.ValueID13)       
       And (coalesce(RateCon.ValueID14,'')='' or AINFO.VALUEID14 =RateCon.ValueID14)       
       And (coalesce(RateCon.ValueID15,'')='' or AINFO.VALUEID15 =RateCon.ValueID15)       
       Order by       
       RateTab.Effective Desc,       
       len(coalesce(RateCon.ValueID1,'')) Desc,       
       len(coalesce(RateCon.ValueID2,'')) Desc,       
       len(coalesce(RateCon.ValueID3,'')) Desc,       
       len(coalesce(RateCon.ValueID4,'')) Desc,       
       len(coalesce(RateCon.ValueID5,'')) Desc,       
       len(coalesce(RateCon.ValueID6,'')) Desc,       
       len(coalesce(RateCon.ValueID7,'')) Desc,       
       len(coalesce(RateCon.ValueID8,'')) Desc,       
       len(coalesce(RateCon.ValueID9,'')) Desc,       
       len(coalesce(RateCon.ValueID10,'')) Desc,       
       len(coalesce(RateCon.ValueID11,'')) Desc,       
       len(coalesce(RateCon.ValueID12,'')) Desc,       
       len(coalesce(RateCon.ValueID13,'')) Desc,       
       len(coalesce(RateCon.ValueID14,'')) Desc,       
       len(coalesce(RateCon.ValueID15,'')) Desc       

       UNION ALL

       SELECT RateTab.Code, 
       Cast(Max(Cast(RateCon.AllowedF as Int)) as Bit) as AllowedF, 
       sum(Case When (Case When @P_TSI=0 Then 1 Else @P_TSI End)>=RateCon.MaxTSI Then RateCon.MaxTSI-RateCon.MinTSI Else (Case When @P_TSI=0 Then 1 Else @P_TSI End)-RateCon.MinTSI end*RateCon.MinRate/(Case When @P_TSI=0 Then 1 Else @P_TSI End)) as MinRate,
       sum(Case When (Case When @P_TSI=0 Then 1 Else @P_TSI End)>=RateCon.MaxTSI Then RateCon.MaxTSI-RateCon.MinTSI Else (Case When @P_TSI=0 Then 1 Else @P_TSI End)-RateCon.MinTSI end*RateCon.MaxRate/(Case When @P_TSI=0 Then 1 Else @P_TSI End)) as MaxRate,
       Max(RateCon.PML) as PML, 
       Max(RateCon.TExcess) as TExcess, 
       cast(Max(cast(RateTab.RateLoadingF as Int)) as Bit) as RateLoadingF,       
       Max(Case When coalesce(RateCon.Loading,0)=0 Then 100 else RateCon.Loading end) as Loading,       
       Max(Case When coalesce(RateCon.PCTLOSS,0)=0 Then 100 else RateCon.PCTLOSS end) as PCTLOSS,       
       --Rate Always in Percent       
       sum(
       Case       
       When RateCon.Unit='F' then (Case When (Case When @P_TSI=0 Then 1 Else @P_TSI End)<>0 Then RateCon.Rate/(Case When @P_TSI=0 Then 1 Else @P_TSI End)*100 else 0 end)       
       When RateCon.Unit='M' then 
             Case When (Case When @P_TSI=0 Then 1 Else @P_TSI End)>=RateCon.MaxTSI Then RateCon.MaxTSI-RateCon.MinTSI Else (Case When @P_TSI=0 Then 1 Else @P_TSI End)-RateCon.MinTSI end*RateCon.Rate/10/(Case When @P_TSI=0 Then 1 Else @P_TSI End) 
       else Case When (Case When @P_TSI=0 Then 1 Else @P_TSI End)>=RateCon.MaxTSI Then RateCon.MaxTSI-RateCon.MinTSI Else (Case When @P_TSI=0 Then 1 Else @P_TSI End)-RateCon.MinTSI end*RateCon.Rate/(Case When @P_TSI=0 Then 1 Else @P_TSI End) end 
       )as Rate       
       From Acceptance       
       INNER JOIN AInfo on (AInfo.ANO=Acceptance.ANO)       
       INNER JOIN COVER ON (COVER.CNO=ACCEPTANCE.CNO)       
       INNER JOIN RateTab ON (RateTab.Effective<=Acceptance.SDate and (@P_Code='%' or RateTab.Code Like @P_Code or RateTab.PCode Like @P_Code))       
       INNER JOIN RateCon on (    
        RateTab.TOC=Cover.TOC and RateCon.Code=RateTab.Code 
        And ((Case When @P_TSI=0 Then 1 Else @P_TSI End) Between RateCon.MinTSI and RateCon.MaxTSI or RateCon.MaxTSI<=(Case When @P_TSI=0 Then 1 Else @P_TSI End))
       And RateCon.ALLOWEDF=1
       And RateCon.ProgressiveF=1
       And (
       (RateTab.SPeriod=0 and (    
        (datediff(month, acceptance.sdate, acceptance.edate)>=RateCon.MinPeriod)     
        or (datediff(month, acceptance.sdate, acceptance.edate)=RateCon.MinPeriod-1 and day(acceptance.sdate)<day(acceptance.edate))     
        or RateCon.MinPeriod=0)                               
        And (    
        (datediff(month, acceptance.sdate, acceptance.edate)<RateCon.MaxPeriod)     
        or (datediff(month, acceptance.sdate, acceptance.edate)=RateCon.MaxPeriod and day(acceptance.sdate)>=day(acceptance.edate))     
        or RateCon.MaxPeriod=0)) OR
       (RateTab.SPeriod=1 
        and ((datediff(day, acceptance.sdate, acceptance.edate)>=RateCon.MinPeriod) or RateCon.MinPeriod=0)
       And ((datediff(day, acceptance.sdate, acceptance.edate)<=RateCon.MaxPeriod) or RateCon.MaxPeriod=0))
       )     
       ) 
       WHERE Acceptance.ANO=@P_ANO       
       And (coalesce(RateCon.ValueID1,'')='' or AINFO.VALUEID1 =RateCon.ValueID1)       
       And (coalesce(RateCon.ValueID2,'')='' or AINFO.VALUEID2 =RateCon.ValueID2)       
       And (coalesce(RateCon.ValueID3,'')='' or AINFO.VALUEID3 =RateCon.ValueID3)       
       And (coalesce(RateCon.ValueID4,'')='' or AINFO.VALUEID4 =RateCon.ValueID4)       
       And (coalesce(RateCon.ValueID5,'')='' or AINFO.VALUEID5 =RateCon.ValueID5)       
       And (coalesce(RateCon.ValueID6,'')='' or AINFO.VALUEID6 =RateCon.ValueID6)       
       And (coalesce(RateCon.ValueID7,'')='' or AINFO.VALUEID7 =RateCon.ValueID7)       
       And (coalesce(RateCon.ValueID8,'')='' or AINFO.VALUEID8 =RateCon.ValueID8)       
       And (coalesce(RateCon.ValueID9,'')='' or AINFO.VALUEID9 =RateCon.ValueID9)       
       And (coalesce(RateCon.ValueID10,'')='' or AINFO.VALUEID10 =RateCon.ValueID10)       
       And (coalesce(RateCon.ValueID11,'')='' or AINFO.VALUEID11 =RateCon.ValueID11)       
       And (coalesce(RateCon.ValueID12,'')='' or AINFO.VALUEID12 =RateCon.ValueID12)       
       And (coalesce(RateCon.ValueID13,'')='' or AINFO.VALUEID13 =RateCon.ValueID13)       
       And (coalesce(RateCon.ValueID14,'')='' or AINFO.VALUEID14 =RateCon.ValueID14)       
       And (coalesce(RateCon.ValueID15,'')='' or AINFO.VALUEID15 =RateCon.ValueID15)       
       Group By RateTab.Code
) R
)       
go


IF Not EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Province]') AND type in (N'U'))
begin
CREATE TABLE [dbo].[Province](
	[Province] [varchar](10) NOT NULL,
	[Description] [varchar](50) NULL,
	[AllowedF] [bit] NULL,
	[Last_Update] [smalldatetime] NULL,
	[Last_OPR] [varchar](10) NULL,
 CONSTRAINT [I_Province] PRIMARY KEY CLUSTERED 
(
	[Province] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
end

go


IF  NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ICPS_PROFILE]') AND type in (N'U'))
BEGIN
DROP VIEW [dbo].[ICPS_PROFILE]     
END
GO

alter table profile alter column salutation Nvarchar(100)
GO

CREATE VIEW [dbo].[ICPS_PROFILE]       
WITH SCHEMABINDING      
AS        
SELECT Case When LOB='13' then 'RepairShop' else 'Supplier' end as RefSource, ID, SALUTATION, FIRSTNAME, MIDNAME, LASTNAME, LOB,     
NAME, INITIAL, ADDRESS_1, ADDRESS_2, ADDRESS_3, CITY, ZIPCODE, PHONE_1, PHONE_2, MOBILE_1, MOBILE_2, FAX_1, FAX_2, EMAIL, EMAIL_2,       
CONTACT, CONTACTADDRESS, CONTACTPHONE, TITLE,       
TAXID, TAXNAME, TAXADDRESS, VATF, TAXF, TAXTYPE, VAT, TAX, TAXPCT, LAST_OPR, LAST_UPDATE     
FROM dbo.PROFILE      
WHERE LOB IN ('13', '14')   
go

IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'Description_1' AND Object_ID = Object_ID(N'province'))
BEGIN
alter table province add Description_1 nvarchar(50)
end
go

update province set Description_1 = '' where Description_1 is null
GO

IF  NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[District]') AND type in (N'U'))
BEGIN
CREATE TABLE dbo.District
	(
	District nvarchar(50) NOT NULL,
	Description nvarchar(100) NULL,
	Description_1 nvarchar(100) NULL,
	Province varchar(10) NULL,
	AllowedF bit NULL,
	Last_Update smalldatetime NULL,
	Last_OPR varchar(10) NULL
	)  ON [PRIMARY]
ALTER TABLE dbo.District ADD CONSTRAINT
	PK_District PRIMARY KEY CLUSTERED 
	(
	District
	) WITH( STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
END
GO


IF  NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SubDistrict]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[SubDistrict](
	[SubDistrict] [nvarchar](50) NOT NULL,
	[Description] [nvarchar](100) NULL,
	[Description_1] [nvarchar](100) NULL,
	[Province] [varchar](10) NULL,
	[District] [nvarchar](50) NULL,
	[ZipCode] [varchar](20) NULL,
	[AllowedF] [bit] NULL,
	[Last_Update] [smalldatetime] NULL,
	[Last_OPR] [varchar](10) NULL,
 CONSTRAINT [I_SubDistrict] PRIMARY KEY CLUSTERED 
(
	[SubDistrict] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
END
GO



