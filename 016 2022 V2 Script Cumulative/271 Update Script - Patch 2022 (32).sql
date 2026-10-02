/****** Object:  UserDefinedFunction [dbo].[DB_U_I_DISBURSE]    Script Date: 5/25/2022 11:06:24 PM ******/
DROP FUNCTION [dbo].[DB_U_I_DISBURSE]
GO

/****** Object:  UserDefinedFunction [dbo].[DB_U_F_DISBURSE]    Script Date: 5/25/2022 11:06:24 PM ******/
DROP FUNCTION [dbo].[DB_U_F_DISBURSE]
GO

/****** Object:  UserDefinedFunction [dbo].[DB_I_DISBURSE_UNPAID_EXCESSREFUND_ID]    Script Date: 5/25/2022 11:06:24 PM ******/
DROP FUNCTION [dbo].[DB_I_DISBURSE_UNPAID_EXCESSREFUND_ID]
GO

/****** Object:  UserDefinedFunction [dbo].[DB_I_DISBURSE_UNPAID_EXCESSREFUND_CLAIMANT]    Script Date: 5/25/2022 11:06:24 PM ******/
DROP FUNCTION [dbo].[DB_I_DISBURSE_UNPAID_EXCESSREFUND_CLAIMANT]
GO

/****** Object:  UserDefinedFunction [dbo].[DB_I_DISBURSE_UNPAID_CLAIM_ID]    Script Date: 5/25/2022 11:06:24 PM ******/
DROP FUNCTION [dbo].[DB_I_DISBURSE_UNPAID_CLAIM_ID]
GO

/****** Object:  UserDefinedFunction [dbo].[DB_I_DISBURSE_UNPAID_CLAIM_CLAIMANT]    Script Date: 5/25/2022 11:06:24 PM ******/
DROP FUNCTION [dbo].[DB_I_DISBURSE_UNPAID_CLAIM_CLAIMANT]
GO

/****** Object:  UserDefinedFunction [dbo].[DB_I_DISBURSE_NOT_EXCESSREFUND_ID]    Script Date: 5/25/2022 11:06:24 PM ******/
DROP FUNCTION [dbo].[DB_I_DISBURSE_NOT_EXCESSREFUND_ID]
GO

/****** Object:  UserDefinedFunction [dbo].[DB_I_DISBURSE_NOT_EXCESSREFUND_CLAIMANT]    Script Date: 5/25/2022 11:06:24 PM ******/
DROP FUNCTION [dbo].[DB_I_DISBURSE_NOT_EXCESSREFUND_CLAIMANT]
GO

/****** Object:  UserDefinedFunction [dbo].[DB_I_DISBURSE_NOT_CLAIM_ID]    Script Date: 5/25/2022 11:06:24 PM ******/
DROP FUNCTION [dbo].[DB_I_DISBURSE_NOT_CLAIM_ID]
GO

/****** Object:  UserDefinedFunction [dbo].[DB_I_DISBURSE_NOT_CLAIM_CLAIMANT]    Script Date: 5/25/2022 11:06:24 PM ******/
DROP FUNCTION [dbo].[DB_I_DISBURSE_NOT_CLAIM_CLAIMANT]
GO

/****** Object:  UserDefinedFunction [dbo].[DB_I_DISBURSE_HOLD_EXCESSREFUND_ID]    Script Date: 5/25/2022 11:06:24 PM ******/
DROP FUNCTION [dbo].[DB_I_DISBURSE_HOLD_EXCESSREFUND_ID]
GO

/****** Object:  UserDefinedFunction [dbo].[DB_I_DISBURSE_HOLD_EXCESSREFUND_CLAIMANT]    Script Date: 5/25/2022 11:06:24 PM ******/
DROP FUNCTION [dbo].[DB_I_DISBURSE_HOLD_EXCESSREFUND_CLAIMANT]
GO

/****** Object:  UserDefinedFunction [dbo].[DB_I_DISBURSE_HOLD_CLAIM_ID]    Script Date: 5/25/2022 11:06:24 PM ******/
DROP FUNCTION [dbo].[DB_I_DISBURSE_HOLD_CLAIM_ID]
GO

/****** Object:  UserDefinedFunction [dbo].[DB_I_DISBURSE_HOLD_CLAIM_CLAIMANT]    Script Date: 5/25/2022 11:06:24 PM ******/
DROP FUNCTION [dbo].[DB_I_DISBURSE_HOLD_CLAIM_CLAIMANT]
GO

/****** Object:  UserDefinedFunction [dbo].[DB_I_DISBURSE_ALL_EXCESSREFUND_ID]    Script Date: 5/25/2022 11:06:24 PM ******/
DROP FUNCTION [dbo].[DB_I_DISBURSE_ALL_EXCESSREFUND_ID]
GO

/****** Object:  UserDefinedFunction [dbo].[DB_I_DISBURSE_ALL_EXCESSREFUND_CLAIMANT]    Script Date: 5/25/2022 11:06:24 PM ******/
DROP FUNCTION [dbo].[DB_I_DISBURSE_ALL_EXCESSREFUND_CLAIMANT]
GO

/****** Object:  UserDefinedFunction [dbo].[DB_I_DISBURSE_ALL_CLAIM_ID]    Script Date: 5/25/2022 11:06:24 PM ******/
DROP FUNCTION [dbo].[DB_I_DISBURSE_ALL_CLAIM_ID]
GO

/****** Object:  UserDefinedFunction [dbo].[DB_I_DISBURSE_ALL_CLAIM_CLAIMANT]    Script Date: 5/25/2022 11:06:24 PM ******/
DROP FUNCTION [dbo].[DB_I_DISBURSE_ALL_CLAIM_CLAIMANT]
GO

/****** Object:  UserDefinedFunction [dbo].[DB_F_DISBURSE_UNPAID_EXCESSREFUND_CLAIMANT]    Script Date: 5/25/2022 11:06:24 PM ******/
DROP FUNCTION [dbo].[DB_F_DISBURSE_UNPAID_EXCESSREFUND_CLAIMANT]
GO

/****** Object:  UserDefinedFunction [dbo].[DB_F_DISBURSE_UNPAID_CLAIM_CLAIMANT]    Script Date: 5/25/2022 11:06:24 PM ******/
DROP FUNCTION [dbo].[DB_F_DISBURSE_UNPAID_CLAIM_CLAIMANT]
GO

/****** Object:  UserDefinedFunction [dbo].[DB_F_DISBURSE_NOT_EXCESSREFUND_CLAIMANT]    Script Date: 5/25/2022 11:06:24 PM ******/
DROP FUNCTION [dbo].[DB_F_DISBURSE_NOT_EXCESSREFUND_CLAIMANT]
GO

/****** Object:  UserDefinedFunction [dbo].[DB_F_DISBURSE_NOT_CLAIM_CLAIMANT]    Script Date: 5/25/2022 11:06:24 PM ******/
DROP FUNCTION [dbo].[DB_F_DISBURSE_NOT_CLAIM_CLAIMANT]
GO

/****** Object:  UserDefinedFunction [dbo].[DB_F_DISBURSE_HOLD_EXCESSREFUND_CLAIMANT]    Script Date: 5/25/2022 11:06:24 PM ******/
DROP FUNCTION [dbo].[DB_F_DISBURSE_HOLD_EXCESSREFUND_CLAIMANT]
GO

/****** Object:  UserDefinedFunction [dbo].[DB_F_DISBURSE_HOLD_CLAIM_CLAIMANT]    Script Date: 5/25/2022 11:06:24 PM ******/
DROP FUNCTION [dbo].[DB_F_DISBURSE_HOLD_CLAIM_CLAIMANT]
GO

/****** Object:  UserDefinedFunction [dbo].[DB_F_DISBURSE_ALL_EXCESSREFUND_CLAIMANT]    Script Date: 5/25/2022 11:06:24 PM ******/
DROP FUNCTION [dbo].[DB_F_DISBURSE_ALL_EXCESSREFUND_CLAIMANT]
GO

/****** Object:  UserDefinedFunction [dbo].[DB_F_DISBURSE_ALL_CLAIM_CLAIMANT]    Script Date: 5/25/2022 11:06:24 PM ******/
DROP FUNCTION [dbo].[DB_F_DISBURSE_ALL_CLAIM_CLAIMANT]
GO

