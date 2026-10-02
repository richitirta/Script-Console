IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'GoPublicF' AND Object_ID = Object_ID(N'profile_ext'))

BEGIN
alter table profile_ext add GoPublicF bit
End
Go

IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'PropertySeparationF' AND Object_ID = Object_ID(N'profile_ext'))

BEGIN
alter table profile_ext add PropertySeparationF bit
END
GO

IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'BOD_Village_1' AND Object_ID = Object_ID(N'profile_ext'))

BEGIN
alter table profile_ext add BOD_Village_1 varchar(50)
END
GO

IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'BOD_Village_2' AND Object_ID = Object_ID(N'profile_ext'))

BEGIN
alter table profile_ext add BOD_Village_2 varchar(50)
END
GO

IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'BOD_Village_3' AND Object_ID = Object_ID(N'profile_ext'))

BEGIN
alter table profile_ext add BOD_Village_3 varchar(50)
END
GO


drop view vProfile_Ext
go
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
	--,Profile.Rating_Agency
	--,Profile.Rating_Date
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
	,Profile.BOD_Village_1
	,Profile.BOD_Village_2
	,Profile.BOD_Village_3
	,Profile.BOD_District_1
	,Profile.BOD_District_2
	,Profile.BOD_District_3
	,Profile.BOD_City_1
	,Profile.BOD_City_2
	,Profile.BOD_City_3
	,Profile.Own_Share
	,Profile.Own_Status
	,Profile.GoPublicF
	,Profile.PropertySeparationF
from dbo.Profile_Ext Profile
Inner Join dbo.SysTab SysTab on (1=1)
go


insert into PatchVersioning
select '1554 Update Script - profile_ext 02 maret 2026.sql',GETDATE()
go	
  
Declare @PrevScript varchar(100)
Declare @CurrScript varchar(100)

Select @PrevScript=''
Select @CurrSCript='1554 Update Script - profile_ext 02 maret 2026.sql'


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
  
  