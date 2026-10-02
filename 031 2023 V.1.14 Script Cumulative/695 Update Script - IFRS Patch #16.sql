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
ALTER TABLE dbo.IFRS_Initial_Detail_BEL ADD
	BEL_Claim_Expected_Monthly_1 float(53) NULL,
	BEL_Claim_Expected_Monthly_2 float(53) NULL,
	BEL_Claim_Expected_Monthly_3 float(53) NULL,
	BEL_Claim_Expected_Monthly_4 float(53) NULL,
	BEL_Claim_Expected_Monthly_5 float(53) NULL,
	BEL_Claim_Expected_Monthly_6 float(53) NULL,
	BEL_Claim_Expected_Monthly_7 float(53) NULL,
	BEL_Claim_Expected_Monthly_8 float(53) NULL,
	BEL_Claim_Expected_Monthly_9 float(53) NULL,
	BEL_Claim_Expected_Monthly_10 float(53) NULL,
	BEL_Claim_Expected_Monthly_11 float(53) NULL,
	BEL_Claim_Expected_Monthly_12 float(53) NULL,
	BEL_Claim_Expected_Monthly_13 float(53) NULL,
	BEL_Claim_Expected_Monthly_14 float(53) NULL,
	BEL_Claim_Expected_Monthly_15 float(53) NULL,
	BEL_Claim_Expected_Monthly_16 float(53) NULL,
	BEL_Claim_Expected_Monthly_17 float(53) NULL,
	BEL_Claim_Expected_Monthly_18 float(53) NULL,
	BEL_Claim_Expected_Monthly_19 float(53) NULL,
	BEL_Claim_Expected_Monthly_20 float(53) NULL,
	BEL_Claim_Expected_Monthly_21 float(53) NULL,
	BEL_Claim_Expected_Monthly_22 float(53) NULL,
	BEL_Claim_Expected_Monthly_23 float(53) NULL,
	BEL_Claim_Expected_Monthly_24 float(53) NULL,
	BEL_Claim_Expected_Monthly_25 float(53) NULL,
	BEL_Claim_Expected_Monthly_26 float(53) NULL,
	BEL_Claim_Expected_Monthly_27 float(53) NULL,
	BEL_Claim_Expected_Monthly_28 float(53) NULL,
	BEL_Claim_Expected_Monthly_29 float(53) NULL,
	BEL_Claim_Expected_Monthly_30 float(53) NULL,
	BEL_Expense_Expected_Monthly_1 float(53) NULL,
	BEL_Expense_Expected_Monthly_2 float(53) NULL,
	BEL_Expense_Expected_Monthly_3 float(53) NULL,
	BEL_Expense_Expected_Monthly_4 float(53) NULL,
	BEL_Expense_Expected_Monthly_5 float(53) NULL,
	BEL_Expense_Expected_Monthly_6 float(53) NULL,
	BEL_Expense_Expected_Monthly_7 float(53) NULL,
	BEL_Expense_Expected_Monthly_8 float(53) NULL,
	BEL_Expense_Expected_Monthly_9 float(53) NULL,
	BEL_Expense_Expected_Monthly_10 float(53) NULL,
	BEL_Expense_Expected_Monthly_11 float(53) NULL,
	BEL_Expense_Expected_Monthly_12 float(53) NULL,
	BEL_Expense_Expected_Monthly_13 float(53) NULL,
	BEL_Expense_Expected_Monthly_14 float(53) NULL,
	BEL_Expense_Expected_Monthly_15 float(53) NULL,
	BEL_Expense_Expected_Monthly_16 float(53) NULL,
	BEL_Expense_Expected_Monthly_17 float(53) NULL,
	BEL_Expense_Expected_Monthly_18 float(53) NULL,
	BEL_Expense_Expected_Monthly_19 float(53) NULL,
	BEL_Expense_Expected_Monthly_20 float(53) NULL,
	BEL_Expense_Expected_Monthly_21 float(53) NULL,
	BEL_Expense_Expected_Monthly_22 float(53) NULL,
	BEL_Expense_Expected_Monthly_23 float(53) NULL,
	BEL_Expense_Expected_Monthly_24 float(53) NULL,
	BEL_Expense_Expected_Monthly_25 float(53) NULL,
	BEL_Expense_Expected_Monthly_26 float(53) NULL,
	BEL_Expense_Expected_Monthly_27 float(53) NULL,
	BEL_Expense_Expected_Monthly_28 float(53) NULL,
	BEL_Expense_Expected_Monthly_29 float(53) NULL,
	BEL_Expense_Expected_Monthly_30 float(53) NULL,
	BEL_Refund_Expected_Monthly_1 float(53) NULL,
	BEL_Refund_Expected_Monthly_2 float(53) NULL,
	BEL_Refund_Expected_Monthly_3 float(53) NULL,
	BEL_Refund_Expected_Monthly_4 float(53) NULL,
	BEL_Refund_Expected_Monthly_5 float(53) NULL,
	BEL_Refund_Expected_Monthly_6 float(53) NULL,
	BEL_Refund_Expected_Monthly_7 float(53) NULL,
	BEL_Refund_Expected_Monthly_8 float(53) NULL,
	BEL_Refund_Expected_Monthly_9 float(53) NULL,
	BEL_Refund_Expected_Monthly_10 float(53) NULL,
	BEL_Refund_Expected_Monthly_11 float(53) NULL,
	BEL_Refund_Expected_Monthly_12 float(53) NULL,
	BEL_Refund_Expected_Monthly_13 float(53) NULL,
	BEL_Refund_Expected_Monthly_14 float(53) NULL,
	BEL_Refund_Expected_Monthly_15 float(53) NULL,
	BEL_Refund_Expected_Monthly_16 float(53) NULL,
	BEL_Refund_Expected_Monthly_17 float(53) NULL,
	BEL_Refund_Expected_Monthly_18 float(53) NULL,
	BEL_Refund_Expected_Monthly_19 float(53) NULL,
	BEL_Refund_Expected_Monthly_20 float(53) NULL,
	BEL_Refund_Expected_Monthly_21 float(53) NULL,
	BEL_Refund_Expected_Monthly_22 float(53) NULL,
	BEL_Refund_Expected_Monthly_23 float(53) NULL,
	BEL_Refund_Expected_Monthly_24 float(53) NULL,
	BEL_Refund_Expected_Monthly_25 float(53) NULL,
	BEL_Refund_Expected_Monthly_26 float(53) NULL,
	BEL_Refund_Expected_Monthly_27 float(53) NULL,
	BEL_Refund_Expected_Monthly_28 float(53) NULL,
	BEL_Refund_Expected_Monthly_29 float(53) NULL,
	BEL_Refund_Expected_Monthly_30 float(53) NULL
