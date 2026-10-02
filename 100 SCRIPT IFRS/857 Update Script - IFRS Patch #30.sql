DROP Procedure IFRS_SHOW_INITIAL
GO
Create Procedure IFRS_SHOW_INITIAL(@DataID as Int, @GroupType as varchar(1), @YearN as Int)
as

Declare @IFRS table (
 BEL_Beginning Float,
 BEL_Premium_Expected Float,
 BEL_Commission_Expected Float,
 BEL_Interest_Accrete Float,
 BEL_Claim_Expected Float,
 BEL_Expense_Expected Float,
 BEL_Cost_Expected Float,
 BEL_Others_Expected Float,
 BEL_Refund_Expected Float,
 BEL_Ending_Before_Change Float,
 BEL_Ending_After_Change_NonDiscRate Float,
 BEL_Ending_After_Change_DiscRate Float,
 BEL_GainLoss_NonDiscRate Float,
 BEL_GainLoss_DiscRate Float,
 BEL_NonPerformingRisk Float,
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
 Loss_Portion_from_Refund_Release Float,
 Loss_Portion_from_RA_Release Float,
 Loss_Portion_from_Interest_Accrete Float,
 Loss_Portion_from_GainLoss_DiscRate Float,
 Loss_GainLoss_NonDiscRate Float,
 Loss_End Float
)

Declare @Method as varchar(1);
Declare @OneRous as Bit;

