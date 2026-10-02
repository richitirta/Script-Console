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
ALTER TABLE dbo.IFRS_Calculation ADD
	Onerous_1 bit NULL,
	Onerous_2 bit NULL,
	Onerous_3 bit NULL,
	Onerous_4 bit NULL,
	Onerous_5 bit NULL,
	Onerous_6 bit NULL,
	Onerous_7 bit NULL,
	Onerous_8 bit NULL,
	Onerous_9 bit NULL,
	Onerous_10 bit NULL,
	Onerous_11 bit NULL,
	Onerous_12 bit NULL,
	Onerous_13 bit NULL,
	Onerous_14 bit NULL,
	Onerous_15 bit NULL,
	Onerous_16 bit NULL,
	Onerous_17 bit NULL,
	Onerous_18 bit NULL,
	Onerous_19 bit NULL,
	Onerous_20 bit NULL,
	Onerous_21 bit NULL,
	Onerous_22 bit NULL,
	Onerous_23 bit NULL,
	Onerous_24 bit NULL,
	Onerous_25 bit NULL,
	Onerous_26 bit NULL,
	Onerous_27 bit NULL,
	Onerous_28 bit NULL,
	Onerous_29 bit NULL,
	Onerous_30 bit NULL
GO
COMMIT

GO

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
ALTER TABLE dbo.IFRS_Movement ADD
	Description varchar(255) NULL
GO
COMMIT

GO

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
ALTER TABLE dbo.ACCLINK ADD
	GroupID int NULL
GO
DECLARE @v sql_variant 
SET @v = N'IFRS GROUP ID (see IFRS_CALCULATION)'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'ACCLINK', N'COLUMN', N'GroupID'
GO
ALTER TABLE dbo.ACCLINK SET (LOCK_ESCALATION = TABLE)
GO
COMMIT

GO

DROP FUNCTION IFRS_Movement_PROCESS
GO
CREATE FUNCTION IFRS_Movement_PROCESS(@P_Type varchar(2),@P_Date smalldatetime, @P_PEDate smalldatetime,@P_EDate smalldatetime)            
RETURNS TABLE            
AS RETURN(            
Select I2.GroupID, I2.Branch, '' as DocNo, '' as RefNo, @P_Date as Date, I2.TOC as Code, 
Case 
When I1.GroupType='I' and I2.Method='B' then 'IFIB'
When I1.GroupType='R' and I2.Method='B' then 'IFRB'
When I1.GroupType='I' and I2.Method='P' then 'IFIP'
else 'IFRP'
end as Type, SysTab.Currency, 'JOURNAL' as Subject, MParam.Remarks as Remarks,

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
Inner join SysTab on (1=1)
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
SysTab.Currency, 
MParam.Remarks

Union all

Select I2.GroupID, I2.Branch, '' as DocNo, '' as RefNo, @P_Date as Date, I2.TOC as Code, 
Case 
When I2.Method='B' then 'IFPB'
else 'IFPP'
end as Type, SysTab.Currency, 'JOURNAL' as Subject, MParam.Remarks as Remarks,
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
Inner join SysTab on (1=1)
Inner join MParam on (MParam.Type=@P_Type)
Group by 
I2.GroupID,
I2.Branch, 
I2.TOC, 
Case 
When I2.Method='B' then 'IFPB'
else 'IFPP'
end,
SysTab.Currency, 
MParam.Remarks
)            

GO

Drop Procedure IFRS_SHOW_CALCULATION
GO

Create Procedure IFRS_SHOW_CALCULATION(@GroupID as int, @GroupType as varchar(1), @YearN as Int)
as

Declare @IFRS table (
 BEL_Beginning Float,
 BEL_Premium_Expected Float,
 BEL_Commission_Expected Float,
 BEL_Interest_Accrete Float,
 BEL_Claim_Expected Float,
 BEL_Expense_Expected Float,
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
 CSM_GainLoss_Realization_Premium Float,
 CSM_GainLoss_Realization_Commission Float,
 CSM_GainLoss_NonDiscRate Float,
 CSM_End Float,
 Loss_Start Float,
 Loss_Portion_from_Claim_Release Float,
 Loss_Portion_from_Expense_Release Float,
 Loss_Portion_from_Refund_Release Float,
 Loss_Portion_from_RA_Release Float,
 Loss_Portion_from_Interest_Accrete Float,
 Loss_GainLoss_Realization_Premium Float,
 Loss_GainLoss_Realization_Commission Float,
 Loss_Portion_from_GainLoss_DiscRate Float,
 Loss_GainLoss_NonDiscRate Float,
 Loss_End Float,
 Loss_Percentage Float,
 ACQ_Amortization Float,
 CSM_Start_N Float, 
 Loss_Start_N Float
)

Declare @MonthN as Int
Declare @Method as varchar(1)
Declare @OneRous as Bit

Select 
@MonthN=(year(I.ProcessDate)*12+Month(I.ProcessDate))-(Year*12+Month)+1, 
@Method=I.Method, 
@OneRous=
	Case When @GroupType='I' Then 
		Case 
		When @YearN=1 then I.OneRous_1
		When @YearN=2 then I.OneRous_2
		When @YearN=3 then I.OneRous_3
		When @YearN=4 then I.OneRous_4
		When @YearN=5 then I.OneRous_5
		When @YearN=6 then I.OneRous_6
		When @YearN=7 then I.OneRous_7
		When @YearN=8 then I.OneRous_8
		When @YearN=9 then I.OneRous_9
		When @YearN=10 then I.OneRous_10
		When @YearN=11 then I.OneRous_11
		When @YearN=12 then I.OneRous_12
		When @YearN=13 then I.OneRous_13
		When @YearN=14 then I.OneRous_14
		When @YearN=15 then I.OneRous_15
		When @YearN=16 then I.OneRous_16
		When @YearN=17 then I.OneRous_17
		When @YearN=18 then I.OneRous_18
		When @YearN=19 then I.OneRous_19
		When @YearN=20 then I.OneRous_20
		When @YearN=21 then I.OneRous_21
		When @YearN=22 then I.OneRous_22
		When @YearN=23 then I.OneRous_23
		When @YearN=24 then I.OneRous_24
		When @YearN=25 then I.OneRous_25
		When @YearN=26 then I.OneRous_26
		When @YearN=27 then I.OneRous_27
		When @YearN=28 then I.OneRous_28
		When @YearN=29 then I.OneRous_29
		When @YearN=30 then I.OneRous_30
		end
	else cast(0 as Bit) 
	end 
from IFRS_Calculation I 
Where GroupID=@GroupID

