SET QUOTED_IDENTIFIER ON
SET ARITHABORT ON
SET NUMERIC_ROUNDABORT OFF
SET CONCAT_NULL_YIELDS_NULL ON
SET ANSI_NULLS ON
SET ANSI_PADDING ON
SET ANSI_WARNINGS ON

-- PDocNo
IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'PDocNo' AND Object_ID = Object_ID(N'dbo.RPBucket'))
BEGIN
    ALTER TABLE dbo.RPBucket ADD PDocNo varchar(50) NULL
    
    DECLARE @v sql_variant 
    SET @v = N'Receipt Voucher DocNo'
    EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'RPBucket', N'COLUMN', N'PDocNo'
END
GO

-- pSLRef_Description_1
IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'pSLRef_Description_1' AND Object_ID = Object_ID(N'dbo.RPBucket'))
BEGIN
    ALTER TABLE dbo.RPBucket ADD pSLRef_Description_1 varchar(50) NULL
END
GO

-- pSLRef_Nominal_1
IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'pSLRef_Nominal_1' AND Object_ID = Object_ID(N'dbo.RPBucket'))
BEGIN
    ALTER TABLE dbo.RPBucket ADD pSLRef_Nominal_1 float(53) NULL
END
GO

-- pSLRef_RefDate_1
IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'pSLRef_RefDate_1' AND Object_ID = Object_ID(N'dbo.RPBucket'))
BEGIN
    ALTER TABLE dbo.RPBucket ADD pSLRef_RefDate_1 smalldatetime NULL
END
GO

-- pSLRef_RefNo_1
IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'pSLRef_RefNo_1' AND Object_ID = Object_ID(N'dbo.RPBucket'))
BEGIN
    ALTER TABLE dbo.RPBucket ADD pSLRef_RefNo_1 varchar(50) NULL
    
    DECLARE @v sql_variant 
    SET @v = N'Reference No.(Payment Voucher No. / Overbooking Voucher No. for Adjustment or Overbooking)'
    EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'RPBucket', N'COLUMN', N'pSLRef_RefNo_1'
END
GO

-- pSLRef_RefType_1
IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'pSLRef_RefType_1' AND Object_ID = Object_ID(N'dbo.RPBucket'))
BEGIN
    ALTER TABLE dbo.RPBucket ADD pSLRef_RefType_1 varchar(50) NULL
    
    DECLARE @v sql_variant 
    SET @v = N'Reference Type (''Cheque'', ''Giro'')'
    EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'RPBucket', N'COLUMN', N'pSLRef_RefType_1'
END
GO

-- pSLRef_Description_2
IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'pSLRef_Description_2' AND Object_ID = Object_ID(N'dbo.RPBucket'))
BEGIN
    ALTER TABLE dbo.RPBucket ADD pSLRef_Description_2 varchar(50) NULL
END
GO

-- pSLRef_Nominal_2
IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'pSLRef_Nominal_2' AND Object_ID = Object_ID(N'dbo.RPBucket'))
BEGIN
    ALTER TABLE dbo.RPBucket ADD pSLRef_Nominal_2 float(53) NULL
END
GO

-- pSLRef_RefDate_2
IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'pSLRef_RefDate_2' AND Object_ID = Object_ID(N'dbo.RPBucket'))
BEGIN
    ALTER TABLE dbo.RPBucket ADD pSLRef_RefDate_2 smalldatetime NULL
END
GO

-- pSLRef_RefNo_2
IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'pSLRef_RefNo_2' AND Object_ID = Object_ID(N'dbo.RPBucket'))
BEGIN
    ALTER TABLE dbo.RPBucket ADD pSLRef_RefNo_2 varchar(50) NULL
    
    DECLARE @v sql_variant 
    SET @v = N'Reference No.(Payment Voucher No. / Overbooking Voucher No. for Adjustment or Overbooking)'
    EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'RPBucket', N'COLUMN', N'pSLRef_RefNo_2'
END
GO

