DROP FUNCTION FN_CollType_Voucher
GO
CREATE FUNCTION FN_CollType_Voucher(@P_CollType as varchar(10))            
RETURNS TABLE            
as RETURN(  
Select V.Voucher 
from nVoucher V
Where Exists
(
	Select Top 1 C.CollType
	From CollType C
	Left Join CollType_Segment C1 on (C1.CollType=C.CollType)
	Left Join CollType_TOC C2 on (C2.CollType=C.CollType)
	Left Join CollType_CGroup C3 on (C3.CollType=C.CollType)
	Inner Join Admlink A on (A.Voucher=V.Voucher)
	Inner Join Profile on (Profile.ID=A.ID)
	Where C.CollType=@P_CollType
	and (coalesce(C1.Segment, C.Segment)=A.Segment or coalesce(C1.Segment, C.Segment)='')
	and (coalesce(C2.TOC, C.TOC)=A.Code or coalesce(C2.TOC, C.TOC)='')
	and (coalesce(C3.Cgroup, C.CGroup)=Profile.CGroup or coalesce(C3.Cgroup, C.CGroup)='')
)
)

GO

if exists (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'CL_R_COLLECT_ALL_CLAIM_ALL') AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) )
BEGIN 
DROP function CL_R_COLLECT_ALL_CLAIM_ALL
end
GO
CREATE function CL_R_COLLECT_ALL_CLAIM_ALL (@P_SDate as smalldatetime, @P_EDate as SmallDateTime, @P_ID as Varchar(255))
RETURNS TABLE
AS RETURN
(
select distinct  Voucher.RefNo, Voucher.Voucher, Admlink.Type, Admlink.Code, Admlink.BatchNo, Admlink.Bank, Admlink.Date, Admlink.Subject, Voucher.DocNo, Voucher.StatID, Voucher.ActionBy, Voucher.ActionDate, Voucher.AcceptedBy, Voucher.AcceptedDate, 
Voucher.[Currency],  Voucher.Installment, Voucher.DueDate as DueDate, Voucher.AmountDue-Voucher.Payment_CC-Voucher.Payment_OC as Nominal,
Voucher.Remarks+Voucher.sInstallment as AName, Profile.Name, Voucher.debtorF,Voucher.CreditorF, Admlink.RefType, Admlink.A_PolicyNo, Voucher.Branch
from ProAcc,[Profile],Voucher_AmountWPCDue(@P_EDate) Voucher,AdmLink
where  Voucher.Voucher=AdmLink.Voucher 
and ProAcc.ProAcc=Voucher.ProAcc 
and ProAcc.[ID]=[Profile].[ID] 
and Admlink.Type in ('IR','IT','IX')
and Admlink.ISType in ('R','T')
and round(Voucher.AmountDue - (Voucher.Payment_CC+Voucher.Payment_OC),2)>0 and Voucher.DueDate between @P_SDate and @P_EDate
and Admlink.Subject='Claim'
and Profile.ID Like @P_ID+'%'
and Not Exists (Select Top 1 CollectionV.Voucher from CollectionV, CollectionH Where CollectionH.CollNo=CollectionV.COllNo and CollectionH.CollStatus<>'C' and CollectionV.CollNo<>Voucher.CollNo and CollectionV.Voucher=Voucher.Voucher)   
and Not Exists (Select Top 1 SL.doc_no from SL_Request SL, Request R Where R.Status<>'C' and R.Voucher='' and R.Request=SL.Request and SL.doc_no=Voucher.Voucher)

)

GO
if exists (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'CL_I_COLLECT_ALL_CLAIM_ALL') AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) )
BEGIN 
DROP function CL_I_COLLECT_ALL_CLAIM_ALL
end
GO
CREATE function CL_I_COLLECT_ALL_CLAIM_ALL(@P_SDate as smalldatetime, @P_EDate as SmallDateTime)
RETURNS TABLE
AS RETURN
(
select distinct  Voucher.RefNo, Voucher.Voucher, Admlink.Type, Admlink.Code, Admlink.BatchNo, Admlink.Bank, Admlink.Date, Admlink.Subject, Voucher.DocNo, Voucher.StatID, Voucher.ActionBy, Voucher.ActionDate, Voucher.AcceptedBy, Voucher.AcceptedDate, 
Voucher.[Currency],  Voucher.Installment, Voucher.DueDate as DueDate, Voucher.AmountDue-Voucher.Payment_CC-Voucher.Payment_OC as Nominal,
Voucher.Remarks+Voucher.sInstallment as AName, Profile.Name, Voucher.debtorF,Voucher.CreditorF, Admlink.RefType, Admlink.A_PolicyNo, Voucher.Branch
from ProAcc,[Profile],Voucher_AmountWPCDue(@P_EDate) Voucher,AdmLink
where  Voucher.Voucher=AdmLink.Voucher 
and ProAcc.ProAcc=Voucher.ProAcc 
and ProAcc.[ID]=[Profile].[ID] 
and Admlink.Type in ('DI','IC','CF','JP','SO')
and Admlink.ISType in ('I','L','C')
and round(Voucher.AmountDue - (Voucher.Payment_CC+Voucher.Payment_OC),2)>0 and Voucher.DueDate between @P_SDate and @P_EDate
and Admlink.Subject='Claim'
and Not Exists (Select Top 1 CollectionV.Voucher from CollectionV, CollectionH Where CollectionH.CollNo=CollectionV.COllNo and CollectionH.CollStatus<>'C' and CollectionV.CollNo<>Voucher.CollNo and CollectionV.Voucher=Voucher.Voucher)   
and Not Exists (Select Top 1 SL.doc_no from SL_Request SL, Request R Where R.Status<>'C' and R.Voucher='' and R.Request=SL.Request and SL.doc_no=Voucher.Voucher)

)

