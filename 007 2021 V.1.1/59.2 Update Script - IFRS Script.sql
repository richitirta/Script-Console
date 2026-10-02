DROP Procedure IFRS_Get_Assumption
GO
Create Procedure IFRS_Get_Assumption(@PDate as smalldatetime, @AssumptionID as varchar(10), @TSI as Float, @Segment as varchar(10), @TOC as varchar(10))                  
as                  
Select I2.*, I5.DiscRate 
from IFRS_Assumption I1
cross apply (Select Top 1 * from IFRS_Assumption_Detail I2 Where I2.AssumptionID=I1.AssumptionID and I2.VDate<=@PDate order by I2.VDate Desc) I2
Left Join IFRS_Assumption_Segment I3 on (@AssumptionID='' and I3.AssumptionID=I1.AssumptionID and I3.Segment=@Segment)
Left Join IFRS_Assumption_TOC I4 on (@AssumptionID='' and I4.AssumptionID=I1.AssumptionID and I4.TOC=@TOC)
cross apply (Select Top 1 I2.DiscRate from IFRS_DiscRate_Detail I2 Where I2.DiscRateID=I1.DiscRateID and I2.VDate<=@PDate order by I2.VDate Desc) I5
Where (@AssumptionID<>'' and I1.AssumptionID=@AssumptionID) or (@AssumptionID='' and @TSI Between I1.SI_Lower and I1.SI_Upper and coalesce(I3.Segment,'')=@Segment and coalesce(I4.TOC,'')=@TOC and I1.AllowedF=1)

GO

Drop Procedure IFRS_SHOW_INITIAL
GO

Create Procedure IFRS_SHOW_INITIAL(@DataID as Int, @GroupType as varchar(1), @YearN as Int)
as

Declare @IFRS table (
	BEL_Beginning	Float,
	BEL_Premium_Expected	Float,
	BEL_Commission_Expected	Float,
	BEL_Interest_Accrete	Float,
	BEL_Claim_Expected	Float,
	BEL_Expense_Expected	Float,
	BEL_Ending_Before_Change	Float,
	BEL_Ending_After_Change_NonDiscRate	Float,
	BEL_Ending_After_Change_DiscRate	Float,
	BEL_GainLoss_NonDiscRate	Float,
	BEL_GainLoss_DiscRate	Float,
	RA_Beginning	Float,
	RA_Interest_Accrete	Float,
	RA_Release	Float,
	RA_Ending_Before_Change	Float,
	RA_Ending_After_Change_NonDiscRate	Float,
	RA_Ending_After_Change_DiscRate	Float,
	RA_GainLoss_NonDiscRate	Float,
	RA_GainLoss_DiscRate	Float,
	CSM_Start	Float,
	CSM_Interest_Accrete	Float,
	CSM_Amortization	Float,
	CSM_GainLoss_Realization_Premium	Float,
	CSM_GainLoss_Realization_Commission	Float,
	CSM_GainLoss_NonDiscRate	Float,
	CSM_End	Float,
	Loss_Start	Float,
	Loss_Portion_from_Claim_Release	Float,
	Loss_Portion_from_Expense_Release	Float,
	Loss_Portion_from_RA_Release	Float,
	Loss_Portion_from_Interest_Accrete	Float,
	Loss_GainLoss_Realization_Premium	Float,
	Loss_GainLoss_Realization_Commission	Float,
	Loss_Portion_from_GainLoss_DiscRate	Float,
	Loss_GainLoss_NonDiscRate	Float,
	Loss_End	Float,
	Loss_Percentage Float
)

