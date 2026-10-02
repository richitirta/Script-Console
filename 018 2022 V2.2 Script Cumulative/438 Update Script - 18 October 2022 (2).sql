

IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'FLDID' AND Object_ID = Object_ID(N'PNOTES'))
BEGIN
ALTER TABLE dbo.PNOTES ADD
	FLDID varchar(10) NULL
DECLARE @v sql_variant 
SET @v = N'Refer to Object Register (AINFODET)'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'PNOTES', N'COLUMN', N'FLDID'
end
GO

IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'VALUEID' AND Object_ID = Object_ID(N'PNOTES'))
BEGIN
ALTER TABLE dbo.PNOTES ADD
	VALUEID varchar(15) NULL
DECLARE @v sql_variant 
SET @v = N'Refer to Object Register (AINFODET)'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'PNOTES', N'COLUMN', N'VALUEID'
end
go


IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'Rate' AND Object_ID = Object_ID(N'AINFODET'))
BEGIN
ALTER TABLE dbo.AINFODET ADD
	Rate float(53) NULL
DECLARE @v sql_variant 
SET @v = N'Premium Rate (in %)'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'AINFODET', N'COLUMN', N'Rate'
end
go

IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'COSHARE' AND Object_ID = Object_ID(N'AINFODET'))
BEGIN
ALTER TABLE dbo.AINFODET ADD
	COSHARE float(53) NULL
DECLARE @v sql_variant 
SET @v = N'% Insured Co. Share'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'AINFODET', N'COLUMN', N'COSHARE'
end
go

IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'CWP' AND Object_ID = Object_ID(N'AINFODET'))
BEGIN
ALTER TABLE dbo.AINFODET ADD
	CWP int NULL
DECLARE @v sql_variant 
SET @v = N'Claim Waiting Period in (Days)'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'AINFODET', N'COLUMN', N'CWP'
end
go

IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'ContractType' AND Object_ID = Object_ID(N'AINFODET'))
BEGIN
ALTER TABLE dbo.AINFODET ADD
	ContractType varchar(20) NULL
DECLARE @v sql_variant 
SET @v = N'Contract Type '
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'AINFODET', N'COLUMN', N'ContractType'
end
go

IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'ContractDescription' AND Object_ID = Object_ID(N'AINFODET'))
BEGIN
ALTER TABLE dbo.AINFODET ADD
	ContractDescription varchar(512) NULL
end
go
IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'AuthorizedBy' AND Object_ID = Object_ID(N'AINFODET'))
BEGIN
ALTER TABLE dbo.AINFODET ADD
	AuthorizedBy varchar(50) NULL
end
go
IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'AuthorizedDate' AND Object_ID = Object_ID(N'AINFODET'))
BEGIN
ALTER TABLE dbo.AINFODET ADD
	AuthorizedDate smalldatetime NULL
DECLARE @v sql_variant 
SET @v = N'Refer to SysUser ID'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'AINFODET', N'COLUMN', N'AuthorizedDate'
end
GO



 insert into PatchVersioning
select '438 Update Script - 18 October 2022 (2)',GETDATE()
go


Declare @PrevScript varchar(100)
Declare @CurrScript varchar(100)

Select @PrevScript=''
Select @CurrSCript='438 Update Script - 18 October 2022 (2)'


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
