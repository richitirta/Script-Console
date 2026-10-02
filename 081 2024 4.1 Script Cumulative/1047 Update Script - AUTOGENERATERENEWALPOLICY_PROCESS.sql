DROP Procedure AutoGenerateRenewalPolicy_Process
GO
create Procedure AutoGenerateRenewalPolicy_Process(@P_PDate as smalldatetime)    
as  
Select   
coalesce(Renewal.ASource,'UW') as ASource,  
Max(Acceptance.PolicyNo) as PolicyNo,   
Case When Acceptance.LANO=-1 or Cover.OpenFlag=1 Then Acceptance.ANO else MAcceptance.ANO end as ANO,   
Case When Acceptance.LANO=-1 or Cover.OpenFlag=1 Then Acceptance.LANO else MAcceptance.LANO end as LANO,   
Case When Acceptance.LANO=-1 or Cover.OpenFlag=1 Then Acceptance.PolicyNo else MAcceptance.PolicyNo end as PolicyNo,  
Case When Acceptance.LANO=-1 or Cover.OpenFlag=1 Then Acceptance.CertificateNo else MAcceptance.CertificateNo end as CertificateNo,  
Case When Acceptance.LANO=-1 or Cover.OpenFlag=1 Then coalesce(Renewal.SDate,Acceptance.EDate) else MAcceptance.EDate end as SDate,   
Case When Acceptance.LANO=-1 or Cover.OpenFlag=1 Then coalesce(Renewal.EDate,dateadd(month,datediff(Month,Acceptance.SDate, Acceptance.EDate),Acceptance.EDate)) else dateadd(month,datediff(Month,MAcceptance.SDate, MAcceptance.EDate),MAcceptance.EDate) end
 as EDate,  
Case When Acceptance.LANO=-1 or Cover.OpenFlag=1 Then Acceptance.Branch else MAcceptance.Branch end as Branch,   
Max(PolicyType.SType) as SType,  
Max(Cover.CNO) as CNO,   
Max(Cast(Cover.OpenFlag as int)) as OpenFlag,  
Max(Case When coalesce(RenewalRight.NewTOC,'')='' then Acceptance.TOC else RenewalRight.NewTOC end) as NewTOC,  
cast(Max(cast(Segment.AutoInforceF as Int)) as Bit) as InforceF,  
cast(max(case When SysTab.PolicyNoOnRenewalF=1 or TOC.PolicyNoOnRenewalF=1 Then 1 else 0 End) as Bit) as PolicyNoOnRenewalF  
from Acceptance   
inner join Cover on (Cover.CNO=Acceptance.CNO)  
inner join Policytype on (PolicyType.PolicyType=Cover.PolicyType)  
inner join TOC on (TOC.TOC=Acceptance.TOC and TOC.RQDays<>0)  
inner join Segment on (Segment.Segment=Cover.Segment)  
inner join SysTab on (1=1)  
Left Join Acceptance MAcceptance on (MAcceptance.ANO=Acceptance.LANO and Acceptance.LANO<>-1)  
Left join Renewal on (Renewal.ANO=Acceptance.ANO)  
Left Join RenewalRight on (RenewalRight.TOC=Renewal.TOC and RenewalRight.RCode=Renewal.RCode)  
Where (Acceptance.AutoGenerateRenewalF=1 or Segment.AutoGenerateRenewalF=1)  
and Acceptance.ANO<>Acceptance.LANO and Acceptance.RenewableF=1 and Acceptance.AStatus in ('I','C') and Cover.CStatus<>'C'       
and Acceptance.EDate Between @P_PDate and dateadd(day,TOC.RQDays,@P_PDate)    
and (TOC.MaxRenewal=0 or Acceptance.Renewal<TOC.MaxRenewal)
and coalesce(Renewal.ASource,'UW')='UW'  
and coalesce(Renewal.Status,'O')='O' and ((coalesce(Renewal.RenewalF,1)=1 and coalesce(Renewal.Action,0)=0) or (coalesce(Renewal.Action,0) in (1,2)))  
Group By  
coalesce(Renewal.ASource,'UW'),  
Case When Acceptance.LANO=-1 or Cover.OpenFlag=1 Then Acceptance.ANO else MAcceptance.ANO end,  
Case When Acceptance.LANO=-1 or Cover.OpenFlag=1 Then Acceptance.LANO else MAcceptance.LANO end,   
Case When Acceptance.LANO=-1 or Cover.OpenFlag=1 Then Acceptance.PolicyNo else MAcceptance.PolicyNo end,  
Case When Acceptance.LANO=-1 or Cover.OpenFlag=1 Then Acceptance.CertificateNo else MAcceptance.CertificateNo end,  
Case When Acceptance.LANO=-1 or Cover.OpenFlag=1 Then coalesce(Renewal.SDate,Acceptance.EDate) else MAcceptance.EDate end,   
Case When Acceptance.LANO=-1 or Cover.OpenFlag=1 Then coalesce(Renewal.EDate,dateadd(month,datediff(Month,Acceptance.SDate, Acceptance.EDate),Acceptance.EDate)) else dateadd(month,datediff(Month,MAcceptance.SDate, MAcceptance.EDate),MAcceptance.EDate) end,  
Case When Acceptance.LANO=-1 or Cover.OpenFlag=1 Then Acceptance.Branch else MAcceptance.Branch end  
  

go




insert into PatchVersioning
select '1047 Update Script - AUTOGENERATERENEWALPOLICY_PROCESS',GETDATE()
go
	

Declare @PrevScript varchar(100)
Declare @CurrScript varchar(100)

Select @PrevScript=''
Select @CurrSCript='1047 Update Script - AUTOGENERATERENEWALPOLICY_PROCESS'


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