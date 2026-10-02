Alter Table CLAIM Alter Column CT varchar(20)
GO
Alter Table SysBatchUp Alter Column CT varchar(20)
GO
IF EXISTS(SELECT * FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS WHERE TABLE_NAME='PettyCashD' AND CONSTRAINT_NAME='I_PettyCashD')
Begin
alter table PettyCashD drop constraint I_PettyCashD
end
GO
Alter Table PettyCashD Alter Column CT varchar(20)
GO
IF not EXISTS (SELECT * FROM sys.indexes WHERE name='I_PettyCashD' AND object_id = OBJECT_ID(N'PettyCashD'))
Begin
Create Unique index I_PettyCashD on PettyCashD(PettyCash, Account, Branch, CT, DocNo)
end
GO
Alter Table RPBucket Alter Column CT varchar(20)
GO
Alter Table nVoucher Alter Column CT varchar(20)
GO
Alter Table vType Alter Column CT varchar(20)
GO
Alter Table LinkExcel Alter Column CT varchar(20)
GO
Alter Table SysUser Alter Column CT varchar(20)
GO
IF EXISTS(SELECT * FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS WHERE TABLE_NAME='Journal_Account' AND CONSTRAINT_NAME='I_Journal_Account')
Begin
alter table Journal_Account Drop constraint I_Journal_Account
end
GO
Alter Table Journal_Account Alter Column CT varchar(20)
GO
IF not EXISTS (SELECT * FROM sys.indexes WHERE name='I_Journal_Account' AND object_id = OBJECT_ID(N'Journal_Account'))
Begin
Create Unique index I_Journal_Account on Journal_Account(Source, Account, Currency, CT)
end
GO
Alter Table mVoucher Alter Column CT varchar(20)
GO
Alter Table mSL Alter Column CT varchar(20)
GO
Alter Table mJournal Alter Column CT varchar(20)
GO
Alter Table AmortizationD Alter Column CT varchar(20)
GO
Alter Table nSL Alter Column CT varchar(20)
GO
Alter Table AmortizationH Alter Column CT varchar(20)
GO
Alter Table PettyCashH Alter Column CT varchar(20)
GO
Alter Table APBucket Alter Column CT varchar(20)
GO
Alter Table Request Alter Column CT varchar(20)
GO
Alter Table SL_Request Alter Column CT varchar(20)
GO
Alter Table pVoucher Alter Column CT varchar(20)
GO
Alter Table AdmLink Alter Column CT varchar(20)
GO
Alter Table Service Alter Column CT varchar(20)
GO
Alter Table CSTALLOCATIOND Alter Column CT varchar(20)
GO
Alter Table ARBucket Alter Column CT varchar(20)
GO
Alter Table Scheme_Transaction Alter Column CT varchar(20)
GO
Alter Table SysBatchOriginalSC Alter Column CT varchar(20)
GO
Alter Table PCSummary Alter Column CT varchar(20)
GO
Alter Table nJournal Alter Column CT varchar(20)
GO
Alter Table pSL Alter Column CT varchar(20)
GO
Alter Table SysBatchSC Alter Column CT varchar(20)
GO
Alter Table pJournal Alter Column CT varchar(20)
GO
Alter Table SysBatchOriginalUp Alter Column CT varchar(20)
GO
Alter Table ACCLINK Alter Column CT varchar(20)
GO
Alter Table ACCEPTANCE Alter Column CT varchar(20)
GO
IF EXISTS(SELECT * FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS WHERE TABLE_NAME='BAssumption_Growth' AND CONSTRAINT_NAME='I_BAssumption_Growth')
Begin
alter table BAssumption_Growth drop constraint I_BAssumption_Growth
end
GO
IF EXISTS(SELECT * FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS WHERE TABLE_NAME='BAssumption_Growth' AND CONSTRAINT_NAME='FK_BAssumption_Growth_CT')
Begin
alter table BAssumption_Growth drop constraint FK_BAssumption_Growth_CT
end
GO
Alter Table BAssumption_Growth Alter Column CT varchar(20) Not Null
GO
IF not EXISTS(SELECT * FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS WHERE TABLE_NAME='BAssumption_Growth' AND CONSTRAINT_NAME='I_BAssumption_Growth')
Begin
Alter Table BAssumption_Growth add constraint I_BAssumption_Growth Primary Key (Year, CT, ID)
end
GO
alter table BAssumption_Rate drop constraint I_BAssumption_Rate
GO
IF EXISTS(SELECT * FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS WHERE TABLE_NAME='BAssumption_Rate' AND CONSTRAINT_NAME='FK_BAssumption_Rate_CT')
Begin
alter table BAssumption_Rate drop constraint FK_BAssumption_Rate_CT
end
GO
Alter Table BAssumption_Rate Alter Column CT varchar(20) Not Null
GO
IF not EXISTS(SELECT * FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS WHERE TABLE_NAME='BAssumption_Rate' AND CONSTRAINT_NAME='I_BAssumption_Rate')
Begin
Alter Table BAssumption_Rate add constraint I_BAssumption_Rate Primary Key (Year, CT, ID)
end
GO
IF EXISTS(SELECT * FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS WHERE TABLE_NAME='Budget_Activity' AND CONSTRAINT_NAME='I_Budget_Activity')
Begin
alter table Budget_Activity drop constraint I_Budget_Activity
end
GO
IF EXISTS(SELECT * FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS WHERE TABLE_NAME='Budget_Activity' AND CONSTRAINT_NAME='FK_Budget_Activity_CT')
Begin
alter table Budget_Activity drop constraint FK_Budget_Activity_CT
end
GO
Alter Table Budget_Activity Alter Column CT varchar(20) Not Null
GO
IF not EXISTS(SELECT * FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS WHERE TABLE_NAME='Budget_Activity' AND CONSTRAINT_NAME='I_Budget_Activity')
Begin
alter table Budget_Activity add constraint I_Budget_Activity Primary Key (CT, GID)
end
GO
IF EXISTS(SELECT * FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS WHERE TABLE_NAME='Budget_Center' AND CONSTRAINT_NAME='I_Budget_Center')
Begin
alter table Budget_Center drop constraint I_Budget_Center
end
GO
IF EXISTS(SELECT * FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS WHERE TABLE_NAME='Budget_Center' AND CONSTRAINT_NAME='FK_Budget_Center_CT')
Begin
alter table Budget_Center drop constraint FK_Budget_Center_CT
end
GO
Alter Table Budget_Center Alter Column CT varchar(20) Not Null
GO
IF not EXISTS(SELECT * FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS WHERE TABLE_NAME='Budget_Center' AND CONSTRAINT_NAME='I_Budget_Center')
Begin
alter table Budget_Center add constraint I_Budget_Center Primary Key (Branch, CT)
end
GO
IF EXISTS(SELECT * FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS WHERE TABLE_NAME='Budget_Entry' AND CONSTRAINT_NAME='I_Budget_Entry')
Begin
alter table Budget_Entry drop constraint I_Budget_Entry
end
GO
IF EXISTS(SELECT * FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS WHERE TABLE_NAME='Budget_Entry' AND CONSTRAINT_NAME='FK_Budget_Entry_CT')
Begin
alter table Budget_Entry drop constraint FK_Budget_Entry_CT
end
GO
Alter Table Budget_Entry Alter Column CT varchar(20) Not Null
GO
IF not EXISTS(SELECT * FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS WHERE TABLE_NAME='Budget_Entry' AND CONSTRAINT_NAME='I_Budget_Entry')
Begin
alter table Budget_Entry add constraint I_Budget_Entry Primary Key (Year, Branch, CT, GID, ID)
end
GO
IF EXISTS(SELECT * FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS WHERE TABLE_NAME='CTBudget' AND CONSTRAINT_NAME='I_CTBudget')
Begin
alter table CTBudget drop constraint I_CTBudget
end
GO
IF EXISTS(SELECT * FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS WHERE TABLE_NAME='CTBudget' AND CONSTRAINT_NAME='CTCTBudget')
begin
alter table CTBudget drop constraint CTCTBudget
end
GO
Alter Table CTBudget Alter Column CT varchar(20) Not Null
GO
IF not EXISTS(SELECT * FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS WHERE TABLE_NAME='CTBudget' AND CONSTRAINT_NAME='I_CTBudget')
begin
alter table CTBudget add constraint I_CTBudget Primary Key (Account, Branch, Year, CT)
end
GO
IF EXISTS(SELECT * FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS WHERE TABLE_NAME='CTL' AND CONSTRAINT_NAME='I_CTL')
begin
alter table CTL drop constraint I_CTL
end
GO
IF EXISTS(SELECT * FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS WHERE TABLE_NAME='CTL' AND CONSTRAINT_NAME='CTCTL')
begin
alter table CTL drop constraint CTCTL
end
GO
Alter Table CTL Alter Column CT varchar(20) Not Null
GO
IF not EXISTS(SELECT * FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS WHERE TABLE_NAME='CTL' AND CONSTRAINT_NAME='I_CTL')
begin
alter table CTL add constraint I_CTL Primary Key (Account, Branch, Month, Year, CT)
end
GO
IF not EXISTS(SELECT * FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS WHERE TABLE_NAME='CT' AND CONSTRAINT_NAME='I_CT')
begin
alter table CT drop constraint I_CT
end
GO
Alter Table CT Alter Column CT varchar(20) Not Null
GO
IF not EXISTS(SELECT * FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS WHERE TABLE_NAME='CT' AND CONSTRAINT_NAME='I_CT')
begin
alter table CT add constraint I_CT Primary Key (CT)
end
GO
IF not EXISTS(SELECT * FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS WHERE TABLE_NAME='CTL' AND CONSTRAINT_NAME='FK_CTL_CT')
begin
ALTER TABLE CTL  WITH NOCHECK ADD  CONSTRAINT [FK_CTL_CT] FOREIGN KEY(CT)
REFERENCES CT (CT) ON UPDATE CASCADE ON DELETE CASCADE
end
GO

