 
DROP function [dbo].[CL_R_COLLECT_ALL_ALL_ALL]
GO
CREATE function [dbo].[CL_R_COLLECT_ALL_ALL_ALL] (@P_SDate as smalldatetime, @P_EDate as SmallDateTime, @P_ID as Varchar(255))  
RETURNS TABLE  
AS RETURN  
(  
select distinct  Voucher.RefNo, Voucher.Voucher, Admlink.Type, Admlink.BatchNo, Admlink.Bank, Admlink.Date, Admlink.Subject, Voucher.DocNo, Voucher.StatID, Voucher.ActionBy, Voucher.ActionDate, Voucher.AcceptedBy, Voucher.AcceptedDate,   
Voucher.[Currency],  Voucher.Installment, Voucher.DueDate as DueDate, Voucher.AmountDue-Voucher.Payment_CC-Voucher.Payment_OC as Nominal,  
Voucher.Remarks+Voucher.sInstallment as AName, Profile.Name, Voucher.debtorF,Voucher.CreditorF, Admlink.RefType, Admlink.A_PolicyNo, Voucher.Branch  
from ProAcc,[Profile],Voucher_AmountWPCDue(@P_EDate) Voucher,AdmLink  
where  Voucher.Voucher=AdmLink.Voucher   
and ProAcc.ProAcc=Voucher.ProAcc   
and ProAcc.[ID]=[Profile].[ID]   
and Admlink.Type in ('IR','IT','IX')  
and Admlink.ISType in ('R','T')  
and round(Voucher.AmountDue - (Voucher.Payment_CC+Voucher.Payment_OC),2)>0 and Voucher.DueDate between @P_SDate and @P_EDate  
and Profile.ID Like @P_ID+'%'  
and Not Exists (Select Top 1 CollectionV.Voucher from CollectionV, CollectionH Where CollectionH.CollNo=CollectionV.COllNo and CollectionH.CollStatus<>'C' and CollectionV.CollNo<>Voucher.CollNo and CollectionV.Voucher=Voucher.Voucher)     
and Not Exists (Select Top 1 SL.doc_no from SL_Request SL, Request R Where R.Status<>'C' and R.Voucher='' and R.Request=SL.Request and SL.doc_no=Voucher.Voucher)  
  
)  
  
GO  

DROP function [dbo].[CL_R_COLLECT_UNPAID_ALL_ALL]

GO

CREATE function [dbo].[CL_R_COLLECT_UNPAID_ALL_ALL] (@P_SDate as smalldatetime, @P_EDate as SmallDateTime, @P_ID as Varchar(255))
RETURNS TABLE
AS RETURN
(
select distinct  Voucher.RefNo, Voucher.Voucher, Admlink.Type, Admlink.BatchNo, Admlink.Bank, Admlink.Date, Admlink.Subject, Voucher.DocNo, Voucher.StatID, Voucher.ActionBy, Voucher.ActionDate, Voucher.AcceptedBy, Voucher.AcceptedDate, 
Voucher.[Currency],  Voucher.Installment, Voucher.DueDate as DueDate, Voucher.AmountDue-Voucher.Payment_CC-Voucher.Payment_OC as Nominal,
Voucher.Remarks+Voucher.sInstallment as AName, Profile.Name, Voucher.debtorF,Voucher.CreditorF, Admlink.RefType, Admlink.A_PolicyNo, Voucher.Branch
from ProAcc,[Profile],Voucher_AmountWPCDue(@P_EDate) Voucher,AdmLink
where  Voucher.Voucher=AdmLink.Voucher 
and ProAcc.ProAcc=Voucher.ProAcc 
and ProAcc.[ID]=[Profile].[ID] 
and Admlink.Type in ('IR','IT','IX')
and Admlink.ISType in ('R','T')
and round(Voucher.AmountDue - (Voucher.Payment_CC+Voucher.Payment_OC),2)>0 and Voucher.DueDate between @P_SDate and @P_EDate
and Profile.ID Like @P_ID+'%'
and Voucher.Voucher in (Select CollectionV.Voucher from CollectionV, CollectionH Where CollectionH.CollNo=CollectionV.CollNo and CollectionH.CollStatus='C' and CollectionV.Paid=0 and CollectionV.CollNo<>Voucher.CollNo and CollectionV.Voucher=Voucher.Voucher)
and Not Exists (Select Top 1 CollectionV.Voucher from CollectionV, CollectionH Where CollectionH.CollNo=CollectionV.COllNo and CollectionH.CollStatus<>'C' and CollectionV.CollNo<>Voucher.CollNo and CollectionV.Voucher=Voucher.Voucher)   
and Not Exists (Select Top 1 SL.doc_no from SL_Request SL, Request R Where R.Status<>'C' and R.Voucher='' and R.Request=SL.Request and SL.doc_no=Voucher.Voucher)


)


GO
DROP function [dbo].[CL_R_COLLECT_HOLD_ALL_ALL]
GO
CREATE function [dbo].[CL_R_COLLECT_HOLD_ALL_ALL] (@P_SDate as smalldatetime, @P_EDate as SmallDateTime, @P_ID as Varchar(255))
RETURNS TABLE
AS RETURN
(
select distinct  Voucher.RefNo, Voucher.Voucher, Admlink.Type, Admlink.BatchNo, Admlink.Bank, Admlink.Date, Admlink.Subject, Voucher.DocNo, Voucher.StatID, Voucher.ActionBy, Voucher.ActionDate, Voucher.AcceptedBy, Voucher.AcceptedDate, 
Voucher.[Currency],  Voucher.Installment, Voucher.DueDate as DueDate, Voucher.AmountDue-Voucher.Payment_CC-Voucher.Payment_OC as Nominal,
Voucher.Remarks+Voucher.sInstallment as AName, Profile.Name, Voucher.debtorF,Voucher.CreditorF, Admlink.RefType, Admlink.A_PolicyNo, Voucher.Branch
from ProAcc,[Profile],Voucher_AmountWPCDue(@P_EDate) Voucher,AdmLink
where  Voucher.Voucher=AdmLink.Voucher 
and ProAcc.ProAcc=Voucher.ProAcc 
and ProAcc.[ID]=[Profile].[ID] 
and Admlink.Type in ('IR','IT','IX')
and Admlink.ISType in ('R','T')
and round(Voucher.AmountDue - (Voucher.Payment_CC+Voucher.Payment_OC),2)>0 and Voucher.DueDate between @P_SDate and @P_EDate
and Profile.ID Like @P_ID+'%'
and Voucher.Voucher in (Select CollectionV.Voucher from CollectionV, CollectionH Where CollectionH.CollNo=CollectionV.CollNo and CollectionH.CollStatus='C' and CollectionV.Hold<>0 and CollectionV.CollNo<>Voucher.CollNo and CollectionV.Voucher=Voucher.Voucher)
)

GO

DROP function [dbo].[CL_R_COLLECT_NOT_ALL_ALL]
GO
CREATE function [dbo].[CL_R_COLLECT_NOT_ALL_ALL] (@P_SDate as smalldatetime, @P_EDate as SmallDateTime, @P_ID as Varchar(255))
RETURNS TABLE
AS RETURN
(
select distinct  Voucher.RefNo, Voucher.Voucher, Admlink.Type, Admlink.BatchNo, Admlink.Bank, Admlink.Date, Admlink.Subject, Voucher.DocNo, Voucher.StatID, Voucher.ActionBy, Voucher.ActionDate, Voucher.AcceptedBy, Voucher.AcceptedDate, 
Voucher.[Currency],  Voucher.Installment, Voucher.DueDate as DueDate, Voucher.AmountDue-Voucher.Payment_CC-Voucher.Payment_OC as Nominal,
Voucher.Remarks+Voucher.sInstallment as AName, Profile.Name, Voucher.debtorF,Voucher.CreditorF, Admlink.RefType, Admlink.A_PolicyNo, Voucher.Branch
from ProAcc,[Profile],Voucher_AmountWPCDue(@P_EDate) Voucher,AdmLink
where  Voucher.Voucher=AdmLink.Voucher 
and ProAcc.ProAcc=Voucher.ProAcc 
and ProAcc.[ID]=[Profile].[ID] 
and Admlink.Type in ('IR','IT','IX')
and Admlink.ISType in ('R','T')
and round(Voucher.AmountDue - (Voucher.Payment_CC+Voucher.Payment_OC),2)>0 and Voucher.DueDate between @P_SDate and @P_EDate
and Profile.ID Like @P_ID+'%'
and Not Exists (Select Top 1 CollectionV.Voucher from CollectionV, CollectionH Where CollectionH.CollNo=CollectionV.COllNo and CollectionH.CollStatus<>'C' and CollectionV.CollNo<>Voucher.CollNo and CollectionV.Voucher=Voucher.Voucher)   
and Not Exists (Select Top 1 SL.doc_no from SL_Request SL, Request R Where R.Status<>'C' and R.Voucher='' and R.Request=SL.Request and SL.doc_no=Voucher.Voucher)

)



GO
DROP function [dbo].[CL_R_COLLECT_PERIOD_DUE_ALL_ALL]
GO
Create function [dbo].[CL_R_COLLECT_PERIOD_DUE_ALL_ALL](@P_SDate as smalldatetime, @P_EDate as SmallDateTime, @P_ID as varchar(10))
RETURNS TABLE
AS RETURN
(
select distinct  Voucher.RefNo, Voucher.Voucher, Admlink.Type, Admlink.BatchNo, Admlink.Bank, Admlink.Date, Admlink.Subject, Voucher.DocNo, Voucher.StatID, Voucher.ActionBy, Voucher.ActionDate, Voucher.AcceptedBy, Voucher.AcceptedDate, 
Voucher.[Currency],  Voucher.Installment, Voucher.DueDate as DueDate, Voucher.AmountDue as Nominal,
Voucher.Remarks+Voucher.sInstallment as AName, Profile.Name, Voucher.debtorF,Voucher.CreditorF, Admlink.RefType, Admlink.A_PolicyNo, Voucher.Branch
from ProAcc,[Profile],Voucher_AmountPeriodDue(@P_SDate, @P_EDate) Voucher,AdmLink
where  Voucher.Voucher=AdmLink.Voucher 
and ProAcc.ProAcc=Voucher.ProAcc 
and ProAcc.[ID]=[Profile].[ID] 
and Admlink.Type in ('IR','IT','IX')
and Admlink.ISType in ('R','T')
and Admlink.ID  like @P_ID+'%'
and Voucher.AmountDue<>0  
)

GO

  
DROP function [dbo].[CL_I_COLLECT_ALL_ALL_ALL]
GO
CREATE function [dbo].[CL_I_COLLECT_ALL_ALL_ALL] (@P_SDate as smalldatetime, @P_EDate as SmallDateTime)  
RETURNS TABLE  
AS RETURN  
(  
select distinct  Voucher.RefNo, Voucher.Voucher, Admlink.Type, Admlink.BatchNo, Admlink.Bank, Admlink.Date, Admlink.Subject, Voucher.DocNo, Voucher.StatID, Voucher.ActionBy, Voucher.ActionDate, Voucher.AcceptedBy, Voucher.AcceptedDate,   
Voucher.[Currency],  Voucher.Installment, Voucher.DueDate as DueDate, Voucher.AmountDue-Voucher.Payment_CC-Voucher.Payment_OC as Nominal,  
Voucher.Remarks+Voucher.sInstallment as AName, Profile.Name, Voucher.debtorF,Voucher.CreditorF, Admlink.RefType, Admlink.A_PolicyNo, Voucher.Branch  
from ProAcc,[Profile],Voucher_AmountWPCDue(@P_EDate) Voucher,AdmLink  
where  Voucher.Voucher=AdmLink.Voucher   
and ProAcc.ProAcc=Voucher.ProAcc   
and ProAcc.[ID]=[Profile].[ID]   
and Admlink.Type in ('BB','BA','BO','BC','BP','BD','DI','IC','CF','JP','SO')     
and Admlink.ISType in ('I','L','C')  
and round(Voucher.AmountDue - (Voucher.Payment_CC+Voucher.Payment_OC),2)>0 and Voucher.DueDate between @P_SDate and @P_EDate  
 
and Not Exists (Select Top 1 CollectionV.Voucher from CollectionV, CollectionH Where CollectionH.CollNo=CollectionV.COllNo and CollectionH.CollStatus<>'C' and CollectionV.CollNo<>Voucher.CollNo and CollectionV.Voucher=Voucher.Voucher)     
and Not Exists (Select Top 1 SL.doc_no from SL_Request SL, Request R Where R.Status<>'C' and R.Voucher='' and R.Request=SL.Request and SL.doc_no=Voucher.Voucher)  
  
)  
  
GO  

DROP function [dbo].[CL_I_COLLECT_UNPAID_ALL_ALL]

GO

CREATE function [dbo].[CL_I_COLLECT_UNPAID_ALL_ALL] (@P_SDate as smalldatetime, @P_EDate as SmallDateTime)
RETURNS TABLE
AS RETURN
(
select distinct  Voucher.RefNo, Voucher.Voucher, Admlink.Type, Admlink.BatchNo, Admlink.Bank, Admlink.Date, Admlink.Subject, Voucher.DocNo, Voucher.StatID, Voucher.ActionBy, Voucher.ActionDate, Voucher.AcceptedBy, Voucher.AcceptedDate, 
Voucher.[Currency],  Voucher.Installment, Voucher.DueDate as DueDate, Voucher.AmountDue-Voucher.Payment_CC-Voucher.Payment_OC as Nominal,
Voucher.Remarks+Voucher.sInstallment as AName, Profile.Name, Voucher.debtorF,Voucher.CreditorF, Admlink.RefType, Admlink.A_PolicyNo, Voucher.Branch
from ProAcc,[Profile],Voucher_AmountWPCDue(@P_EDate) Voucher,AdmLink
where  Voucher.Voucher=AdmLink.Voucher 
and ProAcc.ProAcc=Voucher.ProAcc 
and ProAcc.[ID]=[Profile].[ID] 
and Admlink.Type in ('BB','BA','BO','BC','BP','BD','DI','IC','CF','JP','SO')   
and Admlink.ISType in ('I','L','C')
and round(Voucher.AmountDue - (Voucher.Payment_CC+Voucher.Payment_OC),2)>0 and Voucher.DueDate between @P_SDate and @P_EDate

and Voucher.Voucher in (Select CollectionV.Voucher from CollectionV, CollectionH Where CollectionH.CollNo=CollectionV.CollNo and CollectionH.CollStatus='C' and CollectionV.Paid=0 and CollectionV.CollNo<>Voucher.CollNo and CollectionV.Voucher=Voucher.Voucher)
and Not Exists (Select Top 1 CollectionV.Voucher from CollectionV, CollectionH Where CollectionH.CollNo=CollectionV.COllNo and CollectionH.CollStatus<>'C' and CollectionV.CollNo<>Voucher.CollNo and CollectionV.Voucher=Voucher.Voucher)   
and Not Exists (Select Top 1 SL.doc_no from SL_Request SL, Request R Where R.Status<>'C' and R.Voucher='' and R.Request=SL.Request and SL.doc_no=Voucher.Voucher)


)


