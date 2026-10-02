IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'ACQ_Cost' AND Object_ID = Object_ID(N'IFRS_Movement'))
BEGIN
ALTER TABLE IFRS_Movement ADD ACQ_Cost float(53) NULL
END
GO

IF EXISTS(SELECT * FROM sys.columns WHERE Name = N'Amount_1_1' AND Object_ID = Object_ID(N'ACCLINK'))
BEGIN
ALTER TABLE ACCLINK DROP COLUMN Amount_1_1
END
GO
IF EXISTS(SELECT * FROM sys.columns WHERE Name = N'Amount_1_2' AND Object_ID = Object_ID(N'ACCLINK'))
BEGIN
ALTER TABLE ACCLINK DROP COLUMN Amount_1_2
END
GO
IF EXISTS(SELECT * FROM sys.columns WHERE Name = N'Amount_1_3' AND Object_ID = Object_ID(N'ACCLINK'))
BEGIN
ALTER TABLE ACCLINK DROP COLUMN Amount_1_3
END
GO
IF EXISTS(SELECT * FROM sys.columns WHERE Name = N'Amount_1_4' AND Object_ID = Object_ID(N'ACCLINK'))
BEGIN
ALTER TABLE ACCLINK DROP COLUMN Amount_1_4
END
GO
IF EXISTS(SELECT * FROM sys.columns WHERE Name = N'Amount_1_5' AND Object_ID = Object_ID(N'ACCLINK'))
BEGIN
ALTER TABLE ACCLINK DROP COLUMN Amount_1_5
END
GO
IF EXISTS(SELECT * FROM sys.columns WHERE Name = N'Amount_1_6' AND Object_ID = Object_ID(N'ACCLINK'))
BEGIN
ALTER TABLE ACCLINK DROP COLUMN Amount_1_6
END
GO


IF EXISTS(SELECT * FROM sys.columns WHERE Name = N'Amount_3_1' AND Object_ID = Object_ID(N'ACCLINK'))
BEGIN
ALTER TABLE ACCLINK DROP COLUMN Amount_3_1
END
GO
IF EXISTS(SELECT * FROM sys.columns WHERE Name = N'Amount_3_2' AND Object_ID = Object_ID(N'ACCLINK'))
BEGIN
ALTER TABLE ACCLINK DROP COLUMN Amount_3_2
END
GO
IF EXISTS(SELECT * FROM sys.columns WHERE Name = N'Amount_3_3' AND Object_ID = Object_ID(N'ACCLINK'))
BEGIN
ALTER TABLE ACCLINK DROP COLUMN Amount_3_3
END
GO
IF EXISTS(SELECT * FROM sys.columns WHERE Name = N'Amount_3_4' AND Object_ID = Object_ID(N'ACCLINK'))
BEGIN
ALTER TABLE ACCLINK DROP COLUMN Amount_3_4
END
GO
IF EXISTS(SELECT * FROM sys.columns WHERE Name = N'Amount_3_5' AND Object_ID = Object_ID(N'ACCLINK'))
BEGIN
ALTER TABLE ACCLINK DROP COLUMN Amount_3_5
END
GO
IF EXISTS(SELECT * FROM sys.columns WHERE Name = N'Amount_3_6' AND Object_ID = Object_ID(N'ACCLINK'))
BEGIN
ALTER TABLE ACCLINK DROP COLUMN Amount_3_6
END
GO
IF EXISTS(SELECT * FROM sys.columns WHERE Name = N'Amount_3_7' AND Object_ID = Object_ID(N'ACCLINK'))
BEGIN
ALTER TABLE ACCLINK DROP COLUMN Amount_3_7
END
GO
IF EXISTS(SELECT * FROM sys.columns WHERE Name = N'Amount_3_8' AND Object_ID = Object_ID(N'ACCLINK'))
BEGIN
ALTER TABLE ACCLINK DROP COLUMN Amount_3_8
END
GO


IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'Amount_31' AND Object_ID = Object_ID(N'ACCLINK'))
BEGIN
ALTER TABLE ACCLINK ADD Amount_31 float(53) NULL
END
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
 Loss_Start Float,
 Loss_Portion_from_Claim_Release Float,
 Loss_Portion_from_Expense_Release Float,
 Loss_Portion_from_Cost_Release Float,
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
Declare @Loss_End as Float
Declare @BEL_GainLoss_DiscRate as Float
Declare @RA_GainLoss_DiscRate as Float
Declare @BEL_NonPerformingRisk as Float

