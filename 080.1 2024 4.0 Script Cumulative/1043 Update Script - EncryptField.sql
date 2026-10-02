ALTER TABLE EncryptField ADD FieldType VARCHAR(1) NULL
GO

ALTER TABLE EncryptField DROP COLUMN ApplyAlwaysEncryptF
GO

--SELECT * FROM EncryptField WHERE FormName = 'PROFILEDLG' and encryptf = 1
--GO
--SELECT * FROM EncryptField WHERE FormName = 'PACCDLG'
--GO
insert into [EncryptField]
select max(encryptid)+1,'PROFILEDLG','TxtBirthDate','BirthDate','','*',0,0,0,GETDATE(),'CARE','S' from EncryptField
GO
insert into [EncryptField]
select max(encryptid)+1,'PROFILEDLG','TxtPIDNo','ID_NO','','*',0,0,0,GETDATE(),'CARE','S' from EncryptField
GO
insert into [EncryptField]
select max(encryptid)+1,'PROFILEDLG','LstPIDType','ID_Type','','*',0,0,0,GETDATE(),'CARE','S' from EncryptField
GO

insert into [EncryptField]
select max(encryptid)+1,'PROFILEDLG','TxtTAXID','TaxID','','*',0,0,0,GETDATE(),'CARE','S' from EncryptField
GO

insert into [EncryptField]
select max(encryptid)+1,'PROFILEDLG','TxtPassportNo','PassPortNo','','*',0,0,0,GETDATE(),'CARE','S' from EncryptField
GO

insert into [EncryptField]
select max(encryptid)+1,'PROFILEDLG','LblCreatedBy','UserID','','*',0,0,0,GETDATE(),'CARE','S' from EncryptField
GO

insert into [EncryptField]
select max(encryptid)+1,'PROFILEDLG','TxtMothersName','MothersName','','*',0,0,0,GETDATE(),'CARE','S' from EncryptField
GO

insert into [EncryptField]
select max(encryptid)+1,'PROFILEDLG','LblAccountNo','AccountNo','','*',0,0,0,GETDATE(),'CARE','S' from EncryptField
GO

insert into [EncryptField]
select max(encryptid)+1,'PROFILEDLG','LblBankAccount','BankAccount','','*',0,0,0,GETDATE(),'CARE','S' from EncryptField
GO

insert into [EncryptField]
select max(encryptid)+1,'PAccDlg','TxtBankAccNo','AccountNo','ACCOUNTNO','*',0,0,0,GETDATE(),'CARE','S' from EncryptField
GO

insert into [EncryptField]
select max(encryptid)+1,'PAccDlg','TxtBankAccName','BankAccount','ACCOUNTNO','*',0,0,0,GETDATE(),'CARE','S' from EncryptField
GO

insert into [EncryptField]
select max(encryptid)+1,'PROFILEDLG','TxtCity','City','','*',0,0,0,GETDATE(),'CARE','S' from EncryptField
GO


insert into [EncryptField]
select max(encryptid)+1,'PROFILEDLG','TxtCountry','Country','','*',0,0,0,GETDATE(),'CARE','S' from EncryptField
GO


insert into [EncryptField]
select max(encryptid)+1,'PROFILEDLG','TxtAddress_1','Address_1','','*',0,0,0,GETDATE(),'CARE','S' from EncryptField
GO

insert into [EncryptField]
select max(encryptid)+1,'PROFILEDLG','TxtAddress_2','Address_2','','*',0,0,0,GETDATE(),'CARE','S' from EncryptField
GO

insert into [EncryptField]
select max(encryptid)+1,'PROFILEDLG','TxtAddress_3','Address_3','','*',0,0,0,GETDATE(),'CARE','S' from EncryptField
GO


insert into [EncryptField]
select max(encryptid)+1,'PROFILEDLG','TxtProvinceID','Province','','*',0,0,0,GETDATE(),'CARE','S' from EncryptField
GO


insert into [EncryptField]
select max(encryptid)+1,'PROFILEDLG','LstIncomeCorporate','Income','','*',0,0,0,GETDATE(),'CARE','S' from EncryptField
GO


insert into [EncryptField]
select max(encryptid)+1,'PROFILEDLG','LstIncome','Income','','*',0,0,0,GETDATE(),'CARE','S' from EncryptField
GO


insert into [EncryptField]
select max(encryptid)+1,'PROFILEDLG','LstGender','Gender','','*',0,0,0,GETDATE(),'CARE','S' from EncryptField
GO



insert into [EncryptField]
select max(encryptid)+1,'PROFILEDLG','TxtBirthPlace','BirthPlace','','*',0,0,0,GETDATE(),'CARE','S' from EncryptField
GO



insert into [EncryptField]
select max(encryptid)+1,'PROFILEDLG','lstMarital','Marital','','*',0,0,0,GETDATE(),'CARE','S' from EncryptField
GO


insert into [EncryptField]
select max(encryptid)+1,'PROFILEDLG','TxtPhone_1','Phone_1','','*',0,0,0,GETDATE(),'CARE','S' from EncryptField
GO


insert into [EncryptField]
select max(encryptid)+1,'PROFILEDLG','TxtPhone_2','Phone_2','','*',0,0,0,GETDATE(),'CARE','S' from EncryptField
GO


insert into [EncryptField]
select max(encryptid)+1,'PROFILEDLG','TxtMPhone_1','Mobile_1','','*',0,0,0,GETDATE(),'CARE','S' from EncryptField
GO


insert into [EncryptField]
select max(encryptid)+1,'PROFILEDLG','TxtMPhone_2','Mobile_2','','*',0,0,0,GETDATE(),'CARE','S' from EncryptField
GO


insert into [EncryptField]
select max(encryptid)+1,'PROFILEDLG','TxtFax_1','Fax_1','','*',0,0,0,GETDATE(),'CARE','S' from EncryptField
GO


insert into [EncryptField]
select max(encryptid)+1,'PROFILEDLG','TxtFax_2','Fax_2','','*',0,0,0,GETDATE(),'CARE','S' from EncryptField
GO


insert into [EncryptField]
select max(encryptid)+1,'PAccDlg','TxtBankCode','Bank','','*',0,0,0,GETDATE(),'CARE','S' from EncryptField
GO


UPDATE EncryptField SET FieldType = '' WHERE FieldType IS NULL
GO



 update encryptfield set fieldtype = 'S'  where formname = 'profiledlg' and fieldname in
 ('email','email_2')
 go

   update encryptfield set fieldtype = 'S' where formname = 'profiledlg' and fieldname in
 ('Gender', 'BirthDate', 'ID_Type', 'ID_No')
 go


 

insert into PatchVersioning
select '1043 Update Script - EncryptField',GETDATE()
go
	

Declare @PrevScript varchar(100)
Declare @CurrScript varchar(100)

Select @PrevScript=''
Select @CurrSCript='1043 Update Script - EncryptField'


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