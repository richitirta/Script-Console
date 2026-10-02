DROP Function oSL
GO
CREATE Function oSL(@P_Voucher varchar(30))     
RETURNS Table     
as Return     
(     
Select pSL.Voucher, pSL.Doc_No, pSL.Doc_Date, pSL.Doc_CCY, pSL.Nominal_OC, pSL.CT, pSL.Nominal, pSL.Remarks, pSL.Hint,     
case when coalesce(RPBucket.PID,0)<>0 then cast(1 as Bit) else cast(0 as Bit) end as BucketF,  
case when coalesce(RPBucket.PID,0)<>0 then coalesce(RPBucket.Status,'') else '' end as BucketStatus,  
case when coalesce(RPBucket.PID,0)<>0 then coalesce(RPBucket.ErrMsg,'') else '' end as BucketErrmsg,  
Case When OSL.Account is null then pSL.PaymentF else OSL.PaymentF end as PaymentF,     
Case When OSL.Account is null then pSL.Account else OSL.Account end as Account,     
Case When OSL.Account is null then pVoucher.Branch else OVoucher.Branch end as Branch,     
pSL.Nominator, pSL.Denominator, pSL.Rate, pSL.SortNo, pSL.pVoucher, pSL.LockedF, pSL.FundingF, pSL.GID, pSL.Description    
From dbo.pVoucher     
Inner Join dbo.VType on (VType.VType=pVoucher.VType)    
Inner Join dbo.pSL on (pSL.Voucher=pVoucher.Voucher)     
Left Join dbo.Branch OBranch on (OBranch.IO_Account=pSL.Account)    
Left Join pVoucher OVoucher on (OVoucher.RefNo=pSL.Voucher and OVoucher.Branch=OBranch.Branch and OVoucher.SL_Cat='B' and OVoucher.RefType='INTEROFFICE')    
Left Join pSL oSL on (oSL.Voucher=OVoucher.Voucher and oSL.Doc_no=pSL.Doc_No and oSL.Nominal=pSL.Nominal and (oSL.SortNo=0 or oSL.SortNo=pSL.SortNo))    
Outer Apply (  
 Select Top 1 R.PID, R.Status, R.Errmsg   
 from RPBucket R   
 Where R.Voucher=pVoucher.Voucher and R.NVoucher=pSL.Doc_No and R.NVoucher<>''  
 and pVoucher.SL_Cat='P' and pSL.Doc_No<>pSL.Account and (Case When OSL.PaymentF is null then pSL.PaymentF else OSL.PaymentF end)=0  
) RPBucket  
Where (pVoucher.Voucher=@P_Voucher)     
)     
GO


insert into PatchVersioning
select '1560 Update Script - Patch 2026 (10).sql',GETDATE()
go	
  
Declare @PrevScript varchar(100)
Declare @CurrScript varchar(100)

Select @PrevScript=''
Select @CurrSCript='1560 Update Script - Patch 2026 (10).sql'


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