Select @Method=I.Method, @OneRous=Case WHen @GroupType='I' Then I.OneRous else cast(0 as Bit) end from IFRS_Initial I Where DataID=@DataID

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
When @YearN=1 then I2_BEL.BEL_Cost_Expected_1
When @YearN=2 then I2_BEL.BEL_Cost_Expected_2
When @YearN=3 then I2_BEL.BEL_Cost_Expected_3
When @YearN=4 then I2_BEL.BEL_Cost_Expected_4
When @YearN=5 then I2_BEL.BEL_Cost_Expected_5
When @YearN=6 then I2_BEL.BEL_Cost_Expected_6
When @YearN=7 then I2_BEL.BEL_Cost_Expected_7
When @YearN=8 then I2_BEL.BEL_Cost_Expected_8
When @YearN=9 then I2_BEL.BEL_Cost_Expected_9
When @YearN=10 then I2_BEL.BEL_Cost_Expected_10
When @YearN=11 then I2_BEL.BEL_Cost_Expected_11
When @YearN=12 then I2_BEL.BEL_Cost_Expected_12
When @YearN=13 then I2_BEL.BEL_Cost_Expected_13
When @YearN=14 then I2_BEL.BEL_Cost_Expected_14
When @YearN=15 then I2_BEL.BEL_Cost_Expected_15
When @YearN=16 then I2_BEL.BEL_Cost_Expected_16
When @YearN=17 then I2_BEL.BEL_Cost_Expected_17
When @YearN=18 then I2_BEL.BEL_Cost_Expected_18
When @YearN=19 then I2_BEL.BEL_Cost_Expected_19
When @YearN=20 then I2_BEL.BEL_Cost_Expected_20
When @YearN=21 then I2_BEL.BEL_Cost_Expected_21
When @YearN=22 then I2_BEL.BEL_Cost_Expected_22
When @YearN=23 then I2_BEL.BEL_Cost_Expected_23
When @YearN=24 then I2_BEL.BEL_Cost_Expected_24
When @YearN=25 then I2_BEL.BEL_Cost_Expected_25
When @YearN=26 then I2_BEL.BEL_Cost_Expected_26
When @YearN=27 then I2_BEL.BEL_Cost_Expected_27
When @YearN=28 then I2_BEL.BEL_Cost_Expected_28
When @YearN=29 then I2_BEL.BEL_Cost_Expected_29
When @YearN=30 then I2_BEL.BEL_Cost_Expected_30
end) as BEL_Cost_Expected,
Sum(Case 
When @YearN=1 then I2_BEL.BEL_Others_Expected_1
When @YearN=2 then I2_BEL.BEL_Others_Expected_2
When @YearN=3 then I2_BEL.BEL_Others_Expected_3
When @YearN=4 then I2_BEL.BEL_Others_Expected_4
When @YearN=5 then I2_BEL.BEL_Others_Expected_5
When @YearN=6 then I2_BEL.BEL_Others_Expected_6
When @YearN=7 then I2_BEL.BEL_Others_Expected_7
When @YearN=8 then I2_BEL.BEL_Others_Expected_8
When @YearN=9 then I2_BEL.BEL_Others_Expected_9
When @YearN=10 then I2_BEL.BEL_Others_Expected_10
When @YearN=11 then I2_BEL.BEL_Others_Expected_11
When @YearN=12 then I2_BEL.BEL_Others_Expected_12
When @YearN=13 then I2_BEL.BEL_Others_Expected_13
When @YearN=14 then I2_BEL.BEL_Others_Expected_14
When @YearN=15 then I2_BEL.BEL_Others_Expected_15
When @YearN=16 then I2_BEL.BEL_Others_Expected_16
When @YearN=17 then I2_BEL.BEL_Others_Expected_17
When @YearN=18 then I2_BEL.BEL_Others_Expected_18
When @YearN=19 then I2_BEL.BEL_Others_Expected_19
When @YearN=20 then I2_BEL.BEL_Others_Expected_20
When @YearN=21 then I2_BEL.BEL_Others_Expected_21
When @YearN=22 then I2_BEL.BEL_Others_Expected_22
When @YearN=23 then I2_BEL.BEL_Others_Expected_23
When @YearN=24 then I2_BEL.BEL_Others_Expected_24
When @YearN=25 then I2_BEL.BEL_Others_Expected_25
When @YearN=26 then I2_BEL.BEL_Others_Expected_26
When @YearN=27 then I2_BEL.BEL_Others_Expected_27
When @YearN=28 then I2_BEL.BEL_Others_Expected_28
When @YearN=29 then I2_BEL.BEL_Others_Expected_29
When @YearN=30 then I2_BEL.BEL_Others_Expected_30
end) as BEL_Others_Expected,
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
When @YearN=1 then I2_BEL.BEL_NonPerformingRisk_1
When @YearN=2 then I2_BEL.BEL_NonPerformingRisk_2
When @YearN=3 then I2_BEL.BEL_NonPerformingRisk_3
When @YearN=4 then I2_BEL.BEL_NonPerformingRisk_4
When @YearN=5 then I2_BEL.BEL_NonPerformingRisk_5
When @YearN=6 then I2_BEL.BEL_NonPerformingRisk_6
When @YearN=7 then I2_BEL.BEL_NonPerformingRisk_7
When @YearN=8 then I2_BEL.BEL_NonPerformingRisk_8
When @YearN=9 then I2_BEL.BEL_NonPerformingRisk_9
When @YearN=10 then I2_BEL.BEL_NonPerformingRisk_10
When @YearN=11 then I2_BEL.BEL_NonPerformingRisk_11
When @YearN=12 then I2_BEL.BEL_NonPerformingRisk_12
When @YearN=13 then I2_BEL.BEL_NonPerformingRisk_13
When @YearN=14 then I2_BEL.BEL_NonPerformingRisk_14
When @YearN=15 then I2_BEL.BEL_NonPerformingRisk_15
When @YearN=16 then I2_BEL.BEL_NonPerformingRisk_16
When @YearN=17 then I2_BEL.BEL_NonPerformingRisk_17
When @YearN=18 then I2_BEL.BEL_NonPerformingRisk_18
When @YearN=19 then I2_BEL.BEL_NonPerformingRisk_19
When @YearN=20 then I2_BEL.BEL_NonPerformingRisk_20
When @YearN=21 then I2_BEL.BEL_NonPerformingRisk_21
When @YearN=22 then I2_BEL.BEL_NonPerformingRisk_22
When @YearN=23 then I2_BEL.BEL_NonPerformingRisk_23
When @YearN=24 then I2_BEL.BEL_NonPerformingRisk_24
When @YearN=25 then I2_BEL.BEL_NonPerformingRisk_25
When @YearN=26 then I2_BEL.BEL_NonPerformingRisk_26
When @YearN=27 then I2_BEL.BEL_NonPerformingRisk_27
When @YearN=28 then I2_BEL.BEL_NonPerformingRisk_28
When @YearN=29 then I2_BEL.BEL_NonPerformingRisk_29
When @YearN=30 then I2_BEL.BEL_NonPerformingRisk_30
end) as BEL_NonPerformingRisk,
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
When @YearN=1 then I2_PAA.PAA_Start_1
When @YearN=2 then I2_PAA.PAA_Start_2
When @YearN=3 then I2_PAA.PAA_Start_3
When @YearN=4 then I2_PAA.PAA_Start_4
When @YearN=5 then I2_PAA.PAA_Start_5
When @YearN=6 then I2_PAA.PAA_Start_6
When @YearN=7 then I2_PAA.PAA_Start_7
When @YearN=8 then I2_PAA.PAA_Start_8
When @YearN=9 then I2_PAA.PAA_Start_9
When @YearN=10 then I2_PAA.PAA_Start_10
When @YearN=11 then I2_PAA.PAA_Start_11
When @YearN=12 then I2_PAA.PAA_Start_12
When @YearN=13 then I2_PAA.PAA_Start_13
When @YearN=14 then I2_PAA.PAA_Start_14
When @YearN=15 then I2_PAA.PAA_Start_15
When @YearN=16 then I2_PAA.PAA_Start_16
When @YearN=17 then I2_PAA.PAA_Start_17
When @YearN=18 then I2_PAA.PAA_Start_18
When @YearN=19 then I2_PAA.PAA_Start_19
When @YearN=20 then I2_PAA.PAA_Start_20
When @YearN=21 then I2_PAA.PAA_Start_21
When @YearN=22 then I2_PAA.PAA_Start_22
When @YearN=23 then I2_PAA.PAA_Start_23
When @YearN=24 then I2_PAA.PAA_Start_24
When @YearN=25 then I2_PAA.PAA_Start_25
When @YearN=26 then I2_PAA.PAA_Start_26
When @YearN=27 then I2_PAA.PAA_Start_27
When @YearN=28 then I2_PAA.PAA_Start_28
When @YearN=29 then I2_PAA.PAA_Start_29
When @YearN=30 then I2_PAA.PAA_Start_30
end) as PAA_Start,
Sum(Case 
When @YearN=1 then I2_PAA.PAA_Interest_Accrete_1
When @YearN=2 then I2_PAA.PAA_Interest_Accrete_2
When @YearN=3 then I2_PAA.PAA_Interest_Accrete_3
When @YearN=4 then I2_PAA.PAA_Interest_Accrete_4
When @YearN=5 then I2_PAA.PAA_Interest_Accrete_5
When @YearN=6 then I2_PAA.PAA_Interest_Accrete_6
When @YearN=7 then I2_PAA.PAA_Interest_Accrete_7
When @YearN=8 then I2_PAA.PAA_Interest_Accrete_8
When @YearN=9 then I2_PAA.PAA_Interest_Accrete_9
When @YearN=10 then I2_PAA.PAA_Interest_Accrete_10
When @YearN=11 then I2_PAA.PAA_Interest_Accrete_11
When @YearN=12 then I2_PAA.PAA_Interest_Accrete_12
When @YearN=13 then I2_PAA.PAA_Interest_Accrete_13
When @YearN=14 then I2_PAA.PAA_Interest_Accrete_14
When @YearN=15 then I2_PAA.PAA_Interest_Accrete_15
When @YearN=16 then I2_PAA.PAA_Interest_Accrete_16
When @YearN=17 then I2_PAA.PAA_Interest_Accrete_17
When @YearN=18 then I2_PAA.PAA_Interest_Accrete_18
When @YearN=19 then I2_PAA.PAA_Interest_Accrete_19
When @YearN=20 then I2_PAA.PAA_Interest_Accrete_20
When @YearN=21 then I2_PAA.PAA_Interest_Accrete_21
When @YearN=22 then I2_PAA.PAA_Interest_Accrete_22
When @YearN=23 then I2_PAA.PAA_Interest_Accrete_23
When @YearN=24 then I2_PAA.PAA_Interest_Accrete_24
When @YearN=25 then I2_PAA.PAA_Interest_Accrete_25
When @YearN=26 then I2_PAA.PAA_Interest_Accrete_26
When @YearN=27 then I2_PAA.PAA_Interest_Accrete_27
When @YearN=28 then I2_PAA.PAA_Interest_Accrete_28
When @YearN=29 then I2_PAA.PAA_Interest_Accrete_29
When @YearN=30 then I2_PAA.PAA_Interest_Accrete_30
end) as PAA_Interest_Accrete,
Sum(Case 
When @YearN=1 then I2_PAA.PAA_Amortization_1
When @YearN=2 then I2_PAA.PAA_Amortization_2
When @YearN=3 then I2_PAA.PAA_Amortization_3
When @YearN=4 then I2_PAA.PAA_Amortization_4
When @YearN=5 then I2_PAA.PAA_Amortization_5
When @YearN=6 then I2_PAA.PAA_Amortization_6
When @YearN=7 then I2_PAA.PAA_Amortization_7
When @YearN=8 then I2_PAA.PAA_Amortization_8
When @YearN=9 then I2_PAA.PAA_Amortization_9
When @YearN=10 then I2_PAA.PAA_Amortization_10
When @YearN=11 then I2_PAA.PAA_Amortization_11
When @YearN=12 then I2_PAA.PAA_Amortization_12
When @YearN=13 then I2_PAA.PAA_Amortization_13
When @YearN=14 then I2_PAA.PAA_Amortization_14
When @YearN=15 then I2_PAA.PAA_Amortization_15
When @YearN=16 then I2_PAA.PAA_Amortization_16
When @YearN=17 then I2_PAA.PAA_Amortization_17
When @YearN=18 then I2_PAA.PAA_Amortization_18
When @YearN=19 then I2_PAA.PAA_Amortization_19
When @YearN=20 then I2_PAA.PAA_Amortization_20
When @YearN=21 then I2_PAA.PAA_Amortization_21
When @YearN=22 then I2_PAA.PAA_Amortization_22
When @YearN=23 then I2_PAA.PAA_Amortization_23
When @YearN=24 then I2_PAA.PAA_Amortization_24
When @YearN=25 then I2_PAA.PAA_Amortization_25
When @YearN=26 then I2_PAA.PAA_Amortization_26
When @YearN=27 then I2_PAA.PAA_Amortization_27
When @YearN=28 then I2_PAA.PAA_Amortization_28
When @YearN=29 then I2_PAA.PAA_Amortization_29
When @YearN=30 then I2_PAA.PAA_Amortization_30
end) as PAA_Amortization,
Sum(Case 
When @YearN=1 then I2_PAA.PAA_End_1
When @YearN=2 then I2_PAA.PAA_End_2
When @YearN=3 then I2_PAA.PAA_End_3
When @YearN=4 then I2_PAA.PAA_End_4
When @YearN=5 then I2_PAA.PAA_End_5
When @YearN=6 then I2_PAA.PAA_End_6
When @YearN=7 then I2_PAA.PAA_End_7
When @YearN=8 then I2_PAA.PAA_End_8
When @YearN=9 then I2_PAA.PAA_End_9
When @YearN=10 then I2_PAA.PAA_End_10
When @YearN=11 then I2_PAA.PAA_End_11
When @YearN=12 then I2_PAA.PAA_End_12
When @YearN=13 then I2_PAA.PAA_End_13
When @YearN=14 then I2_PAA.PAA_End_14
When @YearN=15 then I2_PAA.PAA_End_15
When @YearN=16 then I2_PAA.PAA_End_16
When @YearN=17 then I2_PAA.PAA_End_17
When @YearN=18 then I2_PAA.PAA_End_18
When @YearN=19 then I2_PAA.PAA_End_19
When @YearN=20 then I2_PAA.PAA_End_20
When @YearN=21 then I2_PAA.PAA_End_21
When @YearN=22 then I2_PAA.PAA_End_22
When @YearN=23 then I2_PAA.PAA_End_23
When @YearN=24 then I2_PAA.PAA_End_24
When @YearN=25 then I2_PAA.PAA_End_25
When @YearN=26 then I2_PAA.PAA_End_26
When @YearN=27 then I2_PAA.PAA_End_27
When @YearN=28 then I2_PAA.PAA_End_28
When @YearN=29 then I2_PAA.PAA_End_29
When @YearN=30 then I2_PAA.PAA_End_30
end) as PAA_End,
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
When @YearN=1 then I2_LOSS.Loss_Portion_from_Cost_Release_1
When @YearN=2 then I2_LOSS.Loss_Portion_from_Cost_Release_2
When @YearN=3 then I2_LOSS.Loss_Portion_from_Cost_Release_3
When @YearN=4 then I2_LOSS.Loss_Portion_from_Cost_Release_4
When @YearN=5 then I2_LOSS.Loss_Portion_from_Cost_Release_5
When @YearN=6 then I2_LOSS.Loss_Portion_from_Cost_Release_6
When @YearN=7 then I2_LOSS.Loss_Portion_from_Cost_Release_7
When @YearN=8 then I2_LOSS.Loss_Portion_from_Cost_Release_8
When @YearN=9 then I2_LOSS.Loss_Portion_from_Cost_Release_9
When @YearN=10 then I2_LOSS.Loss_Portion_from_Cost_Release_10
When @YearN=11 then I2_LOSS.Loss_Portion_from_Cost_Release_11
When @YearN=12 then I2_LOSS.Loss_Portion_from_Cost_Release_12
When @YearN=13 then I2_LOSS.Loss_Portion_from_Cost_Release_13
When @YearN=14 then I2_LOSS.Loss_Portion_from_Cost_Release_14
When @YearN=15 then I2_LOSS.Loss_Portion_from_Cost_Release_15
When @YearN=16 then I2_LOSS.Loss_Portion_from_Cost_Release_16
When @YearN=17 then I2_LOSS.Loss_Portion_from_Cost_Release_17
When @YearN=18 then I2_LOSS.Loss_Portion_from_Cost_Release_18
When @YearN=19 then I2_LOSS.Loss_Portion_from_Cost_Release_19
When @YearN=20 then I2_LOSS.Loss_Portion_from_Cost_Release_20
When @YearN=21 then I2_LOSS.Loss_Portion_from_Cost_Release_21
When @YearN=22 then I2_LOSS.Loss_Portion_from_Cost_Release_22
When @YearN=23 then I2_LOSS.Loss_Portion_from_Cost_Release_23
When @YearN=24 then I2_LOSS.Loss_Portion_from_Cost_Release_24
When @YearN=25 then I2_LOSS.Loss_Portion_from_Cost_Release_25
When @YearN=26 then I2_LOSS.Loss_Portion_from_Cost_Release_26
When @YearN=27 then I2_LOSS.Loss_Portion_from_Cost_Release_27
When @YearN=28 then I2_LOSS.Loss_Portion_from_Cost_Release_28
When @YearN=29 then I2_LOSS.Loss_Portion_from_Cost_Release_29
When @YearN=30 then I2_LOSS.Loss_Portion_from_Cost_Release_30
end) as Loss_Portion_from_Cost_Release,
Sum(Case 
When @YearN=1 then I2_LOSS.Loss_Portion_from_Others_Release_1
When @YearN=2 then I2_LOSS.Loss_Portion_from_Others_Release_2
When @YearN=3 then I2_LOSS.Loss_Portion_from_Others_Release_3
When @YearN=4 then I2_LOSS.Loss_Portion_from_Others_Release_4
When @YearN=5 then I2_LOSS.Loss_Portion_from_Others_Release_5
When @YearN=6 then I2_LOSS.Loss_Portion_from_Others_Release_6
When @YearN=7 then I2_LOSS.Loss_Portion_from_Others_Release_7
When @YearN=8 then I2_LOSS.Loss_Portion_from_Others_Release_8
When @YearN=9 then I2_LOSS.Loss_Portion_from_Others_Release_9
When @YearN=10 then I2_LOSS.Loss_Portion_from_Others_Release_10
When @YearN=11 then I2_LOSS.Loss_Portion_from_Others_Release_11
When @YearN=12 then I2_LOSS.Loss_Portion_from_Others_Release_12
When @YearN=13 then I2_LOSS.Loss_Portion_from_Others_Release_13
When @YearN=14 then I2_LOSS.Loss_Portion_from_Others_Release_14
When @YearN=15 then I2_LOSS.Loss_Portion_from_Others_Release_15
When @YearN=16 then I2_LOSS.Loss_Portion_from_Others_Release_16
When @YearN=17 then I2_LOSS.Loss_Portion_from_Others_Release_17
When @YearN=18 then I2_LOSS.Loss_Portion_from_Others_Release_18
When @YearN=19 then I2_LOSS.Loss_Portion_from_Others_Release_19
When @YearN=20 then I2_LOSS.Loss_Portion_from_Others_Release_20
When @YearN=21 then I2_LOSS.Loss_Portion_from_Others_Release_21
When @YearN=22 then I2_LOSS.Loss_Portion_from_Others_Release_22
When @YearN=23 then I2_LOSS.Loss_Portion_from_Others_Release_23
When @YearN=24 then I2_LOSS.Loss_Portion_from_Others_Release_24
When @YearN=25 then I2_LOSS.Loss_Portion_from_Others_Release_25
When @YearN=26 then I2_LOSS.Loss_Portion_from_Others_Release_26
When @YearN=27 then I2_LOSS.Loss_Portion_from_Others_Release_27
When @YearN=28 then I2_LOSS.Loss_Portion_from_Others_Release_28
When @YearN=29 then I2_LOSS.Loss_Portion_from_Others_Release_29
When @YearN=30 then I2_LOSS.Loss_Portion_from_Others_Release_30
end) as Loss_Portion_from_Others_Release,
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
end) as Loss_End
from IFRS_Initial I1
Inner join IFRS_Initial_Detail I2 on (I2.DataID=I1.DataID and I2.GroupType=@GroupType)
Inner join IFRS_Initial_Detail_BEL I2_BEL on (I2_BEL.DataID=I2.DataID and I2_BEL.GroupType=I2.GroupType)
Inner join IFRS_Initial_Detail_RA I2_RA on (I2_RA.DataID=I2.DataID and I2_RA.GroupType=I2.GroupType)
Inner join IFRS_Initial_Detail_CSM I2_CSM on (I2_CSM.DataID=I2.DataID and I2_CSM.GroupType=I2.GroupType)
LEFT join IFRS_Initial_Detail_PAA I2_PAA on (I2_PAA.DataID=I2.DataID and I2_CSM.GroupType=I2.GroupType)
Inner join IFRS_Initial_Detail_LOSS I2_LOSS on (I2_LOSS.DataID=I2.DataID and I2_LOSS.GroupType=I2.GroupType)
Where I1.DataID=@DataID 

