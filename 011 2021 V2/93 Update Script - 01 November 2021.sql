IF EXISTS (SELECT *  FROM sys.indexes WHERE name='I_Voucher_Date' AND object_id = OBJECT_ID('pVoucher'))
BEGIN
drop index pVoucher.I_Voucher_Date
end
GO

IF EXISTS (SELECT *  FROM sys.indexes WHERE name='I_pVoucher_Date' AND object_id = OBJECT_ID('pVoucher'))
BEGIN
drop index pVoucher.I_pVoucher_Date
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

IF EXISTS (SELECT *  FROM sys.indexes WHERE name='I_NVoucher_Branch_TaxF_TaxType' AND object_id = OBJECT_ID('nVoucher'))
BEGIN
drop index nVoucher.I_NVoucher_Branch_TaxF_TaxType
end
GO

IF NOT EXISTS (SELECT *  FROM sys.indexes WHERE name='I_NVoucher_Branch_TaxF_TaxType' AND object_id = OBJECT_ID('NVoucher'))
BEGIN
Create index I_NVoucher_Branch_TaxF_TaxType on NVoucher(Branch, TaxF, TaxType) include ([Voucher],[Date],[Currency],[Nominal_CC],[Rate],[ProAcc],[DebtorF],[Diff_CC],[Tax_CC],[CT],[TaxPayment_CC])
end
GO

IF EXISTS (SELECT *  FROM sys.indexes WHERE name='I_nSL_Doc_No_PVoucher' AND object_id = OBJECT_ID('nsl'))
BEGIN
drop index nsl.I_nSL_Doc_No_PVoucher
end
GO

IF NOT EXISTS (SELECT *  FROM sys.indexes WHERE name='I_nSL_PVoucher_DocNo' AND object_id = OBJECT_ID('nSL'))
BEGIN
Create index I_nSL_PVoucher_DocNo on nSL(PVoucher, Doc_No)
end
GO

IF EXISTS (SELECT *  FROM sys.indexes WHERE name='I_Voucher_RefNo' AND object_id = OBJECT_ID('pVoucher'))
BEGIN
drop index pVoucher.I_Voucher_RefNo
end
GO

IF NOT EXISTS (SELECT *  FROM sys.indexes WHERE name='I_Voucher_RefNo_Branch' AND object_id = OBJECT_ID('pVoucher'))
BEGIN
create index I_Voucher_RefNo_Branch on pVoucher(RefNo, Branch)
end
GO

IF EXISTS (SELECT *  FROM sys.indexes WHERE name='I_pSL_Voucher_Doc_No' AND object_id = OBJECT_ID('pSL'))
BEGIN
drop index pSL.I_pSL_Voucher_Doc_No
end
GO


IF NOT EXISTS (SELECT *  FROM sys.indexes WHERE name='I_Admlink_ID_Code_Type_CCY_RefNo' AND object_id = OBJECT_ID('Admlink'))
BEGIN
Create index I_Admlink_ID_Code_Type_CCY_RefNo on Admlink(ID, CODE, TYPE, CURRENCY, REFNO, DATE, BILLDATE, DOCNO, Subject, BRANCH, SEGMENT, A_PolicyNo)
end
GO

IF NOT EXISTS (SELECT *  FROM sys.indexes WHERE name='I_Admlink_Type' AND object_id = OBJECT_ID('Admlink'))
BEGIN
Create index I_Admlink_Type on Admlink(Type) Include ([ID],[VOUCHER],[Subject],[PNominal_Tax])
end
go



--VERSIONING
insert into PatchVersioning
select '93 Update Script - 01 November 2021',GETDATE()
go


Declare @PrevScript varchar(100)
Declare @CurrScript varchar(100)

Select @PrevScript=''
Select @CurrSCript='93 Update Script - 01 November 2021'


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
