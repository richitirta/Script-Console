SET QUOTED_IDENTIFIER ON
SET ARITHABORT ON
SET NUMERIC_ROUNDABORT OFF
SET CONCAT_NULL_YIELDS_NULL ON
SET ANSI_NULLS ON
SET ANSI_PADDING ON
SET ANSI_WARNINGS ON

IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'Num_Dependent' AND Object_ID = Object_ID(N'Profile_Ext'))
BEGIN
ALTER TABLE dbo.Profile_Ext ADD
	Num_Dependent Int NULL
end
go
IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'Relation' AND Object_ID = Object_ID(N'Profile_Ext'))
BEGIN
ALTER TABLE dbo.Profile_Ext ADD
	Relation varchar(30)
end
go
IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'Debtor_Class' AND Object_ID = Object_ID(N'Profile_Ext'))
BEGIN
ALTER TABLE dbo.Profile_Ext ADD
	Debtor_Class varchar(30)
end
go
IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'BirthDate_1' AND Object_ID = Object_ID(N'Profile_Ext'))
BEGIN
ALTER TABLE dbo.Profile_Ext ADD
	BirthDate_1 smalldatetime
end
go
IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'Rating_Agency' AND Object_ID = Object_ID(N'Profile_Ext'))
BEGIN
ALTER TABLE dbo.Profile_Ext ADD
	Rating_Agency varchar(100)
end
go
IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'Rating_Date' AND Object_ID = Object_ID(N'Profile_Ext'))
BEGIN
ALTER TABLE dbo.Profile_Ext ADD
	Rating_Date smalldatetime
end
go
IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'ID_No_Ext_1' AND Object_ID = Object_ID(N'Profile_Ext'))
BEGIN
ALTER TABLE dbo.Profile_Ext ADD
	ID_No_Ext_1	varchar(30)
end
go
IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'ID_No_Ext_2' AND Object_ID = Object_ID(N'Profile_Ext'))
BEGIN
ALTER TABLE dbo.Profile_Ext ADD
	ID_No_Ext_2	varchar(30)
end
go
IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'ID_No_Ext_3' AND Object_ID = Object_ID(N'Profile_Ext'))
BEGIN
ALTER TABLE dbo.Profile_Ext ADD
	ID_No_Ext_3	varchar(30)
end
go
IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'ID_Type_Ext_1' AND Object_ID = Object_ID(N'Profile_Ext'))
BEGIN
ALTER TABLE dbo.Profile_Ext ADD
	ID_Type_Ext_1 varchar(50)
end
go
IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'ID_Type_Ext_2' AND Object_ID = Object_ID(N'Profile_Ext'))
BEGIN
ALTER TABLE dbo.Profile_Ext ADD
	ID_Type_Ext_2 varchar(50)
end
go
IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'ID_Type_Ext_3' AND Object_ID = Object_ID(N'Profile_Ext'))
BEGIN
ALTER TABLE dbo.Profile_Ext ADD
	ID_Type_Ext_3 varchar(50)
end
go
IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'BOD_Gender_1' AND Object_ID = Object_ID(N'Profile_Ext'))
BEGIN
ALTER TABLE dbo.Profile_Ext ADD
	BOD_Gender_1 varchar(30)
end
go
IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'BOD_Gender_2' AND Object_ID = Object_ID(N'Profile_Ext'))
BEGIN
ALTER TABLE dbo.Profile_Ext ADD
	BOD_Gender_2 varchar(30)
end
go
IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'BOD_Gender_3' AND Object_ID = Object_ID(N'Profile_Ext'))
BEGIN
ALTER TABLE dbo.Profile_Ext ADD
	BOD_Gender_3 varchar(30)
end
go
IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'BOD_Address_1' AND Object_ID = Object_ID(N'Profile_Ext'))
BEGIN
ALTER TABLE dbo.Profile_Ext ADD
	BOD_Address_1 varchar(1024)
end
go
IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'BOD_Address_2' AND Object_ID = Object_ID(N'Profile_Ext'))
BEGIN
ALTER TABLE dbo.Profile_Ext ADD
	BOD_Address_2 varchar(1024)
end
go
IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'BOD_Address_3' AND Object_ID = Object_ID(N'Profile_Ext'))
BEGIN
ALTER TABLE dbo.Profile_Ext ADD
	BOD_Address_3 varchar(1024)
end
go
IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'BOD_SubDistrict_1' AND Object_ID = Object_ID(N'Profile_Ext'))
BEGIN
ALTER TABLE dbo.Profile_Ext ADD
	BOD_SubDistrict_1 varchar(256)
end
go
IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'BOD_SubDistrict_2' AND Object_ID = Object_ID(N'Profile_Ext'))
BEGIN
ALTER TABLE dbo.Profile_Ext ADD
	BOD_SubDistrict_2 varchar(256)
end
go
IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'BOD_SubDistrict_3' AND Object_ID = Object_ID(N'Profile_Ext'))
BEGIN
ALTER TABLE dbo.Profile_Ext ADD
	BOD_SubDistrict_3 varchar(256)
end
go
IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'BOD_District_1' AND Object_ID = Object_ID(N'Profile_Ext'))
BEGIN
ALTER TABLE dbo.Profile_Ext ADD
	BOD_District_1 varchar(256)
end
go
IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'BOD_District_2' AND Object_ID = Object_ID(N'Profile_Ext'))
BEGIN
ALTER TABLE dbo.Profile_Ext ADD
	BOD_District_2 varchar(256)
end
go
IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'BOD_District_3' AND Object_ID = Object_ID(N'Profile_Ext'))
BEGIN
ALTER TABLE dbo.Profile_Ext ADD
	BOD_District_3 varchar(256)
end
go
IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'BOD_City_1' AND Object_ID = Object_ID(N'Profile_Ext'))
BEGIN
ALTER TABLE dbo.Profile_Ext ADD
	BOD_City_1 varchar(50)
end
go
IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'BOD_City_2' AND Object_ID = Object_ID(N'Profile_Ext'))
BEGIN
ALTER TABLE dbo.Profile_Ext ADD
	BOD_City_2 varchar(50)
end
go
IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'BOD_City_3' AND Object_ID = Object_ID(N'Profile_Ext'))
BEGIN
ALTER TABLE dbo.Profile_Ext ADD
	BOD_City_3 varchar(50)
end
go
IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'Own_Share' AND Object_ID = Object_ID(N'Profile_Ext'))
BEGIN
ALTER TABLE dbo.Profile_Ext ADD
	Own_Share Float
