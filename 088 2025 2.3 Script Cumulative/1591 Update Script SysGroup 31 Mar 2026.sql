IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'AutoEmailF' AND Object_ID = Object_ID(N'dbo.SysGroup'))
BEGIN
ALTER TABLE SysGroup ADD AutoEmailF Bit
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Auto Email Flag (0 : No, 1 : Yes)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',
@level1name=N'SysGroup', @level2type=N'COLUMN',@level2name=N'AutoEmailF'
END
GO

Update SysGroup set AutoEmailF=0 Where AutoEmailF is null
GO