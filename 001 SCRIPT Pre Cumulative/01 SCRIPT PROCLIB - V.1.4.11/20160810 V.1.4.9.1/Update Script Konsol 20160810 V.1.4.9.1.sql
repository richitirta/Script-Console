--V.1.4.9.1 
--Penyempurnaan script untuk Claim Cession untuk pemeriksaan Treaty berdasarkan kondisi durasi periode Polis (Min dan Max Period)
IF EXISTS ( SELECT * FROM   sysobjects WHERE  id = object_id(N'[dbo].[Claim_Cession]') and OBJECTPROPERTY(id, N'IsProcedure') = 1 ) BEGIN    DROP PROCEDURE [dbo].[Claim_Cession] END 
go
CREATE PROCEDURE Claim_Cession (@PCNO as integer, @pLDate as smalldatetime, @pRType as varchar(255))                  
AS                  
SELECT (Case When ReClass.PriorityF=1 Then ReClass.PriorityF else Reinsurance.PriorityF end) as PriorityF, Reinsurance.RID, Reinsurance.RType, Reinsurance.Category,                  
Reinsurance.Share,                  
Case When Event.Category='E' and RECLASS.ELIMIT<>0 Then RECLASS.ELIMIT Else (Case WHEN RECLASS.Limit=0 THEN Reinsurance.Limit Else RECLASS.Limit end)End as Limit,                  
Case When Event.Category='E' and RECLASS.EExcess<>0 Then RECLASS.EExcess Else (Case WHEN RECLASS.Excess=0 THEN Reinsurance.Excess Else RECLASS.Excess end) End as Excess,                  
Reinsurance.ExcessType,              
RECLASS.CessionF , RECLASS.AssessmentF, REINSURANCE.Deductible, REINSURANCE.A_Deductible, REINSURANCE.A_EDeductible, REINSURANCE.Aggregate, REINSURANCE.A_Aggregate, REINSURANCE.A_EAggregate                  
FROM Claim        
Left Join Event On (Event.EventNo=Claim.EventNo)        
Inner Join Acceptance on (Acceptance.ANO=Claim.ANO)        
Inner Join Cover on (Cover.CNO=Acceptance.CNO)        
Inner Join RArrHeader on (RArrHeader.ANO=Claim.ANO)        
Inner Join Reinsurance on (Reinsurance.RTYPE=@pRType and @pLDate Between Reinsurance.SDate And Reinsurance.EDate)        
Inner Join ReClass on (ReClass.RNO=Reinsurance.RNO and ReClass.TOC=Claim.TOC)        
Left Join RePolicy on (RePolicy.RNO=Reinsurance.RNO)        
WHERE Claim.CNO=@PCNO         
and RArrHeader.EXOLF=0        --Not Exclude XOL        
and (coalesce(Event.EventNo,'')<>'' or ReClass.EventF=0)   
and (Event.Category='E' or Reinsurance.Category<>'E')         
And Reinsurance.Category<>'S' --Not Shortfall Surplus        
And (coalesce(RePolicy.ID,'')='' or  coalesce(RePolicy.ID,'')=Cover.PHolder)      
And
(      
 (    
 (datediff(month, acceptance.sdate, acceptance.edate)>=ReClass.MinPeriod)     
 or (datediff(month, acceptance.sdate, acceptance.edate)=ReClass.MinPeriod-1 and day(acceptance.sdate)<day(acceptance.edate))     
 or ReClass.MinPeriod=0)                               
 And (    
 (datediff(month, acceptance.sdate, acceptance.edate)<ReClass.MaxPeriod)     
 or (datediff(month, acceptance.sdate, acceptance.edate)=ReClass.MaxPeriod and day(acceptance.sdate)>=day(acceptance.edate))     
 or ReClass.MaxPeriod=0)
)      
-- If Risk is Excluded        
AND NOT EXISTS (SELECT TOP 1 1 FROM RPARTDET, LCALC WHERE LCALC.CNO=CLAIM.CNO AND RPARTDET.RNO=REINSURANCE.RNO AND RPARTDET.TOR=LCALC.TOR AND RPARTDET.EXCLUDEF=1)        
Order By coalesce(RePolicy.ID,'') Desc, Case When (Event.Category='E' and Reinsurance.Category in ('C','E')) or (coalesce(Event.Category,'R')='R' and Reinsurance.Category in ('R')) Then 1 else 0 end Desc, (Case When ReClass.PriorityF=1 Then ReClass.PriorityF else Reinsurance.PriorityF end) Desc           
go

