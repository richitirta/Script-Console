Begin tran
Declare @P_PDate as smalldatetime
Declare @P_ID as varchar(10)

Select @P_PDate='01/01/2021'	--Starting Date to Initialize
Select @P_ID='MHE00001'	-- Profile SUbject Pajak

---Check PASAL21 or Not
Select TaxTablePaid.* from TaxTablePaid , Profile 
Where Profile.ID=TaxTablePaid.ID and Profile.TaxType='PASAL21' and TaxTablePaid.Year>=Year(@P_PDate) and Profile.ID=@P_ID

--dengan nilai dibawah ini sama
Select Year(nVoucher.Date) Year, nVoucher.RefNo as ID, sum(-nVoucher.RefAmount) as PNominal, sum(nVoucher.Nominal_CC-nVoucher.Diff_CC) as Tax
from nVoucher, VType 
Where VType.VType=nVoucher.Vtype and VType.TaxF=1 and VType.TaxType='PASAL21' and nVoucher.Date>=@P_PDate and nVoucher.RefNo=@P_ID
Group by Year(nVoucher.Date), nVoucher.RefNo

---Initialize Tax Table for WH Tax

Select 
nVoucher.Voucher,
Year(nVoucher.Date) as Year,
nVoucher.RefNo as ID,
nVoucher.Currency,
coalesce(nSL.RefAmount,0) as RefAmount,
nVoucher.Nominal_CC-nVoucher.Diff_CC as Tax
into #T2
from nVoucher
Left Join 
(
	Select Voucher, sum(RefAmount) as RefAmount
	from
	(
		Select 
		nVoucher.Voucher,
		Case 
		When RefVoucher.Tax_CC=0 then
			Case When RefVoucher.DebtorF=1 then 1 else -1 end*(Select sum(PNominal_Tax) from Admlink A Where A.Voucher=RefVoucher.Voucher)*nSL.Rate*(Case When RefVoucher.DebtorF=1 Then -1 else 1 end)
		else
			Case When RefVoucher.DebtorF=1 then 1 else -1 end*(Select sum(PNominal_Tax) from Admlink A Where A.Voucher=RefVoucher.Voucher)/(-RefVoucher.Tax_CC)*nSL.Rate*nSL.Nominal_OC 
		end as RefAmount
		from nVoucher, VType, nSL, nVoucher RefVoucher
		where VType.VType=nVoucher.VType 
		and VType.TaxF=1 and nSL.Voucher=nVoucher.Voucher
		and RefVoucher.Voucher=nSL.Doc_No 
		and VType.TaxType='PASAL21'
		and nVoucher.Date>=@P_PDate
		and nVoucher.RefNo=@P_ID
	) nSL
	Group by nSL.Voucher
) nSL on (nSL.Voucher=nVoucher.Voucher)
, VType
Where VType.VType=nVoucher.VType and VType.TaxF=1 
and VType.TaxType='PASAL21'
and nVoucher.Date>=@P_PDate
and nVoucher.RefNo=@P_ID

Update nVoucher Set Refamount=0 
from nVoucher, VType
Where VType.VType=nVoucher.VType and VType.TaxF=1 
and VType.TaxType='PASAL21'
and nVoucher.Date>=@P_PDate
and nVoucher.RefNo=@P_ID

Update nVoucher set RefAmount=#T2.RefAmount from nVoucher, #T2 Where #T2.Voucher=nVoucher.Voucher

Delete from TaxTablePaid Where Year>=Year(@P_PDate) and ID=@P_ID
insert into TaxTablePaid(Year,ID,PNominal,Tax) Select Year, ID, sum(-RefAmount), sum(Tax) from #T2 Group By Year, ID


drop table #T2

--Rollback
commit tran

