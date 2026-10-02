DROP Procedure QFacCessionShare
GO
CREATE Procedure QFacCessionShare(@P_ANO integer)     
as     
Select 
sum(Case When RArrDet.Limit<>0 and RArrHeader.TAmount<>0 then RArrDet.Limit/RArrHeader.TAmount else 1 end *(RArrDet.Share-RArrDet.JPShare)*FPart.Share/100) as FShare,
sum(Case When RArrDet.PrecedeFacCessionF=1 or TOC.PrecedeFacCessionF=1 Then (Case When RArrDet.Limit<>0 and RArrHeader.TAmount<>0 then RArrDet.Limit/RArrHeader.TAmount else 1 end *(RArrDet.Share-RArrDet.JPShare)*FPart.Share/100) else 0 end) as PrecedeFShare
from RArrDet     
Inner join FPart on (FPart.ANO=RArrDet.ANO and FPart.FID=RArrDet.FID)
Inner Join RArrHeader on (RArrHeader.ANO=RArrDet.ANO)
Inner Join Acceptance on (Acceptance.ANO=RArrDet.ANO)     
Inner Join TOC on (TOC.TOC=Acceptance.TOC)     
Where (RArrDet.FullCoverF=1 or Exists (Select RCover.Category from FPartDet, RCover Where RCover.ANO=FPartDet.ANO and RCover.Code=FPartDet.Code and RCover.Category='M' and FPartDet.ANO=RArrDet.ANO and FPartDet.FID=RArrDet.FID))     
and RArrDet.Status<>'O' 
and RArrDet.ANO=@P_ANO     

go


 insert into PatchVersioning
select '448 Update Script - Patch 2022 (79)',GETDATE()
go


Declare @PrevScript varchar(100)
Declare @CurrScript varchar(100)

Select @PrevScript=''
Select @CurrSCript='448 Update Script - Patch 2022 (79)'


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



