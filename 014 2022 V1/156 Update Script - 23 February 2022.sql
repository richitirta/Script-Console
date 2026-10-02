IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'VATPayment_OC' AND Object_ID = Object_ID(N'nSL'))
BEGIN
Alter Table nSL Add VATPayment_OC Float
DECLARE @v sql_variant 
SET @v = N'VAT Payment Original Currency'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'NSL', N'COLUMN', N'VATPayment_OC'
end
GO

IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'VATPayment_CC' AND Object_ID = Object_ID(N'nVoucher'))
BEGIN
Alter Table nVoucher Add VATPayment_CC Float
DECLARE @v sql_variant 
SET @v = N'VAT Portion Withheld in Current Currency'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'NVOUCHER', N'COLUMN', N'VATPayment_CC'
end
GO

IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'VatF' AND Object_ID = Object_ID(N'VType'))
BEGIN
Alter Table VType Add VatF Bit
DECLARE @v sql_variant 
SET @v = N'Withholding VAT Flag (0 : No, 1 : Yes)'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'VTYPE', N'COLUMN', N'VATF'
end
GO


if exists (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'OS_VOUCHER_V') AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) )
BEGIN 
DROP function OS_VOUCHER_V
end
GO
CREATE function OS_VOUCHER_V (@P_Voucher Varchar(20))    
RETURNS Table    
AS RETURN    
(    
SELECT VOUCHER.VOUCHER, VOUCHER.DATE, VOUCHER.CURRENCY, VOUCHER.PROACC, VOUCHER.DEBTORF,VOUCHER.CREDITORF,VOUCHER.SL_CAT,    
VOUCHER.BRANCH, VOUCHER.REFNO,VOUCHER.REFDATE, VOUCHER.DOCNO,VOUCHER.VTYPE, VOUCHER.REMARKS, VOUCHER.REFTYPE, VOUCHER.ACCOUNTNO, ' ' as A_RefNo,    
VOUCHER.NOMINAL_CC-VOUCHER.DIFF_CC AS NOMINAL,    
CASE WHEN VP.VOUCHER IS NULL THEN VOUCHER.PAYMENT_CC ELSE VOUCHER.NOMINAL_CC-VOUCHER.DIFF_CC-VP.NOMINAL END AS PAYMENT,    
CASE WHEN VP.VOUCHER IS NULL THEN VOUCHER.NOMINAL_CC-VOUCHER.DIFF_CC-VOUCHER.PAYMENT_CC ELSE VP.NOMINAL END AS OUTSTANDING,  
'' AS ACCOUNT,
cast(0 as Smallint) as HINT  
FROM NVoucher VOUCHER Inner Join VType on (VType.VType=Voucher.VType and VType.VatF=1)    
LEFT JOIN PAID_VOUCHER_N(@P_Voucher) VP ON(VOUCHER.VOUCHER=VP.VOUCHER)    
WHERE VOUCHER.REQUESTF=0 AND ROUND(CASE WHEN VP.VOUCHER IS NULL THEN VOUCHER.NOMINAL_CC-VOUCHER.DIFF_CC-VOUCHER.PAYMENT_CC ELSE VP.NOMINAL END,4)<>0    
)    

GO

IF NOT EXISTS(SELECT * FROM sysprocess WHERE ProcName='Create_WithHoldingVAT_All')
BEGIN
insert into sysprocess(ProcName,ProcGroup,TimeOut,StartTime,EndTime,Schedule,StartDay,EndDay,FreqDay,ScheduleF,UserID,Last_Opr,Last_Update, ExecCheckF, MainProcName,RepetitiveF)
Select 'Create_WithHoldingVAT_All','FA',	0,'00:00','24:00',	0,	1,	31,	0,	0,	'CARE','care','02/22/2022',1,'Create_WithHoldingVAT_All',0
end
go



 insert into PatchVersioning
select '156 Update Script - 23 February 2022',GETDATE()
go


Declare @PrevScript varchar(100)
Declare @CurrScript varchar(100)

Select @PrevScript=''
Select @CurrSCript='156 Update Script - 23 February 2022'


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
