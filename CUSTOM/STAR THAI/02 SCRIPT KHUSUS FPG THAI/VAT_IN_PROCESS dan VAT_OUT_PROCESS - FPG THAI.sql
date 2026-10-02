drop function VAT_IN_PROCESS
go

CREATE FUNCTION VAT_IN_PROCESS(@P_Type varchar(2),@P_Date smalldatetime, @P_PEDate smalldatetime,@P_EDate smalldatetime)                            
RETURNS TABLE                            
AS RETURN(                            
select A.Branch, A.DocNo, A.RefNo, @P_Date as Date, A.Code as Code, @P_Type as Type, SysTab.Currency, 'JOURNAL' as Subject, A.Remarks as Remarks,
 'Amount_1'  = Case When (A.Subject='Others' and A.Type like 'OT%') then dbo.fn_SL_Payment_Nominal(SL.Nominal_OC, pVoucher.SL_Cat, pVoucher.DebtorF, V.DebtorF)*A.Amount_13/(Case When V.DebtorF=1 Then (V.Nominal_CC-V.Diff_CC) Else -(V.Nominal_CC-V.Diff_CC) end)*V.Rate else 0 end,
 'Amount_2'  = Case When (A.Subject='Premium' and A.Type in ('BB','BA','BC','BO','OP')) then dbo.fn_SL_Payment_Nominal(SL.Nominal_OC, pVoucher.SL_Cat, pVoucher.DebtorF, V.DebtorF)*A.Amount_13/(Case When V.DebtorF=1 Then (V.Nominal_CC-V.Diff_CC) Else -(V.Nominal_CC-V.Diff_CC) end)*V.Rate else 0 end,
 'Amount_3'  = Case When (A.Subject='Premium' and A.Type in ('DC','XP','CP','QS','QP','S1','S2','S3','AF','FO')) then dbo.fn_SL_Payment_Nominal(SL.Nominal_OC, pVoucher.SL_Cat, pVoucher.DebtorF, V.DebtorF)*A.Amount_13/(Case When V.DebtorF=1 Then (V.Nominal_CC-V.Diff_CC) Else -(V.Nominal_CC-V.Diff_CC) end)*V.Rate else 0 end,
 'Amount_4'  = 0,                       
 'Amount_5'  = Case When (A.Subject='Claim' and A.Type in ('DI','IC','IR','IT','IX')) or (A.Subject='Claim' and A.Type in ('OP') and A.Amount_9<>0) then dbo.fn_SL_Payment_Nominal(SL.Nominal_OC, pVoucher.SL_Cat, pVoucher.DebtorF, V.DebtorF)*A.Amount_13/(Case When V.DebtorF=1 Then (V.Nominal_CC-V.Diff_CC) Else -(V.Nominal_CC-V.Diff_CC) end)*V.Rate else 0 end,
 'Amount'    = dbo.fn_SL_Payment_Nominal(SL.Nominal_OC, pVoucher.SL_Cat, pVoucher.DebtorF, V.DebtorF)*A.Amount_13/(Case When V.DebtorF=1 Then (V.Nominal_CC-V.Diff_CC) Else -(V.Nominal_CC-V.Diff_CC) end)*V.Rate
from pSL SL, pVoucher, nVoucher V, Admlink A, SysTab
where A.Voucher=V.Voucher and pVoucher.Voucher=SL.Voucher and V.Voucher=SL.Doc_No and SL.PaymentF=1 and V.SL_Cat='N' 
and pVoucher.Date>@P_PEDate and pVoucher.Date<=@P_EDate
and A.Amount_13<>0
and (
	(A.Subject='Premium' and A.Type in ('BB','BA','BC','BO','OP')) or
	(A.Subject='Premium' and A.Type in ('DC','XP','CP','QS','QP','S1','S2','S3','AF','FO')) or
	(A.Subject='Claim' and A.Type in ('DI','IC','IR','IT','IX')) or -- Claim Loss
	(A.Subject='Claim' and A.Type in ('OP') and A.Amount_9<>0) or	-- Claim Expenses
	(A.Subject='Others' and A.Type like 'OT%')	-- Others Transaction
)
)                            
go

drop function VAT_OUT_PROCESS
go

CREATE FUNCTION VAT_OUT_PROCESS(@P_Type varchar(2),@P_Date smalldatetime, @P_PEDate smalldatetime,@P_EDate smalldatetime)                            
RETURNS TABLE                            
AS RETURN(                            
select A.Branch, A.DocNo, A.RefNo, @P_Date as Date, A.Code as Code, @P_Type as Type, SysTab.Currency, 'JOURNAL' as Subject, A.Remarks as Remarks,
 'Amount_1'  = Case When (A.Subject='Premium' and A.Type in ('DI','IC','IR','IT','IX')) Then A.Amount_13*V.Rate else 0 end,
 'Amount_2'  = 0,
 'Amount_3'  = 0,                       
 'Amount_4'  = Case When (A.Subject='Claim' and A.Type in ('OP') and A.Amount_8<>0) Then A.Amount_13*V.Rate else 0 end,
 'Amount_5'  = 0,                       
 'Amount'    = A.Amount_13*V.Rate
from nVoucher V, Admlink A, SysTab, TOC
where A.Voucher=V.Voucher and TOC.TOC=A.CODE
and coalesce(V.TaxNo,'')<>'' and V.TaxDate>@P_PEDate and V.TaxDate<=@P_EDate
and (A.Amount_13<>0 or TOC.TAXINVOICEF=1)
and (
(A.Subject='Premium' and A.Type in ('DI','IC','IR','IT','IX')) or
(A.Subject='Claim' and A.Type in ('OP') and A.Amount_8<>0)	-- Claim Salvage
)
)                            
go