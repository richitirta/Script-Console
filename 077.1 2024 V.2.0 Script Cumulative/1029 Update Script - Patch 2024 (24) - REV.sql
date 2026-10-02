DROP Function Payor_Discount
GO
CREATE Function Payor_Discount(@P_ANO as int,@P_Code as varchar(10),@P_Period as int=0)          
RETURNS @DISCOUNT TABLE (GDISCOUNT Float, PDISCOUNT Float, DISCOUNT Float)  
AS          
BEGIN          
 Declare @PDiscount Float          
 Declare @GDiscount Float      
 Declare @NDiscount Float
 Declare @SLoading Float    
 Declare @TDiscount Float          
 Declare @RegNo varchar(50)    
 Declare @AStatus varchar(1)    
 Declare @LANO int
 Declare @OANO int
 Declare @DiscAmount Float
 Declare @Gross Float
 Declare @NoGDiscountF Bit

Select @TDiscount=Null
Select @PDiscount=Null
Select @GDiscount=0
Select @NDiscount=0
Select @SLoading=0
Select @DiscAmount=0
Select @NoGDiscountF=0
                 
Select @RegNo=RegNo, @AStatus=AStatus, @LANO=LANO, @OANO=OANO, @Gross=PCalc.Gross 
from Acceptance
Inner Join PCalc on (Pcalc.ANO=Acceptance.ANO)
Where Acceptance.ANO=@P_ANO    

if @LANO=-1
BEGIN
         Select @DiscAmount=Payor.DiscAmount, @PDiscount=Payor.Discount, @GDiscount=Payor.GDiscount, @NDiscount=Payor.NDiscount, @SLoading=Payor.SLoading, @TDiscount=PayorDet.Discount, @NoGDiscountF=coalesce(PayorDet.NoGDiscountF,0)
         from Acceptance 
         Inner Join Payor on (Payor.ANO=Acceptance.ANO)
         Left Join PayorDet on (PayorDet.ANO=Payor.ANO and PayorDet.Code=@P_Code and (PayorDet.Period=0 or PayorDet.Period=@P_Period))               
         Where Acceptance.ANO=@P_ANO  
 END
ELSE
BEGIN 
         -- Payor Discount from Alternate Discount          
        Select @DiscAmount=APayor.DiscAmount, @PDiscount=APayor.Discount from APayor Where ANO=@P_ANO          
        if @PDiscount is null          
        BEGIN           
             if @RegNo='' or @AStatus in ('W','T')   
             Begin       
               Select @DiscAmount=coalesce(PayorDet.DiscAmount, Payor.DiscAmount), @PDiscount=Payor.Discount, @GDiscount=Payor.GDiscount, @NDiscount=Payor.NDiscount, @SLoading=Payor.SLoading, @TDiscount=PayorDet.Discount, @NoGDiscountF=coalesce(PayorDet.NoGDiscountF,0)
               from Acceptance 
               Inner Join Acceptance mAcceptance on (mAcceptance.ANO=mAcceptance.LANO and mAcceptance.ANO=Acceptance.LANO)
               Inner Join Payor on (Payor.ANO=mAcceptance.ANO)
               Left Join PayorDet on (PayorDet.ANO=Payor.ANO and PayorDet.Code=@P_Code and (PayorDet.Period=0 or PayorDet.Period=@P_Period))           
               Where Acceptance.ANO=@P_ANO 
           end    
           else    
           Begin    
               Select @DiscAmount=coalesce(PayorDet.DiscAmount, Payor.DiscAmount), @PDiscount=Payor.Discount, @GDiscount=Payor.GDiscount, @NDiscount=Payor.NDiscount, @SLoading=Payor.SLoading, @TDiscount=PayorDet.Discount, @NoGDiscountF=coalesce(PayorDet.NoGDiscountF,0)
               from Acceptance 
               Inner Join Acceptance mAcceptance on (mAcceptance.ANO=mAcceptance.LANO and ((mAcceptance.RegNo<>'' and mAcceptance.RegNo=Acceptance.RegNo)))
               Inner Join Payor on (Payor.ANO=mAcceptance.ANO)
               Left Join PayorDet on (PayorDet.ANO=Payor.ANO and PayorDet.Code=@P_Code and (PayorDet.Period=0 or PayorDet.Period=@P_Period))           
               Where Acceptance.ANO=@P_ANO 
           end    
        End          
        Else          
        BEGIN          
             Select @DiscAmount=PayorDet.DiscAmount, @TDiscount=PayorDet.Discount, @NoGDiscountF=coalesce(PayorDet.NoGDiscountF,0)
			 from APayorDet PayorDet Where PayorDet.ANO=@P_ANO and PayorDet.Code=@P_Code and (PayorDet.Period=0 or PayorDet.Period=@P_Period)          
        End          
 END
                        
 if @TDiscount is not null          
		Select @PDiscount=@TDiscount          

 if @NoGDiscountF=1
	Select @GDiscount=0

 if @PDiscount=0 and @DiscAmount<>0
	Select @PDiscount=@DiscAmount / (@Gross * (1 - @GDiscount / 100) * (1 - @NDiscount / 100)) * 100

 insert into @Discount(GDiscount, PDiscount, Discount) Select @GDiscount, @PDiscount, (1 - (1 - @GDiscount / 100) * (1 - @NDiscount / 100) * (1 - @PDiscount / 100) * (1 + @SLoading / 100))*100
Return  
End          
GO

DROP Function Premium_Commission_Net_VAT
GO
CREATE Function Premium_Commission_Net_VAT(@P_ANO as int,@P_Code as varchar(10),@P_Period Int, @P_MinimumPremiumF Bit)                
RETURNS Float                
AS                
BEGIN                
 Declare @GDiscount Float                
 Declare @PDiscount Float                
 Declare @Discount Float                
 Declare @RDiscount Float                
 Declare @RLoading Float
 Declare @ADiscount Float                
 Declare @MShare Float                
 Declare @VAT Float        
 Declare @DetailF bit               
 Declare @RegNo varchar(50)        
 Declare @AStatus varchar(1)        
 Declare @LANO int   
 Declare @OANO int
 Declare @GrossUpComm Float      
 Declare @ADate smalldatetime
 Declare @VatSubsidiesF Bit     
 Declare @Gross Float
 Declare @TotalGross Float
 Declare @NumCCY Int
 Declare @TaxMethod int
      
 Select 
 @VatSubsidiesF=cast(Max(cast(Systab.VATSubsidiesF as Int)) as Bit), 
 @TaxMethod = Max(SysTab.TaxMethod),
 @ADate=Max(case when Acceptance.AUserID<>'' then Acceptance.ADate else cast(convert(varchar(10), getdate(),1) as smalldatetime) end), 
 @ADiscount=Max(Acceptance.Discount), 
 @RegNo=Max(Acceptance.RegNo), 
 @Astatus=Max(Acceptance.AStatus), 
 @LANO=Max(Acceptance.LANO), 
 @OANO=Max(Acceptance.OANO),
 @NumCCY=coalesce(count(distinct PCalc.Currency),1),
 @Gross=Case 
		When coalesce(count(distinct PCalc.Currency),1)=1 Then
			-- in Original Currency
			coalesce(sum(Case When ICalc.Code=@P_Code then 1 else 0 end*Case When (PCALC.Description<>'' and PCALC.Description<>'Minimum Premium') then ICALC.GROSS*PCALC.GROSS/PCALC.OGROSS else ICALC.GROSS*RCALC.GROSS/RCALC.OGROSS end),0)
		else
			coalesce(sum(Case When ICalc.Code=@P_Code then 1 else 0 end*Case When (PCALC.Description<>'' and PCALC.Description<>'Minimum Premium') then ICALC.GROSS*PCALC.GROSS/PCALC.OGROSS*PCALC.RATE else ICALC.GROSS*RCALC.GROSS/RCALC.OGROSS*PCALC.RATE end),0)
		End,
 @TotalGross=Case 
		When coalesce(count(distinct PCalc.Currency),1)=1 Then
			-- in Original Currency
			coalesce(sum(Case When (PCALC.Description<>'' and PCALC.Description<>'Minimum Premium') then ICALC.GROSS*PCALC.GROSS/PCALC.OGROSS else ICALC.GROSS*RCALC.GROSS/RCALC.OGROSS end),0)
		else
			coalesce(sum(Case When (PCALC.Description<>'' and PCALC.Description<>'Minimum Premium') then ICALC.GROSS*PCALC.GROSS/PCALC.OGROSS*PCALC.RATE else ICALC.GROSS*RCALC.GROSS/RCALC.OGROSS*PCALC.RATE end),0)
		End,
 @RDiscount = Case When sum((ICalc.Gross+ICalc.Discount-ICalc.Loading)*PCalc.Rate)<>0 then sum(ICalc.Discount*PCalc.Rate)/sum((ICalc.Gross+ICalc.Discount-ICalc.Loading)*PCalc.Rate)*100 else 0 end,
 @RLoading = Case When sum((ICalc.Gross-ICalc.Loading)*PCalc.Rate)<>0 then sum(ICalc.Gross*PCalc.Rate)/sum((ICalc.Gross-ICalc.Loading)*PCalc.Rate) else 1 end 
 From 
 Acceptance 
 Inner Join Cover on (Cover.CNO=Acceptance.CNO) 
 Inner Join Systab on (1=1)
 Inner Join ICalc on (ICalc.ANO=Acceptance.ANO and ICalc.Gross<>0 and (@P_Period=0 or @P_Period=DateDiff(month, Acceptance.SDate, ICalc.SDate) / 12 + 1))
 Inner join RCALC on (ICALC.ANO=RCALC.ANO AND ICALC.CURRENCY=RCALC.CURRENCY AND ICALC.CODE=RCALC.CODE AND ICALC.TOR=RCALC.TOR AND ICALC.SDATE=RCALC.SDATE AND ICALC.EDATE=RCALC.EDATE AND ICALC.SANO=RCALC.SANO)     
 Inner join PCALC on (PCALC.ANO=ICALC.ANO AND PCALC.CURRENCY=ICALC.CURRENCY)     
 Where Acceptance.ANO=@P_ANO                                  
        
 Select @GDiscount=GDiscount, @PDiscount=PDiscount, @Discount=Discount from Payor_Discount(@P_ANO,@P_Code,@P_Period)        
 --Select @RDiscount=Discount, @RLoading=Loading from Rate_Discount(@P_ANO,@P_Code)                
 Select @MShare=dbo.Member_Share(@P_ANO)                                     
 
 if @LANO=-1	
 BEGIN
	  Select @GrossUpComm=
	  sum(
	  Case 
	  When coalesce(AccBSDet.FeeAmount,AccBS.FeeAmount)<>0 and @Gross<>0 Then
		  coalesce(AccBSDet.FeeAmount,AccBS.FeeAmount*@Gross/@TotalGross)/@Gross*100 
	  else
	  	  coalesce(AccBSDet.Fee,AccBS.Fee)
	  end
	  *(
	  Case 
	  When GrossUpF=1 Then 1 
	  else -- NetUpF (Net after VAT and TAX)
		(
		100 +
		(case when @ADate<MParam.Effective then MParam.VatOLD else MParam.Vat end)*(Case When Profile.VATF=1 Then 1 else 0 end)
		-
		Case 
		When TaxType.MTaxType='PASAL21' then MParam.PASAL21*(100-MParam.TAXDISCOUNT)/100
		When TaxType.MTaxType='PASAL23' then MParam.PASAL23
		When TaxType.MTaxType='PASAL26' then MParam.Pasal26
		When TaxType.MTaxType='PASAL4' then MParam.PASAL4
		else 0
		end 
		*(Case When Profile.TaxPCT=0 Then 1 else Profile.TaxPCT/100 end)
		*(Case When Profile.TaxF=1 Then 1 else 0 end)
		)/100
	  end)
	  + AccBS.UpFee)
	  from Acceptance   
	  inner join AccBS on (AccBS.ANO=Acceptance.ANO and AccBS.NoProrataF=0)   
	  Left Join AccBSDet on ((AccBSDet.Period=0 or AccBSDet.Period=@P_Period) and AccBSDet.ID=AccBS.ID and AccBSDet.BSType=AccBS.BSType and AccBSDet.ANO=AccBS.ANO and AccBSDet.Code=@P_Code and AccBSDet.InceptionF=0)  
	  Inner Join MParam on (MParam.Type='B'+AccBS.BSType)
	  Inner Join Profile on (Profile.ID=AccBS.ID)
	  Left Join TaxType on (TaxType.TaxType=Profile.TaxType)
	  Where Acceptance.ANO=@P_ANO and (AccBS.GrossUpF=1 or AccBS.NetUpF=1)  
          
	  if @GrossUpComm is null    
		 Select @GrossUpComm=0              
		 	  
	  Select @VAT=
	   sum(  
	   (  
		Case 
		When coalesce(AccBSDet.FeeAmount,AccBS.FeeAmount)<>0 and @Gross<>0 Then
			coalesce(AccBSDet.FeeAmount,AccBS.FeeAmount*@Gross/@TotalGross)/@Gross*100 
			/
			(
			Case 
			When AccBS.GrossF=1 then 
				1/@RLoading*100/(100-@RDiscount)  
			When AccBS.GrossBLF=1 Then
				1/@RLoading
			else  
				1 
			end 
			*
			(Case When AccBS.NetF=1 then (1-@Discount/100) When AccBS.NetGroupF=1 then (1-@GDiscount/100) else 1 end)
			)	   
		else
	  		coalesce(AccBSDet.Fee,AccBS.Fee)
			*
			(
			Case 
			When AccBS.GrossF=1 then 
				1/@RLoading*100/(100-@RDiscount)  
			When AccBS.GrossBLF=1 Then
				1/@RLoading
			else  
				1 
			end 
			*
			(Case When AccBS.NetF=1 then (1-@Discount/100) When AccBS.NetGroupF=1 then (1-@GDiscount/100) else 1 end)
			)	   
		end
		* (1-(Case When AccBS.GrossUpF=0 and AccBS.NetUpF=0 Then (@GrossUpComm)/100 else 0 end))      
		+(-(Case When @ADiscount=0 then AccBS.Discount else @ADiscount end)+AccBS.UpFee)*(Case When AccBS.GrossUpF=0 and AccBS.NetUpF=0 Then (100-@GrossUpComm)/100 else 1 end)     
	   )
	   *(Case When AccBS.MemberF=1 or AccBS.MemberFeeF=1 Then (1-@MShare/100) else 1 end)
	   *(Case When (Case When (coalesce(Profile.VATESDate,'01/01/1900')<= @ADate and coalesce(Profile.VatEEDate,'01/01/1900')>= @ADate) Then cast(0 as Bit) else Profile.VatF end)=1 Then (case when @ADate<MParam.Effective then MParam.VatOLD else MParam.Vat end)/100 else 0 end)   
	   *(Case When @TaxMethod<>3 or RateTab.VatCommissionF=1 then 1 else 0 end)
	   )     
	  From Acceptance
	  Inner Join AccBS on (AccBS.ANO=Acceptance.ANO and AccBS.NoProrataF=0)
	  Left Join AccBSDet on ((AccBSDet.Period=0 or AccBSDet.Period=@P_Period) and AccBSDet.ID=AccBS.ID and AccBSDet.BSType=AccBS.BSType and AccBSDet.ANO=AccBS.ANO and AccBSDet.Code=@P_Code and AccBSDet.InceptionF=0)
	  Inner Join MParam on (MParam.Type='B'+AccBS.BSType)
	  Inner Join Profile on (Profile.ID=AccBS.ID)
	  Inner Join RateTab on (RateTab.Code=@P_Code)
	  Where Acceptance.ANO=@P_ANO 
	  and (AccBS.NotMinimumPremiumF=0 or (AccBS.NotMinimumPremiumF=1 and @P_MinimumPremiumF=0))                   
 END
 ELSE
 BEGIN
	 Select Top 1 @DetailF=1 from AAccBS Where ANO=@P_ANO                        
	 if @DetailF is null         
	 Begin
		if @RegNo='' or @AStatus in ('W','T')   
		Begin	
		  Select @GrossUpComm=
		  sum(
		  Case 
		  When coalesce(AccBSDet.FeeAmount,AccBS.FeeAmount)<>0 and @Gross<>0 Then
			  coalesce(AccBSDet.FeeAmount,AccBS.FeeAmount*@Gross/@TotalGross)/@Gross*100 
		  else
	  		  coalesce(AccBSDet.Fee,AccBS.Fee)
		  end
		  *(
		  Case 
		  When GrossUpF=1 Then 1 
		  else -- NetUpF (Net after VAT and TAX)
			(
			100 +
			(case when @ADate<MParam.Effective then MParam.VatOLD else MParam.Vat end)*(Case When Profile.VATF=1 Then 1 else 0 end)
			-
			Case 
			When TaxType.MTaxType='PASAL21' then MParam.PASAL21*(100-MParam.TAXDISCOUNT)/100
			When TaxType.MTaxType='PASAL23' then MParam.PASAL23
			When TaxType.MTaxType='PASAL26' then MParam.Pasal26
			When TaxType.MTaxType='PASAL4' then MParam.PASAL4
			else 0
			end 
			*(Case When Profile.TaxPCT=0 Then 1 else Profile.TaxPCT/100 end)
			*(Case When Profile.TaxF=1 Then 1 else 0 end)
			)/100
		  end)
		  + AccBS.UpFee)
		  from Acceptance   
		  Inner Join Acceptance mAcceptance on (mAcceptance.ANO=mAcceptance.LANO and mAcceptance.ANO=Acceptance.LANO)		  
		  inner join AccBS on (AccBS.ANO=mAcceptance.ANO and AccBS.NoProrataF=0)   
		  Left Join AccBSDet on ((AccBSDet.Period=0 or AccBSDet.Period=@P_Period) and AccBSDet.ID=AccBS.ID and AccBSDet.BSType=AccBS.BSType and AccBSDet.ANO=AccBS.ANO and AccBSDet.Code=@P_Code and AccBSDet.InceptionF=0)  
		  Inner Join MParam on (MParam.Type='B'+AccBS.BSType)
		  Inner Join Profile on (Profile.ID=AccBS.ID)
		  Left Join TaxType on (TaxType.TaxType=Profile.TaxType)
		  Where Acceptance.ANO=@P_ANO and (AccBS.GrossUpF=1 or AccBS.NetUpF=1)  		

		  if @GrossUpComm is null    
			 Select @GrossUpComm=0              
		  
		   Select @VAT=
		   sum(  
		   (  
			Case 
			When coalesce(AccBSDet.FeeAmount,AccBS.FeeAmount)<>0 and @Gross<>0 Then
				coalesce(AccBSDet.FeeAmount,AccBS.FeeAmount*@Gross/@TotalGross)/@Gross*100 
				/
				(
				Case 
				When AccBS.GrossF=1 then 
					1/@RLoading*100/(100-@RDiscount)  
				When AccBS.GrossBLF=1 Then
					1/@RLoading
				else  
					1 
				end 
				*
				(Case When AccBS.NetF=1 then (1-@Discount/100) When AccBS.NetGroupF=1 then (1-@GDiscount/100) else 1 end)
				)	   
			else
	  			coalesce(AccBSDet.Fee,AccBS.Fee)
				*
				(
				Case 
				When AccBS.GrossF=1 then 
					1/@RLoading*100/(100-@RDiscount)  
				When AccBS.GrossBLF=1 Then
					1/@RLoading
				else  
					1 
				end 
				*
				(Case When AccBS.NetF=1 then (1-@Discount/100) When AccBS.NetGroupF=1 then (1-@GDiscount/100) else 1 end)
				)	   
			end
			* (1-(Case When AccBS.GrossUpF=0 and AccBS.NetUpF=0 Then (@GrossUpComm)/100 else 0 end))    
			+(-(Case When @ADiscount=0 then AccBS.Discount else @ADiscount end)+AccBS.UpFee)*(Case When AccBS.GrossUpF=0 and AccBS.NetUpF=0 Then (100-@GrossUpComm)/100 else 1 end)     
		   )
		   *(Case When AccBS.MemberF=1 or AccBS.MemberFeeF=1 Then (1-@MShare/100) else 1 end)
		   *(Case When (Case When (coalesce(Profile.VATESDate,'01/01/1900')<= @ADate and coalesce(Profile.VatEEDate,'01/01/1900')>= @ADate) Then cast(0 as Bit) else Profile.VatF end)=1 Then (case when @ADate<MParam.Effective then MParam.VatOLD else MParam.Vat end)/100 else 0 end)   
		   *(Case When @TaxMethod<>3 or RateTab.VatCommissionF=1 then 1 else 0 end)
		   )     
		  From Acceptance
		  Inner Join Acceptance mAcceptance on (mAcceptance.ANO=mAcceptance.LANO and mAcceptance.ANO=Acceptance.LANO)		  		  
		  Inner Join AccBS on (AccBS.ANO=mAcceptance.ANO and AccBS.NoProrataF=0)
		  Left Join AccBSDet on ((AccBSDet.Period=0 or AccBSDet.Period=@P_Period) and AccBSDet.ID=AccBS.ID and AccBSDet.BSType=AccBS.BSType and AccBSDet.ANO=AccBS.ANO and AccBSDet.Code=@P_Code and AccBSDet.InceptionF=0)
		  Inner Join MParam on (MParam.Type='B'+AccBS.BSType)
		  Inner Join Profile on (Profile.ID=AccBS.ID)
		  Inner Join RateTab on (RateTab.Code=@P_Code)
		  Where Acceptance.ANO=@P_ANO 
		  and (AccBS.NotMinimumPremiumF=0 or (AccBS.NotMinimumPremiumF=1 and @P_MinimumPremiumF=0))                   		  		  
		end
		else
		Begin
		  Select @GrossUpComm=
		  sum(
		  Case 
		  When coalesce(AccBSDet.FeeAmount,AccBS.FeeAmount)<>0 and @Gross<>0 Then
			  coalesce(AccBSDet.FeeAmount,AccBS.FeeAmount*@Gross/@TotalGross)/@Gross*100 
		  else
	  		  coalesce(AccBSDet.Fee,AccBS.Fee)
		  end
		  *(
		  Case 
		  When GrossUpF=1 Then 1 
		  else -- NetUpF (Net after VAT and TAX)
			(
			100 +
			(case when @ADate<MParam.Effective then MParam.VatOLD else MParam.Vat end)*(Case When Profile.VATF=1 Then 1 else 0 end)
			-
			Case 
			When TaxType.MTaxType='PASAL21' then MParam.PASAL21*(100-MParam.TAXDISCOUNT)/100
			When TaxType.MTaxType='PASAL23' then MParam.PASAL23
			When TaxType.MTaxType='PASAL26' then MParam.Pasal26
			When TaxType.MTaxType='PASAL4' then MParam.PASAL4
			else 0
			end 
			*(Case When Profile.TaxPCT=0 Then 1 else Profile.TaxPCT/100 end)
			*(Case When Profile.TaxF=1 Then 1 else 0 end)
			)/100
		  end)
		  + AccBS.UpFee)
		  from Acceptance   
		  Inner Join Acceptance mAcceptance on (mAcceptance.ANO=mAcceptance.LANO and ((mAcceptance.RegNo<>'' and mAcceptance.RegNo=Acceptance.RegNo)))
		  inner join AccBS on (AccBS.ANO=mAcceptance.ANO and AccBS.NoProrataF=0)   
		  Left Join AccBSDet on ((AccBSDet.Period=0 or AccBSDet.Period=@P_Period) and AccBSDet.ID=AccBS.ID and AccBSDet.BSType=AccBS.BSType and AccBSDet.ANO=AccBS.ANO and AccBSDet.Code=@P_Code and AccBSDet.InceptionF=0)  
		  Inner Join MParam on (MParam.Type='B'+AccBS.BSType)
		  Inner Join Profile on (Profile.ID=AccBS.ID)
		  Left Join TaxType on (TaxType.TaxType=Profile.TaxType)
		  Where Acceptance.ANO=@P_ANO and (AccBS.GrossUpF=1 or AccBS.NetUpF=1)  		

		  if @GrossUpComm is null    
			 Select @GrossUpComm=0              
		  
	      Select @VAT=
		   sum(  
		   (  
			Case 
			When coalesce(AccBSDet.FeeAmount,AccBS.FeeAmount)<>0 and @Gross<>0 Then
				coalesce(AccBSDet.FeeAmount,AccBS.FeeAmount*@Gross/@TotalGross)/@Gross*100 
				/
				(
				Case 
				When AccBS.GrossF=1 then 
					1/@RLoading*100/(100-@RDiscount)  
				When AccBS.GrossBLF=1 Then
					1/@RLoading
				else  
					1 
				end 
				*
				(Case When AccBS.NetF=1 then (1-@Discount/100) When AccBS.NetGroupF=1 then (1-@GDiscount/100) else 1 end)
				)	   
			else
	  			coalesce(AccBSDet.Fee,AccBS.Fee)
				*
				(
				Case 
				When AccBS.GrossF=1 then 
					1/@RLoading*100/(100-@RDiscount)  
				When AccBS.GrossBLF=1 Then
					1/@RLoading
				else  
					1 
				end 
				*
				(Case When AccBS.NetF=1 then (1-@Discount/100) When AccBS.NetGroupF=1 then (1-@GDiscount/100) else 1 end)
				)	   
			end
			* (1-(Case When AccBS.GrossUpF=0 and AccBS.NetUpF=0 Then (@GrossUpComm)/100 else 0 end))    
			+(-(Case When @ADiscount=0 then AccBS.Discount else @ADiscount end)+AccBS.UpFee)*(Case When AccBS.GrossUpF=0 and AccBS.NetUpF=0 Then (100-@GrossUpComm)/100 else 1 end)     
		   )
		   *(Case When AccBS.MemberF=1 or AccBS.MemberFeeF=1 Then (1-@MShare/100) else 1 end)
		   *(Case When (Case When (coalesce(Profile.VATESDate,'01/01/1900')<= @ADate and coalesce(Profile.VatEEDate,'01/01/1900')>= @ADate) Then cast(0 as Bit) else Profile.VatF end)=1 Then (case when @ADate<MParam.Effective then MParam.VatOLD else MParam.Vat end)/100 else 0 end)   
		   *(Case When @TaxMethod<>3 or RateTab.VatCommissionF=1 then 1 else 0 end)
		   )     
		  From Acceptance
		  Inner Join Acceptance mAcceptance on (mAcceptance.ANO=mAcceptance.LANO and ((mAcceptance.RegNo<>'' and mAcceptance.RegNo=Acceptance.RegNo)))
		  Inner Join AccBS on (AccBS.ANO=mAcceptance.ANO and AccBS.NoProrataF=0)
		  Left Join AccBSDet on ((AccBSDet.Period=0 or AccBSDet.Period=@P_Period) and AccBSDet.ID=AccBS.ID and AccBSDet.BSType=AccBS.BSType and AccBSDet.ANO=AccBS.ANO and AccBSDet.Code=@P_Code and AccBSDet.InceptionF=0)
		  Inner Join MParam on (MParam.Type='B'+AccBS.BSType)
		  Inner Join Profile on (Profile.ID=AccBS.ID)
          Inner Join RateTab on (RateTab.Code=@P_Code)
		  Where Acceptance.ANO=@P_ANO 
		  and (AccBS.NotMinimumPremiumF=0 or (AccBS.NotMinimumPremiumF=1 and @P_MinimumPremiumF=0))    		  		
		end
	 end
	 else
	 Begin
		  Select @GrossUpComm=
		  sum(
		  Case 
		  When coalesce(AAccBSDet.FeeAmount,AAccBS.FeeAmount)<>0 and @Gross<>0 Then
			  coalesce(AAccBSDet.FeeAmount,AAccBS.FeeAmount*@Gross/@TotalGross)*100/@Gross 
		  else
	  		  coalesce(AAccBSDet.Fee,AAccBS.Fee)
		  end
		  *(
		  Case 
		  When GrossUpF=1 Then 1 
		  else -- NetUpF (Net after VAT and TAX)
			(
			100 +
			(case when @ADate<MParam.Effective then MParam.VatOLD else MParam.Vat end)*(Case When Profile.VATF=1 Then 1 else 0 end)
			-
			Case 
			When TaxType.MTaxType='PASAL21' then MParam.PASAL21*(100-MParam.TAXDISCOUNT)/100
			When TaxType.MTaxType='PASAL23' then MParam.PASAL23
			When TaxType.MTaxType='PASAL26' then MParam.Pasal26
			When TaxType.MTaxType='PASAL4' then MParam.PASAL4
			else 0
			end 
			*(Case When Profile.TaxPCT=0 Then 1 else Profile.TaxPCT/100 end)
			*(Case When Profile.TaxF=1 Then 1 else 0 end)
			)/100
		  end)
		  + AAccBS.UpFee)
		  From AAccBS 
		  Left Join AAccBSDet on ((AAccBSDet.Period=0 or AAccBSDet.Period=@P_Period) and AAccBSDet.ID=AAccBS.ID and AAccBSDet.BSType=AAccBS.BSType and AAccBSDet.ANO=AAccBS.ANO and AAccBSDet.Code=@P_Code)   
		  Inner Join MParam on (MParam.Type='B'+AAccBS.BSType)
		  Inner Join Profile on (Profile.ID=AAccBS.ID)
		  Left Join TaxType on (TaxType.TaxType=Profile.TaxType)		  
		  Where AAccBS.ANO=@P_ANO and (AAccBS.GrossUpF=1 or AAccBS.NetUpF=1)    	 
		  
		  if @GrossUpComm is null    
			 Select @GrossUpComm=0              		  
			 
	       Select @VAT=
		   sum(  
		   (  
			Case 
			When coalesce(AccBSDet.FeeAmount,AccBS.FeeAmount)<>0 and @Gross<>0 Then
				coalesce(AccBSDet.FeeAmount,AccBS.FeeAmount*@Gross/@TotalGross)/@Gross*100 
				/
				(
				Case 
				When AccBS.GrossF=1 then 
					1/@RLoading*100/(100-@RDiscount)  
				When AccBS.GrossBLF=1 Then
					1/@RLoading
				else  
					1 
				end 
				*
				(Case When AccBS.NetF=1 then (1-@Discount/100) When AccBS.NetGroupF=1 then (1-@GDiscount/100) else 1 end)
				)	   
			else
	  			coalesce(AccBSDet.Fee,AccBS.Fee)
				*
				(
				Case 
				When AccBS.GrossF=1 then 
					1/@RLoading*100/(100-@RDiscount)  
				When AccBS.GrossBLF=1 Then
					1/@RLoading
				else  
					1 
				end 
				*
				(Case When AccBS.NetF=1 then (1-@Discount/100) When AccBS.NetGroupF=1 then (1-@GDiscount/100) else 1 end)
				)	   
			end
			* (1-(Case When AccBS.GrossUpF=0 and AccBS.NetUpF=0 Then (@GrossUpComm)/100 else 0 end))    
			+(-(Case When @ADiscount=0 then AccBS.Discount else @ADiscount end)+AccBS.UpFee)*(Case When AccBS.GrossUpF=0 and AccBS.NetUpF=0 Then (100-@GrossUpComm)/100 else 1 end)     
		   )
		   *(Case When AccBS.MemberF=1 or AccBS.MemberFeeF=1 Then (1-@MShare/100) else 1 end)
		   *(Case When (Case When (coalesce(Profile.VATESDate,'01/01/1900')<= @ADate and coalesce(Profile.VatEEDate,'01/01/1900')>= @ADate) Then cast(0 as Bit) else Profile.VatF end)=1 Then (case when @ADate<MParam.Effective then MParam.VatOLD else MParam.Vat end)/100 else 0 end)   
		   *(Case When @TaxMethod<>3 or RateTab.VatCommissionF=1 then 1 else 0 end)
		   )     
		  From Acceptance
		  Inner Join AAccBS AccBS on (AccBS.ANO=Acceptance.ANO and AccBS.NoProrataF=0)
		  Left Join AAccBSDet AccBSDet on ((AccBSDet.Period=0 or AccBSDet.Period=@P_Period) and AccBSDet.ID=AccBS.ID and AccBSDet.BSType=AccBS.BSType and AccBSDet.ANO=AccBS.ANO and AccBSDet.Code=@P_Code)
		  Inner Join MParam on (MParam.Type='B'+AccBS.BSType)
		  Inner Join Profile on (Profile.ID=AccBS.ID)
          Inner Join RateTab on (RateTab.Code=@P_Code)
		  Where Acceptance.ANO=@P_ANO 
		  and (AccBS.NotMinimumPremiumF=0 or (AccBS.NotMinimumPremiumF=1 and @P_MinimumPremiumF=0))                      
	 end
 
 END
                        
 if @VAT is null                
   Select @VAT=0                
                        
 return(@VAT)                
