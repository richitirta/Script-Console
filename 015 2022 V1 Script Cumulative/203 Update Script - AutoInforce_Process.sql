DROP Procedure AutoInforce_Process
GO
CREATE Procedure AutoInforce_Process(@P_PDate as smalldatetime)                                                
as                                       

Declare @AIBucket table(PID int, ADate SmallDateTime, Last_Update SmallDateTime, RegNo Varchar(50), CertificateNo varchar(20), BatchNo varchar(30), Status varchar(1))
insert into @AIBucket 
Select top 100 PID, ADate, Last_Update, RegNo, CertificateNo, BatchNo, Status 
from AIBucket with (ReadCommitted) 
Where Status='R'
and not exists (Select Top 1 objname from syslockedobject Where ObjName='AIBUCKET'+cast(AIBUCKET.PID as varchar(10)) and Status='L')


--Individual Polis  
Select AIBucket.ADate, AIBucket.PID, Acceptance.ANO, Acceptance.LANO, Acceptance.RegNo, Acceptance.BatchNo, cast(0 as Bit) as BulkF, Acceptance.Branch, Acceptance.BackDatedF                   
from @AIBucket AIBucket
Inner Join Acceptance on (Acceptance.RegNo=AIBucket.RegNo and Acceptance.LANO=-1)
Inner Join Cover on (Cover.CNO=Acceptance.CNO)
where AIBucket.Status='R'     
and Cover.CStatus='A' and Acceptance.AStatus in ('W','T')         
and Acceptance.CDate<=AIBucket.Last_Update     

Union All    


--Open Cover Master Policy
Select AIBucket.ADate, AIBucket.PID, Acceptance.ANO, Acceptance.LANO, Acceptance.RegNo, Acceptance.BatchNo, cast(0 as Bit) as BulkF, Acceptance.Branch, Acceptance.BackDatedF                   
from @AIBucket AIBucket
Inner Join Acceptance on (Acceptance.RegNo=AIBucket.RegNo and Acceptance.LANO=Acceptance.ANO)
Inner Join Cover on (Cover.CNO=Acceptance.CNO)
where AIBucket.Status='R'     
and Cover.OpenFlag=1      
and Cover.CStatus='A' and Acceptance.AStatus in ('W','T')         
and Acceptance.CDate<=AIBucket.Last_Update     

Union All    

--Open Cover Certificate
Select AIBucket.ADate, AIBucket.PID, Acceptance.ANO, Acceptance.LANO, Acceptance.RegNo, Acceptance.BatchNo, cast(0 as Bit) as BulkF, Acceptance.Branch, Acceptance.BackDatedF
from @AIBucket AIBucket
Inner Join Acceptance on (Acceptance.RegNo=AIBucket.RegNo and AIBucket.CertificateNo<>'' and Acceptance.CertificateNo=AIBucket.CertificateNo and Acceptance.ANO<>Acceptance.LANO)
Inner Join Cover on (Cover.CNO=Acceptance.CNO)
where AIBucket.Status='R'     
and Cover.OpenFlag=1                   
and Cover.CStatus='A' and Acceptance.AStatus in ('W','T')         
and Acceptance.CDate<=AIBucket.Last_Update     

Union All        

--Bulk Inforce Certificate    
Select AIBucket.ADate, AIBucket.PID, Max(Acceptance.LANO) as ANO, Max(Acceptance.LANO) as LANO, Max(Acceptance.RegNo) as RegNo, Acceptance.BatchNo, cast(1 as Bit) as BulkF, Acceptance.Branch, cast(Max(cast(Acceptance.BackDatedF as Int)) as Bit) as BackDatedF
from @AIBucket AIBucket
Inner Join Acceptance on (Acceptance.RegNo=AIBucket.RegNo and AIBucket.CertificateNo='' and Acceptance.BatchNo=AIBucket.BatchNo and Acceptance.ANO<>Acceptance.LANO)
Inner Join Cover on (Cover.CNO=Acceptance.CNO)
where AIBucket.Status='R'     
and Cover.OpenFlag=1                  
and Cover.CStatus='A' and Acceptance.AStatus in ('W','T')         
and Acceptance.CDate<=AIBucket.Last_Update     
--Inforce Batch until Batch Completed
and not exists (Select Top 1 S.batchNo from SysBatchH S with(readcommitted) Where S.BatchNo=AIBucket.BatchNo and S.Status<>'C')
Group By AIBucket.ADate, AIBucket.PID, Acceptance.BatchNo, Acceptance.Branch    

Union All    

--Fleet Polis Last    
Select AIBucket.ADate, AIBucket.PID, Acceptance.ANO, Acceptance.LANO, Acceptance.RegNo, Acceptance.BatchNo, cast(0 as Bit) as BulkF, Acceptance.Branch, Acceptance.BackDatedF    
from @AIBucket AIBucket
Inner Join Acceptance on (Acceptance.RegNo=AIBucket.RegNo and Acceptance.ANO=Acceptance.LANO)
Inner join Cover on (Cover.CNO=Acceptance.CNO)
where AIBucket.Status='R'     
and Cover.OpenFlag=0
and Cover.CStatus='A' and Acceptance.AStatus in ('W','T')         
and Acceptance.CDate<=AIBucket.Last_Update     




GO



 insert into PatchVersioning
select '203 Update Script - AutoInforce_Process',GETDATE()
go


Declare @PrevScript varchar(100)
Declare @CurrScript varchar(100)

Select @PrevScript=''
Select @CurrSCript='203 Update Script - AutoInforce_Process'


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