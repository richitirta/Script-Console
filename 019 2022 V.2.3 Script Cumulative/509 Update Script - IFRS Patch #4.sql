/* To prevent any potential data loss issues, you should review this script in detail before running it outside the context of the database designer.*/
BEGIN TRANSACTION
SET QUOTED_IDENTIFIER ON
SET ARITHABORT ON
SET NUMERIC_ROUNDABORT OFF
SET CONCAT_NULL_YIELDS_NULL ON
SET ANSI_NULLS ON
SET ANSI_PADDING ON
SET ANSI_WARNINGS ON
COMMIT
BEGIN TRANSACTION
GO
ALTER TABLE dbo.IFRS_Initial ADD
	Inflation_Rate_1 float(53) NULL,
	Inflation_Rate_2 float(53) NULL,
	Inflation_Rate_3 float(53) NULL,
	Inflation_Rate_4 float(53) NULL,
	Inflation_Rate_5 float(53) NULL,
	Inflation_Rate_6 float(53) NULL,
	Inflation_Rate_7 float(53) NULL,
	Inflation_Rate_8 float(53) NULL,
	Inflation_Rate_9 float(53) NULL,
	Inflation_Rate_10 float(53) NULL,
	Inflation_Rate_11 float(53) NULL,
	Inflation_Rate_12 float(53) NULL,
	Inflation_Rate_13 float(53) NULL,
	Inflation_Rate_14 float(53) NULL,
	Inflation_Rate_15 float(53) NULL,
	Inflation_Rate_16 float(53) NULL,
	Inflation_Rate_17 float(53) NULL,
	Inflation_Rate_18 float(53) NULL,
	Inflation_Rate_19 float(53) NULL,
	Inflation_Rate_20 float(53) NULL,
	Inflation_Rate_21 float(53) NULL,
	Inflation_Rate_22 float(53) NULL,
	Inflation_Rate_23 float(53) NULL,
	Inflation_Rate_24 float(53) NULL,
	Inflation_Rate_25 float(53) NULL,
	Inflation_Rate_26 float(53) NULL,
	Inflation_Rate_27 float(53) NULL,
	Inflation_Rate_28 float(53) NULL,
	Inflation_Rate_29 float(53) NULL,
	Inflation_Rate_30 float(53) NULL
GO
ALTER TABLE dbo.IFRS_CALCULATION ADD
	Inflation_Rate_1 float(53) NULL,
	Inflation_Rate_2 float(53) NULL,
	Inflation_Rate_3 float(53) NULL,
	Inflation_Rate_4 float(53) NULL,
	Inflation_Rate_5 float(53) NULL,
	Inflation_Rate_6 float(53) NULL,
	Inflation_Rate_7 float(53) NULL,
	Inflation_Rate_8 float(53) NULL,
	Inflation_Rate_9 float(53) NULL,
	Inflation_Rate_10 float(53) NULL,
	Inflation_Rate_11 float(53) NULL,
	Inflation_Rate_12 float(53) NULL,
	Inflation_Rate_13 float(53) NULL,
	Inflation_Rate_14 float(53) NULL,
	Inflation_Rate_15 float(53) NULL,
	Inflation_Rate_16 float(53) NULL,
	Inflation_Rate_17 float(53) NULL,
	Inflation_Rate_18 float(53) NULL,
	Inflation_Rate_19 float(53) NULL,
	Inflation_Rate_20 float(53) NULL,
	Inflation_Rate_21 float(53) NULL,
	Inflation_Rate_22 float(53) NULL,
	Inflation_Rate_23 float(53) NULL,
	Inflation_Rate_24 float(53) NULL,
	Inflation_Rate_25 float(53) NULL,
	Inflation_Rate_26 float(53) NULL,
	Inflation_Rate_27 float(53) NULL,
	Inflation_Rate_28 float(53) NULL,
	Inflation_Rate_29 float(53) NULL,
	Inflation_Rate_30 float(53) NULL
