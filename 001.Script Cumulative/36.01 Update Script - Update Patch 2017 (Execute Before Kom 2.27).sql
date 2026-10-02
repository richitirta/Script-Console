IF EXISTS ( SELECT * FROM   sysobjects WHERE  id = object_id(N'[dbo].[QRiskAssLimit]') and OBJECTPROPERTY(id, N'IsProcedure') = 1 )
begin
DROP Procedure QRiskAssLimit
end
GO
CREATE PROCEDURE QRiskAssLimit (@PANO as integer, @RType as varchar(10)='')                    
AS                    
SELECT top 1 RiskAss.RiskAss, Case When ReClass.AssessmentExInwardF=1 and Cover.ISType in ('R','T') Then 100 else RiskAss.PLimit end PLimit, Case When ReClass.AssessmentExInwardF=1 and Cover.ISType in ('R','T') Then 100 else RiskAss.Limit end Limit,
Cover.ISType, RiskAss.Code, RiskAss.HoldF, RiskAss.Share, RiskAss.Rate, RiskAss.Loading, RiskAss.RType                    
From Acceptance
Inner Join Cover on (Cover.CNO=Acceptance.CNO)
Inner Join AInfo on (AInfo.ANO=Acceptance.ANO)
Inner Join RArrHeader on (RArrHeader.ANO=Acceptance.ANO)
Inner Join Reinsurance on (Reinsurance.RType In ('D','Q','S1','S2','S3','A') and RArrHeader.RDate Between Reinsurance.SDate and Reinsurance.EDate)
Inner Join ReClass on (ReClass.RNO=Reinsurance.RNO and ReClass.TOC=Acceptance.TOC and ReClass.AssessmentF=1)
Left Join RiskAss on (
	(RiskAss.RType='' or RiskAss.RType=@RType)
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
)
WHERE Acceptance.ANO=@PANO 
Order by                   
RiskAss.RYear Desc,        
RiskAss.RType Desc,            
RiskAss.PriorityF Desc,                  
len(coalesce(RiskAss.ValueID1,'')) Desc, len(coalesce(RiskAss.ValueID2,'')) Desc, len(coalesce(RiskAss.ValueID3,'')) Desc, len(coalesce(RiskAss.ValueID4,'')) Desc, len(coalesce(RiskAss.ValueID5,'')) Desc,                   
len(coalesce(RiskAss.ValueID6,'')) Desc, len(coalesce(RiskAss.ValueID7,'')) Desc, len(coalesce(RiskAss.ValueID8,'')) Desc, len(coalesce(RiskAss.ValueID9,'')) Desc, len(coalesce(RiskAss.ValueID10,'')) Desc,                   
len(coalesce(RiskAss.ValueID11,'')) Desc, len(coalesce(RiskAss.ValueID12,'')) Desc, len(coalesce(RiskAss.ValueID13,'')) Desc, len(coalesce(RiskAss.ValueID14,'')) Desc, len(coalesce(RiskAss.ValueID15,'')) Desc,                   
RiskAss.Limit Desc, RiskAss.Loading, RiskAss.HoldF        

GO

IF EXISTS ( SELECT * FROM   sysobjects WHERE  id = object_id(N'[dbo].[PI07]') and OBJECTPROPERTY(id, N'IsProcedure') = 1 )
begin
DROP Procedure PI07
end
GO
CREATE Procedure PI07(@P_ANO as integer)  
as  
    
select Claim.CNO, Claim.ClaimNo, Claim.LossDate, Profile.Name, Claim.Description, Claim.CStatus, CCalc.Currency, CCalc.Loss, CCalc.Claim, CCalc.Deductible, CCalc.Cost, CCalc.Salvage, CCalc.Subrogation  
From CLAIM
Left Join Profile on (Profile.ID=Claim.Claimant)
Left Join CCalc on (CCalc.CNO=Claim.CNO)
Where (Claim.Cstatus in ('R','P','T','A') or (Claim.Cstatus='C' and Claim.pCStatus<>''))
and Exists
(
Select A2.ANO from Acceptance A1, Acceptance A2 
Where A1.ANO=@P_ANO and A2.OANO=A1.OANO and A2.ANO=Claim.ANO
Union All
Select A3.ANO from Acceptance A1, Acceptance A2, Acceptance A3 
Where A1.ANO=@P_ANO and A2.ANO=A1.RANO and A3.OANO=A2.OANO and A3.ANO=Claim.ANO
Union All
Select A4.ANO from Acceptance A1, Acceptance A2, Acceptance A3, Acceptance A4
Where A1.ANO=@P_ANO and A2.ANO=A1.RANO and A3.ANO=A2.RANO and A4.OANO=A3.OANO and A4.ANO=Claim.ANO
)
Order by Claim.LossDate Desc


GO


IF EXISTS ( SELECT * FROM   sysobjects WHERE  id = object_id(N'[dbo].[QScheme_Verify_3]') and OBJECTPROPERTY(id, N'IsProcedure') = 1 )
begin
DROP Procedure QScheme_Verify_3
end
GO
CREATE Procedure QScheme_Verify_3 
@P_Coverage as varchar(255), 
@P_Code as varchar(10), 
@p_LMonth as float, 
@p_UMonth as float, 
@p_SchemeNo as varchar (10), 
@p_Description as varchar (255), 
@P_TSI as float=0 
as 
 
Declare @p_ClassNo int 
Declare @P_SIInceptionF Bit 
Select Top 1 @p_ClassNo=S2.ClassNo, @P_SIInceptionF=S1.SIInceptionF 
from scheme_Master S1, Scheme_Class S2 
Where S1.SchemeNo=@P_SchemeNo and S2.SchemeNo=S1.SchemeNo and @P_Description like S2.Description 
Order by S2.Priority Desc 
 
Select 
S1.Lower, 
S1.NoRefundF, 
S1.RateLoadingF, 
Coalesce(SI1.HoldF, S1.HoldF) as HoldF, 
Max(S1.Upper)as Upper, 
Max(coalesce(SI1.PCTLoss, S1.PCTLoss)) as PCTLoss, 
Max(coalesce(SI1.PAddition, S1.PAddition)) as PAddition, 
Max(coalesce(SI1.Discount, S1.Discount)) as Discount, 
Max(coalesce(SI1.RateLower, S1.RateLower)) as RateLower, 
Max(coalesce(SI1.Rate,S1.Rate)) as Rate 
From 
Scheme_Indemnity S1 
Left Join Scheme_Indemnity_TSI SI1 
On (SI1.ClassNo=S1.ClassNo and SI1.Coverage=S1.Coverage and SI1.Code=S1.Code and SI1.Lower=S1.Lower and SI1.Upper=S1.Upper 
-- Range by TSI Compare to Header Only Percentage Of Loss
and (@P_TSI*Case When @P_SIInceptionF=1 Then 1 Else S1.PCTLoss/100 end>=SI1.MinTSI or SI1.MinTSI=0) and (@P_TSI*Case When @P_SIInceptionF=1 Then 1 Else S1.PCTLoss/100 end<=SI1.MaxTSI or SI1.MaxTSI=0)) 
Where 
S1.ClassNo=@P_ClassNo 
and S1.Coverage=@P_Coverage 
and S1.Code=@P_Code 
and 
( 
(S1.Lower>=@p_LMonth and S1.Upper<=@p_UMonth) 
or 
(S1.Lower<=@p_LMonth and S1.Upper>=@p_UMonth) 
or 
(S1.Lower<=@p_LMonth and S1.Upper>=@p_LMonth) 
or 
(S1.Lower<=@p_UMonth and S1.Upper>=@p_UMonth) 
) 
and NOT EXISTS (Select S3.ClassNo from Scheme_Indemnity S3 Where S3.ClassNo=S1.ClassNo and S3.Coverage=S1.Coverage and S3.Code=S1.Code and S1.Lower=S3.Lower and S1.Upper>S3.Upper and S3.Lower<=@P_LMonth and S3.Upper>=@P_UMonth) 
and NOT EXISTS (Select S3.ClassNo from Scheme_Indemnity S3 Where S3.ClassNo=S1.ClassNo and S3.Coverage=S1.Coverage and S3.Code=S1.Code and S1.Lower=S3.Lower and S1.Upper<S3.Upper and S3.Lower>=@P_LMonth and S3.Upper<=@P_UMonth) 
Group By S1.Lower, S1.NoRefundF, S1.RateLoadingF, Coalesce(SI1.HoldF, S1.HoldF) 
Order By S1.Lower, S1.NoRefundF, S1.RateLoadingF, Coalesce(SI1.HoldF, S1.HoldF) 
 
GO


IF EXISTS ( SELECT * FROM   sysobjects WHERE  id = object_id(N'[dbo].[CLItemLossTo]') and OBJECTPROPERTY(id, N'IsProcedure') = 1 )
begin
DROP Procedure CLItemLossTo
end
GO
CREATE PROCEDURE CLItemLossTo (@P_CNO as integer, @P_Currency as varchar(255))       
AS
SELECT CNO, PAYMENT, CURRENCY, REFNO, SUM(CLAIM) AS CLAIM, SUM(TAX) AS TAX, SUM(DEDUCTIBLE) AS DEDUCTIBLE
FROM
(
	SELECT CLLOSS.CNO, CLLOSS.INO, CLLOSS.NOC, CLLOSS.Payment, CLLOSS.CURRENCY, CLLOSS.RefNo,  
	 Max(    
	  CASE            
	   WHEN CLLOSS.STATUS<>'P' THEN 0
	   WHEN CLLOSS.VAR<=CLLOSS.DECLARED THEN (CLLOSS.AMOUNT)             
	   ELSE (CLLOSS.DECLARED/CLLOSS.VAR) * (CLLOSS.AMOUNT)             
	  END    
	 ) as CLAIM,            
	 Max(    
	  CASE            
	   WHEN CLLOSS.STATUS<>'P' THEN 0
	   WHEN CLLOSS.VAR<=CLLOSS.DECLARED THEN (CLLOSS.TAX)             
	   ELSE (CLLOSS.DECLARED/CLLOSS.VAR) * (CLLOSS.TAX)             
	  END    
	 ) as TAX,            
	 Max(    
	  CASE            
	   WHEN CLLOSS.STATUS<>'P' THEN 0
	   WHEN CLLOSS.VAR<=CLLOSS.DECLARED THEN CLLOSS.AMOUNT            
	   ELSE (CLLOSS.DECLARED/CLLOSS.VAR) * CLLOSS.AMOUNT            
	  END*(RCOVER.COSHARE)/100    
	 ) +
	 Max(    
	  CASE            
	   WHEN CLLOSS.STATUS<>'P' THEN 0
	   WHEN CLLOSS.VAR<=CLLOSS.DECLARED THEN CLLOSS.DEPRECIATION            
	   ELSE (CLLOSS.DECLARED/CLLOSS.VAR) * CLLOSS.DEPRECIATION
	  END
	 ) 
	 as DEDUCTIBLE
	From CLLOSS, CLAIM, RCOVER, ICALC, ACCEPTANCE, COVER, COL    
	WHERE CLAIM.CNO=@P_CNO AND CLLOSS.CURRENCY=@P_CURRENCY AND CLAIM.CNO=CLLOSS.CNO 
	AND ACCEPTANCE.ANO=CLAIM.ANO AND COVER.CNO=ACCEPTANCE.CNO AND RCOVER.ANO=ACCEPTANCE.ANO            
	AND ((RCOVER.SDATE<=CLAIM.LOSSDATE AND ACCEPTANCE.ExclusiveF=1) or ((RCOVER.SDATE<CLAIM.LOSSDATE or (RCOVER.SDATE=CLAIM.LOSSDATE AND ACCEPTANCE.STIME<=Claim.LossTime)) AND ACCEPTANCE.ExclusiveF=0))           
	AND ((dbo.fn_Get_ExtPeriodDate(ACCEPTANCE.ExtPeriod, ACCEPTANCE.ExtPeriodInDaysF, RCOVER.EDATE)>CLAIM.LOSSDATE AND ACCEPTANCE.ExclusiveF=1) or ((dbo.fn_Get_ExtPeriodDate(ACCEPTANCE.ExtPeriod, ACCEPTANCE.ExtPeriodInDaysF, RCOVER.EDATE)>CLAIM.LOSSDATE or (dbo.fn_Get_ExtPeriodDate(ACCEPTANCE.ExtPeriod, ACCEPTANCE.ExtPeriodInDaysF, RCOVER.EDATE)=CLAIM.LOSSDATE AND ACCEPTANCE.ETIME>Claim.LossTime)) AND ACCEPTANCE.ExclusiveF=0))          
	AND ICALC.ANO=RCOVER.ANO AND ICALC.CODE=RCOVER.CODE AND ICALC.SDATE=RCOVER.SDATE     
	AND ICALC.INO=CLLOSS.INO    
	AND COL.COL=CLAIM.COL AND COL.TOR=ICALC.TOR    
	Group By CLLOSS.CNO, CLLOSS.INO, CLLOSS.NOC, CLLOSS.Payment, CLLOSS.CURRENCY, CLLOSS.RefNo
) CLLOSS
Group BY CNO, PAYMENT, CURRENCY, REFNO

GO

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[VOUCHER_AMOUNTPERIODDUE]') AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) ) 
begin
DROP FUNCTION VOUCHER_AMOUNTPERIODDUE 
end
GO
CREATE function VOUCHER_AMOUNTPERIODDUE(@P_SDate as smalldatetime, @P_EDate as smalldatetime)      
RETURNS Table      
AS RETURN      
(      
Select Distinct V.Voucher, V.Branch, V.ProAcc, V.RefNo, V.DocNo, V.Currency, V.Installment, V.Payment_CC, V.Payment_OC, V.DebtorF, V.CreditorF, V.StatID, V.ActionBy, V.ActionDate,  V.AcceptedBy, V.AcceptedDate,        
(Case When V.Installment=0 and V.DueDate Between @P_SDate and @P_EDate Then V.Nominal_CC-V.Diff_CC else 0 end+      

Case When V.Installment>=1 and V.DueDate_1 Between @P_SDate and @P_EDate  Then V.AmountDue_1 else 0 end+      
Case When V.Installment>=2 and V.DueDate_2 Between @P_SDate and @P_EDate  Then V.AmountDue_2 else 0 end+      
Case When V.Installment>=3 and V.DueDate_3 Between @P_SDate and @P_EDate  Then V.AmountDue_3 else 0 end+      
Case When V.Installment>=4 and V.DueDate_4 Between @P_SDate and @P_EDate  Then V.AmountDue_4 else 0 end+      
Case When V.Installment>=5 and V.DueDate_5 Between @P_SDate and @P_EDate  Then V.AmountDue_5 else 0 end+      
Case When V.Installment>=6 and V.DueDate_6 Between @P_SDate and @P_EDate  Then V.AmountDue_6 else 0 end+      
Case When V.Installment>=7 and V.DueDate_7 Between @P_SDate and @P_EDate  Then V.AmountDue_7 else 0 end+      
Case When V.Installment>=8 and V.DueDate_8 Between @P_SDate and @P_EDate  Then V.AmountDue_8 else 0 end+      
Case When V.Installment>=9 and V.DueDate_9 Between @P_SDate and @P_EDate  Then V.AmountDue_9 else 0 end+      
Case When V.Installment>=10 and V.DueDate_10 Between @P_SDate and @P_EDate  Then V.AmountDue_10 else 0 end+      
Case When V.Installment>=11 and V.DueDate_11 Between @P_SDate and @P_EDate  Then V.AmountDue_11 else 0 end+      
Case When V.Installment>=12 and V.DueDate_12 Between @P_SDate and @P_EDate  Then V.AmountDue_12 else 0 end+
Case When V.Installment>=13 and V.DueDate_13 Between @P_SDate and @P_EDate  Then V.AmountDue_13 else 0 end+      
Case When V.Installment>=14 and V.DueDate_14 Between @P_SDate and @P_EDate  Then V.AmountDue_14 else 0 end+      
Case When V.Installment>=15 and V.DueDate_15 Between @P_SDate and @P_EDate  Then V.AmountDue_15 else 0 end+      
Case When V.Installment>=16 and V.DueDate_16 Between @P_SDate and @P_EDate  Then V.AmountDue_16 else 0 end+      
Case When V.Installment>=17 and V.DueDate_17 Between @P_SDate and @P_EDate  Then V.AmountDue_17 else 0 end+      
Case When V.Installment>=18 and V.DueDate_18 Between @P_SDate and @P_EDate  Then V.AmountDue_18 else 0 end+      
Case When V.Installment>=19 and V.DueDate_19 Between @P_SDate and @P_EDate  Then V.AmountDue_19 else 0 end+      
Case When V.Installment>=20 and V.DueDate_20 Between @P_SDate and @P_EDate  Then V.AmountDue_20 else 0 end+      
Case When V.Installment>=21 and V.DueDate_21 Between @P_SDate and @P_EDate  Then V.AmountDue_21 else 0 end+      
Case When V.Installment>=22 and V.DueDate_22 Between @P_SDate and @P_EDate  Then V.AmountDue_22 else 0 end+      
Case When V.Installment>=23 and V.DueDate_23 Between @P_SDate and @P_EDate  Then V.AmountDue_23 else 0 end+      
Case When V.Installment>=24 and V.DueDate_24 Between @P_SDate and @P_EDate  Then V.AmountDue_24 else 0 end
) as AmountDue,      

Case  
When V.Installment>=24 and V.DueDate_24 Between @P_SDate and @P_EDate  Then V.DueDate_24    
When V.Installment>=23 and V.DueDate_23 Between @P_SDate and @P_EDate  Then V.DueDate_23    
When V.Installment>=22 and V.DueDate_22 Between @P_SDate and @P_EDate  Then V.DueDate_22    
When V.Installment>=21 and V.DueDate_21 Between @P_SDate and @P_EDate  Then V.DueDate_21       
When V.Installment>=20 and V.DueDate_20 Between @P_SDate and @P_EDate  Then V.DueDate_20    
When V.Installment>=19 and V.DueDate_19 Between @P_SDate and @P_EDate  Then V.DueDate_19    
When V.Installment>=18 and V.DueDate_18 Between @P_SDate and @P_EDate  Then V.DueDate_18    
When V.Installment>=17 and V.DueDate_17 Between @P_SDate and @P_EDate  Then V.DueDate_17    
When V.Installment>=16 and V.DueDate_16 Between @P_SDate and @P_EDate  Then V.DueDate_16    
When V.Installment>=15 and V.DueDate_15 Between @P_SDate and @P_EDate  Then V.DueDate_15
When V.Installment>=14 and V.DueDate_14 Between @P_SDate and @P_EDate  Then V.DueDate_14    
When V.Installment>=13 and V.DueDate_13 Between @P_SDate and @P_EDate  Then V.DueDate_13    
When V.Installment>=12 and V.DueDate_12 Between @P_SDate and @P_EDate  Then V.DueDate_12    
When V.Installment>=11 and V.DueDate_11 Between @P_SDate and @P_EDate  Then V.DueDate_11        
When V.Installment>=10 and V.DueDate_10 Between @P_SDate and @P_EDate  Then V.DueDate_10    
When V.Installment>=9 and V.DueDate_9 Between @P_SDate and @P_EDate  Then V.DueDate_9    
When V.Installment>=8 and V.DueDate_8 Between @P_SDate and @P_EDate  Then V.DueDate_8    
When V.Installment>=7 and V.DueDate_7 Between @P_SDate and @P_EDate  Then V.DueDate_7    
When V.Installment>=6 and V.DueDate_6 Between @P_SDate and @P_EDate  Then V.DueDate_6    
When V.Installment>=5 and V.DueDate_5 Between @P_SDate and @P_EDate  Then V.DueDate_5    
When V.Installment>=4 and V.DueDate_4 Between @P_SDate and @P_EDate  Then V.DueDate_4    
When V.Installment>=3 and V.DueDate_3 Between @P_SDate and @P_EDate  Then V.DueDate_3    
When V.Installment>=2 and V.DueDate_2 Between @P_SDate and @P_EDate  Then V.DueDate_2    
When V.Installment>=1 and V.DueDate_1 Between @P_SDate and @P_EDate  Then V.DueDate_1    
Else V.DueDate End as DueDate,        

(Case When V.Installment<>0 then ' Installment No. ' else '' end+      
Case When V.Installment>=1 and V.DueDate_1 Between @P_SDate and @P_EDate  Then '1 ' else '' end+      
Case When V.Installment>=2 and V.DueDate_2 Between @P_SDate and @P_EDate  Then '2 ' else '' end+      
Case When V.Installment>=3 and V.DueDate_3 Between @P_SDate and @P_EDate  Then '3 ' else '' end+      
Case When V.Installment>=4 and V.DueDate_4 Between @P_SDate and @P_EDate  Then '4 ' else '' end+      
Case When V.Installment>=5 and V.DueDate_5 Between @P_SDate and @P_EDate  Then '5 ' else '' end+      
Case When V.Installment>=6 and V.DueDate_6 Between @P_SDate and @P_EDate  Then '6 ' else '' end+      
Case When V.Installment>=7 and V.DueDate_7 Between @P_SDate and @P_EDate  Then '7 ' else '' end+      
Case When V.Installment>=8 and V.DueDate_8 Between @P_SDate and @P_EDate  Then '8 ' else '' end+      
Case When V.Installment>=9 and V.DueDate_9 Between @P_SDate and @P_EDate  Then '9 ' else '' end+      
Case When V.Installment>=10 and V.DueDate_10 Between @P_SDate and @P_EDate  Then '10 ' else '' end+      
Case When V.Installment>=11 and V.DueDate_11 Between @P_SDate and @P_EDate  Then '11 ' else '' end+      
Case When V.Installment>=12 and V.DueDate_12 Between @P_SDate and @P_EDate  Then '12 ' else '' end+      
Case When V.Installment>=13 and V.DueDate_13 Between @P_SDate and @P_EDate  Then '13 ' else '' end+      
Case When V.Installment>=14 and V.DueDate_14 Between @P_SDate and @P_EDate  Then '14 ' else '' end+      
Case When V.Installment>=15 and V.DueDate_15 Between @P_SDate and @P_EDate  Then '15 ' else '' end+      
Case When V.Installment>=16 and V.DueDate_16 Between @P_SDate and @P_EDate  Then '16 ' else '' end+      
Case When V.Installment>=17 and V.DueDate_17 Between @P_SDate and @P_EDate  Then '17 ' else '' end+      
Case When V.Installment>=18 and V.DueDate_18 Between @P_SDate and @P_EDate  Then '18 ' else '' end+      
Case When V.Installment>=19 and V.DueDate_19 Between @P_SDate and @P_EDate  Then '19 ' else '' end+      
Case When V.Installment>=20 and V.DueDate_20 Between @P_SDate and @P_EDate  Then '20 ' else '' end+      
Case When V.Installment>=21 and V.DueDate_21 Between @P_SDate and @P_EDate  Then '21 ' else '' end+      
Case When V.Installment>=22 and V.DueDate_22 Between @P_SDate and @P_EDate  Then '22 ' else '' end+      
Case When V.Installment>=23 and V.DueDate_23 Between @P_SDate and @P_EDate  Then '23 ' else '' end+      
Case When V.Installment>=24 and V.DueDate_24 Between @P_SDate and @P_EDate  Then '24 '      
Else '' end+      
Case When V.Installment<>0 then 'of '+cast(V.Installment as varchar(255)) else '' end) as sInstallment      
from nVoucher V inner join Admlink A On (A.Voucher=V.Voucher)                  

)      

GO

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[VOUCHER_AMOUNTDUE]') AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) ) 
begin
DROP FUNCTION VOUCHER_AMOUNTDUE 
end
GO
CREATE function VOUCHER_AMOUNTDUE(@P_Date as smalldatetime) 
RETURNS Table 
AS RETURN 
( 
Select Distinct V.Voucher, V.CollNo, V.Branch, V.ProAcc, V.RefNo, V.DocNo, V.Currency, V.Installment, V.Payment_CC, V.Payment_OC, V.DebtorF, V.CreditorF, V.StatID, V.ActionBy, V.ActionDate,  V.AcceptedBy, V.AcceptedDate, 
(Case When V.Installment=0 and V.DueDate <=@P_Date Then V.Nominal_CC-V.Diff_CC else 0 end+ 
Case When V.Installment>=1 and V.DueDate_1 <=@P_Date Then V.AmountDue_1 else 0 end+ 
Case When V.Installment>=2 and V.DueDate_2 <=@P_Date Then V.AmountDue_2 else 0 end+ 
Case When V.Installment>=3 and V.DueDate_3 <=@P_Date Then V.AmountDue_3 else 0 end+ 
Case When V.Installment>=4 and V.DueDate_4 <=@P_Date Then V.AmountDue_4 else 0 end+ 
Case When V.Installment>=5 and V.DueDate_5 <=@P_Date Then V.AmountDue_5 else 0 end+ 
Case When V.Installment>=6 and V.DueDate_6 <=@P_Date Then V.AmountDue_6 else 0 end+ 
Case When V.Installment>=7 and V.DueDate_7 <=@P_Date Then V.AmountDue_7 else 0 end+ 
Case When V.Installment>=8 and V.DueDate_8 <=@P_Date Then V.AmountDue_8 else 0 end+ 
Case When V.Installment>=9 and V.DueDate_9 <=@P_Date Then V.AmountDue_9 else 0 end+ 
Case When V.Installment>=10 and V.DueDate_10 <=@P_Date Then V.AmountDue_10 else 0 end+ 
Case When V.Installment>=11 and V.DueDate_11 <=@P_Date Then V.AmountDue_11 else 0 end+ 
Case When V.Installment>=12 and V.DueDate_12 <=@P_Date Then V.AmountDue_12 else 0 end+ 
Case When V.Installment>=13 and V.DueDate_13 <=@P_Date Then V.AmountDue_13 else 0 end+ 
Case When V.Installment>=14 and V.DueDate_14 <=@P_Date Then V.AmountDue_14 else 0 end+ 
Case When V.Installment>=15 and V.DueDate_15 <=@P_Date Then V.AmountDue_15 else 0 end+ 
Case When V.Installment>=16 and V.DueDate_16 <=@P_Date Then V.AmountDue_16 else 0 end+ 
Case When V.Installment>=17 and V.DueDate_17 <=@P_Date Then V.AmountDue_17 else 0 end+ 
Case When V.Installment>=18 and V.DueDate_18 <=@P_Date Then V.AmountDue_18 else 0 end+ 
Case When V.Installment>=19 and V.DueDate_19 <=@P_Date Then V.AmountDue_19 else 0 end+ 
Case When V.Installment>=20 and V.DueDate_20 <=@P_Date Then V.AmountDue_20 else 0 end+ 
Case When V.Installment>=21 and V.DueDate_21 <=@P_Date Then V.AmountDue_21 else 0 end+ 
Case When V.Installment>=22 and V.DueDate_22 <=@P_Date Then V.AmountDue_22 else 0 end+ 
Case When V.Installment>=23 and V.DueDate_23 <=@P_Date Then V.AmountDue_23 else 0 end+ 
Case When V.Installment>=24 and V.DueDate_24 <=@P_Date Then V.AmountDue_24 else 0 end) as AmountDue, 
 
Case When V.Installment=0 then V.DueDate 
When V.Payment_CC<V.AmountDue_1 then V.DueDate_1 
When V.Payment_CC<V.AmountDue_1+V.AmountDue_2 then V.DueDate_2 
When V.Payment_CC<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3 then V.DueDate_3 
When V.Payment_CC<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4 then V.DueDate_4 
When V.Payment_CC<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5 then V.DueDate_5 
When V.Payment_CC<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6 then V.DueDate_6 
When V.Payment_CC<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7 then V.DueDate_7 
When V.Payment_CC<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8 then V.DueDate_8 
When V.Payment_CC<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9 then V.DueDate_9 
When V.Payment_CC<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10 then V.DueDate_10 
When V.Payment_CC<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11 then V.DueDate_11 
When V.Payment_CC<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12 then V.DueDate_12 
When V.Payment_CC<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13 then V.DueDate_13 
When V.Payment_CC<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14 then V.DueDate_14 
When V.Payment_CC<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15 then V.DueDate_15 
When V.Payment_CC<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16 then V.DueDate_16 
When V.Payment_CC<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16+V.AmountDue_17 then V.DueDate_17 
When V.Payment_CC<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16+V.AmountDue_17+V.AmountDue_18 then V.DueDate_18 
When V.Payment_CC<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16+V.AmountDue_17+V.AmountDue_18+V.AmountDue_19 then V.DueDate_19 
When V.Payment_CC<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16+V.AmountDue_17+V.AmountDue_18+V.AmountDue_19+V.AmountDue_20 then V.DueDate_20 
When V.Payment_CC<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16+V.AmountDue_17+V.AmountDue_18+V.AmountDue_19+V.AmountDue_20+V.AmountDue_21 then V.DueDate_21 
When V.Payment_CC<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16+V.AmountDue_17+V.AmountDue_18+V.AmountDue_19+V.AmountDue_20+V.AmountDue_21+V.AmountDue_22 then V.DueDate_22 
When V.Payment_CC<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16+V.AmountDue_17+V.AmountDue_18+V.AmountDue_19+V.AmountDue_20+V.AmountDue_21+V.AmountDue_22+V.AmountDue_23 then V.DueDate_23 
Else V.DueDate_24 
end as DueDate, 
(Case When V.Installment<>0 then ' Installment No. ' else '' end+ 
Case When V.Installment>=1 and V.DueDate_1 <=@P_Date and V.Payment_CC<V.AmountDue_1 Then '1 ' else '' end+ 
Case When V.Installment>=2 and V.DueDate_2 <=@P_Date and V.Payment_CC<V.AmountDue_1+V.AmountDue_2 Then '2 ' else '' end+ 
Case When V.Installment>=3 and V.DueDate_3 <=@P_Date and V.Payment_CC<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3 Then '3 ' else '' end+ 
Case When V.Installment>=4 and V.DueDate_4 <=@P_Date and V.Payment_CC<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4 Then '4 ' else '' end+ 
Case When V.Installment>=5 and V.DueDate_5 <=@P_Date and V.Payment_CC<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5 Then '5 ' else '' end+ 
Case When V.Installment>=6 and V.DueDate_6 <=@P_Date and V.Payment_CC<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6 Then '6 ' else '' end+ 
Case When V.Installment>=7 and V.DueDate_7 <=@P_Date and V.Payment_CC<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7 Then '7 ' else '' end+ 
Case When V.Installment>=8 and V.DueDate_8 <=@P_Date and V.Payment_CC<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8 Then '8 ' else '' end+ 
Case When V.Installment>=9 and V.DueDate_9 <=@P_Date and V.Payment_CC<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9 Then '9 ' else '' end+ 
Case When V.Installment>=10 and V.DueDate_10 <=@P_Date and V.Payment_CC<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10  Then '10 ' else '' end+ 
Case When V.Installment>=11 and V.DueDate_11 <=@P_Date and V.Payment_CC<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11 Then '11 ' else '' end+ 
Case When V.Installment>=12 and V.DueDate_12 <=@P_Date and V.Payment_CC<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12 Then '12 ' else '' end+ 
Case When V.Installment>=13 and V.DueDate_13 <=@P_Date and V.Payment_CC<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13 Then '13 ' else '' end+ 
Case When V.Installment>=14 and V.DueDate_14 <=@P_Date and V.Payment_CC<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14 Then '14 ' else '' end+ 
Case When V.Installment>=15 and V.DueDate_15 <=@P_Date and V.Payment_CC<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15 Then '15 ' else '' end+ 
Case When V.Installment>=16 and V.DueDate_16 <=@P_Date and V.Payment_CC<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16 Then '16 ' else '' end+ 
Case When V.Installment>=17 and V.DueDate_17 <=@P_Date and V.Payment_CC<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16+V.AmountDue_17 Then '17 ' else '' end+ 
Case When V.Installment>=18 and V.DueDate_18 <=@P_Date and V.Payment_CC<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16+V.AmountDue_17+V.AmountDue_18 Then '18 ' else '' end+ 
Case When V.Installment>=19 and V.DueDate_19 <=@P_Date and V.Payment_CC<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16+V.AmountDue_17+V.AmountDue_18+V.AmountDue_19 Then '19 ' else '' end+ 
Case When V.Installment>=20 and V.DueDate_20 <=@P_Date and V.Payment_CC<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16+V.AmountDue_17+V.AmountDue_18+V.AmountDue_19+V.AmountDue_20 Then '20 ' else '' end+ 
Case When V.Installment>=21 and V.DueDate_21 <=@P_Date and V.Payment_CC<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16+V.AmountDue_17+V.AmountDue_18+V.AmountDue_19+V.AmountDue_20+V.AmountDue_21 Then '21 ' else '' end+ 
Case When V.Installment>=22 and V.DueDate_22 <=@P_Date and V.Payment_CC<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16+V.AmountDue_17+V.AmountDue_18+V.AmountDue_19+V.AmountDue_20+V.AmountDue_21+V.AmountDue_22 Then '22 ' else '' end+ 
Case When V.Installment>=23 and V.DueDate_23 <=@P_Date and V.Payment_CC<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16+V.AmountDue_17+V.AmountDue_18+V.AmountDue_19+V.AmountDue_20+V.AmountDue_21+V.AmountDue_22+V.AmountDue_23 Then '23 ' else '' end+ 
Case When V.Installment>=24 and V.DueDate_24 <=@P_Date and V.Payment_CC<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16+V.AmountDue_17+V.AmountDue_18+V.AmountDue_19+V.AmountDue_20+V.AmountDue_21+V.AmountDue_22+V.AmountDue_23+V.AmountDue_24 Then '24 ' else '' end+ 
Case When V.Installment<>0 then 'of '+cast(V.Installment as varchar(255)) else '' end) as sInstallment 
from nVoucher V 
Where V.Date<=@P_Date and ((V.Nominal_CC-V.Diff_CC-V.Payment_CC-V.Payment_OC)<>0 or V.PDate>=@P_Date) 
) 

