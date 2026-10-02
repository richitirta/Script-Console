DROP FUNCTION VAT_OUT_PROCESS
GO
CREATE FUNCTION VAT_OUT_PROCESS(@P_Type varchar(2),@P_Date smalldatetime, @P_PEDate smalldatetime,@P_EDate smalldatetime)                            
RETURNS TABLE                            
AS RETURN(                            
select A.Branch, V.Voucher as DocNo, V.Voucher as RefNo, 
Case When Branch.End_Date<V.TaxDate Then V.TaxDate else dateadd(day,1,Branch.End_Date) end as Date, A.Code as Code, @P_Type as Type, SysTab.Currency, 'JOURNAL' as Subject, A.Remarks as Remarks,
'Amount_1'  = Case When (A.Subject='Premium' and A.Type in ('DI','IC','IR','IT','IX')) Then A.Amount_13*V.Rate else 0 end,
'Amount_2'  = 0,
'Amount_3'  = 0,                       
 'Amount_4'  = Case When (A.Subject='Claim' and A.Type in ('OP') and A.Amount_8<>0) or (A.Subject='Claim' and A.Type in ('OP') and A.Amount_3<>0) Then A.Amount_13*V.Rate else 0 end,
'Amount_5'  = 0,                       
 'Amount'    = A.Amount_13*V.Rate
from nVoucher V, Admlink A, SysTab, Branch
where A.Voucher=V.Voucher and Branch.Branch=V.Branch
and coalesce(V.TaxNo,'')<>'' and V.TaxDate>@P_PEDate and V.TaxDate<=@P_EDate
and A.Amount_13<>0
and (
(A.Subject='Premium' and A.Type in ('DI','IC','IR','IT','IX')) or
(A.Subject='Claim' and A.Type in ('OP') and A.Amount_8<>0)    or -- Claim Salvage
(A.Subject='Claim' and A.Type in ('OP') and A.Amount_3<>0)  -- Claim OP FEE
)
)                            
GO


 insert into PatchVersioning
select '310 Update Script  - VAT_OUT_PROCESS2',GETDATE()
go


Declare @PrevScript varchar(100)
Declare @CurrScript varchar(100)

Select @PrevScript=''
Select @CurrSCript='310 Update Script  - VAT_OUT_PROCESS'


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