End        

GO
DROP Function Premium_Commission_Net
GO
CREATE Function Premium_Commission_Net(@P_ANO as int,@P_Code as varchar(10),@P_Period Int, @P_MinimumPremiumF Bit)                
RETURNS Float                
AS                
BEGIN                
 Declare @GDiscount Float                
 Declare @PDiscount Float                
 Declare @Discount Float                
 Declare @RDiscount Float                
 Declare @RLoading Float
 Declare @ADiscount Float                
 Declare @MShare Float                
 Declare @Commission Float        
 Declare @DetailF bit               
 Declare @RegNo varchar(50)        
 Declare @AStatus varchar(1)        
 Declare @LANO int   
 Declare @OANO int
 Declare @GrossUpComm Float      
 Declare @ADate smalldatetime
 Declare @VatSubsidiesF Bit
 Declare @Gross Float
 Declare @TotalGross Float
 Declare @NumCCY Int
      
 Select 
 @VatSubsidiesF=cast(Max(cast(Systab.VATSubsidiesF as Int)) as Bit), 
 @ADate=Max(case when Acceptance.AUserID<>'' then Acceptance.ADate else cast(convert(varchar(10), getdate(),1) as smalldatetime) end), 
 @ADiscount=Max(Acceptance.Discount), 
 @RegNo=Max(Acceptance.RegNo), 
 @Astatus=Max(Acceptance.AStatus), 
 @LANO=Max(Acceptance.LANO), 
 @OANO=Max(Acceptance.OANO),
 @NumCCY=coalesce(count(distinct PCalc.Currency),1),
 @Gross=Case 
		When coalesce(count(distinct PCalc.Currency),1)=1 Then
			-- in Original Currency
			coalesce(sum(Case When ICalc.Code=@P_Code then 1 else 0 end*Case When (PCALC.Description<>'' and PCALC.Description<>'Minimum Premium') then ICALC.GROSS*PCALC.GROSS/PCALC.OGROSS else ICALC.GROSS*RCALC.GROSS/RCALC.OGROSS end),0)
		else
			coalesce(sum(Case When ICalc.Code=@P_Code then 1 else 0 end*Case When (PCALC.Description<>'' and PCALC.Description<>'Minimum Premium') then ICALC.GROSS*PCALC.GROSS/PCALC.OGROSS*PCALC.RATE else ICALC.GROSS*RCALC.GROSS/RCALC.OGROSS*PCALC.RATE end),0)
		End,
 @TotalGross=Case 
		When coalesce(count(distinct PCalc.Currency),1)=1 Then
			-- in Original Currency
			coalesce(sum(Case When (PCALC.Description<>'' and PCALC.Description<>'Minimum Premium') then ICALC.GROSS*PCALC.GROSS/PCALC.OGROSS else ICALC.GROSS*RCALC.GROSS/RCALC.OGROSS end),0)
		else
			coalesce(sum(Case When (PCALC.Description<>'' and PCALC.Description<>'Minimum Premium') then ICALC.GROSS*PCALC.GROSS/PCALC.OGROSS*PCALC.RATE else ICALC.GROSS*RCALC.GROSS/RCALC.OGROSS*PCALC.RATE end),0)
		End,
 @RDiscount = Case When sum((ICalc.Gross+ICalc.Discount-ICalc.Loading)*PCalc.Rate)<>0 then sum(ICalc.Discount*PCalc.Rate)/sum((ICalc.Gross+ICalc.Discount-ICalc.Loading)*PCalc.Rate)*100 else 0 end,
 @RLoading = Case When sum((ICalc.Gross-ICalc.Loading)*PCalc.Rate)<>0 then sum(ICalc.Gross*PCalc.Rate)/sum((ICalc.Gross-ICalc.Loading)*PCalc.Rate) else 1 end 
 From 
 Acceptance 
 Inner Join Cover on (Cover.CNO=Acceptance.CNO) 
 Inner Join Systab on (1=1)
 Inner Join ICalc on (ICalc.ANO=Acceptance.ANO and ICalc.Gross<>0 and (@P_Period=0 or @P_Period=DateDiff(month, Acceptance.SDate, ICalc.SDate) / 12 + 1))
 Inner join RCALC on (ICALC.ANO=RCALC.ANO AND ICALC.CURRENCY=RCALC.CURRENCY AND ICALC.CODE=RCALC.CODE AND ICALC.TOR=RCALC.TOR AND ICALC.SDATE=RCALC.SDATE AND ICALC.EDATE=RCALC.EDATE AND ICALC.SANO=RCALC.SANO)     
 Inner join PCALC on (PCALC.ANO=ICALC.ANO AND PCALC.CURRENCY=ICALC.CURRENCY)     
 Where Acceptance.ANO=@P_ANO
         
 Select @GDiscount=GDiscount, @PDiscount=PDiscount, @Discount=Discount from Payor_Discount(@P_ANO,@P_Code,@P_Period)        
 --Select @RDiscount=Discount, @RLoading=Loading from Rate_Discount(@P_ANO,@P_Code)                
 Select @MShare=dbo.Member_Share(@P_ANO)                                     
 
 if @LANO=-1	
 BEGIN
	  Select @GrossUpComm=
	  sum(
	  Case 
	  When coalesce(AccBSDet.FeeAmount,AccBS.FeeAmount)<>0 and @Gross<>0 Then
		  coalesce(AccBSDet.FeeAmount,AccBS.FeeAmount*@Gross/@TotalGross)/@Gross*100 
	  else
	  	  coalesce(AccBSDet.Fee,AccBS.Fee)
	  end
	  *(
	  Case 
	  When GrossUpF=1 Then 1 
	  else -- NetUpF (Net after VAT and TAX)
		(
		100 +
		(case when @ADate<MParam.Effective then MParam.VatOLD else MParam.Vat end)*(Case When Profile.VATF=1 Then 1 else 0 end)
		-
		Case 
		When TaxType.MTaxType='PASAL21' then MParam.PASAL21*(100-MParam.TAXDISCOUNT)/100
		When TaxType.MTaxType='PASAL23' then MParam.PASAL23
		When TaxType.MTaxType='PASAL26' then MParam.Pasal26
		When TaxType.MTaxType='PASAL4' then MParam.PASAL4
		else 0
		end 
		*(Case When Profile.TaxPCT=0 Then 1 else Profile.TaxPCT/100 end)
		*(Case When Profile.TaxF=1 Then 1 else 0 end)
		)/100
	  end)
	  + AccBS.UpFee)
	  from Acceptance   
	  inner join AccBS on (AccBS.ANO=Acceptance.ANO and AccBS.NoProrataF=0)   
	  Left Join AccBSDet on ((AccBSDet.Period=0 or AccBSDet.Period=@P_Period) and AccBSDet.ID=AccBS.ID and AccBSDet.BSType=AccBS.BSType and AccBSDet.ANO=AccBS.ANO and AccBSDet.Code=@P_Code and AccBSDet.InceptionF=0)  
	  Inner Join MParam on (MParam.Type='B'+AccBS.BSType)
	  Inner Join Profile on (Profile.ID=AccBS.ID)
	  Left Join TaxType on (TaxType.TaxType=Profile.TaxType)
	  Where Acceptance.ANO=@P_ANO and (AccBS.GrossUpF=1 or AccBS.NetUpF=1)  
          
	  if @GrossUpComm is null    
		 Select @GrossUpComm=0              
		 
	  Select @Commission=        
	   sum(  
	   (	  
		Case 
		When coalesce(AccBSDet.FeeAmount,AccBS.FeeAmount)<>0 and @Gross<>0 Then
			coalesce(AccBSDet.FeeAmount,AccBS.FeeAmount*@Gross/@TotalGross)/@Gross*100 
			/
			(
			Case 
			When AccBS.GrossF=1 then 
				1/@RLoading*100/(100-@RDiscount)  
			When AccBS.GrossBLF=1 Then
				1/@RLoading
			else  
				1 
			end 
			*
			(Case When AccBS.NetF=1 then (1-@Discount/100) When AccBS.NetGroupF=1 then (1-@GDiscount/100) else 1 end)
			)	   
		else
	  		coalesce(AccBSDet.Fee,AccBS.Fee)
			*
			(
			Case 
			When AccBS.GrossF=1 then 
				1/@RLoading*100/(100-@RDiscount)  
			When AccBS.GrossBLF=1 Then
				1/@RLoading
			else  
				1 
			end 
			*
			(Case When AccBS.NetF=1 then (1-@Discount/100) When AccBS.NetGroupF=1 then (1-@GDiscount/100) else 1 end)
			)	   
		end
		* (1-(Case When AccBS.GrossUpF=0 and AccBS.NetUpF=0 Then (@GrossUpComm)/100 else 0 end))    	  
		+(-(Case When @ADiscount=0 then AccBS.Discount else @ADiscount end)+AccBS.UpFee)*(Case When AccBS.GrossUpF=0 and AccBS.NetUpF=0 Then (100-@GrossUpComm)/100 else 1 end)     
	   )
	   *(Case When AccBS.MemberF=1 or AccBS.MemberFeeF=1 Then (1-@MShare/100) else 1 end)  
	   )     
	  From Acceptance
	  Inner Join AccBS on (AccBS.ANO=Acceptance.ANO and AccBS.NoProrataF=0)
	  Left Join AccBSDet on ((AccBSDet.Period=0 or AccBSDet.Period=@P_Period) and AccBSDet.ID=AccBS.ID and AccBSDet.BSType=AccBS.BSType and AccBSDet.ANO=AccBS.ANO and AccBSDet.Code=@P_Code and AccBSDet.InceptionF=0)
	  Where Acceptance.ANO=@P_ANO 
	  and (AccBS.NotMinimumPremiumF=0 or (AccBS.NotMinimumPremiumF=1 and @P_MinimumPremiumF=0))                   
 END
 ELSE
 BEGIN
	 Select Top 1 @DetailF=1 from AAccBS Where ANO=@P_ANO        
	 if @DetailF is null         
	 Begin
		if @RegNo='' or @AStatus in ('W','T')   
		Begin	
		  Select @GrossUpComm=
		  sum(
		  Case 
		  When coalesce(AccBSDet.FeeAmount,AccBS.FeeAmount)<>0 and @Gross<>0 Then
			  coalesce(AccBSDet.FeeAmount,AccBS.FeeAmount*@Gross/@TotalGross)/@Gross*100 
		  else
	  		  coalesce(AccBSDet.Fee,AccBS.Fee)
		  end
		  *(
		  Case 
		  When GrossUpF=1 Then 1 
		  else -- NetUpF (Net after VAT and TAX)
			(
			100 +
			(case when @ADate<MParam.Effective then MParam.VatOLD else MParam.Vat end)*(Case When Profile.VATF=1 Then 1 else 0 end)
			-
			Case 
			When TaxType.MTaxType='PASAL21' then MParam.PASAL21*(100-MParam.TAXDISCOUNT)/100
			When TaxType.MTaxType='PASAL23' then MParam.PASAL23
			When TaxType.MTaxType='PASAL26' then MParam.Pasal26
			When TaxType.MTaxType='PASAL4' then MParam.PASAL4
			else 0
			end 
			*(Case When Profile.TaxPCT=0 Then 1 else Profile.TaxPCT/100 end)
			*(Case When Profile.TaxF=1 Then 1 else 0 end)
			)/100
		  end)
		  + AccBS.UpFee)

		  from Acceptance   
		  Inner Join Acceptance mAcceptance on (mAcceptance.ANO=mAcceptance.LANO and mAcceptance.ANO=Acceptance.LANO)		  
		  inner join AccBS on (AccBS.ANO=mAcceptance.ANO and AccBS.NoProrataF=0)   
		  Left Join AccBSDet on ((AccBSDet.Period=0 or AccBSDet.Period=@P_Period) and AccBSDet.ID=AccBS.ID and AccBSDet.BSType=AccBS.BSType and AccBSDet.ANO=AccBS.ANO and AccBSDet.Code=@P_Code and AccBSDet.InceptionF=0)  
		  Inner Join MParam on (MParam.Type='B'+AccBS.BSType)
		  Inner Join Profile on (Profile.ID=AccBS.ID)
		  Left Join TaxType on (TaxType.TaxType=Profile.TaxType)
		  Where Acceptance.ANO=@P_ANO and (AccBS.GrossUpF=1 or AccBS.NetUpF=1)  		

		  if @GrossUpComm is null    
			 Select @GrossUpComm=0              
		  
		  Select @Commission=        
		   sum(  
		   (  
			Case 
			When coalesce(AccBSDet.FeeAmount,AccBS.FeeAmount)<>0 and @Gross<>0 Then
				coalesce(AccBSDet.FeeAmount,AccBS.FeeAmount*@Gross/@TotalGross)/@Gross*100 
				/
				(
				Case 
				When AccBS.GrossF=1 then 
					1/@RLoading*100/(100-@RDiscount)  
				When AccBS.GrossBLF=1 Then
					1/@RLoading
				else  
					1 
				end 
				*
				(Case When AccBS.NetF=1 then (1-@Discount/100) When AccBS.NetGroupF=1 then (1-@GDiscount/100) else 1 end)
				)	   
			else
	  			coalesce(AccBSDet.Fee,AccBS.Fee)
				*
				(
				Case 
				When AccBS.GrossF=1 then 
					1/@RLoading*100/(100-@RDiscount)  
				When AccBS.GrossBLF=1 Then
					1/@RLoading
				else  
					1 
				end 
				*
				(Case When AccBS.NetF=1 then (1-@Discount/100) When AccBS.NetGroupF=1 then (1-@GDiscount/100) else 1 end)
				)	   
			end
			* (1-(Case When AccBS.GrossUpF=0 and AccBS.NetUpF=0 Then (@GrossUpComm)/100 else 0 end))  			     
			+(-(Case When @ADiscount=0 then AccBS.Discount else @ADiscount end)+AccBS.UpFee)*(Case When AccBS.GrossUpF=0 and AccBS.NetUpF=0 Then (100-@GrossUpComm)/100 else 1 end)     
		   )
		   *(Case When AccBS.MemberF=1 or AccBS.MemberFeeF=1 Then (1-@MShare/100) else 1 end)  
		   )     
		  From Acceptance
		  Inner Join Acceptance mAcceptance on (mAcceptance.ANO=mAcceptance.LANO and mAcceptance.ANO=Acceptance.LANO)		  		  
		  Inner Join AccBS on (AccBS.ANO=mAcceptance.ANO and AccBS.NoProrataF=0)
		  Left Join AccBSDet on ((AccBSDet.Period=0 or AccBSDet.Period=@P_Period) and AccBSDet.ID=AccBS.ID and AccBSDet.BSType=AccBS.BSType and AccBSDet.ANO=AccBS.ANO and AccBSDet.Code=@P_Code and AccBSDet.InceptionF=0)
		  Where Acceptance.ANO=@P_ANO 
		  and (AccBS.NotMinimumPremiumF=0 or (AccBS.NotMinimumPremiumF=1 and @P_MinimumPremiumF=0))                   		  		  
		end
		else
		Begin
		  Select @GrossUpComm=
		  sum(
		  Case 
		  When coalesce(AccBSDet.FeeAmount,AccBS.FeeAmount)<>0 and @Gross<>0 Then
			  coalesce(AccBSDet.FeeAmount,AccBS.FeeAmount*@Gross/@TotalGross)/@Gross*100 
		  else
	  		  coalesce(AccBSDet.Fee,AccBS.Fee)
		  end
		  *(
		  Case 
		  When GrossUpF=1 Then 1 
		  else -- NetUpF (Net after VAT and TAX)
			(
			100 +
			(case when @ADate<MParam.Effective then MParam.VatOLD else MParam.Vat end)*(Case When Profile.VATF=1 Then 1 else 0 end)
			-
			Case 
			When TaxType.MTaxType='PASAL21' then MParam.PASAL21*(100-MParam.TAXDISCOUNT)/100
			When TaxType.MTaxType='PASAL23' then MParam.PASAL23
			When TaxType.MTaxType='PASAL26' then MParam.Pasal26
			When TaxType.MTaxType='PASAL4' then MParam.PASAL4
			else 0
			end 
			*(Case When Profile.TaxPCT=0 Then 1 else Profile.TaxPCT/100 end)
			*(Case When Profile.TaxF=1 Then 1 else 0 end)
			)/100
		  end)
		  + AccBS.UpFee)
		  from Acceptance   
		  Inner Join Acceptance mAcceptance on (mAcceptance.ANO=mAcceptance.LANO and ((mAcceptance.RegNo<>'' and mAcceptance.RegNo=Acceptance.RegNo)))
		  inner join AccBS on (AccBS.ANO=mAcceptance.ANO and AccBS.NoProrataF=0)   
		  Left Join AccBSDet on ((AccBSDet.Period=0 or AccBSDet.Period=@P_Period) and AccBSDet.ID=AccBS.ID and AccBSDet.BSType=AccBS.BSType and AccBSDet.ANO=AccBS.ANO and AccBSDet.Code=@P_Code and AccBSDet.InceptionF=0)  
		  Inner Join MParam on (MParam.Type='B'+AccBS.BSType)
		  Inner Join Profile on (Profile.ID=AccBS.ID)
		  Left Join TaxType on (TaxType.TaxType=Profile.TaxType)
		  Where Acceptance.ANO=@P_ANO and (AccBS.GrossUpF=1 or AccBS.NetUpF=1)  		

		  if @GrossUpComm is null    
			 Select @GrossUpComm=0              
		  
		  Select @Commission=        
		   sum(  
		   (  
			Case 
			When coalesce(AccBSDet.FeeAmount,AccBS.FeeAmount)<>0 and @Gross<>0 Then
				coalesce(AccBSDet.FeeAmount,AccBS.FeeAmount*@Gross/@TotalGross)/@Gross*100 
				/
				(
				Case 
				When AccBS.GrossF=1 then 
					1/@RLoading*100/(100-@RDiscount)  
				When AccBS.GrossBLF=1 Then
					1/@RLoading
				else  
					1 
				end 
				*
				(Case When AccBS.NetF=1 then (1-@Discount/100) When AccBS.NetGroupF=1 then (1-@GDiscount/100) else 1 end)
				)	   
			else
	  			coalesce(AccBSDet.Fee,AccBS.Fee)
				*
				(
				Case 
				When AccBS.GrossF=1 then 
					1/@RLoading*100/(100-@RDiscount)  
				When AccBS.GrossBLF=1 Then
					1/@RLoading
				else  
					1 
				end 
				*
				(Case When AccBS.NetF=1 then (1-@Discount/100) When AccBS.NetGroupF=1 then (1-@GDiscount/100) else 1 end)
				)	   
			end
			* (1-(Case When AccBS.GrossUpF=0 and AccBS.NetUpF=0 Then (@GrossUpComm)/100 else 0 end))    
			+(-(Case When @ADiscount=0 then AccBS.Discount else @ADiscount end)+AccBS.UpFee)*(Case When AccBS.GrossUpF=0 and AccBS.NetUpF=0 Then (100-@GrossUpComm)/100 else 1 end)     
		   )
		   *(Case When AccBS.MemberF=1 or AccBS.MemberFeeF=1 Then (1-@MShare/100) else 1 end)  
		   )     
		  From Acceptance
		  Inner Join Acceptance mAcceptance on (mAcceptance.ANO=mAcceptance.LANO and ((mAcceptance.RegNo<>'' and mAcceptance.RegNo=Acceptance.RegNo)))
		  Inner Join AccBS on (AccBS.ANO=mAcceptance.ANO and AccBS.NoProrataF=0)
		  Left Join AccBSDet on ((AccBSDet.Period=0 or AccBSDet.Period=@P_Period) and AccBSDet.ID=AccBS.ID and AccBSDet.BSType=AccBS.BSType and AccBSDet.ANO=AccBS.ANO and AccBSDet.Code=@P_Code and AccBSDet.InceptionF=0)
		  Where Acceptance.ANO=@P_ANO 
		  and (AccBS.NotMinimumPremiumF=0 or (AccBS.NotMinimumPremiumF=1 and @P_MinimumPremiumF=0))    		  		
		end
	 end
	 else
	 Begin
		  Select @GrossUpComm=
		  sum(
		  Case 
		  When coalesce(AAccBSDet.FeeAmount,AAccBS.FeeAmount)<>0 and @Gross<>0 Then
			  coalesce(AAccBSDet.FeeAmount,AAccBS.FeeAmount*@Gross/@TotalGross)*100/@Gross 
		  else
	  		  coalesce(AAccBSDet.Fee,AAccBS.Fee)
		  end
		  *(
		  Case 
		  When GrossUpF=1 Then 1 
		  else -- NetUpF (Net after VAT and TAX)
			(
			100 +
			(case when @ADate<MParam.Effective then MParam.VatOLD else MParam.Vat end)*(Case When Profile.VATF=1 Then 1 else 0 end)
			-
			Case 
			When TaxType.MTaxType='PASAL21' then MParam.PASAL21*(100-MParam.TAXDISCOUNT)/100
			When TaxType.MTaxType='PASAL23' then MParam.PASAL23
			When TaxType.MTaxType='PASAL26' then MParam.Pasal26
			When TaxType.MTaxType='PASAL4' then MParam.PASAL4
			else 0
			end 
			*(Case When Profile.TaxPCT=0 Then 1 else Profile.TaxPCT/100 end)
			*(Case When Profile.TaxF=1 Then 1 else 0 end)
			)/100
		  end)
		  + AAccBS.UpFee)
		  From AAccBS 
		  Left Join AAccBSDet on ((AAccBSDet.Period=0 or AAccBSDet.Period=@P_Period) and AAccBSDet.ID=AAccBS.ID and AAccBSDet.BSType=AAccBS.BSType and AAccBSDet.ANO=AAccBS.ANO and AAccBSDet.Code=@P_Code)   
		  Inner Join MParam on (MParam.Type='B'+AAccBS.BSType)
		  Inner Join Profile on (Profile.ID=AAccBS.ID)
		  Left Join TaxType on (TaxType.TaxType=Profile.TaxType)
		  Where AAccBS.ANO=@P_ANO and (AAccBS.GrossUpF=1 or AAccBS.NetUpF=1)    	 
		  
		  if @GrossUpComm is null    
			 Select @GrossUpComm=0              		  
			 
		  Select @Commission=        
		   sum(  
		   (  
			Case 
			When coalesce(AccBSDet.FeeAmount,AccBS.FeeAmount)<>0 and @Gross<>0 Then
				coalesce(AccBSDet.FeeAmount,AccBS.FeeAmount*@Gross/@TotalGross)/@Gross*100 
				/
				(
				Case 
				When AccBS.GrossF=1 then 
					1/@RLoading*100/(100-@RDiscount)  
				When AccBS.GrossBLF=1 Then
					1/@RLoading
				else  
					1 
				end 
				*
				(Case When AccBS.NetF=1 then (1-@Discount/100) When AccBS.NetGroupF=1 then (1-@GDiscount/100) else 1 end)
				)	   
			else
	  			coalesce(AccBSDet.Fee,AccBS.Fee)
				*
				(
				Case 
				When AccBS.GrossF=1 then 
					1/@RLoading*100/(100-@RDiscount)  
				When AccBS.GrossBLF=1 Then
					1/@RLoading
				else  
					1 
				end 
				*
				(Case When AccBS.NetF=1 then (1-@Discount/100) When AccBS.NetGroupF=1 then (1-@GDiscount/100) else 1 end)
				)	   
			end
			* (1-(Case When AccBS.GrossUpF=0 and AccBS.NetUpF=0 Then (@GrossUpComm)/100 else 0 end))      
			+(-(Case When @ADiscount=0 then AccBS.Discount else @ADiscount end)+AccBS.UpFee)*(Case When AccBS.GrossUpF=0 and AccBS.NetUpF=0 Then (100-@GrossUpComm)/100 else 1 end)     
		   )
		   *(Case When AccBS.MemberF=1 or AccBS.MemberFeeF=1 Then (1-@MShare/100) else 1 end)  
		   )     
		  From Acceptance
		  Inner Join AAccBS AccBS on (AccBS.ANO=Acceptance.ANO and AccBS.NoProrataF=0)
		  Left Join AAccBSDet AccBSDet on ((AccBSDet.Period=0 or AccBSDet.Period=@P_Period) and AccBSDet.ID=AccBS.ID and AccBSDet.BSType=AccBS.BSType and AccBSDet.ANO=AccBS.ANO and AccBSDet.Code=@P_Code)
		  Where Acceptance.ANO=@P_ANO 
		  and (AccBS.NotMinimumPremiumF=0 or (AccBS.NotMinimumPremiumF=1 and @P_MinimumPremiumF=0))                      
	 end
 
 END
                        
 if @Commission is null                
   Select @Commission=0                
                        
 return(@Commission)                
