SET QUOTED_IDENTIFIER ON
SET ARITHABORT ON
SET NUMERIC_ROUNDABORT OFF
SET CONCAT_NULL_YIELDS_NULL ON
SET ANSI_NULLS ON
SET ANSI_PADDING ON
SET ANSI_WARNINGS ON


if exists (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'vProfile') ) 
BEGIN 
DROP VIEW dbo.vProfile 
 END
GO

IF EXISTS(SELECT * FROM sys.columns WHERE Name = N'Rating' AND Object_ID = Object_ID(N'Profile'))
BEGIN
ALTER TABLE dbo.Profile Alter column
	Rating varchar(100)
END
go

IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'Rating_Agency' AND Object_ID = Object_ID(N'dbo.Profile'))
BEGIN
ALTER TABLE dbo.Profile ADD Rating_Agency varchar(100) NULL
DECLARE @v sql_variant  
SET @v = N'Rating Agency'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'Profile', N'COLUMN', N'Rating_Agency' 
END
GO

IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'Rating_Date' AND Object_ID = Object_ID(N'dbo.Profile'))
BEGIN
ALTER TABLE dbo.Profile ADD Rating_Date smalldatetime NULL
DECLARE @v sql_variant  
SET @v = N'Rating Date'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'Profile', N'COLUMN', N'Rating_Date' 
END
GO

if exists (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'vProfile') ) 
BEGIN DROP VIEW dbo.vProfile END
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
from dbo.Profile Profile
Inner Join dbo.SysTab SysTab on (1=1)

GO

if exists (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'vProfile_Ext') ) 
BEGIN 
DROP VIEW dbo.vProfile_Ext 
 END
GO

