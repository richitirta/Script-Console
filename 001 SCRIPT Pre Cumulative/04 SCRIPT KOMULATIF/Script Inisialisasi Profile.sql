update Profile_Ext set ID_Type = 'ID Card' where id = 'KTP'
update Profile_Ext set ID_Type = 'Driving License' where id = 'SIM'
go


UPDATE PROFILE SET LicenseExpiry='2025-12-31 00:00:00' WHERE lob IN('01','02')
go