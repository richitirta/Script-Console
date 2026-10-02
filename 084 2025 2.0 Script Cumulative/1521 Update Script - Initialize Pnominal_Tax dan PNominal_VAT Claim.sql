
	Update Admlink set PNominal_Tax=A.PNOMINAL_TAX , PNominal_VAT=A.PNOMINAL_VAT
	from Admlink
	Cross Apply (
		Select 
		-coalesce(sum(PNOMINAL_VAT),0) as PNOMINAL_VAT,
		-coalesce(sum(PNOMINAL_TAX),0) as PNOMINAL_TAX
		FROM 
		(
		Select C1.CNO, C1.Payment as ID, C1.Currency, C2.RefNo, 
		(Case When C2.CAmount=0 then -1 else 1 end)*(CASE WHEN C1.VAR<=C1.DECLARED THEN (C1.VATAMOUNT) ELSE (C1.DECLARED/C1.VAR) * (C1.VATAMOUNT) END)*(100-coalesce(Coinsurance.MShare,0))/100*Case When Coalesce(ISource.Share,0)=0 Then 100 Else Coalesce(ISource.Share,0) End/100 as PNOMINAL_VAT, 
		(Case When C2.CAmount=0 then -1 else 1 end)*(CASE WHEN C1.VAR<=C1.DECLARED THEN (C1.TAXAMOUNT) ELSE (C1.DECLARED/C1.VAR) * (C1.TAXAMOUNT) END)*(100-coalesce(Coinsurance.MShare,0))/100*Case When Coalesce(ISource.Share,0)=0 Then 100 Else Coalesce(ISource.Share,0) End/100 as PNOMINAL_TAX		
		from Admlink A
		Inner Join ClaAss C2 on (C2.AdmNo=A.AdmNo and C2.Type in ('DI','IC') and C2.Code='A')
		Inner Join Claim C3 on (C3.CNO=C2.CNO)
		Inner Join CLLOSS C1 on (C1.CNO=(Case When C2.CAmount<>0 Then C3.CNO else C3.pCNO end) and C1.Currency=C2.Currency and C1.Payment=C2.ID)
		Inner Join NOCTAB ON (NOCTAB.NOC=C1.NOC)
		Inner Join Claim C4 on (C4.CNO=C1.CNO)
		Inner Join Acceptance on (Acceptance.ANO=C4.ANO)
		Inner Join Cover on (Cover.CNO=Acceptance.CNO)
		Left Join ISource on (ISource.CNO=Cover.CNO)
		Outer Apply (Select sum(Share) as MShare from Coinsurance Where Cover.ISType='L' and Coinsurance.CCollectionF=0 and Coinsurance.CNO=Acceptance.CNO) Coinsurance
		Where C1.Status='P' and C2.RefNo=(Case When C1.RefNO<>'' Then C1.RefNo else C4.RefNo end)
		and A.Admno=Admlink.AdmNo

		Union All
                
		Select Distinct C1.CNO, C1.ID, C1.Currency, C2.RefNo, 
		 -(Case When C2.CAmount=0 then -1 else 1 end)*C1.TaxAmount as PNOMINAL_VAT, 
		 -(Case When C2.CAmount=0 then -1 else 1 end)*C1.TaxAmount as PNOMINAL_TAX
		from CLDED C1, ClaAss C2, Claim C3, Claim C4, Admlink A
		Where C2.Type='DI' and C2.Code='E' and C2.AdmNo=A.AdmNO 
		and C3.CNO=C2.CNO and C1.CNO=(Case When C2.CAmount<>0 Then C3.CNO else C3.pCNO end) and C4.CNO=C1.CNO
		and C1.Currency=C2.Currency and C1.ID=C2.ID 
		and C2.RefNo=(Case When C1.RefNO<>'' Then C1.RefNo else C4.RefNo end)
		and A.Admno=Admlink.AdmNo
		) A
	) A
	Where Admlink.Type in ('DI','IC') and Admlink.Subject='Claim'
	and (abs(Admlink.PNominal_Tax-A.PNOMINAL_TAX)>0.1 or abs(Admlink.PNOMINAL_VAT-A.PNOMINAL_VAT)>0.1)
	
	Update Admlink set PNominal_Tax=A.PNOMINAL_TAX , PNominal_VAT=A.PNOMINAL_VAT
	from Admlink
	cross apply (
		Select 
		-coalesce(sum(PNOMINAL_VAT),0) as PNOMINAL_VAT,
		-coalesce(sum(PNOMINAL_TAX),0) as PNOMINAL_TAX
		FROM
		(
		Select Distinct C1.CNO, C1.ID, C1.CCTYPE, C1.Currency, C1.RefNo, 
		(Case when C2.CAmount=0 then -1 else 1 end)*(Case When C1.VAT<>0 Then 1 else 0 end)*(Case When C3.ISType='L' and C1.ContributionF=1 and C1.CCOLLECTIONF=0 Then (100-R.MShare)/100 Else 1 End)*C1.GrossAmount as PNOMINAL_VAT, 
		(Case when C2.CAmount=0 then -1 else 1 end)*(Case When C1.TAX<>0 Then 1 else 0 end)*(Case When C3.ISType='L' and C1.ContributionF=1 and C1.CCOLLECTIONF=0 Then (100-R.MShare)/100 Else 1 End)*C1.GrossAmount as PNOMINAL_TAX 
		from CLCOST C1, ClaAss C2, Claim C3, Claim C4, RArrHeader R, ADMLINK A
		Where C2.Type='OP' and C2.Code='L' and C2.AdmNo=A.AdmNO 
		and C3.CNO=C2.CNO and C1.CNO=(Case When C2.CAmount<>0 Then C3.CNO else C3.pCNO end) and C4.CNO=C1.CNO and R.ANO=C4.ANO
		and C1.Currency=C2.Currency and C1.ID=C2.ID 
		and 
			(C2.RefNo=(Case When C1.RefNO<>'' Then C1.RefNo else C4.RefNo end)
			or 
			(C2.RefNo=C1.CCType))
		and A.Admno=Admlink.AdmNo
		) A
	) A
	Where Admlink.Type='OP' and Admlink.Subject='Claim'
	and (abs(Admlink.PNominal_Tax-A.PNOMINAL_TAX)>0.1 or abs(Admlink.PNOMINAL_VAT-A.PNOMINAL_VAT)>0.1)

	GO


	
insert into PatchVersioning
select '1521 Update Script - Initialize Pnominal_Tax dan PNominal_VAT Claim.sql',GETDATE()
go	
  
Declare @PrevScript varchar(100)
Declare @CurrScript varchar(100)

Select @PrevScript=''
Select @CurrSCript='1521 Update Script - Initialize Pnominal_Tax dan PNominal_VAT Claim.sql'


Declare @ExecScript varchar(100)
Declare @ExecScriptStatus varchar(100)
Declare @Error varchar(200)

Select @Error=''

Begin 
       Select @ExecScript=Execscript,  @ExecScriptStatus=ExecScriptStatus from systab 
       if @PrevScript<>'' and @ExecSCript<>@PrevScript
              THROW 51000, 'Not the Next Sequence Script', 1;
       else 
              if @ExecScriptStatus<>'' and @ExecScriptStatus<>'DONE'
              THROW 51000, 'Pending Script Execution', 1;

       Update SysTab Set ExecScript=@CurrScript, ExecScriptStatus='PENDING'             
       
       BEGIN TRY            
			PRINT '--EXECUTE DONE--'
       END TRY  
       BEGIN CATCH  
       END CATCH;


       Update SysTab Set ExecScript=@CurrScript, ExecScriptStatus='DONE'         
End

GO 