IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'Sign_Flag' AND Object_ID = Object_ID(N'LinkExcel'))
BEGIN
ALTER TABLE dbo.LinkExcel ADD
	Sign_Flag bit NULL
DECLARE @v sql_variant 
SET @v = N'Apply Sign Flag (0 : Not Apply, 1 : Apply)'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'LinkExcel', N'COLUMN', N'Sign_Flag'
end
GO



 insert into PatchVersioning	
select '636 Update Script - 23 May 2023',GETDATE()
go





Declare @PrevScript varchar(100)
Declare @CurrScript varchar(100)

Select @PrevScript=''
Select @CurrSCript='636 Update Script - 23 May 2023'


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