--Perbaikan untuk spreading Claim terkait dengan Facultative Excess Of Loss (Proclib.Claim_Cession)
IF EXISTS ( SELECT * FROM   sysobjects WHERE  id = object_id(N'[dbo].[QCLAIMFACOUT]') and OBJECTPROPERTY(id, N'IsProcedure') = 1 ) BEGIN    DROP PROCEDURE [dbo].[QCLAIMFACOUT] END 
go
CREATE Procedure QCLAIMFACOUT(@P_CNO integer)                  
as                  
SELECT Distinct RArrDet.FID, RArrDet.FLPct, RArrDet.Status, RArrDet.AType, RArrDet.RType, RArrDet.SDate, RArrDet.EDate, RArrDet.Share, RArrDet.Amount, RArrDet.Limit, RArrDet.Excess, Profile.Name, FPart.SlipNo, FPart.ID, FPart.Share AS RShare, RArrDet.FullCoverF, RArrDet.OriginalF, Cast(FPart.Remarks as varchar(512)) as Remarks,      
RArrDet.ClaimCoop,     
Case When RArrDet.Excess<>0 Then 
	Case When CArrHeader.ETAmount>RArrDet.Excess Then CArrHeader.ETAmount-RArrDet.Excess else 0 end
	else CArrHeader.ETAmount
end *RArrDet.Share/100*FPart.Share/100 as Estimate,      
Case When RArrDet.Excess<>0 Then 
	Case When CArrHeader.TAmount>RArrDet.Excess Then CArrHeader.TAmount-RArrDet.Excess else 0 end
	else CArrHeader.TAmount
end *RArrDet.Share/100*FPart.Share/100 as Claim,      
Case When RArrDet.ClaimCoop>0 and (RArrDet.ClaimCoop<=CArrHeader.ETAmount*RArrDet.Share/100*FPart.Share/100) Then Cast(1 as Bit) else Cast(0 as Bit) end as ClaimCoopF      
From ACCEPTANCE, RArrDet, FPart, Profile, CLAIM, CArrHeader      
WHERE Claim.CNO=@P_CNO AND CArrHeader.CNO=Claim.CNO AND ACCEPTANCE.ANO=Claim.ANO AND RArrDet.ANO=Claim.ANO             
AND ((RARRDET.SDATE<=CLAIM.LOSSDATE AND ACCEPTANCE.ExclusiveF=1) or ((RARRDET.SDATE<CLAIM.LOSSDATE or (RARRDET.SDATE=CLAIM.LOSSDATE AND '12:00'<=Claim.LossTime)) AND ACCEPTANCE.ExclusiveF=0))                 
AND ((dbo.fn_Get_ExtPeriodDate(ACCEPTANCE.ExtPeriod, ACCEPTANCE.ExtPeriodInDaysF, RARRDET.EDATE)>CLAIM.LOSSDATE AND ACCEPTANCE.ExclusiveF=1) or ((dbo.fn_Get_ExtPeriodDate(ACCEPTANCE.ExtPeriod, ACCEPTANCE.ExtPeriodInDaysF, RARRDET.EDATE)>CLAIM.LOSSDATE or (dbo.fn_Get_ExtPeriodDate(ACCEPTANCE.ExtPeriod, ACCEPTANCE.ExtPeriodInDaysF, RARRDET.EDATE)=CLAIM.LOSSDATE AND '12:00'>Claim.LossTime)) AND ACCEPTANCE.ExclusiveF=0))                
AND FPart.ANO=RArrDet.ANO AND FPart.FID=RArrDet.FID AND Profile.ID=FPart.ID AND RArrDet.FullCoverF=1             
AND (FPart.Code='' or EXISTS (Select RateCov.Code from RateCov, COL Where RateCov.Code=FPart.Code AND RateCov.TOR=COL.TOR AND COL.COL=Claim.COL))                  
AND RArrDet.Status='A'         
                        
Union All                  
                        
SELECT Distinct RArrDet.FID, RArrDet.FLPct, RArrDet.Status, RArrDet.AType, RArrDet.RType, RArrDet.SDate, RArrDet.EDate, RArrDet.Share, RArrDet.Amount, RArrDet.Limit, RArrDet.Excess, Profile.Name, FPart.SlipNo, FPart.ID, FPart.Share AS RShare, RArrDet.FullCoverF, RArrDet.OriginalF, Cast(FPart.Remarks as varchar(512)) as Remarks,      
RArrDet.ClaimCoop,     
Case When RArrDet.Excess<>0 Then 
	Case When CArrHeader.ETAmount>RArrDet.Excess Then CArrHeader.ETAmount-RArrDet.Excess else 0 end
	else CArrHeader.ETAmount