GO
if exists (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'CL_F_COLLECT_ALL_CLAIM_ALL') AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) )
BEGIN
DROP function CL_F_COLLECT_ALL_CLAIM_ALL 
end
GO
CREATE function CL_F_COLLECT_ALL_CLAIM_ALL (@P_SDate as smalldatetime, @P_EDate as SmallDateTime, @P_ID as Varchar(255))  
RETURNS TABLE  
AS RETURN  
(  
select distinct  Voucher.RefNo,Voucher.Voucher, Admlink.Type, Admlink.Code, Admlink.BatchNo, Admlink.Bank, Admlink.Date, Admlink.Subject, Voucher.DocNo, Voucher.StatID, Voucher.ActionBy, Voucher.ActionDate, Voucher.AcceptedBy, Voucher.AcceptedDate, Voucher.[Currency], Voucher.Installment, Voucher.DueDate as DueDate, Voucher.AmountDue-Voucher.Payment_CC-Voucher.Payment_OC as Nominal, Voucher.Remarks+Voucher.sInstallment as AName, Profile.Name, Voucher.debtorF,Voucher.CreditorF, Admlink.RefType, Admlink.A_PolicyNo, Voucher.Branch  
from ProAcc,[Profile],Voucher_AmountWPCDue(@P_EDate) Voucher,AdmLink  
where  Voucher.Voucher=AdmLink.Voucher   
and ProAcc.ProAcc=Voucher.ProAcc   
and ProAcc.[ID]=[Profile].[ID]   
and Admlink.Type in ('DI','IC','CF','JP','SO')   
and Admlink.ISType in ('I','L','C')
and round(Voucher.AmountDue - (Voucher.Payment_CC+Voucher.Payment_OC),2)>0 and Voucher.DueDate between @P_SDate and @P_EDate  
and Profile.ID Like @P_ID+'%'    
and Admlink.Subject='Claim'  
and Not Exists (Select Top 1 CollectionV.Voucher from CollectionV, CollectionH Where CollectionH.CollNo=CollectionV.COllNo and CollectionH.CollStatus<>'C' and CollectionV.CollNo<>Voucher.CollNo and CollectionV.Voucher=Voucher.Voucher)   
and Not Exists (Select Top 1 SL.doc_no from SL_Request SL, Request R Where R.Status<>'C' and R.Voucher='' and R.Request=SL.Request and SL.doc_no=Voucher.Voucher)

)  

GO
if exists (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'CL_A_COLLECT_ALL_CLAIM_ALL') AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) )
BEGIN
DROP function CL_A_COLLECT_ALL_CLAIM_ALL 
end
GO
CREATE function CL_A_COLLECT_ALL_CLAIM_ALL (@P_SDate as smalldatetime, @P_EDate as SmallDateTime, @P_ID as Varchar(255))  
RETURNS TABLE  
AS RETURN  
(  
select distinct  Voucher.RefNo, Voucher.Voucher, Admlink.Type, Admlink.Code, Admlink.BatchNo, Admlink.Bank, Admlink.Date, Admlink.Subject, Voucher.DocNo, Voucher.StatID, Voucher.ActionBy, Voucher.ActionDate, Voucher.AcceptedBy, Voucher.AcceptedDate,   
Voucher.[Currency],  Voucher.Installment, Voucher.DueDate as DueDate, Voucher.AmountDue-Voucher.Payment_CC-Voucher.Payment_OC as Nominal,  
Voucher.Remarks+Voucher.sInstallment as AName, Profile.Name, Voucher.debtorF,Voucher.CreditorF, Admlink.RefType, Admlink.A_PolicyNo, Voucher.Branch  
from ProAcc,[Profile],Voucher_AmountWPCDue(@P_EDate) Voucher,AdmLink  
where  Voucher.Voucher=AdmLink.Voucher   
and ProAcc.ProAcc=Voucher.ProAcc   
and ProAcc.[ID]=[Profile].[ID]   
and Admlink.Type in ('DI','IC','CF','JP','SO')  
and Admlink.ISType in ('I','L','C')
and round(Voucher.AmountDue - (Voucher.Payment_CC+Voucher.Payment_OC),2)>0 and Voucher.DueDate between @P_SDate and @P_EDate  
and Admlink.Subject='Claim'  
and admlink.Source Like @P_ID+'%'
and Not Exists (Select Top 1 CollectionV.Voucher from CollectionV, CollectionH Where CollectionH.CollNo=CollectionV.COllNo and CollectionH.CollStatus<>'C' and CollectionV.CollNo<>Voucher.CollNo and CollectionV.Voucher=Voucher.Voucher)   
and Not Exists (Select Top 1 SL.doc_no from SL_Request SL, Request R Where R.Status<>'C' and R.Voucher='' and R.Request=SL.Request and SL.doc_no=Voucher.Voucher)
)  
  
GO
if exists (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'CL_R_COLLECT_PERIOD_DUE_CLAIM_ALL') AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) )
BEGIN
DROP function CL_R_COLLECT_PERIOD_DUE_CLAIM_ALL  
end
GO
Create function CL_R_COLLECT_PERIOD_DUE_CLAIM_ALL(@P_SDate as smalldatetime, @P_EDate as SmallDateTime, @P_ID as varchar(10))
RETURNS TABLE
AS RETURN
(
select distinct  Voucher.RefNo, Voucher.Voucher, Admlink.Type, Admlink.Code, Admlink.BatchNo, Admlink.Bank, Admlink.Date, Admlink.Subject, Voucher.DocNo, Voucher.StatID, Voucher.ActionBy, Voucher.ActionDate, Voucher.AcceptedBy, Voucher.AcceptedDate, 
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
and Admlink.Subject='Claim'
)


