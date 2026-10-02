
DROP Procedure QFEEDUTY 
GO
CREATE Procedure QFEEDUTY (@P_ANO integer)
as
SELECT ACCFD.ID, ACCFD.PolicyYear, ACCFD.Currency, ACCFD.Amount, ACCFD.AmountPCT, ACCFD.AmountPCTBased, ACCFD.ContributionF, FDTAB.FDTYPE, FDTAB.DESCRIPTION, RCover.Code as RCode
FROM ACCFD
Inner Join FDTAB on (FDTAB.FDID=ACCFD.FDID)
Cross Apply (
	Select Top 1 R.Code 
	from RCover R
	Inner Join Acceptance A on (A.ANO=R.ANO)
	Where R.ANO=@P_ANO and R.Category='M'
	and Case When ACCFD.PolicyYear=0 Then A.SDate else DateAdd(year, AccFD.PolicyYear - 1, A.SDate) End Between R.SDate and R.EDate
	Order by R.SDate desc
) RCover
WHERE ACCFD.ANO=@P_ANO
GO


 insert into PatchVersioning	
select '694 Update Script - Patch 2023 (67)',GETDATE()
go





Declare @PrevScript varchar(100)
Declare @CurrScript varchar(100)

Select @PrevScript=''
Select @CurrSCript='694 Update Script - Patch 2023 (67)'


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


