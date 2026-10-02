IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS WHERE TABLE_NAME='nJournal' AND CONSTRAINT_NAME='FK_nJournal_nVoucher')
Begin
alter table nJournal drop constraint FK_nJournal_nVoucher
end
GO
IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS WHERE TABLE_NAME='nSL' AND CONSTRAINT_NAME='FK_nSL_nVoucher')
Begin
alter table nSL drop constraint FK_nSL_nVoucher
end
GO
IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS WHERE TABLE_NAME='ReminderV' AND CONSTRAINT_NAME='FK_ReminderV_nVoucher')
Begin
alter table ReminderV drop constraint FK_ReminderV_nVoucher
end
GO
IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS WHERE TABLE_NAME='nVoucher' AND CONSTRAINT_NAME='I_nVoucher')
Begin
alter table nVoucher drop constraint I_nVoucher
end
GO

IF EXISTS (SELECT * FROM sys.indexes WHERE name='I_NVoucher_Branch_Date' AND object_id = OBJECT_ID(N'nVoucher'))
Begin
drop index nVoucher.I_NVoucher_Branch_Date
end
GO

IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS WHERE TABLE_NAME='ReminderV' AND CONSTRAINT_NAME='I_ReminderV')
Begin
alter Table ReminderV drop Constraint I_ReminderV
end
GO

drop function ICPS_PolicyPremiumDue
go
drop function ICPS_PolicyPremiumPaid
go

alter table Admlink alter column Voucher varchar(30) 
GO
alter table nVoucher alter column Voucher varchar(30) Not Null
GO
alter table nSL alter column Voucher varchar(30) 
GO
alter table nJournal alter column Voucher varchar(30)
GO
alter table ReminderV alter column Voucher varchar(30) Not Null

GO


IF not EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS WHERE TABLE_NAME='ReminderV' AND CONSTRAINT_NAME='I_ReminderV')
Begin
ALter Table ReminderV add constraint I_ReminderV PRIMARY KEY NONCLUSTERED (PrintNo, Voucher, Reminder ASC)
end
GO
IF not EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS WHERE TABLE_NAME='nVoucher' AND CONSTRAINT_NAME='I_nVoucher')
Begin
ALter Table nVoucher add constraint I_nVoucher PRIMARY KEY NONCLUSTERED ([Voucher] ASC)
end
GO

IF not EXISTS (SELECT * FROM sys.indexes WHERE name='I_NVoucher_Branch_Date' AND object_id = OBJECT_ID(N'nVoucher'))
Begin
Create Index I_NVoucher_Branch_Date on nVoucher(Voucher, Branch, Date)
end
GO

IF not EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS WHERE TABLE_NAME='nJournal' AND CONSTRAINT_NAME='FK_nJournal_nVoucher')
Begin
ALTER TABLE [dbo].[nJournal]  WITH NOCHECK ADD  CONSTRAINT [FK_nJournal_nVoucher] FOREIGN KEY([Voucher])
REFERENCES [dbo].[nVoucher] ([Voucher])
ON UPDATE CASCADE
ON DELETE CASCADE
end
GO

ALTER TABLE [dbo].[nJournal] CHECK CONSTRAINT [FK_nJournal_nVoucher]
GO

IF not EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS WHERE TABLE_NAME='nSL' AND CONSTRAINT_NAME='FK_nSL_nVoucher')
Begin
ALTER TABLE [dbo].[nSL]  WITH NOCHECK ADD  CONSTRAINT [FK_nSL_nVoucher] FOREIGN KEY([Voucher])
REFERENCES [dbo].[nVoucher] ([Voucher])
ON UPDATE CASCADE
ON DELETE CASCADE
end
GO

ALTER TABLE [dbo].[nSL] CHECK CONSTRAINT [FK_nSL_nVoucher]
GO

