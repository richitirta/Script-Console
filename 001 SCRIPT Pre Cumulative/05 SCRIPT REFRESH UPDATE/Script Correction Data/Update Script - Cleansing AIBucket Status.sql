Begin Tran

--Individual Polis First    
Update AIBucket Set Status='P', ErrMsg=''
from AIBucket, Acceptance, Cover                    
where AIBucket.Status='R'     
and Acceptance.RegNo=AIBucket.RegNo and Acceptance.LANO=-1    
and Cover.CNO=Acceptance.CNO and Not (Cover.CStatus='A' and Acceptance.AStatus in ('W','T'))        
and Acceptance.CDate<=AIBucket.Last_Update     


--Certificate Second    
Update AIBucket Set Status='P', ErrMsg=''
from AIBucket, Acceptance, Cover                    
where AIBucket.Status='R'     
and Acceptance.RegNo=AIBucket.RegNo and AIBucket.CertificateNo<>'' and Acceptance.CertificateNo=AIBucket.CertificateNo and Acceptance.ANO<>Acceptance.LANO and Cover.OpenFlag=1                  
and Cover.CNO=Acceptance.CNO and Not (Cover.CStatus='A' and Acceptance.AStatus in ('W','T'))        
and Acceptance.CDate<=AIBucket.Last_Update     


--Bulk Inforce Certificate    
Update AIBucket Set Status='P', ErrMsg=''
from AIBucket, Acceptance, Cover                    
where AIBucket.Status='R'     
and Acceptance.RegNo=AIBucket.RegNo and AIBucket.CertificateNo='' and Acceptance.BatchNo=AIBucket.BatchNo and Acceptance.ANO<>Acceptance.LANO and Cover.OpenFlag=1                  
and Cover.CNO=Acceptance.CNO and not (Cover.CStatus='A' and Acceptance.AStatus in ('W','T'))         
and Acceptance.CDate<=AIBucket.Last_Update     


--Fleet Polis Last    
Update AIBucket Set Status='P', ErrMsg=''
from AIBucket, Acceptance, Cover                    
where AIBucket.Status='R'     
and Acceptance.RegNo=AIBucket.RegNo and Acceptance.ANO=Acceptance.LANO    
and Cover.CNO=Acceptance.CNO and not (Cover.CStatus='A' and Acceptance.AStatus in ('W','T'))         
and Acceptance.CDate<=AIBucket.Last_Update     

---

--Individual Polis First    
Update AIBucket Set Status='R', ErrMsg=''
from AIBucket, Acceptance, Cover                    
where AIBucket.Status='C'     
and Acceptance.RegNo=AIBucket.RegNo and Acceptance.LANO=-1    
and Cover.CNO=Acceptance.CNO and Cover.CStatus='A' and Acceptance.AStatus in ('W','T')
and Acceptance.CDate<=AIBucket.Last_Update     

--Certificate Second    
Update AIBucket Set Status='R', ErrMsg=''
from AIBucket, Acceptance, Cover                    
where AIBucket.Status='C'     
and Acceptance.RegNo=AIBucket.RegNo and AIBucket.CertificateNo<>'' and Acceptance.CertificateNo=AIBucket.CertificateNo and Acceptance.ANO<>Acceptance.LANO and Cover.OpenFlag=1                  
and Cover.CNO=Acceptance.CNO and Cover.CStatus='A' and Acceptance.AStatus in ('W','T')
and Acceptance.CDate<=AIBucket.Last_Update     


--Bulk Inforce Certificate    
Update AIBucket Set Status='R', ErrMsg=''
from AIBucket, Acceptance, Cover                    
where AIBucket.Status='C'     
and Acceptance.RegNo=AIBucket.RegNo and AIBucket.CertificateNo='' and Acceptance.BatchNo=AIBucket.BatchNo and Acceptance.ANO<>Acceptance.LANO and Cover.OpenFlag=1                  
and Cover.CNO=Acceptance.CNO and Cover.CStatus='A' and Acceptance.AStatus in ('W','T')
and Acceptance.CDate<=AIBucket.Last_Update     


--Fleet Polis Last    
Update AIBucket Set Status='R', ErrMsg=''
from AIBucket, Acceptance, Cover                    
where AIBucket.Status='C'     
and Acceptance.RegNo=AIBucket.RegNo and Acceptance.ANO=Acceptance.LANO    
and Cover.CNO=Acceptance.CNO and Cover.CStatus='A' and Acceptance.AStatus in ('W','T')
and Acceptance.CDate<=AIBucket.Last_Update     


Commit Tran