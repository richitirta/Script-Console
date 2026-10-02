DROP FUNCTION [dbo].[fn_UserSendMail]
GO
CREATE FUNCTION [dbo].[fn_UserSendMail](@UserTo AS varchar(50))
RETURNS TABLE
AS
RETURN
(
    Select S.Email 
from SysUser S 
Where (ID=@UserTo 
or Exists (Select Type from SysuserType ST WHere ST.Type=S.Type and ST.Type=@UserTo)
or Exists (SELECT ID FROM SysUserGroup SGT WHERE [GROUP] 
IN(Select [Group] from SysUserGroup SG WHere SG.[Group]=@UserTo) AND SGT.ID=S.ID)
) 
and LockedF=0 and AllowedF=1 and coalesce(Email,'')<>''
)
GO


insert into PatchVersioning
select '1592 Update Script 6 MEI 2026.sql',GETDATE()
go	
  
Declare @PrevScript varchar(100)
Declare @CurrScript varchar(100)

Select @PrevScript=''
Select @CurrSCript='1592 Update Script 6 MEI 2026.sql'


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