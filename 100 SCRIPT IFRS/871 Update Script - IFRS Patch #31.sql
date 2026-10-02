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
IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'PGroupTag' AND Object_ID = Object_ID(N'IFRS_Initial'))
BEGIN
ALTER TABLE dbo.IFRS_Initial ADD
	PGroupTag varchar(1) NULL
END
GO
DECLARE @v sql_variant 
SET @v = N'Profitability Group Tag (''P'' : Profit, ''R'' : Remaining, ''O'' : Onerous)'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'IFRS_Initial', N'COLUMN', N'PGroupTag'
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
IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'PGroupTag' AND Object_ID = Object_ID(N'IFRS_Calculation'))
BEGIN
ALTER TABLE dbo.IFRS_Calculation ADD
	PGroupTag varchar(1) NULL
END
GO
DECLARE @v sql_variant 
SET @v = N'Profitability Group Tag (''P'' : Profit, ''R'' : Remaining, ''O'' : Onerous)'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'IFRS_Calculation', N'COLUMN', N'PGroupTag'
GO

COMMIT

Drop index ifrs_calculation.I_IFRS_Calculation_AssumptionID_Method_Branch_Segment_ISType_TOC_CGroup_Currency_Year_Month_NumMonths_Onerous
GO
Create index I_IFRS_Calculation_AssumptionID_Method_Branch_Segment_ISType_TOC_CGroup_Currency_Year_Month_NumMonths_PGroupTag on ifrs_calculation(AssumptionID, Method, Branch, Segment, ISType, TOC, CGroup, Currency, Year, Month, NumMonths, PGroupTag)

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
IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'PThresHold' AND Object_ID = Object_ID(N'IFRS_Assumption'))
BEGIN
ALTER TABLE dbo.IFRS_Assumption ADD
	PThresHold float(53) NULL
END
GO
DECLARE @v sql_variant 
SET @v = N'Profitability Threshold (in %)'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'IFRS_Assumption', N'COLUMN', N'PThresHold'
GO
COMMIT
GO

DROP Procedure IFRS_Get_Assumption
GO
Create Procedure IFRS_Get_Assumption(@PDate as smalldatetime, @NumMonths as Integer, @AssumptionID as varchar(10), @TSI as Float, @Segment as varchar(10), @ISType as varchar(10), @TOC as varchar(10), @CGroup as varchar(10), @Currency as varchar(10), @GroupType as varchar(10))                  
as                  

Declare @NumYears as Integer

Select @NumYears=Case When (@NumMonths % 12)<>0 then @NumMonths/12+1 else @NumMonths/12 end

Select 
I1.PThresHold, 
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

GO



 insert into PatchVersioning
select '871 Update Script - IFRS Patch #31',GETDATE()
go


Declare @PrevScript varchar(100)
Declare @CurrScript varchar(100)

Select @PrevScript=''
Select @CurrSCript='871 Update Script - IFRS Patch #31'


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







