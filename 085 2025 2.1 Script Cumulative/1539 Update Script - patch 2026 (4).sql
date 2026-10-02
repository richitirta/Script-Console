DROP procedure PI09
GO
CREATE procedure PI09(@P_ANO as integer)     
as     
Begin     
Declare @P_PDate as smalldatetime     
Select @P_PDate = cast(convert(varchar(10), getdate(),1) as smalldatetime)     
     
Declare @OANO as Int
Declare @LOANO as Int
Declare @LANO as Int
Declare @OpenFlag as bit
     
Select @LANO=A.LANO, @OANO=A.OANO, @LOANO=coalesce(mA.OANO,-1), @OpenFlag=C.OPENFLAG
from Acceptance A
Inner Join Cover C on (C.CNO=A.CNO)
Left Join Acceptance mA on (mA.ANO=A.LANO)
Where A.ANO=@P_ANO   

Select Voucher.Voucher, Voucher.DueDate, Voucher.DocNo, Profile.Name, Voucher.Currency,   
case when Voucher.debtorf=1 then Voucher.Nominal_CC-Voucher.Diff_CC else -(Voucher.Nominal_CC-Voucher.Diff_CC) end  as Nominal,     
case when Voucher.debtorf=1 then (Case When coalesce(Voucher_Due.AmountDue, Voucher.AmountDue)-Voucher.Payment_CC<0 Then 0 else coalesce(Voucher_Due.AmountDue, Voucher.AmountDue)-Voucher.Payment_CC End) else -(Case When coalesce(Voucher_Due.AmountDue, Voucher.AmountDue)-Voucher.Payment_CC<0 Then 0 else coalesce(Voucher_Due.AmountDue, Voucher.AmountDue)-Voucher.Payment_CC End) end as AmountDue,     
case when Voucher.debtorf=1 then Voucher.Payment_CC else -Voucher.Payment_CC end as Payment,     
case when Voucher.debtorf=1 then Voucher.Nominal_CC-Voucher.Diff_CC - Voucher.Payment_CC else -(Voucher.Nominal_CC-Voucher.Diff_CC - Voucher.Payment_CC) end as Outstanding  
from 
(
	 Select Distinct Admlink.Voucher, Admlink.DocNo  
	 from Admlink  
	 Where Admlink.Subject='Claim' and Admlink.Type in ('DI','IR','IT','IX','IC','OP')   
	 and (@LANO<>@P_ANO or @OpenFlag=1) and exists (Select Top 1 C2.Admno from Claim C1, ClaAss C2, Acceptance A Where C2.AdmNo=Admlink.AdmNo and C2.CNO=C1.CNO and A.ANO=C1.ANO and A.OANO=@OANO)
 
	 Union All

	 Select Distinct Admlink.Voucher, Admlink.DocNo  
	 from Admlink  
	 Where Admlink.Subject='Claim' and Admlink.Type in ('DI','IR','IT','IX','IC','OP')   
	 and Not (@LANO<>@P_ANO or @OpenFlag=1) and exists (Select Top 1 C2.Admno from Claim C1, ClaAss C2, Acceptance A, Acceptance mA Where C2.AdmNo=Admlink.AdmNo and C2.CNO=C1.CNO and A.ANO=C1.ANO and mA.ANO=A.LANO and mA.OANO=@LOANO)
) Claim
Inner join nVoucher Voucher on (Voucher.Voucher=Claim.Voucher)
Inner Join Voucher_AmountDue(@P_PDate) Voucher_Due on (Voucher_Due.Voucher=Voucher.Voucher)  
Inner Join ProAcc on (ProAcc.ProAcc=Voucher.ProAcc)  
Inner Join Profile on (Profile.ID=ProAcc.ID)  
End


Go

DROP PROCEDURE PI11_C 
GO
CREATE PROCEDURE PI11_C (@P_ANO as integer)    
AS    
Declare @OANO as Int
Declare @LOANO as Int
Declare @LANO as Int
Declare @OpenFlag as bit
     
Select @LANO=A.LANO, @OANO=A.OANO, @LOANO=coalesce(mA.OANO,-1), @OpenFlag=C.OPENFLAG
from Acceptance A
Inner Join Cover C on (C.CNO=A.CNO)
Left Join Acceptance mA on (mA.ANO=A.LANO)
Where A.ANO=@P_ANO       
  
Select     
coalesce(pVoucher.Voucher, Voucher.Voucher) as Voucher,    
coalesce(pVoucher.Date, Voucher.Date) as Date,    
coalesce(pVoucher.RefDate, Voucher.RefDate) as RefDate,    
Claim.DocNo, ProAcc.Description as Name, SL.Doc_No, SL.Doc_CCY,     
Case When nVoucher.DebtorF=1 Then 1 else -1 end*dbo.fn_SL_Payment_Nominal(SL.Nominal_OC, pVoucher.SL_Cat, pVoucher.DebtorF, nVoucher.DebtorF) as Nominal_OC    
from     
(  
	 Select Distinct Admlink.Voucher, Admlink.DocNo  
	 from Admlink  
	 Where Admlink.Subject='Claim' and Admlink.Type in ('DI','IR','IT','IX','IC','OP')   
	 and (@LANO<>@P_ANO or @OpenFlag=1) and exists (Select Top 1 C2.Admno from Claim C1, ClaAss C2, Acceptance A Where C2.AdmNo=Admlink.AdmNo and C2.CNO=C1.CNO and A.ANO=C1.ANO and A.OANO=@OANO)
 
	 Union All

	 Select Distinct Admlink.Voucher, Admlink.DocNo  
	 from Admlink  
	 Where Admlink.Subject='Claim' and Admlink.Type in ('DI','IR','IT','IX','IC','OP')   
	 and Not (@LANO<>@P_ANO or @OpenFlag=1) and exists (Select Top 1 C2.Admno from Claim C1, ClaAss C2, Acceptance A, Acceptance mA Where C2.AdmNo=Admlink.AdmNo and C2.CNO=C1.CNO and A.ANO=C1.ANO and mA.ANO=A.LANO and mA.OANO=@LOANO)
) Claim  
Inner join nVoucher on (nVoucher.Voucher=Claim.Voucher)    
Inner Join pSL SL on (SL.Doc_No=nVoucher.Voucher and SL.PaymentF=1)    
Inner Join pVoucher Voucher on (Voucher.Voucher=SL.Voucher)         
Left Join pVoucher pVoucher on (pVoucher.Voucher=Voucher.RefNo and Voucher.SL_Cat='B' and Voucher.RefType='INTEROFFICE' and pvoucher.SL_Cat='P')    
Inner Join ProAcc on (ProAcc.ProAcc=Voucher.ProAcc)    
go


insert into PatchVersioning
select '1539 Update Script - patch 2026 (4).sql',GETDATE()
go	
  
Declare @PrevScript varchar(100)
Declare @CurrScript varchar(100)

Select @PrevScript=''
Select @CurrSCript='1539 Update Script - patch 2026 (4).sql'


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