if @Cumulative=1 
Begin
	Select @PProcessDate='01/01/1901'
	Select @BEL_Ending_After_Change_NonDiscRate=0
	Select @BEL_GainLoss_DiscRate=0
	Select @BEL_NonPerformingRisk=0
	Select @RA_Ending_After_Change_NonDiscRate=0
	Select @RA_GainLoss_DiscRate=0
	Select @CSM_End=0
	Select @Loss_End=0
End
else
Begin
	Select @PProcessDate=dateadd(day,-1,cast(month(@ProcessDate) as varchar(2))+'/01/'+cast(year(@ProcessDate) as varchar(4)))

	Select 
	 @BEL_Ending_After_Change_NonDiscRate=sum(BEL_Initial+BEL_Premium_Expected+BEL_Commission_Expected+BEL_Interest_Accrete+BEL_Claim_Expected+BEL_Expense_Expected+BEL_Cost_Expected+BEL_Refund_Expected+BEL_GainLoss_NonDiscRate),
	 @BEL_GainLoss_DiscRate=sum(BEL_GainLoss_DiscRate),
	 @BEL_NonPerformingRisk=sum(BEL_NonPerformingRisk),
	 @RA_Ending_After_Change_NonDiscRate=sum(RA_Initial+RA_Interest_Accrete+RA_Release+RA_GainLoss_NonDiscRate),
	 @RA_GainLoss_DiscRate=sum(RA_GainLoss_DiscRate),
	 @CSM_End=sum(CSM_Initial+CSM_Interest_Accrete+CSM_Amortization+CSM_GainLoss_NonDiscRate),
	 @Loss_End=sum(Loss_Initial+Loss_Portion_from_Claim_Release+Loss_Portion_from_Expense_Release+Loss_Portion_from_Cost_Release+Loss_Portion_from_Refund_Release+Loss_Portion_from_RA_Release+Loss_Portion_from_Interest_Accrete+Loss_Portion_from_GainLoss_DiscRate+Loss_GainLoss_NonDiscRate)
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
	 if @Loss_End is null
		Select @Loss_End=0

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
 BEL_Refund_Expected=sum(BEL_Refund_Expected),

 BEL_Ending_Before_Change=@BEL_Ending_After_Change_NonDiscRate+sum(BEL_Initial+BEL_Premium_Expected+BEL_Commission_Expected+BEL_Interest_Accrete+BEL_Claim_Expected+BEL_Expense_Expected+BEL_Cost_Expected+BEL_Refund_Expected),

 BEL_Ending_After_Change_NonDiscRate=@BEL_Ending_After_Change_NonDiscRate+sum(BEL_Initial+BEL_Premium_Expected+BEL_Commission_Expected+BEL_Interest_Accrete+BEL_Claim_Expected+BEL_Expense_Expected+BEL_Cost_Expected+BEL_Refund_Expected+BEL_GainLoss_NonDiscRate),
 BEL_Ending_After_Change_DiscRate=@BEL_Ending_After_Change_NonDiscRate+@BEL_GainLoss_DiscRate+sum(BEL_Initial+BEL_Premium_Expected+BEL_Commission_Expected+BEL_Interest_Accrete+BEL_Claim_Expected+BEL_Expense_Expected+BEL_Cost_Expected+BEL_Refund_Expected+BEL_GainLoss_NonDiscRate+BEL_GainLoss_DiscRate),

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

 Loss_Start=@Loss_End+sum(case When Description='' Then LOSS_Initial Else 0 End),
 Loss_Portion_from_Claim_Release=sum(Loss_Portion_from_Claim_Release),
 Loss_Portion_from_Expense_Release=sum(Loss_Portion_from_Expense_Release),
 Loss_Portion_from_Cost_Release=sum(Loss_Portion_from_Cost_Release),
 Loss_Portion_from_Refund_Release=sum(Loss_Portion_from_Refund_Release),
 Loss_Portion_from_RA_Release=sum(Loss_Portion_from_RA_Release),
 Loss_Portion_from_Interest_Accrete=sum(Loss_Portion_from_Interest_Accrete),
 Loss_Portion_from_GainLoss_DiscRate=sum(Loss_Portion_from_GainLoss_DiscRate),
 Loss_GainLoss_NonDiscRate=sum(Loss_GainLoss_NonDiscRate),
 LOSS_Adjustment=sum(case When Description<>'' Then LOSS_Initial Else 0 End),
 Loss_End=@Loss_End+sum(Loss_Initial+Loss_Portion_from_Claim_Release+Loss_Portion_from_Expense_Release+Loss_Portion_from_Cost_Release+Loss_Portion_from_Refund_Release+Loss_Portion_from_RA_Release+Loss_Portion_from_Interest_Accrete+Loss_Portion_from_GainLoss_DiscRate+Loss_GainLoss_NonDiscRate),
 ACQ_Amortization=sum(ACQ_Amortization),
 ACQ_Cost=sum(ACQ_Cost)