End        

GO

DROP Function Premium_Commission
GO
CREATE Function Premium_Commission(@P_ANO as int,@P_Code as varchar(10),@P_Period Int, @P_MinimumPremiumF Bit)                
RETURNS Float                
AS                
BEGIN                
 Declare @GDiscount Float                
 Declare @PDiscount Float                
 Declare @Discount Float                
 Declare @RDiscount Float                
 Declare @RLoading Float
 Declare @ADiscount Float                
 Declare @MShare Float                
 Declare @Commission Float        
 Declare @DetailF bit               
 Declare @RegNo varchar(50)        
 Declare @AStatus varchar(1)        
 Declare @LANO int   
 Declare @OANO int
 Declare @GrossUpComm Float      
 Declare @ADate smalldatetime
 Declare @VatSubsidiesF Bit
 Declare @Gross Float
 Declare @TotalGross Float
 Declare @NumCCY Int
      
 Select 
 @VatSubsidiesF=cast(Max(cast(Systab.VATSubsidiesF as Int)) as Bit), 
 @ADate=Max(case when Acceptance.AUserID<>'' then Acceptance.ADate else cast(convert(varchar(10), getdate(),1) as smalldatetime) end), 
 @ADiscount=Max(Acceptance.Discount), 
 @RegNo=Max(Acceptance.RegNo), 
 @Astatus=Max(Acceptance.AStatus), 
 @LANO=Max(Acceptance.LANO), 
 @OANO=Max(Acceptance.OANO),
 @NumCCY=coalesce(count(distinct PCalc.Currency),1),
 @Gross=Case 
		When coalesce(count(distinct PCalc.Currency),1)=1 Then
			-- in Original Currency
			coalesce(sum(Case When ICalc.Code=@P_Code then 1 else 0 end*Case When (PCALC.Description<>'' and PCALC.Description<>'Minimum Premium') then ICALC.GROSS*PCALC.GROSS/PCALC.OGROSS else ICALC.GROSS*RCALC.GROSS/RCALC.OGROSS end),0)
		else
			coalesce(sum(Case When ICalc.Code=@P_Code then 1 else 0 end*Case When (PCALC.Description<>'' and PCALC.Description<>'Minimum Premium') then ICALC.GROSS*PCALC.GROSS/PCALC.OGROSS*PCALC.RATE else ICALC.GROSS*RCALC.GROSS/RCALC.OGROSS*PCALC.RATE end),0)
		End,
 @TotalGross=Case 
		When coalesce(count(distinct PCalc.Currency),1)=1 Then
			-- in Original Currency
			coalesce(sum(Case When (PCALC.Description<>'' and PCALC.Description<>'Minimum Premium') then ICALC.GROSS*PCALC.GROSS/PCALC.OGROSS else ICALC.GROSS*RCALC.GROSS/RCALC.OGROSS end),0)
		else
			coalesce(sum(Case When (PCALC.Description<>'' and PCALC.Description<>'Minimum Premium') then ICALC.GROSS*PCALC.GROSS/PCALC.OGROSS*PCALC.RATE else ICALC.GROSS*RCALC.GROSS/RCALC.OGROSS*PCALC.RATE end),0)
		End,
 @RDiscount = Case When sum((ICalc.Gross+ICalc.Discount-ICalc.Loading)*PCalc.Rate)<>0 then sum(ICalc.Discount*PCalc.Rate)/sum((ICalc.Gross+ICalc.Discount-ICalc.Loading)*PCalc.Rate)*100 else 0 end,
 @RLoading = Case When sum((ICalc.Gross-ICalc.Loading)*PCalc.Rate)<>0 then sum(ICalc.Gross*PCalc.Rate)/sum((ICalc.Gross-ICalc.Loading)*PCalc.Rate) else 1 end 
 From 
 Acceptance 
 Inner Join Cover on (Cover.CNO=Acceptance.CNO) 
 Inner Join Systab on (1=1)
 Inner Join ICalc on (ICalc.ANO=Acceptance.ANO and ICalc.Gross<>0 and (@P_Period=0 or @P_Period=DateDiff(month, Acceptance.SDate, ICalc.SDate) / 12 + 1))
 Inner join RCALC on (ICALC.ANO=RCALC.ANO AND ICALC.CURRENCY=RCALC.CURRENCY AND ICALC.CODE=RCALC.CODE AND ICALC.TOR=RCALC.TOR AND ICALC.SDATE=RCALC.SDATE AND ICALC.EDATE=RCALC.EDATE AND ICALC.SANO=RCALC.SANO)     
 Inner join PCALC on (PCALC.ANO=ICALC.ANO AND PCALC.CURRENCY=ICALC.CURRENCY)     
 Where Acceptance.ANO=@P_ANO
         
 Select @GDiscount=GDiscount, @PDiscount=PDiscount, @Discount=Discount from Payor_Discount(@P_ANO,@P_Code,@P_Period)        
 --Select @RDiscount=Discount, @RLoading=Loading from Rate_Discount(@P_ANO,@P_Code)                
 --Select @MShare=dbo.Member_Share(@P_ANO)                                     
 
 if @LANO=-1	
 BEGIN
	  Select @GrossUpComm=
	  sum(
	  Case 
	  When coalesce(AccBSDet.FeeAmount,AccBS.FeeAmount)<>0 and @Gross<>0 Then
		  coalesce(AccBSDet.FeeAmount,AccBS.FeeAmount*@Gross/@TotalGross)/@Gross*100 
	  else
	  	  coalesce(AccBSDet.Fee,AccBS.Fee)
	  end
	  *(
	  Case 
	  When GrossUpF=1 Then 1 
	  else -- NetUpF (Net after VAT and TAX)
		(
		100 +
		(case when @ADate<MParam.Effective then MParam.VatOLD else MParam.Vat end)*(Case When Profile.VATF=1 Then 1 else 0 end)
		-
		Case 
		When TaxType.MTaxType='PASAL21' then MParam.PASAL21*(100-MParam.TAXDISCOUNT)/100
		When TaxType.MTaxType='PASAL23' then MParam.PASAL23
		When TaxType.MTaxType='PASAL26' then MParam.Pasal26
		When TaxType.MTaxType='PASAL4' then MParam.PASAL4
		else 0
		end 
		*(Case When Profile.TaxPCT=0 Then 1 else Profile.TaxPCT/100 end)
		*(Case When Profile.TaxF=1 Then 1 else 0 end)
		)/100
	  end)
	  + AccBS.UpFee)
	  from Acceptance   
	  inner join AccBS on (AccBS.ANO=Acceptance.ANO and AccBS.NoProrataF=0)   
	  Left Join AccBSDet on ((AccBSDet.Period=0 or AccBSDet.Period=@P_Period) and AccBSDet.ID=AccBS.ID and AccBSDet.BSType=AccBS.BSType and AccBSDet.ANO=AccBS.ANO and AccBSDet.Code=@P_Code and AccBSDet.InceptionF=0)  
	  Inner Join MParam on (MParam.Type='B'+AccBS.BSType)
	  Inner Join Profile on (Profile.ID=AccBS.ID)
	  Left Join TaxType on (TaxType.TaxType=Profile.TaxType)
	  Where Acceptance.ANO=@P_ANO and (AccBS.GrossUpF=1 or AccBS.NetUpF=1)  
          
	  if @GrossUpComm is null    
		 Select @GrossUpComm=0              
		 
	  Select @Commission=        
	   sum(  
	   (	  
		Case 
		When coalesce(AccBSDet.FeeAmount,AccBS.FeeAmount)<>0 and @Gross<>0 Then
			coalesce(AccBSDet.FeeAmount,AccBS.FeeAmount*@Gross/@TotalGross)/@Gross*100 
			/
			(
			Case 
			When AccBS.GrossF=1 then 
				1/@RLoading*100/(100-@RDiscount)  
			When AccBS.GrossBLF=1 Then
				1/@RLoading
			else  
				1 
			end 
			*
			(Case When AccBS.NetF=1 then (1-@Discount/100) When AccBS.NetGroupF=1 then (1-@GDiscount/100) else 1 end)
			)	   
		else
	  		coalesce(AccBSDet.Fee,AccBS.Fee)
			*
			(
			Case 
			When AccBS.GrossF=1 then 
				1/@RLoading*100/(100-@RDiscount)  
			When AccBS.GrossBLF=1 Then
				1/@RLoading
			else  
				1 
			end 
			*
			(Case When AccBS.NetF=1 then (1-@Discount/100) When AccBS.NetGroupF=1 then (1-@GDiscount/100) else 1 end)
			)	   
		end
		* (1-(Case When AccBS.GrossUpF=0 and AccBS.NetUpF=0 Then (@GrossUpComm)/100 else 0 end))    	  
		+(-(Case When @ADiscount=0 then AccBS.Discount else @ADiscount end)+AccBS.UpFee)*(Case When AccBS.GrossUpF=0 and AccBS.NetUpF=0 Then (100-@GrossUpComm)/100 else 1 end)     
	   )
	   --*(Case When AccBS.MemberF=1 or AccBS.MemberFeeF=1 Then (1-@MShare/100) else 1 end)  
	   )     
	  From Acceptance
	  Inner Join AccBS on (AccBS.ANO=Acceptance.ANO and AccBS.NoProrataF=0)
	  Left Join AccBSDet on ((AccBSDet.Period=0 or AccBSDet.Period=@P_Period) and AccBSDet.ID=AccBS.ID and AccBSDet.BSType=AccBS.BSType and AccBSDet.ANO=AccBS.ANO and AccBSDet.Code=@P_Code and AccBSDet.InceptionF=0)
	  Where Acceptance.ANO=@P_ANO 
	  and (AccBS.NotMinimumPremiumF=0 or (AccBS.NotMinimumPremiumF=1 and @P_MinimumPremiumF=0))                   
 END
 ELSE
 BEGIN
	 Select Top 1 @DetailF=1 from AAccBS Where ANO=@P_ANO        
	 if @DetailF is null         
	 Begin
		if @RegNo='' or @AStatus in ('W','T')   
		Begin	
		  Select @GrossUpComm=
		  sum(
		  Case 
		  When coalesce(AccBSDet.FeeAmount,AccBS.FeeAmount)<>0 and @Gross<>0 Then
			  coalesce(AccBSDet.FeeAmount,AccBS.FeeAmount*@Gross/@TotalGross)/@Gross*100 
		  else
	  		  coalesce(AccBSDet.Fee,AccBS.Fee)
		  end
		  *(
		  Case 
		  When GrossUpF=1 Then 1 
		  else -- NetUpF (Net after VAT and TAX)
			(
			100 +
			(case when @ADate<MParam.Effective then MParam.VatOLD else MParam.Vat end)*(Case When Profile.VATF=1 Then 1 else 0 end)
			-
			Case 
			When TaxType.MTaxType='PASAL21' then MParam.PASAL21*(100-MParam.TAXDISCOUNT)/100
			When TaxType.MTaxType='PASAL23' then MParam.PASAL23
			When TaxType.MTaxType='PASAL26' then MParam.Pasal26
			When TaxType.MTaxType='PASAL4' then MParam.PASAL4
			else 0
			end 
			*(Case When Profile.TaxPCT=0 Then 1 else Profile.TaxPCT/100 end)
			*(Case When Profile.TaxF=1 Then 1 else 0 end)
			)/100
		  end)
		  + AccBS.UpFee)

		  from Acceptance   
		  Inner Join Acceptance mAcceptance on (mAcceptance.ANO=mAcceptance.LANO and mAcceptance.ANO=Acceptance.LANO)		  
		  inner join AccBS on (AccBS.ANO=mAcceptance.ANO and AccBS.NoProrataF=0)   
		  Left Join AccBSDet on ((AccBSDet.Period=0 or AccBSDet.Period=@P_Period) and AccBSDet.ID=AccBS.ID and AccBSDet.BSType=AccBS.BSType and AccBSDet.ANO=AccBS.ANO and AccBSDet.Code=@P_Code and AccBSDet.InceptionF=0)  
		  Inner Join MParam on (MParam.Type='B'+AccBS.BSType)
		  Inner Join Profile on (Profile.ID=AccBS.ID)
		  Left Join TaxType on (TaxType.TaxType=Profile.TaxType)
		  Where Acceptance.ANO=@P_ANO and (AccBS.GrossUpF=1 or AccBS.NetUpF=1)  		

		  if @GrossUpComm is null    
			 Select @GrossUpComm=0              
		  
		  Select @Commission=        
		   sum(  
		   (  
			Case 
			When coalesce(AccBSDet.FeeAmount,AccBS.FeeAmount)<>0 and @Gross<>0 Then
				coalesce(AccBSDet.FeeAmount,AccBS.FeeAmount*@Gross/@TotalGross)/@Gross*100 
				/
				(
				Case 
				When AccBS.GrossF=1 then 
					1/@RLoading*100/(100-@RDiscount)  
				When AccBS.GrossBLF=1 Then
					1/@RLoading
				else  
					1 
				end 
				*
				(Case When AccBS.NetF=1 then (1-@Discount/100) When AccBS.NetGroupF=1 then (1-@GDiscount/100) else 1 end)
				)	   
			else
	  			coalesce(AccBSDet.Fee,AccBS.Fee)
				*
				(
				Case 
				When AccBS.GrossF=1 then 
					1/@RLoading*100/(100-@RDiscount)  
				When AccBS.GrossBLF=1 Then
					1/@RLoading
				else  
					1 
				end 
				*
				(Case When AccBS.NetF=1 then (1-@Discount/100) When AccBS.NetGroupF=1 then (1-@GDiscount/100) else 1 end)
				)	   
			end
			* (1-(Case When AccBS.GrossUpF=0 and AccBS.NetUpF=0 Then (@GrossUpComm)/100 else 0 end))  			     
			+(-(Case When @ADiscount=0 then AccBS.Discount else @ADiscount end)+AccBS.UpFee)*(Case When AccBS.GrossUpF=0 and AccBS.NetUpF=0 Then (100-@GrossUpComm)/100 else 1 end)     
		   )
		   --*(Case When AccBS.MemberF=1 or AccBS.MemberFeeF=1 Then (1-@MShare/100) else 1 end)  
		   )     
		  From Acceptance
		  Inner Join Acceptance mAcceptance on (mAcceptance.ANO=mAcceptance.LANO and mAcceptance.ANO=Acceptance.LANO)		  		  
		  Inner Join AccBS on (AccBS.ANO=mAcceptance.ANO and AccBS.NoProrataF=0)
		  Left Join AccBSDet on ((AccBSDet.Period=0 or AccBSDet.Period=@P_Period) and AccBSDet.ID=AccBS.ID and AccBSDet.BSType=AccBS.BSType and AccBSDet.ANO=AccBS.ANO and AccBSDet.Code=@P_Code and AccBSDet.InceptionF=0)
		  Where Acceptance.ANO=@P_ANO 
		  and (AccBS.NotMinimumPremiumF=0 or (AccBS.NotMinimumPremiumF=1 and @P_MinimumPremiumF=0))                   		  		  
		end
		else
		Begin
		  Select @GrossUpComm=
		  sum(
		  Case 
		  When coalesce(AccBSDet.FeeAmount,AccBS.FeeAmount)<>0 and @Gross<>0 Then
			  coalesce(AccBSDet.FeeAmount,AccBS.FeeAmount*@Gross/@TotalGross)/@Gross*100 
		  else
	  		  coalesce(AccBSDet.Fee,AccBS.Fee)
		  end
		  *(
		  Case 
		  When GrossUpF=1 Then 1 
		  else -- NetUpF (Net after VAT and TAX)
			(
			100 +
			(case when @ADate<MParam.Effective then MParam.VatOLD else MParam.Vat end)*(Case When Profile.VATF=1 Then 1 else 0 end)
			-
			Case 
			When TaxType.MTaxType='PASAL21' then MParam.PASAL21*(100-MParam.TAXDISCOUNT)/100
			When TaxType.MTaxType='PASAL23' then MParam.PASAL23
			When TaxType.MTaxType='PASAL26' then MParam.Pasal26
			When TaxType.MTaxType='PASAL4' then MParam.PASAL4
			else 0
			end 
			*(Case When Profile.TaxPCT=0 Then 1 else Profile.TaxPCT/100 end)
			*(Case When Profile.TaxF=1 Then 1 else 0 end)
			)/100
		  end)
		  + AccBS.UpFee)
		  from Acceptance   
		  Inner Join Acceptance mAcceptance on (mAcceptance.ANO=mAcceptance.LANO and ((mAcceptance.RegNo<>'' and mAcceptance.RegNo=Acceptance.RegNo)))
		  inner join AccBS on (AccBS.ANO=mAcceptance.ANO and AccBS.NoProrataF=0)   
		  Left Join AccBSDet on ((AccBSDet.Period=0 or AccBSDet.Period=@P_Period) and AccBSDet.ID=AccBS.ID and AccBSDet.BSType=AccBS.BSType and AccBSDet.ANO=AccBS.ANO and AccBSDet.Code=@P_Code and AccBSDet.InceptionF=0)  
		  Inner Join MParam on (MParam.Type='B'+AccBS.BSType)
		  Inner Join Profile on (Profile.ID=AccBS.ID)
		  Left Join TaxType on (TaxType.TaxType=Profile.TaxType)
		  Where Acceptance.ANO=@P_ANO and (AccBS.GrossUpF=1 or AccBS.NetUpF=1)  		

		  if @GrossUpComm is null    
			 Select @GrossUpComm=0              
		  
		  Select @Commission=        
		   sum(  
		   (  
			Case 
			When coalesce(AccBSDet.FeeAmount,AccBS.FeeAmount)<>0 and @Gross<>0 Then
				coalesce(AccBSDet.FeeAmount,AccBS.FeeAmount*@Gross/@TotalGross)/@Gross*100 
				/
				(
				Case 
				When AccBS.GrossF=1 then 
					1/@RLoading*100/(100-@RDiscount)  
				When AccBS.GrossBLF=1 Then
					1/@RLoading
				else  
					1 
				end 
				*
				(Case When AccBS.NetF=1 then (1-@Discount/100) When AccBS.NetGroupF=1 then (1-@GDiscount/100) else 1 end)
				)	   
			else
	  			coalesce(AccBSDet.Fee,AccBS.Fee)
				*
				(
				Case 
				When AccBS.GrossF=1 then 
					1/@RLoading*100/(100-@RDiscount)  
				When AccBS.GrossBLF=1 Then
					1/@RLoading
				else  
					1 
				end 
				*
				(Case When AccBS.NetF=1 then (1-@Discount/100) When AccBS.NetGroupF=1 then (1-@GDiscount/100) else 1 end)
				)	   
			end
			* (1-(Case When AccBS.GrossUpF=0 and AccBS.NetUpF=0 Then (@GrossUpComm)/100 else 0 end))    
			+(-(Case When @ADiscount=0 then AccBS.Discount else @ADiscount end)+AccBS.UpFee)*(Case When AccBS.GrossUpF=0 and AccBS.NetUpF=0 Then (100-@GrossUpComm)/100 else 1 end)     
		   )
		   --*(Case When AccBS.MemberF=1 or AccBS.MemberFeeF=1 Then (1-@MShare/100) else 1 end)  
		   )     
		  From Acceptance
		  Inner Join Acceptance mAcceptance on (mAcceptance.ANO=mAcceptance.LANO and ((mAcceptance.RegNo<>'' and mAcceptance.RegNo=Acceptance.RegNo)))
		  Inner Join AccBS on (AccBS.ANO=mAcceptance.ANO and AccBS.NoProrataF=0)
		  Left Join AccBSDet on ((AccBSDet.Period=0 or AccBSDet.Period=@P_Period) and AccBSDet.ID=AccBS.ID and AccBSDet.BSType=AccBS.BSType and AccBSDet.ANO=AccBS.ANO and AccBSDet.Code=@P_Code and AccBSDet.InceptionF=0)
		  Where Acceptance.ANO=@P_ANO 
		  and (AccBS.NotMinimumPremiumF=0 or (AccBS.NotMinimumPremiumF=1 and @P_MinimumPremiumF=0))    		  		
		end
	 end
	 else
	 Begin
		  Select @GrossUpComm=
		  sum(
		  Case 
		  When coalesce(AAccBSDet.FeeAmount,AAccBS.FeeAmount)<>0 and @Gross<>0 Then
			  coalesce(AAccBSDet.FeeAmount,AAccBS.FeeAmount*@Gross/@TotalGross)*100/@Gross 
		  else
	  		  coalesce(AAccBSDet.Fee,AAccBS.Fee)
		  end
		  *(
		  Case 
		  When GrossUpF=1 Then 1 
		  else -- NetUpF (Net after VAT and TAX)
			(
			100 +
			(case when @ADate<MParam.Effective then MParam.VatOLD else MParam.Vat end)*(Case When Profile.VATF=1 Then 1 else 0 end)
			-
			Case 
			When TaxType.MTaxType='PASAL21' then MParam.PASAL21*(100-MParam.TAXDISCOUNT)/100
			When TaxType.MTaxType='PASAL23' then MParam.PASAL23
			When TaxType.MTaxType='PASAL26' then MParam.Pasal26
			When TaxType.MTaxType='PASAL4' then MParam.PASAL4
			else 0
			end 
			*(Case When Profile.TaxPCT=0 Then 1 else Profile.TaxPCT/100 end)
			*(Case When Profile.TaxF=1 Then 1 else 0 end)
			)/100
		  end)
		  + AAccBS.UpFee)
		  From AAccBS 
		  Left Join AAccBSDet on ((AAccBSDet.Period=0 or AAccBSDet.Period=@P_Period) and AAccBSDet.ID=AAccBS.ID and AAccBSDet.BSType=AAccBS.BSType and AAccBSDet.ANO=AAccBS.ANO and AAccBSDet.Code=@P_Code)   
		  Inner Join MParam on (MParam.Type='B'+AAccBS.BSType)
		  Inner Join Profile on (Profile.ID=AAccBS.ID)
		  Left Join TaxType on (TaxType.TaxType=Profile.TaxType)
		  Where AAccBS.ANO=@P_ANO and (AAccBS.GrossUpF=1 or AAccBS.NetUpF=1)    	 
		  
		  if @GrossUpComm is null    
			 Select @GrossUpComm=0              		  
			 
		  Select @Commission=        
		   sum(  
		   (  
			Case 
			When coalesce(AccBSDet.FeeAmount,AccBS.FeeAmount)<>0 and @Gross<>0 Then
				coalesce(AccBSDet.FeeAmount,AccBS.FeeAmount*@Gross/@TotalGross)/@Gross*100 
				/
				(
				Case 
				When AccBS.GrossF=1 then 
					1/@RLoading*100/(100-@RDiscount)  
				When AccBS.GrossBLF=1 Then
					1/@RLoading
				else  
					1 
				end 
				*
				(Case When AccBS.NetF=1 then (1-@Discount/100) When AccBS.NetGroupF=1 then (1-@GDiscount/100) else 1 end)
				)	   
			else
	  			coalesce(AccBSDet.Fee,AccBS.Fee)
				*
				(
				Case 
				When AccBS.GrossF=1 then 
					1/@RLoading*100/(100-@RDiscount)  
				When AccBS.GrossBLF=1 Then
					1/@RLoading
				else  
					1 
				end 
				*
				(Case When AccBS.NetF=1 then (1-@Discount/100) When AccBS.NetGroupF=1 then (1-@GDiscount/100) else 1 end)
				)	   
			end
			* (1-(Case When AccBS.GrossUpF=0 and AccBS.NetUpF=0 Then (@GrossUpComm)/100 else 0 end))      
			+(-(Case When @ADiscount=0 then AccBS.Discount else @ADiscount end)+AccBS.UpFee)*(Case When AccBS.GrossUpF=0 and AccBS.NetUpF=0 Then (100-@GrossUpComm)/100 else 1 end)     
		   )
		   --*(Case When AccBS.MemberF=1 or AccBS.MemberFeeF=1 Then (1-@MShare/100) else 1 end)  
		   )     
		  From Acceptance
		  Inner Join AAccBS AccBS on (AccBS.ANO=Acceptance.ANO and AccBS.NoProrataF=0)
		  Left Join AAccBSDet AccBSDet on ((AccBSDet.Period=0 or AccBSDet.Period=@P_Period) and AccBSDet.ID=AccBS.ID and AccBSDet.BSType=AccBS.BSType and AccBSDet.ANO=AccBS.ANO and AccBSDet.Code=@P_Code)
		  Where Acceptance.ANO=@P_ANO 
		  and (AccBS.NotMinimumPremiumF=0 or (AccBS.NotMinimumPremiumF=1 and @P_MinimumPremiumF=0))                      
	 end
 
 END
                        
 if @Commission is null                
   Select @Commission=0                
                        
 return(@Commission)                