Select 'BEL_Beginning'as Description,  BEL_Beginning as Nominal from @IFRS Union All
Select 'BEL_Premium_Expected'as Description,  BEL_Premium_Expected as Nominal from @IFRS Union All
Select 'BEL_Commission_Expected'as Description,  BEL_Commission_Expected as Nominal from @IFRS Union All
Select 'BEL_Interest_Accrete'as Description,  BEL_Interest_Accrete as Nominal from @IFRS Union All
Select 'BEL_Claim_Expected'as Description,  BEL_Claim_Expected as Nominal from @IFRS Union All
Select 'BEL_Expense_Expected'as Description,  BEL_Expense_Expected as Nominal from @IFRS Union All
Select 'BEL_Cost_Expected'as Description,  BEL_Cost_Expected as Nominal from @IFRS Where @GroupType<>'R' Union All
Select 'BEL_Others_Expected'as Description,  BEL_Others_Expected as Nominal from @IFRS Where @GroupType<>'R' Union All
Select 'BEL_Refund_Expected'as Description,  BEL_Refund_Expected as Nominal from @IFRS Union All
Select 'BEL_Ending_Before_Change'as Description,  BEL_Ending_Before_Change as Nominal from @IFRS Union All
Select 'BEL_GainLoss_NonDiscRate'as Description,  BEL_GainLoss_NonDiscRate as Nominal from @IFRS Union All
Select 'BEL_Ending_After_Change_NonDiscRate'as Description,  BEL_Ending_After_Change_NonDiscRate as Nominal from @IFRS Union All
Select 'BEL_GainLoss_DiscRate'as Description,  BEL_GainLoss_DiscRate as Nominal from @IFRS Union All
Select 'BEL_NonPerformingRisk'as Description, BEL_NonPerformingRisk as Nominal from @IFRS Where @GroupType='R' Union All
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
Select 'CSM_End'as Description,  CSM_End as Nominal from @IFRS Union All

