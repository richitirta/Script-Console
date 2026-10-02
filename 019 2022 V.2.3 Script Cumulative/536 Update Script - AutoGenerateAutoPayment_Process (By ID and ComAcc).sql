DROP Function FN_Get_Payment_Percentage
GO
CREATE Function FN_Get_Payment_Percentage(@P_A_PolicyNo varchar(50), @P_Subject varchar(10), @P_Type varchar(10), @P_DocNO varchar(50), @P_Date smalldatetime, @P_Currency varchar(10))
RETURNS @Info TABLE (PCT Float, PDate smalldatetime)
AS    
BEGIN    
-- from Get_Payment_Percentage function (add Payment Date)

Declare @PCT as Float
Declare @PDate as Smalldatetime

Declare @Admlink Table(AdmNo int, DocNo varchar(50), Date SmallDatetime, Voucher varchar(50), Amount Float, LAmount Float)

if @P_Subject='Premium'
Begin
	insert into @Admlink(AdmNo, DocNo, Date, Voucher, Amount, LAmount)
	Select A.AdmNo, A.DocNo, A.Date, A.Voucher, A.Amount, A.LAmount
	from Admlink A
	Inner Join nVoucher V on (V.Voucher=A.Voucher)
	Where A.Date<=@P_Date and A.A_PolicyNo=@P_A_PolicyNo and A.Currency=@P_Currency and A.Subject='Premium' and A.Type in ('DI','IC','IR')
	and (substring(A.DocNo,1,50)+space(50-len(A.DocNo))+convert(varchar(50), A.Date,102))<=(substring(@P_DocNo,1,50)+space(50-len(@P_DocNo))+convert(varchar(50), @P_Date,102)) 
	and Round(V.Nominal_CC-V.Diff_CC,4)>0

	Select Top 1 @P_DocNo=A.DocNo, @P_Date=A.Date
	from @Admlink A
	Order by AdmNo Desc

	Select 
	@PDate=Max(V.PDate),
	@PCT=
	sum(case When V.DebtorF=1 Then (V.Payment_CC) Else -(V.Payment_CC) end)/sum(case When V.DebtorF=1 Then (V.Nominal_CC) Else -(V.Nominal_CC) end)*100

	from (

		   Select V.Voucher, 
		   Max(V.PDate) as Pdate,
		   cast(Max(Cast(V.DebtorF as Int)) as Bit) as DebtorF,
		   Case 
		   When @P_TYPE in ('PI','PL') Then Max((V.Payment_CC)*V.Rate)
		   When Max((V.Payment_CC)*V.Rate)<sum((case When V.DebtorF=1 Then 1 else -1 end)*(A.LAmount)*V.Rate) Then 0
		   Else Max((V.Payment_CC)*V.Rate)-sum((case When V.DebtorF=1 Then 1 else -1 end)*(A.LAmount)*V.Rate)
		   End as Payment_CC,

		   sum(
				  (case When V.DebtorF=1 Then 1 else -1 end)*
				  Case
				  When @P_Type in ('PI','PL') then (A.Amount)
				  Else (A.Amount-A.LAmount)
				  End*V.Rate
		   ) as Nominal_CC
		   from @Admlink A
		   Inner Join nVoucher V on (V.Voucher=A.Voucher)
			Where (substring(A.DocNo,1,50)+space(50-len(A.DocNo))+convert(varchar(50), A.Date,102))>
			coalesce(
			(
			Select Top 1 (substring(B.DocNo,1,50)+space(50-len(B.DocNo))+convert(varchar(50), B.Date,102)) 
			from Admlink B
			Inner Join @Admlink C on (C.DocNo=B.DocNo and C.Date=B.Date)
			Where B.Date<=@P_Date and B.A_PolicyNo=@P_A_PolicyNo and B.Currency=@P_Currency and B.Subject=@P_Subject and B.Type=@P_Type 
			and (substring(B.DocNo,1,50)+space(50-len(B.DocNo))+convert(varchar(50), B.Date,102))<(substring(@P_DocNo,1,50)+space(50-len(@P_DocNo))+convert(varchar(50), @P_Date,102))  
			order by B.AdmNo Desc
			),'')
		   Group By V.Voucher
	) V

	Having sum(case When V.DebtorF=1 Then (V.Nominal_CC) Else -(V.Nominal_CC) end)<>0
