Drop Procedure AutoClaim_Close
GO
CREATE Procedure AutoClaim_Close(@P_PDate as smalldatetime)                      
as                      
Select C1.CNO, Max(C1.CStatus) as CStatus, cast(Max(cast(C1.SettledF as Int)) as bit) as SettledF, max(C1.CSDate) as CSDate, Max(C1.ClaimNo) as ClaimNo, Max(C1.LUserID) as LUserID
from Claim C1  
Inner Join TOC on (TOC.TOC=C1.TOC)
Left Join OS_Claim_By_detail(@P_PDate) C2 on (C2.CNO=C1.CNO)  
Where C1.CStatus='A' and C1.CType<>'C' 
and C1.ADate<=@P_PDate 
and Not Exists (Select pCNO from Claim Where Claim.pCNO=C1.CNO)  --no Correction
and datediff(day,dateadd(day, 30, C1.ADate),@P_PDate)>0   --60 Days After Last Claim Approved
Group by C1.CNO
Having sum(Coalesce(C2.GROSS_OS,0))=0 and sum(Coalesce(C2.EXPENSE_OS,0))=0 and sum(Coalesce(C2.GROSS_OS_NET,0))=0
GO



insert into PatchVersioning
select '1002 Update Script - AutoClaim_Close',GETDATE()
go
	

Declare @PrevScript varchar(100)
Declare @CurrScript varchar(100)

Select @PrevScript=''
Select @CurrSCript='1002 Update Script - AutoClaim_Close'


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