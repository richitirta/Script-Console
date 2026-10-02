DROP FUNCTION fn_GetPNominalVat_ByRisk

GO
CREATE FUNCTION fn_GetPNominalVat_ByRisk(@P_AdmNo as int)
RETURNS Float
AS               
BEGIN              
Declare @P_PNominal_VAT as Float

Select @P_PNominal_VAT=sum(dbo.roundCCY(AccAss.Amount, AccAss.Currency)*RateCov.Portion/coalesce(pRCover.Portion, RCover.Portion))
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

DROP Procedure QProduction_To_Adm
GO
CREATE Procedure QProduction_To_Adm(@P_ANO as int)                              
as                              
Select A1.ID, A1.TOC, A1.Type, A1.Currency, A1.Date, A1.BillDate, A1.DocNo as DocNo, A1.RefNo,  
Case When SysTab.SplitPremiumAndClaimF=1 and A1.Code in ('A','R') Then 'Claim' else 'Premium' end as Subject,       
Max(Case When coalesce(AL.RefNo,'')=A2.RefNo and C.ISType<>'T' Then coalesce(AL.AName,Case When A2.AName<>'' then A2.AName else A2.Remarks end) else Case When A2.AName<>'' then A2.AName else A2.Remarks end end) as Remarks,                                 
Case When (coalesce(APayor.ScheduleF,coalesce(Payor.ScheduleF,0))=1) or (Case When isnull(APayor.ANO,0)=0 Then (Case When isnull(MPayor.ANO,0)=0 Then Payor.PolicyYearF else MPayor.PolicyYearF end) else APayor.PolicyYearF end)=1 Then A1.SDate else A2.SDate end as SDate,                              
Case When (coalesce(APayor.ScheduleF,coalesce(Payor.ScheduleF,0))=1) or (Case When isnull(APayor.ANO,0)=0 Then (Case When isnull(MPayor.ANO,0)=0 Then Payor.PolicyYearF else MPayor.PolicyYearF end) else APayor.PolicyYearF end)=1 Then A1.EDate else A2.EDate end as EDate,               
Max(A2.Source) as Source,                              
Cast(Max(Case When A2.SplitDNCNF=1 and A1.CAmount=0 and Coalesce(A3.ANO,0)<>0 Then 1 Else 0 end) as Bit) as DataReversalF, 
Case When A1.CAmount=0 and Coalesce(A3.Branch,'')<>'' Then A3.Branch Else A2.Branch end as Branch,      
cast(Max(cast(A1.CommPoolF as Integer)) as Bit) as CommPoolF,   
cast(Max(cast(MParam.WriteF as Integer)) as Bit) as WriteF,   
Min(A1.SDate) as MINSDate, Max(A1.SDate) as MAXSDate,                
Min(A1.ACNO)  as MinACNO, Min(A1.ACNO) as MaxACNO,                      
Max(coalesce(RCover.Code, A1.RCode)) as RCode,                     
sum(Case When A1.Code='P' then dbo.roundccy(A1.Amount, A1.Currency) else 0 end) as Amount_1,                              
sum(Case When A1.Code='C' then dbo.roundccy(A1.Amount, A1.Currency) else 0 end) as Amount_2,                              
sum(Case When A1.Code='F' and coalesce(A1.CodeExt,'')='' then dbo.roundccy(A1.Amount, A1.Currency) else 0 end) as Amount_3,                              
sum(Case When A1.Code='D' and coalesce(A1.CodeExt,'')='' then dbo.roundccy(A1.Amount, A1.Currency) else 0 end) as Amount_4,                              
sum(Case When A1.Code='O' then dbo.roundccy(A1.Amount, A1.Currency) else 0 end) as Amount_5,                              
sum(Case When A1.Code='A' then dbo.roundccy(A1.Amount, A1.Currency) else 0 end) as Amount_6,                              
sum(Case When A1.Code='R' then dbo.roundccy(A1.Amount, A1.Currency) else 0 end) as Amount_10,                              
sum(Case When A1.Code in ('D','F') and coalesce(A1.CodeExt,'')='3' then dbo.roundccy(A1.Amount, A1.Currency) else 0 end) as Amount_12,            
sum(Case When A1.Code='T' then dbo.roundccy(A1.Amount, A1.Currency) else 0 end) as Amount_14,                              
sum(Case When A1.Code in ('D','F') and coalesce(A1.CodeExt,'')='1' then dbo.roundccy(A1.Amount, A1.Currency) else 0 end) as Amount_15,            
sum(Case When A1.Code in ('D','F') and coalesce(A1.CodeExt,'')='2' then dbo.roundccy(A1.Amount, A1.Currency) else 0 end) as Amount_16,            
sum(Case When A1.Code='J' then dbo.roundccy(A1.Amount, A1.Currency) else 0 end) as Amount_19,    
sum(Case When A1.Code='U' then dbo.roundccy(A1.Amount, A1.Currency) else 0 end) as Amount_20                                                                            
from AccAss A1                              
Inner Join MParam on (MParam.Type=A1.Type)
Inner Join Acceptance A2 on (A2.ANO=A1.ANO)                              
Left join  Acceptance A3 on (A3.ANO=A2.pANO)    
Inner Join Cover C on (C.CNO=A2.CNO)                  
Left Join Acceptance AL on (AL.ANO=A2.LANO and C.OpenFlag=0)                  
Left Join APayor on (APayor.ANO=A2.ANO and A2.LANO<>-1 and A2.ANO<>A2.LANO)                              
Left Join Payor on (Payor.ANO=A2.ANO and A2.LANO=-1)                 
Left Join Payor MPayor on (MPayor.ANO=A2.LANO and A2.LANO<>-1)                
Left Join RCover on (RCover.ANO=A2.ANO and RCover.Code=A1.RCode and RCover.SDate=A1.SDate and RCover.Category='M')
Inner Join SysTab on (1=1)          
Where A1.ANO=@P_ANO                              
Group By A1.DocNo, A1.RefNo, A1.Type, A1.ID, A1.TOC, A1.Currency, A1.Date, A1.BillDate,             
Case When SysTab.SplitPremiumAndClaimF=1 and A1.Code in ('A','R') Then 'Claim' else 'Premium' end,
Case When (coalesce(APayor.ScheduleF,coalesce(Payor.ScheduleF,0))=1) or (Case When isnull(APayor.ANO,0)=0 Then (Case When isnull(MPayor.ANO,0)=0 Then Payor.PolicyYearF else MPayor.PolicyYearF end) else APayor.PolicyYearF end)=1 Then A1.SDate else A2.SDate end,                
Case When (coalesce(APayor.ScheduleF,coalesce(Payor.ScheduleF,0))=1) or (Case When isnull(APayor.ANO,0)=0 Then (Case When isnull(MPayor.ANO,0)=0 Then Payor.PolicyYearF else MPayor.PolicyYearF end) else APayor.PolicyYearF end)=1 Then A1.EDate else A2.EDate end,
Case When A1.CAmount=0 and Coalesce(A3.Branch,'')<>'' Then A3.Branch Else A2.Branch end 
Order By A1.DocNo, A1.RefNo, A1.Type, A1.ID, A1.TOC, A1.Currency, A1.Date, A1.BillDate
GO


DROP Procedure QUndo_Production_To_Adm
GO
CREATE Procedure QUndo_Production_To_Adm(@P_ANO as int)                      
as                      
Select A1.ADMNO,     
sum(Case When A1.Code='P' then dbo.roundccy(A1.Amount, A1.Currency) else 0 end) as Amount_1,                      
sum(Case When A1.Code='C' then dbo.roundccy(A1.Amount, A1.Currency) else 0 end) as Amount_2,                      
sum(Case When A1.Code='F' and coalesce(A1.CodeExt,'')='' then dbo.roundccy(A1.Amount, A1.Currency) else 0 end) as Amount_3,                      
sum(Case When A1.Code='D' and coalesce(A1.CodeExt,'')='' then dbo.roundccy(A1.Amount, A1.Currency) else 0 end) as Amount_4,                      
sum(Case When A1.Code='O' then dbo.roundccy(A1.Amount, A1.Currency) else 0 end) as Amount_5,                      
sum(Case When A1.Code='A' then dbo.roundccy(A1.Amount, A1.Currency) else 0 end) as Amount_6,                      
sum(Case When A1.Code='R' then dbo.roundccy(A1.Amount, A1.Currency) else 0 end) as Amount_10,                      
sum(Case When A1.Code in ('D','F') and coalesce(A1.CodeExt,'')='3' then dbo.roundccy(A1.Amount, A1.Currency) else 0 end) as Amount_12,     
sum(Case When A1.Code='T' then dbo.roundccy(A1.Amount, A1.Currency) else 0 end) as Amount_14,                      
sum(Case When A1.Code in ('D','F') and coalesce(A1.CodeExt,'')='1' then dbo.roundccy(A1.Amount, A1.Currency) else 0 end) as Amount_15,     
sum(Case When A1.Code in ('D','F') and coalesce(A1.CodeExt,'')='2' then dbo.roundccy(A1.Amount, A1.Currency) else 0 end) as Amount_16,     
sum(Case When A1.Code='J' then dbo.roundccy(A1.Amount, A1.Currency) else 0 end) as Amount_19,                      
sum(Case When A1.Code='U' then dbo.roundccy(A1.Amount, A1.Currency) else 0 end) as Amount_20                      
from AccAss A1                     
Inner Join Admlink A2 on (A2.ADMNO=A1.AdmNo)                      
Where A1.ANO=@P_ANO                      
Group By A1.AdmNo    
                
GO