End
else
Begin
	Declare @LossDate as smalldatetime

	Select top 1 @LossDate=case when isdate(Extra_2)=1 then cast(extra_2 as smalldatetime) else Null end
	from Admlink Where Subject=@P_Subject and Type=@P_Type and DocNo=@P_DocNo and Currency=@P_Currency and Date=@P_Date

	if @LossDate is null
		set @LossDate=@P_Date 

	insert into @Admlink(AdmNo, DocNo, Date, Voucher, Amount, LAmount)
	Select A.AdmNo, A.DocNo, A.Date, A.Voucher, A.Amount*case when V.DebtorF=1 Then V.AmountDue/(V.Nominal_CC-V.Diff_CC) else -V.AmountDue/(V.Nominal_CC-V.Diff_CC) end as Amount, A.LAmount
	from Admlink A
	Inner Join VOUCHER_AMOUNTDUE(@LossDate) V on (V.Voucher=A.Voucher)
	Where A.Date<=@P_Date and A.A_PolicyNo=@P_A_PolicyNo and A.Currency=@P_Currency and A.Subject='Premium' and A.Type in ('DI','IC','IR')
	and (substring(A.A_PolicyNo,1,50)+space(50-len(A.A_PolicyNo))+convert(varchar(50), A.Date,102))<=(substring(@P_A_PolicyNo,1,50)+space(50-len(@P_A_PolicyNo))+convert(varchar(50), @P_Date,102)) 
	and Round(V.Nominal_CC-V.Diff_CC,4)>0

	Select 
	@PDate=Max(V.PDate),
	@PCT=
	sum(case When V.DebtorF=1 Then (V.Payment_CC) Else -(V.Payment_CC) end)/sum(case When V.DebtorF=1 Then (V.Nominal_CC) Else -(V.Nominal_CC) end)*100

	from (

		   Select V.Voucher, 
		   Max(V.PDate) as Pdate,
		   cast(Max(Cast(V.DebtorF as Int)) as Bit) as DebtorF,
		   Case 
		   When @P_TYPE in ('PI','PL') Then Max((V.Payment_CC)*V.Rate)
		   When Max((V.Payment_CC)*V.Rate)<sum((case When V.DebtorF=1 Then 1 else -1 end)*(A.LAmount)*V.Rate) Then 0
		   Else Max((V.Payment_CC)*V.Rate)-sum((case When V.DebtorF=1 Then 1 else -1 end)*(A.LAmount)*V.Rate)
		   End as Payment_CC,

		   sum(
				  (case When V.DebtorF=1 Then 1 else -1 end)*
				  Case
				  When @P_Type in ('PI','PL') then (A.Amount)
				  Else (A.Amount-A.LAmount)
				  End*V.Rate
		   ) as Nominal_CC
		   from @Admlink A
		   Inner Join nVoucher V on (V.Voucher=A.Voucher)
		   Group By V.Voucher
	) V

	Having sum(case When V.DebtorF=1 Then (V.Nominal_CC) Else -(V.Nominal_CC) end)<>0
End

if @PCT IS NULL 
       SELECT @PCT=100

if @PCT<0
       SELECT @PCT=0

if @PCT>100
       SELECT @PCT=100

if @PDate IS NULL
	Select @PDate=cast(convert(varchar(10), getdate(),1) as smalldatetime)

insert into @Info Select @PCT, @PDate 

Return
end

GO

