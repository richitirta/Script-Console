
IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'ErrMsg' AND Object_ID = Object_ID(N'Scheme_Transaction'))
BEGIN
ALTER TABLE dbo.Scheme_Transaction ADD
	ErrMsg varchar(255)
DECLARE @v sql_variant 
SET @v = N'Error Message'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'Scheme_Transaction', N'COLUMN', N'ErrMsg'
end
GO

DROP Procedure AUTORENEWALANDCLOSESCHEME_PROCESS
GO

CREATE Procedure AUTORENEWALANDCLOSESCHEME_PROCESS(@P_PDate as smalldatetime)                                                
as                                       

Select S1.TrNo, S2.NumLapseBeforeClose 
from Scheme_Transaction S1
Inner Join Scheme_Master S2 on (S2.SchemeNo=S1.SchemeNo)
WHere S2.AutoRenewalF=1 and S1.Status<>'C'
and S1.SDate<=@P_PDate
--Not Yet Renewed
and Not Exists (Select Top 1 rTrNo from Scheme_transaction S Where S.rTrNo=S.TrNo)

--has no total loss
and Not Exists (
	Select Top 1 A.PolicyNo, A.RefNo
	from Acceptance A
	Inner Join Claim on (Claim.ANO=A.ANO)
	Inner Join CLLOSS on (CLLOSS.CNO=Claim.CNO and CLLOSS.CTLF=1)
	Where ((Claim.CStatus='A' or Claim.pCStatus='A') and Claim.SettledF=1 and Claim.CType in ('N','E') and Claim.ADate<=@P_PDate) 
	and A.PolicyNo=S1.PolicyNo and A.RefNo=S1.ContractNo 
)
go


 insert into PatchVersioning
select '295 Update Script - 30 May 2022',GETDATE()
go


Declare @PrevScript varchar(100)
Declare @CurrScript varchar(100)

Select @PrevScript=''
Select @CurrSCript='295 Update Script - 30 May 2022'


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


