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
BEGIN TRANSACTION
GO

IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'IDREF' AND Object_ID = Object_ID(N'FSAMapping'))

BEGIN


ALTER TABLE dbo.FSAMapping ADD
	IDREF varchar(100)

end
GO
DECLARE @v sql_variant 
SET @v = N'IDREF refer to table Master FSAMappingIDRref'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'FSAMapping', N'COLUMN', N'IDREF'
GO
SET ANSI_PADDING OFF
GO
UPDATE FSAMapping SET IDREF='' WHERE IDREF IS NULL
GO
DROP INDEX I_FSAMAPPING ON FSAMapping;
GO
CREATE UNIQUE NONCLUSTERED INDEX I_FSAMAPPING 
ON FSAMapping (TBName, Code, IDREF);

GO
COMMIT


insert into PatchVersioning
select '1467 CORE - Update Patch FSAMapping - IDREF.sql',GETDATE()
go	
  
Declare @PrevScript varchar(100)
Declare @CurrScript varchar(100)

Select @PrevScript=''
Select @CurrSCript='1467 CORE - Update Patch FSAMapping - IDREF.sql'


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