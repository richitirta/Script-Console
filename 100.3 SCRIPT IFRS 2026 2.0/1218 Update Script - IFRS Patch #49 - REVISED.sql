IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'NDIC_Expected_1' AND Object_ID = Object_ID(N'IFRS_Assumption_Detail'))
BEGIN
ALTER TABLE IFRS_Assumption_Detail ADD NDIC_Expected_1 float(53) NULL
DECLARE @v sql_variant 
SET @v = N'Non Distinct Investment Component Ex. Profit Sharing'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'IFRS_Assumption_Detail', N'COLUMN', N'NDIC_Expected_1'
END
GO

IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'NDIC_Expected_2' AND Object_ID = Object_ID(N'IFRS_Assumption_Detail'))
BEGIN
ALTER TABLE IFRS_Assumption_Detail ADD NDIC_Expected_2 float(53) NULL
DECLARE @v sql_variant 
SET @v = N'Non Distinct Investment Component Ex. Profit Sharing'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'IFRS_Assumption_Detail', N'COLUMN', N'NDIC_Expected_2'
END
GO

IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'NDIC_Expected_3' AND Object_ID = Object_ID(N'IFRS_Assumption_Detail'))
BEGIN
ALTER TABLE IFRS_Assumption_Detail ADD NDIC_Expected_3 float(53) NULL
DECLARE @v sql_variant 
SET @v = N'Non Distinct Investment Component Ex. Profit Sharing'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'IFRS_Assumption_Detail', N'COLUMN', N'NDIC_Expected_3'
END
GO

IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'NDIC_Expected_4' AND Object_ID = Object_ID(N'IFRS_Assumption_Detail'))
BEGIN
ALTER TABLE IFRS_Assumption_Detail ADD NDIC_Expected_4 float(53) NULL
DECLARE @v sql_variant 
SET @v = N'Non Distinct Investment Component Ex. Profit Sharing'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'IFRS_Assumption_Detail', N'COLUMN', N'NDIC_Expected_4'
END
GO

IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'NDIC_Expected_5' AND Object_ID = Object_ID(N'IFRS_Assumption_Detail'))
BEGIN
ALTER TABLE IFRS_Assumption_Detail ADD NDIC_Expected_5 float(53) NULL
DECLARE @v sql_variant 
SET @v = N'Non Distinct Investment Component Ex. Profit Sharing'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'IFRS_Assumption_Detail', N'COLUMN', N'NDIC_Expected_5'
END
GO

IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'NDIC_Expected_1_R' AND Object_ID = Object_ID(N'IFRS_Assumption_Detail'))
BEGIN
ALTER TABLE IFRS_Assumption_Detail ADD NDIC_Expected_1_R float(53) NULL
END
GO

IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'NDIC_Expected_2_R' AND Object_ID = Object_ID(N'IFRS_Assumption_Detail'))
BEGIN
ALTER TABLE IFRS_Assumption_Detail ADD NDIC_Expected_2_R float(53) NULL
END
GO

IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'NDIC_Expected_3_R' AND Object_ID = Object_ID(N'IFRS_Assumption_Detail'))
BEGIN
ALTER TABLE IFRS_Assumption_Detail ADD NDIC_Expected_3_R float(53) NULL
END
GO

IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'NDIC_Expected_4_R' AND Object_ID = Object_ID(N'IFRS_Assumption_Detail'))
BEGIN
ALTER TABLE IFRS_Assumption_Detail ADD NDIC_Expected_4_R float(53) NULL
END
GO

IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'NDIC_Expected_5_R' AND Object_ID = Object_ID(N'IFRS_Assumption_Detail'))
BEGIN
ALTER TABLE IFRS_Assumption_Detail ADD NDIC_Expected_5_R float(53) NULL
END
GO


---------------------------------------------------------------------------------
--------------------------IFRS_Calculation_Detail_BEL----------------------------
---------------------------------------------------------------------------------

IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'BEL_NDIC_Expected_1' AND Object_ID = Object_ID(N'IFRS_Calculation_Detail_BEL'))
BEGIN
ALTER TABLE IFRS_Calculation_Detail_BEL ADD BEL_NDIC_Expected_1 float(53) NULL
END
GO

IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'BEL_NDIC_Expected_2' AND Object_ID = Object_ID(N'dbo.IFRS_Calculation_Detail_BEL'))
BEGIN
    ALTER TABLE dbo.IFRS_Calculation_Detail_BEL ADD BEL_NDIC_Expected_2 float(53) NULL
END
GO


IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'BEL_NDIC_Expected_3' AND Object_ID = Object_ID(N'dbo.IFRS_Calculation_Detail_BEL'))
BEGIN
    ALTER TABLE dbo.IFRS_Calculation_Detail_BEL ADD BEL_NDIC_Expected_3 float(53) NULL
END
GO


IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'BEL_NDIC_Expected_4' AND Object_ID = Object_ID(N'dbo.IFRS_Calculation_Detail_BEL'))
BEGIN
    ALTER TABLE dbo.IFRS_Calculation_Detail_BEL ADD BEL_NDIC_Expected_4 float(53) NULL
END
GO


IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'BEL_NDIC_Expected_5' AND Object_ID = Object_ID(N'dbo.IFRS_Calculation_Detail_BEL'))
BEGIN
    ALTER TABLE dbo.IFRS_Calculation_Detail_BEL ADD BEL_NDIC_Expected_5 float(53) NULL
END
GO


IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'BEL_NDIC_Expected_6' AND Object_ID = Object_ID(N'dbo.IFRS_Calculation_Detail_BEL'))
BEGIN
    ALTER TABLE dbo.IFRS_Calculation_Detail_BEL ADD BEL_NDIC_Expected_6 float(53) NULL
END
GO


IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'BEL_NDIC_Expected_7' AND Object_ID = Object_ID(N'dbo.IFRS_Calculation_Detail_BEL'))
BEGIN
    ALTER TABLE dbo.IFRS_Calculation_Detail_BEL ADD BEL_NDIC_Expected_7 float(53) NULL
END
GO


IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'BEL_NDIC_Expected_8' AND Object_ID = Object_ID(N'dbo.IFRS_Calculation_Detail_BEL'))
BEGIN
    ALTER TABLE dbo.IFRS_Calculation_Detail_BEL ADD BEL_NDIC_Expected_8 float(53) NULL
END
GO


IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'BEL_NDIC_Expected_9' AND Object_ID = Object_ID(N'dbo.IFRS_Calculation_Detail_BEL'))
BEGIN
    ALTER TABLE dbo.IFRS_Calculation_Detail_BEL ADD BEL_NDIC_Expected_9 float(53) NULL
END
GO


IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'BEL_NDIC_Expected_10' AND Object_ID = Object_ID(N'dbo.IFRS_Calculation_Detail_BEL'))
BEGIN
    ALTER TABLE dbo.IFRS_Calculation_Detail_BEL ADD BEL_NDIC_Expected_10 float(53) NULL
END
GO


IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'BEL_NDIC_Expected_11' AND Object_ID = Object_ID(N'dbo.IFRS_Calculation_Detail_BEL'))
BEGIN
    ALTER TABLE dbo.IFRS_Calculation_Detail_BEL ADD BEL_NDIC_Expected_11 float(53) NULL
END
GO


IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'BEL_NDIC_Expected_12' AND Object_ID = Object_ID(N'dbo.IFRS_Calculation_Detail_BEL'))
BEGIN
    ALTER TABLE dbo.IFRS_Calculation_Detail_BEL ADD BEL_NDIC_Expected_12 float(53) NULL
END
GO


IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'BEL_NDIC_Expected_13' AND Object_ID = Object_ID(N'dbo.IFRS_Calculation_Detail_BEL'))
BEGIN
    ALTER TABLE dbo.IFRS_Calculation_Detail_BEL ADD BEL_NDIC_Expected_13 float(53) NULL
END
GO


IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'BEL_NDIC_Expected_14' AND Object_ID = Object_ID(N'dbo.IFRS_Calculation_Detail_BEL'))
BEGIN
    ALTER TABLE dbo.IFRS_Calculation_Detail_BEL ADD BEL_NDIC_Expected_14 float(53) NULL
END
GO


IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'BEL_NDIC_Expected_15' AND Object_ID = Object_ID(N'dbo.IFRS_Calculation_Detail_BEL'))
BEGIN
    ALTER TABLE dbo.IFRS_Calculation_Detail_BEL ADD BEL_NDIC_Expected_15 float(53) NULL
END
GO


IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'BEL_NDIC_Expected_16' AND Object_ID = Object_ID(N'dbo.IFRS_Calculation_Detail_BEL'))
BEGIN
    ALTER TABLE dbo.IFRS_Calculation_Detail_BEL ADD BEL_NDIC_Expected_16 float(53) NULL
END
GO


IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'BEL_NDIC_Expected_17' AND Object_ID = Object_ID(N'dbo.IFRS_Calculation_Detail_BEL'))
BEGIN
    ALTER TABLE dbo.IFRS_Calculation_Detail_BEL ADD BEL_NDIC_Expected_17 float(53) NULL
END
GO


IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'BEL_NDIC_Expected_18' AND Object_ID = Object_ID(N'dbo.IFRS_Calculation_Detail_BEL'))
BEGIN
    ALTER TABLE dbo.IFRS_Calculation_Detail_BEL ADD BEL_NDIC_Expected_18 float(53) NULL
END
GO


IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'BEL_NDIC_Expected_19' AND Object_ID = Object_ID(N'dbo.IFRS_Calculation_Detail_BEL'))
BEGIN
    ALTER TABLE dbo.IFRS_Calculation_Detail_BEL ADD BEL_NDIC_Expected_19 float(53) NULL
END
GO


IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'BEL_NDIC_Expected_20' AND Object_ID = Object_ID(N'dbo.IFRS_Calculation_Detail_BEL'))
BEGIN
    ALTER TABLE dbo.IFRS_Calculation_Detail_BEL ADD BEL_NDIC_Expected_20 float(53) NULL
END
GO


IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'BEL_NDIC_Expected_21' AND Object_ID = Object_ID(N'dbo.IFRS_Calculation_Detail_BEL'))
BEGIN
    ALTER TABLE dbo.IFRS_Calculation_Detail_BEL ADD BEL_NDIC_Expected_21 float(53) NULL
END
GO


IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'BEL_NDIC_Expected_22' AND Object_ID = Object_ID(N'dbo.IFRS_Calculation_Detail_BEL'))
BEGIN
    ALTER TABLE dbo.IFRS_Calculation_Detail_BEL ADD BEL_NDIC_Expected_22 float(53) NULL
END
GO


IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'BEL_NDIC_Expected_23' AND Object_ID = Object_ID(N'dbo.IFRS_Calculation_Detail_BEL'))
BEGIN
    ALTER TABLE dbo.IFRS_Calculation_Detail_BEL ADD BEL_NDIC_Expected_23 float(53) NULL
END
GO


IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'BEL_NDIC_Expected_24' AND Object_ID = Object_ID(N'dbo.IFRS_Calculation_Detail_BEL'))
BEGIN
    ALTER TABLE dbo.IFRS_Calculation_Detail_BEL ADD BEL_NDIC_Expected_24 float(53) NULL
END
GO


IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'BEL_NDIC_Expected_25' AND Object_ID = Object_ID(N'dbo.IFRS_Calculation_Detail_BEL'))
BEGIN
    ALTER TABLE dbo.IFRS_Calculation_Detail_BEL ADD BEL_NDIC_Expected_25 float(53) NULL
END
GO


IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'BEL_NDIC_Expected_26' AND Object_ID = Object_ID(N'dbo.IFRS_Calculation_Detail_BEL'))
BEGIN
    ALTER TABLE dbo.IFRS_Calculation_Detail_BEL ADD BEL_NDIC_Expected_26 float(53) NULL
END
GO


IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'BEL_NDIC_Expected_27' AND Object_ID = Object_ID(N'dbo.IFRS_Calculation_Detail_BEL'))
BEGIN
    ALTER TABLE dbo.IFRS_Calculation_Detail_BEL ADD BEL_NDIC_Expected_27 float(53) NULL
END
GO


IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'BEL_NDIC_Expected_28' AND Object_ID = Object_ID(N'dbo.IFRS_Calculation_Detail_BEL'))
BEGIN
    ALTER TABLE dbo.IFRS_Calculation_Detail_BEL ADD BEL_NDIC_Expected_28 float(53) NULL
END
GO


IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'BEL_NDIC_Expected_29' AND Object_ID = Object_ID(N'dbo.IFRS_Calculation_Detail_BEL'))
BEGIN
    ALTER TABLE dbo.IFRS_Calculation_Detail_BEL ADD BEL_NDIC_Expected_29 float(53) NULL
END
GO


IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'BEL_NDIC_Expected_30' AND Object_ID = Object_ID(N'dbo.IFRS_Calculation_Detail_BEL'))
BEGIN
    ALTER TABLE dbo.IFRS_Calculation_Detail_BEL ADD BEL_NDIC_Expected_30 float(53) NULL
END
GO


IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'BEL_NDIC_Expected_PAD_1' AND Object_ID = Object_ID(N'dbo.IFRS_Calculation_Detail_BEL'))
BEGIN
    ALTER TABLE dbo.IFRS_Calculation_Detail_BEL ADD BEL_NDIC_Expected_PAD_1 float(53) NULL
END
GO


IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'BEL_NDIC_Expected_PAD_2' AND Object_ID = Object_ID(N'dbo.IFRS_Calculation_Detail_BEL'))
BEGIN
    ALTER TABLE dbo.IFRS_Calculation_Detail_BEL ADD BEL_NDIC_Expected_PAD_2 float(53) NULL
END
GO


IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'BEL_NDIC_Expected_PAD_3' AND Object_ID = Object_ID(N'dbo.IFRS_Calculation_Detail_BEL'))
BEGIN
    ALTER TABLE dbo.IFRS_Calculation_Detail_BEL ADD BEL_NDIC_Expected_PAD_3 float(53) NULL
END
GO


IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'BEL_NDIC_Expected_PAD_4' AND Object_ID = Object_ID(N'dbo.IFRS_Calculation_Detail_BEL'))
BEGIN
    ALTER TABLE dbo.IFRS_Calculation_Detail_BEL ADD BEL_NDIC_Expected_PAD_4 float(53) NULL
END
GO


IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'BEL_NDIC_Expected_PAD_5' AND Object_ID = Object_ID(N'dbo.IFRS_Calculation_Detail_BEL'))
BEGIN
    ALTER TABLE dbo.IFRS_Calculation_Detail_BEL ADD BEL_NDIC_Expected_PAD_5 float(53) NULL
END
GO


IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'BEL_NDIC_Expected_PAD_6' AND Object_ID = Object_ID(N'dbo.IFRS_Calculation_Detail_BEL'))
BEGIN
    ALTER TABLE dbo.IFRS_Calculation_Detail_BEL ADD BEL_NDIC_Expected_PAD_6 float(53) NULL
END
GO


IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'BEL_NDIC_Expected_PAD_7' AND Object_ID = Object_ID(N'dbo.IFRS_Calculation_Detail_BEL'))
BEGIN
    ALTER TABLE dbo.IFRS_Calculation_Detail_BEL ADD BEL_NDIC_Expected_PAD_7 float(53) NULL
END
GO


IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'BEL_NDIC_Expected_PAD_8' AND Object_ID = Object_ID(N'dbo.IFRS_Calculation_Detail_BEL'))
BEGIN
    ALTER TABLE dbo.IFRS_Calculation_Detail_BEL ADD BEL_NDIC_Expected_PAD_8 float(53) NULL
END
GO


IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'BEL_NDIC_Expected_PAD_9' AND Object_ID = Object_ID(N'dbo.IFRS_Calculation_Detail_BEL'))
BEGIN
    ALTER TABLE dbo.IFRS_Calculation_Detail_BEL ADD BEL_NDIC_Expected_PAD_9 float(53) NULL
END
GO


IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'BEL_NDIC_Expected_PAD_10' AND Object_ID = Object_ID(N'dbo.IFRS_Calculation_Detail_BEL'))
BEGIN
    ALTER TABLE dbo.IFRS_Calculation_Detail_BEL ADD BEL_NDIC_Expected_PAD_10 float(53) NULL
END
GO


IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'BEL_NDIC_Expected_PAD_11' AND Object_ID = Object_ID(N'dbo.IFRS_Calculation_Detail_BEL'))
BEGIN
    ALTER TABLE dbo.IFRS_Calculation_Detail_BEL ADD BEL_NDIC_Expected_PAD_11 float(53) NULL
END
GO


IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'BEL_NDIC_Expected_PAD_12' AND Object_ID = Object_ID(N'dbo.IFRS_Calculation_Detail_BEL'))
BEGIN
    ALTER TABLE dbo.IFRS_Calculation_Detail_BEL ADD BEL_NDIC_Expected_PAD_12 float(53) NULL
END
GO


IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'BEL_NDIC_Expected_PAD_13' AND Object_ID = Object_ID(N'dbo.IFRS_Calculation_Detail_BEL'))
BEGIN
    ALTER TABLE dbo.IFRS_Calculation_Detail_BEL ADD BEL_NDIC_Expected_PAD_13 float(53) NULL
END
GO


IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'BEL_NDIC_Expected_PAD_14' AND Object_ID = Object_ID(N'dbo.IFRS_Calculation_Detail_BEL'))
BEGIN
    ALTER TABLE dbo.IFRS_Calculation_Detail_BEL ADD BEL_NDIC_Expected_PAD_14 float(53) NULL
END
GO


IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'BEL_NDIC_Expected_PAD_15' AND Object_ID = Object_ID(N'dbo.IFRS_Calculation_Detail_BEL'))
BEGIN
    ALTER TABLE dbo.IFRS_Calculation_Detail_BEL ADD BEL_NDIC_Expected_PAD_15 float(53) NULL
END
GO


IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'BEL_NDIC_Expected_PAD_16' AND Object_ID = Object_ID(N'dbo.IFRS_Calculation_Detail_BEL'))
BEGIN
    ALTER TABLE dbo.IFRS_Calculation_Detail_BEL ADD BEL_NDIC_Expected_PAD_16 float(53) NULL
END
GO


IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'BEL_NDIC_Expected_PAD_17' AND Object_ID = Object_ID(N'dbo.IFRS_Calculation_Detail_BEL'))
BEGIN
    ALTER TABLE dbo.IFRS_Calculation_Detail_BEL ADD BEL_NDIC_Expected_PAD_17 float(53) NULL
END
GO


IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'BEL_NDIC_Expected_PAD_18' AND Object_ID = Object_ID(N'dbo.IFRS_Calculation_Detail_BEL'))
BEGIN
    ALTER TABLE dbo.IFRS_Calculation_Detail_BEL ADD BEL_NDIC_Expected_PAD_18 float(53) NULL
END
GO


IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'BEL_NDIC_Expected_PAD_19' AND Object_ID = Object_ID(N'dbo.IFRS_Calculation_Detail_BEL'))
BEGIN
    ALTER TABLE dbo.IFRS_Calculation_Detail_BEL ADD BEL_NDIC_Expected_PAD_19 float(53) NULL
END
GO


IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'BEL_NDIC_Expected_PAD_20' AND Object_ID = Object_ID(N'dbo.IFRS_Calculation_Detail_BEL'))
BEGIN
    ALTER TABLE dbo.IFRS_Calculation_Detail_BEL ADD BEL_NDIC_Expected_PAD_20 float(53) NULL
END
GO


IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'BEL_NDIC_Expected_PAD_21' AND Object_ID = Object_ID(N'dbo.IFRS_Calculation_Detail_BEL'))
BEGIN
    ALTER TABLE dbo.IFRS_Calculation_Detail_BEL ADD BEL_NDIC_Expected_PAD_21 float(53) NULL
END
GO


IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'BEL_NDIC_Expected_PAD_22' AND Object_ID = Object_ID(N'dbo.IFRS_Calculation_Detail_BEL'))
BEGIN
    ALTER TABLE dbo.IFRS_Calculation_Detail_BEL ADD BEL_NDIC_Expected_PAD_22 float(53) NULL
END
GO


IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'BEL_NDIC_Expected_PAD_23' AND Object_ID = Object_ID(N'dbo.IFRS_Calculation_Detail_BEL'))
BEGIN
    ALTER TABLE dbo.IFRS_Calculation_Detail_BEL ADD BEL_NDIC_Expected_PAD_23 float(53) NULL
END
GO


IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'BEL_NDIC_Expected_PAD_24' AND Object_ID = Object_ID(N'dbo.IFRS_Calculation_Detail_BEL'))
BEGIN
    ALTER TABLE dbo.IFRS_Calculation_Detail_BEL ADD BEL_NDIC_Expected_PAD_24 float(53) NULL
END
GO


IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'BEL_NDIC_Expected_PAD_25' AND Object_ID = Object_ID(N'dbo.IFRS_Calculation_Detail_BEL'))
BEGIN
    ALTER TABLE dbo.IFRS_Calculation_Detail_BEL ADD BEL_NDIC_Expected_PAD_25 float(53) NULL
END
GO


IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'BEL_NDIC_Expected_PAD_26' AND Object_ID = Object_ID(N'dbo.IFRS_Calculation_Detail_BEL'))
BEGIN
    ALTER TABLE dbo.IFRS_Calculation_Detail_BEL ADD BEL_NDIC_Expected_PAD_26 float(53) NULL
END
GO


IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'BEL_NDIC_Expected_PAD_27' AND Object_ID = Object_ID(N'dbo.IFRS_Calculation_Detail_BEL'))
BEGIN
    ALTER TABLE dbo.IFRS_Calculation_Detail_BEL ADD BEL_NDIC_Expected_PAD_27 float(53) NULL
END
GO


IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'BEL_NDIC_Expected_PAD_28' AND Object_ID = Object_ID(N'dbo.IFRS_Calculation_Detail_BEL'))
BEGIN
    ALTER TABLE dbo.IFRS_Calculation_Detail_BEL ADD BEL_NDIC_Expected_PAD_28 float(53) NULL
END
GO


IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'BEL_NDIC_Expected_PAD_29' AND Object_ID = Object_ID(N'dbo.IFRS_Calculation_Detail_BEL'))
BEGIN
    ALTER TABLE dbo.IFRS_Calculation_Detail_BEL ADD BEL_NDIC_Expected_PAD_29 float(53) NULL
END
GO


IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'BEL_NDIC_Expected_PAD_30' AND Object_ID = Object_ID(N'dbo.IFRS_Calculation_Detail_BEL'))
BEGIN
    ALTER TABLE dbo.IFRS_Calculation_Detail_BEL ADD BEL_NDIC_Expected_PAD_30 float(53) NULL
END
GO

---------------------------------------------------------------------------------
----------------------------IFRS_Initial_Detail_BEL------------------------------
---------------------------------------------------------------------------------
IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'BEL_NDIC_Expected_1' AND Object_ID = Object_ID(N'dbo.IFRS_Initial_Detail_BEL'))
BEGIN
    ALTER TABLE dbo.IFRS_Initial_Detail_BEL ADD BEL_NDIC_Expected_1 float(53) NULL
END
GO


IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'BEL_NDIC_Expected_2' AND Object_ID = Object_ID(N'dbo.IFRS_Initial_Detail_BEL'))
BEGIN
    ALTER TABLE dbo.IFRS_Initial_Detail_BEL ADD BEL_NDIC_Expected_2 float(53) NULL
END
GO


IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'BEL_NDIC_Expected_3' AND Object_ID = Object_ID(N'dbo.IFRS_Initial_Detail_BEL'))
BEGIN
    ALTER TABLE dbo.IFRS_Initial_Detail_BEL ADD BEL_NDIC_Expected_3 float(53) NULL
END
GO


IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'BEL_NDIC_Expected_4' AND Object_ID = Object_ID(N'dbo.IFRS_Initial_Detail_BEL'))
BEGIN
    ALTER TABLE dbo.IFRS_Initial_Detail_BEL ADD BEL_NDIC_Expected_4 float(53) NULL
END
GO


IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'BEL_NDIC_Expected_5' AND Object_ID = Object_ID(N'dbo.IFRS_Initial_Detail_BEL'))
BEGIN
    ALTER TABLE dbo.IFRS_Initial_Detail_BEL ADD BEL_NDIC_Expected_5 float(53) NULL
END
GO


IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'BEL_NDIC_Expected_6' AND Object_ID = Object_ID(N'dbo.IFRS_Initial_Detail_BEL'))
BEGIN
    ALTER TABLE dbo.IFRS_Initial_Detail_BEL ADD BEL_NDIC_Expected_6 float(53) NULL
END
GO


IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'BEL_NDIC_Expected_7' AND Object_ID = Object_ID(N'dbo.IFRS_Initial_Detail_BEL'))
BEGIN
    ALTER TABLE dbo.IFRS_Initial_Detail_BEL ADD BEL_NDIC_Expected_7 float(53) NULL
END
GO


IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'BEL_NDIC_Expected_8' AND Object_ID = Object_ID(N'dbo.IFRS_Initial_Detail_BEL'))
BEGIN
    ALTER TABLE dbo.IFRS_Initial_Detail_BEL ADD BEL_NDIC_Expected_8 float(53) NULL
END
GO


IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'BEL_NDIC_Expected_9' AND Object_ID = Object_ID(N'dbo.IFRS_Initial_Detail_BEL'))
BEGIN
    ALTER TABLE dbo.IFRS_Initial_Detail_BEL ADD BEL_NDIC_Expected_9 float(53) NULL
END
GO


IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'BEL_NDIC_Expected_10' AND Object_ID = Object_ID(N'dbo.IFRS_Initial_Detail_BEL'))
BEGIN
    ALTER TABLE dbo.IFRS_Initial_Detail_BEL ADD BEL_NDIC_Expected_10 float(53) NULL
END
GO


IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'BEL_NDIC_Expected_11' AND Object_ID = Object_ID(N'dbo.IFRS_Initial_Detail_BEL'))
BEGIN
    ALTER TABLE dbo.IFRS_Initial_Detail_BEL ADD BEL_NDIC_Expected_11 float(53) NULL
END
GO


IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'BEL_NDIC_Expected_12' AND Object_ID = Object_ID(N'dbo.IFRS_Initial_Detail_BEL'))
BEGIN
    ALTER TABLE dbo.IFRS_Initial_Detail_BEL ADD BEL_NDIC_Expected_12 float(53) NULL
END
GO


IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'BEL_NDIC_Expected_13' AND Object_ID = Object_ID(N'dbo.IFRS_Initial_Detail_BEL'))
BEGIN
    ALTER TABLE dbo.IFRS_Initial_Detail_BEL ADD BEL_NDIC_Expected_13 float(53) NULL
END
GO


IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'BEL_NDIC_Expected_14' AND Object_ID = Object_ID(N'dbo.IFRS_Initial_Detail_BEL'))
BEGIN
    ALTER TABLE dbo.IFRS_Initial_Detail_BEL ADD BEL_NDIC_Expected_14 float(53) NULL
END
GO


IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'BEL_NDIC_Expected_15' AND Object_ID = Object_ID(N'dbo.IFRS_Initial_Detail_BEL'))
BEGIN
    ALTER TABLE dbo.IFRS_Initial_Detail_BEL ADD BEL_NDIC_Expected_15 float(53) NULL
END
GO


IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'BEL_NDIC_Expected_16' AND Object_ID = Object_ID(N'dbo.IFRS_Initial_Detail_BEL'))
BEGIN
    ALTER TABLE dbo.IFRS_Initial_Detail_BEL ADD BEL_NDIC_Expected_16 float(53) NULL
END
GO


IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'BEL_NDIC_Expected_17' AND Object_ID = Object_ID(N'dbo.IFRS_Initial_Detail_BEL'))
BEGIN
    ALTER TABLE dbo.IFRS_Initial_Detail_BEL ADD BEL_NDIC_Expected_17 float(53) NULL
END
GO


IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'BEL_NDIC_Expected_18' AND Object_ID = Object_ID(N'dbo.IFRS_Initial_Detail_BEL'))
BEGIN
    ALTER TABLE dbo.IFRS_Initial_Detail_BEL ADD BEL_NDIC_Expected_18 float(53) NULL
END
GO


IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'BEL_NDIC_Expected_19' AND Object_ID = Object_ID(N'dbo.IFRS_Initial_Detail_BEL'))
BEGIN
    ALTER TABLE dbo.IFRS_Initial_Detail_BEL ADD BEL_NDIC_Expected_19 float(53) NULL
END
GO


IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'BEL_NDIC_Expected_20' AND Object_ID = Object_ID(N'dbo.IFRS_Initial_Detail_BEL'))
BEGIN
    ALTER TABLE dbo.IFRS_Initial_Detail_BEL ADD BEL_NDIC_Expected_20 float(53) NULL
END
GO


IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'BEL_NDIC_Expected_21' AND Object_ID = Object_ID(N'dbo.IFRS_Initial_Detail_BEL'))
BEGIN
    ALTER TABLE dbo.IFRS_Initial_Detail_BEL ADD BEL_NDIC_Expected_21 float(53) NULL
END
GO


IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'BEL_NDIC_Expected_22' AND Object_ID = Object_ID(N'dbo.IFRS_Initial_Detail_BEL'))
BEGIN
    ALTER TABLE dbo.IFRS_Initial_Detail_BEL ADD BEL_NDIC_Expected_22 float(53) NULL
END
GO


IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'BEL_NDIC_Expected_23' AND Object_ID = Object_ID(N'dbo.IFRS_Initial_Detail_BEL'))
BEGIN
    ALTER TABLE dbo.IFRS_Initial_Detail_BEL ADD BEL_NDIC_Expected_23 float(53) NULL
END
GO


IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'BEL_NDIC_Expected_24' AND Object_ID = Object_ID(N'dbo.IFRS_Initial_Detail_BEL'))
BEGIN
    ALTER TABLE dbo.IFRS_Initial_Detail_BEL ADD BEL_NDIC_Expected_24 float(53) NULL
END
GO


IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'BEL_NDIC_Expected_25' AND Object_ID = Object_ID(N'dbo.IFRS_Initial_Detail_BEL'))
BEGIN
    ALTER TABLE dbo.IFRS_Initial_Detail_BEL ADD BEL_NDIC_Expected_25 float(53) NULL
END
GO


IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'BEL_NDIC_Expected_26' AND Object_ID = Object_ID(N'dbo.IFRS_Initial_Detail_BEL'))
BEGIN
    ALTER TABLE dbo.IFRS_Initial_Detail_BEL ADD BEL_NDIC_Expected_26 float(53) NULL
END
GO


IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'BEL_NDIC_Expected_27' AND Object_ID = Object_ID(N'dbo.IFRS_Initial_Detail_BEL'))
BEGIN
    ALTER TABLE dbo.IFRS_Initial_Detail_BEL ADD BEL_NDIC_Expected_27 float(53) NULL
END
GO


IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'BEL_NDIC_Expected_28' AND Object_ID = Object_ID(N'dbo.IFRS_Initial_Detail_BEL'))
BEGIN
    ALTER TABLE dbo.IFRS_Initial_Detail_BEL ADD BEL_NDIC_Expected_28 float(53) NULL
END
GO


IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'BEL_NDIC_Expected_29' AND Object_ID = Object_ID(N'dbo.IFRS_Initial_Detail_BEL'))
BEGIN
    ALTER TABLE dbo.IFRS_Initial_Detail_BEL ADD BEL_NDIC_Expected_29 float(53) NULL
END
GO


IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'BEL_NDIC_Expected_30' AND Object_ID = Object_ID(N'dbo.IFRS_Initial_Detail_BEL'))
BEGIN
    ALTER TABLE dbo.IFRS_Initial_Detail_BEL ADD BEL_NDIC_Expected_30 float(53) NULL
END
GO


IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'BEL_NDIC_Expected_PAD_1' AND Object_ID = Object_ID(N'dbo.IFRS_Initial_Detail_BEL'))
BEGIN
    ALTER TABLE dbo.IFRS_Initial_Detail_BEL ADD BEL_NDIC_Expected_PAD_1 float(53) NULL
END
GO


IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'BEL_NDIC_Expected_PAD_2' AND Object_ID = Object_ID(N'dbo.IFRS_Initial_Detail_BEL'))
BEGIN
    ALTER TABLE dbo.IFRS_Initial_Detail_BEL ADD BEL_NDIC_Expected_PAD_2 float(53) NULL
END
GO


IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'BEL_NDIC_Expected_PAD_3' AND Object_ID = Object_ID(N'dbo.IFRS_Initial_Detail_BEL'))
BEGIN
    ALTER TABLE dbo.IFRS_Initial_Detail_BEL ADD BEL_NDIC_Expected_PAD_3 float(53) NULL
END
GO


IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'BEL_NDIC_Expected_PAD_4' AND Object_ID = Object_ID(N'dbo.IFRS_Initial_Detail_BEL'))
BEGIN
    ALTER TABLE dbo.IFRS_Initial_Detail_BEL ADD BEL_NDIC_Expected_PAD_4 float(53) NULL
END
GO


IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'BEL_NDIC_Expected_PAD_5' AND Object_ID = Object_ID(N'dbo.IFRS_Initial_Detail_BEL'))
BEGIN
    ALTER TABLE dbo.IFRS_Initial_Detail_BEL ADD BEL_NDIC_Expected_PAD_5 float(53) NULL
END
GO


IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'BEL_NDIC_Expected_PAD_6' AND Object_ID = Object_ID(N'dbo.IFRS_Initial_Detail_BEL'))
BEGIN
    ALTER TABLE dbo.IFRS_Initial_Detail_BEL ADD BEL_NDIC_Expected_PAD_6 float(53) NULL
END
GO


IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'BEL_NDIC_Expected_PAD_7' AND Object_ID = Object_ID(N'dbo.IFRS_Initial_Detail_BEL'))
BEGIN
    ALTER TABLE dbo.IFRS_Initial_Detail_BEL ADD BEL_NDIC_Expected_PAD_7 float(53) NULL
END
GO


IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'BEL_NDIC_Expected_PAD_8' AND Object_ID = Object_ID(N'dbo.IFRS_Initial_Detail_BEL'))
BEGIN
    ALTER TABLE dbo.IFRS_Initial_Detail_BEL ADD BEL_NDIC_Expected_PAD_8 float(53) NULL
END
GO


IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'BEL_NDIC_Expected_PAD_9' AND Object_ID = Object_ID(N'dbo.IFRS_Initial_Detail_BEL'))
BEGIN
    ALTER TABLE dbo.IFRS_Initial_Detail_BEL ADD BEL_NDIC_Expected_PAD_9 float(53) NULL
END
GO


IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'BEL_NDIC_Expected_PAD_10' AND Object_ID = Object_ID(N'dbo.IFRS_Initial_Detail_BEL'))
BEGIN
    ALTER TABLE dbo.IFRS_Initial_Detail_BEL ADD BEL_NDIC_Expected_PAD_10 float(53) NULL
END
GO


IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'BEL_NDIC_Expected_PAD_11' AND Object_ID = Object_ID(N'dbo.IFRS_Initial_Detail_BEL'))
BEGIN
    ALTER TABLE dbo.IFRS_Initial_Detail_BEL ADD BEL_NDIC_Expected_PAD_11 float(53) NULL
END
GO


IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'BEL_NDIC_Expected_PAD_12' AND Object_ID = Object_ID(N'dbo.IFRS_Initial_Detail_BEL'))
BEGIN
    ALTER TABLE dbo.IFRS_Initial_Detail_BEL ADD BEL_NDIC_Expected_PAD_12 float(53) NULL
END
GO


IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'BEL_NDIC_Expected_PAD_13' AND Object_ID = Object_ID(N'dbo.IFRS_Initial_Detail_BEL'))
BEGIN
    ALTER TABLE dbo.IFRS_Initial_Detail_BEL ADD BEL_NDIC_Expected_PAD_13 float(53) NULL
END
GO


IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'BEL_NDIC_Expected_PAD_14' AND Object_ID = Object_ID(N'dbo.IFRS_Initial_Detail_BEL'))
BEGIN
    ALTER TABLE dbo.IFRS_Initial_Detail_BEL ADD BEL_NDIC_Expected_PAD_14 float(53) NULL
END
GO


IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'BEL_NDIC_Expected_PAD_15' AND Object_ID = Object_ID(N'dbo.IFRS_Initial_Detail_BEL'))
BEGIN
    ALTER TABLE dbo.IFRS_Initial_Detail_BEL ADD BEL_NDIC_Expected_PAD_15 float(53) NULL
