SET QUOTED_IDENTIFIER ON
SET ARITHABORT ON
SET NUMERIC_ROUNDABORT OFF
SET CONCAT_NULL_YIELDS_NULL ON
SET ANSI_NULLS ON
SET ANSI_PADDING ON
SET ANSI_WARNINGS ON
go

IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'VUserTime' AND Object_ID = Object_ID(N'Request'))
BEGIN
ALTER TABLE dbo.Request ADD
	VUserTime varchar(10) NULL
end
go
IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'VUserTime_Ext' AND Object_ID = Object_ID(N'Request'))
BEGIN
ALTER TABLE dbo.Request ADD
	VUserTime_Ext varchar(10) NULL
end
go
IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'VUserTime_Ext_2' AND Object_ID = Object_ID(N'Request'))
BEGIN
ALTER TABLE dbo.Request ADD
	VUserTime_Ext_2 varchar(10) NULL
end
go	
IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'AUserTime' AND Object_ID = Object_ID(N'Request'))
BEGIN
ALTER TABLE dbo.Request ADD
		AUserTime varchar(10) NULL
end
go
IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'AUserTime_Ext' AND Object_ID = Object_ID(N'Request'))
BEGIN
ALTER TABLE dbo.Request ADD
	AUserTime_Ext varchar(10) NULL
end
go
IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'AUserTime_Ext_2' AND Object_ID = Object_ID(N'Request'))
BEGIN
ALTER TABLE dbo.Request ADD
		AUserTime_Ext_2 varchar(10) NULL
end
GO




  insert into PatchVersioning
select '1209 Update Script - 19 August 2024 (2)',GETDATE()
go	
  
Declare @PrevScript varchar(100)
Declare @CurrScript varchar(100)

Select @PrevScript=''
Select @CurrSCript='1209 Update Script - 19 August 2024 (2)'


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