DROP function FL_SchemePolicy
go
CREATE function FL_SchemePolicy(@P_SchemeNo varchar(10), @P_PolicyNo varchar(50))                
RETURNS Table                  
AS RETURN                  
(                  
Select Distinct a.PolicyNo, a.AName as Insured, a.LANO, a.CNO, a.AID, S.SchemeNo   
from acceptance as a, cover as c, Scheme_Master S   
where S.TOC=A.TOC and (S.PHolder='' or S.Pholder=C.Pholder) and S.SchemeNo Like @P_SchemeNo+'%'   
and a.cno=c.cno and a.ano = a.lano and c.openflag=1   
and A.AType not in ('A','C') and a.astatus = 'I'   
and a.PolicyNo like @P_PolicyNo+'%'   
and   
(not exists (Select * from Scheme_Assignment Where SchemeNo=@P_SchemeNo)   
or exists (Select * from Scheme_Assignment Where SchemeNo=@P_SchemeNo and PolicyNo=a.PolicyNo)))    
  
  
go





insert into PatchVersioning
select '930 Update Script Fl_SchemePolicy',GETDATE()
go


Declare @PrevScript varchar(100)
Declare @CurrScript varchar(100)

Select @PrevScript=''
Select @CurrSCript='930 Update Script Fl_SchemePolicy'


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
