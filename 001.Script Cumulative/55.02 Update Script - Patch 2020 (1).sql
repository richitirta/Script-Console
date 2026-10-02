if exists (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'FN_UserCT') AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) )
BEGIN
DROP function FN_UserCT
END
GO
Create function FN_UserCT(@P_USERID varchar(50), @P_Branch varchar(10), @P_Account varchar(10))  
RETURNS Table    
AS RETURN    
(  
SELECT CT.*
from CT
Inner Join SysUser on (SysUser.ID=@P_UserID)
Left Join Account on (Account.Account=@P_Account)
Left Join Type on (Type.Type=Account.Type)
Where (CT.Branch is null or CT.Branch='' or CT.Branch=@P_Branch)
and (
       SysUser.Type='SUPERVISOR' or 
       (
       not(coalesce(Type.PL_Flag,1)=1 and coalesce(Type.Type,5)=5) 
       or dbo.GetPrivileges(@P_UserID,'FORCEUSECSTALLOCATION')=0 
       or EXISTS (Select C.Account from CSTALLOCATIOND C Where C.Branch=@P_Branch and C.Account=@P_Account and C.CT=CT.CT)
       or (@P_Account='' and (SysUser.CT='' or SysUser.CT=CT.CT)) 
       )
)        

)  
GO


insert into PatchVersioning
select '55.2 Update Script - Patch 2020 (1)',GETDATE()
go


Declare @PrevScript varchar(100)
Declare @CurrScript varchar(100)

Select @PrevScript='55.1 Update Script - FN_POLICY_ONRISK'
Select @CurrSCript='55.2 Update Script - Patch 2020 (1)'


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


