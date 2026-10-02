IF NOT EXISTS(SELECT * FROM SYSFORM WHERE FNAME='CLReceiptDlg')
BEGIN
INSERT INTO SYSFORM 
SELECT 'CLReceiptDlg','Claim Loss Item Receipt','CLAIM',0
END
GO

--inisialisasi
insert into SysUserForm
select s.TYPE,f.fname,1,1,1,1,1,1
from SysUserType s, SysForm f
where f.FName in
('CLReceiptDlg')
and 1 not in(Select 1 from SysUserForm S1 Where S1.type=S.type and S1.fname=f.fname)
go

insert into PatchVersioning
select '1461 Update Patch Script - Claim Form CLReceiptDlg',GETDATE()
go	
  
Declare @PrevScript varchar(100)
Declare @CurrScript varchar(100)

Select @PrevScript=''
Select @CurrSCript='1461 Update Patch Script - Claim Form CLReceiptDlg'


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