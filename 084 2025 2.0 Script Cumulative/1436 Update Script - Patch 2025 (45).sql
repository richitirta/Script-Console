SET QUOTED_IDENTIFIER ON
SET ARITHABORT ON
SET NUMERIC_ROUNDABORT OFF
SET CONCAT_NULL_YIELDS_NULL ON
SET ANSI_NULLS ON
SET ANSI_PADDING ON
SET ANSI_WARNINGS ON

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'VOUCHER_AMOUNTWPCDUE') AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) )
BEGIN DROP FUNCTION VOUCHER_AMOUNTWPCDUE END
GO

CREATE function VOUCHER_AMOUNTWPCDUE(@P_Date as smalldatetime) 
RETURNS Table 
AS RETURN 
( 
Select V.Voucher, V.Remarks, V.CollNo, V.Branch, V.ProAcc, V.RefNo, V.DocNo, V.Currency, V.Installment, V.Nominal_CC, V.Diff_CC, (V.Payment_CC+V.Payment_OC) as Payment_CC, cast(0 as Float) as Payment_OC,  V.DebtorF, V.CreditorF, V.StatID, V.ActionBy, V.ActionDate,  V.AcceptedBy, V.AcceptedDate, 
(Case When V.Installment=0 and dateadd(day, A.WPC, V.DueDate) <=@P_Date Then V.Nominal_CC-V.Diff_CC else 0 end+ 
Case When V.Installment>=1 and V.DueDate_1 <=@P_Date Then V.AmountDue_1 else 0 end+ 
Case When V.Installment>=2 and V.DueDate_2 <=@P_Date Then V.AmountDue_2 else 0 end+ 
Case When V.Installment>=3 and V.DueDate_3 <=@P_Date Then V.AmountDue_3 else 0 end+ 
Case When V.Installment>=4 and V.DueDate_4 <=@P_Date Then V.AmountDue_4 else 0 end+ 
Case When V.Installment>=5 and V.DueDate_5 <=@P_Date Then V.AmountDue_5 else 0 end+ 
Case When V.Installment>=6 and V.DueDate_6 <=@P_Date Then V.AmountDue_6 else 0 end+ 
Case When V.Installment>=7 and V.DueDate_7 <=@P_Date Then V.AmountDue_7 else 0 end+ 
Case When V.Installment>=8 and V.DueDate_8 <=@P_Date Then V.AmountDue_8 else 0 end+ 
Case When V.Installment>=9 and V.DueDate_9 <=@P_Date Then V.AmountDue_9 else 0 end+ 
Case When V.Installment>=10 and V.DueDate_10 <=@P_Date Then V.AmountDue_10 else 0 end+ 
Case When V.Installment>=11 and V.DueDate_11 <=@P_Date Then V.AmountDue_11 else 0 end+ 
Case When V.Installment>=12 and V.DueDate_12 <=@P_Date Then V.AmountDue_12 else 0 end+ 
Case When V.Installment>=13 and V.DueDate_13 <=@P_Date Then V.AmountDue_13 else 0 end+ 
Case When V.Installment>=14 and V.DueDate_14 <=@P_Date Then V.AmountDue_14 else 0 end+ 
Case When V.Installment>=15 and V.DueDate_15 <=@P_Date Then V.AmountDue_15 else 0 end+ 
Case When V.Installment>=16 and V.DueDate_16 <=@P_Date Then V.AmountDue_16 else 0 end+ 
Case When V.Installment>=17 and V.DueDate_17 <=@P_Date Then V.AmountDue_17 else 0 end+ 
Case When V.Installment>=18 and V.DueDate_18 <=@P_Date Then V.AmountDue_18 else 0 end+ 
Case When V.Installment>=19 and V.DueDate_19 <=@P_Date Then V.AmountDue_19 else 0 end+ 
Case When V.Installment>=20 and V.DueDate_20 <=@P_Date Then V.AmountDue_20 else 0 end+ 
Case When V.Installment>=21 and V.DueDate_21 <=@P_Date Then V.AmountDue_21 else 0 end+ 
Case When V.Installment>=22 and V.DueDate_22 <=@P_Date Then V.AmountDue_22 else 0 end+ 
Case When V.Installment>=23 and V.DueDate_23 <=@P_Date Then V.AmountDue_23 else 0 end+ 
Case When V.Installment>=24 and V.DueDate_24 <=@P_Date Then V.AmountDue_24 else 0 end) as AmountDue, 

Case When V.Installment=0 then 0
When (V.Payment_CC+V.Payment_OC)<(V.AmountDue_1) then (V.AmountDue_1)-(V.Payment_CC+V.Payment_OC)
When (V.Payment_CC+V.Payment_OC)<(V.AmountDue_1+V.AmountDue_2) then (V.AmountDue_1+V.AmountDue_2)-(V.Payment_CC+V.Payment_OC)
When (V.Payment_CC+V.Payment_OC)<(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3) then (V.AmountDue_1+V.AmountDue_2+V.AmountDue_3)-(V.Payment_CC+V.Payment_OC)
When (V.Payment_CC+V.Payment_OC)<(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4) then (V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4)-(V.Payment_CC+V.Payment_OC)
When (V.Payment_CC+V.Payment_OC)<(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5) then (V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5)-(V.Payment_CC+V.Payment_OC)
When (V.Payment_CC+V.Payment_OC)<(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6) then (V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6)-(V.Payment_CC+V.Payment_OC)
When (V.Payment_CC+V.Payment_OC)<(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7) then (V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7)-(V.Payment_CC+V.Payment_OC)
When (V.Payment_CC+V.Payment_OC)<(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8) then (V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8)-(V.Payment_CC+V.Payment_OC)
When (V.Payment_CC+V.Payment_OC)<(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9) then (V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9)-(V.Payment_CC+V.Payment_OC)
When (V.Payment_CC+V.Payment_OC)<(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10) then (V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10)-(V.Payment_CC+V.Payment_OC)
When (V.Payment_CC+V.Payment_OC)<(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11) then (V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11)-(V.Payment_CC+V.Payment_OC)
When (V.Payment_CC+V.Payment_OC)<(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12) then (V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12)-(V.Payment_CC+V.Payment_OC)
When (V.Payment_CC+V.Payment_OC)<(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13) then (V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13)-(V.Payment_CC+V.Payment_OC)
When (V.Payment_CC+V.Payment_OC)<(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14) then (V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14)-(V.Payment_CC+V.Payment_OC)
When (V.Payment_CC+V.Payment_OC)<(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15) then (V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15)-(V.Payment_CC+V.Payment_OC)
When (V.Payment_CC+V.Payment_OC)<(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16) then (V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16)-(V.Payment_CC+V.Payment_OC)
When (V.Payment_CC+V.Payment_OC)<(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16+V.AmountDue_17) then (V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16+V.AmountDue_17)-(V.Payment_CC+V.Payment_OC)
When (V.Payment_CC+V.Payment_OC)<(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16+V.AmountDue_17+V.AmountDue_18) then (V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16+V.AmountDue_17+V.AmountDue_18)-(V.Payment_CC+V.Payment_OC)
When (V.Payment_CC+V.Payment_OC)<(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16+V.AmountDue_17+V.AmountDue_18+V.AmountDue_19) then (V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16+V.AmountDue_17+V.AmountDue_18+V.AmountDue_19)-(V.Payment_CC+V.Payment_OC)
When (V.Payment_CC+V.Payment_OC)<(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16+V.AmountDue_17+V.AmountDue_18+V.AmountDue_19+V.AmountDue_20) then (V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16+V.AmountDue_17+V.AmountDue_18+V.AmountDue_19+V.AmountDue_20)-(V.Payment_CC+V.Payment_OC)
When (V.Payment_CC+V.Payment_OC)<(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16+V.AmountDue_17+V.AmountDue_18+V.AmountDue_19+V.AmountDue_20+V.AmountDue_21) then (V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16+V.AmountDue_17+V.AmountDue_18+V.AmountDue_19+V.AmountDue_20+V.AmountDue_21)-(V.Payment_CC+V.Payment_OC)
When (V.Payment_CC+V.Payment_OC)<(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16+V.AmountDue_17+V.AmountDue_18+V.AmountDue_19+V.AmountDue_20+V.AmountDue_21+V.AmountDue_22) then (V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16+V.AmountDue_17+V.AmountDue_18+V.AmountDue_19+V.AmountDue_20+V.AmountDue_21+V.AmountDue_22)-(V.Payment_CC+V.Payment_OC)
When (V.Payment_CC+V.Payment_OC)<(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16+V.AmountDue_17+V.AmountDue_18+V.AmountDue_19+V.AmountDue_20+V.AmountDue_21+V.AmountDue_22+V.AmountDue_23) then (V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16+V.AmountDue_17+V.AmountDue_18+V.AmountDue_19+V.AmountDue_20+V.AmountDue_21+V.AmountDue_22+V.AmountDue_23)-(V.Payment_CC+V.Payment_OC)
Else 0
end as AmountNextDue, 

Case 
When V.Installment>=1 and V.DueDate_1 <=@P_Date and (V.Payment_CC+V.Payment_OC)<V.AmountDue_1 then V.DueDate_1 
When V.Installment>=2 and V.DueDate_2 <=@P_Date and (V.Payment_CC+V.Payment_OC)<V.AmountDue_1+V.AmountDue_2 then V.DueDate_2 
When V.Installment>=3 and V.DueDate_3 <=@P_Date and (V.Payment_CC+V.Payment_OC)<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3 then V.DueDate_3 
When V.Installment>=4 and V.DueDate_4 <=@P_Date and (V.Payment_CC+V.Payment_OC)<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4 then V.DueDate_4 
When V.Installment>=5 and V.DueDate_5 <=@P_Date and (V.Payment_CC+V.Payment_OC)<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5 then V.DueDate_5 
When V.Installment>=6 and V.DueDate_6 <=@P_Date and (V.Payment_CC+V.Payment_OC)<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6 then V.DueDate_6 
When V.Installment>=7 and V.DueDate_7 <=@P_Date and (V.Payment_CC+V.Payment_OC)<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7 then V.DueDate_7 
When V.Installment>=8 and V.DueDate_8 <=@P_Date and (V.Payment_CC+V.Payment_OC)<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8 then V.DueDate_8 
When V.Installment>=9 and V.DueDate_9 <=@P_Date and (V.Payment_CC+V.Payment_OC)<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9 then V.DueDate_9 
When V.Installment>=10 and V.DueDate_10 <=@P_Date and (V.Payment_CC+V.Payment_OC)<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10 then V.DueDate_10 
When V.Installment>=11 and V.DueDate_11 <=@P_Date and (V.Payment_CC+V.Payment_OC)<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11 then V.DueDate_11 
When V.Installment>=12 and V.DueDate_12 <=@P_Date and (V.Payment_CC+V.Payment_OC)<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12 then V.DueDate_12 
When V.Installment>=13 and V.DueDate_13 <=@P_Date and (V.Payment_CC+V.Payment_OC)<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13 then V.DueDate_13 
When V.Installment>=14 and V.DueDate_14 <=@P_Date and (V.Payment_CC+V.Payment_OC)<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14 then V.DueDate_14 
When V.Installment>=15 and V.DueDate_15 <=@P_Date and (V.Payment_CC+V.Payment_OC)<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15 then V.DueDate_15 
When V.Installment>=16 and V.DueDate_16 <=@P_Date and (V.Payment_CC+V.Payment_OC)<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16 then V.DueDate_16 
When V.Installment>=17 and V.DueDate_17 <=@P_Date and (V.Payment_CC+V.Payment_OC)<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16+V.AmountDue_17 then V.DueDate_17 
When V.Installment>=18 and V.DueDate_18 <=@P_Date and (V.Payment_CC+V.Payment_OC)<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16+V.AmountDue_17+V.AmountDue_18 then V.DueDate_18 
When V.Installment>=19 and V.DueDate_19 <=@P_Date and (V.Payment_CC+V.Payment_OC)<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16+V.AmountDue_17+V.AmountDue_18+V.AmountDue_19 then V.DueDate_19 
When V.Installment>=20 and V.DueDate_20 <=@P_Date and (V.Payment_CC+V.Payment_OC)<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16+V.AmountDue_17+V.AmountDue_18+V.AmountDue_19+V.AmountDue_20 then V.DueDate_20 
When V.Installment>=21 and V.DueDate_21 <=@P_Date and (V.Payment_CC+V.Payment_OC)<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16+V.AmountDue_17+V.AmountDue_18+V.AmountDue_19+V.AmountDue_20+V.AmountDue_21 then V.DueDate_21 
When V.Installment>=22 and V.DueDate_22 <=@P_Date and (V.Payment_CC+V.Payment_OC)<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16+V.AmountDue_17+V.AmountDue_18+V.AmountDue_19+V.AmountDue_20+V.AmountDue_21+V.AmountDue_22 then V.DueDate_22 
When V.Installment>=23 and V.DueDate_23 <=@P_Date and (V.Payment_CC+V.Payment_OC)<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16+V.AmountDue_17+V.AmountDue_18+V.AmountDue_19+V.AmountDue_20+V.AmountDue_21+V.AmountDue_22+V.AmountDue_23 then V.DueDate_23 
When V.Installment>=24 and V.DueDate_24 <=@P_Date and (V.Payment_CC+V.Payment_OC)<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16+V.AmountDue_17+V.AmountDue_18+V.AmountDue_19+V.AmountDue_20+V.AmountDue_21+V.AmountDue_22+V.AmountDue_23+V.AmountDue_24 then V.DueDate_24
Else 
	Case 
	When V.Installment<>0 Then NULL
	else
		dateadd(day, A.WPC, V.DueDate)
	End
end as DueDate, 


Case 
When V.Installment>=24 and V.DueDate_24 <=@P_Date then V.DueDate_24
When V.Installment>=23 and V.DueDate_23 <=@P_Date then V.DueDate_23
When V.Installment>=22 and V.DueDate_22 <=@P_Date then V.DueDate_22
When V.Installment>=21 and V.DueDate_21 <=@P_Date then V.DueDate_21
When V.Installment>=20 and V.DueDate_20 <=@P_Date then V.DueDate_20
When V.Installment>=19 and V.DueDate_19 <=@P_Date then V.DueDate_19
When V.Installment>=18 and V.DueDate_18 <=@P_Date then V.DueDate_18
When V.Installment>=17 and V.DueDate_17 <=@P_Date then V.DueDate_17
When V.Installment>=16 and V.DueDate_16 <=@P_Date then V.DueDate_16
When V.Installment>=15 and V.DueDate_15 <=@P_Date then V.DueDate_15
When V.Installment>=14 and V.DueDate_14 <=@P_Date then V.DueDate_14
When V.Installment>=13 and V.DueDate_13 <=@P_Date then V.DueDate_13
When V.Installment>=12 and V.DueDate_12 <=@P_Date then V.DueDate_12
When V.Installment>=11 and V.DueDate_11 <=@P_Date then V.DueDate_11
When V.Installment>=10 and V.DueDate_10 <=@P_Date then V.DueDate_10
When V.Installment>=9 and V.DueDate_9 <=@P_Date then V.DueDate_9
When V.Installment>=8 and V.DueDate_8 <=@P_Date then V.DueDate_8
When V.Installment>=7 and V.DueDate_7 <=@P_Date then V.DueDate_7
When V.Installment>=6 and V.DueDate_6 <=@P_Date then V.DueDate_6
When V.Installment>=5 and V.DueDate_5 <=@P_Date then V.DueDate_5
When V.Installment>=4 and V.DueDate_4 <=@P_Date then V.DueDate_4
When V.Installment>=3 and V.DueDate_3 <=@P_Date then V.DueDate_3
When V.Installment>=2 and V.DueDate_2 <=@P_Date then V.DueDate_2
When V.Installment>=1 and V.DueDate_1 <=@P_Date then V.DueDate_1
Else 
	Case 
	When V.Installment<>0 Then NULL
	else
		dateadd(day, A.WPC, V.DueDate)
	End
end as LastDueDate, 

Case When V.INSTALLMENT=0 Then (V.Nominal_CC-V.Diff_CC)-(V.Payment_CC+V.Payment_OC) else 0 end as Outstanding_0,

Case 
When V.AmountDue_1<(V.Payment_CC+V.Payment_OC) Then 0
else V.AmountDue_1-(V.Payment_CC+V.Payment_OC) end 
+
Case WHen V.Installment=1 and (V.Payment_CC+V.Payment_OC)>(V.Nominal_CC-V.Diff_CC) Then (V.Nominal_CC-V.Diff_CC)-(V.Payment_CC+V.Payment_OC) else 0 end
as Outstanding_1,

Case 
When V.AmountDue_2<((V.Payment_CC+V.Payment_OC)-V.AmountDue_1) Then 0
When ((V.Payment_CC+V.Payment_OC)-V.AmountDue_1)<0 then V.AmountDue_2
else V.AmountDue_2-((V.Payment_CC+V.Payment_OC)-V.AmountDue_1) end 
+
Case WHen V.Installment=2 and (V.Payment_CC+V.Payment_OC)>(V.Nominal_CC-V.Diff_CC) Then (V.Nominal_CC-V.Diff_CC)-(V.Payment_CC+V.Payment_OC) else 0 end
as Outstanding_2,

Case 
When V.AmountDue_3<((V.Payment_CC+V.Payment_OC)-(V.AmountDue_1+V.AmountDue_2)) Then 0
When ((V.Payment_CC+V.Payment_OC)-(V.AmountDue_1+V.AmountDue_2))<0 then V.AmountDue_3
else V.AmountDue_3-((V.Payment_CC+V.Payment_OC)-(V.AmountDue_1+V.AmountDue_2)) end 
+
Case WHen V.Installment=3 and (V.Payment_CC+V.Payment_OC)>(V.Nominal_CC-V.Diff_CC) Then (V.Nominal_CC-V.Diff_CC)-(V.Payment_CC+V.Payment_OC) else 0 end
as Outstanding_3,

Case 
When V.AmountDue_4<((V.Payment_CC+V.Payment_OC)-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3)) Then 0
When ((V.Payment_CC+V.Payment_OC)-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3))<0 then V.AmountDue_4
else V.AmountDue_4-((V.Payment_CC+V.Payment_OC)-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3)) end 
+
Case WHen V.Installment=4 and (V.Payment_CC+V.Payment_OC)>(V.Nominal_CC-V.Diff_CC) Then (V.Nominal_CC-V.Diff_CC)-(V.Payment_CC+V.Payment_OC) else 0 end
as Outstanding_4,

