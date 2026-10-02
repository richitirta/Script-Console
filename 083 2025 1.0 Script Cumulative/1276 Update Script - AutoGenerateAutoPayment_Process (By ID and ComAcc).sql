DROP Procedure AutoGenerateAutoPayment_Process
GO
CREATE Procedure AutoGenerateAutoPayment_Process(@P_PDate as smalldatetime)                                              
as          

	Declare @Payment as Table(ID varchar(10), Type varchar(10), Subject varchar(10), Currency varchar(10), Voucher varchar(20), AmountPaid Float)

	insert into @Payment
	Select A.ID, A.Type, A.Subject, A.Currency, A.Voucher,   
	(Case When Nominal_CC*PaymentPCT/100-Payment_CC>0 Then Nominal_CC*PaymentPCT/100-Payment_CC else 0 end)*(Case When A.DebtorF=1 Then 1 else -1 end) as AmountPaid  
	from  
	(  
	Select V.Voucher, V.Date, V.Currency, V.DebtorF, Ad.A_PolicyNo, Ad.ID, Ad.DocNo, Ad.RefNo, Ad.Type, Ad.Subject,   
	(case When V.DebtorF=1 Then Ad.Amount else -Ad.Amount end) as Nominal_CC,  
	(case When V.DebtorF=1 Then Ad.Amount else -Ad.Amount end)/(V.Nominal_CC-V.Diff_CC)*(V.Payment_CC+V.Payment_OC) as Payment_CC,  
	(case When V.DebtorF=1 Then Ad.Amount else -Ad.Amount end)/(V.Nominal_CC-V.Diff_CC)*(V.Nominal_CC-V.Diff_CC-V.Payment_CC-V.Payment_OC) as Outstanding_CC  
	from nVoucher V   
	Inner Join Admlink Ad on (Ad.Voucher=V.Voucher and Ad.Subject='PREMIUM' and Ad.Type in ('BA'))  
	Inner Join BRRule BR on (BR.AutoGenerateAutoPaymentF=1 and BR.TOC=Ad.Code and (BR.Branch='<All>' or BR.Branch=Ad.Branch) and (BR.BizmapID='<All>' or BR.BizMapID=Ad.BizMapID) and BR.FacOpt=0 and (BR.TOPRO='<All>'))   
	and (V.Date<=datediff(day,-15,@P_PDate) and Round(V.Nominal_CC-V.Diff_CC-V.Payment_CC-V.Payment_OC,4)<>0)  
	and Not Exists (Select Top 1 SL.doc_no from SL_Request SL, Request R Where R.Status<>'C' and R.Voucher='' and R.Request=SL.Request and SL.doc_no=V.Voucher)  
	) A  
	Cross Apply (Select P.PCT as PaymentPCT, P.PDate from FN_Get_Payment_Percentage(A.A_PolicyNo, A.Subject, A.Type, A.DOCNO, A.Date, A.Currency, A.DebtorF) P) P  
	Where A.ID<>'' 
	and P.PDate<=datediff(day,-15,@P_PDate)
	and (Case When Nominal_CC*PaymentPCT/100-Payment_CC>0 Then Nominal_CC*PaymentPCT/100-Payment_CC else 0 end)>0

	Declare @ComAcc as Table (ComAcc Varchar(30), Currency varchar(10))

	Declare @UserID as varchar(50)
	Declare @Branch as varchar(10)

	Select @UserID=S1.UserID, @Branch=S2.Branch 
	from sysprocess s1, sysuser s2 Where s1.ProcName='AutoGenerateAutoPayment_Process' and s2.id=S1.UserID

	-- Get Company Account by User who executing the process 
	insert into @ComAcc
	Select Comacc.Comacc, Comacc.Currency 
	from FN_UserComAcc(@UserID, @Branch) ComAcc
	Where Transferf=1 

	Select A.ID, A.Type, A.Subject, A.Currency, A.ComAcc, A.ProcName, 
	A.AmountPaid*A.Rate as AmountPaid,
	A.Rate,
	(
		Select 
		Voucher+',' 
		from @Payment P 
		Cross Apply (
			Select top 1 C.ComAcc, C.Currency
			from @ComAcc C 
			Inner Join SysTab on (1=1)
			Left Join ProAcc on (ProAcc.ID=A.ID and ProAcc.Currency=P.Currency and ProAcc.Currency=C.Currency and ProAcc.AccountNo<>'' and ProAcc.BankAccount<>'')
			Where ((coalesce(ProAcc.Currency,'')='' and C.Currency=SysTab.Currency) or (coalesce(ProAcc.Currency,'')<>'' and C.Currency=ProAcc.Currency))
			Order By Case When (coalesce(ProAcc.Currency,'')<>'' and C.Currency=ProAcc.Currency) Then 0 else 1 end
		) ComAcc
		Where P.ID=A.ID and P.Type=A.Type and P.Subject=A.Subject and ComAcc.ComAcc=A.ComAcc and P.Currency=A.Currency and ComAcc.Currency=A.ComAcc_Currency 
		for xml path('')
	) as SVoucher
	from
	(                                 
		Select A.ID, A.Type, A.Subject, A.Currency, ComAcc.ComAcc, ComAcc.Currency as ComAcc_Currency,
		'AutoReceiptRequest_Process' as ProcName,
		dbo.Get_exchange(@P_PDate,A.Currency)/dbo.Get_exchange(@P_PDate,ComAcc.Currency) as Rate,
		sum(A.AmountPaid) as AmountPaid
		from  @Payment A
		Cross Apply (
			Select top 1 C.ComAcc, C.Currency
			from @ComAcc C 
			Inner Join SysTab on (1=1)
			Left Join ProAcc on (ProAcc.ID=A.ID and ProAcc.Currency=A.Currency and ProAcc.Currency=C.Currency and ProAcc.AccountNo<>'' and ProAcc.BankAccount<>'')
			Where ((coalesce(ProAcc.Currency,'')='' and C.Currency=SysTab.Currency) or (coalesce(ProAcc.Currency,'')<>'' and C.Currency=ProAcc.Currency))
			Order By Case When (coalesce(ProAcc.Currency,'')<>'' and C.Currency=ProAcc.Currency) Then 0 else 1 end
		) ComAcc
		Group By A.ID, A.ID, A.Type, A.Subject, A.Currency, ComAcc.ComAcc, ComAcc.Currency
		Having sum(round(AmountPaid,4))<0  
	) A
	Outer Apply (Select Top 1 ARBucket.Status, ARBucket.Remarks from ARBucket Where ARBucket.ProcName=A.ProcName and ARBucket.ID=A.ID and ARBucket.Type=A.Type and ARBucket.Subject=A.Subject and ARBucket.ComAcc=A.ComAcc Order by ARBucket.PID Desc) ARBucket  
	Where coalesce(ARBucket.Status,'')<>'R'  

	go

	
  insert into PatchVersioning
select '1276 Update Script - AutoGenerateAutoPayment_Process (By ID and ComAcc)',GETDATE()
go	
  
Declare @PrevScript varchar(100)
Declare @CurrScript varchar(100)

Select @PrevScript=''
Select @CurrSCript='1276 Update Script - AutoGenerateAutoPayment_Process (By ID and ComAcc)'


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