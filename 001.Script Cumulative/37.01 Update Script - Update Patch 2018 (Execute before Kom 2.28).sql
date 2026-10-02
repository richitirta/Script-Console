IF EXISTS ( SELECT * FROM   sysobjects WHERE  id = object_id(N'[dbo].[QPREMIUMAMOUNT]') and OBJECTPROPERTY(id, N'IsProcedure') = 1 )
begin
DROP Procedure QPREMIUMAMOUNT
end
GO
CREATE PROCEDURE QPREMIUMAMOUNT (@P_ANO AS INTEGER,@P_PDate as smalldatetime)                      

AS                     

Declare @P_APolicyNo as varchar(50)        
Declare @P_WPC as int  
Declare @P_BillDate as smalldatetime  
Declare @P_OANO as int        
Declare @P_OCNO as int
Declare @P_AdmNo as int
Select   
Top 1
@P_APolicyNo=Case When Cover.OpenFlag=1 and Acceptance.BulkF=0 Then Acceptance.PolicyNo+Case When Acceptance.CertificateNo<>'' Then '-'+Acceptance.CertificateNo else '' end else Acceptance.PolicyNo end,  
@P_WPC=coalesce(APayor.WPC, Payor.WPC),  
@P_BillDate=  
Case   
When Acceptance.AType='A' Then Acceptance.ADate   
else   
 Case When Cover.OpenFlag=0 Then   
  Case When SysTab.DueByEffectiveF=0 Then coalesce(mAcceptance.ADate,Acceptance.ADate) else coalesce(mAcceptance.PDate,Acceptance.PDate) end  
 else  
  Case When SysTab.DueByEffectiveF=0 Then Acceptance.ADate else Acceptance.PDate end  
 end  
end,  
@P_OANO=Acceptance.OANO,
@P_OCNO=Cover.OCNO,
@P_AdmNo=Admlink.AdmNo
from Acceptance   
Left Join Acceptance mAcceptance on (mAcceptance.ANO=Acceptance.LANO)  
Left Join APayor on (APayor.ANO=Acceptance.ANO)  
Left Join Payor on (Payor.ANO=coalesce(mAcceptance.ANO, Acceptance.ANO))  
Inner Join AccAss on (AccAss.ANO=Acceptance.ANO)
Inner Join Admlink on (Admlink.Admno=AccAss.AdmNo and Admlink.Type in ('DI','IC','IR'))
Inner Join Cover on (Cover.CNO=Acceptance.CNO)  
Inner Join SysTab on (1=1)  
Where Acceptance.ANO=@P_ANO                
Order by Admlink.AdmNo desc

Select           
sum(Voucher.PremiumAmount) as PremiumAmount,          
Min(Voucher.DueDate) as DueDate,          
sum(Voucher.PremiumPaid) as PremiumPaid,          
@P_WPC as WPC,  
@P_BillDate as BillDate,  
Max(Voucher.PDate) as Date          
From          
(           
 SELECT                      
 DISTINCT  
 nVoucher.Voucher,  
 CASE WHEN nVoucher.DEBTORF=1 THEN (Case When Voucher_Due.Voucher is null then nVoucher.Nominal_CC-nVoucher.Diff_CC else Voucher_Due.AmountDue end) ELSE -(Case When Voucher_Due.Voucher is null then nVoucher.Nominal_CC-nVoucher.Diff_CC else Voucher_Due.AmountDue end) END*nVoucher.RATE as PremiumAmount,                      
 Case When Round(nVoucher.Payment_CC,2)<round((Case When Voucher_Due.Voucher is null then nVoucher.Nominal_CC-nVoucher.Diff_CC else Voucher_Due.AmountDue end),2) Then isnull(Voucher_Due.DueDate, nVoucher.DueDate) else Null end AS DUEDATE,                 
 CASE WHEN nVoucher.DEBTORF=1 THEN nVoucher.PAYMENT_CC ELSE -nVoucher.PAYMENT_CC END*nVoucher.RATE as PremiumPaid,                      
 Admlink.WPC As WPC,              
 Admlink.BillDate as BillDate,          
 (Select Max(Case When coalesce(OVoucher.RefDate, pVoucher.RefDate)<coalesce(OVoucher.PDate, pVoucher.PDate) Then coalesce(OVoucher.RefDate, pVoucher.RefDate) else coalesce(OVoucher.PDate, pVoucher.PDate) end)     
 from pSL 
 Inner Join pVoucher on (pVoucher.Voucher=pSL.Voucher)     
 Left Join pVoucher oVoucher on (oVoucher.Voucher=pVoucher.RefNo and oVoucher.SL_Cat='P')     
 Where pSL.PaymentF=1 and pSL.Doc_No=nVoucher.Voucher    
 ) as PDate                
 FROM Admlink 
 Inner Join nVoucher on (nVoucher.Voucher=Admlink.Voucher)   
 Left Join Voucher_AmountDue(@P_PDate) Voucher_Due on (Voucher_Due.Voucher=nVoucher.Voucher)          
 Where Admlink.Subject='Premium' and Admlink.Type in ('DI','IC','IR') 
 and Admlink.A_PolicyNo=@P_APolicyNo and Admlink.AdmNo<=@P_ADMNO
 and exists (Select Top 1 AdmNo from AccAss, Acceptance, Cover Where Cover.OCNO=@P_OCNO and Cover.CNO=Acceptance.CNO and Acceptance.ANO=AccAss.ANO and AccAss.AdmNo=Admlink.AdmNo)

) Voucher          

