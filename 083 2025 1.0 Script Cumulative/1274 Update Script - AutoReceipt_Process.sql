DROP Procedure AutoReceipt_Process
GO
CREATE Procedure AutoReceipt_Process(@P_PDate as smalldatetime,@P_PID as int=0)                                            
as                                      
Declare @ARBucket table(PID int, A_PolicyNo varchar(50), Voucher varchar(50), sVoucher varchar(MAX), Bank varchar(50), AccountNo varchar(50), ID varchar(10))
insert into @ARBucket 
Select Top 1000 ARBucket.PID, 
coalesce(ARBucket.A_PolicyNo,'') as A_PolicyNo,
coalesce(ARBucket.Voucher,'') as Voucher,
coalesce(ARBucket.sVoucher,'') as sVoucher,
coalesce(ARBucket.Bank,'') as Bank,
coalesce(ARBucket.AccountNo,'') as AccountNo,
coalesce(ARBucket.ID,'') as ID
from ARBucket
Where ARBucket.Status='R' and (PID = @P_PID or @P_PID = 0)     
and (ARBucket.ProcName='' or ARBucket.ProcName='AutoReceipt_Process')
and not exists (Select Top 1 objname from syslockedobject Where ObjName='ARBucket'+cast(ARBucket.PID as varchar(10)) and Status='L')

Declare @ARBucketAdmno table (PID int, AdmNo int)


--- for Receipt
insert into @ARBucketAdmno
Select A.PID, Admlink.AdmNo
from @ARBucket A
Inner Join ARBucket on (ARBucket.PID=A.PID)
Inner Join Admlink on (Admlink.Voucher=A.Voucher)
Inner Join nVoucher on (nVoucher.Voucher=Admlink.Voucher)     
Left Join VAccount V1 on (Admlink.RefType='VIRTUAL' and V1.Bank=A.Bank)
Left Join VAccountD V2 on (V2.VID=V1.VID and V2.AccountNo=A.AccountNo) 
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
Inner Join Admlink on ((Admlink.Bank=A.Bank and Admlink.AccountNo=A.AccountNo) or (Admlink.Bank_Ext=A.Bank and Admlink.AccountNo_Ext=A.AccountNo))
Inner Join nVoucher on (nVoucher.Voucher=Admlink.Voucher)     
Left Join VAccount V1 on (Admlink.RefType='VIRTUAL' and V1.Bank=A.Bank)
Left Join VAccountD V2 on (V2.VID=V1.VID and V2.AccountNo=A.AccountNo) 
Left Join CollectionH C on (C.CollNo=V2.CollNo and C.CollStatus='R')
Where A.Bank<>'' and A.AccountNo<>'' and A.Voucher='' and A.sVoucher=''
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
Inner Join Admlink on (charindex(Admlink.Voucher,A.SVoucher)<>0)
Inner Join nVoucher on (nVoucher.Voucher=Admlink.Voucher)     
Left Join VAccount V1 on (Admlink.RefType='VIRTUAL' and V1.Bank=A.Bank)
Left Join VAccountD V2 on (V2.VID=V1.VID and V2.AccountNo=A.AccountNo) 
Left Join CollectionH C on (C.CollNo=V2.CollNo and C.CollStatus='R')
Where A.SVoucher<>''
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
Where A.A_PolicyNo<>'' and not (A.Bank<>'' and A.AccountNo<>'') and A.Voucher='' and A.SVoucher=''
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
Inner Join Admlink on (Admlink.ID=A.ID and charindex(Admlink.Voucher,A.SVoucher)<>0)
Inner Join nVoucher on (nVoucher.Voucher=Admlink.Voucher)     
Left Join VAccount V1 on (Admlink.RefType='VIRTUAL' and V1.Bank=ARBucket.Bank)
Left Join VAccountD V2 on (V2.VID=V1.VID and V2.AccountNo=ARBucket.AccountNo) 
Left Join CollectionH C on (C.CollNo=V2.CollNo and C.CollStatus='R')
Where A.ID<>'' and A.SVoucher<>''
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
Inner Join Admlink on ((Admlink.Bank=A.Bank and Admlink.AccountNo=A.AccountNo) or (Admlink.Bank_Ext=A.Bank and Admlink.AccountNo_Ext=A.AccountNo))
Inner Join nVoucher on (nVoucher.Voucher=Admlink.Voucher)     
Left Join VAccount V1 on (Admlink.RefType='VIRTUAL' and V1.Bank=ARBucket.Bank)
Left Join VAccountD V2 on (V2.VID=V1.VID and V2.AccountNo=ARBucket.AccountNo) 
Left Join CollectionH C on (C.CollNo=V2.CollNo and C.CollStatus='R')
Where A.Bank<>'' and A.AccountNo<>'' and A.SVoucher=''
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