insert into @IFRS
Select
Sum(Case 
When @YearN=1 then I2_BEL.BEL_Beginning_1
When @YearN=2 then I2_BEL.BEL_Beginning_2
When @YearN=3 then I2_BEL.BEL_Beginning_3
When @YearN=4 then I2_BEL.BEL_Beginning_4
When @YearN=5 then I2_BEL.BEL_Beginning_5
When @YearN=6 then I2_BEL.BEL_Beginning_6
When @YearN=7 then I2_BEL.BEL_Beginning_7
When @YearN=8 then I2_BEL.BEL_Beginning_8
When @YearN=9 then I2_BEL.BEL_Beginning_9
When @YearN=10 then I2_BEL.BEL_Beginning_10
When @YearN=11 then I2_BEL.BEL_Beginning_11
When @YearN=12 then I2_BEL.BEL_Beginning_12
When @YearN=13 then I2_BEL.BEL_Beginning_13
When @YearN=14 then I2_BEL.BEL_Beginning_14
When @YearN=15 then I2_BEL.BEL_Beginning_15
When @YearN=16 then I2_BEL.BEL_Beginning_16
When @YearN=17 then I2_BEL.BEL_Beginning_17
When @YearN=18 then I2_BEL.BEL_Beginning_18
When @YearN=19 then I2_BEL.BEL_Beginning_19
When @YearN=20 then I2_BEL.BEL_Beginning_20
When @YearN=21 then I2_BEL.BEL_Beginning_21
When @YearN=22 then I2_BEL.BEL_Beginning_22
When @YearN=23 then I2_BEL.BEL_Beginning_23
When @YearN=24 then I2_BEL.BEL_Beginning_24
When @YearN=25 then I2_BEL.BEL_Beginning_25
When @YearN=26 then I2_BEL.BEL_Beginning_26
When @YearN=27 then I2_BEL.BEL_Beginning_27
When @YearN=28 then I2_BEL.BEL_Beginning_28
When @YearN=29 then I2_BEL.BEL_Beginning_29
When @YearN=30 then I2_BEL.BEL_Beginning_30
end) as BEL_Beginning,
Sum(Case 
When @YearN=1 then I2_BEL.BEL_Premium_Expected_1
When @YearN=2 then I2_BEL.BEL_Premium_Expected_2
When @YearN=3 then I2_BEL.BEL_Premium_Expected_3
When @YearN=4 then I2_BEL.BEL_Premium_Expected_4
When @YearN=5 then I2_BEL.BEL_Premium_Expected_5
When @YearN=6 then I2_BEL.BEL_Premium_Expected_6
When @YearN=7 then I2_BEL.BEL_Premium_Expected_7
When @YearN=8 then I2_BEL.BEL_Premium_Expected_8
When @YearN=9 then I2_BEL.BEL_Premium_Expected_9
When @YearN=10 then I2_BEL.BEL_Premium_Expected_10
When @YearN=11 then I2_BEL.BEL_Premium_Expected_11
When @YearN=12 then I2_BEL.BEL_Premium_Expected_12
When @YearN=13 then I2_BEL.BEL_Premium_Expected_13
When @YearN=14 then I2_BEL.BEL_Premium_Expected_14
When @YearN=15 then I2_BEL.BEL_Premium_Expected_15
When @YearN=16 then I2_BEL.BEL_Premium_Expected_16
When @YearN=17 then I2_BEL.BEL_Premium_Expected_17
When @YearN=18 then I2_BEL.BEL_Premium_Expected_18
When @YearN=19 then I2_BEL.BEL_Premium_Expected_19
When @YearN=20 then I2_BEL.BEL_Premium_Expected_20
When @YearN=21 then I2_BEL.BEL_Premium_Expected_21
When @YearN=22 then I2_BEL.BEL_Premium_Expected_22
When @YearN=23 then I2_BEL.BEL_Premium_Expected_23
When @YearN=24 then I2_BEL.BEL_Premium_Expected_24
When @YearN=25 then I2_BEL.BEL_Premium_Expected_25
When @YearN=26 then I2_BEL.BEL_Premium_Expected_26
When @YearN=27 then I2_BEL.BEL_Premium_Expected_27
When @YearN=28 then I2_BEL.BEL_Premium_Expected_28
When @YearN=29 then I2_BEL.BEL_Premium_Expected_29
When @YearN=30 then I2_BEL.BEL_Premium_Expected_30
end) as BEL_Premium_Expected,
Sum(Case 
When @YearN=1 then I2_BEL.BEL_Commission_Expected_1
When @YearN=2 then I2_BEL.BEL_Commission_Expected_2
When @YearN=3 then I2_BEL.BEL_Commission_Expected_3
When @YearN=4 then I2_BEL.BEL_Commission_Expected_4
When @YearN=5 then I2_BEL.BEL_Commission_Expected_5
When @YearN=6 then I2_BEL.BEL_Commission_Expected_6
When @YearN=7 then I2_BEL.BEL_Commission_Expected_7
When @YearN=8 then I2_BEL.BEL_Commission_Expected_8
When @YearN=9 then I2_BEL.BEL_Commission_Expected_9
When @YearN=10 then I2_BEL.BEL_Commission_Expected_10
When @YearN=11 then I2_BEL.BEL_Commission_Expected_11
When @YearN=12 then I2_BEL.BEL_Commission_Expected_12
When @YearN=13 then I2_BEL.BEL_Commission_Expected_13
When @YearN=14 then I2_BEL.BEL_Commission_Expected_14
When @YearN=15 then I2_BEL.BEL_Commission_Expected_15
When @YearN=16 then I2_BEL.BEL_Commission_Expected_16
When @YearN=17 then I2_BEL.BEL_Commission_Expected_17
When @YearN=18 then I2_BEL.BEL_Commission_Expected_18
When @YearN=19 then I2_BEL.BEL_Commission_Expected_19
When @YearN=20 then I2_BEL.BEL_Commission_Expected_20
When @YearN=21 then I2_BEL.BEL_Commission_Expected_21
When @YearN=22 then I2_BEL.BEL_Commission_Expected_22
When @YearN=23 then I2_BEL.BEL_Commission_Expected_23
When @YearN=24 then I2_BEL.BEL_Commission_Expected_24
When @YearN=25 then I2_BEL.BEL_Commission_Expected_25
When @YearN=26 then I2_BEL.BEL_Commission_Expected_26
When @YearN=27 then I2_BEL.BEL_Commission_Expected_27
When @YearN=28 then I2_BEL.BEL_Commission_Expected_28
When @YearN=29 then I2_BEL.BEL_Commission_Expected_29
When @YearN=30 then I2_BEL.BEL_Commission_Expected_30
end) as BEL_Commission_Expected,
Sum(Case 
When @YearN=1 then I2_BEL.BEL_Interest_Accrete_1
When @YearN=2 then I2_BEL.BEL_Interest_Accrete_2
When @YearN=3 then I2_BEL.BEL_Interest_Accrete_3
When @YearN=4 then I2_BEL.BEL_Interest_Accrete_4
When @YearN=5 then I2_BEL.BEL_Interest_Accrete_5
When @YearN=6 then I2_BEL.BEL_Interest_Accrete_6
When @YearN=7 then I2_BEL.BEL_Interest_Accrete_7
When @YearN=8 then I2_BEL.BEL_Interest_Accrete_8
When @YearN=9 then I2_BEL.BEL_Interest_Accrete_9
When @YearN=10 then I2_BEL.BEL_Interest_Accrete_10
When @YearN=11 then I2_BEL.BEL_Interest_Accrete_11
When @YearN=12 then I2_BEL.BEL_Interest_Accrete_12
When @YearN=13 then I2_BEL.BEL_Interest_Accrete_13
When @YearN=14 then I2_BEL.BEL_Interest_Accrete_14
When @YearN=15 then I2_BEL.BEL_Interest_Accrete_15
When @YearN=16 then I2_BEL.BEL_Interest_Accrete_16
When @YearN=17 then I2_BEL.BEL_Interest_Accrete_17
When @YearN=18 then I2_BEL.BEL_Interest_Accrete_18
When @YearN=19 then I2_BEL.BEL_Interest_Accrete_19
When @YearN=20 then I2_BEL.BEL_Interest_Accrete_20
When @YearN=21 then I2_BEL.BEL_Interest_Accrete_21
When @YearN=22 then I2_BEL.BEL_Interest_Accrete_22
When @YearN=23 then I2_BEL.BEL_Interest_Accrete_23
When @YearN=24 then I2_BEL.BEL_Interest_Accrete_24
When @YearN=25 then I2_BEL.BEL_Interest_Accrete_25
When @YearN=26 then I2_BEL.BEL_Interest_Accrete_26
When @YearN=27 then I2_BEL.BEL_Interest_Accrete_27
When @YearN=28 then I2_BEL.BEL_Interest_Accrete_28
When @YearN=29 then I2_BEL.BEL_Interest_Accrete_29
When @YearN=30 then I2_BEL.BEL_Interest_Accrete_30
end) as BEL_Interest_Accrete,
Sum(Case 
When @YearN=1 then I2_BEL.BEL_Claim_Expected_1
When @YearN=2 then I2_BEL.BEL_Claim_Expected_2
When @YearN=3 then I2_BEL.BEL_Claim_Expected_3
When @YearN=4 then I2_BEL.BEL_Claim_Expected_4
When @YearN=5 then I2_BEL.BEL_Claim_Expected_5
When @YearN=6 then I2_BEL.BEL_Claim_Expected_6
When @YearN=7 then I2_BEL.BEL_Claim_Expected_7
When @YearN=8 then I2_BEL.BEL_Claim_Expected_8
When @YearN=9 then I2_BEL.BEL_Claim_Expected_9
When @YearN=10 then I2_BEL.BEL_Claim_Expected_10
When @YearN=11 then I2_BEL.BEL_Claim_Expected_11
When @YearN=12 then I2_BEL.BEL_Claim_Expected_12
When @YearN=13 then I2_BEL.BEL_Claim_Expected_13
When @YearN=14 then I2_BEL.BEL_Claim_Expected_14
When @YearN=15 then I2_BEL.BEL_Claim_Expected_15
When @YearN=16 then I2_BEL.BEL_Claim_Expected_16
When @YearN=17 then I2_BEL.BEL_Claim_Expected_17
When @YearN=18 then I2_BEL.BEL_Claim_Expected_18
When @YearN=19 then I2_BEL.BEL_Claim_Expected_19
When @YearN=20 then I2_BEL.BEL_Claim_Expected_20
When @YearN=21 then I2_BEL.BEL_Claim_Expected_21
When @YearN=22 then I2_BEL.BEL_Claim_Expected_22
When @YearN=23 then I2_BEL.BEL_Claim_Expected_23
When @YearN=24 then I2_BEL.BEL_Claim_Expected_24
When @YearN=25 then I2_BEL.BEL_Claim_Expected_25
When @YearN=26 then I2_BEL.BEL_Claim_Expected_26
When @YearN=27 then I2_BEL.BEL_Claim_Expected_27
When @YearN=28 then I2_BEL.BEL_Claim_Expected_28
When @YearN=29 then I2_BEL.BEL_Claim_Expected_29
When @YearN=30 then I2_BEL.BEL_Claim_Expected_30
end) as BEL_Claim_Expected,
Sum(Case 
When @YearN=1 then I2_BEL.BEL_Expense_Expected_1
When @YearN=2 then I2_BEL.BEL_Expense_Expected_2
When @YearN=3 then I2_BEL.BEL_Expense_Expected_3
When @YearN=4 then I2_BEL.BEL_Expense_Expected_4
When @YearN=5 then I2_BEL.BEL_Expense_Expected_5
When @YearN=6 then I2_BEL.BEL_Expense_Expected_6
When @YearN=7 then I2_BEL.BEL_Expense_Expected_7
When @YearN=8 then I2_BEL.BEL_Expense_Expected_8
When @YearN=9 then I2_BEL.BEL_Expense_Expected_9
When @YearN=10 then I2_BEL.BEL_Expense_Expected_10
When @YearN=11 then I2_BEL.BEL_Expense_Expected_11
When @YearN=12 then I2_BEL.BEL_Expense_Expected_12
When @YearN=13 then I2_BEL.BEL_Expense_Expected_13
When @YearN=14 then I2_BEL.BEL_Expense_Expected_14
When @YearN=15 then I2_BEL.BEL_Expense_Expected_15
When @YearN=16 then I2_BEL.BEL_Expense_Expected_16
When @YearN=17 then I2_BEL.BEL_Expense_Expected_17
When @YearN=18 then I2_BEL.BEL_Expense_Expected_18
When @YearN=19 then I2_BEL.BEL_Expense_Expected_19
When @YearN=20 then I2_BEL.BEL_Expense_Expected_20
When @YearN=21 then I2_BEL.BEL_Expense_Expected_21
When @YearN=22 then I2_BEL.BEL_Expense_Expected_22
When @YearN=23 then I2_BEL.BEL_Expense_Expected_23
When @YearN=24 then I2_BEL.BEL_Expense_Expected_24
When @YearN=25 then I2_BEL.BEL_Expense_Expected_25
When @YearN=26 then I2_BEL.BEL_Expense_Expected_26
When @YearN=27 then I2_BEL.BEL_Expense_Expected_27
When @YearN=28 then I2_BEL.BEL_Expense_Expected_28
When @YearN=29 then I2_BEL.BEL_Expense_Expected_29
When @YearN=30 then I2_BEL.BEL_Expense_Expected_30
end) as BEL_Expense_Expected,
Sum(Case 
When @YearN=1 then I2_BEL.BEL_Refund_Expected_1
When @YearN=2 then I2_BEL.BEL_Refund_Expected_2
When @YearN=3 then I2_BEL.BEL_Refund_Expected_3
When @YearN=4 then I2_BEL.BEL_Refund_Expected_4
When @YearN=5 then I2_BEL.BEL_Refund_Expected_5
When @YearN=6 then I2_BEL.BEL_Refund_Expected_6
When @YearN=7 then I2_BEL.BEL_Refund_Expected_7
When @YearN=8 then I2_BEL.BEL_Refund_Expected_8
When @YearN=9 then I2_BEL.BEL_Refund_Expected_9
When @YearN=10 then I2_BEL.BEL_Refund_Expected_10
When @YearN=11 then I2_BEL.BEL_Refund_Expected_11
When @YearN=12 then I2_BEL.BEL_Refund_Expected_12
When @YearN=13 then I2_BEL.BEL_Refund_Expected_13
When @YearN=14 then I2_BEL.BEL_Refund_Expected_14
When @YearN=15 then I2_BEL.BEL_Refund_Expected_15
When @YearN=16 then I2_BEL.BEL_Refund_Expected_16
When @YearN=17 then I2_BEL.BEL_Refund_Expected_17
When @YearN=18 then I2_BEL.BEL_Refund_Expected_18
When @YearN=19 then I2_BEL.BEL_Refund_Expected_19
When @YearN=20 then I2_BEL.BEL_Refund_Expected_20
When @YearN=21 then I2_BEL.BEL_Refund_Expected_21
When @YearN=22 then I2_BEL.BEL_Refund_Expected_22
When @YearN=23 then I2_BEL.BEL_Refund_Expected_23
When @YearN=24 then I2_BEL.BEL_Refund_Expected_24
When @YearN=25 then I2_BEL.BEL_Refund_Expected_25
When @YearN=26 then I2_BEL.BEL_Refund_Expected_26
When @YearN=27 then I2_BEL.BEL_Refund_Expected_27
When @YearN=28 then I2_BEL.BEL_Refund_Expected_28
When @YearN=29 then I2_BEL.BEL_Refund_Expected_29
When @YearN=30 then I2_BEL.BEL_Refund_Expected_30
end) as BEL_Refund_Expected,
Sum(Case 
When @YearN=1 then I2_BEL.BEL_Ending_Before_Change_1
When @YearN=2 then I2_BEL.BEL_Ending_Before_Change_2
When @YearN=3 then I2_BEL.BEL_Ending_Before_Change_3
When @YearN=4 then I2_BEL.BEL_Ending_Before_Change_4
When @YearN=5 then I2_BEL.BEL_Ending_Before_Change_5
When @YearN=6 then I2_BEL.BEL_Ending_Before_Change_6
When @YearN=7 then I2_BEL.BEL_Ending_Before_Change_7
When @YearN=8 then I2_BEL.BEL_Ending_Before_Change_8
When @YearN=9 then I2_BEL.BEL_Ending_Before_Change_9
When @YearN=10 then I2_BEL.BEL_Ending_Before_Change_10
When @YearN=11 then I2_BEL.BEL_Ending_Before_Change_11
When @YearN=12 then I2_BEL.BEL_Ending_Before_Change_12
When @YearN=13 then I2_BEL.BEL_Ending_Before_Change_13
When @YearN=14 then I2_BEL.BEL_Ending_Before_Change_14
When @YearN=15 then I2_BEL.BEL_Ending_Before_Change_15
When @YearN=16 then I2_BEL.BEL_Ending_Before_Change_16
When @YearN=17 then I2_BEL.BEL_Ending_Before_Change_17
When @YearN=18 then I2_BEL.BEL_Ending_Before_Change_18
When @YearN=19 then I2_BEL.BEL_Ending_Before_Change_19
When @YearN=20 then I2_BEL.BEL_Ending_Before_Change_20
When @YearN=21 then I2_BEL.BEL_Ending_Before_Change_21
When @YearN=22 then I2_BEL.BEL_Ending_Before_Change_22
When @YearN=23 then I2_BEL.BEL_Ending_Before_Change_23
When @YearN=24 then I2_BEL.BEL_Ending_Before_Change_24
When @YearN=25 then I2_BEL.BEL_Ending_Before_Change_25
When @YearN=26 then I2_BEL.BEL_Ending_Before_Change_26
When @YearN=27 then I2_BEL.BEL_Ending_Before_Change_27
When @YearN=28 then I2_BEL.BEL_Ending_Before_Change_28
When @YearN=29 then I2_BEL.BEL_Ending_Before_Change_29
When @YearN=30 then I2_BEL.BEL_Ending_Before_Change_30
end) as BEL_Ending_Before_Change,
Sum(Case 
When @YearN=1 then I2_BEL.BEL_Ending_After_Change_NonDiscRate_1
When @YearN=2 then I2_BEL.BEL_Ending_After_Change_NonDiscRate_2
When @YearN=3 then I2_BEL.BEL_Ending_After_Change_NonDiscRate_3
When @YearN=4 then I2_BEL.BEL_Ending_After_Change_NonDiscRate_4
When @YearN=5 then I2_BEL.BEL_Ending_After_Change_NonDiscRate_5
When @YearN=6 then I2_BEL.BEL_Ending_After_Change_NonDiscRate_6
When @YearN=7 then I2_BEL.BEL_Ending_After_Change_NonDiscRate_7
When @YearN=8 then I2_BEL.BEL_Ending_After_Change_NonDiscRate_8
When @YearN=9 then I2_BEL.BEL_Ending_After_Change_NonDiscRate_9
When @YearN=10 then I2_BEL.BEL_Ending_After_Change_NonDiscRate_10
When @YearN=11 then I2_BEL.BEL_Ending_After_Change_NonDiscRate_11
When @YearN=12 then I2_BEL.BEL_Ending_After_Change_NonDiscRate_12
When @YearN=13 then I2_BEL.BEL_Ending_After_Change_NonDiscRate_13
When @YearN=14 then I2_BEL.BEL_Ending_After_Change_NonDiscRate_14
When @YearN=15 then I2_BEL.BEL_Ending_After_Change_NonDiscRate_15
When @YearN=16 then I2_BEL.BEL_Ending_After_Change_NonDiscRate_16
When @YearN=17 then I2_BEL.BEL_Ending_After_Change_NonDiscRate_17
When @YearN=18 then I2_BEL.BEL_Ending_After_Change_NonDiscRate_18
When @YearN=19 then I2_BEL.BEL_Ending_After_Change_NonDiscRate_19
When @YearN=20 then I2_BEL.BEL_Ending_After_Change_NonDiscRate_20
When @YearN=21 then I2_BEL.BEL_Ending_After_Change_NonDiscRate_21
When @YearN=22 then I2_BEL.BEL_Ending_After_Change_NonDiscRate_22
When @YearN=23 then I2_BEL.BEL_Ending_After_Change_NonDiscRate_23
When @YearN=24 then I2_BEL.BEL_Ending_After_Change_NonDiscRate_24
When @YearN=25 then I2_BEL.BEL_Ending_After_Change_NonDiscRate_25
When @YearN=26 then I2_BEL.BEL_Ending_After_Change_NonDiscRate_26
When @YearN=27 then I2_BEL.BEL_Ending_After_Change_NonDiscRate_27
When @YearN=28 then I2_BEL.BEL_Ending_After_Change_NonDiscRate_28
When @YearN=29 then I2_BEL.BEL_Ending_After_Change_NonDiscRate_29
When @YearN=30 then I2_BEL.BEL_Ending_After_Change_NonDiscRate_30
end) as BEL_Ending_After_Change_NonDiscRate,
Sum(Case 
When @YearN=1 then I2_BEL.BEL_Ending_After_Change_DiscRate_1
When @YearN=2 then I2_BEL.BEL_Ending_After_Change_DiscRate_2
When @YearN=3 then I2_BEL.BEL_Ending_After_Change_DiscRate_3
When @YearN=4 then I2_BEL.BEL_Ending_After_Change_DiscRate_4
When @YearN=5 then I2_BEL.BEL_Ending_After_Change_DiscRate_5
When @YearN=6 then I2_BEL.BEL_Ending_After_Change_DiscRate_6
When @YearN=7 then I2_BEL.BEL_Ending_After_Change_DiscRate_7
When @YearN=8 then I2_BEL.BEL_Ending_After_Change_DiscRate_8
When @YearN=9 then I2_BEL.BEL_Ending_After_Change_DiscRate_9
When @YearN=10 then I2_BEL.BEL_Ending_After_Change_DiscRate_10
When @YearN=11 then I2_BEL.BEL_Ending_After_Change_DiscRate_11
When @YearN=12 then I2_BEL.BEL_Ending_After_Change_DiscRate_12
When @YearN=13 then I2_BEL.BEL_Ending_After_Change_DiscRate_13
When @YearN=14 then I2_BEL.BEL_Ending_After_Change_DiscRate_14
When @YearN=15 then I2_BEL.BEL_Ending_After_Change_DiscRate_15
When @YearN=16 then I2_BEL.BEL_Ending_After_Change_DiscRate_16
When @YearN=17 then I2_BEL.BEL_Ending_After_Change_DiscRate_17
When @YearN=18 then I2_BEL.BEL_Ending_After_Change_DiscRate_18
When @YearN=19 then I2_BEL.BEL_Ending_After_Change_DiscRate_19
When @YearN=20 then I2_BEL.BEL_Ending_After_Change_DiscRate_20
When @YearN=21 then I2_BEL.BEL_Ending_After_Change_DiscRate_21
When @YearN=22 then I2_BEL.BEL_Ending_After_Change_DiscRate_22
When @YearN=23 then I2_BEL.BEL_Ending_After_Change_DiscRate_23
When @YearN=24 then I2_BEL.BEL_Ending_After_Change_DiscRate_24
When @YearN=25 then I2_BEL.BEL_Ending_After_Change_DiscRate_25
When @YearN=26 then I2_BEL.BEL_Ending_After_Change_DiscRate_26
When @YearN=27 then I2_BEL.BEL_Ending_After_Change_DiscRate_27
When @YearN=28 then I2_BEL.BEL_Ending_After_Change_DiscRate_28
When @YearN=29 then I2_BEL.BEL_Ending_After_Change_DiscRate_29
When @YearN=30 then I2_BEL.BEL_Ending_After_Change_DiscRate_30
end) as BEL_Ending_After_Change_DiscRate,
Sum(Case 
When @YearN=1 then I2_BEL.BEL_GainLoss_NonDiscRate_1
When @YearN=2 then I2_BEL.BEL_GainLoss_NonDiscRate_2
When @YearN=3 then I2_BEL.BEL_GainLoss_NonDiscRate_3
When @YearN=4 then I2_BEL.BEL_GainLoss_NonDiscRate_4
When @YearN=5 then I2_BEL.BEL_GainLoss_NonDiscRate_5
When @YearN=6 then I2_BEL.BEL_GainLoss_NonDiscRate_6
When @YearN=7 then I2_BEL.BEL_GainLoss_NonDiscRate_7
When @YearN=8 then I2_BEL.BEL_GainLoss_NonDiscRate_8
When @YearN=9 then I2_BEL.BEL_GainLoss_NonDiscRate_9
When @YearN=10 then I2_BEL.BEL_GainLoss_NonDiscRate_10
When @YearN=11 then I2_BEL.BEL_GainLoss_NonDiscRate_11
When @YearN=12 then I2_BEL.BEL_GainLoss_NonDiscRate_12
When @YearN=13 then I2_BEL.BEL_GainLoss_NonDiscRate_13
When @YearN=14 then I2_BEL.BEL_GainLoss_NonDiscRate_14
When @YearN=15 then I2_BEL.BEL_GainLoss_NonDiscRate_15
When @YearN=16 then I2_BEL.BEL_GainLoss_NonDiscRate_16
When @YearN=17 then I2_BEL.BEL_GainLoss_NonDiscRate_17
When @YearN=18 then I2_BEL.BEL_GainLoss_NonDiscRate_18
When @YearN=19 then I2_BEL.BEL_GainLoss_NonDiscRate_19
When @YearN=20 then I2_BEL.BEL_GainLoss_NonDiscRate_20
When @YearN=21 then I2_BEL.BEL_GainLoss_NonDiscRate_21
When @YearN=22 then I2_BEL.BEL_GainLoss_NonDiscRate_22
When @YearN=23 then I2_BEL.BEL_GainLoss_NonDiscRate_23
When @YearN=24 then I2_BEL.BEL_GainLoss_NonDiscRate_24
When @YearN=25 then I2_BEL.BEL_GainLoss_NonDiscRate_25
When @YearN=26 then I2_BEL.BEL_GainLoss_NonDiscRate_26
When @YearN=27 then I2_BEL.BEL_GainLoss_NonDiscRate_27
When @YearN=28 then I2_BEL.BEL_GainLoss_NonDiscRate_28
When @YearN=29 then I2_BEL.BEL_GainLoss_NonDiscRate_29
When @YearN=30 then I2_BEL.BEL_GainLoss_NonDiscRate_30
end) as BEL_GainLoss_NonDiscRate,
Sum(Case 
When @YearN=1 then I2_BEL.BEL_GainLoss_DiscRate_1
When @YearN=2 then I2_BEL.BEL_GainLoss_DiscRate_2
When @YearN=3 then I2_BEL.BEL_GainLoss_DiscRate_3
When @YearN=4 then I2_BEL.BEL_GainLoss_DiscRate_4
When @YearN=5 then I2_BEL.BEL_GainLoss_DiscRate_5
When @YearN=6 then I2_BEL.BEL_GainLoss_DiscRate_6
When @YearN=7 then I2_BEL.BEL_GainLoss_DiscRate_7
When @YearN=8 then I2_BEL.BEL_GainLoss_DiscRate_8
When @YearN=9 then I2_BEL.BEL_GainLoss_DiscRate_9
When @YearN=10 then I2_BEL.BEL_GainLoss_DiscRate_10
When @YearN=11 then I2_BEL.BEL_GainLoss_DiscRate_11
When @YearN=12 then I2_BEL.BEL_GainLoss_DiscRate_12
When @YearN=13 then I2_BEL.BEL_GainLoss_DiscRate_13
When @YearN=14 then I2_BEL.BEL_GainLoss_DiscRate_14
When @YearN=15 then I2_BEL.BEL_GainLoss_DiscRate_15
When @YearN=16 then I2_BEL.BEL_GainLoss_DiscRate_16
When @YearN=17 then I2_BEL.BEL_GainLoss_DiscRate_17
When @YearN=18 then I2_BEL.BEL_GainLoss_DiscRate_18
When @YearN=19 then I2_BEL.BEL_GainLoss_DiscRate_19
When @YearN=20 then I2_BEL.BEL_GainLoss_DiscRate_20
When @YearN=21 then I2_BEL.BEL_GainLoss_DiscRate_21
When @YearN=22 then I2_BEL.BEL_GainLoss_DiscRate_22
When @YearN=23 then I2_BEL.BEL_GainLoss_DiscRate_23
When @YearN=24 then I2_BEL.BEL_GainLoss_DiscRate_24
When @YearN=25 then I2_BEL.BEL_GainLoss_DiscRate_25
When @YearN=26 then I2_BEL.BEL_GainLoss_DiscRate_26
When @YearN=27 then I2_BEL.BEL_GainLoss_DiscRate_27
When @YearN=28 then I2_BEL.BEL_GainLoss_DiscRate_28
When @YearN=29 then I2_BEL.BEL_GainLoss_DiscRate_29
When @YearN=30 then I2_BEL.BEL_GainLoss_DiscRate_30
end) as BEL_GainLoss_DiscRate,
Sum(Case 
When @YearN=1 then I2_RA.RA_Beginning_1
When @YearN=2 then I2_RA.RA_Beginning_2
When @YearN=3 then I2_RA.RA_Beginning_3
When @YearN=4 then I2_RA.RA_Beginning_4
When @YearN=5 then I2_RA.RA_Beginning_5
When @YearN=6 then I2_RA.RA_Beginning_6
When @YearN=7 then I2_RA.RA_Beginning_7
When @YearN=8 then I2_RA.RA_Beginning_8
When @YearN=9 then I2_RA.RA_Beginning_9
When @YearN=10 then I2_RA.RA_Beginning_10
When @YearN=11 then I2_RA.RA_Beginning_11
When @YearN=12 then I2_RA.RA_Beginning_12
When @YearN=13 then I2_RA.RA_Beginning_13
When @YearN=14 then I2_RA.RA_Beginning_14
When @YearN=15 then I2_RA.RA_Beginning_15
When @YearN=16 then I2_RA.RA_Beginning_16
When @YearN=17 then I2_RA.RA_Beginning_17
When @YearN=18 then I2_RA.RA_Beginning_18
When @YearN=19 then I2_RA.RA_Beginning_19
When @YearN=20 then I2_RA.RA_Beginning_20
When @YearN=21 then I2_RA.RA_Beginning_21
When @YearN=22 then I2_RA.RA_Beginning_22
When @YearN=23 then I2_RA.RA_Beginning_23
When @YearN=24 then I2_RA.RA_Beginning_24
When @YearN=25 then I2_RA.RA_Beginning_25
When @YearN=26 then I2_RA.RA_Beginning_26
When @YearN=27 then I2_RA.RA_Beginning_27
When @YearN=28 then I2_RA.RA_Beginning_28
When @YearN=29 then I2_RA.RA_Beginning_29
When @YearN=30 then I2_RA.RA_Beginning_30
end) as RA_Beginning,
Sum(Case 
When @YearN=1 then I2_RA.RA_Interest_Accrete_1
When @YearN=2 then I2_RA.RA_Interest_Accrete_2
When @YearN=3 then I2_RA.RA_Interest_Accrete_3
When @YearN=4 then I2_RA.RA_Interest_Accrete_4
When @YearN=5 then I2_RA.RA_Interest_Accrete_5
When @YearN=6 then I2_RA.RA_Interest_Accrete_6
When @YearN=7 then I2_RA.RA_Interest_Accrete_7
When @YearN=8 then I2_RA.RA_Interest_Accrete_8
When @YearN=9 then I2_RA.RA_Interest_Accrete_9
When @YearN=10 then I2_RA.RA_Interest_Accrete_10
When @YearN=11 then I2_RA.RA_Interest_Accrete_11
When @YearN=12 then I2_RA.RA_Interest_Accrete_12
When @YearN=13 then I2_RA.RA_Interest_Accrete_13
When @YearN=14 then I2_RA.RA_Interest_Accrete_14
When @YearN=15 then I2_RA.RA_Interest_Accrete_15
When @YearN=16 then I2_RA.RA_Interest_Accrete_16
When @YearN=17 then I2_RA.RA_Interest_Accrete_17
When @YearN=18 then I2_RA.RA_Interest_Accrete_18
When @YearN=19 then I2_RA.RA_Interest_Accrete_19
When @YearN=20 then I2_RA.RA_Interest_Accrete_20
When @YearN=21 then I2_RA.RA_Interest_Accrete_21
When @YearN=22 then I2_RA.RA_Interest_Accrete_22
When @YearN=23 then I2_RA.RA_Interest_Accrete_23
When @YearN=24 then I2_RA.RA_Interest_Accrete_24
When @YearN=25 then I2_RA.RA_Interest_Accrete_25
When @YearN=26 then I2_RA.RA_Interest_Accrete_26
When @YearN=27 then I2_RA.RA_Interest_Accrete_27
When @YearN=28 then I2_RA.RA_Interest_Accrete_28
When @YearN=29 then I2_RA.RA_Interest_Accrete_29
When @YearN=30 then I2_RA.RA_Interest_Accrete_30
end) as RA_Interest_Accrete,
Sum(Case 
When @YearN=1 then I2_RA.RA_Release_1
When @YearN=2 then I2_RA.RA_Release_2
When @YearN=3 then I2_RA.RA_Release_3
When @YearN=4 then I2_RA.RA_Release_4
When @YearN=5 then I2_RA.RA_Release_5
When @YearN=6 then I2_RA.RA_Release_6
When @YearN=7 then I2_RA.RA_Release_7
When @YearN=8 then I2_RA.RA_Release_8
When @YearN=9 then I2_RA.RA_Release_9
When @YearN=10 then I2_RA.RA_Release_10
When @YearN=11 then I2_RA.RA_Release_11
When @YearN=12 then I2_RA.RA_Release_12
When @YearN=13 then I2_RA.RA_Release_13
When @YearN=14 then I2_RA.RA_Release_14
When @YearN=15 then I2_RA.RA_Release_15
When @YearN=16 then I2_RA.RA_Release_16
When @YearN=17 then I2_RA.RA_Release_17
When @YearN=18 then I2_RA.RA_Release_18
When @YearN=19 then I2_RA.RA_Release_19
When @YearN=20 then I2_RA.RA_Release_20
When @YearN=21 then I2_RA.RA_Release_21
When @YearN=22 then I2_RA.RA_Release_22
When @YearN=23 then I2_RA.RA_Release_23
When @YearN=24 then I2_RA.RA_Release_24
When @YearN=25 then I2_RA.RA_Release_25
When @YearN=26 then I2_RA.RA_Release_26
When @YearN=27 then I2_RA.RA_Release_27
When @YearN=28 then I2_RA.RA_Release_28
When @YearN=29 then I2_RA.RA_Release_29
When @YearN=30 then I2_RA.RA_Release_30
end) as RA_Release,
Sum(Case 
When @YearN=1 then I2_RA.RA_Ending_Before_Change_1
When @YearN=2 then I2_RA.RA_Ending_Before_Change_2
When @YearN=3 then I2_RA.RA_Ending_Before_Change_3
When @YearN=4 then I2_RA.RA_Ending_Before_Change_4
When @YearN=5 then I2_RA.RA_Ending_Before_Change_5
When @YearN=6 then I2_RA.RA_Ending_Before_Change_6
When @YearN=7 then I2_RA.RA_Ending_Before_Change_7
When @YearN=8 then I2_RA.RA_Ending_Before_Change_8
When @YearN=9 then I2_RA.RA_Ending_Before_Change_9
When @YearN=10 then I2_RA.RA_Ending_Before_Change_10
When @YearN=11 then I2_RA.RA_Ending_Before_Change_11
When @YearN=12 then I2_RA.RA_Ending_Before_Change_12
When @YearN=13 then I2_RA.RA_Ending_Before_Change_13
When @YearN=14 then I2_RA.RA_Ending_Before_Change_14
When @YearN=15 then I2_RA.RA_Ending_Before_Change_15
When @YearN=16 then I2_RA.RA_Ending_Before_Change_16
When @YearN=17 then I2_RA.RA_Ending_Before_Change_17
When @YearN=18 then I2_RA.RA_Ending_Before_Change_18
When @YearN=19 then I2_RA.RA_Ending_Before_Change_19
When @YearN=20 then I2_RA.RA_Ending_Before_Change_20
When @YearN=21 then I2_RA.RA_Ending_Before_Change_21
When @YearN=22 then I2_RA.RA_Ending_Before_Change_22
When @YearN=23 then I2_RA.RA_Ending_Before_Change_23
When @YearN=24 then I2_RA.RA_Ending_Before_Change_24
When @YearN=25 then I2_RA.RA_Ending_Before_Change_25
When @YearN=26 then I2_RA.RA_Ending_Before_Change_26
When @YearN=27 then I2_RA.RA_Ending_Before_Change_27
When @YearN=28 then I2_RA.RA_Ending_Before_Change_28
When @YearN=29 then I2_RA.RA_Ending_Before_Change_29
When @YearN=30 then I2_RA.RA_Ending_Before_Change_30
end) as RA_Ending_Before_Change,
Sum(Case 
When @YearN=1 then I2_RA.RA_Ending_After_Change_NonDiscRate_1
When @YearN=2 then I2_RA.RA_Ending_After_Change_NonDiscRate_2
When @YearN=3 then I2_RA.RA_Ending_After_Change_NonDiscRate_3
When @YearN=4 then I2_RA.RA_Ending_After_Change_NonDiscRate_4
When @YearN=5 then I2_RA.RA_Ending_After_Change_NonDiscRate_5
When @YearN=6 then I2_RA.RA_Ending_After_Change_NonDiscRate_6
When @YearN=7 then I2_RA.RA_Ending_After_Change_NonDiscRate_7
When @YearN=8 then I2_RA.RA_Ending_After_Change_NonDiscRate_8
When @YearN=9 then I2_RA.RA_Ending_After_Change_NonDiscRate_9
When @YearN=10 then I2_RA.RA_Ending_After_Change_NonDiscRate_10
When @YearN=11 then I2_RA.RA_Ending_After_Change_NonDiscRate_11
When @YearN=12 then I2_RA.RA_Ending_After_Change_NonDiscRate_12
When @YearN=13 then I2_RA.RA_Ending_After_Change_NonDiscRate_13
When @YearN=14 then I2_RA.RA_Ending_After_Change_NonDiscRate_14
When @YearN=15 then I2_RA.RA_Ending_After_Change_NonDiscRate_15
When @YearN=16 then I2_RA.RA_Ending_After_Change_NonDiscRate_16
When @YearN=17 then I2_RA.RA_Ending_After_Change_NonDiscRate_17
When @YearN=18 then I2_RA.RA_Ending_After_Change_NonDiscRate_18
When @YearN=19 then I2_RA.RA_Ending_After_Change_NonDiscRate_19
When @YearN=20 then I2_RA.RA_Ending_After_Change_NonDiscRate_20
When @YearN=21 then I2_RA.RA_Ending_After_Change_NonDiscRate_21
When @YearN=22 then I2_RA.RA_Ending_After_Change_NonDiscRate_22
When @YearN=23 then I2_RA.RA_Ending_After_Change_NonDiscRate_23
When @YearN=24 then I2_RA.RA_Ending_After_Change_NonDiscRate_24
When @YearN=25 then I2_RA.RA_Ending_After_Change_NonDiscRate_25
When @YearN=26 then I2_RA.RA_Ending_After_Change_NonDiscRate_26
When @YearN=27 then I2_RA.RA_Ending_After_Change_NonDiscRate_27
When @YearN=28 then I2_RA.RA_Ending_After_Change_NonDiscRate_28
When @YearN=29 then I2_RA.RA_Ending_After_Change_NonDiscRate_29
When @YearN=30 then I2_RA.RA_Ending_After_Change_NonDiscRate_30
end) as RA_Ending_After_Change_NonDiscRate,
Sum(Case 
When @YearN=1 then I2_RA.RA_Ending_After_Change_DiscRate_1
When @YearN=2 then I2_RA.RA_Ending_After_Change_DiscRate_2
When @YearN=3 then I2_RA.RA_Ending_After_Change_DiscRate_3
When @YearN=4 then I2_RA.RA_Ending_After_Change_DiscRate_4
When @YearN=5 then I2_RA.RA_Ending_After_Change_DiscRate_5
When @YearN=6 then I2_RA.RA_Ending_After_Change_DiscRate_6
When @YearN=7 then I2_RA.RA_Ending_After_Change_DiscRate_7
When @YearN=8 then I2_RA.RA_Ending_After_Change_DiscRate_8
When @YearN=9 then I2_RA.RA_Ending_After_Change_DiscRate_9
When @YearN=10 then I2_RA.RA_Ending_After_Change_DiscRate_10
When @YearN=11 then I2_RA.RA_Ending_After_Change_DiscRate_11
When @YearN=12 then I2_RA.RA_Ending_After_Change_DiscRate_12
When @YearN=13 then I2_RA.RA_Ending_After_Change_DiscRate_13
When @YearN=14 then I2_RA.RA_Ending_After_Change_DiscRate_14
When @YearN=15 then I2_RA.RA_Ending_After_Change_DiscRate_15
When @YearN=16 then I2_RA.RA_Ending_After_Change_DiscRate_16
When @YearN=17 then I2_RA.RA_Ending_After_Change_DiscRate_17
When @YearN=18 then I2_RA.RA_Ending_After_Change_DiscRate_18
When @YearN=19 then I2_RA.RA_Ending_After_Change_DiscRate_19
When @YearN=20 then I2_RA.RA_Ending_After_Change_DiscRate_20
When @YearN=21 then I2_RA.RA_Ending_After_Change_DiscRate_21
When @YearN=22 then I2_RA.RA_Ending_After_Change_DiscRate_22
When @YearN=23 then I2_RA.RA_Ending_After_Change_DiscRate_23
When @YearN=24 then I2_RA.RA_Ending_After_Change_DiscRate_24
When @YearN=25 then I2_RA.RA_Ending_After_Change_DiscRate_25
When @YearN=26 then I2_RA.RA_Ending_After_Change_DiscRate_26
When @YearN=27 then I2_RA.RA_Ending_After_Change_DiscRate_27
When @YearN=28 then I2_RA.RA_Ending_After_Change_DiscRate_28
When @YearN=29 then I2_RA.RA_Ending_After_Change_DiscRate_29
When @YearN=30 then I2_RA.RA_Ending_After_Change_DiscRate_30
end) as RA_Ending_After_Change_DiscRate,
Sum(Case 
When @YearN=1 then I2_RA.RA_GainLoss_NonDiscRate_1
When @YearN=2 then I2_RA.RA_GainLoss_NonDiscRate_2
When @YearN=3 then I2_RA.RA_GainLoss_NonDiscRate_3
When @YearN=4 then I2_RA.RA_GainLoss_NonDiscRate_4
When @YearN=5 then I2_RA.RA_GainLoss_NonDiscRate_5
When @YearN=6 then I2_RA.RA_GainLoss_NonDiscRate_6
When @YearN=7 then I2_RA.RA_GainLoss_NonDiscRate_7
When @YearN=8 then I2_RA.RA_GainLoss_NonDiscRate_8
When @YearN=9 then I2_RA.RA_GainLoss_NonDiscRate_9
When @YearN=10 then I2_RA.RA_GainLoss_NonDiscRate_10
When @YearN=11 then I2_RA.RA_GainLoss_NonDiscRate_11
When @YearN=12 then I2_RA.RA_GainLoss_NonDiscRate_12
When @YearN=13 then I2_RA.RA_GainLoss_NonDiscRate_13
When @YearN=14 then I2_RA.RA_GainLoss_NonDiscRate_14
When @YearN=15 then I2_RA.RA_GainLoss_NonDiscRate_15
When @YearN=16 then I2_RA.RA_GainLoss_NonDiscRate_16
When @YearN=17 then I2_RA.RA_GainLoss_NonDiscRate_17
When @YearN=18 then I2_RA.RA_GainLoss_NonDiscRate_18
When @YearN=19 then I2_RA.RA_GainLoss_NonDiscRate_19
When @YearN=20 then I2_RA.RA_GainLoss_NonDiscRate_20
When @YearN=21 then I2_RA.RA_GainLoss_NonDiscRate_21
When @YearN=22 then I2_RA.RA_GainLoss_NonDiscRate_22
When @YearN=23 then I2_RA.RA_GainLoss_NonDiscRate_23
When @YearN=24 then I2_RA.RA_GainLoss_NonDiscRate_24
When @YearN=25 then I2_RA.RA_GainLoss_NonDiscRate_25
When @YearN=26 then I2_RA.RA_GainLoss_NonDiscRate_26
When @YearN=27 then I2_RA.RA_GainLoss_NonDiscRate_27
When @YearN=28 then I2_RA.RA_GainLoss_NonDiscRate_28
When @YearN=29 then I2_RA.RA_GainLoss_NonDiscRate_29
When @YearN=30 then I2_RA.RA_GainLoss_NonDiscRate_30
end) as RA_GainLoss_NonDiscRate,
Sum(Case 
When @YearN=1 then I2_RA.RA_GainLoss_DiscRate_1
When @YearN=2 then I2_RA.RA_GainLoss_DiscRate_2
When @YearN=3 then I2_RA.RA_GainLoss_DiscRate_3
When @YearN=4 then I2_RA.RA_GainLoss_DiscRate_4
When @YearN=5 then I2_RA.RA_GainLoss_DiscRate_5
When @YearN=6 then I2_RA.RA_GainLoss_DiscRate_6
When @YearN=7 then I2_RA.RA_GainLoss_DiscRate_7
When @YearN=8 then I2_RA.RA_GainLoss_DiscRate_8
When @YearN=9 then I2_RA.RA_GainLoss_DiscRate_9
When @YearN=10 then I2_RA.RA_GainLoss_DiscRate_10
When @YearN=11 then I2_RA.RA_GainLoss_DiscRate_11
When @YearN=12 then I2_RA.RA_GainLoss_DiscRate_12
When @YearN=13 then I2_RA.RA_GainLoss_DiscRate_13
When @YearN=14 then I2_RA.RA_GainLoss_DiscRate_14
When @YearN=15 then I2_RA.RA_GainLoss_DiscRate_15
When @YearN=16 then I2_RA.RA_GainLoss_DiscRate_16
When @YearN=17 then I2_RA.RA_GainLoss_DiscRate_17
When @YearN=18 then I2_RA.RA_GainLoss_DiscRate_18
When @YearN=19 then I2_RA.RA_GainLoss_DiscRate_19
When @YearN=20 then I2_RA.RA_GainLoss_DiscRate_20
When @YearN=21 then I2_RA.RA_GainLoss_DiscRate_21
When @YearN=22 then I2_RA.RA_GainLoss_DiscRate_22
When @YearN=23 then I2_RA.RA_GainLoss_DiscRate_23
When @YearN=24 then I2_RA.RA_GainLoss_DiscRate_24
When @YearN=25 then I2_RA.RA_GainLoss_DiscRate_25
When @YearN=26 then I2_RA.RA_GainLoss_DiscRate_26
When @YearN=27 then I2_RA.RA_GainLoss_DiscRate_27
When @YearN=28 then I2_RA.RA_GainLoss_DiscRate_28
When @YearN=29 then I2_RA.RA_GainLoss_DiscRate_29
When @YearN=30 then I2_RA.RA_GainLoss_DiscRate_30
end) as RA_GainLoss_DiscRate,
Sum(Case 
When @YearN=1 then I2_CSM.CSM_Start_1
When @YearN=2 then I2_CSM.CSM_Start_2
When @YearN=3 then I2_CSM.CSM_Start_3
When @YearN=4 then I2_CSM.CSM_Start_4
When @YearN=5 then I2_CSM.CSM_Start_5
When @YearN=6 then I2_CSM.CSM_Start_6
When @YearN=7 then I2_CSM.CSM_Start_7
When @YearN=8 then I2_CSM.CSM_Start_8
When @YearN=9 then I2_CSM.CSM_Start_9
When @YearN=10 then I2_CSM.CSM_Start_10
When @YearN=11 then I2_CSM.CSM_Start_11
When @YearN=12 then I2_CSM.CSM_Start_12
When @YearN=13 then I2_CSM.CSM_Start_13
When @YearN=14 then I2_CSM.CSM_Start_14
When @YearN=15 then I2_CSM.CSM_Start_15
When @YearN=16 then I2_CSM.CSM_Start_16
When @YearN=17 then I2_CSM.CSM_Start_17
When @YearN=18 then I2_CSM.CSM_Start_18
When @YearN=19 then I2_CSM.CSM_Start_19
When @YearN=20 then I2_CSM.CSM_Start_20
When @YearN=21 then I2_CSM.CSM_Start_21
When @YearN=22 then I2_CSM.CSM_Start_22
When @YearN=23 then I2_CSM.CSM_Start_23
When @YearN=24 then I2_CSM.CSM_Start_24
When @YearN=25 then I2_CSM.CSM_Start_25
When @YearN=26 then I2_CSM.CSM_Start_26
When @YearN=27 then I2_CSM.CSM_Start_27
When @YearN=28 then I2_CSM.CSM_Start_28
When @YearN=29 then I2_CSM.CSM_Start_29
When @YearN=30 then I2_CSM.CSM_Start_30
end) as CSM_Start,
Sum(Case 
When @YearN=1 then I2_CSM.CSM_Interest_Accrete_1
When @YearN=2 then I2_CSM.CSM_Interest_Accrete_2
When @YearN=3 then I2_CSM.CSM_Interest_Accrete_3
When @YearN=4 then I2_CSM.CSM_Interest_Accrete_4
When @YearN=5 then I2_CSM.CSM_Interest_Accrete_5
When @YearN=6 then I2_CSM.CSM_Interest_Accrete_6
When @YearN=7 then I2_CSM.CSM_Interest_Accrete_7
When @YearN=8 then I2_CSM.CSM_Interest_Accrete_8
When @YearN=9 then I2_CSM.CSM_Interest_Accrete_9
When @YearN=10 then I2_CSM.CSM_Interest_Accrete_10
When @YearN=11 then I2_CSM.CSM_Interest_Accrete_11
When @YearN=12 then I2_CSM.CSM_Interest_Accrete_12
When @YearN=13 then I2_CSM.CSM_Interest_Accrete_13
When @YearN=14 then I2_CSM.CSM_Interest_Accrete_14
When @YearN=15 then I2_CSM.CSM_Interest_Accrete_15
When @YearN=16 then I2_CSM.CSM_Interest_Accrete_16
When @YearN=17 then I2_CSM.CSM_Interest_Accrete_17
When @YearN=18 then I2_CSM.CSM_Interest_Accrete_18
When @YearN=19 then I2_CSM.CSM_Interest_Accrete_19
When @YearN=20 then I2_CSM.CSM_Interest_Accrete_20
When @YearN=21 then I2_CSM.CSM_Interest_Accrete_21
When @YearN=22 then I2_CSM.CSM_Interest_Accrete_22
When @YearN=23 then I2_CSM.CSM_Interest_Accrete_23
When @YearN=24 then I2_CSM.CSM_Interest_Accrete_24
When @YearN=25 then I2_CSM.CSM_Interest_Accrete_25
When @YearN=26 then I2_CSM.CSM_Interest_Accrete_26
When @YearN=27 then I2_CSM.CSM_Interest_Accrete_27
When @YearN=28 then I2_CSM.CSM_Interest_Accrete_28
When @YearN=29 then I2_CSM.CSM_Interest_Accrete_29
When @YearN=30 then I2_CSM.CSM_Interest_Accrete_30
end) as CSM_Interest_Accrete,
Sum(Case 
When @YearN=1 then I2_CSM.CSM_Amortization_1
When @YearN=2 then I2_CSM.CSM_Amortization_2
When @YearN=3 then I2_CSM.CSM_Amortization_3
When @YearN=4 then I2_CSM.CSM_Amortization_4
When @YearN=5 then I2_CSM.CSM_Amortization_5
When @YearN=6 then I2_CSM.CSM_Amortization_6
When @YearN=7 then I2_CSM.CSM_Amortization_7
When @YearN=8 then I2_CSM.CSM_Amortization_8
When @YearN=9 then I2_CSM.CSM_Amortization_9
When @YearN=10 then I2_CSM.CSM_Amortization_10
When @YearN=11 then I2_CSM.CSM_Amortization_11
When @YearN=12 then I2_CSM.CSM_Amortization_12
When @YearN=13 then I2_CSM.CSM_Amortization_13
When @YearN=14 then I2_CSM.CSM_Amortization_14
When @YearN=15 then I2_CSM.CSM_Amortization_15
When @YearN=16 then I2_CSM.CSM_Amortization_16
When @YearN=17 then I2_CSM.CSM_Amortization_17
When @YearN=18 then I2_CSM.CSM_Amortization_18
When @YearN=19 then I2_CSM.CSM_Amortization_19
When @YearN=20 then I2_CSM.CSM_Amortization_20
When @YearN=21 then I2_CSM.CSM_Amortization_21
When @YearN=22 then I2_CSM.CSM_Amortization_22
When @YearN=23 then I2_CSM.CSM_Amortization_23
When @YearN=24 then I2_CSM.CSM_Amortization_24
When @YearN=25 then I2_CSM.CSM_Amortization_25
When @YearN=26 then I2_CSM.CSM_Amortization_26
When @YearN=27 then I2_CSM.CSM_Amortization_27
When @YearN=28 then I2_CSM.CSM_Amortization_28
When @YearN=29 then I2_CSM.CSM_Amortization_29
When @YearN=30 then I2_CSM.CSM_Amortization_30
end) as CSM_Amortization,
Sum(Case 
When @YearN=1 then I2_CSM.CSM_GainLoss_Realization_Premium_1
When @YearN=2 then I2_CSM.CSM_GainLoss_Realization_Premium_2
When @YearN=3 then I2_CSM.CSM_GainLoss_Realization_Premium_3
When @YearN=4 then I2_CSM.CSM_GainLoss_Realization_Premium_4
When @YearN=5 then I2_CSM.CSM_GainLoss_Realization_Premium_5
When @YearN=6 then I2_CSM.CSM_GainLoss_Realization_Premium_6
When @YearN=7 then I2_CSM.CSM_GainLoss_Realization_Premium_7
When @YearN=8 then I2_CSM.CSM_GainLoss_Realization_Premium_8
When @YearN=9 then I2_CSM.CSM_GainLoss_Realization_Premium_9
When @YearN=10 then I2_CSM.CSM_GainLoss_Realization_Premium_10
When @YearN=11 then I2_CSM.CSM_GainLoss_Realization_Premium_11
When @YearN=12 then I2_CSM.CSM_GainLoss_Realization_Premium_12
When @YearN=13 then I2_CSM.CSM_GainLoss_Realization_Premium_13
When @YearN=14 then I2_CSM.CSM_GainLoss_Realization_Premium_14
When @YearN=15 then I2_CSM.CSM_GainLoss_Realization_Premium_15
When @YearN=16 then I2_CSM.CSM_GainLoss_Realization_Premium_16
When @YearN=17 then I2_CSM.CSM_GainLoss_Realization_Premium_17
When @YearN=18 then I2_CSM.CSM_GainLoss_Realization_Premium_18
When @YearN=19 then I2_CSM.CSM_GainLoss_Realization_Premium_19
When @YearN=20 then I2_CSM.CSM_GainLoss_Realization_Premium_20
When @YearN=21 then I2_CSM.CSM_GainLoss_Realization_Premium_21
When @YearN=22 then I2_CSM.CSM_GainLoss_Realization_Premium_22
When @YearN=23 then I2_CSM.CSM_GainLoss_Realization_Premium_23
When @YearN=24 then I2_CSM.CSM_GainLoss_Realization_Premium_24
When @YearN=25 then I2_CSM.CSM_GainLoss_Realization_Premium_25
When @YearN=26 then I2_CSM.CSM_GainLoss_Realization_Premium_26
When @YearN=27 then I2_CSM.CSM_GainLoss_Realization_Premium_27
When @YearN=28 then I2_CSM.CSM_GainLoss_Realization_Premium_28
When @YearN=29 then I2_CSM.CSM_GainLoss_Realization_Premium_29
When @YearN=30 then I2_CSM.CSM_GainLoss_Realization_Premium_30
end) as CSM_GainLoss_Realization_Premium,
Sum(Case 
When @YearN=1 then I2_CSM.CSM_GainLoss_Realization_Commission_1
When @YearN=2 then I2_CSM.CSM_GainLoss_Realization_Commission_2
When @YearN=3 then I2_CSM.CSM_GainLoss_Realization_Commission_3
When @YearN=4 then I2_CSM.CSM_GainLoss_Realization_Commission_4
When @YearN=5 then I2_CSM.CSM_GainLoss_Realization_Commission_5
When @YearN=6 then I2_CSM.CSM_GainLoss_Realization_Commission_6
When @YearN=7 then I2_CSM.CSM_GainLoss_Realization_Commission_7
When @YearN=8 then I2_CSM.CSM_GainLoss_Realization_Commission_8
When @YearN=9 then I2_CSM.CSM_GainLoss_Realization_Commission_9
When @YearN=10 then I2_CSM.CSM_GainLoss_Realization_Commission_10
When @YearN=11 then I2_CSM.CSM_GainLoss_Realization_Commission_11
When @YearN=12 then I2_CSM.CSM_GainLoss_Realization_Commission_12
When @YearN=13 then I2_CSM.CSM_GainLoss_Realization_Commission_13
When @YearN=14 then I2_CSM.CSM_GainLoss_Realization_Commission_14
When @YearN=15 then I2_CSM.CSM_GainLoss_Realization_Commission_15
When @YearN=16 then I2_CSM.CSM_GainLoss_Realization_Commission_16
When @YearN=17 then I2_CSM.CSM_GainLoss_Realization_Commission_17
When @YearN=18 then I2_CSM.CSM_GainLoss_Realization_Commission_18
When @YearN=19 then I2_CSM.CSM_GainLoss_Realization_Commission_19
When @YearN=20 then I2_CSM.CSM_GainLoss_Realization_Commission_20
When @YearN=21 then I2_CSM.CSM_GainLoss_Realization_Commission_21
When @YearN=22 then I2_CSM.CSM_GainLoss_Realization_Commission_22
When @YearN=23 then I2_CSM.CSM_GainLoss_Realization_Commission_23
When @YearN=24 then I2_CSM.CSM_GainLoss_Realization_Commission_24
When @YearN=25 then I2_CSM.CSM_GainLoss_Realization_Commission_25
When @YearN=26 then I2_CSM.CSM_GainLoss_Realization_Commission_26
When @YearN=27 then I2_CSM.CSM_GainLoss_Realization_Commission_27
When @YearN=28 then I2_CSM.CSM_GainLoss_Realization_Commission_28
When @YearN=29 then I2_CSM.CSM_GainLoss_Realization_Commission_29
When @YearN=30 then I2_CSM.CSM_GainLoss_Realization_Commission_30
end) as CSM_GainLoss_Realization_Commission,
Sum(Case 
When @YearN=1 then I2_CSM.CSM_GainLoss_NonDiscRate_1
When @YearN=2 then I2_CSM.CSM_GainLoss_NonDiscRate_2
When @YearN=3 then I2_CSM.CSM_GainLoss_NonDiscRate_3
When @YearN=4 then I2_CSM.CSM_GainLoss_NonDiscRate_4
When @YearN=5 then I2_CSM.CSM_GainLoss_NonDiscRate_5
When @YearN=6 then I2_CSM.CSM_GainLoss_NonDiscRate_6
When @YearN=7 then I2_CSM.CSM_GainLoss_NonDiscRate_7
When @YearN=8 then I2_CSM.CSM_GainLoss_NonDiscRate_8
When @YearN=9 then I2_CSM.CSM_GainLoss_NonDiscRate_9
When @YearN=10 then I2_CSM.CSM_GainLoss_NonDiscRate_10
When @YearN=11 then I2_CSM.CSM_GainLoss_NonDiscRate_11
When @YearN=12 then I2_CSM.CSM_GainLoss_NonDiscRate_12
When @YearN=13 then I2_CSM.CSM_GainLoss_NonDiscRate_13
When @YearN=14 then I2_CSM.CSM_GainLoss_NonDiscRate_14
When @YearN=15 then I2_CSM.CSM_GainLoss_NonDiscRate_15
When @YearN=16 then I2_CSM.CSM_GainLoss_NonDiscRate_16
When @YearN=17 then I2_CSM.CSM_GainLoss_NonDiscRate_17
When @YearN=18 then I2_CSM.CSM_GainLoss_NonDiscRate_18
When @YearN=19 then I2_CSM.CSM_GainLoss_NonDiscRate_19
When @YearN=20 then I2_CSM.CSM_GainLoss_NonDiscRate_20
When @YearN=21 then I2_CSM.CSM_GainLoss_NonDiscRate_21
When @YearN=22 then I2_CSM.CSM_GainLoss_NonDiscRate_22
When @YearN=23 then I2_CSM.CSM_GainLoss_NonDiscRate_23
When @YearN=24 then I2_CSM.CSM_GainLoss_NonDiscRate_24
When @YearN=25 then I2_CSM.CSM_GainLoss_NonDiscRate_25
When @YearN=26 then I2_CSM.CSM_GainLoss_NonDiscRate_26
When @YearN=27 then I2_CSM.CSM_GainLoss_NonDiscRate_27
When @YearN=28 then I2_CSM.CSM_GainLoss_NonDiscRate_28
When @YearN=29 then I2_CSM.CSM_GainLoss_NonDiscRate_29
When @YearN=30 then I2_CSM.CSM_GainLoss_NonDiscRate_30
end) as CSM_GainLoss_NonDiscRate,
Sum(Case 
When @YearN=1 then I2_CSM.CSM_End_1
When @YearN=2 then I2_CSM.CSM_End_2
When @YearN=3 then I2_CSM.CSM_End_3
When @YearN=4 then I2_CSM.CSM_End_4
When @YearN=5 then I2_CSM.CSM_End_5
When @YearN=6 then I2_CSM.CSM_End_6
When @YearN=7 then I2_CSM.CSM_End_7
When @YearN=8 then I2_CSM.CSM_End_8
When @YearN=9 then I2_CSM.CSM_End_9
When @YearN=10 then I2_CSM.CSM_End_10
When @YearN=11 then I2_CSM.CSM_End_11
When @YearN=12 then I2_CSM.CSM_End_12
When @YearN=13 then I2_CSM.CSM_End_13
When @YearN=14 then I2_CSM.CSM_End_14
When @YearN=15 then I2_CSM.CSM_End_15
When @YearN=16 then I2_CSM.CSM_End_16
When @YearN=17 then I2_CSM.CSM_End_17
When @YearN=18 then I2_CSM.CSM_End_18
When @YearN=19 then I2_CSM.CSM_End_19
When @YearN=20 then I2_CSM.CSM_End_20
When @YearN=21 then I2_CSM.CSM_End_21
When @YearN=22 then I2_CSM.CSM_End_22
When @YearN=23 then I2_CSM.CSM_End_23
When @YearN=24 then I2_CSM.CSM_End_24
When @YearN=25 then I2_CSM.CSM_End_25
When @YearN=26 then I2_CSM.CSM_End_26
When @YearN=27 then I2_CSM.CSM_End_27
When @YearN=28 then I2_CSM.CSM_End_28
When @YearN=29 then I2_CSM.CSM_End_29
When @YearN=30 then I2_CSM.CSM_End_30
end) as CSM_End,
Sum(Case 
When @YearN=1 then I2_LOSS.Loss_Start_1
When @YearN=2 then I2_LOSS.Loss_Start_2
When @YearN=3 then I2_LOSS.Loss_Start_3
When @YearN=4 then I2_LOSS.Loss_Start_4
When @YearN=5 then I2_LOSS.Loss_Start_5
When @YearN=6 then I2_LOSS.Loss_Start_6
When @YearN=7 then I2_LOSS.Loss_Start_7
When @YearN=8 then I2_LOSS.Loss_Start_8
When @YearN=9 then I2_LOSS.Loss_Start_9
When @YearN=10 then I2_LOSS.Loss_Start_10
When @YearN=11 then I2_LOSS.Loss_Start_11
When @YearN=12 then I2_LOSS.Loss_Start_12
When @YearN=13 then I2_LOSS.Loss_Start_13
When @YearN=14 then I2_LOSS.Loss_Start_14
When @YearN=15 then I2_LOSS.Loss_Start_15
When @YearN=16 then I2_LOSS.Loss_Start_16
When @YearN=17 then I2_LOSS.Loss_Start_17
When @YearN=18 then I2_LOSS.Loss_Start_18
When @YearN=19 then I2_LOSS.Loss_Start_19
When @YearN=20 then I2_LOSS.Loss_Start_20
When @YearN=21 then I2_LOSS.Loss_Start_21
When @YearN=22 then I2_LOSS.Loss_Start_22
When @YearN=23 then I2_LOSS.Loss_Start_23
When @YearN=24 then I2_LOSS.Loss_Start_24
When @YearN=25 then I2_LOSS.Loss_Start_25
When @YearN=26 then I2_LOSS.Loss_Start_26
When @YearN=27 then I2_LOSS.Loss_Start_27
When @YearN=28 then I2_LOSS.Loss_Start_28
When @YearN=29 then I2_LOSS.Loss_Start_29
When @YearN=30 then I2_LOSS.Loss_Start_30
end) as Loss_Start,
Sum(Case 
When @YearN=1 then I2_LOSS.Loss_Portion_from_Claim_Release_1
When @YearN=2 then I2_LOSS.Loss_Portion_from_Claim_Release_2
When @YearN=3 then I2_LOSS.Loss_Portion_from_Claim_Release_3
When @YearN=4 then I2_LOSS.Loss_Portion_from_Claim_Release_4
When @YearN=5 then I2_LOSS.Loss_Portion_from_Claim_Release_5
When @YearN=6 then I2_LOSS.Loss_Portion_from_Claim_Release_6
When @YearN=7 then I2_LOSS.Loss_Portion_from_Claim_Release_7
When @YearN=8 then I2_LOSS.Loss_Portion_from_Claim_Release_8
When @YearN=9 then I2_LOSS.Loss_Portion_from_Claim_Release_9
When @YearN=10 then I2_LOSS.Loss_Portion_from_Claim_Release_10
When @YearN=11 then I2_LOSS.Loss_Portion_from_Claim_Release_11
When @YearN=12 then I2_LOSS.Loss_Portion_from_Claim_Release_12
When @YearN=13 then I2_LOSS.Loss_Portion_from_Claim_Release_13
When @YearN=14 then I2_LOSS.Loss_Portion_from_Claim_Release_14
When @YearN=15 then I2_LOSS.Loss_Portion_from_Claim_Release_15
When @YearN=16 then I2_LOSS.Loss_Portion_from_Claim_Release_16
When @YearN=17 then I2_LOSS.Loss_Portion_from_Claim_Release_17
When @YearN=18 then I2_LOSS.Loss_Portion_from_Claim_Release_18
When @YearN=19 then I2_LOSS.Loss_Portion_from_Claim_Release_19
When @YearN=20 then I2_LOSS.Loss_Portion_from_Claim_Release_20
When @YearN=21 then I2_LOSS.Loss_Portion_from_Claim_Release_21
When @YearN=22 then I2_LOSS.Loss_Portion_from_Claim_Release_22
When @YearN=23 then I2_LOSS.Loss_Portion_from_Claim_Release_23
When @YearN=24 then I2_LOSS.Loss_Portion_from_Claim_Release_24
When @YearN=25 then I2_LOSS.Loss_Portion_from_Claim_Release_25
When @YearN=26 then I2_LOSS.Loss_Portion_from_Claim_Release_26
When @YearN=27 then I2_LOSS.Loss_Portion_from_Claim_Release_27
When @YearN=28 then I2_LOSS.Loss_Portion_from_Claim_Release_28
When @YearN=29 then I2_LOSS.Loss_Portion_from_Claim_Release_29
When @YearN=30 then I2_LOSS.Loss_Portion_from_Claim_Release_30
end) as Loss_Portion_from_Claim_Release,
Sum(Case 
When @YearN=1 then I2_LOSS.Loss_Portion_from_Expense_Release_1
When @YearN=2 then I2_LOSS.Loss_Portion_from_Expense_Release_2
When @YearN=3 then I2_LOSS.Loss_Portion_from_Expense_Release_3
When @YearN=4 then I2_LOSS.Loss_Portion_from_Expense_Release_4
When @YearN=5 then I2_LOSS.Loss_Portion_from_Expense_Release_5
When @YearN=6 then I2_LOSS.Loss_Portion_from_Expense_Release_6
When @YearN=7 then I2_LOSS.Loss_Portion_from_Expense_Release_7
When @YearN=8 then I2_LOSS.Loss_Portion_from_Expense_Release_8
When @YearN=9 then I2_LOSS.Loss_Portion_from_Expense_Release_9
When @YearN=10 then I2_LOSS.Loss_Portion_from_Expense_Release_10
When @YearN=11 then I2_LOSS.Loss_Portion_from_Expense_Release_11
When @YearN=12 then I2_LOSS.Loss_Portion_from_Expense_Release_12
When @YearN=13 then I2_LOSS.Loss_Portion_from_Expense_Release_13
When @YearN=14 then I2_LOSS.Loss_Portion_from_Expense_Release_14
When @YearN=15 then I2_LOSS.Loss_Portion_from_Expense_Release_15
When @YearN=16 then I2_LOSS.Loss_Portion_from_Expense_Release_16
When @YearN=17 then I2_LOSS.Loss_Portion_from_Expense_Release_17
When @YearN=18 then I2_LOSS.Loss_Portion_from_Expense_Release_18
When @YearN=19 then I2_LOSS.Loss_Portion_from_Expense_Release_19
When @YearN=20 then I2_LOSS.Loss_Portion_from_Expense_Release_20
When @YearN=21 then I2_LOSS.Loss_Portion_from_Expense_Release_21
When @YearN=22 then I2_LOSS.Loss_Portion_from_Expense_Release_22
When @YearN=23 then I2_LOSS.Loss_Portion_from_Expense_Release_23
When @YearN=24 then I2_LOSS.Loss_Portion_from_Expense_Release_24
When @YearN=25 then I2_LOSS.Loss_Portion_from_Expense_Release_25
When @YearN=26 then I2_LOSS.Loss_Portion_from_Expense_Release_26
When @YearN=27 then I2_LOSS.Loss_Portion_from_Expense_Release_27
When @YearN=28 then I2_LOSS.Loss_Portion_from_Expense_Release_28
When @YearN=29 then I2_LOSS.Loss_Portion_from_Expense_Release_29
When @YearN=30 then I2_LOSS.Loss_Portion_from_Expense_Release_30
end) as Loss_Portion_from_Expense_Release,
Sum(Case 
When @YearN=1 then I2_LOSS.Loss_Portion_from_Refund_Release_1
When @YearN=2 then I2_LOSS.Loss_Portion_from_Refund_Release_2
When @YearN=3 then I2_LOSS.Loss_Portion_from_Refund_Release_3
When @YearN=4 then I2_LOSS.Loss_Portion_from_Refund_Release_4
When @YearN=5 then I2_LOSS.Loss_Portion_from_Refund_Release_5
When @YearN=6 then I2_LOSS.Loss_Portion_from_Refund_Release_6
When @YearN=7 then I2_LOSS.Loss_Portion_from_Refund_Release_7
When @YearN=8 then I2_LOSS.Loss_Portion_from_Refund_Release_8
When @YearN=9 then I2_LOSS.Loss_Portion_from_Refund_Release_9
When @YearN=10 then I2_LOSS.Loss_Portion_from_Refund_Release_10
When @YearN=11 then I2_LOSS.Loss_Portion_from_Refund_Release_11
When @YearN=12 then I2_LOSS.Loss_Portion_from_Refund_Release_12
When @YearN=13 then I2_LOSS.Loss_Portion_from_Refund_Release_13
When @YearN=14 then I2_LOSS.Loss_Portion_from_Refund_Release_14
When @YearN=15 then I2_LOSS.Loss_Portion_from_Refund_Release_15
When @YearN=16 then I2_LOSS.Loss_Portion_from_Refund_Release_16
When @YearN=17 then I2_LOSS.Loss_Portion_from_Refund_Release_17
When @YearN=18 then I2_LOSS.Loss_Portion_from_Refund_Release_18
When @YearN=19 then I2_LOSS.Loss_Portion_from_Refund_Release_19
When @YearN=20 then I2_LOSS.Loss_Portion_from_Refund_Release_20
When @YearN=21 then I2_LOSS.Loss_Portion_from_Refund_Release_21
When @YearN=22 then I2_LOSS.Loss_Portion_from_Refund_Release_22
When @YearN=23 then I2_LOSS.Loss_Portion_from_Refund_Release_23
When @YearN=24 then I2_LOSS.Loss_Portion_from_Refund_Release_24
When @YearN=25 then I2_LOSS.Loss_Portion_from_Refund_Release_25
When @YearN=26 then I2_LOSS.Loss_Portion_from_Refund_Release_26
When @YearN=27 then I2_LOSS.Loss_Portion_from_Refund_Release_27
When @YearN=28 then I2_LOSS.Loss_Portion_from_Refund_Release_28
When @YearN=29 then I2_LOSS.Loss_Portion_from_Refund_Release_29
When @YearN=30 then I2_LOSS.Loss_Portion_from_Refund_Release_30
end) as Loss_Portion_from_Refund_Release,
Sum(Case 
When @YearN=1 then I2_LOSS.Loss_Portion_from_RA_Release_1
When @YearN=2 then I2_LOSS.Loss_Portion_from_RA_Release_2
When @YearN=3 then I2_LOSS.Loss_Portion_from_RA_Release_3
When @YearN=4 then I2_LOSS.Loss_Portion_from_RA_Release_4
When @YearN=5 then I2_LOSS.Loss_Portion_from_RA_Release_5
When @YearN=6 then I2_LOSS.Loss_Portion_from_RA_Release_6
When @YearN=7 then I2_LOSS.Loss_Portion_from_RA_Release_7
When @YearN=8 then I2_LOSS.Loss_Portion_from_RA_Release_8
When @YearN=9 then I2_LOSS.Loss_Portion_from_RA_Release_9
When @YearN=10 then I2_LOSS.Loss_Portion_from_RA_Release_10
When @YearN=11 then I2_LOSS.Loss_Portion_from_RA_Release_11
When @YearN=12 then I2_LOSS.Loss_Portion_from_RA_Release_12
When @YearN=13 then I2_LOSS.Loss_Portion_from_RA_Release_13
When @YearN=14 then I2_LOSS.Loss_Portion_from_RA_Release_14
When @YearN=15 then I2_LOSS.Loss_Portion_from_RA_Release_15
When @YearN=16 then I2_LOSS.Loss_Portion_from_RA_Release_16
When @YearN=17 then I2_LOSS.Loss_Portion_from_RA_Release_17
When @YearN=18 then I2_LOSS.Loss_Portion_from_RA_Release_18
When @YearN=19 then I2_LOSS.Loss_Portion_from_RA_Release_19
When @YearN=20 then I2_LOSS.Loss_Portion_from_RA_Release_20
When @YearN=21 then I2_LOSS.Loss_Portion_from_RA_Release_21
When @YearN=22 then I2_LOSS.Loss_Portion_from_RA_Release_22
When @YearN=23 then I2_LOSS.Loss_Portion_from_RA_Release_23
When @YearN=24 then I2_LOSS.Loss_Portion_from_RA_Release_24
When @YearN=25 then I2_LOSS.Loss_Portion_from_RA_Release_25
When @YearN=26 then I2_LOSS.Loss_Portion_from_RA_Release_26
When @YearN=27 then I2_LOSS.Loss_Portion_from_RA_Release_27
When @YearN=28 then I2_LOSS.Loss_Portion_from_RA_Release_28
When @YearN=29 then I2_LOSS.Loss_Portion_from_RA_Release_29
When @YearN=30 then I2_LOSS.Loss_Portion_from_RA_Release_30
end) as Loss_Portion_from_RA_Release,
Sum(Case 
When @YearN=1 then I2_LOSS.Loss_Portion_from_Interest_Accrete_1
When @YearN=2 then I2_LOSS.Loss_Portion_from_Interest_Accrete_2
When @YearN=3 then I2_LOSS.Loss_Portion_from_Interest_Accrete_3
When @YearN=4 then I2_LOSS.Loss_Portion_from_Interest_Accrete_4
When @YearN=5 then I2_LOSS.Loss_Portion_from_Interest_Accrete_5
When @YearN=6 then I2_LOSS.Loss_Portion_from_Interest_Accrete_6
When @YearN=7 then I2_LOSS.Loss_Portion_from_Interest_Accrete_7
When @YearN=8 then I2_LOSS.Loss_Portion_from_Interest_Accrete_8
When @YearN=9 then I2_LOSS.Loss_Portion_from_Interest_Accrete_9
When @YearN=10 then I2_LOSS.Loss_Portion_from_Interest_Accrete_10
When @YearN=11 then I2_LOSS.Loss_Portion_from_Interest_Accrete_11
When @YearN=12 then I2_LOSS.Loss_Portion_from_Interest_Accrete_12
When @YearN=13 then I2_LOSS.Loss_Portion_from_Interest_Accrete_13
When @YearN=14 then I2_LOSS.Loss_Portion_from_Interest_Accrete_14
When @YearN=15 then I2_LOSS.Loss_Portion_from_Interest_Accrete_15
When @YearN=16 then I2_LOSS.Loss_Portion_from_Interest_Accrete_16
When @YearN=17 then I2_LOSS.Loss_Portion_from_Interest_Accrete_17
When @YearN=18 then I2_LOSS.Loss_Portion_from_Interest_Accrete_18
When @YearN=19 then I2_LOSS.Loss_Portion_from_Interest_Accrete_19
When @YearN=20 then I2_LOSS.Loss_Portion_from_Interest_Accrete_20
When @YearN=21 then I2_LOSS.Loss_Portion_from_Interest_Accrete_21
When @YearN=22 then I2_LOSS.Loss_Portion_from_Interest_Accrete_22
When @YearN=23 then I2_LOSS.Loss_Portion_from_Interest_Accrete_23
When @YearN=24 then I2_LOSS.Loss_Portion_from_Interest_Accrete_24
When @YearN=25 then I2_LOSS.Loss_Portion_from_Interest_Accrete_25
When @YearN=26 then I2_LOSS.Loss_Portion_from_Interest_Accrete_26
When @YearN=27 then I2_LOSS.Loss_Portion_from_Interest_Accrete_27
When @YearN=28 then I2_LOSS.Loss_Portion_from_Interest_Accrete_28
When @YearN=29 then I2_LOSS.Loss_Portion_from_Interest_Accrete_29
When @YearN=30 then I2_LOSS.Loss_Portion_from_Interest_Accrete_30
end) as Loss_Portion_from_Interest_Accrete,
Sum(Case 
When @YearN=1 then I2_LOSS.Loss_GainLoss_Realization_Premium_1
When @YearN=2 then I2_LOSS.Loss_GainLoss_Realization_Premium_2
When @YearN=3 then I2_LOSS.Loss_GainLoss_Realization_Premium_3
When @YearN=4 then I2_LOSS.Loss_GainLoss_Realization_Premium_4
When @YearN=5 then I2_LOSS.Loss_GainLoss_Realization_Premium_5
When @YearN=6 then I2_LOSS.Loss_GainLoss_Realization_Premium_6
When @YearN=7 then I2_LOSS.Loss_GainLoss_Realization_Premium_7
When @YearN=8 then I2_LOSS.Loss_GainLoss_Realization_Premium_8
When @YearN=9 then I2_LOSS.Loss_GainLoss_Realization_Premium_9
When @YearN=10 then I2_LOSS.Loss_GainLoss_Realization_Premium_10
When @YearN=11 then I2_LOSS.Loss_GainLoss_Realization_Premium_11
When @YearN=12 then I2_LOSS.Loss_GainLoss_Realization_Premium_12
When @YearN=13 then I2_LOSS.Loss_GainLoss_Realization_Premium_13
When @YearN=14 then I2_LOSS.Loss_GainLoss_Realization_Premium_14
When @YearN=15 then I2_LOSS.Loss_GainLoss_Realization_Premium_15
When @YearN=16 then I2_LOSS.Loss_GainLoss_Realization_Premium_16
When @YearN=17 then I2_LOSS.Loss_GainLoss_Realization_Premium_17
When @YearN=18 then I2_LOSS.Loss_GainLoss_Realization_Premium_18
When @YearN=19 then I2_LOSS.Loss_GainLoss_Realization_Premium_19
When @YearN=20 then I2_LOSS.Loss_GainLoss_Realization_Premium_20
When @YearN=21 then I2_LOSS.Loss_GainLoss_Realization_Premium_21
When @YearN=22 then I2_LOSS.Loss_GainLoss_Realization_Premium_22
When @YearN=23 then I2_LOSS.Loss_GainLoss_Realization_Premium_23
When @YearN=24 then I2_LOSS.Loss_GainLoss_Realization_Premium_24
When @YearN=25 then I2_LOSS.Loss_GainLoss_Realization_Premium_25
When @YearN=26 then I2_LOSS.Loss_GainLoss_Realization_Premium_26
When @YearN=27 then I2_LOSS.Loss_GainLoss_Realization_Premium_27
When @YearN=28 then I2_LOSS.Loss_GainLoss_Realization_Premium_28
When @YearN=29 then I2_LOSS.Loss_GainLoss_Realization_Premium_29
When @YearN=30 then I2_LOSS.Loss_GainLoss_Realization_Premium_30
end) as Loss_GainLoss_Realization_Premium,
Sum(Case 
When @YearN=1 then I2_LOSS.Loss_GainLoss_Realization_Commission_1
When @YearN=2 then I2_LOSS.Loss_GainLoss_Realization_Commission_2
When @YearN=3 then I2_LOSS.Loss_GainLoss_Realization_Commission_3
When @YearN=4 then I2_LOSS.Loss_GainLoss_Realization_Commission_4
When @YearN=5 then I2_LOSS.Loss_GainLoss_Realization_Commission_5
When @YearN=6 then I2_LOSS.Loss_GainLoss_Realization_Commission_6
When @YearN=7 then I2_LOSS.Loss_GainLoss_Realization_Commission_7
When @YearN=8 then I2_LOSS.Loss_GainLoss_Realization_Commission_8
When @YearN=9 then I2_LOSS.Loss_GainLoss_Realization_Commission_9
When @YearN=10 then I2_LOSS.Loss_GainLoss_Realization_Commission_10
When @YearN=11 then I2_LOSS.Loss_GainLoss_Realization_Commission_11
When @YearN=12 then I2_LOSS.Loss_GainLoss_Realization_Commission_12
When @YearN=13 then I2_LOSS.Loss_GainLoss_Realization_Commission_13
When @YearN=14 then I2_LOSS.Loss_GainLoss_Realization_Commission_14
When @YearN=15 then I2_LOSS.Loss_GainLoss_Realization_Commission_15
When @YearN=16 then I2_LOSS.Loss_GainLoss_Realization_Commission_16
When @YearN=17 then I2_LOSS.Loss_GainLoss_Realization_Commission_17
When @YearN=18 then I2_LOSS.Loss_GainLoss_Realization_Commission_18
When @YearN=19 then I2_LOSS.Loss_GainLoss_Realization_Commission_19
When @YearN=20 then I2_LOSS.Loss_GainLoss_Realization_Commission_20
When @YearN=21 then I2_LOSS.Loss_GainLoss_Realization_Commission_21
When @YearN=22 then I2_LOSS.Loss_GainLoss_Realization_Commission_22
When @YearN=23 then I2_LOSS.Loss_GainLoss_Realization_Commission_23
When @YearN=24 then I2_LOSS.Loss_GainLoss_Realization_Commission_24
When @YearN=25 then I2_LOSS.Loss_GainLoss_Realization_Commission_25
When @YearN=26 then I2_LOSS.Loss_GainLoss_Realization_Commission_26
When @YearN=27 then I2_LOSS.Loss_GainLoss_Realization_Commission_27
When @YearN=28 then I2_LOSS.Loss_GainLoss_Realization_Commission_28
When @YearN=29 then I2_LOSS.Loss_GainLoss_Realization_Commission_29
When @YearN=30 then I2_LOSS.Loss_GainLoss_Realization_Commission_30
end) as Loss_GainLoss_Realization_Commission,
Sum(Case 
When @YearN=1 then I2_LOSS.Loss_Portion_from_GainLoss_DiscRate_1
When @YearN=2 then I2_LOSS.Loss_Portion_from_GainLoss_DiscRate_2
When @YearN=3 then I2_LOSS.Loss_Portion_from_GainLoss_DiscRate_3
When @YearN=4 then I2_LOSS.Loss_Portion_from_GainLoss_DiscRate_4
When @YearN=5 then I2_LOSS.Loss_Portion_from_GainLoss_DiscRate_5
When @YearN=6 then I2_LOSS.Loss_Portion_from_GainLoss_DiscRate_6
When @YearN=7 then I2_LOSS.Loss_Portion_from_GainLoss_DiscRate_7
When @YearN=8 then I2_LOSS.Loss_Portion_from_GainLoss_DiscRate_8
When @YearN=9 then I2_LOSS.Loss_Portion_from_GainLoss_DiscRate_9
When @YearN=10 then I2_LOSS.Loss_Portion_from_GainLoss_DiscRate_10
When @YearN=11 then I2_LOSS.Loss_Portion_from_GainLoss_DiscRate_11
When @YearN=12 then I2_LOSS.Loss_Portion_from_GainLoss_DiscRate_12
When @YearN=13 then I2_LOSS.Loss_Portion_from_GainLoss_DiscRate_13
When @YearN=14 then I2_LOSS.Loss_Portion_from_GainLoss_DiscRate_14
When @YearN=15 then I2_LOSS.Loss_Portion_from_GainLoss_DiscRate_15
When @YearN=16 then I2_LOSS.Loss_Portion_from_GainLoss_DiscRate_16
When @YearN=17 then I2_LOSS.Loss_Portion_from_GainLoss_DiscRate_17
When @YearN=18 then I2_LOSS.Loss_Portion_from_GainLoss_DiscRate_18
When @YearN=19 then I2_LOSS.Loss_Portion_from_GainLoss_DiscRate_19
When @YearN=20 then I2_LOSS.Loss_Portion_from_GainLoss_DiscRate_20
When @YearN=21 then I2_LOSS.Loss_Portion_from_GainLoss_DiscRate_21
When @YearN=22 then I2_LOSS.Loss_Portion_from_GainLoss_DiscRate_22
When @YearN=23 then I2_LOSS.Loss_Portion_from_GainLoss_DiscRate_23
When @YearN=24 then I2_LOSS.Loss_Portion_from_GainLoss_DiscRate_24
When @YearN=25 then I2_LOSS.Loss_Portion_from_GainLoss_DiscRate_25
When @YearN=26 then I2_LOSS.Loss_Portion_from_GainLoss_DiscRate_26
When @YearN=27 then I2_LOSS.Loss_Portion_from_GainLoss_DiscRate_27
When @YearN=28 then I2_LOSS.Loss_Portion_from_GainLoss_DiscRate_28
When @YearN=29 then I2_LOSS.Loss_Portion_from_GainLoss_DiscRate_29
When @YearN=30 then I2_LOSS.Loss_Portion_from_GainLoss_DiscRate_30
end) as Loss_Portion_from_GainLoss_DiscRate,
Sum(Case 
When @YearN=1 then I2_LOSS.Loss_GainLoss_NonDiscRate_1
When @YearN=2 then I2_LOSS.Loss_GainLoss_NonDiscRate_2
When @YearN=3 then I2_LOSS.Loss_GainLoss_NonDiscRate_3
When @YearN=4 then I2_LOSS.Loss_GainLoss_NonDiscRate_4
When @YearN=5 then I2_LOSS.Loss_GainLoss_NonDiscRate_5
When @YearN=6 then I2_LOSS.Loss_GainLoss_NonDiscRate_6
When @YearN=7 then I2_LOSS.Loss_GainLoss_NonDiscRate_7
When @YearN=8 then I2_LOSS.Loss_GainLoss_NonDiscRate_8
When @YearN=9 then I2_LOSS.Loss_GainLoss_NonDiscRate_9
When @YearN=10 then I2_LOSS.Loss_GainLoss_NonDiscRate_10
When @YearN=11 then I2_LOSS.Loss_GainLoss_NonDiscRate_11
When @YearN=12 then I2_LOSS.Loss_GainLoss_NonDiscRate_12
When @YearN=13 then I2_LOSS.Loss_GainLoss_NonDiscRate_13
When @YearN=14 then I2_LOSS.Loss_GainLoss_NonDiscRate_14
When @YearN=15 then I2_LOSS.Loss_GainLoss_NonDiscRate_15
When @YearN=16 then I2_LOSS.Loss_GainLoss_NonDiscRate_16
When @YearN=17 then I2_LOSS.Loss_GainLoss_NonDiscRate_17
When @YearN=18 then I2_LOSS.Loss_GainLoss_NonDiscRate_18
When @YearN=19 then I2_LOSS.Loss_GainLoss_NonDiscRate_19
When @YearN=20 then I2_LOSS.Loss_GainLoss_NonDiscRate_20
When @YearN=21 then I2_LOSS.Loss_GainLoss_NonDiscRate_21
When @YearN=22 then I2_LOSS.Loss_GainLoss_NonDiscRate_22
When @YearN=23 then I2_LOSS.Loss_GainLoss_NonDiscRate_23
When @YearN=24 then I2_LOSS.Loss_GainLoss_NonDiscRate_24
When @YearN=25 then I2_LOSS.Loss_GainLoss_NonDiscRate_25
When @YearN=26 then I2_LOSS.Loss_GainLoss_NonDiscRate_26
When @YearN=27 then I2_LOSS.Loss_GainLoss_NonDiscRate_27
When @YearN=28 then I2_LOSS.Loss_GainLoss_NonDiscRate_28
When @YearN=29 then I2_LOSS.Loss_GainLoss_NonDiscRate_29
When @YearN=30 then I2_LOSS.Loss_GainLoss_NonDiscRate_30
end) as Loss_GainLoss_NonDiscRate,
Sum(Case 
When @YearN=1 then I2_LOSS.Loss_End_1
When @YearN=2 then I2_LOSS.Loss_End_2
When @YearN=3 then I2_LOSS.Loss_End_3
When @YearN=4 then I2_LOSS.Loss_End_4
When @YearN=5 then I2_LOSS.Loss_End_5
When @YearN=6 then I2_LOSS.Loss_End_6
When @YearN=7 then I2_LOSS.Loss_End_7
When @YearN=8 then I2_LOSS.Loss_End_8
When @YearN=9 then I2_LOSS.Loss_End_9
When @YearN=10 then I2_LOSS.Loss_End_10
When @YearN=11 then I2_LOSS.Loss_End_11
When @YearN=12 then I2_LOSS.Loss_End_12
When @YearN=13 then I2_LOSS.Loss_End_13
When @YearN=14 then I2_LOSS.Loss_End_14
When @YearN=15 then I2_LOSS.Loss_End_15
When @YearN=16 then I2_LOSS.Loss_End_16
When @YearN=17 then I2_LOSS.Loss_End_17
When @YearN=18 then I2_LOSS.Loss_End_18
When @YearN=19 then I2_LOSS.Loss_End_19
When @YearN=20 then I2_LOSS.Loss_End_20
When @YearN=21 then I2_LOSS.Loss_End_21
When @YearN=22 then I2_LOSS.Loss_End_22
When @YearN=23 then I2_LOSS.Loss_End_23
When @YearN=24 then I2_LOSS.Loss_End_24
When @YearN=25 then I2_LOSS.Loss_End_25
When @YearN=26 then I2_LOSS.Loss_End_26
When @YearN=27 then I2_LOSS.Loss_End_27
When @YearN=28 then I2_LOSS.Loss_End_28
When @YearN=29 then I2_LOSS.Loss_End_29
When @YearN=30 then I2_LOSS.Loss_End_30
end) as Loss_End,
Sum(Case 
When @YearN=1 then I2_LOSS.Loss_Percentage_1
When @YearN=2 then I2_LOSS.Loss_Percentage_2
When @YearN=3 then I2_LOSS.Loss_Percentage_3
When @YearN=4 then I2_LOSS.Loss_Percentage_4
When @YearN=5 then I2_LOSS.Loss_Percentage_5
When @YearN=6 then I2_LOSS.Loss_Percentage_6
When @YearN=7 then I2_LOSS.Loss_Percentage_7
When @YearN=8 then I2_LOSS.Loss_Percentage_8
When @YearN=9 then I2_LOSS.Loss_Percentage_9
When @YearN=10 then I2_LOSS.Loss_Percentage_10
When @YearN=11 then I2_LOSS.Loss_Percentage_11
When @YearN=12 then I2_LOSS.Loss_Percentage_12
When @YearN=13 then I2_LOSS.Loss_Percentage_13
When @YearN=14 then I2_LOSS.Loss_Percentage_14
When @YearN=15 then I2_LOSS.Loss_Percentage_15
When @YearN=16 then I2_LOSS.Loss_Percentage_16
When @YearN=17 then I2_LOSS.Loss_Percentage_17
When @YearN=18 then I2_LOSS.Loss_Percentage_18
When @YearN=19 then I2_LOSS.Loss_Percentage_19
When @YearN=20 then I2_LOSS.Loss_Percentage_20
When @YearN=21 then I2_LOSS.Loss_Percentage_21
When @YearN=22 then I2_LOSS.Loss_Percentage_22
When @YearN=23 then I2_LOSS.Loss_Percentage_23
When @YearN=24 then I2_LOSS.Loss_Percentage_24
When @YearN=25 then I2_LOSS.Loss_Percentage_25
When @YearN=26 then I2_LOSS.Loss_Percentage_26
When @YearN=27 then I2_LOSS.Loss_Percentage_27
When @YearN=28 then I2_LOSS.Loss_Percentage_28
When @YearN=29 then I2_LOSS.Loss_Percentage_29
When @YearN=30 then I2_LOSS.Loss_Percentage_30
end) as Loss_Percentage,
Sum(Case 
When @YearN=1 then I2.ACQ_Amortization_1
When @YearN=2 then I2.ACQ_Amortization_2
When @YearN=3 then I2.ACQ_Amortization_3
When @YearN=4 then I2.ACQ_Amortization_4
When @YearN=5 then I2.ACQ_Amortization_5
When @YearN=6 then I2.ACQ_Amortization_6
When @YearN=7 then I2.ACQ_Amortization_7
When @YearN=8 then I2.ACQ_Amortization_8
When @YearN=9 then I2.ACQ_Amortization_9
When @YearN=10 then I2.ACQ_Amortization_10
When @YearN=11 then I2.ACQ_Amortization_11
When @YearN=12 then I2.ACQ_Amortization_12
When @YearN=13 then I2.ACQ_Amortization_13
When @YearN=14 then I2.ACQ_Amortization_14
When @YearN=15 then I2.ACQ_Amortization_15
When @YearN=16 then I2.ACQ_Amortization_16
When @YearN=17 then I2.ACQ_Amortization_17
When @YearN=18 then I2.ACQ_Amortization_18
When @YearN=19 then I2.ACQ_Amortization_19
When @YearN=20 then I2.ACQ_Amortization_20
When @YearN=21 then I2.ACQ_Amortization_21
When @YearN=22 then I2.ACQ_Amortization_22
When @YearN=23 then I2.ACQ_Amortization_23
When @YearN=24 then I2.ACQ_Amortization_24
When @YearN=25 then I2.ACQ_Amortization_25
When @YearN=26 then I2.ACQ_Amortization_26
When @YearN=27 then I2.ACQ_Amortization_27
When @YearN=28 then I2.ACQ_Amortization_28
When @YearN=29 then I2.ACQ_Amortization_29
When @YearN=30 then I2.ACQ_Amortization_30
end) as ACQ_Amortization,
Sum(Case 
When @YearN=1 then I2_CSM.CSM_Start_2
When @YearN=2 then I2_CSM.CSM_Start_3
When @YearN=3 then I2_CSM.CSM_Start_4
When @YearN=4 then I2_CSM.CSM_Start_5
When @YearN=5 then I2_CSM.CSM_Start_6
When @YearN=6 then I2_CSM.CSM_Start_7
When @YearN=7 then I2_CSM.CSM_Start_8
When @YearN=8 then I2_CSM.CSM_Start_9
When @YearN=9 then I2_CSM.CSM_Start_10
When @YearN=10 then I2_CSM.CSM_Start_11
When @YearN=11 then I2_CSM.CSM_Start_12
When @YearN=12 then I2_CSM.CSM_Start_13
When @YearN=13 then I2_CSM.CSM_Start_14
When @YearN=14 then I2_CSM.CSM_Start_15
When @YearN=15 then I2_CSM.CSM_Start_16
When @YearN=16 then I2_CSM.CSM_Start_17
When @YearN=17 then I2_CSM.CSM_Start_18
When @YearN=18 then I2_CSM.CSM_Start_19
When @YearN=19 then I2_CSM.CSM_Start_20
When @YearN=20 then I2_CSM.CSM_Start_21
When @YearN=21 then I2_CSM.CSM_Start_22
When @YearN=22 then I2_CSM.CSM_Start_23
When @YearN=23 then I2_CSM.CSM_Start_24
When @YearN=24 then I2_CSM.CSM_Start_25
When @YearN=25 then I2_CSM.CSM_Start_26
When @YearN=26 then I2_CSM.CSM_Start_27
When @YearN=27 then I2_CSM.CSM_Start_28
When @YearN=28 then I2_CSM.CSM_Start_29
When @YearN=29 then I2_CSM.CSM_Start_30
When @YearN=30 then 0
end) as CSM_Start_N,
Sum(Case 
When @YearN=1 then I2_LOSS.Loss_Start_2
When @YearN=2 then I2_LOSS.Loss_Start_3
When @YearN=3 then I2_LOSS.Loss_Start_4
When @YearN=4 then I2_LOSS.Loss_Start_5
When @YearN=5 then I2_LOSS.Loss_Start_6
When @YearN=6 then I2_LOSS.Loss_Start_7
When @YearN=7 then I2_LOSS.Loss_Start_8
When @YearN=8 then I2_LOSS.Loss_Start_9
When @YearN=9 then I2_LOSS.Loss_Start_10
When @YearN=10 then I2_LOSS.Loss_Start_11
When @YearN=11 then I2_LOSS.Loss_Start_12
When @YearN=12 then I2_LOSS.Loss_Start_13
When @YearN=13 then I2_LOSS.Loss_Start_14
When @YearN=14 then I2_LOSS.Loss_Start_15
When @YearN=15 then I2_LOSS.Loss_Start_16
When @YearN=16 then I2_LOSS.Loss_Start_17
When @YearN=17 then I2_LOSS.Loss_Start_18
When @YearN=18 then I2_LOSS.Loss_Start_19
When @YearN=19 then I2_LOSS.Loss_Start_20
When @YearN=20 then I2_LOSS.Loss_Start_21
When @YearN=21 then I2_LOSS.Loss_Start_22
When @YearN=22 then I2_LOSS.Loss_Start_23
When @YearN=23 then I2_LOSS.Loss_Start_24
When @YearN=24 then I2_LOSS.Loss_Start_25
When @YearN=25 then I2_LOSS.Loss_Start_26
When @YearN=26 then I2_LOSS.Loss_Start_27
When @YearN=27 then I2_LOSS.Loss_Start_28
When @YearN=28 then I2_LOSS.Loss_Start_29
When @YearN=29 then I2_LOSS.Loss_Start_30
When @YearN=30 then 0
end) as Loss_Start_N
from IFRS_Calculation I1
Inner join IFRS_Calculation_Detail I2 on (I2.GroupID=I1.GroupID and I2.GroupType=@GroupType)
Inner join IFRS_Calculation_Detail_BEL I2_BEL on (I2_BEL.GroupID=I2.GroupID and I2_BEL.GroupType=I2.GroupType and I2_BEL.EffYear=I2.EffYear and I2_BEL.EffMonth=I2.EffMonth)
Inner join IFRS_Calculation_Detail_RA I2_RA on (I2_RA.GroupID=I2.GroupID and I2_RA.GroupType=I2.GroupType and I2_RA.EffYear=I2.EffYear and I2_RA.EffMonth=I2.EffMonth)
Inner join IFRS_Calculation_Detail_CSM I2_CSM on (I2_CSM.GroupID=I2.GroupID and I2_CSM.GroupType=I2.GroupType and I2_CSM.EffYear=I2.EffYear and I2_CSM.EffMonth=I2.EffMonth)
Inner join IFRS_Calculation_Detail_LOSS I2_LOSS on (I2_LOSS.GroupID=I2.GroupID and I2_LOSS.GroupType=I2.GroupType and I2_LOSS.EffYear=I2.EffYear and I2_LOSS.EffMonth=I2.EffMonth)
Where I1.GroupID=@GroupID 


