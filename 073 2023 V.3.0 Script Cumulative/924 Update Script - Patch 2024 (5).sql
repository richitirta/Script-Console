
DROP procedure qPolicyData
GO
Create procedure qPolicyData(@P_SQLFilter as varchar(2048), @P_MaxRecord as int=1000)          
as  
  
Declare @SQL as varchar(8000)  
  
Select @P_SQLFILTER=replace(@P_SQLFILTER,'``','''')

if @P_MaxRecord=0 
	Select @P_MaxRecord=1000
	  
Select @SQL=''      
Select @SQL = @SQL + ' Select Top ' + cast(@P_MaxRecord as varchar(10)) + '*'  
Select @SQL = @SQL + ' from '  
Select @SQL = @SQL + ' ('  
Select @SQL = @SQL + '  SELECT ACCEPTANCE.ANO, ACCEPTANCE.TOC AS TOC, COVER.INSURED AS Insured, ACCEPTANCE.AName AS AName, COVER.COVERNO, ACCEPTANCE.REGNO, ACCEPTANCE.POLICYNO AS PolicyNo, ACCEPTANCE.CERTIFICATENO AS CertificateNo, ACCEPTANCE.REFNO, Acceptance.PDate, Acceptance.PPDate,       '  
Select @SQL = @SQL + '  coalesce(APayor.Installment, coalesce(MPayor.Installment, Payor.Installment)) as Installment, '
Select @SQL = @SQL + '  PROFILE.TAXID, PROFILE_EXT.ID_NO,     '
Select @SQL = @SQL + '  AINFO.VALUEID1, AINFO.VALUEDESC1,      '  
Select @SQL = @SQL + '  AINFO.VALUEID2, AINFO.VALUEDESC2,      '  
Select @SQL = @SQL + '  AINFO.VALUEID3, AINFO.VALUEDESC3,      '  
Select @SQL = @SQL + '  AINFO.VALUEID4, AINFO.VALUEDESC4,      '  
Select @SQL = @SQL + '  AINFO.VALUEID5, AINFO.VALUEDESC5,      '  
Select @SQL = @SQL + '  AINFO.VALUEID6, AINFO.VALUEDESC6,      '  
Select @SQL = @SQL + '  AINFO.VALUEID7, AINFO.VALUEDESC7,      '  
Select @SQL = @SQL + '  AINFO.VALUEID8, AINFO.VALUEDESC8,      '  
Select @SQL = @SQL + '  AINFO.VALUEID9, AINFO.VALUEDESC9,      '  
Select @SQL = @SQL + '  AINFO.VALUEID10, AINFO.VALUEDESC10,     '   
Select @SQL = @SQL + '  AINFO.VALUEID11, AINFO.VALUEDESC11,      '  
Select @SQL = @SQL + '  AINFO.VALUEID12, AINFO.VALUEDESC12,      '  
Select @SQL = @SQL + '  AINFO.VALUEID13, AINFO.VALUEDESC13,      '  
Select @SQL = @SQL + '  AINFO.VALUEID14, AINFO.VALUEDESC14,      '  
Select @SQL = @SQL + '  AINFO.VALUEID15, AINFO.VALUEDESC15      '  
Select @SQL = @SQL + '  FROM ACCEPTANCE '
Select @SQL = @SQL + '  INNER JOIN  COVER ON COVER.CNO = ACCEPTANCE.CNO '
Select @SQL = @SQL + '  INNER JOIN  AINFO ON AINFO.ANO = ACCEPTANCE.ANO  '  
Select @SQL = @SQL + '  INNER JOIN PROFILE ON (PROFILE.ID=ACCEPTANCE.AID) '
Select @SQL = @SQL + '  LEFT JOIN PROFILE_EXT ON (PROFILE_EXT.ID=PROFILE.ID) '
Select @SQL = @SQL + '  Left Join APayor on (APayor.ANO=ACCEPTANCE.ANO and ACCEPTANCE.LANO<>-1 and ACCEPTANCE.ANO<>ACCEPTANCE.LANO) '
Select @SQL = @SQL + '  Left Join Payor on (Payor.ANO=ACCEPTANCE.ANO and ACCEPTANCE.LANO=-1) '    
Select @SQL = @SQL + '  Left Join Payor MPayor on (MPayor.ANO=ACCEPTANCE.LANO and ACCEPTANCE.LANO<>-1)  '
Select @SQL = @SQL + '  WHERE (ACCEPTANCE.ANO <> ACCEPTANCE.LANO) AND (ACCEPTANCE.ATYPE NOT IN (''C'', ''A'')) AND (ACCEPTANCE.ASTATUS NOT IN (''W'',''T'')) AND (COVER.CSTATUS<>''C'') AND (Acceptance.pAStatus<>''W'') AND ((ACCEPTANCE.PDATE<ACCEPTANCE.PPDATE) or (ACCEPTANCE.PDATE=ACCEPTANCE.PPDATE and ACCEPTANCE.STime<ACCEPTANCE.ETime)) AND ACCEPTANCE.POLICYNO<>''''                '  
Select @SQL = @SQL + ' ) Q'  
if @P_SQLFilter<>''  
 Select @SQL = @SQL + ' Where ' + @P_SQLFilter  
else
 Select @SQL = @SQL + ' Where 1<>1'
Execute (@SQL)  
GO

DROP FUNCTION FL_CL_POLICYNO
GO
CREATE FUNCTION FL_CL_POLICYNO(@P_USERID varchar(50), @P_PolicyNo varchar(50))                        
RETURNS TABLE                        
AS RETURN                        
(
Select A.PolicyNo, A.CertificateNo, A.AName, A.SDate, A.EDate, A.PDate, A.PPDate, A.NCDate, A.ExtPeriod, A.Branch, A.TOC                   
from Acceptance A 
Inner Join Cover C on (C.CNO=A.CNO)                    
Where A.ATYPE Not In ('A','C') And A.ASTATUS Not in ('W','T') and C.CStatus not in ('R','P','C')             
And ((A.PDATE<A.PPDATE) or (A.PDATE=A.PPDATE and A.STime<A.ETime)) And A.ANO<>A.LANO              
and A.PolicyNo<>'' and A.PolicyNo Like @P_PolicyNo+'%'                    
and EXISTS (Select Top 1 S.Branch from SysUserBranch S Where S.AllowedF=1 and S.Branch=A.Branch and S.ID=@P_UserID)                    
and EXISTS (Select Top 1 S.TOC from SysUserTOC S Where S.TOC=A.TOC and S.ID=@P_UserID)                    
)       

GO
DROP PROCEDURE QCLACC_3
GO
CREATE PROCEDURE QCLACC_3(@P_POLICYNO AS VARCHAR(255), @P_CERTIFICATENO VARCHAR(255), @P_REFNO varchar(50)='', @P_TOC varchar(10)='', @P_VALUEID varchar(255)='')     
AS     
SELECT TOP 10 ACCEPTANCE.ANO, ACCEPTANCE.POLICYNO, ACCEPTANCE.CERTIFICATENO, ACCEPTANCE.AID, COVER.INSURED, COVER.ISTYPE, COVER.SEGMENT, ACCEPTANCE.TOC, ACCEPTANCE.SDATE, ACCEPTANCE.EDATE, Cover.PHolder, ACCEPTANCE.BRANCH, ACCEPTANCE.ANAME, PROFILE.RESTRICTEDF, PROFILE.NAME, ACCEPTANCE.PDATE, ACCEPTANCE.PPDATE, ACCEPTANCE.NCDATE,  ACCEPTANCE.EXTPERIOD,     
Case When GenDTab.Description is not null then ACCEPTANCE.ValueDesc else '' end as Description,     
coalesce(InParty.ID, coalesce(ISource.ID, Acceptance.AID)) as Payment,
coalesce(IProfile.Name, coalesce(PProfile.Name, Profile.Name)) as Payment_Name
FROM ACCEPTANCE WITH (INDEX(I_Acceptance_PolicyNo_CertificateNo))  
Left Join Acceptance mA on (mA.ANO=Acceptance.LANO)
Left Join GenDTab On (GenDTab.FLDID=ACCEPTANCE.FLDID AND GenDTab.ValueID=ACCEPTANCE.ValueID)  
Inner Join COVER on (Cover.CNO=Acceptance.CNO)  
Left Join ISource On (ISource.CNO=Cover.CNO)   
Left Join InParty on (InParty.CNO=Cover.CNO and InParty.IType in ('MORTGAGE'))
Left Join Profile PProfile On (PProfile.ID=ISource.ID)  
Left Join Profile IProfile On (IProfile.ID=InParty.ID)  
Left Join Profile on (Profile.ID=Acceptance.AID)  
WHERE ACCEPTANCE.ATYPE Not In ('A','C') AND ACCEPTANCE.AStatus not in ('W','T') and COVER.CStatus not in ('R','P','C')     
and coalesce(mA.AStatus, Acceptance.AStatus) not in ('W','T')
And ((ACCEPTANCE.PDATE<ACCEPTANCE.PPDATE) or (ACCEPTANCE.PDATE=ACCEPTANCE.PPDATE and ACCEPTANCE.STime<ACCEPTANCE.ETime)) AND ACCEPTANCE.ANO<>ACCEPTANCE.LANO   
AND ACCEPTANCE.POLICYNO<>'' AND ACCEPTANCE.POLICYNO LIKE @P_POLICYNO AND ACCEPTANCE.CERTIFICATENO LIKE @P_CERTIFICATENO     
AND ACCEPTANCE.TOC LIKE @P_TOC+'%' AND ACCEPTANCE.REFNO LIKE @P_REFNO+'%'  
AND ACCEPTANCE.VALUEID LIKE @P_VALUEID+'%'
ORDER BY ACCEPTANCE.ANO DESC 

GO
DROP FUNCTION FL_CL_CERTIFICATENO
GO
CREATE FUNCTION FL_CL_CERTIFICATENO(@P_USERID varchar(50), @P_PolicyNo varchar(50),@P_CertificateNo varchar(10))            
RETURNS TABLE            
AS RETURN            
(
Select A.CertificateNo, A.AName, A.SDate, A.EDate, A.PDate, A.PPDate, A.NCDate, A.ExtPeriod            
from Acceptance A Inner Join Cover C on (C.CNO=A.CNO)          
Where A.ATYPE Not In ('A','C') And A.ASTATUS NOT IN ('W','T') And C.CStatus<>'C' 
And ((A.PDATE<A.PPDATE) or (A.PDATE=A.PPDATE and A.STime<A.ETime)) And A.ANO<>A.LANO And A.LANO <> -1   
and A.PolicyNo=@P_PolicyNo and A.CertificateNo Like @P_CertificateNo+'%'          
and A.Branch in (Select S.Branch from SysUserBranch S Where S.ID=@P_UserID)          
and A.TOC in (Select S.TOC from SysUserTOC S Where S.ID=@P_UserID)          
)       
  
go




insert into PatchVersioning
select '924 Update Script - Patch 2024 (5)',GETDATE()
go


Declare @PrevScript varchar(100)
Declare @CurrScript varchar(100)

Select @PrevScript=''
Select @CurrSCript='924 Update Script - Patch 2024 (5)'


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