Create View vProfile_Ext
WITH SCHEMABINDING
AS
select 
	Profile.ID
	,Profile.BLNo
	,Profile.BLDate
	,Profile.BOD_1
	,Profile.BODFunction_1
	,Profile.BOD_2
	,Profile.BODFunction_2
	,Profile.BOD_3
	,Profile.BODFunction_3
	,Profile.SHolder_1
	,Profile.SHolder_2
	,Profile.SHolder_3
	,Profile.WNIF
	,Profile.NickName
	,Profile.Citizen
	,Profile.CName
	,Profile.CAddress
	,Profile.CPhone_1
	,Profile.CPhone_2
	,Profile.Employment
	,Profile.Income
	,Profile.OtherIncome
	,Profile.ID_Date
	,dbo.fn_DECRYPTTEXT(SysTab.EncryptionPassPhrase,Profile.ID_No) as ID_No
	,dbo.fn_DECRYPTTEXT(SysTab.EncryptionPassPhrase,Profile.ID_Type) as ID_Type 
	,dbo.fn_DECRYPTTEXT(SysTab.EncryptionPassPhrase,Profile.PassportNo) as PassportNo 
	,dbo.fn_DECRYPTTEXT(SysTab.EncryptionPassPhrase,Profile.Gender) as Gender 
	,dbo.fn_DECRYPTTEXT(SysTab.EncryptionPassPhrase,Profile.MothersName) as MothersName 
	,dbo.fn_DECRYPTDATE(SysTab.EncryptionPassPhrase,Profile.BirthDate) as BirthDate 
	,Profile.ID_Name
	,Profile.BirthPlace
	,Profile.Religion
	,Profile.Purpose
	,Profile.SIUP
	,Profile.TDP
	,Profile.Marital
	,Profile.JOBTitle
	,Profile.PIC_TITLE_1
	,Profile.PIC_NAME_1
	,Profile.PIC_TITLE_2
	,Profile.PIC_NAME_2
	,Profile.PIC_TITLE_3
	,Profile.PIC_NAME_3
	,Profile.HOMEPAGE
	,Profile.ID_Date_Ext
	,Profile.ID_No_Ext
	,Profile.ID_Name_Ext
	,Profile.ID_Type_Ext
	,Profile.ADDHOMEPAGE
	,Profile.BLPlace
	,Profile.CBRAFLAG
	,Profile.CBRATPMID
	,Profile.CBRADepartment
	,Profile.CBRACOID
	,Profile.CBRATPRMID
	,Profile.CBRATPStatus
	,Profile.CBRATPTYPE
	,Profile.CBRATPRMSCOPE
	,Profile.CBRANDASTATUS
	,Profile.CBRANDAEFFDATE
	,Profile.CBRANDAEXPDATE
	,Profile.CBRAAgreement
	,Profile.CBRAAgreementStatus
	,Profile.CBRAAgreementEffDate
	,Profile.CBRAAgreementExpDate
	,Profile.CBRAOBDDDate
	,Profile.CBRAOBDDStatus
	,Profile.CBRAOBDDRating
	,Profile.CBRALODDID
	,Profile.CBRALODDStatus
	,Profile.CBRALODDCreateDate
	,Profile.CBRALODDCompDate
	,Profile.CBRALatestResRisk
	,Profile.CBRALatestMaxInfoSec
	,Profile.CBRALatestMaxBCM
	,Profile.CBRALatestMaxCompliance
	,Profile.CBRALatestCurrFVA
	,Profile.CBRALatestMaxMateriality
	,Profile.CBRANDDSInfoSecDate
	,Profile.CBRANDDSBusContDate
	,Profile.CBRANDDSFVADate
	,Profile.CBRANDDSMaterialityDate
	,Profile.CBRANDDSISODate
	,Profile.CBRAODDSDate
	,Profile.CBRAODDSTPDate
	,Profile.BeneficiaryOwner
	,Profile.CBRAOBID
	,Profile.CBRAOBCDDate
	,Profile.CBRANOREFDATE
	,Profile.CBRATPEForm
	,Profile.CBRATPEFormSubDate
	,Profile.CBRAODDCDate
	,Profile.DomicileAddress
	,Profile.AddressSameIDF
	,Profile.PIDExpDate
	,Profile.NoPIDExpDateF
	,Profile.LastEducation
	,Profile.MonthlyIncome
	,Profile.MonthlyExpenses
	,Profile.Num_Dependent
	,Profile.Relation
	,Profile.Debtor_Class
	,Profile.BirthDate_1
	,Profile.ID_No_Ext_1
	,Profile.ID_Type_Ext_1
	,Profile.ID_No_Ext_2
	,Profile.ID_Type_Ext_2
	,Profile.ID_No_Ext_3
	,Profile.ID_Type_Ext_3
	,Profile.BOD_Gender_1
	,Profile.BOD_Gender_2
	,Profile.BOD_Gender_3
	,Profile.BOD_Address_1
	,Profile.BOD_Address_2
	,Profile.BOD_Address_3
	,Profile.BOD_SubDistrict_1
	,Profile.BOD_SubDistrict_2
	,Profile.BOD_SubDistrict_3
	,Profile.BOD_District_1
	,Profile.BOD_District_2
	,Profile.BOD_District_3
	,Profile.BOD_City_1
	,Profile.BOD_City_2
	,Profile.BOD_City_3
	,Profile.Own_Share
	,Profile.Own_Status
from dbo.Profile_Ext Profile
Inner Join dbo.SysTab SysTab on (1=1)


GO


Update Profile set Rating_agency=E.Rating_Agency, Rating_Date=E.Rating_Date from profile P, Profile_Ext E
where P.ID=E.ID
go

IF EXISTS(SELECT * FROM sys.columns WHERE Name = N'Rating_Agency' AND Object_ID = Object_ID(N'profile_Ext'))
BEGIN
Alter table profile_Ext drop column Rating_Agency
end
go

IF EXISTS(SELECT * FROM sys.columns WHERE Name = N'Rating_Date' AND Object_ID = Object_ID(N'profile_Ext'))
BEGIN
Alter table profile_Ext drop column Rating_Date
end
go

insert into PatchVersioning
select '1457.1 Update Script Patch Profile SLIK Oct 2025',GETDATE()
go	

Declare @PrevScript varchar(100)
Declare @CurrScript varchar(100)

Select @PrevScript=''
Select @CurrScript='1457.1 Update Script Patch Profile SLIK Oct 2025'


Declare @ExecScript varchar(100)
Declare @ExecScriptStatus varchar(100)
Declare @Error varchar(200)

Select @Error=''

Begin 
       Select @ExecScript=ExecScript,  @ExecScriptStatus=ExecScriptStatus from systab 
       if @PrevScript<>'' and @ExecScript<>@PrevScript
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

GO