SET QUOTED_IDENTIFIER ON
SET ARITHABORT ON
SET NUMERIC_ROUNDABORT OFF
SET CONCAT_NULL_YIELDS_NULL ON
SET ANSI_NULLS ON
SET ANSI_PADDING ON
SET ANSI_WARNINGS ON

IF NOT EXISTS(SELECT * FROM SYSFORM WHERE FNAME='ALLOWONLYUSERDLGTXTEXPIRY')
BEGIN
Insert into sysform (FName, Description, FCode, RequestF)
Select 'ALLOWONLYUSERDLGTXTEXPIRY','ENABLE ONLY TXTEXPIRY ON FORM USERDLG WEBSETUP','ACTIVITIES',0
end
go

--SysUserForm
IF NOT EXISTS(SELECT * FROM SysUserForm WHERE FNAME='ALLOWONLYUSERDLGTXTEXPIRY')
BEGIN
insert into SysUserForm
select s.TYPE,f.fname,0,0,0,0,0,0
from SysUserType s, SysForm f
where f.FName in
('ALLOWONLYUSERDLGTXTEXPIRY')
and 1 not in (Select 1 from SysUserForm S1 Where S1.type=S.type and S1.fname=f.fname)
end
go


insert into PatchVersioning
select '1363 CORE - Update Patch SysForm - WebSetup UserDlg - ALLOWONLYUSERDLGTXTEXPIRY',GETDATE()
go	
  

Declare @PrevScript varchar(100)
Declare @CurrScript varchar(100)

Select @PrevScript=''
Select @CurrSCript='1363 CORE - Update Patch SysForm - WebSetup UserDlg - ALLOWONLYUSERDLGTXTEXPIRY'


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