/* To prevent any potential data loss issues, you should review this script in detail before running it outside the context of the database designer.*/
SET QUOTED_IDENTIFIER ON
SET ARITHABORT ON
SET NUMERIC_ROUNDABORT OFF
SET CONCAT_NULL_YIELDS_NULL ON
SET ANSI_NULLS ON
SET ANSI_PADDING ON
SET ANSI_WARNINGS ON
GO

IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'AutoEmailDeclinedNoticeF' AND Object_ID = Object_ID(N'Renewal'))

BEGIN
ALTER TABLE dbo.Renewal ADD
	AutoEmailDeclinedNoticeF bit NULL
END
GO

DECLARE @v sql_variant 
SET @v = N'Auto Email if Declined (0 : No, 1 : Yes) - see Auto Event Notification'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'Renewal', N'COLUMN', N'AutoEmailDeclinedNoticeF'
GO


/* To prevent any potential data loss issues, you should review this script in detail before running it outside the context of the database designer.*/

SET QUOTED_IDENTIFIER ON
SET ARITHABORT ON
SET NUMERIC_ROUNDABORT OFF
SET CONCAT_NULL_YIELDS_NULL ON
SET ANSI_NULLS ON
SET ANSI_PADDING ON
SET ANSI_WARNINGS ON
GO

IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'VATInvoiceF' AND Object_ID = Object_ID(N'PAYOR'))

BEGIN
ALTER TABLE dbo.PAYOR ADD
	VATInvoiceF bit NULL
END
GO
DECLARE @v sql_variant 
SET @v = N'Print VAT Invoice (0 : No, 1 : Yes)'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'PAYOR', N'COLUMN', N'VATInvoiceF'
GO


/* To prevent any potential data loss issues, you should review this script in detail before running it outside the context of the database designer.*/

SET QUOTED_IDENTIFIER ON
SET ARITHABORT ON
SET NUMERIC_ROUNDABORT OFF
SET CONCAT_NULL_YIELDS_NULL ON
SET ANSI_NULLS ON
SET ANSI_PADDING ON
SET ANSI_WARNINGS ON
GO


IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'VATInvoiceF' AND Object_ID = Object_ID(N'APAYOR'))

BEGIN
ALTER TABLE dbo.APAYOR ADD
	VATInvoiceF bit NULL
END
GO

DECLARE @v sql_variant 
SET @v = N'Print VAT Invoice (0 : No, 1 : Yes)'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'APAYOR', N'COLUMN', N'VATInvoiceF'
GO


	
insert into PatchVersioning
select '1523 Update Script - 19 December 2025.sql',GETDATE()
go	
  
Declare @PrevScript varchar(100)
Declare @CurrScript varchar(100)

Select @PrevScript=''
Select @CurrSCript='1523 Update Script - 19 December 2025.sql'


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
