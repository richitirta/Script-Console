
IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'DomicileAddress' AND Object_ID = Object_ID(N'profile_Ext'))
BEGIN
alter table profile_Ext add DomicileAddress varchar(512)
end
go
update profile_ext set DomicileAddress = '' where DomicileAddress is null
go
IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'AddressSameIDF' AND Object_ID = Object_ID(N'profile_Ext'))
BEGIN
alter table profile_Ext add AddressSameIDF bit
end
go
update profile_ext set AddressSameIDF = 0 where AddressSameIDF is null
go

IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'PIDExpDate' AND Object_ID = Object_ID(N'profile_Ext'))
BEGIN
alter table profile_Ext add PIDExpDate smalldatetime
end
go
update profile_ext set PIDExpDate = '' where PIDExpDate is null
go

IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'NoPIDExpDateF' AND Object_ID = Object_ID(N'profile_Ext'))
BEGIN
alter table profile_Ext add NoPIDExpDateF bit
end
go
update profile_ext set NoPIDExpDateF = 0 where NoPIDExpDateF is null
go


IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'LastEducation' AND Object_ID = Object_ID(N'profile_Ext'))
BEGIN
alter table profile_Ext add LastEducation varchar(10)
end
go
update profile_ext set LastEducation = '' where LastEducation is null
go

IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'MonthlyIncome' AND Object_ID = Object_ID(N'profile_Ext'))
BEGIN
alter table profile_Ext add MonthlyIncome varchar(100)
end
go
update profile_ext set MonthlyIncome = '' where MonthlyIncome is null
go

IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'MonthlyExpenses' AND Object_ID = Object_ID(N'profile_Ext'))
BEGIN
alter table profile_Ext add MonthlyExpenses varchar(100)
end
go
update profile_ext set MonthlyExpenses = '' where MonthlyExpenses is null
go



--SELECT * FROM Profile_Income
--go

IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'Monthly' AND Object_ID = Object_ID(N'Profile_Income'))
BEGIN
alter table Profile_Income add Monthly bit
end
go
IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'Annually' AND Object_ID = Object_ID(N'Profile_Income'))
BEGIN
alter table  Profile_Income add Annually bit
end
go


update Profile_Income set monthly  = 1 where monthly is null
go

update Profile_Income set Annually  = 1 where Annually is null
go


 
 

  insert into PatchVersioning
select '1206 Update Script - 2 Oktober 2024',GETDATE()
go	
  
Declare @PrevScript varchar(100)
Declare @CurrScript varchar(100)

Select @PrevScript=''
Select @CurrSCript='1206 Update Script - 2 Oktober 2024'


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
  
  
  
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 