DROP Procedure AutoGenerateAutoPayment_Process
GO
CREATE Procedure AutoGenerateAutoPayment_Process(@P_PDate as smalldatetime)                                              
as          

	Declare @Payment as Table(ID varchar(10), Type varchar(10), Subject varchar(10), Currency varchar(10), Voucher varchar(20), AmountPaid Float)

	insert into @Payment
	Select A.ID, A.Type, A.Subject, A.Currency, A.Voucher,   
	case   
	When (Case When Nominal_CC*PaymentPCT/100>Outstanding_CC Then Outstanding_CC else Nominal_CC*PaymentPCT/100 end)>Payment_CC then   
	(Case When Nominal_CC*PaymentPCT/100>Outstanding_CC Then Outstanding_CC else Nominal_CC*PaymentPCT/100 end)-Payment_CC   
	else   
	0   
	end  
	*(Case When A.DebtorF=1 Then 1 else -1 end) as AmountPaid  
	from  
	(  
	Select V.Voucher, V.Date, V.Currency, V.DebtorF, Ad.A_PolicyNo, Ad.ID, Ad.DocNo, Ad.RefNo, Ad.Type, Ad.Subject,   
	(case When V.DebtorF=1 Then Ad.Amount else -Ad.Amount end) as Nominal_CC,  
	(case When V.DebtorF=1 Then Ad.Amount else -Ad.Amount end)/(V.Nominal_CC-V.Diff_CC)*(V.Payment_CC) as Payment_CC,  
	(case When V.DebtorF=1 Then Ad.Amount else -Ad.Amount end)/(V.Nominal_CC-V.Diff_CC)*(V.Nominal_CC-V.Diff_CC-V.Payment_CC) as Outstanding_CC  
	from nVoucher V   
	Inner Join Admlink Ad on (Ad.Voucher=V.Voucher and Ad.Subject='PREMIUM' and Ad.Type in ('BA'))  
	Inner Join BRRule BR on (BR.AutoGenerateAutoPaymentF=1 and BR.TOC=Ad.Code and (BR.Branch='<All>' or BR.Branch=Ad.Branch) and (BR.BizmapID='<All>' or BR.BizMapID=Ad.BizMapID) and BR.FacOpt=0 and (BR.TOPRO='<All>'))   
	and (V.Date<=datediff(day,-15,@P_PDate) and Round(V.Nominal_CC-V.Diff_CC-V.Payment_CC-V.Payment_OC,4)<>0)  
	and Not Exists (Select Top 1 SL.doc_no from SL_Request SL, Request R Where R.Status<>'C' and R.Voucher='' and R.Request=SL.Request and SL.doc_no=V.Voucher)  
	) A  
	Cross Apply (Select P.PCT as PaymentPCT, P.PDate from FN_Get_Payment_Percentage(A.A_PolicyNo, A.Subject, A.Type, A.DOCNO, A.Date, A.Currency) P) P  
	Where A.ID<>'' 
	and P.PDate<=datediff(day,-15,@P_PDate)
	and 
	(
	case   
	When (Case When Nominal_CC*PaymentPCT/100>Outstanding_CC Then Outstanding_CC else Nominal_CC*PaymentPCT/100 end)>Payment_CC then   
	(Case When Nominal_CC*PaymentPCT/100>Outstanding_CC Then Outstanding_CC else Nominal_CC*PaymentPCT/100 end)-Payment_CC   
	else   
	0   
	end  
	)<>0

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

	Select A.ID, A.Type, A.Subject, A.ComAcc, A.ProcName, A.AmountPaid,
	(
		Select 
		Voucher+',' 
		from @Payment P 
		Cross Apply (
			Select top 1 ComAcc 
			from @ComAcc C 
			Inner Join SysTab on (1=1)
			Left Join ProAcc on (ProAcc.ID=A.ID and ProAcc.Currency=P.Currency and ProAcc.Currency=C.Currency and ProAcc.AccountNo<>'' and ProAcc.BankAccount<>'')
			Where ((coalesce(ProAcc.Currency,'')='' and C.Currency=SysTab.Currency) or (coalesce(ProAcc.Currency,'')<>'' and C.Currency=ProAcc.Currency))
		) ComAcc
		Where P.ID=A.ID and P.Type=A.Type and P.Subject=A.Subject and ComAcc.ComAcc=A.ComAcc
		for xml path('')
	) as SVoucher
	from
	(                                 
		Select A.ID, A.Type, A.Subject, ComAcc.ComAcc, 
		'AutoReceiptRequest_Process' as ProcName,
		sum(A.AmountPaid) as AmountPaid
		from  @Payment A
		Cross Apply (
			Select top 1 ComAcc 
			from @ComAcc C 
			Inner Join SysTab on (1=1)
			Left Join ProAcc on (ProAcc.ID=A.ID and ProAcc.Currency=A.Currency and ProAcc.Currency=C.Currency and ProAcc.AccountNo<>'' and ProAcc.BankAccount<>'')
			Where ((coalesce(ProAcc.Currency,'')='' and C.Currency=SysTab.Currency) or (coalesce(ProAcc.Currency,'')<>'' and C.Currency=ProAcc.Currency))
		) ComAcc
		Group By A.ID, A.ID, A.Type, A.Subject, ComAcc.ComAcc
		Having sum(round(AmountPaid,4))<0  
	) A
	Outer Apply (Select Top 1 ARBucket.Status, ARBucket.Remarks from ARBucket Where ARBucket.ProcName=A.ProcName and ARBucket.ID=A.ID and ARBucket.Type=A.Type and ARBucket.Subject=A.Subject and ARBucket.ComAcc=A.ComAcc Order by ARBucket.PID Desc) ARBucket  
	Where coalesce(ARBucket.Status,'')<>'R'  

go



 insert into PatchVersioning	
select '536 Update Script - AutoGenerateAutoPayment_Process (By ID and ComAcc)',GETDATE()
go





Declare @PrevScript varchar(100)
Declare @CurrScript varchar(100)

Select @PrevScript=''
Select @CurrSCript='536 Update Script - AutoGenerateAutoPayment_Process (By ID and ComAcc)'


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




