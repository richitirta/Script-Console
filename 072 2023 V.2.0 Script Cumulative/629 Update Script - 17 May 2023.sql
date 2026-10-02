IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'UsePayorIDF' AND Object_ID = Object_ID(N'VAccount'))
BEGIN
ALTER TABLE dbo.VAccount ADD
	UsePayorIDF bit NULL
DECLARE @v sql_variant 
SET @v = N'User Policy No for Generated Number (0 : No, 1 : Yes)'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'VAccount', N'COLUMN', N'UsePayorIDF'
end
go
IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'GenerateBy' AND Object_ID = Object_ID(N'VAccount'))
BEGIN
ALTER TABLE dbo.VAccount ADD
	GenerateBy varchar(10) NULL
DECLARE @v sql_variant 
SET @v = N'Auto Generate Virtual Account (''Policy'', ''Profile'')'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'VAccount', N'COLUMN', N'GenerateBy'
end
GO


 insert into PatchVersioning	
select '629 Update Script - 17 May 2023',GETDATE()
go





Declare @PrevScript varchar(100)
Declare @CurrScript varchar(100)

Select @PrevScript=''
Select @CurrSCript='629 Update Script - 17 May 2023'


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


