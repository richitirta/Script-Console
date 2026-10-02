DROP PROCEDURE QPREMIUMAMOUNT
GO
CREATE PROCEDURE QPREMIUMAMOUNT (@P_ANO AS INTEGER,@P_PDate as smalldatetime)                      

AS                     

Declare @P_APolicyNo as varchar(50)        
Declare @P_OANO int
Declare @P_MOANO int
Declare @P_LANO int
Declare @P_WPC as int  
Declare @P_BillDate as smalldatetime  
Declare @P_BackdatedF as bit
Declare @P_Grace as Int

Select 
@P_APolicyNo=Case When Cover.OpenFlag=1 and Acceptance.BulkF=0 Then Acceptance.PolicyNo+Case When Acceptance.CertificateNo<>'' Then '-'+Acceptance.CertificateNo else '' end else Acceptance.PolicyNo end,  
@P_OANO=Acceptance.OANO,
@P_LANO=Acceptance.LANO,
@P_MOANO=MAcceptance.OANO,
@P_WPC=coalesce(APayor.WPC, coalesce(MPayor.WPC, Payor.WPC)),  
@P_Grace=coalesce(APayor.Grace, coalesce(MPayor.Grace, Payor.Grace)),
@P_BillDate= dateadd(day,coalesce(APayor.Grace, coalesce(MPayor.Grace, Payor.Grace)),
Case   
When Acceptance.AType='A' Then Acceptance.ADate   
else   
 Case When Cover.OpenFlag=0 Then   
  Case When SysTab.DueByEffectiveF=0 Then coalesce(mAcceptance.ADate,Acceptance.ADate) else coalesce(mAcceptance.PDate,Acceptance.PDate) end  
 else  
  Case When SysTab.DueByEffectiveF=0 Then Acceptance.ADate else Acceptance.PDate end  
 end  
end)
,  
@P_BackdatedF=Acceptance.BackDatedF
from Acceptance
Inner Join Cover on (Cover.CNO=Acceptance.CNO)
Left Join Acceptance mAcceptance on (mAcceptance.ANO=mAcceptance.LANO and mAcceptance.ANO=Acceptance.LANO)  
Left Join APayor on (APayor.ANO=Acceptance.ANO)  
Left Join Payor on (Payor.ANO=Acceptance.ANO)
Left Join Payor MPayor on (MPayor.ANO=mAcceptance.ANO)
Inner Join SysTab on (1=1)  
Where Acceptance.ANO=@P_ANO 


Declare @AdmNo table (AdmNo int Primary key)


if @P_ANO<>@P_LANO
Begin
	insert into @AdmNo
	Select   
	Distinct Admlink.AdmNo
	from Admlink
	Inner Join AccAss on (AccAss.AdmNo=Admlink.AdmNo)
	Inner Join Acceptance on (Acceptance.ANO=AccAss.ANO)
	Inner Join Acceptance oAcceptance on (oAcceptance.oANO=Acceptance.oANO)
	Where OAcceptance.OANO=@P_OANO and Admlink.A_PolicyNo=@P_APolicyNo and Admlink.Subject='Premium' and Admlink.Type in ('DI','IC','IR','IT','IX') 	
	
	Union All
	
	--Data Upload
	Select   
	Admlink.AdmNo
	from Admlink
	Where Admlink.A_PolicyNo=@P_APolicyNo and Admlink.Subject='Premium' and Admlink.Type in ('DI','IC','IR','IT','IX') and Admlink.Extra_1<>''
End
else
Begin
	insert into @AdmNo
	Select   
	Distinct Admlink.AdmNo
	from Admlink
	Inner Join AccAss on (AccAss.AdmNo=Admlink.AdmNo)
	Inner Join Acceptance on (Acceptance.ANO=AccAss.ANO)
	Inner Join Acceptance oAcceptance on (oAcceptance.oANO=Acceptance.oANO)
	Inner Join Acceptance mAcceptance on (mAcceptance.ANO=oAcceptance.LANO)
	Where mAcceptance.OANO=@P_MOANO and Admlink.A_PolicyNo=@P_APolicyNo and Admlink.Subject='Premium' and Admlink.Type in ('DI','IC','IR','IT','IX') 

	Union All

	--Data Upload
	Select   
	Admlink.AdmNo
	from Admlink
	Where Admlink.A_PolicyNo=@P_APolicyNo and Admlink.Subject='Premium' and Admlink.Type in ('DI','IC','IR','IT','IX') and Admlink.Extra_1<>''