/****** Object:  UserDefinedFunction [dbo].[DB_F_DISBURSE_ALL_CLAIM_CLAIMANT]    Script Date: 5/25/2022 11:06:24 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO




CREATE FUNCTION [dbo].[DB_F_DISBURSE_ALL_CLAIM_CLAIMANT](@P_SDate as smalldatetime, @P_EDate as SmallDateTime, @P_ID as Varchar(255))    
RETURNS TABLE    
AS RETURN    
(    
select distinct  Voucher.RefNo as RefNo, Voucher.Voucher, Admlink.Type, Admlink.Code, Admlink.BatchNo, Admlink.Bank, Admlink.Date, Admlink.Subject, Voucher.DocNo, Voucher.StatID, Voucher.ActionBy, Voucher.ActionDate, Voucher.AcceptedBy, Voucher.AcceptedDate,     
Voucher.[Currency],  Voucher.Installment, Voucher.DueDate as DueDate, Voucher.Nominal_CC-Voucher.Diff_CC-Voucher.Payment_CC-Voucher.Payment_OC as Nominal,    
Voucher.Remarks as AName, Profile.Name, Voucher.debtorF,Voucher.CreditorF, Admlink.RefType,Voucher.Branch, Admlink.A_PolicyNo, Admlink.EXTRA_4  
from ProAcc,[Profile], nVoucher Voucher, AdmLink  
where  Voucher.Voucher=AdmLink.Voucher     
and ProAcc.ProAcc=Voucher.ProAcc     
and ProAcc.[ID]=[Profile].[ID]     
and Admlink.Type in ('DI','IC','CF','JP','SO','OP')    
and Not ((Admlink.Type in ('OP') and Admlink.Amount_8<>0) or (Admlink.Type in ('DI','SO') and Admlink.Amount_7+Admlink.Amount_12+Admlink.Amount_15=Admlink.Amount)) -- Not Claim Salvage/Excess      
and Upper(AdmLink.Subject)='CLAIM'  
and Admlink.BillDate between @P_SDate and @P_EDate
and round(Voucher.Nominal_CC-Voucher.Diff_CC - (Voucher.Payment_CC+Voucher.Payment_OC),2)>0   
and Admlink.A_ID Like @P_ID+'%'
and Not Exists (Select Top 1 CollectionV.Voucher from CollectionV, CollectionH Where CollectionH.CollNo=CollectionV.COllNo and CollectionH.CollStatus<>'C' and CollectionV.CollNo<>Voucher.CollNo and CollectionV.Voucher=Voucher.Voucher)   
and Not Exists (Select Top 1 SL.doc_no from SL_Request SL, Request R Where R.Status<>'C' and R.Voucher='' and R.Request=SL.Request and SL.doc_no=Voucher.Voucher)

  
)    
  




GO

/****** Object:  UserDefinedFunction [dbo].[DB_F_DISBURSE_ALL_EXCESSREFUND_CLAIMANT]    Script Date: 5/25/2022 11:06:24 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO




CREATE FUNCTION [dbo].[DB_F_DISBURSE_ALL_EXCESSREFUND_CLAIMANT](@P_SDate as smalldatetime, @P_EDate as SmallDateTime, @P_ID as Varchar(255))    
RETURNS TABLE    
AS RETURN    
(    
select distinct  Voucher.RefNo as RefNo, Voucher.Voucher, Admlink.Type, Admlink.Code, Admlink.BatchNo, Admlink.Bank, Admlink.Date, Admlink.Subject, Voucher.DocNo, Voucher.StatID, Voucher.ActionBy, Voucher.ActionDate, Voucher.AcceptedBy, Voucher.AcceptedDate,     
Voucher.[Currency],  Voucher.Installment, Voucher.DueDate as DueDate, Voucher.AmountDue-Voucher.Payment_CC-Voucher.Payment_OC as Nominal,    
Voucher.Remarks as AName, Profile.Name, Voucher.debtorF,Voucher.CreditorF, Admlink.RefType,Voucher.Branch, Admlink.A_PolicyNo, Admlink.EXTRA_4  
from ProAcc,[Profile], Voucher_AmountWPCDue(@P_EDate) Voucher, AdmLink  
where  Voucher.Voucher=AdmLink.Voucher     
and ProAcc.ProAcc=Voucher.ProAcc     
and ProAcc.[ID]=[Profile].[ID]     
and ((Admlink.Type in ('OP') and Admlink.Amount_8<>0) or (Admlink.Type in ('DI','SO') and Admlink.Amount_7+Admlink.Amount_12+Admlink.Amount_15=Admlink.Amount)) -- Claim Salvage/Excess      
and Upper(AdmLink.Subject)='CLAIM' and Upper(Admlink.Extra_3)='REFUND'
and round(Voucher.AmountDue - (Voucher.Payment_CC+Voucher.Payment_OC),2)>0 and Voucher.DueDate between @P_SDate and @P_EDate    
    
and Admlink.A_ID Like @P_ID+'%'    
and Not Exists (Select Top 1 CollectionV.Voucher from CollectionV, CollectionH Where CollectionH.CollNo=CollectionV.COllNo and CollectionH.CollStatus<>'C' and CollectionV.CollNo<>Voucher.CollNo and CollectionV.Voucher=Voucher.Voucher)   
and Not Exists (Select Top 1 SL.doc_no from SL_Request SL, Request R Where R.Status<>'C' and R.Voucher='' and R.Request=SL.Request and SL.doc_no=Voucher.Voucher)

)    
  




GO

/****** Object:  UserDefinedFunction [dbo].[DB_F_DISBURSE_HOLD_CLAIM_CLAIMANT]    Script Date: 5/25/2022 11:06:24 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO




CREATE function [dbo].[DB_F_DISBURSE_HOLD_CLAIM_CLAIMANT](@P_SDate as smalldatetime, @P_EDate as SmallDateTime, @P_ID as Varchar(255))    
RETURNS TABLE      
AS RETURN      
(      
     
select distinct  Voucher.RefNo as RefNo, Voucher.Voucher, Admlink.Type, Admlink.Code, Admlink.BatchNo, Admlink.Bank, Admlink.Date, Admlink.Subject, Voucher.DocNo, Voucher.StatID, Voucher.ActionBy, Voucher.ActionDate, Voucher.AcceptedBy, Voucher.AcceptedDate,     
Voucher.[Currency],  Voucher.Installment, Voucher.DueDate as DueDate, Voucher.Nominal_CC-Voucher.Diff_CC-Voucher.Payment_CC-Voucher.Payment_OC as Nominal,    
Voucher.Remarks as AName, Profile.Name, Voucher.debtorF,Voucher.CreditorF, Admlink.RefType,Voucher.Branch, Admlink.A_PolicyNo, Admlink.EXTRA_4  
from ProAcc,[Profile], nVoucher Voucher, AdmLink  
where  Voucher.Voucher=AdmLink.Voucher     
and ProAcc.ProAcc=Voucher.ProAcc     
and ProAcc.[ID]=[Profile].[ID]     
and Admlink.Type in ('DI','IC','CF','JP','SO','OP')    
and Not ((Admlink.Type in ('OP') and Admlink.Amount_8<>0) or (Admlink.Type in ('DI','SO') and Admlink.Amount_7+Admlink.Amount_12+Admlink.Amount_15=Admlink.Amount)) -- Not Claim Salvage/Excess      
and Upper(AdmLink.Subject)='CLAIM'  
and Admlink.BillDate between @P_SDate and @P_EDate
and Admlink.A_ID Like @P_ID+'%'
and round(Voucher.Nominal_CC-Voucher.Diff_CC - (Voucher.Payment_CC+Voucher.Payment_OC),2)>0   
and Voucher.Voucher in (Select CollectionV.Voucher from CollectionV, CollectionH Where CollectionH.CollNo=CollectionV.CollNo and CollectionH.CollStatus='C' and CollectionV.Hold<>0 and CollectionV.Voucher=Voucher.Voucher)          
)      





GO

/****** Object:  UserDefinedFunction [dbo].[DB_F_DISBURSE_HOLD_EXCESSREFUND_CLAIMANT]    Script Date: 5/25/2022 11:06:24 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO




CREATE function [dbo].[DB_F_DISBURSE_HOLD_EXCESSREFUND_CLAIMANT](@P_SDate as smalldatetime, @P_EDate as SmallDateTime, @P_ID as Varchar(255))    
RETURNS TABLE      
AS RETURN      
(      
     
select distinct  Voucher.RefNo as RefNo, Voucher.Voucher, Admlink.Type, Admlink.Code, Admlink.BatchNo, Admlink.Bank, Admlink.Date, Admlink.Subject, Voucher.DocNo, Voucher.StatID, Voucher.ActionBy, Voucher.ActionDate, Voucher.AcceptedBy, Voucher.AcceptedDate,     
Voucher.[Currency],  Voucher.Installment, Voucher.DueDate as DueDate, Voucher.AmountDue-Voucher.Payment_CC-Voucher.Payment_OC as Nominal,    
Voucher.Remarks as AName, Profile.Name, Voucher.debtorF,Voucher.CreditorF, Admlink.RefType,Voucher.Branch, Admlink.A_PolicyNo, Admlink.EXTRA_4  
from ProAcc,[Profile], Voucher_AmountWPCDue(@P_EDate) Voucher, AdmLink  
where  Voucher.Voucher=AdmLink.Voucher     
and ProAcc.ProAcc=Voucher.ProAcc     
and ProAcc.[ID]=[Profile].[ID]     
and ((Admlink.Type in ('OP') and Admlink.Amount_8<>0) or (Admlink.Type in ('DI','SO') and Admlink.Amount_7+Admlink.Amount_12+Admlink.Amount_15=Admlink.Amount)) -- Claim Salvage/Excess      
and Upper(AdmLink.Subject)='CLAIM' and Upper(Admlink.Extra_3)='REFUND'
and round(Voucher.AmountDue - (Voucher.Payment_CC+Voucher.Payment_OC),2)>0 and Voucher.DueDate between @P_SDate and @P_EDate    
    
and Voucher.Voucher in (Select CollectionV.Voucher from CollectionV, CollectionH Where CollectionH.CollNo=CollectionV.CollNo and CollectionH.CollStatus='C' and CollectionV.Hold<>0 and CollectionV.Voucher=Voucher.Voucher)    
and Admlink.A_ID Like @P_ID+'%'      
)      





GO

/****** Object:  UserDefinedFunction [dbo].[DB_F_DISBURSE_NOT_CLAIM_CLAIMANT]    Script Date: 5/25/2022 11:06:24 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO




CREATE function [dbo].[DB_F_DISBURSE_NOT_CLAIM_CLAIMANT](@P_SDate as smalldatetime, @P_EDate as SmallDateTime, @P_ID as Varchar(255))    
RETURNS TABLE    
AS RETURN    
(    
select distinct  Voucher.RefNo as RefNo, Voucher.Voucher, Admlink.Type, Admlink.Code, Admlink.BatchNo, Admlink.Bank, Admlink.Date, Admlink.Subject, Voucher.DocNo, Voucher.StatID, Voucher.ActionBy, Voucher.ActionDate, Voucher.AcceptedBy, Voucher.AcceptedDate,     
Voucher.[Currency],  Voucher.Installment, Voucher.DueDate as DueDate, Voucher.Nominal_CC-Voucher.Diff_CC-Voucher.Payment_CC-Voucher.Payment_OC as Nominal,    
Voucher.Remarks as AName, Profile.Name, Voucher.debtorF,Voucher.CreditorF, Admlink.RefType,Voucher.Branch, Admlink.A_PolicyNo, Admlink.EXTRA_4  
from ProAcc,[Profile], nVoucher Voucher, AdmLink  
where  Voucher.Voucher=AdmLink.Voucher     
and ProAcc.ProAcc=Voucher.ProAcc     
and ProAcc.[ID]=[Profile].[ID]     
and Admlink.Type in ('DI','IC','CF','JP','SO','OP')    
and Not ((Admlink.Type in ('OP') and Admlink.Amount_8<>0) or (Admlink.Type in ('DI','SO') and Admlink.Amount_7+Admlink.Amount_12+Admlink.Amount_15=Admlink.Amount)) -- Not Claim Salvage/Excess      
and Upper(AdmLink.Subject)='CLAIM'  
and Admlink.BillDate between @P_SDate and @P_EDate
and Admlink.A_ID Like @P_ID+'%'
and round(Voucher.Nominal_CC-Voucher.Diff_CC - (Voucher.Payment_CC+Voucher.Payment_OC),2)>0   
and Not Exists (Select Top 1 CollectionV.Voucher from CollectionV, CollectionH Where CollectionH.CollNo=CollectionV.COllNo and CollectionH.CollStatus<>'C' and CollectionV.CollNo<>Voucher.CollNo and CollectionV.Voucher=Voucher.Voucher)   
and Not Exists (Select Top 1 SL.doc_no from SL_Request SL, Request R Where R.Status<>'C' and R.Voucher='' and R.Request=SL.Request and SL.doc_no=Voucher.Voucher)

)    
  




GO

/****** Object:  UserDefinedFunction [dbo].[DB_F_DISBURSE_NOT_EXCESSREFUND_CLAIMANT]    Script Date: 5/25/2022 11:06:24 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO




CREATE function [dbo].[DB_F_DISBURSE_NOT_EXCESSREFUND_CLAIMANT](@P_SDate as smalldatetime, @P_EDate as SmallDateTime, @P_ID as Varchar(255))    
RETURNS TABLE    
AS RETURN    
(    
select distinct  Voucher.RefNo as RefNo, Voucher.Voucher, Admlink.Type, Admlink.Code, Admlink.BatchNo, Admlink.Bank, Admlink.Date, Admlink.Subject, Voucher.DocNo, Voucher.StatID, Voucher.ActionBy, Voucher.ActionDate, Voucher.AcceptedBy, Voucher.AcceptedDate,     
Voucher.[Currency],  Voucher.Installment, Voucher.DueDate as DueDate, Voucher.AmountDue-Voucher.Payment_CC-Voucher.Payment_OC as Nominal,    
Voucher.Remarks as AName, Profile.Name, Voucher.debtorF,Voucher.CreditorF, Admlink.RefType,Voucher.Branch, Admlink.A_PolicyNo, Admlink.EXTRA_4  
from ProAcc,[Profile], Voucher_AmountWPCDue(@P_EDate) Voucher, AdmLink  
where  Voucher.Voucher=AdmLink.Voucher     
and ProAcc.ProAcc=Voucher.ProAcc     
and ProAcc.[ID]=[Profile].[ID]     
and ((Admlink.Type in ('OP') and Admlink.Amount_8<>0) or (Admlink.Type in ('DI','SO') and Admlink.Amount_7+Admlink.Amount_12+Admlink.Amount_15=Admlink.Amount)) -- Claim Salvage/Excess      
and Upper(AdmLink.Subject)='CLAIM' and Upper(Admlink.Extra_3)='REFUND'
and round(Voucher.AmountDue - (Voucher.Payment_CC+Voucher.Payment_OC),2)>0 and Voucher.DueDate between @P_SDate and @P_EDate    
    
and Admlink.A_ID Like @P_ID+'%'    
and Not Exists (Select Top 1 CollectionV.Voucher from CollectionV, CollectionH Where CollectionH.CollNo=CollectionV.COllNo and CollectionH.CollStatus<>'C' and CollectionV.CollNo<>Voucher.CollNo and CollectionV.Voucher=Voucher.Voucher)   
and Not Exists (Select Top 1 SL.doc_no from SL_Request SL, Request R Where R.Status<>'C' and R.Voucher='' and R.Request=SL.Request and SL.doc_no=Voucher.Voucher)

)    
  




GO

/****** Object:  UserDefinedFunction [dbo].[DB_F_DISBURSE_UNPAID_CLAIM_CLAIMANT]    Script Date: 5/25/2022 11:06:24 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO




CREATE function [dbo].[DB_F_DISBURSE_UNPAID_CLAIM_CLAIMANT](@P_SDate as smalldatetime, @P_EDate as SmallDateTime, @P_ID as Varchar(255))    
RETURNS TABLE    
AS RETURN    
(    
select distinct  Voucher.RefNo as RefNo, Voucher.Voucher, Admlink.Type, Admlink.Code, Admlink.BatchNo, Admlink.Bank, Admlink.Date, Admlink.Subject, Voucher.DocNo, Voucher.StatID, Voucher.ActionBy, Voucher.ActionDate, Voucher.AcceptedBy, Voucher.AcceptedDate,     
Voucher.[Currency],  Voucher.Installment, Voucher.DueDate as DueDate, Voucher.Nominal_CC-Voucher.Diff_CC-Voucher.Payment_CC-Voucher.Payment_OC as Nominal,    
Voucher.Remarks as AName, Profile.Name, Voucher.debtorF,Voucher.CreditorF, Admlink.RefType,Voucher.Branch, Admlink.A_PolicyNo, Admlink.EXTRA_4  
from ProAcc,[Profile], nVoucher Voucher, AdmLink  
where  Voucher.Voucher=AdmLink.Voucher     
and ProAcc.ProAcc=Voucher.ProAcc     
and ProAcc.[ID]=[Profile].[ID]     
and Admlink.Type in ('DI','IC','CF','JP','SO','OP')    
and Not ((Admlink.Type in ('OP') and Admlink.Amount_8<>0) or (Admlink.Type in ('DI','SO') and Admlink.Amount_7+Admlink.Amount_12+Admlink.Amount_15=Admlink.Amount)) -- Not Claim Salvage/Excess      
and Upper(AdmLink.Subject)='CLAIM'  
and Admlink.BillDate between @P_SDate and @P_EDate
and Admlink.A_ID Like @P_ID+'%'
and round(Voucher.Nominal_CC-Voucher.Diff_CC - (Voucher.Payment_CC+Voucher.Payment_OC),2)>0   
and Voucher.Voucher in (Select CollectionV.Voucher from CollectionV, CollectionH Where CollectionH.CollNo=CollectionV.CollNo and CollectionH.CollStatus='C' and CollectionV.Paid=0 and CollectionV.Voucher=Voucher.Voucher)    
and Not Exists (Select Top 1 CollectionV.Voucher from CollectionV, CollectionH Where CollectionH.CollNo=CollectionV.COllNo and CollectionH.CollStatus<>'C' and CollectionV.CollNo<>Voucher.CollNo and CollectionV.Voucher=Voucher.Voucher)   
and Not Exists (Select Top 1 SL.doc_no from SL_Request SL, Request R Where R.Status<>'C' and R.Voucher='' and R.Request=SL.Request and SL.doc_no=Voucher.Voucher)

)   
  
  
  
  
  



GO

/****** Object:  UserDefinedFunction [dbo].[DB_F_DISBURSE_UNPAID_EXCESSREFUND_CLAIMANT]    Script Date: 5/25/2022 11:06:24 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO




CREATE function [dbo].[DB_F_DISBURSE_UNPAID_EXCESSREFUND_CLAIMANT](@P_SDate as smalldatetime, @P_EDate as SmallDateTime, @P_ID as Varchar(255))    
RETURNS TABLE    
AS RETURN    
(    
select distinct  Voucher.RefNo as RefNo, Voucher.Voucher, Admlink.Type, Admlink.Code, Admlink.BatchNo, Admlink.Bank, Admlink.Date, Admlink.Subject, Voucher.DocNo, Voucher.StatID, Voucher.ActionBy, Voucher.ActionDate, Voucher.AcceptedBy, Voucher.AcceptedDate,     
Voucher.[Currency],  Voucher.Installment, Voucher.DueDate as DueDate, Voucher.AmountDue-Voucher.Payment_CC-Voucher.Payment_OC as Nominal,    
Voucher.Remarks as AName, Profile.Name, Voucher.debtorF,Voucher.CreditorF, Admlink.RefType,Voucher.Branch, Admlink.A_PolicyNo, Admlink.EXTRA_4  
from ProAcc,[Profile], Voucher_AmountWPCDue(@P_EDate) Voucher, AdmLink  
where  Voucher.Voucher=AdmLink.Voucher     
and ProAcc.ProAcc=Voucher.ProAcc     
and ProAcc.[ID]=[Profile].[ID]     
and ((Admlink.Type in ('OP') and Admlink.Amount_8<>0) or (Admlink.Type in ('DI','SO') and Admlink.Amount_7+Admlink.Amount_12+Admlink.Amount_15=Admlink.Amount)) -- Claim Salvage/Excess      
and Upper(AdmLink.Subject)='CLAIM' and Upper(Admlink.Extra_3)='REFUND'
and round(Voucher.AmountDue - (Voucher.Payment_CC+Voucher.Payment_OC),2)>0 and Voucher.DueDate between @P_SDate and @P_EDate    
    
and Voucher.Voucher in (Select CollectionV.Voucher from CollectionV, CollectionH Where CollectionH.CollNo=CollectionV.CollNo and CollectionH.CollStatus='C' and CollectionV.Paid=0 and CollectionV.Voucher=Voucher.Voucher)    
and Admlink.A_ID Like @P_ID+'%'      
and Not Exists (Select Top 1 CollectionV.Voucher from CollectionV, CollectionH Where CollectionH.CollNo=CollectionV.COllNo and CollectionH.CollStatus<>'C' and CollectionV.CollNo<>Voucher.CollNo and CollectionV.Voucher=Voucher.Voucher)   
and Not Exists (Select Top 1 SL.doc_no from SL_Request SL, Request R Where R.Status<>'C' and R.Voucher='' and R.Request=SL.Request and SL.doc_no=Voucher.Voucher)

)   
  




GO

/****** Object:  UserDefinedFunction [dbo].[DB_I_DISBURSE_ALL_CLAIM_CLAIMANT]    Script Date: 5/25/2022 11:06:24 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO




CREATE FUNCTION [dbo].[DB_I_DISBURSE_ALL_CLAIM_CLAIMANT](@P_SDate as smalldatetime, @P_EDate as SmallDateTime)    
RETURNS TABLE    
AS RETURN    
(    
select distinct  Voucher.RefNo as RefNo, Voucher.Voucher, Admlink.Type, Admlink.Code, Admlink.BatchNo, Admlink.Bank, Admlink.Date, Admlink.Subject, Voucher.DocNo, Voucher.StatID, Voucher.ActionBy, Voucher.ActionDate, Voucher.AcceptedBy, Voucher.AcceptedDate,     
Voucher.[Currency],  Voucher.Installment, Voucher.DueDate as DueDate, Voucher.AmountDue-Voucher.Payment_CC-Voucher.Payment_OC as Nominal,    
Profile.Name+'-'+Voucher.Remarks as AName, Profile.Name, Voucher.debtorF,Voucher.CreditorF, Admlink.RefType,Voucher.Branch, Admlink.A_PolicyNo, Admlink.EXTRA_4  
from ProAcc,[Profile],Voucher_AmountWPCDue(@P_EDate) Voucher,AdmLink  
where  Voucher.Voucher=AdmLink.Voucher     
and ProAcc.ProAcc=Voucher.ProAcc     
and ProAcc.[ID]=[Profile].[ID]     
and Admlink.Type in ('DI','IC','CF','JP','SO','OP')    
and Not ((Admlink.Type in ('OP') and Admlink.Amount_8<>0) or (Admlink.Type in ('DI','SO') and Admlink.Amount_7+Admlink.Amount_12+Admlink.Amount_15=Admlink.Amount)) -- Not Claim Salvage/Excess      
and Upper(AdmLink.Subject)='CLAIM'  
and Admlink.BillDate between @P_SDate and @P_EDate 
and round(Voucher.AmountDue - (Voucher.Payment_CC+Voucher.Payment_OC),2)>0 
    
and Not Exists (Select Top 1 CollectionV.Voucher from CollectionV, CollectionH Where CollectionH.CollNo=CollectionV.COllNo and CollectionH.CollStatus<>'C' and CollectionV.CollNo<>Voucher.CollNo and CollectionV.Voucher=Voucher.Voucher)   
and Not Exists (Select Top 1 SL.doc_no from SL_Request SL, Request R Where R.Status<>'C' and R.Voucher='' and R.Request=SL.Request and SL.doc_no=Voucher.Voucher)

)    





GO

/****** Object:  UserDefinedFunction [dbo].[DB_I_DISBURSE_ALL_CLAIM_ID]    Script Date: 5/25/2022 11:06:24 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO




CREATE FUNCTION [dbo].[DB_I_DISBURSE_ALL_CLAIM_ID](@P_SDate as smalldatetime, @P_EDate as SmallDateTime,@P_ID as varchar(10))    
RETURNS TABLE    
AS RETURN    
(    
select distinct  Voucher.RefNo as RefNo, Voucher.Voucher, Admlink.Type, Admlink.Code, Admlink.BatchNo, Admlink.Bank, Admlink.Date, Admlink.Subject, Voucher.DocNo, Voucher.StatID, Voucher.ActionBy, Voucher.ActionDate, Voucher.AcceptedBy, Voucher.AcceptedDate,     
Voucher.[Currency],  Voucher.Installment, Voucher.DueDate as DueDate, Voucher.AmountDue-Voucher.Payment_CC-Voucher.Payment_OC as Nominal,    
Profile.Name+'-'+Voucher.Remarks as AName, Profile.Name, Voucher.debtorF,Voucher.CreditorF, Admlink.RefType,Voucher.Branch, Admlink.A_PolicyNo, Admlink.EXTRA_4  
from ProAcc,[Profile],Voucher_AmountWPCDue(@P_EDate) Voucher,AdmLink  
where  Voucher.Voucher=AdmLink.Voucher     
and ProAcc.ProAcc=Voucher.ProAcc     
and ProAcc.[ID]=[Profile].[ID]     
and Admlink.Type in ('DI','IC','CF','JP','SO','OP')    
and Not ((Admlink.Type in ('OP') and Admlink.Amount_8<>0) or (Admlink.Type in ('DI','SO') and Admlink.Amount_7+Admlink.Amount_12+Admlink.Amount_15=Admlink.Amount)) -- Not Claim Salvage/Excess      
and Upper(AdmLink.Subject)='CLAIM'  
and Admlink.BillDate between @P_SDate and @P_EDate 
and round(Voucher.AmountDue - (Voucher.Payment_CC+Voucher.Payment_OC),2)>0 
 and AdmLink.ID Like @P_ID+'%'  
    
and Not Exists (Select Top 1 CollectionV.Voucher from CollectionV, CollectionH Where CollectionH.CollNo=CollectionV.COllNo and CollectionH.CollStatus<>'C' and CollectionV.CollNo<>Voucher.CollNo and CollectionV.Voucher=Voucher.Voucher)   
and Not Exists (Select Top 1 SL.doc_no from SL_Request SL, Request R Where R.Status<>'C' and R.Voucher='' and R.Request=SL.Request and SL.doc_no=Voucher.Voucher)

)    
  




GO

/****** Object:  UserDefinedFunction [dbo].[DB_I_DISBURSE_ALL_EXCESSREFUND_CLAIMANT]    Script Date: 5/25/2022 11:06:24 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO




CREATE FUNCTION [dbo].[DB_I_DISBURSE_ALL_EXCESSREFUND_CLAIMANT](@P_SDate as smalldatetime, @P_EDate as SmallDateTime)    
RETURNS TABLE    
AS RETURN    
(    
select distinct  Voucher.RefNo as RefNo, Voucher.Voucher, Admlink.Type, Admlink.Code, Admlink.BatchNo, Admlink.Bank, Admlink.Date, Admlink.Subject, Voucher.DocNo, Voucher.StatID, Voucher.ActionBy, Voucher.ActionDate, Voucher.AcceptedBy, Voucher.AcceptedDate,     
Voucher.[Currency],  Voucher.Installment, Voucher.DueDate as DueDate, Voucher.AmountDue-Voucher.Payment_CC-Voucher.Payment_OC as Nominal,    
Profile.Name+'-'+Voucher.Remarks as AName, Profile.Name, Voucher.debtorF,Voucher.CreditorF, Admlink.RefType,Voucher.Branch, Admlink.A_PolicyNo, Admlink.EXTRA_4  
from ProAcc,[Profile],Voucher_AmountWPCDue(@P_EDate) Voucher,AdmLink  
where  Voucher.Voucher=AdmLink.Voucher     
and ProAcc.ProAcc=Voucher.ProAcc     
and ProAcc.[ID]=[Profile].[ID]     
and ((Admlink.Type in ('OP') and Admlink.Amount_8<>0) or (Admlink.Type in ('DI','SO') and Admlink.Amount_7+Admlink.Amount_12+Admlink.Amount_15=Admlink.Amount)) -- Claim Salvage/Excess      
and Upper(AdmLink.Subject)='CLAIM' and Upper(Admlink.Extra_3)='REFUND'
and round(Voucher.AmountDue - (Voucher.Payment_CC+Voucher.Payment_OC),2)>0 and Voucher.DueDate between @P_SDate and @P_EDate    
    
and Not Exists (Select Top 1 CollectionV.Voucher from CollectionV, CollectionH Where CollectionH.CollNo=CollectionV.COllNo and CollectionH.CollStatus<>'C' and CollectionV.CollNo<>Voucher.CollNo and CollectionV.Voucher=Voucher.Voucher)   
and Not Exists (Select Top 1 SL.doc_no from SL_Request SL, Request R Where R.Status<>'C' and R.Voucher='' and R.Request=SL.Request and SL.doc_no=Voucher.Voucher)

)    





GO

/****** Object:  UserDefinedFunction [dbo].[DB_I_DISBURSE_ALL_EXCESSREFUND_ID]    Script Date: 5/25/2022 11:06:24 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO




CREATE FUNCTION [dbo].[DB_I_DISBURSE_ALL_EXCESSREFUND_ID](@P_SDate as smalldatetime, @P_EDate as SmallDateTime,@P_ID as varchar(10))    
RETURNS TABLE    
AS RETURN    
(    
select distinct  Voucher.RefNo as RefNo, Voucher.Voucher, Admlink.Type, Admlink.Code, Admlink.BatchNo, Admlink.Bank, Admlink.Date, Admlink.Subject, Voucher.DocNo, Voucher.StatID, Voucher.ActionBy, Voucher.ActionDate, Voucher.AcceptedBy, Voucher.AcceptedDate,     
Voucher.[Currency],  Voucher.Installment, Voucher.DueDate as DueDate, Voucher.AmountDue-Voucher.Payment_CC-Voucher.Payment_OC as Nominal,    
Profile.Name+'-'+Voucher.Remarks as AName, Profile.Name, Voucher.debtorF,Voucher.CreditorF, Admlink.RefType,Voucher.Branch, Admlink.A_PolicyNo, Admlink.EXTRA_4  
from ProAcc,[Profile],Voucher_AmountWPCDue(@P_EDate) Voucher,AdmLink  
where  Voucher.Voucher=AdmLink.Voucher     
and ProAcc.ProAcc=Voucher.ProAcc     
and ProAcc.[ID]=[Profile].[ID]     
and ((Admlink.Type in ('OP') and Admlink.Amount_8<>0) or (Admlink.Type in ('DI','SO') and Admlink.Amount_7+Admlink.Amount_12+Admlink.Amount_15=Admlink.Amount)) -- Claim Salvage/Excess      
and Upper(AdmLink.Subject)='CLAIM' and Upper(Admlink.Extra_3)='REFUND'
and round(Voucher.AmountDue - (Voucher.Payment_CC+Voucher.Payment_OC),2)>0 and Voucher.DueDate between @P_SDate and @P_EDate    
 and AdmLink.ID Like @P_ID+'%'  
    
and Not Exists (Select Top 1 CollectionV.Voucher from CollectionV, CollectionH Where CollectionH.CollNo=CollectionV.COllNo and CollectionH.CollStatus<>'C' and CollectionV.CollNo<>Voucher.CollNo and CollectionV.Voucher=Voucher.Voucher)   
and Not Exists (Select Top 1 SL.doc_no from SL_Request SL, Request R Where R.Status<>'C' and R.Voucher='' and R.Request=SL.Request and SL.doc_no=Voucher.Voucher)

)    
  




GO

/****** Object:  UserDefinedFunction [dbo].[DB_I_DISBURSE_HOLD_CLAIM_CLAIMANT]    Script Date: 5/25/2022 11:06:24 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO




CREATE function [dbo].[DB_I_DISBURSE_HOLD_CLAIM_CLAIMANT](@P_SDate as smalldatetime, @P_EDate as SmallDateTime)    
RETURNS TABLE    
AS RETURN    
(    
   
select distinct  Voucher.RefNo as RefNo, Voucher.Voucher, Admlink.Type, Admlink.Code, Admlink.BatchNo, Admlink.Bank, Admlink.Date, Admlink.Subject, Voucher.DocNo, Voucher.StatID, Voucher.ActionBy, Voucher.ActionDate, Voucher.AcceptedBy, Voucher.AcceptedDate,     
Voucher.[Currency],  Voucher.Installment, Voucher.DueDate as DueDate, Voucher.AmountDue-Voucher.Payment_CC-Voucher.Payment_OC as Nominal,    
Profile.Name+'-'+Voucher.Remarks as AName, Profile.Name, Voucher.debtorF,Voucher.CreditorF, Admlink.RefType,Voucher.Branch, Admlink.A_PolicyNo, Admlink.EXTRA_4  
from ProAcc,[Profile],Voucher_AmountWPCDue(@P_EDate) Voucher,AdmLink  
where  Voucher.Voucher=AdmLink.Voucher     
and ProAcc.ProAcc=Voucher.ProAcc     
and ProAcc.[ID]=[Profile].[ID]     
and Admlink.Type in ('DI','IC','CF','JP','SO','OP')    
and Not ((Admlink.Type in ('OP') and Admlink.Amount_8<>0) or (Admlink.Type in ('DI','SO') and Admlink.Amount_7+Admlink.Amount_12+Admlink.Amount_15=Admlink.Amount)) -- Not Claim Salvage/Excess      
and Upper(AdmLink.Subject)='CLAIM'  
and Admlink.BillDate between @P_SDate and @P_EDate 
and round(Voucher.AmountDue - (Voucher.Payment_CC+Voucher.Payment_OC),2)>0 
    
and Voucher.Voucher in (Select CollectionV.Voucher from CollectionV, CollectionH Where CollectionH.CollNo=CollectionV.CollNo and CollectionH.CollStatus='C' and CollectionV.Hold<>0 and CollectionV.Voucher=Voucher.Voucher)    
)    
    




GO

/****** Object:  UserDefinedFunction [dbo].[DB_I_DISBURSE_HOLD_CLAIM_ID]    Script Date: 5/25/2022 11:06:24 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO




CREATE function [dbo].[DB_I_DISBURSE_HOLD_CLAIM_ID](@P_SDate as smalldatetime, @P_EDate as SmallDateTime,@P_ID as varchar(10))    
RETURNS TABLE    
AS RETURN    
(    
   
select distinct  Voucher.RefNo as RefNo, Voucher.Voucher, Admlink.Type, Admlink.Code, Admlink.BatchNo, Admlink.Bank, Admlink.Date, Admlink.Subject, Voucher.DocNo, Voucher.StatID, Voucher.ActionBy, Voucher.ActionDate, Voucher.AcceptedBy, Voucher.AcceptedDate,     
Voucher.[Currency],  Voucher.Installment, Voucher.DueDate as DueDate, Voucher.AmountDue-Voucher.Payment_CC-Voucher.Payment_OC as Nominal,    
Profile.Name+'-'+Voucher.Remarks as AName, Profile.Name, Voucher.debtorF,Voucher.CreditorF, Admlink.RefType,Voucher.Branch, Admlink.A_PolicyNo, Admlink.EXTRA_4  
from ProAcc,[Profile],Voucher_AmountWPCDue(@P_EDate) Voucher,AdmLink  
where  Voucher.Voucher=AdmLink.Voucher     
and ProAcc.ProAcc=Voucher.ProAcc     
and ProAcc.[ID]=[Profile].[ID]     
and Admlink.Type in ('DI','IC','CF','JP','SO','OP')    
and Not ((Admlink.Type in ('OP') and Admlink.Amount_8<>0) or (Admlink.Type in ('DI','SO') and Admlink.Amount_7+Admlink.Amount_12+Admlink.Amount_15=Admlink.Amount)) -- Not Claim Salvage/Excess      
and Upper(AdmLink.Subject)='CLAIM'  
and Admlink.BillDate between @P_SDate and @P_EDate  
and round(Voucher.AmountDue - (Voucher.Payment_CC+Voucher.Payment_OC),2)>0 
and AdmLink.ID Like @P_ID+'%'  
    
and Voucher.Voucher in (Select CollectionV.Voucher from CollectionV, CollectionH Where CollectionH.CollNo=CollectionV.CollNo and CollectionH.CollStatus='C' and CollectionV.Hold<>0 and CollectionV.Voucher=Voucher.Voucher)    
)    
    




GO

/****** Object:  UserDefinedFunction [dbo].[DB_I_DISBURSE_HOLD_EXCESSREFUND_CLAIMANT]    Script Date: 5/25/2022 11:06:24 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO




CREATE function [dbo].[DB_I_DISBURSE_HOLD_EXCESSREFUND_CLAIMANT](@P_SDate as smalldatetime, @P_EDate as SmallDateTime)    
RETURNS TABLE    
AS RETURN    
(    
   
select distinct  Voucher.RefNo as RefNo, Voucher.Voucher, Admlink.Type, Admlink.Code, Admlink.BatchNo, Admlink.Bank, Admlink.Date, Admlink.Subject, Voucher.DocNo, Voucher.StatID, Voucher.ActionBy, Voucher.ActionDate, Voucher.AcceptedBy, Voucher.AcceptedDate,     
Voucher.[Currency],  Voucher.Installment, Voucher.DueDate as DueDate, Voucher.AmountDue-Voucher.Payment_CC-Voucher.Payment_OC as Nominal,    
Profile.Name+'-'+Voucher.Remarks as AName, Profile.Name, Voucher.debtorF,Voucher.CreditorF, Admlink.RefType,Voucher.Branch, Admlink.A_PolicyNo, Admlink.EXTRA_4  
from ProAcc,[Profile],Voucher_AmountWPCDue(@P_EDate) Voucher,AdmLink  
where  Voucher.Voucher=AdmLink.Voucher     
and ProAcc.ProAcc=Voucher.ProAcc     
and ProAcc.[ID]=[Profile].[ID]     
and ((Admlink.Type in ('OP') and Admlink.Amount_8<>0) or (Admlink.Type in ('DI','SO') and Admlink.Amount_7+Admlink.Amount_12+Admlink.Amount_15=Admlink.Amount)) -- Claim Salvage/Excess      
and Upper(AdmLink.Subject)='CLAIM' and Upper(Admlink.Extra_3)='REFUND'
and round(Voucher.AmountDue - (Voucher.Payment_CC+Voucher.Payment_OC),2)>0 and Voucher.DueDate between @P_SDate and @P_EDate    
    
and Voucher.Voucher in (Select CollectionV.Voucher from CollectionV, CollectionH Where CollectionH.CollNo=CollectionV.CollNo and CollectionH.CollStatus='C' and CollectionV.Hold<>0 and CollectionV.Voucher=Voucher.Voucher)    
)    
    




GO

/****** Object:  UserDefinedFunction [dbo].[DB_I_DISBURSE_HOLD_EXCESSREFUND_ID]    Script Date: 5/25/2022 11:06:24 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO




CREATE function [dbo].[DB_I_DISBURSE_HOLD_EXCESSREFUND_ID](@P_SDate as smalldatetime, @P_EDate as SmallDateTime,@P_ID as varchar(10))    
RETURNS TABLE    
AS RETURN    
(    
   
select distinct  Voucher.RefNo as RefNo, Voucher.Voucher, Admlink.Type, Admlink.Code, Admlink.BatchNo, Admlink.Bank, Admlink.Date, Admlink.Subject, Voucher.DocNo, Voucher.StatID, Voucher.ActionBy, Voucher.ActionDate, Voucher.AcceptedBy, Voucher.AcceptedDate,     
Voucher.[Currency],  Voucher.Installment, Voucher.DueDate as DueDate, Voucher.AmountDue-Voucher.Payment_CC-Voucher.Payment_OC as Nominal,    
Profile.Name+'-'+Voucher.Remarks as AName, Profile.Name, Voucher.debtorF,Voucher.CreditorF, Admlink.RefType,Voucher.Branch, Admlink.A_PolicyNo, Admlink.EXTRA_4  
from ProAcc,[Profile],Voucher_AmountWPCDue(@P_EDate) Voucher,AdmLink  
where  Voucher.Voucher=AdmLink.Voucher     
and ProAcc.ProAcc=Voucher.ProAcc     
and ProAcc.[ID]=[Profile].[ID]     
and ((Admlink.Type in ('OP') and Admlink.Amount_8<>0) or (Admlink.Type in ('DI','SO') and Admlink.Amount_7+Admlink.Amount_12+Admlink.Amount_15=Admlink.Amount)) -- Claim Salvage/Excess      
and Upper(AdmLink.Subject)='CLAIM' and Upper(Admlink.Extra_3)='REFUND'
and round(Voucher.AmountDue - (Voucher.Payment_CC+Voucher.Payment_OC),2)>0 and Voucher.DueDate between @P_SDate and @P_EDate    
and AdmLink.ID Like @P_ID+'%'  
    
and Voucher.Voucher in (Select CollectionV.Voucher from CollectionV, CollectionH Where CollectionH.CollNo=CollectionV.CollNo and CollectionH.CollStatus='C' and CollectionV.Hold<>0 and CollectionV.Voucher=Voucher.Voucher)    
)    
    




GO

/****** Object:  UserDefinedFunction [dbo].[DB_I_DISBURSE_NOT_CLAIM_CLAIMANT]    Script Date: 5/25/2022 11:06:24 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO




CREATE function [dbo].[DB_I_DISBURSE_NOT_CLAIM_CLAIMANT](@P_SDate as smalldatetime, @P_EDate as SmallDateTime)    
RETURNS TABLE    
AS RETURN    
(    
select distinct  Voucher.RefNo as RefNo, Voucher.Voucher, Admlink.Type, Admlink.Code, Admlink.BatchNo, Admlink.Bank, Admlink.Date, Admlink.Subject, Voucher.DocNo, Voucher.StatID, Voucher.ActionBy, Voucher.ActionDate, Voucher.AcceptedBy, Voucher.AcceptedDate,     
Voucher.[Currency],  Voucher.Installment, Voucher.DueDate as DueDate, Voucher.AmountDue-Voucher.Payment_CC-Voucher.Payment_OC as Nominal,    
Profile.Name+'-'+Voucher.Remarks as AName, Profile.Name, Voucher.debtorF,Voucher.CreditorF, Admlink.RefType,Voucher.Branch, Admlink.A_PolicyNo, Admlink.EXTRA_4  
from ProAcc,[Profile],Voucher_AmountWPCDue(@P_EDate) Voucher,AdmLink  
where  Voucher.Voucher=AdmLink.Voucher     
and ProAcc.ProAcc=Voucher.ProAcc     
and ProAcc.[ID]=[Profile].[ID]     
and Admlink.Type in ('DI','IC','CF','JP','SO','OP')    
and Not ((Admlink.Type in ('OP') and Admlink.Amount_8<>0) or (Admlink.Type in ('DI','SO') and Admlink.Amount_7+Admlink.Amount_12+Admlink.Amount_15=Admlink.Amount)) -- Not Claim Salvage/Excess      
and Upper(AdmLink.Subject)='CLAIM'  
and Admlink.BillDate between @P_SDate and @P_EDate  
and round(Voucher.AmountDue - (Voucher.Payment_CC+Voucher.Payment_OC),2)>0 
    
and Not Exists (Select Top 1 CollectionV.Voucher from CollectionV, CollectionH Where CollectionH.CollNo=CollectionV.COllNo and CollectionH.CollStatus<>'C' and CollectionV.CollNo<>Voucher.CollNo and CollectionV.Voucher=Voucher.Voucher)   
and Not Exists (Select Top 1 SL.doc_no from SL_Request SL, Request R Where R.Status<>'C' and R.Voucher='' and R.Request=SL.Request and SL.doc_no=Voucher.Voucher)

)    
  




GO

/****** Object:  UserDefinedFunction [dbo].[DB_I_DISBURSE_NOT_CLAIM_ID]    Script Date: 5/25/2022 11:06:24 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO




CREATE function [dbo].[DB_I_DISBURSE_NOT_CLAIM_ID](@P_SDate as smalldatetime, @P_EDate as SmallDateTime,@P_ID as varchar(10))    
RETURNS TABLE    
AS RETURN    
(    
select distinct  Voucher.RefNo as RefNo, Voucher.Voucher, Admlink.Type, Admlink.Code, Admlink.BatchNo, Admlink.Bank, Admlink.Date, Admlink.Subject, Voucher.DocNo, Voucher.StatID, Voucher.ActionBy, Voucher.ActionDate, Voucher.AcceptedBy, Voucher.AcceptedDate,     
Voucher.[Currency],  Voucher.Installment, Voucher.DueDate as DueDate, Voucher.AmountDue-Voucher.Payment_CC-Voucher.Payment_OC as Nominal,    
Profile.Name+'-'+Voucher.Remarks as AName, Profile.Name, Voucher.debtorF,Voucher.CreditorF, Admlink.RefType,Voucher.Branch, Admlink.A_PolicyNo, Admlink.EXTRA_4  
from ProAcc,[Profile],Voucher_AmountWPCDue(@P_EDate) Voucher,AdmLink  
where  Voucher.Voucher=AdmLink.Voucher     
and ProAcc.ProAcc=Voucher.ProAcc     
and ProAcc.[ID]=[Profile].[ID]     
and Admlink.Type in ('DI','IC','CF','JP','SO','OP')    
and Not ((Admlink.Type in ('OP') and Admlink.Amount_8<>0) or (Admlink.Type in ('DI','SO') and Admlink.Amount_7+Admlink.Amount_12+Admlink.Amount_15=Admlink.Amount)) -- Not Claim Salvage/Excess      
and Upper(AdmLink.Subject)='CLAIM'  
and Admlink.BillDate between @P_SDate and @P_EDate 
and round(Voucher.AmountDue - (Voucher.Payment_CC+Voucher.Payment_OC),2)>0 
    
and AdmLink.ID Like @P_ID+'%'    
and Not Exists (Select Top 1 CollectionV.Voucher from CollectionV, CollectionH Where CollectionH.CollNo=CollectionV.COllNo and CollectionH.CollStatus<>'C' and CollectionV.CollNo<>Voucher.CollNo and CollectionV.Voucher=Voucher.Voucher)   
and Not Exists (Select Top 1 SL.doc_no from SL_Request SL, Request R Where R.Status<>'C' and R.Voucher='' and R.Request=SL.Request and SL.doc_no=Voucher.Voucher)

)    
      




GO

/****** Object:  UserDefinedFunction [dbo].[DB_I_DISBURSE_NOT_EXCESSREFUND_CLAIMANT]    Script Date: 5/25/2022 11:06:24 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO




CREATE function [dbo].[DB_I_DISBURSE_NOT_EXCESSREFUND_CLAIMANT](@P_SDate as smalldatetime, @P_EDate as SmallDateTime)    
RETURNS TABLE    
AS RETURN    
(    
select distinct  Voucher.RefNo as RefNo, Voucher.Voucher, Admlink.Type, Admlink.Code, Admlink.BatchNo, Admlink.Bank, Admlink.Date, Admlink.Subject, Voucher.DocNo, Voucher.StatID, Voucher.ActionBy, Voucher.ActionDate, Voucher.AcceptedBy, Voucher.AcceptedDate,     
Voucher.[Currency],  Voucher.Installment, Voucher.DueDate as DueDate, Voucher.AmountDue-Voucher.Payment_CC-Voucher.Payment_OC as Nominal,    
Profile.Name+'-'+Voucher.Remarks as AName, Profile.Name, Voucher.debtorF,Voucher.CreditorF, Admlink.RefType,Voucher.Branch, Admlink.A_PolicyNo, Admlink.EXTRA_4  
from ProAcc,[Profile],Voucher_AmountWPCDue(@P_EDate) Voucher,AdmLink  
where  Voucher.Voucher=AdmLink.Voucher     
and ProAcc.ProAcc=Voucher.ProAcc     
and ProAcc.[ID]=[Profile].[ID]     
and ((Admlink.Type in ('OP') and Admlink.Amount_8<>0) or (Admlink.Type in ('DI','SO') and Admlink.Amount_7+Admlink.Amount_12+Admlink.Amount_15=Admlink.Amount)) -- Claim Salvage/Excess      
and Upper(AdmLink.Subject)='CLAIM' and Upper(Admlink.Extra_3)='REFUND'
and round(Voucher.AmountDue - (Voucher.Payment_CC+Voucher.Payment_OC),2)>0 and Voucher.DueDate between @P_SDate and @P_EDate    
    
and Not Exists (Select Top 1 CollectionV.Voucher from CollectionV, CollectionH Where CollectionH.CollNo=CollectionV.COllNo and CollectionH.CollStatus<>'C' and CollectionV.CollNo<>Voucher.CollNo and CollectionV.Voucher=Voucher.Voucher)   
and Not Exists (Select Top 1 SL.doc_no from SL_Request SL, Request R Where R.Status<>'C' and R.Voucher='' and R.Request=SL.Request and SL.doc_no=Voucher.Voucher)

)    
  




GO

/****** Object:  UserDefinedFunction [dbo].[DB_I_DISBURSE_NOT_EXCESSREFUND_ID]    Script Date: 5/25/2022 11:06:24 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO




CREATE function [dbo].[DB_I_DISBURSE_NOT_EXCESSREFUND_ID](@P_SDate as smalldatetime, @P_EDate as SmallDateTime,@P_ID as varchar(10))    
RETURNS TABLE    
AS RETURN    
(    
select distinct  Voucher.RefNo as RefNo, Voucher.Voucher, Admlink.Type, Admlink.Code, Admlink.BatchNo, Admlink.Bank, Admlink.Date, Admlink.Subject, Voucher.DocNo, Voucher.StatID, Voucher.ActionBy, Voucher.ActionDate, Voucher.AcceptedBy, Voucher.AcceptedDate,     
Voucher.[Currency],  Voucher.Installment, Voucher.DueDate as DueDate, Voucher.AmountDue-Voucher.Payment_CC-Voucher.Payment_OC as Nominal,    
Profile.Name+'-'+Voucher.Remarks as AName, Profile.Name, Voucher.debtorF,Voucher.CreditorF, Admlink.RefType,Voucher.Branch, Admlink.A_PolicyNo, Admlink.EXTRA_4  
from ProAcc,[Profile],Voucher_AmountWPCDue(@P_EDate) Voucher,AdmLink  
where  Voucher.Voucher=AdmLink.Voucher     
and ProAcc.ProAcc=Voucher.ProAcc     
and ProAcc.[ID]=[Profile].[ID]     
and ((Admlink.Type in ('OP') and Admlink.Amount_8<>0) or (Admlink.Type in ('DI','SO') and Admlink.Amount_7+Admlink.Amount_12+Admlink.Amount_15=Admlink.Amount)) -- Claim Salvage/Excess      
and Upper(AdmLink.Subject)='CLAIM' and Upper(Admlink.Extra_3)='REFUND'
and round(Voucher.AmountDue - (Voucher.Payment_CC+Voucher.Payment_OC),2)>0 and Voucher.DueDate between @P_SDate and @P_EDate    
    
and AdmLink.ID Like @P_ID+'%'    
and Not Exists (Select Top 1 CollectionV.Voucher from CollectionV, CollectionH Where CollectionH.CollNo=CollectionV.COllNo and CollectionH.CollStatus<>'C' and CollectionV.CollNo<>Voucher.CollNo and CollectionV.Voucher=Voucher.Voucher)   
and Not Exists (Select Top 1 SL.doc_no from SL_Request SL, Request R Where R.Status<>'C' and R.Voucher='' and R.Request=SL.Request and SL.doc_no=Voucher.Voucher)

)    
      




GO

/****** Object:  UserDefinedFunction [dbo].[DB_I_DISBURSE_UNPAID_CLAIM_CLAIMANT]    Script Date: 5/25/2022 11:06:24 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO




CREATE function [dbo].[DB_I_DISBURSE_UNPAID_CLAIM_CLAIMANT](@P_SDate as smalldatetime, @P_EDate as SmallDateTime)    
RETURNS TABLE    
AS RETURN    
(    
select distinct  Voucher.RefNo as RefNo, Voucher.Voucher, Admlink.Type, Admlink.Code, Admlink.BatchNo, Admlink.Bank, Admlink.Date, Admlink.Subject, Voucher.DocNo, Voucher.StatID, Voucher.ActionBy, Voucher.ActionDate, Voucher.AcceptedBy, Voucher.AcceptedDate,     
Voucher.[Currency],  Voucher.Installment, Voucher.DueDate as DueDate, Voucher.AmountDue-Voucher.Payment_CC-Voucher.Payment_OC as Nominal,    
Profile.Name+'-'+Voucher.Remarks as AName, Profile.Name, Voucher.debtorF,Voucher.CreditorF, Admlink.RefType,Voucher.Branch, Admlink.A_PolicyNo, Admlink.EXTRA_4  
from ProAcc,[Profile],Voucher_AmountWPCDue(@P_EDate) Voucher,AdmLink  
where  Voucher.Voucher=AdmLink.Voucher     
and ProAcc.ProAcc=Voucher.ProAcc     
and ProAcc.[ID]=[Profile].[ID]     
and Admlink.Type in ('DI','IC','CF','JP','SO','OP')    
and Not ((Admlink.Type in ('OP') and Admlink.Amount_8<>0) or (Admlink.Type in ('DI','SO') and Admlink.Amount_7+Admlink.Amount_12+Admlink.Amount_15=Admlink.Amount)) -- Not Claim Salvage/Excess      
and Upper(AdmLink.Subject)='CLAIM'  
and Admlink.BillDate between @P_SDate and @P_EDate   
and round(Voucher.AmountDue - (Voucher.Payment_CC+Voucher.Payment_OC),2)>0 
    
and Voucher.Voucher in (Select CollectionV.Voucher from CollectionV, CollectionH Where CollectionH.CollNo=CollectionV.CollNo and CollectionH.CollStatus='C' and CollectionV.Paid=0 and CollectionV.Voucher=Voucher.Voucher)    
and Not Exists (Select Top 1 CollectionV.Voucher from CollectionV, CollectionH Where CollectionH.CollNo=CollectionV.COllNo and CollectionH.CollStatus<>'C' and CollectionV.CollNo<>Voucher.CollNo and CollectionV.Voucher=Voucher.Voucher)   
and Not Exists (Select Top 1 SL.doc_no from SL_Request SL, Request R Where R.Status<>'C' and R.Voucher='' and R.Request=SL.Request and SL.doc_no=Voucher.Voucher)

    
)    
    




GO

/****** Object:  UserDefinedFunction [dbo].[DB_I_DISBURSE_UNPAID_CLAIM_ID]    Script Date: 5/25/2022 11:06:24 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO




CREATE function [dbo].[DB_I_DISBURSE_UNPAID_CLAIM_ID](@P_SDate as smalldatetime, @P_EDate as SmallDateTime,@P_ID as varchar(10))    
RETURNS TABLE    
AS RETURN    
(    
select distinct  Voucher.RefNo as RefNo, Voucher.Voucher, Admlink.Type, Admlink.Code, Admlink.BatchNo, Admlink.Bank, Admlink.Date, Admlink.Subject, Voucher.DocNo, Voucher.StatID, Voucher.ActionBy, Voucher.ActionDate, Voucher.AcceptedBy, Voucher.AcceptedDate,     
Voucher.[Currency],  Voucher.Installment, Voucher.DueDate as DueDate, Voucher.AmountDue-Voucher.Payment_CC-Voucher.Payment_OC as Nominal,    
Profile.Name+'-'+Voucher.Remarks as AName, Profile.Name, Voucher.debtorF,Voucher.CreditorF, Admlink.RefType,Voucher.Branch, Admlink.A_PolicyNo, Admlink.EXTRA_4  
from ProAcc,[Profile],Voucher_AmountWPCDue(@P_EDate) Voucher,AdmLink  
where  Voucher.Voucher=AdmLink.Voucher     
and ProAcc.ProAcc=Voucher.ProAcc     
and ProAcc.[ID]=[Profile].[ID]     
and Admlink.Type in ('DI','IC','CF','JP','SO','OP')    
and Not ((Admlink.Type in ('OP') and Admlink.Amount_8<>0) or (Admlink.Type in ('DI','SO') and Admlink.Amount_7+Admlink.Amount_12+Admlink.Amount_15=Admlink.Amount)) -- Not Claim Salvage/Excess      
and Upper(AdmLink.Subject)='CLAIM'  
and Admlink.BillDate between @P_SDate and @P_EDate  
and round(Voucher.AmountDue - (Voucher.Payment_CC+Voucher.Payment_OC),2)>0 
    
and AdmLink.ID Like @P_ID+'%'  
and Voucher.Voucher in (Select CollectionV.Voucher from CollectionV, CollectionH Where CollectionH.CollNo=CollectionV.CollNo and CollectionH.CollStatus='C' and CollectionV.Paid=0 and CollectionV.Voucher=Voucher.Voucher)    
and Not Exists (Select Top 1 CollectionV.Voucher from CollectionV, CollectionH Where CollectionH.CollNo=CollectionV.COllNo and CollectionH.CollStatus<>'C' and CollectionV.CollNo<>Voucher.CollNo and CollectionV.Voucher=Voucher.Voucher)   
and Not Exists (Select Top 1 SL.doc_no from SL_Request SL, Request R Where R.Status<>'C' and R.Voucher='' and R.Request=SL.Request and SL.doc_no=Voucher.Voucher)

    
)    





GO

/****** Object:  UserDefinedFunction [dbo].[DB_I_DISBURSE_UNPAID_EXCESSREFUND_CLAIMANT]    Script Date: 5/25/2022 11:06:24 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO




CREATE function [dbo].[DB_I_DISBURSE_UNPAID_EXCESSREFUND_CLAIMANT](@P_SDate as smalldatetime, @P_EDate as SmallDateTime)    
RETURNS TABLE    
AS RETURN    
(    
select distinct  Voucher.RefNo as RefNo, Voucher.Voucher, Admlink.Type, Admlink.Code, Admlink.BatchNo, Admlink.Bank, Admlink.Date, Admlink.Subject, Voucher.DocNo, Voucher.StatID, Voucher.ActionBy, Voucher.ActionDate, Voucher.AcceptedBy, Voucher.AcceptedDate,     
Voucher.[Currency],  Voucher.Installment, Voucher.DueDate as DueDate, Voucher.AmountDue-Voucher.Payment_CC-Voucher.Payment_OC as Nominal,    
Profile.Name+'-'+Voucher.Remarks as AName, Profile.Name, Voucher.debtorF,Voucher.CreditorF, Admlink.RefType,Voucher.Branch, Admlink.A_PolicyNo, Admlink.EXTRA_4  
from ProAcc,[Profile],Voucher_AmountWPCDue(@P_EDate) Voucher,AdmLink  
where  Voucher.Voucher=AdmLink.Voucher     
and ProAcc.ProAcc=Voucher.ProAcc     
and ProAcc.[ID]=[Profile].[ID]     
and ((Admlink.Type in ('OP') and Admlink.Amount_8<>0) or (Admlink.Type in ('DI','SO') and Admlink.Amount_7+Admlink.Amount_12+Admlink.Amount_15=Admlink.Amount)) -- Claim Salvage/Excess      
and Upper(AdmLink.Subject)='CLAIM' and Upper(Admlink.Extra_3)='REFUND'
and round(Voucher.AmountDue - (Voucher.Payment_CC+Voucher.Payment_OC),2)>0 and Voucher.DueDate between @P_SDate and @P_EDate    
    
and Voucher.Voucher in (Select CollectionV.Voucher from CollectionV, CollectionH Where CollectionH.CollNo=CollectionV.CollNo and CollectionH.CollStatus='C' and CollectionV.Paid=0 and CollectionV.Voucher=Voucher.Voucher)    
and Not Exists (Select Top 1 CollectionV.Voucher from CollectionV, CollectionH Where CollectionH.CollNo=CollectionV.COllNo and CollectionH.CollStatus<>'C' and CollectionV.CollNo<>Voucher.CollNo and CollectionV.Voucher=Voucher.Voucher)   
and Not Exists (Select Top 1 SL.doc_no from SL_Request SL, Request R Where R.Status<>'C' and R.Voucher='' and R.Request=SL.Request and SL.doc_no=Voucher.Voucher)

    
)    
    




GO

/****** Object:  UserDefinedFunction [dbo].[DB_I_DISBURSE_UNPAID_EXCESSREFUND_ID]    Script Date: 5/25/2022 11:06:24 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO




CREATE function [dbo].[DB_I_DISBURSE_UNPAID_EXCESSREFUND_ID](@P_SDate as smalldatetime, @P_EDate as SmallDateTime,@P_ID as varchar(10))    
RETURNS TABLE    
AS RETURN    
(    
select distinct  Voucher.RefNo as RefNo, Voucher.Voucher, Admlink.Type, Admlink.Code, Admlink.BatchNo, Admlink.Bank, Admlink.Date, Admlink.Subject, Voucher.DocNo, Voucher.StatID, Voucher.ActionBy, Voucher.ActionDate, Voucher.AcceptedBy, Voucher.AcceptedDate,     
Voucher.[Currency],  Voucher.Installment, Voucher.DueDate as DueDate, Voucher.AmountDue-Voucher.Payment_CC-Voucher.Payment_OC as Nominal,    
Profile.Name+'-'+Voucher.Remarks as AName, Profile.Name, Voucher.debtorF,Voucher.CreditorF, Admlink.RefType,Voucher.Branch, Admlink.A_PolicyNo, Admlink.EXTRA_4  
from ProAcc,[Profile],Voucher_AmountWPCDue(@P_EDate) Voucher,AdmLink  
where  Voucher.Voucher=AdmLink.Voucher     
and ProAcc.ProAcc=Voucher.ProAcc     
and ProAcc.[ID]=[Profile].[ID]     
and ((Admlink.Type in ('OP') and Admlink.Amount_8<>0) or (Admlink.Type in ('DI','SO') and Admlink.Amount_7+Admlink.Amount_12+Admlink.Amount_15=Admlink.Amount)) -- Claim Salvage/Excess      
and Upper(AdmLink.Subject)='CLAIM' and Upper(Admlink.Extra_3)='REFUND'
and round(Voucher.AmountDue - (Voucher.Payment_CC+Voucher.Payment_OC),2)>0 and Voucher.DueDate between @P_SDate and @P_EDate    
    
and AdmLink.ID Like @P_ID+'%'  
and Voucher.Voucher in (Select CollectionV.Voucher from CollectionV, CollectionH Where CollectionH.CollNo=CollectionV.CollNo and CollectionH.CollStatus='C' and CollectionV.Paid=0 and CollectionV.Voucher=Voucher.Voucher)    
and Not Exists (Select Top 1 CollectionV.Voucher from CollectionV, CollectionH Where CollectionH.CollNo=CollectionV.COllNo and CollectionH.CollStatus<>'C' and CollectionV.CollNo<>Voucher.CollNo and CollectionV.Voucher=Voucher.Voucher)   
and Not Exists (Select Top 1 SL.doc_no from SL_Request SL, Request R Where R.Status<>'C' and R.Voucher='' and R.Request=SL.Request and SL.doc_no=Voucher.Voucher)

    
)    





GO

/****** Object:  UserDefinedFunction [dbo].[DB_U_F_DISBURSE]    Script Date: 5/25/2022 11:06:24 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO



CREATE FUNCTION [dbo].[DB_U_F_DISBURSE](@P_PDate smalldatetime, @P_Voucher as varchar(20), @P_PolicyNo as varchar(50), @P_RefNo as varchar(50), @P_DocNo as varchar(50)) 
RETURNS TABLE    
AS RETURN    
(    
select distinct  Voucher.RefNo as RefNo, Voucher.Voucher, Admlink.Type, Admlink.Code, Admlink.BatchNo, Admlink.Bank, Admlink.Date, Admlink.Subject, Voucher.DocNo, Voucher.StatID, Voucher.ActionBy, Voucher.ActionDate, Voucher.AcceptedBy, Voucher.AcceptedDate,     
Voucher.[Currency],  Voucher.Installment, Voucher.DueDate as DueDate, Voucher.AmountDue-Voucher.Payment_CC-Voucher.Payment_OC as Nominal,    
Profile.Name+'-'+Voucher.Remarks as AName, Profile.Name, Voucher.debtorF,Voucher.CreditorF, Admlink.RefType,Voucher.Branch, Admlink.A_PolicyNo, Admlink.EXTRA_4  
from ProAcc,[Profile],Voucher_AmountWPCDue(@P_PDate) Voucher,AdmLink 
where  Voucher.Voucher=AdmLink.Voucher     
and ProAcc.ProAcc=Voucher.ProAcc     
and ProAcc.[ID]=[Profile].[ID]     
and Admlink.Type in ('DI','IC','CF','JP','SO','OP')    
and Not ((Admlink.Type in ('OP') and Admlink.Amount_8<>0) or (Admlink.Type in ('DI','SO') and Admlink.Amount_7+Admlink.Amount_12+Admlink.Amount_15=Admlink.Amount)) -- Not Claim Salvage/Excess      
and Upper(AdmLink.Subject)='CLAIM'  
and Admlink.Date<=@P_PDate
and Admlink.Voucher Like @P_Voucher 
and Admlink.A_PolicyNo Like @P_PolicyNo 
and Admlink.RefNo Like @P_RefNo 
and Admlink.DocNo Like @P_DocNo
and Not Exists (Select Top 1 CollectionV.Voucher from CollectionV, CollectionH Where CollectionH.CollNo=CollectionV.COllNo and CollectionH.CollStatus<>'C' and CollectionV.CollNo<>Voucher.CollNo and CollectionV.Voucher=Voucher.Voucher)   
and Not Exists (Select Top 1 SL.doc_no from SL_Request SL, Request R Where R.Status<>'C' and R.Voucher='' and R.Request=SL.Request and SL.doc_no=Voucher.Voucher)

)    
  




GO

/****** Object:  UserDefinedFunction [dbo].[DB_U_I_DISBURSE]    Script Date: 5/25/2022 11:06:24 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO



CREATE FUNCTION [dbo].[DB_U_I_DISBURSE](@P_PDate smalldatetime, @P_Voucher as varchar(20), @P_PolicyNo as varchar(50), @P_RefNo as varchar(50), @P_DocNo as varchar(50)) 
RETURNS TABLE    
AS RETURN    
(    
select distinct  Voucher.RefNo as RefNo, Voucher.Voucher, Admlink.Type, Admlink.Code, Admlink.BatchNo, Admlink.Bank, Admlink.Date, Admlink.Subject, Voucher.DocNo, Voucher.StatID, Voucher.ActionBy, Voucher.ActionDate, Voucher.AcceptedBy, Voucher.AcceptedDate,     
Voucher.[Currency],  Voucher.Installment, Voucher.DueDate as DueDate, Voucher.AmountDue-Voucher.Payment_CC-Voucher.Payment_OC as Nominal,    
Profile.Name+'-'+Voucher.Remarks as AName, Profile.Name, Voucher.debtorF,Voucher.CreditorF, Admlink.RefType,Voucher.Branch, Admlink.A_PolicyNo, Admlink.EXTRA_4  
from ProAcc,[Profile],Voucher_AmountWPCDue(@P_PDate) Voucher,AdmLink  
where  Voucher.Voucher=AdmLink.Voucher     
and ProAcc.ProAcc=Voucher.ProAcc     
and ProAcc.[ID]=[Profile].[ID]     
and Admlink.Type in ('DI','IC','CF','JP','SO','OP')    
and Not ((Admlink.Type in ('OP') and Admlink.Amount_8<>0) or (Admlink.Type in ('DI','SO') and Admlink.Amount_7+Admlink.Amount_12+Admlink.Amount_15=Admlink.Amount)) -- Not Claim Salvage/Excess      
and Upper(AdmLink.Subject)='CLAIM'  
and Admlink.Voucher Like @P_Voucher 
and Admlink.A_PolicyNo Like @P_PolicyNo 
and Admlink.RefNo Like @P_RefNo 
and Admlink.DocNo Like @P_DocNo
and Not Exists (Select Top 1 CollectionV.Voucher from CollectionV, CollectionH Where CollectionH.CollNo=CollectionV.COllNo and CollectionH.CollStatus<>'C' and CollectionV.CollNo<>Voucher.CollNo and CollectionV.Voucher=Voucher.Voucher)   
and Not Exists (Select Top 1 SL.doc_no from SL_Request SL, Request R Where R.Status<>'C' and R.Voucher='' and R.Request=SL.Request and SL.doc_no=Voucher.Voucher)

) 





GO




 insert into PatchVersioning
select '271 Update Script - Patch 2022 (32)',GETDATE()
go


Declare @PrevScript varchar(100)
Declare @CurrScript varchar(100)

Select @PrevScript=''
Select @CurrSCript='271 Update Script - Patch 2022 (32)'


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




go
