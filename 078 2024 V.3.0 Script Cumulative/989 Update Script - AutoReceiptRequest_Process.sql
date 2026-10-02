DROP Procedure AutoReceiptRequest_Process
GO
CREATE Procedure AutoReceiptRequest_Process(@P_PDate as smalldatetime,@P_PID as int=0)                                            
as                                      
Declare @ARBucket table(PID int, A_PolicyNo varchar(50), Voucher varchar(50), Bank varchar(50), AccountNo varchar(50), ID varchar(10))
insert into @ARBucket 
Select Top 1000 ARBucket.PID, 
coalesce(ARBucket.A_PolicyNo,'') as A_PolicyNo,
coalesce(ARBucket.Voucher,'') as Voucher,
coalesce(ARBucket.Bank,'') as Bank,
coalesce(ARBucket.AccountNo,'') as AccountNo,
coalesce(ARBucket.ID,'') as ID
from ARBucket
Where ARBucket.Status='R' and (PID = @P_PID or @P_PID = 0)     
and (ARBucket.ProcName='AutoReceiptRequest_Process')
and not exists (Select Top 1 objname from syslockedobject Where ObjName='ARBucket'+cast(ARBucket.PID as varchar(10)) and Status='L')

Declare @ARBucketAdmno table (PID int, AdmNo int)


--- for Receipt
insert into @ARBucketAdmno
Select A.PID, Admlink.AdmNo
from @ARBucket A
Inner Join ARBucket on (ARBucket.PID=A.PID)
Inner Join Admlink on (Admlink.Voucher=A.Voucher)
Inner Join nVoucher on (nVoucher.Voucher=Admlink.Voucher)     
Left Join VAccount V1 on (Admlink.RefType='VIRTUAL' and V1.Bank=ARBucket.Bank)
Left Join VAccountD V2 on (V2.VID=V1.VID and V2.AccountNo=ARBucket.AccountNo) 
Left Join CollectionH C on (C.CollNo=V2.CollNo and C.CollStatus='R')
Where A.Voucher<>''
and ARBucket.AmountPaid>0  -- Receipt Voucher
and Admlink.Date<=ARBucket.RefDate and Admlink.Date<=@P_PDate    
and (ARBucket.Currency='' or Admlink.Currency=ARBucket.Currency) 
and (ARBucket.Type='' or Admlink.Type=ARBucket.Type) 
and (ARBucket.Subject='' or Admlink.Subject=ARBucket.Subject) 
and
(
(Admlink.Subject='Premium' and (Admlink.Type in ('DI','IC','IR','IT','IX') or (ARBucket.NetPaidF=1 and Admlink.Type in ('BB','BA','BC','BO','BP','BD') and Admlink.ID=Admlink.Source)) )
or
(Admlink.Subject='CLaim' and Admlink.Type in ('OP') and (Admlink.Amount_3<>0 or Admlink.Amount_8<>0 or Admlink.Amount_10<>0))
)
and round(coalesce(nVoucher.Nominal_CC-nVoucher.Diff_CC-nVoucher.Payment_CC,0),2)>0
and not Exists (Select CollectionV.Voucher from CollectionV, CollectionH where CollectionH.CollNo<>coalesce(C.CollNo,'') and CollectionV.CollNo=CollectionH.CollNo and CollectionH.CollStatus<>'C' and CollectionV.Voucher=nVoucher.Voucher)              
and not Exists (Select SL.doc_no from SL_Request SL, Request R Where R.Status<>'C' and R.Voucher='' and R.Request=SL.Request and SL.doc_no=nVoucher.Voucher)                    
and not exists (Select Top 1 Ad.PID from @ARBucketAdmNo Ad Where Ad.PID=A.PID)

