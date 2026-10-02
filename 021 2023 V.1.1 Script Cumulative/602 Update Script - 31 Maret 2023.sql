IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'DaysAutoLapse' AND Object_ID = Object_ID(N'COLLTYPE'))
BEGIN
ALTER TABLE dbo.COLLTYPE ADD
	DaysAutoLapse int NULL
DECLARE @v sql_variant 
SET @v = N'Days Before Collection is Closed(0 : No, 1 : Yes)'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'COLLTYPE', N'COLUMN', N'DaysAutoLapse'
END
GO

IF EXISTS ( SELECT * FROM   sysobjects WHERE  id = object_id(N'AutoClose_Collection') and OBJECTPROPERTY(id, N'IsProcedure') = 1 )
BEGIN
DROP Procedure AutoClose_Collection
END
GO
CREATE Procedure AutoClose_Collection(@P_PDate as smalldatetime)                          
as                          
Select C1.CollNo
from CollectionH C1, CollType C2
Where C2.CollType=C1.CollType and C1.CollStatus='R' and C2.DaysAutoLapse<>0 and dateadd(day, C2.DaysAutoLapse, C1.CollDate)>=@P_PDate

GO

IF NOT EXISTS(SELECT * FROM SYsProcess WHERE ProcName='AutoClose_Collection')
BEGIN
insert into SYsProcess(ProcName, MainProcName, ProcGroup, TimeOut, StartTime, EndTime, Schedule, StartDay, EndDay, FreqDay, ScheduleF, RepetitiveF, UserID, Last_Opr, Last_Update)
Select 'AutoClose_Collection','AutoClose_Collection','FA', 0, '00:00','24:00',0,1,31,0,0,0,'CARE','CARE',cast(convert(varchar(10), getdate(),1) as smalldatetime)
END
GO


 insert into PatchVersioning	
select '602 Update Script - 31 Maret 2023',GETDATE()
go





Declare @PrevScript varchar(100)
Declare @CurrScript varchar(100)

Select @PrevScript=''
Select @CurrSCript='602 Update Script - 31 Maret 2023'


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