Select 'PAA_Start'as Description,  PAA_Start as Nominal from @IFRS Where @Method='P' Union All
Select 'PAA_Adjustment_Financial'as Description,  PAA_Interest_Accrete as Nominal from @IFRS Where @Method='P' Union All
Select 'PAA_Amortization'as Description,  PAA_Amortization as Nominal from @IFRS Where @Method='P' Union All

Select 'Loss_Start'as Description,  Loss_Start as Nominal from @IFRS Where @GroupType='I' Union All
Select 'Loss_Portion_from_Claim_Release'as Description,  Loss_Portion_from_Claim_Release as Nominal from @IFRS Where @GroupType='I' Union All
Select 'Loss_Portion_from_Expense_Release'as Description,  Loss_Portion_from_Expense_Release as Nominal from @IFRS Where @GroupType='I' Union All
Select 'Loss_Portion_from_Cost_Release'as Description,  Loss_Portion_from_Cost_Release as Nominal from @IFRS Where @GroupType='I' Union All
Select 'Loss_Portion_from_Others_Release'as Description,  Loss_Portion_from_Others_Release as Nominal from @IFRS Where @GroupType='I' Union All
Select 'Loss_Portion_from_Refund_Release'as Description,  Loss_Portion_from_Refund_Release as Nominal from @IFRS Where @GroupType='I' Union All
Select 'Loss_Portion_from_RA_Release'as Description,  Loss_Portion_from_RA_Release as Nominal from @IFRS Where @GroupType='I' Union All
Select 'Loss_Portion_from_Interest_Accrete'as Description,  Loss_Portion_from_Interest_Accrete as Nominal from @IFRS Where @GroupType='I' Union All
Select 'Loss_Portion_from_GainLoss_DiscRate'as Description,  Loss_Portion_from_GainLoss_DiscRate as Nominal from @IFRS Where @GroupType='I' Union All
Select 'Loss_GainLoss_NonDiscRate'as Description,  Loss_GainLoss_NonDiscRate as Nominal from @IFRS Where @GroupType='I' Union All
Select 'Loss_End'as Description,  Loss_End as Nominal from @IFRS Where @GroupType='I'

GO


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
 BEL_Expense_Expected Float,
 BEL_Cost_Expected Float,
 BEL_Others_Expected Float,
 BEL_Refund_Expected Float,
 BEL_Ending_Before_Change Float,
 BEL_Ending_After_Change_NonDiscRate Float,
 BEL_Ending_After_Change_DiscRate Float,
 BEL_GainLoss_NonDiscRate Float,
 BEL_GainLoss_DiscRate Float,
 BEL_NonPerformingRisk Float,
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
Declare @BEL_NonPerformingRisk as Float
Declare @ACQ_Cost as Float