IF not EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS WHERE TABLE_NAME='ReminderV' AND CONSTRAINT_NAME='FK_ReminderV_nVoucher')
Begin
ALTER TABLE [dbo].[ReminderV]  WITH NOCHECK ADD  CONSTRAINT [FK_ReminderV_nVoucher] FOREIGN KEY([Voucher])
REFERENCES [dbo].[nVoucher] ([Voucher])
ON UPDATE CASCADE
ON DELETE CASCADE
end
GO

ALTER TABLE [dbo].[ReminderV] CHECK CONSTRAINT [FK_ReminderV_nVoucher]
GO


Create Function ICPS_PolicyPremiumDue(@P_A_PolicyNo as varchar(50))
RETURNS Float
With SchemaBinding
AS    
BEGIN    
 Declare @PremiumPaid as float
 Declare @PremiumDue as float
 DECLARE PolicyPremium_Cursor CURSOR FOR    
	SELECT     
	sum(CASE WHEN nVoucher.DEBTORF=1 THEN 1 else -1 end*  
	(Case When nVoucher.Installment=0 and nVoucher.DueDate <=getdate() Then nVoucher.Nominal_CC-nVoucher.Diff_CC else 0 end+          
	Case When nVoucher.Installment>=1 and nVoucher.DueDate_1 <=getdate() Then nVoucher.AmountDue_1 else 0 end+          
	Case When nVoucher.Installment>=2 and nVoucher.DueDate_2 <=getdate() Then nVoucher.AmountDue_2 else 0 end+          
	Case When nVoucher.Installment>=3 and nVoucher.DueDate_3 <=getdate() Then nVoucher.AmountDue_3 else 0 end+          
	Case When nVoucher.Installment>=4 and nVoucher.DueDate_4 <=getdate() Then nVoucher.AmountDue_4 else 0 end+          
	Case When nVoucher.Installment>=5 and nVoucher.DueDate_5 <=getdate() Then nVoucher.AmountDue_5 else 0 end+          
	Case When nVoucher.Installment>=6 and nVoucher.DueDate_6 <=getdate() Then nVoucher.AmountDue_6 else 0 end+          
	Case When nVoucher.Installment>=7 and nVoucher.DueDate_7 <=getdate() Then nVoucher.AmountDue_7 else 0 end+          
	Case When nVoucher.Installment>=8 and nVoucher.DueDate_8 <=getdate() Then nVoucher.AmountDue_8 else 0 end+          
	Case When nVoucher.Installment>=9 and nVoucher.DueDate_9 <=getdate() Then nVoucher.AmountDue_9 else 0 end+          
	Case When nVoucher.Installment>=10 and nVoucher.DueDate_10 <=getdate() Then nVoucher.AmountDue_10 else 0 end+          
	Case When nVoucher.Installment>=11 and nVoucher.DueDate_11 <=getdate() Then nVoucher.AmountDue_11 else 0 end+          
	Case When nVoucher.Installment>=12 and nVoucher.DueDate_12 <=getdate() Then nVoucher.AmountDue_12 else 0 end)*nVoucher.Rate) as PremiumDue,          
	sum(CASE WHEN nVoucher.DEBTORF=1 THEN nVoucher.PAYMENT_CC ELSE -nVoucher.PAYMENT_CC END*nVoucher.RATE) as PremiumPaid  
	FROM DBO.nVoucher nVoucher, DBO.Admlink Admlink        
	Where nVoucher.Voucher = Admlink.Voucher and Admlink.Type in ('DI','IC','IR') and Admlink.Subject='PREMIUM'  
	And Admlink.A_PolicyNo=@P_A_PolicyNo
	Group By Admlink.A_PolicyNo 
 OPEN PolicyPremium_Cursor    
 FETCH FROM PolicyPremium_Cursor into @PremiumDue, @PremiumPaid
 Close PolicyPremium_Cursor    
 Deallocate PolicyPremium_Cursor    
 Return (@PremiumDue)    
