DROP Procedure AutoGenerateAutoPayment_Process
GO
CREATE Procedure AutoGenerateAutoPayment_Process(@P_PDate as smalldatetime)                                            
as                                      
Select A.Bank, A.AccountNo, A.Type, A.Subject, A.Currency, 'AutoReceiptRequest_Process' as ProcName, sum(round(AmountPaid,4)) as AmountPaid,
(Select Top 1 Remarks from ARBucket Where ARBucket.RefDate<=@P_PDate and ARBucket.ProcName='AutoReceiptRequest_Process' and ARBucket.Bank=A.Bank and ARBucket.AccountNo=A.AccountNo and ARBucket.Type=A.Type and ARBucket.Subject=A.Subject and ARBucket.Currency=A.Currency and ARBucket.Status='P' Order by PID Desc) as Remarks
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
		Select Distinct V2.Voucher, V2.Date, V2.Currency, V2.DebtorF, Ad.A_PolicyNo, Ad.Bank, Ad.AccountNo, Ad.DocNo, Ad.RefNo, Ad.Type, Ad.Subject, V2.Nominal_CC-V2.Diff_CC as Nominal_CC, V2.Payment_CC, V2.Nominal_CC-V2.Diff_CC-V2.Payment_CC as Outstanding_CC
		from nVoucher V2 with (readcommitted) 
		Inner Join Admlink Ad on (Ad.Voucher=V2.Voucher and Ad.Subject='PREMIUM' and Ad.Type in ('BB','BO','BA','BC','FO'))
		Inner Join BRRule BR on (BR.AutoGenerateAutoPaymentF=1 and BR.TOC=Ad.Code and (BR.Branch='<All>' or BR.Branch=Ad.Branch) and (BR.BizmapID='<All>' or BR.BizMapID=Ad.BizMapID)) 
		and Not Exists (Select Top 1 SL.doc_no from SL_Request SL, Request R Where R.Status<>'C' and R.Voucher='' and R.Request=SL.Request and SL.doc_no=V2.Voucher)
	) A
	Cross Apply (Select dbo.Get_Payment_Percentage(A.A_PolicyNo,A.Subject,A.Type, A.DOCNO, A.Date, A.Currency) as PaymentPCT) P
	Where not exists (Select Top 1 PID from ARBucket Where ARBucket.ProcName='AutoReceiptRequest_Process' and ARBucket.Bank=A.Bank and ARBucket.AccountNo=A.AccountNo and ARBucket.Type=A.Type and ARBucket.Subject=A.Subject and ARBucket.Currency=A.Currency and ARBucket.Status='R')
) A
Group By A.Bank, A.AccountNo, A.Type, A.Subject, A.Currency
Having sum(round(AmountPaid,4))<0

go





 insert into PatchVersioning
select '322 Update Script - AutoGenerateAutoPayment_Process (By Bank and AccountNo)',GETDATE()
go


Declare @PrevScript varchar(100)
Declare @CurrScript varchar(100)

Select @PrevScript=''
Select @CurrSCript='322 Update Script - AutoGenerateAutoPayment_Process (By Bank and AccountNo)'


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




