
DROP Procedure AutoGenerateAutoPayment_Process
GO
CREATE Procedure AutoGenerateAutoPayment_Process(@P_PDate as smalldatetime)                                            
as                    
Select A.*, ARBucket.Remarks
from
(                  
	Select A_PolicyNo, A.Voucher, A.RefNo, A.Type, A.Subject, A.Currency, 'AutoReceiptRequest_Process' as ProcName, sum(round(AmountPaid,4)) as AmountPaid
	from
	(
		Select A.*, 
		(Case When Nominal_CC*PaymentPCT/100-Payment_CC>0 Then Nominal_CC*PaymentPCT/100-Payment_CC else 0 end)*(Case When A.DebtorF=1 Then 1 else -1 end) as AmountPaid
		from
		(
			Select Top 500 V.Voucher, V.Date, V.Currency, V.DebtorF, Ad.A_PolicyNo, Ad.Bank, Ad.AccountNo, Ad.DocNo, Ad.RefNo, Ad.Type, Ad.Subject, 
			(case When V.DebtorF=1 Then Ad.Amount else -Ad.Amount end) as Nominal_CC,
			(case When V.DebtorF=1 Then Ad.Amount else -Ad.Amount end)/(V.Nominal_CC-V.Diff_CC)*(V.Payment_CC+V.Payment_OC) as Payment_CC,
			(case When V.DebtorF=1 Then Ad.Amount else -Ad.Amount end)/(V.Nominal_CC-V.Diff_CC)*(V.Nominal_CC-V.Diff_CC-V.Payment_CC-V.Payment_OC) as Outstanding_CC
			from nVoucher V 
			Inner Join Admlink Ad on (Ad.Voucher=V.Voucher and Ad.Subject='PREMIUM' and Ad.Type in ('BA'))
			Inner Join BRRule BR on (BR.AutoGenerateAutoPaymentF=1 and BR.TOC=Ad.Code and (BR.Branch='<All>' or BR.Branch=Ad.Branch) and (BR.BizmapID='<All>' or BR.BizMapID=Ad.BizMapID) and BR.FacOpt=0 and (BR.TOPRO='<All>')) 
			and (V.Date<=@P_PDATE and Round(V.Nominal_CC-V.Diff_CC-V.Payment_CC-V.Payment_OC,4)<>0)
			and Not Exists (Select Top 1 SL.doc_no from SL_Request SL, Request R Where R.Status<>'C' and R.Voucher='' and R.Request=SL.Request and SL.doc_no=V.Voucher)
		) A
		Cross Apply (Select dbo.Get_Payment_Percentage(A.A_PolicyNo, A.Subject, A.Type, A.DOCNO, A.Date, A.Currency, A.DebtorF) as PaymentPCT) P
	) A
	Group By A_PolicyNo, A.Voucher, A.RefNo, A.Type, A.Subject, A.Currency
	Having sum(round(AmountPaid,4))<0
) A
Cross Apply (Select Top 1 ARBucket.Status, ARBucket.Remarks from ARBucket Where ARBucket.A_PolicyNo=A.A_PolicyNo and ARBucket.RefNo=A.RefNo and ARBucket.Type=A.Type and ARBucket.Subject=A.Subject Order by ARBucket.PID Desc) ARBucket
Where coalesce(ARBucket.Status,'')<>'R'

GO


insert into PatchVersioning
select '1480 Update Script - AutoGenerateAutoPayment_Process.sql',GETDATE()
go	
  
Declare @PrevScript varchar(100)
Declare @CurrScript varchar(100)

Select @PrevScript=''
Select @CurrSCript='1480 Update Script - AutoGenerateAutoPayment_Process.sql'


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