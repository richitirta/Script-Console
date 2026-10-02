ALTER TABLE CLAIM	ALTER COLUMN RequestName	Varchar(50)
GO
ALTER TABLE nVoucher	ALTER COLUMN RequestName	Varchar(50)
GO
ALTER TABLE mVoucher	ALTER COLUMN RequestName	Varchar(50)
GO
ALTER TABLE Request	ALTER COLUMN RequestName	Varchar(50)
GO
ALTER TABLE pVoucher	ALTER COLUMN RequestName	Varchar(50)
GO
ALTER TABLE Service	ALTER COLUMN RequestName	Varchar(50)

GO
ALTER TABLE ACCEPTANCE	ALTER COLUMN RequestName	Varchar(50)

GO
if exists (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'FN_UserVType') AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) )
BEGIN
DROP FUNCTION FN_UserVType 
END
GO
CREATE FUNCTION FN_UserVType (@P_UserID as varchar(50))            
RETURNS TABLE            
as RETURN(            
SELECT VType.*       
 from VType       
 Inner join SysUser on (SysUser.ID=@P_UserID)      
 Where (SysUser.Type='SUPERVISOR' 
 or dbo.getPrivileges(@P_UserID,'ALLOWPASSUSERVTYPE')<>0
 or EXISTS (Select SysUserVType.VType from SysUserVType Where SysUserVType.VType=VType.VType and SysUserVType.ID=@P_UserID and SysUserVType.VType=VType.VType)
 )   
)          
GO

insert into PatchVersioning
select '55.30 Update Script - Patch 2020 (30)',GETDATE()
go


Declare @PrevScript varchar(100)
Declare @CurrScript varchar(100)

Select @PrevScript='55.29 Update Script - Patch 2020 (29)'
Select @CurrSCript='55.30 Update Script - Patch 2020 (30)'


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



  