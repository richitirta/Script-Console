
DROP FUNCTION FL_UW_Ded
GO
CREATE FUNCTION FL_UW_Ded(@P_ANO as integer, @P_DCode as varchar(255), @P_TOPF as bit=0)  
RETURNS TABLE  
As Return (  
Select Distinct DedTab.*   
From RCOVER  
Inner Join RATECOV on RATECOV.CODE = RCOVER.CODE  
Inner Join DedTab on DeDTab.TOR = RateCov.TOR   
Inner Join TOR on (TOR.TOR=DedTab.TOR)
Inner Join Acceptance on Acceptance.ANO = RCover.ANO  
Left join TOP_Deductible on TOP_Deductible.TOPRO=Acceptance.TOPRO and TOP_Deductible.DCode=DedTab.DCode   
WHERE RCOVER.ANO=@P_ANO and DedTab.ALLOWEDF=1 
AND (DedTab.DCode Like @P_DCode OR DedTab.Remarks Like @P_DCode)  
and (@P_TOPF=0 or coalesce(TOP_Deductible.TOPRO,'')=Acceptance.TOPRO)   
AND (coalesce(ValueID1L,'') in ('<All>','') OR EXISTS (SELECT TOP 1 * FROM ACCSEARCH WHERE ACCSEARCH.ANO=@P_ANO AND TOR.RFLDID1=ACCSEARCH.FLDID and right(space(15)+ACCSEARCH.VALUEID,15) Between right(space(15)+ValueID1L,15) and (Case When ValueID1U in ('') then right(space(15)+ValueID1L,15) else right(space(15)+ValueID1U,15) end)))
AND (coalesce(ValueID2L,'') in ('<All>','') OR EXISTS (SELECT TOP 1 * FROM ACCSEARCH WHERE ACCSEARCH.ANO=@P_ANO AND TOR.RFLDID2=ACCSEARCH.FLDID and right(space(15)+ACCSEARCH.VALUEID,15) Between right(space(15)+ValueID2L,15) and (Case When ValueID2U in ('') then right(space(15)+ValueID2L,15) else right(space(15)+ValueID2U,15) end)))
AND (coalesce(ValueID3L,'') in ('<All>','') OR EXISTS (SELECT TOP 1 * FROM ACCSEARCH WHERE ACCSEARCH.ANO=@P_ANO AND TOR.RFLDID3=ACCSEARCH.FLDID and right(space(15)+ACCSEARCH.VALUEID,15) Between right(space(15)+ValueID3L,15) and (Case When ValueID3U in ('') then right(space(15)+ValueID3L,15) else right(space(15)+ValueID3U,15) end)))
AND (coalesce(ValueID4L,'') in ('<All>','') OR EXISTS (SELECT TOP 1 * FROM ACCSEARCH WHERE ACCSEARCH.ANO=@P_ANO AND TOR.RFLDID4=ACCSEARCH.FLDID and right(space(15)+ACCSEARCH.VALUEID,15) Between right(space(15)+ValueID4L,15) and (Case When ValueID4U in ('') then right(space(15)+ValueID4L,15) else right(space(15)+ValueID4U,15) end)))
AND (coalesce(ValueID5L,'') in ('<All>','') OR EXISTS (SELECT TOP 1 * FROM ACCSEARCH WHERE ACCSEARCH.ANO=@P_ANO AND TOR.RFLDID5=ACCSEARCH.FLDID and right(space(15)+ACCSEARCH.VALUEID,15) Between right(space(15)+ValueID5L,15) and (Case When ValueID5U in ('') then right(space(15)+ValueID5L,15) else right(space(15)+ValueID5U,15) end)))
) 

GO

DROP FUNCTION fn_RateCon
GO
CREATE FUNCTION fn_RateCon(@P_ANO as int,@P_Code as varchar(20),@P_TSI as Float=0)       
RETURNS Table       
AS RETURN (       
Select Top 1 *
From
(
	SELECT Top 1 RateTab.Code, cast(0 as Bit) as ProgressiveF, RateCon.AllowedF, RateCon.MinRate, RateCon.MaxRate, RateCon.PML, RateCon.TExcess, RateTab.RateLoadingF,       
	Case When coalesce(RateCon.Loading,0)=0 Then 100 else RateCon.Loading end as Loading,       
	Case When coalesce(RateCon.PCTLOSS,0)=0 Then 100 else RateCon.PCTLOSS end as PCTLOSS,       
	--Rate Always in Percent       
	Case       
	When RateCon.Unit='F' then (Case When (Case When @P_TSI=0 Then 1 Else @P_TSI End)<>0 Then RateCon.Rate/(Case When @P_TSI=0 Then 1 Else @P_TSI End)*100 else 0 end)       
	When RateCon.Unit='M' then RateCon.Rate/10       
	else RateCon.Rate end as Rate,       
	RateCon.MaxTSI as MaxTSI     
	From Acceptance       
	INNER JOIN AInfo on (AInfo.ANO=Acceptance.ANO)       
	INNER JOIN COVER ON (COVER.CNO=ACCEPTANCE.CNO)       
	INNER JOIN RateTab ON (RateTab.Effective<=Acceptance.SDate and (@P_Code='%' or RateTab.Code Like @P_Code or RateTab.PCode Like @P_Code))       
	INNER JOIN RateCon on (    
	 RateTab.TOC=Cover.TOC and RateCon.Code=RateTab.Code And ((Case When @P_TSI=0 Then 1 Else @P_TSI End)>=RateCon.MinTSI or RateCon.MinTSI=0) and ((Case When @P_TSI=0 Then 1 Else @P_TSI End)<=RateCon.MaxTSI or RateCon.MaxTSI=0)     
	 And RateCon.ALLOWEDF=1
	 And RateCon.ProgressiveF=0
	 And (
	 (RateTab.SPeriod=0 and (    
	 (datediff(month, acceptance.sdate, acceptance.edate)>=RateCon.MinPeriod)     
	 or (datediff(month, acceptance.sdate, acceptance.edate)=RateCon.MinPeriod-1 and day(acceptance.sdate)<day(acceptance.edate))     
	 or RateCon.MinPeriod=0)                               
	 And (    
	 (datediff(month, acceptance.sdate, acceptance.edate)<RateCon.MaxPeriod)     
	 or (datediff(month, acceptance.sdate, acceptance.edate)=RateCon.MaxPeriod and day(acceptance.sdate)>=day(acceptance.edate))     
	 or RateCon.MaxPeriod=0)) OR
	(RateTab.SPeriod=1 
	 and ((datediff(day, acceptance.sdate, acceptance.edate)>=RateCon.MinPeriod) or RateCon.MinPeriod=0)
	 And ((datediff(day, acceptance.sdate, acceptance.edate)<=RateCon.MaxPeriod) or RateCon.MaxPeriod=0))
	 )     
	) 
	WHERE Acceptance.ANO=@P_ANO       
	And (coalesce(RateCon.ValueID1,'')='' or AINFO.VALUEID1 =RateCon.ValueID1)       
	And (coalesce(RateCon.ValueID2,'')='' or AINFO.VALUEID2 =RateCon.ValueID2)       
	And (coalesce(RateCon.ValueID3,'')='' or AINFO.VALUEID3 =RateCon.ValueID3)       
	And (coalesce(RateCon.ValueID4,'')='' or AINFO.VALUEID4 =RateCon.ValueID4)       
	And (coalesce(RateCon.ValueID5,'')='' or AINFO.VALUEID5 =RateCon.ValueID5)       
	And (coalesce(RateCon.ValueID6,'')='' or AINFO.VALUEID6 =RateCon.ValueID6)       
	And (coalesce(RateCon.ValueID7,'')='' or AINFO.VALUEID7 =RateCon.ValueID7)       
	And (coalesce(RateCon.ValueID8,'')='' or AINFO.VALUEID8 =RateCon.ValueID8)       
	And (coalesce(RateCon.ValueID9,'')='' or AINFO.VALUEID9 =RateCon.ValueID9)       
	And (coalesce(RateCon.ValueID10,'')='' or AINFO.VALUEID10 =RateCon.ValueID10)       
	And (coalesce(RateCon.ValueID11,'')='' or AINFO.VALUEID11 =RateCon.ValueID11)       
	And (coalesce(RateCon.ValueID12,'')='' or AINFO.VALUEID12 =RateCon.ValueID12)       
	And (coalesce(RateCon.ValueID13,'')='' or AINFO.VALUEID13 =RateCon.ValueID13)       
	And (coalesce(RateCon.ValueID14,'')='' or AINFO.VALUEID14 =RateCon.ValueID14)       
	And (coalesce(RateCon.ValueID15,'')='' or AINFO.VALUEID15 =RateCon.ValueID15)       
	Order by       
	RateTab.Effective Desc,       
	len(coalesce(RateCon.ValueID1,'')) Desc,       
	len(coalesce(RateCon.ValueID2,'')) Desc,       
	len(coalesce(RateCon.ValueID3,'')) Desc,       
	len(coalesce(RateCon.ValueID4,'')) Desc,       
	len(coalesce(RateCon.ValueID5,'')) Desc,       
	len(coalesce(RateCon.ValueID6,'')) Desc,       
	len(coalesce(RateCon.ValueID7,'')) Desc,       
	len(coalesce(RateCon.ValueID8,'')) Desc,       
	len(coalesce(RateCon.ValueID9,'')) Desc,       
	len(coalesce(RateCon.ValueID10,'')) Desc,       
	len(coalesce(RateCon.ValueID11,'')) Desc,       
	len(coalesce(RateCon.ValueID12,'')) Desc,       
	len(coalesce(RateCon.ValueID13,'')) Desc,       
	len(coalesce(RateCon.ValueID14,'')) Desc,       
	len(coalesce(RateCon.ValueID15,'')) Desc       

	UNION ALL

	SELECT RateTab.Code, 
	cast(1 as Bit) as ProgressiveF,
	Cast(Max(Cast(RateCon.AllowedF as Int)) as Bit) as AllowedF, 
	sum(Case When (Case When @P_TSI=0 Then 1 Else @P_TSI End)>=RateCon.MaxTSI Then RateCon.MaxTSI-RateCon.MinTSI Else (Case When @P_TSI=0 Then 1 Else @P_TSI End)-RateCon.MinTSI end*RateCon.MinRate/(Case When @P_TSI=0 Then 1 Else @P_TSI End)) as MinRate,
	sum(Case When (Case When @P_TSI=0 Then 1 Else @P_TSI End)>=RateCon.MaxTSI Then RateCon.MaxTSI-RateCon.MinTSI Else (Case When @P_TSI=0 Then 1 Else @P_TSI End)-RateCon.MinTSI end*RateCon.MaxRate/(Case When @P_TSI=0 Then 1 Else @P_TSI End)) as MaxRate,
	Max(RateCon.PML) as PML, 
	Max(RateCon.TExcess) as TExcess, 
	cast(Max(cast(RateTab.RateLoadingF as Int)) as Bit) as RateLoadingF,       
	Max(Case When coalesce(RateCon.Loading,0)=0 Then 100 else RateCon.Loading end) as Loading,       
	Max(Case When coalesce(RateCon.PCTLOSS,0)=0 Then 100 else RateCon.PCTLOSS end) as PCTLOSS,       
	--Rate Always in Percent       
	sum(
	Case       
	When RateCon.Unit='F' then (Case When (Case When @P_TSI=0 Then 1 Else @P_TSI End)<>0 Then RateCon.Rate/(Case When @P_TSI=0 Then 1 Else @P_TSI End)*100 else 0 end)       
	When RateCon.Unit='M' then 
		Case When (Case When @P_TSI=0 Then 1 Else @P_TSI End)>=RateCon.MaxTSI Then RateCon.MaxTSI-RateCon.MinTSI Else (Case When @P_TSI=0 Then 1 Else @P_TSI End)-RateCon.MinTSI end*RateCon.Rate/10/(Case When @P_TSI=0 Then 1 Else @P_TSI End) 
	else Case When (Case When @P_TSI=0 Then 1 Else @P_TSI End)>=RateCon.MaxTSI Then RateCon.MaxTSI-RateCon.MinTSI Else (Case When @P_TSI=0 Then 1 Else @P_TSI End)-RateCon.MinTSI end*RateCon.Rate/(Case When @P_TSI=0 Then 1 Else @P_TSI End) end 
	)as Rate,
	Max(RateCon.MaxTSI) as MaxTSI     
	From Acceptance       
	INNER JOIN AInfo on (AInfo.ANO=Acceptance.ANO)       
	INNER JOIN COVER ON (COVER.CNO=ACCEPTANCE.CNO)       
	INNER JOIN RateTab ON (RateTab.Effective<=Acceptance.SDate and (@P_Code='%' or RateTab.Code Like @P_Code or RateTab.PCode Like @P_Code))       
	INNER JOIN RateCon on (    
	 RateTab.TOC=Cover.TOC and RateCon.Code=RateTab.Code 
	 And ((Case When @P_TSI=0 Then 1 Else @P_TSI End) Between RateCon.MinTSI and RateCon.MaxTSI or RateCon.MaxTSI<=(Case When @P_TSI=0 Then 1 Else @P_TSI End))
	 And RateCon.ALLOWEDF=1
	 And RateCon.ProgressiveF=1
	 And (
	 (RateTab.SPeriod=0 and (    
	 (datediff(month, acceptance.sdate, acceptance.edate)>=RateCon.MinPeriod)     
	 or (datediff(month, acceptance.sdate, acceptance.edate)=RateCon.MinPeriod-1 and day(acceptance.sdate)<day(acceptance.edate))     
	 or RateCon.MinPeriod=0)                               
	 And (    
	 (datediff(month, acceptance.sdate, acceptance.edate)<RateCon.MaxPeriod)     
	 or (datediff(month, acceptance.sdate, acceptance.edate)=RateCon.MaxPeriod and day(acceptance.sdate)>=day(acceptance.edate))     
	 or RateCon.MaxPeriod=0)) OR
	(RateTab.SPeriod=1 
	 and ((datediff(day, acceptance.sdate, acceptance.edate)>=RateCon.MinPeriod) or RateCon.MinPeriod=0)
	 And ((datediff(day, acceptance.sdate, acceptance.edate)<=RateCon.MaxPeriod) or RateCon.MaxPeriod=0))
	 )     
	) 
	WHERE Acceptance.ANO=@P_ANO       
	And (coalesce(RateCon.ValueID1,'')='' or AINFO.VALUEID1 =RateCon.ValueID1)       
	And (coalesce(RateCon.ValueID2,'')='' or AINFO.VALUEID2 =RateCon.ValueID2)       
	And (coalesce(RateCon.ValueID3,'')='' or AINFO.VALUEID3 =RateCon.ValueID3)       
	And (coalesce(RateCon.ValueID4,'')='' or AINFO.VALUEID4 =RateCon.ValueID4)       
	And (coalesce(RateCon.ValueID5,'')='' or AINFO.VALUEID5 =RateCon.ValueID5)       
	And (coalesce(RateCon.ValueID6,'')='' or AINFO.VALUEID6 =RateCon.ValueID6)       
	And (coalesce(RateCon.ValueID7,'')='' or AINFO.VALUEID7 =RateCon.ValueID7)       
	And (coalesce(RateCon.ValueID8,'')='' or AINFO.VALUEID8 =RateCon.ValueID8)       
	And (coalesce(RateCon.ValueID9,'')='' or AINFO.VALUEID9 =RateCon.ValueID9)       
	And (coalesce(RateCon.ValueID10,'')='' or AINFO.VALUEID10 =RateCon.ValueID10)       
	And (coalesce(RateCon.ValueID11,'')='' or AINFO.VALUEID11 =RateCon.ValueID11)       
	And (coalesce(RateCon.ValueID12,'')='' or AINFO.VALUEID12 =RateCon.ValueID12)       
	And (coalesce(RateCon.ValueID13,'')='' or AINFO.VALUEID13 =RateCon.ValueID13)       
	And (coalesce(RateCon.ValueID14,'')='' or AINFO.VALUEID14 =RateCon.ValueID14)       
	And (coalesce(RateCon.ValueID15,'')='' or AINFO.VALUEID15 =RateCon.ValueID15)       
	Group By RateTab.Code
) R
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
  Claim.LargeF,              
  Claim.UniqueF,              
  Claim.TBAF_1,              
  Claim.TBAF_2,              
  Claim.SurveyF,              
  CLLOSS.TOI,              
  Claim.Branch,       
  Claim.TOC,              
  Cover.MO,      
  Case When CLInfo.CNO is null then AInfo.ValueID1 else CLInfo.ValueID1 end as ValueID1,              
  Case When CLInfo.CNO is null then AInfo.ValueID2 else CLInfo.ValueID2 end as ValueID2,              
  Case When CLInfo.CNO is null then AInfo.ValueID3 else CLInfo.ValueID3 end as ValueID3,              
  Case When CLInfo.CNO is null then AInfo.ValueID4 else CLInfo.ValueID4 end as ValueID4,              
  Case When CLInfo.CNO is null then AInfo.ValueID5 else CLInfo.ValueID5 end as ValueID5,              
  Case When CLInfo.CNO is null then AInfo.ValueID6 else CLInfo.ValueID6 end as ValueID6,              
  Case When CLInfo.CNO is null then AInfo.ValueID7 else CLInfo.ValueID7 end as ValueID7,              
  Case When CLInfo.CNO is null then AInfo.ValueID8 else CLInfo.ValueID8 end as ValueID8,              
  Case When CLInfo.CNO is null then AInfo.ValueID9 else CLInfo.ValueID9 end as ValueID9,              
  Case When CLInfo.CNO is null then AInfo.ValueID10 else CLInfo.ValueID10 end as ValueID10,              
  Case When CLInfo.CNO is null then AInfo.ValueID11 else CLInfo.ValueID11 end as ValueID11,              
  Case When CLInfo.CNO is null then AInfo.ValueID12 else CLInfo.ValueID12 end as ValueID12,              
  Case When CLInfo.CNO is null then AInfo.ValueID13 else CLInfo.ValueID13 end as ValueID13,              
  Case When CLInfo.CNO is null then AInfo.ValueID14 else CLInfo.ValueID14 end as ValueID14,              
  Case When CLInfo.CNO is null then AInfo.ValueID15 else CLInfo.ValueID15 end as ValueID15,              
  Case When CLInfo.CNO is null then AInfo.ValueDesc1 else CLInfo.ValueDesc1 end as ValueDesc1,              
  Case When CLInfo.CNO is null then AInfo.ValueDesc2 else CLInfo.ValueDesc2 end as ValueDesc2,              
  Case When CLInfo.CNO is null then AInfo.ValueDesc3 else CLInfo.ValueDesc3 end as ValueDesc3,              
  Case When CLInfo.CNO is null then AInfo.ValueDesc4 else CLInfo.ValueDesc4 end as ValueDesc4,              
  Case When CLInfo.CNO is null then AInfo.ValueDesc5 else CLInfo.ValueDesc5 end as ValueDesc5,              
  Case When CLInfo.CNO is null then AInfo.ValueDesc6 else CLInfo.ValueDesc6 end as ValueDesc6,              
  Case When CLInfo.CNO is null then AInfo.ValueDesc7 else CLInfo.ValueDesc7 end as ValueDesc7,              
  Case When CLInfo.CNO is null then AInfo.ValueDesc8 else CLInfo.ValueDesc8 end as ValueDesc8,              
  Case When CLInfo.CNO is null then AInfo.ValueDesc9 else CLInfo.ValueDesc9 end as ValueDesc9,              
  Case When CLInfo.CNO is null then AInfo.ValueDesc10 else CLInfo.ValueDesc10 end as ValueDesc10,            
  Case When CLInfo.CNO is null then AInfo.ValueDesc11 else CLInfo.ValueDesc11 end as ValueDesc11,              
  Case When CLInfo.CNO is null then AInfo.ValueDesc12 else CLInfo.ValueDesc12 end as ValueDesc12,              
  Case When CLInfo.CNO is null then AInfo.ValueDesc13 else CLInfo.ValueDesc13 end as ValueDesc13,              
  Case When CLInfo.CNO is null then AInfo.ValueDesc14 else CLInfo.ValueDesc14 end as ValueDesc14,              
  Case When CLInfo.CNO is null then AInfo.ValueDesc15 else CLInfo.ValueDesc15 end as ValueDesc15,              
  Acceptance.AName , Acceptance.CertificateNo, Acceptance.RefNo as ARefNo            
From CLAIM              
Inner Join Profile Payment on (Payment.ID=Claim.Payment)        
Left Join CLLoss on (CLLoss.CNO=Claim.CNO and Not (@Value13=''))        
Left Join CLInfo on (CLInfo.CNO=CLLoss.CNO and CLInfo.INO=CLLoss.INO and CLInfo.NOC=CLLOSS.NOC)        
Left Join Acceptance on (Acceptance.ANO=Claim.ANO)              
Left Join AInfo on (AInfo.ANO=Acceptance.ANO)              
Left Join Cover on (Cover.CNO=Acceptance.CNO)              
Left Join COLTab on (COLTAB.COL=Claim.COL)              
Where           
  (@Value1='%' or Claim.ClaimNo Like @Value1+'%')    
  And (@Value2='%' or Claim.PolicyNo Like @Value2+'%')    
  And (@Value5='%' or Claim.LossPlace Like @Value5+'%')    
  And (@Value7='%' or Claim.ClaimantInfo Like @Value7+'%' or exists (Select P.ID from CLLoss C, Profile P Where C.CNO=Claim.CNO and P.ID=C.Claimant and P.Name Like @Value7+'%'))      
  And (@Value8='%' or Payment.Name Like @Value8+'%' or exists (Select P.ID from CLLoss C, Profile P Where C.CNO=Claim.CNO and P.ID=C.Payment and P.Name Like @Value8+'%'))    
  And (@Value9='%' or Claim.EventName Like @Value9+'%')     
  And (@Value12='%' or Claim.Refno Like @Value12+'%')    
  And (@Value10='%' or Claim.CType Like @Value10+'%')    
  And (@Value11='%' or Claim.CStatus Like @Value11+'%')    
  And ((Claim.LargeF=1 and @Value14='Large') or @Value14='')              
  And ((Claim.UniqueF=1 and @Value15='Unique') or @Value15='')              
  And (((Claim.TBAF_1=1 or Claim.TBAF_2=1) and @Value17='TBA') or @Value17='')              
  And ((Claim.SurveyF=1 and @Value18='Survey') or @Value18='')              
  And (@Value16='%' or Claim.TOC Like @Value16+'%')   
  And (@Value13='%' or coalesce(CLLOSS.TOI,'') like @Value13+'%')    
  And (@Value6='%' or coalesce(COLTAB.Description,'') Like @Value6+'%')    
  And (@Value21='%' or coalesce(COVER.RefNo,'') Like @Value21+'%')    
)              





GO

DROP Procedure QScheme_Verify_6 
GO
CREATE Procedure QScheme_Verify_6 
@p_Coverage as varchar (255), 
@p_Interest as varchar (20), 
@p_TSI as float, 
@P_NOfYears as float, 
@p_SchemeNo as varchar (10), 
@p_Description as varchar (255) 
as 
Select Top 1 *
from 
(
	Select Top 1 
	S1.Code, 
	cast(0 as Bit) as ProgressiveF,
	(Case When @p_TSI=0 then (Case When S1.IncludeF=1 Then S1.SI else 0 end) else @P_TSI end) as SI, 
	Case       
	When S1.Unit='F' then Case When (Case When @p_TSI=0 then (Case When S1.IncludeF=1 Then S1.SI else 0 end) else @P_TSI end)<>0 Then S1.Rate/(Case When @p_TSI=0 then (Case When S1.IncludeF=1 Then S1.SI else 0 end) else @P_TSI end)*100 else 0 end
	When S1.Unit='M' then S1.Rate/10
	else S1.Rate end
	as Rate,
	S1.Unit, S1.Category, S1.Portion, S1.TOI, S1.NOTDECRF, S1.RateBasedID, 
	TOI.Description as TOIDesc, 
	TOI.Adjustable, 
	RateTab.Description as RateDesc,
	S1.Upper
	from 
	RateTab, 
	TOI, 
	Scheme_Additional S1, 
	Scheme_Class S2 
	Where 
	RateTab.Code=S1.Code 
	and TOI.TOI=S1.TOI 
	and (S1.Coverage='' or S1.Coverage=@P_Coverage) 
	and S1.Interest=@p_Interest 
	and (S1.Lower<=(Case When @p_TSI=0 then (Case When S1.IncludeF=1 Then S1.SI else 0 end) else @P_TSI end) or S1.Lower=0) 
	and (S1.Upper>=(Case When @p_TSI=0 then (Case When S1.IncludeF=1 Then S1.SI else 0 end) else @P_TSI end) or S1.Upper=0) 
	and (S1.NOfYearsL<=@p_NOfYears or S1.NOfYearsL=0) 
	and (S1.NOfYearsU>=@p_NOfYears or S1.NOfYearsU=0) 
	and S2.ClassNo=S1.ClassNo 
	and S2.SchemeNo=@p_SchemeNO 
	and @p_Description Like S2.Description 
	and S2.Priority=coalesce((Select Top 1 S3.Priority from Scheme_Class S3 Where S3.SchemeNo=@P_SchemeNo and @P_Description like S3.Description Order By S3.Priority Desc),0) 
	and S1.ProgressiveF=0

	Union All

	Select Top 1 
	S1.Code, 
	cast(1 as Bit) as ProgressiveF,
	Max((Case When @p_TSI=0 then (Case When S1.IncludeF=1 Then S1.SI else 0 end) else @P_TSI end)) as SI, 
	sum(Case       
	When S1.Unit='F' then Case When (Case When @p_TSI=0 then (Case When S1.IncludeF=1 Then S1.SI else 0 end) else @P_TSI end)<>0 Then S1.Rate/
	(Case When @p_TSI=0 then (Case When S1.IncludeF=1 Then S1.SI else 0 end) else @P_TSI end)*100 else 0 end
	When S1.Unit='M' then 
		Case When (Case When @p_TSI=0 then (Case When S1.IncludeF=1 Then S1.SI else 0 end) else @P_TSI end)>=S1.Upper Then S1.Upper-S1.Lower Else (Case When @p_TSI=0 then (Case When S1.IncludeF=1 Then S1.SI else 0 end) else @P_TSI end)-S1.Lower end*S1.Rate/10/(Case When @p_TSI=0 then (Case When S1.IncludeF=1 Then S1.SI else 0 end) else @P_TSI end)
	else 
	    Case When (Case When @p_TSI=0 then (Case When S1.IncludeF=1 Then S1.SI else 0 end) else @P_TSI end)>=S1.Upper Then S1.Upper-S1.Lower Else (Case When @p_TSI=0 then (Case When S1.IncludeF=1 Then S1.SI else 0 end) else @P_TSI end)-S1.Lower end*S1.Rate/(Case When @p_TSI=0 then (Case When S1.IncludeF=1 Then S1.SI else 0 end) else @P_TSI end) end 
	) as Rate,
	Max(S1.Unit) as Unit, Max(S1.Category) as Category, Max(S1.Portion) as Portion, 
	Max(S1.TOI) as TOI, 
	cast(Max(Cast(S1.NOTDECRF as Int)) as Bit) as NOTDECRF, 
	Max(S1.RateBasedID) as RateBasedID, 
	Max(TOI.Description) as TOIDesc, 
	cast(Max(Cast(TOI.Adjustable as Int)) as Bit) as Adjustable, 
	Max(RateTab.Description) as RateDesc,
	Max(S1.Upper) as Upper
	from 
	RateTab, 
	TOI, 
	Scheme_Additional S1, 
	Scheme_Class S2 
	Where 
	RateTab.Code=S1.Code 
	and TOI.TOI=S1.TOI 
	and (S1.Coverage='' or S1.Coverage=@P_Coverage) 
	and S1.Interest=@p_Interest 
	and ((Case When @p_TSI=0 then (Case When S1.IncludeF=1 Then S1.SI else 0 end) else @P_TSI end) Between S1.Lower and S1.Upper or (Case When @p_TSI=0 then (Case When S1.IncludeF=1 Then S1.SI else 0 end) else @P_TSI end)>=S1.Upper)
	and (S1.NOfYearsL<=@p_NOfYears or S1.NOfYearsL=0) 
	and (S1.NOfYearsU>=@p_NOfYears or S1.NOfYearsU=0) 
	and S2.ClassNo=S1.ClassNo 
	and S2.SchemeNo=@p_SchemeNO 
	and @p_Description Like S2.Description 
	and S2.Priority=coalesce((Select Top 1 S3.Priority from Scheme_Class S3 Where S3.SchemeNo=@P_SchemeNo and @P_Description like S3.Description Order By S3.Priority Desc),0) 
	and S1.ProgressiveF=1 and (Case When @p_TSI=0 then (Case When S1.IncludeF=1 Then S1.SI else 0 end) else @P_TSI end)<>0
	Group BY S1.Code
) R

GO

DROP Function Payor_Discount
GO
CREATE Function Payor_Discount(@P_ANO as int,@P_Code as varchar(10),@P_Period as int=0)          
RETURNS @DISCOUNT TABLE (GDISCOUNT Float, PDISCOUNT Float, DISCOUNT Float)  
AS          
BEGIN          
 Declare @PDiscount Float          
 Declare @GDiscount Float      
 Declare @NDiscount Float
 Declare @SLoading Float    
 Declare @TDiscount Float          
 Declare @RegNo varchar(20)    
 Declare @AStatus varchar(1)    
 Declare @LANO int
 Declare @OANO int
 Declare @DiscAmount Float
 Declare @Gross Float

Select @TDiscount=Null
Select @PDiscount=Null
Select @GDiscount=0
Select @NDiscount=0
Select @SLoading=0
Select @DiscAmount=0
                 
Select @RegNo=RegNo, @AStatus=AStatus, @LANO=LANO, @OANO=OANO, @Gross=PCalc.Gross from Acceptance, PCalc Where Pcalc.ANO=Acceptance.ANO and Acceptance.ANO=@P_ANO    

if @LANO=-1
BEGIN
         Select @DiscAmount=Payor.DiscAmount, @PDiscount=Payor.Discount, @GDiscount=Payor.GDiscount, @NDiscount=Payor.NDiscount, @SLoading=Payor.SLoading, @TDiscount=PayorDet.Discount
         from Acceptance 
         Left Join Payor on (Payor.ANO=Acceptance.ANO)
         Left Join PayorDet on (PayorDet.ANO=Payor.ANO and PayorDet.Code=@P_Code and (PayorDet.Period=0 or PayorDet.Period=@P_Period))               
         Where Acceptance.ANO=@P_ANO  
 END
ELSE
BEGIN 
         -- Payor Discount from Alternate Discount          
        Select @DiscAmount=APayor.DiscAmount, @PDiscount=APayor.Discount from APayor Where ANO=@P_ANO          
        if @PDiscount is null          
        BEGIN           
             if @RegNo='' or @AStatus in ('W','T')   
             Begin       
               Select @DiscAmount=coalesce(PayorDet.DiscAmount, Payor.DiscAmount), @PDiscount=Payor.Discount, @GDiscount=Payor.GDiscount, @NDiscount=Payor.NDiscount, @SLoading=Payor.SLoading, @TDiscount=PayorDet.Discount
               from Acceptance 
               Inner Join Acceptance mAcceptance on (mAcceptance.ANO=mAcceptance.LANO and mAcceptance.ANO=Acceptance.LANO)
               Left Join Payor on (Payor.ANO=mAcceptance.ANO)
               Left Join PayorDet on (PayorDet.ANO=Payor.ANO and PayorDet.Code=@P_Code and (PayorDet.Period=0 or PayorDet.Period=@P_Period))           
               Where Acceptance.ANO=@P_ANO 
           end    
           else    
           Begin    
               Select @DiscAmount=coalesce(PayorDet.DiscAmount, Payor.DiscAmount), @PDiscount=Payor.Discount, @GDiscount=Payor.GDiscount, @NDiscount=Payor.NDiscount, @SLoading=Payor.SLoading, @TDiscount=PayorDet.Discount
               from Acceptance 
               Inner Join Acceptance mAcceptance on (mAcceptance.ANO=mAcceptance.LANO and ((mAcceptance.RegNo<>'' and mAcceptance.RegNo=Acceptance.RegNo)))
               Left Join Payor on (Payor.ANO=mAcceptance.ANO)
               Left Join PayorDet on (PayorDet.ANO=Payor.ANO and PayorDet.Code=@P_Code and (PayorDet.Period=0 or PayorDet.Period=@P_Period))           
               Where Acceptance.ANO=@P_ANO 
           end    
        End          
        Else          
        BEGIN          
             Select @DiscAmount=PayorDet.DiscAmount, @TDiscount=PayorDet.Discount from APayorDet PayorDet Where PayorDet.ANO=@P_ANO and PayorDet.Code=@P_Code and (PayorDet.Period=0 or PayorDet.Period=@P_Period)          
        End          
 END
                        
 if @TDiscount is not null          
		Select @PDiscount=@TDiscount          

 if @PDiscount=0 and @DiscAmount<>0
	Select @PDiscount=@DiscAmount / (@Gross * (1 - @GDiscount / 100) * (1 - @NDiscount / 100)) * 100

 insert into @Discount(GDiscount, PDiscount, Discount) Select @GDiscount, @PDiscount, (1 - (1 - @GDiscount / 100) * (1 - @NDiscount / 100) * (1 - @PDiscount / 100) * (1 + @SLoading / 100))*100
Return  
End          


   


GO

