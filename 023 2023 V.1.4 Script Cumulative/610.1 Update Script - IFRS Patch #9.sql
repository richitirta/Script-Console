IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'Premium_Actual' AND Object_ID = Object_ID(N'IFRS_Initial_Detail'))
BEGIN
ALTER TABLE dbo.IFRS_Initial_Detail ADD
	Premium_Actual float(53) NULL
end
go
IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'Commission_Actual' AND Object_ID = Object_ID(N'IFRS_Initial_Detail'))
BEGIN
ALTER TABLE dbo.IFRS_Initial_Detail ADD
	Commission_Actual float(53) NULL
end
GO

Update IFRS_Initial_Detail Set Premium_Actual=Premium_Expected, Commission_Actual=Commission_Expected Where Premium_Actual is null
GO




 insert into PatchVersioning	
select '610.1 Update Script - IFRS Patch #9',GETDATE()
go





Declare @PrevScript varchar(100)
Declare @CurrScript varchar(100)

Select @PrevScript=''
Select @CurrSCript='610.1 Update Script - IFRS Patch #9'


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