GO
DROP function [dbo].[CL_I_COLLECT_HOLD_ALL_ALL]
GO
CREATE function [dbo].[CL_I_COLLECT_HOLD_ALL_ALL] (@P_SDate as smalldatetime, @P_EDate as SmallDateTime)
RETURNS TABLE
AS RETURN
(
select distinct  Voucher.RefNo, Voucher.Voucher, Admlink.Type, Admlink.BatchNo, Admlink.Bank, Admlink.Date, Admlink.Subject, Voucher.DocNo, Voucher.StatID, Voucher.ActionBy, Voucher.ActionDate, Voucher.AcceptedBy, Voucher.AcceptedDate, 
Voucher.[Currency],  Voucher.Installment, Voucher.DueDate as DueDate, Voucher.AmountDue-Voucher.Payment_CC-Voucher.Payment_OC as Nominal,
Voucher.Remarks+Voucher.sInstallment as AName, Profile.Name, Voucher.debtorF,Voucher.CreditorF, Admlink.RefType, Admlink.A_PolicyNo, Voucher.Branch
from ProAcc,[Profile],Voucher_AmountWPCDue(@P_EDate) Voucher,AdmLink
where  Voucher.Voucher=AdmLink.Voucher 
and ProAcc.ProAcc=Voucher.ProAcc 
and ProAcc.[ID]=[Profile].[ID] 
and Admlink.Type in ('BB','BA','BO','BC','BP','BD','DI','IC','CF','JP','SO')   
and Admlink.ISType in ('I','L','C')
and round(Voucher.AmountDue - (Voucher.Payment_CC+Voucher.Payment_OC),2)>0 and Voucher.DueDate between @P_SDate and @P_EDate

and Voucher.Voucher in (Select CollectionV.Voucher from CollectionV, CollectionH Where CollectionH.CollNo=CollectionV.CollNo and CollectionH.CollStatus='C' and CollectionV.Hold<>0 and CollectionV.CollNo<>Voucher.CollNo and CollectionV.Voucher=Voucher.Voucher)
)

GO

DROP function [dbo].[CL_I_COLLECT_NOT_ALL_ALL]
GO
CREATE function [dbo].[CL_I_COLLECT_NOT_ALL_ALL] (@P_SDate as smalldatetime, @P_EDate as SmallDateTime)
RETURNS TABLE
AS RETURN
(
select distinct  Voucher.RefNo, Voucher.Voucher, Admlink.Type, Admlink.BatchNo, Admlink.Bank, Admlink.Date, Admlink.Subject, Voucher.DocNo, Voucher.StatID, Voucher.ActionBy, Voucher.ActionDate, Voucher.AcceptedBy, Voucher.AcceptedDate, 
Voucher.[Currency],  Voucher.Installment, Voucher.DueDate as DueDate, Voucher.AmountDue-Voucher.Payment_CC-Voucher.Payment_OC as Nominal,
Voucher.Remarks+Voucher.sInstallment as AName, Profile.Name, Voucher.debtorF,Voucher.CreditorF, Admlink.RefType, Admlink.A_PolicyNo, Voucher.Branch
from ProAcc,[Profile],Voucher_AmountWPCDue(@P_EDate) Voucher,AdmLink
where  Voucher.Voucher=AdmLink.Voucher 
and ProAcc.ProAcc=Voucher.ProAcc 
and ProAcc.[ID]=[Profile].[ID] 
and Admlink.Type in ('BB','BA','BO','BC','BP','BD','DI','IC','CF','JP','SO')   
and Admlink.ISType in ('I','L','C')
and round(Voucher.AmountDue - (Voucher.Payment_CC+Voucher.Payment_OC),2)>0 and Voucher.DueDate between @P_SDate and @P_EDate

and Not Exists (Select Top 1 CollectionV.Voucher from CollectionV, CollectionH Where CollectionH.CollNo=CollectionV.COllNo and CollectionH.CollStatus<>'C' and CollectionV.CollNo<>Voucher.CollNo and CollectionV.Voucher=Voucher.Voucher)   
and Not Exists (Select Top 1 SL.doc_no from SL_Request SL, Request R Where R.Status<>'C' and R.Voucher='' and R.Request=SL.Request and SL.doc_no=Voucher.Voucher)

)



GO
DROP function [dbo].[CL_I_COLLECT_PERIOD_DUE_ALL_ALL]
GO
Create function [dbo].[CL_I_COLLECT_PERIOD_DUE_ALL_ALL](@P_SDate as smalldatetime, @P_EDate as SmallDateTime, @P_ID as varchar(10))
RETURNS TABLE
AS RETURN
(
select distinct  Voucher.RefNo, Voucher.Voucher, Admlink.Type, Admlink.BatchNo, Admlink.Bank, Admlink.Date, Admlink.Subject, Voucher.DocNo, Voucher.StatID, Voucher.ActionBy, Voucher.ActionDate, Voucher.AcceptedBy, Voucher.AcceptedDate, 
Voucher.[Currency],  Voucher.Installment, Voucher.DueDate as DueDate, Voucher.AmountDue as Nominal,
Voucher.Remarks+Voucher.sInstallment as AName, Profile.Name, Voucher.debtorF,Voucher.CreditorF, Admlink.RefType, Admlink.A_PolicyNo, Voucher.Branch
from ProAcc,[Profile],Voucher_AmountPeriodDue(@P_SDate, @P_EDate) Voucher,AdmLink
where  Voucher.Voucher=AdmLink.Voucher 
and ProAcc.ProAcc=Voucher.ProAcc 
and ProAcc.[ID]=[Profile].[ID] 
and Admlink.Type in ('BB','BA','BO','BC','BP','BD','DI','IC','CF','JP','SO')   
and Admlink.ISType in ('I','L','C')
and Admlink.ID  like @P_ID+'%'
and Voucher.AmountDue<>0  
)





GO

DROP function [dbo].[CL_F_COLLECT_ALL_ALL_ALL]
GO
CREATE function [dbo].[CL_F_COLLECT_ALL_ALL_ALL] (@P_SDate as smalldatetime, @P_EDate as SmallDateTime, @P_ID as Varchar(255))  
RETURNS TABLE  
AS RETURN  
(  
select distinct  Voucher.RefNo, Voucher.Voucher, Admlink.Type, Admlink.BatchNo, Admlink.Bank, Admlink.Date, Admlink.Subject, Voucher.DocNo, Voucher.StatID, Voucher.ActionBy, Voucher.ActionDate, Voucher.AcceptedBy, Voucher.AcceptedDate,   
Voucher.[Currency],  Voucher.Installment, Voucher.DueDate as DueDate, Voucher.AmountDue-Voucher.Payment_CC-Voucher.Payment_OC as Nominal,  
Voucher.Remarks+Voucher.sInstallment as AName, Profile.Name, Voucher.debtorF,Voucher.CreditorF, Admlink.RefType, Admlink.A_PolicyNo, Voucher.Branch  
from ProAcc,[Profile],Voucher_AmountWPCDue(@P_EDate) Voucher,AdmLink  
where  Voucher.Voucher=AdmLink.Voucher   
and ProAcc.ProAcc=Voucher.ProAcc   
and ProAcc.[ID]=[Profile].[ID]   
and Admlink.Type in ('BB','BA','BO','BC','BP','BD','DI','IC','CF','JP','SO')     
and Admlink.ISType in ('I','L','C')  
and round(Voucher.AmountDue - (Voucher.Payment_CC+Voucher.Payment_OC),2)>0 and Voucher.DueDate between @P_SDate and @P_EDate  
and Profile.ID Like @P_ID+'%'  
and Not Exists (Select Top 1 CollectionV.Voucher from CollectionV, CollectionH Where CollectionH.CollNo=CollectionV.COllNo and CollectionH.CollStatus<>'C' and CollectionV.CollNo<>Voucher.CollNo and CollectionV.Voucher=Voucher.Voucher)     
and Not Exists (Select Top 1 SL.doc_no from SL_Request SL, Request R Where R.Status<>'C' and R.Voucher='' and R.Request=SL.Request and SL.doc_no=Voucher.Voucher)  
  
)  
  
GO  

DROP function [dbo].[CL_F_COLLECT_UNPAID_ALL_ALL]

GO

CREATE function [dbo].[CL_F_COLLECT_UNPAID_ALL_ALL] (@P_SDate as smalldatetime, @P_EDate as SmallDateTime, @P_ID as Varchar(255))
RETURNS TABLE
AS RETURN
(
select distinct  Voucher.RefNo, Voucher.Voucher, Admlink.Type, Admlink.BatchNo, Admlink.Bank, Admlink.Date, Admlink.Subject, Voucher.DocNo, Voucher.StatID, Voucher.ActionBy, Voucher.ActionDate, Voucher.AcceptedBy, Voucher.AcceptedDate, 
Voucher.[Currency],  Voucher.Installment, Voucher.DueDate as DueDate, Voucher.AmountDue-Voucher.Payment_CC-Voucher.Payment_OC as Nominal,
Voucher.Remarks+Voucher.sInstallment as AName, Profile.Name, Voucher.debtorF,Voucher.CreditorF, Admlink.RefType, Admlink.A_PolicyNo, Voucher.Branch
from ProAcc,[Profile],Voucher_AmountWPCDue(@P_EDate) Voucher,AdmLink
where  Voucher.Voucher=AdmLink.Voucher 
and ProAcc.ProAcc=Voucher.ProAcc 
and ProAcc.[ID]=[Profile].[ID] 
and Admlink.Type in ('BB','BA','BO','BC','BP','BD','DI','IC','CF','JP','SO')   
and Admlink.ISType in ('I','L','C')
and round(Voucher.AmountDue - (Voucher.Payment_CC+Voucher.Payment_OC),2)>0 and Voucher.DueDate between @P_SDate and @P_EDate
and Profile.ID Like @P_ID+'%'
and Voucher.Voucher in (Select CollectionV.Voucher from CollectionV, CollectionH Where CollectionH.CollNo=CollectionV.CollNo and CollectionH.CollStatus='C' and CollectionV.Paid=0 and CollectionV.CollNo<>Voucher.CollNo and CollectionV.Voucher=Voucher.Voucher)
and Not Exists (Select Top 1 CollectionV.Voucher from CollectionV, CollectionH Where CollectionH.CollNo=CollectionV.COllNo and CollectionH.CollStatus<>'C' and CollectionV.CollNo<>Voucher.CollNo and CollectionV.Voucher=Voucher.Voucher)   
and Not Exists (Select Top 1 SL.doc_no from SL_Request SL, Request R Where R.Status<>'C' and R.Voucher='' and R.Request=SL.Request and SL.doc_no=Voucher.Voucher)


)


GO
DROP function [dbo].[CL_F_COLLECT_HOLD_ALL_ALL]
GO
CREATE function [dbo].[CL_F_COLLECT_HOLD_ALL_ALL] (@P_SDate as smalldatetime, @P_EDate as SmallDateTime, @P_ID as Varchar(255))
RETURNS TABLE
AS RETURN
(
select distinct  Voucher.RefNo, Voucher.Voucher, Admlink.Type, Admlink.BatchNo, Admlink.Bank, Admlink.Date, Admlink.Subject, Voucher.DocNo, Voucher.StatID, Voucher.ActionBy, Voucher.ActionDate, Voucher.AcceptedBy, Voucher.AcceptedDate, 
Voucher.[Currency],  Voucher.Installment, Voucher.DueDate as DueDate, Voucher.AmountDue-Voucher.Payment_CC-Voucher.Payment_OC as Nominal,
Voucher.Remarks+Voucher.sInstallment as AName, Profile.Name, Voucher.debtorF,Voucher.CreditorF, Admlink.RefType, Admlink.A_PolicyNo, Voucher.Branch
from ProAcc,[Profile],Voucher_AmountWPCDue(@P_EDate) Voucher,AdmLink
where  Voucher.Voucher=AdmLink.Voucher 
and ProAcc.ProAcc=Voucher.ProAcc 
and ProAcc.[ID]=[Profile].[ID] 
and Admlink.Type in ('BB','BA','BO','BC','BP','BD','DI','IC','CF','JP','SO')   
and Admlink.ISType in ('I','L','C')
and round(Voucher.AmountDue - (Voucher.Payment_CC+Voucher.Payment_OC),2)>0 and Voucher.DueDate between @P_SDate and @P_EDate
and Profile.ID Like @P_ID+'%'
and Voucher.Voucher in (Select CollectionV.Voucher from CollectionV, CollectionH Where CollectionH.CollNo=CollectionV.CollNo and CollectionH.CollStatus='C' and CollectionV.Hold<>0 and CollectionV.CollNo<>Voucher.CollNo and CollectionV.Voucher=Voucher.Voucher)
)

GO

DROP function [dbo].[CL_F_COLLECT_NOT_ALL_ALL]
GO
CREATE function [dbo].[CL_F_COLLECT_NOT_ALL_ALL] (@P_SDate as smalldatetime, @P_EDate as SmallDateTime, @P_ID as Varchar(255))
RETURNS TABLE
AS RETURN
(
select distinct  Voucher.RefNo, Voucher.Voucher, Admlink.Type, Admlink.BatchNo, Admlink.Bank, Admlink.Date, Admlink.Subject, Voucher.DocNo, Voucher.StatID, Voucher.ActionBy, Voucher.ActionDate, Voucher.AcceptedBy, Voucher.AcceptedDate, 
Voucher.[Currency],  Voucher.Installment, Voucher.DueDate as DueDate, Voucher.AmountDue-Voucher.Payment_CC-Voucher.Payment_OC as Nominal,
Voucher.Remarks+Voucher.sInstallment as AName, Profile.Name, Voucher.debtorF,Voucher.CreditorF, Admlink.RefType, Admlink.A_PolicyNo, Voucher.Branch
from ProAcc,[Profile],Voucher_AmountWPCDue(@P_EDate) Voucher,AdmLink
where  Voucher.Voucher=AdmLink.Voucher 
and ProAcc.ProAcc=Voucher.ProAcc 
and ProAcc.[ID]=[Profile].[ID] 
and Admlink.Type in ('BB','BA','BO','BC','BP','BD','DI','IC','CF','JP','SO')   
and Admlink.ISType in ('I','L','C')
and round(Voucher.AmountDue - (Voucher.Payment_CC+Voucher.Payment_OC),2)>0 and Voucher.DueDate between @P_SDate and @P_EDate
and Profile.ID Like @P_ID+'%'
and Not Exists (Select Top 1 CollectionV.Voucher from CollectionV, CollectionH Where CollectionH.CollNo=CollectionV.COllNo and CollectionH.CollStatus<>'C' and CollectionV.CollNo<>Voucher.CollNo and CollectionV.Voucher=Voucher.Voucher)   
and Not Exists (Select Top 1 SL.doc_no from SL_Request SL, Request R Where R.Status<>'C' and R.Voucher='' and R.Request=SL.Request and SL.doc_no=Voucher.Voucher)

)



GO
DROP function [dbo].[CL_F_COLLECT_PERIOD_DUE_ALL_ALL]
GO
Create function [dbo].[CL_F_COLLECT_PERIOD_DUE_ALL_ALL](@P_SDate as smalldatetime, @P_EDate as SmallDateTime, @P_ID as varchar(10))
RETURNS TABLE
AS RETURN
(
select distinct  Voucher.RefNo, Voucher.Voucher, Admlink.Type, Admlink.BatchNo, Admlink.Bank, Admlink.Date, Admlink.Subject, Voucher.DocNo, Voucher.StatID, Voucher.ActionBy, Voucher.ActionDate, Voucher.AcceptedBy, Voucher.AcceptedDate, 
Voucher.[Currency],  Voucher.Installment, Voucher.DueDate as DueDate, Voucher.AmountDue as Nominal,
Voucher.Remarks+Voucher.sInstallment as AName, Profile.Name, Voucher.debtorF,Voucher.CreditorF, Admlink.RefType, Admlink.A_PolicyNo, Voucher.Branch
from ProAcc,[Profile],Voucher_AmountPeriodDue(@P_SDate, @P_EDate) Voucher,AdmLink
where  Voucher.Voucher=AdmLink.Voucher 
and ProAcc.ProAcc=Voucher.ProAcc 
and ProAcc.[ID]=[Profile].[ID] 
and Admlink.Type in ('BB','BA','BO','BC','BP','BD','DI','IC','CF','JP','SO')   
and Admlink.ISType in ('I','L','C')
and Admlink.ID  like @P_ID+'%'
and Voucher.AmountDue<>0  
)

