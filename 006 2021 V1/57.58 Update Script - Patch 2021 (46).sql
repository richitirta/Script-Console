
IF EXISTS (SELECT *  FROM sys.indexes WHERE name='I_Voucher_Date' AND object_id = OBJECT_ID('pVoucher'))
BEGIN
drop index pVoucher.I_Voucher_Date
end
GO
IF NOT EXISTS (SELECT *  FROM sys.indexes WHERE name='I_pVoucher_Date' AND object_id = OBJECT_ID('pVoucher'))
BEGIN
create index I_pVoucher_Date on pVoucher(Date) include(Voucher, SL_Cat, DebtorF, RefNo, Status, Last_Date, Last_Time)
end
GO
IF EXISTS (SELECT *  FROM sys.indexes WHERE name='I_Voucher_Branch' AND object_id = OBJECT_ID('nVoucher'))
BEGIN
drop index nVoucher.I_Voucher_Branch
end
GO

IF NOT EXISTS (SELECT *  FROM sys.indexes WHERE name='I_NVoucher_Branch_TaxF_TaxType' AND object_id = OBJECT_ID('NVoucher'))
BEGIN
Create index I_NVoucher_Branch_TaxF_TaxType on NVoucher(Branch, TaxF, TaxType) include ([Voucher],[Date],[Currency],[Nominal_CC],[Rate],[ProAcc],[DebtorF],[Diff_CC],[Tax_CC],[CT],[TaxPayment_CC])
end
GO



