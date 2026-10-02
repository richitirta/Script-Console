
insert into PatchVersioning
select '56.7 Update Patch - Patch 2020 (57)',GETDATE()
go

Declare @PrevScript varchar(100)
Declare @CurrScript varchar(100)

Select @PrevScript='56.6 Update Patch - Patch 2020 (54)'
Select @CurrSCript='56.7 Update Patch - Patch 2020 (57)'


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
			
			DROP PROCEDURE CLAIM_FREQ_BY_POLICY
			DROP PROCEDURE OWN_FAULT_BY_POLICY
       END TRY  
       BEGIN CATCH  
       END CATCH;


       Update SysTab Set ExecScript=@CurrScript, ExecScriptStatus='DONE'         
End

GO
CREATE PROCEDURE CLAIM_FREQ_BY_POLICY(@P_PolicyNo as varchar(50),@P_CERTIFICATENO as varchar(20))
AS
Select ceiling(sum(CLAIM_FREQ)*cast(12 as Float)/Cast(Max(NumMonths) as Float))as CLAIM_FREQ
from 
(
       SELECT coalesce(Max(C2.Multiplier),1) as CLAIM_FREQ, Max(datediff(month, A.SDate, A.EDate)) as NumMonths
       from Claim C1
	   Inner Join Acceptance A on (A.ANO=C1.ANO)
       Left Join CLDED C2 on (C2.CNO=C1.CNO)
       Where C1.PolicyNo=@P_PolicyNO and C1.CertificateNo=@P_CertificateNo and C1.CType<>'C' 
       and (C1.CStatus in ('P','T','A') or C1.pCStatus in ('A')) and not exists (Select pCNO from Claim Where Claim.pCNO=C1.CNO and Claim.CStatus<>'R')
       Group By C1.OCNO
) C
GO

GO
CREATE PROCEDURE OWN_FAULT_BY_POLICY(@P_PolicyNo as varchar(50),@P_CERTIFICATENO as varchar(20))
AS
Select ceiling(sum(CLAIM_FREQ)*cast(12 as Float)/Cast(Max(NumMonths) as Float))as CLAIM_FREQ
from 
(
       SELECT coalesce(Max(C2.Multiplier),1) as CLAIM_FREQ, Max(datediff(month, A.SDate, A.EDate)) as NumMonths
       from Claim C1
	   Inner Join Acceptance A on (A.ANO=C1.ANO)
       Left Join CLDED C2 on (C2.CNO=C1.CNO)
	   Inner Join COLTAB on (COLTAB.COL=C1.COL and COLTAB.OWNFAULTF=1)
       Where C1.PolicyNo=@P_PolicyNO and C1.CertificateNo=@P_CertificateNo and C1.CType<>'C' 
       and (C1.CStatus in ('P','T','A') or C1.pCStatus in ('A')) and not exists (Select pCNO from Claim Where Claim.pCNO=C1.CNO and Claim.CStatus<>'R')
       Group By C1.OCNO
) C
