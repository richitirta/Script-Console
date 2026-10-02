DROP Procedure IFRS_SHOW_INITIAL
GO
Create Procedure IFRS_SHOW_INITIAL(@DataID as int, @GroupType as varchar(1), @YearN as Int, @MonthN as Int, @Cumulative as Bit)
as

Declare @IFRS table (
 BEL_Beginning Float,
 BEL_Premium_Expected Float,
 BEL_Commission_Expected Float,
 BEL_Interest_Accrete Float,
 BEL_Claim_Expected Float,
 BEL_Claim_NPR_Expected Float,
 BEL_Expense_Expected Float,
 BEL_Cost_Expected Float,
 BEL_Others_Expected Float,
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


Declare @IFRS_Detail Table(GroupID int, GroupType varchar(1), EffMonth Int, EffYear Int, Month Int, Year Int, Method varchar(1), Bel_Beginning Float, Total_Bel_Beginning Float, Net_Premium_Expected Float, Total_Net_Premium_Expected Float, Commission_Actual Float, Total_Commission_Actual Float, Bel_Beginning_Portion Float, Net_Premium_Expected_Portion Float, Commission_Actual_Portion Float)

insert into @IFRS_Detail
Select 
I2.GroupID, I2.GroupType, I2.EffMonth, I2.EffYear, 
max(I.Month) as Month, 
max(I.Year) as Year,
Max(I1.Method) as Method,
Sum(Case   
When (((I2.EffMonth+I2.EffYear*12)-(I1.Month+I1.Year*12)+1)-1)/12+1=1 then I3B.BEL_Beginning_1  
When (((I2.EffMonth+I2.EffYear*12)-(I1.Month+I1.Year*12)+1)-1)/12+1=2 then I3B.BEL_Beginning_2  
When (((I2.EffMonth+I2.EffYear*12)-(I1.Month+I1.Year*12)+1)-1)/12+1=3 then I3B.BEL_Beginning_3  
When (((I2.EffMonth+I2.EffYear*12)-(I1.Month+I1.Year*12)+1)-1)/12+1=4 then I3B.BEL_Beginning_4  
When (((I2.EffMonth+I2.EffYear*12)-(I1.Month+I1.Year*12)+1)-1)/12+1=5 then I3B.BEL_Beginning_5  
When (((I2.EffMonth+I2.EffYear*12)-(I1.Month+I1.Year*12)+1)-1)/12+1=6 then I3B.BEL_Beginning_6  
When (((I2.EffMonth+I2.EffYear*12)-(I1.Month+I1.Year*12)+1)-1)/12+1=7 then I3B.BEL_Beginning_7  
When (((I2.EffMonth+I2.EffYear*12)-(I1.Month+I1.Year*12)+1)-1)/12+1=8 then I3B.BEL_Beginning_8  
When (((I2.EffMonth+I2.EffYear*12)-(I1.Month+I1.Year*12)+1)-1)/12+1=9 then I3B.BEL_Beginning_9  
When (((I2.EffMonth+I2.EffYear*12)-(I1.Month+I1.Year*12)+1)-1)/12+1=10 then I3B.BEL_Beginning_10  
When (((I2.EffMonth+I2.EffYear*12)-(I1.Month+I1.Year*12)+1)-1)/12+1=11 then I3B.BEL_Beginning_11  
When (((I2.EffMonth+I2.EffYear*12)-(I1.Month+I1.Year*12)+1)-1)/12+1=12 then I3B.BEL_Beginning_12  
When (((I2.EffMonth+I2.EffYear*12)-(I1.Month+I1.Year*12)+1)-1)/12+1=13 then I3B.BEL_Beginning_13  
When (((I2.EffMonth+I2.EffYear*12)-(I1.Month+I1.Year*12)+1)-1)/12+1=14 then I3B.BEL_Beginning_14  
When (((I2.EffMonth+I2.EffYear*12)-(I1.Month+I1.Year*12)+1)-1)/12+1=15 then I3B.BEL_Beginning_15  
When (((I2.EffMonth+I2.EffYear*12)-(I1.Month+I1.Year*12)+1)-1)/12+1=16 then I3B.BEL_Beginning_16  
When (((I2.EffMonth+I2.EffYear*12)-(I1.Month+I1.Year*12)+1)-1)/12+1=17 then I3B.BEL_Beginning_17  
When (((I2.EffMonth+I2.EffYear*12)-(I1.Month+I1.Year*12)+1)-1)/12+1=18 then I3B.BEL_Beginning_18  
When (((I2.EffMonth+I2.EffYear*12)-(I1.Month+I1.Year*12)+1)-1)/12+1=19 then I3B.BEL_Beginning_19  
When (((I2.EffMonth+I2.EffYear*12)-(I1.Month+I1.Year*12)+1)-1)/12+1=20 then I3B.BEL_Beginning_20  
When (((I2.EffMonth+I2.EffYear*12)-(I1.Month+I1.Year*12)+1)-1)/12+1=21 then I3B.BEL_Beginning_21  
When (((I2.EffMonth+I2.EffYear*12)-(I1.Month+I1.Year*12)+1)-1)/12+1=22 then I3B.BEL_Beginning_22  
When (((I2.EffMonth+I2.EffYear*12)-(I1.Month+I1.Year*12)+1)-1)/12+1=23 then I3B.BEL_Beginning_23  
When (((I2.EffMonth+I2.EffYear*12)-(I1.Month+I1.Year*12)+1)-1)/12+1=24 then I3B.BEL_Beginning_24  
When (((I2.EffMonth+I2.EffYear*12)-(I1.Month+I1.Year*12)+1)-1)/12+1=25 then I3B.BEL_Beginning_25  
When (((I2.EffMonth+I2.EffYear*12)-(I1.Month+I1.Year*12)+1)-1)/12+1=26 then I3B.BEL_Beginning_26  
When (((I2.EffMonth+I2.EffYear*12)-(I1.Month+I1.Year*12)+1)-1)/12+1=27 then I3B.BEL_Beginning_27  
When (((I2.EffMonth+I2.EffYear*12)-(I1.Month+I1.Year*12)+1)-1)/12+1=28 then I3B.BEL_Beginning_28  
When (((I2.EffMonth+I2.EffYear*12)-(I1.Month+I1.Year*12)+1)-1)/12+1=29 then I3B.BEL_Beginning_29  
When (((I2.EffMonth+I2.EffYear*12)-(I1.Month+I1.Year*12)+1)-1)/12+1=30 then I3B.BEL_Beginning_30  
end) as BEL_Beginning,
Max(Case   
When (((I2.EffMonth+I2.EffYear*12)-(I1.Month+I1.Year*12)+1)-1)/12+1=1 then I2B.BEL_Beginning_1  
When (((I2.EffMonth+I2.EffYear*12)-(I1.Month+I1.Year*12)+1)-1)/12+1=2 then I2B.BEL_Beginning_2  
When (((I2.EffMonth+I2.EffYear*12)-(I1.Month+I1.Year*12)+1)-1)/12+1=3 then I2B.BEL_Beginning_3  
When (((I2.EffMonth+I2.EffYear*12)-(I1.Month+I1.Year*12)+1)-1)/12+1=4 then I2B.BEL_Beginning_4  
When (((I2.EffMonth+I2.EffYear*12)-(I1.Month+I1.Year*12)+1)-1)/12+1=5 then I2B.BEL_Beginning_5  
When (((I2.EffMonth+I2.EffYear*12)-(I1.Month+I1.Year*12)+1)-1)/12+1=6 then I2B.BEL_Beginning_6  
When (((I2.EffMonth+I2.EffYear*12)-(I1.Month+I1.Year*12)+1)-1)/12+1=7 then I2B.BEL_Beginning_7  
When (((I2.EffMonth+I2.EffYear*12)-(I1.Month+I1.Year*12)+1)-1)/12+1=8 then I2B.BEL_Beginning_8  
When (((I2.EffMonth+I2.EffYear*12)-(I1.Month+I1.Year*12)+1)-1)/12+1=9 then I2B.BEL_Beginning_9  
When (((I2.EffMonth+I2.EffYear*12)-(I1.Month+I1.Year*12)+1)-1)/12+1=10 then I2B.BEL_Beginning_10  
When (((I2.EffMonth+I2.EffYear*12)-(I1.Month+I1.Year*12)+1)-1)/12+1=11 then I2B.BEL_Beginning_11  
When (((I2.EffMonth+I2.EffYear*12)-(I1.Month+I1.Year*12)+1)-1)/12+1=12 then I2B.BEL_Beginning_12  
When (((I2.EffMonth+I2.EffYear*12)-(I1.Month+I1.Year*12)+1)-1)/12+1=13 then I2B.BEL_Beginning_13  
When (((I2.EffMonth+I2.EffYear*12)-(I1.Month+I1.Year*12)+1)-1)/12+1=14 then I2B.BEL_Beginning_14  
When (((I2.EffMonth+I2.EffYear*12)-(I1.Month+I1.Year*12)+1)-1)/12+1=15 then I2B.BEL_Beginning_15  
When (((I2.EffMonth+I2.EffYear*12)-(I1.Month+I1.Year*12)+1)-1)/12+1=16 then I2B.BEL_Beginning_16  
When (((I2.EffMonth+I2.EffYear*12)-(I1.Month+I1.Year*12)+1)-1)/12+1=17 then I2B.BEL_Beginning_17  
When (((I2.EffMonth+I2.EffYear*12)-(I1.Month+I1.Year*12)+1)-1)/12+1=18 then I2B.BEL_Beginning_18  
When (((I2.EffMonth+I2.EffYear*12)-(I1.Month+I1.Year*12)+1)-1)/12+1=19 then I2B.BEL_Beginning_19  
When (((I2.EffMonth+I2.EffYear*12)-(I1.Month+I1.Year*12)+1)-1)/12+1=20 then I2B.BEL_Beginning_20  
When (((I2.EffMonth+I2.EffYear*12)-(I1.Month+I1.Year*12)+1)-1)/12+1=21 then I2B.BEL_Beginning_21  
When (((I2.EffMonth+I2.EffYear*12)-(I1.Month+I1.Year*12)+1)-1)/12+1=22 then I2B.BEL_Beginning_22  
When (((I2.EffMonth+I2.EffYear*12)-(I1.Month+I1.Year*12)+1)-1)/12+1=23 then I2B.BEL_Beginning_23  
When (((I2.EffMonth+I2.EffYear*12)-(I1.Month+I1.Year*12)+1)-1)/12+1=24 then I2B.BEL_Beginning_24  
When (((I2.EffMonth+I2.EffYear*12)-(I1.Month+I1.Year*12)+1)-1)/12+1=25 then I2B.BEL_Beginning_25  
When (((I2.EffMonth+I2.EffYear*12)-(I1.Month+I1.Year*12)+1)-1)/12+1=26 then I2B.BEL_Beginning_26  
When (((I2.EffMonth+I2.EffYear*12)-(I1.Month+I1.Year*12)+1)-1)/12+1=27 then I2B.BEL_Beginning_27  
When (((I2.EffMonth+I2.EffYear*12)-(I1.Month+I1.Year*12)+1)-1)/12+1=28 then I2B.BEL_Beginning_28  
When (((I2.EffMonth+I2.EffYear*12)-(I1.Month+I1.Year*12)+1)-1)/12+1=29 then I2B.BEL_Beginning_29  
When (((I2.EffMonth+I2.EffYear*12)-(I1.Month+I1.Year*12)+1)-1)/12+1=30 then I2B.BEL_Beginning_30  
end) as Total_BEL_Beginning,
Sum(I3.Premium_Expected+I3.Commission_Expected) as Net_Premium_Expected,
Max(I2.Premium_Expected+I2.Commission_Expected) as Total_Net_Premium_Expected,
Sum(I3.Commission_Actual_BC) as Commission_Actual,
Max(I2.Commission_Actual_BC) as Total_Commission_Actual,
Cast(0 as Float) as Bel_Beginning_Portion, 
cast(0 as Float) as Net_Premium_Expected_Portion, 
cast(0 as Float) as Commission_Actual_Portion
from IFRS_Initial I
Inner Join IFRS_Calculation I1 on (I1.GroupID=I.GroupID)
Inner Join IFRS_Calculation_Detail I2 on (I2.GroupID=I1.GroupID and I2.GroupType=@GroupType and I2.EffYear=I.EffYear and I2.EffMonth=I.EffMonth)
Inner Join IFRS_Calculation_Detail_Bel I2b on (I2b.GroupID=I2.GroupID and I2b.GroupType=I2.GroupType and I2b.EffYear=I2.EffYear and I2b.EffMonth=I2.EffMonth)
Inner Join IFRS_initial_Detail I3 on (I3.DataID=I.DataID and I3.GroupType=@GroupType)
Inner Join IFRS_initial_Detail_Bel I3b on (I3b.DataID=I.DataID and I3b.GroupType=I3.GroupType)
Where I.DataID=@DataID 
Group By I2.GroupID, I2.GroupType, I2.EffMonth, I2.EffYear

Declare @Method as varchar(1)
Declare @ProcessDate as Date
Declare @PProcessDate as Date

Update I 
Set 
Bel_Beginning_Portion=Case When I.Total_BeL_Beginning<>0 Then I.Bel_Beginning/I.Total_BeL_Beginning Else 1 end,
Net_Premium_Expected_Portion=case When I.Total_Net_Premium_Expected<>0 then I.Net_Premium_Expected/I.Total_Net_Premium_Expected Else 1 end,
Commission_Actual_Portion=Case When I.Total_Commission_Actual<>0 then I.Commission_Actual/I.Total_Commission_Actual Else 1 end
from @IFRS_Detail I 

Select Top 1 @Method=I.Method, @ProcessDate=dateadd(day,-1,dateadd(month, ((@YearN-1)*12+@MonthN), cast(I.Month as varchar(2))+'/01/'+cast(I.year as varchar(4))))  
from @IFRS_Detail I 

Declare @BEL_Ending_After_Change_NonDiscRate as Float
Declare @RA_Ending_After_Change_NonDiscRate as Float
Declare @CSM_End as Float
Declare @PAA_End as Float
Declare @Loss_End as Float
Declare @BEL_GainLoss_DiscRate as Float
Declare @RA_GainLoss_DiscRate as Float
Declare @ACQ_Cost as Float

if @Cumulative=1 
Begin
	Select @PProcessDate='01/01/1901'
	Select @BEL_Ending_After_Change_NonDiscRate=0
	Select @BEL_GainLoss_DiscRate=0
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
	 @BEL_Ending_After_Change_NonDiscRate=sum((BEL_Initial+BEL_Premium_Expected+BEL_Commission_Expected+BEL_Interest_Accrete+BEL_Claim_Expected+BEL_Claim_NPR_Expected+BEL_Expense_Expected+BEL_Cost_Expected+BEL_Others_Expected+BEL_Refund_Expected+BEL_GainLoss_NonDiscRate)*Id.Bel_Beginning_Portion),
	 @BEL_GainLoss_DiscRate=sum(BEL_GainLoss_DiscRate*Id.Bel_Beginning_Portion),
	 @RA_Ending_After_Change_NonDiscRate=sum((RA_Initial+RA_Interest_Accrete+RA_Release+RA_GainLoss_NonDiscRate)*Id.Bel_Beginning_Portion),
	 @RA_GainLoss_DiscRate=sum(RA_GainLoss_DiscRate*Id.Bel_Beginning_Portion),
	 @CSM_End=sum((CSM_Initial+CSM_Interest_Accrete+CSM_Amortization+CSM_GainLoss_NonDiscRate+CSM_Adjustment)*Id.Bel_Beginning_Portion),
	 @PAA_End=sum((PAA_Premium_Expected+PAA_Commission_Expected+PAA_Interest_Accrete+PAA_Amortization)*Id.Net_Premium_Expected_Portion),
	 @Loss_End=sum((Loss_Initial+Loss_Portion_from_Claim_Release+Loss_Portion_from_Expense_Release+Loss_Portion_from_Cost_Release+Loss_Portion_from_Others_Release+Loss_Portion_from_Refund_Release+Loss_Portion_from_RA_Release+Loss_Portion_from_Interest_Accrete+Loss_Portion_from_GainLoss_DiscRate+Loss_GainLoss_NonDiscRate+Loss_Adjustment)*Id.Bel_Beginning_Portion),
	 @ACQ_Cost=sum((ACQ_Cost+ACQ_Amortization)*Id.Commission_Actual_Portion)
	 from @IFRS_Detail Id
	 Inner Join IFRS_Movement I on (I.GroupID=Id.GroupID and I.GroupType=Id.GroupType and I.EffMonth=Id.EffMonth and I.EffYear=Id.EffYear)
	 Where I.ProcessDate<=@PProcessDate 
	 
	 if @BEL_Ending_After_Change_NonDiscRate is null
		Select @BEL_Ending_After_Change_NonDiscRate=0
	 if @BEL_GainLoss_DiscRate is null
		Select @BEL_GainLoss_DiscRate=0
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
 BEL_Beginning=@BEL_Ending_After_Change_NonDiscRate+sum(BEL_Initial*Id.Bel_Beginning_Portion),
 BEL_Premium_Expected=sum(BEL_Premium_Expected*Id.Bel_Beginning_Portion),
 BEL_Commission_Expected=sum(BEL_Commission_Expected*Id.Bel_Beginning_Portion),
 BEL_Interest_Accrete=sum(BEL_Interest_Accrete*Id.Bel_Beginning_Portion),
 BEL_Claim_Expected=sum(BEL_Claim_Expected*Id.Bel_Beginning_Portion),
 BEL_Claim_NPR_Expected=sum(BEL_Claim_NPR_Expected*Id.Bel_Beginning_Portion),
 BEL_Expense_Expected=sum(BEL_Expense_Expected*Id.Bel_Beginning_Portion),
 BEL_Cost_Expected=sum(BEL_Cost_Expected*Id.Bel_Beginning_Portion),
 BEL_Others_Expected=sum(BEL_Others_Expected*Id.Bel_Beginning_Portion),
 BEL_Refund_Expected=sum(BEL_Refund_Expected*Id.Bel_Beginning_Portion),

 BEL_Ending_Before_Change=@BEL_Ending_After_Change_NonDiscRate+sum((BEL_Initial+BEL_Premium_Expected+BEL_Commission_Expected+BEL_Interest_Accrete+BEL_Claim_Expected+BEL_Claim_NPR_Expected+BEL_Expense_Expected+BEL_Cost_Expected+BEL_Others_Expected+BEL_Refund_Expected)*Id.Bel_Beginning_Portion),
 BEL_Ending_After_Change_NonDiscRate=@BEL_Ending_After_Change_NonDiscRate+sum((BEL_Initial+BEL_Premium_Expected+BEL_Commission_Expected+BEL_Interest_Accrete+BEL_Claim_Expected+BEL_Claim_NPR_Expected+BEL_Expense_Expected+BEL_Cost_Expected+BEL_Others_Expected+BEL_Refund_Expected+BEL_GainLoss_NonDiscRate)*Id.Bel_Beginning_Portion),
 BEL_Ending_After_Change_DiscRate=@BEL_Ending_After_Change_NonDiscRate+@BEL_GainLoss_DiscRate+sum((BEL_Initial+BEL_Premium_Expected+BEL_Commission_Expected+BEL_Interest_Accrete+BEL_Claim_Expected+BEL_Claim_NPR_Expected+BEL_Expense_Expected+BEL_Cost_Expected+BEL_Others_Expected+BEL_Refund_Expected+BEL_GainLoss_NonDiscRate+BEL_GainLoss_DiscRate)*Id.Bel_Beginning_Portion),

 BEL_GainLoss_NonDiscRate=sum(BEL_GainLoss_NonDiscRate*Id.Bel_Beginning_Portion),
 BEL_GainLoss_DiscRate=@BEL_GainLoss_DiscRate+sum(BEL_GainLoss_DiscRate*Id.Bel_Beginning_Portion),

 RA_Beginning=@RA_Ending_After_Change_NonDiscRate+sum(RA_Initial*Id.Bel_Beginning_Portion),
 RA_Interest_Accrete=sum(RA_Interest_Accrete*Id.Bel_Beginning_Portion),
 RA_Release=sum(RA_Release*Id.Bel_Beginning_Portion),

 RA_Ending_Before_Change=@RA_Ending_After_Change_NonDiscRate+sum((RA_Initial+RA_Interest_Accrete+RA_Release)*Id.Bel_Beginning_Portion),

 RA_Ending_After_Change_NonDiscRate=@RA_Ending_After_Change_NonDiscRate+sum((RA_Initial+RA_Interest_Accrete+RA_Release+RA_GainLoss_NonDiscRate)*Id.Bel_Beginning_Portion),
 RA_Ending_After_Change_DiscRate=@RA_Ending_After_Change_NonDiscRate+@RA_GainLoss_DiscRate+sum((RA_Initial+RA_Interest_Accrete+RA_Release+RA_GainLoss_NonDiscRate+RA_GainLoss_DiscRate)*Id.Bel_Beginning_Portion),

 RA_GainLoss_NonDiscRate=sum(RA_GainLoss_NonDiscRate*Id.Bel_Beginning_Portion),
 RA_GainLoss_DiscRate=@RA_GainLoss_DiscRate+sum(RA_GainLoss_DiscRate*Id.Bel_Beginning_Portion),

 CSM_Start=@CSM_End+sum(CSM_Initial*Id.Bel_Beginning_Portion),
 CSM_Interest_Accrete=sum(CSM_Interest_Accrete*Id.Bel_Beginning_Portion),
 CSM_Amortization=sum(CSM_Amortization*Id.Bel_Beginning_Portion),
 CSM_GainLoss_NonDiscRate=sum(CSM_GainLoss_NonDiscRate*Id.Bel_Beginning_Portion),
 CSM_Adjustment=sum(CSM_Adjustment*Id.Bel_Beginning_Portion),
 CSM_End=@CSM_End+sum((CSM_Initial+CSM_Interest_Accrete+CSM_Amortization+CSM_GainLoss_NonDiscRate+CSM_Adjustment)*Id.Bel_Beginning_Portion),

 PAA_Start=@PAA_End+sum((PAA_Premium_Expected+PAA_Commission_Expected)*Id.Net_Premium_Expected_Portion),
 PAA_Interest_Accrete=sum(PAA_Interest_Accrete*Id.Net_Premium_Expected_Portion),
 PAA_Amortization=sum(PAA_Amortization*Id.Net_Premium_Expected_Portion),
 PAA_End=@PAA_End+sum((PAA_Premium_Expected+PAA_Commission_Expected+PAA_Interest_Accrete+PAA_Amortization)*Id.Net_Premium_Expected_Portion),

 Loss_Start=@Loss_End+sum(LOSS_Initial*Id.Bel_Beginning_Portion),
 Loss_Portion_from_Claim_Release=sum(Loss_Portion_from_Claim_Release*Id.Bel_Beginning_Portion),
 Loss_Portion_from_Expense_Release=sum(Loss_Portion_from_Expense_Release*Id.Bel_Beginning_Portion),
 Loss_Portion_from_Cost_Release=sum(Loss_Portion_from_Cost_Release*Id.Bel_Beginning_Portion),
 Loss_Portion_from_Others_Release=sum(Loss_Portion_from_Others_Release*Id.Bel_Beginning_Portion),
 Loss_Portion_from_Refund_Release=sum(Loss_Portion_from_Refund_Release*Id.Bel_Beginning_Portion),
 Loss_Portion_from_RA_Release=sum(Loss_Portion_from_RA_Release*Id.Bel_Beginning_Portion),
 Loss_Portion_from_Interest_Accrete=sum(Loss_Portion_from_Interest_Accrete*Id.Bel_Beginning_Portion),
 Loss_Portion_from_GainLoss_DiscRate=sum(Loss_Portion_from_GainLoss_DiscRate*Id.Bel_Beginning_Portion),
 Loss_GainLoss_NonDiscRate=sum(Loss_GainLoss_NonDiscRate*Id.Bel_Beginning_Portion),
 LOSS_Adjustment=sum(Loss_Adjustment*Id.Bel_Beginning_Portion),
 Loss_End=@Loss_End+sum((Loss_Initial+Loss_Portion_from_Claim_Release+Loss_Portion_from_Expense_Release+Loss_Portion_from_Cost_Release+Loss_Portion_from_Others_Release+Loss_Portion_from_Refund_Release+Loss_Portion_from_RA_Release+Loss_Portion_from_Interest_Accrete+Loss_Portion_from_GainLoss_DiscRate+Loss_GainLoss_NonDiscRate+Loss_Adjustment)*Id.Bel_Beginning_Portion),
 ACQ_Amortization=sum(ACQ_Amortization*Id.Commission_Actual_Portion),
 ACQ_Cost=@ACQ_Cost+sum(ACQ_Cost*Id.Commission_Actual_Portion)
from @IFRS_Detail Id
Inner Join IFRS_Movement I on (I.GroupID=Id.GroupID and I.GroupType=Id.GroupType and I.EffMonth=Id.EffMonth and I.EffYear=Id.EffYear)
Where I.ProcessDate<=@ProcessDate and I.ProcessDate>@PProcessDate

Select 'BEL_Beginning'as Description,  BEL_Beginning as Nominal from @IFRS Union All
Select 'BEL_Premium_Expected'as Description,  BEL_Premium_Expected as Nominal from @IFRS Union All
Select 'BEL_Commission_Expected'as Description,  BEL_Commission_Expected as Nominal from @IFRS Union All
Select 'BEL_Interest_Accrete'as Description,  BEL_Interest_Accrete as Nominal from @IFRS Union All
Select 'BEL_Claim_Expected'as Description,  BEL_Claim_Expected as Nominal from @IFRS Union All
Select 'BEL_Claim_NPR_Expected'as Description,  BEL_Claim_NPR_Expected as Nominal from @IFRS Where @GroupType='R' Union All
Select 'BEL_Expense_Expected'as Description,  BEL_Expense_Expected as Nominal from @IFRS Union All
Select 'BEL_Cost_Expected'as Description,  BEL_Cost_Expected as Nominal from @IFRS Where @GroupType<>'R' Union All 
Select 'BEL_Others_Expected'as Description,  BEL_Others_Expected as Nominal from @IFRS Where @GroupType<>'R' Union All 
Select 'BEL_Refund_Expected'as Description,  BEL_Refund_Expected as Nominal from @IFRS Union All
Select 'BEL_Ending_Before_Change'as Description,  BEL_Ending_Before_Change as Nominal from @IFRS Union All
Select 'BEL_GainLoss_NonDiscRate'as Description,  BEL_GainLoss_NonDiscRate as Nominal from @IFRS Union All
Select 'BEL_Ending_After_Change_NonDiscRate'as Description,  BEL_Ending_After_Change_NonDiscRate as Nominal from @IFRS Union All
Select 'BEL_GainLoss_DiscRate'as Description,  BEL_GainLoss_DiscRate as Nominal from @IFRS Union All
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
Select 'PAA_Amount_Recognized_As_Revenue'as Description,  PAA_Amortization as Nominal from @IFRS Where @Method='P' Union All
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
go

 insert into PatchVersioning
select '913 Update Script - IFRS Patch #38',GETDATE()
go