END
GO


IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'BEL_NDIC_Expected_PAD_16' AND Object_ID = Object_ID(N'dbo.IFRS_Initial_Detail_BEL'))
BEGIN
    ALTER TABLE dbo.IFRS_Initial_Detail_BEL ADD BEL_NDIC_Expected_PAD_16 float(53) NULL
END
GO


IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'BEL_NDIC_Expected_PAD_17' AND Object_ID = Object_ID(N'dbo.IFRS_Initial_Detail_BEL'))
BEGIN
    ALTER TABLE dbo.IFRS_Initial_Detail_BEL ADD BEL_NDIC_Expected_PAD_17 float(53) NULL
END
GO


IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'BEL_NDIC_Expected_PAD_18' AND Object_ID = Object_ID(N'dbo.IFRS_Initial_Detail_BEL'))
BEGIN
    ALTER TABLE dbo.IFRS_Initial_Detail_BEL ADD BEL_NDIC_Expected_PAD_18 float(53) NULL
END
GO


IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'BEL_NDIC_Expected_PAD_19' AND Object_ID = Object_ID(N'dbo.IFRS_Initial_Detail_BEL'))
BEGIN
    ALTER TABLE dbo.IFRS_Initial_Detail_BEL ADD BEL_NDIC_Expected_PAD_19 float(53) NULL
END
GO


IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'BEL_NDIC_Expected_PAD_20' AND Object_ID = Object_ID(N'dbo.IFRS_Initial_Detail_BEL'))
BEGIN
    ALTER TABLE dbo.IFRS_Initial_Detail_BEL ADD BEL_NDIC_Expected_PAD_20 float(53) NULL
END
GO


IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'BEL_NDIC_Expected_PAD_21' AND Object_ID = Object_ID(N'dbo.IFRS_Initial_Detail_BEL'))
BEGIN
    ALTER TABLE dbo.IFRS_Initial_Detail_BEL ADD BEL_NDIC_Expected_PAD_21 float(53) NULL
END
GO


IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'BEL_NDIC_Expected_PAD_22' AND Object_ID = Object_ID(N'dbo.IFRS_Initial_Detail_BEL'))
BEGIN
    ALTER TABLE dbo.IFRS_Initial_Detail_BEL ADD BEL_NDIC_Expected_PAD_22 float(53) NULL
END
GO


IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'BEL_NDIC_Expected_PAD_23' AND Object_ID = Object_ID(N'dbo.IFRS_Initial_Detail_BEL'))
BEGIN
    ALTER TABLE dbo.IFRS_Initial_Detail_BEL ADD BEL_NDIC_Expected_PAD_23 float(53) NULL
END
GO


IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'BEL_NDIC_Expected_PAD_24' AND Object_ID = Object_ID(N'dbo.IFRS_Initial_Detail_BEL'))
BEGIN
    ALTER TABLE dbo.IFRS_Initial_Detail_BEL ADD BEL_NDIC_Expected_PAD_24 float(53) NULL
END
GO


IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'BEL_NDIC_Expected_PAD_25' AND Object_ID = Object_ID(N'dbo.IFRS_Initial_Detail_BEL'))
BEGIN
    ALTER TABLE dbo.IFRS_Initial_Detail_BEL ADD BEL_NDIC_Expected_PAD_25 float(53) NULL
END
GO


IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'BEL_NDIC_Expected_PAD_26' AND Object_ID = Object_ID(N'dbo.IFRS_Initial_Detail_BEL'))
BEGIN
    ALTER TABLE dbo.IFRS_Initial_Detail_BEL ADD BEL_NDIC_Expected_PAD_26 float(53) NULL
END
GO


IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'BEL_NDIC_Expected_PAD_27' AND Object_ID = Object_ID(N'dbo.IFRS_Initial_Detail_BEL'))
BEGIN
    ALTER TABLE dbo.IFRS_Initial_Detail_BEL ADD BEL_NDIC_Expected_PAD_27 float(53) NULL
END
GO


IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'BEL_NDIC_Expected_PAD_28' AND Object_ID = Object_ID(N'dbo.IFRS_Initial_Detail_BEL'))
BEGIN
    ALTER TABLE dbo.IFRS_Initial_Detail_BEL ADD BEL_NDIC_Expected_PAD_28 float(53) NULL
END
GO


IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'BEL_NDIC_Expected_PAD_29' AND Object_ID = Object_ID(N'dbo.IFRS_Initial_Detail_BEL'))
BEGIN
    ALTER TABLE dbo.IFRS_Initial_Detail_BEL ADD BEL_NDIC_Expected_PAD_29 float(53) NULL
END
GO


IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'BEL_NDIC_Expected_PAD_30' AND Object_ID = Object_ID(N'dbo.IFRS_Initial_Detail_BEL'))
BEGIN
    ALTER TABLE dbo.IFRS_Initial_Detail_BEL ADD BEL_NDIC_Expected_PAD_30 float(53) NULL
END
GO



---------------------------------------------------------------------------------
----------------------------------IFRS_Movement----------------------------------
---------------------------------------------------------------------------------

IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'BEL_NDIC_Expected' AND Object_ID = Object_ID(N'dbo.IFRS_Movement'))
BEGIN
    ALTER TABLE dbo.IFRS_Movement ADD BEL_NDIC_Expected float(53) NULL
END
GO

IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'Loss_Portion_from_NDIC_Release' AND Object_ID = Object_ID(N'dbo.IFRS_Movement'))
BEGIN
    ALTER TABLE dbo.IFRS_Movement ADD Loss_Portion_from_NDIC_Release float(53) NULL
END
GO


---------------------------------------------------------------------------------
----------------------------------IFRS_Get_Assumption----------------------------------
---------------------------------------------------------------------------------


DROP Procedure IFRS_Get_Assumption
GO
Create Procedure IFRS_Get_Assumption(@PDate as smalldatetime, @NumMonths as Integer, @AssumptionID as varchar(10), @TSI as Float, @Segment as varchar(10), @ISType as varchar(10), @TOC as varchar(10), @CGroup as varchar(10), @Currency as varchar(10), @GroupType as varchar(10))                  
as                  

Declare @NumYears as Integer

Select @NumYears=Case When (@NumMonths % 12)<>0 then @NumMonths/12+1 else @NumMonths/12 end

if @AssumptionID=''
Begin
	Select 
	@PDate as Date,
	I1.PThresHold, 
	I1.MAXPERIODPAA,
	I1.SI_Lower,
	I1.SI_Upper,
	I1.CSM_Amortization_Method,
	I2.AssumptionID,
	I2.Method,
	I2.ApplyFAForPAAF,
	I2.ReinsuranceParamF,
	Case When @GroupType='R' and I2.ReinsuranceParamF=1 Then Claim_PAD_R Else Claim_PAD end as Claim_PAD,
	Case When @GroupType='R' and I2.ReinsuranceParamF=1 Then Expense_PAD_R Else Expense_PAD end as Expense_PAD,
	I2.Cost_PAD,

	Case When @GroupType='R' and I2.ReinsuranceParamF=1 Then Weight_1_R Else Weight_1 end as Weight_1,
	Case When @GroupType='R' and I2.ReinsuranceParamF=1 Then Claim_Expected_1_R Else Claim_Expected_1 end as Claim_Expected_1,
	Case When @GroupType='R' and I2.ReinsuranceParamF=1 Then Expense_Expected_1_R Else Expense_Expected_1 end as Expense_Expected_1,
	I2.Cost_Expected_1,
	I2.Others_Expected_1,
	Case When @GroupType='R' and I2.ReinsuranceParamF=1 Then NDIC_Expected_1_R Else NDIC_Expected_1 end as NDIC_Expected_1,
	I2.Cancel_Rate_1,

	Case When @GroupType='R' and I2.ReinsuranceParamF=1 Then Weight_2_R Else Weight_2 end as Weight_2,
	Case When @GroupType='R' and I2.ReinsuranceParamF=1 Then Claim_Expected_2_R Else Claim_Expected_2 end as Claim_Expected_2,
	Case When @GroupType='R' and I2.ReinsuranceParamF=1 Then Expense_Expected_2_R Else Expense_Expected_2 end as Expense_Expected_2,
	I2.Cost_Expected_2,
	I2.Others_Expected_2,
	Case When @GroupType='R' and I2.ReinsuranceParamF=1 Then NDIC_Expected_2_R Else NDIC_Expected_2 end as NDIC_Expected_2,
	I2.Cancel_Rate_2,

	Case When @GroupType='R' and I2.ReinsuranceParamF=1 Then Weight_3_R Else Weight_3 end as Weight_3,
	Case When @GroupType='R' and I2.ReinsuranceParamF=1 Then Claim_Expected_3_R Else Claim_Expected_3 end as Claim_Expected_3,
	Case When @GroupType='R' and I2.ReinsuranceParamF=1 Then Expense_Expected_3_R Else Expense_Expected_3 end as Expense_Expected_3,
	I2.Cost_Expected_3,
	I2.Others_Expected_3,
	Case When @GroupType='R' and I2.ReinsuranceParamF=1 Then NDIC_Expected_3_R Else NDIC_Expected_3 end as NDIC_Expected_3,
	I2.Cancel_Rate_3,

	Case When @GroupType='R' and I2.ReinsuranceParamF=1 Then Weight_4_R Else Weight_4 end as Weight_4,
	Case When @GroupType='R' and I2.ReinsuranceParamF=1 Then Claim_Expected_4_R Else Claim_Expected_4 end as Claim_Expected_4,
	Case When @GroupType='R' and I2.ReinsuranceParamF=1 Then Expense_Expected_4_R Else Expense_Expected_4 end as Expense_Expected_4,
	I2.Cost_Expected_4,
	I2.Others_Expected_4,
	Case When @GroupType='R' and I2.ReinsuranceParamF=1 Then NDIC_Expected_4_R Else NDIC_Expected_4 end as NDIC_Expected_4,
	I2.Cancel_Rate_4,

	Case When @GroupType='R' and I2.ReinsuranceParamF=1 Then Weight_5_R Else Weight_5 end as Weight_5,
	Case When @GroupType='R' and I2.ReinsuranceParamF=1 Then Claim_Expected_5_R Else Claim_Expected_5 end as Claim_Expected_5,
	Case When @GroupType='R' and I2.ReinsuranceParamF=1 Then Expense_Expected_5_R Else Expense_Expected_5 end as Expense_Expected_5,
	I2.Cost_Expected_5,
	I2.Others_Expected_5,
	Case When @GroupType='R' and I2.ReinsuranceParamF=1 Then NDIC_Expected_5_R Else NDIC_Expected_5 end as NDIC_Expected_5,
	I2.Cancel_Rate_5,

	Case When @GroupType='R' and I2.ReinsuranceParamF=1 Then TotalWeight_R Else TotalWeight end as TotalWeight,
	Case When @GroupType='R' and I2.ReinsuranceParamF=1 Then Claim_NPR_R Else Claim_NPR end as Claim_NPR,
	Case When @GroupType='R' and I2.ReinsuranceParamF=1 Then ClaimPaid_Ratio_1_R Else ClaimPaid_Ratio_1 end as ClaimPaid_Ratio_1,
	Case When @GroupType='R' and I2.ReinsuranceParamF=1 Then ClaimPaid_Ratio_2_R Else ClaimPaid_Ratio_2 end as ClaimPaid_Ratio_2,
	Case When @GroupType='R' and I2.ReinsuranceParamF=1 Then ClaimPaid_Ratio_3_R Else ClaimPaid_Ratio_3 end as ClaimPaid_Ratio_3,
	Case When @GroupType='R' and I2.ReinsuranceParamF=1 Then ClaimPaid_Ratio_4_R Else ClaimPaid_Ratio_4 end as ClaimPaid_Ratio_4,
	Case When @GroupType='R' and I2.ReinsuranceParamF=1 Then ClaimPaid_Ratio_5_R Else ClaimPaid_Ratio_5 end as ClaimPaid_Ratio_5,
	Case When @GroupType='R' and I2.ReinsuranceParamF=1 Then ClaimPaid_Ratio_6_R Else ClaimPaid_Ratio_6 end as ClaimPaid_Ratio_6,
	Case When @GroupType='R' and I2.ReinsuranceParamF=1 Then ClaimPaid_Ratio_7_R Else ClaimPaid_Ratio_7 end as ClaimPaid_Ratio_7,
	Case When @GroupType='R' and I2.ReinsuranceParamF=1 Then ClaimPaid_Ratio_8_R Else ClaimPaid_Ratio_8 end as ClaimPaid_Ratio_8,
	Case When @GroupType='R' and I2.ReinsuranceParamF=1 Then ClaimPaid_Ratio_9_R Else ClaimPaid_Ratio_9 end as ClaimPaid_Ratio_9,
	Case When @GroupType='R' and I2.ReinsuranceParamF=1 Then ClaimPaid_Ratio_10_R Else ClaimPaid_Ratio_10 end as ClaimPaid_Ratio_10,
	Case When I2.Inflation_Rate<>0 then I2.Inflation_Rate else coalesce(I10.InfRate,0) end as Inflation_Rate,
	I8.DiscRate, 
	I9.ERatio_1,
	I9.ERatio_2,
	I9.ERatio_3,
	I9.ERatio_4,
	I9.ERatio_5,
	I9.ERatio_6,
	I9.ERatio_7,
	I9.ERatio_8,
	I9.ERatio_9,
	I9.ERatio_10,
	I9.ERatio_11,
	I9.ERatio_12,
	I9.ERatio_13,
	I9.ERatio_14,
	I9.ERatio_15,
	I9.ERatio_16,
	I9.ERatio_17,
	I9.ERatio_18,
	I9.ERatio_19,
	I9.ERatio_20,
	I9.ERatio_21,
	I9.ERatio_22,
	I9.ERatio_23,
	I9.ERatio_24,
	I9.ERatio_25,
	I9.ERatio_26,
	I9.ERatio_27,
	I9.ERatio_28,
	I9.ERatio_29,
	I9.ERatio_30,
	I11.CancelRate_1,
	I11.CancelRate_2,
	I11.CancelRate_3,
	I11.CancelRate_4,
	I11.CancelRate_5,
	I11.CancelRate_6,
	I11.CancelRate_7,
	I11.CancelRate_8,
	I11.CancelRate_9,
	I11.CancelRate_10,
	I11.CancelRate_11,
	I11.CancelRate_12,
	I11.CancelRate_13,
	I11.CancelRate_14,
	I11.CancelRate_15,
	I11.CancelRate_16,
	I11.CancelRate_17,
	I11.CancelRate_18,
	I11.CancelRate_19,
	I11.CancelRate_20,
	I11.CancelRate_21,
	I11.CancelRate_22,
	I11.CancelRate_23,
	I11.CancelRate_24,
	I11.CancelRate_25,
	I11.CancelRate_26,
	I11.CancelRate_27,
	I11.CancelRate_28,
	I11.CancelRate_29,
	I11.CancelRate_30
	from IFRS_Assumption I1
	cross apply (Select Top 1 * from IFRS_Assumption_Detail I2 Where I2.AssumptionID=I1.AssumptionID and I2.VDate<=@PDate order by I2.VDate Desc) I2
	Left Join IFRS_Assumption_Segment I3 on (I3.AssumptionID=I1.AssumptionID and I3.Segment=@Segment)
	Left Join IFRS_Assumption_ISType I4 on (I4.AssumptionID=I1.AssumptionID and I4.ISType=@ISType)
	Left Join IFRS_Assumption_TOC I5 on (I5.AssumptionID=I1.AssumptionID and I5.TOC=@TOC)
	Left Join IFRS_Assumption_CGroup I6 on (I6.AssumptionID=I1.AssumptionID and I6.CGroup=@Cgroup)
	Left Join IFRS_Assumption_Currency I7 on (I7.AssumptionID=I1.AssumptionID and I7.Currency=@Currency)
	cross apply (
		Select Top 1 I2.DiscRate 
		from IFRS_DiscRate_Detail I2 
		Where I2.DiscRateID=I1.DiscRateID and I2.VDate<=@PDate and I2.Tenor=(@NumYears)
		order by I2.VDate Desc) I8
	Outer apply (
		Select Top 1 
		I2.ERatio_1,
		I2.ERatio_2,
		I2.ERatio_3,
		I2.ERatio_4,
		I2.ERatio_5,
		I2.ERatio_6,
		I2.ERatio_7,
		I2.ERatio_8,
		I2.ERatio_9,
		I2.ERatio_10,
		I2.ERatio_11,
		I2.ERatio_12,
		I2.ERatio_13,
		I2.ERatio_14,
		I2.ERatio_15,
		I2.ERatio_16,
		I2.ERatio_17,
		I2.ERatio_18,
		I2.ERatio_19,
		I2.ERatio_20,
		I2.ERatio_21,
		I2.ERatio_22,
		I2.ERatio_23,
		I2.ERatio_24,
		I2.ERatio_25,
		I2.ERatio_26,
		I2.ERatio_27,
		I2.ERatio_28,
		I2.ERatio_29,
		I2.ERatio_30
		from IFRS_ERatio_Detail I2
		Where I2.ERatioID=I1.ERatioID and I2.VDate<=@PDate and I2.Tenor=(@NumYears)
		order by I2.VDate Desc) I9
	Outer apply (
		Select Top 1 I2.InfRate 
		from IFRS_InfRate_Detail I2 
		Where I2.InfRateID=I1.InfRateID and I2.VDate<=@PDate 
		order by I2.VDate Desc) I10
	Outer apply (
		Select Top 1 
		I2.CancelRate_1,
		I2.CancelRate_2,
		I2.CancelRate_3,
		I2.CancelRate_4,
		I2.CancelRate_5,
		I2.CancelRate_6,
		I2.CancelRate_7,
		I2.CancelRate_8,
		I2.CancelRate_9,
		I2.CancelRate_10,
		I2.CancelRate_11,
		I2.CancelRate_12,
		I2.CancelRate_13,
		I2.CancelRate_14,
		I2.CancelRate_15,
		I2.CancelRate_16,
		I2.CancelRate_17,
		I2.CancelRate_18,
		I2.CancelRate_19,
		I2.CancelRate_20,
		I2.CancelRate_21,
		I2.CancelRate_22,
		I2.CancelRate_23,
		I2.CancelRate_24,
		I2.CancelRate_25,
		I2.CancelRate_26,
		I2.CancelRate_27,
		I2.CancelRate_28,
		I2.CancelRate_29,
		I2.CancelRate_30
		from IFRS_CancelRate_Detail I2
		Where I2.CancelRateID=I1.CancelRateID and I2.VDate<=@PDate and I2.Tenor=(@NumYears)
		order by I2.VDate Desc) I11
	Where 
	((I1.SI_Lower=0 or @TSI>=I1.SI_Lower)
	 and (I1.SI_Upper=0 or @TSI<=I1.SI_Upper)
	 and (I1.Period_Lower=0 or @NumMonths>=I1.Period_Lower)
	 and (I1.Period_Upper=0 or @NumMonths<=I1.Period_Upper)
	 and coalesce(I3.Segment,'')=@Segment 
	 and coalesce(I4.ISType,'')=@ISType
	 and coalesce(I5.TOC,'')=@TOC 
	 and coalesce(I6.CGroup,'')=@CGroup 
	 and coalesce(I7.Currency,'')=@Currency 
	 and I1.AllowedF=1
	 )