GO
ALTER TABLE dbo.IFRS_Initial_Detail_BEL ADD
	BEL_Refund_Expected_1 float(53) NULL,
	BEL_Refund_Expected_2 float(53) NULL,
	BEL_Refund_Expected_3 float(53) NULL,
	BEL_Refund_Expected_4 float(53) NULL,
	BEL_Refund_Expected_5 float(53) NULL,
	BEL_Refund_Expected_6 float(53) NULL,
	BEL_Refund_Expected_7 float(53) NULL,
	BEL_Refund_Expected_8 float(53) NULL,
	BEL_Refund_Expected_9 float(53) NULL,
	BEL_Refund_Expected_10 float(53) NULL,
	BEL_Refund_Expected_11 float(53) NULL,
	BEL_Refund_Expected_12 float(53) NULL,
	BEL_Refund_Expected_13 float(53) NULL,
	BEL_Refund_Expected_14 float(53) NULL,
	BEL_Refund_Expected_15 float(53) NULL,
	BEL_Refund_Expected_16 float(53) NULL,
	BEL_Refund_Expected_17 float(53) NULL,
	BEL_Refund_Expected_18 float(53) NULL,
	BEL_Refund_Expected_19 float(53) NULL,
	BEL_Refund_Expected_20 float(53) NULL,
	BEL_Refund_Expected_21 float(53) NULL,
	BEL_Refund_Expected_22 float(53) NULL,
	BEL_Refund_Expected_23 float(53) NULL,
	BEL_Refund_Expected_24 float(53) NULL,
	BEL_Refund_Expected_25 float(53) NULL,
	BEL_Refund_Expected_26 float(53) NULL,
	BEL_Refund_Expected_27 float(53) NULL,
	BEL_Refund_Expected_28 float(53) NULL,
	BEL_Refund_Expected_29 float(53) NULL,
	BEL_Refund_Expected_30 float(53) NULL
GO
ALTER TABLE dbo.IFRS_CALCULATION_DETAIL_BEL ADD
	BEL_Refund_Expected_1 float(53) NULL,
	BEL_Refund_Expected_2 float(53) NULL,
	BEL_Refund_Expected_3 float(53) NULL,
	BEL_Refund_Expected_4 float(53) NULL,
	BEL_Refund_Expected_5 float(53) NULL,
	BEL_Refund_Expected_6 float(53) NULL,
	BEL_Refund_Expected_7 float(53) NULL,
	BEL_Refund_Expected_8 float(53) NULL,
	BEL_Refund_Expected_9 float(53) NULL,
	BEL_Refund_Expected_10 float(53) NULL,
	BEL_Refund_Expected_11 float(53) NULL,
	BEL_Refund_Expected_12 float(53) NULL,
	BEL_Refund_Expected_13 float(53) NULL,
	BEL_Refund_Expected_14 float(53) NULL,
	BEL_Refund_Expected_15 float(53) NULL,
	BEL_Refund_Expected_16 float(53) NULL,
	BEL_Refund_Expected_17 float(53) NULL,
	BEL_Refund_Expected_18 float(53) NULL,
	BEL_Refund_Expected_19 float(53) NULL,
	BEL_Refund_Expected_20 float(53) NULL,
	BEL_Refund_Expected_21 float(53) NULL,
	BEL_Refund_Expected_22 float(53) NULL,
	BEL_Refund_Expected_23 float(53) NULL,
	BEL_Refund_Expected_24 float(53) NULL,
	BEL_Refund_Expected_25 float(53) NULL,
	BEL_Refund_Expected_26 float(53) NULL,
	BEL_Refund_Expected_27 float(53) NULL,
	BEL_Refund_Expected_28 float(53) NULL,
	BEL_Refund_Expected_29 float(53) NULL,
	BEL_Refund_Expected_30 float(53) NULL
