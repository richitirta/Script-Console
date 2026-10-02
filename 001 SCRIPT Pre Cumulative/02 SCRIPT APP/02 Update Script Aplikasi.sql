drop FUNCTION [dbo].[FL_UW_Ded]
go
CREATE FUNCTION [dbo].[FL_UW_Ded](@P_ANO as integer, @P_DCode as varchar(255), @P_TOPF as bit=0)
RETURNS TABLE
As Return (
Select Distinct DedTab.* 
From RCOVER
Inner Join RATECOV on RATECOV.CODE = RCOVER.CODE
Inner Join DedTab on DeDTab.TOR = RateCov.TOR 
Inner Join Acceptance on Acceptance.ANO = RCover.ANO
Left join TOP_Deductible on TOP_Deductible.TOPRO=Acceptance.TOPRO and TOP_Deductible.DCode=DedTab.DCode 
WHERE RCOVER.ANO=@P_ANO and DedTab.ALLOWEDF=1 AND (DedTab.DCode = @P_DCode OR DedTab.Remarks Like @P_DCode +'%')
and (@P_TOPF=0 or coalesce(TOP_Deductible.TOPRO,'')=Acceptance.TOPRO) 
)
go

drop FUNCTION [dbo].[FL_UW_TOI]
go
CREATE FUNCTION [dbo].[FL_UW_TOI](@P_ANO as integer, @P_TOI as varchar(255), @P_TOPF as bit=0)
RETURNS TABLE
As Return (
SELECT DISTINCT TOI.TOI,MAX(TOI.DESCRIPTION) as DESCRIPTION,  MAX(SYSTAB.CURRENCY) as CURRENCY, MAX(CAST(TOI.ADJUSTABLE as INT)) AS ADJUSTABLE, MAX(TOI.PCTADJ) as PCTADJ, MAX(TOI.DISPMODEL) AS DISPMODEL, MAX(PCLASS.CATEGORY) AS CATEGORY, MAX(PCLASS.LIMIT) AS LIMIT, CASE WHEN MAX(PCLASS.CATEGORY)='M' THEN MAX(TOIVALUE.VALUE) ELSE 0 END AS VALUE 
From TOI
INNER JOIN SYSTAB ON (1=1) 
Inner join PCLASS on PCLASS.TOI=TOI.TOI
Inner join RATECOV on RATECOV.TOR=PCLASS.TOR
Inner join RCOVER on RATECOV.CODE=RCOVER.CODE
Inner join Acceptance on Acceptance.ANO=RCOVER.ANO
LEFT JOIN AINFO ON (AINFO.ANO=RCOVER.ANO) 
LEFT JOIN TOIVALUE ON ( 
TOIVALUE.TOI=TOI.TOI AND TOIVALUE.YEAR=YEAR(ACCEPTANCE.SDATE) 
And ((TOIValue.ValueID1='' and AINFO.ValueDesc1 Like TOIValue.ValueDesc1+'%') or (TOIValue.ValueID1<>'' and AINFO.ValueID1 Like TOIValue.ValueID1) or (TOIValue.ValueID1 is null)) 
And ((TOIValue.ValueID2='' and AINFO.ValueDesc2 Like TOIValue.ValueDesc2+'%') or (TOIValue.ValueID2<>'' and AINFO.ValueID2 Like TOIValue.ValueID2) or (TOIValue.ValueID2 is null)) 
And ((TOIValue.ValueID3='' and AINFO.ValueDesc3 Like TOIValue.ValueDesc3+'%') or (TOIValue.ValueID3<>'' and AINFO.ValueID3 Like TOIValue.ValueID3) or (TOIValue.ValueID3 is null)) 
And ((TOIValue.ValueID4='' and AINFO.ValueDesc4 Like TOIValue.ValueDesc4+'%') or (TOIValue.ValueID4<>'' and AINFO.ValueID4 Like TOIValue.ValueID4) or (TOIValue.ValueID4 is null)) 
And ((TOIValue.ValueID5='' and AINFO.ValueDesc5 Like TOIValue.ValueDesc5+'%') or (TOIValue.ValueID5<>'' and AINFO.ValueID5 Like TOIValue.ValueID5) or (TOIValue.ValueID5 is null)) 
And ((TOIValue.ValueID6='' and AINFO.ValueDesc6 Like TOIValue.ValueDesc6+'%') or (TOIValue.ValueID6<>'' and AINFO.ValueID6 Like TOIValue.ValueID6) or (TOIValue.ValueID6 is null)) 
And ((TOIValue.ValueID7='' and AINFO.ValueDesc7 Like TOIValue.ValueDesc7+'%') or (TOIValue.ValueID7<>'' and AINFO.ValueID7 Like TOIValue.ValueID7) or (TOIValue.ValueID7 is null)) 
And ((TOIValue.ValueID8='' and AINFO.ValueDesc8 Like TOIValue.ValueDesc8+'%') or (TOIValue.ValueID8<>'' and AINFO.ValueID8 Like TOIValue.ValueID8) or (TOIValue.ValueID8 is null)) 
And ((TOIValue.ValueID9='' and AINFO.ValueDesc9 Like TOIValue.ValueDesc9+'%') or (TOIValue.ValueID9<>'' and AINFO.ValueID9 Like TOIValue.ValueID9) or (TOIValue.ValueID9 is null)) 
And ((TOIValue.ValueID10='' and AINFO.ValueDesc10 Like TOIValue.ValueDesc10+'%') or (TOIValue.ValueID10<>'' and AINFO.ValueID10 Like TOIValue.ValueID10) or (TOIValue.ValueID10 is null)) 
And ((TOIValue.ValueID11='' and AINFO.ValueDesc11 Like TOIValue.ValueDesc11+'%') or (TOIValue.ValueID11<>'' and AINFO.ValueID11 Like TOIValue.ValueID11) or (TOIValue.ValueID11 is null)) 
And ((TOIValue.ValueID12='' and AINFO.ValueDesc12 Like TOIValue.ValueDesc12+'%') or (TOIValue.ValueID12<>'' and AINFO.ValueID12 Like TOIValue.ValueID12) or (TOIValue.ValueID12 is null)) 
And ((TOIValue.ValueID13='' and AINFO.ValueDesc13 Like TOIValue.ValueDesc13+'%') or (TOIValue.ValueID13<>'' and AINFO.ValueID13 Like TOIValue.ValueID13) or (TOIValue.ValueID13 is null)) 
And ((TOIValue.ValueID14='' and AINFO.ValueDesc14 Like TOIValue.ValueDesc14+'%') or (TOIValue.ValueID14<>'' and AINFO.ValueID14 Like TOIValue.ValueID14) or (TOIValue.ValueID14 is null)) 
And ((TOIValue.ValueID15='' and AINFO.ValueDesc15 Like TOIValue.ValueDesc15+'%') or (TOIValue.ValueID15<>'' and AINFO.ValueID15 Like TOIValue.ValueID15) or (TOIValue.ValueID15 is null)) 
) 
Left join TOP_Interest on TOP_Interest.TOPRO=Acceptance.TOPRO and TOP_Interest.TOI=TOI.TOI 
WHERE RCOVER.ANO=@P_ANO and TOI.ALLOWEDF=1 AND (TOI.TOI Like @P_TOI OR TOI.DESCRIPTION Like @P_TOI+'%') and (@P_TOPF=0 or coalesce(TOP_Interest.TOPRO,'')=Acceptance.TOPRO) 
Group By TOI.TOI  
)
go
Insert into MParam(Type, Remarks, MemorialF, Effective, Last_Opr, Last_Update) 
Select 'PD','Policy Deposit',0,getdate(),'CARE',getdate()
go