GO

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[VOUCHER_AMOUNTWPCDUE]') AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) ) 
begin
DROP FUNCTION VOUCHER_AMOUNTWPCDUE 
end
GO
CREATE function VOUCHER_AMOUNTWPCDUE(@P_Date as smalldatetime) 
RETURNS Table 
AS RETURN 
( 
Select Distinct V.Voucher, V.Branch, V.CollNo, V.ProAcc, V.RefNo, V.DocNo, V.Currency, V.Installment, V.Payment_CC, V.Payment_OC, V.DebtorF, V.CreditorF, V.StatID, V.ActionBy, V.ActionDate,  V.AcceptedBy, V.AcceptedDate, 
(Case When V.Installment=0 and dateadd(day,A.WPC,V.DueDate) <=@P_Date Then V.Nominal_CC-V.Diff_CC else 0 end+ 
Case When V.Installment>=1 and V.DueDate_1 <=@P_Date Then V.AmountDue_1 else 0 end+ 
Case When V.Installment>=2 and V.DueDate_2 <=@P_Date Then V.AmountDue_2 else 0 end+ 
Case When V.Installment>=3 and V.DueDate_3 <=@P_Date Then V.AmountDue_3 else 0 end+ 
Case When V.Installment>=4 and V.DueDate_4 <=@P_Date Then V.AmountDue_4 else 0 end+ 
Case When V.Installment>=5 and V.DueDate_5 <=@P_Date Then V.AmountDue_5 else 0 end+ 
Case When V.Installment>=6 and V.DueDate_6 <=@P_Date Then V.AmountDue_6 else 0 end+ 
Case When V.Installment>=7 and V.DueDate_7 <=@P_Date Then V.AmountDue_7 else 0 end+ 
Case When V.Installment>=8 and V.DueDate_8 <=@P_Date Then V.AmountDue_8 else 0 end+ 
Case When V.Installment>=9 and V.DueDate_9 <=@P_Date Then V.AmountDue_9 else 0 end+ 
Case When V.Installment>=10 and V.DueDate_10 <=@P_Date Then V.AmountDue_10 else 0 end+ 
Case When V.Installment>=11 and V.DueDate_11 <=@P_Date Then V.AmountDue_11 else 0 end+ 
Case When V.Installment>=12 and V.DueDate_12 <=@P_Date Then V.AmountDue_12 else 0 end+ 
Case When V.Installment>=13 and V.DueDate_13 <=@P_Date Then V.AmountDue_13 else 0 end+ 
Case When V.Installment>=14 and V.DueDate_14 <=@P_Date Then V.AmountDue_14 else 0 end+ 
Case When V.Installment>=15 and V.DueDate_15 <=@P_Date Then V.AmountDue_15 else 0 end+ 
Case When V.Installment>=16 and V.DueDate_16 <=@P_Date Then V.AmountDue_16 else 0 end+ 
Case When V.Installment>=17 and V.DueDate_17 <=@P_Date Then V.AmountDue_17 else 0 end+ 
Case When V.Installment>=18 and V.DueDate_18 <=@P_Date Then V.AmountDue_18 else 0 end+ 
Case When V.Installment>=19 and V.DueDate_19 <=@P_Date Then V.AmountDue_19 else 0 end+ 
Case When V.Installment>=20 and V.DueDate_20 <=@P_Date Then V.AmountDue_20 else 0 end+ 
Case When V.Installment>=21 and V.DueDate_21 <=@P_Date Then V.AmountDue_21 else 0 end+ 
Case When V.Installment>=22 and V.DueDate_22 <=@P_Date Then V.AmountDue_22 else 0 end+ 
Case When V.Installment>=23 and V.DueDate_23 <=@P_Date Then V.AmountDue_23 else 0 end+ 
Case When V.Installment>=24 and V.DueDate_24 <=@P_Date Then V.AmountDue_24 else 0 end) as AmountDue, 
 
Case When V.Installment=0 then dateadd(day, A.WPC,V.DueDate) 
When V.Payment_CC<V.AmountDue_1 then V.DueDate_1 
When V.Payment_CC<V.AmountDue_1+V.AmountDue_2 then V.DueDate_2 
When V.Payment_CC<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3 then V.DueDate_3 
When V.Payment_CC<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4 then V.DueDate_4 
When V.Payment_CC<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5 then V.DueDate_5 
When V.Payment_CC<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6 then V.DueDate_6 
When V.Payment_CC<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7 then V.DueDate_7 
When V.Payment_CC<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8 then V.DueDate_8 
When V.Payment_CC<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9 then V.DueDate_9 
When V.Payment_CC<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10 then V.DueDate_10 
When V.Payment_CC<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11 then V.DueDate_11 
When V.Payment_CC<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12 then V.DueDate_12 
When V.Payment_CC<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13 then V.DueDate_13 
When V.Payment_CC<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14 then V.DueDate_14 
When V.Payment_CC<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15 then V.DueDate_15 
When V.Payment_CC<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16 then V.DueDate_16 
When V.Payment_CC<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16+V.AmountDue_17 then V.DueDate_17 
When V.Payment_CC<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16+V.AmountDue_17+V.AmountDue_18 then V.DueDate_18 
When V.Payment_CC<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16+V.AmountDue_17+V.AmountDue_18+V.AmountDue_19 then V.DueDate_19 
When V.Payment_CC<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16+V.AmountDue_17+V.AmountDue_18+V.AmountDue_19+V.AmountDue_20 then V.DueDate_20 
When V.Payment_CC<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16+V.AmountDue_17+V.AmountDue_18+V.AmountDue_19+V.AmountDue_20+V.AmountDue_21 then V.DueDate_21 
When V.Payment_CC<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16+V.AmountDue_17+V.AmountDue_18+V.AmountDue_19+V.AmountDue_20+V.AmountDue_21+V.AmountDue_22 then V.DueDate_22 
When V.Payment_CC<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16+V.AmountDue_17+V.AmountDue_18+V.AmountDue_19+V.AmountDue_20+V.AmountDue_21+V.AmountDue_22+V.AmountDue_23 then V.DueDate_23 Else V.DueDate_24 
end as DueDate, 
(Case When V.Installment<>0 then ' Installment No. ' else '' end+ 
Case When V.Installment>=1 and V.DueDate_1 <=@P_Date and V.Payment_CC<V.AmountDue_1 Then '1 ' else '' end+ 
Case When V.Installment>=2 and V.DueDate_2 <=@P_Date and V.Payment_CC<V.AmountDue_1+V.AmountDue_2 Then '2 ' else '' end+ 
Case When V.Installment>=3 and V.DueDate_3 <=@P_Date and V.Payment_CC<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3 Then '3 ' else '' end+ 
Case When V.Installment>=4 and V.DueDate_4 <=@P_Date and V.Payment_CC<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4 Then '4 ' else '' end+ 
Case When V.Installment>=5 and V.DueDate_5 <=@P_Date and V.Payment_CC<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5 Then '5 ' else '' end+ 
Case When V.Installment>=6 and V.DueDate_6 <=@P_Date and V.Payment_CC<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6 Then '6 ' else '' end+ 
Case When V.Installment>=7 and V.DueDate_7 <=@P_Date and V.Payment_CC<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7 Then '7 ' else '' end+ 
Case When V.Installment>=8 and V.DueDate_8 <=@P_Date and V.Payment_CC<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8 Then '8 ' else '' end+ 
Case When V.Installment>=9 and V.DueDate_9 <=@P_Date and V.Payment_CC<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9 Then '9 ' else '' end+ 
Case When V.Installment>=10 and V.DueDate_10 <=@P_Date and V.Payment_CC<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10  Then '10 ' else '' end+ 
Case When V.Installment>=11 and V.DueDate_11 <=@P_Date and V.Payment_CC<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11 Then '11 ' else '' end+ 
Case When V.Installment>=12 and V.DueDate_12 <=@P_Date and V.Payment_CC<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12 Then '12 ' else '' end+ 
Case When V.Installment>=13 and V.DueDate_13 <=@P_Date and V.Payment_CC<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13 Then '13 ' else '' end+ 
Case When V.Installment>=14 and V.DueDate_14 <=@P_Date and V.Payment_CC<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14 Then '14 ' else '' end+ 
Case When V.Installment>=15 and V.DueDate_15 <=@P_Date and V.Payment_CC<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15 Then '15 ' else '' end+ 
Case When V.Installment>=16 and V.DueDate_16 <=@P_Date and V.Payment_CC<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16 Then '16 ' else '' end+ 
Case When V.Installment>=17 and V.DueDate_17 <=@P_Date and V.Payment_CC<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16+V.AmountDue_17 Then '17 ' else '' end+ 
Case When V.Installment>=18 and V.DueDate_18 <=@P_Date and V.Payment_CC<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16+V.AmountDue_17+V.AmountDue_18 Then '18 ' else '' end+ 
Case When V.Installment>=19 and V.DueDate_19 <=@P_Date and V.Payment_CC<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16+V.AmountDue_17+V.AmountDue_18+V.AmountDue_19 Then '19 ' else '' end+ 
Case When V.Installment>=20 and V.DueDate_20 <=@P_Date and V.Payment_CC<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16+V.AmountDue_17+V.AmountDue_18+V.AmountDue_19+V.AmountDue_20 Then '20 ' else '' end+ 
Case When V.Installment>=21 and V.DueDate_21 <=@P_Date and V.Payment_CC<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16+V.AmountDue_17+V.AmountDue_18+V.AmountDue_19+V.AmountDue_20+V.AmountDue_21 Then '21 ' else '' end+ 
Case When V.Installment>=22 and V.DueDate_22 <=@P_Date and V.Payment_CC<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16+V.AmountDue_17+V.AmountDue_18+V.AmountDue_19+V.AmountDue_20+V.AmountDue_21+V.AmountDue_22 Then '22 ' else '' end+ 
Case When V.Installment>=23 and V.DueDate_23 <=@P_Date and V.Payment_CC<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16+V.AmountDue_17+V.AmountDue_18+V.AmountDue_19+V.AmountDue_20+V.AmountDue_21+V.AmountDue_22+V.AmountDue_23 Then '23 ' else '' end+ 
Case When V.Installment>=24 and V.DueDate_24 <=@P_Date and V.Payment_CC<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16+V.AmountDue_17+V.AmountDue_18+V.AmountDue_19+V.AmountDue_20+V.AmountDue_21+V.AmountDue_22+V.AmountDue_23+V.AmountDue_24 Then '24 ' else '' end+ 
Case When V.Installment<>0 then 'of '+cast(V.Installment as varchar(255)) else '' end) as sInstallment 
from nVoucher V inner join Admlink A On (A.Voucher=V.Voucher) 
Where V.Date<=@P_Date and ((V.Nominal_CC-V.Diff_CC-V.Payment_CC-V.Payment_OC)<>0 or V.PDate>=@P_Date) 
) 
 
GO

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[VOUCHER_REMINDERDUE]') AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) ) 
begin
DROP FUNCTION VOUCHER_REMINDERDUE 
end
GO
CREATE function VOUCHER_REMINDERDUE(@P_Reminder as int, @P_Date as smalldatetime)      
RETURNS Table      
AS RETURN      
(      
Select Distinct V.Voucher, V.Date, V.Branch, V.VType, V.ProAcc, V.RefNo, V.SL_Cat, V.Remarks, V.DocNo, V.Currency, V.Installment, V.Payment_CC, V.Payment_OC, V.DebtorF, V.CreditorF,      
      
      
(Case When V.Installment=0 and datediff(day, V.DueDate, @P_Date)>=(Case When RD.ID is null then R.Day_1 else RD.Day_1 end) Then V.Nominal_CC-V.Diff_CC else 0 end+      
Case When V.Installment>=1 and datediff(day, V.DueDate_1, @P_Date)>=(Case When RD.ID is null then R.Day_1 else RD.Day_1 end) Then V.AmountDue_1 else 0 end+      
Case When V.Installment>=2 and datediff(day, V.DueDate_2, @P_Date)>=(Case When RD.ID is null then R.Day_1 else RD.Day_1 end) Then V.AmountDue_2 else 0 end+      
Case When V.Installment>=3 and datediff(day, V.DueDate_3, @P_Date)>=(Case When RD.ID is null then R.Day_1 else RD.Day_1 end) Then V.AmountDue_3 else 0 end+      
Case When V.Installment>=4 and datediff(day, V.DueDate_4, @P_Date)>=(Case When RD.ID is null then R.Day_1 else RD.Day_1 end) Then V.AmountDue_4 else 0 end+      
Case When V.Installment>=5 and datediff(day, V.DueDate_5, @P_Date)>=(Case When RD.ID is null then R.Day_1 else RD.Day_1 end) Then V.AmountDue_5 else 0 end+      
Case When V.Installment>=6 and datediff(day, V.DueDate_6, @P_Date)>=(Case When RD.ID is null then R.Day_1 else RD.Day_1 end) Then V.AmountDue_6 else 0 end+      
Case When V.Installment>=7 and datediff(day, V.DueDate_7, @P_Date)>=(Case When RD.ID is null then R.Day_1 else RD.Day_1 end) Then V.AmountDue_7 else 0 end+      
Case When V.Installment>=8 and datediff(day, V.DueDate_8, @P_Date)>=(Case When RD.ID is null then R.Day_1 else RD.Day_1 end) Then V.AmountDue_8 else 0 end+      
Case When V.Installment>=9 and datediff(day, V.DueDate_9, @P_Date)>=(Case When RD.ID is null then R.Day_1 else RD.Day_1 end) Then V.AmountDue_9 else 0 end+      
Case When V.Installment>=10 and datediff(day, V.DueDate_10, @P_Date)>=(Case When RD.ID is null then R.Day_1 else RD.Day_1 end) Then V.AmountDue_10 else 0 end+      
Case When V.Installment>=11 and datediff(day, V.DueDate_11, @P_Date)>=(Case When RD.ID is null then R.Day_1 else RD.Day_1 end) Then V.AmountDue_11 else 0 end+      
Case When V.Installment>=12 and datediff(day, V.DueDate_12, @P_Date)>=(Case When RD.ID is null then R.Day_1 else RD.Day_1 end) Then V.AmountDue_12 else 0 end+
Case When V.Installment>=13 and datediff(day, V.DueDate_13, @P_Date)>=(Case When RD.ID is null then R.Day_1 else RD.Day_1 end) Then V.AmountDue_13 else 0 end+      
Case When V.Installment>=14 and datediff(day, V.DueDate_14, @P_Date)>=(Case When RD.ID is null then R.Day_1 else RD.Day_1 end) Then V.AmountDue_14 else 0 end+      
Case When V.Installment>=15 and datediff(day, V.DueDate_15, @P_Date)>=(Case When RD.ID is null then R.Day_1 else RD.Day_1 end) Then V.AmountDue_15 else 0 end+      
Case When V.Installment>=16 and datediff(day, V.DueDate_16, @P_Date)>=(Case When RD.ID is null then R.Day_1 else RD.Day_1 end) Then V.AmountDue_16 else 0 end+      
Case When V.Installment>=17 and datediff(day, V.DueDate_17, @P_Date)>=(Case When RD.ID is null then R.Day_1 else RD.Day_1 end) Then V.AmountDue_17 else 0 end+      
Case When V.Installment>=18 and datediff(day, V.DueDate_18, @P_Date)>=(Case When RD.ID is null then R.Day_1 else RD.Day_1 end) Then V.AmountDue_18 else 0 end+      
Case When V.Installment>=19 and datediff(day, V.DueDate_19, @P_Date)>=(Case When RD.ID is null then R.Day_1 else RD.Day_1 end) Then V.AmountDue_19 else 0 end+      
Case When V.Installment>=20 and datediff(day, V.DueDate_20, @P_Date)>=(Case When RD.ID is null then R.Day_1 else RD.Day_1 end) Then V.AmountDue_20 else 0 end+      
Case When V.Installment>=21 and datediff(day, V.DueDate_21, @P_Date)>=(Case When RD.ID is null then R.Day_1 else RD.Day_1 end) Then V.AmountDue_21 else 0 end+      
Case When V.Installment>=22 and datediff(day, V.DueDate_22, @P_Date)>=(Case When RD.ID is null then R.Day_1 else RD.Day_1 end) Then V.AmountDue_22 else 0 end+      
Case When V.Installment>=23 and datediff(day, V.DueDate_23, @P_Date)>=(Case When RD.ID is null then R.Day_1 else RD.Day_1 end) Then V.AmountDue_23 else 0 end+      
Case When V.Installment>=24 and datediff(day, V.DueDate_24, @P_Date)>=(Case When RD.ID is null then R.Day_1 else RD.Day_1 end) Then V.AmountDue_24 else 0 end
) as AmountDue,  
    
V.Nominal_CC-V.Diff_CC-
      
(Case When V.Installment=0 and datediff(day, V.DueDate, @P_Date)>=(Case When RD.ID is null then R.Day_1 else RD.Day_1 end) Then V.Nominal_CC-V.Diff_CC else 0 end+      
Case When V.Installment>=1 and datediff(day, V.DueDate_1, @P_Date)>=(Case When RD.ID is null then R.Day_1 else RD.Day_1 end) Then V.AmountDue_1 else 0 end+      
Case When V.Installment>=2 and datediff(day, V.DueDate_2, @P_Date)>=(Case When RD.ID is null then R.Day_1 else RD.Day_1 end) Then V.AmountDue_2 else 0 end+      
Case When V.Installment>=3 and datediff(day, V.DueDate_3, @P_Date)>=(Case When RD.ID is null then R.Day_1 else RD.Day_1 end) Then V.AmountDue_3 else 0 end+      
Case When V.Installment>=4 and datediff(day, V.DueDate_4, @P_Date)>=(Case When RD.ID is null then R.Day_1 else RD.Day_1 end) Then V.AmountDue_4 else 0 end+      
Case When V.Installment>=5 and datediff(day, V.DueDate_5, @P_Date)>=(Case When RD.ID is null then R.Day_1 else RD.Day_1 end) Then V.AmountDue_5 else 0 end+      
Case When V.Installment>=6 and datediff(day, V.DueDate_6, @P_Date)>=(Case When RD.ID is null then R.Day_1 else RD.Day_1 end) Then V.AmountDue_6 else 0 end+      
Case When V.Installment>=7 and datediff(day, V.DueDate_7, @P_Date)>=(Case When RD.ID is null then R.Day_1 else RD.Day_1 end) Then V.AmountDue_7 else 0 end+      
Case When V.Installment>=8 and datediff(day, V.DueDate_8, @P_Date)>=(Case When RD.ID is null then R.Day_1 else RD.Day_1 end) Then V.AmountDue_8 else 0 end+      
Case When V.Installment>=9 and datediff(day, V.DueDate_9, @P_Date)>=(Case When RD.ID is null then R.Day_1 else RD.Day_1 end) Then V.AmountDue_9 else 0 end+      
Case When V.Installment>=10 and datediff(day, V.DueDate_10, @P_Date)>=(Case When RD.ID is null then R.Day_1 else RD.Day_1 end) Then V.AmountDue_10 else 0 end+      
Case When V.Installment>=11 and datediff(day, V.DueDate_11, @P_Date)>=(Case When RD.ID is null then R.Day_1 else RD.Day_1 end) Then V.AmountDue_11 else 0 end+      
Case When V.Installment>=12 and datediff(day, V.DueDate_12, @P_Date)>=(Case When RD.ID is null then R.Day_1 else RD.Day_1 end) Then V.AmountDue_12 else 0 end+
Case When V.Installment>=13 and datediff(day, V.DueDate_13, @P_Date)>=(Case When RD.ID is null then R.Day_1 else RD.Day_1 end) Then V.AmountDue_13 else 0 end+      
Case When V.Installment>=14 and datediff(day, V.DueDate_14, @P_Date)>=(Case When RD.ID is null then R.Day_1 else RD.Day_1 end) Then V.AmountDue_14 else 0 end+      
Case When V.Installment>=15 and datediff(day, V.DueDate_15, @P_Date)>=(Case When RD.ID is null then R.Day_1 else RD.Day_1 end) Then V.AmountDue_15 else 0 end+      
Case When V.Installment>=16 and datediff(day, V.DueDate_16, @P_Date)>=(Case When RD.ID is null then R.Day_1 else RD.Day_1 end) Then V.AmountDue_16 else 0 end+      
Case When V.Installment>=17 and datediff(day, V.DueDate_17, @P_Date)>=(Case When RD.ID is null then R.Day_1 else RD.Day_1 end) Then V.AmountDue_17 else 0 end+      
Case When V.Installment>=18 and datediff(day, V.DueDate_18, @P_Date)>=(Case When RD.ID is null then R.Day_1 else RD.Day_1 end) Then V.AmountDue_18 else 0 end+      
Case When V.Installment>=19 and datediff(day, V.DueDate_19, @P_Date)>=(Case When RD.ID is null then R.Day_1 else RD.Day_1 end) Then V.AmountDue_19 else 0 end+      
Case When V.Installment>=20 and datediff(day, V.DueDate_20, @P_Date)>=(Case When RD.ID is null then R.Day_1 else RD.Day_1 end) Then V.AmountDue_20 else 0 end+      
Case When V.Installment>=21 and datediff(day, V.DueDate_21, @P_Date)>=(Case When RD.ID is null then R.Day_1 else RD.Day_1 end) Then V.AmountDue_21 else 0 end+      
Case When V.Installment>=22 and datediff(day, V.DueDate_22, @P_Date)>=(Case When RD.ID is null then R.Day_1 else RD.Day_1 end) Then V.AmountDue_22 else 0 end+      
Case When V.Installment>=23 and datediff(day, V.DueDate_23, @P_Date)>=(Case When RD.ID is null then R.Day_1 else RD.Day_1 end) Then V.AmountDue_23 else 0 end+      
Case When V.Installment>=24 and datediff(day, V.DueDate_24, @P_Date)>=(Case When RD.ID is null then R.Day_1 else RD.Day_1 end) Then V.AmountDue_24 else 0 end
) as AmountUnDue,     
            
Case When V.Installment=0 then V.DueDate   
When V.Payment_CC<V.AmountDue_1 then V.DueDate_1   
When V.Payment_CC<V.AmountDue_1+V.AmountDue_2 then V.DueDate_2   
When V.Payment_CC<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3 then V.DueDate_3   
When V.Payment_CC<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4 then V.DueDate_4   
When V.Payment_CC<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5 then V.DueDate_5   
When V.Payment_CC<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6 then V.DueDate_6   
When V.Payment_CC<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7 then V.DueDate_7   
When V.Payment_CC<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8 then V.DueDate_8   
When V.Payment_CC<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9 then V.DueDate_9   
When V.Payment_CC<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10 then V.DueDate_10   
When V.Payment_CC<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11 then V.DueDate_11   
When V.Payment_CC<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12 then V.DueDate_12   
When V.Payment_CC<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13 then V.DueDate_13   
When V.Payment_CC<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14 then V.DueDate_14   
When V.Payment_CC<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15 then V.DueDate_15   
When V.Payment_CC<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16 then V.DueDate_16   
When V.Payment_CC<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16+V.AmountDue_17 then V.DueDate_17   
When V.Payment_CC<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16+V.AmountDue_17+V.AmountDue_18 then V.DueDate_18   
When V.Payment_CC<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16+V.AmountDue_17+V.AmountDue_18+V.AmountDue_19 then V.DueDate_19   
When V.Payment_CC<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16+V.AmountDue_17+V.AmountDue_18+V.AmountDue_19+V.AmountDue_20 then V.DueDate_20   
When V.Payment_CC<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16+V.AmountDue_17+V.AmountDue_18+V.AmountDue_19+V.AmountDue_20+V.AmountDue_21 then V.DueDate_21   
When V.Payment_CC<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16+V.AmountDue_17+V.AmountDue_18+V.AmountDue_19+V.AmountDue_20+V.AmountDue_21+V.AmountDue_22 then V.DueDate_22   
When V.Payment_CC<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16+V.AmountDue_17+V.AmountDue_18+V.AmountDue_19+V.AmountDue_20+V.AmountDue_21+V.AmountDue_22+V.AmountDue_23 then V.DueDate_23   
Else V.DueDate_24   
end as DueDate,   
(Case When V.Installment<>0 then ' Installment No. ' else '' end+   
Case When V.Installment>=1 and datediff(day, V.DueDate_1, @P_Date)>=(Case When RD.ID is null then R.Day_1 else RD.Day_1 end) and V.Payment_CC<V.AmountDue_1 Then '1 ' else '' end+   
Case When V.Installment>=2 and datediff(day, V.DueDate_2, @P_Date)>=(Case When RD.ID is null then R.Day_1 else RD.Day_1 end) and V.Payment_CC<V.AmountDue_1+V.AmountDue_2 Then '2 ' else '' end+   
Case When V.Installment>=3 and datediff(day, V.DueDate_3, @P_Date)>=(Case When RD.ID is null then R.Day_1 else RD.Day_1 end) and V.Payment_CC<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3 Then '3 ' else '' end+   
Case When V.Installment>=4 and datediff(day, V.DueDate_4, @P_Date)>=(Case When RD.ID is null then R.Day_1 else RD.Day_1 end) and V.Payment_CC<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4 Then '4 ' else '' end+   
Case When V.Installment>=5 and datediff(day, V.DueDate_5, @P_Date)>=(Case When RD.ID is null then R.Day_1 else RD.Day_1 end) and V.Payment_CC<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5 Then '5 ' else '' end+   
Case When V.Installment>=6 and datediff(day, V.DueDate_6, @P_Date)>=(Case When RD.ID is null then R.Day_1 else RD.Day_1 end) and V.Payment_CC<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6 Then '6 ' else '' end+   
Case When V.Installment>=7 and datediff(day, V.DueDate_7, @P_Date)>=(Case When RD.ID is null then R.Day_1 else RD.Day_1 end) and V.Payment_CC<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7 Then '7 ' else '' end+   
Case When V.Installment>=8 and datediff(day, V.DueDate_8, @P_Date)>=(Case When RD.ID is null then R.Day_1 else RD.Day_1 end) and V.Payment_CC<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8 Then '8 ' else '' end+   
Case When V.Installment>=9 and datediff(day, V.DueDate_9, @P_Date)>=(Case When RD.ID is null then R.Day_1 else RD.Day_1 end) and V.Payment_CC<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9 Then '9 ' else '' end+   
Case When V.Installment>=10 and datediff(day, V.DueDate_10, @P_Date)>=(Case When RD.ID is null then R.Day_1 else RD.Day_1 end) and V.Payment_CC<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10  Then '10 ' else '' end+   
Case When V.Installment>=11 and datediff(day, V.DueDate_11, @P_Date)>=(Case When RD.ID is null then R.Day_1 else RD.Day_1 end) and V.Payment_CC<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11 Then '11 ' else '' end+   
Case When V.Installment>=12 and datediff(day, V.DueDate_12, @P_Date)>=(Case When RD.ID is null then R.Day_1 else RD.Day_1 end) and V.Payment_CC<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12 Then '12 ' else '' end+   
Case When V.Installment>=13 and datediff(day, V.DueDate_13, @P_Date)>=(Case When RD.ID is null then R.Day_1 else RD.Day_1 end) and V.Payment_CC<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13 Then '13 ' else '' end+   
Case When V.Installment>=14 and datediff(day, V.DueDate_14, @P_Date)>=(Case When RD.ID is null then R.Day_1 else RD.Day_1 end) and V.Payment_CC<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14 Then '14 ' else '' end+   
Case When V.Installment>=15 and datediff(day, V.DueDate_15, @P_Date)>=(Case When RD.ID is null then R.Day_1 else RD.Day_1 end) and V.Payment_CC<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15 Then '15 ' else '' end+   
Case When V.Installment>=16 and datediff(day, V.DueDate_16, @P_Date)>=(Case When RD.ID is null then R.Day_1 else RD.Day_1 end) and V.Payment_CC<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16 Then '16 ' else '' end+   
Case When V.Installment>=17 and datediff(day, V.DueDate_17, @P_Date)>=(Case When RD.ID is null then R.Day_1 else RD.Day_1 end) and V.Payment_CC<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16+V.AmountDue_17 Then '17 ' else '' end+   
Case When V.Installment>=18 and datediff(day, V.DueDate_18, @P_Date)>=(Case When RD.ID is null then R.Day_1 else RD.Day_1 end) and V.Payment_CC<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16+V.AmountDue_17+V.AmountDue_18 Then '18 ' else '' end+   
Case When V.Installment>=19 and datediff(day, V.DueDate_19, @P_Date)>=(Case When RD.ID is null then R.Day_1 else RD.Day_1 end) and V.Payment_CC<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16+V.AmountDue_17+V.AmountDue_18+V.AmountDue_19 Then '19 ' else '' end+   
Case When V.Installment>=20 and datediff(day, V.DueDate_20, @P_Date)>=(Case When RD.ID is null then R.Day_1 else RD.Day_1 end) and V.Payment_CC<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16+V.AmountDue_17+V.AmountDue_18+V.AmountDue_19+V.AmountDue_20 Then '20 ' else '' end+   
Case When V.Installment>=21 and datediff(day, V.DueDate_21, @P_Date)>=(Case When RD.ID is null then R.Day_1 else RD.Day_1 end) and V.Payment_CC<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16+V.AmountDue_17+V.AmountDue_18+V.AmountDue_19+V.AmountDue_20+V.AmountDue_21 Then '21 ' else '' end+   
Case When V.Installment>=22 and datediff(day, V.DueDate_22, @P_Date)>=(Case When RD.ID is null then R.Day_1 else RD.Day_1 end) and V.Payment_CC<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16+V.AmountDue_17+V.AmountDue_18+V.AmountDue_19+V.AmountDue_20+V.AmountDue_21+V.AmountDue_22 Then '22 ' else '' end+   
Case When V.Installment>=23 and datediff(day, V.DueDate_23, @P_Date)>=(Case When RD.ID is null then R.Day_1 else RD.Day_1 end) and V.Payment_CC<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16+V.AmountDue_17+V.AmountDue_18+V.AmountDue_19+V.AmountDue_20+V.AmountDue_21+V.AmountDue_22+V.AmountDue_23 Then '23 ' else '' end+   
Case When V.Installment>=24 and datediff(day, V.DueDate_24, @P_Date)>=(Case When RD.ID is null then R.Day_1 else RD.Day_1 end) and V.Payment_CC<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16+V.AmountDue_17+V.AmountDue_18+V.AmountDue_19+V.AmountDue_20+V.AmountDue_21+V.AmountDue_22+V.AmountDue_23+V.AmountDue_24 Then '24 ' else '' end+   
Case When V.Installment<>0 then 'of '+cast(V.Installment as varchar(255)) else '' end) as sInstallment   
   
from nVoucher V 
inner join Admlink A On (A.Voucher=V.Voucher) 
inner join Reminder R on (R.Reminder=@P_Reminder) 
Left Join ReminderD RD on (R.Reminder=RD.Reminder and RD.ID=A.Source and RD.ISType=A.ISType)      
Where V.Date<=@P_Date  
and ((V.Nominal_CC-V.Diff_CC-V.Payment_CC-V.Payment_OC)<>0 or V.PDate>=@P_Date)      
and datediff(day,
Case When V.Installment=0 then V.DueDate   
When V.Payment_CC<V.AmountDue_1 then V.DueDate_1   
When V.Payment_CC<V.AmountDue_1+V.AmountDue_2 then V.DueDate_2   
When V.Payment_CC<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3 then V.DueDate_3   
When V.Payment_CC<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4 then V.DueDate_4   
When V.Payment_CC<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5 then V.DueDate_5   
When V.Payment_CC<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6 then V.DueDate_6   
When V.Payment_CC<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7 then V.DueDate_7   
When V.Payment_CC<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8 then V.DueDate_8   
When V.Payment_CC<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9 then V.DueDate_9   
When V.Payment_CC<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10 then V.DueDate_10   
When V.Payment_CC<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11 then V.DueDate_11   
When V.Payment_CC<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12 then V.DueDate_12   
When V.Payment_CC<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13 then V.DueDate_13   
When V.Payment_CC<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14 then V.DueDate_14   
When V.Payment_CC<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15 then V.DueDate_15   
When V.Payment_CC<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16 then V.DueDate_16   
When V.Payment_CC<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16+V.AmountDue_17 then V.DueDate_17   
When V.Payment_CC<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16+V.AmountDue_17+V.AmountDue_18 then V.DueDate_18   
When V.Payment_CC<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16+V.AmountDue_17+V.AmountDue_18+V.AmountDue_19 then V.DueDate_19   
When V.Payment_CC<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16+V.AmountDue_17+V.AmountDue_18+V.AmountDue_19+V.AmountDue_20 then V.DueDate_20   
When V.Payment_CC<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16+V.AmountDue_17+V.AmountDue_18+V.AmountDue_19+V.AmountDue_20+V.AmountDue_21 then V.DueDate_21   
When V.Payment_CC<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16+V.AmountDue_17+V.AmountDue_18+V.AmountDue_19+V.AmountDue_20+V.AmountDue_21+V.AmountDue_22 then V.DueDate_22   
When V.Payment_CC<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16+V.AmountDue_17+V.AmountDue_18+V.AmountDue_19+V.AmountDue_20+V.AmountDue_21+V.AmountDue_22+V.AmountDue_23 then V.DueDate_23   Else V.DueDate_24   end, @P_Date) Between (Case When RD.ID is null then R.Day_1 else RD.Day_1 end) and (Case When RD.ID is null then R.Day_2 else RD.Day_2 end)      
)      


