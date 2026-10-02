select * into RPBucket_Backup01102018 from RPBucket
go

/****** Object:  Table [dbo].[RPBucket]    Script Date: 1/9/2018 6:42:14 PM ******/
DROP TABLE [dbo].[RPBucket]
GO

/****** Object:  Table [dbo].[RPBucket]    Script Date: 1/9/2018 6:42:14 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

SET ANSI_PADDING ON
GO

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
	[A_PolicyNo] [varchar](50) NULL
) ON [PRIMARY]

GO

Create Unique Index I_RPBucket on RPBucket(PID)
GO
SET ANSI_PADDING OFF
GO


