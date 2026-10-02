DROP Procedure QFACOUT
GO
CREATE Procedure QFACOUT(@P_ANO integer)        
as        
SELECT RArrDet.FID, RArrDet.Status, RArrDet.AType, RArrDet.RType, RArrDet.SDate, RArrDet.EDate, RArrDet.Share, RArrDet.Amount, RArrDet.Limit, RArrDet.Excess, RArrDet.Retention, RArrDet.Prorata, Profile.Name,       
FPart.SlipNo, FPart.SlipRetF, FPart.ID, FPart.Share AS RShare, FPart.Comm, FPart.WPC,        
FPart.Currency, FPart.NetRate , FPart.Unit, RArrDet.PCALC, RArrDet.CPct, RArrDet.FullCoverF, RArrDet.OriginalF, RArrDet.PrecedeFacCessionF, FPart.Remarks,  
FPart.Grace, FPart.Installment, RArrDet.AcceptedBy, RArrDet.AcceptedDate   
From RArrDet  
Inner Join FPart on (FPart.ANO=RArrDet.ANO And FPart.FID=RArrDet.FID)  
Inner Join Profile on (Profile.ID=FPart.ID)  
WHERE RArrDet.ANO=@P_ANO  
 
 
 go
 
 
 
 

insert into PatchVersioning
select '956 Update Script - Patch 2024 (11)',GETDATE()
go


Declare @PrevScript varchar(100)
Declare @CurrScript varchar(100)

Select @PrevScript=''
Select @CurrSCript='956 Update Script - Patch 2024 (11)'


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
	 
 