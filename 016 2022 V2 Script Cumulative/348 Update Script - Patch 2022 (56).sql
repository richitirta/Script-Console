DROP FUNCTION FN_GENDTAB 
GO
CREATE FUNCTION FN_GENDTAB (@P_FLDID as varchar(10), @P_TOC as varchar(10),@P_SEGMENT as varchar(10), @P_ISTYPE as varchar(1))     
RETURNS Table
AS RETURN (

Select G1.FLDID, G1.VALUEID, G1.DESCRIPTION, G1.AllowedF, 
G1.FLDCHGINF,
G1.FLDID1,
G1.VALUEID1,
G1.VALUEDESC1,
G1.FLDID2,
G1.VALUEID2,
G1.VALUEDESC2,
G1.FLDID3,
G1.VALUEID3,
G1.VALUEDESC3,
G1.FLDID4,
G1.VALUEID4,
G1.VALUEDESC4,
G1.FLDID5,
G1.VALUEID5,
G1.VALUEDESC5,
G1.FLDID6,
G1.VALUEID6,
G1.VALUEDESC6,
G1.FLDID7,
G1.VALUEID7,
G1.VALUEDESC7,
G1.FLDID8,
G1.VALUEID8,
G1.VALUEDESC8,
G1.FLDID9,
G1.VALUEID9,
G1.VALUEDESC9,
G1.FLDID10,
G1.VALUEID10,
G1.VALUEDESC10,
G1.FLDID11,
G1.VALUEID11,
G1.VALUEDESC11,
G1.FLDID12,
G1.VALUEID12,
G1.VALUEDESC12,
G1.FLDID13,
G1.VALUEID13,
G1.VALUEDESC13,
G1.FLDID14,
G1.VALUEID14,
G1.VALUEDESC14,
G1.FLDID15,
G1.VALUEID15,
G1.VALUEDESC15,
Case When G1.VALUEID=(Select top 1 AccSearch.ValueID from AccSearch Where AccSearch.FLDID=@P_FLDID Order by AccSearch.ANO) Then 1 else 0 end as RecentUsed    
from GenDTab G1 
Inner Join GenHTab G2 on (G2.FLDID=G1.FLDID)    
Outer Apply (Select Top 1 ValueID from GenDTOC G3 Where G2.SubClassF=1 and @P_TOC<>'' and G3.FLDID=G1.FLDID and G3.VALUEID=G1.VALUEID and (G3.TOC='<All>' or G3.TOC=@P_TOC)) G3
Outer Apply (Select Top 1 ValueID from GenDSegment G3 Where G2.SegmentF=1 and @P_SEGMENT<>'' and G3.FLDID=G1.FLDID and G3.VALUEID=G1.VALUEID and (G3.SEGMENT='<All>' or G3.SEGMENT=@P_SEGMENT)) G4
Outer Apply (Select Top 1 ValueID from GenDISTYPE G3 Where G2.ISTYPEF=1 and @P_ISTYPE<>'' and G3.FLDID=G1.FLDID and G3.VALUEID=G1.VALUEID and (G3.ISTYPE='<All>' or G3.ISTYPE=@P_ISTYPE)) G5
Where G1.FLDID=@P_FLDID
and coalesce(G3.ValueID,case When G2.SubClassF=0 or @P_TOC='' then '<Any>' else '' end)<>'' 
and coalesce(G4.ValueID,case When G2.SegmentF=0 or @P_Segment='' then '<Any>' else '' end)<>'' 
and coalesce(G5.ValueID,case When G2.ISTypeF=0 or @P_ISType='' then '<Any>' else '' end)<>''
)

go




 insert into PatchVersioning
select '348 Update Script - Patch 2022 (56)',GETDATE()
go


Declare @PrevScript varchar(100)
Declare @CurrScript varchar(100)

Select @PrevScript=''
Select @CurrSCript='348 Update Script - Patch 2022 (56)'


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