Declare @ARBucketVoucher table (PID int, Voucher varchar(30), ID varchar(10), DocNo varchar(50), Nominal Float, Outstanding Float)
insert into @ARBucketVoucher
Select Ad.PID, nVoucher.Voucher, 
Max(Admlink.ID) as ID, 
Max(Admlink.DocNo) as DocNo,
Max(Case When nVoucher.DebtorF=1 Then (nVoucher.Nominal_CC-nVoucher.Diff_CC) else -(nVoucher.Nominal_CC-nVoucher.Diff_CC) end) as Nominal,
Max(Case When nVoucher.DebtorF=1 Then (nVoucher.Nominal_CC-nVoucher.Diff_CC-nVoucher.Payment_CC-nVoucher.Payment_OC) else -(nVoucher.Nominal_CC-nVoucher.Diff_CC-nVoucher.Payment_CC-nVoucher.Payment_OC) end) as Outstanding
from @ARBucketAdmno Ad
Inner Join Admlink on (Admlink.AdmNo=Ad.AdmNo)
Inner Join nVoucher on (nVoucher.Voucher=Admlink.Voucher)     
Group By Ad.PID, nVoucher.Voucher


Select 
cast(Case When ARBucket.AmountPaid<0 Then 1 else 0 end as bit) as PaymentF, 
ARBucket.PID, ARBucket.Remarks, ARBucket.Last_Opr, ARBucket.VType, ARBucket.ComAcc, ARBucket.Branch, case when coalesce(ARBucket.CT,'')='' then nVoucher.CT else coalesce(ARBucket.CT,'') end as CT, ARBucket.RefType, ARBucket.RefDate, ARBucket.RefNo, 
ARBucket.Rate, 
ARBucket.SAccount, ARBucket.TAccount, 
ARBucket.AmountPaid,
ARBucket.TaxDeduction, 

Case
When coalesce(ARBucket.Charges,0)=0 and ARBucket.RefType='CREDIT CARD' and coalesce(ARBucket.CCPayType,'') in ('SP','IP') then	
	Case 
	When ARBucket.CCPayType='SP' then 
		-- FullPaid
		ARBucket.AmountPaid*1/(1-(SysTab.CCSPFee+SysTab.CCTAX)/100)*SysTab.CCSPFee/100
	Else
		-- PartialPaid
		ARBucket.AmountPaid*1/(1-(SysTab.CCIPFee+SysTab.CCTAX)/100)*SysTab.CCIPFee/100
	END
else
	coalesce(ARBucket.Charges,0)
End as Charges,

Case
When coalesce(ARBucket.TaxCharges,0)=0 and ARBucket.RefType='CREDIT CARD' and coalesce(ARBucket.CCPayType,'') in ('SP','IP') then	
	Case 
	When ARBucket.CCPayType='SP' then 
		-- FullPaid
		ARBucket.AmountPaid*1/(1-(SysTab.CCSPFee+SysTab.CCTAX)/100)*SysTab.CCTAX/100 
	Else
		-- PartialPaid
		ARBucket.AmountPaid*1/(1-(SysTab.CCIPFee+SysTab.CCTAX)/100)*SysTab.CCTAX/100 
	END
else
	coalesce(ARBucket.TaxCharges,'')
End as TaxCharges,

Case
When coalesce(ARBucket.EAccount,'')='' and ARBucket.RefType='CREDIT CARD' and coalesce(ARBucket.CCPayType,'') in ('SP','IP') then
	SysTab.CCCOLAccount 
else
	coalesce(ARBucket.EAccount,'')
End as EAccount,

Case
When coalesce(ARBucket.ETaxAccount,'')='' and ARBucket.RefType='CREDIT CARD' and coalesce(ARBucket.CCPayType,'') in ('SP','IP') then
	SysTab.CCTAXAccount  
else
	coalesce(ARBucket.ETaxAccount,'')
End as ETaxAccount,

Ad.ID, Ad.DocNo, nVoucher.Voucher, nVoucher.DebtorF, nVoucher.Date, nVoucher.ProAcc, nVoucher.Currency, nVoucher.Branch as VBranch, 
Ad.Outstanding as Outstanding, 
ARBucket.AutoPrintF
from @ARBucket A
Inner Join ARBucket on (ARBucket.PID=A.PID)
Inner Join @ARBucketVoucher Ad on (Ad.PID=A.PID)
Inner Join nVoucher on (nVoucher.Voucher=Ad.Voucher)     
Inner Join SysTab on (1=1)




GO




  
  insert into PatchVersioning
select '1274 Update Script - AutoReceipt_Process',GETDATE()
go	
  
Declare @PrevScript varchar(100)
Declare @CurrScript varchar(100)

Select @PrevScript=''
Select @CurrSCript='1274 Update Script - AutoReceipt_Process'


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