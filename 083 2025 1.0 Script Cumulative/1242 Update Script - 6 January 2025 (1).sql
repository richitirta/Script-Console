IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'EFFECTIVE' AND Object_ID = Object_ID(N'DOCLIST'))
BEGIN
SET QUOTED_IDENTIFIER ON
SET ARITHABORT ON
SET NUMERIC_ROUNDABORT OFF
SET CONCAT_NULL_YIELDS_NULL ON
SET ANSI_NULLS ON
SET ANSI_PADDING ON
SET ANSI_WARNINGS ON
 
ALTER TABLE dbo.DOCLIST ADD
	EFFECTIVE smalldatetime NULL
 
DECLARE @v sql_variant 
SET @v = N'Effective Date the Document Check List Applied'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'DOCLIST', N'COLUMN', N'EFFECTIVE'
end
GO

DROP Procedure QCDOCLIST
GO
CREATE Procedure QCDOCLIST(@P_CNO integer, @P_INO integer, @P_NOC varchar(10))   
as   

Declare @P_RegDate as smalldatetime

Select @P_RegDate=C2.RegDate from Claim C1, Claim C2 Where C1.CNO=@P_CNO and C2.CNO=C1.OCNO

Select CDOCLIST.ProcessFlag, CDOCLIST.RequiredF, CDOCLIST.RequiredBy, CDOCList.RequiredDate, CDOCLIST.MandatoryF, CDOCLIST.DocType, CDOCLIST.Description, CDOCLIST.AvailableF, CDOCLIST.CollectionF, CDOCLIST.RecDate, CDOCLIST.OptionalF, CDOCLIST.REMARKS, Max(CDOCLISTPIC.IMAGEID) as IMAGEID, Count(CDOCLISTPIC.IMAGEID) as CountImage
from   
(   
	select Cast(coalesce(CDOCLIST.AvailableF, 0) as bit) as ProcessFlag, Cast(coalesce(CDOCLIST.requiredF, 0) as bit) as requiredF, CDOCLIST.RequiredBy, CDOCList.RequiredDate, cast(coalesce(DOCLIST.MandatoryF,0) as Bit) as MandatoryF, DOCLIST.DocType, DOCLIST.Description, coalesce(CDOCLIST.AvailableF, 0) as AvailableF, cast(coalesce(DOCTYPE.CollectionF,0) as Bit) as CollectionF, CDOCLIST.RecDate, cast(coalesce(DocType.OptionalF,0) as Bit) as OptionalF, '' as Remarks
	from ICover
	Inner join DocList on (DocList.NOC=@P_NOC and DocList.TOI=ICover.TOI and DocList.Effective<=@P_RegDate)
	Left join DOCTYPE on (DOCTYPE.DOCTYPE=DOCLIST.DOCTYPE) 
	Left Join CDOCLIST on (CDOCLIST.CNO=@P_CNO and CDOCLIST.INO=ICover.INO and CDOCLIST.DOCTYPE=DOCLIST.DOCTYPE)   
	Where ICover.INO=@P_INO and coalesce(CDOCLIST.DOCTYPE,'')=''
	   
	Union All   
   
	select Cast(coalesce(CDOCLIST.AvailableF, 0) as bit) as ProcessFlag, Cast(coalesce(CDOCLIST.requiredF, 0) as bit) as requiredF, CDOCLIST.RequiredBy, CDOCList.RequiredDate, cast(coalesce(DOCLIST.MandatoryF,0) as Bit) as MandatoryF, CDOCList.DocType, CDOCLIST.Description, CDOCLIST.AvailableF, cast(coalesce(DOCTYPE.CollectionF,0) as Bit) as CollectionF, CDOCLIST.RecDate, cast(coalesce(DocType.OptionalF,0) as Bit) as OptionalF, CDoclist.REMARKS 
	from CDOCLIST 
	Inner Join ICover on (ICover.INO=@P_INO)
	Left Join DocList On (DocList.NOC=CDocList.NOC and DocList.TOI=ICover.TOI and DocList.Effective<=@P_RegDate and DocList.DocType=CDocList.DocType)
	Left Join DOCTYPE on (DOCTYPE.DOCTYPE=CDOCLIST.DOCTYPE)   
	Where CDOCLIST.CNO=@P_CNO AND CDOCLIST.INO=@P_INO   
) CDOCLIST 
LEFT JOIN CDOCLISTPIC ON (CDOCLISTPIC.CNO=@P_CNO AND CDOCLISTPIC.DOCTYPE=CDOCLIST.DOCTYPE)
Group by CDOCLIST.ProcessFlag, CDOCLIST.RequiredF, CDOCLIST.RequiredBy, CDOCList.RequiredDate, CDOCLIST.MandatoryF, CDOCLIST.DocType, CDOCLIST.Description, CDOCLIST.AvailableF, CDOCLIST.CollectionF, CDOCLIST.RecDate, CDOCLIST.OptionalF, CDOCLIST.REMARKS
Order By CDOCLIST.DOCTYPE   
   
GO


  insert into PatchVersioning
select '1242 Update Script - 6 January 2025 (1)',GETDATE()
go	
  
Declare @PrevScript varchar(100)
Declare @CurrScript varchar(100)

Select @PrevScript=''
Select @CurrSCript='1242 Update Script - 6 January 2025 (1)'


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