insert into @ARBucketAdmno
Select A.PID, Admlink.AdmNo
from @ARBucket A
Inner Join ARBucket on (ARBucket.PID=A.PID)
Inner Join Admlink on (Admlink.Bank=A.Bank and Admlink.AccountNo=A.AccountNo)
Inner Join nVoucher on (nVoucher.Voucher=Admlink.Voucher)     
Left Join VAccount V1 on (Admlink.RefType='VIRTUAL' and V1.Bank=ARBucket.Bank)
Left Join VAccountD V2 on (V2.VID=V1.VID and V2.AccountNo=ARBucket.AccountNo) 
Left Join CollectionH C on (C.CollNo=V2.CollNo and C.CollStatus='R')
Where A.Bank<>'' and A.AccountNo<>'' and A.Voucher=''
and ARBucket.AmountPaid>0  -- Receipt Voucher
and Admlink.Date<=ARBucket.RefDate and Admlink.Date<=@P_PDate    
and (ARBucket.Currency='' or Admlink.Currency=ARBucket.Currency) 
and (ARBucket.Type='' or Admlink.Type=ARBucket.Type) 
and (ARBucket.Subject='' or Admlink.Subject=ARBucket.Subject) 
and
(
(Admlink.Subject='Premium' and (Admlink.Type in ('DI','IC','IR','IT','IX') or (ARBucket.NetPaidF=1 and Admlink.Type in ('BB','BA','BC','BO','BP','BD') and Admlink.ID=Admlink.Source)) )
or
(Admlink.Subject='CLaim' and Admlink.Type in ('OP') and (Admlink.Amount_3<>0 or Admlink.Amount_8<>0 or Admlink.Amount_10<>0))
)
and round(coalesce(nVoucher.Nominal_CC-nVoucher.Diff_CC-nVoucher.Payment_CC,0),2)>0
and not Exists (Select CollectionV.Voucher from CollectionV, CollectionH where CollectionH.CollNo<>coalesce(C.CollNo,'') and CollectionV.CollNo=CollectionH.CollNo and CollectionH.CollStatus<>'C' and CollectionV.Voucher=nVoucher.Voucher)              
and not Exists (Select SL.doc_no from SL_Request SL, Request R Where R.Status<>'C' and R.Voucher='' and R.Request=SL.Request and SL.doc_no=nVoucher.Voucher)               
and not exists (Select Top 1 Ad.PID from @ARBucketAdmNo Ad Where Ad.PID=A.PID)


insert into @ARBucketAdmno
Select A.PID, Admlink.AdmNo
from @ARBucket A
Inner Join ARBucket on (ARBucket.PID=A.PID)
Inner Join Admlink on (Admlink.A_PolicyNo=A.A_PolicyNo)
Inner Join nVoucher on (nVoucher.Voucher=Admlink.Voucher)     
Left Join VAccount V1 on (Admlink.RefType='VIRTUAL' and V1.Bank=ARBucket.Bank)
Left Join VAccountD V2 on (V2.VID=V1.VID and V2.AccountNo=ARBucket.AccountNo) 
Left Join CollectionH C on (C.CollNo=V2.CollNo and C.CollStatus='R')
Where A.A_PolicyNo<>'' and not (A.Bank<>'' and A.AccountNo<>'') and A.Voucher=''
and ARBucket.AmountPaid>0  -- Receipt Voucher
and Admlink.Date<=ARBucket.RefDate and Admlink.Date<=@P_PDate    
and (ARBucket.Currency='' or Admlink.Currency=ARBucket.Currency) 
and (ARBucket.Type='' or Admlink.Type=ARBucket.Type) 
and (ARBucket.Subject='' or Admlink.Subject=ARBucket.Subject) 
and
(
(Admlink.Subject='Premium' and (Admlink.Type in ('DI','IC','IR','IT','IX') or (ARBucket.NetPaidF=1 and Admlink.Type in ('BB','BA','BC','BO','BP','BD') and Admlink.ID=Admlink.Source)) )
or
(Admlink.Subject='CLaim' and Admlink.Type in ('OP') and (Admlink.Amount_3<>0 or Admlink.Amount_8<>0 or Admlink.Amount_10<>0))
)
and round(coalesce(nVoucher.Nominal_CC-nVoucher.Diff_CC-nVoucher.Payment_CC,0),2)>0
and not Exists (Select CollectionV.Voucher from CollectionV, CollectionH where CollectionH.CollNo<>coalesce(C.CollNo,'') and CollectionV.CollNo=CollectionH.CollNo and CollectionH.CollStatus<>'C' and CollectionV.Voucher=nVoucher.Voucher)              
and not Exists (Select SL.doc_no from SL_Request SL, Request R Where R.Status<>'C' and R.Voucher='' and R.Request=SL.Request and SL.doc_no=nVoucher.Voucher)                    
and not exists (Select Top 1 Ad.PID from @ARBucketAdmNo Ad Where Ad.PID=A.PID)


