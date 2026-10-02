IF EXISTS ( SELECT * FROM   sysobjects WHERE  id = object_id(N'View07') and OBJECTPROPERTY(id, N'IsProcedure') = 1 )
BEGIN
DROP PROCEDURE View07 
end
GO
CREATE PROCEDURE View07 (@p_ANo as integer)                  
AS                  
Declare @MRegNo as varchar(50)  
Declare @AStatus as varchar(1)  
Declare @AType as varchar(1)  
Declare @ASource as varchar(10)  
  
Select @MRegNo=A.RegNo, @AStatus=A.AStatus, @AType=A.AType, @ASource=C.ASource from Acceptance A, Cover C Where C.CNO=A.CNO and A.ANO=@P_ANO  

if (@MRegNo='' or @AStatus in ('W','T') or (@ASource='MKT' and @AType='N'))  
Begin  
	SELECT AccAss.ID, Profile.Name, AccAss.Type, AccAss.Posted, AccAss.Admno, AccAss.Currency, Acceptance.RegNo, Accass.DocNo, AccAss.RefNo,        
	Case When AccAss.CAmount=0 and Coalesce(pAcceptance.Branch,'')<>'' Then pAcceptance.Branch Else Acceptance.Branch end Branch,   dbo.fn_Get_UWYear(Acceptance.SDate, Acceptance.EDate, Case When (Case When isnull(APayor.ANO,0)=0 Then (Case When isnull(MPayor.ANO,0)=0 Then Payor.PolicyYearF else MPayor.PolicyYearF end) else APayor.PolicyYearF end)=1 Then AccAss.SDate else Acceptance.SDate end) as PolicyYear,  
	sum(                  
	 case                  
	  when (accass.type in ('IR','IT','IX') and accass.code in ('P','U','F')) or (accass.type in ('DI','IC') and accass.code in ('P','U')) or (AccAss.Type not in ('DI','IC','IR','IT','IX') and AccAss.Code='P') then AccAss.Amount  
	  else 0                  
	 end                  
	)   
	+  
	sum(  
	 Case   
	  When Acceptance.NoRefundF=7 and AccAss.Type in ('BB','BA','BO','BC','BP','BD') and AccAss.Code in ('C') then AccAss.Amount   
	  else 0   
	 end  
	)  
	AS Premium,                   
	sum(                  
	 case                   
	  when accass.code='C' and coalesce(accass.codeext,'') in ('','V') then AccAss.Amount                  
	  else 0                  
	 end                  
	)   
	-  
	sum(  
	 Case   
	  When Acceptance.NoRefundF=7 and AccAss.Type in ('BB','BA','BO','BC','BP','BD') and AccAss.Code in ('C') then AccAss.Amount   
	  else 0   
	 end  
	)  
	AS Commision,                   
	sum(                  
	 case                   
	  when accass.code='C' and coalesce(accass.codeext,'')='1' then AccAss.Amount                  
	  else 0                  
	 end                  
	) AS OverridingCommission,                   
	sum(                  
	 case                   
	  when accass.Type not in ('IR','IT','IX') and accass.code='F' then AccAss.Amount                  
	  else 0                  
	 end                  
	) AS Fee,                   
	sum(                  
	 case                   
	  when accass.code='D' then AccAss.Amount                  
	  else 0                  
	 end                  
	) AS Duty,                   
	sum(                  
	 case                   
	  when accass.type not in ('CP','DC','XP','QS','QP','S1','S2','S3','AF','FO','FP') and accass.code='O' then AccAss.Amount                  
	  else 0                  
	 end                  
	) AS Discount,                   
	sum(                  
	 case                   
	  when accass.type in ('CP','DC','XP','QS','QP','S1','S2','S3','AF','FO','FP') and accass.code='O' and coalesce(accass.CodeExt,'')='' then AccAss.Amount                  
	  else 0                  
	 end                  
	) AS Acquisition,     
	sum(                  
	 case                   
	  when accass.type in ('CP','DC','XP','QS','QP','S1','S2','S3','AF','FO','FP') and accass.code='O' and coalesce(accass.CodeExt,'')='1' then AccAss.Amount                  
	  else 0                  
	 end                  
	) AS PremiumAdjustment,                                 
	sum(                  
	 case                  
	  when accass.code='I' then AccAss.Amount                  
	  else 0                  
	 end                  
	) AS OtherIncome,                 
	sum(                  
	 case                  
	  when accass.type in ('IR','IT','IX') and accass.code='F' then -AccAss.Amount  
	  when accass.Type in ('DI','IC') and accass.code='U' then -AccAss.Amount          
	  when accass.Type Not in ('DI','IC') and accass.code='U' then AccAss.Amount          
	  else 0                  
	 End                  
	) AS Ujroh,                
	sum(                  
	 case                  
	  when (accass.type in ('IR','IT','IX') and accass.code in ('P','U'))  or (accass.type in ('DI','IC') and accass.code in ('P')) or (AccAss.Type not in ('DI','IC','IR','IT','IX') and AccAss.Code in ('P','U')) then AccAss.Amount                  
	  else 0                  
	 end                  
	) AS Tabarru,           
	sum(                  
	 case                  
	  when accass.type not in ('CP','DC','XP','QS','QP','S1','S2','S3','AF','FO','FP') and accass.code='J' then AccAss.Amount                  
	  else 0                  
	 end                  
	) AS Deposit,           
	sum(                  
	 case                   
	  when accass.type in ('CP','DC','XP','QS','QP','S1','S2','S3','AF','FO','FP') and accass.code='J' then AccAss.Amount                  
	  else 0                  
	 end                  
	) AS Advance,                    
	dbo.roundccy(sum(AccAss.Amount),AccAss.Currency) - sum(AccAss.Amount)as Rounding,          
	Case   
	When Max(Admlink.AdmNo) is null then  
	 dbo.roundccy(  
	 sum(  
	 AccAss.Amount  
	  *(Case  
		When SysTab.TaxMethod in (0,3) Then  
			Case When ((AccAss.Type in ('BB','BA','BC','BP','BD') and AccAss.Code in ('C','O')) or (AccAss.Type in ('OP','OR')) or (AccAss.Type in ('DI','IC','CF','JP','BO') and AccAss.Code in ('P','C','O','J','U')) or (AccAss.Type not in ('BB','BA','BC','BP','BD','OP','OP','DI','IC','CF','JP','BO') and AccAss.Code not in ('F','D'))) then 1 Else 0 End  
		When SysTab.TaxMethod in (4) Then  
			Case When ((AccAss.Type in ('BB','BA','BC','BP','BD') and AccAss.Code in ('C','O')) or (AccAss.Type in ('OP','OR')) or (AccAss.Type in ('DI','IC','CF','JP','BO') and AccAss.Code in ('P','C','D','O','J','U')) or (AccAss.Type not in ('BB','BA','BC','BP','BD','OP','OP','DI','IC','CF','JP','BO') and AccAss.Code not in ('F','D'))) then 1 Else 0 End  
		else  
			Case When ((AccAss.Type in ('CP','DC','QS','QP','S1','S2','S3','AF','XP','FO','FP','IR','IT','IX') and AccAss.Code in ('C')) or (AccAss.Type in ('BB','BA','BC','BP','BD') and AccAss.Code in ('C','O')) or (AccAss.Type in ('OP','OR')) or (AccAss.Type not in ('CP','DC','QS','QP','S1','S2','S3','AF','XP','FO','FP','IR','IT','IX','BB','BA','BC','BP','BD','OP','OR') and AccAss.Code not in ('F','D'))) then 1 Else 0 End     
		end)    
		*(Case   
		When SysTab.TaxMethod in (3) and ((AccAss.Type in ('BB','BA','BC','BP','BD'))) Then  
			case When RateTab.VATCommissionF=1 and (Case When Cover.ISType not in ('T','R') or Profile.VATCOMMEXEMPTIF=0 Then cast(1 as Bit) Else 0 END)=1 then 1 else 0 end    	
		Else
			1
		End)
		*(Case   
		When SysTab.TaxMethod in (0,3,4) Then  
			Case When ((AccAss.Type in ('BB','BA','BC','BP','BD','OP','OR')) or ((AccAss.Type not in ('BB','BA','BC','BP','BD','OP','OR','DI','IC','CF','JP','BO') and TOC.VATBusinessF=1) or (Insured.VATF=1 and TOC.VATBusinessF=1))) Then 1 Else 0 End  
		Else  
			Case When ((AccAss.Type in ('BB','BA','BC','BP','BD','OP','OR')) or ((AccAss.Type not in ('BB','BA','BC','BP','BD','OP','OR','DI','IC','CF','JP','BO')) or (Insured.VATF=1 and TOC.VATBusinessF=1))) Then 1 Else 0 End  
		End)
	 *(Case When Profile.VatF=1 or AccAss.Type in ('DI','IC','CF','JP','BO') Then 1 else 0 end)  
	 *(Case When Acceptance.NoRefundF=7 and AccAss.Type in ('BB','BA','BO','BC','BP','BD') and AccAss.Code in ('C','O') then 0 else 1 end)  
	 *(Case When Acceptance.NoRefundF in (8,10,14) then 0 else 1 end)  
	 )  
	 ,Accass.Currency)  
	 *(Max(MParam.VAT)/100)  
	 +
	 dbo.roundccy(sum(case When AccAss.Code='V' Then AccAss.Amount else 0 End),Accass.Currency)
	When Max(coalesce((Admlink.Amount-Admlink.Amount_11-Admlink.Amount_12-(Admlink.Amount_8+Admlink.Amount_13+Admlink.Amount_17+Admlink.Amount_18)-Admlink.Amount_14),0))<>0 then   
	 sum((Admlink.Amount_13)*case When AccAss.Code<>'V' Then AccAss.Amount else 0 End)/Max(coalesce((Admlink.Amount-Admlink.Amount_11-Admlink.Amount_12-(Admlink.Amount_8+Admlink.Amount_13+Admlink.Amount_17+Admlink.Amount_18)-Admlink.Amount_14),0))  
	Else 0 end  
	as VAT,         
	Case   
	 When Max(Admlink.AdmNo) is null then  
	 dbo.roundccy(  
	 sum(  
	  AccAss.Amount  
	  *(Case  
		When SysTab.TaxMethod in (0,3) Then  
			Case When ((AccAss.Type in ('BB','BA','BC','BP','BD') and AccAss.Code in ('C','O')) or (AccAss.Type in ('OP','OR')) or (AccAss.Type in ('DI','IC','CF','JP','BO') and AccAss.Code in ('P','C','O','J','U')) or (AccAss.Type not in ('BB','BA','BC','BP','BD','OP','OP','DI','IC','CF','JP','BO') and AccAss.Code not in ('F','D'))) then 1 Else 0 End  
		When SysTab.TaxMethod in (4) Then  
			Case When ((AccAss.Type in ('BB','BA','BC','BP','BD') and AccAss.Code in ('C','O')) or (AccAss.Type in ('OP','OR')) or (AccAss.Type in ('DI','IC','CF','JP','BO') and AccAss.Code in ('P','C','D','O','J','U')) or (AccAss.Type not in ('BB','BA','BC','BP','BD','OP','OP','DI','IC','CF','JP','BO') and AccAss.Code not in ('F','D'))) then 1 Else 0 End  
		else  
			Case When ((AccAss.Type in ('CP','DC','QS','QP','S1','S2','S3','AF','XP','FO','FP','IR','IT','IX') and AccAss.Code in ('C')) or (AccAss.Type in ('BB','BA','BC','BP','BD') and AccAss.Code in ('C','O')) or (AccAss.Type in ('OP','OR')) or (AccAss.Type not in ('CP','DC','QS','QP','S1','S2','S3','AF','XP','FO','FP','IR','IT','IX','BB','BA','BC','BP','BD','OP','OR') and AccAss.Code not in ('F','D'))) then 1 Else 0 End     
		end)    
		*(Case   
		When SysTab.TaxMethod in (3) and ((AccAss.Type in ('BB','BA','BC','BP','BD'))) Then  
			case When RateTab.VATCommissionF=1 and (Case When Cover.ISType not in ('T','R') or Profile.VATCOMMEXEMPTIF=0 Then cast(1 as Bit) Else 0 END)=1 then 1 else 0 end    	
		Else
			1
		End)
		*(Case   
		When SysTab.TaxMethod in (0,3,4) Then  
			Case When ((AccAss.Type in ('BB','BA','BC','BP','BD','OP','OR')) or ((AccAss.Type not in ('BB','BA','BC','BP','BD','OP','OR','DI','IC','CF','JP','BO') and TOC.VATBusinessF=1) or (Insured.VATF=1 and TOC.VATBusinessF=1))) Then 1 Else 0 End  
		Else  
			Case When ((AccAss.Type in ('BB','BA','BC','BP','BD','OP','OR')) or ((AccAss.Type not in ('BB','BA','BC','BP','BD','OP','OR','DI','IC','CF','JP','BO')) or (Insured.VATF=1 and TOC.VATBusinessF=1))) Then 1 Else 0 End  
		End)
	 *(Case When Profile.VatF=1 or AccAss.Type in ('DI','IC','CF','JP','BO') Then 1 else 0 end)  
	 *(Case When Acceptance.NoRefundF=7 and AccAss.Type in ('BB','BA','BO','BC','BP','BD') and AccAss.Code in ('C','O') then 0 else 1 end)  
	 *(Case When Acceptance.NoRefundF in (8,10,14) then 0 else 1 end)  
	 *(Case When SysTab.VATSubsidiesF=1 or Profile.VATSubsidiesF=1 then 1 else 0 end)  
	 *(Case When Accass.Type in ('BB','BA') Then 1 else 0 end)
	 )  
	 ,Accass.Currency)
	 *Case When (Max(MParam.VAT)/100)<0 Then -(Max(MParam.VAT)/100) else 0 end 
	 When Max(coalesce((Admlink.Amount-Admlink.Amount_11-Admlink.Amount_12-(Admlink.Amount_8+Admlink.Amount_13+Admlink.Amount_17+Admlink.Amount_18)-Admlink.Amount_14),0))<>0 then   
		Case 
		When round(Max(Admlink.Amount_13+Admlink.Amount_14),4)=round(Max(-Admlink.Amount_8),4) or round(Max(Admlink.Amount_13),4)=round(Max(-Admlink.Amount_8),4) then
			sum((-Admlink.Amount_13)*AccAss.Amount)/Max(coalesce((Admlink.Amount-Admlink.Amount_11-Admlink.Amount_12-(Admlink.Amount_8+Admlink.Amount_13+Admlink.Amount_17+Admlink.Amount_18)-Admlink.Amount_14),0))  
		else
		0
		end
	 Else 
	   0
	 end  
	as VATSubsidies,         
	Case   
	When Max(Admlink.AdmNo) is null then  
	 dbo.roundccy(  
	 sum(  
	 AccAss.Amount  
	  *(Case  
		When SysTab.TaxMethod in (0,3) Then  
			Case When ((AccAss.Type in ('BB','BA','BC','BP','BD') and AccAss.Code in ('C','O')) or (AccAss.Type in ('OP','OR')) or (AccAss.Type in ('DI','IC','CF','JP','BO') and AccAss.Code in ('P','C','O','J','U')) or (AccAss.Type not in ('BB','BA','BC','BP','BD','OP','OP','DI','IC','CF','JP','BO') and AccAss.Code not in ('F','D'))) then 1 Else 0 End  
		When SysTab.TaxMethod in (4) Then  
			Case When ((AccAss.Type in ('BB','BA','BC','BP','BD') and AccAss.Code in ('C','O')) or (AccAss.Type in ('OP','OR')) or (AccAss.Type in ('DI','IC','CF','JP','BO') and AccAss.Code in ('P','C','D','O','J','U')) or (AccAss.Type not in ('BB','BA','BC','BP','BD','OP','OP','DI','IC','CF','JP','BO') and AccAss.Code not in ('F','D'))) then 1 Else 0 End  
		else  
			Case When ((AccAss.Type in ('CP','DC','QS','QP','S1','S2','S3','AF','XP','FO','FP','IR','IT','IX') and AccAss.Code in ('C')) or (AccAss.Type in ('BB','BA','BC','BP','BD') and AccAss.Code in ('C','O')) or (AccAss.Type in ('OP','OR')) or (AccAss.Type not in ('CP','DC','QS','QP','S1','S2','S3','AF','XP','FO','FP','IR','IT','IX','BB','BA','BC','BP','BD','OP','OR') and AccAss.Code not in ('F','D'))) then 1 Else 0 End     
		end)    
	 *(Case When Profile.BVatF=1 or AccAss.Type in ('DI','IC','CF','JP','BO') Then 1 else 0 end)  
	 *(Case When Acceptance.NoRefundF<>11 and Acceptance.NoRefundF<>14 and AccAss.Type in ('DI','IC','CF','JP','BO') and Insured.BVatF=1 then 1 else 0 end)  
	 )  
	 ,Accass.Currency)  
	 *Max((Case When coalesce(Acceptance.OverwriteBVatF,0)=0 Then Branch.VAT else coalesce(Acceptance.BVATPCT,0) end)/100)  
	When Max(coalesce((Admlink.Amount-Admlink.Amount_11-Admlink.Amount_12-(Admlink.Amount_8+Admlink.Amount_13+Admlink.Amount_17+Admlink.Amount_18)-Admlink.Amount_14),0))<>0 then   
	 sum((Admlink.Amount_17)*AccAss.Amount)/Max(coalesce((Admlink.Amount-Admlink.Amount_11-Admlink.Amount_12-(Admlink.Amount_8+Admlink.Amount_13+Admlink.Amount_17+Admlink.Amount_18)-Admlink.Amount_14),0))  
	Else 0 end  
	as VAT_1,        
	Case   
	When Max(Admlink.AdmNo) is null then  
	 Case when Max(AccAss.Type) in ('DI','IC','CF','JP','BO') Then    
	  Case   
	  When Max(SysTab.TaxMethod)=2 then  
	   dbo.roundccy(  
	   sum(  
	   AccAss.Amount*Case When (AccAss.Type in ('DI','IC') and Accass.Code in ('P','O','U')) or (AccAss.Type in ('CF','JP') and AccAss.Code in ('P','O')) or (AccAss.Type in ('BO')) Then 1 else 0 end     
	   *coalesce(RateCov.Portion,0)/coalesce(pRCover.Portion, RCover.Portion)  
	   *(Case When Acceptance.NoRefundF<>11 and Acceptance.NoRefundF<>14 and AccAss.Type in ('DI','IC','CF','JP','BO') and Insured.TVatF=1 then 1 else 0 end)
	   )  
	   ,Accass.Currency)  
	  When Max(SysTab.TaxMethod)=3 then  
	   dbo.roundccy(  
	   sum(  
	   AccAss.Amount*Case When (AccAss.Type in ('DI','IC') and Accass.Code in ('P','O','U')) or (AccAss.Type in ('CF','JP') and AccAss.Code in ('P','O')) or (AccAss.Type in ('BO')) Then 1 else 0 end     
	   *case When RateTab.VATF=1 and RateTab.VATEXEMPTF=0 then 1 else 0 end  
	   *(Case When Acceptance.NoRefundF<>11 and Acceptance.NoRefundF<>14 and AccAss.Type in ('DI','IC','CF','JP','BO') and Insured.TVatF=1 then 1 else 0 end)
	   )  
	   ,Accass.Currency)  
	  Else  
	   dbo.roundccy(  
	   sum(  
		 AccAss.Amount  
		  *(Case  
			When SysTab.TaxMethod in (0,3) Then  
				Case When ((AccAss.Type in ('BB','BA','BC','BP','BD') and AccAss.Code in ('C','O')) or (AccAss.Type in ('OP','OR')) or (AccAss.Type in ('DI','IC','CF','JP','BO') and AccAss.Code in ('P','C','O','J','U')) or (AccAss.Type not in ('BB','BA','BC','BP','BD','OP','OP','DI','IC','CF','JP','BO') and AccAss.Code not in ('F','D'))) then 1 Else 0 End  
			When SysTab.TaxMethod in (4) Then  
				Case When ((AccAss.Type in ('BB','BA','BC','BP','BD') and AccAss.Code in ('C','O')) or (AccAss.Type in ('OP','OR')) or (AccAss.Type in ('DI','IC','CF','JP','BO') and AccAss.Code in ('P','C','D','O','J','U')) or (AccAss.Type not in ('BB','BA','BC','BP','BD','OP','OP','DI','IC','CF','JP','BO') and AccAss.Code not in ('F','D'))) then 1 Else 0 End  
			else  
				Case When ((AccAss.Type in ('CP','DC','QS','QP','S1','S2','S3','AF','XP','FO','FP','IR','IT','IX') and AccAss.Code in ('C')) or (AccAss.Type in ('BB','BA','BC','BP','BD') and AccAss.Code in ('C','O')) or (AccAss.Type in ('OP','OR')) or (AccAss.Type not in ('CP','DC','QS','QP','S1','S2','S3','AF','XP','FO','FP','IR','IT','IX','BB','BA','BC','BP','BD','OP','OR') and AccAss.Code not in ('F','D'))) then 1 Else 0 End     
			end)    
			*(Case   
			When SysTab.TaxMethod in (3) and ((AccAss.Type in ('BB','BA','BC','BP','BD'))) Then  
				case When RateTab.VATCommissionF=1 and (Case When Cover.ISType not in ('T','R') or Profile.VATCOMMEXEMPTIF=0 Then cast(1 as Bit) Else 0 END)=1 then 1 else 0 end    	
			Else
				1
			End)    
		  *(Case When Profile.TVatF=1 or (AccAss.Type in ('DI','IC','CF','JP','BO')) Then 1 else 0 end)  
		  *(Case When Acceptance.NoRefundF<>11 and Acceptance.NoRefundF<>14 and AccAss.Type in ('DI','IC','CF','JP','BO') and Insured.TVatF=1 then 1 else 0 end)		
	   )  
	   ,Accass.Currency)  
	  end      
	 else  
	  0  
	 end  
	 *Max((Case When coalesce(Acceptance.OverwriteTVatF,0)=0 Then TOC.VAT else coalesce(Acceptance.TVATPCT,0) end)/100)  
	When Max(coalesce((Admlink.Amount-Admlink.Amount_11-Admlink.Amount_12-(Admlink.Amount_8+Admlink.Amount_13+Admlink.Amount_17+Admlink.Amount_18)-Admlink.Amount_14),0))<>0 then   
	 sum((Admlink.Amount_18)*AccAss.Amount)/Max(coalesce((Admlink.Amount-Admlink.Amount_11-Admlink.Amount_12-(Admlink.Amount_8+Admlink.Amount_13+Admlink.Amount_17+Admlink.Amount_18)-Admlink.Amount_14),0))  
	Else 0 end  
	as VAT_2,   
	Case   
	When Max(Admlink.AdmNo) is null then  
	 dbo.roundccy(  
	 sum(  
	 -(  
	  Case   
	  When charindex(AccAss.Type,'FOFPQSQPS1S2S3AF')<>0  then  
	   Case   
	   When TaxType.MTaxType in ('PASAL21','PASAL23','PASAL4') Then  
		Case When AccAss.Code<>'P' then 1 else 0 end      
	   else  
		Case When AccAss.Code<>'C' then 1 else 0 end      
	   end  
	  Else  
	   1  
	  End  
	  *AccAss.Amount  
	  )  
	 *(Case When Profile.TaxF=1 Then 1 Else 0 End)  
	 *(Case   
	  When TaxType.MTaxType='PASAL21' Then   
	   Case When (Case When MParam.UseTaxTypeF=0 Then MParam.PASAL21 Else TaxType.TaxRate End)<>0 Then (Case When Profile.AccruedTax<>0 Then Profile.AccruedTax else (Case When MParam.UseTaxTypeF=0 Then MParam.PASAL21 Else TaxType.TaxRate End)*(100-MParam.TaxDiscount)/100 end) else 0 end/100    
	  When TaxType.MTaxType='PASAL23' Then  
	   Case When (Case When MParam.UseTaxTypeF=0 Then MParam.PASAL23 Else TaxType.TaxRate End)<>0 Then (Case When Profile.AccruedTax<>0 Then Profile.AccruedTax else (Case When MParam.UseTaxTypeF=0 Then MParam.PASAL23 Else TaxType.TaxRate End) end) else 0 end/100   
	  When TaxType.MTaxType='PASAL26' Then   
	   Case When (Case When MParam.UseTaxTypeF=0 Then MParam.PASAL26 Else TaxType.TaxRate End)<>0 Then (Case When Profile.AccruedTax<>0 Then Profile.AccruedTax else (Case When MParam.UseTaxTypeF=0 Then MParam.PASAL26 Else TaxType.TaxRate End) end) else 0 end/100  
	  When TaxType.MTaxType='PASAL4' Then   
	   Case When (Case When MParam.UseTaxTypeF=0 Then MParam.PASAL4 Else TaxType.TaxRate End)<>0 Then (Case When Profile.AccruedTax<>0 Then Profile.AccruedTax else (Case When MParam.UseTaxTypeF=0 Then MParam.PASAL4 Else TaxType.TaxRate End) end) else 0 end/100  
	  ELSE Profile.AccruedTax/100  
	  END)  
	 *Case When coalesce(Profile.TaxPCT,0)=0 then 1 else Profile.TaxPCT/100 end  
	 *(Case When Acceptance.NoRefundF=7 and AccAss.Type in ('BB','BA','BO','BC','BP','BD') and AccAss.Code in ('C') then 0 else 1 end)  
	 *(Case When Acceptance.NoRefundF in (9,10) then 0 else 1 end)  
	 )  
	 ,AccAss.Currency)  
	When Max(coalesce((Admlink.Amount-Admlink.Amount_11-Admlink.Amount_12-(Admlink.Amount_8+Admlink.Amount_13+Admlink.Amount_17+Admlink.Amount_18)-Admlink.Amount_14),0))<>0 then   
	 sum((Admlink.Amount_14)*AccAss.Amount)/Max(coalesce((Admlink.Amount-Admlink.Amount_11-Admlink.Amount_12-(Admlink.Amount_8+Admlink.Amount_13+Admlink.Amount_17+Admlink.Amount_18)-Admlink.Amount_14),0))  
	Else 0 end  
	as TAX,
	Case   
	When Max(Admlink.AdmNo) is null then  
	 dbo.roundccy(  
	 sum(  
	 -(  
	  Case   
	  When charindex(AccAss.Type,'FOFPQSQPS1S2S3AF')<>0  then  
	   Case   
	   When TaxType.MTaxType in ('PASAL21','PASAL23','PASAL4') Then  
		Case When AccAss.Code<>'P' then 1 else 0 end      
	   else  
		Case When AccAss.Code<>'C' then 1 else 0 end      
	   end  
	  Else  
	   1  
	  End  
	  *AccAss.Amount  
	  )  
	 *(Case When Profile.TaxF=1 Then 1 Else 0 End)  
	 *(Case   
	  When TaxType.MTaxType='PASAL21' Then   
	   Case When (Case When MParam.UseTaxTypeF=0 Then MParam.PASAL21 Else TaxType.TaxRate End)<>0 Then (Case When Profile.AccruedTax<>0 Then Profile.AccruedTax else (Case When MParam.UseTaxTypeF=0 Then MParam.PASAL21 Else TaxType.TaxRate End)*(100-MParam.TaxDiscount)/100 end) else 0 end/100    
	  When TaxType.MTaxType='PASAL23' Then  
	   Case When (Case When MParam.UseTaxTypeF=0 Then MParam.PASAL23 Else TaxType.TaxRate End)<>0 Then (Case When Profile.AccruedTax<>0 Then Profile.AccruedTax else (Case When MParam.UseTaxTypeF=0 Then MParam.PASAL23 Else TaxType.TaxRate End) end) else 0 end/100   
	  When TaxType.MTaxType='PASAL26' Then   
	   Case When (Case When MParam.UseTaxTypeF=0 Then MParam.PASAL26 Else TaxType.TaxRate End)<>0 Then (Case When Profile.AccruedTax<>0 Then Profile.AccruedTax else (Case When MParam.UseTaxTypeF=0 Then MParam.PASAL26 Else TaxType.TaxRate End) end) else 0 end/100  
	  When TaxType.MTaxType='PASAL4' Then   
	   Case When (Case When MParam.UseTaxTypeF=0 Then MParam.PASAL4 Else TaxType.TaxRate End)<>0 Then (Case When Profile.AccruedTax<>0 Then Profile.AccruedTax else (Case When MParam.UseTaxTypeF=0 Then MParam.PASAL4 Else TaxType.TaxRate End) end) else 0 end/100  
	  ELSE Profile.AccruedTax/100  
	  END)  
	 *Case When coalesce(Profile.TaxPCT,0)=0 then 1 else Profile.TaxPCT/100 end  
	 *(Case When Acceptance.NoRefundF=7 and AccAss.Type in ('BB','BA','BO','BC','BP','BD') and AccAss.Code in ('C') then 0 else 1 end)  
	 *(Case When Acceptance.NoRefundF in (9,10) then 0 else 1 end)  
	 *(Case When Profile.TAXSubsidiesF=1 then -1 else 0 end)  
	 *(Case When Accass.Type in ('BB','BA') Then 1 else 0 end)
	 )  
	 ,AccAss.Currency)  
	When Max(coalesce((Admlink.Amount-Admlink.Amount_11-Admlink.Amount_12-(Admlink.Amount_8+Admlink.Amount_13+Admlink.Amount_17+Admlink.Amount_18)-Admlink.Amount_14),0))<>0 then   
		Case 
		When round(Max(Admlink.Amount_13+Admlink.Amount_14),4)=round(Max(-Admlink.Amount_8),4) or round(Max(Admlink.Amount_14),4)=round(Max(-Admlink.Amount_8),4) then
			sum((-Admlink.Amount_14)*AccAss.Amount)/Max(coalesce((Admlink.Amount-Admlink.Amount_11-Admlink.Amount_12-(Admlink.Amount_8+Admlink.Amount_13+Admlink.Amount_17+Admlink.Amount_18)-Admlink.Amount_14),0))  
		else
		0
		end
	Else 0 end  
	as TAXSubsidies
	FROM Acceptance   
	Inner Join Cover on (Cover.CNO=Acceptance.CNO)  
	Inner Join TOC on (TOC.TOC=Acceptance.TOC)  
	Inner Join Branch on (Branch.Branch=Acceptance.Branch)  
	Inner Join Profile Insured on (Insured.ID=Acceptance.AID)  
	Inner Join AccAss on (Acceptance.ANO=AccAss.ANO)  
	Left Join APayor on (APayor.ANO=Acceptance.ANO and Acceptance.LANO<>-1 and Acceptance.ANO<>Acceptance.LANO)                                
	Left Join Payor on (Payor.ANO=Acceptance.ANO and Acceptance.LANO=-1)                
	Left Join Acceptance pAcceptance on (pAcceptance.ANO=Acceptance.pANO)  
	Left Join Admlink on (Admlink.AdmNo=AccAss.AdmNo and not ((Acceptance.LANO<>-1 and Cover.OpenFlag=0) or (Acceptance.BulkF=1))) 
	Inner Join Profile on (Profile.ID=AccAss.ID)  
	Left Join TaxType on (TaxType.TaxType=Profile.TaxType)  
	Inner Join Mparam on (MParam.Type=AccAss.Type)  
	Outer Apply (
		Select mPayor.ANO, mPayor.PolicyYearF 
		from Acceptance mAcceptance, Cover mCover, Payor mPayor
		Where mCover.CNO=mAcceptance.CNO and mPayor.ANO=mAcceptance.ANO and mAcceptance.ANO=mAcceptance.LANO and MAcceptance.ANO=Acceptance.LANO 
	) mPayor
	Inner Join SysTab on (1=1)  
	Left Join RateTab on (RateTab.Code=AccAss.RCode)  
	Left Join RCover on (RCover.ANO=Acceptance.ANO and RCover.Code=AccAss.RCode and RCover.SDate=AccAss.SDate)  
	Left Join RCover pRCover on (AccAss.CAmount=0 and pRCover.ANO=Acceptance.pANO and pRCover.Code=AccAss.RCode and pRCover.SDate=AccAss.SDate)  
	Outer apply (Select sum(RateCov.Portion) as Portion from RateCov Where RateCov.Code=AccAss.RCode and RateCov.VatF=1) as RateCov  
	WHERE Acceptance.ANO=@P_ANO          
	GROUP BY AccAss.ID, Profile.Name, AccAss.Type, AccAss.Posted, AccAss.Admno, AccAss.Currency, Acceptance.RegNo, Accass.DocNo, AccAss.RefNo,        
	Case When AccAss.CAmount=0 and Coalesce(pAcceptance.Branch,'')<>'' Then pAcceptance.Branch Else Acceptance.Branch end,   dbo.fn_Get_UWYear(Acceptance.SDate, Acceptance.EDate, Case When (Case When isnull(APayor.ANO,0)=0 Then (Case When isnull(MPayor.ANO,0)=0 Then Payor.PolicyYearF else MPayor.PolicyYearF end) else APayor.PolicyYearF end)=1 Then AccAss.SDate else Acceptance.SDate end)   