GO
if exists (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'CL_I_COLLECT_PERIOD_DUE_CLAIM_ALL') AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) )
BEGIN
DROP function CL_I_COLLECT_PERIOD_DUE_CLAIM_ALL
end
GO
Create function CL_I_COLLECT_PERIOD_DUE_CLAIM_ALL(@P_SDate as smalldatetime, @P_EDate as SmallDateTime)
RETURNS TABLE
AS RETURN
(
select distinct  Voucher.RefNo, Voucher.Voucher, Admlink.Type, Admlink.Code, Admlink.BatchNo, Admlink.Bank, Admlink.Date, Admlink.Subject, Voucher.DocNo, Voucher.StatID, Voucher.ActionBy, Voucher.ActionDate, Voucher.AcceptedBy, Voucher.AcceptedDate, 
Voucher.[Currency],  Voucher.Installment, Voucher.DueDate as DueDate, Voucher.AmountDue as Nominal,
Voucher.Remarks+Voucher.sInstallment as AName, Profile.Name, Voucher.debtorF,Voucher.CreditorF, Admlink.RefType, Admlink.A_PolicyNo, Voucher.Branch
from ProAcc,[Profile],Voucher_AmountPeriodDue(@P_SDate, @P_EDate) Voucher,AdmLink
where  Voucher.Voucher=AdmLink.Voucher 
and ProAcc.ProAcc=Voucher.ProAcc 
and ProAcc.[ID]=[Profile].[ID] 
and Admlink.Type in ('DI','IC','CF','JP','SO')
and Admlink.ISType in ('I','L','C')
and Voucher.AmountDue<>0  
and Admlink.Subject='Claim'
)

GO
if exists (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'CL_F_COLLECT_PERIOD_DUE_CLAIM_ALL') AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) )
BEGIN
DROP function CL_F_COLLECT_PERIOD_DUE_CLAIM_ALL
end
GO
Create function CL_F_COLLECT_PERIOD_DUE_CLAIM_ALL(@P_SDate as smalldatetime, @P_EDate as SmallDateTime, @P_ID as varchar(10))
RETURNS TABLE
AS RETURN
(
select distinct  Voucher.RefNo, Voucher.Voucher, Admlink.Type, Admlink.Code, Admlink.BatchNo, Admlink.Bank, Admlink.Date, Admlink.Subject, Voucher.DocNo, Voucher.StatID, Voucher.ActionBy, Voucher.ActionDate, Voucher.AcceptedBy, Voucher.AcceptedDate, 
Voucher.[Currency],  Voucher.Installment, Voucher.DueDate as DueDate, Voucher.AmountDue as Nominal,
Voucher.Remarks+Voucher.sInstallment as AName, Profile.Name, Voucher.debtorF,Voucher.CreditorF, Admlink.RefType, Admlink.A_PolicyNo, Voucher.Branch
from ProAcc,[Profile],Voucher_AmountPeriodDue(@P_SDate, @P_EDate) Voucher,AdmLink
where  Voucher.Voucher=AdmLink.Voucher 
and ProAcc.ProAcc=Voucher.ProAcc 
and ProAcc.[ID]=[Profile].[ID] 
and Admlink.Type in ('DI','IC','CF','JP','SO')
and Admlink.ISType in ('I','L','C')
and Admlink.ID  like @P_ID+'%'
and Voucher.AmountDue<>0  
and Admlink.Subject='Claim'
)

GO
if exists (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'CL_A_COLLECT_PERIOD_DUE_CLAIM_ALL') AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) )
BEGIN
DROP function CL_A_COLLECT_PERIOD_DUE_CLAIM_ALL
end
GO
Create function CL_A_COLLECT_PERIOD_DUE_CLAIM_ALL(@P_SDate as smalldatetime, @P_EDate as SmallDateTime, @P_ID as varchar(10))
RETURNS TABLE
AS RETURN
(
select distinct  Voucher.RefNo, Voucher.Voucher, Admlink.Type, Admlink.Code, Admlink.BatchNo, Admlink.Bank, Admlink.Date, Admlink.Subject, Voucher.DocNo, Voucher.StatID, Voucher.ActionBy, Voucher.ActionDate, Voucher.AcceptedBy, Voucher.AcceptedDate, 
Voucher.[Currency],  Voucher.Installment, Voucher.DueDate as DueDate, Voucher.AmountDue as Nominal,
Voucher.Remarks+Voucher.sInstallment as AName, Profile.Name, Voucher.debtorF,Voucher.CreditorF, Admlink.RefType, Admlink.A_PolicyNo, Voucher.Branch
from ProAcc,[Profile],Voucher_AmountPeriodDue(@P_SDate, @P_EDate) Voucher,AdmLink
where  Voucher.Voucher=AdmLink.Voucher 
and ProAcc.ProAcc=Voucher.ProAcc 
and ProAcc.[ID]=[Profile].[ID] 
and Admlink.Type in ('DI','IC','CF','JP','SO')
and Admlink.ISType in ('I','L','C')
and Admlink.Source like @P_ID+'%'
and Voucher.AmountDue<>0  
and Admlink.Subject='Claim'
)


GO

