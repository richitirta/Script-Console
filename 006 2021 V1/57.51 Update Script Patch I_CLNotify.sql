
IF EXISTS (SELECT *  FROM sys.indexes WHERE name='I_CLNotify' AND object_id = OBJECT_ID('CLNotify'))
BEGIN
drop Index I_CLNotify on CLNotify--(CNO,Type,RID,ID,Document)
end
GO

IF EXISTS(SELECT * FROM sys.columns WHERE Name = N'RID' AND Object_ID = Object_ID(N'CLNotify'))
begin
alter table CLNotify
alter column RID varchar (100) null
end
GO

IF NOT EXISTS (SELECT *  FROM sys.indexes WHERE name='I_CLNotify' AND object_id = OBJECT_ID('CLNotify'))
BEGIN
CREATE UNIQUE NONCLUSTERED INDEX I_CLNotify on CLNotify(CNO,Type,RID,ID,Document)
end
GO


--sp_helpindex CLNotify
