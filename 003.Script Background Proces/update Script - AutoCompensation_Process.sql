IF EXISTS ( SELECT * FROM   sysobjects WHERE  id = object_id(N'AutoCompensation_Process') and OBJECTPROPERTY(id, N'IsProcedure') = 1 )
BEGIN
DROP Procedure AutoCompensation_Process
end
GO
CREATE Procedure AutoCompensation_Process(@P_PDate as smalldatetime)                  
as                  
Select Distinct A2.Branch, A2.Type, A2.Subject, A2.A_PolicyNo, A2.ID, A2.Currency, A2.Remarks, A2.DocNo, A2.RefNo, A1.CT, A1.ProAcc, A1.Voucher, A1.Date, A1.DebtorF, A1.CreditorF, A1.Nominal_CC, A1.Diff_CC, A1.Payment_CC
from nVoucher a1 
Inner Join Admlink A2 On (A2.Voucher=A1.Voucher) 
where round(a1.NOMINAL_CC-a1.DIFF_CC-a1.PAYMENT_CC,4)<>0 and A1.Payment_CC=0 
and Exists (
	Select A4.A_PolicyNo from nVoucher Voucher, Admlink A4 Where A4.Date<=@P_PDate and A4.Voucher=Voucher.Voucher and Voucher.Payment_CC=0 and A4.Type=A2.Type and A4.Subject=A2.Subject and A4.A_PolicyNo=A2.A_PolicyNo and A4.ID=A2.ID and A4.Currency=A2.Currency and A4.RefNo=A2.RefNo 
	and Not Exists (Select Top 1 CollectionV.Voucher from CollectionV, CollectionH Where CollectionH.CollNo=CollectionV.COllNo and CollectionH.CollStatus<>'C' and CollectionV.CollNo<>Voucher.CollNo and CollectionV.Voucher=Voucher.Voucher)   
	and Not Exists (Select Top 1 SL.doc_no from SL_Request SL, Request R Where R.Status<>'C' and R.Voucher='' and R.Request=SL.Request and SL.doc_no=Voucher.Voucher)	
	Group by A4.A_PolicyNo 
	having round(sum(A4.Amount),2)=0
)
and A2.Date<=@P_PDate
and A2.Subject = 'Premium' 
and Not Exists (Select Top 1 CollectionV.Voucher from CollectionV, CollectionH Where CollectionH.CollNo=CollectionV.COllNo and CollectionH.CollStatus<>'C' and CollectionV.CollNo<>A1.CollNo and CollectionV.Voucher=A1.Voucher)   
and Not Exists (Select Top 1 SL.doc_no from SL_Request SL, Request R Where R.Status<>'C' and R.Voucher='' and R.Request=SL.Request and SL.doc_no=A1.Voucher)	
Order By A2.Branch, A2.A_PolicyNo, A2.Type, A2.Subject, A2.ID, A2.Currency, A2.RefNo
go

  insert into PatchVersioning
select 'update Script - AutoCompensation_Process',GETDATE()
go
