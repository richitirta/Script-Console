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
@P_WPC=coalesce(APayor.WPC, Payor.WPC),  
@P_Grace=coalesce(APayor.Grace, Payor.Grace),
@P_BillDate=  
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
,  
@P_BackdatedF=Acceptance.BackDatedF
from Acceptance
Inner Join Cover on (Cover.CNO=Acceptance.CNO)
Left Join Acceptance mAcceptance on (mAcceptance.ANO=mAcceptance.LANO and mAcceptance.ANO=Acceptance.LANO)  
Left Join APayor on (APayor.ANO=Acceptance.ANO)  
Left Join Payor on (Payor.ANO=coalesce(mAcceptance.ANO, Acceptance.ANO))  
Inner Join SysTab on (1=1)  
Where Acceptance.ANO=@P_ANO 


Declare @AdmNo table (AdmNo int)


if @P_ANO<>@P_LANO
	insert into @AdmNo
	Select   
	Admlink.AdmNo
	from Admlink
	Inner Join AccAss on (AccAss.AdmNo=Admlink.AdmNo)
	Inner Join Acceptance on (Acceptance.ANO=AccAss.ANO)
	Inner Join Acceptance oAcceptance on (oAcceptance.oANO=Acceptance.oANO)
	Where OAcceptance.OANO=@P_OANO and Admlink.A_PolicyNo=@P_APolicyNo and Admlink.Subject='Premium' and Admlink.Type in ('DI','IC','IR','IT','IX') 

else
	insert into @AdmNo
	Select   
	Admlink.AdmNo
	from Admlink
	Inner Join AccAss on (AccAss.AdmNo=Admlink.AdmNo)
	Inner Join Acceptance on (Acceptance.ANO=AccAss.ANO)
	Inner Join Acceptance oAcceptance on (oAcceptance.oANO=Acceptance.oANO)
	Inner Join Acceptance mAcceptance on (mAcceptance.ANO=oAcceptance.LANO)
	Where mAcceptance.OANO=@P_MOANO and Admlink.A_PolicyNo=@P_APolicyNo and Admlink.Subject='Premium' and Admlink.Type in ('DI','IC','IR','IT','IX') 

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
	(
		Select Max(coalesce(pVoucher.RefDate, coalesce(OVoucher.RefDate, Voucher.RefDate)))     
		from pSL 
		Inner Join pVoucher Voucher on (Voucher.Voucher=pSL.Voucher)     
		Left Join pVoucher oVoucher on (oVoucher.Voucher=Voucher.RefNo and Voucher.SL_Cat in ('A','B') and oVoucher.SL_Cat in ('P','B'))     
		Left Join pVoucher pVoucher on (pVoucher.Voucher=oVoucher.RefNo and oVoucher.SL_Cat='B' and pvoucher.SL_Cat='P')
		Where pSL.PaymentF=1 and pSL.Doc_No=nVoucher.Voucher    
	) as PDate                
	FROM Admlink 
	Inner Join @AdmNo AdmNo on(AdmNo.AdmNo=Admlink.AdmNo)
	Inner Join nVoucher on (nVoucher.Voucher=Admlink.Voucher)   
	Left Join Voucher_AmountWPCDue(@P_PDate) Voucher_Due on (Voucher_Due.Voucher=nVoucher.Voucher)   
) Voucher 


GO


DROP procedure PI08
GO
CREATE procedure PI08(@P_ANO as integer)   
as   
Begin   
Declare @P_PDate as smalldatetime   
Declare @P_APolicyNo as varchar(50)
Declare @P_LANO as int   
Declare @P_OANO as int   
Declare @P_MOANO as int
Select @P_PDate = cast(convert(varchar(10), getdate(),1) as smalldatetime)   
   
Select 
@P_APolicyNo=Case When C1.OpenFlag=1 and A1.BulkF=0 Then A1.PolicyNo+Case When A1.CertificateNo<>'' Then '-'+A1.CertificateNo else '' end else A1.PolicyNo end,  
@P_OANO=A1.OANO,
@P_MOANO=MA1.OANO,
@P_LANO=A1.LANO
from Acceptance A1
Left Join Acceptance mA1 on (mA1.ANO=mA1.LANO and mA1.ANO=A1.LANO)  
Inner Join Cover C1 on (C1.CNO=A1.CNO)
Where A1.ANO=@P_ANO      

