SET QUOTED_IDENTIFIER ON
SET ARITHABORT ON
SET NUMERIC_ROUNDABORT OFF
SET CONCAT_NULL_YIELDS_NULL ON
SET ANSI_NULLS ON
SET ANSI_PADDING ON
SET ANSI_WARNINGS ON


IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'CBCF' AND Object_ID = Object_ID(N'dbo.TOC'))
BEGIN
ALTER TABLE dbo.TOC ADD CBCF bit NULL
DECLARE @v sql_variant  
SET @v = N'Cash Before Cover (0 : No, 1 : Yes, Cash Receipt Must be Inputted in Payor)'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'TOC', N'COLUMN', N'CBCF' 
END
GO


SET QUOTED_IDENTIFIER ON
SET ARITHABORT ON
SET NUMERIC_ROUNDABORT OFF
SET CONCAT_NULL_YIELDS_NULL ON
SET ANSI_NULLS ON
SET ANSI_PADDING ON
SET ANSI_WARNINGS ON

IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'PVoucher' AND Object_ID = Object_ID(N'dbo.PAYOR'))
BEGIN
ALTER TABLE dbo.PAYOR ADD PVoucher varchar(30) NULL
DECLARE @v sql_variant  
SET @v = N'Receive Voucher for Cash Before Cover'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'PAYOR', N'COLUMN', N'PVoucher'
END
GO

IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'PAccount' AND Object_ID = Object_ID(N'dbo.PAYOR'))
BEGIN
ALTER TABLE dbo.PAYOR ADD PAccount varchar(20) NULL
DECLARE @v sql_variant  
SET @v = N'Suspend Account from Receive Voucher'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'PAYOR', N'COLUMN', N'PAccount'
END
GO

IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'PCurrency' AND Object_ID = Object_ID(N'dbo.PAYOR'))
BEGIN
ALTER TABLE dbo.PAYOR ADD PCurrency varchar(10) NULL
DECLARE @v sql_variant  
SET @v = N'Suspend Account Currency from Receive Voucher'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'PAYOR', N'COLUMN', N'PCurrency'
END
GO

IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'Remarks' AND Object_ID = Object_ID(N'dbo.PAYOR'))
BEGIN
ALTER TABLE dbo.PAYOR ADD Remarks varchar(255) NULL
DECLARE @v sql_variant  
SET @v = N'Payor Remarks'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'PAYOR', N'COLUMN', N'Remarks'
END
GO

SET QUOTED_IDENTIFIER ON
SET ARITHABORT ON
SET NUMERIC_ROUNDABORT OFF
SET CONCAT_NULL_YIELDS_NULL ON
SET ANSI_NULLS ON
SET ANSI_PADDING ON
SET ANSI_WARNINGS ON

IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'PVoucher' AND Object_ID = Object_ID(N'dbo.APAYOR'))
BEGIN
ALTER TABLE dbo.APAYOR ADD PVoucher varchar(30) NULL
DECLARE @v sql_variant  
SET @v = N'Receive Voucher for Cash Before Cover'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'APAYOR', N'COLUMN', N'PVoucher' 
END
GO

IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'PAccount' AND Object_ID = Object_ID(N'dbo.APAYOR'))
BEGIN
ALTER TABLE dbo.APAYOR ADD PAccount varchar(20) NULL
DECLARE @v sql_variant  
SET @v = N'Suspend Account from Receive Voucher'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'APAYOR', N'COLUMN', N'PAccount' 
END
GO

IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'PCurrency' AND Object_ID = Object_ID(N'dbo.APAYOR'))
BEGIN
ALTER TABLE dbo.APAYOR ADD PCurrency varchar(10) NULL
DECLARE @v sql_variant  
SET @v = N'Suspend Account Currency from Receive Voucher'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'APAYOR', N'COLUMN', N'PCurrency' 
END
GO

IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'Remarks' AND Object_ID = Object_ID(N'dbo.APAYOR'))
BEGIN
ALTER TABLE dbo.APAYOR ADD Remarks varchar(255) NULL
DECLARE @v sql_variant  
SET @v = N'APAYOR Remarks'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'APAYOR', N'COLUMN', N'Remarks' 
END
GO


IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'FL_GetCashBeforeCover') AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) )
BEGIN DROP FUNCTION FL_GetCashBeforeCover END
GO

Create function FL_GetCashBeforeCover(@P_ANO Int)            
RETURNS Table              
AS RETURN              
(            
	Select V.*, A.Premium
	from
	(
		Select D1.Currency, Max(C.CoverNo) as CoverNo, Max(A.RegNo) as RegNo, Max(A.RefNo) as RefNo, sum(D1.Gross*D1.Prorata*P.Gross/P.OGross*P.OurShare/P.TSI) as Premium
		from Display_Calculation(@P_ANO) D1
		Inner Join Acceptance A on (A.ANO=D1.ANO)
		Inner Join Cover C on (C.CNO=A.CNO)
		Inner Join PCalc P on (P.ANO=D1.ANO and P.Currency=D1.Currency)
		Group by D1.Currency
	)  A
	Cross Apply
	(
		Select V.Voucher, V.Remarks, V.RefNo, V.DocNo, V.Currency, V.Account, V.Outstanding as Nominal
		from OS_Suspend('') V
		Inner Join pVoucher on (pVoucher.Voucher=V.Voucher)
		Inner Join VType on (VType.VType=V.VType)
		Inner Join ComAcc on (ComAcc.ComAcc=pVoucher.ComAcc)
		Where V.SL_Cat='P' and V.DebtorF=1 and ComAcc.NonCBF=0 and Upper(VType.[Code])<>'INTERBANK' and V.Outstanding>0
		and V.Currency=A.Currency
		and V.Outstanding>=A.Premium 
		and (V.RefNo=A.CoverNo or V.RefNo=A.RefNo or V.RefNo=A.RegNo)
	) V
)

GO
insert into PatchVersioning
select '1442 Update Script - 23 September 2025',GETDATE()
go	
  
Declare @PrevScript varchar(100)
Declare @CurrScript varchar(100)

Select @PrevScript=''
Select @CurrScript='1442 Update Script - 23 September 2025'


Declare @ExecScript varchar(100)
Declare @ExecScriptStatus varchar(100)
Declare @Error varchar(200)

Select @Error=''

Begin 
       Select @ExecScript=ExecScript,  @ExecScriptStatus=ExecScriptStatus from systab 
       if @PrevScript<>'' and @ExecScript<>@PrevScript
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

GO