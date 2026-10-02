IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'Portion_IFRS4' AND Object_ID = Object_ID(N'dbo.EMS_CSTALLOCATIONH'))
BEGIN
ALTER TABLE EMS_CSTALLOCATIONH ADD Portion_IFRS4 float
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Portion To Be Allocated for IFRS4 (%)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',
@level1name=N'EMS_CSTALLOCATIONH', @level2type=N'COLUMN',@level2name=N'Portion_IFRS4'
END
GO

IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'PCT_IFRS4' AND Object_ID = Object_ID(N'dbo.EMS_CSTALLOCATIOND'))
BEGIN
ALTER TABLE EMS_CSTALLOCATIOND ADD PCT_IFRS4 float
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Cost Allocation Percentage for IFRS4 (%)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',
@level1name=N'EMS_CSTALLOCATIOND', @level2type=N'COLUMN',@level2name=N'PCT_IFRS4'
END
GO