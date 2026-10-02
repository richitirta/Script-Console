IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'Province' AND Object_ID = Object_ID(N'profile'))
BEGIN
Alter Table Profile Add Province varchar(25)
END
GO

Update Profile Set Province='' Where Province is null
GO