DROP Procedure QCheckObjectClaimed
GO
CREATE Procedure QCheckObjectClaimed(@P_ClaimNo varchar(20), @P_PolicyNo varchar(20), @P_CertificateNo varchar(20),@P_LossDate smalldatetime='01/01/2007', @P_COL varchar(10)='', @P_Location varchar(10)='')   
as   
select C1.ClaimNo, C1.LossDate,  C1.PolicyNo+case When C1.CertificateNo='' then '' else '-'+C1.CertificateNo end as PolicyNo, C1.CStatus, C1.CNO, C1.ANO, P1.Name as Claimant, c2.DESCRIPTION as 'COL', L.location   
FROM   
(   
 select C1.OCNO, Max(C1.CNO) as CNO   
 from Claim C1   
 Where C1.ClaimNo<>@P_ClaimNo and C1.PolicyNo=@P_PolicyNo and C1.CertificateNo=@P_CertificateNo and C1.LossDate between dateadd(day,-14,@P_LossDate) and dateadd(day,14,@P_LossDate)   
 and not (C1.CStatus='C' and C1.pCStatus='P') -- not Close Claim
 and not ((C1.CStatus='A' or C1.pCStatus='A') and C1.CType='C')  --not Claim Cancellation
 and (@P_COL='' or C1.COL=@P_COL)   
 and (@P_Location='' or C1.location=@P_Location)   
 Group By C1.OCNO   
) C   
Inner Join Claim C1 on (C1.CNO=C.CNO)   
Inner Join Profile P1 on (P1.ID=C1.Claimant)   
Inner Join COLTAB C2 on (C2.COL=C1.COL)   
Left Join Location L on (L.Location=C1.Location)   
   
   
go

DROP procedure PI08 
GO
CREATE procedure PI08 (@P_ANO as integer)   
as   
Begin   
Declare @P_Date as smalldatetime   
Declare @P_PolicyNo as varchar(20)   
Declare @P_CertificateNo as varchar(20)   
Declare @P_OpenFLag as Bit   
Declare @P_LANO as int   
Declare @P_A_PolicyNo as varchar(50)   
Select @P_Date = Getdate()   
   
Select @P_LANO=A1.LANO, @P_PolicyNo=A1.PolicyNo, @P_CertificateNo=A1.CertificateNo, @P_OpenFlag=C1.OpenFlag from Acceptance A1, Cover C1 Where C1.CNO=A1.CNO and A1.ANO=@P_ANO   
   
if @P_LANO<>-1   
if @P_OpenFlag=1 and @P_ANO<>@P_LANO   
Select @P_A_PolicyNo=@P_PolicyNo + '-' + @P_CertificateNo   
else   
Select @P_A_PolicyNo=@P_PolicyNo   
else   
Select @P_A_PolicyNo=@P_PolicyNo   
   