Select 'BEL_Beginning'as Description,  BEL_Beginning as Nominal from @IFRS Where @Method='B' Union All
Select 'BEL_Premium_Expected'as Description,  BEL_Premium_Expected as Nominal from @IFRS Where @Method='B' Union All
Select 'BEL_Commission_Expected'as Description,  BEL_Commission_Expected as Nominal from @IFRS Where @Method='B' Union All
Select 'BEL_Interest_Accrete'as Description,  BEL_Interest_Accrete as Nominal from @IFRS Where @Method='B' Union All
Select 'BEL_Claim_Expected'as Description,  BEL_Claim_Expected as Nominal from @IFRS Where @Method='B' Union All
Select 'BEL_Expense_Expected'as Description,  BEL_Expense_Expected as Nominal from @IFRS Where @Method='B' Union All
Select 'BEL_Refund_Expected'as Description,  BEL_Refund_Expected as Nominal from @IFRS Where @Method='B' Union All
Select 'BEL_Ending_Before_Change'as Description,  BEL_Ending_Before_Change as Nominal from @IFRS Where @Method='B' Union All
Select 'BEL_GainLoss_NonDiscRate'as Description,  BEL_GainLoss_NonDiscRate as Nominal from @IFRS Where @Method='B' Union All
Select 'BEL_Ending_After_Change_NonDiscRate'as Description,  BEL_Ending_After_Change_NonDiscRate as Nominal from @IFRS Where @Method='B' Union All
Select 'BEL_GainLoss_DiscRate'as Description,  BEL_GainLoss_DiscRate as Nominal from @IFRS Where @Method='B' Union All
Select 'BEL_Ending_After_Change_DiscRate'as Description,  BEL_Ending_After_Change_DiscRate as Nominal from @IFRS Where @Method='B' Union All
Select 'RA_Beginning'as Description,  RA_Beginning as Nominal from @IFRS Where @Method='B' Union All
Select 'RA_Interest_Accrete'as Description,  RA_Interest_Accrete as Nominal from @IFRS Where @Method='B' Union All
Select 'RA_Release'as Description,  RA_Release as Nominal from @IFRS Where @Method='B' Union All
Select 'RA_Ending_Before_Change'as Description,  RA_Ending_Before_Change as Nominal from @IFRS Where @Method='B' Union All
Select 'RA_GainLoss_NonDiscRate'as Description,  RA_GainLoss_NonDiscRate as Nominal from @IFRS Where @Method='B' Union All
Select 'RA_Ending_After_Change_NonDiscRate'as Description,  RA_Ending_After_Change_NonDiscRate as Nominal from @IFRS Where @Method='B' Union All
Select 'RA_GainLoss_DiscRate'as Description,  RA_GainLoss_DiscRate as Nominal from @IFRS Where @Method='B' Union All
Select 'RA_Ending_After_Change_DiscRate'as Description,  RA_Ending_After_Change_DiscRate as Nominal from @IFRS Where @Method='B' Union All

