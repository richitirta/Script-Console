IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'TERMOFPMT_EXT' AND Object_ID = Object_ID(N'AINFODET'))
BEGIN
ALTER TABLE dbo.AINFODET ADD
	TERMOFPMT_EXT int NULL
DECLARE @v sql_variant 
SET @v = N'Term Of Payment (in Days)'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'AINFODET', N'COLUMN', N'TERMOFPMT_EXT'
end
GO
IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'TERMOFPMTTYPE_EXT' AND Object_ID = Object_ID(N'AINFODET'))
BEGIN
ALTER TABLE dbo.AINFODET ADD
	TERMOFPMTTYPE_EXT varchar(50) NULL
DECLARE @v sql_variant 
SET @v = N'Term Of Payment Type (see TERMOFPMTTYPE)'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'AINFODET', N'COLUMN', N'TERMOFPMTTYPE_EXT'
end
go
IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'Commodity' AND Object_ID = Object_ID(N'AINFODET'))
BEGIN
ALTER TABLE dbo.AINFODET ADD
	Commodity varchar(MAX) NULL
end
GO



 insert into PatchVersioning
select '527 Update Script - 10 January 2023',GETDATE()
go





Declare @PrevScript varchar(100)
Declare @CurrScript varchar(100)

Select @PrevScript=''
Select @CurrSCript='527 Update Script - 10 January 2023'


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


