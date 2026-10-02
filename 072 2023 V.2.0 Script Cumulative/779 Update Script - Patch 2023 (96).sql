DROP FUNCTION CLLISTQRY_B
GO
CREATE FUNCTION CLLISTQRY_B(@VALUE1 AS VARCHAR(255), @VALUE2 AS VARCHAR(255), @VALUE5 AS VARCHAR(255), @VALUE6 AS VARCHAR(255), @VALUE7 AS VARCHAR(255), @VALUE8 AS VARCHAR(255), @VALUE9 AS VARCHAR(255), @VALUE10 AS VARCHAR(255), @VALUE11 AS VARCHAR(255), @VALUE12 AS VARCHAR(255), @VALUE13 AS VARCHAR(255),@VALUE14 as Varchar(10), @VALUE15 as Varchar(10),@VALUE16 as Varchar(255),@VALUE17 as Varchar(255),@VALUE18 as Varchar(255),@VALUE21 as Varchar(255), @VALUE22 AS Varchar(255))              
RETURNS Table              
AS RETURN (              

SELECT Claim.CNO,              
  Claim.ClaimNo,              
  Claim.refno,              
  Claim.PolicyNo,              
  Claim.RegDate,              
  Claim.LossDate,              
  Claim.LossPlace,              
  COLTAB.Description,              
  Claim.ClaimantInfo as Claimant,              
  Payment.Name as Payment,              
  Claim.EventName,              
  Claim.CType,              
  Claim.CStatus,             
  Claim.pCStatus, 
  Claim.LargeF,              
  Claim.UniqueF,              
  Claim.TBAF_1,              
  Claim.TBAF_2,              
  Claim.SurveyF,              
  CLLOSS.TOI,              
  Claim.Branch,       
  Claim.TOC,              
  Cover.MO,      
  Case When coalesce(CLInfo.ValueID1,'')='' then AInfo.ValueID1 else CLInfo.ValueID1 end as ValueID1,              
  Case When coalesce(CLInfo.ValueID2,'')='' then AInfo.ValueID2 else CLInfo.ValueID2 end as ValueID2,              
  Case When coalesce(CLInfo.ValueID3,'')='' then AInfo.ValueID3 else CLInfo.ValueID3 end as ValueID3,              
  Case When coalesce(CLInfo.ValueID4,'')='' then AInfo.ValueID4 else CLInfo.ValueID4 end as ValueID4,              
  Case When coalesce(CLInfo.ValueID5,'')='' then AInfo.ValueID5 else CLInfo.ValueID5 end as ValueID5,              
  Case When coalesce(CLInfo.ValueID6,'')='' then AInfo.ValueID6 else CLInfo.ValueID6 end as ValueID6,              
  Case When coalesce(CLInfo.ValueID7,'')='' then AInfo.ValueID7 else CLInfo.ValueID7 end as ValueID7,              
  Case When coalesce(CLInfo.ValueID8,'')='' then AInfo.ValueID8 else CLInfo.ValueID8 end as ValueID8,              
  Case When coalesce(CLInfo.ValueID9,'')='' then AInfo.ValueID9 else CLInfo.ValueID9 end as ValueID9,              
  Case When coalesce(CLInfo.ValueID10,'')='' then AInfo.ValueID10 else CLInfo.ValueID10 end as ValueID10,              
  Case When coalesce(CLInfo.ValueID11,'')='' then AInfo.ValueID11 else CLInfo.ValueID11 end as ValueID11,              
  Case When coalesce(CLInfo.ValueID12,'')='' then AInfo.ValueID12 else CLInfo.ValueID12 end as ValueID12,              
  Case When coalesce(CLInfo.ValueID13,'')='' then AInfo.ValueID13 else CLInfo.ValueID13 end as ValueID13,              
  Case When coalesce(CLInfo.ValueID14,'')='' then AInfo.ValueID14 else CLInfo.ValueID14 end as ValueID14,              
  Case When coalesce(CLInfo.ValueID15,'')='' then AInfo.ValueID15 else CLInfo.ValueID15 end as ValueID15,              
  Case When coalesce(CLInfo.ValueDesc1,'')='' then AInfo.ValueDesc1 else CLInfo.ValueDesc1 end as ValueDesc1,              
  Case When coalesce(CLInfo.ValueDesc2,'')='' then AInfo.ValueDesc2 else CLInfo.ValueDesc2 end as ValueDesc2,              
  Case When coalesce(CLInfo.ValueDesc3,'')='' then AInfo.ValueDesc3 else CLInfo.ValueDesc3 end as ValueDesc3,              
  Case When coalesce(CLInfo.ValueDesc4,'')='' then AInfo.ValueDesc4 else CLInfo.ValueDesc4 end as ValueDesc4,              
  Case When coalesce(CLInfo.ValueDesc5,'')='' then AInfo.ValueDesc5 else CLInfo.ValueDesc5 end as ValueDesc5,              
  Case When coalesce(CLInfo.ValueDesc6,'')='' then AInfo.ValueDesc6 else CLInfo.ValueDesc6 end as ValueDesc6,              
  Case When coalesce(CLInfo.ValueDesc7,'')='' then AInfo.ValueDesc7 else CLInfo.ValueDesc7 end as ValueDesc7,              
  Case When coalesce(CLInfo.ValueDesc8,'')='' then AInfo.ValueDesc8 else CLInfo.ValueDesc8 end as ValueDesc8,              
  Case When coalesce(CLInfo.ValueDesc9,'')='' then AInfo.ValueDesc9 else CLInfo.ValueDesc9 end as ValueDesc9,              
  Case When coalesce(CLInfo.ValueDesc10,'')='' then AInfo.ValueDesc10 else CLInfo.ValueDesc10 end as ValueDesc10,            
  Case When coalesce(CLInfo.ValueDesc11,'')='' then AInfo.ValueDesc11 else CLInfo.ValueDesc11 end as ValueDesc11,              
  Case When coalesce(CLInfo.ValueDesc12,'')='' then AInfo.ValueDesc12 else CLInfo.ValueDesc12 end as ValueDesc12,              
  Case When coalesce(CLInfo.ValueDesc13,'')='' then AInfo.ValueDesc13 else CLInfo.ValueDesc13 end as ValueDesc13,              
  Case When coalesce(CLInfo.ValueDesc14,'')='' then AInfo.ValueDesc14 else CLInfo.ValueDesc14 end as ValueDesc14,              
  Case When coalesce(CLInfo.ValueDesc15,'')='' then AInfo.ValueDesc15 else CLInfo.ValueDesc15 end as ValueDesc15,              
  AINFO_EXT.ValueID16, 
  AINFO_EXT.ValueID17, 
  AINFO_EXT.ValueID18, 
  AINFO_EXT.ValueID19, 
  AINFO_EXT.ValueID20, 
  AINFO_EXT.ValueID21, 
  AINFO_EXT.ValueID22, 
  AINFO_EXT.ValueID23, 
  AINFO_EXT.ValueID24, 
  AINFO_EXT.ValueID25, 
  AINFO_EXT.ValueID26, 
  AINFO_EXT.ValueID27, 
  AINFO_EXT.ValueID28, 
  AINFO_EXT.ValueID29, 
  AINFO_EXT.ValueID30, 
  AINFO_EXT.ValueDesc16, 
  AINFO_EXT.ValueDesc17, 
  AINFO_EXT.ValueDesc18, 
  AINFO_EXT.ValueDesc19, 
  AINFO_EXT.ValueDesc20, 
  AINFO_EXT.ValueDesc21, 
  AINFO_EXT.ValueDesc22, 
  AINFO_EXT.ValueDesc23, 
  AINFO_EXT.ValueDesc24, 
  AINFO_EXT.ValueDesc25, 
  AINFO_EXT.ValueDesc26, 
  AINFO_EXT.ValueDesc27, 
  AINFO_EXT.ValueDesc28, 
  AINFO_EXT.ValueDesc29, 
  AINFO_EXT.ValueDesc30, 
  Acceptance.AName , Acceptance.CertificateNo, Acceptance.RefNo as ARefNo            
From CLAIM              
Inner Join Profile Payment on (Payment.ID=Claim.Payment)        
Left Join CLLoss on (CLLoss.CNO=Claim.CNO and CLLOSS.Refno Like @Value12+'%')
Left Join Profile Claimant on (Claimant.ID=CLLoss.Claimant)
Left Join Profile CPayment on (CPayment.ID=CLLoss.Payment)
Left Join CLCOST on (CLCOST.CNO=Claim.CNO and CLCOST.Refno Like @Value12+'%')
Left Join Acceptance on (Acceptance.ANO=Claim.ANO)              
Left Join Cover on (Cover.CNO=Acceptance.CNO)              
Left Join COLTab on (COLTAB.COL=Claim.COL)              
Left Join AInfo on (AInfo.ANO=Acceptance.ANO)              
Left Join AINFO_EXT on (AINFO_EXT.ANO=Acceptance.ANO)
Left Join CLInfo on (@Value13 Not in ('','%') and CLInfo.CNO=Claim.CNO and CLInfo.INO=CLLoss.INO and CLInfo.NOC=CLLoss.NOC and CLInfo.Claimant=CLLoss.Claimant)        
Where           
  (@Value1='%' or Claim.ClaimNo Like @Value1+'%')    
  And (@Value2='%' or Claim.PolicyNo Like @Value2+'%')    
  And (@Value5='%' or Claim.LossPlace Like @Value5+'%')    
  And (@Value7='%' or Claim.ClaimantInfo Like @Value7+'%' or coalesce(Claimant.Name,'') Like @Value7+'%')      
  And (@Value8='%' or Payment.Name Like @Value8+'%' or coalesce(CPayment.Name,'') Like @Value8+'%')      
  And (@Value9='%' or Claim.EventName Like @Value9+'%')     
  And (@Value12='%' or Claim.Refno Like @Value12+'%' or coalesce(CLLOSS.Refno,'') Like @Value12+'%' or coalesce(CLCOST.Refno,'') Like @Value12+'%')    
  And (@Value10='%' or Claim.CType Like @Value10+'%')    
  And (@Value11='%' or (Claim.CStatus Like @Value11+'%') or (Claim.CStatus='C' and Claim.pCStatus='P' and 'D' Like @Value11+'%'))    
  And ((Claim.LargeF=1 and @Value14='Large') or @Value14='')              
  And ((Claim.UniqueF=1 and @Value15='Unique') or @Value15='')              
  And (((Claim.TBAF_1=1 or Claim.TBAF_2=1) and @Value17='TBA') or @Value17='')              
  And ((Claim.SurveyF=1 and @Value18='Survey') or @Value18='')              
  And (@Value16='%' or Claim.TOC Like @Value16+'%')   
  And (@Value13='%' or CLLOSS.TOI Like @Value13+'%')    
  And (@Value6='%' or COLTAB.Description Like @Value6+'%')    
  And (@Value21='%' or COVER.RefNo Like @Value21+'%')    

  And  
'|'+Case When coalesce(CLInfo.ValueID1,'')='' then AInfo.ValueID1 else CLInfo.ValueID1 end+
'|'+Case When coalesce(CLInfo.ValueID2,'')='' then AInfo.ValueID2 else CLInfo.ValueID2 end+
'|'+Case When coalesce(CLInfo.ValueID3,'')='' then AInfo.ValueID3 else CLInfo.ValueID3 end+
'|'+Case When coalesce(CLInfo.ValueID4,'')='' then AInfo.ValueID4 else CLInfo.ValueID4 end+
'|'+Case When coalesce(CLInfo.ValueID5,'')='' then AInfo.ValueID5 else CLInfo.ValueID5 end+
'|'+Case When coalesce(CLInfo.ValueID6,'')='' then AInfo.ValueID6 else CLInfo.ValueID6 end+
'|'+Case When coalesce(CLInfo.ValueID7,'')='' then AInfo.ValueID7 else CLInfo.ValueID7 end+
'|'+Case When coalesce(CLInfo.ValueID8,'')='' then AInfo.ValueID8 else CLInfo.ValueID8 end+
'|'+Case When coalesce(CLInfo.ValueID9,'')='' then AInfo.ValueID9 else CLInfo.ValueID9 end+
'|'+Case When coalesce(CLInfo.ValueID10,'')='' then AInfo.ValueID10 else CLInfo.ValueID10 end+
'|'+Case When coalesce(CLInfo.ValueID11,'')='' then AInfo.ValueID11 else CLInfo.ValueID11 end+
'|'+Case When coalesce(CLInfo.ValueID12,'')='' then AInfo.ValueID12 else CLInfo.ValueID12 end+
'|'+Case When coalesce(CLInfo.ValueID13,'')='' then AInfo.ValueID13 else CLInfo.ValueID13 end+
'|'+Case When coalesce(CLInfo.ValueID14,'')='' then AInfo.ValueID14 else CLInfo.ValueID14 end+
'|'+Case When coalesce(CLInfo.ValueID15,'')='' then AInfo.ValueID15 else CLInfo.ValueID15 end+
'|'+Case When coalesce(CLInfo.ValueDesc1,'')='' then AInfo.ValueDesc1 else CLInfo.ValueDesc1 end+
'|'+Case When coalesce(CLInfo.ValueDesc2,'')='' then AInfo.ValueDesc2 else CLInfo.ValueDesc2 end+
'|'+Case When coalesce(CLInfo.ValueDesc3,'')='' then AInfo.ValueDesc3 else CLInfo.ValueDesc3 end+
'|'+Case When coalesce(CLInfo.ValueDesc4,'')='' then AInfo.ValueDesc4 else CLInfo.ValueDesc4 end+
'|'+Case When coalesce(CLInfo.ValueDesc5,'')='' then AInfo.ValueDesc5 else CLInfo.ValueDesc5 end+
'|'+Case When coalesce(CLInfo.ValueDesc6,'')='' then AInfo.ValueDesc6 else CLInfo.ValueDesc6 end+
'|'+Case When coalesce(CLInfo.ValueDesc7,'')='' then AInfo.ValueDesc7 else CLInfo.ValueDesc7 end+
'|'+Case When coalesce(CLInfo.ValueDesc8,'')='' then AInfo.ValueDesc8 else CLInfo.ValueDesc8 end+
'|'+Case When coalesce(CLInfo.ValueDesc9,'')='' then AInfo.ValueDesc9 else CLInfo.ValueDesc9 end+
'|'+Case When coalesce(CLInfo.ValueDesc10,'')='' then AInfo.ValueDesc10 else CLInfo.ValueDesc10 end+
'|'+Case When coalesce(CLInfo.ValueDesc11,'')='' then AInfo.ValueDesc11 else CLInfo.ValueDesc11 end+
'|'+Case When coalesce(CLInfo.ValueDesc12,'')='' then AInfo.ValueDesc12 else CLInfo.ValueDesc12 end+
'|'+Case When coalesce(CLInfo.ValueDesc13,'')='' then AInfo.ValueDesc13 else CLInfo.ValueDesc13 end+
'|'+Case When coalesce(CLInfo.ValueDesc14,'')='' then AInfo.ValueDesc14 else CLInfo.ValueDesc14 end+
'|'+Case When coalesce(CLInfo.ValueDesc15,'')='' then AInfo.ValueDesc15 else CLInfo.ValueDesc15 end
 LIKE '|%'+@Value22+'%'
)            

