IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'gpid' AND Object_ID = Object_ID(N'rpbucket'))
BEGIN
alter table rpbucket add gpid int
end
go
update rpbucket set gpid = 0 where gpid is null
go
IF EXISTS ( SELECT * FROM   sysobjects WHERE  id = object_id(N'AUTORECEIPTPAYMENT_PROCESS') and OBJECTPROPERTY(id, N'IsProcedure') = 1 )
BEGIN
DROP Procedure AUTORECEIPTPAYMENT_PROCESS
end
go
CREATE Procedure AUTORECEIPTPAYMENT_PROCESS(@P_PDate as smalldatetime, @P_PID as int=0, @P_GPID as int=0)                                        
as                               
Select * 
from RPBucket with (ReadCommitted)
where Status='R' 
and ((@P_PID<>0 and PID = @P_PID) or (@P_GPID<>0 and GPID=@P_GPID) or (@P_PID=0 and @P_GPID=0 and GPID=0))
order by GPID, Voucher, PID ASC


go


  insert into PatchVersioning
select 'Update Script - AutoReceiptPayment_Process (Cumulative 2020 v.1.2)',GETDATE()
go
