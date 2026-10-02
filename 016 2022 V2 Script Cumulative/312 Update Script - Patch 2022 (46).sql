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
from (Select Distinct Admlink.DocNo, Admlink.Voucher, Admlink.Type from ClaAss, Admlink, Claim C1, Acceptance A1, Acceptance A2 Where Admlink.AdmNo=ClaAss.AdmNo and ClaAss.Type in ('DI','IR','IC','OP') and ClaAss.CNO=C1.CNO and C1.ANO=A2.ANO and A2.OANO=A1.OANO and A1.ANO=@P_ANO) Claim
Inner join nVoucher on (nVoucher.Voucher=Claim.Voucher)
Inner Join pSL SL on (SL.Doc_No=nVoucher.Voucher and SL.PaymentF=1)
Inner Join pVoucher Voucher on (Voucher.Voucher=SL.Voucher)     
Left Join pVoucher pVoucher on (pVoucher.Voucher=Voucher.RefNo and Voucher.SL_Cat='B' and Voucher.RefType='INTEROFFICE' and pvoucher.SL_Cat='P')
Inner Join ProAcc on (ProAcc.ProAcc=Voucher.ProAcc)

GO
DROP PROCEDURE PI11_P 
GO
CREATE PROCEDURE PI11_P (@P_ANO as integer)
AS
Select
coalesce(pVoucher.Voucher, Voucher.Voucher) as Voucher,
coalesce(pVoucher.Date, Voucher.Date) as Date,
coalesce(pVoucher.RefDate, Voucher.RefDate) as RefDate,
Policy.DocNo, ProAcc.Description as Name, SL.Doc_No, SL.Doc_CCY, 
Case When nVoucher.DebtorF=1 Then 1 else -1 end*dbo.fn_SL_Payment_Nominal(SL.Nominal_OC, pVoucher.SL_Cat, pVoucher.DebtorF, nVoucher.DebtorF) as Nominal_OC
from (Select Distinct Admlink.DocNo, Admlink.Voucher, Admlink.Type from AccAss, Admlink, Acceptance A1, Acceptance A2 Where Admlink.AdmNo=AccAss.AdmNo and AccAss.Type in ('DI','IR','IC','OP') and AccAss.ANO=A1.ANO and A1.OANO=A2.OANO and A2.ANO=@P_ANO) Policy
Inner join nVoucher on (nVoucher.Voucher=Policy.Voucher)
Inner Join pSL SL on (SL.Doc_No=nVoucher.Voucher and SL.PaymentF=1)
Inner Join pVoucher Voucher on (Voucher.Voucher=SL.Voucher)     
Left Join pVoucher pVoucher on (pVoucher.Voucher=Voucher.RefNo and Voucher.SL_Cat='B' and Voucher.RefType='INTEROFFICE' and pvoucher.SL_Cat='P')
Inner Join ProAcc on (ProAcc.ProAcc=Voucher.ProAcc)

go



 insert into PatchVersioning
select '312 Update Script - Patch 2022 (46)',GETDATE()
go


Declare @PrevScript varchar(100)
Declare @CurrScript varchar(100)

Select @PrevScript=''
Select @CurrSCript='312 Update Script - Patch 2022 (46)'


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
