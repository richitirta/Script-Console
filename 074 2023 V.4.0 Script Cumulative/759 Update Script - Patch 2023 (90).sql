DROP FUNCTION FN_UserVType 
GO
CREATE FUNCTION FN_UserVType (@P_UserID as varchar(50))            
RETURNS TABLE            
as RETURN(            
SELECT VType.*       
 from VType       
 Inner join SysUser on (SysUser.ID=@P_UserID)      
 Left Join SysUserVType on (SysUserVType.ID=SysUser.ID and SysUserVType.VType=VType.VType)
 Where (coalesce(SysUserVType.VType,'')<>'' or SysUser.Type='SUPERVISOR' or dbo.getPrivileges(@P_UserID,'ALLOWPASSUSERVTYPE')<>0)   
)          

go


 insert into PatchVersioning	
select '759 Update Script - Patch 2023 (90)',GETDATE()
go





Declare @PrevScript varchar(100)
Declare @CurrScript varchar(100)

Select @PrevScript=''
Select @CurrSCript='759 Update Script - Patch 2023 (90)'


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



     