--- for Payment
insert into @ARBucketAdmno
Select A.PID, Admlink.AdmNo
from @ARBucket A
Inner Join ARBucket on (ARBucket.PID=A.PID)
Inner Join Admlink on (Admlink.ID=A.ID and charindex(Admlink.Voucher,ARBucket.SVoucher)<>0)
Inner Join nVoucher on (nVoucher.Voucher=Admlink.Voucher)     
Left Join VAccount V1 on (Admlink.RefType='VIRTUAL' and V1.Bank=ARBucket.Bank)
Left Join VAccountD V2 on (V2.VID=V1.VID and V2.AccountNo=ARBucket.AccountNo) 
Left Join CollectionH C on (C.CollNo=V2.CollNo and C.CollStatus='R')
Where A.ID<>'' and ARBucket.SVoucher<>''
and ARBucket.AmountPaid<0  -- Payment Voucher
and Admlink.Date<=ARBucket.RefDate and Admlink.Date<=@P_PDate    
and (ARBucket.Currency='' or Admlink.Currency=ARBucket.Currency) 
and (ARBucket.Type='' or Admlink.Type=ARBucket.Type) 
and (ARBucket.Subject='' or Admlink.Subject=ARBucket.Subject) 
and
(
(Admlink.Subject='Claim' and Admlink.Type in ('DI','IC','IR','IT','IX'))
or
(Admlink.Subject='Claim' and Admlink.Type in ('OP') and Admlink.Amount_9<>0)
or
(Admlink.Subject='Premium' and Admlink.Type in ('BB','BA','BO','BC','BP','BD','FO','OP'))
)
and round(coalesce(nVoucher.Nominal_CC-nVoucher.Diff_CC-nVoucher.Payment_CC,0),2)>0
and not Exists (Select CollectionV.Voucher from CollectionV, CollectionH where CollectionH.CollNo<>coalesce(C.CollNo,'') and CollectionV.CollNo=CollectionH.CollNo and CollectionH.CollStatus<>'C' and CollectionV.Voucher=nVoucher.Voucher)              
and not Exists (Select SL.doc_no from SL_Request SL, Request R Where R.Status<>'C' and R.Voucher='' and R.Request=SL.Request and SL.doc_no=nVoucher.Voucher)                    
and not exists (Select Top 1 Ad.PID from @ARBucketAdmNo Ad Where Ad.PID=A.PID)

