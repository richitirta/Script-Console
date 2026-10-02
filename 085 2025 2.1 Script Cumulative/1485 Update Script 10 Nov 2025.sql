/* To prevent any potential data loss issues, you should review this script in detail before running it outside the context of the database designer.*/
SET QUOTED_IDENTIFIER ON
SET ARITHABORT ON
SET NUMERIC_ROUNDABORT OFF
SET CONCAT_NULL_YIELDS_NULL ON
SET ANSI_NULLS ON
SET ANSI_PADDING ON
SET ANSI_WARNINGS ON


SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

IF  NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[SysGroup]') AND type in (N'U'))

BEGIN

CREATE TABLE [dbo].[SysGroup](
	[Group] [Varchar] (10) NOT NULL,
	[Description] [varchar](255) NOT NULL,
	[AllowedF] [Bit] NULL,
	[Last_Opr] [varchar](50) NULL,
	[Last_Update] [smalldatetime] NULL
	
 CONSTRAINT [i_SysGroup] PRIMARY KEY NONCLUSTERED 
(
	[Group] ASC
	
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = OFF) ON [PRIMARY]
) ON [PRIMARY]
END
GO

ALTER TABLE [dbo].[SysGroup] SET (LOCK_ESCALATION = DISABLE)
GO



EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'see AppName' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'SysGroup', @level2type=N'COLUMN',@level2name=N'Group'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Allow Selection Flag (0 : No, 1 : Yes)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'SysGroup', @level2type=N'COLUMN',@level2name=N'AllowedF'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Last User Update' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'SysGroup', @level2type=N'COLUMN',@level2name=N'Last_Opr'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Last Date Update' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'SysGroup', @level2type=N'COLUMN',@level2name=N'Last_Update'
GO




/* To prevent any potential data loss issues, you should review this script in detail before running it outside the context of the database designer.*/

SET QUOTED_IDENTIFIER ON
SET ARITHABORT ON
SET NUMERIC_ROUNDABORT OFF
SET CONCAT_NULL_YIELDS_NULL ON
SET ANSI_NULLS ON
SET ANSI_PADDING ON
SET ANSI_WARNINGS ON


SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

IF  NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'SysUserGroup') AND type in (N'U'))

BEGIN

CREATE TABLE [dbo].[SysUserGroup](
	[Group] [Varchar] (10) NOT NULL,
	[UserID] [varchar](50) NOT NULL,
	[Last_Opr] [varchar](50) NULL,
	[Last_Update] [smalldatetime] NULL
	
 CONSTRAINT [i_SysUserGroup] PRIMARY KEY NONCLUSTERED 
(
	[Group] ASC,
    [UserID] ASC
	
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = OFF) ON [PRIMARY]
) ON [PRIMARY]
END
GO

ALTER TABLE [dbo].[SysUserGroup] SET (LOCK_ESCALATION = DISABLE)
GO

ALTER TABLE [dbo].[SysUserGroup]  WITH CHECK ADD  CONSTRAINT [FK_SysUserGroup_SysGroup] FOREIGN KEY([Group])
REFERENCES [dbo].[SysGroup] ([Group])
GO

ALTER TABLE [dbo].[SysUserGroup] CHECK CONSTRAINT [FK_SysUserGroup_SysGroup]
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'see AppName' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'SysUserGroup', @level2type=N'COLUMN',@level2name=N'Group'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'User ID' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'SysUserGroup', @level2type=N'COLUMN',@level2name=N'UserID'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Last User Update' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'SysUserGroup', @level2type=N'COLUMN',@level2name=N'Last_Opr'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Last Date Update' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'SysUserGroup', @level2type=N'COLUMN',@level2name=N'Last_Update'
GO




DROP FUNCTION [dbo].[fn_GetActionUser]

GO
CREATE FUNCTION [dbo].[fn_GetActionUser]()
RETURNS TABLE
AS
RETURN
(
    SELECT ID, Name, 'U' AS Type FROM SysUser
    UNION ALL
    SELECT Type AS ID, Description AS Name, 'T' AS Type FROM SysUserType
    UNION ALL
    SELECT [Group] AS ID, Description AS Name, 'G' AS Type FROM SysGroup
)
GO




insert into PatchVersioning
select '1485 Update Script 10 Nov 2025.sql',GETDATE()
go	
  
Declare @PrevScript varchar(100)
Declare @CurrScript varchar(100)

Select @PrevScript=''
Select @CurrSCript='1485 Update Script 10 Nov 2025.sql'


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