Select Voucher.Voucher, Voucher.DueDate, Voucher.DocNo, Voucher_Due.DueDate as NDueDate, Profile.Name, Voucher.Currency,   
Admlink.RefType,  
Admlink.AccountNo, Admlink.Bank, Admlink.BankName,   
Admlink.AccountNo_Ext, Admlink.Bank_Ext, Admlink.BankName_Ext,   
case when Voucher.debtorf=1 then Voucher.Nominal_CC-Voucher.Diff_CC else -(Voucher.Nominal_CC-Voucher.Diff_CC) end  as Nominal,   
case when Voucher.debtorf=1 then (coalesce(Voucher_Due.AmountDue, Voucher.AmountDue)-Voucher.Payment_CC) else -(coalesce(Voucher_Due.AmountDue, Voucher.AmountDue)-Voucher.Payment_CC) end as AmountDue,   
case when Voucher.debtorf=1 then Voucher.Payment_CC else -Voucher.Payment_CC end as Payment,   
case when Voucher.debtorf=1 then Voucher.Nominal_CC-Voucher.Diff_CC - Voucher.Payment_CC else -(Voucher.Nominal_CC-Voucher.Diff_CC - Voucher.Payment_CC) end as Outstanding,   
Voucher.Installment,   
Voucher.DueDate_1, case when Voucher.debtorf=1 then Voucher.AmountDue_1 else -Voucher.AmountDue_1 end AmountDue_1,   
Voucher.DueDate_2, case when Voucher.debtorf=1 then Voucher.AmountDue_2 else -Voucher.AmountDue_2 end AmountDue_2,   
Voucher.DueDate_3, case when Voucher.debtorf=1 then Voucher.AmountDue_3 else -Voucher.AmountDue_3 end AmountDue_3,   
Voucher.DueDate_4, case when Voucher.debtorf=1 then Voucher.AmountDue_4 else -Voucher.AmountDue_4 end AmountDue_4,   
Voucher.DueDate_5, case when Voucher.debtorf=1 then Voucher.AmountDue_5 else -Voucher.AmountDue_5 end AmountDue_5,   
Voucher.DueDate_6, case when Voucher.debtorf=1 then Voucher.AmountDue_6 else -Voucher.AmountDue_6 end AmountDue_6,   
Voucher.DueDate_7, case when Voucher.debtorf=1 then Voucher.AmountDue_7 else -Voucher.AmountDue_7 end AmountDue_7,   
Voucher.DueDate_8, case when Voucher.debtorf=1 then Voucher.AmountDue_8 else -Voucher.AmountDue_8 end AmountDue_8,   
Voucher.DueDate_9, case when Voucher.debtorf=1 then Voucher.AmountDue_9 else -Voucher.AmountDue_9 end AmountDue_9,   
Voucher.DueDate_10, case when Voucher.debtorf=1 then Voucher.AmountDue_10 else -Voucher.AmountDue_10 end AmountDue_10,   
Voucher.DueDate_11, case when Voucher.debtorf=1 then Voucher.AmountDue_11 else -Voucher.AmountDue_11 end AmountDue_11,   
Voucher.DueDate_12, case when Voucher.debtorf=1 then Voucher.AmountDue_12 else -Voucher.AmountDue_12 end AmountDue_12,   
Voucher.DueDate_13, case when Voucher.debtorf=1 then Voucher.AmountDue_13 else -Voucher.AmountDue_13 end AmountDue_13,   
Voucher.DueDate_14, case when Voucher.debtorf=1 then Voucher.AmountDue_14 else -Voucher.AmountDue_14 end AmountDue_14,   
Voucher.DueDate_15, case when Voucher.debtorf=1 then Voucher.AmountDue_15 else -Voucher.AmountDue_15 end AmountDue_15,   
Voucher.DueDate_16, case when Voucher.debtorf=1 then Voucher.AmountDue_16 else -Voucher.AmountDue_16 end AmountDue_16,   
Voucher.DueDate_17, case when Voucher.debtorf=1 then Voucher.AmountDue_17 else -Voucher.AmountDue_17 end AmountDue_17,   
Voucher.DueDate_18, case when Voucher.debtorf=1 then Voucher.AmountDue_18 else -Voucher.AmountDue_18 end AmountDue_18,   
Voucher.DueDate_19, case when Voucher.debtorf=1 then Voucher.AmountDue_19 else -Voucher.AmountDue_19 end AmountDue_19,   
Voucher.DueDate_20, case when Voucher.debtorf=1 then Voucher.AmountDue_20 else -Voucher.AmountDue_20 end AmountDue_20,   
Voucher.DueDate_21, case when Voucher.debtorf=1 then Voucher.AmountDue_21 else -Voucher.AmountDue_21 end AmountDue_21,   
Voucher.DueDate_22, case when Voucher.debtorf=1 then Voucher.AmountDue_22 else -Voucher.AmountDue_22 end AmountDue_22,   
Voucher.DueDate_23, case when Voucher.debtorf=1 then Voucher.AmountDue_23 else -Voucher.AmountDue_23 end AmountDue_23,   
Voucher.DueDate_24, case when Voucher.debtorf=1 then Voucher.AmountDue_24 else -Voucher.AmountDue_24 end AmountDue_24   
from nVoucher Voucher Inner Join Voucher_AmountDue(@P_Date) Voucher_Due on (Voucher_Due.Voucher=Voucher.Voucher), Profile, ProAcc, Admlink   
Where Profile.ID=ProAcc.ID and ProAcc.ProAcc=Voucher.ProAcc and Admlink.Voucher=Voucher.Voucher   
and Admlink.Subject='Premium' and Admlink.Type in ('DI','IC','IR') and Admlink.A_PolicyNo=@P_A_PolicyNo and (Admlink.Extra_1='' or Admlink.Extra_1 is null)   
End   
   
go

