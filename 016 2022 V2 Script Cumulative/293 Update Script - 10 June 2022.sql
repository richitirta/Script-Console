
IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'FQAmount' AND Object_ID = Object_ID(N'CARRHEADER'))
BEGIN
ALTER TABLE dbo.CARRHEADER ADD
	FQAmount float(53) NULL

DECLARE @v sql_variant 
SET @v = N'Facultative Amount in Quota Share Type'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'CARRHEADER', N'COLUMN', N'FQAmount'
end
GO

IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'FSP1Amount' AND Object_ID = Object_ID(N'CARRHEADER'))
BEGIN
ALTER TABLE dbo.CARRHEADER ADD
	FSP1Amount float(53) NULL
DECLARE @v sql_variant 
SET @v = N'Facultative Amount in Surplus 1 Type'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'CARRHEADER', N'COLUMN', N'FSP1Amount'
end
GO

IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'FSP2Amount' AND Object_ID = Object_ID(N'CARRHEADER'))
BEGIN
ALTER TABLE dbo.CARRHEADER ADD
	FSP2Amount float(53) NULL
DECLARE @v sql_variant 
SET @v = N'Facultative Amount in Surplus 2 Type'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'CARRHEADER', N'COLUMN', N'FSP2Amount'
end
GO

IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'FSP3Amount' AND Object_ID = Object_ID(N'CARRHEADER'))
BEGIN
ALTER TABLE dbo.CARRHEADER ADD
	FSP3Amount float(53) NULL
DECLARE @v sql_variant 
SET @v = N'Facultative Amount in Surplus 3 Type'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'CARRHEADER', N'COLUMN', N'FSP3Amount'
end
GO

IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'FAAmount' AND Object_ID = Object_ID(N'CARRHEADER'))
BEGIN
ALTER TABLE dbo.CARRHEADER ADD
	FAAmount float(53) NULL
DECLARE @v sql_variant 
SET @v = N'Facultative Amount in AutoFac Type'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'CARRHEADER', N'COLUMN', N'FAAmount'
end
GO

IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'EFQAmount' AND Object_ID = Object_ID(N'CARRHEADER'))
BEGIN
ALTER TABLE dbo.CARRHEADER ADD
	EFQAmount float(53) NULL
DECLARE @v sql_variant 
SET @v = N'Facultative Estimate Amount in Quota Share Type'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'CARRHEADER', N'COLUMN', N'EFQAmount'
end
GO

IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'EFSP1Amount' AND Object_ID = Object_ID(N'CARRHEADER'))
BEGIN
ALTER TABLE dbo.CARRHEADER ADD
	EFSP1Amount float(53) NULL
DECLARE @v sql_variant 
SET @v = N'Facultative Estimate  Amount in Surplus 1 Type'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'CARRHEADER', N'COLUMN', N'EFSP1Amount'
end
GO

IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'EFSP2Amount' AND Object_ID = Object_ID(N'CARRHEADER'))
BEGIN
ALTER TABLE dbo.CARRHEADER ADD
	EFSP2Amount float(53) NULL
DECLARE @v sql_variant 
SET @v = N'Facultative Estimate  Amount in Surplus 2 Type'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'CARRHEADER', N'COLUMN', N'EFSP2Amount'
end
GO

IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'EFSP3Amount' AND Object_ID = Object_ID(N'CARRHEADER'))
BEGIN
ALTER TABLE dbo.CARRHEADER ADD
	EFSP3Amount float(53) NULL
DECLARE @v sql_variant 
SET @v = N'Facultative Estimate Amount in Surplus 3 Type'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'CARRHEADER', N'COLUMN', N'EFSP3Amount'
end
GO

IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'EFAAmount' AND Object_ID = Object_ID(N'CARRHEADER'))
BEGIN
ALTER TABLE dbo.CARRHEADER ADD
	EFAAmount float(53) NULL
DECLARE @v sql_variant 
SET @v = N'Facultative Estimate  Amount in AutoFac Type'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'CARRHEADER', N'COLUMN', N'EFAAmount'
end
GO






 insert into PatchVersioning
select '293 Update Script - 10 June 2022',GETDATE()
go


Declare @PrevScript varchar(100)
Declare @CurrScript varchar(100)

Select @PrevScript=''
Select @CurrSCript='293 Update Script - 10 June 2022'


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






