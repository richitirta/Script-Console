
DROP Procedure QProduction_To_Adm
GO
CREATE Procedure QProduction_To_Adm(@P_ANO as int)                              
as                              
Select A1.ID, A1.TOC, A1.Type, A1.Currency, A1.Date, A1.BillDate, Max(A1.DocNo) as DocNo, A1.RefNo,  
Case When SysTab.SplitPremiumAndClaimF=1 and A1.Code in ('A','R') Then 'Claim' else 'Premium' end as Subject,       
Max(Case When coalesce(AL.RefNo,'')=A1.RefNo and C.ISType<>'T' Then coalesce(AL.AName,Case When A2.AName<>'' then A2.AName else A2.Remarks end) else Case When A2.AName<>'' then A2.AName else A2.Remarks end end) as Remarks,                                 
(Select Top 1 TreatyInstallmentF from reinsurance Where Reinsurance.docNo=A1.RefNo) as TreatyInstallmentF,
Case When (isnull(Payor.ScheduleF,0)=1) or (Case When isnull(APayor.ANO,0)=0 Then (Case When isnull(MPayor.ANO,0)=0 Then Payor.PolicyYearF else MPayor.PolicyYearF end) else APayor.PolicyYearF end)=1 Then A1.SDate else A2.SDate end as SDate,                              
Case When (isnull(Payor.ScheduleF,0)=1) or (Case When isnull(APayor.ANO,0)=0 Then (Case When isnull(MPayor.ANO,0)=0 Then Payor.PolicyYearF else MPayor.PolicyYearF end) else APayor.PolicyYearF end)=1 Then A1.EDate else A2.EDate end as EDate,               
case When coalesce(A1.Source,'')='' or A1.Source<>A1.ID then A2.Source else A1.Source end Source,                              
Case When A1.CAmount=0 and Coalesce(A3.Branch,'')<>'' Then A3.Branch Else A2.Branch end Branch,         
Max(Branch.VAT) as BVATPCT,
min (A1.SDate) as MINSDate, max(A1.SDate) as MAXSDate,                
min (A1.ACNO)  as MinACNO, min (A1.ACNO) as MaxACNO,                          
sum(Case When A1.Code='P' then A1.Amount else 0 end) as Amount_1,                              
sum(Case When A1.Code='C' then A1.Amount else 0 end) as Amount_2,                              
sum(Case When A1.Code='F' and coalesce(A1.CodeExt,'')='' then A1.Amount else 0 end) as Amount_3,                              
sum(Case When A1.Code='D' and coalesce(A1.CodeExt,'')='' then A1.Amount else 0 end) as Amount_4,                              
sum(Case When A1.Code='O' then A1.Amount else 0 end) as Amount_5,                              
sum(Case When A1.Code='A' then A1.Amount else 0 end) as Amount_6,                              
sum(Case When A1.Code='R' then A1.Amount else 0 end) as Amount_10,                              
sum(Case When A1.Code='T' then A1.Amount else 0 end) as Amount_14,                              
sum(Case When A1.Code in ('D','F') and coalesce(A1.CodeExt,'')='1' then A1.Amount else 0 end) as Amount_15,            
sum(Case When A1.Code in ('D','F') and coalesce(A1.CodeExt,'')='2' then A1.Amount else 0 end) as Amount_16,            
sum(Case When A1.Code='J' then A1.Amount else 0 end) as Amount_19,    
sum(Case When A1.Code='U' then A1.Amount else 0 end) as Amount_20                              
from AccAss A1                              
Inner Join Acceptance A2 on (A2.ANO=A1.ANO)                              
Inner Join Cover C on (C.CNO=A2.CNO)                  
Left Join Acceptance AL on (AL.ANO=A2.LANO and C.OpenFlag=0)                  
Left Join APayor on (APayor.ANO=A2.ANO and A2.LANO<>-1 and A2.ANO<>A2.LANO)                              
Left Join Payor on (Payor.ANO=A2.ANO and A2.LANO=-1)                 
Left Join Payor MPayor on (MPayor.ANO=A2.LANO and A2.LANO<>-1)                
Left join  Acceptance A3 on (A3.ANO=A2.pANO)    
Inner Join Branch on (Branch.Branch=Case When A1.CAmount=0 and Coalesce(A3.Branch,'')<>'' Then A3.Branch Else A2.Branch end)
Inner Join SysTab on (1=1)                          
Where A1.ANO=@P_ANO                              
Group By A1.ID, A1.TOC, A1.Type, A1.Currency, A1.Date, A1.BillDate, A1.RefNo,                       
Case When SysTab.SplitPremiumAndClaimF=1 and A1.Code in ('A','R') Then 'Claim' else 'Premium' end,
Case When (isnull(Payor.ScheduleF,0)=1) or (Case When isnull(APayor.ANO,0)=0 Then (Case When isnull(MPayor.ANO,0)=0 Then Payor.PolicyYearF else MPayor.PolicyYearF end) else APayor.PolicyYearF end)=1 Then A1.SDate else A2.SDate end,                
Case When (isnull(Payor.ScheduleF,0)=1) or (Case When isnull(APayor.ANO,0)=0 Then (Case When isnull(MPayor.ANO,0)=0 Then Payor.PolicyYearF else MPayor.PolicyYearF end) else APayor.PolicyYearF end)=1 Then A1.EDate else A2.EDate end,
case When coalesce(A1.Source,'')='' or A1.Source<>A1.ID then A2.Source else A1.Source end,                              
Case When A1.CAmount=0 and Coalesce(A3.Branch,'')<>'' Then A3.Branch Else A2.Branch end 


