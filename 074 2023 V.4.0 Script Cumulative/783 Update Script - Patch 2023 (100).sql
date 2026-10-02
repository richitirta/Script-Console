
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
	and Admlink.Subject='Claim' and Admlink.Type in ('DI','IC','IR','IT','IX','OP','VT') 
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
	and Admlink.Subject='Claim' and Admlink.Type in ('DI','IC','IR','IT','IX','OP','VT') 


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
   


GO


DROP PROCEDURE PI11_C 
GO
CREATE PROCEDURE PI11_C (@P_ANO as integer)
AS
Select 
coalesce(pVoucher.Voucher, Voucher.Voucher) as Voucher,
coalesce(pVoucher.Date, Voucher.Date) as Date,
coalesce(pVoucher.RefDate, Voucher.RefDate) as RefDate,
Claim.DocNo, ProAcc.Description as Name, SL.Doc_No, SL.Doc_CCY, 
Case When nVoucher.DebtorF=1 Then 1 else -1 end*dbo.fn_SL_Payment_Nominal(SL.Nominal_OC, pVoucher.SL_Cat, pVoucher.DebtorF, nVoucher.DebtorF) as Nominal_OC
from (Select Distinct Admlink.DocNo, Admlink.Voucher, Admlink.Type from ClaAss, Admlink, Claim C1, Acceptance A1, Acceptance A2 Where Admlink.AdmNo=ClaAss.AdmNo and ClaAss.Type in ('DI','IR','IT','IC','OP','VT') and ClaAss.CNO=C1.CNO and C1.ANO=A2.ANO and A2.OANO=A1.OANO and A1.ANO=@P_ANO) Claim
Inner join nVoucher on (nVoucher.Voucher=Claim.Voucher)
Inner Join pSL SL on (SL.Doc_No=nVoucher.Voucher and SL.PaymentF=1)
Inner Join pVoucher Voucher on (Voucher.Voucher=SL.Voucher)     
Left Join pVoucher pVoucher on (pVoucher.Voucher=Voucher.RefNo and Voucher.SL_Cat='B' and Voucher.RefType='INTEROFFICE' and pvoucher.SL_Cat='P')
Inner Join ProAcc on (ProAcc.ProAcc=Voucher.ProAcc)
GO

DROP procedure PI13
GO
CREATE procedure PI13(@P_ANO as integer) 
as 
Begin 
Declare @P_Date as smalldatetime 
Declare @P_PolicyNo as varchar(50) 
Declare @P_CertificateNo as varchar(20) 
Declare @P_OpenFLag as Bit 
Declare @P_LANO as int 
Declare @P_A_PolicyNo as varchar(50) 
Select @P_Date = cast(convert(varchar(10), getdate(),1) as smalldatetime) 
 
Select @P_LANO=A1.LANO, @P_PolicyNo=A1.PolicyNo, @P_CertificateNo=A1.CertificateNo, @P_OpenFlag=C1.OpenFlag from Acceptance A1, Cover C1 Where C1.CNO=A1.CNO and A1.ANO=@P_ANO 
 
if @P_LANO<>-1 
if @P_OpenFlag=1 and @P_ANO<>@P_LANO 
Select @P_A_PolicyNo=@P_PolicyNo + '-' + @P_CertificateNo 
else 
Select @P_A_PolicyNo=@P_PolicyNo 
else 
Select @P_A_PolicyNo=@P_PolicyNo 
 
Select Distinct Admlink.Subject, Voucher.Voucher, Voucher.DueDate, Voucher.DocNo, Voucher_Due.DueDate as NDueDate, 
Profile.Name, Voucher.Currency, Admlink.RefType, Admlink.BankName, Admlink.AccountNo, 
case when Voucher.debtorf=1 then Voucher.Nominal_CC-Voucher.Diff_CC else -(Voucher.Nominal_CC-Voucher.Diff_CC) end  as Nominal, 
case when Voucher.debtorf=1 then (coalesce(Voucher_Due.AmountDue, Voucher.AmountDue)-Voucher.Payment_CC) else -(coalesce(Voucher_Due.AmountDue, Voucher.AmountDue)-Voucher.Payment_CC) end as AmountDue, 
case when Voucher.debtorf=1 then Voucher.Payment_CC else -Voucher.Payment_CC end as Payment, 
case when Voucher.debtorf=1 then Voucher.Nominal_CC-Voucher.Diff_CC - Voucher.Payment_CC else -(Voucher.Nominal_CC-Voucher.Diff_CC - Voucher.Payment_CC) end as Outstanding  
from nVoucher Voucher 
Left Join Voucher_AmountDue(@P_Date) Voucher_Due on (Voucher_Due.Voucher=Voucher.Voucher)
Inner join Admlink on (Admlink.Voucher=Voucher.Voucher)
Inner Join Profile on (Profile.ID=Admlink.ID)
Where Admlink.Type in ('DI','IC','IR','IT','IX','CF','JP','BB','BA','BO','BC','BP','BD','OP','FO','VT') and Admlink.A_PolicyNo=@P_A_PolicyNo and (Admlink.Extra_1='' or Admlink.Extra_1 is null) 
 
end 
 
go



 insert into PatchVersioning
select '783 Update Script - Patch 2023 (100)',GETDATE()
go


Declare @PrevScript varchar(100)
Declare @CurrScript varchar(100)

Select @PrevScript=''
Select @CurrSCript='783 Update Script - Patch 2023 (100)'


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



