DROP Procedure AutoInforce_Process
GO
CREATE Procedure AutoInforce_Process(@P_PDate as smalldatetime)                                                
as                                       

Declare @AIBucket table(PID int, ADate SmallDateTime, Last_Update SmallDateTime, RegNo Varchar(20), CertificateNo varchar(20), BatchNo varchar(20), Status varchar(1))
insert into @AIBucket Select PID, ADate, Last_Update, RegNo, CertificateNo, BatchNo, Status from AIBucket with (ReadCommitted) Where Status='R'

--Individual Polis First    
Select AIBucket.ADate, AIBucket.PID, Acceptance.ANO, Acceptance.LANO, Acceptance.RegNo, Acceptance.BatchNo, cast(0 as Bit) as BulkF                  
from @AIBucket AIBucket, Acceptance, Cover                    
where AIBucket.Status='R'     
and Acceptance.RegNo=AIBucket.RegNo and Acceptance.LANO=-1    
and Cover.CNO=Acceptance.CNO and Cover.CStatus='A' and Acceptance.AStatus in ('W','T')         
and Acceptance.CDate<=AIBucket.Last_Update     

Union All    

--Certificate Second    
Select AIBucket.ADate, AIBucket.PID, Acceptance.ANO, Acceptance.LANO, Acceptance.RegNo, Acceptance.BatchNo, cast(0 as Bit) as BulkF    
from @AIBucket AIBucket, Acceptance, Cover                    
where AIBucket.Status='R'     
and Acceptance.RegNo=AIBucket.RegNo and AIBucket.CertificateNo<>'' and Acceptance.CertificateNo=AIBucket.CertificateNo and Acceptance.ANO<>Acceptance.LANO and Cover.OpenFlag=1                  
and Cover.CNO=Acceptance.CNO and Cover.CStatus='A' and Acceptance.AStatus in ('W','T')         
and Acceptance.CDate<=AIBucket.Last_Update     

Union All        

--Bulk Inforce Certificate    
Select AIBucket.ADate, AIBucket.PID, Max(Acceptance.LANO) as ANO, Max(Acceptance.LANO) as LANO, Max(Acceptance.RegNo) as RegNo, Acceptance.BatchNo, cast(1 as Bit) as BulkF                  
from @AIBucket AIBucket, Acceptance, Cover                    
where AIBucket.Status='R'     
and Acceptance.RegNo=AIBucket.RegNo and AIBucket.CertificateNo='' and Acceptance.BatchNo=AIBucket.BatchNo and Acceptance.ANO<>Acceptance.LANO and Cover.OpenFlag=1                  
and Cover.CNO=Acceptance.CNO and Cover.CStatus='A' and Acceptance.AStatus in ('W','T')         
and Acceptance.CDate<=AIBucket.Last_Update     
--Inforce Batch until Batch Completed
and not exists (Select Top 1 S.batchNo from SysBatchH S with(readcommitted) Where S.BatchNo=AIBucket.BatchNo and S.Status<>'C')
Group By AIBucket.ADate, AIBucket.PID, Acceptance.BatchNo    

Union All    

--Fleet Polis Last    
Select AIBucket.ADate, AIBucket.PID, Acceptance.ANO, Acceptance.LANO, Acceptance.RegNo, Acceptance.BatchNo, cast(0 as Bit) as BulkF    
from @AIBucket AIBucket, Acceptance, Cover                    
where AIBucket.Status='R'     
and Acceptance.RegNo=AIBucket.RegNo and Acceptance.ANO=Acceptance.LANO    
and Cover.CNO=Acceptance.CNO and Cover.CStatus='A' and Acceptance.AStatus in ('W','T')         
and Acceptance.CDate<=AIBucket.Last_Update     



