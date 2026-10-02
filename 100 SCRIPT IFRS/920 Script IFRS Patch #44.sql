IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'Installment' AND Object_ID = Object_ID(N'IFRS_Calculation'))
BEGIN
ALTER TABLE IFRS_Calculation ADD Installment int NULL
DECLARE @v sql_variant 
SET @v = N'Number Of Installment'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'IFRS_Calculation', N'COLUMN', N'Installment'
END
GO

IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'TermOfPayment' AND Object_ID = Object_ID(N'IFRS_Calculation'))
BEGIN
ALTER TABLE IFRS_Calculation ADD TermOfPayment int NULL
DECLARE @v sql_variant 
SET @v = N'Number Of Installment'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'IFRS_Calculation', N'COLUMN', N'TermOfPayment'
END
GO

Drop index ifrs_calculation.I_IFRS_Calculation_AssumptionID_Method_Branch_Segment_ISType_TOC_CGroup_Currency_Year_Month_NumMonths_PGroupTag
GO
Create index I_IFRS_Calculation_AssumptionID_Method_Branch_Segment_ISType_TOC_CGroup_Currency_Year_Month_NumMonths_I_T_PGroupTag
on IFRS_Calculation (AssumptionID, Method, Branch, Segment, ISType, TOC, CGroup, Currency, Year, Month, NumMonths, Installment, TermOfPayment, PGroupTag)
WITH (ALLOW_PAGE_LOCKS = OFF, ALLOW_ROW_LOCKS = ON)
GO


-----------------------------------------------------------------------------
-- .::IFRS_Calculation_Detail_BEL::.