if @Cumulative=1 
Begin
	Select @PProcessDate='01/01/1901'
	Select @BEL_Ending_After_Change_NonDiscRate=0
	Select @BEL_GainLoss_DiscRate=0
	Select @BEL_NonPerformingRisk=0
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
	 @BEL_Ending_After_Change_NonDiscRate=sum(BEL_Initial+BEL_Premium_Expected+BEL_Commission_Expected+BEL_Interest_Accrete+BEL_Claim_Expected+BEL_Expense_Expected+BEL_Cost_Expected+BEL_Others_Expected+BEL_Refund_Expected+BEL_GainLoss_NonDiscRate),
	 @BEL_GainLoss_DiscRate=sum(BEL_GainLoss_DiscRate),
	 @BEL_NonPerformingRisk=sum(BEL_NonPerformingRisk),
	 @RA_Ending_After_Change_NonDiscRate=sum(RA_Initial+RA_Interest_Accrete+RA_Release+RA_GainLoss_NonDiscRate),
	 @RA_GainLoss_DiscRate=sum(RA_GainLoss_DiscRate),
	 @CSM_End=sum(CSM_Initial+CSM_Interest_Accrete+CSM_Amortization+CSM_GainLoss_NonDiscRate),
	 @PAA_End=sum(PAA_Premium_Expected+PAA_Commission_Expected+PAA_Amortization),
	 @Loss_End=sum(Loss_Initial+Loss_Portion_from_Claim_Release+Loss_Portion_from_Expense_Release+Loss_Portion_from_Cost_Release+Loss_Portion_from_Others_Release+Loss_Portion_from_Refund_Release+Loss_Portion_from_RA_Release+Loss_Portion_from_Interest_Accrete+Loss_Portion_from_GainLoss_DiscRate+Loss_GainLoss_NonDiscRate),
	 @ACQ_Cost=sum(ACQ_Cost+ACQ_Amortization)
	 from IFRS_Movement I
	 Where I.GroupID=@GroupID and I.GroupType=@GroupType and I.ProcessDate<=@PProcessDate 
	 
	 if @BEL_Ending_After_Change_NonDiscRate is null
		Select @BEL_Ending_After_Change_NonDiscRate=0
	 if @BEL_GainLoss_DiscRate is null
		Select @BEL_GainLoss_DiscRate=0
	 if @BEL_NonPerformingRisk is null
		Select @BEL_NonPerformingRisk=0
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
 BEL_Expense_Expected=sum(BEL_Expense_Expected),
 BEL_Cost_Expected=sum(BEL_Cost_Expected),
 BEL_Others_Expected=sum(BEL_Others_Expected),
 BEL_Refund_Expected=sum(BEL_Refund_Expected),

 BEL_Ending_Before_Change=@BEL_Ending_After_Change_NonDiscRate+sum(BEL_Initial+BEL_Premium_Expected+BEL_Commission_Expected+BEL_Interest_Accrete+BEL_Claim_Expected+BEL_Expense_Expected+BEL_Cost_Expected+BEL_Others_Expected+BEL_Refund_Expected),

 BEL_Ending_After_Change_NonDiscRate=@BEL_Ending_After_Change_NonDiscRate+sum(BEL_Initial+BEL_Premium_Expected+BEL_Commission_Expected+BEL_Interest_Accrete+BEL_Claim_Expected+BEL_Expense_Expected+BEL_Cost_Expected+BEL_Others_Expected+BEL_Refund_Expected+BEL_GainLoss_NonDiscRate),
 BEL_Ending_After_Change_DiscRate=@BEL_Ending_After_Change_NonDiscRate+@BEL_GainLoss_DiscRate+sum(BEL_Initial+BEL_Premium_Expected+BEL_Commission_Expected+BEL_Interest_Accrete+BEL_Claim_Expected+BEL_Expense_Expected+BEL_Cost_Expected+BEL_Others_Expected+BEL_Refund_Expected+BEL_GainLoss_NonDiscRate+BEL_GainLoss_DiscRate),

 BEL_GainLoss_NonDiscRate=sum(BEL_GainLoss_NonDiscRate),
 BEL_GainLoss_DiscRate=@BEL_GainLoss_DiscRate+sum(BEL_GainLoss_DiscRate),
 BEL_NonPerformingRisk=@BEL_NonPerformingRisk+sum(BEL_NonPerformingRisk),

 RA_Beginning=@RA_Ending_After_Change_NonDiscRate+sum(+RA_Initial),
 RA_Interest_Accrete=sum(RA_Interest_Accrete),
 RA_Release=sum(RA_Release),

 RA_Ending_Before_Change=@RA_Ending_After_Change_NonDiscRate+sum(RA_Initial+RA_Interest_Accrete+RA_Release),

 RA_Ending_After_Change_NonDiscRate=@RA_Ending_After_Change_NonDiscRate+sum(RA_Initial+RA_Interest_Accrete+RA_Release+RA_GainLoss_NonDiscRate),
 RA_Ending_After_Change_DiscRate=@RA_Ending_After_Change_NonDiscRate+@RA_GainLoss_DiscRate+sum(RA_Initial+RA_Interest_Accrete+RA_Release+RA_GainLoss_NonDiscRate+RA_GainLoss_DiscRate),

 RA_GainLoss_NonDiscRate=sum(RA_GainLoss_NonDiscRate),
 RA_GainLoss_DiscRate=@RA_GainLoss_DiscRate+sum(RA_GainLoss_DiscRate),

 CSM_Start=@CSM_End+sum(case When Description='' Then CSM_Initial Else 0 End),
 CSM_Interest_Accrete=sum(CSM_Interest_Accrete),
 CSM_Amortization=sum(CSM_Amortization),
 CSM_GainLoss_NonDiscRate=sum(CSM_GainLoss_NonDiscRate),
 CSM_Adjustment=sum(case When Description<>'' Then CSM_Initial Else 0 End),
 CSM_End=@CSM_End+sum(CSM_Initial+CSM_Interest_Accrete+CSM_Amortization+CSM_GainLoss_NonDiscRate),

 PAA_Start=@PAA_End+sum(PAA_Premium_Expected+PAA_Commission_Expected),
 PAA_Interest_Accrete=sum(PAA_Interest_Accrete),
 PAA_Amortization=sum(PAA_Amortization),
 PAA_End=@PAA_End+sum(PAA_Premium_Expected+PAA_Commission_Expected+PAA_Interest_Accrete+(PAA_Amortization-PAA_Interest_Accrete)),

 Loss_Start=@Loss_End+sum(case When Description='' Then LOSS_Initial Else 0 End),
 Loss_Portion_from_Claim_Release=sum(Loss_Portion_from_Claim_Release),
 Loss_Portion_from_Expense_Release=sum(Loss_Portion_from_Expense_Release),
 Loss_Portion_from_Cost_Release=sum(Loss_Portion_from_Cost_Release),
 Loss_Portion_from_Others_Release=sum(Loss_Portion_from_Others_Release),
 Loss_Portion_from_Refund_Release=sum(Loss_Portion_from_Refund_Release),
 Loss_Portion_from_RA_Release=sum(Loss_Portion_from_RA_Release),
 Loss_Portion_from_Interest_Accrete=sum(Loss_Portion_from_Interest_Accrete),
 Loss_Portion_from_GainLoss_DiscRate=sum(Loss_Portion_from_GainLoss_DiscRate),
 Loss_GainLoss_NonDiscRate=sum(Loss_GainLoss_NonDiscRate),
 LOSS_Adjustment=sum(case When Description<>'' Then LOSS_Initial Else 0 End),
 Loss_End=@Loss_End+sum(Loss_Initial+Loss_Portion_from_Claim_Release+Loss_Portion_from_Expense_Release+Loss_Portion_from_Cost_Release+Loss_Portion_from_Others_Release+Loss_Portion_from_Refund_Release+Loss_Portion_from_RA_Release+Loss_Portion_from_Interest_Accrete+Loss_Portion_from_GainLoss_DiscRate+Loss_GainLoss_NonDiscRate),
 ACQ_Amortization=sum(ACQ_Amortization),
 ACQ_Cost=@ACQ_Cost+sum(ACQ_Cost)
from IFRS_Movement I
Where I.GroupID=@GroupID and I.GroupType=@GroupType and I.ProcessDate<=@ProcessDate and I.ProcessDate>@PProcessDate