Select 'CSM_Start'as Description,  CSM_Start as Nominal from @IFRS Where (@Method='B') and (@OneRous=0 or CSM_Start<>0) Union All
Select 'CSM_Interest_Accrete'as Description,  CSM_Interest_Accrete as Nominal from @IFRS Where (@Method='B' and @OneRous=0) or CSM_Interest_Accrete<>0 Union All

Select 'CSM_Amortization'as Description,  CSM_Amortization + (Case When @YearN*12<=@MonthN and not ((@Method='B' and @OneRous=1 and CSM_End<>0) or (@Method='B' and @OneRous=0 and LOSS_End<>0)) then (CSM_Start_N-CSM_End) else 0 end) as Nominal from @IFRS Where (@Method='B') and (@OneRous=0 or CSM_Amortization<>0) Union All

Select 'CSM_GainLoss_Realization_Premium'as Description,  CSM_GainLoss_Realization_Premium as Nominal from @IFRS Where (@Method='B' and @OneRous=0) or CSM_GainLoss_Realization_Premium<>0 Union All
Select 'CSM_GainLoss_Realization_Commission'as Description,  CSM_GainLoss_Realization_Commission as Nominal from @IFRS Where (@Method='B' and @OneRous=0) or CSM_GainLoss_Realization_Commission<>0 Union All
Select 'CSM_GainLoss_NonDiscRate'as Description,  CSM_GainLoss_NonDiscRate as Nominal from @IFRS Where (@Method='B' and @OneRous=0) or CSM_GainLoss_NonDiscRate<>0 Union All

