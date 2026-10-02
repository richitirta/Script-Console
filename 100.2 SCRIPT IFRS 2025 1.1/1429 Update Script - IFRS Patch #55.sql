
SET QUOTED_IDENTIFIER ON
SET ARITHABORT ON
SET NUMERIC_ROUNDABORT OFF
SET CONCAT_NULL_YIELDS_NULL ON
SET ANSI_NULLS ON
SET ANSI_PADDING ON
SET ANSI_WARNINGS ON

IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'BEL_GainLoss_NPR' AND Object_ID = Object_ID(N'dbo.IFRS_Movement'))
BEGIN
ALTER TABLE dbo.IFRS_Movement ADD
	BEL_GainLoss_NPR float(53) NULL
end
GO

IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'BEL_GainLoss_NPR' AND Object_ID = Object_ID(N'dbo.IFRS_Initial_Detail_BEL'))
BEGIN
ALTER TABLE dbo.IFRS_Initial_Detail_BEL ADD
	BEL_GainLoss_NPR float(53) NULL
end
GO

IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'BEL_GainLoss_NPR' AND Object_ID = Object_ID(N'dbo.IFRS_Calculation_Detail_BEL'))
BEGIN
ALTER TABLE dbo.IFRS_Calculation_Detail_BEL ADD
	BEL_GainLoss_NPR float(53) NULL
end
GO


IF EXISTS ( SELECT * FROM   sysobjects WHERE  id = object_id(N'IFRS_SHOW_INITIAL') and OBJECTPROPERTY(id, N'IsProcedure') = 1 )
BEGIN DROP PROCEDURE IFRS_SHOW_INITIAL END
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
 BEL_NDIC_Expected Float,      
 BEL_Refund_Expected Float,      
 BEL_Ending_Before_Change Float,      
 BEL_Ending_After_Change_NonDiscRate Float,      
 BEL_Ending_After_Change_NPR Float,      
 BEL_Ending_After_Change_DiscRate Float,      
 BEL_GainLoss_NonDiscRate Float,      
 BEL_GainLoss_NPR Float,
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
 Loss_Portion_from_NDIC_Release Float,      
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
      
      
Declare @IFRS_Detail Table(GroupID int, GroupType varchar(1), EffMonth Int, EffYear Int, Month Int, Year Int, Method varchar(1), Bel_Beginning Float, Total_Bel_Beginning Float, Premium_Expected Float, Total_Premium_Expected Float, Commission_Expected Float, Total_Commission_Expected Float, Net_Premium_Expected Float, Total_Net_Premium_Expected Float, Commission_Actual Float, Total_Commission_Actual Float, Bel_Beginning_Portion Float, Premium_Expected_Portion Float, Commission_Expected_Portion Float, Net_Premium_Expected_Portion Float, Commission_Actual_Portion Float)      
      
insert into @IFRS_Detail      
Select       
I2.GroupID, I2.GroupType, I2.EffMonth, I2.EffYear,       
max(I.Month) as Month,       
max(I.Year) as Year,      
Max(I1.Method) as Method,      
Sum(I3b.BEL_Beginning) as BEL_Beginning,      
Max(I2b.BEL_Beginning) as Total_BEL_Beginning,      
Sum(I3.Premium_Expected) as Premium_Expected,      
Max(I2.Premium_Expected) as Total_Premium_Expected,      
Sum(I3.Commission_Expected) as Commission_Expected,      
Max(I2.Commission_Expected) as Total_Commission_Expected,      
Sum(I3.Premium_Expected+I3.Commission_Expected) as Net_Premium_Expected,      
Max(I2.Premium_Expected+I2.Commission_Expected) as Total_Net_Premium_Expected,      
Sum(I3.Commission_Actual_BC) as Commission_Actual,      
Max(I2.Commission_Actual_BC) as Total_Commission_Actual,      
Cast(0 as Float) as Bel_Beginning_Portion,       
cast(0 as Float) as Premium_Expected_Portion,       
cast(0 as Float) as Commission_Expected_Portion,       
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
  
Select * from ifrs_initial_detail_bel      
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
Declare @BEL_GainLoss_NPR as Float
Declare @BEL_GainLoss_DiscRate as Float      
Declare @RA_GainLoss_DiscRate as Float      
Declare @ACQ_Cost as Float      
      
