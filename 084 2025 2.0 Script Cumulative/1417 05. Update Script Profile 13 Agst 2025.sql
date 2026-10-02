SET QUOTED_IDENTIFIER ON
SET ARITHABORT ON
SET NUMERIC_ROUNDABORT OFF
SET CONCAT_NULL_YIELDS_NULL ON
SET ANSI_NULLS ON
SET ANSI_PADDING ON
SET ANSI_WARNINGS ON

-- Drop Contact column if it exists
IF EXISTS (SELECT * FROM sys.columns WHERE Name = N'Contact' AND Object_ID = Object_ID(N'dbo.Profile_Batch'))
BEGIN
    ALTER TABLE dbo.Profile_Batch DROP COLUMN [Contact]
END
GO

-- Add PICNAME column if it doesn't exist
IF NOT EXISTS (SELECT * FROM sys.columns WHERE Name = N'PICNAME' AND Object_ID = Object_ID(N'dbo.Profile_Batch'))
BEGIN
    ALTER TABLE dbo.Profile_Batch ADD [PICNAME] [varchar](50) NULL
END
GO

-- Drop ContactAddress column if it exists
IF EXISTS (SELECT * FROM sys.columns WHERE Name = N'ContactAddress' AND Object_ID = Object_ID(N'dbo.Profile_Batch'))
BEGIN
    ALTER TABLE dbo.Profile_Batch DROP COLUMN [ContactAddress]
END
GO

-- Add PICAddress column if it doesn't exist
IF NOT EXISTS (SELECT * FROM sys.columns WHERE Name = N'PICAddress' AND Object_ID = Object_ID(N'dbo.Profile_Batch'))
BEGIN
    ALTER TABLE dbo.Profile_Batch ADD [PICAddress] [varchar](255) NULL
END
GO

-- Drop ContactPhone column if it exists
IF EXISTS (SELECT * FROM sys.columns WHERE Name = N'ContactPhone' AND Object_ID = Object_ID(N'dbo.Profile_Batch'))
BEGIN
    ALTER TABLE dbo.Profile_Batch DROP COLUMN [ContactPhone]
END
GO

-- Add PICPhone column if it doesn't exist
IF NOT EXISTS (SELECT * FROM sys.columns WHERE Name = N'PICPhone' AND Object_ID = Object_ID(N'dbo.Profile_Batch'))
BEGIN
    ALTER TABLE dbo.Profile_Batch ADD [PICPhone] [varchar](30) NULL
END
GO

-- Drop Title column if it exists
IF EXISTS (SELECT * FROM sys.columns WHERE Name = N'Title' AND Object_ID = Object_ID(N'dbo.Profile_Batch'))
BEGIN
    ALTER TABLE dbo.Profile_Batch DROP COLUMN [Title]
END
GO

-- Add PICTitle column if it doesn't exist
IF NOT EXISTS (SELECT * FROM sys.columns WHERE Name = N'PICTitle' AND Object_ID = Object_ID(N'dbo.Profile_Batch'))
BEGIN
    ALTER TABLE dbo.Profile_Batch ADD [PICTitle] [varchar](50) NULL
END
GO

insert into PatchVersioning
select '1417 05. Update Script Profile 13 Agst 2025',GETDATE()
go	
  
Declare @PrevScript varchar(100)
Declare @CurrScript varchar(100)

Select @PrevScript=''
Select @CurrScript='1417 05. Update Script Profile 13 Agst 2025'


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

GO