Select 'CSM_Adjustment' as Description, (Case When @YearN*12<=@MonthN then (CSM_Start_N-CSM_End) else 0 end) from @IFRS Where (Case When @YearN*12<=@MonthN then (CSM_Start_N-CSM_End) else 0 end)<>0 and ((@Method='B' and @OneRous=1 and CSM_End<>0) or (@Method='B' and @OneRous=0 and LOSS_End<>0)) Union All
Select 'CSM_End'as Description,  CSM_End + (Case When @YearN*12<=@MonthN then (CSM_Start_N-CSM_End) else 0 end) as Nominal from @IFRS Where (@Method='B') and (@OneRous=0 or CSM_End<>0) Union All

Select 'PAA_Premium_Expected'as Description,  BEL_Premium_Expected as Nominal from @IFRS Where @Method='P' Union All
Select 'PAA_Commission_Expected'as Description,  BEL_Commission_Expected as Nominal from @IFRS Where @Method='P' Union All
Select 'PAA_Amortization'as Description,  CSM_Amortization as Nominal from @IFRS Where @Method='P' Union All
Select 'PAA_GainLoss_Realization_Premium'as Description,  CSM_GainLoss_Realization_Premium as Nominal from @IFRS Where @Method='P' Union All
Select 'PAA_GainLoss_Realization_Commission'as Description,  CSM_GainLoss_Realization_Commission as Nominal from @IFRS Where @Method='P'  Union All