end *RArrDet.Share/100*FPart.Share/100 as Estimate,      
Case When RArrDet.Excess<>0 Then 
	Case When CArrHeader.TAmount>RArrDet.Excess Then CArrHeader.TAmount-RArrDet.Excess else 0 end
	else CArrHeader.TAmount
end *RArrDet.Share/100*FPart.Share/100 as Claim,    
Case When RArrDet.ClaimCoop>0 and (RArrDet.ClaimCoop<=CArrHeader.ETAmount*RArrDet.Share/100*FPart.Share/100) Then Cast(1 as Bit) else Cast(0 as Bit) end as ClaimCoopF      
From ACCEPTANCE, RArrDet, FPart, Profile, CLAIM, CArrHeader, FPartDet                  
WHERE Claim.CNO=@P_CNO AND CArrHeader.CNO=Claim.CNO  AND ACCEPTANCE.ANO=Claim.ANO AND RArrDet.ANO=Claim.ANO             
AND ((RARRDET.SDATE<=CLAIM.LOSSDATE AND ACCEPTANCE.ExclusiveF=1) or ((RARRDET.SDATE<CLAIM.LOSSDATE or (RARRDET.SDATE=CLAIM.LOSSDATE AND '12:00'<=Claim.LossTime)) AND ACCEPTANCE.ExclusiveF=0))                 
AND ((dbo.fn_Get_ExtPeriodDate(ACCEPTANCE.ExtPeriod, ACCEPTANCE.ExtPeriodInDaysF, RARRDET.EDATE)>CLAIM.LOSSDATE AND ACCEPTANCE.ExclusiveF=1) or ((dbo.fn_Get_ExtPeriodDate(ACCEPTANCE.ExtPeriod, ACCEPTANCE.ExtPeriodInDaysF, RARRDET.EDATE)>CLAIM.LOSSDATE or (dbo.fn_Get_ExtPeriodDate(ACCEPTANCE.ExtPeriod, ACCEPTANCE.ExtPeriodInDaysF, RARRDET.EDATE)=CLAIM.LOSSDATE AND '12:00'>Claim.LossTime)) AND ACCEPTANCE.ExclusiveF=0))                
AND FPart.ANO=RArrDet.ANO AND FPart.FID=RArrDet.FID AND Profile.ID=FPart.ID AND RArrDet.FullCoverF=0                  
AND FPartDet.ANO=RArrDet.ANO AND FPartDet.FID=RArrDet.FID AND FPartDet.ID=FPart.ID           
AND EXISTS (Select RateCov.Code from RateCov, COL Where RateCov.Code=FPartDet.Code AND RateCov.TOR=COL.TOR AND COL.COL=Claim.COL)                  
AND RArrDet.Status='A'   
go


--perbaikan pada Endorse untuk Commission BC (Coom Pool), dikarenakan nilai pembalik belum memasukkan Flag-nya..
IF EXISTS ( SELECT * FROM   sysobjects WHERE  id = object_id(N'[dbo].[BALANCE_ACCASS]') and OBJECTPROPERTY(id, N'IsProcedure') = 1 ) BEGIN    DROP PROCEDURE [dbo].[BALANCE_ACCASS] END 
IF EXISTS ( SELECT * FROM   sysobjects WHERE  id = object_id(N'[dbo].[BALANCE_ACCASS_REINSURANCE]') and OBJECTPROPERTY(id, N'IsProcedure') = 1 ) BEGIN    DROP PROCEDURE [dbo].[BALANCE_ACCASS_REINSURANCE] END 
go

