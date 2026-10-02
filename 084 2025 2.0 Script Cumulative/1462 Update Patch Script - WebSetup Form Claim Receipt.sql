IF NOT EXISTS(SELECT * FROM SYSFORM WHERE FNAME='CHospitalListFrm')
BEGIN
INSERT INTO SYSFORM VALUES 
('CHospitalListFrm','Hospital Table Inquiry','SETUP',0),
('CHospitalFrm','Hospital Table Registration','SETUP',0),
('CMedicalListFrm','Hospital Table Inquiry','SETUP',0),
('CMedicalFrm','Hospital Table Registration','SETUP',0),
('CPetitionTypeListFrm','Hospital Table Inquiry','SETUP',0),
('CPetitionTypeFrm','Hospital Table Registration','SETUP',0)
END
GO

--inisialisasi
insert into SysUserForm
select s.TYPE,f.fname,1,1,1,1,1,1
from SysUserType s, SysForm f
where f.FName in
('CHospitalListFrm','CHospitalFrm','CMedicalListFrm','CMedicalFrm','CPetitionTypeListFrm','CPetitionTypeFrm')
and 1 not in(Select 1 from SysUserForm S1 Where S1.type=S.type and S1.fname=f.fname)
go


insert into PatchVersioning
select '1462 Update Patch Script - WebSetup Form Claim Receipt',GETDATE()
go	
  
Declare @PrevScript varchar(100)
Declare @CurrScript varchar(100)

Select @PrevScript=''
Select @CurrSCript='1462 Update Patch Script - WebSetup Form Claim Receipt'


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

GO 