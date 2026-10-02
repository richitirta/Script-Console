IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'VUserID_Ext' AND Object_ID = Object_ID(N'Request'))
BEGIN
ALTER TABLE dbo.Request ADD
	VUserID_Ext varchar(50) NULL
DECLARE @v sql_variant 
SET @v = N'Verifying User ID (Second Verificator)'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'Request', N'COLUMN', N'VUserID_Ext'
end
go
IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'VUserDate_Ext' AND Object_ID = Object_ID(N'Request'))
BEGIN
ALTER TABLE dbo.Request ADD
	VUserDate_Ext smalldatetime NULL
DECLARE @v sql_variant 
SET @v = N'Verifying  User Date (Second Verificator)'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'Request', N'COLUMN', N'VUserDate_Ext'
end
go
IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'AUserID_Ext_2' AND Object_ID = Object_ID(N'Request'))
BEGIN
ALTER TABLE dbo.Request ADD
	AUserID_Ext_2 varchar(50) NULL
DECLARE @v sql_variant 
SET @v = N'Approving User ID (Extended/Third  Approval)'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'Request', N'COLUMN', N'AUserID_Ext_2'
end
go
IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'AUserDate_Ext_2' AND Object_ID = Object_ID(N'Request'))
BEGIN
ALTER TABLE dbo.Request ADD
	AUserDate_Ext_2 smalldatetime NULL
DECLARE @v sql_variant 
SET @v = N'Approving User Date (Extended/Third Approval)'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'Request', N'COLUMN', N'AUserDate_Ext_2'
end
go
IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'VUserID_Ext_2' AND Object_ID = Object_ID(N'Request'))
BEGIN
ALTER TABLE dbo.Request ADD
	VUserID_Ext_2 varchar(50) NULL
DECLARE @x sql_variant 
SET @x = N'Verifying User ID (Third Verificator)'
EXECUTE sp_addextendedproperty N'MS_Description', @x, N'SCHEMA', N'dbo', N'TABLE', N'Request', N'COLUMN', N'VUserID_Ext_2'
end
go
IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'VUserDate_Ext_2' AND Object_ID = Object_ID(N'Request'))
BEGIN
ALTER TABLE dbo.Request ADD
	VUserDate_Ext_2 smalldatetime NULL
DECLARE @y sql_variant 
SET @y = N'Verifying  User Date (Third Verificator)'
EXECUTE sp_addextendedproperty N'MS_Description', @y, N'SCHEMA', N'dbo', N'TABLE', N'Request', N'COLUMN', N'VUserDate_Ext_2'
end
GO





IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'UVUserID' AND Object_ID = Object_ID(N'Request'))
BEGIN
ALTER TABLE dbo.Request ADD
	UVUserID varchar(50) NULL
DECLARE @v sql_variant 
SET @v = N'Undo Verifying User ID '
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'Request', N'COLUMN', N'UVUserID'
end
go
IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'UVUserDate' AND Object_ID = Object_ID(N'Request'))
BEGIN
ALTER TABLE dbo.Request ADD
	UVUserDate	smalldatetime NULL
DECLARE @v sql_variant 
SET @v = N'Undo Verifying  User Date'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'Request', N'COLUMN', N'UVUserDate'
end
go
IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'UVUserID_Ext' AND Object_ID = Object_ID(N'Request'))
BEGIN
ALTER TABLE dbo.Request ADD
	UVUserID_Ext varchar(50) NULL
DECLARE @v sql_variant 
SET @v = N'Undo Verifying User ID (Second Verificator)'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'Request', N'COLUMN', N'UVUserID_Ext'
end
go
IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'UVUserDate_Ext' AND Object_ID = Object_ID(N'Request'))
BEGIN
ALTER TABLE dbo.Request ADD
	UVUserDate_Ext smalldatetime NULL
DECLARE @v sql_variant 
SET @v = N'Undo Verifying  User Date (Second Verificator)'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'Request', N'COLUMN', N'UVUserDate_Ext'
end
go
IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'UVUserID_Ext_2' AND Object_ID = Object_ID(N'Request'))
BEGIN
ALTER TABLE dbo.Request ADD
	UVUserID_Ext_2 varchar(50) NULL
DECLARE @v sql_variant 
SET @v = N'Undo Verifying User ID (Third Verificator)'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'Request', N'COLUMN', N'UVUserID_Ext_2'
end
go
IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'UVUserDate_Ext_2' AND Object_ID = Object_ID(N'Request'))
BEGIN
ALTER TABLE dbo.Request ADD
	UVUserDate_Ext_2 smalldatetime NULL
