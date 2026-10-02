IF EXISTS ( SELECT * FROM   sysobjects WHERE  id = object_id(N'[dbo].[AutoAccAss_Deferred]') and OBJECTPROPERTY(id, N'IsProcedure') = 1 )
begin
DROP Procedure AutoAccAss_Deferred
end
GO
CREATE Procedure AutoAccAss_Deferred(@P_PDate as smalldatetime)                                        
as             
Select Top 50000 Acceptance.ANO, Acceptance.SDate, Acceptance.EDate, Acceptance.PDate, Acceptance.ADate, pAcceptance.SDate as PrevSDate, pAcceptance.EDate as PrevEDate
from Acceptance with(readcommitted)  
Left Join Acceptance pAcceptance with(readcommitted) on (pAcceptance.ANO=Acceptance.pANO)
Inner join Cover with(readcommitted) on (Cover.CNO=Acceptance.CNO)  
Inner Join TOC with(readcommitted) on (TOC.TOC=Acceptance.TOC)  
where Acceptance.ANO<>Acceptance.LANO   
and datediff(month, Acceptance.SDate, Acceptance.EDate)>=TOC.DPremium     
and Acceptance.ADate<=@P_PDate   
and (Acceptance.AStatus not in ('W','T') and Cover.CStatus<>'C')  
and not Exists (Select Top 1 A1.ANO from AccAss_Deferred A1 Where A1.ANO=Acceptance.ANO) 

GO

