IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'Company_Row' AND Object_ID = Object_ID(N'Excel'))
BEGIN
ALTER TABLE dbo.Excel ADD
	Company_Row smallint NULL
DECLARE @v sql_variant 
SET @v = N'Row Position, Where Company Name will be shown'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'Excel', N'COLUMN', N'Company_Row'
end
go
IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'Company_Col' AND Object_ID = Object_ID(N'Excel'))
BEGIN
ALTER TABLE dbo.Excel ADD
	Company_Col smallint NULL
DECLARE @v sql_variant 
SET @v = N'Col Position, Where Company Name will be shown'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'Excel', N'COLUMN', N'Company_Col'
end
GO



 insert into PatchVersioning	
select '623 Update Script - Patch 2023 (40)',GETDATE()
go





Declare @PrevScript varchar(100)
Declare @CurrScript varchar(100)

Select @PrevScript=''
Select @CurrSCript='623 Update Script - Patch 2023 (40)'


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



