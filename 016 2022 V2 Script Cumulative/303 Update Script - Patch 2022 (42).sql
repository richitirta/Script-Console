DROP function FL_UserBranchAccountIO
GO
Create function FL_UserBranchAccountIO(@P_USERID varchar(50), @P_Branch varchar(10), @P_Account varchar(10), @P_DebtorF Bit)            
RETURNS Table              
AS RETURN              
(            
SELECT Branch.Branch, Branch.Name, Branch.Active_Flag, Branch.ShariaF, 
Case When Type.PL_Flag=1 and Type.Type=5 and dbo.GetPrivileges(@P_UserID,'FORCEUSECSTALLOCATION')=1 Then
	(Select Top 1 CT from CSTALLOCATIOND C Where C.Branch=Branch.Branch and C.Account=@P_Account and (SysUser.CT='' or SysUser.CT=C.CT)) 
Else
	(Select Top 1 CT from CT Where CT.Branch=Branch.Branch and CT.AllowedF=1) 
End as CT
from Branch, SysUser, Account, Type          
Where SysUser.ID=@P_UserID and Account.Account=@P_Account and Account.Inter_Flag=1 and Type.Type=Account.Type       
and Branch.Branch Like @P_Branch+'%' and Branch.Op_Flag=1       
and (
SysUser.Type='SUPERVISOR' or 
	(
	EXISTS (
		Select S.Branch 
		from SysUserBranch S 
		Where S.Branch=Branch.Branch and S.ID=SysUser.ID
		and (
			(Type.PL_Flag=1 and S.IncomeReceiveF=1 and @P_DebtorF=1) or 
			(Type.PL_Flag=1 and S.ExpensePaymentF=1 and @P_DebtorF=0) or 
			(Type.BS_Flag=1 and S.SuspendReceiveF=1 and @P_DebtorF=1) or 
			(Type.BS_Flag=1 and S.SuspendPaymentF=1 and @P_DebtorF=0))
			)
	 and (not(Type.PL_Flag=1 and Type.Type=5) or dbo.GetPrivileges(@P_UserID,'FORCEUSECSTALLOCATION')=0 or EXISTS (Select C.Account from CSTALLOCATIONH C Where C.Branch=Branch.Branch and C.Account=Account.Account))
	)
)        

)      

go



 insert into PatchVersioning
select '303 Update Script - Patch 2022 (42)',GETDATE()
go


Declare @PrevScript varchar(100)
Declare @CurrScript varchar(100)

Select @PrevScript=''
Select @CurrSCript='303 Update Script - Patch 2022 (42)'


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

