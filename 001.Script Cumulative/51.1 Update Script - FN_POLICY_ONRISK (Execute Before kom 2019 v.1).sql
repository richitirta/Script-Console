if exists (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'FN_POLICY_ONRISK') AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) )
BEGIN
DROP function FN_POLICY_ONRISK
end
GO
CREATE function FN_POLICY_ONRISK(@P_AsAt as smalldatetime)          
RETURNS Table            
AS RETURN            
(          
Select Acceptance.ANO
from Acceptance, Cover
Where Cover.CNO=Acceptance.CNO 
and Acceptance.ADate<=@P_AsAt and Acceptance.PolicyNo<>'' and Acceptance.AType not in ('C','A') and Acceptance.AStatus not in ('W','T') and Cover.CStatus<>'C'
and @P_AsAt between Acceptance.PDate and Acceptance.EDate
and not exists (
	Select A.PANO
	from Acceptance A, Cover C
	Where A.PANO=Acceptance.ANO and C.CNO=A.CNO 
	and A.ADate<=@P_AsAt and A.PolicyNo<>'' and A.AType not in ('A') and A.AStatus not in ('W','T') and C.CStatus<>'C'
	and @P_AsAt between A.PDate and A.EDate
)
and not exists (
	Select A.RANO
	from Acceptance A, Cover C
	Where A.RANO=Acceptance.ANO and C.CNO=A.CNO 
	and A.ADate<=@P_AsAt and A.PolicyNo<>'' and A.AType not in ('A') and A.AStatus not in ('W','T') and C.CStatus<>'C'
	and @P_AsAt between A.PDate and A.EDate
)
)              
go

insert into PatchVersioning
select '55.1 Update Script - FN_POLICY_ONRISK',GETDATE()
go

Declare @PrevScript varchar(100)
Declare @CurrScript varchar(100)

Select @PrevScript='51 Script Komulatif Konsol 2018 2.1'
Select @CurrSCript='51.1 Update Script - FN_POLICY_ONRISK (Execute Before kom 2019 v.1)'


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