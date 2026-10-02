DROP Procedure AutoGenerateAutoPayment_Process
GO
CREATE Procedure AutoGenerateAutoPayment_Process(@P_PDate as smalldatetime)                                            
as                                      
Select A_PolicyNo, A.Voucher, A.RefNo, A.Type, A.Subject, A.Currency, 'AutoReceiptRequest_Process' as ProcName, sum(round(AmountPaid,4)) as AmountPaid,
(Select Top 1 Remarks from ARBucket Where ARBucket.RefDate<=@P_PDate and ARBucket.A_PolicyNo=A.A_PolicyNo and ARBucket.AmountPaid>0 and ARBucket.Status='P' Order by PID Desc) as Remarks
from
(
	Select A.*, 
	case 
	When (Case When Nominal_CC*PaymentPCT/100>Outstanding_CC Then Outstanding_CC else Nominal_CC*PaymentPCT/100 end)>Payment_CC then 
		(Case When Nominal_CC*PaymentPCT/100>Outstanding_CC Then Outstanding_CC else Nominal_CC*PaymentPCT/100 end)-Payment_CC 
	else 
		0 
	end
	*(Case When A.DebtorF=1 Then 1 else -1 end) as AmountPaid
	from
	(
		Select Distinct V2.Voucher, V2.Date, V2.Currency, V2.DebtorF, Ad.A_PolicyNo, Ad.DocNo, Ad.RefNo, Ad.Type, Ad.Subject, V2.Nominal_CC-V2.Diff_CC as Nominal_CC, V2.Payment_CC, V2.Nominal_CC-V2.Diff_CC-V2.Payment_CC as Outstanding_CC
		from nVoucher V2 with (readcommitted) 
		Inner Join Admlink Ad on (Ad.Voucher=V2.Voucher and Ad.Subject='PREMIUM' and Ad.Type in ('BB','BO','BA','BC','FO'))
		Inner Join BRRule BR on (BR.AutoGenerateAutoPaymentF=1 and BR.TOC=Ad.Code and (BR.Branch='<All>' or BR.Branch=Ad.Branch) and (BR.BizmapID='<All>' or BR.BizMapID=Ad.BizMapID)) 
		and Not Exists (Select Top 1 SL.doc_no from SL_Request SL, Request R Where R.Status<>'C' and R.Voucher='' and R.Request=SL.Request and SL.doc_no=V2.Voucher)
	) A
	Cross Apply (Select dbo.Get_Payment_Percentage(A.A_PolicyNo,A.Type, A.DOCNO, A.Date, A.Currency) as PaymentPCT) P
	Where not exists (Select Top 1 PID from ARBucket Where ARBucket.A_PolicyNo=A.A_PolicyNo and ARBucket.RefNo=A.RefNo and ARBucket.Type=A.Type and ARBucket.Subject=A.Subject and ARBucket.Status='R')
) A
Group By A_PolicyNo, A.Voucher, A.RefNo, A.Type, A.Subject, A.Currency
Having sum(round(AmountPaid,4))<0