DROP PROCEDURE View07 
GO
CREATE PROCEDURE View07 (@p_ANo as integer)                
AS                
SELECT AccAss.ID, Profile.Name, AccAss.Type, AccAss.Posted, AccAss.Admno, AccAss.Currency, Acceptance.RegNo, Accass.DocNo, AccAss.RefNo,      
Case When AccAss.CAmount=0 and Coalesce(pAcceptance.Branch,'')<>'' Then pAcceptance.Branch Else Acceptance.Branch end Branch,   
dbo.fn_Get_UWYear(Acceptance.SDate, Acceptance.EDate, Case When (Case When isnull(APayor.ANO,0)=0 Then (Case When isnull(MPayor.ANO,0)=0 Then Payor.PolicyYearF else MPayor.PolicyYearF end) else APayor.PolicyYearF end)=1 Then AccAss.SDate else Acceptance.SDate end) as PolicyYear,
sum(                
 case                
  when (accass.type in ('IR','IT','IX') and accass.code in ('P','U','F')) or (accass.type in ('DI','IC') and accass.code in ('P','U')) or (AccAss.Type not in ('DI','IC','IR','IT','IX') and AccAss.Code='P') then accass.Amount                
  else 0                
 end                
) AS Premium,                 
sum(                
 case                 
  when accass.code='C' then accass.Amount                
  else 0                
 end                
) AS Commision,                 
sum(                
 case                 
  when accass.Type not in ('IR','IT','IX') and accass.code='F' then accass.Amount                
  else 0                
 end                
) AS Fee,                 
sum(                
 case                 
  when accass.code='D' then accass.Amount                
  else 0                
 end                
) AS Duty,                 
sum(                
 case                 
  when accass.code='O' then accass.Amount                
  else 0                
 end                
) AS Discount,                 
sum(                
 case                
  when accass.code='I' then accass.Amount                
  else 0                
 end                
) AS OtherIncome,               
sum(                
 case                
  when accass.type in ('IR','IT','IX') and accass.code='F' then -accass.Amount
  when accass.Type in ('DI','IC') and accass.code='U' then -accass.Amount        
  when accass.Type Not in ('DI','IC') and accass.code='U' then accass.Amount        
  else 0                
 End                
) AS Ujroh,              
sum(                
 case                
  when (accass.type in ('IR','IT','IX') and accass.code in ('P','U'))  or (accass.type in ('DI','IC') and accass.code in ('P')) or (AccAss.Type not in ('DI','IC','IR','IT','IX') and AccAss.Code in ('P','U')) then accass.Amount                
  else 0                
 end                
) AS Tabarru,         
sum(                
 case                
  when (accass.code in ('J')) then accass.Amount                
  else 0                
 end                
) AS Deposit,          
sum(Case When coalesce((Admlink.Amount-Admlink.Amount_11-Admlink.Amount_12-Admlink.Amount_13-Admlink.Amount_14),0)<>0 then Admlink.Amount_11*AccAss.amount/(Admlink.Amount-Admlink.Amount_11-Admlink.Amount_12-Admlink.Amount_13-Admlink.Amount_14) else 0 end)
as Rounding,        
sum(Case When coalesce((Admlink.Amount-Admlink.Amount_11-Admlink.Amount_12-Admlink.Amount_13-Admlink.Amount_14),0)<>0 then Admlink.Amount_13*AccAss.amount/(Admlink.Amount-Admlink.Amount_11-Admlink.Amount_12-Admlink.Amount_13-Admlink.Amount_14) else 0 end)
as VAT,        
sum(Case When coalesce((Admlink.Amount-Admlink.Amount_11-Admlink.Amount_12-Admlink.Amount_13-Admlink.Amount_14),0)<>0 then Admlink.Amount_14*AccAss.amount/(Admlink.Amount-Admlink.Amount_11-Admlink.Amount_12-Admlink.Amount_13-Admlink.Amount_14) else 0 end)
as TAX    
FROM AccAss 
Inner Join Acceptance on (Acceptance.ANO=AccAss.ANO)
Left Join APayor on (APayor.ANO=Acceptance.ANO and Acceptance.LANO<>-1 and Acceptance.ANO<>Acceptance.LANO)                              
Left Join Payor on (Payor.ANO=Acceptance.ANO and Acceptance.LANO=-1)              
Left Join Acceptance pAcceptance on (pAcceptance.ANO=Acceptance.pANO)
Left Join Admlink on (Admlink.AdmNo=AccAss.AdmNo)
Inner Join Profile on (Profile.ID=AccAss.ID)
Left Join Acceptance mAcceptance on (((Acceptance.RegNo<>'' and Acceptance.RegNo=mAcceptance.RegNo) or (Acceptance.RegNo='' and Acceptance.LANO=MAcceptance.ANO)) and MAcceptance.ANO=MAcceptance.LANO and MAcceptance.CNO=Acceptance.CNO)
Left Join Payor MPayor on (MPayor.ANO=mAcceptance.ANO)      
WHERE Acceptance.ANO=@P_ANO        
GROUP BY AccAss.ID, Profile.Name, AccAss.Type, AccAss.Posted, AccAss.Admno, AccAss.Currency, Acceptance.RegNo, Accass.DocNo, AccAss.RefNo,      
Case When AccAss.CAmount=0 and Coalesce(pAcceptance.Branch,'')<>'' Then pAcceptance.Branch Else Acceptance.Branch end,   
dbo.fn_Get_UWYear(Acceptance.SDate, Acceptance.EDate, Case When (Case When isnull(APayor.ANO,0)=0 Then (Case When isnull(MPayor.ANO,0)=0 Then Payor.PolicyYearF else MPayor.PolicyYearF end) else APayor.PolicyYearF end)=1 Then AccAss.SDate else Acceptance.SDate end) 

GO


DROP PROCEDURE View07A 
GO
CREATE PROCEDURE View07A (@p_ANo as integer)              
AS              
SELECT AccAss.ID, Profile.Name, AccAss.Type, AccAss.Posted, AccAss.Admno, AccAss.Currency, Acceptance.RegNo, Accass.DocNo, AccAss.RefNo,      
Case When AccAss.CAmount=0 and Coalesce(pAcceptance.Branch,'')<>'' Then pAcceptance.Branch Else Acceptance.Branch end Branch,   
dbo.fn_Get_UWYear(MAcceptance.SDate, MAcceptance.EDate, Case When (Case When isnull(APayor.ANO,0)=0 Then (Case When isnull(MPayor.ANO,0)=0 Then Payor.PolicyYearF else MPayor.PolicyYearF end) else APayor.PolicyYearF end)=1 Then AccAss.SDate else Acceptance.SDate end) as PolicyYear,
(Case When isnull(APayor.ANO,0)=0 Then (Case When isnull(MPayor.ANO,0)=0 Then Payor.Grace else MPayor.Grace end) else APayor.Grace end) as Grace,
sum(                
 case                
  when (accass.type in ('IR','IT','IX') and accass.code in ('P','U','F')) or (accass.type in ('DI','IC') and accass.code in ('P','U')) or (AccAss.Type not in ('DI','IC','IR','IT','IX') and AccAss.Code='P') then accass.Amount                
  else 0                
 end                
) AS Premium,                 
sum(                
 case                 
  when accass.code='C' then accass.Amount                
  else 0                
 end                
) AS Commision,                 
sum(                
 case                 
  when accass.Type not in ('IR','IT','IX') and accass.code='F' then accass.Amount                
  else 0                
 end                
) AS Fee,                 
sum(                
 case                 
  when accass.code='D' then accass.Amount                
  else 0                
 end                
) AS Duty,                 
sum(                
 case                 
  when accass.code='O' then accass.Amount                
  else 0                
 end                
) AS Discount,                 
sum(                
 case                
  when accass.code='I' then accass.Amount                
  else 0                
 end                
) AS OtherIncome,               
sum(                
 case                
  when accass.type in ('IR','IT','IX') and accass.code='F' then -accass.Amount
  when accass.Type in ('DI','IC') and accass.code='U' then -accass.Amount        
  when accass.Type Not in ('DI','IC') and accass.code='U' then accass.Amount        
  else 0                
 End                
) AS Ujroh,              
sum(                
 case                
  when (accass.type in ('IR','IT','IX') and accass.code in ('P','U'))  or (accass.type in ('DI','IC') and accass.code in ('P')) or (AccAss.Type not in ('DI','IC','IR','IT','IX') and AccAss.Code in ('P','U')) then accass.Amount                
  else 0                
 end                
) AS Tabarru,         
sum(                
 case                
  when (accass.code in ('J')) then accass.Amount                
  else 0                
 end                
) AS Deposit,          
sum(Case When coalesce((Admlink.Amount-Admlink.Amount_11-Admlink.Amount_12-Admlink.Amount_13-Admlink.Amount_14),0)<>0 then Admlink.Amount_11*AccAss.amount/(Admlink.Amount-Admlink.Amount_11-Admlink.Amount_12-Admlink.Amount_13-Admlink.Amount_14) else 0 end)
as Rounding,        
sum(Case When coalesce((Admlink.Amount-Admlink.Amount_11-Admlink.Amount_12-Admlink.Amount_13-Admlink.Amount_14),0)<>0 then Admlink.Amount_13*AccAss.amount/(Admlink.Amount-Admlink.Amount_11-Admlink.Amount_12-Admlink.Amount_13-Admlink.Amount_14) else 0 end)
as VAT,        
sum(Case When coalesce((Admlink.Amount-Admlink.Amount_11-Admlink.Amount_12-Admlink.Amount_13-Admlink.Amount_14),0)<>0 then Admlink.Amount_14*AccAss.amount/(Admlink.Amount-Admlink.Amount_11-Admlink.Amount_12-Admlink.Amount_13-Admlink.Amount_14) else 0 end)
as TAX    
FROM AccAss 
Inner Join Acceptance on (Acceptance.ANO=AccAss.ANO)
Left Join APayor on (APayor.ANO=Acceptance.ANO and Acceptance.LANO<>-1 and Acceptance.ANO<>Acceptance.LANO)                              
Left Join Payor on (Payor.ANO=Acceptance.ANO and Acceptance.LANO=-1)              
Left Join Acceptance pAcceptance on (pAcceptance.ANO=Acceptance.pANO)
Left Join Admlink on (Admlink.AdmNo=AccAss.AdmNo)
Inner Join Profile on (Profile.ID=AccAss.ID)
Inner Join Acceptance mAcceptance on (((Acceptance.RegNo<>'' and Acceptance.RegNo=mAcceptance.RegNo) or (Acceptance.RegNo='' and Acceptance.LANO=MAcceptance.ANO)) and MAcceptance.ANO=MAcceptance.LANO and MAcceptance.CNO=Acceptance.CNO)
Left Join Payor MPayor on (MPayor.ANO=mAcceptance.ANO)      
WHERE MAcceptance.ANO=@P_ANO        
GROUP BY AccAss.ID, Profile.Name, AccAss.Type, AccAss.Posted, AccAss.Admno, AccAss.Currency, Acceptance.RegNo, Accass.DocNo, AccAss.RefNo,      
Case When AccAss.CAmount=0 and Coalesce(pAcceptance.Branch,'')<>'' Then pAcceptance.Branch Else Acceptance.Branch end,   
dbo.fn_Get_UWYear(MAcceptance.SDate, MAcceptance.EDate, Case When (Case When isnull(APayor.ANO,0)=0 Then (Case When isnull(MPayor.ANO,0)=0 Then Payor.PolicyYearF else MPayor.PolicyYearF end) else APayor.PolicyYearF end)=1 Then AccAss.SDate else Acceptance.SDate end),
(Case When isnull(APayor.ANO,0)=0 Then (Case When isnull(MPayor.ANO,0)=0 Then Payor.Grace else MPayor.Grace end) else APayor.Grace end)


GO
DROP Procedure QRCESSIONDET
GO
CREATE Procedure QRCESSIONDET (@P_ANO integer,@P_RID varchar(255), @P_ID varchar(255), @P_CCY varchar(255), @P_SDate DateTime, @P_EDate DateTime, @P_Code varchar(10), @P_AdjustableF bit,@P_TSI as Float=0, @P_ASDate as DateTime=0)              
AS          
Declare @Premium_Treaty_Discount as Float          
Declare @Premium_Discount as Float          
Declare @Premium_Commission as Float          
Declare @Premium_OutGo as Float          
Declare @P_TOC as varchar(10)  
Declare @P_AType as varchar(1)  
Declare @P_ONGROSSNet as int  
Declare @P_RateConF as Bit  
Declare @P_NETRATE as Float  
Declare @P_NETRATEDet as Float  
Declare @P_NOFYEARS as Int  
Declare @P_COMM as Float  
Declare @P_COMMN as Float  
Declare @P_COMMI as Float  
Declare @P_OnMinPremiumF as Bit  
Declare @P_PPCT as Float  
Declare @P_OnNetPremiumF as Bit  
Declare @P_RNO as int  
Declare @P_RType as varchar(10)  
Declare @P_OPFEE as Float  
Declare @P_OPFEEPCT as Float  
Declare @P_FEE as Float  
Declare @P_OANO as int  
Declare @P_COMMPOLICYF as Bit  
Declare @P_PFactor as Float

Select   
@P_ASDate=Case When @P_ASDate=0 Then A.SDate else @P_ASDate end,  
@P_NOFYEARS=datediff(year,A.sdate, A.edate),   
@P_TOC=C.TOC,   
@P_AType=A.AType,   
@P_ONGROSSNET=R.ONGROSSNET,   
@P_RateConF=R3.RateConF,   
@P_NETRATE=R2.NETRATE,  
@P_NETRATEDet=R4.NETRATE,  
@P_COMM=CASE WHEN R3.COMM<>0 Then R3.COMM ELSE R2.COMM END,  
@P_COMMN=CASE WHEN R3.COMMN<>0 Then R3.COMMN ELSE R2.COMMN END,  
@P_COMMI=R2.COMMI,  
@P_OnMinPremiumF=R2.OnMinPremiumF,  
@P_PPCT=R2.PPCT,  
@P_OnNetPremiumF=R2.OnNetPremiumF,   
@P_RNO=R1.RNO,  
@P_RType=R1.RType,  
@P_OANO=A.OANO,  
@P_FEE=R2.FEE,  
@P_COMMPOLICYF=R2.COMMPOLICYF,
@P_PFactor=Case When C.ISType='R' Then (100-I.UJrohCedant)/100*(100+I.UjrohReins)/100 else 1 end  
from Acceptance A, RarrHeader R, Cover C Left Join ISource I on (I.CNO=C.CNO), Reinsurance R1, RPart R2, ReClass R3 Left Join ReClassDet R4 ON (R4.RNO=R3.RNO AND R4.TOC=R3.TOC AND R4.CODE=@P_CODE)  
Where C.CNO=A.CNO and R.ANO=A.ANO and A.ANO=@P_ANO and R1.RID=@P_RID and R2.RNO=R1.RNO and R3.RNO=R1.RNO and R2.ID=@P_ID and R3.TOC=C.TOC  

Select @Premium_Treaty_Discount=dbo.Premium_Treaty_Discount(@P_ANO, @P_Code,cast(datediff(Month,@P_ASDate, @P_SDate) as integer) / 12 + 1)          
Select @Premium_Discount=dbo.premium_discount(@P_ANO, @P_Code, cast(datediff(Month,@P_ASDate, @P_SDate) as integer) / 12 + 1)  
Select @Premium_Commission=dbo.Premium_Commission(@P_ANO, @P_Code, cast(datediff(Month,@P_ASDate, @P_SDate) as integer) / 12 + 1,0)+dbo.Premium_Commission_Vat(@P_ANO, @P_Code, cast(datediff(Month,@P_ASDate, @P_SDate) as integer) / 12 + 1,0)  
Select @Premium_outGo=@Premium_Discount+@Premium_Commission  

Select 
@P_OPFEE=coalesce(Sum(Case When A1.ContributionF=1 Then A1.Amount*100/coalesce(I.Share,100) else 0 end),0),
@P_OPFEEPCT=coalesce(Sum(Case When A1.ContributionF=0 Then A1.Amount*100/coalesce(I.Share,100) else 0 end)/Max(PCalc.Gross)*100,0)
from AccFD A1 
INNER JOIN FDTAB on (FDTAB.FDID=A1.FDID)
INNER Join PCalc on (PCalc.ANO=A1.ANO and PCalc.Currency=A1.Currency)
, Acceptance A2 Left Join ISource I on (I.CNO=A2.CNO) 
Where @P_RType in ('Q','S1','S2','S3') and FDTAB.FDType='O' and A1.Currency=@P_CCY and A1.ANO=A2.ANO and A2.OANO=@P_OANO and A2.ANO<=@P_ANO  

--Apply OP FEE for ONR
Select @Premium_outGo=@Premium_outGo+@P_OPFEEPCT

Select @P_COMM=CASE WHEN @P_COMMPOLICYF=1 and @P_COMM=0 and @P_COMMN=0 Then @Premium_Commission ELSE @P_COMM END  
 
Select              
sum(Case When OnMinPremiumF=0 Then (case When Gross_1>Gross_2 then Gross_1 else Gross_2 end) else (case When Gross_1<Gross_2 and Gross_1<>0 then Gross_1 else Gross_2 end) end) as Premium,              
sum(Case When OnMinPremiumF=0 Then (case When Gross_1>Gross_2 then Comm_1 else Comm_2 end) else (case When Gross_1<Gross_2 and Gross_1<>0 then Comm_1 else Comm_2 end) end) as Commission,              
sum(Case When OnMinPremiumF=0 Then (case When Gross_1>Gross_2 then Disc_1 else Disc_2 end) else (case When Gross_1<Gross_2 and Gross_1<>0 then Disc_1 else Disc_2 end) end) as Discount,  
sum(Case When OnMinPremiumF=0 Then (case When Gross_1>Gross_2 then Fee_1 else Fee_2 end) else (case When Gross_1<Gross_2 and Gross_1<>0 then Fee_1 else Fee_2 end) end) as Fee              
From          
(select              
Cast(@P_OnMinPremiumF as integer) as OnMinPremiumF,              
coalesce(SUM((CASE WHEN @P_PPCT<>0 THEN @P_PPCT/100 ELSE (Case When @P_RateConF=1 and (RRateCon.Rate is not null or RateCon.Rate is not null) then 0 else 1 end) END * ICALC.GROSS*(PCALC.PGROSS*@P_PFactor)/PCALC.POGROSS*(Case When @P_OnNetPremiumF=1 Then (100-@Premium_Treaty_Discount)/100 else 1 end)-(ICALC.GROSS*@P_OPFEE/PCALC.POGROSS))*(Case When @P_COMMN=0 Then @P_COMM/100 else (Case When RCover.NetRateF=1 or @P_ONGROSSNET=2 OR (@P_ONGROSSNET=0 AND (100-@Premium_OutGo)/100*(100-@P_COMMN)/100<(100-@P_COMM)/100) Then (100-@Premium_OutGo)/100*(@P_COMMN)/100 else @P_COMM/100 end) end)),0) AS COMM_1,              
coalesce(SUM((Case When @P_RateConF=1 Then (Case When RRateCon.Rate is null then RateCon.Rate*(Case When RateCon.Loading<>0 then RateCon.Loading/100 else RCover.Loading end) else RRateCon.Rate/PCalc.RiskNum*(Case When RRateCon.Loading<>0 then RRateCon.Loading/100 else RCover.Loading end) end) Else coalesce(@P_NETRATEDet,@P_NETRATE/PCalc.RiskNum) end/100*(100-RCover.Discount)/100*ICALC.GROSS/PCALC.GROSS*ICALC.PRORATA *ICALC.TSI*(CASE WHEN RCOVER.PCALC='S' OR RCOVER.PCTLOSS=0 THEN 100 ELSE RCOVER.PCTLOSS END)/(CASE WHEN RCOVER.PCTLOSS=0 THEN 100 ELSE RCOVER.PCTLOSS END+RCOVER.PAddition)*ICALC.PCTADJ/100-(ICALC.GROSS*@P_OPFEE/PCALC.POGROSS))*(Case When @P_COMMN=0 Then @P_COMM/100 else (Case When RCover.NetRateF=1 or @P_ONGROSSNET=2 OR (@P_ONGROSSNET=0 AND (100-@Premium_OutGo)/100*(100-@P_COMMN)/100<(100-@P_COMM)/100) Then (100-@Premium_OutGo)/100*(@P_COMMN)/100 else @P_COMM/100 end) end)),0) AS COMM_2,              

coalesce(SUM((CASE WHEN @P_PPCT<>0 THEN @P_PPCT/100 ELSE (Case When @P_RateConF=1 and (RRateCon.Rate is not null or RateCon.Rate is not null) then 0 else 1 end) END * ICALC.GROSS*(PCALC.PGROSS*@P_PFactor)/PCALC.POGROSS*(Case When @P_OnNetPremiumF=1 Then (100-@Premium_Treaty_Discount)/100 else 1 end))*(Case When @P_COMMN=0 Then 1 else (Case When RCover.NetRateF=1 or @P_ONGROSSNET=2 OR (@P_ONGROSSNET=0 AND (100-@Premium_OutGo)/100*(100-@P_COMMN)/100<(100-@P_COMM)/100) Then 1 else 1 end) end)),0) AS GROSS_1,            
coalesce(SUM((Case When @P_RateConF=1 Then (Case When RRateCon.Rate is null then RateCon.Rate*(Case When RateCon.Loading<>0 then RateCon.Loading/100 else RCover.Loading end) else RRateCon.Rate/PCalc.RiskNum*(Case When RRateCon.Loading<>0 then RRateCon.Loading/100 else RCover.Loading end) end) Else coalesce(@P_NETRATEDet,@P_NETRATE/PCalc.RiskNum) end/100*(100-RCover.Discount)/100*ICALC.GROSS/PCALC.GROSS*ICALC.PRORATA *ICALC.TSI*(CASE WHEN RCOVER.PCALC='S' OR RCOVER.PCTLOSS=0 THEN 100 ELSE RCOVER.PCTLOSS END)/(CASE WHEN RCOVER.PCTLOSS=0 THEN 100 ELSE RCOVER.PCTLOSS END+RCOVER.PAddition)*ICALC.PCTADJ/100)*(Case When @P_COMMN=0 Then 1 else (Case When RCover.NetRateF=1 or @P_ONGROSSNET=2 OR (@P_ONGROSSNET=0 AND (100-@Premium_OutGo)/100*(100-@P_COMMN)/100<(100-@P_COMM)/100) Then 1 else 1 end) end)),0) AS GROSS_2,              
             
coalesce(SUM((CASE WHEN @P_PPCT<>0 THEN @P_PPCT/100 ELSE (Case When @P_RateConF=1 and (RRateCon.Rate is not null or RateCon.Rate is not null) then 0 else 1 end) END * ICALC.GROSS*(PCALC.PGROSS*@P_PFactor)/PCALC.POGROSS*(Case When @P_OnNetPremiumF=1 Then (100-@Premium_Treaty_Discount)/100 else 1 end)-(ICALC.GROSS*@P_OPFEE/PCALC.POGROSS))*(Case When @P_COMMN=0 Then 0 else (Case When RCover.NetRateF=1 or @P_ONGROSSNET=2 OR (@P_ONGROSSNET=0 AND (100-@Premium_OutGo)/100*(100-@P_COMMN)/100<(100-@P_COMM)/100) Then (@Premium_OutGo)/100 else 0 end) end)),0) AS DISC_1,              
coalesce(SUM((Case When @P_RateConF=1 Then (Case When RRateCon.Rate is null then RateCon.Rate*(Case When RateCon.Loading<>0 then RateCon.Loading/100 else RCover.Loading end) else RRateCon.Rate/PCalc.RiskNum*(Case When RRateCon.Loading<>0 then RRateCon.Loading/100 else RCover.Loading end) end) Else coalesce(@P_NETRATEDet,@P_NETRATE/PCalc.RiskNum) end/100*(100-RCover.Discount)/100*ICALC.GROSS/PCALC.GROSS*ICALC.PRORATA *ICALC.TSI*(CASE WHEN RCOVER.PCALC='S' OR RCOVER.PCTLOSS=0 THEN 100 ELSE RCOVER.PCTLOSS END)/(CASE WHEN RCOVER.PCTLOSS=0 THEN 100 ELSE RCOVER.PCTLOSS END+RCOVER.PAddition)*ICALC.PCTADJ/100)*(Case When @P_COMMN=0 Then 0 else (Case When RCover.NetRateF=1 or @P_ONGROSSNET=2 OR (@P_ONGROSSNET=0 AND (100-@Premium_OutGo)/100*(100-@P_COMMN)/100<(100-@P_COMM)/100) Then (@Premium_OutGo)/100 else 0 end) end)),0) AS DISC_2,  

coalesce(SUM((CASE WHEN @P_PPCT<>0 THEN @P_PPCT/100 ELSE (Case When @P_RateConF=1 and (RRateCon.Rate is not null or RateCon.Rate is not null) then 0 else 1 end) END * ICALC.GROSS*(PCALC.PGROSS*@P_PFactor)/PCALC.POGROSS*(Case When @P_OnNetPremiumF=1 Then (100-@Premium_Treaty_Discount)/100 else 1 end))*(Case When @P_COMMN=0 Then 1 else (Case When RCover.NetRateF=1 or @P_ONGROSSNET=2 OR (@P_ONGROSSNET=0 AND (100-@Premium_OutGo)/100*(100-@P_COMMN)/100<(100-@P_COMM)/100) Then 1 else 1 end) end)*@P_FEE/100-(ICALC.GROSS*@P_OPFEE/PCALC.POGROSS)),0) AS FEE_1,              
coalesce(SUM((Case When @P_RateConF=1 Then (Case When RRateCon.Rate is null then RateCon.Rate*(Case When RateCon.Loading<>0 then RateCon.Loading/100 else RCover.Loading end) else RRateCon.Rate/PCalc.RiskNum*(Case When RRateCon.Loading<>0 then RRateCon.Loading/100 else RCover.Loading end) end) Else coalesce(@P_NETRATEDet,@P_NETRATE/PCalc.RiskNum) end/100*(100-RCover.Discount)/100*ICALC.GROSS/PCALC.GROSS*ICALC.PRORATA *ICALC.TSI*(CASE WHEN RCOVER.PCALC='S' OR RCOVER.PCTLOSS=0 THEN 100 ELSE RCOVER.PCTLOSS END)/(CASE WHEN RCOVER.PCTLOSS=0 THEN 100 ELSE RCOVER.PCTLOSS END+RCOVER.PAddition)*ICALC.PCTADJ/100)*(Case When @P_COMMN=0 Then 1 else (Case When RCover.NetRateF=1 or @P_ONGROSSNET=2 OR (@P_ONGROSSNET=0 AND (100-@Premium_OutGo)/100*(100-@P_COMMN)/100<(100-@P_COMM)/100) Then 1 else 1 end) end)*@P_FEE/100-(ICALC.GROSS*@P_OPFEE/PCALC.POGROSS)),0) AS FEE_2  
              
FROM ICALC   
INNER JOIN ACCEPTANCE SACCEPTANCE ON (SACCEPTANCE.ANO=ICALC.SANO)  
INNER JOIN RCOVER ON (RCOVER.ANO=ICALC.SANO AND RCOVER.CODE=ICALC.CODE AND (RCOVER.SDATE=ICALC.SDATE OR (@P_AType='A' AND (CASE WHEN RCOVER.SDATE<SACCEPTANCE.PDATE THEN SACCEPTANCE.PDATE ELSE RCOVER.SDATE END)=ICALC.SDATE)))  
LEFT JOIN RPARTDET ON (RPARTDET.RNO=@P_RNO AND RPARTDET.ID=@P_ID AND RPARTDET.TOR=ICALC.TOR)  
LEFT Join FN_RateCon(@P_ANO, @P_CODE,@P_TSI) RateCon On (RateCon.Code=ICalc.Code)  
LEFT Join FN_RRateCon(@P_ANO, @P_RID, @P_TSI) RRateCon On (1=1)              
INNER JOIN ICOVER ON (ICOVER.INO=ICALC.INO AND (ICOVER.ADJUSTABLE=@P_ADJUSTABLEF OR @P_AType='A'))  
INNER JOIN RCALC ON (RCALC.ANO=ICALC.ANO AND RCALC.CURRENCY=ICALC.CURRENCY AND RCALC.CODE=ICALC.CODE AND RCALC.TOR=ICALC.TOR AND RCALC.SDATE=ICALC.SDATE AND RCALC.EDATE=ICALC.EDATE AND RCALC.SANO=ICALC.SANO AND RCALC.EXTREATYF=0)  
INNER JOIN PCALC_ANNUM(@P_ANO) PCALC ON (PCALC.ANO=ICALC.ANO AND PCALC.CODE=ICALC.CODE AND PCALC.SDATE=ICALC.SDATE AND PCALC.EDATE=ICALC.EDATE AND PCALC.INO=ICALC.INO AND PCALC.CURRENCY=ICALC.CURRENCY)  
WHERE ICALC.ANO=@P_ANO AND ICALC.CURRENCY=@P_CCY AND ICALC.SDATE=@P_SDATE AND ICALC.EDATE=@P_EDATE AND ICALC.CODE=@P_CODE              
AND RPARTDET.TOR IS NULL AND PCALC.GROSS<>0  

Union All              

select              

Cast(@P_OnMinPremiumF as integer) as OnMinPremiumF,              

coalesce(SUM((CASE WHEN RPARTDET.PPCT<>0 THEN RPARTDET.PPCT/100 ELSE (Case When @P_RateConF=1 and (RRateCon.Rate is not null or RateCon.Rate is not null) then 0 else 1 end) END * ICALC.GROSS*(PCALC.PGROSS*@P_PFactor)/PCALC.POGROSS-(ICALC.GROSS*@P_OPFEE/PCALC.POGROSS))*(Case When @P_OnNetPremiumF=1 Then (100-@Premium_Treaty_Discount)/100 else 1 end)*(Case When RPARTDET.COMMN=0 Then RPARTDET.COMM/100 else (Case When RCover.NetRateF=1 or @P_ONGROSSNET=2 OR (@P_ONGROSSNET=0 AND (100-@Premium_OutGo)/100*(100-RPARTDET.CommN)/100<(100-RPARTDET.COMM)/100) Then (100-@Premium_OutGo)/100*(RPARTDET.CommN)/100 else RPARTDET.COMM/100 end) end)),0) AS COMM_1,              
coalesce(SUM((Case When @P_RateConF=1 Then (Case When RRateCon.Rate is null then RateCon.Rate*(Case When RateCon.Loading<>0 then RateCon.Loading/100 else RCover.Loading end) else RRateCon.Rate/PCalc.RiskNum*(Case When RRateCon.Loading<>0 then RRateCon.Loading/100 else RCover.Loading end) end) Else coalesce(@P_NETRATEDet,RPARTDET.NETRate) end/100*(100-RCover.Discount)/100*ICALC.GROSS/PCALC.GROSS*ICALC.PRORATA *ICALC.TSI*(CASE WHEN RCOVER.PCALC='S' OR RCOVER.PCTLOSS=0 THEN 100 ELSE RCOVER.PCTLOSS END)/(CASE WHEN RCOVER.PCTLOSS=0 THEN 100 ELSE RCOVER.PCTLOSS END+RCOVER.PAddition)*ICALC.PCTADJ/100-(ICALC.GROSS*@P_OPFEE/PCALC.POGROSS))*(Case When RPARTDET.COMMN=0 Then RPARTDET.COMM/100 else (Case When RCover.NetRateF=1 or @P_ONGROSSNET=2 OR (@P_ONGROSSNET=0 AND (100-@Premium_OutGo)/100*(100-RPARTDET.CommN)/100<(100-RPARTDET.COMM)/100) Then (100-@Premium_OutGo)/100*(RPARTDET.CommN)/100 else RPARTDET.COMM/100 end) end)),0) AS COMM_2,                  
              
coalesce(SUM((CASE WHEN RPARTDET.PPCT<>0 THEN RPARTDET.PPCT/100 ELSE (Case When @P_RateConF=1 and (RRateCon.Rate is not null or RateCon.Rate is not null) then 0 else 1 end) END * ICALC.GROSS*(PCALC.PGROSS*@P_PFactor)/PCALC.POGROSS)*(Case When @P_OnNetPremiumF=1 Then (100-@Premium_Treaty_Discount)/100 else 1 end)*(Case When RPARTDET.COMMN=0 Then 1 else (Case When RCover.NetRateF=1 or @P_ONGROSSNET=2 OR (@P_ONGROSSNET=0 AND (100-@Premium_OutGo)/100*(100-RPARTDET.CommN)/100<(100-RPARTDET.COMM)/100) Then 1 else 1 end) end)),0) AS GROSS_1,              
coalesce(SUM((Case When @P_RateConF=1 Then (Case When RRateCon.Rate is null then RateCon.Rate*(Case When RateCon.Loading<>0 then RateCon.Loading/100 else RCover.Loading end) else RRateCon.Rate/PCalc.RiskNum*(Case When RRateCon.Loading<>0 then RRateCon.Loading/100 else RCover.Loading end) end) Else coalesce(@P_NETRATEDet,RPARTDET.NETRate) end/100*(100-RCover.Discount)/100*ICALC.GROSS/PCALC.GROSS*ICALC.PRORATA *ICALC.TSI*(CASE WHEN RCOVER.PCALC='S' OR RCOVER.PCTLOSS=0 THEN 100 ELSE RCOVER.PCTLOSS END)/(CASE WHEN RCOVER.PCTLOSS=0 THEN 100 ELSE RCOVER.PCTLOSS END+RCOVER.PAddition)*ICALC.PCTADJ/100)*(Case When RPARTDET.COMMN=0 Then 1 else (Case When RCover.NetRateF=1 or @P_ONGROSSNET=2 OR (@P_ONGROSSNET=0 AND (100-@Premium_OutGo)/100*(100-RPARTDET.CommN)/100<(100-RPARTDET.COMM)/100) Then 1 else 1 end) end)),0) AS GROSS_2,              

coalesce(SUM((CASE WHEN RPARTDET.PPCT<>0 THEN RPARTDET.PPCT/100 ELSE (Case When @P_RateConF=1 and (RRateCon.Rate is not null or RateCon.Rate is not null) then 0 else 1 end) END * ICALC.GROSS*(PCALC.PGROSS*@P_PFactor)/PCALC.POGROSS-(ICALC.GROSS*@P_OPFEE/PCALC.POGROSS))*(Case When @P_OnNetPremiumF=1 Then (100-@Premium_Treaty_Discount)/100 else 1 end)*(Case When RPARTDET.COMMN=0 Then 0 else (Case When RCover.NetRateF=1 or @P_ONGROSSNET=2 OR (@P_ONGROSSNET=0 AND (100-@Premium_OutGo)/100*(100-RPARTDET.CommN)/100<(100-RPARTDET.COMM)/100) Then (@Premium_OutGo)/100 else 0 end) end)),0) AS DISC_1,              
coalesce(SUM((Case When @P_RateConF=1 Then (Case When RRateCon.Rate is null then RateCon.Rate*(Case When RateCon.Loading<>0 then RateCon.Loading/100 else RCover.Loading end) else RRateCon.Rate/PCalc.RiskNum*(Case When RRateCon.Loading<>0 then RRateCon.Loading/100 else RCover.Loading end) end) Else coalesce(@P_NETRATEDet,RPARTDET.NETRate) end/100*(100-RCover.Discount)/100*ICALC.GROSS/PCALC.GROSS*ICALC.PRORATA *ICALC.TSI*(CASE WHEN RCOVER.PCALC='S' OR RCOVER.PCTLOSS=0 THEN 100 ELSE RCOVER.PCTLOSS END)/(CASE WHEN RCOVER.PCTLOSS=0 THEN 100 ELSE RCOVER.PCTLOSS END+RCOVER.PAddition)*ICALC.PCTADJ/100)*(Case When RPARTDET.COMMN=0 Then 0 else (Case When RCover.NetRateF=1 or @P_ONGROSSNET=2 OR (@P_ONGROSSNET=0 AND (100-@Premium_OutGo)/100*(100-RPARTDET.CommN)/100<(100-RPARTDET.COMM)/100) Then (@Premium_OutGo)/100 else 0 end) end)),0) AS DISC_2,  

coalesce(SUM((CASE WHEN RPARTDET.PPCT<>0 THEN RPARTDET.PPCT/100 ELSE (Case When @P_RateConF=1 and (RRateCon.Rate is not null or RateCon.Rate is not null) then 0 else 1 end) END * ICALC.GROSS*(PCALC.PGROSS*@P_PFactor)/PCALC.POGROSS)*(Case When @P_OnNetPremiumF=1 Then (100-@Premium_Treaty_Discount)/100 else 1 end)*(Case When RPARTDET.COMMN=0 Then 1 else (Case When RCover.NetRateF=1 or @P_ONGROSSNET=2 OR (@P_ONGROSSNET=0 AND (100-@Premium_OutGo)/100*(100-RPARTDET.CommN)/100<(100-RPARTDET.COMM)/100) Then 1 else 1 end) end)*@P_FEE/100-(ICALC.GROSS*@P_OPFEE/PCALC.POGROSS)),0) AS FEE_1,              
coalesce(SUM((Case When @P_RateConF=1 Then (Case When RRateCon.Rate is null then RateCon.Rate*(Case When RateCon.Loading<>0 then RateCon.Loading/100 else RCover.Loading end) else RRateCon.Rate/PCalc.RiskNum*(Case When RRateCon.Loading<>0 then RRateCon.Loading/100 else RCover.Loading end) end) Else coalesce(@P_NETRATEDet,RPARTDET.NETRate) end/100*(100-RCover.Discount)/100*ICALC.GROSS/PCALC.GROSS*ICALC.PRORATA *ICALC.TSI*(CASE WHEN RCOVER.PCALC='S' OR RCOVER.PCTLOSS=0 THEN 100 ELSE RCOVER.PCTLOSS END)/(CASE WHEN RCOVER.PCTLOSS=0 THEN 100 ELSE RCOVER.PCTLOSS END+RCOVER.PAddition)*ICALC.PCTADJ/100)*(Case When RPARTDET.COMMN=0 Then 1 else (Case When RCover.NetRateF=1 or @P_ONGROSSNET=2 OR (@P_ONGROSSNET=0 AND (100-@Premium_OutGo)/100*(100-RPARTDET.CommN)/100<(100-RPARTDET.COMM)/100) Then 1 else 1 end) end)*@P_FEE/100-(ICALC.GROSS*@P_OPFEE/PCALC.POGROSS)),0) AS FEE_2  
FROM ICALC   
INNER JOIN ACCEPTANCE SACCEPTANCE ON (SACCEPTANCE.ANO=ICALC.SANO)  
INNER JOIN RCOVER ON (RCOVER.ANO=ICALC.SANO AND RCOVER.CODE=ICALC.CODE AND (RCOVER.SDATE=ICALC.SDATE OR (@P_AType='A' AND (CASE WHEN RCOVER.SDATE<SACCEPTANCE.PDATE THEN SACCEPTANCE.PDATE ELSE RCOVER.SDATE END)=ICALC.SDATE)))  
INNER JOIN RPARTDET ON (RPARTDET.RNO=@P_RNO AND RPARTDET.ID=@P_ID AND RPARTDET.TOR=ICALC.TOR AND (RPARTDET.NOFYEARS=0 OR RPARTDET.NOFYEARS=@P_NOFYEARS) and RPARTDET.EXCLUDEF=0)  
LEFT Join FN_RateCon(@P_ANO, @P_CODE,@P_TSI) RateCon On (RateCon.Code=ICalc.Code)  
LEFT Join FN_RRateCon(@P_ANO, @P_RID, @P_TSI) RRateCon On (1=1)              
INNER JOIN ICOVER ON (ICOVER.INO=ICALC.INO AND (ICOVER.ADJUSTABLE=@P_ADJUSTABLEF OR @P_AType='A'))  
INNER JOIN RCALC ON (RCALC.ANO=ICALC.ANO AND RCALC.CURRENCY=ICALC.CURRENCY AND RCALC.CODE=ICALC.CODE AND RCALC.TOR=ICALC.TOR AND RCALC.SDATE=ICALC.SDATE AND RCALC.EDATE=ICALC.EDATE AND RCALC.SANO=ICALC.SANO AND RCALC.EXTREATYF=0)  
INNER JOIN PCALC_ANNUM(@P_ANO) PCALC ON (PCALC.ANO=ICALC.ANO AND PCALC.CODE=ICALC.CODE AND PCALC.SDATE=ICALC.SDATE AND PCALC.EDATE=ICALC.EDATE AND PCALC.INO=ICALC.INO AND PCALC.CURRENCY=ICALC.CURRENCY)  
WHERE ICALC.ANO=@P_ANO AND ICALC.CURRENCY=@P_CCY AND ICALC.SDATE=@P_SDATE AND ICALC.EDATE=@P_EDATE AND ICALC.CODE=@P_CODE              
AND PCALC.GROSS<>0  

) R        

