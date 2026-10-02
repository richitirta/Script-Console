IF NOT EXISTS(SELECT * FROM SYSFORM WHERE FNAME='ALLOWUNDOVERIFYREQUEST')
BEGIN
insert into sysform(FName, Description, FCode, RequestF)
Select 'ALLOWUNDOVERIFYREQUEST', 'ALLOW UNDO VERIFY PAYMENT REQUEST','ACTIVITIES',0
end
go

IF NOT EXISTS(SELECT * FROM SYSFORM WHERE FNAME='ALLOWUNDOAPPROVEREQUEST')
BEGIN
insert into sysform(FName, Description, FCode, RequestF)
Select 'ALLOWUNDOAPPROVEREQUEST', 'ALLOW UNDO APPROVE PAYMENT REQUEST','ACTIVITIES',0
end
go

IF NOT EXISTS(SELECT * FROM SYSFORM WHERE FNAME='ALLOWUNDOAPPROVEVOUCHER')
BEGIN
insert into sysform(FName, Description, FCode, RequestF)
Select 'ALLOWUNDOAPPROVEVOUCHER', 'ALLOW UNDO APPROVE PAYMENT VOUCHER','ACTIVITIES',0
end
go

IF NOT EXISTS(SELECT * FROM SYSFORM WHERE FNAME='ALLOWMODIFYONGOINGREQUESTVERIFICATION')
BEGIN
insert into sysform(FName, Description, FCode, RequestF)
Select 'ALLOWMODIFYONGOINGREQUESTVERIFICATION', 'ALLOW MODIFY ON GOING VERIFICATION PAYMENT REQUEST','ACTIVITIES',0
end
go


  insert into PatchVersioning
select '1243 Update Script - Patch 2024 (85)',GETDATE()
go	
  
Declare @PrevScript varchar(100)
Declare @CurrScript varchar(100)

Select @PrevScript=''
Select @CurrSCript='1243 Update Script - Patch 2024 (85)'


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