Declare @AdmNo table (AdmNo int)


if @P_ANO<>@P_LANO
	insert into @AdmNo
	Select   
	Admlink.AdmNo
	from Admlink
	Inner Join AccAss on (AccAss.AdmNo=Admlink.AdmNo)
	Inner Join Acceptance on (Acceptance.ANO=AccAss.ANO)
	Inner Join Acceptance oAcceptance on (oAcceptance.oANO=Acceptance.oANO)
	Where OAcceptance.OANO=@P_OANO and Admlink.A_PolicyNo=@P_APolicyNo and Admlink.Subject='Premium' and Admlink.Type in ('DI','IC','IR','IT','IX') 
else
	insert into @AdmNo
	Select   
	Admlink.AdmNo
	from Admlink
	Inner Join AccAss on (AccAss.AdmNo=Admlink.AdmNo)
	Inner Join Acceptance on (Acceptance.ANO=AccAss.ANO)
	Inner Join Acceptance oAcceptance on (oAcceptance.oANO=Acceptance.oANO)
	Inner Join Acceptance mAcceptance on (mAcceptance.ANO=oAcceptance.LANO)
	Where mAcceptance.OANO=@P_MOANO and Admlink.A_PolicyNo=@P_APolicyNo and Admlink.Subject='Premium' and Admlink.Type in ('DI','IC','IR','IT','IX') 

   
