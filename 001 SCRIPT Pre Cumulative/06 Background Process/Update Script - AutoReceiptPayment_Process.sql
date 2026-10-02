DROP Procedure AUTORECEIPTPAYMENT_PROCESS
GO
CREATE Procedure AUTORECEIPTPAYMENT_PROCESS(@P_PDate as smalldatetime, @P_BatchNo as varchar(10))                                        
as                               
Select * 
from RPBucket with (ReadCommitted)
where Status='R' and (Batchno = @P_BatchNo or @P_BatchNo = '')
order by Voucher, PID ASC