CREATE Procedure BALANCE_ACCASS(@P_ANO integer)              
as              
SELECT A1.ACNO, A1.BizmapID, A2.AType, A1.Type,A1.ID, A1.Code,       
Case When A2.AType='A' then A1.Amount_OC else A1.CAmount end as CAmount,       
A1.Currency_OC, A1.Rate, A1.Currency, A1.TOC, A1.PolicyNo, A1.Remarks, A1.Prorata, A1.SDate, A1.EDate, A1.Date, A1.BillDate, A1.PProrata, A1.DocNo, A1.RefNo, A1.AdjustableF, A1.RCode, A2.SDATE AS PSDATE, A2.EDATE AS PEDATE,       
CASE WHEN R1.NOREFUNDF=1 THEN R1.NOREFUNDF ELSE COALESCE(R2.NOREFUNDF,COALESCE(COALESCE(A5.NOREFUNDF,A4.NOREFUNDF),CAST(0 as BIT))) END AS NOREFUNDF,      
Case When A3.AType='C' and A3.EMethod<>'A' and Not R2.CPRefund is null then R2.CPRefund When A3.AType='C' and A3.EMethod<>'A' and A1.Type in ('DI','IC','IR','BB','BA','BO','BC','OP') Then R1.CPRefund else 0 end as CPRefund,    
A1.ADJMETHOD, A1.Source, A1.CommPoolF
FROM ACCASS A1       
INNER JOIN ACCEPTANCE A2 ON (A1.ANO=A2.ANO)       
INNER JOIN ACCEPTANCE A3 ON (A3.PANO=A2.ANO AND A3.AType<>'A')       
Left Join RCover R1 on (R1.ANO=A3.ANO and R1.Code=A1.RCode and R1.SDate=A1.SDate)              
Left Join ACCBS A4 on (A4.ANO=A3.ANO and A4.ID=A1.ID and 'B'+A4.BSType=A1.Type)      
Left Join AACCBS A5 on (A5.ANO=A3.ANO and A5.ID=A1.ID and 'B'+A5.BSType=A1.Type)      
Left Join FPart F on (F.ANO=A3.ANO and F.SlipNo=A1.RefNo and F.ID=A1.ID)    
Left Join RArrDet R2 on (R2.ANO=A3.ANO and R2.FID=F.FID and ((R2.RType='F' and A1.Type='FO') or R2.RType=A1.Type) and R2.Status<>'O')    
WHERE A2.ANO=@P_ANO AND (A1.CAMOUNT<>0 OR A2.AType='A')   
AND Not (A1.TYPE in ('DI','OP') AND A1.CODE IN ('D','F'))              
AND A1.TYPE NOT in ('PD') AND A1.CODE NOT IN ('J')  


GO
CREATE Procedure BALANCE_ACCASS_REINSURANCE(@P_ANO integer)    
as    
SELECT A1.ACNO, A1.BizmapID, A2.AType, A1.Type,A1.ID, A1.Code,       
Case When A2.AType='A' then A1.Amount_OC else A1.CAmount end as CAmount,       
A1.Currency_OC, A1.Rate, A1.Currency, A1.TOC, A1.PolicyNo, A1.Remarks, A1.Prorata, A1.SDate, A1.EDate, A1.Date, A1.BillDate, A1.PProrata, A1.DocNo, A1.RefNo, A1.AdjustableF, A1.RCode, A2.SDATE AS PSDATE, A2.EDATE AS PEDATE,       
CASE WHEN R1.NOREFUNDF=1 THEN R1.NOREFUNDF ELSE COALESCE(R2.NOREFUNDF,COALESCE(COALESCE(A5.NOREFUNDF,A4.NOREFUNDF),CAST(0 as BIT))) END AS NOREFUNDF,      
Case When A3.AType='C' and A3.EMethod<>'A' and Not R2.CPRefund is null then R2.CPRefund When A3.AType='C' and A3.EMethod<>'A' and A1.Type in ('DI','IC','IR','BB','BA','BO','BC','OP') Then R1.CPRefund else 0 end as CPRefund,    
A1.ADJMETHOD, A1.Source, A1.CommPoolF
FROM ACCASS A1       
INNER JOIN ACCEPTANCE A2 ON (A1.ANO=A2.ANO)       
INNER JOIN ACCEPTANCE A3 ON (A3.PANO=A2.ANO AND A3.AType<>'A')       
Left Join RCover R1 on (R1.ANO=A3.ANO and R1.Code=A1.RCode and R1.SDate=A1.SDate)              
Left Join ACCBS A4 on (A4.ANO=A3.ANO and A4.ID=A1.ID and 'B'+A4.BSType=A1.Type)      
Left Join AACCBS A5 on (A5.ANO=A3.ANO and A5.ID=A1.ID and 'B'+A5.BSType=A1.Type)      
Left Join FPart F on (F.ANO=A3.ANO and F.SlipNo=A1.RefNo and F.ID=A1.ID)    
Left Join RArrDet R2 on (R2.ANO=A3.ANO and R2.FID=F.FID and ((R2.RType='F' and A1.Type='FO') or R2.RType=A1.Type) and R2.Status<>'O')    
WHERE A2.ANO=@P_ANO AND (A1.CAMOUNT<>0 OR A2.AType='A')   
AND Not (A1.TYPE in ('DI','OP') AND A1.CODE IN ('D','F'))              
AND A1.TYPE NOT in ('PD') AND A1.CODE NOT IN ('J')  
AND A1.TYPE IN ('CP','DC','QS','QP','S1','S2','S3','AF','XP','FO')    
go