end
go
IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'Own_Status' AND Object_ID = Object_ID(N'Profile_Ext'))
BEGIN
ALTER TABLE dbo.Profile_Ext ADD
	Own_Status varchar(30)
end
GO

EXEC sys.sp_addextendedproperty @name = N'MS_Description', @value = N'Number of Dependents', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE',  @level1name = N'Profile_Ext', @level2type = N'COLUMN', @level2name = N'Num_Dependent'
GO
EXEC sys.sp_addextendedproperty @name = N'MS_Description', @value = N'Relationship to the informant', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE',  @level1name = N'Profile_Ext', @level2type = N'COLUMN', @level2name = N'Relation'
GO
EXEC sys.sp_addextendedproperty @name = N'MS_Description', @value = N'Partner date of birth', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE',  @level1name = N'Profile_Ext', @level2type = N'COLUMN', @level2name = N'BirthDate_1'
GO
EXEC sys.sp_addextendedproperty @name = N'MS_Description', @value = N'Debtor classification', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE',  @level1name = N'Profile_Ext', @level2type = N'COLUMN', @level2name = N'Debtor_Class'
GO
EXEC sys.sp_addextendedproperty @name = N'MS_Description', @value = N'Rating Agency', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE',  @level1name = N'Profile_Ext', @level2type = N'COLUMN', @level2name = N'Rating_Agency'
GO
EXEC sys.sp_addextendedproperty @name = N'MS_Description', @value = N'Rating Date', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE',  @level1name = N'Profile_Ext', @level2type = N'COLUMN', @level2name = N'Rating_Date'
GO
EXEC sys.sp_addextendedproperty @name = N'MS_Description', @value = N'ID No of BOD 1 ', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE',  @level1name = N'Profile_Ext', @level2type = N'COLUMN', @level2name = N'ID_No_Ext_1'
GO
EXEC sys.sp_addextendedproperty @name = N'MS_Description', @value = N'ID No of BOD 2', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE',  @level1name = N'Profile_Ext', @level2type = N'COLUMN', @level2name = N'ID_No_Ext_2'
GO
EXEC sys.sp_addextendedproperty @name = N'MS_Description', @value = N'ID No of BOD 3', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE',  @level1name = N'Profile_Ext', @level2type = N'COLUMN', @level2name = N'ID_No_Ext_3'
GO
EXEC sys.sp_addextendedproperty @name = N'MS_Description', @value = N'ID Type of BOD 1', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE',  @level1name = N'Profile_Ext', @level2type = N'COLUMN', @level2name = N'ID_Type_Ext_1'
GO
EXEC sys.sp_addextendedproperty @name = N'MS_Description', @value = N'ID Type of BOD 2', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE',  @level1name = N'Profile_Ext', @level2type = N'COLUMN', @level2name = N'ID_Type_Ext_2'
GO
EXEC sys.sp_addextendedproperty @name = N'MS_Description', @value = N'ID Type of BOD 3', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE',  @level1name = N'Profile_Ext', @level2type = N'COLUMN', @level2name = N'ID_Type_Ext_3'
GO
EXEC sys.sp_addextendedproperty @name = N'MS_Description', @value = N'Gender of BOD 1', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE',  @level1name = N'Profile_Ext', @level2type = N'COLUMN', @level2name = N'BOD_Gender_1'
GO
EXEC sys.sp_addextendedproperty @name = N'MS_Description', @value = N'Gender of BOD 2', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE',  @level1name = N'Profile_Ext', @level2type = N'COLUMN', @level2name = N'BOD_Gender_2'
GO
EXEC sys.sp_addextendedproperty @name = N'MS_Description', @value = N'Gender of BOD 3', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE',  @level1name = N'Profile_Ext', @level2type = N'COLUMN', @level2name = N'BOD_Gender_3'
GO
EXEC sys.sp_addextendedproperty @name = N'MS_Description', @value = N'Address of BOD 1', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE',  @level1name = N'Profile_Ext', @level2type = N'COLUMN', @level2name = N'BOD_Address_1'
GO
EXEC sys.sp_addextendedproperty @name = N'MS_Description', @value = N'Address of BOD 2', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE',  @level1name = N'Profile_Ext', @level2type = N'COLUMN', @level2name = N'BOD_Address_2'
GO
EXEC sys.sp_addextendedproperty @name = N'MS_Description', @value = N'Address of BOD 3', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE',  @level1name = N'Profile_Ext', @level2type = N'COLUMN', @level2name = N'BOD_Address_3'
GO
EXEC sys.sp_addextendedproperty @name = N'MS_Description', @value = N'SubDistrict of BOD 1', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE',  @level1name = N'Profile_Ext', @level2type = N'COLUMN', @level2name = N'BOD_SubDistrict_1'
GO
EXEC sys.sp_addextendedproperty @name = N'MS_Description', @value = N'SubDistrict of BOD 2', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE',  @level1name = N'Profile_Ext', @level2type = N'COLUMN', @level2name = N'BOD_SubDistrict_2'
GO
EXEC sys.sp_addextendedproperty @name = N'MS_Description', @value = N'SubDistrict of BOD 3', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE',  @level1name = N'Profile_Ext', @level2type = N'COLUMN', @level2name = N'BOD_SubDistrict_3'
GO
EXEC sys.sp_addextendedproperty @name = N'MS_Description', @value = N'District of BOD 1', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE',  @level1name = N'Profile_Ext', @level2type = N'COLUMN', @level2name = N'BOD_District_1'
GO
EXEC sys.sp_addextendedproperty @name = N'MS_Description', @value = N'District of BOD 2', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE',  @level1name = N'Profile_Ext', @level2type = N'COLUMN', @level2name = N'BOD_District_2'
GO
EXEC sys.sp_addextendedproperty @name = N'MS_Description', @value = N'District of BOD 3', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE',  @level1name = N'Profile_Ext', @level2type = N'COLUMN', @level2name = N'BOD_District_3'
GO
EXEC sys.sp_addextendedproperty @name = N'MS_Description', @value = N'City of BOD 1', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE',  @level1name = N'Profile_Ext', @level2type = N'COLUMN', @level2name = N'BOD_City_1'
GO
EXEC sys.sp_addextendedproperty @name = N'MS_Description', @value = N'City of BOD 2', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE',  @level1name = N'Profile_Ext', @level2type = N'COLUMN', @level2name = N'BOD_City_2'
GO
EXEC sys.sp_addextendedproperty @name = N'MS_Description', @value = N'City of BOD 3', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE',  @level1name = N'Profile_Ext', @level2type = N'COLUMN', @level2name = N'BOD_City_3'
GO
EXEC sys.sp_addextendedproperty @name = N'MS_Description', @value = N'Owner Share', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE',  @level1name = N'Profile_Ext', @level2type = N'COLUMN', @level2name = N'Own_Share'
GO
EXEC sys.sp_addextendedproperty @name = N'MS_Description', @value = N'Owner Status', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE',  @level1name = N'Profile_Ext', @level2type = N'COLUMN', @level2name = N'Own_Status'
GO


