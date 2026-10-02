IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'EmailF' AND Object_ID = Object_ID(N'ActionList'))
BEGIN
ALTER TABLE ActionList ADD
	EmailF bit 
DECLARE @v sql_variant 
SET @v = N'Net Amount for Adjustment Deposit (0 : No, 1 : Yes)'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'ActionList', N'COLUMN', N'EmailF'
end
go

Update ActionList Set EmailF = '0' where emailf is null
GO