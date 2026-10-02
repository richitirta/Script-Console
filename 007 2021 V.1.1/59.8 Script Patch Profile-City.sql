IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'Name' AND Object_ID = Object_ID(N'City'))
BEGIN
Alter Table City Add Name Varchar(255)
end
GO
IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'Province' AND Object_ID = Object_ID(N'City'))
BEGIN
Alter Table City Add Province Varchar(50)
end
GO
IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'Last_Update' AND Object_ID = Object_ID(N'City'))
BEGIN
Alter Table City Add Last_Update smalldatetime
end
GO
IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'Country' AND Object_ID = Object_ID(N'Province'))
BEGIN
Alter Table Province Add Country Varchar(50)
end
GO
IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'Last_Opr' AND Object_ID = Object_ID(N'City'))
BEGIN
Alter Table City Add Last_Opr Varchar(10)
end
GO
Update Province set Country = '' where Country is Null
GO
Update City set Province = '' where Province is Null
GO
Update City set AllowedF = 1 where AllowedF = 0
GO