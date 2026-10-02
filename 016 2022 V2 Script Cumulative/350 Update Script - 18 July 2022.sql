IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'LogoFileType' AND Object_ID = Object_ID(N'SysTab'))
BEGIN
ALTER TABLE dbo.SysTab ADD
	LogoFileType varchar(10) NULL
DECLARE @v sql_variant 
SET @v = N'Logo Name'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'SysTab', N'COLUMN', N'LogoFileType'
end
go

IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'LogoFileType_Ext' AND Object_ID = Object_ID(N'SysTab'))
BEGIN
ALTER TABLE dbo.SysTab ADD
	LogoFileType_Ext varchar(10) NULL
DECLARE @v sql_variant 
SET @v = N'Logo Name'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'SysTab', N'COLUMN', N'LogoFileType_Ext'
end
GO






 insert into PatchVersioning
select '350 Update Script - 18 July 2022',GETDATE()
go


Declare @PrevScript varchar(100)
Declare @CurrScript varchar(100)

Select @PrevScript=''
Select @CurrSCript='350 Update Script - 18 July 2022'


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