if exists (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'CL_R_COLLECT_NOT_CLAIM_ALL') AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) )
BEGIN
DROP function CL_R_COLLECT_NOT_CLAIM_ALL 
end
GO
CREATE function CL_R_COLLECT_NOT_CLAIM_ALL (@P_SDate as smalldatetime, @P_EDate as SmallDateTime, @P_ID as Varchar(255))
RETURNS TABLE
AS RETURN
(
select distinct  Voucher.RefNo, Voucher.Voucher, Admlink.Type, Admlink.Code, Admlink.BatchNo, Admlink.Bank, Admlink.Date, Admlink.Subject, Voucher.DocNo, Voucher.StatID, Voucher.ActionBy, Voucher.ActionDate, Voucher.AcceptedBy, Voucher.AcceptedDate, 
Voucher.[Currency],  Voucher.Installment, Voucher.DueDate as DueDate, Voucher.AmountDue-Voucher.Payment_CC-Voucher.Payment_OC as Nominal,
Voucher.Remarks+Voucher.sInstallment as AName, Profile.Name, Voucher.debtorF,Voucher.CreditorF, Admlink.RefType, Admlink.A_PolicyNo, Voucher.Branch
from ProAcc,[Profile],Voucher_AmountWPCDue(@P_EDate) Voucher,AdmLink
where  Voucher.Voucher=AdmLink.Voucher 
and ProAcc.ProAcc=Voucher.ProAcc 
and ProAcc.[ID]=[Profile].[ID] 
and Admlink.Type in ('IR','IT','IX')
and Admlink.ISType in ('R','T')
and round(Voucher.AmountDue - (Voucher.Payment_CC+Voucher.Payment_OC),2)>0 and Voucher.DueDate between @P_SDate and @P_EDate
and Admlink.Subject='Claim'
and Profile.ID Like @P_ID+'%'
and Not Exists (Select Top 1 CollectionV.Voucher from CollectionV, CollectionH Where CollectionH.CollNo=CollectionV.COllNo and CollectionH.CollStatus<>'C' and CollectionV.CollNo<>Voucher.CollNo and CollectionV.Voucher=Voucher.Voucher)   
and Not Exists (Select Top 1 SL.doc_no from SL_Request SL, Request R Where R.Status<>'C' and R.Voucher='' and R.Request=SL.Request and SL.doc_no=Voucher.Voucher)

)

GO

if exists (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'CL_I_COLLECT_NOT_CLAIM_ALL') AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) )
BEGIN
DROP function CL_I_COLLECT_NOT_CLAIM_ALL
end
GO
CREATE function CL_I_COLLECT_NOT_CLAIM_ALL(@P_SDate as smalldatetime, @P_EDate as SmallDateTime)
RETURNS TABLE
AS RETURN
(
select distinct  Voucher.RefNo, Voucher.Voucher, Admlink.Type, Admlink.Code, Admlink.BatchNo, Admlink.Bank, Admlink.Date, Admlink.Subject, Voucher.DocNo, Voucher.StatID, Voucher.ActionBy, Voucher.ActionDate, Voucher.AcceptedBy, Voucher.AcceptedDate, 
Voucher.[Currency],  Voucher.Installment, Voucher.DueDate as DueDate, Voucher.AmountDue-Voucher.Payment_CC-Voucher.Payment_OC as Nominal,
Voucher.Remarks+Voucher.sInstallment as AName, Profile.Name, Voucher.debtorF,Voucher.CreditorF, Admlink.RefType, Admlink.A_PolicyNo, Voucher.Branch
from ProAcc,[Profile],Voucher_AmountWPCDue(@P_EDate) Voucher,AdmLink
where  Voucher.Voucher=AdmLink.Voucher 
and ProAcc.ProAcc=Voucher.ProAcc 
and ProAcc.[ID]=[Profile].[ID] 
and Admlink.Type in ('DI','IC','CF','JP','SO')
and Admlink.ISType in ('I','L','C')
and round(Voucher.AmountDue - (Voucher.Payment_CC+Voucher.Payment_OC),2)>0 and Voucher.DueDate between @P_SDate and @P_EDate
and Admlink.Subject='Claim'
and Not Exists (Select Top 1 CollectionV.Voucher from CollectionV, CollectionH Where CollectionH.CollNo=CollectionV.COllNo and CollectionH.CollStatus<>'C' and CollectionV.CollNo<>Voucher.CollNo and CollectionV.Voucher=Voucher.Voucher)   
and Not Exists (Select Top 1 SL.doc_no from SL_Request SL, Request R Where R.Status<>'C' and R.Voucher='' and R.Request=SL.Request and SL.doc_no=Voucher.Voucher)

)

GO
if exists (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'CL_F_COLLECT_NOT_CLAIM_ALL') AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) )
BEGIN
DROP function CL_F_COLLECT_NOT_CLAIM_ALL
end
GO
CREATE function CL_F_COLLECT_NOT_CLAIM_ALL (@P_SDate as smalldatetime, @P_EDate as SmallDateTime, @P_ID as Varchar(255))
RETURNS TABLE
AS RETURN
(
select distinct  Voucher.RefNo, Voucher.Voucher, Admlink.Type, Admlink.Code, Admlink.BatchNo, Admlink.Bank, Admlink.Date, Admlink.Subject, Voucher.DocNo, Voucher.StatID, Voucher.ActionBy, Voucher.ActionDate, Voucher.AcceptedBy, Voucher.AcceptedDate, 
Voucher.[Currency],  Voucher.Installment, Voucher.DueDate as DueDate, Voucher.AmountDue-Voucher.Payment_CC-Voucher.Payment_OC as Nominal,
Voucher.Remarks+Voucher.sInstallment as AName, Profile.Name, Voucher.debtorF,Voucher.CreditorF, Admlink.RefType, Admlink.A_PolicyNo, Voucher.Branch
from ProAcc,[Profile],Voucher_AmountWPCDue(@P_EDate) Voucher,AdmLink
where  Voucher.Voucher=AdmLink.Voucher 
and ProAcc.ProAcc=Voucher.ProAcc 
and ProAcc.[ID]=[Profile].[ID] 
and Admlink.Type in ('DI','IC','CF','JP','SO')
and Admlink.ISType in ('I','L','C')
and round(Voucher.AmountDue - (Voucher.Payment_CC+Voucher.Payment_OC),2)>0 and Voucher.DueDate between @P_SDate and @P_EDate
and Admlink.Subject='Claim'
and Profile.ID Like @P_ID+'%'
and Not Exists (Select Top 1 CollectionV.Voucher from CollectionV, CollectionH Where CollectionH.CollNo=CollectionV.COllNo and CollectionH.CollStatus<>'C' and CollectionV.CollNo<>Voucher.CollNo and CollectionV.Voucher=Voucher.Voucher)   
and Not Exists (Select Top 1 SL.doc_no from SL_Request SL, Request R Where R.Status<>'C' and R.Voucher='' and R.Request=SL.Request and SL.doc_no=Voucher.Voucher)

)