GO

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Get_Payment_Percentage]') AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) ) 
begin
DROP FUNCTION Get_Payment_Percentage 
end
GO
CREATE Function Get_Payment_Percentage(@P_A_PolicyNo varchar(50), @P_Date smalldatetime)
RETURNS Float AS        
  
BEGIN       
Declare @PCT as Float

Select 
@PCT=sum(case When V.DebtorF=1 Then (V.Payment_CC) Else -(V.Payment_CC) end)/sum(case When V.DebtorF=1 Then (V.Nominal_CC-V.Diff_CC) Else -(V.Nominal_CC-V.Diff_CC) end)*100
from nVoucher V 
Where Exists (Select Voucher from Admlink A Where V.Voucher=A.Voucher and A.Date<=@P_Date and A.A_PolicyNo=@P_A_PolicyNo and A.SUbject='Premium' and V.DebtorF=1 and A.Type in ('DI','IC','IR'))
Having sum(case When V.DebtorF=1 Then (V.Nominal_CC-V.Diff_CC) Else -(V.Nominal_CC-V.Diff_CC) end)<>0

if @PCT IS NULL 
	SELECT @PCT=100

Return @PCT
End

GO

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[fn_Voucher_AmountWPCDue]') AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) ) 
begin
DROP FUNCTION fn_Voucher_AmountWPCDue 
end
GO
Create FUNCTION fn_Voucher_AmountWPCDue (@P_Voucher as varchar(20), @P_Date as smalldatetime)    
RETURNS Float    
AS     
BEGIN    
Declare @AmountDue as Float  
Select  
Top 1 
@AmountDue=  
(Case When V.Installment=0 and dateadd(day,A.WPC,V.DueDate) <=@P_Date Then V.Nominal_CC-V.Diff_CC else 0 end+    
Case When V.Installment>=1 and V.DueDate_1 <=@P_Date Then V.AmountDue_1 else 0 end+    
Case When V.Installment>=2 and V.DueDate_2 <=@P_Date Then V.AmountDue_2 else 0 end+    
Case When V.Installment>=3 and V.DueDate_3 <=@P_Date Then V.AmountDue_3 else 0 end+    
Case When V.Installment>=4 and V.DueDate_4 <=@P_Date Then V.AmountDue_4 else 0 end+    
Case When V.Installment>=5 and V.DueDate_5 <=@P_Date Then V.AmountDue_5 else 0 end+    
Case When V.Installment>=6 and V.DueDate_6 <=@P_Date Then V.AmountDue_6 else 0 end+    
Case When V.Installment>=7 and V.DueDate_7 <=@P_Date Then V.AmountDue_7 else 0 end+    
Case When V.Installment>=8 and V.DueDate_8 <=@P_Date Then V.AmountDue_8 else 0 end+    
Case When V.Installment>=9 and V.DueDate_9 <=@P_Date Then V.AmountDue_9 else 0 end+    
Case When V.Installment>=10 and V.DueDate_10 <=@P_Date Then V.AmountDue_10 else 0 end+    
Case When V.Installment>=11 and V.DueDate_11 <=@P_Date Then V.AmountDue_11 else 0 end+    
Case When V.Installment>=12 and V.DueDate_12 <=@P_Date Then V.AmountDue_12 else 0 end+  
Case When V.Installment>=13 and V.DueDate_13 <=@P_Date Then V.AmountDue_13 else 0 end+    
Case When V.Installment>=14 and V.DueDate_14 <=@P_Date Then V.AmountDue_14 else 0 end+    
Case When V.Installment>=15 and V.DueDate_15 <=@P_Date Then V.AmountDue_15 else 0 end+    
Case When V.Installment>=16 and V.DueDate_16 <=@P_Date Then V.AmountDue_16 else 0 end+    
Case When V.Installment>=17 and V.DueDate_17 <=@P_Date Then V.AmountDue_17 else 0 end+    
Case When V.Installment>=18 and V.DueDate_18 <=@P_Date Then V.AmountDue_18 else 0 end+    
Case When V.Installment>=19 and V.DueDate_19 <=@P_Date Then V.AmountDue_19 else 0 end+    
Case When V.Installment>=20 and V.DueDate_20 <=@P_Date Then V.AmountDue_20 else 0 end+    
Case When V.Installment>=21 and V.DueDate_21 <=@P_Date Then V.AmountDue_21 else 0 end+    
Case When V.Installment>=22 and V.DueDate_22 <=@P_Date Then V.AmountDue_22 else 0 end+    
Case When V.Installment>=23 and V.DueDate_23 <=@P_Date Then V.AmountDue_23 else 0 end+    
Case When V.Installment>=24 and V.DueDate_24 <=@P_Date Then V.AmountDue_24 else 0 end)
from nVoucher V, Admlink A where A.Voucher=V.Voucher and V.Voucher=@P_Voucher  
return(@AmountDue)  
END    

GO

IF EXISTS ( SELECT * FROM   sysobjects WHERE  id = object_id(N'[dbo].[PI08]') and OBJECTPROPERTY(id, N'IsProcedure') = 1 )
begin
DROP Procedure PI08
end
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
   
Select Distinct Voucher.Voucher, Voucher.DueDate, Voucher.DocNo, Voucher_Due.DueDate as NDueDate, Profile.Name, Voucher.Currency,   
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

IF EXISTS ( SELECT * FROM   sysobjects WHERE  id = object_id(N'[dbo].[PI09]') and OBJECTPROPERTY(id, N'IsProcedure') = 1 )
begin
DROP Procedure PI09
end
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
 
Select Distinct Voucher.Voucher, Voucher.DueDate, Voucher.DocNo, Profile.Name, Voucher.Currency, 
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

IF EXISTS ( SELECT * FROM   sysobjects WHERE  id = object_id(N'[dbo].[PI13]') and OBJECTPROPERTY(id, N'IsProcedure') = 1 )
begin
DROP Procedure PI13
end
GO
CREATE procedure PI13 (@P_ANO as integer) 
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
 
Select Distinct Admlink.Subject, Voucher.Voucher, Voucher.DueDate, Voucher.DocNo, Voucher_Due.DueDate as NDueDate, 
Profile.Name, Voucher.Currency, 
 
case when Voucher.debtorf=1 then Voucher.Nominal_CC-Voucher.Diff_CC else -(Voucher.Nominal_CC-Voucher.Diff_CC) end  as Nominal, 
case when Voucher.debtorf=1 then (coalesce(Voucher_Due.AmountDue, Voucher.AmountDue)-Voucher.Payment_CC) else -(coalesce(Voucher_Due.AmountDue, Voucher.AmountDue)-Voucher.Payment_CC) end as AmountDue, 
case when Voucher.debtorf=1 then Voucher.Payment_CC else -Voucher.Payment_CC end as Payment, 
case when Voucher.debtorf=1 then Voucher.Nominal_CC-Voucher.Diff_CC - Voucher.Payment_CC else -(Voucher.Nominal_CC-Voucher.Diff_CC - Voucher.Payment_CC) end as Outstanding 
 
from nVoucher Voucher Left Join Voucher_AmountDue(@P_Date) Voucher_Due on (Voucher_Due.Voucher=Voucher.Voucher), Profile, ProAcc, Admlink 
Where Profile.ID=ProAcc.ID and ProAcc.ProAcc=Voucher.ProAcc and Admlink.Voucher=Voucher.Voucher 
and Admlink.Type in ('DI','IC','IR','CF','JP','BB','BA','BO','OP','FO') and Admlink.A_PolicyNo=@P_A_PolicyNo and (Admlink.Extra_1='' or Admlink.Extra_1 is null) 
 
end 
 
GO

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[OS_VOUCHER_N]') AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) ) 
begin
DROP FUNCTION OS_VOUCHER_N 
end
GO

CREATE function OS_VOUCHER_N (@P_Voucher Varchar(20))        
RETURNS Table        
AS RETURN        
(        
SELECT DISTINCT VOUCHER.VOUCHER, VOUCHER.DATE, VOUCHER.CURRENCY, VOUCHER.PROACC, VOUCHER.DEBTORF,VOUCHER.CREDITORF,VOUCHER.SL_CAT,        
VOUCHER.BRANCH, VOUCHER.REFNO,VOUCHER.REFDATE,VOUCHER.DOCNO,VOUCHER.VTYPE, VOUCHER.REMARKS, VOUCHER.REFTYPE, VOUCHER.ACCOUNTNO, Admlink.A_RefNo,        
VOUCHER.NOMINAL_CC-VOUCHER.DIFF_CC AS NOMINAL,        
CASE WHEN VP.VOUCHER IS NULL THEN VOUCHER.PAYMENT_CC ELSE VOUCHER.NOMINAL_CC-VOUCHER.DIFF_CC-VP.NOMINAL END AS PAYMENT,        
CASE WHEN VP.VOUCHER IS NULL THEN VOUCHER.NOMINAL_CC-VOUCHER.DIFF_CC-VOUCHER.PAYMENT_CC ELSE VP.NOMINAL END AS OUTSTANDING,    
'' AS ACCOUNT,  
cast(0 as Smallint) as HINT    
FROM NVoucher VOUCHER 
Inner Join Admlink On (Admlink.Voucher=Voucher.Voucher)        
LEFT JOIN PAID_VOUCHER_N(@P_Voucher) VP ON(VOUCHER.VOUCHER=VP.VOUCHER)        
WHERE VOUCHER.STATUS<>'C' AND VOUCHER.REQUESTF=0 AND ROUND(CASE WHEN VP.VOUCHER IS NULL THEN VOUCHER.NOMINAL_CC-VOUCHER.DIFF_CC-VOUCHER.PAYMENT_CC ELSE VP.NOMINAL END,4)<>0        
)        

GO
IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[fn_RRateCon]') AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) ) 
begin
DROP FUNCTION fn_RRateCon 
end
GO

CREATE FUNCTION fn_RRateCon(@P_ANO as int,@P_RID as varchar(20),@P_TSI as Float=0)       
RETURNS Table       
AS RETURN (       
SELECT Top 1 RateCon.Code, 
Case When coalesce(RateCon.Loading,0)=0 Then 100 else RateCon.Loading end as Loading,       
--Rate Always in Percent       
Case       
When RateCon.Unit='F' then (Case When (Case When @P_TSI=0 Then 1 Else @P_TSI End)<>0 Then RateCon.Rate/(Case When @P_TSI=0 Then 1 Else @P_TSI End)*100 else 0 end)       
When RateCon.Unit='M' then RateCon.Rate/10       
else RateCon.Rate end as Rate
From Acceptance       
INNER JOIN AInfo on (AInfo.ANO=Acceptance.ANO)       
INNER JOIN COVER ON (COVER.CNO=ACCEPTANCE.CNO)       
INNER JOIN REINSURANCE on (REINSURANCE.RID=@P_RID)       
INNER JOIN RECLASS ON (RECLASS.RNO=REINSURANCE.RNO AND RECLASS.TOC=Acceptance.TOC)       
INNER JOIN RateTab ON (RateTab.Effective<=Acceptance.SDate and RateTab.Code=RECLASS.CODE)       
INNER JOIN RateCon on (    
	RateCon.Code=RateTab.Code And ((Case When @P_TSI=0 Then 1 Else @P_TSI End)>=RateCon.MinTSI or RateCon.MinTSI=0) and ((Case When @P_TSI=0 Then 1 Else @P_TSI End)<=RateCon.MaxTSI or RateCon.MaxTSI=0)     
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
)    


GO

IF EXISTS ( SELECT * FROM   sysobjects WHERE  id = object_id(N'[dbo].[QRFACDET]') and OBJECTPROPERTY(id, N'IsProcedure') = 1 )
begin
DROP Procedure QRFACDET
end
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
		MAX(FPart.NetRate)/MAX(PCALC.RiskNum) 
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

IF EXISTS ( SELECT * FROM   sysobjects WHERE  id = object_id(N'[dbo].[Facultative_Premium]') and OBJECTPROPERTY(id, N'IsProcedure') = 1 )
begin
DROP Procedure Facultative_Premium
end
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
		MAX(FPart.NetRate)/MAX(PCALC.RiskNum)
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

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PCALC_ANNUM]') AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) ) 
begin
DROP FUNCTION PCALC_ANNUM 
end
GO
CREATE FUNCTION PCALC_ANNUM(@P_ANO as int)      
RETURNS Table      
AS RETURN (      
Select ICALC.ANO, ICALC.CODE, ICALC.INO, ICALC.Currency, ICALC.SDATE, ICALC.EDATE, SUM(ICALC.GROSS) AS GROSS, MAX(PCALC.RATE) AS RATE, MAX(PCALC.GROSS) AS PGROSS, MAX(PCALC.OGROSS) AS POGROSS, 
Max(Case When Upper(PCALC.DESCRIPTION) in ('MINIMUM PREMIUM','POLICY  PREMIUM') Then 1 else 0 end) as MinimumPremiumF,
(Select Count(Distinct I.Code+'-'+cast(ICOVER.ADJUSTABLE as varchar(1))) as RiskNum from ICalc I, ICOVER Where ICOVER.INO=I.INO and I.Gross<>0 and I.ANO=ICalc.ANO and I.INO=ICalc.INO and I.Currency=ICalc.Currency and I.SDate=ICalc.SDate and I.EDate=ICalc.EDate) as RiskNum
FROM ICALC, PCALC
Where ICALC.ANO=@P_ANO and PCALC.ANO=ICALC.ANO and PCALC.CURRENCY=ICALC.CURRENCY 
Group By ICALC.ANO, ICALC.CODE, ICALC.INO, ICALC.Currency, ICALC.SDATE, ICALC.EDATE      
Having SUM(ICALC.Gross) <> 0      
)      

GO

