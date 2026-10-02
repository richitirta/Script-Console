
insert into PatchVersioning
select '57.20 Update Patch - Patch 2021 (5)',GETDATE()
go

Declare @PrevScript varchar(100)
Declare @CurrScript varchar(100)

Select @PrevScript='57.19 Update Patch - Patch 2021 (4)'
Select @CurrSCript='57.20 Update Patch - Patch 2021 (5)'


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
			DROP Procedure QACCDOCLIST
			DROP Procedure QCDOCLIST

       END TRY  
       BEGIN CATCH  
       END CATCH;


       Update SysTab Set ExecScript=@CurrScript, ExecScriptStatus='DONE'         
End


GO
CREATE Procedure QACCDOCLIST(@P_ANO integer)   
as   
Select A1.ProcessFlag, A1.MandatoryF, A1.DocType, A1.Description, A1.AvailableF, A1.CollectionF, A1.RecDate, Max(A2.ImageID) as ImageID, Count(A2.ImageID) as CountImage
from   
(   
	select Cast(coalesce(ACCDOCLIST.AvailableF, 0) as bit) as ProcessFlag, cast(coalesce(PDOCLIST.MandatoryF,0) as Bit) as MandatoryF, ACCDOCLIST.DocType, ACCDOCLIST.Description, ACCDOCLIST.AvailableF, cast(coalesce(DOCTYPE.CollectionF,0) as Bit) as CollectionF, ACCDOCLIST.RECDATE   
	from Acceptance
	Inner Join ACCDOCLIST on (ACCDOCLIST.ANO=ACCEPTANCE.OANO)
	Left Join DOCTYPE on (DOCTYPE.DOCTYPE=ACCDOCLIST.DOCTYPE)   
	LEFT JOIN PDOCLIST ON (PDOCLIST.TOC=ACCEPTANCE.TOC AND PDOCLIST.DOCTYPE=ACCDOCLIST.DOCTYPE) 
	Where Acceptance.ANO=@P_ANO   

	Union All

	select Cast(coalesce(ACCDOCLIST.AvailableF, 0) as bit) as ProcessFlag, cast(coalesce(PDOCLIST.MandatoryF,0) as Bit) as MandatoryF, MACCDOCLIST.DocType, MACCDOCLIST.Description, Cast(coalesce(ACCDOCLIST.AvailableF, 0) as bit) as AvailableF, cast(coalesce(DOCTYPE.CollectionF,0) as Bit) as CollectionF, ACCDOCLIST.RECDATE
	from ACCEPTANCE 
	INNER JOIN COVER ON (COVER.CNO=ACCEPTANCE.CNO) 
	INNER JOIN ACCEPTANCE MA on (Cover.OpenFlag=1 and ACCEPTANCE.ANO<>ACCEPTANCE.LANO AND MA.ANO=ACCEPTANCE.LANO)
	Inner Join ACCDOCLIST MACCDOCLIST on (MACCDOCLIST.ANO=MA.OANO)
	INNER JOIN PDOCLIST ON (PDOCLIST.TOC=ACCEPTANCE.TOC AND PDOCLIST.DOCTYPE=MACCDOCLIST.DOCTYPE) 
	Left join DOCTYPE on (DOCTYPE.DOCTYPE=PDOCLIST.DOCTYPE)   
	Left Join ACCDOCLIST on (ACCDOCLIST.ANO=Acceptance.OANO and ACCDOCLIST.DOCTYPE=MACCDOCLIST.DOCTYPE)   
	Where Acceptance.ANO=@P_ANO and coalesce(ACCDOCLIST.DocType,'')=''

	Union All

	select Cast(coalesce(ACCDOCLIST.AvailableF, 0) as bit) as ProcessFlag, cast(coalesce(PDOCLIST.MandatoryF,0) as Bit) as MandatoryF, PDOCLIST.DocType, coalesce(ACCDOCLIST.Description, PDOCLIST.Description) as Description, Cast(coalesce(ACCDOCLIST.AvailableF, 0) as bit) as AvailableF, cast(coalesce(DOCTYPE.CollectionF,0) as Bit) as CollectionF, ACCDOCLIST.RECDATE   
	from ACCEPTANCE 
	INNER JOIN COVER ON (COVER.CNO=ACCEPTANCE.CNO) 
	INNER JOIN PDOCLIST ON (PDOCLIST.TOC=ACCEPTANCE.TOC) 
	Left join DOCTYPE on (DOCTYPE.DOCTYPE=PDOCLIST.DOCTYPE)   
	Left Join ACCDOCLIST on (ACCDOCLIST.ANO=Acceptance.OANO and ACCDOCLIST.DOCTYPE=PDOCLIST.DOCTYPE)   
	Where Acceptance.ANO=@P_ANO and coalesce(ACCDOCLIST.DocType,'')=''
	and not exists (Select TOP 1 MACCDOCLIST.DOCTYPE FROM ACCEPTANCE MA, ACCDOCLIST MACCDOCLIST Where Cover.OpenFlag=1 and ACCEPTANCE.ANO<>ACCEPTANCE.LANO and MA.ANO=ACCEPTANCE.LANO AND MACCDOCLIST.ANO=MA.OANO)    
) A1 
Left Join ACCDOCLISTPIC A2 on (A2.ANO=@P_ANO and A2.DocType=A1.DocType)
Group By A1.ProcessFlag, A1.MandatoryF, A1.DocType, A1.Description, A1.AvailableF, A1.CollectionF, A1.RecDate
Order By A1.DOCTYPE   