End

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
Min(Voucher.PDate) as Date          
From          
(           
	SELECT                      
	DISTINCT  
	nVoucher.Voucher,  
	CASE WHEN nVoucher.DEBTORF=1 THEN (Case When Voucher_Due.Voucher is null then nVoucher.Nominal_CC-nVoucher.Diff_CC else Voucher_Due.AmountDue end) ELSE -(Case When Voucher_Due.Voucher is null then nVoucher.Nominal_CC-nVoucher.Diff_CC else Voucher_Due.AmountDue end) END*nVoucher.RATE as PremiumAmount,                      	
	CASE WHEN nVoucher.DEBTORF=1 THEN (CASE WHEN coalesce(Voucher_Due.AmountDue,0)-nVoucher.Payment_CC<0 Then 0 Else coalesce(Voucher_Due.AmountDue,0)-nVoucher.Payment_CC End) ELSE -(CASE WHEN coalesce(Voucher_Due.AmountDue,0)-nVoucher.Payment_CC<0 Then 0 Else coalesce(Voucher_Due.AmountDue,0)-nVoucher.Payment_CC End) END*nVoucher.RATE as PremiumDue,                      
	Case When Round(nVoucher.Payment_CC,2)<round((Case When Voucher_Due.Voucher is null then nVoucher.Nominal_CC-nVoucher.Diff_CC else Voucher_Due.AmountDue end),2) Then isnull(Voucher_Due.DueDate, nVoucher.DueDate) else Null end AS DUEDATE,                
	CASE WHEN nVoucher.DEBTORF=1 THEN nVoucher.Nominal_CC-nVOucher.Diff_CC-nVoucher.PAYMENT_CC ELSE -(nVoucher.Nominal_CC-nVOucher.Diff_CC-nVoucher.PAYMENT_CC) END*nVoucher.RATE as PremiumOutstanding,   
	CASE WHEN nVoucher.DEBTORF=1 THEN nVoucher.PAYMENT_CC ELSE -nVoucher.PAYMENT_CC END*nVoucher.RATE as PremiumPaid,                      
	Payment.PDate                
	FROM Admlink 
	Inner Join @AdmNo AdmNo on(AdmNo.AdmNo=Admlink.AdmNo)
	Inner Join nVoucher on (nVoucher.Voucher=Admlink.Voucher)   
	Left Join Voucher_AmountWPCDue(@P_PDate) Voucher_Due on (Voucher_Due.Voucher=nVoucher.Voucher)   
	outer Apply (
		Select Max(coalesce(pVoucher.RefDate, coalesce(OVoucher.RefDate, Voucher.RefDate))) as PDate
		from pSL 
		Inner Join pVoucher Voucher on (Voucher.Voucher=pSL.Voucher)     
		Left Join pVoucher oVoucher on (oVoucher.Voucher=Voucher.RefNo and Voucher.SL_Cat in ('A','B') and oVoucher.SL_Cat in ('P','B'))     
		Left Join pVoucher pVoucher on (pVoucher.Voucher=oVoucher.RefNo and oVoucher.SL_Cat='B' and pvoucher.SL_Cat='P')
		Where pSL.PaymentF=1 and pSL.Doc_No=nVoucher.Voucher    
	) Payment
) Voucher 

go



  insert into PatchVersioning
select '1133 Update Script - Patch 2024 (57)',GETDATE()
go	
  
Declare @PrevScript varchar(100)
Declare @CurrScript varchar(100)

Select @PrevScript=''
Select @CurrSCript='1133 Update Script - Patch 2024 (57)'


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