IF EXISTS ( SELECT * FROM   sysobjects WHERE  id = object_id(N'[dbo].[QPolicy_Rate]') and OBJECTPROPERTY(id, N'IsProcedure') = 1 )
begin
DROP Procedure QPolicy_Rate
end
GO
CREATE Procedure QPolicy_Rate(@P_ANO as int)     
as     
Select ICALC.Code, ICALC.SDate, SUM(ICALC.TSI) as TSI, Max(ICALC.PrevMinRate) as PrevMinRate, Max(ICALC.PrevMaxRate) as PrevMaxRate, Max(ICALC.MinRate) as MinRate, Max(ICALC.MaxRate) as MaxRate     
from     
(     
Select ICALC.Code, ICALC.SDate,     
MAX((Case When ICover.Category='M' then ICALC.TSI else 0 end)*(CASE WHEN RCOVER.PCTLOSS=0 THEN 100 ELSE RCOVER.PCTLOSS END)/(CASE WHEN RCOVER.PCTLOSS=0 THEN 100 ELSE RCOVER.PCTLOSS END+RCOVER.PAddition)) as TSI,     
CAST(0 as FLOAT) as PREVMINRATE,     
CAST(0 as FLOAT) as PREVMAXRATE,     
SUM(ICALC.GROSS*100/(100-RCover.Discount)/ICALC.TSI/(Case When RCOVER.LOADING=0 THEN 1 ELSE RCOVER.LOADING END)*Case When ICalc.PCTADJ<>0 Then cast(100 as Float)/ICALC.PCTADJ else 1 end*Case When ICALC.Prorata=1 then (Case When Day(ICALC.SDate)<>Day(ICALC.EDate) then cast(Cover.Prorata as Float)/datediff(day,ICALC.SDate, ICALC.EDate) else cast(case When TOC.PTerm=0 Then 12 else TOC.PTerm end as Float)/datediff(Month, ICALC.SDate, ICALC.EDate) end) else (Case When RCover.PCalc='P' and Cover.Voyage=0 then Case When day(ICalc.SDate)<>day(ICalc.EDate) or Cover.PPeriod=1 then cast(Cover.Prorata as Float)/datediff(day,ICalc.SDate, ICalc.EDate) else cast(case When TOC.PTerm=0 Then 12 else TOC.PTerm end as Float)/datediff(month,ICalc.SDate, ICalc.EDate) end else 1/ICALC.Prorata end) end)*100+0.0000000001 as MINRATE,     
SUM(ICALC.GROSS*100/(100-RCover.Discount)/ICALC.TSI/(Case When RCOVER.LOADING=0 THEN 1 ELSE RCOVER.LOADING END)*Case When ICalc.PCTADJ<>0 Then cast(100 as Float)/ICALC.PCTADJ else 1 end*Case When ICALC.Prorata=1 then (Case When Day(ICALC.SDate)<>Day(ICALC.EDate) then cast(Cover.Prorata as Float)/datediff(day,ICALC.SDate, ICALC.EDate) else cast(case When TOC.PTerm=0 Then 12 else TOC.PTerm end as Float)/datediff(Month, ICALC.SDate, ICALC.EDate) end) else (Case When RCover.PCalc='P' and Cover.Voyage=0 then Case When day(ICalc.SDate)<>day(ICalc.EDate) or Cover.PPeriod=1 then cast(Cover.Prorata as Float)/datediff(day,ICalc.SDate, ICalc.EDate) else cast(case When TOC.PTerm=0 Then 12 else TOC.PTerm end as Float)/datediff(month,ICalc.SDate, ICalc.EDate) end else 1/ICALC.Prorata end) end)*100-0.0000000001 as MAXRATE     
from COVER, ACCEPTANCE, ICover, ICALC, RCover, TOC
Where ACCEPTANCE.ANO=@P_ANO and COVER.CNO=ACCEPTANCE.CNO and COVER.ISType in ('I','C','L') and RCover.ANO=Acceptance.ANO     
and RCover.ANO=ICALC.ANO and RCover.Code=ICALC.Code and RCover.SDate=ICALC.SDate and RCover.EDate=ICALC.EDate and datediff(month, ICALC.SDate, ICALC.EDate)<>0     
and ICover.INO=ICalc.INO and ICALC.TSI<>0     
and TOC.TOC=ACCEPTANCE.TOC
Group By ICalc.INO, ICALC.Code, ICALC.SDate     
     
Union All     
     
Select ICALC.Code, ICALC.SDate,     
0 as TSI,     
SUM(ICALC.GROSS*100/(100-RCover.Discount)/ICALC.TSI/(Case When RCOVER.LOADING=0 THEN 1 ELSE RCOVER.LOADING END)*Case When ICalc.PCTADJ<>0 Then cast(100 as Float)/ICALC.PCTADJ else 1 end*Case When ICALC.Prorata=1 then (Case When Day(ICALC.SDate)<>Day(ICALC.EDate) then cast(Cover.Prorata as Float)/datediff(day,ICALC.SDate, ICALC.EDate) else cast(case When TOC.PTerm=0 Then 12 else TOC.PTerm end as Float)/datediff(Month, ICALC.SDate, ICALC.EDate) end) else (Case When RCover.PCalc='P' and Cover.Voyage=0 then Case When day(ICalc.SDate)<>day(ICalc.EDate) or Cover.PPeriod=1 then cast(Cover.Prorata as Float)/datediff(day,ICalc.SDate, ICalc.EDate) else cast(case When TOC.PTerm=0 Then 12 else TOC.PTerm end as Float)/datediff(month,ICalc.SDate, ICalc.EDate) end else 1/ICALC.Prorata end) end)*100+0.0000000001 as PREVMINRATE,     
SUM(ICALC.GROSS*100/(100-RCover.Discount)/ICALC.TSI/(Case When RCOVER.LOADING=0 THEN 1 ELSE RCOVER.LOADING END)*Case When ICalc.PCTADJ<>0 Then cast(100 as Float)/ICALC.PCTADJ else 1 end*Case When ICALC.Prorata=1 then (Case When Day(ICALC.SDate)<>Day(ICALC.EDate) then cast(Cover.Prorata as Float)/datediff(day,ICALC.SDate, ICALC.EDate) else cast(case When TOC.PTerm=0 Then 12 else TOC.PTerm end as Float)/datediff(Month, ICALC.SDate, ICALC.EDate) end) else (Case When RCover.PCalc='P' and Cover.Voyage=0 then Case When day(ICalc.SDate)<>day(ICalc.EDate) or Cover.PPeriod=1 then cast(Cover.Prorata as Float)/datediff(day,ICalc.SDate, ICalc.EDate) else cast(case When TOC.PTerm=0 Then 12 else TOC.PTerm end as Float)/datediff(month,ICalc.SDate, ICalc.EDate) end else 1/ICALC.Prorata end) end)*100-0.0000000001 as PREVMAXRATE,     
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

IF EXISTS ( SELECT * FROM   sysobjects WHERE  id = object_id(N'[dbo].[qPolicyData]') and OBJECTPROPERTY(id, N'IsProcedure') = 1 )
begin
DROP Procedure qPolicyData
end
GO
Create procedure qPolicyData(@P_SQLFilter as varchar(2048))          
as  
  
Declare @SQL as varchar(8000)  
  
Select @P_SQLFILTER=replace(@P_SQLFILTER,'``','''')
  
Select @SQL=''      
Select @SQL = @SQL + ' Select *'  
Select @SQL = @SQL + ' from '  
Select @SQL = @SQL + ' ('  
Select @SQL = @SQL + '  SELECT ACCEPTANCE.ANO, COVER.TOC AS TOC, COVER.INSURED AS Insured, ACCEPTANCE.AName AS AName, COVER.COVERNO, ACCEPTANCE.REGNO, ACCEPTANCE.POLICYNO AS PolicyNo, ACCEPTANCE.CERTIFICATENO AS CertificateNo, ACCEPTANCE.REFNO, Acceptance.PDate, Acceptance.PPDate,       '  
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
Select @SQL = @SQL + '  FROM COVER INNER JOIN  ACCEPTANCE ON COVER.CNO = ACCEPTANCE.CNO INNER JOIN  AINFO ON ACCEPTANCE.ANO = AINFO.ANO '  
Select @SQL = @SQL + '  INNER JOIN PROFILE ON (PROFILE.ID=ACCEPTANCE.AID) LEFT JOIN PROFILE_EXT ON (PROFILE_EXT.ID=PROFILE.ID) '
Select @SQL = @SQL + '  WHERE (ACCEPTANCE.ANO <> ACCEPTANCE.LANO) AND (ACCEPTANCE.ATYPE NOT IN (''C'', ''A'')) AND (ACCEPTANCE.ASTATUS NOT IN (''W'',''T'')) AND NOT (COVER.CSTATUS=''C'' AND ACCEPTANCE.ASTATUS=''C'') AND datediff(day, ACCEPTANCE.PDATE,ACCEPTANCE.PPDATE)>0 AND ACCEPTANCE.POLICYNO<>''''                '  
Select @SQL = @SQL + ' ) Q'  
if @P_SQLFilter<>''  
 Select @SQL = @SQL + ' Where ' + @P_SQLFilter  

Execute (@SQL)  

GO


IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[FN_QTOPRateCode]') AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) ) 
begin
DROP FUNCTION FN_QTOPRateCode 
end
GO
CREATE FUNCTION FN_QTOPRateCode (@p_code varchar (10), @p_TOPRO varchar(10))
RETURNS TABLE  
AS RETURN (  
	SELECT RateTab.Code, Max(RateTab.Description) as Description, Max(RateTab.Unit) as Unit, cast(Max(cast(RateTab.NoRefundF as Int)) as bit) as NoRefundF, max(RClass.Category) as Category, sum(RateTab.Rate*RateCov.Portion/100) AS Rate, sum(RateCov.Portion) AS Portion, Max(RateTab.Description) as Remark  
	From RateTab, RateCov, Rclass, TOPRO  
	Where RateTab.Code Like @P_Code and RateTab.Code=RateCov.Code and Rclass.TOR=RateCov.TOR 
	and TOPRO.TOPRO=@P_TOPRO and TOPRO.TOC=Substring(RClass.TOC, 1, len(TOPRO.TOC))
	Group By RateTab.Code, RClass.TOC
	Having sum(RateCov.Portion)=100
 )

GO

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[CL_U_COLLECT]') AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) ) 
begin
DROP FUNCTION CL_U_COLLECT 
end
GO
CREATE function CL_U_COLLECT(@P_PDate smalldatetime, @P_Voucher as varchar(20), @P_PolicyNo as varchar(50), @P_RefNo as varchar(50)) 
RETURNS TABLE 
AS RETURN 
( 
select Voucher.RefNo,Voucher.Voucher, Admlink.Type, Admlink.Date, Admlink.Subject, Voucher.DocNo, Voucher.StatID, Voucher.ActionBy, Voucher.ActionDate, Voucher.AcceptedBy, Voucher.AcceptedDate, Voucher.[Currency], Voucher.Installment, Voucher.DueDate as DueDate, Voucher.AmountDue-Voucher.Payment_CC-Voucher.Payment_OC as Nominal, AdmLink.Remarks+Voucher.sInstallment as AName, Profile.Name, Voucher.debtorF,Voucher.CreditorF,AdmLink.BatchNo, Admlink.RefType, Admlink.A_PolicyNo, Voucher.Branch, Admlink.Code, 
Admlink.AccountNo, Admlink.Extra_4 
from ProAcc,[Profile],Voucher_AmountWPCDue(@P_PDate) Voucher,AdmLink 
where Voucher.Voucher=AdmLink.Voucher 
and ProAcc.ProAcc=Voucher.ProAcc 
and ProAcc.[ID]=[Profile].[ID] 
and Admlink.Type in ('BB','BO','BA','DI','IC','CF','JP','SO') 
and Admlink.ISType in ('I','L','C') 
and Admlink.Subject='Premium' 
and Admlink.Voucher Like @P_Voucher 
and Admlink.A_PolicyNo Like @P_PolicyNo 
and Admlink.RefNo Like @P_RefNo 
and Not Exists (Select CollectionV.Voucher from CollectionV, CollectionH Where CollectionH.CollNo=CollectionV.COllNo and CollectionH.CollStatus<>'C' and CollectionV.CollNo<>Voucher.CollNo and CollectionV.Voucher=Voucher.Voucher) 
) 


GO

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[DB_U_F_DISBURSE]') AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) ) 
begin
DROP FUNCTION DB_U_F_DISBURSE 
end
GO
CREATE FUNCTION DB_U_F_DISBURSE(@P_PDate smalldatetime, @P_Voucher as varchar(20), @P_PolicyNo as varchar(50), @P_RefNo as varchar(50), @P_DocNo as varchar(50)) 
RETURNS TABLE    
AS RETURN    
(    
select distinct  Admlink.RefNo as RefNo, Voucher.Voucher,Admlink.Type, Admlink.Date, Admlink.Subject, Voucher.DocNo, Voucher.StatID, Voucher.ActionBy, Voucher.ActionDate, Voucher.AcceptedBy, Voucher.AcceptedDate,     
Voucher.[Currency],  Voucher.Installment, Voucher.DueDate as DueDate, Voucher.AmountDue-Voucher.Payment_CC-Voucher.Payment_OC as Nominal,    
Profile.Name+'-'+AdmLink.Remarks as AName, Profile.Name, Voucher.debtorF,Voucher.CreditorF,AdmLink.BatchNo, Admlink.RefType,Voucher.Branch, Admlink.Code, Admlink.A_PolicyNo, Admlink.EXTRA_4  
from ProAcc,[Profile],Voucher_AmountWPCDue(@P_PDate) Voucher,AdmLink 
where  Voucher.Voucher=AdmLink.Voucher     
and ProAcc.ProAcc=Voucher.ProAcc     
and ProAcc.[ID]=[Profile].[ID]     
and Admlink.Type in ('DI','IC','SO','OP')    
and Not ((Admlink.Type in ('OP') and Admlink.Amount_8<>0) or (Admlink.Type in ('DI','SO') and Admlink.Amount_7+Admlink.Amount_12=Admlink.Amount)) -- Not Claim Salvage/Excess      
and Upper(AdmLink.Subject)='CLAIM'  
and Admlink.Date<=@P_PDate
and Admlink.Voucher Like @P_Voucher 
and Admlink.A_PolicyNo Like @P_PolicyNo 
and Admlink.RefNo Like @P_RefNo 
and Admlink.DocNo Like @P_DocNo
and Not Exists (Select CollectionV.Voucher from CollectionV, CollectionH Where CollectionH.CollNo=CollectionV.COllNo and CollectionH.CollStatus<>'C' and CollectionV.Voucher=Voucher.Voucher) 
)    
  

GO

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[DB_U_I_DISBURSE]') AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) ) 
begin
DROP FUNCTION DB_U_I_DISBURSE 
end
GO
CREATE FUNCTION DB_U_I_DISBURSE(@P_PDate smalldatetime, @P_Voucher as varchar(20), @P_PolicyNo as varchar(50), @P_RefNo as varchar(50), @P_DocNo as varchar(50)) 
RETURNS TABLE    
AS RETURN    
(    
select distinct  Admlink.RefNo as RefNo, Voucher.Voucher,Admlink.Type, Admlink.Date, Admlink.Subject, Voucher.DocNo, Voucher.StatID, Voucher.ActionBy, Voucher.ActionDate, Voucher.AcceptedBy, Voucher.AcceptedDate,     
Voucher.[Currency],  Voucher.Installment, Voucher.DueDate as DueDate, Voucher.AmountDue-Voucher.Payment_CC-Voucher.Payment_OC as Nominal,    
Profile.Name+'-'+AdmLink.Remarks as AName, Profile.Name, Voucher.debtorF,Voucher.CreditorF,AdmLink.BatchNo, Admlink.RefType,Voucher.Branch, Admlink.Code, Admlink.A_PolicyNo, Admlink.EXTRA_4  
from ProAcc,[Profile],Voucher_AmountWPCDue(@P_PDate) Voucher,AdmLink  
where  Voucher.Voucher=AdmLink.Voucher     
and ProAcc.ProAcc=Voucher.ProAcc     
and ProAcc.[ID]=[Profile].[ID]     
and Admlink.Type in ('DI','IC','SO','OP')    
and Not ((Admlink.Type in ('OP') and Admlink.Amount_8<>0) or (Admlink.Type in ('DI','SO') and Admlink.Amount_7+Admlink.Amount_12=Admlink.Amount)) -- Not Claim Salvage/Excess      
and Upper(AdmLink.Subject)='CLAIM'  
and Admlink.Voucher Like @P_Voucher 
and Admlink.A_PolicyNo Like @P_PolicyNo 
and Admlink.RefNo Like @P_RefNo 
and Admlink.DocNo Like @P_DocNo
and Not Exists (Select CollectionV.Voucher from CollectionV, CollectionH Where CollectionH.CollNo=CollectionV.COllNo and CollectionH.CollStatus<>'C' and CollectionV.Voucher=Voucher.Voucher) 
) 


GO

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[DB_U_R_DISBURSE]') AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) ) 
begin
DROP FUNCTION DB_U_R_DISBURSE 
end
GO

CREATE FUNCTION DB_U_R_DISBURSE(@P_PDate smalldatetime, @P_Voucher as varchar(20), @P_PolicyNo as varchar(50), @P_RefNo as varchar(50), @P_DocNo as varchar(50)) 
RETURNS TABLE  
AS RETURN  
(  
select distinct  Voucher.RefNo, Voucher.Voucher,Admlink.Type, Admlink.Date, Admlink.Subject, Admlink.Extra_3,Voucher.DocNo, Voucher.StatID, Voucher.ActionBy, Voucher.ActionDate, Voucher.AcceptedBy, Voucher.AcceptedDate,   
Voucher.[Currency],  Voucher.Installment, Voucher.DueDate as DueDate, Voucher.AmountDue-Voucher.Payment_CC-Voucher.Payment_OC as Nominal,  
Case When Reinsurance.DocNo is null Then Admlink.Remarks else Reinsurance.Description end +Voucher.sInstallment as AName, Profile.Name, Voucher.debtorF,Voucher.CreditorF,AdmLink.BatchNo, Admlink.RefType,Voucher.Branch, Admlink.Code, Admlink.A_PolicyNo, Admlink.EXTRA_4
from ProAcc,[Profile],Voucher_AmountWPCDue(@P_PDate) Voucher,AdmLink Left Join Reinsurance On (Reinsurance.DocNo=Admlink.RefNo)
where  Voucher.Voucher=AdmLink.Voucher   
and ProAcc.ProAcc=Voucher.ProAcc   
and ProAcc.[ID]=[Profile].[ID]   
and Admlink.Type in ('PI','FO','QS','QP','S1','S2','S3','CP','XP','AF','DC','X1','X2','X3','X4','X5','X6','X7','X8','X9','XX','RP','AP','IR','IT','IX')  
and Admlink.Voucher Like @P_Voucher 
and Admlink.A_PolicyNo Like @P_PolicyNo 
and Admlink.RefNo Like @P_RefNo 
and Admlink.DocNo Like @P_DocNo
and Not Exists (Select CollectionV.Voucher from CollectionV, CollectionH Where CollectionH.CollNo=CollectionV.COllNo and CollectionH.CollStatus<>'C' and CollectionV.Voucher=Voucher.Voucher) 
)  

GO

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[DISPLAY_FACULTATIVE_BALANCE_PRORATA_CALCULATION]') AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) ) 
begin
DROP FUNCTION DISPLAY_FACULTATIVE_BALANCE_PRORATA_CALCULATION 
end
GO
CREATE FUNCTION DISPLAY_FACULTATIVE_BALANCE_PRORATA_CALCULATION(@P_ANO int, @P_FID Varchar(20))          
-- From Display_Prorata Calculation   
-- RCalc.Sdate Replaced with RArrDet.SDate  
-- Rcalc.EDate Replaced with RArrDet.EDate  
-- Acceptance.AType Replaced with RArrDet.AType  
RETURNS TABLE  AS          
RETURN (          
select          
Distinct          
RCalc.ANO,          
RCalc.Code,          
RCalc.Currency,          
RCalc.SDate,  
RCalc.EDate,  
Prorata_Calculation=          
case          
When RArrDet.AType<>'N' then          
 case          
 when DateDiff(day, (Case When Datediff(day, RCalc.EDate, RArrDet.EDate)>=0 Then RCalc.EDate else RArrDet.EDate end), acceptance.pdate)>=0 then ''
 when DateDiff(day, acceptance.pdate, (Case When Datediff(day, RArrDet.SDate, RCalc.SDate)>=0 Then RCalc.SDate else RArrDet.SDate end))>0 then ''          
 Else          
  case          
  when acceptance.cpct<>0 or Cover.Voyage=1 then          
   case when acceptance.cpct<>0 and acceptance.cpct<>100 then convert(varchar(25),Cast(Acceptance.CPCT as float),3)+'%' else '' end          
  Else          
    case          
     when day(acceptance.pdate)=day((Case When Datediff(day, RCalc.EDate, RArrDet.EDate)>=0 Then RCalc.EDate else RArrDet.EDate end)) and day((Case When Datediff(day, RArrDet.SDate, RCalc.SDate)>=0 Then RCalc.SDate else RArrDet.SDate end))=day((Case When Datediff(day, RCalc.EDate, RArrDet.EDate)>=0 Then RCalc.EDate else RArrDet.EDate end)) and Cover.PPeriod<>1 and datediff(month,(Case When Datediff(day, RArrDet.SDate, RCalc.SDate)>=0 Then RCalc.SDate else RArrDet.SDate end),(Case When Datediff(day, RCalc.EDate, RArrDet.EDate)>=0 Then RCalc.EDate else RArrDet.EDate end))<>0 then          
  Case When DateDiff(month, acceptance.pdate, (Case When Datediff(day, RCalc.EDate, RArrDet.EDate)>=0 Then RCalc.EDate else RArrDet.EDate end))<>datediff(month,(Case When Datediff(day, RArrDet.SDate, RCalc.SDate)>=0 Then RCalc.SDate else RArrDet.SDate end),(Case When Datediff(day, RCalc.EDate, RArrDet.EDate)>=0 Then RCalc.EDate else RArrDet.EDate end)) then          
       convert(varchar(25),DateDiff(month, acceptance.pdate, (Case When Datediff(day, RCalc.EDate, RArrDet.EDate)>=0 Then RCalc.EDate else RArrDet.EDate end)))+'/'+convert(varchar(25),datediff(month,(Case When Datediff(day, RArrDet.SDate, RCalc.SDate)>=0 Then RCalc.SDate else RArrDet.SDate end),(Case When Datediff(day, RCalc.EDate, RArrDet.EDate)>=0 Then RCalc.EDate else RArrDet.EDate end)))          
  Else          
   ''          
  End          
    Else          
  Case When DateDiff(day, acceptance.pdate, (Case When Datediff(day, RCalc.EDate, RArrDet.EDate)>=0 Then RCalc.EDate else RArrDet.EDate end))<>datediff(day,(Case When Datediff(day, RArrDet.SDate, RCalc.SDate)>=0 Then RCalc.SDate else RArrDet.SDate end),(Case When Datediff(day, RCalc.EDate, RArrDet.EDate)>=0 Then RCalc.EDate else RArrDet.EDate end)) then          
       convert(varchar(25),DateDiff(day, acceptance.pdate, (Case When Datediff(day, RCalc.EDate, RArrDet.EDate)>=0 Then RCalc.EDate else RArrDet.EDate end)))+'/'+convert(varchar(25),datediff(day,(Case When Datediff(day, RArrDet.SDate, RCalc.SDate)>=0 Then RCalc.SDate else RArrDet.SDate end),(Case When Datediff(day, RCalc.EDate, RArrDet.EDate)>=0 Then RCalc.EDate else RArrDet.EDate end)))          
  Else          
   ''          
  End          
            
    End          
  End          
 End          
Else          
 ''          
end,          
            
Prorata=          
case          
When RArrDet.AType<>'N' then          
 case          
 when DateDiff(day, (Case When Datediff(day, RCalc.EDate, RArrDet.EDate)>=0 Then RCalc.EDate else RArrDet.EDate end), acceptance.pdate)>=0 then 0          
 when DateDiff(day, acceptance.pdate, (Case When Datediff(day, RArrDet.SDate, RCalc.SDate)>=0 Then RCalc.SDate else RArrDet.SDate end))>0 then 1          
 Else          
  case  
  when acceptance.cpct<>0 or Cover.Voyage=1 then          
   case when acceptance.cpct<>0 and acceptance.cpct<>100 then Acceptance.CPCT/100 else 1 end          
  Else          
    case          
     when day(acceptance.pdate)=day((Case When Datediff(day, RCalc.EDate, RArrDet.EDate)>=0 Then RCalc.EDate else RArrDet.EDate end)) and day((Case When Datediff(day, RArrDet.SDate, RCalc.SDate)>=0 Then RCalc.SDate else RArrDet.SDate end))=day((Case When Datediff(day, RCalc.EDate, RArrDet.EDate)>=0 Then RCalc.EDate else RArrDet.EDate end)) and Cover.PPeriod<>1 and datediff(month,(Case When Datediff(day, RArrDet.SDate, RCalc.SDate)>=0 Then RCalc.SDate else RArrDet.SDate end),(Case When Datediff(day, RCalc.EDate, RArrDet.EDate)>=0 Then RCalc.EDate else RArrDet.EDate end))<>0 then          
  Case When DateDiff(month, acceptance.pdate, (Case When Datediff(day, RCalc.EDate, RArrDet.EDate)>=0 Then RCalc.EDate else RArrDet.EDate end))<>datediff(month,(Case When Datediff(day, RArrDet.SDate, RCalc.SDate)>=0 Then RCalc.SDate else RArrDet.SDate end),(Case When Datediff(day, RCalc.EDate, RArrDet.EDate)>=0 Then RCalc.EDate else RArrDet.EDate end)) then          
       Cast(DateDiff(month, acceptance.pdate, (Case When Datediff(day, RCalc.EDate, RArrDet.EDate)>=0 Then RCalc.EDate else RArrDet.EDate end)) as Float)/Cast(datediff(month,(Case When Datediff(day, RArrDet.SDate, RCalc.SDate)>=0 Then RCalc.SDate else RArrDet.SDate end),(Case When Datediff(day, RCalc.EDate, RArrDet.EDate)>=0 Then RCalc.EDate else RArrDet.EDate end)) as Float)          
  Else          
1          
  End          
    Else          
  Case When DateDiff(day, acceptance.pdate, (Case When Datediff(day, RCalc.EDate, RArrDet.EDate)>=0 Then RCalc.EDate else RArrDet.EDate end))<>datediff(day,(Case When Datediff(day, RArrDet.SDate, RCalc.SDate)>=0 Then RCalc.SDate else RArrDet.SDate end),(Case When Datediff(day, RCalc.EDate, RArrDet.EDate)>=0 Then RCalc.EDate else RArrDet.EDate end)) then          
       Cast(DateDiff(Day, acceptance.pdate, (Case When Datediff(day, RCalc.EDate, RArrDet.EDate)>=0 Then RCalc.EDate else RArrDet.EDate end)) as Float)/Cast(datediff(Day,(Case When Datediff(day, RArrDet.SDate, RCalc.SDate)>=0 Then RCalc.SDate else RArrDet.SDate end),(Case When Datediff(day, RCalc.EDate, RArrDet.EDate)>=0 Then RCalc.EDate else RArrDet.EDate end)) as Float)          
  Else          
1          
  End          
            
    End          
  End          
 End          
Else          
1          
End                                
From acceptance          
inner Join Cover on (Cover.CNO=Acceptance.CNO)          
inner join PCalc on (PCalc.ANO=Acceptance.ANO)          
inner join RCalc on (RCalc.ANO=PCalc.ANO and RCalc.Currency=PCalc.Currency)          
inner join RArrDet on (RArrDet.ANO=Acceptance.ANO and RArrDet.FID=@P_FID)    
inner Join RCover on (RCover.ANO=Acceptance.ANO and RCover.Code=RCalc.Code and RCover.SDate=RCalc.SDate)        
Where RArrDet.AType not in ('A','C')        
and (RArrDet.AType='N' or (Acceptance.NoRefundF not in (2) and RCover.NoRefundF=0 and RArrDet.NoRefundF=0 and (Acceptance.NoRefundF in (0,3,4,5,6) or (DateDiff(day, acceptance.pdate, (Case When Datediff(day, RArrDet.SDate, RCalc.SDate)>=0 Then RCalc.SDate else RArrDet.SDate end))>0))))
and Acceptance.ANO=@P_ANO        
            
Union All          
            
select          
Distinct          
RCalc.ANO,          
RCalc.Code,          
RCalc.Currency,          
RCalc.SDate,  
RCalc.EDate,  
Prorata_Calculation=          
case          
when DateDiff(day, (Case When Datediff(day, RCalc.EDate, RArrDet.EDate)>=0 Then RCalc.EDate else RArrDet.EDate end), acceptance.pdate)>=0 and acceptance.pdate between pacceptance.sdate and pacceptance.edate then ''
when DateDiff(day, acceptance.pdate, (Case When Datediff(day, RArrDet.SDate, RCalc.SDate)>=0 Then RCalc.SDate else RArrDet.SDate end))>0 and acceptance.pdate between pacceptance.sdate and pacceptance.edate then ''          
Else          
  case          
  when acceptance.cpct<>0 or Cover.Voyage=1 then          
    case when acceptance.cpct<>0 and acceptance.cpct<>100 then convert(varchar(25),Cast(Acceptance.CPCT as float),3)+'%' else '' end        Else          
    case          
  When Acceptance.SDate<>Acceptance.PDate or Acceptance.NoRefundF=6 then          
      case          
       when day(acceptance.pdate)=day((Case When Datediff(day, RCalc.EDate, RArrDet.EDate)>=0 Then RCalc.EDate else RArrDet.EDate end)) and day((Case When Datediff(day, RArrDet.SDate, RCalc.SDate)>=0 Then RCalc.SDate else RArrDet.SDate end))=day((Case When Datediff(day, RCalc.EDate, RArrDet.EDate)>=0 Then RCalc.EDate else RArrDet.EDate end)) and Cover.PPeriod<>1 and datediff(month,(Case When Datediff(day, RArrDet.SDate, RCalc.SDate)>=0 Then RCalc.SDate else RArrDet.SDate end),(Case When Datediff(day, RCalc.EDate, RArrDet.EDate)>=0 Then RCalc.EDate else RArrDet.EDate end))<>0 then          
    Case When DateDiff(month, acceptance.pdate, (Case When Datediff(day, RCalc.EDate, RArrDet.EDate)>=0 Then RCalc.EDate else RArrDet.EDate end))<>datediff(month,(Case When Datediff(day, RArrDet.SDate, RCalc.SDate)>=0 Then RCalc.SDate else RArrDet.SDate end),(Case When Datediff(day, RCalc.EDate, RArrDet.EDate)>=0 Then RCalc.EDate else RArrDet.EDate end)) then          
         convert(varchar(25),DateDiff(month, acceptance.pdate, (Case When Datediff(day, RCalc.EDate, RArrDet.EDate)>=0 Then RCalc.EDate else RArrDet.EDate end)))+'/'+convert(varchar(25),datediff(month,(Case When Datediff(day, RArrDet.SDate, RCalc.SDate)>=0 Then RCalc.SDate else RArrDet.SDate end),(Case When Datediff(day, RCalc.EDate, RArrDet.EDate)>=0 Then RCalc.EDate else RArrDet.EDate end)))          
    Else          
     ''          
    End          
      Else          
    Case When DateDiff(day, acceptance.pdate, (Case When Datediff(day, RCalc.EDate, RArrDet.EDate)>=0 Then RCalc.EDate else RArrDet.EDate end))<>datediff(day,(Case When Datediff(day, RArrDet.SDate, RCalc.SDate)>=0 Then RCalc.SDate else RArrDet.SDate end),(Case When Datediff(day, RCalc.EDate, RArrDet.EDate)>=0 Then RCalc.EDate else RArrDet.EDate end)) then          
         convert(varchar(25),DateDiff(day, acceptance.pdate, (Case When Datediff(day, RCalc.EDate, RArrDet.EDate)>=0 Then RCalc.EDate else RArrDet.EDate end)))+'/'+convert(varchar(25),datediff(day,(Case When Datediff(day, RArrDet.SDate, RCalc.SDate)>=0 Then RCalc.SDate else RArrDet.SDate end),(Case When Datediff(day, RCalc.EDate, RArrDet.EDate)>=0 Then RCalc.EDate else RArrDet.EDate end)))          
    Else          
     ''          
    End          
              
      End          
    Else          
     -- Endorsement Period          
      ''          
    End          
  End          
end,          
Prorata=          
case          
when DateDiff(day, (Case When Datediff(day, RCalc.EDate, RArrDet.EDate)>=0 Then RCalc.EDate else RArrDet.EDate end), acceptance.pdate)>=0 and acceptance.pdate between pacceptance.sdate and pacceptance.edate then 0          
when DateDiff(day, acceptance.pdate, (Case When Datediff(day, RArrDet.SDate, RCalc.SDate)>=0 Then RCalc.SDate else RArrDet.SDate end))>0  and acceptance.pdate between pacceptance.sdate and pacceptance.edate then 1          
Else          
  case          
  when acceptance.cpct<>0 or Cover.Voyage=1 then          
    case when acceptance.cpct<>0 and acceptance.cpct<>100 then Acceptance.CPCT/100 else 1 end          
  Else          
    case          
  When Acceptance.SDate<>Acceptance.PDate or Acceptance.NoRefundF=6 then          
      case          
       when day(acceptance.pdate)=day((Case When Datediff(day, RCalc.EDate, RArrDet.EDate)>=0 Then RCalc.EDate else RArrDet.EDate end)) and day((Case When Datediff(day, RArrDet.SDate, RCalc.SDate)>=0 Then RCalc.SDate else RArrDet.SDate end))=day((Case When Datediff(day, RCalc.EDate, RArrDet.EDate)>=0 Then RCalc.EDate else RArrDet.EDate end)) and Cover.PPeriod<>1 and datediff(month,(Case When Datediff(day, RArrDet.SDate, RCalc.SDate)>=0 Then RCalc.SDate else RArrDet.SDate end),(Case When Datediff(day, RCalc.EDate, RArrDet.EDate)>=0 Then RCalc.EDate else RArrDet.EDate end))<>0 then          
    Case When DateDiff(month, acceptance.pdate, (Case When Datediff(day, RCalc.EDate, RArrDet.EDate)>=0 Then RCalc.EDate else RArrDet.EDate end))<>datediff(month,(Case When Datediff(day, RArrDet.SDate, RCalc.SDate)>=0 Then RCalc.SDate else RArrDet.SDate end),(Case When Datediff(day, RCalc.EDate, RArrDet.EDate)>=0 Then RCalc.EDate else RArrDet.EDate end)) then          
         Cast(DateDiff(month, acceptance.pdate, (Case When Datediff(day, RCalc.EDate, RArrDet.EDate)>=0 Then RCalc.EDate else RArrDet.EDate end)) as Float)/Cast(datediff(month,(Case When Datediff(day, RArrDet.SDate, RCalc.SDate)>=0 Then RCalc.SDate else RArrDet.SDate end),(Case When Datediff(day, RCalc.EDate, RArrDet.EDate)>=0 Then RCalc.EDate else RArrDet.EDate end)) as Float)          
    Else          
 1          
    End          
      Else          
    Case When DateDiff(day, acceptance.pdate, (Case When Datediff(day, RCalc.EDate, RArrDet.EDate)>=0 Then RCalc.EDate else RArrDet.EDate end))<>datediff(day,(Case When Datediff(day, RArrDet.SDate, RCalc.SDate)>=0 Then RCalc.SDate else RArrDet.SDate end),(Case When Datediff(day, RCalc.EDate, RArrDet.EDate)>=0 Then RCalc.EDate else RArrDet.EDate end)) then          
         Cast(DateDiff(Day, acceptance.pdate, (Case When Datediff(day, RCalc.EDate, RArrDet.EDate)>=0 Then RCalc.EDate else RArrDet.EDate end)) as Float)/Cast(datediff(Day,(Case When Datediff(day, RArrDet.SDate, RCalc.SDate)>=0 Then RCalc.SDate else RArrDet.SDate end),(Case When Datediff(day, RCalc.EDate, RArrDet.EDate)>=0 Then RCalc.EDate else RArrDet.EDate end)) as Float)          
    Else          
 1          
    End          
              
      End          
    Else          
     -- Endorsement Period          
 1          
    End          
  End          
End          
            
From acceptance          
inner Join Cover on (Cover.CNO=Acceptance.CNO)          
inner join Acceptance pAcceptance on (pAcceptance.ANO=Acceptance.pANO)          
inner join PCalc on (PCalc.ANO=pAcceptance.ANO)          
inner join RCalc on (RCalc.ANO=PCalc.ANO and RCalc.Currency=PCalc.Currency)     
inner join RArrDet on (RArrDet.ANO=pAcceptance.ANO and RArrDet.FID=@P_FID)         
Left Join RCover on (RCover.ANO=pAcceptance.ANO and RCover.Code=RCalc.Code and RCover.SDate=RCalc.SDate)          
Where Acceptance.AType<>'A' and Not (Acceptance.AType='C' and Acceptance.EMethod='A') and pAcceptance.AType not in ('A','C')        
and Acceptance.NoRefundF Not in (2) and coalesce(RCover.NoRefundF,0)=0 and coalesce(RArrDet.NoRefundF,0)=0
and (Acceptance.NoRefundF in (0,3,4,5,6) or (DateDiff(day, acceptance.pdate, (Case When Datediff(day, RArrDet.SDate, RCalc.SDate)>=0 Then RCalc.SDate else RArrDet.SDate end))>0  and acceptance.pdate between pacceptance.sdate and pacceptance.edate))      
and Acceptance.ANO=@P_ANO        
)

GO

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[FL_SR_TOC]') AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) ) 
begin
DROP FUNCTION FL_SR_TOC 
end
GO
Create function FL_SR_TOC(@P_USERID varchar(50), @P_TOC varchar(10),@P_PolicyType varchar(10))  
RETURNS Table  
AS RETURN  
(

Select Distinct TOC.TOC,TOC.Description 
From TOC, PTClass, SysUserTOC S 
Where TOC.AllowedF=1 and S.ID=@P_USERID and S.TOC=TOC.TOC and PTClass.COB=TOC.COB and PTClass.PolicyType like @P_PolicyType+'%' and TOC.TOC like @P_TOC+'%'
and S.Effective<=cast(convert(varchar(10),getdate(),1) as smalldatetime)
and not exists (Select S1.ID from SysUserTOC S1 Where S1.TOC=S.TOC and S1.ID=S.ID and S1.Effective<=cast(convert(varchar(10),getdate(),1) as smalldatetime) and S1.Effective>S.Effective)
)


GO

IF EXISTS ( SELECT * FROM   sysobjects WHERE  id = object_id(N'[dbo].[QGetPreCedeFacCessionAmount]') and OBJECTPROPERTY(id, N'IsProcedure') = 1 )
begin
DROP Procedure QGetPreCedeFacCessionAmount
end
GO
CREATE Procedure QGetPreCedeFacCessionAmount(@P_ANO integer)     
as     
Select sum(
Case 
When RArrDet.Amount<>0 Then RArrDet.Amount
When RArrDet.Limit<>0 Then (RArrDet.Share-RArrDet.JPShare)/100*RArrDet.Limit
When RArrHeader.TAmount<>0 then (RArrDet.Share-RArrDet.JPShare)/100*RArrHeader.TAmount
else (RArrDet.Share-RArrDet.JPShare)/100*P.Amount/P.NUMRISK
end) as Amount   
from RArrDet     
Inner Join RArrHeader on (RArrHeader.ANO=RArrDet.ANO)
Inner Join FN_PCalc(@P_ANO) P on (P.ANO=RArrDet.ANO)
Inner Join Acceptance on (Acceptance.ANO=RArrDet.ANO)     
Inner Join Cover on (Cover.CNO=Acceptance.CNO)     
Inner Join TOC on (TOC.TOC=Acceptance.TOC)     
Where (RArrDet.FullCoverF=1 or Exists (Select RCover.Category from FPartDet, RCover Where RCover.ANO=FPartDet.ANO and RCover.Code=FPartDet.Code and RCover.Category='M' and FPartDet.ANO=RArrDet.ANO and FPartDet.FID=RArrDet.FID))     
and RArrDet.Status<>'O' and (RArrDet.PrecedeFacCessionF=1 or TOC.PrecedeFacCessionF=1)     
and RArrDet.ANO=@P_ANO     

GO

IF EXISTS ( SELECT * FROM   sysobjects WHERE  id = object_id(N'[dbo].[QRateCode]') and OBJECTPROPERTY(id, N'IsProcedure') = 1 )
begin
DROP Procedure QRateCode
end
GO
CREATE PROCEDURE QRateCode (@P_ANO as integer, @P_Code as varchar(20),@P_AllowedF as bit=0, @P_TSI as float=0)              
AS              
Declare @Temp Table (Code varchar(20), Rate Float, MinRate Float, MaxRate Float, PML Float, TExcess Int, Loading Float, AllowedF bit)  

Select @P_TSI = case When @P_TSI=0 Then 1 else @P_TSI end

Declare RateCode_Cursor Cursor For 
	Select RateTab.Code
	FROM  Acceptance               
	Inner join RateTab on ((RateTab.TOC=substring(Acceptance.TOC,1,len(RateTab.TOC))) and RateTab.Effective<=Acceptance.SDate and (@P_Code='%' or RateTab.Code Like @P_Code OR RateTab.Description Like @P_Code) And (RateTab.AllowedF=@P_AllowedF or @P_AllowedF=0))            
	Where Acceptance.ANO=@P_ANO  

Open RateCode_Cursor

Declare @P_Code_Temp as varchar(20)

FETCH FROM RateCode_Cursor into @P_Code_Temp
WHILE @@FETCH_STATUS = 0  
BEGIN  
	insert into @TEMP(Code, Rate, MinRate, MaxRate, PML, TExcess, Loading, AllowedF)
	Select Top 1 Code, Rate, MinRate, MaxRate, PML, TExcess, Loading, AllowedF 
	from fn_RateCon(@P_ANO,@P_Code_Temp,@P_TSI) F
	FETCH Next FROM RateCode_Cursor into @P_Code_Temp
End  
Close RateCode_Cursor  
Deallocate RateCode_Cursor


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
 Max(F.MinRate) as MinRate,
 Max(F.MaxRate) as MaxRate,
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
GROUP BY RateTab.Code, RateTab.AllowedF, RateTab.NoRefundF  , RateTab.SIBasedID  


GO


IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[FL_RateCode]') AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) ) 
begin
DROP FUNCTION FL_RateCode 
end
GO
CREATE Function FL_RateCode(@P_ANO as integer, @P_Code as varchar(10),@P_AllowedF as bit=0, @P_TSI as float=0, @P_TOPF as bit=0)   
RETURNS @RateCon TABLE (Code varchar(10), AllowedF Bit, NoRefundF Bit, SIBasedID Int, Description varchar(255), Unit varchar(10), Category varchar(10), Rate Float, MinRate Float, MaxRate Float, PML Float, Portion Float, Loading Float, TExcess Float)
AS
BEGIN
Declare @Temp Table (Code varchar(20), Rate Float, MinRate Float, MaxRate Float, PML Float, TExcess Int, Loading Float, AllowedF bit)  

Select @P_TSI = case When @P_TSI=0 Then 1 else @P_TSI end

Declare RateCode_Cursor Cursor For 
	Select RateTab.Code
	FROM  Acceptance               
	Inner join RateTab on ((RateTab.TOC=substring(Acceptance.TOC,1,len(RateTab.TOC))) and RateTab.Effective<=Acceptance.SDate and (@P_Code='%' or RateTab.Code Like @P_Code OR RateTab.Description Like @P_Code) And (RateTab.AllowedF=@P_AllowedF or @P_AllowedF=0))            
	Where Acceptance.ANO=@P_ANO  

Open RateCode_Cursor

Declare @P_Code_Temp as varchar(20)

FETCH FROM RateCode_Cursor into @P_Code_Temp
WHILE @@FETCH_STATUS = 0  
BEGIN  
	insert into @TEMP(Code, Rate, MinRate, MaxRate, PML, TExcess, Loading, AllowedF)
	Select Top 1 Code, Rate, MinRate, MaxRate, PML, TExcess, Loading, AllowedF 
	from fn_RateCon(@P_ANO,@P_Code_Temp,@P_TSI) F
	FETCH Next FROM RateCode_Cursor into @P_Code_Temp
End  
Close RateCode_Cursor  
Deallocate RateCode_Cursor

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
 Max(F.MinRate) as MinRate,
 Max(F.MaxRate) as MaxRate,
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
Left join TOP_RATE on (TOP_RATE.TOPRO=Acceptance.TOPRO and (TOP_Rate.Code=RateTab.Code or TOP_Rate.Code=RateTab.PCode) and RateTab.effective<=Acceptance.pDate)     
WHERE  Acceptance.ANO=@P_ANO
and (@P_TOPF=0 or coalesce(TOP_RATE.TOPRO,'')=Acceptance.TOPRO)
GROUP BY RateTab.Code, RateTab.AllowedF, RateTab.NoRefundF  , RateTab.SIBasedID  

RETURN
END

GO

IF EXISTS ( SELECT * FROM   sysobjects WHERE  id = object_id(N'[dbo].[ListQry_2]') and OBJECTPROPERTY(id, N'IsProcedure') = 1 )
begin
DROP Procedure ListQry_2
end
GO
CREATE PROCEDURE ListQry_2(@P_ANO as integer)
AS   
SELECT Cast(0 as bit) as ProcessFlag,   
Cover.COVERNO,   
Cast(Acceptance.AName as varchar(128)) as Insured,   
Cover.CNO,   
Cover.CStatus,   
Acceptance.lANO,   
Acceptance.ANO,   
Acceptance.REGNO,   
Acceptance.ADATE,   
Acceptance.LUSERID as USERID,   
SysTab.Currency,   
(SELECT coalesce(SUM(PCALC.TSI*PCALC.RATE),0) FROM  PCALC WHERE PCALC.ANO=ACCEPTANCE.ANO AND ACCEPTANCE.PSTATUS='C')*CASE WHEN ACCEPTANCE.QTY=0 THEN 1 ELSE ACCEPTANCE.QTY END AS TSI,
(SELECT coalesce(SUM(PCALC.OURSHARE*PCALC.RATE),0) FROM  PCALC WHERE PCALC.ANO=ACCEPTANCE.ANO AND ACCEPTANCE.PSTATUS='C')*CASE WHEN ACCEPTANCE.QTY=0 THEN 1 ELSE ACCEPTANCE.QTY END AS OURSHARE, 
(SELECT coalesce(SUM(PCALC.GROSS*PCALC.RATE),0) FROM  PCALC WHERE PCALC.ANO=ACCEPTANCE.ANO AND ACCEPTANCE.PSTATUS='C')*CASE WHEN ACCEPTANCE.QTY=0 THEN 1 ELSE ACCEPTANCE.QTY END AS GROSS,
Acceptance.ASTATUS,   
Acceptance.ATYPE,   
Acceptance.SDate,   
Acceptance.EDate,   
Year(Coalesce(RArrHeader.RDate,Acceptance.SDate)) AS RYear,   
Cover.ISType,   
Acceptance.Renewal,   
Acceptance.ESeqNo,   
Acceptance.PolicyNo,   
Acceptance.CertificateNo   
FROM  Acceptance left Join RArrHeader on (RArrHeader.ANO=Acceptance.ANO), Cover, SysTab   
WHERE  Cover.CNO=Acceptance.CNO   
And (Acceptance.ANO=Acceptance.LANO Or Acceptance.LANO=-1)   
And Cover.ISType<>'T'
and Acceptance.ano=@P_ANO 
	
GO


IF EXISTS ( SELECT * FROM   sysobjects WHERE  id = object_id(N'[dbo].[ListQry_2_b]') and OBJECTPROPERTY(id, N'IsProcedure') = 1 )
begin
DROP Procedure ListQry_2_b
end
GO
CREATE PROCEDURE ListQry_2_b (@P_ANO as integer, @P_CertificateNo as varchar(255))
AS
SELECT Distinct
Cast(0 as bit) as ProcessFlag,   
Cover.COVERNO,   
Cast(Acceptance.AName as varchar(128)) as Insured,   
Cover.CNO,   
Cover.CStatus,   
Acceptance.lANO,   
Acceptance.ANO,   
Acceptance.REGNO,   
Acceptance.ADATE,   
Acceptance.LUSERID as USERID,   
SysTab.Currency,   
(SELECT coalesce(SUM(PCALC.TSI*PCALC.RATE),0) FROM  PCALC WHERE PCALC.ANO=ACCEPTANCE.ANO AND ACCEPTANCE.PSTATUS='C')*CASE WHEN ACCEPTANCE.QTY=0 THEN 1 ELSE ACCEPTANCE.QTY END AS TSI,
(SELECT coalesce(SUM(PCALC.OURSHARE*PCALC.RATE),0) FROM  PCALC WHERE PCALC.ANO=ACCEPTANCE.ANO AND ACCEPTANCE.PSTATUS='C')*CASE WHEN ACCEPTANCE.QTY=0 THEN 1 ELSE ACCEPTANCE.QTY END AS OURSHARE, 
(SELECT coalesce(SUM(PCALC.GROSS*PCALC.RATE),0) FROM  PCALC WHERE PCALC.ANO=ACCEPTANCE.ANO AND ACCEPTANCE.PSTATUS='C')*CASE WHEN ACCEPTANCE.QTY=0 THEN 1 ELSE ACCEPTANCE.QTY END AS GROSS,
Acceptance.ASTATUS,   
Acceptance.ATYPE,   
Acceptance.SDate,   
Acceptance.EDate,   
Year(Coalesce(RArrHeader.RDate,Acceptance.SDate)) AS RYear,   
Cover.ISType,   
Acceptance.Renewal,   
Acceptance.ESeqNo,   
Acceptance.PolicyNo,   
Acceptance.CertificateNo   
FROM  Acceptance left Join RArrHeader on (RArrHeader.ANO=Acceptance.ANO), Cover, SysTab, Acceptance as acceptance_detail
WHERE  Cover.CNO=Acceptance.CNO   
And Cover.ISType<>'T'
and Acceptance.ano=@P_ANO 
and acceptance.ano = acceptance_detail.lano 
and Acceptance_detail.ANO<>Acceptance_detail.LANO
And acceptance_detail.CertificateNo = @P_CertificateNo

GO

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Premium_Fee]') AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) ) 
begin
DROP FUNCTION Premium_Fee 
end
GO

CREATE Function Premium_Fee(@P_ANO as int,@P_Period int=0) 
RETURNS Float 
AS 
BEGIN 

Declare @P_OPFEEPCT Float

Select 
@P_OPFEEPCT=coalesce(Sum(
	Case When A1.Amount<>0 Then
		A1.Amount*100/coalesce(R.PCTSHARE-R.MSHARE,100)/PCalc.Gross*100 
	Else
		A1.AmountPCT
	End),0)
from 
Acceptance A
Inner join Acceptance A2 on (A2.OANO=A.ANO and A2.ANO<=A.ANO)
INNER JOIN AccFD A1 on (A1.ANO=A2.ANO and A1.ContributionF=0 And (A1.PolicyYear=0 or A1.PolicyYear=@P_Period))
INNER JOIN FDTAB on (FDTAB.FDID=A1.FDID)
INNER Join PCalc on (PCalc.ANO=A1.ANO and PCalc.Currency=A1.Currency)
INNER JOIN RARRHEADER R ON (R.ANO=A2.ANO)
Where FDTAB.FDType='O' and A.ANO=@P_ANO 

if @P_OPFEEPCT is null 
	Select @P_OPFEEPCT=0

return (@P_OPFEEPCT) 
 
End


GO

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Premium_OutGo]') AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) ) 
begin
DROP FUNCTION Premium_OutGo 
end
GO