End
Else
Begin
	Select 
	@PDate as Date,
	I1.PThresHold, 
	I1.MAXPERIODPAA,
	I1.SI_Lower,
	I1.SI_Upper,
	I1.CSM_Amortization_Method,
	I2.AssumptionID,
	I2.Method,
	I2.ApplyFAForPAAF,
	I2.ReinsuranceParamF,
	Case When @GroupType='R' and I2.ReinsuranceParamF=1 Then Claim_PAD_R Else Claim_PAD end as Claim_PAD,
	Case When @GroupType='R' and I2.ReinsuranceParamF=1 Then Expense_PAD_R Else Expense_PAD end as Expense_PAD,
	I2.Cost_PAD,

	Case When @GroupType='R' and I2.ReinsuranceParamF=1 Then Weight_1_R Else Weight_1 end as Weight_1,
	Case When @GroupType='R' and I2.ReinsuranceParamF=1 Then Claim_Expected_1_R Else Claim_Expected_1 end as Claim_Expected_1,
	Case When @GroupType='R' and I2.ReinsuranceParamF=1 Then Expense_Expected_1_R Else Expense_Expected_1 end as Expense_Expected_1,
	I2.Cost_Expected_1,
	I2.Others_Expected_1,
	Case When @GroupType='R' and I2.ReinsuranceParamF=1 Then NDIC_Expected_1_R Else NDIC_Expected_1 end as NDIC_Expected_1,
	I2.Cancel_Rate_1,

	Case When @GroupType='R' and I2.ReinsuranceParamF=1 Then Weight_2_R Else Weight_2 end as Weight_2,
	Case When @GroupType='R' and I2.ReinsuranceParamF=1 Then Claim_Expected_2_R Else Claim_Expected_2 end as Claim_Expected_2,
	Case When @GroupType='R' and I2.ReinsuranceParamF=1 Then Expense_Expected_2_R Else Expense_Expected_2 end as Expense_Expected_2,
	I2.Cost_Expected_2,
	I2.Others_Expected_2,
	Case When @GroupType='R' and I2.ReinsuranceParamF=1 Then NDIC_Expected_2_R Else NDIC_Expected_2 end as NDIC_Expected_2,
	I2.Cancel_Rate_2,

	Case When @GroupType='R' and I2.ReinsuranceParamF=1 Then Weight_3_R Else Weight_3 end as Weight_3,
	Case When @GroupType='R' and I2.ReinsuranceParamF=1 Then Claim_Expected_3_R Else Claim_Expected_3 end as Claim_Expected_3,
	Case When @GroupType='R' and I2.ReinsuranceParamF=1 Then Expense_Expected_3_R Else Expense_Expected_3 end as Expense_Expected_3,
	I2.Cost_Expected_3,
	I2.Others_Expected_3,
	Case When @GroupType='R' and I2.ReinsuranceParamF=1 Then NDIC_Expected_3_R Else NDIC_Expected_3 end as NDIC_Expected_3,
	I2.Cancel_Rate_3,

	Case When @GroupType='R' and I2.ReinsuranceParamF=1 Then Weight_4_R Else Weight_4 end as Weight_4,
	Case When @GroupType='R' and I2.ReinsuranceParamF=1 Then Claim_Expected_4_R Else Claim_Expected_4 end as Claim_Expected_4,
	Case When @GroupType='R' and I2.ReinsuranceParamF=1 Then Expense_Expected_4_R Else Expense_Expected_4 end as Expense_Expected_4,
	I2.Cost_Expected_4,
	I2.Others_Expected_4,
	Case When @GroupType='R' and I2.ReinsuranceParamF=1 Then NDIC_Expected_4_R Else NDIC_Expected_4 end as NDIC_Expected_4,
	I2.Cancel_Rate_4,

	Case When @GroupType='R' and I2.ReinsuranceParamF=1 Then Weight_5_R Else Weight_5 end as Weight_5,
	Case When @GroupType='R' and I2.ReinsuranceParamF=1 Then Claim_Expected_5_R Else Claim_Expected_5 end as Claim_Expected_5,
	Case When @GroupType='R' and I2.ReinsuranceParamF=1 Then Expense_Expected_5_R Else Expense_Expected_5 end as Expense_Expected_5,
	I2.Cost_Expected_5,
	I2.Others_Expected_5,
	Case When @GroupType='R' and I2.ReinsuranceParamF=1 Then NDIC_Expected_5_R Else NDIC_Expected_5 end as NDIC_Expected_5,
	I2.Cancel_Rate_5,

	Case When @GroupType='R' and I2.ReinsuranceParamF=1 Then TotalWeight_R Else TotalWeight end as TotalWeight,
	Case When @GroupType='R' and I2.ReinsuranceParamF=1 Then Claim_NPR_R Else Claim_NPR end as Claim_NPR,
	Case When @GroupType='R' and I2.ReinsuranceParamF=1 Then ClaimPaid_Ratio_1_R Else ClaimPaid_Ratio_1 end as ClaimPaid_Ratio_1,
	Case When @GroupType='R' and I2.ReinsuranceParamF=1 Then ClaimPaid_Ratio_2_R Else ClaimPaid_Ratio_2 end as ClaimPaid_Ratio_2,
	Case When @GroupType='R' and I2.ReinsuranceParamF=1 Then ClaimPaid_Ratio_3_R Else ClaimPaid_Ratio_3 end as ClaimPaid_Ratio_3,
	Case When @GroupType='R' and I2.ReinsuranceParamF=1 Then ClaimPaid_Ratio_4_R Else ClaimPaid_Ratio_4 end as ClaimPaid_Ratio_4,
	Case When @GroupType='R' and I2.ReinsuranceParamF=1 Then ClaimPaid_Ratio_5_R Else ClaimPaid_Ratio_5 end as ClaimPaid_Ratio_5,
	Case When @GroupType='R' and I2.ReinsuranceParamF=1 Then ClaimPaid_Ratio_6_R Else ClaimPaid_Ratio_6 end as ClaimPaid_Ratio_6,
	Case When @GroupType='R' and I2.ReinsuranceParamF=1 Then ClaimPaid_Ratio_7_R Else ClaimPaid_Ratio_7 end as ClaimPaid_Ratio_7,
	Case When @GroupType='R' and I2.ReinsuranceParamF=1 Then ClaimPaid_Ratio_8_R Else ClaimPaid_Ratio_8 end as ClaimPaid_Ratio_8,
	Case When @GroupType='R' and I2.ReinsuranceParamF=1 Then ClaimPaid_Ratio_9_R Else ClaimPaid_Ratio_9 end as ClaimPaid_Ratio_9,
	Case When @GroupType='R' and I2.ReinsuranceParamF=1 Then ClaimPaid_Ratio_10_R Else ClaimPaid_Ratio_10 end as ClaimPaid_Ratio_10,
	Case When I2.Inflation_Rate<>0 then I2.Inflation_Rate else coalesce(I10.InfRate,0) end as Inflation_Rate,
	I8.DiscRate, 
	I9.ERatio_1,
	I9.ERatio_2,
	I9.ERatio_3,
	I9.ERatio_4,
	I9.ERatio_5,
	I9.ERatio_6,
	I9.ERatio_7,
	I9.ERatio_8,
	I9.ERatio_9,
	I9.ERatio_10,
	I9.ERatio_11,
	I9.ERatio_12,
	I9.ERatio_13,
	I9.ERatio_14,
	I9.ERatio_15,
	I9.ERatio_16,
	I9.ERatio_17,
	I9.ERatio_18,
	I9.ERatio_19,
	I9.ERatio_20,
	I9.ERatio_21,
	I9.ERatio_22,
	I9.ERatio_23,
	I9.ERatio_24,
	I9.ERatio_25,
	I9.ERatio_26,
	I9.ERatio_27,
	I9.ERatio_28,
	I9.ERatio_29,
	I9.ERatio_30,
	I11.CancelRate_1,
	I11.CancelRate_2,
	I11.CancelRate_3,
	I11.CancelRate_4,
	I11.CancelRate_5,
	I11.CancelRate_6,
	I11.CancelRate_7,
	I11.CancelRate_8,
	I11.CancelRate_9,
	I11.CancelRate_10,
	I11.CancelRate_11,
	I11.CancelRate_12,
	I11.CancelRate_13,
	I11.CancelRate_14,
	I11.CancelRate_15,
	I11.CancelRate_16,
	I11.CancelRate_17,
	I11.CancelRate_18,
	I11.CancelRate_19,
	I11.CancelRate_20,
	I11.CancelRate_21,
	I11.CancelRate_22,
	I11.CancelRate_23,
	I11.CancelRate_24,
	I11.CancelRate_25,
	I11.CancelRate_26,
	I11.CancelRate_27,
	I11.CancelRate_28,
	I11.CancelRate_29,
	I11.CancelRate_30
	from IFRS_Assumption I1
	cross apply (Select Top 1 * from IFRS_Assumption_Detail I2 Where I2.AssumptionID=I1.AssumptionID and I2.VDate<=@PDate order by I2.VDate Desc) I2
	cross apply (
		Select Top 1 I2.DiscRate 
		from IFRS_DiscRate_Detail I2 
		Where I2.DiscRateID=I1.DiscRateID and I2.VDate<=@PDate and I2.Tenor=(@NumYears)
		order by I2.VDate Desc) I8
	Outer apply (
		Select Top 1 
		I2.ERatio_1,
		I2.ERatio_2,
		I2.ERatio_3,
		I2.ERatio_4,
		I2.ERatio_5,
		I2.ERatio_6,
		I2.ERatio_7,
		I2.ERatio_8,
		I2.ERatio_9,
		I2.ERatio_10,
		I2.ERatio_11,
		I2.ERatio_12,
		I2.ERatio_13,
		I2.ERatio_14,
		I2.ERatio_15,
		I2.ERatio_16,
		I2.ERatio_17,
		I2.ERatio_18,
		I2.ERatio_19,
		I2.ERatio_20,
		I2.ERatio_21,
		I2.ERatio_22,
		I2.ERatio_23,
		I2.ERatio_24,
		I2.ERatio_25,
		I2.ERatio_26,
		I2.ERatio_27,
		I2.ERatio_28,
		I2.ERatio_29,
		I2.ERatio_30
		from IFRS_ERatio_Detail I2
		Where I2.ERatioID=I1.ERatioID and I2.VDate<=@PDate and I2.Tenor=(@NumYears)
		order by I2.VDate Desc) I9
	Outer apply (
		Select Top 1 I2.InfRate 
		from IFRS_InfRate_Detail I2 
		Where I2.InfRateID=I1.InfRateID and I2.VDate<=@PDate 
		order by I2.VDate Desc) I10
	Outer apply (
		Select Top 1 
		I2.CancelRate_1,
		I2.CancelRate_2,
		I2.CancelRate_3,
		I2.CancelRate_4,
		I2.CancelRate_5,
		I2.CancelRate_6,
		I2.CancelRate_7,
		I2.CancelRate_8,
		I2.CancelRate_9,
		I2.CancelRate_10,
		I2.CancelRate_11,
		I2.CancelRate_12,
		I2.CancelRate_13,
		I2.CancelRate_14,
		I2.CancelRate_15,
		I2.CancelRate_16,
		I2.CancelRate_17,
		I2.CancelRate_18,
		I2.CancelRate_19,
		I2.CancelRate_20,
		I2.CancelRate_21,
		I2.CancelRate_22,
		I2.CancelRate_23,
		I2.CancelRate_24,
		I2.CancelRate_25,
		I2.CancelRate_26,
		I2.CancelRate_27,
		I2.CancelRate_28,
		I2.CancelRate_29,
		I2.CancelRate_30
		from IFRS_CancelRate_Detail I2
		Where I2.CancelRateID=I1.CancelRateID and I2.VDate<=@PDate and I2.Tenor=(@NumYears)
		order by I2.VDate Desc) I11
	Where I1.AssumptionID=@AssumptionID
End

GO


---------------------------------------------------------------------------------
----------------------------------IFRS_SHOW_INITIAL----------------------------------
---------------------------------------------------------------------------------

DROP Procedure IFRS_SHOW_INITIAL  
GO  
Create Procedure IFRS_SHOW_INITIAL(@DataID as int, @GroupType as varchar(1), @YearN as Int, @MonthN as Int, @Cumulative as Bit)      
as      
      
Declare @IFRS table (      
 BEL_Beginning Float,      
 BEL_Premium_Expected Float,      
 BEL_Commission_Expected Float,      
 BEL_Interest_Accrete Float,      
 BEL_Claim_Expected Float,      
 BEL_Claim_NPR_Expected Float,      
 BEL_Expense_Expected Float,      
 BEL_Cost_Expected Float,      
 BEL_Others_Expected Float,      
 BEL_NDIC_Expected Float,      
 BEL_Refund_Expected Float,      
 BEL_Ending_Before_Change Float,      
 BEL_Ending_After_Change_NonDiscRate Float,      
 BEL_Ending_After_Change_DiscRate Float,      
 BEL_GainLoss_NonDiscRate Float,      
 BEL_GainLoss_DiscRate Float,      
 RA_Beginning Float,      
 RA_Interest_Accrete Float,      
 RA_Release Float,      
 RA_Ending_Before_Change Float,      
 RA_Ending_After_Change_NonDiscRate Float,      
 RA_Ending_After_Change_DiscRate Float,      
 RA_GainLoss_NonDiscRate Float,      
 RA_GainLoss_DiscRate Float,      
 CSM_Start Float,      
 CSM_Interest_Accrete Float,      
 CSM_Amortization Float,      
 CSM_GainLoss_NonDiscRate Float,      
 CSM_Adjustment Float,      
 CSM_End Float,      
 PAA_Start Float,      
 PAA_Interest_Accrete Float,      
 PAA_Amortization Float,       
 PAA_End Float,      
 Loss_Start Float,      
 Loss_Portion_from_Claim_Release Float,      
 Loss_Portion_from_Expense_Release Float,      
 Loss_Portion_from_Cost_Release Float,      
 Loss_Portion_from_Others_Release Float,      
 Loss_Portion_from_NDIC_Release Float,      
 Loss_Portion_from_Refund_Release Float,      
 Loss_Portion_from_RA_Release Float,      
 Loss_Portion_from_Interest_Accrete Float,      
 Loss_Portion_from_GainLoss_DiscRate Float,      
 Loss_GainLoss_NonDiscRate Float,      
 Loss_Adjustment Float,      
 Loss_End Float,      
 ACQ_Amortization Float,      
 ACQ_Cost Float      
)      
      
      
Declare @IFRS_Detail Table(GroupID int, GroupType varchar(1), EffMonth Int, EffYear Int, Month Int, Year Int, Method varchar(1), Bel_Beginning Float, Total_Bel_Beginning Float, Premium_Expected Float, Total_Premium_Expected Float, Commission_Expected Float, Total_Commission_Expected Float, Net_Premium_Expected Float, Total_Net_Premium_Expected Float, Commission_Actual Float, Total_Commission_Actual Float, Bel_Beginning_Portion Float, Premium_Expected_Portion Float, Commission_Expected_Portion Float, Net_Premium_Expected_Portion Float, Commission_Actual_Portion Float)      
      
insert into @IFRS_Detail      
Select       
I2.GroupID, I2.GroupType, I2.EffMonth, I2.EffYear,       
max(I.Month) as Month,       
max(I.Year) as Year,      
Max(I1.Method) as Method,      
Sum(I3b.BEL_Beginning) as BEL_Beginning,      
Max(I2b.BEL_Beginning) as Total_BEL_Beginning,      
Sum(I3.Premium_Expected) as Premium_Expected,      
Max(I2.Premium_Expected) as Total_Premium_Expected,      
Sum(I3.Commission_Expected) as Commission_Expected,      
Max(I2.Commission_Expected) as Total_Commission_Expected,      
Sum(I3.Premium_Expected+I3.Commission_Expected) as Net_Premium_Expected,      
Max(I2.Premium_Expected+I2.Commission_Expected) as Total_Net_Premium_Expected,      
Sum(I3.Commission_Actual_BC) as Commission_Actual,      
Max(I2.Commission_Actual_BC) as Total_Commission_Actual,      
Cast(0 as Float) as Bel_Beginning_Portion,       
cast(0 as Float) as Premium_Expected_Portion,       
cast(0 as Float) as Commission_Expected_Portion,       
cast(0 as Float) as Net_Premium_Expected_Portion,       
cast(0 as Float) as Commission_Actual_Portion      
from IFRS_Initial I      
Inner Join IFRS_Calculation I1 on (I1.GroupID=I.GroupID)      
Inner Join IFRS_Calculation_Detail I2 on (I2.GroupID=I1.GroupID and I2.GroupType=@GroupType and I2.EffYear=I.EffYear and I2.EffMonth=I.EffMonth)      
Inner Join IFRS_Calculation_Detail_Bel I2b on (I2b.GroupID=I2.GroupID and I2b.GroupType=I2.GroupType and I2b.EffYear=I2.EffYear and I2b.EffMonth=I2.EffMonth)      
Inner Join IFRS_initial_Detail I3 on (I3.DataID=I.DataID and I3.GroupType=@GroupType)      
Inner Join IFRS_initial_Detail_Bel I3b on (I3b.DataID=I.DataID and I3b.GroupType=I3.GroupType)      
Where I.DataID=@DataID       
Group By I2.GroupID, I2.GroupType, I2.EffMonth, I2.EffYear      
  
