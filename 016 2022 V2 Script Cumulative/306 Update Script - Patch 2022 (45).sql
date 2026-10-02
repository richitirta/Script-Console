DROP FUNCTION fn_GetPNominalVat_ByRisk
GO
CREATE FUNCTION fn_GetPNominalVat_ByRisk(@P_ADMNO as int)
RETURNS Float
AS               
BEGIN              
Declare @P_PNominal_VAT as Float

Select @P_PNominal_VAT=sum(AccAss.Amount*RateCov.Portion/coalesce(pRCover.Portion, RCover.Portion))
from 
AccAss
Inner Join Acceptance on (Acceptance.ANO=AccAss.ANO)
Left Join RCover on (RCover.ANO=Acceptance.ANO and RCover.Code=AccAss.RCode and RCover.SDate=AccAss.SDate)
Left Join RCover pRCover on (AccAss.CAmount=0 and pRCover.ANO=Acceptance.pANO and pRCover.Code=AccAss.RCode and pRCover.SDate=AccAss.SDate)
cross apply (Select sum(RateCov.Portion) as Portion from RateCov Where RateCov.Code=AccAss.RCode and RateCov.VatF=1) as RateCov
Where AccAss.AdmNo=@P_AdmNo 
and 
(
(AccAss.Type in ('DI','IC') and Accass.Code in ('P','O','U')) 
or (AccAss.Type in ('CF','JP') and AccAss.Code in ('P','O')) 
or (AccAss.Type in ('BO'))
)

if @P_PNominal_VAT is null 
	Select @P_PNominal_VAT=0

return @P_PNominal_VAT
END  


GO

DROP PROCEDURE View07 
GO
CREATE PROCEDURE View07 (@p_ANo as integer)                
AS                
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
	*(Case When (AccAss.Type in ('BB','BA','BC','BP','BD','OP') and Profile.VATF=1) or (AccAss.Type not in ('BB','BA','BC','BP','BD','OP','DI','IC','CF','JP','BO') and Profile.VATF=1 and TOC.VATBusinessF=1) or (AccAss.Type in ('DI','IC','CF','JP','BO') and Insured.VATF=1 and TOC.VATBusinessF=1) Then 1 Else 0 End)
	*(Case When SysTab.TaxMethod=0 or (Accass.Type in ('CP','DC','QS','QP','S1','S2','S3','AF','XP','FO','FP','IR','IX') and AccAss.Code='C') or (AccAss.Type in ('OP')) or (Accass.Type Not in ('CP','DC','QS','QP','S1','S2','S3','AF','XP','FO','FP','IR','IX') and AccAss.Code Not in ('F','D')) Then 1 else 0 end)
	*(Case When Acceptance.NoRefundF=7 and AccAss.Type in ('BB','BA','BO','BC','BP','BD') and AccAss.Code in ('C') then 0 else 1 end)
	*(Case When Acceptance.NoRefundF in (8,10,14) then 0 else 1 end)
	)
	,Accass.Currency)
	*(Max(MParam.VAT)/100)
When Max(coalesce((Admlink.Amount-Admlink.Amount_11-Admlink.Amount_12-(Admlink.Amount_8+Admlink.Amount_13+Admlink.Amount_17+Admlink.Amount_18)-Admlink.Amount_14),0))<>0 then 
	sum((Admlink.Amount_13)*AccAss.Amount)/Max(coalesce((Admlink.Amount-Admlink.Amount_11-Admlink.Amount_12-(Admlink.Amount_8+Admlink.Amount_13+Admlink.Amount_17+Admlink.Amount_18)-Admlink.Amount_14),0))
