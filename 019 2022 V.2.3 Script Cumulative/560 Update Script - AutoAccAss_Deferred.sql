DROP Procedure AutoAccAss_Deferred
GO
CREATE Procedure AutoAccAss_Deferred(@P_PDate as smalldatetime)                                          
as               
Select Top 100000 Acceptance.ANO, Acceptance.SDate, Acceptance.EDate, Acceptance.PDate, Acceptance.ADate, pAcceptance.SDate as PrevSDate, pAcceptance.EDate as PrevEDate  
from Acceptance    
Left Join Acceptance pAcceptance on (pAcceptance.ANO=Acceptance.pANO)  
Inner join Cover on (Cover.CNO=Acceptance.CNO)    
Inner Join TOC on (TOC.TOC=Acceptance.TOC)    
where Acceptance.ANO<>Acceptance.LANO     
and datediff(month, Acceptance.SDate, Acceptance.EDate)>=TOC.DPremium       
and Acceptance.ADate<=@P_PDate     
and (Acceptance.AStatus not in ('W','T') and Cover.CStatus<>'C')    
and not Exists (Select Top 1 A1.ANO from AccAss_Deferred A1 Where A1.ANO=Acceptance.ANO)   
GO


 insert into PatchVersioning	
select '560 Update Script - AutoAccAss_Deferred',GETDATE()
go





Declare @PrevScript varchar(100)
Declare @CurrScript varchar(100)

Select @PrevScript=''
Select @CurrSCript='560 Update Script - AutoAccAss_Deferred'


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
