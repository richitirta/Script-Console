IF EXISTS ( SELECT * FROM   sysobjects WHERE  id = object_id(N'[dbo].[AutoGenerateRenewal_Process]') and OBJECTPROPERTY(id, N'IsProcedure') = 1 )
begin
DROP Procedure AutoGenerateRenewal_Process
end
GO
Create Procedure AutoGenerateRenewal_Process(@P_PDate as smalldatetime)                                
as                       
Select Acceptance.PolicyNo, Acceptance.CertificateNo, Acceptance.LANO, Acceptance.ANO, Acceptance.Branch, Cover.OpenFlag, Acceptance.TOC 
from Acceptance
Inner Join Cover on (Cover.CNO=Acceptance.CNO)
Inner Join TOC on (TOC.TOC=Acceptance.TOC and TOC.RNDays<>0)
Inner Join Segment on (Segment.Segment=Cover.Segment and Segment.AutoGenerateRenewalF=1)
Where  Acceptance.ANO<>Acceptance.LANO and Cover.ISType in ('I','L','C','R') 
and Acceptance.RenewableF=1 and Acceptance.AStatus in ('I','C') and Cover.CStatus<>'C'       
and Acceptance.AType not in ('C','A')           
and not exists (Select Top 1 ANO from Renewal Where (Renewal.Status<>'O' or not (TOC.RenewalDataF=1 and Renewal.PStatus='I')) and Renewal.ANO=Acceptance.ANO)          
and not exists (Select Top 1 PANO from Acceptance nA Where nA.AStatus in ('I','C') and nA.AType not in ('A') and nA.pANO=Acceptance.ANO)          
and Acceptance.EDate Between @P_PDate and dateadd(day, TOC.RNDays,@P_PDate)

GO



