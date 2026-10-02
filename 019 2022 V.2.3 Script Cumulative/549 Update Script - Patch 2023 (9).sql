DROP Function FN_FDTAB
GO
Create Function FN_FDTAB(@P_ANO as integer)
RETURNS Table 
AS RETURN ( 

Select FDTAB.*
from FDTAB
Inner Join SysTab on (1=1)
Inner Join Currency on (Currency.Currency=FDTab.Currency and Currency.AllowedF=1)
Left Join (Select ANO, TOC from Acceptance Where ANO=@P_ANO) TOC on (TOC.ANO=@P_ANO)
Left Join FDTABTOC on (FDTABTOC.FDID=FDTAB.FDID and FDTABTOC.TOC=TOC.TOC)
Left Join (Select Distinct ANO, Currency from ICover Where ANO=@P_ANO) ICover on (ICover.ANO=@P_ANO and ICover.Currency=Currency.Currency)
Where  (Currency.Currency=SysTab.Currency or Currency.Currency=ICover.Currency)
and (FDTAB.ApplyTOCF=0 or coalesce(FDTABTOC.TOC,'')<>'')

) 

go


 insert into PatchVersioning	
select '549 Update Script - Patch 2023 (9)',GETDATE()
go





Declare @PrevScript varchar(100)
Declare @CurrScript varchar(100)

Select @PrevScript=''
Select @CurrSCript='549 Update Script - Patch 2023 (9)'


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

