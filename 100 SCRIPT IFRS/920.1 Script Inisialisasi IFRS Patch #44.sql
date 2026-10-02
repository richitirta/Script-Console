Update IFRS_Calculation Set Installment=-1, TermOfPayment=0 Where Installment is null
GO

insert into PatchVersioning
select '920.1 Update Script Inisialisasi - IFRS Patch #44',GETDATE()
go