DROP View Voucher
GO
CREATE View Voucher   as    
Select V.Voucher, V.Date, V.VType, V.Remarks, V.Currency, V.Nominal_CC, V.Rate, V.Nominal, V.Branch, V.Num_Doc, V.SL_Cat, V.ProAcc, V.ComAcc, V.RefNo, V.RefDate, V.RefType, V.DueDate, V.DebtorF, V.ChequeF, V.CreditorF, V.Diff_CC, V.Diff, V.Vat_CC,    
V.Tax_CC, V.VatF, V.TaxF, V.PaymentF, V.ReceiptF, V.TaxType, V.BranchF, V.CT, V.NDueDate, V.MDueDate, V.DocNo, V.BackDatedF, V.AccountNo, V.BankAccount, V.BankName, V.Last_Date, V.Last_Time, V.Last_Opr, V.PDate, V.Payment_CC, V.Payment_OC, V.NPayment, V.TaxPayment_CC,    
V.TaxPayment_OC, V.Status, V.PrintDate, V.PrintUser, V.Source, V.SourceF, V.Posting_Flag, V.Investment, V.InvestmentF, V.Asset, V.AssetF,
V.REQUESTF , V.RequestMessage, V.RequestName
from dbo.nVoucher V    
Union All    
Select V.Voucher, V.Date, V.VType, V.Remarks, V.Currency, V.Nominal_CC, V.Rate, V.Nominal, V.Branch, V.Num_Doc, V.SL_Cat, V.ProAcc, V.ComAcc, V.RefNo, V.RefDate, V.RefType, V.DueDate, V.DebtorF, V.ChequeF, V.CreditorF, V.Diff_CC, V.Diff, V.Vat_CC,    
V.Tax_CC, V.VatF, V.TaxF, V.PaymentF, V.ReceiptF, V.TaxType, V.BranchF, V.CT, V.NDueDate, V.MDueDate, V.DocNo, V.BackDatedF, V.AccountNo, V.BankAccount, V.BankName, V.Last_Date, V.Last_Time, V.Last_Opr, V.PDate, V.Payment_CC, V.Payment_OC, V.NPayment, V.TaxPayment_CC,         
V.TaxPayment_OC, V.Status, V.PrintDate, V.PrintUser, V.Source, V.SourceF, V.Posting_Flag, V.Investment, V.InvestmentF, V.Asset, V.AssetF,
V.REQUESTF , V.RequestMessage, V.RequestName
from dbo.pVoucher V    
Union All    
Select V.Voucher, V.Date, V.VType, V.Remarks, V.Currency, V.Nominal_CC, V.Rate, V.Nominal, V.Branch, V.Num_Doc, V.SL_Cat, V.ProAcc, V.ComAcc, V.RefNo, V.RefDate, V.RefType, V.DueDate, V.DebtorF, V.ChequeF, V.CreditorF, V.Diff_CC, V.Diff, V.Vat_CC,    
V.Tax_CC, V.VatF, V.TaxF, V.PaymentF, V.ReceiptF, V.TaxType, V.BranchF, V.CT, V.NDueDate, V.MDueDate, V.DocNo, V.BackDatedF, V.AccountNo, V.BankAccount, V.BankName, V.Last_Date, V.Last_Time, V.Last_Opr, V.PDate, V.Payment_CC, V.Payment_OC, V.NPayment, V.TaxPayment_CC,         
V.TaxPayment_OC, V.Status, V.PrintDate, V.PrintUser, V.Source, V.SourceF, V.Posting_Flag, V.Investment, V.InvestmentF,  V.Asset, V.AssetF,
V.REQUESTF , V.RequestMessage, V.RequestName
from dbo.mVoucher V    
go

DROP PROCEDURE View07 
GO
CREATE PROCEDURE View07 (@p_ANo as integer)              
AS              
SELECT AccAss.ID, Profile.Name, AccAss.Type, AccAss.Posted, AccAss.Admno, AccAss.Currency, Acceptance.RegNo,       
sum(              
 case              
  when (accass.type in ('DI','IC') and accass.code in ('P','U')) or (AccAss.Type not in ('DI','IC') and AccAss.Code='P') then accass.Amount              
  else 0              
 end              
) AS Premium,               
sum(              
 case               
  when accass.code='C' then accass.Amount              
  else 0              
 end              
) AS Commision,               
sum(              
 case               
  when accass.code='F' then accass.Amount              
  else 0              
 end              
) AS Fee,               
sum(              
 case               
  when accass.code='D' then accass.Amount              
  else 0              
 end              
) AS Duty,               
sum(              
 case               
  when accass.code='O' then accass.Amount              
  else 0              
 end              
) AS Discount,               
sum(              
 case              
  when accass.code='I' then accass.Amount              
  else 0              
 end              
) AS OtherIncome,             
sum(              
 case              
  when accass.Type in ('DI','IC') and accass.code='U' then -accass.Amount      
  when accass.Type Not in ('DI','IC') and accass.code='U' then accass.Amount      
  else 0              
 End              
) AS Ujroh,            
sum(              
 case              
  when (accass.type in ('DI','IC') and accass.code in ('P')) or (AccAss.Type not in ('DI','IC') and AccAss.Code in ('P','U')) then accass.Amount              
  else 0              
 end              
) AS Tabarru,       
sum(              
 case              
  when (accass.type in ('DI') and accass.code in ('J')) then accass.Amount              
  else 0              
 end              
) AS Deposit,        
sum(Case When coalesce((Admlink.Amount-Admlink.Amount_11-Admlink.Amount_12-Admlink.Amount_13-Admlink.Amount_14),0)<>0 then Admlink.Amount_11*AccAss.amount/(Admlink.Amount-Admlink.Amount_11-Admlink.Amount_12-Admlink.Amount_13-Admlink.Amount_14) else 0 end)
 as Rounding,      
sum(Case When coalesce((Admlink.Amount-Admlink.Amount_11-Admlink.Amount_12-Admlink.Amount_13-Admlink.Amount_14),0)<>0 then Admlink.Amount_13*AccAss.amount/(Admlink.Amount-Admlink.Amount_11-Admlink.Amount_12-Admlink.Amount_13-Admlink.Amount_14) else 0 end)
 as VAT,      
sum(Case When coalesce((Admlink.Amount-Admlink.Amount_11-Admlink.Amount_12-Admlink.Amount_13-Admlink.Amount_14),0)<>0 then Admlink.Amount_14*AccAss.amount/(Admlink.Amount-Admlink.Amount_11-Admlink.Amount_12-Admlink.Amount_13-Admlink.Amount_14) else 0 end)
 as TAX      
FROM AccAss Left Join Admlink on (Admlink.AdmNo=AccAss.AdmNo), Acceptance, Profile              
WHERE AccAss.ID=Profile.ID And Acceptance.Ano=Accass.Ano And Acceptance.ANO=@p_ANO              
GROUP BY AccAss.ID, Profile.Name, AccAss.Type, AccAss.Posted, AccAss.RefNo, AccAss.Admno, AccAss.Currency, Acceptance.RegNo      
        
           
GO