IF not EXISTS(SELECT * FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS WHERE TABLE_NAME='CTBudget' AND CONSTRAINT_NAME='FK_CTBudget_CT')
begin
ALTER TABLE CTBudget  WITH NOCHECK ADD  CONSTRAINT [FK_CTBudget_CT] FOREIGN KEY(CT)
REFERENCES CT (CT) ON UPDATE CASCADE ON DELETE CASCADE
end
GO

IF not EXISTS(SELECT * FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS WHERE TABLE_NAME='Budget_Center' AND CONSTRAINT_NAME='FK_Budget_Center_CT')
begin
ALTER TABLE Budget_Center  WITH NOCHECK ADD  CONSTRAINT [FK_Budget_Center_CT] FOREIGN KEY(CT)
REFERENCES CT (CT) ON UPDATE CASCADE ON DELETE CASCADE
end
GO

IF not EXISTS(SELECT * FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS WHERE TABLE_NAME='Budget_Entry' AND CONSTRAINT_NAME='FK_Budget_Entry_CT')
begin
ALTER TABLE Budget_Entry  WITH NOCHECK ADD  CONSTRAINT [FK_Budget_Entry_CT] FOREIGN KEY(CT)
REFERENCES CT (CT) ON UPDATE CASCADE ON DELETE CASCADE
end
GO
IF not EXISTS(SELECT * FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS WHERE TABLE_NAME='Budget_Activity' AND CONSTRAINT_NAME='FK_Budget_Activity_CT')
begin
ALTER TABLE Budget_Activity  WITH NOCHECK ADD  CONSTRAINT [FK_Budget_Activity_CT] FOREIGN KEY(CT)
REFERENCES CT (CT) ON UPDATE CASCADE ON DELETE CASCADE
end
GO
IF not EXISTS(SELECT * FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS WHERE TABLE_NAME='BAssumption_Rate' AND CONSTRAINT_NAME='FK_BAssumption_Rate_CT')
begin
ALTER TABLE BAssumption_Rate  WITH NOCHECK ADD  CONSTRAINT [FK_BAssumption_Rate_CT] FOREIGN KEY(CT)
REFERENCES CT (CT) ON UPDATE CASCADE ON DELETE CASCADE
end
GO
IF not EXISTS(SELECT * FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS WHERE TABLE_NAME='BAssumption_Growth' AND CONSTRAINT_NAME='FK_BAssumption_Growth_CT')
begin
ALTER TABLE BAssumption_Growth  WITH NOCHECK ADD  CONSTRAINT [FK_BAssumption_Growth_CT] FOREIGN KEY(CT)
REFERENCES CT (CT) ON UPDATE CASCADE ON DELETE CASCADE
end
go




 insert into PatchVersioning
select '150 Update Script - 17 February 2022',GETDATE()
go


Declare @PrevScript varchar(100)
Declare @CurrScript varchar(100)

Select @PrevScript=''
Select @CurrSCript='150 Update Script - 17 February 2022'


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