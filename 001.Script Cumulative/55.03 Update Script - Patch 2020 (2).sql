IF EXISTS ( SELECT * FROM   sysobjects WHERE  id = object_id(N'QGet_Object_Restriction') and OBJECTPROPERTY(id, N'IsProcedure') = 1 )
BEGIN
DROP Procedure QGet_Object_Restriction
END
GO
CREATE Procedure QGet_Object_Restriction(@P_ANO as integer)
AS

SELECT top 1 ObjectRegister.RestrictedF, 'Restricted Object Register, Policy No : ' + Acceptance.PolicyNo + '-' + Acceptance.CertificateNo as Remarks
From Acceptance
Inner Join AInfo on (AInfo.ANO=Acceptance.ANO)
Inner Join ObjectRegister on (
	ObjectRegister.TOC=Acceptance.TOC        
	And ((ObjectRegister.ValueID1='' and Ainfo.ValueDesc1 Like ObjectRegister.ValueDesc1+'%') or (ObjectRegister.ValueID1<>'' and AInfo.ValueID1 Like ObjectRegister.ValueID1+'%') or (ObjectRegister.ValueID1 is null))                    
	And ((ObjectRegister.ValueID2='' and Ainfo.ValueDesc2 Like ObjectRegister.ValueDesc2+'%') or (ObjectRegister.ValueID2<>'' and AInfo.ValueID2 Like ObjectRegister.ValueID2+'%') or (ObjectRegister.ValueID2 is null))                    
	And ((ObjectRegister.ValueID3='' and Ainfo.ValueDesc3 Like ObjectRegister.ValueDesc3+'%') or (ObjectRegister.ValueID3<>'' and AInfo.ValueID3 Like ObjectRegister.ValueID3+'%') or (ObjectRegister.ValueID3 is null))                    
	And ((ObjectRegister.ValueID4='' and Ainfo.ValueDesc4 Like ObjectRegister.ValueDesc4+'%') or (ObjectRegister.ValueID4<>'' and AInfo.ValueID4 Like ObjectRegister.ValueID4+'%') or (ObjectRegister.ValueID4 is null))                    
	And ((ObjectRegister.ValueID5='' and Ainfo.ValueDesc5 Like ObjectRegister.ValueDesc5+'%') or (ObjectRegister.ValueID5<>'' and AInfo.ValueID5 Like ObjectRegister.ValueID5+'%') or (ObjectRegister.ValueID5 is null))                    
	And ((ObjectRegister.ValueID6='' and Ainfo.ValueDesc6 Like ObjectRegister.ValueDesc6+'%') or (ObjectRegister.ValueID6<>'' and AInfo.ValueID6 Like ObjectRegister.ValueID6+'%') or (ObjectRegister.ValueID6 is null))                    
	And ((ObjectRegister.ValueID7='' and Ainfo.ValueDesc7 Like ObjectRegister.ValueDesc7+'%') or (ObjectRegister.ValueID7<>'' and AInfo.ValueID7 Like ObjectRegister.ValueID7+'%') or (ObjectRegister.ValueID7 is null))                    
	And ((ObjectRegister.ValueID8='' and Ainfo.ValueDesc8 Like ObjectRegister.ValueDesc8+'%') or (ObjectRegister.ValueID8<>'' and AInfo.ValueID8 Like ObjectRegister.ValueID8+'%') or (ObjectRegister.ValueID8 is null))                    
	And ((ObjectRegister.ValueID9='' and Ainfo.ValueDesc9 Like ObjectRegister.ValueDesc9+'%') or (ObjectRegister.ValueID9<>'' and AInfo.ValueID9 Like ObjectRegister.ValueID9+'%') or (ObjectRegister.ValueID9 is null))                    
	And ((ObjectRegister.ValueID10='' and Ainfo.ValueDesc10 Like ObjectRegister.ValueDesc10+'%') or (ObjectRegister.ValueID10<>'' and AInfo.ValueID10 Like ObjectRegister.ValueID10+'%') or (ObjectRegister.ValueID10 is null))                    
	And ((ObjectRegister.ValueID11='' and Ainfo.ValueDesc11 Like ObjectRegister.ValueDesc11+'%') or (ObjectRegister.ValueID11<>'' and AInfo.ValueID11 Like ObjectRegister.ValueID11+'%') or (ObjectRegister.ValueID11 is null))                    
	And ((ObjectRegister.ValueID12='' and Ainfo.ValueDesc12 Like ObjectRegister.ValueDesc12+'%') or (ObjectRegister.ValueID12<>'' and AInfo.ValueID12 Like ObjectRegister.ValueID12+'%') or (ObjectRegister.ValueID12 is null))                    
	And ((ObjectRegister.ValueID13='' and Ainfo.ValueDesc13 Like ObjectRegister.ValueDesc13+'%') or (ObjectRegister.ValueID13<>'' and AInfo.ValueID13 Like ObjectRegister.ValueID13+'%') or (ObjectRegister.ValueID13 is null))                    
	And ((ObjectRegister.ValueID14='' and Ainfo.ValueDesc14 Like ObjectRegister.ValueDesc14+'%') or (ObjectRegister.ValueID14<>'' and AInfo.ValueID14 Like ObjectRegister.ValueID14+'%') or (ObjectRegister.ValueID14 is null))     
	And ((ObjectRegister.ValueID15='' and Ainfo.ValueDesc15 Like ObjectRegister.ValueDesc15+'%') or (ObjectRegister.ValueID15<>'' and AInfo.ValueID15 Like ObjectRegister.ValueID15+'%') or (ObjectRegister.ValueID15 is null))      
)
WHERE Acceptance.ANO=@P_ANO