Select * from ifrs_initial_detail_bel      
Declare @Method as varchar(1)      
Declare @ProcessDate as Date      
Declare @PProcessDate as Date      
      
Update I       
Set       
Bel_Beginning_Portion=Case When I.Total_BeL_Beginning<>0 Then I.Bel_Beginning/I.Total_BeL_Beginning Else 1 end,      
Net_Premium_Expected_Portion=case When I.Total_Net_Premium_Expected<>0 then I.Net_Premium_Expected/I.Total_Net_Premium_Expected Else 1 end,      
Commission_Actual_Portion=Case When I.Total_Commission_Actual<>0 then I.Commission_Actual/I.Total_Commission_Actual Else 1 end      
from @IFRS_Detail I       
      
Select Top 1 @Method=I.Method, @ProcessDate=dateadd(day,-1,dateadd(month, ((@YearN-1)*12+@MonthN), cast(I.Month as varchar(2))+'/01/'+cast(I.year as varchar(4))))        
from @IFRS_Detail I       
      
Declare @BEL_Ending_After_Change_NonDiscRate as Float      
Declare @RA_Ending_After_Change_NonDiscRate as Float      
Declare @CSM_End as Float      
Declare @PAA_End as Float      
Declare @Loss_End as Float      
Declare @BEL_GainLoss_DiscRate as Float      
Declare @RA_GainLoss_DiscRate as Float      
Declare @ACQ_Cost as Float      
      
if @Cumulative=1       
Begin      
 Select @PProcessDate='01/01/1901'      
 Select @BEL_Ending_After_Change_NonDiscRate=0      
 Select @BEL_GainLoss_DiscRate=0      
 Select @RA_Ending_After_Change_NonDiscRate=0      
 Select @RA_GainLoss_DiscRate=0      
 Select @PAA_End=0      
 Select @CSM_End=0      
 Select @Loss_End=0      
 Select @ACQ_Cost=0      
End      
else      
Begin      
 Select @PProcessDate=dateadd(day,-1,cast(month(@ProcessDate) as varchar(2))+'/01/'+cast(year(@ProcessDate) as varchar(4)))      
      
 Select       
  @BEL_Ending_After_Change_NonDiscRate=sum((BEL_Initial+BEL_Premium_Expected+BEL_Commission_Expected+BEL_Interest_Accrete+BEL_Claim_Expected+BEL_Claim_NPR_Expected+BEL_Expense_Expected+BEL_Cost_Expected+BEL_Others_Expected+BEL_NDIC_Expected+BEL_Refund_Expected+BEL_GainLoss_NonDiscRate)*Id.Bel_Beginning_Portion),      
  @BEL_GainLoss_DiscRate=sum(BEL_GainLoss_DiscRate*Id.Bel_Beginning_Portion),      
  @RA_Ending_After_Change_NonDiscRate=sum((RA_Initial+RA_Interest_Accrete+RA_Release+RA_GainLoss_NonDiscRate)*Id.Bel_Beginning_Portion),      
  @RA_GainLoss_DiscRate=sum(RA_GainLoss_DiscRate*Id.Bel_Beginning_Portion),      
  @CSM_End=sum((CSM_Initial+CSM_Interest_Accrete+CSM_Amortization+CSM_GainLoss_NonDiscRate+CSM_Adjustment)*Id.Bel_Beginning_Portion),      
  @PAA_End=sum((PAA_Premium_Expected+PAA_Commission_Expected+PAA_Interest_Accrete+PAA_Amortization)*Id.Net_Premium_Expected_Portion),      
  @Loss_End=sum((Loss_Initial+Loss_Portion_from_Claim_Release+Loss_Portion_from_Expense_Release+Loss_Portion_from_Cost_Release+Loss_Portion_from_Others_Release+Loss_Portion_from_NDIC_Release+Loss_Portion_from_Refund_Release+Loss_Portion_from_RA_Release+Loss_Portion_from_Interest_Accrete+Loss_Portion_from_GainLoss_DiscRate+Loss_GainLoss_NonDiscRate+Loss_Adjustment)*Id.Bel_Beginning_Portion),      
  @ACQ_Cost=sum((ACQ_Cost+ACQ_Amortization)*Id.Commission_Actual_Portion)      
  from @IFRS_Detail Id      
  Inner Join IFRS_Movement I on (I.GroupID=Id.GroupID and I.GroupType=Id.GroupType and I.EffMonth=Id.EffMonth and I.EffYear=Id.EffYear)      
  Where I.ProcessDate<=@PProcessDate       
        
  if @BEL_Ending_After_Change_NonDiscRate is null      
  Select @BEL_Ending_After_Change_NonDiscRate=0      
  if @BEL_GainLoss_DiscRate is null      
  Select @BEL_GainLoss_DiscRate=0      
  if @RA_Ending_After_Change_NonDiscRate is null      
  Select @RA_Ending_After_Change_NonDiscRate=0      
  if @RA_GainLoss_DiscRate is null      
  Select @RA_GainLoss_DiscRate=0      
  if @CSM_End is null      
  Select @CSM_End=0      
  if @PAA_End is null      
  Select @PAA_End=0      
  if @Loss_End is null      
  Select @Loss_End=0      
  if @ACQ_Cost is null      
  Select @ACQ_Cost=0      
End      
      
insert into @IFRS      
Select       
 BEL_Beginning=@BEL_Ending_After_Change_NonDiscRate+sum(BEL_Initial*Id.Bel_Beginning_Portion),      
 BEL_Premium_Expected=sum(BEL_Premium_Expected*Id.Bel_Beginning_Portion),      
 BEL_Commission_Expected=sum(BEL_Commission_Expected*Id.Bel_Beginning_Portion),      
 BEL_Interest_Accrete=sum(BEL_Interest_Accrete*Id.Bel_Beginning_Portion),      
 BEL_Claim_Expected=sum(BEL_Claim_Expected*Id.Bel_Beginning_Portion),      
 BEL_Claim_NPR_Expected=sum(BEL_Claim_NPR_Expected*Id.Bel_Beginning_Portion),      
 BEL_Expense_Expected=sum(BEL_Expense_Expected*Id.Bel_Beginning_Portion),      
 BEL_Cost_Expected=sum(BEL_Cost_Expected*Id.Bel_Beginning_Portion),      
 BEL_Others_Expected=sum(BEL_Others_Expected*Id.Bel_Beginning_Portion),      
 BEL_NDIC_Expected=sum(BEL_NDIC_Expected*Id.Bel_Beginning_Portion),      
 BEL_Refund_Expected=sum(BEL_Refund_Expected*Id.Bel_Beginning_Portion),      
      
 BEL_Ending_Before_Change=@BEL_Ending_After_Change_NonDiscRate+sum((BEL_Initial+BEL_Premium_Expected+BEL_Commission_Expected+BEL_Interest_Accrete+BEL_Claim_Expected+BEL_Claim_NPR_Expected+BEL_Expense_Expected+BEL_Cost_Expected+BEL_Others_Expected+BEL_NDIC_Expected+BEL_Refund_Expected)*Id.Bel_Beginning_Portion),      
 BEL_Ending_After_Change_NonDiscRate=@BEL_Ending_After_Change_NonDiscRate+sum((BEL_Initial+BEL_Premium_Expected+BEL_Commission_Expected+BEL_Interest_Accrete+BEL_Claim_Expected+BEL_Claim_NPR_Expected+BEL_Expense_Expected+BEL_Cost_Expected+BEL_Others_Expected+BEL_NDIC_Expected+BEL_Refund_Expected+BEL_GainLoss_NonDiscRate)*Id.Bel_Beginning_Portion),      
 BEL_Ending_After_Change_DiscRate=@BEL_Ending_After_Change_NonDiscRate+@BEL_GainLoss_DiscRate+sum((BEL_Initial+BEL_Premium_Expected+BEL_Commission_Expected+BEL_Interest_Accrete+BEL_Claim_Expected+BEL_Claim_NPR_Expected+BEL_Expense_Expected+BEL_Cost_Expected+BEL_Others_Expected+BEL_NDIC_Expected+BEL_Refund_Expected+BEL_GainLoss_NonDiscRate+BEL_GainLoss_DiscRate)*Id.Bel_Beginning_Portion),      
      
 BEL_GainLoss_NonDiscRate=sum(BEL_GainLoss_NonDiscRate*Id.Bel_Beginning_Portion),      
 BEL_GainLoss_DiscRate=@BEL_GainLoss_DiscRate+sum(BEL_GainLoss_DiscRate*Id.Bel_Beginning_Portion),      
      
 RA_Beginning=@RA_Ending_After_Change_NonDiscRate+sum(RA_Initial*Id.Bel_Beginning_Portion),      
 RA_Interest_Accrete=sum(RA_Interest_Accrete*Id.Bel_Beginning_Portion),      
 RA_Release=sum(RA_Release*Id.Bel_Beginning_Portion),      
      
 RA_Ending_Before_Change=@RA_Ending_After_Change_NonDiscRate+sum((RA_Initial+RA_Interest_Accrete+RA_Release)*Id.Bel_Beginning_Portion),      
      
 RA_Ending_After_Change_NonDiscRate=@RA_Ending_After_Change_NonDiscRate+sum((RA_Initial+RA_Interest_Accrete+RA_Release+RA_GainLoss_NonDiscRate)*Id.Bel_Beginning_Portion),      
 RA_Ending_After_Change_DiscRate=@RA_Ending_After_Change_NonDiscRate+@RA_GainLoss_DiscRate+sum((RA_Initial+RA_Interest_Accrete+RA_Release+RA_GainLoss_NonDiscRate+RA_GainLoss_DiscRate)*Id.Bel_Beginning_Portion),      
      
 RA_GainLoss_NonDiscRate=sum(RA_GainLoss_NonDiscRate*Id.Bel_Beginning_Portion),      
 RA_GainLoss_DiscRate=@RA_GainLoss_DiscRate+sum(RA_GainLoss_DiscRate*Id.Bel_Beginning_Portion),      
      
 CSM_Start=@CSM_End+sum(CSM_Initial*Id.Bel_Beginning_Portion),      
 CSM_Interest_Accrete=sum(CSM_Interest_Accrete*Id.Bel_Beginning_Portion),      
 CSM_Amortization=sum(CSM_Amortization*Id.Bel_Beginning_Portion),      
 CSM_GainLoss_NonDiscRate=sum(CSM_GainLoss_NonDiscRate*Id.Bel_Beginning_Portion),      
 CSM_Adjustment=sum(CSM_Adjustment*Id.Bel_Beginning_Portion),      
 CSM_End=@CSM_End+sum((CSM_Initial+CSM_Interest_Accrete+CSM_Amortization+CSM_GainLoss_NonDiscRate+CSM_Adjustment)*Id.Bel_Beginning_Portion),      
      
 PAA_Start=@PAA_End+sum((PAA_Premium_Expected+PAA_Commission_Expected)*Id.Net_Premium_Expected_Portion),      
 PAA_Interest_Accrete=sum(PAA_Interest_Accrete*Id.Net_Premium_Expected_Portion),      
 PAA_Amortization=sum(PAA_Amortization*Id.Net_Premium_Expected_Portion),      
 PAA_End=@PAA_End+sum((PAA_Premium_Expected+PAA_Commission_Expected+PAA_Interest_Accrete+PAA_Amortization)*Id.Net_Premium_Expected_Portion),      
      
 Loss_Start=@Loss_End+sum(LOSS_Initial*Id.Bel_Beginning_Portion),      
 Loss_Portion_from_Claim_Release=sum(Loss_Portion_from_Claim_Release*Id.Bel_Beginning_Portion),      
 Loss_Portion_from_Expense_Release=sum(Loss_Portion_from_Expense_Release*Id.Bel_Beginning_Portion),      
 Loss_Portion_from_Cost_Release=sum(Loss_Portion_from_Cost_Release*Id.Bel_Beginning_Portion),      
 Loss_Portion_from_Others_Release=sum(Loss_Portion_from_Others_Release*Id.Bel_Beginning_Portion),      
 Loss_Portion_from_NDIC_Release=sum(Loss_Portion_from_NDIC_Release*Id.Bel_Beginning_Portion),      
 Loss_Portion_from_Refund_Release=sum(Loss_Portion_from_Refund_Release*Id.Bel_Beginning_Portion),      
 Loss_Portion_from_RA_Release=sum(Loss_Portion_from_RA_Release*Id.Bel_Beginning_Portion),      
 Loss_Portion_from_Interest_Accrete=sum(Loss_Portion_from_Interest_Accrete*Id.Bel_Beginning_Portion),      
 Loss_Portion_from_GainLoss_DiscRate=sum(Loss_Portion_from_GainLoss_DiscRate*Id.Bel_Beginning_Portion),      
 Loss_GainLoss_NonDiscRate=sum(Loss_GainLoss_NonDiscRate*Id.Bel_Beginning_Portion),      
 LOSS_Adjustment=sum(Loss_Adjustment*Id.Bel_Beginning_Portion),      
 Loss_End=@Loss_End+sum((Loss_Initial+Loss_Portion_from_Claim_Release+Loss_Portion_from_Expense_Release+Loss_Portion_from_Cost_Release+Loss_Portion_from_Others_Release+Loss_Portion_from_NDIC_Release+Loss_Portion_from_Refund_Release+Loss_Portion_from_RA_Release+Loss_Portion_from_Interest_Accrete+Loss_Portion_from_GainLoss_DiscRate+Loss_GainLoss_NonDiscRate+Loss_Adjustment)*Id.Bel_Beginning_Portion),      
 ACQ_Amortization=sum(ACQ_Amortization*Id.Commission_Actual_Portion),      
 ACQ_Cost=@ACQ_Cost+sum(ACQ_Cost*Id.Commission_Actual_Portion)      
from @IFRS_Detail Id      
Inner Join IFRS_Movement I on (I.GroupID=Id.GroupID and I.GroupType=Id.GroupType and I.EffMonth=Id.EffMonth and I.EffYear=Id.EffYear)      
Where I.ProcessDate<=@ProcessDate and I.ProcessDate>@PProcessDate      
      
Select 'BEL_Beginning'as Description,  BEL_Beginning as Nominal from @IFRS Union All      
Select 'BEL_Premium_Expected'as Description,  BEL_Premium_Expected as Nominal from @IFRS Union All      
Select 'BEL_Commission_Expected'as Description,  BEL_Commission_Expected as Nominal from @IFRS Union All      
Select 'BEL_Interest_Accrete'as Description,  BEL_Interest_Accrete as Nominal from @IFRS Union All      
Select 'BEL_Claim_Expected'as Description,  BEL_Claim_Expected as Nominal from @IFRS Union All      
Select 'BEL_Claim_NPR_Expected'as Description,  BEL_Claim_NPR_Expected as Nominal from @IFRS Where @GroupType='R' Union All      
Select 'BEL_Expense_Expected'as Description,  BEL_Expense_Expected as Nominal from @IFRS Union All      
Select 'BEL_Cost_Expected'as Description,  BEL_Cost_Expected as Nominal from @IFRS Where @GroupType<>'R' Union All       
Select 'BEL_Others_Expected'as Description,  BEL_Others_Expected as Nominal from @IFRS Where @GroupType<>'R' Union All       
Select 'BEL_NDIC_Expected'as Description,  BEL_NDIC_Expected as Nominal from @IFRS Where @GroupType<>'R' Union All       
Select 'BEL_Refund_Expected'as Description,  BEL_Refund_Expected as Nominal from @IFRS Union All      
Select 'BEL_Ending_Before_Change'as Description,  BEL_Ending_Before_Change as Nominal from @IFRS Union All      
Select 'BEL_GainLoss_NonDiscRate'as Description,  BEL_GainLoss_NonDiscRate as Nominal from @IFRS Union All      
Select 'BEL_Ending_After_Change_NonDiscRate'as Description,  BEL_Ending_After_Change_NonDiscRate as Nominal from @IFRS Union All      
Select 'BEL_GainLoss_DiscRate'as Description,  BEL_GainLoss_DiscRate as Nominal from @IFRS Union All      
Select 'BEL_Ending_After_Change_DiscRate'as Description,  BEL_Ending_After_Change_DiscRate as Nominal from @IFRS Union All      
      
Select 'RA_Beginning'as Description,  RA_Beginning as Nominal from @IFRS Union All      
Select 'RA_Interest_Accrete'as Description,  RA_Interest_Accrete as Nominal from @IFRS Union All      
Select 'RA_Release'as Description,  RA_Release as Nominal from @IFRS Union All      
Select 'RA_Ending_Before_Change'as Description,  RA_Ending_Before_Change as Nominal from @IFRS Union All      
Select 'RA_GainLoss_NonDiscRate'as Description,  RA_GainLoss_NonDiscRate as Nominal from @IFRS Union All      
Select 'RA_Ending_After_Change_NonDiscRate'as Description,  RA_Ending_After_Change_NonDiscRate as Nominal from @IFRS Union All      
Select 'RA_GainLoss_DiscRate'as Description,  RA_GainLoss_DiscRate as Nominal from @IFRS Union All      
Select 'RA_Ending_After_Change_DiscRate'as Description,  RA_Ending_After_Change_DiscRate as Nominal from @IFRS Union All      
      
Select 'CSM_Start'as Description,  CSM_Start as Nominal from @IFRS Union All      
Select 'CSM_Interest_Accrete'as Description,  CSM_Interest_Accrete as Nominal from @IFRS Union All      
Select 'CSM_Amortization'as Description,  CSM_Amortization as Nominal from @IFRS Union All      
Select 'CSM_GainLoss_NonDiscRate'as Description,  CSM_GainLoss_NonDiscRate as Nominal from @IFRS Union All      
Select 'CSM_Adjustment' as Description, CSM_Adjustment as Nominal from @IFRS Union All      
Select 'CSM_End' as Description, CSM_End as Nominal from @IFRS Union All      
      