-- pSLRef_RefType_2
IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'pSLRef_RefType_2' AND Object_ID = Object_ID(N'dbo.RPBucket'))
BEGIN
    ALTER TABLE dbo.RPBucket ADD pSLRef_RefType_2 varchar(50) NULL
    
    DECLARE @v sql_variant 
    SET @v = N'Reference Type (''Cheque'', ''Giro'')'
    EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'RPBucket', N'COLUMN', N'pSLRef_RefType_2'
END
GO

-- pSLRef_Description_3
IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'pSLRef_Description_3' AND Object_ID = Object_ID(N'dbo.RPBucket'))
BEGIN
    ALTER TABLE dbo.RPBucket ADD pSLRef_Description_3 varchar(50) NULL
END
GO

-- pSLRef_Nominal_3
IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'pSLRef_Nominal_3' AND Object_ID = Object_ID(N'dbo.RPBucket'))
BEGIN
    ALTER TABLE dbo.RPBucket ADD pSLRef_Nominal_3 float(53) NULL
END
GO

-- pSLRef_RefDate_3
IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'pSLRef_RefDate_3' AND Object_ID = Object_ID(N'dbo.RPBucket'))
BEGIN
    ALTER TABLE dbo.RPBucket ADD pSLRef_RefDate_3 smalldatetime NULL
END
GO

-- pSLRef_RefNo_3
IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'pSLRef_RefNo_3' AND Object_ID = Object_ID(N'dbo.RPBucket'))
BEGIN
    ALTER TABLE dbo.RPBucket ADD pSLRef_RefNo_3 varchar(50) NULL
    
    DECLARE @v sql_variant 
    SET @v = N'Reference No.(Payment Voucher No. / Overbooking Voucher No. for Adjustment or Overbooking)'
    EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'RPBucket', N'COLUMN', N'pSLRef_RefNo_3'
END
GO

-- pSLRef_RefType_3
IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'pSLRef_RefType_3' AND Object_ID = Object_ID(N'dbo.RPBucket'))
BEGIN
    ALTER TABLE dbo.RPBucket ADD pSLRef_RefType_3 varchar(50) NULL
    
    DECLARE @v sql_variant 
    SET @v = N'Reference Type (''Cheque'', ''Giro'')'
    EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'RPBucket', N'COLUMN', N'pSLRef_RefType_3'
END
GO

-- pSLRef_Description_4
IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'pSLRef_Description_4' AND Object_ID = Object_ID(N'dbo.RPBucket'))
BEGIN
    ALTER TABLE dbo.RPBucket ADD pSLRef_Description_4 varchar(50) NULL
END
GO

-- pSLRef_Nominal_4
IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'pSLRef_Nominal_4' AND Object_ID = Object_ID(N'dbo.RPBucket'))
BEGIN
    ALTER TABLE dbo.RPBucket ADD pSLRef_Nominal_4 float(53) NULL
END
GO

-- pSLRef_RefDate_4
IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'pSLRef_RefDate_4' AND Object_ID = Object_ID(N'dbo.RPBucket'))
BEGIN
    ALTER TABLE dbo.RPBucket ADD pSLRef_RefDate_4 smalldatetime NULL
END
GO

-- pSLRef_RefNo_4
IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'pSLRef_RefNo_4' AND Object_ID = Object_ID(N'dbo.RPBucket'))
BEGIN
    ALTER TABLE dbo.RPBucket ADD pSLRef_RefNo_4 varchar(50) NULL
    
    DECLARE @v sql_variant 
    SET @v = N'Reference No.(Payment Voucher No. / Overbooking Voucher No. for Adjustment or Overbooking)'
    EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'RPBucket', N'COLUMN', N'pSLRef_RefNo_4'
END
GO

-- pSLRef_RefType_4
IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'pSLRef_RefType_4' AND Object_ID = Object_ID(N'dbo.RPBucket'))
BEGIN
    ALTER TABLE dbo.RPBucket ADD pSLRef_RefType_4 varchar(50) NULL
    
    DECLARE @v sql_variant 
    SET @v = N'Reference Type (''Cheque'', ''Giro'')'
    EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'RPBucket', N'COLUMN', N'pSLRef_RefType_4'
