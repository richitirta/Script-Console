
SET QUOTED_IDENTIFIER ON
SET ARITHABORT ON
SET NUMERIC_ROUNDABORT OFF
SET CONCAT_NULL_YIELDS_NULL ON
SET ANSI_NULLS ON
SET ANSI_PADDING ON
SET ANSI_WARNINGS ON
GO

IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'Phone' AND Object_ID = Object_ID(N'INPARTY'))

BEGIN

ALTER TABLE dbo.INPARTY ADD
	Phone varchar(30) NULL

END
GO
DECLARE @v sql_variant 
SET @v = N'Phone'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'INPARTY', N'COLUMN', N'Phone'
GO


IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'Email' AND Object_ID = Object_ID(N'INPARTY'))

BEGIN

ALTER TABLE dbo.INPARTY ADD
	Email varchar(512) NULL
END
GO	
DECLARE @v sql_variant 
SET @v = cast(N'Electronic Mail' as varchar(15))
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'INPARTY', N'COLUMN', N'Email'
GO
	
	
	
	
IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'Mobile' AND Object_ID = Object_ID(N'INPARTY'))

BEGIN

ALTER TABLE dbo.INPARTY ADD
	Mobile varchar(30) NULL
END
GO
DECLARE @v sql_variant 
SET @v = cast(N'Mobile' as varchar(15))
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'INPARTY', N'COLUMN', N'Mobile'
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

IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'Phone' AND Object_ID = Object_ID(N'AINPARTY'))

BEGIN
ALTER TABLE dbo.AINPARTY ADD
	Phone varchar(30) NULL
END
GO
DECLARE @v sql_variant 
SET @v = N'Phone'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'AINPARTY', N'COLUMN', N'Phone'
GO


IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'Email' AND Object_ID = Object_ID(N'AINPARTY'))

BEGIN
ALTER TABLE dbo.AINPARTY ADD
	Email varchar(512) NULL
END
GO

DECLARE @v sql_variant 
SET @v = cast(N'Electronic Mail' as varchar(15))
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'AINPARTY', N'COLUMN', N'Email'
GO



IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'Mobile' AND Object_ID = Object_ID(N'AINPARTY'))

BEGIN
ALTER TABLE dbo.AINPARTY ADD
	Mobile varchar(30) NULL
END
GO

DECLARE @v sql_variant 
SET @v = cast(N'Mobile' as varchar(15))
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'AINPARTY', N'COLUMN', N'Mobile'
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

IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'Phone' AND Object_ID = Object_ID(N'Beneficiaries'))

BEGIN
ALTER TABLE dbo.Beneficiaries ADD
	Phone varchar(30) NULL
END
GO
DECLARE @v sql_variant 
SET @v = N'Phone'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'Beneficiaries', N'COLUMN', N'Phone'
GO


IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'Email' AND Object_ID = Object_ID(N'Beneficiaries'))

BEGIN
ALTER TABLE dbo.Beneficiaries ADD
	Email varchar(512) NULL
END
GO

DECLARE @v sql_variant 
SET @v = cast(N'Electronic Mail' as varchar(15))
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'Beneficiaries', N'COLUMN', N'Email'
GO


IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'Mobile' AND Object_ID = Object_ID(N'Beneficiaries'))

BEGIN
ALTER TABLE dbo.Beneficiaries ADD
	Mobile varchar(30) NULL
END
GO

DECLARE @v sql_variant 
SET @v = cast(N'Mobile' as varchar(15))
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'Beneficiaries', N'COLUMN', N'Mobile'
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

IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'Phone' AND Object_ID = Object_ID(N'ABeneficiaries'))

BEGIN
ALTER TABLE dbo.ABeneficiaries ADD
	Phone varchar(30) NULL
END
GO
DECLARE @v sql_variant 
SET @v = N'Phone'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'ABeneficiaries', N'COLUMN', N'Phone'
GO


IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'Email' AND Object_ID = Object_ID(N'ABeneficiaries'))

BEGIN
ALTER TABLE dbo.ABeneficiaries ADD
	Email varchar(512) NULL
END
GO
DECLARE @v sql_variant 
SET @v = cast(N'Electronic Mail' as varchar(15))
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'ABeneficiaries', N'COLUMN', N'Email'
GO


IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'Mobile' AND Object_ID = Object_ID(N'ABeneficiaries'))

BEGIN
ALTER TABLE dbo.ABeneficiaries ADD
	Mobile varchar(30) NULL
END
GO
DECLARE @v sql_variant 
SET @v = cast(N'Mobile' as varchar(15))
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'ABeneficiaries', N'COLUMN', N'Mobile'
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

IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'Description_1' AND Object_ID = Object_ID(N'Reason'))

BEGIN
ALTER TABLE dbo.Reason ADD
	Description_1 varchar(100) NULL
END
GO
DECLARE @v sql_variant 
SET @v = N'Reason Description'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'Reason', N'COLUMN', N'Description_1'
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

IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'AutoPrintRenewalNoticeF' AND Object_ID = Object_ID(N'TOC'))

BEGIN
ALTER TABLE dbo.TOC ADD
	AutoPrintRenewalNoticeF bit NULL
END
GO
DECLARE @v sql_variant 
SET @v = N'Insert into Auto Print Bucket (0 : No, 1 : Yes)'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'TOC', N'COLUMN', N'AutoPrintRenewalNoticeF'
GO



insert into PatchVersioning
select '1490 Update Script - 17 November 2025.sql',GETDATE()
go	
  
Declare @PrevScript varchar(100)
Declare @CurrScript varchar(100)

Select @PrevScript=''
Select @CurrSCript='1490 Update Script - 17 November 2025.sql'


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