CREATE Function Premium_OutGo(@P_ANO as int,@P_Code as varchar(10),@P_Period int=0)  
RETURNS Float  
AS  
BEGIN  
 Return (dbo.premium_discount(@P_ANO, @P_Code,@P_Period)+dbo.Premium_Commission(@P_ANO, @P_Code,@P_Period,0)+dbo.Premium_Commission_Vat(@P_ANO, @P_Code,@P_Period,0)+dbo.premium_Fee(@P_ANO, @P_Period))  
End  

GO

DROP Procedure QRCESSIONDET 
GO
CREATE Procedure QRCESSIONDET (@P_ANO integer,@P_RID varchar(255), @P_ID varchar(255), @P_CCY varchar(255), @P_SDate DateTime, @P_EDate DateTime, @P_Code varchar(10), @P_AdjustableF bit,@P_TSI as Float=0, @P_ASDate as DateTime=0)              
AS          
Declare @Premium_Treaty_Discount as Float          
Declare @Premium_Discount as Float          
Declare @Premium_Commission as Float          
Declare @Premium_Fee as Float          
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
@P_TOC=A.TOC,   
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
Where C.CNO=A.CNO and R.ANO=A.ANO and A.ANO=@P_ANO and R1.RID=@P_RID and R2.RNO=R1.RNO and R3.RNO=R1.RNO and R2.ID=@P_ID and R3.TOC=A.TOC  

Select @Premium_Treaty_Discount=dbo.Premium_Treaty_Discount(@P_ANO, @P_Code,cast(datediff(Month,@P_ASDate, @P_SDate) as integer) / 12 + 1)          
Select @Premium_Discount=dbo.premium_discount(@P_ANO, @P_Code, cast(datediff(Month,@P_ASDate, @P_SDate) as integer) / 12 + 1)  
Select @Premium_Commission=dbo.Premium_Commission(@P_ANO, @P_Code, cast(datediff(Month,@P_ASDate, @P_SDate) as integer) / 12 + 1,0)+dbo.Premium_Commission_Vat(@P_ANO, @P_Code, cast(datediff(Month,@P_ASDate, @P_SDate) as integer) / 12 + 1,0)  
Select @Premium_Fee=dbo.Premium_Fee(@P_ANO, cast(datediff(Month,@P_ASDate, @P_SDate) as integer) / 12 + 1)  
Select @Premium_outGo=@Premium_Discount+@Premium_Commission+@Premium_Fee  

Select 
@P_OPFEE=coalesce(Sum(
	Case When A1.Amount<>0 Then
		A1.Amount*100/coalesce(R.PCTSHARE-R.MSHARE,100) 
	Else
		A1.AmountPCT/100*PCalc.Gross
	End	
),0)
from 
Acceptance A2
INNER JOIN AccFD A1 on (A1.ANO=A2.ANO and A1.Currency=@P_CCY and A1.ContributionF=1)
INNER JOIN FDTAB on (FDTAB.FDID=A1.FDID)
INNER Join PCalc on (PCalc.ANO=A1.ANO and PCalc.Currency=A1.Currency)
INNER JOIN RARRHEADER R ON (R.ANO=A2.ANO)
Where @P_RType in ('Q','S1','S2','S3') and FDTAB.FDType='O' and A2.OANO=@P_OANO and A2.ANO<=@P_ANO  

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
coalesce(SUM((Case When @P_RateConF=1 Then (Case When RRateCon.Rate is null then RateCon.Rate*(Case When RateCon.Loading<>0 then RateCon.Loading/100 else RCover.Loading end) else RRateCon.Rate/PCalc.RiskNum*(Case When RRateCon.Loading<>0 then RRateCon.Loading/100 else RCover.Loading end) end) Else coalesce(@P_NETRATEDet,RPARTDET.NETRate) end/100*(100-RCover.Discount)/100*ICALC.GROSS/PCALC.GROSS*ICALC.PRORATA *ICALC.TSI*(CASE WHEN RCOVER.PCALC='S' OR RCOVER.PCTLOSS=0 THEN 100 ELSE RCOVER.PCTLOSS END)/(CASE

 WHEN RCOVER.PCTLOSS=0 THEN 100 ELSE RCOVER.PCTLOSS END+RCOVER.PAddition)*ICALC.PCTADJ/100-(ICALC.GROSS*@P_OPFEE/PCALC.POGROSS))*(Case When RPARTDET.COMMN=0 Then RPARTDET.COMM/100 else (Case When RCover.NetRateF=1 or @P_ONGROSSNET=2 OR (@P_ONGROSSNET=0 AND (100-@Premium_OutGo)/100*(100-RPARTDET.CommN)/100<(100-RPARTDET.COMM)/100) Then (100-@Premium_OutGo)/100*(RPARTDET.CommN)/100 else RPARTDET.COMM/100 end) end)),0) AS COMM_2,                  
              
coalesce(SUM((CASE WHEN RPARTDET.PPCT<>0 THEN RPARTDET.PPCT/100 ELSE (Case When @P_RateConF=1 and (RRateCon.Rate is not null or RateCon.Rate is not null) then 0 else 1 end) END * ICALC.GROSS*(PCALC.PGROSS*@P_PFactor)/PCALC.POGROSS)*(Case When @P_OnNetPremiumF=1 Then (100-@Premium_Treaty_Discount)/100 else 1 end)*(Case When RPARTDET.COMMN=0 Then 1 else (Case When RCover.NetRateF=1 or @P_ONGROSSNET=2 OR (@P_ONGROSSNET=0 AND (100-@Premium_OutGo)/100*(100-RPARTDET.CommN)/100<(100-RPARTDET.COMM)/100) Then 1 else 1 end) end)),0) AS GROSS_1,              
coalesce(SUM((Case When @P_RateConF=1 Then (Case When RRateCon.Rate is null then RateCon.Rate*(Case When RateCon.Loading<>0 then RateCon.Loading/100 else RCover.Loading end) else RRateCon.Rate/PCalc.RiskNum*(Case When RRateCon.Loading<>0 then RRateCon.Loading/100 else RCover.Loading end) end) Else coalesce(@P_NETRATEDet,RPARTDET.NETRate) end/100*(100-RCover.Discount)/100*ICALC.GROSS/PCALC.GROSS*ICALC.PRORATA *ICALC.TSI*(CASE WHEN RCOVER.PCALC='S' OR RCOVER.PCTLOSS=0 THEN 100 ELSE RCOVER.PCTLOSS END)/(CASE

 WHEN RCOVER.PCTLOSS=0 THEN 100 ELSE RCOVER.PCTLOSS END+RCOVER.PAddition)*ICALC.PCTADJ/100)*(Case When RPARTDET.COMMN=0 Then 1 else (Case When RCover.NetRateF=1 or @P_ONGROSSNET=2 OR (@P_ONGROSSNET=0 AND (100-@Premium_OutGo)/100*(100-RPARTDET.CommN)/100<(100-RPARTDET.COMM)/100) Then 1 else 1 end) end)),0) AS GROSS_2,              

coalesce(SUM((CASE WHEN RPARTDET.PPCT<>0 THEN RPARTDET.PPCT/100 ELSE (Case When @P_RateConF=1 and (RRateCon.Rate is not null or RateCon.Rate is not null) then 0 else 1 end) END * ICALC.GROSS*(PCALC.PGROSS*@P_PFactor)/PCALC.POGROSS-(ICALC.GROSS*@P_OPFEE/PCALC.POGROSS))*(Case When @P_OnNetPremiumF=1 Then (100-@Premium_Treaty_Discount)/100 else 1 end)*(Case When RPARTDET.COMMN=0 Then 0 else (Case When RCover.NetRateF=1 or @P_ONGROSSNET=2 OR (@P_ONGROSSNET=0 AND (100-@Premium_OutGo)/100*(100-RPARTDET.CommN)/100<(100-RPARTDET.COMM)/100) Then (@Premium_OutGo)/100 else 0 end) end)),0) AS DISC_1,              
coalesce(SUM((Case When @P_RateConF=1 Then (Case When RRateCon.Rate is null then RateCon.Rate*(Case When RateCon.Loading<>0 then RateCon.Loading/100 else RCover.Loading end) else RRateCon.Rate/PCalc.RiskNum*(Case When RRateCon.Loading<>0 then RRateCon.Loading/100 else RCover.Loading end) end) Else coalesce(@P_NETRATEDet,RPARTDET.NETRate) end/100*(100-RCover.Discount)/100*ICALC.GROSS/PCALC.GROSS*ICALC.PRORATA *ICALC.TSI*(CASE WHEN RCOVER.PCALC='S' OR RCOVER.PCTLOSS=0 THEN 100 ELSE RCOVER.PCTLOSS END)/(CASE

 WHEN RCOVER.PCTLOSS=0 THEN 100 ELSE RCOVER.PCTLOSS END+RCOVER.PAddition)*ICALC.PCTADJ/100)*(Case When RPARTDET.COMMN=0 Then 0 else (Case When RCover.NetRateF=1 or @P_ONGROSSNET=2 OR (@P_ONGROSSNET=0 AND (100-@Premium_OutGo)/100*(100-RPARTDET.CommN)/100<(100-RPARTDET.COMM)/100) Then (@Premium_OutGo)/100 else 0 end) end)),0) AS DISC_2,  

coalesce(SUM((CASE WHEN RPARTDET.PPCT<>0 THEN RPARTDET.PPCT/100 ELSE (Case When @P_RateConF=1 and (RRateCon.Rate is not null or RateCon.Rate is not null) then 0 else 1 end) END * ICALC.GROSS*(PCALC.PGROSS*@P_PFactor)/PCALC.POGROSS)*(Case When @P_OnNetPremiumF=1 Then (100-@Premium_Treaty_Discount)/100 else 1 end)*(Case When RPARTDET.COMMN=0 Then 1 else (Case When RCover.NetRateF=1 or @P_ONGROSSNET=2 OR (@P_ONGROSSNET=0 AND (100-@Premium_OutGo)/100*(100-RPARTDET.CommN)/100<(100-RPARTDET.COMM)/100) Then 1 else 1 end) end)*@P_FEE/100-(ICALC.GROSS*@P_OPFEE/PCALC.POGROSS)),0) AS FEE_1,              
coalesce(SUM((Case When @P_RateConF=1 Then (Case When RRateCon.Rate is null then RateCon.Rate*(Case When RateCon.Loading<>0 then RateCon.Loading/100 else RCover.Loading end) else RRateCon.Rate/PCalc.RiskNum*(Case When RRateCon.Loading<>0 then RRateCon.Loading/100 else RCover.Loading end) end) Else coalesce(@P_NETRATEDet,RPARTDET.NETRate) end/100*(100-RCover.Discount)/100*ICALC.GROSS/PCALC.GROSS*ICALC.PRORATA *ICALC.TSI*(CASE WHEN RCOVER.PCALC='S' OR RCOVER.PCTLOSS=0 THEN 100 ELSE RCOVER.PCTLOSS END)/(CASE

 WHEN RCOVER.PCTLOSS=0 THEN 100 ELSE RCOVER.PCTLOSS END+RCOVER.PAddition)*ICALC.PCTADJ/100)*(Case When RPARTDET.COMMN=0 Then 1 else (Case When RCover.NetRateF=1 or @P_ONGROSSNET=2 OR (@P_ONGROSSNET=0 AND (100-@Premium_OutGo)/100*(100-RPARTDET.CommN)/100<(100-RPARTDET.COMM)/100) Then 1 else 1 end) end)*@P_FEE/100-(ICALC.GROSS*@P_OPFEE/PCALC.POGROSS)),0) AS FEE_2  
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

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PREMIUM_CALCULATION_BASE]') AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) ) 
begin
DROP FUNCTION PREMIUM_CALCULATION_BASE 
end
GO

CREATE FUNCTION PREMIUM_CALCULATION_BASE(@P_ANO int)                  

RETURNS @PCALC TABLE (ANO Int, Currency varchar(10), CANO int, Code varchar(10), PolicyYear Int, NoRefundF Bit, MinimumPremiumF Bit, Premium Float, FeeDuty Float)
AS
BEGIN

DECLARE @ACCEPTANCE TABLE (ANO Int, CNO Int, SDate SmallDateTime, NOREFUNDF Bit, AType varchar(10), PDate SmallDateTime, CPCT Float, QTY Int, PANO Int, EMethod varchar(1))
INSERT INTO @ACCEPTANCE
SELECT ANO, CNO, SDATE, NOREFUNDF, ATYPE, PDATE, CPCT, QTY, PANO, EMETHOD FROM ACCEPTANCE WHERE ANO=@P_ANO

INSERT INTO @PCALC
Select ANO, Currency, CANO, Code, PolicyYear, NoRefundF, Cast(Max(MinimumPremiumF) as Bit) as MinimumPremiumF, sum(Premium) as Premium, 0 as FeeDuty      
 from (                  
  select Acceptance.ANO, RCalc.Currency, @P_ANO as CANO, RCalc.Code,  cast(datediff(Month,Acceptance.SDate, RCalc.SDate) as integer) / 12 + 1  as PolicyYear,          
  Acceptance.NoRefundF,   
  Case When Upper(PCALC.DESCRIPTION) in ('MINIMUM PREMIUM','POLICY MINIMUM PREMIUM') Then 1 else 0 end as MinimumPremiumF,                                       
  case                  
  When (Acceptance.NoRefundF in (2,4) or Not (Acceptance.AType='N' or ((RCover.NoRefundF=0 and Acceptance.NoRefundF in (0,3,5,6,7)) or (DateDiff(day, acceptance.pdate, RCalc.SDate) >= 0)))) Then 0      
  When Acceptance.AType<>'N' then                  
   case                  
   when DateDiff(day, rcalc.Edate, acceptance.pdate)>=0 then 0                  
   when DateDiff(day, acceptance.pdate, rcalc.SDate)>0 then 1                  
   Else                  
    case                  
    when acceptance.cpct<>0 or Cover.Voyage=1 then                  
     case                  
     when acceptance.cpct<>0 then                  
		acceptance.cpct/100                  
     Else                  
		1                  
     End                  
    Else                  
		 case                  
		 when day(acceptance.pdate)=day(rcalc.edate) and day(rcalc.sdate)=day(rcalc.edate) and Cover.PPeriod<>1 and datediff(month,rcalc.sdate,rcalc.edate)<>0 then                  
		  convert(float,DateDiff(month, acceptance.pdate, rcalc.edate))/convert(float,datediff(month,rcalc.sdate,rcalc.edate))                  
		 Else                  
		  convert(float,DateDiff(day, acceptance.pdate, rcalc.edate))/convert(float,datediff(day,rcalc.sdate,rcalc.edate))                  
		 End                  
    End                  
   End                  
  Else                  
	1                  
  End                  
  * (Case When Acceptance.Qty=0 Then 1 else Acceptance.Qty end)                  
  * (Case When PCALC.DESCRIPTION='Minimum Premium' Then RCALC.GROSS else RCALC.OGROSS*PCALC.GROSS/PCALC.OGROSS END+RCalc.Reinstatement)*(case When Pcalc.TSI=0 then 1 else PCalc.Ourshare/PCalc.TSI end) as Premium
  From RCALC, PCALC, @Acceptance acceptance, cover, RCOVER             
  Where Acceptance.ANO=@P_ANO AND Cover.CNO=Acceptance.CNO                  
  and RCOVER.ANO=RCALC.ANO AND RCOVER.CODE=RCALC.CODE AND RCOVER.SDATE=RCALC.SDATE                  
  and RCalc.ANO=Acceptance.ANO and PCalc.ANO=RCalc.ANO and PCalc.Currency=RCalc.Currency                  
  and Acceptance.AType not in ('A','C')                  
  and PCalc.Gross<>0          
                                                    
  Union All                  
                                                                                             
  select Acceptance.ANO, RCalc.Currency, Acceptance.PANO as CANO, RCalc.Code, cast(datediff(Month,pAcceptance.SDate, RCalc.SDate) as integer) / 12 + 1 as PolicyYear,          
  Acceptance.NoRefundF,   
  Case When Upper(PCALC.DESCRIPTION) in ('MINIMUM PREMIUM','POLICY MINIMUM PREMIUM') Then 1 else 0 end as MinimumPremiumF,                                       
  -case                  
  When (Acceptance.NoRefundF in (2,4) or Not ((coalesce(RCover.NoRefundF,0)=0 and Acceptance.NoRefundF in (0,3,5,6,7)) or (DateDiff(day, acceptance.pdate, rcalc.SDate) >= 0  and acceptance.pdate between pacceptance.sdate and pacceptance.edate))) Then 0   
  when DateDiff(day, rcalc.Edate, acceptance.pdate)>=0 and acceptance.pdate between pacceptance.sdate and pacceptance.edate then 0                  
  when DateDiff(day, acceptance.pdate, rcalc.SDate)>0 and acceptance.pdate between pacceptance.sdate and pacceptance.edate then 1                  
  Else                  
   case                  
   when acceptance.cpct<>0 or Cover.Voyage=1 then                  
    case                  
    when acceptance.cpct<>0 then                  
		acceptance.cpct/100                  
    Else                  
		1                  
    End                  
   Else                  
    case                  
    When Acceptance.SDate<>Acceptance.PDate or Acceptance.NoRefundF=6 then                  
		case                  
		when day(acceptance.pdate)=day(rcalc.edate) and day(rcalc.sdate)=day(rcalc.edate) and Cover.PPeriod<>1 and datediff(month,rcalc.sdate,rcalc.edate)<>0 then             
		convert(float,DateDiff(month, acceptance.pdate, rcalc.edate))/convert(float,datediff(month,rcalc.sdate,rcalc.edate))                  
		Else                  
		convert(float,DateDiff(day, acceptance.pdate,rcalc.edate))/convert(float,datediff(day,rcalc.sdate,rcalc.edate))                  
		End                  
    Else                  
    -- Endorsement Period                  
		1                  
    End                  
   End                  
  End                  
  * (Case When pAcceptance.Qty=0 Then 1 else pAcceptance.Qty end)                  
  * (Case When PCALC.DESCRIPTION='Minimum Premium' Then RCALC.GROSS else RCALC.OGROSS*PCALC.GROSS/PCALC.OGROSS END+RCalc.Reinstatement)*(case When Pcalc.TSI=0 then 1 else PCalc.Ourshare/PCalc.TSI end)
  * (Case When Acceptance.AType='C' and Acceptance.EMethod<>'A' and RCover.CPRefund<>0 Then RCover.CPRefund/100 else 1 end) as Premium      
  from @Acceptance Acceptance inner join Acceptance pAcceptance on (pAcceptance.ANO=Acceptance.pANO) inner Join Cover on (Cover.CNO=pAcceptance.CNO)                  
  inner join PCalc on (PCalc.ANO=pAcceptance.ANO) inner join RCalc on (RCalc.ANO=PCalc.ANO and RCalc.Currency=PCalc.Currency)                  
  Left Join RCover on (RCover.ANO=Acceptance.ANO and RCover.Code=RCalc.Code and RCover.SDate=RCalc.SDate)                  
  Where Acceptance.ANO=@P_ANO and Acceptance.AType<>'A' and Not (Acceptance.AType='C' and Acceptance.EMethod='A') and pAcceptance.AType not in ('A','C')                  
  and PCalc.Gross<>0                    
                                                    
  Union All                  
        
  select Acceptance.ANO, RCalc.Currency, @P_ANO as CANO, RCalc.Code, cast(datediff(Month,Acceptance.SDate, RCalc.SDate) as integer) / 12 + 1 as PolicyYear,      
  Acceptance.NoRefundF,       
  Case When Upper(PCALC.DESCRIPTION) in ('MINIMUM PREMIUM','POLICY MINIMUM PREMIUM') Then 1 else 0 end as MinimumPremiumF,                                       
  (Case When PCALC.DESCRIPTION='Minimum Premium' Then RCALC.GROSS else RCALC.OGROSS*PCALC.GROSS/PCALC.OGROSS END+RCalc.Reinstatement)*coalesce(sISource.Share/100,(case When Pcalc.TSI=0 then 1 else PCalc.Ourshare/PCalc.TSI end)) as Premium      
  From RCALC Left Join Acceptance sAcceptance on (sAcceptance.ANO=RCalc.SANO) Left Join ISource sISource on (sISource.CNO=sAcceptance.CNO), PCALC, @Acceptance acceptance      
  Where Acceptance.ANO=@P_ANO and RCalc.ANO=Acceptance.ANO and PCalc.ANO=RCalc.ANO and PCalc.Currency=RCalc.Currency and Acceptance.AType='A'                  
  and PCalc.Gross<>0   
        
) T                  
                                      
Group By ANO, Currency, CANO, Code, PolicyYear, NoRefundF  

RETURN

END

GO

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PREMIUM_CALCULATION]') AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) ) 
begin
DROP FUNCTION PREMIUM_CALCULATION 
end
GO

CREATE FUNCTION PREMIUM_CALCULATION(@P_ANO int)                  
RETURNS TABLE  AS                  
RETURN (                  
Select ANO, Currency,   
sum(Premium-Case When NoRefundF=7 Then Premium*dbo.Premium_Commission(CANO,Code,PolicyYear,MinimumPremiumF)/100 else 0 end) as Premium,           
sum(Case When NoRefundF=7 Then 0 else Premium*dbo.Premium_Commission(CANO,Code,PolicyYear,MinimumPremiumF)/100 end) as Commission,           
sum(Premium*dbo.Premium_Discount(CANO,Code,PolicyYear)/100) as Discount,           
sum(Case When NoRefundF=7 Then 0 else Premium*dbo.Premium_Commission_Vat(CANO,Code,PolicyYear,MinimumPremiumF)/100 end) as Vat,           
sum(Case When NoRefundF=7 Then 0 else Premium*dbo.Premium_Commission_Tax(CANO,Code,PolicyYear,MinimumPremiumF)/100 end) as Tax,      
0 as FeeDuty      
from PREMIUM_CALCULATION_BASE(@P_ANO) T                                              
Group By ANO, Currency          
          
Union All                  
                                 
select A1.ANO, AccAss.Currency_OC as Currency,                  
sum(Case When AccAss.Code in ('P','U') then (Case When A1.AType='A' and AccAss.AdjMethod='OVERLIMIT' then -AccAss.CAmount*(Case When A1.CPCT<>0 Then A1.CPCT/100 else 1 end)/(Case When AccAss.PProrata<>0 Then AccAss.PProrata else 1 end) else -AccAss.Amount_OC end)*(Case When AccAss.Type='DI' then 100/(100-coalesce(Coinsurance.MShare,0)) else 1 end) else 0 end) as Premium,                  
sum(Case When AccAss.Code='C' then (Case When A1.AType='A' and AccAss.AdjMethod='OVERLIMIT' then AccAss.CAmount*(Case When A1.CPCT<>0 Then A1.CPCT/100 else 1 end)/(Case When AccAss.PProrata<>0 Then AccAss.PProrata else 1 end) else AccAss.Amount_OC end)*(Case When AccAss.Type='DI' then 100/(100-coalesce(Coinsurance.MShare,0)) else 1 end) else 0 end) as Commission,                  
sum(Case When AccAss.Code='O' then (Case When A1.AType='A' and AccAss.AdjMethod='OVERLIMIT' then AccAss.CAmount*(Case When A1.CPCT<>0 Then A1.CPCT/100 else 1 end)/(Case When AccAss.PProrata<>0 Then AccAss.PProrata else 1 end) else AccAss.Amount_OC end)*(Case When AccAss.Type='DI' then 100/(100-coalesce(Coinsurance.MShare,0)) else 1 end) else 0 end) as Discount,                  
sum((Case When A1.AType='A' and AccAss.AdjMethod='OVERLIMIT' then AccAss.CAmount*(Case When A1.CPCT<>0 Then A1.CPCT/100 else 1 end)/(Case When AccAss.PProrata<>0 Then AccAss.PProrata else 1 end) else AccAss.Amount_OC end)*(Case When AccAss.Type='DI' then 100/(100-coalesce(Coinsurance.MShare,0)) else 1 end)*(Case When Profile.VatF=1 Then MParam.Vat/100 else 0 end)) as Vat,                  
sum((Case When A1.AType='A' and AccAss.AdjMethod='OVERLIMIT' then AccAss.CAmount*(Case When A1.CPCT<>0 Then A1.CPCT/100 else 1 end)/(Case When AccAss.PProrata<>0 Then AccAss.PProrata else 1 end) else AccAss.Amount_OC end)*(Case When AccAss.Type='DI' then 100/(100-coalesce(Coinsurance.MShare,0)) else 1 end)*(Case When Profile.TaxF=1 Then (Case When Profile.TaxType='PASAL21' Then MParam.Pasal21/100*(100-MParam.TaxDiscount)/100 When Profile.TaxType='PASAL23' Then MParam.Pasal23/100 When Profile.TaxType='PASAL26' Then MParam.Pasal26/100 else 0 end)*(Case When Profile.TaxPCT=0 Then 1 else Profile.TaxPCT/100 end) else 0 end)) as Tax,      
sum(Case When AccAss.Code in ('F','D') then -AccAss.Amount_OC else 0 end) as FeeDuty      
from Acceptance A1       
inner join Acceptance A2 on (A2.OANO=A1.OANO)    
inner join AccAss on (AccAss.ANO=A2.ANO)      
inner join Profile on (Profile.ID=AccAss.ID)      
inner join MParam on (MParam.Type=Accass.Type)      
Left Join (Select CNO, sum(Share) as MShare from Coinsurance Where PCollectionF=0 Group by CNO) Coinsurance on (Coinsurance.CNO=A2.CNO)      
Left join Acceptance pA1 on (pA1.ANO=A2.PANO)      
Where A1.ANO=@P_ANO     
and (                  
(A2.ANO<=A1.PANO AND A2.ANO<@P_ANO AND A1.PDate<=A2.PDate and A1.PPDate>=A2.PPDate and A1.AType='A' and (A2.AType<>'A' and coalesce(pA1.AType,'')<>'A') and AccAss.AdjustableF=1 and (AccAss.AdjMethod<>'OVERLIMIT' or AccAss.CAmount<>0) and NOT EXISTS (Select PANO from Acceptance A3 Where A3.PANO=A2.ANO and A3.AStatus<>'C' and A3.AType='A' and A3.ANO<>@P_ANO))                  
or (A2.ANO<@P_ANO AND A1.AType='C' and A1.EMethod='A' and A2.PDate>=A1.PDate and (coalesce(pA1.pDate,A2.PDate)>=A1.PDate or A2.ATYPE='A' or (coalesce(pA1.pDate,A2.PDate)<A1.PDate and AccAss.CAmount<>0)))                  
or (A2.ANO=A1.PANO and A2.AType='A' and A1.AType='C'))                  
and ((AccAss.Type in ('DI','IC','IR') and AccAss.Code='P') or (AccAss.Type in ('DI','IC') and AccAss.Code='U') Or (AccAss.Type in ('BB','BA','BO') and AccAss.Code='C') or (AccAss.Type in ('DI','IC','IR') and AccAss.Code='O') or (A1.AType='C' and A1.EMethod='A' and AccAss.Type in ('DI') and AccAss.Code in ('F','D')))                  
Group By A1.ANO, AccAss.Currency_OC                                                                             
)           
        

GO

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[fn_RateCon]') AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) ) 
begin
DROP FUNCTION fn_RateCon 
end
GO

CREATE FUNCTION fn_RateCon(@P_ANO as int,@P_Code as varchar(20),@P_TSI as Float=0)       
RETURNS Table       
AS RETURN (       
Select Top 1 *
From
(
	SELECT Top 1 cast(0 as Bit) as ProgressiveF, RateTab.Code, Acceptance.Sdate, RateCon.AllowedF, RateCon.MinRate, RateCon.MaxRate, RateCon.PML, RateCon.TExcess, RateTab.RateLoadingF,       
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
	 RateCon.Code=RateTab.Code And ((Case When @P_TSI=0 Then 1 Else @P_TSI End)>=RateCon.MinTSI or RateCon.MinTSI=0) and ((Case When @P_TSI=0 Then 1 Else @P_TSI End)<=RateCon.MaxTSI or RateCon.MaxTSI=0)     
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

	SELECT 
	cast(1 as Bit) as ProgressiveF,
	RateTab.Code, 
	Max(Acceptance.Sdate) as Sdate,
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
	 RateCon.Code=RateTab.Code 
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

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[DISPLAY_GROSS_FACULTATIVE_CALCULATION]') AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) ) 
begin
DROP FUNCTION DISPLAY_GROSS_FACULTATIVE_CALCULATION 
end
GO


CREATE FUNCTION DISPLAY_GROSS_FACULTATIVE_CALCULATION(@P_ANO int, @P_FID Varchar(20))      
RETURNS @PCALC TABLE (ANO Int, Currency varchar(10), Code varchar(10), FCode varchar(10), SDate SmallDateTime, EDate SmallDateTime, Gross Float, Calculation varchar(1024))
AS
BEGIN

DECLARE @ACCEPTANCE TABLE (ANO Int, CNO Int, PANO Int, ATYPE varchar(1), EMethod varchar(1))
INSERT INTO @ACCEPTANCE
SELECT ANO, CNO, PANO, ATYPE, EMethod FROM ACCEPTANCE WHERE ANO=@P_ANO

DECLARE @RARRDET TABLE (ANO Int, FID varchar(20), Limit Float, PCalc varchar(1), SDate SmallDateTime, EDate SmallDateTime, Share Float, FLPCT Float, OnGrossAfterCommF Bit, FullCoverF Bit, NoRefundF Bit)
INSERT INTO @RARRDET
Select ANO, FID, Limit, PCalc, SDate, EDate, Share, FLPCT, OnGrossAfterCommF, FullCoverF, NOREFUNDF FROM RarrDet Where ANO=@P_ANO and FID=@P_FID

Declare @P_FullcoverF Bit
Declare @P_PANO Int

Select @P_PANO=PANO from @ACCEPTANCE 
Select @P_FullcoverF=FullCoverF from @RArrDet


if @P_FullcoverF=1
Begin
	--1
	Insert into @PCALC
	Select ICalc.ANO, ICalc.Currency, ICalc.Code, ICalc.FCode, ICalc.SDate, ICalc.EDate,   
	Gross=    
	Case     
	 When Max(ICalc.NetRate)=0 then    
	  case When Max(ICalc.FLPCT)=0 Then    
		Case When Max(ICalc.Unit)='F' Then
			sum(ICalc.PCTShare/100*ICalc.Gross*(Case When ICalc.OnGrossAfterCommF=1 Then (100-dbo.Premium_Commission(ICalc.ANO, ICalc.Code,0,0))/100 else 1 end)/Icalc.PProrata)*max(ICalc.FacProrata)
		Else
			sum(ICalc.PCTShare/100*ICalc.Gross*(Case When ICalc.OnGrossAfterCommF=1 Then (100-dbo.Premium_Commission(ICalc.ANO, ICalc.Code,0,0))/100 else 1 end)/Icalc.PProrata)*max(ICalc.FacProrata)*max(ICalc.Share)/100    
		End
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
		Case When Max(ICalc.Unit)='F' Then
			   convert(varchar(25), cast(sum(ICalc.PCTShare/100*ICalc.Gross*(Case When ICalc.OnGrossAfterCommF=1 Then (100-dbo.Premium_Commission(ICalc.ANO, ICalc.Code,0,0))/100 else 1 end)/ICalc.PProrata) as Money),1) + Case When max(ICalc.FacProrata_Calculation)='' or Max(ICalc.FacProrata)=1 Then '' Else ' x ' + max(ICalc.FacProrata_Calculation) End
		Else
			convert(varchar(25), cast(sum(ICalc.PCTShare/100*ICalc.Gross*(Case When ICalc.OnGrossAfterCommF=1 Then (100-dbo.Premium_Commission(ICalc.ANO, ICalc.Code,0,0))/100 else 1 end)/ICalc.PProrata) as Money),1) + Case When max(ICalc.FacProrata_Calculation)='' or Max(ICalc.FacProrata)=1 Then '' Else ' x ' + max(ICalc.FacProrata_Calculation) End + ' x '+convert(varchar(25), Max(ICalc.Share),3)+'%'    
		End
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
	from ICalc, PCalc, (Select ANO, INO, Currency, SDate, EDate, Count(Distinct Code) as RiskNum from ICalc Where Gross<>0 and ANO=@P_ANO Group By ANO, INO, Currency, SDate, EDate) I, DISPLAY_FACULTATIVE_PRORATA_CALCULATION(@P_ANO, @P_FID) D, FPart, @RARRDET RArrDet, @Acceptance Acceptance, Cover    
	Where Acceptance.ANO=@P_ANO and Cover.CNO=Acceptance.CNO and ICalc.ANO=Acceptance.ANO and ICalc.Rate<>0 and PCalc.ANO=ICalc.ANO and PCalc.Currency=ICalc.Currency    
	and I.ANO=ICalc.ANO and I.INO=ICalc.INO and I.Currency=ICalc.Currency and I.SDate=ICalc.SDate and I.EDate=ICalc.EDate        
	and D.ANO=ICalc.ANO and D.Currency=ICalc.Currency and D.Code=ICalc.Code and D.SDate=ICalc.Sdate and D.EDate=ICalc.EDate and D.TOR=ICalc.TOR    
	and RArrDet.FullCoverF=1 and RArrDet.ANO=D.ANO and RArrDet.FID=@P_FID and FPart.ANO=RArrDet.ANO and FPart.FID=RArrdet.FID    
	and RArrDet.NoRefundF=0
	Group By ICalc.ANO, ICalc.INO, ICalc.Currency, ICalc.Code, ICalc.SDate, ICalc.EDate, ICalc.PCTAdj    
	) ICalc    
	Group By ICalc.ANO, ICalc.Currency, ICalc.Code, ICalc.FCode, ICalc.SDate, ICalc.EDate, ICalc.SRate, ICalc.sProrata, ICalc.PCTadj      
End
    

--2 (Refund from Endorsement)    
If @P_PANO<>-1 AND @P_FullcoverF=1
BEGIN
	Insert into @PCALC
	Select ICalc.ANO, ICalc.Currency, ICalc.Code, ICalc.FCode, ICalc.SDate, ICalc.EDate,   
	Gross=-    
	Case     
	 When Max(ICalc.NetRate)=0 then    
	  case When Max(ICalc.FLPCT)=0 Then    
		Case When Max(ICalc.Unit)='F' Then
			sum(ICalc.PCTShare/100*ICalc.Gross*(Case When ICalc.OnGrossAfterCommF=1 Then (100-dbo.Premium_Commission(ICalc.ANO, ICalc.Code,0,0))/100 else 1 end)/Icalc.PProrata)*max(ICalc.FacProrata)
		Else
			sum(ICalc.PCTShare/100*ICalc.Gross*(Case When ICalc.OnGrossAfterCommF=1 Then (100-dbo.Premium_Commission(ICalc.ANO, ICalc.Code,0,0))/100 else 1 end)/Icalc.PProrata)*max(ICalc.FacProrata)*max(ICalc.Share)/100    
		End
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
		Case When Max(ICalc.Unit)='F' Then
			'- ' + convert(varchar(25), cast(sum(ICalc.PCTShare/100*ICalc.Gross*(Case When ICalc.OnGrossAfterCommF=1 Then (100-dbo.Premium_Commission(ICalc.ANO, ICalc.Code,0,0))/100 else 1 end)/ICalc.PProrata) as Money),1) + Case When max(ICalc.FacProrata_Calculation)='' or Max(ICalc.FacProrata)=1 Then '' Else ' x ' + max(ICalc.FacProrata_Calculation) End
		Else
			'- ' + convert(varchar(25), cast(sum(ICalc.PCTShare/100*ICalc.Gross*(Case When ICalc.OnGrossAfterCommF=1 Then (100-dbo.Premium_Commission(ICalc.ANO, ICalc.Code,0,0))/100 else 1 end)/ICalc.PProrata) as Money),1) + Case When max(ICalc.FacProrata_Calculation)='' or Max(ICalc.FacProrata)=1 Then '' Else ' x ' + max(ICalc.FacProrata_Calculation) End + ' x '+convert(varchar(25), Max(ICalc.Share),3)+'%'    
		End
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
	from ICalc, PCalc, (Select I.ANO, I.INO, I.Currency, I.SDate, I.EDate, Count(Distinct I.Code) as RiskNum from ICalc I, Acceptance A Where I.Gross<>0 and I.ANO=A.PANO and A.ANO=@P_ANO Group By I.ANO, I.INO, I.Currency, I.SDate, I.EDate) I, DISPLAY_FACULTATIVE_PRORATA_CALCULATION(@P_ANO, @P_FID) D, FPart, RArrDet, @RARRDET pRArrDet, @Acceptance pAcceptance, Acceptance, Cover    
	Where pAcceptance.ANO=@P_ANO and Acceptance.ANO=pAcceptance.PANO and Cover.CNO=Acceptance.CNO and ICalc.ANO=Acceptance.ANO and ICalc.Rate<>0 and PCalc.ANO=ICalc.ANO and PCalc.Currency=ICalc.Currency    
	and I.ANO=ICalc.ANO and I.INO=ICalc.INO and I.Currency=ICalc.Currency and I.SDate=ICalc.SDate and I.EDate=ICalc.EDate        
	and D.ANO=ICalc.ANO and D.Currency=ICalc.Currency and D.Code=ICalc.Code and D.SDate=ICalc.Sdate and D.EDate=ICalc.EDate and D.TOR=ICalc.TOR    
	and RArrDet.Status in ('A','R') and RArrDet.FullCoverF=1 and RArrDet.ANO=D.ANO and RArrDet.FID=@P_FID and FPart.ANO=RArrDet.ANO and FPart.FID=RArrdet.FID    
	and pRArrDet.ANO=pAcceptance.ANO and pRArrDet.FID=@P_FID and pRArrDet.NoRefundF=0
	Group By ICalc.ANO, ICalc.INO, ICalc.Currency, ICalc.Code, ICalc.SDate, ICalc.EDate, ICalc.PCTAdj    
	) ICalc    
	Group By ICalc.ANO, ICalc.Currency, ICalc.Code, ICalc.FCode, ICalc.SDate, ICalc.EDate, ICalc.SRate, ICalc.sProrata, ICalc.PCTadj                  
