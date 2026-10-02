DROP PROCEDURE QPREMIUMAMOUNT 
GO
CREATE PROCEDURE QPREMIUMAMOUNT (@P_ANO AS INTEGER,@P_PDate as smalldatetime)                        
  
AS                       
  
Declare @P_APolicyNo as varchar(50)          
Declare @P_WPC as int    
Declare @P_BillDate as smalldatetime    
Declare @P_BackdatedF as bit  
Declare @P_Grace as Int  
  
Select   
@P_APolicyNo=
Case 
When A.LANO<>-1 then
	Case
	When A.ANO<>A.LANO and ((C.OpenFlag=1 and A.BulkF=0) or (C.OpenFlag=0 and A.RefNo<>mA.RefNo)) then
		A.PolicyNo+'-'+A.CertificateNo
	else
		A.PolicyNo
	end
Else
	A.PolicyNo
end,
@P_WPC=coalesce(APayor.WPC, coalesce(MPayor.WPC, Payor.WPC)),    
@P_Grace=coalesce(APayor.Grace, coalesce(MPayor.Grace, Payor.Grace)),  
@P_BillDate= dateadd(day,coalesce(APayor.Grace, coalesce(MPayor.Grace, Payor.Grace)),  
Case     
When A.AType='A' Then A.ADate     
else     
 Case When C.OpenFlag=0 Then     
  Case When SysTab.DueByEffectiveF=0 Then coalesce(mA.ADate,A.ADate) else coalesce(mA.PDate,A.PDate) end    
 else    
  Case When SysTab.DueByEffectiveF=0 Then A.ADate else A.PDate end    
 end    
end)  
,    
@P_BackdatedF=A.BackDatedF  
from Acceptance A
Inner Join Cover C on (C.CNO=A.CNO)  
Left Join Acceptance mA on (mA.ANO=mA.LANO and mA.RegNo=A.RegNo)    
Left Join APayor on (APayor.ANO=A.ANO)    
Left Join Payor on (Payor.ANO=A.ANO)  
Left Join Payor MPayor on (MPayor.ANO=mA.ANO)  
Inner Join SysTab on (1=1)    
Where A.ANO=@P_ANO and A.PolicyNo<>''
  
