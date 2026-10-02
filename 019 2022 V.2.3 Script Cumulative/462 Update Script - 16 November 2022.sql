


if exists (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'FL_FACULTATIVE_DOCNO') AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) )
BEGIN DROP FUNCTION FL_FACULTATIVE_DOCNO END
go



CREATE FUNCTION FL_FACULTATIVE_DOCNO (@ANO Int, @PDate as smalldatetime)                    
RETURNS TABLE                    
as RETURN(                    
Select R1.DocNo, R2.DESCRIPTION, R1.ID, R1.Share, R3.Limit*R2.Share/100*R1.Share/100 as Limit, R1.Comm, Case When R2.RType='Q' Then 'QS' When R2.RType='S1' Then 'S1' When R2.RType='S2' Then 'S2' When R2.RType='S3' Then 'S3' When R2.RType='A' Then 'AF' END as RTYPE 
from Acceptance A
Inner Join Cover C on (C.CNO=A.CNO)
Left Join Profile PHolder on (PHolder.ID=C.PHOLDER)
Inner Join Reinsurance R2 on (@PDate Between R2.SDate and R2.EDate and R2.RType in ('Q','QS','S1','S2','S3','A')) 
Inner Join ReClass R3 on (R3.RNO=R2.RNO and R3.TOC=A.TOC)
Inner Join RPart R1 on (R1.RNO=R2.RNO)
Where A.ANO=@ANO
And 
	(
	 R2.ApplySegmentF=0 or (exists (Select Segment from ReSegment Where ReSegment.RNO=R2.RNO and ReSegment.Segment=C.Segment))
	)
	And 
	(
	 R2.ApplyCGroupF=0 or (exists (Select CGroup from ReCGroup Where ReCGroup.RNO=R2.RNO and ReCGroup.CGroup=PHolder.CGroup))
	)
)                                    

go



 insert into PatchVersioning
select '462 Update Script - 16 November 2022',GETDATE()
go


Declare @PrevScript varchar(100)
Declare @CurrScript varchar(100)

Select @PrevScript=''
Select @CurrSCript='462 Update Script - 16 November 2022'


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
