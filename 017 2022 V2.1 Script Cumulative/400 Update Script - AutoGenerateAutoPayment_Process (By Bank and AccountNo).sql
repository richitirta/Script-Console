DROP Procedure AutoGenerateAutoPayment_Process
GO
CREATE Procedure AutoGenerateAutoPayment_Process(@P_PDate as smalldatetime)                                            
as                                      
Select A.*
	from
	(
	Select A.Bank, A.AccountNo, A.Type, A.Subject, A.Currency, 'AutoReceiptRequest_Process' as ProcName, sum(round(AmountPaid,4)) as AmountPaid
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
			Select V.Voucher, V.Date, V.Currency, V.DebtorF, Ad.A_PolicyNo, Ad.Bank, Ad.AccountNo, Ad.DocNo, Ad.RefNo, Ad.Type, Ad.Subject, 
			(case When V.DebtorF=1 Then Ad.Amount else -Ad.Amount end) as Nominal_CC,
			(case When V.DebtorF=1 Then Ad.Amount else -Ad.Amount end)/(V.Nominal_CC-V.Diff_CC)*(V.Payment_CC) as Payment_CC,
			(case When V.DebtorF=1 Then Ad.Amount else -Ad.Amount end)/(V.Nominal_CC-V.Diff_CC)*(V.Nominal_CC-V.Diff_CC-V.Payment_CC) as Outstanding_CC
			from nVoucher V 
			Inner Join Admlink Ad on (Ad.Voucher=V.Voucher and Ad.Subject='PREMIUM' and Ad.Type in ('BA'))
			Inner Join BRRule BR on (BR.AutoGenerateAutoPaymentF=1 and BR.TOC=Ad.Code and (BR.Branch='<All>' or BR.Branch=Ad.Branch) and (BR.BizmapID='<All>' or BR.BizMapID=Ad.BizMapID) and BR.FacOpt=0 and (BR.TOPRO='<All>')) 
			and (V.Date<=@P_PDATE and Round(V.Nominal_CC-V.Diff_CC-V.Payment_CC-V.Payment_OC,4)<>0)
			and Not Exists (Select Top 1 SL.doc_no from SL_Request SL, Request R Where R.Status<>'C' and R.Voucher='' and R.Request=SL.Request and SL.doc_no=V.Voucher)
		) A
		Cross Apply (Select dbo.Get_Payment_Percentage(A.A_PolicyNo, A.Subject, A.Type, A.DOCNO, A.Date, A.Currency) as PaymentPCT) P
	) A
	Group By A.Bank, A.AccountNo, A.Type, A.Subject, A.Currency
	Having sum(round(AmountPaid,4))<0
) A
Outer Apply (Select Top 1 ARBucket.Status, ARBucket.Remarks from ARBucket Where ARBucket.ProcName=A.ProcName and ARBucket.Bank=A.Bank and ARBucket.AccountNo=A.AccountNo and ARBucket.Type=A.Type and ARBucket.Subject=A.Subject and ARBucket.Currency=A.Currency Order by ARBucket.PID Desc) ARBucket
Where coalesce(ARBucket.Status,'')<>'R'


