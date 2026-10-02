
IF NOT EXISTS(SELECT * FROM sysprocess WHERE Procname='AutoCreate_WithHoldingVAT')
BEGIN
insert into sysprocess(ProcName, ProcGroup, TimeOut, StartTime, EndTime, Schedule, StartDay, EndDay, FreqDay, ScheduleF, UserID, Last_Opr, Last_Update, ExecCheckF, MainProcName, RepetitiveF)
Select 'AutoCreate_WithHoldingVAT','SC',0,'00:00','24:00',1,1,31,0,0,'CARE','CARE',cast(convert(varchar(10), getdate(),1) as smalldatetime),0,'AutoCreate_WithHoldingVAT',0
end
go



 insert into PatchVersioning
select '344 Update Script - 12 July 2022',GETDATE()
go


Declare @PrevScript varchar(100)
Declare @CurrScript varchar(100)

Select @PrevScript=''
Select @CurrSCript='344 Update Script - 12 July 2022'


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

