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


Select A.ID, A.Type, A.Subject, A.Currency, A.ProcName, A.AmountPaid,
(
	Select 
	Voucher+',' 
	from @Payment P 
	Where P.ID=A.ID and P.Type=A.Type and P.Subject=A.Subject and P.Currency=A.Currency
	for xml path('')
) as SVoucher
from
(                                 
Select A.ID, A.Type, A.Subject, A.Currency, 
'AutoReceiptRequest_Process' as ProcName,
sum(A.AmountPaid) as AmountPaid
from  @Payment A
Group By A.ID, A.ID, A.Type, A.Subject, A.Currency
Having sum(round(AmountPaid,4))<0  
) A
Outer Apply (Select Top 1 ARBucket.Status, ARBucket.Remarks from ARBucket Where ARBucket.ProcName=A.ProcName and ARBucket.ID=A.ID and ARBucket.Type=A.Type and ARBucket.Subject=A.Subject and ARBucket.Currency=A.Currency Order by ARBucket.PID Desc) ARBucket  
Where coalesce(ARBucket.Status,'')<>'R'  
go




 insert into PatchVersioning	
select '732 Update Script - AutoGenerateAutoPayment_Process (By ID)',GETDATE()
go





Declare @PrevScript varchar(100)
Declare @CurrScript varchar(1004)

Select @PrevScript=''
Select @CurrSCript='732 Update Script - AutoGenerateAutoPayment_Process (By ID)'


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


