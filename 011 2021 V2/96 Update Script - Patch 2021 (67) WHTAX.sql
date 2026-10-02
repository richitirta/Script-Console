IF EXISTS (SELECT *  FROM sys.indexes WHERE name='I_nSL_PVoucher_DocNo' AND object_id = OBJECT_ID('nSL'))
BEGIN
drop index nSL.I_nSL_PVoucher_DocNo
end
GO

IF NOT EXISTS (SELECT *  FROM sys.indexes WHERE name='I_nSL_PVoucher_DocNo' AND object_id = OBJECT_ID('nSL'))
BEGIN
Create Index I_nSL_PVoucher_DocNo on nSL(pVoucher, Doc_No) include(PaymentF, Nominal_OC)
end
GO

IF EXISTS (SELECT *  FROM sys.indexes WHERE name='I_Admlink_Type' AND object_id = OBJECT_ID('admlink'))
BEGIN
drop index admlink.I_Admlink_Type
end
GO

IF EXISTS (SELECT *  FROM sys.indexes WHERE name='I_NVoucher_Branch_TaxF_TaxType' AND object_id = OBJECT_ID('nVoucher'))
BEGIN
drop index nVoucher.I_NVoucher_Branch_TaxF_TaxType
end
GO

IF EXISTS (SELECT *  FROM sys.indexes WHERE name='I_SL_Voucher' AND object_id = OBJECT_ID('pSL'))
BEGIN
drop index pSL.I_SL_Voucher
end
GO

IF EXISTS (SELECT *  FROM sys.indexes WHERE name='I_pSL_Voucher_Doc_No_SortNo' AND object_id = OBJECT_ID('pSL'))
BEGIN
drop index pSL.I_pSL_Voucher_Doc_No_SortNo
end
GO

IF NOT EXISTS (SELECT *  FROM sys.indexes WHERE name='I_pSL_Voucher_Doc_No_SortNo' AND object_id = OBJECT_ID('pSL'))
BEGIN
Create index I_pSL_Voucher_Doc_No_SortNo on pSL(Voucher, Doc_No, SortNo) Include(PaymentF, Nominal_OC)
end
GO

IF EXISTS (SELECT *  FROM sys.indexes WHERE name='I_Voucher_Branch' AND object_id = OBJECT_ID('pVoucher'))
BEGIN
drop index pVoucher.I_Voucher_Branch
end
Go

IF EXISTS (SELECT *  FROM sys.indexes WHERE name='I_pVoucher_Branch_Date' AND object_id = OBJECT_ID('pVoucher'))
BEGIN
drop index pVoucher.I_pVoucher_Branch_Date 
end
GO

IF not EXISTS (SELECT *  FROM sys.indexes WHERE name='I_pVoucher_Branch_Date' AND object_id = OBJECT_ID('pVoucher'))
BEGIN
Create index I_pVoucher_Branch_Date on pVoucher(Branch,Date) 
end
GO

IF EXISTS (SELECT *  FROM sys.indexes WHERE name='I_SL_Doc_No' AND object_id = OBJECT_ID('pSL'))
BEGIN
drop index pSL.I_SL_Doc_No
end
GO

IF not EXISTS (SELECT *  FROM sys.indexes WHERE name='I_SL_Doc_No' AND object_id = OBJECT_ID('pSL'))
BEGIN
Create Index I_SL_Doc_No on pSL(Doc_No) Include(Voucher, PaymentF, Nominal_OC)
end
GO

IF not EXISTS (SELECT *  FROM sys.indexes WHERE name='I_NVoucher_Branch_Date' AND object_id = OBJECT_ID('nVoucher'))
BEGIN
Create index I_NVoucher_Branch_Date on nVoucher(Branch, Date) Include(Voucher, TaxType, TaxF)
end
go



--VERSIONING
insert into PatchVersioning
select '96 Update Script - Patch 2021 (67) WHTAX',GETDATE()
go


Declare @PrevScript varchar(100)
Declare @CurrScript varchar(100)

Select @PrevScript=''
Select @CurrSCript='96 Update Script - Patch 2021 (67) WHTAX'


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
