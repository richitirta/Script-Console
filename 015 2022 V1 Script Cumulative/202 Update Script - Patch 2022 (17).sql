DROP PROCEDURE QPAYMENTNEXTDUE 
GO
CREATE PROCEDURE QPAYMENTNEXTDUE (@P_ANO AS INTEGER,@P_PDate as smalldatetime)                      

AS 

Declare @P_APolicyNo as varchar(50)        
Declare @P_OANO int
Declare @P_MOANO int
Declare @P_LANO int
Declare @P_MinAdmNo as int
Declare @P_MaxAdmNo as int

Select 
@P_APolicyNo=Case When Cover.OpenFlag=1 and Acceptance.BulkF=0 Then Acceptance.PolicyNo+Case When Acceptance.CertificateNo<>'' Then '-'+Acceptance.CertificateNo else '' end else Acceptance.PolicyNo end,  
@P_OANO=Acceptance.OANO,
@P_LANO=Acceptance.LANO,
@P_MOANO=MAcceptance.OANO
from Acceptance
Inner Join Cover on (Cover.CNO=Acceptance.CNO)
Left Join Acceptance mAcceptance on (mAcceptance.ANO=mAcceptance.LANO and mAcceptance.ANO=Acceptance.LANO)  
Where Cover.CNO=Acceptance.CNO and Acceptance.ANO=@P_ANO 


if @P_ANO<>@P_LANO
       Select   
       @P_MinAdmNo=coalesce(Min(Admlink.AdmNo),0),
       @P_MaxAdmNo=coalesce(Max(Admlink.AdmNo),0)
       from Admlink
       Inner Join AccAss on (AccAss.AdmNo=Admlink.AdmNo)
       Inner Join Acceptance on (Acceptance.ANO=AccAss.ANO)
       Inner Join Acceptance oAcceptance on (oAcceptance.oANO=Acceptance.oANO)
       Where OAcceptance.OANO=@P_OANO and Admlink.A_PolicyNo=@P_APolicyNo and Admlink.Subject='Premium' and Admlink.Type in ('DI','IC','IR') and Admlink.Date<=@P_PDate
else
       Select   
       @P_MinAdmNo=coalesce(Min(Admlink.AdmNo),0),
       @P_MaxAdmNo=coalesce(Max(Admlink.AdmNo),0)
       from 
       Admlink
       Inner Join AccAss on (AccAss.AdmNo=Admlink.AdmNo)
       Inner Join Acceptance on (Acceptance.ANO=AccAss.ANO)
       Inner Join Acceptance oAcceptance on (oAcceptance.oANO=Acceptance.oANO)
       Inner Join Acceptance mAcceptance on (mAcceptance.ANO=oAcceptance.LANO)
       Where mAcceptance.OANO=@P_MOANO and Admlink.A_PolicyNo=@P_APolicyNo and Admlink.Subject='Premium' and Admlink.Type in ('DI','IC','IR') and Admlink.Date<=@P_PDate

