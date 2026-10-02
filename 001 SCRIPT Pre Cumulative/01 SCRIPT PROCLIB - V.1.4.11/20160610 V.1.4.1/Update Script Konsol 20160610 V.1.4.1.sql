--Update 6 Jun 2016
IF EXISTS ( SELECT * FROM   sysobjects WHERE  id = object_id(N'[dbo].[TREATY_LIMIT]') and OBJECTPROPERTY(id, N'IsProcedure') = 1 ) BEGIN    DROP PROCEDURE [dbo].[TREATY_LIMIT] END 
go
IF EXISTS ( SELECT * FROM   sysobjects WHERE  id = object_id(N'[dbo].[QRiskAssLimit]') and OBJECTPROPERTY(id, N'IsProcedure') = 1 ) BEGIN    DROP PROCEDURE [dbo].[QRiskAssLimit] END 
go
if exists (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[DISPLAY_CALCULATION]') AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) ) BEGIN DROP FUNCTION [dbo].[DISPLAY_CALCULATION] END
go
CREATE Procedure TREATY_LIMIT (@P_ANO integer, @P_OurShare Float, @P_NCoys Integer)  
as  
SELECT TOP 1 TOL.Limit, TOL.HOLDF  
From TOL, acceptance, RARRHEADER, cover, REINSURANCE, RECLASS  
WHERE Acceptance.ANO=@P_ANO And Cover.CNO=Acceptance.CNO And RArrHeader.ANO=Acceptance.ANO  
And Reinsurance.RNO=ReClass.RNO and ReClass.TOC=Cover.TOC And RArrHeader.RDate Between Reinsurance.SDate and Reinsurance.EDate and ReClass.CessionF=1  and Reinsurance.RType In ('D','Q','S1','S2','S3','A')
And TOL.RYear=Reinsurance.RYear And TOL.TOC=ReClass.TOC And TOL.IsType=Cover.IsType  
And ((Minrange<=@P_OurShare And MaxRange>=@P_OurShare) or (MinRange=0 and MaxRange=0))  
And ((MinCoys<=@P_NCoys And MaxCoys>=@P_NCoys) Or (MinCoys=0 And MaxCoys=0))  
And ((MinYear<=datediff(year,Acceptance.SDate, Acceptance.EDate) and MaxYear>=datediff(year,Acceptance.SDate, Acceptance.EDate)) or (MinYear=0 and MaxYear=0))  
Order By TOL.Limit Desc  

  
GO


CREATE PROCEDURE QRiskAssLimit (@PANO as integer, @RType as varchar(10)='')                    
AS                    
SELECT top 1 RiskAss.RiskAss, RiskAss.PLimit, RiskAss.Limit, Cover.ISType, RiskAss.Code, RiskAss.HoldF, RiskAss.Share, RiskAss.Rate, RiskAss.Loading, RiskAss.RType                    
From Riskass, cover, acceptance, Ainfo, RARRHEADER, REINSURANCE, RECLASS                    
WHERE Acceptance.ANO=@PANO And RArrHeader.ANO=Acceptance.ANO and Acceptance.ANO=AInfo.ANO And Acceptance.CNO=Cover.CNO and (RiskAss.RType='' or RiskAss.RType=@RType)                
And Reinsurance.RNO=ReClass.RNO and ReClass.TOC=Cover.TOC And RArrHeader.RDate Between Reinsurance.SDate and Reinsurance.EDate and ReClass.AssessmentF=1 and Reinsurance.RType In ('D','Q','S1','S2','S3','A')
And Riskass.RYear=Reinsurance.RYear And RiskAss.TOC=ReClass.TOC        
and (RiskAss.TSILimit=0 or RArrHeader.TAmount-RArrHeader.MAmount<=RiskAss.TSILimit)                  
And ((RiskAss.ValueID1='' and Ainfo.ValueDesc1 Like RiskAss.ValueDesc1+'%') or (RiskAss.ValueID1<>'' and AInfo.ValueID1 Like RiskAss.ValueID1+'%') or (RiskAss.ValueID1 is null))                    
And ((RiskAss.ValueID2='' and Ainfo.ValueDesc2 Like RiskAss.ValueDesc2+'%') or (RiskAss.ValueID2<>'' and AInfo.ValueID2 Like RiskAss.ValueID2+'%') or (RiskAss.ValueID2 is null))                    
And ((RiskAss.ValueID3='' and Ainfo.ValueDesc3 Like RiskAss.ValueDesc3+'%') or (RiskAss.ValueID3<>'' and AInfo.ValueID3 Like RiskAss.ValueID3+'%') or (RiskAss.ValueID3 is null))                    
And ((RiskAss.ValueID4='' and Ainfo.ValueDesc4 Like RiskAss.ValueDesc4+'%') or (RiskAss.ValueID4<>'' and AInfo.ValueID4 Like RiskAss.ValueID4+'%') or (RiskAss.ValueID4 is null))                    
And ((RiskAss.ValueID5='' and Ainfo.ValueDesc5 Like RiskAss.ValueDesc5+'%') or (RiskAss.ValueID5<>'' and AInfo.ValueID5 Like RiskAss.ValueID5+'%') or (RiskAss.ValueID5 is null))                    
And ((RiskAss.ValueID6='' and Ainfo.ValueDesc6 Like RiskAss.ValueDesc6+'%') or (RiskAss.ValueID6<>'' and AInfo.ValueID6 Like RiskAss.ValueID6+'%') or (RiskAss.ValueID6 is null))                    
And ((RiskAss.ValueID7='' and Ainfo.ValueDesc7 Like RiskAss.ValueDesc7+'%') or (RiskAss.ValueID7<>'' and AInfo.ValueID7 Like RiskAss.ValueID7+'%') or (RiskAss.ValueID7 is null))                    
And ((RiskAss.ValueID8='' and Ainfo.ValueDesc8 Like RiskAss.ValueDesc8+'%') or (RiskAss.ValueID8<>'' and AInfo.ValueID8 Like RiskAss.ValueID8+'%') or (RiskAss.ValueID8 is null))                    
And ((RiskAss.ValueID9='' and Ainfo.ValueDesc9 Like RiskAss.ValueDesc9+'%') or (RiskAss.ValueID9<>'' and AInfo.ValueID9 Like RiskAss.ValueID9+'%') or (RiskAss.ValueID9 is null))                    
And ((RiskAss.ValueID10='' and Ainfo.ValueDesc10 Like RiskAss.ValueDesc10+'%') or (RiskAss.ValueID10<>'' and AInfo.ValueID10 Like RiskAss.ValueID10+'%') or (RiskAss.ValueID10 is null))                    
And ((RiskAss.ValueID11='' and Ainfo.ValueDesc11 Like RiskAss.ValueDesc11+'%') or (RiskAss.ValueID11<>'' and AInfo.ValueID11 Like RiskAss.ValueID11+'%') or (RiskAss.ValueID11 is null))                    
And ((RiskAss.ValueID12='' and Ainfo.ValueDesc12 Like RiskAss.ValueDesc12+'%') or (RiskAss.ValueID12<>'' and AInfo.ValueID12 Like RiskAss.ValueID12+'%') or (RiskAss.ValueID12 is null))                    
And ((RiskAss.ValueID13='' and Ainfo.ValueDesc13 Like RiskAss.ValueDesc13+'%') or (RiskAss.ValueID13<>'' and AInfo.ValueID13 Like RiskAss.ValueID13+'%') or (RiskAss.ValueID13 is null))                    
And ((RiskAss.ValueID14='' and Ainfo.ValueDesc14 Like RiskAss.ValueDesc14+'%') or (RiskAss.ValueID14<>'' and AInfo.ValueID14 Like RiskAss.ValueID14+'%') or (RiskAss.ValueID14 is null))                    
And ((RiskAss.ValueID15='' and Ainfo.ValueDesc15 Like RiskAss.ValueDesc15+'%') or (RiskAss.ValueID15<>'' and AInfo.ValueID15 Like RiskAss.ValueID15+'%') or (RiskAss.ValueID15 is null))                    
Order by                   
RiskAss.RYear Desc,        
RiskAss.RType Desc,            
RiskAss.PriorityF Desc,                  
len(coalesce(RiskAss.ValueID1,'')) Desc, len(coalesce(RiskAss.ValueID2,'')) Desc, len(coalesce(RiskAss.ValueID3,'')) Desc, len(coalesce(RiskAss.ValueID4,'')) Desc, len(coalesce(RiskAss.ValueID5,'')) Desc,                   
len(coalesce(RiskAss.ValueID6,'')) Desc, len(coalesce(RiskAss.ValueID7,'')) Desc, len(coalesce(RiskAss.ValueID8,'')) Desc, len(coalesce(RiskAss.ValueID9,'')) Desc, len(coalesce(RiskAss.ValueID10,'')) Desc,                   
len(coalesce(RiskAss.ValueID11,'')) Desc, len(coalesce(RiskAss.ValueID12,'')) Desc, len(coalesce(RiskAss.ValueID13,'')) Desc, len(coalesce(RiskAss.ValueID14,'')) Desc, len(coalesce(RiskAss.ValueID15,'')) Desc,                   
RiskAss.Limit Desc, RiskAss.Loading, RiskAss.HoldF 
go


 
CREATE FUNCTION [dbo].[DISPLAY_CALCULATION](@P_ANO int) 
RETURNS TABLE  AS 
RETURN ( 
Select A.ANO, D1.Code, D1.SDate, D1.EDate, D1.Gross, D2.Prorata, D1.Currency,  D1.Calculation as Premium_Calculation, D2.Prorata_Calculation, 
D1.Calculation + Case When D2.Prorata=0 or D2.Prorata_Calculation='' Then '' else ' x '+D2.Prorata_Calculation end 
+ Case When A.Qty>1 Then ' x '+ Convert(varchar(25), Cast(A.Qty as Int),1) Else '' end 
+ ' = ' + Convert(varchar(50), Cast(D1.Gross*(Case When D2.Prorata<>0 or D2.Prorata_Calculation<>'' Then D2.Prorata else 1 end)*Case When A.Qty>1 Then A.Qty Else 1 End as Money),1) as Calculation, 
dbo.Premium_Discount(D1.ANO, D1.Code,cast(datediff(Month,A.SDate, D1.SDate) as integer) / 12 + 1) as Discount, dbo.Premium_Commission(D1.ANO, D1.Code,cast(datediff(Month,A.SDate, D1.SDate) as integer) / 12 + 1,0) as Commission 
from Display_Gross_Calculation(@P_ANO) D1, Display_Prorata_Calculation(@P_ANO) D2, Acceptance A 
Where a.ANO = D1.ANO And D1.ANO = D2.ANO And D1.Currency = D2.Currency And D1.Code = D2.Code And D1.SDate = D2.SDate And D1.EDate = D2.EDate and D2.Prorata<>0 
) 
go

update SysTab Set versionNo='20160610 V1.4.1',versionUpdate=getdate()
go