SET QUOTED_IDENTIFIER ON
SET ARITHABORT ON
SET NUMERIC_ROUNDABORT OFF
SET CONCAT_NULL_YIELDS_NULL ON
SET ANSI_NULLS ON
SET ANSI_PADDING ON
SET ANSI_WARNINGS ON

--Intermediaries Individual
INSERT INTO [dbo].[Profile_Mandatory]
           ([CorporateF]
		   ,[IndividualF]
		   ,[IntermediaryF]
		   ,[PanelName] 
           ,[ControlName]
           ,[Description]
		   ,[FieldName]
		   ,[MaxLen]
		   ,[MaxLen_Ext]
		   ,[MaxLen_Ext_1]
		   )
     VALUES
		(0,1,1,'PnlHeader','LblName','Full Name','Name',0,0,0),
		(0,1,1,'PnlHeader','LblCountryID','Country','Country',0,0,0),
		(0,1,1,'PnlHeader','LblProvinceID','Province','Province',0,0,0),
		(0,1,1,'PnlHeader','LblZipCode','ZipCode','ZipCode',0,0,0),
		(0,1,1,'PnlHeader','LblCity','City','City',0,0,0),
		(0,1,1,'PnlHeader','LblAreaID','Area','Area',0,0,0),
		(0,1,1,'PnlHeader','LblAddress_1','Address_1','Address_1',0,0,0),
		(0,1,1,'PnlHeader','LblMPhone','Mobile Phone','Mobile_1',10,13,0),
		(0,1,1,'PnlHeader','LblEmail','Email_1','Email_1',0,0,0),
		(0,1,1,'PnlHeader','LblPType','Profile Type','PType',0,0,0),
		(0,1,1,'PnlHeader','LblLOB','Line Of Business Individual','LOB',0,0,0),
		(0,1,1,'PnlPersonalInfo','LblGender','Gender Individual','Gender',0,0,0),
		(0,1,1,'PnlPersonalInfo','LblBirthDate','Birth Date Individual','BirthDate',0,0,0),
		(0,1,1,'PnlPersonalInfo','LblPIDType','ID Card Type Individual','ID_Type',0,0,0),
		(0,1,1,'PnlPersonalInfo','LblPIDNo','Personal ID No Individual','ID_No',0,0,0),
		(0,1,1,'PnlPersonalInfo','LblPIDName','Personal ID Name Individual','ID_Name',0,0,0),
		(0,1,1,'PnlTax','LblTax','Tax Type','TAXType',0,0,0),
		(0,1,1,'PnlTax','LblTaxID','Tax ID','TAXID',16,16,0),
		(0,1,1,'PnlTax','LblTAXName','Tax Name','TAXName',0,0,0),
		(0,1,1,'PnlTax','LblTAXAdd','Tax Address','TAXAdd',0,0,0),
		(0,1,1,'PnlBizRelated','LblLicenseNo','License No','LicenseNo',0,0,0),
		(0,1,1,'PnlBizRelated','LblLicenseDate','License Date','LicenseDate',0,0,0),
		(0,1,1,'PnlBizRelated','LblLicenseNo','License No','LicenseNo',0,0,0)
GO

insert into PatchVersioning
select '1388 Update Script Profile Mandatory 23 Jul 2025 - Inisialisasi Setup',GETDATE()
go	
  
Declare @PrevScript varchar(100)
Declare @CurrScript varchar(100)

Select @PrevScript=''
Select @CurrSCript='1388 Update Script Profile Mandatory 23 Jul 2025 - Inisialisasi Setup'


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