GO

DROP PROCEDURE [dbo].[QCLACC_3]
GO
CREATE PROCEDURE [dbo].[QCLACC_3] (@P_POLICYNO AS VARCHAR(255), @P_CERTIFICATENO VARCHAR(255), @P_REFNO varchar(50)='', @P_TOC varchar(10)='')     
AS     
SELECT TOP 10 ACCEPTANCE.ANO, ACCEPTANCE.POLICYNO, ACCEPTANCE.CERTIFICATENO, ACCEPTANCE.AID, COVER.INSURED, COVER.ISTYPE, ACCEPTANCE.TOC, ACCEPTANCE.SDATE, ACCEPTANCE.EDATE, Cover.PHolder, ACCEPTANCE.BRANCH, ACCEPTANCE.ANAME, PROFILE.RESTRICTEDF, PROFILE.
NAME, ACCEPTANCE.PDATE, ACCEPTANCE.PPDATE, ACCEPTANCE.NCDATE,  ACCEPTANCE.EXTPERIOD,     
Case When GenDTab.Description is not null then ACCEPTANCE.ValueDesc else '' end as Description,     
Case When ISource.ID is null then ACCEPTANCE.AID else ISource.ID end as Payment,     
Case When ISource.ID is null then Profile.Name else PProfile.Name end as Payment_Name     
FROM ACCEPTANCE WITH (INDEX(I_Acceptance_PolicyNo_CertificateNo))  
Left Join GenDTab On (GenDTab.FLDID=ACCEPTANCE.FLDID AND GenDTab.ValueID=ACCEPTANCE.ValueID)  
Inner Join COVER on (Cover.CNO=Acceptance.CNO)  
Left Join ISource On (ISource.CNO=Cover.CNO)   
Left Join Profile PProfile On (PProfile.ID=ISource.ID)  
Left Join Profile on (Profile.ID=Acceptance.AID)  
WHERE ACCEPTANCE.ATYPE Not In ('A','C') AND ACCEPTANCE.AStatus not in ('W','T') and COVER.CStatus not in ('R','P','C')     
AND ACCEPTANCE.PDATE<ACCEPTANCE.PPDATE AND ACCEPTANCE.ANO<>ACCEPTANCE.LANO   
AND ACCEPTANCE.POLICYNO<>'' AND ACCEPTANCE.POLICYNO LIKE @P_POLICYNO AND ACCEPTANCE.CERTIFICATENO LIKE @P_CERTIFICATENO     
AND ACCEPTANCE.TOC LIKE @P_TOC+'%' AND ACCEPTANCE.REFNO LIKE @P_REFNO+'%'  
ORDER BY ACCEPTANCE.ANO DESC     

GO

DROP procedure QInConsistent_LossItem
GO
CREATE  procedure QInConsistent_LossItem(@P_CNO integer)     
as     
Declare @P_LossDate as smalldatetime        
Declare @P_LossTime as varchar(5)        
Declare @P_EventNo as int      
Declare @P_COL as varchar(10)        
        
Select @P_LossDate=LossDate, @P_LossTime=LossTime, @P_EventNo=EventNo, @P_Col=COL
from Claim Where CNO=@P_CNO        
                       
Select TOP 1 CLLOSS.INO,CLLOSS.NOC  
from CLLOSS Where CNO=@P_CNO And not Exists  
(  
Select ICOVER.INO,NOC.NOC  
From ICOVER WITH (INDEX(I_ICOVER)), ICOVERNOC, NOC, ACCEPTANCE  
Where ICOVER.INO=CLLOSS.INO AND ICOVERNOC.INO=ICOVER.INO AND NOC.NOC=ICOVERNOC.NOC AND NOC.TOI=ICOVER.TOI AND NOC.NOC=CLLOSS.NOC
AND ACCEPTANCE.ANO=ICOVER.ANO  
AND ((ICOVERNOC.SDATE<=@P_LOSSDATE AND ACCEPTANCE.ExclusiveF=1) or ((ICOVERNOC.SDATE<@P_LOSSDATE or (ICOVERNOC.SDATE=@P_LOSSDATE AND ACCEPTANCE.STIME<=@P_LOSSTIME)) AND ACCEPTANCE.ExclusiveF=0))                     
AND ((dbo.fn_Get_ExtPeriodDate(ACCEPTANCE.ExtPeriod, ACCEPTANCE.ExtPeriodInDaysF, ICOVERNOC.EDATE)>@P_LOSSDATE AND ACCEPTANCE.ExclusiveF=1) or ((dbo.fn_Get_ExtPeriodDate(ACCEPTANCE.ExtPeriod, ACCEPTANCE.ExtPeriodInDaysF, ICOVERNOC.EDATE)>@P_LOSSDATE or (dbo.fn_Get_ExtPeriodDate(ACCEPTANCE.ExtPeriod, ACCEPTANCE.ExtPeriodInDaysF, ICOVERNOC.EDATE)=@P_LOSSDATE AND ACCEPTANCE.ETIME>@P_LOSSTIME)) AND ACCEPTANCE.ExclusiveF=0))                              
AND
ABS(CASE 
WHEN ICOVERNOC.AMOUNT<>0 AND ICOVERNOC.PCT*ICOVER.AMOUNT/100<>0 THEN
	CASE WHEN ICOVERNOC.AMOUNT>ICOVERNOC.PCT*ICOVER.AMOUNT/100 THEN ICOVERNOC.PCT*ICOVER.AMOUNT/100 ELSE ICOVERNOC.AMOUNT END
WHEN ICOVERNOC.AMOUNT<>0 THEN ICOVERNOC.AMOUNT
ELSE ICOVERNOC.PCT*ICOVER.AMOUNT/100
END-CLLOSS.DECLARED)<=1
  
UNION ALL  
    
Select ICOVER.INO, NOC.NOC  
From ICOVER WITH (INDEX(I_ICOVER)), RCOVER, Col, RATECOV, PCLASS, NOC, ACCEPTANCE, COLNOCCLASS        
Where ICOVER.INO=CLLOSS.INO AND RCOVER.ANO=ICOVER.ANO AND ACCEPTANCE.ANO=RCOVER.ANO AND COL.COL=@P_COL      
AND ((RCOVER.SDATE<=@P_LOSSDATE AND ACCEPTANCE.ExclusiveF=1) or ((RCOVER.SDATE<@P_LOSSDATE or (RCOVER.SDATE=@P_LOSSDATE AND ACCEPTANCE.STIME<=@P_LOSSTIME)) AND ACCEPTANCE.ExclusiveF=0))                     
AND ((dbo.fn_Get_ExtPeriodDate(ACCEPTANCE.ExtPeriod, ACCEPTANCE.ExtPeriodInDaysF, RCOVER.EDATE)>@P_LOSSDATE AND ACCEPTANCE.ExclusiveF=1) or ((dbo.fn_Get_ExtPeriodDate(ACCEPTANCE.ExtPeriod, ACCEPTANCE.ExtPeriodInDaysF, RCOVER.EDATE)>@P_LOSSDATE or (dbo.fn_Get_ExtPeriodDate(ACCEPTANCE.ExtPeriod, ACCEPTANCE.ExtPeriodInDaysF, RCOVER.EDATE)=@P_LOSSDATE AND ACCEPTANCE.ETIME>@P_LOSSTIME)) AND ACCEPTANCE.ExclusiveF=0))                    
AND RATECOV.CODE=RCOVER.CODE AND RATECOV.TOR=COL.TOR AND PCLASS.TOR=COL.TOR AND PCLASS.TOI=ICOVER.TOI                        
AND NOC.TOI=ICOVER.TOI AND NOC.NOC=CLLOSS.NOC
AND NOT EXISTS (SELECT TOP 1 ICOVERNOC.NOC FROM ICOVERNOC WHERE ICOVERNOC.INO=CLLOSS.INO AND ICOVERNOC.NOC=NOC.NOC)                        
AND COLNOCCLASS.NOC=NOC.NOC AND COLNOCCLASS.COL=@P_COL
AND (PCLASS.CTLF=0 OR NOC.CTLF=PCLASS.CTLF)
AND
ABS(CASE                        
 WHEN @P_EVENTNO=-1 THEN                        
        CASE                        
        WHEN RCOVER.PCTLOSS=0 OR ICOVER.NOTDECRF=1 OR ICOVER.NOTFLF=1 THEN ICOVER.AMOUNT 
        ELSE ICOVER.AMOUNT*RCOVER.PCTLOSS/100 END                        
 Else                        
        CASE                        
        WHEN RCOVER.PCTLOSS=0 OR ICOVER.NOTDECRF=1 OR ICOVER.NOTFLF=1 THEN ICOVER.AMOUNT_AOE                
        ELSE ICOVER.AMOUNT_AOE*RCOVER.PCTLOSS/100 END                        
 END-CLLOSS.DECLARED)<=1
)  
          

GO

DROP Function Get_RateLoading
GO
CREATE Function Get_RateLoading(@P_ANO as int,@P_Code as varchar(20), @P_PDate as datetime) 
RETURNS Float AS        
  
BEGIN       
Declare @RateTab Table (
Code varchar(10),
ValueID1 varchar(15),
ValueID2 varchar(15),
ValueID3 varchar(15),
ValueID4 varchar(15),
ValueID5 varchar(15),
ValueID6 varchar(15),
ValueID7 varchar(15),
ValueID8 varchar(15),
ValueID9 varchar(15),
ValueID10 varchar(15),
ValueID11 varchar(15),
ValueID12 varchar(15),
ValueID13 varchar(15),
ValueID14 varchar(15),
ValueID15 varchar(15)
)

insert into @RateTab
SELECT Top 1 RateTab.Code, 
G1.ValueID as ValueID1,
G2.ValueID as ValueID2,
G3.ValueID as ValueID3,
G4.ValueID as ValueID4,
G5.ValueID as ValueID5,
G6.ValueID as ValueID6,
G7.ValueID as ValueID7,
G8.ValueID as ValueID8,
G9.ValueID as ValueID9,
G10.ValueID as ValueID10,
G11.ValueID as ValueID11,
G12.ValueID as ValueID12,
G13.ValueID as ValueID13,
G14.ValueID as ValueID14,
G15.ValueID as ValueID15

From AInfo 
 INNER JOIN RateTab ON (RateTab.Code=@P_Code)     
 Left Join GenHTab H1 on (H1.FLDID=AInfo.FLDID1)
 Left Join GenHTab H2 on (H2.FLDID=AInfo.FLDID2)
 Left Join GenHTab H3 on (H3.FLDID=AInfo.FLDID3)
 Left Join GenHTab H4 on (H4.FLDID=AInfo.FLDID4)
 Left Join GenHTab H5 on (H5.FLDID=AInfo.FLDID5)
 Left Join GenHTab H6 on (H6.FLDID=AInfo.FLDID6)
 Left Join GenHTab H7 on (H7.FLDID=AInfo.FLDID7)
 Left Join GenHTab H8 on (H8.FLDID=AInfo.FLDID8)
 Left Join GenHTab H9 on (H9.FLDID=AInfo.FLDID9)
 Left Join GenHTab H10 on (H10.FLDID=AInfo.FLDID10)
 Left Join GenHTab H11 on (H11.FLDID=AInfo.FLDID11)
 Left Join GenHTab H12 on (H12.FLDID=AInfo.FLDID12)
 Left Join GenHTab H13 on (H13.FLDID=AInfo.FLDID13)
 Left Join GenHTab H14 on (H14.FLDID=AInfo.FLDID14)
 Left Join GenHTab H15 on (H15.FLDID=AInfo.FLDID15)           
 Left Join GenDTab G1 on (G1.FLDID=AInfo.FLDID1 and ((G1.Formula='AGE' and cast(dbo.fn_Age(AInfo.ValueDesc1,@P_PDate, H1.AGEMETHOD) as varchar(10)) Between G1.FLower and G1.FUpper) or (G1.Formula<>'AGE' and G1.ValueID=AInfo.ValueID1)))            
 Left Join GenDTab G2 on (G2.FLDID=AInfo.FLDID2 and ((G2.Formula='AGE' and cast(dbo.fn_Age(AInfo.ValueDesc2,@P_PDate, H2.AGEMETHOD) as varchar(10)) Between G2.FLower and G2.FUpper) or (G2.Formula<>'AGE' and G2.ValueID=AInfo.ValueID2)))             
 Left Join GenDTab G3 on (G3.FLDID=AInfo.FLDID3 and ((G3.Formula='AGE' and cast(dbo.fn_Age(AInfo.ValueDesc3,@P_PDate, H3.AGEMETHOD) as varchar(10)) Between G3.FLower and G3.FUpper) or (G3.Formula<>'AGE' and G3.ValueID=AInfo.ValueID3)))          
 Left Join GenDTab G4 on (G4.FLDID=AInfo.FLDID4 and ((G4.Formula='AGE' and cast(dbo.fn_Age(AInfo.ValueDesc4,@P_PDate, H4.AGEMETHOD) as varchar(10)) Between G4.FLower and G4.FUpper) or (G4.Formula<>'AGE' and G4.ValueID=AInfo.ValueID4)))          
 Left Join GenDTab G5 on (G5.FLDID=AInfo.FLDID5 and ((G5.Formula='AGE' and cast(dbo.fn_Age(AInfo.ValueDesc5,@P_PDate, H5.AGEMETHOD) as varchar(10)) Between G5.FLower and G5.FUpper) or (G5.Formula<>'AGE' and G5.ValueID=AInfo.ValueID5)))          
 Left Join GenDTab G6 on (G6.FLDID=AInfo.FLDID6 and ((G6.Formula='AGE' and cast(dbo.fn_Age(AInfo.ValueDesc6,@P_PDate, H6.AGEMETHOD) as varchar(10)) Between G6.FLower and G6.FUpper) or (G6.Formula<>'AGE' and G6.ValueID=AInfo.ValueID6)))          
 Left Join GenDTab G7 on (G7.FLDID=AInfo.FLDID7 and ((G7.Formula='AGE' and cast(dbo.fn_Age(AInfo.ValueDesc7,@P_PDate, H7.AGEMETHOD) as varchar(10)) Between G7.FLower and G7.FUpper) or (G7.Formula<>'AGE' and G7.ValueID=AInfo.ValueID7)))          
 Left Join GenDTab G8 on (G8.FLDID=AInfo.FLDID8 and ((G8.Formula='AGE' and cast(dbo.fn_Age(AInfo.ValueDesc8,@P_PDate, H8.AGEMETHOD) as varchar(10)) Between G8.FLower and G8.FUpper) or (G8.Formula<>'AGE' and G8.ValueID=AInfo.ValueID8)))          
 Left Join GenDTab G9 on (G9.FLDID=AInfo.FLDID9 and ((G9.Formula='AGE' and cast(dbo.fn_Age(AInfo.ValueDesc9,@P_PDate, H9.AGEMETHOD) as varchar(10)) Between G9.FLower and G9.FUpper) or (G9.Formula<>'AGE' and G9.ValueID=AInfo.ValueID9)))          
 Left Join GenDTab G10 on (G10.FLDID=AInfo.FLDID10 and ((G10.Formula='AGE' and cast(dbo.fn_Age(AInfo.ValueDesc10,@P_PDate, H10.AGEMETHOD) as varchar(10)) Between G10.FLower and G10.FUpper) or (G10.Formula<>'AGE' and G10.ValueID=AInfo.ValueID10)))          
 Left Join GenDTab G11 on (G11.FLDID=AInfo.FLDID11 and ((G11.Formula='AGE' and cast(dbo.fn_Age(AInfo.ValueDesc11,@P_PDate, H11.AGEMETHOD) as varchar(10)) Between G11.FLower and G11.FUpper) or (G11.Formula<>'AGE' and G11.ValueID=AInfo.ValueID11)))          
 Left Join GenDTab G12 on (G12.FLDID=AInfo.FLDID12 and ((G12.Formula='AGE' and cast(dbo.fn_Age(AInfo.ValueDesc12,@P_PDate, H12.AGEMETHOD) as varchar(10)) Between G12.FLower and G12.FUpper) or (G12.Formula<>'AGE' and G12.ValueID=AInfo.ValueID12)))          
 Left Join GenDTab G13 on (G13.FLDID=AInfo.FLDID13 and ((G13.Formula='AGE' and cast(dbo.fn_Age(AInfo.ValueDesc13,@P_PDate, H13.AGEMETHOD) as varchar(10)) Between G13.FLower and G13.FUpper) or (G13.Formula<>'AGE' and G13.ValueID=AInfo.ValueID13)))          
 Left Join GenDTab G14 on (G14.FLDID=AInfo.FLDID14 and ((G14.Formula='AGE' and cast(dbo.fn_Age(AInfo.ValueDesc14,@P_PDate, H14.AGEMETHOD) as varchar(10)) Between G14.FLower and G14.FUpper) or (G14.Formula<>'AGE' and G14.ValueID=AInfo.ValueID14)))          
 Left Join GenDTab G15 on (G15.FLDID=AInfo.FLDID15 and ((G15.Formula='AGE' and cast(dbo.fn_Age(AInfo.ValueDesc15,@P_PDate, H15.AGEMETHOD) as varchar(10)) Between G15.FLower and G15.FUpper) or (G15.Formula<>'AGE' and G15.ValueID=AInfo.ValueID15)))          
WHERE AINFO.ANO=@P_ANO                       
Order by RateTab.Effective Desc

Declare @Loading as Float
Declare @Temp_Loading as Float
Select @Loading=1

--Rate Loading #1
Select @Temp_Loading=Null
SELECT Top 1 @Temp_Loading=RateCon.Loading
From @RateTab RateTab
INNER JOIN RateCon_M1 RateCon  on (
RateCon.Code=RateTab.Code and RateCon.AllowedF=1                 
and (coalesce(RateCon.ValueID1,'')='' or RateTab.ValueID1 =RateCon.ValueID1)                
And (coalesce(RateCon.ValueID2,'')='' or RateTab.ValueID2 =RateCon.ValueID2)                
And (coalesce(RateCon.ValueID3,'')='' or RateTab.ValueID3 =RateCon.ValueID3)                
And (coalesce(RateCon.ValueID4,'')='' or RateTab.ValueID4 =RateCon.ValueID4)                
And (coalesce(RateCon.ValueID5,'')='' or RateTab.ValueID5 =RateCon.ValueID5)                
And (coalesce(RateCon.ValueID6,'')='' or RateTab.ValueID6 =RateCon.ValueID6)                
And (coalesce(RateCon.ValueID7,'')='' or RateTab.ValueID7 =RateCon.ValueID7)                
And (coalesce(RateCon.ValueID8,'')='' or RateTab.ValueID8 =RateCon.ValueID8)                
And (coalesce(RateCon.ValueID9,'')='' or RateTab.ValueID9 =RateCon.ValueID9)                
And (coalesce(RateCon.ValueID10,'')='' or RateTab.ValueID10 =RateCon.ValueID10)                
And (coalesce(RateCon.ValueID11,'')='' or RateTab.ValueID11 =RateCon.ValueID11)                
And (coalesce(RateCon.ValueID12,'')='' or RateTab.ValueID12 =RateCon.ValueID12)                
And (coalesce(RateCon.ValueID13,'')='' or RateTab.ValueID13 =RateCon.ValueID13)                
And (coalesce(RateCon.ValueID14,'')='' or RateTab.ValueID14 =RateCon.ValueID14)                
And (coalesce(RateCon.ValueID15,'')='' or RateTab.ValueID15 =RateCon.ValueID15)                       
)
Order by   
len(coalesce(RateCon.ValueID1,'')) Desc,                           
len(coalesce(RateCon.ValueID2,'')) Desc,                           
len(coalesce(RateCon.ValueID3,'')) Desc,                           
len(coalesce(RateCon.ValueID4,'')) Desc,                           
len(coalesce(RateCon.ValueID5,'')) Desc,                          
len(coalesce(RateCon.ValueID6,'')) Desc,                          
len(coalesce(RateCon.ValueID7,'')) Desc,                          
len(coalesce(RateCon.ValueID8,'')) Desc,                          
len(coalesce(RateCon.ValueID9,'')) Desc,                          
len(coalesce(RateCon.ValueID10,'')) Desc,                          
len(coalesce(RateCon.ValueID11,'')) Desc,                          
len(coalesce(RateCon.ValueID12,'')) Desc,                          
len(coalesce(RateCon.ValueID13,'')) Desc,                          
len(coalesce(RateCon.ValueID14,'')) Desc,                          
len(coalesce(RateCon.ValueID15,'')) Desc                          

if @Temp_Loading is null
	Select @Temp_Loading=1
	
Select @Loading=@Loading*@Temp_Loading


--Rate Loading #2
Select @Temp_Loading=Null
SELECT Top 1 @Temp_Loading=RateCon.Loading
From @RateTab RateTab
INNER JOIN RateCon_M2 RateCon  on (
RateCon.Code=RateTab.Code and RateCon.AllowedF=1                 
and (coalesce(RateCon.ValueID1,'')='' or RateTab.ValueID1 =RateCon.ValueID1)                
And (coalesce(RateCon.ValueID2,'')='' or RateTab.ValueID2 =RateCon.ValueID2)                
And (coalesce(RateCon.ValueID3,'')='' or RateTab.ValueID3 =RateCon.ValueID3)                
And (coalesce(RateCon.ValueID4,'')='' or RateTab.ValueID4 =RateCon.ValueID4)                
And (coalesce(RateCon.ValueID5,'')='' or RateTab.ValueID5 =RateCon.ValueID5)                
And (coalesce(RateCon.ValueID6,'')='' or RateTab.ValueID6 =RateCon.ValueID6)                
And (coalesce(RateCon.ValueID7,'')='' or RateTab.ValueID7 =RateCon.ValueID7)                
And (coalesce(RateCon.ValueID8,'')='' or RateTab.ValueID8 =RateCon.ValueID8)                
And (coalesce(RateCon.ValueID9,'')='' or RateTab.ValueID9 =RateCon.ValueID9)                
And (coalesce(RateCon.ValueID10,'')='' or RateTab.ValueID10 =RateCon.ValueID10)                
And (coalesce(RateCon.ValueID11,'')='' or RateTab.ValueID11 =RateCon.ValueID11)                
And (coalesce(RateCon.ValueID12,'')='' or RateTab.ValueID12 =RateCon.ValueID12)                
And (coalesce(RateCon.ValueID13,'')='' or RateTab.ValueID13 =RateCon.ValueID13)                
And (coalesce(RateCon.ValueID14,'')='' or RateTab.ValueID14 =RateCon.ValueID14)                
And (coalesce(RateCon.ValueID15,'')='' or RateTab.ValueID15 =RateCon.ValueID15)                       
)
Order by   
len(coalesce(RateCon.ValueID1,'')) Desc,                           
len(coalesce(RateCon.ValueID2,'')) Desc,                           
len(coalesce(RateCon.ValueID3,'')) Desc,                           
len(coalesce(RateCon.ValueID4,'')) Desc,                           
len(coalesce(RateCon.ValueID5,'')) Desc,                          
len(coalesce(RateCon.ValueID6,'')) Desc,                          
len(coalesce(RateCon.ValueID7,'')) Desc,                          
len(coalesce(RateCon.ValueID8,'')) Desc,                          
len(coalesce(RateCon.ValueID9,'')) Desc,                          
len(coalesce(RateCon.ValueID10,'')) Desc,                          
len(coalesce(RateCon.ValueID11,'')) Desc,                          
len(coalesce(RateCon.ValueID12,'')) Desc,                          
len(coalesce(RateCon.ValueID13,'')) Desc,                          
len(coalesce(RateCon.ValueID14,'')) Desc,                          
len(coalesce(RateCon.ValueID15,'')) Desc                          

if @Temp_Loading is null
	Select @Temp_Loading=1
	
Select @Loading=@Loading*@Temp_Loading


--Rate Loading #3
Select @Temp_Loading=Null
SELECT Top 1 @Temp_Loading=RateCon.Loading
From @RateTab RateTab
INNER JOIN RateCon_M3 RateCon  on (
RateCon.Code=RateTab.Code and RateCon.AllowedF=1                 
and (coalesce(RateCon.ValueID1,'')='' or RateTab.ValueID1 =RateCon.ValueID1)                
And (coalesce(RateCon.ValueID2,'')='' or RateTab.ValueID2 =RateCon.ValueID2)                
And (coalesce(RateCon.ValueID3,'')='' or RateTab.ValueID3 =RateCon.ValueID3)                
And (coalesce(RateCon.ValueID4,'')='' or RateTab.ValueID4 =RateCon.ValueID4)                
And (coalesce(RateCon.ValueID5,'')='' or RateTab.ValueID5 =RateCon.ValueID5)                
And (coalesce(RateCon.ValueID6,'')='' or RateTab.ValueID6 =RateCon.ValueID6)                
And (coalesce(RateCon.ValueID7,'')='' or RateTab.ValueID7 =RateCon.ValueID7)                
And (coalesce(RateCon.ValueID8,'')='' or RateTab.ValueID8 =RateCon.ValueID8)                
And (coalesce(RateCon.ValueID9,'')='' or RateTab.ValueID9 =RateCon.ValueID9)                
And (coalesce(RateCon.ValueID10,'')='' or RateTab.ValueID10 =RateCon.ValueID10)                
And (coalesce(RateCon.ValueID11,'')='' or RateTab.ValueID11 =RateCon.ValueID11)                
And (coalesce(RateCon.ValueID12,'')='' or RateTab.ValueID12 =RateCon.ValueID12)                
And (coalesce(RateCon.ValueID13,'')='' or RateTab.ValueID13 =RateCon.ValueID13)                
And (coalesce(RateCon.ValueID14,'')='' or RateTab.ValueID14 =RateCon.ValueID14)                
And (coalesce(RateCon.ValueID15,'')='' or RateTab.ValueID15 =RateCon.ValueID15)                       
)
Order by   
len(coalesce(RateCon.ValueID1,'')) Desc,                           
len(coalesce(RateCon.ValueID2,'')) Desc,                           
len(coalesce(RateCon.ValueID3,'')) Desc,                           
len(coalesce(RateCon.ValueID4,'')) Desc,                           
len(coalesce(RateCon.ValueID5,'')) Desc,                          
len(coalesce(RateCon.ValueID6,'')) Desc,                          
len(coalesce(RateCon.ValueID7,'')) Desc,                          
len(coalesce(RateCon.ValueID8,'')) Desc,                          
len(coalesce(RateCon.ValueID9,'')) Desc,                          
len(coalesce(RateCon.ValueID10,'')) Desc,                          
len(coalesce(RateCon.ValueID11,'')) Desc,                          
len(coalesce(RateCon.ValueID12,'')) Desc,                          
len(coalesce(RateCon.ValueID13,'')) Desc,                          
len(coalesce(RateCon.ValueID14,'')) Desc,                          
len(coalesce(RateCon.ValueID15,'')) Desc                          

if @Temp_Loading is null
	Select @Temp_Loading=1
	
Select @Loading=@Loading*@Temp_Loading


--Rate Loading #4
Select @Temp_Loading=Null
SELECT Top 1 @Temp_Loading=RateCon.Loading
From @RateTab RateTab
INNER JOIN RateCon_M4 RateCon  on (
RateCon.Code=RateTab.Code and RateCon.AllowedF=1                 
and (coalesce(RateCon.ValueID1,'')='' or RateTab.ValueID1 =RateCon.ValueID1)                
And (coalesce(RateCon.ValueID2,'')='' or RateTab.ValueID2 =RateCon.ValueID2)                
And (coalesce(RateCon.ValueID3,'')='' or RateTab.ValueID3 =RateCon.ValueID3)                
And (coalesce(RateCon.ValueID4,'')='' or RateTab.ValueID4 =RateCon.ValueID4)                
And (coalesce(RateCon.ValueID5,'')='' or RateTab.ValueID5 =RateCon.ValueID5)                
And (coalesce(RateCon.ValueID6,'')='' or RateTab.ValueID6 =RateCon.ValueID6)                
And (coalesce(RateCon.ValueID7,'')='' or RateTab.ValueID7 =RateCon.ValueID7)                
And (coalesce(RateCon.ValueID8,'')='' or RateTab.ValueID8 =RateCon.ValueID8)                
And (coalesce(RateCon.ValueID9,'')='' or RateTab.ValueID9 =RateCon.ValueID9)                
And (coalesce(RateCon.ValueID10,'')='' or RateTab.ValueID10 =RateCon.ValueID10)                
And (coalesce(RateCon.ValueID11,'')='' or RateTab.ValueID11 =RateCon.ValueID11)                
And (coalesce(RateCon.ValueID12,'')='' or RateTab.ValueID12 =RateCon.ValueID12)                
And (coalesce(RateCon.ValueID13,'')='' or RateTab.ValueID13 =RateCon.ValueID13)                
And (coalesce(RateCon.ValueID14,'')='' or RateTab.ValueID14 =RateCon.ValueID14)                
And (coalesce(RateCon.ValueID15,'')='' or RateTab.ValueID15 =RateCon.ValueID15)                       
)
Order by   
len(coalesce(RateCon.ValueID1,'')) Desc,                           
len(coalesce(RateCon.ValueID2,'')) Desc,                           
len(coalesce(RateCon.ValueID3,'')) Desc,                           
len(coalesce(RateCon.ValueID4,'')) Desc,                           
len(coalesce(RateCon.ValueID5,'')) Desc,                          
len(coalesce(RateCon.ValueID6,'')) Desc,                          
len(coalesce(RateCon.ValueID7,'')) Desc,                          
len(coalesce(RateCon.ValueID8,'')) Desc,                          
len(coalesce(RateCon.ValueID9,'')) Desc,                          
len(coalesce(RateCon.ValueID10,'')) Desc,                          
len(coalesce(RateCon.ValueID11,'')) Desc,                          
len(coalesce(RateCon.ValueID12,'')) Desc,                          
len(coalesce(RateCon.ValueID13,'')) Desc,                          
len(coalesce(RateCon.ValueID14,'')) Desc,                          
len(coalesce(RateCon.ValueID15,'')) Desc                          

