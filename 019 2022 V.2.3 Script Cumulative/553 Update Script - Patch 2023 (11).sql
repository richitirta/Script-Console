DROP Procedure QDEPOSIT_FACULTATIVE_CESSION 
GO
CREATE Procedure QDEPOSIT_FACULTATIVE_CESSION (@P_ANO integer, @P_RType varchar(255))     
AS                           
SELECT FPart.ID, RArrDet.RType, FPart.SlipNo, RArrDet.Share, FPart.Comm, FPart.Share as RShare
From Acceptance       
Inner Join Cover on (Cover.CNO=Acceptance.CNO)      
Inner Join RArrDet on (RArrDet.ANO=Acceptance.ANO and RArrDet.RType=@P_RType and RArrDet.Status='R')      
Inner Join FPart on (FPart.ANO=RArrDet.ANO And FPart.FID=RArrDet.FID)
WHERE ACCEPTANCE.ANO=@P_ANO

go



 insert into PatchVersioning	
select '553 Update Script - Patch 2023 (11)',GETDATE()
go





Declare @PrevScript varchar(100)
Declare @CurrScript varchar(100)

Select @PrevScript=''
Select @CurrSCript='553 Update Script - Patch 2023 (11)'


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