DROP PROCEDURE View07 
GO
CREATE PROCEDURE View07 (@p_ANo as integer)                
AS                
SELECT AccAss.ID, Profile.Name, AccAss.Type, AccAss.Posted, AccAss.Admno, AccAss.Currency, Acceptance.RegNo, Accass.DocNo, AccAss.RefNo,      
Case When AccAss.CAmount=0 and Coalesce(pAcceptance.Branch,'')<>'' Then pAcceptance.Branch Else Acceptance.Branch end Branch,   dbo.fn_Get_UWYear(Acceptance.SDate, Acceptance.EDate, Case When (Case When isnull(APayor.ANO,0)=0 Then (Case When isnull(MPayor.ANO,0)=0 Then Payor.PolicyYearF else MPayor.PolicyYearF end) else APayor.PolicyYearF end)=1 Then AccAss.SDate else Acceptance.SDate end) as PolicyYear,
sum(                
 case                
  when (accass.type in ('IR','IT','IX') and accass.code in ('P','U','F')) or (accass.type in ('DI','IC') and accass.code in ('P','U')) or (AccAss.Type not in ('DI','IC','IR','IT','IX') and AccAss.Code='P') then dbo.roundCCY(AccAss.Amount, AccAss.Currency)
  else 0                
 end                
) 
+
sum(
 Case 
  When Acceptance.NoRefundF=7 and AccAss.Type in ('BB','BA','BO','BC','BP','BD') and AccAss.Code in ('C') then dbo.roundCCY(AccAss.Amount, AccAss.Currency) 
  else 0 
 end
)
AS Premium,                 
sum(                
 case                 
  when accass.code='C' and coalesce(accass.codeext,'') in ('','V') then dbo.roundCCY(AccAss.Amount, AccAss.Currency)                
  else 0                
 end                
) 
-
sum(
 Case 
  When Acceptance.NoRefundF=7 and AccAss.Type in ('BB','BA','BO','BC','BP','BD') and AccAss.Code in ('C') then dbo.roundCCY(AccAss.Amount, AccAss.Currency) 
  else 0 
 end
)
AS Commision,                 
sum(                
 case                 
  when accass.code='C' and coalesce(accass.codeext,'')='1' then dbo.roundCCY(AccAss.Amount, AccAss.Currency)                
  else 0                
 end                
) AS OverridingCommission,                 
sum(                
 case                 
  when accass.Type not in ('IR','IT','IX') and accass.code='F' then dbo.roundCCY(AccAss.Amount, AccAss.Currency)                
  else 0                
 end                
) AS Fee,                 
sum(                
 case                 
  when accass.code='D' then dbo.roundCCY(AccAss.Amount, AccAss.Currency)                
  else 0                
 end                
) AS Duty,                 
sum(                
 case                 
  when accass.type not in ('CP','DC','XP','QS','QP','S1','S2','S3','AF','FO','FP') and accass.code='O' then dbo.roundCCY(AccAss.Amount, AccAss.Currency)                
  else 0                
 end                
) AS Discount,                 
sum(                
 case                 
  when accass.type in ('CP','DC','XP','QS','QP','S1','S2','S3','AF','FO','FP') and accass.code='O' and coalesce(accass.CodeExt,'')='' then dbo.roundCCY(AccAss.Amount, AccAss.Currency)                
  else 0                
 end                
) AS Acquisition,   
sum(                
 case                 
  when accass.type in ('CP','DC','XP','QS','QP','S1','S2','S3','AF','FO','FP') and accass.code='O' and coalesce(accass.CodeExt,'')='1' then dbo.roundCCY(AccAss.Amount, AccAss.Currency)                
  else 0                
 end                
) AS PremiumAdjustment,                               
sum(                
 case                
  when accass.code='I' then dbo.roundCCY(AccAss.Amount, AccAss.Currency)                
  else 0                
 end                
) AS OtherIncome,               
sum(                
 case                
  when accass.type in ('IR','IT','IX') and accass.code='F' then -dbo.roundCCY(AccAss.Amount, AccAss.Currency)
  when accass.Type in ('DI','IC') and accass.code='U' then -dbo.roundCCY(AccAss.Amount, AccAss.Currency)        
  when accass.Type Not in ('DI','IC') and accass.code='U' then dbo.roundCCY(AccAss.Amount, AccAss.Currency)        
  else 0                
 End                
) AS Ujroh,              
sum(                
 case                
  when (accass.type in ('IR','IT','IX') and accass.code in ('P','U'))  or (accass.type in ('DI','IC') and accass.code in ('P')) or (AccAss.Type not in ('DI','IC','IR','IT','IX') and AccAss.Code in ('P','U')) then dbo.roundCCY(AccAss.Amount, AccAss.Currency)                
  else 0                
 end                
) AS Tabarru,         
sum(                
 case                
  when accass.type not in ('CP','DC','XP','QS','QP','S1','S2','S3','AF','FO','FP') and accass.code='J' then dbo.roundCCY(AccAss.Amount, AccAss.Currency)                
  else 0                
 end                
) AS Deposit,         
sum(                
 case                 
  when accass.type in ('CP','DC','XP','QS','QP','S1','S2','S3','AF','FO','FP') and accass.code='J' then dbo.roundCCY(AccAss.Amount, AccAss.Currency)                
  else 0                
 end                
) AS Advance,                  
dbo.roundccy(sum(dbo.roundCCY(AccAss.Amount, AccAss.Currency)),AccAss.Currency) - sum(dbo.roundCCY(AccAss.Amount, AccAss.Currency))as Rounding,        
Case 
When Max(Admlink.AdmNo) is null then
	dbo.roundccy(
	sum(
	dbo.roundCCY(AccAss.Amount, AccAss.Currency)
	*(Case When (AccAss.Type in ('BB','BA','BC','BP','BD','OP') and Profile.VATF=1) or (AccAss.Type not in ('BB','BA','BC','BP','BD','OP','DI','IC','CF','JP','BO') and Profile.VATF=1 and TOC.VATBusinessF=1) or (AccAss.Type in ('DI','IC','CF','JP','BO') and Insured.VATF=1 and TOC.VATBusinessF=1) Then 1 Else 0 End)
	*(Case When SysTab.TaxMethod=0 or (Accass.Type in ('CP','DC','QS','QP','S1','S2','S3','AF','XP','FO','FP','IR','IX') and AccAss.Code='C') or (AccAss.Type in ('OP')) or (Accass.Type Not in ('CP','DC','QS','QP','S1','S2','S3','AF','XP','FO','FP','IR','IX') and AccAss.Code Not in ('F','D')) Then 1 else 0 end)
	*(Case When Acceptance.NoRefundF=7 and AccAss.Type in ('BB','BA','BO','BC','BP','BD') and AccAss.Code in ('C') then 0 else 1 end)
	*(Case When Acceptance.NoRefundF in (8,10,14) then 0 else 1 end)
	)
	,Accass.Currency)
	*(Max(MParam.VAT)/100)
When Max(coalesce((Admlink.Amount-Admlink.Amount_11-Admlink.Amount_12-(Admlink.Amount_8+Admlink.Amount_13+Admlink.Amount_17+Admlink.Amount_18)-Admlink.Amount_14),0))<>0 then 
	sum((Admlink.Amount_13)*dbo.roundCCY(AccAss.Amount, AccAss.Currency))/Max(coalesce((Admlink.Amount-Admlink.Amount_11-Admlink.Amount_12-(Admlink.Amount_8+Admlink.Amount_13+Admlink.Amount_17+Admlink.Amount_18)-Admlink.Amount_14),0))
Else 0 end
as VAT,       
Case 
When Max(Admlink.AdmNo) is null then
	dbo.roundccy(
	sum(
	dbo.roundCCY(AccAss.Amount, AccAss.Currency)
	*(Case When (AccAss.Type in ('BB','BA','BC','BP','BD','OP') and Profile.VATF=1) or (AccAss.Type not in ('BB','BA','BC','BP','BD','OP','DI','IC','CF','JP','BO') and Profile.VATF=1 and TOC.VATBusinessF=1) or (AccAss.Type in ('DI','IC','CF','JP','BO') and Insured.VATF=1 and TOC.VATBusinessF=1) Then 1 Else 0 End)
	*(Case When SysTab.TaxMethod=0 or (Accass.Type in ('CP','DC','QS','QP','S1','S2','S3','AF','XP','FO','FP','IR','IX') and AccAss.Code='C') or (AccAss.Type in ('OP')) or (Accass.Type Not in ('CP','DC','QS','QP','S1','S2','S3','AF','XP','FO','FP','IR','IX') and AccAss.Code Not in ('F','D')) Then 1 else 0 end)
	*(Case When Acceptance.NoRefundF=7 and AccAss.Type in ('BB','BA','BO','BC','BP','BD') and AccAss.Code in ('C') then 0 else 1 end)
	*(Case When Acceptance.NoRefundF in (8,10,14) then 0 else 1 end)
	*(Case When SysTab.VATSubsidiesF=1 or Profile.VATSubsidiesF=1 then 1 else 0 end)
	)
	,Accass.Currency)
	*Case When (Max(MParam.VAT)/100)<0 Then -(Max(MParam.VAT)/100) else 0 end
When Max(coalesce((Admlink.Amount-Admlink.Amount_11-Admlink.Amount_12-(Admlink.Amount_8+Admlink.Amount_13+Admlink.Amount_17+Admlink.Amount_18)-Admlink.Amount_14),0))<>0 then 
	sum((Admlink.Amount_8)*dbo.roundCCY(AccAss.Amount, AccAss.Currency))/Max(coalesce((Admlink.Amount-Admlink.Amount_11-Admlink.Amount_12-(Admlink.Amount_8+Admlink.Amount_13+Admlink.Amount_17+Admlink.Amount_18)-Admlink.Amount_14),0))
Else 0 end
as VATSubsidies,       
Case 
When Max(Admlink.AdmNo) is null then
	dbo.roundccy(
	sum(
	dbo.roundCCY(AccAss.Amount, AccAss.Currency)
	*(Case When SysTab.TaxMethod=0 or (Accass.Type in ('CP','DC','QS','QP','S1','S2','S3','AF','XP','FO','FP','IR','IX') and AccAss.Code='C') or (AccAss.Type in ('OP')) or (Accass.Type Not in ('CP','DC','QS','QP','S1','S2','S3','AF','XP','FO','FP','IR','IX') and AccAss.Code Not in ('F','D')) Then 1 else 0 end)
	*(Case When Profile.BVatF=1 or (AccAss.Type in ('DI','IC','CF','JP','BO')) Then 1 else 0 end)
	*(Case When Acceptance.NoRefundF<>11 and Acceptance.NoRefundF<>14 and AccAss.Type in ('DI','IC','CF','JP','BO') and Insured.BVatF=1 then 1 else 0 end)
	)
	,Accass.Currency)
	*Max((Case When coalesce(Acceptance.OverwriteBVatF,0)=0 Then Branch.VAT else coalesce(Acceptance.BVATPCT,0) end)/100)
