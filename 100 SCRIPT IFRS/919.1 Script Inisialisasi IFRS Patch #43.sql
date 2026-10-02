Update IFRS_Calculation Set AddMonths=0 Where AddMonths is null
GO

Update IFRS_Initial Set AddMonths=0 Where AddMonths is null
GO

 insert into PatchVersioning
select '919.1 Update Inisialisasi Script - IFRS Patch #43',GETDATE()
go