End    
go
Create Function ICPS_PolicyPremiumPaid(@P_A_PolicyNo as varchar(50))
RETURNS Float
With SchemaBinding
AS    
BEGIN    
 Declare @PremiumPaid as float
 Declare @PremiumDue as float
 DECLARE PolicyPremium_Cursor CURSOR FOR    
	SELECT     
	sum(CASE WHEN nVoucher.DEBTORF=1 THEN 1 else -1 end*  
	(Case When nVoucher.Installment=0 and nVoucher.DueDate <=getdate() Then nVoucher.Nominal_CC-nVoucher.Diff_CC else 0 end+          
	Case When nVoucher.Installment>=1 and nVoucher.DueDate_1 <=getdate() Then nVoucher.AmountDue_1 else 0 end+          
	Case When nVoucher.Installment>=2 and nVoucher.DueDate_2 <=getdate() Then nVoucher.AmountDue_2 else 0 end+          
	Case When nVoucher.Installment>=3 and nVoucher.DueDate_3 <=getdate() Then nVoucher.AmountDue_3 else 0 end+          
	Case When nVoucher.Installment>=4 and nVoucher.DueDate_4 <=getdate() Then nVoucher.AmountDue_4 else 0 end+          
	Case When nVoucher.Installment>=5 and nVoucher.DueDate_5 <=getdate() Then nVoucher.AmountDue_5 else 0 end+          
	Case When nVoucher.Installment>=6 and nVoucher.DueDate_6 <=getdate() Then nVoucher.AmountDue_6 else 0 end+          
	Case When nVoucher.Installment>=7 and nVoucher.DueDate_7 <=getdate() Then nVoucher.AmountDue_7 else 0 end+          
	Case When nVoucher.Installment>=8 and nVoucher.DueDate_8 <=getdate() Then nVoucher.AmountDue_8 else 0 end+          
	Case When nVoucher.Installment>=9 and nVoucher.DueDate_9 <=getdate() Then nVoucher.AmountDue_9 else 0 end+          
	Case When nVoucher.Installment>=10 and nVoucher.DueDate_10 <=getdate() Then nVoucher.AmountDue_10 else 0 end+          
	Case When nVoucher.Installment>=11 and nVoucher.DueDate_11 <=getdate() Then nVoucher.AmountDue_11 else 0 end+          
	Case When nVoucher.Installment>=12 and nVoucher.DueDate_12 <=getdate() Then nVoucher.AmountDue_12 else 0 end)*nVoucher.Rate) as PremiumDue,          
	sum(CASE WHEN nVoucher.DEBTORF=1 THEN nVoucher.PAYMENT_CC ELSE -nVoucher.PAYMENT_CC END*nVoucher.RATE) as PremiumPaid  
	FROM DBO.nVoucher nVoucher, DBO.Admlink Admlink        
	Where nVoucher.Voucher = Admlink.Voucher and Admlink.Type in ('DI','IC','IR') and Admlink.Subject='PREMIUM'  
	And Admlink.A_PolicyNo=@P_A_PolicyNo
	Group By Admlink.A_PolicyNo 
 OPEN PolicyPremium_Cursor    
 FETCH FROM PolicyPremium_Cursor into @PremiumDue, @PremiumPaid
 Close PolicyPremium_Cursor    
 Deallocate PolicyPremium_Cursor    
 Return (@PremiumPaid)    
End    
go

IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS WHERE TABLE_NAME='BPP' AND CONSTRAINT_NAME='I_BPP')
Begin
Alter Table BPP drop Constraint I_BPP
end
GO

Alter table BPP alter Column Voucher varchar(30) Not Null
GO

IF not EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS WHERE TABLE_NAME='BPP' AND CONSTRAINT_NAME='I_BPP')
Begin
ALter Table BPP add constraint I_BPP PRIMARY KEY NONCLUSTERED ([Voucher] ASC)
end
GO

IF  EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS WHERE TABLE_NAME='TAX' AND CONSTRAINT_NAME='I_TAX')
Begin
Alter Table TAX drop Constraint I_TAX
end
GO
Alter table TAX alter Column Voucher varchar(30) Not Null
GO
IF not EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS WHERE TABLE_NAME='TAX' AND CONSTRAINT_NAME='I_TAX')
Begin
ALter Table TAX add constraint I_TAX PRIMARY KEY NONCLUSTERED ([Voucher] ASC)
end
GO