insert into @IFRS
Select
Case 
When @YearN=1 then BEL_Beginning_1
When @YearN=2 then BEL_Beginning_2
When @YearN=3 then BEL_Beginning_3
When @YearN=4 then BEL_Beginning_4
When @YearN=5 then BEL_Beginning_5
When @YearN=6 then BEL_Beginning_6
When @YearN=7 then BEL_Beginning_7
When @YearN=8 then BEL_Beginning_8
When @YearN=9 then BEL_Beginning_9
When @YearN=10 then BEL_Beginning_10
When @YearN=11 then BEL_Beginning_11
When @YearN=12 then BEL_Beginning_12
When @YearN=13 then BEL_Beginning_13
When @YearN=14 then BEL_Beginning_14
When @YearN=15 then BEL_Beginning_15
end as BEL_Beginning,
Case 
When @YearN=1 then BEL_Premium_Expected_1
When @YearN=2 then BEL_Premium_Expected_2
When @YearN=3 then BEL_Premium_Expected_3
When @YearN=4 then BEL_Premium_Expected_4
When @YearN=5 then BEL_Premium_Expected_5
When @YearN=6 then BEL_Premium_Expected_6
When @YearN=7 then BEL_Premium_Expected_7
When @YearN=8 then BEL_Premium_Expected_8
When @YearN=9 then BEL_Premium_Expected_9
When @YearN=10 then BEL_Premium_Expected_10
When @YearN=11 then BEL_Premium_Expected_11
When @YearN=12 then BEL_Premium_Expected_12
When @YearN=13 then BEL_Premium_Expected_13
When @YearN=14 then BEL_Premium_Expected_14
When @YearN=15 then BEL_Premium_Expected_15
end as BEL_Premium_Expected,
Case 
When @YearN=1 then BEL_Commission_Expected_1
When @YearN=2 then BEL_Commission_Expected_2
When @YearN=3 then BEL_Commission_Expected_3
When @YearN=4 then BEL_Commission_Expected_4
When @YearN=5 then BEL_Commission_Expected_5
When @YearN=6 then BEL_Commission_Expected_6
When @YearN=7 then BEL_Commission_Expected_7
When @YearN=8 then BEL_Commission_Expected_8
When @YearN=9 then BEL_Commission_Expected_9
When @YearN=10 then BEL_Commission_Expected_10
When @YearN=11 then BEL_Commission_Expected_11
When @YearN=12 then BEL_Commission_Expected_12
When @YearN=13 then BEL_Commission_Expected_13
When @YearN=14 then BEL_Commission_Expected_14
When @YearN=15 then BEL_Commission_Expected_15
end as BEL_Commission_Expected,
Case 
When @YearN=1 then BEL_Interest_Accrete_1
When @YearN=2 then BEL_Interest_Accrete_2
When @YearN=3 then BEL_Interest_Accrete_3
When @YearN=4 then BEL_Interest_Accrete_4
When @YearN=5 then BEL_Interest_Accrete_5
When @YearN=6 then BEL_Interest_Accrete_6
When @YearN=7 then BEL_Interest_Accrete_7
When @YearN=8 then BEL_Interest_Accrete_8
When @YearN=9 then BEL_Interest_Accrete_9
When @YearN=10 then BEL_Interest_Accrete_10
When @YearN=11 then BEL_Interest_Accrete_11
When @YearN=12 then BEL_Interest_Accrete_12
When @YearN=13 then BEL_Interest_Accrete_13
When @YearN=14 then BEL_Interest_Accrete_14
When @YearN=15 then BEL_Interest_Accrete_15
end as BEL_Interest_Accrete,
Case 
When @YearN=1 then BEL_Claim_Expected_1
When @YearN=2 then BEL_Claim_Expected_2
When @YearN=3 then BEL_Claim_Expected_3
When @YearN=4 then BEL_Claim_Expected_4
When @YearN=5 then BEL_Claim_Expected_5
When @YearN=6 then BEL_Claim_Expected_6
When @YearN=7 then BEL_Claim_Expected_7
When @YearN=8 then BEL_Claim_Expected_8
When @YearN=9 then BEL_Claim_Expected_9
When @YearN=10 then BEL_Claim_Expected_10
When @YearN=11 then BEL_Claim_Expected_11
When @YearN=12 then BEL_Claim_Expected_12
When @YearN=13 then BEL_Claim_Expected_13
When @YearN=14 then BEL_Claim_Expected_14
When @YearN=15 then BEL_Claim_Expected_15
end as BEL_Claim_Expected,
Case 
When @YearN=1 then BEL_Expense_Expected_1
When @YearN=2 then BEL_Expense_Expected_2
When @YearN=3 then BEL_Expense_Expected_3
When @YearN=4 then BEL_Expense_Expected_4
When @YearN=5 then BEL_Expense_Expected_5
When @YearN=6 then BEL_Expense_Expected_6
When @YearN=7 then BEL_Expense_Expected_7
When @YearN=8 then BEL_Expense_Expected_8
When @YearN=9 then BEL_Expense_Expected_9
When @YearN=10 then BEL_Expense_Expected_10
When @YearN=11 then BEL_Expense_Expected_11
When @YearN=12 then BEL_Expense_Expected_12
When @YearN=13 then BEL_Expense_Expected_13
When @YearN=14 then BEL_Expense_Expected_14
When @YearN=15 then BEL_Expense_Expected_15
end as BEL_Expense_Expected,
Case 
When @YearN=1 then BEL_Ending_Before_Change_1
When @YearN=2 then BEL_Ending_Before_Change_2
When @YearN=3 then BEL_Ending_Before_Change_3
When @YearN=4 then BEL_Ending_Before_Change_4
When @YearN=5 then BEL_Ending_Before_Change_5
When @YearN=6 then BEL_Ending_Before_Change_6
When @YearN=7 then BEL_Ending_Before_Change_7
When @YearN=8 then BEL_Ending_Before_Change_8
When @YearN=9 then BEL_Ending_Before_Change_9
When @YearN=10 then BEL_Ending_Before_Change_10
When @YearN=11 then BEL_Ending_Before_Change_11
When @YearN=12 then BEL_Ending_Before_Change_12
When @YearN=13 then BEL_Ending_Before_Change_13
When @YearN=14 then BEL_Ending_Before_Change_14
When @YearN=15 then BEL_Ending_Before_Change_15
end as BEL_Ending_Before_Change,
Case 
When @YearN=1 then BEL_Ending_After_Change_NonDiscRate_1
When @YearN=2 then BEL_Ending_After_Change_NonDiscRate_2
When @YearN=3 then BEL_Ending_After_Change_NonDiscRate_3
When @YearN=4 then BEL_Ending_After_Change_NonDiscRate_4
When @YearN=5 then BEL_Ending_After_Change_NonDiscRate_5
When @YearN=6 then BEL_Ending_After_Change_NonDiscRate_6
When @YearN=7 then BEL_Ending_After_Change_NonDiscRate_7
When @YearN=8 then BEL_Ending_After_Change_NonDiscRate_8
When @YearN=9 then BEL_Ending_After_Change_NonDiscRate_9
When @YearN=10 then BEL_Ending_After_Change_NonDiscRate_10
When @YearN=11 then BEL_Ending_After_Change_NonDiscRate_11
When @YearN=12 then BEL_Ending_After_Change_NonDiscRate_12
When @YearN=13 then BEL_Ending_After_Change_NonDiscRate_13
When @YearN=14 then BEL_Ending_After_Change_NonDiscRate_14
When @YearN=15 then BEL_Ending_After_Change_NonDiscRate_15
end as BEL_Ending_After_Change_NonDiscRate,
Case 
When @YearN=1 then BEL_Ending_After_Change_DiscRate_1
When @YearN=2 then BEL_Ending_After_Change_DiscRate_2
When @YearN=3 then BEL_Ending_After_Change_DiscRate_3
When @YearN=4 then BEL_Ending_After_Change_DiscRate_4
When @YearN=5 then BEL_Ending_After_Change_DiscRate_5
When @YearN=6 then BEL_Ending_After_Change_DiscRate_6
When @YearN=7 then BEL_Ending_After_Change_DiscRate_7
When @YearN=8 then BEL_Ending_After_Change_DiscRate_8
When @YearN=9 then BEL_Ending_After_Change_DiscRate_9
When @YearN=10 then BEL_Ending_After_Change_DiscRate_10
When @YearN=11 then BEL_Ending_After_Change_DiscRate_11
When @YearN=12 then BEL_Ending_After_Change_DiscRate_12
When @YearN=13 then BEL_Ending_After_Change_DiscRate_13
When @YearN=14 then BEL_Ending_After_Change_DiscRate_14
When @YearN=15 then BEL_Ending_After_Change_DiscRate_15
end as BEL_Ending_After_Change_DiscRate,
Case 
When @YearN=1 then BEL_GainLoss_NonDiscRate_1
When @YearN=2 then BEL_GainLoss_NonDiscRate_2
When @YearN=3 then BEL_GainLoss_NonDiscRate_3
When @YearN=4 then BEL_GainLoss_NonDiscRate_4
When @YearN=5 then BEL_GainLoss_NonDiscRate_5
When @YearN=6 then BEL_GainLoss_NonDiscRate_6
When @YearN=7 then BEL_GainLoss_NonDiscRate_7
When @YearN=8 then BEL_GainLoss_NonDiscRate_8
When @YearN=9 then BEL_GainLoss_NonDiscRate_9
When @YearN=10 then BEL_GainLoss_NonDiscRate_10
When @YearN=11 then BEL_GainLoss_NonDiscRate_11
When @YearN=12 then BEL_GainLoss_NonDiscRate_12
When @YearN=13 then BEL_GainLoss_NonDiscRate_13
When @YearN=14 then BEL_GainLoss_NonDiscRate_14
When @YearN=15 then BEL_GainLoss_NonDiscRate_15
end as BEL_GainLoss_NonDiscRate,
Case 
When @YearN=1 then BEL_GainLoss_DiscRate_1
When @YearN=2 then BEL_GainLoss_DiscRate_2
When @YearN=3 then BEL_GainLoss_DiscRate_3
When @YearN=4 then BEL_GainLoss_DiscRate_4
When @YearN=5 then BEL_GainLoss_DiscRate_5
When @YearN=6 then BEL_GainLoss_DiscRate_6
When @YearN=7 then BEL_GainLoss_DiscRate_7
When @YearN=8 then BEL_GainLoss_DiscRate_8
When @YearN=9 then BEL_GainLoss_DiscRate_9
When @YearN=10 then BEL_GainLoss_DiscRate_10
When @YearN=11 then BEL_GainLoss_DiscRate_11
When @YearN=12 then BEL_GainLoss_DiscRate_12
When @YearN=13 then BEL_GainLoss_DiscRate_13
When @YearN=14 then BEL_GainLoss_DiscRate_14
When @YearN=15 then BEL_GainLoss_DiscRate_15
end as BEL_GainLoss_DiscRate,
Case 
When @YearN=1 then RA_Beginning_1
When @YearN=2 then RA_Beginning_2
When @YearN=3 then RA_Beginning_3
When @YearN=4 then RA_Beginning_4
When @YearN=5 then RA_Beginning_5
When @YearN=6 then RA_Beginning_6
When @YearN=7 then RA_Beginning_7
When @YearN=8 then RA_Beginning_8
When @YearN=9 then RA_Beginning_9
When @YearN=10 then RA_Beginning_10
When @YearN=11 then RA_Beginning_11
When @YearN=12 then RA_Beginning_12
When @YearN=13 then RA_Beginning_13
When @YearN=14 then RA_Beginning_14
When @YearN=15 then RA_Beginning_15
end as RA_Beginning,
Case 
When @YearN=1 then RA_Interest_Accrete_1
When @YearN=2 then RA_Interest_Accrete_2
When @YearN=3 then RA_Interest_Accrete_3
When @YearN=4 then RA_Interest_Accrete_4
When @YearN=5 then RA_Interest_Accrete_5
When @YearN=6 then RA_Interest_Accrete_6
When @YearN=7 then RA_Interest_Accrete_7
When @YearN=8 then RA_Interest_Accrete_8
When @YearN=9 then RA_Interest_Accrete_9
When @YearN=10 then RA_Interest_Accrete_10
When @YearN=11 then RA_Interest_Accrete_11
When @YearN=12 then RA_Interest_Accrete_12
When @YearN=13 then RA_Interest_Accrete_13
When @YearN=14 then RA_Interest_Accrete_14
When @YearN=15 then RA_Interest_Accrete_15
end as RA_Interest_Accrete,
Case 
When @YearN=1 then RA_Release_1
When @YearN=2 then RA_Release_2
When @YearN=3 then RA_Release_3
When @YearN=4 then RA_Release_4
When @YearN=5 then RA_Release_5
When @YearN=6 then RA_Release_6
When @YearN=7 then RA_Release_7
When @YearN=8 then RA_Release_8
When @YearN=9 then RA_Release_9
When @YearN=10 then RA_Release_10
When @YearN=11 then RA_Release_11
When @YearN=12 then RA_Release_12
When @YearN=13 then RA_Release_13
When @YearN=14 then RA_Release_14
When @YearN=15 then RA_Release_15
end as RA_Release,
Case 
When @YearN=1 then RA_Ending_Before_Change_1
When @YearN=2 then RA_Ending_Before_Change_2
When @YearN=3 then RA_Ending_Before_Change_3
When @YearN=4 then RA_Ending_Before_Change_4
When @YearN=5 then RA_Ending_Before_Change_5
When @YearN=6 then RA_Ending_Before_Change_6
When @YearN=7 then RA_Ending_Before_Change_7
When @YearN=8 then RA_Ending_Before_Change_8
When @YearN=9 then RA_Ending_Before_Change_9
When @YearN=10 then RA_Ending_Before_Change_10
When @YearN=11 then RA_Ending_Before_Change_11
When @YearN=12 then RA_Ending_Before_Change_12
When @YearN=13 then RA_Ending_Before_Change_13
When @YearN=14 then RA_Ending_Before_Change_14
When @YearN=15 then RA_Ending_Before_Change_15
end as RA_Ending_Before_Change,
Case 
When @YearN=1 then RA_Ending_After_Change_NonDiscRate_1
When @YearN=2 then RA_Ending_After_Change_NonDiscRate_2
When @YearN=3 then RA_Ending_After_Change_NonDiscRate_3
When @YearN=4 then RA_Ending_After_Change_NonDiscRate_4
When @YearN=5 then RA_Ending_After_Change_NonDiscRate_5
When @YearN=6 then RA_Ending_After_Change_NonDiscRate_6
When @YearN=7 then RA_Ending_After_Change_NonDiscRate_7
When @YearN=8 then RA_Ending_After_Change_NonDiscRate_8
When @YearN=9 then RA_Ending_After_Change_NonDiscRate_9
When @YearN=10 then RA_Ending_After_Change_NonDiscRate_10
When @YearN=11 then RA_Ending_After_Change_NonDiscRate_11
When @YearN=12 then RA_Ending_After_Change_NonDiscRate_12
When @YearN=13 then RA_Ending_After_Change_NonDiscRate_13
When @YearN=14 then RA_Ending_After_Change_NonDiscRate_14
When @YearN=15 then RA_Ending_After_Change_NonDiscRate_15
end as RA_Ending_After_Change_NonDiscRate,
Case 
When @YearN=1 then RA_Ending_After_Change_DiscRate_1
When @YearN=2 then RA_Ending_After_Change_DiscRate_2
When @YearN=3 then RA_Ending_After_Change_DiscRate_3
When @YearN=4 then RA_Ending_After_Change_DiscRate_4
When @YearN=5 then RA_Ending_After_Change_DiscRate_5
When @YearN=6 then RA_Ending_After_Change_DiscRate_6
When @YearN=7 then RA_Ending_After_Change_DiscRate_7
When @YearN=8 then RA_Ending_After_Change_DiscRate_8
When @YearN=9 then RA_Ending_After_Change_DiscRate_9
When @YearN=10 then RA_Ending_After_Change_DiscRate_10
When @YearN=11 then RA_Ending_After_Change_DiscRate_11
When @YearN=12 then RA_Ending_After_Change_DiscRate_12
When @YearN=13 then RA_Ending_After_Change_DiscRate_13
When @YearN=14 then RA_Ending_After_Change_DiscRate_14
When @YearN=15 then RA_Ending_After_Change_DiscRate_15
end as RA_Ending_After_Change_DiscRate,
Case 
When @YearN=1 then RA_GainLoss_NonDiscRate_1
When @YearN=2 then RA_GainLoss_NonDiscRate_2
When @YearN=3 then RA_GainLoss_NonDiscRate_3
When @YearN=4 then RA_GainLoss_NonDiscRate_4
When @YearN=5 then RA_GainLoss_NonDiscRate_5
When @YearN=6 then RA_GainLoss_NonDiscRate_6
When @YearN=7 then RA_GainLoss_NonDiscRate_7
When @YearN=8 then RA_GainLoss_NonDiscRate_8
When @YearN=9 then RA_GainLoss_NonDiscRate_9
When @YearN=10 then RA_GainLoss_NonDiscRate_10
When @YearN=11 then RA_GainLoss_NonDiscRate_11
When @YearN=12 then RA_GainLoss_NonDiscRate_12
When @YearN=13 then RA_GainLoss_NonDiscRate_13
When @YearN=14 then RA_GainLoss_NonDiscRate_14
When @YearN=15 then RA_GainLoss_NonDiscRate_15
end as RA_GainLoss_NonDiscRate,
Case 
When @YearN=1 then RA_GainLoss_DiscRate_1
When @YearN=2 then RA_GainLoss_DiscRate_2
When @YearN=3 then RA_GainLoss_DiscRate_3
When @YearN=4 then RA_GainLoss_DiscRate_4
When @YearN=5 then RA_GainLoss_DiscRate_5
When @YearN=6 then RA_GainLoss_DiscRate_6
When @YearN=7 then RA_GainLoss_DiscRate_7
When @YearN=8 then RA_GainLoss_DiscRate_8
When @YearN=9 then RA_GainLoss_DiscRate_9
When @YearN=10 then RA_GainLoss_DiscRate_10
When @YearN=11 then RA_GainLoss_DiscRate_11
When @YearN=12 then RA_GainLoss_DiscRate_12
When @YearN=13 then RA_GainLoss_DiscRate_13
When @YearN=14 then RA_GainLoss_DiscRate_14
When @YearN=15 then RA_GainLoss_DiscRate_15
end as RA_GainLoss_DiscRate,
Case 
When @YearN=1 then CSM_Start_1
When @YearN=2 then CSM_Start_2
When @YearN=3 then CSM_Start_3
When @YearN=4 then CSM_Start_4
When @YearN=5 then CSM_Start_5
When @YearN=6 then CSM_Start_6
When @YearN=7 then CSM_Start_7
When @YearN=8 then CSM_Start_8
When @YearN=9 then CSM_Start_9
When @YearN=10 then CSM_Start_10
When @YearN=11 then CSM_Start_11
When @YearN=12 then CSM_Start_12
When @YearN=13 then CSM_Start_13
When @YearN=14 then CSM_Start_14
When @YearN=15 then CSM_Start_15
end as CSM_Start,
Case 
When @YearN=1 then CSM_Interest_Accrete_1
When @YearN=2 then CSM_Interest_Accrete_2
When @YearN=3 then CSM_Interest_Accrete_3
When @YearN=4 then CSM_Interest_Accrete_4
When @YearN=5 then CSM_Interest_Accrete_5
When @YearN=6 then CSM_Interest_Accrete_6
When @YearN=7 then CSM_Interest_Accrete_7
When @YearN=8 then CSM_Interest_Accrete_8
When @YearN=9 then CSM_Interest_Accrete_9
When @YearN=10 then CSM_Interest_Accrete_10
When @YearN=11 then CSM_Interest_Accrete_11
When @YearN=12 then CSM_Interest_Accrete_12
When @YearN=13 then CSM_Interest_Accrete_13
When @YearN=14 then CSM_Interest_Accrete_14
When @YearN=15 then CSM_Interest_Accrete_15
end as CSM_Interest_Accrete,
Case 
When @YearN=1 then CSM_Amortization_1
When @YearN=2 then CSM_Amortization_2
When @YearN=3 then CSM_Amortization_3
When @YearN=4 then CSM_Amortization_4
When @YearN=5 then CSM_Amortization_5
When @YearN=6 then CSM_Amortization_6
When @YearN=7 then CSM_Amortization_7
When @YearN=8 then CSM_Amortization_8
When @YearN=9 then CSM_Amortization_9
When @YearN=10 then CSM_Amortization_10
When @YearN=11 then CSM_Amortization_11
When @YearN=12 then CSM_Amortization_12
When @YearN=13 then CSM_Amortization_13
When @YearN=14 then CSM_Amortization_14
When @YearN=15 then CSM_Amortization_15
end as CSM_Amortization,
Case 
When @YearN=1 then CSM_GainLoss_Realization_Premium_1
When @YearN=2 then CSM_GainLoss_Realization_Premium_2
When @YearN=3 then CSM_GainLoss_Realization_Premium_3
When @YearN=4 then CSM_GainLoss_Realization_Premium_4
When @YearN=5 then CSM_GainLoss_Realization_Premium_5
When @YearN=6 then CSM_GainLoss_Realization_Premium_6
When @YearN=7 then CSM_GainLoss_Realization_Premium_7
When @YearN=8 then CSM_GainLoss_Realization_Premium_8
When @YearN=9 then CSM_GainLoss_Realization_Premium_9
When @YearN=10 then CSM_GainLoss_Realization_Premium_10
When @YearN=11 then CSM_GainLoss_Realization_Premium_11
When @YearN=12 then CSM_GainLoss_Realization_Premium_12
When @YearN=13 then CSM_GainLoss_Realization_Premium_13
When @YearN=14 then CSM_GainLoss_Realization_Premium_14
When @YearN=15 then CSM_GainLoss_Realization_Premium_15
end as CSM_GainLoss_Realization_Premium,
Case 
When @YearN=1 then CSM_GainLoss_Realization_Commission_1
When @YearN=2 then CSM_GainLoss_Realization_Commission_2
When @YearN=3 then CSM_GainLoss_Realization_Commission_3
When @YearN=4 then CSM_GainLoss_Realization_Commission_4
When @YearN=5 then CSM_GainLoss_Realization_Commission_5
When @YearN=6 then CSM_GainLoss_Realization_Commission_6
When @YearN=7 then CSM_GainLoss_Realization_Commission_7
When @YearN=8 then CSM_GainLoss_Realization_Commission_8
When @YearN=9 then CSM_GainLoss_Realization_Commission_9
When @YearN=10 then CSM_GainLoss_Realization_Commission_10
When @YearN=11 then CSM_GainLoss_Realization_Commission_11
When @YearN=12 then CSM_GainLoss_Realization_Commission_12
When @YearN=13 then CSM_GainLoss_Realization_Commission_13
When @YearN=14 then CSM_GainLoss_Realization_Commission_14
When @YearN=15 then CSM_GainLoss_Realization_Commission_15
end as CSM_GainLoss_Realization_Commission,
Case 
When @YearN=1 then CSM_GainLoss_NonDiscRate_1
When @YearN=2 then CSM_GainLoss_NonDiscRate_2
When @YearN=3 then CSM_GainLoss_NonDiscRate_3
When @YearN=4 then CSM_GainLoss_NonDiscRate_4
When @YearN=5 then CSM_GainLoss_NonDiscRate_5
When @YearN=6 then CSM_GainLoss_NonDiscRate_6
When @YearN=7 then CSM_GainLoss_NonDiscRate_7
When @YearN=8 then CSM_GainLoss_NonDiscRate_8
When @YearN=9 then CSM_GainLoss_NonDiscRate_9
When @YearN=10 then CSM_GainLoss_NonDiscRate_10
When @YearN=11 then CSM_GainLoss_NonDiscRate_11
When @YearN=12 then CSM_GainLoss_NonDiscRate_12
When @YearN=13 then CSM_GainLoss_NonDiscRate_13
When @YearN=14 then CSM_GainLoss_NonDiscRate_14
When @YearN=15 then CSM_GainLoss_NonDiscRate_15
end as CSM_GainLoss_NonDiscRate,
Case 
When @YearN=1 then CSM_End_1
When @YearN=2 then CSM_End_2
When @YearN=3 then CSM_End_3
When @YearN=4 then CSM_End_4
When @YearN=5 then CSM_End_5
When @YearN=6 then CSM_End_6
When @YearN=7 then CSM_End_7
When @YearN=8 then CSM_End_8
When @YearN=9 then CSM_End_9
When @YearN=10 then CSM_End_10
When @YearN=11 then CSM_End_11
When @YearN=12 then CSM_End_12
When @YearN=13 then CSM_End_13
When @YearN=14 then CSM_End_14
When @YearN=15 then CSM_End_15
end as CSM_End,
Case 
When @YearN=1 then Loss_Start_1
When @YearN=2 then Loss_Start_2
When @YearN=3 then Loss_Start_3
When @YearN=4 then Loss_Start_4
When @YearN=5 then Loss_Start_5
When @YearN=6 then Loss_Start_6
When @YearN=7 then Loss_Start_7
When @YearN=8 then Loss_Start_8
When @YearN=9 then Loss_Start_9
When @YearN=10 then Loss_Start_10
When @YearN=11 then Loss_Start_11
When @YearN=12 then Loss_Start_12
When @YearN=13 then Loss_Start_13
When @YearN=14 then Loss_Start_14
When @YearN=15 then Loss_Start_15
end as Loss_Start,
Case 
When @YearN=1 then Loss_Portion_from_Claim_Release_1
When @YearN=2 then Loss_Portion_from_Claim_Release_2
When @YearN=3 then Loss_Portion_from_Claim_Release_3
When @YearN=4 then Loss_Portion_from_Claim_Release_4
When @YearN=5 then Loss_Portion_from_Claim_Release_5
When @YearN=6 then Loss_Portion_from_Claim_Release_6
When @YearN=7 then Loss_Portion_from_Claim_Release_7
When @YearN=8 then Loss_Portion_from_Claim_Release_8
When @YearN=9 then Loss_Portion_from_Claim_Release_9
When @YearN=10 then Loss_Portion_from_Claim_Release_10
When @YearN=11 then Loss_Portion_from_Claim_Release_11
When @YearN=12 then Loss_Portion_from_Claim_Release_12
When @YearN=13 then Loss_Portion_from_Claim_Release_13
When @YearN=14 then Loss_Portion_from_Claim_Release_14
When @YearN=15 then Loss_Portion_from_Claim_Release_15
end as Loss_Portion_from_Claim_Release,
Case 
When @YearN=1 then Loss_Portion_from_Expense_Release_1
When @YearN=2 then Loss_Portion_from_Expense_Release_2
When @YearN=3 then Loss_Portion_from_Expense_Release_3
When @YearN=4 then Loss_Portion_from_Expense_Release_4
When @YearN=5 then Loss_Portion_from_Expense_Release_5
When @YearN=6 then Loss_Portion_from_Expense_Release_6
When @YearN=7 then Loss_Portion_from_Expense_Release_7
When @YearN=8 then Loss_Portion_from_Expense_Release_8
When @YearN=9 then Loss_Portion_from_Expense_Release_9
When @YearN=10 then Loss_Portion_from_Expense_Release_10
When @YearN=11 then Loss_Portion_from_Expense_Release_11
When @YearN=12 then Loss_Portion_from_Expense_Release_12
When @YearN=13 then Loss_Portion_from_Expense_Release_13
When @YearN=14 then Loss_Portion_from_Expense_Release_14
When @YearN=15 then Loss_Portion_from_Expense_Release_15
end as Loss_Portion_from_Expense_Release,
Case 
When @YearN=1 then Loss_Portion_from_RA_Release_1
When @YearN=2 then Loss_Portion_from_RA_Release_2
When @YearN=3 then Loss_Portion_from_RA_Release_3
When @YearN=4 then Loss_Portion_from_RA_Release_4
When @YearN=5 then Loss_Portion_from_RA_Release_5
When @YearN=6 then Loss_Portion_from_RA_Release_6
When @YearN=7 then Loss_Portion_from_RA_Release_7
When @YearN=8 then Loss_Portion_from_RA_Release_8
When @YearN=9 then Loss_Portion_from_RA_Release_9
When @YearN=10 then Loss_Portion_from_RA_Release_10
When @YearN=11 then Loss_Portion_from_RA_Release_11
When @YearN=12 then Loss_Portion_from_RA_Release_12
When @YearN=13 then Loss_Portion_from_RA_Release_13
When @YearN=14 then Loss_Portion_from_RA_Release_14
When @YearN=15 then Loss_Portion_from_RA_Release_15
end as Loss_Portion_from_RA_Release,
Case 
When @YearN=1 then Loss_Portion_from_Interest_Accrete_1
When @YearN=2 then Loss_Portion_from_Interest_Accrete_2
When @YearN=3 then Loss_Portion_from_Interest_Accrete_3
When @YearN=4 then Loss_Portion_from_Interest_Accrete_4
When @YearN=5 then Loss_Portion_from_Interest_Accrete_5
When @YearN=6 then Loss_Portion_from_Interest_Accrete_6
When @YearN=7 then Loss_Portion_from_Interest_Accrete_7
When @YearN=8 then Loss_Portion_from_Interest_Accrete_8
When @YearN=9 then Loss_Portion_from_Interest_Accrete_9
When @YearN=10 then Loss_Portion_from_Interest_Accrete_10
When @YearN=11 then Loss_Portion_from_Interest_Accrete_11
When @YearN=12 then Loss_Portion_from_Interest_Accrete_12
When @YearN=13 then Loss_Portion_from_Interest_Accrete_13
When @YearN=14 then Loss_Portion_from_Interest_Accrete_14
When @YearN=15 then Loss_Portion_from_Interest_Accrete_15
end as Loss_Portion_from_Interest_Accrete,
Case 
When @YearN=1 then Loss_GainLoss_Realization_Premium_1
When @YearN=2 then Loss_GainLoss_Realization_Premium_2
When @YearN=3 then Loss_GainLoss_Realization_Premium_3
When @YearN=4 then Loss_GainLoss_Realization_Premium_4
When @YearN=5 then Loss_GainLoss_Realization_Premium_5
When @YearN=6 then Loss_GainLoss_Realization_Premium_6
When @YearN=7 then Loss_GainLoss_Realization_Premium_7
When @YearN=8 then Loss_GainLoss_Realization_Premium_8
When @YearN=9 then Loss_GainLoss_Realization_Premium_9
When @YearN=10 then Loss_GainLoss_Realization_Premium_10
When @YearN=11 then Loss_GainLoss_Realization_Premium_11
When @YearN=12 then Loss_GainLoss_Realization_Premium_12
When @YearN=13 then Loss_GainLoss_Realization_Premium_13
When @YearN=14 then Loss_GainLoss_Realization_Premium_14
When @YearN=15 then Loss_GainLoss_Realization_Premium_15
end as Loss_GainLoss_Realization_Premium,
Case 
When @YearN=1 then Loss_GainLoss_Realization_Commission_1
When @YearN=2 then Loss_GainLoss_Realization_Commission_2
When @YearN=3 then Loss_GainLoss_Realization_Commission_3
When @YearN=4 then Loss_GainLoss_Realization_Commission_4
When @YearN=5 then Loss_GainLoss_Realization_Commission_5
When @YearN=6 then Loss_GainLoss_Realization_Commission_6
When @YearN=7 then Loss_GainLoss_Realization_Commission_7
When @YearN=8 then Loss_GainLoss_Realization_Commission_8
When @YearN=9 then Loss_GainLoss_Realization_Commission_9
When @YearN=10 then Loss_GainLoss_Realization_Commission_10
When @YearN=11 then Loss_GainLoss_Realization_Commission_11
When @YearN=12 then Loss_GainLoss_Realization_Commission_12
When @YearN=13 then Loss_GainLoss_Realization_Commission_13
When @YearN=14 then Loss_GainLoss_Realization_Commission_14
When @YearN=15 then Loss_GainLoss_Realization_Commission_15
end as Loss_GainLoss_Realization_Commission,
Case 
When @YearN=1 then Loss_Portion_from_GainLoss_DiscRate_1
When @YearN=2 then Loss_Portion_from_GainLoss_DiscRate_2
When @YearN=3 then Loss_Portion_from_GainLoss_DiscRate_3
When @YearN=4 then Loss_Portion_from_GainLoss_DiscRate_4
When @YearN=5 then Loss_Portion_from_GainLoss_DiscRate_5
When @YearN=6 then Loss_Portion_from_GainLoss_DiscRate_6
When @YearN=7 then Loss_Portion_from_GainLoss_DiscRate_7
When @YearN=8 then Loss_Portion_from_GainLoss_DiscRate_8
When @YearN=9 then Loss_Portion_from_GainLoss_DiscRate_9
When @YearN=10 then Loss_Portion_from_GainLoss_DiscRate_10
When @YearN=11 then Loss_Portion_from_GainLoss_DiscRate_11
When @YearN=12 then Loss_Portion_from_GainLoss_DiscRate_12
When @YearN=13 then Loss_Portion_from_GainLoss_DiscRate_13
When @YearN=14 then Loss_Portion_from_GainLoss_DiscRate_14
When @YearN=15 then Loss_Portion_from_GainLoss_DiscRate_15
end as Loss_Portion_from_GainLoss_DiscRate,
Case 
When @YearN=1 then Loss_GainLoss_NonDiscRate_1
When @YearN=2 then Loss_GainLoss_NonDiscRate_2
When @YearN=3 then Loss_GainLoss_NonDiscRate_3
When @YearN=4 then Loss_GainLoss_NonDiscRate_4
When @YearN=5 then Loss_GainLoss_NonDiscRate_5
When @YearN=6 then Loss_GainLoss_NonDiscRate_6
When @YearN=7 then Loss_GainLoss_NonDiscRate_7
When @YearN=8 then Loss_GainLoss_NonDiscRate_8
When @YearN=9 then Loss_GainLoss_NonDiscRate_9
When @YearN=10 then Loss_GainLoss_NonDiscRate_10
When @YearN=11 then Loss_GainLoss_NonDiscRate_11
When @YearN=12 then Loss_GainLoss_NonDiscRate_12
When @YearN=13 then Loss_GainLoss_NonDiscRate_13
When @YearN=14 then Loss_GainLoss_NonDiscRate_14
When @YearN=15 then Loss_GainLoss_NonDiscRate_15
end as Loss_GainLoss_NonDiscRate,
Case 
When @YearN=1 then Loss_End_1
When @YearN=2 then Loss_End_2
When @YearN=3 then Loss_End_3
When @YearN=4 then Loss_End_4
When @YearN=5 then Loss_End_5
When @YearN=6 then Loss_End_6
When @YearN=7 then Loss_End_7
When @YearN=8 then Loss_End_8
When @YearN=9 then Loss_End_9
When @YearN=10 then Loss_End_10
When @YearN=11 then Loss_End_11
When @YearN=12 then Loss_End_12
When @YearN=13 then Loss_End_13
When @YearN=14 then Loss_End_14
When @YearN=15 then Loss_End_15
end as Loss_End,
Case 
When @YearN=1 then Loss_Percentage_1
When @YearN=2 then Loss_Percentage_2
When @YearN=3 then Loss_Percentage_3
When @YearN=4 then Loss_Percentage_4
When @YearN=5 then Loss_Percentage_5
When @YearN=6 then Loss_Percentage_6
When @YearN=7 then Loss_Percentage_7
When @YearN=8 then Loss_Percentage_8
When @YearN=9 then Loss_Percentage_9
When @YearN=10 then Loss_Percentage_10
When @YearN=11 then Loss_Percentage_11
When @YearN=12 then Loss_Percentage_12
When @YearN=13 then Loss_Percentage_13
When @YearN=14 then Loss_Percentage_14
When @YearN=15 then Loss_Percentage_15
end as Loss_Percentage
from IFRS_Initial I1
Inner join IFRS_Initial_Detail I2 on (I2.DataID=I1.DataID)
Where I1.DataID=@DataID and I2.GroupType=@GroupType


