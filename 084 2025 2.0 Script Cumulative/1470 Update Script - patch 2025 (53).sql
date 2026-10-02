IF EXISTS ( SELECT * FROM   sysobjects WHERE  id = object_id(N'PI13') and OBJECTPROPERTY(id, N'IsProcedure') = 1 )

BEGIN

DROP procedure PI13

end
GO

CREATE procedure PI13(@P_ANO as integer)   
as   
Begin   
Declare @P_PDate as smalldatetime     
Declare @A_PolicyNo varchar(50)

Select @P_PDate = cast(convert(varchar(10), getdate(),1) as smalldatetime)     
     
Select 
@A_PolicyNo=
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
end
from Acceptance A
Left join Acceptance mA on (mA.ANO=A.LANO)
Inner Join Cover C on (C.CNO=A.CNO)
Where A.ANO=@P_ANO     
   
Select Policy.Subject, Voucher.Voucher, Voucher.DueDate, Voucher.DocNo, Voucher_Due.DueDate as NDueDate,   
Profile.Name, Voucher.Currency, Policy.RefType, Policy.BankName, Policy.AccountNo,   
case when Voucher.debtorf=1 then Voucher.Nominal_CC-Voucher.Diff_CC else -(Voucher.Nominal_CC-Voucher.Diff_CC) end  as Nominal,   
case when Voucher.debtorf=1 then (coalesce(Voucher_Due.AmountDue, Voucher.AmountDue)-Voucher.Payment_CC) else -(coalesce(Voucher_Due.AmountDue, Voucher.AmountDue)-Voucher.Payment_CC) end as AmountDue,   
case when Voucher.debtorf=1 then Voucher.Payment_CC else -Voucher.Payment_CC end as Payment,   
case when Voucher.debtorf=1 then Voucher.Nominal_CC-Voucher.Diff_CC - Voucher.Payment_CC else -(Voucher.Nominal_CC-Voucher.Diff_CC - Voucher.Payment_CC) end as Outstanding    
from 
(
	Select Distinct Admlink.Voucher, Admlink.Subject, Admlink.RefType, Admlink.AccountNo, Admlink.Bank, Admlink.BankName, Admlink.AccountNo_Ext, Admlink.Bank_Ext, Admlink.BankName_Ext
	from Admlink
	Where Admlink.A_policyNo=@A_Policyno and Admlink.Type in ('DI','IC','IR','IT','IX','CF','JP','BB','BA','BO','BC','BP','BD','OP','FO','RP','X1','X2','X3','X4','X5','X6','X7') 
) Policy
Inner join nVoucher Voucher on (Voucher.Voucher=Policy.Voucher)
Left Join Voucher_AmountDue(@P_PDate) Voucher_Due on (Voucher_Due.Voucher=Voucher.Voucher)  
Inner Join ProAcc on (ProAcc.ProAcc=Voucher.ProAcc)  
Inner Join Profile on (Profile.ID=ProAcc.ID)  
   
end   
   
go


insert into PatchVersioning
select '1470 Update Script - patch 2025 (53)',GETDATE()
go	
  
Declare @PrevScript varchar(100)
Declare @CurrScript varchar(100)

Select @PrevScript=''
Select @CurrSCript='1470 Update Script - patch 2025 (53)'


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
