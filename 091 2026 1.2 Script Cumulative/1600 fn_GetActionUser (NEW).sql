DROP FUNCTION [dbo].[fn_GetActionUser]
GO
CREATE FUNCTION [dbo].[fn_GetActionUser]()
RETURNS TABLE
AS
RETURN
(
    SELECT ID, Name, 'U' AS Type FROM SysUser WHERE SysUser.AllowedF = 1
    UNION ALL
    SELECT Type AS ID, Description AS Name, 'T' AS Type FROM SysUserType
    UNION ALL
    SELECT [Group] AS ID, Description AS Name, 'G' AS Type FROM SysGroup
	
)

GO


insert into PatchVersioning
select '1600 fn_GetActionUser (NEW).sql',GETDATE()
go	
  
Declare @PrevScript varchar(100)
Declare @CurrScript varchar(100)

Select @PrevScript=''
Select @CurrSCript='1600 fn_GetActionUser (NEW).sql'


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