-- DROP BEL_Premium_Expected
IF EXISTS(SELECT * FROM sys.columns WHERE Name = N'BEL_Premium_Expected_1' AND Object_ID = Object_ID(N'IFRS_Calculation_Detail_BEL'))
BEGIN
ALTER TABLE IFRS_Calculation_Detail_BEL DROP COLUMN BEL_Premium_Expected_1
END
GO
IF EXISTS(SELECT * FROM sys.columns WHERE Name = N'BEL_Premium_Expected_2' AND Object_ID = Object_ID(N'IFRS_Calculation_Detail_BEL'))
BEGIN
ALTER TABLE IFRS_Calculation_Detail_BEL DROP COLUMN BEL_Premium_Expected_2
END
GO
IF EXISTS(SELECT * FROM sys.columns WHERE Name = N'BEL_Premium_Expected_3' AND Object_ID = Object_ID(N'IFRS_Calculation_Detail_BEL'))
BEGIN
ALTER TABLE IFRS_Calculation_Detail_BEL DROP COLUMN BEL_Premium_Expected_3
END
GO
IF EXISTS(SELECT * FROM sys.columns WHERE Name = N'BEL_Premium_Expected_4' AND Object_ID = Object_ID(N'IFRS_Calculation_Detail_BEL'))
BEGIN
ALTER TABLE IFRS_Calculation_Detail_BEL DROP COLUMN BEL_Premium_Expected_4
END
GO
IF EXISTS(SELECT * FROM sys.columns WHERE Name = N'BEL_Premium_Expected_5' AND Object_ID = Object_ID(N'IFRS_Calculation_Detail_BEL'))
BEGIN
ALTER TABLE IFRS_Calculation_Detail_BEL DROP COLUMN BEL_Premium_Expected_5
END
GO
IF EXISTS(SELECT * FROM sys.columns WHERE Name = N'BEL_Premium_Expected_6' AND Object_ID = Object_ID(N'IFRS_Calculation_Detail_BEL'))
BEGIN
ALTER TABLE IFRS_Calculation_Detail_BEL DROP COLUMN BEL_Premium_Expected_6
END
GO
IF EXISTS(SELECT * FROM sys.columns WHERE Name = N'BEL_Premium_Expected_7' AND Object_ID = Object_ID(N'IFRS_Calculation_Detail_BEL'))
BEGIN
ALTER TABLE IFRS_Calculation_Detail_BEL DROP COLUMN BEL_Premium_Expected_7
END
GO
IF EXISTS(SELECT * FROM sys.columns WHERE Name = N'BEL_Premium_Expected_8' AND Object_ID = Object_ID(N'IFRS_Calculation_Detail_BEL'))
BEGIN
ALTER TABLE IFRS_Calculation_Detail_BEL DROP COLUMN BEL_Premium_Expected_8
END
GO
IF EXISTS(SELECT * FROM sys.columns WHERE Name = N'BEL_Premium_Expected_9' AND Object_ID = Object_ID(N'IFRS_Calculation_Detail_BEL'))
BEGIN
ALTER TABLE IFRS_Calculation_Detail_BEL DROP COLUMN BEL_Premium_Expected_9
END
GO
IF EXISTS(SELECT * FROM sys.columns WHERE Name = N'BEL_Premium_Expected_10' AND Object_ID = Object_ID(N'IFRS_Calculation_Detail_BEL'))
BEGIN
ALTER TABLE IFRS_Calculation_Detail_BEL DROP COLUMN BEL_Premium_Expected_10
END
GO
IF EXISTS(SELECT * FROM sys.columns WHERE Name = N'BEL_Premium_Expected_11' AND Object_ID = Object_ID(N'IFRS_Calculation_Detail_BEL'))
BEGIN
ALTER TABLE IFRS_Calculation_Detail_BEL DROP COLUMN BEL_Premium_Expected_11
END
GO
IF EXISTS(SELECT * FROM sys.columns WHERE Name = N'BEL_Premium_Expected_12' AND Object_ID = Object_ID(N'IFRS_Calculation_Detail_BEL'))
BEGIN
ALTER TABLE IFRS_Calculation_Detail_BEL DROP COLUMN BEL_Premium_Expected_12
END
GO
IF EXISTS(SELECT * FROM sys.columns WHERE Name = N'BEL_Premium_Expected_13' AND Object_ID = Object_ID(N'IFRS_Calculation_Detail_BEL'))
BEGIN
ALTER TABLE IFRS_Calculation_Detail_BEL DROP COLUMN BEL_Premium_Expected_13
END
GO
IF EXISTS(SELECT * FROM sys.columns WHERE Name = N'BEL_Premium_Expected_14' AND Object_ID = Object_ID(N'IFRS_Calculation_Detail_BEL'))
BEGIN
ALTER TABLE IFRS_Calculation_Detail_BEL DROP COLUMN BEL_Premium_Expected_14
END
GO
IF EXISTS(SELECT * FROM sys.columns WHERE Name = N'BEL_Premium_Expected_15' AND Object_ID = Object_ID(N'IFRS_Calculation_Detail_BEL'))
BEGIN
ALTER TABLE IFRS_Calculation_Detail_BEL DROP COLUMN BEL_Premium_Expected_15
END
GO
IF EXISTS(SELECT * FROM sys.columns WHERE Name = N'BEL_Premium_Expected_16' AND Object_ID = Object_ID(N'IFRS_Calculation_Detail_BEL'))
BEGIN
ALTER TABLE IFRS_Calculation_Detail_BEL DROP COLUMN BEL_Premium_Expected_16
END
GO
IF EXISTS(SELECT * FROM sys.columns WHERE Name = N'BEL_Premium_Expected_17' AND Object_ID = Object_ID(N'IFRS_Calculation_Detail_BEL'))
BEGIN
ALTER TABLE IFRS_Calculation_Detail_BEL DROP COLUMN BEL_Premium_Expected_17
END
GO
IF EXISTS(SELECT * FROM sys.columns WHERE Name = N'BEL_Premium_Expected_18' AND Object_ID = Object_ID(N'IFRS_Calculation_Detail_BEL'))
BEGIN
ALTER TABLE IFRS_Calculation_Detail_BEL DROP COLUMN BEL_Premium_Expected_18
END
GO
IF EXISTS(SELECT * FROM sys.columns WHERE Name = N'BEL_Premium_Expected_19' AND Object_ID = Object_ID(N'IFRS_Calculation_Detail_BEL'))
BEGIN
ALTER TABLE IFRS_Calculation_Detail_BEL DROP COLUMN BEL_Premium_Expected_19
END
GO
IF EXISTS(SELECT * FROM sys.columns WHERE Name = N'BEL_Premium_Expected_20' AND Object_ID = Object_ID(N'IFRS_Calculation_Detail_BEL'))
BEGIN
ALTER TABLE IFRS_Calculation_Detail_BEL DROP COLUMN BEL_Premium_Expected_20
END
GO
IF EXISTS(SELECT * FROM sys.columns WHERE Name = N'BEL_Premium_Expected_21' AND Object_ID = Object_ID(N'IFRS_Calculation_Detail_BEL'))
BEGIN
ALTER TABLE IFRS_Calculation_Detail_BEL DROP COLUMN BEL_Premium_Expected_21
END
GO
IF EXISTS(SELECT * FROM sys.columns WHERE Name = N'BEL_Premium_Expected_22' AND Object_ID = Object_ID(N'IFRS_Calculation_Detail_BEL'))
BEGIN
ALTER TABLE IFRS_Calculation_Detail_BEL DROP COLUMN BEL_Premium_Expected_22
END
GO
IF EXISTS(SELECT * FROM sys.columns WHERE Name = N'BEL_Premium_Expected_23' AND Object_ID = Object_ID(N'IFRS_Calculation_Detail_BEL'))
BEGIN
ALTER TABLE IFRS_Calculation_Detail_BEL DROP COLUMN BEL_Premium_Expected_23
END
GO
IF EXISTS(SELECT * FROM sys.columns WHERE Name = N'BEL_Premium_Expected_24' AND Object_ID = Object_ID(N'IFRS_Calculation_Detail_BEL'))
BEGIN
ALTER TABLE IFRS_Calculation_Detail_BEL DROP COLUMN BEL_Premium_Expected_24
END
GO
IF EXISTS(SELECT * FROM sys.columns WHERE Name = N'BEL_Premium_Expected_25' AND Object_ID = Object_ID(N'IFRS_Calculation_Detail_BEL'))
BEGIN
ALTER TABLE IFRS_Calculation_Detail_BEL DROP COLUMN BEL_Premium_Expected_25
END
GO
IF EXISTS(SELECT * FROM sys.columns WHERE Name = N'BEL_Premium_Expected_26' AND Object_ID = Object_ID(N'IFRS_Calculation_Detail_BEL'))
BEGIN
ALTER TABLE IFRS_Calculation_Detail_BEL DROP COLUMN BEL_Premium_Expected_26
END
GO
IF EXISTS(SELECT * FROM sys.columns WHERE Name = N'BEL_Premium_Expected_27' AND Object_ID = Object_ID(N'IFRS_Calculation_Detail_BEL'))
BEGIN
ALTER TABLE IFRS_Calculation_Detail_BEL DROP COLUMN BEL_Premium_Expected_27
END
GO
IF EXISTS(SELECT * FROM sys.columns WHERE Name = N'BEL_Premium_Expected_28' AND Object_ID = Object_ID(N'IFRS_Calculation_Detail_BEL'))
BEGIN
ALTER TABLE IFRS_Calculation_Detail_BEL DROP COLUMN BEL_Premium_Expected_28
END
GO
IF EXISTS(SELECT * FROM sys.columns WHERE Name = N'BEL_Premium_Expected_29' AND Object_ID = Object_ID(N'IFRS_Calculation_Detail_BEL'))
BEGIN
ALTER TABLE IFRS_Calculation_Detail_BEL DROP COLUMN BEL_Premium_Expected_29
END
GO
IF EXISTS(SELECT * FROM sys.columns WHERE Name = N'BEL_Premium_Expected_30' AND Object_ID = Object_ID(N'IFRS_Calculation_Detail_BEL'))
BEGIN
ALTER TABLE IFRS_Calculation_Detail_BEL DROP COLUMN BEL_Premium_Expected_30
END
GO

