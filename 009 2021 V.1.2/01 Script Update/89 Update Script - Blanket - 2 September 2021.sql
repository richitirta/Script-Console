
IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'BlanketMoved' AND Object_ID = Object_ID(N'Blanket_Delivery'))
BEGIN
ALTER TABLE dbo.Blanket_Delivery ADD
	BlanketMoved bigint NULL
DECLARE @v sql_variant 
SET @v = N'Blanket Number'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'Blanket_Delivery', N'COLUMN', N'BlanketMoved'
end
GO

IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'Status' AND Object_ID = Object_ID(N'Blanket_Delivery'))
BEGIN
ALTER TABLE dbo.Blanket_Delivery ADD
	Status varchar(1) NULL
DECLARE @v sql_variant 
SET @v = N'Delivery Status (''O''pen, ''C''losed)'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'Blanket_Delivery', N'COLUMN', N'Status'
end
GO

IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'SDeliveryNo' AND Object_ID = Object_ID(N'Blanket_Delivery'))
BEGIN
ALTER TABLE dbo.Blanket_Delivery ADD
	SDeliveryNo varchar(20) NULL
DECLARE @v sql_variant 
SET @v = N'Source Delivery No'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'Blanket_Delivery', N'COLUMN', N'SDeliveryNo'
end
GO

Update Blanket_Delivery Set Status='O' Where Status is null
GO
Update Blanket_Delivery Set Status='O' Where Status  = ''
GO



insert into PatchVersioning
select '89 Update Script - Blanket - 2 September 2021',GETDATE()
go

