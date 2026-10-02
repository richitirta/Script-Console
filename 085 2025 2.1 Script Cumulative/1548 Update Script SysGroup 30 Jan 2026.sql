IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'ID' AND Object_ID = Object_ID(N'dbo.SysUserGroup'))
BEGIN
ALTER TABLE SysUserGroup ADD ID varchar(50)
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'User ID (see to SysUser)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'SysUserGroup', @level2type=N'COLUMN',@level2name=N'ID'
END
GO

Update SysUserGroup set ID=UserID 
GO

ALTER TABLE SysUserGroup ALTER COLUMN ID varchar(50) NOT NULL
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'User Group (see to SysGroup)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'SysUserGroup', @level2type=N'COLUMN',@level2name=N'Group'
GO

ALTER TABLE [dbo].[SysUserGroup] DROP CONSTRAINT [i_SysUserGroup]
GO

ALTER TABLE [dbo].[SysUserGroup] ADD  CONSTRAINT [i_SysUserGroup] PRIMARY KEY NONCLUSTERED
(
	[Group] ASC,
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = OFF) ON [PRIMARY]
GO


ALTER TABLE [dbo].[SysUserGroup]  WITH CHECK ADD  CONSTRAINT [FK_SysUserGroup_sysuser] FOREIGN KEY([ID])
REFERENCES [dbo].[sysuser] ([ID])
GO

ALTER TABLE [dbo].[SysUserGroup] CHECK CONSTRAINT [FK_SysUserGroup_sysuser]
GO

ALTER TABLE SysUserGroup DROP COLUMN UserID 
GO
