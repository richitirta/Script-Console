DROP Procedure QRDOCLIST
GO
CREATE Procedure QRDOCLIST(@P_Request as varchar(20))     
as     
Select RDocList.*, R1.CountImage, R2.ImageId, R2.FileType  
from     
Request
Cross Apply
(     
 Select Cast(0 as bit) as ProcessFlag, DOCTYPE.DOCTYPE, DOCTYPE.DESCRIPTION as DOCTYPEDESC, DOCTYPE.DESCRIPTION, coalesce(DocType.MandatoryF, cast(0 as Bit)) as MandatoryF, Cast(0 as bit) as AvailableF, Cast(Null as smalldatetime) as RECDATE    
 from DocType     
 Where DocType.Purpose=Case When Request.CreditorF=1 Then 'PAYMENT' Else 'RECEIPT' end and DocType.AllowedF=1 and NOT EXISTS (Select DocType from RDocList Where RDocList.DocType=DocType.DocType and Request=Request.Request)     
     
 Union All     
     
 select RDOCLIST.AvailableF as ProcessFlag, RDOCLIST.DOCTYPE, DOCTYPE.DESCRIPTION as DOCTYPEDESC, RDOCLIST.Description, coalesce(DocType.MandatoryF, cast(0 as Bit)) as MandatoryF, RDOCLIST.AvailableF as AvailableF, RDOCLIST.RECDATE     
 from RDOCLIST     
 Left Join DocType on (DocType.DocType=RDocList.DocType)    
 Where RDOCLIST.Request=Request.Request     
) RDOCLIST     
Outer Apply (    
 Select count(R.ImageID) as CountImage from RDocListPIC R Where R.REQUEST=Request.Request and R.DocType=RDocList.DocType    
) R1    
Outer Apply (    
 Select Top 1 R.ImageID, R.FileType from RDocListPIC R Where R.REQUEST=Request.Request and R.DocType=RDocList.DocType Order by R.ImageID Desc  
) R2    
Where Request.Request=@P_Request
Order By RDOCLIST.DOCTYPE   
go


  insert into PatchVersioning
select '1249 Update Script - Patch 2024 (89)',GETDATE()
go	
  
Declare @PrevScript varchar(100)
Declare @CurrScript varchar(100)

Select @PrevScript=''
Select @CurrSCript='1249 Update Script - Patch 2024 (89)'


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