IF  NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'Profile_FS') AND type in (N'U'))
BEGIN
SET QUOTED_IDENTIFIER ON
SET ARITHABORT ON
SET NUMERIC_ROUNDABORT OFF
SET CONCAT_NULL_YIELDS_NULL ON
SET ANSI_NULLS ON
SET ANSI_PADDING ON
SET ANSI_WARNINGS ON

CREATE TABLE dbo.Profile_FS(
	[ID] [varchar](10) NOT NULL,
	[Year] [int] NOT NULL,
	[Month] [int] NOT NULL,
	[PositionAsset] [int] NULL,
	[Asset] [float] NULL,
	[CurrentAsset] [float] NULL,
	[CashEquivalent] [float] NULL,
	[TradeReceivablesCurrent] [float] NULL,
	[OtherInvCurrent] [float] NULL,
	[OtherCurrentAsset] [float] NULL,
	[NonCurrentAsset] [float] NULL,
	[TradeReceivablesNonCurrent] [float] NULL,
	[OtherInvNonCurrent] [float] NULL,
	[OtherNonCurrentAsset] [float] NULL,
	[Liability] [float] NULL,
	[ShortTermLiability] [float] NULL,
	[ShortTermLoan] [float] NULL,
	[ShortTermTradePayables] [float] NULL,
	[OtherShortTermLiability] [float] NULL,
	[LongTermLiability] [float] NULL,
	[LongTermLoan] [float] NULL,
	[LongTermTradePayables] [float] NULL,
	[OtherLongTermLiability] [float] NULL,
	[Equity] [float] NULL,
	[OpRevenue] [float] NULL,
	[OpExpenses] [float] NULL,
	[GrossProfitLoss] [float] NULL,
	[OtherIncome] [float] NULL,
	[OtherExpenses] [float] NULL,
	[ProfitLossBeforeTax] [float] NULL,
	[CurrentYearProfitLoss] [float] NULL,
	[Last_Opr] [varchar](50) NULL,
	[Last_Update] [smalldatetime] NULL,
	[Last_Time] [varchar](8) NULL,
CONSTRAINT [i_ProfileFS] PRIMARY KEY NONCLUSTERED 
(
	[ID] ASC,
	[Year] ASC,
	[Month] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = OFF) ON [PRIMARY]
) ON [PRIMARY]


ALTER TABLE [dbo].[Profile_FS]  WITH CHECK ADD  CONSTRAINT [FK_Profile_FS_Profile] FOREIGN KEY([ID])
REFERENCES [dbo].[Profile] ([ID])
ON UPDATE CASCADE
ON DELETE CASCADE


