DROP function [dbo].Fn_GetSentToAllUser
go
Create function [dbo].Fn_GetSentToAllUser(@P_UserID as varchar(50), @P_TOC as varchar(10),@P_Branch as varchar(10))  
RETURNS Table    
AS RETURN   
( 
Select S.ID, S.Name, S.Type from 
(
Select S1.ID, S1.Name, 'U' as Type from SysUser S1 Where cast(convert(varchar(10), getdate(),1) as smalldatetime)<=S1.Expiry and S1.LockedF=0 and S1.AllowedF=1 
and Exists (Select SysUserTOC.ID from SysUserTOC Where SysUserTOC.ID=S1.ID and SysUserTOC.TOC=@P_TOC) 
and Exists (Select SysUserBranch.ID from SysUserBranch Where SysUserBranch.ID=S1.ID and SysUserBranch.AllowedF=1 and SysUserBranch.Branch=@P_Branch)
union all 
Select Type as ID, Description as Name, 'T' as Type from SysUserType
) S 
--Left Join ActionUser A on (A.ActionUser=S.ID and A.ActionCode=@P_ActionCode), SysUserType S1
Where 
 (@P_UserID <>'' and S.ID like @P_UserID) or @P_UserID=''
--and (S1.ApplyActionCodeF=0 or coalesce(A.ActionCode,'')<>'') and coalesce(A.ActionCode,'')=@P_ActionCode  )
)
go


DROP function [dbo].Fn_GetSentToFAUser
go
Create function [dbo].Fn_GetSentToFAUser(@P_UserID as varchar(50),@P_Branch as varchar(10),@P_ActionCode as varchar(10))  
RETURNS Table    
AS RETURN   
( 
Select S.ID, S.Name, S.Type, coalesce(AL.RCondition,'') RCondition from 
(
Select S1.ID, S1.Name, 'U' as Type, 1 as ApplyActionCodeF from SysUser S1 Where cast(convert(varchar(10), getdate(),1) as smalldatetime)<=S1.Expiry and S1.LockedF=0 and S1.AllowedF=1 
and Exists (Select SysUserBranch.ID from SysUserBranch Where SysUserBranch.ID=S1.ID and SysUserBranch.AllowedF=1 and SysUserBranch.Branch=@P_Branch)
union all 
Select Type as ID, Description as Name, 'T' as Type, ApplyActionCodeF from SysUserType
) S 
Left Join ActionList AL on (AL.ActionCode=@P_ActionCode)
Left Join ActionUser A on (A.ActionCode=AL.ActionCode )
----Inner Join SysUser on (SysUser.ID=@P_UserID)
----Inner Join SysUsertype S1 on (S1.Type=SysUser.Type)
Where 
(@P_UserID='' and coalesce(A.ActionCode,'')=@P_ActionCode) or
 (@P_UserID <>'' and S.ID like @P_UserID and (S.ApplyActionCodeF=0 or coalesce(A.ActionCode,'')<>'') and A.ActionUser=S.ID) 

)
go

DROP function [dbo].[Fn_GetSentToUser]
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
go




--SELECT * FROM Fn_GetSentToAllUser('','','')
--SELECT * FROM Fn_GetSentToFAUser('willy','11','')
--SELECT * FROM Fn_GetSentToFAUser('','11','') S
-- Left Join fn_GetVoucherActionUser('','') f on (s.RCondition=4 and f.ID=S.ID)
--where 1=1
-- and (coalesce(S.RCondition,0)<>4 or f.ID=S.ID)

insert into PatchVersioning
select '1536 Update Script 26 Jan 2026 - F2 User Task.sql',GETDATE()
go	
  
Declare @PrevScript varchar(100)
Declare @CurrScript varchar(100)

Select @PrevScript=''
Select @CurrSCript='1536 Update Script 26 Jan 2026 - F2 User Task.sql'


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