GO

IF EXISTS ( SELECT * FROM   sysobjects WHERE  id = object_id(N'[dbo].[QREINSURANCE_RATE]') and OBJECTPROPERTY(id, N'IsProcedure') = 1 )
begin
DROP Procedure QREINSURANCE_RATE
end
GO
CREATE Procedure QREINSURANCE_RATE(@P_ANO integer, @P_CURRENCY varchar(10)) 
as 
SELECT coalesce(ReRate.CCYTo,'') as CCYTo,
Case 
When coalesce(ReRate.Rate,0)<>0 Then ReRate.Rate 
Else 
	Case
	When coalesce(ReRate.CCYTO,'')='' or coalesce(ReRate.CCYTO,'')=@P_Currency Then 
		Case When @P_Currency<>SysTab.Currency Then (Select Rate from fn_exchange(Acceptance.SDate) Currency Where Currency=@P_Currency) else 1 end
	Else
		Case When @P_Currency<>SysTab.Currency Then (Select Rate from fn_exchange(Acceptance.SDate) Currency Where Currency=@P_Currency) else 1 end
		/
		Case When @P_Currency<>ReRate.CCYTO Then (Select Rate from fn_exchange(Acceptance.SDate) Currency Where Currency=ReRate.CCYTO) else 1 end
	End
end as Rate
From Acceptance 
Inner Join SysTab on (1=1)
Inner Join Cover on (Cover.CNO=Acceptance.CNO) 
Left Join RArrHeader on (RArrHeader.ANO=Acceptance.ANO) 
Left Join ReRate on ( 
ReRate.TOC=Acceptance.TOC 
and ReRate.RYear=coalesce(( 
	Select Top 1 R1.RYear 
	from Reinsurance R1, ReClass R2 
	Left Join RePolicy R3 on (R3.RNO=R2.RNO and R3.ID=Cover.PHolder) 
	Where (R1.Category<>'P' or Coalesce(R3.ID,'')<>'') and R1.RType='Q' and R2.RNO=R1.RNO and R2.TOC=Acceptance.TOC and RArrHeader.RDate Between R1.SDate and R1.EDate 
	Order By Case When R1.RID=RArrHeader.QID Then 1 else 0 end Desc, coalesce(R3.ID,'') Desc, (Case When R2.PriorityF=1 Then R2.PriorityF else R1.PriorityF end) Desc),Year(RArrHeader.RDate)) 
And ReRate.Currency=@P_Currency) 
WHERE Acceptance.ANO=@P_ANO 

GO


IF EXISTS ( SELECT * FROM   sysobjects WHERE  id = object_id(N'[dbo].[QCLAIM_RATE]') and OBJECTPROPERTY(id, N'IsProcedure') = 1 )
begin
DROP Procedure QCLAIM_RATE
end
GO
CREATE Procedure QCLAIM_RATE(@P_CNO integer, @P_CURRENCY varchar( 10))
as
SELECT coalesce(ReRate.CCYTo,'') as CCYTo,
Case 
When coalesce(ReRate.CRate,0)<>0 Then ReRate.CRate 
When coalesce(ReRate.Rate,0)<>0 Then ReRate.Rate 
Else 
	Case
	When coalesce(ReRate.CCYTO,'')='' or coalesce(ReRate.CCYTO,'')=@P_Currency Then 
		Case When @P_Currency<>SysTab.Currency Then (Select Rate from fn_exchange(Acceptance.SDate) Currency Where Currency=@P_Currency) else 1 end
	Else
		Case When @P_Currency<>SysTab.Currency Then (Select Rate from fn_exchange(Acceptance.SDate) Currency Where Currency=@P_Currency) else 1 end
		/
		Case When @P_Currency<>ReRate.CCYTO Then (Select Rate from fn_exchange(Acceptance.SDate) Currency Where Currency=ReRate.CCYTO) else 1 end
	End
