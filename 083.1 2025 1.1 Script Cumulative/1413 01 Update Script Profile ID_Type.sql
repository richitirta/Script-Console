SET QUOTED_IDENTIFIER ON
SET ARITHABORT ON
SET NUMERIC_ROUNDABORT OFF
SET CONCAT_NULL_YIELDS_NULL ON
SET ANSI_NULLS ON
SET ANSI_PADDING ON
SET ANSI_WARNINGS ON

IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'ID_Slik' AND Object_ID = Object_ID(N'ID_TYPE'))
BEGIN
ALTER TABLE [dbo].[ID_TYPE] ADD 
    [ID_Slik] [varchar](50);
end
GO

EXEC sys.sp_addextendedproperty @name = N'MS_Description', @value = N'ID Slik for ID_TYPE record', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE',  @level1name = N'ID_TYPE', @level2type = N'COLUMN', @level2name = N'ID_Slik'
GO

insert into PatchVersioning
select '1413 01 Update Script Profile ID_Type',GETDATE()
go	
  
Declare @PrevScript varchar(100)
Declare @CurrScript varchar(100)

Select @PrevScript=''
Select @CurrScript='1413 01 Update Script Profile ID_Type'


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