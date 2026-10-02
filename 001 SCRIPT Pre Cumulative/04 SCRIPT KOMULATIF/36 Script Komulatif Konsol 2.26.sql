

 IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'TOPROF' AND Object_ID = Object_ID(N'ICover'))
BEGIN
 Alter Table ICover Add TOPROF bit
end
go
Update ICover Set TOPROF=0 Where TOPROF IS NULL
GO
 IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'TOPROF' AND Object_ID = Object_ID(N'RCover'))
BEGIN
Alter Table RCover Add TOPROF bit
end
go
Update RCover Set TOPROF=0 Where TOPROF IS NULL
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
alter table sysbatchoriginalsc add
refno varchar(50)
go
alter table sysbatchsc add
refno varchar(50)
go
 IF Not EXISTS (SELECT Name FROM sysindexes WHERE Name = 'I_SysBatchUp_BatchNo_RefNo') 
BEGIN
Create Index I_SysBatchUp_BatchNo_RefNo on SysBatchUp(BatchNo, RefNo)
end
GO

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


Update AccAss Set CodeExt='' Where CodeExt is null
go

update SysRequest set duedate=GETDATE() where duedate is null
go

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