if @Temp_Loading is null
	Select @Temp_Loading=1
	
Select @Loading=@Loading*@Temp_Loading


--Rate Loading #5
Select @Temp_Loading=Null
SELECT Top 1 @Temp_Loading=RateCon.Loading
From @RateTab RateTab
INNER JOIN RateCon_M5 RateCon  on (
RateCon.Code=RateTab.Code and RateCon.AllowedF=1                 
and (coalesce(RateCon.ValueID1,'')='' or RateTab.ValueID1 =RateCon.ValueID1)                
And (coalesce(RateCon.ValueID2,'')='' or RateTab.ValueID2 =RateCon.ValueID2)                
And (coalesce(RateCon.ValueID3,'')='' or RateTab.ValueID3 =RateCon.ValueID3)                
And (coalesce(RateCon.ValueID4,'')='' or RateTab.ValueID4 =RateCon.ValueID4)                
And (coalesce(RateCon.ValueID5,'')='' or RateTab.ValueID5 =RateCon.ValueID5)                
And (coalesce(RateCon.ValueID6,'')='' or RateTab.ValueID6 =RateCon.ValueID6)                
And (coalesce(RateCon.ValueID7,'')='' or RateTab.ValueID7 =RateCon.ValueID7)                
And (coalesce(RateCon.ValueID8,'')='' or RateTab.ValueID8 =RateCon.ValueID8)                
And (coalesce(RateCon.ValueID9,'')='' or RateTab.ValueID9 =RateCon.ValueID9)                
And (coalesce(RateCon.ValueID10,'')='' or RateTab.ValueID10 =RateCon.ValueID10)                
And (coalesce(RateCon.ValueID11,'')='' or RateTab.ValueID11 =RateCon.ValueID11)                
And (coalesce(RateCon.ValueID12,'')='' or RateTab.ValueID12 =RateCon.ValueID12)                
And (coalesce(RateCon.ValueID13,'')='' or RateTab.ValueID13 =RateCon.ValueID13)                
And (coalesce(RateCon.ValueID14,'')='' or RateTab.ValueID14 =RateCon.ValueID14)                
And (coalesce(RateCon.ValueID15,'')='' or RateTab.ValueID15 =RateCon.ValueID15)                       
)
Order by   
len(coalesce(RateCon.ValueID1,'')) Desc,                           
len(coalesce(RateCon.ValueID2,'')) Desc,                           
len(coalesce(RateCon.ValueID3,'')) Desc,                           
len(coalesce(RateCon.ValueID4,'')) Desc,                           
len(coalesce(RateCon.ValueID5,'')) Desc,                          
len(coalesce(RateCon.ValueID6,'')) Desc,                          
len(coalesce(RateCon.ValueID7,'')) Desc,                          
len(coalesce(RateCon.ValueID8,'')) Desc,                          
len(coalesce(RateCon.ValueID9,'')) Desc,                          
len(coalesce(RateCon.ValueID10,'')) Desc,                          
len(coalesce(RateCon.ValueID11,'')) Desc,                          
len(coalesce(RateCon.ValueID12,'')) Desc,                          
len(coalesce(RateCon.ValueID13,'')) Desc,                          
len(coalesce(RateCon.ValueID14,'')) Desc,                          
len(coalesce(RateCon.ValueID15,'')) Desc                          

if @Temp_Loading is null
	Select @Temp_Loading=1
	
Select @Loading=@Loading*@Temp_Loading

--Rate Loading #6
Select @Temp_Loading=Null
SELECT Top 1 @Temp_Loading=RateCon.Loading
From @RateTab RateTab
INNER JOIN RateCon_M6 RateCon  on (
RateCon.Code=RateTab.Code and RateCon.AllowedF=1                 
and (coalesce(RateCon.ValueID1,'')='' or RateTab.ValueID1 =RateCon.ValueID1)                
And (coalesce(RateCon.ValueID2,'')='' or RateTab.ValueID2 =RateCon.ValueID2)                
And (coalesce(RateCon.ValueID3,'')='' or RateTab.ValueID3 =RateCon.ValueID3)                
And (coalesce(RateCon.ValueID4,'')='' or RateTab.ValueID4 =RateCon.ValueID4)                
And (coalesce(RateCon.ValueID5,'')='' or RateTab.ValueID5 =RateCon.ValueID5)                
And (coalesce(RateCon.ValueID6,'')='' or RateTab.ValueID6 =RateCon.ValueID6)                
And (coalesce(RateCon.ValueID7,'')='' or RateTab.ValueID7 =RateCon.ValueID7)                
And (coalesce(RateCon.ValueID8,'')='' or RateTab.ValueID8 =RateCon.ValueID8)                
And (coalesce(RateCon.ValueID9,'')='' or RateTab.ValueID9 =RateCon.ValueID9)                
And (coalesce(RateCon.ValueID10,'')='' or RateTab.ValueID10 =RateCon.ValueID10)                
And (coalesce(RateCon.ValueID11,'')='' or RateTab.ValueID11 =RateCon.ValueID11)                
And (coalesce(RateCon.ValueID12,'')='' or RateTab.ValueID12 =RateCon.ValueID12)                
And (coalesce(RateCon.ValueID13,'')='' or RateTab.ValueID13 =RateCon.ValueID13)                
And (coalesce(RateCon.ValueID14,'')='' or RateTab.ValueID14 =RateCon.ValueID14)                
And (coalesce(RateCon.ValueID15,'')='' or RateTab.ValueID15 =RateCon.ValueID15)                       
)
Order by   
len(coalesce(RateCon.ValueID1,'')) Desc,                           
len(coalesce(RateCon.ValueID2,'')) Desc,                           
len(coalesce(RateCon.ValueID3,'')) Desc,                           
len(coalesce(RateCon.ValueID4,'')) Desc,                           
len(coalesce(RateCon.ValueID5,'')) Desc,                          
len(coalesce(RateCon.ValueID6,'')) Desc,                          
len(coalesce(RateCon.ValueID7,'')) Desc,                          
len(coalesce(RateCon.ValueID8,'')) Desc,                          
len(coalesce(RateCon.ValueID9,'')) Desc,                          
len(coalesce(RateCon.ValueID10,'')) Desc,                          
len(coalesce(RateCon.ValueID11,'')) Desc,                          
len(coalesce(RateCon.ValueID12,'')) Desc,                          
len(coalesce(RateCon.ValueID13,'')) Desc,                          
len(coalesce(RateCon.ValueID14,'')) Desc,                          
len(coalesce(RateCon.ValueID15,'')) Desc                          

if @Temp_Loading is null
	Select @Temp_Loading=1
	
Select @Loading=@Loading*@Temp_Loading


--Rate Loading #7
Select @Temp_Loading=Null
SELECT Top 1 @Temp_Loading=RateCon.Loading
From @RateTab RateTab
INNER JOIN RateCon_M7 RateCon  on (
RateCon.Code=RateTab.Code and RateCon.AllowedF=1                 
and (coalesce(RateCon.ValueID1,'')='' or RateTab.ValueID1 =RateCon.ValueID1)                
And (coalesce(RateCon.ValueID2,'')='' or RateTab.ValueID2 =RateCon.ValueID2)                
And (coalesce(RateCon.ValueID3,'')='' or RateTab.ValueID3 =RateCon.ValueID3)                
And (coalesce(RateCon.ValueID4,'')='' or RateTab.ValueID4 =RateCon.ValueID4)                
And (coalesce(RateCon.ValueID5,'')='' or RateTab.ValueID5 =RateCon.ValueID5)                
And (coalesce(RateCon.ValueID6,'')='' or RateTab.ValueID6 =RateCon.ValueID6)                
And (coalesce(RateCon.ValueID7,'')='' or RateTab.ValueID7 =RateCon.ValueID7)                
And (coalesce(RateCon.ValueID8,'')='' or RateTab.ValueID8 =RateCon.ValueID8)                
And (coalesce(RateCon.ValueID9,'')='' or RateTab.ValueID9 =RateCon.ValueID9)                
And (coalesce(RateCon.ValueID10,'')='' or RateTab.ValueID10 =RateCon.ValueID10)                
And (coalesce(RateCon.ValueID11,'')='' or RateTab.ValueID11 =RateCon.ValueID11)                
And (coalesce(RateCon.ValueID12,'')='' or RateTab.ValueID12 =RateCon.ValueID12)                
And (coalesce(RateCon.ValueID13,'')='' or RateTab.ValueID13 =RateCon.ValueID13)                
And (coalesce(RateCon.ValueID14,'')='' or RateTab.ValueID14 =RateCon.ValueID14)                
And (coalesce(RateCon.ValueID15,'')='' or RateTab.ValueID15 =RateCon.ValueID15)                       
)
Order by   
len(coalesce(RateCon.ValueID1,'')) Desc,                           
len(coalesce(RateCon.ValueID2,'')) Desc,                           
len(coalesce(RateCon.ValueID3,'')) Desc,                           
len(coalesce(RateCon.ValueID4,'')) Desc,                           
len(coalesce(RateCon.ValueID5,'')) Desc,                          
len(coalesce(RateCon.ValueID6,'')) Desc,                          
len(coalesce(RateCon.ValueID7,'')) Desc,                          
len(coalesce(RateCon.ValueID8,'')) Desc,                          
len(coalesce(RateCon.ValueID9,'')) Desc,                          
len(coalesce(RateCon.ValueID10,'')) Desc,                          
len(coalesce(RateCon.ValueID11,'')) Desc,                          
len(coalesce(RateCon.ValueID12,'')) Desc,                          
len(coalesce(RateCon.ValueID13,'')) Desc,                          
len(coalesce(RateCon.ValueID14,'')) Desc,                          
len(coalesce(RateCon.ValueID15,'')) Desc                          

if @Temp_Loading is null
	Select @Temp_Loading=1
	
Select @Loading=@Loading*@Temp_Loading

Return @Loading  
END  

GO

DROP Function fn_Age
GO
CREATE Function fn_Age(@sBirthDate varchar(100),@ComparisonDate as Date, @AgeMethod as int)        
RETURNS INT AS          
BEGIN        
declare @BirthDate as Date
declare @temp as int          
set @temp=0          
if isdate(@sBirthDate)=1 
	set @BirthDate=cast(@sBirthDate as Date)
else
	set @BirthDate=@ComparisonDate
        
if @comparisondate<=@BirthDate          
      set @temp=0          
else          
begin          
 set @temp=datediff(year,@BirthDate,@ComparisonDate)       
  if @AgeMethod=4  -- Nearest Birth Date by Month-Day    
  begin              
      if DateAdd(year,@Temp,@BirthDate)>@ComparisonDate      
            set @Temp=@Temp-1      
      if DateDiff(Month,Dateadd(Year,@Temp,@BirthDate),@ComparisonDate) = DateDiff(Month,@ComparisonDate, Dateadd(Year,@Temp+1,@BirthDate))      
      Begin  
  if DateAdd(Month, DateDiff(Month,Dateadd(Year,@Temp,@BirthDate),@ComparisonDate),Dateadd(Year,@Temp,@BirthDate))<@ComparisonDate  
   set @Temp=@Temp+1            
   End  
      else   
      Begin  
  if DateDiff(Month,Dateadd(Year,@Temp,@BirthDate),@ComparisonDate) > DateDiff(Month,@ComparisonDate, Dateadd(Year,@Temp+1,@BirthDate))      
            set @Temp=@Temp+1       
      End  
  end      
  else  
  if @AgeMethod=3 --Next Birth Day      
  begin              
      if DateAdd(year,@Temp,@BirthDate)>@ComparisonDate      
            set @Temp=@Temp-1      
      if DateDiff(day,Dateadd(Year,@Temp,@BirthDate),@ComparisonDate) > 0      
            set @Temp=@Temp+1          
  end        
  else       
  if @AgeMethod=2  -- Nearest Birth Date by Day    
  begin            
      if DateAdd(year,@Temp,@BirthDate)>@ComparisonDate    
            set @Temp=@Temp-1    
      if DateDiff(day,Dateadd(Year,@Temp,@BirthDate),@ComparisonDate) > DateDiff(day,@ComparisonDate, Dateadd(Year,@Temp+1,@BirthDate))    
            set @Temp=@Temp+1        
  end        
  else        
  if @AgeMethod=1 -- Nearest Birth Date by Month      
  begin        
      if DateAdd(year,@Temp,@BirthDate)>@ComparisonDate      
            set @Temp=@Temp-1      
      if DateDiff(Month,Dateadd(Year,@Temp,@BirthDate),@ComparisonDate) > DateDiff(Month,@ComparisonDate, Dateadd(Year,@Temp+1,@BirthDate))      
            set @Temp=@Temp+1       
  end            
  else   -- Year Lapse      
  begin         
      if @temp>0          
       if month(@ComparisonDate)< month(@BirthDate) or (month(@BirthDate)=month(@ComparisonDate) and day(@ComparisonDate)<day(@BirthDate))          
        set @temp=@temp-1            
  end      
end        
        
return @temp      
End

GO

DROP PROCEDURE QPREMIUMAMOUNT
GO
CREATE PROCEDURE QPREMIUMAMOUNT (@P_ANO AS INTEGER,@P_PDate as smalldatetime)                      

AS                     

Declare @P_APolicyNo as varchar(50)        
Declare @P_WPC as int  
Declare @P_BillDate as smalldatetime  
Declare @P_OANO as int        
Declare @P_OCNO as int
Select   
@P_APolicyNo=Case When Cover.OpenFlag=1 and Acceptance.BulkF=0 Then Acceptance.PolicyNo+Case When Acceptance.CertificateNo<>'' Then '-'+Acceptance.CertificateNo else '' end else Acceptance.PolicyNo end,  
@P_WPC=coalesce(APayor.WPC, Payor.WPC),  
@P_BillDate=  
Case   
When Acceptance.AType='A' Then Acceptance.ADate   
else   
 Case When Cover.OpenFlag=0 Then   
  Case When SysTab.DueByEffectiveF=0 Then coalesce(mAcceptance.ADate,Acceptance.ADate) else coalesce(mAcceptance.PDate,Acceptance.PDate) end  
 else  
  Case When SysTab.DueByEffectiveF=0 Then Acceptance.ADate else Acceptance.PDate end  
 end  
end,  
@P_OANO=Acceptance.OANO,
@P_OCNO=Cover.OCNO
from Acceptance   
Left Join Acceptance mAcceptance on (mAcceptance.ANO=Acceptance.LANO)  
Left Join APayor on (APayor.ANO=Acceptance.ANO)  
Left Join Payor on (Payor.ANO=coalesce(mAcceptance.ANO, Acceptance.ANO))  
Inner Join Cover on (Cover.CNO=Acceptance.CNO)  
Inner Join SysTab on (1=1)  
Where Acceptance.ANO=@P_ANO                

Select           
sum(Voucher.PremiumAmount) as PremiumAmount,          
Min(Voucher.DueDate) as DueDate,          
sum(Voucher.PremiumPaid) as PremiumPaid,          
@P_WPC as WPC,  
@P_BillDate as BillDate,  
Max(Voucher.PDate) as Date          
From          
(           
 SELECT                      
 DISTINCT  
 nVoucher.Voucher,  
 CASE WHEN nVoucher.DEBTORF=1 THEN (Case When Voucher_Due.Voucher is null then nVoucher.Nominal_CC-nVoucher.Diff_CC else Voucher_Due.AmountDue end) ELSE -(Case When Voucher_Due.Voucher is null then nVoucher.Nominal_CC-nVoucher.Diff_CC else Voucher_Due.AmountDue end) END*nVoucher.RATE as PremiumAmount,                      
 Case When Round(nVoucher.Payment_CC,2)<round((Case When Voucher_Due.Voucher is null then nVoucher.Nominal_CC-nVoucher.Diff_CC else Voucher_Due.AmountDue end),2) Then isnull(Voucher_Due.DueDate, nVoucher.DueDate) else Null end AS DUEDATE,                 


 CASE WHEN nVoucher.DEBTORF=1 THEN nVoucher.PAYMENT_CC ELSE -nVoucher.PAYMENT_CC END*nVoucher.RATE as PremiumPaid,                      
 Admlink.WPC As WPC,              
 Admlink.BillDate as BillDate,          
 (Select Max(Case When coalesce(OVoucher.RefDate, pVoucher.RefDate)<coalesce(OVoucher.PDate, pVoucher.PDate) Then coalesce(OVoucher.RefDate, pVoucher.RefDate) else coalesce(OVoucher.PDate, pVoucher.PDate) end)     
 from pSL 
 Inner Join pVoucher on (pVoucher.Voucher=pSL.Voucher)     
 Left Join pVoucher oVoucher on (oVoucher.Voucher=pVoucher.RefNo and oVoucher.SL_Cat='P')     
 Where pSL.PaymentF=1 and pSL.Doc_No=nVoucher.Voucher    
 ) as PDate                
 FROM Admlink 
 Inner Join nVoucher on (nVoucher.Voucher=Admlink.Voucher)   
 Left Join Voucher_AmountDue(@P_PDate) Voucher_Due on (Voucher_Due.Voucher=nVoucher.Voucher)          
 Where Admlink.Subject='Premium' and Admlink.Type in ('DI','IC','IR') and Admlink.A_PolicyNo=@P_APolicyNo and Admlink.Date<=@P_PDate  
 and exists (Select Top 1 AdmNo from AccAss, Acceptance, Cover Where Cover.OCNO=@P_OCNO and Cover.CNO=Acceptance.CNO and Acceptance.ANO=AccAss.ANO and AccAss.AdmNo=Admlink.AdmNo)

) Voucher          



GO

DROP FUNCTION R_Claim_Detail
GO
Create FUNCTION R_Claim_Detail(@P_SDate as SmallDatetime, @P_EDate as  smalldatetime)
RETURNS @TCLAIM TABLE (Remarks varchar(50), Date smalldatetime, CNO int, ClaimNo varchar(20), Branch varchar(10), UWYear Int, ACYear Int, Currency varchar(10), TOC varchar(10), Claim_OS_Previous Float Default 0,Claim_Register Float Default 0, Claim_Settle
 Float Default 0, Claim_Close Float Default 0, Claim_OS_Current Float Default 0)
AS
BEGIN
Declare @P_PEDATE as SmallDatetime
Set @P_PEDATE=dateadd(day,-1,@P_SDATE)


insert into @TClaim(Remarks, Date, CNO, ClaimNo, Branch, UWYear, ACYear, Currency, TOC, Claim_OS_Previous, Claim_Register, Claim_Settle, Claim_Close, Claim_OS_Current)

Select Remarks, Date, CNO, ClaimNo, Branch, UWYear, ACYear, Currency, TOC, sum(Claim_OS_Previous) as Claim_OS_Previous, sum(Claim_Register) as Claim_Register, sum(Claim_Settle) as Claim_Settle, sum(Claim_Close) as Claim_Close, sum(Claim_OS_Current) as Claim_OS_Current

From (

Select 
0 as OrderNo,
'Previous Claim Outstanding' as Remarks, @P_PEDate as Date, C1.CNO as CNO, C1.ClaimNo, C1.Branch, year(A1.SDate) as UWYear, year(A1.ADate) as ACYear, C1.Currency, C1.TOC, sum(Gross_OS) as Claim_OS_Previous, 0 as Claim_Register, 0 as Claim_Settle, 0 
as Claim_Close, 0 as Claim_OS_Current
from OS_Net_Claim_By_Detail(@P_PEDate) C1, Acceptance A1 Where A1.ANO=C1.ANO
Group By C1.CNO, C1.ClaimNo, C1.Branch, Year(A1.SDate), year(A1.ADate), C1.Currency, C1.TOC

union all

Select 
1 as OrderNo,
Max(
Case 
When PClaim.CNO is null Then 'Register Claim Estimation (New)'
When  PClaim.CStatus='C' and PClaim.PCStatus='A' Then 'Re-Open Claim'
else 'Register Claim Estimation (Correction)'
end) as Remarks,
C1.Date, C1.CCNO as CNO, C1.ClaimNo, C1.Branch, year(A1.SDate) as UWYear, year(A1.ADate) as ACYear, C1.Currency, C1.TOC, 0 as Claim_OS_Previous, sum(Claim_Register) as Claim_Register, 0 as Claim_Settle, 0 as Claim_Close, 0 as Claim_OS_Current
from Claim_Register_By_Detail(@P_Sdate,@P_EDate) C1 Inner Join Claim C2 on (C2.CNO=C1.CCNO) Left Join Claim PClaim on (PClaim.CNO=C2.PCNO), Acceptance A1 Where A1.ANO=C1.ANO
Group By C1.Date, C1.CCNO, C1.ClaimNo, C1.Branch, Year(A1.SDate), year(A1.ADate), C1.Currency, C1.TOC

union all

Select
2 as OrderNo,
Max(
Case 
When PClaim.CNO is null Then 'Claim Paid Settlement'
When  PClaim.CStatus='C' and PClaim.PCStatus='A' Then 'Claim Paid Settlement'
else 'Claim Paid Settlement'
end) as Remarks, 
C1.Date, C1.CCNO as CNO, C1.ClaimNo, C1.Branch, year(A1.SDate) as UWYear, year(A1.ADate) as ACYear, C1.Currency, C1.TOC, 0 as Claim_OS_Previous, 0 as Claim_Register, sum(Claim_Settle) as Claim_Settle, 0 as Claim_Close, 0 as Claim_OS_Current
from Claim_Settle_By_Detail(@P_Sdate,@P_EDate) C1 Inner Join Claim C2 on (C2.CNO=C1.CCNO) Left Join Claim PClaim on (PClaim.CNO=C2.PCNO), Acceptance A1 Where A1.ANO=C1.ANO
Group By C1.Date, C1.CCNO, C1.ClaimNo, C1.Branch, Year(A1.SDate), year(A1.ADate), C1.Currency, C1.TOC

union all

Select 
3 as OrderNo,
'Claim Close/Declined' as Remarks, C1.Date, C1.CCNO as CNO, C1.ClaimNo, C1.Branch, year(A1.SDate) as UWYear, year(A1.ADate) as ACYear, C1.Currency, C1.TOC, 0 as Claim_OS_Previous, 0 as Claim_Register, 0 as Claim_Settle, sum(Claim_Close) as Claim_Close, 0 as Claim_OS_Current
from Claim_Close_By_Detail(@P_Sdate,@P_EDate) C1, Acceptance A1 Where A1.ANO=C1.ANO
Group By C1.Date, C1.CCNO, C1.ClaimNo, C1.Branch, Year(A1.SDate), year(A1.ADate), C1.Currency, C1.TOC

union all

Select 
4 as OrderNo,
'Current Claim Outstanding' as Remarks,  @P_EDate as Date, C1.CNO as CNO, C1.ClaimNo, C1.Branch, year(A1.SDate) as UWYear, year(A1.ADate) as ACYear, C1.Currency, C1.TOC, 0 as Claim_OS_Previous, 0 as Claim_Register, 0 as Claim_Settle, 0 as Claim_Close, sum(Gross_OS) as Claim_OS_Current
from OS_Net_Claim_By_Detail(@P_EDate) C1, Acceptance A1 Where A1.ANO=C1.ANO
Group By C1.CNO, C1.ClaimNo, C1.Branch, Year(A1.SDate), year(A1.ADate), C1.Currency, C1.TOC
) C

Group By Currency, CNO, OrderNo, Date, ClaimNo, Branch, UWYear, ACYear, TOC, Remarks
Order By Currency, CNO, OrderNo, Date, ClaimNo, Branch, UWYear, ACYear, TOC, Remarks

Return
END

GO

DROP Procedure GetReinsuranceRate
GO
CREATE Procedure GetReinsuranceRate(@P_TOC as varchar(10), @P_Currency as varchar(10), @P_SDate as smalldatetime, @P_PHolder as varchar(10)='')   
as   
SELECT ReRate.Rate, ReRate.CCYTo   
From ReRate
Where 
ReRate.TOC=@P_TOC
and ReRate.Currency=@P_Currency
and ReRate.RYear=coalesce((   
 Select Top 1 R1.RYear   
 from Reinsurance R1, ReClass R2   
 Left Join RePolicy R3 on (R3.RNO=R2.RNO and R3.ID=@P_PHolder)   
 Where (R1.Category<>'P' or Coalesce(R3.ID,'')<>'') and R1.RType='Q' and R2.RNO=R1.RNO and R2.TOC=@P_TOC and @P_SDate Between R1.SDate and R1.EDate   
 Order By coalesce(R3.ID,'') Desc, (Case When R2.PriorityF=1 Then R2.PriorityF else R1.PriorityF end) Desc),Year(@P_SDate)) 

GO

DROP Procedure QPolicy_Rate
GO
CREATE Procedure QPolicy_Rate(@P_ANO as int)     
as     
Select ICALC.Code, ICALC.SDate, SUM(ICALC.TSI) as TSI, Max(ICALC.PrevMinRate+0.0000000001) as PrevMinRate, Max(ICALC.PrevMaxRate-0.0000000001) as PrevMaxRate, Max(ICALC.MinRate+0.0000000001) as MinRate, Max(ICALC.MaxRate-0.0000000001) as MaxRate     
from     
(     
Select ICALC.Code, ICALC.SDate,     
MAX((Case When ICover.Category='M' then ICALC.TSI else 0 end)*(CASE WHEN RCOVER.PCTLOSS=0 THEN 100 ELSE RCOVER.PCTLOSS END)/(CASE WHEN RCOVER.PCTLOSS=0 THEN 100 ELSE RCOVER.PCTLOSS END+RCOVER.PAddition)) as TSI,     
CAST(0 as FLOAT) as PREVMINRATE,     
CAST(0 as FLOAT) as PREVMAXRATE,     
SUM(ICALC.GROSS*100/(100-RCover.Discount)/ICALC.TSI/(Case When RCOVER.LOADING=0 THEN 1 ELSE RCOVER.LOADING END)*Case When ICalc.PCTADJ<>0 Then cast(100 as Float)/ICALC.PCTADJ else 1 end*Case When ICALC.Prorata=1 then (Case When Day(ICALC.SDate)<>Day(ICALC.EDate) then cast(Cover.Prorata as Float)/datediff(day,ICALC.SDate, ICALC.EDate) else cast(case When TOC.PTerm=0 Then 12 else TOC.PTerm end as Float)/datediff(Month, ICALC.SDate, ICALC.EDate) end) else (Case When RCover.PCalc='P' and Cover.Voyage=0 then Case When day(ICalc.SDate)<>day(ICalc.EDate) or Cover.PPeriod=1 then cast(Cover.Prorata as Float)/datediff(day,ICalc.SDate, ICalc.EDate) else cast(case When TOC.PTerm=0 Then 12 else TOC.PTerm end as Float)/datediff(month,ICalc.SDate, ICalc.EDate) end else 1/ICALC.Prorata end) end)*100 as MINRATE,     
SUM(ICALC.GROSS*100/(100-RCover.Discount)/ICALC.TSI/(Case When RCOVER.LOADING=0 THEN 1 ELSE RCOVER.LOADING END)*Case When ICalc.PCTADJ<>0 Then cast(100 as Float)/ICALC.PCTADJ else 1 end*Case When ICALC.Prorata=1 then (Case When Day(ICALC.SDate)<>Day(ICALC.EDate) then cast(Cover.Prorata as Float)/datediff(day,ICALC.SDate, ICALC.EDate) else cast(case When TOC.PTerm=0 Then 12 else TOC.PTerm end as Float)/datediff(Month, ICALC.SDate, ICALC.EDate) end) else (Case When RCover.PCalc='P' and Cover.Voyage=0 then Case When day(ICalc.SDate)<>day(ICalc.EDate) or Cover.PPeriod=1 then cast(Cover.Prorata as Float)/datediff(day,ICalc.SDate, ICalc.EDate) else cast(case When TOC.PTerm=0 Then 12 else TOC.PTerm end as Float)/datediff(month,ICalc.SDate, ICalc.EDate) end else 1/ICALC.Prorata end) end)*100 as MAXRATE     
from COVER, ACCEPTANCE, ICover, ICALC, RCover, TOC
Where ACCEPTANCE.ANO=@P_ANO and COVER.CNO=ACCEPTANCE.CNO and COVER.ISType in ('I','C','L') and RCover.ANO=Acceptance.ANO     
and RCover.ANO=ICALC.ANO and RCover.Code=ICALC.Code and RCover.SDate=ICALC.SDate and RCover.EDate=ICALC.EDate and datediff(month, ICALC.SDate, ICALC.EDate)<>0     
and ICover.INO=ICalc.INO and ICALC.TSI<>0     
and TOC.TOC=ACCEPTANCE.TOC
Group By ICalc.INO, ICALC.Code, ICALC.SDate     
     
Union All     
     
Select ICALC.Code, ICALC.SDate,     
0 as TSI,     
SUM(ICALC.GROSS*100/(100-RCover.Discount)/ICALC.TSI/(Case When RCOVER.LOADING=0 THEN 1 ELSE RCOVER.LOADING END)*Case When ICalc.PCTADJ<>0 Then cast(100 as Float)/ICALC.PCTADJ else 1 end*Case When ICALC.Prorata=1 then (Case When Day(ICALC.SDate)<>Day(ICALC.EDate) then cast(Cover.Prorata as Float)/datediff(day,ICALC.SDate, ICALC.EDate) else cast(case When TOC.PTerm=0 Then 12 else TOC.PTerm end as Float)/datediff(Month, ICALC.SDate, ICALC.EDate) end) else (Case When RCover.PCalc='P' and Cover.Voyage=0 then Case When day(ICalc.SDate)<>day(ICalc.EDate) or Cover.PPeriod=1 then cast(Cover.Prorata as Float)/datediff(day,ICalc.SDate, ICalc.EDate) else cast(case When TOC.PTerm=0 Then 12 else TOC.PTerm end as Float)/datediff(month,ICalc.SDate, ICalc.EDate) end else 1/ICALC.Prorata end) end)*100 as PREVMINRATE,     
SUM(ICALC.GROSS*100/(100-RCover.Discount)/ICALC.TSI/(Case When RCOVER.LOADING=0 THEN 1 ELSE RCOVER.LOADING END)*Case When ICalc.PCTADJ<>0 Then cast(100 as Float)/ICALC.PCTADJ else 1 end*Case When ICALC.Prorata=1 then (Case When Day(ICALC.SDate)<>Day(ICALC.EDate) then cast(Cover.Prorata as Float)/datediff(day,ICALC.SDate, ICALC.EDate) else cast(case When TOC.PTerm=0 Then 12 else TOC.PTerm end as Float)/datediff(Month, ICALC.SDate, ICALC.EDate) end) else (Case When RCover.PCalc='P' and Cover.Voyage=0 then Case When day(ICalc.SDate)<>day(ICalc.EDate) or Cover.PPeriod=1 then cast(Cover.Prorata as Float)/datediff(day,ICalc.SDate, ICalc.EDate) else cast(case When TOC.PTerm=0 Then 12 else TOC.PTerm end as Float)/datediff(month,ICalc.SDate, ICalc.EDate) end else 1/ICALC.Prorata end) end)*100 as PREVMAXRATE,     
CAST(0 as FLOAT) as MINRATE,     
CAST(0 as FLOAT) as MAXRATE     
from COVER, ACCEPTANCE, ACCEPTANCE PACCEPTANCE, ICover, ICALC, RCover, TOC
Where ACCEPTANCE.ANO=@P_ANO and COVER.CNO=ACCEPTANCE.CNO and COVER.ISType in ('I','C','L') and PACCEPTANCE.ANO=ACCEPTANCE.PANO and RCOVER.ANO=PACCEPTANCE.ANO     
and RCover.ANO=ICALC.ANO and RCover.Code=ICALC.Code and RCover.SDate=ICALC.SDate and RCover.EDate=ICALC.EDate and datediff(month, ICALC.SDate, ICALC.EDate)<>0     
and ICover.INO=ICalc.INO and ICALC.TSI<>0     
and TOC.TOC=ACCEPTANCE.TOC
Group By ICalc.INO, ICALC.Code, ICALC.SDate     
) ICALC     
Group By ICALC.Code, ICALC.SDate     
Having SUM(ICALC.TSI)<>0     
     

     
GO

DROP FUNCTION FL_SL_ACCOUNT
GO
CREATE FUNCTION FL_SL_ACCOUNT(@P_GID varchar(10), @P_Voucher varchar(20), @P_VType varchar(10), @P_ComAcc varchar(30), @P_Doc_No varchar(20),@P_CCY varchar(10), @P_Payment_Flag bit)                                    
RETURNS @TSL_Account TABLE (Account Varchar(10), Open_ItemF Bit, Branch Varchar(15), Hint Int, Description varchar(512), Currency varchar(10), AccGroup varchar(10), Outstanding Float)                                    
AS                                        
BEGIN                               
Declare @P_SL_Cat varchar(1)                
                       