GO

DROP Procedure QUndo_Production_To_Adm
GO
CREATE Procedure QUndo_Production_To_Adm(@P_ANO as int)                      
as                      
Select A1.ADMNO,     
sum(Case When A1.Code='P' then A1.Amount else 0 end) as Amount_1,                      
sum(Case When A1.Code='C' then A1.Amount else 0 end) as Amount_2,                      
sum(Case When A1.Code='F' and coalesce(A1.CodeExt,'')='' then A1.Amount else 0 end) as Amount_3,                      
sum(Case When A1.Code='D' and coalesce(A1.CodeExt,'')='' then A1.Amount else 0 end) as Amount_4,                      
sum(Case When A1.Code='O' then A1.Amount else 0 end) as Amount_5,                      
sum(Case When A1.Code='A' then A1.Amount else 0 end) as Amount_6,                      
sum(Case When A1.Code='R' then A1.Amount else 0 end) as Amount_10,                      
sum(Case When A1.Code='T' then A1.Amount else 0 end) as Amount_14,                      
sum(Case When A1.Code in ('D','F') and coalesce(A1.CodeExt,'')='1' then A1.Amount else 0 end) as Amount_15,     
sum(Case When A1.Code in ('D','F') and coalesce(A1.CodeExt,'')='2' then A1.Amount else 0 end) as Amount_16,     
sum(Case When A1.Code='J' then A1.Amount else 0 end) as Amount_19,                      
sum(Case When A1.Code='U' then A1.Amount else 0 end) as Amount_20                      
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
Case When AccAss.CAmount=0 and Coalesce(pAcceptance.Branch,'')<>'' Then pAcceptance.Branch Else Acceptance.Branch end Branch,   
dbo.fn_Get_UWYear(Acceptance.SDate, Acceptance.EDate, Case When (Case When isnull(APayor.ANO,0)=0 Then (Case When isnull(MPayor.ANO,0)=0 Then Payor.PolicyYearF else MPayor.PolicyYearF end) else APayor.PolicyYearF end)=1 Then AccAss.SDate else Acceptance.SDate end) as PolicyYear,
sum(                
 case                
  when (accass.type in ('IR','IT','IX') and accass.code in ('P','U','F')) or (accass.type in ('DI','IC') and accass.code in ('P','U')) or (AccAss.Type not in ('DI','IC','IR','IT','IX') and AccAss.Code='P') then AccAss.Amount
  else 0                
 end                
) AS Premium,                 
sum(                
 case                 
  when accass.code='C' and coalesce(accass.codeext,'')='' then AccAss.Amount                
  else 0                
 end                
) AS Commision,                 
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
  when accass.type not in ('CP','DC','XP','QS','QP','S1','S2','S3','AF','FO') and accass.code='O' then AccAss.Amount                
  else 0                
 end                
) AS Discount,                 
sum(                
 case                 
  when accass.type in ('CP','DC','XP','QS','QP','S1','S2','S3','AF','FO') and accass.code='O' and coalesce(accass.CodeExt,'')='' then AccAss.Amount                
  else 0                
 end                
) AS Acquisition,   
sum(                
 case                 
  when accass.type in ('CP','DC','XP','QS','QP','S1','S2','S3','AF','FO') and accass.code='O' and coalesce(accass.CodeExt,'')='1' then AccAss.Amount                
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
  when accass.type not in ('CP','DC','XP','QS','QP','S1','S2','S3','AF','FO') and accass.code='J' then AccAss.Amount                
  else 0                
 end                
) AS Deposit,         
sum(                
 case                 
  when accass.type in ('CP','DC','XP','QS','QP','S1','S2','S3','AF','FO') and accass.code='J' then AccAss.Amount                
  else 0                
 end                
) AS Advance,                  
sum(Case When coalesce((Admlink.Amount-Admlink.Amount_11-Admlink.Amount_12-(Admlink.Amount_13+Admlink.Amount_17+Admlink.Amount_18)-Admlink.Amount_14),0)<>0 then Admlink.Amount_11*AccAss.Amount/(Admlink.Amount-Admlink.Amount_11-Admlink.Amount_12-(Admlink.Amount_13+Admlink.Amount_17+Admlink.Amount_18)-Admlink.Amount_14) else 0 end) as Rounding,        
sum(
Case 
When Admlink.Amount is null then
	AccAss.Amount
	*(Case When Profile.VATF=1 Then 1 Else 0 End)
	*(MParam.VAT/100)
	*(Case When SysTab.TaxMethod=0 or (Accass.Type in ('CP','DC','QS','QP','S1','S2','S3','AF','XP','FO','FP','IR','IX') and AccAss.Code='C') or (Accass.Type Not in ('CP','DC','QS','QP','S1','S2','S3','AF','XP','FO','FP','IR','IX') and AccAss.Code Not in ('F','D')) Then 1 else 0 end)
When coalesce((Admlink.Amount-Admlink.Amount_11-Admlink.Amount_12-(Admlink.Amount_13+Admlink.Amount_17+Admlink.Amount_18)-Admlink.Amount_14),0)<>0 then 
	(Admlink.Amount_13)*AccAss.Amount/(Admlink.Amount-Admlink.Amount_11-Admlink.Amount_12-(Admlink.Amount_13+Admlink.Amount_17+Admlink.Amount_18)-Admlink.Amount_14) 
Else 0 end
)as VAT,        
sum(Case When coalesce((Admlink.Amount-Admlink.Amount_11-Admlink.Amount_12-(Admlink.Amount_13+Admlink.Amount_17+Admlink.Amount_18)-Admlink.Amount_14),0)<>0 then (Admlink.Amount_17)*AccAss.Amount/(Admlink.Amount-Admlink.Amount_11-Admlink.Amount_12-(Admlink.Amount_13+Admlink.Amount_17+Admlink.Amount_18)-Admlink.Amount_14) else 0 end)as VAT_1,        
sum(Case When coalesce((Admlink.Amount-Admlink.Amount_11-Admlink.Amount_12-(Admlink.Amount_13+Admlink.Amount_17+Admlink.Amount_18)-Admlink.Amount_14),0)<>0 then (Admlink.Amount_18)*AccAss.Amount/(Admlink.Amount-Admlink.Amount_11-Admlink.Amount_12-(Admlink.Amount_13+Admlink.Amount_17+Admlink.Amount_18)-Admlink.Amount_14) else 0 end)as VAT_2,        
sum(
Case 
When Admlink.Amount is null then
	-(Case When AccAss.Code<>'C' or charindex(AccAss.Type,'FOFPQSQPS1S2S3AF')=0 then AccAss.Amount Else 0 end)
	*(Case When Profile.TaxF=1 Then (Case When TaxType.MTaxType='PASAL21' Then (100-MParam.TaxDiscount)/100 Else 1 end) Else 0 End)
	*(Case 
		When TaxType.MTaxType='PASAL21' Then MParam.PASAL21/100*Case When coalesce(Profile.TaxPCT,0)=0 then 1 else Profile.TaxPCT/100 end
		When TaxType.MTaxType='PASAL23' Then MParam.PASAL23/100*Case When coalesce(Profile.TaxPCT,0)=0 then 1 else Profile.TaxPCT/100 end
		When TaxType.MTaxType='PASAL26' Then MParam.PASAL26/100*Case When coalesce(Profile.TaxPCT,0)=0 then 1 else Profile.TaxPCT/100 end
		ELSE 0
	  END)
When coalesce((Admlink.Amount-Admlink.Amount_11-Admlink.Amount_12-(Admlink.Amount_13+Admlink.Amount_17+Admlink.Amount_18)-Admlink.Amount_14),0)<>0 then 
	Admlink.Amount_14*AccAss.Amount/(Admlink.Amount-Admlink.Amount_11-Admlink.Amount_12-(Admlink.Amount_13+Admlink.Amount_17+Admlink.Amount_18)-Admlink.Amount_14) 
Else 0 end
)as TAX    
FROM AccAss 
Inner Join Acceptance on (Acceptance.ANO=AccAss.ANO)
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
WHERE Acceptance.ANO=@P_ANO        
GROUP BY AccAss.ID, Profile.Name, AccAss.Type, AccAss.Posted, AccAss.Admno, AccAss.Currency, Acceptance.RegNo, Accass.DocNo, AccAss.RefNo,      
Case When AccAss.CAmount=0 and Coalesce(pAcceptance.Branch,'')<>'' Then pAcceptance.Branch Else Acceptance.Branch end,   
dbo.fn_Get_UWYear(Acceptance.SDate, Acceptance.EDate, Case When (Case When isnull(APayor.ANO,0)=0 Then (Case When isnull(MPayor.ANO,0)=0 Then Payor.PolicyYearF else MPayor.PolicyYearF end) else APayor.PolicyYearF end)=1 Then AccAss.SDate else Acceptance.SDate end) 