Else 0 end
as VAT,       
Case 
When Max(Admlink.AdmNo) is null then
	dbo.roundccy(
	sum(
	AccAss.Amount
	*(Case When (AccAss.Type in ('BB','BA','BC','BP','BD','OP') and Profile.VATF=1) or (AccAss.Type not in ('BB','BA','BC','BP','BD','OP','DI','IC','CF','JP','BO') and Profile.VATF=1 and TOC.VATBusinessF=1) or (AccAss.Type in ('DI','IC','CF','JP','BO') and Insured.VATF=1 and TOC.VATBusinessF=1) Then 1 Else 0 End)
	*(Case When SysTab.TaxMethod=0 or (Accass.Type in ('CP','DC','QS','QP','S1','S2','S3','AF','XP','FO','FP','IR','IX') and AccAss.Code='C') or (AccAss.Type in ('OP')) or (Accass.Type Not in ('CP','DC','QS','QP','S1','S2','S3','AF','XP','FO','FP','IR','IX') and AccAss.Code Not in ('F','D')) Then 1 else 0 end)
	*(Case When Acceptance.NoRefundF=7 and AccAss.Type in ('BB','BA','BO','BC','BP','BD') and AccAss.Code in ('C') then 0 else 1 end)
	*(Case When Acceptance.NoRefundF in (8,10,14) then 0 else 1 end)
	*(Case When SysTab.VATSubsidiesF=1 or Profile.VATSubsidiesF=1 then 1 else 0 end)
	)
	,Accass.Currency)
	*Case When (Max(MParam.VAT)/100)<0 Then -(Max(MParam.VAT)/100) else 0 end When Max(coalesce((Admlink.Amount-Admlink.Amount_11-Admlink.Amount_12-(Admlink.Amount_8+Admlink.Amount_13+Admlink.Amount_17+Admlink.Amount_18)-Admlink.Amount_14),0))<>0 then 
	sum((Admlink.Amount_8)*AccAss.Amount)/Max(coalesce((Admlink.Amount-Admlink.Amount_11-Admlink.Amount_12-(Admlink.Amount_8+Admlink.Amount_13+Admlink.Amount_17+Admlink.Amount_18)-Admlink.Amount_14),0))
