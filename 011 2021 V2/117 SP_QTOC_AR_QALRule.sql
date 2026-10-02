DROP PROCEDURE QALRule
GO
CREATE PROCEDURE QALRule (@TOC as varchar(10),@Branch as varchar(10),@Segment as varchar(10),@Source as varchar(10))      
as      
select top 1 * from ALRule where toc = @TOC and Branch=@Branch and Segment=@Segment and Source=@Source;
GO
DROP PROCEDURE [dbo].[QTOC_AR]
GO
CREATE PROCEDURE [dbo].[QTOC_AR] (@TOC Varchar(10))                  
AS                  
BEGIN                  
Select CAST(0 As Bit) ProcessFlag , ALRule.*, Branch.Name as BName, Segment.Description as SDescription, Profile.Name as SourceName 
from ALRule 
Left join Branch On (Branch.Branch=ALRule.Branch) 
Left Join Segment On (Segment.Segment=ALRule.Segment) 
Left join Profile On (Profile.ID=ALRule.Source) 
where ALRule.TOC = @TOC;     
END
go


insert into PatchVersioning
select '117 SP_QTOC_AR_QALRule',GETDATE()
go


Declare @PrevScript varchar(100)
Declare @CurrScript varchar(100)

Select @PrevScript=''
Select @CurrSCript='117 SP_QTOC_AR_QALRule'


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