if @P_Payment_Flag=1                       
Begin              
 Select @P_SL_Cat=SL_Cat from pVoucher Where Voucher=@P_Doc_No                
 if @P_SL_Cat is null                 
 Begin              
   Select @P_SL_Cat='N'                
 End                
 if @P_SL_Cat='P'                
 Begin                           
   insert into @TSL_Account                                    
   Select A1.Account, A2.Open_ItemF, A1.Branch, A1.Hint, A2.Description, V.Currency, A2.AccGroup,          
   (Case When VType.DebtorF=1 Then 1 Else -1 end)*(Case When V.DebtorF=1 then -(Max(A1.Nominal_OC)-sum(Case When SL_Alloc.Nominal_OC is null then 0 else SL_Alloc.Nominal_OC end)) else (Max(A1.Nominal_OC)-sum(Case When SL_Alloc.Nominal_OC is null then 0 else SL_Alloc.Nominal_OC end)) end) as Outstanding              
   from pVoucher V                                     
   Inner Join Get_Open_Item_Hint_P(@P_Doc_No,@P_VType) A1 on (A1.Voucher=V.Voucher)                                     
   Inner join VType on (VType.VType=@P_VType)          
   Inner Join Account A2 on (A2.Account=A1.Account)     
   Left Join ComAcc on (ComAcc.ComAcc=@P_ComAcc)    
   Left Join Open_Item_Allocated(@P_Doc_No) SL_Alloc on (SL_Alloc.Voucher<>@P_Voucher and SL_Alloc.Doc_no=A1.Voucher and SL_Alloc.Branch=A1.Branch and SL_Alloc.Account=A1.Account)                                     
   Where @P_Doc_No<>'' and A1.Voucher=V.Voucher                                     
   and ((coalesce(ComAcc.ComAcc,'')='' and A2.AccGroup='') or (coalesce(ComAcc.ComAcc,'')<>'' and (ComAcc.AccGroup='' or A2.AccGroup='' or ComAcc.AccGroup=A2.AccGroup)))     
   Group By A1.Account, A2.Open_ItemF, A1.Branch, A1.Hint, VType.DebtorF, V.DebtorF, V.SL_Cat, A2.Description, V.Currency , A2.AccGroup                                  
   Having round(Max(A1.Nominal_OC),2)<>round(sum(Case When SL_Alloc.Nominal_OC is null then 0 else SL_Alloc.Nominal_OC end),2)                                        
 End              
 else                
 Begin              
   insert into @TSL_Account                                    
   Select A1.Account, A2.Open_ItemF, A1.Branch, A1.Hint, A2.Description, V.Currency, A2.AccGroup,
   (Case When VType.DebtorF=1 Then 1 Else -1 end)*(Case When V.DebtorF=1 then (Max(A1.Nominal_OC)-sum(Case When SL_Alloc.Nominal_OC is null then 0 else SL_Alloc.Nominal_OC end)) else (Max(A1.Nominal_OC)-sum(Case When SL_Alloc.Nominal_OC is null then 0 else SL_Alloc.Nominal_OC end)) end) as Outstanding              
   from nVoucher V                                     
   Inner Join Get_Open_Item_Hint_N(@P_Doc_No,@P_VType) A1 on (A1.Voucher=V.Voucher)                                     
   Inner join VType on (VType.VType=@P_VType)          
   Inner Join Account A2 on (A2.Account=A1.Account)       
   Left Join ComAcc on (ComAcc.ComAcc=@P_ComAcc)
   Left Join Open_Item_Allocated(@P_Doc_No) SL_Alloc on (SL_Alloc.Voucher<>@P_Voucher and SL_Alloc.Doc_no=A1.Voucher and SL_Alloc.Branch=A1.Branch and SL_Alloc.Account=A1.Account)                                     
   Where @P_Doc_No<>'' and A1.Voucher=V.Voucher                                     
   and ((coalesce(ComAcc.ComAcc,'')='' and A2.AccGroup='') or (coalesce(ComAcc.ComAcc,'')<>'' and (ComAcc.AccGroup='' or A2.AccGroup='' or ComAcc.AccGroup=A2.AccGroup)))     
   Group By A1.Account, A2.Open_ItemF, A1.Branch, A1.Hint, VType.DebtorF, V.DebtorF, V.SL_Cat, A2.Description, V.Currency, A2.AccGroup                                   
   Having round(Max(A1.Nominal_OC),2)<>round(sum(Case When SL_Alloc.Nominal_OC is null then 0 else SL_Alloc.Nominal_OC end),2)                         
 End              
End              
Else            
Begin           
 if @P_GID=''       
 Begin                        
  insert into @TSL_Account                                
  Select A1.Account, A1.Open_ItemF, '' as Branch, max(CASE WHEN vtype.debtorf=1 THEN vPattern.Credit ELSE vpattern.debit end) as Hint, A1.Description, Case When @P_CCY='' then SysTab.Currency else @P_CCY end as Currency, A1.AccGroup, 0 as Outstanding                 
  from Account A1 
  Left Join ComAcc on (ComAcc.ComAcc=@P_ComAcc), Account a2, vPattern, SysTab, VType              
  Where A1.AllowedF=1 and a1.post_flag=1 and a1.parent=a2.parent and a2.account=vPattern.account and vPattern.Constant_Flag=1 and ((vPattern.Credit<0 AND VType.DebtorF = 1) or (vPattern.Debit<0 AND VType.CreditorF = 1)) and VType.Vtype=@P_VType AND VType.VType = VPattern.VType and (A1.Hold_Flag<>1 or A1.Suspend_Flag=1)                                    
  and ((coalesce(ComAcc.ComAcc,'')='' and A1.AccGroup='') or (coalesce(ComAcc.ComAcc,'')<>'' and (ComAcc.AccGroup='' or A1.AccGroup='' or ComAcc.AccGroup=A1.AccGroup)))     
  Group By A1.Account, A1.Open_ItemF, A1.Description, SysTab.Currency, A1.AccGroup                                   
 End      
 Else      
 Begin      
  insert into @TSL_Account                                    
  Select A1.Account, A1.Open_ItemF, '' as Branch, max(CASE WHEN vtype.debtorf=1 THEN vPattern.Credit ELSE vpattern.debit end) as Hint, B.Description, Case When @P_CCY='' then SysTab.Currency else @P_CCY end as Currency, A1.AccGroup, 0 as Outstanding                   
  from Budget_AccountDetail B, Account A1 
  Left Join ComAcc on (ComAcc.ComAcc=@P_ComAcc), Account a2, vPattern, SysTab, VType                                       
  Where B.GID=@P_GID and B.ID=@P_Doc_No and (A1.Account=B.Account_Dr or A1.Account=B.Account_Cr) and A1.AllowedF=1 and a1.post_flag=1 and a1.parent=a2.parent and a2.account=vPattern.account and vPattern.Constant_Flag=1 and ((vPattern.Credit<0 AND VType.DebtorF = 1) or (vPattern.Debit<0 AND VType.CreditorF = 1)) and VType.Vtype=@P_VType AND VType.VType = VPattern.VType and (A1.Hold_Flag<>1 or A1.Suspend_Flag=1)                                      
  and ((coalesce(ComAcc.ComAcc,'')='' and A1.AccGroup='') or (coalesce(ComAcc.ComAcc,'')<>'' and (ComAcc.AccGroup='' or A1.AccGroup='' or ComAcc.AccGroup=A1.AccGroup)))     
  Group By A1.Account, A1.Open_ItemF, B.Description, SysTab.Currency, A1.AccGroup            
 End      
End       
       
Return                                    
END                

GO

DROP FUNCTION FN_NJOURNAL_SL
GO
CREATE FUNCTION FN_NJOURNAL_SL( @P_SDate as  smalldatetime,@P_EDate as smalldatetime)      
RETURNS TABLE         
AS RETURN ( 
Select
Distinct
SL.Voucher,
SL.Doc_No,
SL.Doc_Date,
SL.Remarks,
SL.Account, 
Case When Type.BS_Flag=1 Then '' When SL.CT='' Then Voucher.CT else SL.CT end as CT,
(Case When Type.PL_Flag=1 then SysTab.Currency else Voucher.Currency end) as Doc_CCY,
Case When Type.PL_FLAG=1 Then 
	Case When Voucher.DebtorF=1 then SL.Nominal*Voucher.Rate else -SL.Nominal*Voucher.Rate end
else
	Case When Voucher.DebtorF=1 then SL.Nominal else -SL.Nominal end
end as Nominal_OC,
Case When Type.PL_FLAG=1 Then 
	1
else
	Voucher.Rate
end as Rate,
Case When Type.PL_FLAG=1 Then 
	Case When Voucher.DebtorF=1 then SL.Nominal*Voucher.Rate else -SL.Nominal*Voucher.Rate end
else
	Case When Voucher.DebtorF=1 then SL.Nominal*Voucher.Rate else -SL.Nominal*Voucher.Rate end
end as Nominal
from nSL SL, nVoucher Voucher, nJournal Journal, Account, Type, SysTab
Where Voucher.Voucher=SL.Voucher and Account.Account=SL.Account and Type.Type=Account.Type
and Journal.Voucher=SL.Voucher and Journal.Account=SL.Account 
and Journal.Currency=(Case When Type.PL_Flag=1 then SysTab.Currency else Voucher.Currency end)
and Journal.CT=(Case When Type.BS_Flag=1 Then '' When SL.CT='' Then Voucher.CT else SL.CT end)
and Voucher.Date Between @P_SDate and @P_EDate
)

GO

DROP FUNCTION FN_PJOURNAL_SL
GO
CREATE FUNCTION FN_PJOURNAL_SL( @P_SDate as  smalldatetime,@P_EDate as smalldatetime)            
RETURNS TABLE               
AS RETURN (       
Select      
Distinct      
SL.SortNo,
SL.Voucher,      
SL.Doc_No,      
SL.Doc_Date,      
SL.Remarks,      
SL.Account,       
Case When Type.BS_Flag=1 Then '' When SL.CT='' Then Voucher.CT else SL.CT end as CT,      
Case When Type.PL_Flag=1 then SysTab.Currency When SL.PaymentF=1 Then SL.Doc_CCY else Voucher.Currency end as Doc_CCY,      
Case When Voucher.SL_Cat IN ('A','B','P') then      
  Case       
   When SL.PaymentF=1 Then Case When Voucher.DebtorF=1 Then -SL.Nominal_OC else SL.Nominal_OC end      
   When Type.PL_Flag=1 Then Case When Voucher.DebtorF=1 then -SL.Nominal*Voucher.Rate else SL.Nominal*Voucher.Rate end      
   else Case When Voucher.DebtorF=1 Then -SL.Nominal else SL.Nominal end      
   end      
  else      
  Case       
   When SL.PaymentF=1 Then Case When Voucher.DebtorF=1 Then SL.Nominal_OC else -SL.Nominal_OC end      
   When Type.PL_Flag=1 Then Case When Voucher.DebtorF=1 then SL.Nominal*Voucher.Rate else -SL.Nominal*Voucher.Rate end      
   else Case When Voucher.DebtorF=1 Then SL.Nominal else -SL.Nominal end      
   end      
  end AS Nominal_OC,        
Case When Voucher.SL_Cat IN ('A','B','P') then      
  Case       
   When SL.PaymentF=1 Then (Case When (Journal.Debit_OC+Journal.Credit_OC)<>0 Then (Journal.Debit+Journal.Credit)/(Journal.Debit_OC+Journal.Credit_OC) else 0 End)  
   When Type.PL_Flag=1 Then 1      
   else Voucher.Rate end      
  else      
  Case       
   When SL.PaymentF=1 Then (Case When (Journal.Debit_OC+Journal.Credit_OC)<>0 Then (Journal.Debit+Journal.Credit)/(Journal.Debit_OC+Journal.Credit_OC) else 0 End)      
   When Type.PL_Flag=1 Then 1      
   else Voucher.Rate end         
  end AS Rate,        
Case When Voucher.SL_Cat IN ('A','B','P') then      
  Case       
   When SL.PaymentF=1 Then Case When Voucher.DebtorF=1 Then -SL.Nominal_OC else SL.Nominal_OC end *(Case When (Journal.Debit_OC+Journal.Credit_OC)<>0 Then (Journal.Debit+Journal.Credit)/(Journal.Debit_OC+Journal.Credit_OC) else 0 End)      
   When Type.PL_Flag=1 Then Case When Voucher.DebtorF=1 then -SL.Nominal*Voucher.Rate else SL.Nominal*Voucher.Rate end      
   else Case When Voucher.DebtorF=1 Then -SL.Nominal else SL.Nominal end*Voucher.Rate       
   end      
  else      
  Case       
   When SL.PaymentF=1 Then Case When Voucher.DebtorF=1 Then SL.Nominal_OC else -SL.Nominal_OC end *(Case When (Journal.Debit_OC+Journal.Credit_OC)<>0 Then (Journal.Debit+Journal.Credit)/(Journal.Debit_OC+Journal.Credit_OC) else 0 End)      
   When Type.PL_Flag=1 Then Case When Voucher.DebtorF=1 then SL.Nominal*Voucher.Rate else -SL.Nominal*Voucher.Rate end      
   else Case When Voucher.DebtorF=1 Then SL.Nominal else -SL.Nominal end*Voucher.Rate       
   end      
  end AS Nominal      
from pSL SL, pVoucher Voucher, pJournal Journal, Account, Type, SysTab      
Where Voucher.Voucher=SL.Voucher and Account.Account=SL.Account and Type.Type=Account.Type      
and Journal.Voucher=SL.Voucher and Journal.Account=SL.Account       
and Journal.Currency=(Case When Type.PL_Flag=1 then SysTab.Currency When SL.PaymentF=1 Then SL.Doc_CCY else Voucher.Currency end)      
and Journal.CT=(Case When Type.BS_Flag=1 Then '' When SL.CT='' Then Voucher.CT else SL.CT end)      
and Voucher.Date Between @P_SDate and @P_EDate      
) 


GO

DROP Function Get_Payment_Percentage
GO
CREATE Function Get_Payment_Percentage(@P_A_PolicyNo varchar(50), @P_Date smalldatetime)
RETURNS Float AS        
  
BEGIN       
Declare @PCT as Float

Select 
@PCT=sum(case When V.DebtorF=1 Then (V.Payment_CC) Else -(V.Payment_CC) end)/sum(case When V.DebtorF=1 Then (V.Nominal_CC-V.Diff_CC) Else -(V.Nominal_CC-V.Diff_CC) end)*100
from Admlink a, nVoucher V 
Where V.Voucher=A.Voucher and A.Date<=@P_Date and A.A_PolicyNo=@P_A_PolicyNo and A.SUbject='Premium' and V.DebtorF=1 and A.Type in ('DI','IC','IR')
Having sum(case When V.DebtorF=1 Then (V.Nominal_CC-V.Diff_CC) Else -(V.Nominal_CC-V.Diff_CC) end)<>0

if @PCT IS NULL 
	SELECT @PCT=100

Return @PCT
End

            
GO

DROP procedure PI09 
GO
CREATE procedure PI09 (@P_ANO as integer) 
as 
Begin 
Declare @P_Date as smalldatetime 
Declare @P_PolicyNo as varchar(20) 
Declare @P_CertificateNo as varchar(20) 
Declare @P_OpenFLag as Bit 
Declare @P_LANO as int 
Declare @P_A_PolicyNo as varchar(50) 
Select @P_Date = Getdate() 
 
Select @P_LANO=A1.LANO, @P_PolicyNo=A1.PolicyNo, @P_CertificateNo=A1.CertificateNo, @P_OpenFlag=C1.OpenFlag from Acceptance A1, Cover C1 Where C1.CNO=A1.CNO and A1.ANO=@P_ANO 
 
if @P_LANO<>-1 
if @P_OpenFlag=1 and @P_ANO<>@P_LANO 
Select @P_A_PolicyNo=@P_PolicyNo + '-' + @P_CertificateNo 
else 
Select @P_A_PolicyNo=@P_PolicyNo 
else 
Select @P_A_PolicyNo=@P_PolicyNo 
 
Select Voucher.Voucher, Voucher.DueDate, Voucher.DocNo, Profile.Name, Voucher.Currency, 
case when Voucher.debtorf=1 then Voucher.Nominal_CC-Voucher.Diff_CC else -(Voucher.Nominal_CC-Voucher.Diff_CC) end  as Nominal, 
case when Voucher.debtorf=1 then (Voucher.AmountDue-Voucher.Payment_CC) else -(Voucher.AmountDue-Voucher.Payment_CC) end as AmountDue, 
case when Voucher.debtorf=1 then Voucher.Payment_CC else -Voucher.Payment_CC end as Payment, 
case when Voucher.debtorf=1 then Voucher.Nominal_CC-Voucher.Diff_CC - Voucher.Payment_CC else -(Voucher.Nominal_CC-Voucher.Diff_CC - Voucher.Payment_CC) end as Outstanding 
 
from nVoucher Voucher, Profile, ProAcc, Admlink 
Where Profile.ID=ProAcc.ID and ProAcc.ProAcc=Voucher.ProAcc and Admlink.Voucher=Voucher.Voucher 
and Admlink.Subject='Claim' and Admlink.Type in ('DI','IC','IR','OP') and Admlink.A_PolicyNo<>'' and Admlink.A_PolicyNo=@P_A_PolicyNo and (Admlink.Extra_1='' or Admlink.Extra_1 is null) 
and round(Voucher.AmountDue,0)>round(Voucher.Payment_CC,0) 
End 
 
 
GO

DROP Function Premium_MaxOutGo
GO
CREATE Function Premium_MaxOutGo(@P_ANO as int,@P_Code as varchar(10),@P_Period int=0)        
RETURNS Float        
AS        

BEGIN        
 --Return (dbo.premium_discount(@P_ANO, @P_Code,@P_Period)-dbo.Payor_Group_Discount(@P_ANO, @P_Code,@P_Period)+dbo.Premium_Commission(@P_ANO, @P_Code,@P_Period,0)+dbo.Premium_Commission_Vat(@P_ANO, @P_Code,@P_Period,0))        
 --Return (dbo.Premium_Commission(@P_ANO, @P_Code,@P_Period,0)-dbo.Premium_Commission_UpFee(@P_ANO, @P_Code,@P_Period,0))  
 --Return (100/(100-dbo.premium_discount(@P_ANO, @P_Code,@P_Period))*(dbo.Premium_Commission(@P_ANO, @P_Code,@P_Period,0)-dbo.Premium_Commission_UpFee(@P_ANO, @P_Code,@P_Period,0)))
 Return (dbo.premium_discount(@P_ANO, @P_Code,@P_Period)+dbo.Premium_Commission(@P_ANO, @P_Code,@P_Period,0)-dbo.Premium_Commission_UpFee(@P_ANO, @P_Code,@P_Period,0))  
End      

GO

DROP procedure PI08 
GO
CREATE procedure PI08 (@P_ANO as integer)   
as   
Begin   
Declare @P_Date as smalldatetime   
Declare @P_PolicyNo as varchar(20)   
Declare @P_CertificateNo as varchar(20)   
Declare @P_OpenFLag as Bit   
Declare @P_LANO as int   
Declare @P_A_PolicyNo as varchar(50)   
Select @P_Date = Getdate()   
   
Select @P_LANO=A1.LANO, @P_PolicyNo=A1.PolicyNo, @P_CertificateNo=A1.CertificateNo, @P_OpenFlag=C1.OpenFlag from Acceptance A1, Cover C1 Where C1.CNO=A1.CNO and A1.ANO=@P_ANO   
   
if @P_LANO<>-1   
if @P_OpenFlag=1 and @P_ANO<>@P_LANO   
Select @P_A_PolicyNo=@P_PolicyNo + '-' + @P_CertificateNo   
else   
Select @P_A_PolicyNo=@P_PolicyNo   
else   
Select @P_A_PolicyNo=@P_PolicyNo   
   
Select Voucher.Voucher, Voucher.DueDate, Voucher.DocNo, Voucher_Due.DueDate as NDueDate, Profile.Name, Voucher.Currency,   
Admlink.RefType,  
Admlink.AccountNo, Admlink.Bank, Admlink.BankName,   
Admlink.AccountNo_Ext, Admlink.Bank_Ext, Admlink.BankName_Ext,   
case when Voucher.debtorf=1 then Voucher.Nominal_CC-Voucher.Diff_CC else -(Voucher.Nominal_CC-Voucher.Diff_CC) end  as Nominal,   
case when Voucher.debtorf=1 then (coalesce(Voucher_Due.AmountDue, Voucher.AmountDue)-Voucher.Payment_CC) else -(coalesce(Voucher_Due.AmountDue, Voucher.AmountDue)-Voucher.Payment_CC) end as AmountDue,   
case when Voucher.debtorf=1 then Voucher.Payment_CC else -Voucher.Payment_CC end as Payment,   
case when Voucher.debtorf=1 then Voucher.Nominal_CC-Voucher.Diff_CC - Voucher.Payment_CC else -(Voucher.Nominal_CC-Voucher.Diff_CC - Voucher.Payment_CC) end as Outstanding,   
Voucher.Installment,   
Voucher.DueDate_1, case when Voucher.debtorf=1 then Voucher.AmountDue_1 else -Voucher.AmountDue_1 end AmountDue_1,   
Voucher.DueDate_2, case when Voucher.debtorf=1 then Voucher.AmountDue_2 else -Voucher.AmountDue_2 end AmountDue_2,   
Voucher.DueDate_3, case when Voucher.debtorf=1 then Voucher.AmountDue_3 else -Voucher.AmountDue_3 end AmountDue_3,   
Voucher.DueDate_4, case when Voucher.debtorf=1 then Voucher.AmountDue_4 else -Voucher.AmountDue_4 end AmountDue_4,   
Voucher.DueDate_5, case when Voucher.debtorf=1 then Voucher.AmountDue_5 else -Voucher.AmountDue_5 end AmountDue_5,   
Voucher.DueDate_6, case when Voucher.debtorf=1 then Voucher.AmountDue_6 else -Voucher.AmountDue_6 end AmountDue_6,   
Voucher.DueDate_7, case when Voucher.debtorf=1 then Voucher.AmountDue_7 else -Voucher.AmountDue_7 end AmountDue_7,   
Voucher.DueDate_8, case when Voucher.debtorf=1 then Voucher.AmountDue_8 else -Voucher.AmountDue_8 end AmountDue_8,   
Voucher.DueDate_9, case when Voucher.debtorf=1 then Voucher.AmountDue_9 else -Voucher.AmountDue_9 end AmountDue_9,   
Voucher.DueDate_10, case when Voucher.debtorf=1 then Voucher.AmountDue_10 else -Voucher.AmountDue_10 end AmountDue_10,   
Voucher.DueDate_11, case when Voucher.debtorf=1 then Voucher.AmountDue_11 else -Voucher.AmountDue_11 end AmountDue_11,   
Voucher.DueDate_12, case when Voucher.debtorf=1 then Voucher.AmountDue_12 else -Voucher.AmountDue_12 end AmountDue_12,   
Voucher.DueDate_13, case when Voucher.debtorf=1 then Voucher.AmountDue_13 else -Voucher.AmountDue_13 end AmountDue_13,   
Voucher.DueDate_14, case when Voucher.debtorf=1 then Voucher.AmountDue_14 else -Voucher.AmountDue_14 end AmountDue_14,   
Voucher.DueDate_15, case when Voucher.debtorf=1 then Voucher.AmountDue_15 else -Voucher.AmountDue_15 end AmountDue_15,   
Voucher.DueDate_16, case when Voucher.debtorf=1 then Voucher.AmountDue_16 else -Voucher.AmountDue_16 end AmountDue_16,   
Voucher.DueDate_17, case when Voucher.debtorf=1 then Voucher.AmountDue_17 else -Voucher.AmountDue_17 end AmountDue_17,   
Voucher.DueDate_18, case when Voucher.debtorf=1 then Voucher.AmountDue_18 else -Voucher.AmountDue_18 end AmountDue_18,   
Voucher.DueDate_19, case when Voucher.debtorf=1 then Voucher.AmountDue_19 else -Voucher.AmountDue_19 end AmountDue_19,   
Voucher.DueDate_20, case when Voucher.debtorf=1 then Voucher.AmountDue_20 else -Voucher.AmountDue_20 end AmountDue_20,   
Voucher.DueDate_21, case when Voucher.debtorf=1 then Voucher.AmountDue_21 else -Voucher.AmountDue_21 end AmountDue_21,   
Voucher.DueDate_22, case when Voucher.debtorf=1 then Voucher.AmountDue_22 else -Voucher.AmountDue_22 end AmountDue_22,   
Voucher.DueDate_23, case when Voucher.debtorf=1 then Voucher.AmountDue_23 else -Voucher.AmountDue_23 end AmountDue_23,   
Voucher.DueDate_24, case when Voucher.debtorf=1 then Voucher.AmountDue_24 else -Voucher.AmountDue_24 end AmountDue_24   
from nVoucher Voucher Inner Join Voucher_AmountDue(@P_Date) Voucher_Due on (Voucher_Due.Voucher=Voucher.Voucher), Profile, ProAcc, Admlink   
Where Profile.ID=ProAcc.ID and ProAcc.ProAcc=Voucher.ProAcc and Admlink.Voucher=Voucher.Voucher   
and Admlink.Subject='Premium' and Admlink.Type in ('DI','IC','IR') and Admlink.A_PolicyNo<>'' and Admlink.A_PolicyNo=@P_A_PolicyNo and (Admlink.Extra_1='' or Admlink.Extra_1 is null)   
End   
   

GO

DROP FUNCTION DISPLAY_GROSS_CALCULATION
GO
CREATE FUNCTION DISPLAY_GROSS_CALCULATION(@P_ANO int)      
RETURNS TABLE  AS      
RETURN (      
Select ICalc.ANO, ICalc.Currency, ICalc.Code, ICalc.SDate, ICalc.EDate, sum(ICalc.Gross) as Gross,      
Calculation=      
Case When ICalc.SRate<>'Flat' then convert(varchar(25),Cast(sum(ICalc.TSI) as Money),1) + ' x ' + (case When RCover.Unit='C' then convert(varchar(25), Cast(sum(ICalc.Rate*100)/Count(*) as Numeric(38,8)),2)+'%' else convert(varchar(25), Cast(sum(ICalc.Rate*1000)/Count(*) as Numeric(38,8)),3)+'‰' end) else convert(varchar(25), Cast(sum(ICalc.Rate) as Money),1) end +      
Case When ICalc.sProrata<>'' then ' x '+ICalc.sProrata else '' end +      
Case When ICalc.SRate<>'Flat' and ICalc.PCTAdj<>100 then ' x '+Cast(Icalc.PCTAdj as varchar(10))+'%' else '' end      
From      
(Select ICalc.ANO, ICalc.INO, ICalc.Currency, ICalc.Code, ICalc.SDate, ICalc.EDate, Case When ICalc.SRate='Flat' then 100 else ICalc.PCTAdj end as PCTAdj, sum(ICalc.Gross) as Gross, Max(ICalc.SRate) as SRate, Max(ICalc.TSI) as TSI, sum(ICalc.Rate) as Rate, Max(ICalc.sProrata) as sProrata      
from ICalc, Acceptance Where ICalc.ANO=Acceptance.ANO and Acceptance.ANO=@P_ANO and ICalc.Rate<>0      
Group By ICalc.ANO, ICalc.INO, ICalc.Currency, ICalc.Code, ICalc.SDate, ICalc.EDate, Case When ICalc.SRate='Flat' then 100 else ICalc.PCTAdj end      
) ICalc, RCover      
Where RCOVER.ANO = ICALC.ANO And RCOVER.Code = ICALC.Code And RCOVER.SDate = ICALC.SDate And RCOVER.EDate = ICALC.EDate      
Group By ICalc.ANO, ICalc.Currency, ICalc.Code, ICalc.SDate, ICalc.EDate, ICalc.SRate, RCover.Unit, ICalc.sProrata, ICalc.PCTadj      
                
Union All      
                
Select ICalc.ANO, ICalc.Currency, ICalc.Code, ICalc.SDate, ICalc.EDate, -sum(ICalc.Gross)*Case When Max(ICalc.AType)='C' and Max(ICalc.EMethod)<>'A' and Max(RCover.CPRefund)<>0 then Max(RCover.CPRefund)/100 else 1 end as Gross,      
Calculation='- '+      
Case When ICalc.SRate<>'Flat' then convert(varchar(25),Cast(sum(ICalc.TSI) as Money),1) + ' x ' + (case When RCover.Unit='C' then convert(varchar(25), Cast(sum(ICalc.Rate*100)/Count(*) as Numeric(38,8)),2)+'%' else convert(varchar(25), Cast(sum(ICalc.Rate*1000)/Count(*) as Numeric(38,8)),3)+'‰' end) else convert(varchar(25), Cast(sum(ICalc.Rate) as Money),1) end +      
Case When ICalc.sProrata<>'' then ' x '+ICalc.sProrata else '' end +      
Case When ICalc.SRate<>'Flat' and ICalc.PCTAdj<>100 then ' x '+Cast(Icalc.PCTAdj as varchar(10))+'%' else '' end +  
Case When Max(ICalc.AType)='C' and Max(ICalc.EMethod)<>'A' and Max(RCover.CPRefund)<>0 then ' x '+convert(varchar(25),Max(RCover.CPRefund),3)+'%' else '' end  
From      
(Select Acceptance.AType, Acceptance.EMethod, ICalc.ANO, ICalc.INO, ICalc.Currency, ICalc.Code, ICalc.SDate, ICalc.EDate, Case When ICalc.SRate='Flat' then 100 else ICalc.PCTAdj end as PCTAdj, sum(ICalc.Gross) as Gross, Max(ICalc.SRate) as SRate, Max(ICalc.TSI) as TSI, sum(ICalc.Rate) as Rate, Max(ICalc.sProrata) as sProrata      
from ICalc, Acceptance Where ICalc.ANO=Acceptance.PANO and Acceptance.ANO=@P_ANO and ICalc.Rate<>0      
Group By Acceptance.AType, Acceptance.EMethod, ICalc.ANO, ICalc.INO, ICalc.Currency, ICalc.Code, ICalc.SDate, ICalc.EDate, Case When ICalc.SRate='Flat' then 100 else ICalc.PCTAdj end      
) ICalc, RCover      
Where RCOVER.ANO = ICALC.ANO And RCOVER.Code = ICALC.Code And RCOVER.SDate = ICALC.SDate And RCOVER.EDate = ICALC.EDate      
Group By ICalc.ANO, ICalc.Currency, ICalc.Code, ICalc.SDate, ICalc.EDate, ICalc.SRate, RCover.Unit, ICalc.sProrata, ICalc.PCTadj      
      
Union All      
        
Select ICalc.ANO, ICalc.Currency, ICalc.Code, ICalc.SDate, ICalc.EDate, sum(ICalc.Gross) as Gross,      
Calculation=      
Case When ICalc.SRate<>'Flat' then convert(varchar(25),Cast(sum(ICalc.TSI) as Money),1) + ' x ' + (case When RCover.Unit='C' then convert(varchar(25), Cast(sum(ICalc.Rate*100)/Count(*) as Numeric(38,8)),2)+'%' else convert(varchar(25), Cast(sum(ICalc.Rate*1000)/Count(*) as Numeric(38,8)),3)+'‰' end) else convert(varchar(25), Cast(sum(ICalc.Rate) as Money),1) end +      
Case When ICalc.sProrata<>'' then ' x '+ICalc.sProrata else '' end +      
Case When ICalc.SRate<>'Flat' and ICalc.PCTAdj<>100 then ' x '+Cast(Icalc.PCTAdj as varchar(10))+'%' else '' end      
From      
(Select ICalc.ANO, ICalc.INO, ICalc.Currency, ICalc.Code, ICalc.SDate, ICalc.EDate, Case When ICalc.SRate='Flat' then 100 else ICalc.PCTAdj end as PCTAdj, sum(ICalc.Reinstatement) as Gross, Max(ICalc.SRate) as SRate, Max(ICalc.Indemnity) as TSI, sum(ICalc.Rate) as Rate, Max(ICalc.sProrata) as sProrata      
from ICalc, Acceptance Where Acceptance.EMethod='R' and ICalc.ANO=Acceptance.ANO and Acceptance.ANO=@P_ANO and ICalc.Rate<>0      
Group By ICalc.ANO, ICalc.INO, ICalc.Currency, ICalc.Code, ICalc.SDate, ICalc.EDate, Case When ICalc.SRate='Flat' then 100 else ICalc.PCTAdj end      
) ICalc, RCover      
Where RCOVER.ANO = ICALC.ANO And RCOVER.Code = ICALC.Code And RCOVER.SDate = ICALC.SDate And RCOVER.EDate = ICALC.EDate      
Group By ICalc.ANO, ICalc.Currency, ICalc.Code, ICalc.SDate, ICalc.EDate, ICalc.SRate, RCover.Unit, ICalc.sProrata, ICalc.PCTadj      
)     

GO


DROP Procedure Facultative_Premium
GO
CREATE Procedure Facultative_Premium(@P_ANO integer,@P_Code varchar(10), @P_CCY varchar(10), @P_SDate smalldatetime, @P_EDate smalldatetime, @P_FID varchar(255),@P_AdjustableF bit)    
as    
Select sum(Premium) as Premium    
From    
(    
 SELECT 
 CASE
 WHEN MAX(FPART.NETRATE)<>0 THEN
	(Case When MAX(FPart.Unit)='F' Then 
		MAX(FPart.NetRate) 
	 else 
		SUM(FPart.NetRate/100/PCALC.RiskNum*(Case When RArrDet.Limit*100/coalesce(ISource.Share,100)<>0 Then RArrDet.Limit*100/coalesce(ISource.Share,100) else ICALC.TSI end)*ICALC.PCTADJ/100*ICALC.GROSS/PCALC.GROSS) 
	 end)
	 *Max((Case When RArrDet.PCalc='P' or datediff(month,RArrDet.SDate, RArrDet.EDate)=0 or Cover.Voyage=1 Then 1 else 12/cast(datediff(month,RArrDet.SDate, RArrDet.EDate) as float) end))
 ELSE
	sum((ICALC.GROSS/PCALC.POGROSS*PCALC.PGROSS)/ICALC.PRORATA)
 END*MAX(PCalc.Rate) AS PREMIUM
 FROM ICALC, ICOVER, PCALC_ANNUM(@P_ANO) PCALC, FPART, RARRDET, ACCEPTANCE LEFT JOIN ISOURCE ON (ISOURCE.CNO=ACCEPTANCE.CNO), COVER    
 WHERE FPART.ANO=RARRDET.ANO AND FPART.FID=RARRDET.FID AND FPART.FID=@P_FID    
 AND RARRDET.ANO=PCALC.ANO AND PCALC.ANO=ICALC.ANO AND PCALC.CODE=ICALC.CODE AND PCALC.SDATE=ICALC.SDATE AND PCALC.EDATE=ICALC.EDATE AND PCALC.INO=ICALC.INO AND PCALC.CURRENCY=ICALC.CURRENCY AND ICALC.CURRENCY=@P_CCY    
 AND ICOVER.INO=ICALC.INO AND (ICOVER.ADJUSTABLE=@P_ADJUSTABLEF OR ACCEPTANCE.ATYPE='A')    
 AND ICALC.SDATE=@P_SDATE AND ICALC.EDATE=@P_EDATE AND ICALC.CODE=@P_CODE    
 AND ACCEPTANCE.ANO=ICALC.ANO AND COVER.CNO=ACCEPTANCE.CNO    
 AND PCALC.GROSS<>0 AND RARRDET.FULLCOVERF=1    
 AND ICALC.GROSS<>0

 Union All    

select  
Case 
When Max(FPart.NetRate)<>0 Then 
MAX((Case When FPart.Unit='F' Then FPart.NetRate else FPart.NetRate/100*(Case When RArrDet.Limit*100/coalesce(ISource.Share,100)<>0 Then RArrDet.Limit*100/coalesce(ISource.Share,100) else ICALC.TSI end)*ICALC.PCTADJ/100 end)
	*(Case When RArrDet.PCalc='P' or datediff(month,RArrDet.SDate, RArrDet.EDate)=0 or Cover.Voyage=1 Then 1 else 12/cast(datediff(month,RArrDet.SDate, RArrDet.EDate) as float) end))    
else 
sum((ICALC.GROSS/PCALC.POGROSS*PCALC.PGROSS)/ICALC.PRORATA)
end*Max(PCalc.Rate) AS PREMIUM    
FROM ICALC, ICOVER, PCALC_ANNUM(@P_ANO) PCALC, FPARTDET FPART, RATECOV, RARRDET, ACCEPTANCE LEFT JOIN ISOURCE ON (ISOURCE.CNO=ACCEPTANCE.CNO), COVER    
WHERE FPART.ANO=RARRDET.ANO AND FPART.FID=RARRDET.FID AND FPART.FID=@P_FID AND RATECOV.CODE=FPART.CODE
AND RARRDET.ANO=PCALC.ANO AND PCALC.ANO=ICALC.ANO AND PCALC.CODE=ICALC.CODE AND PCALC.SDATE=ICALC.SDATE AND PCALC.EDATE=ICALC.EDATE AND PCALC.INO=ICALC.INO AND PCALC.CURRENCY=ICALC.CURRENCY AND ICALC.CURRENCY=@P_CCY    
AND ICOVER.INO=ICALC.INO AND (ICOVER.ADJUSTABLE=@P_ADJUSTABLEF OR ACCEPTANCE.ATYPE='A')    
AND ICALC.SDATE=@P_SDATE AND ICALC.EDATE=@P_EDATE AND ICALC.CODE=@P_CODE AND ICALC.TOR=RATECOV.TOR
AND ACCEPTANCE.ANO=ICALC.ANO AND COVER.CNO=ACCEPTANCE.CNO    
AND PCALC.GROSS<>0 AND RARRDET.FULLCOVERF=0    
Group By ICalc.INO
) F    