End

--3 Detail    
IF @P_FullcoverF=0
BEGIN
	Insert into @PCALC
	Select ICalc.ANO, ICalc.Currency, ICalc.Code, ICalc.FCode, ICalc.SDate, ICalc.EDate,   
	Gross=    
	Case     
	 When Max(ICalc.NetRate)=0 then    
	  case When Max(ICalc.FLPCT)=0 Then    
		Case When Max(ICalc.Unit)='F' Then
			sum(ICalc.PCTShare/100*ICalc.Gross*(Case When ICalc.OnGrossAfterCommF=1 Then (100-dbo.Premium_Commission(ICalc.ANO, ICalc.Code,0,0))/100 else 1 end)/Icalc.PProrata)*max(ICalc.FacProrata)
		Else
			sum(ICalc.PCTShare/100*ICalc.Gross*(Case When ICalc.OnGrossAfterCommF=1 Then (100-dbo.Premium_Commission(ICalc.ANO, ICalc.Code,0,0))/100 else 1 end)/Icalc.PProrata)*max(ICalc.FacProrata)*max(ICalc.Share)/100    
		End
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
		Case When Max(ICalc.Unit)='F' Then
			convert(varchar(25), cast(sum(ICalc.PCTShare/100*ICalc.Gross*(Case When ICalc.OnGrossAfterCommF=1 Then (100-dbo.Premium_Commission(ICalc.ANO, ICalc.Code,0,0))/100 else 1 end)/ICalc.PProrata) as Money),1) + Case When max(ICalc.FacProrata_Calculation)='' or Max(ICalc.FacProrata)=1 Then '' Else ' x ' + max(ICalc.FacProrata_Calculation) End
		Else
			convert(varchar(25), cast(sum(ICalc.PCTShare/100*ICalc.Gross*(Case When ICalc.OnGrossAfterCommF=1 Then (100-dbo.Premium_Commission(ICalc.ANO, ICalc.Code,0,0))/100 else 1 end)/ICalc.PProrata) as Money),1) + Case When max(ICalc.FacProrata_Calculation)='' or Max(ICalc.FacProrata)=1 Then '' Else ' x ' + max(ICalc.FacProrata_Calculation) End + ' x '+convert(varchar(25), Max(ICalc.Share),3)+'%'    
		End
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
	from ICalc, PCalc, DISPLAY_FACULTATIVE_PRORATA_CALCULATION(@P_ANO, @P_FID) D, FPartDet FPart, RateCov, @RARRDET RArrDet, @Acceptance Acceptance, Cover    
	Where Acceptance.ANO=@P_ANO and Cover.CNO=Acceptance.CNO and ICalc.ANO=Acceptance.ANO and ICalc.Rate<>0 and PCalc.ANO=ICalc.ANO and PCalc.Currency=ICalc.Currency    
	and D.ANO=ICalc.ANO and D.Currency=ICalc.Currency and D.SDate=ICalc.Sdate and D.EDate=ICalc.EDate and D.TOR=ICalc.TOR    
	and RArrDet.FullCoverF=0 and RArrDet.ANO=D.ANO 
	and RArrDet.FID=@P_FID and FPart.ANO=RArrDet.ANO and FPart.FID=RArrdet.FID and RateCov.Code=FPart.Code and RateCov.TOR=ICalc.TOR
	and RArrDet.NoRefundF=0
	Group By ICalc.ANO, ICalc.INO, ICalc.Currency, ICalc.Code, ICalc.SDate, ICalc.EDate, ICalc.PCTAdj 
	) ICalc    
	Group By ICalc.ANO, ICalc.Currency, ICalc.Code, ICalc.FCode, ICalc.SDate, ICalc.EDate, ICalc.SRate, ICalc.sProrata, ICalc.PCTadj      
END

--4 Refund/Endorsement Detail    
IF @P_PANO<>-1 AND @P_FullcoverF=0    
BEGIN
	Insert into @PCALC
	Select ICalc.ANO, ICalc.Currency, ICalc.Code, ICalc.FCode, ICalc.SDate, ICalc.EDate,  
	Gross=-    
	Case     
	 When Max(ICalc.NetRate)=0 then    
	  case When Max(ICalc.FLPCT)=0 Then    
		Case When Max(ICalc.Unit)='F' Then
			sum(ICalc.PCTShare/100*ICalc.Gross*(Case When ICalc.OnGrossAfterCommF=1 Then (100-dbo.Premium_Commission(ICalc.ANO, ICalc.Code,0,0))/100 else 1 end)/Icalc.PProrata)*max(ICalc.FacProrata)
		Else
			sum(ICalc.PCTShare/100*ICalc.Gross*(Case When ICalc.OnGrossAfterCommF=1 Then (100-dbo.Premium_Commission(ICalc.ANO, ICalc.Code,0,0))/100 else 1 end)/Icalc.PProrata)*max(ICalc.FacProrata)*max(ICalc.Share)/100    
		End
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
		Case When Max(ICalc.Unit)='F' Then
			'- ' + convert(varchar(25), cast(sum(ICalc.PCTShare/100*ICalc.Gross*(Case When ICalc.OnGrossAfterCommF=1 Then (100-dbo.Premium_Commission(ICalc.ANO, ICalc.Code,0,0))/100 else 1 end)/ICalc.PProrata) as Money),1) + Case When max(ICalc.FacProrata_Calculation)='' or Max(ICalc.FacProrata)=1 Then '' Else ' x ' + max(ICalc.FacProrata_Calculation) End
		Else
			'- ' + convert(varchar(25), cast(sum(ICalc.PCTShare/100*ICalc.Gross*(Case When ICalc.OnGrossAfterCommF=1 Then (100-dbo.Premium_Commission(ICalc.ANO, ICalc.Code,0,0))/100 else 1 end)/ICalc.PProrata) as Money),1) + Case When max(ICalc.FacProrata_Calculation)='' or Max(ICalc.FacProrata)=1 Then '' Else ' x ' + max(ICalc.FacProrata_Calculation) End + ' x '+convert(varchar(25), Max(ICalc.Share),3)+'%'    
		End
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
	from ICalc, PCalc, DISPLAY_FACULTATIVE_PRORATA_CALCULATION(@P_ANO, @P_FID) D, FPartDet FPart, RateCov, RArrDet, @RARRDET pRArrDet, @Acceptance pAcceptance, Acceptance, Cover    
	Where pAcceptance.ANO=@P_ANO and Acceptance.ANO=pAcceptance.PANO and Cover.CNO=Acceptance.CNO and ICalc.ANO=Acceptance.ANO and ICalc.Rate<>0 and PCalc.ANO=ICalc.ANO and PCalc.Currency=ICalc.Currency    
	and D.ANO=ICalc.ANO and D.Currency=ICalc.Currency and D.SDate=ICalc.Sdate and D.EDate=ICalc.EDate and D.TOR=ICalc.TOR    
	and RArrDet.Status in ('A','R') and RArrDet.FullCoverF=0 and RArrDet.ANO=D.ANO 
	and RArrDet.FID=@P_FID and FPart.ANO=RArrDet.ANO and FPart.FID=RArrdet.FID and RateCov.Code=FPart.Code and RateCov.TOR=ICalc.TOR
	and pRArrDet.ANO=pAcceptance.ANO and pRArrDet.FID=@P_FID and pRArrDet.NoRefundF=0
	Group By ICalc.ANO, ICalc.INO, ICalc.Currency, ICalc.Code, ICalc.SDate, ICalc.EDate, ICalc.PCTAdj 
	) ICalc
	Group By ICalc.ANO, ICalc.Currency, ICalc.Code, ICalc.FCode, ICalc.SDate, ICalc.EDate, ICalc.SRate, ICalc.sProrata, ICalc.PCTadj        
END
    
RETURN
END

GO

IF EXISTS ( SELECT * FROM   sysobjects WHERE  id = object_id(N'[dbo].[QCLACC_3]') and OBJECTPROPERTY(id, N'IsProcedure') = 1 )
begin
DROP Procedure QCLACC_3
end
GO
CREATE PROCEDURE QCLACC_3(@P_POLICYNO AS VARCHAR(255), @P_CERTIFICATENO VARCHAR(255), @P_REFNO varchar(50)='', @P_TOC varchar(10)='')     
AS     
SELECT TOP 10 ACCEPTANCE.ANO, ACCEPTANCE.POLICYNO, ACCEPTANCE.CERTIFICATENO, ACCEPTANCE.AID, COVER.INSURED, COVER.ISTYPE, ACCEPTANCE.TOC, ACCEPTANCE.SDATE, ACCEPTANCE.EDATE, Cover.PHolder, ACCEPTANCE.BRANCH, ACCEPTANCE.ANAME, PROFILE.RESTRICTEDF, PROFILE.NAME, ACCEPTANCE.PDATE, ACCEPTANCE.PPDATE, ACCEPTANCE.NCDATE,  ACCEPTANCE.EXTPERIOD,     
Case When GenDTab.Description is not null then ACCEPTANCE.ValueDesc else '' end as Description,     
coalesce(InParty.ID, coalesce(ISource.ID, Acceptance.AID)) as Payment,
coalesce(IProfile.Name, coalesce(PProfile.Name, Profile.Name)) as Payment_Name
FROM ACCEPTANCE WITH (INDEX(I_Acceptance_PolicyNo_CertificateNo))  
Left Join GenDTab On (GenDTab.FLDID=ACCEPTANCE.FLDID AND GenDTab.ValueID=ACCEPTANCE.ValueID)  
Inner Join COVER on (Cover.CNO=Acceptance.CNO)  
Left Join ISource On (ISource.CNO=Cover.CNO)   
Left Join InParty on (InParty.CNO=Cover.CNO and InParty.IType in ('MORTGAGE'))
Left Join Profile PProfile On (PProfile.ID=ISource.ID)  
Left Join Profile IProfile On (IProfile.ID=InParty.ID)  
Left Join Profile on (Profile.ID=Acceptance.AID)  
WHERE ACCEPTANCE.ATYPE Not In ('A','C') AND ACCEPTANCE.AStatus not in ('W','T') and COVER.CStatus not in ('R','P','C')     
AND ACCEPTANCE.PDATE<ACCEPTANCE.PPDATE AND ACCEPTANCE.ANO<>ACCEPTANCE.LANO   
AND ACCEPTANCE.POLICYNO<>'' AND ACCEPTANCE.POLICYNO LIKE @P_POLICYNO AND ACCEPTANCE.CERTIFICATENO LIKE @P_CERTIFICATENO     
AND ACCEPTANCE.TOC LIKE @P_TOC+'%' AND ACCEPTANCE.REFNO LIKE @P_REFNO+'%'  
ORDER BY ACCEPTANCE.POLICYNO, ACCEPTANCE.CERTIFICATENO, ACCEPTANCE.REFNO, ACCEPTANCE.ANO DESC     

GO

IF EXISTS ( SELECT * FROM   sysobjects WHERE  id = object_id(N'[dbo].[QCHECKDECLAREDVALUE]') and OBJECTPROPERTY(id, N'IsProcedure') = 1 )
begin
DROP Procedure QCHECKDECLAREDVALUE
end
GO
CREATE PROCEDURE QCHECKDECLAREDVALUE (@PCNO AS INTEGER)   
AS
Select SUM(CLLOSS.Estimate/Rate) as Estimate, SUM(CLLOSS.Amount/Rate) as Amount, 
MAX(Case When ICOVER.AMOUNT<>0 and ICOVER.AMOUNT_AOE<>0 THEN CLLOSS.DECLARED*ICOVER.AMOUNT_AOE/ICOVER.AMOUNT ELSE CLLOSS.DECLARED END) as DECLARED
from CLLOSS 
INNER JOIN CLAIM ON (CLAIM.CNO=CLLOSS.CNO)
INNER JOIN ACCEPTANCE ON (ACCEPTANCE.ANO=CLAIM.ANO)
INNER JOIN NOCTAB ON (NOCTAB.NOC=CLLOSS.NOC) 
INNER JOIN ICOVER ON (ICOVER.INO=CLLOSS.INO)
LEFT JOIN ICOVERNOC ON ((ICoverNOC.PCT<>0 or ICoverNOC.Amount<>0) 
and ICOVERNOC.INO=CLLOSS.INO and ICOVERNOC.NOC=CLLOSS.NOC
AND ((ICOVERNOC.SDATE<=CLAIM.LossDate AND ACCEPTANCE.ExclusiveF=1) or ((ICOVERNOC.SDATE<CLAIM.LossDate or (ICOVERNOC.SDATE=CLAIM.LossDate AND ACCEPTANCE.STIME<=CLAIM.LossTime)) AND ACCEPTANCE.ExclusiveF=0))                     
AND ((dbo.fn_Get_ExtPeriodDate(ACCEPTANCE.ExtPeriod, ACCEPTANCE.ExtPeriodInDaysF, ICOVERNOC.EDATE)>CLAIM.LossDate AND ACCEPTANCE.ExclusiveF=1) or ((dbo.fn_Get_ExtPeriodDate(ACCEPTANCE.ExtPeriod, ACCEPTANCE.ExtPeriodInDaysF, ICOVERNOC.EDATE)>CLAIM.LossDate or (dbo.fn_Get_ExtPeriodDate(ACCEPTANCE.ExtPeriod, ACCEPTANCE.ExtPeriodInDaysF, ICOVERNOC.EDATE)=CLAIM.LossDate AND ACCEPTANCE.ETIME>CLAIM.LossTime)) AND ACCEPTANCE.ExclusiveF=0))                              
) 

Where CLLOSS.Declared>1 and (NOCTAB.SubLimitF=0 or coalesce(ICoverNOC.NOC,'')<>'') and CLLoss.CNO=@PCNO
Group by CLLOSS.CNO, CLLOSS.INO, coalesce(ICoverNOC.NOC,'') 
having SUM(CLLOSS.Estimate/Rate)>MAX(Case When ICOVER.AMOUNT<>0 and ICOVER.AMOUNT_AOE<>0 THEN CLLOSS.DECLARED*ICOVER.AMOUNT_AOE/ICOVER.AMOUNT ELSE CLLOSS.DECLARED END) or SUM(CLLOSS.Amount/Rate)>MAX(Case When ICOVER.AMOUNT<>0 and ICOVER.AMOUNT_AOE<>0 THEN CLLOSS.DECLARED*ICOVER.AMOUNT_AOE/ICOVER.AMOUNT ELSE CLLOSS.DECLARED END)


GO

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[DISPLAY_PRORATA_CALCULATION]') AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) ) 
begin
DROP FUNCTION DISPLAY_PRORATA_CALCULATION 
end
GO
CREATE FUNCTION DISPLAY_PRORATA_CALCULATION(@P_ANO int)        
RETURNS TABLE  AS        
RETURN (        
select        
Distinct        
RCalc.ANO,        
RCalc.Code,        
RCalc.Currency,        
RCalc.SDate,        
RCalc.EDate,        
Prorata_Calculation=        
case        
When Acceptance.AType<>'N' then        

 case        
 when DateDiff(day, RCalc.Edate, acceptance.pdate)>=0 then ''
 when DateDiff(day, acceptance.pdate, RCalc.SDate)>0 then ''        
 Else        

  case        
  when acceptance.cpct<>0 or Cover.Voyage=1 then        
	case when acceptance.cpct<>0 and acceptance.cpct<>100 then convert(varchar(25),Cast(Acceptance.CPCT as float),3)+'%' else '' end        
  Else        
    case        
    when day(acceptance.pdate)=day(RCalc.edate) and day(RCalc.sdate)=day(RCalc.edate) and Cover.PPeriod<>1 and datediff(month,RCalc.sdate,RCalc.edate)<>0 then        
		Case When DateDiff(month, acceptance.pdate, RCalc.edate)<>datediff(month,RCalc.sdate,RCalc.edate) then        
		Case When Acceptance.EXCLUSIVEF=0 and Acceptance.STime<Acceptance.ETime and RCalc.EDate=Acceptance.EDate Then
			convert(varchar(25),DateDiff(month, acceptance.pdate, dateadd(day,1,RCalc.edate)))+'/'+convert(varchar(25),datediff(month,RCalc.sdate,dateadd(day,1,RCalc.edate)))        
		Else
			convert(varchar(25),DateDiff(month, acceptance.pdate, RCalc.edate))+'/'+convert(varchar(25),datediff(month,RCalc.sdate,RCalc.edate))        
		End
	Else        
		''        
	End        

    Else        
		Case When DateDiff(day, acceptance.pdate, RCalc.edate)<>datediff(day,RCalc.sdate,RCalc.edate) then        
		Case When Acceptance.EXCLUSIVEF=0 and Acceptance.STime<Acceptance.ETime and RCalc.EDate=Acceptance.EDate Then
			convert(varchar(25),DateDiff(day, acceptance.pdate, dateadd(day,1,RCalc.edate)))+'/'+convert(varchar(25),datediff(day,RCalc.sdate,dateadd(day,1,RCalc.edate)))        
		Else
			convert(varchar(25),DateDiff(day, acceptance.pdate, RCalc.edate))+'/'+convert(varchar(25),datediff(day,RCalc.sdate,RCalc.edate))        
		End
	  Else        
	   ''        
	  End        
          
		End        
  End        
 
  End         
Else        
 ''        
end,        
          
Prorata=        
case        
When Acceptance.AType<>'N' then        
 case        
 when DateDiff(day, RCalc.Edate, acceptance.pdate)>=0 then 0        
 when DateDiff(day, acceptance.pdate, RCalc.SDate)>0 then 1        
 Else        
  case        
  when acceptance.cpct<>0 or Cover.Voyage=1 then        
   case when acceptance.cpct<>0 and acceptance.cpct<>100 then Acceptance.CPCT/100 else 1 end        
  Else        
    case        
     when day(acceptance.pdate)=day(RCalc.edate) and day(RCalc.sdate)=day(RCalc.edate) and Cover.PPeriod<>1 and datediff(month,RCalc.sdate,RCalc.edate)<>0 then        
  Case When DateDiff(month, acceptance.pdate, RCalc.edate)<>datediff(month,RCalc.sdate,RCalc.edate) then        
		Case When Acceptance.EXCLUSIVEF=0 and Acceptance.STime<Acceptance.ETime and RCalc.EDate=Acceptance.EDate Then
			Cast(DateDiff(month, acceptance.pdate, dateadd(day,1,RCalc.edate)) as Float)/Cast(datediff(month,RCalc.sdate,dateadd(day,1,RCalc.edate)) as Float)        
		Else
			Cast(DateDiff(month, acceptance.pdate, RCalc.edate) as Float)/Cast(datediff(month,RCalc.sdate,RCalc.edate) as Float)        
		End
  Else        
1        
  End        
    Else        
  Case When DateDiff(day, acceptance.pdate, RCalc.edate)<>datediff(day,RCalc.sdate,RCalc.edate) then        
		Case When Acceptance.EXCLUSIVEF=0 and Acceptance.STime<Acceptance.ETime and RCalc.EDate=Acceptance.EDate Then
			Cast(DateDiff(Day, acceptance.pdate, dateadd(day,1,RCalc.edate)) as Float)/Cast(datediff(Day,RCalc.sdate,dateadd(day,1,RCalc.edate)) as Float)        
		Else
			Cast(DateDiff(Day, acceptance.pdate, RCalc.edate) as Float)/Cast(datediff(Day,RCalc.sdate,RCalc.edate) as Float)
		End
  Else        
1  
  End        
          
    End        
  End        
 End        
Else        
1        
End        
          
                      
From acceptance        
inner Join Cover on (Cover.CNO=Acceptance.CNO)        
inner join PCalc on (PCalc.ANO=Acceptance.ANO)        
inner join RCalc on (RCalc.ANO=PCalc.ANO and RCalc.Currency=PCalc.Currency)        
inner Join RCover on (RCover.ANO=Acceptance.ANO and RCover.Code=RCalc.Code and RCover.SDate=RCalc.SDate)        
Where Acceptance.AType not in ('A','C')        
and (Acceptance.AType='N' or (Acceptance.NoRefundF not in (2,4) and RCover.NoRefundF=0 and (Acceptance.NoRefundF in (0,3,5,6) or (DateDiff(day, acceptance.pdate, RCalc.SDate) > 0))))
and Acceptance.ANO=@P_ANO        
          
Union All        
          
select        
Distinct        
RCalc.ANO,        
RCalc.Code,        
RCalc.Currency,        
RCalc.SDate,        
RCalc.EDate,        
Prorata_Calculation=        
case        
when DateDiff(day, rcalc.Edate, acceptance.pdate)>=0 and acceptance.pdate between pacceptance.sdate and pacceptance.edate then ''        
when DateDiff(day, acceptance.pdate, rcalc.SDate)>0 and acceptance.pdate between pacceptance.sdate and pacceptance.edate then ''        
Else        
  case        
  when acceptance.cpct<>0 or Cover.Voyage=1 then        
    case when acceptance.cpct<>0 and acceptance.cpct<>100 then convert(varchar(25),Cast(Acceptance.CPCT as float),3)+'%' else '' end        Else        
    case        
  When Acceptance.SDate<>Acceptance.PDate or Acceptance.NoRefundF=6 then        
      case        
       when day(acceptance.pdate)=day(RCalc.edate) and day(RCalc.sdate)=day(RCalc.edate) and Cover.PPeriod<>1 and datediff(month,RCalc.sdate,RCalc.edate)<>0 then        
    Case When DateDiff(month, acceptance.pdate, RCalc.edate)<>datediff(month,RCalc.sdate,RCalc.edate) then        
		Case When pAcceptance.EXCLUSIVEF=0 and pAcceptance.STime<pAcceptance.ETime and RCalc.EDate=pAcceptance.EDate Then
			convert(varchar(25),DateDiff(month, acceptance.pdate, dateadd(day,1,RCalc.edate)))+'/'+convert(varchar(25),datediff(month,RCalc.sdate,dateadd(day,1,RCalc.edate)))        
		Else
			convert(varchar(25),DateDiff(month, acceptance.pdate, RCalc.edate))+'/'+convert(varchar(25),datediff(month,RCalc.sdate,RCalc.edate))        
		End
    Else        
     ''        
    End        
      Else        
    Case When DateDiff(day, acceptance.pdate, RCalc.edate)<>datediff(day,RCalc.sdate,RCalc.edate) then        
		Case When pAcceptance.EXCLUSIVEF=0 and pAcceptance.STime<pAcceptance.ETime and RCalc.EDate=pAcceptance.EDate Then
			convert(varchar(25),DateDiff(day, acceptance.pdate, dateadd(day,1,RCalc.edate)))+'/'+convert(varchar(25),datediff(day,RCalc.sdate,dateadd(day,1,RCalc.edate)))        
		Else
			convert(varchar(25),DateDiff(day, acceptance.pdate, RCalc.edate))+'/'+convert(varchar(25),datediff(day,RCalc.sdate,RCalc.edate))        
		End
    Else        
     ''        
    End        
            
      End        
    Else        
     -- Endorsement Period        
      ''        
    End        
  End        
end,        
Prorata=        
case        
when DateDiff(day, rcalc.Edate, acceptance.pdate)>=0 and acceptance.pdate between pacceptance.sdate and pacceptance.edate then 0        
when DateDiff(day, acceptance.pdate, rcalc.SDate)>0  and acceptance.pdate between pacceptance.sdate and pacceptance.edate then 1        
Else        
  case        
  when acceptance.cpct<>0 or Cover.Voyage=1 then        
    case when acceptance.cpct<>0 and acceptance.cpct<>100 then Acceptance.CPCT/100 else 1 end        
  Else        
    case        
  When Acceptance.SDate<>Acceptance.PDate or Acceptance.NoRefundF=6 then        
      case        
       when day(acceptance.pdate)=day(RCalc.edate) and day(RCalc.sdate)=day(RCalc.edate) and Cover.PPeriod<>1 and datediff(month,RCalc.sdate,RCalc.edate)<>0 then  
    Case When DateDiff(month, acceptance.pdate, RCalc.edate)<>datediff(month,RCalc.sdate,RCalc.edate) then        
		Case When pAcceptance.EXCLUSIVEF=0 and pAcceptance.STime<pAcceptance.ETime and RCalc.EDate=pAcceptance.EDate Then
			Cast(DateDiff(month, acceptance.pdate, dateadd(day,1,RCalc.edate)) as Float)/Cast(datediff(month,RCalc.sdate,dateadd(day,1,RCalc.edate)) as Float)        
		Else
			Cast(DateDiff(month, acceptance.pdate, RCalc.edate) as Float)/Cast(datediff(month,RCalc.sdate,RCalc.edate) as Float)        
		End
    Else        
 1        
    End        
      Else        
    Case When DateDiff(day, acceptance.pdate, RCalc.edate)<>datediff(day,RCalc.sdate,RCalc.edate) then        
		Case When pAcceptance.EXCLUSIVEF=0 and pAcceptance.STime<pAcceptance.ETime and RCalc.EDate=pAcceptance.EDate Then
			Cast(DateDiff(Day, acceptance.pdate, dateadd(day,1,RCalc.edate)) as Float)/Cast(datediff(Day,RCalc.sdate,dateadd(day,1,RCalc.edate)) as Float)        
		Else
			Cast(DateDiff(Day, acceptance.pdate, RCalc.edate) as Float)/Cast(datediff(Day,RCalc.sdate,RCalc.edate) as Float)        
		End
    Else        
 1        
    End        
            
      End        
    Else        
     -- Endorsement Period        
 1        
    End        
  End        
End        
          
From acceptance        
inner Join Cover on (Cover.CNO=Acceptance.CNO)        
inner join Acceptance pAcceptance on (pAcceptance.ANO=Acceptance.pANO)        
inner join PCalc on (PCalc.ANO=pAcceptance.ANO)        
inner join RCalc on (RCalc.ANO=PCalc.ANO and RCalc.Currency=PCalc.Currency)        
Left Join RCover on (RCover.ANO=Acceptance.ANO and RCover.Code=RCalc.Code and RCover.SDate=RCalc.SDate)        
Where Acceptance.AType<>'A' and Not (Acceptance.AType='C' and Acceptance.EMethod='A') and pAcceptance.AType not in ('A','C')        
and Acceptance.NoRefundF Not in (2,4) and coalesce(RCover.NoRefundF,0)=0
and (Acceptance.NoRefundF in (0,3,5,6) or (DateDiff(day, acceptance.pdate, rcalc.SDate) > 0 and acceptance.pdate between pacceptance.sdate and pacceptance.edate))      
and Acceptance.ANO=@P_ANO        
)        
       
GO

IF EXISTS ( SELECT * FROM   sysobjects WHERE  id = object_id(N'[dbo].[Treaty_Premium_Commission]') and OBJECTPROPERTY(id, N'IsProcedure') = 1 )
begin
DROP Procedure Treaty_Premium_Commission
end
GO
CREATE Procedure Treaty_Premium_Commission(@P_ANO integer,@P_Code varchar(10),@P_CCY varchar(10), @P_SDate smalldatetime, @P_EDate smalldatetime,@P_RID varchar(255),@P_AdjustableF Bit,@P_TSI Float=0)    
as    
Declare @Premium_Treaty_Discount as Float          
Declare @Premium_Discount as Float          
Declare @Premium_Commission as Float          
Declare @Premium_Fee as Float          
Declare @Premium_OutGo as Float          
Declare @P_TOC as varchar(10)  
Declare @P_AType as varchar(1)  
Declare @P_ONGROSSNet as int  
Declare @P_RateConF as Bit   
Declare @P_NETRATEDet as Float  
Declare @P_NOFYEARS as Int  
Declare @P_COMM as Float  
Declare @P_COMMN as Float  
Declare @P_RNO as int  
Declare @P_RType as varchar(10)  
Declare @P_OPFEE as Float  
Declare @P_OPFEEPCT as Float  
Declare @P_OANO as int   
Declare @P_PFactor as Float
Declare @P_ASDate as smalldatetime