Select 'BEL_Beginning'as Description,  BEL_Beginning as Nominal from @IFRS Union All
Select 'BEL_Premium_Expected'as Description,  BEL_Premium_Expected as Nominal from @IFRS Union All
Select 'BEL_Commission_Expected'as Description,  BEL_Commission_Expected as Nominal from @IFRS Union All
Select 'BEL_Interest_Accrete'as Description,  BEL_Interest_Accrete as Nominal from @IFRS Union All
Select 'BEL_Claim_Expected'as Description,  BEL_Claim_Expected as Nominal from @IFRS Union All
Select 'BEL_Expense_Expected'as Description,  BEL_Expense_Expected as Nominal from @IFRS Union All
Select 'BEL_Cost_Expected'as Description,  BEL_Cost_Expected as Nominal from @IFRS Where @GroupType<>'R' Union All 
Select 'BEL_Others_Expected'as Description,  BEL_Others_Expected as Nominal from @IFRS Where @GroupType<>'R' Union All 
Select 'BEL_Refund_Expected'as Description,  BEL_Refund_Expected as Nominal from @IFRS Union All
Select 'BEL_Ending_Before_Change'as Description,  BEL_Ending_Before_Change as Nominal from @IFRS Union All
Select 'BEL_GainLoss_NonDiscRate'as Description,  BEL_GainLoss_NonDiscRate as Nominal from @IFRS Union All
Select 'BEL_Ending_After_Change_NonDiscRate'as Description,  BEL_Ending_After_Change_NonDiscRate as Nominal from @IFRS Union All
Select 'BEL_GainLoss_DiscRate'as Description,  BEL_GainLoss_DiscRate as Nominal from @IFRS Union All
Select 'BEL_NonPerformingRisk' as Description, BEL_NonPerformingRisk as Nominal from @IFRS Where @GroupType='R' Union All
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
Select 'PAA_Amount_Recognized_As_Revenue'as Description,  PAA_Amortization-PAA_Interest_Accrete as Nominal from @IFRS Where @Method='P' Union All
Select 'PAA_End' as Description, PAA_End as Nominal from @IFRS Where (@Method='P') Union All

Select 'Loss_Start'as Description,  Loss_Start as Nominal from @IFRS Where @GroupType='I' Union All
Select 'Loss_Portion_from_Claim_Release'as Description,  Loss_Portion_from_Claim_Release as Nominal from @IFRS Where @GroupType='I' Union All
Select 'Loss_Portion_from_Expense_Release'as Description,  Loss_Portion_from_Expense_Release as Nominal from @IFRS  Where @GroupType='I' Union All
Select 'Loss_Portion_from_Cost_Release'as Description,  Loss_Portion_from_Cost_Release as Nominal from @IFRS Where @GroupType='I' Union All
Select 'Loss_Portion_from_Others_Release'as Description,  Loss_Portion_from_Others_Release as Nominal from @IFRS Where @GroupType='I' Union All
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

GO
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
 BEL_Expense_Expected Float,
 BEL_Cost_Expected Float,
 BEL_Others_Expected Float,
 BEL_Refund_Expected Float,
 BEL_GainLoss_NonDiscRate Float,
 BEL_GainLoss_DiscRate Float,
 BEL_NonPerformingRisk Float,
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
 BEL_Expense_Expected=sum(BEL_Expense_Expected),
 BEL_Cost_Expected=sum(BEL_Cost_Expected),
 BEL_Others_Expected=sum(BEL_Others_Expected),
 BEL_Refund_Expected=sum(BEL_Refund_Expected),
 BEL_GainLoss_NonDiscRate=sum(BEL_GainLoss_NonDiscRate),
 BEL_GainLoss_DiscRate=sum(BEL_GainLoss_DiscRate),
 BEL_NonPerformingRisk=sum(BEL_NonPerformingRisk),

 RA_Initial=sum(RA_Initial),
 RA_Interest_Accrete=sum(RA_Interest_Accrete),
 RA_Release=sum(RA_Release), 
 RA_GainLoss_NonDiscRate=sum(RA_GainLoss_NonDiscRate),
 RA_GainLoss_DiscRate=sum(RA_GainLoss_DiscRate),

 CSM_Initial=sum(Case When I.Description='' Then CSM_Initial Else 0 end),
 CSM_Interest_Accrete=sum(CSM_Interest_Accrete),
 CSM_Amortization=sum(CSM_Amortization),
 CSM_GainLoss_NonDiscRate=sum(CSM_GainLoss_NonDiscRate),
 CSM_Adjustment=sum(Case When I.Description<>'' Then CSM_Initial Else 0 end),

 PAA_Premium_Expected=sum(PAA_Premium_Expected),
 PAA_Commission_Expected=sum(PAA_Commission_Expected),
 PAA_Interest_Accrete=sum(PAA_Interest_Accrete),
 PAA_Amortization=sum(PAA_Amortization),

 Loss_Initial=sum(Case When I.Description='' Then Loss_Initial Else 0 end),
 Loss_Portion_from_Claim_Release=sum(Loss_Portion_from_Claim_Release),
 Loss_Portion_from_Expense_Release=sum(Loss_Portion_from_Expense_Release),
 Loss_Portion_from_Cost_Release=sum(Loss_Portion_from_Cost_Release),
 Loss_Portion_from_Others_Release=sum(Loss_Portion_from_Others_Release),
 Loss_Portion_from_Refund_Release=sum(Loss_Portion_from_Refund_Release),
 Loss_Portion_from_RA_Release=sum(Loss_Portion_from_RA_Release),
 Loss_Portion_from_Interest_Accrete=sum(Loss_Portion_from_Interest_Accrete),
 Loss_Portion_from_GainLoss_DiscRate=sum(Loss_Portion_from_GainLoss_DiscRate),
 Loss_GainLoss_NonDiscRate=sum(Loss_GainLoss_NonDiscRate),
 LOSS_Adjustment=sum(Case When I.Description<>'' Then Loss_Initial Else 0 end),
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
Select VType, -6 as Hint, 'BEL_Expense_Expected'as Description,  BEL_Expense_Expected as Nominal from @IFRS Where @Method='B' Union All
Select VType, -17 as Hint, 'BEL_Cost_Expected'as Description,  BEL_Cost_Expected as Nominal from @IFRS Where @Method='B' and @GroupType<>'R' Union All
Select VType, -32 as Hint, 'BEL_Others_Expected'as Description,  BEL_Others_Expected as Nominal from @IFRS Where @Method='B' and @GroupType<>'R' Union All
Select VType, -28 as Hint, 'BEL_Refund_Expected'as Description,  BEL_Refund_Expected as Nominal from @IFRS Where @Method='B' Union All
Select VType, -7 as Hint, 'BEL_GainLoss_NonDiscRate'as Description,  BEL_GainLoss_NonDiscRate as Nominal from @IFRS Where @Method='B' Union All
Select VType, -8 as Hint, 'BEL_GainLoss_DiscRate'as Description,  BEL_GainLoss_DiscRate as Nominal from @IFRS Where @Method='B' Union All
Select VType, -30 as Hint, 'BEL_NonPerformingRisk'as Description,  BEL_NonPerformingRisk as Nominal from @IFRS Where @Method='B' and @GroupType='R' Union All
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
Select VType, -15 as Hint, 'PAA_Adjustment_Financial'as Description,  CSM_Interest_Accrete as Nominal from @IFRS Where @Method='P' Union All
Select VType, -16 as Hint, 'PAA_Amortization'as Description,  CSM_Amortization as Nominal from @IFRS Where @Method='P' Union All