GO

DROP FUNCTION CLLISTQRY 
GO
CREATE FUNCTION CLLISTQRY (@VALUE1 AS VARCHAR(255), @VALUE2 AS VARCHAR(255), @VALUE5 AS VARCHAR(255), @VALUE6 AS VARCHAR(255), @VALUE7 AS VARCHAR(255), @VALUE8 AS VARCHAR(255), @VALUE9 AS VARCHAR(255), @VALUE10 AS VARCHAR(255), @VALUE11 AS VARCHAR(255), @VALUE12 AS VARCHAR(255), @VALUE13 AS VARCHAR(255),@VALUE14 as Varchar(10), @VALUE15 as Varchar(10),@VALUE16 as Varchar(255),@VALUE17 as Varchar(255),@VALUE18 as Varchar(255),@VALUE21 as Varchar(255))              
RETURNS Table              
AS RETURN (              

SELECT Claim.CNO,              
  Claim.ClaimNo,              
  Claim.refno,              
  Claim.PolicyNo,              
  Claim.RegDate,              
  Claim.LossDate,              
  Claim.LossPlace,              
  COLTAB.Description,              
  Claim.ClaimantInfo as Claimant,              
  Payment.Name as Payment,              
  Claim.EventName,              
  Claim.CType,              
  Claim.CStatus,             
  Claim.pCStatus, 
  Claim.LargeF,              
  Claim.UniqueF,              
  Claim.TBAF_1,              
  Claim.TBAF_2,              
  Claim.SurveyF,              
  CLLOSS.TOI,              
  Claim.Branch,       
  Claim.TOC,              
  Cover.MO,      
  Case When coalesce(CLInfo.ValueID1,'')='' then AInfo.ValueID1 else CLInfo.ValueID1 end as ValueID1,              
  Case When coalesce(CLInfo.ValueID2,'')='' then AInfo.ValueID2 else CLInfo.ValueID2 end as ValueID2,              
  Case When coalesce(CLInfo.ValueID3,'')='' then AInfo.ValueID3 else CLInfo.ValueID3 end as ValueID3,              
  Case When coalesce(CLInfo.ValueID4,'')='' then AInfo.ValueID4 else CLInfo.ValueID4 end as ValueID4,              
  Case When coalesce(CLInfo.ValueID5,'')='' then AInfo.ValueID5 else CLInfo.ValueID5 end as ValueID5,              
  Case When coalesce(CLInfo.ValueID6,'')='' then AInfo.ValueID6 else CLInfo.ValueID6 end as ValueID6,              
  Case When coalesce(CLInfo.ValueID7,'')='' then AInfo.ValueID7 else CLInfo.ValueID7 end as ValueID7,              
  Case When coalesce(CLInfo.ValueID8,'')='' then AInfo.ValueID8 else CLInfo.ValueID8 end as ValueID8,              
  Case When coalesce(CLInfo.ValueID9,'')='' then AInfo.ValueID9 else CLInfo.ValueID9 end as ValueID9,              
  Case When coalesce(CLInfo.ValueID10,'')='' then AInfo.ValueID10 else CLInfo.ValueID10 end as ValueID10,              
  Case When coalesce(CLInfo.ValueID11,'')='' then AInfo.ValueID11 else CLInfo.ValueID11 end as ValueID11,              
  Case When coalesce(CLInfo.ValueID12,'')='' then AInfo.ValueID12 else CLInfo.ValueID12 end as ValueID12,              
  Case When coalesce(CLInfo.ValueID13,'')='' then AInfo.ValueID13 else CLInfo.ValueID13 end as ValueID13,              
  Case When coalesce(CLInfo.ValueID14,'')='' then AInfo.ValueID14 else CLInfo.ValueID14 end as ValueID14,              
  Case When coalesce(CLInfo.ValueID15,'')='' then AInfo.ValueID15 else CLInfo.ValueID15 end as ValueID15,              
  Case When coalesce(CLInfo.ValueDesc1,'')='' then AInfo.ValueDesc1 else CLInfo.ValueDesc1 end as ValueDesc1,              
  Case When coalesce(CLInfo.ValueDesc2,'')='' then AInfo.ValueDesc2 else CLInfo.ValueDesc2 end as ValueDesc2,              
  Case When coalesce(CLInfo.ValueDesc3,'')='' then AInfo.ValueDesc3 else CLInfo.ValueDesc3 end as ValueDesc3,              
  Case When coalesce(CLInfo.ValueDesc4,'')='' then AInfo.ValueDesc4 else CLInfo.ValueDesc4 end as ValueDesc4,              
  Case When coalesce(CLInfo.ValueDesc5,'')='' then AInfo.ValueDesc5 else CLInfo.ValueDesc5 end as ValueDesc5,              
  Case When coalesce(CLInfo.ValueDesc6,'')='' then AInfo.ValueDesc6 else CLInfo.ValueDesc6 end as ValueDesc6,              
  Case When coalesce(CLInfo.ValueDesc7,'')='' then AInfo.ValueDesc7 else CLInfo.ValueDesc7 end as ValueDesc7,              
  Case When coalesce(CLInfo.ValueDesc8,'')='' then AInfo.ValueDesc8 else CLInfo.ValueDesc8 end as ValueDesc8,              
  Case When coalesce(CLInfo.ValueDesc9,'')='' then AInfo.ValueDesc9 else CLInfo.ValueDesc9 end as ValueDesc9,              
  Case When coalesce(CLInfo.ValueDesc10,'')='' then AInfo.ValueDesc10 else CLInfo.ValueDesc10 end as ValueDesc10,            
  Case When coalesce(CLInfo.ValueDesc11,'')='' then AInfo.ValueDesc11 else CLInfo.ValueDesc11 end as ValueDesc11,              
  Case When coalesce(CLInfo.ValueDesc12,'')='' then AInfo.ValueDesc12 else CLInfo.ValueDesc12 end as ValueDesc12,              
  Case When coalesce(CLInfo.ValueDesc13,'')='' then AInfo.ValueDesc13 else CLInfo.ValueDesc13 end as ValueDesc13,              
  Case When coalesce(CLInfo.ValueDesc14,'')='' then AInfo.ValueDesc14 else CLInfo.ValueDesc14 end as ValueDesc14,              
  Case When coalesce(CLInfo.ValueDesc15,'')='' then AInfo.ValueDesc15 else CLInfo.ValueDesc15 end as ValueDesc15,              
  AINFO_EXT.ValueID16, 
  AINFO_EXT.ValueID17, 
  AINFO_EXT.ValueID18, 
  AINFO_EXT.ValueID19, 
  AINFO_EXT.ValueID20, 
  AINFO_EXT.ValueID21, 
  AINFO_EXT.ValueID22, 
  AINFO_EXT.ValueID23, 
  AINFO_EXT.ValueID24, 
  AINFO_EXT.ValueID25, 
  AINFO_EXT.ValueID26, 
  AINFO_EXT.ValueID27, 
  AINFO_EXT.ValueID28, 
  AINFO_EXT.ValueID29, 
  AINFO_EXT.ValueID30, 
  AINFO_EXT.ValueDesc16, 
  AINFO_EXT.ValueDesc17, 
  AINFO_EXT.ValueDesc18, 
  AINFO_EXT.ValueDesc19, 
  AINFO_EXT.ValueDesc20, 
  AINFO_EXT.ValueDesc21, 
  AINFO_EXT.ValueDesc22, 
  AINFO_EXT.ValueDesc23, 
  AINFO_EXT.ValueDesc24, 
  AINFO_EXT.ValueDesc25, 
  AINFO_EXT.ValueDesc26, 
  AINFO_EXT.ValueDesc27, 
  AINFO_EXT.ValueDesc28, 
  AINFO_EXT.ValueDesc29, 
  AINFO_EXT.ValueDesc30, 
  Acceptance.AName , Acceptance.CertificateNo, Acceptance.RefNo as ARefNo            
From CLAIM              
Inner Join Profile Payment on (Payment.ID=Claim.Payment)        
Left Join CLLoss on (CLLoss.CNO=Claim.CNO and CLLOSS.Refno Like @Value12+'%')
Left Join Profile Claimant on (Claimant.ID=CLLoss.Claimant)
Left Join Profile CPayment on (CPayment.ID=CLLoss.Payment)
Left Join CLCOST on (CLCOST.CNO=Claim.CNO and CLCOST.Refno Like @Value12+'%')
Left Join Acceptance on (Acceptance.ANO=Claim.ANO)              
Left Join Cover on (Cover.CNO=Acceptance.CNO)              
Left Join COLTab on (COLTAB.COL=Claim.COL)              
Left Join AInfo on (AInfo.ANO=Acceptance.ANO)              
Left Join AINFO_EXT on (AINFO_EXT.ANO=Acceptance.ANO)
Left Join CLInfo on (@Value13 Not in ('','%') and CLInfo.CNO=Claim.CNO and CLInfo.INO=CLLoss.INO and CLInfo.NOC=CLLoss.NOC and CLInfo.Claimant=CLLoss.Claimant)        
Where           
  (@Value1='%' or Claim.ClaimNo Like @Value1+'%')    
  And (@Value2='%' or Claim.PolicyNo Like @Value2+'%')    
  And (@Value5='%' or Claim.LossPlace Like @Value5+'%')    
  And (@Value7='%' or Claim.ClaimantInfo Like @Value7+'%' or coalesce(Claimant.Name,'') Like @Value7+'%')      
  And (@Value8='%' or Payment.Name Like @Value8+'%' or coalesce(CPayment.Name,'') Like @Value8+'%')      
  And (@Value9='%' or Claim.EventName Like @Value9+'%')     
  And (@Value12='%' or Claim.Refno Like @Value12+'%' or coalesce(CLLOSS.Refno,'') Like @Value12+'%' or coalesce(CLCOST.Refno,'') Like @Value12+'%')    
  And (@Value10='%' or Claim.CType Like @Value10+'%')    
  And (@Value11='%' or (Claim.CStatus Like @Value11+'%') or (Claim.CStatus='C' and Claim.pCStatus='P' and 'D' Like @Value11+'%'))    
  And ((Claim.LargeF=1 and @Value14='Large') or @Value14='')              
  And ((Claim.UniqueF=1 and @Value15='Unique') or @Value15='')              
  And (((Claim.TBAF_1=1 or Claim.TBAF_2=1) and @Value17='TBA') or @Value17='')              
  And ((Claim.SurveyF=1 and @Value18='Survey') or @Value18='')              
  And (@Value16='%' or Claim.TOC Like @Value16+'%')   
  And (@Value13='%' or CLLOSS.TOI Like @Value13+'%')    
  And (@Value6='%' or COLTAB.Description Like @Value6+'%')    
  And (@Value21='%' or COVER.RefNo Like @Value21+'%')    
)          


go



 insert into PatchVersioning
select '779 Update Script - Patch 2023 (96)',GETDATE()
go


Declare @PrevScript varchar(100)
Declare @CurrScript varchar(100)

Select @PrevScript=''
Select @CurrSCript='779 Update Script - Patch 2023 (96)'


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