Select Distinct Voucher.Voucher, Voucher.DueDate, Voucher.DocNo, Voucher_Due.DueDate as NDueDate, Profile.Name, Voucher.Currency,   
Admlink.RefType,  
Admlink.AccountNo, Admlink.Bank, Admlink.BankName,   
Admlink.AccountNo_Ext, Admlink.Bank_Ext, Admlink.BankName_Ext,   
case when Voucher.debtorf=1 then Voucher.Nominal_CC-Voucher.Diff_CC else -(Voucher.Nominal_CC-Voucher.Diff_CC) end  as Nominal,   
case when Voucher.debtorf=1 then (Case When coalesce(Voucher_Due.AmountDue, Voucher.AmountDue)-Voucher.Payment_CC<0 Then 0 else coalesce(Voucher_Due.AmountDue, Voucher.AmountDue)-Voucher.Payment_CC End) else -(Case When coalesce(Voucher_Due.AmountDue, Voucher.AmountDue)-Voucher.Payment_CC<0 Then 0 else coalesce(Voucher_Due.AmountDue, Voucher.AmountDue)-Voucher.Payment_CC End) end as AmountDue,   
case when Voucher.debtorf=1 then Voucher.Payment_CC else -Voucher.Payment_CC end as Payment,   
case when Voucher.debtorf=1 then Voucher.Nominal_CC-Voucher.Diff_CC - Voucher.Payment_CC else -(Voucher.Nominal_CC-Voucher.Diff_CC - Voucher.Payment_CC) end as Outstanding,   
Voucher.Installment,   
Voucher.DueDate_1, case when Voucher.debtorf=1 then Voucher.AmountDue_1 else -Voucher.AmountDue_1 end AmountDue_1,   
Voucher.DueDate_2, case when Voucher.debtorf=1 then Voucher.AmountDue_2 else -Voucher.AmountDue_2 end AmountDue_2,   
Voucher.DueDate_3, case when Voucher.debtorf=1 then Voucher.AmountDue_3 else -Voucher.AmountDue_3 end AmountDue_3,   
Voucher.DueDate_4, case when Voucher.debtorf=1 then Voucher.AmountDue_4 else -Voucher.AmountDue_4 end AmountDue_4,   
Voucher.DueDate_5, case when Voucher.debtorf=1 then Voucher.AmountDue_5 else -Voucher.AmountDue_5 end AmountDue_5,   
Voucher.DueDate_6, case when Voucher.debtorf=1 then Voucher.AmountDue_6 else -Voucher.AmountDue_6 end AmountDue_6,   
Voucher.DueDate_7, case when Voucher.debtorf=1 then Voucher.AmountDue_7 else -Voucher.AmountDue_7 end AmountDue_7,   
Voucher.DueDate_8, case when Voucher.debtorf=1 then Voucher.AmountDue_8 else -Voucher.AmountDue_8 end AmountDue_8,   
Voucher.DueDate_9, case when Voucher.debtorf=1 then Voucher.AmountDue_9 else -Voucher.AmountDue_9 end AmountDue_9,   
Voucher.DueDate_10, case when Voucher.debtorf=1 then Voucher.AmountDue_10 else -Voucher.AmountDue_10 end AmountDue_10,   
Voucher.DueDate_11, case when Voucher.debtorf=1 then Voucher.AmountDue_11 else -Voucher.AmountDue_11 end AmountDue_11,   
Voucher.DueDate_12, case when Voucher.debtorf=1 then Voucher.AmountDue_12 else -Voucher.AmountDue_12 end AmountDue_12,   
Voucher.DueDate_13, case when Voucher.debtorf=1 then Voucher.AmountDue_13 else -Voucher.AmountDue_13 end AmountDue_13,   
Voucher.DueDate_14, case when Voucher.debtorf=1 then Voucher.AmountDue_14 else -Voucher.AmountDue_14 end AmountDue_14,   
Voucher.DueDate_15, case when Voucher.debtorf=1 then Voucher.AmountDue_15 else -Voucher.AmountDue_15 end AmountDue_15,   
Voucher.DueDate_16, case when Voucher.debtorf=1 then Voucher.AmountDue_16 else -Voucher.AmountDue_16 end AmountDue_16,   
Voucher.DueDate_17, case when Voucher.debtorf=1 then Voucher.AmountDue_17 else -Voucher.AmountDue_17 end AmountDue_17,   
Voucher.DueDate_18, case when Voucher.debtorf=1 then Voucher.AmountDue_18 else -Voucher.AmountDue_18 end AmountDue_18,   
Voucher.DueDate_19, case when Voucher.debtorf=1 then Voucher.AmountDue_19 else -Voucher.AmountDue_19 end AmountDue_19,   
Voucher.DueDate_20, case when Voucher.debtorf=1 then Voucher.AmountDue_20 else -Voucher.AmountDue_20 end AmountDue_20,   
Voucher.DueDate_21, case when Voucher.debtorf=1 then Voucher.AmountDue_21 else -Voucher.AmountDue_21 end AmountDue_21,   
Voucher.DueDate_22, case when Voucher.debtorf=1 then Voucher.AmountDue_22 else -Voucher.AmountDue_22 end AmountDue_22,   
Voucher.DueDate_23, case when Voucher.debtorf=1 then Voucher.AmountDue_23 else -Voucher.AmountDue_23 end AmountDue_23,   
Voucher.DueDate_24, case when Voucher.debtorf=1 then Voucher.AmountDue_24 else -Voucher.AmountDue_24 end AmountDue_24   
from nVoucher Voucher 
Inner Join Voucher_AmountDue(@P_PDate) Voucher_Due on (Voucher_Due.Voucher=Voucher.Voucher)
Inner Join ProAcc on (ProAcc.ProAcc=Voucher.ProAcc)
Inner Join Profile on (Profile.ID=ProAcc.ID)
Inner Join Admlink on (Admlink.Voucher=Voucher.Voucher)
Inner Join @AdmNo AdmNo on (Admlink.AdmNo=AdmNo.AdmNo)
End   
   

GO

DROP procedure PI09
GO
CREATE procedure PI09(@P_ANO as integer)   
as   
Begin   
Declare @P_PDate as smalldatetime   
Declare @P_APolicyNo as varchar(50)
Declare @P_LANO as int   
Declare @P_OANO as int   
Declare @P_MOANO as int
Select @P_PDate = cast(convert(varchar(10), getdate(),1) as smalldatetime)   
   