Case 
When V.AmountDue_5<((V.Payment_CC+V.Payment_OC)-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4)) Then 0
When ((V.Payment_CC+V.Payment_OC)-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4))<0 then V.AmountDue_5
else V.AmountDue_5-((V.Payment_CC+V.Payment_OC)-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4)) end 
+
Case WHen V.Installment=5 and (V.Payment_CC+V.Payment_OC)>(V.Nominal_CC-V.Diff_CC) Then (V.Nominal_CC-V.Diff_CC)-(V.Payment_CC+V.Payment_OC) else 0 end
as Outstanding_5,

Case 
When V.AmountDue_6<((V.Payment_CC+V.Payment_OC)-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5)) Then 0
When ((V.Payment_CC+V.Payment_OC)-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5))<0 then V.AmountDue_6
else V.AmountDue_6-((V.Payment_CC+V.Payment_OC)-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5)) end 
+
Case WHen V.Installment=6 and (V.Payment_CC+V.Payment_OC)>(V.Nominal_CC-V.Diff_CC) Then (V.Nominal_CC-V.Diff_CC)-(V.Payment_CC+V.Payment_OC) else 0 end
as Outstanding_6,

Case 
When V.AmountDue_7<((V.Payment_CC+V.Payment_OC)-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6)) Then 0
When ((V.Payment_CC+V.Payment_OC)-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6))<0 then V.AmountDue_7
else V.AmountDue_7-((V.Payment_CC+V.Payment_OC)-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6)) end 
+
Case WHen V.Installment=7 and (V.Payment_CC+V.Payment_OC)>(V.Nominal_CC-V.Diff_CC) Then (V.Nominal_CC-V.Diff_CC)-(V.Payment_CC+V.Payment_OC) else 0 end
as Outstanding_7,

