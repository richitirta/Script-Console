--inisialisasi data awal
update proacc set accountno='' where AccountNo is null
go
update proacc set BankAccount='' where BankAccount is null
go
update Profile_Ext set ID_No='' where ID_No is null
go
update Profile_Ext set ID_Type='' where ID_Type is null
go
update Profile_Ext set PassPortNo='' where PassPortNo is null
go
update Profile_Ext set BirthDate='' where BirthDate is null
go
update Profile_Ext set MothersName='' where MothersName is null
go
update Profile_Ext set Gender='' where Gender is null
go
update Profile set TAXID='' where TAXID is null
go
update Profile set Email='' where Email is null
go
update Profile set EMail_2='' where EMail_2 is null
go
update Profile set USERID='' where USERID is null
go