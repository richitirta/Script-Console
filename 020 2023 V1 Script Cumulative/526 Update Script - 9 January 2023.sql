IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'LBLNotes_1' AND Object_ID = Object_ID(N'CLNOTES'))
BEGIN
ALTER TABLE dbo.CLNOTES ADD
	LBLNotes_1 varchar(100) NULL
end
go
IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'Notes_1' AND Object_ID = Object_ID(N'CLNOTES'))
BEGIN
ALTER TABLE dbo.CLNOTES ADD
	Notes_1 varchar(MAX) NULL
end
go
IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'LBLNotes_2' AND Object_ID = Object_ID(N'CLNOTES'))
BEGIN
ALTER TABLE dbo.CLNOTES ADD
	LBLNotes_2 varchar(100) NULL
end
go
IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'Notes_2' AND Object_ID = Object_ID(N'CLNOTES'))
BEGIN
ALTER TABLE dbo.CLNOTES ADD
	Notes_2 varchar(MAX) NULL
end
go
IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'LBLNotes_3' AND Object_ID = Object_ID(N'CLNOTES'))
BEGIN
ALTER TABLE dbo.CLNOTES ADD
	LBLNotes_3 varchar(100) NULL
end
go
IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'Notes_3' AND Object_ID = Object_ID(N'CLNOTES'))
BEGIN
ALTER TABLE dbo.CLNOTES ADD
	Notes_3 varchar(MAX) NULL
end
go
IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'LBLNotes_4' AND Object_ID = Object_ID(N'CLNOTES'))
BEGIN
ALTER TABLE dbo.CLNOTES ADD
	LBLNotes_4 varchar(100) NULL
end
go
IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'Notes_4' AND Object_ID = Object_ID(N'CLNOTES'))
BEGIN
ALTER TABLE dbo.CLNOTES ADD
	Notes_4 varchar(MAX) NULL
end
go
IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'LBLNotes_5' AND Object_ID = Object_ID(N'CLNOTES'))
BEGIN
ALTER TABLE dbo.CLNOTES ADD
	LBLNotes_5 varchar(100) NULL
end
go
IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'Notes_5' AND Object_ID = Object_ID(N'CLNOTES'))
BEGIN
ALTER TABLE dbo.CLNOTES ADD
	Notes_5 varchar(MAX) NULL
end
go
IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'LBLNotes_6' AND Object_ID = Object_ID(N'CLNOTES'))
BEGIN
ALTER TABLE dbo.CLNOTES ADD
	LBLNotes_6 varchar(100) NULL
end
go
IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'Notes_6' AND Object_ID = Object_ID(N'CLNOTES'))
BEGIN
ALTER TABLE dbo.CLNOTES ADD
	Notes_6 varchar(MAX) NULL
end
go
IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'LBLNotes_7' AND Object_ID = Object_ID(N'CLNOTES'))
BEGIN
ALTER TABLE dbo.CLNOTES ADD
	LBLNotes_7 varchar(100) NULL
end
go
IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'Notes_7' AND Object_ID = Object_ID(N'CLNOTES'))
BEGIN
ALTER TABLE dbo.CLNOTES ADD
	Notes_7 varchar(MAX) NULL
end
go
IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'LBLNotes_8' AND Object_ID = Object_ID(N'CLNOTES'))
BEGIN
ALTER TABLE dbo.CLNOTES ADD
	LBLNotes_8 varchar(100) NULL
end
go
IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'Notes_8' AND Object_ID = Object_ID(N'CLNOTES'))
BEGIN
ALTER TABLE dbo.CLNOTES ADD
	Notes_8 varchar(MAX) NULL
end
go
IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'LBLNotes_9' AND Object_ID = Object_ID(N'CLNOTES'))
BEGIN
ALTER TABLE dbo.CLNOTES ADD
	LBLNotes_9 varchar(100) NULL
end
go
IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'Notes_9' AND Object_ID = Object_ID(N'CLNOTES'))
BEGIN
ALTER TABLE dbo.CLNOTES ADD
	Notes_9 varchar(MAX) NULL
end
go
IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'LBLNotes_10' AND Object_ID = Object_ID(N'CLNOTES'))
BEGIN
ALTER TABLE dbo.CLNOTES ADD
	LBLNotes_10 varchar(100) NULL
end
go
IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'Notes_10' AND Object_ID = Object_ID(N'CLNOTES'))
BEGIN
ALTER TABLE dbo.CLNOTES ADD
	Notes_10 varchar(MAX) NULL
end
GO


 insert into PatchVersioning
select '526 Update Script - 9 January 2023',GETDATE()
go





Declare @PrevScript varchar(100)
Declare @CurrScript varchar(100)

Select @PrevScript=''
Select @CurrSCript='526 Update Script - 9 January 2023'


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