Select 'PAA_Start'as Description,  PAA_Start as Nominal from @IFRS Where (@Method='P')  Union All      
Select 'PAA_Adjustment_Financial'as Description,  PAA_Interest_Accrete as Nominal from @IFRS Where @Method='P' Union All      
Select 'PAA_Amount_Recognized_As_Revenue'as Description,  PAA_Amortization as Nominal from @IFRS Where @Method='P' Union All      
Select 'PAA_End' as Description, PAA_End as Nominal from @IFRS Where (@Method='P') Union All      
      
Select 'Loss_Start'as Description,  Loss_Start as Nominal from @IFRS Where @GroupType='I' Union All      
Select 'Loss_Portion_from_Claim_Release'as Description,  Loss_Portion_from_Claim_Release as Nominal from @IFRS Where @GroupType='I' Union All      
Select 'Loss_Portion_from_Expense_Release'as Description,  Loss_Portion_from_Expense_Release as Nominal from @IFRS  Where @GroupType='I' Union All      
Select 'Loss_Portion_from_Cost_Release'as Description,  Loss_Portion_from_Cost_Release as Nominal from @IFRS Where @GroupType='I' Union All      
Select 'Loss_Portion_from_Others_Release'as Description,  Loss_Portion_from_Others_Release as Nominal from @IFRS Where @GroupType='I' Union All      
Select 'Loss_Portion_from_NDIC_Release'as Description,  Loss_Portion_from_NDIC_Release as Nominal from @IFRS Where @GroupType='I' Union All      
Select 'Loss_Portion_from_Refund_Release'as Description,  Loss_Portion_from_Refund_Release as Nominal from @IFRS Where @GroupType='I' Union All      
Select 'Loss_Portion_from_RA_Release'as Description,  Loss_Portion_from_RA_Release as Nominal from @IFRS Where @GroupType='I' Union All      
Select 'Loss_Portion_from_Interest_Accrete'as Description,  Loss_Portion_from_Interest_Accrete as Nominal from @IFRS Where @GroupType='I' Union All      
Select 'Loss_Portion_from_GainLoss_DiscRate'as Description,  Loss_Portion_from_GainLoss_DiscRate as Nominal from @IFRS Where @GroupType='I' Union All      
Select 'Loss_GainLoss_NonDiscRate'as Description,  Loss_GainLoss_NonDiscRate as Nominal from @IFRS Where @GroupType='I' Union All      
Select 'Loss_Adjustment' as Description, Loss_adjustment as Nominal from @IFRS Where @GroupType='I' Union All      
Select 'Loss_End' as Description, Loss_End as Nominal from @IFRS Where @GroupType='I' Union All      
      
Select 'ACQ_Amortization'as Description,  ACQ_Amortization as Nominal from @IFRS Union All      
Select 'ACQ_Cost'as Description,  ACQ_Cost as Nominal from @IFRS      
  
GO



---------------------------------------------------------------------------------
----------------------------------IFRS_SHOW_CALCULATION----------------------------------
---------------------------------------------------------------------------------
DROP Procedure IFRS_SHOW_CALCULATION
GO
Create Procedure IFRS_SHOW_CALCULATION(@GroupID as int, @GroupType as varchar(1), @YearN as Int, @MonthN as Int, @Cumulative as Bit)    
as    
    
Declare @IFRS table (    
 BEL_Beginning Float,    
 BEL_Premium_Expected Float,    
 BEL_Commission_Expected Float,    
 BEL_Interest_Accrete Float,    
 BEL_Claim_Expected Float,    
 BEL_Claim_NPR_Expected Float,    
 BEL_Expense_Expected Float,    
 BEL_Cost_Expected Float,    
 BEL_Others_Expected Float,    
 BEL_NDIC_Expected Float,    
 BEL_Refund_Expected Float,    
 BEL_Ending_Before_Change Float,    
 BEL_Ending_After_Change_NonDiscRate Float,    
 BEL_Ending_After_Change_DiscRate Float,    
 BEL_GainLoss_NonDiscRate Float,    
 BEL_GainLoss_DiscRate Float,    
 RA_Beginning Float,    
 RA_Interest_Accrete Float,    
 RA_Release Float,    
 RA_Ending_Before_Change Float,    
 RA_Ending_After_Change_NonDiscRate Float,    
 RA_Ending_After_Change_DiscRate Float,    
 RA_GainLoss_NonDiscRate Float,    
 RA_GainLoss_DiscRate Float,    
 CSM_Start Float,    
 CSM_Interest_Accrete Float,    
 CSM_Amortization Float,    
 CSM_GainLoss_NonDiscRate Float,    
 CSM_Adjustment Float,    
 CSM_End Float,    
 PAA_Start Float,    
 PAA_Interest_Accrete Float,    
 PAA_Amortization Float,     
 PAA_End Float,    
 Loss_Start Float,    
 Loss_Portion_from_Claim_Release Float,    
 Loss_Portion_from_Expense_Release Float,    
 Loss_Portion_from_Cost_Release Float,    
 Loss_Portion_from_Others_Release Float,    
 Loss_Portion_from_NDIC_Release Float,    
 Loss_Portion_from_Refund_Release Float,    
 Loss_Portion_from_RA_Release Float,    
 Loss_Portion_from_Interest_Accrete Float,    
 Loss_Portion_from_GainLoss_DiscRate Float,    
 Loss_GainLoss_NonDiscRate Float,    
 Loss_Adjustment Float,    
 Loss_End Float,    
 ACQ_Amortization Float,    
 ACQ_Cost Float    
)    
    
Declare @Method as varchar(1)    
Declare @ProcessDate as Date    
Declare @PProcessDate as Date    
    
Select     
@Method=I.Method,    
@ProcessDate=dateadd(day,-1,dateadd(month, ((@YearN-1)*12+@MonthN), cast(I.Month as varchar(2))+'/01/'+cast(I.year as varchar(4))))    
from IFRS_Calculation I     
Where GroupID=@GroupID    
    
    
Declare @BEL_Ending_After_Change_NonDiscRate as Float    
Declare @RA_Ending_After_Change_NonDiscRate as Float    
Declare @CSM_End as Float    
Declare @PAA_End as Float    
Declare @Loss_End as Float    
Declare @BEL_GainLoss_DiscRate as Float    
Declare @RA_GainLoss_DiscRate as Float    
Declare @ACQ_Cost as Float    
    
if @Cumulative=1     
Begin    
 Select @PProcessDate='01/01/1901'    
 Select @BEL_Ending_After_Change_NonDiscRate=0    
 Select @BEL_GainLoss_DiscRate=0    
 Select @RA_Ending_After_Change_NonDiscRate=0    
 Select @RA_GainLoss_DiscRate=0    
 Select @PAA_End=0    
 Select @CSM_End=0    
 Select @Loss_End=0    
 Select @ACQ_Cost=0    
End    
else    
Begin    
 Select @PProcessDate=dateadd(day,-1,cast(month(@ProcessDate) as varchar(2))+'/01/'+cast(year(@ProcessDate) as varchar(4)))    
    
 Select     
  @BEL_Ending_After_Change_NonDiscRate=sum(BEL_Initial+BEL_Premium_Expected+BEL_Commission_Expected+BEL_Interest_Accrete+BEL_Claim_Expected+BEL_Claim_NPR_Expected+BEL_Expense_Expected+BEL_Cost_Expected+BEL_Others_Expected+BEL_NDIC_Expected+BEL_Refund_Expected+BEL_GainLoss_NonDiscRate),    
  @BEL_GainLoss_DiscRate=sum(BEL_GainLoss_DiscRate),    
  @RA_Ending_After_Change_NonDiscRate=sum(RA_Initial+RA_Interest_Accrete+RA_Release+RA_GainLoss_NonDiscRate),    
  @RA_GainLoss_DiscRate=sum(RA_GainLoss_DiscRate),    
  @CSM_End=sum(CSM_Initial+CSM_Interest_Accrete+CSM_Amortization+CSM_GainLoss_NonDiscRate+CSM_Adjustment),    
  @PAA_End=sum(PAA_Premium_Expected+PAA_Commission_Expected+PAA_Interest_Accrete+PAA_Amortization),    
  @Loss_End=sum(Loss_Initial+Loss_Portion_from_Claim_Release+Loss_Portion_from_Expense_Release+Loss_Portion_from_Cost_Release+Loss_Portion_from_Others_Release+Loss_Portion_from_NDIC_Release+Loss_Portion_from_Refund_Release+Loss_Portion_from_RA_Release+Loss_Portion_from_Interest_Accrete+Loss_Portion_from_GainLoss_DiscRate+Loss_GainLoss_NonDiscRate+Loss_Adjustment),    
  @ACQ_Cost=sum(ACQ_Cost+ACQ_Amortization)    
  from IFRS_Movement I    
  Where I.GroupID=@GroupID and I.GroupType=@GroupType and I.ProcessDate<=@PProcessDate     
      
  if @BEL_Ending_After_Change_NonDiscRate is null    
  Select @BEL_Ending_After_Change_NonDiscRate=0    
  if @BEL_GainLoss_DiscRate is null    
  Select @BEL_GainLoss_DiscRate=0    
  if @RA_Ending_After_Change_NonDiscRate is null    
  Select @RA_Ending_After_Change_NonDiscRate=0    
  if @RA_GainLoss_DiscRate is null    
  Select @RA_GainLoss_DiscRate=0    
  if @CSM_End is null    
  Select @CSM_End=0    
  if @PAA_End is null    
  Select @PAA_End=0    
  if @Loss_End is null    
  Select @Loss_End=0    
  if @ACQ_Cost is null    
  Select @ACQ_Cost=0    
End    
    
    
    
insert into @IFRS    
Select     
 BEL_Beginning=@BEL_Ending_After_Change_NonDiscRate+sum(BEL_Initial),    
 BEL_Premium_Expected=sum(BEL_Premium_Expected),    
 BEL_Commission_Expected=sum(BEL_Commission_Expected),    
 BEL_Interest_Accrete=sum(BEL_Interest_Accrete),    
 BEL_Claim_Expected=sum(BEL_Claim_Expected),    
 BEL_Claim_NPR_Expected=sum(BEL_Claim_NPR_Expected),    
 BEL_Expense_Expected=sum(BEL_Expense_Expected),    
 BEL_Cost_Expected=sum(BEL_Cost_Expected),    
 BEL_Others_Expected=sum(BEL_Others_Expected),    
 BEL_NDIC_Expected=sum(BEL_NDIC_Expected),    
 BEL_Refund_Expected=sum(BEL_Refund_Expected),    
    
 BEL_Ending_Before_Change=@BEL_Ending_After_Change_NonDiscRate+sum(BEL_Initial+BEL_Premium_Expected+BEL_Commission_Expected+BEL_Interest_Accrete+BEL_Claim_Expected+BEL_Claim_NPR_Expected+BEL_Expense_Expected+BEL_Cost_Expected+BEL_Others_Expected+BEL_NDIC_Expected+BEL_Refund_Expected),    
    
 BEL_Ending_After_Change_NonDiscRate=@BEL_Ending_After_Change_NonDiscRate+sum(BEL_Initial+BEL_Premium_Expected+BEL_Commission_Expected+BEL_Interest_Accrete+BEL_Claim_Expected+BEL_Claim_NPR_Expected+BEL_Expense_Expected+BEL_Cost_Expected+BEL_Others_Expected+BEL_NDIC_Expected+BEL_Refund_Expected+BEL_GainLoss_NonDiscRate),    
 BEL_Ending_After_Change_DiscRate=@BEL_Ending_After_Change_NonDiscRate+@BEL_GainLoss_DiscRate+sum(BEL_Initial+BEL_Premium_Expected+BEL_Commission_Expected+BEL_Interest_Accrete+BEL_Claim_Expected+BEL_Claim_NPR_Expected+BEL_Expense_Expected+BEL_Cost_Expected+BEL_Others_Expected+BEL_NDIC_Expected+BEL_Refund_Expected+BEL_GainLoss_NonDiscRate+BEL_GainLoss_DiscRate),    
    
 BEL_GainLoss_NonDiscRate=sum(BEL_GainLoss_NonDiscRate),    
 BEL_GainLoss_DiscRate=@BEL_GainLoss_DiscRate+sum(BEL_GainLoss_DiscRate),    
    
 RA_Beginning=@RA_Ending_After_Change_NonDiscRate+sum(+RA_Initial),    
 RA_Interest_Accrete=sum(RA_Interest_Accrete),    
 RA_Release=sum(RA_Release),    
    
 RA_Ending_Before_Change=@RA_Ending_After_Change_NonDiscRate+sum(RA_Initial+RA_Interest_Accrete+RA_Release),    
    
 RA_Ending_After_Change_NonDiscRate=@RA_Ending_After_Change_NonDiscRate+sum(RA_Initial+RA_Interest_Accrete+RA_Release+RA_GainLoss_NonDiscRate),    
 RA_Ending_After_Change_DiscRate=@RA_Ending_After_Change_NonDiscRate+@RA_GainLoss_DiscRate+sum(RA_Initial+RA_Interest_Accrete+RA_Release+RA_GainLoss_NonDiscRate+RA_GainLoss_DiscRate),    
    
 RA_GainLoss_NonDiscRate=sum(RA_GainLoss_NonDiscRate),    
 RA_GainLoss_DiscRate=@RA_GainLoss_DiscRate+sum(RA_GainLoss_DiscRate),    
    
 CSM_Start=@CSM_End+sum(CSM_Initial),    
 CSM_Interest_Accrete=sum(CSM_Interest_Accrete),    
 CSM_Amortization=sum(CSM_Amortization),    
 CSM_GainLoss_NonDiscRate=sum(CSM_GainLoss_NonDiscRate),    
 CSM_Adjustment=sum(CSM_Adjustment),    
 CSM_End=@CSM_End+sum(CSM_Initial+CSM_Interest_Accrete+CSM_Amortization+CSM_GainLoss_NonDiscRate+CSM_Adjustment),    
    
 PAA_Start=@PAA_End+sum(PAA_Premium_Expected+PAA_Commission_Expected),    
 PAA_Interest_Accrete=sum(PAA_Interest_Accrete),    
 PAA_Amortization=sum(PAA_Amortization),    
 PAA_End=@PAA_End+sum(PAA_Premium_Expected+PAA_Commission_Expected+PAA_Interest_Accrete+PAA_Amortization),    
    
 Loss_Start=@Loss_End+sum(LOSS_Initial),    
 Loss_Portion_from_Claim_Release=sum(Loss_Portion_from_Claim_Release),    
 Loss_Portion_from_Expense_Release=sum(Loss_Portion_from_Expense_Release),    
 Loss_Portion_from_Cost_Release=sum(Loss_Portion_from_Cost_Release),    
 Loss_Portion_from_Others_Release=sum(Loss_Portion_from_Others_Release),    
 Loss_Portion_from_NDIC_Release=sum(Loss_Portion_from_NDIC_Release),    
 Loss_Portion_from_Refund_Release=sum(Loss_Portion_from_Refund_Release),    
 Loss_Portion_from_RA_Release=sum(Loss_Portion_from_RA_Release),    
 Loss_Portion_from_Interest_Accrete=sum(Loss_Portion_from_Interest_Accrete),    
 Loss_Portion_from_GainLoss_DiscRate=sum(Loss_Portion_from_GainLoss_DiscRate),    
 Loss_GainLoss_NonDiscRate=sum(Loss_GainLoss_NonDiscRate),    
 LOSS_Adjustment=sum(Loss_Adjustment),    
 Loss_End=@Loss_End+sum(Loss_Initial+Loss_Portion_from_Claim_Release+Loss_Portion_from_Expense_Release+Loss_Portion_from_Cost_Release+Loss_Portion_from_Others_Release+Loss_Portion_from_NDIC_Release+Loss_Portion_from_Refund_Release+Loss_Portion_from_RA_Release+Loss_Portion_from_Interest_Accrete+Loss_Portion_from_GainLoss_DiscRate+Loss_GainLoss_NonDiscRate+Loss_Adjustment),    
 ACQ_Amortization=sum(ACQ_Amortization),    
 ACQ_Cost=@ACQ_Cost+sum(ACQ_Cost)    
from IFRS_Movement I    
Where I.GroupID=@GroupID and I.GroupType=@GroupType and I.ProcessDate<=@ProcessDate and I.ProcessDate>@PProcessDate    
    
Select 'BEL_Beginning'as Description,  BEL_Beginning as Nominal from @IFRS Union All    
Select 'BEL_Premium_Expected'as Description,  BEL_Premium_Expected as Nominal from @IFRS Union All    
Select 'BEL_Commission_Expected'as Description,  BEL_Commission_Expected as Nominal from @IFRS Union All    
Select 'BEL_Interest_Accrete'as Description,  BEL_Interest_Accrete as Nominal from @IFRS Union All    
Select 'BEL_Claim_Expected'as Description,  BEL_Claim_Expected as Nominal from @IFRS Union All    
Select 'BEL_Claim_NPR_Expected'as Description,  BEL_Claim_NPR_Expected as Nominal from @IFRS Where @GroupType='R' Union All    
Select 'BEL_Expense_Expected'as Description,  BEL_Expense_Expected as Nominal from @IFRS Union All    
Select 'BEL_Cost_Expected'as Description,  BEL_Cost_Expected as Nominal from @IFRS Where @GroupType<>'R' Union All     
Select 'BEL_Others_Expected'as Description,  BEL_Others_Expected as Nominal from @IFRS Where @GroupType<>'R' Union All     
Select 'BEL_NDIC_Expected'as Description,  BEL_NDIC_Expected as Nominal from @IFRS Where @GroupType<>'R' Union All     
Select 'BEL_Refund_Expected'as Description,  BEL_Refund_Expected as Nominal from @IFRS Union All    
Select 'BEL_Ending_Before_Change'as Description,  BEL_Ending_Before_Change as Nominal from @IFRS Union All    
Select 'BEL_GainLoss_NonDiscRate'as Description,  BEL_GainLoss_NonDiscRate as Nominal from @IFRS Union All    
Select 'BEL_Ending_After_Change_NonDiscRate'as Description,  BEL_Ending_After_Change_NonDiscRate as Nominal from @IFRS Union All    
Select 'BEL_GainLoss_DiscRate'as Description,  BEL_GainLoss_DiscRate as Nominal from @IFRS Union All    
Select 'BEL_Ending_After_Change_DiscRate'as Description,  BEL_Ending_After_Change_DiscRate as Nominal from @IFRS Union All    
    
