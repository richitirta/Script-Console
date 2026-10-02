DROP FUNCTION VAT_OUT_PROCESS
GO
CREATE FUNCTION VAT_OUT_PROCESS(@P_Type varchar(2),@P_Date smalldatetime, @P_PEDate smalldatetime,@P_EDate smalldatetime)                            
RETURNS TABLE                            
AS RETURN(                            
select A.Branch, V.Voucher as DocNo, Case When pVoucher.SL_Cat='P' Then pVoucher.Voucher else pVoucher.RefNo end as RefNo, 
Case When Branch.End_Date<pVoucher.Date Then pVoucher.Date else dateadd(day,1,Branch.End_Date) end as Date, A.Code as Code, @P_Type as Type, SysTab.Currency, 'JOURNAL' as Subject, cast(Left(A.Remarks,510) as nvarchar(1024)) as Remarks,
'Amount_1'  = Case When (A.Subject='Premium' and A.Type in ('DI','IC','BO')) then dbo.fn_SL_Payment_Nominal(SL.Nominal_OC, pVoucher.SL_Cat, pVoucher.DebtorF, V.DebtorF)*A.Amount_13/(Case When V.DebtorF=1 Then (V.Nominal_CC-V.Diff_CC) Else -(V.Nominal_CC-V.Diff_CC) end)*V.Rate else 0 end,
'Amount_2'  = Case When (A.Subject='Premium' and A.Type in ('DC','XP','CP','QS','QP','S1','S2','S3','AF','FO')) then dbo.fn_SL_Payment_Nominal(SL.Nominal_OC, pVoucher.SL_Cat, pVoucher.DebtorF, V.DebtorF)*A.Amount_13/(Case When V.DebtorF=1 Then (V.Nominal_CC-V.Diff_CC) Else -(V.Nominal_CC-V.Diff_CC) end)*V.Rate else 0 end,
'Amount_3'  = 0,
'Amount_4'  = Case When (A.Type in ('OP') and (A.Subject='Claim' and A.Amount_8<>0)) then dbo.fn_SL_Payment_Nominal(SL.Nominal_OC, pVoucher.SL_Cat, pVoucher.DebtorF, V.DebtorF)*A.Amount_13/(Case When V.DebtorF=1 Then (V.Nominal_CC-V.Diff_CC) Else -(V.Nominal_CC-V.Diff_CC) end)*V.Rate else 0 end,
'Amount_5'  = 0,
'Amount'    = dbo.fn_SL_Payment_Nominal(SL.Nominal_OC, pVoucher.SL_Cat, pVoucher.DebtorF, V.DebtorF)*A.Amount_13/(Case When V.DebtorF=1 Then (V.Nominal_CC-V.Diff_CC) Else -(V.Nominal_CC-V.Diff_CC) end)*V.Rate
from pSL SL, pVoucher, nVoucher V, Admlink A, SysTab, Branch
where A.Voucher=V.Voucher and pVoucher.Voucher=SL.Voucher and V.Voucher=SL.Doc_No and SL.PaymentF=1 and V.SL_Cat='N' 
       and Branch.Branch=V.Branch
       and pVoucher.Date>@P_PEDate and pVoucher.Date<=@P_EDate
       and A.Amount_13<>0
       and (
              (A.Subject='Premium' and A.Type in ('DI','IC','BO')) or
              (A.Subject='Premium' and A.Type in ('DC','XP','CP','QS','QP','S1','S2','S3','AF','FO')) or
              (A.Type in ('OP') and (A.Subject='Claim' and A.Amount_8<>0))  -- Claim Salvage
       )
)                            
 
GO
 
 
DROP FUNCTION VAT_IN_PROCESS
GO
CREATE FUNCTION VAT_IN_PROCESS(@P_Type varchar(2),@P_Date smalldatetime, @P_PEDate smalldatetime,@P_EDate smalldatetime)                            
RETURNS TABLE                            
AS RETURN(                            
select A.Branch, V.Voucher as DocNo, Case When pVoucher.SL_Cat='P' Then pVoucher.Voucher else pVoucher.RefNo end as RefNo, 
Case When Branch.End_Date<pVoucher.Date Then pVoucher.Date else dateadd(day,1,Branch.End_Date) end as Date, A.Code as Code, @P_Type as Type, SysTab.Currency, 'JOURNAL' as Subject, cast(Left(A.Remarks,510) as nvarchar(1024)) as Remarks,
'Amount_1'  = Case When (A.Subject='Others' and A.Type like 'OT%') then dbo.fn_SL_Payment_Nominal(SL.Nominal_OC, pVoucher.SL_Cat, pVoucher.DebtorF, V.DebtorF)*A.Amount_13/(Case When V.DebtorF=1 Then (V.Nominal_CC-V.Diff_CC) Else -(V.Nominal_CC-V.Diff_CC) end)*V.Rate else 0 end,
'Amount_2'  = Case When (A.Subject='Premium' and A.Type in ('BB','BA','BC','IR','IT','IX')) then dbo.fn_SL_Payment_Nominal(SL.Nominal_OC, pVoucher.SL_Cat, pVoucher.DebtorF, V.DebtorF)*A.Amount_13/(Case When V.DebtorF=1 Then (V.Nominal_CC-V.Diff_CC) Else -(V.Nominal_CC-V.Diff_CC) end)*V.Rate else 0 end,
'Amount_3'  = 0,
'Amount_4'  = 0,                       
'Amount_5'  = Case When ((A.Subject='Claim' and A.Type in ('DI','IC','IR','IT','IX')) or (A.Type in ('OP') and not (A.Subject='Claim' and A.Amount_8<>0))) then dbo.fn_SL_Payment_Nominal(SL.Nominal_OC, pVoucher.SL_Cat, pVoucher.DebtorF, V.DebtorF)*A.Amount_13/(Case When V.DebtorF=1 Then (V.Nominal_CC-V.Diff_CC) Else -(V.Nominal_CC-V.Diff_CC) end)*V.Rate else 0 end,
'Amount'    = dbo.fn_SL_Payment_Nominal(SL.Nominal_OC, pVoucher.SL_Cat, pVoucher.DebtorF, V.DebtorF)*A.Amount_13/(Case When V.DebtorF=1 Then (V.Nominal_CC-V.Diff_CC) Else -(V.Nominal_CC-V.Diff_CC) end)*V.Rate
from pSL SL, pVoucher, nVoucher V, Admlink A, SysTab, Branch
where A.Voucher=V.Voucher and pVoucher.Voucher=SL.Voucher and V.Voucher=SL.Doc_No and SL.PaymentF=1 and V.SL_Cat='N' 
       and Branch.Branch=V.Branch
       and pVoucher.Date>@P_PEDate and pVoucher.Date<=@P_EDate
       and A.Amount_13<>0
       and (
              (A.Subject='Premium' and A.Type in ('BB','BA','BC','IR','IT','IX')) or
              (A.Subject='Claim' and A.Type in ('DI','IC','IR','IT','IX')) or -- Claim Loss
              (A.Type in ('OP') and not (A.Subject='Claim' and A.Amount_8<>0)) or  -- Others Party exclude Claim Salvage
              (A.Subject='Others' and A.Type like 'OT%')      -- Others Transaction
       )
)                            
 
 
