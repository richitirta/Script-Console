SET QUOTED_IDENTIFIER ON
SET ARITHABORT ON
SET NUMERIC_ROUNDABORT OFF
SET CONCAT_NULL_YIELDS_NULL ON
SET ANSI_NULLS ON
SET ANSI_PADDING ON
SET ANSI_WARNINGS ON



update Profile_Mandatory set HeaderColumn_Ext='Phone_2' where FieldName='Phone_1'
update Profile_Mandatory set HeaderColumn_Ext='Mobile_2' where FieldName='Mobile_1'
update Profile_Mandatory set FieldName='TaxAddress',HeaderColumn='TaxAddress' where ControlName='LblTAXAdd'
update Profile_Mandatory set FieldName='Email_1', HeaderColumn='Email_1',HeaderColumn_Ext='Email_2' where ControlName='LblEmail'

update Profile_Mandatory set FieldName='PICName', HeaderColumn='PICName' where ControlName='LblPICName'
update Profile_Mandatory set FieldName='PICName', HeaderColumn='PICName' where ControlName='LblPICName2'
update Profile_Mandatory set FieldName='PICTitle', HeaderColumn='PICTitle' where ControlName='LblPICTitle'
update Profile_Mandatory set FieldName='PICPhone', HeaderColumn='PICPhone' where ControlName='LblPICPhone'
update Profile_Mandatory set FieldName='PICAddress', HeaderColumn='PICAddress' where ControlName='LblPICAddress'

update Profile_Mandatory set HeaderColumn_Ext='Tax' where FieldName='TAXType'

UPDATE Profile_Mandatory SET Message='First Name is required for Individual Profile !' WHERE ControlName='LblFirstName'
UPDATE Profile_Mandatory SET Message='Profile Name is required !' WHERE ControlName='LblName'
UPDATE Profile_Mandatory SET Message='Last Name Is required !' WHERE ControlName='LblLastName'
UPDATE Profile_Mandatory SET Message='Mid Name Is required !' WHERE ControlName='LblMidName'
UPDATE Profile_Mandatory SET Message='Telephone Number is required !' WHERE ControlName='LblPhone'
UPDATE Profile_Mandatory SET Message='Phone Number is required ! Mobile Phone Number must Contain Number Only (0..9) !' WHERE ControlName='LblMPhone'
update Profile_Mandatory set Message='TaxType is required !' where ControlName='LblTax'
update Profile_Mandatory set Message='Profile Address (line 2) is required !' where ControlName='LblAddress_2'
UPDATE Profile_Mandatory SET Message='Initial Profile Is required !' WHERE ControlName='LblInitial'
UPDATE Profile_Mandatory SET Message='Birth Place Is required For Individual Profile !' WHERE ControlName='LblBirthPlace'
UPDATE Profile_Mandatory SET Message='License Expiry is required !' WHERE ControlName='LblLicenseExpiry'
UPDATE Profile_Mandatory SET Message='Harmonization Code is required !' WHERE ControlName='LblHSCode'
UPDATE Profile_Mandatory SET Message='Harmonization Code is required !' WHERE ControlName='LbSICCode'
UPDATE Profile_Mandatory SET Message='BI Industrial Type is required !' WHERE ControlName='LblBIType'
UPDATE Profile_Mandatory SET Message='Purpose Of Insurance is required !' WHERE ControlName='LblPurpose'
UPDATE Profile_Mandatory SET Message='Salutation is required !' WHERE ControlName='LblSalutation'
UPDATE Profile_Mandatory SET Message='Address (line 3) is required !' WHERE ControlName='LblAddress_3'
UPDATE Profile_Mandatory SET Message='Passport No. is required For Foreign Citizen !' WHERE ControlName='LblPassPortNo'
UPDATE Profile_Mandatory SET Message='Personal ID Date is required !' WHERE ControlName='LblPIDDate'
UPDATE Profile_Mandatory SET Message='Religion is required for Non Corporate (Individual) Profile !' WHERE ControlName='LblReligion'
UPDATE Profile_Mandatory SET Message='Marital Status is required !' WHERE ControlName='LblMarital'
UPDATE Profile_Mandatory SET Message='Citizenship is required !' WHERE ControlName='LblCitizenShip'
UPDATE Profile_Mandatory SET Message='Employment is required for Non Corporate (Individual) Profile !' WHERE ControlName='LblEmployment'
UPDATE Profile_Mandatory SET Message='Annual Income is required for Non Corporate (Individual) Profile !' WHERE ControlName='LblIncome'
UPDATE Profile_Mandatory SET Message='Annual Income is required for Corporate Profile !' WHERE ControlName='LblIncome1'
UPDATE Profile_Mandatory SET Message='Source Of Income is required!' WHERE ControlName='LblIncomeSource'
UPDATE Profile_Mandatory SET Message='Income Source is required for Corporate Profile !' WHERE ControlName='lblIncomeSourceCorporate'
UPDATE Profile_Mandatory SET Message='COY Working Name is required !' WHERE ControlName='LblCOYName'
UPDATE Profile_Mandatory SET Message='COY Working Address is required !' WHERE ControlName='LblCOYAdd'
UPDATE Profile_Mandatory SET Message='Branch is required !' WHERE ControlName='LblBranch'
UPDATE Profile_Mandatory SET Message='Kabupaten/Kota is required !' WHERE ControlName='LblDistrict'
UPDATE Profile_Mandatory SET Message='Kecamatan is required !' WHERE ControlName='LblSubDistrict'
UPDATE Profile_Mandatory SET Message='Keluarahan/Desa is required !' WHERE ControlName='LblKelDesa' 
UPDATE Profile_Mandatory SET Message='Village is required !' WHERE ControlName='LblVillage' 
UPDATE Profile_Mandatory SET Message='RW is required !' WHERE ControlName='LblRW' 
UPDATE Profile_Mandatory SET Message='RT is required !' WHERE ControlName='LblRT' 
UPDATE Profile_Mandatory SET Message='Moo is required !' WHERE ControlName='LblMoo' 
UPDATE Profile_Mandatory SET Message='Soi is required !' WHERE ControlName='LblSoi' 
UPDATE Profile_Mandatory SET Message='TAX Holiday Period is invalid !' WHERE ControlName='LblTaxHoliday'
UPDATE Profile_Mandatory SET Message='VAT Exempted Period is invalid !' WHERE ControlName='LblVATPeriod'