GO


ALTER TABLE dbo.IFRS_Initial_Detail_RA ADD
	RA_Release_Monthly_1 float(53) NULL,
	RA_Release_Monthly_2 float(53) NULL,
	RA_Release_Monthly_3 float(53) NULL,
	RA_Release_Monthly_4 float(53) NULL,
	RA_Release_Monthly_5 float(53) NULL,
	RA_Release_Monthly_6 float(53) NULL,
	RA_Release_Monthly_7 float(53) NULL,
	RA_Release_Monthly_8 float(53) NULL,
	RA_Release_Monthly_9 float(53) NULL,
	RA_Release_Monthly_10 float(53) NULL,
	RA_Release_Monthly_11 float(53) NULL,
	RA_Release_Monthly_12 float(53) NULL,
	RA_Release_Monthly_13 float(53) NULL,
	RA_Release_Monthly_14 float(53) NULL,
	RA_Release_Monthly_15 float(53) NULL,
	RA_Release_Monthly_16 float(53) NULL,
	RA_Release_Monthly_17 float(53) NULL,
	RA_Release_Monthly_18 float(53) NULL,
	RA_Release_Monthly_19 float(53) NULL,
	RA_Release_Monthly_20 float(53) NULL,
	RA_Release_Monthly_21 float(53) NULL,
	RA_Release_Monthly_22 float(53) NULL,
	RA_Release_Monthly_23 float(53) NULL,
	RA_Release_Monthly_24 float(53) NULL,
	RA_Release_Monthly_25 float(53) NULL,
	RA_Release_Monthly_26 float(53) NULL,
	RA_Release_Monthly_27 float(53) NULL,
	RA_Release_Monthly_28 float(53) NULL,
	RA_Release_Monthly_29 float(53) NULL,
	RA_Release_Monthly_30 float(53) NULL
GO

ALTER TABLE dbo.IFRS_Initial_Detail  ADD
	Premium_Actual_BC float(53) NULL,
	Commission_Actual_BC float(53) NULL

GO

