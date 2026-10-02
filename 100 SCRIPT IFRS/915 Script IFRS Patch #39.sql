IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'CancelRateID' AND Object_ID = Object_ID(N'IFRS_Assumption'))
BEGIN
ALTER TABLE IFRS_Assumption ADD CancelRateID varchar(10) NULL
DECLARE @v sql_variant 
SET @v = N'Refer to IFRS_CancelRate'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'IFRS_Assumption', N'COLUMN', N'CancelRateID'
END
GO

Drop Procedure IFRS_Get_Assumption
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
go

 insert into PatchVersioning
select '915 Update Script - IFRS Patch #39',GETDATE()
go