--Penambahan Upload UP
--IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'ContributionF' AND Object_ID = Object_ID(N'SysBatchOriginalUP')) BEGIN ALTER TABLE SysBatchOriginalUP ADD ContributionF int END
--IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'ContributionF' AND Object_ID = Object_ID(N'SysBatchUP')) BEGIN ALTER TABLE SysBatchUP ADD ContributionF int END
--IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'ICoverDetTOI' AND Object_ID = Object_ID(N'SysBatchOriginalUP')) BEGIN ALTER TABLE SysBatchOriginalUP ADD ICoverDetTOI int END
--IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'ICoverDetTOI' AND Object_ID = Object_ID(N'SysBatchUP')) BEGIN ALTER TABLE SysBatchUP ADD ICoverDetTOI int END
--go

--Perbaikan View Settingan scheme 

IF EXISTS ( SELECT * FROM   sysobjects WHERE  id = object_id(N'[dbo].[QSchemeViewAdditional]') and OBJECTPROPERTY(id, N'IsProcedure') = 1 ) BEGIN    DROP PROCEDURE [dbo].[QSchemeViewAdditional] END 
IF EXISTS ( SELECT * FROM   sysobjects WHERE  id = object_id(N'[dbo].[QSchemeViewCoverage]') and OBJECTPROPERTY(id, N'IsProcedure') = 1 ) BEGIN    DROP PROCEDURE [dbo].[QSchemeViewCoverage] END 
IF EXISTS ( SELECT * FROM   sysobjects WHERE  id = object_id(N'[dbo].[QSchemeViewDeductible]') and OBJECTPROPERTY(id, N'IsProcedure') = 1 ) BEGIN    DROP PROCEDURE [dbo].[QSchemeViewDeductible] END 
IF EXISTS ( SELECT * FROM   sysobjects WHERE  id = object_id(N'[dbo].[QSchemeViewIndemnity]') and OBJECTPROPERTY(id, N'IsProcedure') = 1 ) BEGIN    DROP PROCEDURE [dbo].[QSchemeViewIndemnity] END 
IF EXISTS ( SELECT * FROM   sysobjects WHERE  id = object_id(N'[dbo].[QSchemeViewInterest]') and OBJECTPROPERTY(id, N'IsProcedure') = 1 ) BEGIN    DROP PROCEDURE [dbo].[QSchemeViewInterest] END 
go

CREATE procedure QSchemeViewCoverage(@p_SchemeNo varchar(10),@P_Class_Desc as varchar(100))   
as   
select Top 50000
coverage.classno,   
class.description as class_desc, coverage.coverage,   
coverage.code, ratetab.description as ratetab_desc,   
coverage.rate,   
Coverage.GrossUpF,   
case   
when coverage.unit='M' then 'Per Mil'   
when coverage.unit='C' then 'Percentage'   
when coverage.unit='F' then 'Flat'   
else coverage.unit   
end as unit,   
case   
when coverage.category='A' then 'Additional'   
when coverage.category='M' then 'Main'   
else coverage.category   
end as category,   
Coverage.RateLoadingF   
from scheme_coverage as coverage, scheme_class as class, ratetab   
where   
coverage.classno=class.classno 
and coverage.code=ratetab.code 
and class.schemeno=@p_schemeno 
and (@P_Class_Desc='<All>' or class.description=@P_Class_Desc)

GO

CREATE procedure QSchemeViewInterest(@p_SchemeNo varchar(10),@P_Class_Desc as varchar(100))   
as   
select top 50000 S2.ClassNo, S1.Description as Class_Desc, S2.TOI, TOI.Description as TOI_Desc, Case When S2.Category='M' then 'Main' else 'Additional' end as Category, S2.SI   
from scheme_Class as S1, scheme_interest as S2, toi   
where  S1.ClassNo=S2.ClassNo and TOI.TOI=S2.TOI and S1.SchemeNo=@P_SchemeNo and (@P_Class_Desc='<All>' or S1.description=@P_Class_Desc)
   
   
GO

CREATE procedure QSchemeViewDeductible(@p_SchemeNo varchar(10),@P_Class_Desc as varchar(100))   
as  
select Top 50000 deductible.classno,class.description as class_desc, deductible.coverage, deductible.lower, deductible.upper, deductible.dcode, deductible.remarks  
from scheme_deductible as deductible, scheme_class as class  
where  deductible.classno=class.classno and class.schemeno=@p_schemeno and (@P_Class_Desc='<All>' or class.description=@P_Class_Desc)
  