Alter Table VPrintLog Alter Column Voucher varchar(30)
GO

IF  EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS WHERE TABLE_NAME='InvValue' AND CONSTRAINT_NAME='I_InvValue')
Begin
Alter Table InvValue drop Constraint I_InvValue
end
GO
Alter table InvValue alter Column Voucher varchar(30) Not Null
GO
IF not EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS WHERE TABLE_NAME='InvValue' AND CONSTRAINT_NAME='I_InvValue')
Begin
ALter Table InvValue add constraint I_InvValue PRIMARY KEY NONCLUSTERED (Investment, RefType, Voucher, Date)
end
GO

Alter Table ARBucket alter Column Voucher varchar(30)
GO
Alter Table RPBucket alter Column nVoucher varchar(30)
GO

IF  EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS WHERE TABLE_NAME='CollectionV' AND CONSTRAINT_NAME='I_CollectionV')
Begin
Alter Table CollectionV drop Constraint I_CollectionV
end
GO
Alter table CollectionV alter Column Voucher varchar(30) Not Null
GO
IF not EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS WHERE TABLE_NAME='CollectionV' AND CONSTRAINT_NAME='I_CollectionV')
Begin
ALter Table CollectionV add constraint I_CollectionV PRIMARY KEY NONCLUSTERED (CollNo, RefNo, Currency, Voucher)
end
GO

IF  EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS WHERE TABLE_NAME='CollResultDet' AND CONSTRAINT_NAME='I_CollResultDet')
Begin
Alter Table CollResultDet drop Constraint I_CollResultDet
end
GO
Alter table CollResultDet alter Column Voucher varchar(30) Not Null
GO
IF not EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS WHERE TABLE_NAME='CollResultDet' AND CONSTRAINT_NAME='I_CollResultDet')
Begin
ALter Table CollResultDet add constraint I_CollResultDet PRIMARY KEY NONCLUSTERED (CollNo, VoucherR, RefNo, Currency, Voucher)
end
GO

IF  EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS WHERE TABLE_NAME='VoucherLinkD' AND CONSTRAINT_NAME='I_VoucherLinkD')
Begin
Alter Table VoucherLinkD drop Constraint I_VoucherLinkD
end
GO
Alter table VoucherLinkD alter Column Voucher varchar(30) Not Null
GO
IF not EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS WHERE TABLE_NAME='VoucherLinkD' AND CONSTRAINT_NAME='I_VoucherLinkD')
Begin
ALter Table VoucherLinkD add constraint I_VoucherLinkD PRIMARY KEY NONCLUSTERED (BID, Voucher)
end
GO

Alter Table LogFileD Alter Column Voucher varchar(30)

GO

ALTER TABLE [dbo].[nVoucher] DROP CONSTRAINT [DF__nVoucher__Rate_R__1BD9655E]
GO

ALTER TABLE [dbo].[nVoucher] DROP CONSTRAINT [DF_nVoucher_RefAmount]
GO

ALTER TABLE [dbo].[nVoucher] DROP CONSTRAINT [DF_nVoucher_BackDatedF]
GO

ALTER TABLE [dbo].[nVoucher] DROP CONSTRAINT [DF_nVoucher_TaxPayment_OC]
GO

ALTER TABLE [dbo].[nVoucher] DROP CONSTRAINT [DF_nVoucher_TaxPayment_CC]
GO

ALTER TABLE [dbo].[nVoucher] DROP CONSTRAINT [DF_nVoucher_AMOUNTDUE_12]
GO

ALTER TABLE [dbo].[nVoucher] DROP CONSTRAINT [DF_nVoucher_AMOUNTDUE_11]
GO

ALTER TABLE [dbo].[nVoucher] DROP CONSTRAINT [DF_nVoucher_AMOUNTDUE_10]
GO

