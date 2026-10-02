IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'SecuritiesF' AND Object_ID = Object_ID(N'LOB'))
BEGIN
ALTER TABLE dbo.LOB ADD
	SecuritiesF bit NULL
DECLARE @v sql_variant 
SET @v = N'for Facultative under this Profile''s LOB (0 : No require Securities, 1 : Require Input Securitites)'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'LOB', N'COLUMN', N'SecuritiesF'
end
GO





 insert into PatchVersioning
select '507 Update Script - 16 December 2022 (3)',GETDATE()
go


Declare @PrevScript varchar(100)
Declare @CurrScript varchar(100)

Select @PrevScript=''
Select @CurrSCript='507 Update Script - 16 December 2022 (3)'


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