ALTER TABLE [dbo].[Profile_FS] CHECK CONSTRAINT [FK_Profile_FS_Profile]
end
go
begin transaction
EXEC sys.sp_addextendedproperty @name = N'MS_Description', @value = N'Unique code for each ID', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE',  @level1name = N'Profile_FS', @level2type = N'COLUMN', @level2name = N'ID'
GO
EXEC sys.sp_addextendedproperty @name = N'MS_Description', @value = N'Financial Statement in Year', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE',  @level1name = N'Profile_FS', @level2type = N'COLUMN', @level2name = N'Year'
GO
EXEC sys.sp_addextendedproperty @name = N'MS_Description', @value = N'Financial Statement in Month', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE',  @level1name = N'Profile_FS', @level2type = N'COLUMN', @level2name = N'Month'
GO
EXEC sys.sp_addextendedproperty @name = N'MS_Description', @value = N'Annual Financial Statement Position', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE',  @level1name = N'Profile_FS', @level2type = N'COLUMN', @level2name = N'PositionAsset'
GO
EXEC sys.sp_addextendedproperty @name = N'MS_Description', @value = N'Total Value of All Assets', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE',  @level1name = N'Profile_FS', @level2type = N'COLUMN', @level2name = N'Asset'
GO
EXEC sys.sp_addextendedproperty @name = N'MS_Description', @value = N'Total Value of All Current Assets', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE',  @level1name = N'Profile_FS', @level2type = N'COLUMN', @level2name = N'CurrentAsset'
GO
EXEC sys.sp_addextendedproperty @name = N'MS_Description', @value = N'Cash and cash equivalents (current assets)', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE',  @level1name = N'Profile_FS', @level2type = N'COLUMN', @level2name = N'CashEquivalent'
GO
EXEC sys.sp_addextendedproperty @name = N'MS_Description', @value = N'Trade receivables / financing receivables (current assets)', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE',  @level1name = N'Profile_FS', @level2type = N'COLUMN', @level2name = N'TradeReceivablesCurrent'
GO
EXEC sys.sp_addextendedproperty @name = N'MS_Description', @value = N'Investments / other financial assets (current assets)', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE',  @level1name = N'Profile_FS', @level2type = N'COLUMN', @level2name = N'OtherInvCurrent'
GO
EXEC sys.sp_addextendedproperty @name = N'MS_Description', @value = N'Other current assets (current assets)', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE',  @level1name = N'Profile_FS', @level2type = N'COLUMN', @level2name = N'OtherCurrentAsset'
GO
EXEC sys.sp_addextendedproperty @name = N'MS_Description', @value = N'Non-current assets', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE',  @level1name = N'Profile_FS', @level2type = N'COLUMN', @level2name = N'NonCurrentAsset'
GO
EXEC sys.sp_addextendedproperty @name = N'MS_Description', @value = N'Trade receivables / financing receivables (non-current assets)', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE',  @level1name = N'Profile_FS', @level2type = N'COLUMN', @level2name = N'TradeReceivablesNonCurrent'
GO
EXEC sys.sp_addextendedproperty @name = N'MS_Description', @value = N'Investments / other financial assets (non-current assets)', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE',  @level1name = N'Profile_FS', @level2type = N'COLUMN', @level2name = N'OtherInvNonCurrent'
GO
EXEC sys.sp_addextendedproperty @name = N'MS_Description', @value = N'Other non-current assets (non-current assets)', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE',  @level1name = N'Profile_FS', @level2type = N'COLUMN', @level2name = N'OtherNonCurrentAsset'
GO
EXEC sys.sp_addextendedproperty @name = N'MS_Description', @value = N'Total Value of All Liability', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE',  @level1name = N'Profile_FS', @level2type = N'COLUMN', @level2name = N'Liability'
GO
EXEC sys.sp_addextendedproperty @name = N'MS_Description', @value = N'Short-Term Liability', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE',  @level1name = N'Profile_FS', @level2type = N'COLUMN', @level2name = N'ShortTermLiability'
GO
EXEC sys.sp_addextendedproperty @name = N'MS_Description', @value = N'Short-Term Loan (Short-Term Liability) ', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE',  @level1name = N'Profile_FS', @level2type = N'COLUMN', @level2name = N'ShortTermLoan'
GO
EXEC sys.sp_addextendedproperty @name = N'MS_Description', @value = N'Short-Term Trade Payables (Short-Term Liability)', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE',  @level1name = N'Profile_FS', @level2type = N'COLUMN', @level2name = N'ShortTermTradePayables'
GO
EXEC sys.sp_addextendedproperty @name = N'MS_Description', @value = N'Other Short-Term Liability (Short-Term Liability)', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE',  @level1name = N'Profile_FS', @level2type = N'COLUMN', @level2name = N'OtherShortTermLiability'
GO
EXEC sys.sp_addextendedproperty @name = N'MS_Description', @value = N'Long Term Liability', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE',  @level1name = N'Profile_FS', @level2type = N'COLUMN', @level2name = N'LongTermLiability'
GO
EXEC sys.sp_addextendedproperty @name = N'MS_Description', @value = N'Long-Term Loan', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE',  @level1name = N'Profile_FS', @level2type = N'COLUMN', @level2name = N'LongTermLoan'
GO
EXEC sys.sp_addextendedproperty @name = N'MS_Description', @value = N'Long-Term Trade Payables (Long-Term Liability)', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE',  @level1name = N'Profile_FS', @level2type = N'COLUMN', @level2name = N'LongTermTradePayables'
GO
EXEC sys.sp_addextendedproperty @name = N'MS_Description', @value = N'Other Long-Term Liabilities (Long-Term Liabilities)', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE',  @level1name = N'Profile_FS', @level2type = N'COLUMN', @level2name = N'OtherLongTermLiability'
GO
EXEC sys.sp_addextendedproperty @name = N'MS_Description', @value = N'The Difference Between Total Assets and Total Liabilities', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE',  @level1name = N'Profile_FS', @level2type = N'COLUMN', @level2name = N'Equity'
GO
EXEC sys.sp_addextendedproperty @name = N'MS_Description', @value = N'Business Revenue / Operation', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE',  @level1name = N'Profile_FS', @level2type = N'COLUMN', @level2name = N'OpRevenue'
GO
EXEC sys.sp_addextendedproperty @name = N'MS_Description', @value = N'Cost Of Revenues / Operating Expenses', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE',  @level1name = N'Profile_FS', @level2type = N'COLUMN', @level2name = N'OpExpenses'
GO
EXEC sys.sp_addextendedproperty @name = N'MS_Description', @value = N'The Difference Between Operating Revenue and Cost of Revenue', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE',  @level1name = N'Profile_FS', @level2type = N'COLUMN', @level2name = N'GrossProfitLoss'
GO
EXEC sys.sp_addextendedproperty @name = N'MS_Description', @value = N'Other Income / Non-Operating', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE',  @level1name = N'Profile_FS', @level2type = N'COLUMN', @level2name = N'OtherIncome'
GO
EXEC sys.sp_addextendedproperty @name = N'MS_Description', @value = N'Other Expenses / Non-Operating', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE',  @level1name = N'Profile_FS', @level2type = N'COLUMN', @level2name = N'OtherExpenses'
GO
EXEC sys.sp_addextendedproperty @name = N'MS_Description', @value = N'The Difference Between Other Income and Other Expenses', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE',  @level1name = N'Profile_FS', @level2type = N'COLUMN', @level2name = N'ProfitLossBeforeTax'
GO
EXEC sys.sp_addextendedproperty @name = N'MS_Description', @value = N'Current Year Profit / Loss', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE',  @level1name = N'Profile_FS', @level2type = N'COLUMN', @level2name = N'CurrentYearProfitLoss'
GO
EXEC sys.sp_addextendedproperty @name = N'MS_Description', @value = N'Last User Update', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE',  @level1name = N'Profile_FS', @level2type = N'COLUMN', @level2name = N'Last_Opr'
GO
EXEC sys.sp_addextendedproperty @name = N'MS_Description', @value = N'Last Date Update', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE',  @level1name = N'Profile_FS', @level2type = N'COLUMN', @level2name = N'Last_Update'
GO
EXEC sys.sp_addextendedproperty @name = N'MS_Description', @value = N'Last Time Update', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE',  @level1name = N'Profile_FS', @level2type = N'COLUMN', @level2name = N'Last_Time'
GO

if exists (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'vProfile') ) 
BEGIN 
DROP VIEW dbo.vProfile 
 END
GO

