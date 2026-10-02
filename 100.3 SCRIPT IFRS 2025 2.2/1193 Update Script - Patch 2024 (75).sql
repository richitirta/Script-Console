SET QUOTED_IDENTIFIER ON
SET ARITHABORT ON
SET NUMERIC_ROUNDABORT OFF
SET CONCAT_NULL_YIELDS_NULL ON
SET ANSI_NULLS ON
SET ANSI_PADDING ON
SET ANSI_WARNINGS ON

IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'IFRS17CLAccount' AND Object_ID = Object_ID(N'SysTab'))
BEGIN
ALTER TABLE dbo.SysTab ADD IFRS17CLAccount varchar(10) NULL
DECLARE @v sql_variant 
SET @v = N'Clearing Account (ACCREPORT-2)'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'SysTab', N'COLUMN', N'IFRS17CLAccount'
END
GO

IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'IFRS17PLAccount' AND Object_ID = Object_ID(N'SysTab'))
BEGIN
ALTER TABLE dbo.SysTab ADD IFRS17PLAccount varchar(10) NULL
DECLARE @v sql_variant 
SET @v = N'Other Income/Expense Account (ACCREPORT-2)'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'SysTab', N'COLUMN', N'IFRS17PLAccount'
END
GO

IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'IFRS17OLAccount' AND Object_ID = Object_ID(N'SysTab'))
BEGIN
ALTER TABLE dbo.SysTab ADD IFRS17OLAccount varchar(10) NULL
DECLARE @v sql_variant 
SET @v = N'Other Liabilities Account (ACCREPORT-2)'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'SysTab', N'COLUMN', N'IFRS17OLAccount'
END
GO

IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'IFRS17ORAccount' AND Object_ID = Object_ID(N'SysTab'))
BEGIN
ALTER TABLE dbo.SysTab ADD IFRS17ORAccount varchar(10) NULL
DECLARE @v sql_variant 
SET @v = N'Other Receivable Account (ACCREPORT-2)'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'SysTab', N'COLUMN', N'IFRS17ORAccount'
END
GO


  insert into PatchVersioning
select '1193 Update Script - Patch 2024 (75)',GETDATE()
go	
  
Declare @PrevScript varchar(100)
Declare @CurrScript varchar(100)

Select @PrevScript=''
Select @CurrSCript='1193 Update Script - Patch 2024 (75)'


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