DROP PROCEDURE View07A 
GO
CREATE PROCEDURE View07A (@p_ANo as integer)            
AS            
SELECT AccAss.ID, Profile.Name, AccAss.Type, AccAss.Posted, AccAss.Admno, AccAss.Currency, Acceptance.RegNo,       
sum(            
 case              
  when (accass.type in ('DI','IC') and accass.code in ('P','U')) or (AccAss.Type not in ('DI','IC') and AccAss.Code='P') then accass.Amount              
  else 0              
 end              
) AS Premium,            
sum(            
 case            
  when accass.code='C' then accass.Amount            
  else 0            
 End            
) AS Commision,            
sum(            
 case            
  when accass.code='F' then accass.Amount            
  else 0            
 End            
) AS Fee,            
sum(            
 case            
  when accass.code='D' then accass.Amount            
  else 0            
 End            
) AS Duty,            
sum(            
 case            
  when accass.code='O' then accass.Amount            
  else 0            
 End            
) AS Discount,            
sum(            
 case            
  when accass.code='I' then accass.Amount            
  else 0            
 End            
) AS OtherIncome,          
sum(            
 case            
  when accass.Type in ('DI','IC') and accass.code='U' then -accass.Amount      
  when accass.Type Not in ('DI','IC') and accass.code='U' then accass.Amount      
  else 0            
 End            
) AS Ujroh,        
sum(              
 case              
  when (accass.type in ('DI','IC') and accass.code in ('P')) or (AccAss.Type not in ('DI','IC') and AccAss.Code in ('P','U')) then accass.Amount              
  else 0              
 end              
) AS Tabarru,      
sum(              
 case              
  when (accass.type in ('DI') and accass.code in ('J')) then accass.Amount              
  else 0              
 end              
) AS Deposit,      
sum(Case When coalesce((Admlink.Amount-Admlink.Amount_11-Admlink.Amount_12-Admlink.Amount_13-Admlink.Amount_14),0)<>0 then Admlink.Amount_11*AccAss.amount/(Admlink.Amount-Admlink.Amount_11-Admlink.Amount_12-Admlink.Amount_13-Admlink.Amount_14) else 0 end)
 as Rounding,      
sum(Case When coalesce((Admlink.Amount-Admlink.Amount_11-Admlink.Amount_12-Admlink.Amount_13-Admlink.Amount_14),0)<>0 then Admlink.Amount_13*AccAss.amount/(Admlink.Amount-Admlink.Amount_11-Admlink.Amount_12-Admlink.Amount_13-Admlink.Amount_14) else 0 end)
 as VAT,      
sum(Case When coalesce((Admlink.Amount-Admlink.Amount_11-Admlink.Amount_12-Admlink.Amount_13-Admlink.Amount_14),0)<>0 then Admlink.Amount_14*AccAss.amount/(Admlink.Amount-Admlink.Amount_11-Admlink.Amount_12-Admlink.Amount_13-Admlink.Amount_14) else 0 end)
 as TAX  
FROM AccAss Left Join Admlink on (Admlink.AdmNo=AccAss.AdmNo), Acceptance, Profile, Acceptance AS M            
WHERE AccAss.ID=Profile.ID And Acceptance.Ano=Accass.Ano And Acceptance.RegNo=M.RegNo and Acceptance.PolicyNo=M.PolicyNo and M.ANO=@P_ANO      
GROUP BY AccAss.ID, Profile.Name, AccAss.Type, AccAss.Posted, AccAss.RefNo, AccAss.Admno, AccAss.Currency, Acceptance.RegNo      
go

DROP Procedure View16L
GO
CREATE Procedure View16L(@P_ANO integer)   
as   
SELECT 
ACCEPTANCE.CNO,ACCEPTANCE.ANO, ACCEPTANCE.POLICYNO, ACCEPTANCE.CERTIFICATENO, ACCEPTANCE.ADATE, ACCEPTANCE.SDATE, ACCEPTANCE.EDATE, ACCEPTANCE.REMARKS, ACCEPTANCE.ASTATUS, ACCEPTANCE.BACKDATEDF, AccAss.CURRENCY_OC,   
sum(case accass.code+accass.type   
when 'PIT' then accass.amount_oc   
when 'PIX' then accass.amount_oc   
else 0 end) as Premium,   
   
sum(case accass.code+accass.type   
when 'UIT' then accass.amount_oc   
when 'UIX' then accass.amount_oc   
else 0 end) as UjrohCedant,   
   
sum(case accass.code+accass.type   
when 'AIT' then accass.amount_oc   
when 'AIX' then accass.amount_oc   
else 0 end) as Claim,   
   
sum(case accass.code+accass.type   
when 'RIT' then accass.amount_oc   
when 'RIX' then accass.amount_oc   
else 0 end) as Subrogation,   
   
sum(case accass.code+accass.type   
when 'CIT' then accass.amount_oc   
when 'CIX' then accass.amount_oc   
else 0 end) as Commission,   
   
sum(case accass.code+accass.type   
when 'FIT' then accass.amount_oc   
when 'FIX' then accass.amount_oc   
else 0 end) as Fee,   
   
sum(case accass.code+accass.type   
when 'TIT' then accass.amount_oc   
when 'TIX' then accass.amount_oc   
else 0 end) as Tax,   
   
sum(case accass.code+accass.type   
when 'CBO' then accass.amount_oc   
when 'OIT' then accass.amount_oc   
when 'OIX' then accass.amount_oc   
else 0 end) as Other,   
   
sum(case accass.code+accass.type   
when 'DIT' then accass.amount_oc   
when 'DIX' then accass.amount_oc   
else 0 end) as Fund,   
Max(PCalc.OurShare) as TSI,   
AccAss.Currency   
FROM ACCEPTANCE With (Index (I_ACCEPTANCE_LANO))   
Left Join AccAss with (Index (I_ACCASS_ANO)) on (AccAss.ANO=Acceptance.ANO)   
Left Join PCalc with (index(I_PCalc)) on (PCalc.ANO=Acceptance.ANO and PCalc.Currency=AccAss.Currency)   
WHERE Acceptance.LANO=@P_ANO and Acceptance.ANO<>Acceptance.LANO   
GROUP BY ACCEPTANCE.ANO, ACCEPTANCE.CNO, ACCEPTANCE.POLICYNO, ACCEPTANCE.CERTIFICATENO, ACCEPTANCE.ADATE, ACCEPTANCE.SDATE, ACCEPTANCE.EDATE, ACCEPTANCE.REMARKS, ACCEPTANCE.ASTATUS, ACCEPTANCE.BACKDATEDF, AccAss.CURRENCY_OC, AccAss.CURRENCY   
ORDER BY ACCEPTANCE.ANO