Select 'RA_Beginning'as Description,  RA_Beginning as Nominal from @IFRS Union All    
Select 'RA_Interest_Accrete'as Description,  RA_Interest_Accrete as Nominal from @IFRS Union All    
Select 'RA_Release'as Description,  RA_Release as Nominal from @IFRS Union All    
Select 'RA_Ending_Before_Change'as Description,  RA_Ending_Before_Change as Nominal from @IFRS Union All    
Select 'RA_GainLoss_NonDiscRate'as Description,  RA_GainLoss_NonDiscRate as Nominal from @IFRS Union All    
Select 'RA_Ending_After_Change_NonDiscRate'as Description,  RA_Ending_After_Change_NonDiscRate as Nominal from @IFRS Union All    
Select 'RA_GainLoss_DiscRate'as Description,  RA_GainLoss_DiscRate as Nominal from @IFRS Union All    
Select 'RA_Ending_After_Change_DiscRate'as Description,  RA_Ending_After_Change_DiscRate as Nominal from @IFRS Union All    
    
Select 'CSM_Start'as Description,  CSM_Start as Nominal from @IFRS Union All    
Select 'CSM_Interest_Accrete'as Description,  CSM_Interest_Accrete as Nominal from @IFRS Union All    
Select 'CSM_Amortization'as Description,  CSM_Amortization as Nominal from @IFRS Union All    
Select 'CSM_GainLoss_NonDiscRate'as Description,  CSM_GainLoss_NonDiscRate as Nominal from @IFRS Union All    
Select 'CSM_Adjustment' as Description, CSM_Adjustment as Nominal from @IFRS Union All    
Select 'CSM_End' as Description, CSM_End as Nominal from @IFRS Union All    
    
Select 'PAA_Start'as Description,  PAA_Start as Nominal from @IFRS Where (@Method='P')  Union All    
Select 'PAA_Adjustment_Financial'as Description,  PAA_Interest_Accrete as Nominal from @IFRS Where @Method='P' Union All    
Select 'PAA_Amount_Recognized_As_Revenue'as Description,  PAA_Amortization as Nominal from @IFRS Where @Method='P' Union All    
Select 'PAA_End' as Description, PAA_End as Nominal from @IFRS Where (@Method='P') Union All    
    
Select 'Loss_Start'as Description,  Loss_Start as Nominal from @IFRS Where @GroupType='I' Union All    
Select 'Loss_Portion_from_Claim_Release'as Description,  Loss_Portion_from_Claim_Release as Nominal from @IFRS Where @GroupType='I' Union All    
Select 'Loss_Portion_from_Expense_Release'as Description,  Loss_Portion_from_Expense_Release as Nominal from @IFRS  Where @GroupType='I' Union All    
Select 'Loss_Portion_from_Cost_Release'as Description,  Loss_Portion_from_Cost_Release as Nominal from @IFRS Where @GroupType='I' Union All    
Select 'Loss_Portion_from_Others_Release'as Description,  Loss_Portion_from_Others_Release as Nominal from @IFRS Where @GroupType='I' Union All    
Select 'Loss_Portion_from_NDIC_Release'as Description,  Loss_Portion_from_NDIC_Release as Nominal from @IFRS Where @GroupType='I' Union All    
Select 'Loss_Portion_from_Refund_Release'as Description,  Loss_Portion_from_Refund_Release as Nominal from @IFRS Where @GroupType='I' Union All    
Select 'Loss_Portion_from_RA_Release'as Description,  Loss_Portion_from_RA_Release as Nominal from @IFRS Where @GroupType='I' Union All    
Select 'Loss_Portion_from_Interest_Accrete'as Description,  Loss_Portion_from_Interest_Accrete as Nominal from @IFRS Where @GroupType='I' Union All    
Select 'Loss_Portion_from_GainLoss_DiscRate'as Description,  Loss_Portion_from_GainLoss_DiscRate as Nominal from @IFRS Where @GroupType='I' Union All    
Select 'Loss_GainLoss_NonDiscRate'as Description,  Loss_GainLoss_NonDiscRate as Nominal from @IFRS Where @GroupType='I' Union All    
Select 'Loss_Adjustment' as Description, Loss_adjustment as Nominal from @IFRS Where @GroupType='I' Union All    
Select 'Loss_End' as Description, Loss_End as Nominal from @IFRS Where @GroupType='I' Union All    
Select 'ACQ_Amortization'as Description,  ACQ_Amortization as Nominal from @IFRS Union All    
Select 'ACQ_Cost'as Description,  ACQ_Cost as Nominal from @IFRS    

GO


---------------------------------------------------------------------------------
----------------------------------IFRS_Show_Movement----------------------------------
---------------------------------------------------------------------------------
DROP Procedure IFRS_SHOW_MOVEMENT
GO
Create Procedure IFRS_SHOW_MOVEMENT(@GroupID as Int, @GroupType as varchar(1), @SDate smalldatetime, @EDate smalldatetime)  
as  
  
Declare @IFRS table (  
 VType varchar(10),   
 BEL_Initial Float,  
 BEL_Premium_Expected Float,  
 BEL_Commission_Expected Float,  
 BEL_Interest_Accrete Float,  
 BEL_Claim_Expected Float,  
 BEL_Claim_NPR_Expected Float,  
 BEL_Expense_Expected Float,  
 BEL_Cost_Expected Float,  
 BEL_Others_Expected Float,  
 BEL_NDIC_Expected Float,  
 BEL_Refund_Expected Float,  
 BEL_GainLoss_NonDiscRate Float,  
 BEL_GainLoss_DiscRate Float,  
 RA_Initial Float,  
 RA_Interest_Accrete Float,  
 RA_Release Float,  
 RA_GainLoss_NonDiscRate Float,  
 RA_GainLoss_DiscRate Float,  
 CSM_Initial Float,  
 CSM_Interest_Accrete Float,  
 CSM_Amortization Float,  
 CSM_GainLoss_NonDiscRate Float,  
 CSM_Adjustment Float,  
 PAA_Premium_Expected Float,  
 PAA_Commission_Expected Float,  
 PAA_Interest_Accrete Float,  
 PAA_Amortization Float,  
 Loss_Initial Float,  
 Loss_Portion_from_Claim_Release Float,  
 Loss_Portion_from_Expense_Release Float,  
 Loss_Portion_from_Cost_Release Float,  
 Loss_Portion_from_Others_Release Float,  
 Loss_Portion_from_NDIC_Release Float,  
 Loss_Portion_from_Refund_Release Float,  
 Loss_Portion_from_RA_Release Float,  
 Loss_Portion_from_Interest_Accrete Float,  
 Loss_Portion_from_GainLoss_DiscRate Float,  
 Loss_GainLoss_NonDiscRate Float,  
 Loss_Adjustment Float,  
 ACQ_Amortization Float,  
 ACQ_Cost Float  
)  
  
Declare @Method as varchar(1)  
Declare @OneRous as Bit  
  
Select @Method=I.Method, @OneRous=Case WHen @GroupType='I' Then I.OneRous else cast(0 as Bit) end from IFRS_Calculation I Where GroupID=@GroupID  
  
insert into @IFRS  
Select   
 VType=Max(Voucher.VType),  
 BEL_Initial=sum(BEL_Initial),  
 BEL_Premium_Expected=sum(BEL_Premium_Expected),  
 BEL_Commission_Expected=sum(BEL_Commission_Expected),  
 BEL_Interest_Accrete=sum(BEL_Interest_Accrete),  
 BEL_Claim_Expected=sum(BEL_Claim_Expected),  
 BEL_Claim_NPR_Expected=sum(BEL_Claim_NPR_Expected),  
 BEL_Expense_Expected=sum(BEL_Expense_Expected),  
 BEL_Cost_Expected=sum(BEL_Cost_Expected),  
 BEL_Others_Expected=sum(BEL_Others_Expected),  
 BEL_NDIC_Expected=sum(BEL_NDIC_Expected),  
 BEL_Refund_Expected=sum(BEL_Refund_Expected),  
 BEL_GainLoss_NonDiscRate=sum(BEL_GainLoss_NonDiscRate),  
 BEL_GainLoss_DiscRate=sum(BEL_GainLoss_DiscRate),  
  
 RA_Initial=sum(RA_Initial),  
 RA_Interest_Accrete=sum(RA_Interest_Accrete),  
 RA_Release=sum(RA_Release),   
 RA_GainLoss_NonDiscRate=sum(RA_GainLoss_NonDiscRate),  
 RA_GainLoss_DiscRate=sum(RA_GainLoss_DiscRate),  
  
 CSM_Initial=sum(CSM_Initial),  
 CSM_Interest_Accrete=sum(CSM_Interest_Accrete),  
 CSM_Amortization=sum(CSM_Amortization),  
 CSM_GainLoss_NonDiscRate=sum(CSM_GainLoss_NonDiscRate),  
 CSM_Adjustment=sum(CSM_Adjustment),  
  
 PAA_Premium_Expected=sum(PAA_Premium_Expected),  
 PAA_Commission_Expected=sum(PAA_Commission_Expected),  
 PAA_Interest_Accrete=sum(PAA_Interest_Accrete),  
 PAA_Amortization=sum(PAA_Amortization),  
  
 Loss_Initial=sum(Loss_Initial),  
 Loss_Portion_from_Claim_Release=sum(Loss_Portion_from_Claim_Release),  
 Loss_Portion_from_Expense_Release=sum(Loss_Portion_from_Expense_Release),  
 Loss_Portion_from_Cost_Release=sum(Loss_Portion_from_Cost_Release),  
 Loss_Portion_from_Others_Release=sum(Loss_Portion_from_Others_Release),  
 Loss_Portion_from_NDIC_Release=sum(Loss_Portion_from_NDIC_Release),  
 Loss_Portion_from_Refund_Release=sum(Loss_Portion_from_Refund_Release),  
 Loss_Portion_from_RA_Release=sum(Loss_Portion_from_RA_Release),  
 Loss_Portion_from_Interest_Accrete=sum(Loss_Portion_from_Interest_Accrete),  
 Loss_Portion_from_GainLoss_DiscRate=sum(Loss_Portion_from_GainLoss_DiscRate),  
 Loss_GainLoss_NonDiscRate=sum(Loss_GainLoss_NonDiscRate),  
 LOSS_Adjustment=sum(Loss_Adjustment),  
 ACQ_Amortization=sum(ACQ_Amortization),  
 ACQ_Cost=sum(ACQ_Cost)  
from IFRS_Movement I, AccLink A, mVoucher Voucher  
Where I.GroupID=@GroupID and I.GroupType=@GroupType and I.ProcessDate Between @Sdate and @EDate  
and Voucher.Voucher=A.Voucher and A.AccNo=I.AccNo  
  
Select VType, -1 as Hint, 'BEL_Initial'as Description,  BEL_Initial as Nominal from @IFRS Where @Method='B' Union All  
Select VType, -2 as Hint, 'BEL_Premium_Expected'as Description,  BEL_Premium_Expected as Nominal from @IFRS Where @Method='B' Union All  
Select VType, -3 as Hint, 'BEL_Commission_Expected'as Description,  BEL_Commission_Expected as Nominal from @IFRS Where @Method='B' Union All  
Select VType, -4 as Hint, 'BEL_Interest_Accrete'as Description,  BEL_Interest_Accrete as Nominal from @IFRS Where @Method='B' Union All  
Select VType, -5 as Hint, 'BEL_Claim_Expected'as Description,  BEL_Claim_Expected as Nominal from @IFRS Where @Method='B' Union All  
Select VType, -30 as Hint, 'BEL_Claim_NPR_Expected'as Description,  BEL_Claim_NPR_Expected as Nominal from @IFRS Where @Method='B' and @GroupType='R' Union All  
Select VType, -6 as Hint, 'BEL_Expense_Expected'as Description,  BEL_Expense_Expected as Nominal from @IFRS Where @Method='B' Union All  
Select VType, -17 as Hint, 'BEL_Cost_Expected'as Description,  BEL_Cost_Expected as Nominal from @IFRS Where @Method='B' and @GroupType<>'R' Union All  
Select VType, -32 as Hint, 'BEL_Others_Expected'as Description,  BEL_Others_Expected as Nominal from @IFRS Where @Method='B' and @GroupType<>'R' Union All  
Select VType, -34 as Hint, 'BEL_NDIC_Expected'as Description,  BEL_NDIC_Expected as Nominal from @IFRS Where @Method='B' and @GroupType<>'R' Union All  
Select VType, -28 as Hint, 'BEL_Refund_Expected'as Description,  BEL_Refund_Expected as Nominal from @IFRS Where @Method='B' Union All  
Select VType, -7 as Hint, 'BEL_GainLoss_NonDiscRate'as Description,  BEL_GainLoss_NonDiscRate as Nominal from @IFRS Where @Method='B' Union All  
Select VType, -8 as Hint, 'BEL_GainLoss_DiscRate'as Description,  BEL_GainLoss_DiscRate as Nominal from @IFRS Where @Method='B' Union All  
Select VType, -9 as Hint, 'RA_Initial'as Description,  RA_Initial as Nominal from @IFRS Where @Method='B' Union All  
Select VType, -10 as Hint, 'RA_Interest_Accrete'as Description,  RA_Interest_Accrete as Nominal from @IFRS Where @Method='B' Union All  
Select VType, -11 as Hint, 'RA_Release'as Description,  RA_Release as Nominal from @IFRS Where @Method='B' Union All  
Select VType, -12 as Hint, 'RA_GainLoss_NonDiscRate'as Description,  RA_GainLoss_NonDiscRate as Nominal from @IFRS Where @Method='B' Union All  
Select VType, -13 as Hint, 'RA_GainLoss_DiscRate'as Description,  RA_GainLoss_DiscRate as Nominal from @IFRS Where @Method='B' Union All  
  
Select VType, -14 as Hint, 'CSM_Initial'as Description,  CSM_Initial as Nominal from @IFRS Where (@Method='B') and (CSM_Initial<>0) Union All  
Select VType, -15 as Hint, 'CSM_Interest_Accrete'as Description,  CSM_Interest_Accrete as Nominal from @IFRS Where (@Method='B') and (CSM_Interest_Accrete<>0) Union All  
Select VType, -16 as Hint, 'CSM_Amortization'as Description,  CSM_Amortization as Nominal from @IFRS Where (@Method='B') and (CSM_Amortization<>0) Union All  
Select VType, -18 as Hint, 'CSM_GainLoss_NonDiscRate'as Description,  CSM_GainLoss_NonDiscRate as Nominal from @IFRS Where (@Method='B') and (CSM_GainLoss_NonDiscRate<>0) Union All  
Select VType, -14 as Hint, 'CSM_Adjustment'as Description,  CSM_Adjustment as Nominal from @IFRS Where (@Method='B') and (CSM_Adjustment<>0) Union All  
  
Select VType, -2 as Hint, 'PAA_Premium_Expected'as Description,  PAA_Premium_Expected as Nominal from @IFRS Where @Method='P' Union All  
Select VType, -3 as Hint, 'PAA_Commission_Expected'as Description,  PAA_Commission_Expected as Nominal from @IFRS Where @Method='P' Union All  
Select VType, -15 as Hint, 'PAA_Adjustment_Financial'as Description,  PAA_Interest_Accrete as Nominal from @IFRS Where @Method='P' Union All  
Select VType, -16 as Hint, 'PAA_Amount_Recognized_As_Revenue'as Description,  PAA_Amortization as Nominal from @IFRS Where @Method='P' Union All  
  
Select VType, -19 as Hint, 'Loss_Initial'as Description,  Loss_Initial as Nominal from @IFRS Where (@Method='B' and @GroupType='I') and (Loss_Initial<>0) Union All  
Select VType, -20 as Hint, 'Loss_Portion_from_Claim_Release'as Description,  Loss_Portion_from_Claim_Release as Nominal from @IFRS Where (@Method='B' and @GroupType='I') and (Loss_Portion_from_Claim_Release<>0) Union All  
Select VType, -21 as Hint, 'Loss_Portion_from_Expense_Release'as Description,  Loss_Portion_from_Expense_Release as Nominal from @IFRS Where (@Method='B' and @GroupType='I') and (Loss_Portion_from_Expense_Release<>0) Union All  
Select VType, -24 as Hint, 'Loss_Portion_from_Cost_Release'as Description,  Loss_Portion_from_Cost_Release as Nominal from @IFRS Where (@Method='B' and @GroupType='I') and (Loss_Portion_from_Cost_Release<>0) Union All  
Select VType, -33 as Hint, 'Loss_Portion_from_Others_Release'as Description,  Loss_Portion_from_Others_Release as Nominal from @IFRS Where (@Method='B' and @GroupType='I') and (Loss_Portion_from_Others_Release<>0) Union All  
Select VType, -35 as Hint, 'Loss_Portion_from_NDIC_Release'as Description,  Loss_Portion_from_NDIC_Release as Nominal from @IFRS Where (@Method='B' and @GroupType='I') and (Loss_Portion_from_NDIC_Release<>0) Union All  
Select VType, -29 as Hint, 'Loss_Portion_from_Refund_Release'as Description,  Loss_Portion_from_Refund_Release as Nominal from @IFRS Where (@Method='B' and @GroupType='I') and (Loss_Portion_from_Refund_Release<>0) Union All   
Select VType, -22 as Hint, 'Loss_Portion_from_RA_Release'as Description,  Loss_Portion_from_RA_Release as Nominal from @IFRS Where (@Method='B' and @GroupType='I') and (Loss_Portion_from_RA_Release<>0) Union All  
Select VType, -23 as Hint, 'Loss_Portion_from_Interest_Accrete'as Description,  Loss_Portion_from_Interest_Accrete as Nominal from @IFRS Where (@Method='B' and @GroupType='I') and (Loss_Portion_from_Interest_Accrete<>0)   
Select VType, -25 as Hint, 'Loss_Portion_from_GainLoss_DiscRate'as Description,  Loss_Portion_from_GainLoss_DiscRate as Nominal from @IFRS Where (@Method='B' and @GroupType='I') and (Loss_Portion_from_GainLoss_DiscRate<>0) Union All  
Select VType, -26 as Hint, 'Loss_GainLoss_NonDiscRate'as Description,  Loss_GainLoss_NonDiscRate as Nominal from @IFRS Where (@Method='B' and @GroupType='I') and (Loss_GainLoss_NonDiscRate<>0) Union All  
Select VType, -19 as Hint, 'Loss_Adjustment'as Description,  Loss_Adjustment as Nominal from @IFRS Where (@Method='B' and @GroupType='I') and (Loss_Adjustment<>0) Union All  
Select VType, -27 as Hint, 'ACQ_Amortization'as Description,  ACQ_Amortization as Nominal from @IFRS   
Select VType, -31 as Hint, 'ACQ_Cost'as Description,  ACQ_Cost as Nominal from @IFRS   