Case 
When V.AmountDue_8<((V.Payment_CC+V.Payment_OC)-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7)) Then 0
When ((V.Payment_CC+V.Payment_OC)-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7))<0 then V.AmountDue_8
else V.AmountDue_8-((V.Payment_CC+V.Payment_OC)-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7)) end 
+
Case WHen V.Installment=8 and (V.Payment_CC+V.Payment_OC)>(V.Nominal_CC-V.Diff_CC) Then (V.Nominal_CC-V.Diff_CC)-(V.Payment_CC+V.Payment_OC) else 0 end
as Outstanding_8,

Case 
When V.AmountDue_9<((V.Payment_CC+V.Payment_OC)-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8)) Then 0
When ((V.Payment_CC+V.Payment_OC)-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8))<0 then V.AmountDue_9
else V.AmountDue_9-((V.Payment_CC+V.Payment_OC)-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8)) end 
+
Case WHen V.Installment=9 and (V.Payment_CC+V.Payment_OC)>(V.Nominal_CC-V.Diff_CC) Then (V.Nominal_CC-V.Diff_CC)-(V.Payment_CC+V.Payment_OC) else 0 end
as Outstanding_9,

Case 
When V.AmountDue_10<((V.Payment_CC+V.Payment_OC)-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9)) Then 0
When ((V.Payment_CC+V.Payment_OC)-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9))<0 then V.AmountDue_10
else V.AmountDue_10-((V.Payment_CC+V.Payment_OC)-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9)) end 
+
Case WHen V.Installment=10 and (V.Payment_CC+V.Payment_OC)>(V.Nominal_CC-V.Diff_CC) Then (V.Nominal_CC-V.Diff_CC)-(V.Payment_CC+V.Payment_OC) else 0 end
as Outstanding_10,

Case 
When V.AmountDue_11<((V.Payment_CC+V.Payment_OC)-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10)) Then 0
When ((V.Payment_CC+V.Payment_OC)-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10))<0 then V.AmountDue_11
else V.AmountDue_11-((V.Payment_CC+V.Payment_OC)-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10)) end 
+
Case WHen V.Installment=11 and (V.Payment_CC+V.Payment_OC)>(V.Nominal_CC-V.Diff_CC) Then (V.Nominal_CC-V.Diff_CC)-(V.Payment_CC+V.Payment_OC) else 0 end
as Outstanding_11,
  
Case 
When V.AmountDue_12<((V.Payment_CC+V.Payment_OC)-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11)) Then 0
When ((V.Payment_CC+V.Payment_OC)-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11))<0 then V.AmountDue_12
else V.AmountDue_12-((V.Payment_CC+V.Payment_OC)-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11)) end 
+
Case WHen V.Installment=12 and (V.Payment_CC+V.Payment_OC)>(V.Nominal_CC-V.Diff_CC) Then (V.Nominal_CC-V.Diff_CC)-(V.Payment_CC+V.Payment_OC) else 0 end
as Outstanding_12,

Case 
When V.AmountDue_13<((V.Payment_CC+V.Payment_OC)-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12)) Then 0
When ((V.Payment_CC+V.Payment_OC)-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12))<0 then V.AmountDue_13
else V.AmountDue_13-((V.Payment_CC+V.Payment_OC)-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12)) end 
+
Case WHen V.Installment=13 and (V.Payment_CC+V.Payment_OC)>(V.Nominal_CC-V.Diff_CC) Then (V.Nominal_CC-V.Diff_CC)-(V.Payment_CC+V.Payment_OC) else 0 end
as Outstanding_13,

Case 
When V.AmountDue_14<((V.Payment_CC+V.Payment_OC)-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13)) Then 0
When ((V.Payment_CC+V.Payment_OC)-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13))<0 then V.AmountDue_14
else V.AmountDue_14-((V.Payment_CC+V.Payment_OC)-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13)) end 
+
Case WHen V.Installment=14 and (V.Payment_CC+V.Payment_OC)>(V.Nominal_CC-V.Diff_CC) Then (V.Nominal_CC-V.Diff_CC)-(V.Payment_CC+V.Payment_OC) else 0 end
as Outstanding_14, 
 
Case 
When V.AmountDue_15<((V.Payment_CC+V.Payment_OC)-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14)) Then 0
When ((V.Payment_CC+V.Payment_OC)-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14))<0 then V.AmountDue_15
else V.AmountDue_15-((V.Payment_CC+V.Payment_OC)-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14)) end 
+
Case WHen V.Installment=15 and (V.Payment_CC+V.Payment_OC)>(V.Nominal_CC-V.Diff_CC) Then (V.Nominal_CC-V.Diff_CC)-(V.Payment_CC+V.Payment_OC) else 0 end
as Outstanding_15, 
 
Case 
When V.AmountDue_16<((V.Payment_CC+V.Payment_OC)-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15)) Then 0
When ((V.Payment_CC+V.Payment_OC)-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15))<0 then V.AmountDue_16
else V.AmountDue_16-((V.Payment_CC+V.Payment_OC)-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15)) end 
+
Case WHen V.Installment=16 and (V.Payment_CC+V.Payment_OC)>(V.Nominal_CC-V.Diff_CC) Then (V.Nominal_CC-V.Diff_CC)-(V.Payment_CC+V.Payment_OC) else 0 end
as Outstanding_16, 

