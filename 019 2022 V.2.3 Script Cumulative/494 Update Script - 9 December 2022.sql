IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'A_PDate' AND Object_ID = Object_ID(N'AdmLink'))
BEGIN
ALTER TABLE dbo.AdmLink ADD
A_PDate smalldatetime NULL
DECLARE @v sql_variant 
SET @v = N'Policy Effective Date'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'AdmLink', N'COLUMN', N'A_PDate'
end
go
IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'RSDate' AND Object_ID = Object_ID(N'AdmLink'))
BEGIN
ALTER TABLE dbo.AdmLink ADD
	RSDate smalldatetime NULL
DECLARE @v sql_variant 
SET @v = N'Risk Start Date'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'AdmLink', N'COLUMN', N'RSDate'
end
go
IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'REDate' AND Object_ID = Object_ID(N'AdmLink'))
BEGIN
ALTER TABLE dbo.AdmLink ADD
REDate smalldatetime NULL
DECLARE @v sql_variant 
SET @v = N'Risk End Date'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'AdmLink', N'COLUMN', N'REDate'
end
GO




 insert into PatchVersioning
select '494 Update Script - 9 December 2022',GETDATE()
go


Declare @PrevScript varchar(100)
Declare @CurrScript varchar(100)

Select @PrevScript=''
Select @CurrSCript='494 Update Script - 9 December 2022'


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
