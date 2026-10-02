

Update Admlink Set RegID=Acceptance.RegID, FLDID=Acceptance.FLDID, ValueID=Acceptance.ValueID, ValueDesc=Acceptance.ValueDesc
from Admlink, AccAss, Acceptance 
Where Acceptance.ANO=AccAss.ANO and Admlink.AdmNo=AccAss.AdmNo and Admlink.RegID is null
and Admlink.Type in ('DI', 'IR', 'IC', 'JP', 'CF', 'FO', 'FP', 'BA', 'BB', 'BO', 'BC', 'BP', 'BD', 'DP', 'DR', 'OP', 'IT', 'IX', 'PD')
go

Update Admlink Set RegID=Acceptance.RegID, FLDID=Acceptance.FLDID, ValueID=Acceptance.ValueID, ValueDesc=Acceptance.ValueDesc
from Admlink, ClaAss, Claim, Acceptance 
Where Acceptance.ANO=Claim.ANO and Claim.CNO=ClaAss.CNO and Admlink.AdmNo=ClaAss.AdmNo and Admlink.RegID is null
and Admlink.Type in ('DI', 'IR', 'IC', 'JP', 'CF', 'FO', 'FP', 'BA', 'BB', 'BO', 'BC', 'BP', 'BD', 'OP', 'VT','IT','IT')

GO



 insert into PatchVersioning	
select '655.1 Update Script - Inisialisasi 5 June 2023 (1)',GETDATE()
go





Declare @PrevScript varchar(100)
Declare @CurrScript varchar(100)

Select @PrevScript=''
Select @CurrSCript='655.1 Update Script - Inisialisasi 5 June 2023 (1)'


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



