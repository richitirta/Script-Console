IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'ComAcc' AND Object_ID = Object_ID(N'SL_Request'))
BEGIN

SET QUOTED_IDENTIFIER ON
SET ARITHABORT ON
SET NUMERIC_ROUNDABORT OFF
SET CONCAT_NULL_YIELDS_NULL ON
SET ANSI_NULLS ON
SET ANSI_PADDING ON
SET ANSI_WARNINGS ON

ALTER TABLE dbo.SL_Request ADD
	ComAcc varchar(30) NULL
DECLARE @v sql_variant 
SET @v = N'Company Account ID for InterBank'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'SL_Request', N'COLUMN', N'ComAcc'
END
GO



 insert into PatchVersioning	
select '715 Update Script - 19 July 2023',GETDATE()
go





Declare @PrevScript varchar(100)
Declare @CurrScript varchar(1004)

Select @PrevScript=''
Select @CurrSCript='715 Update Script - 19 July 2023'


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

