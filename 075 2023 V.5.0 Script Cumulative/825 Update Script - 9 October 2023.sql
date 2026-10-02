IF NOT EXISTS(SELECT * FROM SYSFORM WHERE FNAME='ALLOWCHANGEREFDATE')
BEGIN
insert into sysform(FName, Description, FCode, RequestF)
Select 'ALLOWCHANGEREFDATE','Allow Change Reference Date (FA)','ACTIVITIES',0
END
GO
IF NOT EXISTS(SELECT * FROM SYSFORM WHERE FNAME='ALLOWCHANGEDUEDATE')
BEGIN
insert into sysform(FName, Description, FCode, RequestF)
Select 'ALLOWCHANGEDUEDATE','Allow Change Due Date (FA)','ACTIVITIES',0
END
GO


 insert into PatchVersioning
select '825 Update Script - 9 October 2023',GETDATE()
go


Declare @PrevScript varchar(100)
Declare @CurrScript varchar(100)

Select @PrevScript=''
Select @CurrSCript='825 Update Script - 9 October 2023'


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