Select   
@P_ASDate=A.SDate,  
@P_NOFYEARS=datediff(year,A.sdate, A.edate),   
@P_TOC=A.TOC,   
@P_AType=A.AType,   
@P_ONGROSSNET=R.ONGROSSNET,   
@P_RateConF=R3.RateConF,   
@P_NETRATEDet=R4.NETRATE,  
@P_COMM=R3.COMM,
@P_COMMN=R3.COMMN,
@P_RNO=R1.RNO,  
@P_RType=R1.RType,  
@P_OANO=A.OANO,  

@P_PFactor=Case When C.ISType='R' Then (100-I.UJrohCedant)/100*(100+I.UjrohReins)/100 else 1 end  
from Acceptance A, RarrHeader R, Cover C Left Join ISource I on (I.CNO=C.CNO), Reinsurance R1, ReClass R3 Left Join ReClassDet R4 ON (R4.RNO=R3.RNO AND R4.TOC=R3.TOC AND R4.CODE=@P_CODE)  
Where C.CNO=A.CNO and R.ANO=A.ANO and A.ANO=@P_ANO and R1.RID=@P_RID and R3.RNO=R1.RNO and R3.TOC=A.TOC  

Select @Premium_Treaty_Discount=dbo.Premium_Treaty_Discount(@P_ANO, @P_Code,cast(datediff(Month,@P_ASDate, @P_SDate) as integer) / 12 + 1)          
Select @Premium_Discount=dbo.premium_discount(@P_ANO, @P_Code, cast(datediff(Month,@P_ASDate, @P_SDate) as integer) / 12 + 1)  
Select @Premium_Commission=dbo.Premium_Commission(@P_ANO, @P_Code, cast(datediff(Month,@P_ASDate, @P_SDate) as integer) / 12 + 1,0)+dbo.Premium_Commission_Vat(@P_ANO, @P_Code, cast(datediff(Month,@P_ASDate, @P_SDate) as integer) / 12 + 1,0)  
Select @Premium_Fee=dbo.Premium_Fee(@P_ANO, cast(datediff(Month,@P_ASDate, @P_SDate) as integer) / 12 + 1)  
Select @Premium_outGo=@Premium_Discount+@Premium_Commission+@Premium_Fee  

Select 
@P_OPFEE=coalesce(Sum(
	Case When A1.Amount<>0 Then
		A1.Amount*100/coalesce(R.PCTSHARE-R.MSHARE,100) 
	Else
		A1.AmountPCT/100*PCalc.Gross
	End	
),0)
from 
Acceptance A2
INNER JOIN AccFD A1 on (A1.ANO=A2.ANO and A1.Currency=@P_CCY and A1.ContributionF=1)
INNER JOIN FDTAB on (FDTAB.FDID=A1.FDID)
INNER Join PCalc on (PCalc.ANO=A1.ANO and PCalc.Currency=A1.Currency)
INNER JOIN RARRHEADER R ON (R.ANO=A2.ANO)
Where @P_RType in ('Q','S1','S2','S3') and FDTAB.FDType='O' and A2.OANO=@P_OANO and A2.ANO<=@P_ANO  

--Select @P_COMM=CASE WHEN @P_COMMPOLICYF=1 and @P_COMM=0 and @P_COMMN=0 Then @Premium_Commission ELSE @P_COMM END  
 
Select              
sum(Case When OnMinPremiumF=0 Then (case When Gross_1>Gross_2 then Gross_1 else Gross_2 end) else (case When Gross_1<Gross_2 and Gross_1<>0 then Gross_1 else Gross_2 end) end) as Premium,           
sum(Case When OnMinPremiumF=0 Then (case When Gross_1>Gross_2 then Comm_1 else Comm_2 end) else (case When Gross_1<Gross_2 and Gross_1<>0 then Comm_1 else Comm_2 end) end) as Commission,         
sum(Case When OnMinPremiumF=0 Then (case When Gross_1>Gross_2 then Disc_1 else Disc_2 end) else (case When Gross_1<Gross_2 and Gross_1<>0 then Disc_1 else Disc_2 end) end) as Discount,  
sum(Case When OnMinPremiumF=0 Then (case When Gross_1>Gross_2 then Fee_1 else Fee_2 end) else (case When Gross_1<Gross_2 and Gross_1<>0 then Fee_1 else Fee_2 end) end) as Fee              
From          
(

select            
RPart.ID,  
Cast(RPart.OnMinPremiumF as integer) as OnMinPremiumF,              
coalesce(SUM((CASE WHEN RPart.PPCT<>0 THEN RPart.PPCT/100 ELSE (Case When @P_RateConF=1 and (RRateCon.Rate is not null or RateCon.Rate is not null) then 0 else 1 end) END * ICALC.GROSS*(PCALC.PGROSS*@P_PFactor)/PCALC.POGROSS*(Case When RPart.OnNetPremiumF=1 Then (100-@Premium_Treaty_Discount)/100 else 1 end)-(ICALC.GROSS*@P_OPFEE/PCALC.POGROSS))*(Case When (CASE WHEN @P_COMMN<>0 Then @P_COMMN ELSE RPART.COMMN END)=0 Then (CASE WHEN @P_COMM<>0 Then @P_COMM ELSE RPART.COMM END)/100 else (Case When RCover.NetRateF=1 or @P_ONGROSSNET=2 OR (@P_ONGROSSNET=0 AND (100-@Premium_OutGo)/100*(100-(CASE WHEN @P_COMMN<>0 Then @P_COMMN ELSE RPART.COMMN END))/100<(100-(CASE WHEN @P_COMM<>0 Then @P_COMM ELSE RPART.COMM END))/100) Then (100-@Premium_OutGo)/100*((CASE WHEN @P_COMMN<>0 Then @P_COMMN ELSE RPART.COMMN END))/100 else (CASE WHEN @P_COMM<>0 Then @P_COMM ELSE RPART.COMM END)/100 end) end)*PCalc.Rate),0) AS COMM_1,              
coalesce(SUM((Case When @P_RateConF=1 Then (Case When RRateCon.Rate is null then RateCon.Rate*(Case When RateCon.Loading<>0 then RateCon.Loading/100 else RCover.Loading end) else RRateCon.Rate/PCalc.RiskNum*(Case When RRateCon.Loading<>0 then RRateCon.Loading/100 else RCover.Loading end) end) Else coalesce(@P_NETRATEDet,RPart.NetRate/PCalc.RiskNum) end/100*(100-RCover.Discount)/100*ICALC.GROSS/PCALC.GROSS*ICALC.PRORATA *ICALC.TSI*(CASE WHEN RCOVER.PCALC='S' OR RCOVER.PCTLOSS=0 THEN 100 ELSE RCOVER.PCTLOSS END)/(CASE WHEN RCOVER.PCTLOSS=0 THEN 100 ELSE RCOVER.PCTLOSS END+RCOVER.PAddition)*ICALC.PCTADJ/100-(ICALC.GROSS*@P_OPFEE/PCALC.POGROSS))*(Case When (CASE WHEN @P_COMMN<>0 Then @P_COMMN ELSE RPART.COMMN END)=0 Then (CASE WHEN @P_COMM<>0 Then @P_COMM ELSE RPART.COMM END)/100 else (Case When RCover.NetRateF=1 or @P_ONGROSSNET=2 OR (@P_ONGROSSNET=0 AND (100-@Premium_OutGo)/100*(100-(CASE WHEN @P_COMMN<>0 Then @P_COMMN ELSE RPART.COMMN END))/100<(100-(CASE WHEN @P_COMM<>0 Then @P_COMM ELSE RPART.COMM END))/100) Then (100-@Premium_OutGo)/100*((CASE WHEN @P_COMMN<>0 Then @P_COMMN ELSE RPART.COMMN END))/100 else (CASE WHEN @P_COMM<>0 Then @P_COMM ELSE RPART.COMM END)/100 end) end)*PCalc.Rate),0) AS COMM_2,              

coalesce(SUM((CASE WHEN RPart.PPCT<>0 THEN RPart.PPCT/100 ELSE (Case When @P_RateConF=1 and (RRateCon.Rate is not null or RateCon.Rate is not null) then 0 else 1 end) END * ICALC.GROSS*(PCALC.PGROSS*@P_PFactor)/PCALC.POGROSS*(Case When RPart.OnNetPremiumF=1 Then (100-@Premium_Treaty_Discount)/100 else 1 end))*(Case When (CASE WHEN @P_COMMN<>0 Then @P_COMMN ELSE RPART.COMMN END)=0 Then 1 else (Case When RCover.NetRateF=1 or @P_ONGROSSNET=2 OR (@P_ONGROSSNET=0 AND (100-@Premium_OutGo)/100*(100-(CASE WHEN @P_COMMN<>0 Then @P_COMMN ELSE RPART.COMMN END))/100<(100-(CASE WHEN @P_COMM<>0 Then @P_COMM ELSE RPART.COMM END))/100) Then 1 else 1 end) end)*PCalc.Rate),0) AS GROSS_1,            
coalesce(SUM((Case When @P_RateConF=1 Then (Case When RRateCon.Rate is null then RateCon.Rate*(Case When RateCon.Loading<>0 then RateCon.Loading/100 else RCover.Loading end) else RRateCon.Rate/PCalc.RiskNum*(Case When RRateCon.Loading<>0 then RRateCon.Loading/100 else RCover.Loading end) end) Else coalesce(@P_NETRATEDet,RPart.NetRate/PCalc.RiskNum) end/100*(100-RCover.Discount)/100*ICALC.GROSS/PCALC.GROSS*ICALC.PRORATA *ICALC.TSI*(CASE WHEN RCOVER.PCALC='S' OR RCOVER.PCTLOSS=0 THEN 100 ELSE RCOVER.PCTLOSS END)/(CASE WHEN RCOVER.PCTLOSS=0 THEN 100 ELSE RCOVER.PCTLOSS END+RCOVER.PAddition)*ICALC.PCTADJ/100)*(Case When (CASE WHEN @P_COMMN<>0 Then @P_COMMN ELSE RPART.COMMN END)=0 Then 1 else (Case When RCover.NetRateF=1 or @P_ONGROSSNET=2 OR (@P_ONGROSSNET=0 AND (100-@Premium_OutGo)/100*(100-(CASE WHEN @P_COMMN<>0 Then @P_COMMN ELSE RPART.COMMN END))/100<(100-(CASE WHEN @P_COMM<>0 Then @P_COMM ELSE RPART.COMM END))/100) Then 1 else 1 end) end)*PCalc.Rate),0) AS GROSS_2,              
             
coalesce(SUM((CASE WHEN RPart.PPCT<>0 THEN RPart.PPCT/100 ELSE (Case When @P_RateConF=1 and (RRateCon.Rate is not null or RateCon.Rate is not null) then 0 else 1 end) END * ICALC.GROSS*(PCALC.PGROSS*@P_PFactor)/PCALC.POGROSS*(Case When RPart.OnNetPremiumF=1 Then (100-@Premium_Treaty_Discount)/100 else 1 end)-(ICALC.GROSS*@P_OPFEE/PCALC.POGROSS))*(Case When (CASE WHEN @P_COMMN<>0 Then @P_COMMN ELSE RPART.COMMN END)=0 Then 0 else (Case When RCover.NetRateF=1 or @P_ONGROSSNET=2 OR (@P_ONGROSSNET=0 AND (100-@Premium_OutGo)/100*(100-(CASE WHEN @P_COMMN<>0 Then @P_COMMN ELSE RPART.COMMN END))/100<(100-(CASE WHEN @P_COMM<>0 Then @P_COMM ELSE RPART.COMM END))/100) Then (@Premium_OutGo)/100 else 0 end) end)*PCalc.Rate),0) AS DISC_1,              
coalesce(SUM((Case When @P_RateConF=1 Then (Case When RRateCon.Rate is null then RateCon.Rate*(Case When RateCon.Loading<>0 then RateCon.Loading/100 else RCover.Loading end) else RRateCon.Rate/PCalc.RiskNum*(Case When RRateCon.Loading<>0 then RRateCon.Loading/100 else RCover.Loading end) end) Else coalesce(@P_NETRATEDet,RPart.NetRate/PCalc.RiskNum) end/100*(100-RCover.Discount)/100*ICALC.GROSS/PCALC.GROSS*ICALC.PRORATA *ICALC.TSI*(CASE WHEN RCOVER.PCALC='S' OR RCOVER.PCTLOSS=0 THEN 100 ELSE RCOVER.PCTLOSS END)/(CASE WHEN RCOVER.PCTLOSS=0 THEN 100 ELSE RCOVER.PCTLOSS END+RCOVER.PAddition)*ICALC.PCTADJ/100)*(Case When (CASE WHEN @P_COMMN<>0 Then @P_COMMN ELSE RPART.COMMN END)=0 Then 0 else (Case When RCover.NetRateF=1 or @P_ONGROSSNET=2 OR (@P_ONGROSSNET=0 AND (100-@Premium_OutGo)/100*(100-(CASE WHEN @P_COMMN<>0 Then @P_COMMN ELSE RPART.COMMN END))/100<(100-(CASE WHEN @P_COMM<>0 Then @P_COMM ELSE RPART.COMM END))/100) Then (@Premium_OutGo)/100 else 0 end) end)*PCalc.Rate),0) AS DISC_2,  

coalesce(SUM((CASE WHEN RPart.PPCT<>0 THEN RPart.PPCT/100 ELSE (Case When @P_RateConF=1 and (RRateCon.Rate is not null or RateCon.Rate is not null) then 0 else 1 end) END * ICALC.GROSS*(PCALC.PGROSS*@P_PFactor)/PCALC.POGROSS*(Case When RPart.OnNetPremiumF=1 Then (100-@Premium_Treaty_Discount)/100 else 1 end))*(Case When (CASE WHEN @P_COMMN<>0 Then @P_COMMN ELSE RPART.COMMN END)=0 Then 1 else (Case When RCover.NetRateF=1 or @P_ONGROSSNET=2 OR (@P_ONGROSSNET=0 AND (100-@Premium_OutGo)/100*(100-(CASE WHEN @P_COMMN<>0 Then @P_COMMN ELSE RPART.COMMN END))/100<(100-(CASE WHEN @P_COMM<>0 Then @P_COMM ELSE RPART.COMM END))/100) Then 1 else 1 end) end)*RPart.Fee/100-(ICALC.GROSS*@P_OPFEE/PCALC.POGROSS)*PCalc.Rate),0) AS FEE_1,              
coalesce(SUM((Case When @P_RateConF=1 Then (Case When RRateCon.Rate is null then RateCon.Rate*(Case When RateCon.Loading<>0 then RateCon.Loading/100 else RCover.Loading end) else RRateCon.Rate/PCalc.RiskNum*(Case When RRateCon.Loading<>0 then RRateCon.Loading/100 else RCover.Loading end) end) Else coalesce(@P_NETRATEDet,RPart.NetRate/PCalc.RiskNum) end/100*(100-RCover.Discount)/100*ICALC.GROSS/PCALC.GROSS*ICALC.PRORATA *ICALC.TSI*(CASE WHEN RCOVER.PCALC='S' OR RCOVER.PCTLOSS=0 THEN 100 ELSE RCOVER.PCTLOSS END)/(CASE WHEN RCOVER.PCTLOSS=0 THEN 100 ELSE RCOVER.PCTLOSS END+RCOVER.PAddition)*ICALC.PCTADJ/100)*(Case When (CASE WHEN @P_COMMN<>0 Then @P_COMMN ELSE RPART.COMMN END)=0 Then 1 else (Case When RCover.NetRateF=1 or @P_ONGROSSNET=2 OR (@P_ONGROSSNET=0 AND (100-@Premium_OutGo)/100*(100-(CASE WHEN @P_COMMN<>0 Then @P_COMMN ELSE RPART.COMMN END))/100<(100-(CASE WHEN @P_COMM<>0 Then @P_COMM ELSE RPART.COMM END))/100) Then 1 else 1 end) end)*RPart.Fee/100-(ICALC.GROSS*@P_OPFEE/PCALC.POGROSS)*PCalc.Rate),0) AS FEE_2  
              
FROM ICALC   
INNER JOIN ACCEPTANCE SACCEPTANCE ON (SACCEPTANCE.ANO=ICALC.SANO)  
INNER JOIN RCOVER ON (RCOVER.ANO=ICALC.SANO AND RCOVER.CODE=ICALC.CODE AND (RCOVER.SDATE=ICALC.SDATE OR (@P_AType='A' AND (CASE WHEN RCOVER.SDATE<SACCEPTANCE.PDATE THEN SACCEPTANCE.PDATE ELSE RCOVER.SDATE END)=ICALC.SDATE)))  
INNER JOIN REINSURANCE ON (REINSURANCE.RID=@P_RID)
INNER JOIN RPART ON (RPART.RNO=REINSURANCE.RNO)
LEFT JOIN RPARTDET ON (RPARTDET.RNO=@P_RNO AND RPARTDET.ID=RPART.ID AND RPARTDET.TOR=ICALC.TOR)  
LEFT Join FN_RateCon(@P_ANO, @P_CODE,@P_TSI) RateCon On (RateCon.Code=ICalc.Code)  
LEFT Join FN_RRateCon(@P_ANO, @P_RID, @P_TSI) RRateCon On (1=1)              
INNER JOIN ICOVER ON (ICOVER.INO=ICALC.INO AND (ICOVER.ADJUSTABLE=@P_ADJUSTABLEF OR @P_AType='A'))  
INNER JOIN RCALC ON (RCALC.ANO=ICALC.ANO AND RCALC.CURRENCY=ICALC.CURRENCY AND RCALC.CODE=ICALC.CODE AND RCALC.TOR=ICALC.TOR AND RCALC.SDATE=ICALC.SDATE AND RCALC.EDATE=ICALC.EDATE AND RCALC.SANO=ICALC.SANO AND RCALC.EXTREATYF=0)  
INNER JOIN PCALC_ANNUM(@P_ANO) PCALC ON (PCALC.ANO=ICALC.ANO AND PCALC.CODE=ICALC.CODE AND PCALC.SDATE=ICALC.SDATE AND PCALC.EDATE=ICALC.EDATE AND PCALC.INO=ICALC.INO AND PCALC.CURRENCY=ICALC.CURRENCY)  
WHERE ICALC.ANO=@P_ANO AND ICALC.CURRENCY=@P_CCY AND ICALC.SDATE=@P_SDATE AND ICALC.EDATE=@P_EDATE AND ICALC.CODE=@P_CODE              
AND RPARTDET.TOR IS NULL AND PCALC.GROSS<>0  
Group By RPart.ID, Cast(RPart.OnMinPremiumF as integer)

Union All              

select              
RPart.ID,
Cast(RPart.OnMinPremiumF as integer) as OnMinPremiumF,              

coalesce(SUM((CASE WHEN RPARTDET.PPCT<>0 THEN RPARTDET.PPCT/100 ELSE (Case When @P_RateConF=1 and (RRateCon.Rate is not null or RateCon.Rate is not null) then 0 else 1 end) END * ICALC.GROSS*(PCALC.PGROSS*@P_PFactor)/PCALC.POGROSS-(ICALC.GROSS*@P_OPFEE/PCALC.POGROSS))*(Case When RPart.OnNetPremiumF=1 Then (100-@Premium_Treaty_Discount)/100 else 1 end)*(Case When RPARTDET.COMMN=0 Then RPARTDET.COMM/100 else (Case When RCover.NetRateF=1 or @P_ONGROSSNET=2 OR (@P_ONGROSSNET=0 AND (100-@Premium_OutGo)/100*(100-RPARTDET.CommN)/100<(100-RPARTDET.COMM)/100) Then (100-@Premium_OutGo)/100*(RPARTDET.CommN)/100 else RPARTDET.COMM/100 end) end)*PCalc.Rate),0) AS COMM_1,              
coalesce(SUM((Case When @P_RateConF=1 Then (Case When RRateCon.Rate is null then RateCon.Rate*(Case When RateCon.Loading<>0 then RateCon.Loading/100 else RCover.Loading end) else RRateCon.Rate/PCalc.RiskNum*(Case When RRateCon.Loading<>0 then RRateCon.Loading/100 else RCover.Loading end) end) Else coalesce(@P_NETRATEDet,RPARTDET.NETRate) end/100*(100-RCover.Discount)/100*ICALC.GROSS/PCALC.GROSS*ICALC.PRORATA *ICALC.TSI*(CASE WHEN RCOVER.PCALC='S' OR RCOVER.PCTLOSS=0 THEN 100 ELSE RCOVER.PCTLOSS END)/(CASE WHEN RCOVER.PCTLOSS=0 THEN 100 ELSE RCOVER.PCTLOSS END+RCOVER.PAddition)*ICALC.PCTADJ/100-(ICALC.GROSS*@P_OPFEE/PCALC.POGROSS))*(Case When RPARTDET.COMMN=0 Then RPARTDET.COMM/100 else (Case When RCover.NetRateF=1 or @P_ONGROSSNET=2 OR (@P_ONGROSSNET=0 AND (100-@Premium_OutGo)/100*(100-RPARTDET.CommN)/100<(100-RPARTDET.COMM)/100) Then (100-@Premium_OutGo)/100*(RPARTDET.CommN)/100 else RPARTDET.COMM/100 end) end)*PCalc.Rate),0) AS COMM_2,                  
              
coalesce(SUM((CASE WHEN RPARTDET.PPCT<>0 THEN RPARTDET.PPCT/100 ELSE (Case When @P_RateConF=1 and (RRateCon.Rate is not null or RateCon.Rate is not null) then 0 else 1 end) END * ICALC.GROSS*(PCALC.PGROSS*@P_PFactor)/PCALC.POGROSS)*(Case When RPart.OnNetPremiumF=1 Then (100-@Premium_Treaty_Discount)/100 else 1 end)*(Case When RPARTDET.COMMN=0 Then 1 else (Case When RCover.NetRateF=1 or @P_ONGROSSNET=2 OR (@P_ONGROSSNET=0 AND (100-@Premium_OutGo)/100*(100-RPARTDET.CommN)/100<(100-RPARTDET.COMM)/100) Then 1 else 1 end) end)*PCalc.Rate),0) AS GROSS_1,              
coalesce(SUM((Case When @P_RateConF=1 Then (Case When RRateCon.Rate is null then RateCon.Rate*(Case When RateCon.Loading<>0 then RateCon.Loading/100 else RCover.Loading end) else RRateCon.Rate/PCalc.RiskNum*(Case When RRateCon.Loading<>0 then RRateCon.Loading/100 else RCover.Loading end) end) Else coalesce(@P_NETRATEDet,RPARTDET.NETRate) end/100*(100-RCover.Discount)/100*ICALC.GROSS/PCALC.GROSS*ICALC.PRORATA *ICALC.TSI*(CASE WHEN RCOVER.PCALC='S' OR RCOVER.PCTLOSS=0 THEN 100 ELSE RCOVER.PCTLOSS END)/(CASE WHEN RCOVER.PCTLOSS=0 THEN 100 ELSE RCOVER.PCTLOSS END+RCOVER.PAddition)*ICALC.PCTADJ/100)*(Case When RPARTDET.COMMN=0 Then 1 else (Case When RCover.NetRateF=1 or @P_ONGROSSNET=2 OR (@P_ONGROSSNET=0 AND (100-@Premium_OutGo)/100*(100-RPARTDET.CommN)/100<(100-RPARTDET.COMM)/100) Then 1 else 1 end) end)*PCalc.Rate),0) AS GROSS_2,              

coalesce(SUM((CASE WHEN RPARTDET.PPCT<>0 THEN RPARTDET.PPCT/100 ELSE (Case When @P_RateConF=1 and (RRateCon.Rate is not null or RateCon.Rate is not null) then 0 else 1 end) END * ICALC.GROSS*(PCALC.PGROSS*@P_PFactor)/PCALC.POGROSS-(ICALC.GROSS*@P_OPFEE/PCALC.POGROSS))*(Case When RPart.OnNetPremiumF=1 Then (100-@Premium_Treaty_Discount)/100 else 1 end)*(Case When RPARTDET.COMMN=0 Then 0 else (Case When RCover.NetRateF=1 or @P_ONGROSSNET=2 OR (@P_ONGROSSNET=0 AND (100-@Premium_OutGo)/100*(100-RPARTDET.CommN)/100<(100-RPARTDET.COMM)/100) Then (@Premium_OutGo)/100 else 0 end) end)*PCalc.Rate),0) AS DISC_1,              
coalesce(SUM((Case When @P_RateConF=1 Then (Case When RRateCon.Rate is null then RateCon.Rate*(Case When RateCon.Loading<>0 then RateCon.Loading/100 else RCover.Loading end) else RRateCon.Rate/PCalc.RiskNum*(Case When RRateCon.Loading<>0 then RRateCon.Loading/100 else RCover.Loading end) end) Else coalesce(@P_NETRATEDet,RPARTDET.NETRate) end/100*(100-RCover.Discount)/100*ICALC.GROSS/PCALC.GROSS*ICALC.PRORATA *ICALC.TSI*(CASE WHEN RCOVER.PCALC='S' OR RCOVER.PCTLOSS=0 THEN 100 ELSE RCOVER.PCTLOSS END)/(CASE WHEN RCOVER.PCTLOSS=0 THEN 100 ELSE RCOVER.PCTLOSS END+RCOVER.PAddition)*ICALC.PCTADJ/100)*(Case When RPARTDET.COMMN=0 Then 0 else (Case When RCover.NetRateF=1 or @P_ONGROSSNET=2 OR (@P_ONGROSSNET=0 AND (100-@Premium_OutGo)/100*(100-RPARTDET.CommN)/100<(100-RPARTDET.COMM)/100) Then (@Premium_OutGo)/100 else 0 end) end)*PCalc.Rate),0) AS DISC_2,  

coalesce(SUM((CASE WHEN RPARTDET.PPCT<>0 THEN RPARTDET.PPCT/100 ELSE (Case When @P_RateConF=1 and (RRateCon.Rate is not null or RateCon.Rate is not null) then 0 else 1 end) END * ICALC.GROSS*(PCALC.PGROSS*@P_PFactor)/PCALC.POGROSS)*(Case When RPart.OnNetPremiumF=1 Then (100-@Premium_Treaty_Discount)/100 else 1 end)*(Case When RPARTDET.COMMN=0 Then 1 else (Case When RCover.NetRateF=1 or @P_ONGROSSNET=2 OR (@P_ONGROSSNET=0 AND (100-@Premium_OutGo)/100*(100-RPARTDET.CommN)/100<(100-RPARTDET.COMM)/100) Then 1 else 1 end) end)*RPart.Fee/100-(ICALC.GROSS*@P_OPFEE/PCALC.POGROSS)*PCalc.Rate),0) AS FEE_1,              
coalesce(SUM((Case When @P_RateConF=1 Then (Case When RRateCon.Rate is null then RateCon.Rate*(Case When RateCon.Loading<>0 then RateCon.Loading/100 else RCover.Loading end) else RRateCon.Rate/PCalc.RiskNum*(Case When RRateCon.Loading<>0 then RRateCon.Loading/100 else RCover.Loading end) end) Else coalesce(@P_NETRATEDet,RPARTDET.NETRate) end/100*(100-RCover.Discount)/100*ICALC.GROSS/PCALC.GROSS*ICALC.PRORATA *ICALC.TSI*(CASE WHEN RCOVER.PCALC='S' OR RCOVER.PCTLOSS=0 THEN 100 ELSE RCOVER.PCTLOSS END)/(CASE WHEN RCOVER.PCTLOSS=0 THEN 100 ELSE RCOVER.PCTLOSS END+RCOVER.PAddition)*ICALC.PCTADJ/100)*(Case When RPARTDET.COMMN=0 Then 1 else (Case When RCover.NetRateF=1 or @P_ONGROSSNET=2 OR (@P_ONGROSSNET=0 AND (100-@Premium_OutGo)/100*(100-RPARTDET.CommN)/100<(100-RPARTDET.COMM)/100) Then 1 else 1 end) end)*RPart.Fee/100-(ICALC.GROSS*@P_OPFEE/PCALC.POGROSS)*PCalc.Rate),0) AS FEE_2  
FROM ICALC   
INNER JOIN ACCEPTANCE SACCEPTANCE ON (SACCEPTANCE.ANO=ICALC.SANO)  
INNER JOIN RCOVER ON (RCOVER.ANO=ICALC.SANO AND RCOVER.CODE=ICALC.CODE AND (RCOVER.SDATE=ICALC.SDATE OR (@P_AType='A' AND (CASE WHEN RCOVER.SDATE<SACCEPTANCE.PDATE THEN SACCEPTANCE.PDATE ELSE RCOVER.SDATE END)=ICALC.SDATE)))  
INNER JOIN REINSURANCE ON (REINSURANCE.RID=@P_RID)
INNER JOIN RPART ON (RPART.RNO=REINSURANCE.RNO)
LEFT JOIN RPARTDET ON (RPARTDET.RNO=@P_RNO AND RPARTDET.ID=RPART.ID AND RPARTDET.TOR=ICALC.TOR AND (RPARTDET.NOFYEARS=0 OR RPARTDET.NOFYEARS=@P_NOFYEARS) and RPARTDET.EXCLUDEF=0)  
LEFT Join FN_RateCon(@P_ANO, @P_CODE,@P_TSI) RateCon On (RateCon.Code=ICalc.Code)  
LEFT Join FN_RRateCon(@P_ANO, @P_RID, @P_TSI) RRateCon On (1=1)              
INNER JOIN ICOVER ON (ICOVER.INO=ICALC.INO AND (ICOVER.ADJUSTABLE=@P_ADJUSTABLEF OR @P_AType='A'))  
INNER JOIN RCALC ON (RCALC.ANO=ICALC.ANO AND RCALC.CURRENCY=ICALC.CURRENCY AND RCALC.CODE=ICALC.CODE AND RCALC.TOR=ICALC.TOR AND RCALC.SDATE=ICALC.SDATE AND RCALC.EDATE=ICALC.EDATE AND RCALC.SANO=ICALC.SANO AND RCALC.EXTREATYF=0)  
INNER JOIN PCALC_ANNUM(@P_ANO) PCALC ON (PCALC.ANO=ICALC.ANO AND PCALC.CODE=ICALC.CODE AND PCALC.SDATE=ICALC.SDATE AND PCALC.EDATE=ICALC.EDATE AND PCALC.INO=ICALC.INO AND PCALC.CURRENCY=ICALC.CURRENCY)  
WHERE ICALC.ANO=@P_ANO AND ICALC.CURRENCY=@P_CCY AND ICALC.SDATE=@P_SDATE AND ICALC.EDATE=@P_EDATE AND ICALC.CODE=@P_CODE              
AND PCALC.GROSS<>0  
Group By RPart.ID, Cast(RPart.OnMinPremiumF as integer)


) R        

GO