GO

DROP Procedure QRFACDET 
GO
Create Procedure QRFACDET (@P_SANO integer, @P_ANO integer,@P_FID varchar(255), @P_CCY varchar(255), @P_SDate DateTime, @P_EDate DateTime, @P_Code varchar(10),@P_AdjustableF bit)      
as      
Select sum(Gross) as Gross
from
(   
	SELECT 
	CASE
	WHEN MAX(FPART.NETRATE)<>0 THEN
	(Case When MAX(FPart.Unit)='F' Then 
		MAX(FPart.NetRate) 
		else 
		SUM(FPart.NetRate/100/PCALC.RiskNum*(Case When RArrDet.Limit*100/coalesce(ISource.Share,100)<>0 Then RArrDet.Limit*100/coalesce(ISource.Share,100) else ICALC.TSI end)*ICALC.PCTADJ/100*ICALC.GROSS/PCALC.GROSS) 
		end)
		*Max((Case When RArrDet.PCalc='P' or datediff(month,RArrDet.SDate, RArrDet.EDate)=0 or Cover.Voyage=1 Then 1 else 12/cast(datediff(month,RArrDet.SDate, RArrDet.EDate) as float) end))
	ELSE
	sum((ICALC.GROSS/PCALC.POGROSS*PCALC.PGROSS)/ICALC.PRORATA)
	END AS GROSS

    FROM ICALC, ICOVER, PCALC_ANNUM(@P_ANO) PCALC, FPART, RARRDET, ACCEPTANCE LEFT JOIN ISOURCE ON (ISOURCE.CNO=ACCEPTANCE.CNO), COVER      
    WHERE RARRDET.ANO=@P_SANO AND RARRDET.FID=@P_FID AND FPART.ANO=RARRDET.ANO AND FPART.FID=RARRDET.FID
    AND ICOVER.INO=ICALC.INO AND (ICOVER.ADJUSTABLE=@P_ADJUSTABLEF OR ACCEPTANCE.ATYPE='A')      
    AND ICALC.ANO=@P_ANO AND ICALC.CURRENCY=@P_CCY      
    AND PCALC.ANO=ICALC.ANO AND PCALC.CODE=ICALC.CODE AND PCALC.SDATE=ICALC.SDATE AND PCALC.EDATE=ICALC.EDATE AND PCALC.INO=ICALC.INO AND PCALC.CURRENCY=ICALC.CURRENCY      
    AND ICALC.SDATE=@P_SDATE AND ICALC.EDATE=@P_EDATE AND ICALC.CODE=@P_CODE      
    AND ACCEPTANCE.ANO=ICALC.ANO AND COVER.CNO=ACCEPTANCE.CNO      
    AND PCALC.GROSS<>0 AND RARRDET.STATUS<>'O'      
    AND RARRDET.FULLCOVERF=1      
  
  Union All      

	select   
	Case When Max(FPart.NetRate)<>0 Then       
		Max(
		Case When FPart.Unit='F' Then FPart.NetRate else FPart.NetRate/100*((Case When RArrDet.Limit*100/coalesce(ISource.Share,100)<>0 Then RArrDet.Limit*100/coalesce(ISource.Share,100) else ICALC.TSI end)*ICALC.PCTADJ/100) end  
		*  
		Case When RArrDet.PCalc='P' or datediff(month,RArrDet.SDate, RArrDet.EDate)=0 or Cover.Voyage=1 Then 1 else 12/cast(datediff(month,RArrDet.SDate, RArrDet.EDate) as float)   
		end)
	else   
		sum((ICALC.GROSS/PCALC.POGROSS*PCALC.PGROSS)/ICALC.PRORATA)   
	end  AS GROSS      
	FROM ICALC, ICOVER, PCALC_ANNUM(@P_ANO) PCALC, FPARTDET FPART, RATECOV, RARRDET, ACCEPTANCE LEFT JOIN ISOURCE ON (ISOURCE.CNO=ACCEPTANCE.CNO), COVER      
	WHERE RARRDET.ANO=@P_SANO AND RARRDET.FID=@P_FID AND FPART.ANO=RARRDET.ANO AND FPART.FID=RARRDET.FID AND RATECOV.CODE=FPART.CODE
	AND ICOVER.INO=ICALC.INO AND (ICOVER.ADJUSTABLE=@P_ADJUSTABLEF OR ACCEPTANCE.ATYPE='A')      
	AND ICALC.ANO=@P_ANO AND ICALC.CURRENCY=@P_CCY      
	AND PCALC.ANO=ICALC.ANO AND PCALC.CODE=ICALC.CODE AND PCALC.SDATE=ICALC.SDATE AND PCALC.EDATE=ICALC.EDATE AND PCALC.INO=ICALC.INO AND PCALC.CURRENCY=ICALC.CURRENCY      
	AND ICALC.SDATE=@P_SDATE AND ICALC.EDATE=@P_EDATE AND ICALC.CODE=@P_CODE AND ICALC.TOR=RATECOV.TOR
	AND ACCEPTANCE.ANO=ICALC.ANO AND COVER.CNO=ACCEPTANCE.CNO      
	AND PCALC.GROSS<>0 AND RARRDET.STATUS<>'O'      
	AND RARRDET.FULLCOVERF=0           
	Group by ICalc.INO
) F  

GO


DROP FUNCTION DISPLAY_GROSS_FACULTATIVE_CALCULATION
GO
CREATE FUNCTION DISPLAY_GROSS_FACULTATIVE_CALCULATION(@P_ANO int, @P_FID Varchar(20))      
RETURNS TABLE  AS      
RETURN (      
--1
Select ICalc.ANO, ICalc.Currency, ICalc.Code, ICalc.FCode, ICalc.SDate, ICalc.EDate,   
Gross=    
Case     
 When Max(ICalc.NetRate)=0 then    
  case When Max(ICalc.FLPCT)=0 Then    
   sum(ICalc.PCTShare/100*ICalc.Gross*(Case When ICalc.OnGrossAfterCommF=1 Then (100-dbo.Premium_Commission(ICalc.ANO, ICalc.Code,0,0))/100 else 1 end)/Icalc.PProrata)*max(ICalc.FacProrata)*max(ICalc.Share)/100    
  else    
   sum(ICalc.PCTShare/100*ICalc.Gross*(Case When ICalc.OnGrossAfterCommF=1 Then (100-dbo.Premium_Commission(ICalc.ANO, ICalc.Code,0,0))/100 else 1 end)/Icalc.PProrata)*max(ICalc.FacProrata)    
  end  
 else    
  case When Max(ICalc.FLPCT)=0 Then    
	   Case When Max(ICalc.Unit)='F' Then
		Max(ICalc.PCTShare/100)*Max(ICalc.NetRate)*max(ICalc.FacProrata)
	   else
		sum(ICalc.PCTShare/100*Icalc.TSI*ICalc.PCTADJ/100)*Max(ICalc.NetRate)/100*max(ICalc.FacProrata)*max(ICalc.Share)/100   
	   end
  else    
	   Case When Max(ICalc.Unit)='F' Then
		Max(ICalc.PCTShare/100)*Max(ICalc.NetRate)*max(ICalc.FacProrata)       
	   else
		sum(ICalc.PCTShare/100*Icalc.TSI*ICalc.PCTADJ/100)*Max(ICalc.NetRate)/100*max(ICalc.FacProrata)       
	   end  
  end    
 end,     
Calculation=      
Case     
 When Max(ICalc.NetRate)=0 Then    
  case When Max(ICalc.FLPCT)=0 Then    
   convert(varchar(25), cast(sum(ICalc.PCTShare/100*ICalc.Gross*(Case When ICalc.OnGrossAfterCommF=1 Then (100-dbo.Premium_Commission(ICalc.ANO, ICalc.Code,0,0))/100 else 1 end)/ICalc.PProrata) as Money),1) + Case When max(ICalc.FacProrata_Calculation)='' or Max(ICalc.FacProrata)=1 Then '' Else ' x ' + max(ICalc.FacProrata_Calculation) End + ' x '+convert(varchar(25), Max(ICalc.Share),3)+'%'    
  else    
   convert(varchar(25), cast(sum(ICalc.PCTShare/100*ICalc.Gross*(Case When ICalc.OnGrossAfterCommF=1 Then (100-dbo.Premium_Commission(ICalc.ANO, ICalc.Code,0,0))/100 else 1 end)/ICalc.PProrata) as Money),1) + Case When max(ICalc.FacProrata_Calculation)='' or Max(ICalc.FacProrata)=1 Then '' Else ' x ' + max(ICalc.FacProrata_Calculation) End    
  end    
 else    
  Case When Max(ICalc.FacProrata*ICalc.NetRateProrata)=1 then    
   case When Max(ICalc.FLPCT)=0 Then    
		case When Max(ICalc.Unit)='F' Then
			Case When Max(ICalc.PCTShare)<>100 Then convert(varchar(25), cast(Max(ICalc.PCTShare) as Money),1) + '% x ' else '' end +convert(varchar(25), Cast(Max(ICalc.NetRate/ICalc.NetRateProrata) as Money),1) + Case When max(ICalc.FacProrata_Calculation)='' or Max(ICalc.FacProrata*ICalc.NetRateProrata)=1 Then '' Else ' x ' + max(ICalc.FacProrata_Calculation) End 
		else
			convert(varchar(25), cast(sum(ICalc.PCTShare/100*Icalc.TSI*ICalc.PCTADJ/100) as Money),1) + ' x '+convert(varchar(25), cast(Max(ICalc.NetRate/ICalc.NetRateProrata) as Money),2)+'%' + Case When max(ICalc.FacProrata_Calculation)='' or Max(ICalc.FacProrata*ICalc.NetRateProrata)=1 Then '' Else ' x ' + max(ICalc.FacProrata_Calculation) End + ' x '+convert(varchar(25), Max(ICalc.Share),3)+'%'    
		end
   else 
		Case When Max(ICalc.Unit)='F' Then		   
			Case When Max(ICalc.PCTShare)<>100 Then convert(varchar(25), cast(Max(ICalc.PCTShare) as Money),1) + '% x ' else '' end +convert(varchar(25), Cast(Max(ICalc.NetRate/ICalc.NetRateProrata) as Money),1) + Case When max(ICalc.FacProrata_Calculation)='' or Max(ICalc.FacProrata*ICalc.NetRateProrata)=1 Then '' Else ' x ' + max(ICalc.FacProrata_Calculation) End     
		else
			convert(varchar(25), cast(sum(ICalc.PCTShare/100*Icalc.TSI*ICalc.PCTADJ/100) as Money),1) + ' x '+convert(varchar(25), cast(Max(ICalc.NetRate/ICalc.NetRateProrata) as Money),2)+'%' + Case When max(ICalc.FacProrata_Calculation)='' or Max(ICalc.FacProrata*ICalc.NetRateProrata)=1 Then '' Else ' x ' + max(ICalc.FacProrata_Calculation) End 		
		end
   end    
  else    
   case When Max(ICalc.FLPCT)=0 Then    
		Case When Max(ICalc.Unit)='F' Then
			Case When Max(ICalc.PCTShare)<>100 Then convert(varchar(25), cast(Max(ICalc.PCTShare) as Money),1) + '% x ' else '' end +convert(varchar(25), Max(ICalc.NetRate),1) + Case When max(ICalc.FacProrata_Calculation)='' or Max(ICalc.FacProrata)=1 Then '' Else ' x ' + max(ICalc.FacProrata_Calculation) End
		else
			convert(varchar(25), cast(sum(ICalc.PCTShare/100*Icalc.TSI*ICalc.PCTADJ/100) as Money),1) + ' x '+convert(varchar(25), Max(ICalc.NetRate),3)+'%' + Case When max(ICalc.FacProrata_Calculation)='' or Max(ICalc.FacProrata)=1 Then '' Else ' x ' + max(ICalc.FacProrata_Calculation) End + ' x '+convert(varchar(25), Max(ICalc.Share),3)+'%'    		
		end
   else    
		Case When Max(ICalc.Unit)='F' then
			Case When Max(ICalc.PCTShare)<>100 Then convert(varchar(25), cast(Max(ICalc.PCTShare) as Money),1) + '% x ' else '' end +convert(varchar(25), Max(ICalc.NetRate),1) + Case When max(ICalc.FacProrata_Calculation)='' or Max(ICalc.FacProrata)=1 Then '' Else ' x ' + max(ICalc.FacProrata_Calculation) End     
		else
			convert(varchar(25), cast(sum(ICalc.PCTShare/100*Icalc.TSI*ICalc.PCTADJ/100) as Money),1) + ' x '+convert(varchar(25), Max(ICalc.NetRate),3)+'%' + Case When max(ICalc.FacProrata_Calculation)='' or Max(ICalc.FacProrata)=1 Then '' Else ' x ' + max(ICalc.FacProrata_Calculation) End     		
		end
   end      
  end    
 End    
From      
(Select ICalc.ANO, ICalc.INO, ICalc.Currency, ICalc.Code, ICalc.Sdate, ICalc.Edate, ICalc.PCTAdj,    
Max(FPart.Code) as FCode,
Max(D.FacProrata_Calculation) as FacProrata_calculation,    
Max(D.FacProrata) as FacProrata,     
SUM(Case When PCALC.Description<>'' and PCALC.Description<>'Minimum Premium' then ICALC.GROSS*PCALC.GROSS/PCALC.OGROSS else ICALC.GROSS*D.GROSS/D.OGROSS end) AS GROSS,          
AVG(ICalc.Prorata) as PProrata,     
Max(PCalc.Ourshare/PCalc.TSI*100) as PCTShare,     
Max(ICalc.SRate) as SRate,     
Max((Case When RArrDet.Limit*PCalc.TSI/PCalc.OurShare<>0 Then RArrDet.Limit*PCalc.TSI/PCalc.OurShare else ICalc.TSI end)) as TSI,     
SUM(ICalc.Rate) as Rate,     
Max(Case When RArrDet.PCalc='P' or datediff(month,RArrDet.SDate, RArrDet.EDate)=0 or Cover.Voyage=1 Then 1 else 12/cast(datediff(month,RArrDet.SDate, RArrDet.EDate) as float) end) as NetRateProrata,    
Max(FPart.NetRate*Case When RArrDet.PCalc='P' or datediff(month,RArrDet.SDate, RArrDet.EDate)=0 or Cover.Voyage=1 Then 1 else 12/cast(datediff(month,RArrDet.SDate, RArrDet.EDate) as float) end)/Max(I.RiskNum) as NetRate,    
Max(FPart.Unit) as Unit,
Max(RArrDet.Share) as Share,    
Max(RArrDet.FLPCT) as FLPCT,    
Max(ICalc.sProrata) as sProrata,  
Max(Cast(RArrDet.OnGrossAfterCommF as Integer)) as OnGrossAfterCommF  
from ICalc, PCalc, (Select ANO, INO, Currency, SDate, EDate, Count(Distinct Code) as RiskNum from ICalc Where Gross<>0 and ANO=@P_ANO Group By ANO, INO, Currency, SDate, EDate) I, DISPLAY_FACULTATIVE_PRORATA_CALCULATION(@P_ANO, @P_FID) D, FPart, RArrDet, 


Acceptance, Cover    
Where Acceptance.ANO=@P_ANO and Cover.CNO=Acceptance.CNO and ICalc.ANO=Acceptance.ANO and ICalc.Rate<>0 and PCalc.ANO=ICalc.ANO and PCalc.Currency=ICalc.Currency    
and I.ANO=ICalc.ANO and I.INO=ICalc.INO and I.Currency=ICalc.Currency and I.SDate=ICalc.SDate and I.EDate=ICalc.EDate        
and D.ANO=ICalc.ANO and D.Currency=ICalc.Currency and D.Code=ICalc.Code and D.SDate=ICalc.Sdate and D.EDate=ICalc.EDate and D.TOR=ICalc.TOR    
and RArrDet.FullCoverF=1 and RArrDet.ANO=D.ANO and RArrDet.FID=@P_FID and FPart.ANO=RArrDet.ANO and FPart.FID=RArrdet.FID    
and RArrDet.NoRefundF=0
Group By ICalc.ANO, ICalc.INO, ICalc.Currency, ICalc.Code, ICalc.SDate, ICalc.EDate, ICalc.PCTAdj    
) ICalc    
Group By ICalc.ANO, ICalc.Currency, ICalc.Code, ICalc.FCode, ICalc.SDate, ICalc.EDate, ICalc.SRate, ICalc.sProrata, ICalc.PCTadj      
    
UNION ALL    


--2 (Refund from Endorsement)    
Select ICalc.ANO, ICalc.Currency, ICalc.Code, ICalc.FCode, ICalc.SDate, ICalc.EDate,   
Gross=-    
Case     
 When Max(ICalc.NetRate)=0 then    
  case When Max(ICalc.FLPCT)=0 Then    
  sum(ICalc.PCTShare/100*ICalc.Gross*(Case When ICalc.OnGrossAfterCommF=1 Then (100-dbo.Premium_Commission(ICalc.ANO, ICalc.Code,0,0))/100 else 1 end)/Icalc.PProrata)*max(ICalc.FacProrata)*max(ICalc.Share)/100    
  else    
   sum(ICalc.PCTShare/100*ICalc.Gross*(Case When ICalc.OnGrossAfterCommF=1 Then (100-dbo.Premium_Commission(ICalc.ANO, ICalc.Code,0,0))/100 else 1 end)/Icalc.PProrata)*max(ICalc.FacProrata)    
  end    
 else    
  case When Max(ICalc.FLPCT)=0 Then    
	   Case When Max(ICalc.Unit)='F' Then
		Max(ICalc.PCTShare/100)*Max(ICalc.NetRate)*max(ICalc.FacProrata)
	   else
		sum(ICalc.PCTShare/100*Icalc.TSI*ICalc.PCTADJ/100)*Max(ICalc.NetRate)/100*max(ICalc.FacProrata)*max(ICalc.Share)/100   
	   end
  else    
	   Case When Max(ICalc.Unit)='F' Then
		Max(ICalc.PCTShare/100)*Max(ICalc.NetRate)*max(ICalc.FacProrata)       
	   else
		sum(ICalc.PCTShare/100*Icalc.TSI*ICalc.PCTADJ/100)*Max(ICalc.NetRate)/100*max(ICalc.FacProrata)       
	   end  
  end  
 end
 * Case When Max(ICalc.AType)='C' and Max(ICalc.EMethod)<>'A' and Max(ICalc.CPRefund)<>0 then Max(ICalc.CPRefund)/100 else 1 end,
Calculation=      
Case     
 When Max(ICalc.NetRate)=0 Then    
  case When Max(ICalc.FLPCT)=0 Then    
   '- ' + convert(varchar(25), cast(sum(ICalc.PCTShare/100*ICalc.Gross*(Case When ICalc.OnGrossAfterCommF=1 Then (100-dbo.Premium_Commission(ICalc.ANO, ICalc.Code,0,0))/100 else 1 end)/ICalc.PProrata) as Money),1) + Case When max(ICalc.FacProrata_Calculation)='' or Max(ICalc.FacProrata)=1 Then '' Else ' x ' + max(ICalc.FacProrata_Calculation) End + ' x '+convert(varchar(25), Max(ICalc.Share),3)+'%'    
  else    
   '- ' + convert(varchar(25), cast(sum(ICalc.PCTShare/100*ICalc.Gross*(Case When ICalc.OnGrossAfterCommF=1 Then (100-dbo.Premium_Commission(ICalc.ANO, ICalc.Code,0,0))/100 else 1 end)/ICalc.PProrata) as Money),1) + Case When max(ICalc.FacProrata_Calculation)='' or Max(ICalc.FacProrata)=1 Then '' Else ' x ' + max(ICalc.FacProrata_Calculation) End    
  end    
 else    
  Case When Max(ICalc.FacProrata*ICalc.NetRateProrata)=1 then    
   case When Max(ICalc.FLPCT)=0 Then    
		case When Max(ICalc.Unit)='F' Then
			'- ' + Case When Max(ICalc.PCTShare)<>100 Then convert(varchar(25), cast(Max(ICalc.PCTShare) as Money),1) + '% x ' else '' end +convert(varchar(25), Cast(Max(ICalc.NetRate/ICalc.NetRateProrata) as Money),1) + Case When max(ICalc.FacProrata_Calculation)='' or Max(ICalc.FacProrata*ICalc.NetRateProrata)=1 Then '' Else ' x ' + max(ICalc.FacProrata_Calculation) End
		else
			'- ' + convert(varchar(25), cast(sum(ICalc.PCTShare/100*Icalc.TSI*ICalc.PCTADJ/100) as Money),1) + ' x '+convert(varchar(25), cast(Max(ICalc.NetRate/ICalc.NetRateProrata) as Money),2)+'%' + Case When max(ICalc.FacProrata_Calculation)='' or Max(ICalc.FacProrata*ICalc.NetRateProrata)=1 Then '' Else ' x ' + max(ICalc.FacProrata_Calculation) End + ' x '+convert(varchar(25), Max(ICalc.Share),3)+'%'    
		end
   else 
		Case When Max(ICalc.Unit)='F' Then		   
			'- ' + Case When Max(ICalc.PCTShare)<>100 Then convert(varchar(25), cast(Max(ICalc.PCTShare) as Money),1) + '% x ' else '' end +convert(varchar(25), Cast(Max(ICalc.NetRate/ICalc.NetRateProrata) as Money),1) + Case When max(ICalc.FacProrata_Calculation)='' or Max(ICalc.FacProrata*ICalc.NetRateProrata)=1 Then '' Else ' x ' + max(ICalc.FacProrata_Calculation) End     
		else
			'- ' + convert(varchar(25), cast(sum(ICalc.PCTShare/100*Icalc.TSI*ICalc.PCTADJ/100) as Money),1) + ' x '+convert(varchar(25), cast(Max(ICalc.NetRate/ICalc.NetRateProrata) as Money),2)+'%' + Case When max(ICalc.FacProrata_Calculation)='' or Max(ICalc.FacProrata*ICalc.NetRateProrata)=1 Then '' Else ' x ' + max(ICalc.FacProrata_Calculation) End 		
		end
   end    
  else    
   case When Max(ICalc.FLPCT)=0 Then    
		Case When Max(ICalc.Unit)='F' Then
			'- ' + Case When Max(ICalc.PCTShare)<>100 Then convert(varchar(25), cast(Max(ICalc.PCTShare) as Money),1) + '% x ' else '' end +convert(varchar(25), Max(ICalc.NetRate),1) + Case When max(ICalc.FacProrata_Calculation)='' or Max(ICalc.FacProrata)=1 Then '' Else ' x ' + max(ICalc.FacProrata_Calculation) End
		else
			'- ' + convert(varchar(25), cast(sum(ICalc.PCTShare/100*Icalc.TSI*ICalc.PCTADJ/100) as Money),1) + ' x '+convert(varchar(25), Max(ICalc.NetRate),3)+'%' + Case When max(ICalc.FacProrata_Calculation)='' or Max(ICalc.FacProrata)=1 Then '' Else ' x ' + max(ICalc.FacProrata_Calculation) End + ' x '+convert(varchar(25), Max(ICalc.Share),3)+'%'    		
		end
   else    
		Case When Max(ICalc.Unit)='F' then
			'- ' + Case When Max(ICalc.PCTShare)<>100 Then convert(varchar(25), cast(Max(ICalc.PCTShare) as Money),1) + '% x ' else '' end +convert(varchar(25), Max(ICalc.NetRate),1) + Case When max(ICalc.FacProrata_Calculation)='' or Max(ICalc.FacProrata)=1 Then '' Else ' x ' + max(ICalc.FacProrata_Calculation) End     
		else
			'- ' + convert(varchar(25), cast(sum(ICalc.PCTShare/100*Icalc.TSI*ICalc.PCTADJ/100) as Money),1) + ' x '+convert(varchar(25), Max(ICalc.NetRate),3)+'%' + Case When max(ICalc.FacProrata_Calculation)='' or Max(ICalc.FacProrata)=1 Then '' Else ' x ' + max(ICalc.FacProrata_Calculation) End     		
		end
   end      
  end     
 End    
  +  
  Case When Max(ICalc.AType)='C' and Max(ICalc.EMethod)<>'A' and Max(ICalc.CPRefund)<>0 then ' x '+convert(varchar(25),Max(ICalc.CPRefund),3)+'%' else '' end     
From      
(Select ICalc.ANO, ICalc.INO, ICalc.Currency, ICalc.Code, ICalc.Sdate, ICalc.Edate, ICalc.PCTAdj,    
Max(FPart.Code) as FCode,
Max(D.FacProrata_Calculation) as FacProrata_calculation,    
Max(D.FacProrata) as FacProrata,     
SUM(Case When PCALC.Description<>'' and PCALC.Description<>'Minimum Premium' then ICALC.GROSS*PCALC.GROSS/PCALC.OGROSS else ICALC.GROSS*D.GROSS/D.OGROSS end) AS GROSS,          
AVG(ICalc.Prorata) as PProrata,     
Max(PCalc.Ourshare/PCalc.TSI*100) as PCTShare,     
Max(ICalc.SRate) as SRate,     
Max((Case When RArrDet.Limit*PCalc.TSI/PCalc.OurShare<>0 Then RArrDet.Limit*PCalc.TSI/PCalc.OurShare else ICalc.TSI end)) as TSI,     
SUM(ICalc.Rate) as Rate,     
Max(Case When RArrDet.PCalc='P' or datediff(month,RArrDet.SDate, RArrDet.EDate)=0 or Cover.Voyage=1 Then 1 else 12/cast(datediff(month,RArrDet.SDate, RArrDet.EDate) as float) end) as NetRateProrata,    
Max(FPart.NetRate*Case When RArrDet.PCalc='P' or datediff(month,RArrDet.SDate, RArrDet.EDate)=0 or Cover.Voyage=1 Then 1 else 12/cast(datediff(month,RArrDet.SDate, RArrDet.EDate) as float) end)/Max(I.RiskNum) as NetRate,    
Max(FPart.Unit) as Unit,
Max(RArrDet.Share) as Share,    
Max(RArrDet.FLPCT) as FLPCT,    
Max(RArrDet.CPRefund) as CPRefund,
Max(pAcceptance.AType) as AType,
Max(pAcceptance.EMethod) as EMethod,
Max(ICalc.sProrata) as sProrata,  
Max(Cast(RArrDet.OnGrossAfterCommF as Integer)) as OnGrossAfterCommF  
from ICalc, PCalc, (Select I.ANO, I.INO, I.Currency, I.SDate, I.EDate, Count(Distinct I.Code) as RiskNum from ICalc I, Acceptance A Where I.Gross<>0 and I.ANO=A.PANO and A.ANO=@P_ANO Group By I.ANO, I.INO, I.Currency, I.SDate, I.EDate) I, DISPLAY_FACULTATIVE_PRORATA_CALCULATION(@P_ANO, @P_FID) D, FPart, RArrDet, RArrDet pRArrDet, Acceptance pAcceptance, Acceptance, Cover    
Where pAcceptance.ANO=@P_ANO and Acceptance.ANO=pAcceptance.PANO and Cover.CNO=Acceptance.CNO and ICalc.ANO=Acceptance.ANO and ICalc.Rate<>0 and PCalc.ANO=ICalc.ANO and PCalc.Currency=ICalc.Currency    
and I.ANO=ICalc.ANO and I.INO=ICalc.INO and I.Currency=ICalc.Currency and I.SDate=ICalc.SDate and I.EDate=ICalc.EDate        
and D.ANO=ICalc.ANO and D.Currency=ICalc.Currency and D.Code=ICalc.Code and D.SDate=ICalc.Sdate and D.EDate=ICalc.EDate and D.TOR=ICalc.TOR    
and RArrDet.Status in ('A','R') and RArrDet.FullCoverF=1 and RArrDet.ANO=D.ANO and RArrDet.FID=@P_FID and FPart.ANO=RArrDet.ANO and FPart.FID=RArrdet.FID    
and pRArrDet.ANO=pAcceptance.ANO and pRArrDet.FID=@P_FID and pRArrDet.NoRefundF=0
Group By ICalc.ANO, ICalc.INO, ICalc.Currency, ICalc.Code, ICalc.SDate, ICalc.EDate, ICalc.PCTAdj    
) ICalc    
Group By ICalc.ANO, ICalc.Currency, ICalc.Code, ICalc.FCode, ICalc.SDate, ICalc.EDate, ICalc.SRate, ICalc.sProrata, ICalc.PCTadj                  
    
UNION ALL    

--3 Detail    
Select ICalc.ANO, ICalc.Currency, ICalc.Code, ICalc.FCode, ICalc.SDate, ICalc.EDate,   
Gross=    
Case     
 When Max(ICalc.NetRate)=0 then    
  case When Max(ICalc.FLPCT)=0 Then    
   sum(ICalc.PCTShare/100*ICalc.Gross*(Case When ICalc.OnGrossAfterCommF=1 Then (100-dbo.Premium_Commission(ICalc.ANO, ICalc.Code,0,0))/100 else 1 end)/Icalc.PProrata)*max(ICalc.FacProrata)*max(ICalc.Share)/100    
  else    
   sum(ICalc.PCTShare/100*ICalc.Gross*(Case When ICalc.OnGrossAfterCommF=1 Then (100-dbo.Premium_Commission(ICalc.ANO, ICalc.Code,0,0))/100 else 1 end)/Icalc.PProrata)*max(ICalc.FacProrata)    
  end    
 else    
  case When Max(ICalc.FLPCT)=0 Then    
	   Case When Max(ICalc.Unit)='F' Then
		Max(ICalc.PCTShare/100)*Max(ICalc.NetRate)*max(ICalc.FacProrata)
	   else
		sum(ICalc.PCTShare/100*Icalc.TSI*ICalc.PCTADJ/100)*Max(ICalc.NetRate)/100*max(ICalc.FacProrata)*max(ICalc.Share)/100   
	   end
  else    
	   Case When Max(ICalc.Unit)='F' Then
		Max(ICalc.PCTShare/100)*Max(ICalc.NetRate)*max(ICalc.FacProrata)       
	   else
		sum(ICalc.PCTShare/100*Icalc.TSI*ICalc.PCTADJ/100)*Max(ICalc.NetRate)/100*max(ICalc.FacProrata)       
	   end  
  end   
 end,     
Calculation=      
Case     
 When Max(ICalc.NetRate)=0 Then    
  case When Max(ICalc.FLPCT)=0 Then    
   convert(varchar(25), cast(sum(ICalc.PCTShare/100*ICalc.Gross*(Case When ICalc.OnGrossAfterCommF=1 Then (100-dbo.Premium_Commission(ICalc.ANO, ICalc.Code,0,0))/100 else 1 end)/ICalc.PProrata) as Money),1) + Case When max(ICalc.FacProrata_Calculation)='' or Max(ICalc.FacProrata)=1 Then '' Else ' x ' + max(ICalc.FacProrata_Calculation) End + ' x '+convert(varchar(25), Max(ICalc.Share),3)+'%'    
  else    
   convert(varchar(25), cast(sum(ICalc.PCTShare/100*ICalc.Gross*(Case When ICalc.OnGrossAfterCommF=1 Then (100-dbo.Premium_Commission(ICalc.ANO, ICalc.Code,0,0))/100 else 1 end)/ICalc.PProrata) as Money),1) + Case When max(ICalc.FacProrata_Calculation)='' or Max(ICalc.FacProrata)=1 Then '' Else ' x ' + max(ICalc.FacProrata_Calculation) End    
  end    
 else    
  Case When Max(ICalc.FacProrata*ICalc.NetRateProrata)=1 then    
   case When Max(ICalc.FLPCT)=0 Then    
		case When Max(ICalc.Unit)='F' Then
			Case When Max(ICalc.PCTShare)<>100 Then convert(varchar(25), cast(Max(ICalc.PCTShare) as Money),1) + '% x ' else '' end +convert(varchar(25), Cast(Max(ICalc.NetRate/ICalc.NetRateProrata) as Money),1) + Case When max(ICalc.FacProrata_Calculation)='' or Max(ICalc.FacProrata*ICalc.NetRateProrata)=1 Then '' Else ' x ' + max(ICalc.FacProrata_Calculation) End
		else
			convert(varchar(25), cast(sum(ICalc.PCTShare/100*Icalc.TSI*ICalc.PCTADJ/100) as Money),1) + ' x '+convert(varchar(25), cast(Max(ICalc.NetRate/ICalc.NetRateProrata) as Money),2)+'%' + Case When max(ICalc.FacProrata_Calculation)='' or Max(ICalc.FacProrata*ICalc.NetRateProrata)=1 Then '' Else ' x ' + max(ICalc.FacProrata_Calculation) End + ' x '+convert(varchar(25), Max(ICalc.Share),3)+'%'    
		end
   else 
		Case When Max(ICalc.Unit)='F' Then		   
			Case When Max(ICalc.PCTShare)<>100 Then convert(varchar(25), cast(Max(ICalc.PCTShare) as Money),1) + '% x ' else '' end +convert(varchar(25), Cast(Max(ICalc.NetRate/ICalc.NetRateProrata) as Money),1) + Case When max(ICalc.FacProrata_Calculation)='' or Max(ICalc.FacProrata*ICalc.NetRateProrata)=1 Then '' Else ' x ' + max(ICalc.FacProrata_Calculation) End     
		else
			convert(varchar(25), cast(sum(ICalc.PCTShare/100*Icalc.TSI*ICalc.PCTADJ/100) as Money),1) + ' x '+convert(varchar(25), cast(Max(ICalc.NetRate/ICalc.NetRateProrata) as Money),2)+'%' + Case When max(ICalc.FacProrata_Calculation)='' or Max(ICalc.FacProrata*ICalc.NetRateProrata)=1 Then '' Else ' x ' + max(ICalc.FacProrata_Calculation) End 		
		end
   end    
  else    
   case When Max(ICalc.FLPCT)=0 Then    
		Case When Max(ICalc.Unit)='F' Then
			Case When Max(ICalc.PCTShare)<>100 Then convert(varchar(25), cast(Max(ICalc.PCTShare) as Money),1) + '% x ' else '' end +convert(varchar(25), Max(ICalc.NetRate),1) + Case When max(ICalc.FacProrata_Calculation)='' or Max(ICalc.FacProrata)=1 Then '' Else ' x ' + max(ICalc.FacProrata_Calculation) End
		else
			convert(varchar(25), cast(sum(ICalc.PCTShare/100*Icalc.TSI*ICalc.PCTADJ/100) as Money),1) + ' x '+convert(varchar(25), Max(ICalc.NetRate),3)+'%' + Case When max(ICalc.FacProrata_Calculation)='' or Max(ICalc.FacProrata)=1 Then '' Else ' x ' + max(ICalc.FacProrata_Calculation) End + ' x '+convert(varchar(25), Max(ICalc.Share),3)+'%'    		
		end
   else    
		Case When Max(ICalc.Unit)='F' then
			Case When Max(ICalc.PCTShare)<>100 Then convert(varchar(25), cast(Max(ICalc.PCTShare) as Money),1) + '% x ' else '' end +convert(varchar(25), Max(ICalc.NetRate),1) + Case When max(ICalc.FacProrata_Calculation)='' or Max(ICalc.FacProrata)=1 Then '' Else ' x ' + max(ICalc.FacProrata_Calculation) End     
		else
			convert(varchar(25), cast(sum(ICalc.PCTShare/100*Icalc.TSI*ICalc.PCTADJ/100) as Money),1) + ' x '+convert(varchar(25), Max(ICalc.NetRate),3)+'%' + Case When max(ICalc.FacProrata_Calculation)='' or Max(ICalc.FacProrata)=1 Then '' Else ' x ' + max(ICalc.FacProrata_Calculation) End     		
		end
   end      
  end      
 End    
From      
(Select ICalc.ANO, ICalc.INO, ICalc.Currency, ICalc.Code, ICalc.Sdate, ICalc.Edate, ICalc.PCTAdj,    
Max(FPart.Code) as FCode,
Max(D.FacProrata_Calculation) as FacProrata_calculation,    
Max(D.FacProrata) as FacProrata,     
SUM(Case When PCALC.Description<>'' and PCALC.Description<>'Minimum Premium' then ICALC.GROSS*PCALC.GROSS/PCALC.OGROSS else ICALC.GROSS*D.GROSS/D.OGROSS end) AS GROSS,          
AVG(ICalc.Prorata) as PProrata,     
Max(PCalc.Ourshare/PCalc.TSI*100) as PCTShare,     
Max(ICalc.SRate) as SRate,     
Max((Case When RArrDet.Limit*PCalc.TSI/PCalc.OurShare<>0 Then RArrDet.Limit*PCalc.TSI/PCalc.OurShare else ICalc.TSI end)) as TSI,     
SUM(ICalc.Rate) as Rate,     
Max(Case When RArrDet.PCalc='P' or datediff(month,RArrDet.SDate, RArrDet.EDate)=0 or Cover.Voyage=1 Then 1 else 12/cast(datediff(month,RArrDet.SDate, RArrDet.EDate) as float) end) as NetRateProrata,    
Max(FPart.NetRate*Case When RArrDet.PCalc='P' or datediff(month,RArrDet.SDate, RArrDet.EDate)=0 or Cover.Voyage=1 Then 1 else 12/cast(datediff(month,RArrDet.SDate, RArrDet.EDate) as float) end) as NetRate,    
Max(FPart.Unit) as Unit,
Max(RArrDet.Share) as Share,    
Max(RArrDet.FLPCT) as FLPCT,    
Max(ICalc.sProrata) as sProrata,  
Max(Cast(RArrDet.OnGrossAfterCommF as Integer)) as OnGrossAfterCommF  
from ICalc, PCalc, DISPLAY_FACULTATIVE_PRORATA_CALCULATION(@P_ANO, @P_FID) D, FPartDet FPart, RateCov, RArrDet, Acceptance, Cover    
Where Acceptance.ANO=@P_ANO and Cover.CNO=Acceptance.CNO and ICalc.ANO=Acceptance.ANO and ICalc.Rate<>0 and PCalc.ANO=ICalc.ANO and PCalc.Currency=ICalc.Currency    
and D.ANO=ICalc.ANO and D.Currency=ICalc.Currency and D.SDate=ICalc.Sdate and D.EDate=ICalc.EDate and D.TOR=ICalc.TOR    
and RArrDet.FullCoverF=0 and RArrDet.ANO=D.ANO 
and RArrDet.FID=@P_FID and FPart.ANO=RArrDet.ANO and FPart.FID=RArrdet.FID and RateCov.Code=FPart.Code and RateCov.TOR=ICalc.TOR
and RArrDet.NoRefundF=0
Group By ICalc.ANO, ICalc.INO, ICalc.Currency, ICalc.Code, ICalc.SDate, ICalc.EDate, ICalc.PCTAdj 
) ICalc    
Group By ICalc.ANO, ICalc.Currency, ICalc.Code, ICalc.FCode, ICalc.SDate, ICalc.EDate, ICalc.SRate, ICalc.sProrata, ICalc.PCTadj      
    
UNION ALL    

--4 Refund/Endorsement Detail    
Select ICalc.ANO, ICalc.Currency, ICalc.Code, ICalc.FCode, ICalc.SDate, ICalc.EDate,  
Gross=-    
Case     
 When Max(ICalc.NetRate)=0 then    
  case When Max(ICalc.FLPCT)=0 Then    
   sum(ICalc.PCTShare/100*ICalc.Gross*(Case When ICalc.OnGrossAfterCommF=1 Then (100-dbo.Premium_Commission(ICalc.ANO, ICalc.Code,0,0))/100 else 1 end)/Icalc.PProrata)*max(ICalc.FacProrata)*max(ICalc.Share)/100    
  else    
   sum(ICalc.PCTShare/100*ICalc.Gross*(Case When ICalc.OnGrossAfterCommF=1 Then (100-dbo.Premium_Commission(ICalc.ANO, ICalc.Code,0,0))/100 else 1 end)/Icalc.PProrata)*max(ICalc.FacProrata)    
  end    
 else    
  case When Max(ICalc.FLPCT)=0 Then    
	   Case When Max(ICalc.Unit)='F' Then
		Max(ICalc.PCTShare/100)*Max(ICalc.NetRate)*max(ICalc.FacProrata)
	   else
		sum(ICalc.PCTShare/100*Icalc.TSI*ICalc.PCTADJ/100)*Max(ICalc.NetRate)/100*max(ICalc.FacProrata)*max(ICalc.Share)/100   
	   end
  else    
	   Case When Max(ICalc.Unit)='F' Then
		Max(ICalc.PCTShare/100)*Max(ICalc.NetRate)*max(ICalc.FacProrata)       
	   else
		sum(ICalc.PCTShare/100*Icalc.TSI*ICalc.PCTADJ/100)*Max(ICalc.NetRate)/100*max(ICalc.FacProrata)       
	   end  
  end  
 end
 * Case When Max(ICalc.AType)='C' and Max(ICalc.EMethod)<>'A' and Max(ICalc.CPRefund)<>0 then Max(ICalc.CPRefund)/100 else 1 end,
Calculation=      
Case     
 When Max(ICalc.NetRate)=0 Then    
  case When Max(ICalc.FLPCT)=0 Then    
   '- ' + convert(varchar(25), cast(sum(ICalc.PCTShare/100*ICalc.Gross*(Case When ICalc.OnGrossAfterCommF=1 Then (100-dbo.Premium_Commission(ICalc.ANO, ICalc.Code,0,0))/100 else 1 end)/ICalc.PProrata) as Money),1) + Case When max(ICalc.FacProrata_Calculation)='' or Max(ICalc.FacProrata)=1 Then '' Else ' x ' + max(ICalc.FacProrata_Calculation) End + ' x '+convert(varchar(25), Max(ICalc.Share),3)+'%'    
  else    
   '- ' + convert(varchar(25), cast(sum(ICalc.PCTShare/100*ICalc.Gross*(Case When ICalc.OnGrossAfterCommF=1 Then (100-dbo.Premium_Commission(ICalc.ANO, ICalc.Code,0,0))/100 else 1 end)/ICalc.PProrata) as Money),1) + Case When max(ICalc.FacProrata_Calculation)='' or Max(ICalc.FacProrata)=1 Then '' Else ' x ' + max(ICalc.FacProrata_Calculation) End    
  end    
 else    
  Case When Max(ICalc.FacProrata*ICalc.NetRateProrata)=1 then    
   case When Max(ICalc.FLPCT)=0 Then    
		case When Max(ICalc.Unit)='F' Then
			'- ' + Case When Max(ICalc.PCTShare)<>100 Then convert(varchar(25), cast(Max(ICalc.PCTShare) as Money),1) + '% x ' else '' end +convert(varchar(25), Cast(Max(ICalc.NetRate/ICalc.NetRateProrata) as Money),1) + Case When max(ICalc.FacProrata_Calculation)='' or Max(ICalc.FacProrata*ICalc.NetRateProrata)=1 Then '' Else ' x ' + max(ICalc.FacProrata_Calculation) End
		else
			'- ' + convert(varchar(25), cast(sum(ICalc.PCTShare/100*Icalc.TSI*ICalc.PCTADJ/100) as Money),1) + ' x '+convert(varchar(25), cast(Max(ICalc.NetRate/ICalc.NetRateProrata) as Money),2)+'%' + Case When max(ICalc.FacProrata_Calculation)='' or Max(ICalc.FacProrata*ICalc.NetRateProrata)=1 Then '' Else ' x ' + max(ICalc.FacProrata_Calculation) End + ' x '+convert(varchar(25), Max(ICalc.Share),3)+'%'    
		end
   else 
		Case When Max(ICalc.Unit)='F' Then		   
			'- ' + Case When Max(ICalc.PCTShare)<>100 Then convert(varchar(25), cast(Max(ICalc.PCTShare) as Money),1) + '% x ' else '' end +convert(varchar(25), Cast(Max(ICalc.NetRate/ICalc.NetRateProrata) as Money),1) + Case When max(ICalc.FacProrata_Calculation)='' or Max(ICalc.FacProrata*ICalc.NetRateProrata)=1 Then '' Else ' x ' + max(ICalc.FacProrata_Calculation) End     
		else
			'- ' + convert(varchar(25), cast(sum(ICalc.PCTShare/100*Icalc.TSI*ICalc.PCTADJ/100) as Money),1) + ' x '+convert(varchar(25), cast(Max(ICalc.NetRate/ICalc.NetRateProrata) as Money),2)+'%' + Case When max(ICalc.FacProrata_Calculation)='' or Max(ICalc.FacProrata*ICalc.NetRateProrata)=1 Then '' Else ' x ' + max(ICalc.FacProrata_Calculation) End 		
		end
   end    
  else    
   case When Max(ICalc.FLPCT)=0 Then    
		Case When Max(ICalc.Unit)='F' Then
			'- ' + Case When Max(ICalc.PCTShare)<>100 Then convert(varchar(25), cast(Max(ICalc.PCTShare) as Money),1) + '% x ' else '' end +convert(varchar(25), Max(ICalc.NetRate),1) + Case When max(ICalc.FacProrata_Calculation)='' or Max(ICalc.FacProrata)=1 Then '' Else ' x ' + max(ICalc.FacProrata_Calculation) End
		else
			'- ' + convert(varchar(25), cast(sum(ICalc.PCTShare/100*Icalc.TSI*ICalc.PCTADJ/100) as Money),1) + ' x '+convert(varchar(25), Max(ICalc.NetRate),3)+'%' + Case When max(ICalc.FacProrata_Calculation)='' or Max(ICalc.FacProrata)=1 Then '' Else ' x ' + max(ICalc.FacProrata_Calculation) End + ' x '+convert(varchar(25), Max(ICalc.Share),3)+'%'    		
		end
   else    
		Case When Max(ICalc.Unit)='F' then
			'- ' + Case When Max(ICalc.PCTShare)<>100 Then convert(varchar(25), cast(Max(ICalc.PCTShare) as Money),1) + '% x ' else '' end +convert(varchar(25), Max(ICalc.NetRate),1) + Case When max(ICalc.FacProrata_Calculation)='' or Max(ICalc.FacProrata)=1 Then '' Else ' x ' + max(ICalc.FacProrata_Calculation) End     
		else
			'- ' + convert(varchar(25), cast(sum(ICalc.PCTShare/100*Icalc.TSI*ICalc.PCTADJ/100) as Money),1) + ' x '+convert(varchar(25), Max(ICalc.NetRate),3)+'%' + Case When max(ICalc.FacProrata_Calculation)='' or Max(ICalc.FacProrata)=1 Then '' Else ' x ' + max(ICalc.FacProrata_Calculation) End     		
		end
   end      
  end
 End 
  +  
  Case When Max(ICalc.AType)='C' and Max(ICalc.EMethod)<>'A' and Max(ICalc.CPRefund)<>0 then ' x '+convert(varchar(25),Max(ICalc.CPRefund),3)+'%' else '' end        
From      
(Select ICalc.ANO, ICalc.INO, ICalc.Currency, ICalc.Code, ICalc.Sdate, ICalc.Edate, ICalc.PCTAdj,    
Max(FPart.Code) as FCode,
Max(D.FacProrata_Calculation) as FacProrata_calculation,    
Max(D.FacProrata) as FacProrata,     
SUM(Case When PCALC.Description<>'' and PCALC.Description<>'Minimum Premium' then ICALC.GROSS*PCALC.GROSS/PCALC.OGROSS else ICALC.GROSS*D.GROSS/D.OGROSS end) AS GROSS,          
AVG(ICalc.Prorata) as PProrata,     
Max(PCalc.Ourshare/PCalc.TSI*100) as PCTShare,     
Max(ICalc.SRate) as SRate,     
Max((Case When RArrDet.Limit*PCalc.TSI/PCalc.OurShare<>0 Then RArrDet.Limit*PCalc.TSI/PCalc.OurShare else ICalc.TSI end)) as TSI,     
SUM(ICalc.Rate) as Rate,     
Max(Case When RArrDet.PCalc='P' or datediff(month,RArrDet.SDate, RArrDet.EDate)=0 or Cover.Voyage=1 Then 1 else 12/cast(datediff(month,RArrDet.SDate, RArrDet.EDate) as float) end) as NetRateProrata,    
Max(FPart.NetRate*Case When RArrDet.PCalc='P' or datediff(month,RArrDet.SDate, RArrDet.EDate)=0 or Cover.Voyage=1 Then 1 else 12/cast(datediff(month,RArrDet.SDate, RArrDet.EDate) as float) end) as NetRate,    
Max(FPart.Unit) as Unit,
Max(RArrDet.Share) as Share,    
Max(RArrDet.FLPCT) as FLPCT,    
Max(RArrDet.CPRefund) as CPRefund,
Max(pAcceptance.AType) as AType,
Max(pAcceptance.EMethod) as EMethod,
Max(ICalc.sProrata) as sProrata,  
Max(Cast(RArrDet.OnGrossAfterCommF as Integer)) as OnGrossAfterCommF  
from ICalc, PCalc, DISPLAY_FACULTATIVE_PRORATA_CALCULATION(@P_ANO, @P_FID) D, FPartDet FPart, RateCov, RArrDet, RArrDet pRArrDet, Acceptance pAcceptance, Acceptance, Cover    
Where pAcceptance.ANO=@P_ANO and Acceptance.ANO=pAcceptance.PANO and Cover.CNO=Acceptance.CNO and ICalc.ANO=Acceptance.ANO and ICalc.Rate<>0 and PCalc.ANO=ICalc.ANO and PCalc.Currency=ICalc.Currency    
and D.ANO=ICalc.ANO and D.Currency=ICalc.Currency and D.SDate=ICalc.Sdate and D.EDate=ICalc.EDate and D.TOR=ICalc.TOR    
and RArrDet.Status in ('A','R') and RArrDet.FullCoverF=0 and RArrDet.ANO=D.ANO 
and RArrDet.FID=@P_FID and FPart.ANO=RArrDet.ANO and FPart.FID=RArrdet.FID and RateCov.Code=FPart.Code and RateCov.TOR=ICalc.TOR
and pRArrDet.ANO=pAcceptance.ANO and pRArrDet.FID=@P_FID and pRArrDet.NoRefundF=0
Group By ICalc.ANO, ICalc.INO, ICalc.Currency, ICalc.Code, ICalc.SDate, ICalc.EDate, ICalc.PCTAdj 
) ICalc
Group By ICalc.ANO, ICalc.Currency, ICalc.Code, ICalc.FCode, ICalc.SDate, ICalc.EDate, ICalc.SRate, ICalc.sProrata, ICalc.PCTadj        
    
)            