When Max(coalesce((Admlink.Amount-Admlink.Amount_11-Admlink.Amount_12-(Admlink.Amount_8+Admlink.Amount_13+Admlink.Amount_17+Admlink.Amount_18)-Admlink.Amount_14),0))<>0 then 
	sum((Admlink.Amount_17)*dbo.roundCCY(AccAss.Amount, AccAss.Currency))/Max(coalesce((Admlink.Amount-Admlink.Amount_11-Admlink.Amount_12-(Admlink.Amount_8+Admlink.Amount_13+Admlink.Amount_17+Admlink.Amount_18)-Admlink.Amount_14),0))
Else 0 end
as VAT_1,      
Case 
When Max(Admlink.AdmNo) is null then
	Case when Max(AccAss.Type) in ('DI','IC','CF','JP','BO') Then 	
		Case When Max(SysTab.TaxMethod)<>2 then
			dbo.roundccy(
			sum(
			dbo.roundCCY(AccAss.Amount, AccAss.Currency)
			*(Case When SysTab.TaxMethod=0 or (Accass.Type in ('CP','DC','QS','QP','S1','S2','S3','AF','XP','FO','FP','IR','IX') and AccAss.Code='C') or (AccAss.Type in ('OP')) or (Accass.Type Not in ('CP','DC','QS','QP','S1','S2','S3','AF','XP','FO','FP','IR','IX') and AccAss.Code Not in ('F','D')) Then 1 else 0 end)
			*(Case When Profile.TVatF=1 or (AccAss.Type in ('DI','IC','CF','JP','BO')) Then 1 else 0 end)
			*(Case When Acceptance.NoRefundF<>11 and Acceptance.NoRefundF<>14 and AccAss.Type in ('DI','IC','CF','JP','BO') and Insured.TVatF=1 then 1 else 0 end)
			)
			,Accass.Currency)
		else
			dbo.roundccy(
			sum(
			dbo.roundCCY(AccAss.Amount, AccAss.Currency)*coalesce(RateCov.Portion,0)/coalesce(pRCover.Portion, RCover.Portion)
			*Case When (AccAss.Type in ('DI','IC') and Accass.Code in ('P','O','U')) or (AccAss.Type in ('CF','JP') and AccAss.Code in ('P','O')) or (AccAss.Type in ('BO')) Then 1 else 0 end			
			)
			,Accass.Currency)
		end
	else
		0
	end
	*Max((Case When coalesce(Acceptance.OverwriteTVatF,0)=0 Then TOC.VAT else coalesce(Acceptance.TVATPCT,0) end)/100)
