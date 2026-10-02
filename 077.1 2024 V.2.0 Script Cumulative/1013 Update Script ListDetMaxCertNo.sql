
IF EXISTS ( SELECT * FROM   sysobjects WHERE  id = object_id(N'ListDetMaxCertNo') and OBJECTPROPERTY(id, N'IsProcedure') = 1 )
BEGIN
DROP PROCEDURE [dbo].[ListDetMaxCertNo]
end
GO

CREATE PROCEDURE [dbo].[ListDetMaxCertNo] (@P_ANO as integer) 
AS
Declare @RegNo varchar(50)
Declare @PolicyNo varchar(50)
Declare @P_PANO int

Select @P_PANO=A.pANO, @RegNo=A.RegNo, @PolicyNo=A.PolicyNo
from Acceptance A
Where A.ANO=@P_ANO

Declare @Temp_ANO table(ANO Int, CertificateNo Varchar(100))

if @PolicyNo=''
	insert into @Temp_ANO
	Select ANO,  CertificateNo
	from Acceptance Where ANO<>LANO and RegNo=@RegNo
else
	insert into @Temp_ANO
	Select ANO,  CertificateNo
	from Acceptance Where ANO<>LANO and PolicyNo=@PolicyNo
		 
SELECT 
	Max(T.CertificateNo) MaxCertNo
FROM @Temp_ANO T
--Inner Join Acceptance on (Acceptance.ANO=T.ANO)

GO



insert into PatchVersioning
select '995 Update Script ListDetMaxCertNo',GETDATE()
go
	

Declare @PrevScript varchar(100)
Declare @CurrScript varchar(100)

Select @PrevScript=''
Select @CurrSCript='995 Update Script ListDetMaxCertNo'


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