ALTER TABLE [dbo].[nVoucher] DROP CONSTRAINT [DF_nVoucher_AMOUNTDUE_9]
GO

ALTER TABLE [dbo].[nVoucher] DROP CONSTRAINT [DF_nVoucher_AMOUNTDUE_8]
GO

ALTER TABLE [dbo].[nVoucher] DROP CONSTRAINT [DF_nVoucher_AMOUNTDUE_7]
GO

ALTER TABLE [dbo].[nVoucher] DROP CONSTRAINT [DF_nVoucher_AMOUNTDUE_6]
GO

ALTER TABLE [dbo].[nVoucher] DROP CONSTRAINT [DF_nVoucher_AMOUNTDUE_5]
GO

ALTER TABLE [dbo].[nVoucher] DROP CONSTRAINT [DF_nVoucher_AMOUNTDUE_4]
GO

ALTER TABLE [dbo].[nVoucher] DROP CONSTRAINT [DF_nVoucher_AMOUNTDUE_3]
GO

ALTER TABLE [dbo].[nVoucher] DROP CONSTRAINT [DF_nVoucher_AMOUNTDUE_2]
GO

ALTER TABLE [dbo].[nVoucher] DROP CONSTRAINT [DF_nVoucher_AMOUNTDUE_1]
GO

ALTER TABLE [dbo].[nVoucher] DROP CONSTRAINT [DF_nVoucher_AMOUNTUNDUE]
GO

ALTER TABLE [dbo].[nVoucher] DROP CONSTRAINT [DF_nVoucher_AMOUNTDUE]
GO

ALTER TABLE [dbo].[nVoucher] DROP CONSTRAINT [DF_nVoucher_CINSTALLMENT]
GO

ALTER TABLE [dbo].[nVoucher] DROP CONSTRAINT [DF_nVoucher_INSTALLMENT]
GO

ALTER TABLE [dbo].[nVoucher] DROP CONSTRAINT [DF_nVoucher_RejectF]
GO

ALTER TABLE [dbo].[nVoucher] DROP CONSTRAINT [DF_nVoucher_BranchF]
GO

ALTER TABLE [dbo].[nVoucher] DROP CONSTRAINT [DF_nVoucher_ReceiptF]
GO

ALTER TABLE [dbo].[nVoucher] DROP CONSTRAINT [DF_nVoucher_PaymentF]
GO

ALTER TABLE [dbo].[nVoucher] DROP CONSTRAINT [DF_nVoucher_SL_Tag]
GO

ALTER TABLE [dbo].[nVoucher] DROP CONSTRAINT [DF_nVoucher_SourceF]
GO

ALTER TABLE [dbo].[nVoucher] DROP CONSTRAINT [DF_nVoucher_ParentF]
GO

ALTER TABLE [dbo].[nVoucher] DROP CONSTRAINT [DF_nVoucher_TaxF]
GO

ALTER TABLE [dbo].[nVoucher] DROP CONSTRAINT [DF_nVoucher_VatF]
GO

ALTER TABLE [dbo].[nVoucher] DROP CONSTRAINT [DF_nVoucher_Tax_CC]
GO

ALTER TABLE [dbo].[nVoucher] DROP CONSTRAINT [DF_nVoucher_Vat_CC]
GO

ALTER TABLE [dbo].[nVoucher] DROP CONSTRAINT [DF_nVoucher_Qty]
GO

ALTER TABLE [dbo].[nVoucher] DROP CONSTRAINT [DF_nVoucher_PIRate]
GO

ALTER TABLE [dbo].[nVoucher] DROP CONSTRAINT [DF_nVoucher_IRate]
GO

ALTER TABLE [dbo].[nVoucher] DROP CONSTRAINT [DF_nVoucher_Payment_OC]
GO

ALTER TABLE [dbo].[nVoucher] DROP CONSTRAINT [DF_nVoucher_Payment_CC]
GO

ALTER TABLE [dbo].[nVoucher] DROP CONSTRAINT [DF_nVoucher_Diff]
GO