GO

DROP PROCEDURE View07A 
GO
CREATE PROCEDURE View07A (@p_ANo as integer)              
AS              
SELECT AccAss.ID, Profile.Name, AccAss.Type, AccAss.Posted, AccAss.Admno, AccAss.Currency, Acceptance.RegNo, Accass.DocNo, AccAss.RefNo,      
Case When AccAss.CAmount=0 and Coalesce(pAcceptance.Branch,'')<>'' Then pAcceptance.Branch Else Acceptance.Branch end Branch,   
dbo.fn_Get_UWYear(MAcceptance.SDate, MAcceptance.EDate, Case When (Case When isnull(APayor.ANO,0)=0 Then (Case When isnull(MPayor.ANO,0)=0 Then Payor.PolicyYearF else MPayor.PolicyYearF end) else APayor.PolicyYearF end)=1 Then AccAss.SDate else Acceptance.SDate end) as PolicyYear,
(Case When isnull(APayor.ANO,0)=0 Then (Case When isnull(MPayor.ANO,0)=0 Then Payor.Grace else MPayor.Grace end) else APayor.Grace end) as Grace,
sum(                
 case                
  when (accass.type in ('IR','IT','IX') and accass.code in ('P','U','F')) or (accass.type in ('DI','IC') and accass.code in ('P','U')) or (AccAss.Type not in ('DI','IC','IR','IT','IX') and AccAss.Code='P') then AccAss.Amount                
  else 0                
 end                
) AS Premium,                 
sum(                
 case                 
  when accass.code='C' and coalesce(accass.codeext,'')='' then AccAss.Amount                
  else 0                
 end                
) AS Commision,                 
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
  when accass.type not in ('CP','DC','XP','QS','QP','S1','S2','S3','AF','FO') and accass.code='O' then AccAss.Amount                
  else 0                
 end                
) AS Discount,                 
sum(                
 case                 
  when accass.type in ('CP','DC','XP','QS','QP','S1','S2','S3','AF','FO') and accass.code='O' and coalesce(accass.CodeExt,'')='' then AccAss.Amount                
  else 0                
 end                
) AS Acquisition,   
sum(                
 case                 
  when accass.type in ('CP','DC','XP','QS','QP','S1','S2','S3','AF','FO') and accass.code='O' and coalesce(accass.CodeExt,'')='1' then AccAss.Amount                
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
  when accass.type not in ('CP','DC','XP','QS','QP','S1','S2','S3','AF','FO') and accass.code='J' then AccAss.Amount                
  else 0                
 end                
) AS Deposit,         
sum(                
 case                 
  when accass.type in ('CP','DC','XP','QS','QP','S1','S2','S3','AF','FO') and accass.code='J' then AccAss.Amount                
  else 0                
 end                
) AS Advance,                  
sum(Case When coalesce((Admlink.Amount-Admlink.Amount_11-Admlink.Amount_12-(Admlink.Amount_13+Admlink.Amount_17+Admlink.Amount_18)-Admlink.Amount_14),0)<>0 then Admlink.Amount_11*AccAss.Amount/(Admlink.Amount-Admlink.Amount_11-Admlink.Amount_12-(Admlink.Amount_13+Admlink.Amount_17+Admlink.Amount_18)-Admlink.Amount_14) else 0 end) as Rounding,        
sum(
Case 
When Admlink.Amount is null then
	AccAss.Amount
	*(Case When Profile.VATF=1 Then 1 Else 0 End)
	*(MParam.VAT/100)
	*(Case When SysTab.TaxMethod=0 or (Accass.Type in ('CP','DC','QS','QP','S1','S2','S3','AF','XP','FO','FP','IR','IX') and AccAss.Code='C') or (Accass.Type Not in ('CP','DC','QS','QP','S1','S2','S3','AF','XP','FO','FP','IR','IX') and AccAss.Code Not in ('F','D')) Then 1 else 0 end)
When coalesce((Admlink.Amount-Admlink.Amount_11-Admlink.Amount_12-(Admlink.Amount_13+Admlink.Amount_17+Admlink.Amount_18)-Admlink.Amount_14),0)<>0 then 
	(Admlink.Amount_13)*AccAss.Amount/(Admlink.Amount-Admlink.Amount_11-Admlink.Amount_12-(Admlink.Amount_13+Admlink.Amount_17+Admlink.Amount_18)-Admlink.Amount_14) 
Else 0 end
)as VAT,        
sum(Case When coalesce((Admlink.Amount-Admlink.Amount_11-Admlink.Amount_12-(Admlink.Amount_13+Admlink.Amount_17+Admlink.Amount_18)-Admlink.Amount_14),0)<>0 then (Admlink.Amount_17)*AccAss.Amount/(Admlink.Amount-Admlink.Amount_11-Admlink.Amount_12-(Admlink.Amount_13+Admlink.Amount_17+Admlink.Amount_18)-Admlink.Amount_14) else 0 end)as VAT_1,        
sum(Case When coalesce((Admlink.Amount-Admlink.Amount_11-Admlink.Amount_12-(Admlink.Amount_13+Admlink.Amount_17+Admlink.Amount_18)-Admlink.Amount_14),0)<>0 then (Admlink.Amount_18)*AccAss.Amount/(Admlink.Amount-Admlink.Amount_11-Admlink.Amount_12-(Admlink.Amount_13+Admlink.Amount_17+Admlink.Amount_18)-Admlink.Amount_14) else 0 end)as VAT_2,        
sum(
Case 
When Admlink.Amount is null then
	-(Case When AccAss.Code<>'C' or charindex(AccAss.Type,'FOFPQSQPS1S2S3AF')=0 then AccAss.Amount Else 0 end)
	*(Case When Profile.TaxF=1 Then (Case When TaxType.MTaxType='PASAL21' Then (100-MParam.TaxDiscount)/100 Else 1 end) Else 0 End)
	*(Case 
		When TaxType.MTaxType='PASAL21' Then MParam.PASAL21/100*Case When coalesce(Profile.TaxPCT,0)=0 then 1 else Profile.TaxPCT/100 end
		When TaxType.MTaxType='PASAL23' Then MParam.PASAL23/100*Case When coalesce(Profile.TaxPCT,0)=0 then 1 else Profile.TaxPCT/100 end
		When TaxType.MTaxType='PASAL26' Then MParam.PASAL26/100*Case When coalesce(Profile.TaxPCT,0)=0 then 1 else Profile.TaxPCT/100 end
		ELSE 0
	  END)
When coalesce((Admlink.Amount-Admlink.Amount_11-Admlink.Amount_12-(Admlink.Amount_13+Admlink.Amount_17+Admlink.Amount_18)-Admlink.Amount_14),0)<>0 then 
	Admlink.Amount_14*AccAss.Amount/(Admlink.Amount-Admlink.Amount_11-Admlink.Amount_12-(Admlink.Amount_13+Admlink.Amount_17+Admlink.Amount_18)-Admlink.Amount_14) 
Else 0 end
)as TAX    
FROM AccAss 
Inner Join Acceptance on (Acceptance.ANO=AccAss.ANO)
Left Join APayor on (APayor.ANO=Acceptance.ANO and Acceptance.LANO<>-1 and Acceptance.ANO<>Acceptance.LANO)                              
Left Join Payor on (Payor.ANO=Acceptance.ANO and Acceptance.LANO=-1)              
Left Join Acceptance pAcceptance on (pAcceptance.ANO=Acceptance.pANO)
Left Join Admlink on (Admlink.AdmNo=AccAss.AdmNo)
Inner Join Profile on (Profile.ID=AccAss.ID)
Left Join TaxType on (TaxType.TaxType=Profile.TaxType)
Inner Join Mparam on (MParam.Type=AccAss.Type)
Inner Join Acceptance mAcceptance on (((Acceptance.RegNo<>'' and Acceptance.RegNo=mAcceptance.RegNo) or (Acceptance.RegNo='' and Acceptance.LANO=MAcceptance.ANO)) and MAcceptance.ANO=MAcceptance.LANO and MAcceptance.CNO=Acceptance.CNO)
Left Join Payor MPayor on (MPayor.ANO=mAcceptance.ANO)      
Inner Join SysTab on (1=1)
WHERE MAcceptance.ANO=@P_ANO        
GROUP BY AccAss.ID, Profile.Name, AccAss.Type, AccAss.Posted, AccAss.Admno, AccAss.Currency, Acceptance.RegNo, Accass.DocNo, AccAss.RefNo,      
Case When AccAss.CAmount=0 and Coalesce(pAcceptance.Branch,'')<>'' Then pAcceptance.Branch Else Acceptance.Branch end,   
dbo.fn_Get_UWYear(MAcceptance.SDate, MAcceptance.EDate, Case When (Case When isnull(APayor.ANO,0)=0 Then (Case When isnull(MPayor.ANO,0)=0 Then Payor.PolicyYearF else MPayor.PolicyYearF end) else APayor.PolicyYearF end)=1 Then AccAss.SDate else Acceptance.SDate end),
(Case When isnull(APayor.ANO,0)=0 Then (Case When isnull(MPayor.ANO,0)=0 Then Payor.Grace else MPayor.Grace end) else APayor.Grace end)

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
sum(VAT) as VAT,
sum(TAX) as TAX,
Sum(FeeDuty) as FeeDuty      
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
                                 
	select A1.ANO, AccAss.Code, AccAss.SDate, AccAss.EDate, AccAss.Currency_OC as Currency,                  
	sum(Case When AccAss.Code in ('P','U') then (Case When A1.AType='A' and AccAss.AdjMethod='OVERLIMIT' then -AccAss.CAmount*(Case When A1.CPCT<>0 Then A1.CPCT/100 else 1 end)/(Case When AccAss.PProrata<>0 Then AccAss.PProrata else 1 end) else -AccAss.Amount_OC end)*(Case When AccAss.Type='DI' then 100/(100-coalesce(Coinsurance.MShare,0)) else 1 end) else 0 end) as Premium,                  
	sum(Case When AccAss.Code='C' then (Case When A1.AType='A' and AccAss.AdjMethod='OVERLIMIT' then AccAss.CAmount*(Case When A1.CPCT<>0 Then A1.CPCT/100 else 1 end)/(Case When AccAss.PProrata<>0 Then AccAss.PProrata else 1 end) else AccAss.Amount_OC end)*(Case When AccAss.Type='DI' then 100/(100-coalesce(Coinsurance.MShare,0)) else 1 end) else 0 end) as Commission,                  
	sum(Case When AccAss.Code='O' then (Case When A1.AType='A' and AccAss.AdjMethod='OVERLIMIT' then AccAss.CAmount*(Case When A1.CPCT<>0 Then A1.CPCT/100 else 1 end)/(Case When AccAss.PProrata<>0 Then AccAss.PProrata else 1 end) else AccAss.Amount_OC end)*(Case When AccAss.Type='DI' then 100/(100-coalesce(Coinsurance.MShare,0)) else 1 end) else 0 end) as Discount,                  
	sum((Case When A1.AType='A' and AccAss.AdjMethod='OVERLIMIT' then AccAss.CAmount*(Case When A1.CPCT<>0 Then A1.CPCT/100 else 1 end)/(Case When AccAss.PProrata<>0 Then AccAss.PProrata else 1 end) else AccAss.Amount_OC end)*(Case When AccAss.Type='DI' then 100/(100-coalesce(Coinsurance.MShare,0)) else 1 end)*(Case When Profile.VatF=1 Then MParam.Vat/100 else 0 end)) as Vat,                  
	sum((Case When A1.AType='A' and AccAss.AdjMethod='OVERLIMIT' then AccAss.CAmount*(Case When A1.CPCT<>0 Then A1.CPCT/100 else 1 end)/(Case When AccAss.PProrata<>0 Then AccAss.PProrata else 1 end) else AccAss.Amount_OC end)*(Case When AccAss.Type='DI' then 100/(100-coalesce(Coinsurance.MShare,0)) else 1 end)*(Case When Profile.TaxF=1 Then (Case When Profile.TaxType='PASAL21' Then MParam.Pasal21/100*(100-MParam.TaxDiscount)/100 When Profile.TaxType='PASAL23' Then MParam.Pasal23/100 When Profile.TaxType='PASAL26' Then MParam.Pasal26/100 else 0 end)*(Case When Profile.TaxPCT=0 Then 1 else Profile.TaxPCT/100 end) else 0 end)) as Tax,      
	sum(Case When AccAss.Code in ('F','D') then -AccAss.Amount_OC else 0 end) as FeeDuty      
	from Acceptance A1       
	inner join Acceptance A2 on (A2.OANO=A1.OANO)    
	inner join AccAss on (AccAss.ANO=A2.ANO)      
	inner join Profile on (Profile.ID=AccAss.ID)      
	inner join MParam on (MParam.Type=Accass.Type)      
	Left Join (Select CNO, sum(Share) as MShare from Coinsurance Where PCollectionF=0 Group by CNO) Coinsurance on (Coinsurance.CNO=A2.CNO)      
	Left join Acceptance pA1 on (pA1.ANO=A2.PANO)      
	Where A1.ANO=@P_ANO     
	and (                  
	(A2.ANO<=A1.PANO AND A2.ANO<@P_ANO AND A1.PDate<=A2.PDate and A1.PPDate>=A2.PPDate and A1.AType='A' and (A2.AType<>'A' and coalesce(pA1.AType,'')<>'A') and AccAss.AdjustableF=1 and (AccAss.AdjMethod<>'OVERLIMIT' or AccAss.CAmount<>0) and NOT EXISTS (Select PANO from Acceptance A3 Where A3.PANO=A2.ANO and A3.AStatus<>'C' and A3.AType='A' and A3.ANO<>@P_ANO))                  
	or (A2.ANO<@P_ANO AND A1.AType='C' and A1.EMethod='A' and A2.PDate>=A1.PDate and (coalesce(pA1.pDate,A2.PDate)>=A1.PDate or A2.ATYPE='A' or (coalesce(pA1.pDate,A2.PDate)<A1.PDate and AccAss.CAmount<>0)))                  
	or (A2.ANO=A1.PANO and A2.AType='A' and A1.AType='C'))                  
	and ((AccAss.Type in ('DI','IC','IR') and AccAss.Code='P') or (AccAss.Type in ('DI','IC') and AccAss.Code='U') Or (AccAss.Type in ('BB','BA','BO') and AccAss.Code='C') or (AccAss.Type in ('DI','IC','IR') and AccAss.Code='O') or (A1.AType='C' and A1.EMethod='A' and AccAss.Type in ('DI') and AccAss.Code in ('F','D')))                  
	Group By A1.ANO, AccAss.Code, AccAss.SDate, AccAss.EDate, AccAss.Currency_OC                                                                             
) T          
Group by ANO, Currency


)           
        