GO

CREATE procedure QSchemeViewIndemnity(@p_SchemeNo varchar(10),@P_Class_Desc as varchar(100))   
as   
select Top 50000 S2.classno, S1.description as class_desc, S2.Coverage, S2.Code, S2.Lower, S2.Upper, S2.PCTLoss, S2.PAddition, S2.Discount, S2.Rate, S2.HoldF, S2.RateLoadingF   
from Scheme_Class as S1, scheme_indemnity as S2   
where  S1.ClassNo=S2.ClassNo and S1.SchemeNo=@P_SchemeNo and (@P_Class_Desc='<All>' or S1.description=@P_Class_Desc)
order by  S2.ClassNo, S2.Coverage, S2.Code, S2.Lower, S2.Upper   
   
GO

CREATE procedure QSchemeViewAdditional(@p_SchemeNo varchar(10),@P_Class_Desc as varchar(100))   
as      
select top 50000
 additional.classno,      
 class.description as class_desc,   
 additional.coverage,  
 additional.interest,      
 additional.toi,      
 toi.description as toi_desc,      
 additional.lower, additional.upper,      
 additional.NOfYearsL, additional.NOfYearsU,      
 additional.SI,    
 additional.code,ratetab.description as ratetab_desc,      
 additional.rate,      
 case       
 when additional.unit = 'M' then 'Per Mil'      
 when additional.unit = 'C' then 'Percentage'      
 when additional.unit = 'F' then 'Flat'      
 else additional.unit      
 end as unit,      
 case       
 when additional.category='A' then 'Additional'      
 when additional.category='M' then 'Main'      
 else additional.category      
 end as category       
from scheme_additional as additional, scheme_class as class, toi,ratetab      
where additional.classno=class.classno 
and additional.toi =toi.toi 
and additional.code=ratetab.code 
and class.schemeno=@p_schemeno and (@P_Class_Desc='<All>' or class.description=@P_Class_Desc)
  
     
go

