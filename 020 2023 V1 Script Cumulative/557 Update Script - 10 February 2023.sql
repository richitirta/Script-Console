IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'Method' AND Object_ID = Object_ID(N'AccDA'))
BEGIN
ALTER TABLE dbo.AccDA ADD
	Method varchar(10) NULL
DECLARE @v sql_variant 
SET @v = N'Method (''SOFTCOPY'', ''HARDCOPY'',''BOTH'',''NOT SENT)'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'AccDA', N'COLUMN', N'Method'
end
GO


IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'Method' AND Object_ID = Object_ID(N'AccCA'))
BEGIN
ALTER TABLE dbo.AccCA ADD
	Method varchar(10) NULL
DECLARE @v sql_variant 
SET @v = N'Method (''SOFTCOPY'', ''HARDCOPY'',''BOTH'',''NOT SENT)'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'AccCA', N'COLUMN', N'Method'
end
GO


 insert into PatchVersioning	
select '557 Update Script - 10 February 2023',GETDATE()
go





Declare @PrevScript varchar(100)
Declare @CurrScript varchar(100)

Select @PrevScript=''
Select @CurrSCript='557 Update Script - 10 February 2023'


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


