DROP function CL_AUTO_COLLECT_ALL_NET 
GO
CREATE function CL_AUTO_COLLECT_ALL_NET (@P_SDate as smalldatetime, @P_EDate as SmallDateTime)  
RETURNS TABLE  
AS RETURN  
(  
select distinct  Admlink.ID, Admlink.A_MO as MO, Admlink.Source, Admlink.A_ID as Holder, '' as RefNo, Voucher.Voucher,Admlink.Type, Admlink.Date, Admlink.Subject, 
Voucher.DocNo, Voucher.StatID, Voucher.ActionBy, Voucher.ActionDate, Voucher.AcceptedBy, Voucher.AcceptedDate, Voucher.[Currency], Voucher.Installment, Voucher.DueDate as DueDate, Voucher.Nominal_CC-Voucher.Diff_CC as Nominal, Voucher.AmountDue as Amount,
 Voucher.Payment_CC as Payment, Voucher.Remarks as AName, Voucher.sInstallment_Ext as Remarks, Profile.Name, Voucher.debtorF,Voucher.CreditorF, 
Admlink.RefType, Admlink.A_PolicyNo, Voucher.Branch,
'' as CBranch -- Collection by Branch (Left Empty if Collection not by Branch)
from ProAcc,[Profile], Voucher_AmountWPCDue(@P_EDate) Voucher,AdmLink  
where  Voucher.Voucher=AdmLink.Voucher   
and ProAcc.ProAcc=Voucher.ProAcc   
and ProAcc.[ID]=[Profile].[ID]   
and Admlink.Type in ('DI','IC','CF','JP','IR','IT','IX','BB','BA','BO')
and Admlink.ISType in ('I','L','C','R','T')
and Admlink.Subject='Premium'  
and (Admlink.Type Not In ('BB','BA','BO') or Admlink.ID=Admlink.Source)
and round(Voucher.Nominal_CC-Voucher.Diff_CC - (Voucher.Payment_CC+Voucher.Payment_OC),4)>0 
) 

GO

DROP function CL_AUTO_COLLECT_PERIOD_DUE_NET_ALL
GO
Create function CL_AUTO_COLLECT_PERIOD_DUE_NET_ALL(@P_SDate as smalldatetime, @P_EDate as SmallDateTime)  
RETURNS TABLE  
AS RETURN  
(  
select distinct  Admlink.ID, Admlink.A_MO as MO, Admlink.Source, Admlink.A_ID as Holder, '' as RefNo, Voucher.Voucher,Admlink.Type, Admlink.Date, Admlink.Subject, 
Voucher.DocNo, Voucher.StatID, Voucher.ActionBy, Voucher.ActionDate, Voucher.AcceptedBy, Voucher.AcceptedDate, Voucher.[Currency], Voucher.Installment, Voucher.DueDate as DueDate, Voucher.Nominal_CC-Voucher.Diff_CC as Nominal, Voucher.AmountDue as Amount,
 Voucher.AmountDue-Voucher.Outstanding as Payment, Voucher.Remarks as AName, Voucher.sInstallment_Ext as Remarks, Profile.Name, Voucher.debtorF,Voucher.CreditorF, 
Admlink.RefType, Admlink.A_PolicyNo, Voucher.Branch,
'' as CBranch -- Collection by Branch (Left Empty if Collection not by Branch)
from ProAcc,[Profile], Voucher_AmountPeriodDue(@P_SDate, @P_EDate) Voucher,AdmLink  
where  Voucher.Voucher=AdmLink.Voucher   
and ProAcc.ProAcc=Voucher.ProAcc   
and ProAcc.[ID]=[Profile].[ID]   
and Admlink.Type in ('DI','IC','CF','JP','IR','IT','IX','BB','BA','BO')
and Admlink.ISType in ('I','L','C','R','T')
and Admlink.Subject='Premium'  
and (Admlink.Type Not In ('BB','BA','BO') or Admlink.ID=Admlink.Source)
and round(Voucher.Outstanding,4)>0 
)  


go

--VERSIONING
insert into PatchVersioning
select 'Update Script - Collection for Auto Billing (Collection Not by Branch)',GETDATE()
go