Create View vProfile
WITH SCHEMABINDING
AS
select 
	Profile.ID
	,Profile.Salutation
	,Profile.FirstName
	,Profile.MidName
	,Profile.LastName
	,Profile.Name
	,Profile.Initial
	,Profile.Address_1
	,Profile.Address_2
	,Profile.Address_3
	,Profile.City
	,Profile.ZipCode
	,Profile.Phone_1
	,Profile.Phone_2
	,Profile.Mobile_1
	,Profile.Mobile_2
	,Profile.Fax_1
	,Profile.Fax_2
	,Profile.Contact
	,Profile.ContactAddress
	,Profile.ContactPhone
	,Profile.Title
	,Profile.PTYPE
	,Profile.RefID
	,dbo.fn_DECRYPTTEXT(SysTab.EncryptionPassPhrase,Profile.TaxID) as TaxID
	,dbo.fn_DECRYPTTEXT(SysTab.EncryptionPassPhrase,Profile.Email) as Email
	,dbo.fn_DECRYPTTEXT(SysTab.EncryptionPassPhrase,Profile.Email_2) as Email_2
	,Profile.TaxName
	,Profile.TaxAddress
	,Profile.VatF
	,Profile.TaxF
	,Profile.LOB
	,Profile.Country
	,Profile.CorporateF
	,Profile.IntermediaryF
	,Profile.Rating
	,Profile.CGroup
	,Profile.SCGroup
	,Profile.Area
	,Profile.TaxType
	,Profile.VAT
	,Profile.TAX
	,Profile.TAXPCT
	,Profile.NTAXINCOME
	,Profile.LAST_OPR
	,Profile.LAST_UPDATE
	,Profile.PID
	,Profile.COMM
	,Profile.Disc
	,Profile.RESTRICTEDF
	,Profile.PREFERREDF
	,Profile.REMARK
	,Profile.CTYPE
	,Profile.ProviderF
	,Profile.RedFlag
	,Profile.RedFlagDate
	,Profile.RedFlagTime
	,Profile.RedFlagDescription
	,Profile.RedFlagUser
	,Profile.DumpF
	,dbo.fn_DECRYPTTEXT(SysTab.EncryptionPassPhrase,Profile.USERID) as USERID
	,Profile.CDATE
	,Profile.ASource
	,Profile.Owner
	,Profile.WPC
	,Profile.Grace
	,Profile.Branch
	,Profile.NetCommF
	,Profile.MaxOutGo
	,Profile.LicenseNo
	,Profile.TPAF
	,Profile.Province
	,Profile.XProfileID
	,Profile.ICPSF
	,Profile.RType
	,Profile.LicenseDate
	,Profile.LicenseExpiry
	,Profile.ContactTitle
	,Profile.TAXHSDate
	,Profile.TAXHEDate
	,Profile.MOID
	,Profile.HSCode
	,Profile.BIType
	,Profile.AccruedTax
	,Profile.Last_Time
	,Profile.Regency
	,Profile.SubsidiaryF
	,Profile.Latitude
	,Profile.Longtitude
	,Profile.District
	,Profile.SubDistrict
	,Profile.RoomNo
	,Profile.FloorNo
	,Profile.HomeNo
	,Profile.MOO
	,Profile.SOI
	,Profile.Village
	,Profile.Building
	,Profile.Road
	,Profile.SyncDate
	,Profile.SyncTime
	,Profile.SYNCERRORMESSAGE
	,Profile.BVATF
	,Profile.TVATF
	,Profile.RestrictedDate
	,Profile.RestrictedTime
	,Profile.RestrictedUser
	,Profile.PrivilegeType
	,Profile.DeferralF
	,Profile.VerifiedBy
	,Profile.VerifiedDate
	,Profile.VerifiedTime
	,Profile.VATOLD
	,Profile.VATSubsidiesF
	,Profile.VATESDate
	,Profile.VATEEDate
	,Profile.CBRAID
	,Profile.CBRADATE
	,Profile.CBRANRDATE
	,Profile.ConsentOnDataKeepByCompanyF
	,Profile.ConsentOnDataPrivacyToThirdPartyF
	,Profile.ConsentOnProductAndServiceOfferingF
	,Profile.VerifiedF
	,Profile.AccruedVAT
	,Profile.TAXIDOLD
	,Profile.Email_3
	,Profile.VATCOMMEXEMPTIF
	,Profile.TAXSubsidiesF
from dbo.Profile Profile
Inner Join dbo.SysTab SysTab on (1=1)

GO

if exists (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'vProfile_Ext') ) 
BEGIN 
DROP VIEW dbo.vProfile_Ext 
 END
GO

Create View vProfile_Ext
WITH SCHEMABINDING
AS
select 
	Profile.ID
	,Profile.BLNo
	,Profile.BLDate
	,Profile.BOD_1
	,Profile.BODFunction_1
	,Profile.BOD_2
	,Profile.BODFunction_2
	,Profile.BOD_3
	,Profile.BODFunction_3
	,Profile.SHolder_1
	,Profile.SHolder_2
	,Profile.SHolder_3
	,Profile.WNIF
	,Profile.NickName
	,Profile.Citizen
	,Profile.CName
	,Profile.CAddress
	,Profile.CPhone_1
	,Profile.CPhone_2
	,Profile.Employment
	,Profile.Income
	,Profile.OtherIncome
	,Profile.ID_Date
	,dbo.fn_DECRYPTTEXT(SysTab.EncryptionPassPhrase,Profile.ID_No) as ID_No
	,dbo.fn_DECRYPTTEXT(SysTab.EncryptionPassPhrase,Profile.ID_Type) as ID_Type 
	,dbo.fn_DECRYPTTEXT(SysTab.EncryptionPassPhrase,Profile.PassportNo) as PassportNo 
	,dbo.fn_DECRYPTTEXT(SysTab.EncryptionPassPhrase,Profile.Gender) as Gender 
	,dbo.fn_DECRYPTTEXT(SysTab.EncryptionPassPhrase,Profile.MothersName) as MothersName 
	,dbo.fn_DECRYPTDATE(SysTab.EncryptionPassPhrase,Profile.BirthDate) as BirthDate 
	,Profile.ID_Name
	,Profile.BirthPlace
	,Profile.Religion
	,Profile.Purpose
	,Profile.SIUP
	,Profile.TDP
	,Profile.Marital
	,Profile.JOBTitle
	,Profile.PIC_TITLE_1
	,Profile.PIC_NAME_1
	,Profile.PIC_TITLE_2
	,Profile.PIC_NAME_2
	,Profile.PIC_TITLE_3
	,Profile.PIC_NAME_3
	,Profile.HOMEPAGE
	,Profile.ID_Date_Ext
	,Profile.ID_No_Ext
	,Profile.ID_Name_Ext
	,Profile.ID_Type_Ext
	,Profile.ADDHOMEPAGE
	,Profile.BLPlace
	,Profile.CBRAFLAG
	,Profile.CBRATPMID
	,Profile.CBRADepartment
	,Profile.CBRACOID
	,Profile.CBRATPRMID
	,Profile.CBRATPStatus
	,Profile.CBRATPTYPE
	,Profile.CBRATPRMSCOPE
	,Profile.CBRANDASTATUS
	,Profile.CBRANDAEFFDATE
	,Profile.CBRANDAEXPDATE
	,Profile.CBRAAgreement
	,Profile.CBRAAgreementStatus
	,Profile.CBRAAgreementEffDate
	,Profile.CBRAAgreementExpDate
	,Profile.CBRAOBDDDate
	,Profile.CBRAOBDDStatus
	,Profile.CBRAOBDDRating
	,Profile.CBRALODDID
	,Profile.CBRALODDStatus
	,Profile.CBRALODDCreateDate
	,Profile.CBRALODDCompDate
	,Profile.CBRALatestResRisk
	,Profile.CBRALatestMaxInfoSec
	,Profile.CBRALatestMaxBCM
	,Profile.CBRALatestMaxCompliance
	,Profile.CBRALatestCurrFVA
	,Profile.CBRALatestMaxMateriality
	,Profile.CBRANDDSInfoSecDate
	,Profile.CBRANDDSBusContDate
	,Profile.CBRANDDSFVADate
	,Profile.CBRANDDSMaterialityDate
	,Profile.CBRANDDSISODate
	,Profile.CBRAODDSDate
	,Profile.CBRAODDSTPDate
	,Profile.BeneficiaryOwner
	,Profile.CBRAOBID
	,Profile.CBRAOBCDDate
	,Profile.CBRANOREFDATE
	,Profile.CBRATPEForm
	,Profile.CBRATPEFormSubDate
	,Profile.CBRAODDCDate
	,Profile.DomicileAddress
	,Profile.AddressSameIDF
	,Profile.PIDExpDate
	,Profile.NoPIDExpDateF
	,Profile.LastEducation
	,Profile.MonthlyIncome
	,Profile.MonthlyExpenses
	,Profile.Num_Dependent
	,Profile.Relation
	,Profile.Debtor_Class
	,Profile.BirthDate_1
	,Profile.Rating_Agency
	,Profile.Rating_Date
	,Profile.ID_No_Ext_1
	,Profile.ID_Type_Ext_1
	,Profile.ID_No_Ext_2
	,Profile.ID_Type_Ext_2
	,Profile.ID_No_Ext_3
	,Profile.ID_Type_Ext_3
	,Profile.BOD_Gender_1
	,Profile.BOD_Gender_2
	,Profile.BOD_Gender_3
	,Profile.BOD_Address_1
	,Profile.BOD_Address_2
	,Profile.BOD_Address_3
	,Profile.BOD_SubDistrict_1
	,Profile.BOD_SubDistrict_2
	,Profile.BOD_SubDistrict_3
	,Profile.BOD_District_1
	,Profile.BOD_District_2
	,Profile.BOD_District_3
	,Profile.BOD_City_1
	,Profile.BOD_City_2
	,Profile.BOD_City_3
	,Profile.Own_Share
	,Profile.Own_Status