--Tuning, untuk fungsi view calculation untuk Premium Commission Up Fee
if exists (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Premium_Commission_UpFee]') AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) ) BEGIN DROP FUNCTION [dbo].[Premium_Commission_UpFee] END
go
CREATE Function Premium_Commission_UpFee(@P_ANO as int,@P_Code as varchar(10),@P_Period Int, @P_MinimumPremiumF Bit)                
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
		(AccBS.UpFee)*(Case When AccBS.GrossUpF=0 and AccBS.NetUpF=0 Then (100-@GrossUpComm)/100 else 1 end)     
	   )*(Case When AccBS.MemberF=1 or AccBS.MemberFeeF=1 Then (1-@MShare/100) else 1 end)  
	   )     
	  From Acceptance
	  Inner Join AccBS on (AccBS.ANO=Acceptance.ANO)
	  Left Join AccBSDet on ((AccBSDet.Period=0 or AccBSDet.Period=@P_Period) and AccBSDet.ID=AccBS.ID and AccBSDet.BSType=AccBS.BSType and AccBSDet.ANO=AccBS.ANO and AccBSDet.Code=@P_Code),
	  MParam, Profile                
	  Where Acceptance.ANO=@P_ANO 
	  and MParam.Type='B'+AccBS.BSType and Profile.ID=AccBS.ID          
	  and (AccBS.NotMinimumPremiumF=0 or (AccBS.NotMinimumPremiumF=1 and @P_MinimumPremiumF=0))                   
 END
 ELSE
 BEGIN
	 Select Top 1 @DetailF=1 from AAccBS Where ANO=@P_ANO                        
	 if @DetailF is null         
	 Begin
		if @RegNo='' or @AStatus in ('W','T') or @P_ANO=@OANO   
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
			(AccBS.UpFee)*(Case When AccBS.GrossUpF=0 and AccBS.NetUpF=0 Then (100-@GrossUpComm)/100 else 1 end)     
		   )*(Case When AccBS.MemberF=1 or AccBS.MemberFeeF=1 Then (1-@MShare/100) else 1 end)  
		   )     
		  From Acceptance
		  Inner Join Acceptance mAcceptance on (mAcceptance.ANO=mAcceptance.LANO and mAcceptance.ANO=Acceptance.LANO)		  		  
		  Inner Join AccBS on (AccBS.ANO=mAcceptance.ANO)
		  Left Join AccBSDet on ((AccBSDet.Period=0 or AccBSDet.Period=@P_Period) and AccBSDet.ID=AccBS.ID and AccBSDet.BSType=AccBS.BSType and AccBSDet.ANO=AccBS.ANO and AccBSDet.Code=@P_Code),
		  MParam, Profile                
		  Where Acceptance.ANO=@P_ANO 
		  and MParam.Type='B'+AccBS.BSType and Profile.ID=AccBS.ID          
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
			(AccBS.UpFee)*(Case When AccBS.GrossUpF=0 and AccBS.NetUpF=0 Then (100-@GrossUpComm)/100 else 1 end)     
		   )*(Case When AccBS.MemberF=1 or AccBS.MemberFeeF=1 Then (1-@MShare/100) else 1 end)  
		   )     
		  From Acceptance
		  Inner Join Acceptance mAcceptance on (mAcceptance.ANO=mAcceptance.LANO and ((mAcceptance.RegNo<>'' and mAcceptance.RegNo=Acceptance.RegNo)))
		  Inner Join AccBS on (AccBS.ANO=mAcceptance.ANO)
		  Left Join AccBSDet on ((AccBSDet.Period=0 or AccBSDet.Period=@P_Period) and AccBSDet.ID=AccBS.ID and AccBSDet.BSType=AccBS.BSType and AccBSDet.ANO=AccBS.ANO and AccBSDet.Code=@P_Code),
		  MParam, Profile                
		  Where Acceptance.ANO=@P_ANO 
		  and MParam.Type='B'+AccBS.BSType and Profile.ID=AccBS.ID          
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
			(AccBS.UpFee)*(Case When AccBS.GrossUpF=0 and AccBS.NetUpF=0 Then (100-@GrossUpComm)/100 else 1 end)     
		   )*(Case When AccBS.MemberF=1 or AccBS.MemberFeeF=1 Then (1-@MShare/100) else 1 end)  
		   )     
		  From Acceptance
		  Inner Join AAccBS AccBS on (AccBS.ANO=Acceptance.ANO)
		  Left Join AAccBSDet AccBSDet on ((AccBSDet.Period=0 or AccBSDet.Period=@P_Period) and AccBSDet.ID=AccBS.ID and AccBSDet.BSType=AccBS.BSType and AccBSDet.ANO=AccBS.ANO and AccBSDet.Code=@P_Code),
		  MParam, Profile                
		  Where Acceptance.ANO=@P_ANO 
		  and MParam.Type='B'+AccBS.BSType and Profile.ID=AccBS.ID          
		  and (AccBS.NotMinimumPremiumF=0 or (AccBS.NotMinimumPremiumF=1 and @P_MinimumPremiumF=0))                      
	 end
 
 END
                        
 if @Commission is null                
   Select @Commission=0                
                        
 return(@Commission)                
End        

GO  

--Tuning, Penghapusan Referential Integrity dari Table Accass_Deferred 
Alter Table AccAss_Deferred drop constraint FK_ACCASS_DEFERRED_ACCASS
go

--Penambahan untuk Sesi Reinsurance terkait dengan Policy Deposit 
IF EXISTS ( SELECT * FROM   sysobjects WHERE  id = object_id(N'[dbo].[QPOLICY_DEPOSIT]') and OBJECTPROPERTY(id, N'IsProcedure') = 1 ) BEGIN    DROP PROCEDURE [dbo].[QPOLICY_DEPOSIT] END 
IF EXISTS ( SELECT * FROM   sysobjects WHERE  id = object_id(N'[dbo].[QPOLICY_DEPOSIT_USAGE]') and OBJECTPROPERTY(id, N'IsProcedure') = 1 ) BEGIN    DROP PROCEDURE [dbo].[QPOLICY_DEPOSIT_USAGE] END 
IF EXISTS ( SELECT * FROM   sysobjects WHERE  id = object_id(N'[dbo].[QDEPOSIT_REINSURANCE_CESSION]') and OBJECTPROPERTY(id, N'IsProcedure') = 1 ) BEGIN    DROP PROCEDURE [dbo].[QDEPOSIT_REINSURANCE_CESSION] END 
IF EXISTS ( SELECT * FROM   sysobjects WHERE  id = object_id(N'[dbo].[QREINSURANCE_DEPOSIT]') and OBJECTPROPERTY(id, N'IsProcedure') = 1 ) BEGIN    DROP PROCEDURE [dbo].[QREINSURANCE_DEPOSIT] END 
IF EXISTS ( SELECT * FROM   sysobjects WHERE  id = object_id(N'[dbo].[QREINSURANCE_DEPOSIT_USAGE]') and OBJECTPROPERTY(id, N'IsProcedure') = 1 ) BEGIN    DROP PROCEDURE [dbo].[QREINSURANCE_DEPOSIT_USAGE] END 
go


