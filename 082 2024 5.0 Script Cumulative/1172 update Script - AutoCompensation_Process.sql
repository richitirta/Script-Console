DROP Procedure AutoCompensation_Process
GO
CREATE Procedure AutoCompensation_Process(@P_PDate as smalldatetime)                    
as                    
Select Distinct A2.Branch, A2.Type, A2.Subject, A2.A_PolicyNo, A2.ID, A2.Currency, A2.Remarks, A2.DocNo, A2.RefNo, A1.CT, A1.ProAcc, A1.Voucher, A1.Date, A1.DebtorF, A1.CreditorF, A1.Nominal_CC, A1.Diff_CC, A1.Payment_CC  
from nVoucher a1   
Inner Join Admlink A2 On (A2.Voucher=A1.Voucher)   
where 
A2.Date<=@P_PDate and A1.Payment_CC=0
and 
Exists (  
 Select A4.A_PolicyNo 
 from nVoucher Voucher
 Inner Join Admlink A4 On (A4.Voucher=Voucher.Voucher)
 Where A4.Date<=@P_PDate and Voucher.Payment_CC=0 
 and A4.Type=A2.Type and A4.Subject=A2.Subject and A4.A_PolicyNo=A2.A_PolicyNo and A4.ID=A2.ID and A4.Currency=A2.Currency and A4.Branch=A2.Branch and A4.Amount=-A2.Amount
 and Not Exists (Select Top 1 CollectionV.Voucher from CollectionV, CollectionH Where CollectionH.CollNo=CollectionV.COllNo and CollectionH.CollStatus<>'C' and CollectionV.CollNo<>Voucher.CollNo and CollectionV.Voucher=Voucher.Voucher)     
 and Not Exists (Select Top 1 SL.doc_no from SL_Request SL, Request R Where R.Status<>'C' and R.Voucher='' and R.Request=SL.Request and SL.doc_no=Voucher.Voucher)   
)  
and Not Exists (Select Top 1 CollectionV.Voucher from CollectionV, CollectionH Where CollectionH.CollNo=CollectionV.COllNo and CollectionH.CollStatus<>'C' and CollectionV.CollNo<>A1.CollNo and CollectionV.Voucher=A1.Voucher)     
and Not Exists (Select Top 1 SL.doc_no from SL_Request SL, Request R Where R.Status<>'C' and R.Voucher='' and R.Request=SL.Request and SL.doc_no=A1.Voucher)   
Order By A2.Branch, A2.A_PolicyNo, A2.Type, A2.Subject, A2.ID, A2.Currency, A2.RefNo 
go



  insert into PatchVersioning
select '1172 update Script - AutoCompensation_Process',GETDATE()
go	
  
Declare @PrevScript varchar(100)
Declare @CurrScript varchar(100)

Select @PrevScript=''
Select @CurrSCript='1172 update Script - AutoCompensation_Process'


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

