--tuning upload
alter table sysbatchoriginalsc add
RefNO varchar(50)
go
alter table sysbatchsc add
RefNO varchar(50)
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

IF EXISTS(SELECT * FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS WHERE TABLE_NAME='SysBatchOriginalSC' AND CONSTRAINT_NAME='I_SysBatchoriginalsc')
begin
Alter Table SysBatchOriginalSC drop constraint I_SysBatchoriginalsc
end
GO
IF EXISTS(SELECT * FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS WHERE TABLE_NAME='SysBatchOriginalUP' AND CONSTRAINT_NAME='I_SysBatchoriginalUP')
begin
Alter Table SysBatchOriginalUP drop constraint I_SysBatchoriginalUP
end
GO
IF EXISTS(SELECT * FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS WHERE TABLE_NAME='SysBatchOriginalBE' AND CONSTRAINT_NAME='I_SysBatchoriginalBE')
begin
Alter Table SysBatchOriginalBE drop constraint I_SysBatchoriginalBE
end
GO
IF EXISTS(SELECT * FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS WHERE TABLE_NAME='SysBatchOriginalBC' AND CONSTRAINT_NAME='I_SysBatchoriginalBC')
begin
Alter Table SysBatchOriginalBC drop constraint I_SysBatchoriginalBC
end
GO

IF EXISTS(SELECT * FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS WHERE TABLE_NAME='SysBatchBC' AND CONSTRAINT_NAME='I_sysbatchBC')
begin
Alter Table SysBatchBC drop constraint I_sysbatchBC
end
GO
IF EXISTS(SELECT * FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS WHERE TABLE_NAME='SysBatchBE' AND CONSTRAINT_NAME='I_sysbatchBE')
begin
Alter Table SysBatchBE drop constraint I_sysbatchBE
end
GO
IF EXISTS(SELECT * FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS WHERE TABLE_NAME='SysBatchUP' AND CONSTRAINT_NAME='I_sysbatchup')
begin
Alter Table SysBatchUP drop constraint I_sysbatchup
end
GO
IF EXISTS(SELECT * FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS WHERE TABLE_NAME='SysBatchSC' AND CONSTRAINT_NAME='I_SysBatchSC')
begin
Alter Table SysBatchSC drop constraint I_SysBatchSC
end
GO

IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].FK_SysBatchOriginalBC_SysBatchH') AND parent_object_id = OBJECT_ID(N'[dbo].SysBatchOriginalBC'))
begin
Alter Table SysBatchOriginalBC drop constraint FK_SysBatchOriginalBC_SysBatchH
end
GO

IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].FK_SysBatchOriginalBE_SysBatchH') AND parent_object_id = OBJECT_ID(N'[dbo].SysBatchOriginalBE'))
begin
Alter Table SysBatchOriginalBE drop constraint FK_SysBatchOriginalBE_SysBatchH
end
GO

IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].FK_SysBatchOriginalSC_SysBatchH') AND parent_object_id = OBJECT_ID(N'[dbo].SysBatchOriginalSC'))
begin
Alter Table SysBatchOriginalSC drop constraint FK_SysBatchOriginalSC_SysBatchH
end
GO

IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].FK_SysBatchOriginalUP_SysBatchH') AND parent_object_id = OBJECT_ID(N'[dbo].SysBatchOriginalUP'))
begin
Alter Table SysBatchOriginalUP drop constraint FK_SysBatchOriginalUP_SysBatchH
end
GO

IF Not EXISTS (SELECT *  FROM sys.indexes WHERE name='I_SysBatchSC' AND object_id = OBJECT_ID('SysBatchSC'))
BEGIN
Create Unique Index I_SysBatchSC on SysBatchSC(BID)
end
GO
IF Not EXISTS (SELECT *  FROM sys.indexes WHERE name='I_SysBatchUP' AND object_id = OBJECT_ID('SysBatchUP'))
BEGIN
Create Unique Index I_SysBatchUP on SysBatchUP(BID)
end
GO
IF Not EXISTS (SELECT *  FROM sys.indexes WHERE name='I_SysBatchBE' AND object_id = OBJECT_ID('SysBatchBE'))
BEGIN
Create Unique Index I_SysBatchBE on SysBatchBE(BID)
end
GO
IF Not EXISTS (SELECT *  FROM sys.indexes WHERE name='I_SysBatchBC' AND object_id = OBJECT_ID('SysBatchBC'))
BEGIN
Create Unique Index I_SysBatchBC on SysBatchBC(BID)
end
GO
IF Not EXISTS (SELECT *  FROM sys.indexes WHERE name='I_SysBatchOriginalSC' AND object_id = OBJECT_ID('I_SysBatchOriginalSC'))
BEGIN
Create Unique Index I_SysBatchOriginalSC on SysBatchOriginalSC(BID)
end
GO
IF Not EXISTS (SELECT *  FROM sys.indexes WHERE name='I_SysBatchOriginalUP' AND object_id = OBJECT_ID('SysBatchOriginalUP'))
BEGIN
Create Unique Index I_SysBatchOriginalUP on SysBatchOriginalUP(BID)
end
GO
IF Not EXISTS (SELECT *  FROM sys.indexes WHERE name='I_SysBatchOriginalBE' AND object_id = OBJECT_ID('SysBatchOriginalBE'))
BEGIN
Create Unique Index I_SysBatchOriginalBE on SysBatchOriginalBE(BID)
end
GO
IF Not EXISTS (SELECT *  FROM sys.indexes WHERE name='I_SysBatchOriginalBC' AND object_id = OBJECT_ID('SysBatchOriginalBC'))
BEGIN
Create Unique Index I_SysBatchOriginalBC on SysBatchOriginalBC(BID)
end
GO
