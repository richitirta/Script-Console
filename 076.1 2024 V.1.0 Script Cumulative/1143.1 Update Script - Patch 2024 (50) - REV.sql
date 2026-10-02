


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
 Declare @AType varchar(1)        
 Declare @ASource varchar(10)
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
 @AStatus=Max(Acceptance.AStatus), 
 @AType=Max(Acceptance.AType),
 @ASource=Max(Cover.ASource),
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
		if @RegNo='' or @AStatus in ('W','T') or (@ASource='MKT' and @AType='N')   
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
		  Inner Join Acceptance mAcceptance on (mAcceptance.ANO=mAcceptance.LANO and mAcceptance.PolicyNo<>'' and ((mAcceptance.RegNo<>'' and mAcceptance.RegNo=Acceptance.RegNo)))
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
		  Inner Join Acceptance mAcceptance on (mAcceptance.ANO=mAcceptance.LANO and mAcceptance.PolicyNo<>'' and ((mAcceptance.RegNo<>'' and mAcceptance.RegNo=Acceptance.RegNo)))
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



  insert into PatchVersioning
select '1143.1 Update Script - Patch 2024 (50) - REV',GETDATE()
go
  
Declare @PrevScript varchar(100)
Declare @CurrScript varchar(100)

Select @PrevScript=''
Select @CurrSCript='1143.1 Update Script - Patch 2024 (50) - REV'


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


