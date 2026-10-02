DROP function FL_Get_Policy_APRule_Layout
GO
Create function FL_Get_Policy_APRule_Layout(@P_ANO as int)      
RETURNS Table      
AS RETURN      
(   
	Select R.Layout, Max(R.Description) as Description
	from
	(
		Select SysReport.RepName as Layout, SysReport.Description
		from Get_Policy_APRule(@P_ANO) R
		Inner Join SysProcID S on (S.Class=R.Class)
		Inner Join SysReport on (SysReport.Code=S.ProcID)
		Inner Join Acceptance A on (A.ANO=@P_ANO)
		Inner Join Cover C on (C.CNO=A.CNO)
		Inner Join PolicyType on (PolicyType.PolicyType=C.PolicyType)
		Where R.RepName=''
		and S.ValueID1='N'
		and S.ValueiD2=PolicyType.SType
		and S.ValueID3=C.ISType
		and S.VALUEID4=A.TOC

		Union all

		Select S.RepName as Layout, S.Description
		from Get_Policy_APRule(@P_ANO) R
		Inner Join SysProcID S on (S.Class=R.Class)
		Inner Join Acceptance A on (A.ANO=@P_ANO)
		Inner Join Cover C on (C.CNO=A.CNO)
		Inner Join PolicyType on (PolicyType.PolicyType=C.PolicyType)
		Where R.RepName=''
		and S.ValueID1='N'
		and S.ValueiD2=PolicyType.SType
		and S.ValueID3=C.ISType
		and S.VALUEID4=A.TOC
	) R
	Group by R.Layout 
)       

GO

insert into PatchVersioning
select '1550 Update Script - 19 February 2026.sql',GETDATE()
go	
  
Declare @PrevScript varchar(100)
Declare @CurrScript varchar(100)

Select @PrevScript=''
Select @CurrSCript='1550 Update Script - 19 February 2026.sql'


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