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
AND ACCEPTANCE.PDATE<ACCEPTANCE.PPDATE AND ACCEPTANCE.ANO<>ACCEPTANCE.LANO   
AND ACCEPTANCE.POLICYNO<>'' AND ACCEPTANCE.POLICYNO LIKE @P_POLICYNO AND ACCEPTANCE.CERTIFICATENO LIKE @P_CERTIFICATENO     
AND ACCEPTANCE.TOC LIKE @P_TOC+'%' AND ACCEPTANCE.REFNO LIKE @P_REFNO+'%'  
AND ACCEPTANCE.VALUEID LIKE @P_VALUEID+'%'
ORDER BY ACCEPTANCE.ANO DESC 
go


 insert into PatchVersioning	
select '739 Update Script - Patch 2023 (85)',GETDATE()
go





Declare @PrevScript varchar(100)
Declare @CurrScript varchar(1004)

Select @PrevScript=''
Select @CurrSCript='739 Update Script - Patch 2023 (85)'


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





