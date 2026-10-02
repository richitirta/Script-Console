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
		End
 From 
 Acceptance 
 Inner Join Cover on (Cover.CNO=Acceptance.CNO) 
 Inner Join Systab on (1=1)
 Left Join ICalc on (ICalc.ANO=Acceptance.ANO and ICalc.Gross<>0 and (@P_Period=0 or @P_Period=DateDiff(month, Acceptance.SDate, ICalc.SDate) / 12 + 1))
 Left join RCALC on (ICALC.ANO=RCALC.ANO AND ICALC.CURRENCY=RCALC.CURRENCY AND ICALC.CODE=RCALC.CODE AND ICALC.TOR=RCALC.TOR AND ICALC.SDATE=RCALC.SDATE AND ICALC.EDATE=RCALC.EDATE AND ICALC.SANO=RCALC.SANO)     
 Left join PCALC on (PCALC.ANO=ICALC.ANO AND PCALC.CURRENCY=ICALC.CURRENCY)     
 Where Acceptance.ANO=@P_ANO
         
 Select @GDiscount=GDiscount, @PDiscount=PDiscount, @Discount=Discount from Payor_Discount(@P_ANO,@P_Code,@P_Period)        
 Select @RDiscount=Discount, @RLoading=Loading from Rate_Discount(@P_ANO,@P_Code)                
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
		*  
		(1-(Case When AccBS.GrossUpF=0 and AccBS.NetUpF=0 Then (@GrossUpComm)/100 else 0 end))    	  
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

DROP Procedure QPCALC_ACCASS
GO
CREATE Procedure QPCALC_ACCASS (@P_ANO integer)     
AS     
SELECT ICALC.CURRENCY, ICALC.CODE, 
(Case When coalesce(APayor.PolicyYearF,Payor.PolicyYearF)=1 then ICalc.SDate else coalesce(P.InstDate, ICalc.SDate) end) as SDate,
(Case When coalesce(APayor.PolicyYearF,Payor.PolicyYearF)=1 then ICalc.EDate else coalesce(P.InstLDate, ICalc.EDate) end) as EDate,
(Case When A1.AType='A' Then 0 else ICover.Adjustable end) as AdjustableF, 
ICALC.SANO, A2.LANO,     
Cast(Max(cast(RCover.NoRefundF as Integer)) as Bit) as NoRefundF,     
Max(Case When ICover.Adjustable=1 Then TOI.AdjMethod else '' end) as AdjMethod,     
AVG(ICALC.PRORATA) AS PPRORATA, 
MAX(CASE WHEN PCALC.TSI<>0 AND COALESCE(ISOURCE.LIMIT,0)<>0 THEN PCALC.OURSHARE/PCALC.TSI*100 ELSE COALESCE(ISOURCE.SHARE,100) END) as SHARE, 
SUM(Case When (coalesce(APayor.PolicyYearF,Payor.PolicyYearF)=1 and coalesce(APayor.DecreasePremiumF,Payor.DecreasePremiumF)=1) then coalesce(P.InstAmount,0) else coalesce(P.InstPCT,100)/100*(Case When (PCALC.Description<>'' and PCALC.Description<>'Minimum Premium') then ICALC.GROSS*PCALC.GROSS/PCALC.OGROSS else ICALC.GROSS*RCALC.GROSS/RCALC.OGROSS end) end) AS GROSS,     
MAX(PCALC.GROSS) as TOTALGROSS,
CAST(MAX(Case When Upper(PCALC.DESCRIPTION) in ('MINIMUM PREMIUM','POLICY MINIMUM PREMIUM') Then 1 else 0 end) as Bit) as MinimumPremiumF,     
SUM(ICALC.REINSTATEMENT) AS REINSTATEMENT,     
SUM(ICALC.DISCOUNT) AS DISCOUNT,     
SUM(ICALC.LOADING) AS LOADING,     
MAX(PCALC.TSI) as TSI,      --100% Sum Insured for Reinsurance Rate     
MAX(PCALC.Rate) As Rate,
MAX(RateTab.BPComm) as BPComm
FROM ICover     
inner join ICALC on (ICALC.INO=ICOVER.INO and ICALC.ANO=ICOVER.ANO)     
inner join TOI on (TOI.TOI=ICOVER.TOI)     
inner join RCALC on (ICALC.ANO=RCALC.ANO AND ICALC.CURRENCY=RCALC.CURRENCY AND ICALC.CODE=RCALC.CODE AND ICALC.TOR=RCALC.TOR AND ICALC.SDATE=RCALC.SDATE AND ICALC.EDATE=RCALC.EDATE AND ICALC.SANO=RCALC.SANO)     
inner join PCALC on (PCALC.ANO=ICALC.ANO AND PCALC.CURRENCY=ICALC.CURRENCY)     
Left join RCover on (RCover.ANO=RCalc.ANO and RCover.Code=RCalc.Code and RCover.SDate=RCalc.SDate)     
Inner Join RateTab on (RateTab.Code=ICalc.Code)
inner join ACCEPTANCE A1 On (A1.ANO=ICALC.ANO)     
inner join ACCEPTANCE A2 on (A2.ANO=ICALC.SANO)     
Inner Join RArrHeader R on (R.ANO=ICalc.ANO)     
left join ISource on (ISource.CNO=A2.CNO)   
Left Join Payor on (Payor.ANO=@P_ANO)
Left Join APayor on (APayor.ANO=@P_ANO)  
Left Join Payor_Schedule P on (P.ANO=@P_ANO and (coalesce(APayor.ScheduleF,Payor.ScheduleF)=1 or (coalesce(APayor.PolicyYearF,Payor.PolicyYearF)=1 and coalesce(APayor.DecreasePremiumF,Payor.DecreasePremiumF)=1)) and P.InstDate Between ICalc.SDate and dateadd(day,-1,ICalc.EDate))
WHERE ICover.ANO=@P_ANO and ICALC.GROSS<>0
GROUP BY ICALC.CURRENCY, ICALC.CODE, 
(Case When coalesce(APayor.PolicyYearF,Payor.PolicyYearF)=1 then ICalc.SDate else coalesce(P.InstDate, ICalc.SDate) end),
(Case When coalesce(APayor.PolicyYearF,Payor.PolicyYearF)=1 then ICalc.EDate else coalesce(P.InstLDate, ICalc.EDate) end),
(Case When A1.AType='A' Then 0 else ICover.Adjustable end), ICalc.SANO, A2.LANO     

go


 insert into PatchVersioning	
select '727 Update Script - Patch 2023 (79)',GETDATE()
go





Declare @PrevScript varchar(100)
Declare @CurrScript varchar(1004)

Select @PrevScript=''
Select @CurrSCript='727 Update Script - Patch 2023 (79)'


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






