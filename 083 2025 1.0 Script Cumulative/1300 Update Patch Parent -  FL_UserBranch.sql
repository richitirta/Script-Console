
DROP function [dbo].[FL_UserBranch]
GO
CREATE function [dbo].[FL_UserBranch](@P_USERID varchar(50), @P_Branch varchar(10))    
RETURNS Table      
AS RETURN      
(    
SELECT Branch.Branch, Branch.Name, Branch.Parent, Branch.Active_Flag, Branch.ShariaF
from Branch, SysUser    
Where SysUser.ID=@P_UserID and Branch.Branch Like @P_Branch+'%' and Branch.Op_Flag=1 and Branch.Active_Flag=1    
and (SysUser.Type='SUPERVISOR' or Branch.Branch in (Select S.Branch from SysUserBranch S Where S.AllowedF=1 and S.ID=@P_UserID))
)
GO




  insert into PatchVersioning
select '1300 Update Patch Parent -  FL_UserBranch',GETDATE()
go	
  

Declare @PrevScript varchar(100)
Declare @CurrScript varchar(100)

Select @PrevScript=''
Select @CurrSCript='1300 Update Patch Parent -  FL_UserBranch'


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