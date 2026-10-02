DROP Procedure AutoInforceCBC_Process
GO
CREATE Procedure AutoInforceCBC_Process(@P_PDate as smalldatetime)                                                  
as                                         
  
Select A.ANO, A.LANO, A.RegNo, A.Branch, C.OpenFlag, P.Gross*P.Ourshare/P.TSI as Premium, V.Voucher as pVoucher, P.Currency, S.ID, S.Param5 as AUserID
from
(
	Select S.ID, S.Param3, (case When s.ActionCode='' and coalesce(pS.ActionCode, '')<>'' then  coalesce(pS.Param5, '') else s.Param5 end) as Param5
	from SysRequest S 
	Left Join SysRequest pS on (pS.ID=s.PID) 
	Inner Join ActionList A on (A.ActionCode=(case When s.ActionCode='' and coalesce(pS.ActionCode, '')<>'' then  coalesce(pS.ActionCode, '') else s.ActionCode end) and A.ActionEndF=1 and (A.RCondition=1 or A.ApprovedFName='ALLOWPASSAPPLIMIT')) 
	Where S.Status='' and S.Param2 in ('UND-MW') and S.UserDate<=@P_PDate
) S
Inner Join Acceptance A on (A.ANO=S.Param3 and A.AType='N' and A.AStatus='W' and A.PStatus='I')
Inner Join Cover C on (C.CNO=A.CNO)
Inner Join PCalc P on (P.ANO=A.ANO)
Cross Apply (
	Select V.Voucher
	From pVoucher V
	Inner Join VType on (VType.VType=V.VType)  
	Inner Join ComAcc on (ComAcc.ComAcc=V.ComAcc)  
	Where V.Status in ('U','P') and V.SL_Cat='P' and V.DebtorF=1 and ComAcc.NonCBF=0 and Upper(VType.[Code])<>'INTERBANK' and (V.Nominal_CC-V.Diff_CC-V.Payment_CC)>0  
	and V.Currency=P.Currency  
	and (V.Nominal_CC-V.Diff_CC-V.Payment_CC)>=P.Gross*P.Ourshare/P.TSI
	and (V.RefNo=C.CoverNo or V.RefNo=A.RefNo or V.RefNo=A.RegNo)  
) V

Go



insert into PatchVersioning
select '1559 Update Script - AutoInforceCBC_Process.sql',GETDATE()
go	
  
Declare @PrevScript varchar(100)
Declare @CurrScript varchar(100)

Select @PrevScript=''
Select @CurrSCript='1559 Update Script - AutoInforceCBC_Process.sql'


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

GO 