from dbo.Profile_Ext Profile
Inner Join dbo.SysTab SysTab on (1=1)


GO

if exists (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'vProAcc') ) 
BEGIN 
DROP View vProAcc
end
GO
Create View vProAcc
WITH SCHEMABINDING
AS
select 
ProAcc.ProAcc, 
ProAcc.Description, 
ProAcc.Currency, 
ProAcc.ID, 
dbo.fn_DECRYPTTEXT(SysTab.EncryptionPassPhrase,ProAcc.AccountNo) as AccountNO, 
dbo.fn_DECRYPTTEXT(SysTab.EncryptionPassPhrase,ProAcc.BankAccount) as BankAccount, 
ProAcc.BankName, 
ProAcc.Bank,
ProAcc.BankBranch,
ProAcc.RestrictedF, 
ProAcc.Last_Opr, 
ProAcc.Last_Update, 
ProAcc.UserID, 
ProAcc.CDate, 
ProAcc.BCTransferBy, 
ProAcc.RESTRICTAFTERUSEDF, 
ProAcc.Remarks, 
ProAcc.PUserID, 
ProAcc.PUserDate,
ProAcc.ExcludeTaxF, 
ProAcc.RefType, 
ProAcc.PRDays, 
ProAcc.Purpose, 
ProAcc.Account_DR, 
ProAcc.Account_CR
from dbo.Proacc ProAcc
Inner Join dbo.SysTab SysTab on (1=1)
go



IF  NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'CompanyRelationType') AND type in (N'U'))
begin
SET ANSI_NULLS ON
 
SET QUOTED_IDENTIFIER ON
 

CREATE TABLE [dbo].[CompanyRelationType](
	[CompanyRelationType] [varchar](10) NOT NULL,
	[Description] [varchar](255) NULL,
	[AllowedF] [bit] NULL,
	[Last_Opr] [varchar](50) NULL,
	[Last_Update] [smalldatetime] NULL,
 CONSTRAINT [I_CompanyRelationType] PRIMARY KEY CLUSTERED 
(
	[CompanyRelationType] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = OFF) ON [PRIMARY]
) ON [PRIMARY]


ALTER TABLE [dbo].[CompanyRelationType] SET (LOCK_ESCALATION = DISABLE)


ALTER TABLE [dbo].[CompanyRelationType] ADD  DEFAULT (0) FOR [AllowedF]


EXEC sys.sp_addextendedproperty 
    @name = N'MS_Description', 
    @value = N'Unique code for each company relationship type', 
    @level0type = N'SCHEMA', @level0name = N'dbo', 
    @level1type = N'TABLE',  @level1name = N'CompanyRelationType', 
    @level2type = N'COLUMN', @level2name = N'CompanyRelationType'


EXEC sys.sp_addextendedproperty 
    @name = N'MS_Description', 
    @value = N'Description of the company relationship type', 
    @level0type = N'SCHEMA', @level0name = N'dbo', 
    @level1type = N'TABLE',  @level1name = N'CompanyRelationType', 
    @level2type = N'COLUMN', @level2name = N'Description'


EXEC sys.sp_addextendedproperty 
    @name = N'MS_Description', 
    @value = N'Flag indicating whether this relation type is allowed/active (0=No, 1=Yes)', 
    @level0type = N'SCHEMA', @level0name = N'dbo', 
    @level1type = N'TABLE',  @level1name = N'CompanyRelationType', 
    @level2type = N'COLUMN', @level2name = N'AllowedF'


EXEC sys.sp_addextendedproperty 
    @name = N'MS_Description', 
    @value = N'Last operator/user who updated this record', 
    @level0type = N'SCHEMA', @level0name = N'dbo', 
    @level1type = N'TABLE',  @level1name = N'CompanyRelationType', 
    @level2type = N'COLUMN', @level2name = N'Last_Opr'
 

EXEC sys.sp_addextendedproperty 
    @name = N'MS_Description', 
    @value = N'Date and time of last update on this record', 
    @level0type = N'SCHEMA', @level0name = N'dbo', 
    @level1type = N'TABLE',  @level1name = N'CompanyRelationType', 
    @level2type = N'COLUMN', @level2name = N'Last_Update'

end
 go

 IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'Description' AND Object_ID = Object_ID(N'ID_TYPE'))
BEGIN
--- Update Table ID_TYPE
ALTER TABLE [dbo].[ID_TYPE] ADD 
    [Description] [varchar](255) NULL
end
go
 IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'Last_Opr' AND Object_ID = Object_ID(N'ID_TYPE'))
BEGIN
ALTER TABLE [dbo].[ID_TYPE] ADD 
    [Last_Opr] [varchar](50) NULL
end
go
 IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'Last_Update' AND Object_ID = Object_ID(N'ID_TYPE'))
