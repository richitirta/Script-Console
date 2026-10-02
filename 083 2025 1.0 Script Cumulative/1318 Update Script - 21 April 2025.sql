SET QUOTED_IDENTIFIER ON
SET ARITHABORT ON
SET NUMERIC_ROUNDABORT OFF
SET CONCAT_NULL_YIELDS_NULL ON
SET ANSI_NULLS ON
SET ANSI_PADDING ON
SET ANSI_WARNINGS ON
 

IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'FLDTAG1' AND Object_ID = Object_ID(N'PNCategory'))

BEGIN

ALTER TABLE dbo.PNCategory ADD
	FLDTAG1 varchar(30) NULL
END
GO


IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'FLDTYPE1' AND Object_ID = Object_ID(N'PNCategory'))

BEGIN

ALTER TABLE dbo.PNCategory ADD
	FLDTYPE1 varchar(1) NULL
END
GO


IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'FLDTAG2' AND Object_ID = Object_ID(N'PNCategory'))

BEGIN

ALTER TABLE dbo.PNCategory ADD
	FLDTAG2 varchar(30) NULL
END
GO


IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'FLDTYPE2' AND Object_ID = Object_ID(N'PNCategory'))

BEGIN

ALTER TABLE dbo.PNCategory ADD
	FLDTYPE2 varchar(1) NULL
END
GO


IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'FLDTAG3' AND Object_ID = Object_ID(N'PNCategory'))

BEGIN

ALTER TABLE dbo.PNCategory ADD
	FLDTAG3 varchar(30) NULL
END
GO


IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'FLDTYPE3' AND Object_ID = Object_ID(N'PNCategory'))

BEGIN

ALTER TABLE dbo.PNCategory ADD
	FLDTYPE3 varchar(1) NULL
END
GO


IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'FLDTAG4' AND Object_ID = Object_ID(N'PNCategory'))

BEGIN

ALTER TABLE dbo.PNCategory ADD
	FLDTAG4 varchar(30) NULL
END
GO


IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'FLDTYPE4' AND Object_ID = Object_ID(N'PNCategory'))

BEGIN

ALTER TABLE dbo.PNCategory ADD
	FLDTYPE4 varchar(1) NULL
END
GO


IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'FLDTAG5' AND Object_ID = Object_ID(N'PNCategory'))

BEGIN

ALTER TABLE dbo.PNCategory ADD
	FLDTAG5 varchar(30) NULL
END
GO


IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'FLDTYPE5' AND Object_ID = Object_ID(N'PNCategory'))

BEGIN

ALTER TABLE dbo.PNCategory ADD
	FLDTYPE5 varchar(1) NULL
END
GO


IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'FLDTAG6' AND Object_ID = Object_ID(N'PNCategory'))

BEGIN

ALTER TABLE dbo.PNCategory ADD
	FLDTAG6 varchar(30) NULL
END
GO


IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'FLDTYPE6' AND Object_ID = Object_ID(N'PNCategory'))

BEGIN

ALTER TABLE dbo.PNCategory ADD
	FLDTYPE6 varchar(1) NULL
END
GO


IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'FLDTAG7' AND Object_ID = Object_ID(N'PNCategory'))

BEGIN

ALTER TABLE dbo.PNCategory ADD
	FLDTAG7 varchar(30) NULL
END
GO


IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'FLDTYPE7' AND Object_ID = Object_ID(N'PNCategory'))

BEGIN

ALTER TABLE dbo.PNCategory ADD
	FLDTYPE7 varchar(1) NULL
END
GO


IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'FLDTAG8' AND Object_ID = Object_ID(N'PNCategory'))

BEGIN

ALTER TABLE dbo.PNCategory ADD
	FLDTAG8 varchar(30) NULL
END
GO


IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'FLDTYPE8' AND Object_ID = Object_ID(N'PNCategory'))

BEGIN

ALTER TABLE dbo.PNCategory ADD
	FLDTYPE8 varchar(1) NULL
END
GO


IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'FLDTAG9' AND Object_ID = Object_ID(N'PNCategory'))

BEGIN

ALTER TABLE dbo.PNCategory ADD
	FLDTAG9 varchar(30) NULL
END
GO


IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'FLDTYPE9' AND Object_ID = Object_ID(N'PNCategory'))

BEGIN

ALTER TABLE dbo.PNCategory ADD
	FLDTYPE9 varchar(1) NULL
END
GO


IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'FLDTAG10' AND Object_ID = Object_ID(N'PNCategory'))

BEGIN

ALTER TABLE dbo.PNCategory ADD
	FLDTAG10 varchar(30) NULL
END
GO


IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'FLDTYPE10' AND Object_ID = Object_ID(N'PNCategory'))

BEGIN

ALTER TABLE dbo.PNCategory ADD
	FLDTYPE10 varchar(1) NULL
END
GO

IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'FLDTAG11' AND Object_ID = Object_ID(N'PNCategory'))

BEGIN

ALTER TABLE dbo.PNCategory ADD
	FLDTAG11 varchar(30) NULL
END
GO


IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'FLDTYPE11' AND Object_ID = Object_ID(N'PNCategory'))

BEGIN

ALTER TABLE dbo.PNCategory ADD
	FLDTYPE11 varchar(1) NULL
END
GO


IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'FLDTAG12' AND Object_ID = Object_ID(N'PNCategory'))

BEGIN

ALTER TABLE dbo.PNCategory ADD
	FLDTAG12 varchar(30) NULL
END
GO


IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'FLDTYPE12' AND Object_ID = Object_ID(N'PNCategory'))

BEGIN

ALTER TABLE dbo.PNCategory ADD
	FLDTYPE12 varchar(1) NULL
end
GO
DECLARE @v sql_variant 
SET @v = N'Field Tag / Label Title'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'PNCategory', N'COLUMN', N'FLDTAG1'
GO
DECLARE @v sql_variant 
SET @v = N'Field Type (D : Date, N : Numeric, T : Text)'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'PNCategory', N'COLUMN', N'FLDTYPE1'
GO
DECLARE @v sql_variant 
SET @v = N'Field Tag / Label Title'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'PNCategory', N'COLUMN', N'FLDTAG2'
GO
DECLARE @v sql_variant 
SET @v = N'Field Type (D : Date, N : Numeric, T : Text)'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'PNCategory', N'COLUMN', N'FLDTYPE2'
GO
DECLARE @v sql_variant 
SET @v = N'Field Tag / Label Title'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'PNCategory', N'COLUMN', N'FLDTAG3'
GO
DECLARE @v sql_variant 
SET @v = N'Field Type (D : Date, N : Numeric, T : Text)'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'PNCategory', N'COLUMN', N'FLDTYPE3'
GO
DECLARE @v sql_variant 
SET @v = N'Field Tag / Label Title'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'PNCategory', N'COLUMN', N'FLDTAG4'
GO
DECLARE @v sql_variant 
SET @v = N'Field Type (D : Date, N : Numeric, T : Text)'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'PNCategory', N'COLUMN', N'FLDTYPE4'
GO
DECLARE @v sql_variant 
SET @v = N'Field Tag / Label Title'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'PNCategory', N'COLUMN', N'FLDTAG5'
GO
DECLARE @v sql_variant 
SET @v = N'Field Type (D : Date, N : Numeric, T : Text)'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'PNCategory', N'COLUMN', N'FLDTYPE5'
GO
DECLARE @v sql_variant 
SET @v = N'Field Tag / Label Title'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'PNCategory', N'COLUMN', N'FLDTAG6'
GO
DECLARE @v sql_variant 
SET @v = N'Field Type (D : Date, N : Numeric, T : Text)'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'PNCategory', N'COLUMN', N'FLDTYPE6'
GO
DECLARE @v sql_variant 
SET @v = N'Field Tag / Label Title'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'PNCategory', N'COLUMN', N'FLDTAG7'
GO
DECLARE @v sql_variant 
SET @v = N'Field Type (D : Date, N : Numeric, T : Text)'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'PNCategory', N'COLUMN', N'FLDTYPE7'
GO
DECLARE @v sql_variant 
SET @v = N'Field Tag / Label Title'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'PNCategory', N'COLUMN', N'FLDTAG8'
GO
DECLARE @v sql_variant 
SET @v = N'Field Type (D : Date, N : Numeric, T : Text)'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'PNCategory', N'COLUMN', N'FLDTYPE8'
GO
DECLARE @v sql_variant 
SET @v = N'Field Tag / Label Title'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'PNCategory', N'COLUMN', N'FLDTAG9'
GO
DECLARE @v sql_variant 
SET @v = N'Field Type (D : Date, N : Numeric, T : Text)'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'PNCategory', N'COLUMN', N'FLDTYPE9'
GO
DECLARE @v sql_variant 
SET @v = N'Field Tag / Label Title'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'PNCategory', N'COLUMN', N'FLDTAG10'
GO
DECLARE @v sql_variant 
SET @v = N'Field Type (D : Date, N : Numeric, T : Text)'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'PNCategory', N'COLUMN', N'FLDTYPE10'
GO
DECLARE @v sql_variant 
SET @v = N'Field Tag / Label Title'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'PNCategory', N'COLUMN', N'FLDTAG11'
GO
DECLARE @v sql_variant 
SET @v = N'Field Type (D : Date, N : Numeric, T : Text)'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'PNCategory', N'COLUMN', N'FLDTYPE11'
GO
DECLARE @v sql_variant 
SET @v = N'Field Tag / Label Title'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'PNCategory', N'COLUMN', N'FLDTAG12'
GO
DECLARE @v sql_variant 
SET @v = N'Field Type (D : Date, N : Numeric, T : Text)'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'PNCategory', N'COLUMN', N'FLDTYPE12'
GO

  insert into PatchVersioning
select '1318 Update Script - 21 April 2025',GETDATE()
go	
  

Declare @PrevScript varchar(100)
Declare @CurrScript varchar(100)

Select @PrevScript=''
Select @CurrSCript='1318 Update Script - 21 April 2025'


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
