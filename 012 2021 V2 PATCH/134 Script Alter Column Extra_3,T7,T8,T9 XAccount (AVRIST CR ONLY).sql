
IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'Extra_3' AND Object_ID = Object_ID(N'xaccount'))
BEGIN
alter table xaccount
add  Extra_3 varchar(50)
end
Go
IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'T7' AND Object_ID = Object_ID(N'xaccount'))
BEGIN
alter table xaccount
add  T7 varchar(100)
end
Go
IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'T8' AND Object_ID = Object_ID(N'xaccount'))
BEGIN
alter table xaccount
add  T8 varchar(100)
end
Go
IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'T9' AND Object_ID = Object_ID(N'xaccount'))
BEGIN
alter table xaccount
add  T9 varchar(100)
end
Go

update xaccount set Extra_3 ='' where Extra_3 is null
go
update xaccount set T7 ='' where T7 is null
go
update xaccount set T8 ='' where T8 is null
go
update xaccount set T9 ='' where T9 is null
go



 insert into PatchVersioning
select '134 Script Alter Column Extra_3,T7,T8,T9 XAccount',GETDATE()
go


Declare @PrevScript varchar(100)
Declare @CurrScript varchar(100)

Select @PrevScript=''
Select @CurrSCript='134 Script Alter Column Extra_3,T7,T8,T9 XAccount'


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