ALTER TABLE [dbo].[nVoucher] DROP CONSTRAINT [DF_nVoucher_Diff_CC]
GO

ALTER TABLE [dbo].[nVoucher] DROP CONSTRAINT [DF_nVoucher_InvestmentF]
GO

ALTER TABLE [dbo].[nVoucher] DROP CONSTRAINT [DF_nVoucher_AssetF]
GO

ALTER TABLE [dbo].[nVoucher] DROP CONSTRAINT [DF_nVoucher_ByCheque]
GO

ALTER TABLE [dbo].[nVoucher] DROP CONSTRAINT [DF_nVoucher_ChequeF]
GO

ALTER TABLE [dbo].[nVoucher] DROP CONSTRAINT [DF_nVoucher_CreditorF]
GO

ALTER TABLE [dbo].[nVoucher] DROP CONSTRAINT [DF_nVoucher_DebtorF]
GO

ALTER TABLE [dbo].[nVoucher] DROP CONSTRAINT [DF_nVoucher_SL_Flag]
GO

ALTER TABLE [dbo].[nVoucher] DROP CONSTRAINT [DF_nVoucher_Posting_Flag]
GO

ALTER TABLE [dbo].[nVoucher] DROP CONSTRAINT [DF_nVoucher_Nominal]
GO

ALTER TABLE [dbo].[nVoucher] DROP CONSTRAINT [DF_nVoucher_Rate]
GO

ALTER TABLE [dbo].[nVoucher] DROP CONSTRAINT [DF_nVoucher_Nominal_CC]
GO

ALTER TABLE [dbo].[AdmLink] DROP CONSTRAINT [DF_AdmLink_TaxTableF]
GO

ALTER TABLE [dbo].[AdmLink] DROP CONSTRAINT [DF_AdmLink_STATEMENT]
GO

ALTER TABLE [dbo].[AdmLink] DROP CONSTRAINT [DF_AdmLink_WPC]
GO

ALTER TABLE [dbo].[AdmLink] DROP CONSTRAINT [DF_AdmLink_TransF]
GO

ALTER TABLE [dbo].[AdmLink] DROP CONSTRAINT [DF__AdmLink__AMOUNTD__695412AE]
GO

ALTER TABLE [dbo].[AdmLink] DROP CONSTRAINT [DF__AdmLink__AMOUNTD__685FEE75]
GO

ALTER TABLE [dbo].[AdmLink] DROP CONSTRAINT [DF__AdmLink__AMOUNTD__676BCA3C]
GO

ALTER TABLE [dbo].[AdmLink] DROP CONSTRAINT [DF__AdmLink__AMOUNTD__6677A603]
GO

ALTER TABLE [dbo].[AdmLink] DROP CONSTRAINT [DF__AdmLink__AMOUNTD__658381CA]
GO

ALTER TABLE [dbo].[AdmLink] DROP CONSTRAINT [DF__AdmLink__AMOUNTD__648F5D91]
GO

ALTER TABLE [dbo].[AdmLink] DROP CONSTRAINT [DF__AdmLink__AMOUNTD__639B3958]
GO

ALTER TABLE [dbo].[AdmLink] DROP CONSTRAINT [DF__AdmLink__AMOUNTD__62A7151F]
GO

ALTER TABLE [dbo].[AdmLink] DROP CONSTRAINT [DF__AdmLink__AMOUNTD__61B2F0E6]
GO

ALTER TABLE [dbo].[AdmLink] DROP CONSTRAINT [DF__AdmLink__AMOUNTD__60BECCAD]
GO

ALTER TABLE [dbo].[AdmLink] DROP CONSTRAINT [DF__AdmLink__AMOUNTD__5FCAA874]
GO

ALTER TABLE [dbo].[AdmLink] DROP CONSTRAINT [DF__AdmLink__AMOUNTD__5ED6843B]
GO

ALTER TABLE [dbo].[AdmLink] DROP CONSTRAINT [DF__AdmLink__IAMOUNT__5DE26002]
GO

