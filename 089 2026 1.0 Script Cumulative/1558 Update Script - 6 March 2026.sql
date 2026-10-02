
insert into sysprocess(ProcName, MainProcName, ProcGroup, TimeOut, StartTime, EndTime, Schedule, StartDay, EndDay, FreqDay, ScheduleF, UserID, Last_Opr, Last_Update)
Select 'AUTOINFORCECBC_PROCESS' as ProcName,'AUTOINFORCECBC_PROCESS', 'SC',0,'00:00','00:00',0,0,0,0,0,'CARE','CARE',cast(convert(varchar(10), getdate(),1) as smalldatetime)
GO



insert into PatchVersioning
select '1558 Update Script - 6 March 2026.sql',GETDATE()
go	
  
Declare @PrevScript varchar(100)
Declare @CurrScript varchar(100)

Select @PrevScript=''
Select @CurrSCript='1558 Update Script - 6 March 2026.sql'


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