from IFRS_Movement I
Where I.GroupID=@GroupID and I.GroupType=@GroupType and I.ProcessDate<=@ProcessDate and I.ProcessDate>@PProcessDate



Select 'BEL_Beginning'as Description,  BEL_Beginning as Nominal from @IFRS Where @Method='B' Union All
Select 'BEL_Premium_Expected'as Description,  BEL_Premium_Expected as Nominal from @IFRS Where @Method='B' Union All
Select 'BEL_Commission_Expected'as Description,  BEL_Commission_Expected as Nominal from @IFRS Where @Method='B' Union All
Select 'BEL_Interest_Accrete'as Description,  BEL_Interest_Accrete as Nominal from @IFRS Where @Method='B' Union All
Select 'BEL_Claim_Expected'as Description,  BEL_Claim_Expected as Nominal from @IFRS Where @Method='B' Union All
Select 'BEL_Expense_Expected'as Description,  BEL_Expense_Expected as Nominal from @IFRS Where @Method='B' Union All
Select 'BEL_Cost_Expected'as Description,  BEL_Cost_Expected as Nominal from @IFRS Where @Method='B' and BEL_Cost_Expected<0 Union All
Select 'BEL_Refund_Expected'as Description,  BEL_Refund_Expected as Nominal from @IFRS Where @Method='B' Union All
Select 'BEL_Ending_Before_Change'as Description,  BEL_Ending_Before_Change as Nominal from @IFRS Where @Method='B' Union All
Select 'BEL_GainLoss_NonDiscRate'as Description,  BEL_GainLoss_NonDiscRate as Nominal from @IFRS Where @Method='B' Union All
Select 'BEL_Ending_After_Change_NonDiscRate'as Description,  BEL_Ending_After_Change_NonDiscRate as Nominal from @IFRS Where @Method='B' Union All
Select 'BEL_GainLoss_DiscRate'as Description,  BEL_GainLoss_DiscRate as Nominal from @IFRS Where @Method='B' Union All
Select 'BEL_NonPerformingRisk' as Description, BEL_NonPerformingRisk as Nominal from @IFRS Where @Method='B'and @GroupType='R' Union All
Select 'BEL_Ending_After_Change_DiscRate'as Description,  BEL_Ending_After_Change_DiscRate as Nominal from @IFRS Where @Method='B' Union All
Select 'RA_Beginning'as Description,  RA_Beginning as Nominal from @IFRS Where @Method='B' Union All
Select 'RA_Interest_Accrete'as Description,  RA_Interest_Accrete as Nominal from @IFRS Where @Method='B' Union All
Select 'RA_Release'as Description,  RA_Release as Nominal from @IFRS Where @Method='B' Union All
Select 'RA_Ending_Before_Change'as Description,  RA_Ending_Before_Change as Nominal from @IFRS Where @Method='B' Union All
Select 'RA_GainLoss_NonDiscRate'as Description,  RA_GainLoss_NonDiscRate as Nominal from @IFRS Where @Method='B' Union All
Select 'RA_Ending_After_Change_NonDiscRate'as Description,  RA_Ending_After_Change_NonDiscRate as Nominal from @IFRS Where @Method='B' Union All
Select 'RA_GainLoss_DiscRate'as Description,  RA_GainLoss_DiscRate as Nominal from @IFRS Where @Method='B' Union All
Select 'RA_Ending_After_Change_DiscRate'as Description,  RA_Ending_After_Change_DiscRate as Nominal from @IFRS Where @Method='B' Union All

Select 'CSM_Start'as Description,  CSM_Start as Nominal from @IFRS Where (@Method='B') and (CSM_Start<>0) Union All
Select 'CSM_Interest_Accrete'as Description,  CSM_Interest_Accrete as Nominal from @IFRS Where (@Method='B') and (CSM_Interest_Accrete<>0) Union All
Select 'CSM_Amortization'as Description,  CSM_Amortization as Nominal from @IFRS Where (@Method='B') and (CSM_Amortization<>0) Union All
Select 'CSM_GainLoss_NonDiscRate'as Description,  CSM_GainLoss_NonDiscRate as Nominal from @IFRS Where (@Method='B') and (CSM_GainLoss_NonDiscRate<>0) Union All
Select 'CSM_Adjustment' as Description, CSM_Adjustment as Nominal from @IFRS Where (@Method='B') and (CSM_Adjustment<>0) Union All
Select 'CSM_End' as Description, CSM_End as Nominal from @IFRS Where (@Method='B') and (CSM_End<>0) Union All