End        


GO

DROP Function Premium_Commission_VAT
GO
CREATE Function Premium_Commission_VAT(@P_ANO as int,@P_Code as varchar(10),@P_Period Int, @P_MinimumPremiumF Bit)                
RETURNS Float                
AS                
BEGIN                
 Declare @GDiscount Float                
 Declare @PDiscount Float                
 Declare @Discount Float                
 Declare @RDiscount Float                
 Declare @RLoading Float
 Declare @ADiscount Float                
 Declare @MShare Float                
 Declare @VAT Float        
 Declare @DetailF bit               
 Declare @RegNo varchar(50)        
 Declare @AStatus varchar(1)        
 Declare @LANO int   
 Declare @OANO int
 Declare @GrossUpComm Float      
 Declare @ADate smalldatetime
 Declare @VatSubsidiesF Bit     
 Declare @Gross Float
 Declare @TotalGross Float
 Declare @NumCCY Int
 Declare @TaxMethod int
      
 Select 
 @VatSubsidiesF=cast(Max(cast(Systab.VATSubsidiesF as Int)) as Bit), 
 @TaxMethod = Max(SysTab.TaxMethod),
 @ADate=Max(case when Acceptance.AUserID<>'' then Acceptance.ADate else cast(convert(varchar(10), getdate(),1) as smalldatetime) end), 
 @ADiscount=Max(Acceptance.Discount), 
 @RegNo=Max(Acceptance.RegNo), 
 @Astatus=Max(Acceptance.AStatus), 
 @LANO=Max(Acceptance.LANO), 
 @OANO=Max(Acceptance.OANO),
 @NumCCY=coalesce(count(distinct PCalc.Currency),1),
 @Gross=Case 
		When coalesce(count(distinct PCalc.Currency),1)=1 Then
			-- in Original Currency
			coalesce(sum(Case When ICalc.Code=@P_Code then 1 else 0 end*Case When (PCALC.Description<>'' and PCALC.Description<>'Minimum Premium') then ICALC.GROSS*PCALC.GROSS/PCALC.OGROSS else ICALC.GROSS*RCALC.GROSS/RCALC.OGROSS end),0)
		else
			coalesce(sum(Case When ICalc.Code=@P_Code then 1 else 0 end*Case When (PCALC.Description<>'' and PCALC.Description<>'Minimum Premium') then ICALC.GROSS*PCALC.GROSS/PCALC.OGROSS*PCALC.RATE else ICALC.GROSS*RCALC.GROSS/RCALC.OGROSS*PCALC.RATE end),0)
		End,
 @TotalGross=Case 
		When coalesce(count(distinct PCalc.Currency),1)=1 Then
			-- in Original Currency
			coalesce(sum(Case When (PCALC.Description<>'' and PCALC.Description<>'Minimum Premium') then ICALC.GROSS*PCALC.GROSS/PCALC.OGROSS else ICALC.GROSS*RCALC.GROSS/RCALC.OGROSS end),0)
		else
			coalesce(sum(Case When (PCALC.Description<>'' and PCALC.Description<>'Minimum Premium') then ICALC.GROSS*PCALC.GROSS/PCALC.OGROSS*PCALC.RATE else ICALC.GROSS*RCALC.GROSS/RCALC.OGROSS*PCALC.RATE end),0)
		End,
 @RDiscount = Case When sum((ICalc.Gross+ICalc.Discount-ICalc.Loading)*PCalc.Rate)<>0 then sum(ICalc.Discount*PCalc.Rate)/sum((ICalc.Gross+ICalc.Discount-ICalc.Loading)*PCalc.Rate)*100 else 0 end,
 @RLoading = Case When sum((ICalc.Gross-ICalc.Loading)*PCalc.Rate)<>0 then sum(ICalc.Gross*PCalc.Rate)/sum((ICalc.Gross-ICalc.Loading)*PCalc.Rate) else 1 end 
 From 
 Acceptance 
 Inner Join Cover on (Cover.CNO=Acceptance.CNO) 
 Inner Join Systab on (1=1)
 Inner Join ICalc on (ICalc.ANO=Acceptance.ANO and ICalc.Gross<>0 and (@P_Period=0 or @P_Period=DateDiff(month, Acceptance.SDate, ICalc.SDate) / 12 + 1))
 Inner join RCALC on (ICALC.ANO=RCALC.ANO AND ICALC.CURRENCY=RCALC.CURRENCY AND ICALC.CODE=RCALC.CODE AND ICALC.TOR=RCALC.TOR AND ICALC.SDATE=RCALC.SDATE AND ICALC.EDATE=RCALC.EDATE AND ICALC.SANO=RCALC.SANO)     
 Inner join PCALC on (PCALC.ANO=ICALC.ANO AND PCALC.CURRENCY=ICALC.CURRENCY)     
 Where Acceptance.ANO=@P_ANO                                  
        
 Select @GDiscount=GDiscount, @PDiscount=PDiscount, @Discount=Discount from Payor_Discount(@P_ANO,@P_Code,@P_Period)        
 --Select @RDiscount=Discount, @RLoading=Loading from Rate_Discount(@P_ANO,@P_Code)                
 --Select @MShare=dbo.Member_Share(@P_ANO)                                     
 
 if @LANO=-1	
 BEGIN
	  Select @GrossUpComm=
	  sum(
	  Case 
	  When coalesce(AccBSDet.FeeAmount,AccBS.FeeAmount)<>0 and @Gross<>0 Then
		  coalesce(AccBSDet.FeeAmount,AccBS.FeeAmount*@Gross/@TotalGross)/@Gross*100 
	  else
	  	  coalesce(AccBSDet.Fee,AccBS.Fee)
	  end
	  *(
	  Case 
	  When GrossUpF=1 Then 1 
	  else -- NetUpF (Net after VAT and TAX)
		(
		100 +
		(case when @ADate<MParam.Effective then MParam.VatOLD else MParam.Vat end)*(Case When Profile.VATF=1 Then 1 else 0 end)
		-
		Case 
		When TaxType.MTaxType='PASAL21' then MParam.PASAL21*(100-MParam.TAXDISCOUNT)/100
		When TaxType.MTaxType='PASAL23' then MParam.PASAL23
		When TaxType.MTaxType='PASAL26' then MParam.Pasal26
		When TaxType.MTaxType='PASAL4' then MParam.PASAL4
		else 0
		end 
		*(Case When Profile.TaxPCT=0 Then 1 else Profile.TaxPCT/100 end)
		*(Case When Profile.TaxF=1 Then 1 else 0 end)
		)/100
	  end)
	  + AccBS.UpFee)
	  from Acceptance   
	  inner join AccBS on (AccBS.ANO=Acceptance.ANO and AccBS.NoProrataF=0)   
	  Left Join AccBSDet on ((AccBSDet.Period=0 or AccBSDet.Period=@P_Period) and AccBSDet.ID=AccBS.ID and AccBSDet.BSType=AccBS.BSType and AccBSDet.ANO=AccBS.ANO and AccBSDet.Code=@P_Code and AccBSDet.InceptionF=0)  
	  Inner Join MParam on (MParam.Type='B'+AccBS.BSType)
	  Inner Join Profile on (Profile.ID=AccBS.ID)
	  Left Join TaxType on (TaxType.TaxType=Profile.TaxType)
	  Where Acceptance.ANO=@P_ANO and (AccBS.GrossUpF=1 or AccBS.NetUpF=1)  
          
	  if @GrossUpComm is null    
		 Select @GrossUpComm=0              
		 	  
	  Select @VAT=
	   sum(  
	   (  
		Case 
		When coalesce(AccBSDet.FeeAmount,AccBS.FeeAmount)<>0 and @Gross<>0 Then
			coalesce(AccBSDet.FeeAmount,AccBS.FeeAmount*@Gross/@TotalGross)/@Gross*100 
			/
			(
			Case 
			When AccBS.GrossF=1 then 
				1/@RLoading*100/(100-@RDiscount)  
			When AccBS.GrossBLF=1 Then
				1/@RLoading
			else  
				1 
			end 
			*
			(Case When AccBS.NetF=1 then (1-@Discount/100) When AccBS.NetGroupF=1 then (1-@GDiscount/100) else 1 end)
			)	   
		else
	  		coalesce(AccBSDet.Fee,AccBS.Fee)
			*
			(
			Case 
			When AccBS.GrossF=1 then 
				1/@RLoading*100/(100-@RDiscount)  
			When AccBS.GrossBLF=1 Then
				1/@RLoading
			else  
				1 
			end 
			*
			(Case When AccBS.NetF=1 then (1-@Discount/100) When AccBS.NetGroupF=1 then (1-@GDiscount/100) else 1 end)
			)	   
		end
		* (1-(Case When AccBS.GrossUpF=0 and AccBS.NetUpF=0 Then (@GrossUpComm)/100 else 0 end))      
		+(-(Case When @ADiscount=0 then AccBS.Discount else @ADiscount end)+AccBS.UpFee)*(Case When AccBS.GrossUpF=0 and AccBS.NetUpF=0 Then (100-@GrossUpComm)/100 else 1 end)     
	   )
	   --*(Case When AccBS.MemberF=1 or AccBS.MemberFeeF=1 Then (1-@MShare/100) else 1 end)
	   *(Case When (Case When (coalesce(Profile.VATESDate,'01/01/1900')<= @ADate and coalesce(Profile.VatEEDate,'01/01/1900')>= @ADate) Then cast(0 as Bit) else Profile.VatF end)=1 Then (case when @ADate<MParam.Effective then MParam.VatOLD else MParam.Vat end)/100 else 0 end)   
	   *(Case When @TaxMethod<>3 or RateTab.VatCommissionF=1 then 1 else 0 end)
	   )     
	  From Acceptance
	  Inner Join AccBS on (AccBS.ANO=Acceptance.ANO and AccBS.NoProrataF=0)
	  Left Join AccBSDet on ((AccBSDet.Period=0 or AccBSDet.Period=@P_Period) and AccBSDet.ID=AccBS.ID and AccBSDet.BSType=AccBS.BSType and AccBSDet.ANO=AccBS.ANO and AccBSDet.Code=@P_Code and AccBSDet.InceptionF=0)
	  Inner Join MParam on (MParam.Type='B'+AccBS.BSType)
	  Inner Join Profile on (Profile.ID=AccBS.ID)
	  Inner Join RateTab on (RateTab.Code=@P_Code)
	  Where Acceptance.ANO=@P_ANO 
	  and (AccBS.NotMinimumPremiumF=0 or (AccBS.NotMinimumPremiumF=1 and @P_MinimumPremiumF=0))                   
 END
 ELSE
 BEGIN
	 Select Top 1 @DetailF=1 from AAccBS Where ANO=@P_ANO                        
	 if @DetailF is null         
	 Begin
		if @RegNo='' or @AStatus in ('W','T')   
		Begin	
		  Select @GrossUpComm=
		  sum(
		  Case 
		  When coalesce(AccBSDet.FeeAmount,AccBS.FeeAmount)<>0 and @Gross<>0 Then
			  coalesce(AccBSDet.FeeAmount,AccBS.FeeAmount*@Gross/@TotalGross)/@Gross*100 
		  else
	  		  coalesce(AccBSDet.Fee,AccBS.Fee)
		  end
		  *(
		  Case 
		  When GrossUpF=1 Then 1 
		  else -- NetUpF (Net after VAT and TAX)
			(
			100 +
			(case when @ADate<MParam.Effective then MParam.VatOLD else MParam.Vat end)*(Case When Profile.VATF=1 Then 1 else 0 end)
			-
			Case 
			When TaxType.MTaxType='PASAL21' then MParam.PASAL21*(100-MParam.TAXDISCOUNT)/100
			When TaxType.MTaxType='PASAL23' then MParam.PASAL23
			When TaxType.MTaxType='PASAL26' then MParam.Pasal26
			When TaxType.MTaxType='PASAL4' then MParam.PASAL4
			else 0
			end 
			*(Case When Profile.TaxPCT=0 Then 1 else Profile.TaxPCT/100 end)
			*(Case When Profile.TaxF=1 Then 1 else 0 end)
			)/100
		  end)
		  + AccBS.UpFee)
		  from Acceptance   
		  Inner Join Acceptance mAcceptance on (mAcceptance.ANO=mAcceptance.LANO and mAcceptance.ANO=Acceptance.LANO)		  
		  inner join AccBS on (AccBS.ANO=mAcceptance.ANO and AccBS.NoProrataF=0)   
		  Left Join AccBSDet on ((AccBSDet.Period=0 or AccBSDet.Period=@P_Period) and AccBSDet.ID=AccBS.ID and AccBSDet.BSType=AccBS.BSType and AccBSDet.ANO=AccBS.ANO and AccBSDet.Code=@P_Code and AccBSDet.InceptionF=0)  
		  Inner Join MParam on (MParam.Type='B'+AccBS.BSType)
		  Inner Join Profile on (Profile.ID=AccBS.ID)
		  Left Join TaxType on (TaxType.TaxType=Profile.TaxType)
		  Where Acceptance.ANO=@P_ANO and (AccBS.GrossUpF=1 or AccBS.NetUpF=1)  		

		  if @GrossUpComm is null    
			 Select @GrossUpComm=0              
		  
		   Select @VAT=
		   sum(  
		   (  
			Case 
			When coalesce(AccBSDet.FeeAmount,AccBS.FeeAmount)<>0 and @Gross<>0 Then
				coalesce(AccBSDet.FeeAmount,AccBS.FeeAmount*@Gross/@TotalGross)/@Gross*100 
				/
				(
				Case 
				When AccBS.GrossF=1 then 
					1/@RLoading*100/(100-@RDiscount)  
				When AccBS.GrossBLF=1 Then
					1/@RLoading
				else  
					1 
				end 
				*
				(Case When AccBS.NetF=1 then (1-@Discount/100) When AccBS.NetGroupF=1 then (1-@GDiscount/100) else 1 end)
				)	   
			else
	  			coalesce(AccBSDet.Fee,AccBS.Fee)
				*
				(
				Case 
				When AccBS.GrossF=1 then 
					1/@RLoading*100/(100-@RDiscount)  
				When AccBS.GrossBLF=1 Then
					1/@RLoading
				else  
					1 
				end 
				*
				(Case When AccBS.NetF=1 then (1-@Discount/100) When AccBS.NetGroupF=1 then (1-@GDiscount/100) else 1 end)
				)	   
			end
			* (1-(Case When AccBS.GrossUpF=0 and AccBS.NetUpF=0 Then (@GrossUpComm)/100 else 0 end))    
			+(-(Case When @ADiscount=0 then AccBS.Discount else @ADiscount end)+AccBS.UpFee)*(Case When AccBS.GrossUpF=0 and AccBS.NetUpF=0 Then (100-@GrossUpComm)/100 else 1 end)     
		   )
		   --*(Case When AccBS.MemberF=1 or AccBS.MemberFeeF=1 Then (1-@MShare/100) else 1 end)
		   *(Case When (Case When (coalesce(Profile.VATESDate,'01/01/1900')<= @ADate and coalesce(Profile.VatEEDate,'01/01/1900')>= @ADate) Then cast(0 as Bit) else Profile.VatF end)=1 Then (case when @ADate<MParam.Effective then MParam.VatOLD else MParam.Vat end)/100 else 0 end)   
		   *(Case When @TaxMethod<>3 or RateTab.VatCommissionF=1 then 1 else 0 end)
		   )     
		  From Acceptance
		  Inner Join Acceptance mAcceptance on (mAcceptance.ANO=mAcceptance.LANO and mAcceptance.ANO=Acceptance.LANO)		  		  
		  Inner Join AccBS on (AccBS.ANO=mAcceptance.ANO and AccBS.NoProrataF=0)
		  Left Join AccBSDet on ((AccBSDet.Period=0 or AccBSDet.Period=@P_Period) and AccBSDet.ID=AccBS.ID and AccBSDet.BSType=AccBS.BSType and AccBSDet.ANO=AccBS.ANO and AccBSDet.Code=@P_Code and AccBSDet.InceptionF=0)
		  Inner Join MParam on (MParam.Type='B'+AccBS.BSType)
		  Inner Join Profile on (Profile.ID=AccBS.ID)
		  Inner Join RateTab on (RateTab.Code=@P_Code)
		  Where Acceptance.ANO=@P_ANO 
		  and (AccBS.NotMinimumPremiumF=0 or (AccBS.NotMinimumPremiumF=1 and @P_MinimumPremiumF=0))                   		  		  
		end
		else
		Begin
		  Select @GrossUpComm=
		  sum(
		  Case 
		  When coalesce(AccBSDet.FeeAmount,AccBS.FeeAmount)<>0 and @Gross<>0 Then
			  coalesce(AccBSDet.FeeAmount,AccBS.FeeAmount*@Gross/@TotalGross)/@Gross*100 
		  else
	  		  coalesce(AccBSDet.Fee,AccBS.Fee)
		  end
		  *(
		  Case 
		  When GrossUpF=1 Then 1 
		  else -- NetUpF (Net after VAT and TAX)
			(
			100 +
			(case when @ADate<MParam.Effective then MParam.VatOLD else MParam.Vat end)*(Case When Profile.VATF=1 Then 1 else 0 end)
			-
			Case 
			When TaxType.MTaxType='PASAL21' then MParam.PASAL21*(100-MParam.TAXDISCOUNT)/100
			When TaxType.MTaxType='PASAL23' then MParam.PASAL23
			When TaxType.MTaxType='PASAL26' then MParam.Pasal26
			When TaxType.MTaxType='PASAL4' then MParam.PASAL4
			else 0
			end 
			*(Case When Profile.TaxPCT=0 Then 1 else Profile.TaxPCT/100 end)
			*(Case When Profile.TaxF=1 Then 1 else 0 end)
			)/100
		  end)
		  + AccBS.UpFee)
		  from Acceptance   
		  Inner Join Acceptance mAcceptance on (mAcceptance.ANO=mAcceptance.LANO and ((mAcceptance.RegNo<>'' and mAcceptance.RegNo=Acceptance.RegNo)))
		  inner join AccBS on (AccBS.ANO=mAcceptance.ANO and AccBS.NoProrataF=0)   
		  Left Join AccBSDet on ((AccBSDet.Period=0 or AccBSDet.Period=@P_Period) and AccBSDet.ID=AccBS.ID and AccBSDet.BSType=AccBS.BSType and AccBSDet.ANO=AccBS.ANO and AccBSDet.Code=@P_Code and AccBSDet.InceptionF=0)  
		  Inner Join MParam on (MParam.Type='B'+AccBS.BSType)
		  Inner Join Profile on (Profile.ID=AccBS.ID)
		  Left Join TaxType on (TaxType.TaxType=Profile.TaxType)
		  Where Acceptance.ANO=@P_ANO and (AccBS.GrossUpF=1 or AccBS.NetUpF=1)  		

		  if @GrossUpComm is null    
			 Select @GrossUpComm=0              
		  
	      Select @VAT=
		   sum(  
		   (  
			Case 
			When coalesce(AccBSDet.FeeAmount,AccBS.FeeAmount)<>0 and @Gross<>0 Then
				coalesce(AccBSDet.FeeAmount,AccBS.FeeAmount*@Gross/@TotalGross)/@Gross*100 
				/
				(
				Case 
				When AccBS.GrossF=1 then 
					1/@RLoading*100/(100-@RDiscount)  
				When AccBS.GrossBLF=1 Then
					1/@RLoading
				else  
					1 
				end 
				*
				(Case When AccBS.NetF=1 then (1-@Discount/100) When AccBS.NetGroupF=1 then (1-@GDiscount/100) else 1 end)
				)	   
			else
	  			coalesce(AccBSDet.Fee,AccBS.Fee)
				*
				(
				Case 
				When AccBS.GrossF=1 then 
					1/@RLoading*100/(100-@RDiscount)  
				When AccBS.GrossBLF=1 Then
					1/@RLoading
				else  
					1 
				end 
				*
				(Case When AccBS.NetF=1 then (1-@Discount/100) When AccBS.NetGroupF=1 then (1-@GDiscount/100) else 1 end)
				)	   
			end
			* (1-(Case When AccBS.GrossUpF=0 and AccBS.NetUpF=0 Then (@GrossUpComm)/100 else 0 end))    
			+(-(Case When @ADiscount=0 then AccBS.Discount else @ADiscount end)+AccBS.UpFee)*(Case When AccBS.GrossUpF=0 and AccBS.NetUpF=0 Then (100-@GrossUpComm)/100 else 1 end)     
		   )
		   --*(Case When AccBS.MemberF=1 or AccBS.MemberFeeF=1 Then (1-@MShare/100) else 1 end)
		   *(Case When (Case When (coalesce(Profile.VATESDate,'01/01/1900')<= @ADate and coalesce(Profile.VatEEDate,'01/01/1900')>= @ADate) Then cast(0 as Bit) else Profile.VatF end)=1 Then (case when @ADate<MParam.Effective then MParam.VatOLD else MParam.Vat end)/100 else 0 end)   
		   *(Case When @TaxMethod<>3 or RateTab.VatCommissionF=1 then 1 else 0 end)
		   )     
		  From Acceptance
		  Inner Join Acceptance mAcceptance on (mAcceptance.ANO=mAcceptance.LANO and ((mAcceptance.RegNo<>'' and mAcceptance.RegNo=Acceptance.RegNo)))
		  Inner Join AccBS on (AccBS.ANO=mAcceptance.ANO and AccBS.NoProrataF=0)
		  Left Join AccBSDet on ((AccBSDet.Period=0 or AccBSDet.Period=@P_Period) and AccBSDet.ID=AccBS.ID and AccBSDet.BSType=AccBS.BSType and AccBSDet.ANO=AccBS.ANO and AccBSDet.Code=@P_Code and AccBSDet.InceptionF=0)
		  Inner Join MParam on (MParam.Type='B'+AccBS.BSType)
		  Inner Join Profile on (Profile.ID=AccBS.ID)
          Inner Join RateTab on (RateTab.Code=@P_Code)
		  Where Acceptance.ANO=@P_ANO 
		  and (AccBS.NotMinimumPremiumF=0 or (AccBS.NotMinimumPremiumF=1 and @P_MinimumPremiumF=0))    		  		
		end
	 end
	 else
	 Begin
		  Select @GrossUpComm=
		  sum(
		  Case 
		  When coalesce(AAccBSDet.FeeAmount,AAccBS.FeeAmount)<>0 and @Gross<>0 Then
			  coalesce(AAccBSDet.FeeAmount,AAccBS.FeeAmount*@Gross/@TotalGross)*100/@Gross 
		  else
	  		  coalesce(AAccBSDet.Fee,AAccBS.Fee)
		  end
		  *(
		  Case 
		  When GrossUpF=1 Then 1 
		  else -- NetUpF (Net after VAT and TAX)
			(
			100 +
			(case when @ADate<MParam.Effective then MParam.VatOLD else MParam.Vat end)*(Case When Profile.VATF=1 Then 1 else 0 end)
			-
			Case 
			When TaxType.MTaxType='PASAL21' then MParam.PASAL21*(100-MParam.TAXDISCOUNT)/100
			When TaxType.MTaxType='PASAL23' then MParam.PASAL23
			When TaxType.MTaxType='PASAL26' then MParam.Pasal26
			When TaxType.MTaxType='PASAL4' then MParam.PASAL4
			else 0
			end 
			*(Case When Profile.TaxPCT=0 Then 1 else Profile.TaxPCT/100 end)
			*(Case When Profile.TaxF=1 Then 1 else 0 end)
			)/100
		  end)
		  + AAccBS.UpFee)
		  From AAccBS 
		  Left Join AAccBSDet on ((AAccBSDet.Period=0 or AAccBSDet.Period=@P_Period) and AAccBSDet.ID=AAccBS.ID and AAccBSDet.BSType=AAccBS.BSType and AAccBSDet.ANO=AAccBS.ANO and AAccBSDet.Code=@P_Code)   
		  Inner Join MParam on (MParam.Type='B'+AAccBS.BSType)
		  Inner Join Profile on (Profile.ID=AAccBS.ID)
		  Left Join TaxType on (TaxType.TaxType=Profile.TaxType)		  
		  Where AAccBS.ANO=@P_ANO and (AAccBS.GrossUpF=1 or AAccBS.NetUpF=1)    	 
		  
		  if @GrossUpComm is null    
			 Select @GrossUpComm=0              		  
			 
	       Select @VAT=
		   sum(  
		   (  
			Case 
			When coalesce(AccBSDet.FeeAmount,AccBS.FeeAmount)<>0 and @Gross<>0 Then
				coalesce(AccBSDet.FeeAmount,AccBS.FeeAmount*@Gross/@TotalGross)/@Gross*100 
				/
				(
				Case 
				When AccBS.GrossF=1 then 
					1/@RLoading*100/(100-@RDiscount)  
				When AccBS.GrossBLF=1 Then
					1/@RLoading
				else  
					1 
				end 
				*
				(Case When AccBS.NetF=1 then (1-@Discount/100) When AccBS.NetGroupF=1 then (1-@GDiscount/100) else 1 end)
				)	   
			else
	  			coalesce(AccBSDet.Fee,AccBS.Fee)
				*
				(
				Case 
				When AccBS.GrossF=1 then 
					1/@RLoading*100/(100-@RDiscount)  
				When AccBS.GrossBLF=1 Then
					1/@RLoading
				else  
					1 
				end 
				*
				(Case When AccBS.NetF=1 then (1-@Discount/100) When AccBS.NetGroupF=1 then (1-@GDiscount/100) else 1 end)
				)	   
			end
			* (1-(Case When AccBS.GrossUpF=0 and AccBS.NetUpF=0 Then (@GrossUpComm)/100 else 0 end))    
			+(-(Case When @ADiscount=0 then AccBS.Discount else @ADiscount end)+AccBS.UpFee)*(Case When AccBS.GrossUpF=0 and AccBS.NetUpF=0 Then (100-@GrossUpComm)/100 else 1 end)     
		   )
		   --*(Case When AccBS.MemberF=1 or AccBS.MemberFeeF=1 Then (1-@MShare/100) else 1 end)
		   *(Case When (Case When (coalesce(Profile.VATESDate,'01/01/1900')<= @ADate and coalesce(Profile.VatEEDate,'01/01/1900')>= @ADate) Then cast(0 as Bit) else Profile.VatF end)=1 Then (case when @ADate<MParam.Effective then MParam.VatOLD else MParam.Vat end)/100 else 0 end)   
		   *(Case When @TaxMethod<>3 or RateTab.VatCommissionF=1 then 1 else 0 end)
		   )     
		  From Acceptance
		  Inner Join AAccBS AccBS on (AccBS.ANO=Acceptance.ANO and AccBS.NoProrataF=0)
		  Left Join AAccBSDet AccBSDet on ((AccBSDet.Period=0 or AccBSDet.Period=@P_Period) and AccBSDet.ID=AccBS.ID and AccBSDet.BSType=AccBS.BSType and AccBSDet.ANO=AccBS.ANO and AccBSDet.Code=@P_Code)
		  Inner Join MParam on (MParam.Type='B'+AccBS.BSType)
		  Inner Join Profile on (Profile.ID=AccBS.ID)
          Inner Join RateTab on (RateTab.Code=@P_Code)
		  Where Acceptance.ANO=@P_ANO 
		  and (AccBS.NotMinimumPremiumF=0 or (AccBS.NotMinimumPremiumF=1 and @P_MinimumPremiumF=0))                      
	 end
 
 END
                        
 if @VAT is null                
   Select @VAT=0                
                        
 return(@VAT)                