End
Else
Begin
	SELECT AccAss.ID, Profile.Name, AccAss.Type, AccAss.Posted, AccAss.Admno, AccAss.Currency, Acceptance.RegNo, Accass.DocNo, AccAss.RefNo,        
	Case When AccAss.CAmount=0 and Coalesce(pAcceptance.Branch,'')<>'' Then pAcceptance.Branch Else Acceptance.Branch end Branch,   dbo.fn_Get_UWYear(Acceptance.SDate, Acceptance.EDate, Case When (Case When isnull(APayor.ANO,0)=0 Then (Case When isnull(MPayor.ANO,0)=0 Then Payor.PolicyYearF else MPayor.PolicyYearF end) else APayor.PolicyYearF end)=1 Then AccAss.SDate else Acceptance.SDate end) as PolicyYear,  
	sum(                  
	 case                  
	  when (accass.type in ('IR','IT','IX') and accass.code in ('P','U','F')) or (accass.type in ('DI','IC') and accass.code in ('P','U')) or (AccAss.Type not in ('DI','IC','IR','IT','IX') and AccAss.Code='P') then AccAss.Amount  
	  else 0                  
	 end                  
	)   
	+  
	sum(  
	 Case   
	  When Acceptance.NoRefundF=7 and AccAss.Type in ('BB','BA','BO','BC','BP','BD') and AccAss.Code in ('C') then AccAss.Amount   
	  else 0   
	 end  
	)  
	AS Premium,                   
	sum(                  
	 case                   
	  when accass.code='C' and coalesce(accass.codeext,'') in ('','V') then AccAss.Amount                  
	  else 0                  
	 end                  
	)   
	-  
	sum(  
	 Case   
	  When Acceptance.NoRefundF=7 and AccAss.Type in ('BB','BA','BO','BC','BP','BD') and AccAss.Code in ('C') then AccAss.Amount   
	  else 0   
	 end  
	)  
	AS Commision,                   
	sum(                  
	 case                   
	  when accass.code='C' and coalesce(accass.codeext,'')='1' then AccAss.Amount                  
	  else 0                  
	 end                  
	) AS OverridingCommission,                   
	sum(                  
	 case                   
	  when accass.Type not in ('IR','IT','IX') and accass.code='F' then AccAss.Amount                  
	  else 0                  
	 end                  
	) AS Fee,                   
	sum(                  
	 case                   
	  when accass.code='D' then AccAss.Amount                  
	  else 0                  
	 end                  
	) AS Duty,                   
	sum(                  
	 case                   
	  when accass.type not in ('CP','DC','XP','QS','QP','S1','S2','S3','AF','FO','FP') and accass.code='O' then AccAss.Amount                  
	  else 0                  
	 end                  
	) AS Discount,                   
	sum(                  
	 case                   
	  when accass.type in ('CP','DC','XP','QS','QP','S1','S2','S3','AF','FO','FP') and accass.code='O' and coalesce(accass.CodeExt,'')='' then AccAss.Amount                  
	  else 0                  
	 end                  
	) AS Acquisition,     
	sum(                  
	 case                   
	  when accass.type in ('CP','DC','XP','QS','QP','S1','S2','S3','AF','FO','FP') and accass.code='O' and coalesce(accass.CodeExt,'')='1' then AccAss.Amount                  
	  else 0                  
	 end                  
	) AS PremiumAdjustment,                                 
	sum(                  
	 case                  
	  when accass.code='I' then AccAss.Amount                  
	  else 0                  
	 end                  
	) AS OtherIncome,                 
	sum(                  
	 case                  
	  when accass.type in ('IR','IT','IX') and accass.code='F' then -AccAss.Amount  
	  when accass.Type in ('DI','IC') and accass.code='U' then -AccAss.Amount          
	  when accass.Type Not in ('DI','IC') and accass.code='U' then AccAss.Amount          
	  else 0                  
	 End                  
	) AS Ujroh,                
	sum(                  
	 case                  
	  when (accass.type in ('IR','IT','IX') and accass.code in ('P','U'))  or (accass.type in ('DI','IC') and accass.code in ('P')) or (AccAss.Type not in ('DI','IC','IR','IT','IX') and AccAss.Code in ('P','U')) then AccAss.Amount                  
	  else 0                  
	 end                  
	) AS Tabarru,           
	sum(                  
	 case                  
	  when accass.type not in ('CP','DC','XP','QS','QP','S1','S2','S3','AF','FO','FP') and accass.code='J' then AccAss.Amount                  
	  else 0                  
	 end                  
	) AS Deposit,           
	sum(                  
	 case                   
	  when accass.type in ('CP','DC','XP','QS','QP','S1','S2','S3','AF','FO','FP') and accass.code='J' then AccAss.Amount                  
	  else 0                  
	 end                  
	) AS Advance,                    
	dbo.roundccy(sum(AccAss.Amount),AccAss.Currency) - sum(AccAss.Amount)as Rounding,          
	Case   
	When Max(Admlink.AdmNo) is null then  
	 dbo.roundccy(  
	 sum(  
	 AccAss.Amount  
	  *(Case  
		When SysTab.TaxMethod in (0,3) Then  
			Case When ((AccAss.Type in ('BB','BA','BC','BP','BD') and AccAss.Code in ('C','O')) or (AccAss.Type in ('OP','OR')) or (AccAss.Type in ('DI','IC','CF','JP','BO') and AccAss.Code in ('P','C','O','J','U')) or (AccAss.Type not in ('BB','BA','BC','BP','BD','OP','OP','DI','IC','CF','JP','BO') and AccAss.Code not in ('F','D'))) then 1 Else 0 End  
		When SysTab.TaxMethod in (4) Then  
			Case When ((AccAss.Type in ('BB','BA','BC','BP','BD') and AccAss.Code in ('C','O')) or (AccAss.Type in ('OP','OR')) or (AccAss.Type in ('DI','IC','CF','JP','BO') and AccAss.Code in ('P','C','D','O','J','U')) or (AccAss.Type not in ('BB','BA','BC','BP','BD','OP','OP','DI','IC','CF','JP','BO') and AccAss.Code not in ('F','D'))) then 1 Else 0 End  
		else  
			Case When ((AccAss.Type in ('CP','DC','QS','QP','S1','S2','S3','AF','XP','FO','FP','IR','IT','IX') and AccAss.Code in ('C')) or (AccAss.Type in ('BB','BA','BC','BP','BD') and AccAss.Code in ('C','O')) or (AccAss.Type in ('OP','OR')) or (AccAss.Type not in ('CP','DC','QS','QP','S1','S2','S3','AF','XP','FO','FP','IR','IT','IX','BB','BA','BC','BP','BD','OP','OR') and AccAss.Code not in ('F','D'))) then 1 Else 0 End     
		end)    
		*(Case   
		When SysTab.TaxMethod in (3) and ((AccAss.Type in ('BB','BA','BC','BP','BD'))) Then  
			case When RateTab.VATCommissionF=1 and (Case When Cover.ISType not in ('T','R') or Profile.VATCOMMEXEMPTIF=0 Then cast(1 as Bit) Else 0 END)=1 then 1 else 0 end    	
		Else
			1
		End)
		*(Case   
		When SysTab.TaxMethod in (0,3,4) Then  
			Case When ((AccAss.Type in ('BB','BA','BC','BP','BD','OP','OR')) or ((AccAss.Type not in ('BB','BA','BC','BP','BD','OP','OR','DI','IC','CF','JP','BO') and TOC.VATBusinessF=1) or (Insured.VATF=1 and TOC.VATBusinessF=1))) Then 1 Else 0 End  
		Else  
			Case When ((AccAss.Type in ('BB','BA','BC','BP','BD','OP','OR')) or ((AccAss.Type not in ('BB','BA','BC','BP','BD','OP','OR','DI','IC','CF','JP','BO')) or (Insured.VATF=1 and TOC.VATBusinessF=1))) Then 1 Else 0 End  
		End)
	 *(Case When Profile.VatF=1 or AccAss.Type in ('DI','IC','CF','JP','BO') Then 1 else 0 end)  
	 *(Case When Acceptance.NoRefundF=7 and AccAss.Type in ('BB','BA','BO','BC','BP','BD') and AccAss.Code in ('C','O') then 0 else 1 end)  
	 *(Case When Acceptance.NoRefundF in (8,10,14) then 0 else 1 end)  
	 )  
	 ,Accass.Currency)  
	 *(Max(MParam.VAT)/100)  
	 +
	 dbo.roundccy(sum(case When AccAss.Code='V' Then AccAss.Amount else 0 End),Accass.Currency)
	When Max(coalesce((Admlink.Amount-Admlink.Amount_11-Admlink.Amount_12-(Admlink.Amount_8+Admlink.Amount_13+Admlink.Amount_17+Admlink.Amount_18)-Admlink.Amount_14),0))<>0 then   
	 sum((Admlink.Amount_13)*case When AccAss.Code<>'V' Then AccAss.Amount else 0 End)/Max(coalesce((Admlink.Amount-Admlink.Amount_11-Admlink.Amount_12-(Admlink.Amount_8+Admlink.Amount_13+Admlink.Amount_17+Admlink.Amount_18)-Admlink.Amount_14),0))  
	Else 0 end  
	as VAT,         
	Case   
	 When Max(Admlink.AdmNo) is null then  
	 dbo.roundccy(  
	 sum(  
	  AccAss.Amount  
	  *(Case  
		When SysTab.TaxMethod in (0,3) Then  
			Case When ((AccAss.Type in ('BB','BA','BC','BP','BD') and AccAss.Code in ('C','O')) or (AccAss.Type in ('OP','OR')) or (AccAss.Type in ('DI','IC','CF','JP','BO') and AccAss.Code in ('P','C','O','J','U')) or (AccAss.Type not in ('BB','BA','BC','BP','BD','OP','OP','DI','IC','CF','JP','BO') and AccAss.Code not in ('F','D'))) then 1 Else 0 End  
		When SysTab.TaxMethod in (4) Then  
			Case When ((AccAss.Type in ('BB','BA','BC','BP','BD') and AccAss.Code in ('C','O')) or (AccAss.Type in ('OP','OR')) or (AccAss.Type in ('DI','IC','CF','JP','BO') and AccAss.Code in ('P','C','D','O','J','U')) or (AccAss.Type not in ('BB','BA','BC','BP','BD','OP','OP','DI','IC','CF','JP','BO') and AccAss.Code not in ('F','D'))) then 1 Else 0 End  
		else  
			Case When ((AccAss.Type in ('CP','DC','QS','QP','S1','S2','S3','AF','XP','FO','FP','IR','IT','IX') and AccAss.Code in ('C')) or (AccAss.Type in ('BB','BA','BC','BP','BD') and AccAss.Code in ('C','O')) or (AccAss.Type in ('OP','OR')) or (AccAss.Type not in ('CP','DC','QS','QP','S1','S2','S3','AF','XP','FO','FP','IR','IT','IX','BB','BA','BC','BP','BD','OP','OR') and AccAss.Code not in ('F','D'))) then 1 Else 0 End     
		end)    
		*(Case   
		When SysTab.TaxMethod in (3) and ((AccAss.Type in ('BB','BA','BC','BP','BD'))) Then  
			case When RateTab.VATCommissionF=1 and (Case When Cover.ISType not in ('T','R') or Profile.VATCOMMEXEMPTIF=0 Then cast(1 as Bit) Else 0 END)=1 then 1 else 0 end    	
		Else
			1
		End)
		*(Case   
		When SysTab.TaxMethod in (0,3,4) Then  
			Case When ((AccAss.Type in ('BB','BA','BC','BP','BD','OP','OR')) or ((AccAss.Type not in ('BB','BA','BC','BP','BD','OP','OR','DI','IC','CF','JP','BO') and TOC.VATBusinessF=1) or (Insured.VATF=1 and TOC.VATBusinessF=1))) Then 1 Else 0 End  
		Else  
			Case When ((AccAss.Type in ('BB','BA','BC','BP','BD','OP','OR')) or ((AccAss.Type not in ('BB','BA','BC','BP','BD','OP','OR','DI','IC','CF','JP','BO')) or (Insured.VATF=1 and TOC.VATBusinessF=1))) Then 1 Else 0 End  
		End)
	 *(Case When Profile.VatF=1 or AccAss.Type in ('DI','IC','CF','JP','BO') Then 1 else 0 end)  
	 *(Case When Acceptance.NoRefundF=7 and AccAss.Type in ('BB','BA','BO','BC','BP','BD') and AccAss.Code in ('C','O') then 0 else 1 end)  
	 *(Case When Acceptance.NoRefundF in (8,10,14) then 0 else 1 end)  
	 *(Case When SysTab.VATSubsidiesF=1 or Profile.VATSubsidiesF=1 then 1 else 0 end)  
	 *(Case When Accass.Type in ('BB','BA') Then 1 else 0 end)
	 )  
	 ,Accass.Currency)
	 *Case When (Max(MParam.VAT)/100)<0 Then -(Max(MParam.VAT)/100) else 0 end 
	 When Max(coalesce((Admlink.Amount-Admlink.Amount_11-Admlink.Amount_12-(Admlink.Amount_8+Admlink.Amount_13+Admlink.Amount_17+Admlink.Amount_18)-Admlink.Amount_14),0))<>0 then   
		Case 
		When round(Max(Admlink.Amount_13+Admlink.Amount_14),4)=round(Max(-Admlink.Amount_8),4) or round(Max(Admlink.Amount_13),4)=round(Max(-Admlink.Amount_8),4) then
			sum((-Admlink.Amount_13)*AccAss.Amount)/Max(coalesce((Admlink.Amount-Admlink.Amount_11-Admlink.Amount_12-(Admlink.Amount_8+Admlink.Amount_13+Admlink.Amount_17+Admlink.Amount_18)-Admlink.Amount_14),0))  
		else
		0
		end
	 Else 
	   0
	 end  
	as VATSubsidies,         
	Case   
	When Max(Admlink.AdmNo) is null then  
	 dbo.roundccy(  
	 sum(  
	 AccAss.Amount  
	  *(Case  
		When SysTab.TaxMethod in (0,3) Then  
			Case When ((AccAss.Type in ('BB','BA','BC','BP','BD') and AccAss.Code in ('C','O')) or (AccAss.Type in ('OP','OR')) or (AccAss.Type in ('DI','IC','CF','JP','BO') and AccAss.Code in ('P','C','O','J','U')) or (AccAss.Type not in ('BB','BA','BC','BP','BD','OP','OP','DI','IC','CF','JP','BO') and AccAss.Code not in ('F','D'))) then 1 Else 0 End  
		When SysTab.TaxMethod in (4) Then  
			Case When ((AccAss.Type in ('BB','BA','BC','BP','BD') and AccAss.Code in ('C','O')) or (AccAss.Type in ('OP','OR')) or (AccAss.Type in ('DI','IC','CF','JP','BO') and AccAss.Code in ('P','C','D','O','J','U')) or (AccAss.Type not in ('BB','BA','BC','BP','BD','OP','OP','DI','IC','CF','JP','BO') and AccAss.Code not in ('F','D'))) then 1 Else 0 End  
		else  
			Case When ((AccAss.Type in ('CP','DC','QS','QP','S1','S2','S3','AF','XP','FO','FP','IR','IT','IX') and AccAss.Code in ('C')) or (AccAss.Type in ('BB','BA','BC','BP','BD') and AccAss.Code in ('C','O')) or (AccAss.Type in ('OP','OR')) or (AccAss.Type not in ('CP','DC','QS','QP','S1','S2','S3','AF','XP','FO','FP','IR','IT','IX','BB','BA','BC','BP','BD','OP','OR') and AccAss.Code not in ('F','D'))) then 1 Else 0 End     
		end)    
		*(Case When Profile.BVatF=1 or AccAss.Type in ('DI','IC','CF','JP','BO') Then 1 else 0 end)  
 	    *(Case When Acceptance.NoRefundF<>11 and Acceptance.NoRefundF<>14 and AccAss.Type in ('DI','IC','CF','JP','BO') and Insured.BVatF=1 then 1 else 0 end)  
	 )  
	 ,Accass.Currency)  
	 *Max((Case When coalesce(Acceptance.OverwriteBVatF,0)=0 Then Branch.VAT else coalesce(Acceptance.BVATPCT,0) end)/100)  
	When Max(coalesce((Admlink.Amount-Admlink.Amount_11-Admlink.Amount_12-(Admlink.Amount_8+Admlink.Amount_13+Admlink.Amount_17+Admlink.Amount_18)-Admlink.Amount_14),0))<>0 then   
	 sum((Admlink.Amount_17)*AccAss.Amount)/Max(coalesce((Admlink.Amount-Admlink.Amount_11-Admlink.Amount_12-(Admlink.Amount_8+Admlink.Amount_13+Admlink.Amount_17+Admlink.Amount_18)-Admlink.Amount_14),0))  
	Else 0 end  
	as VAT_1,        
	Case   
	When Max(Admlink.AdmNo) is null then  
	 Case when Max(AccAss.Type) in ('DI','IC','CF','JP','BO') Then    
	  Case   
	  When Max(SysTab.TaxMethod)=2 then  
	   dbo.roundccy(  
	   sum(  
	   AccAss.Amount*Case When (AccAss.Type in ('DI','IC') and Accass.Code in ('P','O','U')) or (AccAss.Type in ('CF','JP') and AccAss.Code in ('P','O')) or (AccAss.Type in ('BO')) Then 1 else 0 end     
	   *coalesce(RateCov.Portion,0)/coalesce(pRCover.Portion, RCover.Portion)  
	   *(Case When Acceptance.NoRefundF<>11 and Acceptance.NoRefundF<>14 and AccAss.Type in ('DI','IC','CF','JP','BO') and Insured.TVatF=1 then 1 else 0 end)
	   )  
	   ,Accass.Currency)  
	  When Max(SysTab.TaxMethod)=3 then  
	   dbo.roundccy(  
	   sum(  
	   AccAss.Amount*Case When (AccAss.Type in ('DI','IC') and Accass.Code in ('P','O','U')) or (AccAss.Type in ('CF','JP') and AccAss.Code in ('P','O')) or (AccAss.Type in ('BO')) Then 1 else 0 end     
	   *case When RateTab.VATF=1 and RateTab.VATEXEMPTF=0 then 1 else 0 end  
	   *(Case When Acceptance.NoRefundF<>11 and Acceptance.NoRefundF<>14 and AccAss.Type in ('DI','IC','CF','JP','BO') and Insured.TVatF=1 then 1 else 0 end)
	   )  
	   ,Accass.Currency)  
	  Else  
	   dbo.roundccy(  
	   sum(  
		 AccAss.Amount  
		  *(Case  
			When SysTab.TaxMethod in (0,3) Then  
				Case When ((AccAss.Type in ('BB','BA','BC','BP','BD') and AccAss.Code in ('C','O')) or (AccAss.Type in ('OP','OR')) or (AccAss.Type in ('DI','IC','CF','JP','BO') and AccAss.Code in ('P','C','O','J','U')) or (AccAss.Type not in ('BB','BA','BC','BP','BD','OP','OP','DI','IC','CF','JP','BO') and AccAss.Code not in ('F','D'))) then 1 Else 0 End  
			When SysTab.TaxMethod in (4) Then  
				Case When ((AccAss.Type in ('BB','BA','BC','BP','BD') and AccAss.Code in ('C','O')) or (AccAss.Type in ('OP','OR')) or (AccAss.Type in ('DI','IC','CF','JP','BO') and AccAss.Code in ('P','C','D','O','J','U')) or (AccAss.Type not in ('BB','BA','BC','BP','BD','OP','OP','DI','IC','CF','JP','BO') and AccAss.Code not in ('F','D'))) then 1 Else 0 End  
			else  
				Case When ((AccAss.Type in ('CP','DC','QS','QP','S1','S2','S3','AF','XP','FO','FP','IR','IT','IX') and AccAss.Code in ('C')) or (AccAss.Type in ('BB','BA','BC','BP','BD') and AccAss.Code in ('C','O')) or (AccAss.Type in ('OP','OR')) or (AccAss.Type not in ('CP','DC','QS','QP','S1','S2','S3','AF','XP','FO','FP','IR','IT','IX','BB','BA','BC','BP','BD','OP','OR') and AccAss.Code not in ('F','D'))) then 1 Else 0 End     
			end)    
			*(Case   
			When SysTab.TaxMethod in (3) and ((AccAss.Type in ('BB','BA','BC','BP','BD'))) Then  
				case When RateTab.VATCommissionF=1 and (Case When Cover.ISType not in ('T','R') or Profile.VATCOMMEXEMPTIF=0 Then cast(1 as Bit) Else 0 END)=1 then 1 else 0 end    	
			Else
				1
			End)    
			*(Case When Profile.TVatF=1 or (AccAss.Type in ('DI','IC','CF','JP','BO')) Then 1 else 0 end)  
		    *(Case When Acceptance.NoRefundF<>11 and Acceptance.NoRefundF<>14 and AccAss.Type in ('DI','IC','CF','JP','BO') and Insured.TVatF=1 then 1 else 0 end)		
	   )  
	   ,Accass.Currency)  
	  end      
	 else  
	  0  
	 end  
	 *Max((Case When coalesce(Acceptance.OverwriteTVatF,0)=0 Then TOC.VAT else coalesce(Acceptance.TVATPCT,0) end)/100)  
	When Max(coalesce((Admlink.Amount-Admlink.Amount_11-Admlink.Amount_12-(Admlink.Amount_8+Admlink.Amount_13+Admlink.Amount_17+Admlink.Amount_18)-Admlink.Amount_14),0))<>0 then   
	 sum((Admlink.Amount_18)*AccAss.Amount)/Max(coalesce((Admlink.Amount-Admlink.Amount_11-Admlink.Amount_12-(Admlink.Amount_8+Admlink.Amount_13+Admlink.Amount_17+Admlink.Amount_18)-Admlink.Amount_14),0))  
	Else 0 end  
	as VAT_2,   
	Case   
	When Max(Admlink.AdmNo) is null then  
	 dbo.roundccy(  
	 sum(  
	 -(  
	  Case   
	  When charindex(AccAss.Type,'FOFPQSQPS1S2S3AF')<>0  then  
	   Case   
	   When TaxType.MTaxType in ('PASAL21','PASAL23','PASAL4') Then  
		Case When AccAss.Code<>'P' then 1 else 0 end      
	   else  
		Case When AccAss.Code<>'C' then 1 else 0 end      
	   end  
	  Else  
	   1  
	  End  
	  *AccAss.Amount  
	  )  
	 *(Case When Profile.TaxF=1 Then 1 Else 0 End)  
	 *(Case   
	  When TaxType.MTaxType='PASAL21' Then   
	   Case When (Case When MParam.UseTaxTypeF=0 Then MParam.PASAL21 Else TaxType.TaxRate End)<>0 Then (Case When Profile.AccruedTax<>0 Then Profile.AccruedTax else (Case When MParam.UseTaxTypeF=0 Then MParam.PASAL21 Else TaxType.TaxRate End)*(100-MParam.TaxDiscount)/100 end) else 0 end/100    
	  When TaxType.MTaxType='PASAL23' Then  
	   Case When (Case When MParam.UseTaxTypeF=0 Then MParam.PASAL23 Else TaxType.TaxRate End)<>0 Then (Case When Profile.AccruedTax<>0 Then Profile.AccruedTax else (Case When MParam.UseTaxTypeF=0 Then MParam.PASAL23 Else TaxType.TaxRate End) end) else 0 end/100   
	  When TaxType.MTaxType='PASAL26' Then   
	   Case When (Case When MParam.UseTaxTypeF=0 Then MParam.PASAL26 Else TaxType.TaxRate End)<>0 Then (Case When Profile.AccruedTax<>0 Then Profile.AccruedTax else (Case When MParam.UseTaxTypeF=0 Then MParam.PASAL26 Else TaxType.TaxRate End) end) else 0 end/100  
	  When TaxType.MTaxType='PASAL4' Then   
	   Case When (Case When MParam.UseTaxTypeF=0 Then MParam.PASAL4 Else TaxType.TaxRate End)<>0 Then (Case When Profile.AccruedTax<>0 Then Profile.AccruedTax else (Case When MParam.UseTaxTypeF=0 Then MParam.PASAL4 Else TaxType.TaxRate End) end) else 0 end/100  
	  ELSE Profile.AccruedTax/100  
	  END)  
	 *Case When coalesce(Profile.TaxPCT,0)=0 then 1 else Profile.TaxPCT/100 end  
	 *(Case When Acceptance.NoRefundF=7 and AccAss.Type in ('BB','BA','BO','BC','BP','BD') and AccAss.Code in ('C') then 0 else 1 end)  
	 *(Case When Acceptance.NoRefundF in (9,10) then 0 else 1 end)  
	 )  
	 ,AccAss.Currency)  
	When Max(coalesce((Admlink.Amount-Admlink.Amount_11-Admlink.Amount_12-(Admlink.Amount_8+Admlink.Amount_13+Admlink.Amount_17+Admlink.Amount_18)-Admlink.Amount_14),0))<>0 then   
	 sum((Admlink.Amount_14)*AccAss.Amount)/Max(coalesce((Admlink.Amount-Admlink.Amount_11-Admlink.Amount_12-(Admlink.Amount_8+Admlink.Amount_13+Admlink.Amount_17+Admlink.Amount_18)-Admlink.Amount_14),0))  
	Else 0 end  
	as TAX,
	Case   
	When Max(Admlink.AdmNo) is null then  
	 dbo.roundccy(  
	 sum(  
	 -(  
	  Case   
	  When charindex(AccAss.Type,'FOFPQSQPS1S2S3AF')<>0  then  
	   Case   
	   When TaxType.MTaxType in ('PASAL21','PASAL23','PASAL4') Then  
		Case When AccAss.Code<>'P' then 1 else 0 end      
	   else  
		Case When AccAss.Code<>'C' then 1 else 0 end      
	   end  
	  Else  
	   1  
	  End  
	  *AccAss.Amount  
	  )  
	 *(Case When Profile.TaxF=1 Then 1 Else 0 End)  
	 *(Case   
	  When TaxType.MTaxType='PASAL21' Then   
	   Case When (Case When MParam.UseTaxTypeF=0 Then MParam.PASAL21 Else TaxType.TaxRate End)<>0 Then (Case When Profile.AccruedTax<>0 Then Profile.AccruedTax else (Case When MParam.UseTaxTypeF=0 Then MParam.PASAL21 Else TaxType.TaxRate End)*(100-MParam.TaxDiscount)/100 end) else 0 end/100    
	  When TaxType.MTaxType='PASAL23' Then  
	   Case When (Case When MParam.UseTaxTypeF=0 Then MParam.PASAL23 Else TaxType.TaxRate End)<>0 Then (Case When Profile.AccruedTax<>0 Then Profile.AccruedTax else (Case When MParam.UseTaxTypeF=0 Then MParam.PASAL23 Else TaxType.TaxRate End) end) else 0 end/100   
	  When TaxType.MTaxType='PASAL26' Then   
	   Case When (Case When MParam.UseTaxTypeF=0 Then MParam.PASAL26 Else TaxType.TaxRate End)<>0 Then (Case When Profile.AccruedTax<>0 Then Profile.AccruedTax else (Case When MParam.UseTaxTypeF=0 Then MParam.PASAL26 Else TaxType.TaxRate End) end) else 0 end/100  
	  When TaxType.MTaxType='PASAL4' Then   
	   Case When (Case When MParam.UseTaxTypeF=0 Then MParam.PASAL4 Else TaxType.TaxRate End)<>0 Then (Case When Profile.AccruedTax<>0 Then Profile.AccruedTax else (Case When MParam.UseTaxTypeF=0 Then MParam.PASAL4 Else TaxType.TaxRate End) end) else 0 end/100  
	  ELSE Profile.AccruedTax/100  
	  END)  
	 *Case When coalesce(Profile.TaxPCT,0)=0 then 1 else Profile.TaxPCT/100 end  
	 *(Case When Acceptance.NoRefundF=7 and AccAss.Type in ('BB','BA','BO','BC','BP','BD') and AccAss.Code in ('C') then 0 else 1 end)  
	 *(Case When Acceptance.NoRefundF in (9,10) then 0 else 1 end)  
	 *(Case When Profile.TAXSubsidiesF=1 then -1 else 0 end)  
	 *(Case When Accass.Type in ('BB','BA') Then 1 else 0 end)
	 )  
	 ,AccAss.Currency)  
	When Max(coalesce((Admlink.Amount-Admlink.Amount_11-Admlink.Amount_12-(Admlink.Amount_8+Admlink.Amount_13+Admlink.Amount_17+Admlink.Amount_18)-Admlink.Amount_14),0))<>0 then   
		Case 
		When round(Max(Admlink.Amount_13+Admlink.Amount_14),4)=round(Max(-Admlink.Amount_8),4) or round(Max(Admlink.Amount_14),4)=round(Max(-Admlink.Amount_8),4) then
			sum((-Admlink.Amount_14)*AccAss.Amount)/Max(coalesce((Admlink.Amount-Admlink.Amount_11-Admlink.Amount_12-(Admlink.Amount_8+Admlink.Amount_13+Admlink.Amount_17+Admlink.Amount_18)-Admlink.Amount_14),0))  
		else
		0
		end
	Else 0 end  
	as TAXSubsidies
	FROM Acceptance   
	Inner Join Cover on (Cover.CNO=Acceptance.CNO)  
	Inner Join TOC on (TOC.TOC=Acceptance.TOC)  
	Inner Join Branch on (Branch.Branch=Acceptance.Branch)  
	Inner Join Profile Insured on (Insured.ID=Acceptance.AID)  
	Inner Join AccAss on (Acceptance.ANO=AccAss.ANO)  
	Left Join APayor on (APayor.ANO=Acceptance.ANO and Acceptance.LANO<>-1 and Acceptance.ANO<>Acceptance.LANO)                                
	Left Join Payor on (Payor.ANO=Acceptance.ANO and Acceptance.LANO=-1)                
	Left Join Acceptance pAcceptance on (pAcceptance.ANO=Acceptance.pANO)  
	Left Join Admlink on (Admlink.AdmNo=AccAss.AdmNo and not ((Acceptance.LANO<>-1 and Cover.OpenFlag=0) or (Acceptance.BulkF=1))) 
	Inner Join Profile on (Profile.ID=AccAss.ID)  
	Left Join TaxType on (TaxType.TaxType=Profile.TaxType)  
	Inner Join Mparam on (MParam.Type=AccAss.Type)  
	Outer Apply (
		Select mPayor.ANO, mPayor.PolicyYearF 
		from Acceptance mAcceptance, Cover mCover, Payor mPayor
		Where mCover.CNO=mAcceptance.CNO and mPayor.ANO=mAcceptance.ANO and mAcceptance.ANO=mAcceptance.LANO and MAcceptance.RegNo=Acceptance.RegNo and mCover.ASource=@ASource 
	) mPayor
	Inner Join SysTab on (1=1)  
	Left Join RateTab on (RateTab.Code=AccAss.RCode)  
	Left Join RCover on (RCover.ANO=Acceptance.ANO and RCover.Code=AccAss.RCode and RCover.SDate=AccAss.SDate)  
	Left Join RCover pRCover on (AccAss.CAmount=0 and pRCover.ANO=Acceptance.pANO and pRCover.Code=AccAss.RCode and pRCover.SDate=AccAss.SDate)  
	Outer apply (Select sum(RateCov.Portion) as Portion from RateCov Where RateCov.Code=AccAss.RCode and RateCov.VatF=1) as RateCov  
	WHERE Acceptance.ANO=@P_ANO          
	GROUP BY AccAss.ID, Profile.Name, AccAss.Type, AccAss.Posted, AccAss.Admno, AccAss.Currency, Acceptance.RegNo, Accass.DocNo, AccAss.RefNo,        
	Case When AccAss.CAmount=0 and Coalesce(pAcceptance.Branch,'')<>'' Then pAcceptance.Branch Else Acceptance.Branch end,   dbo.fn_Get_UWYear(Acceptance.SDate, Acceptance.EDate, Case When (Case When isnull(APayor.ANO,0)=0 Then (Case When isnull(MPayor.ANO,0)=0 Then Payor.PolicyYearF else MPayor.PolicyYearF end) else APayor.PolicyYearF end)=1 Then AccAss.SDate else Acceptance.SDate end)   