GO
if exists (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'CL_A_COLLECT_NOT_CLAIM_ALL') AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) )
begin
DROP function CL_A_COLLECT_NOT_CLAIM_ALL
end
GO
CREATE function CL_A_COLLECT_NOT_CLAIM_ALL (@P_SDate as smalldatetime, @P_EDate as SmallDateTime, @P_ID as Varchar(255))
RETURNS TABLE
AS RETURN
(
select distinct  Voucher.RefNo, Voucher.Voucher, Admlink.Type, Admlink.Code, Admlink.BatchNo, Admlink.Bank, Admlink.Date, Admlink.Subject, Voucher.DocNo, Voucher.StatID, Voucher.ActionBy, Voucher.ActionDate, Voucher.AcceptedBy, Voucher.AcceptedDate, 
Voucher.[Currency],  Voucher.Installment, Voucher.DueDate as DueDate, Voucher.AmountDue-Voucher.Payment_CC-Voucher.Payment_OC as Nominal,
Voucher.Remarks+Voucher.sInstallment as AName, Profile.Name, Voucher.debtorF,Voucher.CreditorF, Admlink.RefType, Admlink.A_PolicyNo, Voucher.Branch
from ProAcc,[Profile],Voucher_AmountWPCDue(@P_EDate) Voucher,AdmLink
where  Voucher.Voucher=AdmLink.Voucher 
and ProAcc.ProAcc=Voucher.ProAcc 
and ProAcc.[ID]=[Profile].[ID] 
and Admlink.Type in ('DI','IC','CF','JP','SO')
and Admlink.ISType in ('I','L','C')
and round(Voucher.AmountDue - (Voucher.Payment_CC+Voucher.Payment_OC),2)>0 and Voucher.DueDate between @P_SDate and @P_EDate
and Admlink.Subject='Claim'
and admlink.Source Like @P_ID+'%'
and Not Exists (Select Top 1 CollectionV.Voucher from CollectionV, CollectionH Where CollectionH.CollNo=CollectionV.COllNo and CollectionH.CollStatus<>'C' and CollectionV.CollNo<>Voucher.CollNo and CollectionV.Voucher=Voucher.Voucher)   
and Not Exists (Select Top 1 SL.doc_no from SL_Request SL, Request R Where R.Status<>'C' and R.Voucher='' and R.Request=SL.Request and SL.doc_no=Voucher.Voucher)

)

GO
if exists (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'CL_R_COLLECT_UNPAID_CLAIM_ALL') AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) )
begin
DROP function CL_R_COLLECT_UNPAID_CLAIM_ALL
end
GO
CREATE function CL_R_COLLECT_UNPAID_CLAIM_ALL (@P_SDate as smalldatetime, @P_EDate as SmallDateTime, @P_ID as Varchar(255))
RETURNS TABLE
AS RETURN
(
select distinct  Voucher.RefNo, Voucher.Voucher, Admlink.Type, Admlink.Code, Admlink.BatchNo, Admlink.Bank, Admlink.Date, Admlink.Subject, Voucher.DocNo, Voucher.StatID, Voucher.ActionBy, Voucher.ActionDate, Voucher.AcceptedBy, Voucher.AcceptedDate, 
Voucher.[Currency],  Voucher.Installment, Voucher.DueDate as DueDate, Voucher.AmountDue-Voucher.Payment_CC-Voucher.Payment_OC as Nominal,
Voucher.Remarks+Voucher.sInstallment as AName, Profile.Name, Voucher.debtorF,Voucher.CreditorF, Admlink.RefType, Admlink.A_PolicyNo, Voucher.Branch
from ProAcc,[Profile],Voucher_AmountWPCDue(@P_EDate) Voucher,AdmLink
where  Voucher.Voucher=AdmLink.Voucher 
and ProAcc.ProAcc=Voucher.ProAcc 
and ProAcc.[ID]=[Profile].[ID] 
and Admlink.Type in ('IR','IT','IX')
and Admlink.ISType in ('R','T')
and round(Voucher.AmountDue - (Voucher.Payment_CC+Voucher.Payment_OC),2)>0 and Voucher.DueDate between @P_SDate and @P_EDate
and Admlink.Subject='Claim'
and Profile.ID Like @P_ID+'%'
and Voucher.Voucher in (Select CollectionV.Voucher from CollectionV, CollectionH Where CollectionH.CollNo=CollectionV.CollNo and CollectionH.CollStatus='C' and CollectionV.Paid=0 and CollectionV.CollNo<>Voucher.CollNo and CollectionV.Voucher=Voucher.Voucher)
and Not Exists (Select Top 1 CollectionV.Voucher from CollectionV, CollectionH Where CollectionH.CollNo=CollectionV.COllNo and CollectionH.CollStatus<>'C' and CollectionV.CollNo<>Voucher.CollNo and CollectionV.Voucher=Voucher.Voucher)   
and Not Exists (Select Top 1 SL.doc_no from SL_Request SL, Request R Where R.Status<>'C' and R.Voucher='' and R.Request=SL.Request and SL.doc_no=Voucher.Voucher)


)

