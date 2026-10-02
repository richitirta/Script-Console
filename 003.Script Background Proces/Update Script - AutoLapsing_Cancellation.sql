IF EXISTS ( SELECT * FROM   sysobjects WHERE  id = object_id(N'AL_Lapse_Cancellation') and OBJECTPROPERTY(id, N'IsProcedure') = 1 )
BEGIN
DROP Procedure AL_Lapse_Cancellation
end
GO
CREATE Procedure AL_Lapse_Cancellation(@P_PDate as smalldatetime)                  
as                  
Select A.PID, A.A_PolicyNo, Max(A2.ANO) as ANO, Max(A2.CANO) as CANO, Max(A.DueDate) as DueDate, Max(A.Payment) as Payment
from ALBucket A, ALRule, AccAss, Acceptance A1, Acceptance A2          
Where ALRule.TOC=A.TOC and ALRule.Branch=A.Branch and ALRule.Segment=A.Segment                 
and AccAss.AdmNo=A.AdmNo and A1.ANO=AccAss.ANO and A2.OANO=A1.OANO          
and (A.Status='N' or (A.Status='H' and datediff(day,A.PDate,@P_PDate)>=ALRule.DaysHoldLapse and ALRule.DaysHoldLapse<>0))                
Group By A.PID, A.A_PolicyNo          
Order by CANO Desc, ANO
go


DROP Procedure AL_Lapse_Compensation_In_Paid
GO
CREATE Procedure AL_Lapse_Compensation_In_Paid(@P_PDate as smalldatetime, @P_A_PolicyNo as varchar(50))                
as                
Select Top 1 pVoucher.Voucher as pVoucher, Admlink.Voucher            
from Admlink, ALBucket, pVoucher, pSL        
Where ALBucket.A_PolicyNo=@P_A_PolicyNo and ALBucket.A_PolicyNo=Admlink.A_PolicyNo and Admlink.Type in ('DI','IC','IR','CF','JP','BB','BA','BO') and Admlink.Subject='Premium'              
and ALBucket.Status in ('N','H')
and pVoucher.Voucher=pSL.Voucher and pSL.Doc_No=Admlink.Voucher and pSL.PaymentF=1        
and pVoucher.Date>=ALBucket.PDate        

go


  insert into PatchVersioning
select 'Update Script - AutoLapsing_Cancellation',GETDATE()
go