Select	'BEL_Beginning'as Description, 	BEL_Beginning	as Nominal from @IFRS	Union All
Select	'BEL_Premium_Expected'as Description, 	BEL_Premium_Expected	as Nominal from @IFRS	Union All
Select	'BEL_Commission_Expected'as Description, 	BEL_Commission_Expected	as Nominal from @IFRS	Union All
Select	'BEL_Interest_Accrete'as Description, 	BEL_Interest_Accrete	as Nominal from @IFRS	Union All
Select	'BEL_Claim_Expected'as Description, 	BEL_Claim_Expected	as Nominal from @IFRS	Union All
Select	'BEL_Expense_Expected'as Description, 	BEL_Expense_Expected	as Nominal from @IFRS	Union All
Select	'BEL_Ending_Before_Change'as Description, 	BEL_Ending_Before_Change	as Nominal from @IFRS	Union All
Select	'BEL_Ending_After_Change_NonDiscRate'as Description, 	BEL_Ending_After_Change_NonDiscRate	as Nominal from @IFRS	Union All
Select	'BEL_Ending_After_Change_DiscRate'as Description, 	BEL_Ending_After_Change_DiscRate	as Nominal from @IFRS	Union All
Select	'BEL_GainLoss_NonDiscRate'as Description, 	BEL_GainLoss_NonDiscRate	as Nominal from @IFRS	Union All
Select	'BEL_GainLoss_DiscRate'as Description, 	BEL_GainLoss_DiscRate	as Nominal from @IFRS	Union All
Select	'RA_Beginning'as Description, 	RA_Beginning	as Nominal from @IFRS	Union All
Select	'RA_Interest_Accrete'as Description, 	RA_Interest_Accrete	as Nominal from @IFRS	Union All
Select	'RA_Release'as Description, 	RA_Release	as Nominal from @IFRS	Union All
Select	'RA_Ending_Before_Change'as Description, 	RA_Ending_Before_Change	as Nominal from @IFRS	Union All
Select	'RA_Ending_After_Change_NonDiscRate'as Description, 	RA_Ending_After_Change_NonDiscRate	as Nominal from @IFRS	Union All
Select	'RA_Ending_After_Change_DiscRate'as Description, 	RA_Ending_After_Change_DiscRate	as Nominal from @IFRS	Union All
Select	'RA_GainLoss_NonDiscRate'as Description, 	RA_GainLoss_NonDiscRate	as Nominal from @IFRS	Union All
Select	'RA_GainLoss_DiscRate'as Description, 	RA_GainLoss_DiscRate	as Nominal from @IFRS	Union All
Select	'CSM_Start'as Description, 	CSM_Start	as Nominal from @IFRS	Union All
Select	'CSM_Interest_Accrete'as Description, 	CSM_Interest_Accrete	as Nominal from @IFRS	Union All
Select	'CSM_Amortization'as Description, 	CSM_Amortization	as Nominal from @IFRS	Union All
Select	'CSM_GainLoss_Realization_Premium'as Description, 	CSM_GainLoss_Realization_Premium	as Nominal from @IFRS	Union All
Select	'CSM_GainLoss_Realization_Commission'as Description, 	CSM_GainLoss_Realization_Commission	as Nominal from @IFRS	Union All
Select	'CSM_GainLoss_NonDiscRate'as Description, 	CSM_GainLoss_NonDiscRate	as Nominal from @IFRS	Union All
Select	'CSM_End'as Description, 	CSM_End	as Nominal from @IFRS	Union All
Select	'Loss_Start'as Description, 	Loss_Start	as Nominal from @IFRS	Union All
Select	'Loss_Portion_from_Claim_Release'as Description, 	Loss_Portion_from_Claim_Release	as Nominal from @IFRS	Union All
Select	'Loss_Portion_from_Expense_Release'as Description, 	Loss_Portion_from_Expense_Release	as Nominal from @IFRS	Union All
Select	'Loss_Portion_from_RA_Release'as Description, 	Loss_Portion_from_RA_Release	as Nominal from @IFRS	Union All
Select	'Loss_Portion_from_Interest_Accrete'as Description, 	Loss_Portion_from_Interest_Accrete	as Nominal from @IFRS	Union All
Select	'Loss_GainLoss_Realization_Premium'as Description, 	Loss_GainLoss_Realization_Premium	as Nominal from @IFRS	Union All
Select	'Loss_GainLoss_Realization_Commission'as Description, 	Loss_GainLoss_Realization_Commission	as Nominal from @IFRS	Union All
Select	'Loss_Portion_from_GainLoss_DiscRate'as Description, 	Loss_Portion_from_GainLoss_DiscRate	as Nominal from @IFRS	Union All
Select	'Loss_GainLoss_NonDiscRate'as Description, 	Loss_GainLoss_NonDiscRate	as Nominal from @IFRS	Union All
Select	'Loss_End'as Description, 	Loss_End	as Nominal from @IFRS Union All	 
Select	'Loss_Percentage'as Description, 	Loss_Percentage	as Nominal from @IFRS