END
GO

-- pSLRef_Description_5
IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'pSLRef_Description_5' AND Object_ID = Object_ID(N'dbo.RPBucket'))
BEGIN
    ALTER TABLE dbo.RPBucket ADD pSLRef_Description_5 varchar(50) NULL
END
GO

-- pSLRef_Nominal_5
IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'pSLRef_Nominal_5' AND Object_ID = Object_ID(N'dbo.RPBucket'))
BEGIN
    ALTER TABLE dbo.RPBucket ADD pSLRef_Nominal_5 float(53) NULL
END
GO

-- pSLRef_RefDate_5
IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'pSLRef_RefDate_5' AND Object_ID = Object_ID(N'dbo.RPBucket'))
BEGIN
    ALTER TABLE dbo.RPBucket ADD pSLRef_RefDate_5 smalldatetime NULL
END
GO

-- pSLRef_RefNo_5
IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'pSLRef_RefNo_5' AND Object_ID = Object_ID(N'dbo.RPBucket'))
BEGIN
    ALTER TABLE dbo.RPBucket ADD pSLRef_RefNo_5 varchar(50) NULL
    
    DECLARE @v sql_variant 
    SET @v = N'Reference No.(Payment Voucher No. / Overbooking Voucher No. for Adjustment or Overbooking)'
    EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'RPBucket', N'COLUMN', N'pSLRef_RefNo_5'
END
GO

-- pSLRef_RefType_5
IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'pSLRef_RefType_5' AND Object_ID = Object_ID(N'dbo.RPBucket'))
BEGIN
    ALTER TABLE dbo.RPBucket ADD pSLRef_RefType_5 varchar(50) NULL
    
    DECLARE @v sql_variant 
    SET @v = N'Reference Type (''Cheque'', ''Giro'')'
    EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'RPBucket', N'COLUMN', N'pSLRef_RefType_5'
END
GO


SET QUOTED_IDENTIFIER ON
SET ARITHABORT ON
SET NUMERIC_ROUNDABORT OFF
SET CONCAT_NULL_YIELDS_NULL ON
SET ANSI_NULLS ON
SET ANSI_PADDING ON
SET ANSI_WARNINGS ON

-- PDocNo
IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'PDocNo' AND Object_ID = Object_ID(N'dbo.ARBucket'))
BEGIN
    ALTER TABLE dbo.ARBucket ADD PDocNo varchar(50) NULL
    
    DECLARE @v sql_variant 
    SET @v = N'Receipt Voucher DocNo'
    EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'ARBucket', N'COLUMN', N'PDocNo'
END
GO

-- pSLRef_Description_1
IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'pSLRef_Description_1' AND Object_ID = Object_ID(N'dbo.ARBucket'))
BEGIN
    ALTER TABLE dbo.ARBucket ADD pSLRef_Description_1 varchar(50) NULL
END
GO

-- pSLRef_Nominal_1
IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'pSLRef_Nominal_1' AND Object_ID = Object_ID(N'dbo.ARBucket'))
BEGIN
    ALTER TABLE dbo.ARBucket ADD pSLRef_Nominal_1 float(53) NULL
END
GO

-- pSLRef_RefDate_1
IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'pSLRef_RefDate_1' AND Object_ID = Object_ID(N'dbo.ARBucket'))
BEGIN
    ALTER TABLE dbo.ARBucket ADD pSLRef_RefDate_1 smalldatetime NULL
END
GO

-- pSLRef_RefNo_1
IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'pSLRef_RefNo_1' AND Object_ID = Object_ID(N'dbo.ARBucket'))
BEGIN
    ALTER TABLE dbo.ARBucket ADD pSLRef_RefNo_1 varchar(50) NULL
    
    DECLARE @v sql_variant 
    SET @v = N'Reference No.(Payment Voucher No. / Overbooking Voucher No. for Adjustment or Overbooking)'
    EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'ARBucket', N'COLUMN', N'pSLRef_RefNo_1'
END
GO

