IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'RPBucket') AND type in (N'U'))
begin
select * into RPBucket_Backup20210301 from RPBucket
END
GO
IF EXISTS(SELECT TOP 1 * FROM Versioning WHERE VerNoApp='2019 V.2.0.0' and VerUpdateApp=CONVERT(char(10), GetDate(),110))
BEGIN
DROP TABLE [dbo].[RPBucket]
CREATE TABLE [dbo].[RPBucket](
	[Branch] [varchar](5) NULL,
	[CT] [varchar](10) NULL,
	[ID] [varchar](20) NULL,
	[Date] [smalldatetime] NULL,
	[VType] [varchar](10) NULL,
	[ComAcc] [varchar](20) NULL,
	[Remarks] [varchar](512) NULL,
	[RefType] [varchar](50) NULL,
	[RefDate] [smalldatetime] NULL,
	[RefNo] [varchar](50) NULL,
	[Voucher] [varchar](20) NULL,
	[Currency] [varchar](5) NULL,
	[Nominal] [float] NULL,
	[BatchNo] [varchar](10) NULL,
	[Last_Opr] [varchar](10) NULL,
	[Last_Date] [smalldatetime] NULL,
	[PID] [int] IDENTITY(1,1) NOT NULL,
	[Account] [varchar](20) NULL,
	[Account_1] [varchar](20) NULL,
	[VAccount] [varchar](20) NULL,
	[DocNo] [varchar](50) NULL,
	[BackDatedF] [bit] NULL,
	[Status] [varchar](1) NULL,
	[PDate] [smalldatetime] NULL,
	[Errmsg] [varchar](512) NULL,
	[NVOUCHER] [varchar](20) NULL,
	[PAYMENT] [float] NULL,
	[PAYMENT_DATE] [smalldatetime] NULL,
	[PAYMENT_BACKDATEDF] [bit] NULL,
	[NetPaidF] [bit] NULL,
	[A_PolicyNo] [varchar](50) NULL,
	[Rate] [float] NULL,
	[MVOUCHER] [varchar](20) NULL,
	[Charges] [float] NULL,
	[sAccount] [varchar](10) NULL,
	[eAccount] [varchar](10) NULL
) ON [PRIMARY]
END
GO


IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'gpid' AND Object_ID = Object_ID(N'rpbucket'))
begin	
alter table rpbucket add gpid int
end
go


IF EXISTS (SELECT *  FROM sys.indexes WHERE name='I_RPBUCKET' AND object_id = OBJECT_ID('RPBucket'))
BEGIN
DROP INDEX I_RPBUCKET ON RPBucket
end
GO

CREATE UNIQUE NONCLUSTERED INDEX [I_RPBUCKET] ON [dbo].[RPBucket]
(
	[PID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO

IF EXISTS (SELECT *  FROM sys.indexes WHERE name='I_RPBUCKET_VOUCHER' AND object_id = OBJECT_ID('RPBucket'))
BEGIN
DROP INDEX [I_RPBUCKET_VOUCHER] ON [dbo].[RPBucket]
end
GO

CREATE NONCLUSTERED INDEX [I_RPBUCKET_VOUCHER] ON [dbo].[RPBucket]
(
	[Voucher] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO

IF EXISTS (SELECT *  FROM sys.indexes WHERE name='I_RPBUCKET_VOUCHER_NVOUCHER' AND object_id = OBJECT_ID('RPBucket'))
BEGIN
DROP INDEX [I_RPBUCKET_VOUCHER_NVOUCHER] ON [dbo].[RPBucket]
end
GO

CREATE NONCLUSTERED INDEX [I_RPBUCKET_VOUCHER_NVOUCHER] ON [dbo].[RPBucket]
(
	[Voucher] ASC,
	[NVoucher] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO




SET ANSI_PADDING OFF
GO


  insert into PatchVersioning
select 'Update Table - RPBucket',GETDATE()
go