IF EXISTS ( SELECT * FROM   sysobjects WHERE  id = object_id(N'[dbo].[QREINSURANCE_CESSION]') and OBJECTPROPERTY(id, N'IsProcedure') = 1 )
begin
DROP Procedure QREINSURANCE_CESSION
end
GO
CREATE Procedure QREINSURANCE_CESSION (@P_ANO integer, @P_ADate smalldatetime, @P_RType varchar(255), @P_TSI Float=0, @P_RID varchar(20)='', @P_ManualF Bit=0, @P_GROSS Float=0)                                
as                                                          
SELECT (Case When ReClass.PriorityF=1 Then ReClass.PriorityF else Reinsurance.PriorityF end) as PriorityF, Reinsurance.RID, Reinsurance.RType,                                
ReClass.PLimit*Case When coalesce(R1.Rate,0)=0 Then (Case When Reinsurance.Currency='' or Reinsurance.Currency=SysTab.Currency Then 1 Else (Select Rate from fn_exchange(Acceptance.SDate) Currency Where Currency=Reinsurance.Currency) End) else coalesce(R1.Rate,1)*coalesce(R2.Rate,1) end as PLimit, 
Case RECLASS.Limit WHEN 0 then Reinsurance.Limit Else RECLASS.Limit end*Case When coalesce(R1.Rate,0)=0 Then (Case When Reinsurance.Currency='' or Reinsurance.Currency=SysTab.Currency Then 1 Else (Select Rate from fn_exchange(Acceptance.SDate) Currency Where Currency=Reinsurance.Currency) End) else coalesce(R1.Rate,1)*coalesce(R2.Rate,1) end  as limit, 
ReClass.ShortFallLimit*Case When coalesce(R1.Rate,0)=0 Then (Case When Reinsurance.Currency='' or Reinsurance.Currency=SysTab.Currency Then 1 Else (Select Rate from fn_exchange(Acceptance.SDate) Currency Where Currency=Reinsurance.Currency) End) else coalesce(R1.Rate,1)*coalesce(R2.Rate,1) end  as ShortFallLimit,              
ReClass.MinTSI*Case When coalesce(R1.Rate,0)=0 Then (Case When Reinsurance.Currency='' or Reinsurance.Currency=SysTab.Currency Then 1 Else (Select Rate from fn_exchange(Acceptance.SDate) Currency Where Currency=Reinsurance.Currency) End) else coalesce(R1.Rate,1)*coalesce(R2.Rate,1) end  as MinTI, 
ReClass.AssessmentExInwardF,
Reinsurance.UjrohReins, Reinsurance.UjrohCedant, Reinsurance.Share, Reinsurance.PShare, Acceptance.FLDID, Acceptance.ValueID, ReClass.CessionF, ReClass.AssessmentF, ReClass.DirectF                                
From Acceptance       
Inner Join Cover on (Cover.CNO=Acceptance.CNO)      
Left Join RArrHeader on (RArrHeader.ANO=Acceptance.ANO)      
Inner Join Reinsurance on (Reinsurance.RType=@P_RType)      
Inner Join ReClass on (ReClass.RNO=Reinsurance.RNO and ReClass.TOC=Acceptance.TOC and (ReClass.DirectF=0 or Cover.ISType in ('I','L','C')))      
Left Join RePolicy on (RePolicy.RNO=Reinsurance.RNO)      
Left Join ReRate R1 on (R1.TOC=Acceptance.TOC and R1.RYear=Reinsurance.RYEAR and R1.Currency=Reinsurance.Currency)
left Join ReRate R2 on (R2.TOC=R1.TOC and R2.RYear=R1.RYear and R2.Currency=R1.CCYTo)
Inner Join SysTab on (1=1)
WHERE ACCEPTANCE.ANO=@P_ANO         
And Case When Reinsurance.PolicyRunOffF=1 Then Acceptance.SDate else @P_ADATE end Between Reinsurance.SDate And Reinsurance.EDate         
And (@P_RID='' or Reinsurance.RID=@P_RID or RArrHeader.ManualF=0 or Acceptance.EMethod='T')                            
And (coalesce(RePolicy.ID,'')='' or  coalesce(RePolicy.ID,'')=Cover.PHolder)    
And (@P_ManualF=1 or RArrHeader.ManualF=1 or       
(      
 (Reinsurance.ORBusinessF=RArrHeader.ORBusinessF)      
 And (@P_TSI>=ReClass.MinTSI*Case When coalesce(R1.Rate,0)=0 Then (Case When Reinsurance.Currency='' or Reinsurance.Currency=SysTab.Currency Then 1 Else (Select Rate from fn_exchange(Acceptance.SDate) Currency Where Currency=Reinsurance.Currency) End) else coalesce(R1.Rate,1)*coalesce(R2.Rate,1) end  or ReClass.MinTSI*Case When coalesce(R1.Rate,0)=0 Then (Case When Reinsurance.Currency='' or Reinsurance.Currency=SysTab.Currency Then 1 Else (Select Rate from fn_exchange(Acceptance.SDate) Currency Where Currency=Reinsurance.Currency) End) else coalesce(R1.Rate,1)*coalesce(R2.Rate,1) end =0) and (@P_TSI<=ReClass.MaxTSI*Case When coalesce(R1.Rate,0)=0 Then (Case When Reinsurance.Currency='' or Reinsurance.Currency=SysTab.Currency Then 1 Else (Select Rate from fn_exchange(Acceptance.SDate) Currency Where Currency=Reinsurance.Currency) End) else coalesce(R1.Rate,1)*coalesce(R2.Rate,1) end  or ReClass.MaxTSI*Case When coalesce(R1.Rate,0)=0 Then (Case When Reinsurance.Currency='' or Reinsurance.Currency=SysTab.Currency Then 1 Else (Select Rate from fn_exchange(Acceptance.SDate) Currency Where Currency=Reinsurance.Currency) End) else coalesce(R1.Rate,1)*coalesce(R2.Rate,1) end =0) 
 and (@P_GROSS>=ReClass.MinGross*Case When coalesce(R1.Rate,0)=0 Then (Case When Reinsurance.Currency='' or Reinsurance.Currency=SysTab.Currency Then 1 Else (Select Rate from fn_exchange(Acceptance.SDate) Currency Where Currency=Reinsurance.Currency) End) else coalesce(R1.Rate,1)*coalesce(R2.Rate,1) end  or ReClass.MinGross*Case When coalesce(R1.Rate,0)=0 Then (Case When Reinsurance.Currency='' or Reinsurance.Currency=SysTab.Currency Then 1 Else (Select Rate from fn_exchange(Acceptance.SDate) Currency Where Currency=Reinsurance.Currency) End) else coalesce(R1.Rate,1)*coalesce(R2.Rate,1) end =0) and (@P_GROSS<=ReClass.MaxGross*Case When coalesce(R1.Rate,0)=0 Then (Case When Reinsurance.Currency='' or Reinsurance.Currency=SysTab.Currency Then 1 Else (Select Rate from fn_exchange(Acceptance.SDate) Currency Where Currency=Reinsurance.Currency) End) else coalesce(R1.Rate,1)*coalesce(R2.Rate,1) end  or ReClass.MaxGross*Case When coalesce(R1.Rate,0)=0 Then (Case When Reinsurance.Currency='' or Reinsurance.Currency=SysTab.Currency Then 1 Else (Select Rate from fn_exchange(Acceptance.SDate) Currency Where Currency=Reinsurance.Currency) End) else coalesce(R1.Rate,1)*coalesce(R2.Rate,1) end =0)                 
 And (    
 (datediff(month, Case When Reinsurance.PolicyRunOffF=1 then Acceptance.SDate else coalesce(RArrHeader.RDate,acceptance.sdate) end, Case When Reinsurance.PolicyRunOffF=1 then Acceptance.EDate else coalesce(RArrHeader.NRDate,Acceptance.EDate) end)>=ReClass.MinPeriod)     
 or (datediff(month, Case When Reinsurance.PolicyRunOffF=1 then Acceptance.SDate else coalesce(RArrHeader.RDate,acceptance.sdate) end, Case When Reinsurance.PolicyRunOffF=1 then Acceptance.EDate else coalesce(RArrHeader.NRDate,Acceptance.EDate) end)=ReClass.MinPeriod-1 and day(Case When Reinsurance.PolicyRunOffF=1 then Acceptance.SDate else coalesce(RArrHeader.RDate,acceptance.sdate) end)<day(Case When Reinsurance.PolicyRunOffF=1 then Acceptance.EDate else coalesce(RArrHeader.NRDate,Acceptance.EDate) end)


)     
 or ReClass.MinPeriod=0)                               
 And (    
 (datediff(month, Case When Reinsurance.PolicyRunOffF=1 then Acceptance.SDate else coalesce(RArrHeader.RDate,acceptance.sdate) end, Case When Reinsurance.PolicyRunOffF=1 then Acceptance.EDate else coalesce(RArrHeader.NRDate,Acceptance.EDate) end)<ReClass.MaxPeriod)     
 or (datediff(month, Case When Reinsurance.PolicyRunOffF=1 then Acceptance.SDate else coalesce(RArrHeader.RDate,acceptance.sdate) end, Case When Reinsurance.PolicyRunOffF=1 then Acceptance.EDate else coalesce(RArrHeader.NRDate,Acceptance.EDate) end)=ReClass.MaxPeriod and day(Case When Reinsurance.PolicyRunOffF=1 then Acceptance.SDate else coalesce(RArrHeader.RDate,acceptance.sdate) end)>=day(Case When Reinsurance.PolicyRunOffF=1 then Acceptance.EDate else coalesce(RArrHeader.NRDate,Acceptance.EDate) end))


 or ReClass.MaxPeriod=0))      
)                    
And Exists (Select Top 1 RCalc.ANO from RCalc Left Join RPartDet on (RPartDet.RNO=Reinsurance.RNO and RPartDet.TOR=RCalc.TOR) Where RCalc.ANO=Acceptance.ANO and coalesce(RPartDet.ExcludeF,0)=0)  
Order By coalesce(RePolicy.ID,'') Desc, (Case When ReClass.PriorityF=1 Then ReClass.PriorityF else Reinsurance.PriorityF end) Desc                   
  

GO

IF EXISTS ( SELECT * FROM   sysobjects WHERE  id = object_id(N'[dbo].[Claim_Cession]') and OBJECTPROPERTY(id, N'IsProcedure') = 1 )
begin
DROP Procedure Claim_Cession
end
GO
CREATE PROCEDURE Claim_Cession (@PCNO as integer, @pLDate as smalldatetime, @pRType as varchar(255))                    
AS                    
SELECT coalesce(RePolicy.ID,''), (Case When ReClass.PriorityF=1 Then ReClass.PriorityF else Reinsurance.PriorityF end) as PriorityF, Reinsurance.RID, Reinsurance.RType, Reinsurance.Category, Reinsurance.Share,                    
Case When Event.Category='E' and RECLASS.ELIMIT<>0 Then RECLASS.ELIMIT Else (Case WHEN RECLASS.Limit=0 THEN Reinsurance.Limit Else RECLASS.Limit end) End*Case When coalesce(R1.CRate,0)<>0 Then coalesce(R1.CRate,0)*Case When coalesce(R2.CRate,0)<>0 Then coalesce(R2.CRate,0) else coalesce(R2.Rate,1) End When coalesce(R1.Rate,0)<>0 Then coalesce(R1.Rate,0) *Case When coalesce(R2.CRate,0)<>0 Then coalesce(R2.CRate,0) else coalesce(R2.Rate,1) End else (Case When Reinsurance.Currency='' or Reinsurance.Currency=SysTab.Currency Then 1 Else (Select Rate from fn_exchange(Acceptance.SDate) Currency Where Currency=Reinsurance.Currency) End) End as Limit,                    
Case When Event.Category='E' and RECLASS.EExcess<>0 Then RECLASS.EExcess Else (Case WHEN RECLASS.Excess=0 THEN Reinsurance.Excess Else RECLASS.Excess end) End*Case When coalesce(R1.CRate,0)<>0 Then coalesce(R1.CRate,0)*Case When coalesce(R2.CRate,0)<>0 Then coalesce(R2.CRate,0) else coalesce(R2.Rate,1) End When coalesce(R1.Rate,0)<>0 Then coalesce(R1.Rate,0) *Case When coalesce(R2.CRate,0)<>0 Then coalesce(R2.CRate,0) else coalesce(R2.Rate,1) End else (Case When Reinsurance.Currency='' or Reinsurance.Currency=SysTab.Currency Then 1 Else (Select Rate from fn_exchange(Acceptance.SDate) Currency Where Currency=Reinsurance.Currency) End) End as Excess,                    
Reinsurance.ExcessType,                
RECLASS.CessionF , RECLASS.AssessmentF, 

REINSURANCE.Deductible*Case When coalesce(R1.CRate,0)<>0 Then coalesce(R1.CRate,0)*Case When coalesce(R2.CRate,0)<>0 Then coalesce(R2.CRate,0) else coalesce(R2.Rate,1) End When coalesce(R1.Rate,0)<>0 Then coalesce(R1.Rate,0) *Case When coalesce(R2.CRate,0)<>0 Then coalesce(R2.CRate,0) else coalesce(R2.Rate,1) End else (Case When Reinsurance.Currency='' or Reinsurance.Currency=SysTab.Currency Then 1 Else (Select Rate from fn_exchange(Acceptance.SDate) Currency Where Currency=Reinsurance.Currency) End) End as Deductible, 
REINSURANCE.A_Deductible*Case When coalesce(R1.CRate,0)<>0 Then coalesce(R1.CRate,0)*Case When coalesce(R2.CRate,0)<>0 Then coalesce(R2.CRate,0) else coalesce(R2.Rate,1) End When coalesce(R1.Rate,0)<>0 Then coalesce(R1.Rate,0) *Case When coalesce(R2.CRate,0)<>0 Then coalesce(R2.CRate,0) else coalesce(R2.Rate,1) End else (Case When Reinsurance.Currency='' or Reinsurance.Currency=SysTab.Currency Then 1 Else (Select Rate from fn_exchange(Acceptance.SDate) Currency Where Currency=Reinsurance.Currency) End) End as A_Deductible, 
REINSURANCE.A_EDeductible*Case When coalesce(R1.CRate,0)<>0 Then coalesce(R1.CRate,0)*Case When coalesce(R2.CRate,0)<>0 Then coalesce(R2.CRate,0) else coalesce(R2.Rate,1) End When coalesce(R1.Rate,0)<>0 Then coalesce(R1.Rate,0) *Case When coalesce(R2.CRate,0)<>0 Then coalesce(R2.CRate,0) else coalesce(R2.Rate,1) End else (Case When Reinsurance.Currency='' or Reinsurance.Currency=SysTab.Currency Then 1 Else (Select Rate from fn_exchange(Acceptance.SDate) Currency Where Currency=Reinsurance.Currency) End) End as A_EDeductible, 
REINSURANCE.Aggregate*Case When coalesce(R1.CRate,0)<>0 Then coalesce(R1.CRate,0)*Case When coalesce(R2.CRate,0)<>0 Then coalesce(R2.CRate,0) else coalesce(R2.Rate,1) End When coalesce(R1.Rate,0)<>0 Then coalesce(R1.Rate,0) *Case When coalesce(R2.CRate,0)<>0 Then coalesce(R2.CRate,0) else coalesce(R2.Rate,1) End else (Case When Reinsurance.Currency='' or Reinsurance.Currency=SysTab.Currency Then 1 Else (Select Rate from fn_exchange(Acceptance.SDate) Currency Where Currency=Reinsurance.Currency) End) End as Aggregate, 
REINSURANCE.A_Aggregate*Case When coalesce(R1.CRate,0)<>0 Then coalesce(R1.CRate,0)*Case When coalesce(R2.CRate,0)<>0 Then coalesce(R2.CRate,0) else coalesce(R2.Rate,1) End When coalesce(R1.Rate,0)<>0 Then coalesce(R1.Rate,0) *Case When coalesce(R2.CRate,0)<>0 Then coalesce(R2.CRate,0) else coalesce(R2.Rate,1) End else (Case When Reinsurance.Currency='' or Reinsurance.Currency=SysTab.Currency Then 1 Else (Select Rate from fn_exchange(Acceptance.SDate) Currency Where Currency=Reinsurance.Currency) End) End as A_Aggregate, 
REINSURANCE.A_EAggregate*Case When coalesce(R1.CRate,0)<>0 Then coalesce(R1.CRate,0)*Case When coalesce(R2.CRate,0)<>0 Then coalesce(R2.CRate,0) else coalesce(R2.Rate,1) End When coalesce(R1.Rate,0)<>0 Then coalesce(R1.Rate,0) *Case When coalesce(R2.CRate,0)<>0 Then coalesce(R2.CRate,0) else coalesce(R2.Rate,1) End else (Case When Reinsurance.Currency='' or Reinsurance.Currency=SysTab.Currency Then 1 Else (Select Rate from fn_exchange(Acceptance.SDate) Currency Where Currency=Reinsurance.Currency) End) End as A_EAggregate
FROM Claim          
Left Join Event On (Event.EventNo=Claim.EventNo)          
Inner Join Acceptance on (Acceptance.ANO=Claim.ANO)          
Inner Join Cover on (Cover.CNO=Acceptance.CNO)          
Inner Join RArrHeader on (RArrHeader.ANO=Claim.ANO)          
Inner Join Reinsurance on (Reinsurance.RTYPE=@pRType and @pLDate Between Reinsurance.SDate And Reinsurance.EDate)          
Inner Join ReClass on (ReClass.RNO=Reinsurance.RNO and ReClass.TOC=Claim.TOC)          
Left Join RePolicy on (RePolicy.RNO=Reinsurance.RNO)          
Left Join ReRate R1 on (R1.TOC=Claim.TOC and R1.RYear=Reinsurance.RYEAR and R1.Currency=Reinsurance.Currency)
left Join ReRate R2 on (R2.TOC=R1.TOC and R2.RYear=R1.RYear and R2.Currency=R1.CCYTo)
Inner Join SysTab on (1=1)
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
Order By coalesce(RePolicy.ID,'') Desc, 
Case When (coalesce(Event.Category,'R')<>'R' and Reinsurance.Category in ('C','E')) or (coalesce(Event.Category,'R')='R' and Reinsurance.Category in ('R')) Then 1 else 0 end Desc, 
(Case When ReClass.PriorityF=1 Then ReClass.PriorityF else Reinsurance.PriorityF end) Desc             

GO

IF EXISTS ( SELECT * FROM   sysobjects WHERE  id = object_id(N'[dbo].[QREINSURANCE_RATE]') and OBJECTPROPERTY(id, N'IsProcedure') = 1 )
begin
DROP Procedure QREINSURANCE_RATE
end
GO
CREATE Procedure QREINSURANCE_RATE(@P_ANO integer, @P_CURRENCY varchar(10)) 
as 
SELECT coalesce(ReRate.CCYTo,'') as CCYTo,
Case 
When coalesce(ReRate.Rate,0)<>0 Then ReRate.Rate 
Else 
	Case
	When coalesce(ReRate.CCYTO,'')='' or coalesce(ReRate.CCYTO,'')=@P_Currency Then 1
	Else
		Case When @P_Currency<>SysTab.Currency Then (Select Rate from fn_exchange(Acceptance.SDate) Currency Where Currency=@P_Currency) else 1 end
		/
		Case When @P_Currency<>ReRate.CCYTO Then (Select Rate from fn_exchange(Acceptance.SDate) Currency Where Currency=ReRate.CCYTO) else 1 end
	End
end as Rate
From Acceptance 
Inner Join SysTab on (1=1)
Inner Join Cover on (Cover.CNO=Acceptance.CNO) 
Left Join RArrHeader on (RArrHeader.ANO=Acceptance.ANO) 
Left Join ReRate on ( 
ReRate.TOC=Acceptance.TOC 
and ReRate.Currency<>ReRate.CCYTo
and ReRate.RYear=coalesce(( 
	Select Top 1 R1.RYear 
	from Reinsurance R1, ReClass R2 
	Left Join RePolicy R3 on (R3.RNO=R2.RNO and R3.ID=Cover.PHolder) 
	Where (R1.Category<>'P' or Coalesce(R3.ID,'')<>'') and R1.RType='Q' and R2.RNO=R1.RNO and R2.TOC=Acceptance.TOC and RArrHeader.RDate Between R1.SDate and R1.EDate 
	Order By Case When R1.RID=RArrHeader.QID Then 1 else 0 end Desc, coalesce(R3.ID,'') Desc, (Case When R2.PriorityF=1 Then R2.PriorityF else R1.PriorityF end) Desc),Year(RArrHeader.RDate)) 
And ReRate.Currency=@P_Currency) 
WHERE Acceptance.ANO=@P_ANO 



GO


IF EXISTS ( SELECT * FROM   sysobjects WHERE  id = object_id(N'[dbo].[QCLAIM_RATE]') and OBJECTPROPERTY(id, N'IsProcedure') = 1 )
begin
DROP Procedure QCLAIM_RATE
end
GO
CREATE Procedure QCLAIM_RATE(@P_CNO integer, @P_CURRENCY varchar( 10))
as
SELECT coalesce(ReRate.CCYTo,'') as CCYTo,
Case 
When coalesce(ReRate.CRate,0)<>0 Then ReRate.CRate 
When coalesce(ReRate.Rate,0)<>0 Then ReRate.Rate 
Else 
	Case
	When coalesce(ReRate.CCYTO,'')='' or coalesce(ReRate.CCYTO,'')=@P_Currency Then 1
	Else
		Case When @P_Currency<>SysTab.Currency Then (Select Rate from fn_exchange(Acceptance.SDate) Currency Where Currency=@P_Currency) else 1 end
		/
		Case When @P_Currency<>ReRate.CCYTO Then (Select Rate from fn_exchange(Acceptance.SDate) Currency Where Currency=ReRate.CCYTO) else 1 end
	End
end as CRate
From Claim
Inner Join SysTab on (1=1)
Inner Join Acceptance on (Acceptance.ANO=Claim.ANO)
Inner Join Cover on (Cover.CNO=Acceptance.CNO) 
Left Join RArrHeader on (RArrHeader.ANO=Acceptance.ANO) 
Left Join ReRate on ( 
ReRate.TOC=ACCEPTANCE.TOC 
and ReRate.Currency<>ReRate.CCYTo
and ReRate.RYear=coalesce(( 
	Select Top 1 R1.RYear 
	from Reinsurance R1, ReClass R2 
	Left Join RePolicy R3 on (R3.RNO=R2.RNO and R3.ID=Cover.PHolder) 
	Where (R1.Category<>'P' or Coalesce(R3.ID,'')<>'') and R1.RType='Q' and R2.RNO=R1.RNO and R2.TOC=ACCEPTANCE.TOC and RArrHeader.RDate Between R1.SDate and R1.EDate 
	Order By Case When R1.RID=RArrHeader.QID Then 1 else 0 end Desc, coalesce(R3.ID,'') Desc, (Case When R2.PriorityF=1 Then R2.PriorityF else R1.PriorityF end) Desc),Year(RArrHeader.RDate)) 
And ReRate.Currency=@P_Currency) 
WHERE Claim.CNO=@P_CNO


GO


IF EXISTS ( SELECT * FROM   sysobjects WHERE  id = object_id(N'[dbo].[GetReinsuranceRate]') and OBJECTPROPERTY(id, N'IsProcedure') = 1 )
begin
DROP Procedure GetReinsuranceRate
end
GO
CREATE Procedure GetReinsuranceRate(@P_TOC as varchar(10), @P_Currency as varchar(10), @P_SDate as smalldatetime, @P_PHolder as varchar(10)='')   
as   
SELECT coalesce(ReRate.CCYTo,'') as CCYTo,
Case 
When coalesce(ReRate.Rate,0)<>0 Then ReRate.Rate 
Else 
	Case
	When coalesce(ReRate.CCYTO,'')='' or ReRate.CCYTO=@P_Currency Then 1
	Else
		Case When @P_Currency<>SysTab.Currency Then (Select Rate from fn_exchange(@P_SDate) Currency Where Currency=@P_Currency) else 1 end
		/
		Case When @P_Currency<>ReRate.CCYTO Then (Select Rate from fn_exchange(@P_SDate) Currency Where Currency=ReRate.CCYTO) else 1 end
	End
end as Rate
 
From SysTab
Left Join ReRate on (
ReRate.TOC=@P_TOC
and ReRate.Currency<>ReRate.CCYTo
and ReRate.RYear=coalesce((   
 Select Top 1 R1.RYear   
 from Reinsurance R1, ReClass R2   
 Left Join RePolicy R3 on (R3.RNO=R2.RNO and R3.ID=@P_PHolder)   
 Where (R1.Category<>'P' or Coalesce(R3.ID,'')<>'') and R1.RType='Q' and R2.RNO=R1.RNO and R2.TOC=@P_TOC and @P_SDate Between R1.SDate and R1.EDate   
 Order By coalesce(R3.ID,'') Desc, (Case When R2.PriorityF=1 Then R2.PriorityF else R1.PriorityF end) Desc),Year(@P_SDate)) 
And ReRate.Currency=@P_Currency) 
  

GO

IF EXISTS ( SELECT * FROM   sysobjects WHERE  id = object_id(N'[dbo].[QProduction_To_Adm]') and OBJECTPROPERTY(id, N'IsProcedure') = 1 )
begin
DROP Procedure QProduction_To_Adm
end
GO
CREATE Procedure QProduction_To_Adm(@P_ANO as int)                              
as                              
Select A1.ID, A1.TOC, A1.Type, A1.Currency, A1.Date, A1.BillDate, Max(A1.DocNo) as DocNo, A1.RefNo,  
Case When SysTab.SplitPremiumAndClaimF=1 and A1.Code in ('A','R') Then 'Claim' else 'Premium' end as Subject,       
Max(Case When coalesce(AL.RefNo,'')=A1.RefNo and C.ISType<>'T' Then coalesce(AL.AName,Case When A2.AName<>'' then A2.AName else A2.Remarks end) else Case When A2.AName<>'' then A2.AName else A2.Remarks end end) as Remarks,                                 
(Select Top 1 TreatyInstallmentF from reinsurance Where Reinsurance.docNo=A1.RefNo) as TreatyInstallmentF,
Case When (isnull(Payor.ScheduleF,0)=1) or (Case When isnull(APayor.ANO,0)=0 Then (Case When isnull(MPayor.ANO,0)=0 Then Payor.PolicyYearF else MPayor.PolicyYearF end) else APayor.PolicyYearF end)=1 Then A1.SDate else A2.SDate end as SDate,                              
Case When (isnull(Payor.ScheduleF,0)=1) or (Case When isnull(APayor.ANO,0)=0 Then (Case When isnull(MPayor.ANO,0)=0 Then Payor.PolicyYearF else MPayor.PolicyYearF end) else APayor.PolicyYearF end)=1 Then A1.EDate else A2.EDate end as EDate,               
case When coalesce(A1.Source,'')='' or A1.Source<>A1.ID then A2.Source else A1.Source end Source,                              
Case When A1.CAmount=0 and Coalesce(A3.Branch,'')<>'' Then A3.Branch Else A2.Branch end Branch,         
Max(Branch.VAT) as BVATPCT,
min (A1.SDate) as MINSDate, max(A1.SDate) as MAXSDate,                
min (A1.ACNO)  as MinACNO, min (A1.ACNO) as MaxACNO,                          
sum(Case When A1.Code='P' then A1.Amount else 0 end) as Amount_1,                              
sum(Case When A1.Code='C' then A1.Amount else 0 end) as Amount_2,                              
sum(Case When A1.Code='F' and coalesce(coalesce(A1.CodeExt,''),'')='' then A1.Amount else 0 end) as Amount_3,                              
sum(Case When A1.Code='D' and coalesce(A1.CodeExt,'')='' then A1.Amount else 0 end) as Amount_4,                              
sum(Case When A1.Code='O' and coalesce(A1.CodeExt,'')='' then A1.Amount else 0 end) as Amount_5,                              
sum(Case When A1.Code='A' then A1.Amount else 0 end) as Amount_6,                              
sum(Case When A1.Code='O' and coalesce(A1.CodeExt,'')='1' then A1.Amount else 0 end) as Amount_7,                              
sum(Case When A1.Code='O' and coalesce(A1.CodeExt,'')='2' then A1.Amount else 0 end) as Amount_8,                              
sum(Case When A1.Code='R' then A1.Amount else 0 end) as Amount_10,                              
sum(Case When A1.Code='T' then A1.Amount else 0 end) as Amount_14,                              
sum(Case When A1.Code in ('D','F') and coalesce(A1.CodeExt,'')='1' then A1.Amount else 0 end) as Amount_15,            
sum(Case When A1.Code in ('D','F') and coalesce(A1.CodeExt,'')='2' then A1.Amount else 0 end) as Amount_16,            
sum(Case When A1.Code='J' then A1.Amount else 0 end) as Amount_19,    
sum(Case When A1.Code='U' then A1.Amount else 0 end) as Amount_20                              
from AccAss A1                              
Inner Join Acceptance A2 on (A2.ANO=A1.ANO)                              
Inner Join Cover C on (C.CNO=A2.CNO)                  
Left Join Acceptance AL on (AL.ANO=A2.LANO and C.OpenFlag=0)                  
Left Join APayor on (APayor.ANO=A2.ANO and A2.LANO<>-1 and A2.ANO<>A2.LANO)                              
Left Join Payor on (Payor.ANO=A2.ANO and A2.LANO=-1)                 
Left Join Payor MPayor on (MPayor.ANO=A2.LANO and A2.LANO<>-1)                
Left join  Acceptance A3 on (A3.ANO=A2.pANO)    
Inner Join Branch on (Branch.Branch=Case When A1.CAmount=0 and Coalesce(A3.Branch,'')<>'' Then A3.Branch Else A2.Branch end)
Inner Join SysTab on (1=1)                          
Where A1.ANO=@P_ANO                              
Group By A1.ID, A1.TOC, A1.Type, A1.Currency, A1.Date, A1.BillDate, A1.RefNo,                       
Case When SysTab.SplitPremiumAndClaimF=1 and A1.Code in ('A','R') Then 'Claim' else 'Premium' end,
Case When (isnull(Payor.ScheduleF,0)=1) or (Case When isnull(APayor.ANO,0)=0 Then (Case When isnull(MPayor.ANO,0)=0 Then Payor.PolicyYearF else MPayor.PolicyYearF end) else APayor.PolicyYearF end)=1 Then A1.SDate else A2.SDate end,                
Case When (isnull(Payor.ScheduleF,0)=1) or (Case When isnull(APayor.ANO,0)=0 Then (Case When isnull(MPayor.ANO,0)=0 Then Payor.PolicyYearF else MPayor.PolicyYearF end) else APayor.PolicyYearF end)=1 Then A1.EDate else A2.EDate end,
case When coalesce(A1.Source,'')='' or A1.Source<>A1.ID then A2.Source else A1.Source end,                              
Case When A1.CAmount=0 and Coalesce(A3.Branch,'')<>'' Then A3.Branch Else A2.Branch end 

GO

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Premium_Overriding]') AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) ) 
begin
DROP FUNCTION Premium_Overriding 
end
GO


CREATE Function Premium_Overriding(@P_ANO as int,@P_Code as varchar(10),@P_Period Int, @P_MinimumPremiumF Bit)                
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
	  and MParam.Type='B'+AccBS.BSType and (AccBS.BSType='O') and Profile.ID=AccBS.ID          
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
		  and MParam.Type='B'+AccBS.BSType and (AccBS.BSType='O') and Profile.ID=AccBS.ID          
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
		  and MParam.Type='B'+AccBS.BSType and (AccBS.BSType='O') and Profile.ID=AccBS.ID          
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
		  and MParam.Type='B'+AccBS.BSType and (AccBS.BSType='O') and Profile.ID=AccBS.ID          
		  and (AccBS.NotMinimumPremiumF=0 or (AccBS.NotMinimumPremiumF=1 and @P_MinimumPremiumF=0))                      
	 end
 
 END
                        
 if @Commission is null                
   Select @Commission=0                
                        
 return(@Commission)                
End        


GO


IF EXISTS ( SELECT * FROM   sysobjects WHERE  id = object_id(N'[dbo].[Get_Fee_Amount_By_Percentage]') and OBJECTPROPERTY(id, N'IsProcedure') = 1 )
begin
DROP Procedure Get_Fee_Amount_By_Percentage
end
GO
Create Procedure Get_Fee_Amount_By_Percentage(@P_ANO as Int, @P_Code as varchar(10), @P_FDType as varchar(1), @P_AmountPCT as Float, @P_AmountPCTBased as Int=0, @P_PolicyYear as Int=0)
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
			 Case 
			 When @P_AmountPCTBased=0 then
				sum(D1.Gross*(100-D1.Discount)/100*D1.Prorata*P.Gross/P.OGross*P.OurShare/P.TSI)
			 Else
				Max(P.OurShare)
			 End
	    Else
			 Case
			 When @P_AmountPCTBased=0 then
				sum(D1.Gross*P.Gross/P.OGross*P.OurShare/P.TSI*(100-R.MSHARE)/100)
			 Else
				Max(P.OurShare*(100-R.MSHARE)/100)
			 End
		End*@P_AmountPCT/100
		from Display_Calculation(@P_ANO) D1, Acceptance A, PCalc P, RARRHEADER R
		Where P.ANO=A.ANO and P.Currency=D1.Currency and A.ANO=D1.ANO and R.ANO=A.ANO and D1.Currency=@P_Code
		and (D1.ANO=@P_ANO or @P_FDTYPE<>'O')
		and (@P_PolicyYear=0 or (D1.SDate>=dateadd(month,12*(@P_PolicyYear-1),A.SDate) and D1.SDate<dateadd(month,12*(@P_PolicyYear),A.SDate)))

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
					Case
					When @P_AmountPCTBased=0 then
						sum(D1.Gross*(100-D1.Discount)/100*D1.Prorata*P.Gross/P.OGross*P.OurShare/P.TSI)
					Else
						Max(P.OurShare)
					End
				ELSE 
					Case
					When @P_AmountPCTBased=0 then
						sum(D1.Gross*P.Gross/P.OGross*P.OurShare/P.TSI*(100-R.MSHARE)/100)
					Else
						Max(P.OurShare*(100-R.MSHARE)/100)
					End
				End*@P_AmountPCT/100
				from Display_Calculation(ACCEPTANCE.ANO) D1, Acceptance A, PCalc P, RARRHEADER R
				Where P.ANO=A.ANO and P.Currency=D1.Currency and A.ANO=D1.ANO and R.ANO=A.ANO and D1.Currency=@P_Code
				and (D1.ANO=ACCEPTANCE.ANO or @P_FDTYPE<>'O')
				and (@P_PolicyYear=0 or (D1.SDate>=dateadd(month,12*(@P_PolicyYear-1),A.SDate) and D1.SDate<dateadd(month,12*(@P_PolicyYear),A.SDate)))
			) as FEE
			FROM ACCEPTANCE, COVER
			WHERE COVER.CNO=ACCEPTANCE.CNO AND COVER.OPENFLAG=0 AND ACCEPTANCE.ANO<>ACCEPTANCE.LANO AND ACCEPTANCE.LANO=@P_ANO AND ACCEPTANCE.REGNO=@P_REGNO
		) A
SELECT @P_FEE AS FEE

GO


insert into PatchVersioning
select '36.01 Update Script - Update Patch 2017 (Execute Before Kom 2.27)',GETDATE()
go


Declare @PrevScript varchar(100)
Declare @CurrScript varchar(100)

Select @PrevScript='36 Script Komulatif Konsol 2.26'
Select @CurrSCript='36.01 Update Script - Update Patch 2017 (Execute Before Kom 2.27)'


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



