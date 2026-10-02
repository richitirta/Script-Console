DROP PROCEDURE CI08 
GO
--baru
Create PROCEDURE CI08 (@P_CNO AS INTEGER)
AS

Select C1.DocType, C1.Description as Remark, C2.ImageID, C2.FileType, C2.LAST_OPR, C2.LAST_UPDATE
from CLAIM 
INNER JOIN CDOCLIST C1 ON (C1.CNO=CLAIM.OCNO)
INNER JOIN CDOCLISTPIC C2 ON (C2.CNO=CLAIM.OCNO and C2.DocType=C1.DocType)
Where CLAIM.CNO=@P_CNO

Union All

Select '(None)' as DocType, C1.Remark, C1.ImageID, C1.FileType, C1.LAST_OPR, C1.LAST_UPDATE
from CLAIM 
INNER JOIN CLPIC C1 ON (C1.CNO=CLAIM.OCNO)
Where CLAIM.CNO=@P_CNO

Union All

Select '(None)' as DocType, C1.Description as Remark, C1.ImageID, C1.FileType, C1.UserID as LAST_OPR, C1.Date as LAST_UPDATE
from CLPrintLog C1
Where C1.CNO=@P_CNO and C1.ImageID>0


go




insert into PatchVersioning
select '122 Update Script - Patch 2021 (79)',GETDATE()
go


Declare @PrevScript varchar(100)
Declare @CurrScript varchar(100)

Select @PrevScript=''
Select @CurrSCript='122 Update Script - Patch 2021 (79)'


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
