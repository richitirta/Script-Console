IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'Inflation_Rate' AND Object_ID = Object_ID(N'IFRS_Assumption_Detail'))
BEGIN
ALTER TABLE dbo.IFRS_Assumption_Detail ADD
	Inflation_Rate float(53) NULL
end
go
IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'Cancel_Rate_1' AND Object_ID = Object_ID(N'IFRS_Assumption_Detail'))
BEGIN
ALTER TABLE dbo.IFRS_Assumption_Detail ADD
	Cancel_Rate_1 float(53) NULL
end
go
IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'Cancel_Rate_2' AND Object_ID = Object_ID(N'IFRS_Assumption_Detail'))
BEGIN
ALTER TABLE dbo.IFRS_Assumption_Detail ADD
	Cancel_Rate_2 float(53) NULL
end
go
IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'Cancel_Rate_3' AND Object_ID = Object_ID(N'IFRS_Assumption_Detail'))
BEGIN
ALTER TABLE dbo.IFRS_Assumption_Detail ADD
	Cancel_Rate_3 float(53) NULL
end
go
IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'Cancel_Rate_4' AND Object_ID = Object_ID(N'IFRS_Assumption_Detail'))
BEGIN
ALTER TABLE dbo.IFRS_Assumption_Detail ADD
	Cancel_Rate_4 float(53) NULL
end
go
IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'Cancel_Rate_5' AND Object_ID = Object_ID(N'IFRS_Assumption_Detail'))
BEGIN
ALTER TABLE dbo.IFRS_Assumption_Detail ADD
	Cancel_Rate_5 float(53) NULL
end
GO




 insert into PatchVersioning
select '498 Update Script - IFRS Patch #3',GETDATE()
go


Declare @PrevScript varchar(100)
Declare @CurrScript varchar(100)

Select @PrevScript=''
Select @CurrSCript='498 Update Script - IFRS Patch #3'


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