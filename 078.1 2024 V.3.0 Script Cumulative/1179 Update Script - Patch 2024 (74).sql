DROP procedure QMissing_Risk
GO
CREATE  procedure QMissing_Risk(@P_ANO integer) 
as 
Select Top 1 A1.ANO 
from Acceptance A1 
Where A1.ANO=@P_ANO
and 
(
not exists (Select Top 1 R1.ANO from RCover R1 Where R1.Category='M' and R1.ANO=A1.ANO and (R1.SDate=A1.SDate or  R1.SDate=A1.PDate)) or
not exists (Select Top 1 R1.ANO from RCover R1 Where R1.Category='M' and R1.ANO=A1.ANO and R1.EDate=A1.EDate) or
exists (
	Select top 1 R1.ANO
	from RCover R1 
	Where R1.Category='M' and R1.ANO=A1.ANO and not ((R1.SDate=A1.SDate or  R1.SDate=A1.PDate) and R1.EDate=A1.EDate)
	and Not Exists
	( 
		Select Top 1 R2.ANO 
		from RCover R2 
		Where R2.Category='M' and R2.ANO=R1.ANO 
		and not (R2.Code=R1.Code and R2.Sdate=R1.Sdate) 
		and 
		( 
		(R2.Sdate<=R1.Edate and R2.Edate>=R1.Edate) or (R2.Sdate<=R1.Sdate and R2.Edate>=R1.Sdate) or 
		(R1.Sdate<=R2.Sdate and R1.Edate>=R2.Sdate) or (R1.Sdate<=R2.Edate and R1.Edate>=R2.Edate) 
		) 
	) 
	)
)


Union All
 
Select Top 1 A1.ANO 
from Acceptance A1
Inner Join RCover R1 on (R1.ANO=A1.ANO)
Inner Join RateTab R3 on (R3.Code=R1.Code)
Where A1.ANO=@P_ANO 
and R1.Category='A' and R3.TOR<>''
and Not Exists
(
	Select Top 1 R2.ANO 
	from RCover R2
	Inner Join RateCov R4 on (R4.Code=R2.Code and R4.TOR=R3.TOR)
	Where R2.Category='M' and R2.ANO=R1.ANO 
	and R1.SDate Between R2.SDate and R2.EDate
	and R1.EDate Between R2.SDate and R2.EDate
	
)
go


  insert into PatchVersioning
select '1179 Update Script - Patch 2024 (74)',GETDATE()
go	
  
Declare @PrevScript varchar(100)
Declare @CurrScript varchar(100)

Select @PrevScript=''
Select @CurrSCript='1179 Update Script - Patch 2024 (74)'


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