GO
DROP function [dbo].[CL_A_COLLECT_ALL_ALL_ALL]
GO
CREATE function [dbo].[CL_A_COLLECT_ALL_ALL_ALL] (@P_SDate as smalldatetime, @P_EDate as SmallDateTime, @P_ID as Varchar(255))  
RETURNS TABLE  
AS RETURN  
(  
select distinct  Voucher.RefNo, Voucher.Voucher, Admlink.Type, Admlink.BatchNo, Admlink.Bank, Admlink.Date, Admlink.Subject, Voucher.DocNo, Voucher.StatID, Voucher.ActionBy, Voucher.ActionDate, Voucher.AcceptedBy, Voucher.AcceptedDate,   
Voucher.[Currency],  Voucher.Installment, Voucher.DueDate as DueDate, Voucher.AmountDue-Voucher.Payment_CC-Voucher.Payment_OC as Nominal,  
Voucher.Remarks+Voucher.sInstallment as AName, Profile.Name, Voucher.debtorF,Voucher.CreditorF, Admlink.RefType, Admlink.A_PolicyNo, Voucher.Branch  
from ProAcc,[Profile],Voucher_AmountWPCDue(@P_EDate) Voucher,AdmLink  
where  Voucher.Voucher=AdmLink.Voucher   
and ProAcc.ProAcc=Voucher.ProAcc   
and ProAcc.[ID]=[Profile].[ID]   
and Admlink.Type in ('BB','BA','BO','BC','BP','BD','DI','IC','CF','JP','SO')     
and Admlink.ISType in ('I','L','C')  
and ((Admlink.Type in ('BB','BA','BO','BC','BP','BD') and Admlink.ID=Admlink.Source) or (Admlink.Type not in ('BB','BA','BO','BC','BP','BD')))
and round(Voucher.AmountDue - (Voucher.Payment_CC+Voucher.Payment_OC),2)>0 and Voucher.DueDate between @P_SDate and @P_EDate  
and Profile.ID Like @P_ID+'%'  
and Not Exists (Select Top 1 CollectionV.Voucher from CollectionV, CollectionH Where CollectionH.CollNo=CollectionV.COllNo and CollectionH.CollStatus<>'C' and CollectionV.CollNo<>Voucher.CollNo and CollectionV.Voucher=Voucher.Voucher)     
and Not Exists (Select Top 1 SL.doc_no from SL_Request SL, Request R Where R.Status<>'C' and R.Voucher='' and R.Request=SL.Request and SL.doc_no=Voucher.Voucher)  
  
)  
  
GO  

DROP function [dbo].[CL_A_COLLECT_UNPAID_ALL_ALL]

GO

CREATE function [dbo].[CL_A_COLLECT_UNPAID_ALL_ALL] (@P_SDate as smalldatetime, @P_EDate as SmallDateTime, @P_ID as Varchar(255))
RETURNS TABLE
AS RETURN
(
select distinct  Voucher.RefNo, Voucher.Voucher, Admlink.Type, Admlink.BatchNo, Admlink.Bank, Admlink.Date, Admlink.Subject, Voucher.DocNo, Voucher.StatID, Voucher.ActionBy, Voucher.ActionDate, Voucher.AcceptedBy, Voucher.AcceptedDate, 
Voucher.[Currency],  Voucher.Installment, Voucher.DueDate as DueDate, Voucher.AmountDue-Voucher.Payment_CC-Voucher.Payment_OC as Nominal,
Voucher.Remarks+Voucher.sInstallment as AName, Profile.Name, Voucher.debtorF,Voucher.CreditorF, Admlink.RefType, Admlink.A_PolicyNo, Voucher.Branch
from ProAcc,[Profile],Voucher_AmountWPCDue(@P_EDate) Voucher,AdmLink
where  Voucher.Voucher=AdmLink.Voucher 
and ProAcc.ProAcc=Voucher.ProAcc 
and ProAcc.[ID]=[Profile].[ID] 
and Admlink.Type in ('BB','BA','BO','BC','BP','BD','DI','IC','CF','JP','SO')   
and Admlink.ISType in ('I','L','C')
and ((Admlink.Type in ('BB','BA','BO','BC','BP','BD') and Admlink.ID=Admlink.Source) or (Admlink.Type not in ('BB','BA','BO','BC','BP','BD')))
and round(Voucher.AmountDue - (Voucher.Payment_CC+Voucher.Payment_OC),2)>0 and Voucher.DueDate between @P_SDate and @P_EDate
and Profile.ID Like @P_ID+'%'
and Voucher.Voucher in (Select CollectionV.Voucher from CollectionV, CollectionH Where CollectionH.CollNo=CollectionV.CollNo and CollectionH.CollStatus='C' and CollectionV.Paid=0 and CollectionV.CollNo<>Voucher.CollNo and CollectionV.Voucher=Voucher.Voucher)
and Not Exists (Select Top 1 CollectionV.Voucher from CollectionV, CollectionH Where CollectionH.CollNo=CollectionV.COllNo and CollectionH.CollStatus<>'C' and CollectionV.CollNo<>Voucher.CollNo and CollectionV.Voucher=Voucher.Voucher)   
and Not Exists (Select Top 1 SL.doc_no from SL_Request SL, Request R Where R.Status<>'C' and R.Voucher='' and R.Request=SL.Request and SL.doc_no=Voucher.Voucher)


)


GO
DROP function [dbo].[CL_A_COLLECT_HOLD_ALL_ALL]
GO
CREATE function [dbo].[CL_A_COLLECT_HOLD_ALL_ALL] (@P_SDate as smalldatetime, @P_EDate as SmallDateTime, @P_ID as Varchar(255))
RETURNS TABLE
AS RETURN
(
select distinct  Voucher.RefNo, Voucher.Voucher, Admlink.Type, Admlink.BatchNo, Admlink.Bank, Admlink.Date, Admlink.Subject, Voucher.DocNo, Voucher.StatID, Voucher.ActionBy, Voucher.ActionDate, Voucher.AcceptedBy, Voucher.AcceptedDate, 
Voucher.[Currency],  Voucher.Installment, Voucher.DueDate as DueDate, Voucher.AmountDue-Voucher.Payment_CC-Voucher.Payment_OC as Nominal,
Voucher.Remarks+Voucher.sInstallment as AName, Profile.Name, Voucher.debtorF,Voucher.CreditorF, Admlink.RefType, Admlink.A_PolicyNo, Voucher.Branch
from ProAcc,[Profile],Voucher_AmountWPCDue(@P_EDate) Voucher,AdmLink
where  Voucher.Voucher=AdmLink.Voucher 
and ProAcc.ProAcc=Voucher.ProAcc 
and ProAcc.[ID]=[Profile].[ID] 
and Admlink.Type in ('BB','BA','BO','BC','BP','BD','DI','IC','CF','JP','SO')   
and Admlink.ISType in ('I','L','C')
and ((Admlink.Type in ('BB','BA','BO','BC','BP','BD') and Admlink.ID=Admlink.Source) or (Admlink.Type not in ('BB','BA','BO','BC','BP','BD')))
and round(Voucher.AmountDue - (Voucher.Payment_CC+Voucher.Payment_OC),2)>0 and Voucher.DueDate between @P_SDate and @P_EDate
and Profile.ID Like @P_ID+'%'
and Voucher.Voucher in (Select CollectionV.Voucher from CollectionV, CollectionH Where CollectionH.CollNo=CollectionV.CollNo and CollectionH.CollStatus='C' and CollectionV.Hold<>0 and CollectionV.CollNo<>Voucher.CollNo and CollectionV.Voucher=Voucher.Voucher)
)

GO

DROP function [dbo].[CL_A_COLLECT_NOT_ALL_ALL]
GO
CREATE function [dbo].[CL_A_COLLECT_NOT_ALL_ALL] (@P_SDate as smalldatetime, @P_EDate as SmallDateTime, @P_ID as Varchar(255))
RETURNS TABLE
AS RETURN
(
select distinct  Voucher.RefNo, Voucher.Voucher, Admlink.Type, Admlink.BatchNo, Admlink.Bank, Admlink.Date, Admlink.Subject, Voucher.DocNo, Voucher.StatID, Voucher.ActionBy, Voucher.ActionDate, Voucher.AcceptedBy, Voucher.AcceptedDate, 
Voucher.[Currency],  Voucher.Installment, Voucher.DueDate as DueDate, Voucher.AmountDue-Voucher.Payment_CC-Voucher.Payment_OC as Nominal,
Voucher.Remarks+Voucher.sInstallment as AName, Profile.Name, Voucher.debtorF,Voucher.CreditorF, Admlink.RefType, Admlink.A_PolicyNo, Voucher.Branch
from ProAcc,[Profile],Voucher_AmountWPCDue(@P_EDate) Voucher,AdmLink
where  Voucher.Voucher=AdmLink.Voucher 
and ProAcc.ProAcc=Voucher.ProAcc 
and ProAcc.[ID]=[Profile].[ID] 
and Admlink.Type in ('BB','BA','BO','BC','BP','BD','DI','IC','CF','JP','SO')   
and Admlink.ISType in ('I','L','C')
and ((Admlink.Type in ('BB','BA','BO','BC','BP','BD') and Admlink.ID=Admlink.Source) or (Admlink.Type not in ('BB','BA','BO','BC','BP','BD')))
and round(Voucher.AmountDue - (Voucher.Payment_CC+Voucher.Payment_OC),2)>0 and Voucher.DueDate between @P_SDate and @P_EDate
and Profile.ID Like @P_ID+'%'
and Not Exists (Select Top 1 CollectionV.Voucher from CollectionV, CollectionH Where CollectionH.CollNo=CollectionV.COllNo and CollectionH.CollStatus<>'C' and CollectionV.CollNo<>Voucher.CollNo and CollectionV.Voucher=Voucher.Voucher)   
and Not Exists (Select Top 1 SL.doc_no from SL_Request SL, Request R Where R.Status<>'C' and R.Voucher='' and R.Request=SL.Request and SL.doc_no=Voucher.Voucher)

)



GO
DROP function [dbo].[CL_A_COLLECT_PERIOD_DUE_ALL_ALL]
GO
Create function [dbo].[CL_A_COLLECT_PERIOD_DUE_ALL_ALL](@P_SDate as smalldatetime, @P_EDate as SmallDateTime, @P_ID as varchar(10))
RETURNS TABLE
AS RETURN
(
select distinct  Voucher.RefNo, Voucher.Voucher, Admlink.Type, Admlink.BatchNo, Admlink.Bank, Admlink.Date, Admlink.Subject, Voucher.DocNo, Voucher.StatID, Voucher.ActionBy, Voucher.ActionDate, Voucher.AcceptedBy, Voucher.AcceptedDate, 
Voucher.[Currency],  Voucher.Installment, Voucher.DueDate as DueDate, Voucher.AmountDue as Nominal,
Voucher.Remarks+Voucher.sInstallment as AName, Profile.Name, Voucher.debtorF,Voucher.CreditorF, Admlink.RefType, Admlink.A_PolicyNo, Voucher.Branch
from ProAcc,[Profile],Voucher_AmountPeriodDue(@P_SDate, @P_EDate) Voucher,AdmLink
where  Voucher.Voucher=AdmLink.Voucher 
and ProAcc.ProAcc=Voucher.ProAcc 
and ProAcc.[ID]=[Profile].[ID] 
and Admlink.Type in ('BB','BA','BO','BC','BP','BD','DI','IC','CF','JP','SO')   
and Admlink.ISType in ('I','L','C')
and ((Admlink.Type in ('BB','BA','BO','BC','BP','BD') and Admlink.ID=Admlink.Source) or (Admlink.Type not in ('BB','BA','BO','BC','BP','BD')))
and Admlink.ID  like @P_ID+'%'
and Voucher.AmountDue<>0  
)

GO

DROP function [dbo].[CL_C_COLLECT_ALL_ALL] 
GO
CREATE function [dbo].[CL_C_COLLECT_ALL_ALL] (@P_SDate as smalldatetime, @P_EDate as SmallDateTime, @P_ID as Varchar(255))  
RETURNS TABLE  
AS RETURN  
(  
select distinct  Voucher.RefNo, Voucher.Voucher, Admlink.Type, Admlink.BatchNo, Admlink.Bank, Admlink.Date, Admlink.Subject, Voucher.DocNo, Voucher.StatID, Voucher.ActionBy, Voucher.ActionDate, Voucher.AcceptedBy, Voucher.AcceptedDate,   
Voucher.[Currency],  Voucher.Installment, Voucher.DueDate as DueDate, Voucher.AmountDue-Voucher.Payment_CC-Voucher.Payment_OC as Nominal,  
Voucher.Remarks+Voucher.sInstallment as AName, Profile.Name, Voucher.debtorF,Voucher.CreditorF, Admlink.RefType, Admlink.A_PolicyNo, Voucher.Branch  
from ProAcc,[Profile],Voucher_AmountWPCDue(@P_EDate) Voucher,AdmLink  
where  Voucher.Voucher=AdmLink.Voucher   
and ProAcc.ProAcc=Voucher.ProAcc   
and ProAcc.[ID]=[Profile].[ID]   
and ((Admlink.Type in ('CP','DC','QS','QP','S1','S2','S3','AF','XP','FO','FP','FX','X1','X2','X3','X4','X5','X6','X7','X8','X9','XX')) or (Admlink.Type in ('OP') and Admlink.Amount_8+Admlink.Amount_10<>0))
and round(Voucher.AmountDue - (Voucher.Payment_CC+Voucher.Payment_OC),2)>0 and Voucher.DueDate between @P_SDate and @P_EDate    
and Admlink.Subject='Claim'  
and Profile.ID Like @P_ID+'%'  
and Not Exists (Select Top 1 CollectionV.Voucher from CollectionV, CollectionH Where CollectionH.CollNo=CollectionV.COllNo and CollectionH.CollStatus<>'C' and CollectionV.CollNo<>Voucher.CollNo and CollectionV.Voucher=Voucher.Voucher)   
and Not Exists (Select Top 1 SL.doc_no from SL_Request SL, Request R Where R.Status<>'C' and R.Voucher='' and R.Request=SL.Request and SL.doc_no=Voucher.Voucher)

)  
  