Select             
@P_BackdatedF as BackdatedF,  
sum(Voucher.PremiumAmount) as PremiumAmount,            
sum(Voucher.PremiumDue) as PremiumDue,     
Min(Voucher.DueDate) as DueDate,        
coalesce(datediff(day,Min(Voucher.DueDate),@P_PDate),0) as Lapse,  
sum(Voucher.PremiumPaid) as PremiumPaid,            
sum(Voucher.PremiumOutstanding) as PremiumOutstanding,            
@P_WPC as WPC,    
@P_Grace as Grace,  
@P_BillDate as BillDate,    
Min(Voucher.PDate) as Date,
Max(Voucher.LastDueDate) as LastDueDate,
Max(Voucher.LastPayDate) as LastPayDate
From            
(             
 SELECT                        
 nVoucher.Voucher,    
 CASE WHEN nVoucher.DEBTORF=1 THEN (Case When Voucher_Due.Voucher is null then nVoucher.Nominal_CC-nVoucher.Diff_CC else Voucher_Due.AmountDue end) ELSE -(Case When Voucher_Due.Voucher is null then nVoucher.Nominal_CC-nVoucher.Diff_CC else Voucher_Due.AmountDue end) END*nVoucher.RATE as PremiumAmount,                         
 CASE WHEN nVoucher.DEBTORF=1 THEN (CASE WHEN coalesce(Voucher_Due.AmountDue,0)-(nVoucher.Payment_CC+nVoucher.Payment_OC)<0 Then 0 Else coalesce(Voucher_Due.AmountDue,0)-(nVoucher.Payment_CC+nVoucher.Payment_OC) End) ELSE -(CASE WHEN coalesce(Voucher_Due.AmountDue,0)-(nVoucher.Payment_CC+nVoucher.Payment_OC)<0 Then 0 Else coalesce(Voucher_Due.AmountDue,0)-(nVoucher.Payment_CC+nVoucher.Payment_OC) End) END*nVoucher.RATE as PremiumDue,                        
 Case When Round((nVoucher.Payment_CC+nVoucher.Payment_OC),2)<round((Case When Voucher_Due.Voucher is null then nVoucher.Nominal_CC-nVoucher.Diff_CC else Voucher_Due.AmountDue end),2) Then isnull(Voucher_Due.DueDate, dateadd(day, @P_WPC, nVoucher.DueDate)) else Null end AS DueDate,                  
 Case When nVoucher.INSTALLMENT<>0 then Voucher_Due.LastDueDate else dateadd(day, @P_WPC, nVoucher.DueDate) End as LastDueDate,
 CASE WHEN nVoucher.DEBTORF=1 THEN nVoucher.Nominal_CC-nVoucher.Diff_CC-(nVoucher.Payment_CC+nVoucher.Payment_OC) ELSE -(nVoucher.Nominal_CC-nVoucher.Diff_CC-(nVoucher.Payment_CC+nVoucher.Payment_OC)) END*nVoucher.RATE as PremiumOutstanding,     
 CASE WHEN nVoucher.DEBTORF=1 THEN (nVoucher.Payment_CC+nVoucher.Payment_OC) ELSE -(nVoucher.Payment_CC+nVoucher.Payment_OC) END*nVoucher.RATE as PremiumPaid,                        
 Payment.PDate, 
 Payment.LastPayDate
 FROM (
	Select Distinct Admlink.Voucher
	from Admlink
	Where Admlink.A_policyNo=@P_APolicyNo and Admlink.Subject='Premium' and Admlink.Type in ('DI','IC','IR','IT','IX') 
 ) Admlink
 Inner Join nVoucher on (nVoucher.Voucher=Admlink.Voucher)     
 Left Join Voucher_AmountWPCDue(@P_PDate) Voucher_Due on (Voucher_Due.Voucher=nVoucher.Voucher)     
 Outer Apply (  
  Select 
  Max(coalesce(pVoucher.RefDate, coalesce(OVoucher.RefDate, Voucher.RefDate))) as PDate,
  Max(Case When coalesce(pVoucher.RefDate, coalesce(OVoucher.RefDate, Voucher.RefDate)) <=@P_PDate then coalesce(pVoucher.RefDate, coalesce(OVoucher.RefDate, Voucher.RefDate)) else Null End) as LastPayDate,
  sum(case When V.DebtorF=1 Then 1 else -1 end*dbo.fn_SL_Payment_Nominal(pSL.Nominal_OC, pVoucher.SL_Cat, pVoucher.DebtorF, V.DebtorF)) as Payment
  from pSL   
  Inner Join pVoucher Voucher on (Voucher.Voucher=pSL.Voucher)       
  Left Join pVoucher oVoucher on (oVoucher.Voucher=Voucher.RefNo and Voucher.SL_Cat in ('A','B') and oVoucher.SL_Cat in ('P','B'))       
  Left Join pVoucher pVoucher on (pVoucher.Voucher=oVoucher.RefNo and oVoucher.SL_Cat='B' and pvoucher.SL_Cat='P')  
  Inner Join nVoucher V on (V.Voucher=pSL.Doc_No)
  Where pSL.PaymentF=1 and pSL.Doc_No=nVoucher.Voucher     
 ) Payment  
) Voucher   


GO



insert into PatchVersioning
select '1556 Update Script - patch 2026 (8).sql',GETDATE()
go	
  
Declare @PrevScript varchar(100)
Declare @CurrScript varchar(100)

Select @PrevScript=''
Select @CurrSCript='1556 Update Script - patch 2026 (8).sql'


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