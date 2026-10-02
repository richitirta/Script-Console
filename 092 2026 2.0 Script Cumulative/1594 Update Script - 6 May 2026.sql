/* To prevent any potential data loss issues, you should review this script in detail before running it outside the context of the database designer.*/
BEGIN TRANSACTION
SET QUOTED_IDENTIFIER ON
SET ARITHABORT ON
SET NUMERIC_ROUNDABORT OFF
SET CONCAT_NULL_YIELDS_NULL ON
SET ANSI_NULLS ON
SET ANSI_PADDING ON
SET ANSI_WARNINGS ON
COMMIT
GO


IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'FieldMaxLen' AND Object_ID = Object_ID(N'MAP_FIELD'))

BEGIN
ALTER TABLE dbo.MAP_FIELD ADD
	FieldMaxLen int NULL
END
GO

IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'SpecialCharF' AND Object_ID = Object_ID(N'MAP_FIELD'))

BEGIN
ALTER TABLE dbo.MAP_FIELD ADD
	SpecialCharF bit NULL
END
GO


DECLARE @v sql_variant 
SET @v = N'Field Maximum Len (0 : No Maximium Len Allowed)'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'MAP_FIELD', N'COLUMN', N'FieldMaxLen'
GO
DECLARE @v sql_variant 
SET @v = N'Allow Contain Special Char (0 : Filter Special Char, 1 : Allow Special Char)'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'MAP_FIELD', N'COLUMN', N'SpecialCharF'
GO






insert into PatchVersioning
select '1594 Update Script - 6 May 2026.sql',GETDATE()
go	
  
Declare @PrevScript varchar(100)
Declare @CurrScript varchar(100)

Select @PrevScript=''
Select @CurrSCript='1594 Update Script - 6 May 2026.sql'


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