Select VType, -19 as Hint, 'Loss_Initial'as Description,  Loss_Initial as Nominal from @IFRS Where (@Method='B' and @GroupType='I') and (Loss_Initial<>0) Union All
Select VType, -20 as Hint, 'Loss_Portion_from_Claim_Release'as Description,  Loss_Portion_from_Claim_Release as Nominal from @IFRS Where (@Method='B' and @GroupType='I') and (Loss_Portion_from_Claim_Release<>0) Union All
Select VType, -21 as Hint, 'Loss_Portion_from_Expense_Release'as Description,  Loss_Portion_from_Expense_Release as Nominal from @IFRS Where (@Method='B' and @GroupType='I') and (Loss_Portion_from_Expense_Release<>0) Union All
Select VType, -24 as Hint, 'Loss_Portion_from_Cost_Release'as Description,  Loss_Portion_from_Cost_Release as Nominal from @IFRS Where (@Method='B' and @GroupType='I') and (Loss_Portion_from_Cost_Release<>0) Union All
Select VType, -33 as Hint, 'Loss_Portion_from_Others_Release'as Description,  Loss_Portion_from_Others_Release as Nominal from @IFRS Where (@Method='B' and @GroupType='I') and (Loss_Portion_from_Others_Release<>0) Union All
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
RETURNS @IFRS TABLE (GroupID Int, Branch varchar(10), DocNo varchar(50), RefNo varchar(50), Date smalldatetime, Code varchar(10), Type varchar(10), Currency varchar(10), Subject varchar(10), Remarks varchar(255),
Amount_1 Float, Amount_2 Float, Amount_3 Float, Amount_4 Float,Amount_5 Float, Amount_6 Float, Amount_7 Float, Amount_8 Float, Amount_9 Float, Amount_10 Float, 
Amount_11 Float, Amount_12 Float, Amount_13 Float, Amount_14 Float, Amount_15 Float, Amount_16 Float, Amount_17 Float, Amount_18 Float, Amount_19 Float, Amount_20 Float, 
Amount_21 Float, Amount_22 Float, Amount_23 Float, Amount_24 Float, Amount_25 Float, Amount_26 Float, Amount_27 Float, Amount_28 Float, Amount_29 Float, Amount_30 Float, Amount_31 Float, Amount_32 Float, Amount_33 Float)
AS
BEGIN

Declare @IFRS_Data TABLE (GroupID Int, Branch varchar(10), DocNo varchar(50), RefNo varchar(50), Date smalldatetime, Code varchar(10), Type varchar(10), Currency varchar(10), Subject varchar(10), Remarks varchar(255),
Amount_1 Float, Amount_2 Float, Amount_3 Float, Amount_4 Float,Amount_5 Float, Amount_6 Float, Amount_7 Float, Amount_8 Float, Amount_9 Float, Amount_10 Float, 
Amount_11 Float, Amount_12 Float, Amount_13 Float, Amount_14 Float, Amount_15 Float, Amount_16 Float, Amount_17 Float, Amount_18 Float, Amount_19 Float, Amount_20 Float, 
Amount_21 Float, Amount_22 Float, Amount_23 Float, Amount_24 Float, Amount_25 Float, Amount_26 Float, Amount_27 Float, Amount_28 Float, Amount_29 Float, Amount_30 Float, Amount_31 Float, Amount_32 Float, Amount_33 Float)

Declare @IFRS_Data_Paid TABLE (GroupID Int, Branch varchar(10), DocNo varchar(50), RefNo varchar(50), Date smalldatetime, Code varchar(10), Type varchar(10), Currency varchar(10), Subject varchar(10), Remarks varchar(255),
Amount_1 Float, Amount_2 Float, Amount_3 Float, Amount_4 Float,Amount_5 Float, Amount_6 Float, Amount_7 Float, Amount_8 Float, Amount_9 Float, Amount_10 Float, 
Amount_11 Float, Amount_12 Float, Amount_13 Float, Amount_14 Float, Amount_15 Float, Amount_16 Float, Amount_17 Float, Amount_18 Float, Amount_19 Float, Amount_20 Float, 
Amount_21 Float, Amount_22 Float, Amount_23 Float, Amount_24 Float, Amount_25 Float, Amount_26 Float, Amount_27 Float, Amount_28 Float, Amount_29 Float, Amount_30 Float, Amount_31 Float, Amount_32 Float, Amount_33 Float)


insert into @IFRS_Data
Select I2.GroupID, I2.Branch, '' as DocNo, '' as RefNo, @P_Date as Date, I2.TOC as Code, 
Case 
When I1.GroupType='I' and I2.Method='B' then 'IFIB'
When I1.GroupType='R' and I2.Method='B' then 'IFRB'
When I1.GroupType='I' and I2.Method='P' then 'IFIP'
else 'IFRP'
end as Type, I2.Currency, 'JOURNAL' as Subject, MParam.Remarks as Remarks,

Amount_1 = sum(case When I2.Method='B' then I1.BEL_Initial else 0 end),
Amount_2 = sum(case When I2.Method='B' then I1.BEL_Premium_Expected else I1.PAA_Premium_Expected end),
Amount_3 = sum(case When I2.Method='B' then I1.BEL_Commission_Expected else I1.PAA_Commission_Expected end),
Amount_4 = sum(case When I2.Method='B' then I1.BEL_Interest_Accrete else 0 end),
Amount_5 = sum(case When I2.Method='B' then I1.BEL_Claim_Expected else 0 end),
Amount_6 = sum(case When I2.Method='B' then I1.BEL_Expense_Expected else 0 end),
Amount_7 = sum(case When I2.Method='B' then I1.BEL_GainLoss_NonDiscRate else 0 end),
Amount_8 = sum(case When I2.Method='B' then I1.BEL_GainLoss_DiscRate else 0 end),
Amount_9 = sum(case When I2.Method='B' then I1.RA_Initial else 0 end),
Amount_10 = sum(case When I2.Method='B' then I1.RA_Interest_Accrete else 0 end),
Amount_11 = sum(case When I2.Method='B' then I1.RA_Release else 0 end),
Amount_12 = sum(case When I2.Method='B' then I1.RA_GainLoss_NonDiscRate else 0 end),
Amount_13 = sum(case When I2.Method='B' then I1.RA_GainLoss_DiscRate else 0 end),
Amount_14 = sum(case When I2.Method='B' then I1.CSM_Initial else 0 end),
Amount_15 = sum(case When I2.Method='B' then I1.CSM_Interest_Accrete else I1.PAA_Interest_Accrete end),
Amount_16 = sum(case When I2.Method='B' then I1.CSM_Amortization else I1.PAA_Amortization end),
Amount_17 = sum(case When I2.Method='B' then I1.BEL_Cost_Expected else 0 end),
Amount_18 = sum(case When I2.Method='B' then I1.CSM_GainLoss_NonDiscRate else 0 end),
Amount_19 = sum(case When I2.Method='B' then I1.Loss_Initial else 0 end),
Amount_20 = sum(case When I2.Method='B' then I1.Loss_Portion_from_Claim_Release else 0 end),
Amount_21 = sum(case When I2.Method='B' then I1.Loss_Portion_from_Expense_Release else 0 end),
Amount_22 = sum(case When I2.Method='B' then I1.Loss_Portion_from_RA_Release else 0 end),
Amount_23 = sum(case When I2.Method='B' then I1.Loss_Portion_from_Interest_Accrete else 0 end),
Amount_24 = sum(case When I2.Method='B' then I1.Loss_Portion_from_Cost_Release else 0 end),
Amount_25 = sum(case When I2.Method='B' then I1.Loss_Portion_from_GainLoss_DiscRate else 0 end),
Amount_26 = sum(case When I2.Method='B' then I1.Loss_GainLoss_NonDiscRate else 0 end),
Amount_27 = sum(I1.ACQ_Amortization),
Amount_28 = sum(case When I2.Method='B' then I1.BEL_Refund_Expected else 0 end),
Amount_29 = sum(case When I2.Method='B' then I1.Loss_Portion_from_Refund_Release else 0 end),
Amount_30 = sum(case When I2.Method='B' then I1.BEL_NonPerformingRisk else 0 end),
Amount_31 = sum(I1.ACQ_Cost),
Amount_32 = sum(case When I2.Method='B' then I1.BEL_Others_Expected else 0 end),
Amount_33 = sum(case When I2.Method='B' then I1.Loss_Portion_from_Others_Release else 0 end)
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
Amount_29 = cast(0 as Float),
Amount_30 = cast(0 as Float),
Amount_31 = cast(0 as Float),
Amount_32 = cast(0 as Float),
Amount_33 = cast(0 as Float)
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
I1.Amount_29,
I1.Amount_30,
cast(0 as Float) as Amount_31,  --ACQ Cost in Base Currency
I1.Amount_32,
I1.Amount_33
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
cast(0 as Float) as Amount_29,
cast(0 as Float) as Amount_30,
sum(I1.Amount_31) as Amount_31, --ACQ Cost in Base Currency
cast(0 as Float) as Amount_32,
cast(0 as Float) as Amount_33
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
I1.Amount_29,
I1.Amount_30,
I1.Amount_31,
I1.Amount_32,
I1.Amount_33
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
cast(0 as Float) as Amount_29,
cast(0 as Float) as Amount_30,
cast(0 as Float) as Amount_31,
cast(0 as Float) as Amount_32,
cast(0 as Float) as Amount_33
from @IFRS_Data_Paid I1
Inner Join SysTab on (1=1)
Group By 
I1.GroupID, I1.Branch, I1.DocNo, I1.RefNo, I1.Date, I1.Code, I1.Type, SysTab.Currency, I1.Subject, I1.Remarks
Having sum(I1.Amount_7)<>0