insert into @ARBucketAdmno
Select A.PID, Admlink.AdmNo
from @ARBucket A
Inner Join ARBucket on (ARBucket.PID=A.PID)
Inner Join Admlink on (Admlink.Voucher=A.Voucher)
Inner Join nVoucher on (nVoucher.Voucher=Admlink.Voucher)     
Left Join VAccount V1 on (Admlink.RefType='VIRTUAL' and V1.Bank=ARBucket.Bank)
Left Join VAccountD V2 on (V2.VID=V1.VID and V2.AccountNo=ARBucket.AccountNo) 
Left Join CollectionH C on (C.CollNo=V2.CollNo and C.CollStatus='R')
Where A.Voucher<>''
and ARBucket.AmountPaid<0  -- Payment Voucher
and Admlink.Date<=ARBucket.RefDate and Admlink.Date<=@P_PDate    
and (ARBucket.Currency='' or Admlink.Currency=ARBucket.Currency) 
and (ARBucket.Type='' or Admlink.Type=ARBucket.Type) 
and (ARBucket.Subject='' or Admlink.Subject=ARBucket.Subject) 
and
(
(Admlink.Subject='Claim' and Admlink.Type in ('DI','IC','IR','IT','IX'))
or
(Admlink.Subject='Claim' and Admlink.Type in ('OP') and Admlink.Amount_9<>0)
or
(Admlink.Subject='Premium' and Admlink.Type in ('BB','BA','BO','BC','BP','BD','FO','OP'))
)
and round(coalesce(nVoucher.Nominal_CC-nVoucher.Diff_CC-nVoucher.Payment_CC,0),2)>0
and not Exists (Select CollectionV.Voucher from CollectionV, CollectionH where CollectionH.CollNo<>coalesce(C.CollNo,'') and CollectionV.CollNo=CollectionH.CollNo and CollectionH.CollStatus<>'C' and CollectionV.Voucher=nVoucher.Voucher)              
and not Exists (Select SL.doc_no from SL_Request SL, Request R Where R.Status<>'C' and R.Voucher='' and R.Request=SL.Request and SL.doc_no=nVoucher.Voucher)                    
and not exists (Select Top 1 Ad.PID from @ARBucketAdmNo Ad Where Ad.PID=A.PID)

insert into @ARBucketAdmno
Select A.PID, Admlink.AdmNo
from @ARBucket A
Inner Join ARBucket on (ARBucket.PID=A.PID)
Inner Join Admlink on (Admlink.Bank=A.Bank and Admlink.AccountNo=A.AccountNo)
Inner Join nVoucher on (nVoucher.Voucher=Admlink.Voucher)     
Left Join VAccount V1 on (Admlink.RefType='VIRTUAL' and V1.Bank=ARBucket.Bank)
Left Join VAccountD V2 on (V2.VID=V1.VID and V2.AccountNo=ARBucket.AccountNo) 
Left Join CollectionH C on (C.CollNo=V2.CollNo and C.CollStatus='R')
Where A.Bank<>'' and A.AccountNo<>'' and ARBucket.SVoucher=''
and ARBucket.AmountPaid<0  -- Payment Voucher
and Admlink.Date<=ARBucket.RefDate and Admlink.Date<=@P_PDate    
and (ARBucket.Currency='' or Admlink.Currency=ARBucket.Currency) 
and (ARBucket.Type='' or Admlink.Type=ARBucket.Type) 
and (ARBucket.Subject='' or Admlink.Subject=ARBucket.Subject) 
and
(
(Admlink.Subject='Claim' and Admlink.Type in ('DI','IC','IR','IT','IX'))
or
(Admlink.Subject='Claim' and Admlink.Type in ('OP') and Admlink.Amount_9<>0)
or
(Admlink.Subject='Premium' and Admlink.Type in ('BB','BA','BO','BC','BP','BD','FO','OP'))
)
and round(coalesce(nVoucher.Nominal_CC-nVoucher.Diff_CC-nVoucher.Payment_CC,0),2)>0
and not Exists (Select CollectionV.Voucher from CollectionV, CollectionH where CollectionH.CollNo<>coalesce(C.CollNo,'') and CollectionV.CollNo=CollectionH.CollNo and CollectionH.CollStatus<>'C' and CollectionV.Voucher=nVoucher.Voucher)              
and not Exists (Select SL.doc_no from SL_Request SL, Request R Where R.Status<>'C' and R.Voucher='' and R.Request=SL.Request and SL.doc_no=nVoucher.Voucher)               
and not exists (Select Top 1 Ad.PID from @ARBucketAdmNo Ad Where Ad.PID=A.PID)

