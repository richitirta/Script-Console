Select * into #R from SysProcess Where ProcName='AUTOINFORCE_PROCESS'

Update #R Set ProcName='AutoGenerateRenewalPolicy_Process'

IF NOT EXISTS(SELECT * FROM sysprocess WHERE Procname='AutoGenerateRenewalPolicy_Process')
BEGIN
insert into sysprocess Select * from #R
end
go

drop table #R
GO

Select * into #R from SysProcess Where ProcName='AUTOINFORCE_PROCESS'

Update #R Set ProcName='AutoGenerateRenewalQuotation_Process'
IF NOT EXISTS(SELECT * FROM sysprocess WHERE Procname='AutoGenerateRenewalQuotation_Process')
BEGIN
insert into sysprocess Select * from #R
end
go

drop table #R
GO


Select * into #R from SysProcess Where ProcName='AUTOINFORCE_PROCESS'

Update #R Set ProcName='AUTOGENERATERENEWAL_PROCESS'
IF NOT EXISTS(SELECT * FROM sysprocess WHERE Procname='AUTOGENERATERENEWAL_PROCESS')
BEGIN
insert into sysprocess Select * from #R
end
go

drop table #R
GO

DROP Procedure AutoGenerateRenewalQuotation_Process
GO
create Procedure AutoGenerateRenewalQuotation_Process(@P_PDate as smalldatetime)  
as
Select 
Renewal.ASource,
Case When Acceptance.LANO=-1 or Cover.OpenFlag=1 Then Acceptance.ANO else MAcceptance.ANO end as ANO, 
Case When Acceptance.LANO=-1 or Cover.OpenFlag=1 Then Acceptance.LANO else MAcceptance.LANO end as LANO, 
Case When Acceptance.LANO=-1 or Cover.OpenFlag=1 Then Acceptance.PolicyNo else MAcceptance.PolicyNo end as PolicyNo,
Case When Acceptance.LANO=-1 or Cover.OpenFlag=1 Then Acceptance.CertificateNo else MAcceptance.CertificateNo end as CertificateNo,
Case When Acceptance.LANO=-1 or Cover.OpenFlag=1 Then Renewal.SDate else MAcceptance.EDate end as SDate, 
Case When Acceptance.LANO=-1 or Cover.OpenFlag=1 Then Renewal.EDate else dateadd(month,datediff(Month,MAcceptance.SDate, MAcceptance.EDate),MAcceptance.EDate) end as EDate,
Case When Acceptance.LANO=-1 or Cover.OpenFlag=1 Then Acceptance.Branch else MAcceptance.Branch end as Branch, 
Max(PolicyType.SType) as SType,
Max(Cover.CNO) as CNO, 
Max(Cast(Cover.OpenFlag as int)) as OpenFlag,
Max(Case When coalesce(RenewalRight.NewTOC,'')='' then Cover.TOC else RenewalRight.NewTOC end) as NewTOC
from Acceptance 
inner join Cover on (Cover.CNO=Acceptance.CNO)
inner join Policytype on (PolicyType.PolicyType=Cover.PolicyType)
inner join TOC on (TOC.TOC=Cover.TOC and TOC.RQDays<>0)
inner join Segment on (Segment.Segment=Cover.Segment and Segment.AutoGenerateRenewalF=1)
Left Join Acceptance MAcceptance on (MAcceptance.ANO=Acceptance.LANO and Acceptance.LANO<>-1)
inner join Renewal on (Renewal.ANO=Acceptance.ANO and Renewal.Status='O' and ((Renewal.RenewalF=1 and Renewal.Action=0) or (Renewal.Action in (1,2))))
Left Join RenewalRight on (RenewalRight.TOC=Renewal.TOC and RenewalRight.RCode=Renewal.RCode)
Where Acceptance.ANO<>Acceptance.LANO and Acceptance.RenewableF=1 and Acceptance.AStatus in ('I','C') and Cover.CStatus<>'C'     
and Acceptance.EDate Between @P_PDate and dateadd(day,TOC.RQDays,@P_PDate)  
and Renewal.ASource='MKT'
Group By
Renewal.ASource,
Case When Acceptance.LANO=-1 or Cover.OpenFlag=1 Then Acceptance.ANO else MAcceptance.ANO end,
Case When Acceptance.LANO=-1 or Cover.OpenFlag=1 Then Acceptance.LANO else MAcceptance.LANO end, 
Case When Acceptance.LANO=-1 or Cover.OpenFlag=1 Then Acceptance.PolicyNo else MAcceptance.PolicyNo end,
Case When Acceptance.LANO=-1 or Cover.OpenFlag=1 Then Acceptance.CertificateNo else MAcceptance.CertificateNo end,
Case When Acceptance.LANO=-1 or Cover.OpenFlag=1 Then Renewal.SDate else MAcceptance.EDate end,
Case When Acceptance.LANO=-1 or Cover.OpenFlag=1 Then Renewal.EDate else dateadd(month,datediff(Month,MAcceptance.SDate, MAcceptance.EDate),MAcceptance.EDate) end,
Case When Acceptance.LANO=-1 or Cover.OpenFlag=1 Then Acceptance.Branch else MAcceptance.Branch end