GO
if exists (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'CL_I_COLLECT_UNPAID_CLAIM_ALL') AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) )
begin
DROP function CL_I_COLLECT_UNPAID_CLAIM_ALL
end
GO
CREATE function CL_I_COLLECT_UNPAID_CLAIM_ALL(@P_SDate as smalldatetime, @P_EDate as SmallDateTime)
RETURNS TABLE
AS RETURN
(
select distinct  Voucher.RefNo, Voucher.Voucher, Admlink.Type, Admlink.Code, Admlink.BatchNo, Admlink.Bank, Admlink.Date, Admlink.Subject, Voucher.DocNo, Voucher.StatID, Voucher.ActionBy, Voucher.ActionDate, Voucher.AcceptedBy, Voucher.AcceptedDate, 
Voucher.[Currency],  Voucher.Installment, Voucher.DueDate as DueDate, Voucher.AmountDue-Voucher.Payment_CC-Voucher.Payment_OC as Nominal,
Voucher.Remarks+Voucher.sInstallment as AName, Profile.Name, Voucher.debtorF,Voucher.CreditorF, Admlink.RefType, Admlink.A_PolicyNo, Voucher.Branch
from ProAcc,[Profile],Voucher_AmountWPCDue(@P_EDate) Voucher,AdmLink
where  Voucher.Voucher=AdmLink.Voucher 
and ProAcc.ProAcc=Voucher.ProAcc 
and ProAcc.[ID]=[Profile].[ID] 
and Admlink.Type in ('DI','IC','CF','JP','SO')
and Admlink.ISType in ('I','L','C')
and round(Voucher.AmountDue - (Voucher.Payment_CC+Voucher.Payment_OC),2)>0 and Voucher.DueDate between @P_SDate and @P_EDate
and Admlink.Subject='Claim'
and Voucher.Voucher in (Select CollectionV.Voucher from CollectionV, CollectionH Where CollectionH.CollNo=CollectionV.CollNo and CollectionH.CollStatus='C' and CollectionV.Paid=0 and CollectionV.CollNo<>Voucher.CollNo and CollectionV.Voucher=Voucher.Voucher)
and Not Exists (Select Top 1 CollectionV.Voucher from CollectionV, CollectionH Where CollectionH.CollNo=CollectionV.COllNo and CollectionH.CollStatus<>'C' and CollectionV.CollNo<>Voucher.CollNo and CollectionV.Voucher=Voucher.Voucher)   
and Not Exists (Select Top 1 SL.doc_no from SL_Request SL, Request R Where R.Status<>'C' and R.Voucher='' and R.Request=SL.Request and SL.doc_no=Voucher.Voucher)

)

GO
if exists (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'CL_F_COLLECT_UNPAID_CLAIM_ALL') AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) )
begin
DROP function CL_F_COLLECT_UNPAID_CLAIM_ALL 
end
GO
CREATE function CL_F_COLLECT_UNPAID_CLAIM_ALL (@P_SDate as smalldatetime, @P_EDate as SmallDateTime, @P_ID as Varchar(255))
RETURNS TABLE
AS RETURN
(
select distinct  Voucher.RefNo, Voucher.Voucher, Admlink.Type, Admlink.Code, Admlink.BatchNo, Admlink.Bank, Admlink.Date, Admlink.Subject, Voucher.DocNo, Voucher.StatID, Voucher.ActionBy, Voucher.ActionDate, Voucher.AcceptedBy, Voucher.AcceptedDate, 
Voucher.[Currency],  Voucher.Installment, Voucher.DueDate as DueDate, Voucher.AmountDue-Voucher.Payment_CC-Voucher.Payment_OC as Nominal,
Voucher.Remarks+Voucher.sInstallment as AName, Profile.Name, Voucher.debtorF,Voucher.CreditorF, Admlink.RefType, Admlink.A_PolicyNo, Voucher.Branch
from ProAcc,[Profile],Voucher_AmountWPCDue(@P_EDate) Voucher,AdmLink
where  Voucher.Voucher=AdmLink.Voucher 
and ProAcc.ProAcc=Voucher.ProAcc 
and ProAcc.[ID]=[Profile].[ID] 
and Admlink.Type in ('DI','IC','CF','JP','SO')
and Admlink.ISType in ('I','L','C')
and round(Voucher.AmountDue - (Voucher.Payment_CC+Voucher.Payment_OC),2)>0 and Voucher.DueDate between @P_SDate and @P_EDate
and Admlink.Subject='Claim'
and Profile.ID Like @P_ID+'%'
and Voucher.Voucher in (Select CollectionV.Voucher from CollectionV, CollectionH Where CollectionH.CollNo=CollectionV.CollNo and CollectionH.CollStatus='C' and CollectionV.Paid=0 and CollectionV.CollNo<>Voucher.CollNo and CollectionV.Voucher=Voucher.Voucher)
and Not Exists (Select Top 1 CollectionV.Voucher from CollectionV, CollectionH Where CollectionH.CollNo=CollectionV.COllNo and CollectionH.CollStatus<>'C' and CollectionV.CollNo<>Voucher.CollNo and CollectionV.Voucher=Voucher.Voucher)   
and Not Exists (Select Top 1 SL.doc_no from SL_Request SL, Request R Where R.Status<>'C' and R.Voucher='' and R.Request=SL.Request and SL.doc_no=Voucher.Voucher)


)