Case 
When V.AmountDue_17<((V.Payment_CC+V.Payment_OC)-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16)) Then 0
When ((V.Payment_CC+V.Payment_OC)-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16))<0 then V.AmountDue_17
else V.AmountDue_17-((V.Payment_CC+V.Payment_OC)-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16)) end 
+
Case WHen V.Installment=17 and (V.Payment_CC+V.Payment_OC)>(V.Nominal_CC-V.Diff_CC) Then (V.Nominal_CC-V.Diff_CC)-(V.Payment_CC+V.Payment_OC) else 0 end
as Outstanding_17, 

Case 
When V.AmountDue_18<((V.Payment_CC+V.Payment_OC)-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16+V.AmountDue_17)) Then 0
When ((V.Payment_CC+V.Payment_OC)-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16+V.AmountDue_17))<0 then V.AmountDue_18
else V.AmountDue_18-((V.Payment_CC+V.Payment_OC)-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16+V.AmountDue_17)) end 
+
Case WHen V.Installment=18 and (V.Payment_CC+V.Payment_OC)>(V.Nominal_CC-V.Diff_CC) Then (V.Nominal_CC-V.Diff_CC)-(V.Payment_CC+V.Payment_OC) else 0 end
as Outstanding_18, 

Case 
When V.AmountDue_19<((V.Payment_CC+V.Payment_OC)-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16+V.AmountDue_17+V.AmountDue_18)) Then 0
When ((V.Payment_CC+V.Payment_OC)-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16+V.AmountDue_17+V.AmountDue_18))<0 then V.AmountDue_19
else V.AmountDue_19-((V.Payment_CC+V.Payment_OC)-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16+V.AmountDue_17+V.AmountDue_18)) end 
+
Case WHen V.Installment=19 and (V.Payment_CC+V.Payment_OC)>(V.Nominal_CC-V.Diff_CC) Then (V.Nominal_CC-V.Diff_CC)-(V.Payment_CC+V.Payment_OC) else 0 end
as Outstanding_19, 

Case 
When V.AmountDue_20<((V.Payment_CC+V.Payment_OC)-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16+V.AmountDue_17+V.AmountDue_18+V.AmountDue_19)) Then 0
When ((V.Payment_CC+V.Payment_OC)-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16+V.AmountDue_17+V.AmountDue_18+V.AmountDue_19))<0 then V.AmountDue_20
else V.AmountDue_20-((V.Payment_CC+V.Payment_OC)-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16+V.AmountDue_17+V.AmountDue_18+V.AmountDue_19)) end 
+
Case WHen V.Installment=20 and (V.Payment_CC+V.Payment_OC)>(V.Nominal_CC-V.Diff_CC) Then (V.Nominal_CC-V.Diff_CC)-(V.Payment_CC+V.Payment_OC) else 0 end
as Outstanding_20, 
  
Case 
When V.AmountDue_21<((V.Payment_CC+V.Payment_OC)-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16+V.AmountDue_17+V.AmountDue_18+V.AmountDue_19+V.AmountDue_20)) Then 0
When ((V.Payment_CC+V.Payment_OC)-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16+V.AmountDue_17+V.AmountDue_18+V.AmountDue_19+V.AmountDue_20))<0 then V.AmountDue_21
else V.AmountDue_21-((V.Payment_CC+V.Payment_OC)-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16+V.AmountDue_17+V.AmountDue_18+V.AmountDue_19+V.AmountDue_20)) end 
+
Case WHen V.Installment=21 and (V.Payment_CC+V.Payment_OC)>(V.Nominal_CC-V.Diff_CC) Then (V.Nominal_CC-V.Diff_CC)-(V.Payment_CC+V.Payment_OC) else 0 end
as Outstanding_21, 

Case 
When V.AmountDue_22<((V.Payment_CC+V.Payment_OC)-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16+V.AmountDue_17+V.AmountDue_18+V.AmountDue_19+V.AmountDue_20+V.AmountDue_21)) Then 0
When ((V.Payment_CC+V.Payment_OC)-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16+V.AmountDue_17+V.AmountDue_18+V.AmountDue_19+V.AmountDue_20+V.AmountDue_21))<0 then V.AmountDue_22
else V.AmountDue_22-((V.Payment_CC+V.Payment_OC)-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16+V.AmountDue_17+V.AmountDue_18+V.AmountDue_19+V.AmountDue_20+V.AmountDue_21)) end 
+
Case WHen V.Installment=22 and (V.Payment_CC+V.Payment_OC)>(V.Nominal_CC-V.Diff_CC) Then (V.Nominal_CC-V.Diff_CC)-(V.Payment_CC+V.Payment_OC) else 0 end
as Outstanding_22, 

Case 
When V.AmountDue_23<((V.Payment_CC+V.Payment_OC)-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16+V.AmountDue_17+V.AmountDue_18+V.AmountDue_19+V.AmountDue_20+V.AmountDue_21+V.AmountDue_22)) Then 0
When ((V.Payment_CC+V.Payment_OC)-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16+V.AmountDue_17+V.AmountDue_18+V.AmountDue_19+V.AmountDue_20+V.AmountDue_21+V.AmountDue_22))<0 then V.AmountDue_23
else V.AmountDue_23-((V.Payment_CC+V.Payment_OC)-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16+V.AmountDue_17+V.AmountDue_18+V.AmountDue_19+V.AmountDue_20+V.AmountDue_21+V.AmountDue_22)) end 
+
Case WHen V.Installment=23 and (V.Payment_CC+V.Payment_OC)>(V.Nominal_CC-V.Diff_CC) Then (V.Nominal_CC-V.Diff_CC)-(V.Payment_CC+V.Payment_OC) else 0 end
as Outstanding_23, 
 
Case 
When V.AmountDue_24<((V.Payment_CC+V.Payment_OC)-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16+V.AmountDue_17+V.AmountDue_18+V.AmountDue_19+V.AmountDue_20+V.AmountDue_21+V.AmountDue_22+V.AmountDue_23)) Then 0
When ((V.Payment_CC+V.Payment_OC)-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16+V.AmountDue_17+V.AmountDue_18+V.AmountDue_19+V.AmountDue_20+V.AmountDue_21+V.AmountDue_22+V.AmountDue_23))<0 then V.AmountDue_24
else V.AmountDue_24-((V.Payment_CC+V.Payment_OC)-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16+V.AmountDue_17+V.AmountDue_18+V.AmountDue_19+V.AmountDue_20+V.AmountDue_21+V.AmountDue_22+V.AmountDue_23)) End
+
Case WHen V.Installment=24 and (V.Payment_CC+V.Payment_OC)>(V.Nominal_CC-V.Diff_CC) Then (V.Nominal_CC-V.Diff_CC)-(V.Payment_CC+V.Payment_OC) else 0 end
as Outstanding_24,

