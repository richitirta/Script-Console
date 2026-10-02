
IF  NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'DIRECTORATE') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[DIRECTORATE](
	[DIRECTORATE] [varchar](10) NULL,
	[Description] [varchar](50) NULL,
	[Last_Opr] [varchar](50) NULL,
	[Last_Update] [smalldatetime] NULL,
 CONSTRAINT [I_DIRECTORATE] UNIQUE NONCLUSTERED 
(
	[DIRECTORATE] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Directorate ID' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'DIRECTORATE', @level2type=N'COLUMN',@level2name=N'DIRECTORATE'
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Directorate Description' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'DIRECTORATE', @level2type=N'COLUMN',@level2name=N'Description'
END
GO



/* To prevent any potential data loss issues, you should review this script in detail before running it outside the context of the database designer.*/
BEGIN TRANSACTION
SET QUOTED_IDENTIFIER ON
SET ARITHABORT ON
SET NUMERIC_ROUNDABORT OFF
SET CONCAT_NULL_YIELDS_NULL ON
SET ANSI_NULLS ON
SET ANSI_PADDING ON
SET ANSI_WARNINGS ON
COMMIT
BEGIN TRANSACTION
GO

IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'DIRECTORATE' AND Object_ID = Object_ID(N'CT'))

BEGIN
ALTER TABLE dbo.CT ADD
	DIRECTORATE varchar(10) NULL
END
GO
DECLARE @v sql_variant 
SET @v = N'Refer ke Directorate Table'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'CT', N'COLUMN', N'DIRECTORATE'
GO
ALTER TABLE dbo.CT SET (LOCK_ESCALATION = DISABLE)
GO
COMMIT

GO

IF  NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'Budget_Activity_ApprovalLimit') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[Budget_Activity_ApprovalLimit](
	[CT] [varchar](20) NOT NULL,
	[GID] [varchar](10) NOT NULL,
	[Type] [varchar](20) NOT NULL,
	[MaxNominal] [float] NOT NULL,
	[UserTypeChecker] [varchar](10) NULL,
	[UserTypeApprover] [varchar](10) NULL,
	[UserTypeChecker_Ext] [varchar](10) NULL,
	[UserTypeApprover_Ext] [varchar](10) NULL,
	[LimitChecker] [float] NULL,
	[LimitApprover] [float] NULL,
	[LimitChecker_Ext] [float] NULL,
	[LimitApprover_Ext] [float] NULL,
 CONSTRAINT [I_Budget_Activity_ApprovalLimit] UNIQUE NONCLUSTERED 
(
	[CT] ASC,
	[GID] ASC,
	[Type] ASC,
	[MaxNominal] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
END
GO

ALTER TABLE [dbo].[Budget_Activity_ApprovalLimit]  WITH CHECK ADD  CONSTRAINT [FK_Budget_Activity_ApprovalLimit_Budget_Activity] FOREIGN KEY([CT], [GID])
REFERENCES [dbo].[Budget_Activity] ([CT], [GID])
ON UPDATE CASCADE
ON DELETE CASCADE
GO

ALTER TABLE [dbo].[Budget_Activity_ApprovalLimit] CHECK CONSTRAINT [FK_Budget_Activity_ApprovalLimit_Budget_Activity]
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'for ''PROPOSAL''/''PO''/''REALIZATION''' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Budget_Activity_ApprovalLimit', @level2type=N'COLUMN',@level2name=N'Type'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'User Type for Checker' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Budget_Activity_ApprovalLimit', @level2type=N'COLUMN',@level2name=N'UserTypeChecker'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'User Type for Approver' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Budget_Activity_ApprovalLimit', @level2type=N'COLUMN',@level2name=N'UserTypeApprover'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'User Type for Checker Extended' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Budget_Activity_ApprovalLimit', @level2type=N'COLUMN',@level2name=N'UserTypeChecker_Ext'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'User Type for Approver Extended' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Budget_Activity_ApprovalLimit', @level2type=N'COLUMN',@level2name=N'UserTypeApprover_Ext'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Limit for Checker' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Budget_Activity_ApprovalLimit', @level2type=N'COLUMN',@level2name=N'LimitChecker'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Limit for Approver' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Budget_Activity_ApprovalLimit', @level2type=N'COLUMN',@level2name=N'LimitApprover'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Limit for Extended Checker' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Budget_Activity_ApprovalLimit', @level2type=N'COLUMN',@level2name=N'LimitChecker_Ext'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Limit for Extended Approver' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Budget_Activity_ApprovalLimit', @level2type=N'COLUMN',@level2name=N'LimitApprover_Ext'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Maximum Nominal for the Approval' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Budget_Activity_ApprovalLimit', @level2type=N'COLUMN',@level2name=N'MaxNominal'
GO



/* To prevent any potential data loss issues, you should review this script in detail before running it outside the context of the database designer.*/
BEGIN TRANSACTION
SET QUOTED_IDENTIFIER ON
SET ARITHABORT ON
SET NUMERIC_ROUNDABORT OFF
SET CONCAT_NULL_YIELDS_NULL ON
SET ANSI_NULLS ON
SET ANSI_PADDING ON
SET ANSI_WARNINGS ON
COMMIT
BEGIN TRANSACTION
GO

IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'AssType' AND Object_ID = Object_ID(N'Budget_AccountDetail'))

BEGIN
ALTER TABLE dbo.Budget_AccountDetail ADD
	AssType varchar(20) NULL
END
GO
DECLARE @v sql_variant 
SET @v = N'Asset if AssType Filled, AssType refer to Asset Type Table (AssType)'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'Budget_AccountDetail', N'COLUMN', N'AssType'
GO
ALTER TABLE dbo.Budget_AccountDetail SET (LOCK_ESCALATION = DISABLE)
GO
COMMIT
GO


/* To prevent any potential data loss issues, you should review this script in detail before running it outside the context of the database designer.*/
BEGIN TRANSACTION
SET QUOTED_IDENTIFIER ON
SET ARITHABORT ON
SET NUMERIC_ROUNDABORT OFF
SET CONCAT_NULL_YIELDS_NULL ON
SET ANSI_NULLS ON
SET ANSI_PADDING ON
SET ANSI_WARNINGS ON
COMMIT
BEGIN TRANSACTION
GO

IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'AssType' AND Object_ID = Object_ID(N'Budget_Account'))