Select 'PAA_Start'as Description,  CSM_Start-(BEL_Premium_Expected+BEL_Commission_Expected) as Nominal from @IFRS Where (@Method='P') and (CSM_Start<>0) Union All
Select 'PAA_Premium_Expected'as Description,  BEL_Premium_Expected as Nominal from @IFRS Where @Method='P' Union All
Select 'PAA_Commission_Expected'as Description,  BEL_Commission_Expected as Nominal from @IFRS Where @Method='P' Union All
Select 'PAA_Adjustment_Financial'as Description,  CSM_Interest_Accrete as Nominal from @IFRS Where @Method='P' Union All
Select 'PAA_Amortization'as Description,  CSM_Amortization as Nominal from @IFRS Where @Method='P' Union All
Select 'PAA_End' as Description, CSM_End as Nominal from @IFRS Where (@Method='P') and (CSM_End<>0) Union All

Select 'Loss_Start'as Description,  Loss_Start as Nominal from @IFRS Where (@Method='B') and (Loss_Start<>0) Union All
Select 'Loss_Portion_from_Claim_Release'as Description,  Loss_Portion_from_Claim_Release as Nominal from @IFRS Where (@Method='B') and (Loss_Portion_from_Claim_Release<>0) Union All
Select 'Loss_Portion_from_Expense_Release'as Description,  Loss_Portion_from_Expense_Release as Nominal from @IFRS Where (@Method='B') and (Loss_Portion_from_Expense_Release<>0) Union All
Select 'Loss_Portion_from_Cost_Release'as Description,  Loss_Portion_from_Cost_Release as Nominal from @IFRS Where (@Method='B') and (Loss_Portion_from_Cost_Release<>0) Union All
Select 'Loss_Portion_from_Refund_Release'as Description,  Loss_Portion_from_Refund_Release as Nominal from @IFRS Where (@Method='B') and (Loss_Portion_from_Refund_Release<>0) Union All 
Select 'Loss_Portion_from_RA_Release'as Description,  Loss_Portion_from_RA_Release as Nominal from @IFRS Where (@Method='B') and (Loss_Portion_from_RA_Release<>0) Union All
Select 'Loss_Portion_from_Interest_Accrete'as Description,  Loss_Portion_from_Interest_Accrete as Nominal from @IFRS Where (@Method='B') and (Loss_Portion_from_Interest_Accrete<>0) Union All
Select 'Loss_Portion_from_GainLoss_DiscRate'as Description,  Loss_Portion_from_GainLoss_DiscRate as Nominal from @IFRS Where (@Method='B') and (Loss_Portion_from_GainLoss_DiscRate<>0) Union All 
Select 'Loss_GainLoss_NonDiscRate'as Description,  Loss_GainLoss_NonDiscRate as Nominal from @IFRS Where (@Method='B') and (Loss_GainLoss_NonDiscRate<>0)  Union All
Select 'Loss_Adjustment' as Description, Loss_adjustment as Nominal from @IFRS Where  (@Method='B') and (Loss_adjustment<>0) Union All 
Select 'Loss_End' as Description, Loss_End as Nominal from @IFRS Where  (@Method='B') and (Loss_End<>0) Union All 
Select 'ACQ_Amortization'as Description,  ACQ_Amortization as Nominal from @IFRS 
Select 'ACQ_Cost'as Description,  ACQ_Cost as Nominal from @IFRS 
GO

GO
DROP Procedure IFRS_SHOW_MOVEMENT
GO
Create Procedure IFRS_SHOW_MOVEMENT(@GroupID as Int, @GroupType as varchar(1), @SDate smalldatetime, @EDate smalldatetime)
as