(Case When V.Installment<>0 then ' Installment No. ' else '' end+      
Case When V.Installment>=1 and V.DueDate_1 <=@P_Date and (V.Payment_CC+V.Payment_OC)<V.AmountDue_1 Then '1 ' else '' end+
Case When V.Installment>=2 and V.DueDate_2 <=@P_Date and (V.Payment_CC+V.Payment_OC)<V.AmountDue_1+V.AmountDue_2 Then '2 ' else '' end+
Case When V.Installment>=3 and V.DueDate_3 <=@P_Date and (V.Payment_CC+V.Payment_OC)<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3 Then '3 ' else '' end+
Case When V.Installment>=4 and V.DueDate_4 <=@P_Date and (V.Payment_CC+V.Payment_OC)<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4 Then '4 ' else '' end+
Case When V.Installment>=5 and V.DueDate_5 <=@P_Date and (V.Payment_CC+V.Payment_OC)<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5 Then '5 ' else '' end+
Case When V.Installment>=6 and V.DueDate_6 <=@P_Date and (V.Payment_CC+V.Payment_OC)<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6 Then '6 ' else '' end+
Case When V.Installment>=7 and V.DueDate_7 <=@P_Date and (V.Payment_CC+V.Payment_OC)<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7 Then '7 ' else '' end+
Case When V.Installment>=8 and V.DueDate_8 <=@P_Date and (V.Payment_CC+V.Payment_OC)<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8 Then '8 ' else '' end+
Case When V.Installment>=9 and V.DueDate_9 <=@P_Date and (V.Payment_CC+V.Payment_OC)<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9 Then '9 ' else '' end+
Case When V.Installment>=10 and V.DueDate_10 <=@P_Date and (V.Payment_CC+V.Payment_OC)<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10 Then '10 ' else '' end+
Case When V.Installment>=11 and V.DueDate_11 <=@P_Date and (V.Payment_CC+V.Payment_OC)<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11 Then '11 ' else '' end+
Case When V.Installment>=12 and V.DueDate_12 <=@P_Date and (V.Payment_CC+V.Payment_OC)<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12 Then '12 ' else '' end+
Case When V.Installment>=13 and V.DueDate_13 <=@P_Date and (V.Payment_CC+V.Payment_OC)<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13 Then '13 ' else '' end+
Case When V.Installment>=14 and V.DueDate_14 <=@P_Date and (V.Payment_CC+V.Payment_OC)<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14 Then '14 ' else '' end+
Case When V.Installment>=15 and V.DueDate_15 <=@P_Date and (V.Payment_CC+V.Payment_OC)<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15 Then '15 ' else '' end+
Case When V.Installment>=16 and V.DueDate_16 <=@P_Date and (V.Payment_CC+V.Payment_OC)<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16 Then '16 ' else '' end+
Case When V.Installment>=17 and V.DueDate_17 <=@P_Date and (V.Payment_CC+V.Payment_OC)<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16+V.AmountDue_17 Then '17 ' else '' end+
Case When V.Installment>=18 and V.DueDate_18 <=@P_Date and (V.Payment_CC+V.Payment_OC)<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16+V.AmountDue_17+V.AmountDue_18 Then '18 ' else '' end+
Case When V.Installment>=19 and V.DueDate_19 <=@P_Date and (V.Payment_CC+V.Payment_OC)<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16+V.AmountDue_17+V.AmountDue_18+V.AmountDue_19 Then '19 ' else '' end+
Case When V.Installment>=20 and V.DueDate_20 <=@P_Date and (V.Payment_CC+V.Payment_OC)<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16+V.AmountDue_17+V.AmountDue_18+V.AmountDue_19+V.AmountDue_20 Then '20 ' else '' end+
Case When V.Installment>=21 and V.DueDate_21 <=@P_Date and (V.Payment_CC+V.Payment_OC)<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16+V.AmountDue_17+V.AmountDue_18+V.AmountDue_19+V.AmountDue_20+V.AmountDue_21 Then '21 ' else '' end+
Case When V.Installment>=22 and V.DueDate_22 <=@P_Date and (V.Payment_CC+V.Payment_OC)<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16+V.AmountDue_17+V.AmountDue_18+V.AmountDue_19+V.AmountDue_20+V.AmountDue_21+V.AmountDue_22 Then '22 ' else '' end+
Case When V.Installment>=23 and V.DueDate_23 <=@P_Date and (V.Payment_CC+V.Payment_OC)<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16+V.AmountDue_17+V.AmountDue_18+V.AmountDue_19+V.AmountDue_20+V.AmountDue_21+V.AmountDue_22+V.AmountDue_23 Then '23 ' else '' end+
Case When V.Installment>=24 and V.DueDate_24 <=@P_Date and (V.Payment_CC+V.Payment_OC)<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16+V.AmountDue_17+V.AmountDue_18+V.AmountDue_19+V.AmountDue_20+V.AmountDue_21+V.AmountDue_22+V.AmountDue_23+V.AmountDue_24 Then '24 ' else '' end
+      
Case When V.Installment<>0 then 'of '+cast(V.Installment as varchar(255)) else '' end) as sInstallment,

(
Case When V.Installment>=1 and V.DueDate_1 <=@P_Date and (V.Payment_CC+V.Payment_OC)<V.AmountDue_1 
	Then ' Installment 1 : ' + 
	convert(varchar(50), cast(
	Case 
	When V.AmountDue_1<(V.Payment_CC+V.Payment_OC) Then 0
	else V.AmountDue_1-(V.Payment_CC+V.Payment_OC) end 
	+
	Case WHen V.Installment=1 and (V.Payment_CC+V.Payment_OC)>(V.Nominal_CC-V.Diff_CC) Then (V.Nominal_CC-V.Diff_CC)-(V.Payment_CC+V.Payment_OC) else 0 end
	as Money),1)+char(13)+char(10)
	else '' end+ 

Case When V.Installment>=2 and V.DueDate_2 <=@P_Date and (V.Payment_CC+V.Payment_OC)<V.AmountDue_1+V.AmountDue_2 
	Then ' Installment 2 : ' + 
	convert(varchar(50), cast(
	Case 
	When V.AmountDue_2<((V.Payment_CC+V.Payment_OC)-V.AmountDue_1) Then 0
	When ((V.Payment_CC+V.Payment_OC)-V.AmountDue_1)<0 then V.AmountDue_2
	else V.AmountDue_2-((V.Payment_CC+V.Payment_OC)-V.AmountDue_1) end 
	+
	Case WHen V.Installment=2 and (V.Payment_CC+V.Payment_OC)>(V.Nominal_CC-V.Diff_CC) Then (V.Nominal_CC-V.Diff_CC)-(V.Payment_CC+V.Payment_OC) else 0 end
	as Money),1)+char(13)+char(10)
	else '' end+ 

Case When V.Installment>=3 and V.DueDate_3 <=@P_Date and (V.Payment_CC+V.Payment_OC)<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3 
	Then ' Installment 3 : ' + 
	convert(varchar(50), cast(
	Case 
	When V.AmountDue_3<((V.Payment_CC+V.Payment_OC)-(V.AmountDue_1+V.AmountDue_2)) Then 0
	When ((V.Payment_CC+V.Payment_OC)-(V.AmountDue_1+V.AmountDue_2))<0 then V.AmountDue_3
	else V.AmountDue_3-((V.Payment_CC+V.Payment_OC)-(V.AmountDue_1+V.AmountDue_2)) end 
	+
	Case WHen V.Installment=3 and (V.Payment_CC+V.Payment_OC)>(V.Nominal_CC-V.Diff_CC) Then (V.Nominal_CC-V.Diff_CC)-(V.Payment_CC+V.Payment_OC) else 0 end
	as Money),1)+char(13)+char(10)
	else '' end+ 

Case When V.Installment>=4 and V.DueDate_4 <=@P_Date and (V.Payment_CC+V.Payment_OC)<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4 
	Then ' Installment 4 : ' + 
	convert(varchar(50), cast(
	Case 
	When V.AmountDue_4<((V.Payment_CC+V.Payment_OC)-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3)) Then 0
	When ((V.Payment_CC+V.Payment_OC)-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3))<0 then V.AmountDue_4
	else V.AmountDue_4-((V.Payment_CC+V.Payment_OC)-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3)) end 
	+
	Case WHen V.Installment=4 and (V.Payment_CC+V.Payment_OC)>(V.Nominal_CC-V.Diff_CC) Then (V.Nominal_CC-V.Diff_CC)-(V.Payment_CC+V.Payment_OC) else 0 end
	as Money),1)+char(13)+char(10)
	else '' end+ 

Case When V.Installment>=5 and V.DueDate_5 <=@P_Date and (V.Payment_CC+V.Payment_OC)<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5 
	Then ' Installment 5 : ' + 
	convert(varchar(50), cast(
	Case 
	When V.AmountDue_5<((V.Payment_CC+V.Payment_OC)-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4)) Then 0
	When ((V.Payment_CC+V.Payment_OC)-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4))<0 then V.AmountDue_5
	else V.AmountDue_5-((V.Payment_CC+V.Payment_OC)-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4)) end 
	+
	Case WHen V.Installment=5 and (V.Payment_CC+V.Payment_OC)>(V.Nominal_CC-V.Diff_CC) Then (V.Nominal_CC-V.Diff_CC)-(V.Payment_CC+V.Payment_OC) else 0 end
	as Money),1)+char(13)+char(10)
	else '' end+ 

Case When V.Installment>=6 and V.DueDate_6 <=@P_Date and (V.Payment_CC+V.Payment_OC)<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6 
	Then ' Installment 6 : ' + 
	convert(varchar(50), cast(
	Case 
	When V.AmountDue_6<((V.Payment_CC+V.Payment_OC)-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5)) Then 0
	When ((V.Payment_CC+V.Payment_OC)-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5))<0 then V.AmountDue_6
	else V.AmountDue_6-((V.Payment_CC+V.Payment_OC)-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5)) end 
	+
	Case WHen V.Installment=6 and (V.Payment_CC+V.Payment_OC)>(V.Nominal_CC-V.Diff_CC) Then (V.Nominal_CC-V.Diff_CC)-(V.Payment_CC+V.Payment_OC) else 0 end
	as Money),1)+char(13)+char(10)
	else '' end+ 

Case When V.Installment>=7 and V.DueDate_7 <=@P_Date and (V.Payment_CC+V.Payment_OC)<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7 
	Then ' Installment 7 : ' + 
	convert(varchar(50), cast(
	Case 
	When V.AmountDue_7<((V.Payment_CC+V.Payment_OC)-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6)) Then 0
	When ((V.Payment_CC+V.Payment_OC)-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6))<0 then V.AmountDue_7
	else V.AmountDue_7-((V.Payment_CC+V.Payment_OC)-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6)) end 
	+
	Case WHen V.Installment=7 and (V.Payment_CC+V.Payment_OC)>(V.Nominal_CC-V.Diff_CC) Then (V.Nominal_CC-V.Diff_CC)-(V.Payment_CC+V.Payment_OC) else 0 end
	as Money),1)+char(13)+char(10)
	else '' end+ 