GO

DROP FUNCTION List10_Det 
GO
CREATE FUNCTION List10_Det (@P_ANO as integer)   
RETURNS Table   
AS RETURN(   
   
SELECT Cast(0 as bit) as ProcessFlag,   
ACCEPTANCE.CNO,ACCEPTANCE.ANO, ACCEPTANCE.POLICYNO, ACCEPTANCE.CERTIFICATENO, ACCEPTANCE.ADATE, ACCEPTANCE.SDATE, ACCEPTANCE.EDATE, ACCEPTANCE.REMARKS, ACCEPTANCE.ASTATUS, ACCEPTANCE.BACKDATEDF, AccAss.CURRENCY_OC,   
sum(case accass.code+accass.type   
when 'PIT' then accass.amount_oc   
when 'PIX' then accass.amount_oc   
else 0 end) as Premium,   
   
sum(case accass.code+accass.type   
when 'UIT' then accass.amount_oc   
when 'UIX' then accass.amount_oc   
else 0 end) as UjrohCedant,   
   
sum(case accass.code+accass.type   
when 'AIT' then accass.amount_oc   
when 'AIX' then accass.amount_oc   
else 0 end) as Claim,   
   
sum(case accass.code+accass.type   
when 'RIT' then accass.amount_oc   
when 'RIX' then accass.amount_oc   
else 0 end) as Subrogation,   
   
sum(case accass.code+accass.type   
when 'CIT' then accass.amount_oc   
when 'CIX' then accass.amount_oc   
else 0 end) as Commission,   
   
sum(case accass.code+accass.type   
when 'FIT' then accass.amount_oc   
when 'FIX' then accass.amount_oc   
else 0 end) as Fee,   
   
sum(case accass.code+accass.type   
when 'TIT' then accass.amount_oc   
when 'TIX' then accass.amount_oc   
else 0 end) as Tax,   
   
sum(case accass.code+accass.type   
when 'CBO' then accass.amount_oc   
when 'OIT' then accass.amount_oc   
when 'OIX' then accass.amount_oc   
else 0 end) as Other,   
   
sum(case accass.code+accass.type   
when 'DIT' then accass.amount_oc   
when 'DIX' then accass.amount_oc   
else 0 end) as Fund,   
Max(PCalc.OurShare) as TSI,   
AccAss.Currency   
FROM ACCEPTANCE With (Index (I_ACCEPTANCE_LANO))   
Left Join AccAss with (Index (I_ACCASS_ANO)) on (AccAss.ANO=Acceptance.ANO)   
Left Join PCalc with (index(I_PCalc)) on (PCalc.ANO=Acceptance.ANO and PCalc.Currency=AccAss.Currency)   
WHERE Acceptance.LANO=@P_ANO and Acceptance.ANO<>Acceptance.LANO   
GROUP BY ACCEPTANCE.ANO, ACCEPTANCE.CNO, ACCEPTANCE.POLICYNO, ACCEPTANCE.CERTIFICATENO, ACCEPTANCE.ADATE, ACCEPTANCE.SDATE, ACCEPTANCE.EDATE, ACCEPTANCE.REMARKS, ACCEPTANCE.ASTATUS, ACCEPTANCE.BACKDATEDF, AccAss.CURRENCY_OC, AccAss.CURRENCY   
)   
   
 go

DROP PROCEDURE [dbo].[QCLACC01_1]
GO
CREATE PROCEDURE [dbo].[QCLACC01_1] (@PCNO AS INTEGER, @PTOI AS VARCHAR(10))      
AS      
SELECT Distinct cast(ICOVER.REMARK as varchar(255)) AS REMARK, ICOVER.CURRENCY,      
CASE      
 WHEN CLAIM.EVENTNO=-1 THEN      
        CASE      
        WHEN ICOVER.NOTDECRF=1 OR RCOVER.PCTLOSS=0 THEN ICOVER.AMOUNT      
        ELSE ICOVER.AMOUNT*RCOVER.PCTLOSS/100 END      
 Else      
        CASE      
        WHEN ICOVER.NOTDECRF=1 OR RCOVER.PCTLOSS=0 THEN ICOVER.AMOUNT_AOE      
        ELSE ICOVER.AMOUNT_AOE*RCOVER.PCTLOSS/100 END      
 END AS SI, ICOVER.INO, ICOVER.TOI, ICOVER.TOTAL, ICOVER.INDEMNITY, TOI.AGREEDVALF      
From ICOVER, CLAIM, Col, ICALC, RCOVER, TOI, acceptance      
WHERE CLAIM.CNO=@PCNO AND ICOVER.ANO=CLAIM.ANO AND RCOVER.ANO=CLAIM.ANO AND ACCEPTANCE.ANO=CLAIM.ANO      
AND ICALC.ANO=CLAIM.ANO AND ICOVER.INO=ICALC.INO AND RCOVER.CODE=ICALC.CODE      
AND ((RCOVER.SDATE<=CLAIM.LOSSDATE And Acceptance.ExclusiveF=1) or ((RCOVER.SDATE<CLAIM.LOSSDATE or (RCOVER.SDATE=CLAIM.LOSSDATE and '12:00'<=Claim.LossTime)) and Acceptance.ExclusiveF=0))     
AND ((dbo.fn_Get_ExtPeriodDate(ACCEPTANCE.ExtPeriod, ACCEPTANCE.ExtPeriodInDaysF, RCOVER.EDATE)>CLAIM.LOSSDATE AND ACCEPTANCE.ExclusiveF=1) or ((dbo.fn_Get_ExtPeriodDate(ACCEPTANCE.ExtPeriod, ACCEPTANCE.ExtPeriodInDaysF, RCOVER.EDATE)>CLAIM.LOSSDATE 
or (dbo.fn_Get_ExtPeriodDate(ACCEPTANCE.ExtPeriod, ACCEPTANCE.ExtPeriodInDaysF, RCOVER.EDATE)=CLAIM.LOSSDATE AND '12:00'>Claim.LossTime)) AND ACCEPTANCE.ExclusiveF=0))      
AND COL.COL=CLAIM.COL AND ICALC.TOR=COL.TOR AND TOI.TOI=ICOVER.TOI     
AND ICOVER.TOI=@PTOI
GO