CREATE Procedure QDEPOSIT_REINSURANCE_CESSION (@P_ANO integer, @P_RType varchar(255))     
AS                           
SELECT Top 1 Reinsurance.RID, Reinsurance.SHARE
From Acceptance       
Inner Join Cover on (Cover.CNO=Acceptance.CNO)      
Inner Join Reinsurance on (Reinsurance.RType='Q')      
Inner Join ReClass on (ReClass.RNO=Reinsurance.RNO and ReClass.TOC=Cover.TOC)      
Left Join RePolicy on (RePolicy.RNO=Reinsurance.RNO)      
WHERE ACCEPTANCE.ANO=@P_ANO
And Acceptance.SDate Between Reinsurance.SDate And Reinsurance.EDate       
And (coalesce(RePolicy.ID,'')='' or  coalesce(RePolicy.ID,'')=Cover.PHolder)    
Order By coalesce(RePolicy.ID,'') Desc, (Case When ReClass.PriorityF=1 Then ReClass.PriorityF else Reinsurance.PriorityF end) Desc                   
  
GO

CREATE Procedure QPOLICY_DEPOSIT(@P_LANO integer)                
as                
Select     
sum(AccAss.Amount) as Total_Deposit    
from Acceptance MA1     
Inner Join Acceptance MA2 on (MA2.OANO=MA1.OANO)    
Inner join AccAss on (AccAss.ANO=MA2.ANO)    
Where MA1.ANO=@P_LANO and MA2.ANO<=@P_LANO and AccAss.Code='J' and AccAss.Type in ('DI','IC')

GO


CREATE Procedure QREINSURANCE_DEPOSIT(@P_LANO integer)                
as                
Select     
AccAss.ID, 
Max(AccAss.Type) as Type,
max(AccAss.RefNo) as RefNo, 
sum(-AccAss.Amount) as Total_Deposit    
from Acceptance MA1     
Inner Join Acceptance MA2 on (MA2.OANO=MA1.OANO)    
Inner join AccAss on (AccAss.ANO=MA2.ANO)    
Where MA1.ANO=@P_LANO and MA2.ANO<=@P_LANO and AccAss.Code='J' and AccAss.Type in ('QS','QP')
Group by AccAss.ID

    
GO

CREATE Procedure QPOLICY_DEPOSIT_USAGE(@P_ANO integer)                
as                
Select     
AccAss.Currency,     
sum(Case When AccAss.Code<>'J' Then AccAss.Amount else 0 end) as Total_Premium,    
sum(Case When AccAss.Code='J' Then -AccAss.Amount else 0 end) as Deposit_Usage    
from Acceptance A1    
Inner Join Acceptance MA1 on (MA1.ANO=A1.LANO)    
Inner Join Acceptance MA2 on (MA2.OANO=MA1.OANO)    
Inner Join Acceptance A2 on (A2.LANO=MA2.LANO and A2.ANO<>A2.LANO and A2.ANO<=@P_ANO)    
Inner Join AccAss on (AccAss.ANO=A2.ANO)    
Where A1.ANO=@P_ANO     
and ((AccAss.Type in ('DI','IC') and AccAss.Code in ('P','U','O','J')) or (AccAss.Type in ('IR','IT','IX') and AccAss.Code in ('P','O','J')))     
Group by AccAss.Currency    

GO


CREATE Procedure QREINSURANCE_DEPOSIT_USAGE(@P_ANO integer, @P_ID as varchar(10))                
as                
Select     
AccAss.Currency,     
sum(Case When AccAss.Code<>'J' Then -AccAss.Amount else 0 end) as Total_Premium,    
sum(Case When AccAss.Code='J' Then AccAss.Amount else 0 end) as Deposit_Usage    
from Acceptance A1    
Inner Join Acceptance MA1 on (MA1.ANO=A1.LANO)    
Inner Join Acceptance MA2 on (MA2.OANO=MA1.OANO)    
Inner Join Acceptance A2 on (A2.LANO=MA2.LANO and A2.ANO<>A2.LANO and A2.ANO<=@P_ANO)    
Inner Join AccAss on (AccAss.ANO=A2.ANO)    
Where A1.ANO=@P_ANO and AccAss.ID=@P_ID
and ((AccAss.Type in ('QS','QP') and AccAss.Code in ('P','C','O','J')))
Group by AccAss.Currency    
go

update SysTab Set versionNo='20160810 V1.4.9.1',versionUpdate=getdate()
go