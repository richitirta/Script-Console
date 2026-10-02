DROP Procedure AutoPayment_Process
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
APBucket.ProAcc, 
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
Where APBucket.Status='R' and CollectionH.CollStatus='R' and COLLECTIONH.RepDate<=@P_PDate
order by APBucket.CollNo    


GO


insert into PatchVersioning
select '1501 Update Script - AutoPayment_Process.sql',GETDATE()
go	
  
Declare @PrevScript varchar(100)
Declare @CurrScript varchar(100)

Select @PrevScript=''
Select @CurrSCript='1501 Update Script - AutoPayment_Process.sql'


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