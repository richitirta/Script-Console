update systab set EncryptionPassPhrase=''

--inisialisasi data awal
update proacc set accountno=dbo.fn_ENCRYPTTEXT(systab.EncryptionPassPhrase,accountno) from systab, proacc 
go
update proacc set BankAccount=dbo.fn_ENCRYPTTEXT(systab.EncryptionPassPhrase,BankAccount) from systab, proacc
go
update Profile_Ext set ID_No=dbo.fn_ENCRYPTTEXT(systab.EncryptionPassPhrase,ID_No) from systab, Profile_Ext
go
update Profile_Ext set ID_Type=dbo.fn_ENCRYPTTEXT(systab.EncryptionPassPhrase,ID_Type) from systab, Profile_Ext
go
update Profile_Ext set PassPortNo=dbo.fn_ENCRYPTTEXT(systab.EncryptionPassPhrase,PassPortNo) from systab, Profile_Ext
go
update Profile_Ext set BirthDate=dbo.fn_ENCRYPTDATE(systab.EncryptionPassPhrase,BirthDate) from systab, Profile_Ext
go
update Profile_Ext set MothersName=dbo.fn_ENCRYPTTEXT(systab.EncryptionPassPhrase,MothersName) from systab, Profile_Ext
go
update Profile_Ext set Gender=dbo.fn_ENCRYPTTEXT(systab.EncryptionPassPhrase,Gender) from systab, Profile_Ext
go
update Profile set TAXID=dbo.fn_ENCRYPTTEXT(systab.EncryptionPassPhrase,TAXID) from systab, Profile
go
update Profile set Email=dbo.fn_ENCRYPTTEXT(systab.EncryptionPassPhrase,Email) from systab, Profile
go
update Profile set EMail_2=dbo.fn_ENCRYPTTEXT(systab.EncryptionPassPhrase,EMail_2) from systab, Profile
go
update Profile set USERID=dbo.fn_ENCRYPTTEXT(systab.EncryptionPassPhrase,USERID) from systab, Profile
go