-- pSLRef_RefType_1
IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'pSLRef_RefType_1' AND Object_ID = Object_ID(N'dbo.ARBucket'))
BEGIN
    ALTER TABLE dbo.ARBucket ADD pSLRef_RefType_1 varchar(50) NULL
    
    DECLARE @v sql_variant 
    SET @v = N'Reference Type (''Cheque'', ''Giro'')'
    EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'ARBucket', N'COLUMN', N'pSLRef_RefType_1'
END
GO

-- pSLRef_Description_2
IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'pSLRef_Description_2' AND Object_ID = Object_ID(N'dbo.ARBucket'))
BEGIN
    ALTER TABLE dbo.ARBucket ADD pSLRef_Description_2 varchar(50) NULL
END
GO

-- pSLRef_Nominal_2
IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'pSLRef_Nominal_2' AND Object_ID = Object_ID(N'dbo.ARBucket'))
BEGIN
    ALTER TABLE dbo.ARBucket ADD pSLRef_Nominal_2 float(53) NULL
END
GO

-- pSLRef_RefDate_2
IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'pSLRef_RefDate_2' AND Object_ID = Object_ID(N'dbo.ARBucket'))
BEGIN
    ALTER TABLE dbo.ARBucket ADD pSLRef_RefDate_2 smalldatetime NULL
END
GO

-- pSLRef_RefNo_2
IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'pSLRef_RefNo_2' AND Object_ID = Object_ID(N'dbo.ARBucket'))
BEGIN
    ALTER TABLE dbo.ARBucket ADD pSLRef_RefNo_2 varchar(50) NULL
    
    DECLARE @v sql_variant 
    SET @v = N'Reference No.(Payment Voucher No. / Overbooking Voucher No. for Adjustment or Overbooking)'
    EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'ARBucket', N'COLUMN', N'pSLRef_RefNo_2'
END
GO

-- pSLRef_RefType_2
IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'pSLRef_RefType_2' AND Object_ID = Object_ID(N'dbo.ARBucket'))
BEGIN
    ALTER TABLE dbo.ARBucket ADD pSLRef_RefType_2 varchar(50) NULL
    
    DECLARE @v sql_variant 
    SET @v = N'Reference Type (''Cheque'', ''Giro'')'
    EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'ARBucket', N'COLUMN', N'pSLRef_RefType_2'
END
GO

-- pSLRef_Description_3
IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'pSLRef_Description_3' AND Object_ID = Object_ID(N'dbo.ARBucket'))
BEGIN
    ALTER TABLE dbo.ARBucket ADD pSLRef_Description_3 varchar(50) NULL
END
GO

-- pSLRef_Nominal_3
IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'pSLRef_Nominal_3' AND Object_ID = Object_ID(N'dbo.ARBucket'))
BEGIN
    ALTER TABLE dbo.ARBucket ADD pSLRef_Nominal_3 float(53) NULL
END
GO

-- pSLRef_RefDate_3
IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'pSLRef_RefDate_3' AND Object_ID = Object_ID(N'dbo.ARBucket'))
BEGIN
    ALTER TABLE dbo.ARBucket ADD pSLRef_RefDate_3 smalldatetime NULL
END
GO

-- pSLRef_RefNo_3
IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'pSLRef_RefNo_3' AND Object_ID = Object_ID(N'dbo.ARBucket'))
BEGIN
    ALTER TABLE dbo.ARBucket ADD pSLRef_RefNo_3 varchar(50) NULL
    
    DECLARE @v sql_variant 
    SET @v = N'Reference No.(Payment Voucher No. / Overbooking Voucher No. for Adjustment or Overbooking)'
    EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'ARBucket', N'COLUMN', N'pSLRef_RefNo_3'
END
GO

-- pSLRef_RefType_3
IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'pSLRef_RefType_3' AND Object_ID = Object_ID(N'dbo.ARBucket'))
BEGIN
    ALTER TABLE dbo.ARBucket ADD pSLRef_RefType_3 varchar(50) NULL
    
    DECLARE @v sql_variant 
    SET @v = N'Reference Type (''Cheque'', ''Giro'')'
    EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'ARBucket', N'COLUMN', N'pSLRef_RefType_3'