ALTER TABLE dbo.IFRS_Calculation_Detail ADD
	Premium_Actual float(53) NULL,
	Commission_Actual float(53) NULL,
	Premium_Actual_BC float(53) NULL,
	Commission_Actual_BC float(53) NULL

GO


ALTER TABLE dbo.IFRS_Calculation_Detail_BEL ADD
	BEL_Claim_Expected_Monthly_1 float(53) NULL,
	BEL_Claim_Expected_Monthly_2 float(53) NULL,
	BEL_Claim_Expected_Monthly_3 float(53) NULL,
	BEL_Claim_Expected_Monthly_4 float(53) NULL,
	BEL_Claim_Expected_Monthly_5 float(53) NULL,
	BEL_Claim_Expected_Monthly_6 float(53) NULL,
	BEL_Claim_Expected_Monthly_7 float(53) NULL,
	BEL_Claim_Expected_Monthly_8 float(53) NULL,
	BEL_Claim_Expected_Monthly_9 float(53) NULL,
	BEL_Claim_Expected_Monthly_10 float(53) NULL,
	BEL_Claim_Expected_Monthly_11 float(53) NULL,
	BEL_Claim_Expected_Monthly_12 float(53) NULL,
	BEL_Claim_Expected_Monthly_13 float(53) NULL,
	BEL_Claim_Expected_Monthly_14 float(53) NULL,
	BEL_Claim_Expected_Monthly_15 float(53) NULL,
	BEL_Claim_Expected_Monthly_16 float(53) NULL,
	BEL_Claim_Expected_Monthly_17 float(53) NULL,
	BEL_Claim_Expected_Monthly_18 float(53) NULL,
	BEL_Claim_Expected_Monthly_19 float(53) NULL,
	BEL_Claim_Expected_Monthly_20 float(53) NULL,
	BEL_Claim_Expected_Monthly_21 float(53) NULL,
	BEL_Claim_Expected_Monthly_22 float(53) NULL,
	BEL_Claim_Expected_Monthly_23 float(53) NULL,
	BEL_Claim_Expected_Monthly_24 float(53) NULL,
	BEL_Claim_Expected_Monthly_25 float(53) NULL,
	BEL_Claim_Expected_Monthly_26 float(53) NULL,
	BEL_Claim_Expected_Monthly_27 float(53) NULL,
	BEL_Claim_Expected_Monthly_28 float(53) NULL,
	BEL_Claim_Expected_Monthly_29 float(53) NULL,
	BEL_Claim_Expected_Monthly_30 float(53) NULL,
	BEL_Expense_Expected_Monthly_1 float(53) NULL,
	BEL_Expense_Expected_Monthly_2 float(53) NULL,
	BEL_Expense_Expected_Monthly_3 float(53) NULL,
	BEL_Expense_Expected_Monthly_4 float(53) NULL,
	BEL_Expense_Expected_Monthly_5 float(53) NULL,
	BEL_Expense_Expected_Monthly_6 float(53) NULL,
	BEL_Expense_Expected_Monthly_7 float(53) NULL,
	BEL_Expense_Expected_Monthly_8 float(53) NULL,
	BEL_Expense_Expected_Monthly_9 float(53) NULL,
	BEL_Expense_Expected_Monthly_10 float(53) NULL,
	BEL_Expense_Expected_Monthly_11 float(53) NULL,
	BEL_Expense_Expected_Monthly_12 float(53) NULL,
	BEL_Expense_Expected_Monthly_13 float(53) NULL,
	BEL_Expense_Expected_Monthly_14 float(53) NULL,
	BEL_Expense_Expected_Monthly_15 float(53) NULL,
	BEL_Expense_Expected_Monthly_16 float(53) NULL,
	BEL_Expense_Expected_Monthly_17 float(53) NULL,
	BEL_Expense_Expected_Monthly_18 float(53) NULL,
	BEL_Expense_Expected_Monthly_19 float(53) NULL,
	BEL_Expense_Expected_Monthly_20 float(53) NULL,
	BEL_Expense_Expected_Monthly_21 float(53) NULL,
	BEL_Expense_Expected_Monthly_22 float(53) NULL,
	BEL_Expense_Expected_Monthly_23 float(53) NULL,
	BEL_Expense_Expected_Monthly_24 float(53) NULL,
	BEL_Expense_Expected_Monthly_25 float(53) NULL,
	BEL_Expense_Expected_Monthly_26 float(53) NULL,
	BEL_Expense_Expected_Monthly_27 float(53) NULL,
	BEL_Expense_Expected_Monthly_28 float(53) NULL,
	BEL_Expense_Expected_Monthly_29 float(53) NULL,
	BEL_Expense_Expected_Monthly_30 float(53) NULL,
	BEL_Refund_Expected_Monthly_1 float(53) NULL,
	BEL_Refund_Expected_Monthly_2 float(53) NULL,
	BEL_Refund_Expected_Monthly_3 float(53) NULL,
	BEL_Refund_Expected_Monthly_4 float(53) NULL,
	BEL_Refund_Expected_Monthly_5 float(53) NULL,
	BEL_Refund_Expected_Monthly_6 float(53) NULL,
	BEL_Refund_Expected_Monthly_7 float(53) NULL,
	BEL_Refund_Expected_Monthly_8 float(53) NULL,
	BEL_Refund_Expected_Monthly_9 float(53) NULL,
	BEL_Refund_Expected_Monthly_10 float(53) NULL,
	BEL_Refund_Expected_Monthly_11 float(53) NULL,
	BEL_Refund_Expected_Monthly_12 float(53) NULL,
	BEL_Refund_Expected_Monthly_13 float(53) NULL,
	BEL_Refund_Expected_Monthly_14 float(53) NULL,
	BEL_Refund_Expected_Monthly_15 float(53) NULL,
	BEL_Refund_Expected_Monthly_16 float(53) NULL,
	BEL_Refund_Expected_Monthly_17 float(53) NULL,
	BEL_Refund_Expected_Monthly_18 float(53) NULL,
	BEL_Refund_Expected_Monthly_19 float(53) NULL,
	BEL_Refund_Expected_Monthly_20 float(53) NULL,
	BEL_Refund_Expected_Monthly_21 float(53) NULL,
	BEL_Refund_Expected_Monthly_22 float(53) NULL,
	BEL_Refund_Expected_Monthly_23 float(53) NULL,
	BEL_Refund_Expected_Monthly_24 float(53) NULL,
	BEL_Refund_Expected_Monthly_25 float(53) NULL,
	BEL_Refund_Expected_Monthly_26 float(53) NULL,
	BEL_Refund_Expected_Monthly_27 float(53) NULL,
	BEL_Refund_Expected_Monthly_28 float(53) NULL,
	BEL_Refund_Expected_Monthly_29 float(53) NULL,
	BEL_Refund_Expected_Monthly_30 float(53) NULL