Select
V.Currency,
V.Voucher,
Max(Currency.Rate) as Rate,
Max(coalesce(AProfile.Name, Admlink.Remarks)) as InsuredName,
Max(TOC.PolicyTitle) as PolicyTitle,
Max(Admlink.Bank) as Bank, 
Max(Admlink.BankAccount) as BankAccount, 
Max(Admlink.AccountNo) as AccountNo,
Round(Max
(
CASE WHEN V.DEBTORF=1 THEN 1 Else -1 END*
((Case 
When V.Installment=0 Then V.Nominal_CC-V.Diff_CC 
When V.Installment>=1 and @P_PDate<=V.DueDate_1 Then V.AmountDue_1 
When V.Installment>=2 and @P_PDate<=V.DueDate_2 Then V.AmountDue_1+V.AmountDue_2 
When V.Installment>=3 and @P_PDate<=V.DueDate_3 Then V.AmountDue_1+V.AmountDue_2+V.AmountDue_3 
When V.Installment>=4 and @P_PDate<=V.DueDate_4 Then V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4 
When V.Installment>=5 and @P_PDate<=V.DueDate_5 Then V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5 
When V.Installment>=6 and @P_PDate<=V.DueDate_6 Then V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6 
When V.Installment>=7 and @P_PDate<=V.DueDate_7 Then V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7 
When V.Installment>=8 and @P_PDate<=V.DueDate_8 Then V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8 
When V.Installment>=9 and @P_PDate<=V.DueDate_9 Then V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9 
When V.Installment>=10 and @P_PDate<=V.DueDate_10 Then V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10 
When V.Installment>=11 and @P_PDate<=V.DueDate_11 Then V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11 
When V.Installment>=12 and @P_PDate<=V.DueDate_12 Then V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12 
When V.Installment>=13 and @P_PDate<=V.DueDate_13 Then V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13 
When V.Installment>=14 and @P_PDate<=V.DueDate_14 Then V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14
When V.Installment>=15 and @P_PDate<=V.DueDate_15 Then V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15 
When V.Installment>=16 and @P_PDate<=V.DueDate_16 Then V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16 
When V.Installment>=17 and @P_PDate<=V.DueDate_17 Then V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16+V.AmountDue_17 
When V.Installment>=18 and @P_PDate<=V.DueDate_18 Then V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16+V.AmountDue_17+V.AmountDue_18 
When V.Installment>=19 and @P_PDate<=V.DueDate_19 Then V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16+V.AmountDue_17+V.AmountDue_18+V.AmountDue_19 
When V.Installment>=20 and @P_PDate<=V.DueDate_20 Then V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16+V.AmountDue_17+V.AmountDue_18+V.AmountDue_19+V.AmountDue_20 
When V.Installment>=21 and @P_PDate<=V.DueDate_21 Then V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16+V.AmountDue_17+V.AmountDue_18+V.AmountDue_19+V.AmountDue_20+V.AmountDue_21 
When V.Installment>=22 and @P_PDate<=V.DueDate_22 Then V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16+V.AmountDue_17+V.AmountDue_18+V.AmountDue_19+V.AmountDue_20+V.AmountDue_21+V.AmountDue_22 
When V.Installment>=23 and @P_PDate<=V.DueDate_23 Then V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16+V.AmountDue_17+V.AmountDue_18+V.AmountDue_19+V.AmountDue_20+V.AmountDue_21+V.AmountDue_22+V.AmountDue_23 
When V.Installment>=24 and @P_PDate<=V.DueDate_24 Then V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16+V.AmountDue_17+V.AmountDue_18+V.AmountDue_19+V.AmountDue_20+V.AmountDue_21+V.AmountDue_22+V.AmountDue_23+V.AmountDue_24 else V.Nominal_CC-V.Diff_CC end)-V.Payment_CC)),4) as AmountDue,
Max
(
Case 
When V.Installment=0 Then V.DueDate
When V.Installment>=1 and @P_PDate<=V.DueDate_1 Then V.DueDate_1
When V.Installment>=2 and @P_PDate<=V.DueDate_2 Then V.DueDate_2
When V.Installment>=3 and @P_PDate<=V.DueDate_3 Then V.DueDate_3
When V.Installment>=4 and @P_PDate<=V.DueDate_4 Then V.DueDate_4
When V.Installment>=5 and @P_PDate<=V.DueDate_5 Then V.DueDate_5
When V.Installment>=6 and @P_PDate<=V.DueDate_6 Then V.DueDate_6
When V.Installment>=7 and @P_PDate<=V.DueDate_7 Then V.DueDate_7
When V.Installment>=8 and @P_PDate<=V.DueDate_8 Then V.DueDate_8
When V.Installment>=9 and @P_PDate<=V.DueDate_9 Then V.DueDate_9
When V.Installment>=10 and @P_PDate<=V.DueDate_10 Then V.DueDate_10
When V.Installment>=11 and @P_PDate<=V.DueDate_11 Then V.DueDate_11
When V.Installment>=12 and @P_PDate<=V.DueDate_12 Then V.DueDate_12
When V.Installment>=13 and @P_PDate<=V.DueDate_13 Then V.DueDate_13
When V.Installment>=14 and @P_PDate<=V.DueDate_14 Then V.DueDate_14
When V.Installment>=15 and @P_PDate<=V.DueDate_15 Then V.DueDate_15
When V.Installment>=16 and @P_PDate<=V.DueDate_16 Then V.DueDate_16
When V.Installment>=17 and @P_PDate<=V.DueDate_17 Then V.DueDate_17
When V.Installment>=18 and @P_PDate<=V.DueDate_18 Then V.DueDate_18
When V.Installment>=19 and @P_PDate<=V.DueDate_19 Then V.DueDate_19
When V.Installment>=20 and @P_PDate<=V.DueDate_20 Then V.DueDate_20
When V.Installment>=21 and @P_PDate<=V.DueDate_21 Then V.DueDate_21
When V.Installment>=22 and @P_PDate<=V.DueDate_22 Then V.DueDate_22
When V.Installment>=23 and @P_PDate<=V.DueDate_23 Then V.DueDate_23
When V.Installment>=24 and @P_PDate<=V.DueDate_24 Then V.DueDate_24
Else Null end
) as DueDate
FROM Admlink 
Inner Join nVoucher V on (V.Voucher=Admlink.Voucher)   
Inner Join fn_Exchange(@P_PDate) Currency on (Currency.Currency=Admlink.Currency)
Left Join Profile AProfile on (AProfile.ID=Admlink.A_ID)
Inner Join TOC on (TOC.TOC=Admlink.Code)
Where ((V.Nominal_CC-V.Diff_CC-V.Payment_CC-V.Payment_OC)<>0 or V.PDate>=@P_PDate) 
and Admlink.A_PolicyNo=@P_APolicyNo and Admlink.Subject='Premium' and Admlink.Type in ('DI','IC','IR') and Admlink.Date<=@P_PDate
and (@P_MinAdmNo=0 or Admlink.AdmNo>=@P_MinAdmNo)
and (@P_MaxAdmno=0 or Admlink.AdmNo<=@P_MaxAdmNo)
Group by V.Currency,V.Voucher
Having 
Round(Max
(
CASE WHEN V.DEBTORF=1 THEN 1 Else -1 END*
((Case 
When V.Installment=0 Then V.Nominal_CC-V.Diff_CC 
When V.Installment>=1 and @P_PDate<=V.DueDate_1 Then V.AmountDue_1 
When V.Installment>=2 and @P_PDate<=V.DueDate_2 Then V.AmountDue_1+V.AmountDue_2 
When V.Installment>=3 and @P_PDate<=V.DueDate_3 Then V.AmountDue_1+V.AmountDue_2+V.AmountDue_3 
When V.Installment>=4 and @P_PDate<=V.DueDate_4 Then V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4 
When V.Installment>=5 and @P_PDate<=V.DueDate_5 Then V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5 
When V.Installment>=6 and @P_PDate<=V.DueDate_6 Then V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6 
When V.Installment>=7 and @P_PDate<=V.DueDate_7 Then V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7 
When V.Installment>=8 and @P_PDate<=V.DueDate_8 Then V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8 
When V.Installment>=9 and @P_PDate<=V.DueDate_9 Then V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9 
When V.Installment>=10 and @P_PDate<=V.DueDate_10 Then V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10 
When V.Installment>=11 and @P_PDate<=V.DueDate_11 Then V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11 
When V.Installment>=12 and @P_PDate<=V.DueDate_12 Then V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12 
When V.Installment>=13 and @P_PDate<=V.DueDate_13 Then V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13 
When V.Installment>=14 and @P_PDate<=V.DueDate_14 Then V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14 
When V.Installment>=15 and @P_PDate<=V.DueDate_15 Then V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15 
When V.Installment>=16 and @P_PDate<=V.DueDate_16 Then V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16 
When V.Installment>=17 and @P_PDate<=V.DueDate_17 Then V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16+V.AmountDue_17 
When V.Installment>=18 and @P_PDate<=V.DueDate_18 Then V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16+V.AmountDue_17+V.AmountDue_18 
When V.Installment>=19 and @P_PDate<=V.DueDate_19 Then V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16+V.AmountDue_17+V.AmountDue_18+V.AmountDue_19 
When V.Installment>=20 and @P_PDate<=V.DueDate_20 Then V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16+V.AmountDue_17+V.AmountDue_18+V.AmountDue_19+V.AmountDue_20 
When V.Installment>=21 and @P_PDate<=V.DueDate_21 Then V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16+V.AmountDue_17+V.AmountDue_18+V.AmountDue_19+V.AmountDue_20+V.AmountDue_21 
When V.Installment>=22 and @P_PDate<=V.DueDate_22 Then V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16+V.AmountDue_17+V.AmountDue_18+V.AmountDue_19+V.AmountDue_20+V.AmountDue_21+V.AmountDue_22 
When V.Installment>=23 and @P_PDate<=V.DueDate_23 Then V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16+V.AmountDue_17+V.AmountDue_18+V.AmountDue_19+V.AmountDue_20+V.AmountDue_21+V.AmountDue_22+V.AmountDue_23 
When V.Installment>=24 and @P_PDate<=V.DueDate_24 Then V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16+V.AmountDue_17+V.AmountDue_18+V.AmountDue_19+V.AmountDue_20+V.AmountDue_21+V.AmountDue_22+V.AmountDue_23+V.AmountDue_24 else V.Nominal_CC-V.Diff_CC end)-V.Payment_CC)
),4)>=0


GO




 insert into PatchVersioning
select '202 Update Script - Patch 2022 (17)',GETDATE()
go


Declare @PrevScript varchar(100)
Declare @CurrScript varchar(100)

Select @PrevScript=''
Select @CurrSCript='202 Update Script - Patch 2022 (17)'


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