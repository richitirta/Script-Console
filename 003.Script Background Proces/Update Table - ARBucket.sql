IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'ARBucket') AND type in (N'U'))
begin
select * into ARBucket_Backup20210301 from ARBucket
END
GO


IF EXISTS(SELECT TOP 1 * FROM Versioning WHERE VerNoApp='2019 V.2.0.0' and VerUpdateApp=CONVERT(char(10), GetDate(),110))
BEGIN
DROP TABLE [dbo].[ARBucket] 
CREATE TABLE [dbo].[ARBucket](
	[PID] [int] IDENTITY(1,1) NOT NULL,
	[A_PolicyNo] [varchar](50) NULL,
	[Bank] [varchar](10) NULL,
	[AccountNo] [varchar](150) NULL,
	[Voucher] [varchar](20) NULL,
	[ComAcc] [varchar](30) NULL,
	[Branch] [varchar](10) NULL,
	[RefType] [varchar](50) NULL,
	[RefNo] [varchar](50) NULL,
	[RefDate] [smalldatetime] NULL,
	[AmountPaid] [float] NOT NULL,
	[Rate] [float] NOT NULL,
	[Status] [varchar](1) NULL,
	[Last_Opr] [varchar](50) NULL,
	[Last_Update] [smalldatetime] NULL,
	[PDate] [smalldatetime] NOT NULL,
	[PVoucher] [varchar](20) NULL,
	[ErrMsg] [varchar](255) NULL,
	[sAccount] [varchar](10) NULL,
	[Charges] [float] NULL,
	[Remarks] [varchar](512) NULL,
	[eAccount] [varchar](10) NULL,
	[CT] [varchar](10) NULL,
	[AutoPrintF] [bit] NULL,
	[Currency] [varchar] (10) Null,
	[Subject] [varchar] (10) Null,
	[Procname] [varchar] (100) Null,
	[Type] [varchar] (10) Null,
 CONSTRAINT [I_ARBucket] PRIMARY KEY CLUSTERED 
(
	[PID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Bucket Status (''R''equest, ''P''rocessed, ''C''losed/Cancelled)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'ARBucket', @level2type=N'COLUMN',@level2name=N'Status'
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Account COA for Payment Difference' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'ARBucket', @level2type=N'COLUMN',@level2name=N'sAccount'
END
GO
--22 jan 2020
IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'NetPaidF' AND Object_ID = Object_ID(N'ARBucket'))
begin
Alter Table ARBucket Add NetPaidF Bit
END
GO


  insert into PatchVersioning
select 'Update Table - ARBucket',GETDATE()
go
