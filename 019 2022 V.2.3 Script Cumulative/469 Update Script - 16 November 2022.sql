
DROP FUNCTION FL_FACULTATIVE_DOCNO
GO

CREATE FUNCTION FL_FACULTATIVE_DOCNO (@ANO Int, @PDate as smalldatetime)                    
RETURNS TABLE                    
as RETURN(                    
Select RPart.DocNo, Reinsurance.DESCRIPTION, RPart.ID, RPart.Share, 
Case RECLASS.Limit WHEN 0 then Reinsurance.Limit Else RECLASS.Limit end*Case When coalesce(R1.Rate,0)=0 Then (Case When Reinsurance.Currency='' or Reinsurance.Currency=SysTab.Currency Then 1 Else dbo.get_Exchange(A.SDate, Reinsurance.Currency) End) else coalesce(R1.Rate,1)*coalesce(R2.Rate,1) End*Reinsurance.Share/100*RPart.Share/100 as Limit, 
RPart.Comm, Case When Reinsurance.RType='Q' Then 'QS' When Reinsurance.RType='S1' Then 'S1' When Reinsurance.RType='S2' Then 'S2' When Reinsurance.RType='S3' Then 'S3' When Reinsurance.RType='A' Then 'AF' END as RTYPE 
from Acceptance A
Inner Join Cover C on (C.CNO=A.CNO)
Left Join Profile PHolder on (PHolder.ID=C.PHOLDER)
Inner Join Reinsurance on (@PDate Between Reinsurance.SDate and Reinsurance.EDate and Reinsurance.RType in ('Q','QS','S1','S2','S3','A')) 
Inner Join ReClass on (ReClass.RNO=Reinsurance.RNO and ReClass.TOC=A.TOC)
Inner Join RPart on (RPart.RNO=Reinsurance.RNO)
Left Join ReRate R1 on (R1.TOC=A.TOC and R1.RYear=Reinsurance.RYEAR and R1.Currency=Reinsurance.Currency)
left Join ReRate R2 on (R2.TOC=R1.TOC and R2.RYear=R1.RYear and R2.Currency=R1.CCYTo and R1.Currency<>R1.CCYTO)
Inner Join SysTab on (1=1)
Where A.ANO=@ANO
And 
	(
	 Reinsurance.ApplySegmentF=0 or (exists (Select Segment from ReSegment Where ReSegment.RNO=Reinsurance.RNO and ReSegment.Segment=C.Segment))
	)
	And 
	(
	 Reinsurance.ApplyCGroupF=0 or (exists (Select CGroup from ReCGroup Where ReCGroup.RNO=Reinsurance.RNO and ReCGroup.CGroup=PHolder.CGroup))
	)
)                                    


go


 insert into PatchVersioning
select '469 Update Script - 16 November 2022',GETDATE()
go


Declare @PrevScript varchar(100)
Declare @CurrScript varchar(100)

Select @PrevScript=''
Select @CurrSCript='469 Update Script - 16 November 2022'


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