End        

GO

DROP Function Premium_Commission_Tax

GO

CREATE Function Premium_Commission_Tax(@P_ANO as int,@P_Code as varchar(10),@P_Period Int, @P_MinimumPremiumF Bit)                
RETURNS Float                
AS                
BEGIN                
 Declare @GDiscount Float                
 Declare @PDiscount Float                
 Declare @Discount Float                
 Declare @RDiscount Float                
 Declare @RLoading Float
 Declare @ADiscount Float                
 Declare @MShare Float                
 Declare @TAX Float        
 Declare @DetailF bit               
 Declare @RegNo varchar(50)        
 Declare @AStatus varchar(1)        
 Declare @LANO int   
 Declare @OANO int
 Declare @GrossUpComm Float      
 Declare @ADate smalldatetime
 Declare @VatSubsidiesF Bit
 Declare @Gross Float
 Declare @TotalGross Float
 Declare @NumCCY Int
 Declare @TaxMethod int
      
 Select 
 @VatSubsidiesF=cast(Max(cast(Systab.VATSubsidiesF as Int)) as Bit), 
 @TaxMethod = Max(SysTab.TaxMethod),
 @ADate=Max(case when Acceptance.AUserID<>'' then Acceptance.ADate else cast(convert(varchar(10), getdate(),1) as smalldatetime) end), 
 @ADiscount=Max(Acceptance.Discount), 
 @RegNo=Max(Acceptance.RegNo), 
 @Astatus=Max(Acceptance.AStatus), 
 @LANO=Max(Acceptance.LANO), 
 @OANO=Max(Acceptance.OANO),
 @NumCCY=coalesce(count(distinct PCalc.Currency),1),
 @Gross=Case 
		When coalesce(count(distinct PCalc.Currency),1)=1 Then
			-- in Original Currency
			coalesce(sum(Case When ICalc.Code=@P_Code then 1 else 0 end*Case When (PCALC.Description<>'' and PCALC.Description<>'Minimum Premium') then ICALC.GROSS*PCALC.GROSS/PCALC.OGROSS else ICALC.GROSS*RCALC.GROSS/RCALC.OGROSS end),0)
		else
			coalesce(sum(Case When ICalc.Code=@P_Code then 1 else 0 end*Case When (PCALC.Description<>'' and PCALC.Description<>'Minimum Premium') then ICALC.GROSS*PCALC.GROSS/PCALC.OGROSS*PCALC.RATE else ICALC.GROSS*RCALC.GROSS/RCALC.OGROSS*PCALC.RATE end),0)
		End,
 @TotalGross=Case 
		When coalesce(count(distinct PCalc.Currency),1)=1 Then
			-- in Original Currency
			coalesce(sum(Case When (PCALC.Description<>'' and PCALC.Description<>'Minimum Premium') then ICALC.GROSS*PCALC.GROSS/PCALC.OGROSS else ICALC.GROSS*RCALC.GROSS/RCALC.OGROSS end),0)
		else
			coalesce(sum(Case When (PCALC.Description<>'' and PCALC.Description<>'Minimum Premium') then ICALC.GROSS*PCALC.GROSS/PCALC.OGROSS*PCALC.RATE else ICALC.GROSS*RCALC.GROSS/RCALC.OGROSS*PCALC.RATE end),0)
		End,
 @RDiscount = Case When sum((ICalc.Gross+ICalc.Discount-ICalc.Loading)*PCalc.Rate)<>0 then sum(ICalc.Discount*PCalc.Rate)/sum((ICalc.Gross+ICalc.Discount-ICalc.Loading)*PCalc.Rate)*100 else 0 end,
 @RLoading = Case When sum((ICalc.Gross-ICalc.Loading)*PCalc.Rate)<>0 then sum(ICalc.Gross*PCalc.Rate)/sum((ICalc.Gross-ICalc.Loading)*PCalc.Rate) else 1 end 
 From 
 Acceptance 
 Inner Join Cover on (Cover.CNO=Acceptance.CNO) 
 Inner Join Systab on (1=1)
 Inner Join ICalc on (ICalc.ANO=Acceptance.ANO and ICalc.Gross<>0 and (@P_Period=0 or @P_Period=DateDiff(month, Acceptance.SDate, ICalc.SDate) / 12 + 1))
 Inner join RCALC on (ICALC.ANO=RCALC.ANO AND ICALC.CURRENCY=RCALC.CURRENCY AND ICALC.CODE=RCALC.CODE AND ICALC.TOR=RCALC.TOR AND ICALC.SDATE=RCALC.SDATE AND ICALC.EDATE=RCALC.EDATE AND ICALC.SANO=RCALC.SANO)     
 Inner join PCALC on (PCALC.ANO=ICALC.ANO AND PCALC.CURRENCY=ICALC.CURRENCY)     
 Where Acceptance.ANO=@P_ANO                                
       
 Select @GDiscount=GDiscount, @PDiscount=PDiscount, @Discount=Discount from Payor_Discount(@P_ANO,@P_Code,@P_Period)        
 --Select @RDiscount=Discount, @RLoading=Loading from Rate_Discount(@P_ANO,@P_Code)                
 --Select @MShare=dbo.Member_Share(@P_ANO)                                     
 
 if @LANO=-1	
 BEGIN
	  Select @GrossUpComm=
	  sum(
	  Case 
	  When coalesce(AccBSDet.FeeAmount,AccBS.FeeAmount)<>0 and @Gross<>0 Then
		  coalesce(AccBSDet.FeeAmount,AccBS.FeeAmount*@Gross/@TotalGross)/@Gross*100 
	  else
	  	  coalesce(AccBSDet.Fee,AccBS.Fee)
	  end
	  *(
	  Case 
	  When GrossUpF=1 Then 1 
	  else -- NetUpF (Net after VAT and TAX)
		(
		100 +
		(case when @ADate<MParam.Effective then MParam.VatOLD else MParam.Vat end)*(Case When Profile.VATF=1 Then 1 else 0 end)
		-
		Case 
		When TaxType.MTaxType='PASAL21' then MParam.PASAL21*(100-MParam.TAXDISCOUNT)/100
		When TaxType.MTaxType='PASAL23' then MParam.PASAL23
		When TaxType.MTaxType='PASAL26' then MParam.Pasal26
		When TaxType.MTaxType='PASAL4' then MParam.PASAL4
		else 0
		end 
		*(Case When Profile.TaxPCT=0 Then 1 else Profile.TaxPCT/100 end)
		*(Case When Profile.TaxF=1 Then 1 else 0 end)
		)/100
	  end)
	  + AccBS.UpFee)
	  from Acceptance   
	  inner join AccBS on (AccBS.ANO=Acceptance.ANO and AccBS.NoProrataF=0)   
	  Left Join AccBSDet on ((AccBSDet.Period=0 or AccBSDet.Period=@P_Period) and AccBSDet.ID=AccBS.ID and AccBSDet.BSType=AccBS.BSType and AccBSDet.ANO=AccBS.ANO and AccBSDet.Code=@P_Code and AccBSDet.InceptionF=0)  
	  Inner Join MParam on (MParam.Type='B'+AccBS.BSType)
	  Inner Join Profile on (Profile.ID=AccBS.ID)
	  Left Join TaxType on (TaxType.TaxType=Profile.TaxType)
	  Where Acceptance.ANO=@P_ANO and (AccBS.GrossUpF=1 or AccBS.NetUpF=1)  
          
	  if @GrossUpComm is null    
		 Select @GrossUpComm=0              
		 
	  Select @TAX=
	   sum(  
	   (  
		Case 
		When coalesce(AccBSDet.FeeAmount,AccBS.FeeAmount)<>0 and @Gross<>0 Then
			coalesce(AccBSDet.FeeAmount,AccBS.FeeAmount*@Gross/@TotalGross)/@Gross*100 
			/
			(
			Case 
			When AccBS.GrossF=1 then 
				1/@RLoading*100/(100-@RDiscount)  
			When AccBS.GrossBLF=1 Then
				1/@RLoading
			else  
				1 
			end 
			*
			(Case When AccBS.NetF=1 then (1-@Discount/100) When AccBS.NetGroupF=1 then (1-@GDiscount/100) else 1 end)
			)	   
		else
	  		coalesce(AccBSDet.Fee,AccBS.Fee)
			*
			(
			Case 
			When AccBS.GrossF=1 then 
				1/@RLoading*100/(100-@RDiscount)  
			When AccBS.GrossBLF=1 Then
				1/@RLoading
			else  
				1 
			end 
			*
			(Case When AccBS.NetF=1 then (1-@Discount/100) When AccBS.NetGroupF=1 then (1-@GDiscount/100) else 1 end)
			)	   
		end
		* (1-(Case When AccBS.GrossUpF=0 and AccBS.NetUpF=0 Then (@GrossUpComm)/100 else 0 end))    
		+(-(Case When @ADiscount=0 then AccBS.Discount else @ADiscount end)+AccBS.UpFee)*(Case When AccBS.GrossUpF=0 and AccBS.NetUpF=0 Then (100-@GrossUpComm)/100 else 1 end)     
	   )
	   --*(Case When AccBS.MemberF=1 or AccBS.MemberFeeF=1 Then (1-@MShare/100) else 1 end) 
	   *(Case When (Case When (coalesce(Profile.TaxHSDate,'01/01/1900')<= @ADate and coalesce(Profile.TaxHEDate,'01/01/1900')>= @ADate) Then cast(0 as Bit) else Profile.TaxF end)=1 Then (Case When TaxType.MTaxType='PASAL21' then MParam.Pasal21*(100-MParam.TaxDiscount)/100 When TaxType.MTaxType='PASAL23' then MParam.Pasal23 When TaxType.MTaxType='PASAL26' then MParam.Pasal26 When TaxType.MTaxType='PASAL4' then MParam.Pasal4 else TaxType.TaxRate end)/100*(Case When Profile.TaxPCT=0 Then 1 else TaxPCT/100 end) else 0 end)    
	   )     
	  From Acceptance
	  Inner Join AccBS on (AccBS.ANO=Acceptance.ANO and AccBS.NoProrataF=0)
	  Left Join AccBSDet on ((AccBSDet.Period=0 or AccBSDet.Period=@P_Period) and AccBSDet.ID=AccBS.ID and AccBSDet.BSType=AccBS.BSType and AccBSDet.ANO=AccBS.ANO and AccBSDet.Code=@P_Code and AccBSDet.InceptionF=0)
	  Inner Join MParam on (MParam.Type='B'+AccBS.BSType)
	  Inner Join Profile on (Profile.ID=AccBS.ID)
	  Left Join TaxType on (TaxType.TaxType=Profile.TaxType)
	  Where Acceptance.ANO=@P_ANO 
	  and (AccBS.NotMinimumPremiumF=0 or (AccBS.NotMinimumPremiumF=1 and @P_MinimumPremiumF=0))                   
 END
 ELSE
 BEGIN
	 Select Top 1 @DetailF=1 from AAccBS Where ANO=@P_ANO                        
	 if @DetailF is null         
	 Begin
		if @RegNo='' or @AStatus in ('W','T')   
		Begin	
		  Select @GrossUpComm=
		  sum(
		  Case 
		  When coalesce(AccBSDet.FeeAmount,AccBS.FeeAmount)<>0 and @Gross<>0 Then
			  coalesce(AccBSDet.FeeAmount,AccBS.FeeAmount*@Gross/@TotalGross)/@Gross*100 
		  else
	  		  coalesce(AccBSDet.Fee,AccBS.Fee)
		  end
		  *(
		  Case 
		  When GrossUpF=1 Then 1 
		  else -- NetUpF (Net after VAT and TAX)
			(
			100 +
			(case when @ADate<MParam.Effective then MParam.VatOLD else MParam.Vat end)*(Case When Profile.VATF=1 Then 1 else 0 end)
			-
			Case 
			When TaxType.MTaxType='PASAL21' then MParam.PASAL21*(100-MParam.TAXDISCOUNT)/100
			When TaxType.MTaxType='PASAL23' then MParam.PASAL23
			When TaxType.MTaxType='PASAL26' then MParam.Pasal26
			When TaxType.MTaxType='PASAL4' then MParam.PASAL4
			else 0
			end 
			*(Case When Profile.TaxPCT=0 Then 1 else Profile.TaxPCT/100 end)
			*(Case When Profile.TaxF=1 Then 1 else 0 end)
			)/100
		  end)
		  + AccBS.UpFee)
		  from Acceptance   
		  Inner Join Acceptance mAcceptance on (mAcceptance.ANO=mAcceptance.LANO and mAcceptance.ANO=Acceptance.LANO)		  
		  inner join AccBS on (AccBS.ANO=mAcceptance.ANO and AccBS.NoProrataF=0)   
		  Left Join AccBSDet on ((AccBSDet.Period=0 or AccBSDet.Period=@P_Period) and AccBSDet.ID=AccBS.ID and AccBSDet.BSType=AccBS.BSType and AccBSDet.ANO=AccBS.ANO and AccBSDet.Code=@P_Code and AccBSDet.InceptionF=0)  
		  Inner Join MParam on (MParam.Type='B'+AccBS.BSType)
		 
		  Inner Join Profile on (Profile.ID=AccBS.ID)
		  Left Join TaxType on (TaxType.TaxType=Profile.TaxType)
		  Where Acceptance.ANO=@P_ANO and (AccBS.GrossUpF=1 or AccBS.NetUpF=1)  		

		  if @GrossUpComm is null    
			 Select @GrossUpComm=0              
		  
		  Select @TAX=
		   sum(  
		   (  
			Case 
			When coalesce(AccBSDet.FeeAmount,AccBS.FeeAmount)<>0 and @Gross<>0 Then
				coalesce(AccBSDet.FeeAmount,AccBS.FeeAmount*@Gross/@TotalGross)/@Gross*100 
				/
				(
				Case 
				When AccBS.GrossF=1 then 
					1/@RLoading*100/(100-@RDiscount)  
				When AccBS.GrossBLF=1 Then
					1/@RLoading
				else  
					1 
				end 
				*
				(Case When AccBS.NetF=1 then (1-@Discount/100) When AccBS.NetGroupF=1 then (1-@GDiscount/100) else 1 end)
				)	   
			else
	  			coalesce(AccBSDet.Fee,AccBS.Fee)
				*
				(
				Case 
				When AccBS.GrossF=1 then 
					1/@RLoading*100/(100-@RDiscount)  
				When AccBS.GrossBLF=1 Then
					1/@RLoading
				else  
					1 
				end 
				*
				(Case When AccBS.NetF=1 then (1-@Discount/100) When AccBS.NetGroupF=1 then (1-@GDiscount/100) else 1 end)
				)	   
			end
			* (1-(Case When AccBS.GrossUpF=0 and AccBS.NetUpF=0 Then (@GrossUpComm)/100 else 0 end))    
			+(-(Case When @ADiscount=0 then AccBS.Discount else @ADiscount end)+AccBS.UpFee)*(Case When AccBS.GrossUpF=0 and AccBS.NetUpF=0 Then (100-@GrossUpComm)/100 else 1 end)     
		   )
		   --*(Case When AccBS.MemberF=1 or AccBS.MemberFeeF=1 Then (1-@MShare/100) else 1 end) 
		   *(Case When (Case When (coalesce(Profile.TaxHSDate,'01/01/1900')<= @ADate and coalesce(Profile.TaxHEDate,'01/01/1900')>= @ADate) Then cast(0 as Bit) else Profile.TaxF end)=1 Then (Case When TaxType.MTaxType='PASAL21' then MParam.Pasal21*(100-MParam.TaxDiscount)/100 When TaxType.MTaxType='PASAL23' then MParam.Pasal23 When TaxType.MTaxType='PASAL26' then MParam.Pasal26 When TaxType.MTaxType='PASAL4' then MParam.Pasal4 else TaxType.TaxRate end)/100*(Case When Profile.TaxPCT=0 Then 1 else TaxPCT/100 end) else 0 end)    
		   )     
		  From Acceptance
		  Inner Join Acceptance mAcceptance on (mAcceptance.ANO=mAcceptance.LANO and mAcceptance.ANO=Acceptance.LANO)		  		  
		  Inner Join AccBS on (AccBS.ANO=mAcceptance.ANO and AccBS.NoProrataF=0)
		  Left Join AccBSDet on ((AccBSDet.Period=0 or AccBSDet.Period=@P_Period) and AccBSDet.ID=AccBS.ID and AccBSDet.BSType=AccBS.BSType and AccBSDet.ANO=AccBS.ANO and AccBSDet.Code=@P_Code and AccBSDet.InceptionF=0)
		  Inner Join MParam on (MParam.Type='B'+AccBS.BSType)
		  Inner Join Profile on (Profile.ID=AccBS.ID)
		  Left Join TaxType on (TaxType.TaxType=Profile.TaxType)
		  Where Acceptance.ANO=@P_ANO 
		  and (AccBS.NotMinimumPremiumF=0 or (AccBS.NotMinimumPremiumF=1 and @P_MinimumPremiumF=0))                   		  		  
		end
		else
		Begin
		  Select @GrossUpComm=
		  sum(
		  Case 
		  When coalesce(AccBSDet.FeeAmount,AccBS.FeeAmount)<>0 and @Gross<>0 Then
			  coalesce(AccBSDet.FeeAmount,AccBS.FeeAmount*@Gross/@TotalGross)/@Gross*100 
		  else
	  		  coalesce(AccBSDet.Fee,AccBS.Fee)
		  end
		  *(
		  Case 
		  When GrossUpF=1 Then 1 
		  else -- NetUpF (Net after VAT and TAX)
			(
			100 +
			(case when @ADate<MParam.Effective then MParam.VatOLD else MParam.Vat end)*(Case When Profile.VATF=1 Then 1 else 0 end)
			-
			Case 
			When TaxType.MTaxType='PASAL21' then MParam.PASAL21*(100-MParam.TAXDISCOUNT)/100
			When TaxType.MTaxType='PASAL23' then MParam.PASAL23
			When TaxType.MTaxType='PASAL26' then MParam.Pasal26
			When TaxType.MTaxType='PASAL4' then MParam.PASAL4
			else 0
			end 
			*(Case When Profile.TaxPCT=0 Then 1 else Profile.TaxPCT/100 end)
			*(Case When Profile.TaxF=1 Then 1 else 0 end)
			)/100
		  end)
		  + AccBS.UpFee)
		  from Acceptance   
		  Inner Join Acceptance mAcceptance on (mAcceptance.ANO=mAcceptance.LANO and ((mAcceptance.RegNo<>'' and mAcceptance.RegNo=Acceptance.RegNo)))
		  inner join AccBS on (AccBS.ANO=mAcceptance.ANO and AccBS.NoProrataF=0)   
		  Left Join AccBSDet on ((AccBSDet.Period=0 or AccBSDet.Period=@P_Period) and AccBSDet.ID=AccBS.ID and AccBSDet.BSType=AccBS.BSType and AccBSDet.ANO=AccBS.ANO and AccBSDet.Code=@P_Code and AccBSDet.InceptionF=0)  
		  Inner Join MParam on (MParam.Type='B'+AccBS.BSType)
		  Inner Join Profile on (Profile.ID=AccBS.ID)
		  Left Join TaxType on (TaxType.TaxType=Profile.TaxType)
		  Where Acceptance.ANO=@P_ANO and (AccBS.GrossUpF=1 or AccBS.NetUpF=1)  		

		  if @GrossUpComm is null    
			 Select @GrossUpComm=0              
		  
		  Select @TAX=
		   sum(  
		   (  
			Case 
			When coalesce(AccBSDet.FeeAmount,AccBS.FeeAmount)<>0 and @Gross<>0 Then
				coalesce(AccBSDet.FeeAmount,AccBS.FeeAmount*@Gross/@TotalGross)/@Gross*100 
				/
				(
				Case 
				When AccBS.GrossF=1 then 
					1/@RLoading*100/(100-@RDiscount)  
				When AccBS.GrossBLF=1 Then
					1/@RLoading
				else  
					1 
				end 
				*
				(Case When AccBS.NetF=1 then (1-@Discount/100) When AccBS.NetGroupF=1 then (1-@GDiscount/100) else 1 end)
				)	   
			else
	  			coalesce(AccBSDet.Fee,AccBS.Fee)
				*
				(
				Case 
				When AccBS.GrossF=1 then 
					1/@RLoading*100/(100-@RDiscount)  
				When AccBS.GrossBLF=1 Then
					1/@RLoading
				else  
					1 
				end 
				*
				(Case When AccBS.NetF=1 then (1-@Discount/100) When AccBS.NetGroupF=1 then (1-@GDiscount/100) else 1 end)
				)	   
			end
			* (1-(Case When AccBS.GrossUpF=0 and AccBS.NetUpF=0 Then (@GrossUpComm)/100 else 0 end))    
			+(-(Case When @ADiscount=0 then AccBS.Discount else @ADiscount end)+AccBS.UpFee)*(Case When AccBS.GrossUpF=0 and AccBS.NetUpF=0 Then (100-@GrossUpComm)/100 else 1 end)     
		   )
		   --*(Case When AccBS.MemberF=1 or AccBS.MemberFeeF=1 Then (1-@MShare/100) else 1 end) 
		   *(Case When (Case When (coalesce(Profile.TaxHSDate,'01/01/1900')<= @ADate and coalesce(Profile.TaxHEDate,'01/01/1900')>= @ADate) Then cast(0 as Bit) else Profile.TaxF end)=1 Then (Case When TaxType.MTaxType='PASAL21' then MParam.Pasal21*(100-MParam.TaxDiscount)/100 When TaxType.MTaxType='PASAL23' then MParam.Pasal23 When TaxType.MTaxType='PASAL26' then MParam.Pasal26 When TaxType.MTaxType='PASAL4' then MParam.Pasal4 else TaxType.TaxRate end)/100*(Case When Profile.TaxPCT=0 Then 1 else TaxPCT/100 end) else 0 end)    
		   )     
		  From Acceptance
		  Inner Join Acceptance mAcceptance on (mAcceptance.ANO=mAcceptance.LANO and ((mAcceptance.RegNo<>'' and mAcceptance.RegNo=Acceptance.RegNo)))
		  Inner Join AccBS on (AccBS.ANO=mAcceptance.ANO and AccBS.NoProrataF=0)
		  Left Join AccBSDet on ((AccBSDet.Period=0 or AccBSDet.Period=@P_Period) and AccBSDet.ID=AccBS.ID and AccBSDet.BSType=AccBS.BSType and AccBSDet.ANO=AccBS.ANO and AccBSDet.Code=@P_Code and AccBSDet.InceptionF=0)
		  Inner Join MParam on (MParam.Type='B'+AccBS.BSType)
		  Inner Join Profile on (Profile.ID=AccBS.ID)
		  Left Join TaxType on (TaxType.TaxType=Profile.TaxType)
		  Where Acceptance.ANO=@P_ANO 
		  and (AccBS.NotMinimumPremiumF=0 or (AccBS.NotMinimumPremiumF=1 and @P_MinimumPremiumF=0))    		  		
		end
	 end
	 else
	 Begin
		  Select @GrossUpComm=
		  sum(
		  Case 
		  When coalesce(AAccBSDet.FeeAmount,AAccBS.FeeAmount)<>0 and @Gross<>0 Then
			  coalesce(AAccBSDet.FeeAmount,AAccBS.FeeAmount*@Gross/@TotalGross)*100/@Gross 
		  else
	  		  coalesce(AAccBSDet.Fee,AAccBS.Fee)
		  end
		  *(
		  Case 
		  When GrossUpF=1 Then 1 
		  else -- NetUpF (Net after VAT and TAX)
			(
			100 +
			(case when @ADate<MParam.Effective then MParam.VatOLD else MParam.Vat end)*(Case When Profile.VATF=1 Then 1 else 0 end)
			-
			Case 
			When TaxType.MTaxType='PASAL21' then MParam.PASAL21*(100-MParam.TAXDISCOUNT)/100
			When TaxType.MTaxType='PASAL23' then MParam.PASAL23
			When TaxType.MTaxType='PASAL26' then MParam.Pasal26
			When TaxType.MTaxType='PASAL4' then MParam.PASAL4
			else 0
			end 
			*(Case When Profile.TaxPCT=0 Then 1 else Profile.TaxPCT/100 end)
			*(Case When Profile.TaxF=1 Then 1 else 0 end)
			)/100
		  end)
		  + AAccBS.UpFee)

		  From AAccBS 
		  Left Join AAccBSDet on ((AAccBSDet.Period=0 or AAccBSDet.Period=@P_Period) and AAccBSDet.ID=AAccBS.ID and AAccBSDet.BSType=AAccBS.BSType and AAccBSDet.ANO=AAccBS.ANO and AAccBSDet.Code=@P_Code)   
		  Inner Join MParam on (MParam.Type='B'+AAccBS.BSType)
		  Inner Join Profile on (Profile.ID=AAccBS.ID)
		  Left Join TaxType on (TaxType.TaxType=Profile.TaxType)
		  Where AAccBS.ANO=@P_ANO and (AAccBS.GrossUpF=1 or AAccBS.NetUpF=1)    	 
		  
		  if @GrossUpComm is null    
			 Select @GrossUpComm=0              		  
			 
		  Select @TAX=
		   sum(  
		   (  
			Case 
			When coalesce(AccBSDet.FeeAmount,AccBS.FeeAmount)<>0 and @Gross<>0 Then
				coalesce(AccBSDet.FeeAmount,AccBS.FeeAmount*@Gross/@TotalGross)/@Gross*100 
				/
				(
				Case 
				When AccBS.GrossF=1 then 
					1/@RLoading*100/(100-@RDiscount)  
				When AccBS.GrossBLF=1 Then
					1/@RLoading
				else  
					1 
				end 
				*
				(Case When AccBS.NetF=1 then (1-@Discount/100) When AccBS.NetGroupF=1 then (1-@GDiscount/100) else 1 end)
				)	   
			else
	  			coalesce(AccBSDet.Fee,AccBS.Fee)
				*
				(
				Case 
				When AccBS.GrossF=1 then 
					1/@RLoading*100/(100-@RDiscount)  
				When AccBS.GrossBLF=1 Then
					1/@RLoading
				else  
					1 
				end 
				*
				(Case When AccBS.NetF=1 then (1-@Discount/100) When AccBS.NetGroupF=1 then (1-@GDiscount/100) else 1 end)
				)	   
			end
			* (1-(Case When AccBS.GrossUpF=0 and AccBS.NetUpF=0 Then (@GrossUpComm)/100 else 0 end))    
			+(-(Case When @ADiscount=0 then AccBS.Discount else @ADiscount end)+AccBS.UpFee)*(Case When AccBS.GrossUpF=0 and AccBS.NetUpF=0 Then (100-@GrossUpComm)/100 else 1 end)     
		   )
		   --*(Case When AccBS.MemberF=1 or AccBS.MemberFeeF=1 Then (1-@MShare/100) else 1 end) 
		   *(Case When (Case When (coalesce(Profile.TaxHSDate,'01/01/1900')<= @ADate and coalesce(Profile.TaxHEDate,'01/01/1900')>= @ADate) Then cast(0 as Bit) else Profile.TaxF end)=1 Then (Case When TaxType.MTaxType='PASAL21' then MParam.Pasal21*(100-MParam.TaxDiscount)/100 When TaxType.MTaxType='PASAL23' then MParam.Pasal23 When TaxType.MTaxType='PASAL26' then MParam.Pasal26 When TaxType.MTaxType='PASAL4' then MParam.Pasal4 else TaxType.TaxRate end)/100*(Case When Profile.TaxPCT=0 Then 1 else TaxPCT/100 end) else 0 end)    
		   )     
		  From Acceptance
		  Inner Join AAccBS AccBS on (AccBS.ANO=Acceptance.ANO and AccBS.NoProrataF=0)
		  Left Join AAccBSDet AccBSDet on ((AccBSDet.Period=0 or AccBSDet.Period=@P_Period) and AccBSDet.ID=AccBS.ID and AccBSDet.BSType=AccBS.BSType and AccBSDet.ANO=AccBS.ANO and AccBSDet.Code=@P_Code)
		  Inner Join MParam on (MParam.Type='B'+AccBS.BSType)
		  Inner Join Profile on (Profile.ID=AccBS.ID)
		   Left Join TaxType on (TaxType.TaxType=Profile.TaxType)
		  Where Acceptance.ANO=@P_ANO 
		  and (AccBS.NotMinimumPremiumF=0 or (AccBS.NotMinimumPremiumF=1 and @P_MinimumPremiumF=0))                      
	 end
 
 END                       

 if @TAX is null                
   Select @TAX=0                
                        
 return(@TAX)                