-- DROP BEL_Commision_Expected
IF EXISTS(SELECT * FROM sys.columns WHERE Name = N'BEL_Commission_Expected_1' AND Object_ID = Object_ID(N'IFRS_Calculation_Detail_BEL'))
BEGIN
ALTER TABLE IFRS_Calculation_Detail_BEL DROP COLUMN BEL_Commission_Expected_1
END
GO
IF EXISTS(SELECT * FROM sys.columns WHERE Name = N'BEL_Commission_Expected_2' AND Object_ID = Object_ID(N'IFRS_Calculation_Detail_BEL'))
BEGIN
ALTER TABLE IFRS_Calculation_Detail_BEL DROP COLUMN BEL_Commission_Expected_2
END
GO
IF EXISTS(SELECT * FROM sys.columns WHERE Name = N'BEL_Commission_Expected_3' AND Object_ID = Object_ID(N'IFRS_Calculation_Detail_BEL'))
BEGIN
ALTER TABLE IFRS_Calculation_Detail_BEL DROP COLUMN BEL_Commission_Expected_3
END
GO
IF EXISTS(SELECT * FROM sys.columns WHERE Name = N'BEL_Commission_Expected_4' AND Object_ID = Object_ID(N'IFRS_Calculation_Detail_BEL'))
BEGIN
ALTER TABLE IFRS_Calculation_Detail_BEL DROP COLUMN BEL_Commission_Expected_4
END
GO
IF EXISTS(SELECT * FROM sys.columns WHERE Name = N'BEL_Commission_Expected_5' AND Object_ID = Object_ID(N'IFRS_Calculation_Detail_BEL'))
BEGIN
ALTER TABLE IFRS_Calculation_Detail_BEL DROP COLUMN BEL_Commission_Expected_5
END
GO
IF EXISTS(SELECT * FROM sys.columns WHERE Name = N'BEL_Commission_Expected_6' AND Object_ID = Object_ID(N'IFRS_Calculation_Detail_BEL'))
BEGIN
ALTER TABLE IFRS_Calculation_Detail_BEL DROP COLUMN BEL_Commission_Expected_6
END
GO
IF EXISTS(SELECT * FROM sys.columns WHERE Name = N'BEL_Commission_Expected_7' AND Object_ID = Object_ID(N'IFRS_Calculation_Detail_BEL'))
BEGIN
ALTER TABLE IFRS_Calculation_Detail_BEL DROP COLUMN BEL_Commission_Expected_7
END
GO
IF EXISTS(SELECT * FROM sys.columns WHERE Name = N'BEL_Commission_Expected_8' AND Object_ID = Object_ID(N'IFRS_Calculation_Detail_BEL'))
BEGIN
ALTER TABLE IFRS_Calculation_Detail_BEL DROP COLUMN BEL_Commission_Expected_8
END
GO
IF EXISTS(SELECT * FROM sys.columns WHERE Name = N'BEL_Commission_Expected_9' AND Object_ID = Object_ID(N'IFRS_Calculation_Detail_BEL'))
BEGIN
ALTER TABLE IFRS_Calculation_Detail_BEL DROP COLUMN BEL_Commission_Expected_9
END
GO
IF EXISTS(SELECT * FROM sys.columns WHERE Name = N'BEL_Commission_Expected_10' AND Object_ID = Object_ID(N'IFRS_Calculation_Detail_BEL'))
BEGIN
ALTER TABLE IFRS_Calculation_Detail_BEL DROP COLUMN BEL_Commission_Expected_10
END
GO
IF EXISTS(SELECT * FROM sys.columns WHERE Name = N'BEL_Commission_Expected_11' AND Object_ID = Object_ID(N'IFRS_Calculation_Detail_BEL'))
BEGIN
ALTER TABLE IFRS_Calculation_Detail_BEL DROP COLUMN BEL_Commission_Expected_11
END
GO
IF EXISTS(SELECT * FROM sys.columns WHERE Name = N'BEL_Commission_Expected_12' AND Object_ID = Object_ID(N'IFRS_Calculation_Detail_BEL'))
BEGIN
ALTER TABLE IFRS_Calculation_Detail_BEL DROP COLUMN BEL_Commission_Expected_12
END
GO
IF EXISTS(SELECT * FROM sys.columns WHERE Name = N'BEL_Commission_Expected_13' AND Object_ID = Object_ID(N'IFRS_Calculation_Detail_BEL'))
BEGIN
ALTER TABLE IFRS_Calculation_Detail_BEL DROP COLUMN BEL_Commission_Expected_13
END
GO
IF EXISTS(SELECT * FROM sys.columns WHERE Name = N'BEL_Commission_Expected_14' AND Object_ID = Object_ID(N'IFRS_Calculation_Detail_BEL'))
BEGIN
ALTER TABLE IFRS_Calculation_Detail_BEL DROP COLUMN BEL_Commission_Expected_14
END
GO
IF EXISTS(SELECT * FROM sys.columns WHERE Name = N'BEL_Commission_Expected_15' AND Object_ID = Object_ID(N'IFRS_Calculation_Detail_BEL'))
BEGIN
ALTER TABLE IFRS_Calculation_Detail_BEL DROP COLUMN BEL_Commission_Expected_15
END
GO
IF EXISTS(SELECT * FROM sys.columns WHERE Name = N'BEL_Commission_Expected_16' AND Object_ID = Object_ID(N'IFRS_Calculation_Detail_BEL'))
BEGIN
ALTER TABLE IFRS_Calculation_Detail_BEL DROP COLUMN BEL_Commission_Expected_16
END
GO
IF EXISTS(SELECT * FROM sys.columns WHERE Name = N'BEL_Commission_Expected_17' AND Object_ID = Object_ID(N'IFRS_Calculation_Detail_BEL'))
BEGIN
ALTER TABLE IFRS_Calculation_Detail_BEL DROP COLUMN BEL_Commission_Expected_17
END
GO
IF EXISTS(SELECT * FROM sys.columns WHERE Name = N'BEL_Commission_Expected_18' AND Object_ID = Object_ID(N'IFRS_Calculation_Detail_BEL'))
BEGIN
ALTER TABLE IFRS_Calculation_Detail_BEL DROP COLUMN BEL_Commission_Expected_18
END
GO
IF EXISTS(SELECT * FROM sys.columns WHERE Name = N'BEL_Commission_Expected_19' AND Object_ID = Object_ID(N'IFRS_Calculation_Detail_BEL'))
BEGIN
ALTER TABLE IFRS_Calculation_Detail_BEL DROP COLUMN BEL_Commission_Expected_19
END
GO
IF EXISTS(SELECT * FROM sys.columns WHERE Name = N'BEL_Commission_Expected_20' AND Object_ID = Object_ID(N'IFRS_Calculation_Detail_BEL'))
BEGIN
ALTER TABLE IFRS_Calculation_Detail_BEL DROP COLUMN BEL_Commission_Expected_20
END
GO
IF EXISTS(SELECT * FROM sys.columns WHERE Name = N'BEL_Commission_Expected_21' AND Object_ID = Object_ID(N'IFRS_Calculation_Detail_BEL'))
BEGIN
ALTER TABLE IFRS_Calculation_Detail_BEL DROP COLUMN BEL_Commission_Expected_21
END
GO
IF EXISTS(SELECT * FROM sys.columns WHERE Name = N'BEL_Commission_Expected_22' AND Object_ID = Object_ID(N'IFRS_Calculation_Detail_BEL'))
BEGIN
ALTER TABLE IFRS_Calculation_Detail_BEL DROP COLUMN BEL_Commission_Expected_22
END
GO
IF EXISTS(SELECT * FROM sys.columns WHERE Name = N'BEL_Commission_Expected_23' AND Object_ID = Object_ID(N'IFRS_Calculation_Detail_BEL'))
BEGIN
ALTER TABLE IFRS_Calculation_Detail_BEL DROP COLUMN BEL_Commission_Expected_23
END
GO
IF EXISTS(SELECT * FROM sys.columns WHERE Name = N'BEL_Commission_Expected_24' AND Object_ID = Object_ID(N'IFRS_Calculation_Detail_BEL'))
BEGIN
ALTER TABLE IFRS_Calculation_Detail_BEL DROP COLUMN BEL_Commission_Expected_24
END
GO
IF EXISTS(SELECT * FROM sys.columns WHERE Name = N'BEL_Commission_Expected_25' AND Object_ID = Object_ID(N'IFRS_Calculation_Detail_BEL'))
BEGIN
ALTER TABLE IFRS_Calculation_Detail_BEL DROP COLUMN BEL_Commission_Expected_25
END
GO
IF EXISTS(SELECT * FROM sys.columns WHERE Name = N'BEL_Commission_Expected_26' AND Object_ID = Object_ID(N'IFRS_Calculation_Detail_BEL'))
BEGIN
ALTER TABLE IFRS_Calculation_Detail_BEL DROP COLUMN BEL_Commission_Expected_26
END
GO
IF EXISTS(SELECT * FROM sys.columns WHERE Name = N'BEL_Commission_Expected_27' AND Object_ID = Object_ID(N'IFRS_Calculation_Detail_BEL'))
BEGIN
ALTER TABLE IFRS_Calculation_Detail_BEL DROP COLUMN BEL_Commission_Expected_27
END
GO
IF EXISTS(SELECT * FROM sys.columns WHERE Name = N'BEL_Commission_Expected_28' AND Object_ID = Object_ID(N'IFRS_Calculation_Detail_BEL'))
BEGIN
ALTER TABLE IFRS_Calculation_Detail_BEL DROP COLUMN BEL_Commission_Expected_28
END
GO
IF EXISTS(SELECT * FROM sys.columns WHERE Name = N'BEL_Commission_Expected_29' AND Object_ID = Object_ID(N'IFRS_Calculation_Detail_BEL'))
BEGIN
ALTER TABLE IFRS_Calculation_Detail_BEL DROP COLUMN BEL_Commission_Expected_29
END
GO
IF EXISTS(SELECT * FROM sys.columns WHERE Name = N'BEL_Commission_Expected_30' AND Object_ID = Object_ID(N'IFRS_Calculation_Detail_BEL'))
BEGIN
ALTER TABLE IFRS_Calculation_Detail_BEL DROP COLUMN BEL_Commission_Expected_30
END
GO

