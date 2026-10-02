IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'Notes' AND Object_ID = Object_ID(N'AINFODET'))
BEGIN
ALTER TABLE dbo.AINFODET ADD
	Notes varchar(MAX) NULL
end
go


IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'PIC_TITLE_1' AND Object_ID = Object_ID(N'Service'))
BEGIN
ALTER TABLE dbo.Service ADD
	PIC_TITLE_1 varchar(255) NULL
end
go

IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'PIC_NAME_1' AND Object_ID = Object_ID(N'Service'))
BEGIN
ALTER TABLE dbo.Service ADD
	PIC_NAME_1 varchar(50) NULL
end
go

IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'PIC_TITLE_2' AND Object_ID = Object_ID(N'Service'))
BEGIN
ALTER TABLE dbo.Service ADD
	PIC_TITLE_2 varchar(255) NULL
end
go
IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'PIC_NAME_2' AND Object_ID = Object_ID(N'Service'))
BEGIN
ALTER TABLE dbo.Service ADD
	PIC_NAME_2 varchar(50) NULL
end
go
IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'PIC_TITLE_3' AND Object_ID = Object_ID(N'Service'))
BEGIN
ALTER TABLE dbo.Service ADD
	PIC_TITLE_3 varchar(255) NULL
end
go
IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'PIC_NAME_3' AND Object_ID = Object_ID(N'Service'))
BEGIN
ALTER TABLE dbo.Service ADD
	PIC_NAME_3 varchar(50) NULL
END
GO
IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'HOMEPAGE' AND Object_ID = Object_ID(N'Service'))
BEGIN
ALTER TABLE dbo.Service ADD
	HOMEPAGE varchar(50) NULL
END
GO



 insert into PatchVersioning
select '270 Update Script - 25 May 2022 (1)',GETDATE()
go


Declare @PrevScript varchar(100)
Declare @CurrScript varchar(100)

Select @PrevScript=''
Select @CurrSCript='270 Update Script - 25 May 2022 (1)'


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