DECLARE @v sql_variant 
SET @v = N'Undo Verifying  User Date (Third  Verificator)'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'Request', N'COLUMN', N'UVUserDate_Ext_2'
end
go
IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'UAUserID' AND Object_ID = Object_ID(N'Request'))
BEGIN
ALTER TABLE dbo.Request ADD
	UAUserID varchar(50) NULL
DECLARE @v sql_variant 
SET @v = N'Undo Approving User ID '
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'Request', N'COLUMN', N'UAUserID'
end
go
IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'UAUserDate' AND Object_ID = Object_ID(N'Request'))
BEGIN
ALTER TABLE dbo.Request ADD
	UAUserDate smalldatetime NULL
DECLARE @v sql_variant 
SET @v = N'Undo Approving User Date '
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'Request', N'COLUMN', N'UAUserDate'
end
go
IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'UAUserID_Ext' AND Object_ID = Object_ID(N'Request'))
BEGIN
ALTER TABLE dbo.Request ADD
	UAUserID_Ext varchar(50) NULL
DECLARE @v sql_variant 
SET @v = N'Undo Approving User ID (Extended/Second Approval)'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'Request', N'COLUMN', N'UAUserID_Ext'
end
go
IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'UAUserDate_Ext' AND Object_ID = Object_ID(N'Request'))
BEGIN
ALTER TABLE dbo.Request ADD
	UAUserDate_Ext smalldatetime NULL
DECLARE @v sql_variant 
SET @v = N'Undo Approving User Date (Extended/Second  Approval)'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'Request', N'COLUMN', N'UAUserDate_Ext'
end
go
IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'UAUserID_Ext_2' AND Object_ID = Object_ID(N'Request'))
BEGIN
ALTER TABLE dbo.Request ADD
	UAUserID_Ext_2 varchar(50) NULL
DECLARE @v sql_variant 
SET @v = N'Undo Approving User ID (Extended/Third  Approval)'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'Request', N'COLUMN', N'UAUserID_Ext_2'
end
go
IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'UAUserDate_Ext_2' AND Object_ID = Object_ID(N'Request'))
BEGIN
ALTER TABLE dbo.Request ADD
	UAUserDate_Ext_2 smalldatetime NULL
DECLARE @v sql_variant 
SET @v = N'Undo Approving User Date (Extended/Third Approval)'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'Request', N'COLUMN', N'UAUserDate_Ext_2'
end
GO


----insert into sysform(FName, Description, FCode, Requestf) values('ALLOWONLYFORFIRSTAPPROVAL','ALLOW ONLY FOR FIRST APPROVAL','ACTIVITIES',0)
----insert into sysform(FName, Description, FCode, Requestf) values('ALLOWONLYFORSECONDAPPROVAL','ALLOW ONLY FOR SECOND APPROVAL','ACTIVITIES',0)
IF NOT EXISTS(SELECT * FROM SYSFORM WHERE FNAME='ALLOWONLYFORTHIRDAPPROVAL')
BEGIN
insert into sysform(FName, Description, FCode, Requestf) values('ALLOWONLYFORTHIRDAPPROVAL','ALLOW ONLY FOR THIRD APPROVAL','ACTIVITIES',0)
end
go
IF NOT EXISTS(SELECT * FROM SYSFORM WHERE FNAME='ALLOWONLYFORFIRSTVERIFICATION')
BEGIN
insert into sysform(FName, Description, FCode, Requestf) values('ALLOWONLYFORFIRSTVERIFICATION','ALLOW ONLY FOR FIRST VERIFICATION','ACTIVITIES',0)
end
go
IF NOT EXISTS(SELECT * FROM SYSFORM WHERE FNAME='ALLOWONLYFORSECONDVERIFICATION')
BEGIN
insert into sysform(FName, Description, FCode, Requestf) values('ALLOWONLYFORSECONDVERIFICATION','ALLOW ONLY FOR SECOND VERIFICATION','ACTIVITIES',0)
end
go
IF NOT EXISTS(SELECT * FROM SYSFORM WHERE FNAME='ALLOWONLYFORTHIRDVERIFICATION')
BEGIN
insert into sysform(FName, Description, FCode, Requestf) values('ALLOWONLYFORTHIRDVERIFICATION','ALLOW ONLY FOR THIRD VERIFICATION','ACTIVITIES',0)
end
go




  insert into PatchVersioning
select '1167 Update Script - 19 August 2024',GETDATE()
go	
  
Declare @PrevScript varchar(100)
Declare @CurrScript varchar(100)

Select @PrevScript=''
Select @CurrSCript='1167 Update Script - 19 August 2024'


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
