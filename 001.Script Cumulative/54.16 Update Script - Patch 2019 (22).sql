IF EXISTS ( SELECT * FROM   sysobjects WHERE  id = object_id(N'QCLAIMAMOUNT') and OBJECTPROPERTY(id, N'IsProcedure') = 1 )
BEGIN
DROP PROCEDURE QCLAIMAMOUNT 
end
GO
CREATE PROCEDURE QCLAIMAMOUNT (@P_CNO AS INTEGER,@P_PDate as smalldatetime) 
AS 
SELECT 
Admlink.A_PolicyNo,
sum(CASE WHEN nVoucher.DEBTORF=1 THEN (Case When coalesce(Voucher_Due.AmountDue,0)=0 then nVoucher.Nominal_CC-nVoucher.Diff_CC else Voucher_Due.AmountDue end) ELSE -(Case When Voucher_Due.Voucher is null then nVoucher.Nominal_CC-nVoucher.Diff_CC else Voucher_Due.AmountDue end) END*nVoucher.RATE) as ClaimAmount, 
MIN(Case When Round(nVoucher.Payment_CC,2)<round((Case When Voucher_Due.Voucher is null then nVoucher.Nominal_CC-nVoucher.Diff_CC else Voucher_Due.AmountDue end),2) Then isnull(Voucher_Due.DueDate, nVoucher.DueDate) else Null end) AS DUEDATE, 
sum(CASE WHEN nVoucher.DEBTORF=1 THEN nVoucher.PAYMENT_CC ELSE -nVoucher.PAYMENT_CC END*nVoucher.RATE) as ClaimPaid, 
MAX(Case When nVoucher.Payment_CC<>0 then nVoucher.PDATE else Null end) AS DATE, 
MAX(Admlink.WPC) As WPC 
FROM nVoucher Left Join Voucher_AmountDue(@P_PDate) Voucher_Due on (Voucher_Due.Voucher=nVoucher.Voucher), Admlink 
Where nVoucher.Voucher = Admlink.Voucher and EXISTS (SELECT ClaAss.ADMNO FROM ClaAss, Claim C1, Claim C2 WHERE C1.CNO=@P_CNO and C2.OCNO=C1.OCNO AND ClaAss.CNO=C2.CNO AND ClaAss.TYPE IN ('DI','IC','IR','OP') AND ADMLINK.ADMNO=ClaAss.ADMNO) 
Group By Admlink.A_PolicyNo
 
 
go
 

  insert into PatchVersioning
select '54.16 Update Script - Patch 2019 (22)',GETDATE()
go

Declare @PrevScript varchar(100)
Declare @CurrScript varchar(100)

Select @PrevScript='54.15 Update Script - Patch 2019 (20)'
Select @CurrSCript='54.16 Update Script - Patch 2019 (22)'


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