Case When V.Installment>=8 and V.DueDate_8 <=@P_Date and (V.Payment_CC+V.Payment_OC)<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8 
	Then ' Installment 8 : ' + 
	convert(varchar(50), cast(
	Case 
	When V.AmountDue_8<((V.Payment_CC+V.Payment_OC)-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7)) Then 0
	When ((V.Payment_CC+V.Payment_OC)-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7))<0 then V.AmountDue_8
	else V.AmountDue_8-((V.Payment_CC+V.Payment_OC)-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7)) end 
	+
	Case WHen V.Installment=8 and (V.Payment_CC+V.Payment_OC)>(V.Nominal_CC-V.Diff_CC) Then (V.Nominal_CC-V.Diff_CC)-(V.Payment_CC+V.Payment_OC) else 0 end
	as Money),1)+char(13)+char(10)
	else '' end+ 

Case When V.Installment>=9 and V.DueDate_9 <=@P_Date and (V.Payment_CC+V.Payment_OC)<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9 
	Then ' Installment 2 : ' + 
	convert(varchar(50), cast(
	Case 
	When V.AmountDue_9<((V.Payment_CC+V.Payment_OC)-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8)) Then 0
	When ((V.Payment_CC+V.Payment_OC)-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8))<0 then V.AmountDue_9
	else V.AmountDue_9-((V.Payment_CC+V.Payment_OC)-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8)) end 
	+
	Case WHen V.Installment=9 and (V.Payment_CC+V.Payment_OC)>(V.Nominal_CC-V.Diff_CC) Then (V.Nominal_CC-V.Diff_CC)-(V.Payment_CC+V.Payment_OC) else 0 end
	as Money),1)+char(13)+char(10)
	else '' end+ 

Case When V.Installment>=10 and V.DueDate_10 <=@P_Date and (V.Payment_CC+V.Payment_OC)<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10  
	Then ' Installment 10 : ' + 
	convert(varchar(50), cast(
	Case 
	When V.AmountDue_10<((V.Payment_CC+V.Payment_OC)-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9)) Then 0
	When ((V.Payment_CC+V.Payment_OC)-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9))<0 then V.AmountDue_10
	else V.AmountDue_10-((V.Payment_CC+V.Payment_OC)-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9)) end 
	+
	Case WHen V.Installment=10 and (V.Payment_CC+V.Payment_OC)>(V.Nominal_CC-V.Diff_CC) Then (V.Nominal_CC-V.Diff_CC)-(V.Payment_CC+V.Payment_OC) else 0 end
	as Money),1)+char(13)+char(10)
	else '' end+ 

Case When V.Installment>=11 and V.DueDate_11 <=@P_Date and (V.Payment_CC+V.Payment_OC)<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11 
	Then ' Installment 11 : ' + 
	convert(varchar(50), cast(
	Case 
	When V.AmountDue_11<((V.Payment_CC+V.Payment_OC)-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10)) Then 0
	When ((V.Payment_CC+V.Payment_OC)-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10))<0 then V.AmountDue_11
	else V.AmountDue_11-((V.Payment_CC+V.Payment_OC)-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10)) end 
	+
	Case WHen V.Installment=11 and (V.Payment_CC+V.Payment_OC)>(V.Nominal_CC-V.Diff_CC) Then (V.Nominal_CC-V.Diff_CC)-(V.Payment_CC+V.Payment_OC) else 0 end
	as Money),1)+char(13)+char(10)
	else '' end+ 

Case When V.Installment>=12 and V.DueDate_12 <=@P_Date and (V.Payment_CC+V.Payment_OC)<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12 
	Then ' Installment 12 : ' + 
	convert(varchar(50), cast(
	Case 
	When V.AmountDue_12<((V.Payment_CC+V.Payment_OC)-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11)) Then 0
	When ((V.Payment_CC+V.Payment_OC)-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11))<0 then V.AmountDue_12
	else V.AmountDue_12-((V.Payment_CC+V.Payment_OC)-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11)) end 
	+
	Case WHen V.Installment=12 and (V.Payment_CC+V.Payment_OC)>(V.Nominal_CC-V.Diff_CC) Then (V.Nominal_CC-V.Diff_CC)-(V.Payment_CC+V.Payment_OC) else 0 end
	as Money),1)+char(13)+char(10)
	else '' end+ 

Case When V.Installment>=13 and V.DueDate_13 <=@P_Date and (V.Payment_CC+V.Payment_OC)<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13 
	Then ' Installment 13 : ' + 
	convert(varchar(50), cast(
	Case 
	When V.AmountDue_14<((V.Payment_CC+V.Payment_OC)-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13)) Then 0
	When ((V.Payment_CC+V.Payment_OC)-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13))<0 then V.AmountDue_14
	else V.AmountDue_14-((V.Payment_CC+V.Payment_OC)-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13)) end 
	+
	Case WHen V.Installment=13 and (V.Payment_CC+V.Payment_OC)>(V.Nominal_CC-V.Diff_CC) Then (V.Nominal_CC-V.Diff_CC)-(V.Payment_CC+V.Payment_OC) else 0 end
	as Money),1)+char(13)+char(10)
	else '' end+ 

Case When V.Installment>=14 and V.DueDate_14 <=@P_Date and (V.Payment_CC+V.Payment_OC)<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14 
	Then ' Installment 14 : ' + 
	convert(varchar(50), cast(
	Case 
	When V.AmountDue_2<((V.Payment_CC+V.Payment_OC)-V.AmountDue_1) Then 0
	When ((V.Payment_CC+V.Payment_OC)-V.AmountDue_1)<0 then V.AmountDue_2
	else V.AmountDue_2-((V.Payment_CC+V.Payment_OC)-V.AmountDue_1) end 
	+
	Case WHen V.Installment=2 and (V.Payment_CC+V.Payment_OC)>(V.Nominal_CC-V.Diff_CC) Then (V.Nominal_CC-V.Diff_CC)-(V.Payment_CC+V.Payment_OC) else 0 end
	as Money),1)+char(13)+char(10)
	else '' end+ 

Case When V.Installment>=15 and V.DueDate_15 <=@P_Date and (V.Payment_CC+V.Payment_OC)<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15 
	Then ' Installment 15 : ' + 
	convert(varchar(50), cast(
	Case 
	When V.AmountDue_15<((V.Payment_CC+V.Payment_OC)-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14)) Then 0
	When ((V.Payment_CC+V.Payment_OC)-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14))<0 then V.AmountDue_15
	else V.AmountDue_15-((V.Payment_CC+V.Payment_OC)-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14)) end 
	+
	Case WHen V.Installment=15 and (V.Payment_CC+V.Payment_OC)>(V.Nominal_CC-V.Diff_CC) Then (V.Nominal_CC-V.Diff_CC)-(V.Payment_CC+V.Payment_OC) else 0 end
	as Money),1)+char(13)+char(10)
	else '' end+ 

Case When V.Installment>=16 and V.DueDate_16 <=@P_Date and (V.Payment_CC+V.Payment_OC)<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16 
	Then ' Installment 16 : ' + 
	convert(varchar(50), cast(
	Case 
	When V.AmountDue_16<((V.Payment_CC+V.Payment_OC)-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15)) Then 0
	When ((V.Payment_CC+V.Payment_OC)-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15))<0 then V.AmountDue_16
	else V.AmountDue_16-((V.Payment_CC+V.Payment_OC)-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15)) end 
	+
	Case WHen V.Installment=16 and (V.Payment_CC+V.Payment_OC)>(V.Nominal_CC-V.Diff_CC) Then (V.Nominal_CC-V.Diff_CC)-(V.Payment_CC+V.Payment_OC) else 0 end
	as Money),1)+char(13)+char(10)
	else '' end+ 

Case When V.Installment>=17 and V.DueDate_17 <=@P_Date and (V.Payment_CC+V.Payment_OC)<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16+V.AmountDue_17 
	Then ' Installment 17 : ' + 
	convert(varchar(50), cast(
	Case 
	When V.AmountDue_17<((V.Payment_CC+V.Payment_OC)-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16)) Then 0
	When ((V.Payment_CC+V.Payment_OC)-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16))<0 then V.AmountDue_17
	else V.AmountDue_17-((V.Payment_CC+V.Payment_OC)-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16)) end 
	+
	Case WHen V.Installment=17 and (V.Payment_CC+V.Payment_OC)>(V.Nominal_CC-V.Diff_CC) Then (V.Nominal_CC-V.Diff_CC)-(V.Payment_CC+V.Payment_OC) else 0 end
	as Money),1)+char(13)+char(10)
	else '' end+ 

