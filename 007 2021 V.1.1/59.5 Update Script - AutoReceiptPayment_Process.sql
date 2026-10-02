DROP Procedure AUTORECEIPTPAYMENT_PROCESS
GO
CREATE Procedure AUTORECEIPTPAYMENT_PROCESS(@P_PDate as smalldatetime, @P_PID as int=0, @P_GPID as int=0)                                        
as                               
Select * 
from RPBucket with (ReadCommitted)
where Status='R' 
and ((@P_PID<>0 and PID = @P_PID) or (@P_GPID<>0 and GPID=@P_GPID) or (@P_PID=0 and @P_GPID=0 and GPID=0))
order by GPID, PID 