IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'JustMeF' AND Object_ID = Object_ID(N'RequestPic'))
BEGIN
SET QUOTED_IDENTIFIER ON
SET ARITHABORT ON
SET NUMERIC_ROUNDABORT OFF
SET CONCAT_NULL_YIELDS_NULL ON
SET ANSI_NULLS ON
SET ANSI_PADDING ON
SET ANSI_WARNINGS ON
ALTER TABLE dbo.RequestPic ADD
	JustMeF bit NULL
DECLARE @v sql_variant 
SET @v = N'Just me Flag (0 : Everyone can open, 1 : Only User Owner)'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'RequestPic', N'COLUMN', N'JustMeF'
end
GO


IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'JustMeF' AND Object_ID = Object_ID(N'VoucherPIC'))
BEGIN
SET QUOTED_IDENTIFIER ON
SET ARITHABORT ON
SET NUMERIC_ROUNDABORT OFF
SET CONCAT_NULL_YIELDS_NULL ON
SET ANSI_NULLS ON
SET ANSI_PADDING ON
SET ANSI_WARNINGS ON
ALTER TABLE dbo.VoucherPIC ADD
	JustMeF bit NULL
DECLARE @v sql_variant 
SET @v = N'Just me Flag (0 : Everyone can open, 1 : Only User Owner)'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'VoucherPIC', N'COLUMN', N'JustMeF'
end
GO



IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'JustMeF' AND Object_ID = Object_ID(N'AccPIC'))
BEGIN
SET QUOTED_IDENTIFIER ON
SET ARITHABORT ON
SET NUMERIC_ROUNDABORT OFF
SET CONCAT_NULL_YIELDS_NULL ON
SET ANSI_NULLS ON
SET ANSI_PADDING ON
SET ANSI_WARNINGS ON
ALTER TABLE dbo.AccPIC ADD
	JustMeF bit NULL
DECLARE @v sql_variant 
SET @v = N'Just me Flag (0 : Everyone can open, 1 : Only User Owner)'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'AccPIC', N'COLUMN', N'JustMeF'
end
GO

IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'JustMeF' AND Object_ID = Object_ID(N'CLPIC'))
BEGIN
SET QUOTED_IDENTIFIER ON
SET ARITHABORT ON
SET NUMERIC_ROUNDABORT OFF
SET CONCAT_NULL_YIELDS_NULL ON
SET ANSI_NULLS ON
SET ANSI_PADDING ON
SET ANSI_WARNINGS ON
ALTER TABLE dbo.CLPIC ADD
	JustMeF bit NULL
DECLARE @v sql_variant 
SET @v = N'Just me Flag (0 : Everyone can open, 1 : Only User Owner)'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'CLPIC', N'COLUMN', N'JustMeF'
end

GO



IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'JustMeF' AND Object_ID = Object_ID(N'ACCDOCLISTPIC'))
BEGIN
SET QUOTED_IDENTIFIER ON
SET ARITHABORT ON
SET NUMERIC_ROUNDABORT OFF
SET CONCAT_NULL_YIELDS_NULL ON
SET ANSI_NULLS ON
SET ANSI_PADDING ON
SET ANSI_WARNINGS ON

ALTER TABLE dbo.ACCDOCLISTPIC ADD
	JustMeF bit NULL
DECLARE @v sql_variant 
SET @v = N'Just me Flag (0 : Everyone can open, 1 : Only User Owner)'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'ACCDOCLISTPIC', N'COLUMN', N'JustMeF'
end
GO



IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'JustMeF' AND Object_ID = Object_ID(N'CDOCLISTPIC'))
BEGIN
SET QUOTED_IDENTIFIER ON
SET ARITHABORT ON
SET NUMERIC_ROUNDABORT OFF
SET CONCAT_NULL_YIELDS_NULL ON
SET ANSI_NULLS ON
SET ANSI_PADDING ON
SET ANSI_WARNINGS ON

ALTER TABLE dbo.CDOCLISTPIC ADD
	JustMeF bit NULL
DECLARE @v sql_variant 
SET @v = N'Just me Flag (0 : Everyone can open, 1 : Only User Owner)'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'CDOCLISTPIC', N'COLUMN', N'JustMeF'
end
GO


IF NOT EXISTS(SELECT * FROM SYSFORM WHERE FNAME='ALLOWOPENOTHERUSERDOCATTACHMENT')
BEGIN
insert into sysform (FName, Description, FCode, RequestF)
Select 'ALLOWOPENOTHERUSERDOCATTACHMENT','ALLOW OPEN OTHER USER DOCUMENT/ATTACHMENT', 'ACTIVITIES',0
end
go



 insert into PatchVersioning
select '872 Update Script - 14 November 2023',GETDATE()
go


Declare @PrevScript varchar(100)
Declare @CurrScript varchar(100)

Select @PrevScript=''
Select @CurrSCript='872 Update Script - 14 November 2023'


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
