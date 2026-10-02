if exists (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'FN_GENDTAB') AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) ) 
BEGIN 
DROP FUNCTION FN_GENDTAB
end
GO
CREATE FUNCTION FN_GENDTAB (@P_FLDID as varchar(10), @P_TOC as varchar(10),@P_SEGMENT as varchar(10), @P_ISTYPE as varchar(1))     
RETURNS @GENDTAB Table
(
	FLDID Varchar(10),
	VALUEID Varchar(15),
	DESCRIPTION Varchar(Max),
	AllowedF bit, 
	FLDCHGINF bit, 
	FLDID1 varchar(10), 
	VALUEID1 varchar(15),
	VALUEDESC1 varchar(255),
	FLDID2 varchar(10), 
	VALUEID2 varchar(15),
	VALUEDESC2 varchar(255),
	FLDID3 varchar(10), 
	VALUEID3 varchar(15),
	VALUEDESC3 varchar(255),
	FLDID4 varchar(10), 
	VALUEID4 varchar(15),
	VALUEDESC4 varchar(255),
	FLDID5 varchar(10), 
	VALUEID5 varchar(15),
	VALUEDESC5 varchar(255),
	FLDID6 varchar(10), 
	VALUEID6 varchar(15),
	VALUEDESC6 varchar(255),
	FLDID7 varchar(10), 
	VALUEID7 varchar(15),
	VALUEDESC7 varchar(255),
	FLDID8 varchar(10), 
	VALUEID8 varchar(15),
	VALUEDESC8 varchar(255),
	FLDID9 varchar(10), 
	VALUEID9 varchar(15),
	VALUEDESC9 varchar(255),
	FLDID10 varchar(10), 
	VALUEID10 varchar(15),
	VALUEDESC10 varchar(255),
	FLDID11 varchar(10), 
	VALUEID11 varchar(15),
	VALUEDESC11 varchar(255),
	FLDID12 varchar(10), 
	VALUEID12 varchar(15),
	VALUEDESC12 varchar(255),
	FLDID13 varchar(10), 
	VALUEID13 varchar(15),
	VALUEDESC13 varchar(255),
	FLDID14 varchar(10), 
	VALUEID14 varchar(15),
	VALUEDESC14 varchar(255),
	FLDID15 varchar(10), 
	VALUEID15 varchar(15),
	VALUEDESC15 varchar(255),
	RecentUsed Int
)
AS
BEGIN

Declare @ANO int
Select Top 1 @ANO=A.ANO 
from Acceptance A 
Inner Join Cover C on (C.CNO=A.CNO) 
Where A.TOC=@P_TOC and C.Segment Like @P_Segment+'%' and C.ISType Like @P_ISTYPE+'%' 
Order by A.ANO Desc

INSERT INTO @GENDTAB
Select G1.FLDID, G1.VALUEID, G1.DESCRIPTION, G1.AllowedF, G1.FLDCHGINF,
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
coalesce((Select Top 1 ANO from AccSearch Where AccSearch.ANO=@ANO and AccSearch.FLDID=G1.FLDID and AccSearch.ValueID=G1.ValueID),0) as RecentUsed    
from GenDTab G1 
Inner Join GenHTab G2 on (G2.FLDID=G1.FLDID)     
Where     
G1.FLDID=@P_FLDID
and
(     
G2.SubClassF=0 or @P_TOC=''     
or (G2.SubClassF=1 and EXISTS (Select Top 1 ValueID from GenDTOC G3 Where G3.FLDID=G1.FLDID and G3.VALUEID=G1.VALUEID and (G3.TOC='<All>' or G3.TOC=@P_TOC)))     
)  
and      
(     
G2.SegmentF=0 or @P_SEGMENT=''     
or (G2.SegmentF=1 and EXISTS (Select Top 1 ValueID from GenDSegment G3 Where G3.FLDID=G1.FLDID and G3.VALUEID=G1.VALUEID and (G3.SEGMENT='<All>' or G3.SEGMENT=@P_SEGMENT)))     
)  
and
(     
G2.ISTYPEF=0 or @P_ISTYPE=''     
or (G2.ISTYPEF=1 and EXISTS (Select Top 1 ValueID from GenDISTYPE G3 Where G3.FLDID=G1.FLDID and G3.VALUEID=G1.VALUEID and (G3.ISTYPE='<All>' or G3.ISTYPE=@P_ISTYPE)))     
)  

RETURN
END

GO

insert into PatchVersioning
select '62 Update Script - Patch 2021 (61)',GETDATE()
go


Declare @PrevScript varchar(100)
Declare @CurrScript varchar(100)

Select @PrevScript=''
Select @CurrSCript='62 Update Script - Patch 2021 (61)'


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