BEGIN
ALTER TABLE [dbo].[ID_TYPE] ADD 
    [Last_Update] [smalldatetime] NULL
end
GO

EXEC sys.sp_addextendedproperty 
    @name = N'MS_Description', 
    @value = N'Description for ID_TYPE record', 
    @level0type = N'SCHEMA', @level0name = N'dbo', 
    @level1type = N'TABLE',  @level1name = N'ID_TYPE', 
    @level2type = N'COLUMN', @level2name = N'Description'
GO

EXEC sys.sp_addextendedproperty 
    @name = N'MS_Description', 
    @value = N'Last operator/user who updated this record', 
    @level0type = N'SCHEMA', @level0name = N'dbo', 
    @level1type = N'TABLE',  @level1name = N'ID_TYPE', 
    @level2type = N'COLUMN', @level2name = N'Last_Opr'
GO

EXEC sys.sp_addextendedproperty 
    @name = N'MS_Description', 
    @value = N'Date and time of last update on this record', 
    @level0type = N'SCHEMA', @level0name = N'dbo', 
    @level1type = N'TABLE',  @level1name = N'ID_TYPE', 
    @level2type = N'COLUMN', @level2name = N'Last_Update'
GO


IF  NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'DebtorGroup') AND type in (N'U'))
BEGIN
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[DebtorGroup](
	[DebtorGroup] [varchar](10) NOT NULL,
	[Description] [varchar](255) NULL,
	[AllowedF] [bit] NULL,
	[Last_Opr] [varchar](50) NULL,
	[Last_Update] [smalldatetime] NULL,
 CONSTRAINT [I_DebtorGroup] PRIMARY KEY CLUSTERED 
(
	[DebtorGroup] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = OFF) ON [PRIMARY]
) ON [PRIMARY]


ALTER TABLE [dbo].[DebtorGroup] SET (LOCK_ESCALATION = DISABLE)

ALTER TABLE [dbo].[DebtorGroup] ADD  DEFAULT (0) FOR [AllowedF]


EXEC sys.sp_addextendedproperty 
    @name = N'MS_Description', 
    @value = N'Unique code for each debtor group', 
    @level0type = N'SCHEMA', @level0name = N'dbo', 
    @level1type = N'TABLE',  @level1name = N'DebtorGroup', 
    @level2type = N'COLUMN', @level2name = N'DebtorGroup'


EXEC sys.sp_addextendedproperty 
    @name = N'MS_Description', 
    @value = N'Description of the debtor group', 
    @level0type = N'SCHEMA', @level0name = N'dbo', 
    @level1type = N'TABLE',  @level1name = N'DebtorGroup', 
    @level2type = N'COLUMN', @level2name = N'Description'


EXEC sys.sp_addextendedproperty 
    @name = N'MS_Description', 
    @value = N'Flag indicating whether this debtor group is allowed/active (0=No, 1=Yes)', 
    @level0type = N'SCHEMA', @level0name = N'dbo', 
    @level1type = N'TABLE',  @level1name = N'DebtorGroup', 
    @level2type = N'COLUMN', @level2name = N'AllowedF'


EXEC sys.sp_addextendedproperty 
    @name = N'MS_Description', 
    @value = N'Last operator/user who updated this record', 
    @level0type = N'SCHEMA', @level0name = N'dbo', 
    @level1type = N'TABLE',  @level1name = N'DebtorGroup', 
    @level2type = N'COLUMN', @level2name = N'Last_Opr'


EXEC sys.sp_addextendedproperty 
    @name = N'MS_Description', 
    @value = N'Date and time of last update on this record', 
    @level0type = N'SCHEMA', @level0name = N'dbo', 
    @level1type = N'TABLE',  @level1name = N'DebtorGroup', 
    @level2type = N'COLUMN', @level2name = N'Last_Update'
end
go

 IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'Description' AND Object_ID = Object_ID(N'EMPLOYMENT'))
BEGIN
ALTER TABLE [dbo].EMPLOYMENT ADD [Description] [varchar](255) NULL
END
GO

 IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'AllowedF' AND Object_ID = Object_ID(N'EMPLOYMENT'))
BEGIN
ALTER TABLE [dbo].EMPLOYMENT ADD [AllowedF] [bit] NULL

END
GO

Update EMPLOYMENT set AllowedF =1 where AllowedF is null
Go

 IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'Last_Opr' AND Object_ID = Object_ID(N'EMPLOYMENT'))
BEGIN
ALTER TABLE [dbo].EMPLOYMENT ADD [Last_Opr] [varchar](50) NULL
END
GO

 IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'Last_Update' AND Object_ID = Object_ID(N'EMPLOYMENT'))
BEGIN
ALTER TABLE [dbo].EMPLOYMENT ADD [Last_Update] [smalldatetime] NULL
END
GO

IF  NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'EMPLOYMENT') AND type in (N'U'))
BEGIN
--- Update Table EMPLOYMENT
ALTER TABLE [dbo].[EMPLOYMENT] ADD 
    [Description] [varchar](255) NULL,
    [AllowedF] [bit] NULL,
    [Last_Opr] [varchar](50) NULL,
    [Last_Update] [smalldatetime] NULL

update EMPLOYMENT set AllowedF =1 where AllowedF is null

EXEC sys.sp_addextendedproperty 
    @name = N'MS_Description', 
    @value = N'Description for employment record', 
    @level0type = N'SCHEMA', @level0name = N'dbo', 
    @level1type = N'TABLE',  @level1name = N'EMPLOYMENT', 
    @level2type = N'COLUMN', @level2name = N'Description'


EXEC sys.sp_addextendedproperty 
    @name = N'MS_Description', 
    @value = N'Flag indicating whether this employment type is allowed/active (0=No, 1=Yes)', 
    @level0type = N'SCHEMA', @level0name = N'dbo', 
    @level1type = N'TABLE',  @level1name = N'EMPLOYMENT', 
    @level2type = N'COLUMN', @level2name = N'AllowedF'


EXEC sys.sp_addextendedproperty 
    @name = N'MS_Description', 
    @value = N'Last operator/user who updated this record', 
    @level0type = N'SCHEMA', @level0name = N'dbo', 
    @level1type = N'TABLE',  @level1name = N'EMPLOYMENT', 
    @level2type = N'COLUMN', @level2name = N'Last_Opr'


EXEC sys.sp_addextendedproperty 
    @name = N'MS_Description', 
    @value = N'Date and time of last update on this record', 
    @level0type = N'SCHEMA', @level0name = N'dbo', 
    @level1type = N'TABLE',  @level1name = N'EMPLOYMENT', 
    @level2type = N'COLUMN', @level2name = N'Last_Update'
