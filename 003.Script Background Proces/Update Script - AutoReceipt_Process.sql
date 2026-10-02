IF EXISTS ( SELECT * FROM   sysobjects WHERE  id = object_id(N'AutoReceipt_Process') and OBJECTPROPERTY(id, N'IsProcedure') = 1 )
BEGIN
DROP Procedure AutoReceipt_Process
end
GO
CREATE Procedure AutoReceipt_Process(@P_PDate as smalldatetime,@P_PID as int=0)                                            
as                                      
Select Distinct cast(Case When ARBucket.AmountPaid<0 Then 1 else 0 end as bit) as PaymentF, ARBucket.PID, ARBucket.Remarks, ARBucket.Last_Opr, ARBucket.ComAcc, ARBucket.Branch, ARBucket.CT, ARBucket.RefType, ARBucket.RefDate, ARBucket.RefNo, ARBucket.AmountPaid, ARBucket.Rate, ARBucket.SAccount, ARBucket.Charges, ARBucket.EAccount, Admlink.ID, nVoucher.Voucher, nVoucher.DebtorF, nVoucher.Remarks, nVoucher.Date, nVoucher.ProAcc, nVoucher.Branch, nVoucher.Currency, 
Case When nVoucher.DebtorF=1 Then (nVoucher.Nominal_CC-nVoucher.Diff_CC-nVoucher.Payment_CC) else -(nVoucher.Nominal_CC-nVoucher.Diff_CC-nVoucher.Payment_CC) end as Outstanding, ARBucket.AutoPrintF
from ARBucket with (ReadCommitted)
Inner Join Admlink with (ReadCommitted) on (  
(  
 (coalesce(ARBucket.A_PolicyNo,'')='' or (Admlink.A_PolicyNo=ARBucket.A_PolicyNo)) and 
 (coalesce(ARBucket.Voucher,'')='' or (Admlink.Voucher=ARBucket.Voucher)) and 
 (coalesce(ARBucket.RefNo,'')='' or (Admlink.RefNo=ARBucket.RefNo)) and 
 (coalesce(ARBucket.AccountNo,'')='' or (Admlink.Bank=ARBucket.Bank and Admlink.AccountNo=ARBucket.AccountNo) or (Admlink.Bank_Ext=ARBucket.Bank and Admlink.AccountNo_Ext=ARBucket.AccountNo))
)  
and Admlink.Subject='Premium' 
and (ARBucket.Currency='' or Admlink.Currency=ARBucket.Currency) 
and (ARBucket.Type='' or Admlink.Type=ARBucket.Type) 
and (ARBucket.Subject='' or Admlink.Subject=ARBucket.Subject) 
and (Admlink.Type in ('DI','IC','IR','IT','IX') or (ARBucket.NetPaidF=1 and Admlink.Type in ('BB','BA','BC','BO') and Admlink.ID=Admlink.Source)) 
and Admlink.Date<=ARBucket.RefDate and Admlink.Date<=@P_PDate   
)      
Inner Join nVoucher on (nVoucher.Voucher=Admlink.Voucher)     
Left Join VAccount V1 on (Admlink.RefType='VIRTUAL' and V1.Bank=Admlink.Bank)
Left Join VAccountD V2 on (V2.VID=V1.VID and V2.AccountNo=Admlink.AccountNo) 
Left Join CollectionH C on (C.CollNo=V2.CollNo and C.CollStatus='R')
Where ARBucket.Status='R' and (PID = @P_PID or @P_PID = 0)                                                
and ARBucket.AmountPaid>0  -- Receipt Voucher
and (ARBucket.ProcName='' or ARBucket.ProcName='AutoReceipt_Process')
and round(coalesce(nVoucher.Nominal_CC-nVoucher.Diff_CC-nVoucher.Payment_CC,0),2)>=0
and not Exists (Select CollectionV.Voucher from CollectionV, CollectionH where CollectionH.CollNo<>coalesce(C.CollNo,'') and CollectionV.CollNo=CollectionH.CollNo and CollectionH.CollStatus<>'C' and CollectionV.Voucher=nVoucher.Voucher)              
and not Exists (Select SL.doc_no from SL_Request SL, Request R Where R.Status<>'C' and R.Voucher='' and R.Request=SL.Request and SL.doc_no=nVoucher.Voucher)               