GO
DROP function [dbo].[CL_C_COLLECT_All_FACULTATIVE]
GO
CREATE function [dbo].[CL_C_COLLECT_All_FACULTATIVE] (@P_SDate as smalldatetime, @P_EDate as SmallDateTime, @P_ID as Varchar(255))
RETURNS TABLE
AS RETURN
(
select distinct  Voucher.RefNo, Voucher.Voucher, Admlink.Type, Admlink.BatchNo, Admlink.Bank, Admlink.Date, Admlink.Subject, Voucher.DocNo, Voucher.StatID, Voucher.ActionBy, Voucher.ActionDate, Voucher.AcceptedBy, Voucher.AcceptedDate, 
Voucher.[Currency],  Voucher.Installment, Voucher.DueDate as DueDate, Voucher.AmountDue-Voucher.Payment_CC-Voucher.Payment_OC as Nominal,
Voucher.Remarks+Voucher.sInstallment as AName, Profile.Name, Voucher.debtorF,Voucher.CreditorF, Admlink.RefType, Admlink.A_PolicyNo, Voucher.Branch
from ProAcc,[Profile],Voucher_AmountWPCDue(@P_EDate) Voucher,AdmLink
where  Voucher.Voucher=AdmLink.Voucher 
and ProAcc.ProAcc=Voucher.ProAcc 
and ProAcc.[ID]=[Profile].[ID] 
and Admlink.Type in ('FO','FP','FX')
and round(Voucher.AmountDue - (Voucher.Payment_CC+Voucher.Payment_OC),2)>0 and Voucher.DueDate between @P_SDate and @P_EDate
and Admlink.Subject='Claim'
and Profile.ID Like @P_ID+'%'
and Not Exists (Select Top 1 CollectionV.Voucher from CollectionV, CollectionH Where CollectionH.CollNo=CollectionV.COllNo and CollectionH.CollStatus<>'C' and CollectionV.CollNo<>Voucher.CollNo and CollectionV.Voucher=Voucher.Voucher)   
and Not Exists (Select Top 1 SL.doc_no from SL_Request SL, Request R Where R.Status<>'C' and R.Voucher='' and R.Request=SL.Request and SL.doc_no=Voucher.Voucher)
)
GO
DROP function [dbo].[CL_C_COLLECT_All_FACULTATIVE_PROP]
GO
CREATE function [dbo].[CL_C_COLLECT_All_FACULTATIVE_PROP] (@P_SDate as smalldatetime, @P_EDate as SmallDateTime, @P_ID as Varchar(255))
RETURNS TABLE
AS RETURN
(
select distinct  Voucher.RefNo, Voucher.Voucher, Admlink.Type, Admlink.BatchNo, Admlink.Bank, Admlink.Date, Admlink.Subject, Voucher.DocNo, Voucher.StatID, Voucher.ActionBy, Voucher.ActionDate, Voucher.AcceptedBy, Voucher.AcceptedDate, 
Voucher.[Currency],  Voucher.Installment, Voucher.DueDate as DueDate, Voucher.AmountDue-Voucher.Payment_CC-Voucher.Payment_OC as Nominal,
Voucher.Remarks+Voucher.sInstallment as AName, Profile.Name, Voucher.debtorF,Voucher.CreditorF, Admlink.RefType, Admlink.A_PolicyNo, Voucher.Branch
from ProAcc,[Profile],Voucher_AmountWPCDue(@P_EDate) Voucher,AdmLink
where  Voucher.Voucher=AdmLink.Voucher 
and ProAcc.ProAcc=Voucher.ProAcc 
and ProAcc.[ID]=[Profile].[ID] 
and Admlink.Type in ('FO','FP')
and round(Voucher.AmountDue - (Voucher.Payment_CC+Voucher.Payment_OC),2)>0 and Voucher.DueDate between @P_SDate and @P_EDate
and Admlink.Subject='Claim'
and Profile.ID Like @P_ID+'%'
and Not Exists (Select Top 1 CollectionV.Voucher from CollectionV, CollectionH Where CollectionH.CollNo=CollectionV.COllNo and CollectionH.CollStatus<>'C' and CollectionV.CollNo<>Voucher.CollNo and CollectionV.Voucher=Voucher.Voucher)   
and Not Exists (Select Top 1 SL.doc_no from SL_Request SL, Request R Where R.Status<>'C' and R.Voucher='' and R.Request=SL.Request and SL.doc_no=Voucher.Voucher)
)
GO
DROP function [dbo].[CL_C_COLLECT_ALL_FACULTATIVE_NONPROP] 

GO

CREATE function [dbo].[CL_C_COLLECT_ALL_FACULTATIVE_NONPROP] (@P_SDate as smalldatetime, @P_EDate as SmallDateTime, @P_ID as Varchar(255))
RETURNS TABLE
AS RETURN
(
select distinct  Voucher.RefNo, Voucher.Voucher, Admlink.Type, Admlink.BatchNo, Admlink.Bank, Admlink.Date, Admlink.Subject, Voucher.DocNo, Voucher.StatID, Voucher.ActionBy, Voucher.ActionDate, Voucher.AcceptedBy, Voucher.AcceptedDate, 
Voucher.[Currency],  Voucher.Installment, Voucher.DueDate as DueDate, Voucher.AmountDue-Voucher.Payment_CC-Voucher.Payment_OC as Nominal,
Voucher.Remarks+Voucher.sInstallment as AName, Profile.Name, Voucher.debtorF,Voucher.CreditorF, Admlink.RefType, Admlink.A_PolicyNo, Voucher.Branch
from ProAcc,[Profile],Voucher_AmountWPCDue(@P_EDate) Voucher,AdmLink
where  Voucher.Voucher=AdmLink.Voucher 
and ProAcc.ProAcc=Voucher.ProAcc 
and ProAcc.[ID]=[Profile].[ID] 
and Admlink.Type in ('FX')
and round(Voucher.AmountDue - (Voucher.Payment_CC+Voucher.Payment_OC),2)>0 and Voucher.DueDate between @P_SDate and @P_EDate

and Admlink.Subject='Claim'
and Profile.ID Like @P_ID+'%'
and Not Exists (Select Top 1 CollectionV.Voucher from CollectionV, CollectionH Where CollectionH.CollNo=CollectionV.COllNo and CollectionH.CollStatus<>'C' and CollectionV.CollNo<>Voucher.CollNo and CollectionV.Voucher=Voucher.Voucher)   
and Not Exists (Select Top 1 SL.doc_no from SL_Request SL, Request R Where R.Status<>'C' and R.Voucher='' and R.Request=SL.Request and SL.doc_no=Voucher.Voucher)

)

GO


DROP function [dbo].[CL_C_COLLECT_ALL_TREATY]
GO
CREATE function [dbo].[CL_C_COLLECT_ALL_TREATY] (@P_SDate as smalldatetime, @P_EDate as SmallDateTime, @P_ID as Varchar(255))
RETURNS TABLE
AS RETURN
(
select distinct  Voucher.RefNo, Voucher.Voucher, Admlink.Type, Admlink.BatchNo, Admlink.Bank, Admlink.Date, Admlink.Subject, Voucher.DocNo, Voucher.StatID, Voucher.ActionBy, Voucher.ActionDate, Voucher.AcceptedBy, Voucher.AcceptedDate, 
Voucher.[Currency],  Voucher.Installment, Voucher.DueDate as DueDate, Voucher.AmountDue-Voucher.Payment_CC-Voucher.Payment_OC as Nominal,
Voucher.Remarks+Voucher.sInstallment as AName, Profile.Name, Voucher.debtorF,Voucher.CreditorF, Admlink.RefType, Admlink.A_PolicyNo, Voucher.Branch
from ProAcc,[Profile],Voucher_AmountWPCDue(@P_EDate) Voucher,AdmLink
where  Voucher.Voucher=AdmLink.Voucher 
and ProAcc.ProAcc=Voucher.ProAcc 
and ProAcc.[ID]=[Profile].[ID] 
and Admlink.Type in ('QS','QP','S1','S2','S3')
and round(Voucher.AmountDue - (Voucher.Payment_CC+Voucher.Payment_OC),2)>0 and Voucher.DueDate between @P_SDate and @P_EDate
and Admlink.Subject='Claim'
and Profile.ID Like @P_ID+'%'
and Not Exists (Select Top 1 CollectionV.Voucher from CollectionV, CollectionH Where CollectionH.CollNo=CollectionV.COllNo and CollectionH.CollStatus<>'C' and CollectionV.CollNo<>Voucher.CollNo and CollectionV.Voucher=Voucher.Voucher)   
and Not Exists (Select Top 1 SL.doc_no from SL_Request SL, Request R Where R.Status<>'C' and R.Voucher='' and R.Request=SL.Request and SL.doc_no=Voucher.Voucher)

)

GO
DROP function [dbo].[CL_C_COLLECT_All_CONSORTIUM]
GO
CREATE function [dbo].[CL_C_COLLECT_All_CONSORTIUM] (@P_SDate as smalldatetime, @P_EDate as SmallDateTime, @P_ID as Varchar(255))
RETURNS TABLE
AS RETURN
(
select distinct  Voucher.RefNo, Voucher.Voucher, Admlink.Type, Admlink.BatchNo, Admlink.Bank, Admlink.Date, Admlink.Subject, Voucher.DocNo, Voucher.StatID, Voucher.ActionBy, Voucher.ActionDate, Voucher.AcceptedBy, Voucher.AcceptedDate, 
Voucher.[Currency],  Voucher.Installment, Voucher.DueDate as DueDate, Voucher.AmountDue-Voucher.Payment_CC-Voucher.Payment_OC as Nominal,
Voucher.Remarks+Voucher.sInstallment as AName, Profile.Name, Voucher.debtorF,Voucher.CreditorF, Admlink.RefType, Admlink.A_PolicyNo, Voucher.Branch
from ProAcc,[Profile],Voucher_AmountWPCDue(@P_EDate) Voucher,AdmLink
where  Voucher.Voucher=AdmLink.Voucher 
and ProAcc.ProAcc=Voucher.ProAcc 
and ProAcc.[ID]=[Profile].[ID] 
and Admlink.Type in ('DC')
and round(Voucher.AmountDue - (Voucher.Payment_CC+Voucher.Payment_OC),2)>0 and Voucher.DueDate between @P_SDate and @P_EDate
and Admlink.Subject='Claim'
and Profile.ID Like @P_ID+'%'
and Not Exists (Select Top 1 CollectionV.Voucher from CollectionV, CollectionH Where CollectionH.CollNo=CollectionV.COllNo and CollectionH.CollStatus<>'C' and CollectionV.CollNo<>Voucher.CollNo and CollectionV.Voucher=Voucher.Voucher)   
and Not Exists (Select Top 1 SL.doc_no from SL_Request SL, Request R Where R.Status<>'C' and R.Voucher='' and R.Request=SL.Request and SL.doc_no=Voucher.Voucher)
)
GO
DROP function [dbo].[CL_C_COLLECT_All_QUOTASHARE]
GO
CREATE function [dbo].[CL_C_COLLECT_All_QUOTASHARE] (@P_SDate as smalldatetime, @P_EDate as SmallDateTime, @P_ID as Varchar(255))
RETURNS TABLE
AS RETURN
(
select distinct  Voucher.RefNo, Voucher.Voucher, Admlink.Type, Admlink.BatchNo, Admlink.Bank, Admlink.Date, Admlink.Subject, Voucher.DocNo, Voucher.StatID, Voucher.ActionBy, Voucher.ActionDate, Voucher.AcceptedBy, Voucher.AcceptedDate, 
Voucher.[Currency],  Voucher.Installment, Voucher.DueDate as DueDate, Voucher.AmountDue-Voucher.Payment_CC-Voucher.Payment_OC as Nominal,
Voucher.Remarks+Voucher.sInstallment as AName, Profile.Name, Voucher.debtorF,Voucher.CreditorF, Admlink.RefType, Admlink.A_PolicyNo, Voucher.Branch
from ProAcc,[Profile],Voucher_AmountWPCDue(@P_EDate) Voucher,AdmLink
where  Voucher.Voucher=AdmLink.Voucher 
and ProAcc.ProAcc=Voucher.ProAcc 
and ProAcc.[ID]=[Profile].[ID] 
and Admlink.Type in ('QS','QP')
and round(Voucher.AmountDue - (Voucher.Payment_CC+Voucher.Payment_OC),2)>0 and Voucher.DueDate between @P_SDate and @P_EDate
and Admlink.Subject='Claim'
and Profile.ID Like @P_ID+'%'
and Not Exists (Select Top 1 CollectionV.Voucher from CollectionV, CollectionH Where CollectionH.CollNo=CollectionV.COllNo and CollectionH.CollStatus<>'C' and CollectionV.CollNo<>Voucher.CollNo and CollectionV.Voucher=Voucher.Voucher)   
and Not Exists (Select Top 1 SL.doc_no from SL_Request SL, Request R Where R.Status<>'C' and R.Voucher='' and R.Request=SL.Request and SL.doc_no=Voucher.Voucher)
)

GO

DROP function [dbo].[CL_C_COLLECT_All_SURPLUS]
GO
CREATE function [dbo].[CL_C_COLLECT_All_SURPLUS] (@P_SDate as smalldatetime, @P_EDate as SmallDateTime, @P_ID as Varchar(255))
RETURNS TABLE
AS RETURN
(
select distinct  Voucher.RefNo, Voucher.Voucher, Admlink.Type, Admlink.BatchNo, Admlink.Bank, Admlink.Date, Admlink.Subject, Voucher.DocNo, Voucher.StatID, Voucher.ActionBy, Voucher.ActionDate, Voucher.AcceptedBy, Voucher.AcceptedDate, 
Voucher.[Currency],  Voucher.Installment, Voucher.DueDate as DueDate, Voucher.AmountDue-Voucher.Payment_CC-Voucher.Payment_OC as Nominal,
Voucher.Remarks+Voucher.sInstallment as AName, Profile.Name, Voucher.debtorF,Voucher.CreditorF, Admlink.RefType, Admlink.A_PolicyNo, Voucher.Branch
from ProAcc,[Profile],Voucher_AmountWPCDue(@P_EDate) Voucher,AdmLink
where  Voucher.Voucher=AdmLink.Voucher 
and ProAcc.ProAcc=Voucher.ProAcc 
and ProAcc.[ID]=[Profile].[ID] 
and Admlink.Type in ('S1','S2','S3')
and round(Voucher.AmountDue - (Voucher.Payment_CC+Voucher.Payment_OC),2)>0 and Voucher.DueDate between @P_SDate and @P_EDate
and Admlink.Subject='Claim'
and Profile.ID Like @P_ID+'%'
and Not Exists (Select Top 1 CollectionV.Voucher from CollectionV, CollectionH Where CollectionH.CollNo=CollectionV.COllNo and CollectionH.CollStatus<>'C' and CollectionV.CollNo<>Voucher.CollNo and CollectionV.Voucher=Voucher.Voucher)   
and Not Exists (Select Top 1 SL.doc_no from SL_Request SL, Request R Where R.Status<>'C' and R.Voucher='' and R.Request=SL.Request and SL.doc_no=Voucher.Voucher)
)
GO
DROP function [dbo].[CL_C_COLLECT_All_AUTOFACULTATIVE]
GO
CREATE function [dbo].[CL_C_COLLECT_All_AUTOFACULTATIVE] (@P_SDate as smalldatetime, @P_EDate as SmallDateTime, @P_ID as Varchar(255))
RETURNS TABLE
AS RETURN
(
select distinct  Voucher.RefNo, Voucher.Voucher, Admlink.Type, Admlink.BatchNo, Admlink.Bank, Admlink.Date, Admlink.Subject, Voucher.DocNo, Voucher.StatID, Voucher.ActionBy, Voucher.ActionDate, Voucher.AcceptedBy, Voucher.AcceptedDate, 
Voucher.[Currency],  Voucher.Installment, Voucher.DueDate as DueDate, Voucher.AmountDue-Voucher.Payment_CC-Voucher.Payment_OC as Nominal,
Voucher.Remarks+Voucher.sInstallment as AName, Profile.Name, Voucher.debtorF,Voucher.CreditorF, Admlink.RefType, Admlink.A_PolicyNo, Voucher.Branch
from ProAcc,[Profile],Voucher_AmountWPCDue(@P_EDate) Voucher,AdmLink
where  Voucher.Voucher=AdmLink.Voucher 
and ProAcc.ProAcc=Voucher.ProAcc 
and ProAcc.[ID]=[Profile].[ID] 
and Admlink.Type in ('AF')
and round(Voucher.AmountDue - (Voucher.Payment_CC+Voucher.Payment_OC),2)>0 and Voucher.DueDate between @P_SDate and @P_EDate
and Admlink.Subject='Claim'
and Profile.ID Like @P_ID+'%'
and Not Exists (Select Top 1 CollectionV.Voucher from CollectionV, CollectionH Where CollectionH.CollNo=CollectionV.COllNo and CollectionH.CollStatus<>'C' and CollectionV.CollNo<>Voucher.CollNo and CollectionV.Voucher=Voucher.Voucher)   
and Not Exists (Select Top 1 SL.doc_no from SL_Request SL, Request R Where R.Status<>'C' and R.Voucher='' and R.Request=SL.Request and SL.doc_no=Voucher.Voucher)
)
GO

