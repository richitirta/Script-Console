/* To prevent any potential data loss issues, you should review this script in detail before running it outside the context of the database designer.*/

SET QUOTED_IDENTIFIER ON
SET ARITHABORT ON
SET NUMERIC_ROUNDABORT OFF
SET CONCAT_NULL_YIELDS_NULL ON
SET ANSI_NULLS ON
SET ANSI_PADDING ON
SET ANSI_WARNINGS ON

IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'ApplyCGroupExF' AND Object_ID = Object_ID(N'ComAcc'))

BEGIN

ALTER TABLE dbo.ComAcc ADD
	ApplyCGroupExF bit NULL
END
GO
DECLARE @v sql_variant 
SET @v = N'Apply Company Group as Exclusion (0 : No, 1 : Yes)'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'ComAcc', N'COLUMN', N'ApplyCGroupExF'
GO



IF  NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'ComAcc_CGroup') AND type in (N'U'))

BEGIN
CREATE TABLE [dbo].[ComAcc_CGroup](
	[ComAcc] [varchar](30) NOT NULL,
	[CGroup] [varchar](10) NOT NULL,
 CONSTRAINT [I_ComAcc_CGroup] PRIMARY KEY CLUSTERED 
(
	[ComAcc] ASC,
	[CGroup] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = OFF) ON [PRIMARY]
) ON [PRIMARY]
END
GO

ALTER TABLE [dbo].[ComAcc_CGroup] SET (LOCK_ESCALATION = DISABLE)
GO

ALTER TABLE [dbo].[ComAcc_CGroup]  WITH NOCHECK ADD  CONSTRAINT [FK_ComAcc_CGroup_ComAcc] FOREIGN KEY([ComAcc])
REFERENCES [dbo].[ComAcc] ([ComAcc])
ON UPDATE CASCADE
ON DELETE CASCADE
GO

ALTER TABLE [dbo].[ComAcc_CGroup] CHECK CONSTRAINT [FK_ComAcc_CGroup_ComAcc]
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Company Account ID' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'ComAcc_CGroup', @level2type=N'COLUMN',@level2name=N'ComAcc'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Company Group' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'ComAcc_CGroup', @level2type=N'COLUMN',@level2name=N'CGroup'
GO



DROP FUNCTION FN_Payor_UserComAcc

GO


CREATE FUNCTION FN_Payor_UserComAcc (@P_UserID as varchar(50), @P_Branch as varchar(10), @P_ID as varchar(10))            
RETURNS TABLE            
as RETURN(            
SELECT ComAcc.*       
 from ComAcc       
 Left Join Branch on (Branch.Branch=@P_Branch)      
 Inner join SysUser on (SysUser.ID=@P_UserID)      
 Left Join Profile on (Profile.ID=@P_ID)
 Where (SysUser.Type='SUPERVISOR' or Exists (Select Top 1 SysUserComAcc.ComAcc from SysUserComAcc Where SysUserComAcc.AllowedF=1 and SysUserComAcc.ID=@P_UserID and SysUserComAcc.ComAcc=ComAcc.ComAcc)) and          
 (
	@P_Branch='' or        
	(Coalesce(Branch.Op_Flag,0)=0) or      
	(ComAcc.Branch=@P_Branch) or          
	(ComAcc.Branch='' and Not Exists (Select Top 1 ComAcc from ComAcc_Branch Where ComAcc_Branch.ComAcc=ComAcc.ComAcc)) or
	(exists (Select Top 1 ComAcc from ComAcc_Branch Where ComAcc_Branch.ComAcc=ComAcc.ComAcc and ComAcc_Branch.Branch=@P_Branch)) 	
 )           
 and
 (
	@P_ID='' or         
	(Not Exists (Select Top 1 ComAcc from ComAcc_CGroup Where ComAcc_CGroup.ComAcc=ComAcc.ComAcc)) or
	(ComAcc.ApplyCGroupExF=0 and exists (Select Top 1 ComAcc from ComAcc_CGroup Where ComAcc_CGroup.ComAcc=ComAcc.ComAcc and ComAcc_CGroup.CGroup=Profile.CGroup)) or           
	(ComAcc.ApplyCGroupExF=1 and Not exists (Select Top 1 ComAcc from ComAcc_CGroup Where ComAcc_CGroup.ComAcc=ComAcc.ComAcc and ComAcc_CGroup.CGroup=Profile.CGroup))
 )           
) 

GO

insert into PatchVersioning
select '1489 Update Script - 14 November 2025.sql',GETDATE()
go	
  
Declare @PrevScript varchar(100)
Declare @CurrScript varchar(100)

Select @PrevScript=''
Select @CurrSCript='1489 Update Script - 14 November 2025.sql'


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


