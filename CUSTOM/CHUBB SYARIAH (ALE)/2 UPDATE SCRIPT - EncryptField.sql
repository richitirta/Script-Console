ALTER TABLE EncryptField ADD FieldType VARCHAR(1) NULL
GO

UPDATE EncryptField SET FieldType = '' WHERE FieldType IS NULL
GO

alter table EncryptField drop column Applyalwaysencryptf
go

drop view icps_profile
go

alter table profile_EXT alter column ID_No varchar(2000)
go
alter table profile_EXT alter column ID_Type varchar(2000)
go
alter table profile_ext alter column Birthdate varchar(2000)
go
alter table profile_ext alter column PassPortNo varchar(2000)
go
alter table profile_ext alter column MothersName varchar(2000)
go
alter table profile_ext alter column Gender varchar(2000)
go
alter table profile alter column TaxID varchar(2000)
go
alter table profile alter column TaxIDOLD varchar(2000)
go
alter table profile alter column email varchar(2000)
go
alter table profile alter column email_2 varchar(2000)
go
alter table profile alter column USERID varchar(2000)
go

alter table proacc alter column AccountNo varchar(2000)
go

alter table proacc alter column bankaccount varchar(2000)
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
select '1194 UPDATE SCRIPT - EncryptField',GETDATE()
go	
  
Declare @PrevScript varchar(100)
Declare @CurrScript varchar(100)

Select @PrevScript=''
Select @CurrSCript='1194 UPDATE SCRIPT - EncryptField'


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

