Begin tran

Update RPart Set DocNo='' Where DocNo is null

Select Distinct R1.DocNo as DocNo, R2.DocNo as d_DocNo, R1.RNO, R1.SDate, R1.EDate into #R
from reinsurance r1, rpart r2 where R2.RNO=R1.RNO and R1.DocNo<>R2.DocNo and R2.DocNo<>''


--Check Data
Select #R.*, R.RDate, A1.RefNo
from RArrHeader R, AccAss A1, Admlink A2, nVoucher V, #R, ReClass R1
Where A2.Type in ('CP','XP','DC','QS','QP','S1','S2','S3','AF') 
and R.ANO=A1.ANO and A2.AdmNo=A1.AdmNo and V.Voucher=A2.Voucher and A1.RefNo=#R.d_DocNo 
and R1.RNO=#R.RNO and R.RDate Between #R.Sdate and #R.EDate and A1.TOC=A1.TOC

--Update Data
Update V Set RefNo=#R.DocNo, DocNo=Case When #R.d_DocNo=V.DocNo Then #R.DocNo else V.DocNo end
from RArrHeader R, AccAss A1, Admlink A2, nVoucher V, #R, ReClass R1
Where A2.Type in ('CP','XP','DC','QS','QP','S1','S2','S3','AF') 
and R.ANO=A1.ANO and A2.AdmNo=A1.AdmNo and V.Voucher=A2.Voucher and A1.RefNo=#R.d_DocNo 
and R1.RNO=#R.RNO and R.RDate Between #R.Sdate and #R.EDate and A1.TOC=A1.TOC


Update A2 Set RefNo=#R.DocNo, DocNo=Case When #R.d_DocNo=A2.DocNo Then #R.DocNo else A2.DocNo end
from RArrHeader R, AccAss A1, Admlink A2, nVoucher V, #R, ReClass R1
Where A2.Type in ('CP','XP','DC','QS','QP','S1','S2','S3','AF') 
and R.ANO=A1.ANO and A2.AdmNo=A1.AdmNo and V.Voucher=A2.Voucher and A1.RefNo=#R.d_DocNo 
and R1.RNO=#R.RNO and R.RDate Between #R.Sdate and #R.EDate and A1.TOC=A1.TOC

Update A1 Set RefNo=#R.DocNo, DocNo=Case When #R.d_DocNo=A1.DocNo Then #R.DocNo else A1.DocNo end
from RArrHeader R, AccAss A1, Admlink A2, nVoucher V, #R, ReClass R1
Where A2.Type in ('CP','XP','DC','QS','QP','S1','S2','S3','AF') 
and R.ANO=A1.ANO and A2.AdmNo=A1.AdmNo and V.Voucher=A2.Voucher and A1.RefNo=#R.d_DocNo 
and R1.RNO=#R.RNO and R.RDate Between #R.Sdate and #R.EDate and A1.TOC=A1.TOC


Update R Set DocNo=#R.DocNo
from RPart R, #R Where R.RNO=#R.RNO and R.DocNo=#R.d_DocNo

drop table #R

--rollback tran

Commit
