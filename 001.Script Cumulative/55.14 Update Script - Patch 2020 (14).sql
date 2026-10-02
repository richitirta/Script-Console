IF EXISTS ( SELECT * FROM   sysobjects WHERE  id = object_id(N'QRDOCLIST') and OBJECTPROPERTY(id, N'IsProcedure') = 1 )
BEGIN
DROP Procedure QRDOCLIST 
END
GO
CREATE Procedure QRDOCLIST(@P_Request as varchar(20)) 
as 
Select * 
from 
( 
Select Cast(0 as bit) as ProcessFlag, DOCTYPE.DOCTYPE, DOCTYPE.DESCRIPTION, Cast(0 as bit) as AvailableF, Cast(Null as smalldatetime) as RECDATE
from DocType 
Where DocType.Purpose='PAYMENT' and DocType.AllowedF=1 and NOT EXISTS (Select DocType from RDocList Where RDocList.DocType=DocType.DocType and Request=@P_Request) 
 
Union All 
 
select RDOCLIST.AvailableF as ProcessFlag, RDOCLIST.DOCTYPE, RDOCLIST.Description, RDOCLIST.AvailableF as AvailableF, RDOCLIST.RECDATE 
from RDOCLIST 
Where RDOCLIST.Request=@P_Request 
 
) RDOCLIST 
Order By RDOCLIST.DOCTYPE 
GO

 
insert into PatchVersioning
select '55.14 Update Script - Patch 2020 (14)',GETDATE()
go


Declare @PrevScript varchar(100)
Declare @CurrScript varchar(100)

Select @PrevScript='55.13 Update Script - Patch 2020 (13)'
Select @CurrSCript='55.14 Update Script - Patch 2020 (14)'


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



 