End        

GO


DROP Function Premium_Commission_Table
GO
CREATE Function Premium_Commission_Table(@P_ANO as int,@P_Code as varchar(10),@P_Period Int, @P_MinimumPremiumF Bit)                
RETURNS @Commission_Table Table(ADate smalldatetime, ID varchar(10), BSType varchar(10), OBSType varchar(10), NoRefundF Bit, Commission Float)           
AS                
BEGIN                  
 Declare @GDiscount Float                
 Declare @PDiscount Float                
 Declare @Discount Float                
 Declare @RDiscount Float                
 Declare @RLoading Float
 Declare @ADiscount Float                
 Declare @MShare Float                
 Declare @Commission Float        
 Declare @DetailF bit               
 Declare @RegNo varchar(50)        
 Declare @AStatus varchar(1)        
 Declare @LANO int   
 Declare @OANO int
 Declare @GrossUpComm Float      
 Declare @ADate smalldatetime
 Declare @VatSubsidiesF Bit
 Declare @Gross Float
 Declare @TotalGross Float
 Declare @NumCCY Int
       
 Select 
 @VatSubsidiesF=cast(Max(cast(Systab.VATSubsidiesF as Int)) as Bit), 
 @ADate=Max(case when Acceptance.AUserID<>'' then Acceptance.ADate else cast(convert(varchar(10), getdate(),1) as smalldatetime) end), 
 @ADiscount=Max(Acceptance.Discount), 
 @RegNo=Max(Acceptance.RegNo), 
 @Astatus=Max(Acceptance.AStatus), 
 @LANO=Max(Acceptance.LANO), 
 @OANO=Max(Acceptance.OANO),
 @NumCCY=coalesce(count(distinct PCalc.Currency),1),
 @Gross=Case 
		When coalesce(count(distinct PCalc.Currency),1)=1 Then
			-- in Original Currency
			coalesce(sum(Case When ICalc.Code=@P_Code then 1 else 0 end*Case When (PCALC.Description<>'' and PCALC.Description<>'Minimum Premium') then ICALC.GROSS*PCALC.GROSS/PCALC.OGROSS else ICALC.GROSS*RCALC.GROSS/RCALC.OGROSS end),0)
		else
			coalesce(sum(Case When ICalc.Code=@P_Code then 1 else 0 end*Case When (PCALC.Description<>'' and PCALC.Description<>'Minimum Premium') then ICALC.GROSS*PCALC.GROSS/PCALC.OGROSS*PCALC.RATE else ICALC.GROSS*RCALC.GROSS/RCALC.OGROSS*PCALC.RATE end),0)
		End,
 @TotalGross=Case 
		When coalesce(count(distinct PCalc.Currency),1)=1 Then
			-- in Original Currency
			coalesce(sum(Case When (PCALC.Description<>'' and PCALC.Description<>'Minimum Premium') then ICALC.GROSS*PCALC.GROSS/PCALC.OGROSS else ICALC.GROSS*RCALC.GROSS/RCALC.OGROSS end),0)
		else
			coalesce(sum(Case When (PCALC.Description<>'' and PCALC.Description<>'Minimum Premium') then ICALC.GROSS*PCALC.GROSS/PCALC.OGROSS*PCALC.RATE else ICALC.GROSS*RCALC.GROSS/RCALC.OGROSS*PCALC.RATE end),0)
		End,
 @RDiscount = Case When sum((ICalc.Gross+ICalc.Discount-ICalc.Loading)*PCalc.Rate)<>0 then sum(ICalc.Discount*PCalc.Rate)/sum((ICalc.Gross+ICalc.Discount-ICalc.Loading)*PCalc.Rate)*100 else 0 end,
 @RLoading = Case When sum((ICalc.Gross-ICalc.Loading)*PCalc.Rate)<>0 then sum(ICalc.Gross*PCalc.Rate)/sum((ICalc.Gross-ICalc.Loading)*PCalc.Rate) else 1 end 
 From 
 Acceptance 
 Inner Join Cover on (Cover.CNO=Acceptance.CNO) 
 Inner Join Systab on (1=1)
 Inner Join ICalc on (ICalc.ANO=Acceptance.ANO and ICalc.Gross<>0 and (@P_Period=0 or @P_Period=DateDiff(month, Acceptance.SDate, ICalc.SDate) / 12 + 1))
 Inner join RCALC on (ICALC.ANO=RCALC.ANO AND ICALC.CURRENCY=RCALC.CURRENCY AND ICALC.CODE=RCALC.CODE AND ICALC.TOR=RCALC.TOR AND ICALC.SDATE=RCALC.SDATE AND ICALC.EDATE=RCALC.EDATE AND ICALC.SANO=RCALC.SANO)     
 Inner join PCALC on (PCALC.ANO=ICALC.ANO AND PCALC.CURRENCY=ICALC.CURRENCY)     
 Where Acceptance.ANO=@P_ANO
         
 Select @GDiscount=GDiscount, @PDiscount=PDiscount, @Discount=Discount from Payor_Discount(@P_ANO,@P_Code,@P_Period)        
 --Select @RDiscount=Discount, @RLoading=Loading from Rate_Discount(@P_ANO,@P_Code)                
 --Select @MShare=dbo.Member_Share(@P_ANO)                                     
 
 if @LANO=-1	
 BEGIN
	  Select @GrossUpComm=
	  sum(
	  Case 
	  When coalesce(AccBSDet.FeeAmount,AccBS.FeeAmount)<>0 and @Gross<>0 Then
		  coalesce(AccBSDet.FeeAmount,AccBS.FeeAmount*@Gross/@TotalGross)/@Gross*100 
	  else
	  	  coalesce(AccBSDet.Fee,AccBS.Fee)
	  end
	  *(
	  Case 
	  When GrossUpF=1 Then 1 
	  else -- NetUpF (Net after VAT and TAX)
		(
		100 +
		(case when @ADate<MParam.Effective then MParam.VatOLD else MParam.Vat end)*(Case When Profile.VATF=1 Then 1 else 0 end)
		-
		Case 
		When TaxType.MTaxType='PASAL21' then MParam.PASAL21*(100-MParam.TAXDISCOUNT)/100
		When TaxType.MTaxType='PASAL23' then MParam.PASAL23
		When TaxType.MTaxType='PASAL26' then MParam.Pasal26
		When TaxType.MTaxType='PASAL4' then MParam.PASAL4
		else 0
		end 
		*(Case When Profile.TaxPCT=0 Then 1 else Profile.TaxPCT/100 end)
		*(Case When Profile.TaxF=1 Then 1 else 0 end)
		)/100
	  end)
	  + AccBS.UpFee)
	  from Acceptance   
	  inner join AccBS on (AccBS.ANO=Acceptance.ANO and AccBS.NoProrataF=0)   
	  Left Join AccBSDet on ((AccBSDet.Period=0 or AccBSDet.Period=@P_Period) and AccBSDet.ID=AccBS.ID and AccBSDet.BSType=AccBS.BSType and AccBSDet.ANO=AccBS.ANO and AccBSDet.Code=@P_Code and AccBSDet.InceptionF=0)  
	  Inner Join MParam on (MParam.Type='B'+AccBS.BSType)
	  Inner Join Profile on (Profile.ID=AccBS.ID)
	  Left Join TaxType on (TaxType.TaxType=Profile.TaxType)
	  Where Acceptance.ANO=@P_ANO and (AccBS.GrossUpF=1 or AccBS.NetUpF=1)  
          
	  if @GrossUpComm is null    
		 Select @GrossUpComm=0              
		 
	  Insert into @Commission_Table(ADate, ID, BSType, OBSType, NoRefundF, Commission)
	  Select @ADate, ACCBS.ID, ACCBS.BSType, Max(OBSType) as OBSType, cast(Max(cast(ACCBS.NoRefundF as Int)) as Bit),
	   sum(  
	   (	  
		Case 
		When coalesce(AccBSDet.FeeAmount,AccBS.FeeAmount)<>0 and @Gross<>0 Then
			coalesce(AccBSDet.FeeAmount,AccBS.FeeAmount*@Gross/@TotalGross)/@Gross*100 
			/
			(
			Case 
			When AccBS.GrossF=1 then 
				1/@RLoading*100/(100-@RDiscount)  
			When AccBS.GrossBLF=1 Then
				1/@RLoading
			else  
				1 
			end 
			*
			(Case When AccBS.NetF=1 then (1-@Discount/100) When AccBS.NetGroupF=1 then (1-@GDiscount/100) else 1 end)
			)	   
		else
	  		coalesce(AccBSDet.Fee,AccBS.Fee)
			*
			(
			Case 
			When AccBS.GrossF=1 then 
				1/@RLoading*100/(100-@RDiscount)  
			When AccBS.GrossBLF=1 Then
				1/@RLoading
			else  
				1 
			end 
			*
			(Case When AccBS.NetF=1 then (1-@Discount/100) When AccBS.NetGroupF=1 then (1-@GDiscount/100) else 1 end)
			)	   
		end
		* (1-(Case When AccBS.GrossUpF=0 and AccBS.NetUpF=0 Then (@GrossUpComm)/100 else 0 end))    	  
		+(-(Case When @ADiscount=0 then AccBS.Discount else @ADiscount end)+AccBS.UpFee)*(Case When AccBS.GrossUpF=0 and AccBS.NetUpF=0 Then (100-@GrossUpComm)/100 else 1 end)     
	   )
	   --*(Case When AccBS.MemberF=1 or AccBS.MemberFeeF=1 Then (1-@MShare/100) else 1 end)  
	   )     
	  From Acceptance
	  Inner Join AccBS on (AccBS.ANO=Acceptance.ANO and AccBS.NoProrataF=0)
	  Left Join AccBSDet on ((AccBSDet.Period=0 or AccBSDet.Period=@P_Period) and AccBSDet.ID=AccBS.ID and AccBSDet.BSType=AccBS.BSType and AccBSDet.ANO=AccBS.ANO and AccBSDet.Code=@P_Code and AccBSDet.InceptionF=0)
	  Where Acceptance.ANO=@P_ANO 
	  and (AccBS.NotMinimumPremiumF=0 or (AccBS.NotMinimumPremiumF=1 and @P_MinimumPremiumF=0))                   
	  Group By ACCBS.ID, ACCBS.BSType
 END
 ELSE
 BEGIN
	 Select Top 1 @DetailF=1 from AAccBS Where ANO=@P_ANO        
	 if @DetailF is null         
	 Begin
		if @RegNo='' or @AStatus in ('W','T')   
		Begin	
		  Select @GrossUpComm=
		  sum(
		  Case 
		  When coalesce(AccBSDet.FeeAmount,AccBS.FeeAmount)<>0 and @Gross<>0 Then
			  coalesce(AccBSDet.FeeAmount,AccBS.FeeAmount*@Gross/@TotalGross)/@Gross*100 
		  else
	  		  coalesce(AccBSDet.Fee,AccBS.Fee)
		  end
		  *(
		  Case 
		  When GrossUpF=1 Then 1 
		  else -- NetUpF (Net after VAT and TAX)
			(
			100 +
			(case when @ADate<MParam.Effective then MParam.VatOLD else MParam.Vat end)*(Case When Profile.VATF=1 Then 1 else 0 end)
			-
			Case 
			When TaxType.MTaxType='PASAL21' then MParam.PASAL21*(100-MParam.TAXDISCOUNT)/100
			When TaxType.MTaxType='PASAL23' then MParam.PASAL23
			When TaxType.MTaxType='PASAL26' then MParam.Pasal26
			When TaxType.MTaxType='PASAL4' then MParam.PASAL4
			else 0
			end 
			*(Case When Profile.TaxPCT=0 Then 1 else Profile.TaxPCT/100 end)
			*(Case When Profile.TaxF=1 Then 1 else 0 end)
			)/100
		  end)
		  + AccBS.UpFee)
		  from Acceptance   
		  Inner Join Acceptance mAcceptance on (mAcceptance.ANO=mAcceptance.LANO and mAcceptance.ANO=Acceptance.LANO)		  
		  inner join AccBS on (AccBS.ANO=mAcceptance.ANO and AccBS.NoProrataF=0)   
		  Left Join AccBSDet on ((AccBSDet.Period=0 or AccBSDet.Period=@P_Period) and AccBSDet.ID=AccBS.ID and AccBSDet.BSType=AccBS.BSType and AccBSDet.ANO=AccBS.ANO and AccBSDet.Code=@P_Code and AccBSDet.InceptionF=0)  
		  Inner Join MParam on (MParam.Type='B'+AccBS.BSType)
		  Inner Join Profile on (Profile.ID=AccBS.ID)
		  Left Join TaxType on (TaxType.TaxType=Profile.TaxType)
		  Where Acceptance.ANO=@P_ANO and (AccBS.GrossUpF=1 or AccBS.NetUpF=1)  		

		  if @GrossUpComm is null    
			 Select @GrossUpComm=0              
		  
		   Insert into @Commission_Table(ADate, ID, BSType, OBSType, NoRefundF, Commission)
		   Select @ADate, ACCBS.ID, ACCBS.BSType, Max(OBSType) as OBSType, cast(Max(cast(ACCBS.NoRefundF as Int)) as Bit),
		   sum(  
		   (  
			Case 
			When coalesce(AccBSDet.FeeAmount,AccBS.FeeAmount)<>0 and @Gross<>0 Then
				coalesce(AccBSDet.FeeAmount,AccBS.FeeAmount*@Gross/@TotalGross)/@Gross*100 
				/
				(
				Case 
				When AccBS.GrossF=1 then 
					1/@RLoading*100/(100-@RDiscount)  
				When AccBS.GrossBLF=1 Then
					1/@RLoading
				else  
					1 
				end 
				*
				(Case When AccBS.NetF=1 then (1-@Discount/100) When AccBS.NetGroupF=1 then (1-@GDiscount/100) else 1 end)
				)	   
			else
	  			coalesce(AccBSDet.Fee,AccBS.Fee)
				*
				(
				Case 
				When AccBS.GrossF=1 then 
					1/@RLoading*100/(100-@RDiscount)  
				When AccBS.GrossBLF=1 Then
					1/@RLoading
				else  
					1 
				end 
				*
				(Case When AccBS.NetF=1 then (1-@Discount/100) When AccBS.NetGroupF=1 then (1-@GDiscount/100) else 1 end)
				)	   
			end
			* (1-(Case When AccBS.GrossUpF=0 and AccBS.NetUpF=0 Then (@GrossUpComm)/100 else 0 end))  			     
			+(-(Case When @ADiscount=0 then AccBS.Discount else @ADiscount end)+AccBS.UpFee)*(Case When AccBS.GrossUpF=0 and AccBS.NetUpF=0 Then (100-@GrossUpComm)/100 else 1 end)     
		   )
		   --*(Case When AccBS.MemberF=1 or AccBS.MemberFeeF=1 Then (1-@MShare/100) else 1 end)  
		   )     
		  From Acceptance
		  Inner Join Acceptance mAcceptance on (mAcceptance.ANO=mAcceptance.LANO and mAcceptance.ANO=Acceptance.LANO)		  		  
		  Inner Join AccBS on (AccBS.ANO=mAcceptance.ANO and AccBS.NoProrataF=0)
		  Left Join AccBSDet on ((AccBSDet.Period=0 or AccBSDet.Period=@P_Period) and AccBSDet.ID=AccBS.ID and AccBSDet.BSType=AccBS.BSType and AccBSDet.ANO=AccBS.ANO and AccBSDet.Code=@P_Code and AccBSDet.InceptionF=0)
		  Where Acceptance.ANO=@P_ANO 
		  and (AccBS.NotMinimumPremiumF=0 or (AccBS.NotMinimumPremiumF=1 and @P_MinimumPremiumF=0))                   		  		  
		  Group By ACCBS.ID, ACCBS.BSType
		end
		else
		Begin
		  Select @GrossUpComm=
		  sum(
		  Case 
		  When coalesce(AccBSDet.FeeAmount,AccBS.FeeAmount)<>0 and @Gross<>0 Then
			  coalesce(AccBSDet.FeeAmount,AccBS.FeeAmount*@Gross/@TotalGross)/@Gross*100 
		  else
	  		  coalesce(AccBSDet.Fee,AccBS.Fee)
		  end
		  *(
		  Case 
		  When GrossUpF=1 Then 1 
		  else -- NetUpF (Net after VAT and TAX)
			(
			100 +
			(case when @ADate<MParam.Effective then MParam.VatOLD else MParam.Vat end)*(Case When Profile.VATF=1 Then 1 else 0 end)
			-
			Case 
			When TaxType.MTaxType='PASAL21' then MParam.PASAL21*(100-MParam.TAXDISCOUNT)/100
			When TaxType.MTaxType='PASAL23' then MParam.PASAL23
			When TaxType.MTaxType='PASAL26' then MParam.Pasal26
			When TaxType.MTaxType='PASAL4' then MParam.PASAL4
			else 0
			end 
			*(Case When Profile.TaxPCT=0 Then 1 else Profile.TaxPCT/100 end)
			*(Case When Profile.TaxF=1 Then 1 else 0 end)
			)/100
		  end)
		  + AccBS.UpFee)
		  from Acceptance   
		  Inner Join Acceptance mAcceptance on (mAcceptance.ANO=mAcceptance.LANO and ((mAcceptance.RegNo<>'' and mAcceptance.RegNo=Acceptance.RegNo)))
		  inner join AccBS on (AccBS.ANO=mAcceptance.ANO and AccBS.NoProrataF=0)   
		  Left Join AccBSDet on ((AccBSDet.Period=0 or AccBSDet.Period=@P_Period) and AccBSDet.ID=AccBS.ID and AccBSDet.BSType=AccBS.BSType and AccBSDet.ANO=AccBS.ANO and AccBSDet.Code=@P_Code and AccBSDet.InceptionF=0)  
		  Inner Join MParam on (MParam.Type='B'+AccBS.BSType)
		  Inner Join Profile on (Profile.ID=AccBS.ID)
		  Left Join TaxType on (TaxType.TaxType=Profile.TaxType)
		  Where Acceptance.ANO=@P_ANO and (AccBS.GrossUpF=1 or AccBS.NetUpF=1)  		

		  if @GrossUpComm is null    
			 Select @GrossUpComm=0              
		  
		   Insert into @Commission_Table(ADate, ID, BSType, OBSType, NoRefundF, Commission)
		   Select @ADate,  ACCBS.ID, ACCBS.BSType, Max(OBSType) as OBSType, cast(Max(cast(ACCBS.NoRefundF as Int)) as Bit),
		   sum(  
		   (  
			Case 
			When coalesce(AccBSDet.FeeAmount,AccBS.FeeAmount)<>0 and @Gross<>0 Then
				coalesce(AccBSDet.FeeAmount,AccBS.FeeAmount*@Gross/@TotalGross)/@Gross*100 
				/
				(
				Case 
				When AccBS.GrossF=1 then 
					1/@RLoading*100/(100-@RDiscount)  
				When AccBS.GrossBLF=1 Then
					1/@RLoading
				else  
					1 
				end 
				*
				(Case When AccBS.NetF=1 then (1-@Discount/100) When AccBS.NetGroupF=1 then (1-@GDiscount/100) else 1 end)
				)	   
			else
	  			coalesce(AccBSDet.Fee,AccBS.Fee)
				*
				(
				Case 
				When AccBS.GrossF=1 then 
					1/@RLoading*100/(100-@RDiscount)  
				When AccBS.GrossBLF=1 Then
					1/@RLoading
				else  
					1 
				end 
				*
				(Case When AccBS.NetF=1 then (1-@Discount/100) When AccBS.NetGroupF=1 then (1-@GDiscount/100) else 1 end)
				)	   
			end
			* (1-(Case When AccBS.GrossUpF=0 and AccBS.NetUpF=0 Then (@GrossUpComm)/100 else 0 end))    
			+(-(Case When @ADiscount=0 then AccBS.Discount else @ADiscount end)+AccBS.UpFee)*(Case When AccBS.GrossUpF=0 and AccBS.NetUpF=0 Then (100-@GrossUpComm)/100 else 1 end)     
		   )
		   --*(Case When AccBS.MemberF=1 or AccBS.MemberFeeF=1 Then (1-@MShare/100) else 1 end)  
		   )     
		  From Acceptance
		  Inner Join Acceptance mAcceptance on (mAcceptance.ANO=mAcceptance.LANO and ((mAcceptance.RegNo<>'' and mAcceptance.RegNo=Acceptance.RegNo)))
		  Inner Join AccBS on (AccBS.ANO=mAcceptance.ANO and AccBS.NoProrataF=0)
		  Left Join AccBSDet on ((AccBSDet.Period=0 or AccBSDet.Period=@P_Period) and AccBSDet.ID=AccBS.ID and AccBSDet.BSType=AccBS.BSType and AccBSDet.ANO=AccBS.ANO and AccBSDet.Code=@P_Code and AccBSDet.InceptionF=0)
		  Where Acceptance.ANO=@P_ANO 
		  and (AccBS.NotMinimumPremiumF=0 or (AccBS.NotMinimumPremiumF=1 and @P_MinimumPremiumF=0))    		  		
		  Group By ACCBS.ID, ACCBS.BSType
		end
	 end
	 else
	 Begin
		  Select @GrossUpComm=
		  sum(
		  Case 
		  When coalesce(AAccBSDet.FeeAmount,AAccBS.FeeAmount)<>0 and @Gross<>0 Then
			  coalesce(AAccBSDet.FeeAmount,AAccBS.FeeAmount*@Gross/@TotalGross)*100/@Gross 
		  else
	  		  coalesce(AAccBSDet.Fee,AAccBS.Fee)
		  end
		  *(
		  Case 
		  When GrossUpF=1 Then 1 
		  else -- NetUpF (Net after VAT and TAX)
			(
			100 +
			(case when @ADate<MParam.Effective then MParam.VatOLD else MParam.Vat end)*(Case When Profile.VATF=1 Then 1 else 0 end)
			-
			Case 
			When TaxType.MTaxType='PASAL21' then MParam.PASAL21*(100-MParam.TAXDISCOUNT)/100
			When TaxType.MTaxType='PASAL23' then MParam.PASAL23
			When TaxType.MTaxType='PASAL26' then MParam.Pasal26
			When TaxType.MTaxType='PASAL4' then MParam.PASAL4
			else 0
			end 
			*(Case When Profile.TaxPCT=0 Then 1 else Profile.TaxPCT/100 end)
			*(Case When Profile.TaxF=1 Then 1 else 0 end)
			)/100
		  end)
		  + AAccBS.UpFee)
		  From AAccBS 
		  Left Join AAccBSDet on ((AAccBSDet.Period=0 or AAccBSDet.Period=@P_Period) and AAccBSDet.ID=AAccBS.ID and AAccBSDet.BSType=AAccBS.BSType and AAccBSDet.ANO=AAccBS.ANO and AAccBSDet.Code=@P_Code)   
		  Inner Join MParam on (MParam.Type='B'+AAccBS.BSType)
		  Inner Join Profile on (Profile.ID=AAccBS.ID)
		  Left Join TaxType on (TaxType.TaxType=Profile.TaxType)
		  Where AAccBS.ANO=@P_ANO and (AAccBS.GrossUpF=1 or AAccBS.NetUpF=1)    	 
		  
		  if @GrossUpComm is null    
			 Select @GrossUpComm=0              		  

		   Insert into @Commission_Table(ADate, ID, BSType, OBSType, NoRefundF, Commission)
		   Select @ADate,  ACCBS.ID, ACCBS.BSType, Max(OBSType) as OBSType, cast(Max(cast(ACCBS.NoRefundF as Int)) as Bit), 
		   sum(  
		   (  
			Case 
			When coalesce(AccBSDet.FeeAmount,AccBS.FeeAmount)<>0 and @Gross<>0 Then
				coalesce(AccBSDet.FeeAmount,AccBS.FeeAmount*@Gross/@TotalGross)/@Gross*100 
				/
				(
				Case 
				When AccBS.GrossF=1 then 
					1/@RLoading*100/(100-@RDiscount)  
				When AccBS.GrossBLF=1 Then
					1/@RLoading
				else  
					1 
				end 
				*
				(Case When AccBS.NetF=1 then (1-@Discount/100) When AccBS.NetGroupF=1 then (1-@GDiscount/100) else 1 end)
				)	   
			else
	  			coalesce(AccBSDet.Fee,AccBS.Fee)
				*
				(
				Case 
				When AccBS.GrossF=1 then 
					1/@RLoading*100/(100-@RDiscount)  
				When AccBS.GrossBLF=1 Then
					1/@RLoading
				else  
					1 
				end 
				*
				(Case When AccBS.NetF=1 then (1-@Discount/100) When AccBS.NetGroupF=1 then (1-@GDiscount/100) else 1 end)
				)	   
			end
			* (1-(Case When AccBS.GrossUpF=0 and AccBS.NetUpF=0 Then (@GrossUpComm)/100 else 0 end))      
			+(-(Case When @ADiscount=0 then AccBS.Discount else @ADiscount end)+AccBS.UpFee)*(Case When AccBS.GrossUpF=0 and AccBS.NetUpF=0 Then (100-@GrossUpComm)/100 else 1 end)     
		   )
		   --*(Case When AccBS.MemberF=1 or AccBS.MemberFeeF=1 Then (1-@MShare/100) else 1 end)  
		   )     
		  From Acceptance
		  Inner Join AAccBS AccBS on (AccBS.ANO=Acceptance.ANO and AccBS.NoProrataF=0)
		  Left Join AAccBSDet AccBSDet on ((AccBSDet.Period=0 or AccBSDet.Period=@P_Period) and AccBSDet.ID=AccBS.ID and AccBSDet.BSType=AccBS.BSType and AccBSDet.ANO=AccBS.ANO and AccBSDet.Code=@P_Code)
		  Where Acceptance.ANO=@P_ANO 
		  and (AccBS.NotMinimumPremiumF=0 or (AccBS.NotMinimumPremiumF=1 and @P_MinimumPremiumF=0))                      
		  Group By ACCBS.ID, ACCBS.BSType
	 end
 
 END
                        
 Return
                        
