IF not EXISTS (SELECT * FROM sys.indexes WHERE name='I_Admlink_Date_Subject_Type' AND object_id = OBJECT_ID(N'AdmLink'))
Begin
CREATE INDEX I_Admlink_Date_Subject_Type
ON AdmLink (Date, Subject, Type)
INCLUDE ([ID],[VOUCHER],[SOURCE],[A_PolicyNo],[A_MO],[A_ID],[RefType])
end
GO

IF EXISTS (SELECT * FROM sys.indexes WHERE name='I_Admlink_Date' AND object_id = OBJECT_ID(N'Admlink'))
Begin
drop index Admlink.I_Admlink_Date
end
go



--VERSIONING
insert into PatchVersioning
select '104 Update Script - Patch 2021 (72)',GETDATE()
go