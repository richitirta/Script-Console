

--PROFILE_TAB_OTHERS

IF NOT EXISTS(SELECT * FROM SYSFORM WHERE FNAME='PACCDLG')
BEGIN
insert into sysform(FName, Description, FCode, RequestF)
Select 'PACCDLG', 'Profile Account Dialog','GENERAL',0
end
go


IF NOT EXISTS(SELECT * FROM SYSFORM WHERE FNAME='PHOLDERDLG')
BEGIN
insert into sysform(FName, Description, FCode, RequestF)
Select 'PHOLDERDLG', 'Profile Policy Holder Dialog','GENERAL',0
end
go


IF NOT EXISTS(SELECT * FROM SYSFORM WHERE FNAME='PAGENCYDLG')
BEGIN
insert into sysform(FName, Description, FCode, RequestF)
Select 'PAGENCYDLG', 'Profile Agency Dialog','GENERAL',0
end
go


IF NOT EXISTS(SELECT * FROM SYSFORM WHERE FNAME='PCOLLATERALDLG')
BEGIN
insert into sysform(FName, Description, FCode, RequestF)
Select 'PCOLLATERALDLG', 'Profile Collateral Dialog','GENERAL',0
end
go

IF NOT EXISTS(SELECT * FROM SYSFORM WHERE FNAME='PROFILE_VACCOUNT')
BEGIN
insert into sysform(FName, Description, FCode, RequestF)
Select 'PROFILE_VACCOUNT', 'Allow Change Profile Virtual Account','ACTIVITIES',0
end
go


IF NOT EXISTS(SELECT * FROM SYSFORM WHERE FNAME='PVACCDLG')
BEGIN
insert into sysform(FName, Description, FCode, RequestF)
Select 'PVACCDLG', 'Profile Virtual Account Dialog','GENERAL',0
end
go

IF NOT EXISTS(SELECT * FROM SYSFORM WHERE FNAME='PROFILE_BUSINESS')
BEGIN
insert into sysform(FName, Description, FCode, RequestF)
Select 'PROFILE_BUSINESS', 'Allow Change Profile Others Data','ACTIVITIES',0
end
go


 insert into PatchVersioning
select '824 Update script - 05 Oktober 2023 (Privillege Profile)',GETDATE()
go


Declare @PrevScript varchar(100)
Declare @CurrScript varchar(100)

Select @PrevScript=''
Select @CurrSCript='824 Update script - 05 Oktober 2023 (Privillege Profile)'


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


