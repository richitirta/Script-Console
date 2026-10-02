
	Update Admlink set PNominal_Tax=
	            coalesce((
				Select -sum(PNOMINAL_TAX) as PNOMINAL_TAX
                FROM 
                (
                Select Distinct C1.CNO, C1.INO, C1.NOC as TypeCode, C1.Payment as ID, C1.Currency, C1.RefNo, (Case When C2.CAmount=0 then -1 else 1 end)*C1.VATAmount as PNOMINAL_VAT, (Case When C2.CAmount=0 then -1 else 1 end)*C1.TaxAmount as PNOMINAL_TAX				
                from CLLOSS C1, ClaAss C2, Claim C3, Claim C4, ADMLINK A
                Where C2.Type='DI' and C2.Code='A' and C2.AdmNo=A.AdmNO 
                and C3.CNO=C2.CNO and C1.CNO=(Case When C2.CAmount<>0 Then C3.CNO else C3.pCNO end) and C4.CNO=C1.CNO
                and C1.Currency=C2.Currency and C1.Payment=C2.ID 
                and C2.RefNo=(Case When C1.RefNO<>'' Then C1.RefNo else C4.RefNo end)
                and A.Admno=Admlink.AdmNo
                
                Union All
                
                Select Distinct C1.CNO, 0 as INO, C1.DCode as TypeCode, C1.ID, C1.Currency, '' as RefNo, -(Case When C2.CAmount=0 then -1 else 1 end)*C1.VATAmount as PNOMINAL_VAT, -(Case When C2.CAmount=0 then -1 else 1 end)*C1.TaxAmount as PNOMINAL_TAX				
                from CLDED C1, ClaAss C2, Claim C3, Claim C4, Admlink A
                Where C2.Type='DI' and C2.Code='E' and C2.AdmNo=A.AdmNO 
                and C3.CNO=C2.CNO and C1.CNO=(Case When C2.CAmount<>0 Then C3.CNO else C3.pCNO end) and C4.CNO=C1.CNO
                and C1.Currency=C2.Currency and C1.ID=C2.ID 
                and C2.RefNo=(Case When C1.RefNO<>'' Then C1.RefNo else C4.RefNo end)
                and A.Admno=Admlink.AdmNo
                ) C
				),0)
	from Admlink
	Where Admlink.Type='DI' and Admlink.Subject='Claim'
	and Admlink.PNominal_Tax=0
	and Admlink.Date >= '01/01/2020'


	
	Update Admlink set PNominal_Tax=
	            coalesce((
				Select -sum(PNOMINAL_TAX) as PNOMINAL_TAX
                FROM
                (
                Select Distinct C1.CNO, C1.ID, C1.CCTYPE, C1.Currency, C1.RefNo, 
                (Case when C2.CAmount=0 then -1 else 1 end)*(Case When C3.ISType='L' and C1.ContributionF=1 and C1.CCOLLECTIONF=0 Then (100-R.MShare)/100 Else 1 End)*C1.GrossAmount as PNOMINAL_VAT, 
                (Case when C2.CAmount=0 then -1 else 1 end)*(Case When C3.ISType='L' and C1.ContributionF=1 and C1.CCOLLECTIONF=0 Then (100-R.MShare)/100 Else 1 End)*C1.GrossAmount as PNOMINAL_TAX 
                from CLCOST C1, ClaAss C2, Claim C3, Claim C4, RArrHeader R, ADMLINK A
                Where C2.Type='OP' and C2.Code='L' and C2.AdmNo=A.AdmNO 
                and C3.CNO=C2.CNO and C1.CNO=(Case When C2.CAmount<>0 Then C3.CNO else C3.pCNO end) and C4.CNO=C1.CNO and R.ANO=C4.ANO
                and C1.Currency=C2.Currency and C1.ID=C2.ID 
				and 
					(C2.RefNo=(Case When C1.RefNO<>'' Then C1.RefNo else C4.RefNo end)
					or 
					(C2.RefNo=C1.CCType))
                and A.Admno=Admlink.AdmNo
                ) C
				),0)
	from Admlink
	Where Admlink.Type='OP' and Admlink.Subject='Claim'
	and Admlink.PNominal_Tax=0
	and Admlink.Date >= '01/01/2020'