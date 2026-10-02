
IF  NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'SysUserCT') AND type in (N'U'))
BEGIN
/****** Object:  Table [dbo].[SysUserCT]    Script Date: 6/12/2024 4:19:00 PM ******/
SET ANSI_NULLS ON
 

SET QUOTED_IDENTIFIER ON
 

CREATE TABLE [dbo].[SysUserCT](
	[ID] [varchar](50) NOT NULL,
	[CT] [varchar](20) NOT NULL,
	[AllowedF] [bit] NULL
) ON [PRIMARY]
 

ALTER TABLE [dbo].[SysUserCT] SET (LOCK_ESCALATION = DISABLE)
 

ALTER TABLE [dbo].[SysUserCT]  WITH NOCHECK ADD  CONSTRAINT [FK_SysUserCT_CT] FOREIGN KEY([CT])
REFERENCES [dbo].[CT] ([CT])
 

ALTER TABLE [dbo].[SysUserCT] CHECK CONSTRAINT [FK_SysUserCT_CT]
 

ALTER TABLE [dbo].[SysUserCT]  WITH NOCHECK ADD  CONSTRAINT [FK_SysUserCT_SysUser] FOREIGN KEY([ID])
REFERENCES [dbo].[SysUser] ([ID])
ON UPDATE CASCADE
ON DELETE CASCADE
 

ALTER TABLE [dbo].[SysUserCT] CHECK CONSTRAINT [FK_SysUserCT_SysUser]
 

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'User ID (see SysUser)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'SysUserCT', @level2type=N'COLUMN',@level2name=N'ID'
 

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Company Account ID' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'SysUserCT', @level2type=N'COLUMN',@level2name=N'CT'
end
go


IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'FN_UserCT') AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) )
BEGIN
DROP function FN_UserCT
end
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
Left Join Budget_Center  B on (B.Branch=@P_Branch and B.CT=CT.CT)
Inner Join SysTab on (1=1)
Where 
SysUser.Type='SUPERVISOR' or dbo.GetPrivileges(@P_UserID,'ALLOWPASSCTRESTRICTION')=1 or
(
	(
	CT.Branch is null or CT.Branch='' or CT.Branch=@P_Branch
	)
and (
	SysTab.BudgetFeaturesF=0
	or
	not exists (Select Top 1 CT from Budget_Center B Where B.Branch=@P_Branch)
	or coalesce(B.CT,'')<>''
	)
and 
	(
    not(coalesce(Type.PL_Flag,1)=1 and coalesce(Type.Type,5)=5) 
    or dbo.GetPrivileges(@P_UserID,'FORCEUSECSTALLOCATION')=0
    or EXISTS (Select C.Account from CSTALLOCATIOND C Where C.Branch=@P_Branch and C.Account=@P_Account and C.CT=CT.CT)
    or (@P_Account='' and (SysUser.CT='' or SysUser.CT=CT.CT or exists (Select Top 1 CT from SysUserCT Where ID=@P_USERID and CT=CT.CT))) 
    )      
)
)  

go


insert into PatchVersioning
select '1078 Update Script - 12 June 2024',GETDATE()
go
	

Declare @PrevScript varchar(100)
Declare @CurrScript varchar(100)

Select @PrevScript=''
Select @CurrSCript='1078 Update Script - 12 June 2024'


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
