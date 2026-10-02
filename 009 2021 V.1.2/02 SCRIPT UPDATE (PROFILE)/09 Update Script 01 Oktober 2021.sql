--select PIC_TITLE_1,* from Profile_Ext


alter table Profile_Ext alter column PIC_TITLE_1 varchar(255)
go
IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'PIC_TITLE_2' AND Object_ID = Object_ID(N'Profile_Ext'))
BEGIN
ALTER TABLE Profile_Ext ADD PIC_TITLE_2 varchar(255) NULL
end
go

IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'PIC_TITLE_3' AND Object_ID = Object_ID(N'Profile_Ext'))
BEGIN
ALTER TABLE Profile_Ext ADD PIC_TITLE_3 varchar(255) NULL
end
go

IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'ADDHOMEPAGE' AND Object_ID = Object_ID(N'Profile_Ext'))
BEGIN
ALTER TABLE Profile_Ext ADD ADDHOMEPAGE varchar(50) NULL
end
go

IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'PIC_NAME_1' AND Object_ID = Object_ID(N'Profile_Ext'))
BEGIN
ALTER TABLE Profile_Ext ADD PIC_NAME_1 varchar(50) NULL
end
go

IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'PIC_NAME_2' AND Object_ID = Object_ID(N'Profile_Ext'))
BEGIN
ALTER TABLE Profile_Ext ADD PIC_NAME_2 varchar(50) NULL
end
go

IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'PIC_NAME_3' AND Object_ID = Object_ID(N'Profile_Ext'))
BEGIN
ALTER TABLE Profile_Ext ADD PIC_NAME_3 varchar(50) NULL
end
go