ALTER TABLE dbo.IFRS_Calculation_Detail_BEL SET (LOCK_ESCALATION = DISABLE)
GO

-----------------------------------------------------------------------------
-- .::IFRS_Initial_Detail_BEL::.

-- DROP BEL_Premium_Expected
IF EXISTS(SELECT * FROM sys.columns WHERE Name = N'BEL_Premium_Expected_1' AND Object_ID = Object_ID(N'IFRS_Initial_Detail_BEL'))
BEGIN
ALTER TABLE IFRS_Initial_Detail_BEL DROP COLUMN BEL_Premium_Expected_1
END
GO
IF EXISTS(SELECT * FROM sys.columns WHERE Name = N'BEL_Premium_Expected_2' AND Object_ID = Object_ID(N'IFRS_Initial_Detail_BEL'))
BEGIN
ALTER TABLE IFRS_Initial_Detail_BEL DROP COLUMN BEL_Premium_Expected_2
END
GO
IF EXISTS(SELECT * FROM sys.columns WHERE Name = N'BEL_Premium_Expected_3' AND Object_ID = Object_ID(N'IFRS_Initial_Detail_BEL'))
BEGIN
ALTER TABLE IFRS_Initial_Detail_BEL DROP COLUMN BEL_Premium_Expected_3
END
GO
IF EXISTS(SELECT * FROM sys.columns WHERE Name = N'BEL_Premium_Expected_4' AND Object_ID = Object_ID(N'IFRS_Initial_Detail_BEL'))
BEGIN
ALTER TABLE IFRS_Initial_Detail_BEL DROP COLUMN BEL_Premium_Expected_4
END
GO
IF EXISTS(SELECT * FROM sys.columns WHERE Name = N'BEL_Premium_Expected_5' AND Object_ID = Object_ID(N'IFRS_Initial_Detail_BEL'))
BEGIN
ALTER TABLE IFRS_Initial_Detail_BEL DROP COLUMN BEL_Premium_Expected_5
END
GO
IF EXISTS(SELECT * FROM sys.columns WHERE Name = N'BEL_Premium_Expected_6' AND Object_ID = Object_ID(N'IFRS_Initial_Detail_BEL'))
BEGIN
ALTER TABLE IFRS_Initial_Detail_BEL DROP COLUMN BEL_Premium_Expected_6
END
GO
IF EXISTS(SELECT * FROM sys.columns WHERE Name = N'BEL_Premium_Expected_7' AND Object_ID = Object_ID(N'IFRS_Initial_Detail_BEL'))
BEGIN
ALTER TABLE IFRS_Initial_Detail_BEL DROP COLUMN BEL_Premium_Expected_7
END
GO
IF EXISTS(SELECT * FROM sys.columns WHERE Name = N'BEL_Premium_Expected_8' AND Object_ID = Object_ID(N'IFRS_Initial_Detail_BEL'))
BEGIN
ALTER TABLE IFRS_Initial_Detail_BEL DROP COLUMN BEL_Premium_Expected_8
END
GO
IF EXISTS(SELECT * FROM sys.columns WHERE Name = N'BEL_Premium_Expected_9' AND Object_ID = Object_ID(N'IFRS_Initial_Detail_BEL'))
BEGIN
ALTER TABLE IFRS_Initial_Detail_BEL DROP COLUMN BEL_Premium_Expected_9
END
GO
IF EXISTS(SELECT * FROM sys.columns WHERE Name = N'BEL_Premium_Expected_10' AND Object_ID = Object_ID(N'IFRS_Initial_Detail_BEL'))
BEGIN
ALTER TABLE IFRS_Initial_Detail_BEL DROP COLUMN BEL_Premium_Expected_10
END
GO
IF EXISTS(SELECT * FROM sys.columns WHERE Name = N'BEL_Premium_Expected_11' AND Object_ID = Object_ID(N'IFRS_Initial_Detail_BEL'))
BEGIN
ALTER TABLE IFRS_Initial_Detail_BEL DROP COLUMN BEL_Premium_Expected_11
END
GO
IF EXISTS(SELECT * FROM sys.columns WHERE Name = N'BEL_Premium_Expected_12' AND Object_ID = Object_ID(N'IFRS_Initial_Detail_BEL'))
BEGIN
ALTER TABLE IFRS_Initial_Detail_BEL DROP COLUMN BEL_Premium_Expected_12
END
GO
IF EXISTS(SELECT * FROM sys.columns WHERE Name = N'BEL_Premium_Expected_13' AND Object_ID = Object_ID(N'IFRS_Initial_Detail_BEL'))
BEGIN
ALTER TABLE IFRS_Initial_Detail_BEL DROP COLUMN BEL_Premium_Expected_13
END
GO
IF EXISTS(SELECT * FROM sys.columns WHERE Name = N'BEL_Premium_Expected_14' AND Object_ID = Object_ID(N'IFRS_Initial_Detail_BEL'))
BEGIN
ALTER TABLE IFRS_Initial_Detail_BEL DROP COLUMN BEL_Premium_Expected_14
END
GO
IF EXISTS(SELECT * FROM sys.columns WHERE Name = N'BEL_Premium_Expected_15' AND Object_ID = Object_ID(N'IFRS_Initial_Detail_BEL'))
BEGIN
ALTER TABLE IFRS_Initial_Detail_BEL DROP COLUMN BEL_Premium_Expected_15
END
GO
IF EXISTS(SELECT * FROM sys.columns WHERE Name = N'BEL_Premium_Expected_16' AND Object_ID = Object_ID(N'IFRS_Initial_Detail_BEL'))
BEGIN
ALTER TABLE IFRS_Initial_Detail_BEL DROP COLUMN BEL_Premium_Expected_16
END
GO
IF EXISTS(SELECT * FROM sys.columns WHERE Name = N'BEL_Premium_Expected_17' AND Object_ID = Object_ID(N'IFRS_Initial_Detail_BEL'))
BEGIN
ALTER TABLE IFRS_Initial_Detail_BEL DROP COLUMN BEL_Premium_Expected_17
END
GO
IF EXISTS(SELECT * FROM sys.columns WHERE Name = N'BEL_Premium_Expected_18' AND Object_ID = Object_ID(N'IFRS_Initial_Detail_BEL'))
BEGIN
ALTER TABLE IFRS_Initial_Detail_BEL DROP COLUMN BEL_Premium_Expected_18
END
GO
IF EXISTS(SELECT * FROM sys.columns WHERE Name = N'BEL_Premium_Expected_19' AND Object_ID = Object_ID(N'IFRS_Initial_Detail_BEL'))
BEGIN
ALTER TABLE IFRS_Initial_Detail_BEL DROP COLUMN BEL_Premium_Expected_19
END
GO
IF EXISTS(SELECT * FROM sys.columns WHERE Name = N'BEL_Premium_Expected_20' AND Object_ID = Object_ID(N'IFRS_Initial_Detail_BEL'))
BEGIN
ALTER TABLE IFRS_Initial_Detail_BEL DROP COLUMN BEL_Premium_Expected_20
END
GO
IF EXISTS(SELECT * FROM sys.columns WHERE Name = N'BEL_Premium_Expected_21' AND Object_ID = Object_ID(N'IFRS_Initial_Detail_BEL'))
BEGIN
ALTER TABLE IFRS_Initial_Detail_BEL DROP COLUMN BEL_Premium_Expected_21
END
GO
IF EXISTS(SELECT * FROM sys.columns WHERE Name = N'BEL_Premium_Expected_22' AND Object_ID = Object_ID(N'IFRS_Initial_Detail_BEL'))
BEGIN
ALTER TABLE IFRS_Initial_Detail_BEL DROP COLUMN BEL_Premium_Expected_22
END
GO
IF EXISTS(SELECT * FROM sys.columns WHERE Name = N'BEL_Premium_Expected_23' AND Object_ID = Object_ID(N'IFRS_Initial_Detail_BEL'))
BEGIN
ALTER TABLE IFRS_Initial_Detail_BEL DROP COLUMN BEL_Premium_Expected_23
END
GO
IF EXISTS(SELECT * FROM sys.columns WHERE Name = N'BEL_Premium_Expected_24' AND Object_ID = Object_ID(N'IFRS_Initial_Detail_BEL'))
BEGIN
ALTER TABLE IFRS_Initial_Detail_BEL DROP COLUMN BEL_Premium_Expected_24
END
GO
IF EXISTS(SELECT * FROM sys.columns WHERE Name = N'BEL_Premium_Expected_25' AND Object_ID = Object_ID(N'IFRS_Initial_Detail_BEL'))
BEGIN
ALTER TABLE IFRS_Initial_Detail_BEL DROP COLUMN BEL_Premium_Expected_25
END
GO
IF EXISTS(SELECT * FROM sys.columns WHERE Name = N'BEL_Premium_Expected_26' AND Object_ID = Object_ID(N'IFRS_Initial_Detail_BEL'))
BEGIN
ALTER TABLE IFRS_Initial_Detail_BEL DROP COLUMN BEL_Premium_Expected_26
END
GO
IF EXISTS(SELECT * FROM sys.columns WHERE Name = N'BEL_Premium_Expected_27' AND Object_ID = Object_ID(N'IFRS_Initial_Detail_BEL'))
BEGIN
ALTER TABLE IFRS_Initial_Detail_BEL DROP COLUMN BEL_Premium_Expected_27
END
GO
IF EXISTS(SELECT * FROM sys.columns WHERE Name = N'BEL_Premium_Expected_28' AND Object_ID = Object_ID(N'IFRS_Initial_Detail_BEL'))
BEGIN
ALTER TABLE IFRS_Initial_Detail_BEL DROP COLUMN BEL_Premium_Expected_28
END
GO
IF EXISTS(SELECT * FROM sys.columns WHERE Name = N'BEL_Premium_Expected_29' AND Object_ID = Object_ID(N'IFRS_Initial_Detail_BEL'))
BEGIN
ALTER TABLE IFRS_Initial_Detail_BEL DROP COLUMN BEL_Premium_Expected_29
END
GO
IF EXISTS(SELECT * FROM sys.columns WHERE Name = N'BEL_Premium_Expected_30' AND Object_ID = Object_ID(N'IFRS_Initial_Detail_BEL'))
BEGIN
ALTER TABLE IFRS_Initial_Detail_BEL DROP COLUMN BEL_Premium_Expected_30
END
GO