insert into @ARBucketAdmno
Select A.PID, Admlink.AdmNo
from @ARBucket A
Inner Join ARBucket on (ARBucket.PID=A.PID)
Inner Join Admlink on (Admlink.A_PolicyNo=A.A_PolicyNo)
Inner Join nVoucher on (nVoucher.Voucher=Admlink.Voucher)     
Left Join VAccount V1 on (Admlink.RefType='VIRTUAL' and V1.Bank=ARBucket.Bank)
Left Join VAccountD V2 on (V2.VID=V1.VID and V2.AccountNo=ARBucket.AccountNo) 
Left Join CollectionH C on (C.CollNo=V2.CollNo and C.CollStatus='R')
Where A.A_PolicyNo<>''
and ARBucket.AmountPaid<0  -- Payment Voucher
and Admlink.Date<=ARBucket.RefDate and Admlink.Date<=@P_PDate    
and (ARBucket.Currency='' or Admlink.Currency=ARBucket.Currency) 
and (ARBucket.Type='' or Admlink.Type=ARBucket.Type) 
and (ARBucket.Subject='' or Admlink.Subject=ARBucket.Subject) 
and
(
(Admlink.Subject='Claim' and Admlink.Type in ('DI','IC','IR','IT','IX'))
or
(Admlink.Subject='Claim' and Admlink.Type in ('OP') and Admlink.Amount_9<>0)
or
(Admlink.Subject='Premium' and Admlink.Type in ('BB','BA','BO','BC','BP','BD','FO','OP'))
)
and round(coalesce(nVoucher.Nominal_CC-nVoucher.Diff_CC-nVoucher.Payment_CC,0),2)>0
and not Exists (Select CollectionV.Voucher from CollectionV, CollectionH where CollectionH.CollNo<>coalesce(C.CollNo,'') and CollectionV.CollNo=CollectionH.CollNo and CollectionH.CollStatus<>'C' and CollectionV.Voucher=nVoucher.Voucher)              
and not Exists (Select SL.doc_no from SL_Request SL, Request R Where R.Status<>'C' and R.Voucher='' and R.Request=SL.Request and SL.doc_no=nVoucher.Voucher)               
and not exists (Select Top 1 Ad.PID from @ARBucketAdmNo Ad Where Ad.PID=A.PID)

Update ARBucket Set Status='C', Errmsg='No Transaction', PDate=@P_PDate 
from @ARBucket A 
Inner Join ARBucket on (ARBucket.PID=A.PID) 
Where not exists (Select Top 1 Ad.PID from @ARBucketAdmNo Ad Where Ad.PID=A.PID)

Select Distinct cast(Case When ARBucket.AmountPaid<0 Then 1 else 0 end as bit) as PaymentF, ARBucket.PID, ARBucket.Remarks, ARBucket.Last_Opr, ARBucket.ComAcc, ARBucket.Branch, ARBucket.CT, ARBucket.RefType, ARBucket.RefDate, ARBucket.RefNo, ARBucket.AmountPaid, ARBucket.Rate, ARBucket.SAccount, ARBucket.TAccount, ARBucket.Charges, ARBucket.EAccount, Admlink.ID, Admlink.DocNo, nVoucher.Voucher, nVoucher.DebtorF, nVoucher.Date, nVoucher.ProAcc, nVoucher.Currency, nVoucher.Branch as VBranch, 
Case When nVoucher.DebtorF=1 Then (nVoucher.Nominal_CC-nVoucher.Diff_CC-nVoucher.Payment_CC) else -(nVoucher.Nominal_CC-nVoucher.Diff_CC-nVoucher.Payment_CC) end as Outstanding, ARBucket.AutoPrintF
from @ARBucket A
Inner Join ARBucket on (ARBucket.PID=A.PID)
Inner Join @ARBucketAdmno Ad on (Ad.PID=A.PID)
Inner Join Admlink on (Admlink.AdmNo=Ad.AdmNo)
Inner Join nVoucher on (nVoucher.Voucher=Admlink.Voucher)     


GO



insert into PatchVersioning
select '989 Update Script - AutoReceiptRequest_Process',GETDATE()
go


Declare @PrevScript varchar(100)
Declare @CurrScript varchar(100)

Select @PrevScript=''
Select @CurrSCript='989 Update Script - AutoReceiptRequest_Process'


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