GO

DROP function OS_VOUCHER_M 
GO
CREATE function OS_VOUCHER_M (@P_Voucher Varchar(20))    
RETURNS Table    
AS RETURN    
(    
SELECT VOUCHER.VOUCHER, VOUCHER.DATE, VOUCHER.CURRENCY, VOUCHER.PROACC, VOUCHER.DEBTORF,VOUCHER.CREDITORF,VOUCHER.SL_CAT,    
VOUCHER.BRANCH, VOUCHER.REFNO,VOUCHER.REFDATE, VOUCHER.DOCNO,VOUCHER.VTYPE, VOUCHER.REMARKS, VOUCHER.REFTYPE, VOUCHER.ACCOUNTNO, '  ' as A_RefNo,    
VOUCHER.NOMINAL_CC-VOUCHER.DIFF_CC AS NOMINAL,    
CASE WHEN VP.VOUCHER IS NULL THEN VOUCHER.PAYMENT_CC ELSE VOUCHER.NOMINAL_CC-VOUCHER.DIFF_CC-VP.NOMINAL END AS PAYMENT,    
CASE WHEN VP.VOUCHER IS NULL THEN VOUCHER.NOMINAL_CC-VOUCHER.DIFF_CC-VOUCHER.PAYMENT_CC ELSE VP.NOMINAL END AS OUTSTANDING,  
'' AS ACCOUNT,
cast(0 as Smallint) as HINT  
FROM NVoucher VOUCHER    
INNER JOIN VTYPE ON (VTYPE.VTYPE=VOUCHER.VTYPE)    
LEFT JOIN PAID_VOUCHER_N(@P_Voucher) VP ON(VOUCHER.VOUCHER=VP.VOUCHER)    
WHERE Voucher.SL_Tag=1	-- Manual Voucher
AND VOUCHER.INVESTMENTF=0 AND VTYPE.TAXF=0 AND VOUCHER.REQUESTF=0 AND ROUND(CASE WHEN VP.VOUCHER IS NULL THEN VOUCHER.NOMINAL_CC-VOUCHER.DIFF_CC-VOUCHER.PAYMENT_CC ELSE VP.NOMINAL END,4)<>0    
)    
       
GO


DROP Procedure [dbo].[QCheckMaxOutGo]
GO
CREATE Procedure [dbo].[QCheckMaxOutGo](@P_ANO as integer) 
as 
Declare @Temp Table(ANO Int, Code varchar(10), PrevOutGo Float, OutGo Float) 
 
insert into @Temp(ANO, Code, PrevOutGo, OutGo) 
Select Distinct R1.ANO, R1.Code, dbo.Premium_MaxOutGo(A.PANO, R1.Code,0) as PrevOutGo, dbo.Premium_MaxOutGo(A.ANO, R1.Code,0) as OutGo from Acceptance A, RCover R1 Where R1.ANO=A.ANO and A.ANO=@P_ANO 
 
Select R1.ANO, 
Case 
When R1.OutGo>R2.MaxOutGo Then 'Rate Code ('+R1.Code+') Maximum Out Go !' 
When R1.OutGo>BS.MaxOutGo Then 'Business Source ('+BS.ID+') Maximum Out Go !' 
When R1.OutGo>BR.MaxOutGo Then 'Business Rule ('+BR.BizMapID+') Maximum Out Go !' 
End as ErrDesc 
from @Temp R1
Inner Join Acceptance A on (A.ANO=R1.ANO)
Inner Join RArrHeader R on (R.ANO=A.ANO) 
Inner Join Cover C on (C.CNO=A.CNO) 
Inner join Profile BS on (BS.ID=A.Source) 
Inner join RateTab R2 on (R2.Code=R1.Code) 
Left Join BRRule BR on (BR.TOC=A.TOC and (BR.Branch='<All>' or BR.Branch=A.Branch) and (BR.BizmapID='<All>' or BR.BizMapID=A.BizMapID) and (BR.FacOpt=0 or (BR.FacOpt=1 and R.FAmount<>0) or (BR.FacOpt=2 and R.FAmount=0))) 
Where R1.PrevOutGo<R1.OutGo 
and ((R2.MaxOutGo<>0 and R1.OutGo>R2.MaxOutGo+0.0000000001) Or (BS.MaxOutGo<>0 and R1.OutGo>BS.MaxOutGo+0.0000000001) Or (BR.MaxOutGo<>0 and R1.OutGo>BR.MaxOutGo+0.0000000001)) 


GO

DROP Function Premium_Treaty_Overriding
GO
CREATE Function Premium_Treaty_Overriding(@P_ANO as int,@P_Code as varchar(10),@P_Period Int, @P_MinimumPremiumF Bit)                
RETURNS Float                
AS                
BEGIN                
 Declare @GDiscount Float                
 Declare @PDiscount Float                
 Declare @Discount Float                
 Declare @RDiscount Float                
 Declare @ADiscount Float                
 Declare @MShare Float                
 Declare @Commission Float        
 Declare @DetailF bit               
 Declare @RegNo varchar(20)        
 Declare @AStatus varchar(1)        
 Declare @LANO int   
 Declare @OANO int
 Declare @GrossUpComm Float      
      
 select @ADiscount=Acceptance.Discount, @RegNo=Acceptance.RegNo, @Astatus=Acceptance.AStatus, @LANO=Acceptance.LANO, @OANO=Acceptance.OANO from Acceptance, Cover Where Cover.CNO=Acceptance.CNO and Acceptance.ANO=@P_ANO                                     
       
 Select @GDiscount=GDiscount, @PDiscount=PDiscount, @Discount=Discount from Payor_Discount(@P_ANO,@P_Code,@P_Period)        
 Select @RDiscount=dbo.Rate_Discount(@P_ANO)                
 Select @MShare=dbo.Member_Share(@P_ANO)                                     
 
 if @LANO=-1	
 BEGIN
	  Select @GrossUpComm=sum(Case When GrossUpF=1 Then coalesce(AccBSDet.Fee,AccBS.Fee)+UpFee else NetFee+UpFee end)   
	  from Acceptance   
	  inner join AccBS on (AccBS.ANO=Acceptance.ANO)   
	  Left Join AccBSDet on ((AccBSDet.Period=0 or AccBSDet.Period=@P_Period) and AccBSDet.ID=AccBS.ID and AccBSDet.BSType=AccBS.BSType and AccBSDet.ANO=AccBS.ANO and AccBSDet.Code=@P_Code)  
	  Where Acceptance.ANO=@P_ANO and (AccBS.GrossUpF=1 or AccBS.NetUpF=1)  
          
	  if @GrossUpComm is null    
		 Select @GrossUpComm=0              
		 
	  Select @Commission=        
	   sum(  
	   (  
		Case When AccBS.GrossF=1 then  
			coalesce(AccBSDet.Fee,AccBS.Fee)*100/(100-@RDiscount)  
		else  
			coalesce(AccBSDet.Fee,AccBS.Fee)  
		end *  
		(  
		 (Case When AccBS.NetF=1 then (1-@Discount/100) When AccBS.NetGroupF=1 then (1-@GDiscount/100) else 1 end)  
		*  
		 (1-(Case When AccBS.GrossUpF=0 and AccBS.NetUpF=0 Then (@GrossUpComm)/100 else 0 end))    
		 )  
		+(-(Case When @ADiscount=0 then AccBS.Discount else @ADiscount end)+AccBS.UpFee)*(Case When AccBS.GrossUpF=0 and AccBS.NetUpF=0 Then (100-@GrossUpComm)/100 else 1 end)     
	   )*(Case When AccBS.MemberF=1 Then (1-@MShare/100) else 1 end)*(Case When Profile.VatF=1 Then 1+MParam.Vat/100 else 1 end)   
	   )     
	  From Acceptance
	  Inner Join AccBS on (AccBS.ANO=Acceptance.ANO)
	  Left Join AccBSDet on ((AccBSDet.Period=0 or AccBSDet.Period=@P_Period) and AccBSDet.ID=AccBS.ID and AccBSDet.BSType=AccBS.BSType and AccBSDet.ANO=AccBS.ANO and AccBSDet.Code=@P_Code),
	  MParam, Profile                
	  Where Acceptance.ANO=@P_ANO 
	  and MParam.Type='B'+AccBS.BSType and (AccBS.BSType='O' or AccBS.TreatyOverridingF=1) and Profile.ID=AccBS.ID          
	  and (AccBS.NotMinimumPremiumF=0 or (AccBS.NotMinimumPremiumF=1 and @P_MinimumPremiumF=0))                   
 END
 ELSE
 BEGIN
	 Select Top 1 @DetailF=1 from AAccBS Where ANO=@P_ANO                        
	 if @DetailF is null         
	 Begin
		if @RegNo='' or @AStatus in ('W','T')   
		Begin	
		  Select @GrossUpComm=sum(Case When GrossUpF=1 Then coalesce(AccBSDet.Fee,AccBS.Fee)+UpFee else NetFee+UpFee end)   
		  from Acceptance   
		  Inner Join Acceptance mAcceptance on (mAcceptance.ANO=mAcceptance.LANO and mAcceptance.ANO=Acceptance.LANO)		  
		  inner join AccBS on (AccBS.ANO=mAcceptance.ANO)   
		  Left Join AccBSDet on ((AccBSDet.Period=0 or AccBSDet.Period=@P_Period) and AccBSDet.ID=AccBS.ID and AccBSDet.BSType=AccBS.BSType and AccBSDet.ANO=AccBS.ANO and AccBSDet.Code=@P_Code)  
		  Where Acceptance.ANO=@P_ANO and (AccBS.GrossUpF=1 or AccBS.NetUpF=1)  		

		  if @GrossUpComm is null    
			 Select @GrossUpComm=0              
		  
		  Select @Commission=        
		   sum(  
		   (  
			Case When AccBS.GrossF=1 then  
				coalesce(AccBSDet.Fee,AccBS.Fee)*100/(100-@RDiscount)  
			else  
				coalesce(AccBSDet.Fee,AccBS.Fee)  
			end *  
			(  
			 (Case When AccBS.NetF=1 then (1-@Discount/100) When AccBS.NetGroupF=1 then (1-@GDiscount/100) else 1 end)  
			*  
			 (1-(Case When AccBS.GrossUpF=0 and AccBS.NetUpF=0 Then (@GrossUpComm)/100 else 0 end))    
			 )  
			+(-(Case When @ADiscount=0 then AccBS.Discount else @ADiscount end)+AccBS.UpFee)*(Case When AccBS.GrossUpF=0 and AccBS.NetUpF=0 Then (100-@GrossUpComm)/100 else 1 end)     
		   )*(Case When AccBS.MemberF=1 Then (1-@MShare/100) else 1 end)*(Case When Profile.VatF=1 Then 1+MParam.Vat/100 else 1 end)   
		   )     
		  From Acceptance
		  Inner Join Acceptance mAcceptance on (mAcceptance.ANO=mAcceptance.LANO and mAcceptance.ANO=Acceptance.LANO)		  		  
		  Inner Join AccBS on (AccBS.ANO=mAcceptance.ANO)
		  Left Join AccBSDet on ((AccBSDet.Period=0 or AccBSDet.Period=@P_Period) and AccBSDet.ID=AccBS.ID and AccBSDet.BSType=AccBS.BSType and AccBSDet.ANO=AccBS.ANO and AccBSDet.Code=@P_Code),
		  MParam, Profile                
		  Where Acceptance.ANO=@P_ANO 
		  and MParam.Type='B'+AccBS.BSType and (AccBS.BSType='O' or AccBS.TreatyOverridingF=1) and Profile.ID=AccBS.ID          
		  and (AccBS.NotMinimumPremiumF=0 or (AccBS.NotMinimumPremiumF=1 and @P_MinimumPremiumF=0))                   		  		  
		end
		else
		Begin
		  Select @GrossUpComm=sum(Case When GrossUpF=1 Then coalesce(AccBSDet.Fee,AccBS.Fee)+UpFee else NetFee+UpFee end)   
		  from Acceptance   
		  Inner Join Acceptance mAcceptance on (mAcceptance.ANO=mAcceptance.LANO and ((mAcceptance.RegNo<>'' and mAcceptance.RegNo=Acceptance.RegNo)))
		  inner join AccBS on (AccBS.ANO=mAcceptance.ANO)   
		  Left Join AccBSDet on ((AccBSDet.Period=0 or AccBSDet.Period=@P_Period) and AccBSDet.ID=AccBS.ID and AccBSDet.BSType=AccBS.BSType and AccBSDet.ANO=AccBS.ANO and AccBSDet.Code=@P_Code)  
		  Where Acceptance.ANO=@P_ANO and (AccBS.GrossUpF=1 or AccBS.NetUpF=1)  		

		  if @GrossUpComm is null    
			 Select @GrossUpComm=0              
		  
		  Select @Commission=        
		   sum(  
		   (  
			Case When AccBS.GrossF=1 then  
				coalesce(AccBSDet.Fee,AccBS.Fee)*100/(100-@RDiscount)  
			else  
				coalesce(AccBSDet.Fee,AccBS.Fee)  
			end *  
			(  
			 (Case When AccBS.NetF=1 then (1-@Discount/100) When AccBS.NetGroupF=1 then (1-@GDiscount/100) else 1 end)  
			*  
			 (1-(Case When AccBS.GrossUpF=0 and AccBS.NetUpF=0 Then (@GrossUpComm)/100 else 0 end))    
			 )  
			+(-(Case When @ADiscount=0 then AccBS.Discount else @ADiscount end)+AccBS.UpFee)*(Case When AccBS.GrossUpF=0 and AccBS.NetUpF=0 Then (100-@GrossUpComm)/100 else 1 end)     
		   )*(Case When AccBS.MemberF=1 Then (1-@MShare/100) else 1 end)*(Case When Profile.VatF=1 Then 1+MParam.Vat/100 else 1 end)   
		   )     
		  From Acceptance
		  Inner Join Acceptance mAcceptance on (mAcceptance.ANO=mAcceptance.LANO and ((mAcceptance.RegNo<>'' and mAcceptance.RegNo=Acceptance.RegNo)))
		  Inner Join AccBS on (AccBS.ANO=mAcceptance.ANO)
		  Left Join AccBSDet on ((AccBSDet.Period=0 or AccBSDet.Period=@P_Period) and AccBSDet.ID=AccBS.ID and AccBSDet.BSType=AccBS.BSType and AccBSDet.ANO=AccBS.ANO and AccBSDet.Code=@P_Code),
		  MParam, Profile                
		  Where Acceptance.ANO=@P_ANO 
		  and MParam.Type='B'+AccBS.BSType and (AccBS.BSType='O' or AccBS.TreatyOverridingF=1) and Profile.ID=AccBS.ID          
		  and (AccBS.NotMinimumPremiumF=0 or (AccBS.NotMinimumPremiumF=1 and @P_MinimumPremiumF=0))    		  		
		end
	 end
	 else
	 Begin
		  Select @GrossUpComm=sum(Case When GrossUpF=1 Then coalesce(AAccBSDet.Fee,AAccBS.Fee)+UpFee else NetFee+UpFee end)   
		  From AAccBS Left Join AAccBSDet on ((AAccBSDet.Period=0 or AAccBSDet.Period=@P_Period) and AAccBSDet.ID=AAccBS.ID and AAccBSDet.BSType=AAccBS.BSType and AAccBSDet.ANO=AAccBS.ANO and AAccBSDet.Code=@P_Code)   
		  Where AAccBS.ANO=@P_ANO and (AAccBS.GrossUpF=1 or AAccBS.NetUpF=1)    	 
		  
		  if @GrossUpComm is null    
			 Select @GrossUpComm=0              		  
			 
		  Select @Commission=        
		   sum(  
		   (  
			Case When AccBS.GrossF=1 then  
				coalesce(AccBSDet.Fee,AccBS.Fee)*100/(100-@RDiscount)  
			else  
				coalesce(AccBSDet.Fee,AccBS.Fee)  
			end *  
			(  
			 (Case When AccBS.NetF=1 then (1-@Discount/100) When AccBS.NetGroupF=1 then (1-@GDiscount/100) else 1 end)  
			*  
			 (1-(Case When AccBS.GrossUpF=0 and AccBS.NetUpF=0 Then (@GrossUpComm)/100 else 0 end))    
			 )  
			+(-(Case When @ADiscount=0 then AccBS.Discount else @ADiscount end)+AccBS.UpFee)*(Case When AccBS.GrossUpF=0 and AccBS.NetUpF=0 Then (100-@GrossUpComm)/100 else 1 end)     
		   )*(Case When AccBS.MemberF=1 Then (1-@MShare/100) else 1 end)*(Case When Profile.VatF=1 Then 1+MParam.Vat/100 else 1 end)   
		   )     
		  From Acceptance
		  Inner Join AAccBS AccBS on (AccBS.ANO=Acceptance.ANO)
		  Left Join AAccBSDet AccBSDet on ((AccBSDet.Period=0 or AccBSDet.Period=@P_Period) and AccBSDet.ID=AccBS.ID and AccBSDet.BSType=AccBS.BSType and AccBSDet.ANO=AccBS.ANO and AccBSDet.Code=@P_Code),
		  MParam, Profile                
		  Where Acceptance.ANO=@P_ANO 
		  and MParam.Type='B'+AccBS.BSType and (AccBS.BSType='O' or AccBS.TreatyOverridingF=1) and Profile.ID=AccBS.ID          
		  and (AccBS.NotMinimumPremiumF=0 or (AccBS.NotMinimumPremiumF=1 and @P_MinimumPremiumF=0))                      
	 end
 
 END
                        
 if @Commission is null                
   Select @Commission=0                
                        
 return(@Commission)                