GO


ALTER TABLE dbo.IFRS_Calculation_Detail_RA ADD
	RA_Release_Monthly_1 float(53) NULL,
	RA_Release_Monthly_2 float(53) NULL,
	RA_Release_Monthly_3 float(53) NULL,
	RA_Release_Monthly_4 float(53) NULL,
	RA_Release_Monthly_5 float(53) NULL,
	RA_Release_Monthly_6 float(53) NULL,
	RA_Release_Monthly_7 float(53) NULL,
	RA_Release_Monthly_8 float(53) NULL,
	RA_Release_Monthly_9 float(53) NULL,
	RA_Release_Monthly_10 float(53) NULL,
	RA_Release_Monthly_11 float(53) NULL,
	RA_Release_Monthly_12 float(53) NULL,
	RA_Release_Monthly_13 float(53) NULL,
	RA_Release_Monthly_14 float(53) NULL,
	RA_Release_Monthly_15 float(53) NULL,
	RA_Release_Monthly_16 float(53) NULL,
	RA_Release_Monthly_17 float(53) NULL,
	RA_Release_Monthly_18 float(53) NULL,
	RA_Release_Monthly_19 float(53) NULL,
	RA_Release_Monthly_20 float(53) NULL,
	RA_Release_Monthly_21 float(53) NULL,
	RA_Release_Monthly_22 float(53) NULL,
	RA_Release_Monthly_23 float(53) NULL,
	RA_Release_Monthly_24 float(53) NULL,
	RA_Release_Monthly_25 float(53) NULL,
	RA_Release_Monthly_26 float(53) NULL,
	RA_Release_Monthly_27 float(53) NULL,
	RA_Release_Monthly_28 float(53) NULL,
	RA_Release_Monthly_29 float(53) NULL,
	RA_Release_Monthly_30 float(53) NULL
GO


COMMIT

GO



Drop Function IFRS_Movement_PROCESS

GO

