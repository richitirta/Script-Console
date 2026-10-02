
if exists (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'IFRS_Disclosure') AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) )
BEGIN 
DROP Function IFRS_Disclosure
end
GO
CREATE Function IFRS_Disclosure(@P_SDate as Smalldatetime, @P_Edate as smalldatetime, @P_Method as varchar(1), @P_GroupType varchar(1), @P_Branch varchar(10), @P_COB varchar(10), @P_TOC varchar(10), @P_CGroup varchar(10), @P_ISType varchar(1), @P_Currency varchar(10), @P_Year Int, @P_Month Int)                  
RETURNS 
 @IFRS table (    
 GroupID Int, 
 GroupType varchar(1), 
 EffMonth Int, 
 EffYear Int,
 NumMonths Int,
 BEL_Beginning Float,    
 BEL_Beginning_OC Float,    
 BEL_Initial Float,    
 BEL_Premium_Expected Float,    
 BEL_Commission_Expected Float,    
 BEL_Interest_Accrete Float,    
 BEL_Claim_Expected Float,    
 BEL_Claim_NPR_Expected Float,    
 BEL_Expense_Expected Float,    
 BEL_Cost_Expected Float,    
 BEL_Others_Expected Float,    
 BEL_Refund_Expected Float,    
 BEL_GainLoss_NonDiscRate Float,    
 BEL_GainLoss_ExchangeRate Float,
 BEL_Ending Float,    
 BEL_Ending_OC Float,    
 BEL_GainLoss_DiscRate Float,    
 RA_Beginning Float,    
 RA_Beginning_OC Float,    
 RA_Initial Float,    
 RA_Interest_Accrete Float,    
 RA_Release Float,    
 RA_GainLoss_NonDiscRate Float,    
 RA_GainLoss_ExchangeRate Float,
 RA_Ending Float,     
 RA_Ending_OC Float,     
 RA_GainLoss_DiscRate Float,    
 CSM_Start Float,    
 CSM_Start_OC Float,    
 CSM_Initial Float,    
 CSM_Interest_Accrete Float,    
 CSM_Amortization Float,    
 CSM_GainLoss_NonDiscRate Float,    
 CSM_Adjustment Float,
 CSM_GainLoss_ExchangeRate Float,
 CSM_End Float,    
 CSM_End_OC Float,    
 PAA_Start Float,    
 PAA_Start_OC Float,    
 PAA_Premium_Expected Float,    
 PAA_Commission_Expected Float,    
 PAA_Interest_Accrete Float,    
 PAA_Amortization Float,     
 PAA_GainLoss_ExchangeRate Float,
 PAA_End Float,    
 PAA_End_OC Float,    
 Loss_Start Float,    
 Loss_Start_OC Float,    
 Loss_Initial Float,    
 Loss_Inc_Dec_IR_Non_RA Float,    
 Loss_Inc_Dec_IR_RA Float,    
 Loss_Inc_Dec_IF Float,    
 Loss_Inc_Dec_LC Float,    
 Loss_Adjustment Float,    
 Loss_End Float,    
 Loss_End_OC Float,    
 ACQ_Amortization Float
)    
AS                  
BEGIN                    

	Declare @ProcessDate as Date    
	Declare @PProcessDate as Date    
   
	Select @PProcessDate=dateadd(day,-1,@P_SDate)
	Select @ProcessDate=@P_EDate

	Declare @PCurrency Table (Currency varchar(10) Primary key, Rate Float)
	Declare @Currency Table (Currency varchar(10) Primary key, Rate Float)

	insert into @PCurrency
	Select C.Currency, case when C.VRate<>0 Then C.VRate else C.Rate End as Rate
	from fn_Exchange(@P_SDate) C

	insert into @Currency
	Select C.Currency, case when C.VRate<>0 Then C.VRate else C.Rate End as Rate
	from fn_Exchange(dateadd(day,1,@P_EDate)) C


	Declare @IFRS_BBAL table (    
	 GroupID Int, 
	 GroupType varchar(1), 
	 EffMonth Int, 
	 EffYear Int,
	 BEL_Ending_OC Float,    
	 RA_Ending_OC Float,    
	 CSM_End_OC Float,    
	 PAA_End_OC Float,    
	 Loss_End_OC Float,
	 BEL_Ending Float,    
	 RA_Ending Float,    
	 CSM_End Float,    
	 PAA_End Float,    
	 Loss_End Float
	)    


	Insert into @IFRS_BBAL
	Select     
	I.GroupID, I.GroupType, I.EffMonth, I.EffYear,
	BEL_Ending_OC= sum(Case When I1.Method='B' Then (I.BEL_Initial+I.BEL_Premium_Expected+I.BEL_Commission_Expected+I.BEL_Interest_Accrete+I.BEL_Claim_Expected+I.BEL_Claim_NPR_Expected+I.BEL_Expense_Expected+I.BEL_Cost_Expected+I.BEL_Others_Expected+I.BEL_Refund_Expected+I.BEL_GainLoss_NonDiscRate) Else 0 end),    
	RA_Ending_OC= sum(Case When I1.Method='B' Then (I.RA_Initial+I.RA_Interest_Accrete+I.RA_Release+I.RA_GainLoss_NonDiscRate) Else 0 end),    
	CSM_End_OC= sum(Case When I1.Method='B' Then (I.CSM_Initial+I.CSM_Interest_Accrete+I.CSM_Amortization+I.CSM_GainLoss_NonDiscRate+I.CSM_Adjustment) Else 0 End),    
	PAA_End_OC= sum(Case When I1.Method='P' Then (I.PAA_Premium_Expected+I.PAA_Commission_Expected+I.PAA_Interest_Accrete+I.PAA_Amortization) Else 0 end),    
	LOSS_End_OC= sum(Case When I1.Method='B' Then (I.Loss_Initial+I.Loss_Portion_from_Claim_Release+I.Loss_Portion_from_Expense_Release+I.Loss_Portion_from_Cost_Release+I.Loss_Portion_from_Others_Release+I.Loss_Portion_from_Refund_Release+I.Loss_Portion_from_RA_Release+I.Loss_Portion_from_Interest_Accrete+I.Loss_Portion_from_GainLoss_DiscRate+I.Loss_GainLoss_NonDiscRate+I.Loss_Adjustment) Else 0 End),
	BEL_Ending= sum(Case When I1.Method='B' Then (I.BEL_Initial+I.BEL_Premium_Expected+I.BEL_Commission_Expected+I.BEL_Interest_Accrete+I.BEL_Claim_Expected+I.BEL_Claim_NPR_Expected+I.BEL_Expense_Expected+I.BEL_Cost_Expected+I.BEL_Others_Expected+I.BEL_Refund_Expected+I.BEL_GainLoss_NonDiscRate)*Currency.Rate Else 0 End),    
	RA_Ending= sum(Case When I1.Method='B' Then (I.RA_Initial+I.RA_Interest_Accrete+I.RA_Release+I.RA_GainLoss_NonDiscRate)*Currency.Rate Else 0 End),    
	CSM_End= sum(Case When I1.Method='B' Then (I.CSM_initial+I.CSM_Interest_Accrete+I.CSM_Amortization+I.CSM_GainLoss_NonDiscRate+I.CSM_Adjustment)*Currency.Rate Else 0 End),    
	PAA_End= sum(Case When I1.Method='P' Then (I.PAA_Premium_Expected+I.PAA_Commission_Expected+I.PAA_Interest_Accrete+I.PAA_Amortization)*Currency.Rate Else 0 End),    
	LOSS_End= sum(Case When I1.Method='B' Then (I.Loss_Initial+I.Loss_Portion_from_Claim_Release+I.Loss_Portion_from_Expense_Release+I.Loss_Portion_from_Cost_Release+I.Loss_Portion_from_Others_Release+I.Loss_Portion_from_Refund_Release+I.Loss_Portion_from_RA_Release+I.Loss_Portion_from_Interest_Accrete+I.Loss_Portion_from_GainLoss_DiscRate+I.Loss_GainLoss_NonDiscRate+I.Loss_Adjustment)*coalesce(mVoucher.Rate,1) Else 0 End)
	from IFRS_Movement I
	Left Join Acclink on (Acclink.AccNo=I.AccNo)
	Left Join mVoucher on (mVoucher.Voucher=Acclink.Voucher)
	Inner Join IFRS_Calculation I1 on (I1.GroupID=I.GroupID)
	Inner Join IFRS_Calculation_Detail I2 on (I2.GroupID=I.GroupID and I2.GroupType=I.GroupType and I2.EffMonth=I.EffMonth and I2.EffYear=I.EffYear)
	Inner Join IFRS_Calculation_Detail_BEL I3 on (I3.GroupID=I.GroupID and I3.GroupType=I.GroupType and I3.EffMonth=I.EffMonth and I3.EffYear=I.EffYear)
	Inner Join IFRS_Calculation_Detail_RA I4 on (I4.GroupID=I.GroupID and I4.GroupType=I.GroupType and I4.EffMonth=I.EffMonth and I4.EffYear=I.EffYear)
	Inner Join IFRS_Calculation_Detail_CSM I5 on (I5.GroupID=I.GroupID and I5.GroupType=I.GroupType and I5.EffMonth=I.EffMonth and I5.EffYear=I.EffYear)
	Inner Join IFRS_Calculation_Detail_LOSS I6 on (I6.GroupID=I.GroupID and I6.GroupType=I.GroupType and I6.EffMonth=I.EffMonth and I6.EffYear=I.EffYear)
	Inner Join IFRS_Calculation_Detail_PAA I7 on (I7.GroupID=I.GroupID and I7.GroupType=I.GroupType and I7.EffMonth=I.EffMonth and I7.EffYear=I.EffYear)
	Inner Join TOC on (TOC.TOC=I1.TOC)
	Inner Join @PCurrency Currency on (Currency.Currency=I1.Currency)
	Where I.ProcessDate<=@PProcessDate 
	and (
		(@P_Method='' or I1.Method=@P_Method) and
		(@P_GroupType='' or I.GroupType=@P_GroupType) and
		(@P_Branch='' or I1.Branch=@P_Branch) and
		(@P_COB='' or TOC.COB=@P_COB) and
		(@P_TOC='' or I1.TOC=@P_TOC) and
		(@P_CGroup='' or I1.CGroup=@P_CGroup) and
		(@P_ISType='' or I1.ISType=@P_ISType) and
		(@P_Currency='' or I1.Currency=@P_Currency) and
		(@P_Year<=0 or I1.Year=@P_Year) and
		(@P_Month<=0 or I1.Month=@P_Month) 
	)
	Group by I.GroupID, I.GroupType, I.EffMonth, I.EffYear


	Insert into @IFRS
	Select 
	coalesce(I.GroupID, Ib.GroupID) as GroupID,
	coalesce(I.GroupType, Ib.GroupType) as GroupType,
	coalesce(I.EffMonth, Ib.EffMonth) as EffMonth,
	coalesce(I.EffYear, Ib.EffYear) as EffYear,
	Max(
	Case 
		When I1.NumMonths-((I1.Month+I1.Year*12)-(Month(@P_EDate)+Year(@P_EDate)*12)+1)>I1.NumMonths Then I1.NumMonths 
		Else I1.NumMonths-((I1.Month+I1.Year*12)-(Month(@P_EDate)+Year(@P_EDate)*12)+1) 
	End) as NumMonths,
	BEL_Beginning= sum(coalesce(Ib.BEL_Ending,0)),    
	BEL_Beginning_OC= sum(coalesce(Ib.BEL_Ending_OC,0)),    
	BEL_Initial= sum(coalesce(I.BEL_Initial,0)),    
	BEL_Premium_Expected= sum(coalesce(I.BEL_Premium_Expected,0)),    
	BEL_Commission_Expected= sum(coalesce(I.BEL_Commission_Expected,0)),    
	BEL_Interest_Accrete= sum(coalesce(I.BEL_Interest_Accrete,0)),    
	BEL_Claim_Expected= sum(coalesce(I.BEL_Claim_Expected,0)),    
	BEL_Claim_NPR_Expected= sum(coalesce(I.BEL_Claim_NPR_Expected,0)),    
	BEL_Expense_Expected= sum(coalesce(I.BEL_Expense_Expected,0)),    
	BEL_Cost_Expected= sum(coalesce(I.BEL_Cost_Expected,0)),    
	BEL_Others_Expected= sum(coalesce(I.BEL_Others_Expected,0)),    
	BEL_Refund_Expected= sum(coalesce(I.BEL_Refund_Expected,0)),       
	BEL_GainLoss_NonDiscRate= sum(coalesce(I.BEL_GainLoss_NonDiscRate,0)),      
	BEL_GainLoss_ExchangeRate = sum((coalesce(Ib.BEL_Ending_OC,0)+coalesce(I.BEL_Ending_OC,0))*Currency.Rate)-sum(coalesce(Ib.BEL_Ending,0)+coalesce(I.BEL_Ending,0)),
	BEL_Ending= sum(coalesce(Ib.BEL_Ending,0)+coalesce(I.BEL_Ending,0))+sum((coalesce(Ib.BEL_Ending_OC,0)+coalesce(I.BEL_Ending_OC,0))*Currency.Rate)-sum(coalesce(Ib.BEL_Ending,0)+coalesce(I.BEL_Ending,0)),    
	BEL_Ending_OC= sum(coalesce(Ib.BEL_Ending_OC,0)+coalesce(I.BEL_Ending_OC,0)),    
	BEL_GainLoss_DiscRate= sum(coalesce(I.BEL_GainLoss_DiscRate,0)),    
    
	RA_Beginning= sum(coalesce(Ib.RA_Ending,0)),    
	RA_Beginning_OC= sum(coalesce(Ib.RA_Ending_OC,0)),    
	RA_Initial= sum(coalesce(I.RA_Initial,0)),    
	RA_Interest_Accrete= sum(coalesce(I.RA_Interest_Accrete,0)),    
	RA_Release= sum(coalesce(I.RA_Release,0)),    
	RA_GainLoss_NonDiscRate= sum(coalesce(I.RA_GainLoss_NonDiscRate,0)),    
	RA_GainLoss_ExchangeRate = sum((coalesce(Ib.RA_Ending_OC,0)+coalesce(I.RA_Ending_OC,0))*Currency.Rate)-sum(coalesce(Ib.RA_Ending,0)+coalesce(I.RA_Ending,0)),
	RA_Ending= sum(coalesce(Ib.RA_Ending,0)+coalesce(I.RA_Ending,0))+sum((coalesce(Ib.RA_Ending_OC,0)+coalesce(I.RA_Ending_OC,0))*Currency.Rate)-sum(coalesce(Ib.RA_Ending,0)+coalesce(I.RA_Ending,0)), 
	RA_Ending_OC= sum(coalesce(Ib.RA_Ending_OC,0)+coalesce(I.RA_Ending_OC,0)), 
	RA_GainLoss_DiscRate= sum(coalesce(I.RA_GainLoss_DiscRate,0)),    
    
	CSM_Start= sum(coalesce(Ib.CSM_End,0)),    
	CSM_Start_OC= sum(coalesce(Ib.CSM_End_OC,0)),    
	CSM_Initial= sum(coalesce(I.CSM_Initial,0)),
	CSM_Interest_Accrete= sum(coalesce(I.CSM_Interest_Accrete,0)),    
	CSM_Amortization= sum(coalesce(I.CSM_Amortization,0)),    
	CSM_GainLoss_NonDiscRate= sum(coalesce(I.CSM_GainLoss_NonDiscRate,0)),    
	CSM_Adjustment= sum(coalesce(I.CSM_Adjustment,0)),    
	CSM_GainLoss_ExchangeRate = sum((coalesce(Ib.CSM_End_OC,0)+coalesce(I.CSM_End_OC,0))*Currency.Rate)-sum(coalesce(Ib.CSM_End,0)+coalesce(I.CSM_End,0)),    
	CSM_End= sum(coalesce(Ib.CSM_End,0)+coalesce(I.CSM_End,0))+sum((coalesce(Ib.CSM_End_OC,0)+coalesce(I.CSM_End_OC,0))*Currency.Rate)-sum(coalesce(Ib.CSM_End,0)+coalesce(I.CSM_End,0)),
	CSM_End_OC= sum(coalesce(Ib.CSM_End_OC,0)+coalesce(I.CSM_End_OC,0)),    
    
	PAA_Start= sum(coalesce(Ib.PAA_End,0)),    
	PAA_Start_OC= sum(coalesce(Ib.PAA_End_OC,0)),    
	PAA_Premium_Expected= sum(coalesce(I.PAA_Premium_Expected,0)),    
	PAA_Commission_Expected= sum(coalesce(I.PAA_Commission_Expected,0)),    
	PAA_Interest_Accrete= sum(coalesce(I.PAA_Interest_Accrete,0)),    
	PAA_Amortization= sum(coalesce(I.PAA_Amortization,0)),    
	PAA_GainLoss_ExchangeRate = sum((coalesce(Ib.PAA_End_OC,0)+coalesce(I.PAA_End_OC,0))*Currency.Rate)-sum(coalesce(Ib.PAA_End,0)+coalesce(I.PAA_End,0)),
	PAA_End= sum(coalesce(Ib.PAA_End,0)+coalesce(I.PAA_End,0))+sum((coalesce(Ib.PAA_End_OC,0)+coalesce(I.PAA_End_OC,0))*Currency.Rate)-sum(coalesce(Ib.PAA_End,0)+coalesce(I.PAA_End,0)),    
	PAA_End_OC= sum(coalesce(Ib.PAA_End_OC,0)+coalesce(I.PAA_End_OC,0)),    
    
	Loss_Start= sum(coalesce(Ib.Loss_End,0)),    
	Loss_Start_OC= sum(coalesce(Ib.Loss_End_OC,0)),    
	Loss_Initial = sum(coalesce(I.Loss_Initial,0)),     
	Loss_Inc_Dec_IR_NON_RA = sum(coalesce(I.Loss_Inc_Dec_IR_NON_RA,0)),     
	Loss_Inc_Dec_IR_RA = sum(coalesce(I.Loss_Inc_Dec_IR_RA,0)),     	
	Loss_Inc_Dec_IF = sum(coalesce(I.Loss_Inc_Dec_IF,0)),     
	Loss_Inc_Dec_LC = sum(coalesce(I.Loss_Inc_Dec_LC,0)),     
	LOSS_Adjustment= sum(coalesce(I.Loss_Adjustment,0)),    
	Loss_End= sum(coalesce(Ib.Loss_End,0)+coalesce(I.Loss_End,0)),
	Loss_End_OC= sum(coalesce(Ib.Loss_End_OC,0)+coalesce(I.Loss_End_OC,0)),
	ACQ_Amortization= sum(coalesce(I.ACQ_Amortization,0))
	From
	(
		Select     
		I.GroupID, I.GroupType, I.EffMonth, I.EffYear,
		BEL_Initial = sum(Case When I1.Method='B' Then (BEL_Initial)*coalesce(mVoucher.Rate,1) Else 0 End),    
		BEL_Premium_Expected= sum(Case When I1.Method='B' Then (BEL_Premium_Expected)*coalesce(mVoucher.Rate,1) Else 0 End),    
		BEL_Commission_Expected= sum(Case When I1.Method='B' Then (BEL_Commission_Expected)*coalesce(mVoucher.Rate,1) Else 0 End),    
		BEL_Interest_Accrete= sum(Case When I1.Method='B' Then (BEL_Interest_Accrete)*coalesce(mVoucher.Rate,1) Else 0 End),    
		BEL_Claim_Expected= sum(Case When I1.Method='B' Then (BEL_Claim_Expected)*coalesce(mVoucher.Rate,1) Else 0 End),    
		BEL_Claim_NPR_Expected= sum(Case When I1.Method='B' Then (BEL_Claim_NPR_Expected)*coalesce(mVoucher.Rate,1) Else 0 End),    
		BEL_Expense_Expected= sum(Case When I1.Method='B' Then (BEL_Expense_Expected)*coalesce(mVoucher.Rate,1) Else 0 End),    
		BEL_Cost_Expected= sum(Case When I1.Method='B' Then (BEL_Cost_Expected)*coalesce(mVoucher.Rate,1) Else 0 End),    
		BEL_Others_Expected= sum(Case When I1.Method='B' Then (BEL_Others_Expected)*coalesce(mVoucher.Rate,1) Else 0 End),    
		BEL_Refund_Expected= sum(Case When I1.Method='B' Then (BEL_Refund_Expected)*coalesce(mVoucher.Rate,1) Else 0 End),           
		BEL_GainLoss_NonDiscRate= sum(Case When I1.Method='B' Then (BEL_GainLoss_NonDiscRate)*coalesce(mVoucher.Rate,1) Else 0 End),    
		BEL_Ending= sum(Case When I1.Method='B' Then (BEL_Initial+BEL_Premium_Expected+BEL_Commission_Expected+BEL_Interest_Accrete+BEL_Claim_Expected+BEL_Claim_NPR_Expected+BEL_Expense_Expected+BEL_Cost_Expected+BEL_Others_Expected+BEL_Refund_Expected+BEL_GainLoss_NonDiscRate)*coalesce(mVoucher.Rate,1) Else 0 End),        
		BEL_Ending_OC= sum(Case When I1.Method='B' Then (BEL_Initial+BEL_Premium_Expected+BEL_Commission_Expected+BEL_Interest_Accrete+BEL_Claim_Expected+BEL_Claim_NPR_Expected+BEL_Expense_Expected+BEL_Cost_Expected+BEL_Others_Expected+BEL_Refund_Expected+BEL_GainLoss_NonDiscRate) Else 0 End),        
		BEL_GainLoss_DiscRate= sum(Case When I1.Method='B' Then (BEL_GainLoss_DiscRate)*coalesce(mVoucher.Rate,1) Else 0 End),    
    
		RA_Initial= sum(Case When I1.Method='B' Then (RA_Initial)*coalesce(mVoucher.Rate,1) Else 0 End),    
		RA_Interest_Accrete= sum(Case When I1.Method='B' Then (RA_Interest_Accrete)*coalesce(mVoucher.Rate,1) Else 0 End),    
		RA_Release= sum(Case When I1.Method='B' Then (RA_Release)*coalesce(mVoucher.Rate,1) Else 0 End),    
		RA_GainLoss_NonDiscRate= sum(Case When I1.Method='B' Then (RA_GainLoss_NonDiscRate)*coalesce(mVoucher.Rate,1) Else 0 End),            
		RA_Ending= sum(Case When I1.Method='B' Then (RA_Initial+RA_Interest_Accrete+RA_Release+RA_GainLoss_NonDiscRate)*coalesce(mVoucher.Rate,1) Else 0 End),    
		RA_Ending_OC= sum(Case When I1.Method='B' Then (RA_Initial+RA_Interest_Accrete+RA_Release+RA_GainLoss_NonDiscRate) Else 0 End),    
		RA_GainLoss_DiscRate= sum(Case When I1.Method='B' Then (RA_GainLoss_DiscRate)*coalesce(mVoucher.Rate,1) Else 0 End),    
    
		CSM_Initial= sum(Case When I1.Method='B' Then (CSM_Initial)*coalesce(mVoucher.Rate,1) Else 0 End),
		CSM_Interest_Accrete= sum(Case When I1.Method='B' Then (CSM_Interest_Accrete)*coalesce(mVoucher.Rate,1) Else 0 End),    
		CSM_Amortization= sum(Case When I1.Method='B' Then (CSM_Amortization)*coalesce(mVoucher.Rate,1) Else 0 End),    
		CSM_GainLoss_NonDiscRate= sum(Case When I1.Method='B' Then (CSM_GainLoss_NonDiscRate)*coalesce(mVoucher.Rate,1) Else 0 End),    
		CSM_Adjustment= sum(Case When I1.Method='B' Then (CSM_Adjustment)*coalesce(mVoucher.Rate,1) Else 0 End),    
		CSM_End= sum(Case When I1.Method='B' Then (CSM_Initial+CSM_Interest_Accrete+CSM_Amortization+CSM_GainLoss_NonDiscRate+CSM_Adjustment)*coalesce(mVoucher.Rate,1) Else 0 End),    
		CSM_End_OC= sum(Case When I1.Method='B' Then (CSM_Initial+CSM_Interest_Accrete+CSM_Amortization+CSM_GainLoss_NonDiscRate+CSM_Adjustment) Else 0 End),    
    
		PAA_Premium_Expected = sum(Case When I1.Method='P' Then (PAA_Premium_Expected)*coalesce(mVoucher.Rate,1) Else 0 End),    
		PAA_Commission_Expected = sum(Case When I1.Method='P' Then (PAA_Commission_Expected)*coalesce(mVoucher.Rate,1) Else 0 End),    
		PAA_Interest_Accrete= sum(Case When I1.Method='P' Then (PAA_Interest_Accrete)*coalesce(mVoucher.Rate,1) Else 0 End),    
		PAA_Amortization= sum(Case When I1.Method='P' Then (PAA_Amortization)*coalesce(mVoucher.Rate,1) Else 0 End),    
		PAA_End= sum(Case When I1.Method='P' Then (PAA_Premium_Expected+PAA_Commission_Expected+PAA_Interest_Accrete+PAA_Amortization)*coalesce(mVoucher.Rate,1) Else 0 End),    
		PAA_End_OC= sum(Case When I1.Method='P' Then (PAA_Premium_Expected+PAA_Commission_Expected+PAA_Interest_Accrete+PAA_Amortization) Else 0 End),    

		Loss_Initial = sum(Case When I1.Method='B' Then (LOSS_Initial)*coalesce(mVoucher.Rate,1) Else 0 End),    
		Loss_Inc_Dec_IR_NON_RA = sum(Case When I1.Method='B' Then (Loss_Portion_from_Claim_Release+Loss_Portion_from_Expense_Release+Loss_Portion_from_Cost_Release+Loss_Portion_from_Others_Release+Loss_Portion_from_Refund_Release)*coalesce(mVoucher.Rate,1)  Else 0 End),     
		Loss_Inc_Dec_IR_RA = sum(Case When I1.Method='B' Then (Loss_Portion_from_RA_Release)*coalesce(mVoucher.Rate,1)  Else 0 End),     
		Loss_Inc_Dec_IF = sum(Case When I1.Method='B' Then (Loss_Portion_from_Interest_Accrete+Loss_Portion_from_GainLoss_DiscRate)*coalesce(mVoucher.Rate,1)  Else 0 End),     
		Loss_Inc_Dec_LC = sum(Case When I1.Method='B' Then (Loss_GainLoss_NonDiscRate)*coalesce(mVoucher.Rate,1)  Else 0 End),     
		LOSS_Adjustment= sum(Case When I1.Method='B' Then (Loss_Adjustment)*coalesce(mVoucher.Rate,1)  Else 0 End),    
		Loss_End= sum(Case When I1.Method='B' Then (Loss_Initial+Loss_Portion_from_Claim_Release+Loss_Portion_from_Expense_Release+Loss_Portion_from_Cost_Release+Loss_Portion_from_Others_Release+Loss_Portion_from_Refund_Release+Loss_Portion_from_RA_Release+Loss_Portion_from_Interest_Accrete+Loss_Portion_from_GainLoss_DiscRate+Loss_GainLoss_NonDiscRate+Loss_Adjustment)*coalesce(mVoucher.Rate,1)  Else 0 End),    
		Loss_End_OC= sum(Case When I1.Method='B' Then (Loss_Initial+Loss_Portion_from_Claim_Release+Loss_Portion_from_Expense_Release+Loss_Portion_from_Cost_Release+Loss_Portion_from_Others_Release+Loss_Portion_from_Refund_Release+Loss_Portion_from_RA_Release+Loss_Portion_from_Interest_Accrete+Loss_Portion_from_GainLoss_DiscRate+Loss_GainLoss_NonDiscRate+Loss_Adjustment) Else 0 End),    

		--Already in Base Currency
		ACQ_Amortization= sum(ACQ_Amortization)  
		from IFRS_Movement I    
		Inner Join IFRS_Calculation I1 on (I1.GroupID=I.GroupID)
		Inner Join TOC on (TOC.TOC=I1.TOC)
		Left Join Acclink on (Acclink.AccNo=I.AccNo)
		Left Join mVoucher on (mVoucher.Voucher=Acclink.Voucher)
		Where I.ProcessDate<=@ProcessDate and I.ProcessDate>@PProcessDate 
		and (
		(@P_Method='' or I1.Method=@P_Method) and
		(@P_GroupType='' or I.GroupType=@P_GroupType) and
		(@P_Branch='' or I1.Branch=@P_Branch) and
		(@P_COB='' or TOC.COB=@P_COB) and
		(@P_TOC='' or I1.TOC=@P_TOC) and
		(@P_CGroup='' or I1.CGroup=@P_CGroup) and
		(@P_ISType='' or I1.ISType=@P_ISType) and
		(@P_Currency='' or I1.Currency=@P_Currency) and
		(@P_Year<=0 or I1.Year=@P_Year) and
		(@P_Month<=0 or I1.Month=@P_Month) 
		)	
		Group By I.GroupID, I.GroupType, I.EffMonth, I.EffYear
	) I
	Full Join @IFRS_BBAL Ib on (Ib.GroupID=I.GroupID and Ib.GroupType=I.GroupType and Ib.EffMonth=I.EffMonth and Ib.EffYear=I.EffYear)
	Inner Join IFRS_Calculation I1 on (I1.GroupID=coalesce(I.GroupID, Ib.GroupID))
	Inner Join @Currency Currency on (Currency.Currency=I1.Currency)

	Group By coalesce(I.GroupID, Ib.GroupID), coalesce(I.GroupType, Ib.GroupType), coalesce(I.EffMonth, Ib.EffMonth), coalesce(I.EffYear, Ib.EffYear)

                         
	Return  
                          
End          
  
go






  insert into PatchVersioning
select '1333 Update script - IFRS_Disclosure',GETDATE()
go	
  

Declare @PrevScript varchar(100)
Declare @CurrScript varchar(100)

Select @PrevScript=''
Select @CurrSCript='1333 Update script - IFRS_Disclosure'


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

  