if @Cumulative=1       
Begin      
 Select @PProcessDate='01/01/1901'      
 Select @BEL_Ending_After_Change_NonDiscRate=0       
 Select @BEL_GainLoss_NPR=0      
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
  @BEL_Ending_After_Change_NonDiscRate=sum((BEL_Initial+BEL_Premium_Expected+BEL_Commission_Expected+BEL_Interest_Accrete+BEL_Claim_Expected+BEL_Claim_NPR_Expected+BEL_Expense_Expected+BEL_Cost_Expected+BEL_Others_Expected+BEL_NDIC_Expected+BEL_Refund_Expected+BEL_GainLoss_NonDiscRate)*Id.Bel_Beginning_Portion),        
  @BEL_GainLoss_NPR=sum(BEL_GainLoss_NPR*Id.Bel_Beginning_Portion),      
  @BEL_GainLoss_DiscRate=sum(BEL_GainLoss_DiscRate*Id.Bel_Beginning_Portion),      
  @RA_Ending_After_Change_NonDiscRate=sum((RA_Initial+RA_Interest_Accrete+RA_Release+RA_GainLoss_NonDiscRate)*Id.Bel_Beginning_Portion),      
  @RA_GainLoss_DiscRate=sum(RA_GainLoss_DiscRate*Id.Bel_Beginning_Portion),      
  @CSM_End=sum((CSM_Initial+CSM_Interest_Accrete+CSM_Amortization+CSM_GainLoss_NonDiscRate+CSM_Adjustment)*Id.Bel_Beginning_Portion),      
  @PAA_End=sum((PAA_Premium_Expected+PAA_Commission_Expected+PAA_Interest_Accrete+PAA_Amortization)*Id.Net_Premium_Expected_Portion),      
  @Loss_End=sum((Loss_Initial+Loss_Portion_from_Claim_Release+Loss_Portion_from_Expense_Release+Loss_Portion_from_Cost_Release+Loss_Portion_from_Others_Release+Loss_Portion_from_NDIC_Release+Loss_Portion_from_Refund_Release+Loss_Portion_from_RA_Release+Loss_Portion_from_Interest_Accrete+Loss_Portion_from_GainLoss_DiscRate+Loss_GainLoss_NonDiscRate+Loss_Adjustment)*Id.Bel_Beginning_Portion),      
  @ACQ_Cost=sum((ACQ_Cost+ACQ_Amortization)*Id.Commission_Actual_Portion)      
  from @IFRS_Detail Id      
  Inner Join IFRS_Movement I on (I.GroupID=Id.GroupID and I.GroupType=Id.GroupType and I.EffMonth=Id.EffMonth and I.EffYear=Id.EffYear)      
  Where I.ProcessDate<=@PProcessDate       
        
  if @BEL_Ending_After_Change_NonDiscRate is null      
  Select @BEL_Ending_After_Change_NonDiscRate=0      
  if @BEL_GainLoss_NPR is null      
  Select @BEL_GainLoss_NPR=0      
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
 BEL_NDIC_Expected=sum(BEL_NDIC_Expected*Id.Bel_Beginning_Portion),      
 BEL_Refund_Expected=sum(BEL_Refund_Expected*Id.Bel_Beginning_Portion),      
      
 BEL_Ending_Before_Change=@BEL_Ending_After_Change_NonDiscRate+sum((BEL_Initial+BEL_Premium_Expected+BEL_Commission_Expected+BEL_Interest_Accrete+BEL_Claim_Expected+BEL_Claim_NPR_Expected+BEL_Expense_Expected+BEL_Cost_Expected+BEL_Others_Expected+BEL_NDIC_Expected+BEL_Refund_Expected)*Id.Bel_Beginning_Portion),      
 BEL_Ending_After_Change_NonDiscRate=@BEL_Ending_After_Change_NonDiscRate+sum((BEL_Initial+BEL_Premium_Expected+BEL_Commission_Expected+BEL_Interest_Accrete+BEL_Claim_Expected+BEL_Claim_NPR_Expected+BEL_Expense_Expected+BEL_Cost_Expected+BEL_Others_Expected+BEL_NDIC_Expected+BEL_Refund_Expected+BEL_GainLoss_NonDiscRate)*Id.Bel_Beginning_Portion),      
 BEL_Ending_After_Change_NPR=@BEL_Ending_After_Change_NonDiscRate+@BEL_GainLoss_NPR+sum((BEL_Initial+BEL_Premium_Expected+BEL_Commission_Expected+BEL_Interest_Accrete+BEL_Claim_Expected+BEL_Claim_NPR_Expected+BEL_Expense_Expected+BEL_Cost_Expected+BEL_Others_Expected+BEL_NDIC_Expected+BEL_Refund_Expected+BEL_GainLoss_NonDiscRate+BEL_GainLoss_NPR)*Id.Bel_Beginning_Portion),      
 BEL_Ending_After_Change_DiscRate=@BEL_Ending_After_Change_NonDiscRate+@BEL_GainLoss_NPR+@BEL_GainLoss_DiscRate+sum((BEL_Initial+BEL_Premium_Expected+BEL_Commission_Expected+BEL_Interest_Accrete+BEL_Claim_Expected+BEL_Claim_NPR_Expected+BEL_Expense_Expected+BEL_Cost_Expected+BEL_Others_Expected+BEL_NDIC_Expected+BEL_Refund_Expected+BEL_GainLoss_NonDiscRate+BEL_GainLoss_NPR+BEL_GainLoss_DiscRate)*Id.Bel_Beginning_Portion),      
      
 BEL_GainLoss_NonDiscRate=sum(BEL_GainLoss_NonDiscRate*Id.Bel_Beginning_Portion),      
 BEL_GainLoss_NPR=@BEL_GainLoss_NPR+sum(BEL_GainLoss_NPR*Id.Bel_Beginning_Portion),
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
 Loss_Portion_from_NDIC_Release=sum(Loss_Portion_from_NDIC_Release*Id.Bel_Beginning_Portion),      
 Loss_Portion_from_Refund_Release=sum(Loss_Portion_from_Refund_Release*Id.Bel_Beginning_Portion),      
 Loss_Portion_from_RA_Release=sum(Loss_Portion_from_RA_Release*Id.Bel_Beginning_Portion),      
 Loss_Portion_from_Interest_Accrete=sum(Loss_Portion_from_Interest_Accrete*Id.Bel_Beginning_Portion),      
 Loss_Portion_from_GainLoss_DiscRate=sum(Loss_Portion_from_GainLoss_DiscRate*Id.Bel_Beginning_Portion),      
 Loss_GainLoss_NonDiscRate=sum(Loss_GainLoss_NonDiscRate*Id.Bel_Beginning_Portion),      
 LOSS_Adjustment=sum(Loss_Adjustment*Id.Bel_Beginning_Portion),      
 Loss_End=@Loss_End+sum((Loss_Initial+Loss_Portion_from_Claim_Release+Loss_Portion_from_Expense_Release+Loss_Portion_from_Cost_Release+Loss_Portion_from_Others_Release+Loss_Portion_from_NDIC_Release+Loss_Portion_from_Refund_Release+Loss_Portion_from_RA_Release+Loss_Portion_from_Interest_Accrete+Loss_Portion_from_GainLoss_DiscRate+Loss_GainLoss_NonDiscRate+Loss_Adjustment)*Id.Bel_Beginning_Portion),      
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
Select 'BEL_NDIC_Expected'as Description,  BEL_NDIC_Expected as Nominal from @IFRS Where @GroupType<>'R' Union All       
Select 'BEL_Refund_Expected'as Description,  BEL_Refund_Expected as Nominal from @IFRS Union All      
Select 'BEL_Ending_Before_Change'as Description,  BEL_Ending_Before_Change as Nominal from @IFRS Union All      
Select 'BEL_GainLoss_NonDiscRate'as Description,  BEL_GainLoss_NonDiscRate as Nominal from @IFRS Union All      
Select 'BEL_Ending_After_Change_NonDiscRate'as Description,  BEL_Ending_After_Change_NonDiscRate as Nominal from @IFRS Union All      
Select 'BEL_GainLoss_NPR' as Description, BEL_GainLoss_NPR as Nominal from @IFRS Union all
Select 'BEL_Ending_After_Change_NPR' as Description, BEL_Ending_After_Change_NPR as Nominal from @IFRS Union all
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
Select 'Loss_Portion_from_NDIC_Release'as Description,  Loss_Portion_from_NDIC_Release as Nominal from @IFRS Where @GroupType='I' Union All      
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
 BEL_Claim_NPR_Expected Float,    
 BEL_Expense_Expected Float,    
 BEL_Cost_Expected Float,    
 BEL_Others_Expected Float,    
 BEL_NDIC_Expected Float,    
 BEL_Refund_Expected Float,    
 BEL_Ending_Before_Change Float,    
 BEL_Ending_After_Change_NonDiscRate Float, 
 BEL_Ending_After_Change_NPR Float,
 BEL_Ending_After_Change_DiscRate Float,    
 BEL_GainLoss_NonDiscRate Float,    
 BEL_GainLoss_NPR Float,
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
 Loss_Portion_from_NDIC_Release Float,    
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
Declare @BEL_GainLoss_NPR as Float
Declare @BEL_GainLoss_DiscRate as Float    
Declare @RA_GainLoss_DiscRate as Float    
Declare @ACQ_Cost as Float    
    
