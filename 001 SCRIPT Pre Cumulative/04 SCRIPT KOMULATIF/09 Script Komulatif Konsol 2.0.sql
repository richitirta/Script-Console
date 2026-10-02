--PERBAIKAN F2 DEDUCTIBLE
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

-- 3 Apr 2017 : Lookup Salutation

IF  NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Salutation]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[Salutation](
	[Salutation] [varchar](10) NULL
) ON [PRIMARY]
CREATE UNIQUE INDEX I_SALUTATION ON SALUTATION(SALUTATION)
end
GO
IF NOT EXISTS(SELECT * FROM Salutation WHERE Salutation='N/A')
BEGIN
insert into Salutation values('N/A')
end
GO
IF NOT EXISTS(SELECT * FROM Salutation WHERE Salutation='PD')
BEGIN
insert into Salutation values('PD')
end
GO
IF NOT EXISTS(SELECT * FROM Salutation WHERE Salutation='PT')
BEGIN
insert into Salutation values('PT')
end
GO
IF NOT EXISTS(SELECT * FROM Salutation WHERE Salutation='CV')
BEGIN
insert into Salutation values('CV')
end
GO
IF NOT EXISTS(SELECT * FROM Salutation WHERE Salutation='Mr')
BEGIN
insert into Salutation values('Mr')
end
GO
IF NOT EXISTS(SELECT * FROM Salutation WHERE Salutation='Mrs')
BEGIN
insert into Salutation values('Mrs')
end
GO
IF NOT EXISTS(SELECT * FROM Salutation WHERE Salutation='Miss')
BEGIN
insert into Salutation values('Miss')
end
GO
IF NOT EXISTS(SELECT * FROM Salutation WHERE Salutation='Tn')
BEGIN
insert into Salutation values('Tn')
end
GO
IF NOT EXISTS(SELECT * FROM Salutation WHERE Salutation='Ny')
BEGIN
insert into Salutation values('Ny')
end
GO
IF NOT EXISTS(SELECT * FROM Salutation WHERE Salutation='Nn')
BEGIN
insert into Salutation values('Nn')
end
GO
IF NOT EXISTS(SELECT * FROM Salutation WHERE Salutation='RS')
BEGIN
insert into Salutation values('RS')
end
GO
IF NOT EXISTS(SELECT * FROM Salutation WHERE Salutation='RSIA')
BEGIN
insert into Salutation values('RSIA')
end
GO
IF NOT EXISTS(SELECT * FROM Salutation WHERE Salutation='KLINIK')
BEGIN
insert into Salutation values('KLINIK')
end
GO
IF NOT EXISTS(SELECT * FROM Salutation WHERE Salutation='RSUD')
BEGIN
insert into Salutation values('RSUD')
end
GO
IF NOT EXISTS(SELECT * FROM Salutation WHERE Salutation='PUSKESMAS')
BEGIN
insert into Salutation values('PUSKESMAS')
end
GO
IF NOT EXISTS(SELECT * FROM Salutation WHERE Salutation='RB')
BEGIN
insert into Salutation values('RB')
end
GO
IF NOT EXISTS(SELECT * FROM Salutation WHERE Salutation='BIDAN')
BEGIN
insert into Salutation values('BIDAN')
end
GO
IF NOT EXISTS(SELECT * FROM Salutation WHERE Salutation='OPTIK')
BEGIN
insert into Salutation values('OPTIK')
end
GO
IF NOT EXISTS(SELECT * FROM Salutation WHERE Salutation='APOTIK')
BEGIN
insert into Salutation values('APOTIK')
end
GO
IF NOT EXISTS(SELECT * FROM Salutation WHERE Salutation='BP')
BEGIN
insert into Salutation values('BP')
end
GO
IF NOT EXISTS(SELECT * FROM Salutation WHERE Salutation='BALKESMAS')
BEGIN
insert into Salutation values('BALKESMAS')
end
GO

-- 3 Mar 2017 : Perbaikan Inquiry Quiry No data available jika passingan refno=null dan claim.ano=-1
IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[CLLISTQRY]') AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) ) 
BEGIN DROP FUNCTION [dbo].[CLLISTQRY] END
GO
CREATE FUNCTION CLLISTQRY (@VALUE1 AS VARCHAR(255), @VALUE2 AS VARCHAR(255), @VALUE5 AS VARCHAR(255), @VALUE6 AS VARCHAR(255), @VALUE7 AS VARCHAR(255), @VALUE8 AS VARCHAR(255), @VALUE9 AS VARCHAR(255), @VALUE10 AS VARCHAR(255), @VALUE11 AS VARCHAR(255), @VALUE12 AS VARCHAR(255), @VALUE13 AS VARCHAR(255),@VALUE14 as Varchar(10), @VALUE15 as Varchar(10),@VALUE16 as Varchar(255),@VALUE17 as Varchar(255),@VALUE18 as Varchar(255),@VALUE21 as Varchar(255))              
RETURNS Table              
AS RETURN (              
SELECT Claim.CNO,              
  Claim.ClaimNo,              
  Claim.refno,              
  Claim.PolicyNo,              
  Claim.RegDate,              
  Claim.LossDate,              
  Claim.LossPlace,              
  COLTAB.Description,              
  Claim.ClaimantInfo as Claimant,              
  Payment.Name as Payment,              
  Claim.EventName,              
  Claim.CType,              
  Claim.CStatus,              
  Claim.LargeF,              
  Claim.UniqueF,              
  Claim.TBAF_1,              
  Claim.TBAF_2,              
  Claim.SurveyF,              
  CLLOSS.TOI,              
  Claim.Branch,       
  Claim.TOC,              
  Cover.MO,      
  Case When CLInfo.CNO is null then AInfo.ValueID1 else CLInfo.ValueID1 end as ValueID1,              
  Case When CLInfo.CNO is null then AInfo.ValueID2 else CLInfo.ValueID2 end as ValueID2,              
  Case When CLInfo.CNO is null then AInfo.ValueID3 else CLInfo.ValueID3 end as ValueID3,              
  Case When CLInfo.CNO is null then AInfo.ValueID4 else CLInfo.ValueID4 end as ValueID4,              
  Case When CLInfo.CNO is null then AInfo.ValueID5 else CLInfo.ValueID5 end as ValueID5,              
  Case When CLInfo.CNO is null then AInfo.ValueID6 else CLInfo.ValueID6 end as ValueID6,              
  Case When CLInfo.CNO is null then AInfo.ValueID7 else CLInfo.ValueID7 end as ValueID7,              
  Case When CLInfo.CNO is null then AInfo.ValueID8 else CLInfo.ValueID8 end as ValueID8,              
  Case When CLInfo.CNO is null then AInfo.ValueID9 else CLInfo.ValueID9 end as ValueID9,              
  Case When CLInfo.CNO is null then AInfo.ValueID10 else CLInfo.ValueID10 end as ValueID10,              
  Case When CLInfo.CNO is null then AInfo.ValueID11 else CLInfo.ValueID11 end as ValueID11,              
  Case When CLInfo.CNO is null then AInfo.ValueID12 else CLInfo.ValueID12 end as ValueID12,              
  Case When CLInfo.CNO is null then AInfo.ValueID13 else CLInfo.ValueID13 end as ValueID13,              
  Case When CLInfo.CNO is null then AInfo.ValueID14 else CLInfo.ValueID14 end as ValueID14,              
  Case When CLInfo.CNO is null then AInfo.ValueID15 else CLInfo.ValueID15 end as ValueID15,              
  Case When CLInfo.CNO is null then AInfo.ValueDesc1 else CLInfo.ValueDesc1 end as ValueDesc1,              
  Case When CLInfo.CNO is null then AInfo.ValueDesc2 else CLInfo.ValueDesc2 end as ValueDesc2,              
  Case When CLInfo.CNO is null then AInfo.ValueDesc3 else CLInfo.ValueDesc3 end as ValueDesc3,              
  Case When CLInfo.CNO is null then AInfo.ValueDesc4 else CLInfo.ValueDesc4 end as ValueDesc4,              
  Case When CLInfo.CNO is null then AInfo.ValueDesc5 else CLInfo.ValueDesc5 end as ValueDesc5,              
  Case When CLInfo.CNO is null then AInfo.ValueDesc6 else CLInfo.ValueDesc6 end as ValueDesc6,              
  Case When CLInfo.CNO is null then AInfo.ValueDesc7 else CLInfo.ValueDesc7 end as ValueDesc7,              
  Case When CLInfo.CNO is null then AInfo.ValueDesc8 else CLInfo.ValueDesc8 end as ValueDesc8,              
  Case When CLInfo.CNO is null then AInfo.ValueDesc9 else CLInfo.ValueDesc9 end as ValueDesc9,              
  Case When CLInfo.CNO is null then AInfo.ValueDesc10 else CLInfo.ValueDesc10 end as ValueDesc10,            
  Case When CLInfo.CNO is null then AInfo.ValueDesc11 else CLInfo.ValueDesc11 end as ValueDesc11,              
  Case When CLInfo.CNO is null then AInfo.ValueDesc12 else CLInfo.ValueDesc12 end as ValueDesc12,              
  Case When CLInfo.CNO is null then AInfo.ValueDesc13 else CLInfo.ValueDesc13 end as ValueDesc13,              
  Case When CLInfo.CNO is null then AInfo.ValueDesc14 else CLInfo.ValueDesc14 end as ValueDesc14,              
  Case When CLInfo.CNO is null then AInfo.ValueDesc15 else CLInfo.ValueDesc15 end as ValueDesc15,              
  Acceptance.AName , Acceptance.CertificateNo, Acceptance.RefNo as ARefNo            
From CLAIM              
Inner Join Profile Payment on (Payment.ID=Claim.Payment)        
Left Join CLLoss on (CLLoss.CNO=Claim.CNO and Not (@Value13=''))        
Left Join CLInfo on (CLInfo.CNO=CLLoss.CNO and CLInfo.INO=CLLoss.INO and CLInfo.NOC=CLLOSS.NOC)        
Left Join Acceptance on (Acceptance.ANO=Claim.ANO)              
Left Join AInfo on (AInfo.ANO=Acceptance.ANO)              
Left Join Cover on (Cover.CNO=Acceptance.CNO)              
Left Join COLTab on (COLTAB.COL=Claim.COL)              
Where           
  (@Value1='%' or Claim.ClaimNo Like @Value1+'%')    
  And (@Value2='%' or Claim.PolicyNo Like @Value2+'%')    
  And (@Value5='%' or Claim.LossPlace Like @Value5+'%')    
  And (@Value7='%' or Claim.ClaimantInfo Like @Value7+'%' or exists (Select P.ID from CLLoss C, Profile P Where C.CNO=Claim.CNO and P.ID=C.Claimant and P.Name Like @Value7+'%'))      
  And (@Value8='%' or Payment.Name Like @Value8+'%' or exists (Select P.ID from CLLoss C, Profile P Where C.CNO=Claim.CNO and P.ID=C.Payment and P.Name Like @Value8+'%'))    
  And (@Value9='%' or Claim.EventName Like @Value9+'%')     
  And (@Value12='%' or Claim.Refno Like @Value12+'%')    
  And (@Value10='%' or Claim.CType Like @Value10+'%')    
  And (@Value11='%' or Claim.CStatus Like @Value11+'%')    
  And ((Claim.LargeF=1 and @Value14='Large') or @Value14='')              
  And ((Claim.UniqueF=1 and @Value15='Unique') or @Value15='')              
  And (((Claim.TBAF_1=1 or Claim.TBAF_2=1) and @Value17='TBA') or @Value17='')              
  And ((Claim.SurveyF=1 and @Value18='Survey') or @Value18='')              
  And (@Value16='%' or Claim.TOC Like @Value16+'%')   
  And (@Value13='%' or coalesce(CLLOSS.TOI,'') like @Value13+'%')    
  And (@Value6='%' or coalesce(COLTAB.Description,'') Like @Value6+'%')    
  And (@Value21='%' or coalesce(COVER.RefNo,'') Like @Value21+'%')    
)              

go

--4 apr 2017
IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'District' AND Object_ID = Object_ID(N'PROFILE'))
BEGIN
ALTER TABLE dbo.PROFILE ADD District	nvarchar(510) NULL
end
go

IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'SubDistrict' AND Object_ID = Object_ID(N'PROFILE'))
BEGIN
ALTER TABLE dbo.PROFILE ADD SubDistrict	nvarchar(510) NULL
end
go


IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'RoomNo' AND Object_ID = Object_ID(N'PROFILE'))
BEGIN
ALTER TABLE dbo.PROFILE ADD RoomNo	nvarchar(100) NULL
end
go

IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'FloorNo' AND Object_ID = Object_ID(N'PROFILE'))
BEGIN
ALTER TABLE dbo.PROFILE ADD FloorNo	nvarchar(100) NULL
end
go

IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'HomeNo' AND Object_ID = Object_ID(N'PROFILE'))
BEGIN
ALTER TABLE dbo.PROFILE ADD HomeNo	nvarchar(100) NULL
end
go

IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'MOO' AND Object_ID = Object_ID(N'PROFILE'))
BEGIN
ALTER TABLE dbo.PROFILE ADD MOO	nvarchar(100) NULL
end
go

IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'SOI' AND Object_ID = Object_ID(N'PROFILE'))
BEGIN
ALTER TABLE dbo.PROFILE ADD SOI	nvarchar(100) NULL
end
go

IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'Village' AND Object_ID = Object_ID(N'PROFILE'))
BEGIN
ALTER TABLE dbo.PROFILE ADD Village	nvarchar(100) NULL
end
go


IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'Building' AND Object_ID = Object_ID(N'PROFILE'))
BEGIN
ALTER TABLE dbo.PROFILE ADD Building	nvarchar(100) NULL
end
go

IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'Road' AND Object_ID = Object_ID(N'PROFILE'))
BEGIN
ALTER TABLE dbo.PROFILE ADD Road	nvarchar(100) NULL
end
go

IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'Country' AND Object_ID = Object_ID(N'province'))
BEGIN
ALTER TABLE dbo.PROFILE ADD Country	varchar(10) NULL
end
go

IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'OJKRegion' AND Object_ID = Object_ID(N'province'))
BEGIN
ALTER TABLE dbo.PROFILE ADD OJKRegion	varchar(10) NULL
end
go


IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'OJKSchemeNo' AND Object_ID = Object_ID(N'province'))
BEGIN
ALTER TABLE dbo.PROFILE ADD OJKSchemeNo	varchar(10) NULL
end
go


--22 Mar 2017 : Penambahan Fitur Inward Facultative Excess Of Loss

IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'Limit' AND Object_ID = Object_ID(N'ISOURCE'))
BEGIN
ALTER TABLE dbo.ISOURCE ADD Limit float(53) NULL
DECLARE @v sql_variant 
SET @v = N'Limit Of Liability'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'ISOURCE', N'COLUMN', N'Limit'
end
go

IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'Excess' AND Object_ID = Object_ID(N'ISOURCE'))
BEGIN
ALTER TABLE dbo.ISOURCE ADD Excess float(53) NULL
DECLARE @v sql_variant 
SET @v = N'In Excess Limit'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'ISOURCE', N'COLUMN', N'Excess'
end
go

Update ISource Set Limit=0 from ISource WHere Limit is null
Update ISource Set Excess=0 from ISource WHere Excess is null
GO


IF EXISTS ( SELECT * FROM   sysobjects WHERE  id = object_id(N'[dbo].[ISShare]') and OBJECTPROPERTY(id, N'IsProcedure') = 1 )
BEGIN DROP PROCEDURE ISShare  END 
GO
CREATE PROCEDURE ISShare (@PANO as Integer)
AS
Select ISource.Share as ISShare
FROM ISource, Acceptance
WHERE ISource.CNO=Acceptance.CNO and Acceptance.ANO=@PANO 

GO

IF EXISTS ( SELECT * FROM   sysobjects WHERE  id = object_id(N'[dbo].[QClaimShare]') and OBJECTPROPERTY(id, N'IsProcedure') = 1 )
BEGIN DROP PROCEDURE QClaimShare  END 
GO
CREATE PROCEDURE QClaimShare (@P_CNO as integer)
AS
SELECT ISource.Share AS ISShare
FROM ISource, Acceptance, Claim
Where ISource.CNO=Acceptance.CNO and Acceptance.ANO=Claim.ANO and Claim.CNO=@P_CNO


GO

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[FN_PCalc]') AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) ) 
BEGIN DROP FUNCTION [dbo].[FN_PCalc] END
GO
Create FUNCTION FN_PCalc (@P_ANO as integer)            
RETURNS Table            
AS RETURN (            
SELECT  Acceptance.ANO,            
 Count(Distinct PCalc.Currency) AS NUMCCY,          
 MAX(PCALC.RATE) AS RATE,          
 MAX(CASE When Acceptance.QTY=0 Then 1 Else Acceptance.QTY end) as NumRisk,
 sum(PCalc.TSI*PCalc.Rate*Case When Acceptance.QTY=0 Then 1 Else Acceptance.QTY end) AS TSI,            
 sum(PCalc.OurShare*PCalc.Rate*Case When Acceptance.QTY=0 Then 1 Else Acceptance.QTY end) AS OurShare,            
 sum(PCalc.Amount*PCalc.Rate*Case When Acceptance.QTY=0 Then 1 Else Acceptance.QTY end) AS Amount,            
 sum(PCalc.Gross*PCalc.Rate*Case When Acceptance.QTY=0 Then 1 Else Acceptance.QTY end) AS Gross,            
 sum(PCalc.Claim*PCalc.Rate*Case When Acceptance.QTY=0 Then 1 Else Acceptance.QTY end) AS Claim,            
 sum(case when PCalc.TSI=0 then 0 else PCalc.OurShare*PCalc.Rate*Case When Acceptance.QTY=0 Then 1 Else Acceptance.QTY end end)/            
 sum(case when PCalc.TSI=0 then 1 else PCalc.TSI*PCalc.Rate*Case When Acceptance.QTY=0 Then 1 Else Acceptance.QTY end end)*            
 sum(PCalc.Gross*PCalc.Rate*Case When Acceptance.QTY=0 Then 1 Else Acceptance.QTY end) as Premium,            
 Max(Acceptance.ValueID) as ValueID,            
 Max(Acceptance.ValueDesc) as ValueDesc,            
 MAX(Year(RARRHEADER.RDATE)) As RYear,        
 MAX(CASE WHEN PCALC.TSI<>0 AND COALESCE(ISOURCE.LIMIT,0)<>0 THEN PCALC.OURSHARE/PCALC.TSI*100 ELSE COALESCE(ISOURCE.SHARE,100) END) as PCTSHARE, 
 Max(cast(Datediff(month,Acceptance.SDate, Acceptance.EDate) as float)/cast(12 as float)) as Prorata                  
FROM  Acceptance with(NOLOCK)       
LEFT JOIN Pcalc with(NOLOCK) ON (Acceptance.ANO=PCalc.ANO and Acceptance.PStatus='C')       
LEFT JOIN RArrHeader with(NOLOCK) On (RArrHeader.ANO=Acceptance.ANO)      
LEFT JOIN ISOURCE with (NOLOCK) ON (ISOURCE.CNO=ACCEPTANCE.CNO)            
Where Acceptance.ANO=@P_ANO            
GROUP BY Acceptance.ANO            
)            


GO

IF EXISTS ( SELECT * FROM   sysobjects WHERE  id = object_id(N'[dbo].[QCCALC_1]') and OBJECTPROPERTY(id, N'IsProcedure') = 1 )
BEGIN DROP PROCEDURE QCCALC_1  END 
GO
CREATE PROCEDURE QCCALC_1 (@PCNO as integer) 
AS
SELECT CCALC.*, ISOURCE.LIMIT, ISOURCE.EXCESS
FROM CCALC INNER JOIN CLAIM ON (CLAIM.CNO=CCALC.CNO) INNER JOIN ACCEPTANCE ON (ACCEPTANCE.ANO=CLAIM.ANO ) LEFT JOIN ISOURCE ON (ISOURCE.CNO=ACCEPTANCE.CNO)
WHERE CCALC.CNO=@PCNO   


GO

IF EXISTS ( SELECT * FROM   sysobjects WHERE  id = object_id(N'[dbo].[QPCALC_ACCASS]') and OBJECTPROPERTY(id, N'IsProcedure') = 1 )
BEGIN DROP PROCEDURE QPCALC_ACCASS  END 
GO
CREATE Procedure QPCALC_ACCASS (@P_ANO integer)     
AS     
SELECT ICALC.CURRENCY, ICALC.CODE, ICALC.SDATE, ICALC.EDATE, (Case When A1.AType='A' Then 0 else ICover.Adjustable end) as AdjustableF, ICALC.SANO, A2.LANO,     
Cast(Max(cast(RCover.NoRefundF as Integer)) as Bit) as NoRefundF,     
Max(Case When ICover.Adjustable=1 Then TOI.AdjMethod else '' end) as AdjMethod,     
AVG(ICALC.PRORATA) AS PPRORATA, 
MAX(CASE WHEN PCALC.TSI<>0 AND COALESCE(ISOURCE.LIMIT,0)<>0 THEN PCALC.OURSHARE/PCALC.TSI*100 ELSE COALESCE(ISOURCE.SHARE,100) END) as SHARE, 
SUM(Case When PCALC.Description<>'' and PCALC.Description<>'Minimum Premium' then ICALC.GROSS*PCALC.GROSS/PCALC.OGROSS else ICALC.GROSS*RCALC.GROSS/RCALC.OGROSS end) AS GROSS,     
CAST(MAX(Case When Upper(PCALC.DESCRIPTION) in ('MINIMUM PREMIUM','POLICY MINIMUM PREMIUM') Then 1 else 0 end) as Bit) as MinimumPremiumF,     
SUM(ICALC.REINSTATEMENT) AS REINSTATEMENT,     
SUM(ICALC.DISCOUNT) AS DISCOUNT,     
MAX(PCALC.TSI) as TSI,      --100% Sum Insured for Reinsurance Rate     
MAX(PCALC.Rate) As Rate     
FROM ICover     
inner join ICALC on (ICALC.INO=ICOVER.INO and ICALC.ANO=ICOVER.ANO)     
inner join TOI on (TOI.TOI=ICOVER.TOI)     
inner join RCALC on (ICALC.ANO=RCALC.ANO AND ICALC.CURRENCY=RCALC.CURRENCY AND ICALC.CODE=RCALC.CODE AND ICALC.TOR=RCALC.TOR AND ICALC.SDATE=RCALC.SDATE AND ICALC.EDATE=RCALC.EDATE AND ICALC.SANO=RCALC.SANO)     
inner join PCALC on (PCALC.ANO=ICALC.ANO AND PCALC.CURRENCY=ICALC.CURRENCY)     
Left join RCover on (RCover.ANO=RCalc.ANO and RCover.Code=RCalc.Code and RCover.SDate=RCalc.SDate)     
inner join ACCEPTANCE A1 On (A1.ANO=ICALC.ANO)     
inner join ACCEPTANCE A2 on (A2.ANO=ICALC.SANO)     
Inner Join RArrHeader R on (R.ANO=ICalc.ANO)     
left join ISource on (ISource.CNO=A2.CNO)     
WHERE ICover.ANO=@P_ANO and ICALC.GROSS<>0 AND ICALC.SDATE<>ICALC.EDATE  
GROUP BY ICALC.CURRENCY, ICALC.CODE, ICALC.SDATE, ICALC.EDATE, (Case When A1.AType='A' Then 0 else ICover.Adjustable end), ICalc.SANO, A2.LANO     

GO


IF EXISTS ( SELECT * FROM   sysobjects WHERE  id = object_id(N'[dbo].[CLView06a]') and OBJECTPROPERTY(id, N'IsProcedure') = 1 )
BEGIN DROP PROCEDURE CLView06a  END 
GO
CREATE PROCEDURE CLView06a (@P_CNO as integer)
AS
SELECT CLAIM.CLAIMNO, CLAIM.ANO, CLAIM.CNO, CLAIM.LOSSDATE, CLAIM.CTYPE,
CCALC.RATE, 
CCALC.SHARE AS PCTSHARE,
CCALC.LOSS AS ESTIMATE,
CCALC.CLAIM AS OURSHARE,
CCALC.EDEDUCTIBLE AS EDEDUCTIBLE,
CCALC.DEDUCTIBLE AS DEDUCTIBLE,
CCALC.COST,
CCALC.RCOST AS RCOST,
CCALC.ECOST,
CCALC.ERCOST AS ERCOST,
CCALC.SALVAGE AS SALVAGE,
CCALC.SUBROGATION As SUBROGATION,
COALESCE(ISOURCE.LIMIT,0) AS LIMIT,
COALESCE(ISOURCE.EXCESS,0) AS EXCESS
From CCALC INNER JOIN CLAIM ON (CLAIM.CNO=CCALC.CNO) INNER JOIN ACCEPTANCE ON (ACCEPTANCE.ANO=CLAIM.ANO) LEFT JOIN ISOURCE ON (ISOURCE.CNO=ACCEPTANCE.CNO)
WHERE CCALC.CNO=@P_CNO

GO

IF EXISTS ( SELECT * FROM   sysobjects WHERE  id = object_id(N'[dbo].[CLVIEW06B]') and OBJECTPROPERTY(id, N'IsProcedure') = 1 )
BEGIN DROP PROCEDURE CLVIEW06B  END 
GO
CREATE PROCEDURE CLVIEW06B (@P_CNO AS INTEGER)       
AS      
SELECT C.*, C.TAmount as OurShare, Claim.ClaimNo, Claim.ANO, Claim.LossDate, C.ETAmount as Estimate, 
R.CID, R.QID, R.DID, R.XPID, R.SP1ID, R.SP2ID, R.SP3ID, R.AID, coalesce(ISOURCE.SHARE,100) as PCTSHARE,
CASE WHEN CLAIM.PSTATUS='C' and (C.CAMOUNT<>0 OR C.ECAMOUNT<>0) THEN R.CSHARE ELSE 0 end as CSHARE,    
CASE WHEN CLAIM.PSTATUS='C' and (C.DAMOUNT<>0 OR C.EDAMOUNT<>0) THEN R.DSHARE ELSE 0 end as DSHARE,    
CASE WHEN CLAIM.PSTATUS='C' and (C.QAMOUNT<>0 OR C.EQAMOUNT<>0) THEN R.QSHARE ELSE 0 end as QSHARE,    
CASE WHEN CLAIM.PSTATUS='C' and (C.XPAMOUNT<>0 OR C.EXPAMOUNT<>0) THEN R.XPSHARE ELSE 0 end as XPSHARE,    
CASE WHEN CLAIM.PSTATUS='C' and (C.SP1AMOUNT<>0 OR C.ESP1AMOUNT<>0) THEN R.SP1SHARE ELSE 0 end as SP1SHARE,    
CASE WHEN CLAIM.PSTATUS='C' and (C.SP2AMOUNT<>0 OR C.ESP2AMOUNT<>0) THEN R.SP2SHARE ELSE 0 end as SP2SHARE,    
CASE WHEN CLAIM.PSTATUS='C' and (C.SP3AMOUNT<>0 OR C.ESP3AMOUNT<>0) THEN R.SP3SHARE ELSE 0 end as SP3SHARE,    
CASE WHEN CLAIM.PSTATUS='C' and (C.AAMOUNT<>0 OR C.EAAMOUNT<>0) THEN R.ASHARE ELSE 0 end as ASHARE,    
CASE WHEN CLAIM.PSTATUS='C' and (C.FAMOUNT<>0 OR C.EFAMOUNT<>0) THEN CASE WHEN C.FAMOUNT<>0 THEN C.FAMOUNT/C.TAMOUNT*100 ELSE C.EFAMOUNT/C.ETAMOUNT*100 END ELSE 0 END AS FSHARE
FROM RARRHEADER R, CARRHEADER C, CLAIM, ACCEPTANCE LEFT JOIN ISOURCE ON (ISOURCE.CNO=ACCEPTANCE.CNO)
WHERE CLAIM.CNO=@P_CNO and C.CNO=CLAIM.CNO and R.ANO=CLAIM.ANO AND ACCEPTANCE.ANO=R.ANO 
      
GO

--3 APR 2017 : Penambahan Overriding Commission dan Acquisition COst (untuk perhitungan Net to Grss) Facultative


IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'OComm' AND Object_ID = Object_ID(N'FPART'))
BEGIN
ALTER TABLE dbo.FPART ADD OComm float(53) NULL
DECLARE @v sql_variant 
SET @v = N'Overriding Commission (in %)'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'FPART', N'COLUMN', N'OComm'
ALTER TABLE dbo.FPART ADD CONSTRAINT DF_FPART_OComm DEFAULT 0 FOR OComm
end
go

IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'ACQCOST' AND Object_ID = Object_ID(N'FPART'))
BEGIN
ALTER TABLE dbo.FPART ADD ACQCOST float(53) NULL
DECLARE @v sql_variant 
SET @v = N'Acquisition Cost (in %)'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'FPART', N'COLUMN', N'ACQCOST'
ALTER TABLE dbo.FPART ADD CONSTRAINT DF_FPART_ACQCOST DEFAULT 0 FOR ACQCOST
end
go


Update fpart set OComm=0 where OComm is null
Update fpart set ACQCOST=0 where ACQCOST is null
go


IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'OComm' AND Object_ID = Object_ID(N'FPARTDET'))
BEGIN
ALTER TABLE dbo.FPARTDET ADD OComm float(53) NULL
DECLARE @v sql_variant 
SET @v = N'Overriding Commission (in %)'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'FPARTDET', N'COLUMN', N'OComm'
ALTER TABLE dbo.FPARTDET ADD CONSTRAINT
	DF_FPARTDET_OComm DEFAULT 0 FOR OComm
end
go

Update FPARTDET set OComm=0 where OComm is null
go

IF EXISTS ( SELECT * FROM   sysobjects WHERE  id = object_id(N'[dbo].[QFacultative_Data]') and OBJECTPROPERTY(id, N'IsProcedure') = 1 )
BEGIN DROP PROCEDURE QFacultative_Data  END 
GO
CREATE Procedure QFacultative_Data(@P_ANO integer, @P_FID varchar(20))                    
AS                                  
SELECT R.FID, R.AType, F.SLIPNO, R.SDATE, R.EDATE, R.RTYPE, F.ID, R.SHARE, R.FLPCT, R.AMOUNT, R.LIMIT, R.EXCESS, R.UJROHREINS, R.UJROHCEDANT,                    
R.UserID, R.CDate,                  
R.LUserID, R.LDate,                  
R.AUserID, R.AUserDate,            
R.AcceptedBy, R.AcceptedDate,             
R.ClaimCOOP, R.PrecedeFacCessionF, R.NoRefundF,   
F.Code, F.COMM, F.OCOMM, F.ACQCOST, F.NETRATE, F.Currency, F.Unit, R.PCALC, R.CPCT, R.Memo, F.REMARKS, F.WPC, R.FULLCOVERF, R.ORIGINALF, R.OnGrossAfterCommF, R.OnNetRateF, R.CPRefund, F.PERIOD, F.INSTALLMENT,       
F.GRACE,                    
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
BEGIN DROP PROCEDURE QFACOUTDET  END 
GO
CREATE Procedure QFACOUTDET(@P_ANO integer,@P_CODE varchar(10))        
as        
SELECT FPartDet.Code, RArrDet.FID, RArrDet.FLPct, RArrDet.Status, RArrDet.AType, RArrDet.RType, RArrDet.SDate, RArrDet.EDate, RArrDet.Share, RArrDet.Amount, RArrDet.Prorata, Profile.Name, FPart.SlipNo, FPart.ID, FPart.Share AS RShare, FPart.ACQCOST, FPartDet.Comm, FPartDet.OComm, FPart.WPC,        
FPart.Currency, FPartDet.NetRate , FPartDet.Unit, RArrDet.PCALC, RArrDet.CPct, RArrDet.CPRefund, RArrDet.NoRefundF, RArrDet.OnGrossAfterCommF, RArrDet.FullCoverF, FPart.Remarks, RArrDet.UJROHREINS, RArrDet.UJROHCEDANT        
From RArrDet, FPart, Profile, FPartDet        
WHERE RArrDet.ANO=@P_ANO And FPart.ANO=RArrDet.ANO And FPart.FID=RArrDet.FID And Profile.ID=FPart.ID AND RArrDet.FullCoverF=0        
AND FPartDet.ANO=RArrDet.ANO and FPartDet.FID=RArrDet.FID And FPartDet.ID=FPart.ID   
And (FPartDet.Code=@P_Code or Exists (Select Top 1 RCalc.Code from RCalc, RateCov Where RCalc.ANO=RArrDet.ANO and RateCov.Code=FPartDet.Code and RCalc.TOR=RateCov.TOR and RCalc.Code=@P_Code))  
          
Union All        
          
SELECT FPart.Code, RArrDet.FID, RArrDet.FLPct, RArrDet.Status, RArrDet.AType, RArrDet.RType, RArrDet.SDate, RArrDet.EDate, RArrDet.Share, RArrDet.Amount, RArrDet.Prorata, Profile.Name, FPart.SlipNo, FPart.ID, FPart.Share AS RShare, FPart.ACQCOST, FPart.Comm, FPart.OComm, FPart.WPC, 
       
FPart.Currency, FPart.NetRate , FPart.Unit, RArrDet.PCALC, RArrDet.CPct,  RArrDet.CPRefund, RArrDet.NoRefundF, RArrDet.OnGrossAfterCommF, RArrDet.FullCoverF, FPart.Remarks, RArrDet.UJROHREINS, RArrDet.UJROHCEDANT        
From RArrDet, FPart, Profile        
WHERE RArrDet.ANO=@P_ANO And FPart.ANO=RArrDet.ANO And FPart.FID=RArrDet.FID And Profile.ID=FPart.ID AND RArrDet.FullCoverF=1      


GO

--4 APR 2017 : Penambahan Currency di Treaty Setting, sehingga limit tidak harus dikonversikan dulu terhadap Base Currency

IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'Currency' AND Object_ID = Object_ID(N'REINSURANCE'))
BEGIN
ALTER TABLE dbo.REINSURANCE ADD Currency varchar(10) NULL
DECLARE @v sql_variant 
SET @v = N'Currency Code (see Currency Table)'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'REINSURANCE', N'COLUMN', N'Currency'
end
go

UPDATE REINSURANCE SET CURRENCY=SYSTAB.CURRENCY FROM REINSURANCE, SYSTAB WHERE REINSURANCE.CURRENCY IS NULL
GO


IF EXISTS ( SELECT * FROM   sysobjects WHERE  id = object_id(N'[dbo].[QREINSURANCE_CESSION]') and OBJECTPROPERTY(id, N'IsProcedure') = 1 )
BEGIN DROP PROCEDURE QREINSURANCE_CESSION  END 
GO
CREATE Procedure QREINSURANCE_CESSION (@P_ANO integer, @P_ADate smalldatetime, @P_RType varchar(255), @P_TSI Float=0, @P_RID varchar(20)='', @P_ManualF Bit=0, @P_GROSS Float=0)                                
as                                                          
SELECT (Case When ReClass.PriorityF=1 Then ReClass.PriorityF else Reinsurance.PriorityF end) as PriorityF, Reinsurance.RID, Reinsurance.RType,                                
ReClass.PLimit*coalesce(ReRate.Rate,1) as PLimit, 
Case RECLASS.Limit WHEN 0 then Reinsurance.Limit Else RECLASS.Limit end*coalesce(ReRate.Rate,1) as limit, 
ReClass.ShortFallLimit*coalesce(ReRate.Rate,1) as ShortFallLimit,              
ReClass.MinTSI*coalesce(ReRate.Rate,1) as MinTI, 
Reinsurance.UjrohReins, Reinsurance.UjrohCedant, Reinsurance.Share, Reinsurance.PShare, Acceptance.FLDID, Acceptance.ValueID, ReClass.CessionF, ReClass.AssessmentF, ReClass.DirectF                                
From Acceptance       
Inner Join Cover on (Cover.CNO=Acceptance.CNO)      
Left Join RArrHeader on (RArrHeader.ANO=Acceptance.ANO)      
Inner Join Reinsurance on (Reinsurance.RType=@P_RType)      
Inner Join ReClass on (ReClass.RNO=Reinsurance.RNO and ReClass.TOC=Cover.TOC)      
Left Join RePolicy on (RePolicy.RNO=Reinsurance.RNO)      
Left Join ReRate on (ReRate.TOC=COVER.TOC and ReRate.RYear=Reinsurance.RYEAR and ReRate.Currency=Reinsurance.Currency)
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

IF EXISTS ( SELECT * FROM   sysobjects WHERE  id = object_id(N'[dbo].[Claim_Cession]') and OBJECTPROPERTY(id, N'IsProcedure') = 1 )
BEGIN DROP PROCEDURE Claim_Cession  END 
GO
CREATE PROCEDURE Claim_Cession (@PCNO as integer, @pLDate as smalldatetime, @pRType as varchar(255))                    
AS                    
SELECT coalesce(RePolicy.ID,''), (Case When ReClass.PriorityF=1 Then ReClass.PriorityF else Reinsurance.PriorityF end) as PriorityF, Reinsurance.RID, Reinsurance.RType, Reinsurance.Category,                    
Reinsurance.Share,                    
Case When Event.Category='E' and RECLASS.ELIMIT<>0 Then RECLASS.ELIMIT Else (Case WHEN RECLASS.Limit=0 THEN Reinsurance.Limit Else RECLASS.Limit end) End*Case When coalesce(ReRate.CRate,0)<>0 Then coalesce(ReRate.CRate,0) else coalesce(ReRate.Rate,1) end as Limit,                    
Case When Event.Category='E' and RECLASS.EExcess<>0 Then RECLASS.EExcess Else (Case WHEN RECLASS.Excess=0 THEN Reinsurance.Excess Else RECLASS.Excess end) End*Case When coalesce(ReRate.CRate,0)<>0 Then coalesce(ReRate.CRate,0) else coalesce(ReRate.Rate,1) end as Excess,                    
Reinsurance.ExcessType,                
RECLASS.CessionF , RECLASS.AssessmentF, 
REINSURANCE.Deductible*Case When coalesce(ReRate.CRate,0)<>0 Then coalesce(ReRate.CRate,0) else coalesce(ReRate.Rate,1) end as Deductible, 
REINSURANCE.A_Deductible*Case When coalesce(ReRate.CRate,0)<>0 Then coalesce(ReRate.CRate,0) else coalesce(ReRate.Rate,1) end as A_Deductible, 
REINSURANCE.A_EDeductible*Case When coalesce(ReRate.CRate,0)<>0 Then coalesce(ReRate.CRate,0) else coalesce(ReRate.Rate,1) end as A_EDeductible, 
REINSURANCE.Aggregate*Case When coalesce(ReRate.CRate,0)<>0 Then coalesce(ReRate.CRate,0) else coalesce(ReRate.Rate,1) end as Aggregate, 
REINSURANCE.A_Aggregate*Case When coalesce(ReRate.CRate,0)<>0 Then coalesce(ReRate.CRate,0) else coalesce(ReRate.Rate,1) end as A_Aggregate, 
REINSURANCE.A_EAggregate*Case When coalesce(ReRate.CRate,0)<>0 Then coalesce(ReRate.CRate,0) else coalesce(ReRate.Rate,1) end as A_EAggregate
FROM Claim          
Left Join Event On (Event.EventNo=Claim.EventNo)          
Inner Join Acceptance on (Acceptance.ANO=Claim.ANO)          
Inner Join Cover on (Cover.CNO=Acceptance.CNO)          
Inner Join RArrHeader on (RArrHeader.ANO=Claim.ANO)          
Inner Join Reinsurance on (Reinsurance.RTYPE=@pRType and @pLDate Between Reinsurance.SDate And Reinsurance.EDate)          
Inner Join ReClass on (ReClass.RNO=Reinsurance.RNO and ReClass.TOC=Claim.TOC)          
Left Join RePolicy on (RePolicy.RNO=Reinsurance.RNO)          
Left Join ReRate on (ReRate.TOC=Claim.TOC and ReRate.RYear=Reinsurance.RYEAR and ReRate.Currency=Reinsurance.Currency)
Inner Join SysTab on (1=1)
WHERE Claim.CNO=@PCNO           
and RArrHeader.EXOLF=0        --Not Exclude XOL          
and (coalesce(Event.EventNo,'')<>'' or ReClass.EventF=0)     
and (Event.Category='E' or Reinsurance.Category<>'E')           
And Reinsurance.Category<>'S' --Not Shortfall Surplus          
And (coalesce(RePolicy.ID,'')='' or  coalesce(RePolicy.ID,'')=Cover.PHolder)        
And  
(        
 (      
 (datediff(month, acceptance.sdate, acceptance.edate)>=ReClass.MinPeriod)       
 or (datediff(month, acceptance.sdate, acceptance.edate)=ReClass.MinPeriod-1 and day(acceptance.sdate)<day(acceptance.edate))       
 or ReClass.MinPeriod=0)                                 
 And (      
 (datediff(month, acceptance.sdate, acceptance.edate)<ReClass.MaxPeriod)       
 or (datediff(month, acceptance.sdate, acceptance.edate)=ReClass.MaxPeriod and day(acceptance.sdate)>=day(acceptance.edate))       
 or ReClass.MaxPeriod=0)  
)        
-- If Risk is Excluded          
AND NOT EXISTS (SELECT TOP 1 1 FROM RPARTDET, LCALC WHERE LCALC.CNO=CLAIM.CNO AND RPARTDET.RNO=REINSURANCE.RNO AND RPARTDET.TOR=LCALC.TOR AND RPARTDET.EXCLUDEF=1)          
And (Case When coalesce(ReRate.CRate,0)<>0 Then coalesce(ReRate.CRate,0) else coalesce(ReRate.Rate,1) end<>1 or Reinsurance.Currency=SysTab.Currency)
Order By coalesce(RePolicy.ID,'') Desc, Case When (Event.Category='E' and Reinsurance.Category in ('C','E')) or (coalesce(Event.Category,'R')='R' and Reinsurance.Category in ('R')) Then 1 else 0 end Desc, (Case When ReClass.PriorityF=1 Then ReClass.PriorityF else Reinsurance.PriorityF end) Desc             


  
GO

IF EXISTS ( SELECT * FROM   sysobjects WHERE  id = object_id(N'[dbo].[QGet_MinDep]') and OBJECTPROPERTY(id, N'IsProcedure') = 1 )
BEGIN DROP PROCEDURE QGet_MinDep  END 
GO
CREATE Procedure QGet_MinDep (@P_CNO integer, @P_RID varchar(20), @P_PID varchar(10))                                
as    
Select 
Case When Coalesce(R2.MDP+R2.AAP,0)<>0 Then Coalesce(R2.MDP+R2.AAP,0) Else R1.MDP+R1.AAP end*Case When coalesce(ReRate.CRate,0)<>0 Then coalesce(ReRate.CRate,0) else coalesce(ReRate.Rate,1) end as MDP, 
Case When Coalesce(R2.MDP_1+R2.AAP_1,0)<>0 Then Coalesce(R2.MDP_1+R2.AAP_1,0) Else R1.MDP_1+R1.AAP_1 end*Case When coalesce(ReRate.CRate,0)<>0 Then coalesce(ReRate.CRate,0) else coalesce(ReRate.Rate,1) end as MDP_1 
from Claim
Inner Join Reinsurance R1 on (R1.RID=@P_RID)
Inner Join RPart R2 on (R2.RNO=R1.RNO and R2.ID=@P_PID)
Left Join ReRate on (ReRate.TOC=Claim.TOC and ReRate.RYear=R1.RYEAR and ReRate.Currency=R1.Currency)
Inner Join SysTab on (1=1)
Where Claim.CNO=@P_CNO 
and (Case When coalesce(ReRate.CRate,0)<>0 Then coalesce(ReRate.CRate,0) else coalesce(ReRate.Rate,1) end<>1 or R1.Currency=SysTab.Currency)


GO


IF EXISTS ( SELECT * FROM   sysobjects WHERE  id = object_id(N'[dbo].[QCLAIMRCESSION]') and OBJECTPROPERTY(id, N'IsProcedure') = 1 )
BEGIN DROP PROCEDURE QCLAIMRCESSION  END 
GO
CREATE Procedure QCLAIMRCESSION (@P_RID varchar(255), @P_CNO int)      
as      
SELECT RPART.*, REINSURANCE.RID, REINSURANCE.CESSION, REINSURANCE.DOCNO, 
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
GO


--Penambahan Table scheme beneficiary

IF  NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Scheme_Beneficiary]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[Scheme_Beneficiary](
	[TrNo] [int] NOT NULL,
	[ID] [varchar](10) NOT NULL,
	[Name] [varchar](255) NOT NULL,
	[ID_Type] [varchar](10) NULL,
	[ID_NO] [varchar](20) NULL,
	[Address_1] [varchar](255) NULL,
	[Address_2] [varchar](255) NULL,
	[GENDER] [varchar](30) NULL,
	[RELATION] [varchar](30) NULL,
	[REMARK] [varchar](255) NULL,
 CONSTRAINT [I_Scheme_Beneficiary] PRIMARY KEY NONCLUSTERED 
(
	[TrNo] ASC,
	[ID] ASC,
	[Name] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
ALTER TABLE [dbo].[Scheme_Beneficiary]  WITH CHECK ADD  CONSTRAINT [FK_Scheme_Beneficiary_Scheme_Transaction] FOREIGN KEY([TrNo])
REFERENCES [dbo].[Scheme_Transaction] ([TrNo])
ON UPDATE CASCADE
ON DELETE CASCADE
ALTER TABLE [dbo].[Scheme_Beneficiary] CHECK CONSTRAINT [FK_Scheme_Beneficiary_Scheme_Transaction]
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Cover No (see Acceptance)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Scheme_Beneficiary', @level2type=N'COLUMN',@level2name=N'TrNo'
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Beneficiary Profile ID' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Scheme_Beneficiary', @level2type=N'COLUMN',@level2name=N'ID'
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Beneficiaries Name' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Scheme_Beneficiary', @level2type=N'COLUMN',@level2name=N'Name'
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Identification Type (SIM/KTP/etc)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Scheme_Beneficiary', @level2type=N'COLUMN',@level2name=N'ID_Type'
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Identification No. (KTP No/etc)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Scheme_Beneficiary', @level2type=N'COLUMN',@level2name=N'ID_NO'
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Beneficiaries Address' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Scheme_Beneficiary', @level2type=N'COLUMN',@level2name=N'Address_1'
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Beneficiaries Zip Code' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Scheme_Beneficiary', @level2type=N'COLUMN',@level2name=N'Address_2'
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Gender' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Scheme_Beneficiary', @level2type=N'COLUMN',@level2name=N'GENDER'
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Insured Relation' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Scheme_Beneficiary', @level2type=N'COLUMN',@level2name=N'RELATION'
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Remarks' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Scheme_Beneficiary', @level2type=N'COLUMN',@level2name=N'REMARK'
end
go


-- 5 APR 2017 : Update Script Aplikasi terkait dengan Multi TOC
IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].Classified_Object') AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) ) 
BEGIN DROP FUNCTION [dbo].Classified_Object END
GO
CREATE  FUNCTION Classified_Object()  
RETURNS TABLE  
AS RETURN(  
SELECT Acceptance.ANO  
FROM RiskAss, Cover, Acceptance, AInfo  
WHERE [Riskass].[RYear]=Year([Acceptance].[SDate]) and [Acceptance].[ANO]=[AInfo].[ANO] And [Acceptance].[CNO]=[Cover].[CNO] And [RiskAss].[TOC]=[Acceptance].[TOC]   
And ((RiskAss.ValueID1='' and [Ainfo].[ValueDesc1] Like [RiskAss].[ValueDesc1]+'%') or (RiskAss.ValueID1<>'' and AInfo.ValueID1 Like RiskAss.ValueID1+'%') or (RiskAss.ValueID1 is null))  
And ((RiskAss.ValueID2='' and [Ainfo].[ValueDesc2] Like [RiskAss].[ValueDesc2]+'%') or (RiskAss.ValueID2<>'' and AInfo.ValueID2 Like RiskAss.ValueID2+'%') or (RiskAss.ValueID2 is null))  
And ((RiskAss.ValueID3='' and [Ainfo].[ValueDesc3] Like [RiskAss].[ValueDesc3]+'%') or (RiskAss.ValueID3<>'' and AInfo.ValueID3 Like RiskAss.ValueID3+'%') or (RiskAss.ValueID3 is null))  
And ((RiskAss.ValueID4='' and [Ainfo].[ValueDesc4] Like [RiskAss].[ValueDesc4]+'%') or (RiskAss.ValueID4<>'' and AInfo.ValueID4 Like RiskAss.ValueID4+'%') or (RiskAss.ValueID4 is null))  
And ((RiskAss.ValueID5='' and [Ainfo].[ValueDesc5] Like [RiskAss].[ValueDesc5]+'%') or (RiskAss.ValueID5<>'' and AInfo.ValueID5 Like RiskAss.ValueID5+'%') or (RiskAss.ValueID5 is null))  
And ((RiskAss.ValueID6='' and [Ainfo].[ValueDesc6] Like [RiskAss].[ValueDesc6]+'%') or (RiskAss.ValueID6<>'' and AInfo.ValueID6 Like RiskAss.ValueID6+'%') or (RiskAss.ValueID6 is null))  
And ((RiskAss.ValueID7='' and [Ainfo].[ValueDesc7] Like [RiskAss].[ValueDesc7]+'%') or (RiskAss.ValueID7<>'' and AInfo.ValueID7 Like RiskAss.ValueID7+'%') or (RiskAss.ValueID7 is null))  
And ((RiskAss.ValueID8='' and [Ainfo].[ValueDesc8] Like [RiskAss].[ValueDesc8]+'%') or (RiskAss.ValueID8<>'' and AInfo.ValueID8 Like RiskAss.ValueID8+'%') or (RiskAss.ValueID8 is null))  
And ((RiskAss.ValueID9='' and [Ainfo].[ValueDesc9] Like [RiskAss].[ValueDesc9]+'%') or (RiskAss.ValueID9<>'' and AInfo.ValueID9 Like RiskAss.ValueID9+'%') or (RiskAss.ValueID9 is null))  
And ((RiskAss.ValueID10='' and [Ainfo].[ValueDesc10] Like [RiskAss].[ValueDesc10]+'%') or (RiskAss.ValueID10<>'' and AInfo.ValueID10 Like RiskAss.ValueID10+'%') or (RiskAss.ValueID10 is null))  
And ((RiskAss.ValueID11='' and [Ainfo].[ValueDesc11] Like [RiskAss].[ValueDesc11]+'%') or (RiskAss.ValueID11<>'' and AInfo.ValueID11 Like RiskAss.ValueID11+'%') or (RiskAss.ValueID11 is null))  
And ((RiskAss.ValueID12='' and [Ainfo].[ValueDesc12] Like [RiskAss].[ValueDesc12]+'%') or (RiskAss.ValueID12<>'' and AInfo.ValueID12 Like RiskAss.ValueID12+'%') or (RiskAss.ValueID12 is null))  
And ((RiskAss.ValueID13='' and [Ainfo].[ValueDesc13] Like [RiskAss].[ValueDesc13]+'%') or (RiskAss.ValueID13<>'' and AInfo.ValueID13 Like RiskAss.ValueID13+'%') or (RiskAss.ValueID13 is null))  
And ((RiskAss.ValueID14='' and [Ainfo].[ValueDesc14] Like [RiskAss].[ValueDesc14]+'%') or (RiskAss.ValueID14<>'' and AInfo.ValueID14 Like RiskAss.ValueID14+'%') or (RiskAss.ValueID14 is null))  
And ((RiskAss.ValueID15='' and [Ainfo].[ValueDesc15] Like [RiskAss].[ValueDesc15]+'%') or (RiskAss.ValueID15<>'' and AInfo.ValueID15 Like RiskAss.ValueID15+'%') or (RiskAss.ValueID15 is null))  
)  
GO

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].FL_CL_CERTIFICATENO') AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) ) 
BEGIN DROP FUNCTION [dbo].FL_CL_CERTIFICATENO END
GO
CREATE FUNCTION FL_CL_CERTIFICATENO(@P_USERID varchar(50), @P_PolicyNo varchar(20),@P_CertificateNo varchar(10))            
RETURNS TABLE            
AS RETURN            
(Select A.CertificateNo, A.AName, A.SDate, A.EDate, A.PDate, A.PPDate, A.NCDate, A.ExtPeriod            
from Acceptance A Inner Join Cover C on (C.CNO=A.CNO)          
Where A.ATYPE Not In ('A','C') And A.ASTATUS NOT IN ('W','T') And C.CStatus<>'C' And A.PDATE<>A.PPDATE And A.ANO<>A.LANO And A.LANO <> -1
and A.PolicyNo=@P_PolicyNo and A.CertificateNo Like @P_CertificateNo+'%'          
and A.Branch in (Select S.Branch from SysUserBranch S Where S.ID=@P_UserID)          
and A.TOC in (Select S.TOC from SysUserTOC S Where S.ID=@P_UserID)          
)       
  
GO

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].FL_CL_POLICYNO') AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) ) 
BEGIN DROP FUNCTION [dbo].FL_CL_POLICYNO END
GO
CREATE FUNCTION FL_CL_POLICYNO(@P_USERID varchar(50), @P_PolicyNo varchar(20))                        
RETURNS TABLE                        
AS RETURN                        
(Select A.PolicyNo, A.CertificateNo, A.AName, A.SDate, A.EDate, A.PDate, A.PPDate, A.NCDate, A.ExtPeriod                   
from Acceptance A Inner Join Cover C on (C.CNO=A.CNO)                    
Where A.ATYPE Not In ('A','C') And A.ASTATUS Not in ('W','T') and C.CStatus not in ('R','P','C')             
And A.PDATE<A.PPDATE And A.ANO<>A.LANO              
and A.PolicyNo<>'' and A.PolicyNo Like @P_PolicyNo+'%'                    
and EXISTS (Select S.Branch from SysUserBranch S Where S.Branch=A.Branch and S.ID=@P_UserID)                    
and EXISTS (Select S.TOC from SysUserTOC S Where S.TOC=A.TOC and S.ID=@P_UserID)                    
)       

GO

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].FL_RateCode') AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) ) 
BEGIN DROP FUNCTION [dbo].FL_RateCode END
GO
CREATE Function FL_RateCode(@P_ANO as integer, @P_Code as varchar(10),@P_AllowedF as bit=0, @P_TSI as float=0, @P_TOPF as bit=0)   
RETURNS Table   
AS RETURN   
(   
SELECT  RateTab.Code, RateTab.AllowedF, RateTab.NoRefundF, RateTab.SIBasedID,  
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
--in Percentage   
sum(case when coalesce(F.MinRate,0)<>0 then F.MinRate else RateTab.MinRate end*RateCov.Portion/100) as MinRate,   
sum(case when coalesce(F.MaxRate,0)<>0 then F.MaxRate else RateTab.MaxRate end*RateCov.Portion/100) as MaxRate,   
max(F.PML) as PML,   
sum(RateCov.Portion) AS Portion,   
MAX(Case When coalesce(F.Loading,0)=0 Then 1 else F.Loading/100 end) As Loading,   
Max(F.TExcess) as TExcess   
FROM  Acceptance   
Inner join Cover on (Cover.CNO=Acceptance.CNO)   
Inner join RateTab on ((RateTab.TOC=substring(Acceptance.TOC,1,len(RateTab.TOC))) and (@P_Code='%' or RateTab.Code Like @P_Code OR RateTab.Description Like @P_Code) And (RateTab.AllowedF=@P_AllowedF or @P_AllowedF=0))   
Inner join RateCov on (RateCov.Code=RateTab.Code)   
Inner join RClass on (RClass.TOC=Acceptance.TOC And RClass.TOR=RateCov.TOR)   
Left Join fn_RateCon(@P_ANO,@P_Code,@P_TSI) F on (F.Code=RateTab.Code)   
Left join TOP_RATE on (TOP_RATE.TOPRO=Acceptance.TOPRO and (TOP_Rate.Code=RateTab.Code or TOP_Rate.Code=RateTab.PCode))   
WHERE  Acceptance.ANO=@P_ANO and coalesce(F.AllowedF,1)=1  and (@P_TOPF=0 or coalesce(TOP_RATE.TOPRO,'')=Acceptance.TOPRO)   
GROUP BY RateTab.Code, RateTab.AllowedF, RateTab.NoRefundF , RateTab.SIBasedID  
)   

GO

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].FL_REINSURANCE_CESSION') AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) ) 
BEGIN DROP FUNCTION [dbo].FL_REINSURANCE_CESSION END
GO
CREATE Function FL_REINSURANCE_CESSION(@P_ANO integer, @P_ADate smalldatetime, @P_RType varchar(255), @P_TSI Float=0, @P_RID varchar(20)='', @P_ManualF Bit=0)                                
Returns Table        
As Return        
(        
SELECT Reinsurance.RID, Reinsurance.Description, Reinsurance.RType,                                
ReClass.PLimit, Case RECLASS.Limit WHEN 0 then Reinsurance.Limit Else RECLASS.Limit end as limit, ReClass.ShortFallLimit,              
ReClass.MinTSI, Reinsurance.UjrohReins, Reinsurance.UjrohCedant, Reinsurance.Share, Reinsurance.PShare, ReClass.CessionF, ReClass.AssessmentF, ReClass.DirectF                                
From Acceptance       
Inner Join Cover on (Cover.CNO=Acceptance.CNO)      
Inner Join RArrHeader on (RArrHeader.ANO=Acceptance.ANO)      
Inner Join Reinsurance on (Reinsurance.RType=@P_RType)      
Inner Join ReClass on (ReClass.RNO=Reinsurance.RNO and ReClass.TOC=Acceptance.TOC)      
Left Join RePolicy on (RePolicy.RNO=Reinsurance.RNO)      
WHERE ACCEPTANCE.ANO=@P_ANO         
And Case When Reinsurance.PolicyRunOffF=1 Then Acceptance.SDate else @P_ADATE end Between Reinsurance.SDate And Reinsurance.EDate       
And (@P_RID='' or Reinsurance.RID=@P_RID or RArrHeader.ManualF=0 or Acceptance.EMethod='T')                            
And (coalesce(RePolicy.ID,'')='' or  coalesce(RePolicy.ID,'')=Cover.PHolder)    
And (@P_ManualF=1 or RArrHeader.ManualF=1 or       
(      
 (Reinsurance.ORBusinessF=RArrHeader.ORBusinessF)      
 And (@P_TSI>=ReClass.MinTSI or ReClass.MinTSI=0) and (@P_TSI<=ReClass.MaxTSI or ReClass.MaxTSI=0)  
 And (    
 (datediff(month, acceptance.sdate, acceptance.edate)>=ReClass.MinPeriod)     
 or (datediff(month, acceptance.sdate, acceptance.edate)=ReClass.MinPeriod-1 and day(acceptance.sdate)<day(acceptance.edate))     
 or ReClass.MinPeriod=0)                               
 And (    
 (datediff(month, acceptance.sdate, acceptance.edate)<ReClass.MaxPeriod)     
 or (datediff(month, acceptance.sdate, acceptance.edate)=ReClass.MaxPeriod and day(acceptance.sdate)>=day(acceptance.edate))     
 or ReClass.MaxPeriod=0))      
)             
)            

GO

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].FL_SchemePolicy') AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) ) 
BEGIN DROP FUNCTION [dbo].FL_SchemePolicy END
GO
CREATE function FL_SchemePolicy(@P_SchemeNo varchar(10), @P_PolicyNo varchar(10))                
RETURNS Table                  
AS RETURN                  
(                  
Select Distinct a.PolicyNo, a.AName as Insured, a.LANO, a.CNO, a.AID, S.SchemeNo   
from acceptance as a, cover as c, Scheme_Master S   
where S.TOC=A.TOC and S.SchemeNo Like @P_SchemeNo+'%'   
and a.cno=c.cno and a.ano = a.lano and c.openflag=1   
and A.AType not in ('A','C') and a.astatus = 'I'   
and a.PolicyNo like @P_PolicyNo+'%'   
and   
(not exists (Select * from Scheme_Assignment Where SchemeNo=@P_SchemeNo)   
or exists (Select * from Scheme_Assignment Where SchemeNo=@P_SchemeNo and PolicyNo=a.PolicyNo)))    
  
  
GO 
 
IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].FL_SR_CertificateNo') AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) ) 
BEGIN DROP FUNCTION [dbo].FL_SR_CertificateNo END
GO
Create function FL_SR_CertificateNo(@P_USERID varchar(50), @P_PolicyNo varchar(20),@P_CertificateNo varchar(10))      
RETURNS Table      
AS RETURN      
(Select A.CertificateNo, A.AName, A.SDate, A.EDate  
from Acceptance A Inner Join Cover C on (C.CNO=A.CNO)  
Where (A.LANO<>-1 or A.LANO<>A.ANO) and A.ATYPE Not In ('A','C') And A.ASTATUS<>'W' and C.Cstatus<>'C' And A.PDATE<>A.PPDATE   
and A.PolicyNo=@P_PolicyNo and A.CertificateNo Like @P_CertificateNo+'%'  
and A.Branch in (Select S.Branch from SysUserBranch S Where S.ID=@P_UserID)  
and A.TOC in (Select S.TOC from SysUserTOC S Where S.ID=@P_UserID)  
)   

GO

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].FL_SR_PolicyNo') AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) ) 
BEGIN DROP FUNCTION [dbo].FL_SR_PolicyNo END
GO
CREATE function FL_SR_PolicyNo(@P_USERID varchar(50), @P_PolicyNo varchar(20))        
RETURNS Table        
AS RETURN        
(Select A.PolicyNo, A.AName, A.SDate, A.EDate ,A.CertificateNo     
from Acceptance A Inner Join Cover C on (C.CNO=A.CNO)      
Where (A.LANO=-1 or A.LANO=A.ANO) and A.ATYPE Not In ('A','C')   
And A.ASTATUS<>'W' and C.CStatus<>'C' And A.PDATE<>A.PPDATE  
And C.ASource='UW'       
and A.PolicyNo Like @P_PolicyNo+'%'      
and A.Branch in (Select S.Branch from SysUserBranch S Where S.ID=@P_UserID)      
and A.TOC in (Select S.TOC from SysUserTOC S Where S.ID=@P_UserID)      
)   

GO

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].FL_SR_SchemeNo') AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) ) 
BEGIN DROP FUNCTION [dbo].FL_SR_SchemeNo END
GO
Create function FL_SR_SchemeNo(@P_USERID varchar(50), @P_SchemeNo varchar(10),@P_PolicyNo varchar(10))    
RETURNS Table    
AS RETURN    
(  
Select Distinct S.SchemeNo, S.Description, S.Disc, S.DailyBasisF, s.sPeriod, s.AllowedF   
from acceptance as a  
inner join cover as c on (a.cno=c.cno and c.OpenFlag=1)   
inner join Scheme_Master S on (S.TOC=A.TOC and S.SchemeNo Like @P_SchemeNo)  
inner join SysUser on (SysUser.ID=@P_UserID)  
Left Join Scheme_Branch S1 on (SysUser.Type<>'SUPERVISOR' and S1.SchemeNo=S.SchemeNo)   
where a.ano = a.lano and S.AllowedF=1 and A.AType not in ('A','C') and a.astatus = 'I' and a.PolicyNo Like @P_PolicyNo+'%'   
and NOT EXISTS (Select PANO from Acceptance Where Acceptance.PANO=a.ANO)  
and (SysUser.Type='SUPERVISOR' or S1.Branch is null or EXISTS (Select Branch from SysUserBranch Where SysUserBranch.Branch=S1.Branch and AllowedF=1 and ID=@P_UserID))  
and (SysUser.Type='SUPERVISOR' or EXISTS (Select TOC from SysUserTOC Where SysUserTOC.TOC=S.TOC and ID=@P_UserID))  
)

GO

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].FN_ONECARD') AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) ) 
BEGIN DROP FUNCTION [dbo].FN_ONECARD END
GO
CREATE FUNCTION FN_ONECARD(@P_CARDID as varchar(30))      
RETURNS TABLE AS      
RETURN (      
SELECT Distinct Acceptance.ANO    
from Acceptance, Cover, TOC, OneCardD Where TOC.TOC=Acceptance.TOC and TOC.COB<>'13' and Cover.PHolder=OneCardD.ID and Cover.CNO=Acceptance.CNO and OneCardD.CardID like @P_CardID+'%'      
) 

GO

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].fn_RateCon') AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) ) 
BEGIN DROP FUNCTION [dbo].fn_RateCon END
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
  RateTab.TOC=Acceptance.TOC and RateCon.Code=RateTab.Code And ((Case When @P_TSI=0 Then 1 Else @P_TSI End)>=RateCon.MinTSI or RateCon.MinTSI=0) and ((Case When @P_TSI=0 Then 1 Else @P_TSI End)<=RateCon.MaxTSI or RateCon.MaxTSI=0)       
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
  RateTab.TOC=Acceptance.TOC and RateCon.Code=RateTab.Code   
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
  
GO
  
IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].fn_RateCon_M1') AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) ) 
BEGIN DROP FUNCTION [dbo].fn_RateCon_M1 END
GO
CREATE FUNCTION fn_RateCon_M1(@P_ANO as int,@P_Code as varchar(20), @P_PDate as datetime)                          
RETURNS Table                          
AS RETURN (                          
SELECT Top 1 RateCon.Code, RateCon.Loading, RateCon.AllowedF              
From Acceptance                 
 INNER JOIN AInfo on (AInfo.ANO=Acceptance.ANO)                
 INNER JOIN COVER ON (COVER.CNO=ACCEPTANCE.CNO)                 
 INNER JOIN RateTab ON (RateTab.TOC=Acceptance.TOC and RateTab.Effective<=Acceptance.SDate and (@P_Code='%' or RateTab.Code Like @P_Code or RateTab.PCode Like @P_Code))              
 INNER JOIN RateCon_M1 RateCon  on (RateCon.Code=RateTab.Code)                
 Left Join GenDTab G1 on (G1.FLDID=AInfo.FLDID1 and ((G1.Formula='AGE' and cast(dbo.fn_Get_Age(AInfo.ValueDesc1,@P_PDate) as varchar(10)) Between G1.FLower and G1.FUpper) or (G1.Formula<>'AGE' and G1.ValueID=AInfo.ValueID1)))            
 Left Join GenDTab G2 on (G2.FLDID=AInfo.FLDID2 and ((G2.Formula='AGE' and cast(dbo.fn_Get_Age(AInfo.ValueDesc2,@P_PDate) as varchar(10)) Between G2.FLower and G2.FUpper) or (G2.Formula<>'AGE' and G2.ValueID=AInfo.ValueID2)))             
 Left Join GenDTab G3 on (G3.FLDID=AInfo.FLDID3 and ((G3.Formula='AGE' and cast(dbo.fn_Get_Age(AInfo.ValueDesc3,@P_PDate) as varchar(10)) Between G3.FLower and G3.FUpper) or (G3.Formula<>'AGE' and G3.ValueID=AInfo.ValueID3)))          
 Left Join GenDTab G4 on (G4.FLDID=AInfo.FLDID4 and ((G4.Formula='AGE' and cast(dbo.fn_Get_Age(AInfo.ValueDesc4,@P_PDate) as varchar(10)) Between G4.FLower and G4.FUpper) or (G4.Formula<>'AGE' and G4.ValueID=AInfo.ValueID4)))          
 Left Join GenDTab G5 on (G5.FLDID=AInfo.FLDID5 and ((G5.Formula='AGE' and cast(dbo.fn_Get_Age(AInfo.ValueDesc5,@P_PDate) as varchar(10)) Between G5.FLower and G5.FUpper) or (G5.Formula<>'AGE' and G5.ValueID=AInfo.ValueID5)))          
 Left Join GenDTab G6 on (G6.FLDID=AInfo.FLDID6 and ((G6.Formula='AGE' and cast(dbo.fn_Get_Age(AInfo.ValueDesc6,@P_PDate) as varchar(10)) Between G6.FLower and G6.FUpper) or (G6.Formula<>'AGE' and G6.ValueID=AInfo.ValueID6)))          
 Left Join GenDTab G7 on (G7.FLDID=AInfo.FLDID7 and ((G7.Formula='AGE' and cast(dbo.fn_Get_Age(AInfo.ValueDesc7,@P_PDate) as varchar(10)) Between G7.FLower and G7.FUpper) or (G7.Formula<>'AGE' and G7.ValueID=AInfo.ValueID7)))          
 Left Join GenDTab G8 on (G8.FLDID=AInfo.FLDID8 and ((G8.Formula='AGE' and cast(dbo.fn_Get_Age(AInfo.ValueDesc8,@P_PDate) as varchar(10)) Between G8.FLower and G8.FUpper) or (G8.Formula<>'AGE' and G8.ValueID=AInfo.ValueID8)))          
 Left Join GenDTab G9 on (G9.FLDID=AInfo.FLDID9 and ((G9.Formula='AGE' and cast(dbo.fn_Get_Age(AInfo.ValueDesc9,@P_PDate) as varchar(10)) Between G9.FLower and G9.FUpper) or (G9.Formula<>'AGE' and G9.ValueID=AInfo.ValueID9)))          
 Left Join GenDTab G10 on (G10.FLDID=AInfo.FLDID10 and ((G10.Formula='AGE' and cast(dbo.fn_Get_Age(AInfo.ValueDesc10,@P_PDate) as varchar(10)) Between G10.FLower and G10.FUpper) or (G10.Formula<>'AGE' and G10.ValueID=AInfo.ValueID10)))          
 Left Join GenDTab G11 on (G11.FLDID=AInfo.FLDID11 and ((G11.Formula='AGE' and cast(dbo.fn_Get_Age(AInfo.ValueDesc11,@P_PDate) as varchar(10)) Between G11.FLower and G11.FUpper) or (G11.Formula<>'AGE' and G11.ValueID=AInfo.ValueID11)))          
 Left Join GenDTab G12 on (G12.FLDID=AInfo.FLDID12 and ((G12.Formula='AGE' and cast(dbo.fn_Get_Age(AInfo.ValueDesc12,@P_PDate) as varchar(10)) Between G12.FLower and G12.FUpper) or (G12.Formula<>'AGE' and G12.ValueID=AInfo.ValueID12)))          
 Left Join GenDTab G13 on (G13.FLDID=AInfo.FLDID13 and ((G13.Formula='AGE' and cast(dbo.fn_Get_Age(AInfo.ValueDesc13,@P_PDate) as varchar(10)) Between G13.FLower and G13.FUpper) or (G13.Formula<>'AGE' and G13.ValueID=AInfo.ValueID13)))          
 Left Join GenDTab G14 on (G14.FLDID=AInfo.FLDID14 and ((G14.Formula='AGE' and cast(dbo.fn_Get_Age(AInfo.ValueDesc14,@P_PDate) as varchar(10)) Between G14.FLower and G14.FUpper) or (G14.Formula<>'AGE' and G14.ValueID=AInfo.ValueID14)))          
 Left Join GenDTab G15 on (G15.FLDID=AInfo.FLDID15 and ((G15.Formula='AGE' and cast(dbo.fn_Get_Age(AInfo.ValueDesc15,@P_PDate) as varchar(10)) Between G15.FLower and G15.FUpper) or (G15.Formula<>'AGE' and G15.ValueID=AInfo.ValueID15)))          
WHERE Acceptance.ANO=@P_ANO                       
And (coalesce(RateCon.ValueID1,'')='' or G1.ValueID =RateCon.ValueID1)                
And (coalesce(RateCon.ValueID2,'')='' or G2.ValueID =RateCon.ValueID2)                
And (coalesce(RateCon.ValueID3,'')='' or G3.ValueID =RateCon.ValueID3)                
And (coalesce(RateCon.ValueID4,'')='' or G4.ValueID =RateCon.ValueID4)                
And (coalesce(RateCon.ValueID5,'')='' or G5.ValueID =RateCon.ValueID5)                
And (coalesce(RateCon.ValueID6,'')='' or G6.ValueID =RateCon.ValueID6)                
And (coalesce(RateCon.ValueID7,'')='' or G7.ValueID =RateCon.ValueID7)                
And (coalesce(RateCon.ValueID8,'')='' or G8.ValueID =RateCon.ValueID8)                
And (coalesce(RateCon.ValueID9,'')='' or G9.ValueID =RateCon.ValueID9)                
And (coalesce(RateCon.ValueID10,'')='' or G10.ValueID =RateCon.ValueID10)                
And (coalesce(RateCon.ValueID11,'')='' or G11.ValueID =RateCon.ValueID11)                
And (coalesce(RateCon.ValueID12,'')='' or G12.ValueID =RateCon.ValueID12)                
And (coalesce(RateCon.ValueID13,'')='' or G13.ValueID =RateCon.ValueID13)                
And (coalesce(RateCon.ValueID14,'')='' or G14.ValueID =RateCon.ValueID14)                
And (coalesce(RateCon.ValueID15,'')='' or G15.ValueID =RateCon.ValueID15)                       
Order by   
RateTab.Effective Desc,  
RateCon.AllowedF Desc,                 
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
)  

GO

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].fn_RateCon_M2') AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) ) 
BEGIN DROP FUNCTION [dbo].fn_RateCon_M2 END
GO
CREATE FUNCTION fn_RateCon_M2(@P_ANO as int,@P_Code as varchar(20), @P_PDate as datetime)                                                   
RETURNS Table                          
AS RETURN (                          
SELECT Top 1 RateCon.Code, RateCon.Loading, RateCon.AllowedF              
From Acceptance                 
 INNER JOIN AInfo on (AInfo.ANO=Acceptance.ANO)                
 INNER JOIN COVER ON (COVER.CNO=ACCEPTANCE.CNO)                 
 INNER JOIN RateTab ON (RateTab.TOC=Acceptance.TOC and RateTab.Effective<=Acceptance.SDate and (@P_Code='%' or RateTab.Code Like @P_Code or RateTab.PCode Like @P_Code))              
 INNER JOIN RateCon_M2 RateCon  on (RateCon.Code=RateTab.Code)                
 Left Join GenDTab G1 on (G1.FLDID=AInfo.FLDID1 and ((G1.Formula='AGE' and cast(dbo.fn_Get_Age(AInfo.ValueDesc1,@P_PDate) as varchar(10)) Between G1.FLower and G1.FUpper) or (G1.Formula<>'AGE' and G1.ValueID=AInfo.ValueID1)))            
 Left Join GenDTab G2 on (G2.FLDID=AInfo.FLDID2 and ((G2.Formula='AGE' and cast(dbo.fn_Get_Age(AInfo.ValueDesc2,@P_PDate) as varchar(10)) Between G2.FLower and G2.FUpper) or (G2.Formula<>'AGE' and G2.ValueID=AInfo.ValueID2)))             
 Left Join GenDTab G3 on (G3.FLDID=AInfo.FLDID3 and ((G3.Formula='AGE' and cast(dbo.fn_Get_Age(AInfo.ValueDesc3,@P_PDate) as varchar(10)) Between G3.FLower and G3.FUpper) or (G3.Formula<>'AGE' and G3.ValueID=AInfo.ValueID3)))          
 Left Join GenDTab G4 on (G4.FLDID=AInfo.FLDID4 and ((G4.Formula='AGE' and cast(dbo.fn_Get_Age(AInfo.ValueDesc4,@P_PDate) as varchar(10)) Between G4.FLower and G4.FUpper) or (G4.Formula<>'AGE' and G4.ValueID=AInfo.ValueID4)))          
 Left Join GenDTab G5 on (G5.FLDID=AInfo.FLDID5 and ((G5.Formula='AGE' and cast(dbo.fn_Get_Age(AInfo.ValueDesc5,@P_PDate) as varchar(10)) Between G5.FLower and G5.FUpper) or (G5.Formula<>'AGE' and G5.ValueID=AInfo.ValueID5)))          
 Left Join GenDTab G6 on (G6.FLDID=AInfo.FLDID6 and ((G6.Formula='AGE' and cast(dbo.fn_Get_Age(AInfo.ValueDesc6,@P_PDate) as varchar(10)) Between G6.FLower and G6.FUpper) or (G6.Formula<>'AGE' and G6.ValueID=AInfo.ValueID6)))          
 Left Join GenDTab G7 on (G7.FLDID=AInfo.FLDID7 and ((G7.Formula='AGE' and cast(dbo.fn_Get_Age(AInfo.ValueDesc7,@P_PDate) as varchar(10)) Between G7.FLower and G7.FUpper) or (G7.Formula<>'AGE' and G7.ValueID=AInfo.ValueID7)))          
 Left Join GenDTab G8 on (G8.FLDID=AInfo.FLDID8 and ((G8.Formula='AGE' and cast(dbo.fn_Get_Age(AInfo.ValueDesc8,@P_PDate) as varchar(10)) Between G8.FLower and G8.FUpper) or (G8.Formula<>'AGE' and G8.ValueID=AInfo.ValueID8)))          
 Left Join GenDTab G9 on (G9.FLDID=AInfo.FLDID9 and ((G9.Formula='AGE' and cast(dbo.fn_Get_Age(AInfo.ValueDesc9,@P_PDate) as varchar(10)) Between G9.FLower and G9.FUpper) or (G9.Formula<>'AGE' and G9.ValueID=AInfo.ValueID9)))          
 Left Join GenDTab G10 on (G10.FLDID=AInfo.FLDID10 and ((G10.Formula='AGE' and cast(dbo.fn_Get_Age(AInfo.ValueDesc10,@P_PDate) as varchar(10)) Between G10.FLower and G10.FUpper) or (G10.Formula<>'AGE' and G10.ValueID=AInfo.ValueID10)))          
 Left Join GenDTab G11 on (G11.FLDID=AInfo.FLDID11 and ((G11.Formula='AGE' and cast(dbo.fn_Get_Age(AInfo.ValueDesc11,@P_PDate) as varchar(10)) Between G11.FLower and G11.FUpper) or (G11.Formula<>'AGE' and G11.ValueID=AInfo.ValueID11)))          
 Left Join GenDTab G12 on (G12.FLDID=AInfo.FLDID12 and ((G12.Formula='AGE' and cast(dbo.fn_Get_Age(AInfo.ValueDesc12,@P_PDate) as varchar(10)) Between G12.FLower and G12.FUpper) or (G12.Formula<>'AGE' and G12.ValueID=AInfo.ValueID12)))          
 Left Join GenDTab G13 on (G13.FLDID=AInfo.FLDID13 and ((G13.Formula='AGE' and cast(dbo.fn_Get_Age(AInfo.ValueDesc13,@P_PDate) as varchar(10)) Between G13.FLower and G13.FUpper) or (G13.Formula<>'AGE' and G13.ValueID=AInfo.ValueID13)))          
 Left Join GenDTab G14 on (G14.FLDID=AInfo.FLDID14 and ((G14.Formula='AGE' and cast(dbo.fn_Get_Age(AInfo.ValueDesc14,@P_PDate) as varchar(10)) Between G14.FLower and G14.FUpper) or (G14.Formula<>'AGE' and G14.ValueID=AInfo.ValueID14)))          
 Left Join GenDTab G15 on (G15.FLDID=AInfo.FLDID15 and ((G15.Formula='AGE' and cast(dbo.fn_Get_Age(AInfo.ValueDesc15,@P_PDate) as varchar(10)) Between G15.FLower and G15.FUpper) or (G15.Formula<>'AGE' and G15.ValueID=AInfo.ValueID15)))          
WHERE Acceptance.ANO=@P_ANO                       
And (coalesce(RateCon.ValueID1,'')='' or G1.ValueID =RateCon.ValueID1)                
And (coalesce(RateCon.ValueID2,'')='' or G2.ValueID =RateCon.ValueID2)                
And (coalesce(RateCon.ValueID3,'')='' or G3.ValueID =RateCon.ValueID3)                
And (coalesce(RateCon.ValueID4,'')='' or G4.ValueID =RateCon.ValueID4)                
And (coalesce(RateCon.ValueID5,'')='' or G5.ValueID =RateCon.ValueID5)                
And (coalesce(RateCon.ValueID6,'')='' or G6.ValueID =RateCon.ValueID6)                
And (coalesce(RateCon.ValueID7,'')='' or G7.ValueID =RateCon.ValueID7)                
And (coalesce(RateCon.ValueID8,'')='' or G8.ValueID =RateCon.ValueID8)                
And (coalesce(RateCon.ValueID9,'')='' or G9.ValueID =RateCon.ValueID9)                
And (coalesce(RateCon.ValueID10,'')='' or G10.ValueID =RateCon.ValueID10)                
And (coalesce(RateCon.ValueID11,'')='' or G11.ValueID =RateCon.ValueID11)                
And (coalesce(RateCon.ValueID12,'')='' or G12.ValueID =RateCon.ValueID12)                
And (coalesce(RateCon.ValueID13,'')='' or G13.ValueID =RateCon.ValueID13)                
And (coalesce(RateCon.ValueID14,'')='' or G14.ValueID =RateCon.ValueID14)                
And (coalesce(RateCon.ValueID15,'')='' or G15.ValueID =RateCon.ValueID15)                       
Order by   
RateTab.Effective Desc,  
RateCon.AllowedF Desc,                 
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
)           

GO
          
IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].fn_RateCon_M3') AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) ) 
BEGIN DROP FUNCTION [dbo].fn_RateCon_M3 END
GO
CREATE FUNCTION fn_RateCon_M3(@P_ANO as int,@P_Code as varchar(20), @P_PDate as datetime)                          
RETURNS Table                          
AS RETURN (                          
SELECT Top 1 RateCon.Code, RateCon.Loading, RateCon.AllowedF              
From Acceptance                 
 INNER JOIN AInfo on (AInfo.ANO=Acceptance.ANO)                
 INNER JOIN COVER ON (COVER.CNO=ACCEPTANCE.CNO)                 
 INNER JOIN RateTab ON (RateTab.TOC=Acceptance.TOC and RateTab.Effective<=Acceptance.SDate and (@P_Code='%' or RateTab.Code Like @P_Code or RateTab.PCode Like @P_Code))              
 INNER JOIN RateCon_M3 RateCon  on (RateCon.Code=RateTab.Code)                
 Left Join GenDTab G1 on (G1.FLDID=AInfo.FLDID1 and ((G1.Formula='AGE' and cast(dbo.fn_Get_Age(AInfo.ValueDesc1,@P_PDate) as varchar(10)) Between G1.FLower and G1.FUpper) or (G1.Formula<>'AGE' and G1.ValueID=AInfo.ValueID1)))            
 Left Join GenDTab G2 on (G2.FLDID=AInfo.FLDID2 and ((G2.Formula='AGE' and cast(dbo.fn_Get_Age(AInfo.ValueDesc2,@P_PDate) as varchar(10)) Between G2.FLower and G2.FUpper) or (G2.Formula<>'AGE' and G2.ValueID=AInfo.ValueID2)))             
 Left Join GenDTab G3 on (G3.FLDID=AInfo.FLDID3 and ((G3.Formula='AGE' and cast(dbo.fn_Get_Age(AInfo.ValueDesc3,@P_PDate) as varchar(10)) Between G3.FLower and G3.FUpper) or (G3.Formula<>'AGE' and G3.ValueID=AInfo.ValueID3)))          
 Left Join GenDTab G4 on (G4.FLDID=AInfo.FLDID4 and ((G4.Formula='AGE' and cast(dbo.fn_Get_Age(AInfo.ValueDesc4,@P_PDate) as varchar(10)) Between G4.FLower and G4.FUpper) or (G4.Formula<>'AGE' and G4.ValueID=AInfo.ValueID4)))          
 Left Join GenDTab G5 on (G5.FLDID=AInfo.FLDID5 and ((G5.Formula='AGE' and cast(dbo.fn_Get_Age(AInfo.ValueDesc5,@P_PDate) as varchar(10)) Between G5.FLower and G5.FUpper) or (G5.Formula<>'AGE' and G5.ValueID=AInfo.ValueID5)))          
 Left Join GenDTab G6 on (G6.FLDID=AInfo.FLDID6 and ((G6.Formula='AGE' and cast(dbo.fn_Get_Age(AInfo.ValueDesc6,@P_PDate) as varchar(10)) Between G6.FLower and G6.FUpper) or (G6.Formula<>'AGE' and G6.ValueID=AInfo.ValueID6)))          
 Left Join GenDTab G7 on (G7.FLDID=AInfo.FLDID7 and ((G7.Formula='AGE' and cast(dbo.fn_Get_Age(AInfo.ValueDesc7,@P_PDate) as varchar(10)) Between G7.FLower and G7.FUpper) or (G7.Formula<>'AGE' and G7.ValueID=AInfo.ValueID7)))          
 Left Join GenDTab G8 on (G8.FLDID=AInfo.FLDID8 and ((G8.Formula='AGE' and cast(dbo.fn_Get_Age(AInfo.ValueDesc8,@P_PDate) as varchar(10)) Between G8.FLower and G8.FUpper) or (G8.Formula<>'AGE' and G8.ValueID=AInfo.ValueID8)))          
 Left Join GenDTab G9 on (G9.FLDID=AInfo.FLDID9 and ((G9.Formula='AGE' and cast(dbo.fn_Get_Age(AInfo.ValueDesc9,@P_PDate) as varchar(10)) Between G9.FLower and G9.FUpper) or (G9.Formula<>'AGE' and G9.ValueID=AInfo.ValueID9)))          
 Left Join GenDTab G10 on (G10.FLDID=AInfo.FLDID10 and ((G10.Formula='AGE' and cast(dbo.fn_Get_Age(AInfo.ValueDesc10,@P_PDate) as varchar(10)) Between G10.FLower and G10.FUpper) or (G10.Formula<>'AGE' and G10.ValueID=AInfo.ValueID10)))          
 Left Join GenDTab G11 on (G11.FLDID=AInfo.FLDID11 and ((G11.Formula='AGE' and cast(dbo.fn_Get_Age(AInfo.ValueDesc11,@P_PDate) as varchar(10)) Between G11.FLower and G11.FUpper) or (G11.Formula<>'AGE' and G11.ValueID=AInfo.ValueID11)))          
 Left Join GenDTab G12 on (G12.FLDID=AInfo.FLDID12 and ((G12.Formula='AGE' and cast(dbo.fn_Get_Age(AInfo.ValueDesc12,@P_PDate) as varchar(10)) Between G12.FLower and G12.FUpper) or (G12.Formula<>'AGE' and G12.ValueID=AInfo.ValueID12)))          
 Left Join GenDTab G13 on (G13.FLDID=AInfo.FLDID13 and ((G13.Formula='AGE' and cast(dbo.fn_Get_Age(AInfo.ValueDesc13,@P_PDate) as varchar(10)) Between G13.FLower and G13.FUpper) or (G13.Formula<>'AGE' and G13.ValueID=AInfo.ValueID13)))          
 Left Join GenDTab G14 on (G14.FLDID=AInfo.FLDID14 and ((G14.Formula='AGE' and cast(dbo.fn_Get_Age(AInfo.ValueDesc14,@P_PDate) as varchar(10)) Between G14.FLower and G14.FUpper) or (G14.Formula<>'AGE' and G14.ValueID=AInfo.ValueID14)))          
 Left Join GenDTab G15 on (G15.FLDID=AInfo.FLDID15 and ((G15.Formula='AGE' and cast(dbo.fn_Get_Age(AInfo.ValueDesc15,@P_PDate) as varchar(10)) Between G15.FLower and G15.FUpper) or (G15.Formula<>'AGE' and G15.ValueID=AInfo.ValueID15)))          
WHERE Acceptance.ANO=@P_ANO                       
And (coalesce(RateCon.ValueID1,'')='' or G1.ValueID =RateCon.ValueID1)                
And (coalesce(RateCon.ValueID2,'')='' or G2.ValueID =RateCon.ValueID2)                
And (coalesce(RateCon.ValueID3,'')='' or G3.ValueID =RateCon.ValueID3)                
And (coalesce(RateCon.ValueID4,'')='' or G4.ValueID =RateCon.ValueID4)                
And (coalesce(RateCon.ValueID5,'')='' or G5.ValueID =RateCon.ValueID5)                
And (coalesce(RateCon.ValueID6,'')='' or G6.ValueID =RateCon.ValueID6)                
And (coalesce(RateCon.ValueID7,'')='' or G7.ValueID =RateCon.ValueID7)                
And (coalesce(RateCon.ValueID8,'')='' or G8.ValueID =RateCon.ValueID8)                
And (coalesce(RateCon.ValueID9,'')='' or G9.ValueID =RateCon.ValueID9)                
And (coalesce(RateCon.ValueID10,'')='' or G10.ValueID =RateCon.ValueID10)                
And (coalesce(RateCon.ValueID11,'')='' or G11.ValueID =RateCon.ValueID11)                
And (coalesce(RateCon.ValueID12,'')='' or G12.ValueID =RateCon.ValueID12)                
And (coalesce(RateCon.ValueID13,'')='' or G13.ValueID =RateCon.ValueID13)                
And (coalesce(RateCon.ValueID14,'')='' or G14.ValueID =RateCon.ValueID14)                
And (coalesce(RateCon.ValueID15,'')='' or G15.ValueID =RateCon.ValueID15)                       
Order by   
RateTab.Effective Desc,  
RateCon.AllowedF Desc,                 
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
)   
 
GO
 
IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].fn_RiskAssLimit') AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) ) 
BEGIN DROP FUNCTION [dbo].fn_RiskAssLimit END
GO
CREATE FUNCTION fn_RiskAssLimit(@P_ANO as int)  
RETURNS TABLE  
AS RETURN (  
 SELECT Acceptance.ANO, max(RiskAss.Rate) as Rate, max(RiskAss.Loading) as Loading  
 from Acceptance, Cover, AInfo, RiskAss   
 Where Acceptance.ANO=@P_ANO and  
 Cover.CNO=Acceptance.CNO and AInfo.ANO=Acceptance.ANO   
 and RiskAss.RYear=Year(Acceptance.SDate) and RiskAss.TOC=Acceptance.TOC  
 And ((RiskAss.ValueID1='' and Ainfo.ValueDesc1 Like   
 RiskAss.ValueDesc1+'%') or (RiskAss.ValueID1<>'' and AInfo.ValueID1 Like   
 RiskAss.ValueID1+'%') or (RiskAss.ValueID1 is null))  
 And ((RiskAss.ValueID2='' and Ainfo.ValueDesc2 Like   
 RiskAss.ValueDesc2+'%') or (RiskAss.ValueID2<>'' and AInfo.ValueID2 Like   
 RiskAss.ValueID2+'%') or (RiskAss.ValueID2 is null))  
 And ((RiskAss.ValueID3='' and Ainfo.ValueDesc3 Like   
 RiskAss.ValueDesc3+'%') or (RiskAss.ValueID3<>'' and AInfo.ValueID3 Like   
 RiskAss.ValueID3+'%') or (RiskAss.ValueID3 is null))  
 And ((RiskAss.ValueID4='' and Ainfo.ValueDesc4 Like   
 RiskAss.ValueDesc4+'%') or (RiskAss.ValueID4<>'' and AInfo.ValueID4 Like   
 RiskAss.ValueID4+'%') or (RiskAss.ValueID4 is null))  
 And ((RiskAss.ValueID5='' and Ainfo.ValueDesc5 Like   
 RiskAss.ValueDesc5+'%') or (RiskAss.ValueID5<>'' and AInfo.ValueID5 Like   
 RiskAss.ValueID5+'%') or (RiskAss.ValueID5 is null))  
 And ((RiskAss.ValueID6='' and Ainfo.ValueDesc6 Like   
 RiskAss.ValueDesc6+'%') or (RiskAss.ValueID6<>'' and AInfo.ValueID6 Like   
 RiskAss.ValueID6+'%') or (RiskAss.ValueID6 is null))  
 And ((RiskAss.ValueID7='' and Ainfo.ValueDesc7 Like   
 RiskAss.ValueDesc7+'%') or (RiskAss.ValueID7<>'' and AInfo.ValueID7 Like   
 RiskAss.ValueID7+'%') or (RiskAss.ValueID7 is null))  
 And ((RiskAss.ValueID8='' and Ainfo.ValueDesc8 Like   
 RiskAss.ValueDesc8+'%') or (RiskAss.ValueID8<>'' and AInfo.ValueID8 Like   
 RiskAss.ValueID8+'%') or (RiskAss.ValueID8 is null))  
 And ((RiskAss.ValueID9='' and Ainfo.ValueDesc9 Like   
 RiskAss.ValueDesc9+'%') or (RiskAss.ValueID9<>'' and AInfo.ValueID9 Like   
 RiskAss.ValueID9+'%') or (RiskAss.ValueID9 is null))  
 And ((RiskAss.ValueID10='' and Ainfo.ValueDesc10 Like   
 RiskAss.ValueDesc10+'%') or (RiskAss.ValueID10<>'' and AInfo.ValueID10 Like   
 RiskAss.ValueID10+'%') or (RiskAss.ValueID10 is null))  
 And ((RiskAss.ValueID11='' and Ainfo.ValueDesc11 Like   
 RiskAss.ValueDesc11+'%') or (RiskAss.ValueID11<>'' and AInfo.ValueID11 Like   
 RiskAss.ValueID11+'%') or (RiskAss.ValueID11 is null))  
 And ((RiskAss.ValueID12='' and Ainfo.ValueDesc12 Like   
 RiskAss.ValueDesc12+'%') or (RiskAss.ValueID12<>'' and AInfo.ValueID12 Like   
 RiskAss.ValueID12+'%') or (RiskAss.ValueID12 is null))  
 And ((RiskAss.ValueID13='' and Ainfo.ValueDesc13 Like   
 RiskAss.ValueDesc13+'%') or (RiskAss.ValueID13<>'' and AInfo.ValueID13 Like   
 RiskAss.ValueID13+'%') or (RiskAss.ValueID13 is null))  
 And ((RiskAss.ValueID14='' and Ainfo.ValueDesc14 Like   
 RiskAss.ValueDesc14+'%') or (RiskAss.ValueID14<>'' and AInfo.ValueID14 Like   
 RiskAss.ValueID14+'%') or (RiskAss.ValueID14 is null))  
 And ((RiskAss.ValueID15='' and Ainfo.ValueDesc15 Like   
 RiskAss.ValueDesc15+'%') or (RiskAss.ValueID15<>'' and AInfo.ValueID15 Like   
 RiskAss.ValueID15+'%') or (RiskAss.ValueID15 is null))  
 Group By Acceptance.ANO  
)  

GO

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].fn_RRateCon') AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) ) 
BEGIN DROP FUNCTION [dbo].fn_RRateCon END
GO
CREATE FUNCTION fn_RRateCon(@P_ANO as int,@P_RID as varchar(20),@P_TSI as Float=0)       
RETURNS Table       
AS RETURN (       
SELECT Top 1 RateCon.Code, RateCon.AllowedF, RateCon.MinRate, RateCon.MaxRate, RateCon.PML, RateCon.TExcess, RateTab.RateLoadingF,       
Case When coalesce(RateCon.Loading,0)=0 Then 100 else RateCon.Loading end as Loading,       
--Rate Always in Percent       
Case       
When RateCon.Unit='F' then (Case When @P_TSI<>0 Then RateCon.Rate/@P_TSI*100 else 0 end)       
When RateCon.Unit='M' then RateCon.Rate/10       
else RateCon.Rate end as Rate       
From Acceptance       
INNER JOIN AInfo on (AInfo.ANO=Acceptance.ANO)       
INNER JOIN COVER ON (COVER.CNO=ACCEPTANCE.CNO)       
INNER JOIN REINSURANCE on (REINSURANCE.RID=@P_RID)       
INNER JOIN RECLASS ON (RECLASS.RNO=REINSURANCE.RNO AND RECLASS.TOC=Acceptance.TOC)       
INNER JOIN RateTab ON (RateTab.Effective<=Acceptance.SDate and (RateTab.Code=RECLASS.CODE or RateTab.PCode=RECLASS.CODE))       
LEFT JOIN RateCon on (      
 RateTab.TOC=Acceptance.TOC and RateCon.Code=RateTab.Code And (@P_TSI>=RateCon.MinTSI or RateCon.MinTSI=0) and (@P_TSI<=RateCon.MaxTSI or RateCon.MaxTSI=0)       
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
RateCon.AllowedF Desc,         
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
)    

GO

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].Get_Claim_APRule') AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) ) 
BEGIN DROP FUNCTION [dbo].Get_Claim_APRule END
GO
Create function Get_Claim_APRule(@P_CNO as int)      
RETURNS Table      
AS RETURN      
(      
Select AD.RuleID, AD.Class, AD.RepName, AD.ExeName  
from APDRuleH AH INNER JOIN APDRULED AD ON (AH.RULEID=AD.RULEID) INNER JOIN SYSCLASS S ON (S.CLASS=AD.CLASS)  
Where AH.AllowedF=1 AND AH.APPTYPE='CLAIM'  
and 1 in   
(  
Select 1 from Acceptance A, Cover C, Claim  
Where Claim.CNO=@P_CNO and A.ANO=Claim.ANO and C.CNO=A.CNO and C.PolicyType=AH.PolicyType and C.ISType=AH.ISType and (C.Segment=AH.Segment or AH.Segment='<All>') and A.TOC=AH.TOC and (A.TOPRO=AH.TOPRO or AH.TOPRO='<All>')  
and charindex(Claim.CType,S.ClaimCType)<>0  
and charindex(Claim.CStatus,S.ClaimCStatus)<>0  
)  
)   

GO

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].Get_Policy_APRule') AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) ) 
BEGIN DROP FUNCTION [dbo].Get_Policy_APRule END
GO
Create function Get_Policy_APRule(@P_ANO as int)      
RETURNS Table      
AS RETURN      
(      
Select AD.RuleID, AD.Class, AD.RepName, AD.ExeName  
from APDRuleH AH INNER JOIN APDRULED AD ON (AH.RULEID=AD.RULEID) INNER JOIN SYSCLASS S ON (S.CLASS=AD.CLASS)  
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

GO

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].List_Spc_03_Det') AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) ) 
BEGIN DROP FUNCTION [dbo].List_Spc_03_Det END
GO
CREATE  FUNCTION List_Spc_03_Det (@P_ANO AS INTEGER)   
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
 QPCalc.TSI,   
 QPCalc.OurShare,   
 QPCalc.Gross,   
 Acceptance.ASTATUS,   
 Acceptance.ATYPE,   
 Acceptance.SDate,   
 Acceptance.EDate,   
 Year(Acceptance.SDate) AS RYear,  
 QPCalc.ValueID, QPCalc.ValueDesc  
FROM Acceptance, Cover, SysTab, QMasterAcceptance_PCalc() AS QPCalc, RArrHeader  
WHERE   
 Cover.CNO=Acceptance.CNO   
 And QPCalc.ANO=Acceptance.ANO   
 And Acceptance.ANO<>Acceptance.LANO   
 And Acceptance.LANO=@P_ANO  
 And RArrHeader.ANO=Acceptance.ANO  
 And Acceptance.AStatus in ('I','W') and Acceptance.AType<>'C'  
 And Acceptance.TOC='0111'  
 And RArrHeader.FAmount=0  
)  
   
GO

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].List05_Det') AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) ) 
BEGIN DROP FUNCTION [dbo].List05_Det END
GO
CREATE FUNCTION List05_Det (@P_ANO as integer, @P_UserID as varchar(50), @pSDate as smallDateTime, @pEDate as smallDateTime, @pBranch as varchar(10), @pTOC as varchar(10), @pMO as varchar(10))      
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
 QPCalc.TSI,      
 QPCalc.OurShare,      
 QPCalc.Gross,      
 Acceptance.ASTATUS,      
 Acceptance.ATYPE,      
 Acceptance.SDate,      
 Acceptance.EDate,      
 Year(Acceptance.SDate) AS RYear,      
 QPCalc.ValueID,      
 QPCalc.ValueDesc      
From      
 Acceptance,      
 Cover,      
 SysTab,      
 QMasterAcceptance_PCalc() AS QPCalc,      
 RARRHEADER      
Where      
 cover.CNO = acceptance.CNO      
 And Rarrheader.ANO = Acceptance.ANO      
 And QPCalc.ANO=Acceptance.ANO      
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

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].List06_Det') AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) ) 
BEGIN DROP FUNCTION [dbo].List06_Det END
GO
CREATE FUNCTION List06_Det (@P_ANO as integer, @P_UserID as varchar(50), @pSDate as smalldatetime, @pEDate as smallDateTime, @pBranch as varchar(10), @pTOC as varchar(10), @pMO as varchar(10))      
RETURNS TABLE      
AS RETURN(      
      
SELECT Cast(0 as bit) as ProcessFlag,      
 [Acceptance].[CertificateNo],       
 Acceptance.ESeqNo,      
 [Acceptance].[AName],       
 [Acceptance].[ANO],       
 [Acceptance].[REGNO],       
 [Acceptance].[ADATE],       
 [Acceptance].[LUSERID] as UserID,       
 [SysTab].[Currency],       
 [QPCalc].[TSI],       
 [QPCalc].[OurShare],       
 [QPCalc].[Gross],       
 [Acceptance].[ASTATUS],       
 [Acceptance].[ATYPE],       
 [Acceptance].[SDate],       
 [Acceptance].[EDate],       
 Year([Acceptance].[SDate]) AS RYear,      
  Acceptance.ValueID,      
  Acceptance.ValueDesc      
FROM       
 Acceptance,       
 Cover,       
 SysTab,       
 QMasterAcceptance_PCalc() AS QPCalc      
WHERE       
 [Cover].[CNO]=[Acceptance].[CNO]       
 And [QPCalc].[ANO]=[Acceptance].[ANO]       
 And [Acceptance].[ANO]<>[Acceptance].[LANO]       
 And [Acceptance].[LANO]=@P_ANO      
 And [Acceptance].[AStatus]='I'       
 And [Acceptance].[AType]<>'C'       
 And [Cover].[ISType]<>'T'       
 And Acceptance.Branch like @pBranch+'%'    
 And Acceptance.TOC Like @pTOC+'%'      
 And Cover.MO like @pMO+'%'    
 And [Acceptance].[EDate] between @pSDate and @pEDate       
 And Exists (Select S1.ID from SysUser S1 Left Join SysUserBranch S2 on (S2.ID=S1.ID and S2.AllowedF=1 and S2.Branch=Acceptance.Branch) Where S1.ID=@P_UserID and (coalesce(S2.Branch,'')<>'' or S1.Type='SUPERVISOR'))       
)      

GO

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].List07_Det') AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) ) 
BEGIN DROP FUNCTION [dbo].List07_Det END
GO
  CREATE FUNCTION List07_Det (@P_ANO as integer, @PSDate as SmallDateTime, @pEDAte as smallDateTime,@P_COB as varchar(10))  
RETURNS Table  
AS RETURN(  
    
SELECT Cast(0 as bit) as ProcessFlag,  
 [Acceptance].[CertificateNo],  
 Acceptance.ESeqNo,  
 [Acceptance].[AName],  
 [Acceptance].[ANO],  
 [Acceptance].[REGNO],  
 [Acceptance].[ADATE],  
 [Acceptance].[LUSERID] as UserID,  
 [SysTab].[Currency],  
 [QPCalc].[TSI],  
 [QPCalc].[OurShare],  
 [QPCalc].[Gross],  
 [Acceptance].[ASTATUS],  
 [Acceptance].[ATYPE],  
 [Acceptance].[SDate],  
 [Acceptance].[EDate],  
 Year([acceptance].[SDate]) As RYear,  
 Acceptance.ValueID,  
 Acceptance.ValueDesc  
From  
 Acceptance,  
 Cover,  
 SysTab,  
 QMasterAcceptance_PCalc() AS QPCalc,  
 TOC  
Where  
 [cover].[CNO] = [acceptance].[CNO]  
 And [QPCalc].[ANO]=[Acceptance].[ANO]  
 And [Acceptance].[ANO]<>[Acceptance].[LANO]  
 And [Acceptance].[LANO]=@P_ANO  
 And (([Acceptance].[AType]='C' and Acceptance.AStatus='I' and [Acceptance].[PPDate] between @PSdate and @pEDate)  
 or (Acceptance.AType<>'C' and Acceptance.AStatus='C' And [Acceptance].[CloseDate] between @PSdate and @pEDate)  
 or ([Acceptance].[AType]<>'C' and Acceptance.AStatus='I' and [Acceptance].[EDate] between @PSdate and @pEDate))  
 And [Cover].[ISType]<>'T'  
 And Acceptance.AdjustableF=1  
 And TOC.TOC=Acceptance.TOC  
 And TOC.COB=@P_COB  
)  

GO

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].List11A_Det') AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) ) 
BEGIN DROP FUNCTION [dbo].List11A_Det END
GO
CREATE FUNCTION List11A_Det (@P_ANO as integer, @P_UserID as varchar(255), @P_TOC as varchar(10), @P_Branch as varchar(10), @P_AStatus as varchar(1))   
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
QPCalc.TSI,   
QPCalc.OurShare,   
QPCalc.Gross,   
Acceptance.ASTATUS,   
Acceptance.ATYPE,   
Acceptance.SDate,   
Acceptance.EDate,   
Year(Acceptance.SDate) AS RYear,   
QPCalc.ValueID,   
QPCalc.ValueDesc   
From   
Acceptance,   
Cover,   
SysTab,   
QMasterAcceptance_PCalc() AS QPCalc,   
RARRHEADER,   
SysUser   
Where   
cover.CNO = acceptance.CNO   
And Rarrheader.ANO = Acceptance.ANO   
And QPCalc.ANO=Acceptance.ANO   
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

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].List11F_Det') AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) ) 
BEGIN DROP FUNCTION [dbo].List11F_Det END
GO
CREATE FUNCTION List11F_Det (@P_ANO as integer,@P_UserID as varchar(10), @P_TOC as varchar(10), @P_Branch as varchar(10), @P_PDate as smalldatetime, @P_ManualF as bit)      
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
 QPCalc.TSI,      
 QPCalc.OurShare,      
 QPCalc.Gross,      
 Acceptance.ASTATUS,      
 Acceptance.ATYPE,      
 Acceptance.SDate,      
 Acceptance.EDate,      
 Year(Acceptance.SDate) AS RYear,      
 Acceptance.ValueID,      
 Acceptance.ValueDesc      
From      
 Acceptance,      
 Cover,      
 SysTab,      
 QMasterAcceptance_PCalc() AS QPCalc,      
 RARRHEADER,   
 SysUserTOC,   
 SysUserBranch  
Where      
 cover.CNO = acceptance.CNO      
 And Rarrheader.ANO = Acceptance.ANO      
 And QPCalc.ANO=Acceptance.ANO      
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

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].List16_Det') AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) ) 
BEGIN DROP FUNCTION [dbo].List16_Det END
GO
CREATE  FUNCTION List16_Det (@P_ANO as integer, @pSDate as smalldatetime,@pEDate as smalldatetime,@P_COB as varchar(10))  
RETURNS TABLE   
as RETURN(  
  
SELECT Cast(0 as bit) as ProcessFlag,  
 [Acceptance].[CertificateNo],   
 Acceptance.ESeqNo,  
 [Acceptance].[AName],   
 [Acceptance].[ANO],   
 [Acceptance].[REGNO],   
 [Acceptance].[ADATE],   
 [Acceptance].[LUSERID] as UserID,   
 [SysTab].[Currency],   
 [QPCalc].[TSI],   
 [QPCalc].[OurShare],   
 [QPCalc].[Gross],   
 [Acceptance].[ASTATUS],   
 [Acceptance].[ATYPE],   
 [Acceptance].[SDate],   
 [Acceptance].[EDate],   
 Year([Acceptance].[SDate]) AS RYear,  
 Acceptance.ValueID,  
        Acceptance.ValueDesc  
FROM   
 Acceptance,   
 Cover,   
 SysTab,   
 QMasterAcceptance_PCalc() AS QPCalc,  
 TOC  
WHERE   
 [Cover].[CNO]=[Acceptance].[CNO]   
 And Acceptance.TOC = TOC.TOC  
 And [QPCalc].[ANO]=[Acceptance].[ANO]   
 And [Acceptance].[ANO]<>[Acceptance].[LANO]   
 And [Acceptance].[LANO]=@P_ANO   
 And [Cover].[ISType]<>'T'   
 And [Acceptance].[ADate]>=@pSDate   
 And [Acceptance].[ADate]<=@pEDate  
 And TOC.TOC=Acceptance.TOC  
 And TOC.COB=@P_COB  
)  

GO
IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].list16SC_Det') AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) ) 
BEGIN DROP FUNCTION [dbo].list16SC_Det END
GO
CREATE  FUNCTION list16SC_Det (@P_ANO as integer, @P_SDate as smalldatetime, @P_EDate as smalldatetime,@P_COB as varchar(10),@P_ServiceNo as varchar(20))  
RETURNS Table  
AS RETURN(  
    
SELECT Cast(0 as bit) as ProcessFlag,  
 [Acceptance].[CertificateNo],  
 Acceptance.ESeqNo,  
 [Acceptance].[AName],  
 [Acceptance].[ANO],  
 [Acceptance].[REGNO],  
 [Acceptance].[ADATE],  
 [Acceptance].[LUSERID] as UserID,  
 [SysTab].[Currency],  
 [QPCalc].[TSI],  
 [QPCalc].[OurShare],  
 [QPCalc].[Gross],  
 [Acceptance].[ASTATUS],  
 [Acceptance].[ATYPE],  
 [Acceptance].[SDate],  
 [Acceptance].[EDate],  
 Year([acceptance].[SDate]) As RYear,  
 Acceptance.ValueID,  
 Acceptance.ValueDesc  
From  
 Acceptance,  
 Cover,  
 SysTab,  
 QMasterAcceptance_PCalc() AS QPCalc,  
 TOC,  
 Service  
Where  
 [cover].[CNO] = [acceptance].[CNO]  
 And [QPCalc].[ANO]=[Acceptance].[ANO]  
 And [Acceptance].[ANO]<>[Acceptance].[LANO]  
 And [Acceptance].[LANO]=@P_ANO  
 And Service.SType='CANCELLATION'  
 And Service.PANO=Acceptance.ANO  
 And Service.Cdate Between @P_Sdate and @P_EDate  
 And Service.SStatus='P'  
 And TOC.TOC=Acceptance.TOC  
 And TOC.COB Like @P_COB+'%'  
 And Service.ServiceNo Like @P_ServiceNo+'%'  
)  
    
GO
IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].list16SD_Det') AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) ) 
BEGIN DROP FUNCTION [dbo].list16SD_Det END
GO
CREATE FUNCTION list16SD_Det (@P_ANO as integer, @P_SDate as smalldatetime, @P_EDate as smalldatetime,@P_COB as varchar(10),@P_ServiceNo as varchar(20))  
RETURNS Table  
AS RETURN(  
      
SELECT Cast(0 as bit) as ProcessFlag,  
 [Acceptance].[CertificateNo],  
 Acceptance.ESeqNo,  
 [Acceptance].[AName],  
 [Acceptance].[ANO],  
 [Acceptance].[REGNO],  
 [Acceptance].[ADATE],  
 [Acceptance].[LUSERID] as UserID,  
 [SysTab].[Currency],  
 [QPCalc].[TSI],  
 [QPCalc].[OurShare],  
 [QPCalc].[Gross],  
 [Acceptance].[ASTATUS],  
 [Acceptance].[ATYPE],  
 [Acceptance].[SDate],  
 [Acceptance].[EDate],  
 Year([acceptance].[SDate]) As RYear,  
 Acceptance.ValueID,  
 Acceptance.ValueDesc  
From  
 Acceptance,  
 Cover,  
 SysTab,  
 QMasterAcceptance_PCalc() AS QPCalc,  
 TOC,  
 Service  
Where  
 [cover].[CNO] = [acceptance].[CNO]  
 And [QPCalc].[ANO]=[Acceptance].[ANO]  
 And [Acceptance].[ANO]<>[Acceptance].[LANO]  
 And [Acceptance].[LANO]=@P_ANO  
 And ((Service.PANO=Acceptance.ANO and Service.SType<>'NEW') or (Service.ANO=Acceptance.ANO and Service.SType='NEW'))  
 And Service.Cdate Between @P_Sdate and @P_EDate  
 And Acceptance.AStatus='W'  
 And Service.SStatus='C'  
 And TOC.TOC=Acceptance.TOC  
 And TOC.COB Like @P_COB+'%'  
 And Service.ServiceNo Like @P_ServiceNo+'%'  
)  

GO

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].list16SE_Det') AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) ) 
BEGIN DROP FUNCTION [dbo].list16SE_Det END
GO
CREATE  FUNCTION list16SE_Det (@P_ANO as integer, @P_SDate as smalldatetime, @P_EDate as smalldatetime,@P_COB as varchar(10),@P_ServiceNo as varchar(20))  
RETURNS Table  
AS RETURN(  
    
SELECT Cast(0 as bit) as ProcessFlag,  
 [Acceptance].[CertificateNo],  
 Acceptance.ESeqNo,  
 [Acceptance].[AName],  
 [Acceptance].[ANO],  
 [Acceptance].[REGNO],  
 [Acceptance].[ADATE],  
 [Acceptance].[LUSERID] as UserID,  
 [SysTab].[Currency],  
 [QPCalc].[TSI],  
 [QPCalc].[OurShare],  
 [QPCalc].[Gross],  
 [Acceptance].[ASTATUS],  
 [Acceptance].[ATYPE],  
 [Acceptance].[SDate],  
 [Acceptance].[EDate],  
 Year([acceptance].[SDate]) As RYear,  
 Acceptance.ValueID,  
 Acceptance.ValueDesc  
From  
 Acceptance,  
 Cover,  
 SysTab,  
 QMasterAcceptance_PCalc() AS QPCalc,  
 TOC,  
 Service  
Where  
 [cover].[CNO] = [acceptance].[CNO]  
 And [QPCalc].[ANO]=[Acceptance].[ANO]  
 And [Acceptance].[ANO]<>[Acceptance].[LANO]  
 And [Acceptance].[LANO]=@P_ANO  
 And Service.SType='ENDORSEMENT'  
 And Service.PANO=Acceptance.ANO  
 And Service.Cdate Between @P_Sdate and @P_EDate  
 And Service.SStatus='P'  
 And TOC.TOC=Acceptance.TOC  
 And TOC.COB Like @P_COB+'%'  
 And Service.ServiceNo Like @P_ServiceNo+'%'  
)  

GO
IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].list16SL_Det') AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) ) 
BEGIN DROP FUNCTION [dbo].list16SL_Det END
GO
CREATE FUNCTION list16SL_Det (@P_ANO as integer, @P_SDate as smalldatetime, @P_EDate as smalldatetime,@P_COB as varchar(10),@P_ServiceNo as varchar(20))  
RETURNS Table  
AS RETURN(  
      
SELECT Cast(0 as bit) as ProcessFlag,  
 [Acceptance].[CertificateNo],  
 Acceptance.ESeqNo,  
 [Acceptance].[AName],  
 [Acceptance].[ANO],  
 [Acceptance].[REGNO],  
 [Acceptance].[ADATE],  
 [Acceptance].[LUSERID] as UserID,  
 [SysTab].[Currency],  
 [QPCalc].[TSI],  
 [QPCalc].[OurShare],  
 [QPCalc].[Gross],  
 [Acceptance].[ASTATUS],  
 [Acceptance].[ATYPE],  
 [Acceptance].[SDate],  
 [Acceptance].[EDate],  
 Year([acceptance].[SDate]) As RYear,  
 Acceptance.ValueID,  
 Acceptance.ValueDesc  
From  
 Acceptance,  
 Cover,  
 SysTab,  
 QMasterAcceptance_PCalc() AS QPCalc,  
 TOC,  
 Service  
Where  
 [cover].[CNO] = [acceptance].[CNO]  
 And [QPCalc].[ANO]=[Acceptance].[ANO]  
 And [Acceptance].[ANO]<>[Acceptance].[LANO]  
 And [Acceptance].[LANO]=@P_ANO  
 And Service.SType='EXPIRED'  
 And Service.PANO=Acceptance.ANO  
 And Service.Cdate Between @P_Sdate and @P_EDate  
 And Service.SStatus='P'  
 And TOC.TOC=Acceptance.TOC  
 And TOC.COB Like @P_COB+'%'  
 And Service.ServiceNo Like @P_ServiceNo+'%'  
)  

GO
IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].list16SR_Det') AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) ) 
BEGIN DROP FUNCTION [dbo].list16SR_Det END
GO
CREATE FUNCTION list16SR_Det (@P_ANO as integer, @P_SDate as smalldatetime, @P_EDate as smalldatetime,@P_COB as varchar(10),@P_ServiceNo as varchar(20))  
RETURNS Table  
AS RETURN(  
    
SELECT Cast(0 as bit) as ProcessFlag,  
 [Acceptance].[CertificateNo],  
 Acceptance.ESeqNo,  
 [Acceptance].[AName],  
 [Acceptance].[ANO],  
 [Acceptance].[REGNO],  
 [Acceptance].[ADATE],  
 [Acceptance].[LUSERID] as UserID,  
 [SysTab].[Currency],  
 [QPCalc].[TSI],  
 [QPCalc].[OurShare],  
 [QPCalc].[Gross],  
 [Acceptance].[ASTATUS],  
 [Acceptance].[ATYPE],  
 [Acceptance].[SDate],  
 [Acceptance].[EDate],  
 Year([acceptance].[SDate]) As RYear,  
 Acceptance.ValueID,  
 Acceptance.ValueDesc  
From  
 Acceptance,  
 Cover,  
 SysTab,  
 QMasterAcceptance_PCalc() AS QPCalc,  
 TOC,  
 Service  
Where  
 [cover].[CNO] = [acceptance].[CNO]  
 And [QPCalc].[ANO]=[Acceptance].[ANO]  
 And [Acceptance].[ANO]<>[Acceptance].[LANO]  
 And [Acceptance].[LANO]=@P_ANO  
 And Service.SType='RENEWAL'  
 And Service.PANO=Acceptance.ANO  
 And Service.Cdate Between @P_Sdate and @P_EDate  
 And Service.SStatus='P'  
 And TOC.TOC=Acceptance.TOC  
 And TOC.COB Like @P_COB+'%'  
 And Service.ServiceNo Like @P_ServiceNo+'%'  
)  
GO

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].List18_Det') AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) ) 
BEGIN DROP FUNCTION [dbo].List18_Det END
GO
CREATE FUNCTION List18_Det (@P_ANO as integer, @P_UserID as varchar(10), @P_TOC as varchar(10), @P_Branch as varchar(10), @P_PDate as smalldatetime)      
RETURNS Table      
AS RETURN(      
          
SELECT Cast(0 as bit) as ProcessFlag,     
 [Acceptance].[CertificateNo],      
 Acceptance.ESeqNo,      
 [Acceptance].[AName],      
 [Acceptance].[ANO],      
 [Acceptance].[REGNO],      
 [Acceptance].[ADATE],      
 [Acceptance].[LUSERID] as UserID,      
 [SysTab].[Currency],      
 [QPCalc].[TSI],      
 [QPCalc].[OurShare],      
 [QPCalc].[Gross],      
 [Acceptance].[ASTATUS],      
 [Acceptance].[ATYPE],      
 [Acceptance].[SDate],      
 [Acceptance].[EDate],      
 Year([acceptance].[SDate]) As RYear,  
 Acceptance.ValueID,  
 Acceptance.ValueDesc      
From      
 Acceptance,      
 Cover,      
 SysTab,      
 QMasterAcceptance_PCalc() As QPCalc,      
 SysUserTOC,     
 SysUserBranch    
Where      
 [cover].[CNO] = [acceptance].[CNO]      
 And [QPCalc].[ANO]=[Acceptance].[ANO]      
 And [Acceptance].[ANO]<>[Acceptance].[LANO]      
 And [Acceptance].[LANO]=@P_ANO      
 And [Acceptance].[AStatus]='I'      
 And Acceptance.AType Not in ('C','A')      
And [Cover].[ISType]<>'T'      
AND @P_PDate between Acceptance.PDate and Acceptance.PPDate      
 And SysUserTOC.ID=@P_UserID and Acceptance.TOC=SysUserTOC.TOC and (SysUserTOC.TOC=@P_TOC or @P_TOC='')    
 And SysUserBranch.ID=@P_UserID and Acceptance.BRanch=SysUserBranch.Branch and (SysUserBranch.Branch=@P_Branch or @P_Branch='')    
 And Acceptance.ANO in (SELECT ANO from Claim, CLLOSS Where (Claim.CSTATUS IN ('R','P','T','A') OR Claim.PCSTATUS IN ('A')) and Claim.CNO=CLLOSS.CNO and CLLOSS.CTLF=1 And Claim.ANO=Acceptance.ANO)      
)      
                 
GO

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].List19_Det') AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) ) 
BEGIN DROP FUNCTION [dbo].List19_Det END
GO
CREATE FUNCTION List19_Det (@P_ANO as integer, @P_Days as smallint, @P_Date as Smalldatetime,@P_COB as varchar(10),@P_Branch as varchar(10), @P_UnPaidOpt as Bit)   
RETURNS TABLE   
as RETURN(   
   
SELECT Cast(0 as bit) as ProcessFlag,   
[Acceptance].[CertificateNo],   
Acceptance.ESeqNo,   
[Acceptance].[AName],   
[Acceptance].[ANO],   
[Acceptance].[REGNO],   
[Acceptance].[ADATE],   
[Acceptance].[LUSERID] as UserID,   
[SysTab].[Currency],   
[QPCalc].[TSI],   
[QPCalc].[OurShare],   
[QPCalc].[Gross],   
[Acceptance].[ASTATUS],   
[Acceptance].[ATYPE],   
[Acceptance].[SDate],   
[Acceptance].[EDate],   
Year([Acceptance].[SDate]) AS RYear,   
Acceptance.ValueID,   
Acceptance.ValueDesc   
   
FROM   
Acceptance,   
Cover,   
SysTab,   
QMasterAcceptance_PCalc() AS QPCalc,   
TOC   
WHERE   
[Cover].[CNO]=[Acceptance].[CNO]   
And TOC.TOC=Acceptance.TOC and TOC.COB=@P_COB And Acceptance.Branch Like @P_Branch+'%'   
And [QPCalc].[ANO]=[Acceptance].[ANO]   
And [Acceptance].[ANO]<>[Acceptance].[LANO]   
And [Acceptance].[LANO]=@P_ANO   
And [Cover].[ISType]<>'T'   
And Acceptance.AStatus='I'  And Acceptance.AType<>'C'   
And EXISTS (SELECT A1.OANO from Acceptance A1, AccAss, Admlink, nVoucher Voucher Where A1.ANO=AccAss.ANO and A1.OANO=Acceptance.OANO and Voucher.Voucher=Admlink.Voucher and Admlink.AdmNo=AccAss.AdmNo and AccAss.Type in ('DI','IC','IR') and Voucher.nDueDate+@P_Days<@P_Date and Voucher.Nominal_CC-Voucher.Diff_CC-Voucher.Payment_CC-Voucher.Payment_OC<>0 and (@P_UnPaidOpt=0 or Voucher.Payment_CC=0))   
)  

GO

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].ListDet05_a') AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) ) 
BEGIN DROP FUNCTION [dbo].ListDet05_a END
GO
Create function ListDet05_a (@P_ANO as integer,     
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
 Acceptance.AName,        
 Acceptance.ANO,        
 Acceptance.REGNO,        
 Acceptance.ADATE,        
 Acceptance.LUSERID as UserID,        
 SysTab.Currency,        
 QPCalc.TSI,        
 QPCalc.OurShare,        
 QPCalc.Gross,        
 Acceptance.ASTATUS,        
 Acceptance.ATYPE,        
 Acceptance.SDate,        
 Acceptance.EDate,        
 Year(Acceptance.SDate) AS RYear,        
 Acceptance.ValueID,        
 Acceptance.ValueDesc        
From        
 Acceptance,        
 Cover,        
 SysTab,        
 QMasterAcceptance_PCalc() AS QPCalc,        
 Profile        
Where        
 cover.CNO = acceptance.CNO        
 And QPCalc.ANO=Acceptance.ANO        
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
 And (@Value15='%' or @Value15='' or 1 in (SELECT top 1 1 from Service Where ((Service.ANO=Acceptance.pANO and Service.ANO<>-1) or Service.ANO=Acceptance.ANO) and SStatus<>'R' and ServiceNo Like @Value15))        
 And (Acceptance.BatchNo Like @Value19 or (Acceptance.BatchNo is null and @Value19='%'))     
 And ((Acceptance.BackDatedF=1 and @Value20='1') or @Value20='')    
 And ((Cover.TBAF=1 and @Value22='1') or @Value22='')    
 And (@Value23<>'1' or (@Value23='1' and Exists (Select ANO from PPrintLog Where PPrintLog.ANO=Acceptance.ANO)))            
)        
  
GO

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].ListDet05_b') AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) ) 
BEGIN DROP FUNCTION [dbo].ListDet05_b END
GO
Create function ListDet05_b (@P_ANO as integer,     
@Value1 as varchar(255), @Value2 as varchar(255), @Value3 as varchar(255), @Value4 as varchar(255), @Value5 as varchar(255),     
@Value6 varchar(255), @Value7 as varchar(255), @Value8 as varchar(255), @Value9 as varchar(255), @Value10 as varchar(255),    
@Value11 as varchar(255),@Value12 as varchar(255), @Value13 as varchar(255),@Value14 as varchar(255),@Value15 as varchar(255),    
@Value16 as varchar(255),@Value17 as varchar(255),@Value18 as varchar(255),@Value19 as varchar(255),@Value20 as varchar(255),@Value21 as varchar(255), @Value22 as varchar(255), @Value23 as varchar(255)    
)          
RETURNS Table      
AS RETURN      
(      
SELECT Cast(0 as bit) as ProcessFlag,      
 q.[CertificateNo],      
 q.ESeqNo,      
 q.[AName],      
 q.[ANO],      
 q.[REGNO],      
 q.[ADATE],      
 q.[USERID],      
 q.[Currency],      
 q.[TSI],      
 q.[OurShare],      
 q.[Gross],      
 q.[ASTATUS],      
 q.[ATYPE],      
 q.[SDate],      
 q.[EDate],      
 q.RYear,      
 q.ValueID,       
 q.ValueDesc,      
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
FROM ListDet05_a (@P_ANO, @Value1, @Value2, @Value3, @Value4, @Value5, @Value6, @Value7, @Value8, @Value9, @Value10,@Value11, @Value12, @Value13,@Value14,@Value15,@Value16,@Value17,@Value18,@Value19, @Value20, @Value21, @Value22, @Value23) as q, ainfo as a      
Where q.ANO = a.ANO      
)      

GO

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ListQry_1]') AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) ) 
BEGIN DROP FUNCTION [dbo].[ListQry_1] END
GO
CREATE function [dbo].[ListQry_1] (@Value1 as varchar(255), @Value2 as varchar(255), @Value3 as varchar(255), @Value4 as varchar(255), @Value5 as varchar(255), @Value6 varchar(255), @Value7 as varchar(255), @Value8 as varchar(255), @Value9 as varchar(255),  @Value10 as varchar(255),@Value11 as varchar(255), @value12 as varchar(255), @value13 as varchar(255), @Value14 as varchar(255),@Value15 as varchar(255),@Value16 as varchar(255),@Value17 as varchar(255),@Value18 as varchar(255))   
RETURNS Table   
AS RETURN   
(   
SELECT Cast(0 as bit) as ProcessFlag,   
Cover.CoverNo as [Quotation No],   
Acceptance.RegNo as [CI No],   
Acceptance.PolicyNo as [Policy No],   
Acceptance.CertificateNo as [Certificate No],   
Cast(Acceptance.AName as varchar(128)) as Insured,   
Profile.Name as [Policy Holder],   
Cover.CoverDate as [Cover Date],   
Cover.Expdate as [Expiry Date],   
Acceptance.PolicyDate as [Issued Date],   
Acceptance.SDate as Start,   
Acceptance.EDate as [End],   
Acceptance.AStatus,   
Acceptance.AType,   
Acceptance.ANO,   
Acceptance.LANO,   
Acceptance.RefNo,   
Cover.ProformaF,   
cover.CNO   
From cover, acceptance, Profile   
Where cover.CNO = acceptance.CNO And cover.PHolder = Profile.ID   
And (Acceptance.AName Like @Value1)   
And (Cover.CoverNo Like @Value2 Or Cover.CoverNo is null)   
and (Cover.CoverDate = @Value3 Or Cover.CoverDate is null or @Value3 = '')   
And (Cover.ExpDate = @Value4 Or Cover.ExpDate is null or @Value4 = '')   
And (Acceptance.PolicyNo Like @Value5 Or Acceptance.PolicyNo is null)   
And (Acceptance.CertificateNo Like @Value6 Or Acceptance.CertificateNo is null)   
And (Acceptance.PolicyDate = @Value7 Or Acceptance.PolicyDate is null or @Value7 = '' or Acceptance.PolicyDate Between @Value7 and @Value16)   
And (Acceptance.RegDate = @Value17 Or Acceptance.RegDate is null or @Value17 = '' or Acceptance.RegDate Between @Value17 and @Value18)   
And Acceptance.AType Like @Value8   
And Acceptance.AStatus Like @Value9   
And Acceptance.RegNo Like @Value10   
And (Profile.Name Like @Value11 or Profile.Name is null)   
and Acceptance.toc like @Value12   
and (Acceptance.Matters=@Value14 or @Value14='')   
and (Acceptance.Refno like @Value13 or Acceptance.Refno is null)   
And (Cover.ISType<>'T' or Cover.ProformaF=1)   
)   
   
GO

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ListQry_1_a]') AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) ) 
BEGIN DROP FUNCTION [dbo].ListQry_1_a END
GO
CREATE function ListQry_1_a (@Value1 as varchar(255), @Value2 as varchar(255), @Value3 as varchar(255), @Value4 as varchar(255), @Value5 as varchar(255), @Value6 varchar(255), @Value7 as varchar(255), @Value8 as varchar(255), @Value9 as varchar(255), @Value10 as varchar(255),@Value11 as varchar(255), @value12 as varchar(255), @value13 as varchar(255),@Value14 as varchar(255),@Value15 as varchar(255),@Value16 as varchar(255),@Value17 as varchar(255),@Value18 as varchar(255))  
RETURNS Table  
AS RETURN  
(  
SELECT Cast(0 as bit) as ProcessFlag,   
  [q].[Quotation No],  
  [q]. [CI No],  
  [q].[Policy No],  
  [q].[Certificate No],  
  [q].[Insured],  
  [q].[Policy Holder],  
  [q].[Cover Date],  
  [q].[Expiry Date],  
  [q].[Issued Date],  
  [q].[Start],  
  [q].[End],  
  [q].[AStatus],  
  [q].[AType],  
  [q].[ANO],  
  [q].[LANO],  
  q.RefNo,  
  q.ProformaF,  
  q.cno,  
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
        
FROM  ListQry_1 (@Value1, @Value2, @Value3, @Value4, @Value5, @Value6, @Value7, @Value8, @Value9, @Value10,@Value11, @value12, @value13, @Value14,@Value15,@Value16,@Value17,@Value18) as q, ainfo as a  
Where [q].[ANO] = [a].[ANO]  
)  

GO

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ListQry_1b]') AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) ) 
BEGIN DROP FUNCTION [dbo].[ListQry_1b] END
GO
CREATE function [dbo].[ListQry_1b] (@Value1 as varchar(255), @Value2 as   varchar(255), @Value3 as varchar(255), @Value4 as varchar(255), @Value5 as  varchar(255), @Value6 varchar(255), @Value7 as varchar(255), @Value8 as varchar(255), @Value9 as varchar(255), @Value10 as varchar(255),@Value11 as varchar(255), @value12 as varchar(255), @value13 as varchar(255), @Value14 as varchar(255),@Value15 as varchar(255),@Value16 as varchar(255),@Value17 as varchar(255),@Value18 as varchar(255))   
RETURNS Table   
AS RETURN   
(   
SELECT Cast(0 as bit) as ProcessFlag,   
Cover.CoverNo as [Quotation No],   
Acceptance.RegNo as [CI No],   
Acceptance.PolicyNo as [Policy No],   
Acceptance.CertificateNo as [Certificate No],   
Cast(Acceptance.AName as varchar(128)) as Insured,   
Profile.Name as [Policy Holder],   
Cover.CoverDate as [Cover Date],   
Cover.Expdate as [Expiry Date],   
Acceptance.PolicyDate as [Issued Date],   
Acceptance.SDate as Start,   
Acceptance.EDate as [End],   
Acceptance.AStatus,   
Acceptance.AType,   
Acceptance.ANO,   
Acceptance.LANO,   
Acceptance.RefNo,   
Cover.ProformaF,   
acceptance.CNO   
From cover, acceptance, Profile   
Where cover.CNO = acceptance.CNO And cover.PHolder = Profile.ID   
And (Acceptance.AName Like @Value1)   
And (Cover.CoverNo Like @Value2 Or Cover.CoverNo is null)   
and (Cover.CoverDate = @Value3 Or Cover.CoverDate is null or @Value3 = '')   
And (Cover.ExpDate = @Value4 Or Cover.ExpDate is null or @Value4 = '')   
And (Acceptance.PolicyNo Like @Value5 Or Acceptance.PolicyNo is null)   
And (Acceptance.CertificateNo Like @Value6 Or Acceptance.CertificateNo is null)   
And (Acceptance.PolicyDate = @Value7 Or Acceptance.PolicyDate is null or @Value7 = '' or Acceptance.PolicyDate Between @Value7 and @Value16)   
And (Acceptance.RegDate = @Value17 Or Acceptance.RegDate is null or @Value17 = '' or Acceptance.RegDate Between @Value17 and @Value18)   
And Acceptance.AType Like @Value8   
And Acceptance.AStatus Like @Value9   
And Acceptance.RegNo Like @Value10   
And (Profile.Name Like @Value11 or Profile.Name is null)   
and acceptance.toc like @value12   
and (acceptance.refno like @value13 or acceptance.refno is null)   
and (Acceptance.Matters=@Value14 or @Value14='')   
and (acceptance.ano = acceptance.lano or acceptance.lano = -1)   
And (Cover.ISType<>'T' or Cover.ProformaF=1)   
)  

GO

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ListQry_1b_a]') AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) ) 
BEGIN DROP FUNCTION [dbo].[ListQry_1b_a] END
GO
CREATE function ListQry_1b_a (@Value1 as varchar(255), @Value2 as varchar(255), @Value3 as varchar(255), @Value4 as varchar(255), @Value5 as varchar(255), @Value6 varchar(255), @Value7 as varchar(255), @Value8 as varchar(255), @Value9 as varchar(255), @Value10 as varchar(255),@Value11 as varchar(255), @value12 as varchar(255), @value13 as varchar(255), @Value14 as varchar(255),@Value15 as varchar(255),@Value16 as varchar(255),@Value17 as varchar(255),@Value18 as varchar(255))  
RETURNS Table  
AS RETURN  
(  
SELECT Cast(0 as bit) as ProcessFlag,   
  [q].[Quotation No],  
  [q]. [CI No],  
  [q].[Policy No],  
  [q].[Certificate No],  
  [q].[Insured],  
  [q].[Policy Holder],  
  [q].[Cover Date],  
  [q].[Expiry Date],  
  [q].[Issued Date],  
  [q].[Start],  
  [q].[End],  
  [q].[AStatus],  
  [q].[AType],  
  [q].[ANO],  
  [q].[LANO],  
  q.RefNo,  
  q.ProformaF,  
  q.cno,  
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
        
FROM  ListQry_1b (@Value1, @Value2, @Value3, @Value4, @Value5, @Value6, @Value7, @Value8, @Value9, @Value10,@Value11, @value12, @value13, @Value14,@Value15,@Value16,@Value17,@Value18) as q, ainfo as a  
Where [q].[ANO] = [a].[ANO]  
)  

GO

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ListQry_3]') AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) ) 
BEGIN DROP FUNCTION [dbo].[ListQry_3] END
GO
CREATE function [dbo].[ListQry_3] (        
@Value1 as varchar(255), @Value2 as varchar(255), @Value3 as varchar(255), @Value4 as varchar(255), @Value5 as varchar(255),         
@Value6 varchar(255), @Value7 as varchar(255), @Value8 as varchar(255), @Value9 as varchar(255), @Value10 as varchar(255),        
@Value11 as varchar(255),@Value12 as varchar(255), @Value13 as varchar(255),@Value14 as varchar(255),@Value15 as varchar(255),        
@Value16 as varchar(255),@Value17 as varchar(255),@Value18 as varchar(255),@Value19 as varchar(255),@Value20 as varchar(255),@Value21 as varchar(255), @Value22 as varchar(255), @Value23 as varchar(255)        
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
)              
   
GO
IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ListQry_3_A]') AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) ) 
BEGIN DROP FUNCTION [dbo].ListQry_3_A END
GO
Create function ListQry_3_A (    
@Value1 as varchar(255), @Value2 as varchar(255), @Value3 as varchar(255), @Value4 as varchar(255), @Value5 as varchar(255),     
@Value6 varchar(255), @Value7 as varchar(255), @Value8 as varchar(255), @Value9 as varchar(255), @Value10 as varchar(255),    
@Value11 as varchar(255),@Value12 as varchar(255), @Value13 as varchar(255),@Value14 as varchar(255),@Value15 as varchar(255),    
@Value16 as varchar(255),@Value17 as varchar(255),@Value18 as varchar(255),@Value19 as varchar(255),@Value20 as varchar(255),@Value21 as varchar(255), @Value22 as varchar(255), @Value23 as varchar(255)      
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
 LISTQRY_3(@Value1, @Value2, @Value3, @Value4, @Value5, @Value6, @Value7, @Value8, @Value9, @Value10, @Value11, @Value12, @Value13,@Value14,@Value15,@Value16,@Value17,@Value18, @Value19, @Value20, @Value21, @Value22, @Value23) AS Q, AINFO AS A      
Where q.ano_info = a.ANO      
)      

GO

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ListQry_3b]') AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) ) 
BEGIN DROP FUNCTION [dbo].ListQry_3b END
GO
CREATE function [dbo].[ListQry_3b] (            
@Value1 as varchar(255), @Value2 as varchar(255), @Value3 as varchar(255), @Value4 as varchar(255), @Value5 as varchar(255),             
@Value6 varchar(255), @Value7 as varchar(255), @Value8 as varchar(255), @Value9 as varchar(255), @Value10 as varchar(255),            
@Value11 as varchar(255),@Value12 as varchar(255), @Value13 as varchar(255),@Value14 as varchar(255),@Value15 as varchar(255),            
@Value16 as varchar(255),@Value17 as varchar(255),@Value18 as varchar(255),@Value19 as varchar(255),@Value20 as varchar(255),@Value21 as varchar(255), @Value22 as varchar(255), @Value23 as varchar(255)            
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
            
)

GO

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ListSR_Det]') AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) ) 
BEGIN DROP FUNCTION [dbo].ListSR_Det END
GO
CREATE FUNCTION ListSR_Det (@P_ANO as int, @P_ID as int)    
RETURNS Table    
AS RETURN(    
        
SELECT Cast(0 as bit) as ProcessFlag,    
 [Acceptance].[CertificateNo],    
 Acceptance.ESeqNo,    
 [Acceptance].[AName],    
 [Acceptance].[ANO],    
 [Acceptance].[REGNO],    
 [Acceptance].[ADATE],    
 [Acceptance].[LUSERID] as UserID,    
 [SysTab].[Currency],    
 [QPCalc].[TSI],    
 [QPCalc].[OurShare],    
 [QPCalc].[Gross],    
 [Acceptance].[ASTATUS],    
 [Acceptance].[ATYPE],    
 [Acceptance].[SDate],    
 [Acceptance].[EDate],    
 Year([acceptance].[SDate]) As RYear,    
 Acceptance.ValueID,    
 Acceptance.ValueDesc    
From    
 Acceptance,    
 Cover,    
 SysTab,    
 QMasterAcceptance_PCalc() AS QPCalc,    
 TOC,    
 SysRequest    
Where    
 [cover].[CNO] = [acceptance].[CNO]    
 And [QPCalc].[ANO]=[Acceptance].[ANO]    
 And [Acceptance].[ANO]<>[Acceptance].[LANO]    
 And [Acceptance].[LANO]=@P_ANO    
 And SysRequest.ID=@P_ID    
 And SysRequest.Param2 in ('MAR','UND','CLM')    
 And SysRequest.Param3=Acceptance.ANO    
 And TOC.TOC=Acceptance.TOC) 
 
 GO
 
IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ListSR_Det]') AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) ) 
BEGIN DROP FUNCTION [dbo].ListSR_Det END
GO
CREATE  function ListSR_Det(@P_ANO AS INTEGER, @value1 as varchar(255) ,@value2 as varchar(255) ,@value3 as varchar(255) ,@value4 as varchar(255) ,@value5 as varchar(255) ,@value6 as varchar(255) ,@Value7 as varchar(255) ,@value8 as varchar(255) ,@value9 as varchar(255),@Value10 as varchar(255), @Value11 as varchar(255))    
returns table    
AS return    
(    
SELECT     
 Cast(0 as bit) as ProcessFlag,     
 Cover.COVERNO,     
 Acceptance.AName,     
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
 and Acceptance.toc like @Value11    
 And Cover.ISType<>'T'    
)  
GO

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[MListQry_1]') AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) ) 
BEGIN DROP FUNCTION [dbo].MListQry_1 END
GO
CREATE function MListQry_1(@value1 as varchar(255) ,@value2 as varchar(255) ,@value3 as varchar(255) ,@value4 as varchar(255) ,@value5 as varchar(255) ,@value6 as varchar(255) ,@Value7 as varchar(255) ,@value8 as varchar(255) ,@value9 as varchar(255),@Value10 as varchar(255), @Value11 as varchar(255))    
returns table    
AS return    
(    
SELECT   Cast(0 as bit) as ProcessFlag,      
  [Cover].[CoverNo] AS [Quotation No],     
  [Cover].[VSeqNo],     
  [Acceptance].[RegNo] AS [CI No],     
  [Acceptance].[PolicyNo] AS [Policy No],     
  [Acceptance].[CertificateNo] AS [Certificate No],     
  [Cover].[Insured],     
  [Profile].[Name] AS [Proposer],    
  [Cover].[CoverDate] AS [Cover Date],     
  [Cover].[Expdate] AS [Expiry Date],     
  [Acceptance].[PolicyDate] AS [Policy Date],     
  [Acceptance].[SDate] AS Start,     
  [Acceptance].[EDate] AS [End],     
  [Acceptance].[AType],     
  [Acceptance].[AStatus],     
  [Acceptance].[ANO],     
  [Acceptance].[LANO],    
  [Cover].[CStatus],    
  acceptance.ano as ano_info    
FROM  Cover, Acceptance, [Profile]    
WHERE  [Cover].[CNO]=[Acceptance].[CNO]     
  And Cover.PHOLDER=[Profile].[ID]    
  And (Acceptance.AName Like @Value1)  
  And ([Cover].[CoverNo] Like @Value2 Or ([Cover].[CoverNo] is null))     
  And (cover.coverdate=@Value3 Or (cover.coverdate IS NULL) Or cover.coverdate='' or @Value3='')    
  And (cover.expdate=@Value4 Or (cover.expdate IS NULL) Or cover.expdate='' or @Value4='')      
  And ([Acceptance].[PolicyNo] Like @Value5 Or ([Acceptance].[PolicyNo] is null))     
  And ([Acceptance].[CertificateNo] Like @Value6 Or ([Acceptance].[CertificateNo] is null))     
  And (acceptance.policydate=@Value7 Or (acceptance.policydate IS NULL) Or acceptance.policydate='' or @Value7='')    
  And ([Cover].[CStatus] Like @Value8)     
  And ([Acceptance].[RegNo] Like @Value9)     
  And ([Profile].[Name] like @Value10 or [Profile].[Name] is null)    
  and acceptance.toc like @Value11    
  and acceptance.ano = acceptance.lano    
  And [Cover].[ISType]<>'T'    
union     
SELECT   Cast(0 as bit) as ProcessFlag,     
  [Cover].[CoverNo] AS [Quotation No],     
  [Cover].[VSeqNo],     
  [Acceptance].[RegNo] AS [CI No],     
  [Acceptance].[PolicyNo] AS [Policy No],     
  [Acceptance].[CertificateNo] AS [Certificate No],     
  [Cover].[Insured],     
  [Profile].[Name] AS [Proposer],    
  [Cover].[CoverDate] AS [Cover Date],     
  [Cover].[Expdate] AS [Expiry Date],     
  [Acceptance].[PolicyDate] AS [Policy Date],     
  [Acceptance].[SDate] AS Start,     
  [Acceptance].[EDate] AS [End],     
  [Acceptance].[AType],     
  [Acceptance].[AStatus],     
  [Acceptance].[ANO],     
  [Acceptance].[LANO],    
  [Cover].[CStatus],    
  acceptance.ano as ano_info    
FROM  Cover, Acceptance, [Profile]    
WHERE  [Cover].[CNO]=[Acceptance].[CNO]     
  And Cover.PHOLDER=[Profile].[ID]    
  And (Acceptance.AName Like @Value1)    
  And ([Cover].[CoverNo] Like @Value2 Or ([Cover].[CoverNo] is null))     
  And (cover.coverdate=@Value3 Or (cover.coverdate IS NULL) Or cover.coverdate='' or @Value3='')    
  And (cover.expdate=@Value4 Or (cover.expdate IS NULL) Or cover.expdate='' or @Value4='')      
  And ([Acceptance].[PolicyNo] Like @Value5 Or ([Acceptance].[PolicyNo] is null))     
  And ([Acceptance].[CertificateNo] Like @Value6 Or ([Acceptance].[CertificateNo] is null))     
  And (acceptance.policydate=@Value7 Or (acceptance.policydate IS NULL) Or acceptance.policydate='' or @Value7='')    
  And ([Cover].[CStatus] Like @Value8)     
  And ([Acceptance].[RegNo] Like @Value9)     
  And ([Profile].[Name] like @Value10 or [Profile].[Name] is null)    
  and acceptance.toc like @Value11    
  and acceptance.lano = -1    
  And [Cover].[ISType]<>'T'    
union    
SELECT   Cast(0 as bit) as ProcessFlag,     
  [Cover].[CoverNo] AS [Quotation No],     
  [Cover].[VSeqNo],     
  [Acceptance_detail].[RegNo] AS [CI No],     
  [Acceptance_detail].[PolicyNo] AS [Policy No],     
  [Acceptance_detail].[CertificateNo] AS [Certificate No],     
  [Cover].[Insured],     
  [Profile].[Name] AS [Proposer],    
  [Cover].[CoverDate] AS [Cover Date],     
  [Cover].[Expdate] AS [Expiry Date],     
  [Acceptance_detail].[PolicyDate] AS [Policy Date],     
  [Acceptance_detail].[SDate] AS Start,     
  [Acceptance_detail].[EDate] AS [End],     
  [Acceptance_detail].[AType],     
  [Acceptance_detail].[AStatus],     
  [Acceptance_detail].[ANO],     
  [acceptance_detail].[LANO],    
  [Cover].[CStatus],    
  acceptance_detail.ano as ano_info    
FROM  Cover, Acceptance, [Profile], acceptance as acceptance_detail    
WHERE  [Cover].[CNO]=[Acceptance_detail].[CNO]     
  And Cover.PHOLDER=[Profile].[ID]    
  and acceptance.ano = acceptance_detail.lano    
  And (Acceptance_detail.AName Like @Value1)  
  And ([Cover].[CoverNo] Like @Value2 Or ([Cover].[CoverNo] is null))     
  And (cover.coverdate=@Value3 Or (cover.coverdate IS NULL) Or cover.coverdate='' or @Value3='')    
  And (cover.expdate=@Value4 Or (cover.expdate IS NULL) Or cover.expdate='' or @Value4='')      
  And ([Acceptance_detail].[PolicyNo] Like @Value5 Or ([Acceptance_detail].[PolicyNo] is null))     
  And ([Acceptance_detail].[CertificateNo] Like @Value6 Or ([Acceptance_detail].[CertificateNo] is null))     
  And (acceptance_detail.policydate=@Value7 Or (acceptance_detail.policydate IS NULL) Or acceptance_detail.policydate='' or @Value7='')    
  And ([Cover].[CStatus] Like @Value8)     
  And ([Acceptance_detail].[RegNo] Like @Value9)     
  And ([Profile].[Name] like @Value10 or [Profile].[Name] is null)    
  and acceptance.toc like @Value11    
  and acceptance_detail.ano <> acceptance_detail.lano and acceptance_detail.lano <> -1    
  And [Cover].[ISType]<>'T'    
)    

GO

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[MListQry_1b]') AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) ) 
BEGIN DROP FUNCTION [dbo].MListQry_1b END
GO
CREATE function MListQry_1b(@value1 as varchar(255) ,@value2 as varchar(255) ,@value3 as varchar(255) ,@value4 as varchar(255) ,@value5 as varchar(255) ,@value6 as varchar(255) ,@Value7 as varchar(255) ,@value8 as varchar(255) ,@value9 as varchar(255),@Value10 as varchar(255), @Value11 as varchar(255))    
returns table    
AS return    
(    
SELECT    Cast(0 as bit) as ProcessFlag,     
  [Cover].[CoverNo] AS [Quotation No],     
  [Cover].[VSeqNo],     
  [Acceptance].[RegNo] AS [CI No],     
  [Acceptance].[PolicyNo] AS [Policy No],     
  [Acceptance].[CertificateNo] AS [Certificate No],     
  [Cover].[Insured],     
  [Profile].[Name] AS [Proposer],    
  [Cover].[CoverDate] AS [Cover Date],     
  [Cover].[Expdate] AS [Expiry Date],     
  [Acceptance].[PolicyDate] AS [Policy Date],     
  [Acceptance].[SDate] AS Start,     
  [Acceptance].[EDate] AS [End],     
  [Acceptance].[AType],     
  [Acceptance].[AStatus],     
  [Acceptance].[ANO],     
  [Acceptance].[LANO],    
  [Cover].[CStatus]    
FROM  Cover, Acceptance, [Profile]    
WHERE  [Cover].[CNO]=[Acceptance].[CNO]     
  And Cover.PHOLDER=[Profile].[ID]    
  And (Acceptance.AName Like @Value1)  
  And ([Cover].[CoverNo] Like @Value2 Or ([Cover].[CoverNo] is null))     
  And (cover.coverdate=@Value3 Or cover.coverdate is NULL or @Value3='')    
  And (cover.expdate=@Value4 Or cover.expdate is NULL or @Value4='')      
  And ([Acceptance].[PolicyNo] Like @Value5 Or ([Acceptance].[PolicyNo] is null))     
  And ([Acceptance].[CertificateNo] Like @Value6 Or ([Acceptance].[CertificateNo] is null))     
  And (acceptance.policydate=@Value7 Or acceptance.policydate is NULL or @Value7='')    
  And ([Cover].[CStatus] Like @Value8)     
  And ([Acceptance].[RegNo] Like @Value9)     
  And ([Profile].[Name] like @Value10 or [Profile].[Name] is null)    
  and Acceptance.toc like @Value11    
  And ([Acceptance].[ANO] = [Acceptance].[LANO] Or [Acceptance].[LANO] = -1)     
  And [Cover].[ISType]<>'T'    
)   

GO
IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[MListQry_3]') AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) ) 
BEGIN DROP FUNCTION [dbo].MListQry_3 END
GO
CREATE function MListQry_3 (@value1 as varchar(255) ,@value2 as varchar(255) ,@value3 as varchar(255) ,@value4 as varchar(255) ,@value5 as varchar(255) ,@value6 as varchar(255) ,@value7 as varchar(255) ,@value8 as varchar(255) ,@value9 as varchar(255),@Value10 as varchar(255), @Value11 as varchar(255), @Value12 as varchar(255))   
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
QPCalc.TSI,   
QPCalc.OurShare,   
QPCalc.Gross,   
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
FROM  Acceptance Left Join RArrHeader on (RArrHeader.ANO=Acceptance.ANO)   
Left Join QDetail_PCalc() QPCalc on (qPCalc.ANO=Acceptance.ANO and Acceptance.PStatus='C'), Cover, SysTab, Profile   
Where cover.CNO = acceptance.CNO   
And Cover.PHOLDER=Profile.ID   
And (Acceptance.AName Like @Value1)   
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
From Acceptance Left Join RArrHeader on (RArrHeader.ANO=Acceptance.ANO), Cover, SysTab, Profile, acceptance as acceptance_detail   
Where cover.CNO = acceptance.CNO   
And Cover.PHOLDER=Profile.ID   
and acceptance.ano = acceptance_detail.lano   
And (Acceptance_Detail.AName Like @Value1)   
And (Cover.CoverNo Like @Value2 Or (Cover.CoverNo is null))   
and (Cover.CoverDate = @Value3 Or (Cover.CoverDate is null) or @Value3 = '')   
And (Cover.ExpDate = @Value4 Or (Cover.ExpDate is null) or @Value4 = '')   
And (Acceptance_Detail.PolicyNo Like @Value5 Or (Acceptance_Detail.PolicyNo is null))   
And (Acceptance_Detail.CertificateNo Like @Value6 Or (Acceptance_Detail.CertificateNo is null))   
and (Acceptance_Detail.PolicyDate = @Value7 Or (Acceptance_Detail.PolicyDate is null) or @Value7 = '')   
And (Cover.CStatus Like @Value8)   
And (Acceptance_Detail.RegNo Like @Value9)   
And (Profile.Name Like @Value10 or Profile.ID is null)   
and Acceptance.toc like @Value11   
And (Acceptance_detail.ANO <> Acceptance_detail.LANO and Acceptance_detail.LANO <> -1)   
And Cover.ISType<>'T'   
)   
   
GO

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[MListQry_3_a]') AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) ) 
BEGIN DROP FUNCTION [dbo].[MListQry_3_a] END
GO
CREATE function [dbo].[MListQry_3_a](@value1 as varchar(255) ,@value2 as varchar(255) ,@value3 as varchar(255) ,@value4 as varchar(255) ,@value5 as varchar(255) ,@value6 as varchar(255) ,@value7 as varchar(255) ,@value8 as varchar(255) ,@value9 as varchar(255),@Value10 as varchar(255), @Value11 as varchar(255), @Value12 as varchar(255))     
returns table    
as return    
(    
SELECT   Cast(0 as bit) as ProcessFlag,     
  q.[CoverNo],     
  q.[Insured],     
  q.[CNO],     
  q.[CStatus],     
  q.VSeqNo,     
  q.[lANO],     
  q.[ANO],     
  q.[REGNO],     
  q.[ADATE],     
  q.[USERID],     
  q.[Currency],     
  q.[TSI],     
  q.[OurShare],     
  q.[Gross],     
  q.[ASTATUS],     
  q.[ATYPE],     
  q.[SDate],     
  q.[EDate],     
  q.RYear,     
  q.[ISType],     
  q.[Renewal],     
  q.[ESeqNo],     
  q.[PolicyNo],    
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
  a.valueid15, a.valuedesc15      
FROM  MListQry_3(@Value1, @Value2, @Value3, @Value4, @Value5, @Value6, @Value7, @Value8, @Value9, @Value10, @Value11, @Value12) as q, ainfo as a    
WHERE  q.ano_info = a.ano    
)  

GO

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[MListQry_3b]') AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) ) 
BEGIN DROP FUNCTION [dbo].MListQry_3b END
GO
CREATE function MListQry_3b (@value1 as varchar(255) ,@value2 as varchar(255) ,@value3 as varchar(255) ,@value4 as varchar(255) ,@value5 as varchar(255) ,@value6 as varchar(255) ,@value7 as varchar(255) ,@value8 as varchar(255) ,@value9 as varchar(255),@Value10 as varchar(255), @Value11 as varchar(255), @Value12 as varchar(255))   
RETURNS Table   
as return   
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
QPCalc.TSI,   
QPCalc.OurShare,   
QPCalc.Gross,   
Acceptance.ASTATUS,   
Acceptance.ATYPE,   
Acceptance.SDate,   
Acceptance.EDate,   
Year(Coalesce(RArrHeader.RDate,Acceptance.SDate)) AS RYear,   
Cover.ISType,   
Acceptance.Renewal,   
Acceptance.ESeqNo,   
acceptance.PolicyNo   
FROM  Acceptance Left Join RArrHeader on (RArrHeader.ANO=Acceptance.ANO)   
Left Join QDetail_PCalc() QPCalc on (qPCalc.ANO=Acceptance.ANO and Acceptance.PStatus='C'), Cover, SysTab, Profile   
Where cover.CNO = acceptance.CNO   
And Cover.PHOLDER=Profile.ID   
And (Acceptance.AName Like @Value1)   
And (Cover.CoverNo Like @Value2 Or (Cover.CoverNo is null))   
and (Cover.CoverDate = @Value3 Or (Cover.CoverDate is null) or @Value3 = '')   
And (Cover.ExpDate = @Value4 Or (Cover.ExpDate is null) or @Value4 = '')   
And (Acceptance.PolicyNo Like @Value5 Or (Acceptance.PolicyNo is null))   
And (Acceptance.CertificateNo Like @Value6 Or (Acceptance.CertificateNo is null))   
and (Acceptance.PolicyDate = @Value7 Or (Acceptance.PolicyDate is null) or @Value7 = '')   
And (Cover.CStatus Like @Value8)   
And (Acceptance.RegNo Like @Value9)   
And (Profile.Name Like @Value10 or Profile.ID is null)   
And (Acceptance.TOC Like @Value11)   
And (Acceptance.ANO=Acceptance.lANO Or Acceptance.lANO=-1)   
And Cover.ISType<>'T'   
) 

GO 

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[MListSR_Det]') AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) ) 
BEGIN DROP FUNCTION [dbo].MListSR_Det END
GO
CREATE FUNCTION MListSR_Det (@P_ANO as int, @P_ID as int)    
RETURNS Table    
AS RETURN(    
          
SELECT    
 Cast(0 as bit) as ProcessFlag,     
 Cover.COVERNO,    
 Acceptance.AName,    
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
 Year(RARRHEADER.RDATE) As RYear    
From    
 Acceptance,    
 RArrHeader,    
 Cover,    
 SysTab,    
 QMasterAcceptance_PCalc() AS QPCalc,    
 TOC,    
 SysRequest    
Where    
 cover.CNO = acceptance.CNO    
 And RArrHeader.ANO=Acceptance.ANO    
 And QPCalc.ANO=Acceptance.ANO    
 And Acceptance.ANO<>Acceptance.LANO    
 And Acceptance.LANO=@P_ANO    
 And SysRequest.ID=@P_ID    
 And SysRequest.Param2 in ('MAR','UND','CLM')    
 And SysRequest.Param3=Acceptance.ANO    
 And TOC.TOC=Acceptance.TOC)
 
GO

--IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Production_Realized]') AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) ) 
--BEGIN DROP FUNCTION [dbo].Production_Realized END
--GO
--CREATE Function Production_Realized(@P_PEDate smalldatetime, @P_EDate smalldatetime)              
--RETURNS Table              
--AS RETURN(              
--Select A1.AdmNo, A2.A_PolicyNo as PolicyNo, A1.ANO, A2.Branch, A1.TOC, A1.Code, A1.Type, A1.Currency, A1.Amount, V.Rate, A1.ID, A1.BizmapID, A1.Source, C.ISType    
--from AccAss A1, Admlink A2, Acceptance A3, Cover C, nVoucher V              
--Where V.Voucher=A2.Voucher and A2.AdmNo=A1.AdmNo and A3.ANO=A1.ANO and C.CNO=A3.CNO and A2.Date>@P_PEDate and A2.Date<=@P_EDate                              
  
--Union All              
  
--Select A1.AdmNo, A1.PolicyNo, A1.ANO, A2.Branch, A1.TOC, A1.Code, A1.Type, A1.Currency, -(A1.Current_Deferred-A1.Previous_Deferred) as Amount, A1.Rate, A1.ID, A1.BizmapID, A1.Source, C.ISType              
--from R_PREMIUM_DEFERRED_RESERVE(@P_PEDate,@P_EDate) as A1, Acceptance A2, Cover C             
--Where A2.ANO = A1.ANO and C.CNO=A2.CNO             
  
--)              
  
--GO

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SListSR_Det]') AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) ) 
BEGIN DROP FUNCTION [dbo].SListSR_Det END
GO
CREATE FUNCTION SListSR_Det (@P_ANO as int, @P_ID as int)    
RETURNS Table    
AS RETURN(    
          
SELECT    
 Cast(0 as bit) as ProcessFlag,   
 [Acceptance].[CertificateNo],    
 Acceptance.ESeqNo,    
 [Acceptance].[AName],    
 [Acceptance].[ANO],    
 [Acceptance].[REGNO],    
 [Acceptance].[ADATE],    
 [Acceptance].[LUSERID] as UserID,    
 [SysTab].[Currency],    
 [QPCalc].[TSI],    
 [QPCalc].[OurShare],    
 [QPCalc].[Gross],    
 [Acceptance].[ASTATUS],    
 [Acceptance].[ATYPE],    
 [Acceptance].[SDate],    
 [Acceptance].[EDate],    
 Year([acceptance].[SDate]) As RYear    
From    
 Acceptance,    
 Cover,    
 SysTab,    
 QMasterAcceptance_PCalc() AS QPCalc,    
 TOC,    
 SysRequest,    
 Service    
Where    
 [cover].[CNO] = [acceptance].[CNO]    
 And [QPCalc].[ANO]=[Acceptance].[ANO]    
 And [Acceptance].[ANO]<>[Acceptance].[LANO]    
 And [Acceptance].[LANO]=@P_ANO    
 And SysRequest.ID=@P_ID    
 And SysRequest.Param2 in ('SVC')    
 And SysRequest.Param3=Service.SNO    
 And Acceptance.ANO=Service.PANO    
 And TOC.TOC=Acceptance.TOC) 
 
 GO
 
IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SMListSR_Det]') AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) ) 
BEGIN DROP FUNCTION [dbo].SMListSR_Det END
GO
CREATE FUNCTION SMListSR_Det (@P_ANO as int, @P_ID as int)  
RETURNS Table  
AS RETURN(  
        
SELECT  
 Cast(0 as bit) as ProcessFlag,   
 Cover.COVERNO,  
 Acceptance.AName,  
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
 Year(RARRHEADER.RDATE) As RYear  
From  
 Acceptance,  
 RArrHeader,  
 Cover,  
 SysTab,  
 QMasterAcceptance_PCalc() AS QPCalc,  
 TOC,  
 SysRequest  
Where  
 cover.CNO = acceptance.CNO  
 And RArrHeader.ANO=Acceptance.ANO  
 And QPCalc.ANO=Acceptance.ANO  
 And Acceptance.ANO<>Acceptance.LANO  
 And Acceptance.LANO=@P_ANO  
 And SysRequest.ID=@P_ID  
 And SysRequest.Param2 in ('SVC')    
 And SysRequest.Param3=Acceptance.ANO  
 And TOC.TOC=Acceptance.TOC)  
 
 GO
 
IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[fn_Deductible]') AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) ) 
BEGIN DROP FUNCTION [dbo].fn_Deductible END
GO
Create Function fn_Deductible(@P_ANO as int,@P_Category as varchar(1))    
RETURNS VarChar(1024)    
AS    
BEGIN    
 Declare @Remarks as varchar(1024)    
 Declare @Remark as varchar(1024)    
      
 Select @Remarks=''    
 DECLARE AccDed_Cursor CURSOR FOR    
 Select Distinct cast(AccDed.Remarks as varchar(1024)) as Remarks from AccDed, RClass, Acceptance, Cover    
 Where AccDed.ANO=@P_ANO and RClass.TOR=AccDed.TOR and Cover.CNO=Acceptance.CNO and AccDed.ANO=Acceptance.ANO and RClass.TOC=Acceptance.TOC and (RClass.Category=@P_Category or @P_Category='')    
 OPEN AccDed_CURSOR    
 FETCH FROM AccDed_CURSOR into @Remark    
 WHILE @@FETCH_STATUS = 0    
 BEGIN    
    if @Remarks=''    
    BEGIN    
  Select @Remarks=@Remark    
    End    
     Else    
    BEGIN    
     Select @Remarks=substring(@Remarks+'|'+@Remark,1,1024)    
    End    
    FETCH NEXT FROM AccDed_CURSOR into @Remark    
 End    
 Close AccDed_CURSOR    
 Deallocate AccDed_CURSOR    
 Return (@Remarks)    
End   

GO

IF EXISTS ( SELECT * FROM   sysobjects WHERE  id = object_id(N'[dbo].[List_Spc_02]') and OBJECTPROPERTY(id, N'IsProcedure') = 1 )
BEGIN DROP PROCEDURE List_Spc_02  END 
GO
CREATE  PROCEDURE dbo.List_Spc_02  
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
 Acceptance.USERID,   
 SysTab.Currency,   
 QPCalc.TSI,   
 QPCalc.OurShare,   
 QPCalc.Gross,   
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
FROM  Acceptance, Cover, SysTab, QMasterAcceptance_PCalc() AS QPCalc, RArrHeader  
WHERE    
 Cover.CNO=Acceptance.CNO   
 And QPCalc.ANO=Acceptance.ANO  
 And RArrHeader.ANO=Acceptance.ANO  
 And (Acceptance.ANO=Acceptance.LANO Or Acceptance.LANO=-1)   
 And left(Acceptance.TOC,2)  in ('03','04')  
 And Acceptance.AStatus='I' and Acceptance.AType<>'C'  
 And Acceptance.ANO not in (SELECT ANO from Classified_Object() C Where C.ANO=Acceptance.ANO)  
 And RArrHeader.TreatyF=1 and (RArrHeader.CAmount<>0 or RArrHeader.DAmount<>0 or RArrHeader.QAmount<>0 or RArrHeader.SP1Amount<>0 or RArrHeader.SP2Amount<>0 or RArrHeader.SP3Amount<>0 or RArrHeader.XPAmount<>0 or RArrHeader.AAmount<>0)  
  
  
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
 Acceptance.USERID,   
 SysTab.Currency,   
 QPCalc.TSI,   
 QPCalc.OurShare,   
 QPCalc.Gross,   
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
FROM  Acceptance, Cover, SysTab, QMasterAcceptance_PCalc() AS QPCalc, RArrHeader, Acceptance As Acceptance_Detail  
WHERE  Cover.CNO=Acceptance.CNO   
 And QPCalc.ANO=Acceptance.ANO   
 And Acceptance.ANO=Acceptance_Detail.LANO  And Acceptance_Detail.LANO<>Acceptance_Detail.ANO  
 And RArrHeader.ANO=Acceptance_Detail.ANO  
 And left(Acceptance.TOC,2)  in ('03','04')  
 And Acceptance_Detail.AStatus='I' and Acceptance_Detail.AType<>'C'  
 And Acceptance_Detail.ANO not in (SELECT ANO from Classified_Object() C Where C.ANO=Acceptance_Detail.ANO)  
 And RArrHeader.TreatyF=1 and (RArrHeader.CAmount<>0 or RArrHeader.DAmount<>0 or RArrHeader.QAmount<>0 or RArrHeader.SP1Amount<>0 or RArrHeader.SP2Amount<>0 or RArrHeader.SP3Amount<>0 or RArrHeader.XPAmount<>0 or RArrHeader.AAmount<>0)      

GO

IF EXISTS ( SELECT * FROM   sysobjects WHERE  id = object_id(N'[dbo].[List_Spc_03]') and OBJECTPROPERTY(id, N'IsProcedure') = 1 )
BEGIN DROP PROCEDURE List_Spc_03  END 
GO
CREATE PROCEDURE dbo.List_Spc_03  
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
 Acceptance.USERID,   
 SysTab.Currency,   
 QPCalc.TSI,   
 QPCalc.OurShare,   
 QPCalc.Gross,   
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
FROM  Acceptance, Cover, SysTab, QMasterAcceptance_PCalc() AS QPCalc, RArrHeader  
WHERE    
 Cover.CNO=Acceptance.CNO   
 And QPCalc.ANO=Acceptance.ANO  
 And RArrHeader.ANO=Acceptance.ANO  
 And (Acceptance.ANO=Acceptance.LANO Or Acceptance.LANO=-1)   
 And Acceptance.AStatus in ('I','W') and Acceptance.AType<>'C'  
 And Acceptance.TOC='0111'  
 And RArrHeader.FAmount=0  
  
  
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
 Acceptance.USERID,   
 SysTab.Currency,   
 QPCalc.TSI,   
 QPCalc.OurShare,   
 QPCalc.Gross,   
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
FROM  Acceptance, Cover, SysTab, QMasterAcceptance_PCalc() AS QPCalc, RArrHeader, Acceptance As Acceptance_Detail  
WHERE  Cover.CNO=Acceptance.CNO   
 And QPCalc.ANO=Acceptance.ANO   
 And Acceptance.ANO=Acceptance_Detail.LANO  And Acceptance_Detail.LANO<>Acceptance_Detail.ANO  
 And RArrHeader.ANO=Acceptance_Detail.ANO  
 And Acceptance_Detail.AStatus in ('I','W') and Acceptance_Detail.AType<>'C'  
 And Acceptance.TOC='0111'  
 And RArrHeader.FAmount=0 
 
 GO
 
IF EXISTS ( SELECT * FROM   sysobjects WHERE  id = object_id(N'[dbo].[List05]') and OBJECTPROPERTY(id, N'IsProcedure') = 1 )
BEGIN DROP PROCEDURE [List05]  END 
GO
CREATE PROCEDURE [dbo].[List05] (@P_UserID as varchar(50), @pSDate as smallDateTime, @pEDate as smallDateTime, @pBranch as varchar(10), @pTOC as varchar(10), @pMO as varchar(10))      
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
 Year(Acceptance.SDate) AS RYear,      
 Cover.ISType,      
 Acceptance.Renewal,      
 Acceptance.ESeqNo,      
 Acceptance.PolicyNo,      
 acceptance.CertificateNo      
FROM  Acceptance, Cover, SysTab, RArrHeader  
Where cover.CNO = acceptance.CNO       
 And RArrHeader.ANO=Acceptance.ANO      
 And (Acceptance.ANO=Acceptance.LANO Or Acceptance.LANO=-1)      
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
FROM  Acceptance, Cover, SysTab, RArrHeader, Acceptance As Acceptance_Detail      
Where cover.CNO = acceptance.CNO       
 And Acceptance.ANO=Acceptance_Detail.LANO  And Acceptance_Detail.LANO<>Acceptance_Detail.ANO      
 And RArrHeader.ANO=Acceptance_Detail.ANO      
 And Cover.CStatus<>'C'      
 And Acceptance_Detail.AStatus='I' and Acceptance_Detail.AType not in ('A','C')      
 And Acceptance_Detail.EDate between @PSDate and @PEDate      
 And Acceptance_Detail.RenewableF=1      
 And Cover.ISType in ('I','C','L')      
 And Acceptance_Detail.Branch like @pBranch+'%'    
 And Acceptance.TOC Like @pTOC+'%'      
 And Cover.MO like @pMO+'%'    
 And not exists  (SELECT ANO from Claim, CLLOSS Where CLLOSS.CNO=Claim.CNO and CLLOSS.CTLF=1 and Claim.ANO=Acceptance_Detail.ANO)      
 and Exists (Select S1.ID from SysUser S1 Left Join SysUserBranch S2 on (S2.ID=S1.ID and S2.AllowedF=1 and S2.Branch=Acceptance_Detail.Branch) Where S1.ID=@P_UserID and (coalesce(S2.Branch,'')<>'' or S1.Type='SUPERVISOR'))  
    
 GO
 
IF EXISTS ( SELECT * FROM   sysobjects WHERE  id = object_id(N'[dbo].[List06]') and OBJECTPROPERTY(id, N'IsProcedure') = 1 )
BEGIN DROP PROCEDURE [List06]  END 
GO
CREATE PROCEDURE [dbo].[List06] (@P_UserID as varchar(50), @pSDate as smalldateTime, @pEDate as smallDateTime, @pBranch as varchar(10), @pTOC as varchar(10), @pMO as varchar(10))      
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
 Year(Acceptance.SDate) AS RYear,      
 Cover.ISType,      
 Acceptance.Renewal,      
 Acceptance.ESeqNo,      
 Acceptance.PolicyNo,      
 acceptance.CertificateNo      
FROM  Acceptance, Cover, SysTab  
Where cover.CNO = acceptance.CNO         
 And (Acceptance.ANO=Acceptance.LANO Or Acceptance.LANO=-1)      
 And Acceptance.AStatus='I'      
 And Acceptance.AType<>'C'      
 And Cover.ISType<>'T'      
 And Acceptance.Branch like @pBranch+'%'    
 And Acceptance.TOC Like @pTOC+'%'      
 And Cover.MO like @pMO+'%'    
 And Acceptance.EDate between @pSDate and @pEDate      
 and Exists (Select S1.ID from SysUser S1 Left Join SysUserBranch S2 on (S2.ID=S1.ID and S2.AllowedF=1 and S2.Branch=Acceptance.Branch) Where S1.ID=@P_UserID and (coalesce(S2.Branch,'')<>'' or S1.Type='SUPERVISOR'))      
        
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
FROM  Acceptance, Cover, SysTab, Acceptance As Acceptance_Detail      
Where cover.CNO = acceptance.CNO      
 And (Acceptance.ANO=Acceptance.LANO Or Acceptance.LANO=-1)      
 And Acceptance.ANO=Acceptance_Detail.LANO And Acceptance_Detail.LANO<>Acceptance_Detail.ANO      
 And Acceptance_Detail.AStatus='I'      
 And Acceptance_Detail.AType<>'C'      
 And Cover.ISType<>'T'      
 And Acceptance_Detail.Branch like @pBranch+'%'    
 And Acceptance.TOC Like @pTOC+'%'      
 And Cover.MO like @pMO+'%'     
 And Acceptance_Detail.EDate between @pSDate and @pEDate      
 and Exists (Select S1.ID from SysUser S1 Left Join SysUserBranch S2 on (S2.ID=S1.ID and S2.AllowedF=1 and S2.Branch=Acceptance_Detail.Branch) Where S1.ID=@P_UserID and (coalesce(S2.Branch,'')<>'' or S1.Type='SUPERVISOR'))  

GO

IF EXISTS ( SELECT * FROM   sysobjects WHERE  id = object_id(N'[dbo].[List07]') and OBJECTPROPERTY(id, N'IsProcedure') = 1 )
BEGIN DROP PROCEDURE [List07]  END 
GO
CREATE PROCEDURE [dbo].[List07] (@PSDate as SmallDateTime, @pEDAte as smallDateTime,@P_COB as varchar(10))  
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
 Year(Acceptance.SDate) AS RYear,  
 Cover.ISType,  
 Acceptance.Renewal,  
 Acceptance.ESeqNo,  
 Acceptance.PolicyNo,  
 acceptance.CertificateNo  
FROM  Acceptance, Cover, SysTab, TOC  
Where cover.CNO = acceptance.CNO  
 And (Acceptance.ANO=Acceptance.LANO Or Acceptance.LANO=-1)  
 And ((Acceptance.AType='C' and Acceptance.AStatus='I' and Acceptance.PPDate between @PSdate and @pEDate)  
 or (Acceptance.AType<>'C' and Acceptance.AStatus='C' And Acceptance.CloseDate between @PSdate and @pEDate)  
 or (Acceptance.AType<>'C' and Acceptance.AStatus='I' and Acceptance.EDate between @PSdate and @pEDate))  
 And Cover.ISType<>'T'  
 And Acceptance.AdjustableF=1  
 And TOC.TOC=Acceptance.TOC  
 And TOC.COB=@P_COB  
 
 go
 
IF EXISTS ( SELECT * FROM   sysobjects WHERE  id = object_id(N'[dbo].[List10]') and OBJECTPROPERTY(id, N'IsProcedure') = 1 )
BEGIN DROP PROCEDURE [List10]  END 
GO
CREATE PROCEDURE [dbo].[List10](@P_TOC as varchar(10), @P_Branch as varchar(10), @P_PolicyNO as varchar(10), @P_SDate as smalldatetime, @P_EDate as smalldatetime, @P_AStatus as varchar(1))             
AS            
SELECT Cast(0 as bit) as ProcessFlag, Acceptance.ANO AS ANO,             
 Cover.CNO,            
 Cover.CoverDate,            
 Cover.ExpDate,            
 Cast(Acceptance.AName as varchar(128)) as Insured,            
 Cover.UserID,            
 Cover.CStatus,            
 ISource.RType,             
 Acceptance.RegNo,             
 Acceptance.PolicyNo,            
 Profile.Name,             
 Acceptance.AStatus,             
 TOC.Description,             
 Acceptance.Branch            
FROM  Cover, ISource, Acceptance, Payor, Profile, TOC            
WHERE  Acceptance.ANO=Acceptance.LANO             
 And Cover.CNO=Acceptance.CNO             
 And ISource.CNO=Cover.CNO             
 And Payor.ANO=Acceptance.ANO             
 And Cover.ISType='T' and Cover.ProformaF=0  
 And Profile.ID=Payor.ID             
 And TOC.TOC=Acceptance.TOC            
 And TOC.TOC Like @P_TOC+'%'        
 And Acceptance.Branch Like @P_Branch+'%'        
 And Acceptance.PolicyNo Like @P_PolicyNo +'%'        
 And (Acceptance.AStatus=@P_AStatus or @P_AStatus='')    
 And (@P_SDate between Cover.CoverDate and Cover.ExpDate  or @P_EDate between Cover.CoverDate and Cover.ExpDate or Cover.CoverDate Between @P_SDate and @P_EDate or Cover.ExpDate Between @P_SDate and @P_EDate)      
 order by ACCEPTANCE.RegNo 
 
 GO
 
IF EXISTS ( SELECT * FROM   sysobjects WHERE  id = object_id(N'[dbo].[List11a]') and OBJECTPROPERTY(id, N'IsProcedure') = 1 )
BEGIN DROP PROCEDURE [List11a]  END 
GO
CREATE PROCEDURE [dbo].[List11a](@P_UserID as varchar(255), @P_TOC as varchar(10), @P_Branch as varchar(10), @P_AStatus as varchar(1))   
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
Year(Acceptance.SDate) AS RYear,   
Cover.ISType,   
Acceptance.Renewal,   
Acceptance.ESeqNo,   
Acceptance.PolicyNo,   
acceptance.CertificateNo   
FROM  Acceptance, Cover, SysTab, RArrHeader, SysUser   
Where cover.CNO = acceptance.CNO   
And RArrHeader.ANO=Acceptance.ANO   
And (Acceptance.ANO=Acceptance.LANO Or Acceptance.LANO=-1)   
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
FROM  Acceptance, Cover, SysTab, RArrHeader, Acceptance As Acceptance_Detail, SysUser   
Where cover.CNO = acceptance.CNO   
And Acceptance.ANO=Acceptance_Detail.LANO  And Acceptance_Detail.LANO<>Acceptance_Detail.ANO   
And RArrHeader.ANO=Acceptance_Detail.ANO   
And Cover.CStatus<>'C'   
And Acceptance_Detail.AStatus='W'   
And (RArrHeader.RAmount<>0 or RArrHeader.HoldF=1)   
And Cover.ISType<>'T'   
And Acceptance_Detail.TOC Like @P_TOC and Acceptance_Detail.Branch Like @P_Branch and (Acceptance_Detail.AStatus=@P_AStatus or @P_AStatus='')   
And SysUser.ID=@P_UserID   
and (SysUser.Type='SUPERVISOR' or   
(   
EXISTS (Select Branch from SysUserBranch S Where S.ID=@P_UserID and S.Branch=Acceptance_Detail.Branch)   
and   
EXISTS (Select TOC from SysUserTOC S Where S.ID=@P_UserID and S.TOC=Acceptance_Detail.TOC)   
))   

GO

IF EXISTS ( SELECT * FROM   sysobjects WHERE  id = object_id(N'[dbo].[List11F]') and OBJECTPROPERTY(id, N'IsProcedure') = 1 )
BEGIN DROP PROCEDURE [List11F]  END 
GO
CREATE PROCEDURE [dbo].[List11F](@P_UserID as varchar(10), @P_TOC as varchar(10), @P_Branch as varchar(10), @P_PDate as smalldatetime, @P_ManualF as bit)      
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
 Year(Acceptance.SDate) AS RYear,      
 Cover.ISType,      
 Acceptance.Renewal,      
 Acceptance.ESeqNo,      
 Acceptance.PolicyNo,      
 acceptance.CertificateNo      
FROM  Acceptance, Cover, SysTab, RArrHeader, SysUserTOC, SysUserBranch      
Where cover.CNO = acceptance.CNO       
 And RArrHeader.ANO=Acceptance.ANO      
 And (Acceptance.ANO=Acceptance.LANO Or Acceptance.LANO=-1)      
 And Cover.CStatus<>'C'      
 And Acceptance.AStatus='I' and Acceptance.AType not in ('A','C')      
 And RArrHeader.NRDate<Acceptance.EDate And RArrHeader.NRDate<=@P_PDate      
 And (@P_ManualF=0 or RArrHeader.ManualF=@P_ManualF)    
 And Cover.ISType<>'T'      
 And SysUserTOC.ID=@P_UserID and Acceptance.TOC=SysUserTOC.TOC and (SysUserTOC.TOC Like @P_TOC+'%' or @P_TOC='')    
 And SysUserBranch.ID=@P_UserID and Acceptance.BRanch=SysUserBranch.Branch and (SysUserBranch.Branch=@P_Branch or @P_Branch='')     
  
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
FROM  Acceptance, Cover, SysTab, RArrHeader, Acceptance As Acceptance_Detail, SysUserTOC, SysUserBranch  
Where cover.CNO = acceptance.CNO       
 And Acceptance.ANO=Acceptance_Detail.LANO  And Acceptance_Detail.LANO<>Acceptance_Detail.ANO      
 And RArrHeader.ANO=Acceptance_Detail.ANO      
 And Cover.CStatus<>'C'      
 And Acceptance_Detail.AStatus='I' and Acceptance_Detail.AType not in ('A','C')      
 And RArrHeader.NRDate<Acceptance_Detail.EDate And RArrHeader.NRDate<=@P_PDate      
 And (@P_ManualF=0 or RArrHeader.ManualF=@P_ManualF)    
 And Cover.ISType<>'T'      
 And SysUserTOC.ID=@P_UserID and Acceptance_Detail.TOC=SysUserTOC.TOC and (SysUserTOC.TOC Like @P_TOC+'%' or @P_TOC='')    
 And SysUserBranch.ID=@P_UserID and Acceptance_Detail.BRanch=SysUserBranch.Branch and (SysUserBranch.Branch=@P_Branch or @P_Branch='')    
 
 GO

IF EXISTS ( SELECT * FROM   sysobjects WHERE  id = object_id(N'[dbo].[List16]') and OBJECTPROPERTY(id, N'IsProcedure') = 1 )
BEGIN DROP PROCEDURE [List16]  END 
GO
CREATE PROCEDURE [dbo].[List16] (@pSDate as smalldatetime, @pEDate as smalldatetime,@P_COB as varchar(10))
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
      Year(Acceptance.SDate) AS RYear, 
      Cover.ISType, 
      Acceptance.Renewal, 
      Acceptance.ESeqNo, 
      Acceptance.PolicyNo, 
      Acceptance.CertificateNo
FROM       Acceptance, Cover, SysTab, TOC
WHERE       Cover.CNO=Acceptance.CNO 
      And (Acceptance.ANO=Acceptance.LANO Or Acceptance.LANO=-1) 
      And Cover.ISType<>'T' 
      And Acceptance.ADate>=@pSDate 
      And Acceptance.ADate<=@pEDate
      And TOC.TOC=Acceptance.TOC
      And TOC.COB=@P_COB

GO

IF EXISTS ( SELECT * FROM   sysobjects WHERE  id = object_id(N'[dbo].[List16SC]') and OBJECTPROPERTY(id, N'IsProcedure') = 1 )
BEGIN DROP PROCEDURE [List16SC] END 
GO
CREATE  PROCEDURE [dbo].[List16SC](@P_SDate as smalldatetime, @P_EDate as smalldatetime,@P_COB as varchar(10),@P_ServiceNo as varchar(20))
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
 Year(Acceptance.SDate) AS RYear,
 Cover.ISType,
 Acceptance.Renewal,
 Acceptance.ESeqNo,
 Acceptance.PolicyNo,
 acceptance.CertificateNo
FROM  Acceptance, Cover, SysTab, TOC, Service
Where cover.CNO = acceptance.CNO
 And (Acceptance.ANO=Acceptance.LANO Or Acceptance.LANO=-1)
 And Service.SType='CANCELLATION'
 And Service.PANO=Acceptance.ANO
 And Service.Cdate Between @P_Sdate and @P_EDate
 And Service.SStatus='P'
 And TOC.TOC=Acceptance.TOC
 And TOC.COB Like @P_COB+'%'
 And Service.ServiceNo Like @P_ServiceNo+'%'

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
FROM  Acceptance, Cover, SysTab, Acceptance As Acceptance_Detail, TOC, Service
Where cover.CNO = acceptance.CNO
 And Acceptance.ANO=Acceptance_Detail.LANO  And Acceptance_Detail.LANO<>Acceptance_Detail.ANO
 And Service.SType='CANCELLATION'
 And Service.PANO=Acceptance_Detail.ANO
 And Service.Cdate Between @P_Sdate and @P_EDate
 And Service.SStatus='P'
 And TOC.TOC=Acceptance_Detail.TOC
 And TOC.COB Like @P_COB+'%'
 And Service.ServiceNo Like @P_ServiceNo+'%'

GO

IF EXISTS ( SELECT * FROM   sysobjects WHERE  id = object_id(N'[dbo].[List16SD]') and OBJECTPROPERTY(id, N'IsProcedure') = 1 )
BEGIN DROP PROCEDURE [List16SD] END 
GO
CREATE PROCEDURE [dbo].[List16SD](@P_SDate as smalldatetime, @P_EDate as smalldatetime,@P_COB as varchar(10),@P_ServiceNo as varchar(20))
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
 Year(Acceptance.SDate) AS RYear,
 Cover.ISType,
 Acceptance.Renewal,
 Acceptance.ESeqNo,
 Acceptance.PolicyNo,
 acceptance.CertificateNo
FROM  Acceptance, Cover, SysTab, TOC, Service
Where cover.CNO = acceptance.CNO
 And (Acceptance.ANO=Acceptance.LANO Or Acceptance.LANO=-1)
 And ((Service.PANO=Acceptance.ANO and Service.SType<>'NEW') or (Service.ANO=Acceptance.ANO and Service.SType='NEW'))
 And Service.Cdate Between @P_Sdate and @P_EDate
 And Acceptance.AStatus='W'
 And Service.SStatus='C'
 And TOC.TOC=ACCEPTANCE.TOC
 And TOC.COB Like @P_COB+'%'
 And Service.ServiceNo Like @P_ServiceNo+'%'

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
FROM  Acceptance, Cover, SysTab, Acceptance As Acceptance_Detail, TOC, Service
Where cover.CNO = acceptance.CNO
 And Acceptance.ANO=Acceptance_Detail.LANO  And Acceptance_Detail.LANO<>Acceptance_Detail.ANO
 And ((Service.PANO=Acceptance_Detail.ANO and Service.SType<>'NEW') or (Service.ANO=Acceptance_Detail.ANO and Service.SType='NEW'))
 And Service.Cdate Between @P_Sdate and @P_EDate
 And Acceptance_Detail.AStatus='W'
 And Service.SStatus='C'
 And TOC.TOC=Acceptance_Detail.TOC
 And TOC.COB Like @P_COB+'%'
 And Service.ServiceNo Like @P_ServiceNo+'%'

GO

IF EXISTS ( SELECT * FROM   sysobjects WHERE  id = object_id(N'[dbo].[List16SE]') and OBJECTPROPERTY(id, N'IsProcedure') = 1 )
BEGIN DROP PROCEDURE [List16SE] END 
GO
CREATE  PROCEDURE [dbo].[List16SE](@P_SDate as smalldatetime, @P_EDate as smalldatetime,@P_COB as varchar(10),@P_ServiceNo as varchar(20))
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
 Year(Acceptance.SDate) AS RYear,
 Cover.ISType,
 Acceptance.Renewal,
 Acceptance.ESeqNo,
 Acceptance.PolicyNo,
 acceptance.CertificateNo
FROM  Acceptance, Cover, SysTab, TOC, Service
Where cover.CNO = acceptance.CNO
 And (Acceptance.ANO=Acceptance.LANO Or Acceptance.LANO=-1)
 And Service.SType='ENDORSEMENT'
 And Service.PANO=Acceptance.ANO
 And Service.Cdate Between @P_Sdate and @P_EDate
 And Service.SStatus='P'
 And TOC.TOC=ACCEPTANCE.TOC
 And TOC.COB Like @P_COB+'%'
 And Service.ServiceNo Like @P_ServiceNo+'%'
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
FROM  Acceptance, Cover, SysTab, Acceptance As Acceptance_Detail, TOC, Service
Where cover.CNO = acceptance.CNO
 And Acceptance.ANO=Acceptance_Detail.LANO  And Acceptance_Detail.LANO<>Acceptance_Detail.ANO
 And Service.SType='ENDORSEMENT'
 And Service.PANO=Acceptance_Detail.ANO
 And Service.Cdate Between @P_Sdate and @P_EDate
 And Service.SStatus='P'
 And TOC.TOC=Acceptance_Detail.TOC
 And TOC.COB Like @P_COB+'%'
 And Service.ServiceNo Like @P_ServiceNo+'%'

 GO

IF EXISTS ( SELECT * FROM   sysobjects WHERE  id = object_id(N'[dbo].[List16SL]') and OBJECTPROPERTY(id, N'IsProcedure') = 1 )
BEGIN DROP PROCEDURE [List16SL] END 
GO
CREATE PROCEDURE [dbo].[List16SL](@P_SDate as smalldatetime, @P_EDate as smalldatetime,@P_COB as varchar(10),@P_ServiceNo as varchar(20))
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
 Year(Acceptance.SDate) AS RYear,
 Cover.ISType,
 Acceptance.Renewal,
 Acceptance.ESeqNo,
 Acceptance.PolicyNo,
 acceptance.CertificateNo
FROM  Acceptance, Cover, SysTab, TOC, Service
Where cover.CNO = acceptance.CNO
 And (Acceptance.ANO=Acceptance.LANO Or Acceptance.LANO=-1)
 And Service.SType='EXPIRED'
 And Service.PANO=Acceptance.ANO
 And Service.Cdate Between @P_Sdate and @P_EDate
 And Service.SStatus='P'
 And TOC.TOC=ACCEPTANCE.TOC
 And TOC.COB Like @P_COB+'%'
 And Service.ServiceNo Like @P_ServiceNo+'%'

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
FROM  Acceptance, Cover, SysTab, Acceptance As Acceptance_Detail, TOC, Service
Where cover.CNO = acceptance.CNO
 And Acceptance.ANO=Acceptance_Detail.LANO  And Acceptance_Detail.LANO<>Acceptance_Detail.ANO
 And Service.SType='EXPIRED'
 And Service.PANO=Acceptance_Detail.ANO
 And Service.Cdate Between @P_Sdate and @P_EDate
 And Service.SStatus='P'
 And TOC.TOC=Acceptance_Detail.TOC
 And TOC.COB Like @P_COB+'%'
 And Service.ServiceNo Like @P_ServiceNo+'%'

GO

IF EXISTS ( SELECT * FROM   sysobjects WHERE  id = object_id(N'[dbo].[List16SL]') and OBJECTPROPERTY(id, N'IsProcedure') = 1 )
BEGIN DROP PROCEDURE [List16SR] END 
GO
CREATE PROCEDURE [dbo].[List16SR](@P_SDate as smalldatetime, @P_EDate as smalldatetime,@P_COB as varchar(10),@P_ServiceNo as varchar(20))
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
 Year(Acceptance.SDate) AS RYear,
 Cover.ISType,
 Acceptance.Renewal,
 Acceptance.ESeqNo,
 Acceptance.PolicyNo,
 acceptance.CertificateNo
FROM  Acceptance, Cover, SysTab, TOC, Service
Where cover.CNO = acceptance.CNO
 And (Acceptance.ANO=Acceptance.LANO Or Acceptance.LANO=-1)
 And Service.SType='RENEWAL'
 And Service.PANO=Acceptance.ANO
 And Service.Cdate Between @P_Sdate and @P_EDate
 And Service.SStatus='P'
 And TOC.TOC=ACCEPTANCE.TOC
 And TOC.COB Like @P_COB+'%'
 And Service.ServiceNo Like @P_ServiceNo+'%'

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
 Acceptance.AStatus,
 Acceptance.ATYPE,
 Acceptance.SDate,
 Acceptance.EDate,
 Year(Acceptance.SDate) AS RYear,
 Cover.ISType,
 Acceptance.Renewal,
 Acceptance.ESeqNo,
 Acceptance.PolicyNo,
 acceptance.CertificateNo
FROM  Acceptance, Cover, SysTab, Acceptance As Acceptance_Detail, TOC, Service
Where cover.CNO = acceptance.CNO
 And Acceptance.ANO=Acceptance_Detail.LANO  And Acceptance_Detail.LANO<>Acceptance_Detail.ANO
 And Service.SType='RENEWAL'
 And Service.PANO=Acceptance_Detail.ANO
 And Service.Cdate Between @P_Sdate and @P_EDate
 And Service.SStatus='P'
 And TOC.TOC=Acceptance_Detail.TOC
 And TOC.COB Like @P_COB+'%'
 And Service.ServiceNo Like @P_ServiceNo+'%'

 GO


IF EXISTS ( SELECT * FROM   sysobjects WHERE  id = object_id(N'[dbo].[List18]') and OBJECTPROPERTY(id, N'IsProcedure') = 1 )
BEGIN DROP PROCEDURE [List18] END 
GO
CREATE PROCEDURE [dbo].[List18] (@P_UserID as varchar(10), @P_TOC as varchar(10), @P_Branch as varchar(10), @P_PDate as smalldatetime)  
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
 Year(Acceptance.SDate) AS RYear,  
 Cover.ISType,  
 Acceptance.Renewal,  
 Acceptance.ESeqNo,  
 Acceptance.PolicyNo,  
 acceptance.CertificateNo  
FROM  Acceptance, Cover, SysTab, SysUserTOC, SysUserBranch
Where cover.CNO = acceptance.CNO  
 And (Acceptance.ANO=Acceptance.LANO Or Acceptance.LANO=-1)  
 And Acceptance.AStatus='I'  
 And Acceptance.AType Not in ('C','A')  
 And Cover.ISType<>'T'  
 AND @P_PDate between Acceptance.PDate and Acceptance.PPDate  
 And SysUserTOC.ID=@P_UserID and ACCEPTANCE.TOC=SysUserTOC.TOC and (SysUserTOC.TOC=@P_TOC or @P_TOC='')
 And SysUserBranch.ID=@P_UserID and Acceptance.BRanch=SysUserBranch.Branch and (SysUserBranch.Branch=@P_Branch or @P_Branch='')
 And Acceptance.ANO in (SELECT ANO from Claim, CLLOSS Where (Claim.CSTATUS IN ('R','P','T','A') OR Claim.PCSTATUS IN ('A')) and Claim.CNO=CLLOSS.CNO and CLLOSS.CTLF=1 And Claim.ANO=Acceptance.ANO)  
     
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
FROM  Acceptance, Cover, SysTab, Acceptance As Acceptance_Detail, SysUserTOC, SysUserBranch
Where cover.CNO = acceptance.CNO  
 And Acceptance.ANO=Acceptance_Detail.LANO  And Acceptance_Detail.LANO<>Acceptance_Detail.ANO  
 And Acceptance.AStatus='I'  
 And Acceptance.AType Not in ('C','A')  
 And Cover.ISType<>'T'  
 AND @P_PDate between Acceptance_Detail.PDate and Acceptance_Detail.PPDate  
 And SysUserTOC.ID=@P_UserID and Acceptance_Detail.TOC=SysUserTOC.TOC and (SysUserTOC.TOC=@P_TOC or @P_TOC='')
 And SysUserBranch.ID=@P_UserID and Acceptance_Detail.BRanch=SysUserBranch.Branch and (SysUserBranch.Branch=@P_Branch or @P_Branch='')
 And Acceptance_Detail.ANO in (SELECT ANO from Claim, CLLOSS Where (Claim.CSTATUS IN ('R','P','T','A') OR Claim.PCSTATUS IN ('A')) and Claim.CNO=CLLOSS.CNO and CLLOSS.CTLF=1 And Claim.ANO=Acceptance_Detail.ANO)  
 
GO

IF EXISTS ( SELECT * FROM   sysobjects WHERE  id = object_id(N'[dbo].[List19]') and OBJECTPROPERTY(id, N'IsProcedure') = 1 )
BEGIN DROP PROCEDURE [List19] END 
GO
CREATE PROCEDURE [dbo].[List19] (@P_Days as smallint,@P_Date as Smalldatetime,@P_COB as varchar(10),@P_Branch as varchar(10), @P_UnPaidOpt as bit) 
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
Year(Acceptance.SDate) AS RYear, 
Cover.ISType, 
Acceptance.Renewal, 
Acceptance.ESeqNo, 
Acceptance.PolicyNo, 
Acceptance.CertificateNo 
FROM  Acceptance, Cover, SysTab, TOC 
WHERE  Cover.CNO=Acceptance.CNO 
And TOC.TOC=ACCEPTANCE.TOC and TOC.COB=@P_COB And Acceptance.Branch Like @P_Branch+'%' 
And (Acceptance.ANO=Acceptance.LANO Or Acceptance.LANO=-1)And Cover.ISType<>'T' 
And Acceptance.AStatus='I' And Acceptance.AType<>'C' 
And EXISTS (SELECT A1.OANO from Acceptance A1, AccAss, Admlink, nVoucher Voucher Where A1.ANO=AccAss.ANO and A1.OANO=Acceptance.OANO and Voucher.Voucher=Admlink.Voucher and Admlink.AdmNo=AccAss.AdmNo and AccAss.Type in ('DI','IC','IR') and Voucher.nDueDate+@P_Days<@P_Date and Voucher.Nominal_CC-Voucher.Diff_CC-Voucher.Payment_CC-Voucher.Payment_OC<>0 and (@P_UnPaidOpt=0 or Voucher.Payment_CC=0)) 
 
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
FROM  Acceptance, Cover, SysTab, Acceptance As Acceptance_Detail, TOC 
WHERE  Cover.CNO=Acceptance.CNO 
And TOC.TOC=Acceptance_Detail.TOC and TOC.COB=@P_COB And Acceptance_Detail.Branch Like @P_Branch+'%' 
And Acceptance.ANO=Acceptance_Detail.LANO  And Acceptance_Detail.LANO<>Acceptance_Detail.ANO And Cover.ISType<>'T' 
And Acceptance.AStatus='I' And Acceptance.AType<>'C' 
And Acceptance_Detail.AStatus='I'  And Acceptance_Detail.AType<>'C' 
And EXISTS (SELECT A1.OANO from Acceptance A1, AccAss, Admlink, nVoucher Voucher Where A1.ANO=AccAss.ANO and A1.OANO=Acceptance_Detail.OANO and Voucher.Voucher=Admlink.Voucher and Admlink.AdmNo=AccAss.AdmNo and AccAss.Type in ('DI','IC','IR') and Voucher.nDueDate+@P_Days<@P_Date and Voucher.Nominal_CC-Voucher.Diff_CC-Voucher.Payment_CC-Voucher.Payment_OC<>0 and (@P_UnPaidOpt=0 or Voucher.Payment_CC=0)) 
 
 GO

IF EXISTS ( SELECT * FROM   sysobjects WHERE  id = object_id(N'[dbo].[ListSR]') and OBJECTPROPERTY(id, N'IsProcedure') = 1 )
BEGIN DROP PROCEDURE [ListSR] END 
GO
CREATE PROCEDURE [dbo].[ListSR](@P_ID as int)  
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
 QPCalc.TSI,  
 QPCalc.OurShare,  
 QPCalc.Gross,  
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
FROM  Acceptance, Cover, SysTab, QMasterAcceptance_PCalc() AS QPCalc, TOC, SysRequest  
Where cover.CNO = acceptance.CNO  
 And QPCalc.ANO=Acceptance.ANO  
 And (Acceptance.ANO=Acceptance.LANO Or Acceptance.LANO=-1)  
 And SysRequest.ID=@P_ID  
 And SysRequest.Param2 in ('MAR','UND','CLM')  
 And SysRequest.Param3=Acceptance.ANO  
 And TOC.TOC=ACCEPTANCE.TOC  
    
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
 QPCalc.TSI,  
 QPCalc.OurShare,  
 QPCalc.Gross,  
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
FROM  Acceptance, Cover, SysTab, QMasterAcceptance_PCalc() AS QPCalc, Acceptance As Acceptance_Detail, TOC, SysRequest  
Where cover.CNO = acceptance.CNO  
 And QPCalc.ANO=Acceptance.ANO  
 And Acceptance.ANO=Acceptance_Detail.LANO  And Acceptance_Detail.LANO<>Acceptance_Detail.ANO  
 And SysRequest.ID=@P_ID  
 And SysRequest.Param2 in ('MAR','UND','CLM')  
 And SysRequest.Param3=Acceptance_Detail.ANO  
 And TOC.TOC=Acceptance_Detail.TOC 
 
 GO

IF EXISTS ( SELECT * FROM   sysobjects WHERE  id = object_id(N'[dbo].[MListSR]') and OBJECTPROPERTY(id, N'IsProcedure') = 1 )
BEGIN DROP PROCEDURE [MListSR] END 
GO
CREATE PROCEDURE [dbo].[MListSR](@P_ID as int) 
AS 
SELECT Cast(0 as bit) as ProcessFlag, Cover.COVERNO, Cover.Insured, Cover.CNO, Cover.CStatus, Cover.VSeqNo, Acceptance.lANO, Acceptance.ANO, Acceptance.REGNO, Acceptance.ADATE, Acceptance.LUSERID as USERID, SysTab.Currency, QPCalc.TSI, QPCalc.OurShare, QPCalc.Gross, Acceptance.ASTATUS, Acceptance.ATYPE, Acceptance.SDate, Acceptance.EDate, 
		Year(Coalesce(RArrHeader.RDate,Acceptance.SDate)) AS RYear, 
		Cover.ISType, 
		Acceptance.Renewal, 
		Acceptance.ESeqNo, 
		Acceptance.PolicyNo 
FROM  Acceptance Left Join RArrHeader on (RArrHeader.ANO=Acceptance.ANO) Left Join QDetail_PCalc() QPCalc on (qPCalc.ANO=Acceptance.ANO and Acceptance.PStatus='C'), Cover, SysTab, TOC, SysRequest 
Where cover.CNO = acceptance.CNO 
And (Acceptance.ANO=Acceptance.LANO Or Acceptance.LANO=-1) 
And SysRequest.ID=@P_ID 
And SysRequest.Param2 in ('MAR','UND','CLM') 
And SysRequest.Param3=Acceptance.ANO 
And TOC.TOC=ACCEPTANCE.TOC 
 
Union 
 
SELECT  Cast(0 as bit) as ProcessFlag, Cover.COVERNO, Cover.Insured, Cover.CNO, Cover.CStatus, Cover.VSeqNo, Acceptance.lANO, Acceptance.ANO, Acceptance.REGNO, Acceptance.ADATE, Acceptance.LUSERID as USERID, SysTab.Currency, QPCalc.TSI, QPCalc.OurShare, QPCalc.Gross, Acceptance.ASTATUS, Acceptance.ATYPE, Acceptance.SDate, Acceptance.EDate, 
		Year(Coalesce(RArrHeader.RDate,Acceptance.SDate)) AS RYear, 
		Cover.ISType, 
		Acceptance.Renewal, 
		Acceptance.ESeqNo, 
		Acceptance.PolicyNo 
FROM  Acceptance Left Join RArrHeader on (RArrHeader.ANO=Acceptance.ANO) Left Join QDetail_PCalc() QPCalc on (qPCalc.ANO=Acceptance.ANO and Acceptance.PStatus='C'), Cover, SysTab, Acceptance As Acceptance_Detail, TOC, SysRequest 
Where cover.CNO = acceptance.CNO 
And Acceptance.ANO=Acceptance_Detail.LANO  And Acceptance_Detail.LANO<>Acceptance_Detail.ANO 
And SysRequest.ID=@P_ID 
And SysRequest.Param2 in ('MAR','UND','CLM') 
And SysRequest.Param3=Acceptance_Detail.ANO 
And TOC.TOC=Acceptance_Detail.TOC 
 
GO
IF EXISTS ( SELECT * FROM   sysobjects WHERE  id = object_id(N'[dbo].[PCALC01]') and OBJECTPROPERTY(id, N'IsProcedure') = 1 )
BEGIN DROP PROCEDURE [PCALC01] END 
GO
CREATE Procedure [dbo].[PCALC01](@P_ANO integer)    
As    
SELECT  ACCEPTANCE.TOC,    
  COVER.PPERIOD,    
  COVER.PRORATA,    
  COVER.VOYAGE,    
  CASE WHEN RCOVER.UNIT='L' Then 'C' ELSE RCOVER.UNIT END AS UNIT,    
  RCOVER.CODE,    
  RATECOV.TOR,    
  RCOVER.DISCOUNT+RCOVER.DISCOUNT_EXT AS DISCOUNT,    
  RCOVER.LOADING,    
  CASE 
  WHEN RCOVER.UNIT='L' Then 0 
  WHEN RCOVER.CATEGORY='M' AND ICOVER.CATEGORY='M' THEN RCOVER.RATE*RATECOV.PORTION/RCOVER.PORTION*DBO.FN_RATE_LOADING(RCOVER.ANO)
  ELSE RCOVER.RATE*RATECOV.PORTION/RCOVER.PORTION
  END AS RATE,
  RATECOV.PORTION,    
  RCOVER.SDATE,    
  RCOVER.EDATE,    
  RCOVER.PCALC,    
  Case WHEN ICOVER.NOTDECRF=1 OR ICOVER.NOTFLF=1 then 100 else RCOVER.PCTLOSS end as PCTLOSS,    
  Case WHEN ICOVER.NOTDECRF=1 OR ICOVER.NOTFLF=1 then 0 else RCOVER.PADDITION end as PADDITION,    
  CASE WHEN ICOVER.NOTFLF=1 THEN 100 ELSE RCOVER.PPRORATA END AS PPRORATA,
  ICOVER.CURRENCY,    
  ICOVER.SI,    
  ICOVER.INDEMNITY,    
  (Select sum(DDiscount) from AccDed Where ANO=ICover.ANO and (Currency='' or Currency=ICover.Currency) and TOR=RateCov.TOR) as DDISCOUNT,
  ICOVER.Adjustable,    
  ICOVER.PCTADJ,    
  ICOVER.INO,    
  ACCEPTANCE.ANO as SANO,    
  PolicyType.SType
FROM  RCLASS, RATECOV, RCOVER, PCLASS, ICOVER, TOI, ACCEPTANCE, COVER Left Join PolicyType on (PolicyType.PolicyType=Cover.PolicyType)    
WHERE  ACCEPTANCE.ANO=@P_ANO    
  And COVER.CNO=ACCEPTANCE.CNO    
  And RCLASS.TOC=ACCEPTANCE.TOC    
  And RCOVER.ANO=ACCEPTANCE.ANO    
  And ICOVER.ANO=ACCEPTANCE.ANO    
  And RATECOV.CODE=RCOVER.CODE    
  And RCLASS.TOR=RATECOV.TOR    
  And PCLASS.TOR=RATECOV.TOR    
  And PCLASS.TOI=ICOVER.TOI    
  And TOI.TOI=ICOVER.TOI    
ORDER BY ICOVER.CURRENCY, RCOVER.CODE, RATECOV.TOR,RCOVER.SDATE, ACCEPTANCE.ANO




GO

IF EXISTS ( SELECT * FROM   sysobjects WHERE  id = object_id(N'[dbo].PCALC01_ADJ') and OBJECTPROPERTY(id, N'IsProcedure') = 1 )
BEGIN DROP PROCEDURE PCALC01_ADJ END 
GO
CREATE Procedure PCALC01_ADJ(@P_ANO integer)   
As   
SELECT  COVER.TOC,   
COVER.PPERIOD,   
DATEDIFF(DAY,A1.SDATE, A1.EDATE) as PRORATA,   
COVER.VOYAGE,   
CASE WHEN RCOVER.UNIT='L' Then 'C' ELSE RCOVER.UNIT END AS UNIT,    
RCOVER.CODE,   
RATECOV.TOR,   
RCOVER.DISCOUNT+RCOVER.DISCOUNT_EXT AS DISCOUNT,    
RCOVER.LOADING,   
CASE 
WHEN RCOVER.UNIT='L' Then 0 
WHEN RCOVER.CATEGORY='M' AND ICOVER.CATEGORY='M' THEN RCOVER.RATE*RATECOV.PORTION/RCOVER.PORTION*RCalc.Prorata*DBO.FN_RATE_LOADING(RCOVER.ANO)
ELSE RCOVER.RATE*RATECOV.PORTION/RCOVER.PORTION*RCalc.Prorata
END AS RATE,   
case when RCOVER.SDATE<A2.PDATE then A2.PDATE Else RCOVER.SDATE end as SDATE,   
Case When RCOVER.EDATE>A2.PPDATE then A2.PPDATE ELSE RCOVER.EDATE end as EDATE,   
Case WHEN ICOVER.NOTDECRF=1 then 100 else RCOVER.PCTLOSS end as PCTLOSS,   
Case WHEN ICOVER.NOTDECRF=1 then 0 else RCOVER.PADDITION end as PADDITION,   
Case When (Case when RCOVER.SDATE<A2.PDATE then A2.PDATE Else RCOVER.SDATE end)=A1.SDATE AND (Case When RCOVER.EDATE>A2.PPDATE then A2.PPDATE ELSE RCOVER.EDATE end)=A1.EDATE Then RCover.PCalc Else 'P' End as PCalc,   
Case when TOI.ADJMETHOD='OVERLIMIT ' then A1.CPCT else (Case When A1.CPCT<>0 then A1.CPCT else 100 end*cast(datediff(day, case when RCOVER.SDATE<A2.PDATE then A2.PDATE Else RCOVER.SDATE end, Case When RCOVER.EDATE>A2.PPDATE then A2.PPDATE ELSE RCOVER.EDATE end) as float)/  cast(DATEDIFF(DAY,RCOVER.SDATE, RCOVER.EDATE) as float)) end as PPRORATA,   
ICOVER.CURRENCY,   
ICOVER.SI,   
(Select sum(DDiscount) from AccDed Where ANO=ICover.ANO and (Currency='' or Currency=ICover.Currency) and TOR=RateCov.TOR) as DDISCOUNT,
ICOVER.Adjustable,   
ICOVER.PCTADJ,   
TOI.ADJMETHOD,   
ICOVER.INO,   
A2.ANO AS SANO,   
PolicyType.SType   
FROM  RCLASS, RATECOV, RCOVER, PCLASS, ICOVER, TOI, RCalc, COVER Left Join PolicyType on (PolicyType.PolicyType=Cover.PolicyType), ACCEPTANCE A1, ACCEPTANCE A2   
Where A1.PDate <= A2.PDate And A1.PPDate >= A2.PPDate And A2.PDate <= A2.PPDate   
and A1.ANO=@P_ANO and A2.OANO=A1.OANO and A2.ANO<=A1.PANO and A2.ANO<@P_ANO and A2.AType not in ('A','C') and Cover.CNO=A1.CNO   
and ICOVER.ANO=A1.ANO and ICOVER.Adjustable=1   
and RCOVER.ANO=A2.ANO   
and RATECOV.CODE=RCOVER.CODE   
and RCLASS.TOC=COVER.TOC   
and RCLASS.TOR=RATECOV.TOR   
and PCLASS.TOR=RATECOV.TOR   
and PCLASS.TOI=ICOVER.TOI   
and TOI.TOI=ICOVER.TOI   
and RCalc.ANO=A2.ANO and RCalc.Currency=ICover.Currency and RCalc.Code=RCover.Code and RCalc.TOR=RateCov.TOR and RCalc.SDate=RCover.SDate   
and NOT EXISTS (Select PANO from Acceptance A3 Where A3.PANO=A2.ANO and A3.AStatus<>'C' and A3.AType='A' and A3.ANO<>@P_ANO)   
and (TOI.ADJMETHOD<>'OVERLIMIT' or A2.ANO=A1.PANO)   
and (case when RCOVER.SDATE<A2.PDATE then A2.PDATE Else RCOVER.SDATE end)<(Case When RCOVER.EDATE>A2.PPDATE then A2.PPDATE ELSE RCOVER.EDATE end)
ORDER BY ICOVER.CURRENCY, RCOVER.CODE, RATECOV.TOR, RCOVER.SDATE, A2.ANO   



GO

IF EXISTS ( SELECT * FROM   sysobjects WHERE  id = object_id(N'[dbo].[PCALC01_TEMP]') and OBJECTPROPERTY(id, N'IsProcedure') = 1 )
BEGIN DROP PROCEDURE [PCALC01_TEMP] END 
GO
CREATE  Procedure [dbo].[PCALC01_TEMP](@P_ANO integer)
As
SELECT 	COVER.TOC, 
		COVER.PPERIOD, 
		COVER.PRORATA, 
		COVER.VOYAGE, 
		RCOVER.UNIT, 
		RCOVER.CODE, 
		RATECOV.TOR, 
		RCOVER.DISCOUNT, 
		RCOVER.LOADING, 
		RCOVER.RATE*RATECOV.PORTION/RCOVER.PORTION AS RATE, 
		RATECOV.PORTION,
		RCOVER.SDATE, 
		RCOVER.EDATE, 
		RCOVER.PCALC, 
		RCOVER.PCTLOSS, 
		RCOVER.PADDITION, 
		RCOVER.PPRORATA, 
		ICOVER.CURRENCY, 
		ICOVER.SI, 
		ICOVER.Adjustable, 
		TOI.PCTADJ, 
		ICOVER.INO,
		ACCEPTANCE.ANO as SANO
FROM 	RCLASS, RATECOV, tRCOVER RCOVER, PCLASS, tICOVER ICOVER, TOI, tACCEPTANCE ACCEPTANCE, COVER
WHERE 	ACCEPTANCE.ANO=@P_ANO 
		And COVER.CNO=ACCEPTANCE.CNO 
		And RCLASS.TOC=COVER.TOC 
		And RCOVER.ANO=ACCEPTANCE.ANO 
		And ICOVER.ANO=ACCEPTANCE.ANO 
		And RATECOV.CODE=RCOVER.CODE 
		And RCLASS.TOR=RATECOV.TOR 
		And PCLASS.TOR=RATECOV.TOR 
		And PCLASS.TOI=ICOVER.TOI 
		And TOI.TOI=ICOVER.TOI
ORDER BY ICOVER.CURRENCY, RCOVER.CODE, RATECOV.TOR,RCOVER.SDATE;

GO

IF EXISTS ( SELECT * FROM   sysobjects WHERE  id = object_id(N'[dbo].[PCALC02]') and OBJECTPROPERTY(id, N'IsProcedure') = 1 )
BEGIN DROP PROCEDURE [PCALC02] END 
GO
CREATE Procedure [dbo].[PCALC02](@P_ANO integer)
AS
SELECT  ICOVER.CURRENCY, SUM(CASE WHEN ICOVER.CATEGORY='M' THEN ICOVER.SI ELSE 0 END) AS TSI, SUM(CASE WHEN ICOVER.CATEGORY='M' THEN ICOVER.AMOUNT ELSE 0 END) AS AMOUNT
From ICOVER
WHERE  ICOVER.ANO=@P_ANO
  AND ICOVER.TOI IN ( SELECT  PCLASS.TOI
       From PCLASS, RCLASS, RCOVER, acceptance, cover, RATECOV
       Where acceptance.ANO = ICOVER.ANO
         AND COVER.CNO=ACCEPTANCE.CNO
         AND RCLASS.TOC=ACCEPTANCE.TOC
         AND RCOVER.ANO=ACCEPTANCE.ANO
         AND RATECOV.CODE=RCOVER.CODE
         AND RCLASS.TOR=RATECOV.TOR
         AND PCLASS.TOR=RATECOV.TOR
         AND PCLASS.TOI=ICOVER.TOI)
GROUP BY ICOVER.CURRENCY

GO

IF EXISTS ( SELECT * FROM   sysobjects WHERE  id = object_id(N'[dbo].[PCALC02_ADJ]') and OBJECTPROPERTY(id, N'IsProcedure') = 1 )
BEGIN DROP PROCEDURE [PCALC02_ADJ] END 
GO
CREATE Procedure [dbo].[PCALC02_ADJ](@P_ANO integer)
AS
SELECT  ICOVER.CURRENCY, SUM(ICOVER.SI) AS TSI, SUM(ICOVER.AMOUNT) AS AMOUNT
From ICOVER
WHERE  ICOVER.ANO=@P_ANO and ICOVER.Adjustable=1
  AND ICOVER.TOI IN ( SELECT  PCLASS.TOI
       From PCLASS, RCLASS, RCOVER, acceptance, cover, RATECOV
       Where acceptance.ANO = ICOVER.ANO
         AND COVER.CNO=ACCEPTANCE.CNO
         AND RCLASS.TOC=ACCEPTANCE.TOC
         AND RCOVER.ANO=ACCEPTANCE.ANO
         AND RATECOV.CODE=RCOVER.CODE
         AND RCLASS.TOR=RATECOV.TOR
         AND PCLASS.TOR=RATECOV.TOR
         AND PCLASS.TOI=ICOVER.TOI
         -- AND NOT (RCOVER.CATEGORY='A' and ICOVER.CATEGORY='A'))
         AND ICOVER.CATEGORY='M')
GROUP BY ICOVER.CURRENCY

GO

IF EXISTS ( SELECT * FROM   sysobjects WHERE  id = object_id(N'[dbo].[PCALC02_ADJ_TEMP]') and OBJECTPROPERTY(id, N'IsProcedure') = 1 )
BEGIN DROP PROCEDURE [PCALC02_ADJ_TEMP] END 
GO
CREATE Procedure [dbo].[PCALC02_ADJ_TEMP](@P_ANO integer)
AS
SELECT  ICOVER.CURRENCY, SUM(ICOVER.SI) AS TSI, SUM(ICOVER.AMOUNT) AS AMOUNT
FROM  TICOVER ICOVER
WHERE  ICOVER.ANO=@P_ANO AND ICOVER.Adjustable=1
  AND ICOVER.TOI IN ( SELECT  PCLASS.TOI
       From PCLASS, RCLASS, RCOVER, acceptance, cover, RATECOV
       Where acceptance.ANO = ICOVER.ANO
         AND COVER.CNO=ACCEPTANCE.CNO
         AND RCLASS.TOC=ACCEPTANCE.TOC
         AND RCOVER.ANO=ACCEPTANCE.ANO
         AND RATECOV.CODE=RCOVER.CODE
         AND RCLASS.TOR=RATECOV.TOR
         AND PCLASS.TOR=RATECOV.TOR
         AND PCLASS.TOI=ICOVER.TOI
         AND NOT (PCLASS.CATEGORY='A' and RCLASS.CATEGORY='A'))
GROUP BY ICOVER.CURRENCY

GO

IF EXISTS ( SELECT * FROM   sysobjects WHERE  id = object_id(N'[dbo].[PCALC02_TEMP]') and OBJECTPROPERTY(id, N'IsProcedure') = 1 )
BEGIN DROP PROCEDURE [PCALC02_TEMP] END 
GO
CREATE Procedure [dbo].[PCALC02_TEMP](@P_ANO integer)
AS
SELECT  ICOVER.CURRENCY, SUM(ICOVER.SI) AS TSI, SUM(ICOVER.AMOUNT) AS AMOUNT
FROM  TICOVER ICOVER
WHERE  ICOVER.ANO=@P_ANO
  AND ICOVER.TOI IN ( SELECT  PCLASS.TOI
       From PCLASS, RCLASS, RCOVER, acceptance, cover, RATECOV
       Where acceptance.ANO = ICOVER.ANO
         AND COVER.CNO=ACCEPTANCE.CNO
         AND RCLASS.TOC=ACCEPTANCE.TOC
         AND RCOVER.ANO=ACCEPTANCE.ANO
         AND RATECOV.CODE=RCOVER.CODE
         AND RCLASS.TOR=RATECOV.TOR
         AND PCLASS.TOR=RATECOV.TOR
         AND PCLASS.TOI=ICOVER.TOI
         -- AND NOT (RCOVER.CATEGORY='A' and ICOVER.CATEGORY='A'))
         AND ICOVER.CATEGORY='M')
GROUP BY ICOVER.CURRENCY

GO

IF EXISTS ( SELECT * FROM   sysobjects WHERE  id = object_id(N'[dbo].[PI14]') and OBJECTPROPERTY(id, N'IsProcedure') = 1 )
BEGIN DROP PROCEDURE [PI14] END 
GO
CREATE procedure [dbo].[PI14] (@P_ANO as integer)                
as                
Begin                
 Select Distinct Acceptance.OANO as ANO, Cover.CoverNo, Acceptance.RegNo, Acceptance.PolicyNo, Acceptance.CertificateNo, Acceptance.SDate, Acceptance.EDate, Acceptance.AName, TOC.Description as TOCDesc  
 from Acceptance, Cover, TOC  
 Where Acceptance.CANO=@P_ANO and Cover.CNO=Acceptance.CNO and TOC.TOC=ACCEPTANCE.TOC  
   
 union all  
  
 Select Distinct Acceptance.OANO as ANO, Cover.CoverNo, Acceptance.RegNo, Acceptance.PolicyNo, Acceptance.CertificateNo, Acceptance.SDate, Acceptance.EDate, Acceptance.AName, TOC.Description as TOCDesc  
 from Acceptance CAcceptance, Acceptance, Cover, TOC  
 Where CAcceptance.ANO=@P_ANO and Acceptance.ANO=CAcceptance.CANO and Cover.CNO=Acceptance.CNO and TOC.TOC=ACCEPTANCE.TOC  
  
end   

GO

IF EXISTS ( SELECT * FROM   sysobjects WHERE  id = object_id(N'[dbo].[PointRewardRenewal_Process]') and OBJECTPROPERTY(id, N'IsProcedure') = 1 )
BEGIN DROP PROCEDURE [PointRewardRenewal_Process] END 
GO
CREATE Procedure [dbo].[PointRewardRenewal_Process](@P_CardID as varchar(20), @P_SDate as Smalldatetime, @P_EDate as smalldatetime)  
as  
Select   
OneCardH.CardID,   
Case When Acceptance.LANO=-1 or Cover.OpenFlag=0 Then 'Policy' else 'Certificate' end as DocType,   
Case When Acceptance.LANO=-1 or Cover.OpenFlag=0 Then Acceptance.PolicyNo else Acceptance.PolicyNo+'-'+Acceptance.CertificateNo end as DocNo,  
Max(Acceptance.ADate) as Date,  
Max(Acceptance.Renewal) as RYear,  
Max(coalesce(PRewardR.RPP, PRewardD.RPP)) as RPP,  
Max(coalesce(PRewardR.RPC, PRewardD.RPC)) as RPC  
from Acceptance  
inner join Cover on (Cover.CNO=Acceptance.CNO)  
inner join TOC on (TOC.TOC=ACCEPTANCE.TOC)  
inner join OneCardD on (OneCardD.ID=Cover.PHolder)  
inner join OneCardH on (OneCardH.CardID=OneCardD.CardID and (OneCardH.CardID=@P_CardID or @P_CardID='<All>'))  
Inner join PRewardD on (PRewardD.PYear=Year(@P_SDate) and (PRewardD.TOC='<All>' or PRewardD.TOC=ACCEPTANCE.TOC))  
Left  Join PRewardR on (PRewardR.PYear=PRewardD.PYear and PRewardR.TOC=PRewardD.TOC and PRewardR.TOR=PRewardD.TOR and PRewardR.RYear=Acceptance.Renewal)  
Where ((Acceptance.ANO<>Acceptance.LANO  and Cover.OpenFlag=1) or (Acceptance.LANO=-1))
and ((Acceptance.EDate Between @P_SDate and @P_EDate))
and Acceptance.Renewal<>0 and Acceptance.AType='N' and Acceptance.AStatus not in ('W','T') and Cover.CStatus<>'C'  
and PRewardD.TOR in (Select '<All>' union all Select RCalc.TOR from RCalc Where RCalc.ANO=Acceptance.ANO)  
Group By   
OneCardH.CardID,   
Case When Acceptance.LANO=-1 or Cover.OpenFlag=0 Then 'Policy' else 'Certificate' end,   
Case When Acceptance.LANO=-1 or Cover.OpenFlag=0 Then Acceptance.PolicyNo else Acceptance.PolicyNo+'-'+Acceptance.CertificateNo end  

Union All

Select
OneCardH.CardID,   
Case When Acceptance.LANO=-1 or Cover.OpenFlag=0 Then 'Policy' else 'Certificate' end as DocType,   
Case When Acceptance.LANO=-1 or Cover.OpenFlag=0 Then Acceptance.PolicyNo else Acceptance.PolicyNo+'-'+Acceptance.CertificateNo end as DocNo,  
Max(Acceptance.ADate) as Date,  
Max(Acceptance.Renewal) as RYear,  
Max(coalesce(PRewardR.RPP, PRewardD.RPP)) as RPP,  
Max(coalesce(PRewardR.RPC, PRewardD.RPC)) as RPC  
from Acceptance  
inner join Cover on (Cover.CNO=Acceptance.CNO)  
inner join TOC on (TOC.TOC=ACCEPTANCE.TOC)  
inner join OneCardD on (OneCardD.ID=Cover.PHolder)  
inner join OneCardH on (OneCardH.CardID=OneCardD.CardID and (OneCardH.CardID=@P_CardID or @P_CardID='<All>'))  
Inner join PRewardD on (PRewardD.PYear=Year(@P_SDate) and (PRewardD.TOC='<All>' or PRewardD.TOC=ACCEPTANCE.TOC))  
Left  Join PRewardR on (PRewardR.PYear=PRewardD.PYear and PRewardR.TOC=PRewardD.TOC and PRewardR.TOR=PRewardD.TOR and PRewardR.RYear=Acceptance.Renewal)  
Where (Acceptance.ANO=Acceptance.LANO and Cover.OpenFlag=0) 
and ((Acceptance.EDate Between @P_SDate and @P_EDate))
and Acceptance.Renewal<>0 and Acceptance.AType='N' and Acceptance.AStatus not in ('W','T') and Cover.CStatus<>'C'  
and PRewardD.TOR in (Select '<All>' union all Select RCalc.TOR from RCalc Where RCalc.ANO=Acceptance.ANO)  
Group By   
OneCardH.CardID,   
Case When Acceptance.LANO=-1 or Cover.OpenFlag=0 Then 'Policy' else 'Certificate' end,   
Case When Acceptance.LANO=-1 or Cover.OpenFlag=0 Then Acceptance.PolicyNo else Acceptance.PolicyNo+'-'+Acceptance.CertificateNo end             

GO

IF EXISTS ( SELECT * FROM   sysobjects WHERE  id = object_id(N'[dbo].[QACCDOCLIST]') and OBJECTPROPERTY(id, N'IsProcedure') = 1 )
BEGIN DROP PROCEDURE [QACCDOCLIST] END 
GO
CREATE Procedure [dbo].[QACCDOCLIST](@P_ANO integer)   
as   
Select A1.*, A2.ImageID   
from   
(   
select Cast(coalesce(ACCDOCLIST.AvailableF, 0) as bit) as ProcessFlag, PDOCLIST.DocType, coalesce(ACCDOCLIST.Description, PDOCLIST.Description) as Description, coalesce(ACCDOCLIST.AvailableF, 0) as AvailableF, cast(coalesce(DOCTYPE.CollectionF,0) as Bit) 
as CollectionF, ACCDOCLIST.RECDATE   
from ACCEPTANCE INNER JOIN COVER ON (ACCEPTANCE.ANO=@P_ANO AND COVER.CNO=ACCEPTANCE.CNO) INNER JOIN PDOCLIST ON (PDOCLIST.TOC=ACCEPTANCE.TOC) Left join DOCTYPE on (DOCTYPE.DOCTYPE=PDOCLIST.DOCTYPE)   
Left Join ACCDOCLIST on (ACCDOCLIST.ANO=@P_ANO and ACCDOCLIST.DOCTYPE=PDOCLIST.DOCTYPE)   
   
Union All   
   
select Cast(coalesce(ACCDOCLIST.AvailableF, 0) as bit) as ProcessFlag, ACCDOCLIST.DocType, ACCDOCLIST.Description, ACCDOCLIST.AvailableF, cast(coalesce(DOCTYPE.CollectionF,0) as Bit) as CollectionF, ACCDOCLIST.RECDATE   
from ACCDOCLIST Left Join DOCTYPE on (DOCTYPE.DOCTYPE=ACCDOCLIST.DOCTYPE)   
Where ACCDOCLIST.ANO=@P_ANO   
AND NOT EXISTS (Select PDOCLIST.DOCTYPE from PDOCLIST, COVER, ACCEPTANCE Where PDOCLIST.DOCTYPE=ACCDOCLIST.DOCTYPE AND ACCEPTANCE.ANO=@P_ANO AND COVER.CNO=ACCEPTANCE.CNO AND PDOCLIST.TOC=ACCEPTANCE.TOC)   
) A1 Left Join ACCDOCLISTPIC A2 on (A2.ANO=@P_ANO and A2.DocType=A1.DocType)
Order By A1.DOCTYPE   

GO


IF EXISTS ( SELECT * FROM   sysobjects WHERE  id = object_id(N'[dbo].[QApproval_Production]') and OBJECTPROPERTY(id, N'IsProcedure') = 1 )
BEGIN DROP PROCEDURE [QApproval_Production] END 
GO
CREATE Procedure [dbo].[QApproval_Production] (@P_ANO integer)              
AS              
SELECT top 1 Acceptance.PolicyNo, Acceptance.CertificateNo, 
Max(Case When Acceptance.ANO=@P_ANO Then Acceptance.Branch else '' end) as Branch,    
Max(ACCEPTANCE.TOC) as TOC, Max(Cover.ISType) as ISType,   
MIN(Case When TOC.ApplyApprLimitByTOLF=1 Then RARRHEADER.CLIMIT*RARRHEADER.LIMIT*100 ELSE 100 END) as ApprLimitPct,  
sum(PCALC.AMOUNT*RARRHEADER.PCTSHARE/100*(1-RARRHEADER.MSHARE/100)*PCALC.Rate) as Amount              
From PCALC, Acceptance, Cover, RARRHEADER, TOC              
WHERE ((ACCEPTANCE.ANO=@P_ANO And (Cover.OpenFlag=1 or Acceptance.ANO<>Acceptance.LANO)) or (ACCEPTANCE.LANO=@P_ANO And Cover.OpenFlag=0))        
and Cover.CNO=Acceptance.CNO and PCALC.ANO=ACCEPTANCE.ANO AND RARRHEADER.ANO=ACCEPTANCE.ANO              
and TOC.TOC=ACCEPTANCE.TOC  
Group By Acceptance.PolicyNo, Acceptance.CertificateNo
Order By sum(PCALC.AMOUNT*RARRHEADER.PCTSHARE/100*(1-RARRHEADER.MSHARE/100)*PCALC.Rate) Desc            

GO

IF EXISTS ( SELECT * FROM   sysobjects WHERE  id = object_id(N'[dbo].[QBSType]') and OBJECTPROPERTY(id, N'IsProcedure') = 1 )
BEGIN DROP PROCEDURE [QBSType] END 
GO
CREATE PROCEDURE [dbo].[QBSType](@PANO as integer=0) 
AS 
SELECT B.* 
FROM BSType B 
Left Join Acceptance A on (A.ANO=@PANO) 
Left Join Cover C on (C.CNO=A.CNO) 
Left Join TOC on (TOC.TOC=A.TOC) 
Where (coalesce(TOC.CommPoolBSF,0)=1 or B.BSType<>'C') 
 
GO

IF EXISTS ( SELECT * FROM   sysobjects WHERE  id = object_id(N'[dbo].[QCheckMaxOutGo]') and OBJECTPROPERTY(id, N'IsProcedure') = 1 )
BEGIN DROP PROCEDURE [QCheckMaxOutGo] END 
GO
CREATE Procedure [dbo].[QCheckMaxOutGo](@P_ANO as integer) 
as 
Declare @Temp Table(ANO Int, Code varchar(10), PrevOutGo Float, OutGo Float) 
 
insert into @Temp(ANO, Code, PrevOutGo, OutGo) 
Select Distinct R1.ANO, R1.Code, dbo.Premium_MaxOutGo(A.PANO, R1.Code,0) as PrevOutGo, dbo.Premium_MaxOutGo(A.ANO, R1.Code,0) as OutGo from Acceptance A, RCover R1 Where R1.ANO=A.ANO and A.ANO=@P_ANO 
 
Select R1.ANO, 
Case 
When R1.OutGo>R2.MaxOutGo Then 'Rate Code ('+R1.Code+') Maximum Out Go !' 
When R1.OutGo>BS.MaxOutGo Then 'Business Source ('+BS.ID+') Maximum Out Go !' 
When R1.OutGo>BR.MaxOutGo Then 'Business Rule ('+BR.BizMapID+') Maximum Out Go !' 
End as ErrDesc 
from Acceptance A 
Inner Join RArrHeader R on (R.ANO=A.ANO) 
Inner Join @Temp R1 on (R1.ANO=A.ANO) 
Inner Join Cover C on (C.CNO=A.CNO) 
Inner join Profile BS on (BS.ID=A.Source) 
Inner join RateTab R2 on (R2.Code=R1.Code) 
Left Join BRRule BR on (BR.TOC=A.TOC and (BR.Branch='<All>' or BR.Branch=A.Branch) and (BR.BizmapID='<All>' or BR.BizMapID=A.BizMapID) and (BR.FacOpt=0 or (BR.FacOpt=1 and R.FAmount<>0) or (BR.FacOpt=2 and R.FAmount=0))) 
Where A.ANO=@P_ANO and R1.PrevOutGo<R1.OutGo 
and ((R2.MaxOutGo<>0 and R1.OutGo>R2.MaxOutGo) Or (BS.MaxOutGo<>0 and R1.OutGo>BS.MaxOutGo) Or (BR.MaxOutGo<>0 and R1.OutGo>BR.MaxOutGo)) 

GO

IF EXISTS ( SELECT * FROM   sysobjects WHERE  id = object_id(N'[dbo].[QCheckObjectInsured]') and OBJECTPROPERTY(id, N'IsProcedure') = 1 )
BEGIN DROP PROCEDURE [QCheckObjectInsured] END 
GO
CREATE Procedure [dbo].[QCheckObjectInsured](@P_ANO as integer) 
as 
Select max(C1.CoverNo) as QuotationNo, max(A1.RegNo) as CINo, max(A1.PolicyNo+case when A1.CertificateNo='' then '' else '-'+A1.CertificateNo end) as PolicyNo, max(A1.AName) as Insured, max(A1.SDate) as Inception, max(A1.EDate) as Expiry, 
Max(Cast(TOC.FLDTAG1+' : '+A3.ValueDesc1 as varchar(255))) as ObjInfo_1, 
Max(Cast(TOC.FLDTAG2+' : '+A3.ValueDesc2 as varchar(255))) as ObjInfo_2, 
Max(Cast(TOC.FLDTAG3+' : '+A3.ValueDesc3 as varchar(255))) as ObjInfo_3, 
Max(Cast(TOC.FLDTAG4+' : '+A3.ValueDesc4 as varchar(255))) as ObjInfo_4, 
Max(Cast(TOC.FLDTAG5+' : '+A3.ValueDesc5 as varchar(255))) as ObjInfo_5, 
Max(Cast(TOC.FLDTAG6+' : '+A3.ValueDesc6 as varchar(255))) as ObjInfo_6, 
Max(Cast(TOC.FLDTAG7+' : '+A3.ValueDesc7 as varchar(255))) as ObjInfo_7, 
Max(Cast(TOC.FLDTAG8+' : '+A3.ValueDesc8 as varchar(255))) as ObjInfo_8, 
Max(Cast(TOC.FLDTAG9+' : '+A3.ValueDesc9 as varchar(255))) as ObjInfo_9, 
Max(Cast(TOC.FLDTAG10+' : '+A3.ValueDesc10 as varchar(255))) as ObjInfo_10, 
Max(Cast(TOC.FLDTAG11+' : '+A3.ValueDesc11 as varchar(255))) as ObjInfo_11, 
Max(Cast(TOC.FLDTAG12+' : '+A3.ValueDesc12 as varchar(255))) as ObjInfo_12, 
Max(Cast(TOC.FLDTAG13+' : '+A3.ValueDesc13 as varchar(255))) as ObjInfo_13, 
Max(Cast(TOC.FLDTAG14+' : '+A3.ValueDesc14 as varchar(255))) as ObjInfo_14, 
Max(Cast(TOC.FLDTAG15+' : '+A3.ValueDesc15 as varchar(255))) as ObjInfo_15, 
Max(A1.ANO) as ANO 
from Cover C1, Acceptance A1 Left Join AInfo A3 On (A3.ANO=A1.ANO), Cover C2, Acceptance A2, TOC 
Where A2.ANO=@P_ANO and A2.ANO<>A2.LANO and C2.CNO=A2.CNO and TOC.TOC=C2.TOC and A2.AType not in ('A','C') 
and A1.ANO<>A2.RANO and A1.ANO<>A1.LANO and A1.OANO<>A2.OANO and C1.CNO=A1.CNO and A1.AType not in ('A','C') 
and Not (A1.AType='N' and A1.AStatus='C' and ((C1.CStatus='A' and C1.ASource='MKT') or C1.CStatus='C')) 
and A1.PDate<A1.PPDate 
and ( 
	(A1.pDate<=A2.pDate and ((A1.PPDate>A2.PDate) or (A1.PPDate>=A2.PDate and A1.ExclusiveF=0 and A2.ExclusiveF=1))) Or 
	(A2.pDate<=A1.pDate and ((A2.PPDate>A1.PDate) or (A2.PPDate>=A1.PDate and A2.ExclusiveF=0 and A1.ExclusiveF=1))) 
	) 
and A1.REGID=A2.REGID and A1.FLDID<>'' and A1.FLDID=A2.FLDID and A1.ValueID=A2.ValueID 
and TOC.UniqueRefNoF=0 
group By A1.OANO 
 
Union All 
 
Select max(C1.CoverNo) as QuotationNo, max(A1.RegNo) as CINo, max(A1.PolicyNo+case when A1.CertificateNo='' then '' else '-'+A1.CertificateNo end) as PolicyNo, max(A1.AName) as Insured, max(A1.SDate) as Inception, max(A1.EDate) as Expiry, 
Max(Cast(TOC.FLDTAG1+' : '+A3.ValueDesc1 as varchar(255))) as ObjInfo_1, 
Max(Cast(TOC.FLDTAG2+' : '+A3.ValueDesc2 as varchar(255))) as ObjInfo_2, 
Max(Cast(TOC.FLDTAG3+' : '+A3.ValueDesc3 as varchar(255))) as ObjInfo_3, 
Max(Cast(TOC.FLDTAG4+' : '+A3.ValueDesc4 as varchar(255))) as ObjInfo_4, 
Max(Cast(TOC.FLDTAG5+' : '+A3.ValueDesc5 as varchar(255))) as ObjInfo_5, 
Max(Cast(TOC.FLDTAG6+' : '+A3.ValueDesc6 as varchar(255))) as ObjInfo_6, 
Max(Cast(TOC.FLDTAG7+' : '+A3.ValueDesc7 as varchar(255))) as ObjInfo_7, 
Max(Cast(TOC.FLDTAG8+' : '+A3.ValueDesc8 as varchar(255))) as ObjInfo_8, 
Max(Cast(TOC.FLDTAG9+' : '+A3.ValueDesc9 as varchar(255))) as ObjInfo_9, 
Max(Cast(TOC.FLDTAG10+' : '+A3.ValueDesc10 as varchar(255))) as ObjInfo_10, 
Max(Cast(TOC.FLDTAG11+' : '+A3.ValueDesc11 as varchar(255))) as ObjInfo_11, 
Max(Cast(TOC.FLDTAG12+' : '+A3.ValueDesc12 as varchar(255))) as ObjInfo_12, 
Max(Cast(TOC.FLDTAG13+' : '+A3.ValueDesc13 as varchar(255))) as ObjInfo_13, 
Max(Cast(TOC.FLDTAG14+' : '+A3.ValueDesc14 as varchar(255))) as ObjInfo_14, 
Max(Cast(TOC.FLDTAG15+' : '+A3.ValueDesc15 as varchar(255))) as ObjInfo_15, 
Max(A1.ANO) as ANO 
from Cover C1, Acceptance A1 Left Join AInfo A3 On (A3.ANO=A1.ANO), Cover C2, Acceptance A2, TOC 
Where A2.ANO=@P_ANO and A2.ANO=A2.LANO and C2.CNO=A2.CNO and TOC.TOC=C2.TOC and A2.AType not in ('A','C') 
and A1.ANO<>A2.RANO and A1.ANO=A1.LANO and A1.OANO<>A2.OANO and C1.CNO=A1.CNO and A1.AType not in ('A','C') 
and Not (A1.AType='N' and A1.AStatus='C' and ((C1.CStatus='A' and C1.ASource='MKT') or C1.CStatus='C')) 
and A1.PDate<A1.PPDate 
and ( 
	(A1.pDate<=A2.pDate and ((A1.PPDate>A2.PDate) or (A1.PPDate>=A2.PDate and A1.ExclusiveF=0 and A2.ExclusiveF=1))) Or 
	(A2.pDate<=A1.pDate and ((A2.PPDate>A1.PDate) or (A2.PPDate>=A1.PDate and A2.ExclusiveF=0 and A1.ExclusiveF=1))) 
	) 
and TOC.UniqueRefNoF=1 and A1.TOC=C2.TOC and A1.RefNo=A2.RefNo 
group By A1.OANO 
 
GO

IF EXISTS ( SELECT * FROM   sysobjects WHERE  id = object_id(N'[dbo].[QCheckObjectInsured_Upload]') and OBJECTPROPERTY(id, N'IsProcedure') = 1 )
BEGIN DROP PROCEDURE [QCheckObjectInsured_Upload] END 
GO
CREATE Procedure [dbo].[QCheckObjectInsured_Upload](@REGID as varchar(10),@FLDID AS varchar(255),@VALUEID AS varchar(255),@PDate AS smalldatetime,@PPDate AS smalldatetime,@REFNO varchar(255),@PExclusiveF as Bit=0) 
as 
 
Select [Quotation No], [CI No], [Policy No], Insured, Inception, Expiry, ANO 
FROM 
( 
Select Top 1 
C1.CoverNo as [Quotation No], 
A1.RegNo as [CI No], 
A1.PolicyNo + case when A1.CertificateNo='' then '' else '-' + A1.CertificateNo end as [Policy No], 
C1.Insured, 
A1.SDate as Inception, 
A1.EDate as Expiry, 
A1.ANO, 
TOC.UniqueRefNoF, 
A1.RefNo 
from Cover C1, Acceptance A1, TOC 
Where C1.CNO=A1.CNO and TOC.TOC=A1.TOC and A1.AType not in ('A','C') 
and A1.LANO<>A1.ANO and Not (A1.AType='N' and A1.AStatus='C' and ((C1.CStatus='A' and C1.ASource='MKT') or C1.CStatus='C')) 
and A1.PDate<A1.PPDate 
and ( 
	(A1.pDate<=@PDate and ((A1.PPDate>@PDate) or (A1.PPDate>=@PDate and A1.ExclusiveF=0 and @PExclusiveF=1))) or 
	(@PDate<=A1.PDate and ((@PPDate>A1.PDate) or (@PPDate>=A1.PDate and @PExclusiveF=0 and A1.ExclusiveF=1))) 
	) 
and A1.RegID=@REGID and A1.FLDID<>'' and A1.FLDID=@FLDID and A1.ValueID=@VALUEID 
) R 
Where R.UniqueRefNoF=0 or (R.UniqueRefNoF=1 and R.RefNo=@REFNO) 
 
GO


IF EXISTS ( SELECT * FROM   sysobjects WHERE  id = object_id(N'[dbo].[QCLACC_3]') and OBJECTPROPERTY(id, N'IsProcedure') = 1 )
BEGIN DROP PROCEDURE [QCLACC_3] END 
GO
CREATE PROCEDURE [dbo].[QCLACC_3] (@P_POLICYNO AS VARCHAR(255), @P_CERTIFICATENO VARCHAR(255), @P_REFNO varchar(50)='', @P_TOC varchar(10)='')     
AS     
SELECT TOP 10 ACCEPTANCE.ANO, ACCEPTANCE.POLICYNO, ACCEPTANCE.CERTIFICATENO, ACCEPTANCE.AID, COVER.INSURED, COVER.ISTYPE, ACCEPTANCE.TOC, ACCEPTANCE.SDATE, ACCEPTANCE.EDATE, Cover.PHolder, ACCEPTANCE.BRANCH, ACCEPTANCE.ANAME, PROFILE.RESTRICTEDF, PROFILE.NAME, ACCEPTANCE.PDATE, ACCEPTANCE.PPDATE, ACCEPTANCE.NCDATE,  ACCEPTANCE.EXTPERIOD,     
Case When GenDTab.Description is not null then ACCEPTANCE.ValueDesc else '' end as Description,     
Case When ISource.ID is null then ACCEPTANCE.AID else ISource.ID end as Payment,     
Case When ISource.ID is null then Profile.Name else PProfile.Name end as Payment_Name     
FROM ACCEPTANCE   
Left Join GenDTab On (GenDTab.FLDID=ACCEPTANCE.FLDID AND GenDTab.ValueID=ACCEPTANCE.ValueID)  
Inner Join COVER on (Cover.CNO=Acceptance.CNO)  
Left Join ISource On (ISource.CNO=Cover.CNO)   
Left Join Profile PProfile On (PProfile.ID=ISource.ID)  
Left Join Profile on (Profile.ID=Acceptance.AID)  
WHERE ACCEPTANCE.ATYPE Not In ('A','C') AND ACCEPTANCE.AStatus not in ('W','T') and COVER.CStatus not in ('R','P','C')     
AND ACCEPTANCE.PDATE<ACCEPTANCE.PPDATE AND ACCEPTANCE.ANO<>ACCEPTANCE.LANO   
AND ACCEPTANCE.POLICYNO<>'' AND ACCEPTANCE.POLICYNO LIKE @P_POLICYNO AND ACCEPTANCE.CERTIFICATENO LIKE @P_CERTIFICATENO     
AND ACCEPTANCE.TOC LIKE @P_TOC+'%' AND ACCEPTANCE.REFNO LIKE @P_REFNO+'%'  
ORDER BY ACCEPTANCE.ANO DESC     

GO
IF EXISTS ( SELECT * FROM   sysobjects WHERE  id = object_id(N'[dbo].[QCLAIM_RATE]') and OBJECTPROPERTY(id, N'IsProcedure') = 1 )
BEGIN DROP PROCEDURE [QCLAIM_RATE] END 
GO
CREATE Procedure [dbo].[QCLAIM_RATE](@P_CNO integer, @P_CURRENCY varchar( 10))
as
SELECT Case When ReRate.CRate=0 Then ReRate.Rate Else ReRate.CRate end CRate, ReRate.CCYTo 
From Claim
Inner Join Acceptance on (Acceptance.ANO=Claim.ANO)
Inner Join Cover on (Cover.CNO=Acceptance.CNO) 
Left Join RArrHeader on (RArrHeader.ANO=Acceptance.ANO) 
Inner Join ReRate on ( 
ReRate.TOC=ACCEPTANCE.TOC 
and ReRate.RYear=coalesce(( 
	Select Top 1 R1.RYear 
	from Reinsurance R1, ReClass R2 
	Left Join RePolicy R3 on (R3.RNO=R2.RNO and R3.ID=Cover.PHolder) 
	Where (R1.Category<>'P' or Coalesce(R3.ID,'')<>'') and R1.RType='Q' and R2.RNO=R1.RNO and R2.TOC=ACCEPTANCE.TOC and RArrHeader.RDate Between R1.SDate and R1.EDate 
	Order By Case When R1.RID=RArrHeader.QID Then 1 else 0 end Desc, coalesce(R3.ID,'') Desc, (Case When R2.PriorityF=1 Then R2.PriorityF else R1.PriorityF end) Desc),Year(RArrHeader.RDate)) 
And ReRate.Currency=@P_Currency) 
WHERE Claim.CNO=@P_CNO

GO
IF EXISTS ( SELECT * FROM   sysobjects WHERE  id = object_id(N'[dbo].[QCOVER_TOC]') and OBJECTPROPERTY(id, N'IsProcedure') = 1 )
BEGIN DROP PROCEDURE [QCOVER_TOC] END 
GO
CREATE  Procedure [dbo].[QCOVER_TOC](@P_CNO integer)
as
SELECT TOC.*
FROM COVER, TOC
WHERE COVER.TOC=TOC.TOC AND COVER.CNO=@P_CNO

GO
IF EXISTS ( SELECT * FROM   sysobjects WHERE  id = object_id(N'[dbo].[QDEPOSIT_REINSURANCE_CESSION]') and OBJECTPROPERTY(id, N'IsProcedure') = 1 )
BEGIN DROP PROCEDURE [QDEPOSIT_REINSURANCE_CESSION] END 
GO
CREATE Procedure [dbo].[QDEPOSIT_REINSURANCE_CESSION] (@P_ANO integer, @P_RType varchar(255))     
AS                           
SELECT Top 1 Reinsurance.RID, Reinsurance.SHARE
From Acceptance       
Inner Join Cover on (Cover.CNO=Acceptance.CNO)      
Inner Join Reinsurance on (Reinsurance.RType='Q')      
Inner Join ReClass on (ReClass.RNO=Reinsurance.RNO and ReClass.TOC=ACCEPTANCE.TOC)      
Left Join RePolicy on (RePolicy.RNO=Reinsurance.RNO)      
WHERE ACCEPTANCE.ANO=@P_ANO
And Acceptance.SDate Between Reinsurance.SDate And Reinsurance.EDate       
And (coalesce(RePolicy.ID,'')='' or  coalesce(RePolicy.ID,'')=Cover.PHolder)    
Order By coalesce(RePolicy.ID,'') Desc, (Case When ReClass.PriorityF=1 Then ReClass.PriorityF else Reinsurance.PriorityF end) Desc                   
  
GO

IF EXISTS ( SELECT * FROM   sysobjects WHERE  id = object_id(N'[dbo].[QGET_ACTUAL_BUDGET]') and OBJECTPROPERTY(id, N'IsProcedure') = 1 )
BEGIN DROP PROCEDURE [QGET_ACTUAL_BUDGET] END 
GO
CREATE PROCEDURE [dbo].[QGET_ACTUAL_BUDGET](@P_FName  VARCHAR(2), @P_COB VARCHAR(10), @P_BRANCH VARCHAR(10), @P_CURRENCY VARCHAR(5), @P_AO VARCHAR(10), @P_Source Varchar(10), @P_SDATE smalldatetime, @P_EDATE smalldatetime) AS
IF @P_FName='NP'
 SELECT SUM(AMOUNT) AS AMOUNT  FROM TOC T1, COVER C1, ACCEPTANCE A1, GROSS_PREMIUM(@P_SDATE, @P_EDATE, @P_CURRENCY, @P_BRANCH) F1 WHERE A1.RENEWAL=0 AND A1.ANO=F1.ANO AND C1.CNO=A1.CNO AND T1.TOC=A1.TOC AND T1.COB=@P_COB AND C1.MO=@P_AO AND (A1.SOURCE=@P_SOURCE or @P_SOURCE='')
ELSE IF @P_FName='RP'
 SELECT SUM(AMOUNT) AS AMOUNT  FROM TOC T1, COVER C1, ACCEPTANCE A1, GROSS_PREMIUM(@P_SDATE, @P_EDATE, @P_CURRENCY, @P_BRANCH) F1 WHERE A1.RENEWAL<>0 AND A1.ANO=F1.ANO AND C1.CNO=A1.CNO AND T1.TOC=A1.TOC AND T1.COB=@P_COB AND C1.MO=@P_AO AND (A1.SOURCE=@P_SOURCE or @P_SOURCE='')
ELSE IF @P_FName='RI'
 SELECT SUM(AMOUNT) AS AMOUNT  FROM TOC T1, COVER C1, ACCEPTANCE A1, REINSURANCE_PREMIUM(@P_SDATE, @P_EDATE, @P_CURRENCY, @P_BRANCH) F1 WHERE A1.ANO=F1.ANO AND C1.CNO=A1.CNO AND T1.TOC=A1.TOC AND T1.COB=@P_COB AND C1.MO=@P_AO AND (A1.SOURCE=@P_SOURCE or @P_SOURCE='')
ELSE IF @P_FName='UP'
 SELECT SUM(AMOUNT) AS AMOUNT  FROM TOC T1, COVER C1, ACCEPTANCE A1, UNEARNED_PREMIUM(@P_SDATE, @P_EDATE, @P_CURRENCY, @P_BRANCH) F1 WHERE A1.ANO=F1.ANO AND C1.CNO=A1.CNO AND T1.TOC=A1.TOC AND T1.COB=@P_COB AND C1.MO=@P_AO AND (A1.SOURCE=@P_SOURCE or @P_SOURCE='')
ELSE IF @P_FName='CP'
 SELECT SUM(AMOUNT) AS AMOUNT  FROM TOC T1, COVER C1, ACCEPTANCE A1, COMMISSION_PAID(@P_SDATE, @P_EDATE, @P_CURRENCY, @P_BRANCH) F1 WHERE A1.ANO=F1.ANO AND C1.CNO=A1.CNO AND T1.TOC=A1.TOC AND T1.COB=@P_COB AND C1.MO=@P_AO AND (A1.SOURCE=@P_SOURCE or @P_SOURCE='')
ELSE IF @P_FName='CR'
 SELECT SUM(AMOUNT) AS AMOUNT  FROM TOC T1, COVER C1, ACCEPTANCE A1, COMMISSION_RECEIVED(@P_SDATE, @P_EDATE, @P_CURRENCY, @P_BRANCH) F1 WHERE A1.ANO=F1.ANO AND C1.CNO=A1.CNO AND T1.TOC=A1.TOC AND T1.COB=@P_COB AND C1.MO=@P_AO AND (A1.SOURCE=@P_SOURCE or @P_SOURCE='')
ELSE IF @P_FName='CA'
 SELECT SUM(AMOUNT) AS AMOUNT  FROM TOC T1, COVER C1, ACCEPTANCE A1, CLAIM_PAID(@P_SDATE, @P_EDATE, @P_CURRENCY, @P_BRANCH) F1 WHERE A1.ANO=F1.ANO AND C1.CNO=A1.CNO AND T1.TOC=A1.TOC AND T1.COB=@P_COB AND C1.MO=@P_AO AND (A1.SOURCE=@P_SOURCE or @P_SOURCE='')
ELSE IF @P_FName='RC'
 SELECT SUM(AMOUNT) AS AMOUNT  FROM TOC T1, COVER C1, ACCEPTANCE A1, CLAIM_RECEIVED(@P_SDATE, @P_EDATE, @P_CURRENCY, @P_BRANCH) F1 WHERE A1.ANO=F1.ANO AND C1.CNO=A1.CNO AND T1.TOC=A1.TOC AND T1.COB=@P_COB AND C1.MO=@P_AO AND (A1.SOURCE=@P_SOURCE or @P_SOURCE='')
ELSE IF @P_FName='OC'
 SELECT SUM(AMOUNT) AS AMOUNT  FROM TOC T1, COVER C1, ACCEPTANCE A1, OS_CLAIM(@P_SDATE, @P_EDATE, @P_CURRENCY, @P_BRANCH) F1 WHERE A1.ANO=F1.ANO AND C1.CNO=A1.CNO AND T1.TOC=A1.TOC AND T1.COB=@P_COB AND C1.MO=@P_AO AND (A1.SOURCE=@P_SOURCE or @P_SOURCE='')
 
GO

IF EXISTS ( SELECT * FROM   sysobjects WHERE  id = object_id(N'[dbo].[QGet_PHolder_LimitUsage]') and OBJECTPROPERTY(id, N'IsProcedure') = 1 )
BEGIN DROP PROCEDURE [QGet_PHolder_LimitUsage] END 
GO
CREATE Procedure [dbo].[QGet_PHolder_LimitUsage](@P_ANO as integer)
AS
Select PHolder.ID, PHolder.COB, PHolder.TSILimit, PHolder.TSILimitUsage, coalesce(TSI_Current.TSILimitUsage,0)-coalesce(TSI_Previous.TSILimitUsage,0) as LimitUsage
From 
	PHolder
	Inner join
    (
    Select Cover.PHolder, TOC.COB, sum(Case When Acceptance.AType<>'C' Then Pcalc.OurShare*PCalc.Rate else 0 end) as TSILimitUsage
    From PCalc, Acceptance, Cover, TOC
    Where Acceptance.ANO=@P_ANO and PCalc.ANO=Acceptance.ANO and Cover.CNO=Acceptance.CNO and TOC.TOC=Acceptance.TOC and Acceptance.AType in ('N','E','C')        
    Group by Cover.PHolder, TOC.COB
    ) TSI_Current on (PHolder.ID=TSI_Current.PHolder and PHolder.COB=TSI_Current.COB)
    Left Join
    (
    Select Cover.PHolder, TOC.COB, sum(Case When pAcceptance.AType<>'C' Then Pcalc.OurShare*PCalc.Rate else 0 end) as TSILimitUsage
    From PCalc, Acceptance pAcceptance, Acceptance, Cover, TOC
    Where Acceptance.ANO=@P_ANO and pAcceptance.ANO=Acceptance.pANO and PCalc.ANO=pAcceptance.ANO and Cover.CNO=pAcceptance.CNO and TOC.TOC=Acceptance.TOC and pAcceptance.AType in ('N','E','C')        
    Group by Cover.PHolder, TOC.COB
    ) TSI_Previous on (TSI_Current.PHolder=TSI_Previous.PHolder and TSI_Current.COB=TSI_Previous.COB)
    

GO

IF EXISTS ( SELECT * FROM   sysobjects WHERE  id = object_id(N'[dbo].[QGET_UNDERWRITING_PROFILE_BY_BS]') and OBJECTPROPERTY(id, N'IsProcedure') = 1 )
BEGIN DROP PROCEDURE [QGET_UNDERWRITING_PROFILE_BY_BS] END 
GO
CREATE PROCEDURE [dbo].[QGET_UNDERWRITING_PROFILE_BY_BS](@P_FName  VARCHAR(2), @P_ID VARCHAR(10), @P_BRANCH VARCHAR(10), @P_CURRENCY VARCHAR(5), @P_SDATE smalldatetime, @P_EDATE smalldatetime) AS 
IF @P_FName='NP'  -- Gross Premium from New Business 
SELECT SUM(AMOUNT) AS AMOUNT  FROM TOC T1, COVER C1, ACCEPTANCE A1, GROSS_PREMIUM(@P_SDATE, @P_EDATE, @P_CURRENCY, @P_BRANCH) F1 WHERE A1.RENEWAL=0 AND A1.ANO=F1.ANO AND C1.CNO=A1.CNO AND T1.TOC=A1.TOC AND A1.SOURCE=@P_ID 
ELSE IF @P_FName='RP' -- Gross Premium for Renewal Business 
SELECT SUM(AMOUNT) AS AMOUNT  FROM TOC T1, COVER C1, ACCEPTANCE A1, GROSS_PREMIUM(@P_SDATE, @P_EDATE, @P_CURRENCY, @P_BRANCH) F1 WHERE A1.RENEWAL<>0 AND A1.ANO=F1.ANO AND C1.CNO=A1.CNO AND T1.TOC=A1.TOC AND A1.SOURCE=@P_ID 
ELSE IF @P_FName='RI' 
SELECT SUM(AMOUNT) AS AMOUNT  FROM TOC T1, COVER C1, ACCEPTANCE A1, REINSURANCE_PREMIUM(@P_SDATE, @P_EDATE, @P_CURRENCY, @P_BRANCH) F1 WHERE A1.ANO=F1.ANO AND C1.CNO=A1.CNO AND T1.TOC=A1.TOC AND A1.SOURCE=@P_ID 
ELSE IF @P_FName='UP' 
SELECT SUM(AMOUNT) AS AMOUNT  FROM TOC T1, COVER C1, ACCEPTANCE A1, UNEARNED_PREMIUM(@P_SDATE, @P_EDATE, @P_CURRENCY, @P_BRANCH) F1 WHERE A1.ANO=F1.ANO AND C1.CNO=A1.CNO AND T1.TOC=A1.TOC AND A1.SOURCE=@P_ID 
ELSE IF @P_FName='CP' 
SELECT SUM(AMOUNT) AS AMOUNT  FROM TOC T1, COVER C1, ACCEPTANCE A1, COMMISSION_PAID(@P_SDATE, @P_EDATE, @P_CURRENCY, @P_BRANCH) F1 WHERE A1.ANO=F1.ANO AND C1.CNO=A1.CNO AND T1.TOC=A1.TOC AND A1.SOURCE=@P_ID 
ELSE IF @P_FName='CR' 
SELECT SUM(AMOUNT) AS AMOUNT  FROM TOC T1, COVER C1, ACCEPTANCE A1, COMMISSION_RECEIVED(@P_SDATE, @P_EDATE, @P_CURRENCY, @P_BRANCH) F1 WHERE A1.ANO=F1.ANO AND C1.CNO=A1.CNO AND T1.TOC=A1.TOC AND A1.SOURCE=@P_ID 
ELSE IF @P_FName='CA' 
SELECT SUM(AMOUNT) AS AMOUNT  FROM TOC T1, COVER C1, ACCEPTANCE A1, CLAIM_PAID(@P_SDATE, @P_EDATE, @P_CURRENCY, @P_BRANCH) F1 WHERE A1.ANO=F1.ANO AND C1.CNO=A1.CNO AND T1.TOC=A1.TOC AND A1.SOURCE=@P_ID 
ELSE IF @P_FName='RC' 
SELECT SUM(AMOUNT) AS AMOUNT  FROM TOC T1, COVER C1, ACCEPTANCE A1, CLAIM_RECEIVED(@P_SDATE, @P_EDATE, @P_CURRENCY, @P_BRANCH) F1 WHERE A1.ANO=F1.ANO AND C1.CNO=A1.CNO AND T1.TOC=A1.TOC AND A1.SOURCE=@P_ID 
ELSE IF @P_FName='OC' 
SELECT SUM(AMOUNT) AS AMOUNT  FROM TOC T1, COVER C1, ACCEPTANCE A1, OS_CLAIM(@P_SDATE, @P_EDATE, @P_CURRENCY, @P_BRANCH) F1 WHERE A1.ANO=F1.ANO AND C1.CNO=A1.CNO AND T1.TOC=A1.TOC AND A1.SOURCE=@P_ID 

GO

IF EXISTS ( SELECT * FROM   sysobjects WHERE  id = object_id(N'[dbo].[QGET_UNDERWRITING_PROFILE_BY_INSURED]') and OBJECTPROPERTY(id, N'IsProcedure') = 1 )
BEGIN DROP PROCEDURE [QGET_UNDERWRITING_PROFILE_BY_INSURED] END 
GO
CREATE PROCEDURE [dbo].[QGET_UNDERWRITING_PROFILE_BY_INSURED](@P_FName  VARCHAR(2), @P_Pholder VARCHAR(10), @P_BRANCH VARCHAR(10), @P_CURRENCY VARCHAR(5), @P_SDATE smalldatetime, @P_EDATE smalldatetime) AS
IF @P_FName='NP'  -- Gross Premium from New Business
	SELECT SUM(AMOUNT) AS AMOUNT  FROM TOC T1, COVER C1, ACCEPTANCE A1, GROSS_PREMIUM(@P_SDATE, @P_EDATE, @P_CURRENCY, @P_BRANCH) F1 WHERE A1.RENEWAL=0 AND A1.ANO=F1.ANO AND C1.CNO=A1.CNO AND T1.TOC=A1.TOC AND C1.PHOLDER=@P_PHOLDER
ELSE IF @P_FName='RP' -- Gross Premium for Renewal Business
	SELECT SUM(AMOUNT) AS AMOUNT  FROM TOC T1, COVER C1, ACCEPTANCE A1, GROSS_PREMIUM(@P_SDATE, @P_EDATE, @P_CURRENCY, @P_BRANCH) F1 WHERE A1.RENEWAL<>0 AND A1.ANO=F1.ANO AND C1.CNO=A1.CNO AND T1.TOC=A1.TOC AND C1.PHOLDER=@P_PHOLDER
ELSE IF @P_FName='RI'
	SELECT SUM(AMOUNT) AS AMOUNT  FROM TOC T1, COVER C1, ACCEPTANCE A1, REINSURANCE_PREMIUM(@P_SDATE, @P_EDATE, @P_CURRENCY, @P_BRANCH) F1 WHERE A1.ANO=F1.ANO AND C1.CNO=A1.CNO AND T1.TOC=A1.TOC AND C1.PHOLDER=@P_PHOLDER
ELSE IF @P_FName='UP'
	SELECT SUM(AMOUNT) AS AMOUNT  FROM TOC T1, COVER C1, ACCEPTANCE A1, UNEARNED_PREMIUM(@P_SDATE, @P_EDATE, @P_CURRENCY, @P_BRANCH) F1 WHERE A1.ANO=F1.ANO AND C1.CNO=A1.CNO AND T1.TOC=A1.TOC AND C1.PHOLDER=@P_PHOLDER
ELSE IF @P_FName='CP'
	SELECT SUM(AMOUNT) AS AMOUNT  FROM TOC T1, COVER C1, ACCEPTANCE A1, COMMISSION_PAID(@P_SDATE, @P_EDATE, @P_CURRENCY, @P_BRANCH) F1 WHERE A1.ANO=F1.ANO AND C1.CNO=A1.CNO AND T1.TOC=A1.TOC AND C1.PHOLDER=@P_PHOLDER
ELSE IF @P_FName='CR'
	SELECT SUM(AMOUNT) AS AMOUNT  FROM TOC T1, COVER C1, ACCEPTANCE A1, COMMISSION_RECEIVED(@P_SDATE, @P_EDATE, @P_CURRENCY, @P_BRANCH) F1 WHERE A1.ANO=F1.ANO AND C1.CNO=A1.CNO AND T1.TOC=A1.TOC AND C1.PHOLDER=@P_PHOLDER
ELSE IF @P_FName='CA'
	SELECT SUM(AMOUNT) AS AMOUNT  FROM TOC T1, COVER C1, ACCEPTANCE A1, CLAIM_PAID(@P_SDATE, @P_EDATE, @P_CURRENCY, @P_BRANCH) F1 WHERE A1.ANO=F1.ANO AND C1.CNO=A1.CNO AND T1.TOC=A1.TOC AND C1.PHOLDER=@P_PHOLDER
ELSE IF @P_FName='RC'
	SELECT SUM(AMOUNT) AS AMOUNT  FROM TOC T1, COVER C1, ACCEPTANCE A1, CLAIM_RECEIVED(@P_SDATE, @P_EDATE, @P_CURRENCY, @P_BRANCH) F1 WHERE A1.ANO=F1.ANO AND C1.CNO=A1.CNO AND T1.TOC=A1.TOC AND C1.PHOLDER=@P_PHOLDER
ELSE IF @P_FName='OC'
	SELECT SUM(AMOUNT) AS AMOUNT  FROM TOC T1, COVER C1, ACCEPTANCE A1, OS_CLAIM(@P_SDATE, @P_EDATE, @P_CURRENCY, @P_BRANCH) F1 WHERE A1.ANO=F1.ANO AND C1.CNO=A1.CNO AND T1.TOC=A1.TOC AND C1.PHOLDER=@P_PHOLDER

GO

IF EXISTS ( SELECT * FROM   sysobjects WHERE  id = object_id(N'[dbo].[QGET_UNDERWRITING_PROFILE_BY_POLICY]') and OBJECTPROPERTY(id, N'IsProcedure') = 1 )
BEGIN DROP PROCEDURE [QGET_UNDERWRITING_PROFILE_BY_POLICY] END 
GO
CREATE PROCEDURE [dbo].[QGET_UNDERWRITING_PROFILE_BY_POLICY](@P_FName  VARCHAR(2), @P_OANO int, @P_BRANCH VARCHAR(10), @P_CURRENCY VARCHAR(5), @P_SDATE smalldatetime, @P_EDATE smalldatetime) AS  
IF @P_FName='NP'  -- Gross Premium from New Business  
 SELECT SUM(AMOUNT) AS AMOUNT  FROM TOC T1, COVER C1, ACCEPTANCE A1, GROSS_PREMIUM(@P_SDATE, @P_EDATE, @P_CURRENCY, @P_BRANCH) F1 WHERE A1.RENEWAL=0 AND A1.ANO=F1.ANO AND C1.CNO=A1.CNO AND T1.TOC=A1.TOC AND A1.OANO=@P_OANO  
ELSE IF @P_FName='RP' -- Gross Premium for Renewal Business  
 SELECT SUM(AMOUNT) AS AMOUNT  FROM TOC T1, COVER C1, ACCEPTANCE A1, GROSS_PREMIUM(@P_SDATE, @P_EDATE, @P_CURRENCY, @P_BRANCH) F1 WHERE A1.RENEWAL<>0 AND A1.ANO=F1.ANO AND C1.CNO=A1.CNO AND T1.TOC=A1.TOC AND A1.OANO=@P_OANO  
ELSE IF @P_FName='RI'  
 SELECT SUM(AMOUNT) AS AMOUNT  FROM TOC T1, COVER C1, ACCEPTANCE A1, REINSURANCE_PREMIUM(@P_SDATE, @P_EDATE, @P_CURRENCY, @P_BRANCH) F1 WHERE A1.ANO=F1.ANO AND C1.CNO=A1.CNO AND T1.TOC=A1.TOC AND A1.OANO=@P_OANO  
ELSE IF @P_FName='UP'  
 SELECT SUM(AMOUNT) AS AMOUNT  FROM TOC T1, COVER C1, ACCEPTANCE A1, UNEARNED_PREMIUM(@P_SDATE, @P_EDATE, @P_CURRENCY, @P_BRANCH) F1 WHERE A1.ANO=F1.ANO AND C1.CNO=A1.CNO AND T1.TOC=A1.TOC AND A1.OANO=@P_OANO  
ELSE IF @P_FName='CP'  
 SELECT SUM(AMOUNT) AS AMOUNT  FROM TOC T1, COVER C1, ACCEPTANCE A1, COMMISSION_PAID(@P_SDATE, @P_EDATE, @P_CURRENCY, @P_BRANCH) F1 WHERE A1.ANO=F1.ANO AND C1.CNO=A1.CNO AND T1.TOC=A1.TOC AND A1.OANO=@P_OANO  
ELSE IF @P_FName='CR'  
 SELECT SUM(AMOUNT) AS AMOUNT  FROM TOC T1, COVER C1, ACCEPTANCE A1, COMMISSION_RECEIVED(@P_SDATE, @P_EDATE, @P_CURRENCY, @P_BRANCH) F1 WHERE A1.ANO=F1.ANO AND C1.CNO=A1.CNO AND T1.TOC=A1.TOC AND A1.OANO=@P_OANO  
ELSE IF @P_FName='CA'  
 SELECT SUM(AMOUNT) AS AMOUNT  FROM TOC T1, COVER C1, ACCEPTANCE A1, CLAIM_PAID(@P_SDATE, @P_EDATE, @P_CURRENCY, @P_BRANCH) F1 WHERE A1.ANO=F1.ANO AND C1.CNO=A1.CNO AND T1.TOC=A1.TOC AND A1.OANO=@P_OANO  
ELSE IF @P_FName='RC'  
 SELECT SUM(AMOUNT) AS AMOUNT  FROM TOC T1, COVER C1, ACCEPTANCE A1, CLAIM_RECEIVED(@P_SDATE, @P_EDATE, @P_CURRENCY, @P_BRANCH) F1 WHERE A1.ANO=F1.ANO AND C1.CNO=A1.CNO AND T1.TOC=A1.TOC AND A1.OANO=@P_OANO  
ELSE IF @P_FName='OC'  
 SELECT SUM(AMOUNT) AS AMOUNT  FROM TOC T1, COVER C1, ACCEPTANCE A1, OS_CLAIM(@P_SDATE, @P_EDATE, @P_CURRENCY, @P_BRANCH) F1 WHERE A1.ANO=F1.ANO AND C1.CNO=A1.CNO AND T1.TOC=A1.TOC AND A1.OANO=@P_OANO  
  
GO

IF EXISTS ( SELECT * FROM   sysobjects WHERE  id = object_id(N'[dbo].[QGetPreCedeFacCessionAmount]') and OBJECTPROPERTY(id, N'IsProcedure') = 1 )
BEGIN DROP PROCEDURE [QGetPreCedeFacCessionAmount] END 
GO
CREATE Procedure [dbo].[QGetPreCedeFacCessionAmount](@P_ANO integer)     
as     
Select sum(
Case 
When RArrDet.Amount<>0 Then RArrDet.Amount
When RArrDet.Limit<>0 Then RArrDet.Share/100*RArrDet.Limit
When RArrHeader.TAmount<>0 then RArrDet.Share/100*RArrHeader.TAmount
else RArrDet.Share/100*P.OurShare/P.NUMRISK
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

IF EXISTS ( SELECT * FROM   sysobjects WHERE  id = object_id(N'[dbo].[qInwardTreaty_Data]') and OBJECTPROPERTY(id, N'IsProcedure') = 1 )
BEGIN DROP PROCEDURE [qInwardTreaty_Data] END 
GO
CREATE Procedure [dbo].[qInwardTreaty_Data](@P_ANO integer)            
as            
Select A1.CNO, A1.ANO, A1.RegNo, A1.Branch, A1.CT, A1.NCDate, C.CoverDate, C.Insured, C.ExpDate, A1.TOC, C.RefNo, C.RefDate, C.MO, R.Code, I.RType, I.ID, I.Share, I.Fee as RIComm, I.UJROHCEDANT, I.UJROHREINS,    
A1.CDate,    
A1.UserID,     
A1.LDate,    
A1.LUserID,    
A1.AUserID,    
A1.AUserDate,
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
A2.FLDID15, A2.VALUEID15, A2.VALUEDESC15, 0 as FLDSEARCH15,
A3.ID as BSID, A3.Fee as BSFee, A4.ID as OtherID, A4.Fee as OtherFee
from Cover C    
Inner Join Acceptance A1 on (C.CNO=A1.CNO)    
Left Join AINFO A2 On (A2.ANO=A1.ANO) 
Left join ISource I on (I.CNO=C.CNO)    
Left Join RCover R On (R.ANO=A1.ANO)    
Left Join AccBS A3 on (A3.ANO=A1.ANO and A3.BSType='B')    
Left Join AccBS A4 on (A4.ANO=A1.ANO and A4.BSType='O')    
Where A1.ANO=@P_ANO    

GO

IF EXISTS ( SELECT * FROM   sysobjects WHERE  id = object_id(N'[dbo].[QMasterAcceptance]') and OBJECTPROPERTY(id, N'IsProcedure') = 1 )
BEGIN DROP PROCEDURE [QMasterAcceptance] END 
GO
CREATE PROCEDURE [dbo].[QMasterAcceptance] (@P_ANO as integer)        
AS        
SELECT Acceptance.PolicyNo, Acceptance.CertificateNo, Acceptance.Branch, Acceptance.REGNO, Acceptance.ADATE, Acceptance.SDate, Acceptance.EDate, Acceptance.UserID, Acceptance.LUSERID, SysTab.Currency AS CCY, QPCalc.TSI,        
QPCalc.OurShare, QPCalc.Amount, QPCalc.Gross, QPCalc.Premium,  QPCalc.RYear, Acceptance.ATYPE, Acceptance.ASTATUS, Acceptance.LANO, Acceptance.ANO, Acceptance.CNO,        
Cover.ASource, Cover.PPeriod, Cover.CSTATUS, Cover.CoverNoteF, Cover.Voyage, Cover.OpenFlag, Acceptance.AdjustableF, Acceptance.RenewableF, Cover.ISType, Cover.PolicyType, Acceptance.TOC, Cover.MO, Acceptance.BANO,  Acceptance.RANO, Acceptance.RequestF, Acceptance.RequestName,  
ACCCOMPSHEETH.CID, acceptance.CANO , acceptance.ConjunctionF, pAcceptance.AType as pAType        
FROM Acceptance Left Join Acceptance pAcceptance on (pAcceptance.ANO=Acceptance.pANO) Left Join ACCCOMPSHEETH on (ACCCOMPSHEETH.ANO=Acceptance.OANO), FN_PCalc(@P_ANO) AS QPCalc, SysTab, Cover        
WHERE Acceptance.ANO=@P_ANO And Acceptance.CNO=Cover.CNO And QPCalc.ANO=Acceptance.ANO        

GO

IF EXISTS ( SELECT * FROM   sysobjects WHERE  id = object_id(N'[dbo].[qPolicy_Data]') and OBJECTPROPERTY(id, N'IsProcedure') = 1 )
BEGIN DROP PROCEDURE [qPolicy_Data] END 
GO
CREATE Procedure [dbo].[qPolicy_Data](@P_ANO integer)                                    
as                                    
SELECT                                    
C.CNO, C.COVERNO, A1.TOC, C.MO, C.SEGMENT, A1.Location, C.VALIDATION, C.REFNO as CREFNO, C.PRORATA, C.PHOLDER, C.PPERIOD, C.CStatus,                                    
A1.ASource, P.ID as PayorID, C.ISType, C.OpenFlag, C.Voyage, C.PolicyType, C.VSeqNo, C.TBAF,          
A1.ANO, A1.OANO, A1.LANO, A1.CANO, A1.PANO, A1.RANO, A1.REGNO, A1.REGDATE, A1.BRANCH, A1.CT, A1.AStatus, A1.ATYPE, A1.POLICYNO, A1.POLICYDATE, A1.CPOLICYNO, A1.REFNO, A1.REFDATE, A1.RENEWABLEF, A1.CONJUNCTIONF, A1.EXCLUSIVEF, 
A1.SDATE, A1.EDATE, A1.STIME, A1.ETIME,         
          
A1.REMARKS, A1.EXTPERIOD, A1.ExtPeriodInDaysF, A1.ADATE, A1.PDATE, A1.PPDATE, A1.AID, A1.ANAME, A1.BUSINESS, A1.TOPRO, A1.Ujroh, A1.WeightedAvgUjrohF,                           
A1.ESeqNo, A1.EESeqNo, A1.Renewal, A1.BatchNo, A1.BankersClause,               
C.PUserID, C.PUserDate, C.PUserTime,                           
C.AUSERID as CAUserID, C.AUserDate as CAUserDate, C.AUserTime as CAUserTime,                        
C.CUSERID as CCUserID, C.CLOSEDATE as CCLOSEDATE, C.CloseTime as CCloseTime,    
A1.UserID, A1.CDate, A1.CTime,                                   
A1.CUserID, A1.CloseDate, A1.CloseTime,                             
A1.LUSERID, A1.LDate, A1.LTime,     
A1.AUSERID, A1.AUserDate, A1.AUserTime,                             
CCOVER.COVERNO AS CCOVERNO,                           
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
FROM COVER C                        
INNER JOIN ACCEPTANCE A1 ON (C.CNO=A1.CNO)                         
INNER JOIN PAYOR P on (P.ANO=A1.ANO)
LEFT JOIN ACCEPTANCE CACCEPTANCE ON (CACCEPTANCE.ANO=A1.CANO)                        
LEFT JOIN COVER CCOVER ON (CCOVER.CNO=CACCEPTANCE.CNO)                        
Left Join AINFO A2 On (A2.ANO=A1.ANO)                         
Left Join FN_SumInsured(@P_ANO) Interest On (Interest.ANO=A1.ANO and Interest.TSI<>0)                              
WHERE A1.ANO=@P_ANO 

GO

IF EXISTS ( SELECT * FROM   sysobjects WHERE  id = object_id(N'[dbo].[QPolicy_Rate]') and OBJECTPROPERTY(id, N'IsProcedure') = 1 )
BEGIN DROP PROCEDURE [QPolicy_Rate] END 
GO
CREATE Procedure [dbo].[QPolicy_Rate](@P_ANO as int)     
as     
Select ICALC.Code, ICALC.SDate, SUM(ICALC.TSI) as TSI, Max(ICALC.PrevMinRate) as PrevMinRate, Max(ICALC.PrevMaxRate) as PrevMaxRate, Max(ICALC.MinRate) as MinRate, Max(ICALC.MaxRate) as MaxRate     
from     
(     
Select ICALC.Code, ICALC.SDate,     
MAX((Case When ICover.Category='M' then ICALC.TSI else 0 end)*(CASE WHEN RCOVER.PCTLOSS=0 THEN 100 ELSE RCOVER.PCTLOSS END)/(CASE WHEN RCOVER.PCTLOSS=0 THEN 100 ELSE RCOVER.PCTLOSS END+RCOVER.PAddition)) as TSI,     
CAST(0 as FLOAT) as PREVMINRATE,     
CAST(0 as FLOAT) as PREVMAXRATE,     
ROUND(SUM(ICALC.GROSS*100/(100-RCover.Discount)/ICALC.TSI/(Case When RCOVER.LOADING=0 THEN 1 ELSE RCOVER.LOADING END)*Case When ICalc.PCTADJ<>0 Then cast(100 as Float)/ICALC.PCTADJ else 1 end*Case When ICALC.Prorata=1 then (Case When Day(ICALC.SDate)<>Day(ICALC.EDate) then cast(Cover.Prorata as Float)/datediff(day,ICALC.SDate, ICALC.EDate) else cast(case When TOC.PTerm=0 Then 12 else TOC.PTerm end as Float)/datediff(Month, ICALC.SDate, ICALC.EDate) end) else (Case When RCover.PCalc='P' and Cover.Voyage=0 then Case When day(ICalc.SDate)<>day(ICalc.EDate) or Cover.PPeriod=1 then cast(Cover.Prorata as Float)/datediff(day,ICalc.SDate, ICalc.EDate) else cast(case When TOC.PTerm=0 Then 12 else TOC.PTerm end as Float)/datediff(month,ICalc.SDate, ICalc.EDate) end else 1/ICALC.Prorata end) end)*100,13) as MINRATE,     
ROUND(SUM(ICALC.GROSS*100/(100-RCover.Discount)/ICALC.TSI/(Case When RCOVER.LOADING=0 THEN 1 ELSE RCOVER.LOADING END)*Case When ICalc.PCTADJ<>0 Then cast(100 as Float)/ICALC.PCTADJ else 1 end*Case When ICALC.Prorata=1 then (Case When Day(ICALC.SDate)<>Day(ICALC.EDate) then cast(Cover.Prorata as Float)/datediff(day,ICALC.SDate, ICALC.EDate) else cast(case When TOC.PTerm=0 Then 12 else TOC.PTerm end as Float)/datediff(Month, ICALC.SDate, ICALC.EDate) end) else (Case When RCover.PCalc='P' and Cover.Voyage=0 then Case When day(ICalc.SDate)<>day(ICalc.EDate) or Cover.PPeriod=1 then cast(Cover.Prorata as Float)/datediff(day,ICalc.SDate, ICalc.EDate) else cast(case When TOC.PTerm=0 Then 12 else TOC.PTerm end as Float)/datediff(month,ICalc.SDate, ICalc.EDate) end else 1/ICALC.Prorata end) end)*100,13) as MAXRATE     
from COVER, ACCEPTANCE, ICover, ICALC, RCover, TOC
Where ACCEPTANCE.ANO=@P_ANO and COVER.CNO=ACCEPTANCE.CNO and COVER.ISType in ('I','C','L') and RCover.ANO=Acceptance.ANO     
and RCover.ANO=ICALC.ANO and RCover.Code=ICALC.Code and RCover.SDate=ICALC.SDate and RCover.EDate=ICALC.EDate and datediff(month, ICALC.SDate, ICALC.EDate)<>0     
and ICover.INO=ICalc.INO and ICALC.TSI<>0     
and TOC.TOC=ACCEPTANCE.TOC
Group By ICalc.INO, ICALC.Code, ICALC.SDate     
     
Union All     
     
Select ICALC.Code, ICALC.SDate,     
0 as TSI,     
ROUND(SUM(ICALC.GROSS*100/(100-RCover.Discount)/ICALC.TSI/(Case When RCOVER.LOADING=0 THEN 1 ELSE RCOVER.LOADING END)*Case When ICalc.PCTADJ<>0 Then cast(100 as Float)/ICALC.PCTADJ else 1 end*Case When ICALC.Prorata=1 then (Case When Day(ICALC.SDate)<>Day(ICALC.EDate) then cast(Cover.Prorata as Float)/datediff(day,ICALC.SDate, ICALC.EDate) else cast(case When TOC.PTerm=0 Then 12 else TOC.PTerm end as Float)/datediff(Month, ICALC.SDate, ICALC.EDate) end) else (Case When RCover.PCalc='P' and Cover.Voyage=0 then Case When day(ICalc.SDate)<>day(ICalc.EDate) or Cover.PPeriod=1 then cast(Cover.Prorata as Float)/datediff(day,ICalc.SDate, ICalc.EDate) else cast(case When TOC.PTerm=0 Then 12 else TOC.PTerm end as Float)/datediff(month,ICalc.SDate, ICalc.EDate) end else 1/ICALC.Prorata end) end)*100,13) as PREVMINRATE,     
ROUND(SUM(ICALC.GROSS*100/(100-RCover.Discount)/ICALC.TSI/(Case When RCOVER.LOADING=0 THEN 1 ELSE RCOVER.LOADING END)*Case When ICalc.PCTADJ<>0 Then cast(100 as Float)/ICALC.PCTADJ else 1 end*Case When ICALC.Prorata=1 then (Case When Day(ICALC.SDate)<>Day(ICALC.EDate) then cast(Cover.Prorata as Float)/datediff(day,ICALC.SDate, ICALC.EDate) else cast(case When TOC.PTerm=0 Then 12 else TOC.PTerm end as Float)/datediff(Month, ICALC.SDate, ICALC.EDate) end) else (Case When RCover.PCalc='P' and Cover.Voyage=0 then Case When day(ICalc.SDate)<>day(ICalc.EDate) or Cover.PPeriod=1 then cast(Cover.Prorata as Float)/datediff(day,ICalc.SDate, ICalc.EDate) else cast(case When TOC.PTerm=0 Then 12 else TOC.PTerm end as Float)/datediff(month,ICalc.SDate, ICalc.EDate) end else 1/ICALC.Prorata end) end)*100,13) as PREVMAXRATE,     
CAST(0 as FLOAT) as MINRATE,     
CAST(0 as FLOAT) as MAXRATE     
from COVER, ACCEPTANCE, ACCEPTANCE PACCEPTANCE, ICover, ICALC, RCover, TOC
Where ACCEPTANCE.ANO=@P_ANO and COVER.CNO=ACCEPTANCE.CNO and COVER.ISType in ('I','C','L') and PACCEPTANCE.ANO=ACCEPTANCE.PANO and RCOVER.ANO=PACCEPTANCE.ANO     
and RCover.ANO=ICALC.ANO and RCover.Code=ICALC.Code and RCover.SDate=ICALC.SDate and RCover.EDate=ICALC.EDate and datediff(month, ICALC.SDate, ICALC.EDate)<>0     
and ICover.INO=ICalc.INO and ICALC.TSI<>0     
and TOC.TOC=ACCEPTANCE.TOC
Group By ICalc.INO, ICALC.Code, ICALC.SDate     
) ICALC     
Group By ICALC.Code, ICALC.SDate     
Having SUM(ICALC.TSI)<>0     
     
GO

IF EXISTS ( SELECT * FROM   sysobjects WHERE  id = object_id(N'[dbo].[QRateCode]') and OBJECTPROPERTY(id, N'IsProcedure') = 1 )
BEGIN DROP PROCEDURE [QRateCode] END 
GO
CREATE PROCEDURE [dbo].[QRateCode] (@P_ANO as integer, @P_Code as varchar(20),@P_AllowedF as bit=0, @P_TSI as float=0)              
AS              
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
Inner join RateTab on ((RateTab.TOC=substring(Acceptance.TOC,1,len(RateTab.TOC))) and (@P_Code='%' or RateTab.Code Like @P_Code OR RateTab.Description Like @P_Code) And (RateTab.AllowedF=@P_AllowedF or @P_AllowedF=0))            
Where Acceptance.ANO=@P_ANO  
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
Inner join RateTab on ((RateTab.TOC=substring(Acceptance.TOC,1,len(RateTab.TOC))) and (@P_Code='%' or RateTab.Code Like @P_Code OR RateTab.Description Like @P_Code) And (RateTab.AllowedF=@P_AllowedF or @P_AllowedF=0))            
Inner join RateCov on (RateCov.Code=RateTab.Code)          
Inner join RClass on (RClass.TOC=Acceptance.TOC And RClass.TOR=RateCov.TOR)          
Left Join @Temp F on (F.Code=RateTab.Code)          
WHERE  Acceptance.ANO=@P_ANO and coalesce(F.AllowedF,1)=1  
GROUP BY RateTab.Code, RateTab.AllowedF, RateTab.NoRefundF  , RateTab.SIBasedID  

GO

IF EXISTS ( SELECT * FROM   sysobjects WHERE  id = object_id(N'[dbo].[QRCESSIONDET]') and OBJECTPROPERTY(id, N'IsProcedure') = 1 )
BEGIN DROP PROCEDURE [QRCESSIONDET] END 
GO
CREATE Procedure [dbo].[QRCESSIONDET] (@P_ANO integer,@P_RID varchar(255), @P_ID varchar(255), @P_CCY varchar(255), @P_SDate DateTime, @P_EDate DateTime, @P_Code varchar(10), @P_AdjustableF bit,@P_TSI as Float=0, @P_ASDate as DateTime=0)              
AS          
Declare @Premium_Treaty_Discount as Float          
Declare @Premium_Discount as Float          
Declare @Premium_Commission as Float          
Declare @Premium_OutGo as Float          
Declare @P_TOC as varchar(10)  
Declare @P_AType as varchar(1)  
Declare @P_ONGROSSNet as int  
Declare @P_RateConF as Bit  
Declare @P_NETRATE as Float  
Declare @P_NETRATEDet as Float  
Declare @P_NOFYEARS as Int  
Declare @P_COMM as Float  
Declare @P_COMMN as Float  
Declare @P_COMMI as Float  
Declare @P_OnMinPremiumF as Bit  
Declare @P_PPCT as Float  
Declare @P_OnNetPremiumF as Bit  
Declare @P_RNO as int  
Declare @P_RType as varchar(10)  
Declare @P_OPFEE as Float  
Declare @P_OPFEEPCT as Float  
Declare @P_FEE as Float  
Declare @P_OANO as int  
Declare @P_COMMPOLICYF as Bit  
Declare @P_PFactor as Float

Select   
@P_ASDate=Case When @P_ASDate=0 Then A.SDate else @P_ASDate end,  
@P_NOFYEARS=datediff(year,A.sdate, A.edate),   
@P_TOC=A.TOC,   
@P_AType=A.AType,   
@P_ONGROSSNET=R.ONGROSSNET,   
@P_RateConF=R3.RateConF,   
@P_NETRATE=R2.NETRATE,  
@P_NETRATEDet=R4.NETRATE,  
@P_COMM=CASE WHEN R3.COMM<>0 Then R3.COMM ELSE R2.COMM END,  
@P_COMMN=CASE WHEN R3.COMMN<>0 Then R3.COMMN ELSE R2.COMMN END,  
@P_COMMI=R2.COMMI,  
@P_OnMinPremiumF=R2.OnMinPremiumF,  
@P_PPCT=R2.PPCT,  
@P_OnNetPremiumF=R2.OnNetPremiumF,   
@P_RNO=R1.RNO,  
@P_RType=R1.RType,  
@P_OANO=A.OANO,  
@P_FEE=R2.FEE,  
@P_COMMPOLICYF=R2.COMMPOLICYF,
@P_PFactor=Case When C.ISType='R' Then (100-I.UJrohCedant)/100*(100+I.UjrohReins)/100 else 1 end  
from Acceptance A, RarrHeader R, Cover C Left Join ISource I on (I.CNO=C.CNO), Reinsurance R1, RPart R2, ReClass R3 Left Join ReClassDet R4 ON (R4.RNO=R3.RNO AND R4.TOC=R3.TOC AND R4.CODE=@P_CODE)  
Where C.CNO=A.CNO and R.ANO=A.ANO and A.ANO=@P_ANO and R1.RID=@P_RID and R2.RNO=R1.RNO and R3.RNO=R1.RNO and R2.ID=@P_ID and R3.TOC=A.TOC  

Select @Premium_Treaty_Discount=dbo.Premium_Treaty_Discount(@P_ANO, @P_Code,cast(datediff(Month,@P_ASDate, @P_SDate) as integer) / 12 + 1)          
Select @Premium_Discount=dbo.premium_discount(@P_ANO, @P_Code, cast(datediff(Month,@P_ASDate, @P_SDate) as integer) / 12 + 1)  
Select @Premium_Commission=dbo.Premium_Commission(@P_ANO, @P_Code, cast(datediff(Month,@P_ASDate, @P_SDate) as integer) / 12 + 1,0)+dbo.Premium_Commission_Vat(@P_ANO, @P_Code, cast(datediff(Month,@P_ASDate, @P_SDate) as integer) / 12 + 1,0)  
Select @Premium_outGo=@Premium_Discount+@Premium_Commission  

Select 
@P_OPFEE=coalesce(Sum(Case When A1.ContributionF=1 Then (Case When A1.AmountPCT<>0 Then A1.AmountPCT/100*PCalc.Gross else A1.Amount*100/coalesce(I.Share,100) end) else 0 end*ICALC.GROSS/PCALC.OGROSS),0),
@P_OPFEEPCT=
Coalesce(Sum(Case When A1.AmountPCT<>0 Then A1.AmountPCT/100*PCalc.Gross else A1.Amount*100/coalesce(I.Share,100) end*ICALC.GROSS/PCALC.OGROSS)/Sum(PCalc.Gross*100/coalesce(I.Share,100)*ICALC.GROSS/PCALC.OGROSS)*100,0)
from AccFD A1 
INNER JOIN FDTAB on (FDTAB.FDID=A1.FDID)
INNER Join PCalc on (PCalc.ANO=A1.ANO and PCalc.Currency=A1.Currency)
INNER Join ICalc on (ICALC.ANO=PCALC.ANO AND ICALC.CURRENCY=PCALC.CURRENCY AND ICALC.SDATE=@P_SDATE AND ICALC.EDATE=@P_EDATE AND ICALC.CODE=@P_CODE), Acceptance A2 Left Join ISource I on (I.CNO=A2.CNO) 
Where @P_RType in ('Q','S1','S2','S3') and FDTAB.FDType='O' and A1.Currency=@P_CCY and A1.ANO=A2.ANO and A2.OANO=@P_OANO and A2.ANO<=@P_ANO  

--Apply OP FEE for ONR
Select @Premium_outGo=@Premium_outGo+@P_OPFEEPCT

Select @P_COMM=CASE WHEN @P_COMMPOLICYF=1 and @P_COMM=0 and @P_COMMN=0 Then @Premium_Commission ELSE @P_COMM END  
 
Select              
sum(Case When OnMinPremiumF=0 Then (case When Gross_1>Gross_2 then Gross_1 else Gross_2 end) else (case When Gross_1<Gross_2 and Gross_1<>0 then Gross_1 else Gross_2 end) end) as Premium,              
sum(Case When OnMinPremiumF=0 Then (case When Gross_1>Gross_2 then Comm_1 else Comm_2 end) else (case When Gross_1<Gross_2 and Gross_1<>0 then Comm_1 else Comm_2 end) end) as Commission,              
sum(Case When OnMinPremiumF=0 Then (case When Gross_1>Gross_2 then Disc_1 else Disc_2 end) else (case When Gross_1<Gross_2 and Gross_1<>0 then Disc_1 else Disc_2 end) end) as Discount,  
sum(Case When OnMinPremiumF=0 Then (case When Gross_1>Gross_2 then Fee_1 else Fee_2 end) else (case When Gross_1<Gross_2 and Gross_1<>0 then Fee_1 else Fee_2 end) end) as Fee              
From          
(select              
Cast(@P_OnMinPremiumF as integer) as OnMinPremiumF,              
coalesce(SUM((CASE WHEN @P_PPCT<>0 THEN @P_PPCT/100 ELSE (Case When @P_RateConF=1 and (RRateCon.Rate is not null or RateCon.Rate is not null) then 0 else 1 end) END * ICALC.GROSS*(PCALC.PGROSS*@P_PFactor)/PCALC.POGROSS*(Case When @P_OnNetPremiumF=1 Then (100-@Premium_Treaty_Discount)/100 else 1 end)-(ICALC.GROSS*@P_OPFEE/PCALC.POGROSS))*(Case When @P_COMMN=0 Then @P_COMM/100 else (Case When RCover.NetRateF=1 or @P_ONGROSSNET=2 OR (@P_ONGROSSNET=0 AND (100-@Premium_OutGo)/100*(100-@P_COMMN)/100<(100-@P_COMM)/100) Then (100-@Premium_OutGo)/100*(@P_COMMN)/100 else @P_COMM/100 end) end)),0) AS COMM_1,              
coalesce(SUM((Case When @P_RateConF=1 Then (Case When RRateCon.Rate is null then RateCon.Rate*(Case When RateCon.Loading<>0 then RateCon.Loading/100 else RCover.Loading end) else RRateCon.Rate/PCalc.RiskNum*(Case When RRateCon.Loading<>0 then RRateCon.Loading/100 else RCover.Loading end) end) Else coalesce(@P_NETRATEDet,@P_NETRATE/PCalc.RiskNum) end/100*(100-RCover.Discount)/100*ICALC.GROSS/PCALC.GROSS*ICALC.PRORATA *ICALC.TSI*(CASE WHEN RCOVER.PCALC='S' OR RCOVER.PCTLOSS=0 THEN 100 ELSE RCOVER.PCTLOSS END)/(CASE WHEN RCOVER.PCTLOSS=0 THEN 100 ELSE RCOVER.PCTLOSS END+RCOVER.PAddition)*ICALC.PCTADJ/100-(ICALC.GROSS*@P_OPFEE/PCALC.POGROSS))*(Case When @P_COMMN=0 Then @P_COMM/100 else (Case When RCover.NetRateF=1 or @P_ONGROSSNET=2 OR (@P_ONGROSSNET=0 AND (100-@Premium_OutGo)/100*(100-@P_COMMN)/100<(100-@P_COMM)/100) Then (100-@Premium_OutGo)/100*(@P_COMMN)/100 else @P_COMM/100 end) end)),0) AS COMM_2,              

coalesce(SUM((CASE WHEN @P_PPCT<>0 THEN @P_PPCT/100 ELSE (Case When @P_RateConF=1 and (RRateCon.Rate is not null or RateCon.Rate is not null) then 0 else 1 end) END * ICALC.GROSS*(PCALC.PGROSS*@P_PFactor)/PCALC.POGROSS*(Case When @P_OnNetPremiumF=1 Then (100-@Premium_Treaty_Discount)/100 else 1 end))*(Case When @P_COMMN=0 Then 1 else (Case When RCover.NetRateF=1 or @P_ONGROSSNET=2 OR (@P_ONGROSSNET=0 AND (100-@Premium_OutGo)/100*(100-@P_COMMN)/100<(100-@P_COMM)/100) Then 1 else 1 end) end)),0) AS GROSS_1,
            
coalesce(SUM((Case When @P_RateConF=1 Then (Case When RRateCon.Rate is null then RateCon.Rate*(Case When RateCon.Loading<>0 then RateCon.Loading/100 else RCover.Loading end) else RRateCon.Rate/PCalc.RiskNum*(Case When RRateCon.Loading<>0 then RRateCon.Loading/100 else RCover.Loading end) end) Else coalesce(@P_NETRATEDet,@P_NETRATE/PCalc.RiskNum) end/100*(100-RCover.Discount)/100*ICALC.GROSS/PCALC.GROSS*ICALC.PRORATA *ICALC.TSI*(CASE WHEN RCOVER.PCALC='S' OR RCOVER.PCTLOSS=0 THEN 100 ELSE RCOVER.PCTLOSS END)/(CASE WHEN RCOVER.PCTLOSS=0 THEN 100 ELSE RCOVER.PCTLOSS END+RCOVER.PAddition)*ICALC.PCTADJ/100)*(Case When @P_COMMN=0 Then 1 else (Case When RCover.NetRateF=1 or @P_ONGROSSNET=2 OR (@P_ONGROSSNET=0 AND (100-@Premium_OutGo)/100*(100-@P_COMMN)/100<(100-@P_COMM)/100) Then 1 else 1 end) end)),0) AS GROSS_2,              
             
coalesce(SUM((CASE WHEN @P_PPCT<>0 THEN @P_PPCT/100 ELSE (Case When @P_RateConF=1 and (RRateCon.Rate is not null or RateCon.Rate is not null) then 0 else 1 end) END * ICALC.GROSS*(PCALC.PGROSS*@P_PFactor)/PCALC.POGROSS*(Case When @P_OnNetPremiumF=1 Then (100-@Premium_Treaty_Discount)/100 else 1 end))*(Case When @P_COMMN=0 Then 0 else (Case When RCover.NetRateF=1 or @P_ONGROSSNET=2 OR (@P_ONGROSSNET=0 AND (100-@Premium_OutGo)/100*(100-@P_COMMN)/100<(100-@P_COMM)/100) Then (@Premium_OutGo)/100 else 0 end) end)),0) AS DISC_1,              
coalesce(SUM((Case When @P_RateConF=1 Then (Case When RRateCon.Rate is null then RateCon.Rate*(Case When RateCon.Loading<>0 then RateCon.Loading/100 else RCover.Loading end) else RRateCon.Rate/PCalc.RiskNum*(Case When RRateCon.Loading<>0 then RRateCon.Loading/100 else RCover.Loading end) end) Else coalesce(@P_NETRATEDet,@P_NETRATE/PCalc.RiskNum) end/100*(100-RCover.Discount)/100*ICALC.GROSS/PCALC.GROSS*ICALC.PRORATA *ICALC.TSI*(CASE WHEN RCOVER.PCALC='S' OR RCOVER.PCTLOSS=0 THEN 100 ELSE RCOVER.PCTLOSS END)/(CASE WHEN RCOVER.PCTLOSS=0 THEN 100 ELSE RCOVER.PCTLOSS END+RCOVER.PAddition)*ICALC.PCTADJ/100)*(Case When @P_COMMN=0 Then 0 else (Case When RCover.NetRateF=1 or @P_ONGROSSNET=2 OR (@P_ONGROSSNET=0 AND (100-@Premium_OutGo)/100*(100-@P_COMMN)/100<(100-@P_COMM)/100) Then (@Premium_OutGo)/100 else 0 end) end)),0) AS DISC_2,  

coalesce(SUM((CASE WHEN @P_PPCT<>0 THEN @P_PPCT/100 ELSE (Case When @P_RateConF=1 and (RRateCon.Rate is not null or RateCon.Rate is not null) then 0 else 1 end) END * ICALC.GROSS*(PCALC.PGROSS*@P_PFactor)/PCALC.POGROSS*(Case When @P_OnNetPremiumF=1 Then (100-@Premium_Treaty_Discount)/100 else 1 end))*(Case When @P_COMMN=0 Then 1 else (Case When RCover.NetRateF=1 or @P_ONGROSSNET=2 OR (@P_ONGROSSNET=0 AND (100-@Premium_OutGo)/100*(100-@P_COMMN)/100<(100-@P_COMM)/100) Then 1 else 1 end) end)*@P_FEE/100-(ICALC.GROSS*@P_OPFEE/PCALC.POGROSS)),0) AS FEE_1,              
coalesce(SUM((Case When @P_RateConF=1 Then (Case When RRateCon.Rate is null then RateCon.Rate*(Case When RateCon.Loading<>0 then RateCon.Loading/100 else RCover.Loading end) else RRateCon.Rate/PCalc.RiskNum*(Case When RRateCon.Loading<>0 then RRateCon.Loading/100 else RCover.Loading end) end) Else coalesce(@P_NETRATEDet,@P_NETRATE/PCalc.RiskNum) end/100*(100-RCover.Discount)/100*ICALC.GROSS/PCALC.GROSS*ICALC.PRORATA *ICALC.TSI*(CASE WHEN RCOVER.PCALC='S' OR RCOVER.PCTLOSS=0 THEN 100 ELSE RCOVER.PCTLOSS END)/(CASE WHEN RCOVER.PCTLOSS=0 THEN 100 ELSE RCOVER.PCTLOSS END+RCOVER.PAddition)*ICALC.PCTADJ/100)*(Case When @P_COMMN=0 Then 1 else (Case When RCover.NetRateF=1 or @P_ONGROSSNET=2 OR (@P_ONGROSSNET=0 AND (100-@Premium_OutGo)/100*(100-@P_COMMN)/100<(100-@P_COMM)/100) Then 1 else 1 end) end)*@P_FEE/100-(ICALC.GROSS*@P_OPFEE/PCALC.POGROSS)),0) AS FEE_2  
              
FROM ICALC   
INNER JOIN ACCEPTANCE SACCEPTANCE ON (SACCEPTANCE.ANO=ICALC.SANO)  
INNER JOIN RCOVER ON (RCOVER.ANO=ICALC.SANO AND RCOVER.CODE=ICALC.CODE AND (RCOVER.SDATE=ICALC.SDATE OR (@P_AType='A' AND (CASE WHEN RCOVER.SDATE<SACCEPTANCE.PDATE THEN SACCEPTANCE.PDATE ELSE RCOVER.SDATE END)=ICALC.SDATE)))  
LEFT JOIN RPARTDET ON (RPARTDET.RNO=@P_RNO AND RPARTDET.ID=@P_ID AND RPARTDET.TOR=ICALC.TOR)  
LEFT Join FN_RateCon(@P_ANO, @P_CODE,@P_TSI) RateCon On (RateCon.Code=ICalc.Code)  
LEFT Join FN_RRateCon(@P_ANO, @P_RID, @P_TSI) RRateCon On (1=1)              
INNER JOIN ICOVER ON (ICOVER.INO=ICALC.INO AND (ICOVER.ADJUSTABLE=@P_ADJUSTABLEF OR @P_AType='A'))  
INNER JOIN RCALC ON (RCALC.ANO=ICALC.ANO AND RCALC.CURRENCY=ICALC.CURRENCY AND RCALC.CODE=ICALC.CODE AND RCALC.TOR=ICALC.TOR AND RCALC.SDATE=ICALC.SDATE AND RCALC.EDATE=ICALC.EDATE AND RCALC.SANO=ICALC.SANO AND RCALC.EXTREATYF=0)  
INNER JOIN PCALC_ANNUM(@P_ANO) PCALC ON (PCALC.ANO=ICALC.ANO AND PCALC.CODE=ICALC.CODE AND PCALC.SDATE=ICALC.SDATE AND PCALC.EDATE=ICALC.EDATE AND PCALC.INO=ICALC.INO AND PCALC.CURRENCY=ICALC.CURRENCY)  
WHERE ICALC.ANO=@P_ANO AND ICALC.CURRENCY=@P_CCY AND ICALC.SDATE=@P_SDATE AND ICALC.EDATE=@P_EDATE AND ICALC.CODE=@P_CODE              
AND RPARTDET.TOR IS NULL AND PCALC.GROSS<>0  

Union All              

select              

Cast(@P_OnMinPremiumF as integer) as OnMinPremiumF,              

coalesce(SUM((CASE WHEN RPARTDET.PPCT<>0 THEN RPARTDET.PPCT/100 ELSE (Case When @P_RateConF=1 and (RRateCon.Rate is not null or RateCon.Rate is not null) then 0 else 1 end) END * ICALC.GROSS*(PCALC.PGROSS*@P_PFactor)/PCALC.POGROSS-(ICALC.GROSS*@P_OPFEE/PCALC.POGROSS))*(Case When @P_OnNetPremiumF=1 Then (100-@Premium_Treaty_Discount)/100 else 1 end)*(Case When RPARTDET.COMMN=0 Then RPARTDET.COMM/100 else (Case When RCover.NetRateF=1 or @P_ONGROSSNET=2 OR (@P_ONGROSSNET=0 AND (100-@Premium_OutGo)/100*(100-RPARTDET.CommN)/100<(100-RPARTDET.COMM)/100) Then (100-@Premium_OutGo)/100*(RPARTDET.CommN)/100 else RPARTDET.COMM/100 end) end)),0) AS COMM_1,              
coalesce(SUM((Case When @P_RateConF=1 Then (Case When RRateCon.Rate is null then RateCon.Rate*(Case When RateCon.Loading<>0 then RateCon.Loading/100 else RCover.Loading end) else RRateCon.Rate/PCalc.RiskNum*(Case When RRateCon.Loading<>0 then RRateCon.Loading/100 else RCover.Loading end) end) Else coalesce(@P_NETRATEDet,RPARTDET.NETRate) end/100*(100-RCover.Discount)/100*ICALC.GROSS/PCALC.GROSS*ICALC.PRORATA *ICALC.TSI*(CASE WHEN RCOVER.PCALC='S' OR RCOVER.PCTLOSS=0 THEN 100 ELSE RCOVER.PCTLOSS END)/(CASE
 WHEN RCOVER.PCTLOSS=0 THEN 100 ELSE RCOVER.PCTLOSS END+RCOVER.PAddition)*ICALC.PCTADJ/100-(ICALC.GROSS*@P_OPFEE/PCALC.POGROSS))*(Case When RPARTDET.COMMN=0 Then RPARTDET.COMM/100 else (Case When RCover.NetRateF=1 or @P_ONGROSSNET=2 OR (@P_ONGROSSNET=0 AND (100-@Premium_OutGo)/100*(100-RPARTDET.CommN)/100<(100-RPARTDET.COMM)/100) Then (100-@Premium_OutGo)/100*(RPARTDET.CommN)/100 else RPARTDET.COMM/100 end) end)),0) AS COMM_2,                  
              
coalesce(SUM((CASE WHEN RPARTDET.PPCT<>0 THEN RPARTDET.PPCT/100 ELSE (Case When @P_RateConF=1 and (RRateCon.Rate is not null or RateCon.Rate is not null) then 0 else 1 end) END * ICALC.GROSS*(PCALC.PGROSS*@P_PFactor)/PCALC.POGROSS)*(Case When @P_OnNetPremiumF=1 Then (100-@Premium_Treaty_Discount)/100 else 1 end)*(Case When RPARTDET.COMMN=0 Then 1 else (Case When RCover.NetRateF=1 or @P_ONGROSSNET=2 OR (@P_ONGROSSNET=0 AND (100-@Premium_OutGo)/100*(100-RPARTDET.CommN)/100<(100-RPARTDET.COMM)/100) Then 1 else 1 end) end)),0) AS GROSS_1,              
coalesce(SUM((Case When @P_RateConF=1 Then (Case When RRateCon.Rate is null then RateCon.Rate*(Case When RateCon.Loading<>0 then RateCon.Loading/100 else RCover.Loading end) else RRateCon.Rate/PCalc.RiskNum*(Case When RRateCon.Loading<>0 then RRateCon.Loading/100 else RCover.Loading end) end) Else coalesce(@P_NETRATEDet,RPARTDET.NETRate) end/100*(100-RCover.Discount)/100*ICALC.GROSS/PCALC.GROSS*ICALC.PRORATA *ICALC.TSI*(CASE WHEN RCOVER.PCALC='S' OR RCOVER.PCTLOSS=0 THEN 100 ELSE RCOVER.PCTLOSS END)/(CASE
 WHEN RCOVER.PCTLOSS=0 THEN 100 ELSE RCOVER.PCTLOSS END+RCOVER.PAddition)*ICALC.PCTADJ/100)*(Case When RPARTDET.COMMN=0 Then 1 else (Case When RCover.NetRateF=1 or @P_ONGROSSNET=2 OR (@P_ONGROSSNET=0 AND (100-@Premium_OutGo)/100*(100-RPARTDET.CommN)/100<(100-RPARTDET.COMM)/100) Then 1 else 1 end) end)),0) AS GROSS_2,              

coalesce(SUM((CASE WHEN RPARTDET.PPCT<>0 THEN RPARTDET.PPCT/100 ELSE (Case When @P_RateConF=1 and (RRateCon.Rate is not null or RateCon.Rate is not null) then 0 else 1 end) END * ICALC.GROSS*(PCALC.PGROSS*@P_PFactor)/PCALC.POGROSS)*(Case When @P_OnNetPremiumF=1 Then (100-@Premium_Treaty_Discount)/100 else 1 end)*(Case When RPARTDET.COMMN=0 Then 0 else (Case When RCover.NetRateF=1 or @P_ONGROSSNET=2 OR (@P_ONGROSSNET=0 AND (100-@Premium_OutGo)/100*(100-RPARTDET.CommN)/100<(100-RPARTDET.COMM)/100) Then (@Premium_OutGo)/100 else 0 end) end)),0) AS DISC_1,              
coalesce(SUM((Case When @P_RateConF=1 Then (Case When RRateCon.Rate is null then RateCon.Rate*(Case When RateCon.Loading<>0 then RateCon.Loading/100 else RCover.Loading end) else RRateCon.Rate/PCalc.RiskNum*(Case When RRateCon.Loading<>0 then RRateCon.Loading/100 else RCover.Loading end) end) Else coalesce(@P_NETRATEDet,RPARTDET.NETRate) end/100*(100-RCover.Discount)/100*ICALC.GROSS/PCALC.GROSS*ICALC.PRORATA *ICALC.TSI*(CASE WHEN RCOVER.PCALC='S' OR RCOVER.PCTLOSS=0 THEN 100 ELSE RCOVER.PCTLOSS END)/(CASE
 WHEN RCOVER.PCTLOSS=0 THEN 100 ELSE RCOVER.PCTLOSS END+RCOVER.PAddition)*ICALC.PCTADJ/100)*(Case When RPARTDET.COMMN=0 Then 0 else (Case When RCover.NetRateF=1 or @P_ONGROSSNET=2 OR (@P_ONGROSSNET=0 AND (100-@Premium_OutGo)/100*(100-RPARTDET.CommN)/100<(100-RPARTDET.COMM)/100) Then (@Premium_OutGo)/100 else 0 end) end)),0) AS DISC_2,  

coalesce(SUM((CASE WHEN RPARTDET.PPCT<>0 THEN RPARTDET.PPCT/100 ELSE (Case When @P_RateConF=1 and (RRateCon.Rate is not null or RateCon.Rate is not null) then 0 else 1 end) END * ICALC.GROSS*(PCALC.PGROSS*@P_PFactor)/PCALC.POGROSS)*(Case When @P_OnNetPremiumF=1 Then (100-@Premium_Treaty_Discount)/100 else 1 end)*(Case When RPARTDET.COMMN=0 Then 1 else (Case When RCover.NetRateF=1 or @P_ONGROSSNET=2 OR (@P_ONGROSSNET=0 AND (100-@Premium_OutGo)/100*(100-RPARTDET.CommN)/100<(100-RPARTDET.COMM)/100) Then 1 else 1 end) end)*@P_FEE/100-(ICALC.GROSS*@P_OPFEE/PCALC.POGROSS)),0) AS FEE_1,              
coalesce(SUM((Case When @P_RateConF=1 Then (Case When RRateCon.Rate is null then RateCon.Rate*(Case When RateCon.Loading<>0 then RateCon.Loading/100 else RCover.Loading end) else RRateCon.Rate/PCalc.RiskNum*(Case When RRateCon.Loading<>0 then RRateCon.Loading/100 else RCover.Loading end) end) Else coalesce(@P_NETRATEDet,RPARTDET.NETRate) end/100*(100-RCover.Discount)/100*ICALC.GROSS/PCALC.GROSS*ICALC.PRORATA *ICALC.TSI*(CASE WHEN RCOVER.PCALC='S' OR RCOVER.PCTLOSS=0 THEN 100 ELSE RCOVER.PCTLOSS END)/(CASE
 WHEN RCOVER.PCTLOSS=0 THEN 100 ELSE RCOVER.PCTLOSS END+RCOVER.PAddition)*ICALC.PCTADJ/100)*(Case When RPARTDET.COMMN=0 Then 1 else (Case When RCover.NetRateF=1 or @P_ONGROSSNET=2 OR (@P_ONGROSSNET=0 AND (100-@Premium_OutGo)/100*(100-RPARTDET.CommN)/100<(100-RPARTDET.COMM)/100) Then 1 else 1 end) end)*@P_FEE/100-(ICALC.GROSS*@P_OPFEE/PCALC.POGROSS)),0) AS FEE_2  
FROM ICALC   
INNER JOIN ACCEPTANCE SACCEPTANCE ON (SACCEPTANCE.ANO=ICALC.SANO)  
INNER JOIN RCOVER ON (RCOVER.ANO=ICALC.SANO AND RCOVER.CODE=ICALC.CODE AND (RCOVER.SDATE=ICALC.SDATE OR (@P_AType='A' AND (CASE WHEN RCOVER.SDATE<SACCEPTANCE.PDATE THEN SACCEPTANCE.PDATE ELSE RCOVER.SDATE END)=ICALC.SDATE)))  
INNER JOIN RPARTDET ON (RPARTDET.RNO=@P_RNO AND RPARTDET.ID=@P_ID AND RPARTDET.TOR=ICALC.TOR AND (RPARTDET.NOFYEARS=0 OR RPARTDET.NOFYEARS=@P_NOFYEARS) and RPARTDET.EXCLUDEF=0)  
LEFT Join FN_RateCon(@P_ANO, @P_CODE,@P_TSI) RateCon On (RateCon.Code=ICalc.Code)  
LEFT Join FN_RRateCon(@P_ANO, @P_RID, @P_TSI) RRateCon On (1=1)              
INNER JOIN ICOVER ON (ICOVER.INO=ICALC.INO AND (ICOVER.ADJUSTABLE=@P_ADJUSTABLEF OR @P_AType='A'))  
INNER JOIN RCALC ON (RCALC.ANO=ICALC.ANO AND RCALC.CURRENCY=ICALC.CURRENCY AND RCALC.CODE=ICALC.CODE AND RCALC.TOR=ICALC.TOR AND RCALC.SDATE=ICALC.SDATE AND RCALC.EDATE=ICALC.EDATE AND RCALC.SANO=ICALC.SANO AND RCALC.EXTREATYF=0)  
INNER JOIN PCALC_ANNUM(@P_ANO) PCALC ON (PCALC.ANO=ICALC.ANO AND PCALC.CODE=ICALC.CODE AND PCALC.SDATE=ICALC.SDATE AND PCALC.EDATE=ICALC.EDATE AND PCALC.INO=ICALC.INO AND PCALC.CURRENCY=ICALC.CURRENCY)  
WHERE ICALC.ANO=@P_ANO AND ICALC.CURRENCY=@P_CCY AND ICALC.SDATE=@P_SDATE AND ICALC.EDATE=@P_EDATE AND ICALC.CODE=@P_CODE              
AND PCALC.GROSS<>0  

) R        

GO

IF EXISTS ( SELECT * FROM   sysobjects WHERE  id = object_id(N'[dbo].[QREINSURANCE_CESSION]') and OBJECTPROPERTY(id, N'IsProcedure') = 1 )
BEGIN DROP PROCEDURE [QREINSURANCE_CESSION] END 
GO
CREATE Procedure [dbo].[QREINSURANCE_CESSION] (@P_ANO integer, @P_ADate smalldatetime, @P_RType varchar(255), @P_TSI Float=0, @P_RID varchar(20)='', @P_ManualF Bit=0, @P_GROSS Float=0)                                
as                                                          
SELECT (Case When ReClass.PriorityF=1 Then ReClass.PriorityF else Reinsurance.PriorityF end) as PriorityF, Reinsurance.RID, Reinsurance.RType,                                
ReClass.PLimit*coalesce(ReRate.Rate,1) as PLimit, 
Case RECLASS.Limit WHEN 0 then Reinsurance.Limit Else RECLASS.Limit end*coalesce(ReRate.Rate,1) as limit, 
ReClass.ShortFallLimit*coalesce(ReRate.Rate,1) as ShortFallLimit,              
ReClass.MinTSI*coalesce(ReRate.Rate,1) as MinTI, 
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

IF EXISTS ( SELECT * FROM   sysobjects WHERE  id = object_id(N'[dbo].[QREINSURANCE_RATE]') and OBJECTPROPERTY(id, N'IsProcedure') = 1 )
BEGIN DROP PROCEDURE [QREINSURANCE_RATE] END 
GO
CREATE Procedure [dbo].[QREINSURANCE_RATE](@P_ANO integer, @P_CURRENCY varchar(10)) 
as 
SELECT ReRate.Rate, ReRate.CCYTo 
From Acceptance 
Inner Join Cover on (Cover.CNO=Acceptance.CNO) 
Left Join RArrHeader on (RArrHeader.ANO=Acceptance.ANO) 
Inner Join ReRate on ( 
ReRate.TOC=Acceptance.TOC 
and ReRate.RYear=coalesce(( 
	Select Top 1 R1.RYear 
	from Reinsurance R1, ReClass R2 
	Left Join RePolicy R3 on (R3.RNO=R2.RNO and R3.ID=Cover.PHolder) 
	Where (R1.Category<>'P' or Coalesce(R3.ID,'')<>'') and R1.RType='Q' and R2.RNO=R1.RNO and R2.TOC=Acceptance.TOC and RArrHeader.RDate Between R1.SDate and R1.EDate 
	Order By Case When R1.RID=RArrHeader.QID Then 1 else 0 end Desc, coalesce(R3.ID,'') Desc, (Case When R2.PriorityF=1 Then R2.PriorityF else R1.PriorityF end) Desc),Year(RArrHeader.RDate)) 
And ReRate.Currency=@P_Currency) 
WHERE Acceptance.ANO=@P_ANO 
 
GO

IF EXISTS ( SELECT * FROM   sysobjects WHERE  id = object_id(N'[dbo].[QRemove_PHolder_LimitUsage]') and OBJECTPROPERTY(id, N'IsProcedure') = 1 )
BEGIN DROP PROCEDURE [QRemove_PHolder_LimitUsage] END 
GO
CREATE Procedure [dbo].[QRemove_PHolder_LimitUsage](@P_ANO as integer)
AS
Update PHolder Set TSILimitUsage=PHolder.TSILimitUsage-coalesce(TSI_Current.TSILimitUsage,0)
From 
	PHolder
	Inner join
    (
    Select Cover.PHolder, TOC.COB, sum(Case When Acceptance.AType<>'C' Then Pcalc.OurShare*PCalc.Rate else 0 end) as TSILimitUsage
    From PCalc, Acceptance, Cover, TOC
    Where Acceptance.ANO=@P_ANO and PCalc.ANO=Acceptance.ANO and Cover.CNO=Acceptance.CNO and TOC.TOC=Acceptance.TOC and Acceptance.AType in ('N','E','C')        
    Group by Cover.PHolder, TOC.COB
    ) TSI_Current on (PHolder.ID=TSI_Current.PHolder and PHolder.COB=TSI_Current.COB)
    
GO

IF EXISTS ( SELECT * FROM   sysobjects WHERE  id = object_id(N'[dbo].[QRiskAssLimit]') and OBJECTPROPERTY(id, N'IsProcedure') = 1 )
BEGIN DROP PROCEDURE [QRiskAssLimit] END 
GO
CREATE PROCEDURE [dbo].[QRiskAssLimit] (@PANO as integer, @RType as varchar(10)='')                    
AS                    
SELECT top 1 RiskAss.RiskAss, RiskAss.PLimit, RiskAss.Limit, Cover.ISType, RiskAss.Code, RiskAss.HoldF, RiskAss.Share, RiskAss.Rate, RiskAss.Loading, RiskAss.RType                    
From Riskass, cover, acceptance, Ainfo, RARRHEADER, REINSURANCE, RECLASS                    
WHERE Acceptance.ANO=@PANO And RArrHeader.ANO=Acceptance.ANO and Acceptance.ANO=AInfo.ANO And Acceptance.CNO=Cover.CNO and (RiskAss.RType='' or RiskAss.RType=@RType)                
And Reinsurance.RNO=ReClass.RNO and ReClass.TOC=Acceptance.TOC And RArrHeader.RDate Between Reinsurance.SDate and Reinsurance.EDate and ReClass.AssessmentF=1 and Reinsurance.RType In ('D','Q','S1','S2','S3','A')
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
Order by                   
RiskAss.RYear Desc,        
RiskAss.RType Desc,            
RiskAss.PriorityF Desc,                  
len(coalesce(RiskAss.ValueID1,'')) Desc, len(coalesce(RiskAss.ValueID2,'')) Desc, len(coalesce(RiskAss.ValueID3,'')) Desc, len(coalesce(RiskAss.ValueID4,'')) Desc, len(coalesce(RiskAss.ValueID5,'')) Desc,                   
len(coalesce(RiskAss.ValueID6,'')) Desc, len(coalesce(RiskAss.ValueID7,'')) Desc, len(coalesce(RiskAss.ValueID8,'')) Desc, len(coalesce(RiskAss.ValueID9,'')) Desc, len(coalesce(RiskAss.ValueID10,'')) Desc,                   
len(coalesce(RiskAss.ValueID11,'')) Desc, len(coalesce(RiskAss.ValueID12,'')) Desc, len(coalesce(RiskAss.ValueID13,'')) Desc, len(coalesce(RiskAss.ValueID14,'')) Desc, len(coalesce(RiskAss.ValueID15,'')) Desc,                   
RiskAss.Limit Desc, RiskAss.Loading, RiskAss.HoldF                    
  
GO

IF EXISTS ( SELECT * FROM   sysobjects WHERE  id = object_id(N'[dbo].[QSRACC_1]') and OBJECTPROPERTY(id, N'IsProcedure') = 1 )
BEGIN DROP PROCEDURE [QSRACC_1] END 
GO
CREATE PROCEDURE [dbo].[QSRACC_1] (@P_MO as varchar(10), @P_Segment as varchar(10), @P_Branch as varchar(10), @P_POLICYNO AS VARCHAR(255), @P_CERTIFICATENO VARCHAR(255)) 
AS 
SELECT TOP 50 ACCEPTANCE.POLICYNO, ACCEPTANCE.CERTIFICATENO, Acceptance.AID, Acceptance.AName, SysUser.Name as MOName, Acceptance.Branch, Cover.PHolder, COVER.INSURED, Acceptance.TOC, Cover.CoverDate, Cover.ExpDate, RCover.Code, RCover.Coverage, TOC.RegID, 
TOC.Description as TOCDesc, Profile.Name as PHolderName, Profile.Address_1, Profile.Address_2, Profile.Phone_1, Profile.Phone_2, PCalc.Currency, PCalc.TSI, 
Acceptance.LANO, Acceptance.ANO, Acceptance.Source as BSID, Cover.CNO, Cover.ASource, Cover.PolicyType, Cover.ISType, Cover.Segment, Cover.MO, Branch.Name as BranchName, 
Acceptance.TOPRO, TOPRO.Description as TOPRODesc, Acceptance.RefNo 
FROM ACCEPTANCE Left Join (Select RCover.ANO, Max(RCover.Code) as Code, Max(RateTab.Description) as Coverage from RCover, RateTab Where RateTab.Code=RCover.Code and RCover.Category='M' Group By RCover.ANO) RCover on (RCover.ANO=Acceptance.ANO) 
Left join TOPRO on (TOPRO.TOPRO=Acceptance.TOPRO) 
Inner Join Cover on (Cover.CNO=Acceptance.CNO) inner join TOC on (TOC.TOC=Acceptance.TOC) inner join Profile on (Profile.ID=Cover.PHolder) inner join SysUser on (SysUser.ID=Cover.MO) inner join Branch on (Branch.Branch=Acceptance.Branch) 
Left Join PCalc on (PCalc.ANO=Acceptance.ANO) 
WHERE ACCEPTANCE.ATYPE Not In ('A','C') And ACCEPTANCE.ASTATUS<>'W' And ACCEPTANCE.PDATE<>ACCEPTANCE.PPDATE 
And Cover.MO like @P_MO and Cover.Segment Like @P_Segment 
And Acceptance.Branch Like @P_Branch and ACCEPTANCE.POLICYNO LIKE @P_POLICYNO AND ACCEPTANCE.CERTIFICATENO LIKE @P_CERTIFICATENO 
--And Acceptance.ANO<>Acceptance.LANO 
ORDER BY ACCEPTANCE.ANO DESC 
 
GO

IF EXISTS ( SELECT * FROM   sysobjects WHERE  id = object_id(N'[dbo].[QTREATY_EXCLUDED_CLAUSES]') and OBJECTPROPERTY(id, N'IsProcedure') = 1 )
BEGIN DROP PROCEDURE [QTREATY_EXCLUDED_CLAUSES] END 
GO
CREATE Procedure [dbo].[QTREATY_EXCLUDED_CLAUSES](@P_ANO as integer) 
as 
Select REXCLA.ORDERNO, REXCLA.SHORTDESC 
from Acceptance 
Inner Join RArrHeader on (RArrHeader.ANO=Acceptance.ANO and RArrHeader.DShare+RArrHeader.QShare+RArrHeader.SP1Share+RArrHeader.SP2Share+RArrHeader.SP3Share+RArrHeader.AShare<>0) 
Inner Join Cover on (Cover.CNO=Acceptance.CNO) 
Inner Join RexCla on (RexCla.RYear=Year(RArrHeader.RDate) and RexCla.TOC=Acceptance.TOC) 
Left Join AccCla on (AccCla.ANO=Acceptance.ANO and AccCla.OrderNo=RexCla.OrderNo) 
Where Acceptance.ANO=@P_ANO and AccCla.OrderNo is null 
 
GO

IF EXISTS ( SELECT * FROM   sysobjects WHERE  id = object_id(N'[dbo].[QUndoRemove_PHolder_LimitUsage]') and OBJECTPROPERTY(id, N'IsProcedure') = 1 )
BEGIN DROP PROCEDURE [QUndoRemove_PHolder_LimitUsage] END 
GO
CREATE Procedure [dbo].[QUndoRemove_PHolder_LimitUsage](@P_ANO as integer)
AS
Update PHolder Set TSILimitUsage=PHolder.TSILimitUsage+coalesce(TSI_Current.TSILimitUsage,0)
From 
	PHolder
	Inner join
    (
    Select Cover.PHolder, TOC.COB, sum(Case When Acceptance.AType<>'C' Then Pcalc.OurShare*PCalc.Rate else 0 end) as TSILimitUsage
    From PCalc, Acceptance, Cover, TOC
    Where Acceptance.ANO=@P_ANO and PCalc.ANO=Acceptance.ANO and Cover.CNO=Acceptance.CNO and TOC.TOC=Acceptance.TOC and Acceptance.AType in ('N','E','C')        
    Group by Cover.PHolder, TOC.COB
    ) TSI_Current on (PHolder.ID=TSI_Current.PHolder and PHolder.COB=TSI_Current.COB)


GO

IF EXISTS ( SELECT * FROM   sysobjects WHERE  id = object_id(N'[dbo].[QUndoUpdate_PHolder_LimitUsage]') and OBJECTPROPERTY(id, N'IsProcedure') = 1 )
BEGIN DROP PROCEDURE [QUndoUpdate_PHolder_LimitUsage] END 
GO
CREATE Procedure [dbo].[QUndoUpdate_PHolder_LimitUsage](@P_ANO as integer)
AS
Update PHolder Set TSILimitUsage=PHolder.TSILimitUsage-coalesce(TSI_Current.TSILimitUsage,0)+coalesce(TSI_Previous.TSILimitUsage,0)
From 
	PHolder
	Inner join
    (
    Select Cover.PHolder, TOC.COB, sum(Case When Acceptance.AType<>'C' Then Pcalc.OurShare*PCalc.Rate else 0 end) as TSILimitUsage
    From PCalc, Acceptance, Cover, TOC
    Where Acceptance.ANO=@P_ANO and PCalc.ANO=Acceptance.ANO and Cover.CNO=Acceptance.CNO and TOC.TOC=Acceptance.TOC and Acceptance.AType in ('N','E','C')        
    Group by Cover.PHolder, TOC.COB
    ) TSI_Current on (PHolder.ID=TSI_Current.PHolder and PHolder.COB=TSI_Current.COB)
    Left Join
    (
    Select Cover.PHolder, TOC.COB, sum(Case When pAcceptance.AType<>'C' Then Pcalc.OurShare*PCalc.Rate else 0 end) as TSILimitUsage
    From PCalc, Acceptance pAcceptance, Acceptance, Cover, TOC
    Where Acceptance.ANO=@P_ANO and pAcceptance.ANO=Acceptance.pANO and PCalc.ANO=pAcceptance.ANO and Cover.CNO=pAcceptance.CNO and TOC.TOC=Acceptance.TOC and pAcceptance.AType in ('N','E','C')        
    Group by Cover.PHolder, TOC.COB
    ) TSI_Previous on (TSI_Current.PHolder=TSI_Previous.PHolder and TSI_Current.COB=TSI_Previous.COB)


GO

IF EXISTS ( SELECT * FROM   sysobjects WHERE  id = object_id(N'[dbo].[QUpdate_PHolder_LimitUsage]') and OBJECTPROPERTY(id, N'IsProcedure') = 1 )
BEGIN DROP PROCEDURE [QUpdate_PHolder_LimitUsage] END 
GO
CREATE Procedure [dbo].[QUpdate_PHolder_LimitUsage](@P_ANO as integer)
AS
Update PHolder Set TSILimitUsage=PHolder.TSILimitUsage+coalesce(TSI_Current.TSILimitUsage,0)-coalesce(TSI_Previous.TSILimitUsage,0)
From 
	PHolder
	Inner join
    (
    Select Cover.PHolder, TOC.COB, sum(Case When Acceptance.AType<>'C' Then Pcalc.OurShare*PCalc.Rate else 0 end) as TSILimitUsage
    From PCalc, Acceptance, Cover, TOC
    Where Acceptance.ANO=@P_ANO and PCalc.ANO=Acceptance.ANO and Cover.CNO=Acceptance.CNO and TOC.TOC=Acceptance.TOC and Acceptance.AType in ('N','E','C')        
    Group by Cover.PHolder, TOC.COB
    ) TSI_Current on (PHolder.ID=TSI_Current.PHolder and PHolder.COB=TSI_Current.COB)
    Left Join
    (
    Select Cover.PHolder, TOC.COB, sum(Case When pAcceptance.AType<>'C' Then Pcalc.OurShare*PCalc.Rate else 0 end) as TSILimitUsage
    From PCalc, Acceptance pAcceptance, Acceptance, Cover, TOC
    Where Acceptance.ANO=@P_ANO and pAcceptance.ANO=Acceptance.pANO and PCalc.ANO=pAcceptance.ANO and Cover.CNO=pAcceptance.CNO and TOC.TOC=Acceptance.TOC and pAcceptance.AType in ('N','E','C')        
    Group by Cover.PHolder, TOC.COB
    ) TSI_Previous on (TSI_Current.PHolder=TSI_Previous.PHolder and TSI_Current.COB=TSI_Previous.COB)

GO

IF EXISTS ( SELECT * FROM   sysobjects WHERE  id = object_id(N'[dbo].[QWebAINFO]') and OBJECTPROPERTY(id, N'IsProcedure') = 1 )
BEGIN DROP PROCEDURE [QWebAINFO] END 
GO
CREATE Procedure [dbo].[QWebAINFO] (@P_ANO as integer)  
As  
Select AINFO.ANO, '1' as FLDNO, TOC.FLDTAG1 AS FLDTAG, TOC.FLDTAGA1 AS FLDTAGA, AINFO.VALUEID1 AS VALUEID, 
AINFO.VALUEDESC1 as Description, GENHTAB.FLDTAB      
from AINFO, Acceptance, Cover, TOC, TOC_EXT, GENHTAB      
Where Acceptance.ANO=AInfo.ANO and Cover.CNO=Acceptance.CNO and TOC.TOC=Acceptance.TOC and TOC_EXT.TOC=TOC.TOC       
AND GENHTAB.FLDID=AINFO.FLDID1  AND coalesce(TOC.FLDTAG1,'')<>'' AND ACCEPTANCE.ANO=@P_ANO     
UNION ALL      
Select AINFO.ANO, '2' as FLDNO, TOC.FLDTAG2 AS FLDTAG, TOC.FLDTAGA2 AS FLDTAGA, AINFO.VALUEID2 AS VALUEID, 
AINFO.VALUEDESC2 as Description, GENHTAB.FLDTAB      
from AINFO, Acceptance, Cover, TOC, TOC_EXT, GENHTAB      
Where Acceptance.ANO=AInfo.ANO and Cover.CNO=Acceptance.CNO and TOC.TOC=Acceptance.TOC and TOC_EXT.TOC=TOC.TOC       
AND GENHTAB.FLDID=AINFO.FLDID2  AND coalesce(TOC.FLDTAG2,'')<>'' AND ACCEPTANCE.ANO=@P_ANO      
UNION ALL      
Select AINFO.ANO, '3' as FLDNO, TOC.FLDTAG3 AS FLDTAG, TOC.FLDTAGA3 AS FLDTAGA, AINFO.VALUEID3 AS VALUEID, 
AINFO.VALUEDESC3 as Description, GENHTAB.FLDTAB      
from AINFO, Acceptance, Cover, TOC, TOC_EXT, GENHTAB      
Where Acceptance.ANO=AInfo.ANO and Cover.CNO=Acceptance.CNO and TOC.TOC=Acceptance.TOC and TOC_EXT.TOC=TOC.TOC       
AND GENHTAB.FLDID=AINFO.FLDID3  AND coalesce(TOC.FLDTAG3,'')<>'' AND ACCEPTANCE.ANO=@P_ANO      
UNION ALL      
Select AINFO.ANO, '4' as FLDNO, TOC.FLDTAG4 AS FLDTAG, TOC.FLDTAGA4 AS FLDTAGA, AINFO.VALUEID4 AS VALUEID, 
AINFO.VALUEDESC4 as Description, GENHTAB.FLDTAB      
from AINFO, Acceptance, Cover, TOC, TOC_EXT, GENHTAB      
Where Acceptance.ANO=AInfo.ANO and Cover.CNO=Acceptance.CNO and TOC.TOC=Acceptance.TOC and TOC_EXT.TOC=TOC.TOC       
AND GENHTAB.FLDID=AINFO.FLDID4  AND coalesce(TOC.FLDTAG4,'')<>'' AND ACCEPTANCE.ANO=@P_ANO      
UNION ALL      
Select AINFO.ANO, '5' as FLDNO, TOC.FLDTAG5 AS FLDTAG, TOC.FLDTAGA5 AS FLDTAGA, AINFO.VALUEID5 AS VALUEID, 
AINFO.VALUEDESC5 as Description, GENHTAB.FLDTAB      
from AINFO, Acceptance, Cover, TOC, TOC_EXT, GENHTAB      
Where Acceptance.ANO=AInfo.ANO and Cover.CNO=Acceptance.CNO and TOC.TOC=Acceptance.TOC and TOC_EXT.TOC=TOC.TOC       
AND GENHTAB.FLDID=AINFO.FLDID5  AND coalesce(TOC.FLDTAG5,'')<>'' AND ACCEPTANCE.ANO=@P_ANO      
UNION ALL      
Select AINFO.ANO, '6' as FLDNO, TOC.FLDTAG6 AS FLDTAG, TOC.FLDTAGA6 AS FLDTAGA, AINFO.VALUEID6 AS VALUEID, 
AINFO.VALUEDESC6 as Description, GENHTAB.FLDTAB      
from AINFO, Acceptance, Cover, TOC, TOC_EXT, GENHTAB      
Where Acceptance.ANO=AInfo.ANO and Cover.CNO=Acceptance.CNO and TOC.TOC=Acceptance.TOC and TOC_EXT.TOC=TOC.TOC       
AND GENHTAB.FLDID=AINFO.FLDID6  AND coalesce(TOC.FLDTAG6,'')<>'' AND ACCEPTANCE.ANO=@P_ANO      
UNION ALL      
Select AINFO.ANO, '7' as FLDNO, TOC.FLDTAG7 AS FLDTAG, TOC.FLDTAGA7 AS FLDTAGA, AINFO.VALUEID7 AS VALUEID, 
AINFO.VALUEDESC7 as Description, GENHTAB.FLDTAB      
from AINFO, Acceptance, Cover, TOC, TOC_EXT, GENHTAB      
Where Acceptance.ANO=AInfo.ANO and Cover.CNO=Acceptance.CNO and TOC.TOC=Acceptance.TOC and TOC_EXT.TOC=TOC.TOC       
AND GENHTAB.FLDID=AINFO.FLDID7  AND coalesce(TOC.FLDTAG7,'')<>'' AND ACCEPTANCE.ANO=@P_ANO      
UNION ALL      
Select AINFO.ANO, '8' as FLDNO, TOC.FLDTAG8 AS FLDTAG, TOC.FLDTAGA8 AS FLDTAGA, AINFO.VALUEID8 AS VALUEID, 
AINFO.VALUEDESC8 as Description, GENHTAB.FLDTAB      
from AINFO, Acceptance, Cover, TOC, TOC_EXT, GENHTAB      
Where Acceptance.ANO=AInfo.ANO and Cover.CNO=Acceptance.CNO and TOC.TOC=Acceptance.TOC and TOC_EXT.TOC=TOC.TOC       
AND GENHTAB.FLDID=AINFO.FLDID8  AND coalesce(TOC.FLDTAG8,'')<>'' AND ACCEPTANCE.ANO=@P_ANO      
UNION ALL      
Select AINFO.ANO, '9' as FLDNO, TOC.FLDTAG9 AS FLDTAG, TOC.FLDTAGA9 AS FLDTAGA, AINFO.VALUEID9 AS VALUEID, 
AINFO.VALUEDESC9 as Description, GENHTAB.FLDTAB      
from AINFO, Acceptance, Cover, TOC, TOC_EXT, GENHTAB      
Where Acceptance.ANO=AInfo.ANO and Cover.CNO=Acceptance.CNO and TOC.TOC=Acceptance.TOC and TOC_EXT.TOC=TOC.TOC       
AND GENHTAB.FLDID=AINFO.FLDID9  AND coalesce(TOC.FLDTAG9,'')<>'' AND ACCEPTANCE.ANO=@P_ANO      
UNION ALL      
Select AINFO.ANO, '10' as FLDNO, TOC.FLDTAG10 AS FLDTAG, TOC.FLDTAGA10 AS FLDTAGA, AINFO.VALUEID10 AS VALUEID, 
AINFO.VALUEDESC10 as Description, GENHTAB.FLDTAB      
from AINFO, Acceptance, Cover, TOC, TOC_EXT, GENHTAB      
Where Acceptance.ANO=AInfo.ANO and Cover.CNO=Acceptance.CNO and TOC.TOC=Acceptance.TOC and TOC_EXT.TOC=TOC.TOC       
AND GENHTAB.FLDID=AINFO.FLDID10  AND coalesce(TOC.FLDTAG10,'')<>'' AND ACCEPTANCE.ANO=@P_ANO      
UNION ALL      
Select AINFO.ANO, '11' as FLDNO, TOC.FLDTAG11 AS FLDTAG, TOC.FLDTAGA11 AS FLDTAGA, AINFO.VALUEID10 AS VALUEID, 
AINFO.VALUEDESC11 as Description, GENHTAB.FLDTAB      
from AINFO, Acceptance, Cover, TOC, TOC_EXT, GENHTAB      
Where Acceptance.ANO=AInfo.ANO and Cover.CNO=Acceptance.CNO and TOC.TOC=Acceptance.TOC and TOC_EXT.TOC=TOC.TOC       
AND GENHTAB.FLDID=AINFO.FLDID11  AND coalesce(TOC.FLDTAG11,'')<>'' AND ACCEPTANCE.ANO=@P_ANO      
UNION ALL      
Select AINFO.ANO, '12' as FLDNO, TOC.FLDTAG12 AS FLDTAG, TOC.FLDTAGA12 AS FLDTAGA, AINFO.VALUEID12 AS VALUEID, 
AINFO.VALUEDESC12 as Description, GENHTAB.FLDTAB      
from AINFO, Acceptance, Cover, TOC, TOC_EXT, GENHTAB      
Where Acceptance.ANO=AInfo.ANO and Cover.CNO=Acceptance.CNO and TOC.TOC=Acceptance.TOC and TOC_EXT.TOC=TOC.TOC       
AND GENHTAB.FLDID=AINFO.FLDID12  AND coalesce(TOC.FLDTAG12,'')<>'' AND ACCEPTANCE.ANO=@P_ANO      
UNION ALL      
Select AINFO.ANO, '13' as FLDNO, TOC.FLDTAG13 AS FLDTAG, TOC.FLDTAGA13 AS FLDTAGA, AINFO.VALUEID13 AS VALUEID, 
AINFO.VALUEDESC13 as Description, GENHTAB.FLDTAB      
from AINFO, Acceptance, Cover, TOC, TOC_EXT, GENHTAB      
Where Acceptance.ANO=AInfo.ANO and Cover.CNO=Acceptance.CNO and TOC.TOC=Acceptance.TOC and TOC_EXT.TOC=TOC.TOC       
AND GENHTAB.FLDID=AINFO.FLDID13  AND coalesce(TOC.FLDTAG13,'')<>'' AND ACCEPTANCE.ANO=@P_ANO      
UNION ALL      
Select AINFO.ANO, '14' as FLDNO, TOC.FLDTAG14 AS FLDTAG, TOC.FLDTAGA14 AS FLDTAGA, AINFO.VALUEID14 AS VALUEID, 
AINFO.VALUEDESC14 as Description, GENHTAB.FLDTAB      
from AINFO, Acceptance, Cover, TOC, TOC_EXT, GENHTAB      
Where Acceptance.ANO=AInfo.ANO and Cover.CNO=Acceptance.CNO and TOC.TOC=Acceptance.TOC and TOC_EXT.TOC=TOC.TOC       
AND GENHTAB.FLDID=AINFO.FLDID14  AND coalesce(TOC.FLDTAG14,'')<>'' AND ACCEPTANCE.ANO=@P_ANO      
UNION ALL      
Select AINFO.ANO, '15' as FLDNO, TOC.FLDTAG15 AS FLDTAG, TOC.FLDTAGA15 AS FLDTAGA, AINFO.VALUEID15 AS VALUEID, 
AINFO.VALUEDESC15 as Description, GENHTAB.FLDTAB      
from AINFO, Acceptance, Cover, TOC, TOC_EXT, GENHTAB      
Where Acceptance.ANO=AInfo.ANO and Cover.CNO=Acceptance.CNO and TOC.TOC=Acceptance.TOC and TOC_EXT.TOC=TOC.TOC       
AND GENHTAB.FLDID=AINFO.FLDID15  AND coalesce(TOC.FLDTAG15,'')<>'' AND ACCEPTANCE.ANO=@P_ANO 

GO

IF EXISTS ( SELECT * FROM   sysobjects WHERE  id = object_id(N'[dbo].[Risk_Arrangement]') and OBJECTPROPERTY(id, N'IsProcedure') = 1 )
BEGIN DROP PROCEDURE [Risk_Arrangement] END 
GO
CREATE PROCEDURE [dbo].[Risk_Arrangement] (@PANO as integer)     
AS    
SELECT DISTINCT Reinsurance.RID, Reinsurance.RType, ReClass.Limit, Reinsurance.Share, Acceptance.RegID, Acceptance.FLDID, Acceptance.ValueID, TOC.IACCREG    
FROM Reinsurance, ReClass, Cover, Acceptance, RArrHeader, TOC    
WHERE ACCEPTANCE.ANO=@PANO And RArrHeader.ANO=Acceptance.ANO And COVER.CNO=ACCEPTANCE.CNO and TOC.TOC=Acceptance.TOC  
And Reinsurance.RType In ('C','D','Q','XP','S1','S2','S3','A') And Reinsurance.RNO=ReClass.RNO And ReClass.TOC=Acceptance.TOC 
And RArrHeader.RDate Between Reinsurance.SDate and Reinsurance.EDate   
  
GO

IF EXISTS ( SELECT * FROM   sysobjects WHERE  id = object_id(N'[dbo].[Risk_Arrangement_Temp]') and OBJECTPROPERTY(id, N'IsProcedure') = 1 )
BEGIN DROP PROCEDURE [Risk_Arrangement_Temp] END 
GO
CREATE PROCEDURE [dbo].[Risk_Arrangement_Temp] (@PANO as integer) 
AS
SELECT DISTINCT [Reinsurance].[RID], [Reinsurance].[RType], [ReClass].[Limit], [Reinsurance].[Share], [Acceptance].[FLDID], [Acceptance].[ValueID], TOC.IACCREG
FROM Reinsurance, ReClass, Cover, tAcceptance Acceptance, TOC
WHERE [Reinsurance].[RType] In ('C','D','Q','XP','S1','S2','S3','A') And [Reinsurance].[RNO]=[ReClass].[RNo] And [ReClass].[TOC]=[COVER].[TOC] And [COVER].[CNO]=[ACCEPTANCE].[CNO] And [ACCEPTANCE].[ANO]=@PANO And [Reinsurance].[SDate]<=[Acceptance].[SDate] And [Reinsurance].[EDate]>=[Acceptance].[SDate] and TOC.TOC=Cover.TOC

GO

IF EXISTS ( SELECT * FROM   sysobjects WHERE  id = object_id(N'[dbo].[sListSR]') and OBJECTPROPERTY(id, N'IsProcedure') = 1 )
BEGIN DROP PROCEDURE [sListSR] END 
GO
CREATE PROCEDURE [dbo].[sListSR](@P_ID as int)  
AS  
SELECT  
 Cast(0 as bit) as ProcessFlag, 
 [Cover].[COVERNO],  
 [Cover].[Insured],  
 [Cover].[CNO],  
 [Cover].[CStatus],  
 [Acceptance].[lANO],  
 [Acceptance].[ANO],  
 [Acceptance].[REGNO],  
 [Acceptance].[ADATE],  
 [Acceptance].[LUSERID] as USERID,  
 [SysTab].[Currency],  
 [QPCalc].[TSI],  
 [QPCalc].[OurShare],  
 [QPCalc].[Gross],  
 [Acceptance].[ASTATUS],  
 [Acceptance].[ATYPE],  
 [Acceptance].[SDate],  
 [Acceptance].[EDate],  
 Year([Acceptance].[SDate]) AS RYear,  
 [Cover].[ISType],  
 [Acceptance].[Renewal],  
 [Acceptance].[ESeqNo],  
 [Acceptance].[PolicyNo],  
 [acceptance].[CertificateNo]  
FROM  Acceptance, Cover, SysTab, QMasterAcceptance_PCalc() AS QPCalc, TOC, SysRequest, Service  
Where [cover].[CNO] = [acceptance].[CNO]  
 And [QPCalc].[ANO]=[Acceptance].[ANO]  
 And ([Acceptance].[ANO]=[Acceptance].[LANO] Or [Acceptance].[LANO]=-1)  
 And SysRequest.ID=@P_ID  
 And SysRequest.Param2 in ('SVC')  
 And SysRequest.Param3=Service.SNO  
 And Acceptance.ANO=Service.PANO  
 And TOC.TOC=Acceptance.TOC  
      
Union  
      
SELECT  Cast(0 as bit) as ProcessFlag, 
 [Cover].[COVERNO],  
 [Cover].[Insured],  
 [Cover].[CNO],  
 [Cover].[CStatus],  
 [Acceptance].[lANO],  
 [Acceptance].[ANO],  
 [Acceptance].[REGNO],  
 [Acceptance].[ADATE],  
 [Acceptance].[LUSERID] as USERID,  
 [SysTab].[Currency],  
 [QPCalc].[TSI],  
 [QPCalc].[OurShare],  
 [QPCalc].[Gross],  
 [Acceptance].[ASTATUS],  
 [Acceptance].[ATYPE],  
 [Acceptance].[SDate],  
 [Acceptance].[EDate],  
 Year([Acceptance].[SDate]) AS RYear,  
 [Cover].[ISType],  
 [Acceptance].[Renewal],  
 [Acceptance].[ESeqNo],  
 [Acceptance].[PolicyNo],  
 [acceptance].[CertificateNo]  
FROM  Acceptance, Cover, SysTab, QMasterAcceptance_PCalc() AS QPCalc, Acceptance As Acceptance_Detail, TOC, SysRequest, Service  
Where [cover].[CNO] = [acceptance].[CNO]  
 And [QPCalc].[ANO]=[Acceptance].[ANO]  
 And Acceptance.ANO=Acceptance_Detail.LANO  And Acceptance_Detail.LANO<>Acceptance_Detail.ANO  
 And SysRequest.ID=@P_ID  
 And SysRequest.Param2 in ('SVC')  
 And SysRequest.Param3=Service.SNO  
 And Acceptance_Detail.ANO=Service.PANO  
 And TOC.TOC=Acceptance_Detail.TOC  
    
 GO

IF EXISTS ( SELECT * FROM   sysobjects WHERE  id = object_id(N'[dbo].[SMListSR]') and OBJECTPROPERTY(id, N'IsProcedure') = 1 )
BEGIN DROP PROCEDURE [SMListSR] END 
GO
CREATE PROCEDURE [dbo].[SMListSR](@P_ID as int) 
AS 
SELECT Cast(0 as bit) as ProcessFlag, Cover.COVERNO, Cover.Insured, Cover.CNO, Cover.CStatus, Cover.VSeqNo, Acceptance.lANO, Acceptance.ANO, Acceptance.REGNO, Acceptance.ADATE, Acceptance.LUSERID as USERID, SysTab.Currency, QPCalc.TSI, QPCalc.OurShare, QPCalc.Gross, Acceptance.ASTATUS, Acceptance.ATYPE, Acceptance.SDate, Acceptance.EDate, Year(Acceptance.SDate) AS RYear, Cover.OpenFlag, Cover.ISType 
FROM  Acceptance, Cover, SysTab, QMasterAcceptance_PCalc() AS QPCalc, TOC, SysRequest  , Service 
Where [cover].[CNO] = [acceptance].[CNO] 
And [QPCalc].[ANO]=[Acceptance].[ANO] 
And ([Acceptance].[ANO]=[Acceptance].[LANO] Or [Acceptance].[LANO]=-1) 
And SysRequest.ID=@P_ID 
And SysRequest.Param2 in ('SVC') 
And SysRequest.Param3=Service.SNO 
And Acceptance.ANO=Service.PANO 
And TOC.TOC=Acceptance.TOC 
 
Union 
 
SELECT  Cast(0 as bit) as ProcessFlag, Cover.COVERNO, Cover.Insured, Cover.CNO, Cover.CStatus, Cover.VSeqNo, Acceptance.lANO, Acceptance.ANO, Acceptance.REGNO, Acceptance.ADATE, Acceptance.LUSERID as USERID, SysTab.Currency, QPCalc.TSI, QPCalc.OurShare, QPCalc.Gross, Acceptance.ASTATUS, Acceptance.ATYPE, Acceptance.SDate, Acceptance.EDate, Year(Acceptance.SDate) AS RYear, Cover.OpenFlag, Cover.ISType 
FROM  Acceptance, Cover, SysTab, QMasterAcceptance_PCalc() AS QPCalc, Acceptance As Acceptance_Detail, TOC, SysRequest, Service 
Where [cover].[CNO] = [acceptance].[CNO] 
And [QPCalc].[ANO]=[Acceptance].[ANO] 
And Acceptance.ANO=Acceptance_Detail.LANO  And Acceptance_Detail.LANO<>Acceptance_Detail.ANO 
And SysRequest.ID=@P_ID 
And SysRequest.Param2 in ('SVC') 
And SysRequest.Param3=Service.SNO 
And Acceptance_Detail.ANO=Service.PANO 
And TOC.TOC=Acceptance_Detail.TOC 
 
GO

IF EXISTS ( SELECT * FROM   sysobjects WHERE  id = object_id(N'[dbo].[SP_GETLISTINSUREDINFO_1]') and OBJECTPROPERTY(id, N'IsProcedure') = 1 )
BEGIN DROP PROCEDURE [SP_GETLISTINSUREDINFO_1] END 
GO
CREATE PROCEDURE [dbo].[SP_GETLISTINSUREDINFO_1](@P_PolicyNo varchar(20), @P_CertificateNo varchar(20), @P_LicenseNo varchar(20), @P_ChasisNo varchar(20), @P_MachineNo varchar(20), @P_RefNo varchar(20))  
AS  
Select A1.OANO, 
MAX(A1.PolicyNo) AS POLICYNO, 
MAX(A1.CertificateNo) AS CERTIFICATENO, 
MAX(A1.RefNo) AS REFNO, 
MAX(A1.AName) AS INSURED, 
MAX(A1.Address) AS CORRESPONDENCE_ADDRESS, 
MAX(A1.Inception) AS INCEPTION, 
MAX(A1.Expiry) AS EXPIRY,
MAX(A1.SEGMENT) AS SEGMENT, MAX(SEGMENT.DESCRIPTION) AS SEGMENT_DESC, MAX(A1.TOPRO) AS TOPRO, MAX(TOPRO.DESCRIPTION) AS TOPRO_DESC,
MAX(A1.VehicleBrand) AS VEHICLEBRAND, 
MAX(A1.MACHINENO) AS MACHINENO, 
MAX(A1.CHASISNO) AS CHASISNO, 
MAX(A1.LICENSENO) AS LICENSENO, 
MAX(A1.YEARBUILT) AS YEARBUILT, 
MAX(A1.VEHICLEFUNCTION) AS VEHICLEFUNCTION,
Max(dbo.fn_Risk_Coverage(A1.ANO, 'M')) as Main_Coverage,
Max(dbo.fn_Risk_Coverage(A1.ANO, 'A')) as Add_Coverage,
Max(dbo.fn_Deductible(A1.ANO,'')) as Deductible,
Max(dbo.fn_Clauses(A1.ANO)) as Clauses,
Sum(A3.Amount) as Premium,
Sum(A3.Amount*V.Payment_CC/(V.Nominal_CC-V.Diff_CC)) as Premium_Paid,
Max(V.PDate) as Payment_Date
from
(
Select 
A1.OANO, A1.ANO, A1.PolicyNo, A1.CertificateNo, A1.RefNo, A1.AName, A3.Address, A1.SDate as Inception, A1.EDate as Expiry,
A1.TOPRO, C1.SEGMENT, 
CAST(           
Case 
When A2.FLDID1='V01' Then A2.VALUEDESC1 
When A2.FLDID2='V01' Then A2.VALUEDESC2 
When A2.FLDID3='V01' Then A2.VALUEDESC3 
When A2.FLDID4='V01' Then A2.VALUEDESC4 
When A2.FLDID5='V01' Then A2.VALUEDESC5           
When A2.FLDID6='V01' Then A2.VALUEDESC6 
When A2.FLDID7='V01' Then A2.VALUEDESC7 
When A2.FLDID8='V01' Then A2.VALUEDESC8 
When A2.FLDID9='V01' Then A2.VALUEDESC9 
When A2.FLDID10='V01' Then A2.VALUEDESC10           
When A2.FLDID11='V01' Then A2.VALUEDESC11 
When A2.FLDID12='V01' Then A2.VALUEDESC12 
When A2.FLDID13='V01' Then A2.VALUEDESC13 
When A2.FLDID14='V01' Then A2.VALUEDESC14 
When A2.FLDID15='V01' Then A2.VALUEDESC15             
END As Varchar(255)) As 'VEHICLEBRAND',
CAST(           
Case 
When A2.FLDID1='V05' Then A2.VALUEDESC1 
When A2.FLDID2='V05' Then A2.VALUEDESC2 
When A2.FLDID3='V05' Then A2.VALUEDESC3 
When A2.FLDID4='V05' Then A2.VALUEDESC4 
When A2.FLDID5='V05' Then A2.VALUEDESC5           
When A2.FLDID6='V05' Then A2.VALUEDESC6 
When A2.FLDID7='V05' Then A2.VALUEDESC7 
When A2.FLDID8='V05' Then A2.VALUEDESC8 
When A2.FLDID9='V05' Then A2.VALUEDESC9 
When A2.FLDID10='V05' Then A2.VALUEDESC10           
When A2.FLDID11='V05' Then A2.VALUEDESC11 
When A2.FLDID12='V05' Then A2.VALUEDESC12 
When A2.FLDID13='V05' Then A2.VALUEDESC13 
When A2.FLDID14='V05' Then A2.VALUEDESC14 
When A2.FLDID15='V05' Then A2.VALUEDESC15             
END As Varchar(255)) As 'MACHINENO',
CAST(           
Case 
When A2.FLDID1='V13' Then A2.VALUEDESC1 
When A2.FLDID2='V13' Then A2.VALUEDESC2 
When A2.FLDID3='V13' Then A2.VALUEDESC3 
When A2.FLDID4='V13' Then A2.VALUEDESC4 
When A2.FLDID5='V13' Then A2.VALUEDESC5           
When A2.FLDID6='V13' Then A2.VALUEDESC6 
When A2.FLDID7='V13' Then A2.VALUEDESC7 
When A2.FLDID8='V13' Then A2.VALUEDESC8 
When A2.FLDID9='V13' Then A2.VALUEDESC9 
When A2.FLDID10='V13' Then A2.VALUEDESC10           
When A2.FLDID11='V13' Then A2.VALUEDESC11 
When A2.FLDID12='V13' Then A2.VALUEDESC12 
When A2.FLDID13='V13' Then A2.VALUEDESC13 
When A2.FLDID14='V13' Then A2.VALUEDESC14 
When A2.FLDID15='V13' Then A2.VALUEDESC15             
END As Varchar(255)) As 'CHASISNO',
CAST(           
Case 
When A2.FLDID1='V04' Then A2.VALUEDESC1 
When A2.FLDID2='V04' Then A2.VALUEDESC2 
When A2.FLDID3='V04' Then A2.VALUEDESC3 
When A2.FLDID4='V04' Then A2.VALUEDESC4 
When A2.FLDID5='V04' Then A2.VALUEDESC5           
When A2.FLDID6='V04' Then A2.VALUEDESC6 
When A2.FLDID7='V04' Then A2.VALUEDESC7 
When A2.FLDID8='V04' Then A2.VALUEDESC8 
When A2.FLDID9='V04' Then A2.VALUEDESC9 
When A2.FLDID10='V04' Then A2.VALUEDESC10           
When A2.FLDID11='V04' Then A2.VALUEDESC11 
When A2.FLDID12='V04' Then A2.VALUEDESC12 
When A2.FLDID13='V04' Then A2.VALUEDESC13 
When A2.FLDID14='V04' Then A2.VALUEDESC14 
When A2.FLDID15='V04' Then A2.VALUEDESC15             
END As Varchar(255)) As 'LICENSENO',
CAST(           
Case 
When A2.FLDID1='V16' Then A2.VALUEDESC1 
When A2.FLDID2='V16' Then A2.VALUEDESC2 
When A2.FLDID3='V16' Then A2.VALUEDESC3 
When A2.FLDID4='V16' Then A2.VALUEDESC4 
When A2.FLDID5='V16' Then A2.VALUEDESC5           
When A2.FLDID6='V16' Then A2.VALUEDESC6 
When A2.FLDID7='V16' Then A2.VALUEDESC7 
When A2.FLDID8='V16' Then A2.VALUEDESC8 
When A2.FLDID9='V16' Then A2.VALUEDESC9 
When A2.FLDID10='V16' Then A2.VALUEDESC10           
When A2.FLDID11='V16' Then A2.VALUEDESC11 
When A2.FLDID12='V16' Then A2.VALUEDESC12 
When A2.FLDID13='V16' Then A2.VALUEDESC13 
When A2.FLDID14='V16' Then A2.VALUEDESC14 
When A2.FLDID15='V16' Then A2.VALUEDESC15             
END As Varchar(255)) As 'YEARBUILT',
CAST(           
Case 
When A2.FLDID1='V26' Then A2.VALUEDESC1 
When A2.FLDID2='V26' Then A2.VALUEDESC2 
When A2.FLDID3='V26' Then A2.VALUEDESC3 
When A2.FLDID4='V26' Then A2.VALUEDESC4 
When A2.FLDID5='V26' Then A2.VALUEDESC5           
When A2.FLDID6='V26' Then A2.VALUEDESC6 
When A2.FLDID7='V26' Then A2.VALUEDESC7 
When A2.FLDID8='V26' Then A2.VALUEDESC8 
When A2.FLDID9='V26' Then A2.VALUEDESC9 
When A2.FLDID10='V26' Then A2.VALUEDESC10           
When A2.FLDID11='V26' Then A2.VALUEDESC11 
When A2.FLDID12='V26' Then A2.VALUEDESC12 
When A2.FLDID13='V26' Then A2.VALUEDESC13 
When A2.FLDID14='V26' Then A2.VALUEDESC14 
When A2.FLDID15='V26' Then A2.VALUEDESC15             
END As Varchar(255)) As 'VEHICLEFUNCTION'
from Acceptance A1
Inner Join AInfo A2 on (A2.ANO=A1.ANO)
Left Join AccCA A3 on (A3.ANO=A1.ANO)
Inner Join Cover C1 on (C1.CNO=A1.CNO)
Where A1.ANO<>A1.LANO and A1.AType in ('N','E') and A1.AStatus='I' and C1.CStatus<>'C' and A1.TOC Like '02%'
and A1.PolicyNo Like @P_PolicyNo+'%'
and A1.CertificateNo Like @P_CertificateNo+'%'
and A1.RefNo Like @P_RefNo+'%'
) A1
Inner Join Acceptance A2 on (A2.OANO=A1.ANO)
Inner join AccAss A3 on (A3.ANO=A2.ANO and A3.Code='P')
Inner Join Admlink A4 on (A4.AdmNO=A3.AdmNo)
Inner Join nVoucher V on (V.Voucher=A4.Voucher)
Left Join TOPRO on (TOPRO.TOPRO=A1.TOPRO)
Left Join SEGMENT on (SEGMENT.SEGMENT=A1.SEGMENT)
Where A1.LicenseNo Like @P_LicenseNo+'%' and A1.ChasisNo Like @P_ChasisNo+'%' and A1.MachineNo Like @P_MachineNo+'%'
Group by A1.OANO

GO

IF EXISTS ( SELECT * FROM   sysobjects WHERE  id = object_id(N'[dbo].[Treaty_Adjustment_A]') and OBJECTPROPERTY(id, N'IsProcedure') = 1 )
BEGIN DROP PROCEDURE [Treaty_Adjustment_A] END 
GO
CREATE Procedure [dbo].[Treaty_Adjustment_A](@P_ADATE smalldatetime, @P_REGID varchar(10), @P_FLDID varchar ( 255 ), @P_VALUEID varchar ( 255 ))    
as    
SELECT YEAR(RARRHEADER.RDATE) AS RYEAR,     
SUM(RARRHEADER.TAMOUNT-RARRHEADER.MAMOUNT) AS SI,    
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

IF EXISTS ( SELECT * FROM   sysobjects WHERE  id = object_id(N'[dbo].[Treaty_Adjustment_C]') and OBJECTPROPERTY(id, N'IsProcedure') = 1 )
BEGIN DROP PROCEDURE [Treaty_Adjustment_C] END 
GO
CREATE Procedure [dbo].[Treaty_Adjustment_C](@P_ADATE smalldatetime, @P_REGID varchar(10), @P_FLDID varchar ( 255 ), @P_VALUEID varchar ( 255 ))      
as      
SELECT YEAR(RARRHEADER.RDATE) AS RYEAR,       
SUM(RArrHeader.TAmount/(RARRHEADER.PCTShare/100)) AS SI,      
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

IF EXISTS ( SELECT * FROM   sysobjects WHERE  id = object_id(N'[dbo].[Treaty_Adjustment_D]') and OBJECTPROPERTY(id, N'IsProcedure') = 1 )
BEGIN DROP PROCEDURE [Treaty_Adjustment_D] END 
GO
CREATE Procedure [dbo].[Treaty_Adjustment_D](@P_ADATE smalldatetime, @P_REGID varchar(10), @P_FLDID varchar ( 255 ), @P_VALUEID varchar ( 255 ))    
as    
SELECT YEAR(RARRHEADER.RDATE) AS RYEAR,     
SUM(RARRHEADER.TAMOUNT-RARRHEADER.MAMOUNT) AS SI,    
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

IF EXISTS ( SELECT * FROM   sysobjects WHERE  id = object_id(N'[dbo].[Treaty_Adjustment_Q]') and OBJECTPROPERTY(id, N'IsProcedure') = 1 )
BEGIN DROP PROCEDURE [Treaty_Adjustment_Q] END 
GO
CREATE Procedure [dbo].[Treaty_Adjustment_Q](@P_ADATE smalldatetime, @P_REGID varchar(10), @P_FLDID varchar ( 255 ), @P_VALUEID varchar ( 255 ))    
as    
SELECT YEAR(RARRHEADER.RDATE) AS RYEAR,     
SUM(RARRHEADER.TAMOUNT-RARRHEADER.MAMOUNT) AS SI,    
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

IF EXISTS ( SELECT * FROM   sysobjects WHERE  id = object_id(N'[dbo].[Treaty_Adjustment_S1]') and OBJECTPROPERTY(id, N'IsProcedure') = 1 )
BEGIN DROP PROCEDURE [Treaty_Adjustment_S1] END 
GO
CREATE Procedure [dbo].[Treaty_Adjustment_S1](@P_ADATE smalldatetime, @P_REGID varchar(10), @P_FLDID varchar ( 255 ), @P_VALUEID varchar ( 255 ))    
as    
SELECT YEAR(RARRHEADER.RDATE) AS RYEAR,     
SUM(RARRHEADER.TAMOUNT-RARRHEADER.MAMOUNT) AS SI,    
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


IF EXISTS ( SELECT * FROM   sysobjects WHERE  id = object_id(N'[dbo].[Treaty_Adjustment_S2]') and OBJECTPROPERTY(id, N'IsProcedure') = 1 )
BEGIN DROP PROCEDURE [Treaty_Adjustment_S2] END 
GO
CREATE Procedure [dbo].[Treaty_Adjustment_S2](@P_ADATE smalldatetime, @P_REGID varchar(10), @P_FLDID varchar ( 255 ), @P_VALUEID varchar ( 255 ))    
as    
SELECT YEAR(RARRHEADER.RDATE) AS RYEAR,     
SUM(RARRHEADER.TAMOUNT-RARRHEADER.MAMOUNT) AS SI,    
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

IF EXISTS ( SELECT * FROM   sysobjects WHERE  id = object_id(N'[dbo].[Treaty_Adjustment_S3]') and OBJECTPROPERTY(id, N'IsProcedure') = 1 )
BEGIN DROP PROCEDURE [Treaty_Adjustment_S3] END 
GO
CREATE Procedure [dbo].[Treaty_Adjustment_S3](@P_ADATE smalldatetime, @P_REGID varchar(10), @P_FLDID varchar ( 255 ), @P_VALUEID varchar ( 255 ))    
as    
SELECT YEAR(RARRHEADER.RDATE) AS RYEAR,     
SUM(RARRHEADER.TAMOUNT-RARRHEADER.MAMOUNT) AS SI,    
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

IF EXISTS ( SELECT * FROM   sysobjects WHERE  id = object_id(N'[dbo].[Treaty_Adjustment_XP]') and OBJECTPROPERTY(id, N'IsProcedure') = 1 )
BEGIN DROP PROCEDURE [Treaty_Adjustment_XP] END 
GO
CREATE Procedure [dbo].[Treaty_Adjustment_XP](@P_ADATE smalldatetime, @P_REGID varchar(10), @P_FLDID varchar ( 255 ), @P_VALUEID varchar ( 255 ))      
as      
SELECT YEAR(RARRHEADER.RDATE) AS RYEAR,       
SUM(RArrHeader.TAmount/(RARRHEADER.PCTShare/100)) AS SI,      
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

IF EXISTS ( SELECT * FROM   sysobjects WHERE  id = object_id(N'[dbo].[TREATY_LIMIT]') and OBJECTPROPERTY(id, N'IsProcedure') = 1 )
BEGIN DROP PROCEDURE [TREATY_LIMIT] END 
GO
CREATE Procedure [dbo].[TREATY_LIMIT] (@P_ANO integer, @P_OurShare Float, @P_NCoys Integer)  
as  
SELECT TOP 1 TOL.Limit, TOL.HOLDF  
From TOL, acceptance, RARRHEADER, cover, REINSURANCE, RECLASS  
WHERE Acceptance.ANO=@P_ANO And Cover.CNO=Acceptance.CNO And RArrHeader.ANO=Acceptance.ANO  
And Reinsurance.RNO=ReClass.RNO and ReClass.TOC=Acceptance.TOC And RArrHeader.RDate Between Reinsurance.SDate and Reinsurance.EDate and ReClass.CessionF=1  and Reinsurance.RType In ('D','Q','S1','S2','S3','A')
And TOL.RYear=Reinsurance.RYear And TOL.TOC=ReClass.TOC And TOL.IsType=Cover.IsType  
And ((Minrange<=@P_OurShare And MaxRange>=@P_OurShare) or (MinRange=0 and MaxRange=0))  
And ((MinCoys<=@P_NCoys And MaxCoys>=@P_NCoys) Or (MinCoys=0 And MaxCoys=0))  
And ((MinYear<=datediff(year,Acceptance.SDate, Acceptance.EDate) and MaxYear>=datediff(year,Acceptance.SDate, Acceptance.EDate)) or (MinYear=0 and MaxYear=0))  
Order By TOL.Limit Desc  

GO

IF EXISTS ( SELECT * FROM   sysobjects WHERE  id = object_id(N'[dbo].[Treaty_Premium_Commission]') and OBJECTPROPERTY(id, N'IsProcedure') = 1 )
BEGIN DROP PROCEDURE [Treaty_Premium_Commission] END 
GO
CREATE Procedure [dbo].[Treaty_Premium_Commission](@P_ANO integer,@P_Code varchar(10),@P_CCY varchar(10), @P_SDate smalldatetime, @P_EDate smalldatetime,@P_RID varchar(255),@P_AdjustableF Bit,@P_TSI Float=0)    
as    
-- Gross Treaty Calculation in Base Currency    
Select    
sum(Case When OnMinPremiumF=0 Then (case When Gross_1>Gross_2 then Gross_1 else Gross_2 end) else (case When Gross_1<Gross_2 and Gross_1<>0 then Gross_1 else Gross_2 end) end) as Premium,    
sum(Case When OnMinPremiumF=0 Then (case When Gross_1>Gross_2 then Comm_1 else Comm_2 end) else (case When Gross_1<Gross_2 and Gross_1<>0 then Comm_1 else Comm_2 end) end) as Commission,    
sum(Case When OnMinPremiumF=0 Then (case When Gross_1>Gross_2 then Disc_1 else Disc_2 end) else (case When Gross_1<Gross_2 and Gross_1<>0 then Disc_1 else Disc_2 end) end) as Discount    
From    
(    
select RPart.ID,   
Cast(RPart.OnMinPremiumF as integer) as OnMinPremiumF,    
SUM(CASE WHEN RPART.PPCT<>0 THEN RPART.PPCT/100 ELSE (Case When ReClass.RateConF=1 and (RRateCon.Rate is not null or RateCon.Rate is not null) then 0 else 1 end) END * ICALC.GROSS*PCALC.PGROSS/PCALC.POGROSS*Case When RPart.OnNetPremiumF=1 Then (100-dbo.Premium_Treaty_Discount(ICalc.ANO, ICalc.Code,cast(datediff(Month,Acceptance.SDate, @P_SDate) as integer) / 12 + 1))/100 else 1 end*(Case When RPart.COMMN=0 Then RPart.COMM/100 else (Case When RCover.NetRateF=1 or RARRHEADER.ONGROSSNET=2 OR (RARRHEADER.ONGROSSNET=0 AND Reinsurance.RYear>=2009 and (100-dbo.Premium_OutGo(ICalc.ANO, ICalc.Code,cast(datediff(Month,Acceptance.SDate, @P_SDate) as integer) / 12 + 1))/100*(100-RPART.CommN)/100<(100-RPart.COMM)/100) Then (100-dbo.Premium_OutGo(ICalc.ANO, ICalc.Code,cast(datediff(Month,Acceptance.SDate, @P_SDate) as integer) / 12 + 1))/100*(RPart.CommN)/100 else RPart.COMM/100 end) end)*RPart.Share/100*PCalc.Rate) AS COMM_1,    
SUM(Case When RECLASS.RateConF=1 Then (Case When RRateCon.Rate is null then RateCon.Rate*(Case When RateCon.Loading<>0 then RateCon.Loading/100 else 1 end) else RRateCon.Rate*(Case When RRateCon.Loading<>0 then RRateCon.Loading/100 else 1 end) end) Else Coalesce(RECLASSDET.NETRATE, RPART.NETRATE) end/100/PCalc.RiskNum*ICALC.GROSS/PCALC.GROSS*ICALC.PRORATA *ICALC.TSI*ICALC.PCTADJ/100*(Case When RPart.COMMN=0 Then RPart.COMM/100 else (Case When RCover.NetRateF=1 or RARRHEADER.ONGROSSNET=2 OR (RARRHEADER.ONGROSSNET=0 AND Reinsurance.RYear>=2009 and (100-dbo.Premium_OutGo(ICalc.ANO, ICalc.Code,cast(datediff(Month,Acceptance.SDate, @P_SDate) as integer) / 12 + 1))/100*(100-RPART.CommN)/100<(100-RPart.COMM)/100) Then (100-dbo.Premium_OutGo(ICalc.ANO, ICalc.Code,cast(datediff(Month,Acceptance.SDate, @P_SDate) as integer) / 12 + 1))/100*(RPart.CommN)/100 else RPart.COMM/100 end) end)*RPart.Share/100*PCalc.Rate) AS COMM_2,    
    
SUM(CASE WHEN RPART.PPCT<>0 THEN RPART.PPCT/100 ELSE (Case When ReClass.RateConF=1 and (RRateCon.Rate is not null or RateCon.Rate is not null) then 0 else 1 end) END * ICALC.GROSS*PCALC.PGROSS/PCALC.POGROSS*Case When RPart.OnNetPremiumF=1 Then (100-dbo.Premium_Treaty_Discount(ICalc.ANO, ICalc.Code,cast(datediff(Month,Acceptance.SDate, @P_SDate) as integer) / 12 + 1))/100 else 1 end*(Case When RPart.COMMN=0 Then 1 else (Case When RCover.NetRateF=1 or RARRHEADER.ONGROSSNET=2 OR (RARRHEADER.ONGROSSNET=0 AND Reinsurance.RYear>=2009 and (100-dbo.Premium_OutGo(ICalc.ANO, ICalc.Code,cast(datediff(Month,Acceptance.SDate, @P_SDate) as integer) / 12 + 1))/100*(100-RPART.CommN)/100<(100-RPart.COMM)/100) Then 1 else 1 end) end)*RPart.Share/100*PCalc.Rate) AS GROSS_1,    
SUM(Case When RECLASS.RateConF=1 Then (Case When RRateCon.Rate is null then RateCon.Rate*(Case When RateCon.Loading<>0 then RateCon.Loading/100 else 1 end) else RRateCon.Rate*(Case When RRateCon.Loading<>0 then RRateCon.Loading/100 else 1 end) end) Else Coalesce(RECLASSDET.NETRATE, RPART.NETRATE) end/100/PCalc.RiskNum*ICALC.GROSS/PCALC.GROSS*ICALC.PRORATA *ICALC.TSI*ICALC.PCTADJ/100*(Case When RPart.COMMN=0 Then 1 else (Case When RCover.NetRateF=1 or RARRHEADER.ONGROSSNET=2 OR (RARRHEADER.ONGROSSNET=0 AND Reinsurance.RYear>=2009 and (100-dbo.Premium_OutGo(ICalc.ANO, ICalc.Code,cast(datediff(Month,Acceptance.SDate, @P_SDate) as integer) / 12 + 1))/100*(100-RPART.CommN)/100<(100-RPart.COMM)/100) Then 1 else 1 end) end)*RPart.Share/100*PCalc.Rate) AS GROSS_2,    
    
SUM(CASE WHEN RPART.PPCT<>0 THEN RPART.PPCT/100 ELSE (Case When ReClass.RateConF=1 and (RRateCon.Rate is not null or RateCon.Rate is not null) then 0 else 1 end) END * ICALC.GROSS*PCALC.PGROSS/PCALC.POGROSS*Case When RPart.OnNetPremiumF=1 Then (100-dbo.Premium_Treaty_Discount(ICalc.ANO, ICalc.Code,cast(datediff(Month,Acceptance.SDate, @P_SDate) as integer) / 12 + 1))/100 else 1 end*(Case When RPart.COMMN=0 Then 0 else (Case When RCover.NetRateF=1 or RARRHEADER.ONGROSSNET=2 OR (RARRHEADER.ONGROSSNET=0 AND Reinsurance.RYear>=2009 and (100-dbo.Premium_OutGo(ICalc.ANO, ICalc.Code,cast(datediff(Month,Acceptance.SDate, @P_SDate) as integer) / 12 + 1))/100*(100-RPART.CommN)/100<(100-RPart.COMM)/100) Then (dbo.Premium_OutGo(ICalc.ANO, ICalc.Code,cast(datediff(Month,Acceptance.SDate, @P_SDate) as integer) / 12 + 1))/100 else 0 end) end)*RPart.Share/100*PCalc.Rate) AS DISC_1,    
SUM(Case When RECLASS.RateConF=1 Then (Case When RRateCon.Rate is null then RateCon.Rate*(Case When RateCon.Loading<>0 then RateCon.Loading/100 else 1 end) else RRateCon.Rate*(Case When RRateCon.Loading<>0 then RRateCon.Loading/100 else 1 end) end) Else Coalesce(RECLASSDET.NETRATE, RPART.NETRATE) end/100/PCalc.RiskNum*ICALC.GROSS/PCALC.GROSS*ICALC.PRORATA *ICALC.TSI*ICALC.PCTADJ/100*(Case When RPart.COMMN=0 Then 0 else (Case When RCover.NetRateF=1 or RARRHEADER.ONGROSSNET=2 OR (RARRHEADER.ONGROSSNET=0 AND Reinsurance.RYear>=2009 and (100-dbo.Premium_OutGo(ICalc.ANO, ICalc.Code,cast(datediff(Month,Acceptance.SDate, @P_SDate) as integer) / 12 + 1))/100*(100-RPART.CommN)/100<(100-RPart.COMM)/100) Then (dbo.Premium_OutGo(ICalc.ANO, ICalc.Code,cast(datediff(Month,Acceptance.SDate, @P_SDate) as integer) / 12 + 1))/100 else 0 end) end)*RPart.Share/100*PCalc.Rate) AS DISC_2    
    
FROM ICALC Left Join FN_RateCon(@P_ANO, @P_CODE,@P_TSI) RateCon On (RateCon.Code=ICalc.Code), RCover Left Join FN_RRateCon(@P_ANO, @P_RID, @P_TSI) RRateCon On (1=1)    
, ICOVER, RCALC, PCALC_ANNUM(@P_ANO) PCALC, RPART, REINSURANCE, RECLASS Left Join RECLASSDET ON (RECLASSDET.RNO=RECLASS.RNO AND RECLASSDET.TOC=RECLASS.TOC AND RECLASSDET.CODE=@P_CODE), ACCEPTANCE, COVER, ACCEPTANCE SACCEPTANCE, RARRHEADER    
WHERE RPART.RNO=REINSURANCE.RNO AND REINSURANCE.RID=@P_RID    
AND RECLASS.RNO=REINSURANCE.RNO AND RECLASS.TOC=ACCEPTANCE.TOC    
AND ICALC.ANO=@P_ANO AND ICALC.CURRENCY=@P_CCY AND ICALC.SDATE=@P_SDATE AND ICALC.EDATE=@P_EDATE AND ICALC.CODE=@P_CODE    
AND RCALC.ANO=ICALC.ANO AND RCALC.CURRENCY=ICALC.CURRENCY AND RCALC.CODE=ICALC.CODE AND RCALC.TOR=ICALC.TOR AND RCALC.SDATE=ICALC.SDATE AND RCALC.EDATE=ICALC.EDATE AND RCALC.SANO=ICALC.SANO AND RCALC.EXTREATYF=0    
AND (RECLASS.RateConF=1 OR ICALC.TOR NOT IN (SELECT RPARTDET.TOR FROM RPARTDET WHERE RPARTDET.RNO=REINSURANCE.RNO AND RPARTDET.ID=RPART.ID AND RPARTDET.TOR=ICALC.TOR))    
AND PCALC.ANO=ICALC.ANO AND PCALC.CODE=ICALC.CODE AND PCALC.SDATE=ICALC.SDATE AND PCALC.EDATE=ICALC.EDATE AND PCALC.INO=ICALC.INO AND PCALC.CURRENCY=ICALC.CURRENCY    
AND ACCEPTANCE.ANO=ICALC.ANO AND COVER.CNO=ACCEPTANCE.CNO    
AND ICOVER.INO=ICALC.INO AND (ICOVER.ADJUSTABLE=@P_ADJUSTABLEF OR ACCEPTANCE.ATYPE='A')    
AND PCALC.GROSS<>0    
AND SACCEPTANCE.ANO=ICALC.SANO AND RCOVER.ANO=ICALC.SANO AND RCOVER.CODE=ICALC.CODE AND (RCOVER.SDATE=ICALC.SDATE OR (ACCEPTANCE.ATYPE='A' AND (CASE WHEN RCOVER.SDATE<SACCEPTANCE.PDATE THEN SACCEPTANCE.PDATE ELSE RCOVER.SDATE END)=ICALC.SDATE))    
AND RARRHEADER.ANO=ACCEPTANCE.ANO    
Group By RPart.ID, RPart.OnMinPremiumF    
         
                              
Union All    
                              
select RPart.ID,   
Cast(RPart.OnMinPremiumF as integer) as OnMinPremiumF,    
SUM(CASE WHEN RPARTDET.PPCT<>0 THEN RPARTDET.PPCT/100 ELSE (Case When ReClass.RateConF=1 and (RRateCon.Rate is not null or RateCon.Rate is not null) then 0 else 1 end) END * ICALC.GROSS*PCALC.PGROSS/PCALC.POGROSS*Case When RPART.OnNetPremiumF=1 Then (100-dbo.Premium_Treaty_Discount(ICalc.ANO, ICalc.Code,cast(datediff(Month,Acceptance.SDate, @P_SDate) as integer) / 12 + 1))/100 else 1 end*(Case When RPARTDET.COMMN=0 Then RPARTDET.COMM/100 else (Case When RCover.NetRateF=1 or RARRHEADER.ONGROSSNET=2 OR (RARRHEADER.ONGROSSNET=0 AND Reinsurance.RYear>=2009 and (100-dbo.Premium_OutGo(ICalc.ANO, ICalc.Code,cast(datediff(Month,Acceptance.SDate, @P_SDate) as integer) / 12 + 1))/100*(100-RPARTDET.CommN)/100<(100-RPARTDET.COMM)/100) Then (100-dbo.Premium_OutGo(ICalc.ANO, ICalc.Code,cast(datediff(Month,Acceptance.SDate, @P_SDate) as integer) / 12 + 1))/100*(RPARTDET.CommN)/100 else RPARTDET.COMM/100 end) end)*RPart.Share/100*PCalc.Rate) AS COMM_1,    
SUM(Case When RECLASS.RateConF=1 Then (Case When RRateCon.Rate is null then RateCon.Rate*(Case When RateCon.Loading<>0 then RateCon.Loading/100 else 1 end) else RRateCon.Rate*(Case When RRateCon.Loading<>0 then RRateCon.Loading/100 else 1 end) end) Else Coalesce(RECLASSDET.NETRATE, RPARTDET.NETRATE) end/100/PCalc.RiskNum*ICALC.GROSS/PCALC.GROSS*ICALC.PRORATA *ICALC.TSI*ICALC.PCTADJ/100*(Case When RPARTDET.COMMN=0 Then RPARTDET.COMM/100 else (Case When RCover.NetRateF=1 or RARRHEADER.ONGROSSNET=2 OR (RARRHEADER.ONGROSSNET=0 AND Reinsurance.RYear>=2009 and (100-dbo.Premium_OutGo(ICalc.ANO, ICalc.Code,cast(datediff(Month,Acceptance.SDate, @P_SDate) as integer) / 12 + 1))/100*(100-RPARTDET.CommN)/100<(100-RPARTDET.COMM)/100) Then (100-dbo.Premium_OutGo(ICalc.ANO, ICalc.Code,cast(datediff(Month,Acceptance.SDate, @P_SDate) as integer) / 12 + 1))/100*(RPARTDET.CommN)/100 else RPARTDET.COMM/100 end) end)*RPart.Share/100*PCalc.Rate) AS COMM_2,    
    
SUM(CASE WHEN RPARTDET.PPCT<>0 THEN RPARTDET.PPCT/100 ELSE (Case When ReClass.RateConF=1 and (RRateCon.Rate is not null or RateCon.Rate is not null) then 0 else 1 end) END * ICALC.GROSS*PCALC.PGROSS/PCALC.POGROSS*Case When RPART.OnNetPremiumF=1 Then (100-dbo.Premium_Treaty_Discount(ICalc.ANO, ICalc.Code,cast(datediff(Month,Acceptance.SDate, @P_SDate) as integer) / 12 + 1))/100 else 1 end*(Case When RPARTDET.COMMN=0 Then 1 else (Case When RCover.NetRateF=1 or RARRHEADER.ONGROSSNET=2 OR (RARRHEADER.ONGROSSNET=0 AND Reinsurance.RYear>=2009 and (100-dbo.Premium_OutGo(ICalc.ANO, ICalc.Code,cast(datediff(Month,Acceptance.SDate, @P_SDate) as integer) / 12 + 1))/100*(100-RPARTDET.CommN)/100<(100-RPARTDET.COMM)/100) Then 1 else 1 end) end)*RPart.Share/100*PCalc.Rate) AS GROSS_1,    
SUM(Case When RECLASS.RateConF=1 Then (Case When RRateCon.Rate is null then RateCon.Rate*(Case When RateCon.Loading<>0 then RateCon.Loading/100 else 1 end) else RRateCon.Rate*(Case When RRateCon.Loading<>0 then RRateCon.Loading/100 else 1 end) end) Else Coalesce(RECLASSDET.NETRATE, RPARTDET.NETRATE) end/100/PCalc.RiskNum*ICALC.GROSS/PCALC.GROSS*ICALC.PRORATA *ICALC.TSI*ICALC.PCTADJ/100*(Case When RPARTDET.COMMN=0 Then 1 else (Case When RCover.NetRateF=1 or RARRHEADER.ONGROSSNET=2 OR (RARRHEADER.ONGROSSNET=0 AND Reinsurance.RYear>=2009 and (100-dbo.Premium_OutGo(ICalc.ANO, ICalc.Code,cast(datediff(Month,Acceptance.SDate, @P_SDate) as integer) / 12 + 1))/100*(100-RPARTDET.CommN)/100<(100-RPARTDET.COMM)/100) Then 1 else 1 end) end)*RPart.Share/100*PCalc.Rate) AS GROSS_2,    
    
SUM(CASE WHEN RPARTDET.PPCT<>0 THEN RPARTDET.PPCT/100 ELSE (Case When ReClass.RateConF=1 and (RRateCon.Rate is not null or RateCon.Rate is not null) then 0 else 1 end) END * ICALC.GROSS*PCALC.PGROSS/PCALC.POGROSS*Case When RPART.OnNetPremiumF=1 Then (100-dbo.Premium_Treaty_Discount(ICalc.ANO, ICalc.Code,cast(datediff(Month,Acceptance.SDate, @P_SDate) as integer) / 12 + 1))/100 else 1 end*(Case When RPARTDET.COMMN=0 Then 0 else (Case When RCover.NetRateF=1 or RARRHEADER.ONGROSSNET=2 OR (RARRHEADER.ONGROSSNET=0 AND Reinsurance.RYear>=2009 and (100-dbo.Premium_OutGo(ICalc.ANO, ICalc.Code,cast(datediff(Month,Acceptance.SDate, @P_SDate) as integer) / 12 + 1))/100*(100-RPARTDET.CommN)/100<(100-RPARTDET.COMM)/100) Then (dbo.Premium_OutGo(ICalc.ANO, ICalc.Code,cast(datediff(Month,Acceptance.SDate, @P_SDate) as integer) / 12 + 1))/100 else 0 end) end)*RPart.Share/100*PCalc.Rate) AS DISC_1,    
SUM(Case When RECLASS.RateConF=1 Then (Case When RRateCon.Rate is null then RateCon.Rate*(Case When RateCon.Loading<>0 then RateCon.Loading/100 else 1 end) else RRateCon.Rate*(Case When RRateCon.Loading<>0 then RRateCon.Loading/100 else 1 end) end) Else Coalesce(RECLASSDET.NETRATE, RPARTDET.NETRATE) end/100/PCalc.RiskNum*ICALC.GROSS/PCALC.GROSS*ICALC.PRORATA *ICALC.TSI*ICALC.PCTADJ/100*(Case When RPARTDET.COMMN=0 Then 0 else (Case When RCover.NetRateF=1 or RARRHEADER.ONGROSSNET=2 OR (RARRHEADER.ONGROSSNET=0 AND Reinsurance.RYear>=2009 and (100-dbo.Premium_OutGo(ICalc.ANO, ICalc.Code,cast(datediff(Month,Acceptance.SDate, @P_SDate) as integer) / 12 + 1))/100*(100-RPARTDET.CommN)/100<(100-RPARTDET.COMM)/100) Then (dbo.Premium_OutGo(ICalc.ANO, ICalc.Code,cast(datediff(Month,Acceptance.SDate, @P_SDate) as integer) / 12 + 1))/100 else 0 end) end)*RPart.Share/100*PCalc.Rate) AS DISC_2    
                                
FROM ICALC Left Join FN_RateCon(@P_ANO, @P_CODE,@P_TSI) RateCon On (RateCon.Code=ICalc.Code),  RCover Left Join FN_RRateCon(@P_ANO, @P_RID, @P_TSI) RRateCon On (1=1)    
, ICOVER, RCALC, RPART, RPARTDET, REINSURANCE, RECLASS Left Join RECLASSDET ON (RECLASSDET.RNO=RECLASS.RNO AND RECLASSDET.TOC=RECLASS.TOC AND RECLASSDET.CODE=@P_CODE), PCALC_ANNUM(@P_ANO) PCALC, ACCEPTANCE, COVER, ACCEPTANCE SACCEPTANCE, RARRHEADER    
WHERE RPART.RNO=REINSURANCE.RNO AND RPART.ID=RPARTDET.ID AND RPARTDET.RNO=REINSURANCE.RNO AND REINSURANCE.RID=@P_RID AND (RPARTDET.NOFYEARS=0 OR RPARTDET.NOFYEARS=datediff(year,acceptance.sdate, acceptance.edate))    
AND RECLASS.RNO=REINSURANCE.RNO AND RECLASS.TOC=ACCEPTANCE.TOC AND RECLASS.RATECONF=0    
AND ICALC.ANO=@P_ANO AND RPARTDET.TOR=ICALC.TOR AND RPARTDET.EXCLUDEF=0    
AND ICALC.ANO=@P_ANO AND ICALC.CURRENCY=@P_CCY AND ICALC.SDATE=@P_SDATE AND ICALC.EDATE=@P_EDATE AND ICALC.CODE=@P_CODE    
AND RCALC.ANO=ICALC.ANO AND RCALC.CURRENCY=ICALC.CURRENCY AND RCALC.CODE=ICALC.CODE AND RCALC.TOR=ICALC.TOR AND RCALC.SDATE=ICALC.SDATE AND RCALC.EDATE=ICALC.EDATE AND RCALC.SANO=ICALC.SANO AND RCALC.EXTREATYF=0    
AND PCALC.ANO=ICALC.ANO AND PCALC.CODE=ICALC.CODE AND PCALC.SDATE=ICALC.SDATE AND PCALC.EDATE=ICALC.EDATE AND PCALC.INO=ICALC.INO AND PCALC.CURRENCY=ICALC.CURRENCY    
AND ACCEPTANCE.ANO=ICALC.ANO AND COVER.CNO=ACCEPTANCE.CNO    
AND ICOVER.INO=ICALC.INO AND (ICOVER.ADJUSTABLE=@P_ADJUSTABLEF OR ACCEPTANCE.ATYPE='A')    
AND PCALC.GROSS<>0    
AND SACCEPTANCE.ANO=ICALC.SANO AND RCOVER.ANO=ICALC.SANO AND RCOVER.CODE=ICALC.CODE AND (RCOVER.SDATE=ICALC.SDATE OR (ACCEPTANCE.ATYPE='A' AND (CASE WHEN RCOVER.SDATE<SACCEPTANCE.PDATE THEN SACCEPTANCE.PDATE ELSE RCOVER.SDATE END)=ICALC.SDATE))    
AND RARRHEADER.ANO=ACCEPTANCE.ANO    
Group By RPart.ID, RPart.OnMinPremiumF    
) R    
     
GO

IF EXISTS ( SELECT * FROM   sysobjects WHERE  id = object_id(N'[dbo].[View04]') and OBJECTPROPERTY(id, N'IsProcedure') = 1 )
BEGIN DROP PROCEDURE [View04] END 
GO
CREATE PROCEDURE [dbo].[View04] (@pANO as integer)       
AS      
SELECT RArrHeader.*, TOC.REGID, Acceptance.FLDID, Acceptance.ValueID, Cover.OpenFlag, ACCEPTANCE.TOC, Acceptance.PolicyNo, Acceptance.CertificateNo, Acceptance.RegNo, Cover.CoverNo, Cover.ISType, Acceptance.RANO, Acceptance.AType, Acceptance.AStatus, Acceptance.SDate, Acceptance.EDate, MAcceptance.SDate as M_SDate, MAcceptance.EDate as M_EDate
FROM RArrHeader, Acceptance Left Join ACCEPTANCE MAcceptance on (MAcceptance.ANO=Acceptance.LANO), Cover, TOC      
WHERE RArrHeader.ANO=@pANO And Acceptance.ANO=RArrHeader.ANO And Acceptance.CNO=Cover.CNO and TOC.TOC=ACCEPTANCE.TOC      
      
GO

IF EXISTS ( SELECT * FROM   sysobjects WHERE  id = object_id(N'[dbo].[View16]') and OBJECTPROPERTY(id, N'IsProcedure') = 1 )
BEGIN DROP PROCEDURE [View16] END 
GO
CREATE PROCEDURE [dbo].[View16] (@P_ANO as integer)
AS
SELECT Cover.*, [ISource].[RType], [Acceptance].[RegNo], [Acceptance].[ANO] AS ANO, [Payor].[ID], [Profile].[Name], [Acceptance].[AStatus], [TOC].[Description], [Acceptance].[Branch]
FROM Cover, ISource, Acceptance, Payor, Profile, TOC
WHERE [Acceptance].[ANO]=[Acceptance].[LANO] And [Cover].[CNO]=[Acceptance].[CNO] And [ISource].[CNO]=[Cover].[CNO] And [Payor].[ANO]=[Acceptance].[ANO] And [Cover].[ISType]='T' And [Profile].[ID]=[Payor].[ID] And [TOC].[TOC]=[ACCEPTANCE].[TOC] And [Acceptance].[ANO]=@P_ANO


GO

-- 5 APR 2017 :Penambahan Activities ALLOWDECPREMIUM untuk pemeriksaan endorsement Polis tidak mengurangi nilai Premi
IF NOT EXISTS(SELECT * FROM SYSFORM WHERE FNAME='ALLOWDECPREMIUM')
BEGIN
insert into SysForm(FName, Description, FCode) Select 'ALLOWDECPREMIUM','Allow Decreasing Premium Amount','ACTIVITIES'
end
go

-- Penambahan Opsi Exclude Table Of LImit untuk Inward Business (di setting Reinsurance Class), sehingga untuk Inward Business tetap menggunakan 100% Limit
if exists (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Get_Payment_Percentage]') AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) )
BEGIN DROP FUNCTION [dbo].Get_Payment_Percentage END
GO
CREATE Function Get_Payment_Percentage(@P_A_PolicyNo varchar(50), @P_Date smalldatetime)
RETURNS Float AS        
  
BEGIN       
Declare @PCT as Float

Select 
@PCT=sum(case When V.DebtorF=1 Then (V.Payment_CC) Else -(V.Payment_CC) end)/sum(case When V.DebtorF=1 Then (V.Nominal_CC-V.Diff_CC) Else -(V.Nominal_CC-V.Diff_CC) end)*100
from Admlink a, nVoucher V 
Where V.Voucher=A.Voucher and A.Date<=@P_Date and A.A_PolicyNo=@P_A_PolicyNo and A.SUbject='Premium' and V.DebtorF=1 and A.Type in ('DI','IC','IR')
Having sum(case When V.DebtorF=1 Then (V.Nominal_CC-V.Diff_CC) Else -(V.Nominal_CC-V.Diff_CC) end)<>0

if @PCT IS NULL 
	SELECT @PCT=0

Return @PCT
End
GO

IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'AssessmentExInwardF' AND Object_ID = Object_ID(N'RECLASS'))
BEGIN
ALTER TABLE dbo.RECLASS ADD	AssessmentExInwardF bit NULL
DECLARE @v sql_variant 
SET @v = N'Exclude Inward Business for Table Of Limit (0 : No, 1 : Yes Exclude)'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'RECLASS', N'COLUMN', N'AssessmentExInwardF'
ALTER TABLE dbo.RECLASS ADD CONSTRAINT	DF_RECLASS_AssessmentExInwardF DEFAULT 0 FOR AssessmentExInwardF
END
GO

Update ReClass set AssessmentExInwardF=0 Where AssessmentExInwardF is null
GO

IF EXISTS ( SELECT * FROM   sysobjects WHERE  id = object_id(N'[dbo].[QRiskAssLimit]') and OBJECTPROPERTY(id, N'IsProcedure') = 1 )
BEGIN DROP PROCEDURE [QRiskAssLimit] END 
GO
CREATE PROCEDURE [dbo].[QRiskAssLimit] (@PANO as integer, @RType as varchar(10)='')                    
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

--10 APR 2017 :Penambahan Arrival Date di Risk Cover
IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'ARRIVALDATE' AND Object_ID = Object_ID(N'RCOVER'))
BEGIN
ALTER TABLE dbo.RCOVER ADD
	ARRIVALDATE smalldatetime NULL
END
GO


-- Penambahan Binder Warranty di Insurance Source dan Facultative
IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'BinderWarranty' AND Object_ID = Object_ID(N'ISOURCE'))
BEGIN
ALTER TABLE dbo.ISOURCE ADD	BinderWarranty int NULL
DECLARE @v sql_variant 
SET @v = N'Binder Warranty (in Days)'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'ISOURCE', N'COLUMN', N'BinderWarranty'
END
GO

IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'BinderWarranty' AND Object_ID = Object_ID(N'FPART'))
BEGIN
ALTER TABLE dbo.FPART ADD	BinderWarranty int NULL
DECLARE @v sql_variant 
SET @v = N'Binder Warranty (in Days)'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'FPART', N'COLUMN', N'BinderWarranty'
END 
GO

IF EXISTS ( SELECT * FROM   sysobjects WHERE  id = object_id(N'[dbo].[QFacultative_Data]') and OBJECTPROPERTY(id, N'IsProcedure') = 1 )
BEGIN DROP PROCEDURE QFacultative_Data END 
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
F.GRACE,                    
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


--10 Apr 2017 : Penambahan Opsi Create Profile (dulu Dump Profile adalah Opsi untuk Create Profile),
IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'CreateProfileF' AND Object_ID = Object_ID(N'MAP_REFERENCE'))
BEGIN
ALTER TABLE dbo.MAP_REFERENCE ADD	CreateProfileF bit NULL
DECLARE @v sql_variant 
SET @v = N'Flag Indicating ok to Create Profile when not found (0 : No, 1 : Yes)'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'MAP_REFERENCE', N'COLUMN', N'CreateProfileF'
END
GO

Update MAP_REFERENCE SEt CreateProfileF=DumpProfileF Where CreateProfileF is null
GO


--31 mar 2017
IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'Rate_RC' AND Object_ID = Object_ID(N'Exchange'))
BEGIN
Alter Table Exchange Add Rate_RC float default(0)
END
GO
Update Exchange Set Rate_RC=0 Where Rate_RC is null
GO

IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'Rate_RC' AND Object_ID = Object_ID(N'Currency'))
BEGIN
Alter Table Currency Add Rate_RC float default(0)
END
GO
Update Currency Set Rate_RC=0 Where Rate_RC is null 
GO

IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'VRate_RC' AND Object_ID = Object_ID(N'Exchange'))
BEGIN
Alter Table Exchange Add VRate_RC float default(0)
END
GO
Update Exchange Set VRate_RC=0 Where VRate_RC is null
GO

IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'VRate_RC' AND Object_ID = Object_ID(N'Currency'))
BEGIN
Alter Table Currency Add VRate_RC float default(0)
END
GO
Update Currency Set VRate_RC=0 Where VRate_RC is null 
GO

IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'Rate_RC' AND Object_ID = Object_ID(N'nVoucher'))
BEGIN
Alter Table nVoucher Add Rate_RC FLoat Default(0)
END
GO

IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'Rate_RC' AND Object_ID = Object_ID(N'pVoucher'))
BEGIN
Alter Table pVoucher Add Rate_RC FLoat Default(0)
END
GO

IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'Rate_RC' AND Object_ID = Object_ID(N'mVoucher'))
BEGIN
Alter Table mVoucher Add Rate_RC FLoat Default(0)
END
GO

IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'Rate_RC' AND Object_ID = Object_ID(N'Request'))
BEGIN
Alter Table Request Add Rate_RC FLoat Default(0)
END
GO

IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'Debit_RC' AND Object_ID = Object_ID(N'nJournal'))
BEGIN
ALTER TABLE dbo.nJournal ADD	Debit_RC float(53) NULL
DECLARE @v sql_variant 
SET @v = N'Amount Debit Second Base Currency'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'nJournal', N'COLUMN', N'Debit_RC'
END
GO

IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'Credit_RC' AND Object_ID = Object_ID(N'nJournal'))
BEGIN
ALTER TABLE dbo.nJournal ADD	Credit_RC float(53) NULL
DECLARE @v sql_variant 
SET @v = N'Amount Credit Second Base Currency'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'nJournal', N'COLUMN', N'Credit_RC'
END
GO


IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'Debit_RC' AND Object_ID = Object_ID(N'mJournal'))
BEGIN
ALTER TABLE dbo.mJournal ADD	Debit_RC float(53) NULL
DECLARE @v sql_variant 
SET @v = N'Amount Debit Second Base Currency'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'mJournal', N'COLUMN', N'Debit_RC'
END
GO


IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'Credit_RC' AND Object_ID = Object_ID(N'mJournal'))
BEGIN
ALTER TABLE dbo.mJournal ADD	Credit_RC float(53) NULL
DECLARE @v sql_variant 
SET @v = N'Amount Credit Second Base Currency'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'mJournal', N'COLUMN', N'Credit_RC'
END
GO

IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'Debit_RC' AND Object_ID = Object_ID(N'pJournal'))
BEGIN
ALTER TABLE dbo.pJournal ADD	Debit_RC float(53) NULL
DECLARE @v sql_variant 
SET @v = N'Amount Debit Second Base Currency'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'pJournal', N'COLUMN', N'Debit_RC'
END
GO


IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'Credit_RC' AND Object_ID = Object_ID(N'pJournal'))
BEGIN
ALTER TABLE dbo.pJournal ADD	Credit_RC float(53) NULL
DECLARE @v sql_variant 
SET @v = N'Amount Credit Second Base Currency'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'pJournal', N'COLUMN', N'Credit_RC'
END
GO

IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'Debit_RC' AND Object_ID = Object_ID(N'Journal_Account'))
BEGIN
ALTER TABLE dbo.Journal_Account ADD	Debit_RC float(53) NULL
DECLARE @v sql_variant 
SET @v = N'Amount Debit Second Base Currency'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'Journal_Account', N'COLUMN', N'Debit_RC'
END 
GO

IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'Credit_RC' AND Object_ID = Object_ID(N'Journal_Account'))
BEGIN
ALTER TABLE dbo.Journal_Account ADD	Credit_RC float(53) NULL
DECLARE @v sql_variant 
SET @v = N'Amount Credit Second Base Currency'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'Journal_Account', N'COLUMN', N'Credit_RC'
END 
GO

IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'Starting_RC' AND Object_ID = Object_ID(N'CA_FX'))
BEGIN
ALTER TABLE dbo.CA_FX ADD
	Starting_RC float(53) NULL,
	Ending_RC float(53) NULL,
	Debit_RC float(53) NULL,
	Credit_RC float(53) NULL,
	Closing_RC float(53) NULL,
	Revaluation_RC float(53) NULL
END
GO

IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'Starting_RC' AND Object_ID = Object_ID(N'SL_FX'))
BEGIN
ALTER TABLE dbo.SL_FX ADD
	Starting_RC float(53) NULL,
	Ending_RC float(53) NULL,
	Debit_RC float(53) NULL,
	Credit_RC float(53) NULL,
	Closing_RC float(53) NULL,
	Revaluation_RC float(53) NULL
END
GO

IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'Starting_RC' AND Object_ID = Object_ID(N'GL_FX'))
BEGIN
ALTER TABLE dbo.GL_FX ADD
	Starting_RC float(53) NULL,
	Ending_RC float(53) NULL,
	Debit_RC float(53) NULL,
	Credit_RC float(53) NULL,
	Closing_RC float(53) NULL,
	Revaluation_RC float(53) NULL
END
GO


IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'Debit_RC' AND Object_ID = Object_ID(N'GL'))
BEGIN
ALTER TABLE dbo.GL ADD
	Debit_RC float(53) NULL,
	Credit_RC float(53) NULL,
	Revaluation_RC float(53) NULL,
	Balance_RC_1 float(53) NULL,
	Balance_RC_2 float(53) NULL,
	Balance_RC_3 float(53) NULL,
	Balance_RC_4 float(53) NULL,
	Balance_RC_5 float(53) NULL,
	Balance_RC_6 float(53) NULL,
	Balance_RC_7 float(53) NULL,
	Balance_RC_8 float(53) NULL,
	Balance_RC_9 float(53) NULL,
	Balance_RC_10 float(53) NULL,
	Balance_RC_11 float(53) NULL,
	Balance_RC_12 float(53) NULL,
	Balance_RC_13 float(53) NULL,
	Balance_RC_14 float(53) NULL,
	Balance_RC_15 float(53) NULL,
	Balance_RC_16 float(53) NULL,
	Balance_RC_17 float(53) NULL,
	Balance_RC_18 float(53) NULL,
	Balance_RC_19 float(53) NULL,
	Balance_RC_20 float(53) NULL,
	Balance_RC_21 float(53) NULL,
	Balance_RC_22 float(53) NULL,
	Balance_RC_23 float(53) NULL,
	Balance_RC_24 float(53) NULL,
	Balance_RC_25 float(53) NULL,
	Balance_RC_26 float(53) NULL,
	Balance_RC_27 float(53) NULL,
	Balance_RC_28 float(53) NULL,
	Balance_RC_29 float(53) NULL,
	Balance_RC_30 float(53) NULL,
	Balance_RC_31 float(53) NULL
END
GO

IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'Balance_RC' AND Object_ID = Object_ID(N'CTL'))
BEGIN
ALTER TABLE dbo.CTL ADD
	Balance_RC float(53) NULL
END
GO

IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'Actual_RC_1' AND Object_ID = Object_ID(N'CTBUDGET'))
BEGIN
ALTER TABLE dbo.CTBUDGET ADD
	Actual_RC_1 float(53) NULL,
	Actual_RC_2 float(53) NULL,
	Actual_RC_3 float(53) NULL,
	Actual_RC_4 float(53) NULL,
	Actual_RC_5 float(53) NULL,
	Actual_RC_6 float(53) NULL,
	Actual_RC_7 float(53) NULL,
	Actual_RC_8 float(53) NULL,
	Actual_RC_9 float(53) NULL,
	Actual_RC_10 float(53) NULL,
	Actual_RC_11 float(53) NULL,
	Actual_RC_12 float(53) NULL,
	Actual_RC_13 float(53) NULL,
	Actual_RC_14 float(53) NULL,
	Actual_RC_15 float(53) NULL,
	Actual_RC_16 float(53) NULL,
	Actual_RC_17 float(53) NULL,
	Actual_RC_18 float(53) NULL,
	Actual_RC_19 float(53) NULL,
	Actual_RC_20 float(53) NULL,
	Actual_RC_21 float(53) NULL,
	Actual_RC_22 float(53) NULL,
	Actual_RC_23 float(53) NULL,
	Actual_RC_24 float(53) NULL,
	Actual_RC_25 float(53) NULL,
	Actual_RC_26 float(53) NULL,
	Actual_RC_27 float(53) NULL,
	Actual_RC_28 float(53) NULL,
	Actual_RC_29 float(53) NULL,
	Actual_RC_30 float(53) NULL,
	Actual_RC_31 float(53) NULL
END
GO


IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'Actual_RC_1' AND Object_ID = Object_ID(N'BUDGET'))
BEGIN
ALTER TABLE dbo.BUDGET ADD
	Actual_RC_1 float(53) NULL,
	Actual_RC_2 float(53) NULL,
	Actual_RC_3 float(53) NULL,
	Actual_RC_4 float(53) NULL,
	Actual_RC_5 float(53) NULL,
	Actual_RC_6 float(53) NULL,
	Actual_RC_7 float(53) NULL,
	Actual_RC_8 float(53) NULL,
	Actual_RC_9 float(53) NULL,
	Actual_RC_10 float(53) NULL,
	Actual_RC_11 float(53) NULL,
	Actual_RC_12 float(53) NULL,
	Actual_RC_13 float(53) NULL,
	Actual_RC_14 float(53) NULL,
	Actual_RC_15 float(53) NULL,
	Actual_RC_16 float(53) NULL,
	Actual_RC_17 float(53) NULL,
	Actual_RC_18 float(53) NULL,
	Actual_RC_19 float(53) NULL,
	Actual_RC_20 float(53) NULL,
	Actual_RC_21 float(53) NULL,
	Actual_RC_22 float(53) NULL,
	Actual_RC_23 float(53) NULL,
	Actual_RC_24 float(53) NULL,
	Actual_RC_25 float(53) NULL,
	Actual_RC_26 float(53) NULL,
	Actual_RC_27 float(53) NULL,
	Actual_RC_28 float(53) NULL,
	Actual_RC_29 float(53) NULL,
	Actual_RC_30 float(53) NULL,
	Actual_RC_31 float(53) NULL
END
GO


IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'Actual_RC_1' AND Object_ID = Object_ID(N'BUDGET_TOC'))
BEGIN
ALTER TABLE dbo.BUDGET_TOC ADD
	Actual_RC_1 float(53) NULL,
	Actual_RC_2 float(53) NULL,
	Actual_RC_3 float(53) NULL,
	Actual_RC_4 float(53) NULL,
	Actual_RC_5 float(53) NULL,
	Actual_RC_6 float(53) NULL,
	Actual_RC_7 float(53) NULL,
	Actual_RC_8 float(53) NULL,
	Actual_RC_9 float(53) NULL,
	Actual_RC_10 float(53) NULL,
	Actual_RC_11 float(53) NULL,
	Actual_RC_12 float(53) NULL,
	Actual_RC_13 float(53) NULL,
	Actual_RC_14 float(53) NULL,
	Actual_RC_15 float(53) NULL,
	Actual_RC_16 float(53) NULL,
	Actual_RC_17 float(53) NULL,
	Actual_RC_18 float(53) NULL,
	Actual_RC_19 float(53) NULL,
	Actual_RC_20 float(53) NULL,
	Actual_RC_21 float(53) NULL,
	Actual_RC_22 float(53) NULL,
	Actual_RC_23 float(53) NULL,
	Actual_RC_24 float(53) NULL,
	Actual_RC_25 float(53) NULL,
	Actual_RC_26 float(53) NULL,
	Actual_RC_27 float(53) NULL,
	Actual_RC_28 float(53) NULL,
	Actual_RC_29 float(53) NULL,
	Actual_RC_30 float(53) NULL,
	Actual_RC_31 float(53) NULL
END
GO
--multibase currency
--IF EXISTS ( SELECT * FROM   sysobjects WHERE  id = object_id(N'[dbo].Update_Closing_Balance_GL') and OBJECTPROPERTY(id, N'IsProcedure') = 1 )
--BEGIN DROP PROCEDURE Update_Closing_Balance_GL END 
--GO
--CREATE Procedure Update_Closing_Balance_GL (@P_Branch Varchar(10), @P_pMth as Smallint, @P_pYr as Smallint,@P_Mth as Smallint, @P_Yr as Smallint)
--as  
--Insert into GL(Branch,[Month],[Year],Account,Starting,Ending,Closing, Starting_RC, Ending_RC, Closing_RC, Revaluation, Revaluation_RC)
--Select Branch,@P_Mth, @P_Yr,Account,
--Ending,Ending, Case When @P_Mth<>1 Then Closing+Ending-Starting Else 0 End,
--Ending_RC, Ending_RC, Case When @P_Mth<>1 Then Closing_RC+Ending_RC-Starting_RC Else 0 End,0,0 
--From GL Where GL.Branch=@P_Branch and GL.[Month]=@P_pMth and GL.[Year]=@P_pYr

--GO  

--IF EXISTS ( SELECT * FROM   sysobjects WHERE  id = object_id(N'[dbo].Update_Closing_Balance_GL_FX') and OBJECTPROPERTY(id, N'IsProcedure') = 1 )
--BEGIN DROP PROCEDURE Update_Closing_Balance_GL_FX END 
--GO
--CREATE  Procedure Update_Closing_Balance_GL_FX (@P_Branch Varchar(10), @P_pMth as Smallint, @P_pYr as Smallint,@P_Mth as Smallint, @P_Yr as Smallint)
--as
--Insert into GL_FX(Branch,[Month],[Year],Account,Currency,Starting,Ending, Closing, Starting_BC, Ending_BC, Closing_BC, Starting_RC, Ending_RC, Closing_RC, Revaluation, Revaluation_RC)
--Select Branch,@P_Mth, @P_Yr,Account,Currency,
--Ending,Ending,Case When @P_Mth<>1 Then Closing+Ending-Starting Else 0 End,
--Ending_BC,Ending_BC,Case When @P_Mth<>1 Then Closing_BC+Ending_BC-Starting_BC Else 0 end,
--Ending_RC,Ending_RC,Case When @P_Mth<>1 Then Closing_RC+Ending_RC-Starting_RC Else 0 end,0,0	
--From GL_FX Where GL_FX.Branch=@P_Branch and GL_FX.[Month]=@P_pMth and GL_FX.[Year]=@P_pYr

--GO
--IF EXISTS ( SELECT * FROM   sysobjects WHERE  id = object_id(N'[dbo].Update_Closing_Balance_CA_FX') and OBJECTPROPERTY(id, N'IsProcedure') = 1 )
--BEGIN DROP PROCEDURE Update_Closing_Balance_CA_FX END 
--GO
--CREATE  Procedure Update_Closing_Balance_CA_FX (@P_Branch Varchar(10), @P_pMth as Smallint, @P_pYr as Smallint,@P_Mth as Smallint, @P_Yr as Smallint)
--as
--Insert into CA_FX(Branch,[Month],[Year],Account,Currency,ComAcc,Starting,Ending, Closing, Starting_BC, Ending_BC, Closing_BC, Starting_RC, Ending_RC, Closing_RC, Revaluation, Revaluation_RC)
--Select Branch,@P_Mth, @P_Yr,Account,Currency,ComAcc, 
--Ending,Ending,Case When @P_Mth<>1 Then Closing+Ending-Starting Else 0 End,
--Ending_BC,Ending_BC,Case When @P_Mth<>1 Then Closing_BC+Ending_BC-Starting_BC Else 0 end,
--Ending_RC,Ending_RC,Case When @P_Mth<>1 Then Closing_RC+Ending_RC-Starting_RC Else 0 end,0,0
--From CA_FX Where CA_FX.Branch=@P_Branch and CA_FX.[Month]=@P_pMth and CA_FX.[Year]=@P_pYr

--GO

--IF EXISTS ( SELECT * FROM   sysobjects WHERE  id = object_id(N'[dbo].Update_Closing_Balance_SL_FX') and OBJECTPROPERTY(id, N'IsProcedure') = 1 )
--BEGIN DROP PROCEDURE Update_Closing_Balance_SL_FX END 
--GO
--CREATE Procedure Update_Closing_Balance_SL_FX (@P_Branch Varchar(10), @P_pMth as Smallint, @P_pYr as Smallint,@P_Mth as Smallint, @P_Yr as Smallint)
--as
--Insert into SL_FX(Branch,[Month],[Year],Account,Currency,ProAcc, Starting,Ending, Closing, Starting_BC, Ending_BC, Closing_BC, Starting_RC, Ending_RC, Closing_RC, Revaluation, Revaluation_RC)
--Select Branch,@P_Mth, @P_Yr,Account,Currency,ProAcc, 
--Ending,Ending,Case When @P_Mth<>1 Then Closing+Ending-Starting Else 0 End,
--Ending_BC,Ending_BC,Case When @P_Mth<>1 Then Closing_BC+Ending_BC-Starting_BC Else 0 end,
--Ending_RC,Ending_RC,Case When @P_Mth<>1 Then Closing_RC+Ending_RC-Starting_RC Else 0 end,0,0
--From SL_FX Where SL_FX.Branch=@P_Branch and SL_FX.[Month]=@P_pMth and SL_FX.[Year]=@P_pYr

--GO

if exists (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[Journal]') ) BEGIN DROP VIEW [dbo].Journal  END
GO
CREATE View Journal   
as
Select Voucher, Account, Currency,Debit_OC, Credit_OC, Debit, Credit, Debit_RC, Credit_RC, Description, CT, Last_Opr, Last_Date, Last_Time, SortNo
from dbo.nJournal Journal
Union All
Select Voucher, Account, Currency,Debit_OC, Credit_OC, Debit, Credit, Debit_RC, Credit_RC, Description, CT, Last_Opr, Last_Date, Last_Time, SortNo
from dbo.pJournal Journal
Union All
Select Voucher, Account, Currency,Debit_OC, Credit_OC, Debit, Credit, Debit_RC, Credit_RC, Description, CT, Last_Opr, Last_Date, Last_Time, SortNo
from dbo.mJournal Journal

GO

if exists (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[Voucher]') ) BEGIN DROP VIEW [dbo].Voucher  END
GO
CREATE View Voucher   
as    
Select V.Voucher, V.Date, V.VType, V.Remarks, V.Currency, V.Nominal_CC, V.Rate, V.Rate_RC, V.Nominal, V.Branch, V.Num_Doc, V.SL_Cat, V.ProAcc, V.ComAcc, V.RefNo, V.RefDate, V.RefType, V.DueDate, V.DebtorF, V.ChequeF, V.CreditorF, V.Diff_CC, V.Diff, V.Vat_CC,    
V.Tax_CC, V.VatF, V.TaxF, V.PaymentF, V.ReceiptF, V.TaxType, V.BranchF, V.CT, V.NDueDate, V.MDueDate, V.DocNo, V.BackDatedF, V.AccountNo, V.BankAccount, V.BankName, V.Last_Date, V.Last_Time, V.Last_Opr, V.PDate, V.Payment_CC, V.Payment_OC, V.NPayment, V.TaxPayment_CC,    
V.TaxPayment_OC, V.Status, V.PrintDate, V.PrintUser, V.Source, V.SourceF, V.Posting_Flag, V.Investment, V.InvestmentF, V.Asset, V.AssetF,
V.REQUESTF , V.RequestMessage, V.RequestName
from dbo.nVoucher V    
Union All    
Select V.Voucher, V.Date, V.VType, V.Remarks, V.Currency, V.Nominal_CC, V.Rate, V.Rate_RC, V.Nominal, V.Branch, V.Num_Doc, V.SL_Cat, V.ProAcc, V.ComAcc, V.RefNo, V.RefDate, V.RefType, V.DueDate, V.DebtorF, V.ChequeF, V.CreditorF, V.Diff_CC, V.Diff, V.Vat_CC,    
V.Tax_CC, V.VatF, V.TaxF, V.PaymentF, V.ReceiptF, V.TaxType, V.BranchF, V.CT, V.NDueDate, V.MDueDate, V.DocNo, V.BackDatedF, V.AccountNo, V.BankAccount, V.BankName, V.Last_Date, V.Last_Time, V.Last_Opr, V.PDate, V.Payment_CC, V.Payment_OC, V.NPayment, V.TaxPayment_CC,         
V.TaxPayment_OC, V.Status, V.PrintDate, V.PrintUser, V.Source, V.SourceF, V.Posting_Flag, V.Investment, V.InvestmentF, V.Asset, V.AssetF,
V.REQUESTF , V.RequestMessage, V.RequestName
from dbo.pVoucher V    
Union All    
Select V.Voucher, V.Date, V.VType, V.Remarks, V.Currency, V.Nominal_CC, V.Rate, V.Rate_RC, V.Nominal, V.Branch, V.Num_Doc, V.SL_Cat, V.ProAcc, V.ComAcc, V.RefNo, V.RefDate, V.RefType, V.DueDate, V.DebtorF, V.ChequeF, V.CreditorF, V.Diff_CC, V.Diff, V.Vat_CC,    
V.Tax_CC, V.VatF, V.TaxF, V.PaymentF, V.ReceiptF, V.TaxType, V.BranchF, V.CT, V.NDueDate, V.MDueDate, V.DocNo, V.BackDatedF, V.AccountNo, V.BankAccount, V.BankName, V.Last_Date, V.Last_Time, V.Last_Opr, V.PDate, V.Payment_CC, V.Payment_OC, V.NPayment, V.TaxPayment_CC,         
V.TaxPayment_OC, V.Status, V.PrintDate, V.PrintUser, V.Source, V.SourceF, V.Posting_Flag, V.Investment, V.InvestmentF,  V.Asset, V.AssetF,
V.REQUESTF , V.RequestMessage, V.RequestName
from dbo.mVoucher V 

go


--18 apr 2017
IF NOT EXISTS(SELECT * FROM SYSFORM WHERE FNAME='ALLOWIGNORESTNC')
BEGIN
insert into sysform(FName, Description, FCode, Requestf)
Select 'ALLOWIGNORESTNC', 'Allow Ignore STNC Date','ACTIVITIES',0
end
go

--tuning script upload claim
DROP PROCEDURE [dbo].[QCLACC_3]
GO
CREATE PROCEDURE [dbo].[QCLACC_3] (@P_POLICYNO AS VARCHAR(255), @P_CERTIFICATENO VARCHAR(255), @P_REFNO varchar(50)='', @P_TOC varchar(10)='')     
AS     
SELECT TOP 10 ACCEPTANCE.ANO, ACCEPTANCE.POLICYNO, ACCEPTANCE.CERTIFICATENO, ACCEPTANCE.AID, COVER.INSURED, COVER.ISTYPE, ACCEPTANCE.TOC, ACCEPTANCE.SDATE, ACCEPTANCE.EDATE, Cover.PHolder, ACCEPTANCE.BRANCH, ACCEPTANCE.ANAME, PROFILE.RESTRICTEDF, PROFILE.
NAME, ACCEPTANCE.PDATE, ACCEPTANCE.PPDATE, ACCEPTANCE.NCDATE,  ACCEPTANCE.EXTPERIOD,     
Case When GenDTab.Description is not null then ACCEPTANCE.ValueDesc else '' end as Description,     
Case When ISource.ID is null then ACCEPTANCE.AID else ISource.ID end as Payment,     
Case When ISource.ID is null then Profile.Name else PProfile.Name end as Payment_Name     
FROM ACCEPTANCE WITH (INDEX(I_Acceptance_PolicyNo_CertificateNo))  
Left Join GenDTab On (GenDTab.FLDID=ACCEPTANCE.FLDID AND GenDTab.ValueID=ACCEPTANCE.ValueID)  
Inner Join COVER on (Cover.CNO=Acceptance.CNO)  
Left Join ISource On (ISource.CNO=Cover.CNO)   
Left Join Profile PProfile On (PProfile.ID=ISource.ID)  
Left Join Profile on (Profile.ID=Acceptance.AID)  
WHERE ACCEPTANCE.ATYPE Not In ('A','C') AND ACCEPTANCE.AStatus not in ('W','T') and COVER.CStatus not in ('R','P','C')     
AND ACCEPTANCE.PDATE<ACCEPTANCE.PPDATE AND ACCEPTANCE.ANO<>ACCEPTANCE.LANO   
AND ACCEPTANCE.POLICYNO<>'' AND ACCEPTANCE.POLICYNO LIKE @P_POLICYNO AND ACCEPTANCE.CERTIFICATENO LIKE @P_CERTIFICATENO     
AND ACCEPTANCE.TOC LIKE @P_TOC+'%' AND ACCEPTANCE.REFNO LIKE @P_REFNO+'%'  
ORDER BY ACCEPTANCE.ANO DESC     
go

--27 apr 2017
IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'AmountPCT' AND Object_ID = Object_ID(N'TOP_FD'))
BEGIN
ALTER TABLE dbo.TOP_FD ADD	AmountPCT float(53) NULL
DECLARE @v sql_variant 
SET @v = N'Fee and Duty in Percentage of Premium'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'TOP_FD', N'COLUMN', N'AmountPCT'
END
GO


update TOP_FD set AmountPCT=0 where AmountPCT is null
go

--perbaikan save remarks
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF__ProAcc__Remarks_B__0A9FF7E0]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[ProAcc] ADD  CONSTRAINT [DF__ProAcc__Remarks_B__0A9FF7E0]  DEFAULT ('') FOR Remarks
END

GO





--perbaikan bugs upload scheme object ref not set 
DROP FUNCTION fn_Get_Age
GO
CREATE FUNCTION [dbo].[fn_Get_Age] (@P_ValueDate as varchar(50), @P_CurrDate as DateTime) 
RETURNS Integer 
AS 
BEGIN 
Declare @P_Year as integer 
Declare @P_Age as integer 
Declare @P_Date as DateTime 
Select @P_Date=Case 
               When isdate(@P_ValueDate)=1 then cast(@P_ValueDate as DateTime) 
               When isnumeric(@P_ValueDate)=1 and isdate('01/01/'+@P_ValueDate)=1 then cast('01/01/'+@P_ValueDate as DateTime) 
               else @P_CurrDate 
               end 
Select @P_Age=round((Year(@P_CurrDate)*12+Month(@P_CurrDate)-Year(@P_Date)*12-Month(@P_Date))/12,0) 
return(@P_Age) 
END
go

-- Perbaikan Rounding inconsisten loss item ketika proses claim

DROP procedure QInConsistent_LossItem
GO
CREATE  procedure QInConsistent_LossItem(@P_CNO integer)     
as     
Declare @P_LossDate as smalldatetime        
Declare @P_LossTime as varchar(5)        
Declare @P_EventNo as int      
Declare @P_COL as varchar(10)        
        
Select @P_LossDate=LossDate, @P_LossTime=LossTime, @P_EventNo=EventNo, @P_Col=COL
from Claim Where CNO=@P_CNO        
                       
Select TOP 1 CLLOSS.INO,CLLOSS.NOC  
from CLLOSS Where CNO=@P_CNO And not Exists  
(  
Select ICOVER.INO,NOC.NOC  
from ICOVER, ICOVERNOC, NOC, ACCEPTANCE  
Where ICOVERNOC.INO=ICOVER.INO AND NOC.NOC=ICOVERNOC.NOC AND NOC.TOI=ICOVER.TOI AND ICOVER.INO=CLLOSS.INO AND NOC.NOC=CLLOSS.NOC
AND ACCEPTANCE.ANO=ICOVER.ANO  
AND ((ICOVERNOC.SDATE<=@P_LOSSDATE AND ACCEPTANCE.ExclusiveF=1) or ((ICOVERNOC.SDATE<@P_LOSSDATE or (ICOVERNOC.SDATE=@P_LOSSDATE AND ACCEPTANCE.STIME<=@P_LOSSTIME)) AND ACCEPTANCE.ExclusiveF=0))                     
AND ((dbo.fn_Get_ExtPeriodDate(ACCEPTANCE.ExtPeriod, ACCEPTANCE.ExtPeriodInDaysF, ICOVERNOC.EDATE)>@P_LOSSDATE AND ACCEPTANCE.ExclusiveF=1) or ((dbo.fn_Get_ExtPeriodDate(ACCEPTANCE.ExtPeriod, ACCEPTANCE.ExtPeriodInDaysF, ICOVERNOC.EDATE)>@P_LOSSDATE or (dbo.fn_Get_ExtPeriodDate(ACCEPTANCE.ExtPeriod, ACCEPTANCE.ExtPeriodInDaysF, ICOVERNOC.EDATE)=@P_LOSSDATE AND ACCEPTANCE.ETIME>@P_LOSSTIME)) AND ACCEPTANCE.ExclusiveF=0))                              
AND
ABS(CASE 
WHEN ICOVERNOC.AMOUNT<>0 AND ICOVERNOC.PCT*ICOVER.AMOUNT/100<>0 THEN
 CASE WHEN ICOVERNOC.AMOUNT>ICOVERNOC.PCT*ICOVER.AMOUNT/100 THEN ICOVERNOC.PCT*ICOVER.AMOUNT/100 ELSE ICOVERNOC.AMOUNT END
WHEN ICOVERNOC.AMOUNT<>0 THEN ICOVERNOC.AMOUNT
ELSE ICOVERNOC.PCT*ICOVER.AMOUNT/100
END-CLLOSS.DECLARED)>1
  
UNION ALL  
    
Select ICOVER.INO, NOC.NOC  
From RCOVER, Col, RATECOV, PCLASS, ICOVER, NOC, ACCEPTANCE, COLNOCCLASS        
Where RCOVER.ANO=ICOVER.ANO AND ACCEPTANCE.ANO=RCOVER.ANO AND COL.COL=@P_COL      
AND ((RCOVER.SDATE<=@P_LOSSDATE AND ACCEPTANCE.ExclusiveF=1) or ((RCOVER.SDATE<@P_LOSSDATE or (RCOVER.SDATE=@P_LOSSDATE AND ACCEPTANCE.STIME<=@P_LOSSTIME)) AND ACCEPTANCE.ExclusiveF=0))                     
AND ((dbo.fn_Get_ExtPeriodDate(ACCEPTANCE.ExtPeriod, ACCEPTANCE.ExtPeriodInDaysF, RCOVER.EDATE)>@P_LOSSDATE AND ACCEPTANCE.ExclusiveF=1) or ((dbo.fn_Get_ExtPeriodDate(ACCEPTANCE.ExtPeriod, ACCEPTANCE.ExtPeriodInDaysF, RCOVER.EDATE)>@P_LOSSDATE or (dbo.fn_Get_ExtPeriodDate(ACCEPTANCE.ExtPeriod, ACCEPTANCE.ExtPeriodInDaysF, RCOVER.EDATE)=@P_LOSSDATE AND ACCEPTANCE.ETIME>@P_LOSSTIME)) AND ACCEPTANCE.ExclusiveF=0))                    
AND RATECOV.CODE=RCOVER.CODE AND RATECOV.TOR=COL.TOR AND PCLASS.TOR=COL.TOR AND PCLASS.TOI=ICOVER.TOI                        
AND NOC.TOI=ICOVER.TOI AND NOC.NOC=CLLOSS.NOC
AND NOT EXISTS (SELECT TOP 1 ICOVERNOC.NOC FROM ICOVERNOC WHERE ICOVERNOC.INO=CLLOSS.INO AND ICOVERNOC.NOC=NOC.NOC)                        
AND COLNOCCLASS.NOC=NOC.NOC AND COLNOCCLASS.COL=@P_COL
AND (PCLASS.CTLF=0 OR NOC.CTLF=PCLASS.CTLF)
AND
ABS(CASE                        
 WHEN @P_EVENTNO=-1 THEN                        
        CASE                        
        WHEN RCOVER.PCTLOSS=0 OR ICOVER.NOTDECRF=1 OR ICOVER.NOTFLF=1 THEN ICOVER.AMOUNT 
        ELSE ICOVER.AMOUNT*RCOVER.PCTLOSS/100 END                        
 Else                        
        CASE                        
        WHEN RCOVER.PCTLOSS=0 OR ICOVER.NOTDECRF=1 OR ICOVER.NOTFLF=1 THEN ICOVER.AMOUNT_AOE                
        ELSE ICOVER.AMOUNT_AOE*RCOVER.PCTLOSS/100 END                        
 END-CLLOSS.DECLARED)>1
)  
go


Drop Procedure Get_Dedudctible_Amount
GO 
Create Procedure Get_Dedudctible_Amount(@P_ANO as Int, @Code as varchar(10), @Amount as Float)
as
Declare @DiscAmount as float
Declare @VCode as varchar(10)

If (@Code in ('O05-001')) begin

	Select @VCode=
	A2.ValueID1 from acceptance A1, AInfo A2 where A1.ANO = A2.ANO and A1.TOC = '3201' 

	Select @DiscAmount = 
	 Case When @VCode in ('110','120','210','220','230','320','340','420','520','540','730','801','802','803','804','805','806') then
			case when @Amount > 5000 then 5000 + (@Amount-5000) * 0.1 
				 Else @Amount	
			End
		  When @VCode in ('610','620','630') then
			case When @Amount >1000 then 1000 + (@Amount-1000) * 0.2
				 Else @Amount
			End
	 End
End
Else If (@Code in ('P32-001')) begin
	Select @VCode=
	A2.ValueID1 from acceptance A1, AInfo A2 where A1.ANO = A2.ANO and A1.TOC = '3201' 

	Select @DiscAmount = 
	 Case When @VCode in ('110','120','210','220','230','320','340','420','520','540','730','801','802','803','804','805','806','610','620','630') then
			case when @Amount > 5000 then (5000*0.1) + ((@Amount-5000) * 0.01)
				 Else @Amount	
			End
	 End
end
Else Set @DiscAmount = @Amount
Select @DiscAmount as 'Disc'
 


go

--perbaikan bugs saat textchanged di loss item..error karena field currency_oc belum ada 
drop procedure [QCLACC01_1]
GO
CREATE Procedure [dbo].[QCLACC01_1] (@PCNO AS INTEGER, @PTOI AS Nvarchar(10))      
AS      
SELECT Distinct cast(ICOVER.REMARK as varchar(255)) AS REMARK, ICOVER.CURRENCY,      
CASE      
 WHEN CLAIM.EVENTNO=-1 THEN      
        CASE      
        WHEN ICOVER.NOTDECRF=1 OR RCOVER.PCTLOSS=0 THEN ICOVER.AMOUNT      
        ELSE ICOVER.AMOUNT*RCOVER.PCTLOSS/100 END      
 Else      
        CASE      
        WHEN ICOVER.NOTDECRF=1 OR RCOVER.PCTLOSS=0 THEN ICOVER.AMOUNT_AOE      
        ELSE ICOVER.AMOUNT_AOE*RCOVER.PCTLOSS/100 END      
 END AS SI, ICOVER.INO, ICOVER.TOI, ICOVER.TOTAL, ICOVER.INDEMNITY, TOI.AGREEDVALF, ICOVER.CURRENCY_OC, ICOVER.RATE_OC             
From ICOVER, CLAIM, Col, ICALC, RCOVER, TOI, acceptance      
WHERE CLAIM.CNO=@PCNO AND ICOVER.ANO=CLAIM.ANO AND RCOVER.ANO=CLAIM.ANO AND ACCEPTANCE.ANO=CLAIM.ANO      
AND ICALC.ANO=CLAIM.ANO AND ICOVER.INO=ICALC.INO AND RCOVER.CODE=ICALC.CODE      
AND ((RCOVER.SDATE<=CLAIM.LOSSDATE And Acceptance.ExclusiveF=1) or ((RCOVER.SDATE<CLAIM.LOSSDATE or (RCOVER.SDATE=CLAIM.LOSSDATE and '12:00'<=Claim.LossTime)) and Acceptance.ExclusiveF=0))     
AND ((dbo.fn_Get_ExtPeriodDate(ACCEPTANCE.ExtPeriod, ACCEPTANCE.ExtPeriodInDaysF, RCOVER.EDATE)>CLAIM.LOSSDATE AND ACCEPTANCE.ExclusiveF=1) or ((dbo.fn_Get_ExtPeriodDate(ACCEPTANCE.ExtPeriod, ACCEPTANCE.ExtPeriodInDaysF, RCOVER.EDATE)>CLAIM.LOSSDATE 
or (dbo.fn_Get_ExtPeriodDate(ACCEPTANCE.ExtPeriod, ACCEPTANCE.ExtPeriodInDaysF, RCOVER.EDATE)=CLAIM.LOSSDATE AND '12:00'>Claim.LossTime)) AND ACCEPTANCE.ExclusiveF=0))      
AND COL.COL=CLAIM.COL AND ICALC.TOR=COL.TOR AND TOI.TOI=ICOVER.TOI     
AND ICOVER.TOI=@PTOI

go

--Perbaikan bugs scheme verify karena get_rateloading msh menggunakan fn_get_age menjadi fn_age
DROP Function Get_RateLoading
GO
CREATE Function Get_RateLoading(@P_ANO as int,@P_Code as varchar(20), @P_PDate as datetime) 
RETURNS Float AS        
  
BEGIN       
Declare @RateTab Table (
Code varchar(10),
ValueID1 varchar(15),
ValueID2 varchar(15),
ValueID3 varchar(15),
ValueID4 varchar(15),
ValueID5 varchar(15),
ValueID6 varchar(15),
ValueID7 varchar(15),
ValueID8 varchar(15),
ValueID9 varchar(15),
ValueID10 varchar(15),
ValueID11 varchar(15),
ValueID12 varchar(15),
ValueID13 varchar(15),
ValueID14 varchar(15),
ValueID15 varchar(15)
)

insert into @RateTab
SELECT Top 1 RateTab.Code, 
G1.ValueID as ValueID1,
G2.ValueID as ValueID2,
G3.ValueID as ValueID3,
G4.ValueID as ValueID4,
G5.ValueID as ValueID5,
G6.ValueID as ValueID6,
G7.ValueID as ValueID7,
G8.ValueID as ValueID8,
G9.ValueID as ValueID9,
G10.ValueID as ValueID10,
G11.ValueID as ValueID11,
G12.ValueID as ValueID12,
G13.ValueID as ValueID13,
G14.ValueID as ValueID14,
G15.ValueID as ValueID15

From AInfo 
 INNER JOIN RateTab ON (RateTab.Code=@P_Code)     
 Left Join GenHTab H1 on (H1.FLDID=AInfo.FLDID1)
 Left Join GenHTab H2 on (H2.FLDID=AInfo.FLDID2)
 Left Join GenHTab H3 on (H3.FLDID=AInfo.FLDID3)
 Left Join GenHTab H4 on (H4.FLDID=AInfo.FLDID4)
 Left Join GenHTab H5 on (H5.FLDID=AInfo.FLDID5)
 Left Join GenHTab H6 on (H6.FLDID=AInfo.FLDID6)
 Left Join GenHTab H7 on (H7.FLDID=AInfo.FLDID7)
 Left Join GenHTab H8 on (H8.FLDID=AInfo.FLDID8)
 Left Join GenHTab H9 on (H9.FLDID=AInfo.FLDID9)
 Left Join GenHTab H10 on (H10.FLDID=AInfo.FLDID10)
 Left Join GenHTab H11 on (H11.FLDID=AInfo.FLDID11)
 Left Join GenHTab H12 on (H12.FLDID=AInfo.FLDID12)
 Left Join GenHTab H13 on (H13.FLDID=AInfo.FLDID13)
 Left Join GenHTab H14 on (H14.FLDID=AInfo.FLDID14)
 Left Join GenHTab H15 on (H15.FLDID=AInfo.FLDID15)           
 Left Join GenDTab G1 on (G1.FLDID=AInfo.FLDID1 and ((G1.Formula='AGE' and cast(dbo.fn_Age(AInfo.ValueDesc1,@P_PDate, H1.AGEMETHOD) as varchar(10)) Between G1.FLower and G1.FUpper) or (G1.Formula<>'AGE' and G1.ValueID=AInfo.ValueID1)))            
 Left Join GenDTab G2 on (G2.FLDID=AInfo.FLDID2 and ((G2.Formula='AGE' and cast(dbo.fn_Age(AInfo.ValueDesc2,@P_PDate, H2.AGEMETHOD) as varchar(10)) Between G2.FLower and G2.FUpper) or (G2.Formula<>'AGE' and G2.ValueID=AInfo.ValueID2)))             
 Left Join GenDTab G3 on (G3.FLDID=AInfo.FLDID3 and ((G3.Formula='AGE' and cast(dbo.fn_Age(AInfo.ValueDesc3,@P_PDate, H3.AGEMETHOD) as varchar(10)) Between G3.FLower and G3.FUpper) or (G3.Formula<>'AGE' and G3.ValueID=AInfo.ValueID3)))          
 Left Join GenDTab G4 on (G4.FLDID=AInfo.FLDID4 and ((G4.Formula='AGE' and cast(dbo.fn_Age(AInfo.ValueDesc4,@P_PDate, H4.AGEMETHOD) as varchar(10)) Between G4.FLower and G4.FUpper) or (G4.Formula<>'AGE' and G4.ValueID=AInfo.ValueID4)))          
 Left Join GenDTab G5 on (G5.FLDID=AInfo.FLDID5 and ((G5.Formula='AGE' and cast(dbo.fn_Age(AInfo.ValueDesc5,@P_PDate, H5.AGEMETHOD) as varchar(10)) Between G5.FLower and G5.FUpper) or (G5.Formula<>'AGE' and G5.ValueID=AInfo.ValueID5)))          
 Left Join GenDTab G6 on (G6.FLDID=AInfo.FLDID6 and ((G6.Formula='AGE' and cast(dbo.fn_Age(AInfo.ValueDesc6,@P_PDate, H6.AGEMETHOD) as varchar(10)) Between G6.FLower and G6.FUpper) or (G6.Formula<>'AGE' and G6.ValueID=AInfo.ValueID6)))          
 Left Join GenDTab G7 on (G7.FLDID=AInfo.FLDID7 and ((G7.Formula='AGE' and cast(dbo.fn_Age(AInfo.ValueDesc7,@P_PDate, H7.AGEMETHOD) as varchar(10)) Between G7.FLower and G7.FUpper) or (G7.Formula<>'AGE' and G7.ValueID=AInfo.ValueID7)))          
 Left Join GenDTab G8 on (G8.FLDID=AInfo.FLDID8 and ((G8.Formula='AGE' and cast(dbo.fn_Age(AInfo.ValueDesc8,@P_PDate, H8.AGEMETHOD) as varchar(10)) Between G8.FLower and G8.FUpper) or (G8.Formula<>'AGE' and G8.ValueID=AInfo.ValueID8)))          
 Left Join GenDTab G9 on (G9.FLDID=AInfo.FLDID9 and ((G9.Formula='AGE' and cast(dbo.fn_Age(AInfo.ValueDesc9,@P_PDate, H9.AGEMETHOD) as varchar(10)) Between G9.FLower and G9.FUpper) or (G9.Formula<>'AGE' and G9.ValueID=AInfo.ValueID9)))          
 Left Join GenDTab G10 on (G10.FLDID=AInfo.FLDID10 and ((G10.Formula='AGE' and cast(dbo.fn_Age(AInfo.ValueDesc10,@P_PDate, H10.AGEMETHOD) as varchar(10)) Between G10.FLower and G10.FUpper) or (G10.Formula<>'AGE' and G10.ValueID=AInfo.ValueID10)))          
 Left Join GenDTab G11 on (G11.FLDID=AInfo.FLDID11 and ((G11.Formula='AGE' and cast(dbo.fn_Age(AInfo.ValueDesc11,@P_PDate, H11.AGEMETHOD) as varchar(10)) Between G11.FLower and G11.FUpper) or (G11.Formula<>'AGE' and G11.ValueID=AInfo.ValueID11)))          
 Left Join GenDTab G12 on (G12.FLDID=AInfo.FLDID12 and ((G12.Formula='AGE' and cast(dbo.fn_Age(AInfo.ValueDesc12,@P_PDate, H12.AGEMETHOD) as varchar(10)) Between G12.FLower and G12.FUpper) or (G12.Formula<>'AGE' and G12.ValueID=AInfo.ValueID12)))          
 Left Join GenDTab G13 on (G13.FLDID=AInfo.FLDID13 and ((G13.Formula='AGE' and cast(dbo.fn_Age(AInfo.ValueDesc13,@P_PDate, H13.AGEMETHOD) as varchar(10)) Between G13.FLower and G13.FUpper) or (G13.Formula<>'AGE' and G13.ValueID=AInfo.ValueID13)))          
 Left Join GenDTab G14 on (G14.FLDID=AInfo.FLDID14 and ((G14.Formula='AGE' and cast(dbo.fn_Age(AInfo.ValueDesc14,@P_PDate, H14.AGEMETHOD) as varchar(10)) Between G14.FLower and G14.FUpper) or (G14.Formula<>'AGE' and G14.ValueID=AInfo.ValueID14)))          
 Left Join GenDTab G15 on (G15.FLDID=AInfo.FLDID15 and ((G15.Formula='AGE' and cast(dbo.fn_Age(AInfo.ValueDesc15,@P_PDate, H15.AGEMETHOD) as varchar(10)) Between G15.FLower and G15.FUpper) or (G15.Formula<>'AGE' and G15.ValueID=AInfo.ValueID15)))          
WHERE AINFO.ANO=@P_ANO                       
Order by RateTab.Effective Desc

Declare @Loading as Float
Declare @Temp_Loading as Float
Select @Loading=1

--Rate Loading #1
Select @Temp_Loading=Null
SELECT Top 1 @Temp_Loading=RateCon.Loading
From @RateTab RateTab
INNER JOIN RateCon_M1 RateCon  on (
RateCon.Code=RateTab.Code and RateCon.AllowedF=1                 
and (coalesce(RateCon.ValueID1,'')='' or RateTab.ValueID1 =RateCon.ValueID1)                
And (coalesce(RateCon.ValueID2,'')='' or RateTab.ValueID2 =RateCon.ValueID2)                
And (coalesce(RateCon.ValueID3,'')='' or RateTab.ValueID3 =RateCon.ValueID3)                
And (coalesce(RateCon.ValueID4,'')='' or RateTab.ValueID4 =RateCon.ValueID4)                
And (coalesce(RateCon.ValueID5,'')='' or RateTab.ValueID5 =RateCon.ValueID5)                
And (coalesce(RateCon.ValueID6,'')='' or RateTab.ValueID6 =RateCon.ValueID6)                
And (coalesce(RateCon.ValueID7,'')='' or RateTab.ValueID7 =RateCon.ValueID7)                
And (coalesce(RateCon.ValueID8,'')='' or RateTab.ValueID8 =RateCon.ValueID8)                
And (coalesce(RateCon.ValueID9,'')='' or RateTab.ValueID9 =RateCon.ValueID9)                
And (coalesce(RateCon.ValueID10,'')='' or RateTab.ValueID10 =RateCon.ValueID10)                
And (coalesce(RateCon.ValueID11,'')='' or RateTab.ValueID11 =RateCon.ValueID11)                
And (coalesce(RateCon.ValueID12,'')='' or RateTab.ValueID12 =RateCon.ValueID12)                
And (coalesce(RateCon.ValueID13,'')='' or RateTab.ValueID13 =RateCon.ValueID13)                
And (coalesce(RateCon.ValueID14,'')='' or RateTab.ValueID14 =RateCon.ValueID14)                
And (coalesce(RateCon.ValueID15,'')='' or RateTab.ValueID15 =RateCon.ValueID15)                       
)
Order by   
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

if @Temp_Loading is null
	Select @Temp_Loading=1
	
Select @Loading=@Loading*@Temp_Loading


--Rate Loading #2
Select @Temp_Loading=Null
SELECT Top 1 @Temp_Loading=RateCon.Loading
From @RateTab RateTab
INNER JOIN RateCon_M2 RateCon  on (
RateCon.Code=RateTab.Code and RateCon.AllowedF=1                 
and (coalesce(RateCon.ValueID1,'')='' or RateTab.ValueID1 =RateCon.ValueID1)                
And (coalesce(RateCon.ValueID2,'')='' or RateTab.ValueID2 =RateCon.ValueID2)                
And (coalesce(RateCon.ValueID3,'')='' or RateTab.ValueID3 =RateCon.ValueID3)                
And (coalesce(RateCon.ValueID4,'')='' or RateTab.ValueID4 =RateCon.ValueID4)                
And (coalesce(RateCon.ValueID5,'')='' or RateTab.ValueID5 =RateCon.ValueID5)                
And (coalesce(RateCon.ValueID6,'')='' or RateTab.ValueID6 =RateCon.ValueID6)                
And (coalesce(RateCon.ValueID7,'')='' or RateTab.ValueID7 =RateCon.ValueID7)                
And (coalesce(RateCon.ValueID8,'')='' or RateTab.ValueID8 =RateCon.ValueID8)                
And (coalesce(RateCon.ValueID9,'')='' or RateTab.ValueID9 =RateCon.ValueID9)                
And (coalesce(RateCon.ValueID10,'')='' or RateTab.ValueID10 =RateCon.ValueID10)                
And (coalesce(RateCon.ValueID11,'')='' or RateTab.ValueID11 =RateCon.ValueID11)                
And (coalesce(RateCon.ValueID12,'')='' or RateTab.ValueID12 =RateCon.ValueID12)                
And (coalesce(RateCon.ValueID13,'')='' or RateTab.ValueID13 =RateCon.ValueID13)                
And (coalesce(RateCon.ValueID14,'')='' or RateTab.ValueID14 =RateCon.ValueID14)                
And (coalesce(RateCon.ValueID15,'')='' or RateTab.ValueID15 =RateCon.ValueID15)                       
)
Order by   
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

if @Temp_Loading is null
	Select @Temp_Loading=1
	
Select @Loading=@Loading*@Temp_Loading


--Rate Loading #3
Select @Temp_Loading=Null
SELECT Top 1 @Temp_Loading=RateCon.Loading
From @RateTab RateTab
INNER JOIN RateCon_M3 RateCon  on (
RateCon.Code=RateTab.Code and RateCon.AllowedF=1                 
and (coalesce(RateCon.ValueID1,'')='' or RateTab.ValueID1 =RateCon.ValueID1)                
And (coalesce(RateCon.ValueID2,'')='' or RateTab.ValueID2 =RateCon.ValueID2)                
And (coalesce(RateCon.ValueID3,'')='' or RateTab.ValueID3 =RateCon.ValueID3)                
And (coalesce(RateCon.ValueID4,'')='' or RateTab.ValueID4 =RateCon.ValueID4)                
And (coalesce(RateCon.ValueID5,'')='' or RateTab.ValueID5 =RateCon.ValueID5)                
And (coalesce(RateCon.ValueID6,'')='' or RateTab.ValueID6 =RateCon.ValueID6)                
And (coalesce(RateCon.ValueID7,'')='' or RateTab.ValueID7 =RateCon.ValueID7)                
And (coalesce(RateCon.ValueID8,'')='' or RateTab.ValueID8 =RateCon.ValueID8)                
And (coalesce(RateCon.ValueID9,'')='' or RateTab.ValueID9 =RateCon.ValueID9)                
And (coalesce(RateCon.ValueID10,'')='' or RateTab.ValueID10 =RateCon.ValueID10)                
And (coalesce(RateCon.ValueID11,'')='' or RateTab.ValueID11 =RateCon.ValueID11)                
And (coalesce(RateCon.ValueID12,'')='' or RateTab.ValueID12 =RateCon.ValueID12)                
And (coalesce(RateCon.ValueID13,'')='' or RateTab.ValueID13 =RateCon.ValueID13)                
And (coalesce(RateCon.ValueID14,'')='' or RateTab.ValueID14 =RateCon.ValueID14)                
And (coalesce(RateCon.ValueID15,'')='' or RateTab.ValueID15 =RateCon.ValueID15)                       
)
Order by   
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

if @Temp_Loading is null
	Select @Temp_Loading=1
	
Select @Loading=@Loading*@Temp_Loading


--Rate Loading #4
Select @Temp_Loading=Null
SELECT Top 1 @Temp_Loading=RateCon.Loading
From @RateTab RateTab
INNER JOIN RateCon_M4 RateCon  on (
RateCon.Code=RateTab.Code and RateCon.AllowedF=1                 
and (coalesce(RateCon.ValueID1,'')='' or RateTab.ValueID1 =RateCon.ValueID1)                
And (coalesce(RateCon.ValueID2,'')='' or RateTab.ValueID2 =RateCon.ValueID2)                
And (coalesce(RateCon.ValueID3,'')='' or RateTab.ValueID3 =RateCon.ValueID3)                
And (coalesce(RateCon.ValueID4,'')='' or RateTab.ValueID4 =RateCon.ValueID4)                
And (coalesce(RateCon.ValueID5,'')='' or RateTab.ValueID5 =RateCon.ValueID5)                
And (coalesce(RateCon.ValueID6,'')='' or RateTab.ValueID6 =RateCon.ValueID6)                
And (coalesce(RateCon.ValueID7,'')='' or RateTab.ValueID7 =RateCon.ValueID7)                
And (coalesce(RateCon.ValueID8,'')='' or RateTab.ValueID8 =RateCon.ValueID8)                
And (coalesce(RateCon.ValueID9,'')='' or RateTab.ValueID9 =RateCon.ValueID9)                
And (coalesce(RateCon.ValueID10,'')='' or RateTab.ValueID10 =RateCon.ValueID10)                
And (coalesce(RateCon.ValueID11,'')='' or RateTab.ValueID11 =RateCon.ValueID11)                
And (coalesce(RateCon.ValueID12,'')='' or RateTab.ValueID12 =RateCon.ValueID12)                
And (coalesce(RateCon.ValueID13,'')='' or RateTab.ValueID13 =RateCon.ValueID13)                
And (coalesce(RateCon.ValueID14,'')='' or RateTab.ValueID14 =RateCon.ValueID14)                
And (coalesce(RateCon.ValueID15,'')='' or RateTab.ValueID15 =RateCon.ValueID15)                       
)
Order by   
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

if @Temp_Loading is null
	Select @Temp_Loading=1
	
Select @Loading=@Loading*@Temp_Loading


--Rate Loading #5
Select @Temp_Loading=Null
SELECT Top 1 @Temp_Loading=RateCon.Loading
From @RateTab RateTab
INNER JOIN RateCon_M5 RateCon  on (
RateCon.Code=RateTab.Code and RateCon.AllowedF=1                 
and (coalesce(RateCon.ValueID1,'')='' or RateTab.ValueID1 =RateCon.ValueID1)                
And (coalesce(RateCon.ValueID2,'')='' or RateTab.ValueID2 =RateCon.ValueID2)                
And (coalesce(RateCon.ValueID3,'')='' or RateTab.ValueID3 =RateCon.ValueID3)                
And (coalesce(RateCon.ValueID4,'')='' or RateTab.ValueID4 =RateCon.ValueID4)                
And (coalesce(RateCon.ValueID5,'')='' or RateTab.ValueID5 =RateCon.ValueID5)                
And (coalesce(RateCon.ValueID6,'')='' or RateTab.ValueID6 =RateCon.ValueID6)                
And (coalesce(RateCon.ValueID7,'')='' or RateTab.ValueID7 =RateCon.ValueID7)                
And (coalesce(RateCon.ValueID8,'')='' or RateTab.ValueID8 =RateCon.ValueID8)                
And (coalesce(RateCon.ValueID9,'')='' or RateTab.ValueID9 =RateCon.ValueID9)                
And (coalesce(RateCon.ValueID10,'')='' or RateTab.ValueID10 =RateCon.ValueID10)                
And (coalesce(RateCon.ValueID11,'')='' or RateTab.ValueID11 =RateCon.ValueID11)                
And (coalesce(RateCon.ValueID12,'')='' or RateTab.ValueID12 =RateCon.ValueID12)                
And (coalesce(RateCon.ValueID13,'')='' or RateTab.ValueID13 =RateCon.ValueID13)                
And (coalesce(RateCon.ValueID14,'')='' or RateTab.ValueID14 =RateCon.ValueID14)                
And (coalesce(RateCon.ValueID15,'')='' or RateTab.ValueID15 =RateCon.ValueID15)                       
)
Order by   
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

if @Temp_Loading is null
	Select @Temp_Loading=1
	
Select @Loading=@Loading*@Temp_Loading

--Rate Loading #6
Select @Temp_Loading=Null
SELECT Top 1 @Temp_Loading=RateCon.Loading
From @RateTab RateTab
INNER JOIN RateCon_M6 RateCon  on (
RateCon.Code=RateTab.Code and RateCon.AllowedF=1                 
and (coalesce(RateCon.ValueID1,'')='' or RateTab.ValueID1 =RateCon.ValueID1)                
And (coalesce(RateCon.ValueID2,'')='' or RateTab.ValueID2 =RateCon.ValueID2)                
And (coalesce(RateCon.ValueID3,'')='' or RateTab.ValueID3 =RateCon.ValueID3)                
And (coalesce(RateCon.ValueID4,'')='' or RateTab.ValueID4 =RateCon.ValueID4)                
And (coalesce(RateCon.ValueID5,'')='' or RateTab.ValueID5 =RateCon.ValueID5)                
And (coalesce(RateCon.ValueID6,'')='' or RateTab.ValueID6 =RateCon.ValueID6)                
And (coalesce(RateCon.ValueID7,'')='' or RateTab.ValueID7 =RateCon.ValueID7)                
And (coalesce(RateCon.ValueID8,'')='' or RateTab.ValueID8 =RateCon.ValueID8)                
And (coalesce(RateCon.ValueID9,'')='' or RateTab.ValueID9 =RateCon.ValueID9)                
And (coalesce(RateCon.ValueID10,'')='' or RateTab.ValueID10 =RateCon.ValueID10)                
And (coalesce(RateCon.ValueID11,'')='' or RateTab.ValueID11 =RateCon.ValueID11)                
And (coalesce(RateCon.ValueID12,'')='' or RateTab.ValueID12 =RateCon.ValueID12)                
And (coalesce(RateCon.ValueID13,'')='' or RateTab.ValueID13 =RateCon.ValueID13)                
And (coalesce(RateCon.ValueID14,'')='' or RateTab.ValueID14 =RateCon.ValueID14)                
And (coalesce(RateCon.ValueID15,'')='' or RateTab.ValueID15 =RateCon.ValueID15)                       
)
Order by   
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

if @Temp_Loading is null
	Select @Temp_Loading=1
	
Select @Loading=@Loading*@Temp_Loading


--Rate Loading #7
Select @Temp_Loading=Null
SELECT Top 1 @Temp_Loading=RateCon.Loading
From @RateTab RateTab
INNER JOIN RateCon_M7 RateCon  on (
RateCon.Code=RateTab.Code and RateCon.AllowedF=1                 
and (coalesce(RateCon.ValueID1,'')='' or RateTab.ValueID1 =RateCon.ValueID1)                
And (coalesce(RateCon.ValueID2,'')='' or RateTab.ValueID2 =RateCon.ValueID2)                
And (coalesce(RateCon.ValueID3,'')='' or RateTab.ValueID3 =RateCon.ValueID3)                
And (coalesce(RateCon.ValueID4,'')='' or RateTab.ValueID4 =RateCon.ValueID4)                
And (coalesce(RateCon.ValueID5,'')='' or RateTab.ValueID5 =RateCon.ValueID5)                
And (coalesce(RateCon.ValueID6,'')='' or RateTab.ValueID6 =RateCon.ValueID6)                
And (coalesce(RateCon.ValueID7,'')='' or RateTab.ValueID7 =RateCon.ValueID7)                
And (coalesce(RateCon.ValueID8,'')='' or RateTab.ValueID8 =RateCon.ValueID8)                
And (coalesce(RateCon.ValueID9,'')='' or RateTab.ValueID9 =RateCon.ValueID9)                
And (coalesce(RateCon.ValueID10,'')='' or RateTab.ValueID10 =RateCon.ValueID10)                
And (coalesce(RateCon.ValueID11,'')='' or RateTab.ValueID11 =RateCon.ValueID11)                
And (coalesce(RateCon.ValueID12,'')='' or RateTab.ValueID12 =RateCon.ValueID12)                
And (coalesce(RateCon.ValueID13,'')='' or RateTab.ValueID13 =RateCon.ValueID13)                
And (coalesce(RateCon.ValueID14,'')='' or RateTab.ValueID14 =RateCon.ValueID14)                
And (coalesce(RateCon.ValueID15,'')='' or RateTab.ValueID15 =RateCon.ValueID15)                       
)
Order by   
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

if @Temp_Loading is null
	Select @Temp_Loading=1
	
Select @Loading=@Loading*@Temp_Loading

Return @Loading  
END  

GO

DROP Function fn_Age
GO
CREATE Function fn_Age(@sBirthDate varchar(100),@ComparisonDate as smalldatetime, @AgeMethod as int)        
RETURNS INT AS          
BEGIN        
declare @BirthDate as smalldatetime
declare @temp as int          
set @temp=0          
if isdate(@sBirthDate)=1 
	set @BirthDate=cast(@sBirthDate as smalldatetime)
else
	set @BirthDate=@ComparisonDate
        
if @comparisondate<=@BirthDate          
      set @temp=0          
else          
begin          
 set @temp=datediff(year,@BirthDate,@ComparisonDate)       
  if @AgeMethod=4  -- Nearest Birth Date by Month-Day    
  begin              
      if DateAdd(year,@Temp,@BirthDate)>@ComparisonDate      
            set @Temp=@Temp-1      
      if DateDiff(Month,Dateadd(Year,@Temp,@BirthDate),@ComparisonDate) = DateDiff(Month,@ComparisonDate, Dateadd(Year,@Temp+1,@BirthDate))      
      Begin  
  if DateAdd(Month, DateDiff(Month,Dateadd(Year,@Temp,@BirthDate),@ComparisonDate),Dateadd(Year,@Temp,@BirthDate))<@ComparisonDate  
   set @Temp=@Temp+1            
   End  
      else   
      Begin  
  if DateDiff(Month,Dateadd(Year,@Temp,@BirthDate),@ComparisonDate) > DateDiff(Month,@ComparisonDate, Dateadd(Year,@Temp+1,@BirthDate))      
            set @Temp=@Temp+1       
      End  
  end      
  else  
  if @AgeMethod=3 --Next Birth Day      
  begin              
      if DateAdd(year,@Temp,@BirthDate)>@ComparisonDate      
            set @Temp=@Temp-1      
      if DateDiff(day,Dateadd(Year,@Temp,@BirthDate),@ComparisonDate) > 0      
            set @Temp=@Temp+1          
  end        
  else       
  if @AgeMethod=2  -- Nearest Birth Date by Day    
  begin            
      if DateAdd(year,@Temp,@BirthDate)>@ComparisonDate    
            set @Temp=@Temp-1    
      if DateDiff(day,Dateadd(Year,@Temp,@BirthDate),@ComparisonDate) > DateDiff(day,@ComparisonDate, Dateadd(Year,@Temp+1,@BirthDate))    
            set @Temp=@Temp+1        
  end        
  else        
  if @AgeMethod=1 -- Nearest Birth Date by Month      
  begin        
      if DateAdd(year,@Temp,@BirthDate)>@ComparisonDate      
            set @Temp=@Temp-1      
      if DateDiff(Month,Dateadd(Year,@Temp,@BirthDate),@ComparisonDate) > DateDiff(Month,@ComparisonDate, Dateadd(Year,@Temp+1,@BirthDate))      
            set @Temp=@Temp+1       
  end            
  else   -- Year Lapse      
  begin         
      if @temp>0          
       if month(@ComparisonDate)< month(@BirthDate) or (month(@BirthDate)=month(@ComparisonDate) and day(@ComparisonDate)<day(@BirthDate))          
        set @temp=@temp-1            
  end      
end        
        
return @temp      
End

GO

--Perbaikan bugs claim proses karena inconsistent loss item
DROP procedure QInConsistent_LossItem
GO
CREATE  procedure QInConsistent_LossItem(@P_CNO integer)     
as     
Declare @P_LossDate as smalldatetime        
Declare @P_LossTime as varchar(5)        
Declare @P_EventNo as int      
Declare @P_COL as varchar(10)        
        
Select @P_LossDate=LossDate, @P_LossTime=LossTime, @P_EventNo=EventNo, @P_Col=COL
from Claim Where CNO=@P_CNO        
                       
Select TOP 1 CLLOSS.INO,CLLOSS.NOC  
from CLLOSS Where CNO=@P_CNO And not Exists  
(  
Select ICOVER.INO,NOC.NOC  
from ICOVER, ICOVERNOC, NOC, ACCEPTANCE  
Where ICOVERNOC.INO=ICOVER.INO AND NOC.NOC=ICOVERNOC.NOC AND NOC.TOI=ICOVER.TOI AND ICOVER.INO=CLLOSS.INO AND NOC.NOC=CLLOSS.NOC
AND ACCEPTANCE.ANO=ICOVER.ANO  
AND ((ICOVERNOC.SDATE<=@P_LOSSDATE AND ACCEPTANCE.ExclusiveF=1) or ((ICOVERNOC.SDATE<@P_LOSSDATE or (ICOVERNOC.SDATE=@P_LOSSDATE AND ACCEPTANCE.STIME<=@P_LOSSTIME)) AND ACCEPTANCE.ExclusiveF=0))                     
AND ((dbo.fn_Get_ExtPeriodDate(ACCEPTANCE.ExtPeriod, ACCEPTANCE.ExtPeriodInDaysF, ICOVERNOC.EDATE)>@P_LOSSDATE AND ACCEPTANCE.ExclusiveF=1) or ((dbo.fn_Get_ExtPeriodDate(ACCEPTANCE.ExtPeriod, ACCEPTANCE.ExtPeriodInDaysF, ICOVERNOC.EDATE)>@P_LOSSDATE or (dbo.fn_Get_ExtPeriodDate(ACCEPTANCE.ExtPeriod, ACCEPTANCE.ExtPeriodInDaysF, ICOVERNOC.EDATE)=@P_LOSSDATE AND ACCEPTANCE.ETIME>@P_LOSSTIME)) AND ACCEPTANCE.ExclusiveF=0))                              
AND
ABS(CASE 
WHEN ICOVERNOC.AMOUNT<>0 AND ICOVERNOC.PCT*ICOVER.AMOUNT/100<>0 THEN
 CASE WHEN ICOVERNOC.AMOUNT>ICOVERNOC.PCT*ICOVER.AMOUNT/100 THEN ICOVERNOC.PCT*ICOVER.AMOUNT/100 ELSE ICOVERNOC.AMOUNT END
WHEN ICOVERNOC.AMOUNT<>0 THEN ICOVERNOC.AMOUNT
ELSE ICOVERNOC.PCT*ICOVER.AMOUNT/100
END-CLLOSS.DECLARED)>1
  
UNION ALL  
    
Select ICOVER.INO, NOC.NOC  
From RCOVER, Col, RATECOV, PCLASS, ICOVER, NOC, ACCEPTANCE, COLNOCCLASS        
Where RCOVER.ANO=ICOVER.ANO AND ACCEPTANCE.ANO=RCOVER.ANO AND COL.COL=@P_COL      
AND ((RCOVER.SDATE<=@P_LOSSDATE AND ACCEPTANCE.ExclusiveF=1) or ((RCOVER.SDATE<@P_LOSSDATE or (RCOVER.SDATE=@P_LOSSDATE AND ACCEPTANCE.STIME<=@P_LOSSTIME)) AND ACCEPTANCE.ExclusiveF=0))                     
AND ((dbo.fn_Get_ExtPeriodDate(ACCEPTANCE.ExtPeriod, ACCEPTANCE.ExtPeriodInDaysF, RCOVER.EDATE)>@P_LOSSDATE AND ACCEPTANCE.ExclusiveF=1) or ((dbo.fn_Get_ExtPeriodDate(ACCEPTANCE.ExtPeriod, ACCEPTANCE.ExtPeriodInDaysF, RCOVER.EDATE)>@P_LOSSDATE or (dbo.fn_Get_ExtPeriodDate(ACCEPTANCE.ExtPeriod, ACCEPTANCE.ExtPeriodInDaysF, RCOVER.EDATE)=@P_LOSSDATE AND ACCEPTANCE.ETIME>@P_LOSSTIME)) AND ACCEPTANCE.ExclusiveF=0))                    
AND RATECOV.CODE=RCOVER.CODE AND RATECOV.TOR=COL.TOR AND PCLASS.TOR=COL.TOR AND PCLASS.TOI=ICOVER.TOI                        
AND NOC.TOI=ICOVER.TOI AND NOC.NOC=CLLOSS.NOC
AND NOT EXISTS (SELECT TOP 1 ICOVERNOC.NOC FROM ICOVERNOC WHERE ICOVERNOC.INO=CLLOSS.INO AND ICOVERNOC.NOC=NOC.NOC)                        
AND COLNOCCLASS.NOC=NOC.NOC AND COLNOCCLASS.COL=@P_COL
AND (PCLASS.CTLF=0 OR NOC.CTLF=PCLASS.CTLF)
AND
ABS(CASE                        
 WHEN @P_EVENTNO=-1 THEN                        
        CASE                        
        WHEN RCOVER.PCTLOSS=0 OR ICOVER.NOTDECRF=1 OR ICOVER.NOTFLF=1 THEN ICOVER.AMOUNT 
        ELSE ICOVER.AMOUNT*RCOVER.PCTLOSS/100 END                        
 Else                        
        CASE                        
        WHEN RCOVER.PCTLOSS=0 OR ICOVER.NOTDECRF=1 OR ICOVER.NOTFLF=1 THEN ICOVER.AMOUNT_AOE                
        ELSE ICOVER.AMOUNT_AOE*RCOVER.PCTLOSS/100 END                        
 END-CLLOSS.DECLARED)>1
)  
go

--27 apr 2017 (1) : penambahan pnotify
IF  NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PNotify]') AND type in (N'U'))
begin
CREATE TABLE [dbo].[PNotify](
	[ANO] [int] NOT NULL,
	[Type] [varchar](2) NOT NULL,
	[ID] [varchar](10) NOT NULL,
	[Currency_OC] [varchar](5) NOT NULL,
	[Document] [varchar](50) NOT NULL,
	[Remarks] [text] NULL,
	[UserID] [varchar](50) NULL,
	[Date] [smalldatetime] NULL,
	[Time] [varchar](5) NULL,
 CONSTRAINT [I_PNotify] PRIMARY KEY CLUSTERED 
(
	[ANO] ASC,
	[Type] ASC,
	[ID] ASC,
	[Currency_OC] ASC,
	[Document] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Acceptance No. (see Acceptance)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PNotify', @level2type=N'COLUMN',@level2name=N'ANO'
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Claim Business Type (Ex. ''QS'',''S1'', etc)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PNotify', @level2type=N'COLUMN',@level2name=N'Type'
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Profile ID (see Profile)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PNotify', @level2type=N'COLUMN',@level2name=N'ID'
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Original Currency' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PNotify', @level2type=N'COLUMN',@level2name=N'Currency_OC'
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Kind Of Document' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PNotify', @level2type=N'COLUMN',@level2name=N'Document'
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Remarks' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PNotify', @level2type=N'COLUMN',@level2name=N'Remarks'
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Initiating User' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PNotify', @level2type=N'COLUMN',@level2name=N'UserID'
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Transaction Date' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PNotify', @level2type=N'COLUMN',@level2name=N'Date'
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Transaction Time' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PNotify', @level2type=N'COLUMN',@level2name=N'Time'
end
go
DROP Procedure Drop_Acceptance_Link
GO
Create Procedure Drop_Acceptance_Link(@P_ANO as Int)    
AS     
Delete from RCALC Where ANO=@P_ANO    
Delete from AccDocStat Where ANO=@P_ANO    
Delete from AccSurplus Where ANO=@P_ANO    
Delete from ICalc Where ANO=@P_ANO    
Delete from AINFO Where ANO=@P_ANO    
Delete from AINFO_EXT Where ANO=@P_ANO  
Delete from AAccBS Where ANO=@P_ANO    
Delete from ACCDED Where ANO=@P_ANO    
Delete from ACCBS Where ANO=@P_ANO    
Delete from ACCASS Where ANO=@P_ANO    
Delete from ACCCON Where ANO=@P_ANO    
Delete from ACCPIC Where ANO=@P_ANO    
Delete from PCALC Where ANO=@P_ANO    
Delete from BusinessResult Where ANO=@P_ANO    
Delete from ACCEX Where ANO=@P_ANO    
Delete from RCOVER Where ANO=@P_ANO    
Delete from AccCA Where ANO=@P_ANO    
Delete from AccDA Where ANO=@P_ANO    
Delete from AccSgn Where ANO=@P_ANO    
Delete from ACCCLA Where ANO=@P_ANO    
Delete from ACCCOMPSHEETH Where ANO=@P_ANO    
Delete from ICOVER Where ANO=@P_ANO    
Delete from ACCSECTION Where ANO=@P_ANO    
Delete from ACCFD Where ANO=@P_ANO    
Delete from RARRHEADER Where ANO=@P_ANO    
Delete from ACCDEPOSIT Where ANO=@P_ANO    
Delete from PPrintLog Where ANO=@P_ANO    
Delete from RARRDET Where ANO=@P_ANO    
Delete from ACCSEARCH Where ANO=@P_ANO    
Delete from ACCDOCLIST Where ANO=@P_ANO    
Delete from ACCDOCLISTPIC Where ANO=@P_ANO    
Delete from PAYOR Where ANO=@P_ANO    
Delete from ACCCOLLATERAL Where ANO=@P_ANO    
Delete from APayor Where ANO=@P_ANO    
Delete from AccCard Where ANO=@P_ANO    
Delete from ACCEMPCONTH Where ANO=@P_ANO       
Delete from PNOTIFY Where ANO=@P_ANO       



go

--2 May 2017 : ADJUSTMENT REINSURANCE DEPOSIT DIPISAHKAN ANTARA PREMI DAN COMM

IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'DepositF' AND Object_ID = Object_ID(N'ACCASS'))
BEGIN
ALTER TABLE dbo.ACCASS ADD	DepositF bit NULL
DECLARE @v sql_variant 
SET @v = N'Deposit Flag (0 : No, 1 : Yes)'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'ACCASS', N'COLUMN', N'DepositF'
ALTER TABLE dbo.ACCASS SET (LOCK_ESCALATION = TABLE)
END
GO

UPDATE ACCASS SET DEPOSITF=0 Where DEPOSITF IS NULL
UPDATE ACCASS SET DEPOSITF=1 WHERE CODE='J'
go

DROP Procedure QPOLICY_DEPOSIT
GO

CREATE Procedure QPOLICY_DEPOSIT(@P_LANO integer)                
as                
Select     
sum(AccAss.Amount) as Total_Deposit    
from Acceptance MA1     
Inner Join Acceptance MA2 on (MA2.OANO=MA1.OANO)    
Inner join AccAss on (AccAss.ANO=MA2.ANO)    
Where MA1.ANO=@P_LANO and MA2.ANO<=@P_LANO and AccAss.DepositF=1 and AccAss.Type in ('DI','IC')


GO

DROP Procedure QPOLICY_DEPOSIT_USAGE
GO
CREATE Procedure QPOLICY_DEPOSIT_USAGE(@P_ANO integer)                
as                
Select     
AccAss.Currency,     
sum(Case When AccAss.DepositF=0 Then AccAss.Amount else 0 end) as Total_Premium,    
sum(Case When AccAss.DepositF=1 Then -AccAss.Amount else 0 end) as Deposit_Usage    
from Acceptance A1    
Inner Join Acceptance MA1 on (MA1.ANO=A1.LANO)    
Inner Join Acceptance MA2 on (MA2.OANO=MA1.OANO AND MA2.ANO<=MA1.ANO)    
Inner Join Acceptance A2 on (A2.LANO=MA2.LANO and A2.ANO<>A2.LANO)    
Inner Join AccAss on (AccAss.ANO=A2.ANO)    
Where A1.ANO=@P_ANO and (A2.AStatus Not in ('W','T') or A2.ANO=@P_ANO)
and ((AccAss.Type in ('DI','IC') and AccAss.Code in ('P','U','O','J')) or (AccAss.Type in ('IR','IT','IX') and AccAss.Code in ('P','O','J')))     
Group by AccAss.Currency   


GO

DROP Procedure QREINSURANCE_DEPOSIT
GO
CREATE Procedure QREINSURANCE_DEPOSIT(@P_LANO integer)                
as                
Select     
AccAss.ID, 
Max(AccAss.Type) as Type,
max(AccAss.RefNo) as RefNo, 
sum(-AccAss.Amount) as Total_Deposit, 
Max(RPart.Comm) as Comm 
from Acceptance MA1     
Inner Join Acceptance MA2 on (MA2.OANO=MA1.OANO)    
Inner join AccAss on (AccAss.ANO=MA2.ANO)    
Left Join Reinsurance on (Reinsurance.DocNo=AccAss.RefNo)
Left Join RPart on (RPart.RNO=Reinsurance.RNO and RPart.ID=AccAss.ID)
Where MA1.ANO=@P_LANO and MA2.ANO<=@P_LANO and AccAss.DepositF=1 and AccAss.Type in ('QS','QP')
Group by AccAss.ID

GO

DROP Procedure QREINSURANCE_DEPOSIT_USAGE
GO
CREATE Procedure QREINSURANCE_DEPOSIT_USAGE(@P_ANO integer, @P_ID as varchar(10))                
as                
Select     
AccAss.Currency,     
sum(Case When AccAss.DepositF=0 Then AccAss.Amount else 0 end) as Total_Premium,    
sum(Case When AccAss.DepositF=1 Then -AccAss.Amount else 0 end) as Deposit_Usage   
from Acceptance A1    
Inner Join Acceptance MA1 on (MA1.ANO=A1.LANO)    
Inner Join Acceptance MA2 on (MA2.OANO=MA1.OANO AND MA2.ANO<=MA1.ANO)    
Inner Join Acceptance A2 on (A2.LANO=MA2.LANO and A2.ANO<>A2.LANO)    
Inner Join AccAss on (AccAss.ANO=A2.ANO)    
Where A1.ANO=@P_ANO and AccAss.ID=@P_ID and (A2.AStatus Not in ('W','T') or A2.ANO=@P_ANO)
and ((AccAss.Type in ('QS','QP') and AccAss.Code in ('P','C','O','J')))
Group by AccAss.Currency    
go

--sompo sharia : Penambahan Account Group ketika f2 account
DROP FUNCTION FL_SL_ACCOUNT
GO
CREATE FUNCTION FL_SL_ACCOUNT(@P_GID varchar(10), @P_Voucher varchar(20), @P_VType varchar(10), @P_ComAcc varchar(30), @P_Doc_No varchar(20),@P_CCY varchar(10), @P_Payment_Flag bit)                                    
RETURNS @TSL_Account TABLE (Account Varchar(10), Open_ItemF Bit, Branch Varchar(15), Hint Int, Description varchar(512), Currency varchar(10), AccGroup varchar(10), Outstanding Float)                                    
AS                                        
BEGIN                               
Declare @P_SL_Cat varchar(1)                
                       
if @P_Payment_Flag=1                       
Begin              
 Select @P_SL_Cat=SL_Cat from pVoucher Where Voucher=@P_Doc_No                
 if @P_SL_Cat is null                 
 Begin              
   Select @P_SL_Cat='N'                
 End                
 if @P_SL_Cat='P'                
 Begin                           
   insert into @TSL_Account                                    
   Select A1.Account, A2.Open_ItemF, A1.Branch, A1.Hint, A2.Description, V.Currency, A2.AccGroup,          
   (Case When VType.DebtorF=1 Then 1 Else -1 end)*(Case When V.DebtorF=1 then -(Max(A1.Nominal_OC)-sum(Case When SL_Alloc.Nominal_OC is null then 0 else SL_Alloc.Nominal_OC end)) else (Max(A1.Nominal_OC)-sum(Case When SL_Alloc.Nominal_OC is null then 0 else SL_Alloc.Nominal_OC end)) end) as Outstanding              
   from pVoucher V                                     
   Inner Join Get_Open_Item_Hint_P(@P_Doc_No,@P_VType) A1 on (A1.Voucher=V.Voucher)                                     
   Inner join VType on (VType.VType=@P_VType)          
   Inner Join Account A2 on (A2.Account=A1.Account)     
   Left Join ComAcc on (ComAcc.ComAcc=@P_ComAcc)    
   Left Join Open_Item_Allocated(@P_Doc_No) SL_Alloc on (SL_Alloc.Voucher<>@P_Voucher and SL_Alloc.Doc_no=A1.Voucher and SL_Alloc.Branch=A1.Branch and SL_Alloc.Account=A1.Account)                                     
   Where @P_Doc_No<>'' and A1.Voucher=V.Voucher                                     
   and ((coalesce(ComAcc.ComAcc,'')='' and A2.AccGroup='') or (coalesce(ComAcc.ComAcc,'')<>'' and (ComAcc.AccGroup='' or A2.AccGroup='' or ComAcc.AccGroup=A2.AccGroup)))     
   Group By A1.Account, A2.Open_ItemF, A1.Branch, A1.Hint, VType.DebtorF, V.DebtorF, V.SL_Cat, A2.Description, V.Currency , A2.AccGroup                                  
   Having round(Max(A1.Nominal_OC),2)<>round(sum(Case When SL_Alloc.Nominal_OC is null then 0 else SL_Alloc.Nominal_OC end),2)                                        
 End              
 else                
 Begin              
   insert into @TSL_Account                                    
   Select A1.Account, A2.Open_ItemF, A1.Branch, A1.Hint, A2.Description, V.Currency, A2.AccGroup,
   (Case When VType.DebtorF=1 Then 1 Else -1 end)*(Case When V.DebtorF=1 then (Max(A1.Nominal_OC)-sum(Case When SL_Alloc.Nominal_OC is null then 0 else SL_Alloc.Nominal_OC end)) else (Max(A1.Nominal_OC)-sum(Case When SL_Alloc.Nominal_OC is null then 0 else SL_Alloc.Nominal_OC end)) end) as Outstanding              
   from nVoucher V                                     
   Inner Join Get_Open_Item_Hint_N(@P_Doc_No,@P_VType) A1 on (A1.Voucher=V.Voucher)                                     
   Inner join VType on (VType.VType=@P_VType)          
   Inner Join Account A2 on (A2.Account=A1.Account)       
   Left Join ComAcc on (ComAcc.ComAcc=@P_ComAcc)
   Left Join Open_Item_Allocated(@P_Doc_No) SL_Alloc on (SL_Alloc.Voucher<>@P_Voucher and SL_Alloc.Doc_no=A1.Voucher and SL_Alloc.Branch=A1.Branch and SL_Alloc.Account=A1.Account)                                     
   Where @P_Doc_No<>'' and A1.Voucher=V.Voucher                                     
   and ((coalesce(ComAcc.ComAcc,'')='' and A2.AccGroup='') or (coalesce(ComAcc.ComAcc,'')<>'' and (ComAcc.AccGroup='' or A2.AccGroup='' or ComAcc.AccGroup=A2.AccGroup)))     
   Group By A1.Account, A2.Open_ItemF, A1.Branch, A1.Hint, VType.DebtorF, V.DebtorF, V.SL_Cat, A2.Description, V.Currency, A2.AccGroup                                   
   Having round(Max(A1.Nominal_OC),2)<>round(sum(Case When SL_Alloc.Nominal_OC is null then 0 else SL_Alloc.Nominal_OC end),2)                         
 End              
End              
Else            
Begin           
 if @P_GID=''       
 Begin                        
  insert into @TSL_Account                                
  Select A1.Account, A1.Open_ItemF, '' as Branch, max(CASE WHEN vtype.debtorf=1 THEN vPattern.Credit ELSE vpattern.debit end) as Hint, A1.Description, Case When @P_CCY='' then SysTab.Currency else @P_CCY end as Currency, A1.AccGroup, 0 as Outstanding                 
  from Account A1 
  Left Join ComAcc on (ComAcc.ComAcc=@P_ComAcc), Account a2, vPattern, SysTab, VType              
  Where A1.AllowedF=1 and a1.post_flag=1 and a1.parent=a2.parent and a2.account=vPattern.account and vPattern.Constant_Flag=1 and ((vPattern.Credit<0 AND VType.DebtorF = 1) or (vPattern.Debit<0 AND VType.CreditorF = 1)) and VType.Vtype=@P_VType AND VType.VType = VPattern.VType and (A1.Hold_Flag<>1 or A1.Suspend_Flag=1)                                    
  and ((coalesce(ComAcc.ComAcc,'')='' and A1.AccGroup='') or (coalesce(ComAcc.ComAcc,'')<>'' and (ComAcc.AccGroup='' or A1.AccGroup='' or ComAcc.AccGroup=A1.AccGroup)))     
  Group By A1.Account, A1.Open_ItemF, A1.Description, SysTab.Currency, A1.AccGroup                                   
 End      
 Else      
 Begin      
  insert into @TSL_Account                                    
  Select A1.Account, A1.Open_ItemF, '' as Branch, max(CASE WHEN vtype.debtorf=1 THEN vPattern.Credit ELSE vpattern.debit end) as Hint, B.Description, Case When @P_CCY='' then SysTab.Currency else @P_CCY end as Currency, A1.AccGroup, 0 as Outstanding                   
  from Budget_AccountDetail B, Account A1 
  Left Join ComAcc on (ComAcc.ComAcc=@P_ComAcc), Account a2, vPattern, SysTab, VType                                       
  Where B.GID=@P_GID and B.ID=@P_Doc_No and (A1.Account=B.Account_Dr or A1.Account=B.Account_Cr) and A1.AllowedF=1 and a1.post_flag=1 and a1.parent=a2.parent and a2.account=vPattern.account and vPattern.Constant_Flag=1 and ((vPattern.Credit<0 AND VType.DebtorF = 1) or (vPattern.Debit<0 AND VType.CreditorF = 1)) and VType.Vtype=@P_VType AND VType.VType = VPattern.VType and (A1.Hold_Flag<>1 or A1.Suspend_Flag=1)                                      
  and ((coalesce(ComAcc.ComAcc,'')='' and A1.AccGroup='') or (coalesce(ComAcc.ComAcc,'')<>'' and (ComAcc.AccGroup='' or A1.AccGroup='' or ComAcc.AccGroup=A1.AccGroup)))     
  Group By A1.Account, A1.Open_ItemF, B.Description, SysTab.Currency, A1.AccGroup            
 End      
End       
       
Return                                    
END                
            

go



DROP Procedure [dbo].[QPolicy_Rate]
GO
CREATE Procedure [dbo].[QPolicy_Rate](@P_ANO as int)     
as     
Select ICALC.Code, ICALC.SDate, SUM(ICALC.TSI) as TSI, Max(ICALC.PrevMinRate) as PrevMinRate, Max(ICALC.PrevMaxRate) as PrevMaxRate, Max(ICALC.MinRate) as MinRate, Max(ICALC.MaxRate) as MaxRate     
from     
(     
Select ICALC.Code, ICALC.SDate,     
MAX((Case When ICover.Category='M' then ICALC.TSI else 0 end)*(CASE WHEN RCOVER.PCTLOSS=0 THEN 100 ELSE RCOVER.PCTLOSS END)/(CASE WHEN RCOVER.PCTLOSS=0 THEN 100 ELSE RCOVER.PCTLOSS END+RCOVER.PAddition)) as TSI,     
CAST(0 as FLOAT) as PREVMINRATE,     
CAST(0 as FLOAT) as PREVMAXRATE,     
ROUND(SUM(ICALC.GROSS*100/(100-RCover.Discount)/ICALC.TSI/(Case When RCOVER.LOADING=0 THEN 1 ELSE RCOVER.LOADING END)*Case When ICalc.PCTADJ<>0 Then cast(100 as Float)/ICALC.PCTADJ else 1 end*Case When ICALC.Prorata=1 then (Case When Day(ICALC.SDate)<>Day(ICALC.EDate) then cast(Cover.Prorata as Float)/datediff(day,ICALC.SDate, ICALC.EDate) else cast(case When TOC.PTerm=0 Then 12 else TOC.PTerm end as Float)/datediff(Month, ICALC.SDate, ICALC.EDate) end) else (Case When RCover.PCalc='P' and Cover.Voyage=0 then Case When day(ICalc.SDate)<>day(ICalc.EDate) or Cover.PPeriod=1 then cast(Cover.Prorata as Float)/datediff(day,ICalc.SDate, ICalc.EDate) else cast(case When TOC.PTerm=0 Then 12 else TOC.PTerm end as Float)/datediff(month,ICalc.SDate, ICalc.EDate) end else 1/ICALC.Prorata end) end)*100,15) as MINRATE,     
ROUND(SUM(ICALC.GROSS*100/(100-RCover.Discount)/ICALC.TSI/(Case When RCOVER.LOADING=0 THEN 1 ELSE RCOVER.LOADING END)*Case When ICalc.PCTADJ<>0 Then cast(100 as Float)/ICALC.PCTADJ else 1 end*Case When ICALC.Prorata=1 then (Case When Day(ICALC.SDate)<>Day(ICALC.EDate) then cast(Cover.Prorata as Float)/datediff(day,ICALC.SDate, ICALC.EDate) else cast(case When TOC.PTerm=0 Then 12 else TOC.PTerm end as Float)/datediff(Month, ICALC.SDate, ICALC.EDate) end) else (Case When RCover.PCalc='P' and Cover.Voyage=0 then Case When day(ICalc.SDate)<>day(ICalc.EDate) or Cover.PPeriod=1 then cast(Cover.Prorata as Float)/datediff(day,ICalc.SDate, ICalc.EDate) else cast(case When TOC.PTerm=0 Then 12 else TOC.PTerm end as Float)/datediff(month,ICalc.SDate, ICalc.EDate) end else 1/ICALC.Prorata end) end)*100,15) as MAXRATE     
from COVER, ACCEPTANCE, ICover, ICALC, RCover, TOC
Where ACCEPTANCE.ANO=@P_ANO and COVER.CNO=ACCEPTANCE.CNO and COVER.ISType in ('I','C','L') and RCover.ANO=Acceptance.ANO     
and RCover.ANO=ICALC.ANO and RCover.Code=ICALC.Code and RCover.SDate=ICALC.SDate and RCover.EDate=ICALC.EDate and datediff(month, ICALC.SDate, ICALC.EDate)<>0     
and ICover.INO=ICalc.INO and ICALC.TSI<>0     
and TOC.TOC=ACCEPTANCE.TOC
Group By ICalc.INO, ICALC.Code, ICALC.SDate     
     
Union All     
     
Select ICALC.Code, ICALC.SDate,     
0 as TSI,     
ROUND(SUM(ICALC.GROSS*100/(100-RCover.Discount)/ICALC.TSI/(Case When RCOVER.LOADING=0 THEN 1 ELSE RCOVER.LOADING END)*Case When ICalc.PCTADJ<>0 Then cast(100 as Float)/ICALC.PCTADJ else 1 end*Case When ICALC.Prorata=1 then (Case When Day(ICALC.SDate)<>Day(ICALC.EDate) then cast(Cover.Prorata as Float)/datediff(day,ICALC.SDate, ICALC.EDate) else cast(case When TOC.PTerm=0 Then 12 else TOC.PTerm end as Float)/datediff(Month, ICALC.SDate, ICALC.EDate) end) else (Case When RCover.PCalc='P' and Cover.Voyage=0 then Case When day(ICalc.SDate)<>day(ICalc.EDate) or Cover.PPeriod=1 then cast(Cover.Prorata as Float)/datediff(day,ICalc.SDate, ICalc.EDate) else cast(case When TOC.PTerm=0 Then 12 else TOC.PTerm end as Float)/datediff(month,ICalc.SDate, ICalc.EDate) end else 1/ICALC.Prorata end) end)*100,15) as PREVMINRATE,     
ROUND(SUM(ICALC.GROSS*100/(100-RCover.Discount)/ICALC.TSI/(Case When RCOVER.LOADING=0 THEN 1 ELSE RCOVER.LOADING END)*Case When ICalc.PCTADJ<>0 Then cast(100 as Float)/ICALC.PCTADJ else 1 end*Case When ICALC.Prorata=1 then (Case When Day(ICALC.SDate)<>Day(ICALC.EDate) then cast(Cover.Prorata as Float)/datediff(day,ICALC.SDate, ICALC.EDate) else cast(case When TOC.PTerm=0 Then 12 else TOC.PTerm end as Float)/datediff(Month, ICALC.SDate, ICALC.EDate) end) else (Case When RCover.PCalc='P' and Cover.Voyage=0 then Case When day(ICalc.SDate)<>day(ICalc.EDate) or Cover.PPeriod=1 then cast(Cover.Prorata as Float)/datediff(day,ICalc.SDate, ICalc.EDate) else cast(case When TOC.PTerm=0 Then 12 else TOC.PTerm end as Float)/datediff(month,ICalc.SDate, ICalc.EDate) end else 1/ICALC.Prorata end) end)*100,15) as PREVMAXRATE,     
CAST(0 as FLOAT) as MINRATE,     
CAST(0 as FLOAT) as MAXRATE     
from COVER, ACCEPTANCE, ACCEPTANCE PACCEPTANCE, ICover, ICALC, RCover, TOC
Where ACCEPTANCE.ANO=@P_ANO and COVER.CNO=ACCEPTANCE.CNO and COVER.ISType in ('I','C','L') and PACCEPTANCE.ANO=ACCEPTANCE.PANO and RCOVER.ANO=PACCEPTANCE.ANO     
and RCover.ANO=ICALC.ANO and RCover.Code=ICALC.Code and RCover.SDate=ICALC.SDate and RCover.EDate=ICALC.EDate and datediff(month, ICALC.SDate, ICALC.EDate)<>0     
and ICover.INO=ICalc.INO and ICALC.TSI<>0     
and TOC.TOC=ACCEPTANCE.TOC
Group By ICalc.INO, ICALC.Code, ICALC.SDate     
) ICALC     
Group By ICALC.Code, ICALC.SDate     
Having SUM(ICALC.TSI)<>0     
     
GO

DROP Procedure Get_Fee_Amount_By_Percentage
GO
Create Procedure Get_Fee_Amount_By_Percentage(@P_ANO as Int, @P_Code as varchar(10), @P_FDType as varchar(1), @P_AmountPCT as Float)
as

Declare @P_LANO as integer
Declare @P_REGNO as varchar(20)

Select @P_LANO=LANO, @P_REGNO=REGNO from Acceptance Where ANO=@P_ANO

if @P_LANO<>@P_ANO -- Individual or Certificate
	Select 
	Case 
	When @P_FDTYPE<>'O' Then sum(D1.Gross*P.OurShare/P.TSI*(100-R.MSHARE)/100*(100-dbo.Premium_Discount(D1.ANO, D1.Code,cast(datediff(Month,A.SDate, D1.SDate) as integer) / 12 + 1))/100) 
	Else sum(D1.Gross*P.OurShare/P.TSI*(100-R.MSHARE)/100) End*@P_AmountPCT/100 as Fee
	from Display_Gross_Calculation(@P_ANO) D1, Acceptance A, PCalc P, RARRHEADER R
	Where P.ANO=A.ANO and P.Currency=D1.Currency and A.ANO=D1.ANO and R.ANO=A.ANO and A.ANO=@P_ANO and D1.Currency=@P_Code
ELSE	-- Fleet Only
	SELECT SUM(FEE)
	FROM
	(
		SELECT
		ACCEPTANCE.ANO,
		(
			Select 
			Case 
			When @P_FDTYPE<>'O' Then sum(D1.Gross*P.OurShare/P.TSI*(100-R.MSHARE)/100*(100-dbo.Premium_Discount(D1.ANO, D1.Code,cast(datediff(Month,A.SDate, D1.SDate) as integer) / 12 + 1))/100) 
			Else sum(D1.Gross*P.OurShare/P.TSI*(100-R.MSHARE)/100) End*@P_AmountPCT/100 as Fee
			from Display_Gross_Calculation(ACCEPTANCE.ANO) D1, Acceptance A, PCalc P, RARRHEADER R
			Where P.ANO=A.ANO and P.Currency=D1.Currency and A.ANO=D1.ANO and R.ANO=A.ANO and A.ANO=ACCEPTANCE.ANO and D1.Currency=@P_Code
		) as FEE
		FROM ACCEPTANCE, COVER
		WHERE COVER.CNO=ACCEPTANCE.CNO AND COVER.OPENFLAG=0 AND ACCEPTANCE.ANO<>ACCEPTANCE.LANO AND ACCEPTANCE.LANO=@P_ANO AND ACCEPTANCE.REGNO=@P_REGNO
	) A


GO

DROP FUNCTION FL_SL_ACCOUNT
GO
CREATE FUNCTION FL_SL_ACCOUNT(@P_GID varchar(10), @P_Voucher varchar(20), @P_VType varchar(10), @P_ComAcc varchar(30), @P_Doc_No varchar(20),@P_CCY varchar(10), @P_Payment_Flag bit)                                    
RETURNS @TSL_Account TABLE (Account Varchar(10), Open_ItemF Bit, Branch Varchar(15), Hint Int, Description varchar(512), Currency varchar(10), AccGroup varchar(10), Outstanding Float)                                    
AS                                        
BEGIN                               
Declare @P_SL_Cat varchar(1)                
                       
if @P_Payment_Flag=1                       
Begin              
 Select @P_SL_Cat=SL_Cat from pVoucher Where Voucher=@P_Doc_No                
 if @P_SL_Cat is null                 
 Begin              
   Select @P_SL_Cat='N'                
 End                
 if @P_SL_Cat='P'                
 Begin                           
   insert into @TSL_Account                                    
   Select A1.Account, A2.Open_ItemF, A1.Branch, A1.Hint, A2.Description, V.Currency, A2.AccGroup,          
   (Case When VType.DebtorF=1 Then 1 Else -1 end)*(Case When V.DebtorF=1 then -(Max(A1.Nominal_OC)-sum(Case When SL_Alloc.Nominal_OC is null then 0 else SL_Alloc.Nominal_OC end)) else (Max(A1.Nominal_OC)-sum(Case When SL_Alloc.Nominal_OC is null then 0 else SL_Alloc.Nominal_OC end)) end) as Outstanding              
   from pVoucher V                                     
   Inner Join Get_Open_Item_Hint_P(@P_Doc_No,@P_VType) A1 on (A1.Voucher=V.Voucher)                                     
   Inner join VType on (VType.VType=@P_VType)          
   Inner Join Account A2 on (A2.Account=A1.Account)     
   Left Join ComAcc on (ComAcc.ComAcc=@P_ComAcc)    
   Left Join Open_Item_Allocated(@P_Doc_No) SL_Alloc on (SL_Alloc.Voucher<>@P_Voucher and SL_Alloc.Doc_no=A1.Voucher and SL_Alloc.Branch=A1.Branch and SL_Alloc.Account=A1.Account)                                     
   Where @P_Doc_No<>'' and A1.Voucher=V.Voucher                                     
   and ((coalesce(ComAcc.ComAcc,'')='' and A2.AccGroup='') or (coalesce(ComAcc.ComAcc,'')<>'' and (ComAcc.AccGroup='' or A2.AccGroup='' or ComAcc.AccGroup=A2.AccGroup)))     
   Group By A1.Account, A2.Open_ItemF, A1.Branch, A1.Hint, VType.DebtorF, V.DebtorF, V.SL_Cat, A2.Description, V.Currency , A2.AccGroup                                  
   Having round(Max(A1.Nominal_OC),2)<>round(sum(Case When SL_Alloc.Nominal_OC is null then 0 else SL_Alloc.Nominal_OC end),2)                                        
 End              
 else                
 Begin              
   insert into @TSL_Account                                    
   Select A1.Account, A2.Open_ItemF, A1.Branch, A1.Hint, A2.Description, V.Currency, A2.AccGroup,
   (Case When VType.DebtorF=1 Then 1 Else -1 end)*(Case When V.DebtorF=1 then (Max(A1.Nominal_OC)-sum(Case When SL_Alloc.Nominal_OC is null then 0 else SL_Alloc.Nominal_OC end)) else (Max(A1.Nominal_OC)-sum(Case When SL_Alloc.Nominal_OC is null then 0 else SL_Alloc.Nominal_OC end)) end) as Outstanding              
   from nVoucher V                                     
   Inner Join Get_Open_Item_Hint_N(@P_Doc_No,@P_VType) A1 on (A1.Voucher=V.Voucher)                                     
   Inner join VType on (VType.VType=@P_VType)          
   Inner Join Account A2 on (A2.Account=A1.Account)       
   Left Join ComAcc on (ComAcc.ComAcc=@P_ComAcc)
   Left Join Open_Item_Allocated(@P_Doc_No) SL_Alloc on (SL_Alloc.Voucher<>@P_Voucher and SL_Alloc.Doc_no=A1.Voucher and SL_Alloc.Branch=A1.Branch and SL_Alloc.Account=A1.Account)                                     
   Where @P_Doc_No<>'' and A1.Voucher=V.Voucher                                     
   and ((coalesce(ComAcc.ComAcc,'')='' and A2.AccGroup='') or (coalesce(ComAcc.ComAcc,'')<>'' and (ComAcc.AccGroup='' or A2.AccGroup='' or ComAcc.AccGroup=A2.AccGroup)))     
   Group By A1.Account, A2.Open_ItemF, A1.Branch, A1.Hint, VType.DebtorF, V.DebtorF, V.SL_Cat, A2.Description, V.Currency, A2.AccGroup                                   
   Having round(Max(A1.Nominal_OC),2)<>round(sum(Case When SL_Alloc.Nominal_OC is null then 0 else SL_Alloc.Nominal_OC end),2)                         
 End              
End              
Else            
Begin           
 if @P_GID=''       
 Begin                        
  insert into @TSL_Account                                
  Select A1.Account, A1.Open_ItemF, '' as Branch, max(CASE WHEN vtype.debtorf=1 THEN vPattern.Credit ELSE vpattern.debit end) as Hint, A1.Description, Case When @P_CCY='' then SysTab.Currency else @P_CCY end as Currency, A1.AccGroup, 0 as Outstanding                 
  from Account A1 
  Left Join ComAcc on (ComAcc.ComAcc=@P_ComAcc), Account a2, vPattern, SysTab, VType              
  Where A1.AllowedF=1 and a1.post_flag=1 and a1.parent=a2.parent and a2.account=vPattern.account and vPattern.Constant_Flag=1 and ((vPattern.Credit<0 AND VType.DebtorF = 1) or (vPattern.Debit<0 AND VType.CreditorF = 1)) and VType.Vtype=@P_VType AND VType.VType = VPattern.VType and (A1.Hold_Flag<>1 or A1.Suspend_Flag=1)                                    
  and ((coalesce(ComAcc.ComAcc,'')='' and A1.AccGroup='') or (coalesce(ComAcc.ComAcc,'')<>'' and (ComAcc.AccGroup='' or A1.AccGroup='' or ComAcc.AccGroup=A1.AccGroup)))     
  Group By A1.Account, A1.Open_ItemF, A1.Description, SysTab.Currency, A1.AccGroup                                   
 End      
 Else      
 Begin      
  insert into @TSL_Account                                    
  Select A1.Account, A1.Open_ItemF, '' as Branch, max(CASE WHEN vtype.debtorf=1 THEN vPattern.Credit ELSE vpattern.debit end) as Hint, B.Description, Case When @P_CCY='' then SysTab.Currency else @P_CCY end as Currency, A1.AccGroup, 0 as Outstanding                   
  from Budget_AccountDetail B, Account A1 
  Left Join ComAcc on (ComAcc.ComAcc=@P_ComAcc), Account a2, vPattern, SysTab, VType                                       
  Where B.GID=@P_GID and B.ID=@P_Doc_No and (A1.Account=B.Account_Dr or A1.Account=B.Account_Cr) and A1.AllowedF=1 and a1.post_flag=1 and a1.parent=a2.parent and a2.account=vPattern.account and vPattern.Constant_Flag=1 and ((vPattern.Credit<0 AND VType.DebtorF = 1) or (vPattern.Debit<0 AND VType.CreditorF = 1)) and VType.Vtype=@P_VType AND VType.VType = VPattern.VType and (A1.Hold_Flag<>1 or A1.Suspend_Flag=1)                                      
  and ((coalesce(ComAcc.ComAcc,'')='' and A1.AccGroup='') or (coalesce(ComAcc.ComAcc,'')<>'' and (ComAcc.AccGroup='' or A1.AccGroup='' or ComAcc.AccGroup=A1.AccGroup)))     
  Group By A1.Account, A1.Open_ItemF, B.Description, SysTab.Currency, A1.AccGroup            
 End      
End       
       
Return                                    
END                

GO

DROP FUNCTION FN_NJOURNAL_SL
GO
CREATE FUNCTION FN_NJOURNAL_SL( @P_SDate as  smalldatetime,@P_EDate as smalldatetime)      
RETURNS TABLE         
AS RETURN ( 
Select
Distinct
SL.Voucher,
SL.Doc_No,
SL.Doc_Date,
SL.Remarks,
SL.Account, 
Case When Type.BS_Flag=1 Then '' When SL.CT='' Then Voucher.CT else SL.CT end as CT,
(Case When Type.PL_Flag=1 then SysTab.Currency else Voucher.Currency end) as Doc_CCY,
Case When Type.PL_FLAG=1 Then 
	Case When Voucher.DebtorF=1 then SL.Nominal*Voucher.Rate else -SL.Nominal*Voucher.Rate end
else
	Case When Voucher.DebtorF=1 then SL.Nominal else -SL.Nominal end
end as Nominal_OC,
Case When Type.PL_FLAG=1 Then 
	1
else
	Voucher.Rate
end as Rate,
Case When Type.PL_FLAG=1 Then 
	Case When Voucher.DebtorF=1 then SL.Nominal*Voucher.Rate else -SL.Nominal*Voucher.Rate end
else
	Case When Voucher.DebtorF=1 then SL.Nominal*Voucher.Rate else -SL.Nominal*Voucher.Rate end
end as Nominal
from nSL SL, nVoucher Voucher, nJournal Journal, Account, Type, SysTab
Where Voucher.Voucher=SL.Voucher and Account.Account=SL.Account and Type.Type=Account.Type
and Journal.Voucher=SL.Voucher and Journal.Account=SL.Account 
and Journal.Currency=(Case When Type.PL_Flag=1 then SysTab.Currency else Voucher.Currency end)
and Journal.CT=(Case When Type.BS_Flag=1 Then '' When SL.CT='' Then Voucher.CT else SL.CT end)
and Voucher.Date Between @P_SDate and @P_EDate
)

GO

DROP FUNCTION FN_PJOURNAL_SL
GO
CREATE FUNCTION FN_PJOURNAL_SL( @P_SDate as  smalldatetime,@P_EDate as smalldatetime)            
RETURNS TABLE               
AS RETURN (       
Select      
Distinct      
SL.SortNo,
SL.Voucher,      
SL.Doc_No,      
SL.Doc_Date,      
SL.Remarks,      
SL.Account,       
Case When Type.BS_Flag=1 Then '' When SL.CT='' Then Voucher.CT else SL.CT end as CT,      
Case When Type.PL_Flag=1 then SysTab.Currency When SL.PaymentF=1 Then SL.Doc_CCY else Voucher.Currency end as Doc_CCY,      
Case When Voucher.SL_Cat IN ('A','B','P') then      
  Case       
   When SL.PaymentF=1 Then Case When Voucher.DebtorF=1 Then -SL.Nominal_OC else SL.Nominal_OC end      
   When Type.PL_Flag=1 Then Case When Voucher.DebtorF=1 then -SL.Nominal*Voucher.Rate else SL.Nominal*Voucher.Rate end      
   else Case When Voucher.DebtorF=1 Then -SL.Nominal else SL.Nominal end      
   end      
  else      
  Case       
   When SL.PaymentF=1 Then Case When Voucher.DebtorF=1 Then SL.Nominal_OC else -SL.Nominal_OC end      
   When Type.PL_Flag=1 Then Case When Voucher.DebtorF=1 then SL.Nominal*Voucher.Rate else -SL.Nominal*Voucher.Rate end      
   else Case When Voucher.DebtorF=1 Then SL.Nominal else -SL.Nominal end      
   end      
  end AS Nominal_OC,        
Case When Voucher.SL_Cat IN ('A','B','P') then      
  Case       
   When SL.PaymentF=1 Then (Case When (Journal.Debit_OC+Journal.Credit_OC)<>0 Then (Journal.Debit+Journal.Credit)/(Journal.Debit_OC+Journal.Credit_OC) else 0 End)  
   When Type.PL_Flag=1 Then 1      
   else Voucher.Rate end      
  else      
  Case       
   When SL.PaymentF=1 Then (Case When (Journal.Debit_OC+Journal.Credit_OC)<>0 Then (Journal.Debit+Journal.Credit)/(Journal.Debit_OC+Journal.Credit_OC) else 0 End)      
   When Type.PL_Flag=1 Then 1      
   else Voucher.Rate end         
  end AS Rate,        
Case When Voucher.SL_Cat IN ('A','B','P') then      
  Case       
   When SL.PaymentF=1 Then Case When Voucher.DebtorF=1 Then -SL.Nominal_OC else SL.Nominal_OC end *(Case When (Journal.Debit_OC+Journal.Credit_OC)<>0 Then (Journal.Debit+Journal.Credit)/(Journal.Debit_OC+Journal.Credit_OC) else 0 End)      
   When Type.PL_Flag=1 Then Case When Voucher.DebtorF=1 then -SL.Nominal*Voucher.Rate else SL.Nominal*Voucher.Rate end      
   else Case When Voucher.DebtorF=1 Then -SL.Nominal else SL.Nominal end*Voucher.Rate       
   end      
  else      
  Case       
   When SL.PaymentF=1 Then Case When Voucher.DebtorF=1 Then SL.Nominal_OC else -SL.Nominal_OC end *(Case When (Journal.Debit_OC+Journal.Credit_OC)<>0 Then (Journal.Debit+Journal.Credit)/(Journal.Debit_OC+Journal.Credit_OC) else 0 End)      
   When Type.PL_Flag=1 Then Case When Voucher.DebtorF=1 then SL.Nominal*Voucher.Rate else -SL.Nominal*Voucher.Rate end      
   else Case When Voucher.DebtorF=1 Then SL.Nominal else -SL.Nominal end*Voucher.Rate       
   end      
  end AS Nominal      
from pSL SL, pVoucher Voucher, pJournal Journal, Account, Type, SysTab      
Where Voucher.Voucher=SL.Voucher and Account.Account=SL.Account and Type.Type=Account.Type      
and Journal.Voucher=SL.Voucher and Journal.Account=SL.Account       
and Journal.Currency=(Case When Type.PL_Flag=1 then SysTab.Currency When SL.PaymentF=1 Then SL.Doc_CCY else Voucher.Currency end)      
and Journal.CT=(Case When Type.BS_Flag=1 Then '' When SL.CT='' Then Voucher.CT else SL.CT end)      
and Voucher.Date Between @P_SDate and @P_EDate      
) 


GO

DROP Function Get_Payment_Percentage
GO
CREATE Function Get_Payment_Percentage(@P_A_PolicyNo varchar(50), @P_Date smalldatetime)
RETURNS Float AS        
  
BEGIN       
Declare @PCT as Float

Select 
@PCT=sum(case When V.DebtorF=1 Then (V.Payment_CC) Else -(V.Payment_CC) end)/sum(case When V.DebtorF=1 Then (V.Nominal_CC-V.Diff_CC) Else -(V.Nominal_CC-V.Diff_CC) end)*100
from Admlink a, nVoucher V 
Where V.Voucher=A.Voucher and A.Date<=@P_Date and A.A_PolicyNo=@P_A_PolicyNo and A.SUbject='Premium' and V.DebtorF=1 and A.Type in ('DI','IC','IR')
Having sum(case When V.DebtorF=1 Then (V.Nominal_CC-V.Diff_CC) Else -(V.Nominal_CC-V.Diff_CC) end)<>0

if @PCT IS NULL 
	SELECT @PCT=0

Return @PCT
End

            
GO

DROP procedure PI09 
GO
CREATE procedure PI09 (@P_ANO as integer) 
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
 
Select Voucher.Voucher, Voucher.DueDate, Voucher.DocNo, Profile.Name, Voucher.Currency, 
case when Voucher.debtorf=1 then Voucher.Nominal_CC-Voucher.Diff_CC else -(Voucher.Nominal_CC-Voucher.Diff_CC) end  as Nominal, 
case when Voucher.debtorf=1 then (Voucher.AmountDue-Voucher.Payment_CC) else -(Voucher.AmountDue-Voucher.Payment_CC) end as AmountDue, 
case when Voucher.debtorf=1 then Voucher.Payment_CC else -Voucher.Payment_CC end as Payment, 
case when Voucher.debtorf=1 then Voucher.Nominal_CC-Voucher.Diff_CC - Voucher.Payment_CC else -(Voucher.Nominal_CC-Voucher.Diff_CC - Voucher.Payment_CC) end as Outstanding 
 
from nVoucher Voucher, Profile, ProAcc, Admlink 
Where Profile.ID=ProAcc.ID and ProAcc.ProAcc=Voucher.ProAcc and Admlink.Voucher=Voucher.Voucher 
and Admlink.Subject='Claim' and Admlink.Type in ('DI','IC','IR','OP') and Admlink.A_PolicyNo<>'' and Admlink.A_PolicyNo=@P_A_PolicyNo and (Admlink.Extra_1='' or Admlink.Extra_1 is null) 
and round(Voucher.AmountDue,0)>round(Voucher.Payment_CC,0) 
End 
 
 
GO

DROP Function Premium_MaxOutGo
GO
CREATE Function Premium_MaxOutGo(@P_ANO as int,@P_Code as varchar(10),@P_Period int=0)        
RETURNS Float        
AS        

BEGIN        
 --Return (dbo.premium_discount(@P_ANO, @P_Code,@P_Period)-dbo.Payor_Group_Discount(@P_ANO, @P_Code,@P_Period)+dbo.Premium_Commission(@P_ANO, @P_Code,@P_Period,0)+dbo.Premium_Commission_Vat(@P_ANO, @P_Code,@P_Period,0))        
 --Return (dbo.Premium_Commission(@P_ANO, @P_Code,@P_Period,0)-dbo.Premium_Commission_UpFee(@P_ANO, @P_Code,@P_Period,0))  
 --Return (100/(100-dbo.premium_discount(@P_ANO, @P_Code,@P_Period))*(dbo.Premium_Commission(@P_ANO, @P_Code,@P_Period,0)-dbo.Premium_Commission_UpFee(@P_ANO, @P_Code,@P_Period,0)))
 Return (dbo.premium_discount(@P_ANO, @P_Code,@P_Period)+dbo.Premium_Commission(@P_ANO, @P_Code,@P_Period,0)-dbo.Premium_Commission_UpFee(@P_ANO, @P_Code,@P_Period,0))  
End      
go

--5 may 2017

IF  NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[TOP_SECTION]') AND type in (N'U'))
begin
CREATE TABLE [dbo].[TOP_SECTION](
	[TOPRO] [varchar](10) NOT NULL,
	[SECTION] [varchar](10) NOT NULL,
	[SHORTDESC] [varchar](255) NULL,
	[DESCRIPTION] [text] NULL,
 CONSTRAINT [I_TOP_SECTION] PRIMARY KEY CLUSTERED 
(
	[TOPRO] ASC,
	[SECTION] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
ALTER TABLE [dbo].[TOP_SECTION] ADD  CONSTRAINT [DF_Table_1_ANO]  DEFAULT ((0)) FOR [TOPRO]
ALTER TABLE [dbo].[TOP_SECTION]  WITH CHECK ADD  CONSTRAINT [FK_TOP_SECTION_TOPRO1] FOREIGN KEY([TOPRO])
REFERENCES [dbo].[TOPRO] ([TOPRO])
ON UPDATE CASCADE
ON DELETE CASCADE
ALTER TABLE [dbo].[TOP_SECTION] CHECK CONSTRAINT [FK_TOP_SECTION_TOPRO1]
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Type Of Product (see TOPRO)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TOP_SECTION', @level2type=N'COLUMN',@level2name=N'TOPRO'
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Section Wording ID' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TOP_SECTION', @level2type=N'COLUMN',@level2name=N'SECTION'
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Short Description' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TOP_SECTION', @level2type=N'COLUMN',@level2name=N'SHORTDESC'
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Long Description' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TOP_SECTION', @level2type=N'COLUMN',@level2name=N'DESCRIPTION'
END
GO


IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'SECTION' AND Object_ID = Object_ID(N'TOP_Interest'))
BEGIN
ALTER TABLE dbo.TOP_Interest ADD	SECTION varchar(10) NULL
DECLARE @v sql_variant 
SET @v = N'Section Wording ID'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'TOP_Interest', N'COLUMN', N'SECTION'
END
GO

IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'AMOUNT_AOE_PCT' AND Object_ID = Object_ID(N'TOP_Interest'))
BEGIN
ALTER TABLE dbo.TOP_Interest ADD	AMOUNT_AOE_PCT float(53) NULL
DECLARE @v sql_variant 
SET @v = N'Max Liability Percentage'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'TOP_Interest', N'COLUMN', N'AMOUNT_AOE_PCT'
END
GO

IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'AMOUNT_AOE_Source' AND Object_ID = Object_ID(N'TOP_Interest'))
BEGIN
ALTER TABLE dbo.TOP_Interest ADD	AMOUNT_AOE_Source varchar(10) NULL
DECLARE @v sql_variant 
SET @v = N'Max Liability Percentage Source Data'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'TOP_Interest', N'COLUMN', N'AMOUNT_AOE_Source'
END
GO

IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'AMOUNT_AOE_MaxPCT' AND Object_ID = Object_ID(N'TOP_Interest'))
BEGIN
ALTER TABLE dbo.TOP_Interest ADD	AMOUNT_AOE_MaxPCT float(53) NULL
DECLARE @v sql_variant 
SET @v = N'Max Liability Max Percentage'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'TOP_Interest', N'COLUMN', N'AMOUNT_AOE_MaxPCT'
END
GO

IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'AMOUNT_AOE_MaxSource' AND Object_ID = Object_ID(N'TOP_Interest'))
BEGIN
ALTER TABLE dbo.TOP_Interest ADD	AMOUNT_AOE_MaxSource varchar(10) NULL
DECLARE @v sql_variant 
SET @v = N'Max Liability Max Percentage Source Data'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'TOP_Interest', N'COLUMN', N'AMOUNT_AOE_MaxSource'
END
GO

IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'AMOUNT_AOE_Max' AND Object_ID = Object_ID(N'TOP_Interest'))
BEGIN
ALTER TABLE dbo.TOP_Interest ADD	AMOUNT_AOE_Max float(53) NULL
DECLARE @v sql_variant 
SET @v = N'Max Liability Maximum Amount'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'TOP_Interest', N'COLUMN', N'AMOUNT_AOE_Max'
END
GO


IF NOT EXISTS(SELECT * FROM SYSFORM WHERE FNAME='ALLOWENDORSEUJROH')
BEGIN
insert into sysform(FName, Description, FCode) Select 'ALLOWENDORSEUJROH','ALLOW Endorse Ujroh Fee','ACTIVITIES'
end
go



--9 may 2017 : critical illnes
IF  NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Payor_Schedule]') AND type in (N'U'))
begin
CREATE TABLE [dbo].[Payor_Schedule](
	[ANO] [int] NOT NULL,
	[InstNo] [int] NOT NULL,
	[InstDate] [smalldatetime] NULL,
	[InstLDate] [smalldatetime] NULL,
	[InstPCT] [float] NULL,
	[InstAmount] [float] NULL
 CONSTRAINT [I_PAYOR_SCHEDULE] PRIMARY KEY CLUSTERED 
(
	[ANO] ASC, [InstNo] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON)
) ON [PRIMARY]
end
GO

DROP Procedure Drop_Acceptance_Link
GO
Create Procedure Drop_Acceptance_Link(@P_ANO as Int)    
AS     
Delete from RCALC Where ANO=@P_ANO    
Delete from AccDocStat Where ANO=@P_ANO    
Delete from AccSurplus Where ANO=@P_ANO    
Delete from ICalc Where ANO=@P_ANO    
Delete from AINFO Where ANO=@P_ANO    
Delete from AINFO_EXT Where ANO=@P_ANO  
Delete from AAccBS Where ANO=@P_ANO    
Delete from ACCDED Where ANO=@P_ANO    
Delete from ACCBS Where ANO=@P_ANO    
Delete from ACCASS Where ANO=@P_ANO    
Delete from ACCCON Where ANO=@P_ANO    
Delete from ACCPIC Where ANO=@P_ANO    
Delete from PCALC Where ANO=@P_ANO    
Delete from BusinessResult Where ANO=@P_ANO    
Delete from ACCEX Where ANO=@P_ANO    
Delete from RCOVER Where ANO=@P_ANO    
Delete from AccCA Where ANO=@P_ANO    
Delete from AccDA Where ANO=@P_ANO    
Delete from AccSgn Where ANO=@P_ANO    
Delete from ACCCLA Where ANO=@P_ANO    
Delete from ACCCOMPSHEETH Where ANO=@P_ANO    
Delete from ICOVER Where ANO=@P_ANO    
Delete from ACCSECTION Where ANO=@P_ANO    
Delete from ACCFD Where ANO=@P_ANO    
Delete from RARRHEADER Where ANO=@P_ANO    
Delete from ACCDEPOSIT Where ANO=@P_ANO    
Delete from PPrintLog Where ANO=@P_ANO    
Delete from RARRDET Where ANO=@P_ANO    
Delete from ACCSEARCH Where ANO=@P_ANO    
Delete from ACCDOCLIST Where ANO=@P_ANO    
Delete from ACCDOCLISTPIC Where ANO=@P_ANO    
Delete from PAYOR Where ANO=@P_ANO    
Delete from ACCCOLLATERAL Where ANO=@P_ANO    
Delete from APayor Where ANO=@P_ANO    
Delete from AccCard Where ANO=@P_ANO    
Delete from ACCEMPCONTH Where ANO=@P_ANO       
Delete from PNOTIFY Where ANO=@P_ANO      
Delete from PAYOR_SCHEDULE Where ANO=@P_ANO       


GO

IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'ScheduleF' AND Object_ID = Object_ID(N'PAYOR'))
BEGIN
ALTER TABLE dbo.PAYOR ADD	ScheduleF bit NULL
DECLARE @v sql_variant 
SET @v = N'by Payment Schedule Table (Payor_Schedule) (0 : No, 1 : Yes)'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'PAYOR', N'COLUMN', N'ScheduleF'
end
go
Update Payor Set ScheduleF=0 Where ScheduleF is null
GO

DROP Procedure QPCALC_ACCASS 
GO
CREATE Procedure QPCALC_ACCASS (@P_ANO integer)     
AS     
SELECT ICALC.CURRENCY, ICALC.CODE, 
coalesce(P.InstDate, ICalc.SDate) as SDate,
coalesce(P.InstLDate, ICalc.EDate) as EDate,
(Case When A1.AType='A' Then 0 else ICover.Adjustable end) as AdjustableF, ICALC.SANO, A2.LANO,     
Cast(Max(cast(RCover.NoRefundF as Integer)) as Bit) as NoRefundF,     
Max(Case When ICover.Adjustable=1 Then TOI.AdjMethod else '' end) as AdjMethod,     
AVG(ICALC.PRORATA) AS PPRORATA, 
MAX(CASE WHEN PCALC.TSI<>0 AND COALESCE(ISOURCE.LIMIT,0)<>0 THEN PCALC.OURSHARE/PCALC.TSI*100 ELSE COALESCE(ISOURCE.SHARE,100) END) as SHARE, 
SUM(Case When PCALC.Description<>'' and PCALC.Description<>'Minimum Premium' then ICALC.GROSS*PCALC.GROSS/PCALC.OGROSS else ICALC.GROSS*RCALC.GROSS/RCALC.OGROSS end*coalesce(P.InstPCT,100)/100 ) AS GROSS,     
CAST(MAX(Case When Upper(PCALC.DESCRIPTION) in ('MINIMUM PREMIUM','POLICY MINIMUM PREMIUM') Then 1 else 0 end) as Bit) as MinimumPremiumF,     
SUM(ICALC.REINSTATEMENT) AS REINSTATEMENT,     
SUM(ICALC.DISCOUNT) AS DISCOUNT,     
MAX(PCALC.TSI) as TSI,      --100% Sum Insured for Reinsurance Rate     
MAX(PCALC.Rate) As Rate     
FROM ICover     
inner join ICALC on (ICALC.INO=ICOVER.INO and ICALC.ANO=ICOVER.ANO)     
inner join TOI on (TOI.TOI=ICOVER.TOI)     
inner join RCALC on (ICALC.ANO=RCALC.ANO AND ICALC.CURRENCY=RCALC.CURRENCY AND ICALC.CODE=RCALC.CODE AND ICALC.TOR=RCALC.TOR AND ICALC.SDATE=RCALC.SDATE AND ICALC.EDATE=RCALC.EDATE AND ICALC.SANO=RCALC.SANO)     
inner join PCALC on (PCALC.ANO=ICALC.ANO AND PCALC.CURRENCY=ICALC.CURRENCY)     
Left join RCover on (RCover.ANO=RCalc.ANO and RCover.Code=RCalc.Code and RCover.SDate=RCalc.SDate)     
inner join ACCEPTANCE A1 On (A1.ANO=ICALC.ANO)     
inner join ACCEPTANCE A2 on (A2.ANO=ICALC.SANO)     
Inner Join RArrHeader R on (R.ANO=ICalc.ANO)     
left join ISource on (ISource.CNO=A2.CNO)     
Left Join Payor_Schedule P on (P.ANO=@P_ANO)
WHERE ICover.ANO=@P_ANO and ICALC.GROSS<>0 AND ICALC.SDATE<>ICALC.EDATE  
GROUP BY ICALC.CURRENCY, ICALC.CODE, coalesce(P.InstDate, ICalc.SDate), coalesce(P.InstLDate, ICalc.EDate), (Case When A1.AType='A' Then 0 else ICover.Adjustable end), ICalc.SANO, A2.LANO     

GO
DROP Procedure QProduction_To_Adm
GO
CREATE Procedure QProduction_To_Adm(@P_ANO as int)                              
as                              
Select A1.ID, A1.TOC, A1.Type, A1.Currency, A1.Date, A1.BillDate, Max(A1.DocNo) as DocNo, A1.RefNo,  
Case When SysTab.SplitPremiumAndClaimF=1 and A1.Code in ('A','R') Then 'Claim' else 'Premium' end as Subject,       
Max(Case When coalesce(AL.RefNo,'')=A1.RefNo and C.ISType<>'T' Then coalesce(AL.AName,Case When A2.AName<>'' then A2.AName else A2.Remarks end) else Case When A2.AName<>'' then A2.AName else A2.Remarks end end) as Remarks,                                 
Case When (isnull(Payor.ScheduleF,0)=1) or (Case When isnull(APayor.ANO,0)=0 Then (Case When isnull(MPayor.ANO,0)=0 Then Payor.PolicyYearF else MPayor.PolicyYearF end) else APayor.PolicyYearF end)=1 Then A1.SDate else A2.SDate end as SDate,                              
Case When (isnull(Payor.ScheduleF,0)=1) or (Case When isnull(APayor.ANO,0)=0 Then (Case When isnull(MPayor.ANO,0)=0 Then Payor.PolicyYearF else MPayor.PolicyYearF end) else APayor.PolicyYearF end)=1 Then A1.EDate else A2.EDate end as EDate,               
case When coalesce(A1.Source,'')='' or A1.Source<>A1.ID then A2.Source else A1.Source end Source,                              
Case When A1.CAmount=0 and Coalesce(A3.Branch,'')<>'' Then A3.Branch Else A2.Branch end Branch,         
min (A1.SDate) as MINSDate, max(A1.SDate) as MAXSDate,                
min (A1.ACNO)  as MinACNO, min (A1.ACNO) as MaxACNO,                          
sum(Case When A1.Code='P' then A1.Amount else 0 end) as Amount_1,                              
sum(Case When A1.Code='C' then A1.Amount else 0 end) as Amount_2,                              
sum(Case When A1.Code='F' then A1.Amount else 0 end) as Amount_3,                              
sum(Case When A1.Code='D' then A1.Amount else 0 end) as Amount_4,                              
sum(Case When A1.Code='O' then A1.Amount else 0 end) as Amount_5,                              
sum(Case When A1.Code='A' then A1.Amount else 0 end) as Amount_6,                              
sum(Case When A1.Code='R' then A1.Amount else 0 end) as Amount_10,                              
sum(Case When A1.Code='T' then A1.Amount else 0 end) as Amount_14,                              
sum(Case When A1.Code='G' then A1.Amount else 0 end) as Amount_18,                              
sum(Case When A1.Code='J' then A1.Amount else 0 end) as Amount_19,    
sum(Case When A1.Code='U' then A1.Amount else 0 end) as Amount_20                              
from AccAss A1                              
Inner Join Acceptance A2 on (A2.ANO=A1.ANO)                              
Inner Join Cover C on (C.CNO=A2.CNO)                  
Left Join Acceptance AL on (AL.ANO=A2.LANO and C.OpenFlag=0)                  
Left Join APayor on (APayor.ANO=A2.ANO and A2.LANO<>-1 and A2.ANO<>A2.LANO)                              
Left Join Payor on (Payor.ANO=A2.ANO and A2.LANO=-1)                 
Left Join Payor MPayor on (MPayor.ANO=A2.LANO and A2.LANO<>-1)                
Left join  Acceptance A3 on (A3.ANO=A2.pANO)    
Inner Join SysTab on (1=1)                          
Where A1.ANO=@P_ANO                              
Group By A1.ID, A1.TOC, A1.Type, A1.Currency, A1.Date, A1.BillDate, A1.RefNo,                       
Case When SysTab.SplitPremiumAndClaimF=1 and A1.Code in ('A','R') Then 'Claim' else 'Premium' end,
Case When (isnull(Payor.ScheduleF,0)=1) or (Case When isnull(APayor.ANO,0)=0 Then (Case When isnull(MPayor.ANO,0)=0 Then Payor.PolicyYearF else MPayor.PolicyYearF end) else APayor.PolicyYearF end)=1 Then A1.SDate else A2.SDate end,                
Case When (isnull(Payor.ScheduleF,0)=1) or (Case When isnull(APayor.ANO,0)=0 Then (Case When isnull(MPayor.ANO,0)=0 Then Payor.PolicyYearF else MPayor.PolicyYearF end) else APayor.PolicyYearF end)=1 Then A1.EDate else A2.EDate end,
case When coalesce(A1.Source,'')='' or A1.Source<>A1.ID then A2.Source else A1.Source end,                              
Case When A1.CAmount=0 and Coalesce(A3.Branch,'')<>'' Then A3.Branch Else A2.Branch end                              
  

go

--11 may 2017
IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'TAXINVOICEF' AND Object_ID = Object_ID(N'TOC'))
BEGIN
ALTER TABLE dbo.TOC ADD	TAXINVOICEF bit NULL
DECLARE @v sql_variant 
SET @v = N'Print Tax Invoice (0 : No, 1 : Yes)'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'TOC', N'COLUMN', N'TAXINVOICEF'
end
go
UPDATE TOC SET TAXINVOICEF=0 WHERE TAXINVOICEF IS NULL
GO

DROP FUNCTION VAT_OUT_PROCESS
GO
CREATE FUNCTION VAT_OUT_PROCESS(@P_Type varchar(2),@P_Date smalldatetime, @P_PEDate smalldatetime,@P_EDate smalldatetime)                            
RETURNS TABLE                            
AS RETURN(                            
select A.Branch, A.DocNo, A.RefNo, @P_Date as Date, A.Code as Code, @P_Type as Type, SysTab.Currency, 'JOURNAL' as Subject, A.Remarks as Remarks,
 'Amount_1'  = Case When (A.Subject='Premium' and A.Type in ('DI','IC','IR','IT','IX')) Then A.Amount_13*V.Rate else 0 end,
 'Amount_2'  = 0,
 'Amount_3'  = 0,                       
 'Amount_4'  = Case When (A.Subject='Claim' and A.Type in ('OP') and A.Amount_8<>0) Then A.Amount_13*V.Rate else 0 end,
 'Amount_5'  = 0,                       
 'Amount'    = A.Amount_13*V.Rate
from nVoucher V, Admlink A, SysTab, TOC
where A.Voucher=V.Voucher and TOC.TOC=A.CODE
and coalesce(V.TaxNo,'')<>'' and V.TaxDate>@P_PEDate and V.TaxDate<=@P_EDate
and (A.Amount_13<>0 or TOC.TAXINVOICEF=1)
and (
(A.Subject='Premium' and A.Type in ('DI','IC','IR','IT','IX')) or
(A.Subject='Claim' and A.Type in ('OP') and A.Amount_8<>0)	-- Claim Salvage
)
)                            

go

--13 may 2017
DROP PROCEDURE QClaRegAmountExcessQS
GO
CREATE PROCEDURE QClaRegAmountExcessQS (@PCNO as integer) 
AS

SELECT SUM(C3.QAMOUNT+C3.QXOLAMOUNT) AS AMOUNT
FROM CLAIM C1, CLAIM C2, CARRHEADER C3
WHERE C1.CNO=@PCNO and C2.EVENTNO=C1.EVENTNO AND YEAR(C1.LOSSDATE)=YEAR(C2.LOSSDATE) AND C1.OCNO<>C2.OCNO AND C3.CNO=C2.CNO AND C3.STATUS='A'

GO

DROP PROCEDURE QClaRegEAmountExcessQS
GO
CREATE PROCEDURE QClaRegEAmountExcessQS (@PCNO as integer) 
AS

SELECT SUM(C3.EQAmount+C3.QXOLEAMOUNT) AS AMOUNT
FROM CLAIM C1, CLAIM C2, CARRHEADER C3
WHERE C1.CNO=@PCNO and C2.EVENTNO=C1.EVENTNO AND YEAR(C1.LOSSDATE)=YEAR(C2.LOSSDATE) AND C1.OCNO<>C2.OCNO AND C3.CNO=C2.CNO AND C3.STATUS='A'
go


--18 may 2017
IF  NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[DType]') AND type in (N'U'))
begin
CREATE TABLE [dbo].[DType](
	[DType] [varchar](10) NOT NULL,
	[Description] [varchar](255) NULL,
	[AllowedF] [bit] NULL,
	[Last_Opr] [varchar](10) NULL,
	[Last_Update] [smalldatetime] NULL,
 CONSTRAINT [I_DType] PRIMARY KEY CLUSTERED 
(
	[DType] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
ALTER TABLE [dbo].[DType] ADD  CONSTRAINT [DF_DType_AllowedF]  DEFAULT ((0)) FOR [AllowedF]
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Premium Discount Type' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'DType', @level2type=N'COLUMN',@level2name=N'DType'
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Discount Description' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'DType', @level2type=N'COLUMN',@level2name=N'Description'
end
go



IF  NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[AccDiscount]') AND type in (N'U'))
begin
CREATE TABLE [dbo].[AccDiscount](
	[ANO] [int] NOT NULL,
	[DType] [varchar](10) NOT NULL,
	[Discount] [float] NULL,
 CONSTRAINT [I_AccDiscount] PRIMARY KEY NONCLUSTERED 
(
	[ANO] ASC,
	[DType] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
end
go

SET ANSI_PADDING OFF
GO
DROP Procedure Drop_Acceptance_Link
GO
Create Procedure Drop_Acceptance_Link(@P_ANO as Int)    
AS     
Delete from RCALC Where ANO=@P_ANO    
Delete from AccDocStat Where ANO=@P_ANO    
Delete from AccSurplus Where ANO=@P_ANO    
Delete from ICalc Where ANO=@P_ANO    
Delete from AINFO Where ANO=@P_ANO    
Delete from AINFO_EXT Where ANO=@P_ANO  
Delete from AAccBS Where ANO=@P_ANO    
Delete from ACCDED Where ANO=@P_ANO    
Delete from ACCBS Where ANO=@P_ANO    
Delete from ACCASS Where ANO=@P_ANO    
Delete from ACCCON Where ANO=@P_ANO    
Delete from ACCPIC Where ANO=@P_ANO    
Delete from PCALC Where ANO=@P_ANO    
Delete from BusinessResult Where ANO=@P_ANO    
Delete from ACCEX Where ANO=@P_ANO    
Delete from RCOVER Where ANO=@P_ANO    
Delete from AccCA Where ANO=@P_ANO    
Delete from AccDA Where ANO=@P_ANO    
Delete from AccSgn Where ANO=@P_ANO    
Delete from ACCCLA Where ANO=@P_ANO    
Delete from ACCCOMPSHEETH Where ANO=@P_ANO    
Delete from ICOVER Where ANO=@P_ANO    
Delete from ACCSECTION Where ANO=@P_ANO    
Delete from ACCFD Where ANO=@P_ANO    
Delete from RARRHEADER Where ANO=@P_ANO    
Delete from ACCDEPOSIT Where ANO=@P_ANO    
Delete from PPrintLog Where ANO=@P_ANO    
Delete from RARRDET Where ANO=@P_ANO    
Delete from ACCSEARCH Where ANO=@P_ANO    
Delete from ACCDOCLIST Where ANO=@P_ANO    
Delete from ACCDOCLISTPIC Where ANO=@P_ANO    
Delete from PAYOR Where ANO=@P_ANO    
Delete from ACCCOLLATERAL Where ANO=@P_ANO    
Delete from APayor Where ANO=@P_ANO    
Delete from AccCard Where ANO=@P_ANO    
Delete from ACCEMPCONTH Where ANO=@P_ANO       
Delete from PNOTIFY Where ANO=@P_ANO      
Delete from PAYOR_SCHEDULE Where ANO=@P_ANO       
Delete from ACCDISCOUNT Where ANO=@P_ANO       
go

IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'VUserID' AND Object_ID = Object_ID(N'Request'))
BEGIN
ALTER TABLE dbo.Request ADD	VUserID varchar(50) NULL
DECLARE @v sql_variant 
SET @v = N'Verifying User ID'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'Request', N'COLUMN', N'VUserID'
end
go


IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'VUserDate' AND Object_ID = Object_ID(N'Request'))
BEGIN
ALTER TABLE dbo.Request ADD	VUserDate smalldatetime NULL
DECLARE @v sql_variant 
SET @v = N'Verifying  User Date'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'Request', N'COLUMN', N'VUserDate'
end
go


DROP Procedure GetReinsuranceRate
GO
CREATE Procedure GetReinsuranceRate(@P_TOC as varchar(10), @P_Currency as varchar(10), @P_SDate as smalldatetime, @P_PHolder as varchar(10)='')   
as   
SELECT ReRate.Rate, ReRate.CCYTo   
From ReRate
Where 
ReRate.TOC=@P_TOC
and ReRate.Currency=@P_Currency
and ReRate.RYear=coalesce((   
 Select Top 1 R1.RYear   
 from Reinsurance R1, ReClass R2   
 Left Join RePolicy R3 on (R3.RNO=R2.RNO and R3.ID=@P_PHolder)   
 Where (R1.Category<>'P' or Coalesce(R3.ID,'')<>'') and R1.RType='Q' and R2.RNO=R1.RNO and R2.TOC=@P_TOC and @P_SDate Between R1.SDate and R1.EDate   
 Order By coalesce(R3.ID,'') Desc, (Case When R2.PriorityF=1 Then R2.PriorityF else R1.PriorityF end) Desc),Year(@P_SDate)) 

GO

DROP Procedure [dbo].[QPolicy_Rate]
GO
CREATE Procedure [dbo].[QPolicy_Rate](@P_ANO as int)     
as     
Select ICALC.Code, ICALC.SDate, SUM(ICALC.TSI) as TSI, Max(ICALC.PrevMinRate) as PrevMinRate, Max(ICALC.PrevMaxRate) as PrevMaxRate, Max(ICALC.MinRate) as MinRate, Max(ICALC.MaxRate) as MaxRate     
from     
(     
Select ICALC.Code, ICALC.SDate,     
MAX((Case When ICover.Category='M' then ICALC.TSI else 0 end)*(CASE WHEN RCOVER.PCTLOSS=0 THEN 100 ELSE RCOVER.PCTLOSS END)/(CASE WHEN RCOVER.PCTLOSS=0 THEN 100 ELSE RCOVER.PCTLOSS END+RCOVER.PAddition)) as TSI,     
CAST(0 as FLOAT) as PREVMINRATE,     
CAST(0 as FLOAT) as PREVMAXRATE,     
ROUND(SUM(ICALC.GROSS*100/(100-RCover.Discount)/ICALC.TSI/(Case When RCOVER.LOADING=0 THEN 1 ELSE RCOVER.LOADING END)*Case When ICalc.PCTADJ<>0 Then cast(100 as Float)/ICALC.PCTADJ else 1 end*Case When ICALC.Prorata=1 then (Case When Day(ICALC.SDate)<>Day(ICALC.EDate) then cast(Cover.Prorata as Float)/datediff(day,ICALC.SDate, ICALC.EDate) else cast(case When TOC.PTerm=0 Then 12 else TOC.PTerm end as Float)/datediff(Month, ICALC.SDate, ICALC.EDate) end) else (Case When RCover.PCalc='P' and Cover.Voyage=0 then Case When day(ICalc.SDate)<>day(ICalc.EDate) or Cover.PPeriod=1 then cast(Cover.Prorata as Float)/datediff(day,ICalc.SDate, ICalc.EDate) else cast(case When TOC.PTerm=0 Then 12 else TOC.PTerm end as Float)/datediff(month,ICalc.SDate, ICalc.EDate) end else 1/ICALC.Prorata end) end)*100,15) as MINRATE,     
ROUND(SUM(ICALC.GROSS*100/(100-RCover.Discount)/ICALC.TSI/(Case When RCOVER.LOADING=0 THEN 1 ELSE RCOVER.LOADING END)*Case When ICalc.PCTADJ<>0 Then cast(100 as Float)/ICALC.PCTADJ else 1 end*Case When ICALC.Prorata=1 then (Case When Day(ICALC.SDate)<>Day(ICALC.EDate) then cast(Cover.Prorata as Float)/datediff(day,ICALC.SDate, ICALC.EDate) else cast(case When TOC.PTerm=0 Then 12 else TOC.PTerm end as Float)/datediff(Month, ICALC.SDate, ICALC.EDate) end) else (Case When RCover.PCalc='P' and Cover.Voyage=0 then Case When day(ICalc.SDate)<>day(ICalc.EDate) or Cover.PPeriod=1 then cast(Cover.Prorata as Float)/datediff(day,ICalc.SDate, ICalc.EDate) else cast(case When TOC.PTerm=0 Then 12 else TOC.PTerm end as Float)/datediff(month,ICalc.SDate, ICalc.EDate) end else 1/ICALC.Prorata end) end)*100,15) as MAXRATE     
from COVER, ACCEPTANCE, ICover, ICALC, RCover, TOC
Where ACCEPTANCE.ANO=@P_ANO and COVER.CNO=ACCEPTANCE.CNO and COVER.ISType in ('I','C','L') and RCover.ANO=Acceptance.ANO     
and RCover.ANO=ICALC.ANO and RCover.Code=ICALC.Code and RCover.SDate=ICALC.SDate and RCover.EDate=ICALC.EDate and datediff(month, ICALC.SDate, ICALC.EDate)<>0     
and ICover.INO=ICalc.INO and ICALC.TSI<>0     
and TOC.TOC=ACCEPTANCE.TOC
Group By ICalc.INO, ICALC.Code, ICALC.SDate     
     
Union All     
     
Select ICALC.Code, ICALC.SDate,     
0 as TSI,     
ROUND(SUM(ICALC.GROSS*100/(100-RCover.Discount)/ICALC.TSI/(Case When RCOVER.LOADING=0 THEN 1 ELSE RCOVER.LOADING END)*Case When ICalc.PCTADJ<>0 Then cast(100 as Float)/ICALC.PCTADJ else 1 end*Case When ICALC.Prorata=1 then (Case When Day(ICALC.SDate)<>Day(ICALC.EDate) then cast(Cover.Prorata as Float)/datediff(day,ICALC.SDate, ICALC.EDate) else cast(case When TOC.PTerm=0 Then 12 else TOC.PTerm end as Float)/datediff(Month, ICALC.SDate, ICALC.EDate) end) else (Case When RCover.PCalc='P' and Cover.Voyage=0 then Case When day(ICalc.SDate)<>day(ICalc.EDate) or Cover.PPeriod=1 then cast(Cover.Prorata as Float)/datediff(day,ICalc.SDate, ICalc.EDate) else cast(case When TOC.PTerm=0 Then 12 else TOC.PTerm end as Float)/datediff(month,ICalc.SDate, ICalc.EDate) end else 1/ICALC.Prorata end) end)*100,15) as PREVMINRATE,     
ROUND(SUM(ICALC.GROSS*100/(100-RCover.Discount)/ICALC.TSI/(Case When RCOVER.LOADING=0 THEN 1 ELSE RCOVER.LOADING END)*Case When ICalc.PCTADJ<>0 Then cast(100 as Float)/ICALC.PCTADJ else 1 end*Case When ICALC.Prorata=1 then (Case When Day(ICALC.SDate)<>Day(ICALC.EDate) then cast(Cover.Prorata as Float)/datediff(day,ICALC.SDate, ICALC.EDate) else cast(case When TOC.PTerm=0 Then 12 else TOC.PTerm end as Float)/datediff(Month, ICALC.SDate, ICALC.EDate) end) else (Case When RCover.PCalc='P' and Cover.Voyage=0 then Case When day(ICalc.SDate)<>day(ICalc.EDate) or Cover.PPeriod=1 then cast(Cover.Prorata as Float)/datediff(day,ICalc.SDate, ICalc.EDate) else cast(case When TOC.PTerm=0 Then 12 else TOC.PTerm end as Float)/datediff(month,ICalc.SDate, ICalc.EDate) end else 1/ICALC.Prorata end) end)*100,15) as PREVMAXRATE,     
CAST(0 as FLOAT) as MINRATE,     
CAST(0 as FLOAT) as MAXRATE     
from COVER, ACCEPTANCE, ACCEPTANCE PACCEPTANCE, ICover, ICALC, RCover, TOC
Where ACCEPTANCE.ANO=@P_ANO and COVER.CNO=ACCEPTANCE.CNO and COVER.ISType in ('I','C','L') and PACCEPTANCE.ANO=ACCEPTANCE.PANO and RCOVER.ANO=PACCEPTANCE.ANO     
and RCover.ANO=ICALC.ANO and RCover.Code=ICALC.Code and RCover.SDate=ICALC.SDate and RCover.EDate=ICALC.EDate and datediff(month, ICALC.SDate, ICALC.EDate)<>0     
and ICover.INO=ICalc.INO and ICALC.TSI<>0     
and TOC.TOC=ACCEPTANCE.TOC
Group By ICalc.INO, ICALC.Code, ICALC.SDate     
) ICALC     
Group By ICALC.Code, ICALC.SDate     
Having SUM(ICALC.TSI)<>0     
     
GO
DROP Procedure Get_Fee_Amount_By_Percentage
GO
Create Procedure Get_Fee_Amount_By_Percentage(@P_ANO as Int, @P_Code as varchar(10), @P_FDType as varchar(1), @P_AmountPCT as Float)
as

Declare @P_LANO as integer
Declare @P_REGNO as varchar(20)

Select @P_LANO=LANO, @P_REGNO=REGNO from Acceptance Where ANO=@P_ANO

if @P_LANO<>@P_ANO -- Individual or Certificate
	Select 
	Case 
	When @P_FDTYPE<>'O' Then sum(D1.Gross*P.Gross/P.OGross*P.OurShare/P.TSI*(100-R.MSHARE)/100*(100-dbo.Premium_Discount(D1.ANO, D1.Code,cast(datediff(Month,A.SDate, D1.SDate) as integer) / 12 + 1))/100) 
	Else sum(D1.Gross*P.Gross/P.OGross*P.OurShare/P.TSI*(100-R.MSHARE)/100) End*@P_AmountPCT/100 as Fee
	from Display_Gross_Calculation(@P_ANO) D1, Acceptance A, PCalc P, RARRHEADER R
	Where P.ANO=A.ANO and P.Currency=D1.Currency and A.ANO=D1.ANO and R.ANO=A.ANO and A.ANO=@P_ANO and D1.Currency=@P_Code
ELSE	-- Fleet Only
	SELECT SUM(FEE)
	FROM
	(
		SELECT
		ACCEPTANCE.ANO,
		(
			Select 
			Case 
			When @P_FDTYPE<>'O' Then sum(D1.Gross*P.Gross/P.OGross*P.OurShare/P.TSI*(100-R.MSHARE)/100*(100-dbo.Premium_Discount(D1.ANO, D1.Code,cast(datediff(Month,A.SDate, D1.SDate) as integer) / 12 + 1))/100) 
			Else sum(D1.Gross*P.Gross/P.OGross*P.OurShare/P.TSI*(100-R.MSHARE)/100) End*@P_AmountPCT/100 as Fee
			from Display_Gross_Calculation(ACCEPTANCE.ANO) D1, Acceptance A, PCalc P, RARRHEADER R
			Where P.ANO=A.ANO and P.Currency=D1.Currency and A.ANO=D1.ANO and R.ANO=A.ANO and A.ANO=ACCEPTANCE.ANO and D1.Currency=@P_Code
		) as FEE
		FROM ACCEPTANCE, COVER
		WHERE COVER.CNO=ACCEPTANCE.CNO AND COVER.OPENFLAG=0 AND ACCEPTANCE.ANO<>ACCEPTANCE.LANO AND ACCEPTANCE.LANO=@P_ANO AND ACCEPTANCE.REGNO=@P_REGNO
	) A



GO

DROP FUNCTION FL_SL_ACCOUNT
GO
CREATE FUNCTION FL_SL_ACCOUNT(@P_GID varchar(10), @P_Voucher varchar(20), @P_VType varchar(10), @P_ComAcc varchar(30), @P_Doc_No varchar(20),@P_CCY varchar(10), @P_Payment_Flag bit)                                    
RETURNS @TSL_Account TABLE (Account Varchar(10), Open_ItemF Bit, Branch Varchar(15), Hint Int, Description varchar(512), Currency varchar(10), AccGroup varchar(10), Outstanding Float)                                    
AS                                        
BEGIN                               
Declare @P_SL_Cat varchar(1)                
                       
if @P_Payment_Flag=1                       
Begin              
 Select @P_SL_Cat=SL_Cat from pVoucher Where Voucher=@P_Doc_No                
 if @P_SL_Cat is null                 
 Begin              
   Select @P_SL_Cat='N'                
 End                
 if @P_SL_Cat='P'                
 Begin                           
   insert into @TSL_Account                                    
   Select A1.Account, A2.Open_ItemF, A1.Branch, A1.Hint, A2.Description, V.Currency, A2.AccGroup,          
   (Case When VType.DebtorF=1 Then 1 Else -1 end)*(Case When V.DebtorF=1 then -(Max(A1.Nominal_OC)-sum(Case When SL_Alloc.Nominal_OC is null then 0 else SL_Alloc.Nominal_OC end)) else (Max(A1.Nominal_OC)-sum(Case When SL_Alloc.Nominal_OC is null then 0 else SL_Alloc.Nominal_OC end)) end) as Outstanding              
   from pVoucher V                                     
   Inner Join Get_Open_Item_Hint_P(@P_Doc_No,@P_VType) A1 on (A1.Voucher=V.Voucher)                                     
   Inner join VType on (VType.VType=@P_VType)          
   Inner Join Account A2 on (A2.Account=A1.Account)     
   Left Join ComAcc on (ComAcc.ComAcc=@P_ComAcc)    
   Left Join Open_Item_Allocated(@P_Doc_No) SL_Alloc on (SL_Alloc.Voucher<>@P_Voucher and SL_Alloc.Doc_no=A1.Voucher and SL_Alloc.Branch=A1.Branch and SL_Alloc.Account=A1.Account)                                     
   Where @P_Doc_No<>'' and A1.Voucher=V.Voucher                                     
   and ((coalesce(ComAcc.ComAcc,'')='' and A2.AccGroup='') or (coalesce(ComAcc.ComAcc,'')<>'' and (ComAcc.AccGroup='' or A2.AccGroup='' or ComAcc.AccGroup=A2.AccGroup)))     
   Group By A1.Account, A2.Open_ItemF, A1.Branch, A1.Hint, VType.DebtorF, V.DebtorF, V.SL_Cat, A2.Description, V.Currency , A2.AccGroup                                  
   Having round(Max(A1.Nominal_OC),2)<>round(sum(Case When SL_Alloc.Nominal_OC is null then 0 else SL_Alloc.Nominal_OC end),2)                                        
 End              
 else                
 Begin              
   insert into @TSL_Account                                    
   Select A1.Account, A2.Open_ItemF, A1.Branch, A1.Hint, A2.Description, V.Currency, A2.AccGroup,
   (Case When VType.DebtorF=1 Then 1 Else -1 end)*(Case When V.DebtorF=1 then (Max(A1.Nominal_OC)-sum(Case When SL_Alloc.Nominal_OC is null then 0 else SL_Alloc.Nominal_OC end)) else (Max(A1.Nominal_OC)-sum(Case When SL_Alloc.Nominal_OC is null then 0 else SL_Alloc.Nominal_OC end)) end) as Outstanding              
   from nVoucher V                                     
   Inner Join Get_Open_Item_Hint_N(@P_Doc_No,@P_VType) A1 on (A1.Voucher=V.Voucher)                                     
   Inner join VType on (VType.VType=@P_VType)          
   Inner Join Account A2 on (A2.Account=A1.Account)       
   Left Join ComAcc on (ComAcc.ComAcc=@P_ComAcc)
   Left Join Open_Item_Allocated(@P_Doc_No) SL_Alloc on (SL_Alloc.Voucher<>@P_Voucher and SL_Alloc.Doc_no=A1.Voucher and SL_Alloc.Branch=A1.Branch and SL_Alloc.Account=A1.Account)                                     
   Where @P_Doc_No<>'' and A1.Voucher=V.Voucher                                     
   and ((coalesce(ComAcc.ComAcc,'')='' and A2.AccGroup='') or (coalesce(ComAcc.ComAcc,'')<>'' and (ComAcc.AccGroup='' or A2.AccGroup='' or ComAcc.AccGroup=A2.AccGroup)))     
   Group By A1.Account, A2.Open_ItemF, A1.Branch, A1.Hint, VType.DebtorF, V.DebtorF, V.SL_Cat, A2.Description, V.Currency, A2.AccGroup                                   
   Having round(Max(A1.Nominal_OC),2)<>round(sum(Case When SL_Alloc.Nominal_OC is null then 0 else SL_Alloc.Nominal_OC end),2)                         
 End              
End              
Else            
Begin           
 if @P_GID=''       
 Begin                        
  insert into @TSL_Account                                
  Select A1.Account, A1.Open_ItemF, '' as Branch, max(CASE WHEN vtype.debtorf=1 THEN vPattern.Credit ELSE vpattern.debit end) as Hint, A1.Description, Case When @P_CCY='' then SysTab.Currency else @P_CCY end as Currency, A1.AccGroup, 0 as Outstanding                 
  from Account A1 
  Left Join ComAcc on (ComAcc.ComAcc=@P_ComAcc), Account a2, vPattern, SysTab, VType              
  Where A1.AllowedF=1 and a1.post_flag=1 and a1.parent=a2.parent and a2.account=vPattern.account and vPattern.Constant_Flag=1 and ((vPattern.Credit<0 AND VType.DebtorF = 1) or (vPattern.Debit<0 AND VType.CreditorF = 1)) and VType.Vtype=@P_VType AND VType.VType = VPattern.VType and (A1.Hold_Flag<>1 or A1.Suspend_Flag=1)                                    
  and ((coalesce(ComAcc.ComAcc,'')='' and A1.AccGroup='') or (coalesce(ComAcc.ComAcc,'')<>'' and (ComAcc.AccGroup='' or A1.AccGroup='' or ComAcc.AccGroup=A1.AccGroup)))     
  Group By A1.Account, A1.Open_ItemF, A1.Description, SysTab.Currency, A1.AccGroup                                   
 End      
 Else      
 Begin      
  insert into @TSL_Account                                    
  Select A1.Account, A1.Open_ItemF, '' as Branch, max(CASE WHEN vtype.debtorf=1 THEN vPattern.Credit ELSE vpattern.debit end) as Hint, B.Description, Case When @P_CCY='' then SysTab.Currency else @P_CCY end as Currency, A1.AccGroup, 0 as Outstanding                   
  from Budget_AccountDetail B, Account A1 
  Left Join ComAcc on (ComAcc.ComAcc=@P_ComAcc), Account a2, vPattern, SysTab, VType                                       
  Where B.GID=@P_GID and B.ID=@P_Doc_No and (A1.Account=B.Account_Dr or A1.Account=B.Account_Cr) and A1.AllowedF=1 and a1.post_flag=1 and a1.parent=a2.parent and a2.account=vPattern.account and vPattern.Constant_Flag=1 and ((vPattern.Credit<0 AND VType.DebtorF = 1) or (vPattern.Debit<0 AND VType.CreditorF = 1)) and VType.Vtype=@P_VType AND VType.VType = VPattern.VType and (A1.Hold_Flag<>1 or A1.Suspend_Flag=1)                                      
  and ((coalesce(ComAcc.ComAcc,'')='' and A1.AccGroup='') or (coalesce(ComAcc.ComAcc,'')<>'' and (ComAcc.AccGroup='' or A1.AccGroup='' or ComAcc.AccGroup=A1.AccGroup)))     
  Group By A1.Account, A1.Open_ItemF, B.Description, SysTab.Currency, A1.AccGroup            
 End      
End       
       
Return                                    
END                

GO

DROP FUNCTION FN_NJOURNAL_SL
GO
CREATE FUNCTION FN_NJOURNAL_SL( @P_SDate as  smalldatetime,@P_EDate as smalldatetime)      
RETURNS TABLE         
AS RETURN ( 
Select
Distinct
SL.Voucher,
SL.Doc_No,
SL.Doc_Date,
SL.Remarks,
SL.Account, 
Case When Type.BS_Flag=1 Then '' When SL.CT='' Then Voucher.CT else SL.CT end as CT,
(Case When Type.PL_Flag=1 then SysTab.Currency else Voucher.Currency end) as Doc_CCY,
Case When Type.PL_FLAG=1 Then 
	Case When Voucher.DebtorF=1 then SL.Nominal*Voucher.Rate else -SL.Nominal*Voucher.Rate end
else
	Case When Voucher.DebtorF=1 then SL.Nominal else -SL.Nominal end
end as Nominal_OC,
Case When Type.PL_FLAG=1 Then 
	1
else
	Voucher.Rate
end as Rate,
Case When Type.PL_FLAG=1 Then 
	Case When Voucher.DebtorF=1 then SL.Nominal*Voucher.Rate else -SL.Nominal*Voucher.Rate end
else
	Case When Voucher.DebtorF=1 then SL.Nominal*Voucher.Rate else -SL.Nominal*Voucher.Rate end
end as Nominal
from nSL SL, nVoucher Voucher, nJournal Journal, Account, Type, SysTab
Where Voucher.Voucher=SL.Voucher and Account.Account=SL.Account and Type.Type=Account.Type
and Journal.Voucher=SL.Voucher and Journal.Account=SL.Account 
and Journal.Currency=(Case When Type.PL_Flag=1 then SysTab.Currency else Voucher.Currency end)
and Journal.CT=(Case When Type.BS_Flag=1 Then '' When SL.CT='' Then Voucher.CT else SL.CT end)
and Voucher.Date Between @P_SDate and @P_EDate
)

GO

DROP FUNCTION FN_PJOURNAL_SL
GO
CREATE FUNCTION FN_PJOURNAL_SL( @P_SDate as  smalldatetime,@P_EDate as smalldatetime)            
RETURNS TABLE               
AS RETURN (       
Select      
Distinct      
SL.SortNo,
SL.Voucher,      
SL.Doc_No,      
SL.Doc_Date,      
SL.Remarks,      
SL.Account,       
Case When Type.BS_Flag=1 Then '' When SL.CT='' Then Voucher.CT else SL.CT end as CT,      
Case When Type.PL_Flag=1 then SysTab.Currency When SL.PaymentF=1 Then SL.Doc_CCY else Voucher.Currency end as Doc_CCY,      
Case When Voucher.SL_Cat IN ('A','B','P') then      
  Case       
   When SL.PaymentF=1 Then Case When Voucher.DebtorF=1 Then -SL.Nominal_OC else SL.Nominal_OC end      
   When Type.PL_Flag=1 Then Case When Voucher.DebtorF=1 then -SL.Nominal*Voucher.Rate else SL.Nominal*Voucher.Rate end      
   else Case When Voucher.DebtorF=1 Then -SL.Nominal else SL.Nominal end      
   end      
  else      
  Case       
   When SL.PaymentF=1 Then Case When Voucher.DebtorF=1 Then SL.Nominal_OC else -SL.Nominal_OC end      
   When Type.PL_Flag=1 Then Case When Voucher.DebtorF=1 then SL.Nominal*Voucher.Rate else -SL.Nominal*Voucher.Rate end      
   else Case When Voucher.DebtorF=1 Then SL.Nominal else -SL.Nominal end      
   end      
  end AS Nominal_OC,        
Case When Voucher.SL_Cat IN ('A','B','P') then      
  Case       
   When SL.PaymentF=1 Then (Case When (Journal.Debit_OC+Journal.Credit_OC)<>0 Then (Journal.Debit+Journal.Credit)/(Journal.Debit_OC+Journal.Credit_OC) else 0 End)  
   When Type.PL_Flag=1 Then 1      
   else Voucher.Rate end      
  else      
  Case       
   When SL.PaymentF=1 Then (Case When (Journal.Debit_OC+Journal.Credit_OC)<>0 Then (Journal.Debit+Journal.Credit)/(Journal.Debit_OC+Journal.Credit_OC) else 0 End)      
   When Type.PL_Flag=1 Then 1      
   else Voucher.Rate end         
  end AS Rate,        
Case When Voucher.SL_Cat IN ('A','B','P') then      
  Case       
   When SL.PaymentF=1 Then Case When Voucher.DebtorF=1 Then -SL.Nominal_OC else SL.Nominal_OC end *(Case When (Journal.Debit_OC+Journal.Credit_OC)<>0 Then (Journal.Debit+Journal.Credit)/(Journal.Debit_OC+Journal.Credit_OC) else 0 End)      
   When Type.PL_Flag=1 Then Case When Voucher.DebtorF=1 then -SL.Nominal*Voucher.Rate else SL.Nominal*Voucher.Rate end      
   else Case When Voucher.DebtorF=1 Then -SL.Nominal else SL.Nominal end*Voucher.Rate       
   end      
  else      
  Case       
   When SL.PaymentF=1 Then Case When Voucher.DebtorF=1 Then SL.Nominal_OC else -SL.Nominal_OC end *(Case When (Journal.Debit_OC+Journal.Credit_OC)<>0 Then (Journal.Debit+Journal.Credit)/(Journal.Debit_OC+Journal.Credit_OC) else 0 End)      
   When Type.PL_Flag=1 Then Case When Voucher.DebtorF=1 then SL.Nominal*Voucher.Rate else -SL.Nominal*Voucher.Rate end      
   else Case When Voucher.DebtorF=1 Then SL.Nominal else -SL.Nominal end*Voucher.Rate       
   end      
  end AS Nominal      
from pSL SL, pVoucher Voucher, pJournal Journal, Account, Type, SysTab      
Where Voucher.Voucher=SL.Voucher and Account.Account=SL.Account and Type.Type=Account.Type      
and Journal.Voucher=SL.Voucher and Journal.Account=SL.Account       
and Journal.Currency=(Case When Type.PL_Flag=1 then SysTab.Currency When SL.PaymentF=1 Then SL.Doc_CCY else Voucher.Currency end)      
and Journal.CT=(Case When Type.BS_Flag=1 Then '' When SL.CT='' Then Voucher.CT else SL.CT end)      
and Voucher.Date Between @P_SDate and @P_EDate      
) 


GO

DROP Function Get_Payment_Percentage
GO
CREATE Function Get_Payment_Percentage(@P_A_PolicyNo varchar(50), @P_Date smalldatetime)
RETURNS Float AS        
  
BEGIN       
Declare @PCT as Float

Select 
@PCT=sum(case When V.DebtorF=1 Then (V.Payment_CC) Else -(V.Payment_CC) end)/sum(case When V.DebtorF=1 Then (V.Nominal_CC-V.Diff_CC) Else -(V.Nominal_CC-V.Diff_CC) end)*100
from Admlink a, nVoucher V 
Where V.Voucher=A.Voucher and A.Date<=@P_Date and A.A_PolicyNo=@P_A_PolicyNo and A.SUbject='Premium' and V.DebtorF=1 and A.Type in ('DI','IC','IR')
Having sum(case When V.DebtorF=1 Then (V.Nominal_CC-V.Diff_CC) Else -(V.Nominal_CC-V.Diff_CC) end)<>0

if @PCT IS NULL 
	SELECT @PCT=0

Return @PCT
End

            
GO

DROP procedure PI09 
GO
CREATE procedure PI09 (@P_ANO as integer) 
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
 
Select Voucher.Voucher, Voucher.DueDate, Voucher.DocNo, Profile.Name, Voucher.Currency, 
case when Voucher.debtorf=1 then Voucher.Nominal_CC-Voucher.Diff_CC else -(Voucher.Nominal_CC-Voucher.Diff_CC) end  as Nominal, 
case when Voucher.debtorf=1 then (Voucher.AmountDue-Voucher.Payment_CC) else -(Voucher.AmountDue-Voucher.Payment_CC) end as AmountDue, 
case when Voucher.debtorf=1 then Voucher.Payment_CC else -Voucher.Payment_CC end as Payment, 
case when Voucher.debtorf=1 then Voucher.Nominal_CC-Voucher.Diff_CC - Voucher.Payment_CC else -(Voucher.Nominal_CC-Voucher.Diff_CC - Voucher.Payment_CC) end as Outstanding 
 
from nVoucher Voucher, Profile, ProAcc, Admlink 
Where Profile.ID=ProAcc.ID and ProAcc.ProAcc=Voucher.ProAcc and Admlink.Voucher=Voucher.Voucher 
and Admlink.Subject='Claim' and Admlink.Type in ('DI','IC','IR','OP') and Admlink.A_PolicyNo<>'' and Admlink.A_PolicyNo=@P_A_PolicyNo and (Admlink.Extra_1='' or Admlink.Extra_1 is null) 
and round(Voucher.AmountDue,0)>round(Voucher.Payment_CC,0) 
End 
 
 
GO

DROP Function Premium_MaxOutGo
GO
CREATE Function Premium_MaxOutGo(@P_ANO as int,@P_Code as varchar(10),@P_Period int=0)        
RETURNS Float        
AS        

BEGIN        
 --Return (dbo.premium_discount(@P_ANO, @P_Code,@P_Period)-dbo.Payor_Group_Discount(@P_ANO, @P_Code,@P_Period)+dbo.Premium_Commission(@P_ANO, @P_Code,@P_Period,0)+dbo.Premium_Commission_Vat(@P_ANO, @P_Code,@P_Period,0))        
 --Return (dbo.Premium_Commission(@P_ANO, @P_Code,@P_Period,0)-dbo.Premium_Commission_UpFee(@P_ANO, @P_Code,@P_Period,0))  
 --Return (100/(100-dbo.premium_discount(@P_ANO, @P_Code,@P_Period))*(dbo.Premium_Commission(@P_ANO, @P_Code,@P_Period,0)-dbo.Premium_Commission_UpFee(@P_ANO, @P_Code,@P_Period,0)))
 Return (dbo.premium_discount(@P_ANO, @P_Code,@P_Period)+dbo.Premium_Commission(@P_ANO, @P_Code,@P_Period,0)-dbo.Premium_Commission_UpFee(@P_ANO, @P_Code,@P_Period,0))  
End      

GO

DROP procedure PI08 
GO
CREATE procedure PI08 (@P_ANO as integer)   
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
   
Select Voucher.Voucher, Voucher.DueDate, Voucher.DocNo, Voucher_Due.DueDate as NDueDate, Profile.Name, Voucher.Currency,   
Admlink.RefType,  
Admlink.AccountNo, Admlink.Bank, Admlink.BankName,   
Admlink.AccountNo_Ext, Admlink.Bank_Ext, Admlink.BankName_Ext,   
case when Voucher.debtorf=1 then Voucher.Nominal_CC-Voucher.Diff_CC else -(Voucher.Nominal_CC-Voucher.Diff_CC) end  as Nominal,   
case when Voucher.debtorf=1 then (coalesce(Voucher_Due.AmountDue, Voucher.AmountDue)-Voucher.Payment_CC) else -(coalesce(Voucher_Due.AmountDue, Voucher.AmountDue)-Voucher.Payment_CC) end as AmountDue,   
case when Voucher.debtorf=1 then Voucher.Payment_CC else -Voucher.Payment_CC end as Payment,   
case when Voucher.debtorf=1 then Voucher.Nominal_CC-Voucher.Diff_CC - Voucher.Payment_CC else -(Voucher.Nominal_CC-Voucher.Diff_CC - Voucher.Payment_CC) end as Outstanding,   
Voucher.Installment,   
Voucher.DueDate_1, case when Voucher.debtorf=1 then Voucher.AmountDue_1 else -Voucher.AmountDue_1 end AmountDue_1,   
Voucher.DueDate_2, case when Voucher.debtorf=1 then Voucher.AmountDue_2 else -Voucher.AmountDue_2 end AmountDue_2,   
Voucher.DueDate_3, case when Voucher.debtorf=1 then Voucher.AmountDue_3 else -Voucher.AmountDue_3 end AmountDue_3,   
Voucher.DueDate_4, case when Voucher.debtorf=1 then Voucher.AmountDue_4 else -Voucher.AmountDue_4 end AmountDue_4,   
Voucher.DueDate_5, case when Voucher.debtorf=1 then Voucher.AmountDue_5 else -Voucher.AmountDue_5 end AmountDue_5,   
Voucher.DueDate_6, case when Voucher.debtorf=1 then Voucher.AmountDue_6 else -Voucher.AmountDue_6 end AmountDue_6,   
Voucher.DueDate_7, case when Voucher.debtorf=1 then Voucher.AmountDue_7 else -Voucher.AmountDue_7 end AmountDue_7,   
Voucher.DueDate_8, case when Voucher.debtorf=1 then Voucher.AmountDue_8 else -Voucher.AmountDue_8 end AmountDue_8,   
Voucher.DueDate_9, case when Voucher.debtorf=1 then Voucher.AmountDue_9 else -Voucher.AmountDue_9 end AmountDue_9,   
Voucher.DueDate_10, case when Voucher.debtorf=1 then Voucher.AmountDue_10 else -Voucher.AmountDue_10 end AmountDue_10,   
Voucher.DueDate_11, case when Voucher.debtorf=1 then Voucher.AmountDue_11 else -Voucher.AmountDue_11 end AmountDue_11,   
Voucher.DueDate_12, case when Voucher.debtorf=1 then Voucher.AmountDue_12 else -Voucher.AmountDue_12 end AmountDue_12,   
Voucher.DueDate_13, case when Voucher.debtorf=1 then Voucher.AmountDue_13 else -Voucher.AmountDue_13 end AmountDue_13,   
Voucher.DueDate_14, case when Voucher.debtorf=1 then Voucher.AmountDue_14 else -Voucher.AmountDue_14 end AmountDue_14,   
Voucher.DueDate_15, case when Voucher.debtorf=1 then Voucher.AmountDue_15 else -Voucher.AmountDue_15 end AmountDue_15,   
Voucher.DueDate_16, case when Voucher.debtorf=1 then Voucher.AmountDue_16 else -Voucher.AmountDue_16 end AmountDue_16,   
Voucher.DueDate_17, case when Voucher.debtorf=1 then Voucher.AmountDue_17 else -Voucher.AmountDue_17 end AmountDue_17,   
Voucher.DueDate_18, case when Voucher.debtorf=1 then Voucher.AmountDue_18 else -Voucher.AmountDue_18 end AmountDue_18,   
Voucher.DueDate_19, case when Voucher.debtorf=1 then Voucher.AmountDue_19 else -Voucher.AmountDue_19 end AmountDue_19,   
Voucher.DueDate_20, case when Voucher.debtorf=1 then Voucher.AmountDue_20 else -Voucher.AmountDue_20 end AmountDue_20,   
Voucher.DueDate_21, case when Voucher.debtorf=1 then Voucher.AmountDue_21 else -Voucher.AmountDue_21 end AmountDue_21,   
Voucher.DueDate_22, case when Voucher.debtorf=1 then Voucher.AmountDue_22 else -Voucher.AmountDue_22 end AmountDue_22,   
Voucher.DueDate_23, case when Voucher.debtorf=1 then Voucher.AmountDue_23 else -Voucher.AmountDue_23 end AmountDue_23,   
Voucher.DueDate_24, case when Voucher.debtorf=1 then Voucher.AmountDue_24 else -Voucher.AmountDue_24 end AmountDue_24   
from nVoucher Voucher Inner Join Voucher_AmountDue(@P_Date) Voucher_Due on (Voucher_Due.Voucher=Voucher.Voucher), Profile, ProAcc, Admlink   
Where Profile.ID=ProAcc.ID and ProAcc.ProAcc=Voucher.ProAcc and Admlink.Voucher=Voucher.Voucher   
and Admlink.Subject='Premium' and Admlink.Type in ('DI','IC','IR') and Admlink.A_PolicyNo<>'' and Admlink.A_PolicyNo=@P_A_PolicyNo and (Admlink.Extra_1='' or Admlink.Extra_1 is null)   
End   
   

go

--penambahan length address 
IF EXISTS (SELECT *  FROM sys.indexes WHERE name='I_PAlias' AND object_id = OBJECT_ID('PAlias'))
BEGIN
ALTER TABLE dbo.PAlias	DROP CONSTRAINT I_PAlias
END
GO

ALTER TABLE PALIAS ALTER COLUMN ADDRESS VARCHAR(1024)
GO

IF NOT EXISTS (SELECT *  FROM sys.indexes WHERE name='I_PALIAS_ID' AND object_id = OBJECT_ID('PALIAS'))
BEGIN
CREATE INDEX I_PALIAS_ID ON PALIAS(ID)
END
GO





DROP FUNCTION fn_RateCon
GO
CREATE FUNCTION fn_RateCon(@P_ANO as int,@P_Code as varchar(20),@P_TSI as Float=0)       
RETURNS Table       
AS RETURN (       
Select Top 1 *
From
(
	SELECT Top 1 RateTab.Code, cast(0 as Bit) as ProgressiveF, RateCon.AllowedF, RateCon.MinRate, RateCon.MaxRate, RateCon.PML, RateCon.TExcess, RateTab.RateLoadingF,       
	Case When coalesce(RateCon.Loading,0)=0 Then 100 else RateCon.Loading end as Loading,       
	Case When coalesce(RateCon.PCTLOSS,0)=0 Then 100 else RateCon.PCTLOSS end as PCTLOSS,       
	--Rate Always in Percent       
	Case       
	When RateCon.Unit='F' then (Case When (Case When @P_TSI=0 Then 1 Else @P_TSI End)<>0 Then RateCon.Rate/(Case When @P_TSI=0 Then 1 Else @P_TSI End)*100 else 0 end)       
	When RateCon.Unit='M' then RateCon.Rate/10       
	else RateCon.Rate end as Rate,       
	RateCon.MaxTSI as MaxTSI     
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
	cast(1 as Bit) as ProgressiveF,
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
	)as Rate,
	Max(RateCon.MaxTSI) as MaxTSI     
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


GO



IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'AutoInforceF' AND Object_ID = Object_ID(N'PTClass'))
BEGIN
ALTER TABLE dbo.PTClass ADD AutoInforceF bit NULL
DECLARE @v sql_variant 
SET @v = N'Auto Inforce Flag (0 : No, 1 : Yes, Must Use Auto Inforce)'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'PTClass', N'COLUMN', N'AutoInforceF'
end
go

Update PTClass set AutoInforceF=0 Where AutoInforceF is null
go

-- Penambahan detail Object Info
DROP PROCEDURE ListDet01 
GO
CREATE PROCEDURE ListDet01 (@P_ANO as integer) 
AS 
SELECT Cast(0 as bit) as ProcessFlag, Acceptance.CertificateNo, Acceptance.ESeqNo,Acceptance.AName, Acceptance.ANO, Acceptance.REGNO, Acceptance.ADATE, Acceptance.LUSERID as USERID,SysTab.Currency, Acceptance.ASTATUS, Acceptance.ATYPE, Acceptance.SDate, Acceptance.EDate, Acceptance.ValueID, dbo.get_objectInfo(Acceptance.ANO) as ValueDesc, Year(Coalesce(RArrHeader.RDate,Acceptance.SDate)) as RYear, QPCalc.TSI, QPCalc.OurShare, QPCalc.Gross 
FROM Acceptance left Join RArrHeader on (RArrHeader.ANO=Acceptance.ANO) Left Join QDetail_PCalc() QPCalc on (qPCalc.ANO=Acceptance.ANO and Acceptance.PStatus='C'), Cover, SysTab, Acceptance MAcceptance 
WHERE MAcceptance.ANO=@P_ANO and Cover.CNO=MAcceptance.CNO 
And (Acceptance.LANO=MAcceptance.ANO And Acceptance.ANO<>Acceptance.LANO And Acceptance.LANO<>-1) 
 
Union 
 
SELECT Cast(0 as bit) as ProcessFlag, Acceptance.CertificateNo, Acceptance.ESeqNo,Acceptance.AName, Acceptance.ANO, Acceptance.REGNO, Acceptance.ADATE, Acceptance.LUSERID as USERID,SysTab.Currency, Acceptance.ASTATUS, Acceptance.ATYPE, Acceptance.SDate, Acceptance.EDate, Acceptance.ValueID, dbo.get_objectInfo(Acceptance.ANO) as ValueDesc, Year(Coalesce(RArrHeader.RDate,Acceptance.SDate)) as RYear, QPCalc.TSI, QPCalc.OurShare, QPCalc.Gross 
FROM Acceptance left Join RArrHeader on (RArrHeader.ANO=Acceptance.ANO) Left Join QDetail_PCalc() QPCalc on (qPCalc.ANO=Acceptance.ANO and Acceptance.PStatus='C'), Cover, SysTab, Acceptance MAcceptance 
WHERE MAcceptance.ANO=@P_ANO and Cover.CNO=MAcceptance.CNO 
And (MAcceptance.RegNo<>'' and Acceptance.RegNo=MAcceptance.RegNo and Acceptance.PolicyNo<>'' and Acceptance.PolicyNo=MAcceptance.PolicyNo And Acceptance.ANO<>Acceptance.LANO And Acceptance.LANO<>-1) 
 
Union 
 
SELECT Cast(0 as bit) as ProcessFlag, Acceptance.CertificateNo, Acceptance.ESeqNo,Acceptance.AName, Acceptance.ANO, Acceptance.REGNO, Acceptance.ADATE, Acceptance.LUSERID as USERID,SysTab.Currency, Acceptance.ASTATUS, Acceptance.ATYPE, Acceptance.SDate, Acceptance.EDate, Acceptance.ValueID, dbo.get_objectInfo(Acceptance.ANO) as ValueDesc, Year(Coalesce(RArrHeader.RDate,Acceptance.SDate)) as RYear, QPCalc.TSI, QPCalc.OurShare, QPCalc.Gross 
FROM Acceptance left Join RArrHeader on (RArrHeader.ANO=Acceptance.ANO) Left Join QDetail_PCalc() QPCalc on (qPCalc.ANO=Acceptance.ANO and Acceptance.PStatus='C'), Cover, SysTab, Acceptance MAcceptance 
WHERE MAcceptance.ANO=@P_ANO and Cover.CNO=MAcceptance.CNO 
And (MAcceptance.AStatus='W' and MAcceptance.AType<>'N' and MAcceptance.PANO<>-1 and Acceptance.LANO=MAcceptance.PANO And Acceptance.ANO<>Acceptance.LANO And Acceptance.LANO<>-1) 
Order By Acceptance.CertificateNo 
 
GO
 
DROP PROCEDURE ListDet02 
GO
CREATE PROCEDURE ListDet02 (@P_ANO as integer) 
AS 
SELECT Cast(0 as bit) as ProcessFlag, Acceptance.CertificateNo, Acceptance.ESeqNo,Acceptance.AName, Acceptance.ANO, Acceptance.REGNO, Acceptance.ADATE, Acceptance.LUSERID as USERID, SysTab.Currency, Acceptance.ASTATUS, Acceptance.ATYPE, Acceptance.SDate, Acceptance.EDate, Acceptance.ValueID, dbo.get_objectInfo(Acceptance.ANO) as ValueDesc, Year(Coalesce(RArrHeader.RDate,Acceptance.SDate)) as RYear, QPCalc.TSI, QPCalc.OurShare, QPCalc.Gross 
FROM Acceptance left Join RArrHeader on (RArrHeader.ANO=Acceptance.ANO) Left Join QDetail_PCalc() QPCalc on (qPCalc.ANO=Acceptance.ANO and Acceptance.PStatus='C'), Cover, SysTab 
WHERE Cover.CNO=Acceptance.CNO And Acceptance.ANO=@P_ANO 
Order By Acceptance.CertificateNo 
 
GO
DROP PROCEDURE ListDet03 
GO
CREATE PROCEDURE ListDet03 (@P_ANO as integer,@P_SDATE as smalldatetime, @P_EDATE as smalldatetime) 
AS 
SELECT Cast(0 as bit) as ProcessFlag, Acceptance.CertificateNo, Acceptance.ESeqNo,Acceptance.AName, Acceptance.ANO, Acceptance.REGNO, Acceptance.ADATE, Acceptance.LUSERID as USERID,  SysTab.Currency, Acceptance.ASTATUS, Acceptance.ATYPE, Acceptance.SDate, Acceptance.EDate, Acceptance.ValueID, dbo.get_objectInfo(Acceptance.ANO) as ValueDesc, Year(Coalesce(RArrHeader.RDate,Acceptance.SDate)) as RYear, QPCalc.TSI, QPCalc.OurShare, QPCalc.Gross 
FROM Acceptance left Join RArrHeader on (RArrHeader.ANO=Acceptance.ANO) Left Join QDetail_PCalc() QPCalc on (qPCalc.ANO=Acceptance.ANO and Acceptance.PStatus='C'), Cover, SysTab, Acceptance MAcceptance 
WHERE MAcceptance.ANO=@P_ANO and Cover.CNO=MAcceptance.CNO 
And (Acceptance.LANO=MAcceptance.ANO And Acceptance.ANO<>Acceptance.LANO And Acceptance.LANO<>-1) 
And Acceptance.ADate Between @P_Sdate and @P_EDate 
 
Union 
 
SELECT Cast(0 as bit) as ProcessFlag, Acceptance.CertificateNo, Acceptance.ESeqNo,Acceptance.AName, Acceptance.ANO, Acceptance.REGNO, Acceptance.ADATE, Acceptance.LUSERID as USERID,  SysTab.Currency, Acceptance.ASTATUS, Acceptance.ATYPE, Acceptance.SDate, Acceptance.EDate, Acceptance.ValueID, dbo.get_objectInfo(Acceptance.ANO) as ValueDesc, Year(Coalesce(RArrHeader.RDate,Acceptance.SDate)) as RYear, QPCalc.TSI, QPCalc.OurShare, QPCalc.Gross 
FROM Acceptance left Join RArrHeader on (RArrHeader.ANO=Acceptance.ANO) Left Join QDetail_PCalc() QPCalc on (qPCalc.ANO=Acceptance.ANO and Acceptance.PStatus='C'), Cover, SysTab, Acceptance MAcceptance 
WHERE MAcceptance.ANO=@P_ANO and Cover.CNO=MAcceptance.CNO 
And (MAcceptance.RegNo<>'' and Acceptance.RegNo=MAcceptance.RegNo and Acceptance.PolicyNo<>'' and Acceptance.PolicyNo=MAcceptance.PolicyNo And Acceptance.ANO<>Acceptance.LANO And Acceptance.LANO<>-1) 
And Acceptance.ADate Between @P_Sdate and @P_EDate 
 
Union 
 
SELECT Cast(0 as bit) as ProcessFlag, Acceptance.CertificateNo, Acceptance.ESeqNo,Acceptance.AName, Acceptance.ANO, Acceptance.REGNO, Acceptance.ADATE, Acceptance.LUSERID as USERID,  SysTab.Currency, Acceptance.ASTATUS, Acceptance.ATYPE, Acceptance.SDate, Acceptance.EDate, Acceptance.ValueID, dbo.get_objectInfo(Acceptance.ANO) as ValueDesc, Year(Coalesce(RArrHeader.RDate,Acceptance.SDate)) as RYear, QPCalc.TSI, QPCalc.OurShare, QPCalc.Gross 
FROM Acceptance left Join RArrHeader on (RArrHeader.ANO=Acceptance.ANO) Left Join QDetail_PCalc() QPCalc on (qPCalc.ANO=Acceptance.ANO and Acceptance.PStatus='C'), Cover, SysTab, Acceptance MAcceptance 
WHERE MAcceptance.ANO=@P_ANO and Cover.CNO=MAcceptance.CNO 
And (MAcceptance.AStatus='W' and MAcceptance.AType<>'N' and MAcceptance.PANO<>-1 and Acceptance.LANO=MAcceptance.PANO And Acceptance.ANO<>Acceptance.LANO And Acceptance.LANO<>-1) 
And Acceptance.ADate Between @P_Sdate and @P_EDate 
Order By Acceptance.CertificateNo 
 
GO 

DROP PROCEDURE ListDet04 
GO 
CREATE PROCEDURE ListDet04 (@P_ANO as integer,@P_FCERTNO as varchar(20), @P_LCERTNO as varchar(20)) 
AS 
SELECT Cast(0 as bit) as ProcessFlag, Acceptance.CertificateNo, Acceptance.ESeqNo,Acceptance.AName, Acceptance.ANO, Acceptance.REGNO, Acceptance.ADATE, Acceptance.LUSERID as USERID,  SysTab.Currency, Acceptance.ASTATUS, Acceptance.ATYPE, Acceptance.SDate, Acceptance.EDate, Acceptance.ValueID, dbo.get_objectInfo(Acceptance.ANO) as ValueDesc, Year(Coalesce(RArrHeader.RDate,Acceptance.SDate)) as RYear, QPCalc.TSI, QPCalc.OurShare, QPCalc.Gross 
FROM Acceptance left Join RArrHeader on (RArrHeader.ANO=Acceptance.ANO) Left Join QDetail_PCalc() QPCalc on (qPCalc.ANO=Acceptance.ANO and Acceptance.PStatus='C'), Cover, SysTab, Acceptance MAcceptance 
WHERE MAcceptance.ANO=@P_ANO and Cover.CNO=MAcceptance.CNO 
And (Acceptance.LANO=MAcceptance.ANO And Acceptance.ANO<>Acceptance.LANO And Acceptance.LANO<>-1) 
And Acceptance.CertificateNo Between @P_FCertNo and @P_LCertNo 
 
Union 
 
SELECT Cast(0 as bit) as ProcessFlag, Acceptance.CertificateNo, Acceptance.ESeqNo,Acceptance.AName, Acceptance.ANO, Acceptance.REGNO, Acceptance.ADATE, Acceptance.LUSERID as USERID,  SysTab.Currency, Acceptance.ASTATUS, Acceptance.ATYPE, Acceptance.SDate, Acceptance.EDate, Acceptance.ValueID, dbo.get_objectInfo(Acceptance.ANO) as ValueDesc, Year(Coalesce(RArrHeader.RDate,Acceptance.SDate)) as RYear, QPCalc.TSI, QPCalc.OurShare, QPCalc.Gross 
FROM Acceptance left Join RArrHeader on (RArrHeader.ANO=Acceptance.ANO) Left Join QDetail_PCalc() QPCalc on (qPCalc.ANO=Acceptance.ANO and Acceptance.PStatus='C'), Cover, SysTab, Acceptance MAcceptance 
WHERE MAcceptance.ANO=@P_ANO and Cover.CNO=MAcceptance.CNO 
And (MAcceptance.RegNo<>'' and Acceptance.RegNo=MAcceptance.RegNo and Acceptance.PolicyNo<>'' and Acceptance.PolicyNo=MAcceptance.PolicyNo And Acceptance.ANO<>Acceptance.LANO And Acceptance.LANO<>-1) 
And Acceptance.CertificateNo Between @P_FCertNo and @P_LCertNo 
 
Union 
 
SELECT Cast(0 as bit) as ProcessFlag, Acceptance.CertificateNo, Acceptance.ESeqNo,Acceptance.AName, Acceptance.ANO, Acceptance.REGNO, Acceptance.ADATE, Acceptance.LUSERID as USERID,  SysTab.Currency, Acceptance.ASTATUS, Acceptance.ATYPE, Acceptance.SDate, Acceptance.EDate, Acceptance.ValueID, dbo.get_objectInfo(Acceptance.ANO) as ValueDesc, Year(Coalesce(RArrHeader.RDate,Acceptance.SDate)) as RYear, QPCalc.TSI, QPCalc.OurShare, QPCalc.Gross 
FROM Acceptance left Join RArrHeader on (RArrHeader.ANO=Acceptance.ANO) Left Join QDetail_PCalc() QPCalc on (qPCalc.ANO=Acceptance.ANO and Acceptance.PStatus='C'), Cover, SysTab, Acceptance MAcceptance 
WHERE MAcceptance.ANO=@P_ANO and Cover.CNO=MAcceptance.CNO 
And (MAcceptance.AStatus='W' and MAcceptance.AType<>'N' and MAcceptance.PANO<>-1 and Acceptance.LANO=MAcceptance.PANO And Acceptance.ANO<>Acceptance.LANO And Acceptance.LANO<>-1) 
And Acceptance.CertificateNo Between @P_FCertNo and @P_LCertNo 
Order By Acceptance.CertificateNo 
 
 
GO
DROP PROCEDURE ListDet05 
GO
CREATE PROCEDURE ListDet05 (@P_ANO as integer,@P_FBATCHNO as varchar(20), @P_LBATCHNO as varchar(20)) 
AS 
SELECT Cast(0 as bit) as ProcessFlag, Acceptance.CertificateNo, Acceptance.ESeqNo,Acceptance.AName, Acceptance.ANO, Acceptance.REGNO, Acceptance.ADATE, Acceptance.LUSERID as USERID,  SysTab.Currency, Acceptance.ASTATUS, Acceptance.ATYPE, Acceptance.SDate, Acceptance.EDate, Acceptance.ValueID, dbo.get_objectInfo(Acceptance.ANO) as ValueDesc, Year(Coalesce(RArrHeader.RDate,Acceptance.SDate)) as RYear, QPCalc.TSI, QPCalc.OurShare, QPCalc.Gross 
FROM Acceptance left Join RArrHeader on (RArrHeader.ANO=Acceptance.ANO) Left Join QDetail_PCalc() QPCalc on (qPCalc.ANO=Acceptance.ANO and Acceptance.PStatus='C'), Cover, SysTab, Acceptance MAcceptance 
WHERE MAcceptance.ANO=@P_ANO and Cover.CNO=MAcceptance.CNO 
And (Acceptance.LANO=MAcceptance.ANO And Acceptance.ANO<>Acceptance.LANO And Acceptance.LANO<>-1) 
And Acceptance.BatchNo Between @P_FBatchNo and @P_LBatchNo 
 
Union 
 
SELECT Cast(0 as bit) as ProcessFlag, Acceptance.CertificateNo, Acceptance.ESeqNo,Acceptance.AName, Acceptance.ANO, Acceptance.REGNO, Acceptance.ADATE, Acceptance.LUSERID as USERID,  SysTab.Currency, Acceptance.ASTATUS, Acceptance.ATYPE, Acceptance.SDate, Acceptance.EDate, Acceptance.ValueID, dbo.get_objectInfo(Acceptance.ANO) as ValueDesc, Year(Coalesce(RArrHeader.RDate,Acceptance.SDate)) as RYear, QPCalc.TSI, QPCalc.OurShare, QPCalc.Gross 
FROM Acceptance left Join RArrHeader on (RArrHeader.ANO=Acceptance.ANO) Left Join QDetail_PCalc() QPCalc on (qPCalc.ANO=Acceptance.ANO and Acceptance.PStatus='C'), Cover, SysTab, Acceptance MAcceptance 
WHERE MAcceptance.ANO=@P_ANO and Cover.CNO=MAcceptance.CNO 
And (MAcceptance.RegNo<>'' and Acceptance.RegNo=MAcceptance.RegNo and Acceptance.PolicyNo<>'' and Acceptance.PolicyNo=MAcceptance.PolicyNo And Acceptance.ANO<>Acceptance.LANO And Acceptance.LANO<>-1) 
And Acceptance.BatchNo Between @P_FBatchNo and @P_LBatchNo 
 
Union 
 
SELECT Cast(0 as bit) as ProcessFlag, Acceptance.CertificateNo, Acceptance.ESeqNo,Acceptance.AName, Acceptance.ANO, Acceptance.REGNO, Acceptance.ADATE, Acceptance.LUSERID as USERID,  SysTab.Currency, Acceptance.ASTATUS, Acceptance.ATYPE, Acceptance.SDate, Acceptance.EDate, Acceptance.ValueID, dbo.get_objectInfo(Acceptance.ANO) as ValueDesc, Year(Coalesce(RArrHeader.RDate,Acceptance.SDate)) as RYear, QPCalc.TSI, QPCalc.OurShare, QPCalc.Gross 
FROM Acceptance left Join RArrHeader on (RArrHeader.ANO=Acceptance.ANO) Left Join QDetail_PCalc() QPCalc on (qPCalc.ANO=Acceptance.ANO and Acceptance.PStatus='C'), Cover, SysTab, Acceptance MAcceptance 
WHERE MAcceptance.ANO=@P_ANO and Cover.CNO=MAcceptance.CNO 
And (MAcceptance.AStatus='W' and MAcceptance.AType<>'N' and MAcceptance.PANO<>-1 and Acceptance.LANO=MAcceptance.PANO And Acceptance.ANO<>Acceptance.LANO And Acceptance.LANO<>-1) 
And Acceptance.BatchNo Between @P_FBatchNo and @P_LBatchNo 
Order By Acceptance.CertificateNo 
 
GO 
DROP function ListDet05_b 
GO
Create function ListDet05_b (@P_ANO as integer,     
@Value1 as varchar(255), @Value2 as varchar(255), @Value3 as varchar(255), @Value4 as varchar(255), @Value5 as varchar(255),     
@Value6 varchar(255), @Value7 as varchar(255), @Value8 as varchar(255), @Value9 as varchar(255), @Value10 as varchar(255),    
@Value11 as varchar(255),@Value12 as varchar(255), @Value13 as varchar(255),@Value14 as varchar(255),@Value15 as varchar(255),    
@Value16 as varchar(255),@Value17 as varchar(255),@Value18 as varchar(255),@Value19 as varchar(255),@Value20 as varchar(255),@Value21 as varchar(255), @Value22 as varchar(255), @Value23 as varchar(255)    
)          
RETURNS Table      
AS RETURN      
(      
SELECT Cast(0 as bit) as ProcessFlag,      
 q.[CertificateNo],      
 q.ESeqNo,      
 q.[AName],      
 q.[ANO],      
 q.[REGNO],      
 q.[ADATE],      
 q.[USERID],      
 q.[Currency],      
 q.[TSI],      
 q.[OurShare],      
 q.[Gross],      
 q.[ASTATUS],      
 q.[ATYPE],      
 q.[SDate],      
 q.[EDate],      
 q.RYear,      
 q.ValueID,       
 q.ValueDesc,      
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
FROM ListDet05_a (@P_ANO, @Value1, @Value2, @Value3, @Value4, @Value5, @Value6, @Value7, @Value8, @Value9, @Value10,@Value11, @Value12, @Value13,@Value14,@Value15,@Value16,@Value17,@Value18,@Value19, @Value20, @Value21, @Value22, @Value23) as q, ainfo as a      
Where q.ANO = a.ANO      
)      

GO

DROP function ListDet05_a 
GO
Create function ListDet05_a (@P_ANO as integer,     
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
 Acceptance.AName,        
 Acceptance.ANO,        
 Acceptance.REGNO,        
 Acceptance.ADATE,        
 Acceptance.LUSERID as UserID,        
 SysTab.Currency,        
 QPCalc.TSI,        
 QPCalc.OurShare,        
 QPCalc.Gross,        
 Acceptance.ASTATUS,        
 Acceptance.ATYPE,        
 Acceptance.SDate,        
 Acceptance.EDate,        
 Year(Acceptance.SDate) AS RYear,        
 Acceptance.ValueID,        
 dbo.get_objectInfo(Acceptance.ANO) as ValueDesc        
From        
 Acceptance,        
 Cover,        
 SysTab,        
 QMasterAcceptance_PCalc() AS QPCalc,        
 Profile        
Where        
 cover.CNO = acceptance.CNO        
 And QPCalc.ANO=Acceptance.ANO        
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
 And (@Value15='%' or @Value15='' or 1 in (SELECT top 1 1 from Service Where ((Service.ANO=Acceptance.pANO and Service.ANO<>-1) or Service.ANO=Acceptance.ANO) and SStatus<>'R' and ServiceNo Like @Value15))        
 And (Acceptance.BatchNo Like @Value19 or (Acceptance.BatchNo is null and @Value19='%'))     
 And ((Acceptance.BackDatedF=1 and @Value20='1') or @Value20='')    
 And ((Cover.TBAF=1 and @Value22='1') or @Value22='')    
 And (@Value23<>'1' or (@Value23='1' and Exists (Select ANO from PPrintLog Where PPrintLog.ANO=Acceptance.ANO)))            
)        
  

go

DROP PROCEDURE [dbo].[ListDet_By_ANO]
GO
CREATE PROCEDURE [dbo].[ListDet_By_ANO] (@P_ANO as integer)     
AS    
SELECT Cast(0 as bit) as ProcessFlag,
Acceptance.CertificateNo, 
Acceptance.ESeqNo, 
Acceptance.AName, 
Acceptance.ANO, 
Acceptance.REGNO, 
Acceptance.ADATE, 
Acceptance.LUSERID as USERID, 
SysTab.Currency, 
QPCalc.TSI, 
QPCalc.OurShare, 
QPCalc.Gross, 
Acceptance.ASTATUS, 
Acceptance.ATYPE, 
Acceptance.SDate, 
Acceptance.EDate, 
Year(Coalesce(RArrHeader.RDate,Acceptance.SDate)) AS RYear,    
Acceptance.ValueID,    
dbo.get_objectInfo(Acceptance.ANO) as ValueDesc  
FROM 
 Acceptance left Join RArrHeader on (RArrHeader.ANO=Acceptance.ANO) Left Join QDetail_PCalc() QPCalc on (qPCalc.ANO=Acceptance.ANO and Acceptance.PStatus='C'),   
 Cover,     
 SysTab  
WHERE Cover.CNO=Acceptance.CNO And Acceptance.ANO=@P_ANO    


GO

DROP PROCEDURE [dbo].[ListDet_Next]
GO

CREATE PROCEDURE [dbo].[ListDet_Next] (@P_ANO as integer)     
AS    
SELECT Cast(0 as bit) as ProcessFlag,Acceptance.CertificateNo, Acceptance.ESeqNo, Acceptance.AName, Acceptance.ANO, Acceptance.REGNO, Acceptance.ADATE, Acceptance.LUSERID as USERID, SysTab.Currency, QPCalc.TSI, QPCalc.OurShare, QPCalc.Gross, QPCalc.RYear,  
 Acceptance.ASTATUS, Acceptance.ATYPE, Acceptance.SDate, Acceptance.EDate, QPCalc.ValueID, dbo.get_objectInfo(QPCalc.ANO) as ValueDesc    
FROM Acceptance, Cover, SysTab, qMasterAcceptance_PCalc() AS QPCalc    
WHERE Cover.CNO=Acceptance.CNO And QPCalc.ANO=Acceptance.ANO And Acceptance.LANO<>-1 and ((Acceptance.PANO<>-1 and Acceptance.PANO=@P_ANO) or (Acceptance.RANO<>-1 and Acceptance.RANO=@P_ANO))
    


GO

DROP PROCEDURE [dbo].[ListDet_Prev]
GO

CREATE PROCEDURE [dbo].[ListDet_Prev] (@P_ANO as integer)   
AS  
SELECT Cast(0 as bit) as ProcessFlag,Acceptance.CertificateNo, Acceptance.ESeqNo, Acceptance.AName, Acceptance.ANO, Acceptance.REGNO, Acceptance.ADATE,Acceptance.LUSERID as USERID, SysTab.Currency, QPCalc.TSI, QPCalc.OurShare, QPCalc.Gross, QPCalc.RYear, 
Acceptance.ASTATUS, Acceptance.ATYPE, Acceptance.SDate, Acceptance.EDate, QPCalc.ValueID, dbo.get_objectInfo(QPCalc.ANO) as ValueDesc
FROM Acceptance, Cover, SysTab, qMasterAcceptance_PCalc() AS QPCalc, Acceptance AS A1  
WHERE Cover.CNO=Acceptance.CNO And QPCalc.ANO=Acceptance.ANO And Acceptance.LANO<>-1 and (Acceptance.ANO=A1.PANO or Acceptance.ANO=A1.RANO) And A1.ANO=@P_ANO  
  
  


GO

DROP PROCEDURE [dbo].[MListDet_By_ANO]
GO

CREATE PROCEDURE [dbo].[MListDet_By_ANO] (@P_ANO as integer)     
AS     
SELECT Cast(0 as bit) as ProcessFlag, Cover.COVERNO, Acceptance.AName, Acceptance.CertificateNo, Cover.CNO, Cover.CStatus, Cover.VSeqNo, Acceptance.LANO, Acceptance.ANO, Acceptance.REGNO, Acceptance.ADATE, Acceptance.LUSERID as USERID,SysTab.Currency, Acceptance.ASTATUS, Acceptance.ATYPE, Acceptance.SDate, Acceptance.EDate, Acceptance.ValueID, dbo.get_objectInfo(Acceptance.ANO) as ValueDesc, Year(Coalesce(RArrHeader.RDate,Acceptance.SDate)) as RYear, QPCalc.TSI, QPCalc.OurShare, QPCalc.Gross        
FROM Acceptance left Join RArrHeader on (RArrHeader.ANO=Acceptance.ANO) Left Join QDetail_PCalc() QPCalc on (qPCalc.ANO=Acceptance.ANO and Acceptance.PStatus='C'), Cover, SysTab
WHERE Cover.CNO=Acceptance.CNO And Acceptance.ANO=@P_ANO         


GO

DROP PROCEDURE [dbo].[MListDet01]
GO

CREATE PROCEDURE [dbo].[MListDet01](@P_ANO as Integer)       
AS      
SELECT Cast(0 as bit) as ProcessFlag, Cover.COVERNO, Acceptance.AName, Acceptance.CertificateNo, Cover.CNO, Cover.CStatus, Cover.VSeqNo, Acceptance.LANO, Acceptance.ANO, Acceptance.REGNO, Acceptance.ADATE, Acceptance.LUSERID as USERID, SysTab.Currency, Acceptance.ASTATUS, Acceptance.ATYPE, Acceptance.SDate, Acceptance.EDate, Acceptance.ValueID, dbo.get_objectInfo(Acceptance.ANO) as ValueDesc, Year(Coalesce(RArrHeader.RDate,Acceptance.SDate)) as RYear, QPCalc.TSI, QPCalc.OurShare, QPCalc.Gross        
FROM Acceptance left Join RArrHeader on (RArrHeader.ANO=Acceptance.ANO) Left Join QDetail_PCalc() QPCalc on (qPCalc.ANO=Acceptance.ANO and Acceptance.PStatus='C'), Cover, SysTab
WHERE       
 Cover.CNO=Acceptance.CNO       
 And Acceptance.ANO<>Acceptance.LANO       
 And Acceptance.LANO=@P_ANO      
Order By Acceptance.CertificateNo  


GO

DROP PROCEDURE [dbo].[MLISTDET02]
GO

CREATE PROCEDURE [dbo].[MLISTDET02](@P_ANO as Integer)       
AS      
SELECT Cast(0 as bit) as ProcessFlag, Cover.COVERNO, Acceptance.AName, Acceptance.CertificateNo, Cover.CNO, Cover.CStatus, Cover.VSeqNo, Acceptance.LANO, Acceptance.ANO, Acceptance.REGNO, Acceptance.ADATE, Acceptance.LUSERID as USERID, SysTab.Currency, Acceptance.ASTATUS, Acceptance.ATYPE, Acceptance.SDate, Acceptance.EDate, Acceptance.ValueID, dbo.get_objectInfo(Acceptance.ANO) as ValueDesc, Year(Coalesce(RArrHeader.RDate,Acceptance.SDate)) as RYear, QPCalc.TSI, QPCalc.OurShare, QPCalc.Gross        
FROM Acceptance left Join RArrHeader on (RArrHeader.ANO=Acceptance.ANO) Left Join QDetail_PCalc() QPCalc on (qPCalc.ANO=Acceptance.ANO and Acceptance.PStatus='C'), Cover, SysTab
WHERE       
 Cover.CNO=Acceptance.CNO       
 And Acceptance.ANO<>Acceptance.LANO       
 And Acceptance.ANO=@P_ANO      
Order By Acceptance.CertificateNo     


GO

DROP PROCEDURE [dbo].[MLISTDET03]
GO

CREATE PROCEDURE [dbo].[MLISTDET03](@P_ANO as Integer, @P_SDATE AS SMALLDATETIME, @P_EDATE AS SMALLDATETIME)       
AS      
SELECT Cast(0 as bit) as ProcessFlag, Cover.COVERNO, Acceptance.AName, Acceptance.CertificateNo, Cover.CNO, Cover.CStatus, Cover.VSeqNo, Acceptance.LANO, Acceptance.ANO, Acceptance.REGNO, Acceptance.ADATE,Acceptance.LUSERID as USERID,SysTab.Currency, Acceptance.ASTATUS, Acceptance.ATYPE, Acceptance.SDate, Acceptance.EDate, Acceptance.ValueID, dbo.get_objectInfo(Acceptance.ANO) as ValueDesc,  Year(Coalesce(RArrHeader.RDate,Acceptance.SDate)) as RYear, QPCalc.TSI, QPCalc.OurShare, QPCalc.Gross        
FROM Acceptance left Join RArrHeader on (RArrHeader.ANO=Acceptance.ANO) Left Join QDetail_PCalc() QPCalc on (qPCalc.ANO=Acceptance.ANO and Acceptance.PStatus='C'), Cover, SysTab
WHERE       
 Cover.CNO=Acceptance.CNO       
 And Acceptance.ANO<>Acceptance.LANO       
 And Acceptance.LANO=@P_ANO       
 AND (ACCEPTANCE.SDATE BETWEEN @P_SDATE AND @P_EDATE)      
Order By Acceptance.CertificateNo           

GO


DROP PROCEDURE [dbo].[MListDet04]
GO

CREATE PROCEDURE [dbo].[MListDet04](@P_ANO as integer,@P_FCERTNO as varchar(20), @P_LCERTNO as varchar(20))          
AS          
SELECT Cast(0 as bit) as ProcessFlag, Cover.COVERNO, Acceptance.AName, Acceptance.CertificateNo, Cover.CNO, Cover.CStatus, Cover.VSeqNo, Acceptance.LANO, Acceptance.ANO, Acceptance.REGNO, Acceptance.ADATE, Acceptance.LUSERID as USERID,SysTab.Currency, Acceptance.ASTATUS, Acceptance.ATYPE, Acceptance.SDate, Acceptance.EDate, Acceptance.ValueID, dbo.get_objectInfo(Acceptance.ANO) as ValueDesc, Year(Coalesce(RArrHeader.RDate,Acceptance.SDate)) as RYear, QPCalc.TSI, QPCalc.OurShare, QPCalc.Gross        
FROM Acceptance left Join RArrHeader on (RArrHeader.ANO=Acceptance.ANO) Left Join QDetail_PCalc() QPCalc on (qPCalc.ANO=Acceptance.ANO and Acceptance.PStatus='C'), Cover, SysTab
WHERE         
 Cover.CNO=Acceptance.CNO         
 And Acceptance.ANO<>Acceptance.LANO         
 And Acceptance.LANO=@P_ANO         
 And Acceptance.CertificateNo Between @P_FCertNo and @P_LCertNo          
Order By Acceptance.CertificateNo              


GO


DROP FUNCTION [dbo].[List_By_Ano_Det]
GO

CREATE  FUNCTION [dbo].[List_By_Ano_Det] (@P_ANO AS INTEGER,@P_CANO AS INTEGER) 
RETURNS TABLE
AS RETURN(
SELECT Cast(0 as bit) as ProcessFlag,
	[Acceptance].[CertificateNo], 
	Acceptance.ESeqNo,
	[Acceptance].[AName], 
	[Acceptance].[ANO], 
	[Acceptance].[REGNO], 
	[Acceptance].[ADATE], 
	[Acceptance].[LUSERID] as UserID, 
	[SysTab].[Currency], 
	[QPCalc].[TSI], 
	[QPCalc].[OurShare], 
	[QPCalc].[Gross], 
	[Acceptance].[ASTATUS], 
	[Acceptance].[ATYPE], 
	[Acceptance].[SDate], 
	[Acceptance].[EDate], 
	Year([Acceptance].[SDate]) AS RYear,
 	Acceptance.ValueID,
 	dbo.get_objectInfo(Acceptance.ANO) as ValueDesc
FROM Acceptance, Cover, SysTab, QMasterAcceptance_PCalc() AS QPCalc
WHERE 
	[Cover].[CNO]=[Acceptance].[CNO] 
	And [QPCalc].[ANO]=[Acceptance].[ANO] 
	And [Acceptance].[ANO]<>[Acceptance].[LANO] 
	And [Acceptance].[LANO]=@P_ANO
	And [Acceptance].[ANO]=@P_CANO
)
 

GO


DROP FUNCTION [dbo].[List_Spc_01_Det]
GO

CREATE  FUNCTION [dbo].[List_Spc_01_Det] (@P_ANO AS INTEGER) 
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
	QPCalc.TSI, 
	QPCalc.OurShare, 
	QPCalc.Gross, 
	Acceptance.ASTATUS, 
	Acceptance.ATYPE, 
	Acceptance.SDate, 
	Acceptance.EDate, 
	Year(Acceptance.SDate) AS RYear,
	QPCalc.ValueID, dbo.get_objectInfo(QPCalc.ANO) as ValueDesc
FROM Acceptance, Cover, SysTab, QMasterAcceptance_PCalc() AS QPCalc, RArrHeader
WHERE 
	Cover.CNO=Acceptance.CNO 
	And QPCalc.ANO=Acceptance.ANO 
	And Acceptance.ANO<>Acceptance.LANO 
	And Acceptance.LANO=@P_ANO
	And RArrHeader.ANO=Acceptance.ANO
	And Acceptance.AStatus='I' and Acceptance.AType<>'C'
	And Cover.ISType not in ('C','L','I','T')
	And RArrHeader.TreatyF=1 and (RArrHeader.CAmount<>0 or RArrHeader.DAmount<>0 or RArrHeader.QAmount<>0 or RArrHeader.SP1Amount<>0 or RArrHeader.SP2Amount<>0 or RArrHeader.SP3Amount<>0 or RArrHeader.XPAmount<>0 or RArrHeader.AAmount<>0)
)











GO

DROP FUNCTION [dbo].[List_Spc_02_Det]
GO

CREATE  FUNCTION [dbo].[List_Spc_02_Det] (@P_ANO AS INTEGER) 
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
	QPCalc.TSI, 
	QPCalc.OurShare, 
	QPCalc.Gross, 
	Acceptance.ASTATUS, 
	Acceptance.ATYPE, 
	Acceptance.SDate, 
	Acceptance.EDate, 
	Year(Acceptance.SDate) AS RYear,
	QPCalc.ValueID, dbo.get_objectInfo(QPCalc.ANO) as ValueDesc
FROM Acceptance, Cover, SysTab, QMasterAcceptance_PCalc() AS QPCalc, RArrHeader
WHERE 
	Cover.CNO=Acceptance.CNO 
	And QPCalc.ANO=Acceptance.ANO 
	And Acceptance.ANO<>Acceptance.LANO 
	And Acceptance.LANO=@P_ANO
	And RArrHeader.ANO=Acceptance.ANO
	And Acceptance.AStatus='I' and Acceptance.AType<>'C'
	And Acceptance.ANO not in (SELECT ANO from Classified_Object() C Where C.ANO=Acceptance.ANO)
	And RArrHeader.TreatyF=1 and (RArrHeader.CAmount<>0 or RArrHeader.DAmount<>0 or RArrHeader.QAmount<>0 or RArrHeader.SP1Amount<>0 or RArrHeader.SP2Amount<>0 or RArrHeader.SP3Amount<>0 or RArrHeader.XPAmount<>0 or RArrHeader.AAmount<>0)
)

 


GO
DROP FUNCTION [dbo].[List_Spc_03_Det]
GO

CREATE  FUNCTION [dbo].[List_Spc_03_Det] (@P_ANO AS INTEGER)   
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
 QPCalc.TSI,   
 QPCalc.OurShare,   
 QPCalc.Gross,   
 Acceptance.ASTATUS,   
 Acceptance.ATYPE,   
 Acceptance.SDate,   
 Acceptance.EDate,   
 Year(Acceptance.SDate) AS RYear,  
 QPCalc.ValueID, dbo.get_objectInfo(QPCalc.ANO) as ValueDesc 
FROM Acceptance, Cover, SysTab, QMasterAcceptance_PCalc() AS QPCalc, RArrHeader  
WHERE   
 Cover.CNO=Acceptance.CNO   
 And QPCalc.ANO=Acceptance.ANO   
 And Acceptance.ANO<>Acceptance.LANO   
 And Acceptance.LANO=@P_ANO  
 And RArrHeader.ANO=Acceptance.ANO  
 And Acceptance.AStatus in ('I','W') and Acceptance.AType<>'C'  
 And Acceptance.TOC='0111'  
 And RArrHeader.FAmount=0  
)  
   

GO

DROP FUNCTION [dbo].[List01_Det]
GO

CREATE  FUNCTION [dbo].[List01_Det] (@P_ANO AS INTEGER, @P_UserID as varchar(255))   
RETURNS TABLE  
AS RETURN(  
SELECT Cast(0 as bit) as ProcessFlag,  
 [Acceptance].[CertificateNo],   
 Acceptance.ESeqNo,  
 [Acceptance].[AName],   
 [Acceptance].[ANO],   
 [Acceptance].[REGNO],   
 [Acceptance].[ADATE],   
 [Acceptance].[LUSERID] as UserID,   
 [SysTab].[Currency],   
 [QPCalc].[TSI],   
 [QPCalc].[OurShare],   
 [QPCalc].[Gross],   
 [Acceptance].[ASTATUS],   
 [Acceptance].[ATYPE],   
 [Acceptance].[SDate],   
 [Acceptance].[EDate],   
 Year([Acceptance].[SDate]) AS RYear,  
  Acceptance.ValueID,  
  dbo.get_objectInfo(Acceptance.ANO) as ValueDesc
FROM Acceptance, Cover, SysTab, QMasterAcceptance_PCalc() AS QPCalc  
WHERE   
 [Cover].[CNO]=[Acceptance].[CNO]   
 And [QPCalc].[ANO]=[Acceptance].[ANO]   
 And [Acceptance].[ANO]<>[Acceptance].[LANO]   
 And [Acceptance].[LANO]=@P_ANO  
 And [Acceptance].[AStatus]='W'   
 And [Cover].[ISType]<>'T'   
 And [Cover].[CStatus]='A'  
 And Acceptance.LuserID Like @P_UserID
)  
  

GO



/****** Object:  UserDefinedFunction [dbo].[ListDet04_Sub]    Script Date: 6/8/2017 5:41:34 PM ******/
DROP FUNCTION [dbo].[ListDet04_Sub]
GO
/****** Object:  UserDefinedFunction [dbo].[ListDet03_Sub]    Script Date: 6/8/2017 5:41:34 PM ******/
DROP FUNCTION [dbo].[ListDet03_Sub]
GO
/****** Object:  UserDefinedFunction [dbo].[ListDet02_Sub]    Script Date: 6/8/2017 5:41:34 PM ******/
DROP FUNCTION [dbo].[ListDet02_Sub]
GO
/****** Object:  UserDefinedFunction [dbo].[ListDet01_Sub]    Script Date: 6/8/2017 5:41:34 PM ******/
DROP FUNCTION [dbo].[ListDet01_Sub]
GO
/****** Object:  UserDefinedFunction [dbo].[List22_Det]    Script Date: 6/8/2017 5:41:34 PM ******/
DROP FUNCTION [dbo].[List22_Det]
GO
/****** Object:  UserDefinedFunction [dbo].[List21_Det]    Script Date: 6/8/2017 5:41:34 PM ******/
DROP FUNCTION [dbo].[List21_Det]
GO

/****** Object:  UserDefinedFunction [dbo].[List20_Det_Sub]    Script Date: 6/8/2017 5:41:34 PM ******/
DROP FUNCTION [dbo].[List20_Det_Sub]
GO
/****** Object:  UserDefinedFunction [dbo].[List20_Det]    Script Date: 6/8/2017 5:41:34 PM ******/
DROP FUNCTION [dbo].[List20_Det]
GO
/****** Object:  UserDefinedFunction [dbo].[List19_Det]    Script Date: 6/8/2017 5:41:34 PM ******/
DROP FUNCTION [dbo].[List19_Det]
GO
/****** Object:  UserDefinedFunction [dbo].[List18_Det]    Script Date: 6/8/2017 5:41:34 PM ******/
DROP FUNCTION [dbo].[List18_Det]
GO
/****** Object:  UserDefinedFunction [dbo].[List17_Det]    Script Date: 6/8/2017 5:41:34 PM ******/
DROP FUNCTION [dbo].[List17_Det]
GO
/****** Object:  UserDefinedFunction [dbo].[list16SR_Det]    Script Date: 6/8/2017 5:41:34 PM ******/
DROP FUNCTION [dbo].[list16SR_Det]
GO
/****** Object:  UserDefinedFunction [dbo].[list16SL_Det]    Script Date: 6/8/2017 5:41:34 PM ******/
DROP FUNCTION [dbo].[list16SL_Det]
GO
/****** Object:  UserDefinedFunction [dbo].[list16SE_Det]    Script Date: 6/8/2017 5:41:34 PM ******/
DROP FUNCTION [dbo].[list16SE_Det]
GO
/****** Object:  UserDefinedFunction [dbo].[list16SD_Det]    Script Date: 6/8/2017 5:41:34 PM ******/
DROP FUNCTION [dbo].[list16SD_Det]
GO
/****** Object:  UserDefinedFunction [dbo].[list16SC_Det]    Script Date: 6/8/2017 5:41:34 PM ******/
DROP FUNCTION [dbo].[list16SC_Det]
GO
/****** Object:  UserDefinedFunction [dbo].[List16_Det]    Script Date: 6/8/2017 5:41:34 PM ******/
DROP FUNCTION [dbo].[List16_Det]
GO
/****** Object:  UserDefinedFunction [dbo].[List15_Det]    Script Date: 6/8/2017 5:41:34 PM ******/
DROP FUNCTION [dbo].[List15_Det]
GO
/****** Object:  UserDefinedFunction [dbo].[List15_Blank_Det]    Script Date: 6/8/2017 5:41:34 PM ******/
DROP FUNCTION [dbo].[List15_Blank_Det]
GO
/****** Object:  UserDefinedFunction [dbo].[List14_Det]    Script Date: 6/8/2017 5:41:34 PM ******/
DROP FUNCTION [dbo].[List14_Det]
GO
/****** Object:  UserDefinedFunction [dbo].[List13_Det]    Script Date: 6/8/2017 5:41:34 PM ******/
DROP FUNCTION [dbo].[List13_Det]
GO
/****** Object:  UserDefinedFunction [dbo].[List12_Det]    Script Date: 6/8/2017 5:41:34 PM ******/
DROP FUNCTION [dbo].[List12_Det]
GO
/****** Object:  UserDefinedFunction [dbo].[List11G_Det]    Script Date: 6/8/2017 5:41:34 PM ******/
DROP FUNCTION [dbo].[List11G_Det]
GO
/****** Object:  UserDefinedFunction [dbo].[List11F_Det]    Script Date: 6/8/2017 5:41:34 PM ******/
DROP FUNCTION [dbo].[List11F_Det]
GO
/****** Object:  UserDefinedFunction [dbo].[List11E_Det]    Script Date: 6/8/2017 5:41:34 PM ******/
DROP FUNCTION [dbo].[List11E_Det]
GO
/****** Object:  UserDefinedFunction [dbo].[List11D_Det]    Script Date: 6/8/2017 5:41:34 PM ******/
DROP FUNCTION [dbo].[List11D_Det]
GO
/****** Object:  UserDefinedFunction [dbo].[List11C_Det]    Script Date: 6/8/2017 5:41:34 PM ******/
DROP FUNCTION [dbo].[List11C_Det]
GO
/****** Object:  UserDefinedFunction [dbo].[List11B_Det]    Script Date: 6/8/2017 5:41:34 PM ******/
DROP FUNCTION [dbo].[List11B_Det]
GO
/****** Object:  UserDefinedFunction [dbo].[List11A_Det]    Script Date: 6/8/2017 5:41:34 PM ******/
DROP FUNCTION [dbo].[List11A_Det]
GO
/****** Object:  UserDefinedFunction [dbo].[List11_Det]    Script Date: 6/8/2017 5:41:34 PM ******/
DROP FUNCTION [dbo].[List11_Det]
GO

/****** Object:  UserDefinedFunction [dbo].[List09_Det]    Script Date: 6/8/2017 5:41:34 PM ******/
DROP FUNCTION [dbo].[List09_Det]
GO
/****** Object:  UserDefinedFunction [dbo].[List08_Det]    Script Date: 6/8/2017 5:41:34 PM ******/
DROP FUNCTION [dbo].[List08_Det]
GO
/****** Object:  UserDefinedFunction [dbo].[List07_Det]    Script Date: 6/8/2017 5:41:34 PM ******/
DROP FUNCTION [dbo].[List07_Det]
GO
/****** Object:  UserDefinedFunction [dbo].[List06_Det]    Script Date: 6/8/2017 5:41:34 PM ******/
DROP FUNCTION [dbo].[List06_Det]
GO
/****** Object:  UserDefinedFunction [dbo].[List05_Det]    Script Date: 6/8/2017 5:41:34 PM ******/
DROP FUNCTION [dbo].[List05_Det]
GO
/****** Object:  UserDefinedFunction [dbo].[List04_Det]    Script Date: 6/8/2017 5:41:34 PM ******/
DROP FUNCTION [dbo].[List04_Det]
GO
/****** Object:  UserDefinedFunction [dbo].[List03_Det]    Script Date: 6/8/2017 5:41:34 PM ******/
DROP FUNCTION [dbo].[List03_Det]
GO
/****** Object:  UserDefinedFunction [dbo].[List02A_Det]    Script Date: 6/8/2017 5:41:34 PM ******/
DROP FUNCTION [dbo].[List02A_Det]
GO
/****** Object:  UserDefinedFunction [dbo].[List02_Det]    Script Date: 6/8/2017 5:41:34 PM ******/
DROP FUNCTION [dbo].[List02_Det]
GO
/****** Object:  UserDefinedFunction [dbo].[ListDet05_b]    Script Date: 6/8/2017 5:41:34 PM ******/
DROP FUNCTION [dbo].[ListDet05_b]
GO
/****** Object:  UserDefinedFunction [dbo].[ListDet05_a]    Script Date: 6/8/2017 5:41:34 PM ******/
DROP FUNCTION [dbo].[ListDet05_a]
GO
/****** Object:  UserDefinedFunction [dbo].[ListDet05_a]    Script Date: 6/8/2017 5:41:34 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
Create function [dbo].[ListDet05_a] (@P_ANO as integer,     
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
 Acceptance.AName,        
 Acceptance.ANO,        
 Acceptance.REGNO,        
 Acceptance.ADATE,        
 Acceptance.LUSERID as UserID,        
 SysTab.Currency,        
 QPCalc.TSI,        
 QPCalc.OurShare,        
 QPCalc.Gross,        
 Acceptance.ASTATUS,        
 Acceptance.ATYPE,        
 Acceptance.SDate,        
 Acceptance.EDate,        
 Year(Acceptance.SDate) AS RYear,        
 Acceptance.ValueID,        
 dbo.get_objectInfo(Acceptance.ANO) as ValueDesc        
From        
 Acceptance,        
 Cover,        
 SysTab,        
 QMasterAcceptance_PCalc() AS QPCalc,        
 Profile        
Where        
 cover.CNO = acceptance.CNO        
 And QPCalc.ANO=Acceptance.ANO        
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
 And (@Value15='%' or @Value15='' or 1 in (SELECT top 1 1 from Service Where ((Service.ANO=Acceptance.pANO and Service.ANO<>-1) or Service.ANO=Acceptance.ANO) and SStatus<>'R' and ServiceNo Like @Value15))        
 And (Acceptance.BatchNo Like @Value19 or (Acceptance.BatchNo is null and @Value19='%'))     
 And ((Acceptance.BackDatedF=1 and @Value20='1') or @Value20='')    
 And ((Cover.TBAF=1 and @Value22='1') or @Value22='')    
 And (@Value23<>'1' or (@Value23='1' and Exists (Select ANO from PPrintLog Where PPrintLog.ANO=Acceptance.ANO)))            
)        
  

GO
/****** Object:  UserDefinedFunction [dbo].[ListDet05_b]    Script Date: 6/8/2017 5:41:34 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
Create function [dbo].[ListDet05_b] (@P_ANO as integer,     
@Value1 as varchar(255), @Value2 as varchar(255), @Value3 as varchar(255), @Value4 as varchar(255), @Value5 as varchar(255),     
@Value6 varchar(255), @Value7 as varchar(255), @Value8 as varchar(255), @Value9 as varchar(255), @Value10 as varchar(255),    
@Value11 as varchar(255),@Value12 as varchar(255), @Value13 as varchar(255),@Value14 as varchar(255),@Value15 as varchar(255),    
@Value16 as varchar(255),@Value17 as varchar(255),@Value18 as varchar(255),@Value19 as varchar(255),@Value20 as varchar(255),@Value21 as varchar(255), @Value22 as varchar(255), @Value23 as varchar(255)    
)          
RETURNS Table      
AS RETURN      
(      
SELECT Cast(0 as bit) as ProcessFlag,      
 q.[CertificateNo],      
 q.ESeqNo,      
 q.[AName],      
 q.[ANO],      
 q.[REGNO],      
 q.[ADATE],      
 q.[USERID],      
 q.[Currency],      
 q.[TSI],      
 q.[OurShare],      
 q.[Gross],      
 q.[ASTATUS],      
 q.[ATYPE],      
 q.[SDate],      
 q.[EDate],      
 q.RYear,      
 q.ValueID,       
 q.ValueDesc,      
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
FROM ListDet05_a (@P_ANO, @Value1, @Value2, @Value3, @Value4, @Value5, @Value6, @Value7, @Value8, @Value9, @Value10,@Value11, @Value12, @Value13,@Value14,@Value15,@Value16,@Value17,@Value18,@Value19, @Value20, @Value21, @Value22, @Value23) as q, ainfo as a      
Where q.ANO = a.ANO      
)      


GO
/****** Object:  UserDefinedFunction [dbo].[List02_Det]    Script Date: 6/8/2017 5:41:34 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE   FUNCTION [dbo].[List02_Det] (@P_ANO as integer,@P_UserID as varchar(255), @pEDate as smalldatetime)   
RETURNS TABLE  
AS RETURN(  
SELECT Cast(0 as bit) as ProcessFlag,  
 [Acceptance].[CertificateNo],   
 Acceptance.ESeqNo,  
 [Acceptance].[AName],   
 [Acceptance].[ANO],   
 [Acceptance].[REGNO],   
 [Acceptance].[ADATE],   
 [Acceptance].[LUSERID] as UserID,   
 [SysTab].[Currency],   
 [QPCalc].[TSI],   
 [QPCalc].[OurShare],   
 [QPCalc].[Gross],   
 [Acceptance].[ASTATUS],   
 [Acceptance].[ATYPE],   
 [Acceptance].[SDate],   
 [Acceptance].[EDate],   
 Year([Acceptance].[SDate]) AS RYear,  
  Acceptance.ValueID,  
  dbo.get_objectInfo(Acceptance.ANO) as ValueDesc  
FROM   
 Acceptance,   
 Cover,   
 SysTab,   
 QMasterAcceptance_PCalc() AS QPCalc  
WHERE   
 [Cover].[CNO]=[Acceptance].[CNO]   
 And [QPCalc].[ANO]=[Acceptance].[ANO]   
 And [Acceptance].[ANO]<>[Acceptance].[LANO]   
 And [Acceptance].[LANO]=@P_ANO  
 And [Acceptance].[AStatus]='W'   
 And [Cover].[ISType]<>'T'   
 And [Cover].[CStatus]='A'   
 And [Cover].[CDate]+[Cover].[Validation]<=@pEDate  
 And Acceptance.LUserID like @P_UserID
)  


GO
/****** Object:  UserDefinedFunction [dbo].[List02A_Det]    Script Date: 6/8/2017 5:41:34 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE   FUNCTION [dbo].[List02A_Det] (@P_ANO as integer,@P_UserID as varchar(255), @pEDate as smalldatetime)   
RETURNS TABLE  
AS RETURN(  
SELECT Cast(0 as bit) as ProcessFlag,  
 [Acceptance].[CertificateNo],   
 Acceptance.ESeqNo,  
 [Acceptance].[AName],   
 [Acceptance].[ANO],   
 [Acceptance].[REGNO],   
 [Acceptance].[ADATE],   
 [Acceptance].[LUSERID] as UserID,   
 [SysTab].[Currency],   
 [QPCalc].[TSI],   
 [QPCalc].[OurShare],   
 [QPCalc].[Gross],   
 [Acceptance].[ASTATUS],   
 [Acceptance].[ATYPE],   
 [Acceptance].[SDate],   
 [Acceptance].[EDate],   
 Year([Acceptance].[SDate]) AS RYear,  
  Acceptance.ValueID,  
  dbo.get_objectInfo(Acceptance.ANO) as ValueDesc  
FROM   
 Acceptance,   
 Cover,   
 SysTab,   
 QMasterAcceptance_PCalc() AS QPCalc,  
 RArrHeader  
WHERE   
 [Cover].[CNO]=[Acceptance].[CNO]   
 And [QPCalc].[ANO]=[Acceptance].[ANO]   
 And [Acceptance].[ANO]<>[Acceptance].[LANO]   
 And [Acceptance].[LANO]=@P_ANO  
 And [Acceptance].[AStatus]='W'   
 And [Cover].[ISType]<>'T'   
 And [Cover].[CStatus]='A'   
 And [Cover].[CDate]+[Cover].[Validation]<=@pEDate  
 And RArrHeader.ANO=Acceptance.ANO and RArrHeader.FShare<>0  
 And Acceptance.LUserID Like @P_UserID
)  
  

GO
/****** Object:  UserDefinedFunction [dbo].[List03_Det]    Script Date: 6/8/2017 5:41:34 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[List03_Det] (@P_ANO as integer, @P_USERID as varchar(255))     
RETURNS TABLE    
AS RETURN(    
    
SELECT Cast(0 as bit) as ProcessFlag,    
 [Acceptance].[CertificateNo],     
 Acceptance.ESeqNo,    
 [Acceptance].[AName],     
 [Acceptance].[ANO],     
 [Acceptance].[REGNO],     
 [Acceptance].[ADATE],     
 [Acceptance].[LUSERID] as UserID,     
 [SysTab].[Currency],     
 [QPCalc].[TSI],     
 [QPCalc].[OurShare],     
 [QPCalc].[Gross],     
 [Acceptance].[ASTATUS],     
 [Acceptance].[ATYPE],     
 [Acceptance].[SDate],     
 [Acceptance].[EDate],     
 Year(Coalesce(RArrHeader.RDate,Acceptance.SDate)) AS RYear,    
  Acceptance.ValueID,    
  dbo.get_objectInfo(Acceptance.ANO) as ValueDesc    
FROM     
 Acceptance left Join RArrHeader on (RArrHeader.ANO=Acceptance.ANO)
 Left Join QDetail_PCalc() QPCalc on (qPCalc.ANO=Acceptance.ANO and Acceptance.PStatus='C'),   
 Cover,     
 SysTab  
WHERE     
 [Cover].[CNO]=[Acceptance].[CNO]     
 And [Acceptance].[ANO]<>[Acceptance].[LANO]     
 And [Acceptance].[LANO]=@P_ANO    
 And [Acceptance].AStatus Not in ('W','T')  
 And [Cover].[ISType]<>'T'     
 And [Acceptance].[LUserID] Like @P_UserID    
    
)    


GO
/****** Object:  UserDefinedFunction [dbo].[List04_Det]    Script Date: 6/8/2017 5:41:34 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE   FUNCTION [dbo].[List04_Det] (@P_ANO as integer,@P_UserID as varchar(255))  
RETURNS TABLE  
AS RETURN(  
  
SELECT Cast(0 as bit) as ProcessFlag,  
 [Acceptance].[CertificateNo],   
 Acceptance.ESeqNo,  
 [Acceptance].[AName],   
 [Acceptance].[ANO],   
 [Acceptance].[REGNO],   
 [Acceptance].[ADATE],   
 [Acceptance].[LUSERID] as UserID,   
 [SysTab].[Currency],   
 [QPCalc].[TSI],   
 [QPCalc].[OurShare],   
 [QPCalc].[Gross],   
 [Acceptance].[ASTATUS],   
 [Acceptance].[ATYPE],   
 [Acceptance].[SDate],   
 [Acceptance].[EDate],   
 Year([Acceptance].[SDate]) AS RYear,  
  Acceptance.ValueID,  
  dbo.get_objectInfo(Acceptance.ANO) as ValueDesc  
FROM   
 Acceptance,   
 Cover,   
 SysTab,   
 QMasterAcceptance_PCalc() AS QPCalc  
WHERE   
 [Cover].[CNO]=[Acceptance].[CNO]   
 And [QPCalc].[ANO]=[Acceptance].[ANO]   
 And [Acceptance].[ANO]<>[Acceptance].[LANO]   
 And [Acceptance].[LANO]=@P_ANO  
 And [Acceptance].[AStatus]='W'   
 And [Cover].[ISType]<>'T'   
 And [Cover].[CoverNoteF]=1  
 And Acceptance.LUserID Like @P_UserID
)  


GO
/****** Object:  UserDefinedFunction [dbo].[List05_Det]    Script Date: 6/8/2017 5:41:34 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[List05_Det] (@P_ANO as integer, @P_UserID as varchar(50), @pSDate as smallDateTime, @pEDate as smallDateTime, @pBranch as varchar(10), @pTOC as varchar(10), @pMO as varchar(10))      
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
 QPCalc.TSI,      
 QPCalc.OurShare,      
 QPCalc.Gross,      
 Acceptance.ASTATUS,      
 Acceptance.ATYPE,      
 Acceptance.SDate,      
 Acceptance.EDate,      
 Year(Acceptance.SDate) AS RYear,      
 QPCalc.ValueID,      
dbo.get_objectInfo(QPCalc.ANO) as ValueDesc    
From      
 Acceptance,      
 Cover,      
 SysTab,      
 QMasterAcceptance_PCalc() AS QPCalc,      
 RARRHEADER      
Where      
 cover.CNO = acceptance.CNO      
 And Rarrheader.ANO = Acceptance.ANO      
 And QPCalc.ANO=Acceptance.ANO      
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
/****** Object:  UserDefinedFunction [dbo].[List06_Det]    Script Date: 6/8/2017 5:41:34 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[List06_Det] (@P_ANO as integer, @P_UserID as varchar(50), @pSDate as smalldatetime, @pEDate as smallDateTime, @pBranch as varchar(10), @pTOC as varchar(10), @pMO as varchar(10))      
RETURNS TABLE      
AS RETURN(      
      
SELECT Cast(0 as bit) as ProcessFlag,      
 [Acceptance].[CertificateNo],       
 Acceptance.ESeqNo,      
 [Acceptance].[AName],       
 [Acceptance].[ANO],       
 [Acceptance].[REGNO],       
 [Acceptance].[ADATE],       
 [Acceptance].[LUSERID] as UserID,       
 [SysTab].[Currency],       
 [QPCalc].[TSI],       
 [QPCalc].[OurShare],       
 [QPCalc].[Gross],       
 [Acceptance].[ASTATUS],       
 [Acceptance].[ATYPE],       
 [Acceptance].[SDate],       
 [Acceptance].[EDate],       
 Year([Acceptance].[SDate]) AS RYear,      
  Acceptance.ValueID,      
dbo.get_objectInfo(Acceptance.ANO) as ValueDesc    
FROM       
 Acceptance,       
 Cover,       
 SysTab,       
 QMasterAcceptance_PCalc() AS QPCalc      
WHERE       
 [Cover].[CNO]=[Acceptance].[CNO]       
 And [QPCalc].[ANO]=[Acceptance].[ANO]       
 And [Acceptance].[ANO]<>[Acceptance].[LANO]       
 And [Acceptance].[LANO]=@P_ANO      
 And [Acceptance].[AStatus]='I'       
 And [Acceptance].[AType]<>'C'       
 And [Cover].[ISType]<>'T'       
 And Acceptance.Branch like @pBranch+'%'    
 And Acceptance.TOC Like @pTOC+'%'      
 And Cover.MO like @pMO+'%'    
 And [Acceptance].[EDate] between @pSDate and @pEDate       
 And Exists (Select S1.ID from SysUser S1 Left Join SysUserBranch S2 on (S2.ID=S1.ID and S2.AllowedF=1 and S2.Branch=Acceptance.Branch) Where S1.ID=@P_UserID and (coalesce(S2.Branch,'')<>'' or S1.Type='SUPERVISOR'))       
)      


GO
/****** Object:  UserDefinedFunction [dbo].[List07_Det]    Script Date: 6/8/2017 5:41:34 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
  CREATE FUNCTION [dbo].[List07_Det] (@P_ANO as integer, @PSDate as SmallDateTime, @pEDAte as smallDateTime,@P_COB as varchar(10))  
RETURNS Table  
AS RETURN(  
    
SELECT Cast(0 as bit) as ProcessFlag,  
 [Acceptance].[CertificateNo],  
 Acceptance.ESeqNo,  
 [Acceptance].[AName],  
 [Acceptance].[ANO],  
 [Acceptance].[REGNO],  
 [Acceptance].[ADATE],  
 [Acceptance].[LUSERID] as UserID,  
 [SysTab].[Currency],  
 [QPCalc].[TSI],  
 [QPCalc].[OurShare],  
 [QPCalc].[Gross],  
 [Acceptance].[ASTATUS],  
 [Acceptance].[ATYPE],  
 [Acceptance].[SDate],  
 [Acceptance].[EDate],  
 Year([acceptance].[SDate]) As RYear,  
 Acceptance.ValueID,  
dbo.get_objectInfo(Acceptance.ANO) as ValueDesc
From  
 Acceptance,  
 Cover,  
 SysTab,  
 QMasterAcceptance_PCalc() AS QPCalc,  
 TOC  
Where  
 [cover].[CNO] = [acceptance].[CNO]  
 And [QPCalc].[ANO]=[Acceptance].[ANO]  
 And [Acceptance].[ANO]<>[Acceptance].[LANO]  
 And [Acceptance].[LANO]=@P_ANO  
 And (([Acceptance].[AType]='C' and Acceptance.AStatus='I' and [Acceptance].[PPDate] between @PSdate and @pEDate)  
 or (Acceptance.AType<>'C' and Acceptance.AStatus='C' And [Acceptance].[CloseDate] between @PSdate and @pEDate)  
 or ([Acceptance].[AType]<>'C' and Acceptance.AStatus='I' and [Acceptance].[EDate] between @PSdate and @pEDate))  
 And [Cover].[ISType]<>'T'  
 And Acceptance.AdjustableF=1  
 And TOC.TOC=Acceptance.TOC  
 And TOC.COB=@P_COB  
)  


GO
/****** Object:  UserDefinedFunction [dbo].[List08_Det]    Script Date: 6/8/2017 5:41:34 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO

 
CREATE  FUNCTION [dbo].[List08_Det] (@P_ANO as integer, @pSDate as smallDatetime, @pEDate as smalldatetime)
RETURNS TABLE
AS RETURN(

SELECT Cast(0 as bit) as ProcessFlag,
	[Acceptance].[CertificateNo], 
	Acceptance.ESeqNo,
	[Acceptance].[AName], 
	[Acceptance].[ANO], 
	[Acceptance].[REGNO], 
	[Acceptance].[ADATE], 
	[Acceptance].[LUSERID] as UserID, 
	[SysTab].[Currency], 
	[QPCalc].[TSI], 
	[QPCalc].[OurShare], 
	[QPCalc].[Gross], 
	[Acceptance].[ASTATUS], 
	[Acceptance].[ATYPE], 
	[Acceptance].[SDate], 
	[Acceptance].[EDate], 
	Year([Acceptance].[SDate]) AS RYear,
 	Acceptance.ValueID,
dbo.get_objectInfo(Acceptance.ANO) as ValueDesc
FROM 
	Acceptance, 
	Cover, 
	SysTab, 
	QMasterAcceptance_PCalc() AS QPCalc
WHERE 
	[Cover].[CNO]=[Acceptance].[CNO] 
	And [QPCalc].[ANO]=[Acceptance].[ANO] 
	And [Acceptance].[ANO]<>[Acceptance].[LANO] 
	And [Acceptance].[LANO]=@P_ANO
	And [Acceptance].[AType]='A' 
	And [Cover].[ISType]<>'T' 
	And [Acceptance].[ADate]>=@pSDate 
	And [Acceptance].[ADate]<=@pEDate
)

 


GO
/****** Object:  UserDefinedFunction [dbo].[List09_Det]    Script Date: 6/8/2017 5:41:34 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO









CREATE  FUNCTION [dbo].[List09_Det] (@P_ANO as integer, @pSDate as smalldatetime, @pEDate as smalldatetime)
RETURNS TABLE
AS RETURN(

SELECT Cast(0 as bit) as ProcessFlag,
	[Acceptance].[CertificateNo], 
	Acceptance.ESeqNo,
	[Acceptance].[AName], 
	[Acceptance].[ANO], 
	[Acceptance].[REGNO], 
	[Acceptance].[ADATE], 
	[Acceptance].[LUSERID] as UserID, 
	[SysTab].[Currency], 
	[QPCalc].[TSI], 
	[QPCalc].[OurShare], 
	[QPCalc].[Gross], 
	[Acceptance].[ASTATUS], 
	[Acceptance].[ATYPE], 
	[Acceptance].[SDate], 
	[Acceptance].[EDate], 
	Year([Acceptance].[SDate]) AS RYear,
 	Acceptance.ValueID,
dbo.get_objectInfo(Acceptance.ANO) as ValueDesc
FROM 
	Acceptance, 
	Cover, 
	SysTab, 
	QMasterAcceptance_PCalc() AS QPCalc
WHERE 
	[Cover].[CNO]=[Acceptance].[CNO] 
	And [QPCalc].[ANO]=[Acceptance].[ANO] 
	And [Acceptance].[ANO]<>[Acceptance].[LANO] 
	And [Acceptance].[LANO]=@P_ANO 
	And [Acceptance].[AType]='C' 
	And [Cover].[ISType]<>'T' 
	And [Acceptance].[ADate]>=@pSDate 
	And [Acceptance].[ADate]<=@pEDate
)
 


GO

/****** Object:  UserDefinedFunction [dbo].[List11_Det]    Script Date: 6/8/2017 5:41:34 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO


CREATE FUNCTION [dbo].[List11_Det] (@P_ANO as integer,@P_SDate as smalldatetime, @P_EDate as smalldatetime)
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
 QPCalc.TSI,
 QPCalc.OurShare,
 QPCalc.Gross,
 Acceptance.ASTATUS,
 Acceptance.ATYPE,
 Acceptance.SDate,
 Acceptance.EDate,
 Year(Acceptance.SDate) AS RYear,
 Acceptance.ValueID,
 dbo.get_objectInfo(Acceptance.ANO) as ValueDesc
From
 Acceptance,
 Cover,
 SysTab,
 QMasterAcceptance_PCalc() AS QPCalc,
 RARRHEADER
Where
 cover.CNO = acceptance.CNO
 And Rarrheader.ANO = Acceptance.ANO
 And QPCalc.ANO=Acceptance.ANO
 And Acceptance.ANO<>Acceptance.LANO
 And Acceptance.LANO=@P_ANO
 And Cover.CStatus<>'C'
 And (Acceptance.AType Not in ('C','A') and Acceptance.AStatus='I' And RArrHeader.Status='R')
 And Cover.ISType<>'T'
 And Acceptance.ADate Between @P_SDate and @P_EDate
)
        
       

GO
/****** Object:  UserDefinedFunction [dbo].[List11A_Det]    Script Date: 6/8/2017 5:41:34 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[List11A_Det] (@P_ANO as integer, @P_UserID as varchar(255), @P_TOC as varchar(10), @P_Branch as varchar(10), @P_AStatus as varchar(1))   
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
QPCalc.TSI,   
QPCalc.OurShare,   
QPCalc.Gross,   
Acceptance.ASTATUS,   
Acceptance.ATYPE,   
Acceptance.SDate,   
Acceptance.EDate,   
Year(Acceptance.SDate) AS RYear,   
QPCalc.ValueID,   
dbo.get_objectInfo(QPCalc.ANO) as ValueDesc
From   
Acceptance,   
Cover,   
SysTab,   
QMasterAcceptance_PCalc() AS QPCalc,   
RARRHEADER,   
SysUser   
Where   
cover.CNO = acceptance.CNO   
And Rarrheader.ANO = Acceptance.ANO   
And QPCalc.ANO=Acceptance.ANO   
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
/****** Object:  UserDefinedFunction [dbo].[List11B_Det]    Script Date: 6/8/2017 5:41:34 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE FUNCTION [dbo].[List11B_Det] (@P_ANO as integer)
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
 QPCalc.TSI,
 QPCalc.OurShare,
 QPCalc.Gross,
 Acceptance.ASTATUS,
 Acceptance.ATYPE,
 Acceptance.SDate,
 Acceptance.EDate,
 Year(Acceptance.SDate) AS RYear,
 QPCalc.ValueID,
dbo.get_objectInfo(QPCalc.ANO) as ValueDesc
From
 Acceptance,
 Cover,
 SysTab,
 QMasterAcceptance_PCalc() AS QPCalc,
 RARRHEADER
Where
 cover.CNO = acceptance.CNO
 And Rarrheader.ANO = Acceptance.ANO
 And QPCalc.ANO=Acceptance.ANO
 And Acceptance.ANO<>Acceptance.LANO
 And Acceptance.LANO=@P_ANO
 And Cover.CStatus<>'C'
 And Acceptance.AStatus='W'
 And Cover.ISType<>'T'
 And RArrheader.ANO in (SELECT ANO from RArrDet Where Status<>'O')
)
  
  



GO
/****** Object:  UserDefinedFunction [dbo].[List11C_Det]    Script Date: 6/8/2017 5:41:34 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO







CREATE FUNCTION [dbo].[List11C_Det] (@P_ANO as integer) 
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
	QPCalc.TSI, 
	QPCalc.OurShare, 
	QPCalc.Gross, 
	Acceptance.ASTATUS, 
	Acceptance.ATYPE, 
	Acceptance.SDate, 
	Acceptance.EDate, 
	Year(Acceptance.SDate) AS RYear,
	QPCalc.ValueID,
dbo.get_objectInfo(QPCalc.ANO) as ValueDesc
FROM 
	Acceptance, 
	Cover, 
	SysTab, 
	QMasterAcceptance_PCalc() AS QPCalc,
	Rarrheader
WHERE 
	Cover.CNO=Acceptance.CNO 
	And Rarrheader.ANO = Acceptance.ANO
	And QPCalc.ANO=Acceptance.ANO 
	And Acceptance.ANO<>Acceptance.LANO 
	And Acceptance.LANO=@P_ANO 
	And Cover.CStatus<>'C'
        And Acceptance.AStatus='W'   
        And Acceptance.EMethod='T'  
)


 

GO
/****** Object:  UserDefinedFunction [dbo].[List11D_Det]    Script Date: 6/8/2017 5:41:34 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO







CREATE FUNCTION [dbo].[List11D_Det] (@P_ANO as integer,@P_SDate as smalldatetime, @P_EDate as smalldatetime) 
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
	QPCalc.TSI, 
	QPCalc.OurShare, 
	QPCalc.Gross, 
	Acceptance.ASTATUS, 
	Acceptance.ATYPE, 
	Acceptance.SDate, 
	Acceptance.EDate, 
	Year(Acceptance.SDate) AS RYear,
 	Acceptance.ValueID,
dbo.get_objectInfo(Acceptance.ANO) as ValueDesc
FROM 
	Acceptance, 
	Cover, 
	SysTab, 
	QMasterAcceptance_PCalc() AS QPCalc,
	Rarrheader
WHERE 
	Cover.CNO=Acceptance.CNO 
	And Rarrheader.ANO = Acceptance.ANO
	And QPCalc.ANO=Acceptance.ANO 
	And Acceptance.ANO<>Acceptance.LANO 
	And Acceptance.LANO=@P_ANO 
        And Acceptance.ADate Between @P_SDate and @P_EDate
        And RArrHeader.Status<>'R'   
        And RArrHeader.SAmount<>0
        And Cover.ISType<>'T'
)

 

GO
/****** Object:  UserDefinedFunction [dbo].[List11E_Det]    Script Date: 6/8/2017 5:41:34 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO


CREATE FUNCTION [dbo].[List11E_Det] (@P_ANO as integer,@P_SDate as smalldatetime, @P_EDate as smalldatetime,@P_REGID as varchar(10))
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
 QPCalc.TSI,
 QPCalc.OurShare,
 QPCalc.Gross,
 Acceptance.ASTATUS,
 Acceptance.ATYPE,
 Acceptance.SDate,
 Acceptance.EDate,
 Year(Acceptance.SDate) AS RYear,
 Acceptance.ValueID,
dbo.get_objectInfo(Acceptance.ANO) as ValueDesc
From
 Acceptance,
 Cover,
 SysTab,
 QMasterAcceptance_PCalc() AS QPCalc,
 Rarrheader,
 AccRegDet
Where
 cover.CNO = acceptance.CNO
 and Acceptance.REGID=@P_REGID
 And Rarrheader.ANO = Acceptance.ANO
 And QPCalc.ANO=Acceptance.ANO
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
/****** Object:  UserDefinedFunction [dbo].[List11F_Det]    Script Date: 6/8/2017 5:41:34 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[List11F_Det] (@P_ANO as integer,@P_UserID as varchar(10), @P_TOC as varchar(10), @P_Branch as varchar(10), @P_PDate as smalldatetime, @P_ManualF as bit)      
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
 QPCalc.TSI,      
 QPCalc.OurShare,      
 QPCalc.Gross,      
 Acceptance.ASTATUS,      
 Acceptance.ATYPE,      
 Acceptance.SDate,      
 Acceptance.EDate,      
 Year(Acceptance.SDate) AS RYear,      
 Acceptance.ValueID,      
dbo.get_objectInfo(Acceptance.ANO) as ValueDesc
From      
 Acceptance,      
 Cover,      
 SysTab,      
 QMasterAcceptance_PCalc() AS QPCalc,      
 RARRHEADER,   
 SysUserTOC,   
 SysUserBranch  
Where      
 cover.CNO = acceptance.CNO      
 And Rarrheader.ANO = Acceptance.ANO      
 And QPCalc.ANO=Acceptance.ANO      
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
/****** Object:  UserDefinedFunction [dbo].[List11G_Det]    Script Date: 6/8/2017 5:41:34 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



CREATE FUNCTION [dbo].[List11G_Det] (@P_ANO as integer,@P_SDate as smalldatetime, @P_EDate as smalldatetime)
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
 QPCalc.TSI,
 QPCalc.OurShare,
 QPCalc.Gross,
 Acceptance.ASTATUS,
 Acceptance.ATYPE,
 Acceptance.SDate,
 Acceptance.EDate,
 Year(Acceptance.SDate) AS RYear,
 Acceptance.ValueID,
dbo.get_objectInfo(Acceptance.ANO) as ValueDesc
From
 Acceptance,
 Cover,
 SysTab,
 QMasterAcceptance_PCalc() AS QPCalc,
 RARRHEADER
Where
 cover.CNO = acceptance.CNO
 And Rarrheader.ANO = Acceptance.ANO
 And QPCalc.ANO=Acceptance.ANO
 And Acceptance.ANO<>Acceptance.LANO
 And Acceptance.LANO=@P_ANO
 And Acceptance.AStatus<>'W'
 And Acceptance.ANO in
(SELECT AccAss.ANO from AccAss, RArrDet, FPart Where AccAss.ANO=Acceptance.ANO and AccAss.Type='FO' and FPart.ANO=RArrDet.ANO and FPart.FID=RArrDet.FID and AccAss.ANO=RArrDet.ANO and AccAss.ID=FPart.ID and AccAss.RefNo=FPart.SlipNo and (Acceptance.AType='C' or RArrDet.Status='O'))
)
    
     


GO
/****** Object:  UserDefinedFunction [dbo].[List12_Det]    Script Date: 6/8/2017 5:41:34 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO









CREATE  FUNCTION [dbo].[List12_Det] (@P_ANO as integer) 
RETURNS TABLE
AS RETURN(

SELECT Cast(0 as bit) as ProcessFlag,
	[Acceptance].[CertificateNo], 
	Acceptance.ESeqNo,
	[Acceptance].[AName], 
	[Acceptance].[ANO], 
	[Acceptance].[REGNO], 
	[Acceptance].[ADATE], 
	[Acceptance].[LUSERID] as UserID, 
	[SysTab].[Currency], 
	[QPCalc].[TSI], 
	[QPCalc].[OurShare], 
	[QPCalc].[Gross], 
	[Acceptance].[ASTATUS], 
	[Acceptance].[ATYPE], 
	[Acceptance].[SDate], 
	[Acceptance].[EDate], 
	Year([Acceptance].[SDate]) AS RYear,
 	Acceptance.ValueID,
dbo.get_objectInfo(Acceptance.ANO) as ValueDesc
FROM 
	Acceptance, 
	Cover, 
	SysTab, 
	QMasterAcceptance_PCalc() AS QPCalc,
	Rarrheader
WHERE 
	[Cover].[CNO]=[Acceptance].[CNO] 
	And Rarrheader.ANO = Acceptance.ANO
	And [QPCalc].[ANO]=[Acceptance].[ANO] 
	And [Acceptance].[ANO]<>[Acceptance].[LANO] 
	And [Acceptance].[LANO]=@P_ANO 
	And Cover.CStatus<>'C'
	And [Acceptance].[AStatus]='W' 
	And [RArrHeader].[TreatyF]=1 And RArrHeader.Status='A'
	And [Cover].[ISType]<>'T'
)



GO
/****** Object:  UserDefinedFunction [dbo].[List13_Det]    Script Date: 6/8/2017 5:41:34 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE  FUNCTION [dbo].[List13_Det] (@P_ANO as integer, @pSDate as smalldatetime, @pEDate as smalldatetime)
RETURNS TABLE
as RETURN(

SELECT Cast(0 as bit) as ProcessFlag,
	[Acceptance].[CertificateNo], 
	Acceptance.ESeqNo,
	[Acceptance].[AName], 
	[Acceptance].[ANO], 
	[Acceptance].[REGNO], 
	[Acceptance].[ADATE], 
	[Acceptance].[LUSERID] as UserID, 
	[SysTab].[Currency], 
	[QPCalc].[TSI], 
	[QPCalc].[OurShare], 
	[QPCalc].[Gross], 
	[Acceptance].[ASTATUS], 
	[Acceptance].[ATYPE], 
	[Acceptance].[SDate], 
	[Acceptance].[EDate], 
	Year([Acceptance].[SDate]) AS RYear,
 	Acceptance.ValueID,
dbo.get_objectInfo(Acceptance.ANO) as ValueDesc
FROM 
	Acceptance, 
	Cover, 
	SysTab, 
	QMasterAcceptance_PCalc() AS QPCalc
WHERE 
	[Cover].[CNO]=[Acceptance].[CNO] 
	And [QPCalc].[ANO]=[Acceptance].[ANO] 
	And [Acceptance].[ANO]<>[Acceptance].[LANO] 
	And [Acceptance].[LANO]=@P_ANO
     	And [Acceptance].AStatus='I'
      	And [Cover].[ISType]<>'T' 
      	And [Acceptance].[ADate]>=@pSDate 
      	And [Acceptance].[ADate]<=@pEDate
)

  

GO
/****** Object:  UserDefinedFunction [dbo].[List14_Det]    Script Date: 6/8/2017 5:41:34 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO









CREATE  FUNCTION [dbo].[List14_Det] (@P_ANO as integer) 
RETURNS TABLE
as RETURN(

SELECT Cast(0 as bit) as ProcessFlag,
	[Acceptance].[CertificateNo], 
	Acceptance.ESeqNo,
	[Acceptance].[AName], 
	[Acceptance].[ANO], 
	[Acceptance].[REGNO], 
	[Acceptance].[ADATE], 
	[Acceptance].[LUSERID] as UserID, 
	[SysTab].[Currency], 
	[QPCalc].[TSI], 
	[QPCalc].[OurShare], 
	[QPCalc].[Gross], 
	[Acceptance].[ASTATUS], 
	[Acceptance].[ATYPE], 
	[Acceptance].[SDate], 
	[Acceptance].[EDate], 
	Year([Acceptance].[SDate]) AS RYear,
 	Acceptance.ValueID,
dbo.get_objectInfo(Acceptance.ANO) as ValueDesc
FROM 
	Acceptance, 
	Cover, 
	SysTab, 
	QMasterAcceptance_PCalc() AS QPCalc
WHERE 
	[Cover].[CNO]=[Acceptance].[CNO] 
	And [QPCalc].[ANO]=[Acceptance].[ANO] 
	And [Acceptance].[ANO]<>[Acceptance].[LANO] 
	And [Acceptance].[LANO]=@P_ANO
	and Cover.OpenFlag=1
      	And [Acceptance].AStatus='I' 
      	And [Cover].[ISType]<>'T' 
)

 


GO
/****** Object:  UserDefinedFunction [dbo].[List15_Blank_Det]    Script Date: 6/8/2017 5:41:34 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO



CREATE FUNCTION [dbo].[List15_Blank_Det] (@P_ANO as integer,@P_REGID varchar(10), @P_FLDID varchar(255), @P_VALUEID varchar(255))
RETURNS Table
as RETURN(
  
SELECT Cast(0 as bit) as ProcessFlag,
 [Acceptance].[CertificateNo],
 Acceptance.ESeqNo,
 [Acceptance].[AName],
 [Acceptance].[ANO],
 [Acceptance].[REGNO],
 [Acceptance].[ADATE],
 [Acceptance].[LUSERID] as UserID,
 [SysTab].[Currency],
 [QPCalc].[TSI],
 [QPCalc].[OurShare],
 [QPCalc].[Gross],
 [Acceptance].[ASTATUS],
 [Acceptance].[ATYPE],
 [Acceptance].[SDate],
 [Acceptance].[EDate],
 Year([Acceptance].[SDate]) AS RYear,
 Acceptance.ValueID,
dbo.get_objectInfo(Acceptance.ANO) as ValueDesc
From
 Acceptance,
 Cover,
 SysTab,
 QMasterAcceptance_PCalc() AS QPCalc, RArrHeader
Where
 [cover].[CNO] = [acceptance].[CNO]
 And [QPCalc].[ANO]=[Acceptance].[ANO]
 And [Acceptance].[ANO]<>[Acceptance].[LANO]
 And [Acceptance].[LANO]=@P_ANO
 And [Cover].[ISType]<>'T'
 And [RArrHeader].[Status]='A'
 And [RArrHeader].[ANO]=[Acceptance].[ANO]
 And Acceptance.REGID=@P_REGID
 And [Acceptance].[FLDID]=@P_FLDID
 And [Acceptance].[ValueID] Like @P_ValueID + '%')
  
  



GO
/****** Object:  UserDefinedFunction [dbo].[List15_Det]    Script Date: 6/8/2017 5:41:34 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO











CREATE  FUNCTION [dbo].[List15_Det] (@P_ANO as integer,@P_REGID varchar(10), @P_FLDID varchar(255), @P_VALUEID varchar(255), @P_VALUEID1 varchar(255), @P_VALUEID2 varchar(255), @P_VALUEID3 varchar(255), @P_VALUEID4 varchar(255), @P_VALUEID5 varchar(255), @P_VALUEID6 varchar(255)) 
RETURNS TABLE
as RETURN(

SELECT Cast(0 as bit) as ProcessFlag,
	[Acceptance].[CertificateNo], 
	Acceptance.ESeqNo,
	[Acceptance].[AName], 
	[Acceptance].[ANO], 
	[Acceptance].[REGNO], 
	[Acceptance].[ADATE], 
	[Acceptance].[LUSERID] as UserID, 
	[SysTab].[Currency], 
	[QPCalc].[TSI], 
	[QPCalc].[OurShare], 
	[QPCalc].[Gross], 
	[Acceptance].[ASTATUS], 
	[Acceptance].[ATYPE], 
	[Acceptance].[SDate], 
	[Acceptance].[EDate], 
	Year([Acceptance].[SDate]) AS RYear,
	Acceptance.ValueID,
dbo.get_objectInfo(Acceptance.ANO) as ValueDesc
FROM 
	Acceptance, 
	Cover, 
	SysTab, 
	QMasterAcceptance_PCalc() AS QPCalc, RArrHeader, GenDTab
WHERE 
	[Cover].[CNO]=[Acceptance].[CNO] 
	And [QPCalc].[ANO]=[Acceptance].[ANO] 
	And [Acceptance].[ANO]<>[Acceptance].[LANO] 
	And [Acceptance].[LANO]=@P_ANO
	And [RArrHeader].[Status]='A' 
	And [RArrHeader].[ANO]=[Acceptance].[ANO] 
	And Acceptance.REGID=@P_REGID
	And [Acceptance].[FLDID]=[GenDTab].[FLDID] 
	And [Acceptance].[ValueID]=[GenDTab].[ValueID] 
	And [GenDTab].[FLDID]=@P_FLDID 
	And [GenDTab].[ValueID] Like @P_ValueID + '%' 
	And ([GenDTab].[ValueID1] Like @P_ValueID1 + '%' or [GenDTab].[ValueDesc1] Like @P_ValueID1 + '%')
	And ([GenDTab].[ValueID2] Like @P_ValueID2 + '%' or [GenDTab].[ValueDesc2] Like @P_ValueID2 + '%')
	And ([GenDTab].[ValueID3] Like @P_ValueID3 + '%' or [GenDTab].[ValueDesc3] Like @P_ValueID3 + '%')
	And ([GenDTab].[ValueID4] Like @P_ValueID4 + '%' or [GenDTab].[ValueDesc4] Like @P_ValueID4 + '%')
	And ([GenDTab].[ValueID5] Like @P_ValueID5 + '%' or [GenDTab].[ValueDesc5] Like @P_ValueID5 + '%')
	And ([GenDTab].[ValueID6] Like @P_ValueID6 + '%' or [GenDTab].[ValueDesc6] Like @P_ValueID6 + '%')
)
 

GO
/****** Object:  UserDefinedFunction [dbo].[List16_Det]    Script Date: 6/8/2017 5:41:34 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE  FUNCTION [dbo].[List16_Det] (@P_ANO as integer, @pSDate as smalldatetime,@pEDate as smalldatetime,@P_COB as varchar(10))  
RETURNS TABLE   
as RETURN(  
  
SELECT Cast(0 as bit) as ProcessFlag,  
 [Acceptance].[CertificateNo],   
 Acceptance.ESeqNo,  
 [Acceptance].[AName],   
 [Acceptance].[ANO],   
 [Acceptance].[REGNO],   
 [Acceptance].[ADATE],   
 [Acceptance].[LUSERID] as UserID,   
 [SysTab].[Currency],   
 [QPCalc].[TSI],   
 [QPCalc].[OurShare],   
 [QPCalc].[Gross],   
 [Acceptance].[ASTATUS],   
 [Acceptance].[ATYPE],   
 [Acceptance].[SDate],   
 [Acceptance].[EDate],   
 Year([Acceptance].[SDate]) AS RYear,  
 Acceptance.ValueID,  
dbo.get_objectInfo(Acceptance.ANO) as ValueDesc
FROM   
 Acceptance,   
 Cover,   
 SysTab,   
 QMasterAcceptance_PCalc() AS QPCalc,  
 TOC  
WHERE   
 [Cover].[CNO]=[Acceptance].[CNO]   
 And Acceptance.TOC = TOC.TOC  
 And [QPCalc].[ANO]=[Acceptance].[ANO]   
 And [Acceptance].[ANO]<>[Acceptance].[LANO]   
 And [Acceptance].[LANO]=@P_ANO   
 And [Cover].[ISType]<>'T'   
 And [Acceptance].[ADate]>=@pSDate   
 And [Acceptance].[ADate]<=@pEDate  
 And TOC.TOC=Acceptance.TOC  
 And TOC.COB=@P_COB  
)  


GO
/****** Object:  UserDefinedFunction [dbo].[list16SC_Det]    Script Date: 6/8/2017 5:41:34 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE  FUNCTION [dbo].[list16SC_Det] (@P_ANO as integer, @P_SDate as smalldatetime, @P_EDate as smalldatetime,@P_COB as varchar(10),@P_ServiceNo as varchar(20))  
RETURNS Table  
AS RETURN(  
    
SELECT Cast(0 as bit) as ProcessFlag,  
 [Acceptance].[CertificateNo],  
 Acceptance.ESeqNo,  
 [Acceptance].[AName],  
 [Acceptance].[ANO],  
 [Acceptance].[REGNO],  
 [Acceptance].[ADATE],  
 [Acceptance].[LUSERID] as UserID,  
 [SysTab].[Currency],  
 [QPCalc].[TSI],  
 [QPCalc].[OurShare],  
 [QPCalc].[Gross],  
 [Acceptance].[ASTATUS],  
 [Acceptance].[ATYPE],  
 [Acceptance].[SDate],  
 [Acceptance].[EDate],  
 Year([acceptance].[SDate]) As RYear,  
 Acceptance.ValueID,  
dbo.get_objectInfo(Acceptance.ANO) as ValueDesc
From  
 Acceptance,  
 Cover,  
 SysTab,  
 QMasterAcceptance_PCalc() AS QPCalc,  
 TOC,  
 Service  
Where  
 [cover].[CNO] = [acceptance].[CNO]  
 And [QPCalc].[ANO]=[Acceptance].[ANO]  
 And [Acceptance].[ANO]<>[Acceptance].[LANO]  
 And [Acceptance].[LANO]=@P_ANO  
 And Service.SType='CANCELLATION'  
 And Service.PANO=Acceptance.ANO  
 And Service.Cdate Between @P_Sdate and @P_EDate  
 And Service.SStatus='P'  
 And TOC.TOC=Acceptance.TOC  
 And TOC.COB Like @P_COB+'%'  
 And Service.ServiceNo Like @P_ServiceNo+'%'  
)  
    

GO
/****** Object:  UserDefinedFunction [dbo].[list16SD_Det]    Script Date: 6/8/2017 5:41:34 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[list16SD_Det] (@P_ANO as integer, @P_SDate as smalldatetime, @P_EDate as smalldatetime,@P_COB as varchar(10),@P_ServiceNo as varchar(20))  
RETURNS Table  
AS RETURN(  
      
SELECT Cast(0 as bit) as ProcessFlag,  
 [Acceptance].[CertificateNo],  
 Acceptance.ESeqNo,  
 [Acceptance].[AName],  
 [Acceptance].[ANO],  
 [Acceptance].[REGNO],  
 [Acceptance].[ADATE],  
 [Acceptance].[LUSERID] as UserID,  
 [SysTab].[Currency],  
 [QPCalc].[TSI],  
 [QPCalc].[OurShare],  
 [QPCalc].[Gross],  
 [Acceptance].[ASTATUS],  
 [Acceptance].[ATYPE],  
 [Acceptance].[SDate],  
 [Acceptance].[EDate],  
 Year([acceptance].[SDate]) As RYear,  
 Acceptance.ValueID,  
dbo.get_objectInfo(Acceptance.ANO) as ValueDesc
From  
 Acceptance,  
 Cover,  
 SysTab,  
 QMasterAcceptance_PCalc() AS QPCalc,  
 TOC,  
 Service  
Where  
 [cover].[CNO] = [acceptance].[CNO]  
 And [QPCalc].[ANO]=[Acceptance].[ANO]  
 And [Acceptance].[ANO]<>[Acceptance].[LANO]  
 And [Acceptance].[LANO]=@P_ANO  
 And ((Service.PANO=Acceptance.ANO and Service.SType<>'NEW') or (Service.ANO=Acceptance.ANO and Service.SType='NEW'))  
 And Service.Cdate Between @P_Sdate and @P_EDate  
 And Acceptance.AStatus='W'  
 And Service.SStatus='C'  
 And TOC.TOC=Acceptance.TOC  
 And TOC.COB Like @P_COB+'%'  
 And Service.ServiceNo Like @P_ServiceNo+'%'  
)  


GO
/****** Object:  UserDefinedFunction [dbo].[list16SE_Det]    Script Date: 6/8/2017 5:41:34 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE  FUNCTION [dbo].[list16SE_Det] (@P_ANO as integer, @P_SDate as smalldatetime, @P_EDate as smalldatetime,@P_COB as varchar(10),@P_ServiceNo as varchar(20))  
RETURNS Table  
AS RETURN(  
    
SELECT Cast(0 as bit) as ProcessFlag,  
 [Acceptance].[CertificateNo],  
 Acceptance.ESeqNo,  
 [Acceptance].[AName],  
 [Acceptance].[ANO],  
 [Acceptance].[REGNO],  
 [Acceptance].[ADATE],  
 [Acceptance].[LUSERID] as UserID,  
 [SysTab].[Currency],  
 [QPCalc].[TSI],  
 [QPCalc].[OurShare],  
 [QPCalc].[Gross],  
 [Acceptance].[ASTATUS],  
 [Acceptance].[ATYPE],  
 [Acceptance].[SDate],  
 [Acceptance].[EDate],  
 Year([acceptance].[SDate]) As RYear,  
 Acceptance.ValueID,  
dbo.get_objectInfo(Acceptance.ANO) as ValueDesc
From  
 Acceptance,  
 Cover,  
 SysTab,  
 QMasterAcceptance_PCalc() AS QPCalc,  
 TOC,  
 Service  
Where  
 [cover].[CNO] = [acceptance].[CNO]  
 And [QPCalc].[ANO]=[Acceptance].[ANO]  
 And [Acceptance].[ANO]<>[Acceptance].[LANO]  
 And [Acceptance].[LANO]=@P_ANO  
 And Service.SType='ENDORSEMENT'  
 And Service.PANO=Acceptance.ANO  
 And Service.Cdate Between @P_Sdate and @P_EDate  
 And Service.SStatus='P'  
 And TOC.TOC=Acceptance.TOC  
 And TOC.COB Like @P_COB+'%'  
 And Service.ServiceNo Like @P_ServiceNo+'%'  
)  


GO
/****** Object:  UserDefinedFunction [dbo].[list16SL_Det]    Script Date: 6/8/2017 5:41:34 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[list16SL_Det] (@P_ANO as integer, @P_SDate as smalldatetime, @P_EDate as smalldatetime,@P_COB as varchar(10),@P_ServiceNo as varchar(20))  
RETURNS Table  
AS RETURN(  
      
SELECT Cast(0 as bit) as ProcessFlag,  
 [Acceptance].[CertificateNo],  
 Acceptance.ESeqNo,  
 [Acceptance].[AName],  
 [Acceptance].[ANO],  
 [Acceptance].[REGNO],  
 [Acceptance].[ADATE],  
 [Acceptance].[LUSERID] as UserID,  
 [SysTab].[Currency],  
 [QPCalc].[TSI],  
 [QPCalc].[OurShare],  
 [QPCalc].[Gross],  
 [Acceptance].[ASTATUS],  
 [Acceptance].[ATYPE],  
 [Acceptance].[SDate],  
 [Acceptance].[EDate],  
 Year([acceptance].[SDate]) As RYear,  
 Acceptance.ValueID,  
dbo.get_objectInfo(Acceptance.ANO) as ValueDesc
From  
 Acceptance,  
 Cover,  
 SysTab,  
 QMasterAcceptance_PCalc() AS QPCalc,  
 TOC,  
 Service  
Where  
 [cover].[CNO] = [acceptance].[CNO]  
 And [QPCalc].[ANO]=[Acceptance].[ANO]  
 And [Acceptance].[ANO]<>[Acceptance].[LANO]  
 And [Acceptance].[LANO]=@P_ANO  
 And Service.SType='EXPIRED'  
 And Service.PANO=Acceptance.ANO  
 And Service.Cdate Between @P_Sdate and @P_EDate  
 And Service.SStatus='P'  
 And TOC.TOC=Acceptance.TOC  
 And TOC.COB Like @P_COB+'%'  
 And Service.ServiceNo Like @P_ServiceNo+'%'  
)  


GO
/****** Object:  UserDefinedFunction [dbo].[list16SR_Det]    Script Date: 6/8/2017 5:41:34 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[list16SR_Det] (@P_ANO as integer, @P_SDate as smalldatetime, @P_EDate as smalldatetime,@P_COB as varchar(10),@P_ServiceNo as varchar(20))  
RETURNS Table  
AS RETURN(  
    
SELECT Cast(0 as bit) as ProcessFlag,  
 [Acceptance].[CertificateNo],  
 Acceptance.ESeqNo,  
 [Acceptance].[AName],  
 [Acceptance].[ANO],  
 [Acceptance].[REGNO],  
 [Acceptance].[ADATE],  
 [Acceptance].[LUSERID] as UserID,  
 [SysTab].[Currency],  
 [QPCalc].[TSI],  
 [QPCalc].[OurShare],  
 [QPCalc].[Gross],  
 [Acceptance].[ASTATUS],  
 [Acceptance].[ATYPE],  
 [Acceptance].[SDate],  
 [Acceptance].[EDate],  
 Year([acceptance].[SDate]) As RYear,  
 Acceptance.ValueID,  
dbo.get_objectInfo(Acceptance.ANO) as ValueDesc
From  
 Acceptance,  
 Cover,  
 SysTab,  
 QMasterAcceptance_PCalc() AS QPCalc,  
 TOC,  
 Service  
Where  
 [cover].[CNO] = [acceptance].[CNO]  
 And [QPCalc].[ANO]=[Acceptance].[ANO]  
 And [Acceptance].[ANO]<>[Acceptance].[LANO]  
 And [Acceptance].[LANO]=@P_ANO  
 And Service.SType='RENEWAL'  
 And Service.PANO=Acceptance.ANO  
 And Service.Cdate Between @P_Sdate and @P_EDate  
 And Service.SStatus='P'  
 And TOC.TOC=Acceptance.TOC  
 And TOC.COB Like @P_COB+'%'  
 And Service.ServiceNo Like @P_ServiceNo+'%'  
)  

GO
/****** Object:  UserDefinedFunction [dbo].[List17_Det]    Script Date: 6/8/2017 5:41:34 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO









CREATE  FUNCTION [dbo].[List17_Det] (@P_ANO as integer, @pSDate as smalldatetime,@pEDate as smalldatetime,@P_SEGMENT as varchar(10))
RETURNS TABLE
as RETURN(

SELECT Cast(0 as bit) as ProcessFlag,
	[Acceptance].[CertificateNo], 
	Acceptance.ESeqNo,
	[Acceptance].[AName], 
	[Acceptance].[ANO], 
	[Acceptance].[REGNO], 
	[Acceptance].[ADATE], 
	[Acceptance].[LUSERID] as UserID, 
	[SysTab].[Currency], 
	[QPCalc].[TSI], 
	[QPCalc].[OurShare], 
	[QPCalc].[Gross], 
	[Acceptance].[ASTATUS], 
	[Acceptance].[ATYPE], 
	[Acceptance].[SDate], 
	[Acceptance].[EDate], 
	Year([Acceptance].[SDate]) AS RYear,
	Acceptance.ValueID,
dbo.get_objectInfo(Acceptance.ANO) as ValueDesc
FROM 
	Acceptance, 
	Cover, 
	SysTab, 
	QMasterAcceptance_PCalc() AS QPCalc
WHERE 
	[Cover].[CNO]=[Acceptance].[CNO] 
	And [QPCalc].[ANO]=[Acceptance].[ANO] 
	And [Acceptance].[ANO]<>[Acceptance].[LANO] 
	And [Acceptance].[LANO]=@P_ANO 
	And [Cover].[ISType]<>'T' 
	And [Acceptance].[ADate]>=@pSDate 
	And [Acceptance].[ADate]<=@pEDate
	And Cover.Segment=@P_SEGMENT
)

 

GO
/****** Object:  UserDefinedFunction [dbo].[List18_Det]    Script Date: 6/8/2017 5:41:34 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[List18_Det] (@P_ANO as integer, @P_UserID as varchar(10), @P_TOC as varchar(10), @P_Branch as varchar(10), @P_PDate as smalldatetime)      
RETURNS Table      
AS RETURN(      
          
SELECT Cast(0 as bit) as ProcessFlag,     
 [Acceptance].[CertificateNo],      
 Acceptance.ESeqNo,      
 [Acceptance].[AName],      
 [Acceptance].[ANO],      
 [Acceptance].[REGNO],      
 [Acceptance].[ADATE],      
 [Acceptance].[LUSERID] as UserID,      
 [SysTab].[Currency],      
 [QPCalc].[TSI],      
 [QPCalc].[OurShare],      
 [QPCalc].[Gross],      
 [Acceptance].[ASTATUS],      
 [Acceptance].[ATYPE],      
 [Acceptance].[SDate],      
 [Acceptance].[EDate],      
 Year([acceptance].[SDate]) As RYear,  
 Acceptance.ValueID,  
dbo.get_objectInfo(Acceptance.ANO) as ValueDesc  
From      
 Acceptance,      
 Cover,      
 SysTab,      
 QMasterAcceptance_PCalc() As QPCalc,      
 SysUserTOC,     
 SysUserBranch    
Where      
 [cover].[CNO] = [acceptance].[CNO]      
 And [QPCalc].[ANO]=[Acceptance].[ANO]      
 And [Acceptance].[ANO]<>[Acceptance].[LANO]      
 And [Acceptance].[LANO]=@P_ANO      
 And [Acceptance].[AStatus]='I'      
 And Acceptance.AType Not in ('C','A')      
And [Cover].[ISType]<>'T'      
AND @P_PDate between Acceptance.PDate and Acceptance.PPDate      
 And SysUserTOC.ID=@P_UserID and Acceptance.TOC=SysUserTOC.TOC and (SysUserTOC.TOC=@P_TOC or @P_TOC='')    
 And SysUserBranch.ID=@P_UserID and Acceptance.BRanch=SysUserBranch.Branch and (SysUserBranch.Branch=@P_Branch or @P_Branch='')    
 And Acceptance.ANO in (SELECT ANO from Claim, CLLOSS Where (Claim.CSTATUS IN ('R','P','T','A') OR Claim.PCSTATUS IN ('A')) and Claim.CNO=CLLOSS.CNO and CLLOSS.CTLF=1 And Claim.ANO=Acceptance.ANO)      
)      
                 

GO
/****** Object:  UserDefinedFunction [dbo].[List19_Det]    Script Date: 6/8/2017 5:41:34 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[List19_Det] (@P_ANO as integer, @P_Days as smallint, @P_Date as Smalldatetime,@P_COB as varchar(10),@P_Branch as varchar(10), @P_UnPaidOpt as Bit)   
RETURNS TABLE   
as RETURN(   
   
SELECT Cast(0 as bit) as ProcessFlag,   
[Acceptance].[CertificateNo],   
Acceptance.ESeqNo,   
[Acceptance].[AName],   
[Acceptance].[ANO],   
[Acceptance].[REGNO],   
[Acceptance].[ADATE],   
[Acceptance].[LUSERID] as UserID,   
[SysTab].[Currency],   
[QPCalc].[TSI],   
[QPCalc].[OurShare],   
[QPCalc].[Gross],   
[Acceptance].[ASTATUS],   
[Acceptance].[ATYPE],   
[Acceptance].[SDate],   
[Acceptance].[EDate],   
Year([Acceptance].[SDate]) AS RYear,   
Acceptance.ValueID,   
dbo.get_objectInfo(Acceptance.ANO) as ValueDesc
   
FROM   
Acceptance,   
Cover,   
SysTab,   
QMasterAcceptance_PCalc() AS QPCalc,   
TOC   
WHERE   
[Cover].[CNO]=[Acceptance].[CNO]   
And TOC.TOC=Acceptance.TOC and TOC.COB=@P_COB And Acceptance.Branch Like @P_Branch+'%'   
And [QPCalc].[ANO]=[Acceptance].[ANO]   
And [Acceptance].[ANO]<>[Acceptance].[LANO]   
And [Acceptance].[LANO]=@P_ANO   
And [Cover].[ISType]<>'T'   
And Acceptance.AStatus='I'  And Acceptance.AType<>'C'   
And EXISTS (SELECT A1.OANO from Acceptance A1, AccAss, Admlink, nVoucher Voucher Where A1.ANO=AccAss.ANO and A1.OANO=Acceptance.OANO and Voucher.Voucher=Admlink.Voucher and Admlink.AdmNo=AccAss.AdmNo and AccAss.Type in ('DI','IC','IR') and Voucher.nDueDate+@P_Days<@P_Date and Voucher.Nominal_CC-Voucher.Diff_CC-Voucher.Payment_CC-Voucher.Payment_OC<>0 and (@P_UnPaidOpt=0 or Voucher.Payment_CC=0))   
)  


GO
/****** Object:  UserDefinedFunction [dbo].[List20_Det]    Script Date: 6/8/2017 5:41:34 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
    
CREATE FUNCTION [dbo].[List20_Det](@P_ANO as integer, @P_USERID as varchar(255), @P_SDate as smalldatetime, @P_EDate as smalldatetime, @P_AStatus as varchar(1))       
RETURNS TABLE    
AS RETURN(    
    
SELECT 
 Cast(0 as bit) as ProcessFlag, 
 [Acceptance].[CertificateNo],     
 Acceptance.ESeqNo,    
 [Acceptance].[AName],     
 [Acceptance].[ANO],     
 [Acceptance].[REGNO],     
 [Acceptance].[ADATE],     
 [Acceptance].[LUSERID] as UserID,     
 [SysTab].[Currency],     
 [Acceptance].[ASTATUS],     
 [Acceptance].[ATYPE],     
 [Acceptance].[SDate],     
 [Acceptance].[EDate],     
 Year(Coalesce(RArrHeader.RDate,Acceptance.SDate)) AS RYear,    
 Acceptance.ValueID,    
dbo.get_objectInfo(Acceptance.ANO) as ValueDesc,
 QPCalc.TSI,            
 QPCalc.OurShare,            
 QPCalc.Gross 
FROM     
 Acceptance left Join RArrHeader on (RArrHeader.ANO=Acceptance.ANO)
 Left Join QDetail_PCalc() QPCalc on (qPCalc.ANO=Acceptance.ANO and Acceptance.PStatus='C'), 
 Cover,     
 SysTab
WHERE     
 [Cover].[CNO]=[Acceptance].[CNO]     
 And [Acceptance].[ANO]<>[Acceptance].[LANO]     
 And [Acceptance].[LANO]=@P_ANO    
 And [Cover].[ISType]<>'T'     
 And [Acceptance].[LUserID] Like @P_UserID    
 And [Acceptance].[LDate] between @P_SDate and @P_EDate     
 And ([Acceptance].AStatus=@P_AStatus or @P_AStatus='')     
)    
   

GO
/****** Object:  UserDefinedFunction [dbo].[List20_Det_Sub]    Script Date: 6/8/2017 5:41:34 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
    
CREATE FUNCTION [dbo].[List20_Det_Sub](@P_ANO as integer, @P_USERID as varchar(255), @P_SDate as smalldatetime, @P_EDate as smalldatetime, @P_AStatus as varchar(1))       
RETURNS TABLE    
AS RETURN(    
    
SELECT 
 [Acceptance].[CertificateNo],     
 Acceptance.ESeqNo,    
 [Acceptance].[AName],     
 [Acceptance].[ANO],     
 [Acceptance].[REGNO],     
 [Acceptance].[ADATE],     
 [Acceptance].[LUSERID] as UserID,     
 [SysTab].[Currency],     
 [Acceptance].[ASTATUS],     
 [Acceptance].[ATYPE],     
 [Acceptance].[SDate],     
 [Acceptance].[EDate],     
 Year([Acceptance].[SDate]) AS RYear,    
 Acceptance.ValueID,    
dbo.get_objectInfo(Acceptance.ANO) as ValueDesc
FROM     
 Acceptance,     
 Cover,     
 SysTab
WHERE     
 [Cover].[CNO]=[Acceptance].[CNO]     
 And [Acceptance].[ANO]<>[Acceptance].[LANO]     
 And [Acceptance].[LANO]=@P_ANO    
 And [Cover].[ISType]<>'T'     
 And [Acceptance].[LUserID] Like @P_UserID    
 And [Acceptance].[LDate] between @P_SDate and @P_EDate     
 And ([Acceptance].AStatus=@P_AStatus or @P_AStatus='')     
)    
    

GO

/****** Object:  UserDefinedFunction [dbo].[List21_Det]    Script Date: 6/8/2017 5:41:34 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[List21_Det] (@P_ANO as integer,@P_UserID varchar(255))   
RETURNS TABLE  
AS RETURN(  
  
SELECT Cast(0 as bit) as ProcessFlag,    
 [Acceptance].[CertificateNo],   
 Acceptance.ESeqNo,  
 [Acceptance].[AName],   
 [Acceptance].[ANO],   
 [Acceptance].[REGNO],   
 [Acceptance].[ADATE],   
 [Acceptance].[LUSERID] as UserID,   
 [SysTab].[Currency],   
 [QPCalc].[TSI],   
 [QPCalc].[OurShare],   
 [QPCalc].[Gross],   
 [Acceptance].[ASTATUS],   
 [Acceptance].[ATYPE],   
 [Acceptance].[SDate],   
 [Acceptance].[EDate],   
 Year([Acceptance].[SDate]) AS RYear,  
 Acceptance.ValueID,  
 dbo.get_objectInfo(Acceptance.ANO) as ValueDesc
FROM    
 Acceptance,   
 Cover,   
 SysTab,   
 QMasterAcceptance_PCalc() AS QPCalc  
WHERE    
 [Cover].[CNO]=[Acceptance].[CNO]   
 And [QPCalc].[ANO]=[Acceptance].[ANO]   
 And [Acceptance].[ANO]<>[Acceptance].[LANO]   
 And [Acceptance].[LANO]=@P_ANO  
 And [Acceptance].[RequestF]=1 and Acceptance.RequestName Like @P_UserID
)  
  

GO
/****** Object:  UserDefinedFunction [dbo].[List22_Det]    Script Date: 6/8/2017 5:41:34 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE FUNCTION [dbo].[List22_Det] (@P_ANO as integer,@P_SDate as smalldatetime, @P_EDate as smalldatetime)
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
 QPCalc.TSI,
 QPCalc.OurShare,
 QPCalc.Gross,
 Acceptance.ASTATUS,
 Acceptance.ATYPE,
 Acceptance.SDate,
 Acceptance.EDate,
 Year(Acceptance.SDate) AS RYear,
 Acceptance.ValueID,
dbo.get_objectInfo(Acceptance.ANO) as ValueDesc
From
 Acceptance,
 Cover,
 SysTab,
 QMasterAcceptance_PCalc() AS QPCalc,
 RARRHEADER
Where
 cover.CNO = acceptance.CNO
 And Rarrheader.ANO = Acceptance.ANO
 And QPCalc.ANO=Acceptance.ANO
 And Acceptance.ANO<>Acceptance.LANO
 And Acceptance.LANO=@P_ANO
 And Acceptance.AStatus='I'
)
    



GO
/****** Object:  UserDefinedFunction [dbo].[ListDet01_Sub]    Script Date: 6/8/2017 5:41:34 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
    
CREATE FUNCTION [dbo].[ListDet01_Sub](@P_ANO as integer)       
RETURNS TABLE    
AS RETURN(    
SELECT Acceptance.CertificateNo, Acceptance.ESeqNo,Acceptance.AName, Acceptance.ANO, Acceptance.REGNO, Acceptance.ADATE, Acceptance.LUSERID as USERID,SysTab.Currency, Acceptance.ASTATUS, Acceptance.ATYPE, Acceptance.SDate, Acceptance.EDate, Acceptance.ValueID, dbo.get_objectInfo(Acceptance.ANO) as ValueDesc        
FROM Acceptance, Cover, SysTab, Acceptance MAcceptance        
WHERE MAcceptance.ANO=@P_ANO and Cover.CNO=MAcceptance.CNO        
And (Acceptance.LANO=MAcceptance.ANO And Acceptance.ANO<>Acceptance.LANO And Acceptance.LANO<>-1)    

Union

SELECT Acceptance.CertificateNo, Acceptance.ESeqNo,Acceptance.AName, Acceptance.ANO, Acceptance.REGNO, Acceptance.ADATE, Acceptance.LUSERID as USERID,SysTab.Currency, Acceptance.ASTATUS, Acceptance.ATYPE, Acceptance.SDate, Acceptance.EDate, Acceptance.ValueID, dbo.get_objectInfo(Acceptance.ANO) as ValueDesc        
FROM Acceptance, Cover, SysTab, Acceptance MAcceptance        
WHERE MAcceptance.ANO=@P_ANO and Cover.CNO=MAcceptance.CNO        
And (MAcceptance.RegNo<>'' and Acceptance.RegNo=MAcceptance.RegNo and Acceptance.PolicyNo<>'' and Acceptance.PolicyNo=MAcceptance.PolicyNo And Acceptance.ANO<>Acceptance.LANO And Acceptance.LANO<>-1) 

Union

SELECT Acceptance.CertificateNo, Acceptance.ESeqNo,Acceptance.AName, Acceptance.ANO, Acceptance.REGNO, Acceptance.ADATE, Acceptance.LUSERID as USERID,SysTab.Currency, Acceptance.ASTATUS, Acceptance.ATYPE, Acceptance.SDate, Acceptance.EDate, Acceptance.ValueID, dbo.get_objectInfo(Acceptance.ANO) as ValueDesc        
FROM Acceptance, Cover, SysTab, Acceptance MAcceptance        
WHERE MAcceptance.ANO=@P_ANO and Cover.CNO=MAcceptance.CNO        
And (MAcceptance.AStatus='W' and MAcceptance.AType<>'N' and MAcceptance.PANO<>-1 and Acceptance.LANO=MAcceptance.PANO And Acceptance.ANO<>Acceptance.LANO And Acceptance.LANO<>-1)   
)    


GO
/****** Object:  UserDefinedFunction [dbo].[ListDet02_Sub]    Script Date: 6/8/2017 5:41:34 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
    
CREATE FUNCTION [dbo].[ListDet02_Sub](@P_ANO as integer)       
RETURNS TABLE    
AS RETURN(    
SELECT Acceptance.CertificateNo, Acceptance.ESeqNo,Acceptance.AName, Acceptance.ANO, Acceptance.REGNO, Acceptance.ADATE, Acceptance.LUSERID as USERID, SysTab.Currency, Acceptance.ASTATUS, Acceptance.ATYPE, Acceptance.SDate, Acceptance.EDate, Acceptance.ValueID, dbo.get_objectInfo(Acceptance.ANO) as ValueDesc   
FROM Acceptance, Cover, SysTab
WHERE Cover.CNO=Acceptance.CNO And Acceptance.ANO=@P_ANO  
)    


GO
/****** Object:  UserDefinedFunction [dbo].[ListDet03_Sub]    Script Date: 6/8/2017 5:41:34 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
    
CREATE FUNCTION [dbo].[ListDet03_Sub](@P_ANO as integer,@P_SDATE as smalldatetime, @P_EDATE as smalldatetime) 
RETURNS TABLE    
AS RETURN(    
SELECT Acceptance.CertificateNo, Acceptance.ESeqNo,Acceptance.AName, Acceptance.ANO, Acceptance.REGNO, Acceptance.ADATE, Acceptance.LUSERID as USERID,  SysTab.Currency, Acceptance.ASTATUS, Acceptance.ATYPE, Acceptance.SDate, Acceptance.EDate, Acceptance.ValueID, dbo.get_objectInfo(Acceptance.ANO) as ValueDesc       
FROM Acceptance, Cover, SysTab, Acceptance MAcceptance        
WHERE MAcceptance.ANO=@P_ANO and Cover.CNO=MAcceptance.CNO        
And (Acceptance.LANO=MAcceptance.ANO And Acceptance.ANO<>Acceptance.LANO And Acceptance.LANO<>-1)    
And Acceptance.ADate Between @P_Sdate and @P_EDate  

Union

SELECT Acceptance.CertificateNo, Acceptance.ESeqNo,Acceptance.AName, Acceptance.ANO, Acceptance.REGNO, Acceptance.ADATE, Acceptance.LUSERID as USERID,  SysTab.Currency, Acceptance.ASTATUS, Acceptance.ATYPE, Acceptance.SDate, Acceptance.EDate, Acceptance.ValueID, dbo.get_objectInfo(Acceptance.ANO) as ValueDesc      
FROM Acceptance, Cover, SysTab, Acceptance MAcceptance        
WHERE MAcceptance.ANO=@P_ANO and Cover.CNO=MAcceptance.CNO        
And (MAcceptance.RegNo<>'' and Acceptance.RegNo=MAcceptance.RegNo and Acceptance.PolicyNo<>'' and Acceptance.PolicyNo=MAcceptance.PolicyNo And Acceptance.ANO<>Acceptance.LANO And Acceptance.LANO<>-1)    
And Acceptance.ADate Between @P_Sdate and @P_EDate  

Union

SELECT Acceptance.CertificateNo, Acceptance.ESeqNo,Acceptance.AName, Acceptance.ANO, Acceptance.REGNO, Acceptance.ADATE, Acceptance.LUSERID as USERID,  SysTab.Currency, Acceptance.ASTATUS, Acceptance.ATYPE, Acceptance.SDate, Acceptance.EDate, Acceptance.ValueID, dbo.get_objectInfo(Acceptance.ANO) as ValueDesc       
FROM Acceptance, Cover, SysTab, Acceptance MAcceptance        
WHERE MAcceptance.ANO=@P_ANO and Cover.CNO=MAcceptance.CNO        
And (MAcceptance.AStatus='W' and MAcceptance.AType<>'N' and MAcceptance.PANO<>-1 and Acceptance.LANO=MAcceptance.PANO And Acceptance.ANO<>Acceptance.LANO And Acceptance.LANO<>-1) 
And Acceptance.ADate Between @P_Sdate and @P_EDate  

)    


GO
/****** Object:  UserDefinedFunction [dbo].[ListDet04_Sub]    Script Date: 6/8/2017 5:41:34 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
    
CREATE FUNCTION [dbo].[ListDet04_Sub](@P_ANO as integer,@P_FCERTNO as varchar(20), @P_LCERTNO as varchar(20))          
RETURNS TABLE    
AS RETURN(    
SELECT Acceptance.CertificateNo, Acceptance.ESeqNo,Acceptance.AName, Acceptance.ANO, Acceptance.REGNO, Acceptance.ADATE, Acceptance.LUSERID as USERID,  SysTab.Currency, Acceptance.ASTATUS, Acceptance.ATYPE, Acceptance.SDate, Acceptance.EDate, Acceptance.ValueID, dbo.get_objectInfo(Acceptance.ANO) as ValueDesc        
FROM Acceptance, Cover, SysTab, Acceptance MAcceptance          
WHERE MAcceptance.ANO=@P_ANO and Cover.CNO=MAcceptance.CNO          
And (Acceptance.LANO=MAcceptance.ANO And Acceptance.ANO<>Acceptance.LANO And Acceptance.LANO<>-1)      
And Acceptance.CertificateNo Between @P_FCertNo and @P_LCertNo          

Union

SELECT Acceptance.CertificateNo, Acceptance.ESeqNo,Acceptance.AName, Acceptance.ANO, Acceptance.REGNO, Acceptance.ADATE, Acceptance.LUSERID as USERID,  SysTab.Currency, Acceptance.ASTATUS, Acceptance.ATYPE, Acceptance.SDate, Acceptance.EDate, Acceptance.ValueID, dbo.get_objectInfo(Acceptance.ANO) as ValueDesc         
FROM Acceptance, Cover, SysTab, Acceptance MAcceptance          
WHERE MAcceptance.ANO=@P_ANO and Cover.CNO=MAcceptance.CNO          
And (MAcceptance.RegNo<>'' and Acceptance.RegNo=MAcceptance.RegNo and Acceptance.PolicyNo<>'' and Acceptance.PolicyNo=MAcceptance.PolicyNo And Acceptance.ANO<>Acceptance.LANO And Acceptance.LANO<>-1)        
And Acceptance.CertificateNo Between @P_FCertNo and @P_LCertNo          

Union

SELECT Acceptance.CertificateNo, Acceptance.ESeqNo,Acceptance.AName, Acceptance.ANO, Acceptance.REGNO, Acceptance.ADATE, Acceptance.LUSERID as USERID,  SysTab.Currency, Acceptance.ASTATUS, Acceptance.ATYPE, Acceptance.SDate, Acceptance.EDate, Acceptance.ValueID, dbo.get_objectInfo(Acceptance.ANO) as ValueDesc        
FROM Acceptance, Cover, SysTab, Acceptance MAcceptance          
WHERE MAcceptance.ANO=@P_ANO and Cover.CNO=MAcceptance.CNO          
And (MAcceptance.AStatus='W' and MAcceptance.AType<>'N' and MAcceptance.PANO<>-1 and Acceptance.LANO=MAcceptance.PANO And Acceptance.ANO<>Acceptance.LANO And Acceptance.LANO<>-1)
And Acceptance.CertificateNo Between @P_FCertNo and @P_LCertNo          
)    


GO


--Pengaktifan autoinforce

IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'AutoInforceF' AND Object_ID = Object_ID(N'PTClass'))
BEGIN
ALTER TABLE dbo.PTClass ADD AutoInforceF bit NULL
DECLARE @v sql_variant 
SET @v = N'Auto Inforce Flag (0 : No, 1 : Yes, Must Use Auto Inforce)'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'PTClass', N'COLUMN', N'AutoInforceF'
end
go

Update PTClass set AutoInforceF=0 Where AutoInforceF is null
go


--perbaikan Palias

IF EXISTS (SELECT *  FROM sys.indexes WHERE name='I_PAlias' AND object_id = OBJECT_ID('PAlias'))
BEGIN
ALTER TABLE dbo.PAlias	DROP CONSTRAINT I_PAlias
END
GO

ALTER TABLE PALIAS ALTER COLUMN ADDRESS VARCHAR(1024)
GO

IF NOT EXISTS (SELECT *  FROM sys.indexes WHERE name='I_PALIAS_ID' AND object_id = OBJECT_ID('PALIAS'))
BEGIN
CREATE INDEX I_PALIAS_ID ON PALIAS(ID)
END
go


--Penambahan coverage 7-10 pada scheme
 
IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'Coverage_7' AND Object_ID = Object_ID(N'Scheme_Transaction'))
BEGIN
ALTER TABLE dbo.Scheme_Transaction ADD	Coverage_7 varchar(255) NULL
DECLARE @v sql_variant 
SET @v = N'''TS'''
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'Scheme_Transaction', N'COLUMN', N'Coverage_7'
end
GO

IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'Coverage_8' AND Object_ID = Object_ID(N'Scheme_Transaction'))
BEGIN
ALTER TABLE dbo.Scheme_Transaction ADD	Coverage_8 varchar(255) NULL,
	Coverage_9 varchar(255) NULL,
	Coverage_10 varchar(255) NULL
DECLARE @v sql_variant 
SET @v = N'''TS'''
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'Scheme_Transaction', N'COLUMN', N'Coverage_8'
end
GO

IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'Coverage_9' AND Object_ID = Object_ID(N'Scheme_Transaction'))
BEGIN
ALTER TABLE dbo.Scheme_Transaction ADD	Coverage_9 varchar(255) NULL
DECLARE @v sql_variant 
SET @v = N'''TS'''
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'Scheme_Transaction', N'COLUMN', N'Coverage_9'
end
go

IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'Coverage_10' AND Object_ID = Object_ID(N'Scheme_Transaction'))
BEGIN
ALTER TABLE dbo.Scheme_Transaction ADD	Coverage_10 varchar(255) NULL
DECLARE @v sql_variant 
SET @v = N'''TS'''
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'Scheme_Transaction', N'COLUMN', N'Coverage_10'
end
go

IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'Coverage_7' AND Object_ID = Object_ID(N'SysBatchOriginalSC'))
BEGIN
ALTER TABLE dbo.SysBatchOriginalSC ADD
	Coverage_7 varchar(255) NULL,
	Coverage_8 varchar(255) NULL,
	Coverage_9 varchar(255) NULL,
	Coverage_10 varchar(255) NULL
end
GO
IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'Coverage_7' AND Object_ID = Object_ID(N'SysBatchSC'))
BEGIN
ALTER TABLE dbo.SysBatchSC ADD
	Coverage_7 varchar(255) NULL,
	Coverage_8 varchar(255) NULL,
	Coverage_9 varchar(255) NULL,
	Coverage_10 varchar(255) NULL
end
go


--16 JUN 2017 :PENAMBAHAN LOAD FROM EXCEL
DROP FUNCTION DB_U_I_DISBURSE
GO
CREATE FUNCTION DB_U_I_DISBURSE(@P_PDate smalldatetime, @P_Voucher as varchar(20), @P_PolicyNo as varchar(50), @P_RefNo as varchar(50), @P_DocNo as varchar(50)) 
RETURNS TABLE    
AS RETURN    
(    
select distinct  Admlink.RefNo as RefNo, Voucher.Voucher,Admlink.Type, Admlink.Date, Admlink.Subject, Voucher.DocNo, Voucher.StatID, Voucher.ActionBy, Voucher.ActionDate, Voucher.AcceptedBy, Voucher.AcceptedDate,     
Voucher.[Currency],  Voucher.Installment, Voucher.DueDate as DueDate, Voucher.AmountDue-Voucher.Payment_CC-Voucher.Payment_OC as Nominal,    
Profile.Name+'-'+AdmLink.Remarks as AName, Profile.Name, Voucher.debtorF,Voucher.CreditorF,AdmLink.BatchNo, Admlink.RefType,Voucher.Branch, Admlink.Code, Admlink.A_PolicyNo, Admlink.EXTRA_4  
from ProAcc,[Profile],Voucher_AmountWPCDue(@P_PDate) Voucher,AdmLink  
where  Voucher.Voucher=AdmLink.Voucher     
and ProAcc.ProAcc=Voucher.ProAcc     
and ProAcc.[ID]=[Profile].[ID]     
and Admlink.Type in ('DI','IC','SO','OP')    
and Not ((Admlink.Type in ('OP') and Admlink.Amount_8<>0) or (Admlink.Type in ('DI','SO') and Admlink.Amount_7+Admlink.Amount_12=Admlink.Amount)) -- Not Claim Salvage/Excess      
and Upper(AdmLink.Subject)='CLAIM'  
and Admlink.Voucher Like @P_Voucher 
and Admlink.A_PolicyNo Like @P_PolicyNo 
and Admlink.RefNo Like @P_RefNo 
and Admlink.DocNo Like @P_DocNo
) 

GO

DROP FUNCTION DB_U_F_DISBURSE
GO
CREATE FUNCTION DB_U_F_DISBURSE(@P_PDate smalldatetime, @P_Voucher as varchar(20), @P_PolicyNo as varchar(50), @P_RefNo as varchar(50), @P_DocNo as varchar(50)) 
RETURNS TABLE    
AS RETURN    
(    
select distinct  Admlink.RefNo as RefNo, Voucher.Voucher,Admlink.Type, Admlink.Date, Admlink.Subject, Voucher.DocNo, Voucher.StatID, Voucher.ActionBy, Voucher.ActionDate, Voucher.AcceptedBy, Voucher.AcceptedDate,     
Voucher.[Currency],  Voucher.Installment, Voucher.DueDate as DueDate, Voucher.Nominal_CC-Voucher.Diff_CC-Voucher.Payment_CC-Voucher.Payment_OC as Nominal,    
AdmLink.Remarks as AName, Profile.Name, Voucher.debtorF,Voucher.CreditorF, AdmLink.BatchNo, Admlink.RefType,Voucher.Branch, Admlink.Code, Admlink.A_PolicyNo, Admlink.EXTRA_4  
from ProAcc,[Profile], nVoucher Voucher, AdmLink  
where  Voucher.Voucher=AdmLink.Voucher     
and ProAcc.ProAcc=Voucher.ProAcc     
and ProAcc.[ID]=[Profile].[ID]     
and Admlink.Type in ('DI','IC','SO','OP')    
and Not ((Admlink.Type in ('OP') and Admlink.Amount_8<>0) or (Admlink.Type in ('DI','SO') and Admlink.Amount_7+Admlink.Amount_12=Admlink.Amount)) -- Not Claim Salvage/Excess      
and Upper(AdmLink.Subject)='CLAIM'  
and Admlink.Date<=@P_PDate
and Admlink.Voucher Like @P_Voucher 
and Admlink.A_PolicyNo Like @P_PolicyNo 
and Admlink.RefNo Like @P_RefNo 
and Admlink.DocNo Like @P_DocNo
  
)    
  
GO

DROP FUNCTION DB_U_R_DISBURSE
GO
CREATE FUNCTION DB_U_R_DISBURSE(@P_PDate smalldatetime, @P_Voucher as varchar(20), @P_PolicyNo as varchar(50), @P_RefNo as varchar(50), @P_DocNo as varchar(50)) 
RETURNS TABLE  
AS RETURN  
(  
select distinct  Voucher.RefNo, Voucher.Voucher,Admlink.Type, Admlink.Date, Admlink.Subject, Admlink.Extra_3,Voucher.DocNo, Voucher.StatID, Voucher.ActionBy, Voucher.ActionDate, Voucher.AcceptedBy, Voucher.AcceptedDate,   
Voucher.[Currency],  Voucher.Installment, Voucher.DueDate as DueDate, Voucher.AmountDue-Voucher.Payment_CC-Voucher.Payment_OC as Nominal,  
Case When Reinsurance.DocNo is null Then Admlink.Remarks else Reinsurance.Description end +Voucher.sInstallment as AName, Profile.Name, Voucher.debtorF,Voucher.CreditorF,AdmLink.BatchNo, Admlink.RefType,Voucher.Branch, Admlink.Code, Admlink.A_PolicyNo, Admlink.EXTRA_4
from ProAcc,[Profile],Voucher_AmountWPCDue(@P_PDate) Voucher,AdmLink Left Join Reinsurance On (Reinsurance.DocNo=Admlink.RefNo)
where  Voucher.Voucher=AdmLink.Voucher   
and ProAcc.ProAcc=Voucher.ProAcc   
and ProAcc.[ID]=[Profile].[ID]   
and Admlink.Type in ('PI','FO','QS','QP','S1','S2','S3','CP','XP','AF','DC','X1','X2','X3','X4','X5','X6','X7','X8','X9','XX','RP','AP','IR','IT','IX')  
and Admlink.Voucher Like @P_Voucher 
and Admlink.A_PolicyNo Like @P_PolicyNo 
and Admlink.RefNo Like @P_RefNo 
and Admlink.DocNo Like @P_DocNo

)  
GO

--Perbaikan Untuk polis coinsurance, nilai amount yang ditampilkan di payor sesuai dengan ourshare

DROP FUNCTION FN_PCalc
GO
Create FUNCTION FN_PCalc (@P_ANO as integer) RETURNS Table AS RETURN ( SELECT  Acceptance.ANO,  Count(Distinct PCalc.Currency) AS NUMCCY,
 MAX(PCALC.RATE) AS RATE,
 MAX(CASE When Acceptance.QTY=0 Then 1 Else Acceptance.QTY end) as NumRisk,  sum(PCalc.TSI*PCalc.Rate*Case When Acceptance.QTY=0 Then 1 Else Acceptance.QTY end) AS TSI,  sum(PCalc.OurShare*PCalc.Rate*Case When Acceptance.QTY=0 Then 1 Else Acceptance.QTY end) AS OurShare,  sum(PCalc.Amount*PCalc.Rate*Case When Acceptance.QTY=0 Then 1 Else Acceptance.QTY end) AS Amount,  sum(PCalc.Gross*PCalc.Rate*Case When Acceptance.QTY=0 Then 1 Else Acceptance.QTY end) AS Gross,  sum(PCalc.Claim*PCalc.Rate*Case When Acceptance.QTY=0 Then 1 Else Acceptance.QTY end) AS Claim,  sum(case when PCalc.TSI=0 then 0 else PCalc.OurShare*PCalc.Rate*Case When Acceptance.QTY=0 Then 1 Else Acceptance.QTY end end)/  sum(case when PCalc.TSI=0 then 1 else PCalc.TSI*PCalc.Rate*Case When Acceptance.QTY=0 Then 1 Else Acceptance.QTY end end)*  sum(PCalc.Gross*PCalc.Rate*Case When Acceptance.QTY=0 Then 1 Else Acceptance.QTY end) as Premium,
 Max(Acceptance.ValueID) as ValueID,
 Max(Acceptance.ValueDesc) as ValueDesc,
 MAX(Year(RARRHEADER.RDATE)) As RYear,
 MAX(CASE WHEN PCALC.TSI<>0 AND COALESCE(ISOURCE.LIMIT,0)<>0 THEN PCALC.OURSHARE/PCALC.TSI*100 ELSE COALESCE(ISOURCE.SHARE,100) END) as PCTSHARE,
 MAX(RARRHEADER.MSHARE) as MSHARE,
 Max(cast(Datediff(month,Acceptance.SDate, Acceptance.EDate) as float)/cast(12 as float)) as Prorata FROM  Acceptance with(NOLOCK) LEFT JOIN Pcalc with(NOLOCK) ON (Acceptance.ANO=PCalc.ANO and Acceptance.PStatus='C') LEFT JOIN RArrHeader with(NOLOCK) On (RArrHeader.ANO=Acceptance.ANO) LEFT JOIN ISOURCE with (NOLOCK) ON (ISOURCE.CNO=ACCEPTANCE.CNO) Where Acceptance.ANO=@P_ANO GROUP BY Acceptance.ANO
)

go