End

Go
IF EXISTS ( SELECT * FROM   sysobjects WHERE  id = object_id(N'View07A') and OBJECTPROPERTY(id, N'IsProcedure') = 1 )
BEGIN
DROP PROCEDURE View07A 
end
GO
CREATE PROCEDURE View07A (@P_ANO as integer)                
AS                
Declare @MRegNo as varchar(50)  
Declare @MSDate as smalldatetime  
Declare @MEDate as smalldatetime  
Declare @AStatus as varchar(1)  
Declare @AType as varchar(1)  
Declare @ASource as varchar(10)  
  
Select @MRegNo=A.RegNo, @MSDate=A.SDate, @MEDate=A.EDate, @AStatus=A.AStatus, @AType=A.AType, @ASource=C.ASource from Acceptance A, Cover C Where C.CNO=A.CNO and A.ANO=@P_ANO  
  
Declare @View07 Table (ID varchar(10), Name varchar(255), Type varchar(10), Posted Bit, AdmNo Int, Currency varchar(10), RegNo varchar(50), DocNo varchar(50), RefNo varchar(50), Branch varchar(10), PolicyYear Int, Grace Int, Premium Float, Commision Float, OverridingCommission Float, Fee Float, Duty Float, Discount Float, Acquisition Float, PremiumAdjustment Float, OtherIncome Float, Ujroh Float, Tabarru Float, Deposit Float, Advance Float, Rounding Float, VAT Float, VATSubsidies Float, VAT_1 Float, VAT_2 Float, TAX Float, TAXSubsidies Float)  
  
