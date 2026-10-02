

/****** Object:  UserDefinedFunction [dbo].[Fn_GetSentToUser]    Script Date: 1/22/2024 10:46:02 AM ******/
DROP FUNCTION [dbo].[Fn_GetSentToUser]
GO

/****** Object:  UserDefinedFunction [dbo].[Fn_GetSentToUser]    Script Date: 1/22/2024 10:46:02 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

Create function [dbo].[Fn_GetSentToUser](@P_UserType as varchar(20), @P_TOC as varchar(10),@P_Branch as varchar(10),@P_ActionCode as varchar(10))  
RETURNS Table    
AS RETURN   
( 
Select S.ID, S.Name, S.Type from 
(
Select S1.ID, S1.Name, 'U' as Type from SysUser S1 Where cast(convert(varchar(10), getdate(),1) as smalldatetime)<=S1.Expiry and S1.LockedF=0 and S1.AllowedF=1 and Exists (Select SysUserTOC.ID from SysUserTOC Where SysUserTOC.ID=S1.ID and SysUserTOC.TOC=@P_TOC) and Exists (Select SysUserBranch.ID from SysUserBranch Where SysUserBranch.ID=S1.ID and SysUserBranch.AllowedF=1 and SysUserBranch.Branch=@P_Branch)
union all 
Select Type as ID, Description as Name, 'T' as Type from SysUserType
) S 
Left Join ActionUser A on (A.ActionUser=S.ID and A.ActionCode=@P_ActionCode), SysUserType S1
Where S1.Type=@P_UserType and (S1.ApplyActionCodeF=0 or coalesce(A.ActionCode,'')<>'') and coalesce(A.ActionCode,'')=@P_ActionCode
  )
GO




insert into PatchVersioning
select '953 Update Script - Fn_GetSentToUser',GETDATE()
go


Declare @PrevScript varchar(100)
Declare @CurrScript varchar(100)

Select @PrevScript=''
Select @CurrSCript='953 Update Script - Fn_GetSentToUser'


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
	 