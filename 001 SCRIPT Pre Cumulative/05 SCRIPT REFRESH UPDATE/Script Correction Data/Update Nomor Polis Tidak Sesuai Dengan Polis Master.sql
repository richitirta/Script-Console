Begin tran

--PERBAIKAN NO POLIS YANG TIDAK SESUAI DENGAN NO POLIS SEBELUMNYA
Update A2 Set PolicyNo=A1.PolicyNo from Acceptance A1, Acceptance A2 
Where A2.pANO=A1.ANO and A2.PolicyNo<>A1.PolicyNo and A1.PolicyNo<>''

Update A2 Set PolicyNo=A1.PolicyNo from Acceptance A1, Acceptance A2 
Where A2.pANO=A1.ANO and A2.PolicyNo<>A1.PolicyNo and A1.PolicyNo<>''

Update A2 Set PolicyNo=A1.PolicyNo from Acceptance A1, Acceptance A2 
Where A2.pANO=A1.ANO and A2.PolicyNo<>A1.PolicyNo and A1.PolicyNo<>''

Update A2 Set PolicyNo=A1.PolicyNo from Acceptance A1, Acceptance A2 
Where A2.pANO=A1.ANO and A2.PolicyNo<>A1.PolicyNo and A1.PolicyNo<>''

Update A2 Set PolicyNo=A1.PolicyNo from Acceptance A1, Acceptance A2 
Where A2.pANO=A1.ANO and A2.PolicyNo<>A1.PolicyNo and A1.PolicyNo<>''

Update A2 Set PolicyNo=A1.PolicyNo from Acceptance A1, Acceptance A2 
Where A2.pANO=A1.ANO and A2.PolicyNo<>A1.PolicyNo and A1.PolicyNo<>''

--PERBAIKAN NO POLIS SERTIFICATE YANG TIDAK SESUAI DENGAN NO POLIS MASTERNYA
Update A2 Set PolicyNo=A1.PolicyNo from Acceptance A1, Acceptance A2 
Where A2.LANO=A1.ANO and A2.PolicyNo<>A1.PolicyNo and A1.PolicyNo<>''

Update A2 
Set DocNo=A3.PolicyNo+Case When A3.CertificateNo='' Then '' Else '-'+A3.CERTIFICATENO end+Case When A3.ESeqNo>0 Then '-'+Cast(A3.ESeqNo as varchar(10))+'/'+Cast(A3.EESeqNo as varchar(10)) else '' end,POLICYNO=A3.POLICYNO
from Admlink A1, AccAss A2, Acceptance A3, Cover C
Where A3.ANO=A2.ANO and A2.AdmNo=A1.AdmNo 
and C.CNO=A3.CNO 
and ((A3.ANO<>A3.LANO and A3.LANO<>-1 and C.OpenFlag=1 and A3.BulkF=0) or A3.LANO=-1)
and A2.DocNo<>A3.PolicyNo+Case When A3.CertificateNo='' Then '' Else '-'+A3.CERTIFICATENO end+Case When A3.ESeqNo>0 Then '-'+Cast(A3.ESeqNo as varchar(10))+'/'+Cast(A3.EESeqNo as varchar(10)) else '' end

Update A1
Set DocNo=A3.PolicyNo+Case When A3.CertificateNo='' Then '' Else '-'+A3.CERTIFICATENO end+Case When A3.ESeqNo>0 Then '-'+Cast(A3.ESeqNo as varchar(10))+'/'+Cast(A3.EESeqNo as varchar(10)) else '' end, A_POLICYNO=A3.PolicyNo+Case When A3.CertificateNo='' Then '' Else '-'+A3.CERTIFICATENO end
from Admlink A1, AccAss A2, Acceptance A3, Cover C, SysTab
Where A3.ANO=A2.ANO and A2.AdmNo=A1.AdmNo 
and C.CNO=A3.CNO 
and ((A3.ANO<>A3.LANO and A3.LANO<>-1 and C.OpenFlag=1 and A3.BulkF=0) or A3.LANO=-1)
and A1.DocNo<>A3.PolicyNo+Case When A3.CertificateNo='' Then '' Else '-'+A3.CERTIFICATENO end+Case When A3.ESeqNo>0 Then '-'+Cast(A3.ESeqNo as varchar(10))+'/'+Cast(A3.EESeqNo as varchar(10)) else '' end
and (SysTab.DetailTreatyF=1 or A1.Type Not in ('QS','QP','S1','S2','S3','IT','IX'))

Update Claim Set PolicyNo=Acceptance.PolicyNo, CertificateNo=Acceptance.CertificateNo from Claim, Acceptance Where Acceptance.ANO=Claim.ANO
and Claim.PolicyNo<>Acceptance.PolicyNo

Update pSL Set Remarks=A1.DocNo+'-'+A1.RefNo+'-'+A1.Remarks
from pSL, Admlink A1, nVoucher V, AccAss A2, Acceptance A3, Cover C, SysTab
Where A3.ANO=A2.ANO and A2.AdmNo=A1.AdmNo 
and C.CNO=A3.CNO 
and ((A3.ANO<>A3.LANO and A3.LANO<>-1 and C.OpenFlag=1 and A3.BulkF=0) or A3.LANO=-1)
and V.Voucher=A1.Voucher
and A1.DocNo<>V.DocNo
and (SysTab.DetailTreatyF=1 or A1.Type Not in ('QS','QP','S1','S2','S3','IT','IX'))
and pSL.Doc_No=V.Voucher

Update pSL Set Remarks=A1.DocNo+'-'+A1.RefNo+'-'+A1.Remarks
from pSL, Admlink A1, nVoucher V, AccAss A2, Acceptance A3, Cover C, SysTab
Where A3.ANO=A2.ANO and A2.AdmNo=A1.AdmNo 
and C.CNO=A3.CNO 
and ((A3.ANO<>A3.LANO and A3.LANO<>-1 and C.OpenFlag=1 and A3.BulkF=0) or A3.LANO=-1)
and V.Voucher=A1.Voucher
and (SysTab.DetailTreatyF=1 or A1.Type Not in ('QS','QP','S1','S2','S3','IT','IX'))
and pSL.Doc_No=V.Voucher
and A1.Installment=0
and pSL.Remarks<>A1.DocNo+'-'+A1.RefNo+'-'+A1.Remarks

Update V Set DocNo=A1.DocNo
from Admlink A1, nVoucher V, AccAss A2, Acceptance A3, Cover C, SysTab
Where A3.ANO=A2.ANO and A2.AdmNo=A1.AdmNo 
and C.CNO=A3.CNO 
and ((A3.ANO<>A3.LANO and A3.LANO<>-1 and C.OpenFlag=1 and A3.BulkF=0) or A3.LANO=-1)
and V.Voucher=A1.Voucher
and A1.DocNo<>V.DocNo
and (SysTab.DetailTreatyF=1 or A1.Type Not in ('QS','QP','S1','S2','S3','IT','IX'))

--rollback
Commit tran
