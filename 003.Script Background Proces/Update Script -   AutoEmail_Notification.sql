IF EXISTS ( SELECT * FROM   sysobjects WHERE  id = object_id(N'AutoEmail_Notification') and OBJECTPROPERTY(id, N'IsProcedure') = 1 )
BEGIN
DROP Procedure AutoEmail_Notification
end
GO
CREATE Procedure AutoEmail_Notification(@P_PDate as smalldatetime)                    
as                    
Declare @Lapse as int  
Declare @Freq as int  
Select @Lapse=7
Select @Freq=7 

--Auto Lapsing Notification  
--Select C.MO as SID, 'Marketing Officer : '+S.Name as Name, S.MID,  
--'Reminder-'+cast((datediff(day,A.PDate+@Lapse+1, @P_PDate) / @Freq+1) as varchar(10))+' : Auto Lapsing Cancellation Slip Not Printed' as Subject,   
--'Lapse : ' + cast(datediff(day,A.PDate, @P_PDate) as varchar(10)) + ' day(s)' 
--+' ,'+'Policy No : '+A.PolicyNo+Case When A.CertificateNo<>'' Then '-'+A.CertificateNo else '' end  
--+' ,'+'Cancel As At :'+convert(varchar(20), A.PDate,6)  
--+' ,'+'Insured Name :'+A.AName as Message  
--from Acceptance A  
--Inner Join Cover C on (C.CNO=A.CNO)  )  

--Inner Join SysUser S on (S.ID=C.MO--Left Join PPrintLog P on (P.ANO=A.ANO and P.Description Like '%ENDORSEMENT%CANCELLATION%SLIP%')  
--Where A.AStatus='I' and A.AType='C' and A.Remarks Like 'Auto Lapsing' and A.ADate<=@P_PDate  
--and (A.LANO=-1 or (A.ANO=A.LANO and C.OpenFlag=0) or (A.6ANO<>A.LANO and C.OpenFlag=1))  
--and P.ANO is null  
--and datediff(day,A.PDate, @P_PDate)>@Lapse  
--and datediff(day,A.PDate+@Lapse+1, @P_PDate) % @Freq =0  
--Order By SID, MID, Subject, datediff(day,A.PDate, @P_PDate) Desc  

--Union alll


Select Su.ID as SID, 'Name : '+Su.Name as Name, '' as MID,  
'Reminder-'+cast((datediff(day,C1.ADate+@Lapse+1, @P_PDate) / @Freq+1) as varchar(10))+' : Auto Claim Close Notification' as Subject,   
'Lapse : ' + cast(datediff(day,C1.ADate, @P_PDate) as varchar(10)) + ' day(s)'
+' ,'+'Policy No : '+A.PolicyNo+Case When A.CertificateNo<>'' Then '-'+A.CertificateNo else '' end  
+' ,'+'Claim No No : '+C1.ClaimNo
+' ,'+'Approved As At :'+convert(varchar(20), C1.ADate,6)  
+' ,'+'Insured Name :'+A.AName as Message  
from Claim C1  
Inner Join CCalc C2 on (C2.CNO=C1.CNO)
Inner Join CArrHeader C3 on (C3.CNO=C2.CNO)
Inner Join Acceptance A on (A.ANO=C1.ANO)
Inner Join Cover C on (C.CNO=A.CNO)  
Inner Join SysUser S on (S.ID=C1.AUserID)  
Inner Join SysUser Su on (Su.Type=S.Type and Su.Expiry>getdate() and Su.AllowedF=1)
Inner Join SysUserTOC St on (St.ID=Su.ID and St.TOC=A.TOC)
Inner Join TOC on (TOC.TOC=C1.TOC)
Left Join OS_Claim_By_detail(@P_PDate) C4 on (C4.CNO=C1.CNO)  
Where C1.CStatus='A' and C1.CType<>'C' 
--and Coalesce(C2.GROSS_OS,0)=0  
and C1.ADate<=@P_PDate  
and Not Exists (Select pCNO from Claim Where Claim.pCNO=C1.CNO)  --no Correction
and TOC.COB='02'  -- Motor Vehicle Only
and datediff(day,C1.ADate, @P_PDate)>@Lapse  
and datediff(day,C1.ADate+@Lapse+1, @P_PDate) % @Freq =0  
Group by Su.ID, Su.Name, C1.ADate, A.PolicyNo, A.CertificateNo, C1.ClaimNo, C1.ADate, A.AName
having sum((C2.Claim-C2.Deductible-C2.Salvage-C2.Subrogation+C2.Cost)*C2.Share/100*(100-C3.MShare)/100*C2.Rate)<=Max(St.LimitOut)

Union All

Select Su.ID as SID, 'Name : '+Su.Name as Name, '' as MID,  
'Reminder-'+cast((datediff(day,C1.ADate+@Lapse+1, @P_PDate) / @Freq+1) as varchar(10))+' : Auto Claim Close Notification' as Subject,   
'Lapse : ' + cast(datediff(day,C1.ADate, @P_PDate) as varchar(10)) + ' day(s)'
+' ,'+'Policy No : '+A.PolicyNo+Case When A.CertificateNo<>'' Then '-'+A.CertificateNo else '' end  
+' ,'+'Claim No No : '+C1.ClaimNo
+' ,'+'Approved As At :'+convert(varchar(20), C1.ADate,6)  
+' ,'+'Insured Name :'+A.AName as Message  
from Claim C1  
Inner Join CCalc C2 on (C2.CNO=C1.CNO)
Inner Join CArrHeader C3 on (C3.CNO=C2.CNO)
Inner Join Acceptance A on (A.ANO=C1.ANO)
Inner Join Cover C on (C.CNO=A.CNO)  
Inner Join SysUser S on (S.ID=C1.AUserID)  
Inner Join SysUser Su on (Su.ID=S.MID and Su.Expiry>getdate() and Su.AllowedF=1)
Inner Join SysUserTOC St on (St.ID=Su.ID and St.TOC=A.TOC)
Inner Join TOC on (TOC.TOC=C1.TOC)
Left Join OS_Claim_By_detail(@P_PDate) C4 on (C4.CNO=C1.CNO)  
Where C1.CStatus='A' and C1.CType<>'C' 
--and Coalesce(C2.GROSS_OS,0)=0  
and C1.ADate<=@P_PDate  
and Not Exists (Select pCNO from Claim Where Claim.pCNO=C1.CNO)  --no Correction
and TOC.COB='02'  -- Motor Vehicle Only
and datediff(day,C1.ADate, @P_PDate)>@Lapse  
and datediff(day,C1.ADate+@Lapse+1, @P_PDate) % @Freq =0  
Group by Su.ID, Su.Name, C1.ADate, A.PolicyNo, A.CertificateNo, C1.ClaimNo, C1.ADate, A.AName
having sum((C2.Claim-C2.Deductible-C2.Salvage-C2.Subrogation+C2.Cost)*C2.Share/100*(100-C3.MShare)/100*C2.Rate)<=Max(St.LimitOut)

GO

  insert into PatchVersioning
select 'Update Script -   AutoEmail_Notification',GETDATE()
go