IF NOT EXISTS(SELECT * FROM sysprocess WHERE MainProcName='AutoCreateRenewalServicing')
BEGIN
insert into SysProcess(ProcName, ProcGroup, TimeOut, StartTime, EndTime, Schedule, StartDay, EndDay,FreqDay, ScheduleF, UserID, Last_Opr, Last_update, ExecCheckF, MainProcName, RepetitiveF)
Select 'AutoCreateRenewalServicing','SC',0,'00:00','24:00',0,1,31,0,0,'CARE','CARE',cast(convert(varchar(10), getdate(),1) as smalldatetime),0,'AutoCreateRenewalServicing',0
end
GO

IF EXISTS ( SELECT * FROM   sysobjects WHERE  id = object_id(N'AutoCreateRenewalServicing') and OBJECTPROPERTY(id, N'IsProcedure') = 1 )
BEGIN
Drop Procedure AutoCreateRenewalServicing
end
GO
create Procedure AutoCreateRenewalServicing(@P_PDate as smalldatetime)  
as
Select Acceptance.ANO
from Acceptance 
Inner Join TOC on (TOC.TOC=Acceptance.TOC)
Left Join RArrHeader on (RArrHeader.ANO=Acceptance.ANO) 
Left Join Acceptance MAcceptance on (MAcceptance.ANO=Acceptance.LANO)
Inner Join Cover on (Cover.CNO=Acceptance.CNO) 
Where Cover.ISType in ('I','L','C','R') and Cover.CStatus<>'C' 
and Acceptance.RenewableF=1 and Acceptance.AStatus in ('I','C') and Acceptance.AType not in ('C','A') 
and (Acceptance.LANO=-1 or (Acceptance.ANO<>Acceptance.LANO and Cover.OpenFlag=1) or (Acceptance.ANO=Acceptance.LANO and Cover.OpenFlag=0))
and Not Exists (Select RANO from Acceptance A Where A.RANO=Acceptance.ANO)
and Not Exists (Select PANO from Acceptance A Where A.AStatus in ('I','C') and A.AType not in ('A') and A.PANO=Acceptance.ANO)
and Not Exists (Select PANO from Service S Where S.SStatus in ('R','P','A') and S.SType='RENEWAL' and S.PANO=Acceptance.ANO)
and Acceptance.EDate Between @P_PDate and dateadd(day,TOC.RQDays,@P_PDate)  

go


 insert into PatchVersioning	
select '714 Update Script - 18 July 2023',GETDATE()
go





Declare @PrevScript varchar(100)
Declare @CurrScript varchar(1004)

Select @PrevScript=''
Select @CurrSCript='714 Update Script - 18 July 2023'


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



