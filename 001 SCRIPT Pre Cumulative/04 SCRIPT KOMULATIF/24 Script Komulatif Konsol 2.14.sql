--14 sept 2017


insert into SysForm(FName, Description, FCode)
Select 'ALLOWCHANGECT','Allow Change CT (UW/CL)','ACTIVITIES'
go
UPDATE SYSFORM Set Description='Allow Change Policy Branch (UW/CL)' Where FName='ALLOWCHANGEBRANCH'
go

Update VType Set Code=CodeExt, Codeext='' from VType Where TaxF=1 and CodeExt not in ('','Premium','Claim')
go

-- 15 sept 2017 


insert into SysForm(FName, Description, FCode)
Select 'ALLOWCANGEPML','Allow Change PML (UW)','ACTIVITIES'
go

--18 sept 2017
/* To prevent any potential data loss issues, you should review this script in detail before running it outside the context of the database designer.*/
BEGIN TRANSACTION
SET QUOTED_IDENTIFIER ON
SET ARITHABORT ON
SET NUMERIC_ROUNDABORT OFF
SET CONCAT_NULL_YIELDS_NULL ON
SET ANSI_NULLS ON
SET ANSI_PADDING ON
SET ANSI_WARNINGS ON
COMMIT
BEGIN TRANSACTION
GO
ALTER TABLE dbo.ACCLINK ADD
	Amount_1_1 float(53) NULL,
	Amount_1_2 float(53) NULL,
	Amount_1_3 float(53) NULL,
	Amount_1_4 float(53) NULL,
	Amount_1_5 float(53) NULL,
	Amount_1_6 float(53) NULL,
	Amount_3_1 float(53) NULL,
	Amount_3_2 float(53) NULL,
	Amount_3_3 float(53) NULL,
	Amount_3_4 float(53) NULL,
	Amount_3_5 float(53) NULL,
	Amount_3_6 float(53) NULL,
	Amount_3_7 float(53) NULL,
	Amount_3_8 float(53) NULL
GO
DECLARE @v sql_variant 
SET @v = N'Gross Out Standing (Before Member Share/Co Out)'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'ACCLINK', N'COLUMN', N'Amount_1_1'
GO
DECLARE @v sql_variant 
SET @v = N'Coinsurance Out'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'ACCLINK', N'COLUMN', N'Amount_1_2'
GO
DECLARE @v sql_variant 
SET @v = N'Deductible'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'ACCLINK', N'COLUMN', N'Amount_1_3'
GO
DECLARE @v sql_variant 
SET @v = N'Expense/Cost'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'ACCLINK', N'COLUMN', N'Amount_1_4'
GO
DECLARE @v sql_variant 
SET @v = N'Subrogation'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'ACCLINK', N'COLUMN', N'Amount_1_5'
GO
DECLARE @v sql_variant 
SET @v = N'Salvage'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'ACCLINK', N'COLUMN', N'Amount_1_6'
GO
DECLARE @v sql_variant 
SET @v = N'BPPDAN'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'ACCLINK', N'COLUMN', N'Amount_3_1'
GO
DECLARE @v sql_variant 
SET @v = N'MAIPARK'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'ACCLINK', N'COLUMN', N'Amount_3_2'
GO
DECLARE @v sql_variant 
SET @v = N'DECREE'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'ACCLINK', N'COLUMN', N'Amount_3_3'
GO
DECLARE @v sql_variant 
SET @v = N'QUOTA_SHARE'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'ACCLINK', N'COLUMN', N'Amount_3_4'
GO
DECLARE @v sql_variant 
SET @v = N'SURPLUS'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'ACCLINK', N'COLUMN', N'Amount_3_5'
GO
DECLARE @v sql_variant 
SET @v = N'AUTO FACULTATIVE'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'ACCLINK', N'COLUMN', N'Amount_3_6'
GO
DECLARE @v sql_variant 
SET @v = N'FACULTATIVE'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'ACCLINK', N'COLUMN', N'Amount_3_7'
GO
DECLARE @v sql_variant 
SET @v = N'XOL'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'ACCLINK', N'COLUMN', N'Amount_3_8'
GO
ALTER TABLE dbo.ACCLINK SET (LOCK_ESCALATION = TABLE)
GO
COMMIT
GO
/* To prevent any potential data loss issues, you should review this script in detail before running it outside the context of the database designer.*/
BEGIN TRANSACTION
SET QUOTED_IDENTIFIER ON
SET ARITHABORT ON
SET NUMERIC_ROUNDABORT OFF
SET CONCAT_NULL_YIELDS_NULL ON
SET ANSI_NULLS ON
SET ANSI_PADDING ON
SET ANSI_WARNINGS ON
COMMIT
BEGIN TRANSACTION
GO
ALTER TABLE dbo.AdmLink ADD
	EXTRA_6 varchar(50) NULL,
	EXTRA_7 varchar(50) NULL,
	EXTRA_8 varchar(50) NULL,
	EXTRA_9 varchar(50) NULL,
	EXTRA_10 varchar(50) NULL