GO

DROP Procedure AutoGenerateRenewalPolicy_Process
GO
create Procedure AutoGenerateRenewalPolicy_Process(@P_PDate as smalldatetime)  
as
Select 
Renewal.ASource,
Case When Acceptance.LANO=-1 or Cover.OpenFlag=1 Then Acceptance.ANO else MAcceptance.ANO end as ANO, 
Case When Acceptance.LANO=-1 or Cover.OpenFlag=1 Then Acceptance.LANO else MAcceptance.LANO end as LANO, 
Case When Acceptance.LANO=-1 or Cover.OpenFlag=1 Then Acceptance.PolicyNo else MAcceptance.PolicyNo end as PolicyNo,
Case When Acceptance.LANO=-1 or Cover.OpenFlag=1 Then Acceptance.CertificateNo else MAcceptance.CertificateNo end as CertificateNo,
Case When Acceptance.LANO=-1 or Cover.OpenFlag=1 Then Renewal.SDate else MAcceptance.EDate end as SDate, 
Case When Acceptance.LANO=-1 or Cover.OpenFlag=1 Then Renewal.EDate else dateadd(month,datediff(Month,MAcceptance.SDate, MAcceptance.EDate),MAcceptance.EDate) end as EDate,
Case When Acceptance.LANO=-1 or Cover.OpenFlag=1 Then Acceptance.Branch else MAcceptance.Branch end as Branch, 
Max(PolicyType.SType) as SType,
Max(Cover.CNO) as CNO, 
Max(Cast(Cover.OpenFlag as int)) as OpenFlag,
Max(Case When coalesce(RenewalRight.NewTOC,'')='' then Cover.TOC else RenewalRight.NewTOC end) as NewTOC,
cast(Max(cast(Segment.AutoInforceF as Int)) as Bit) as InforceF
from Acceptance 
inner join Cover on (Cover.CNO=Acceptance.CNO)
inner join Policytype on (PolicyType.PolicyType=Cover.PolicyType)
inner join TOC on (TOC.TOC=Cover.TOC and TOC.RQDays<>0)
inner join Segment on (Segment.Segment=Cover.Segment and Segment.AutoGenerateRenewalF=1)
Left Join Acceptance MAcceptance on (MAcceptance.ANO=Acceptance.LANO and Acceptance.LANO<>-1)
inner join Renewal on (Renewal.ANO=Acceptance.ANO and Renewal.Status='O' and ((Renewal.RenewalF=1 and Renewal.Action=0) or (Renewal.Action in (1,2))))
Left Join RenewalRight on (RenewalRight.TOC=Renewal.TOC and RenewalRight.RCode=Renewal.RCode)
Where Acceptance.ANO<>Acceptance.LANO and Acceptance.RenewableF=1 and Acceptance.AStatus in ('I','C') and Cover.CStatus<>'C'     
and Acceptance.EDate Between @P_PDate and dateadd(day,TOC.RQDays,@P_PDate)  
and Renewal.ASource='UW'
Group By
Renewal.ASource,
Case When Acceptance.LANO=-1 or Cover.OpenFlag=1 Then Acceptance.ANO else MAcceptance.ANO end,
Case When Acceptance.LANO=-1 or Cover.OpenFlag=1 Then Acceptance.LANO else MAcceptance.LANO end, 
Case When Acceptance.LANO=-1 or Cover.OpenFlag=1 Then Acceptance.PolicyNo else MAcceptance.PolicyNo end,
Case When Acceptance.LANO=-1 or Cover.OpenFlag=1 Then Acceptance.CertificateNo else MAcceptance.CertificateNo end,
Case When Acceptance.LANO=-1 or Cover.OpenFlag=1 Then Renewal.SDate else MAcceptance.EDate end,
Case When Acceptance.LANO=-1 or Cover.OpenFlag=1 Then Renewal.EDate else dateadd(month,datediff(Month,MAcceptance.SDate, MAcceptance.EDate),MAcceptance.EDate) end,
Case When Acceptance.LANO=-1 or Cover.OpenFlag=1 Then Acceptance.Branch else MAcceptance.Branch end
go