GO
if exists (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'CL_A_COLLECT_UNPAID_CLAIM_ALL') AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) )
begin
DROP function CL_A_COLLECT_UNPAID_CLAIM_ALL 
end
GO
CREATE function CL_A_COLLECT_UNPAID_CLAIM_ALL (@P_SDate as smalldatetime, @P_EDate as SmallDateTime, @P_ID as Varchar(255))
RETURNS TABLE
AS RETURN
(
select distinct  Voucher.RefNo, Voucher.Voucher, Admlink.Type, Admlink.Code, Admlink.BatchNo, Admlink.Bank, Admlink.Date, Admlink.Subject, Voucher.DocNo, Voucher.StatID, Voucher.ActionBy, Voucher.ActionDate, Voucher.AcceptedBy, Voucher.AcceptedDate, 
Voucher.[Currency],  Voucher.Installment, Voucher.DueDate as DueDate, Voucher.AmountDue-Voucher.Payment_CC-Voucher.Payment_OC as Nominal,
Voucher.Remarks+Voucher.sInstallment as AName, Profile.Name, Voucher.debtorF,Voucher.CreditorF, Admlink.RefType, Admlink.A_PolicyNo, Voucher.Branch
from ProAcc,[Profile],Voucher_AmountWPCDue(@P_EDate) Voucher,AdmLink
where  Voucher.Voucher=AdmLink.Voucher 
and ProAcc.ProAcc=Voucher.ProAcc 
and ProAcc.[ID]=[Profile].[ID] 
and Admlink.Type in ('DI','IC','CF','JP','SO')
and Admlink.ISType in ('I','L','C')
and round(Voucher.AmountDue - (Voucher.Payment_CC+Voucher.Payment_OC),2)>0 and Voucher.DueDate between @P_SDate and @P_EDate
and Admlink.Subject='Claim'
and admlink.Source Like @P_ID+'%'
and Voucher.Voucher in (Select CollectionV.Voucher from CollectionV, CollectionH Where CollectionH.CollNo=CollectionV.CollNo and CollectionH.CollStatus='C' and CollectionV.Paid=0 and CollectionV.CollNo<>Voucher.CollNo and CollectionV.Voucher=Voucher.Voucher)
and Not Exists (Select Top 1 CollectionV.Voucher from CollectionV, CollectionH Where CollectionH.CollNo=CollectionV.COllNo and CollectionH.CollStatus<>'C' and CollectionV.CollNo<>Voucher.CollNo and CollectionV.Voucher=Voucher.Voucher)   
and Not Exists (Select Top 1 SL.doc_no from SL_Request SL, Request R Where R.Status<>'C' and R.Voucher='' and R.Request=SL.Request and SL.doc_no=Voucher.Voucher)
)

GO
if exists (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'CL_R_COLLECT_HOLD_CLAIM_ALL') AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) )
begin
DROP function CL_R_COLLECT_HOLD_CLAIM_ALL
end
GO
CREATE function CL_R_COLLECT_HOLD_CLAIM_ALL (@P_SDate as smalldatetime, @P_EDate as SmallDateTime, @P_ID as Varchar(255))
RETURNS TABLE
AS RETURN
(
select distinct  Voucher.RefNo, Voucher.Voucher, Admlink.Type, Admlink.Code, Admlink.BatchNo, Admlink.Bank, Admlink.Date, Admlink.Subject, Voucher.DocNo, Voucher.StatID, Voucher.ActionBy, Voucher.ActionDate, Voucher.AcceptedBy, Voucher.AcceptedDate, 
Voucher.[Currency],  Voucher.Installment, Voucher.DueDate as DueDate, Voucher.AmountDue-Voucher.Payment_CC-Voucher.Payment_OC as Nominal,
Voucher.Remarks+Voucher.sInstallment as AName, Profile.Name, Voucher.debtorF,Voucher.CreditorF, Admlink.RefType, Admlink.A_PolicyNo, Voucher.Branch
from ProAcc,[Profile],Voucher_AmountWPCDue(@P_EDate) Voucher,AdmLink
where  Voucher.Voucher=AdmLink.Voucher 
and ProAcc.ProAcc=Voucher.ProAcc 
and ProAcc.[ID]=[Profile].[ID] 
and Admlink.Type in ('IR','IT','IX')
and Admlink.ISType in ('R','T')
and round(Voucher.AmountDue - (Voucher.Payment_CC+Voucher.Payment_OC),2)>0 and Voucher.DueDate between @P_SDate and @P_EDate
and Admlink.Subject='Claim'
and Profile.ID Like @P_ID+'%'
and Voucher.Voucher in (Select CollectionV.Voucher from CollectionV, CollectionH Where CollectionH.CollNo=CollectionV.CollNo and CollectionH.CollStatus='C' and CollectionV.Hold<>0 and CollectionV.CollNo<>Voucher.CollNo and CollectionV.Voucher=Voucher.Voucher)
)

GO
if exists (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'CL_I_COLLECT_HOLD_CLAIM_ALL') AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) )
begin
DROP function CL_I_COLLECT_HOLD_CLAIM_ALL
end
GO
CREATE function CL_I_COLLECT_HOLD_CLAIM_ALL(@P_SDate as smalldatetime, @P_EDate as SmallDateTime)
RETURNS TABLE
AS RETURN
(
select distinct  Voucher.RefNo, Voucher.Voucher, Admlink.Type, Admlink.Code, Admlink.BatchNo, Admlink.Bank, Admlink.Date, Admlink.Subject, Voucher.DocNo, Voucher.StatID, Voucher.ActionBy, Voucher.ActionDate, Voucher.AcceptedBy, Voucher.AcceptedDate, 
Voucher.[Currency],  Voucher.Installment, Voucher.DueDate as DueDate, Voucher.AmountDue-Voucher.Payment_CC-Voucher.Payment_OC as Nominal,
Voucher.Remarks+Voucher.sInstallment as AName, Profile.Name, Voucher.debtorF,Voucher.CreditorF, Admlink.RefType, Admlink.A_PolicyNo, Voucher.Branch
from ProAcc,[Profile],Voucher_AmountWPCDue(@P_EDate) Voucher,AdmLink
where  Voucher.Voucher=AdmLink.Voucher 
and ProAcc.ProAcc=Voucher.ProAcc 
and ProAcc.[ID]=[Profile].[ID] 
and Admlink.Type in ('DI','IC','CF','JP','SO')
and Admlink.ISType in ('I','L','C')
and round(Voucher.AmountDue - (Voucher.Payment_CC+Voucher.Payment_OC),2)>0 and Voucher.DueDate between @P_SDate and @P_EDate
and Admlink.Subject='Claim'
and Voucher.Voucher in (Select CollectionV.Voucher from CollectionV, CollectionH Where CollectionH.CollNo=CollectionV.CollNo and CollectionH.CollStatus='C' and CollectionV.Hold<>0 and CollectionV.CollNo<>Voucher.CollNo and CollectionV.Voucher=Voucher.Voucher)
)

