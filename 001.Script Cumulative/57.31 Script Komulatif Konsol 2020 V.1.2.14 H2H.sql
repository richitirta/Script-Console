IF  NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'Branch_TOC_RCode') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[Branch_TOC_RCode](
       [Branch] [varchar](10) NOT NULL,
       [TOC] [varchar](10) NOT NULL,
       [RCode] [varchar](10) NOT NULL,
       [TAlias] [varchar](10) NULL,
CONSTRAINT [I_Branch_TOC_RCode] PRIMARY KEY CLUSTERED 
(
       [Branch],[TOC],[RCode]
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
end
GO


--3 MAR 2021 
IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'Status' AND Object_ID = Object_ID(N'SysLogDownload'))
BEGIN
ALTER TABLE SysLogDownload ADD
	Status varchar(1) NULL
	DECLARE @v sql_variant 
SET @v = N'''P''ending, ''C''losed/Rejected; ''A''ccepted'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'SysLogDownload', N'COLUMN', N'Status'
END
GO

GO

IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'ErrMsg' AND Object_ID = Object_ID(N'SysLogDownload'))
BEGIN
ALTER TABLE SysLogDownload ADD
	ErrMsg varchar(255) NULL
	DECLARE @v sql_variant 
SET @v = N'Error Message'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'SysLogDownload', N'COLUMN', N'ErrMsg'
END
GO

GO

IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'LDATE' AND Object_ID = Object_ID(N'SysLogDownload'))
BEGIN
ALTER TABLE SysLogDownload ADD
	LDATE smalldatetime NULL
	DECLARE @v sql_variant 
SET @v = N'Last Update Date'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'SysLogDownload', N'COLUMN', N'LDATE'
END
GO

GO

IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'LTIME' AND Object_ID = Object_ID(N'SysLogDownload'))
BEGIN
ALTER TABLE SysLogDownload ADD
	LTIME varchar(8) NULL
	DECLARE @v sql_variant 
SET @v = N'Last Update Time'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'SysLogDownload', N'COLUMN', N'LTIME'
END
GO

GO

IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'LUSERID' AND Object_ID = Object_ID(N'SysLogDownload'))
BEGIN
ALTER TABLE SysLogDownload ADD
	LUSERID varchar(50) NULL
	DECLARE @v sql_variant 
SET @v = N'Last Update User ID'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'SysLogDownload', N'COLUMN', N'LUSERID'
END
GO

GO

--2020 V.1.3.1
--4 Mar 2021
IF  NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'CustomErrors') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[CustomErrors](
	[ErrFrom] [varchar](50) NULL,
	[ErrType] [varchar](50) NULL,
	[ErrCat] [varchar](50) NULL,
	[ErrCode] [varchar](50) NULL,
	[ErrMessage] [varchar](255) NULL
) ON [PRIMARY]
Create Unique Index I_CustomErrors on CustomErrors(ErrFrom, ErrType, ErrCat, ErrCode, ErrMessage)
END
GO

