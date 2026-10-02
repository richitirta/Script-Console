

UPDATE PROFILE SET LAST_UPDATE = '' WHERE  LAST_UPDATE is null
go


 update profile set last_update='' where last_update is null
 go
 update profile set NetCommF=0 where NetCommF is null
 go
 update profile set PreferredF=0 where PreferredF is null
 go
 update profile set MaxOutGo=0 where MaxOutGo is null
 go
 update profile set TAXHDate='' where TAXHDate is null
 go
 update profile set LicenseDate='' where LicenseDate is null
 go
 update profile set TAXHSDate='' where TAXHSDate is null
 go
 update profile set TAXHEDate='' where TAXHEDate is null
 go
 update profile set RestrictedDate='' where RestrictedDate is null
 go
 update profile set VerifiedDate='' where VerifiedDate is null
 go
 update profile set TPAF=0 where TPAF is null
 go
 update profile set BVATF=0 where BVATF is null
 go
 update profile set TVATF=0 where TVATF is null


 insert into PatchVersioning
select '391 Update Script - Inisialiasi profile',GETDATE()
go


Declare @PrevScript varchar(100)
Declare @CurrScript varchar(100)

Select @PrevScript=''
Select @CurrSCript='391 Update Script - Inisialiasi profile'


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