GO


DROP PROCEDURE View05L1 
GO
CREATE PROCEDURE View05L1 (@p_ANO as integer)    
AS    

Select ANO, Currency, sum(Rate) as Rate, sum(TSI) as TSI, sum(OurShare) as OurShare, sum(Gross) as Gross, sum(CRate) as CRate, sum(Premium) as Premium, sum(Discount) as Discount, sum(Commission) as Commission, sum(Vat) as Vat, sum(Tax) as Tax, sum(FeeDuty) as FeeDuty    
      
From    
(    
SELECT @P_ANO as ANO, P2.Currency, max(coalesce(P1.Rate,0)) as Rate, max(coalesce(P1.TSI,0)) as TSI, max(coalesce(P1.OurShare,0)) as OurShare, Max(coalesce(P1.Gross,0)) as Gross, max(coalesce(P1.CRate,0)) as CRate, sum(P2.Premium) as Premium, sum(P2.Discount) as Discount, sum(P2.Commission) as Commission, sum(P2.Vat) as Vat, sum(P2.Tax) as Tax, sum(P2.FeeDuty) as FeeDuty   
FROM PREMIUM_CALCULATION(@P_ANO) P2 Left Join PCalc P1 On (P2.ANO=P1.ANO and P2.Currency=P1.Currency)    
Group By P2.Currency    
                     
Union All          

Select @P_ANO as ANO, AccFD.Currency, 0 as Rate, 0 as TSI, 0 as OurShare, 0 as Gross, 0 as CRate, 0 as Premium, 0 as Discount, 0 as Commission, 0 as Vat, 0 as Tax, 
Case 
When FDTab.FDType<>'O' Then (ACCFD.Amount)
Else -(ACCFD.Amount) End as FeeDuty
from Acceptance A, PCalc P, AccFD, FDTab
Where AccFD.ANO=@P_ANO and A.ANO=AccFD.ANO and P.ANO=AccFD.ANO and P.Currency=AccFD.Currency and FDTab.FDID=AccFD.FDID
and AccFD.Amount<>0

Union All

Select @P_ANO as ANO, AccFD.Currency, 0 as Rate, 0 as TSI, 0 as OurShare, 0 as Gross, 0 as CRate, 0 as Premium, 0 as Discount, 0 as Commission, 0 as Vat, 0 as Tax, 
sum(
Case 
When FDTab.FDType<>'O' Then 
	  (D1.Gross*(100-D1.Discount)/100*D1.Prorata*P.Gross/P.OGross*P.OurShare/P.TSI*AccFD.AmountPCT/100)
Else
      -(D1.Gross*D1.Prorata*P.Gross/P.OGross*P.OurShare/P.TSI*(100-R.MSHARE)/100*AccFD.AmountPCT/100) 		  
End 
) as FeeDuty
from Display_Calculation(@P_ANO) D1, Acceptance A, PCalc P, AccFD, FDTab, RArrHeader R
Where AccFD.ANO=@P_ANO and P.ANO=D1.ANO and P.Currency=D1.Currency and A.ANO=D1.ANO and R.ANO=A.ANO
and AccFD.Currency=D1.Currency and FDTab.FDID=AccFD.FDID
and AccFD.Amount=0 and AccFd.AMOUNTPCTBASED=0
Group by ACCFD.Currency

Union All

Select @P_ANO as ANO, AccFD.Currency, 0 as Rate, 0 as TSI, 0 as OurShare, 0 as Gross, 0 as CRate, 0 as Premium, 0 as Discount, 0 as Commission, 0 as Vat, 0 as Tax, 
sum(
Case 
When FDTab.FDType<>'O' Then 
	(coalesce(P.OurShare,0)-coalesce(PP.OurShare,0))*AccFD.AmountPCT/100
Else
	-coalesce(P.OurShare*(100-R.MSHARE)/100,0)-coalesce(PP.OurShare*(100-PR.MSHARE)/100,0)*AccFD.AmountPCT/100
End
) as FeeDuty
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
and AccFD.Amount=0 and AccFd.AMOUNTPCTBASED<>0
Group by ACCFD.Currency

) P    
Group By ANO, Currency    
