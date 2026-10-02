DROP function FN_POLICY_ONRISK
GO
CREATE function FN_POLICY_ONRISK(@P_AsAt as smalldatetime)            
RETURNS Table              
AS RETURN              
(            
Select Acceptance.ANO, Acceptance.OANO, Acceptance.LANO  
from Acceptance  
Inner Join Cover on (Cover.CNO=Acceptance.CNO)  
Where Acceptance.PolicyNo<>'' and Acceptance.AType not in ('C','A') and Acceptance.AStatus not in ('W','T') and Cover.CStatus<>'C' and Acceptance.pAStatus<>'W'  
and Acceptance.ADate<=@P_AsAt and Acceptance.PDate<=@P_AsAt  
and @P_AsAt between Acceptance.PDate and Acceptance.EDate  
and not exists (  
	Select A.OANO  
	from Acceptance A  
	Inner Join Cover C on (C.CNO=A.CNO)  
	Where A.OANO=Acceptance.OANO and A.ANO>Acceptance.ANO
	and A.PolicyNo<>'' and A.AType not in ('A') and A.AStatus not in ('W','T') and C.CStatus<>'C'  
	and A.ADate<=@P_AsAt and A.PDate<=@P_AsAt  
)  
and not exists (  
	Select A.RANO  
	from Acceptance A  
	Inner Join Cover C on (C.CNO=A.CNO)  
	Where A.RANO=Acceptance.ANO   
	and A.PolicyNo<>'' and A.AType not in ('A') and A.AStatus not in ('W','T') and C.CStatus<>'C'  
	and A.ADate<=@P_AsAt and A.PDate<=@P_AsAt  
)  
)
go


insert into PatchVersioning
select '978 Update Script - FN_POLICY_ONRISK (Rev. 20240309)',GETDATE()
go


Declare @PrevScript varchar(100)
Declare @CurrScript varchar(100)

Select @PrevScript=''
Select @CurrSCript='978 Update Script - FN_POLICY_ONRISK (Rev. 20240309)'


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

 