DROP function [dbo].[CL_C_COLLECT_All_TREATY_STOPLOSS]
GO
CREATE function [dbo].[CL_C_COLLECT_All_TREATY_STOPLOSS] (@P_SDate as smalldatetime, @P_EDate as SmallDateTime, @P_ID as Varchar(255))
RETURNS TABLE
AS RETURN
(
select distinct  Voucher.RefNo, Voucher.Voucher, Admlink.Type, Admlink.BatchNo, Admlink.Bank, Admlink.Date, Admlink.Subject, Voucher.DocNo, Voucher.StatID, Voucher.ActionBy, Voucher.ActionDate, Voucher.AcceptedBy, Voucher.AcceptedDate, 
Voucher.[Currency],  Voucher.Installment, Voucher.DueDate as DueDate, Voucher.AmountDue-Voucher.Payment_CC-Voucher.Payment_OC as Nominal,
Voucher.Remarks+Voucher.sInstallment as AName, Profile.Name, Voucher.debtorF,Voucher.CreditorF, Admlink.RefType, Admlink.A_PolicyNo, Voucher.Branch
from ProAcc,[Profile],Voucher_AmountWPCDue(@P_EDate) Voucher,AdmLink
where  Voucher.Voucher=AdmLink.Voucher 
and ProAcc.ProAcc=Voucher.ProAcc 
and ProAcc.[ID]=[Profile].[ID] 
and Admlink.Type in ('XX')
and round(Voucher.AmountDue - (Voucher.Payment_CC+Voucher.Payment_OC),2)>0 and Voucher.DueDate between @P_SDate and @P_EDate
and Admlink.Subject='Claim'
and Profile.ID Like @P_ID+'%'
and Not Exists (Select Top 1 CollectionV.Voucher from CollectionV, CollectionH Where CollectionH.CollNo=CollectionV.COllNo and CollectionH.CollStatus<>'C' and CollectionV.CollNo<>Voucher.CollNo and CollectionV.Voucher=Voucher.Voucher)   
and Not Exists (Select Top 1 SL.doc_no from SL_Request SL, Request R Where R.Status<>'C' and R.Voucher='' and R.Request=SL.Request and SL.doc_no=Voucher.Voucher)
)
GO


DROP function [dbo].[CL_C_COLLECT_ALL_TREATY_XOL]
GO
CREATE function [dbo].[CL_C_COLLECT_ALL_TREATY_XOL] (@P_SDate as smalldatetime, @P_EDate as SmallDateTime, @P_ID as Varchar(255))
RETURNS TABLE
AS RETURN
(
select distinct  Voucher.RefNo, Voucher.Voucher, Admlink.Type, Admlink.BatchNo, Admlink.Bank, Admlink.Date, Admlink.Subject, Voucher.DocNo, Voucher.StatID, Voucher.ActionBy, Voucher.ActionDate, Voucher.AcceptedBy, Voucher.AcceptedDate, 
Voucher.[Currency],  Voucher.Installment, Voucher.DueDate as DueDate, Voucher.AmountDue-Voucher.Payment_CC-Voucher.Payment_OC as Nominal,
Voucher.Remarks+Voucher.sInstallment as AName, Profile.Name, Voucher.debtorF,Voucher.CreditorF, Admlink.RefType, Admlink.A_PolicyNo, Voucher.Branch
from ProAcc,[Profile],Voucher_AmountWPCDue(@P_EDate) Voucher,AdmLink
where  Voucher.Voucher=AdmLink.Voucher 
and ProAcc.ProAcc=Voucher.ProAcc 
and ProAcc.[ID]=[Profile].[ID] 
and Admlink.Type in ('X1','X2','X3','X4','X5','X6','X7','X8','X9')
and round(Voucher.AmountDue - (Voucher.Payment_CC+Voucher.Payment_OC),2)>0 and Voucher.DueDate between @P_SDate and @P_EDate
and Admlink.Subject='Claim'
and Profile.ID Like @P_ID+'%'
and Not Exists (Select Top 1 CollectionV.Voucher from CollectionV, CollectionH Where CollectionH.CollNo=CollectionV.COllNo and CollectionH.CollStatus<>'C' and CollectionV.CollNo<>Voucher.CollNo and CollectionV.Voucher=Voucher.Voucher)   
and Not Exists (Select Top 1 SL.doc_no from SL_Request SL, Request R Where R.Status<>'C' and R.Voucher='' and R.Request=SL.Request and SL.doc_no=Voucher.Voucher)

)

GO


DROP FUNCTION [dbo].[DB_R_DISBURSE_ALL_ALL_ALL] 
GO
CREATE FUNCTION [dbo].[DB_R_DISBURSE_ALL_ALL_ALL] (@P_SDate as smalldatetime, @P_EDate as SmallDateTime)  
RETURNS TABLE  
AS RETURN  
(  
select distinct Admlink.RefNo, Voucher.Voucher, Admlink.Type, Admlink.BatchNo, Admlink.Bank, Admlink.Date, Admlink.Subject, Admlink.Extra_3,Voucher.DocNo, Voucher.StatID, Voucher.ActionBy, Voucher.ActionDate, Voucher.AcceptedBy, Voucher.AcceptedDate,   
Voucher.[Currency],  Voucher.Installment, Voucher.DueDate as DueDate, Voucher.AmountDue-Voucher.Payment_CC-Voucher.Payment_OC as Nominal,  
Case When Reinsurance.DocNo is null Then Voucher.Remarks else Reinsurance.Description end +Voucher.sInstallment as AName, Profile.Name, Voucher.debtorF,Voucher.CreditorF, Admlink.RefType,Voucher.Branch, Admlink.A_PolicyNo, Admlink.EXTRA_4, Admlink.ISType
from ProAcc,[Profile],Voucher_AmountWPCDue(@P_EDate) Voucher,AdmLink Left Join Reinsurance On (Reinsurance.DocNo=Admlink.RefNo)
where  Voucher.Voucher=AdmLink.Voucher   
and ProAcc.ProAcc=Voucher.ProAcc   
and ProAcc.[ID]=[Profile].[ID]   
and Admlink.Type in ('PI','FO','FP','FX','QS','QP','S1','S2','S3','CP','XP','AF','DC','X1','X2','X3','X4','X5','X6','X7','X8','X9','XX','RP','AP','IR','IT','IX')  
and round(Voucher.AmountDue - (Voucher.Payment_CC+Voucher.Payment_OC),2)>0 and Voucher.DueDate between @P_SDate and @P_EDate  
  
and Not Exists (Select Top 1 CollectionV.Voucher from CollectionV, CollectionH Where CollectionH.CollNo=CollectionV.COllNo and CollectionH.CollStatus<>'C' and CollectionV.CollNo<>Voucher.CollNo and CollectionV.Voucher=Voucher.Voucher)   
and Not Exists (Select Top 1 SL.doc_no from SL_Request SL, Request R Where R.Status<>'C' and R.Voucher='' and R.Request=SL.Request and SL.doc_no=Voucher.Voucher)

)  

GO
DROP FUNCTION [dbo].[DB_R_DISBURSE_ALL_PREMIUM_ALL] 
GO
CREATE FUNCTION [dbo].[DB_R_DISBURSE_ALL_PREMIUM_ALL] (@P_SDate as smalldatetime, @P_EDate as SmallDateTime)  
RETURNS TABLE  
AS RETURN  
(  
select distinct Admlink.RefNo, Voucher.Voucher, Admlink.Type, Admlink.BatchNo, Admlink.Bank, Admlink.Date, Admlink.Subject, Admlink.Extra_3,Voucher.DocNo, Voucher.StatID, Voucher.ActionBy, Voucher.ActionDate, Voucher.AcceptedBy, Voucher.AcceptedDate,   
Voucher.[Currency],  Voucher.Installment, Voucher.DueDate as DueDate, Voucher.AmountDue-Voucher.Payment_CC-Voucher.Payment_OC as Nominal,  
Case When Reinsurance.DocNo is null Then Voucher.Remarks else Reinsurance.Description end +Voucher.sInstallment as AName, Profile.Name, Voucher.debtorF,Voucher.CreditorF, Admlink.RefType,Voucher.Branch, Admlink.A_PolicyNo, Admlink.EXTRA_4, Admlink.ISType
from ProAcc,[Profile],Voucher_AmountWPCDue(@P_EDate) Voucher,AdmLink Left Join Reinsurance On (Reinsurance.DocNo=Admlink.RefNo)
where  Voucher.Voucher=AdmLink.Voucher   
and ProAcc.ProAcc=Voucher.ProAcc   
and ProAcc.[ID]=[Profile].[ID]   
and Admlink.Type in ('PI','FO','FP','FX','QS','QP','S1','S2','S3','CP','XP','AF','DC','X1','X2','X3','X4','X5','X6','X7','X8','X9','XX','RP','AP','IR','IT','IX')  
and Upper(AdmLink.Subject)='PREMIUM'
and round(Voucher.AmountDue - (Voucher.Payment_CC+Voucher.Payment_OC),2)>0 and Voucher.DueDate between @P_SDate and @P_EDate  
  
and Not Exists (Select Top 1 CollectionV.Voucher from CollectionV, CollectionH Where CollectionH.CollNo=CollectionV.COllNo and CollectionH.CollStatus<>'C' and CollectionV.CollNo<>Voucher.CollNo and CollectionV.Voucher=Voucher.Voucher)   
and Not Exists (Select Top 1 SL.doc_no from SL_Request SL, Request R Where R.Status<>'C' and R.Voucher='' and R.Request=SL.Request and SL.doc_no=Voucher.Voucher)

)  

GO  
DROP FUNCTION [dbo].[DB_R_DISBURSE_ALL_CLAIM_ALL] 
GO
CREATE FUNCTION [dbo].[DB_R_DISBURSE_ALL_CLAIM_ALL] (@P_SDate as smalldatetime, @P_EDate as SmallDateTime)  
RETURNS TABLE  
AS RETURN  
(  
select distinct Admlink.RefNo, Voucher.Voucher, Admlink.Type, Admlink.BatchNo, Admlink.Bank, Admlink.Date, Admlink.Subject, Admlink.Extra_3,Voucher.DocNo, Voucher.StatID, Voucher.ActionBy, Voucher.ActionDate, Voucher.AcceptedBy, Voucher.AcceptedDate,   
Voucher.[Currency],  Voucher.Installment, Voucher.DueDate as DueDate, Voucher.AmountDue-Voucher.Payment_CC-Voucher.Payment_OC as Nominal,  
Case When Reinsurance.DocNo is null Then Voucher.Remarks else Reinsurance.Description end +Voucher.sInstallment as AName, Profile.Name, Voucher.debtorF,Voucher.CreditorF, Admlink.RefType,Voucher.Branch, Admlink.A_PolicyNo, Admlink.EXTRA_4, Admlink.ISType
from ProAcc,[Profile],Voucher_AmountWPCDue(@P_EDate) Voucher,AdmLink Left Join Reinsurance On (Reinsurance.DocNo=Admlink.RefNo)
where  Voucher.Voucher=AdmLink.Voucher   
and ProAcc.ProAcc=Voucher.ProAcc   
and ProAcc.[ID]=[Profile].[ID]   
and Admlink.Type in ('PI','FO','FP','FX','QS','QP','S1','S2','S3','CP','XP','AF','DC','X1','X2','X3','X4','X5','X6','X7','X8','X9','XX','RP','AP','IR','IT','IX')  
and Upper(AdmLink.Subject)='CLAIM'
and round(Voucher.AmountDue - (Voucher.Payment_CC+Voucher.Payment_OC),2)>0 and Voucher.DueDate between @P_SDate and @P_EDate  
  
and Not Exists (Select Top 1 CollectionV.Voucher from CollectionV, CollectionH Where CollectionH.CollNo=CollectionV.COllNo and CollectionH.CollStatus<>'C' and CollectionV.CollNo<>Voucher.CollNo and CollectionV.Voucher=Voucher.Voucher)   
and Not Exists (Select Top 1 SL.doc_no from SL_Request SL, Request R Where R.Status<>'C' and R.Voucher='' and R.Request=SL.Request and SL.doc_no=Voucher.Voucher)

)  

GO
DROP function [dbo].[DB_R_DISBURSE_PERIOD_DUE_ALL_ALL]
GO
CREATE function [dbo].[DB_R_DISBURSE_PERIOD_DUE_ALL_ALL](@P_SDate as smalldatetime, @P_EDate as SmallDateTime)  
RETURNS TABLE  
AS RETURN  
(  
select distinct Admlink.RefNo, Voucher.Voucher, Admlink.Type, Admlink.BatchNo, Admlink.Bank, Admlink.Date, Admlink.Subject, Admlink.Extra_3,Voucher.DocNo, Voucher.StatID, Voucher.ActionBy, Voucher.ActionDate, Voucher.AcceptedBy, Voucher.AcceptedDate,   
Voucher.[Currency],  Voucher.Installment, Voucher.DueDate as DueDate, Voucher.AmountDue-Voucher.Payment_CC-Voucher.Payment_OC as Nominal,  
Case When Reinsurance.DocNo is null Then Voucher.Remarks else Reinsurance.Description end +Voucher.sInstallment as AName, Profile.Name, Voucher.debtorF,Voucher.CreditorF, Admlink.RefType,Voucher.Branch, Admlink.A_PolicyNo, Admlink.EXTRA_4, Admlink.ISType
from ProAcc,[Profile],Voucher_AmountPeriodDue(@P_SDate, @P_EDate) Voucher,AdmLink Left Join Reinsurance On (Reinsurance.DocNo=Admlink.RefNo)
where  Voucher.Voucher=AdmLink.Voucher   
and ProAcc.ProAcc=Voucher.ProAcc   
and ProAcc.[ID]=[Profile].[ID]   
and Admlink.Type in ('PI','FO','FP','FX','QS','QP','S1','S2','S3','CP','XP','AF','DC','X1','X2','X3','X4','X5','X6','X7','X8','X9','XX','RP','AP','IR','IT','IX')  
  
and Voucher.AmountDue<>0
)  
GO

DROP function [dbo].[DB_R_DISBURSE_PERIOD_DUE_PREMIUM_ALL]
GO
CREATE function [dbo].[DB_R_DISBURSE_PERIOD_DUE_PREMIUM_ALL](@P_SDate as smalldatetime, @P_EDate as SmallDateTime)  
RETURNS TABLE  
AS RETURN  
(  
select distinct Admlink.RefNo, Voucher.Voucher, Admlink.Type, Admlink.BatchNo, Admlink.Bank, Admlink.Date, Admlink.Subject, Admlink.Extra_3,Voucher.DocNo, Voucher.StatID, Voucher.ActionBy, Voucher.ActionDate, Voucher.AcceptedBy, Voucher.AcceptedDate,   
Voucher.[Currency],  Voucher.Installment, Voucher.DueDate as DueDate, Voucher.AmountDue-Voucher.Payment_CC-Voucher.Payment_OC as Nominal,  
Case When Reinsurance.DocNo is null Then Voucher.Remarks else Reinsurance.Description end +Voucher.sInstallment as AName, Profile.Name, Voucher.debtorF,Voucher.CreditorF, Admlink.RefType,Voucher.Branch, Admlink.A_PolicyNo, Admlink.EXTRA_4, Admlink.ISType
from ProAcc,[Profile],Voucher_AmountPeriodDue(@P_SDate, @P_EDate) Voucher,AdmLink Left Join Reinsurance On (Reinsurance.DocNo=Admlink.RefNo)
where  Voucher.Voucher=AdmLink.Voucher   
and ProAcc.ProAcc=Voucher.ProAcc   
and ProAcc.[ID]=[Profile].[ID]   
and Admlink.Type in ('PI','FO','FP','FX','QS','QP','S1','S2','S3','CP','XP','AF','DC','X1','X2','X3','X4','X5','X6','X7','X8','X9','XX','RP','AP','IR','IT','IX')  
  
and Voucher.AmountDue<>0
and Upper(AdmLink.Subject)='PREMIUM'
)  

