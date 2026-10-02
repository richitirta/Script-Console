IF EXISTS ( SELECT * FROM   sysobjects WHERE  id = object_id(N'[dbo].[AutoTotalLoss_Cancellation]') and OBJECTPROPERTY(id, N'IsProcedure') = 1 )
begin
DROP Procedure AutoTotalLoss_Cancellation
end
GO
CREATE Procedure AutoTotalLoss_Cancellation(@P_PDate as smalldatetime)              
as              
Select Distinct NAcceptance.ANO, Claim.LossDate, Cover.OpenFlag, NAcceptance.LANO, NAcceptance.RegNo, NAcceptance.RefNo, NAcceptance.RefDate, NAcceptance.Branch, NAcceptance.TOC, Claim.ClaimNo, NAcceptance.PolicyNo, NAcceptance.CertificateNo, 
NAcceptance.PolicyNo+Case When NAcceptance.CertificateNo='' then '' else '-'+NAcceptance.CertificateNo end as A_PolicyNo, 1 as AutoInforceF, 2 as NoRefundF --No Refund All
from Claim  
Inner Join Acceptance on (Acceptance.ANO=Claim.ANO)
Inner Join Acceptance NAcceptance on (NAcceptance.OANO=Acceptance.OANO and NAcceptance.AType in ('N','E') and NAcceptance.AStatus='I')
Inner Join Cover on (Cover.CNO=NAcceptance.CNO)
Inner Join CLLoss on (CLLoss.CNO=Claim.CNO and CLLoss.CTLF=1)
Inner Join TOC on (TOC.TOC=NAcceptance.TOC)
Where (NAcceptance.LANO=-1 or (NAcceptance.ANO<>NAcceptance.LANO and Cover.OpenFlag=1))             
and ((Claim.CStatus='A' or Claim.pCStatus='A')and Claim.SettledF=1 and Claim.CType in ('N','E') and Claim.ADate<=@P_PDate) 
and TOC.CancelOnTotalLossF=1 and NAcceptance.ADate<=@P_PDate