Case When V.Installment>=18 and V.DueDate_18 <=@P_Date and (V.Payment_CC+V.Payment_OC)<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16+V.AmountDue_17+V.AmountDue_18 
	Then ' Installment 18 : ' + 
	convert(varchar(50), cast(
	Case 
	When V.AmountDue_18<((V.Payment_CC+V.Payment_OC)-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16+V.AmountDue_17)) Then 0
	When ((V.Payment_CC+V.Payment_OC)-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16+V.AmountDue_17))<0 then V.AmountDue_18
	else V.AmountDue_18-((V.Payment_CC+V.Payment_OC)-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16+V.AmountDue_17)) end 
	+
	Case WHen V.Installment=18 and (V.Payment_CC+V.Payment_OC)>(V.Nominal_CC-V.Diff_CC) Then (V.Nominal_CC-V.Diff_CC)-(V.Payment_CC+V.Payment_OC) else 0 end
	as Money),1)+char(13)+char(10)
	else '' end+ 

Case When V.Installment>=19 and V.DueDate_19 <=@P_Date and (V.Payment_CC+V.Payment_OC)<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16+V.AmountDue_17+V.AmountDue_18+V.AmountDue_19 
	Then ' Installment 19 : ' + 
	convert(varchar(50), cast(
	Case 
	When V.AmountDue_19<((V.Payment_CC+V.Payment_OC)-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16+V.AmountDue_17+V.AmountDue_18)) Then 0
	When ((V.Payment_CC+V.Payment_OC)-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16+V.AmountDue_17+V.AmountDue_18))<0 then V.AmountDue_19
	else V.AmountDue_19-((V.Payment_CC+V.Payment_OC)-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16+V.AmountDue_17+V.AmountDue_18)) end 
	+
	Case WHen V.Installment=19 and (V.Payment_CC+V.Payment_OC)>(V.Nominal_CC-V.Diff_CC) Then (V.Nominal_CC-V.Diff_CC)-(V.Payment_CC+V.Payment_OC) else 0 end
	as Money),1)+char(13)+char(10)
	else '' end+ 

Case When V.Installment>=20 and V.DueDate_20 <=@P_Date and (V.Payment_CC+V.Payment_OC)<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16+V.AmountDue_17+V.AmountDue_18+V.AmountDue_19+V.AmountDue_20 
	Then ' Installment 20 : ' + 
	convert(varchar(50), cast(
	Case 
	When V.AmountDue_20<((V.Payment_CC+V.Payment_OC)-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16+V.AmountDue_17+V.AmountDue_18+V.AmountDue_19)) Then 0
	When ((V.Payment_CC+V.Payment_OC)-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16+V.AmountDue_17+V.AmountDue_18+V.AmountDue_19))<0 then V.AmountDue_20
	else V.AmountDue_20-((V.Payment_CC+V.Payment_OC)-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16+V.AmountDue_17+V.AmountDue_18+V.AmountDue_19)) end 
	+
	Case WHen V.Installment=20 and (V.Payment_CC+V.Payment_OC)>(V.Nominal_CC-V.Diff_CC) Then (V.Nominal_CC-V.Diff_CC)-(V.Payment_CC+V.Payment_OC) else 0 end
	as Money),1)+char(13)+char(10)
	else '' end+ 

Case When V.Installment>=21 and V.DueDate_21 <=@P_Date and (V.Payment_CC+V.Payment_OC)<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16+V.AmountDue_17+V.AmountDue_18+V.AmountDue_19+V.AmountDue_20+V.AmountDue_21 
	Then ' Installment 21 : ' + 
	convert(varchar(50), cast(
	Case 
	When V.AmountDue_21<((V.Payment_CC+V.Payment_OC)-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16+V.AmountDue_17+V.AmountDue_18+V.AmountDue_19+V.AmountDue_20)) Then 0
	When ((V.Payment_CC+V.Payment_OC)-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16+V.AmountDue_17+V.AmountDue_18+V.AmountDue_19+V.AmountDue_20))<0 then V.AmountDue_21
	else V.AmountDue_21-((V.Payment_CC+V.Payment_OC)-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16+V.AmountDue_17+V.AmountDue_18+V.AmountDue_19+V.AmountDue_20)) end 
	+
	Case WHen V.Installment=21 and (V.Payment_CC+V.Payment_OC)>(V.Nominal_CC-V.Diff_CC) Then (V.Nominal_CC-V.Diff_CC)-(V.Payment_CC+V.Payment_OC) else 0 end
	as Money),1)+char(13)+char(10)
	else '' end+ 

Case When V.Installment>=22 and V.DueDate_22 <=@P_Date and (V.Payment_CC+V.Payment_OC)<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16+V.AmountDue_17+V.AmountDue_18+V.AmountDue_19+V.AmountDue_20+V.AmountDue_21+V.AmountDue_22 
	Then ' Installment 22 : ' + 
	convert(varchar(50), cast(
	Case 
	When V.AmountDue_22<((V.Payment_CC+V.Payment_OC)-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16+V.AmountDue_17+V.AmountDue_18+V.AmountDue_19+V.AmountDue_20+V.AmountDue_21)) Then 0
	When ((V.Payment_CC+V.Payment_OC)-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16+V.AmountDue_17+V.AmountDue_18+V.AmountDue_19+V.AmountDue_20+V.AmountDue_21))<0 then V.AmountDue_22
	else V.AmountDue_22-((V.Payment_CC+V.Payment_OC)-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16+V.AmountDue_17+V.AmountDue_18+V.AmountDue_19+V.AmountDue_20+V.AmountDue_21)) end 
	+
	Case WHen V.Installment=22 and (V.Payment_CC+V.Payment_OC)>(V.Nominal_CC-V.Diff_CC) Then (V.Nominal_CC-V.Diff_CC)-(V.Payment_CC+V.Payment_OC) else 0 end
	as Money),1)+char(13)+char(10)
	else '' end+ 

Case When V.Installment>=23 and V.DueDate_23 <=@P_Date and (V.Payment_CC+V.Payment_OC)<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16+V.AmountDue_17+V.AmountDue_18+V.AmountDue_19+V.AmountDue_20+V.AmountDue_21+V.AmountDue_22+V.AmountDue_23 
	Then ' Installment 23 : ' + 
	convert(varchar(50), cast(
	Case 
	When V.AmountDue_23<((V.Payment_CC+V.Payment_OC)-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16+V.AmountDue_17+V.AmountDue_18+V.AmountDue_19+V.AmountDue_20+V.AmountDue_21+V.AmountDue_22)) Then 0
	When ((V.Payment_CC+V.Payment_OC)-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16+V.AmountDue_17+V.AmountDue_18+V.AmountDue_19+V.AmountDue_20+V.AmountDue_21+V.AmountDue_22))<0 then V.AmountDue_23
	else V.AmountDue_23-((V.Payment_CC+V.Payment_OC)-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16+V.AmountDue_17+V.AmountDue_18+V.AmountDue_19+V.AmountDue_20+V.AmountDue_21+V.AmountDue_22)) end 
	+
	Case WHen V.Installment=23 and (V.Payment_CC+V.Payment_OC)>(V.Nominal_CC-V.Diff_CC) Then (V.Nominal_CC-V.Diff_CC)-(V.Payment_CC+V.Payment_OC) else 0 end
	as Money),1)+char(13)+char(10)
	else '' end+ 

Case When V.Installment>=24 and V.DueDate_24 <=@P_Date and (V.Payment_CC+V.Payment_OC)<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16+V.AmountDue_17+V.AmountDue_18+V.AmountDue_19+V.AmountDue_20+V.AmountDue_21+V.AmountDue_22+V.AmountDue_23+V.AmountDue_24 
	Then ' Installment 24 : ' + 
	convert(varchar(50), cast(
	Case 
	When V.AmountDue_24<((V.Payment_CC+V.Payment_OC)-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16+V.AmountDue_17+V.AmountDue_18+V.AmountDue_19+V.AmountDue_20+V.AmountDue_21+V.AmountDue_22+V.AmountDue_23)) Then 0
	When ((V.Payment_CC+V.Payment_OC)-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16+V.AmountDue_17+V.AmountDue_18+V.AmountDue_19+V.AmountDue_20+V.AmountDue_21+V.AmountDue_22+V.AmountDue_23))<0 then V.AmountDue_24
	else V.AmountDue_24-((V.Payment_CC+V.Payment_OC)-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16+V.AmountDue_17+V.AmountDue_18+V.AmountDue_19+V.AmountDue_20+V.AmountDue_21+V.AmountDue_22+V.AmountDue_23)) End
	+
	Case WHen V.Installment=24 and (V.Payment_CC+V.Payment_OC)>(V.Nominal_CC-V.Diff_CC) Then (V.Nominal_CC-V.Diff_CC)-(V.Payment_CC+V.Payment_OC) else 0 end
	as Money),1)+char(13)+char(10)
	else '' end 

) as sInstallment_Ext
from nVoucher V 
Outer Apply (Select top 1 WPC from Admlink A Where A.Voucher=V.Voucher) A
Where (Round(V.Nominal_CC-V.Diff_CC-(V.Payment_CC+V.Payment_OC),4)<>0 or V.PDate>@P_Date) 
) 