Select 
@P_APolicyNo=Case When C1.OpenFlag=1 and A1.BulkF=0 Then A1.PolicyNo+Case When A1.CertificateNo<>'' Then '-'+A1.CertificateNo else '' end else A1.PolicyNo end,  
@P_OANO=A1.OANO,
@P_MOANO=MA1.OANO,
@P_LANO=A1.LANO
from Acceptance A1
Left Join Acceptance mA1 on (mA1.ANO=mA1.LANO and mA1.ANO=A1.LANO)  
Inner Join Cover C1 on (C1.CNO=A1.CNO)
Where A1.ANO=@P_ANO      

Declare @AdmNo table (AdmNo int)

if @P_ANO<>@P_LANO
	insert into @AdmNo
	Select   
	Admlink.AdmNo
	from Admlink
	Inner Join ClaAss on (ClaAss.AdmNo=Admlink.AdmNo)
	Inner join Claim on (Claim.CNO=ClaAss.CNO)
	Inner Join Acceptance on (Acceptance.ANO=Claim.ANO)
	Inner Join Acceptance oAcceptance on (oAcceptance.oANO=Acceptance.oANO)
	Where OAcceptance.OANO=@P_OANO and Admlink.A_PolicyNo=@P_APolicyNo 
	and Admlink.Subject='Claim' and Admlink.Type in ('DI','IC','IR','IT','IX','OP') 
else
	insert into @AdmNo
	Select   
	Admlink.AdmNo
	from Admlink
	Inner Join ClaAss on (ClaAss.AdmNo=Admlink.AdmNo)
	Inner join Claim on (Claim.CNO=ClaAss.CNO)
	Inner Join Acceptance on (Acceptance.ANO=Claim.ANO)
	Inner Join Acceptance oAcceptance on (oAcceptance.oANO=Acceptance.oANO)
	Inner Join Acceptance mAcceptance on (mAcceptance.ANO=oAcceptance.LANO)
	Where mAcceptance.OANO=@P_MOANO and Admlink.A_PolicyNo=@P_APolicyNo 
	and Admlink.Subject='Claim' and Admlink.Type in ('DI','IC','IR','IT','IX','OP') 


Select Distinct Voucher.Voucher, Voucher.DueDate, Voucher.DocNo, Profile.Name, Voucher.Currency, 
case when Voucher.debtorf=1 then Voucher.Nominal_CC-Voucher.Diff_CC else -(Voucher.Nominal_CC-Voucher.Diff_CC) end  as Nominal,   
case when Voucher.debtorf=1 then (Case When coalesce(Voucher_Due.AmountDue, Voucher.AmountDue)-Voucher.Payment_CC<0 Then 0 else coalesce(Voucher_Due.AmountDue, Voucher.AmountDue)-Voucher.Payment_CC End) else -(Case When coalesce(Voucher_Due.AmountDue, Voucher.AmountDue)-Voucher.Payment_CC<0 Then 0 else coalesce(Voucher_Due.AmountDue, Voucher.AmountDue)-Voucher.Payment_CC End) end as AmountDue,   
case when Voucher.debtorf=1 then Voucher.Payment_CC else -Voucher.Payment_CC end as Payment,   
case when Voucher.debtorf=1 then Voucher.Nominal_CC-Voucher.Diff_CC - Voucher.Payment_CC else -(Voucher.Nominal_CC-Voucher.Diff_CC - Voucher.Payment_CC) end as Outstanding
from nVoucher Voucher 
Inner Join Voucher_AmountDue(@P_PDate) Voucher_Due on (Voucher_Due.Voucher=Voucher.Voucher)
Inner Join ProAcc on (ProAcc.ProAcc=Voucher.ProAcc)
Inner Join Profile on (Profile.ID=ProAcc.ID)
Inner Join Admlink on (Admlink.Voucher=Voucher.Voucher)
Inner Join @AdmNo AdmNo on (Admlink.AdmNo=AdmNo.AdmNo)
End   
   
go


 insert into PatchVersioning
select '471 Update Script - Patch 2022 (84)',GETDATE()
go


Declare @PrevScript varchar(100)
Declare @CurrScript varchar(100)

Select @PrevScript=''
Select @CurrSCript='471 Update Script - Patch 2022 (84)'


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