DROP Function [dbo].[FL_CL_KOL]
GO
Create Function [dbo].[FL_CL_KOL](@P_CNO as Int, @P_INO AS Int, @P_Payment as varchar(10), @P_KOL AS VARCHAR(50)) 
RETURNS TABLE 
AS RETURN ( 
 
SELECT KOL.KOL, KOL.DESCRIPTION, KOL.CATEGORY, Max(coalesce(KOLVALUE.COST,0)) as Cost, KOL.VATF, KOL.TAXF, KOLVALUE.BRANCH 
FROM ICOVER 
INNER JOIN KOL ON (KOL.ALLOWEDF=1 and KOL.TOI=ICOVER.TOI AND (KOL.KOL LIKE @P_KOL or KOL.DESCRIPTION LIKE @P_KOL)) 
INNER JOIN CLAIM ON (CLAIM.CNO=@P_CNO) 
LEFT JOIN CLINFO ON (CLINFO.CNO=CLAIM.CNO AND CLINFO.INO=ICOVER.INO) 
LEFT JOIN IINFO ON (IINFO.INO=ICOVER.INO) 
LEFT JOIN KOLVALUE ON (KOLVALUE.KOL=KOL.KOL AND KOLVALUE.TOI=KOL.TOI 
AND 
( 
KOLVALUE.BRANCH='<All>' 
OR EXISTS 
( 
SELECT CASE WHEN COALESCE(PAYMENT.BRANCH,'')='' THEN CLAIM.BRANCH ELSE PAYMENT.BRANCH END 
FROM PROFILE PAYMENT 
WHERE PAYMENT.ID=@P_Payment and CASE WHEN COALESCE(PAYMENT.BRANCH,'')='' THEN CLAIM.BRANCH ELSE PAYMENT.BRANCH END=KOLVALUE.BRANCH 
) 
) 
) 
WHERE ICOVER.INO=@P_INO 
AND (isnull(KOLVALUE.KOL,'')='' OR --No Reference Value Set 
( 
--Reference Value Set with Specific Claim Info 
(coalesce(KOLVALUE.ValueID1,'')='' Or coalesce(CLINFO.ValueID1,IINFO.ValueID1)=coalesce(KOLVALUE.ValueID1,'')) 
And (coalesce(KOLVALUE.ValueID2,'')='' Or coalesce(CLINFO.ValueID2,IINFO.ValueID2)=coalesce(KOLVALUE.ValueID2,'')) 
And (coalesce(KOLVALUE.ValueID3,'')='' Or coalesce(CLINFO.ValueID3,IINFO.ValueID3)=coalesce(KOLVALUE.ValueID3,'')) 
And (coalesce(KOLVALUE.ValueID4,'')='' Or coalesce(CLINFO.ValueID4,IINFO.ValueID4)=coalesce(KOLVALUE.ValueID4,'')) 
And (coalesce(KOLVALUE.ValueID5,'')='' Or coalesce(CLINFO.ValueID5,IINFO.ValueID5)=coalesce(KOLVALUE.ValueID5,'')) 
And (coalesce(KOLVALUE.ValueID6,'')='' Or coalesce(CLINFO.ValueID6,IINFO.ValueID6)=coalesce(KOLVALUE.ValueID6,'')) 
And (coalesce(KOLVALUE.ValueID7,'')='' Or coalesce(CLINFO.ValueID7,IINFO.ValueID7)=coalesce(KOLVALUE.ValueID7,'')) 
And (coalesce(KOLVALUE.ValueID8,'')='' Or coalesce(CLINFO.ValueID8,IINFO.ValueID8)=coalesce(KOLVALUE.ValueID8,'')) 
And (coalesce(KOLVALUE.ValueID9,'')='' Or coalesce(CLINFO.ValueID9,IINFO.ValueID9)=coalesce(KOLVALUE.ValueID9,'')) 
And (coalesce(KOLVALUE.ValueID10,'')='' Or coalesce(CLINFO.ValueID10,IINFO.ValueID10)=coalesce(KOLVALUE.ValueID10,'')) 
And (coalesce(KOLVALUE.ValueID11,'')='' Or coalesce(CLINFO.ValueID11,IINFO.ValueID11)=coalesce(KOLVALUE.ValueID11,'')) 
And (coalesce(KOLVALUE.ValueID12,'')='' Or coalesce(CLINFO.ValueID12,IINFO.ValueID12)=coalesce(KOLVALUE.ValueID12,'')) 
And (coalesce(KOLVALUE.ValueID13,'')='' Or coalesce(CLINFO.ValueID13,IINFO.ValueID13)=coalesce(KOLVALUE.ValueID13,'')) 
And (coalesce(KOLVALUE.ValueID14,'')='' Or coalesce(CLINFO.ValueID14,IINFO.ValueID14)=coalesce(KOLVALUE.ValueID14,'')) 
And (coalesce(KOLVALUE.ValueID15,'')='' Or coalesce(CLINFO.ValueID15,IINFO.ValueID15)=coalesce(KOLVALUE.ValueID15,'')) 
)) 
Group By KOL.KOL, KOL.DESCRIPTION, KOL.CATEGORY, KOL.VATF, KOL.TAXF, KOLVALUE.BRANCH 
) 
 
GO
 
DROP PROCEDURE [dbo].[QREFERENCE_VALUE]
GO 
CREATE PROCEDURE [dbo].[QREFERENCE_VALUE](@P_CNO as Int, @P_INO AS Int, @P_Payment as varchar(10), @P_KOL AS VARCHAR(50)) 
AS 
 