Declare @IFRS table (
 VType varchar(10), 
 BEL_Beginning Float,
 BEL_Premium_Expected Float,
 BEL_Commission_Expected Float,
 BEL_Interest_Accrete Float,
 BEL_Claim_Expected Float,
 BEL_Expense_Expected Float,
 BEL_Cost_Expected Float,
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
 Loss_Start Float,
 Loss_Portion_from_Claim_Release Float,
 Loss_Portion_from_Expense_Release Float,
 Loss_Portion_from_Cost_Release Float,
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
Declare @OneRous as Bit

Select @Method=I.Method, @OneRous=Case WHen @GroupType='I' Then I.OneRous else cast(0 as Bit) end from IFRS_Calculation I Where GroupID=@GroupID

insert into @IFRS
Select 
 VType=Max(Voucher.VType),
 BEL_Beginning=sum(BEL_Initial),
 BEL_Premium_Expected=sum(BEL_Premium_Expected),
 BEL_Commission_Expected=sum(BEL_Commission_Expected),
 BEL_Interest_Accrete=sum(BEL_Interest_Accrete),
 BEL_Claim_Expected=sum(BEL_Claim_Expected),
 BEL_Expense_Expected=sum(BEL_Expense_Expected),
 BEL_Cost_Expected=sum(BEL_Cost_Expected),
 BEL_Refund_Expected=sum(BEL_Refund_Expected),

 BEL_Ending_Before_Change=sum(BEL_Initial+BEL_Premium_Expected+BEL_Commission_Expected+BEL_Interest_Accrete+BEL_Claim_Expected+BEL_Expense_Expected+BEL_Cost_Expected+BEL_Refund_Expected),

 BEL_Ending_After_Change_NonDiscRate=sum(BEL_Initial+BEL_Premium_Expected+BEL_Commission_Expected+BEL_Interest_Accrete+BEL_Claim_Expected+BEL_Expense_Expected+BEL_Cost_Expected+BEL_Refund_Expected+BEL_GainLoss_NonDiscRate),
 BEL_Ending_After_Change_DiscRate=sum(BEL_Initial+BEL_Premium_Expected+BEL_Commission_Expected+BEL_Interest_Accrete+BEL_Claim_Expected+BEL_Expense_Expected+BEL_Cost_Expected+BEL_Refund_Expected+BEL_GainLoss_NonDiscRate+BEL_GainLoss_DiscRate),

 BEL_GainLoss_NonDiscRate=sum(BEL_GainLoss_NonDiscRate),
 BEL_GainLoss_DiscRate=sum(BEL_GainLoss_DiscRate),
 BEL_NonPerformingRisk=sum(BEL_NonPerformingRisk),

 RA_Beginning=sum(RA_Initial),
 RA_Interest_Accrete=sum(RA_Interest_Accrete),
 RA_Release=sum(RA_Release),

 RA_Ending_Before_Change=sum(RA_Initial+RA_Interest_Accrete+RA_Release),

 RA_Ending_After_Change_NonDiscRate=sum(RA_Initial+RA_Interest_Accrete+RA_Release+RA_GainLoss_NonDiscRate),
 RA_Ending_After_Change_DiscRate=sum(RA_Initial+RA_Interest_Accrete+RA_Release+RA_GainLoss_NonDiscRate+RA_GainLoss_DiscRate),

 RA_GainLoss_NonDiscRate=sum(RA_GainLoss_NonDiscRate),
 RA_GainLoss_DiscRate=sum(RA_GainLoss_DiscRate),

 CSM_Start=sum(Case When I.Description='' Then CSM_Initial Else 0 end),
 CSM_Interest_Accrete=sum(CSM_Interest_Accrete),
 CSM_Amortization=sum(CSM_Amortization),
 CSM_GainLoss_NonDiscRate=sum(CSM_GainLoss_NonDiscRate),
 CSM_Adjustment=sum(Case When I.Description<>'' Then CSM_Initial Else 0 end),
 CSM_End=sum(CSM_Initial+CSM_Interest_Accrete+CSM_Amortization+CSM_GainLoss_NonDiscRate),

 Loss_Start=sum(Case When I.Description='' Then Loss_Initial Else 0 end),
 Loss_Portion_from_Claim_Release=sum(Loss_Portion_from_Claim_Release),
 Loss_Portion_from_Expense_Release=sum(Loss_Portion_from_Expense_Release),
 Loss_Portion_from_Cost_Release=sum(Loss_Portion_from_Cost_Release),
 Loss_Portion_from_Refund_Release=sum(Loss_Portion_from_Refund_Release),
 Loss_Portion_from_RA_Release=sum(Loss_Portion_from_RA_Release),
 Loss_Portion_from_Interest_Accrete=sum(Loss_Portion_from_Interest_Accrete),
 Loss_Portion_from_GainLoss_DiscRate=sum(Loss_Portion_from_GainLoss_DiscRate),
 Loss_GainLoss_NonDiscRate=sum(Loss_GainLoss_NonDiscRate),
 LOSS_Adjustment=sum(Case When I.Description<>'' Then Loss_Initial Else 0 end),
 Loss_End=sum(Loss_Initial+Loss_Portion_from_Claim_Release+Loss_Portion_from_Expense_Release+Loss_Portion_from_Cost_Release+Loss_Portion_from_Refund_Release+Loss_Portion_from_RA_Release+Loss_Portion_from_Interest_Accrete+Loss_Portion_from_GainLoss_DiscRate+Loss_GainLoss_NonDiscRate),
 ACQ_Amortization=sum(ACQ_Amortization),
 ACQ_Cost=sum(ACQ_Cost)
from IFRS_Movement I, AccLink A, mVoucher Voucher
Where I.GroupID=@GroupID and I.GroupType=@GroupType and I.ProcessDate Between @Sdate and @EDate
and Voucher.Voucher=A.Voucher and A.AccNo=I.AccNo

Select VType, -1 as Hint, 'BEL_Beginning'as Description,  BEL_Beginning as Nominal from @IFRS Where @Method='B' Union All
Select VType, -2 as Hint, 'BEL_Premium_Expected'as Description,  BEL_Premium_Expected as Nominal from @IFRS Where @Method='B' Union All
Select VType, -3 as Hint, 'BEL_Commission_Expected'as Description,  BEL_Commission_Expected as Nominal from @IFRS Where @Method='B' Union All
Select VType, -4 as Hint, 'BEL_Interest_Accrete'as Description,  BEL_Interest_Accrete as Nominal from @IFRS Where @Method='B' Union All
Select VType, -5 as Hint, 'BEL_Claim_Expected'as Description,  BEL_Claim_Expected as Nominal from @IFRS Where @Method='B' Union All
Select VType, -6 as Hint, 'BEL_Expense_Expected'as Description,  BEL_Expense_Expected as Nominal from @IFRS Where @Method='B' Union All
Select VType, -17 as Hint, 'BEL_Cost_Expected'as Description,  BEL_Cost_Expected as Nominal from @IFRS Where @Method='B' and BEL_Cost_Expected<>0 Union All
Select VType, -28 as Hint, 'BEL_Refund_Expected'as Description,  BEL_Refund_Expected as Nominal from @IFRS Where @Method='B' Union All
Select VType, 0 as Hint, 'BEL_Ending_Before_Change'as Description,  BEL_Ending_Before_Change as Nominal from @IFRS Where @Method='B' Union All
Select VType, -7 as Hint, 'BEL_GainLoss_NonDiscRate'as Description,  BEL_GainLoss_NonDiscRate as Nominal from @IFRS Where @Method='B' Union All
Select VType, 0 as Hint, 'BEL_Ending_After_Change_NonDiscRate'as Description,  BEL_Ending_After_Change_NonDiscRate as Nominal from @IFRS Where @Method='B' Union All
Select VType, -8 as Hint, 'BEL_GainLoss_DiscRate'as Description,  BEL_GainLoss_DiscRate as Nominal from @IFRS Where @Method='B' Union All
Select VType, -30 as Hint, 'BEL_NonPerformingRisk'as Description,  BEL_NonPerformingRisk as Nominal from @IFRS Where @Method='B' and @GroupType='R' Union All
Select VType, 0 as Hint, 'BEL_Ending_After_Change_DiscRate'as Description,  BEL_Ending_After_Change_DiscRate as Nominal from @IFRS Where @Method='B' Union All
Select VType, -9 as Hint, 'RA_Beginning'as Description,  RA_Beginning as Nominal from @IFRS Where @Method='B' Union All
Select VType, -10 as Hint, 'RA_Interest_Accrete'as Description,  RA_Interest_Accrete as Nominal from @IFRS Where @Method='B' Union All
Select VType, -11 as Hint, 'RA_Release'as Description,  RA_Release as Nominal from @IFRS Where @Method='B' Union All
Select VType, 0 as Hint, 'RA_Ending_Before_Change'as Description,  RA_Ending_Before_Change as Nominal from @IFRS Where @Method='B' Union All
Select VType, -12 as Hint, 'RA_GainLoss_NonDiscRate'as Description,  RA_GainLoss_NonDiscRate as Nominal from @IFRS Where @Method='B' Union All
Select VType, 0 as Hint, 'RA_Ending_After_Change_NonDiscRate'as Description,  RA_Ending_After_Change_NonDiscRate as Nominal from @IFRS Where @Method='B' Union All
Select VType, -13 as Hint, 'RA_GainLoss_DiscRate'as Description,  RA_GainLoss_DiscRate as Nominal from @IFRS Where @Method='B' Union All
Select VType, 0 as Hint, 'RA_Ending_After_Change_DiscRate'as Description,  RA_Ending_After_Change_DiscRate as Nominal from @IFRS Where @Method='B' Union All

Select VType, -14 as Hint, 'CSM_Start'as Description,  CSM_Start as Nominal from @IFRS Where (@Method='B') and (CSM_Start<>0) Union All
Select VType, -15 as Hint, 'CSM_Interest_Accrete'as Description,  CSM_Interest_Accrete as Nominal from @IFRS Where (@Method='B') and (CSM_Interest_Accrete<>0) Union All
Select VType, -16 as Hint, 'CSM_Amortization'as Description,  CSM_Amortization as Nominal from @IFRS Where (@Method='B') and (CSM_Amortization<>0) Union All
Select VType, -18 as Hint, 'CSM_GainLoss_NonDiscRate'as Description,  CSM_GainLoss_NonDiscRate as Nominal from @IFRS Where (@Method='B') and (CSM_GainLoss_NonDiscRate<>0) Union All
Select VType, -14 as Hint, 'CSM_Adjustment'as Description,  CSM_Adjustment as Nominal from @IFRS Where (@Method='B') and (CSM_Adjustment<>0) Union All
Select VType, 0 as Hint, 'CSM_End'as Description,  CSM_End as Nominal from @IFRS Where (@Method='B') and (CSM_End<>0) Union All

Select VType, -2 as Hint, 'PAA_Premium_Expected'as Description,  BEL_Premium_Expected as Nominal from @IFRS Where @Method='P' Union All
Select VType, -3 as Hint, 'PAA_Commission_Expected'as Description,  BEL_Commission_Expected as Nominal from @IFRS Where @Method='P' Union All
Select VType, -15 as Hint, 'PAA_Adjustment_Financial'as Description,  CSM_Interest_Accrete as Nominal from @IFRS Where @Method='P' Union All
Select VType, -16 as Hint, 'PAA_Amortization'as Description,  CSM_Amortization as Nominal from @IFRS Where @Method='P' Union All

Select VType, -19 as Hint, 'Loss_Start'as Description,  Loss_Start as Nominal from @IFRS Where (@Method='B') and (Loss_Start<>0) Union All
Select VType, -20 as Hint, 'Loss_Portion_from_Claim_Release'as Description,  Loss_Portion_from_Claim_Release as Nominal from @IFRS Where (@Method='B') and (Loss_Portion_from_Claim_Release<>0) Union All
Select VType, -21 as Hint, 'Loss_Portion_from_Expense_Release'as Description,  Loss_Portion_from_Expense_Release as Nominal from @IFRS Where (@Method='B') and (Loss_Portion_from_Expense_Release<>0) Union All
Select VType, -24 as Hint, 'Loss_Portion_from_Cost_Release'as Description,  Loss_Portion_from_Cost_Release as Nominal from @IFRS Where (@Method='B') and (Loss_Portion_from_Cost_Release<>0) Union All
Select VType, -29 as Hint, 'Loss_Portion_from_Refund_Release'as Description,  Loss_Portion_from_Refund_Release as Nominal from @IFRS Where (@Method='B') and (Loss_Portion_from_Refund_Release<>0) Union All 
Select VType, -22 as Hint, 'Loss_Portion_from_RA_Release'as Description,  Loss_Portion_from_RA_Release as Nominal from @IFRS Where (@Method='B') and (Loss_Portion_from_RA_Release<>0) Union All
Select VType, -23 as Hint, 'Loss_Portion_from_Interest_Accrete'as Description,  Loss_Portion_from_Interest_Accrete as Nominal from @IFRS Where (@Method='B') and (Loss_Portion_from_Interest_Accrete<>0) 
Select VType, -25 as Hint, 'Loss_Portion_from_GainLoss_DiscRate'as Description,  Loss_Portion_from_GainLoss_DiscRate as Nominal from @IFRS Where (@Method='B') and (Loss_Portion_from_GainLoss_DiscRate<>0) Union All
Select VType, -26 as Hint, 'Loss_GainLoss_NonDiscRate'as Description,  Loss_GainLoss_NonDiscRate as Nominal from @IFRS Where (@Method='B') and (Loss_GainLoss_NonDiscRate<>0) Union All
Select VType, -19 as Hint, 'Loss_Adjustment'as Description,  Loss_Adjustment as Nominal from @IFRS Where (@Method='B') and (Loss_Adjustment<>0) Union All
Select VType, 0 as Hint, 'Loss_End'as Description,  Loss_End as Nominal from @IFRS Where (@Method='B' and @OneRous=1) or Loss_End<>0 Union All  
Select VType, -27 as Hint, 'ACQ_Amortization'as Description,  ACQ_Amortization as Nominal from @IFRS 
Select VType, -31 as Hint, 'ACQ_Cost'as Description,  ACQ_Cost as Nominal from @IFRS 
GO 


DROP FUNCTION IFRS_Movement_PROCESS
GO
Create FUNCTION IFRS_Movement_PROCESS(@P_Type varchar(2),@P_Date smalldatetime, @P_PEDate smalldatetime,@P_EDate smalldatetime)            
RETURNS @IFRS TABLE (GroupID Int, Branch varchar(10), DocNo varchar(50), RefNo varchar(50), Date smalldatetime, Code varchar(10), Type varchar(10), Currency varchar(10), Subject varchar(10), Remarks varchar(255),
Amount_1 Float, Amount_2 Float, Amount_3 Float, Amount_4 Float,Amount_5 Float, Amount_6 Float, Amount_7 Float, Amount_8 Float, Amount_9 Float, Amount_10 Float, 
Amount_11 Float, Amount_12 Float, Amount_13 Float, Amount_14 Float, Amount_15 Float, Amount_16 Float, Amount_17 Float, Amount_18 Float, Amount_19 Float, Amount_20 Float, 
Amount_21 Float, Amount_22 Float, Amount_23 Float, Amount_24 Float, Amount_25 Float, Amount_26 Float, Amount_27 Float, Amount_28 Float, Amount_29 Float, Amount_30 Float, Amount_31 Float)
AS
BEGIN

Declare @IFRS_Data TABLE (GroupID Int, Branch varchar(10), DocNo varchar(50), RefNo varchar(50), Date smalldatetime, Code varchar(10), Type varchar(10), Currency varchar(10), Subject varchar(10), Remarks varchar(255),
Amount_1 Float, Amount_2 Float, Amount_3 Float, Amount_4 Float,Amount_5 Float, Amount_6 Float, Amount_7 Float, Amount_8 Float, Amount_9 Float, Amount_10 Float, 
Amount_11 Float, Amount_12 Float, Amount_13 Float, Amount_14 Float, Amount_15 Float, Amount_16 Float, Amount_17 Float, Amount_18 Float, Amount_19 Float, Amount_20 Float, 
Amount_21 Float, Amount_22 Float, Amount_23 Float, Amount_24 Float, Amount_25 Float, Amount_26 Float, Amount_27 Float, Amount_28 Float, Amount_29 Float, Amount_30 Float, Amount_31 Float)

Declare @IFRS_Data_Paid TABLE (GroupID Int, Branch varchar(10), DocNo varchar(50), RefNo varchar(50), Date smalldatetime, Code varchar(10), Type varchar(10), Currency varchar(10), Subject varchar(10), Remarks varchar(255),
Amount_1 Float, Amount_2 Float, Amount_3 Float, Amount_4 Float,Amount_5 Float, Amount_6 Float, Amount_7 Float, Amount_8 Float, Amount_9 Float, Amount_10 Float, 
Amount_11 Float, Amount_12 Float, Amount_13 Float, Amount_14 Float, Amount_15 Float, Amount_16 Float, Amount_17 Float, Amount_18 Float, Amount_19 Float, Amount_20 Float, 
Amount_21 Float, Amount_22 Float, Amount_23 Float, Amount_24 Float, Amount_25 Float, Amount_26 Float, Amount_27 Float, Amount_28 Float, Amount_29 Float, Amount_30 Float, Amount_31 Float)


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
Amount_17 = sum(I1.BEL_Cost_Expected),
Amount_18 = sum(I1.CSM_GainLoss_NonDiscRate),
Amount_19 = sum(I1.Loss_Initial),
Amount_20 = sum(I1.Loss_Portion_from_Claim_Release),
Amount_21 = sum(I1.Loss_Portion_from_Expense_Release),
Amount_22 = sum(I1.Loss_Portion_from_RA_Release),
Amount_23 = sum(I1.Loss_Portion_from_Interest_Accrete),
Amount_24 = sum(I1.Loss_Portion_from_Cost_Release),
Amount_25 = sum(I1.Loss_Portion_from_GainLoss_DiscRate),
Amount_26 = sum(I1.Loss_GainLoss_NonDiscRate),
Amount_27 = sum(I1.ACQ_Amortization),
Amount_28 = sum(I1.BEL_Refund_Expected),
Amount_29 = sum(I1.Loss_Portion_from_Refund_Release),
Amount_30 = sum(I1.BEL_NonPerformingRisk),
Amount_31 = sum(I1.ACQ_Cost)
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
Amount_31 = cast(0 as Float)
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
cast(0 as Float) as Amount_31  --ACQ Cost in Base Currency
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
sum(I1.Amount_31) as Amount_31 --ACQ Cost in Base Currency
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
I1.Amount_31
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
cast(0 as Float) as Amount_31
from @IFRS_Data_Paid I1
Inner Join SysTab on (1=1)
Group By 
I1.GroupID, I1.Branch, I1.DocNo, I1.RefNo, I1.Date, I1.Code, I1.Type, SysTab.Currency, I1.Subject, I1.Remarks
Having sum(I1.Amount_7)<>0

RETURN
END





GO


 insert into PatchVersioning
select '849 Update Script - IFRS Patch #28',GETDATE()
go


Declare @PrevScript varchar(100)
Declare @CurrScript varchar(100)

Select @PrevScript=''
Select @CurrSCript='849 Update Script - IFRS Patch #28'


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