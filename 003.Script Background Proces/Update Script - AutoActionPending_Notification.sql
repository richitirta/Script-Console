IF EXISTS ( SELECT * FROM   sysobjects WHERE  id = object_id(N'AutoActionPending_Notification') and OBJECTPROPERTY(id, N'IsProcedure') = 1 )
BEGIN
DROP Procedure AutoActionPending_Notification
end
GO
Create Procedure AutoActionPending_Notification(@P_PDate as smalldatetime)                  
as                  
Select  S1.*, A.ActionName
from Actionlist a, Sysrequest S1, SysUser S2  
Where S1.ActionCode=A.ActionCode and S1.Status='' and A.ActionNotification<>0 and S2.ID=S1.Param5  
and DATEDIFF(day, S1.UserDate, @P_PDate)>A.ActionNotification 
go


  insert into PatchVersioning
select 'Update Script - AutoActionPending_Notification',GETDATE()
go