if (@MRegNo='' or @AStatus in ('W','T') or (@ASource='MKT' and @AType='N'))  
Begin  
 insert into  @View07  
 SELECT AccAss.ID, Profile.Name, AccAss.Type, AccAss.Posted, AccAss.Admno, AccAss.Currency, Acceptance.RegNo, Accass.DocNo, AccAss.RefNo,        
 Case When AccAss.CAmount=0 and Coalesce(pAcceptance.Branch,'')<>'' Then pAcceptance.Branch Else Acceptance.Branch end Branch,     
 dbo.fn_Get_UWYear(@MSDate, @MEDate, Case When (Case When isnull(APayor.ANO,0)=0 Then (Case When isnull(MPayor.ANO,0)=0 Then Payor.PolicyYearF else MPayor.PolicyYearF end) else APayor.PolicyYearF end)=1 Then AccAss.SDate else Acceptance.SDate end) as PolicyYear,  
 (Case When isnull(APayor.ANO,0)=0 Then (Case When isnull(MPayor.ANO,0)=0 Then Payor.Grace else MPayor.Grace end) else APayor.Grace end) as Grace,  
 sum(                  
  case                  
   when (accass.type in ('IR','IT','IX') and accass.code in ('P','U','F')) or (accass.type in ('DI','IC') and accass.code in ('P','U')) or (AccAss.Type not in ('DI','IC','IR','IT','IX') and AccAss.Code='P') then AccAss.Amount                  
   else 0                  
  end                  
 )   
 +  
 sum(  
  Case   
   When Acceptance.NoRefundF=7 and AccAss.Type in ('BB','BA','BO','BC','BP','BD') and AccAss.Code in ('C') then AccAss.Amount   
   else 0   
  end  
 )   
 AS Premium,                   
 sum(                  
  case                   
   when accass.code='C' and coalesce(accass.codeext,'') in ('','V') then AccAss.Amount                  
   else 0                  
  end                  
 )   
 -  
 sum(  
  Case   
   When Acceptance.NoRefundF=7 and AccAss.Type in ('BB','BA','BO','BC','BP','BD') and AccAss.Code in ('C') then AccAss.Amount   
   else 0   
  end  
 )  
 AS Commision,                   
 sum(                  
  case                   
   when accass.code='C' and coalesce(accass.codeext,'')='1' then AccAss.Amount                  
   else 0                  
  end                  
 ) AS OverridingCommission,                   
 sum(                  
  case                   
   when accass.Type not in ('IR','IT','IX') and accass.code='F' then AccAss.Amount                  
   else 0                  
  end                  
 ) AS Fee,                   
 sum(                  
  case                   
   when accass.code='D' then AccAss.Amount                  
   else 0                  
  end                  
 ) AS Duty,                   
 sum(                  
  case                   
   when accass.type not in ('CP','DC','XP','QS','QP','S1','S2','S3','AF','FO','FP') and accass.code='O' then AccAss.Amount                  
   else 0                  
  end                  
 ) AS Discount,                   
 sum(                  
  case                   
   when accass.type in ('CP','DC','XP','QS','QP','S1','S2','S3','AF','FO','FP') and accass.code='O' and coalesce(accass.CodeExt,'')='' then AccAss.Amount                  
   else 0                  
  end                  
 ) AS Acquisition,     
 sum(                  
  case       
   when accass.type in ('CP','DC','XP','QS','QP','S1','S2','S3','AF','FO','FP') and accass.code='O' and coalesce(accass.CodeExt,'')='1' then AccAss.Amount                  
   else 0                  
  end                  
 ) AS PremiumAdjustment,                                 
 sum(                  
  case                  
   when accass.code='I' then AccAss.Amount                  
   else 0                  
  end                  
 ) AS OtherIncome,                 
 sum(                  
  case                  
   when accass.type in ('IR','IT','IX') and accass.code='F' then -AccAss.Amount  
   when accass.Type in ('DI','IC') and accass.code='U' then -AccAss.Amount          
   when accass.Type Not in ('DI','IC') and accass.code='U' then AccAss.Amount          
   else 0   
  End         
 ) AS Ujroh,        
 sum(                  
  case                  
   when (accass.type in ('IR','IT','IX') and accass.code in ('P','U'))  or (accass.type in ('DI','IC') and accass.code in ('P')) or (AccAss.Type not in ('DI','IC','IR','IT','IX') and AccAss.Code in ('P','U')) then AccAss.Amount                  
   else 0                  
  end                  
 ) AS Tabarru,           
 sum(                  
  case                  
   when accass.type not in ('CP','DC','XP','QS','QP','S1','S2','S3','AF','FO','FP') and accass.code='J' then AccAss.Amount                  
   else 0                  
  end                  
 ) AS Deposit,           
 sum(                  
  case                   
   when accass.type in ('CP','DC','XP','QS','QP','S1','S2','S3','AF','FO','FP') and accass.code='J' then AccAss.Amount                  
   else 0                  
  end                  
 ) AS Advance,                    
 dbo.roundccy(sum(AccAss.Amount),AccAss.Currency) - sum(AccAss.Amount)as Rounding,   
 Case   
 When Max(Admlink.AdmNo) is null then  
  dbo.roundccy(  
  sum(  
  AccAss.Amount  
  *(Case  
	When SysTab.TaxMethod in (0,3) Then  
		Case When ((AccAss.Type in ('BB','BA','BC','BP','BD') and AccAss.Code in ('C','O')) or (AccAss.Type in ('OP','OR')) or (AccAss.Type in ('DI','IC','CF','JP','BO') and AccAss.Code in ('P','C','O','J','U')) or (AccAss.Type not in ('BB','BA','BC','BP','BD','OP','OP','DI','IC','CF','JP','BO') and AccAss.Code not in ('F','D'))) then 1 Else 0 End  
	When SysTab.TaxMethod in (4) Then  
		Case When ((AccAss.Type in ('BB','BA','BC','BP','BD') and AccAss.Code in ('C','O')) or (AccAss.Type in ('OP','OR')) or (AccAss.Type in ('DI','IC','CF','JP','BO') and AccAss.Code in ('P','C','D','O','J','U')) or (AccAss.Type not in ('BB','BA','BC','BP','BD','OP','OP','DI','IC','CF','JP','BO') and AccAss.Code not in ('F','D'))) then 1 Else 0 End  
	else  
		Case When ((AccAss.Type in ('CP','DC','QS','QP','S1','S2','S3','AF','XP','FO','FP','IR','IT','IX') and AccAss.Code in ('C')) or (AccAss.Type in ('BB','BA','BC','BP','BD') and AccAss.Code in ('C','O')) or (AccAss.Type in ('OP','OR')) or (AccAss.Type not in ('CP','DC','QS','QP','S1','S2','S3','AF','XP','FO','FP','IR','IT','IX','BB','BA','BC','BP','BD','OP','OR') and AccAss.Code not in ('F','D'))) then 1 Else 0 End     
	end)    
	*(Case   
	When SysTab.TaxMethod in (3) and ((AccAss.Type in ('BB','BA','BC','BP','BD'))) Then  
		case When RateTab.VATCommissionF=1 and (Case When Cover.ISType not in ('T','R') or Profile.VATCOMMEXEMPTIF=0 Then cast(1 as Bit) Else 0 END)=1 then 1 else 0 end    	
	Else
		1
	End)
	*(Case   
	When SysTab.TaxMethod in (0,3,4) Then  
		Case When ((AccAss.Type in ('BB','BA','BC','BP','BD','OP','OR')) or ((AccAss.Type not in ('BB','BA','BC','BP','BD','OP','OR','DI','IC','CF','JP','BO') and TOC.VATBusinessF=1) or (Insured.VATF=1 and TOC.VATBusinessF=1))) Then 1 Else 0 End  
	Else  
		Case When ((AccAss.Type in ('BB','BA','BC','BP','BD','OP','OR')) or ((AccAss.Type not in ('BB','BA','BC','BP','BD','OP','OR','DI','IC','CF','JP','BO')) or (Insured.VATF=1 and TOC.VATBusinessF=1))) Then 1 Else 0 End  
	End)   
  *(Case When Profile.VatF=1 or AccAss.Type in ('DI','IC','CF','JP','BO') Then 1 else 0 end)  
  *(Case When Acceptance.NoRefundF=7 and AccAss.Type in ('BB','BA','BO','BC','BP','BD') and AccAss.Code in ('C','O') then 0 else 1 end)  
  *(Case When Acceptance.NoRefundF in (8,10,14) then 0 else 1 end)  
  )  
  ,Accass.Currency) 
  *(Max(MParam.VAT)/100)  
  +
  dbo.roundccy(sum(case When AccAss.Code='V' Then AccAss.Amount else 0 End),Accass.Currency)
 When Max(coalesce((Admlink.Amount-Admlink.Amount_11-Admlink.Amount_12-(Admlink.Amount_8+Admlink.Amount_13+Admlink.Amount_17+Admlink.Amount_18)-Admlink.Amount_14),0))<>0 then   
  sum((Admlink.Amount_13)*case When AccAss.Code<>'V' Then AccAss.Amount else 0 End)/Max(coalesce((Admlink.Amount-Admlink.Amount_11-Admlink.Amount_12-(Admlink.Amount_8+Admlink.Amount_13+Admlink.Amount_17+Admlink.Amount_18)-Admlink.Amount_14),0))  
 Else 0 end  
 as VAT,          
 Case   
 When Max(Admlink.AdmNo) is null then  
  dbo.roundccy(  
  sum(  
  AccAss.Amount  
  *(Case  
	When SysTab.TaxMethod in (0,3) Then  
		Case When ((AccAss.Type in ('BB','BA','BC','BP','BD') and AccAss.Code in ('C','O')) or (AccAss.Type in ('OP','OR')) or (AccAss.Type in ('DI','IC','CF','JP','BO') and AccAss.Code in ('P','C','O','J','U')) or (AccAss.Type not in ('BB','BA','BC','BP','BD','OP','OP','DI','IC','CF','JP','BO') and AccAss.Code not in ('F','D'))) then 1 Else 0 End  
	When SysTab.TaxMethod in (4) Then  
		Case When ((AccAss.Type in ('BB','BA','BC','BP','BD') and AccAss.Code in ('C','O')) or (AccAss.Type in ('OP','OR')) or (AccAss.Type in ('DI','IC','CF','JP','BO') and AccAss.Code in ('P','C','D','O','J','U')) or (AccAss.Type not in ('BB','BA','BC','BP','BD','OP','OP','DI','IC','CF','JP','BO') and AccAss.Code not in ('F','D'))) then 1 Else 0 End  
	else  
		Case When ((AccAss.Type in ('CP','DC','QS','QP','S1','S2','S3','AF','XP','FO','FP','IR','IT','IX') and AccAss.Code in ('C')) or (AccAss.Type in ('BB','BA','BC','BP','BD') and AccAss.Code in ('C','O')) or (AccAss.Type in ('OP','OR')) or (AccAss.Type not in ('CP','DC','QS','QP','S1','S2','S3','AF','XP','FO','FP','IR','IT','IX','BB','BA','BC','BP','BD','OP','OR') and AccAss.Code not in ('F','D'))) then 1 Else 0 End     
	end)    
	*(Case   
	When SysTab.TaxMethod in (3) and ((AccAss.Type in ('BB','BA','BC','BP','BD'))) Then  
		case When RateTab.VATCommissionF=1 and (Case When Cover.ISType not in ('T','R') or Profile.VATCOMMEXEMPTIF=0 Then cast(1 as Bit) Else 0 END)=1 then 1 else 0 end    	
	Else
		1
	End)
	*(Case   
	When SysTab.TaxMethod in (0,3,4) Then  
		Case When ((AccAss.Type in ('BB','BA','BC','BP','BD','OP','OR')) or ((AccAss.Type not in ('BB','BA','BC','BP','BD','OP','OR','DI','IC','CF','JP','BO') and TOC.VATBusinessF=1) or (Insured.VATF=1 and TOC.VATBusinessF=1))) Then 1 Else 0 End  
	Else  
		Case When ((AccAss.Type in ('BB','BA','BC','BP','BD','OP','OR')) or ((AccAss.Type not in ('BB','BA','BC','BP','BD','OP','OR','DI','IC','CF','JP','BO')) or (Insured.VATF=1 and TOC.VATBusinessF=1))) Then 1 Else 0 End  
	End)
  *(Case When Profile.VatF=1 or AccAss.Type in ('DI','IC','CF','JP','BO') Then 1 else 0 end)  
  *(Case When Acceptance.NoRefundF=7 and AccAss.Type in ('BB','BA','BO','BC','BP','BD') and AccAss.Code in ('C','O') then 0 else 1 end)  
  *(Case When Acceptance.NoRefundF in (8,10,14) then 0 else 1 end)  
  *(Case When SysTab.VATSubsidiesF=1 or Profile.VATSubsidiesF=1 then 1 else 0 end)  
  *(Case When Accass.Type in ('BB','BA') Then 1 else 0 end)
  )  
  ,Accass.Currency)  
  *Case When (Max(MParam.VAT)/100)<0 Then -(Max(MParam.VAT)/100) else 0 end  
 When Max(coalesce((Admlink.Amount-Admlink.Amount_11-Admlink.Amount_12-(Admlink.Amount_8+Admlink.Amount_13+Admlink.Amount_17+Admlink.Amount_18)-Admlink.Amount_14),0))<>0 then   
	Case 
	When round(Max(Admlink.Amount_13+Admlink.Amount_14),4)=round(Max(-Admlink.Amount_8),4) or round(Max(Admlink.Amount_13),4)=round(Max(-Admlink.Amount_8),4) then
		sum((-Admlink.Amount_13)*AccAss.Amount)/Max(coalesce((Admlink.Amount-Admlink.Amount_11-Admlink.Amount_12-(Admlink.Amount_8+Admlink.Amount_13+Admlink.Amount_17+Admlink.Amount_18)-Admlink.Amount_14),0))  
	else
	0
	end
 Else 0 end  
 as VATSubsidies,         
 Case   
 When Max(Admlink.AdmNo) is null then  
  dbo.roundccy(  
  sum(  
  AccAss.Amount  
  *(Case  
	When SysTab.TaxMethod in (0,3) Then  
		Case When ((AccAss.Type in ('BB','BA','BC','BP','BD') and AccAss.Code in ('C','O')) or (AccAss.Type in ('OP','OR')) or (AccAss.Type in ('DI','IC','CF','JP','BO') and AccAss.Code in ('P','C','O','J','U')) or (AccAss.Type not in ('BB','BA','BC','BP','BD','OP','OP','DI','IC','CF','JP','BO') and AccAss.Code not in ('F','D'))) then 1 Else 0 End  
	When SysTab.TaxMethod in (4) Then  
		Case When ((AccAss.Type in ('BB','BA','BC','BP','BD') and AccAss.Code in ('C','O')) or (AccAss.Type in ('OP','OR')) or (AccAss.Type in ('DI','IC','CF','JP','BO') and AccAss.Code in ('P','C','D','O','J','U')) or (AccAss.Type not in ('BB','BA','BC','BP','BD','OP','OP','DI','IC','CF','JP','BO') and AccAss.Code not in ('F','D'))) then 1 Else 0 End  
	else  
		Case When ((AccAss.Type in ('CP','DC','QS','QP','S1','S2','S3','AF','XP','FO','FP','IR','IT','IX') and AccAss.Code in ('C')) or (AccAss.Type in ('BB','BA','BC','BP','BD') and AccAss.Code in ('C','O')) or (AccAss.Type in ('OP','OR')) or (AccAss.Type not in ('CP','DC','QS','QP','S1','S2','S3','AF','XP','FO','FP','IR','IT','IX','BB','BA','BC','BP','BD','OP','OR') and AccAss.Code not in ('F','D'))) then 1 Else 0 End     
	end)    
	*(Case When Profile.BVatF=1 or AccAss.Type in ('DI','IC','CF','JP','BO') Then 1 else 0 end)  
    *(Case When Acceptance.NoRefundF<>11 and Acceptance.NoRefundF<>14 and AccAss.Type in ('DI','IC','CF','JP','BO') and Insured.BVatF=1 then 1 else 0 end)  
  )  
  ,Accass.Currency)  
  *Max((Case When coalesce(Acceptance.OverwriteBVatF,0)=0 Then Branch.VAT else coalesce(Acceptance.BVATPCT,0) end)/100)  
 When Max(coalesce((Admlink.Amount-Admlink.Amount_11-Admlink.Amount_12-(Admlink.Amount_8+Admlink.Amount_13+Admlink.Amount_17+Admlink.Amount_18)-Admlink.Amount_14),0))<>0 then   
  sum((Admlink.Amount_17)*AccAss.Amount)/Max(coalesce((Admlink.Amount-Admlink.Amount_11-Admlink.Amount_12-(Admlink.Amount_8+Admlink.Amount_13+Admlink.Amount_17+Admlink.Amount_18)-Admlink.Amount_14),0))  
 Else 0 end  
 as VAT_1,        
 Case   
 When Max(Admlink.AdmNo) is null then  
  Case when Max(AccAss.Type) in ('DI','IC','CF','JP','BO') Then    
   Case   
   When Max(SysTab.TaxMethod)=2 then  
    dbo.roundccy(  
    sum(  
    AccAss.Amount*Case When (AccAss.Type in ('DI','IC') and Accass.Code in ('P','O','U')) or (AccAss.Type in ('CF','JP') and AccAss.Code in ('P','O')) or (AccAss.Type in ('BO')) Then 1 else 0 end     
    *coalesce(RateCov.Portion,0)/coalesce(pRCover.Portion, RCover.Portion)  
	*(Case When Acceptance.NoRefundF<>11 and Acceptance.NoRefundF<>14 and AccAss.Type in ('DI','IC','CF','JP','BO') and Insured.TVatF=1 then 1 else 0 end)
    )  
    ,Accass.Currency)  
   When Max(SysTab.TaxMethod)=3 then  
    dbo.roundccy(  
    sum(  
    AccAss.Amount*Case When (AccAss.Type in ('DI','IC') and Accass.Code in ('P','O','U')) or (AccAss.Type in ('CF','JP') and AccAss.Code in ('P','O')) or (AccAss.Type in ('BO')) Then 1 else 0 end     
    *case When RateTab.VATF=1 and RateTab.VATEXEMPTF=0 then 1 else 0 end  
	*(Case When Acceptance.NoRefundF<>11 and Acceptance.NoRefundF<>14 and AccAss.Type in ('DI','IC','CF','JP','BO') and Insured.TVatF=1 then 1 else 0 end)
    )  
    ,Accass.Currency)  
   Else  
    dbo.roundccy(  
    sum(  
    AccAss.Amount  
	*(Case  
	When SysTab.TaxMethod in (0,3) Then  
		Case When ((AccAss.Type in ('BB','BA','BC','BP','BD') and AccAss.Code in ('C','O')) or (AccAss.Type in ('OP','OR')) or (AccAss.Type in ('DI','IC','CF','JP','BO') and AccAss.Code in ('P','C','O','J','U')) or (AccAss.Type not in ('BB','BA','BC','BP','BD','OP','OP','DI','IC','CF','JP','BO') and AccAss.Code not in ('F','D'))) then 1 Else 0 End  
	When SysTab.TaxMethod in (4) Then  
		Case When ((AccAss.Type in ('BB','BA','BC','BP','BD') and AccAss.Code in ('C','O')) or (AccAss.Type in ('OP','OR')) or (AccAss.Type in ('DI','IC','CF','JP','BO') and AccAss.Code in ('P','C','D','O','J','U')) or (AccAss.Type not in ('BB','BA','BC','BP','BD','OP','OP','DI','IC','CF','JP','BO') and AccAss.Code not in ('F','D'))) then 1 Else 0 End  
	else  
		Case When ((AccAss.Type in ('CP','DC','QS','QP','S1','S2','S3','AF','XP','FO','FP','IR','IT','IX') and AccAss.Code in ('C')) or (AccAss.Type in ('BB','BA','BC','BP','BD') and AccAss.Code in ('C','O')) or (AccAss.Type in ('OP','OR')) or (AccAss.Type not in ('CP','DC','QS','QP','S1','S2','S3','AF','XP','FO','FP','IR','IT','IX','BB','BA','BC','BP','BD','OP','OR') and AccAss.Code not in ('F','D'))) then 1 Else 0 End     
	end)    
	*(Case   
	When SysTab.TaxMethod in (3) and ((AccAss.Type in ('BB','BA','BC','BP','BD'))) Then  
		case When RateTab.VATCommissionF=1 and (Case When Cover.ISType not in ('T','R') or Profile.VATCOMMEXEMPTIF=0 Then cast(1 as Bit) Else 0 END)=1 then 1 else 0 end    	
	Else
		1
	End)    
	*(Case When Profile.TVatF=1 or (AccAss.Type in ('DI','IC','CF','JP','BO')) Then 1 else 0 end)  
	*(Case When Acceptance.NoRefundF<>11 and Acceptance.NoRefundF<>14 and AccAss.Type in ('DI','IC','CF','JP','BO') and Insured.TVatF=1 then 1 else 0 end)
    )  
    ,Accass.Currency)  
   end  
  else  
   0  
  end      
  *Max((Case When coalesce(Acceptance.OverwriteTVatF,0)=0 Then TOC.VAT else coalesce(Acceptance.TVATPCT,0) end)/100)  
 When Max(coalesce((Admlink.Amount-Admlink.Amount_11-Admlink.Amount_12-(Admlink.Amount_8+Admlink.Amount_13+Admlink.Amount_17+Admlink.Amount_18)-Admlink.Amount_14),0))<>0 then   
  sum((Admlink.Amount_18)*AccAss.Amount)/Max(coalesce((Admlink.Amount-Admlink.Amount_11-Admlink.Amount_12-(Admlink.Amount_8+Admlink.Amount_13+Admlink.Amount_17+Admlink.Amount_18)-Admlink.Amount_14),0))  
 Else 0 end  
 as VAT_2,   
 Case    
 When Max(Admlink.AdmNo) is null then  
  dbo.Roundccy(  
  sum(  
  -(  
   Case   
   When charindex(AccAss.Type,'FOFPQSQPS1S2S3AF')<>0  then  
    Case   
    When TaxType.MTaxType in ('PASAL21','PASAL23','PASAL4') Then  
     Case When AccAss.Code<>'P' then 1 else 0 end      
    else  
     Case When AccAss.Code<>'C' then 1 else 0 end      
    end  
   Else  
    1  
   End  
   *AccAss.Amount  
   )  
  *(Case When Profile.TaxF=1 Then 1 Else 0 End)  
  *(Case   
   When TaxType.MTaxType='PASAL21' Then   
    Case When (Case When MParam.UseTaxTypeF=0 Then MParam.PASAL21 Else TaxType.TaxRate End)<>0 Then (Case When Profile.AccruedTax<>0 Then Profile.AccruedTax else (Case When MParam.UseTaxTypeF=0 Then MParam.PASAL21 Else TaxType.TaxRate End)*(100-MParam.TaxDiscount)/100 end) else 0 end/100  
   When TaxType.MTaxType='PASAL23' Then  
    Case When (Case When MParam.UseTaxTypeF=0 Then MParam.PASAL23 Else TaxType.TaxRate End)<>0 Then (Case When Profile.AccruedTax<>0 Then Profile.AccruedTax else (Case When MParam.UseTaxTypeF=0 Then MParam.PASAL23 Else TaxType.TaxRate End) end) else 0 end/100   
   When TaxType.MTaxType='PASAL26' Then   
    Case When (Case When MParam.UseTaxTypeF=0 Then MParam.PASAL26 Else TaxType.TaxRate End)<>0 Then (Case When Profile.AccruedTax<>0 Then Profile.AccruedTax else (Case When MParam.UseTaxTypeF=0 Then MParam.PASAL26 Else TaxType.TaxRate End) end) else 0 end/100  
   When TaxType.MTaxType='PASAL4' Then   
    Case When (Case When MParam.UseTaxTypeF=0 Then MParam.PASAL4 Else TaxType.TaxRate End)<>0 Then (Case When Profile.AccruedTax<>0 Then Profile.AccruedTax else (Case When MParam.UseTaxTypeF=0 Then MParam.PASAL4 Else TaxType.TaxRate End) end) else 0 end/100  
   ELSE Profile.AccruedTax/100  
    END)  
  *Case When coalesce(Profile.TaxPCT,0)=0 then 1 else Profile.TaxPCT/100 end  
  *(Case When Acceptance.NoRefundF=7 and AccAss.Type in ('BB','BA','BO','BC','BP','BD') and AccAss.Code in ('C') then 0 else 1 end)  
  *(Case When Acceptance.NoRefundF in (9,10) then 0 else 1 end)  
  ),AccAss.Currency)  
 When Max(coalesce((Admlink.Amount-Admlink.Amount_11-Admlink.Amount_12-(Admlink.Amount_8+Admlink.Amount_13+Admlink.Amount_17+Admlink.Amount_18)-Admlink.Amount_14),0))<>0 then   
  sum((Admlink.Amount_14)*AccAss.Amount)/Max(coalesce((Admlink.Amount-Admlink.Amount_11-Admlink.Amount_12-(Admlink.Amount_8+Admlink.Amount_13+Admlink.Amount_17+Admlink.Amount_18)-Admlink.Amount_14),0))  
 Else 0 end  
 as TAX,  
 Case    
 When Max(Admlink.AdmNo) is null then  
  dbo.Roundccy(  
  sum(  
  -(  
   Case   
   When charindex(AccAss.Type,'FOFPQSQPS1S2S3AF')<>0  then  
    Case   
    When TaxType.MTaxType in ('PASAL21','PASAL23','PASAL4') Then  
     Case When AccAss.Code<>'P' then 1 else 0 end      
    else  
     Case When AccAss.Code<>'C' then 1 else 0 end      
    end  
   Else  
    1  
   End  
   *AccAss.Amount  
   )  
  *(Case When Profile.TaxF=1 Then 1 Else 0 End)  
  *(Case   
   When TaxType.MTaxType='PASAL21' Then   
    Case When (Case When MParam.UseTaxTypeF=0 Then MParam.PASAL21 Else TaxType.TaxRate End)<>0 Then (Case When Profile.AccruedTax<>0 Then Profile.AccruedTax else (Case When MParam.UseTaxTypeF=0 Then MParam.PASAL21 Else TaxType.TaxRate End)*(100-MParam.TaxDiscount)/100 end) else 0 end/100  
   When TaxType.MTaxType='PASAL23' Then  
    Case When (Case When MParam.UseTaxTypeF=0 Then MParam.PASAL23 Else TaxType.TaxRate End)<>0 Then (Case When Profile.AccruedTax<>0 Then Profile.AccruedTax else (Case When MParam.UseTaxTypeF=0 Then MParam.PASAL23 Else TaxType.TaxRate End) end) else 0 end/100   
   When TaxType.MTaxType='PASAL26' Then   
    Case When (Case When MParam.UseTaxTypeF=0 Then MParam.PASAL26 Else TaxType.TaxRate End)<>0 Then (Case When Profile.AccruedTax<>0 Then Profile.AccruedTax else (Case When MParam.UseTaxTypeF=0 Then MParam.PASAL26 Else TaxType.TaxRate End) end) else 0 end/100  
   When TaxType.MTaxType='PASAL4' Then   
    Case When (Case When MParam.UseTaxTypeF=0 Then MParam.PASAL4 Else TaxType.TaxRate End)<>0 Then (Case When Profile.AccruedTax<>0 Then Profile.AccruedTax else (Case When MParam.UseTaxTypeF=0 Then MParam.PASAL4 Else TaxType.TaxRate End) end) else 0 end/100  
   ELSE Profile.AccruedTax/100  
    END)  
  *Case When coalesce(Profile.TaxPCT,0)=0 then 1 else Profile.TaxPCT/100 end  
  *(Case When Acceptance.NoRefundF=7 and AccAss.Type in ('BB','BA','BO','BC','BP','BD') and AccAss.Code in ('C') then 0 else 1 end)  
  *(Case When Acceptance.NoRefundF in (9,10) then 0 else 1 end)  
  *(Case When Profile.TAXSubsidiesF=1 then -1 else 0 end) 
  *(Case When Accass.Type in ('BB','BA') Then 1 else 0 end)
  ),AccAss.Currency)  
 When Max(coalesce((Admlink.Amount-Admlink.Amount_11-Admlink.Amount_12-(Admlink.Amount_8+Admlink.Amount_13+Admlink.Amount_17+Admlink.Amount_18)-Admlink.Amount_14),0))<>0 then   
	Case 
	When round(Max(Admlink.Amount_13+Admlink.Amount_14),4)=round(Max(-Admlink.Amount_8),4) or round(Max(Admlink.Amount_14),4)=round(Max(-Admlink.Amount_8),4) then
		sum((-Admlink.Amount_14)*AccAss.Amount)/Max(coalesce((Admlink.Amount-Admlink.Amount_11-Admlink.Amount_12-(Admlink.Amount_8+Admlink.Amount_13+Admlink.Amount_17+Admlink.Amount_18)-Admlink.Amount_14),0))  
	else
	0
	end
 Else 0 end  
 as TAXSubsidies
 FROM Acceptance   
 Inner Join Cover on (Cover.CNO=Acceptance.CNO)  
 Inner Join TOC on (TOC.TOC=Acceptance.TOC)  
 Inner Join Branch on (Branch.Branch=Acceptance.Branch)  
 Inner Join Profile Insured on (Insured.ID=Acceptance.AID)  
 Inner Join AccAss on (Acceptance.ANO=AccAss.ANO)  
 Left Join APayor on (APayor.ANO=Acceptance.ANO and Acceptance.LANO<>-1 and Acceptance.ANO<>Acceptance.LANO)                                
 Left Join Payor on (Payor.ANO=Acceptance.ANO and Acceptance.LANO=-1)                
 Left Join Acceptance pAcceptance on (pAcceptance.ANO=Acceptance.pANO)  
 Left Join Admlink on (Admlink.AdmNo=AccAss.AdmNo)  
 Inner Join Profile on (Profile.ID=AccAss.ID)  
 Left Join TaxType on (TaxType.TaxType=Profile.TaxType)  
 Inner Join Mparam on (MParam.Type=AccAss.Type)  
 Left Join Payor MPayor on (MPayor.ANO=@P_ANO)        
 Inner Join SysTab on (1=1)  
 Left Join RateTab on (RateTab.Code=AccAss.RCode)  
 Left Join RCover on (RCover.ANO=Acceptance.ANO and RCover.Code=AccAss.RCode and RCover.SDate=AccAss.SDate)  
 Left Join RCover pRCover on (AccAss.CAmount=0 and pRCover.ANO=Acceptance.pANO and pRCover.Code=AccAss.RCode and pRCover.SDate=AccAss.SDate)  
 Outer apply (Select sum(RateCov.Portion) as Portion from RateCov Where RateCov.Code=AccAss.RCode and RateCov.VatF=1) as RateCov  
 WHERE Acceptance.LANO=@P_ANO  
 GROUP BY AccAss.ID, Profile.Name, AccAss.Type, AccAss.Posted, AccAss.Admno, AccAss.Currency, Acceptance.RegNo, Accass.DocNo, AccAss.RefNo,        
 Case When AccAss.CAmount=0 and Coalesce(pAcceptance.Branch,'')<>'' Then pAcceptance.Branch Else Acceptance.Branch end,     
 dbo.fn_Get_UWYear(@MSDate, @MEDate, Case When (Case When isnull(APayor.ANO,0)=0 Then (Case When isnull(MPayor.ANO,0)=0 Then Payor.PolicyYearF else MPayor.PolicyYearF end) else APayor.PolicyYearF end)=1 Then AccAss.SDate else Acceptance.SDate end),  
 (Case When isnull(APayor.ANO,0)=0 Then (Case When isnull(MPayor.ANO,0)=0 Then Payor.Grace else MPayor.Grace end) else APayor.Grace end)  