GO

--IFRS_SHOW_INITIAL '1002010700002-0',1,'I'


GO
Drop Procedure IFRS_SHOW_CALCULATION
GO

Create Procedure IFRS_SHOW_CALCULATION(@GroupID as int, @GroupType as varchar(1), @YearN as Int)
as

Declare @IFRS table (
	BEL_Beginning	Float,
	BEL_Premium_Expected	Float,
	BEL_Commission_Expected	Float,
	BEL_Interest_Accrete	Float,
	BEL_Claim_Expected	Float,
	BEL_Expense_Expected	Float,
	BEL_Ending_Before_Change	Float,
	BEL_Ending_After_Change_NonDiscRate	Float,
	BEL_Ending_After_Change_DiscRate	Float,
	BEL_GainLoss_NonDiscRate	Float,
	BEL_GainLoss_DiscRate	Float,
	RA_Beginning	Float,
	RA_Interest_Accrete	Float,
	RA_Release	Float,
	RA_Ending_Before_Change	Float,
	RA_Ending_After_Change_NonDiscRate	Float,
	RA_Ending_After_Change_DiscRate	Float,
	RA_GainLoss_NonDiscRate	Float,
	RA_GainLoss_DiscRate	Float,
	CSM_Start	Float,
	CSM_Interest_Accrete	Float,
	CSM_Amortization	Float,
	CSM_GainLoss_Realization_Premium	Float,
	CSM_GainLoss_Realization_Commission	Float,
	CSM_GainLoss_NonDiscRate	Float,
	CSM_End	Float,
	Loss_Start	Float,
	Loss_Portion_from_Claim_Release	Float,
	Loss_Portion_from_Expense_Release	Float,
	Loss_Portion_from_RA_Release	Float,
	Loss_Portion_from_Interest_Accrete	Float,
	Loss_GainLoss_Realization_Premium	Float,
	Loss_GainLoss_Realization_Commission	Float,
	Loss_Portion_from_GainLoss_DiscRate	Float,
	Loss_GainLoss_NonDiscRate	Float,
	Loss_End	Float,
	Loss_Percentage Float
)

