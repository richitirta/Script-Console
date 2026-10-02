
IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'Currency' AND Object_ID = Object_ID(N'Xaccount'))
BEGIN
Alter table Xaccount add Currency varchar(50)
END
Go

IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'Extra_3' AND Object_ID = Object_ID(N'Xaccount'))
BEGIN
Alter table Xaccount add Extra_3 varchar(50)
END
Go

IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'T7' AND Object_ID = Object_ID(N'Xaccount'))
BEGIN
Alter table Xaccount add T7 varchar(100)
END
Go

IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'T8' AND Object_ID = Object_ID(N'Xaccount'))
BEGIN
Alter table Xaccount add T8 varchar(100)
END
Go

IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'T9' AND Object_ID = Object_ID(N'Xaccount'))
BEGIN
Alter table Xaccount add T9 varchar(100)
END
Go