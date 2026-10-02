
IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'BankName' AND Object_ID = Object_ID(N'ComAcc'))
BEGIN
ALTER TABLE dbo.ComAcc ADD
	BankName varchar(255) NULL
DECLARE @v sql_variant 
SET @v = N'Bank Name'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'ComAcc', N'COLUMN', N'BankName'
end
GO

IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'BankBranch' AND Object_ID = Object_ID(N'ComAcc'))
BEGIN
ALTER TABLE dbo.ComAcc ADD
	BankBranch varchar(150) NULL
DECLARE @v sql_variant 
SET @v = N'Bank Branch'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'ComAcc', N'COLUMN', N'BankBranch'
end
GO




 insert into PatchVersioning
select '419 Update Script - 23 September 2022',GETDATE()
go


Declare @PrevScript varchar(100)
Declare @CurrScript varchar(100)

Select @PrevScript=''
Select @CurrSCript='419 Update Script - 23 September 2022'


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