Union All

Select Distinct cast(Case When ARBucket.AmountPaid<0 Then 1 else 0 end as bit) as PaymentF, ARBucket.PID, ARBucket.Remarks, ARBucket.Last_Opr, ARBucket.ComAcc, ARBucket.Branch, ARBucket.CT, ARBucket.RefType, ARBucket.RefDate, ARBucket.RefNo, ARBucket.AmountPaid, ARBucket.Rate, ARBucket.SAccount, ARBucket.Charges, ARBucket.EAccount, Admlink.ID, nVoucher.Voucher, nVoucher.DebtorF, nVoucher.Remarks, nVoucher.Date, nVoucher.ProAcc, nVoucher.Branch, nVoucher.Currency, Case When nVoucher.DebtorF=1 Then (nVoucher.Nominal_CC-nVoucher.Diff_CC-nVoucher.Payment_CC) else -(nVoucher.Nominal_CC-nVoucher.Diff_CC-nVoucher.Payment_CC) end as Outstanding, ARBucket.AutoPrintF
from ARBucket with (ReadCommitted)
Inner Join Admlink with (ReadCommitted) on (  
(  
 (coalesce(ARBucket.A_PolicyNo,'')='' or (Admlink.A_PolicyNo=ARBucket.A_PolicyNo)) and 
 (coalesce(ARBucket.Voucher,'')='' or (Admlink.Voucher=ARBucket.Voucher)) and 
 (coalesce(ARBucket.RefNo,'')='' or (Admlink.RefNo=ARBucket.RefNo))
)  
and 
(
(Admlink.Subject='Claim' and (ARBucket.Currency='' or Admlink.Currency=ARBucket.Currency) and (ARBucket.Type='' or Admlink.Type=ARBucket.Type) and Admlink.Subject=ARBucket.Subject and Admlink.Type in ('DI','IC','IR','IT','IX'))
or
(Admlink.Subject='Premium' and (ARBucket.Currency='' or Admlink.Currency=ARBucket.Currency) and (ARBucket.Type='' or Admlink.Type=ARBucket.Type) and (ARBucket.Subject='' or Admlink.Subject=ARBucket.Subject) and Admlink.Type in ('BB','BA','BO','BC','FO'))



)
and Admlink.Date<=ARBucket.RefDate and Admlink.Date<=@P_PDate   
)      
Inner Join nVoucher on (nVoucher.Voucher=Admlink.Voucher)
Left Join VAccount V1 on (Admlink.RefType='VIRTUAL' and V1.Bank=Admlink.Bank)
Left Join VAccountD V2 on (V2.VID=V1.VID and V2.AccountNo=Admlink.AccountNo) 
Left Join CollectionH C on (C.CollNo=V2.CollNo and C.CollStatus='R')
Where ARBucket.Status='R' and (PID = @P_PID or @P_PID = 0)                                              
and ARBucket.AmountPaid<0  -- Payment Voucher
and (ARBucket.ProcName='' or ARBucket.ProcName='AutoReceipt_Process')       
and round(coalesce(nVoucher.Nominal_CC-nVoucher.Diff_CC-nVoucher.Payment_CC,0),2)>=0
and not Exists (Select CollectionV.Voucher from CollectionV, CollectionH where CollectionH.CollNo<>coalesce(C.CollNo,'') and CollectionV.CollNo=CollectionH.CollNo and CollectionH.CollStatus<>'C' and CollectionV.Voucher=nVoucher.Voucher)              
and not Exists (Select SL.doc_no from SL_Request SL, Request R Where R.Status<>'C' and R.Voucher='' and R.Request=SL.Request and SL.doc_no=nVoucher.Voucher)               
order by ARBucket.PID

go

  insert into PatchVersioning
select 'Update Script - AutoReceipt_Process',GETDATE()
go