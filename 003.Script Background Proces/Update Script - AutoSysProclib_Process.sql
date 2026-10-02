IF EXISTS ( SELECT * FROM   sysobjects WHERE  id = object_id(N'AutoSysProclib_Process') and OBJECTPROPERTY(id, N'IsProcedure') = 1 )
BEGIN
Drop Procedure AutoSysProclib_Process
end
GO
Create Procedure AutoSysProclib_Process(@P_PDate as smalldatetime)          
as          
Select S1.* 
from SysProcLib S1 with (readCommitted)
Where Exists (Select Top 1 S2.ProcName from SysProcess S2 Where S1.ProcName=S2.ProcName and S2.ProcGroup in ('FA')) 
and S1.PDate<=@P_PDate and S1.Status='W' 
and not exists (Select Top 1 objname from syslockedobject Where ObjName='SYSPROCLIB'+cast(S1.PID as varchar(10)) and Status='L')
Order By S1.PID

go

  insert into PatchVersioning
select 'Update Script - AutoSysProclib_Process',GETDATE()
go