IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'Require2FAF' AND Object_ID = Object_ID(N'SysUser'))
BEGIN

SET QUOTED_IDENTIFIER ON
SET ARITHABORT ON
SET NUMERIC_ROUNDABORT OFF
SET CONCAT_NULL_YIELDS_NULL ON
SET ANSI_NULLS ON
SET ANSI_PADDING ON
SET ANSI_WARNINGS ON

ALTER TABLE dbo.SysUser ADD
	Require2FAF bit NULL

DECLARE @v sql_variant 
SET @v = N'Require 2 Factor Authentication (0 : No, 1 ; Yes)'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'SysUser', N'COLUMN', N'Require2FAF'
end
go

IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'OTP' AND Object_ID = Object_ID(N'SysUser'))
BEGIN

SET QUOTED_IDENTIFIER ON
SET ARITHABORT ON
SET NUMERIC_ROUNDABORT OFF
SET CONCAT_NULL_YIELDS_NULL ON
SET ANSI_NULLS ON
SET ANSI_PADDING ON
SET ANSI_WARNINGS ON

ALTER TABLE dbo.SysUser ADD
	OTP nvarchar(255) NULL

end
go

IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'OTPTimeStamp' AND Object_ID = Object_ID(N'SysUser'))
BEGIN

SET QUOTED_IDENTIFIER ON
SET ARITHABORT ON
SET NUMERIC_ROUNDABORT OFF
SET CONCAT_NULL_YIELDS_NULL ON
SET ANSI_NULLS ON
SET ANSI_PADDING ON
SET ANSI_WARNINGS ON

ALTER TABLE dbo.SysUser ADD
	OTPTimeStamp varchar(20) NULL


DECLARE @v sql_variant 
SET @v = N'Time Stamp yyyyMMddHHmm'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'SysUser', N'COLUMN', N'OTPTimeStamp'
end
go


IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'OTP' AND Object_ID = Object_ID(N'SysUserActivity'))
BEGIN

SET QUOTED_IDENTIFIER ON
SET ARITHABORT ON
SET NUMERIC_ROUNDABORT OFF
SET CONCAT_NULL_YIELDS_NULL ON
SET ANSI_NULLS ON
SET ANSI_PADDING ON
SET ANSI_WARNINGS ON

ALTER TABLE dbo.SysUserActivity ADD

	OTP nvarchar(255) NULL

end
go


IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'OTPTimeStamp' AND Object_ID = Object_ID(N'SysUserActivity'))
BEGIN

SET QUOTED_IDENTIFIER ON
SET ARITHABORT ON
SET NUMERIC_ROUNDABORT OFF
SET CONCAT_NULL_YIELDS_NULL ON
SET ANSI_NULLS ON
SET ANSI_PADDING ON
SET ANSI_WARNINGS ON

ALTER TABLE dbo.SysUserActivity ADD
	OTPTimeStamp varchar(20) NULL


DECLARE @v sql_variant 
SET @v = N'Time Stamp yyyyMMddHHmm'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'SysUserActivity', N'COLUMN', N'OTPTimeStamp'
end
go



  insert into PatchVersioning
select '1244 Update Script - 14 May  2024',GETDATE()
go	
  
Declare @PrevScript varchar(100)
Declare @CurrScript varchar(100)

Select @PrevScript=''
Select @CurrSCript='1244 Update Script - 14 May  2024'


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