IF EXISTS ( SELECT * FROM   sysobjects WHERE  id = object_id(N'AL_Lapse_Cancellation') and OBJECTPROPERTY(id, N'IsProcedure') = 1 )
BEGIN
DROP Procedure AL_Lapse_Cancellation
end
GO
CREATE Procedure AL_Lapse_Cancellation(@P_PDate as smalldatetime) 
as 
Select A.PID, A.A_PolicyNo, Max(A2.ANO) as ANO, Max(A2.CANO) as CANO, 'Pembatalan polis sejak awal periode pertanggungan' as Memo 
from ALBucket A, ALRule, AccAss, Acceptance A1, Acceptance A2 
Where ALRule.TOC=A.TOC and ALRule.Branch=A.Branch and ALRule.Segment=A.Segment 
and AccAss.AdmNo=A.AdmNo and A1.ANO=AccAss.ANO and A2.OANO=A1.OANO 
and (A.Status='N' or (A.Status='H' and datediff(day,A.PDate,@P_PDate)>=ALRule.DaysHoldLapse and ALRule.DaysHoldLapse<>0)) 
Group By A.PID, A.A_PolicyNo 
Order by CANO Desc, ANO

go


  insert into PatchVersioning
select 'Update Script - AL_Lapse_Cancellation (TPI)',GETDATE()
go