Else 0 end
as VATSubsidies,       
Case 
When Max(Admlink.AdmNo) is null then
	dbo.roundccy(
	sum(
	AccAss.Amount
	*(Case When SysTab.TaxMethod=0 or (Accass.Type in ('CP','DC','QS','QP','S1','S2','S3','AF','XP','FO','FP','IR','IX') and AccAss.Code='C') or (AccAss.Type in ('OP')) or (Accass.Type Not in ('CP','DC','QS','QP','S1','S2','S3','AF','XP','FO','FP','IR','IX') and AccAss.Code Not in ('F','D')) Then 1 else 0 end)
	*(Case When Profile.BVatF=1 or (AccAss.Type in ('DI','IC','CF','JP','BO')) Then 1 else 0 end)
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
	Case when Max(Admlink.Type) in ('DI','IC','CF','JP','BO') Then 	
		Case When Max(SysTab.TaxMethod)<>2 then
			dbo.roundccy(
			sum(
			AccAss.Amount
			*(Case When SysTab.TaxMethod=0 or (Accass.Type in ('CP','DC','QS','QP','S1','S2','S3','AF','XP','FO','FP','IR','IX') and AccAss.Code='C') or (AccAss.Type in ('OP')) or (Accass.Type Not in ('CP','DC','QS','QP','S1','S2','S3','AF','XP','FO','FP','IR','IX') and AccAss.Code Not in ('F','D')) Then 1 else 0 end)
			*(Case When Profile.TVatF=1 or (AccAss.Type in ('DI','IC','CF','JP','BO')) Then 1 else 0 end)
			*(Case When Acceptance.NoRefundF<>11 and Acceptance.NoRefundF<>14 and AccAss.Type in ('DI','IC','CF','JP','BO') and Insured.TVatF=1 then 1 else 0 end)
			)
			,Accass.Currency)
		else
			dbo.roundccy(
			sum(
			AccAss.Amount*coalesce(RateCov.Portion,0)/coalesce(pRCover.Portion, RCover.Portion)
			)
			,Accass.Currency)
		end
	else
		0
	end
	*Max((Case When coalesce(Acceptance.TVATPCT,0)=0 Then TOC.VAT else coalesce(Acceptance.TVATPCT,0) end)/100)
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
			Case When MParam.PASAL21<>0 Then (Case When Profile.AccruedTax<>0 Then Profile.AccruedTax else MParam.Pasal21*(100-MParam.TaxDiscount)/100 end) else 0 end/100
		When TaxType.MTaxType='PASAL23' Then
			Case When MParam.PASAL23<>0 Then (Case When Profile.AccruedTax<>0 Then Profile.AccruedTax else MParam.PASAL23 end) else 0 end/100 
		When TaxType.MTaxType='PASAL26' Then 
			Case When MParam.PASAL26<>0 Then (Case When Profile.AccruedTax<>0 Then Profile.AccruedTax else MParam.PASAL26 end) else 0 end/100
		When TaxType.MTaxType='PASAL4' Then 
			Case When MParam.PASAL4<>0 Then (Case When Profile.AccruedTax<>0 Then Profile.AccruedTax else MParam.PASAL4 end) else 0 end/100
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
as TAX  
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
Left Join Acceptance mAcceptance on (((Acceptance.RegNo<>'' and Acceptance.RegNo=mAcceptance.RegNo) or (Acceptance.RegNo='' and Acceptance.LANO=MAcceptance.ANO)) and MAcceptance.ANO=MAcceptance.LANO and MAcceptance.CNO=Acceptance.CNO)
Left Join Payor MPayor on (MPayor.ANO=mAcceptance.ANO)      
Inner Join SysTab on (1=1)
Left Join RCover on (RCover.ANO=Acceptance.ANO and RCover.Code=AccAss.RCode and RCover.SDate=AccAss.SDate)
Left Join RCover pRCover on (AccAss.CAmount=0 and pRCover.ANO=Acceptance.pANO and pRCover.Code=AccAss.RCode and pRCover.SDate=AccAss.SDate)
Outer apply (Select sum(RateCov.Portion) as Portion from RateCov Where RateCov.Code=AccAss.RCode and RateCov.VatF=1) as RateCov
WHERE Acceptance.ANO=@P_ANO        
GROUP BY AccAss.ID, Profile.Name, AccAss.Type, AccAss.Posted, AccAss.Admno, AccAss.Currency, Acceptance.RegNo, Accass.DocNo, AccAss.RefNo,      
Case When AccAss.CAmount=0 and Coalesce(pAcceptance.Branch,'')<>'' Then pAcceptance.Branch Else Acceptance.Branch end,   dbo.fn_Get_UWYear(Acceptance.SDate, Acceptance.EDate, Case When (Case When isnull(APayor.ANO,0)=0 Then (Case When isnull(MPayor.ANO,0)=0 Then Payor.PolicyYearF else MPayor.PolicyYearF end) else APayor.PolicyYearF end)=1 Then AccAss.SDate else Acceptance.SDate end) 


GO

DROP PROCEDURE View07A 
GO

CREATE PROCEDURE View07A (@p_ANo as integer)              
AS              
Declare @MRegNo as varchar(50)
Declare @MSDate as smalldatetime
Declare @MEDate as smalldatetime

Select @MRegNo=RegNo, @MSDate=SDate, @MEDate=EDate from Acceptance Where ANO=@P_ANO

if @MRegNo=''
Begin
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
		*(Case When (AccAss.Type in ('BB','BA','BC','BP','BD','OP') and Profile.VATF=1) or (AccAss.Type not in ('BB','BA','BC','BP','BD','OP','DI','IC','CF','JP','BO') and Profile.VATF=1 and TOC.VATBusinessF=1) or (AccAss.Type in ('DI','IC','CF','JP','BO') and Insured.VATF=1 and TOC.VATBusinessF=1) Then 1 Else 0 End)
		*(Case When SysTab.TaxMethod=0 or (Accass.Type in ('CP','DC','QS','QP','S1','S2','S3','AF','XP','FO','FP','IR','IX') and AccAss.Code='C') or (AccAss.Type in ('OP')) or (Accass.Type Not in ('CP','DC','QS','QP','S1','S2','S3','AF','XP','FO','FP','IR','IX') and AccAss.Code Not in ('F','D')) Then 1 else 0 end)
		*(Case When Acceptance.NoRefundF=7 and AccAss.Type in ('BB','BA','BO','BC','BP','BD') and AccAss.Code in ('C') then 0 else 1 end)
		*(Case When Acceptance.NoRefundF in (8,10,14) then 0 else 1 end)
		)
		,Accass.Currency)
		*(Max(MParam.VAT)/100)
	When Max(coalesce((Admlink.Amount-Admlink.Amount_11-Admlink.Amount_12-(Admlink.Amount_8+Admlink.Amount_13+Admlink.Amount_17+Admlink.Amount_18)-Admlink.Amount_14),0))<>0 then 
		sum((Admlink.Amount_13)*AccAss.Amount)/Max(coalesce((Admlink.Amount-Admlink.Amount_11-Admlink.Amount_12-(Admlink.Amount_8+Admlink.Amount_13+Admlink.Amount_17+Admlink.Amount_18)-Admlink.Amount_14),0))
	Else 0 end
	as VAT,        
	Case 
	When Max(Admlink.AdmNo) is null then
		dbo.roundccy(
		sum(
		AccAss.Amount
		*(Case When (AccAss.Type in ('BB','BA','BC','BP','BD','OP') and Profile.VATF=1) or (AccAss.Type not in ('BB','BA','BC','BP','BD','OP','DI','IC','CF','JP','BO') and Profile.VATF=1 and TOC.VATBusinessF=1) or (AccAss.Type in ('DI','IC','CF','JP','BO') and Insured.VATF=1 and TOC.VATBusinessF=1) Then 1 Else 0 End)
		*(Case When SysTab.TaxMethod=0 or (Accass.Type in ('CP','DC','QS','QP','S1','S2','S3','AF','XP','FO','FP','IR','IX') and AccAss.Code='C') or (AccAss.Type in ('OP')) or (Accass.Type Not in ('CP','DC','QS','QP','S1','S2','S3','AF','XP','FO','FP','IR','IX') and AccAss.Code Not in ('F','D')) Then 1 else 0 end)
		*(Case When Acceptance.NoRefundF=7 and AccAss.Type in ('BB','BA','BO','BC','BP','BD') and AccAss.Code in ('C') then 0 else 1 end)
		*(Case When Acceptance.NoRefundF in (8,10,14) then 0 else 1 end)
		*(Case When SysTab.VATSubsidiesF=1 or Profile.VATSubsidiesF=1 then 1 else 0 end)
		)
		,Accass.Currency)
		*Case When (Max(MParam.VAT)/100)<0 Then -(Max(MParam.VAT)/100) else 0 end
	When Max(coalesce((Admlink.Amount-Admlink.Amount_11-Admlink.Amount_12-(Admlink.Amount_8+Admlink.Amount_13+Admlink.Amount_17+Admlink.Amount_18)-Admlink.Amount_14),0))<>0 then 
		sum((Admlink.Amount_8)*AccAss.Amount)/Max(coalesce((Admlink.Amount-Admlink.Amount_11-Admlink.Amount_12-(Admlink.Amount_8+Admlink.Amount_13+Admlink.Amount_17+Admlink.Amount_18)-Admlink.Amount_14),0))
	Else 0 end
	as VATSubsidies,       
	Case 
	When Max(Admlink.AdmNo) is null then
		dbo.roundccy(
		sum(
		AccAss.Amount
		*(Case When SysTab.TaxMethod=0 or (Accass.Type in ('CP','DC','QS','QP','S1','S2','S3','AF','XP','FO','FP','IR','IX') and AccAss.Code='C') or (AccAss.Type in ('OP')) or (Accass.Type Not in ('CP','DC','QS','QP','S1','S2','S3','AF','XP','FO','FP','IR','IX') and AccAss.Code Not in ('F','D')) Then 1 else 0 end)
		*(Case When Profile.BVatF=1 or (AccAss.Type in ('DI','IC','CF','JP','BO')) Then 1 else 0 end)
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
		Case when Max(Admlink.Type) in ('DI','IC','CF','JP','BO') Then 	
			Case When Max(SysTab.TaxMethod)<>2 then
				dbo.roundccy(
				sum(
				AccAss.Amount
				*(Case When SysTab.TaxMethod=0 or (Accass.Type in ('CP','DC','QS','QP','S1','S2','S3','AF','XP','FO','FP','IR','IX') and AccAss.Code='C') or (AccAss.Type in ('OP')) or (Accass.Type Not in ('CP','DC','QS','QP','S1','S2','S3','AF','XP','FO','FP','IR','IX') and AccAss.Code Not in ('F','D')) Then 1 else 0 end)
				*(Case When Profile.TVatF=1 or (AccAss.Type in ('DI','IC','CF','JP','BO')) Then 1 else 0 end)
				*(Case When Acceptance.NoRefundF<>11 and Acceptance.NoRefundF<>14 and AccAss.Type in ('DI','IC','CF','JP','BO') and Insured.TVatF=1 then 1 else 0 end)
				)
				,Accass.Currency)
			else
				dbo.roundccy(
				sum(
				AccAss.Amount*coalesce(RateCov.Portion,0)/coalesce(pRCover.Portion, RCover.Portion)
				)
				,Accass.Currency)
			end
		else
			0
		end
		*Max((Case When coalesce(Acceptance.TVATPCT,0)=0 Then TOC.VAT else coalesce(Acceptance.TVATPCT,0) end)/100)
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
				Case When MParam.PASAL21<>0 Then (Case When Profile.AccruedTax<>0 Then Profile.AccruedTax else MParam.Pasal21*(100-MParam.TaxDiscount)/100 end) else 0 end/100
			When TaxType.MTaxType='PASAL23' Then
				Case When MParam.PASAL23<>0 Then (Case When Profile.AccruedTax<>0 Then Profile.AccruedTax else MParam.PASAL23 end) else 0 end/100 
			When TaxType.MTaxType='PASAL26' Then 
				Case When MParam.PASAL26<>0 Then (Case When Profile.AccruedTax<>0 Then Profile.AccruedTax else MParam.PASAL26 end) else 0 end/100
			When TaxType.MTaxType='PASAL4' Then 
				Case When MParam.PASAL4<>0 Then (Case When Profile.AccruedTax<>0 Then Profile.AccruedTax else MParam.PASAL4 end) else 0 end/100
			ELSE Profile.AccruedTax/100
		  END)
		*Case When coalesce(Profile.TaxPCT,0)=0 then 1 else Profile.TaxPCT/100 end
		*(Case When Acceptance.NoRefundF=7 and AccAss.Type in ('BB','BA','BO','BC','BP','BD') and AccAss.Code in ('C') then 0 else 1 end)
		*(Case When Acceptance.NoRefundF in (9,10) then 0 else 1 end)
		),AccAss.Currency)
	When Max(coalesce((Admlink.Amount-Admlink.Amount_11-Admlink.Amount_12-(Admlink.Amount_8+Admlink.Amount_13+Admlink.Amount_17+Admlink.Amount_18)-Admlink.Amount_14),0))<>0 then 
		sum((Admlink.Amount_14)*AccAss.Amount)/Max(coalesce((Admlink.Amount-Admlink.Amount_11-Admlink.Amount_12-(Admlink.Amount_8+Admlink.Amount_13+Admlink.Amount_17+Admlink.Amount_18)-Admlink.Amount_14),0))
	Else 0 end
	as TAX
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
		*(Case When (AccAss.Type in ('BB','BA','BC','BP','BD','OP') and Profile.VATF=1) or (AccAss.Type not in ('BB','BA','BC','BP','BD','OP','DI','IC','CF','JP','BO') and Profile.VATF=1 and TOC.VATBusinessF=1) or (AccAss.Type in ('DI','IC','CF','JP','BO') and Insured.VATF=1 and TOC.VATBusinessF=1) Then 1 Else 0 End)
		*(Case When SysTab.TaxMethod=0 or (Accass.Type in ('CP','DC','QS','QP','S1','S2','S3','AF','XP','FO','FP','IR','IX') and AccAss.Code='C') or (AccAss.Type in ('OP')) or (Accass.Type Not in ('CP','DC','QS','QP','S1','S2','S3','AF','XP','FO','FP','IR','IX') and AccAss.Code Not in ('F','D')) Then 1 else 0 end)
		*(Case When Acceptance.NoRefundF=7 and AccAss.Type in ('BB','BA','BO','BC','BP','BD') and AccAss.Code in ('C') then 0 else 1 end)
		*(Case When Acceptance.NoRefundF in (8,10,14) then 0 else 1 end)
		)
		,Accass.Currency)
		*(Max(MParam.VAT)/100)
	When Max(coalesce((Admlink.Amount-Admlink.Amount_11-Admlink.Amount_12-(Admlink.Amount_8+Admlink.Amount_13+Admlink.Amount_17+Admlink.Amount_18)-Admlink.Amount_14),0))<>0 then 
		sum((Admlink.Amount_13)*AccAss.Amount)/Max(coalesce((Admlink.Amount-Admlink.Amount_11-Admlink.Amount_12-(Admlink.Amount_8+Admlink.Amount_13+Admlink.Amount_17+Admlink.Amount_18)-Admlink.Amount_14),0))
	Else 0 end
	as VAT,        
	Case 
	When Max(Admlink.AdmNo) is null then
		dbo.roundccy(
		sum(
		AccAss.Amount
		*(Case When (AccAss.Type in ('BB','BA','BC','BP','BD','OP') and Profile.VATF=1) or (AccAss.Type not in ('BB','BA','BC','BP','BD','OP','DI','IC','CF','JP','BO') and Profile.VATF=1 and TOC.VATBusinessF=1) or (AccAss.Type in ('DI','IC','CF','JP','BO') and Insured.VATF=1 and TOC.VATBusinessF=1) Then 1 Else 0 End)
		*(Case When SysTab.TaxMethod=0 or (Accass.Type in ('CP','DC','QS','QP','S1','S2','S3','AF','XP','FO','FP','IR','IX') and AccAss.Code='C') or (AccAss.Type in ('OP')) or (Accass.Type Not in ('CP','DC','QS','QP','S1','S2','S3','AF','XP','FO','FP','IR','IX') and AccAss.Code Not in ('F','D')) Then 1 else 0 end)
		*(Case When Acceptance.NoRefundF=7 and AccAss.Type in ('BB','BA','BO','BC','BP','BD') and AccAss.Code in ('C') then 0 else 1 end)
		*(Case When Acceptance.NoRefundF in (8,10,14) then 0 else 1 end)
		*(Case When SysTab.VATSubsidiesF=1 or Profile.VATSubsidiesF=1 then 1 else 0 end)
		)
		,Accass.Currency)
		*Case When (Max(MParam.VAT)/100)<0 Then -(Max(MParam.VAT)/100) else 0 end
	When Max(coalesce((Admlink.Amount-Admlink.Amount_11-Admlink.Amount_12-(Admlink.Amount_8+Admlink.Amount_13+Admlink.Amount_17+Admlink.Amount_18)-Admlink.Amount_14),0))<>0 then 
		sum((Admlink.Amount_8)*AccAss.Amount)/Max(coalesce((Admlink.Amount-Admlink.Amount_11-Admlink.Amount_12-(Admlink.Amount_8+Admlink.Amount_13+Admlink.Amount_17+Admlink.Amount_18)-Admlink.Amount_14),0))
	Else 0 end
	as VATSubsidies,   
	Case 
	When Max(Admlink.AdmNo) is null then
		dbo.roundccy(
		sum(
		AccAss.Amount
		*(Case When SysTab.TaxMethod=0 or (Accass.Type in ('CP','DC','QS','QP','S1','S2','S3','AF','XP','FO','FP','IR','IX') and AccAss.Code='C') or (AccAss.Type in ('OP')) or (Accass.Type Not in ('CP','DC','QS','QP','S1','S2','S3','AF','XP','FO','FP','IR','IX') and AccAss.Code Not in ('F','D')) Then 1 else 0 end)
		*(Case When Profile.BVatF=1 or (AccAss.Type in ('DI','IC','CF','JP','BO')) Then 1 else 0 end)
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
		Case when Max(Admlink.Type) in ('DI','IC','CF','JP','BO') Then 	
			Case When Max(SysTab.TaxMethod)<>2 then
				dbo.roundccy(
				sum(
				AccAss.Amount
				*(Case When SysTab.TaxMethod=0 or (Accass.Type in ('CP','DC','QS','QP','S1','S2','S3','AF','XP','FO','FP','IR','IX') and AccAss.Code='C') or (AccAss.Type in ('OP')) or (Accass.Type Not in ('CP','DC','QS','QP','S1','S2','S3','AF','XP','FO','FP','IR','IX') and AccAss.Code Not in ('F','D')) Then 1 else 0 end)
				*(Case When Profile.TVatF=1 or (AccAss.Type in ('DI','IC','CF','JP','BO')) Then 1 else 0 end)
				*(Case When Acceptance.NoRefundF<>11 and Acceptance.NoRefundF<>14 and AccAss.Type in ('DI','IC','CF','JP','BO') and Insured.TVatF=1 then 1 else 0 end)
				)
				,Accass.Currency)
			else
				dbo.roundccy(
				sum(
				AccAss.Amount*coalesce(RateCov.Portion,0)/coalesce(pRCover.Portion, RCover.Portion)
				)
				,Accass.Currency)
			end
		else
			0
		end
		*Max((Case When coalesce(Acceptance.TVATPCT,0)=0 Then TOC.VAT else coalesce(Acceptance.TVATPCT,0) end)/100)
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
				Case When MParam.PASAL21<>0 Then (Case When Profile.AccruedTax<>0 Then Profile.AccruedTax else MParam.Pasal21*(100-MParam.TaxDiscount)/100 end) else 0 end/100
			When TaxType.MTaxType='PASAL23' Then
				Case When MParam.PASAL23<>0 Then (Case When Profile.AccruedTax<>0 Then Profile.AccruedTax else MParam.PASAL23 end) else 0 end/100 
			When TaxType.MTaxType='PASAL26' Then 
				Case When MParam.PASAL26<>0 Then (Case When Profile.AccruedTax<>0 Then Profile.AccruedTax else MParam.PASAL26 end) else 0 end/100
			When TaxType.MTaxType='PASAL4' Then 
				Case When MParam.PASAL4<>0 Then (Case When Profile.AccruedTax<>0 Then Profile.AccruedTax else MParam.PASAL4 end) else 0 end/100
			ELSE Profile.AccruedTax/100
		  END)
		*Case When coalesce(Profile.TaxPCT,0)=0 then 1 else Profile.TaxPCT/100 end
		*(Case When Acceptance.NoRefundF=7 and AccAss.Type in ('BB','BA','BO','BC','BP','BD') and AccAss.Code in ('C') then 0 else 1 end)
		*(Case When Acceptance.NoRefundF in (9,10) then 0 else 1 end)
		),AccAss.Currency)
	When Max(coalesce((Admlink.Amount-Admlink.Amount_11-Admlink.Amount_12-(Admlink.Amount_8+Admlink.Amount_13+Admlink.Amount_17+Admlink.Amount_18)-Admlink.Amount_14),0))<>0 then 
		sum((Admlink.Amount_14)*AccAss.Amount)/Max(coalesce((Admlink.Amount-Admlink.Amount_11-Admlink.Amount_12-(Admlink.Amount_8+Admlink.Amount_13+Admlink.Amount_17+Admlink.Amount_18)-Admlink.Amount_14),0))
	Else 0 end
	as TAX	    
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
	Left Join RCover on (RCover.ANO=Acceptance.ANO and RCover.Code=AccAss.RCode and RCover.SDate=AccAss.SDate)
	Left Join RCover pRCover on (AccAss.CAmount=0 and pRCover.ANO=Acceptance.pANO and pRCover.Code=AccAss.RCode and pRCover.SDate=AccAss.SDate)
	Outer apply (Select sum(RateCov.Portion) as Portion from RateCov Where RateCov.Code=AccAss.RCode and RateCov.VatF=1) as RateCov
	WHERE Acceptance.RegNo=@MRegNo
	GROUP BY AccAss.ID, Profile.Name, AccAss.Type, AccAss.Posted, AccAss.Admno, AccAss.Currency, Acceptance.RegNo, Accass.DocNo, AccAss.RefNo,      
	Case When AccAss.CAmount=0 and Coalesce(pAcceptance.Branch,'')<>'' Then pAcceptance.Branch Else Acceptance.Branch end,   
	dbo.fn_Get_UWYear(@MSDate, @MEDate, Case When (Case When isnull(APayor.ANO,0)=0 Then (Case When isnull(MPayor.ANO,0)=0 Then Payor.PolicyYearF else MPayor.PolicyYearF end) else APayor.PolicyYearF end)=1 Then AccAss.SDate else Acceptance.SDate end),
	(Case When isnull(APayor.ANO,0)=0 Then (Case When isnull(MPayor.ANO,0)=0 Then Payor.Grace else MPayor.Grace end) else APayor.Grace end)
END



go



 insert into PatchVersioning
select '306 Update Script - Patch 2022 (45)',GETDATE()
go


Declare @PrevScript varchar(100)
Declare @CurrScript varchar(100)

Select @PrevScript=''
Select @CurrSCript='306 Update Script - Patch 2022 (45)'


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


