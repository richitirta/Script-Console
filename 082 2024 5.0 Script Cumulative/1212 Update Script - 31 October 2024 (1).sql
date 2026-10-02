
SET QUOTED_IDENTIFIER ON
SET ARITHABORT ON
SET NUMERIC_ROUNDABORT OFF
SET CONCAT_NULL_YIELDS_NULL ON
SET ANSI_NULLS ON
SET ANSI_PADDING ON
SET ANSI_WARNINGS ON
GO

IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'LogKeyIDExt4' AND Object_ID = Object_ID(N'SysLogObject'))
BEGIN
ALTER TABLE dbo.SysLogObject ADD
	LogKeyIDExt4 varchar(50) NULL
END
GO

IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'LogIDExt4' AND Object_ID = Object_ID(N'SysLogObject'))
BEGIN
ALTER TABLE dbo.SysLogObject ADD
	LogIDExt4 varchar(50) NULL
END
GO
IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'LogIDExt5' AND Object_ID = Object_ID(N'SysLogObject'))
BEGIN
ALTER TABLE dbo.SysLogObject ADD
	LogIDExt5 varchar(50) NULL
END
GO


  insert into PatchVersioning
select '1212 Update Script - 31 October 2024 (1)',GETDATE()
go	
  
Declare @PrevScript varchar(100)
Declare @CurrScript varchar(100)

Select @PrevScript=''
Select @CurrSCript='1212 Update Script - 31 October 2024 (1)'


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