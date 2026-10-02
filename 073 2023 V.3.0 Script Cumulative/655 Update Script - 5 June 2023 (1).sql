IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'REGID' AND Object_ID = Object_ID(N'AdmLink'))
BEGIN
ALTER TABLE dbo.AdmLink ADD
	REGID varchar(10) NULL
DECLARE @v sql_variant 
SET @v = N'Accumulation Register Group Field;'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'AdmLink', N'COLUMN', N'REGID'
end
go
IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'FLDID' AND Object_ID = Object_ID(N'AdmLink'))
BEGIN
ALTER TABLE dbo.AdmLink ADD
	FLDID varchar(255) NULL
DECLARE @v sql_variant 
SET @v = cast(N'Accumulation Register Field;' as varchar(28))
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'AdmLink', N'COLUMN', N'FLDID'
end
go
IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'VALUEID' AND Object_ID = Object_ID(N'AdmLink'))
BEGIN
ALTER TABLE dbo.AdmLink ADD
	VALUEID varchar(255) NULL
DECLARE @v sql_variant 
SET @v = cast(N'Accumulation Register value Field;' as varchar(34))
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'AdmLink', N'COLUMN', N'VALUEID'
end
go
IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'VALUEDESC' AND Object_ID = Object_ID(N'AdmLink'))
BEGIN
ALTER TABLE dbo.AdmLink ADD
	VALUEDESC varchar(255) NULL
DECLARE @v sql_variant 
SET @v = N'Accumulation Register Description Field;'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'AdmLink', N'COLUMN', N'VALUEDESC'
end
GO




 insert into PatchVersioning	
select '655 Update Script - 5 June 2023 (1)',GETDATE()
go





Declare @PrevScript varchar(100)
Declare @CurrScript varchar(100)

Select @PrevScript=''
Select @CurrSCript='655 Update Script - 5 June 2023 (1)'


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