END  
ELSE  
BEGIN  
 insert into  @View07  
 SELECT AccAss.ID, Profile.Name, AccAss.Type, AccAss.Posted, AccAss.Admno, AccAss.Currency, Acceptance.RegNo, Accass.DocNo, AccAss.RefNo,        
 Case When AccAss.CAmount=0 and Coalesce(pAcceptance.Branch,'')<>'' Then pAcceptance.Branch Else Acceptance.Branch end Branch,     
 dbo.fn_Get_UWYear(@MSDate, @MEDate, Case When (Case When isnull(APayor.ANO,0)=0 Then (Case When isnull(MPayor.ANO,0)=0 Then Payor.PolicyYearF else MPayor.PolicyYearF end) else APayor.PolicyYearF end)=1 Then AccAss.SDate else Acceptance.SDate end) as PolicyYear,  
 (Case When isnull(APayor.ANO,0)=0 Then (Case When isnull(MPayor.ANO,0)=0 Then Payor.Grace else MPayor.Grace end) else APayor.Grace end) as Grace,  
 sum(                  
  case                  
   when (accass.type in ('IR','IT','IX') and accass.code in ('P','U','F')) or (accass.type in ('DI','IC') and accass.code in ('P','U')) or (AccAss.Type not in ('DI','IC','IR','IT','IX') and AccAss.Code='P') then AccAss.Amount    
   else 0                  
  end                  
 )   
 +  
 sum(  
Case   
   When Acceptance.NoRefundF=7 and AccAss.Type in ('BB','BA','BO','BC','BP','BD') and AccAss.Code in ('C') then AccAss.Amount   
   else 0   
  end  
 )   
 AS Premium,                   
 sum(                  
  case        
when accass.code='C' and coalesce(accass.codeext,'') in ('','V') then AccAss.Amount                  
   else 0                  
  end                  
 )   
 -  
 sum(  
  Case   
   When Acceptance.NoRefundF=7 and AccAss.Type in ('BB','BA','BO','BC','BP','BD') and AccAss.Code in ('C') then AccAss.Amount   
   else 0   
  end  
 )   
 AS Commision,                   
 sum(                  
  case                   
   when accass.code='C' and coalesce(accass.codeext,'')='1' then AccAss.Amount                  
   else 0                  
  end                  
 ) AS OverridingCommission,                   
 sum(                  
  case                   
   when accass.Type not in ('IR','IT','IX') and accass.code='F' then AccAss.Amount                  
   else 0                  
  end                  
 ) AS Fee,              
 sum(                  
  case                   
  when accass.code='D' then AccAss.Amount                  
   else 0                  
  end                  
 ) AS Duty,                   
 sum(                  
  case                   
   when accass.type not in ('CP','DC','XP','QS','QP','S1','S2','S3','AF','FO','FP') and accass.code='O' then AccAss.Amount                  
   else 0                  
  end                  
 ) AS Discount,                   
 sum(                  
  case                   
   when accass.type in ('CP','DC','XP','QS','QP','S1','S2','S3','AF','FO','FP') and accass.code='O' and coalesce(accass.CodeExt,'')='' then AccAss.Amount                  
   else 0                  
  end                  
 ) AS Acquisition,     
 sum(                  
  case                   
   when accass.type in ('CP','DC','XP','QS','QP','S1','S2','S3','AF','FO','FP') and accass.code='O' and coalesce(accass.CodeExt,'')='1' then AccAss.Amount                  
   else 0                  
  end                  
 ) AS PremiumAdjustment,                                 
 sum(                  
  case                  
   when accass.code='I' then AccAss.Amount                  
   else 0                  
  end                  
 ) AS OtherIncome,                 
 sum(                  
  case                  
   when accass.type in ('IR','IT','IX') and accass.code='F' then -AccAss.Amount  
   when accass.Type in ('DI','IC') and accass.code='U' then -AccAss.Amount          
   when accass.Type Not in ('DI','IC') and accass.code='U' then AccAss.Amount          
   else 0                  
  End      
 ) AS Ujroh,                
 sum(                  
  case                  
   when (accass.type in ('IR','IT','IX') and accass.code in ('P','U'))  or (accass.type in ('DI','IC') and accass.code in ('P')) or (AccAss.Type not in ('DI','IC','IR','IT','IX') and AccAss.Code in ('P','U')) then AccAss.Amount                  
   else 0                  
  end                  
 ) AS Tabarru,           
 sum(                  
  case                  
   when accass.type not in ('CP','DC','XP','QS','QP','S1','S2','S3','AF','FO','FP') and accass.code='J' then AccAss.Amount                  
   else 0                  
  end                  
 ) AS Deposit,           
 sum(                  
  case                   
   when accass.type in ('CP','DC','XP','QS','QP','S1','S2','S3','AF','FO','FP') and accass.code='J' then AccAss.Amount               
   else 0                  
  end                  
 ) AS Advance,                    
 dbo.roundccy(sum(AccAss.Amount),AccAss.Currency) - sum(AccAss.Amount)as Rounding,   
 Case   
 When Max(Admlink.AdmNo) is null then  
  dbo.roundccy(  
  sum(  
  AccAss.Amount  
  *(Case  
	When SysTab.TaxMethod in (0,3) Then  
		Case When ((AccAss.Type in ('BB','BA','BC','BP','BD') and AccAss.Code in ('C','O')) or (AccAss.Type in ('OP','OR')) or (AccAss.Type in ('DI','IC','CF','JP','BO') and AccAss.Code in ('P','C','O','J','U')) or (AccAss.Type not in ('BB','BA','BC','BP','BD','OP','OP','DI','IC','CF','JP','BO') and AccAss.Code not in ('F','D'))) then 1 Else 0 End  
	When SysTab.TaxMethod in (4) Then  
		Case When ((AccAss.Type in ('BB','BA','BC','BP','BD') and AccAss.Code in ('C','O')) or (AccAss.Type in ('OP','OR')) or (AccAss.Type in ('DI','IC','CF','JP','BO') and AccAss.Code in ('P','C','D','O','J','U')) or (AccAss.Type not in ('BB','BA','BC','BP','BD','OP','OP','DI','IC','CF','JP','BO') and AccAss.Code not in ('F','D'))) then 1 Else 0 End  
	else  
		Case When ((AccAss.Type in ('CP','DC','QS','QP','S1','S2','S3','AF','XP','FO','FP','IR','IT','IX') and AccAss.Code in ('C')) or (AccAss.Type in ('BB','BA','BC','BP','BD') and AccAss.Code in ('C','O')) or (AccAss.Type in ('OP','OR')) or (AccAss.Type not in ('CP','DC','QS','QP','S1','S2','S3','AF','XP','FO','FP','IR','IT','IX','BB','BA','BC','BP','BD','OP','OR') and AccAss.Code not in ('F','D'))) then 1 Else 0 End     
	end)    
	*(Case   
	When SysTab.TaxMethod in (3) and ((AccAss.Type in ('BB','BA','BC','BP','BD'))) Then  
		case When RateTab.VATCommissionF=1 and (Case When Cover.ISType not in ('T','R') or Profile.VATCOMMEXEMPTIF=0 Then cast(1 as Bit) Else 0 END)=1 then 1 else 0 end    	
	Else
		1
	End)
	*(Case   
	When SysTab.TaxMethod in (0,3,4) Then  
		Case When ((AccAss.Type in ('BB','BA','BC','BP','BD','OP','OR')) or ((AccAss.Type not in ('BB','BA','BC','BP','BD','OP','OR','DI','IC','CF','JP','BO') and TOC.VATBusinessF=1) or (Insured.VATF=1 and TOC.VATBusinessF=1))) Then 1 Else 0 End  
	Else  
		Case When ((AccAss.Type in ('BB','BA','BC','BP','BD','OP','OR')) or ((AccAss.Type not in ('BB','BA','BC','BP','BD','OP','OR','DI','IC','CF','JP','BO')) or (Insured.VATF=1 and TOC.VATBusinessF=1))) Then 1 Else 0 End  
	End)   
  *(Case When Profile.VatF=1 or AccAss.Type in ('DI','IC','CF','JP','BO') Then 1 else 0 end)  
  *(Case When Acceptance.NoRefundF=7 and AccAss.Type in ('BB','BA','BO','BC','BP','BD') and AccAss.Code in ('C','O') then 0 else 1 end)  
  *(Case When Acceptance.NoRefundF in (8,10,14) then 0 else 1 end)  
  )  
  ,Accass.Currency)  
  *(Max(MParam.VAT)/100)  
  +
  dbo.roundccy(sum(case When AccAss.Code='V' Then AccAss.Amount else 0 End),Accass.Currency)  
 When Max(coalesce((Admlink.Amount-Admlink.Amount_11-Admlink.Amount_12-(Admlink.Amount_8+Admlink.Amount_13+Admlink.Amount_17+Admlink.Amount_18)-Admlink.Amount_14),0))<>0 then   
  sum((Admlink.Amount_13)*case When AccAss.Code<>'V' Then AccAss.Amount else 0 End)/Max(coalesce((Admlink.Amount-Admlink.Amount_11-Admlink.Amount_12-(Admlink.Amount_8+Admlink.Amount_13+Admlink.Amount_17+Admlink.Amount_18)-Admlink.Amount_14),0))  
 Else 0 end  
 as VAT,          
 Case   
 When Max(Admlink.AdmNo) is null then  
  dbo.roundccy(  
  sum(  
  AccAss.Amount  
  *(Case  
	When SysTab.TaxMethod in (0,3) Then  
		Case When ((AccAss.Type in ('BB','BA','BC','BP','BD') and AccAss.Code in ('C','O')) or (AccAss.Type in ('OP','OR')) or (AccAss.Type in ('DI','IC','CF','JP','BO') and AccAss.Code in ('P','C','O','J','U')) or (AccAss.Type not in ('BB','BA','BC','BP','BD','OP','OP','DI','IC','CF','JP','BO') and AccAss.Code not in ('F','D'))) then 1 Else 0 End  
	When SysTab.TaxMethod in (4) Then  
		Case When ((AccAss.Type in ('BB','BA','BC','BP','BD') and AccAss.Code in ('C','O')) or (AccAss.Type in ('OP','OR')) or (AccAss.Type in ('DI','IC','CF','JP','BO') and AccAss.Code in ('P','C','D','O','J','U')) or (AccAss.Type not in ('BB','BA','BC','BP','BD','OP','OP','DI','IC','CF','JP','BO') and AccAss.Code not in ('F','D'))) then 1 Else 0 End  
	else  
		Case When ((AccAss.Type in ('CP','DC','QS','QP','S1','S2','S3','AF','XP','FO','FP','IR','IT','IX') and AccAss.Code in ('C')) or (AccAss.Type in ('BB','BA','BC','BP','BD') and AccAss.Code in ('C','O')) or (AccAss.Type in ('OP','OR')) or (AccAss.Type not in ('CP','DC','QS','QP','S1','S2','S3','AF','XP','FO','FP','IR','IT','IX','BB','BA','BC','BP','BD','OP','OR') and AccAss.Code not in ('F','D'))) then 1 Else 0 End     
	end)    
	*(Case   
	When SysTab.TaxMethod in (3) and ((AccAss.Type in ('BB','BA','BC','BP','BD'))) Then  
		case When RateTab.VATCommissionF=1 and (Case When Cover.ISType not in ('T','R') or Profile.VATCOMMEXEMPTIF=0 Then cast(1 as Bit) Else 0 END)=1 then 1 else 0 end    	
	Else
		1
	End)
	*(Case   
	When SysTab.TaxMethod in (0,3,4) Then  
		Case When ((AccAss.Type in ('BB','BA','BC','BP','BD','OP','OR')) or ((AccAss.Type not in ('BB','BA','BC','BP','BD','OP','OR','DI','IC','CF','JP','BO') and TOC.VATBusinessF=1) or (Insured.VATF=1 and TOC.VATBusinessF=1))) Then 1 Else 0 End  
	Else  
		Case When ((AccAss.Type in ('BB','BA','BC','BP','BD','OP','OR')) or ((AccAss.Type not in ('BB','BA','BC','BP','BD','OP','OR','DI','IC','CF','JP','BO')) or (Insured.VATF=1 and TOC.VATBusinessF=1))) Then 1 Else 0 End  
	End)
  *(Case When Profile.VatF=1 or AccAss.Type in ('DI','IC','CF','JP','BO') Then 1 else 0 end)  
  *(Case When Acceptance.NoRefundF=7 and AccAss.Type in ('BB','BA','BO','BC','BP','BD') and AccAss.Code in ('C','O') then 0 else 1 end)  
  *(Case When Acceptance.NoRefundF in (8,10,14) then 0 else 1 end)  
  *(Case When SysTab.VATSubsidiesF=1 or Profile.VATSubsidiesF=1 then 1 else 0 end)  
  *(Case When Accass.Type in ('BB','BA') Then 1 else 0 end)
  )  
  ,Accass.Currency)  
  *Case When (Max(MParam.VAT)/100)<0 Then -(Max(MParam.VAT)/100) else 0 end  
 When Max(coalesce((Admlink.Amount-Admlink.Amount_11-Admlink.Amount_12-(Admlink.Amount_8+Admlink.Amount_13+Admlink.Amount_17+Admlink.Amount_18)-Admlink.Amount_14),0))<>0 then   
	Case 
	When round(Max(Admlink.Amount_13+Admlink.Amount_14),4)=round(Max(-Admlink.Amount_8),4) or round(Max(Admlink.Amount_13),4)=round(Max(-Admlink.Amount_8),4) then
		sum((-Admlink.Amount_13)*AccAss.Amount)/Max(coalesce((Admlink.Amount-Admlink.Amount_11-Admlink.Amount_12-(Admlink.Amount_8+Admlink.Amount_13+Admlink.Amount_17+Admlink.Amount_18)-Admlink.Amount_14),0))  
	else
	0
	end
 Else 0 end  
 as VATSubsidies,     
 Case   
 When Max(Admlink.AdmNo) is null then  
  dbo.roundccy(  
  sum(  
  AccAss.Amount  
  *(Case  
	When SysTab.TaxMethod in (0,3) Then  
		Case When ((AccAss.Type in ('BB','BA','BC','BP','BD') and AccAss.Code in ('C','O')) or (AccAss.Type in ('OP','OR')) or (AccAss.Type in ('DI','IC','CF','JP','BO') and AccAss.Code in ('P','C','O','J','U')) or (AccAss.Type not in ('BB','BA','BC','BP','BD','OP','OP','DI','IC','CF','JP','BO') and AccAss.Code not in ('F','D'))) then 1 Else 0 End  
	When SysTab.TaxMethod in (4) Then  
		Case When ((AccAss.Type in ('BB','BA','BC','BP','BD') and AccAss.Code in ('C','O')) or (AccAss.Type in ('OP','OR')) or (AccAss.Type in ('DI','IC','CF','JP','BO') and AccAss.Code in ('P','C','D','O','J','U')) or (AccAss.Type not in ('BB','BA','BC','BP','BD','OP','OP','DI','IC','CF','JP','BO') and AccAss.Code not in ('F','D'))) then 1 Else 0 End  
	else  
		Case When ((AccAss.Type in ('CP','DC','QS','QP','S1','S2','S3','AF','XP','FO','FP','IR','IT','IX') and AccAss.Code in ('C')) or (AccAss.Type in ('BB','BA','BC','BP','BD') and AccAss.Code in ('C','O')) or (AccAss.Type in ('OP','OR')) or (AccAss.Type not in ('CP','DC','QS','QP','S1','S2','S3','AF','XP','FO','FP','IR','IT','IX','BB','BA','BC','BP','BD','OP','OR') and AccAss.Code not in ('F','D'))) then 1 Else 0 End     
	end)    
	*(Case When Profile.BVatF=1 or AccAss.Type in ('DI','IC','CF','JP','BO') Then 1 else 0 end)  
    *(Case When Acceptance.NoRefundF<>11 and Acceptance.NoRefundF<>14 and AccAss.Type in ('DI','IC','CF','JP','BO') and Insured.BVatF=1 then 1 else 0 end)  
  )  
  ,Accass.Currency)  
  *Max((Case When coalesce(Acceptance.OverwriteBVatF,0)=0 Then Branch.VAT else coalesce(Acceptance.BVATPCT,0) end)/100)  
 When Max(coalesce((Admlink.Amount-Admlink.Amount_11-Admlink.Amount_12-(Admlink.Amount_8+Admlink.Amount_13+Admlink.Amount_17+Admlink.Amount_18)-Admlink.Amount_14),0))<>0 then   
  sum((Admlink.Amount_17)*AccAss.Amount)/Max(coalesce((Admlink.Amount-Admlink.Amount_11-Admlink.Amount_12-(Admlink.Amount_8+Admlink.Amount_13+Admlink.Amount_17+Admlink.Amount_18)-Admlink.Amount_14),0))  
 Else 0 end  
 as VAT_1,        
 Case   
 When Max(Admlink.AdmNo) is null then  
  Case when Max(AccAss.Type) in ('DI','IC','CF','JP','BO') Then    
   Case   
   When Max(SysTab.TaxMethod)=2 then  
    dbo.roundccy(  
    sum(  
    AccAss.Amount*Case When (AccAss.Type in ('DI','IC') and Accass.Code in ('P','O','U')) or (AccAss.Type in ('CF','JP') and AccAss.Code in ('P','O')) or (AccAss.Type in ('BO')) Then 1 else 0 end     
    *coalesce(RateCov.Portion,0)/coalesce(pRCover.Portion, RCover.Portion)  
    *(Case When Acceptance.NoRefundF<>11 and Acceptance.NoRefundF<>14 and AccAss.Type in ('DI','IC','CF','JP','BO') and Insured.TVatF=1 then 1 else 0 end)
    )  
    ,Accass.Currency)  
   When Max(SysTab.TaxMethod)=3 then  
    dbo.roundccy( 
    sum(  
    AccAss.Amount*Case When (AccAss.Type in ('DI','IC') and Accass.Code in ('P','O','U')) or (AccAss.Type in ('CF','JP') and AccAss.Code in ('P','O')) or (AccAss.Type in ('BO')) Then 1 else 0 end     
    *case When RateTab.VATF=1 and RateTab.VATEXEMPTF=0 then 1 else 0 end
	*(Case When Acceptance.NoRefundF<>11 and Acceptance.NoRefundF<>14 and AccAss.Type in ('DI','IC','CF','JP','BO') and Insured.TVatF=1 then 1 else 0 end)
    )  
    ,Accass.Currency)  
   Else  
    dbo.roundccy(  
    sum(  
    AccAss.Amount  
	*(Case  
	When SysTab.TaxMethod in (0,3) Then  
		Case When ((AccAss.Type in ('BB','BA','BC','BP','BD') and AccAss.Code in ('C','O')) or (AccAss.Type in ('OP','OR')) or (AccAss.Type in ('DI','IC','CF','JP','BO') and AccAss.Code in ('P','C','O','J','U')) or (AccAss.Type not in ('BB','BA','BC','BP','BD','OP','OP','DI','IC','CF','JP','BO') and AccAss.Code not in ('F','D'))) then 1 Else 0 End  
	When SysTab.TaxMethod in (4) Then  
		Case When ((AccAss.Type in ('BB','BA','BC','BP','BD') and AccAss.Code in ('C','O')) or (AccAss.Type in ('OP','OR')) or (AccAss.Type in ('DI','IC','CF','JP','BO') and AccAss.Code in ('P','C','D','O','J','U')) or (AccAss.Type not in ('BB','BA','BC','BP','BD','OP','OP','DI','IC','CF','JP','BO') and AccAss.Code not in ('F','D'))) then 1 Else 0 End  
	else  
		Case When ((AccAss.Type in ('CP','DC','QS','QP','S1','S2','S3','AF','XP','FO','FP','IR','IT','IX') and AccAss.Code in ('C')) or (AccAss.Type in ('BB','BA','BC','BP','BD') and AccAss.Code in ('C','O')) or (AccAss.Type in ('OP','OR')) or (AccAss.Type not in ('CP','DC','QS','QP','S1','S2','S3','AF','XP','FO','FP','IR','IT','IX','BB','BA','BC','BP','BD','OP','OR') and AccAss.Code not in ('F','D'))) then 1 Else 0 End     
	end)    
	*(Case   
	When SysTab.TaxMethod in (3) and ((AccAss.Type in ('BB','BA','BC','BP','BD'))) Then  
		case When RateTab.VATCommissionF=1 and (Case When Cover.ISType not in ('T','R') or Profile.VATCOMMEXEMPTIF=0 Then cast(1 as Bit) Else 0 END)=1 then 1 else 0 end    	
	Else
		1
	End)      
	*(Case When Profile.TVatF=1 or (AccAss.Type in ('DI','IC','CF','JP','BO')) Then 1 else 0 end)  
    *(Case When Acceptance.NoRefundF<>11 and Acceptance.NoRefundF<>14 and AccAss.Type in ('DI','IC','CF','JP','BO') and Insured.TVatF=1 then 1 else 0 end)
    )  
    ,Accass.Currency)  
   end  
  else  
   0  
  end    
  *Max((Case When coalesce(Acceptance.OverwriteTVatF,0)=0 Then TOC.VAT else coalesce(Acceptance.TVATPCT,0) end)/100)  
 When Max(coalesce((Admlink.Amount-Admlink.Amount_11-Admlink.Amount_12-(Admlink.Amount_8+Admlink.Amount_13+Admlink.Amount_17+Admlink.Amount_18)-Admlink.Amount_14),0))<>0 then   
  sum((Admlink.Amount_18)*AccAss.Amount)/Max(coalesce((Admlink.Amount-Admlink.Amount_11-Admlink.Amount_12-(Admlink.Amount_8+Admlink.Amount_13+Admlink.Amount_17+Admlink.Amount_18)-Admlink.Amount_14),0))  
 Else 0 end  
 as VAT_2,   
 Case    
 When Max(Admlink.AdmNo) is null then  
  dbo.Roundccy(  
  sum(  
 -(  
   Case   
   When charindex(AccAss.Type,'FOFPQSQPS1S2S3AF')<>0  then  
    Case   
    When TaxType.MTaxType in ('PASAL21','PASAL23','PASAL4') Then  
     Case When AccAss.Code<>'P' then 1 else 0 end      
    else  
     Case When AccAss.Code<>'C' then 1 else 0 end      
    end  
   Else  
    1  
   End  
   *AccAss.Amount  
   )  
  *(Case When Profile.TaxF=1 Then 1 Else 0 End)  
  *(Case   
   When TaxType.MTaxType='PASAL21' Then   
    Case When (Case When MParam.UseTaxTypeF=0 Then MParam.PASAL21 Else TaxType.TaxRate End)<>0 Then (Case When Profile.AccruedTax<>0 Then Profile.AccruedTax else (Case When MParam.UseTaxTypeF=0 Then MParam.PASAL21 Else TaxType.TaxRate End)*(100-MParam.TaxDiscount)/100 end) else 0 end/100  
   When TaxType.MTaxType='PASAL23' Then  
    Case When (Case When MParam.UseTaxTypeF=0 Then MParam.PASAL23 Else TaxType.TaxRate End)<>0 Then (Case When Profile.AccruedTax<>0 Then Profile.AccruedTax else (Case When MParam.UseTaxTypeF=0 Then MParam.PASAL23 Else TaxType.TaxRate End) end) else 0 end/100   
   When TaxType.MTaxType='PASAL26' Then   
    Case When (Case When MParam.UseTaxTypeF=0 Then MParam.PASAL26 Else TaxType.TaxRate End)<>0 Then (Case When Profile.AccruedTax<>0 Then Profile.AccruedTax else (Case When MParam.UseTaxTypeF=0 Then MParam.PASAL26 Else TaxType.TaxRate End) end) else 0 end/100  
   When TaxType.MTaxType='PASAL4' Then   
    Case When (Case When MParam.UseTaxTypeF=0 Then MParam.PASAL4 Else TaxType.TaxRate End)<>0 Then (Case When Profile.AccruedTax<>0 Then Profile.AccruedTax else (Case When MParam.UseTaxTypeF=0 Then MParam.PASAL4 Else TaxType.TaxRate End) end) else 0 end/100  
   ELSE Profile.AccruedTax/100  
    END)  
  *Case When coalesce(Profile.TaxPCT,0)=0 then 1 else Profile.TaxPCT/100 end  
  *(Case When Acceptance.NoRefundF=7 and AccAss.Type in ('BB','BA','BO','BC','BP','BD') and AccAss.Code in ('C') then 0 else 1 end)  
  *(Case When Acceptance.NoRefundF in (9,10) then 0 else 1 end)  
  ),AccAss.Currency)  
 When Max(coalesce((Admlink.Amount-Admlink.Amount_11-Admlink.Amount_12-(Admlink.Amount_8+Admlink.Amount_13+Admlink.Amount_17+Admlink.Amount_18)-Admlink.Amount_14),0))<>0 then   
  sum((Admlink.Amount_14)*AccAss.Amount)/Max(coalesce((Admlink.Amount-Admlink.Amount_11-Admlink.Amount_12-(Admlink.Amount_8+Admlink.Amount_13+Admlink.Amount_17+Admlink.Amount_18)-Admlink.Amount_14),0))  
 Else 0 end  
 as TAX,
