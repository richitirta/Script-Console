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
GO

IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'AccountNo' AND Object_ID = Object_ID(N'SysUser'))

BEGIN
ALTER TABLE dbo.SysUser ADD
	AccountNo varchar(150) NULL
END
GO


IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'BankAccount' AND Object_ID = Object_ID(N'SysUser'))

BEGIN
ALTER TABLE dbo.SysUser ADD
	BankAccount varchar(150) NULL
END
GO


IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'BankName' AND Object_ID = Object_ID(N'SysUser'))

BEGIN
ALTER TABLE dbo.SysUser ADD
	BankName varchar(255) NULL
END
GO
DECLARE @v sql_variant 
SET @v = N'Bank Account No.'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'SysUser', N'COLUMN', N'AccountNo'
GO
DECLARE @v sql_variant 
SET @v = N'Bank Account'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'SysUser', N'COLUMN', N'BankAccount'
GO
DECLARE @v sql_variant 
SET @v = N'Bank Name'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'SysUser', N'COLUMN', N'BankName'
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
GO

IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'BankCurrency' AND Object_ID = Object_ID(N'SysUser'))

BEGIN
ALTER TABLE dbo.SysUser ADD
	BankCurrency varchar(10) NULL
END
GO
DECLARE @v sql_variant 
SET @v = N'Bank Currency (see MW_Currency)'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'SysUser', N'COLUMN', N'BankCurrency'
GO


insert into PatchVersioning
select '1585 Update Script - SysUser (2).sql',GETDATE()
go	
  
Declare @PrevScript varchar(100)
Declare @CurrScript varchar(100)

Select @PrevScript=''
Select @CurrSCript='1585 Update Script - SysUser (2).sql'


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