UPDATE Profile_Mandatory SET Message='Country is required !' WHERE ControlName='LblCountryID'
UPDATE Profile_Mandatory SET Message='Province is required !' WHERE ControlName='LblProvinceID'
UPDATE Profile_Mandatory SET Message='City is required !' WHERE ControlName='LblCity'
UPDATE Profile_Mandatory SET Message='Area is required !' WHERE ControlName='LblAreaID'
UPDATE Profile_Mandatory SET Message='Zip Code is required !' WHERE ControlName='LblZipCode'
UPDATE Profile_Mandatory SET Message='Profile Address (line 1) is required !' WHERE ControlName='LblAddress_1'
UPDATE Profile_Mandatory SET Message='Mobile Phone Number is required ! Mobile Phone Number must Contain Number Only (0..9) !' WHERE ControlName='Mobile_1'
UPDATE Profile_Mandatory SET Message='Email Address is required !' WHERE ControlName='LblEmail'
UPDATE Profile_Mandatory SET Message='Profile Type is required !' WHERE ControlName='LblPType'
UPDATE Profile_Mandatory SET Message='Line of Business is required !' WHERE ControlName='LblLOB'
UPDATE Profile_Mandatory SET Message='Gender is required for Non Corporate (Individual) Profile !' WHERE ControlName='LblGender'
UPDATE Profile_Mandatory SET Message='Birth Date Is required For Individual Profile  Or Indonesian Citizen !' WHERE ControlName='LblBirthDate'
UPDATE Profile_Mandatory SET Message='ID Card Type is required !' WHERE ControlName='LblPIDType'
UPDATE Profile_Mandatory SET Message='Personal ID No. is required !' WHERE ControlName='LblPIDNo'
UPDATE Profile_Mandatory SET Message='Personal ID Name is required !' WHERE ControlName='LblPIDName'
UPDATE Profile_Mandatory SET Message='TAX ID is required !' WHERE ControlName='LblTaxID'
UPDATE Profile_Mandatory SET Message='TAX Name is required !' WHERE ControlName='LblTaxName'
UPDATE Profile_Mandatory SET Message='TAX Address is required !' WHERE ControlName='LblTAXAdd'
UPDATE Profile_Mandatory SET Message='License No. is required !' WHERE ControlName='LblLicenseNo'
UPDATE Profile_Mandatory SET Message='License Date is required !' WHERE ControlName='LblLicenseDate'
UPDATE Profile_Mandatory SET Message='Biz. License Date is required for Corporate Profile !' WHERE ControlName='LblBizLicenseDate'
UPDATE Profile_Mandatory SET Message='Biz. License No. is required for Corporate Profile !' WHERE ControlName='LblBizLicenseNo'
UPDATE Profile_Mandatory SET Message='Biz. License Place is required for Corporate Profile !' WHERE ControlName='LblBizLicensePlace'
UPDATE Profile_Mandatory SET Message='Mother''s Name is required !' WHERE ControlName='LblMothersName'
UPDATE Profile_Mandatory SET Message='PIC Name is required for Corporate Profile !' WHERE ControlName='LblPICName' 
UPDATE Profile_Mandatory SET Message='PIC Name is required for Individual Profile !' WHERE ControlName='LblPICName2' 
UPDATE Profile_Mandatory SET Message='PIC Title is required !' WHERE ControlName='LblPICTitle'
UPDATE Profile_Mandatory SET Message='Company Group is required !' WHERE ControlName='LblCGroupID'
UPDATE Profile_Mandatory SET Message='Company Type is required !' WHERE ControlName='LblCtype'
UPDATE Profile_Mandatory SET Message='PIC Phone is required !' WHERE ControlName='LblPICPhone'

insert into PatchVersioning
select '1419 Update Inisialisasi Message & HeaderColumn Profile Mandatory',GETDATE()
go	
  
Declare @PrevScript varchar(100)
Declare @CurrScript varchar(100)

Select @PrevScript=''
Select @CurrScript='1419 Update Inisialisasi Message & HeaderColumn Profile Mandatory'


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