Select 'Loss_Start'as Description,  Loss_Start as Nominal from @IFRS Where (@Method='B' and @OneRous=1) or Loss_Start<>0 Union All
Select 'Loss_Portion_from_Claim_Release'as Description,  Loss_Portion_from_Claim_Release as Nominal from @IFRS Where (@Method='B' and @OneRous=1) or Loss_Portion_from_Claim_Release<>0 Union All
Select 'Loss_Portion_from_Expense_Release'as Description,  Loss_Portion_from_Expense_Release as Nominal from @IFRS Where (@Method='B' and @OneRous=1) or Loss_Portion_from_Expense_Release<>0 Union All
Select 'Loss_Portion_from_Refund_Release'as Description,  Loss_Portion_from_Refund_Release as Nominal from @IFRS Where (@Method='B' and @OneRous=1) or Loss_Portion_from_Refund_Release<>0 Union All
Select 'Loss_Portion_from_RA_Release'as Description,  Loss_Portion_from_RA_Release as Nominal from @IFRS Where (@Method='B' and @OneRous=1) or Loss_Portion_from_RA_Release<>0 Union All
Select 'Loss_Portion_from_Interest_Accrete'as Description,  Loss_Portion_from_Interest_Accrete as Nominal from @IFRS Where (@Method='B' and @OneRous=1) or Loss_Portion_from_Interest_Accrete<>0 Union All
Select 'Loss_GainLoss_Realization_Premium'as Description,  Loss_GainLoss_Realization_Premium as Nominal from @IFRS Where (@Method='B' and @OneRous=1) or Loss_GainLoss_Realization_Premium<>0 Union All
Select 'Loss_GainLoss_Realization_Commission'as Description,  Loss_GainLoss_Realization_Commission as Nominal from @IFRS Where (@Method='B' and @OneRous=1) or Loss_GainLoss_Realization_Commission<>0 Union All
Select 'Loss_Portion_from_GainLoss_DiscRate'as Description,  Loss_Portion_from_GainLoss_DiscRate as Nominal from @IFRS Where (@Method='B' and @OneRous=1) or Loss_Portion_from_GainLoss_DiscRate<>0 Union All
Select 'Loss_GainLoss_NonDiscRate'as Description,  Loss_GainLoss_NonDiscRate as Nominal from @IFRS Where (@Method='B' and @OneRous=1) or Loss_GainLoss_NonDiscRate<>0 Union All
Select 'Loss_Adjustment' as Description, (Case When @YearN*12<=@MonthN then (Loss_Start_N-Loss_End) else 0 end) from @IFRS Where (Case When @YearN*12<=@MonthN then (Loss_Start_N-Loss_End) else 0 end)<>0 Union All
Select 'Loss_End'as Description,  Loss_End + (Case When @YearN*12<=@MonthN then (Loss_Start_N-Loss_End) else 0 end) as Nominal from @IFRS Where (@Method='B' and @OneRous=1) or Loss_End<>0 Union All  
Select 'Loss_Percentage'as Description,  Loss_Percentage as Nominal from @IFRS Where (@Method='B' and @OneRous=1) or Loss_Percentage<>0 Union All  
Select 'ACQ_Amortization'as Description,  ACQ_Amortization as Nominal from @IFRS 

GO




 insert into PatchVersioning	
select '652 Update Script - IFRS Patch #13',GETDATE()
go





Declare @PrevScript varchar(100)
Declare @CurrScript varchar(100)

Select @PrevScript=''
Select @CurrSCript='652 Update Script - IFRS Patch #13'


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



