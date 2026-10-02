IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'UserGroupChecker' AND Object_ID = Object_ID(N'dbo.Budget_Activity_ApprovalLimit'))
BEGIN
ALTER TABLE Budget_Activity_ApprovalLimit ADD UserGroupChecker varchar(50) NULL
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'User Group (see SysGroup) for Checker' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Budget_Activity_ApprovalLimit', @level2type=N'COLUMN',@level2name=N'UserGroupChecker'
END
GO

IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'UserGroupApprover' AND Object_ID = Object_ID(N'dbo.Budget_Activity_ApprovalLimit'))
BEGIN
ALTER TABLE Budget_Activity_ApprovalLimit ADD UserGroupApprover varchar(50) NULL
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'User Group (see SysGroup) for Approver' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Budget_Activity_ApprovalLimit', @level2type=N'COLUMN',@level2name=N'UserGroupApprover'
END
GO

IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'UserGroupChecker_Ext' AND Object_ID = Object_ID(N'dbo.Budget_Activity_ApprovalLimit'))
BEGIN
ALTER TABLE Budget_Activity_ApprovalLimit ADD UserGroupChecker_Ext varchar(50) NULL
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'User Group (see SysGroup) for Checker Extended' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Budget_Activity_ApprovalLimit', @level2type=N'COLUMN',@level2name=N'UserGroupChecker_Ext'
END
GO

IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'UserGroupApprover_Ext' AND Object_ID = Object_ID(N'dbo.Budget_Activity_ApprovalLimit'))
BEGIN
ALTER TABLE Budget_Activity_ApprovalLimit ADD UserGroupApprover_Ext varchar(50) NULL
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'User Group (see SysGroup) for Approver Extended' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Budget_Activity_ApprovalLimit', @level2type=N'COLUMN',@level2name=N'UserGroupApprover_Ext'
END
GO

UPDATE Budget_Activity_ApprovalLimit
SET
    UserGroupChecker = UserTypeChecker,
    UserGroupApprover = UserTypeApprover,
    UserGroupChecker_Ext = UserTypeChecker_Ext,
	UserGroupApprover_Ext = UserTypeApprover_Ext
GO

ALTER TABLE Budget_Activity_ApprovalLimit DROP COLUMN UserTypeChecker 
GO

ALTER TABLE Budget_Activity_ApprovalLimit DROP COLUMN UserTypeApprover 
GO

ALTER TABLE Budget_Activity_ApprovalLimit DROP COLUMN UserTypeChecker_Ext 
GO

ALTER TABLE Budget_Activity_ApprovalLimit DROP COLUMN UserTypeApprover_Ext 
GO