ALTER TABLE [dbo].[AdmLink] DROP CONSTRAINT [DF__AdmLink__LAMOUNT__5CEE3BC9]
GO

ALTER TABLE [dbo].[AdmLink] DROP CONSTRAINT [DF__AdmLink__INSTALL__5BFA1790]
GO

ALTER TABLE [dbo].[AdmLink] DROP CONSTRAINT [DF__AdmLink__AMOUNT__5B05F357]
GO

ALTER TABLE [dbo].[AdmLink] DROP CONSTRAINT [DF__AdmLink__AMOUNT___5A11CF1E]
GO

ALTER TABLE [dbo].[AdmLink] DROP CONSTRAINT [DF__AdmLink__AMOUNT___591DAAE5]
GO

ALTER TABLE [dbo].[AdmLink] DROP CONSTRAINT [DF__AdmLink__AMOUNT___582986AC]
GO

ALTER TABLE [dbo].[AdmLink] DROP CONSTRAINT [DF__AdmLink__AMOUNT___57356273]
GO

ALTER TABLE [dbo].[AdmLink] DROP CONSTRAINT [DF__AdmLink__AMOUNT___56413E3A]
GO

ALTER TABLE [dbo].[AdmLink] DROP CONSTRAINT [DF__AdmLink__AMOUNT___554D1A01]
GO

ALTER TABLE [dbo].[AdmLink] DROP CONSTRAINT [DF__AdmLink__AMOUNT___5458F5C8]
GO

ALTER TABLE [dbo].[AdmLink] DROP CONSTRAINT [DF__AdmLink__AMOUNT___5364D18F]
GO

ALTER TABLE [dbo].[AdmLink] DROP CONSTRAINT [DF__AdmLink__AMOUNT___5270AD56]
GO

ALTER TABLE [dbo].[AdmLink] DROP CONSTRAINT [DF__AdmLink__AMOUNT___517C891D]
GO

ALTER TABLE [dbo].[AdmLink] DROP CONSTRAINT [DF__AdmLink__AMOUNT___508864E4]
GO

ALTER TABLE [dbo].[AdmLink] DROP CONSTRAINT [DF__AdmLink__AMOUNT___4F9440AB]
GO

ALTER TABLE [dbo].[AdmLink] DROP CONSTRAINT [DF__AdmLink__AMOUNT___4EA01C72]
GO

ALTER TABLE [dbo].[AdmLink] DROP CONSTRAINT [DF__AdmLink__AMOUNT___4DABF839]
GO

ALTER TABLE [dbo].[AdmLink] DROP CONSTRAINT [DF_AdmLink_ADMNO]
GO

ALTER TABLE [dbo].[AdmLink] DROP CONSTRAINT [DF_AdmLink_WRITEF]
GO

ALTER TABLE [dbo].[AdmLink] DROP CONSTRAINT [DF_AdmLink_VOUCHERF]
GO


IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS WHERE TABLE_NAME='AdmLink' AND CONSTRAINT_NAME='BranchAdmLink')
Begin
ALTER TABLE [dbo].[AdmLink] DROP CONSTRAINT [BranchAdmLink]
end
GO

IF not EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS WHERE TABLE_NAME='AdmLink' AND CONSTRAINT_NAME='FK_Admlink_Branch')
Begin
ALTER TABLE [dbo].[Admlink]  WITH NOCHECK ADD  CONSTRAINT [FK_Admlink_Branch] FOREIGN KEY([Branch])
REFERENCES [dbo].Branch ([Branch])
end
GO

ALTER TABLE [dbo].[Admlink] CHECK CONSTRAINT [FK_Admlink_Branch]
GO

 insert into PatchVersioning	
select '734 Update Script - Patch 2023 (83)',GETDATE()
go





Declare @PrevScript varchar(100)
Declare @CurrScript varchar(1004)

Select @PrevScript=''
Select @CurrSCript='734 Update Script - Patch 2023 (83)'


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