Case    
 When Max(Admlink.AdmNo) is null then  
  dbo.Roundccy(  
  sum(  
 -(  
   Case   
   When charindex(AccAss.Type,'FOFPQSQPS1S2S3AF')<>0  then  
    Case   
    When TaxType.MTaxType in ('PASAL21','PASAL23','PASAL4') Then  
     Case When AccAss.Code<>'P' then 1 else 0 end      
    else  
     Case When AccAss.Code<>'C' then 1 else 0 end      
    end  
   Else  
    1  
   End  
   *AccAss.Amount  
   )  
  *(Case When Profile.TaxF=1 Then 1 Else 0 End)  
  *(Case   
   When TaxType.MTaxType='PASAL21' Then   
    Case When (Case When MParam.UseTaxTypeF=0 Then MParam.PASAL21 Else TaxType.TaxRate End)<>0 Then (Case When Profile.AccruedTax<>0 Then Profile.AccruedTax else (Case When MParam.UseTaxTypeF=0 Then MParam.PASAL21 Else TaxType.TaxRate End)*(100-MParam.TaxDiscount)/100 end) else 0 end/100  
   When TaxType.MTaxType='PASAL23' Then  
    Case When (Case When MParam.UseTaxTypeF=0 Then MParam.PASAL23 Else TaxType.TaxRate End)<>0 Then (Case When Profile.AccruedTax<>0 Then Profile.AccruedTax else (Case When MParam.UseTaxTypeF=0 Then MParam.PASAL23 Else TaxType.TaxRate End) end) else 0 end/100   
   When TaxType.MTaxType='PASAL26' Then   
    Case When (Case When MParam.UseTaxTypeF=0 Then MParam.PASAL26 Else TaxType.TaxRate End)<>0 Then (Case When Profile.AccruedTax<>0 Then Profile.AccruedTax else (Case When MParam.UseTaxTypeF=0 Then MParam.PASAL26 Else TaxType.TaxRate End) end) else 0 end/100  
   When TaxType.MTaxType='PASAL4' Then   
    Case When (Case When MParam.UseTaxTypeF=0 Then MParam.PASAL4 Else TaxType.TaxRate End)<>0 Then (Case When Profile.AccruedTax<>0 Then Profile.AccruedTax else (Case When MParam.UseTaxTypeF=0 Then MParam.PASAL4 Else TaxType.TaxRate End) end) else 0 end/100  
   ELSE Profile.AccruedTax/100  
    END)  
  *Case When coalesce(Profile.TaxPCT,0)=0 then 1 else Profile.TaxPCT/100 end  
  *(Case When Acceptance.NoRefundF=7 and AccAss.Type in ('BB','BA','BO','BC','BP','BD') and AccAss.Code in ('C') then 0 else 1 end)  
  *(Case When Acceptance.NoRefundF in (9,10) then 0 else 1 end)  
  *(Case When Profile.TAXSubsidiesF=1 then -1 else 0 end) 
  *(Case When Accass.Type in ('BB','BA') Then 1 else 0 end)
  ),AccAss.Currency)  
 When Max(coalesce((Admlink.Amount-Admlink.Amount_11-Admlink.Amount_12-(Admlink.Amount_8+Admlink.Amount_13+Admlink.Amount_17+Admlink.Amount_18)-Admlink.Amount_14),0))<>0 then   
	Case 
	When round(Max(Admlink.Amount_13+Admlink.Amount_14),4)=round(Max(-Admlink.Amount_8),4) or round(Max(Admlink.Amount_14),4)=round(Max(-Admlink.Amount_8),4) then
		sum((-Admlink.Amount_14)*AccAss.Amount)/Max(coalesce((Admlink.Amount-Admlink.Amount_11-Admlink.Amount_12-(Admlink.Amount_8+Admlink.Amount_13+Admlink.Amount_17+Admlink.Amount_18)-Admlink.Amount_14),0))  
	else
	0
	end
 Else 0 end  
 as TAXSubsidies
 FROM Acceptance  
 Inner Join Cover on (Cover.CNO=Acceptance.CNO)  
 Inner Join TOC on (TOC.TOC=Acceptance.TOC)  
 Inner Join Branch on (Branch.Branch=Acceptance.Branch)  
 Inner Join Profile Insured on (Insured.ID=Acceptance.AID)  
 Inner Join AccAss on (Acceptance.ANO=AccAss.ANO)  
 Left Join APayor on (APayor.ANO=Acceptance.ANO and Acceptance.LANO<>-1 and Acceptance.ANO<>Acceptance.LANO)                                
 Left Join Payor on (Payor.ANO=Acceptance.ANO and Acceptance.LANO=-1)                
 Left Join Acceptance pAcceptance on (pAcceptance.ANO=Acceptance.pANO)  
 Left Join Admlink on (Admlink.AdmNo=AccAss.AdmNo)  
 Inner Join Profile on (Profile.ID=AccAss.ID)  
 Left Join TaxType on (TaxType.TaxType=Profile.TaxType)  
 Inner Join Mparam on (MParam.Type=AccAss.Type)  
 Left Join Payor MPayor on (MPayor.ANO=@P_ANO)        
 Inner Join SysTab on (1=1)  
 Left Join RateTab on (RateTab.Code=AccAss.RCode)  
 Left Join RCover on (RCover.ANO=Acceptance.ANO and RCover.Code=AccAss.RCode and RCover.SDate=AccAss.SDate)  
 Left Join RCover pRCover on (AccAss.CAmount=0 and pRCover.ANO=Acceptance.pANO and pRCover.Code=AccAss.RCode and pRCover.SDate=AccAss.SDate)  
 Outer apply (Select sum(RateCov.Portion) as Portion from RateCov Where RateCov.Code=AccAss.RCode and RateCov.VatF=1) as RateCov  
 WHERE Acceptance.PolicyNo<>'' and Acceptance.RegNo=@MRegNo  
 GROUP BY AccAss.ID, Profile.Name, AccAss.Type, AccAss.Posted, AccAss.Admno, AccAss.Currency, Acceptance.RegNo, Accass.DocNo, AccAss.RefNo,        
 Case When AccAss.CAmount=0 and Coalesce(pAcceptance.Branch,'')<>'' Then pAcceptance.Branch Else Acceptance.Branch end,     
 dbo.fn_Get_UWYear(@MSDate, @MEDate, Case When (Case When isnull(APayor.ANO,0)=0 Then (Case When isnull(MPayor.ANO,0)=0 Then Payor.PolicyYearF else MPayor.PolicyYearF end) else APayor.PolicyYearF end)=1 Then AccAss.SDate else Acceptance.SDate end),  
 (Case When isnull(APayor.ANO,0)=0 Then (Case When isnull(MPayor.ANO,0)=0 Then Payor.Grace else MPayor.Grace end) else APayor.Grace end)  
