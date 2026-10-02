DROP Procedure AutoReceipt_Process
GO
CREATE Procedure AutoReceipt_Process(@P_PDate as smalldatetime)                                            
as                                      
Select ARBucket.PID, ARBucket.Remarks, ARBucket.Last_Opr, ARBucket.ComAcc, ARBucket.Branch, ARBucket.RefType, ARBucket.RefDate, ARBucket.RefNo, ARBucket.AmountPaid, ARBucket.Rate, ARBucket.SAccount, ARBucket.Charges, ARBucket.EAccount, Admlink.ID, nVoucher.Voucher, nVoucher.DebtorF, nVoucher.Remarks, nVoucher.Date, nVoucher.ProAcc, nVoucher.Branch, nVoucher.Currency, Case When nVoucher.DebtorF=1 Then (nVoucher.Nominal_CC-nVoucher.Diff_CC-nVoucher.Payment_CC) else -(nVoucher.Nominal_CC-nVoucher.Diff_CC-nVoucher.Payment_CC) end as Outstanding              
from ARBucket with (ReadCommitted)
Inner Join Admlink with (ReadCommitted) on (  
(  
 (coalesce(ARBucket.A_PolicyNo,'')='' or (Admlink.A_PolicyNo=ARBucket.A_PolicyNo)) and 
 (coalesce(ARBucket.Voucher,'')='' or (Admlink.Voucher=ARBucket.Voucher)) and 
 (coalesce(ARBucket.RefNo,'')='' or (Admlink.RefNo=ARBucket.RefNo)) and 
 (coalesce(ARBucket.AccountNo,'')='' or (Admlink.Bank=ARBucket.Bank and Admlink.AccountNo=ARBucket.AccountNo)) 
)  
and Admlink.Subject='Premium' and Admlink.Type in ('DI','IC','IR','IT','IX') and Admlink.Date<=ARBucket.RefDate and Admlink.Date<=@P_PDate   
)      
Inner Join nVoucher on (nVoucher.Voucher=Admlink.Voucher)      
Where ARBucket.Status='R'              
and round(coalesce(nVoucher.Nominal_CC-nVoucher.Diff_CC-nVoucher.Payment_CC,0),2)>=0
and not Exists (Select CollectionV.Voucher from CollectionV, CollectionH where CollectionV.CollNo=CollectionH.CollNo and CollectionH.CollStatus<>'C' and CollectionV.Voucher=nVoucher.Voucher)              
and not Exists (Select SL.doc_no from SL_Request SL, Request R Where R.Status<>'C' and R.Voucher='' and R.Request=SL.Request and SL.doc_no=nVoucher.Voucher)               
order by ARBucket.PID, Admlink.AdmNo








