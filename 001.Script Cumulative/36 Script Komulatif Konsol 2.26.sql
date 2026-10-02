

 IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'TOPROF' AND Object_ID = Object_ID(N'ICover'))
BEGIN
 Alter Table ICover Add TOPROF bit
end
go

 IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'TOPROF' AND Object_ID = Object_ID(N'RCover'))
BEGIN
Alter Table RCover Add TOPROF bit
end
go


 IF Not EXISTS (SELECT Name FROM sysindexes WHERE Name = 'I_ACCCNC_ANO_CNCTYPE_CNCISSUEDDATE') 
BEGIN
Create Unique INdex I_ACCCNC_ANO_CNCTYPE_CNCISSUEDDATE on ACCCNC(ANO, CNCTYPE, CNCISSUEDDATE)
end
go

IF NOT EXISTS(SELECT * FROM sysform WHERE Fname='ACCCNCDlg')
BEGIN
insert into sysform
select 'ACCCNCDlg','Certificate Of No Claim','GENERAL',0
end
go

--8 des 2017
 IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'refno' AND Object_ID = Object_ID(N'sysbatchoriginalsc'))
BEGIN
alter table sysbatchoriginalsc add
refno varchar(50)
END
go
 IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'refno' AND Object_ID = Object_ID(N'sysbatchsc'))
BEGIN
alter table sysbatchsc add
refno varchar(50)
END
go


 IF Not EXISTS (SELECT Name FROM sysindexes WHERE Name = 'I_SysBatchSC_BatchNo_RefNo') 
BEGIN
Create Index I_SysBatchSC_BatchNo_RefNo on SysBatchSC(BatchNo, RefNo)
end
GO

 IF Not EXISTS (SELECT Name FROM sysindexes WHERE Name = 'I_Acceptance_BatchNo_RefNo') 
BEGIN
Create Index I_Acceptance_BatchNo_RefNo on Acceptance(BatchNo, RefNo)
end
GO

 IF Not EXISTS (SELECT Name FROM sysindexes WHERE Name = 'I_Scheme_Transaction_BatchNo_ContractNo') 
BEGIN
Create Index I_Scheme_Transaction_BatchNo_ContractNo on Scheme_Transaction(BatchNo, ContractNo)
end
GO

 IF EXISTS (SELECT Name FROM sysindexes WHERE Name = 'I_Acceptance_LUserID') 
BEGIN
drop index Acceptance.I_Acceptance_LUserID
end
GO
 IF EXISTS (SELECT Name FROM sysindexes WHERE Name = 'I_Acceptance_EDate') 
BEGIN
drop index Acceptance.I_Acceptance_EDate
end
GO
 IF EXISTS (SELECT Name FROM sysindexes WHERE Name = 'I_Acceptance_AName') 
BEGIN
drop index Acceptance.I_Acceptance_AName
end
GO
 IF EXISTS (SELECT Name FROM sysindexes WHERE Name = 'I_Acceptance_AID') 
BEGIN
drop index Acceptance.I_Acceptance_AID
end
GO
 IF EXISTS (SELECT Name FROM sysindexes WHERE Name = 'i_ACCEPTANCE_Branch') 
BEGIN
drop index Acceptance.i_ACCEPTANCE_Branch
end
GO
 IF EXISTS (SELECT Name FROM sysindexes WHERE Name = 'I_Claim_ADate') 
BEGIN
drop index Claim.I_Claim_ADate
end
GO
 IF EXISTS (SELECT Name FROM sysindexes WHERE Name = 'I_Claim_Branch') 
BEGIN
drop index Claim.I_Claim_Branch
end
GO
 IF EXISTS (SELECT Name FROM sysindexes WHERE Name = 'I_Claim_TOC') 
BEGIN
drop index Claim.I_Claim_TOC
end
GO



--encrypt pada Bank Account No, ID NO, NPWP
IF NOT EXISTS(SELECT * FROM sysform WHERE Fname='ALLOWDECRYPTDATA')
BEGIN
Insert Into SysForm values ('ALLOWDECRYPTDATA','Allow Decrypt Data','ACTIVITIES',0)
end
go

IF NOT EXISTS(SELECT * FROM sysform WHERE Fname='ALLOWVIEWENCRYPTFIELD')
BEGIN
insert into Sysform(FName, Description, FCode)
Select 'ALLOWVIEWENCRYPTFIELD','ALLOW VIEW ENCRYPTED FIELD','ACTIVITIES'
end
go



--VERSIONING
insert into versioning
select '2017 V.2.26.0',GETDATE(),'2017 V.2.0.0',GETDATE(),'K: 2017 V.2.0.0',GETDATE()
go


Declare @PrevScript varchar(100)
Declare @CurrScript varchar(100)

Select @PrevScript='35.01 Update Script Multibase Ccy (Execute Before Kom 2.26)'
Select @CurrSCript='36 Script Komulatif Konsol 2.26'


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


