DROP FUNCTION R_SL_ALLOCATED_BY_VOUCHER
GO
CREATE FUNCTION R_SL_ALLOCATED_BY_VOUCHER(@P_Voucher as varchar(20)='')                               

RETURNS TABLE  AS                                 

RETURN (                               

--SL from Payment Voucher                                       

Select pSL.Voucher, pVoucher.Branch, pVoucher.Currency as Doc_CCY, pSL.Voucher as Doc_No, pSL.Account, Max(pSL.Hint) as Hint, sum(pSL.Nominal) as Nominal_OC, cast(1 as Bit) as PaymentF, cast(1 as Float) as Rate                                    

From dbo.pSL                      

Inner Join dbo.pVoucher on (pVoucher.Voucher=pSL.Voucher)                      

Where pVoucher.SL_Cat in ('P') and pSL.PaymentF=1 

and (pVoucher.Voucher=@P_Voucher or @P_Voucher='')      

Group By pSL.Voucher, pVoucher.Branch, pVoucher.Currency, pSL.Account

    

Union All    

    

--SL from InterOffice Overbooking Voucher                                       

Select pVoucher.RefNo as Voucher, pVoucher.Branch, OVoucher.Currency as Doc_CCY, pVoucher.RefNo as Doc_No, pSL.Account, Max(pSL.Hint) as Hint, sum(pSL.Nominal) as Nominal_OC, cast(1 as Bit) as PaymentF, cast(1 as Float) as Rate

From dbo.pSL                      

Inner Join dbo.pVoucher on (pVoucher.Voucher=pSL.Voucher)              

Inner Join dbo.pVoucher OVoucher on (OVoucher.Voucher=pVoucher.RefNo)            

Where pVoucher.SL_Cat in ('B') and pVoucher.RefType='INTEROFFICE' and pSL.PaymentF=1                 

and (pVoucher.RefNo=@P_Voucher or @P_Voucher='')      

Group by pVoucher.RefNo, pVoucher.Branch, OVoucher.Currency, pSL.Account

                                       

union all                                       

                                       

--SL from Overbooking Payment and Adjustment Payment                                       

Select SL.Voucher, VoucherR.Branch, VoucherP.Currency as Doc_CCY, VoucherP.Voucher as Doc_No, SL.SAccount as Account, MAX(SL.Hint) AS HINT,  

sum((case When VoucherR.DebtorF=VoucherP.DebtorF Then SL.Nominal else -SL.Nominal end)) as Nominal_OC, cast(1 as Bit) as PaymentF, cast(1 as Float) as Rate                                       

from pSL SL, pVoucher VoucherP, pVoucher VoucherR  

Where VoucherR.RefType<>'INTEROFFICE' and VoucherR.SL_Cat in ('B','A') and VoucherP.SL_Cat='P' and VoucherR.RefNo=VoucherP.Voucher and SL.Voucher=VoucherR.Voucher                        

and (VoucherP.Voucher=@P_Voucher or @P_Voucher='')  

Group By SL.Voucher, VoucherR.Branch, VoucherP.Currency, VoucherP.Voucher, SL.SAccount  

                                 

union all                                       

                                       

--SL from Adjustment Overbooking                                       

Select SL.Voucher, VoucherR.Branch, VoucherP.Currency as Doc_CCY, VoucherP.RefNo as Doc_No, SL.SAccount as Account, MAX(SL.Hint) AS HINT,  

sum((case When VoucherR.DebtorF=VoucherP.DebtorF Then SL.Nominal else -SL.Nominal end)) as Nominal_OC, cast(1 as Bit) as PaymentF, cast(1 as Float) as Rate

from pSL SL, pVoucher VoucherP, pVoucher VoucherR  

Where VoucherR.RefType<>'INTEROFFICE' and VoucherR.SL_Cat in ('A') and VoucherP.SL_Cat in ('B') and VoucherR.RefNo=VoucherP.Voucher and SL.Voucher=VoucherR.Voucher                 

and (VoucherP.RefNo=@P_Voucher or @P_Voucher='')  

Group By SL.Voucher, VoucherR.Branch, VoucherP.Currency, VoucherP.RefNo, SL.SAccount  



                                       

union all                                       

                                       

--SL from Sub Ledger Payment Voucher and OverPaid                                       

Select SL.Voucher, VoucherR.Branch, VoucherP.Currency as Doc_CCY, SL.Doc_No as Doc_No, SL.Account, SL.Hint,  

(Case When VoucherR.SL_Cat='O'                                        

then (case when VoucherR.DebtorF=VoucherP.DebtorF then SL.Nominal_OC else -SL.Nominal_OC end)                                        

else (case when VoucherR.DebtorF<>VoucherP.DebtorF then SL.Nominal_OC else -SL.Nominal_OC end)                                       

end) as Nominal_OC, cast(1 as Bit) as PaymentF, cast(1 as Float) as Rate

from pSL SL, pVoucher VoucherP, pVoucher VoucherR                                       

Where VoucherR.SL_Cat in ('O','P','A','B') and VoucherP.SL_Cat in ('P') and VoucherR.Voucher=SL.Voucher and SL.Doc_No=VoucherP.Voucher and SL.PaymentF=1                                       

and (SL.Doc_No=@P_Voucher or @P_Voucher='')                         

                               

)         

GO