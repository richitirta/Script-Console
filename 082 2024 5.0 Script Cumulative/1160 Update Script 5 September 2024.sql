IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'Last_Activity_Date' AND Object_ID = Object_ID(N'SysUserActivity'))
BEGIN
Alter Table SysUserActivity Add Last_Activity_Date smalldatetime
END
GO

IF EXISTS(SELECT * FROM sys.columns WHERE Name = N'Last_Activity_Date' AND Object_ID = Object_ID(N'SysUserActivity'))
BEGIN
Update SysUserActivity set Last_Activity_Date = '' where Last_Activity_Date is null
END
GO

IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'Last_Activity_Time' AND Object_ID = Object_ID(N'SysUserActivity'))
BEGIN
Alter Table SysUserActivity Add Last_Activity_Time varchar(8)
END
GO

IF EXISTS(SELECT * FROM sys.columns WHERE Name = N'Last_Activity_Time' AND Object_ID = Object_ID(N'SysUserActivity'))
BEGIN
Update SysUserActivity set Last_Activity_Time = '' where Last_Activity_Time is null
END
GO


  insert into PatchVersioning
select '1160 Update Script 5 September 2024',GETDATE()
go	
  
Declare @PrevScript varchar(100)
Declare @CurrScript varchar(100)

Select @PrevScript=''
Select @CurrSCript='1160 Update Script 5 September 2024'


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