When Max(coalesce((Admlink.Amount-Admlink.Amount_11-Admlink.Amount_12-(Admlink.Amount_8+Admlink.Amount_13+Admlink.Amount_17+Admlink.Amount_18)-Admlink.Amount_14),0))<>0 then 
	sum((Admlink.Amount_18)*dbo.roundCCY(AccAss.Amount, AccAss.Currency))/Max(coalesce((Admlink.Amount-Admlink.Amount_11-Admlink.Amount_12-(Admlink.Amount_8+Admlink.Amount_13+Admlink.Amount_17+Admlink.Amount_18)-Admlink.Amount_14),0))
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
		*dbo.roundCCY(AccAss.Amount, AccAss.Currency)
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
	sum((Admlink.Amount_14)*dbo.roundCCY(AccAss.Amount, AccAss.Currency))/Max(coalesce((Admlink.Amount-Admlink.Amount_11-Admlink.Amount_12-(Admlink.Amount_8+Admlink.Amount_13+Admlink.Amount_17+Admlink.Amount_18)-Admlink.Amount_14),0))
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
	  when (accass.type in ('IR','IT','IX') and accass.code in ('P','U','F')) or (accass.type in ('DI','IC') and accass.code in ('P','U')) or (AccAss.Type not in ('DI','IC','IR','IT','IX') and AccAss.Code='P') then dbo.roundCCY(AccAss.Amount, AccAss.Currency)                
	  else 0                
	 end                
	) 
	+
	sum(
	 Case 
	  When Acceptance.NoRefundF=7 and AccAss.Type in ('BB','BA','BO','BC','BP','BD') and AccAss.Code in ('C') then dbo.roundCCY(AccAss.Amount, AccAss.Currency) 
	  else 0 
	 end
	)	
	AS Premium,                 
	sum(                
	 case                 
	  when accass.code='C' and coalesce(accass.codeext,'') in ('','V') then dbo.roundCCY(AccAss.Amount, AccAss.Currency)                
	  else 0                
	 end                
	) 
	-
	sum(
	 Case 
	  When Acceptance.NoRefundF=7 and AccAss.Type in ('BB','BA','BO','BC','BP','BD') and AccAss.Code in ('C') then dbo.roundCCY(AccAss.Amount, AccAss.Currency) 
	  else 0 
	 end
	)
	AS Commision,                 
	sum(                
	 case                 
	  when accass.code='C' and coalesce(accass.codeext,'')='1' then dbo.roundCCY(AccAss.Amount, AccAss.Currency)                
	  else 0                
	 end                
	) AS OverridingCommission,                 
	sum(                
	 case                 
	  when accass.Type not in ('IR','IT','IX') and accass.code='F' then dbo.roundCCY(AccAss.Amount, AccAss.Currency)                
	  else 0                
	 end                
	) AS Fee,                 
	sum(                
	 case                 
	  when accass.code='D' then dbo.roundCCY(AccAss.Amount, AccAss.Currency)                
	  else 0                
	 end                
	) AS Duty,                 
	sum(                
	 case                 
	  when accass.type not in ('CP','DC','XP','QS','QP','S1','S2','S3','AF','FO','FP') and accass.code='O' then dbo.roundCCY(AccAss.Amount, AccAss.Currency)                
	  else 0                
	 end                
	) AS Discount,                 
	sum(                
	 case                 
	  when accass.type in ('CP','DC','XP','QS','QP','S1','S2','S3','AF','FO','FP') and accass.code='O' and coalesce(accass.CodeExt,'')='' then dbo.roundCCY(AccAss.Amount, AccAss.Currency)                
	  else 0                
	 end                
	) AS Acquisition,   
	sum(                
	 case                 
	  when accass.type in ('CP','DC','XP','QS','QP','S1','S2','S3','AF','FO','FP') and accass.code='O' and coalesce(accass.CodeExt,'')='1' then dbo.roundCCY(AccAss.Amount, AccAss.Currency)                
	  else 0                
	 end                
	) AS PremiumAdjustment,                               
	sum(                
	 case                
	  when accass.code='I' then dbo.roundCCY(AccAss.Amount, AccAss.Currency)                
	  else 0                
	 end                
	) AS OtherIncome,               
	sum(                
	 case                
	  when accass.type in ('IR','IT','IX') and accass.code='F' then -dbo.roundCCY(AccAss.Amount, AccAss.Currency)
	  when accass.Type in ('DI','IC') and accass.code='U' then -dbo.roundCCY(AccAss.Amount, AccAss.Currency)        
	  when accass.Type Not in ('DI','IC') and accass.code='U' then dbo.roundCCY(AccAss.Amount, AccAss.Currency)        
	  else 0                
	 End                
	) AS Ujroh,      
	sum(                
	 case                
	  when (accass.type in ('IR','IT','IX') and accass.code in ('P','U'))  or (accass.type in ('DI','IC') and accass.code in ('P')) or (AccAss.Type not in ('DI','IC','IR','IT','IX') and AccAss.Code in ('P','U')) then dbo.roundCCY(AccAss.Amount, AccAss.Currency)                
	  else 0                
	 end                
	) AS Tabarru,         
	sum(                
	 case                
	  when accass.type not in ('CP','DC','XP','QS','QP','S1','S2','S3','AF','FO','FP') and accass.code='J' then dbo.roundCCY(AccAss.Amount, AccAss.Currency)                
	  else 0                
	 end                
	) AS Deposit,         
	sum(                
	 case                 
	  when accass.type in ('CP','DC','XP','QS','QP','S1','S2','S3','AF','FO','FP') and accass.code='J' then dbo.roundCCY(AccAss.Amount, AccAss.Currency)                
	  else 0                
	 end                
	) AS Advance,                  
	dbo.roundccy(sum(dbo.roundCCY(AccAss.Amount, AccAss.Currency)),AccAss.Currency) - sum(dbo.roundCCY(AccAss.Amount, AccAss.Currency))as Rounding, 
	Case 
	When Max(Admlink.AdmNo) is null then
		dbo.roundccy(
		sum(
		dbo.roundCCY(AccAss.Amount, AccAss.Currency)
		*(Case When (AccAss.Type in ('BB','BA','BC','BP','BD','OP') and Profile.VATF=1) or (AccAss.Type not in ('BB','BA','BC','BP','BD','OP','DI','IC','CF','JP','BO') and Profile.VATF=1 and TOC.VATBusinessF=1) or (AccAss.Type in ('DI','IC','CF','JP','BO') and Insured.VATF=1 and TOC.VATBusinessF=1) Then 1 Else 0 End)
		*(Case When SysTab.TaxMethod=0 or (Accass.Type in ('CP','DC','QS','QP','S1','S2','S3','AF','XP','FO','FP','IR','IX') and AccAss.Code='C') or (AccAss.Type in ('OP')) or (Accass.Type Not in ('CP','DC','QS','QP','S1','S2','S3','AF','XP','FO','FP','IR','IX') and AccAss.Code Not in ('F','D')) Then 1 else 0 end)
		*(Case When Acceptance.NoRefundF=7 and AccAss.Type in ('BB','BA','BO','BC','BP','BD') and AccAss.Code in ('C') then 0 else 1 end)
		*(Case When Acceptance.NoRefundF in (8,10,14) then 0 else 1 end)
		)
		,Accass.Currency)
		*(Max(MParam.VAT)/100)
	When Max(coalesce((Admlink.Amount-Admlink.Amount_11-Admlink.Amount_12-(Admlink.Amount_8+Admlink.Amount_13+Admlink.Amount_17+Admlink.Amount_18)-Admlink.Amount_14),0))<>0 then 
		sum((Admlink.Amount_13)*dbo.roundCCY(AccAss.Amount, AccAss.Currency))/Max(coalesce((Admlink.Amount-Admlink.Amount_11-Admlink.Amount_12-(Admlink.Amount_8+Admlink.Amount_13+Admlink.Amount_17+Admlink.Amount_18)-Admlink.Amount_14),0))
	Else 0 end
	as VAT,        
	Case 
	When Max(Admlink.AdmNo) is null then
		dbo.roundccy(
		sum(
		dbo.roundCCY(AccAss.Amount, AccAss.Currency)
		*(Case When (AccAss.Type in ('BB','BA','BC','BP','BD','OP') and Profile.VATF=1) or (AccAss.Type not in ('BB','BA','BC','BP','BD','OP','DI','IC','CF','JP','BO') and Profile.VATF=1 and TOC.VATBusinessF=1) or (AccAss.Type in ('DI','IC','CF','JP','BO') and Insured.VATF=1 and TOC.VATBusinessF=1) Then 1 Else 0 End)
		*(Case When SysTab.TaxMethod=0 or (Accass.Type in ('CP','DC','QS','QP','S1','S2','S3','AF','XP','FO','FP','IR','IX') and AccAss.Code='C') or (AccAss.Type in ('OP')) or (Accass.Type Not in ('CP','DC','QS','QP','S1','S2','S3','AF','XP','FO','FP','IR','IX') and AccAss.Code Not in ('F','D')) Then 1 else 0 end)
		*(Case When Acceptance.NoRefundF=7 and AccAss.Type in ('BB','BA','BO','BC','BP','BD') and AccAss.Code in ('C') then 0 else 1 end)
		*(Case When Acceptance.NoRefundF in (8,10,14) then 0 else 1 end)
		*(Case When SysTab.VATSubsidiesF=1 or Profile.VATSubsidiesF=1 then 1 else 0 end)
		)
		,Accass.Currency)
		*Case When (Max(MParam.VAT)/100)<0 Then -(Max(MParam.VAT)/100) else 0 end
	When Max(coalesce((Admlink.Amount-Admlink.Amount_11-Admlink.Amount_12-(Admlink.Amount_8+Admlink.Amount_13+Admlink.Amount_17+Admlink.Amount_18)-Admlink.Amount_14),0))<>0 then 
		sum((Admlink.Amount_8)*dbo.roundCCY(AccAss.Amount, AccAss.Currency))/Max(coalesce((Admlink.Amount-Admlink.Amount_11-Admlink.Amount_12-(Admlink.Amount_8+Admlink.Amount_13+Admlink.Amount_17+Admlink.Amount_18)-Admlink.Amount_14),0))
	Else 0 end
	as VATSubsidies,       
	Case 
	When Max(Admlink.AdmNo) is null then
		dbo.roundccy(
		sum(
		dbo.roundCCY(AccAss.Amount, AccAss.Currency)
		*(Case When SysTab.TaxMethod=0 or (Accass.Type in ('CP','DC','QS','QP','S1','S2','S3','AF','XP','FO','FP','IR','IX') and AccAss.Code='C') or (AccAss.Type in ('OP')) or (Accass.Type Not in ('CP','DC','QS','QP','S1','S2','S3','AF','XP','FO','FP','IR','IX') and AccAss.Code Not in ('F','D')) Then 1 else 0 end)
		*(Case When Profile.BVatF=1 or (AccAss.Type in ('DI','IC','CF','JP','BO')) Then 1 else 0 end)
		*(Case When Acceptance.NoRefundF<>11 and Acceptance.NoRefundF<>14 and AccAss.Type in ('DI','IC','CF','JP','BO') and Insured.BVatF=1 then 1 else 0 end)
		)
		,Accass.Currency)
		*Max((Case When coalesce(Acceptance.OverwriteBVatF,0)=0 Then Branch.VAT else coalesce(Acceptance.BVATPCT,0) end)/100)
	When Max(coalesce((Admlink.Amount-Admlink.Amount_11-Admlink.Amount_12-(Admlink.Amount_8+Admlink.Amount_13+Admlink.Amount_17+Admlink.Amount_18)-Admlink.Amount_14),0))<>0 then 
		sum((Admlink.Amount_17)*dbo.roundCCY(AccAss.Amount, AccAss.Currency))/Max(coalesce((Admlink.Amount-Admlink.Amount_11-Admlink.Amount_12-(Admlink.Amount_8+Admlink.Amount_13+Admlink.Amount_17+Admlink.Amount_18)-Admlink.Amount_14),0))
	Else 0 end
	as VAT_1,      
	Case 
	When Max(Admlink.AdmNo) is null then
		Case when Max(AccAss.Type) in ('DI','IC','CF','JP','BO') Then 	
			Case When Max(SysTab.TaxMethod)<>2 then
				dbo.roundccy(
				sum(
				dbo.roundCCY(AccAss.Amount, AccAss.Currency)
				*(Case When SysTab.TaxMethod=0 or (Accass.Type in ('CP','DC','QS','QP','S1','S2','S3','AF','XP','FO','FP','IR','IX') and AccAss.Code='C') or (AccAss.Type in ('OP')) or (Accass.Type Not in ('CP','DC','QS','QP','S1','S2','S3','AF','XP','FO','FP','IR','IX') and AccAss.Code Not in ('F','D')) Then 1 else 0 end)
				*(Case When Profile.TVatF=1 or (AccAss.Type in ('DI','IC','CF','JP','BO')) Then 1 else 0 end)
				*(Case When Acceptance.NoRefundF<>11 and Acceptance.NoRefundF<>14 and AccAss.Type in ('DI','IC','CF','JP','BO') and Insured.TVatF=1 then 1 else 0 end)
				)
				,Accass.Currency)
			else
				dbo.roundccy(
				sum(
				dbo.roundCCY(AccAss.Amount, AccAss.Currency)*coalesce(RateCov.Portion,0)/coalesce(pRCover.Portion, RCover.Portion)
				*Case When (AccAss.Type in ('DI','IC') and Accass.Code in ('P','O','U')) or (AccAss.Type in ('CF','JP') and AccAss.Code in ('P','O')) or (AccAss.Type in ('BO')) Then 1 else 0 end			
				)
				,Accass.Currency)
			end
		else
			0
		end
		*Max((Case When coalesce(Acceptance.OverwriteTVatF,0)=0 Then TOC.VAT else coalesce(Acceptance.TVATPCT,0) end)/100)
	When Max(coalesce((Admlink.Amount-Admlink.Amount_11-Admlink.Amount_12-(Admlink.Amount_8+Admlink.Amount_13+Admlink.Amount_17+Admlink.Amount_18)-Admlink.Amount_14),0))<>0 then 
		sum((Admlink.Amount_18)*dbo.roundCCY(AccAss.Amount, AccAss.Currency))/Max(coalesce((Admlink.Amount-Admlink.Amount_11-Admlink.Amount_12-(Admlink.Amount_8+Admlink.Amount_13+Admlink.Amount_17+Admlink.Amount_18)-Admlink.Amount_14),0))
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
			*dbo.roundCCY(AccAss.Amount, AccAss.Currency)
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
		sum((Admlink.Amount_14)*dbo.roundCCY(AccAss.Amount, AccAss.Currency))/Max(coalesce((Admlink.Amount-Admlink.Amount_11-Admlink.Amount_12-(Admlink.Amount_8+Admlink.Amount_13+Admlink.Amount_17+Admlink.Amount_18)-Admlink.Amount_14),0))
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
	  when (accass.type in ('IR','IT','IX') and accass.code in ('P','U','F')) or (accass.type in ('DI','IC') and accass.code in ('P','U')) or (AccAss.Type not in ('DI','IC','IR','IT','IX') and AccAss.Code='P') then dbo.roundCCY(AccAss.Amount, AccAss.Currency)                
	  else 0                
	 end                
	) 
	+
	sum(
	 Case 
	  When Acceptance.NoRefundF=7 and AccAss.Type in ('BB','BA','BO','BC','BP','BD') and AccAss.Code in ('C') then dbo.roundCCY(AccAss.Amount, AccAss.Currency) 
	  else 0 
	 end
	)	
	AS Premium,                 
	sum(                
	 case                 
	  when accass.code='C' and coalesce(accass.codeext,'') in ('','V') then dbo.roundCCY(AccAss.Amount, AccAss.Currency)                
	  else 0                
	 end                
	) 
	-
	sum(
	 Case 
	  When Acceptance.NoRefundF=7 and AccAss.Type in ('BB','BA','BO','BC','BP','BD') and AccAss.Code in ('C') then dbo.roundCCY(AccAss.Amount, AccAss.Currency) 
	  else 0 
	 end
	)	
	AS Commision,                 
	sum(                
	 case                 
	  when accass.code='C' and coalesce(accass.codeext,'')='1' then dbo.roundCCY(AccAss.Amount, AccAss.Currency)                
	  else 0                
	 end                
	) AS OverridingCommission,                 
	sum(                
	 case                 
	  when accass.Type not in ('IR','IT','IX') and accass.code='F' then dbo.roundCCY(AccAss.Amount, AccAss.Currency)                
	  else 0                
	 end                
	) AS Fee,            
	sum(                
	 case                 
	  when accass.code='D' then dbo.roundCCY(AccAss.Amount, AccAss.Currency)                
	  else 0                
	 end                
	) AS Duty,                 
	sum(                
	 case                 
	  when accass.type not in ('CP','DC','XP','QS','QP','S1','S2','S3','AF','FO','FP') and accass.code='O' then dbo.roundCCY(AccAss.Amount, AccAss.Currency)                
	  else 0                
	 end                
	) AS Discount,                 
	sum(                
	 case                 
	  when accass.type in ('CP','DC','XP','QS','QP','S1','S2','S3','AF','FO','FP') and accass.code='O' and coalesce(accass.CodeExt,'')='' then dbo.roundCCY(AccAss.Amount, AccAss.Currency)                
	  else 0                
	 end                
	) AS Acquisition,   
	sum(                
	 case                 
	  when accass.type in ('CP','DC','XP','QS','QP','S1','S2','S3','AF','FO','FP') and accass.code='O' and coalesce(accass.CodeExt,'')='1' then dbo.roundCCY(AccAss.Amount, AccAss.Currency)                
	  else 0                
	 end                
	) AS PremiumAdjustment,                               
	sum(                
	 case                
	  when accass.code='I' then dbo.roundCCY(AccAss.Amount, AccAss.Currency)                
	  else 0                
	 end                
	) AS OtherIncome,               
	sum(                
	 case                
	  when accass.type in ('IR','IT','IX') and accass.code='F' then -dbo.roundCCY(AccAss.Amount, AccAss.Currency)
	  when accass.Type in ('DI','IC') and accass.code='U' then -dbo.roundCCY(AccAss.Amount, AccAss.Currency)        
	  when accass.Type Not in ('DI','IC') and accass.code='U' then dbo.roundCCY(AccAss.Amount, AccAss.Currency)        
	  else 0                
	 End    
	) AS Ujroh,              
	sum(                
	 case                
	  when (accass.type in ('IR','IT','IX') and accass.code in ('P','U'))  or (accass.type in ('DI','IC') and accass.code in ('P')) or (AccAss.Type not in ('DI','IC','IR','IT','IX') and AccAss.Code in ('P','U')) then dbo.roundCCY(AccAss.Amount, AccAss.Currency)                
	  else 0                
	 end                
	) AS Tabarru,         
	sum(                
	 case                
	  when accass.type not in ('CP','DC','XP','QS','QP','S1','S2','S3','AF','FO','FP') and accass.code='J' then dbo.roundCCY(AccAss.Amount, AccAss.Currency)                
	  else 0                
	 end                
	) AS Deposit,         
	sum(                
	 case                 
	  when accass.type in ('CP','DC','XP','QS','QP','S1','S2','S3','AF','FO','FP') and accass.code='J' then dbo.roundCCY(AccAss.Amount, AccAss.Currency)                
	  else 0                
	 end                
	) AS Advance,                  
	dbo.roundccy(sum(dbo.roundCCY(AccAss.Amount, AccAss.Currency)),AccAss.Currency) - sum(dbo.roundCCY(AccAss.Amount, AccAss.Currency))as Rounding, 
	Case 
	When Max(Admlink.AdmNo) is null then
		dbo.roundccy(
		sum(
		dbo.roundCCY(AccAss.Amount, AccAss.Currency)
		*(Case When (AccAss.Type in ('BB','BA','BC','BP','BD','OP') and Profile.VATF=1) or (AccAss.Type not in ('BB','BA','BC','BP','BD','OP','DI','IC','CF','JP','BO') and Profile.VATF=1 and TOC.VATBusinessF=1) or (AccAss.Type in ('DI','IC','CF','JP','BO') and Insured.VATF=1 and TOC.VATBusinessF=1) Then 1 Else 0 End)
		*(Case When SysTab.TaxMethod=0 or (Accass.Type in ('CP','DC','QS','QP','S1','S2','S3','AF','XP','FO','FP','IR','IX') and AccAss.Code='C') or (AccAss.Type in ('OP')) or (Accass.Type Not in ('CP','DC','QS','QP','S1','S2','S3','AF','XP','FO','FP','IR','IX') and AccAss.Code Not in ('F','D')) Then 1 else 0 end)
		*(Case When Acceptance.NoRefundF=7 and AccAss.Type in ('BB','BA','BO','BC','BP','BD') and AccAss.Code in ('C') then 0 else 1 end)
		*(Case When Acceptance.NoRefundF in (8,10,14) then 0 else 1 end)
		)
		,Accass.Currency)
		*(Max(MParam.VAT)/100)
	When Max(coalesce((Admlink.Amount-Admlink.Amount_11-Admlink.Amount_12-(Admlink.Amount_8+Admlink.Amount_13+Admlink.Amount_17+Admlink.Amount_18)-Admlink.Amount_14),0))<>0 then 
		sum((Admlink.Amount_13)*dbo.roundCCY(AccAss.Amount, AccAss.Currency))/Max(coalesce((Admlink.Amount-Admlink.Amount_11-Admlink.Amount_12-(Admlink.Amount_8+Admlink.Amount_13+Admlink.Amount_17+Admlink.Amount_18)-Admlink.Amount_14),0))
	Else 0 end
	as VAT,        
	Case 
	When Max(Admlink.AdmNo) is null then
		dbo.roundccy(
		sum(
		dbo.roundCCY(AccAss.Amount, AccAss.Currency)
		*(Case When (AccAss.Type in ('BB','BA','BC','BP','BD','OP') and Profile.VATF=1) or (AccAss.Type not in ('BB','BA','BC','BP','BD','OP','DI','IC','CF','JP','BO') and Profile.VATF=1 and TOC.VATBusinessF=1) or (AccAss.Type in ('DI','IC','CF','JP','BO') and Insured.VATF=1 and TOC.VATBusinessF=1) Then 1 Else 0 End)
		*(Case When SysTab.TaxMethod=0 or (Accass.Type in ('CP','DC','QS','QP','S1','S2','S3','AF','XP','FO','FP','IR','IX') and AccAss.Code='C') or (AccAss.Type in ('OP')) or (Accass.Type Not in ('CP','DC','QS','QP','S1','S2','S3','AF','XP','FO','FP','IR','IX') and AccAss.Code Not in ('F','D')) Then 1 else 0 end)
		*(Case When Acceptance.NoRefundF=7 and AccAss.Type in ('BB','BA','BO','BC','BP','BD') and AccAss.Code in ('C') then 0 else 1 end)
		*(Case When Acceptance.NoRefundF in (8,10,14) then 0 else 1 end)
		*(Case When SysTab.VATSubsidiesF=1 or Profile.VATSubsidiesF=1 then 1 else 0 end)
		)
		,Accass.Currency)
		*Case When (Max(MParam.VAT)/100)<0 Then -(Max(MParam.VAT)/100) else 0 end
	When Max(coalesce((Admlink.Amount-Admlink.Amount_11-Admlink.Amount_12-(Admlink.Amount_8+Admlink.Amount_13+Admlink.Amount_17+Admlink.Amount_18)-Admlink.Amount_14),0))<>0 then 
		sum((Admlink.Amount_8)*dbo.roundCCY(AccAss.Amount, AccAss.Currency))/Max(coalesce((Admlink.Amount-Admlink.Amount_11-Admlink.Amount_12-(Admlink.Amount_8+Admlink.Amount_13+Admlink.Amount_17+Admlink.Amount_18)-Admlink.Amount_14),0))
	Else 0 end
	as VATSubsidies,   
	Case 
	When Max(Admlink.AdmNo) is null then
		dbo.roundccy(
		sum(
		dbo.roundCCY(AccAss.Amount, AccAss.Currency)
		*(Case When SysTab.TaxMethod=0 or (Accass.Type in ('CP','DC','QS','QP','S1','S2','S3','AF','XP','FO','FP','IR','IX') and AccAss.Code='C') or (AccAss.Type in ('OP')) or (Accass.Type Not in ('CP','DC','QS','QP','S1','S2','S3','AF','XP','FO','FP','IR','IX') and AccAss.Code Not in ('F','D')) Then 1 else 0 end)
		*(Case When Profile.BVatF=1 or (AccAss.Type in ('DI','IC','CF','JP','BO')) Then 1 else 0 end)
		*(Case When Acceptance.NoRefundF<>11 and Acceptance.NoRefundF<>14 and AccAss.Type in ('DI','IC','CF','JP','BO') and Insured.BVatF=1 then 1 else 0 end)
		)
		,Accass.Currency)
		*Max((Case When coalesce(Acceptance.OverwriteBVatF,0)=0 Then Branch.VAT else coalesce(Acceptance.BVATPCT,0) end)/100)
	When Max(coalesce((Admlink.Amount-Admlink.Amount_11-Admlink.Amount_12-(Admlink.Amount_8+Admlink.Amount_13+Admlink.Amount_17+Admlink.Amount_18)-Admlink.Amount_14),0))<>0 then 
		sum((Admlink.Amount_17)*dbo.roundCCY(AccAss.Amount, AccAss.Currency))/Max(coalesce((Admlink.Amount-Admlink.Amount_11-Admlink.Amount_12-(Admlink.Amount_8+Admlink.Amount_13+Admlink.Amount_17+Admlink.Amount_18)-Admlink.Amount_14),0))
	Else 0 end
	as VAT_1,      
	Case 
	When Max(Admlink.AdmNo) is null then
		Case when Max(AccAss.Type) in ('DI','IC','CF','JP','BO') Then 	
			Case When Max(SysTab.TaxMethod)<>2 then
				dbo.roundccy(
				sum(
				dbo.roundCCY(AccAss.Amount, AccAss.Currency)
				*(Case When SysTab.TaxMethod=0 or (Accass.Type in ('CP','DC','QS','QP','S1','S2','S3','AF','XP','FO','FP','IR','IX') and AccAss.Code='C') or (AccAss.Type in ('OP')) or (Accass.Type Not in ('CP','DC','QS','QP','S1','S2','S3','AF','XP','FO','FP','IR','IX') and AccAss.Code Not in ('F','D')) Then 1 else 0 end)
				*(Case When Profile.TVatF=1 or (AccAss.Type in ('DI','IC','CF','JP','BO')) Then 1 else 0 end)
				*(Case When Acceptance.NoRefundF<>11 and Acceptance.NoRefundF<>14 and AccAss.Type in ('DI','IC','CF','JP','BO') and Insured.TVatF=1 then 1 else 0 end)
				)
				,Accass.Currency)
			else
				dbo.roundccy(
				sum(
				dbo.roundCCY(AccAss.Amount, AccAss.Currency)*coalesce(RateCov.Portion,0)/coalesce(pRCover.Portion, RCover.Portion)
				*Case When (AccAss.Type in ('DI','IC') and Accass.Code in ('P','O','U')) or (AccAss.Type in ('CF','JP') and AccAss.Code in ('P','O')) or (AccAss.Type in ('BO')) Then 1 else 0 end			
				)
				,Accass.Currency)
			end
		else
			0
		end
		*Max((Case When coalesce(Acceptance.OverwriteTVatF,0)=0 Then TOC.VAT else coalesce(Acceptance.TVATPCT,0) end)/100)
	When Max(coalesce((Admlink.Amount-Admlink.Amount_11-Admlink.Amount_12-(Admlink.Amount_8+Admlink.Amount_13+Admlink.Amount_17+Admlink.Amount_18)-Admlink.Amount_14),0))<>0 then 
		sum((Admlink.Amount_18)*dbo.roundCCY(AccAss.Amount, AccAss.Currency))/Max(coalesce((Admlink.Amount-Admlink.Amount_11-Admlink.Amount_12-(Admlink.Amount_8+Admlink.Amount_13+Admlink.Amount_17+Admlink.Amount_18)-Admlink.Amount_14),0))
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
			*dbo.roundCCY(AccAss.Amount, AccAss.Currency)
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
		sum((Admlink.Amount_14)*dbo.roundCCY(AccAss.Amount, AccAss.Currency))/Max(coalesce((Admlink.Amount-Admlink.Amount_11-Admlink.Amount_12-(Admlink.Amount_8+Admlink.Amount_13+Admlink.Amount_17+Admlink.Amount_18)-Admlink.Amount_14),0))
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