GO  
DROP function [dbo].[DB_R_DISBURSE_PERIOD_DUE_CLAIM_ALL]
GO
CREATE function [dbo].[DB_R_DISBURSE_PERIOD_DUE_CLAIM_ALL](@P_SDate as smalldatetime, @P_EDate as SmallDateTime)  
RETURNS TABLE  
AS RETURN  
(  
select distinct Admlink.RefNo, Voucher.Voucher, Admlink.Type, Admlink.BatchNo, Admlink.Bank, Admlink.Date, Admlink.Subject, Admlink.Extra_3,Voucher.DocNo, Voucher.StatID, Voucher.ActionBy, Voucher.ActionDate, Voucher.AcceptedBy, Voucher.AcceptedDate,   
Voucher.[Currency],  Voucher.Installment, Voucher.DueDate as DueDate, Voucher.AmountDue-Voucher.Payment_CC-Voucher.Payment_OC as Nominal,  
Case When Reinsurance.DocNo is null Then Voucher.Remarks else Reinsurance.Description end +Voucher.sInstallment as AName, Profile.Name, Voucher.debtorF,Voucher.CreditorF, Admlink.RefType,Voucher.Branch, Admlink.A_PolicyNo, Admlink.EXTRA_4, Admlink.ISType
from ProAcc,[Profile],Voucher_AmountPeriodDue(@P_SDate, @P_EDate) Voucher,AdmLink Left Join Reinsurance On (Reinsurance.DocNo=Admlink.RefNo)
where  Voucher.Voucher=AdmLink.Voucher   
and ProAcc.ProAcc=Voucher.ProAcc   
and ProAcc.[ID]=[Profile].[ID]   
and Admlink.Type in ('PI','FO','FP','FX','QS','QP','S1','S2','S3','CP','XP','AF','DC','X1','X2','X3','X4','X5','X6','X7','X8','X9','XX','RP','AP','IR','IT','IX')  
  
and Voucher.AmountDue<>0
and Upper(AdmLink.Subject)='CLAIM'
)  

GO  
DROP function [dbo].[DB_R_DISBURSE_UNPAID_ALL_ALL]
GO
CREATE function [dbo].[DB_R_DISBURSE_UNPAID_ALL_ALL](@P_SDate as smalldatetime, @P_EDate as SmallDateTime)  
RETURNS TABLE  
AS RETURN  
(  
select distinct Admlink.RefNo, Voucher.Voucher, Admlink.Type, Admlink.BatchNo, Admlink.Bank, Admlink.Date, Admlink.Subject, Admlink.Extra_3,Voucher.DocNo, Voucher.StatID, Voucher.ActionBy, Voucher.ActionDate, Voucher.AcceptedBy, Voucher.AcceptedDate,   
Voucher.[Currency],  Voucher.Installment, Voucher.DueDate as DueDate, Voucher.AmountDue-Voucher.Payment_CC-Voucher.Payment_OC as Nominal,  
Case When Reinsurance.DocNo is null Then Voucher.Remarks else Reinsurance.Description end +Voucher.sInstallment as AName, Profile.Name, Voucher.debtorF,Voucher.CreditorF, Admlink.RefType,Voucher.Branch, Admlink.A_PolicyNo, Admlink.EXTRA_4, Admlink.ISType
from ProAcc,[Profile],Voucher_AmountWPCDue(@P_EDate) Voucher,AdmLink Left Join Reinsurance On (Reinsurance.DocNo=Admlink.RefNo)
where  Voucher.Voucher=AdmLink.Voucher   
and ProAcc.ProAcc=Voucher.ProAcc   
and ProAcc.[ID]=[Profile].[ID]   
and Admlink.Type in ('PI','FO','FP','FX','QS','QP','S1','S2','S3','CP','XP','AF','DC','X1','X2','X3','X4','X5','X6','X7','X8','X9','XX','RP','AP','IR','IT','IX')  
and round(Voucher.AmountDue - (Voucher.Payment_CC+Voucher.Payment_OC),2)>0 and Voucher.DueDate between @P_SDate and @P_EDate  
  
and Voucher.Voucher in (Select CollectionV.Voucher from CollectionV, CollectionH Where CollectionH.CollNo=CollectionV.CollNo and CollectionH.CollStatus='C' and CollectionV.Paid=0 and CollectionV.Voucher=Voucher.Voucher)  
and Not Exists (Select Top 1 CollectionV.Voucher from CollectionV, CollectionH Where CollectionH.CollNo=CollectionV.COllNo and CollectionH.CollStatus<>'C' and CollectionV.CollNo<>Voucher.CollNo and CollectionV.Voucher=Voucher.Voucher)   
and Not Exists (Select Top 1 SL.doc_no from SL_Request SL, Request R Where R.Status<>'C' and R.Voucher='' and R.Request=SL.Request and SL.doc_no=Voucher.Voucher)

  
)  
  
GO
DROP function [dbo].[DB_R_DISBURSE_UNPAID_PREMIUM_ALL]
GO
CREATE function [dbo].[DB_R_DISBURSE_UNPAID_PREMIUM_ALL](@P_SDate as smalldatetime, @P_EDate as SmallDateTime)  
RETURNS TABLE  
AS RETURN  
(  
select distinct Admlink.RefNo, Voucher.Voucher, Admlink.Type, Admlink.BatchNo, Admlink.Bank, Admlink.Date, Admlink.Subject, Admlink.Extra_3,Voucher.DocNo, Voucher.StatID, Voucher.ActionBy, Voucher.ActionDate, Voucher.AcceptedBy, Voucher.AcceptedDate,   
Voucher.[Currency],  Voucher.Installment, Voucher.DueDate as DueDate, Voucher.AmountDue-Voucher.Payment_CC-Voucher.Payment_OC as Nominal,  
Case When Reinsurance.DocNo is null Then Voucher.Remarks else Reinsurance.Description end +Voucher.sInstallment as AName, Profile.Name, Voucher.debtorF,Voucher.CreditorF, Admlink.RefType,Voucher.Branch, Admlink.A_PolicyNo, Admlink.EXTRA_4, Admlink.ISType
from ProAcc,[Profile],Voucher_AmountWPCDue(@P_EDate) Voucher,AdmLink Left Join Reinsurance On (Reinsurance.DocNo=Admlink.RefNo)
where  Voucher.Voucher=AdmLink.Voucher   
and ProAcc.ProAcc=Voucher.ProAcc   
and ProAcc.[ID]=[Profile].[ID]   
and Admlink.Type in ('PI','FO','FP','FX','QS','QP','S1','S2','S3','CP','XP','AF','DC','X1','X2','X3','X4','X5','X6','X7','X8','X9','XX','RP','AP','IR','IT','IX')  
and Upper(AdmLink.Subject)='PREMIUM'
and round(Voucher.AmountDue - (Voucher.Payment_CC+Voucher.Payment_OC),2)>0 and Voucher.DueDate between @P_SDate and @P_EDate  
  
and Voucher.Voucher in (Select CollectionV.Voucher from CollectionV, CollectionH Where CollectionH.CollNo=CollectionV.CollNo and CollectionH.CollStatus='C' and CollectionV.Paid=0 and CollectionV.Voucher=Voucher.Voucher)  
and Not Exists (Select Top 1 CollectionV.Voucher from CollectionV, CollectionH Where CollectionH.CollNo=CollectionV.COllNo and CollectionH.CollStatus<>'C' and CollectionV.CollNo<>Voucher.CollNo and CollectionV.Voucher=Voucher.Voucher)   
and Not Exists (Select Top 1 SL.doc_no from SL_Request SL, Request R Where R.Status<>'C' and R.Voucher='' and R.Request=SL.Request and SL.doc_no=Voucher.Voucher)

  
)  

GO
DROP function [dbo].[DB_R_DISBURSE_UNPAID_CLAIM_ALL]  
GO
CREATE function [dbo].[DB_R_DISBURSE_UNPAID_CLAIM_ALL](@P_SDate as smalldatetime, @P_EDate as SmallDateTime)  
RETURNS TABLE  
AS RETURN  
(  
select distinct Admlink.RefNo, Voucher.Voucher, Admlink.Type, Admlink.BatchNo, Admlink.Bank, Admlink.Date, Admlink.Subject, Admlink.Extra_3,Voucher.DocNo, Voucher.StatID, Voucher.ActionBy, Voucher.ActionDate, Voucher.AcceptedBy, Voucher.AcceptedDate,   
Voucher.[Currency],  Voucher.Installment, Voucher.DueDate as DueDate, Voucher.AmountDue-Voucher.Payment_CC-Voucher.Payment_OC as Nominal,  
Case When Reinsurance.DocNo is null Then Voucher.Remarks else Reinsurance.Description end +Voucher.sInstallment as AName, Profile.Name, Voucher.debtorF,Voucher.CreditorF, Admlink.RefType,Voucher.Branch, Admlink.A_PolicyNo, Admlink.EXTRA_4, Admlink.ISType
from ProAcc,[Profile],Voucher_AmountWPCDue(@P_EDate) Voucher,AdmLink Left Join Reinsurance On (Reinsurance.DocNo=Admlink.RefNo)
where  Voucher.Voucher=AdmLink.Voucher   
and ProAcc.ProAcc=Voucher.ProAcc   
and ProAcc.[ID]=[Profile].[ID]   
and Admlink.Type in ('PI','FO','FP','FX','QS','QP','S1','S2','S3','CP','XP','AF','DC','X1','X2','X3','X4','X5','X6','X7','X8','X9','XX','RP','AP','IR','IT','IX')  
and Upper(AdmLink.Subject)='CLAIM'
and round(Voucher.AmountDue - (Voucher.Payment_CC+Voucher.Payment_OC),2)>0 and Voucher.DueDate between @P_SDate and @P_EDate  
  
and Voucher.Voucher in (Select CollectionV.Voucher from CollectionV, CollectionH Where CollectionH.CollNo=CollectionV.CollNo and CollectionH.CollStatus='C' and CollectionV.Paid=0 and CollectionV.Voucher=Voucher.Voucher)  
and Not Exists (Select Top 1 CollectionV.Voucher from CollectionV, CollectionH Where CollectionH.CollNo=CollectionV.COllNo and CollectionH.CollStatus<>'C' and CollectionV.CollNo<>Voucher.CollNo and CollectionV.Voucher=Voucher.Voucher)   
and Not Exists (Select Top 1 SL.doc_no from SL_Request SL, Request R Where R.Status<>'C' and R.Voucher='' and R.Request=SL.Request and SL.doc_no=Voucher.Voucher)

  
)  

GO  
DROP function [dbo].[DB_R_DISBURSE_HOLD_ALL_ALL]
GO 
CREATE function [dbo].[DB_R_DISBURSE_HOLD_ALL_ALL](@P_SDate as smalldatetime, @P_EDate as SmallDateTime)  
RETURNS TABLE  
AS RETURN  
(  
 
select distinct Admlink.RefNo, Voucher.Voucher, Admlink.Type, Admlink.BatchNo, Admlink.Bank, Admlink.Date, Admlink.Subject, Admlink.Extra_3,Voucher.DocNo, Voucher.StatID, Voucher.ActionBy, Voucher.ActionDate, Voucher.AcceptedBy, Voucher.AcceptedDate,   
Voucher.[Currency],  Voucher.Installment, Voucher.DueDate as DueDate, Voucher.AmountDue-Voucher.Payment_CC-Voucher.Payment_OC as Nominal,  
Case When Reinsurance.DocNo is null Then Voucher.Remarks else Reinsurance.Description end +Voucher.sInstallment as AName, Profile.Name, Voucher.debtorF,Voucher.CreditorF, Admlink.RefType,Voucher.Branch, Admlink.A_PolicyNo, Admlink.EXTRA_4, Admlink.ISType
from ProAcc,[Profile],Voucher_AmountWPCDue(@P_EDate) Voucher,AdmLink Left Join Reinsurance On (Reinsurance.DocNo=Admlink.RefNo)
where  Voucher.Voucher=AdmLink.Voucher   
and ProAcc.ProAcc=Voucher.ProAcc   
and ProAcc.[ID]=[Profile].[ID]   
and Admlink.Type in ('PI','FO','FP','FX','QS','QP','S1','S2','S3','CP','XP','AF','DC','X1','X2','X3','X4','X5','X6','X7','X8','X9','XX','RP','AP','IR','IT','IX')  
and round(Voucher.AmountDue - (Voucher.Payment_CC+Voucher.Payment_OC),2)>0 and Voucher.DueDate between @P_SDate and @P_EDate  
  
and Voucher.Voucher in (Select CollectionV.Voucher from CollectionV, CollectionH Where CollectionH.CollNo=CollectionV.CollNo and CollectionH.CollStatus='C' and CollectionV.Hold<>0 and CollectionV.Voucher=Voucher.Voucher)  
)  
  
GO
DROP function [dbo].[DB_R_DISBURSE_HOLD_PREMIUM_ALL]  
GO
CREATE function [dbo].[DB_R_DISBURSE_HOLD_PREMIUM_ALL](@P_SDate as smalldatetime, @P_EDate as SmallDateTime)  
RETURNS TABLE  
AS RETURN  
(   
select distinct Admlink.RefNo, Voucher.Voucher, Admlink.Type, Admlink.BatchNo, Admlink.Bank, Admlink.Date, Admlink.Subject, Admlink.Extra_3,Voucher.DocNo, Voucher.StatID, Voucher.ActionBy, Voucher.ActionDate, Voucher.AcceptedBy, Voucher.AcceptedDate,   
Voucher.[Currency],  Voucher.Installment, Voucher.DueDate as DueDate, Voucher.AmountDue-Voucher.Payment_CC-Voucher.Payment_OC as Nominal,  
Case When Reinsurance.DocNo is null Then Voucher.Remarks else Reinsurance.Description end +Voucher.sInstallment as AName, Profile.Name, Voucher.debtorF,Voucher.CreditorF, Admlink.RefType,Voucher.Branch, Admlink.A_PolicyNo, Admlink.EXTRA_4, Admlink.ISType
from ProAcc,[Profile],Voucher_AmountWPCDue(@P_EDate) Voucher,AdmLink Left Join Reinsurance On (Reinsurance.DocNo=Admlink.RefNo)
where  Voucher.Voucher=AdmLink.Voucher   
and ProAcc.ProAcc=Voucher.ProAcc   
and ProAcc.[ID]=[Profile].[ID]   
and Admlink.Type in ('PI','FO','FP','FX','QS','QP','S1','S2','S3','CP','XP','AF','DC','X1','X2','X3','X4','X5','X6','X7','X8','X9','XX','RP','AP','IR','IT','IX')  
and Upper(AdmLink.SUbject)='PREMIUM'
and round(Voucher.AmountDue - (Voucher.Payment_CC+Voucher.Payment_OC),2)>0 and Voucher.DueDate between @P_SDate and @P_EDate  
  
and Voucher.Voucher in (Select CollectionV.Voucher from CollectionV, CollectionH Where CollectionH.CollNo=CollectionV.CollNo and CollectionH.CollStatus='C' and CollectionV.Hold<>0 and CollectionV.Voucher=Voucher.Voucher)  
)  
  
  
GO
DROP function [dbo].[DB_R_DISBURSE_HOLD_CLAIM_ALL]  
GO
CREATE function [dbo].[DB_R_DISBURSE_HOLD_CLAIM_ALL](@P_SDate as smalldatetime, @P_EDate as SmallDateTime)  
RETURNS TABLE  
AS RETURN  
(   
select distinct Admlink.RefNo, Voucher.Voucher, Admlink.Type, Admlink.BatchNo, Admlink.Bank, Admlink.Date, Admlink.Subject, Admlink.Extra_3,Voucher.DocNo, Voucher.StatID, Voucher.ActionBy, Voucher.ActionDate, Voucher.AcceptedBy, Voucher.AcceptedDate,   
Voucher.[Currency],  Voucher.Installment, Voucher.DueDate as DueDate, Voucher.AmountDue-Voucher.Payment_CC-Voucher.Payment_OC as Nominal,  
Case When Reinsurance.DocNo is null Then Voucher.Remarks else Reinsurance.Description end +Voucher.sInstallment as AName, Profile.Name, Voucher.debtorF,Voucher.CreditorF, Admlink.RefType,Voucher.Branch, Admlink.A_PolicyNo, Admlink.EXTRA_4, Admlink.ISType
from ProAcc,[Profile],Voucher_AmountWPCDue(@P_EDate) Voucher,AdmLink Left Join Reinsurance On (Reinsurance.DocNo=Admlink.RefNo)
where  Voucher.Voucher=AdmLink.Voucher   
and ProAcc.ProAcc=Voucher.ProAcc   
and ProAcc.[ID]=[Profile].[ID]   
and Admlink.Type in ('PI','FO','FP','FX','QS','QP','S1','S2','S3','CP','XP','AF','DC','X1','X2','X3','X4','X5','X6','X7','X8','X9','XX','RP','AP','IR','IT','IX')  
and Upper(AdmLink.SUbject)='CLAIM'
and round(Voucher.AmountDue - (Voucher.Payment_CC+Voucher.Payment_OC),2)>0 and Voucher.DueDate between @P_SDate and @P_EDate  
  
and Voucher.Voucher in (Select CollectionV.Voucher from CollectionV, CollectionH Where CollectionH.CollNo=CollectionV.CollNo and CollectionH.CollStatus='C' and CollectionV.Hold<>0 and CollectionV.Voucher=Voucher.Voucher)  
)  
  