insert into @IFRS
Select
Case 
When @YearN=1 then BEL_Beginning_1
When @YearN=2 then BEL_Beginning_2
When @YearN=3 then BEL_Beginning_3
When @YearN=4 then BEL_Beginning_4
When @YearN=5 then BEL_Beginning_5
When @YearN=6 then BEL_Beginning_6
When @YearN=7 then BEL_Beginning_7
When @YearN=8 then BEL_Beginning_8
When @YearN=9 then BEL_Beginning_9
When @YearN=10 then BEL_Beginning_10
When @YearN=11 then BEL_Beginning_11
When @YearN=12 then BEL_Beginning_12
When @YearN=13 then BEL_Beginning_13
When @YearN=14 then BEL_Beginning_14
When @YearN=15 then BEL_Beginning_15
end as BEL_Beginning,
Case 
When @YearN=1 then BEL_Premium_Expected_1
When @YearN=2 then BEL_Premium_Expected_2
When @YearN=3 then BEL_Premium_Expected_3
When @YearN=4 then BEL_Premium_Expected_4
When @YearN=5 then BEL_Premium_Expected_5
When @YearN=6 then BEL_Premium_Expected_6
When @YearN=7 then BEL_Premium_Expected_7
When @YearN=8 then BEL_Premium_Expected_8
When @YearN=9 then BEL_Premium_Expected_9
When @YearN=10 then BEL_Premium_Expected_10
When @YearN=11 then BEL_Premium_Expected_11
When @YearN=12 then BEL_Premium_Expected_12
When @YearN=13 then BEL_Premium_Expected_13
When @YearN=14 then BEL_Premium_Expected_14
When @YearN=15 then BEL_Premium_Expected_15
end as BEL_Premium_Expected,
Case 
When @YearN=1 then BEL_Commission_Expected_1
When @YearN=2 then BEL_Commission_Expected_2
When @YearN=3 then BEL_Commission_Expected_3
When @YearN=4 then BEL_Commission_Expected_4
When @YearN=5 then BEL_Commission_Expected_5
When @YearN=6 then BEL_Commission_Expected_6
When @YearN=7 then BEL_Commission_Expected_7
When @YearN=8 then BEL_Commission_Expected_8
When @YearN=9 then BEL_Commission_Expected_9
When @YearN=10 then BEL_Commission_Expected_10
When @YearN=11 then BEL_Commission_Expected_11
When @YearN=12 then BEL_Commission_Expected_12
When @YearN=13 then BEL_Commission_Expected_13
When @YearN=14 then BEL_Commission_Expected_14
When @YearN=15 then BEL_Commission_Expected_15
end as BEL_Commission_Expected,
Case 
When @YearN=1 then BEL_Interest_Accrete_1
When @YearN=2 then BEL_Interest_Accrete_2
When @YearN=3 then BEL_Interest_Accrete_3
When @YearN=4 then BEL_Interest_Accrete_4
When @YearN=5 then BEL_Interest_Accrete_5
When @YearN=6 then BEL_Interest_Accrete_6
When @YearN=7 then BEL_Interest_Accrete_7
When @YearN=8 then BEL_Interest_Accrete_8
When @YearN=9 then BEL_Interest_Accrete_9
When @YearN=10 then BEL_Interest_Accrete_10
When @YearN=11 then BEL_Interest_Accrete_11
When @YearN=12 then BEL_Interest_Accrete_12
When @YearN=13 then BEL_Interest_Accrete_13
When @YearN=14 then BEL_Interest_Accrete_14
When @YearN=15 then BEL_Interest_Accrete_15
end as BEL_Interest_Accrete,
Case 
When @YearN=1 then BEL_Claim_Expected_1
When @YearN=2 then BEL_Claim_Expected_2
When @YearN=3 then BEL_Claim_Expected_3
When @YearN=4 then BEL_Claim_Expected_4
When @YearN=5 then BEL_Claim_Expected_5
When @YearN=6 then BEL_Claim_Expected_6
When @YearN=7 then BEL_Claim_Expected_7
When @YearN=8 then BEL_Claim_Expected_8
When @YearN=9 then BEL_Claim_Expected_9
When @YearN=10 then BEL_Claim_Expected_10
When @YearN=11 then BEL_Claim_Expected_11
When @YearN=12 then BEL_Claim_Expected_12
When @YearN=13 then BEL_Claim_Expected_13
When @YearN=14 then BEL_Claim_Expected_14
When @YearN=15 then BEL_Claim_Expected_15
end as BEL_Claim_Expected,
Case 
When @YearN=1 then BEL_Expense_Expected_1
When @YearN=2 then BEL_Expense_Expected_2
When @YearN=3 then BEL_Expense_Expected_3
When @YearN=4 then BEL_Expense_Expected_4
When @YearN=5 then BEL_Expense_Expected_5
When @YearN=6 then BEL_Expense_Expected_6
When @YearN=7 then BEL_Expense_Expected_7
When @YearN=8 then BEL_Expense_Expected_8
When @YearN=9 then BEL_Expense_Expected_9
When @YearN=10 then BEL_Expense_Expected_10
When @YearN=11 then BEL_Expense_Expected_11
When @YearN=12 then BEL_Expense_Expected_12
When @YearN=13 then BEL_Expense_Expected_13
When @YearN=14 then BEL_Expense_Expected_14
When @YearN=15 then BEL_Expense_Expected_15
end as BEL_Expense_Expected,
Case 
When @YearN=1 then BEL_Ending_Before_Change_1
When @YearN=2 then BEL_Ending_Before_Change_2
When @YearN=3 then BEL_Ending_Before_Change_3
When @YearN=4 then BEL_Ending_Before_Change_4
When @YearN=5 then BEL_Ending_Before_Change_5
When @YearN=6 then BEL_Ending_Before_Change_6
When @YearN=7 then BEL_Ending_Before_Change_7
When @YearN=8 then BEL_Ending_Before_Change_8
When @YearN=9 then BEL_Ending_Before_Change_9
When @YearN=10 then BEL_Ending_Before_Change_10
When @YearN=11 then BEL_Ending_Before_Change_11
When @YearN=12 then BEL_Ending_Before_Change_12
When @YearN=13 then BEL_Ending_Before_Change_13
When @YearN=14 then BEL_Ending_Before_Change_14
When @YearN=15 then BEL_Ending_Before_Change_15
end as BEL_Ending_Before_Change,
Case 
When @YearN=1 then BEL_Ending_After_Change_NonDiscRate_1
When @YearN=2 then BEL_Ending_After_Change_NonDiscRate_2
When @YearN=3 then BEL_Ending_After_Change_NonDiscRate_3
When @YearN=4 then BEL_Ending_After_Change_NonDiscRate_4
When @YearN=5 then BEL_Ending_After_Change_NonDiscRate_5
When @YearN=6 then BEL_Ending_After_Change_NonDiscRate_6
When @YearN=7 then BEL_Ending_After_Change_NonDiscRate_7
When @YearN=8 then BEL_Ending_After_Change_NonDiscRate_8
When @YearN=9 then BEL_Ending_After_Change_NonDiscRate_9
When @YearN=10 then BEL_Ending_After_Change_NonDiscRate_10
When @YearN=11 then BEL_Ending_After_Change_NonDiscRate_11
When @YearN=12 then BEL_Ending_After_Change_NonDiscRate_12
When @YearN=13 then BEL_Ending_After_Change_NonDiscRate_13
When @YearN=14 then BEL_Ending_After_Change_NonDiscRate_14
When @YearN=15 then BEL_Ending_After_Change_NonDiscRate_15
end as BEL_Ending_After_Change_NonDiscRate,
Case 
When @YearN=1 then BEL_Ending_After_Change_DiscRate_1
When @YearN=2 then BEL_Ending_After_Change_DiscRate_2
When @YearN=3 then BEL_Ending_After_Change_DiscRate_3
When @YearN=4 then BEL_Ending_After_Change_DiscRate_4
When @YearN=5 then BEL_Ending_After_Change_DiscRate_5
When @YearN=6 then BEL_Ending_After_Change_DiscRate_6
When @YearN=7 then BEL_Ending_After_Change_DiscRate_7
When @YearN=8 then BEL_Ending_After_Change_DiscRate_8
When @YearN=9 then BEL_Ending_After_Change_DiscRate_9
When @YearN=10 then BEL_Ending_After_Change_DiscRate_10
When @YearN=11 then BEL_Ending_After_Change_DiscRate_11
When @YearN=12 then BEL_Ending_After_Change_DiscRate_12
When @YearN=13 then BEL_Ending_After_Change_DiscRate_13
When @YearN=14 then BEL_Ending_After_Change_DiscRate_14
When @YearN=15 then BEL_Ending_After_Change_DiscRate_15
end as BEL_Ending_After_Change_DiscRate,
Case 
When @YearN=1 then BEL_GainLoss_NonDiscRate_1
When @YearN=2 then BEL_GainLoss_NonDiscRate_2
When @YearN=3 then BEL_GainLoss_NonDiscRate_3
When @YearN=4 then BEL_GainLoss_NonDiscRate_4
When @YearN=5 then BEL_GainLoss_NonDiscRate_5
When @YearN=6 then BEL_GainLoss_NonDiscRate_6
When @YearN=7 then BEL_GainLoss_NonDiscRate_7
When @YearN=8 then BEL_GainLoss_NonDiscRate_8
When @YearN=9 then BEL_GainLoss_NonDiscRate_9
When @YearN=10 then BEL_GainLoss_NonDiscRate_10
When @YearN=11 then BEL_GainLoss_NonDiscRate_11
When @YearN=12 then BEL_GainLoss_NonDiscRate_12
When @YearN=13 then BEL_GainLoss_NonDiscRate_13
When @YearN=14 then BEL_GainLoss_NonDiscRate_14
When @YearN=15 then BEL_GainLoss_NonDiscRate_15
end as BEL_GainLoss_NonDiscRate,
Case 
When @YearN=1 then BEL_GainLoss_DiscRate_1
When @YearN=2 then BEL_GainLoss_DiscRate_2
When @YearN=3 then BEL_GainLoss_DiscRate_3
When @YearN=4 then BEL_GainLoss_DiscRate_4
When @YearN=5 then BEL_GainLoss_DiscRate_5
When @YearN=6 then BEL_GainLoss_DiscRate_6
When @YearN=7 then BEL_GainLoss_DiscRate_7
When @YearN=8 then BEL_GainLoss_DiscRate_8
When @YearN=9 then BEL_GainLoss_DiscRate_9
When @YearN=10 then BEL_GainLoss_DiscRate_10
When @YearN=11 then BEL_GainLoss_DiscRate_11
When @YearN=12 then BEL_GainLoss_DiscRate_12
When @YearN=13 then BEL_GainLoss_DiscRate_13
When @YearN=14 then BEL_GainLoss_DiscRate_14
When @YearN=15 then BEL_GainLoss_DiscRate_15
end as BEL_GainLoss_DiscRate,
Case 
When @YearN=1 then RA_Beginning_1
When @YearN=2 then RA_Beginning_2
When @YearN=3 then RA_Beginning_3
When @YearN=4 then RA_Beginning_4
When @YearN=5 then RA_Beginning_5
When @YearN=6 then RA_Beginning_6
When @YearN=7 then RA_Beginning_7
When @YearN=8 then RA_Beginning_8
When @YearN=9 then RA_Beginning_9
When @YearN=10 then RA_Beginning_10
When @YearN=11 then RA_Beginning_11
When @YearN=12 then RA_Beginning_12
When @YearN=13 then RA_Beginning_13
When @YearN=14 then RA_Beginning_14
When @YearN=15 then RA_Beginning_15
end as RA_Beginning,
Case 
When @YearN=1 then RA_Interest_Accrete_1
When @YearN=2 then RA_Interest_Accrete_2
When @YearN=3 then RA_Interest_Accrete_3
When @YearN=4 then RA_Interest_Accrete_4
When @YearN=5 then RA_Interest_Accrete_5
When @YearN=6 then RA_Interest_Accrete_6
When @YearN=7 then RA_Interest_Accrete_7
When @YearN=8 then RA_Interest_Accrete_8
When @YearN=9 then RA_Interest_Accrete_9
When @YearN=10 then RA_Interest_Accrete_10
When @YearN=11 then RA_Interest_Accrete_11
When @YearN=12 then RA_Interest_Accrete_12
When @YearN=13 then RA_Interest_Accrete_13
When @YearN=14 then RA_Interest_Accrete_14
When @YearN=15 then RA_Interest_Accrete_15
end as RA_Interest_Accrete,
Case 
When @YearN=1 then RA_Release_1
When @YearN=2 then RA_Release_2
When @YearN=3 then RA_Release_3
When @YearN=4 then RA_Release_4
When @YearN=5 then RA_Release_5
When @YearN=6 then RA_Release_6
When @YearN=7 then RA_Release_7
When @YearN=8 then RA_Release_8
When @YearN=9 then RA_Release_9
When @YearN=10 then RA_Release_10
When @YearN=11 then RA_Release_11
When @YearN=12 then RA_Release_12
When @YearN=13 then RA_Release_13
When @YearN=14 then RA_Release_14
When @YearN=15 then RA_Release_15
end as RA_Release,
Case 
When @YearN=1 then RA_Ending_Before_Change_1
When @YearN=2 then RA_Ending_Before_Change_2
When @YearN=3 then RA_Ending_Before_Change_3
When @YearN=4 then RA_Ending_Before_Change_4
When @YearN=5 then RA_Ending_Before_Change_5
When @YearN=6 then RA_Ending_Before_Change_6
When @YearN=7 then RA_Ending_Before_Change_7
When @YearN=8 then RA_Ending_Before_Change_8
When @YearN=9 then RA_Ending_Before_Change_9
When @YearN=10 then RA_Ending_Before_Change_10
When @YearN=11 then RA_Ending_Before_Change_11
When @YearN=12 then RA_Ending_Before_Change_12
When @YearN=13 then RA_Ending_Before_Change_13
When @YearN=14 then RA_Ending_Before_Change_14
When @YearN=15 then RA_Ending_Before_Change_15
end as RA_Ending_Before_Change,
Case 
When @YearN=1 then RA_Ending_After_Change_NonDiscRate_1
When @YearN=2 then RA_Ending_After_Change_NonDiscRate_2
When @YearN=3 then RA_Ending_After_Change_NonDiscRate_3
When @YearN=4 then RA_Ending_After_Change_NonDiscRate_4
When @YearN=5 then RA_Ending_After_Change_NonDiscRate_5
When @YearN=6 then RA_Ending_After_Change_NonDiscRate_6
When @YearN=7 then RA_Ending_After_Change_NonDiscRate_7
When @YearN=8 then RA_Ending_After_Change_NonDiscRate_8
When @YearN=9 then RA_Ending_After_Change_NonDiscRate_9
When @YearN=10 then RA_Ending_After_Change_NonDiscRate_10
When @YearN=11 then RA_Ending_After_Change_NonDiscRate_11
When @YearN=12 then RA_Ending_After_Change_NonDiscRate_12
When @YearN=13 then RA_Ending_After_Change_NonDiscRate_13
When @YearN=14 then RA_Ending_After_Change_NonDiscRate_14
When @YearN=15 then RA_Ending_After_Change_NonDiscRate_15
end as RA_Ending_After_Change_NonDiscRate,
Case 
When @YearN=1 then RA_Ending_After_Change_DiscRate_1
When @YearN=2 then RA_Ending_After_Change_DiscRate_2
When @YearN=3 then RA_Ending_After_Change_DiscRate_3
When @YearN=4 then RA_Ending_After_Change_DiscRate_4
When @YearN=5 then RA_Ending_After_Change_DiscRate_5
When @YearN=6 then RA_Ending_After_Change_DiscRate_6
When @YearN=7 then RA_Ending_After_Change_DiscRate_7
When @YearN=8 then RA_Ending_After_Change_DiscRate_8
When @YearN=9 then RA_Ending_After_Change_DiscRate_9
When @YearN=10 then RA_Ending_After_Change_DiscRate_10
When @YearN=11 then RA_Ending_After_Change_DiscRate_11
When @YearN=12 then RA_Ending_After_Change_DiscRate_12
When @YearN=13 then RA_Ending_After_Change_DiscRate_13
When @YearN=14 then RA_Ending_After_Change_DiscRate_14
When @YearN=15 then RA_Ending_After_Change_DiscRate_15
end as RA_Ending_After_Change_DiscRate,
Case 
When @YearN=1 then RA_GainLoss_NonDiscRate_1
When @YearN=2 then RA_GainLoss_NonDiscRate_2
When @YearN=3 then RA_GainLoss_NonDiscRate_3
When @YearN=4 then RA_GainLoss_NonDiscRate_4
When @YearN=5 then RA_GainLoss_NonDiscRate_5
When @YearN=6 then RA_GainLoss_NonDiscRate_6
When @YearN=7 then RA_GainLoss_NonDiscRate_7
When @YearN=8 then RA_GainLoss_NonDiscRate_8
When @YearN=9 then RA_GainLoss_NonDiscRate_9
When @YearN=10 then RA_GainLoss_NonDiscRate_10
When @YearN=11 then RA_GainLoss_NonDiscRate_11
When @YearN=12 then RA_GainLoss_NonDiscRate_12
When @YearN=13 then RA_GainLoss_NonDiscRate_13
When @YearN=14 then RA_GainLoss_NonDiscRate_14
When @YearN=15 then RA_GainLoss_NonDiscRate_15
end as RA_GainLoss_NonDiscRate,
Case 
When @YearN=1 then RA_GainLoss_DiscRate_1
When @YearN=2 then RA_GainLoss_DiscRate_2
When @YearN=3 then RA_GainLoss_DiscRate_3
When @YearN=4 then RA_GainLoss_DiscRate_4
When @YearN=5 then RA_GainLoss_DiscRate_5
When @YearN=6 then RA_GainLoss_DiscRate_6
When @YearN=7 then RA_GainLoss_DiscRate_7
When @YearN=8 then RA_GainLoss_DiscRate_8
When @YearN=9 then RA_GainLoss_DiscRate_9
When @YearN=10 then RA_GainLoss_DiscRate_10
When @YearN=11 then RA_GainLoss_DiscRate_11
When @YearN=12 then RA_GainLoss_DiscRate_12
When @YearN=13 then RA_GainLoss_DiscRate_13
When @YearN=14 then RA_GainLoss_DiscRate_14
When @YearN=15 then RA_GainLoss_DiscRate_15
end as RA_GainLoss_DiscRate,
Case 
When @YearN=1 then CSM_Start_1
When @YearN=2 then CSM_Start_2
When @YearN=3 then CSM_Start_3
When @YearN=4 then CSM_Start_4
When @YearN=5 then CSM_Start_5
When @YearN=6 then CSM_Start_6
When @YearN=7 then CSM_Start_7
When @YearN=8 then CSM_Start_8
When @YearN=9 then CSM_Start_9
When @YearN=10 then CSM_Start_10
When @YearN=11 then CSM_Start_11
When @YearN=12 then CSM_Start_12
When @YearN=13 then CSM_Start_13
When @YearN=14 then CSM_Start_14
When @YearN=15 then CSM_Start_15
end as CSM_Start,
Case 
When @YearN=1 then CSM_Interest_Accrete_1
When @YearN=2 then CSM_Interest_Accrete_2
When @YearN=3 then CSM_Interest_Accrete_3
When @YearN=4 then CSM_Interest_Accrete_4
When @YearN=5 then CSM_Interest_Accrete_5
When @YearN=6 then CSM_Interest_Accrete_6
When @YearN=7 then CSM_Interest_Accrete_7
When @YearN=8 then CSM_Interest_Accrete_8
When @YearN=9 then CSM_Interest_Accrete_9
When @YearN=10 then CSM_Interest_Accrete_10
When @YearN=11 then CSM_Interest_Accrete_11
When @YearN=12 then CSM_Interest_Accrete_12
When @YearN=13 then CSM_Interest_Accrete_13
When @YearN=14 then CSM_Interest_Accrete_14
When @YearN=15 then CSM_Interest_Accrete_15
end as CSM_Interest_Accrete,
Case 
When @YearN=1 then CSM_Amortization_1
When @YearN=2 then CSM_Amortization_2
When @YearN=3 then CSM_Amortization_3
When @YearN=4 then CSM_Amortization_4
When @YearN=5 then CSM_Amortization_5
When @YearN=6 then CSM_Amortization_6
When @YearN=7 then CSM_Amortization_7
When @YearN=8 then CSM_Amortization_8
When @YearN=9 then CSM_Amortization_9
When @YearN=10 then CSM_Amortization_10
When @YearN=11 then CSM_Amortization_11
When @YearN=12 then CSM_Amortization_12
When @YearN=13 then CSM_Amortization_13
When @YearN=14 then CSM_Amortization_14
When @YearN=15 then CSM_Amortization_15
end as CSM_Amortization,
Case 
When @YearN=1 then CSM_GainLoss_Realization_Premium_1
When @YearN=2 then CSM_GainLoss_Realization_Premium_2
When @YearN=3 then CSM_GainLoss_Realization_Premium_3
When @YearN=4 then CSM_GainLoss_Realization_Premium_4
When @YearN=5 then CSM_GainLoss_Realization_Premium_5
When @YearN=6 then CSM_GainLoss_Realization_Premium_6
When @YearN=7 then CSM_GainLoss_Realization_Premium_7
When @YearN=8 then CSM_GainLoss_Realization_Premium_8
When @YearN=9 then CSM_GainLoss_Realization_Premium_9
When @YearN=10 then CSM_GainLoss_Realization_Premium_10
When @YearN=11 then CSM_GainLoss_Realization_Premium_11
When @YearN=12 then CSM_GainLoss_Realization_Premium_12
When @YearN=13 then CSM_GainLoss_Realization_Premium_13
When @YearN=14 then CSM_GainLoss_Realization_Premium_14
When @YearN=15 then CSM_GainLoss_Realization_Premium_15
end as CSM_GainLoss_Realization_Premium,
Case 
When @YearN=1 then CSM_GainLoss_Realization_Commission_1
When @YearN=2 then CSM_GainLoss_Realization_Commission_2
When @YearN=3 then CSM_GainLoss_Realization_Commission_3
When @YearN=4 then CSM_GainLoss_Realization_Commission_4
When @YearN=5 then CSM_GainLoss_Realization_Commission_5
When @YearN=6 then CSM_GainLoss_Realization_Commission_6
When @YearN=7 then CSM_GainLoss_Realization_Commission_7
When @YearN=8 then CSM_GainLoss_Realization_Commission_8
When @YearN=9 then CSM_GainLoss_Realization_Commission_9
When @YearN=10 then CSM_GainLoss_Realization_Commission_10
When @YearN=11 then CSM_GainLoss_Realization_Commission_11
When @YearN=12 then CSM_GainLoss_Realization_Commission_12
When @YearN=13 then CSM_GainLoss_Realization_Commission_13
When @YearN=14 then CSM_GainLoss_Realization_Commission_14
When @YearN=15 then CSM_GainLoss_Realization_Commission_15
end as CSM_GainLoss_Realization_Commission,
Case 
When @YearN=1 then CSM_GainLoss_NonDiscRate_1
When @YearN=2 then CSM_GainLoss_NonDiscRate_2
When @YearN=3 then CSM_GainLoss_NonDiscRate_3
When @YearN=4 then CSM_GainLoss_NonDiscRate_4
When @YearN=5 then CSM_GainLoss_NonDiscRate_5
When @YearN=6 then CSM_GainLoss_NonDiscRate_6
When @YearN=7 then CSM_GainLoss_NonDiscRate_7
When @YearN=8 then CSM_GainLoss_NonDiscRate_8
When @YearN=9 then CSM_GainLoss_NonDiscRate_9
When @YearN=10 then CSM_GainLoss_NonDiscRate_10
When @YearN=11 then CSM_GainLoss_NonDiscRate_11
When @YearN=12 then CSM_GainLoss_NonDiscRate_12
When @YearN=13 then CSM_GainLoss_NonDiscRate_13
When @YearN=14 then CSM_GainLoss_NonDiscRate_14
When @YearN=15 then CSM_GainLoss_NonDiscRate_15
end as CSM_GainLoss_NonDiscRate,
Case 
When @YearN=1 then CSM_End_1
When @YearN=2 then CSM_End_2
When @YearN=3 then CSM_End_3
When @YearN=4 then CSM_End_4
When @YearN=5 then CSM_End_5
When @YearN=6 then CSM_End_6
When @YearN=7 then CSM_End_7
When @YearN=8 then CSM_End_8
When @YearN=9 then CSM_End_9
When @YearN=10 then CSM_End_10
When @YearN=11 then CSM_End_11
When @YearN=12 then CSM_End_12
When @YearN=13 then CSM_End_13
When @YearN=14 then CSM_End_14
When @YearN=15 then CSM_End_15
end as CSM_End,
Case 
When @YearN=1 then Loss_Start_1
When @YearN=2 then Loss_Start_2
When @YearN=3 then Loss_Start_3
When @YearN=4 then Loss_Start_4
When @YearN=5 then Loss_Start_5
When @YearN=6 then Loss_Start_6
When @YearN=7 then Loss_Start_7
When @YearN=8 then Loss_Start_8
When @YearN=9 then Loss_Start_9
When @YearN=10 then Loss_Start_10
When @YearN=11 then Loss_Start_11
When @YearN=12 then Loss_Start_12
When @YearN=13 then Loss_Start_13
When @YearN=14 then Loss_Start_14
When @YearN=15 then Loss_Start_15
end as Loss_Start,
Case 
When @YearN=1 then Loss_Portion_from_Claim_Release_1
When @YearN=2 then Loss_Portion_from_Claim_Release_2
When @YearN=3 then Loss_Portion_from_Claim_Release_3
When @YearN=4 then Loss_Portion_from_Claim_Release_4
When @YearN=5 then Loss_Portion_from_Claim_Release_5
When @YearN=6 then Loss_Portion_from_Claim_Release_6
When @YearN=7 then Loss_Portion_from_Claim_Release_7
When @YearN=8 then Loss_Portion_from_Claim_Release_8
When @YearN=9 then Loss_Portion_from_Claim_Release_9
When @YearN=10 then Loss_Portion_from_Claim_Release_10
When @YearN=11 then Loss_Portion_from_Claim_Release_11
When @YearN=12 then Loss_Portion_from_Claim_Release_12
When @YearN=13 then Loss_Portion_from_Claim_Release_13
When @YearN=14 then Loss_Portion_from_Claim_Release_14
When @YearN=15 then Loss_Portion_from_Claim_Release_15
end as Loss_Portion_from_Claim_Release,
Case 
When @YearN=1 then Loss_Portion_from_Expense_Release_1
When @YearN=2 then Loss_Portion_from_Expense_Release_2
When @YearN=3 then Loss_Portion_from_Expense_Release_3
When @YearN=4 then Loss_Portion_from_Expense_Release_4
When @YearN=5 then Loss_Portion_from_Expense_Release_5
When @YearN=6 then Loss_Portion_from_Expense_Release_6
When @YearN=7 then Loss_Portion_from_Expense_Release_7
When @YearN=8 then Loss_Portion_from_Expense_Release_8
When @YearN=9 then Loss_Portion_from_Expense_Release_9
When @YearN=10 then Loss_Portion_from_Expense_Release_10
When @YearN=11 then Loss_Portion_from_Expense_Release_11
When @YearN=12 then Loss_Portion_from_Expense_Release_12
When @YearN=13 then Loss_Portion_from_Expense_Release_13
When @YearN=14 then Loss_Portion_from_Expense_Release_14
When @YearN=15 then Loss_Portion_from_Expense_Release_15
end as Loss_Portion_from_Expense_Release,
Case 
When @YearN=1 then Loss_Portion_from_RA_Release_1
When @YearN=2 then Loss_Portion_from_RA_Release_2
When @YearN=3 then Loss_Portion_from_RA_Release_3
When @YearN=4 then Loss_Portion_from_RA_Release_4
When @YearN=5 then Loss_Portion_from_RA_Release_5
When @YearN=6 then Loss_Portion_from_RA_Release_6
When @YearN=7 then Loss_Portion_from_RA_Release_7
When @YearN=8 then Loss_Portion_from_RA_Release_8
When @YearN=9 then Loss_Portion_from_RA_Release_9
When @YearN=10 then Loss_Portion_from_RA_Release_10
When @YearN=11 then Loss_Portion_from_RA_Release_11
When @YearN=12 then Loss_Portion_from_RA_Release_12
When @YearN=13 then Loss_Portion_from_RA_Release_13
When @YearN=14 then Loss_Portion_from_RA_Release_14
When @YearN=15 then Loss_Portion_from_RA_Release_15
end as Loss_Portion_from_RA_Release,
Case 
When @YearN=1 then Loss_Portion_from_Interest_Accrete_1
When @YearN=2 then Loss_Portion_from_Interest_Accrete_2
When @YearN=3 then Loss_Portion_from_Interest_Accrete_3
When @YearN=4 then Loss_Portion_from_Interest_Accrete_4
When @YearN=5 then Loss_Portion_from_Interest_Accrete_5
When @YearN=6 then Loss_Portion_from_Interest_Accrete_6
When @YearN=7 then Loss_Portion_from_Interest_Accrete_7
When @YearN=8 then Loss_Portion_from_Interest_Accrete_8
When @YearN=9 then Loss_Portion_from_Interest_Accrete_9
When @YearN=10 then Loss_Portion_from_Interest_Accrete_10
When @YearN=11 then Loss_Portion_from_Interest_Accrete_11
When @YearN=12 then Loss_Portion_from_Interest_Accrete_12
When @YearN=13 then Loss_Portion_from_Interest_Accrete_13
When @YearN=14 then Loss_Portion_from_Interest_Accrete_14
When @YearN=15 then Loss_Portion_from_Interest_Accrete_15
end as Loss_Portion_from_Interest_Accrete,
Case 
When @YearN=1 then Loss_GainLoss_Realization_Premium_1
When @YearN=2 then Loss_GainLoss_Realization_Premium_2
When @YearN=3 then Loss_GainLoss_Realization_Premium_3
When @YearN=4 then Loss_GainLoss_Realization_Premium_4
When @YearN=5 then Loss_GainLoss_Realization_Premium_5
When @YearN=6 then Loss_GainLoss_Realization_Premium_6
When @YearN=7 then Loss_GainLoss_Realization_Premium_7
When @YearN=8 then Loss_GainLoss_Realization_Premium_8
When @YearN=9 then Loss_GainLoss_Realization_Premium_9
When @YearN=10 then Loss_GainLoss_Realization_Premium_10
When @YearN=11 then Loss_GainLoss_Realization_Premium_11
When @YearN=12 then Loss_GainLoss_Realization_Premium_12
When @YearN=13 then Loss_GainLoss_Realization_Premium_13
When @YearN=14 then Loss_GainLoss_Realization_Premium_14
When @YearN=15 then Loss_GainLoss_Realization_Premium_15
end as Loss_GainLoss_Realization_Premium,
Case 
When @YearN=1 then Loss_GainLoss_Realization_Commission_1
When @YearN=2 then Loss_GainLoss_Realization_Commission_2
When @YearN=3 then Loss_GainLoss_Realization_Commission_3
When @YearN=4 then Loss_GainLoss_Realization_Commission_4
When @YearN=5 then Loss_GainLoss_Realization_Commission_5
When @YearN=6 then Loss_GainLoss_Realization_Commission_6
When @YearN=7 then Loss_GainLoss_Realization_Commission_7
When @YearN=8 then Loss_GainLoss_Realization_Commission_8
When @YearN=9 then Loss_GainLoss_Realization_Commission_9
When @YearN=10 then Loss_GainLoss_Realization_Commission_10
When @YearN=11 then Loss_GainLoss_Realization_Commission_11
When @YearN=12 then Loss_GainLoss_Realization_Commission_12
When @YearN=13 then Loss_GainLoss_Realization_Commission_13
When @YearN=14 then Loss_GainLoss_Realization_Commission_14
When @YearN=15 then Loss_GainLoss_Realization_Commission_15
end as Loss_GainLoss_Realization_Commission,
Case 
When @YearN=1 then Loss_Portion_from_GainLoss_DiscRate_1
When @YearN=2 then Loss_Portion_from_GainLoss_DiscRate_2
When @YearN=3 then Loss_Portion_from_GainLoss_DiscRate_3
When @YearN=4 then Loss_Portion_from_GainLoss_DiscRate_4
When @YearN=5 then Loss_Portion_from_GainLoss_DiscRate_5
When @YearN=6 then Loss_Portion_from_GainLoss_DiscRate_6
When @YearN=7 then Loss_Portion_from_GainLoss_DiscRate_7
When @YearN=8 then Loss_Portion_from_GainLoss_DiscRate_8
When @YearN=9 then Loss_Portion_from_GainLoss_DiscRate_9
When @YearN=10 then Loss_Portion_from_GainLoss_DiscRate_10
When @YearN=11 then Loss_Portion_from_GainLoss_DiscRate_11
When @YearN=12 then Loss_Portion_from_GainLoss_DiscRate_12
When @YearN=13 then Loss_Portion_from_GainLoss_DiscRate_13
When @YearN=14 then Loss_Portion_from_GainLoss_DiscRate_14
When @YearN=15 then Loss_Portion_from_GainLoss_DiscRate_15
end as Loss_Portion_from_GainLoss_DiscRate,
Case 
When @YearN=1 then Loss_GainLoss_NonDiscRate_1
When @YearN=2 then Loss_GainLoss_NonDiscRate_2
When @YearN=3 then Loss_GainLoss_NonDiscRate_3
When @YearN=4 then Loss_GainLoss_NonDiscRate_4
When @YearN=5 then Loss_GainLoss_NonDiscRate_5
When @YearN=6 then Loss_GainLoss_NonDiscRate_6
When @YearN=7 then Loss_GainLoss_NonDiscRate_7
When @YearN=8 then Loss_GainLoss_NonDiscRate_8
When @YearN=9 then Loss_GainLoss_NonDiscRate_9
When @YearN=10 then Loss_GainLoss_NonDiscRate_10
When @YearN=11 then Loss_GainLoss_NonDiscRate_11
When @YearN=12 then Loss_GainLoss_NonDiscRate_12
When @YearN=13 then Loss_GainLoss_NonDiscRate_13
When @YearN=14 then Loss_GainLoss_NonDiscRate_14
When @YearN=15 then Loss_GainLoss_NonDiscRate_15
end as Loss_GainLoss_NonDiscRate,
Case 
When @YearN=1 then Loss_End_1
When @YearN=2 then Loss_End_2
When @YearN=3 then Loss_End_3
When @YearN=4 then Loss_End_4
When @YearN=5 then Loss_End_5
When @YearN=6 then Loss_End_6
When @YearN=7 then Loss_End_7
When @YearN=8 then Loss_End_8
When @YearN=9 then Loss_End_9
When @YearN=10 then Loss_End_10
When @YearN=11 then Loss_End_11
When @YearN=12 then Loss_End_12
When @YearN=13 then Loss_End_13
When @YearN=14 then Loss_End_14
When @YearN=15 then Loss_End_15
end as Loss_End,
Case 
When @YearN=1 then Loss_Percentage_1
When @YearN=2 then Loss_Percentage_2
When @YearN=3 then Loss_Percentage_3
When @YearN=4 then Loss_Percentage_4
When @YearN=5 then Loss_Percentage_5
When @YearN=6 then Loss_Percentage_6
When @YearN=7 then Loss_Percentage_7
When @YearN=8 then Loss_Percentage_8
When @YearN=9 then Loss_Percentage_9
When @YearN=10 then Loss_Percentage_10
When @YearN=11 then Loss_Percentage_11
When @YearN=12 then Loss_Percentage_12
When @YearN=13 then Loss_Percentage_13
When @YearN=14 then Loss_Percentage_14
When @YearN=15 then Loss_Percentage_15
end as Loss_Percentage
from IFRS_Calculation I1
Inner join IFRS_Calculation_Detail I2 on (I2.GroupID=I1.GroupID)
Where I1.GroupID=@GroupID and I2.GroupType=@GroupType