GO
if exists (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'CL_F_COLLECT_HOLD_CLAIM_ALL') AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) )
begin
DROP function CL_F_COLLECT_HOLD_CLAIM_ALL
end
GO
CREATE function CL_F_COLLECT_HOLD_CLAIM_ALL (@P_SDate as smalldatetime, @P_EDate as SmallDateTime, @P_ID as Varchar(255))
RETURNS TABLE
AS RETURN
(
select distinct  Voucher.RefNo, Voucher.Voucher, Admlink.Type, Admlink.Code, Admlink.BatchNo, Admlink.Bank, Admlink.Date, Admlink.Subject, Voucher.DocNo, Voucher.StatID, Voucher.ActionBy, Voucher.ActionDate, Voucher.AcceptedBy, Voucher.AcceptedDate, 
Voucher.[Currency],  Voucher.Installment, Voucher.DueDate as DueDate, Voucher.AmountDue-Voucher.Payment_CC-Voucher.Payment_OC as Nominal,
Voucher.Remarks+Voucher.sInstallment as AName, Profile.Name, Voucher.debtorF,Voucher.CreditorF, Admlink.RefType, Admlink.A_PolicyNo, Voucher.Branch
from ProAcc,[Profile],Voucher_AmountWPCDue(@P_EDate) Voucher,AdmLink
where  Voucher.Voucher=AdmLink.Voucher 
and ProAcc.ProAcc=Voucher.ProAcc 
and ProAcc.[ID]=[Profile].[ID] 
and Admlink.Type in ('DI','IC','CF','JP','SO')
and Admlink.ISType in ('I','L','C')
and round(Voucher.AmountDue - (Voucher.Payment_CC+Voucher.Payment_OC),2)>0 and Voucher.DueDate between @P_SDate and @P_EDate
and Admlink.Subject='Claim'
and Profile.ID Like @P_ID+'%'
and Voucher.Voucher in (Select CollectionV.Voucher from CollectionV, CollectionH Where CollectionH.CollNo=CollectionV.CollNo and CollectionH.CollStatus='C' and CollectionV.Hold<>0 and CollectionV.CollNo<>Voucher.CollNo and CollectionV.Voucher=Voucher.Voucher)
)

GO
if exists (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'CL_A_COLLECT_HOLD_CLAIM_ALL') AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) )
begin
DROP function CL_A_COLLECT_HOLD_CLAIM_ALL
end
GO
CREATE function CL_A_COLLECT_HOLD_CLAIM_ALL (@P_SDate as smalldatetime, @P_EDate as SmallDateTime, @P_ID as Varchar(255))
RETURNS TABLE
AS RETURN
(
select distinct  Voucher.RefNo, Voucher.Voucher, Admlink.Type, Admlink.Code, Admlink.BatchNo, Admlink.Bank, Admlink.Date, Admlink.Subject, Voucher.DocNo, Voucher.StatID, Voucher.ActionBy, Voucher.ActionDate, Voucher.AcceptedBy, Voucher.AcceptedDate, 
Voucher.[Currency],  Voucher.Installment, Voucher.DueDate as DueDate, Voucher.AmountDue-Voucher.Payment_CC-Voucher.Payment_OC as Nominal,
Voucher.Remarks+Voucher.sInstallment as AName, Profile.Name, Voucher.debtorF,Voucher.CreditorF, Admlink.RefType, Admlink.A_PolicyNo, Voucher.Branch
from ProAcc,[Profile],Voucher_AmountWPCDue(@P_EDate) Voucher,AdmLink
where  Voucher.Voucher=AdmLink.Voucher 
and ProAcc.ProAcc=Voucher.ProAcc 
and ProAcc.[ID]=[Profile].[ID] 
and Admlink.Type in ('DI','IC','CF','JP','SO')
and Admlink.ISType in ('I','L','C')
and round(Voucher.AmountDue - (Voucher.Payment_CC+Voucher.Payment_OC),2)>0 and Voucher.DueDate between @P_SDate and @P_EDate
and Admlink.Subject='Claim'
and admlink.Source Like @P_ID+'%'
and Not Exists (Select Top 1 CollectionV.Voucher from CollectionV, CollectionH Where CollectionH.CollNo=CollectionV.COllNo and CollectionH.CollStatus<>'C' and CollectionV.CollNo<>Voucher.CollNo and CollectionV.Voucher=Voucher.Voucher)   
and Not Exists (Select Top 1 SL.doc_no from SL_Request SL, Request R Where R.Status<>'C' and R.Voucher='' and R.Request=SL.Request and SL.doc_no=Voucher.Voucher)

)

GO








 insert into PatchVersioning
select '231 Update Script - 26 April 2022',GETDATE()
go


Declare @PrevScript varchar(100)
Declare @CurrScript varchar(100)

Select @PrevScript=''
Select @CurrSCript='231 Update Script - 26 April 2022'


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