GO
DECLARE @v sql_variant 
SET @v = N'Free Text'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'AdmLink', N'COLUMN', N'EXTRA_6'
GO
DECLARE @v sql_variant 
SET @v = N'Free Text'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'AdmLink', N'COLUMN', N'EXTRA_7'
GO
DECLARE @v sql_variant 
SET @v = N'Free Text'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'AdmLink', N'COLUMN', N'EXTRA_8'
GO
DECLARE @v sql_variant 
SET @v = N'Free Text'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'AdmLink', N'COLUMN', N'EXTRA_9'
GO
DECLARE @v sql_variant 
SET @v = N'Free Text'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'AdmLink', N'COLUMN', N'EXTRA_10'
GO
ALTER TABLE dbo.AdmLink SET (LOCK_ESCALATION = TABLE)
GO
COMMIT
GO
/* To prevent any potential data loss issues, you should review this script in detail before running it outside the context of the database designer.*/
BEGIN TRANSACTION
SET QUOTED_IDENTIFIER ON
SET ARITHABORT ON
SET NUMERIC_ROUNDABORT OFF
SET CONCAT_NULL_YIELDS_NULL ON
SET ANSI_NULLS ON
SET ANSI_PADDING ON
SET ANSI_WARNINGS ON
COMMIT
BEGIN TRANSACTION
GO
ALTER TABLE dbo.ACCLINK ADD
	EXTRA_6 varchar(50) NULL,
	EXTRA_7 varchar(50) NULL,
	EXTRA_8 varchar(50) NULL,
	EXTRA_9 varchar(50) NULL,
	EXTRA_10 varchar(50) NULL
GO
DECLARE @v sql_variant 
SET @v = N'Free Text'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'ACCLINK', N'COLUMN', N'EXTRA_6'
GO
DECLARE @v sql_variant 
SET @v = N'Free Text'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'ACCLINK', N'COLUMN', N'EXTRA_7'
GO
DECLARE @v sql_variant 
SET @v = N'Free Text'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'ACCLINK', N'COLUMN', N'EXTRA_8'
GO
DECLARE @v sql_variant 
SET @v = N'Free Text'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'ACCLINK', N'COLUMN', N'EXTRA_9'
GO
DECLARE @v sql_variant 
SET @v = N'Free Text'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'ACCLINK', N'COLUMN', N'EXTRA_10'
GO
ALTER TABLE dbo.ACCLINK SET (LOCK_ESCALATION = TABLE)
GO
COMMIT


--19 sept 2017
Select * into #MParam from Mparam Where Type='PC'
go
Update #Mparam Set Type='AD', Remarks='Allowance For Doubtful Account'
go
insert into Mparam Select * from #Mparam
go
drop table #Mparam
go


--19 sept 2017 

BEGIN TRANSACTION
SET QUOTED_IDENTIFIER ON
SET ARITHABORT ON
SET NUMERIC_ROUNDABORT OFF
SET CONCAT_NULL_YIELDS_NULL ON
SET ANSI_NULLS ON
SET ANSI_PADDING ON
SET ANSI_WARNINGS ON
COMMIT
BEGIN TRANSACTION
GO
ALTER TABLE dbo.AdmLink ADD
	MSCode varchar(10) NULL
GO
ALTER TABLE dbo.AdmLink SET (LOCK_ESCALATION = TABLE)
GO
COMMIT

-- AFDA Proses
DROP FUNCTION AFDA_PROCESS
GO
CREATE FUNCTION AFDA_PROCESS(@P_Type varchar(2),@P_Date smalldatetime, @P_PEDate smalldatetime,@P_EDate smalldatetime)                            
RETURNS @ACCLINK TABLE (Branch varchar(10), DocNo varchar(50), RefNo varchar(50), Date smalldatetime, Code varchar(10), Type varchar(50), Currency varchar(10), Subject varchar(10), Remarks varchar(Max), Amount_1 Float, Amount_2 Float, Amount_3 Float, Amount_4 Float, Amount_5 FLoat, Amount Float, Rate Float, Rate_RC Float)

BEGIN  
     

Declare @P_Lapse int

Select @P_Lapse=60

declare @Voucher table(Voucher varchar(20), DebtorF Bit, Account varchar(10), Nominal_OC Float)
insert into @Voucher(Voucher, DebtorF, Account)
Select Voucher.Voucher, Cast(Max(Cast(Voucher.DebtorF as Int)) as Bit) as DebtorF, Max(nSL.Account) as Account
from Admlink, nVoucher Voucher, nSL
Where nSL.Voucher=Voucher.Voucher and Voucher.Voucher=Admlink.Voucher and Voucher.Date<=@P_Date and ((Voucher.Nominal_CC-Voucher.Diff_CC-Voucher.Payment_CC-Voucher.Payment_OC)<>0 or Voucher.PDate>=@P_Date)
Group by Voucher.Voucher


