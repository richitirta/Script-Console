IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'BankBranch' AND Object_ID = Object_ID(N'Profile_Batch'))
BEGIN
    ALTER TABLE Profile_Batch ADD BankBranch varchar (150)
END
GO

IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'BankAccountName' AND Object_ID = Object_ID(N'Profile_Batch'))
BEGIN
    ALTER TABLE Profile_Batch ADD BankAccountName varchar (150)
END
GO

IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'BankAccountNo' AND Object_ID = Object_ID(N'Profile_Batch'))
BEGIN
    ALTER TABLE Profile_Batch ADD BankAccountNo varchar (20)
END
GO

IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'BankName' AND Object_ID = Object_ID(N'Profile_Batch'))
BEGIN
    ALTER TABLE Profile_Batch ADD BankName varchar (255)
END
GO

IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'BCTransferBy' AND Object_ID = Object_ID(N'Profile_Batch'))
BEGIN
    ALTER TABLE Profile_Batch ADD BCTransferBy int
END
GO

IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'bankCode' AND Object_ID = Object_ID(N'Profile_Batch'))
BEGIN
    ALTER TABLE Profile_Batch ADD bankCode varchar (10)
END
GO

IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'RefType' AND Object_ID = Object_ID(N'Profile_Batch'))
BEGIN
    ALTER TABLE Profile_Batch ADD RefType varchar (50)
END
GO

IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'Currency' AND Object_ID = Object_ID(N'Profile_Batch'))
BEGIN
    ALTER TABLE Profile_Batch ADD Currency varchar (5)
END
GO

IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'PRDays' AND Object_ID = Object_ID(N'Profile_Batch'))
BEGIN
    ALTER TABLE Profile_Batch ADD PRDays int
END
GO

IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'Remarks' AND Object_ID = Object_ID(N'Profile_Batch'))
BEGIN
    ALTER TABLE Profile_Batch ADD Remarks varchar(512)
END
GO