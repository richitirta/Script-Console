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
ALTER TABLE dbo.IFRS_Assumption_Detail ADD
	ReinsuranceParamF bit NULL,
	Claim_PAD_R float(53) NULL,
	Expense_PAD_R float(53) NULL,
	Claim_Expected_1_R float(53) NULL,
	Expense_Expected_1_R float(53) NULL,
	Weight_1_R float(53) NULL,
	Claim_Expected_2_R float(53) NULL,
	Expense_Expected_2_R float(53) NULL,
	Weight_2_R float(53) NULL,
	Claim_Expected_3_R float(53) NULL,
	Expense_Expected_3_R float(53) NULL,
	Weight_3_R float(53) NULL,
	Claim_Expected_4_R float(53) NULL,
	Expense_Expected_4_R float(53) NULL,
	Weight_4_R float(53) NULL,
	Claim_Expected_5_R float(53) NULL,
	Expense_Expected_5_R float(53) NULL,
	Weight_5_R float(53) NULL,
	TotalWeight_R float(53) NULL,
	Cancel_Rate_1_R float(53) NULL,
	Cancel_Rate_2_R float(53) NULL,
	Cancel_Rate_3_R float(53) NULL,
	Cancel_Rate_4_R float(53) NULL,
	Cancel_Rate_5_R float(53) NULL
GO
DECLARE @v sql_variant 
SET @v = N'Reinsurance Held Parameters (0 : No, 1 : Yes)'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'IFRS_Assumption_Detail', N'COLUMN', N'ReinsuranceParamF'
GO
DECLARE @v sql_variant 
SET @v = N'% Claim PAD For Reinsurance'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'IFRS_Assumption_Detail', N'COLUMN', N'Claim_PAD_R'
GO
DECLARE @v sql_variant 
SET @v = N'Expense PAD For Reinsurance'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'IFRS_Assumption_Detail', N'COLUMN', N'Expense_PAD_R'
GO
Update IFRS_Assumption_Detail set ReinsuranceParamF=0 Where ReinsuranceParamF is null
GO
COMMIT

GO