if @Cumulative=1     
Begin    
 Select @PProcessDate='01/01/1901'    
 Select @BEL_Ending_After_Change_NonDiscRate=0    
 Select @BEL_GainLoss_NPR=0
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
  @BEL_Ending_After_Change_NonDiscRate=sum(BEL_Initial+BEL_Premium_Expected+BEL_Commission_Expected+BEL_Interest_Accrete+BEL_Claim_Expected+BEL_Claim_NPR_Expected+BEL_Expense_Expected+BEL_Cost_Expected+BEL_Others_Expected+BEL_NDIC_Expected+BEL_Refund_Expected+BEL_GainLoss_NonDiscRate),    
  @BEL_GainLoss_NPR=sum(BEL_GainLoss_NPR),
  @BEL_GainLoss_DiscRate=sum(BEL_GainLoss_DiscRate),    
  @RA_Ending_After_Change_NonDiscRate=sum(RA_Initial+RA_Interest_Accrete+RA_Release+RA_GainLoss_NonDiscRate),    
  @RA_GainLoss_DiscRate=sum(RA_GainLoss_DiscRate),    
  @CSM_End=sum(CSM_Initial+CSM_Interest_Accrete+CSM_Amortization+CSM_GainLoss_NonDiscRate+CSM_Adjustment),    
  @PAA_End=sum(PAA_Premium_Expected+PAA_Commission_Expected+PAA_Interest_Accrete+PAA_Amortization),    
  @Loss_End=sum(Loss_Initial+Loss_Portion_from_Claim_Release+Loss_Portion_from_Expense_Release+Loss_Portion_from_Cost_Release+Loss_Portion_from_Others_Release+Loss_Portion_from_NDIC_Release+Loss_Portion_from_Refund_Release+Loss_Portion_from_RA_Release+Loss_Portion_from_Interest_Accrete+Loss_Portion_from_GainLoss_DiscRate+Loss_GainLoss_NonDiscRate+Loss_Adjustment),    
  @ACQ_Cost=sum(ACQ_Cost+ACQ_Amortization)    
  from IFRS_Movement I    
  Where I.GroupID=@GroupID and I.GroupType=@GroupType and I.ProcessDate<=@PProcessDate     
      
  if @BEL_Ending_After_Change_NonDiscRate is null    
  Select @BEL_Ending_After_Change_NonDiscRate=0    
  if @BEL_GainLoss_NPR is null
  Select @BEL_GainLoss_NPR=0
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
 BEL_Beginning=@BEL_Ending_After_Change_NonDiscRate+sum(BEL_Initial),    
 BEL_Premium_Expected=sum(BEL_Premium_Expected),    
 BEL_Commission_Expected=sum(BEL_Commission_Expected),    
 BEL_Interest_Accrete=sum(BEL_Interest_Accrete),    
 BEL_Claim_Expected=sum(BEL_Claim_Expected),    
 BEL_Claim_NPR_Expected=sum(BEL_Claim_NPR_Expected),    
 BEL_Expense_Expected=sum(BEL_Expense_Expected),    
 BEL_Cost_Expected=sum(BEL_Cost_Expected),    
 BEL_Others_Expected=sum(BEL_Others_Expected),    
 BEL_NDIC_Expected=sum(BEL_NDIC_Expected),    
 BEL_Refund_Expected=sum(BEL_Refund_Expected),    
    
 BEL_Ending_Before_Change=@BEL_Ending_After_Change_NonDiscRate+sum(BEL_Initial+BEL_Premium_Expected+BEL_Commission_Expected+BEL_Interest_Accrete+BEL_Claim_Expected+BEL_Claim_NPR_Expected+BEL_Expense_Expected+BEL_Cost_Expected+BEL_Others_Expected+BEL_NDIC_Expected+BEL_Refund_Expected),    
    
 BEL_Ending_After_Change_NonDiscRate=@BEL_Ending_After_Change_NonDiscRate+sum(BEL_Initial+BEL_Premium_Expected+BEL_Commission_Expected+BEL_Interest_Accrete+BEL_Claim_Expected+BEL_Claim_NPR_Expected+BEL_Expense_Expected+BEL_Cost_Expected+BEL_Others_Expected+BEL_NDIC_Expected+BEL_Refund_Expected+BEL_GainLoss_NonDiscRate),    
 BEL_Ending_After_Change_NPR=@BEL_Ending_After_Change_NonDiscRate+@BEL_GainLoss_NPR+sum(BEL_Initial+BEL_Premium_Expected+BEL_Commission_Expected+BEL_Interest_Accrete+BEL_Claim_Expected+BEL_Claim_NPR_Expected+BEL_Expense_Expected+BEL_Cost_Expected+BEL_Others_Expected+BEL_NDIC_Expected+BEL_Refund_Expected+BEL_GainLoss_NonDiscRate+BEL_GainLoss_NPR),    
 BEL_Ending_After_Change_DiscRate=@BEL_Ending_After_Change_NonDiscRate+@BEL_GainLoss_NPR+@BEL_GainLoss_DiscRate+sum(BEL_Initial+BEL_Premium_Expected+BEL_Commission_Expected+BEL_Interest_Accrete+BEL_Claim_Expected+BEL_Claim_NPR_Expected+BEL_Expense_Expected+BEL_Cost_Expected+BEL_Others_Expected+BEL_NDIC_Expected+BEL_Refund_Expected+BEL_GainLoss_NonDiscRate+BEL_GainLoss_NPR+BEL_GainLoss_DiscRate),    
    
 BEL_GainLoss_NonDiscRate=sum(BEL_GainLoss_NonDiscRate),    
 BEL_GainLoss_NPR=@BEL_GainLoss_NPR+sum(BEL_GainLoss_NPR),
 BEL_GainLoss_DiscRate=@BEL_GainLoss_DiscRate+sum(BEL_GainLoss_DiscRate),    
    
 RA_Beginning=@RA_Ending_After_Change_NonDiscRate+sum(+RA_Initial),    
 RA_Interest_Accrete=sum(RA_Interest_Accrete),    
 RA_Release=sum(RA_Release),    
    
 RA_Ending_Before_Change=@RA_Ending_After_Change_NonDiscRate+sum(RA_Initial+RA_Interest_Accrete+RA_Release),    
    
 RA_Ending_After_Change_NonDiscRate=@RA_Ending_After_Change_NonDiscRate+sum(RA_Initial+RA_Interest_Accrete+RA_Release+RA_GainLoss_NonDiscRate),    
 RA_Ending_After_Change_DiscRate=@RA_Ending_After_Change_NonDiscRate+@RA_GainLoss_DiscRate+sum(RA_Initial+RA_Interest_Accrete+RA_Release+RA_GainLoss_NonDiscRate+RA_GainLoss_DiscRate),    
    
 RA_GainLoss_NonDiscRate=sum(RA_GainLoss_NonDiscRate),    
 RA_GainLoss_DiscRate=@RA_GainLoss_DiscRate+sum(RA_GainLoss_DiscRate),    
    
 CSM_Start=@CSM_End+sum(CSM_Initial),    
 CSM_Interest_Accrete=sum(CSM_Interest_Accrete),    
 CSM_Amortization=sum(CSM_Amortization),    
 CSM_GainLoss_NonDiscRate=sum(CSM_GainLoss_NonDiscRate),    
 CSM_Adjustment=sum(CSM_Adjustment),    
 CSM_End=@CSM_End+sum(CSM_Initial+CSM_Interest_Accrete+CSM_Amortization+CSM_GainLoss_NonDiscRate+CSM_Adjustment),    
    
 PAA_Start=@PAA_End+sum(PAA_Premium_Expected+PAA_Commission_Expected),    
 PAA_Interest_Accrete=sum(PAA_Interest_Accrete),    
 PAA_Amortization=sum(PAA_Amortization),    
 PAA_End=@PAA_End+sum(PAA_Premium_Expected+PAA_Commission_Expected+PAA_Interest_Accrete+PAA_Amortization),    
    
 Loss_Start=@Loss_End+sum(LOSS_Initial),    
 Loss_Portion_from_Claim_Release=sum(Loss_Portion_from_Claim_Release),    
 Loss_Portion_from_Expense_Release=sum(Loss_Portion_from_Expense_Release),    
 Loss_Portion_from_Cost_Release=sum(Loss_Portion_from_Cost_Release),    
 Loss_Portion_from_Others_Release=sum(Loss_Portion_from_Others_Release),    
 Loss_Portion_from_NDIC_Release=sum(Loss_Portion_from_NDIC_Release),    
 Loss_Portion_from_Refund_Release=sum(Loss_Portion_from_Refund_Release),    
 Loss_Portion_from_RA_Release=sum(Loss_Portion_from_RA_Release),    
 Loss_Portion_from_Interest_Accrete=sum(Loss_Portion_from_Interest_Accrete),    
 Loss_Portion_from_GainLoss_DiscRate=sum(Loss_Portion_from_GainLoss_DiscRate),    
 Loss_GainLoss_NonDiscRate=sum(Loss_GainLoss_NonDiscRate),    
 LOSS_Adjustment=sum(Loss_Adjustment),    
 Loss_End=@Loss_End+sum(Loss_Initial+Loss_Portion_from_Claim_Release+Loss_Portion_from_Expense_Release+Loss_Portion_from_Cost_Release+Loss_Portion_from_Others_Release+Loss_Portion_from_NDIC_Release+Loss_Portion_from_Refund_Release+Loss_Portion_from_RA_Release+Loss_Portion_from_Interest_Accrete+Loss_Portion_from_GainLoss_DiscRate+Loss_GainLoss_NonDiscRate+Loss_Adjustment),    
 ACQ_Amortization=sum(ACQ_Amortization),    
 ACQ_Cost=@ACQ_Cost+sum(ACQ_Cost)    
