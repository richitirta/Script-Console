DROP Function Get_TaxType
GO
CREATE Function Get_TaxType(@P_TaxType varchar(10), @P_ID varchar(10), @P_PDate as smalldatetime, @P_PVoucher as varchar(20), @P_TaxNominal as float,@P_@TaxDiscount as Float)          
RETURNS varchar(10) as
  
BEGIN       
Declare @TaxType varchar(10)
Declare @mTaxType varchar(10)
Declare @Type varchar(10)
Declare @PNominal_Tax Float
Declare @PLower Float
Declare @PUpper Float
Declare @Lower Float
Declare @Upper Float


Select @TaxType=TaxType,@mTaxType=mTaxtype, @Lower=coalesce(Lower,0), @Upper=coalesce(Upper,0)
from TaxType 
Where TaxType=@P_TaxType 

if (@TaxType is null) or Not (@Lower=0 and @Upper=0)
Begin
	
	Select @PNominal_Tax=coalesce(sum(-dbo.fn_SL_Payment_Nominal(SL.Nominal_OC, pVoucher.SL_Cat, pVoucher.DebtorF, V.DebtorF)*A.PNominal_Tax/A.Amount*V.Rate),0)
	from pVoucher
	Inner Join pSL SL on (pVoucher.Voucher=SL.Voucher)
	Inner Join nVoucher V on (V.Voucher=SL.Doc_No and SL.PaymentF=1)
	Inner Join Admlink A on (A.Voucher=V.Voucher and A.Type in ('BB','BA','BC','BP','BD') and A.ID=@P_ID) 
	where pVoucher.Date between '01/01/'+cast(Year(@P_PDate) as varchar(4)) and @P_PDate and pVoucher.Voucher<>@P_PVoucher

	if @mTaxType='PASAL21'
		Select @PNominal_Tax = (@PNominal_Tax + @P_TaxNominal)*(100-@P_@TaxDiscount)/100
	else
		Select @PNominal_Tax = (@PNominal_Tax + @P_TaxNominal)

	Select @TaxType=TaxType from TaxType Where @PNominal_Tax Between Lower and Upper and Lower<>Upper and MTAXTYPE=@mTaxType 
	if @TaxType is null
		Select @TaxType=@P_TaxType

End	
return @TaxType
  
END    

GO


 insert into PatchVersioning
select '211 Update Script - Patch 2022 (20)',GETDATE()
go


Declare @PrevScript varchar(100)
Declare @CurrScript varchar(100)

Select @PrevScript=''
Select @CurrSCript='211 Update Script - Patch 2022 (20)'


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



	
