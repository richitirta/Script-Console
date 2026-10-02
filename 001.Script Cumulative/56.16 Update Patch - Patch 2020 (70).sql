
insert into PatchVersioning
select '56.16 Update Patch - Patch 2020 (70)',GETDATE()
go

Declare @PrevScript varchar(100)
Declare @CurrScript varchar(100)

Select @PrevScript='56.15 Update Patch - Patch 2020 (69)'
Select @CurrSCript='56.16 Update Patch - Patch 2020 (70)'


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
			DROP function FL_UserTopro
       END TRY  
       BEGIN CATCH  
       END CATCH;


       Update SysTab Set ExecScript=@CurrScript, ExecScriptStatus='DONE'         
End


GO
CREATE function FL_UserTopro(@P_USERID varchar(50), @P_TOPRO varchar(10),@P_TOC varchar(10),@P_SEGMENT varchar(10),@P_PHOLDER varchar(10),@P_Insured varchar(10))    
RETURNS Table      
AS RETURN      
(    
SELECT Distinct TOPRO.TOPRO, TOPRO.Description, TOPRO.TOC, TOPRO.Expiry, TOPRO.CustomizableF, TOPRO.IncludeExtCoverF
from TOPRO 
Left Join TOP_Segment on (TOP_Segment.TOPRO=TOPRO.TOPRO and TOP_Segment.Segment like @P_SEGMENT)     
Left Join TOP_PHolder on (TOP_PHolder.TOPRO=TOPRO.TOPRO and TOP_PHolder.ID like @P_PHOLDER)  
Left Join TOP_Insured on (TOP_Insured.TOPRO=TOPRO.TOPRO and TOP_Insured.ID like @P_Insured)        
Where (TOPRO.TOPRO Like @P_TOPRO+'%' or TOPRO.Description like  @P_TOPRO+'%')
and TOPRO.TOC=Substring(@P_TOC, 1, len(TOPRO.TOC))
and TOPRO.AllowedF=1           
and (TOPRO.SegmentF=0 or coalesce(TOP_Segment.Segment,'')<>'')
and (TOPRO.PholderF=0 or coalesce(TOP_PHolder.ID,'')<>'') 
and (TOPRO.InsuredF=0 or coalesce(TOP_Insured.ID,'')<>'')
)

