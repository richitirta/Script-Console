DROP Procedure QScheme_Verify_5  
GO
CREATE Procedure QScheme_Verify_5  
@p_TSI as float,  
@P_Coverage as varchar(255),  
@p_SchemeNo as varchar (10),  
@p_Description as varchar (255)  
as

Declare @p_ClassNo int 
Select Top 1 @p_ClassNo=S.ClassNo 
from 
Scheme_Class S
Inner Join Scheme_Coverage S1 on (S1.ClassNo=S.ClassNo and S1.Coverage=@p_Coverage)
Where S.SchemeNo=@P_SchemeNo and @P_Description like S.Description 
Order by S.Priority Desc 
  
Select S1.DCode, S1.PCTTSI, S1.PCTCL, S1.FIXEDMIN, S1.FIXEDMAX, S1.Currency, S1.IUNIT, S1.Remarks, S1.Remarks_1, S1.TOR, S1.STRTSI  
from Scheme_Coverage S3 
Inner Join Scheme_Deductible S1 on (S1.ClassNo=S3.ClassNo and S1.Coverage=S3.Coverage)
Inner join RateCov on (RateCov.Code=S3.Code and RateCov.TOR=S1.TOR)
Where S3.ClassNo=@p_ClassNo and S3.Coverage=@P_Coverage and @p_TSI Between S1.Lower and S1.Upper
go


 insert into PatchVersioning	
select '639 Update Script - Patch 2023 (44)',GETDATE()
go





Declare @PrevScript varchar(100)
Declare @CurrScript varchar(100)

Select @PrevScript=''
Select @CurrSCript='639 Update Script - Patch 2023 (44)'


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





