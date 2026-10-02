IF EXISTS ( SELECT * FROM   sysobjects WHERE  id = object_id(N'QPREMIUMAMOUNT') and OBJECTPROPERTY(id, N'IsProcedure') = 1 )
BEGIN
DROP PROCEDURE QPREMIUMAMOUNT
end
GO
CREATE PROCEDURE QPREMIUMAMOUNT (@P_ANO AS INTEGER,@P_PDate as smalldatetime)                      

AS                     

Declare @P_APolicyNo as varchar(50)        
Declare @P_WPC as int  
Declare @P_BillDate as smalldatetime  
Declare @P_MinAdmNo as int
Declare @P_MaxAdmNo as int
Declare @P_BackdatedF as bit

Select   
@P_APolicyNo=Max(Case When Cover.OpenFlag=1 and Acceptance.BulkF=0 Then Acceptance.PolicyNo+Case When Acceptance.CertificateNo<>'' Then '-'+Acceptance.CertificateNo else '' end else Acceptance.PolicyNo end),  
@P_WPC=Max(coalesce(APayor.WPC, Payor.WPC)),  
@P_BillDate=  
Max(
dateadd(day,coalesce(APayor.Grace, Payor.Grace),
Case   
When Acceptance.AType='A' Then Acceptance.ADate   
else   
 Case When Cover.OpenFlag=0 Then   
  Case When SysTab.DueByEffectiveF=0 Then coalesce(mAcceptance.ADate,Acceptance.ADate) else coalesce(mAcceptance.PDate,Acceptance.PDate) end  
 else  
  Case When SysTab.DueByEffectiveF=0 Then Acceptance.ADate else Acceptance.PDate end  
 end  
end)
),  
@P_MinAdmNo=Min(coalesce(Admlink.AdmNo,0)),
@P_MaxAdmNo=Max(coalesce(Admlink.AdmNo,0)),
@P_BackdatedF=cast(max(cast(Acceptance.BackDatedF as Int)) as Bit)
from Acceptance   
Left Join Acceptance oAcceptance on (oAcceptance.oANO=Acceptance.OANO and oAcceptance.ANO<=@P_ANO)
Left Join Acceptance mAcceptance on (mAcceptance.ANO=mAcceptance.LANO and mAcceptance.ANO=Acceptance.LANO)  
Left Join APayor on (APayor.ANO=oAcceptance.ANO)  
Left Join Payor on (Payor.ANO=coalesce(mAcceptance.ANO, oAcceptance.ANO))  
Left Join AccAss on (AccAss.ANO=oAcceptance.ANO)
Left Join Admlink on (Admlink.Admno=AccAss.AdmNo and Admlink.Type in ('DI','IC','IR'))
Inner Join Cover on (Cover.CNO=Acceptance.CNO)  
Inner Join SysTab on (1=1)  
Where Acceptance.ANO=@P_ANO                


Select           
@P_BackdatedF as BackdatedF,
sum(Voucher.PremiumAmount) as PremiumAmount,          
Min(Voucher.DueDate) as DueDate,      
coalesce(datediff(day,Min(Voucher.DueDate),@P_PDate),0) as Lapse,
sum(Voucher.PremiumPaid) as PremiumPaid,          
sum(Voucher.PremiumOutstanding) as PremiumOutstanding,          
@P_WPC as WPC,  
@P_BillDate as BillDate,  
Min(Voucher.PDate) as Date          
From          
(           
	SELECT                      
	DISTINCT  
	nVoucher.Voucher,  
	CASE WHEN nVoucher.DEBTORF=1 THEN (Case When coalesce(Voucher_Due.AmountDue,0)=0 then nVoucher.Nominal_CC-nVoucher.Diff_CC else Voucher_Due.AmountDue end) ELSE -(Case When Voucher_Due.Voucher is null then nVoucher.Nominal_CC-nVoucher.Diff_CC else Voucher_Due.AmountDue end) END*nVoucher.RATE as PremiumAmount,                      
	Case When Round(nVoucher.Payment_CC,2)<round((Case When Voucher_Due.Voucher is null then nVoucher.Nominal_CC-nVoucher.Diff_CC else Voucher_Due.AmountDue end),2) Then isnull(Voucher_Due.DueDate, nVoucher.DueDate) else Null end AS DUEDATE,                

	CASE WHEN nVoucher.DEBTORF=1 THEN nVoucher.Nominal_CC-nVOucher.Diff_CC-nVoucher.PAYMENT_CC ELSE -(nVoucher.Nominal_CC-nVOucher.Diff_CC-nVoucher.PAYMENT_CC) END*nVoucher.RATE as PremiumOutstanding,                      
	CASE WHEN nVoucher.DEBTORF=1 THEN nVoucher.PAYMENT_CC ELSE -nVoucher.PAYMENT_CC END*nVoucher.RATE as PremiumPaid,                      
	(Select Max(Case When coalesce(OVoucher.RefDate, pVoucher.RefDate)<coalesce(OVoucher.PDate, pVoucher.PDate) Then coalesce(OVoucher.RefDate, pVoucher.RefDate) else coalesce(OVoucher.PDate, pVoucher.PDate) end)     
	from pSL 
	Inner Join pVoucher on (pVoucher.Voucher=pSL.Voucher)     
	Left Join pVoucher oVoucher on (oVoucher.Voucher=pVoucher.RefNo and oVoucher.SL_Cat='P')     
	Where pSL.PaymentF=1 and pSL.Doc_No=nVoucher.Voucher    
	) as PDate                
	FROM Admlink 
	Inner Join nVoucher on (nVoucher.Voucher=Admlink.Voucher)   
	Left Join Voucher_AmountWPCDue(@P_PDate) Voucher_Due on (Voucher_Due.Voucher=nVoucher.Voucher)   
	Where Admlink.Subject='Premium' and Admlink.Type in ('DI','IC','IR') 
	and Admlink.A_PolicyNo=@P_APolicyNo and Admlink.AdmNo Between @P_MinAdmNo and @P_MaxAdmNo
) Voucher 

go

  insert into PatchVersioning
select '54.6 Update Script - Patch 2019 (9)',GETDATE()
go

Declare @PrevScript varchar(100)
Declare @CurrScript varchar(100)

Select @PrevScript='54.5 Update Script - Patch 2019 (8)'
Select @CurrSCript='54.6 Update Script - Patch 2019 (9)'


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


