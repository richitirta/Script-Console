IF EXISTS ( SELECT * FROM   sysobjects WHERE  id = object_id(N'AutoGenerateRenewal_Process') and OBJECTPROPERTY(id, N'IsProcedure') = 1 )
BEGIN
DROP Procedure AutoGenerateRenewal_Process
end
GO
Create Procedure AutoGenerateRenewal_Process(@P_PDate as smalldatetime)                                
as                       
Select Acceptance.PolicyNo, Acceptance.CertificateNo, Acceptance.LANO, Acceptance.ANO, Acceptance.Branch, Cover.OpenFlag, Cover.TOC from Acceptance, Cover, TOC, Segment          
Where Segment.Segment=Cover.Segment and Segment.AutoGenerateRenewalF=1 and TOC.RNDays<>0 and TOC.TOC=Cover.TOC and Acceptance.ANO<>Acceptance.LANO and Cover.ISType in ('I','L','C','R') and Cover.CNO=Acceptance.CNO and Acceptance.RenewableF=1 and Acceptance.AStatus in ('I','C') and Cover.CStatus<>'C'       
and Acceptance.AType not in ('C','A')           
and Acceptance.ANO not in (Select ANO from Renewal Where (Renewal.Status<>'O' or not (TOC.RenewalDataF=1 and Renewal.PStatus='I'))       
and Renewal.ANO=Acceptance.ANO)          
and Acceptance.ANO not in (Select PANO from Acceptance Where Acceptance.AStatus in ('I','C') and Acceptance.AType not in ('A'))          
and Acceptance.EDate Between dateadd(day,-TOC.RNDays,@P_PDate) and @P_PDate 

go



  insert into PatchVersioning
select 'Update Script - AutoGenerateRenewal_Process',GETDATE()
go