SELECT KOL.KOL, KOL.DESCRIPTION, KOL.CATEGORY, Max(coalesce(KOLVALUE.COST,0)) as Cost, KOL.VATF, KOL.TAXF 
FROM ICOVER 
INNER JOIN KOL ON (KOL.ALLOWEDF=1 and KOL.TOI=ICOVER.TOI AND (KOL.KOL LIKE @P_KOL or KOL.DESCRIPTION LIKE @P_KOL)) 
INNER JOIN CLAIM ON (CLAIM.CNO=@P_CNO) 
LEFT JOIN CLINFO ON (CLINFO.CNO=CLAIM.CNO AND CLINFO.INO=ICOVER.INO) 
LEFT JOIN IINFO ON (IINFO.INO=ICOVER.INO) 
LEFT JOIN KOLVALUE ON (KOLVALUE.KOL=KOL.KOL AND KOLVALUE.TOI=KOL.TOI 
AND 
( 
KOLVALUE.BRANCH='<All>' 
OR EXISTS 
( 
SELECT CASE WHEN COALESCE(PAYMENT.BRANCH,'')='' THEN CLAIM.BRANCH ELSE PAYMENT.BRANCH END 
FROM PROFILE PAYMENT 
WHERE PAYMENT.ID=@P_Payment AND CASE WHEN COALESCE(PAYMENT.BRANCH,'')='' THEN CLAIM.BRANCH ELSE PAYMENT.BRANCH END=KOLVALUE.BRANCH 
) 
) 
) 
WHERE ICOVER.INO=@P_INO 
AND (isnull(KOLVALUE.KOL,'')='' OR --No Reference Value Set 
( 
--Reference Value Set with Specific Claim Info 
(coalesce(KOLVALUE.ValueID1,'')='' Or coalesce(CLINFO.ValueID1,IINFO.ValueID1)=coalesce(KOLVALUE.ValueID1,'')) 
And (coalesce(KOLVALUE.ValueID2,'')='' Or coalesce(CLINFO.ValueID2,IINFO.ValueID2)=coalesce(KOLVALUE.ValueID2,'')) 
And (coalesce(KOLVALUE.ValueID3,'')='' Or coalesce(CLINFO.ValueID3,IINFO.ValueID3)=coalesce(KOLVALUE.ValueID3,'')) 
And (coalesce(KOLVALUE.ValueID4,'')='' Or coalesce(CLINFO.ValueID4,IINFO.ValueID4)=coalesce(KOLVALUE.ValueID4,'')) 
And (coalesce(KOLVALUE.ValueID5,'')='' Or coalesce(CLINFO.ValueID5,IINFO.ValueID5)=coalesce(KOLVALUE.ValueID5,'')) 
And (coalesce(KOLVALUE.ValueID6,'')='' Or coalesce(CLINFO.ValueID6,IINFO.ValueID6)=coalesce(KOLVALUE.ValueID6,'')) 
And (coalesce(KOLVALUE.ValueID7,'')='' Or coalesce(CLINFO.ValueID7,IINFO.ValueID7)=coalesce(KOLVALUE.ValueID7,'')) 
And (coalesce(KOLVALUE.ValueID8,'')='' Or coalesce(CLINFO.ValueID8,IINFO.ValueID8)=coalesce(KOLVALUE.ValueID8,'')) 
And (coalesce(KOLVALUE.ValueID9,'')='' Or coalesce(CLINFO.ValueID9,IINFO.ValueID9)=coalesce(KOLVALUE.ValueID9,'')) 
And (coalesce(KOLVALUE.ValueID10,'')='' Or coalesce(CLINFO.ValueID10,IINFO.ValueID10)=coalesce(KOLVALUE.ValueID10,'')) 
And (coalesce(KOLVALUE.ValueID11,'')='' Or coalesce(CLINFO.ValueID11,IINFO.ValueID11)=coalesce(KOLVALUE.ValueID11,'')) 
And (coalesce(KOLVALUE.ValueID12,'')='' Or coalesce(CLINFO.ValueID12,IINFO.ValueID12)=coalesce(KOLVALUE.ValueID12,'')) 
And (coalesce(KOLVALUE.ValueID13,'')='' Or coalesce(CLINFO.ValueID13,IINFO.ValueID13)=coalesce(KOLVALUE.ValueID13,'')) 
And (coalesce(KOLVALUE.ValueID14,'')='' Or coalesce(CLINFO.ValueID14,IINFO.ValueID14)=coalesce(KOLVALUE.ValueID14,'')) 
And (coalesce(KOLVALUE.ValueID15,'')='' Or coalesce(CLINFO.ValueID15,IINFO.ValueID15)=coalesce(KOLVALUE.ValueID15,'')) 
)) 
Group By KOL.KOL, KOL.DESCRIPTION, KOL.CATEGORY, KOL.VATF, KOL.TAXF 
 
 
GO

UPDATE Beneficiaries SET NAME=P.Name
FROM Beneficiaries B, PROFILE P
WHERE B.ID=P.ID AND B.NAME=''
GO

IF Not EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Profile_Income]') AND type in (N'U'))
begin
CREATE TABLE [dbo].[Profile_Income](
	[Income] [varchar](20) NOT NULL,
	[Description] [varchar](20) NOT NULL,
	[AllowedF] [bit] NULL,
	[CorporateF] [bit] NULL
) ON [PRIMARY]
END
GO


IF Not EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Profile_IncomeSource]') AND type in (N'U'))
begin
CREATE TABLE [dbo].[Profile_IncomeSource](
	[IncomeSource] [varchar](20) NOT NULL,
	[Description] [varchar](20) NOT NULL,
	[AllowedF] [bit] NULL,
	[CorporateF] [bit] NULL
) ON [PRIMARY]
END
GO


update versioning Set VerNoApp ='2016 V.2.X.X',VerUpdateApp=getdate()
go
 