end as CRate
From Claim
Inner Join SysTab on (1=1)
Inner Join Acceptance on (Acceptance.ANO=Claim.ANO)
Inner Join Cover on (Cover.CNO=Acceptance.CNO) 
Left Join RArrHeader on (RArrHeader.ANO=Acceptance.ANO) 
Left Join ReRate on ( 
ReRate.TOC=ACCEPTANCE.TOC 
and ReRate.RYear=coalesce(( 
	Select Top 1 R1.RYear 
	from Reinsurance R1, ReClass R2 
	Left Join RePolicy R3 on (R3.RNO=R2.RNO and R3.ID=Cover.PHolder) 
	Where (R1.Category<>'P' or Coalesce(R3.ID,'')<>'') and R1.RType='Q' and R2.RNO=R1.RNO and R2.TOC=ACCEPTANCE.TOC and RArrHeader.RDate Between R1.SDate and R1.EDate 
	Order By Case When R1.RID=RArrHeader.QID Then 1 else 0 end Desc, coalesce(R3.ID,'') Desc, (Case When R2.PriorityF=1 Then R2.PriorityF else R1.PriorityF end) Desc),Year(RArrHeader.RDate)) 
And ReRate.Currency=@P_Currency) 
WHERE Claim.CNO=@P_CNO


GO


IF EXISTS ( SELECT * FROM   sysobjects WHERE  id = object_id(N'[dbo].[GetReinsuranceRate]') and OBJECTPROPERTY(id, N'IsProcedure') = 1 )
begin
DROP Procedure GetReinsuranceRate
end
GO
CREATE Procedure GetReinsuranceRate(@P_TOC as varchar(10), @P_Currency as varchar(10), @P_SDate as smalldatetime, @P_PHolder as varchar(10)='')   
as   
SELECT coalesce(ReRate.CCYTo,'') as CCYTo,
Case 
When coalesce(ReRate.Rate,0)<>0 Then ReRate.Rate 
Else 
	Case
	When coalesce(ReRate.CCYTO,'')='' or ReRate.CCYTO=@P_Currency Then 
		Case When @P_Currency<>SysTab.Currency Then (Select Rate from fn_exchange(@P_SDate) Currency Where Currency=@P_Currency) else 1 end
	Else
		Case When @P_Currency<>SysTab.Currency Then (Select Rate from fn_exchange(@P_SDate) Currency Where Currency=@P_Currency) else 1 end
		/
		Case When @P_Currency<>ReRate.CCYTO Then (Select Rate from fn_exchange(@P_SDate) Currency Where Currency=ReRate.CCYTO) else 1 end
	End
end as Rate
 
From SysTab
Left Join ReRate on (
ReRate.TOC=@P_TOC
and ReRate.RYear=coalesce((   
 Select Top 1 R1.RYear   
 from Reinsurance R1, ReClass R2   
 Left Join RePolicy R3 on (R3.RNO=R2.RNO and R3.ID=@P_PHolder)   
 Where (R1.Category<>'P' or Coalesce(R3.ID,'')<>'') and R1.RType='Q' and R2.RNO=R1.RNO and R2.TOC=@P_TOC and @P_SDate Between R1.SDate and R1.EDate   
 Order By coalesce(R3.ID,'') Desc, (Case When R2.PriorityF=1 Then R2.PriorityF else R1.PriorityF end) Desc),Year(@P_SDate)) 
And ReRate.Currency=@P_Currency) 

GO

insert into PatchVersioning
select '37.01 Update Script - Update Patch 2018 (Execute before Kom 2.28)',GETDATE()
go


Declare @PrevScript varchar(100)
Declare @CurrScript varchar(100)

Select @PrevScript='37 Script Komulatif Konsol 2.27'
Select @CurrSCript='37.01 Update Script - Update Patch 2018 (Execute before Kom 2.28)'


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
