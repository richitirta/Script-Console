IF EXISTS ( SELECT * FROM   sysobjects WHERE  id = object_id(N'AutoPayment_Process') and OBJECTPROPERTY(id, N'IsProcedure') = 1 )

BEGIN

DROP Procedure AutoPayment_Process
End
GO
CREATE Procedure AutoPayment_Process(@P_PDate as smalldatetime)                                      
as                                
Select 

APBucket.PID, 
APBucket.CollNo, 
APBucket.Branch, 
APBucket.CT, 
APBucket.VType, 
APBucket.ComAcc, 
Case When coalesce(APBucket.ProAcc,'')<>'' then APBucket.ProAcc else ProAcc.ProAcc End as ProAcc,
APBucket.Remarks, 
APBucket.RefType, 
APBucket.RefNo, 
APBucket.DOCNO, 
APBucket.RefDate, 
APBucket.AmountPaid, 
APBucket.Status, 
APBucket.Last_Opr, 
APBucket.Last_Update, 
APBucket.PDate, 
APBucket.ErrMsg, 
APBucket.BookDate,
CollectionH.CType    
from APBucket
Inner Join CollectionH on (CollectionH.CollNo=APBucket.CollNo)
Cross Apply (
            select Top 1 ProAcc.ProAcc
            from nVoucher a1 
            Inner Join CollectionV C1 On (C1.Voucher=A1.Voucher and C1.CollNo=CollectionH.CollNo) 
            Inner Join CollectionH C2 On (C2.CollNo=C1.CollNo and C2.CollStatus='R') 
            Inner Join CollectionD C3 On (C3.CollNo=C1.CollNo and C3.RefNo=C1.RefNo and C3.Currency=C1.Currency) 
            Inner Join ProAcc on (ProAcc.ProAcc=A1.ProAcc and ProAcc.ProAcc=Case When coalesce(APBucket.ProAcc,'')<>'' then APBucket.ProAcc else ProAcc.ProAcc End)
            Where Not Exists (Select top 1 pSL.Doc_No from pSL Where pSL.Doc_No=a1.voucher and pSL.pVoucher=CollectionH.CollNo)  
            Order By ProAcc.ID, a1.accountNo, a1.BankAccount, a1.BankName, a1.Voucher
) ProAcc
Where APBucket.Status='R' and CollectionH.CollStatus='R' and COLLECTIONH.RepDate<=@P_PDate
order by APBucket.CollNo    



insert into PatchVersioning
select '1478 Update Script - patch 2025 (54).sql',GETDATE()
go	
  
Declare @PrevScript varchar(100)
Declare @CurrScript varchar(100)

Select @PrevScript=''
Select @CurrSCript='1478 Update Script - patch 2025 (54).sql'


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