GO


GO
CREATE Procedure QCDOCLIST(@P_CNO integer, @P_INO integer, @P_NOC varchar(10))   
as   
Select CDOCLIST.ProcessFlag, CDOCLIST.RequiredF, CDOCLIST.RequiredBy, CDOCList.RequiredDate, CDOCLIST.MandatoryF, CDOCLIST.DocType, CDOCLIST.Description, CDOCLIST.AvailableF, CDOCLIST.CollectionF, CDOCLIST.RecDate, CDOCLIST.OptionalF, Max(CDOCLISTPIC.IMAGEID) as IMAGEID, Count(CDOCLISTPIC.IMAGEID) as CountImage
from   
(   
	select Cast(coalesce(CDOCLIST.AvailableF, 0) as bit) as ProcessFlag, Cast(coalesce(CDOCLIST.requiredF, 0) as bit) as requiredF, CDOCLIST.RequiredBy, CDOCList.RequiredDate, cast(coalesce(DOCLIST.MandatoryF,0) as Bit) as MandatoryF, DOCLIST.DocType, coalesce(CDOCLIST.Description, DOCLIST.Description) as Description, coalesce(CDOCLIST.AvailableF, 0) as AvailableF, cast(coalesce(DOCTYPE.CollectionF,0) as Bit) as CollectionF, CDOCLIST.RecDate, cast(coalesce(DocType.OptionalF,0) as Bit) as OptionalF   
	from ICover
	Inner join DocList on (DocList.NOC=@P_NOC and DocList.TOI=ICover.TOI)
	Left join DOCTYPE on (DOCTYPE.DOCTYPE=DOCLIST.DOCTYPE) 
	Left Join CDOCLIST on (CDOCLIST.CNO=@P_CNO and CDOCLIST.INO=ICover.INO and CDOCLIST.DOCTYPE=DOCLIST.DOCTYPE)   
	Where ICover.INO=@P_INO and coalesce(CDOCLIST.DOCTYPE,'')=''
	   
	Union All   
   
	select Cast(coalesce(CDOCLIST.AvailableF, 0) as bit) as ProcessFlag, Cast(coalesce(CDOCLIST.requiredF, 0) as bit) as requiredF, CDOCLIST.RequiredBy, CDOCList.RequiredDate, cast(coalesce(DOCLIST.MandatoryF,0) as Bit) as MandatoryF, CDOCList.DocType, CDOCLIST.Description, CDOCLIST.AvailableF, cast(coalesce(DOCTYPE.CollectionF,0) as Bit) as CollectionF, CDOCLIST.RecDate, cast(coalesce(DocType.OptionalF,0) as Bit) as OptionalF
	from CDOCLIST 
	Inner Join ICover on (ICover.INO=@P_INO)
	Left Join DocList On (DocList.NOC=CDocList.NOC and DocList.TOI=ICover.TOI and DocList.DocType=CDocList.DocType)
	Left Join DOCTYPE on (DOCTYPE.DOCTYPE=CDOCLIST.DOCTYPE)   
	Where CDOCLIST.CNO=@P_CNO AND CDOCLIST.INO=@P_INO   
) CDOCLIST 
LEFT JOIN CDOCLISTPIC ON (CDOCLISTPIC.CNO=@P_CNO AND CDOCLISTPIC.DOCTYPE=CDOCLIST.DOCTYPE)
Group by CDOCLIST.ProcessFlag, CDOCLIST.RequiredF, CDOCLIST.RequiredBy, CDOCList.RequiredDate, CDOCLIST.MandatoryF, CDOCLIST.DocType, CDOCLIST.Description, CDOCLIST.AvailableF, CDOCLIST.CollectionF, CDOCLIST.RecDate, CDOCLIST.OptionalF
Order By CDOCLIST.DOCTYPE   
   




