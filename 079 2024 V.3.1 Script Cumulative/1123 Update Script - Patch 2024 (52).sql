
drop VIEW ICPS_LOCATION
go


drop view ICPS_PROFILE
go

Alter Table Profile Alter COlumn Address_1 Varchar(1024) 
go
Alter Table Profile Alter COlumn Address_2 Varchar(1024) 
go
Alter Table Profile Alter COlumn Address_3 Varchar(1024) 
go
Alter Table RenewalDA Alter COlumn Address Varchar(1024)
go 
Alter Table Scheme_Beneficiary Alter COlumn Address_1 Varchar(1024) 
go
Alter Table Scheme_Beneficiary Alter COlumn Address_2 Varchar(1024) 
go
Alter Table Scheme_Payor Alter COlumn ADDRESS_1 Varchar(1024) 
go
Alter Table Scheme_Payor Alter COlumn ADDRESS_2 Varchar(1024)
go 
Alter Table Scheme_Payor Alter COlumn ADDRESS_3 Varchar(1024) 
go
Alter Table Location Alter COlumn Address_1 Varchar(1024) 
go
Alter Table Location Alter COlumn Address_2 Varchar(1024) 
go
Alter Table Location Alter COlumn Address_3 Varchar(1024) 
go
Alter Table BankBranch Alter COlumn Address_1 Varchar(1024) 
go
Alter Table BankBranch Alter COlumn Address_2 Varchar(1024)
go 
Alter Table BankBranch Alter COlumn Address_3 Varchar(1024) 
go
Alter Table Profile_Ref Alter COlumn Address Varchar(1024) 
go
Alter Table SCHEME_INPARTY Alter COlumn Address_1 Varchar(1024) 
go
Alter Table SCHEME_INPARTY Alter COlumn Address_2 Varchar(1024) 
go
Alter Table AccCA Alter COlumn Address Varchar(1024) 
go
Alter Table Cheque Alter COlumn Address Varchar(1024) 
go
Alter Table AccDA Alter COlumn Address Varchar(1024) 
go
Alter Table CLSub Alter COlumn Address_1 Varchar(1024)
go 
Alter Table CLSub Alter COlumn Address_2 Varchar(1024) 
go
Alter Table CLSub Alter COlumn Address_3 Varchar(1024) 
go
Alter Table Beneficiaries Alter COlumn Address_1 Varchar(1024) 
go
Alter Table Beneficiaries Alter COlumn Address_2 Varchar(1024) 
go
Alter Table SAccCA Alter COlumn Address Varchar(1024) 
go
Alter Table SAccDA Alter COlumn Address Varchar(1024) 
go
Alter Table SPayor Alter COlumn ADDRESS_1 Varchar(1024) 
go
Alter Table SPayor Alter COlumn ADDRESS_2 Varchar(1024)
go 
Alter Table SPayor Alter COlumn ADDRESS_3 Varchar(1024)
go 
Alter Table Service Alter COlumn Address_1 Varchar(1024) 
go
Alter Table Service Alter COlumn Address_2 Varchar(1024) 
go
--Alter Table Service Alter COlumn Address_3 Varchar(1024) 
--go
Alter Table Scheme_CA Alter COlumn Address Varchar(1024)
go 
Alter Table INPARTY Alter COlumn Address_1 Varchar(1024) 
go
Alter Table INPARTY Alter COlumn Address_2 Varchar(1024) 
go
Alter Table Scheme_Transaction Alter COlumn Address Varchar(1024) 
go
Alter Table OneCardD Alter COlumn Address Varchar(1024) 
go
Alter Table PAlias Alter COlumn Address Varchar(1024) 
go
Alter Table PAYOR Alter COlumn ADDRESS_1 Varchar(1024) 
go
Alter Table PAYOR Alter COlumn ADDRESS_2 Varchar(1024) 
go
Alter Table PAYOR Alter COlumn ADDRESS_3 Varchar(1024) 
go
Alter Table APayor Alter COlumn ADDRESS_1 Varchar(1024) 
go
Alter Table APayor Alter COlumn ADDRESS_2 Varchar(1024) 
go
Alter Table APayor Alter COlumn ADDRESS_3 Varchar(1024)
go 
Alter Table Branch Alter COlumn Address Varchar(1024) 
GO

CREATE VIEW ICPS_LOCATION

WITH SCHEMABINDING

AS

SELECT LOCATION, NAME, ADDRESS_1, ADDRESS_2, ADDRESS_3, ZIPCODE, CITY, COUNTRY, REMARKS, LAST_OPR, LAST_UPDATE 

FROM dbo.LOCATION WHERE ALLOWEDF=1

AND ICPSF=1
go


CREATE VIEW [ICPS_PROFILE]       

WITH SCHEMABINDING      

AS        

SELECT Case When LOB='13' then 'RepairShop' else 'Supplier' end as RefSource, ID, SALUTATION, FIRSTNAME, MIDNAME, LASTNAME, LOB,     

NAME, INITIAL, ADDRESS_1, ADDRESS_2, ADDRESS_3, CITY, ZIPCODE, PHONE_1, PHONE_2, MOBILE_1, MOBILE_2, FAX_1, FAX_2, EMAIL, EMAIL_2,       

CONTACT, CONTACTADDRESS, CONTACTPHONE, TITLE,       

TAXID, TAXNAME, TAXADDRESS, VATF, TAXF, TAXTYPE, VAT, TAX, TAXPCT, LAST_OPR, LAST_UPDATE     

FROM dbo.PROFILE      

WHERE LOB IN ('13', '14')   
go


  insert into PatchVersioning
select '1123 Update Script - Patch 2024 (52)',GETDATE()
go
  
Declare @PrevScript varchar(100)
Declare @CurrScript varchar(100)

Select @PrevScript=''
Select @CurrSCript='1123 Update Script - Patch 2024 (52)'


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




go