/****** Object:  Table [dbo].[IFRS_Assumption_ISType]    Script Date: 3/26/2023 10:22:49 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

SET ANSI_PADDING ON
GO

CREATE TABLE [dbo].[IFRS_Assumption_ISType](
	[AssumptionID] [varchar](10) NOT NULL,
	[ISType] [varchar](10) NOT NULL,
 CONSTRAINT [I_IFRS_Assumption_ISType] PRIMARY KEY CLUSTERED 
(
	[AssumptionID] ASC,
	[ISType] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO

SET ANSI_PADDING OFF
GO

ALTER TABLE [dbo].[IFRS_Assumption_ISType]  WITH CHECK ADD  CONSTRAINT [FK_IFRS_Assumption_ISType_IFRS_Assumption] FOREIGN KEY([AssumptionID])
REFERENCES [dbo].[IFRS_Assumption] ([AssumptionID])
ON UPDATE CASCADE
ON DELETE CASCADE
GO

ALTER TABLE [dbo].[IFRS_Assumption_ISType] CHECK CONSTRAINT [FK_IFRS_Assumption_ISType_IFRS_Assumption]
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
ALTER TABLE dbo.IFRS_Initial ADD
	ISType varchar(1) NULL
GO
DECLARE @v sql_variant 
SET @v = N'Insurance Source Type'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'IFRS_Initial', N'COLUMN', N'ISType'
GO
Update IFRS_Initial Set ISType='I' Where ISType is null
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
ALTER TABLE dbo.IFRS_Calculation ADD
	ISType varchar(1) NULL
GO
DECLARE @v sql_variant 
SET @v = N'Insurance Source Type'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'IFRS_Calculation', N'COLUMN', N'ISType'
GO
Update IFRS_Calculation Set ISType='I' Where ISType is null
GO
COMMIT

GO

drop index IFRS_Initial.I_IFRS_Initial_A_PolicyNo_Type_AssumptionID_Method_Branch_Segment_TOC_Year_Month_NumMonths
GO
create index I_IFRS_Initial_A_PolicyNo_Type_AssumptionID_Method_Branch_Segment_ISType_TOC_Year_Month_NumMonths on IFRS_Initial(A_PolicyNo, Type, AssumptionID, Method, Branch, ISType, Segment, TOC, Year, Month, NumMonths)

GO
drop index IFRS_Calculation.I_IFRS_Calculation_AssumptionID_Method_Branch_Segment_TOC_Year_Month_NumMonths_Onerous
GO
create index I_IFRS_Calculation_AssumptionID_Method_Branch_Segment_ISType_TOC_Year_Month_NumMonths_Onerous on IFRS_Calculation(AssumptionID, Method, Branch, Segment, ISType, TOC, Year, Month, NumMonths, Onerous)


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
Case When @GroupType='R' and I2.ReinsuranceParamF=1 Then Claim_PAD_R Else Claim_PAD end as Claim_PAD,
Case When @GroupType='R' and I2.ReinsuranceParamF=1 Then Expense_PAD_R Else Expense_PAD end as Expense_PAD,

Case When @GroupType='R' and I2.ReinsuranceParamF=1 Then Weight_1_R Else Weight_1 end as Weight_1,
Case When @GroupType='R' and I2.ReinsuranceParamF=1 Then Claim_Expected_1_R Else Claim_Expected_1 end as Claim_Expected_1,
Case When @GroupType='R' and I2.ReinsuranceParamF=1 Then Expense_Expected_1_R Else Expense_Expected_1 end as Expense_Expected_1,
Case When @GroupType='R' and I2.ReinsuranceParamF=1 Then Cancel_Rate_1_R Else Cancel_Rate_1 end as Cancel_Rate_1,

Case When @GroupType='R' and I2.ReinsuranceParamF=1 Then Weight_2_R Else Weight_2 end as Weight_2,
Case When @GroupType='R' and I2.ReinsuranceParamF=1 Then Claim_Expected_2_R Else Claim_Expected_2 end as Claim_Expected_2,
Case When @GroupType='R' and I2.ReinsuranceParamF=1 Then Expense_Expected_2_R Else Expense_Expected_2 end as Expense_Expected_2,
Case When @GroupType='R' and I2.ReinsuranceParamF=1 Then Cancel_Rate_2_R Else Cancel_Rate_2 end as Cancel_Rate_2,

Case When @GroupType='R' and I2.ReinsuranceParamF=1 Then Weight_3_R Else Weight_3 end as Weight_3,
Case When @GroupType='R' and I2.ReinsuranceParamF=1 Then Claim_Expected_3_R Else Claim_Expected_3 end as Claim_Expected_3,
Case When @GroupType='R' and I2.ReinsuranceParamF=1 Then Expense_Expected_3_R Else Expense_Expected_3 end as Expense_Expected_3,
Case When @GroupType='R' and I2.ReinsuranceParamF=1 Then Cancel_Rate_3_R Else Cancel_Rate_3 end as Cancel_Rate_3,

Case When @GroupType='R' and I2.ReinsuranceParamF=1 Then Weight_4_R Else Weight_4 end as Weight_4,
Case When @GroupType='R' and I2.ReinsuranceParamF=1 Then Claim_Expected_4_R Else Claim_Expected_4 end as Claim_Expected_4,
Case When @GroupType='R' and I2.ReinsuranceParamF=1 Then Expense_Expected_4_R Else Expense_Expected_4 end as Expense_Expected_4,
Case When @GroupType='R' and I2.ReinsuranceParamF=1 Then Cancel_Rate_4_R Else Cancel_Rate_4 end as Cancel_Rate_4,

Case When @GroupType='R' and I2.ReinsuranceParamF=1 Then Weight_5_R Else Weight_5 end as Weight_5,
Case When @GroupType='R' and I2.ReinsuranceParamF=1 Then Claim_Expected_5_R Else Claim_Expected_5 end as Claim_Expected_5,
Case When @GroupType='R' and I2.ReinsuranceParamF=1 Then Expense_Expected_5_R Else Expense_Expected_5 end as Expense_Expected_5,
Case When @GroupType='R' and I2.ReinsuranceParamF=1 Then Cancel_Rate_5_R Else Cancel_Rate_5 end as Cancel_Rate_5,

Case When @GroupType='R' and I2.ReinsuranceParamF=1 Then TotalWeight_R Else TotalWeight end as TotalWeight,
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
Left Join IFRS_Assumption_ISType I4 on (@AssumptionID='' and I3.AssumptionID=I1.AssumptionID and I4.ISType=@ISType)
Left Join IFRS_Assumption_TOC I5 on (@AssumptionID='' and I4.AssumptionID=I1.AssumptionID and I5.TOC=@TOC)
Left Join IFRS_Assumption_CGroup I6 on (@AssumptionID='' and I5.AssumptionID=I1.AssumptionID and I6.CGroup=@Cgroup)
Left Join IFRS_Assumption_Currency I7 on (@AssumptionID='' and I6.AssumptionID=I1.AssumptionID and I7.Currency=@Currency)
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


insert into ISType(ISType, Description, Prefix, Infix)
Select 'X', 'EXCESS OF LOSS','',''

GO

Insert into IFRS_Assumption_ISType(AssumptionID, ISType)
Select IFRS_Assumption.AssumptionID, ISType.ISType
from IFRS_Assumption, ISType


GO






 insert into PatchVersioning	
select '595 Update Script - IFRS Patch #7',GETDATE()
go





Declare @PrevScript varchar(100)
Declare @CurrScript varchar(100)

Select @PrevScript=''
Select @CurrSCript='595 Update Script - IFRS Patch #7'


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








