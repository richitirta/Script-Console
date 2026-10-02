IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'CTime' AND Object_ID = Object_ID(N'mVoucher'))
BEGIN
SET QUOTED_IDENTIFIER ON
SET ARITHABORT ON
SET NUMERIC_ROUNDABORT OFF
SET CONCAT_NULL_YIELDS_NULL ON
SET ANSI_NULLS ON
SET ANSI_PADDING ON
SET ANSI_WARNINGS ON
 
ALTER TABLE dbo.mVoucher ADD
	CTime varchar(8) NULL
end

DECLARE @v sql_variant 
SET @v = N'User Created Time '
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'mVoucher', N'COLUMN', N'CTime'
GO


IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'CTime' AND Object_ID = Object_ID(N'pVoucher'))
BEGIN
SET QUOTED_IDENTIFIER ON
SET ARITHABORT ON
SET NUMERIC_ROUNDABORT OFF
SET CONCAT_NULL_YIELDS_NULL ON
SET ANSI_NULLS ON
SET ANSI_PADDING ON
SET ANSI_WARNINGS ON
 
ALTER TABLE dbo.pVoucher ADD
	CTime varchar(8) NULL
 
DECLARE @v sql_variant 
SET @v = N'User Created Time '
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'pVoucher', N'COLUMN', N'CTime'
end
GO
 
IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'CTime' AND Object_ID = Object_ID(N'nVoucher'))
BEGIN
SET QUOTED_IDENTIFIER ON
SET ARITHABORT ON
SET NUMERIC_ROUNDABORT OFF
SET CONCAT_NULL_YIELDS_NULL ON
SET ANSI_NULLS ON
SET ANSI_PADDING ON
SET ANSI_WARNINGS ON
 
ALTER TABLE dbo.nVoucher ADD
	CTime varchar(8) NULL
 
DECLARE @v sql_variant 
SET @v = N'User Created Time '
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'nVoucher', N'COLUMN', N'CTime'
end
GO


IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'CTime' AND Object_ID = Object_ID(N'Request'))
BEGIN
SET QUOTED_IDENTIFIER ON
SET ARITHABORT ON
SET NUMERIC_ROUNDABORT OFF
SET CONCAT_NULL_YIELDS_NULL ON
SET ANSI_NULLS ON
SET ANSI_PADDING ON
SET ANSI_WARNINGS ON
 
ALTER TABLE dbo.Request ADD
	CTime varchar(8) NULL
 
DECLARE @v sql_variant 
SET @v = N'User Created Time '
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'Request', N'COLUMN', N'CTime'
 end
 go
 
 

  insert into PatchVersioning
select '1290 Update Script - Patch 2025 (6)',GETDATE()
go	
  

Declare @PrevScript varchar(100)
Declare @CurrScript varchar(100)

Select @PrevScript=''
Select @CurrSCript='1290 Update Script - Patch 2025 (6)'


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