Create FUNCTION IFRS_Movement_PROCESS(@P_Type varchar(2),@P_Date smalldatetime, @P_PEDate smalldatetime,@P_EDate smalldatetime)            
RETURNS @IFRS TABLE (GroupID Int, Branch varchar(10), DocNo varchar(50), RefNo varchar(50), Date smalldatetime, Code varchar(10), Type varchar(10), Currency varchar(10), Subject varchar(10), Remarks varchar(255),
Amount_1 Float, Amount_2 Float, Amount_3 Float, Amount_4 Float,Amount_5 Float, Amount_6 Float, Amount_7 Float, Amount_8 Float, Amount_9 Float, Amount_10 Float, 
Amount_11 Float, Amount_12 Float, Amount_13 Float, Amount_14 Float, Amount_15 Float, Amount_16 Float, Amount_17 Float, Amount_18 Float, Amount_19 Float, Amount_20 Float, 
Amount_21 Float, Amount_22 Float, Amount_23 Float, Amount_24 Float, Amount_25 Float, Amount_26 Float, Amount_27 Float, Amount_28 Float, Amount_29 Float)
AS
BEGIN

Declare @IFRS_Data TABLE (GroupID Int, Branch varchar(10), DocNo varchar(50), RefNo varchar(50), Date smalldatetime, Code varchar(10), Type varchar(10), Currency varchar(10), Subject varchar(10), Remarks varchar(255),
Amount_1 Float, Amount_2 Float, Amount_3 Float, Amount_4 Float,Amount_5 Float, Amount_6 Float, Amount_7 Float, Amount_8 Float, Amount_9 Float, Amount_10 Float, 
Amount_11 Float, Amount_12 Float, Amount_13 Float, Amount_14 Float, Amount_15 Float, Amount_16 Float, Amount_17 Float, Amount_18 Float, Amount_19 Float, Amount_20 Float, 
Amount_21 Float, Amount_22 Float, Amount_23 Float, Amount_24 Float, Amount_25 Float, Amount_26 Float, Amount_27 Float, Amount_28 Float, Amount_29 Float)

Declare @IFRS_Data_Paid TABLE (GroupID Int, Branch varchar(10), DocNo varchar(50), RefNo varchar(50), Date smalldatetime, Code varchar(10), Type varchar(10), Currency varchar(10), Subject varchar(10), Remarks varchar(255),
Amount_1 Float, Amount_2 Float, Amount_3 Float, Amount_4 Float,Amount_5 Float, Amount_6 Float, Amount_7 Float, Amount_8 Float, Amount_9 Float, Amount_10 Float, 
Amount_11 Float, Amount_12 Float, Amount_13 Float, Amount_14 Float, Amount_15 Float, Amount_16 Float, Amount_17 Float, Amount_18 Float, Amount_19 Float, Amount_20 Float, 
Amount_21 Float, Amount_22 Float, Amount_23 Float, Amount_24 Float, Amount_25 Float, Amount_26 Float, Amount_27 Float, Amount_28 Float, Amount_29 Float)


insert into @IFRS_Data
Select I2.GroupID, I2.Branch, '' as DocNo, '' as RefNo, @P_Date as Date, I2.TOC as Code, 
Case 
When I1.GroupType='I' and I2.Method='B' then 'IFIB'
When I1.GroupType='R' and I2.Method='B' then 'IFRB'
When I1.GroupType='I' and I2.Method='P' then 'IFIP'
else 'IFRP'
end as Type, I2.Currency, 'JOURNAL' as Subject, MParam.Remarks as Remarks,