GO

DROP FUNCTION IFRS_Movement_PROCESS
GO
Create FUNCTION IFRS_Movement_PROCESS(@P_Type varchar(2),@P_Date smalldatetime, @P_PEDate smalldatetime,@P_EDate smalldatetime)              
RETURNS @IFRS TABLE (Branch varchar(10), DocNo varchar(50), RefNo varchar(50), Date smalldatetime, Code varchar(10), Type varchar(10), Currency varchar(10), Subject varchar(10), Remarks varchar(255),  
Amount_1 Float, Amount_2 Float, Amount_3 Float, Amount_4 Float,Amount_5 Float, Amount_6 Float, Amount_7 Float, Amount_8 Float, Amount_9 Float, Amount_10 Float,   
Amount_11 Float, Amount_12 Float, Amount_13 Float, Amount_14 Float, Amount_15 Float, Amount_16 Float, Amount_17 Float, Amount_18 Float, Amount_19 Float, Amount_20 Float,   
Amount_21 Float, Amount_22 Float, Amount_23 Float, Amount_24 Float, Amount_25 Float, Amount_26 Float, Amount_27 Float, Amount_28 Float, Amount_29 Float, Amount_30 Float, Amount_31 Float, Amount_32 Float, Amount_33 Float, Amount_34 Float, Amount_35 Float)  
AS  
BEGIN  
  
Declare @IFRS_Data TABLE (Branch varchar(10), DocNo varchar(50), RefNo varchar(50), Date smalldatetime, Code varchar(10), Type varchar(10), Currency varchar(10), Subject varchar(10), Remarks varchar(255),  
Amount_1 Float, Amount_2 Float, Amount_3 Float, Amount_4 Float,Amount_5 Float, Amount_6 Float, Amount_7 Float, Amount_8 Float, Amount_9 Float, Amount_10 Float,   
Amount_11 Float, Amount_12 Float, Amount_13 Float, Amount_14 Float, Amount_15 Float, Amount_16 Float, Amount_17 Float, Amount_18 Float, Amount_19 Float, Amount_20 Float,   
Amount_21 Float, Amount_22 Float, Amount_23 Float, Amount_24 Float, Amount_25 Float, Amount_26 Float, Amount_27 Float, Amount_28 Float, Amount_29 Float, Amount_30 Float, Amount_31 Float, Amount_32 Float, Amount_33 Float, Amount_34 Float, Amount_35 Float)  
  
Declare @IFRS_Data_Paid TABLE (Branch varchar(10), DocNo varchar(50), RefNo varchar(50), Date smalldatetime, Code varchar(10), Type varchar(10), Currency varchar(10), Subject varchar(10), Remarks varchar(255),  
Amount_1 Float, Amount_2 Float, Amount_3 Float, Amount_4 Float,Amount_5 Float, Amount_6 Float, Amount_7 Float, Amount_8 Float, Amount_9 Float, Amount_10 Float,   
Amount_11 Float, Amount_12 Float, Amount_13 Float, Amount_14 Float, Amount_15 Float, Amount_16 Float, Amount_17 Float, Amount_18 Float, Amount_19 Float, Amount_20 Float,   
Amount_21 Float, Amount_22 Float, Amount_23 Float, Amount_24 Float, Amount_25 Float, Amount_26 Float, Amount_27 Float, Amount_28 Float, Amount_29 Float, Amount_30 Float, Amount_31 Float, Amount_32 Float, Amount_33 Float, Amount_34 Float, Amount_35 Float) 
  
  
insert into @IFRS_Data  
Select I2.Branch, '' as DocNo, '' as RefNo, @P_Date as Date, I2.TOC as Code,   
Case   
When I1.GroupType='I' and I2.Method='B' then 'IFIB'  
When I1.GroupType='R' and I2.Method='B' then 'IFRB'  
When I1.GroupType='I' and I2.Method='P' then 'IFIP'  
else 'IFRP'  
end as Type, I2.Currency, 'JOURNAL' as Subject, MParam.Remarks as Remarks,  
  
Amount_1 = round(sum(case When I2.Method='B' then I1.BEL_Initial else 0 end),16),
Amount_2 = round(sum(case When I2.Method='B' then I1.BEL_Premium_Expected else I1.PAA_Premium_Expected end),16),
Amount_3 = round(sum(case When I2.Method='B' then I1.BEL_Commission_Expected else I1.PAA_Commission_Expected end),16),
Amount_4 = round(sum(case When I2.Method='B' then I1.BEL_Interest_Accrete else 0 end),16),
Amount_5 = round(sum(case When I2.Method='B' then I1.BEL_Claim_Expected else 0 end),16),
Amount_6 = round(sum(case When I2.Method='B' then I1.BEL_Expense_Expected else 0 end),16),
Amount_7 = round(sum(case When I2.Method='B' then I1.BEL_GainLoss_NonDiscRate else 0 end),16),
Amount_8 = round(sum(case When I2.Method='B' then I1.BEL_GainLoss_DiscRate else 0 end),16),
Amount_9 = round(sum(case When I2.Method='B' then I1.RA_Initial else 0 end),16),
Amount_10 = round(sum(case When I2.Method='B' then I1.RA_Interest_Accrete else 0 end),16),
Amount_11 = round(sum(case When I2.Method='B' then I1.RA_Release else 0 end),16),
Amount_12 = round(sum(case When I2.Method='B' then I1.RA_GainLoss_NonDiscRate else 0 end),16),
Amount_13 = round(sum(case When I2.Method='B' then I1.RA_GainLoss_DiscRate else 0 end),16),
Amount_14 = round(sum(case When I2.Method='B' then I1.CSM_Initial+I1.CSM_Adjustment else 0 end),16),
Amount_15 = round(sum(case When I2.Method='B' then I1.CSM_Interest_Accrete else I1.PAA_Interest_Accrete end),16),
Amount_16 = round(sum(case When I2.Method='B' then I1.CSM_Amortization else I1.PAA_Amortization end),16),
Amount_17 = round(sum(case When I2.Method='B' then I1.BEL_Cost_Expected else 0 end),16),
Amount_18 = round(sum(case When I2.Method='B' then I1.CSM_GainLoss_NonDiscRate else 0 end),16),
Amount_19 = round(sum(case When I2.Method='B' then I1.Loss_Initial+I1.Loss_Adjustment else 0 end),16),
Amount_20 = round(sum(case When I2.Method='B' then I1.Loss_Portion_from_Claim_Release else 0 end),16),
Amount_21 = round(sum(case When I2.Method='B' then I1.Loss_Portion_from_Expense_Release else 0 end),16),
Amount_22 = round(sum(case When I2.Method='B' then I1.Loss_Portion_from_RA_Release else 0 end),16),
Amount_23 = round(sum(case When I2.Method='B' then I1.Loss_Portion_from_Interest_Accrete else 0 end),16),
Amount_24 = round(sum(case When I2.Method='B' then I1.Loss_Portion_from_Cost_Release else 0 end),16),
Amount_25 = round(sum(case When I2.Method='B' then I1.Loss_Portion_from_GainLoss_DiscRate else 0 end),16),
Amount_26 = round(sum(case When I2.Method='B' then I1.Loss_GainLoss_NonDiscRate else 0 end),16),
Amount_27 = round(sum(I1.ACQ_Amortization),16),
Amount_28 = round(sum(case When I2.Method='B' then I1.BEL_Refund_Expected else 0 end),16),
Amount_29 = round(sum(case When I2.Method='B' then I1.Loss_Portion_from_Refund_Release else 0 end),16),
Amount_30 = round(sum(case When I2.Method='B' then I1.BEL_Claim_NPR_Expected else 0 end),16),
Amount_31 = round(sum(I1.ACQ_Cost),16),
Amount_32 = round(sum(case When I2.Method='B' then I1.BEL_Others_Expected else 0 end),16),
Amount_33 = round(sum(case When I2.Method='B' then I1.Loss_Portion_from_Others_Release else 0 end),16),
Amount_34 = round(sum(case When I2.Method='B' then I1.BEL_NDIC_Expected else 0 end),16),
Amount_35 = round(sum(case When I2.Method='B' then I1.Loss_Portion_from_NDIC_Release else 0 end),16)
from IFRS_Movement I1   
Inner join IFRS_Calculation I2 on (I2.GroupID=I1.GroupID)  
Inner join MParam on (MParam.Type=@P_Type)  
Where I1.ProcessDate=@P_Date  
Group by   
I2.Branch,   
I2.TOC,   
Case   
When I1.GroupType='I' and I2.Method='B' then 'IFIB'  
When I1.GroupType='R' and I2.Method='B' then 'IFRB'  
When I1.GroupType='I' and I2.Method='P' then 'IFIP'  
else 'IFRP'  
end,  
I2.Currency,   
MParam.Remarks  


  
insert into @IFRS_Data_Paid  
Select I2.Branch, '' as DocNo, '' as RefNo, @P_Date as Date, I2.TOC as Code,   
Case   
When I2.Method='B' then 'IFPB'  
else 'IFPP'  
end as Type, I2.Currency, 'JOURNAL' as Subject, MParam.Remarks as Remarks,  
Amount_1 = sum(I2.Premium+I2.Premium_Rounding),
Amount_2 = cast(0 as Float),
Amount_3 = sum(I2.RIPremium+I2.RIPremium_Rounding),
Amount_4 = sum(I2.Commission+I2.Commission_Rounding),
Amount_5 = sum(I2.RICommission+I2.RICommission_Rounding),
Amount_6 = sum(I2.Others),
Amount_7 = sum(I2.GainLoss),
Amount_8 = sum(I2.GainLossRealizationPremium),
Amount_9 = sum(I2.GainLossRealizationCommission),
Amount_10 = sum(I2.GainLossRealizationRIPremium),
Amount_11 = sum(I2.GainLossRealizationRICommission),
Amount_12 = sum(I2.OtherLiabilities),  
Amount_13 = cast(0 as Float),
Amount_14 = cast(0 as Float),
Amount_15 = cast(0 as Float),
Amount_16 = cast(0 as Float),
Amount_17 = cast(0 as Float),
Amount_18 = cast(0 as Float),
Amount_19 = cast(0 as Float),
Amount_20 = cast(0 as Float),
Amount_21 = cast(0 as Float),
Amount_22 = cast(0 as Float),
Amount_23 = cast(0 as Float),
Amount_24 = cast(0 as Float),
Amount_25 = cast(0 as Float),
Amount_26 = cast(0 as Float),
Amount_27 = cast(0 as Float),
Amount_28 = cast(0 as Float),
Amount_29 = cast(0 as Float),
Amount_30 = cast(0 as Float),
Amount_31 = cast(0 as Float),
Amount_32 = cast(0 as Float),
Amount_33 = cast(0 as Float),
Amount_34 = cast(0 as Float),
Amount_35 = cast(0 as Float)
from IFRS_DATA_PAID(dateadd(day,1,@P_PEDate), @P_EDate) I2  
Inner join MParam on (MParam.Type=@P_Type)  
Group by   
I2.Branch,   
I2.TOC,   
Case   
When I2.Method='B' then 'IFPB'  
else 'IFPP'  
end,  
I2.Currency,   
MParam.Remarks  
  
  
Insert into @IFRS  
Select I1.Branch, I1.DocNo, I1.RefNo, I1.Date, I1.Code, I1.Type, I1.Currency, I1.Subject, I1.Remarks,  
I1.Amount_1,  
I1.Amount_2,   
I1.Amount_3,   
I1.Amount_4,   
I1.Amount_5,  
I1.Amount_6,  
I1.Amount_7,  
I1.Amount_8,  
I1.Amount_9,  
I1.Amount_10,  
I1.Amount_11,  
I1.Amount_12,  
I1.Amount_13,  
I1.Amount_14,  
I1.Amount_15,  
I1.Amount_16,  
I1.Amount_17,  
I1.Amount_18,  
I1.Amount_19,  
I1.Amount_20,  
I1.Amount_21,  
I1.Amount_22,  
I1.Amount_23,  
I1.Amount_24,  
I1.Amount_25,  
I1.Amount_26,  
cast(0 as Float) as Amount_27,  --ACQ Amortization in Base Currency  
I1.Amount_28,  
I1.Amount_29,  
I1.Amount_30,  
cast(0 as Float) as Amount_31,  --ACQ Cost in Base Currency  
I1.Amount_32,  
I1.Amount_33,
I1.Amount_34,
I1.Amount_35
from @IFRS_Data I1  
  
  
Insert into @IFRS  
Select I1.Branch, I1.DocNo, I1.RefNo, I1.Date, I1.Code, I1.Type, SysTab.Currency, I1.Subject, I1.Remarks,  
cast(0 as Float) as Amount_1,  
cast(0 as Float) as Amount_2,  
cast(0 as Float) as Amount_3,  
cast(0 as Float) as Amount_4,  
cast(0 as Float) as Amount_5,  
cast(0 as Float) as Amount_6,  
cast(0 as Float) as Amount_7,  
cast(0 as Float) as Amount_8,  
cast(0 as Float) as Amount_9,  
cast(0 as Float) as Amount_10,  
cast(0 as Float) as Amount_11,  
cast(0 as Float) as Amount_12,  
cast(0 as Float) as Amount_13,  
cast(0 as Float) as Amount_14,  
cast(0 as Float) as Amount_15,  
cast(0 as Float) as Amount_16,  
cast(0 as Float) as Amount_17,  
cast(0 as Float) as Amount_18,  
cast(0 as Float) as Amount_19,  
cast(0 as Float) as Amount_20,  
cast(0 as Float) as Amount_21,  
cast(0 as Float) as Amount_22,  
cast(0 as Float) as Amount_23,  
cast(0 as Float) as Amount_24,  
cast(0 as Float) as Amount_25,  
cast(0 as Float) as Amount_26,  
round(sum(I1.Amount_27),16) as Amount_27, --ACQ Amortization in Base Currency  
cast(0 as Float) as Amount_28,  
cast(0 as Float) as Amount_29,  
cast(0 as Float) as Amount_30,  
round(sum(I1.Amount_31),16) as Amount_31, --ACQ Cost in Base Currency  
cast(0 as Float) as Amount_32,  
cast(0 as Float) as Amount_33,
cast(0 as Float) as Amount_34,
cast(0 as Float) as Amount_35
from @IFRS_Data I1  
Inner Join SysTab on (1=1)  
Group By   
I1.Branch, I1.DocNo, I1.RefNo, I1.Date, I1.Code, I1.Type, SysTab.Currency, I1.Subject, I1.Remarks  
Having round(sum(I1.Amount_27),16)<>0  
  
  
Insert into @IFRS  
Select I1.Branch, I1.DocNo, I1.RefNo, I1.Date, I1.Code, I1.Type, I1.Currency, I1.Subject, I1.Remarks,  
I1.Amount_1,  
I1.Amount_2,   
I1.Amount_3,   
I1.Amount_4,   
I1.Amount_5,  
I1.Amount_6,  
cast(0 as Float) as Amount_7, --Gain Loss in Base Currency  
I1.Amount_8,  
I1.Amount_9,  
I1.Amount_10,  
I1.Amount_11,  
I1.Amount_12,  
I1.Amount_13,  
I1.Amount_14,  
I1.Amount_15,  
I1.Amount_16,  
I1.Amount_17,  
I1.Amount_18,  
I1.Amount_19,  
I1.Amount_20,  
I1.Amount_21,  
I1.Amount_22,  
I1.Amount_23,  
I1.Amount_24,  
I1.Amount_25,  
I1.Amount_26,  
I1.Amount_27,  
I1.Amount_28,  
I1.Amount_29,  
I1.Amount_30,  
I1.Amount_31,  
I1.Amount_32,  
I1.Amount_33,  
I1.Amount_34,
I1.Amount_35
from @IFRS_Data_Paid I1  
  
  
Insert into @IFRS  
Select I1.Branch, I1.DocNo, I1.RefNo, I1.Date, I1.Code, I1.Type, SysTab.Currency, I1.Subject, I1.Remarks,  
cast(0 as Float) as Amount_1,  
cast(0 as Float) as Amount_2,  
cast(0 as Float) as Amount_3,  
cast(0 as Float) as Amount_4,  
cast(0 as Float) as Amount_5,  
cast(0 as Float) as Amount_6,  
round(sum(I1.Amount_7),16) as Amount_7, --Gain Loss in Base Currency  
cast(0 as Float) as Amount_8,  
cast(0 as Float) as Amount_9,  
cast(0 as Float) as Amount_10,  
cast(0 as Float) as Amount_11,  
cast(0 as Float) as Amount_12,  
cast(0 as Float) as Amount_13,  
cast(0 as Float) as Amount_14,  
cast(0 as Float) as Amount_15,  
cast(0 as Float) as Amount_16,  
cast(0 as Float) as Amount_17,  
cast(0 as Float) as Amount_18,  
cast(0 as Float) as Amount_19,  
cast(0 as Float) as Amount_20,  
cast(0 as Float) as Amount_21,  
cast(0 as Float) as Amount_22,  
cast(0 as Float) as Amount_23,  
cast(0 as Float) as Amount_24,  
cast(0 as Float) as Amount_25,  
cast(0 as Float) as Amount_26,  
cast(0 as Float) as Amount_27,   
cast(0 as Float) as Amount_28,  
cast(0 as Float) as Amount_29,  
cast(0 as Float) as Amount_30,  
cast(0 as Float) as Amount_31,  
cast(0 as Float) as Amount_32,  
cast(0 as Float) as Amount_33,  
cast(0 as Float) as Amount_34,
cast(0 as Float) as Amount_35
from @IFRS_Data_Paid I1  
Inner Join SysTab on (1=1)  
Group By   
I1.Branch, I1.DocNo, I1.RefNo, I1.Date, I1.Code, I1.Type, SysTab.Currency, I1.Subject, I1.Remarks  
Having round(sum(I1.Amount_7),16)<>0  
  
RETURN  
END 