declare @Payment table(Voucher varchar(20), Payment_CC Float)
insert into @Payment(Voucher, Payment_CC)
Select pSL.Doc_No as Voucher, Sum(dbo.fn_SL_Payment_Nominal(pSL.Nominal_OC, pVoucher.SL_Cat, pVoucher.DebtorF, V.DebtorF)*(Case When V.DebtorF=1 Then 1 Else -1 end)) as Payment_CC 
from pSL, pVoucher, @Voucher V 
Where pSL.PaymentF=1 and V.Voucher=pSL.Doc_No and pVoucher.Voucher=pSL.Voucher and pVoucher.Date<=@P_Date
Group By pSL.Doc_No

insert into @Acclink
select A.Branch, A.Voucher as DocNo, A.RefNo, @P_Date as Date, A.Code as Code, @P_Type as Type, SysTab.Currency, 'JOURNAL' as Subject, A.Remarks as Remarks,  
'Amount_1'= Case When V.AmountDue-V.Payment_CC>0 then V.AmountDue-V.Payment_CC Else 0 end*(Case When V.DebtorF=1 Then 1 Else -1 end)*(Case When Currency.VRate=0 Then Currency.Rate Else Currency.VRate End),
'Amount_2'=0,
'Amount_3'=0,
'Amount_4'=0,
'Amount_5'=0,
'Amount'= Case When V.AmountDue-V.Payment_CC>0 then V.AmountDue-V.Payment_CC Else 0 end*(Case When V.DebtorF=1 Then 1 Else -1 end)*(Case When Currency.VRate=0 Then Currency.Rate Else Currency.VRate End),
0 as Rate,
0 as Rate_RC
from 
(
	Select
	V.Voucher, 
	V.DebtorF, 
	Case When Voucher.Installment=0 and datediff(day,Voucher.DueDate,@P_Date)>@P_Lapse Then Voucher.Nominal_CC-Voucher.Diff_CC Else 0 End
	+ Case When Voucher.INSTALLMENT=1 and datediff(day,Voucher.DueDate_1,@P_Date)>@P_Lapse Then Voucher.AMOUNTDUE_1 Else 0 End
	+ Case When Voucher.INSTALLMENT=2 and datediff(day,Voucher.DueDate_2,@P_Date)>@P_Lapse Then Voucher.AMOUNTDUE_2 Else 0 End as AmountDue,
	P.Payment_CC 
	from @Voucher V
	Left Join @Payment P on (P.Voucher=V.Voucher)
	Inner Join nVoucher Voucher on (Voucher.Voucher=V.Voucher)
) V, Admlink A, fn_Exchange(dateadd(day,1,@P_Date)) Currency, SysTab
Where A.Voucher=V.Voucher and Currency.Currency=A.Currency
and Case When V.AmountDue-V.Payment_CC>0 then V.AmountDue-V.Payment_CC Else 0 end>0

insert into @Acclink
select A.Branch, A.DocNo, A.RefNo, @P_Date as Date, A.Code, @P_Type as Type, A.Currency, 'REVERSAL' as Subject, A.Remarks,            
 -Amount_1 as Amount_1,            
 -Amount_2 as Amount_2,            
 -Amount_3 as Amount_3,            
 -Amount_4 as Amount_4,            
 -Amount_5 as Amount_5,            
 -Amount as Amount,  
 mVoucher.Rate,
 mVoucher.Rate_RC      
from AccLink A, mVoucher          
Where A.Type='AD' and Month(A.Date)=Month(@P_PEDate) and Year(A.Date)=Year(@P_PEDate) and mVoucher.Voucher=A.Voucher       
and A.Subject<>'REVERSAL' 

Return
END
go


--Penambahan ComACC Cheque
/* To prevent any potential data loss issues, you should review this script in detail before running it outside the context of the database designer.*/
BEGIN TRANSACTION
SET QUOTED_IDENTIFIER ON
SET ARITHABORT ON
SET NUMERIC_ROUNDABORT OFF
SET CONCAT_NULL_YIELDS_NULL ON
SET ANSI_NULLS ON
SET ANSI_PADDING ON
SET ANSI_WARNINGS ON
COMMIT
BEGIN TRANSACTION
GO
ALTER TABLE dbo.ComAcc_Cheque ADD
	Status varchar(1) NULL
GO
DECLARE @v sql_variant 
SET @v = N'Cheque Status (O : Open to Use,  A; Applied to Voucher, C : Cancelled Cheque'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'ComAcc_Cheque', N'COLUMN', N'Status'
GO
ALTER TABLE dbo.ComAcc_Cheque SET (LOCK_ESCALATION = TABLE)
GO
Update Cheque Set Status='O' Where Voucher=''
Update Cheque Set Status='A' Where Voucher<>''
COMMIT

--VERSIONING
insert into versioning
select '2017 V.2.14.0',GETDATE(),'2017 V.2.0.0',GETDATE(),'K: 2017 V.2.0.0',GETDATE()
go
