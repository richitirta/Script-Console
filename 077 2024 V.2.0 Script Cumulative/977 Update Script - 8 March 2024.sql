IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'UseTaxTypeF' AND Object_ID = Object_ID(N'MParam'))
BEGIN

SET QUOTED_IDENTIFIER ON
SET ARITHABORT ON
SET NUMERIC_ROUNDABORT OFF
SET CONCAT_NULL_YIELDS_NULL ON
SET ANSI_NULLS ON
SET ANSI_PADDING ON
SET ANSI_WARNINGS ON


ALTER TABLE dbo.MParam ADD
	UseTaxTypeF bit NULL
DECLARE @v sql_variant 
SET @v = N'Use TaxType Table (0 : No, 1 : Yes)'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'MParam', N'COLUMN', N'UseTaxTypeF'
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
 *(Case When Profile.VatF=1 Then 1 else 0 end)  
 *(Case  
  When SysTab.TaxMethod in (0) Then  
   Case When ((AccAss.Type in ('BB','BA','BC','BP','BD') and AccAss.Code in ('C','P')) or (AccAss.Type in ('OP')) or (AccAss.Type not in ('BB','BA','BC','BP','BD','OP') and AccAss.Code not in ('F','D'))) then 1 Else 0 End  
  When SysTab.TaxMethod in (3) Then  
   Case When ((AccAss.Type in ('BB','BA','BC','BP','BD') and AccAss.Code in ('C','P') and RateTab.VatCommissionF=1) or (AccAss.Type in ('OP')) or (AccAss.Type not in ('BB','BA','BC','BP','BD','OP') and AccAss.Code not in ('F','D'))) then 1 Else 0 End  
  else  
   Case When ((AccAss.Type in ('CP','DC','QS','QP','S1','S2','S3','AF','XP','FO','FP','IR','IT','IX') and AccAss.Code in ('C')) or (AccAss.Type in ('BB','BA','BC','BP','BD') and AccAss.Code in ('C','P')) or (AccAss.Type in ('OP')) or (AccAss.Type not in ('CP','DC','QS','QP','S1','S2','S3','AF','XP','FO','FP','IR','IT','IX','BB','BA','BC','BP','BD','OP') and AccAss.Code not in ('F','D'))) then 1 Else 0 End     
  end)  
 *(Case   
  When SysTab.TaxMethod in (0,3) Then  
   Case When ((AccAss.Type in ('BB','BA','BC','BP','BD','OP')) or ((AccAss.Type not in ('BB','BA','BC','BP','BD','OP','DI','IC','CF','JP','BO') and TOC.VATBusinessF=1) or (Insured.VATF=1 and TOC.VATBusinessF=1))) Then 1 Else 0 End  
  Else  
   Case When ((AccAss.Type in ('BB','BA','BC','BP','BD','OP')) or ((AccAss.Type not in ('BB','BA','BC','BP','BD','OP','DI','IC','CF','JP','BO')) or (Insured.VATF=1 and TOC.VATBusinessF=1))) Then 1 Else 0 End  
  End)  
 *(Case When Acceptance.NoRefundF=7 and AccAss.Type in ('BB','BA','BO','BC','BP','BD') and AccAss.Code in ('C','O') then 0 else 1 end)  
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
 *(Case When Profile.VatF=1 Then 1 else 0 end)  
 *(Case  
  When SysTab.TaxMethod in (0) Then  
   Case When ((AccAss.Type in ('BB','BA','BC','BP','BD') and AccAss.Code in ('C','P')) or (AccAss.Type in ('OP')) or (AccAss.Type not in ('BB','BA','BC','BP','BD','OP') and AccAss.Code not in ('F','D'))) then 1 Else 0 End  
  When SysTab.TaxMethod in (3) Then  
   Case When ((AccAss.Type in ('BB','BA','BC','BP','BD') and AccAss.Code in ('C','P') and RateTab.VatCommissionF=1) or (AccAss.Type in ('OP')) or (AccAss.Type not in ('BB','BA','BC','BP','BD','OP') and AccAss.Code not in ('F','D'))) then 1 Else 0 End  
  else  
   Case When ((AccAss.Type in ('CP','DC','QS','QP','S1','S2','S3','AF','XP','FO','FP','IR','IT','IX') and AccAss.Code in ('C')) or (AccAss.Type in ('BB','BA','BC','BP','BD') and AccAss.Code in ('C','P')) or (AccAss.Type in ('OP')) or (AccAss.Type not in ('CP','DC','QS','QP','S1','S2','S3','AF','XP','FO','FP','IR','IT','IX','BB','BA','BC','BP','BD','OP') and AccAss.Code not in ('F','D'))) then 1 Else 0 End     
  end)  
 *(Case   
  When SysTab.TaxMethod in (0,3) Then  
   Case When ((AccAss.Type in ('BB','BA','BC','BP','BD','OP')) or ((AccAss.Type not in ('BB','BA','BC','BP','BD','OP','DI','IC','CF','JP','BO') and TOC.VATBusinessF=1) or (Insured.VATF=1 and TOC.VATBusinessF=1))) Then 1 Else 0 End  
  Else  
   Case When ((AccAss.Type in ('BB','BA','BC','BP','BD','OP')) or ((AccAss.Type not in ('BB','BA','BC','BP','BD','OP','DI','IC','CF','JP','BO')) or (Insured.VATF=1 and TOC.VATBusinessF=1))) Then 1 Else 0 End  
  End)  
 *(Case When Acceptance.NoRefundF=7 and AccAss.Type in ('BB','BA','BO','BC','BP','BD') and AccAss.Code in ('C','O') then 0 else 1 end)  
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
 *(Case When SysTab.TaxMethod=0 or (Accass.Type in ('CP','DC','QS','QP','S1','S2','S3','AF','XP','FO','FP','IR','IX') and AccAss.Code='C') or (AccAss.Type in ('OP')) or (Accass.Type Not in ('CP','DC','QS','QP','S1','S2','S3','AF','XP','FO','FP','IR','IX')
 and AccAss.Code Not in ('F','D')) Then 1 else 0 end)  
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
 Case when Max(AccAss.Type) in ('DI','IC','CF','JP','BO') Then    
  Case   
  When Max(SysTab.TaxMethod)=2 then  
   dbo.roundccy(  
   sum(  
   AccAss.Amount*Case When (AccAss.Type in ('DI','IC') and Accass.Code in ('P','O','U')) or (AccAss.Type in ('CF','JP') and AccAss.Code in ('P','O')) or (AccAss.Type in ('BO')) Then 1 else 0 end     
   *coalesce(RateCov.Portion,0)/coalesce(pRCover.Portion, RCover.Portion)  
   )  
   ,Accass.Currency)  
  When Max(SysTab.TaxMethod)=3 then  
   dbo.roundccy(  
   sum(  
   AccAss.Amount*Case When (AccAss.Type in ('DI','IC') and Accass.Code in ('P','O','U')) or (AccAss.Type in ('CF','JP') and AccAss.Code in ('P','O')) or (AccAss.Type in ('BO')) Then 1 else 0 end     
   *case When RateTab.VATF=1 and RateTab.VATEXEMPTF=0 then 1 else 0 end  
   )  
   ,Accass.Currency)  
  Else  
   dbo.roundccy(  
   sum(  
   AccAss.Amount  
   *(Case When SysTab.TaxMethod=0 or (Accass.Type in ('CP','DC','QS','QP','S1','S2','S3','AF','XP','FO','FP','IR','IX') and AccAss.Code='C') or (AccAss.Type in ('OP')) or (Accass.Type Not in ('CP','DC','QS','QP','S1','S2','S3','AF','XP','FO','FP','IR','IX
') and AccAss.Code Not in ('F','D')) Then 1 else 0 end)  
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
Left Join RateTab on (RateTab.Code=AccAss.RCode)  
Left Join RCover on (RCover.ANO=Acceptance.ANO and RCover.Code=AccAss.RCode and RCover.SDate=AccAss.SDate)  
Left Join RCover pRCover on (AccAss.CAmount=0 and pRCover.ANO=Acceptance.pANO and pRCover.Code=AccAss.RCode and pRCover.SDate=AccAss.SDate)  
Outer apply (Select sum(RateCov.Portion) as Portion from RateCov Where RateCov.Code=AccAss.RCode and RateCov.VatF=1) as RateCov  
WHERE Acceptance.ANO=@P_ANO          
GROUP BY AccAss.ID, Profile.Name, AccAss.Type, AccAss.Posted, AccAss.Admno, AccAss.Currency, Acceptance.RegNo, Accass.DocNo, AccAss.RefNo,        
Case When AccAss.CAmount=0 and Coalesce(pAcceptance.Branch,'')<>'' Then pAcceptance.Branch Else Acceptance.Branch end,   dbo.fn_Get_UWYear(Acceptance.SDate, Acceptance.EDate, Case When (Case When isnull(APayor.ANO,0)=0 Then (Case When isnull(MPayor.ANO,0)=0 Then Payor.PolicyYearF else MPayor.PolicyYearF end) else APayor.PolicyYearF end)=1 Then AccAss.SDate else Acceptance.SDate end)   
  
GO

DROP PROCEDURE View07A 
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
  
Declare @View07 Table (ID varchar(10), Name varchar(255), Type varchar(10), Posted Bit, AdmNo Int, Currency varchar(10), RegNo varchar(50), DocNo varchar(50), RefNo varchar(50), Branch varchar(10), PolicyYear Int, Grace Int, Premium Float, Commision Float, OverridingCommission Float, Fee Float, Duty Float, Discount Float, Acquisition Float, PremiumAdjustment Float, OtherIncome Float, Ujroh Float, Tabarru Float, Deposit Float, Advance Float, Rounding Float, VAT Float, VATSubsidies Float, VAT_1 Float, VAT_2 Float, TAX Float)  
  
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
  *(Case When Profile.VatF=1 Then 1 else 0 end)  
  *(Case  
   When SysTab.TaxMethod in (0) Then  
    Case When ((AccAss.Type in ('BB','BA','BC','BP','BD') and AccAss.Code in ('C','P')) or (AccAss.Type in ('OP')) or (AccAss.Type not in ('BB','BA','BC','BP','BD','OP') and AccAss.Code not in ('F','D'))) then 1 Else 0 End  
   When SysTab.TaxMethod in (3) Then  
    Case When ((AccAss.Type in ('BB','BA','BC','BP','BD') and AccAss.Code in ('C','P') and RateTab.VatCommissionF=1) or (AccAss.Type in ('OP')) or (AccAss.Type not in ('BB','BA','BC','BP','BD','OP') and AccAss.Code not in ('F','D'))) then 1 Else 0 End  
   else  
    Case When ((AccAss.Type in ('CP','DC','QS','QP','S1','S2','S3','AF','XP','FO','FP','IR','IT','IX') and AccAss.Code in ('C')) or (AccAss.Type in ('BB','BA','BC','BP','BD') and AccAss.Code in ('C','P')) or (AccAss.Type in ('OP')) or (AccAss.Type not in ('CP','DC','QS','QP','S1','S2','S3','AF','XP','FO','FP','IR','IT','IX','BB','BA','BC','BP','BD','OP') and AccAss.Code not in ('F','D'))) then 1 Else 0 End     
   end)  
  *(Case   
   When SysTab.TaxMethod in (0,3) Then  
    Case When ((AccAss.Type in ('BB','BA','BC','BP','BD','OP')) or ((AccAss.Type not in ('BB','BA','BC','BP','BD','OP','DI','IC','CF','JP','BO') and TOC.VATBusinessF=1) or (Insured.VATF=1 and TOC.VATBusinessF=1))) Then 1 Else 0 End  
   Else  
    Case When ((AccAss.Type in ('BB','BA','BC','BP','BD','OP')) or ((AccAss.Type not in ('BB','BA','BC','BP','BD','OP','DI','IC','CF','JP','BO')) or (Insured.VATF=1 and TOC.VATBusinessF=1))) Then 1 Else 0 End  
   End)  
  *(Case When Acceptance.NoRefundF=7 and AccAss.Type in ('BB','BA','BO','BC','BP','BD') and AccAss.Code in ('C','O') then 0 else 1 end)  
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
  *(Case When Profile.VatF=1 Then 1 else 0 end)  
  *(Case  
   When SysTab.TaxMethod in (0) Then  
    Case When ((AccAss.Type in ('BB','BA','BC','BP','BD') and AccAss.Code in ('C','P')) or (AccAss.Type in ('OP')) or (AccAss.Type not in ('BB','BA','BC','BP','BD','OP') and AccAss.Code not in ('F','D'))) then 1 Else 0 End  
   When SysTab.TaxMethod in (3) Then  
    Case When ((AccAss.Type in ('BB','BA','BC','BP','BD') and AccAss.Code in ('C','P') and RateTab.VatCommissionF=1) or (AccAss.Type in ('OP')) or (AccAss.Type not in ('BB','BA','BC','BP','BD','OP') and AccAss.Code not in ('F','D'))) then 1 Else 0 End  
   else  
    Case When ((AccAss.Type in ('CP','DC','QS','QP','S1','S2','S3','AF','XP','FO','FP','IR','IT','IX') and AccAss.Code in ('C')) or (AccAss.Type in ('BB','BA','BC','BP','BD') and AccAss.Code in ('C','P')) or (AccAss.Type in ('OP')) or (AccAss.Type not in ('CP','DC','QS','QP','S1','S2','S3','AF','XP','FO','FP','IR','IT','IX','BB','BA','BC','BP','BD','OP') and AccAss.Code not in ('F','D'))) then 1 Else 0 End     
   end)  
  *(Case   
   When SysTab.TaxMethod in (0,3) Then  
    Case When ((AccAss.Type in ('BB','BA','BC','BP','BD','OP')) or ((AccAss.Type not in ('BB','BA','BC','BP','BD','OP','DI','IC','CF','JP','BO') and TOC.VATBusinessF=1) or (Insured.VATF=1 and TOC.VATBusinessF=1))) Then 1 Else 0 End  
   Else  
    Case When ((AccAss.Type in ('BB','BA','BC','BP','BD','OP')) or ((AccAss.Type not in ('BB','BA','BC','BP','BD','OP','DI','IC','CF','JP','BO')) or (Insured.VATF=1 and TOC.VATBusinessF=1))) Then 1 Else 0 End  
   End)  
  *(Case When Acceptance.NoRefundF=7 and AccAss.Type in ('BB','BA','BO','BC','BP','BD') and AccAss.Code in ('C','O') then 0 else 1 end)  
  *(Case When Acceptance.NoRefundF in (8,10,14) then 0 else 1 end)  
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
  *(Case When SysTab.TaxMethod=0 or (Accass.Type in ('CP','DC','QS','QP','S1','S2','S3','AF','XP','FO','FP','IR','IX') and AccAss.Code='C') or (AccAss.Type in ('OP')) or (Accass.Type Not in ('CP','DC','QS','QP','S1','S2','S3','AF','XP','FO','FP','IR','IX'
) and AccAss.Code Not in ('F','D')) Then 1 else 0 end)  
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
  Case when Max(AccAss.Type) in ('DI','IC','CF','JP','BO') Then    
   Case   
   When Max(SysTab.TaxMethod)=2 then  
    dbo.roundccy(  
    sum(  
    AccAss.Amount*Case When (AccAss.Type in ('DI','IC') and Accass.Code in ('P','O','U')) or (AccAss.Type in ('CF','JP') and AccAss.Code in ('P','O')) or (AccAss.Type in ('BO')) Then 1 else 0 end     
    *coalesce(RateCov.Portion,0)/coalesce(pRCover.Portion, RCover.Portion)  
    )  
    ,Accass.Currency)  
   When Max(SysTab.TaxMethod)=3 then  
    dbo.roundccy(  
    sum(  
    AccAss.Amount*Case When (AccAss.Type in ('DI','IC') and Accass.Code in ('P','O','U')) or (AccAss.Type in ('CF','JP') and AccAss.Code in ('P','O')) or (AccAss.Type in ('BO')) Then 1 else 0 end     
    *case When RateTab.VATF=1 and RateTab.VATEXEMPTF=0 then 1 else 0 end  
    )  
    ,Accass.Currency)  
   Else  
    dbo.roundccy(  
    sum(  
    AccAss.Amount  
    *(Case When SysTab.TaxMethod=0 or (Accass.Type in ('CP','DC','QS','QP','S1','S2','S3','AF','XP','FO','FP','IR','IX') and AccAss.Code='C') or (AccAss.Type in ('OP')) or (Accass.Type Not in ('CP','DC','QS','QP','S1','S2','S3','AF','XP','FO','FP','IR','IX') and AccAss.Code Not in ('F','D')) Then 1 else 0 end)  
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
  *(Case When Profile.VatF=1 Then 1 else 0 end)  
  *(Case  
   When SysTab.TaxMethod in (0) Then  
    Case When ((AccAss.Type in ('BB','BA','BC','BP','BD') and AccAss.Code in ('C','P')) or (AccAss.Type in ('OP')) or (AccAss.Type not in ('BB','BA','BC','BP','BD','OP') and AccAss.Code not in ('F','D'))) then 1 Else 0 End  
   When SysTab.TaxMethod in (3) Then  
    Case When ((AccAss.Type in ('BB','BA','BC','BP','BD') and AccAss.Code in ('C','P') and RateTab.VatCommissionF=1) or (AccAss.Type in ('OP')) or (AccAss.Type not in ('BB','BA','BC','BP','BD','OP') and AccAss.Code not in ('F','D'))) then 1 Else 0 End  
   else  
    Case When ((AccAss.Type in ('CP','DC','QS','QP','S1','S2','S3','AF','XP','FO','FP','IR','IT','IX') and AccAss.Code in ('C')) or (AccAss.Type in ('BB','BA','BC','BP','BD') and AccAss.Code in ('C','P')) or (AccAss.Type in ('OP')) or (AccAss.Type not in ('CP','DC','QS','QP','S1','S2','S3','AF','XP','FO','FP','IR','IT','IX','BB','BA','BC','BP','BD','OP') and AccAss.Code not in ('F','D'))) then 1 Else 0 End     
   end)  
  *(Case   
   When SysTab.TaxMethod in (0,3) Then  
    Case When ((AccAss.Type in ('BB','BA','BC','BP','BD','OP')) or ((AccAss.Type not in ('BB','BA','BC','BP','BD','OP','DI','IC','CF','JP','BO') and TOC.VATBusinessF=1) or (Insured.VATF=1 and TOC.VATBusinessF=1))) Then 1 Else 0 End  
   Else  
    Case When ((AccAss.Type in ('BB','BA','BC','BP','BD','OP')) or ((AccAss.Type not in ('BB','BA','BC','BP','BD','OP','DI','IC','CF','JP','BO')) or (Insured.VATF=1 and TOC.VATBusinessF=1))) Then 1 Else 0 End  
   End)  
  *(Case When Acceptance.NoRefundF=7 and AccAss.Type in ('BB','BA','BO','BC','BP','BD') and AccAss.Code in ('C','O') then 0 else 1 end)  
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
  *(Case When Profile.VatF=1 Then 1 else 0 end)  
  *(Case  
   When SysTab.TaxMethod in (0) Then  
    Case When ((AccAss.Type in ('BB','BA','BC','BP','BD') and AccAss.Code in ('C','P')) or (AccAss.Type in ('OP')) or (AccAss.Type not in ('BB','BA','BC','BP','BD','OP') and AccAss.Code not in ('F','D'))) then 1 Else 0 End  
   When SysTab.TaxMethod in (3) Then  
    Case When ((AccAss.Type in ('BB','BA','BC','BP','BD') and AccAss.Code in ('C','P') and RateTab.VatCommissionF=1) or (AccAss.Type in ('OP')) or (AccAss.Type not in ('BB','BA','BC','BP','BD','OP') and AccAss.Code not in ('F','D'))) then 1 Else 0 End  
   else  
    Case When ((AccAss.Type in ('CP','DC','QS','QP','S1','S2','S3','AF','XP','FO','FP','IR','IT','IX') and AccAss.Code in ('C')) or (AccAss.Type in ('BB','BA','BC','BP','BD') and AccAss.Code in ('C','P')) or (AccAss.Type in ('OP')) or (AccAss.Type not in ('CP','DC','QS','QP','S1','S2','S3','AF','XP','FO','FP','IR','IT','IX','BB','BA','BC','BP','BD','OP') and AccAss.Code not in ('F','D'))) then 1 Else 0 End     
   end)  
  *(Case   
   When SysTab.TaxMethod in (0,3) Then  
    Case When ((AccAss.Type in ('BB','BA','BC','BP','BD','OP')) or ((AccAss.Type not in ('BB','BA','BC','BP','BD','OP','DI','IC','CF','JP','BO') and TOC.VATBusinessF=1) or (Insured.VATF=1 and TOC.VATBusinessF=1))) Then 1 Else 0 End  
   Else  
    Case When ((AccAss.Type in ('BB','BA','BC','BP','BD','OP')) or ((AccAss.Type not in ('BB','BA','BC','BP','BD','OP','DI','IC','CF','JP','BO')) or (Insured.VATF=1 and TOC.VATBusinessF=1))) Then 1 Else 0 End  
   End)  
  *(Case When Acceptance.NoRefundF=7 and AccAss.Type in ('BB','BA','BO','BC','BP','BD') and AccAss.Code in ('C','O') then 0 else 1 end)  
  *(Case When Acceptance.NoRefundF in (8,10,14) then 0 else 1 end)  
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
  Case when Max(AccAss.Type) in ('DI','IC','CF','JP','BO') Then    
   Case   
   When Max(SysTab.TaxMethod)=2 then  
    dbo.roundccy(  
    sum(  
    AccAss.Amount*Case When (AccAss.Type in ('DI','IC') and Accass.Code in ('P','O','U')) or (AccAss.Type in ('CF','JP') and AccAss.Code in ('P','O')) or (AccAss.Type in ('BO')) Then 1 else 0 end     
    *coalesce(RateCov.Portion,0)/coalesce(pRCover.Portion, RCover.Portion)  
    )  
    ,Accass.Currency)  
   When Max(SysTab.TaxMethod)=3 then  
    dbo.roundccy(  
    sum(  
    AccAss.Amount*Case When (AccAss.Type in ('DI','IC') and Accass.Code in ('P','O','U')) or (AccAss.Type in ('CF','JP') and AccAss.Code in ('P','O')) or (AccAss.Type in ('BO')) Then 1 else 0 end     
    *case When RateTab.VATF=1 and RateTab.VATEXEMPTF=0 then 1 else 0 end  
    )  
    ,Accass.Currency)  
   Else  
    dbo.roundccy(  
    sum(  
    AccAss.Amount  
    *(Case When SysTab.TaxMethod=0 or (Accass.Type in ('CP','DC','QS','QP','S1','S2','S3','AF','XP','FO','FP','IR','IX') and AccAss.Code='C') or (AccAss.Type in ('OP')) or (Accass.Type Not in ('CP','DC','QS','QP','S1','S2','S3','AF','XP','FO','FP','IR','IX') and AccAss.Code Not in ('F','D')) Then 1 else 0 end)  
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
 Left Join RateTab on (RateTab.Code=AccAss.RCode)  
 Left Join RCover on (RCover.ANO=Acceptance.ANO and RCover.Code=AccAss.RCode and RCover.SDate=AccAss.SDate)  
 Left Join RCover pRCover on (AccAss.CAmount=0 and pRCover.ANO=Acceptance.pANO and pRCover.Code=AccAss.RCode and pRCover.SDate=AccAss.SDate)  
 Outer apply (Select sum(RateCov.Portion) as Portion from RateCov Where RateCov.Code=AccAss.RCode and RateCov.VatF=1) as RateCov  
 WHERE Acceptance.RegNo=@MRegNo  
 GROUP BY AccAss.ID, Profile.Name, AccAss.Type, AccAss.Posted, AccAss.Admno, AccAss.Currency, Acceptance.RegNo, Accass.DocNo, AccAss.RefNo,        
 Case When AccAss.CAmount=0 and Coalesce(pAcceptance.Branch,'')<>'' Then pAcceptance.Branch Else Acceptance.Branch end,     
 dbo.fn_Get_UWYear(@MSDate, @MEDate, Case When (Case When isnull(APayor.ANO,0)=0 Then (Case When isnull(MPayor.ANO,0)=0 Then Payor.PolicyYearF else MPayor.PolicyYearF end) else APayor.PolicyYearF end)=1 Then AccAss.SDate else Acceptance.SDate end),  
 (Case When isnull(APayor.ANO,0)=0 Then (Case When isnull(MPayor.ANO,0)=0 Then Payor.Grace else MPayor.Grace end) else APayor.Grace end)  
END  
  
Select ID, Name, Type, cast(0 as Bit) as Posted, -1 as AdmNo, Currency,'SUMMARY' as RegNo, 'SUMMARY' as DocNo,'SUMMARY' as RefNo, 'SUMMARY' as Branch, 0 as PolicyYear, 0 as Grace,  
sum(Premium) as Premium, sum(Commision) as Commision, sum(OverridingCommission) as OverridingCommission, sum(Fee) as Fee, sum(Duty) as Duty,   
sum(Discount) as Discount, sum(Acquisition) as Acquisition, sum(PremiumAdjustment) as  PremiumAdjustment, sum(OtherIncome) as OtherIncome,   
sum(Ujroh) as Ujroh, sum(Tabarru) as Tabarru, sum(Deposit) as Deposit, sum(Advance) as Advance, sum(Rounding) as Rounding,   
sum(VAT) as VAT, sum(VATSubsidies) as VATSubsidies, sum(VAT_1) as VAT_1, sum(VAT_2) as VAT_2, sum(TAX) as TAX  
  
from @View07 View07  
Group by ID, Name, Type, Currency  
  
Union All  
Select *   
from @View07 View07  
  

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

GO
DROP FUNCTION PREMIUM_CALCULATION_BY_RATECODE
GO
CREATE FUNCTION PREMIUM_CALCULATION_BY_RATECODE(@P_ANO int)                  
RETURNS TABLE  AS                  
RETURN (                  

Select ANO, Code, Currency,
sum(Premium) as Premium,
sum(Commission) as Commission,
sum(Discount) as Discount,
dbo.roundCCY(sum(VAT),Currency) as VAT,
dbo.roundCCY(sum(TAX),Currency) as TAX,
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

go



insert into PatchVersioning
select '977 Update Script - 8 March 2024',GETDATE()
go


Declare @PrevScript varchar(100)
Declare @CurrScript varchar(100)

Select @PrevScript=''
Select @CurrSCript='977 Update Script - 8 March 2024'


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