GO


DROP FUNCTION [dbo].[DB_R_DISBURSE_ALL_ALL_ID] 
GO
CREATE FUNCTION [dbo].[DB_R_DISBURSE_ALL_ALL_ID] (@P_SDate as smalldatetime, @P_EDate as SmallDateTime,@P_ID as varchar(10))  
RETURNS TABLE  
AS RETURN  
(  
select distinct Admlink.RefNo, Voucher.Voucher, Admlink.Type, Admlink.BatchNo, Admlink.Bank, Admlink.Date, Admlink.Subject, Admlink.Extra_3,Voucher.DocNo, Voucher.StatID, Voucher.ActionBy, Voucher.ActionDate, Voucher.AcceptedBy, Voucher.AcceptedDate,   
Voucher.[Currency],  Voucher.Installment, Voucher.DueDate as DueDate, Voucher.AmountDue-Voucher.Payment_CC-Voucher.Payment_OC as Nominal,  
Case When Reinsurance.DocNo is null Then Voucher.Remarks else Reinsurance.Description end +Voucher.sInstallment as AName, Profile.Name, Voucher.debtorF,Voucher.CreditorF, Admlink.RefType,Voucher.Branch, Admlink.A_PolicyNo, Admlink.EXTRA_4, Admlink.ISType
from ProAcc,[Profile],Voucher_AmountWPCDue(@P_EDate) Voucher,AdmLink Left Join Reinsurance On (Reinsurance.DocNo=Admlink.RefNo)
where  Voucher.Voucher=AdmLink.Voucher   
and ProAcc.ProAcc=Voucher.ProAcc   
and ProAcc.[ID]=[Profile].[ID]   
and Admlink.Type in ('PI','FO','FP','FX','QS','QP','S1','S2','S3','CP','XP','AF','DC','X1','X2','X3','X4','X5','X6','X7','X8','X9','XX','RP','AP','IR','IT','IX')  
and round(Voucher.AmountDue - (Voucher.Payment_CC+Voucher.Payment_OC),2)>0 and Voucher.DueDate between @P_SDate and @P_EDate  
and AdmLink.ID Like @P_ID+'%'  
and Not Exists (Select Top 1 CollectionV.Voucher from CollectionV, CollectionH Where CollectionH.CollNo=CollectionV.COllNo and CollectionH.CollStatus<>'C' and CollectionV.CollNo<>Voucher.CollNo and CollectionV.Voucher=Voucher.Voucher)   
and Not Exists (Select Top 1 SL.doc_no from SL_Request SL, Request R Where R.Status<>'C' and R.Voucher='' and R.Request=SL.Request and SL.doc_no=Voucher.Voucher)

)  

GO
DROP FUNCTION [dbo].[DB_R_DISBURSE_ALL_PREMIUM_ID] 
GO
CREATE FUNCTION [dbo].[DB_R_DISBURSE_ALL_PREMIUM_ID] (@P_SDate as smalldatetime, @P_EDate as SmallDateTime,@P_ID as varchar(10))  
RETURNS TABLE  
AS RETURN  
(  
select distinct Admlink.RefNo, Voucher.Voucher, Admlink.Type, Admlink.BatchNo, Admlink.Bank, Admlink.Date, Admlink.Subject, Admlink.Extra_3,Voucher.DocNo, Voucher.StatID, Voucher.ActionBy, Voucher.ActionDate, Voucher.AcceptedBy, Voucher.AcceptedDate,   
Voucher.[Currency],  Voucher.Installment, Voucher.DueDate as DueDate, Voucher.AmountDue-Voucher.Payment_CC-Voucher.Payment_OC as Nominal,  
Case When Reinsurance.DocNo is null Then Voucher.Remarks else Reinsurance.Description end +Voucher.sInstallment as AName, Profile.Name, Voucher.debtorF,Voucher.CreditorF, Admlink.RefType,Voucher.Branch, Admlink.A_PolicyNo, Admlink.EXTRA_4, Admlink.ISType
from ProAcc,[Profile],Voucher_AmountWPCDue(@P_EDate) Voucher,AdmLink Left Join Reinsurance On (Reinsurance.DocNo=Admlink.RefNo)
where  Voucher.Voucher=AdmLink.Voucher   
and ProAcc.ProAcc=Voucher.ProAcc   
and ProAcc.[ID]=[Profile].[ID]   
and Admlink.Type in ('PI','FO','FP','FX','QS','QP','S1','S2','S3','CP','XP','AF','DC','X1','X2','X3','X4','X5','X6','X7','X8','X9','XX','RP','AP','IR','IT','IX')  
and Upper(AdmLink.Subject)='PREMIUM'
and round(Voucher.AmountDue - (Voucher.Payment_CC+Voucher.Payment_OC),2)>0 and Voucher.DueDate between @P_SDate and @P_EDate  
and AdmLink.ID Like @P_ID+'%'  
and Not Exists (Select Top 1 CollectionV.Voucher from CollectionV, CollectionH Where CollectionH.CollNo=CollectionV.COllNo and CollectionH.CollStatus<>'C' and CollectionV.CollNo<>Voucher.CollNo and CollectionV.Voucher=Voucher.Voucher)   
and Not Exists (Select Top 1 SL.doc_no from SL_Request SL, Request R Where R.Status<>'C' and R.Voucher='' and R.Request=SL.Request and SL.doc_no=Voucher.Voucher)

)  

GO  
DROP FUNCTION [dbo].[DB_R_DISBURSE_ALL_CLAIM_ID] 
GO
CREATE FUNCTION [dbo].[DB_R_DISBURSE_ALL_CLAIM_ID] (@P_SDate as smalldatetime, @P_EDate as SmallDateTime,@P_ID as varchar(10))  
RETURNS TABLE  
AS RETURN  
(  
select distinct Admlink.RefNo, Voucher.Voucher, Admlink.Type, Admlink.BatchNo, Admlink.Bank, Admlink.Date, Admlink.Subject, Admlink.Extra_3,Voucher.DocNo, Voucher.StatID, Voucher.ActionBy, Voucher.ActionDate, Voucher.AcceptedBy, Voucher.AcceptedDate,   
Voucher.[Currency],  Voucher.Installment, Voucher.DueDate as DueDate, Voucher.AmountDue-Voucher.Payment_CC-Voucher.Payment_OC as Nominal,  
Case When Reinsurance.DocNo is null Then Voucher.Remarks else Reinsurance.Description end +Voucher.sInstallment as AName, Profile.Name, Voucher.debtorF,Voucher.CreditorF, Admlink.RefType,Voucher.Branch, Admlink.A_PolicyNo, Admlink.EXTRA_4, Admlink.ISType
from ProAcc,[Profile],Voucher_AmountWPCDue(@P_EDate) Voucher,AdmLink Left Join Reinsurance On (Reinsurance.DocNo=Admlink.RefNo)
where  Voucher.Voucher=AdmLink.Voucher   
and ProAcc.ProAcc=Voucher.ProAcc   
and ProAcc.[ID]=[Profile].[ID]   
and Admlink.Type in ('PI','FO','FP','FX','QS','QP','S1','S2','S3','CP','XP','AF','DC','X1','X2','X3','X4','X5','X6','X7','X8','X9','XX','RP','AP','IR','IT','IX')  
and Upper(AdmLink.Subject)='CLAIM'
and round(Voucher.AmountDue - (Voucher.Payment_CC+Voucher.Payment_OC),2)>0 and Voucher.DueDate between @P_SDate and @P_EDate  
and AdmLink.ID Like @P_ID+'%'  
and Not Exists (Select Top 1 CollectionV.Voucher from CollectionV, CollectionH Where CollectionH.CollNo=CollectionV.COllNo and CollectionH.CollStatus<>'C' and CollectionV.CollNo<>Voucher.CollNo and CollectionV.Voucher=Voucher.Voucher)   
and Not Exists (Select Top 1 SL.doc_no from SL_Request SL, Request R Where R.Status<>'C' and R.Voucher='' and R.Request=SL.Request and SL.doc_no=Voucher.Voucher)

)  

GO
DROP function [dbo].[DB_R_DISBURSE_PERIOD_DUE_ALL_ID]
GO
CREATE function [dbo].[DB_R_DISBURSE_PERIOD_DUE_ALL_ID](@P_SDate as smalldatetime, @P_EDate as SmallDateTime,@P_ID as varchar(10))  
RETURNS TABLE  
AS RETURN  
(  
select distinct Admlink.RefNo, Voucher.Voucher, Admlink.Type, Admlink.BatchNo, Admlink.Bank, Admlink.Date, Admlink.Subject, Admlink.Extra_3,Voucher.DocNo, Voucher.StatID, Voucher.ActionBy, Voucher.ActionDate, Voucher.AcceptedBy, Voucher.AcceptedDate,   
Voucher.[Currency],  Voucher.Installment, Voucher.DueDate as DueDate, Voucher.AmountDue-Voucher.Payment_CC-Voucher.Payment_OC as Nominal,  
Case When Reinsurance.DocNo is null Then Voucher.Remarks else Reinsurance.Description end +Voucher.sInstallment as AName, Profile.Name, Voucher.debtorF,Voucher.CreditorF, Admlink.RefType,Voucher.Branch, Admlink.A_PolicyNo, Admlink.EXTRA_4, Admlink.ISType
from ProAcc,[Profile],Voucher_AmountPeriodDue(@P_SDate, @P_EDate) Voucher,AdmLink Left Join Reinsurance On (Reinsurance.DocNo=Admlink.RefNo)
where  Voucher.Voucher=AdmLink.Voucher   
and ProAcc.ProAcc=Voucher.ProAcc   
and ProAcc.[ID]=[Profile].[ID]   
and Admlink.Type in ('PI','FO','FP','FX','QS','QP','S1','S2','S3','CP','XP','AF','DC','X1','X2','X3','X4','X5','X6','X7','X8','X9','XX','RP','AP','IR','IT','IX')  
and AdmLink.ID Like @P_ID+'%' 
and Voucher.AmountDue<>0
)  
GO

DROP function [dbo].[DB_R_DISBURSE_PERIOD_DUE_PREMIUM_ID]
GO
CREATE function [dbo].[DB_R_DISBURSE_PERIOD_DUE_PREMIUM_ID](@P_SDate as smalldatetime, @P_EDate as SmallDateTime,@P_ID as varchar(10))  
RETURNS TABLE  
AS RETURN  
(  
select distinct Admlink.RefNo, Voucher.Voucher, Admlink.Type, Admlink.BatchNo, Admlink.Bank, Admlink.Date, Admlink.Subject, Admlink.Extra_3,Voucher.DocNo, Voucher.StatID, Voucher.ActionBy, Voucher.ActionDate, Voucher.AcceptedBy, Voucher.AcceptedDate,   
Voucher.[Currency],  Voucher.Installment, Voucher.DueDate as DueDate, Voucher.AmountDue-Voucher.Payment_CC-Voucher.Payment_OC as Nominal,  
Case When Reinsurance.DocNo is null Then Voucher.Remarks else Reinsurance.Description end +Voucher.sInstallment as AName, Profile.Name, Voucher.debtorF,Voucher.CreditorF, Admlink.RefType,Voucher.Branch, Admlink.A_PolicyNo, Admlink.EXTRA_4, Admlink.ISType
from ProAcc,[Profile],Voucher_AmountPeriodDue(@P_SDate, @P_EDate) Voucher,AdmLink Left Join Reinsurance On (Reinsurance.DocNo=Admlink.RefNo)
where  Voucher.Voucher=AdmLink.Voucher   
and ProAcc.ProAcc=Voucher.ProAcc   
and ProAcc.[ID]=[Profile].[ID]   
and Admlink.Type in ('PI','FO','FP','FX','QS','QP','S1','S2','S3','CP','XP','AF','DC','X1','X2','X3','X4','X5','X6','X7','X8','X9','XX','RP','AP','IR','IT','IX')  
and AdmLink.ID Like @P_ID+'%'
and Voucher.AmountDue<>0
and Upper(AdmLink.Subject)='PREMIUM'
)  

GO  
DROP function [dbo].[DB_R_DISBURSE_PERIOD_DUE_CLAIM_ID]
GO
CREATE function [dbo].[DB_R_DISBURSE_PERIOD_DUE_CLAIM_ID](@P_SDate as smalldatetime, @P_EDate as SmallDateTime,@P_ID as varchar(10))  
RETURNS TABLE  
AS RETURN  
(  
select distinct Admlink.RefNo, Voucher.Voucher, Admlink.Type, Admlink.BatchNo, Admlink.Bank, Admlink.Date, Admlink.Subject, Admlink.Extra_3,Voucher.DocNo, Voucher.StatID, Voucher.ActionBy, Voucher.ActionDate, Voucher.AcceptedBy, Voucher.AcceptedDate,   
Voucher.[Currency],  Voucher.Installment, Voucher.DueDate as DueDate, Voucher.AmountDue-Voucher.Payment_CC-Voucher.Payment_OC as Nominal,  
Case When Reinsurance.DocNo is null Then Voucher.Remarks else Reinsurance.Description end +Voucher.sInstallment as AName, Profile.Name, Voucher.debtorF,Voucher.CreditorF, Admlink.RefType,Voucher.Branch, Admlink.A_PolicyNo, Admlink.EXTRA_4, Admlink.ISType
from ProAcc,[Profile],Voucher_AmountPeriodDue(@P_SDate, @P_EDate) Voucher,AdmLink Left Join Reinsurance On (Reinsurance.DocNo=Admlink.RefNo)
where  Voucher.Voucher=AdmLink.Voucher   
and ProAcc.ProAcc=Voucher.ProAcc   
and ProAcc.[ID]=[Profile].[ID]   
and Admlink.Type in ('PI','FO','FP','FX','QS','QP','S1','S2','S3','CP','XP','AF','DC','X1','X2','X3','X4','X5','X6','X7','X8','X9','XX','RP','AP','IR','IT','IX')  
and AdmLink.ID Like @P_ID+'%'
and Voucher.AmountDue<>0
and Upper(AdmLink.Subject)='CLAIM'
)  