end
go


IF  NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'OfficerPosition') AND type in (N'U'))
BEGIN
SET ANSI_NULLS ON

SET QUOTED_IDENTIFIER ON


CREATE TABLE [dbo].[OfficerPosition](
	[OfficerPosition] [varchar](10) NOT NULL,
	[Description] [varchar](255) NULL,
	[AllowedF] [bit] NULL,
	[Last_Opr] [varchar](50) NULL,
	[Last_Update] [smalldatetime] NULL,
 CONSTRAINT [I_OfficerPosition] PRIMARY KEY CLUSTERED 
(
	[OfficerPosition] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = OFF) ON [PRIMARY]
) ON [PRIMARY]


ALTER TABLE [dbo].[OfficerPosition] SET (LOCK_ESCALATION = DISABLE)


ALTER TABLE [dbo].[OfficerPosition] ADD  DEFAULT (0) FOR [AllowedF]


EXEC sys.sp_addextendedproperty 
    @name = N'MS_Description', 
    @value = N'Unique code for each officer position', 
    @level0type = N'SCHEMA', @level0name = N'dbo', 
    @level1type = N'TABLE',  @level1name = N'OfficerPosition', 
    @level2type = N'COLUMN', @level2name = N'OfficerPosition'


EXEC sys.sp_addextendedproperty 
    @name = N'MS_Description', 
    @value = N'Description of the officer position', 
    @level0type = N'SCHEMA', @level0name = N'dbo', 
    @level1type = N'TABLE',  @level1name = N'OfficerPosition', 
    @level2type = N'COLUMN', @level2name = N'Description'


EXEC sys.sp_addextendedproperty 
    @name = N'MS_Description', 
    @value = N'Flag indicating whether this position is allowed/active (0=No, 1=Yes)', 
    @level0type = N'SCHEMA', @level0name = N'dbo', 
    @level1type = N'TABLE',  @level1name = N'OfficerPosition', 
    @level2type = N'COLUMN', @level2name = N'AllowedF'


EXEC sys.sp_addextendedproperty 
    @name = N'MS_Description', 
    @value = N'Last operator/user who updated this record', 
    @level0type = N'SCHEMA', @level0name = N'dbo', 
    @level1type = N'TABLE',  @level1name = N'OfficerPosition', 
    @level2type = N'COLUMN', @level2name = N'Last_Opr'


EXEC sys.sp_addextendedproperty 
    @name = N'MS_Description', 
    @value = N'Date and time of last update on this record', 
    @level0type = N'SCHEMA', @level0name = N'dbo', 
    @level1type = N'TABLE',  @level1name = N'OfficerPosition', 
    @level2type = N'COLUMN', @level2name = N'Last_Update'
end
go



IF  NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'RatingAgency') AND type in (N'U'))
BEGIN
SET ANSI_NULLS ON


SET QUOTED_IDENTIFIER ON


CREATE TABLE [dbo].[RatingAgency](
	[RatingAgency] [varchar](10) NOT NULL,
	[Description] [varchar](255) NULL,
	[AllowedF] [bit] NULL,
	[Last_Opr] [varchar](50) NULL,
	[Last_Update] [smalldatetime] NULL,
 CONSTRAINT [I_RatingAgency] PRIMARY KEY CLUSTERED 
(
	[RatingAgency] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = OFF) ON [PRIMARY]
) ON [PRIMARY]


ALTER TABLE [dbo].[RatingAgency] SET (LOCK_ESCALATION = DISABLE)


ALTER TABLE [dbo].[RatingAgency] ADD  DEFAULT (0) FOR [AllowedF]


EXEC sys.sp_addextendedproperty 
    @name = N'MS_Description', 
    @value = N'Unique code for each rating agency', 
    @level0type = N'SCHEMA', @level0name = N'dbo', 
    @level1type = N'TABLE',  @level1name = N'RatingAgency', 
    @level2type = N'COLUMN', @level2name = N'RatingAgency'


EXEC sys.sp_addextendedproperty 
    @name = N'MS_Description', 
    @value = N'Name or description of the rating agency', 
    @level0type = N'SCHEMA', @level0name = N'dbo', 
    @level1type = N'TABLE',  @level1name = N'RatingAgency', 
    @level2type = N'COLUMN', @level2name = N'Description'


EXEC sys.sp_addextendedproperty 
    @name = N'MS_Description', 
    @value = N'Flag indicating whether this rating agency is allowed/active (0=No, 1=Yes)', 
    @level0type = N'SCHEMA', @level0name = N'dbo', 
    @level1type = N'TABLE',  @level1name = N'RatingAgency', 
    @level2type = N'COLUMN', @level2name = N'AllowedF'


EXEC sys.sp_addextendedproperty 
    @name = N'MS_Description', 
    @value = N'Last operator/user who updated this record', 
    @level0type = N'SCHEMA', @level0name = N'dbo', 
    @level1type = N'TABLE',  @level1name = N'RatingAgency', 
    @level2type = N'COLUMN', @level2name = N'Last_Opr'


EXEC sys.sp_addextendedproperty 
    @name = N'MS_Description', 
    @value = N'Date and time of last update on this record', 
    @level0type = N'SCHEMA', @level0name = N'dbo', 
    @level1type = N'TABLE',  @level1name = N'RatingAgency', 
    @level2type = N'COLUMN', @level2name = N'Last_Update'
end
go




  insert into PatchVersioning
select '1341 Update Script Profile May 2025',GETDATE()
go	
  

Declare @PrevScript varchar(100)
Declare @CurrScript varchar(100)

Select @PrevScript=''
Select @CurrSCript='1341 Update Script Profile May 2025'


Declare @ExecScript varchar(100)
Declare @ExecScriptStatus varchar(100)
Declare @Error varchar(200)

Select @Error=''

Begin 
       Select @ExecScript=Execscript,  @ExecScriptStatus=ExecScriptStatus from systab 
       if @PrevScript<>'' and @ExecSCript<>@PrevScript
              THROW 51000, 'Not the Next Sequence Script', 1;
       else 
              if @ExecScriptStatus<>'' and @ExecScriptStatus<>'DONE'
              THROW 51000, 'Pending Script Execution', 1;

       Update SysTab Set ExecScript=@CurrScript, ExecScriptStatus='PENDING'             
       
       BEGIN TRY            
			PRINT '--EXECUTE DONE--'
       END TRY  
       BEGIN CATCH  
       END CATCH;


       Update SysTab Set ExecScript=@CurrScript, ExecScriptStatus='DONE'         
End




go	