Union All

Select Top 1 Cast(1 as Bit) as RestrictedF, 'Insured Object already has Total Loss, Policy No : ' + A2.PolicyNo + '-' + A2.CertificateNo as Remarks
from Acceptance A1, Acceptance A2, Claim C1
Where A1.ANO=@P_ANO 
and A2.ANO<>A2.LANO and A2.OANO<>A1.OANO 
and A2.RegID<>'' and A1.RegID=A2.RegID and A2.FLDID<>'' and A1.FLDID=A2.FLDID and A2.ValueID<>'' and A1.VALUEID=A2.VALUEID and A1.VALUEDESC=A2.VALUEDESC
and A2.ANO=C1.ANO 
and C1.CType not in ('C') and (C1.CStatus in ('P','T','A') or C1.PCStatus in ('A')) and not exists (Select pCNO from Claim Where Claim.pCNO=C1.CNO and Claim.CStatus<>'R')
and Exists (Select TOP 1 CNO from CLLOSS Where CLLOSS.CNO=C1.CNO and CLLOSS.CTLF=1)

Union All

Select Top 1 Cast(1 as Bit) as RestrictedF, 'Insured Object is already registered, Policy No : ' + A2.PolicyNo + '-' + A2.CertificateNo as Remarks
from Acceptance A1, Cover C1, Acceptance A2, Cover C2
Where A1.ANO=@P_ANO and C1.CNO=A1.CNO 
and A1.RANO=-1
and A2.ANO<>A2.LANO and A2.OANO<>A1.OANO and C2.CNO=A2.CNO 
and A2.AType in ('N','E') and A2.AStatus not in ('W','T') and C2.CStatus<>'C'
and Not Exists (Select Top 1 pANO from Acceptance A3 WHere A3.pANO=A2.ANO and A3.AType<>'A')
and A2.RegID<>'' and A1.RegID=A2.RegID and A2.FLDID<>'' and A1.FLDID=A2.FLDID and A2.ValueID<>'' and A1.VALUEID=A2.VALUEID and A1.VALUEDESC=A2.VALUEDESC
and C1.PHolder=C2.PHolder and A1.AID=A2.AID AND A1.SDATE BETWEEN A2.SDATE AND DATEADD(MONTH, 12, A2.EDATE)
GO

insert into PatchVersioning
select '55.3 Update Script - Patch 2020 (2)',GETDATE()
go


Declare @PrevScript varchar(100)
Declare @CurrScript varchar(100)

Select @PrevScript='55.2 Update Script - Patch 2020 (1)'
Select @CurrSCript='55.3 Update Script - Patch 2020 (2)'


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