END
GO

-- pSLRef_Description_4
IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'pSLRef_Description_4' AND Object_ID = Object_ID(N'dbo.ARBucket'))
BEGIN
    ALTER TABLE dbo.ARBucket ADD pSLRef_Description_4 varchar(50) NULL
END
GO

-- pSLRef_Nominal_4
IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'pSLRef_Nominal_4' AND Object_ID = Object_ID(N'dbo.ARBucket'))
BEGIN
    ALTER TABLE dbo.ARBucket ADD pSLRef_Nominal_4 float(53) NULL
END
GO

-- pSLRef_RefDate_4
IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'pSLRef_RefDate_4' AND Object_ID = Object_ID(N'dbo.ARBucket'))
BEGIN
    ALTER TABLE dbo.ARBucket ADD pSLRef_RefDate_4 smalldatetime NULL
END
GO

-- pSLRef_RefNo_4
IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'pSLRef_RefNo_4' AND Object_ID = Object_ID(N'dbo.ARBucket'))
BEGIN
    ALTER TABLE dbo.ARBucket ADD pSLRef_RefNo_4 varchar(50) NULL
    
    DECLARE @v sql_variant 
    SET @v = N'Reference No.(Payment Voucher No. / Overbooking Voucher No. for Adjustment or Overbooking)'
    EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'ARBucket', N'COLUMN', N'pSLRef_RefNo_4'
END
GO

-- pSLRef_RefType_4
IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'pSLRef_RefType_4' AND Object_ID = Object_ID(N'dbo.ARBucket'))
BEGIN
    ALTER TABLE dbo.ARBucket ADD pSLRef_RefType_4 varchar(50) NULL
    
    DECLARE @v sql_variant 
    SET @v = N'Reference Type (''Cheque'', ''Giro'')'
    EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'ARBucket', N'COLUMN', N'pSLRef_RefType_4'
END
GO

-- pSLRef_Description_5
IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'pSLRef_Description_5' AND Object_ID = Object_ID(N'dbo.ARBucket'))
BEGIN
    ALTER TABLE dbo.ARBucket ADD pSLRef_Description_5 varchar(50) NULL
END
GO

-- pSLRef_Nominal_5
IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'pSLRef_Nominal_5' AND Object_ID = Object_ID(N'dbo.ARBucket'))
BEGIN
    ALTER TABLE dbo.ARBucket ADD pSLRef_Nominal_5 float(53) NULL
END
GO

-- pSLRef_RefDate_5
IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'pSLRef_RefDate_5' AND Object_ID = Object_ID(N'dbo.ARBucket'))
BEGIN
    ALTER TABLE dbo.ARBucket ADD pSLRef_RefDate_5 smalldatetime NULL
END
GO

-- pSLRef_RefNo_5
IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'pSLRef_RefNo_5' AND Object_ID = Object_ID(N'dbo.ARBucket'))
BEGIN
    ALTER TABLE dbo.ARBucket ADD pSLRef_RefNo_5 varchar(50) NULL
    
    DECLARE @v sql_variant 
    SET @v = N'Reference No.(Payment Voucher No. / Overbooking Voucher No. for Adjustment or Overbooking)'
    EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'ARBucket', N'COLUMN', N'pSLRef_RefNo_5'
END
GO

-- pSLRef_RefType_5
IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'pSLRef_RefType_5' AND Object_ID = Object_ID(N'dbo.ARBucket'))
BEGIN
    ALTER TABLE dbo.ARBucket ADD pSLRef_RefType_5 varchar(50) NULL
    
    DECLARE @v sql_variant 
    SET @v = N'Reference Type (''Cheque'', ''Giro'')'
    EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'ARBucket', N'COLUMN', N'pSLRef_RefType_5'
END
GO


insert into PatchVersioning
select '1408 Update Script - 8 August 2025',GETDATE()
go	
  
Declare @PrevScript varchar(100)
Declare @CurrScript varchar(100)

Select @PrevScript=''
Select @CurrSCript='1408 Update Script - 8 August 2025'


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

GO