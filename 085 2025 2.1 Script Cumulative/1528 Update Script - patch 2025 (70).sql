DROP Procedure AutoActionPending_Notification

GO


Create Procedure AutoActionPending_Notification(@P_PDate as smalldatetime)                    
as                    
Select  S.*, Actionlist.ActionName, SU.ID as SentTo
from Sysrequest S
Inner Join Actionlist on (Actionlist.ActionCode=S.ActionCode)  
Inner Join ActionUser on (ActionUser.ActionCode=S.ActionCode and ActionUser.ActionUser=S.Param5)  
Inner Join SysUser SU on (SU.AllowedF=1 and SU.LockedF=0 and (S.Param5=SU.ID or S.Param5=SU.Type or ActionUser.ActionUserAuth_1=SU.ID or ActionUser.ActionUserAuth_2=SU.ID or ActionUser.ActionUserAuth_3=SU.ID or ActionUser.ActionUserAuth_4=SU.ID or ActionUser.ActionUserAuth_5=SU.ID or ActionUser.ActionUserAuth_6=SU.ID or ActionUser.ActionUserAuth_7=SU.ID or ActionUser.ActionUserAuth_8=SU.ID or ActionUser.ActionUserAuth_9=SU.ID or ActionUser.ActionUserAuth_10=SU.ID))  
Where S.Status='' and DATEDIFF(day, S.UserDate, @P_PDate)>Actionlist.ActionNotification and Actionlist.ActionNotification<>0  

GO

insert into PatchVersioning
select '1528 Update Script - patch 2025 (70).sql',GETDATE()
go	
  
Declare @PrevScript varchar(100)
Declare @CurrScript varchar(100)

Select @PrevScript=''
Select @CurrSCript='1528 Update Script - patch 2025 (70).sql'


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

GO 