Select	'BEL_Beginning'as Description, 	BEL_Beginning	as Nominal from @IFRS	Union All
Select	'BEL_Premium_Expected'as Description, 	BEL_Premium_Expected	as Nominal from @IFRS	Union All
Select	'BEL_Commission_Expected'as Description, 	BEL_Commission_Expected	as Nominal from @IFRS	Union All
Select	'BEL_Interest_Accrete'as Description, 	BEL_Interest_Accrete	as Nominal from @IFRS	Union All
Select	'BEL_Claim_Expected'as Description, 	BEL_Claim_Expected	as Nominal from @IFRS	Union All
Select	'BEL_Expense_Expected'as Description, 	BEL_Expense_Expected	as Nominal from @IFRS	Union All
Select	'BEL_Ending_Before_Change'as Description, 	BEL_Ending_Before_Change	as Nominal from @IFRS	Union All
Select	'BEL_Ending_After_Change_NonDiscRate'as Description, 	BEL_Ending_After_Change_NonDiscRate	as Nominal from @IFRS	Union All
Select	'BEL_Ending_After_Change_DiscRate'as Description, 	BEL_Ending_After_Change_DiscRate	as Nominal from @IFRS	Union All
Select	'BEL_GainLoss_NonDiscRate'as Description, 	BEL_GainLoss_NonDiscRate	as Nominal from @IFRS	Union All
Select	'BEL_GainLoss_DiscRate'as Description, 	BEL_GainLoss_DiscRate	as Nominal from @IFRS	Union All
Select	'RA_Beginning'as Description, 	RA_Beginning	as Nominal from @IFRS	Union All
Select	'RA_Interest_Accrete'as Description, 	RA_Interest_Accrete	as Nominal from @IFRS	Union All
Select	'RA_Release'as Description, 	RA_Release	as Nominal from @IFRS	Union All
Select	'RA_Ending_Before_Change'as Description, 	RA_Ending_Before_Change	as Nominal from @IFRS	Union All
Select	'RA_Ending_After_Change_NonDiscRate'as Description, 	RA_Ending_After_Change_NonDiscRate	as Nominal from @IFRS	Union All
Select	'RA_Ending_After_Change_DiscRate'as Description, 	RA_Ending_After_Change_DiscRate	as Nominal from @IFRS	Union All
Select	'RA_GainLoss_NonDiscRate'as Description, 	RA_GainLoss_NonDiscRate	as Nominal from @IFRS	Union All
Select	'RA_GainLoss_DiscRate'as Description, 	RA_GainLoss_DiscRate	as Nominal from @IFRS	Union All
Select	'CSM_Start'as Description, 	CSM_Start	as Nominal from @IFRS	Union All
Select	'CSM_Interest_Accrete'as Description, 	CSM_Interest_Accrete	as Nominal from @IFRS	Union All
Select	'CSM_Amortization'as Description, 	CSM_Amortization	as Nominal from @IFRS	Union All
Select	'CSM_GainLoss_Realization_Premium'as Description, 	CSM_GainLoss_Realization_Premium	as Nominal from @IFRS	Union All
Select	'CSM_GainLoss_Realization_Commission'as Description, 	CSM_GainLoss_Realization_Commission	as Nominal from @IFRS	Union All
Select	'CSM_GainLoss_NonDiscRate'as Description, 	CSM_GainLoss_NonDiscRate	as Nominal from @IFRS	Union All
Select	'CSM_End'as Description, 	CSM_End	as Nominal from @IFRS	Union All
Select	'Loss_Start'as Description, 	Loss_Start	as Nominal from @IFRS	Union All
Select	'Loss_Portion_from_Claim_Release'as Description, 	Loss_Portion_from_Claim_Release	as Nominal from @IFRS	Union All
Select	'Loss_Portion_from_Expense_Release'as Description, 	Loss_Portion_from_Expense_Release	as Nominal from @IFRS	Union All
Select	'Loss_Portion_from_RA_Release'as Description, 	Loss_Portion_from_RA_Release	as Nominal from @IFRS	Union All
Select	'Loss_Portion_from_Interest_Accrete'as Description, 	Loss_Portion_from_Interest_Accrete	as Nominal from @IFRS	Union All
Select	'Loss_GainLoss_Realization_Premium'as Description, 	Loss_GainLoss_Realization_Premium	as Nominal from @IFRS	Union All
Select	'Loss_GainLoss_Realization_Commission'as Description, 	Loss_GainLoss_Realization_Commission	as Nominal from @IFRS	Union All
Select	'Loss_Portion_from_GainLoss_DiscRate'as Description, 	Loss_Portion_from_GainLoss_DiscRate	as Nominal from @IFRS	Union All
Select	'Loss_GainLoss_NonDiscRate'as Description, 	Loss_GainLoss_NonDiscRate	as Nominal from @IFRS	Union All
Select	'Loss_End'as Description, 	Loss_End	as Nominal from @IFRS Union All	 
Select	'Loss_Percentage'as Description, 	Loss_Percentage	as Nominal from @IFRS

