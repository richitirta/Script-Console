DROP function Get_ClaimSubrogation_Monitoring
GO
Create function Get_ClaimSubrogation_Monitoring(@ClaimNo as varchar(20), @Currency as varchar(10), @DocStatus as Int)  
RETURNS Table  
AS RETURN  
(  
	Select cast(0 as Bit) as ProcessFlag, C1.CType, C1.CStatus,
	C1.CNO, C1.TOC, TOC.Description as TOC_Desc, C1.ClaimNo, 
	C1.PolicyNo+Case when C1.CertificateNo<>'' Then '-'+C1.CertificateNo else '' end as PolicyNo, 
	C4.RegDate, C1.ADate, C1.RefNo, 
	dbo.get_ClaimObjectInfo(C1.CNO) as CInfo,
	C2.Currency, C2.Declared, C2.Estimate, C2.Indemnity,
	C2.Payment as PaymentID, 
	C2.Name as PaymentName, 
	C5.GrossAmount as SubrogationGrossAmount, 
	C5.Discount as SubrogationDiscount,
	C5.Amount as SubrogationAmount, C5.Name as SubrogationName,
	C6.Amount as ExpenseAmount, C6.Name as ExpenseName,
	coalesce(C7.Payment,0)+coalesce(C8.Payment,0) as Outstanding,
	S.Document, C3.Remarks, C3.UserID, C3.Date, C3.Time, C3.Last_Opr, C3.Last_Update, C3.Last_Time, C3.Actionby, C3.Actiondate, C3.ActionTime, C3.AcceptedBy, C3.AcceptedDate, C3.AcceptedTime, C3.ImageID
	From Claim C1
	Cross apply (
		Select CLLOSS.CNO, CLLOSS.Currency, CLLOSS.Payment, Max(Profile.Name) as Name, sum(CLLOSS.Declared*CLLOSS.Rate) as Declared, sum(CLLOSS.Estimate) as Estimate, sum(CLLOSS.Amount) as Indemnity
		from CLLOSS, Profile
		Where CLLOSS.CNO=C1.CNO and Profile.ID=CLLOSS.Payment
		Group By CLLOSS.CNO, CLLOSS.Currency, CLLOSS.Payment
	) C2
	Inner Join (
		Select S.Description as Document, S.ClaimCType, S.ClaimCStatus 
		from Docstat D, SysClass S 
		Where D.Purpose='SUBRO' and D.AllowedF=1 and S.CATEGORY='Claim' and S.Class=D.Class
		) S on (
			exists (Select Top 1 Document from CLNotify C3 Where C3.CNO=C1.CNO and C3.Type='OP' and C3.ID=C2.Payment and S.Document=C3.Document)
			or
			(charindex(C1.CType, S.ClaimCType)>0 and charindex(C1.CStatus, S.ClaimCStatus)>0)
		)
	Left Join CLNotify C3 on (C3.CNO=C1.CNO and C3.Type='OP' and C3.ID=C2.Payment and S.Document=C3.Document)
	Inner Join Claim C4 on (C4.CNO=C1.OCNO)
	Inner join TOC on (TOC.TOC=C1.TOC)
	Outer Apply (
		Select CLSUB.CNO, CLSUB.Currency, Max(Profile.ID+'-'+Profile.Name) as Name, sum(CLSUB.Amount) as Amount, sum(CLSub.GrossAmount)as GrossAmount, sum(CLSub.Discount) as Discount
		from CLSUB, Profile
		Where CLSUB.CNO=C2.CNO and CLSUB.Currency=C2.Currency and Profile.ID=CLSUB.ID
		Group By CLSUB.CNO, CLSUB.Currency
	) C5
	Outer Apply (
		Select CLCOST.CNO, CLCOST.Currency, Max(Profile.ID+'-'+Profile.Name) as Name, sum(CLCOST.Amount) as Amount
		from CLCOST, Profile
		Where CLCOST.CNO=C2.CNO and CLCOST.Currency=C2.Currency and Profile.ID=CLCOST.ID
		Group By CLCOST.CNO, CLCOST.Currency
	) C6

	Outer Apply (
		Select sum(Payment) as Payment
		from
		(
			Select Claim.CNO,
			Case When Max(coalesce(nVoucher.Voucher,''))='' then sum(ClaAss.Amount) else Max(case When nVoucher.DebtorF=1 Then (nVoucher.Payment_CC) else -(nVoucher.Payment_CC) end) End as Payment
			from Claim
			Inner Join ClaAss on (ClaAss.CNO=Claim.CNO)
			Left Join Admlink on (Admlink.AdmNo=ClaAss.AdmNo)
			Left Join nVoucher on (nVoucher.Voucher=Admlink.Voucher)
			Where Claim.OCNO=C1.OCNO and ClaAss.Type in ('DI','IC','IR') and ClaAss.Code in ('A','E') and ClaAss.Currency=C2.Currency 
			Group by Claim.CNO
		) V
	) C7
	Outer Apply (
		-- Exclude Subrogation Discount
		Select sum(Payment)*C5.GrossAmount/(C5.GrossAmount-C5.Discount) as Payment
		from
		(
			Select Claim.CNO,
			Case When Max(coalesce(nVoucher.Voucher,''))='' then sum(ClaAss.Amount) else Max(case When nVoucher.DebtorF=1 Then (nVoucher.Payment_CC) else -(nVoucher.Payment_CC) end) End as Payment
			from Claim
			Inner Join ClaAss on (ClaAss.CNO=Claim.CNO)
			Left Join Admlink on (Admlink.AdmNo=ClaAss.AdmNo)
			Left Join nVoucher on (nVoucher.Voucher=Admlink.Voucher)
			Where Claim.OCNO=C1.OCNO and ClaAss.Type in ('OP') and ClaAss.Code in ('R') and ClaAss.Currency=C2.Currency 
			Group by Claim.CNO
		) V
	) C8
	Where C1.RecoverableF=1
	and (C1.CStatus='A' or C1.pCStatus='A'or C1.CSeqNo>0)
	and C1.ClaimNo Like @ClaimNo+'%'
	and C2.Currency like @Currency+'%'
	and not exists (Select pCNO from Claim Where Claim.pCNO=C1.CNO)
	and (@DocStatus=0 or (@DocStatus=1 and coalesce(C3.ImageID,0)=0) or (@DocStatus=2 and coalesce(C3.ImageID,0)<>0))
)  
GO



 insert into PatchVersioning	
select '683 Update Script - Patch 2023 (61)',GETDATE()
go





Declare @PrevScript varchar(100)
Declare @CurrScript varchar(100)

Select @PrevScript=''
Select @CurrSCript='683 Update Script - Patch 2023 (61)'


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




go	



