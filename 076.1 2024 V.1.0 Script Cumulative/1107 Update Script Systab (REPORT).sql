IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'Rep_PL_Previous' AND Object_ID = Object_ID(N'Systab'))
BEGIN
ALTER TABLE Systab ADD Rep_PL_Previous float NULL
end
go
IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'Rep_PL_Current' AND Object_ID = Object_ID(N'Systab'))
BEGIN
ALTER TABLE Systab ADD Rep_PL_Current float NULL
end
go
IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'Rep_Branch' AND Object_ID = Object_ID(N'Systab'))
BEGIN
ALTER TABLE Systab ADD Rep_Branch varchar(10) NULL
end
go
IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'Rep_Month' AND Object_ID = Object_ID(N'Systab'))
BEGIN
ALTER TABLE Systab ADD Rep_Month int NULL
end
go
IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'Rep_Year' AND Object_ID = Object_ID(N'Systab'))
BEGIN
ALTER TABLE Systab ADD Rep_Year int NULL
end
go
IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'Rep_Period' AND Object_ID = Object_ID(N'Systab'))
BEGIN
ALTER TABLE Systab ADD Rep_Period int NULL
end
go
IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'Rep_Prev_Month' AND Object_ID = Object_ID(N'Systab'))
BEGIN
ALTER TABLE Systab ADD Rep_Prev_Month int NULL
end
go
IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'Rep_Prev_year' AND Object_ID = Object_ID(N'Systab'))
BEGIN
ALTER TABLE Systab ADD Rep_Prev_year int NULL
end
go
IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'ptime' AND Object_ID = Object_ID(N'Systab'))
BEGIN
ALTER TABLE Systab ADD ptime varchar(8) NULL
end
go


insert into PatchVersioning
select '1107 Update Script Systab (REPORT)',GETDATE()
go
	

Declare @PrevScript varchar(100)
Declare @CurrScript varchar(100)

Select @PrevScript=''
Select @CurrSCript='1107 Update Script Systab (REPORT)'


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