RETURN
END




GO

DROP Procedure IFRS_Get_Assumption
GO
Create Procedure IFRS_Get_Assumption(@PDate as smalldatetime, @NumMonths as Integer, @AssumptionID as varchar(10), @TSI as Float, @Segment as varchar(10), @ISType as varchar(10), @TOC as varchar(10), @CGroup as varchar(10), @Currency as varchar(10), @GroupType as varchar(10))                  
as                  

Declare @NumYears as Integer

Select @NumYears=Case When (@NumMonths % 12)<>0 then @NumMonths/12+1 else @NumMonths/12 end

Select 
I2.AssumptionID,
I2.Method,
I2.ApplyFAForPAAF,
Case When @GroupType='R' and I2.ReinsuranceParamF=1 Then Claim_PAD_R Else Claim_PAD end as Claim_PAD,
Case When @GroupType='R' and I2.ReinsuranceParamF=1 Then Expense_PAD_R Else Expense_PAD end as Expense_PAD,
I2.Cost_PAD,

Case When @GroupType='R' and I2.ReinsuranceParamF=1 Then Weight_1_R Else Weight_1 end as Weight_1,
Case When @GroupType='R' and I2.ReinsuranceParamF=1 Then Claim_Expected_1_R Else Claim_Expected_1 end as Claim_Expected_1,
Case When @GroupType='R' and I2.ReinsuranceParamF=1 Then Expense_Expected_1_R Else Expense_Expected_1 end as Expense_Expected_1,
I2.Cost_Expected_1,
I2.Others_Expected_1,
I2.Cancel_Rate_1,

Case When @GroupType='R' and I2.ReinsuranceParamF=1 Then Weight_2_R Else Weight_2 end as Weight_2,
Case When @GroupType='R' and I2.ReinsuranceParamF=1 Then Claim_Expected_2_R Else Claim_Expected_2 end as Claim_Expected_2,
Case When @GroupType='R' and I2.ReinsuranceParamF=1 Then Expense_Expected_2_R Else Expense_Expected_2 end as Expense_Expected_2,
I2.Cost_Expected_2,
I2.Others_Expected_2,
I2.Cancel_Rate_2,

Case When @GroupType='R' and I2.ReinsuranceParamF=1 Then Weight_3_R Else Weight_3 end as Weight_3,
Case When @GroupType='R' and I2.ReinsuranceParamF=1 Then Claim_Expected_3_R Else Claim_Expected_3 end as Claim_Expected_3,
Case When @GroupType='R' and I2.ReinsuranceParamF=1 Then Expense_Expected_3_R Else Expense_Expected_3 end as Expense_Expected_3,
I2.Cost_Expected_3,
I2.Others_Expected_3,
I2.Cancel_Rate_3,

Case When @GroupType='R' and I2.ReinsuranceParamF=1 Then Weight_4_R Else Weight_4 end as Weight_4,
Case When @GroupType='R' and I2.ReinsuranceParamF=1 Then Claim_Expected_4_R Else Claim_Expected_4 end as Claim_Expected_4,
Case When @GroupType='R' and I2.ReinsuranceParamF=1 Then Expense_Expected_4_R Else Expense_Expected_4 end as Expense_Expected_4,
I2.Cost_Expected_4,
I2.Others_Expected_4,
I2.Cancel_Rate_4,

Case When @GroupType='R' and I2.ReinsuranceParamF=1 Then Weight_5_R Else Weight_5 end as Weight_5,
Case When @GroupType='R' and I2.ReinsuranceParamF=1 Then Claim_Expected_5_R Else Claim_Expected_5 end as Claim_Expected_5,
Case When @GroupType='R' and I2.ReinsuranceParamF=1 Then Expense_Expected_5_R Else Expense_Expected_5 end as Expense_Expected_5,
I2.Cost_Expected_5,
I2.Others_Expected_5,
I2.Cancel_Rate_5,

Case When @GroupType='R' and I2.ReinsuranceParamF=1 Then TotalWeight_R Else TotalWeight end as TotalWeight,
Case When @GroupType='R' and I2.ReinsuranceParamF=1 Then BEL_NPR_R Else BEL_NPR end as BEL_NPR,
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
I2.Inflation_Rate,
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
I9.ERatio_30
from IFRS_Assumption I1
cross apply (Select Top 1 * from IFRS_Assumption_Detail I2 Where I2.AssumptionID=I1.AssumptionID and I2.VDate<=@PDate order by I2.VDate Desc) I2
Left Join IFRS_Assumption_Segment I3 on (@AssumptionID='' and I3.AssumptionID=I1.AssumptionID and I3.Segment=@Segment)
Left Join IFRS_Assumption_ISType I4 on (@AssumptionID='' and I4.AssumptionID=I1.AssumptionID and I4.ISType=@ISType)
Left Join IFRS_Assumption_TOC I5 on (@AssumptionID='' and I5.AssumptionID=I1.AssumptionID and I5.TOC=@TOC)
Left Join IFRS_Assumption_CGroup I6 on (@AssumptionID='' and I6.AssumptionID=I1.AssumptionID and I6.CGroup=@Cgroup)
Left Join IFRS_Assumption_Currency I7 on (@AssumptionID='' and I7.AssumptionID=I1.AssumptionID and I7.Currency=@Currency)
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
Where 
(@AssumptionID<>'' 
 and I1.AssumptionID=@AssumptionID) or 
(@AssumptionID='' 
 and (I1.SI_Lower=0 or @TSI>=I1.SI_Lower)
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


  go


 insert into PatchVersioning
select '857 Update Script - IFRS Patch #30',GETDATE()
go


Declare @PrevScript varchar(100)
Declare @CurrScript varchar(100)

Select @PrevScript=''
Select @CurrSCript='857 Update Script - IFRS Patch #30'


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




 
 

