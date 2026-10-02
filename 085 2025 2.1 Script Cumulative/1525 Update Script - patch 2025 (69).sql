DROP PROCEDURE QCLACC_5 

GO

CREATE PROCEDURE QCLACC_5 (@P_POLICYNO AS VARCHAR(255), @P_CERTIFICATENO AS VARCHAR(255), @P_DATE AS SMALLDATETIME)   
AS   
SELECT TOP 1  A.PolicyNo, A.CERTIFICATENO, A.PDate  
From Acceptance A  
Left Join Acceptance mA on (mA.ANO=A.LANO)  
WHERE A.PolicyNo=@P_PolicyNo and A.CertificateNo LIKE @P_CertificateNo   
and A.AType in ('C') and A.AStatus in ('I') and A.ANO<>A.LANO and A.PDate<=@P_Date   
and coalesce(mA.AStatus, A.AStatus) not in ('W','T')   
  
GO

insert into PatchVersioning
select '1525 Update Script - patch 2025 (69).sql',GETDATE()
go	
  
Declare @PrevScript varchar(100)
Declare @CurrScript varchar(100)

Select @PrevScript=''
Select @CurrSCript='1525 Update Script - patch 2025 (69).sql'


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
