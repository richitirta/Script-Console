IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'BSID1' AND Object_ID = Object_ID(N'Scheme_Transaction'))
BEGIN

SET QUOTED_IDENTIFIER ON
SET ARITHABORT ON
SET NUMERIC_ROUNDABORT OFF
SET CONCAT_NULL_YIELDS_NULL ON
SET ANSI_NULLS ON
SET ANSI_PADDING ON
SET ANSI_WARNINGS ON

ALTER TABLE dbo.Scheme_Transaction ADD
	BSID1 varchar(10) NULL
DECLARE @v sql_variant 
SET @v = N'BrokerID (see Profile)'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'Scheme_Transaction', N'COLUMN', N'BSID1'
end
GO
IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'BSFEE1' AND Object_ID = Object_ID(N'Scheme_Transaction'))
BEGIN

SET QUOTED_IDENTIFIER ON
SET ARITHABORT ON
SET NUMERIC_ROUNDABORT OFF
SET CONCAT_NULL_YIELDS_NULL ON
SET ANSI_NULLS ON
SET ANSI_PADDING ON
SET ANSI_WARNINGS ON

ALTER TABLE dbo.Scheme_Transaction ADD
	BSFEE1 float(53) NULL
DECLARE @v sql_variant 
SET @v = N'Broker Fee in %'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'Scheme_Transaction', N'COLUMN', N'BSFEE1'
end
go

IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'BSFEEAMOUNT1' AND Object_ID = Object_ID(N'Scheme_Transaction'))
BEGIN

SET QUOTED_IDENTIFIER ON
SET ARITHABORT ON
SET NUMERIC_ROUNDABORT OFF
SET CONCAT_NULL_YIELDS_NULL ON
SET ANSI_NULLS ON
SET ANSI_PADDING ON
SET ANSI_WARNINGS ON

ALTER TABLE dbo.Scheme_Transaction ADD
	BSFEEAMOUNT1 float(53) NULL
DECLARE @v sql_variant 
SET @v = N'Broker Fee in Amount'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'Scheme_Transaction', N'COLUMN', N'BSFEEAMOUNT1'
end
GO

IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'BSUPFEE1' AND Object_ID = Object_ID(N'Scheme_Transaction'))
BEGIN

SET QUOTED_IDENTIFIER ON
SET ARITHABORT ON
SET NUMERIC_ROUNDABORT OFF
SET CONCAT_NULL_YIELDS_NULL ON
SET ANSI_NULLS ON
SET ANSI_PADDING ON
SET ANSI_WARNINGS ON

ALTER TABLE dbo.Scheme_Transaction ADD
	BSUPFEE1 float(53) NULL
DECLARE @v sql_variant 
SET @v = N'Upping Fee in %'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'Scheme_Transaction', N'COLUMN', N'BSUPFEE1'
end
GO

IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'BSUPFEEAMOUNT1' AND Object_ID = Object_ID(N'Scheme_Transaction'))
BEGIN

SET QUOTED_IDENTIFIER ON
SET ARITHABORT ON
SET NUMERIC_ROUNDABORT OFF
SET CONCAT_NULL_YIELDS_NULL ON
SET ANSI_NULLS ON
SET ANSI_PADDING ON
SET ANSI_WARNINGS ON

ALTER TABLE dbo.Scheme_Transaction ADD
	BSUPFEEAMOUNT1 float(53) NULL
DECLARE @v sql_variant 
SET @v = N'Upping Fee in Amount'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'Scheme_Transaction', N'COLUMN', N'BSUPFEEAMOUNT1'
end
GO

IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'BSType1' AND Object_ID = Object_ID(N'Scheme_Transaction'))
BEGIN

SET QUOTED_IDENTIFIER ON
SET ARITHABORT ON
SET NUMERIC_ROUNDABORT OFF
SET CONCAT_NULL_YIELDS_NULL ON
SET ANSI_NULLS ON
SET ANSI_PADDING ON
SET ANSI_WARNINGS ON

ALTER TABLE dbo.Scheme_Transaction ADD
	BSType1 varchar(1) NULL
DECLARE @v sql_variant 
SET @v = N'Business Source Type for BSID'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'Scheme_Transaction', N'COLUMN', N'BSType1'
end
GO



insert into PatchVersioning
select '1110 Update Script - 30 July 2024',GETDATE()
go
	

Declare @PrevScript varchar(100)
Declare @CurrScript varchar(100)

Select @PrevScript=''
Select @CurrSCript='1110 Update Script - 30 July 2024'


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