GO
ALTER TABLE dbo.IFRS_Initial_Detail_LOSS ADD
	LOSS_Portion_from_Refund_Release_1 float(53) NULL,
	LOSS_Portion_from_Refund_Release_2 float(53) NULL,
	LOSS_Portion_from_Refund_Release_3 float(53) NULL,
	LOSS_Portion_from_Refund_Release_4 float(53) NULL,
	LOSS_Portion_from_Refund_Release_5 float(53) NULL,
	LOSS_Portion_from_Refund_Release_6 float(53) NULL,
	LOSS_Portion_from_Refund_Release_7 float(53) NULL,
	LOSS_Portion_from_Refund_Release_8 float(53) NULL,
	LOSS_Portion_from_Refund_Release_9 float(53) NULL,
	LOSS_Portion_from_Refund_Release_10 float(53) NULL,
	LOSS_Portion_from_Refund_Release_11 float(53) NULL,
	LOSS_Portion_from_Refund_Release_12 float(53) NULL,
	LOSS_Portion_from_Refund_Release_13 float(53) NULL,
	LOSS_Portion_from_Refund_Release_14 float(53) NULL,
	LOSS_Portion_from_Refund_Release_15 float(53) NULL,
	LOSS_Portion_from_Refund_Release_16 float(53) NULL,
	LOSS_Portion_from_Refund_Release_17 float(53) NULL,
	LOSS_Portion_from_Refund_Release_18 float(53) NULL,
	LOSS_Portion_from_Refund_Release_19 float(53) NULL,
	LOSS_Portion_from_Refund_Release_20 float(53) NULL,
	LOSS_Portion_from_Refund_Release_21 float(53) NULL,
	LOSS_Portion_from_Refund_Release_22 float(53) NULL,
	LOSS_Portion_from_Refund_Release_23 float(53) NULL,
	LOSS_Portion_from_Refund_Release_24 float(53) NULL,
	LOSS_Portion_from_Refund_Release_25 float(53) NULL,
	LOSS_Portion_from_Refund_Release_26 float(53) NULL,
	LOSS_Portion_from_Refund_Release_27 float(53) NULL,
	LOSS_Portion_from_Refund_Release_28 float(53) NULL,
	LOSS_Portion_from_Refund_Release_29 float(53) NULL,
	LOSS_Portion_from_Refund_Release_30 float(53) NULL
GO
ALTER TABLE dbo.IFRS_CALCULATION_DETAIL_LOSS ADD
	LOSS_Portion_from_Refund_Release_1 float(53) NULL,
	LOSS_Portion_from_Refund_Release_2 float(53) NULL,
	LOSS_Portion_from_Refund_Release_3 float(53) NULL,
	LOSS_Portion_from_Refund_Release_4 float(53) NULL,
	LOSS_Portion_from_Refund_Release_5 float(53) NULL,
	LOSS_Portion_from_Refund_Release_6 float(53) NULL,
	LOSS_Portion_from_Refund_Release_7 float(53) NULL,
	LOSS_Portion_from_Refund_Release_8 float(53) NULL,
	LOSS_Portion_from_Refund_Release_9 float(53) NULL,
	LOSS_Portion_from_Refund_Release_10 float(53) NULL,
	LOSS_Portion_from_Refund_Release_11 float(53) NULL,
	LOSS_Portion_from_Refund_Release_12 float(53) NULL,
	LOSS_Portion_from_Refund_Release_13 float(53) NULL,
	LOSS_Portion_from_Refund_Release_14 float(53) NULL,
	LOSS_Portion_from_Refund_Release_15 float(53) NULL,
	LOSS_Portion_from_Refund_Release_16 float(53) NULL,
	LOSS_Portion_from_Refund_Release_17 float(53) NULL,
	LOSS_Portion_from_Refund_Release_18 float(53) NULL,
	LOSS_Portion_from_Refund_Release_19 float(53) NULL,
	LOSS_Portion_from_Refund_Release_20 float(53) NULL,
	LOSS_Portion_from_Refund_Release_21 float(53) NULL,
	LOSS_Portion_from_Refund_Release_22 float(53) NULL,
	LOSS_Portion_from_Refund_Release_23 float(53) NULL,
	LOSS_Portion_from_Refund_Release_24 float(53) NULL,
	LOSS_Portion_from_Refund_Release_25 float(53) NULL,
	LOSS_Portion_from_Refund_Release_26 float(53) NULL,
	LOSS_Portion_from_Refund_Release_27 float(53) NULL,
	LOSS_Portion_from_Refund_Release_28 float(53) NULL,
	LOSS_Portion_from_Refund_Release_29 float(53) NULL,
	LOSS_Portion_from_Refund_Release_30 float(53) NULL
GO
ALTER TABLE dbo.IFRS_Initial_Detail ADD
	Premium_Expected float(53) NULL,
	Commission_Expected float(53) NULL
GO
ALTER TABLE dbo.IFRS_Calculation_Detail ADD
	Premium_Expected float(53) NULL,
	Commission_Expected float(53) NULL
GO
ALTER TABLE dbo.IFRS_Movement ADD
	BEL_Refund_Expected float(53) NULL,
	Loss_Portion_from_Refund_Release float(53) NULL
GO


COMMIT

 insert into PatchVersioning
select '509 Update Script - IFRS Patch #4',GETDATE()
go