END  
  
Select ID, Name, Type, cast(0 as Bit) as Posted, -1 as AdmNo, Currency,'SUMMARY' as RegNo, 'SUMMARY' as DocNo,'SUMMARY' as RefNo, 'SUMMARY' as Branch, 0 as PolicyYear, 0 as Grace,  
sum(Premium) as Premium, sum(Commision) as Commision, sum(OverridingCommission) as OverridingCommission, sum(Fee) as Fee, sum(Duty) as Duty,   
sum(Discount) as Discount, sum(Acquisition) as Acquisition, sum(PremiumAdjustment) as  PremiumAdjustment, sum(OtherIncome) as OtherIncome,   
sum(Ujroh) as Ujroh, sum(Tabarru) as Tabarru, sum(Deposit) as Deposit, sum(Advance) as Advance, sum(Rounding) as Rounding,   
sum(VAT) as VAT, sum(VATSubsidies) as VATSubsidies, sum(VAT_1) as VAT_1, sum(VAT_2) as VAT_2, sum(TAX) as TAX, sum(TAXSubsidies) as TAXSubsidies  
  
from @View07 View07  
Group by ID, Name, Type, Currency  
  
Union All  
Select *   
from @View07 View07 




go



  insert into PatchVersioning
select '1323 Update Script - Patch 2025 (15)',GETDATE()
go	
  

Declare @PrevScript varchar(100)
Declare @CurrScript varchar(100)

Select @PrevScript=''
Select @CurrSCript='1323 Update Script - Patch 2025 (15)'


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
