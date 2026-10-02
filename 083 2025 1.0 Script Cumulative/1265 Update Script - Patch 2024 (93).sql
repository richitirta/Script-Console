DROP PROCEDURE PI01 
GO
CREATE PROCEDURE PI01 (@P_ANO AS INTEGER) 
AS 
( 
SELECT TOP 1 
A.POLICYNO, A.CERTIFICATENO, C.PHOLDER, P.PREFERREDF, P.RESTRICTEDF, P.NAME, A.ANAME, P.PrivilegeType, A.AID, 
(LTRIM(RTRIM(P.ADDRESS_1)) + ' ' + LTRIM(RTRIM(P.ADDRESS_2)) + ' ' + LTRIM(RTRIM(P.ADDRESS_3))) AS 'ADDRESS', 
(LTRIM(RTRIM(P.PHONE_1)) + ' ' + LTRIM(RTRIM(P.PHONE_2))) AS 'PHONE', 
(LTRIM(RTRIM(P.FAX_1)) + ' ' + LTRIM(RTRIM(P.FAX_2))) AS 'FAX', 
P.EMAIL,A.SDATE, A.EDATE, A.PDATE, A.PPDATE, A.NCDATE,
RA.POLICYNO as PPOLICYNO, RA.CERTIFICATENO as PCERTIFICATENO,
BS.Name as BSName, BS.ID as BSID, BS.PrivilegeType as BSPrivilegeType,
CGROUP.CGROUP AS CGROUP, CGROUP.DESCRIPTION AS CGROUPDESC
FROM COVER C 
INNER JOIN ACCEPTANCE A ON (A.CNO=C.CNO) 
LEFT JOIN ACCEPTANCE RA ON (RA.ANO=A.RANO) 
INNER JOIN PROFILE P ON (C.PHOLDER=P.ID) 
LEFT JOIN PROFILE BS ON (BS.ID=A.SOURCE)
LEFT JOIN CGROUP ON (CGROUP.CGROUP=P.CGROUP)
WHERE A.ANO=@P_ANO 
) 
GO



  insert into PatchVersioning
select '1265 Update Script - Patch 2024 (93)',GETDATE()
go	
  
Declare @PrevScript varchar(100)
Declare @CurrScript varchar(100)

Select @PrevScript=''
Select @CurrSCript='1265 Update Script - Patch 2024 (93)'


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





