drop view ICPS_PROFILE
go

Alter Table SysBatchUp Alter Column Email varchar(512) 
GO

Alter Table Profile Alter Column Email varchar(512) 
GO

Alter Table Profile Alter Column Email_2 varchar(512) 
GO

Alter Table RenewalDA Alter Column Email varchar(512) 
GO

Alter Table SysUser Alter Column EMail varchar(512) 
GO

Alter Table AccCA Alter Column Email varchar(512) 
GO

Alter Table AccDA Alter Column Email varchar(512) 
GO

Alter Table SAccCA Alter Column Email varchar(512) 
GO

Alter Table SAccDA Alter Column Email varchar(512) 
GO

Alter Table AdmLink Alter Column Email varchar(512) 
GO

Alter Table Scheme_CA Alter Column Email varchar(512) 
GO

Alter Table Scheme_Transaction Alter Column Email varchar(512) 
GO

Alter Table OneCardD Alter Column Email varchar(512) 
GO

Alter Table SysBatchOriginalSC Alter Column Email varchar(512) 
GO

Alter Table tScheme_CA Alter Column Email varchar(512) 
GO

Alter Table PAlias Alter Column Email varchar(512) 
GO

Alter Table SysBatchSC Alter Column Email varchar(512) 
GO

Alter Table tScheme_Transaction Alter Column Email varchar(512) 
GO

Alter Table SysBatchOriginalUp Alter Column Email varchar(512) 
GO

Alter Table Branch Alter Column Email varchar(512) 
GO

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
select '640 Update Script - Patch 2023 (45)',GETDATE()
go





Declare @PrevScript varchar(100)
Declare @CurrScript varchar(100)

Select @PrevScript=''
Select @CurrSCript='640 Update Script - Patch 2023 (45)'


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
