Begin tran

Declare @OANO int
Declare @CNO int
Declare @LANO int
Declare @CertificateNo as varchar(10)
Declare @NewCertificateNo as varchar(10)
Declare @CertNum int

Declare @PolicyNo as varchar(50)
Select @PolicyNo=''	-- Empty for ALL


--Only for Open Certificate
Declare Policy_Cursor Cursor For
Select Distinct A.PolicyNo
from
(
Select Acceptance.PolicyNo, Acceptance.CertificateNo, Max(Acceptance.ADate) as ADate
from Acceptance, Cover 
Where Cover.CNO=Acceptance.CNO and Acceptance.BulkF=0 and Cover.OpenFlag=1 and Acceptance.ANO<>Acceptance.LANO and Acceptance.LANO<>-1
and (Acceptance.PolicyNo=@PolicyNo or @PolicyNo='')
and Acceptance.PolicyNo<>''
Group by Acceptance.PolicyNo, Acceptance.CertificateNo
Having count(Distinct Acceptance.OANO)>1
) A

Open Policy_Cursor
FETCH FROM Policy_Cursor into @PolicyNo
WHILE @@FETCH_STATUS = 0  
BEGIN  
	Select @CNO=Max(C.CNO), @LANO=Max(A.LANO), @CertNum=Max(A.CertificateNo)
	from Acceptance A, Cover C Where C.CNO=A.CNO and A.PolicyNo=@PolicyNo

	Declare Certificate_cursor Cursor For 
	Select Acceptance.CertificateNo, Acceptance.OANO
	from Acceptance,
	(Select PolicyNo, CertificateNo, Min(OANO) as OANO 
	from acceptance 
	where PolicyNo=@PolicyNo
	Group by PolicyNo, CertificateNo
	Having count(Distinct OANO)>1
	) A1
	Where A1.PolicyNo=Acceptance.PolicyNo and A1.CertificateNo=Acceptance.CertificateNo and A1.OANO<>Acceptance.OANO

	Open Certificate_cursor
	FETCH FROM Certificate_cursor into @CertificateNo, @OANO
	WHILE @@FETCH_STATUS = 0  
	BEGIN  
		Select @CertNum=@CertNum+1
		Select @NewCertificateNo=right('000000'+cast(@CertNum as varchar(10)),6)

		Update Acceptance Set CNO=@CNO, LANO=@LANO, CertificateNo=@NewCertificateNo Where OANO=@OANO
		
		Update Claim Set CertificateNo=@NewCertificateNo from Claim, Acceptance Where Acceptance.ANO=Claim.ANO and Acceptance.OANO=@OANO
		
		Update AccAss Set DocNo=replace(AccAss.DocNo, @CertificateNo,@NewCertificateNo)
		from Admlink, AccAss, Acceptance
		Where Acceptance.ANO=AccAss.ANO and Admlink.AdmNo=AccAss.AdmNo and Acceptance.OANO=@OANO

		Update Admlink Set DocNo=replace(Admlink.DocNo, @CertificateNo,@NewCertificateNo), A_policyNo=replace(Admlink.A_policyNo, @CertificateNo,@NewCertificateNo) 
		from Admlink, AccAss, Acceptance
		Where Acceptance.ANO=AccAss.ANO and Admlink.AdmNo=AccAss.AdmNo and Acceptance.OANO=@OANO

		Update pSL Set Remarks=replace(pSL.Remarks, @CertificateNo,@NewCertificateNo) from pSL, nVoucher, Admlink, AccAss, Acceptance		
		Where pSL.Doc_No=nVoucher.Voucher and nVoucher.Voucher=Admlink.Voucher and Acceptance.ANO=AccAss.ANO and Admlink.AdmNo=AccAss.AdmNo and Acceptance.OANO=@OANO
				
		Update nVoucher Set DocNo=replace(nVoucher.DocNo, @CertificateNo,@NewCertificateNo) from nVoucher, Admlink, AccAss, Acceptance
		Where nVoucher.Voucher=Admlink.Voucher and Acceptance.ANO=AccAss.ANO and Admlink.AdmNo=AccAss.AdmNo and Acceptance.OANO=@OANO

		FETCH Next FROM Certificate_cursor into @CertificateNo, @OANO
	End  
	Close Certificate_cursor  
	Deallocate Certificate_cursor

	update Cover Set CertNum=@CertNum from Cover Where CNO=@CNO




	FETCH Next FROM Policy_Cursor into @PolicyNo
End  
Close Policy_Cursor  
Deallocate Policy_Cursor


--rollback tran
Commit tran