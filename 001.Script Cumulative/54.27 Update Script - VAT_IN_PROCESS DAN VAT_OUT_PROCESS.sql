if exists (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'VAT_IN_PROCESS') AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) )
BEGIN
DROP FUNCTION VAT_IN_PROCESS
end
GO
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
       (A.Subject='Claim' and A.Type in ('OP') and A.Amount_9<>0) or -- Claim Expenses
       (A.Subject='Others' and A.Type like 'OT%')      -- Others Transaction
)
)                            



GO
if exists (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'VAT_OUT_PROCESS') AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) )
BEGIN
DROP FUNCTION VAT_OUT_PROCESS
end

GO
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
from nVoucher V, Admlink A, SysTab
where A.Voucher=V.Voucher 
and coalesce(V.TaxNo,'')<>'' and V.TaxDate>@P_PEDate and V.TaxDate<=@P_EDate
and A.Amount_13<>0
and (
(A.Subject='Premium' and A.Type in ('DI','IC','IR','IT','IX')) or
(A.Subject='Claim' and A.Type in ('OP') and A.Amount_8<>0)	-- Claim Salvage
)
)                            
go

  insert into PatchVersioning
select '54.27 Update Script - VAT_IN_PROCESS DAN VAT_OUT_PROCESS',GETDATE()
go

Declare @PrevScript varchar(100)
Declare @CurrScript varchar(100)

Select @PrevScript='54.26 Update Script - TNYD_PROCESS'
Select @CurrSCript='54.27 Update Script - VAT_IN_PROCESS DAN VAT_OUT_PROCESS'


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