End        


GO

DROP Function Premium_Commission_VAT_Table
GO
CREATE Function Premium_Commission_VAT_Table(@P_ANO as int,@P_Code as varchar(10),@P_Period Int, @P_MinimumPremiumF Bit)                
RETURNS @Vat_Table Table(ID varchar(10), BSType varchar(10), OBSType varchar(10), NoRefundF Bit, VAT Float)           
AS              
BEGIN                

 Declare @Commission_Table Table(ADate smalldatetime, ID varchar(10), BSType varchar(10), OBSType varchar(10), NoRefundF Bit, Commission Float)           
 insert into @Commission_Table(ADate, ID, BSType, OBSType, NoRefundF, Commission)
 Select ADate, ID, BSType, OBSType, NoRefundF, Commission
 from Premium_Commission_Table(@P_ANO, @P_Code, @P_Period, @P_MinimumPremiumF)

 insert into @VAT_Table(ID, BSType, OBSType, NoRefundF, VAT)
 Select C.ID, C.BSType, C.OBSType, C.NoRefundF, 
 C.Commission
 *(Case When (Case When (coalesce(Profile.VATESDate,'01/01/1900')<= C.ADate and coalesce(Profile.VatEEDate,'01/01/1900')>= C.ADate) Then cast(0 as Bit) else Profile.VatF end)=1 Then (case when C.ADate<MParam.Effective then MParam.VatOLD else MParam.Vat end)/100 else 0 end)   
 *(Case When SysTab.TaxMethod<>3 or RateTab.VatCommissionF=1 then 1 else 0 end)
 from @Commission_Table C
 Inner Join MParam on (MParam.Type='B'+C.BSType)
 Inner Join Profile on (Profile.ID=C.ID)
 Inner Join RateTab on (RateTab.Code=@P_Code)
 Inner Join SysTab on (1=1)
                        
 Return             
