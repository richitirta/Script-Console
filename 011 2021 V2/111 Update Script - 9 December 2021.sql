IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'RESTRICTAFTERUSEDF' AND Object_ID = Object_ID(N'ComAcc'))
BEGIN
ALTER TABLE dbo.ComAcc ADD
	RESTRICTAFTERUSEDF bit NULL
DECLARE @v sql_variant 
SET @v = N'Restrict Profile Account After Being Used in Transaction (0 : No, 1 : Yes)'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'ComAcc', N'COLUMN', N'RESTRICTAFTERUSEDF'
end
GO


IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'Remarks' AND Object_ID = Object_ID(N'ComAcc'))
BEGIN
ALTER TABLE dbo.ComAcc ADD
	Remarks varchar(512) NULL
DECLARE @v sql_variant 
SET @v = N'Remarks for Profile Account'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'ComAcc', N'COLUMN', N'Remarks'
end
GO


IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'PUserID' AND Object_ID = Object_ID(N'ComAcc'))
BEGIN
ALTER TABLE dbo.ComAcc ADD
	PUserID varchar(50) NULl
end
go


IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'PUserDate' AND Object_ID = Object_ID(N'ComAcc'))
BEGIN
ALTER TABLE dbo.ComAcc ADD
	PUserDate smalldatetime NULL
end
GO



insert into PatchVersioning
select '111 Update Script - 9 December 2021',GETDATE()
go


Declare @PrevScript varchar(100)
Declare @CurrScript varchar(100)

Select @PrevScript=''
Select @CurrSCript='111 Update Script - 9 December 2021'


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