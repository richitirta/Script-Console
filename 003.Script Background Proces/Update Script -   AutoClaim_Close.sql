IF EXISTS ( SELECT * FROM   sysobjects WHERE  id = object_id(N'AutoClaim_Close') and OBJECTPROPERTY(id, N'IsProcedure') = 1 )
BEGIN
DROP Procedure AutoClaim_Close
end
GO
CREATE Procedure AutoClaim_Close(@P_PDate as smalldatetime)                      
as                      
Select C1.CNO, C1.CSDate, C1.CStatus, C1.ClaimNo, C1.SettledF  
from Claim C1  
Inner Join TOC on (TOC.TOC=C1.TOC)
Left Join OS_Claim_By_detail(@P_PDate) C2 on (C2.CNO=C1.CNO)  
Where C1.CStatus='A' and C1.CType<>'C' 
--and Coalesce(C2.GROSS_OS,0)=0  
and C1.ADate<=@P_PDate 
and Not Exists (Select pCNO from Claim Where Claim.pCNO=C1.CNO)  --no Correction
and TOC.COB='02'  -- Motor Vehicle Only
and datediff(day,dateadd(day, 60, C1.ADate),@P_PDate)>0   --60 Days After Last Claim Approved

go

  insert into PatchVersioning
select 'Update Script -   AutoClaim_Close',GETDATE()
go