End        

GO

DROP Function Premium_Commission_TAX_Table
GO
CREATE Function Premium_Commission_TAX_Table(@P_ANO as int,@P_Code as varchar(10),@P_Period Int, @P_MinimumPremiumF Bit)                
RETURNS @TAX_Table Table(ID varchar(10), BSType varchar(10), OBSType varchar(10), NoRefundF Bit, TAX Float)           
AS              
BEGIN                

 Declare @Commission_Table Table(ADate smalldatetime, ID varchar(10), BSType varchar(10), OBSType varchar(10), NoRefundF Bit, Commission Float)           
 insert into @Commission_Table(ADate, ID, BSType, OBSType, NoRefundF, Commission)
 Select ADate, ID, BSType, OBSType, NoRefundF, Commission
 from Premium_Commission_Table(@P_ANO, @P_Code, @P_Period, @P_MinimumPremiumF)

 insert into @TAX_Table(ID, BSType, OBSType, NoRefundF, TAX)
 Select C.ID, C.BSType, C.OBSType, C.NoRefundF, 
 C.Commission
 *(Case When (Case When (coalesce(Profile.TaxHSDate,'01/01/1900')<= C.ADate and coalesce(Profile.TaxHEDate,'01/01/1900')>= C.ADate) Then cast(0 as Bit) else Profile.TaxF end)=1 Then (Case When TaxType.MTaxType='PASAL21' then MParam.Pasal21*(100-MParam.TaxDiscount)/100 When TaxType.MTaxType='PASAL23' then MParam.Pasal23 When TaxType.MTaxType='PASAL26' then MParam.Pasal26 When TaxType.MTaxType='PASAL4' then MParam.Pasal4 else TaxType.TaxRate end)/100*(Case When Profile.TaxPCT=0 Then 1 else TaxPCT/100 end) else 0 end)    
 from @Commission_Table C
 Inner Join MParam on (MParam.Type='B'+C.BSType)
 Inner Join Profile on (Profile.ID=C.ID)
 Left Join TaxType on (TaxType.TaxType=Profile.TaxType)
                        
 Return             
End        

GO



DROP FUNCTION PREMIUM_CALCULATION
GO
CREATE FUNCTION PREMIUM_CALCULATION(@P_ANO int)                  
RETURNS TABLE  AS                  
RETURN (                  

Select ANO, Currency,
sum(Premium) as Premium,
sum(Commission) as Commission,
sum(Discount) as Discount,
dbo.roundCCY(sum(VAT),Currency) as VAT,
dbo.roundCCY(sum(TAX),Currency) as TAX,
Sum(FeeDuty) as FeeDuty      
from
(
	Select ANO, Code, SDate, EDate, Currency,   
	sum(Premium-Case When NoRefundF=7 Then Premium*coalesce(T1.Commission,0)/100 else 0 end) as Premium,           
	sum(Case When NoRefundF=7 Then 0 else Premium*coalesce(T1.Commission,0)/100 end) as Commission,           
	sum(Premium*dbo.Premium_Discount(CANO,Code,PolicyYear)/100) as Discount,           
	sum(Case When NoRefundF=7 Then 0 else Premium*coalesce(T1.VAT,0)/100 end) as Vat,           
	sum(Case When NoRefundF=7 Then 0 else Premium*coalesce(T1.TAX,0)/100 end) as Tax,           
	cast(0 as Float) as FeeDuty      
	
	from PREMIUM_CALCULATION_BASE(@P_ANO) T                                              
	Outer Apply (
		Select 
		sum(Case When coalesce(T2.NoRefundF, T1.NoRefundF)=0 Then T1.Commission else 0 end) as Commission,
		sum(
			Case 
			When coalesce(T2.NoRefundF, T1.NoRefundF)=0 Then 
				T1.Commission 
				*(Case When (Case When (coalesce(Profile.VATESDate,'01/01/1900')<= T1.ADate and coalesce(Profile.VatEEDate,'01/01/1900')>= T1.ADate) Then cast(0 as Bit) else Profile.VatF end)=1 Then (case when T1.ADate<MParam.Effective then MParam.VatOLD else MParam.Vat end)/100 else 0 end)   
				*(Case When SysTab.TaxMethod<>3 or RateTab.VatCommissionF=1 then 1 else 0 end)
			else 0 
			end) as VAT,
		sum(
			Case 
			When coalesce(T2.NoRefundF, T1.NoRefundF)=0 Then 
				T1.Commission 
				*(Case When (Case When (coalesce(Profile.TaxHSDate,'01/01/1900')<= T1.ADate and coalesce(Profile.TaxHEDate,'01/01/1900')>= T1.ADate) Then cast(0 as Bit) else Profile.TaxF end)=1 Then (Case When TaxType.MTaxType='PASAL21' then MParam.Pasal21*(100-MParam.TaxDiscount)/100 When TaxType.MTaxType='PASAL23' then MParam.Pasal23 When TaxType.MTaxType='PASAL26' then MParam.Pasal26 When TaxType.MTaxType='PASAL4' then MParam.Pasal4 else TaxType.TaxRate end)/100*(Case When Profile.TaxPCT=0 Then 1 else TaxPCT/100 end) else 0 end)    
			else 0 
			end) as TAX
		from Premium_Commission_Table(T.CANO,T.Code,T.PolicyYear,T.MinimumPremiumF) T1
		Left Join Premium_Commission_Table(@P_ANO,T.Code,T.PolicyYear,T.MinimumPremiumF) T2 on (T2.ID=T1.ID and T2.OBSType=T1.BSType)
		Inner Join MParam on (MParam.Type='B'+T1.BSType)
		Inner Join Profile on (Profile.ID=T1.ID)
		Inner Join RateTab on (RateTab.Code=T.Code)
		Inner Join SysTab on (1=1)
		Left Join TaxType on (TaxType.TaxType=Profile.TaxType)
	) T1
	Group By ANO, Code, SDate, EDate, Currency          

	Union All                  
                                 
	select A3.ANO, AccAss.RCode as Code, AccAss.SDate, AccAss.EDate, AccAss.Currency_OC as Currency,                  
	sum(Case When AccAss.Code in ('P','U') then (Case When A3.AType='A' and AccAss.AdjMethod='OVERLIMIT' then -AccAss.CAmount*(Case When A3.CPCT<>0 Then A3.CPCT/100 else 1 end)/(Case When AccAss.PProrata<>0 Then AccAss.PProrata else 1 end) else -AccAss.Amount_OC end)*(Case When AccAss.Type='DI' then 100/(100-coalesce(Coinsurance.MShare,0)) else 1 end) else 0 end) as Premium,                  
	sum(Case When AccAss.Code='C' then (Case When A3.AType='A' and AccAss.AdjMethod='OVERLIMIT' then AccAss.CAmount*(Case When A3.CPCT<>0 Then A3.CPCT/100 else 1 end)/(Case When AccAss.PProrata<>0 Then AccAss.PProrata else 1 end) else AccAss.Amount_OC end)*(Case When AccAss.Type='DI' then 100/(100-coalesce(Coinsurance.MShare,0)) else 1 end) else 0 end) as Commission,                  
	sum(Case When AccAss.Code='O' then (Case When A3.AType='A' and AccAss.AdjMethod='OVERLIMIT' then AccAss.CAmount*(Case When A3.CPCT<>0 Then A3.CPCT/100 else 1 end)/(Case When AccAss.PProrata<>0 Then AccAss.PProrata else 1 end) else AccAss.Amount_OC end)*(Case When AccAss.Type='DI' then 100/(100-coalesce(Coinsurance.MShare,0)) else 1 end) else 0 end) as Discount,                  
	sum((Case When A3.AType='A' and AccAss.AdjMethod='OVERLIMIT' then AccAss.CAmount*(Case When A3.CPCT<>0 Then A3.CPCT/100 else 1 end)/(Case When AccAss.PProrata<>0 Then AccAss.PProrata else 1 end) else AccAss.Amount_OC end)*(Case When AccAss.Type='DI' then 100/(100-coalesce(Coinsurance.MShare,0)) else 1 end)*(Case When (Case When (coalesce(Profile.VATESDate,'01/01/1900')<= A2.ADate and coalesce(Profile.VatEEDate,'01/01/1900')>= A2.ADate) Then cast(0 as Bit) else Profile.VatF end)=1 Then MParam.Vat/100 else 0 end)) as Vat,                  
	sum((Case When A3.AType='A' and AccAss.AdjMethod='OVERLIMIT' then AccAss.CAmount*(Case When A3.CPCT<>0 Then A3.CPCT/100 else 1 end)/(Case When AccAss.PProrata<>0 Then AccAss.PProrata else 1 end) else AccAss.Amount_OC end)*(Case When AccAss.Type='DI' then 100/(100-coalesce(Coinsurance.MShare,0)) else 1 end)*(Case When (Case When (coalesce(Profile.TaxHSDate,'01/01/1900')<= A2.ADate and coalesce(Profile.TaxHEDate,'01/01/1900')>= A2.ADate) Then cast(0 as Bit) else Profile.TaxF end)=1 Then (Case When TaxType.MTaxType='PASAL21' Then (Case When MParam.UseTaxTypeF=0 Then MParam.PASAL21 Else TaxType.TaxRate End)/100*(100-MParam.TaxDiscount)/100 When TaxType.MTaxType='PASAL23' Then (Case When MParam.UseTaxTypeF=0 Then MParam.PASAL23 Else TaxType.TaxRate End)/100 When TaxType.MTaxType='PASAL26' Then (Case When MParam.UseTaxTypeF=0 Then MParam.PASAL26 Else TaxType.TaxRate End)/100 When TaxType.MTaxType='PASAL4' Then (Case When MParam.UseTaxTypeF=0 Then MParam.PASAL4 Else TaxType.TaxRate End)/100 else 0 end)*(Case When Profile.TaxPCT=0 Then 1 else Profile.TaxPCT/100 end) else Profile.AccruedTax/100 end)) as Tax,      
	sum(Case When AccAss.Code in ('F','D') then -AccAss.Amount_OC else 0 end) as FeeDuty      

	From Acceptance A2 
	inner join AccAss on (AccAss.ANO=A2.ANO)     
	Left join Acceptance pA2  on (pA2.ANO=A2.pANO)     
	inner join Profile on (Profile.ID=AccAss.ID)      
	Left Join TaxType on (TaxType.TaxType=Profile.TaxType)
	inner join MParam on (MParam.Type=Accass.Type)      
	Left Join (Select CNO, sum(Share) as MShare from Coinsurance Where PCollectionF=0 Group by CNO) Coinsurance on (Coinsurance.CNO=A2.CNO)      
	Cross Apply (
		Select Top 1 A1.ANO, A1.OANO, A1.CPCT, A1.AType, A1.EMethod, A1.PANO, A1.PDate, A1.PPDate, A2.PDate as CPDate, coalesce(A2.ANO,0) as CANO,
		coalesce((Select Top 1 PANO from Acceptance A3 Where A3.OANO=A1.OANO and A3.Astatus<>'C' and A3.AType='A' and A3.ANO<@P_ANO Order By A3.PANO Desc), A1.PANO) as PADJANO
		from Acceptance A1
		Left Join RArrHeader R on (R.ANO=A1.ANO)
		Outer Apply (Select Top 1 A2.ANO, A2.PDate from Acceptance A2 Where A2.OANO=A1.OANO and A2.Atype='C' and A2.EMethod='A' and A2.ANO<@P_ANO Order by A2.ANO Desc) A2
		Where A1.ANO=@P_ANO
		Order By A1.OANO, A2.ANO Desc
	) A3 
	Where A2.OANO=A3.OANO and A2.ANO<@P_ANO
	and 
	( 
		(
		A3.AType='A' and
		(    
			(  
			pA2.ANO=A3.PANO and A3.PDate<=(Case When pA2.PDate<pA2.SDate then pA2.SDate else pA2.PDate End) and A3.PPDate>=(Case When pA2.PPDate<pA2.SDate then pA2.SDate else pA2.PPDate End) and (A2.AType='E' and coalesce(pA2.AType,'') in ('N','E'))   
			and AccAss.AdjustableF=1 and AccAss.AdjMethod<>'OVERLIMIT' and AccAss.CAmount=0  
			and pA2.ANO<=A3.PADJANO 
			)     
			or   
			(  
			A2.ANO<=A3.PANO and A3.PDate<=(Case When A2.PDate<A2.SDate then A2.SDate else A2.PDate End) and A3.PPDate>=(Case When A2.PPDate<A2.SDate then A2.SDate else A2.PPDate End) and (A2.AType<>'A' and coalesce(pA2.AType,'')<>'A')   
			and AccAss.AdjustableF=1 and AccAss.AdjMethod<>'OVERLIMIT'  
			and A2.ANO<=A3.PADJANO and A2.PANO<>A3.PADJANO
			)     
			or   
			(  
			A2.ANO<=A3.PANO and A3.PDate<=(Case When A2.PDate<A2.SDate then A2.SDate else A2.PDate End) and A3.PPDate>=(Case When A2.PPDate<A2.SDate then A2.SDate else A2.PPDate End) and (A2.AType<>'A' and coalesce(pA2.AType,'')<>'A')   
			and AccAss.AdjustableF=1 and AccAss.AdjMethod<>'OVERLIMIT' and AccAss.CAmount<>0  
			and A2.PANO=A3.PADJANO
			)     
			or   
			(  
			A2.ANO<=A3.PANO and A3.PDate<=(Case When A2.PDate<A2.SDate then A2.SDate else A2.PDate End) and A3.PPDate>=(Case When A2.PPDate<A2.SDate then A2.SDate else A2.PPDate End) and A2.PDATE<A2.PPDATE and (A2.AType<>'A' and coalesce(pA2.AType,'')<>'A')   
			and AccAss.AdjustableF=1 and AccAss.AdjMethod='OVERLIMIT' and AccAss.CAmount<>0  
			and NOT EXISTS (Select Top 1 PANO from Acceptance A3 Where A3.OANO=A3.OANO and A3.PANO=A2.ANO and A3.Astatus<>'C' and A3.AType='A' and A3.ANO<@P_ANO)  
			)     
		)
		)
		or    
		(  
		--Cancel All
		A3.AType='C' and A3.EMethod='A'and 
		(
		(
		case when A2.ANO<=A3.CANO and A2.PDate>coalesce(A3.CPDate,A2.PDate) Then coalesce(A3.CPDate,A2.PDate) else A2.PDate end>=A3.PDate and AccAss.CAmount<>0
		) 
		or 
		(
		case when A2.ANO<=A3.CANO and coalesce(pA2.pDate,A2.PDate)>coalesce(A3.CPDate,coalesce(pA2.pDate,A2.PDate)) Then coalesce(A3.CPDate,coalesce(pA2.pDate,A2.PDate)) else coalesce(pA2.pDate,A2.PDate) end>=A3.PDate and AccAss.CAmount=0
		)
		)
		)  
		or
		(
		--Adjustment Cancel
		A3.AType='C' and A2.AType='A' and A2.ANO=A3.PANO
		)
	)     	                  
	and 
	(
	(AccAss.Type in ('DI','IC','IR','IT','IX') and AccAss.Code='P') 
	or (AccAss.Type in ('DI','IC') and AccAss.Code='U') 
	Or (AccAss.Type in ('BB','BA','BO','BC','BP','BD') and AccAss.Code='C') 
	or (AccAss.Type in ('DI','IC','IR','IT','IX') and AccAss.Code='O') 
	or (A3.AType='C' and A3.EMethod='A' and AccAss.Type in ('DI') and AccAss.Code in ('F','D'))
	)                  
	Group By A3.ANO, AccAss.RCode, AccAss.SDate, AccAss.EDate, AccAss.Currency_OC
) T          
Group by ANO, Currency


)       

go





insert into PatchVersioning
select '1029 Update Script - Patch 2024 (24) - REV',GETDATE()
go
	

Declare @PrevScript varchar(100)
Declare @CurrScript varchar(100)

Select @PrevScript=''
Select @CurrSCript='1029 Update Script - Patch 2024 (24) - REV'


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