-- DROP BEL_Commission_Expected
IF EXISTS(SELECT * FROM sys.columns WHERE Name = N'BEL_Commission_Expected_1' AND Object_ID = Object_ID(N'IFRS_Initial_Detail_BEL'))
BEGIN
ALTER TABLE IFRS_Initial_Detail_BEL DROP COLUMN BEL_Commission_Expected_1
END
GO
IF EXISTS(SELECT * FROM sys.columns WHERE Name = N'BEL_Commission_Expected_2' AND Object_ID = Object_ID(N'IFRS_Initial_Detail_BEL'))
BEGIN
ALTER TABLE IFRS_Initial_Detail_BEL DROP COLUMN BEL_Commission_Expected_2
END
GO
IF EXISTS(SELECT * FROM sys.columns WHERE Name = N'BEL_Commission_Expected_3' AND Object_ID = Object_ID(N'IFRS_Initial_Detail_BEL'))
BEGIN
ALTER TABLE IFRS_Initial_Detail_BEL DROP COLUMN BEL_Commission_Expected_3
END
GO
IF EXISTS(SELECT * FROM sys.columns WHERE Name = N'BEL_Commission_Expected_4' AND Object_ID = Object_ID(N'IFRS_Initial_Detail_BEL'))
BEGIN
ALTER TABLE IFRS_Initial_Detail_BEL DROP COLUMN BEL_Commission_Expected_4
END
GO
IF EXISTS(SELECT * FROM sys.columns WHERE Name = N'BEL_Commission_Expected_5' AND Object_ID = Object_ID(N'IFRS_Initial_Detail_BEL'))
BEGIN
ALTER TABLE IFRS_Initial_Detail_BEL DROP COLUMN BEL_Commission_Expected_5
END
GO
IF EXISTS(SELECT * FROM sys.columns WHERE Name = N'BEL_Commission_Expected_6' AND Object_ID = Object_ID(N'IFRS_Initial_Detail_BEL'))
BEGIN
ALTER TABLE IFRS_Initial_Detail_BEL DROP COLUMN BEL_Commission_Expected_6
END
GO
IF EXISTS(SELECT * FROM sys.columns WHERE Name = N'BEL_Commission_Expected_7' AND Object_ID = Object_ID(N'IFRS_Initial_Detail_BEL'))
BEGIN
ALTER TABLE IFRS_Initial_Detail_BEL DROP COLUMN BEL_Commission_Expected_7
END
GO
IF EXISTS(SELECT * FROM sys.columns WHERE Name = N'BEL_Commission_Expected_8' AND Object_ID = Object_ID(N'IFRS_Initial_Detail_BEL'))
BEGIN
ALTER TABLE IFRS_Initial_Detail_BEL DROP COLUMN BEL_Commission_Expected_8
END
GO
IF EXISTS(SELECT * FROM sys.columns WHERE Name = N'BEL_Commission_Expected_9' AND Object_ID = Object_ID(N'IFRS_Initial_Detail_BEL'))
BEGIN
ALTER TABLE IFRS_Initial_Detail_BEL DROP COLUMN BEL_Commission_Expected_9
END
GO
IF EXISTS(SELECT * FROM sys.columns WHERE Name = N'BEL_Commission_Expected_10' AND Object_ID = Object_ID(N'IFRS_Initial_Detail_BEL'))
BEGIN
ALTER TABLE IFRS_Initial_Detail_BEL DROP COLUMN BEL_Commission_Expected_10
END
GO
IF EXISTS(SELECT * FROM sys.columns WHERE Name = N'BEL_Commission_Expected_11' AND Object_ID = Object_ID(N'IFRS_Initial_Detail_BEL'))
BEGIN
ALTER TABLE IFRS_Initial_Detail_BEL DROP COLUMN BEL_Commission_Expected_11
END
GO
IF EXISTS(SELECT * FROM sys.columns WHERE Name = N'BEL_Commission_Expected_12' AND Object_ID = Object_ID(N'IFRS_Initial_Detail_BEL'))
BEGIN
ALTER TABLE IFRS_Initial_Detail_BEL DROP COLUMN BEL_Commission_Expected_12
END
GO
IF EXISTS(SELECT * FROM sys.columns WHERE Name = N'BEL_Commission_Expected_13' AND Object_ID = Object_ID(N'IFRS_Initial_Detail_BEL'))
BEGIN
ALTER TABLE IFRS_Initial_Detail_BEL DROP COLUMN BEL_Commission_Expected_13
END
GO
IF EXISTS(SELECT * FROM sys.columns WHERE Name = N'BEL_Commission_Expected_14' AND Object_ID = Object_ID(N'IFRS_Initial_Detail_BEL'))
BEGIN
ALTER TABLE IFRS_Initial_Detail_BEL DROP COLUMN BEL_Commission_Expected_14
END
GO
IF EXISTS(SELECT * FROM sys.columns WHERE Name = N'BEL_Commission_Expected_15' AND Object_ID = Object_ID(N'IFRS_Initial_Detail_BEL'))
BEGIN
ALTER TABLE IFRS_Initial_Detail_BEL DROP COLUMN BEL_Commission_Expected_15
END
GO
IF EXISTS(SELECT * FROM sys.columns WHERE Name = N'BEL_Commission_Expected_16' AND Object_ID = Object_ID(N'IFRS_Initial_Detail_BEL'))
BEGIN
ALTER TABLE IFRS_Initial_Detail_BEL DROP COLUMN BEL_Commission_Expected_16
END
GO
IF EXISTS(SELECT * FROM sys.columns WHERE Name = N'BEL_Commission_Expected_17' AND Object_ID = Object_ID(N'IFRS_Initial_Detail_BEL'))
BEGIN
ALTER TABLE IFRS_Initial_Detail_BEL DROP COLUMN BEL_Commission_Expected_17
END
GO
IF EXISTS(SELECT * FROM sys.columns WHERE Name = N'BEL_Commission_Expected_18' AND Object_ID = Object_ID(N'IFRS_Initial_Detail_BEL'))
BEGIN
ALTER TABLE IFRS_Initial_Detail_BEL DROP COLUMN BEL_Commission_Expected_18
END
GO
IF EXISTS(SELECT * FROM sys.columns WHERE Name = N'BEL_Commission_Expected_19' AND Object_ID = Object_ID(N'IFRS_Initial_Detail_BEL'))
BEGIN
ALTER TABLE IFRS_Initial_Detail_BEL DROP COLUMN BEL_Commission_Expected_19
END
GO
IF EXISTS(SELECT * FROM sys.columns WHERE Name = N'BEL_Commission_Expected_20' AND Object_ID = Object_ID(N'IFRS_Initial_Detail_BEL'))
BEGIN
ALTER TABLE IFRS_Initial_Detail_BEL DROP COLUMN BEL_Commission_Expected_20
END
GO
IF EXISTS(SELECT * FROM sys.columns WHERE Name = N'BEL_Commission_Expected_21' AND Object_ID = Object_ID(N'IFRS_Initial_Detail_BEL'))
BEGIN
ALTER TABLE IFRS_Initial_Detail_BEL DROP COLUMN BEL_Commission_Expected_21
END
GO
IF EXISTS(SELECT * FROM sys.columns WHERE Name = N'BEL_Commission_Expected_22' AND Object_ID = Object_ID(N'IFRS_Initial_Detail_BEL'))
BEGIN
ALTER TABLE IFRS_Initial_Detail_BEL DROP COLUMN BEL_Commission_Expected_22
END
GO
IF EXISTS(SELECT * FROM sys.columns WHERE Name = N'BEL_Commission_Expected_23' AND Object_ID = Object_ID(N'IFRS_Initial_Detail_BEL'))
BEGIN
ALTER TABLE IFRS_Initial_Detail_BEL DROP COLUMN BEL_Commission_Expected_23
END
GO
IF EXISTS(SELECT * FROM sys.columns WHERE Name = N'BEL_Commission_Expected_24' AND Object_ID = Object_ID(N'IFRS_Initial_Detail_BEL'))
BEGIN
ALTER TABLE IFRS_Initial_Detail_BEL DROP COLUMN BEL_Commission_Expected_24
END
GO
IF EXISTS(SELECT * FROM sys.columns WHERE Name = N'BEL_Commission_Expected_25' AND Object_ID = Object_ID(N'IFRS_Initial_Detail_BEL'))
BEGIN
ALTER TABLE IFRS_Initial_Detail_BEL DROP COLUMN BEL_Commission_Expected_25
END
GO
IF EXISTS(SELECT * FROM sys.columns WHERE Name = N'BEL_Commission_Expected_26' AND Object_ID = Object_ID(N'IFRS_Initial_Detail_BEL'))
BEGIN
ALTER TABLE IFRS_Initial_Detail_BEL DROP COLUMN BEL_Commission_Expected_26
END
GO
IF EXISTS(SELECT * FROM sys.columns WHERE Name = N'BEL_Commission_Expected_27' AND Object_ID = Object_ID(N'IFRS_Initial_Detail_BEL'))
BEGIN
ALTER TABLE IFRS_Initial_Detail_BEL DROP COLUMN BEL_Commission_Expected_27
END
GO
IF EXISTS(SELECT * FROM sys.columns WHERE Name = N'BEL_Commission_Expected_28' AND Object_ID = Object_ID(N'IFRS_Initial_Detail_BEL'))
BEGIN
ALTER TABLE IFRS_Initial_Detail_BEL DROP COLUMN BEL_Commission_Expected_28
END
GO
IF EXISTS(SELECT * FROM sys.columns WHERE Name = N'BEL_Commission_Expected_29' AND Object_ID = Object_ID(N'IFRS_Initial_Detail_BEL'))
BEGIN
ALTER TABLE IFRS_Initial_Detail_BEL DROP COLUMN BEL_Commission_Expected_29
END
GO
IF EXISTS(SELECT * FROM sys.columns WHERE Name = N'BEL_Commission_Expected_30' AND Object_ID = Object_ID(N'IFRS_Initial_Detail_BEL'))
BEGIN
ALTER TABLE IFRS_Initial_Detail_BEL DROP COLUMN BEL_Commission_Expected_30
END
GO

ALTER TABLE dbo.IFRS_Initial_Detail_BEL SET (LOCK_ESCALATION = DISABLE)
GO

 insert into PatchVersioning
select '920 Update Script - IFRS Patch #44',GETDATE()
go