GO

DROP FUNCTION PREMIUM_CALCULATION
GO
CREATE FUNCTION PREMIUM_CALCULATION(@P_ANO int)                  
RETURNS TABLE  AS                  
RETURN (                  

Select ANO, Currency,
sum(dbo.RoundCCY(Premium,Currency)) as Premium,
sum(dbo.RoundCCY(Commission,Currency)) as Commission,
sum(dbo.RoundCCY(Discount,Currency)) as Discount,
sum(dbo.RoundCCY(VAT,Currency)) as VAT,
sum(dbo.RoundCCY(TAX,Currency)) as TAX,
Sum(dbo.RoundCCY(FeeDuty,Currency)) as FeeDuty      
from
(
	Select ANO, Code, SDate, EDate, Currency,   
	sum(Premium-Case When NoRefundF=7 Then Premium*dbo.Premium_Commission(CANO,Code,PolicyYear,MinimumPremiumF)/100 else 0 end) as Premium,           
	sum(Case When NoRefundF=7 Then 0 else Premium*dbo.Premium_Commission(CANO,Code,PolicyYear,MinimumPremiumF)/100 end) as Commission,           
	sum(Premium*dbo.Premium_Discount(CANO,Code,PolicyYear)/100) as Discount,           
	sum(Case When NoRefundF=7 Then 0 else Premium*dbo.Premium_Commission_Vat(CANO,Code,PolicyYear,MinimumPremiumF)/100 end) as Vat,           
	sum(Case When NoRefundF=7 Then 0 else Premium*dbo.Premium_Commission_Tax(CANO,Code,PolicyYear,MinimumPremiumF)/100 end) as Tax,
	cast(0 as Float) as FeeDuty      
	from PREMIUM_CALCULATION_BASE(@P_ANO) T                                              
	Group By ANO, Code, SDate, EDate, Currency          

	Union All                  
                                 
	select A3.ANO, AccAss.RCode as Code, AccAss.SDate, AccAss.EDate, AccAss.Currency_OC as Currency,                  
	sum(Case When AccAss.Code in ('P','U') then (Case When A3.AType='A' and AccAss.AdjMethod='OVERLIMIT' then -AccAss.CAmount*(Case When A3.CPCT<>0 Then A3.CPCT/100 else 1 end)/(Case When AccAss.PProrata<>0 Then AccAss.PProrata else 1 end) else -AccAss.Amount_OC end)*(Case When AccAss.Type='DI' then 100/(100-coalesce(Coinsurance.MShare,0)) else 1 end) else 0 end) as Premium,                  
	sum(Case When AccAss.Code='C' then (Case When A3.AType='A' and AccAss.AdjMethod='OVERLIMIT' then AccAss.CAmount*(Case When A3.CPCT<>0 Then A3.CPCT/100 else 1 end)/(Case When AccAss.PProrata<>0 Then AccAss.PProrata else 1 end) else AccAss.Amount_OC end)*(Case When AccAss.Type='DI' then 100/(100-coalesce(Coinsurance.MShare,0)) else 1 end) else 0 end) as Commission,                  
	sum(Case When AccAss.Code='O' then (Case When A3.AType='A' and AccAss.AdjMethod='OVERLIMIT' then AccAss.CAmount*(Case When A3.CPCT<>0 Then A3.CPCT/100 else 1 end)/(Case When AccAss.PProrata<>0 Then AccAss.PProrata else 1 end) else AccAss.Amount_OC end)*(Case When AccAss.Type='DI' then 100/(100-coalesce(Coinsurance.MShare,0)) else 1 end) else 0 end) as Discount,                  
	sum((Case When A3.AType='A' and AccAss.AdjMethod='OVERLIMIT' then AccAss.CAmount*(Case When A3.CPCT<>0 Then A3.CPCT/100 else 1 end)/(Case When AccAss.PProrata<>0 Then AccAss.PProrata else 1 end) else AccAss.Amount_OC end)*(Case When AccAss.Type='DI' then 100/(100-coalesce(Coinsurance.MShare,0)) else 1 end)*(Case When (Case When (coalesce(Profile.VATESDate,'01/01/1900')<= A2.ADate and coalesce(Profile.VatEEDate,'01/01/1900')>= A2.ADate) Then cast(0 as Bit) else Profile.VatF end)=1 Then MParam.Vat/100 else 0 end)) as Vat,                  
	sum((Case When A3.AType='A' and AccAss.AdjMethod='OVERLIMIT' then AccAss.CAmount*(Case When A3.CPCT<>0 Then A3.CPCT/100 else 1 end)/(Case When AccAss.PProrata<>0 Then AccAss.PProrata else 1 end) else AccAss.Amount_OC end)*(Case When AccAss.Type='DI' then 100/(100-coalesce(Coinsurance.MShare,0)) else 1 end)*(Case When (Case When (coalesce(Profile.TaxHSDate,'01/01/1900')<= A2.ADate and coalesce(Profile.TaxHEDate,'01/01/1900')>= A2.ADate) Then cast(0 as Bit) else Profile.TaxF end)=1 Then (Case When TaxType.MTaxType='PASAL21' Then MParam.Pasal21/100*(100-MParam.TaxDiscount)/100 When TaxType.MTaxType='PASAL23' Then MParam.Pasal23/100 When TaxType.MTaxType='PASAL26' Then MParam.Pasal26/100 When TaxType.MTaxType='PASAL4' Then MParam.PASAL4/100 else 0 end)*(Case When Profile.TaxPCT=0 Then 1 else Profile.TaxPCT/100 end) else Profile.AccruedTax/100 end)) as Tax,      
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
        
GO

DROP FUNCTION PREMIUM_CALCULATION_BY_RATECODE
GO
CREATE FUNCTION PREMIUM_CALCULATION_BY_RATECODE(@P_ANO int)                  
RETURNS TABLE  AS                  
RETURN (                  

Select ANO, Code, Currency,
sum(dbo.RoundCCY(Premium,Currency)) as Premium,
sum(dbo.RoundCCY(Commission,Currency)) as Commission,
sum(dbo.RoundCCY(Discount,Currency)) as Discount,
sum(dbo.RoundCCY(VAT,Currency)) as VAT,
sum(dbo.RoundCCY(TAX,Currency)) as TAX,
Sum(dbo.RoundCCY(FeeDuty,Currency)) as FeeDuty       
from
(
	Select ANO, Code, SDate, EDate, Currency,   
	sum(Premium-Case When NoRefundF=7 Then Premium*dbo.Premium_Commission(CANO,Code,PolicyYear,MinimumPremiumF)/100 else 0 end) as Premium,           
	sum(Case When NoRefundF=7 Then 0 else Premium*dbo.Premium_Commission(CANO,Code,PolicyYear,MinimumPremiumF)/100 end) as Commission,           
	sum(Premium*dbo.Premium_Discount(CANO,Code,PolicyYear)/100) as Discount,           
	sum(Case When NoRefundF=7 Then 0 else Premium*dbo.Premium_Commission_Vat(CANO,Code,PolicyYear,MinimumPremiumF)/100 end) as Vat,           
	sum(Case When NoRefundF=7 Then 0 else Premium*dbo.Premium_Commission_Tax(CANO,Code,PolicyYear,MinimumPremiumF)/100 end) as Tax,
	cast(0 as Float) as FeeDuty      
	from PREMIUM_CALCULATION_BASE(@P_ANO) T                                              
	Group By ANO, Code, SDate, EDate, Currency          

	Union All                  
                                 
	select A3.ANO, AccAss.RCode as Code, AccAss.SDate, AccAss.EDate, AccAss.Currency_OC as Currency,                  
	sum(Case When AccAss.Code in ('P','U') then (Case When A3.AType='A' and AccAss.AdjMethod='OVERLIMIT' then -AccAss.CAmount*(Case When A3.CPCT<>0 Then A3.CPCT/100 else 1 end)/(Case When AccAss.PProrata<>0 Then AccAss.PProrata else 1 end) else -AccAss.Amount_OC end)*(Case When AccAss.Type='DI' then 100/(100-coalesce(Coinsurance.MShare,0)) else 1 end) else 0 end) as Premium,                  
	sum(Case When AccAss.Code='C' then (Case When A3.AType='A' and AccAss.AdjMethod='OVERLIMIT' then AccAss.CAmount*(Case When A3.CPCT<>0 Then A3.CPCT/100 else 1 end)/(Case When AccAss.PProrata<>0 Then AccAss.PProrata else 1 end) else AccAss.Amount_OC end)*(Case When AccAss.Type='DI' then 100/(100-coalesce(Coinsurance.MShare,0)) else 1 end) else 0 end) as Commission,                  
	sum(Case When AccAss.Code='O' then (Case When A3.AType='A' and AccAss.AdjMethod='OVERLIMIT' then AccAss.CAmount*(Case When A3.CPCT<>0 Then A3.CPCT/100 else 1 end)/(Case When AccAss.PProrata<>0 Then AccAss.PProrata else 1 end) else AccAss.Amount_OC end)*(Case When AccAss.Type='DI' then 100/(100-coalesce(Coinsurance.MShare,0)) else 1 end) else 0 end) as Discount,                  
	sum((Case When A3.AType='A' and AccAss.AdjMethod='OVERLIMIT' then AccAss.CAmount*(Case When A3.CPCT<>0 Then A3.CPCT/100 else 1 end)/(Case When AccAss.PProrata<>0 Then AccAss.PProrata else 1 end) else AccAss.Amount_OC end)*(Case When AccAss.Type='DI' then 100/(100-coalesce(Coinsurance.MShare,0)) else 1 end)*(Case When (Case When (coalesce(Profile.VATESDate,'01/01/1900')<= A2.ADate and coalesce(Profile.VatEEDate,'01/01/1900')>= A2.ADate) Then cast(0 as Bit) else Profile.VatF end)=1 Then MParam.Vat/100 else 0 end)) as Vat,                  
	sum((Case When A3.AType='A' and AccAss.AdjMethod='OVERLIMIT' then AccAss.CAmount*(Case When A3.CPCT<>0 Then A3.CPCT/100 else 1 end)/(Case When AccAss.PProrata<>0 Then AccAss.PProrata else 1 end) else AccAss.Amount_OC end)*(Case When AccAss.Type='DI' then 100/(100-coalesce(Coinsurance.MShare,0)) else 1 end)*(Case When (Case When (coalesce(Profile.TaxHSDate,'01/01/1900')<= A2.ADate and coalesce(Profile.TaxHEDate,'01/01/1900')>= A2.ADate) Then cast(0 as Bit) else Profile.TaxF end)=1 Then (Case When TaxType.MTaxType='PASAL21' Then MParam.Pasal21/100*(100-MParam.TaxDiscount)/100 When TaxType.MTaxType='PASAL23' Then MParam.Pasal23/100 When TaxType.MTaxType='PASAL26' Then MParam.Pasal26/100 When TaxType.MTaxType='PASAL4' Then MParam.PASAL4/100 else 0 end)*(Case When Profile.TaxPCT=0 Then 1 else Profile.TaxPCT/100 end) else Profile.AccruedTax/100 end)) as Tax,      
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
		Left Join Acceptance A2 on (A2.OANO=A1.OANO and A2.Atype='C' and A2.EMethod='A' and A2.ANO<@P_ANO)
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
			pA2.ANO=A3.PANO and A3.PDate<=pA2.PDate and A3.PPDate>=pA2.PPDate and pA2.PDATE<pA2.PPDATE and (A2.AType='E' and coalesce(pA2.AType,'') in ('N','E'))   
			and AccAss.AdjustableF=1 and AccAss.AdjMethod<>'OVERLIMIT' and AccAss.CAmount=0  
			and pA2.ANO<=A3.PADJANO 
			)     
			or   
			(  
			A2.ANO<=A3.PANO and A3.PDate<=A2.PDate and A3.PPDate>=A2.PPDate and A2.PDATE<A2.PPDATE and (A2.AType<>'A' and coalesce(pA2.AType,'')<>'A')   
			and AccAss.AdjustableF=1 and AccAss.AdjMethod<>'OVERLIMIT'  
			and A2.ANO<=A3.PADJANO and A2.PANO<>A3.PADJANO
			)     
			or   
			(  
			A2.ANO<=A3.PANO and A3.PDate<=A2.PDate and A3.PPDate>=A2.PPDate and A2.PDATE<A2.PPDATE and (A2.AType<>'A' and coalesce(pA2.AType,'')<>'A')   
			and AccAss.AdjustableF=1 and AccAss.AdjMethod<>'OVERLIMIT' and AccAss.CAmount<>0  
			and A2.PANO=A3.PADJANO
			)     
			or   
			(  
			A2.ANO<=A3.PANO and A3.PDate<=A2.PDate and A3.PPDate>=A2.PPDate and A2.PDATE<A2.PPDATE and (A2.AType<>'A' and coalesce(pA2.AType,'')<>'A')   
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
	(AccAss.Type in ('DI','IC','IR') and AccAss.Code='P') 
	or (AccAss.Type in ('DI','IC') and AccAss.Code='U') 
	Or (AccAss.Type in ('BB','BA','BO') and AccAss.Code='C') 
	or (AccAss.Type in ('DI','IC','IR') and AccAss.Code='O') 
	or (A3.AType='C' and A3.EMethod='A' and AccAss.Type in ('DI') and AccAss.Code in ('F','D'))
	)                  
	Group By A3.ANO, AccAss.RCode, AccAss.SDate, AccAss.EDate, AccAss.Currency_OC
) T          
Group by ANO, Code, Currency


)       
GO

DROP PROCEDURE View05L1 
GO

CREATE PROCEDURE View05L1 (@p_ANO as integer)    
AS    

Declare @PremiumCalc Table(Currency varchar(10), Rate float, TSI Float, OurShare Float, Gross Float, CRate Float, Premium FLoat, Discount FLoat, Commission FLoat, VAT Float, TAX FLoat, FeeDuty Float)
Declare @ANO as int
Declare @LANO as int
Declare @RegNo as varchar(50)
Declare @OpenFlag as Bit
Declare @AStatus as varchar(1)

Select @ANO=Acceptance.ANO, @LANO=Acceptance.LANO, @RegNo=Acceptance.RegNo, @OpenFlag=Cover.OpenFlag, @Astatus=Acceptance.AStatus
from Acceptance 
Inner Join Cover on (Cover.CNO=Acceptance.CNO)
Where Acceptance.ANO=@P_ANO

if @ANO<>@LANO or @OpenFlag=1
Begin
	insert into @PremiumCalc

	SELECT P2.Currency, max(coalesce(P1.Rate,0)) as Rate, max(coalesce(P1.TSI,0)) as TSI, max(coalesce(P1.OurShare,0)) as OurShare, Max(coalesce(P1.Gross,0)) as Gross, max(coalesce(P1.CRate,0)) as CRate, sum(P2.Premium) as Premium, sum(P2.Discount) as Discount, sum(P2.Commission) as Commission, sum(P2.Vat) as Vat, sum(P2.Tax) as Tax, sum(P2.FeeDuty) as FeeDuty   
	FROM PREMIUM_CALCULATION(@P_ANO) P2 
	Outer Apply (
		Select PCalc.Currency, Max(PCalc.Rate) as Rate, Max(PCalc.TSI) as TSI, Max(PCalc.OurShare) as Ourshare, Max(PCalc.CRate) as CRate,
		Case 
		When Max(PCalc.Gross)<>Max(PCalc.OGross) then Max(PCalc.Gross)
		Else sum(dbo.roundccy(RCalc.OGross, RCalc.Currency))
		End as Gross
		from PCalc 
		Inner join RCalc on (RCalc.ANO=PCalc.ANO and RCalc.Currency=PCalc.Currency)
		Where Pcalc.ANO=P2.ANO and PCalc.Currency=P2.Currency
		Group by PCalc.Currency
	) P1
	Group By P2.Currency    
                     
	Union All          

	Select AccFD.Currency, 0 as Rate, 0 as TSI, 0 as OurShare, 0 as Gross, 0 as CRate, 0 as Premium, 0 as Discount, 0 as Commission, 0 as Vat, 0 as Tax, 
	Case 
	When FDTab.FDType<>'O' Then (ACCFD.Amount)
	Else -(ACCFD.Amount) End as FeeDuty
	from AccFD
	Inner Join FDTAB on (FDTab.FDID=AccFD.FDID)
	Where AccFD.ANO=@P_ANO and AccFD.Amount<>0

	Union All

	Select AccFD.Currency, 0 as Rate, 0 as TSI, 0 as OurShare, 0 as Gross, 0 as CRate, 0 as Premium, 0 as Discount, 0 as Commission, 0 as Vat, 0 as Tax, 
	sum(dbo.RoundCCY(
	Case 
	When FDTab.FDType<>'O' Then 
		  (D1.Gross*(100-D1.Discount)/100*D1.Prorata*P.Gross/P.OGross*P.OurShare/P.TSI*AccFD.AmountPCT/100*case When AccFD.AMOUNTPCTBASED=3 Then (1-dbo.Premium_Commission(D1.ANO, D1.Code,0,0)/100) else 1 end)
	Else
		  -(D1.Gross*D1.Prorata*P.Gross/P.OGross*P.OurShare/P.TSI*(100-R.MSHARE)/100*AccFD.AmountPCT/100*case When AccFD.AMOUNTPCTBASED=3 Then (1-dbo.Premium_Commission(D1.ANO, D1.Code,0,0)/100) else 1 end)
	End 
	,AccFD.Currency)) as FeeDuty
	from Display_Calculation(@P_ANO) D1
	Inner join RarrHeader R on (R.ANO=D1.ANO)
	Inner join PCalc P on (P.ANO=D1.ANO and P.Currency=D1.Currency)
	Inner Join AccFD on (AccFD.ANO=@P_ANO and AccFD.Currency=D1.Currency)
	Inner Join FDTAB ON (FDTab.FDID=AccFD.FDID)
	Where  AccFD.Amount=0 and AccFd.AMOUNTPCTBASED in (0,3)
	Group by ACCFD.Currency

	Union All

	Select AccFD.Currency, 0 as Rate, 0 as TSI, 0 as OurShare, 0 as Gross, 0 as CRate, 0 as Premium, 0 as Discount, 0 as Commission, 0 as Vat, 0 as Tax, 
	sum(dbo.roundccy(
	Case 
	When FDTab.FDType<>'O' Then 
		(coalesce(P.OurShare,0)-coalesce(PP.OurShare,0))*AccFD.AmountPCT/100
	Else
		-coalesce(P.OurShare*(100-R.MSHARE)/100,0)-coalesce(PP.OurShare*(100-PR.MSHARE)/100,0)*AccFD.AmountPCT/100
	End
	,AccFD.Currency)) as FeeDuty
	from 
	AccFD
	Inner Join FDTab on (FDTAB.FDID=AccFD.FDID)
	Inner Join Acceptance A on (A.ANO=AccFD.ANO)
	Left Join Acceptance PA on (PA.ANO=A.PANO)
	Left Join PCalc P on (P.ANO=A.ANO and P.Currency=AccFD.Currency and A.AType Not in ('A','C'))
	Left Join RArrHeader R on (R.ANO=A.ANO and A.AType Not in ('A','C'))
	Left Join PCalc PP on (PP.ANO=A.PANO and PP.Currency=P.Currency and PA.AType Not in ('A','C'))
	Left Join RArrHeader PR on (PR.ANO=A.PANO and PA.AType Not in ('A','C'))	
	Where AccFD.ANO=@P_ANO
	and AccFD.Amount=0 and AccFd.AMOUNTPCTBASED Not in (0,3)
	Group by ACCFD.Currency

End
else
Begin
	if @RegNo='' or @AStatus in ('W','T')   
	Begin
		insert into @PremiumCalc
		Select P.*
		from Acceptance A
		Cross Apply
		(
			SELECT P2.Currency, max(coalesce(P1.Rate,0)) as Rate, max(coalesce(P1.TSI,0)) as TSI, max(coalesce(P1.OurShare,0)) as OurShare, Max(coalesce(P1.Gross,0)) as Gross, max(coalesce(P1.CRate,0)) as CRate, sum(P2.Premium) as Premium, sum(P2.Discount) as Discount, sum(P2.Commission) as Commission, sum(P2.Vat) as Vat, sum(P2.Tax) as Tax, sum(P2.FeeDuty) as FeeDuty   
			FROM PREMIUM_CALCULATION(A.ANO) P2 
			Outer Apply (
				Select PCalc.Currency, Max(PCalc.Rate) as Rate, Max(PCalc.TSI) as TSI, Max(PCalc.OurShare) as Ourshare, Max(PCalc.CRate) as CRate,
				Case 
				When Max(PCalc.Gross)<>Max(PCalc.OGross) then Max(PCalc.Gross)
				Else sum(dbo.roundccy(RCalc.OGross, RCalc.Currency))
				End as Gross
				from PCalc 
				Inner join RCalc on (RCalc.ANO=PCalc.ANO and RCalc.Currency=PCalc.Currency)
				Where Pcalc.ANO=P2.ANO and PCalc.Currency=P2.Currency
				Group by PCalc.Currency
			) P1 
			Group By P2.Currency    
                     
			Union All          

			Select AccFD.Currency, 0 as Rate, 0 as TSI, 0 as OurShare, 0 as Gross, 0 as CRate, 0 as Premium, 0 as Discount, 0 as Commission, 0 as Vat, 0 as Tax, 
			Case 
			When FDTab.FDType<>'O' Then (ACCFD.Amount)
			Else -(ACCFD.Amount) End as FeeDuty
			from AccFD
			Inner Join FDTAB on (FDTab.FDID=AccFD.FDID)
			Where AccFD.ANO=A.ANO and AccFD.Amount<>0

			Union All

			Select AccFD.Currency, 0 as Rate, 0 as TSI, 0 as OurShare, 0 as Gross, 0 as CRate, 0 as Premium, 0 as Discount, 0 as Commission, 0 as Vat, 0 as Tax, 
			sum(dbo.RoundCCY(
			Case 
			When FDTab.FDType<>'O' Then 
				  (D1.Gross*(100-D1.Discount)/100*D1.Prorata*P.Gross/P.OGross*P.OurShare/P.TSI*AccFD.AmountPCT/100*case When AccFD.AMOUNTPCTBASED=3 Then (1-dbo.Premium_Commission(D1.ANO, D1.Code,0,0)/100) else 1 end)
			Else
				  -(D1.Gross*D1.Prorata*P.Gross/P.OGross*P.OurShare/P.TSI*(100-R.MSHARE)/100*AccFD.AmountPCT/100*case When AccFD.AMOUNTPCTBASED=3 Then (1-dbo.Premium_Commission(D1.ANO, D1.Code,0,0)/100) else 1 end)
			End 
			,AccFD.Currency)) as FeeDuty
			from Display_Calculation(A.ANO) D1
			Inner join RarrHeader R on (R.ANO=D1.ANO)
			Inner join PCalc P on (P.ANO=D1.ANO and P.Currency=D1.Currency)
			Inner Join AccFD on (AccFD.ANO=A.ANO and AccFD.Currency=D1.Currency)
			Inner Join FDTAB ON (FDTab.FDID=AccFD.FDID)
			Where  AccFD.Amount=0 and AccFd.AMOUNTPCTBASED in (0,3)
			Group by ACCFD.Currency

			Union All

			Select AccFD.Currency, 0 as Rate, 0 as TSI, 0 as OurShare, 0 as Gross, 0 as CRate, 0 as Premium, 0 as Discount, 0 as Commission, 0 as Vat, 0 as Tax, 
			sum(dbo.roundccy(
			Case 
			When FDTab.FDType<>'O' Then 
				(coalesce(P.OurShare,0)-coalesce(PP.OurShare,0))*AccFD.AmountPCT/100
			Else
				-coalesce(P.OurShare*(100-R.MSHARE)/100,0)-coalesce(PP.OurShare*(100-PR.MSHARE)/100,0)*AccFD.AmountPCT/100
			End
			,AccFD.Currency)) as FeeDuty
			from 
			AccFD
			Inner Join FDTab on (FDTAB.FDID=AccFD.FDID)
			Left Join Acceptance PA on (PA.ANO=A.PANO)
			Left Join PCalc P on (P.ANO=A.ANO and P.Currency=AccFD.Currency and A.AType Not in ('A','C'))
			Left Join RArrHeader R on (R.ANO=A.ANO and A.AType Not in ('A','C'))
			Left Join PCalc PP on (PP.ANO=A.PANO and PP.Currency=P.Currency and PA.AType Not in ('A','C'))
			Left Join RArrHeader PR on (PR.ANO=A.PANO and PA.AType Not in ('A','C'))	
			Where AccFD.ANO=A.ANO
			and AccFD.Amount=0 and AccFd.AMOUNTPCTBASED Not in (0,3)
			Group by ACCFD.Currency
		) P
		Where A.LANO=@ANO 
	End
	else
	Begin
		insert into @PremiumCalc
		Select P.*
		from Acceptance A
		Cross Apply
		(
			SELECT P2.Currency, max(coalesce(P1.Rate,0)) as Rate, max(coalesce(P1.TSI,0)) as TSI, max(coalesce(P1.OurShare,0)) as OurShare, Max(coalesce(P1.Gross,0)) as Gross, max(coalesce(P1.CRate,0)) as CRate, sum(P2.Premium) as Premium, sum(P2.Discount) as Discount, sum(P2.Commission) as Commission, sum(P2.Vat) as Vat, sum(P2.Tax) as Tax, sum(P2.FeeDuty) as FeeDuty   
			FROM PREMIUM_CALCULATION(A.ANO) P2 
			Outer Apply (
				Select PCalc.Currency, Max(PCalc.Rate) as Rate, Max(PCalc.TSI) as TSI, Max(PCalc.OurShare) as Ourshare, Max(PCalc.CRate) as CRate,
				Case 
				When Max(PCalc.Gross)<>Max(PCalc.OGross) then Max(PCalc.Gross)
				Else sum(dbo.roundccy(RCalc.OGross, RCalc.Currency))
				End as Gross
				from PCalc 
				Inner join RCalc on (RCalc.ANO=PCalc.ANO and RCalc.Currency=PCalc.Currency)
				Where Pcalc.ANO=P2.ANO and PCalc.Currency=P2.Currency
				Group by PCalc.Currency
			) P1 
			Group By P2.Currency    
                     
			Union All          

			Select AccFD.Currency, 0 as Rate, 0 as TSI, 0 as OurShare, 0 as Gross, 0 as CRate, 0 as Premium, 0 as Discount, 0 as Commission, 0 as Vat, 0 as Tax, 
			Case 
			When FDTab.FDType<>'O' Then (ACCFD.Amount)
			Else -(ACCFD.Amount) End as FeeDuty
			from AccFD
			Inner Join FDTAB on (FDTab.FDID=AccFD.FDID)
			Where AccFD.ANO=A.ANO and AccFD.Amount<>0

			Union All

			Select AccFD.Currency, 0 as Rate, 0 as TSI, 0 as OurShare, 0 as Gross, 0 as CRate, 0 as Premium, 0 as Discount, 0 as Commission, 0 as Vat, 0 as Tax, 
			sum(dbo.RoundCCY(
			Case 
			When FDTab.FDType<>'O' Then 
				  (D1.Gross*(100-D1.Discount)/100*D1.Prorata*P.Gross/P.OGross*P.OurShare/P.TSI*AccFD.AmountPCT/100*case When AccFD.AMOUNTPCTBASED=3 Then (1-dbo.Premium_Commission(D1.ANO, D1.Code,0,0)/100) else 1 end)
			Else
				  -(D1.Gross*D1.Prorata*P.Gross/P.OGross*P.OurShare/P.TSI*(100-R.MSHARE)/100*AccFD.AmountPCT/100*case When AccFD.AMOUNTPCTBASED=3 Then (1-dbo.Premium_Commission(D1.ANO, D1.Code,0,0)/100) else 1 end)
			End 
			,AccFD.Currency)) as FeeDuty
			from Display_Calculation(A.ANO) D1
			Inner join RarrHeader R on (R.ANO=D1.ANO)
			Inner join PCalc P on (P.ANO=D1.ANO and P.Currency=D1.Currency)
			Inner Join AccFD on (AccFD.ANO=A.ANO and AccFD.Currency=D1.Currency)
			Inner Join FDTAB ON (FDTab.FDID=AccFD.FDID)
			Where  AccFD.Amount=0 and AccFd.AMOUNTPCTBASED in (0,3)
			Group by ACCFD.Currency

			Union All

			Select AccFD.Currency, 0 as Rate, 0 as TSI, 0 as OurShare, 0 as Gross, 0 as CRate, 0 as Premium, 0 as Discount, 0 as Commission, 0 as Vat, 0 as Tax, 
			sum(dbo.roundccy(
			Case 
			When FDTab.FDType<>'O' Then 
				(coalesce(P.OurShare,0)-coalesce(PP.OurShare,0))*AccFD.AmountPCT/100
			Else
				-coalesce(P.OurShare*(100-R.MSHARE)/100,0)-coalesce(PP.OurShare*(100-PR.MSHARE)/100,0)*AccFD.AmountPCT/100
			End
			,AccFD.Currency)) as FeeDuty
			from 
			AccFD
			Inner Join FDTab on (FDTAB.FDID=AccFD.FDID)
			Left Join Acceptance PA on (PA.ANO=A.PANO)
			Left Join PCalc P on (P.ANO=A.ANO and P.Currency=AccFD.Currency and A.AType Not in ('A','C'))
			Left Join RArrHeader R on (R.ANO=A.ANO and A.AType Not in ('A','C'))
			Left Join PCalc PP on (PP.ANO=A.PANO and PP.Currency=P.Currency and PA.AType Not in ('A','C'))
			Left Join RArrHeader PR on (PR.ANO=A.PANO and PA.AType Not in ('A','C'))	
			Where AccFD.ANO=A.ANO
			and AccFD.Amount=0 and AccFd.AMOUNTPCTBASED Not in (0,3)
			Group by ACCFD.Currency
		) P
		Where A.RegNo<>'' and A.RegNo=@RegNo 
	End

end


Select @p_ANO ANO, Currency, Max(Rate) as Rate, sum(TSI) as TSI, sum(OurShare) as OurShare, sum(Gross) as Gross, Case When Sum(TSI)<>0 then Sum(Gross)/sum(TSI)*100 else 0 end as CRate, sum(Premium) as Premium, sum(Discount) as Discount, sum(Commission) as Commission, sum(Vat) as Vat, sum(Tax) as Tax, sum(FeeDuty) as FeeDuty    
from @PremiumCalc P
Group By Currency    