GO

IF EXISTS ( SELECT * FROM   sysobjects WHERE  id = object_id(N'QPREMIUMAMOUNT') and OBJECTPROPERTY(id, N'IsProcedure') = 1 )
BEGIN DROP PROCEDURE QPREMIUMAMOUNT  END 
GO

CREATE PROCEDURE QPREMIUMAMOUNT (@P_ANO AS INTEGER,@P_PDate as smalldatetime)                        
  
AS                       
  
Declare @P_APolicyNo as varchar(50)          
Declare @P_WPC as int    
Declare @P_BillDate as smalldatetime    
Declare @P_BackdatedF as bit  
Declare @P_Grace as Int  
  
Select   
@P_APolicyNo=
Case 
When A.LANO<>-1 then
	Case
	When A.ANO<>A.LANO and ((C.OpenFlag=1 and A.BulkF=0) or (C.OpenFlag=0 and A.RefNo<>mA.RefNo)) then
		A.PolicyNo+'-'+A.CertificateNo
	else
		A.PolicyNo
	end
Else
	A.PolicyNo
end,
@P_WPC=coalesce(APayor.WPC, coalesce(MPayor.WPC, Payor.WPC)),    
@P_Grace=coalesce(APayor.Grace, coalesce(MPayor.Grace, Payor.Grace)),  
@P_BillDate= dateadd(day,coalesce(APayor.Grace, coalesce(MPayor.Grace, Payor.Grace)),  
Case     
When A.AType='A' Then A.ADate     
else     
 Case When C.OpenFlag=0 Then     
  Case When SysTab.DueByEffectiveF=0 Then coalesce(mA.ADate,A.ADate) else coalesce(mA.PDate,A.PDate) end    
 else    
  Case When SysTab.DueByEffectiveF=0 Then A.ADate else A.PDate end    
 end    
end)  
,    
@P_BackdatedF=A.BackDatedF  
from Acceptance A
Inner Join Cover C on (C.CNO=A.CNO)  
Left Join Acceptance mA on (mA.ANO=mA.LANO and mA.RegNo=A.RegNo)    
Left Join APayor on (APayor.ANO=A.ANO)    
Left Join Payor on (Payor.ANO=A.ANO)  
Left Join Payor MPayor on (MPayor.ANO=mA.ANO)  
Inner Join SysTab on (1=1)    
Where A.ANO=@P_ANO   
  
Select             
@P_BackdatedF as BackdatedF,  
sum(Voucher.PremiumAmount) as PremiumAmount,            
sum(Voucher.PremiumDue) as PremiumDue,     
Min(Voucher.DueDate) as DueDate,        
coalesce(datediff(day,Min(Voucher.DueDate),@P_PDate),0) as Lapse,  
sum(Voucher.PremiumPaid) as PremiumPaid,            
sum(Voucher.PremiumOutstanding) as PremiumOutstanding,            
@P_WPC as WPC,    
@P_Grace as Grace,  
@P_BillDate as BillDate,    
Min(Voucher.PDate) as Date,
Max(Voucher.LastDueDate) as LastDueDate,
Max(Voucher.LastPayDate) as LastPayDate
From            
(             
 SELECT                        
 nVoucher.Voucher,    
 CASE WHEN nVoucher.DEBTORF=1 THEN (Case When Voucher_Due.Voucher is null then nVoucher.Nominal_CC-nVoucher.Diff_CC else Voucher_Due.AmountDue end) ELSE -(Case When Voucher_Due.Voucher is null then nVoucher.Nominal_CC-nVoucher.Diff_CC else Voucher_Due.AmountDue end) END*nVoucher.RATE as PremiumAmount,                         
 CASE WHEN nVoucher.DEBTORF=1 THEN (CASE WHEN coalesce(Voucher_Due.AmountDue,0)-(nVoucher.Payment_CC+nVoucher.Payment_OC)<0 Then 0 Else coalesce(Voucher_Due.AmountDue,0)-(nVoucher.Payment_CC+nVoucher.Payment_OC) End) ELSE -(CASE WHEN coalesce(Voucher_Due.AmountDue,0)-(nVoucher.Payment_CC+nVoucher.Payment_OC)<0 Then 0 Else coalesce(Voucher_Due.AmountDue,0)-(nVoucher.Payment_CC+nVoucher.Payment_OC) End) END*nVoucher.RATE as PremiumDue,                        
 Case When Round((nVoucher.Payment_CC+nVoucher.Payment_OC),2)<round((Case When Voucher_Due.Voucher is null then nVoucher.Nominal_CC-nVoucher.Diff_CC else Voucher_Due.AmountDue end),2) Then isnull(Voucher_Due.DueDate, dateadd(day, @P_WPC, nVoucher.DueDate)) else Null end AS DueDate,                  
 Case When nVoucher.INSTALLMENT<>0 then Voucher_Due.LastDueDate else dateadd(day, @P_WPC, nVoucher.DueDate) End as LastDueDate,
 CASE WHEN nVoucher.DEBTORF=1 THEN nVoucher.Nominal_CC-nVoucher.Diff_CC-(nVoucher.Payment_CC+nVoucher.Payment_OC) ELSE -(nVoucher.Nominal_CC-nVoucher.Diff_CC-(nVoucher.Payment_CC+nVoucher.Payment_OC)) END*nVoucher.RATE as PremiumOutstanding,     
 CASE WHEN nVoucher.DEBTORF=1 THEN (nVoucher.Payment_CC+nVoucher.Payment_OC) ELSE -(nVoucher.Payment_CC+nVoucher.Payment_OC) END*nVoucher.RATE as PremiumPaid,                        
 Payment.PDate, 
 Payment.LastPayDate
 FROM (
	Select Distinct Admlink.Voucher
	from Admlink
	Where Admlink.A_policyNo=@P_APolicyNo and Admlink.Subject='Premium' and Admlink.Type in ('DI','IC','IR','IT','IX') 
 ) Admlink
 Inner Join nVoucher on (nVoucher.Voucher=Admlink.Voucher)     
 Left Join Voucher_AmountWPCDue(@P_PDate) Voucher_Due on (Voucher_Due.Voucher=nVoucher.Voucher)     
 Outer Apply (  
  Select 
  Max(coalesce(pVoucher.RefDate, coalesce(OVoucher.RefDate, Voucher.RefDate))) as PDate,
  Max(Case When coalesce(pVoucher.RefDate, coalesce(OVoucher.RefDate, Voucher.RefDate)) <=@P_PDate then coalesce(pVoucher.RefDate, coalesce(OVoucher.RefDate, Voucher.RefDate)) else Null End) as LastPayDate,
  sum(case When V.DebtorF=1 Then 1 else -1 end*dbo.fn_SL_Payment_Nominal(pSL.Nominal_OC, pVoucher.SL_Cat, pVoucher.DebtorF, V.DebtorF)) as Payment
  from pSL   
  Inner Join pVoucher Voucher on (Voucher.Voucher=pSL.Voucher)       
  Left Join pVoucher oVoucher on (oVoucher.Voucher=Voucher.RefNo and Voucher.SL_Cat in ('A','B') and oVoucher.SL_Cat in ('P','B'))       
  Left Join pVoucher pVoucher on (pVoucher.Voucher=oVoucher.RefNo and oVoucher.SL_Cat='B' and pvoucher.SL_Cat='P')  
  Inner Join nVoucher V on (V.Voucher=pSL.Doc_No)
  Where pSL.PaymentF=1 and pSL.Doc_No=nVoucher.Voucher     
 ) Payment  
) Voucher   

GO

insert into PatchVersioning
select '1436 Update Script - Patch 2025 (45)',GETDATE()
go	
  
Declare @PrevScript varchar(100)
Declare @CurrScript varchar(100)

Select @PrevScript=''
Select @CurrScript='1436 Update Script - Patch 2025 (45)'


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

GO