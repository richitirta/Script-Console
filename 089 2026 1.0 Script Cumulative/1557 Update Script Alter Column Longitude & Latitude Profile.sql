
DROP View vProfile
GO

alter table profile
alter column latitude Varchar(50)
GO

alter table profile
alter column Longtitude Varchar(50)
GO


Create View vProfile

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

from dbo.Profile Profile

Inner Join dbo.SysTab SysTab on (1=1)


GO


insert into PatchVersioning
select '1557 Update Script Alter Column Longitude & Latitude Profile.sql',GETDATE()
go	
  
Declare @PrevScript varchar(100)
Declare @CurrScript varchar(100)

Select @PrevScript=''
Select @CurrSCript='1557 Update Script Alter Column Longitude & Latitude Profile.sql'


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

GO 