BEGIN
ALTER TABLE dbo.Budget_Account ADD
	AssType varchar(20) NULL
END
GO

DECLARE @v sql_variant 
SET @v = N'Asset if AssType Filled, AssType refer to Asset Type Table (AssType)'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'Budget_Account', N'COLUMN', N'AssType'
GO
ALTER TABLE dbo.Budget_Account SET (LOCK_ESCALATION = DISABLE)
GO
COMMIT

GO
/* To prevent any potential data loss issues, you should review this script in detail before running it outside the context of the database designer.*/
BEGIN TRANSACTION
SET QUOTED_IDENTIFIER ON
SET ARITHABORT ON
SET NUMERIC_ROUNDABORT OFF
SET CONCAT_NULL_YIELDS_NULL ON
SET ANSI_NULLS ON
SET ANSI_PADDING ON
SET ANSI_WARNINGS ON
COMMIT
BEGIN TRANSACTION
GO

IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'VType' AND Object_ID = Object_ID(N'Budget_AccountGroup'))

BEGIN
ALTER TABLE dbo.Budget_AccountGroup ADD
	VType varchar(10) NULL
END
GO

DECLARE @v sql_variant 
SET @v = N'Payment Request Voucher Type (for generating Payment Request)'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'Budget_AccountGroup', N'COLUMN', N'VType'
GO
ALTER TABLE dbo.Budget_AccountGroup SET (LOCK_ESCALATION = DISABLE)
GO
COMMIT

GO

IF  NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'EMS_CSTALLOCATIONH') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[EMS_CSTALLOCATIONH](
	[TID] [int] NULL,
	[Branch] [varchar](10) NULL,
	[CT] [varchar](10) NULL,
	[GID] [varchar](10) NULL,
	[ID] [varchar](10) NULL,
	[Classification] [varchar](1) NULL,
	[Portion] [float] NULL,
 CONSTRAINT [I_EMS_CSTALLOCATIONH] UNIQUE NONCLUSTERED 
(
	[TID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY],
 CONSTRAINT [I_EMS_CSTALLOCATIONH_BRANCH_CT_GID_ID] UNIQUE NONCLUSTERED 
(
	[Branch] ASC,
	[CT] ASC,
	[GID] ASC,
	[ID] ASC,
	[Classification] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
END
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Table ID (Auto Generated)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'EMS_CSTALLOCATIONH', @level2type=N'COLUMN',@level2name=N'TID'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Refer to Cost Center Table ' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'EMS_CSTALLOCATIONH', @level2type=N'COLUMN',@level2name=N'CT'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Refer to GID Budget_Activity' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'EMS_CSTALLOCATIONH', @level2type=N'COLUMN',@level2name=N'GID'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Refer To Budget_AccountDetail' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'EMS_CSTALLOCATIONH', @level2type=N'COLUMN',@level2name=N'ID'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Cost Classification (''A''cquisition Cost, ''M''aintenance Cost, ''O''ther expenses)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'EMS_CSTALLOCATIONH', @level2type=N'COLUMN',@level2name=N'Classification'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Portion To Be Allocated (%)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'EMS_CSTALLOCATIONH', @level2type=N'COLUMN',@level2name=N'Portion'
GO


IF  NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'EMS_CSTALLOCATIOND') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[EMS_CSTALLOCATIOND](
	[TID] [int] NULL,
	[Account] [varchar](10) NULL,
	[PCT] [float] NULL,
 CONSTRAINT [I_EMS_CSTALLOCATIOND] UNIQUE NONCLUSTERED 
(
	[TID] ASC,
	[Account] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
END
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Refer to EMS_CSTALLOCATIONH' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'EMS_CSTALLOCATIOND', @level2type=N'COLUMN',@level2name=N'TID'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Cost Allocation Percentage (%)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'EMS_CSTALLOCATIOND', @level2type=N'COLUMN',@level2name=N'PCT'
GO




insert into PatchVersioning
select '1487 Update Script - 5 November 2025.sql',GETDATE()
go	
  
Declare @PrevScript varchar(100)
Declare @CurrScript varchar(100)

Select @PrevScript=''
Select @CurrSCript='1487 Update Script - 5 November 2025.sql'


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