Amount_1 = sum(I1.BEL_Initial),
Amount_2 = sum(I1.BEL_Premium_Expected),
Amount_3 = sum(I1.BEL_Commission_Expected),
Amount_4 = sum(I1.BEL_Interest_Accrete),
Amount_5 = sum(I1.BEL_Claim_Expected),
Amount_6 = sum(I1.BEL_Expense_Expected),
Amount_7 = sum(I1.BEL_GainLoss_NonDiscRate),
Amount_8 = sum(I1.BEL_GainLoss_DiscRate),
Amount_9 = sum(I1.RA_Initial),
Amount_10 = sum(I1.RA_Interest_Accrete),
Amount_11 = sum(I1.RA_Release),
Amount_12 = sum(I1.RA_GainLoss_NonDiscRate),
Amount_13 = sum(I1.RA_GainLoss_DiscRate),
Amount_14 = sum(I1.CSM_Initial),
Amount_15 = sum(I1.CSM_Interest_Accrete),
Amount_16 = sum(I1.CSM_Amortization),
Amount_17 = sum(I1.CSM_GainLoss_Realization),
Amount_18 = sum(I1.CSM_GainLoss_NonDiscRate),
Amount_19 = sum(I1.Loss_Initial),
Amount_20 = sum(I1.Loss_Portion_from_Claim_Release),
Amount_21 = sum(I1.Loss_Portion_from_Expense_Release),
Amount_22 = sum(I1.Loss_Portion_from_RA_Release),
Amount_23 = sum(I1.Loss_Portion_from_Interest_Accrete),
Amount_24 = sum(I1.Loss_GainLoss_Realization),
Amount_25 = sum(I1.Loss_Portion_from_GainLoss_DiscRate),
Amount_26 = sum(I1.Loss_GainLoss_NonDiscRate),
Amount_27 = sum(I1.ACQ_Amortization),
Amount_28 = sum(I1.BEL_Refund_Expected),
Amount_29 = sum(I1.Loss_Portion_from_Refund_Release)
from IFRS_Movement I1 
Inner join IFRS_Calculation I2 on (I2.GroupID=I1.GroupID)
Inner join MParam on (MParam.Type=@P_Type)
Where I1.ProcessDate=@P_Date
Group by 
I2.GroupID, 
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
Select I2.GroupID, I2.Branch, '' as DocNo, '' as RefNo, @P_Date as Date, I2.TOC as Code, 
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
Amount_12 = cast(0 as Float),
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
Amount_29 = cast(0 as Float)
from IFRS_DATA_PAID(dateadd(day,1,@P_PEDate), @P_EDate) I2
Inner join MParam on (MParam.Type=@P_Type)
Group by 
I2.GroupID,
I2.Branch, 
I2.TOC, 
Case 
When I2.Method='B' then 'IFPB'
else 'IFPP'
end,
I2.Currency, 
MParam.Remarks


Insert into @IFRS
Select I1.GroupID, I1.Branch, I1.DocNo, I1.RefNo, I1.Date, I1.Code, I1.Type, I1.Currency, I1.Subject, I1.Remarks,
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
I1.Amount_29
from @IFRS_Data I1

Union all

Select I1.GroupID, I1.Branch, I1.DocNo, I1.RefNo, I1.Date, I1.Code, I1.Type, SysTab.Currency, I1.Subject, I1.Remarks,
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
sum(I1.Amount_27) as Amount_27, --ACQ Amortization in Base Currency
cast(0 as Float) as Amount_28,
cast(0 as Float) as Amount_29
from @IFRS_Data I1
Inner Join SysTab on (1=1)
Group By 
I1.GroupID, I1.Branch, I1.DocNo, I1.RefNo, I1.Date, I1.Code, I1.Type, SysTab.Currency, I1.Subject, I1.Remarks
Having sum(I1.Amount_27)<>0

Union All

Select I1.GroupID, I1.Branch, I1.DocNo, I1.RefNo, I1.Date, I1.Code, I1.Type, I1.Currency, I1.Subject, I1.Remarks,
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
I1.Amount_29
from @IFRS_Data_Paid I1

Union all

Select I1.GroupID, I1.Branch, I1.DocNo, I1.RefNo, I1.Date, I1.Code, I1.Type, SysTab.Currency, I1.Subject, I1.Remarks,
cast(0 as Float) as Amount_1,
cast(0 as Float) as Amount_2,
cast(0 as Float) as Amount_3,
cast(0 as Float) as Amount_4,
cast(0 as Float) as Amount_5,
cast(0 as Float) as Amount_6,
sum(I1.Amount_7) as Amount_7, --Gain Loss in Base Currency
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
cast(0 as Float) as Amount_29
from @IFRS_Data_Paid I1
Inner Join SysTab on (1=1)
Group By 
I1.GroupID, I1.Branch, I1.DocNo, I1.RefNo, I1.Date, I1.Code, I1.Type, SysTab.Currency, I1.Subject, I1.Remarks
Having sum(I1.Amount_7)<>0

RETURN
END



go



 insert into PatchVersioning	
select '695 Update Script - IFRS Patch #16',GETDATE()
go





Declare @PrevScript varchar(100)
Declare @CurrScript varchar(100)

Select @PrevScript=''
Select @CurrSCript='695 Update Script - IFRS Patch #16'


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


