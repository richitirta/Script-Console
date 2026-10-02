DROP Procedure AUTORENEWALANDCLOSESCHEME_PROCESS
GO
CREATE Procedure AUTORENEWALANDCLOSESCHEME_PROCESS(@P_PDate as smalldatetime, @P_TrNo as Int=0)                                                
as                                       

Select S1.TrNo, S2.NumLapseBeforeClose, S1.SDate, mA.STime, S1.EDate, mA.ETime, C.Segment, S2.TOC, CTL.CTLF
from Scheme_Transaction S1
Inner Join Acceptance mA on (mA.ANO=S1.LANO)
Inner Join Payor on (Payor.ANO=mA.ANO)
Inner Join Cover C on (C.CNO=mA.CNO)
Inner Join Scheme_Master S2 on (S2.SchemeNo=S1.SchemeNo)
Outer Apply (
	Select Top 1 CLLOSS.CTLF
	from Acceptance A
	Inner Join Claim on (Claim.ANO=A.ANO)
	Inner Join CLLOSS on (CLLOSS.CNO=Claim.CNO and CLLOSS.CTLF=1)
	Where ((Claim.CStatus='A' or Claim.pCStatus='A') and Claim.SettledF=1 and Claim.CType in ('N','E') and Claim.ADate<=@P_PDate) 
	and A.PolicyNo=S1.PolicyNo and A.RefNo=S1.ContractNo 
) CTL
WHere S2.AutoRenewalF=1 and S1.Status<>'C'
and S1.SDate<=@P_PDate
and (@P_TrNo=0 or S1.TrNo=@P_TrNo)
--Not Yet Renewed
and Not Exists (Select Top 1 rTrNo from Scheme_transaction S Where S.rTrNo=S1.TrNo)
and Payor.DDay=day(@P_PDate)
go




 insert into PatchVersioning
select '441 Update Script - 21 October 2022',GETDATE()
go


Declare @PrevScript varchar(100)
Declare @CurrScript varchar(100)

Select @PrevScript=''
Select @CurrSCript='441 Update Script - 21 October 2022'


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