GO

--IFRS_SHOW_CALCULATION 1,'I',1

insert into Mparam(Type, Remarks, MemorialF, Effective)
Select 'IF', 'IFRS Monthly Process',1,'01/01/2021'
union all
Select 'IFIB', 'IFRS Insurance BBA',0,'01/01/2021'
union all
Select 'IFRB', 'IFRS Reinsurance BBA',0,'01/01/2021'
union all
Select 'IFIP', 'IFRS Insurance PAA',0,'01/01/2021'
union all
Select 'IFRP', 'IFRS Reinsurance PAA',0,'01/01/2021'
GO

DROP FUNCTION IFRS_Movement_PROCESS
GO
CREATE FUNCTION IFRS_Movement_PROCESS(@P_Type varchar(2),@P_Date smalldatetime, @P_PEDate smalldatetime,@P_EDate smalldatetime)            
RETURNS TABLE            
AS RETURN(            
Select I2.Branch, '' as DocNo, '' as RefNo, @P_Date as Date, I2.TOC as Code, 
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
Amount_27 = sum(I1.ACQ_Amortization)
from IFRS_Movement I1 
Inner join IFRS_Calculation I2 on (I2.GroupID=I1.GroupID)
Inner join SysTab on (1=1)
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
SysTab.Currency, 
MParam.Remarks
)            

GO


--Select * from IFRS_Movement_PROCESS('IF','01/31/2007','12/30/2006','01/31/2007')


