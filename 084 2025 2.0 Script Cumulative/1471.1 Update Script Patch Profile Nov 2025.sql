
if exists (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'vProfile') ) 
BEGIN 
DROP VIEW dbo.vProfile 
 END
GO

IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'BatchNo' AND Object_ID = Object_ID(N'dbo.Profile'))
BEGIN
    ALTER TABLE dbo.Profile ADD [BatchNo] [varchar](10) NULL
END
GO


IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'CRM_NO' AND Object_ID = Object_ID(N'Profile'))
BEGIN
ALTER TABLE dbo.Profile ADD
	CRM_NO varchar(50)
end
DECLARE @v sql_variant 
SET @v = N'CRM NO'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'Profile', N'COLUMN', N'CRM_NO'
GO
go

IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'RequestF' AND Object_ID = Object_ID(N'Profile'))
BEGIN
ALTER TABLE dbo.Profile ADD
	RequestF bit
end
DECLARE @v sql_variant 
SET @v = N'Request Flag (0 : No, 1 : Yes)'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'Profile', N'COLUMN', N'RequestF'
GO
go

IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'RequestMessage' AND Object_ID = Object_ID(N'Profile'))
BEGIN
ALTER TABLE dbo.Profile ADD
	RequestMessage	varchar(max)
end
DECLARE @v sql_variant 
SET @v = N'RequestMessage'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'Profile', N'COLUMN', N'RequestMessage'
GO
go

IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'RequestName' AND Object_ID = Object_ID(N'Profile'))
BEGIN
ALTER TABLE dbo.Profile ADD
	RequestName	varchar
end
DECLARE @v sql_variant 
SET @v = N'RequestName'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'Profile', N'COLUMN', N'RequestName'
GO

IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'CTime' AND Object_ID = Object_ID(N'Profile'))
BEGIN
ALTER TABLE dbo.Profile ADD
	CTime	varchar(8)
end
DECLARE @v sql_variant 
SET @v = N'Creation Time'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'Profile', N'COLUMN', N'CTime'
GO


IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'OLicenseNo' AND Object_ID = Object_ID(N'Profile'))
BEGIN
ALTER TABLE dbo.Profile ADD
	OLicenseNo varchar(50)
end
DECLARE @v sql_variant 
SET @v = N'Original Biz License NO'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'Profile', N'COLUMN', N'OLicenseNo'
GO

IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'OLicenseDate' AND Object_ID = Object_ID(N'Profile'))
BEGIN
ALTER TABLE dbo.Profile ADD
	OLicenseDate smalldatetime
end
DECLARE @v sql_variant 
SET @v = N'Original Biz License Date'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'Profile', N'COLUMN', N'OLicenseDate'
GO


Create View vProfile
WITH SCHEMABINDING
AS
select 
	Profile.ID
	,Profile.Salutation
	,Profile.FirstName
	,Profile.MidName
	,Profile.LastName
	,Profile.Name
	,Profile.Initial
	,Profile.Address_1
	,Profile.Address_2
	,Profile.Address_3
	,Profile.City
	,Profile.ZipCode
	,Profile.Phone_1
	,Profile.Phone_2
	,Profile.Mobile_1
	,Profile.Mobile_2
	,Profile.Fax_1
	,Profile.Fax_2
	,Profile.Contact
	,Profile.ContactAddress
	,Profile.ContactPhone
	,Profile.Title
	,Profile.PTYPE
	,Profile.RefID
	,dbo.fn_DECRYPTTEXT(SysTab.EncryptionPassPhrase,Profile.TaxID) as TaxID
	,dbo.fn_DECRYPTTEXT(SysTab.EncryptionPassPhrase,Profile.Email) as Email
	,dbo.fn_DECRYPTTEXT(SysTab.EncryptionPassPhrase,Profile.Email_2) as Email_2
	,Profile.TaxName
	,Profile.TaxAddress
	,Profile.VatF
	,Profile.TaxF
	,Profile.LOB
	,Profile.Country
	,Profile.CorporateF
	,Profile.IntermediaryF
	,Profile.Rating
	,Profile.Rating_Agency
	,Profile.Rating_Date
	,Profile.CGroup
	,Profile.SCGroup
	,Profile.Area
	,Profile.TaxType
	,Profile.VAT
	,Profile.TAX
	,Profile.TAXPCT
	,Profile.NTAXINCOME
	,Profile.LAST_OPR
	,Profile.LAST_UPDATE
	,Profile.PID
	,Profile.COMM
	,Profile.Disc
	,Profile.RESTRICTEDF
	,Profile.PREFERREDF
	,Profile.REMARK
	,Profile.CTYPE
	,Profile.ProviderF
	,Profile.RedFlag
	,Profile.RedFlagDate
	,Profile.RedFlagTime
	,Profile.RedFlagDescription
	,Profile.RedFlagUser
	,Profile.DumpF
	,dbo.fn_DECRYPTTEXT(SysTab.EncryptionPassPhrase,Profile.USERID) as USERID
	,Profile.CDATE
	,Profile.ASource
	,Profile.Owner
	,Profile.WPC
	,Profile.Grace
	,Profile.Branch
	,Profile.NetCommF
	,Profile.MaxOutGo
	,Profile.LicenseNo
	,Profile.TPAF
	,Profile.Province
	,Profile.XProfileID
	,Profile.ICPSF
	,Profile.RType
	,Profile.LicenseDate
	,Profile.LicenseExpiry
	,Profile.ContactTitle
	,Profile.TAXHSDate
	,Profile.TAXHEDate
	,Profile.MOID
	,Profile.HSCode
	,Profile.BIType
	,Profile.AccruedTax
	,Profile.Last_Time
	,Profile.Regency
	,Profile.SubsidiaryF
	,Profile.Latitude
	,Profile.Longtitude
	,Profile.District
	,Profile.SubDistrict
	,Profile.RoomNo
	,Profile.FloorNo
	,Profile.HomeNo
	,Profile.MOO
	,Profile.SOI
	,Profile.Village
	,Profile.Building
	,Profile.Road
	,Profile.SyncDate
	,Profile.SyncTime
	,Profile.SYNCERRORMESSAGE
	,Profile.BVATF
	,Profile.TVATF
	,Profile.RestrictedDate
	,Profile.RestrictedTime
	,Profile.RestrictedUser
	,Profile.PrivilegeType
	,Profile.DeferralF
	,Profile.VerifiedBy
	,Profile.VerifiedDate
	,Profile.VerifiedTime
	,Profile.VATOLD
	,Profile.VATSubsidiesF
	,Profile.VATESDate
	,Profile.VATEEDate
	,Profile.CBRAID
	,Profile.CBRADATE
	,Profile.CBRANRDATE
	,Profile.ConsentOnDataKeepByCompanyF
	,Profile.ConsentOnDataPrivacyToThirdPartyF
	,Profile.ConsentOnProductAndServiceOfferingF
	,Profile.VerifiedF
	,Profile.AccruedVAT
	,Profile.TAXIDOLD
	,Profile.Email_3
	,Profile.VATCOMMEXEMPTIF
	,Profile.TAXSubsidiesF
	,Profile.CRM_NO
	,Profile.CTime
	,Profile.OLicenseNo
	,Profile.OLicenseDate
from dbo.Profile Profile
Inner Join dbo.SysTab SysTab on (1=1)

GO


insert into PatchVersioning
select '1471.1 Update Script Patch Profile CRM Nov 2025.sql',GETDATE()
go	
  