End        

GO


DROP PROCEDURE View05L1 
GO
CREATE PROCEDURE View05L1 (@p_ANO as integer)    
AS    

Select ANO, Currency, sum(Rate) as Rate, sum(TSI) as TSI, sum(OurShare) as OurShare, sum(Gross) as Gross, sum(CRate) as CRate, sum(Premium) as Premium, sum(Discount) as Discount, sum(Commission) as Commission, sum(Vat) as Vat, sum(Tax) as Tax, sum(FeeDuty
) as FeeDuty    
      
From    
(    
SELECT @P_ANO as ANO, P2.Currency, max(coalesce(P1.Rate,0)) as Rate, max(coalesce(P1.TSI,0)) as TSI, max(coalesce(P1.OurShare,0)) as OurShare, Max(coalesce(P1.Gross,0)) as Gross, max(coalesce(P1.CRate,0)) as CRate, sum(P2.Premium) as Premium, sum(P2.Discount) as Discount, sum(P2.Commission) as Commission, sum(P2.Vat) as Vat, sum(P2.Tax) as Tax, sum(P2.FeeDuty) as FeeDuty   
FROM PREMIUM_CALCULATION(@P_ANO) P2 Left Join PCalc P1 On (P2.ANO=P1.ANO and P2.Currency=P1.Currency)    
Group By P2.Currency    
                     
Union All          

Select @P_ANO as ANO, AccFD.Currency, 0 as Rate, 0 as TSI, 0 as OurShare, 0 as Gross, 0 as CRate, 0 as Premium, 0 as Discount, 0 as Commission, 0 as Vat, 0 as Tax, 
Case 
When FDTab.FDType<>'O' Then (ACCFD.Amount)
Else -(ACCFD.Amount) End as FeeDuty
from Acceptance A, PCalc P, AccFD, FDTab
Where A.ANO=@P_ANO and AccFD.ANO=A.ANO and P.ANO=AccFD.ANO and P.Currency=AccFD.Currency and FDTab.FDID=AccFD.FDID
and AccFD.Amount<>0

Union All

Select @P_ANO as ANO, AccFD.Currency, 0 as Rate, 0 as TSI, 0 as OurShare, 0 as Gross, 0 as CRate, 0 as Premium, 0 as Discount, 0 as Commission, 0 as Vat, 0 as Tax, 
Case 
When FDTab.FDType<>'O' Then 
	  ((D1.Gross-D1.Discount)*D1.Prorata*P.Gross/P.OGross*P.OurShare/P.TSI*(100-R.MSHARE)/100*AccFD.AmountPCT/100)
Else
      -(D1.Gross*P.Gross/P.OGross*P.OurShare/P.TSI*(100-R.MSHARE)/100*AccFD.AmountPCT/100) 		  
End 
as FeeDuty
from Display_Calculation(@P_ANO) D1, Acceptance A, PCalc P, AccFD, FDTab, RArrHeader R
Where P.ANO=D1.ANO and P.Currency=D1.Currency and A.ANO=D1.ANO and R.ANO=A.ANO
and AccFD.ANO=A.ANO and AccFD.Currency=D1.Currency and FDTab.FDID=AccFD.FDID
and (D1.ANO=@P_ANO or FDTab.FDType<>'O')
and AccFD.Amount=0            
) P    
Group By ANO, Currency    


GO

DROP Procedure Get_Fee_Amount_By_Percentage
GO
Create Procedure Get_Fee_Amount_By_Percentage(@P_ANO as Int, @P_Code as varchar(10), @P_FDType as varchar(1), @P_AmountPCT as Float)
as

Declare @P_LANO as integer
Declare @P_REGNO as varchar(20)
Declare @P_Fee as Float

Select @P_LANO=LANO, @P_REGNO=REGNO from Acceptance Where ANO=@P_ANO

if @P_LANO<>@P_ANO -- Individual or Certificate
		Select 
		@P_FEE=
		Case 
		When @P_FDTYPE<>'O' Then 
			 sum((D1.Gross-D1.Discount)*D1.Prorata*P.Gross/P.OGross*P.OurShare/P.TSI*(100-R.MSHARE)/100)
	    Else
			 sum(D1.Gross*P.Gross/P.OGross*P.OurShare/P.TSI*(100-R.MSHARE)/100)
		End*@P_AmountPCT/100
		from Display_Calculation(@P_ANO) D1, Acceptance A, PCalc P, RARRHEADER R
		Where P.ANO=A.ANO and P.Currency=D1.Currency and A.ANO=D1.ANO and R.ANO=A.ANO and D1.Currency=@P_Code
		and (D1.ANO=@P_ANO or @P_FDTYPE<>'O')
ELSE	-- Fleet Only
		SELECT @P_FEE=SUM(FEE)
		FROM
		(
			SELECT
			ACCEPTANCE.ANO,
			(
				Select 
				Case 
				When @P_FDTYPE<>'O' Then 
				    sum((D1.Gross-D1.Discount)*D1.Prorata*P.Gross/P.OGross*P.OurShare/P.TSI*(100-R.MSHARE)/100)
				ELSE 
					sum(D1.Gross*P.Gross/P.OGross*P.OurShare/P.TSI*(100-R.MSHARE)/100)
				End*@P_AmountPCT/100
				from Display_Calculation(ACCEPTANCE.ANO) D1, Acceptance A, PCalc P, RARRHEADER R
				Where P.ANO=A.ANO and P.Currency=D1.Currency and A.ANO=D1.ANO and R.ANO=A.ANO and D1.Currency=@P_Code
				and (D1.ANO=ACCEPTANCE.ANO or @P_FDTYPE<>'O')
			) as FEE
			FROM ACCEPTANCE, COVER
			WHERE COVER.CNO=ACCEPTANCE.CNO AND COVER.OPENFLAG=0 AND ACCEPTANCE.ANO<>ACCEPTANCE.LANO AND ACCEPTANCE.LANO=@P_ANO AND ACCEPTANCE.REGNO=@P_REGNO
		) A

SELECT @P_FEE AS FEE


GO

DROP Procedure BALANCE_ACCASS
GO
CREATE Procedure BALANCE_ACCASS(@P_ANO integer)              
as              
SELECT A3.LANO, A1.ACNO, A1.BizmapID, A2.AType, A1.Type,A1.ID, A1.Code,       
Case When A2.AType='A' then A1.Amount_OC else A1.CAmount end as CAmount,       
A1.Currency_OC, A1.Rate, A1.Currency, A1.TOC, A1.PolicyNo, A1.Remarks, A1.Prorata, A1.SDate, A1.EDate, A1.Date, A1.BillDate, A1.PProrata, A1.DocNo, A1.RefNo, A1.AdjustableF, A1.RCode, A2.SDATE AS PSDATE, A2.EDATE AS PEDATE,       
CASE WHEN R1.NOREFUNDF=1 THEN R1.NOREFUNDF ELSE COALESCE(R2.NOREFUNDF,COALESCE(COALESCE(A5.NOREFUNDF,COALESCE(A4.NOREFUNDF,A6.NOREFUNDF)),CAST(0 as BIT))) END AS NOREFUNDF,      
Case When A3.AType='C' and A3.EMethod<>'A' and Not R2.CPRefund is null then R2.CPRefund When A3.AType='C' and A3.EMethod<>'A' and A1.Type in ('DI','IC','IR','BB','BA','BO','BC','OP') Then R1.CPRefund else 0 end as CPRefund,    
A1.ADJMETHOD, A1.Source, A1.CommPoolF
FROM ACCASS A1       
INNER JOIN ACCEPTANCE A2 ON (A1.ANO=A2.ANO)       
INNER JOIN ACCEPTANCE A3 ON (A3.PANO=A2.ANO AND A3.AType<>'A')       
Left Join RCover R1 on (R1.ANO=A3.ANO and R1.Code=A1.RCode and R1.SDate=A1.SDate)              
Left Join ACCBS A4 on (A4.ANO=A3.ANO and A4.ID=A1.ID and 'B'+A4.BSType=A1.Type)      
Left Join AACCBS A5 on (A5.ANO=A3.ANO and A5.ID=A1.ID and 'B'+A5.BSType=A1.Type)     
Left Join ACCBS A6 on (A6.ANO=A3.LANO and A6.ID=A1.ID and 'B'+A6.BSType=A1.Type)       
Left Join FPart F on (F.ANO=A3.ANO and F.SlipNo=A1.RefNo and F.ID=A1.ID)    
Left Join RArrDet R2 on (R2.ANO=A3.ANO and R2.FID=F.FID and ((R2.RType='F' and A1.Type='FO') or R2.RType=A1.Type) and R2.Status<>'O')    
WHERE A2.ANO=@P_ANO AND (A1.CAMOUNT<>0 OR A2.AType='A')   
AND Not (A1.TYPE in ('DI','OP') AND A1.CODE IN ('D','F') or A1.TYPE in ('IC') AND A1.CODE IN ('D'))              
AND A1.TYPE NOT in ('PD') AND A1.CODE NOT IN ('J') 


GO

DROP PROCEDURE QCLACC_4 
GO
CREATE PROCEDURE QCLACC_4 (@P_POLICYNO AS VARCHAR(255), @P_CERTIFICATENO AS VARCHAR(255), @P_DATE AS DATETIME, @P_LOSSTIME as varchar(5)='12:00')   
AS   
SELECT top 100 Acceptance.ANO, Acceptance.AName, Acceptance.PDate, Acceptance.PPDate, Acceptance.NCDate
From ACCEPTANCE, COVER   
WHERE COVER.CNO=ACCEPTANCE.CNO AND COVER.CStatus not in ('R','P','C') AND ACCEPTANCE.AType Not in ('A','C') AND ACCEPTANCE.AStatus not in ('W','T') AND ACCEPTANCE.ANO<>ACCEPTANCE.LANO   
AND ACCEPTANCE.POLICYNO LIKE @P_POLICYNO AND ACCEPTANCE.CERTIFICATENO LIKE @P_CERTIFICATENO   
AND (
(ACCEPTANCE.PDATE<=@P_DATE AND ACCEPTANCE.ExclusiveF=1) or 
 ((ACCEPTANCE.PDATE<@P_DATE or (ACCEPTANCE.PDATE=@P_DATE AND ACCEPTANCE.STIME<=@P_LOSSTIME)) AND ACCEPTANCE.ExclusiveF=0)
 )             
AND 
(
(dbo.fn_Get_ExtPeriodDate(ACCEPTANCE.ExtPeriod, ACCEPTANCE.ExtPeriodInDaysF, ACCEPTANCE.PPDATE)>@P_DATE AND ACCEPTANCE.ExclusiveF=1) or 
((dbo.fn_Get_ExtPeriodDate(ACCEPTANCE.ExtPeriod, ACCEPTANCE.ExtPeriodInDaysF, ACCEPTANCE.PPDATE)>@P_DATE or 
(dbo.fn_Get_ExtPeriodDate(ACCEPTANCE.ExtPeriod, ACCEPTANCE.ExtPeriodInDaysF, ACCEPTANCE.PPDATE)=@P_DATE AND ACCEPTANCE.ETIME>@P_LOSSTIME)) AND ACCEPTANCE.ExclusiveF=0)
)        

Order By ACCEPTANCE.ANO Desc   


GO

DROP Procedure QCheckObjectClaimed
GO
CREATE Procedure QCheckObjectClaimed(@P_ClaimNo varchar(20), @P_PolicyNo varchar(20), @P_CertificateNo varchar(20),@P_LossDate smalldatetime='01/01/2007', @P_COL varchar(10)='', @P_Location varchar(10)='')   
as   
select C1.ClaimNo, C1.LossDate,  C1.PolicyNo+case When C1.CertificateNo='' then '' else '-'+C1.CertificateNo end as PolicyNo, C1.CStatus, C1.CNO, C1.ANO, P1.Name as Claimant, c2.DESCRIPTION as 'COL', L.location   
FROM   
(   
 select C1.OCNO, Max(C1.CNO) as CNO   
 from Claim C1   
 Where C1.ClaimNo<>@P_ClaimNo and C1.PolicyNo=@P_PolicyNo and C1.CertificateNo=@P_CertificateNo and C1.LossDate between dateadd(day,-14,@P_LossDate) and dateadd(day,14,@P_LossDate)   
 and not (C1.CStatus='C') -- not Close Claim
 and not ((C1.CStatus='A' or C1.pCStatus='A') and C1.CType='C')  --not Claim Cancellation
 and (@P_COL='' or C1.COL=@P_COL)   
 and (@P_Location='' or C1.location=@P_Location)   
 Group By C1.OCNO   
) C   
Inner Join Claim C1 on (C1.CNO=C.CNO)   
Inner Join Profile P1 on (P1.ID=C1.Claimant)   
Inner Join COLTAB C2 on (C2.COL=C1.COL)   
Left Join Location L on (L.Location=C1.Location)   
   
GO

DROP FUNCTION fn_RateCon
GO
CREATE FUNCTION fn_RateCon(@P_ANO as int,@P_Code as varchar(20),@P_TSI as Float=0)       
RETURNS Table       
AS RETURN (       
Select Top 1 *
From
(
	SELECT Top 1 RateTab.Code, cast(0 as Bit) as ProgressiveF, RateCon.AllowedF, RateCon.MinRate, RateCon.MaxRate, RateCon.PML, RateCon.TExcess, RateTab.RateLoadingF,       
	Case When coalesce(RateCon.Loading,0)=0 Then 100 else RateCon.Loading end as Loading,       
	Case When coalesce(RateCon.PCTLOSS,0)=0 Then 100 else RateCon.PCTLOSS end as PCTLOSS,       
	--Rate Always in Percent       
	Case       
	When RateCon.Unit='F' then (Case When (Case When @P_TSI=0 Then 1 Else @P_TSI End)<>0 Then RateCon.Rate/(Case When @P_TSI=0 Then 1 Else @P_TSI End)*100 else 0 end)       
	When RateCon.Unit='M' then RateCon.Rate/10       
	else RateCon.Rate end as Rate,       
	RateCon.MaxTSI as MaxTSI     
	From Acceptance       
	INNER JOIN AInfo on (AInfo.ANO=Acceptance.ANO)       
	INNER JOIN COVER ON (COVER.CNO=ACCEPTANCE.CNO)       
	INNER JOIN RateTab ON ((RateTab.TOC=substring(Acceptance.TOC,1,len(RateTab.TOC))) and RateTab.Effective<=Acceptance.SDate and RateTab.Code=@P_Code) 
	INNER JOIN RateCon on (    
	 RateTab.TOC=Cover.TOC and RateCon.Code=RateTab.Code And ((Case When @P_TSI=0 Then 1 Else @P_TSI End)>=RateCon.MinTSI or RateCon.MinTSI=0) and ((Case When @P_TSI=0 Then 1 Else @P_TSI End)<=RateCon.MaxTSI or RateCon.MaxTSI=0)     
	 And RateCon.ALLOWEDF=1
	 And RateCon.ProgressiveF=0
	 And (
	 (RateTab.SPeriod=0 and (    
	 (datediff(month, acceptance.sdate, acceptance.edate)>=RateCon.MinPeriod)     
	 or (datediff(month, acceptance.sdate, acceptance.edate)=RateCon.MinPeriod-1 and day(acceptance.sdate)<day(acceptance.edate))     
	 or RateCon.MinPeriod=0)                               
	 And (    
	 (datediff(month, acceptance.sdate, acceptance.edate)<RateCon.MaxPeriod)     
	 or (datediff(month, acceptance.sdate, acceptance.edate)=RateCon.MaxPeriod and day(acceptance.sdate)>=day(acceptance.edate))     
	 or RateCon.MaxPeriod=0)) OR
	(RateTab.SPeriod=1 
	 and ((datediff(day, acceptance.sdate, acceptance.edate)>=RateCon.MinPeriod) or RateCon.MinPeriod=0)
	 And ((datediff(day, acceptance.sdate, acceptance.edate)<=RateCon.MaxPeriod) or RateCon.MaxPeriod=0))
	 )     
	) 
	WHERE Acceptance.ANO=@P_ANO       
	And (coalesce(RateCon.ValueID1,'')='' or AINFO.VALUEID1 =RateCon.ValueID1)       
	And (coalesce(RateCon.ValueID2,'')='' or AINFO.VALUEID2 =RateCon.ValueID2)       
	And (coalesce(RateCon.ValueID3,'')='' or AINFO.VALUEID3 =RateCon.ValueID3)       
	And (coalesce(RateCon.ValueID4,'')='' or AINFO.VALUEID4 =RateCon.ValueID4)       
	And (coalesce(RateCon.ValueID5,'')='' or AINFO.VALUEID5 =RateCon.ValueID5)       
	And (coalesce(RateCon.ValueID6,'')='' or AINFO.VALUEID6 =RateCon.ValueID6)       
	And (coalesce(RateCon.ValueID7,'')='' or AINFO.VALUEID7 =RateCon.ValueID7)       
	And (coalesce(RateCon.ValueID8,'')='' or AINFO.VALUEID8 =RateCon.ValueID8)       
	And (coalesce(RateCon.ValueID9,'')='' or AINFO.VALUEID9 =RateCon.ValueID9)       
	And (coalesce(RateCon.ValueID10,'')='' or AINFO.VALUEID10 =RateCon.ValueID10)       
	And (coalesce(RateCon.ValueID11,'')='' or AINFO.VALUEID11 =RateCon.ValueID11)       
	And (coalesce(RateCon.ValueID12,'')='' or AINFO.VALUEID12 =RateCon.ValueID12)       
	And (coalesce(RateCon.ValueID13,'')='' or AINFO.VALUEID13 =RateCon.ValueID13)       
	And (coalesce(RateCon.ValueID14,'')='' or AINFO.VALUEID14 =RateCon.ValueID14)       
	And (coalesce(RateCon.ValueID15,'')='' or AINFO.VALUEID15 =RateCon.ValueID15)       
	Order by       
	RateTab.Effective Desc,       
	len(coalesce(RateCon.ValueID1,'')) Desc,       
	len(coalesce(RateCon.ValueID2,'')) Desc,       
	len(coalesce(RateCon.ValueID3,'')) Desc,       
	len(coalesce(RateCon.ValueID4,'')) Desc,       
	len(coalesce(RateCon.ValueID5,'')) Desc,       
	len(coalesce(RateCon.ValueID6,'')) Desc,       
	len(coalesce(RateCon.ValueID7,'')) Desc,       
	len(coalesce(RateCon.ValueID8,'')) Desc,       
	len(coalesce(RateCon.ValueID9,'')) Desc,       
	len(coalesce(RateCon.ValueID10,'')) Desc,       
	len(coalesce(RateCon.ValueID11,'')) Desc,       
	len(coalesce(RateCon.ValueID12,'')) Desc,       
	len(coalesce(RateCon.ValueID13,'')) Desc,       
	len(coalesce(RateCon.ValueID14,'')) Desc,       
	len(coalesce(RateCon.ValueID15,'')) Desc       

	UNION ALL

	SELECT RateTab.Code, 
	cast(1 as Bit) as ProgressiveF,
	Cast(Max(Cast(RateCon.AllowedF as Int)) as Bit) as AllowedF, 
	sum(Case When (Case When @P_TSI=0 Then 1 Else @P_TSI End)>=RateCon.MaxTSI Then RateCon.MaxTSI-RateCon.MinTSI Else (Case When @P_TSI=0 Then 1 Else @P_TSI End)-RateCon.MinTSI end*RateCon.MinRate/(Case When @P_TSI=0 Then 1 Else @P_TSI End)) as MinRate,
	sum(Case When (Case When @P_TSI=0 Then 1 Else @P_TSI End)>=RateCon.MaxTSI Then RateCon.MaxTSI-RateCon.MinTSI Else (Case When @P_TSI=0 Then 1 Else @P_TSI End)-RateCon.MinTSI end*RateCon.MaxRate/(Case When @P_TSI=0 Then 1 Else @P_TSI End)) as MaxRate,
	Max(RateCon.PML) as PML, 
	Max(RateCon.TExcess) as TExcess, 
	cast(Max(cast(RateTab.RateLoadingF as Int)) as Bit) as RateLoadingF,       
	Max(Case When coalesce(RateCon.Loading,0)=0 Then 100 else RateCon.Loading end) as Loading,       
	Max(Case When coalesce(RateCon.PCTLOSS,0)=0 Then 100 else RateCon.PCTLOSS end) as PCTLOSS,       
	--Rate Always in Percent       
	sum(
	Case       
	When RateCon.Unit='F' then (Case When (Case When @P_TSI=0 Then 1 Else @P_TSI End)<>0 Then RateCon.Rate/(Case When @P_TSI=0 Then 1 Else @P_TSI End)*100 else 0 end)       
	When RateCon.Unit='M' then 
		Case When (Case When @P_TSI=0 Then 1 Else @P_TSI End)>=RateCon.MaxTSI Then RateCon.MaxTSI-RateCon.MinTSI Else (Case When @P_TSI=0 Then 1 Else @P_TSI End)-RateCon.MinTSI end*RateCon.Rate/10/(Case When @P_TSI=0 Then 1 Else @P_TSI End) 
	else Case When (Case When @P_TSI=0 Then 1 Else @P_TSI End)>=RateCon.MaxTSI Then RateCon.MaxTSI-RateCon.MinTSI Else (Case When @P_TSI=0 Then 1 Else @P_TSI End)-RateCon.MinTSI end*RateCon.Rate/(Case When @P_TSI=0 Then 1 Else @P_TSI End) end 
	)as Rate,
	Max(RateCon.MaxTSI) as MaxTSI     
	From Acceptance       
	INNER JOIN AInfo on (AInfo.ANO=Acceptance.ANO)       
	INNER JOIN COVER ON (COVER.CNO=ACCEPTANCE.CNO)       
	INNER JOIN RateTab ON ((RateTab.TOC=substring(Acceptance.TOC,1,len(RateTab.TOC))) and RateTab.Effective<=Acceptance.SDate and RateTab.Code=@P_Code)       
	INNER JOIN RateCon on (    
	 RateTab.TOC=Cover.TOC and RateCon.Code=RateTab.Code 
	 And ((Case When @P_TSI=0 Then 1 Else @P_TSI End) Between RateCon.MinTSI and RateCon.MaxTSI or RateCon.MaxTSI<=(Case When @P_TSI=0 Then 1 Else @P_TSI End))
	 And RateCon.ALLOWEDF=1
	 And RateCon.ProgressiveF=1
	 And (
	 (RateTab.SPeriod=0 and (    
	 (datediff(month, acceptance.sdate, acceptance.edate)>=RateCon.MinPeriod)     
	 or (datediff(month, acceptance.sdate, acceptance.edate)=RateCon.MinPeriod-1 and day(acceptance.sdate)<day(acceptance.edate))     
	 or RateCon.MinPeriod=0)                               
	 And (    
	 (datediff(month, acceptance.sdate, acceptance.edate)<RateCon.MaxPeriod)     
	 or (datediff(month, acceptance.sdate, acceptance.edate)=RateCon.MaxPeriod and day(acceptance.sdate)>=day(acceptance.edate))     
	 or RateCon.MaxPeriod=0)) OR
	(RateTab.SPeriod=1 
	 and ((datediff(day, acceptance.sdate, acceptance.edate)>=RateCon.MinPeriod) or RateCon.MinPeriod=0)
	 And ((datediff(day, acceptance.sdate, acceptance.edate)<=RateCon.MaxPeriod) or RateCon.MaxPeriod=0))
	 )     
	) 
	WHERE Acceptance.ANO=@P_ANO       
	And (coalesce(RateCon.ValueID1,'')='' or AINFO.VALUEID1 =RateCon.ValueID1)       
	And (coalesce(RateCon.ValueID2,'')='' or AINFO.VALUEID2 =RateCon.ValueID2)       
	And (coalesce(RateCon.ValueID3,'')='' or AINFO.VALUEID3 =RateCon.ValueID3)       
	And (coalesce(RateCon.ValueID4,'')='' or AINFO.VALUEID4 =RateCon.ValueID4)       
	And (coalesce(RateCon.ValueID5,'')='' or AINFO.VALUEID5 =RateCon.ValueID5)       
	And (coalesce(RateCon.ValueID6,'')='' or AINFO.VALUEID6 =RateCon.ValueID6)       
	And (coalesce(RateCon.ValueID7,'')='' or AINFO.VALUEID7 =RateCon.ValueID7)       
	And (coalesce(RateCon.ValueID8,'')='' or AINFO.VALUEID8 =RateCon.ValueID8)       
	And (coalesce(RateCon.ValueID9,'')='' or AINFO.VALUEID9 =RateCon.ValueID9)       
	And (coalesce(RateCon.ValueID10,'')='' or AINFO.VALUEID10 =RateCon.ValueID10)       
	And (coalesce(RateCon.ValueID11,'')='' or AINFO.VALUEID11 =RateCon.ValueID11)       
	And (coalesce(RateCon.ValueID12,'')='' or AINFO.VALUEID12 =RateCon.ValueID12)       
	And (coalesce(RateCon.ValueID13,'')='' or AINFO.VALUEID13 =RateCon.ValueID13)       
	And (coalesce(RateCon.ValueID14,'')='' or AINFO.VALUEID14 =RateCon.ValueID14)       
	And (coalesce(RateCon.ValueID15,'')='' or AINFO.VALUEID15 =RateCon.ValueID15)       
	Group By RateTab.Code
) R
)       

GO


DROP PROCEDURE QRateCode
GO
CREATE PROCEDURE QRateCode (@P_ANO as integer, @P_Code as varchar(20),@P_AllowedF as bit=0, @P_TSI as float=0)              
AS              
Declare @Temp Table (ANO int, Code varchar(20), SIBasedID Int, Rate Float, PML Float, TExcess Int, Loading Float, AllowedF bit)  

Select @P_TSI = case When @P_TSI=0 Then 1 else @P_TSI end

Insert into @Temp  
Select Acceptance.ANO, RateTab.Code,  RateTab.SIBasedID,
(Select Top 1 Rate from fn_RateCon(Acceptance.ANO,RateTab.Code,@P_TSI) F) as Rate,  
(Select Top 1 PML from fn_RateCon(Acceptance.ANO,RateTab.Code,@P_TSI) F) as PML,  
(Select Top 1 TExcess from fn_RateCon(Acceptance.ANO,RateTab.Code,@P_TSI) F) as TExcess,  
(Select Top 1 Loading from fn_RateCon(Acceptance.ANO,RateTab.Code,@P_TSI) F) as Loading,  
(Select Top 1 AllowedF from fn_RateCon(Acceptance.ANO,RateTab.Code,@P_TSI) F) as AllowedF  
FROM  Acceptance          
Inner join Cover on (Cover.CNO=Acceptance.CNO)          
Inner join RateTab on ((RateTab.TOC=substring(Acceptance.TOC,1,len(RateTab.TOC))) and RateTab.Effective<=Acceptance.SDate and (@P_Code='%' or RateTab.Code Like @P_Code OR RateTab.Description Like @P_Code) And (RateTab.AllowedF=@P_AllowedF or @P_AllowedF=0))            
Where Acceptance.ANO=@P_ANO  

SELECT  RateTab.Code, RateTab.AllowedF, RateTab.NoRefundF,  RateTab.SIBasedID,            
 max(RateTab.Description) as Description,              
 max(RateTab.Unit) as Unit,              
 max(RClass.Category) AS Category,           
 sum(    
 case     
 When coalesce(Case When RateTab.Unit='F' then (Case When @P_TSI<>0 then F.Rate*@P_TSI/100 else 0 end) When RateTab.Unit='M' then F.Rate*10 else F.Rate end,0)<>0 then    
       Case When RateTab.Unit='F' then (Case When @P_TSI<>0 then F.Rate*@P_TSI/100 else 0 end) When RateTab.Unit='M' then F.Rate*10 else F.Rate end    
 else     
       RateTab.Rate    
 end*RateCov.Portion/100) as Rate,     
 cast(0 as Float) as MinRate,
 cast(0 as Float) as MaxRate,
  --in Percentage          
 max(F.PML) as PML,              
 sum(RateCov.Portion) AS Portion,              
 MAX(Case When coalesce(F.Loading,0)=0 Then 1 else F.Loading/100 end) As Loading,    
 Max(F.TExcess) as TExcess    
FROM  Acceptance          
Inner join Cover on (Cover.CNO=Acceptance.CNO)          
Inner join RateTab on ((RateTab.TOC=substring(Acceptance.TOC,1,len(RateTab.TOC))) and RateTab.Effective<=Acceptance.SDate and (@P_Code='%' or RateTab.Code Like @P_Code OR RateTab.Description Like @P_Code) And (RateTab.AllowedF=@P_AllowedF or @P_AllowedF=0))            
Inner join RateCov on (RateCov.Code=RateTab.Code)          
Inner join RClass on (RClass.TOC=Acceptance.TOC And RClass.TOR=RateCov.TOR)          
Left Join @Temp F on (F.Code=RateTab.Code)          
WHERE  Acceptance.ANO=@P_ANO
and 
(
not exists (Select Top 1 RateCon.Code from RateCon Where RateCon.Code=RateTab.Code) or not F.Rate is null
)
GROUP BY RateTab.Code, RateTab.AllowedF, RateTab.NoRefundF  , RateTab.SIBasedID  

GO

DROP Function FL_RateCode
GO
CREATE Function FL_RateCode(@P_ANO as integer, @P_Code as varchar(10),@P_AllowedF as bit=0, @P_TSI as float=0, @P_TOPF as bit=0)   
RETURNS @RateCon TABLE (Code varchar(10), AllowedF Bit, NoRefundF Bit, SIBasedID Int, Description varchar(255), Unit varchar(10), Category varchar(10), Rate Float, MinRate Float, MaxRate Float, PML Float, Portion Float, Loading Float, TExcess Float)
AS
BEGIN
Declare @Temp Table (ANO int, Code varchar(20), SIBasedID Int, Rate Float, PML Float, TExcess Int, Loading Float, AllowedF bit)  

Select @P_TSI = case When @P_TSI=0 Then 1 else @P_TSI end

Insert into @Temp  
Select Acceptance.ANO, RateTab.Code,  RateTab.SIBasedID,
(Select Top 1 Rate from fn_RateCon(Acceptance.ANO,RateTab.Code,@P_TSI) F) as Rate,  
(Select Top 1 PML from fn_RateCon(Acceptance.ANO,RateTab.Code,@P_TSI) F) as PML,  
(Select Top 1 TExcess from fn_RateCon(Acceptance.ANO,RateTab.Code,@P_TSI) F) as TExcess,  
(Select Top 1 Loading from fn_RateCon(Acceptance.ANO,RateTab.Code,@P_TSI) F) as Loading,  
(Select Top 1 AllowedF from fn_RateCon(Acceptance.ANO,RateTab.Code,@P_TSI) F) as AllowedF  
FROM  Acceptance          
Inner join Cover on (Cover.CNO=Acceptance.CNO)          
Inner join RateTab on ((RateTab.TOC=substring(Acceptance.TOC,1,len(RateTab.TOC))) and RateTab.Effective<=Acceptance.SDate and (@P_Code='%' or RateTab.Code Like @P_Code OR RateTab.Description Like @P_Code) And (RateTab.AllowedF=@P_AllowedF or @P_AllowedF=0))            
Where Acceptance.ANO=@P_ANO  

insert into @RateCon
SELECT  RateTab.Code, RateTab.AllowedF, RateTab.NoRefundF,  RateTab.SIBasedID,            
 max(RateTab.Description) as Description,              
 max(RateTab.Unit) as Unit,              
 max(RClass.Category) AS Category,           
 sum(    
 case     
 When coalesce(Case When RateTab.Unit='F' then (Case When @P_TSI<>0 then F.Rate*@P_TSI/100 else 0 end) When RateTab.Unit='M' then F.Rate*10 else F.Rate end,0)<>0 then    
       Case When RateTab.Unit='F' then (Case When @P_TSI<>0 then F.Rate*@P_TSI/100 else 0 end) When RateTab.Unit='M' then F.Rate*10 else F.Rate end    
 else     
       RateTab.Rate    
 end*RateCov.Portion/100) as Rate,     
 cast(0 as Float) as MinRate,
 cast(0 as Float) as MaxRate,
  --in Percentage          
 max(F.PML) as PML,              
 sum(RateCov.Portion) AS Portion,              
 MAX(Case When coalesce(F.Loading,0)=0 Then 1 else F.Loading/100 end) As Loading,    
 Max(F.TExcess) as TExcess    
FROM  Acceptance          
Inner join Cover on (Cover.CNO=Acceptance.CNO)          
Inner join RateTab on ((RateTab.TOC=substring(Acceptance.TOC,1,len(RateTab.TOC))) and RateTab.Effective<=Acceptance.SDate and (@P_Code='%' or RateTab.Code Like @P_Code OR RateTab.Description Like @P_Code) And (RateTab.AllowedF=@P_AllowedF or @P_AllowedF=0))            
Inner join RateCov on (RateCov.Code=RateTab.Code)          
Inner join RClass on (RClass.TOC=Acceptance.TOC And RClass.TOR=RateCov.TOR)          
Left Join @Temp F on (F.Code=RateTab.Code)          
WHERE  Acceptance.ANO=@P_ANO
and 
(
not exists (Select Top 1 RateCon.Code from RateCon Where RateCon.Code=RateTab.Code) or not F.Rate is null
)
GROUP BY RateTab.Code, RateTab.AllowedF, RateTab.NoRefundF  , RateTab.SIBasedID  

RETURN
END