from IFRS_Movement I    
Where I.GroupID=@GroupID and I.GroupType=@GroupType and I.ProcessDate<=@ProcessDate and I.ProcessDate>@PProcessDate    
    
Select 'BEL_Beginning'as Description,  BEL_Beginning as Nominal from @IFRS Union All    
Select 'BEL_Premium_Expected'as Description,  BEL_Premium_Expected as Nominal from @IFRS Union All    
Select 'BEL_Commission_Expected'as Description,  BEL_Commission_Expected as Nominal from @IFRS Union All    
Select 'BEL_Interest_Accrete'as Description,  BEL_Interest_Accrete as Nominal from @IFRS Union All    
Select 'BEL_Claim_Expected'as Description,  BEL_Claim_Expected as Nominal from @IFRS Union All    
Select 'BEL_Claim_NPR_Expected'as Description,  BEL_Claim_NPR_Expected as Nominal from @IFRS Where @GroupType='R' Union All    
Select 'BEL_Expense_Expected'as Description,  BEL_Expense_Expected as Nominal from @IFRS Union All    
Select 'BEL_Cost_Expected'as Description,  BEL_Cost_Expected as Nominal from @IFRS Where @GroupType<>'R' Union All     
Select 'BEL_Others_Expected'as Description,  BEL_Others_Expected as Nominal from @IFRS Where @GroupType<>'R' Union All     
Select 'BEL_NDIC_Expected'as Description,  BEL_NDIC_Expected as Nominal from @IFRS Where @GroupType<>'R' Union All     
Select 'BEL_Refund_Expected'as Description,  BEL_Refund_Expected as Nominal from @IFRS Union All    
Select 'BEL_Ending_Before_Change'as Description,  BEL_Ending_Before_Change as Nominal from @IFRS Union All    
Select 'BEL_GainLoss_NonDiscRate'as Description,  BEL_GainLoss_NonDiscRate as Nominal from @IFRS Union All    
Select 'BEL_Ending_After_Change_NonDiscRate'as Description,  BEL_Ending_After_Change_NonDiscRate as Nominal from @IFRS Union All    
Select 'BEL_GainLoss_NPR' as Description, BEL_GainLoss_NPR as Nominal from @IFRS union All
Select 'BEL_Ending_After_Change_NPR'as Description,  BEL_Ending_After_Change_NPR as Nominal from @IFRS Union All    
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
Select 'Loss_Portion_from_NDIC_Release'as Description,  Loss_Portion_from_NDIC_Release as Nominal from @IFRS Where @GroupType='I' Union All    
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

insert into PatchVersioning
select '1429 Update Script - IFRS Patch #55',GETDATE()
go	
  
Declare @PrevScript varchar(100)
Declare @CurrScript varchar(100)

Select @PrevScript=''
Select @CurrScript='1429 Update Script - IFRS Patch #55'


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

GO