GO  
DROP function [dbo].[DB_R_DISBURSE_UNPAID_ALL_ID]
GO
CREATE function [dbo].[DB_R_DISBURSE_UNPAID_ALL_ID](@P_SDate as smalldatetime, @P_EDate as SmallDateTime,@P_ID as varchar(10))  
RETURNS TABLE  
AS RETURN  
(  
select distinct Admlink.RefNo, Voucher.Voucher, Admlink.Type, Admlink.BatchNo, Admlink.Bank, Admlink.Date, Admlink.Subject, Admlink.Extra_3,Voucher.DocNo, Voucher.StatID, Voucher.ActionBy, Voucher.ActionDate, Voucher.AcceptedBy, Voucher.AcceptedDate,   
Voucher.[Currency],  Voucher.Installment, Voucher.DueDate as DueDate, Voucher.AmountDue-Voucher.Payment_CC-Voucher.Payment_OC as Nominal,  
Case When Reinsurance.DocNo is null Then Voucher.Remarks else Reinsurance.Description end +Voucher.sInstallment as AName, Profile.Name, Voucher.debtorF,Voucher.CreditorF, Admlink.RefType,Voucher.Branch, Admlink.A_PolicyNo, Admlink.EXTRA_4, Admlink.ISType
from ProAcc,[Profile],Voucher_AmountWPCDue(@P_EDate) Voucher,AdmLink Left Join Reinsurance On (Reinsurance.DocNo=Admlink.RefNo)
where  Voucher.Voucher=AdmLink.Voucher   
and ProAcc.ProAcc=Voucher.ProAcc   
and ProAcc.[ID]=[Profile].[ID]   
and Admlink.Type in ('PI','FO','FP','FX','QS','QP','S1','S2','S3','CP','XP','AF','DC','X1','X2','X3','X4','X5','X6','X7','X8','X9','XX','RP','AP','IR','IT','IX')  
and round(Voucher.AmountDue - (Voucher.Payment_CC+Voucher.Payment_OC),2)>0 and Voucher.DueDate between @P_SDate and @P_EDate  
and AdmLink.ID Like @P_ID+'%'
and Voucher.Voucher in (Select CollectionV.Voucher from CollectionV, CollectionH Where CollectionH.CollNo=CollectionV.CollNo and CollectionH.CollStatus='C' and CollectionV.Paid=0 and CollectionV.Voucher=Voucher.Voucher)  
and Not Exists (Select Top 1 CollectionV.Voucher from CollectionV, CollectionH Where CollectionH.CollNo=CollectionV.COllNo and CollectionH.CollStatus<>'C' and CollectionV.CollNo<>Voucher.CollNo and CollectionV.Voucher=Voucher.Voucher)   
and Not Exists (Select Top 1 SL.doc_no from SL_Request SL, Request R Where R.Status<>'C' and R.Voucher='' and R.Request=SL.Request and SL.doc_no=Voucher.Voucher)

  
)  
  
GO
DROP function [dbo].[DB_R_DISBURSE_UNPAID_PREMIUM_ID]
GO
CREATE function [dbo].[DB_R_DISBURSE_UNPAID_PREMIUM_ID](@P_SDate as smalldatetime, @P_EDate as SmallDateTime,@P_ID as varchar(10))  
RETURNS TABLE  
AS RETURN  
(  
select distinct Admlink.RefNo, Voucher.Voucher, Admlink.Type, Admlink.BatchNo, Admlink.Bank, Admlink.Date, Admlink.Subject, Admlink.Extra_3,Voucher.DocNo, Voucher.StatID, Voucher.ActionBy, Voucher.ActionDate, Voucher.AcceptedBy, Voucher.AcceptedDate,   
Voucher.[Currency],  Voucher.Installment, Voucher.DueDate as DueDate, Voucher.AmountDue-Voucher.Payment_CC-Voucher.Payment_OC as Nominal,  
Case When Reinsurance.DocNo is null Then Voucher.Remarks else Reinsurance.Description end +Voucher.sInstallment as AName, Profile.Name, Voucher.debtorF,Voucher.CreditorF, Admlink.RefType,Voucher.Branch, Admlink.A_PolicyNo, Admlink.EXTRA_4, Admlink.ISType
from ProAcc,[Profile],Voucher_AmountWPCDue(@P_EDate) Voucher,AdmLink Left Join Reinsurance On (Reinsurance.DocNo=Admlink.RefNo)
where  Voucher.Voucher=AdmLink.Voucher   
and ProAcc.ProAcc=Voucher.ProAcc   
and ProAcc.[ID]=[Profile].[ID]   
and Admlink.Type in ('PI','FO','FP','FX','QS','QP','S1','S2','S3','CP','XP','AF','DC','X1','X2','X3','X4','X5','X6','X7','X8','X9','XX','RP','AP','IR','IT','IX')  
and Upper(AdmLink.Subject)='PREMIUM'
and round(Voucher.AmountDue - (Voucher.Payment_CC+Voucher.Payment_OC),2)>0 and Voucher.DueDate between @P_SDate and @P_EDate  
and AdmLink.ID Like @P_ID+'%'
and Voucher.Voucher in (Select CollectionV.Voucher from CollectionV, CollectionH Where CollectionH.CollNo=CollectionV.CollNo and CollectionH.CollStatus='C' and CollectionV.Paid=0 and CollectionV.Voucher=Voucher.Voucher)  
and Not Exists (Select Top 1 CollectionV.Voucher from CollectionV, CollectionH Where CollectionH.CollNo=CollectionV.COllNo and CollectionH.CollStatus<>'C' and CollectionV.CollNo<>Voucher.CollNo and CollectionV.Voucher=Voucher.Voucher)   
and Not Exists (Select Top 1 SL.doc_no from SL_Request SL, Request R Where R.Status<>'C' and R.Voucher='' and R.Request=SL.Request and SL.doc_no=Voucher.Voucher)

  
)  

GO
DROP function [dbo].[DB_R_DISBURSE_UNPAID_CLAIM_ID]  
GO
CREATE function [dbo].[DB_R_DISBURSE_UNPAID_CLAIM_ID](@P_SDate as smalldatetime, @P_EDate as SmallDateTime,@P_ID as varchar(10))  
RETURNS TABLE  
AS RETURN  
(  
select distinct Admlink.RefNo, Voucher.Voucher, Admlink.Type, Admlink.BatchNo, Admlink.Bank, Admlink.Date, Admlink.Subject, Admlink.Extra_3,Voucher.DocNo, Voucher.StatID, Voucher.ActionBy, Voucher.ActionDate, Voucher.AcceptedBy, Voucher.AcceptedDate,   
Voucher.[Currency],  Voucher.Installment, Voucher.DueDate as DueDate, Voucher.AmountDue-Voucher.Payment_CC-Voucher.Payment_OC as Nominal,  
Case When Reinsurance.DocNo is null Then Voucher.Remarks else Reinsurance.Description end +Voucher.sInstallment as AName, Profile.Name, Voucher.debtorF,Voucher.CreditorF, Admlink.RefType,Voucher.Branch, Admlink.A_PolicyNo, Admlink.EXTRA_4, Admlink.ISType
from ProAcc,[Profile],Voucher_AmountWPCDue(@P_EDate) Voucher,AdmLink Left Join Reinsurance On (Reinsurance.DocNo=Admlink.RefNo)
where  Voucher.Voucher=AdmLink.Voucher   
and ProAcc.ProAcc=Voucher.ProAcc   
and ProAcc.[ID]=[Profile].[ID]   
and Admlink.Type in ('PI','FO','FP','FX','QS','QP','S1','S2','S3','CP','XP','AF','DC','X1','X2','X3','X4','X5','X6','X7','X8','X9','XX','RP','AP','IR','IT','IX')  
and Upper(AdmLink.Subject)='CLAIM'
and round(Voucher.AmountDue - (Voucher.Payment_CC+Voucher.Payment_OC),2)>0 and Voucher.DueDate between @P_SDate and @P_EDate  
and AdmLink.ID Like @P_ID+'%'
and Voucher.Voucher in (Select CollectionV.Voucher from CollectionV, CollectionH Where CollectionH.CollNo=CollectionV.CollNo and CollectionH.CollStatus='C' and CollectionV.Paid=0 and CollectionV.Voucher=Voucher.Voucher)  
and Not Exists (Select Top 1 CollectionV.Voucher from CollectionV, CollectionH Where CollectionH.CollNo=CollectionV.COllNo and CollectionH.CollStatus<>'C' and CollectionV.CollNo<>Voucher.CollNo and CollectionV.Voucher=Voucher.Voucher)   
and Not Exists (Select Top 1 SL.doc_no from SL_Request SL, Request R Where R.Status<>'C' and R.Voucher='' and R.Request=SL.Request and SL.doc_no=Voucher.Voucher)

  
)  

GO  
DROP function [dbo].[DB_R_DISBURSE_HOLD_ALL_ID]
GO 
CREATE function [dbo].[DB_R_DISBURSE_HOLD_ALL_ID](@P_SDate as smalldatetime, @P_EDate as SmallDateTime,@P_ID as varchar(10))  
RETURNS TABLE  
AS RETURN  
(  
 
select distinct Admlink.RefNo, Voucher.Voucher, Admlink.Type, Admlink.BatchNo, Admlink.Bank, Admlink.Date, Admlink.Subject, Admlink.Extra_3,Voucher.DocNo, Voucher.StatID, Voucher.ActionBy, Voucher.ActionDate, Voucher.AcceptedBy, Voucher.AcceptedDate,   
Voucher.[Currency],  Voucher.Installment, Voucher.DueDate as DueDate, Voucher.AmountDue-Voucher.Payment_CC-Voucher.Payment_OC as Nominal,  
Case When Reinsurance.DocNo is null Then Voucher.Remarks else Reinsurance.Description end +Voucher.sInstallment as AName, Profile.Name, Voucher.debtorF,Voucher.CreditorF, Admlink.RefType,Voucher.Branch, Admlink.A_PolicyNo, Admlink.EXTRA_4, Admlink.ISType
from ProAcc,[Profile],Voucher_AmountWPCDue(@P_EDate) Voucher,AdmLink Left Join Reinsurance On (Reinsurance.DocNo=Admlink.RefNo)
where  Voucher.Voucher=AdmLink.Voucher   
and ProAcc.ProAcc=Voucher.ProAcc   
and ProAcc.[ID]=[Profile].[ID]   
and Admlink.Type in ('PI','FO','FP','FX','QS','QP','S1','S2','S3','CP','XP','AF','DC','X1','X2','X3','X4','X5','X6','X7','X8','X9','XX','RP','AP','IR','IT','IX')  
and round(Voucher.AmountDue - (Voucher.Payment_CC+Voucher.Payment_OC),2)>0 and Voucher.DueDate between @P_SDate and @P_EDate  
and AdmLink.ID Like @P_ID+'%'  
and Voucher.Voucher in (Select CollectionV.Voucher from CollectionV, CollectionH Where CollectionH.CollNo=CollectionV.CollNo and CollectionH.CollStatus='C' and CollectionV.Hold<>0 and CollectionV.Voucher=Voucher.Voucher)  
)  
  
GO
DROP function [dbo].[DB_R_DISBURSE_HOLD_PREMIUM_ID]  
GO
CREATE function [dbo].[DB_R_DISBURSE_HOLD_PREMIUM_ID](@P_SDate as smalldatetime, @P_EDate as SmallDateTime,@P_ID as varchar(10))  
RETURNS TABLE  
AS RETURN  
(   
select distinct Admlink.RefNo, Voucher.Voucher, Admlink.Type, Admlink.BatchNo, Admlink.Bank, Admlink.Date, Admlink.Subject, Admlink.Extra_3,Voucher.DocNo, Voucher.StatID, Voucher.ActionBy, Voucher.ActionDate, Voucher.AcceptedBy, Voucher.AcceptedDate,   
Voucher.[Currency],  Voucher.Installment, Voucher.DueDate as DueDate, Voucher.AmountDue-Voucher.Payment_CC-Voucher.Payment_OC as Nominal,  
Case When Reinsurance.DocNo is null Then Voucher.Remarks else Reinsurance.Description end +Voucher.sInstallment as AName, Profile.Name, Voucher.debtorF,Voucher.CreditorF, Admlink.RefType,Voucher.Branch, Admlink.A_PolicyNo, Admlink.EXTRA_4, Admlink.ISType
from ProAcc,[Profile],Voucher_AmountWPCDue(@P_EDate) Voucher,AdmLink Left Join Reinsurance On (Reinsurance.DocNo=Admlink.RefNo)
where  Voucher.Voucher=AdmLink.Voucher   
and ProAcc.ProAcc=Voucher.ProAcc   
and ProAcc.[ID]=[Profile].[ID]   
and Admlink.Type in ('PI','FO','FP','FX','QS','QP','S1','S2','S3','CP','XP','AF','DC','X1','X2','X3','X4','X5','X6','X7','X8','X9','XX','RP','AP','IR','IT','IX')  
and Upper(AdmLink.SUbject)='PREMIUM'
and round(Voucher.AmountDue - (Voucher.Payment_CC+Voucher.Payment_OC),2)>0 and Voucher.DueDate between @P_SDate and @P_EDate  
and AdmLink.ID Like @P_ID+'%'
and Voucher.Voucher in (Select CollectionV.Voucher from CollectionV, CollectionH Where CollectionH.CollNo=CollectionV.CollNo and CollectionH.CollStatus='C' and CollectionV.Hold<>0 and CollectionV.Voucher=Voucher.Voucher)  
)  
  
  
GO
DROP function [dbo].[DB_R_DISBURSE_HOLD_CLAIM_ID]  
GO
CREATE function [dbo].[DB_R_DISBURSE_HOLD_CLAIM_ID](@P_SDate as smalldatetime, @P_EDate as SmallDateTime,@P_ID as varchar(10))  
RETURNS TABLE  
AS RETURN  
(   
select distinct Admlink.RefNo, Voucher.Voucher, Admlink.Type, Admlink.BatchNo, Admlink.Bank, Admlink.Date, Admlink.Subject, Admlink.Extra_3,Voucher.DocNo, Voucher.StatID, Voucher.ActionBy, Voucher.ActionDate, Voucher.AcceptedBy, Voucher.AcceptedDate,   
Voucher.[Currency],  Voucher.Installment, Voucher.DueDate as DueDate, Voucher.AmountDue-Voucher.Payment_CC-Voucher.Payment_OC as Nominal,  
Case When Reinsurance.DocNo is null Then Voucher.Remarks else Reinsurance.Description end +Voucher.sInstallment as AName, Profile.Name, Voucher.debtorF,Voucher.CreditorF, Admlink.RefType,Voucher.Branch, Admlink.A_PolicyNo, Admlink.EXTRA_4, Admlink.ISType
from ProAcc,[Profile],Voucher_AmountWPCDue(@P_EDate) Voucher,AdmLink Left Join Reinsurance On (Reinsurance.DocNo=Admlink.RefNo)
where  Voucher.Voucher=AdmLink.Voucher   
and ProAcc.ProAcc=Voucher.ProAcc   
and ProAcc.[ID]=[Profile].[ID]   
and Admlink.Type in ('PI','FO','FP','FX','QS','QP','S1','S2','S3','CP','XP','AF','DC','X1','X2','X3','X4','X5','X6','X7','X8','X9','XX','RP','AP','IR','IT','IX')  
and Upper(AdmLink.SUbject)='CLAIM'
and round(Voucher.AmountDue - (Voucher.Payment_CC+Voucher.Payment_OC),2)>0 and Voucher.DueDate between @P_SDate and @P_EDate  
and AdmLink.ID Like @P_ID+'%'
and Voucher.Voucher in (Select CollectionV.Voucher from CollectionV, CollectionH Where CollectionH.CollNo=CollectionV.CollNo and CollectionH.CollStatus='C' and CollectionV.Hold<>0 and CollectionV.Voucher=Voucher.Voucher)  
)  
  
 GO
 
 
insert into PatchVersioning
select '1567 Update Script - Patch 2026 (9).sql',GETDATE()
go	
  
Declare @PrevScript varchar(100)
Declare @CurrScript varchar(100)

Select @PrevScript=''
Select @CurrSCript='1567 Update Script - Patch 2026 (9).sql'


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

GO 
