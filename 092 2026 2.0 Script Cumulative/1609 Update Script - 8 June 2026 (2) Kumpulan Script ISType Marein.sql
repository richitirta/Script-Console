DROP function FL_Get_Policy_APRule_Layout
GO
Create function FL_Get_Policy_APRule_Layout(@P_ANO as int)      
RETURNS Table      
AS RETURN      
(   
	Select R.Layout, Max(R.Description) as Description
	from
	(
		Select SysReport.RepName as Layout, SysReport.Description
		from Get_Policy_APRule(@P_ANO) R
		Inner Join SysProcID S on (S.Class=R.Class)
		Inner Join SysReport on (SysReport.Code=S.ProcID)
		Inner Join Acceptance A on (A.ANO=@P_ANO)
		Inner Join Cover C on (C.CNO=A.CNO)
		Inner Join PolicyType on (PolicyType.PolicyType=C.PolicyType)
		Where R.RepName=''
		and S.ValueID1='N'
		and S.ValueiD2=PolicyType.SType
		and S.ValueID3=A.ISType
		and S.VALUEID4=A.TOC

		Union all

		Select S.RepName as Layout, S.Description
		from Get_Policy_APRule(@P_ANO) R
		Inner Join SysProcID S on (S.Class=R.Class)
		Inner Join Acceptance A on (A.ANO=@P_ANO)
		Inner Join Cover C on (C.CNO=A.CNO)
		Inner Join PolicyType on (PolicyType.PolicyType=C.PolicyType)
		Where R.RepName=''
		and S.ValueID1='N'
		and S.ValueiD2=PolicyType.SType
		and S.ValueID3=A.ISType
		and S.VALUEID4=A.TOC
	) R
	Group by R.Layout 
)       

GO
DROP FUNCTION fn_RiskAssLimit
GO
CREATE FUNCTION fn_RiskAssLimit(@P_ANO as int)  
RETURNS TABLE  
AS RETURN (  
SELECT top 1 RiskAss.RiskAss, Case When ReClass.AssessmentExInwardF=1 and Acceptance.ISType in ('R','N','T','Q','S','A','X','P') Then 100 else RiskAss.PLimit end PLimit, Case When ReClass.AssessmentExInwardF=1 and Acceptance.ISType in ('R','N','T','Q','S','A','X','P') Then 100 else RiskAss.Limit end Limit,
Acceptance.ISType, RiskAss.Code, RiskAss.HoldF, RiskAss.Share, RiskAss.Rate, RiskAss.Loading, RiskAss.RType                    
From Acceptance
Inner Join Cover on (Cover.CNO=Acceptance.CNO)
Inner Join AInfo on (AInfo.ANO=Acceptance.ANO)
Inner Join RArrHeader on (RArrHeader.ANO=Acceptance.ANO)
Inner Join Reinsurance on (Reinsurance.RType In ('D','Q','S1','S2','S3','A') and RArrHeader.RDate Between Reinsurance.SDate and Reinsurance.EDate)
Inner Join ReClass on (ReClass.RNO=Reinsurance.RNO and ReClass.TOC=Acceptance.TOC and ReClass.AssessmentF=1)
Left Join RiskAss on (
	Riskass.RYear=Reinsurance.RYear And RiskAss.TOC=ReClass.TOC        
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
WHERE Acceptance.ANO=@P_ANO 
Order by                   
RiskAss.RYear Desc,        
RiskAss.RType Desc,            
RiskAss.PriorityF Desc,                  
len(coalesce(RiskAss.ValueID1,'')) Desc, len(coalesce(RiskAss.ValueID2,'')) Desc, len(coalesce(RiskAss.ValueID3,'')) Desc, len(coalesce(RiskAss.ValueID4,'')) Desc, len(coalesce(RiskAss.ValueID5,'')) Desc,                   
len(coalesce(RiskAss.ValueID6,'')) Desc, len(coalesce(RiskAss.ValueID7,'')) Desc, len(coalesce(RiskAss.ValueID8,'')) Desc, len(coalesce(RiskAss.ValueID9,'')) Desc, len(coalesce(RiskAss.ValueID10,'')) Desc,                   
len(coalesce(RiskAss.ValueID11,'')) Desc, len(coalesce(RiskAss.ValueID12,'')) Desc, len(coalesce(RiskAss.ValueID13,'')) Desc, len(coalesce(RiskAss.ValueID14,'')) Desc, len(coalesce(RiskAss.ValueID15,'')) Desc,                   
RiskAss.Limit Desc, RiskAss.Loading, RiskAss.HoldF        
)  


GO 

DROP function Get_Claim_APRule
GO
Create function Get_Claim_APRule(@P_CNO as int)      
RETURNS Table      
AS RETURN      
(      
	WITH fn_APDRule as (   
		Select AD.RuleID, AD.Class, AD.Version, AD.RepName, AD.ExeName, AH.AutoInforceF, R.ApplyeStampDutyF, AD.NeedEmailF,AD.NeedPrintF, AD.NeedeStampDutyF, AD.PrintLogoF, R.ID, R.DocNo
		from APDRuleH AH 
		INNER JOIN APDRULED AD ON (AD.RULEID=AH.RULEID AND AD.AllowedF=1) 
		INNER JOIN 
		(
			Select AH.RuleID, AD.Class, AD.Version, AD.PrintLogoF, A.ApplyeStampDutyF, Reinsurance.ID, Reinsurance.DocNo
			from APDRuleH AH 
			Inner Join APDRuleD AD on (AD.RULEID=AH.RULEID AND AD.AllowedF=1) 
			CROSS APPLY 	(  
				Select TOP 1 TOC.ApplyeStampDutyF
				from Claim
				Inner Join Acceptance A on (A.ANO=Claim.ANO)
				Inner Join TOC on (TOC.TOC=A.TOC)
				Inner Join Cover C on (C.CNO=A.CNO)
				Inner Join Profile P on (P.ID=C.PHolder)		
				Where Claim.CNO=@P_CNO 
				and (C.PolicyType=AH.PolicyType or AH.PolicyType='<All>')
				and (Claim.ISType=AH.ISType or AH.ISType='<All>')
				and (A.TOC=AH.TOC or AH.TOC='<All>')
				and (A.TOPRO=AH.TOPRO or AH.TOPRO='<All>')  
				and (P.PType=AH.PType or AH.PType='<All>')
				and charindex(Claim.CType,AD.ClaimCType)<>0 and charindex(Claim.CStatus,AD.ClaimCStatus)<>0  	
				and (
					(AH.ApplySegmentF=0 and (C.Segment=AH.Segment or AH.Segment='<All>')) or
					(AH.ApplySegmentF=1 and exists (Select top 1 Ad.Segment from APDRuleD_Segment Ad Where Ad.RuleID=AH.RuleID and Ad.Segment=C.Segment))
				)
				and (
					(AH.ApplyPHolderF=0) or
					(AH.ApplyPHolderF=1 and exists (Select top 1 Ad.ID from APDRuleD_PHolder Ad Where Ad.RuleID=AH.RuleID and Ad.ID=C.PHolder))
				)
				and (
					(AH.ApplyPHolderExF=0) or
					(AH.ApplyPHolderExF=1 and Not exists (Select top 1 Ad.ID from APDRuleD_PHolder Ad Where Ad.RuleID=AH.RuleID and Ad.ID=C.PHolder))
				)
				and (
					(AH.ApplyInsuredF=0) or
					(AH.ApplyInsuredF=1 and exists (Select top 1 Ad.ID from APDRuleD_Insured Ad Where Ad.RuleID=AH.RuleID and Ad.ID=A.AID))
				)
				and (
					(AH.ApplyInsuredExF=0) or
					(AH.ApplyInsuredExF=1 and Not exists (Select top 1 Ad.ID from APDRuleD_Insured Ad Where Ad.RuleID=AH.RuleID and Ad.ID=A.AID))
				)
				and (
					(AH.ApplyBranchF=0) or
					(AH.ApplyBranchF=1 and exists (Select top 1 Ad.Branch from APDRuleD_Branch Ad Where Ad.RuleID=AH.RuleID and Ad.Branch=A.Branch))
				)				
				and (
					(AH.ApplySourceF=0) or
					(AH.ApplySourceF=1 and exists (Select top 1 Ad.ID from APDRuleD_Source Ad Where Ad.RuleID=AH.RuleID and Ad.ID=A.Source))
				)
				and (
					(AH.ApplySourceExF=0) or
					(AH.ApplySourceExF=1 and Not exists (Select top 1 Ad.ID from APDRuleD_Source Ad Where Ad.RuleID=AH.RuleID and Ad.ID=A.Source))
				)
			)  A

			Outer Apply (
				Select RPart.ID, CASE WHEN COALESCE(RPart.DOCNO,'')='' THEN RPart.DOCNO ELSE Reinsurance.DOCNO END AS DOCNO
				from Claim
				Inner join RArrHeader RArr on (RArr.ANO=Claim.ANO)
				Inner Join CArrHeader CArr on (CArr.CNO=Claim.CNO)
				Left Join CArrHeader pCArr on (pCArr .CNO=Claim.pCNO)
				, Reinsurance, RPart
				Where Claim.CNO=@P_CNO 
				and (
					(
					Case When AD.DataExcessPriorityF=1 and ((CArr.EXPAmount<>0 and Claim.CStatus in ('R','P')) or (CArr.XPAmount<>0 and Claim.CStatus in ('T','A'))) then RArr.XPID Else '' end = Reinsurance.RID
					)
					or
					(
					Case When AD.DataAutoFacF=1 and ((CArr.EAAmount<>0 and Claim.CStatus in ('R','P')) or (CArr.AAmount<>0 and Claim.CStatus in ('T','A'))) then RArr.AID Else '' end = Reinsurance.RID
					)
					or
					(
					Case When AD.DataCompulsoryF=1 and ((CArr.ECAmount<>0 and Claim.CStatus in ('R','P')) or (CArr.CAmount<>0 and Claim.CStatus in ('T','A'))) then RArr.CID Else '' end = Reinsurance.RID
					)
					or
					(
					Case When AD.DataDecreeF=1 and ((CArr.EDAmount<>0 and Claim.CStatus in ('R','P')) or (CArr.DAmount<>0 and Claim.CStatus in ('T','A'))) then RArr.DID Else '' end = Reinsurance.RID
					)
					or
					(
					Case When AD.DataTreatyF=1 and 
						(
						(CArr.EQAmount<>0 and Claim.CStatus in ('R','P') and (AD.ApplyTreatyCashLossCombineF=0 or (AD.ApplyTreatyCashLossCombineF=1 and Reinsurance.CASHLOSSCOMBINE<=(CArr.EQAmount+CArr.ESP1Amount+CArr.ESP2Amount++CArr.ESP3Amount)))) 
						or 
						(CArr.QAmount<>0 and Claim.CStatus in ('T','A') and (AD.ApplyTreatyCashLossCombineF=0 or (AD.ApplyTreatyCashLossCombineF=1 and Reinsurance.CASHLOSSCOMBINE<=(CArr.QAmount+CArr.SP1Amount+CArr.SP2Amount++CArr.SP3Amount)))) 
						) then RArr.QID Else '' end = Reinsurance.RID
					)
					or
					(
					Case When AD.DataSurplusF=1 and 
						(
						(CArr.ESP1Amount<>0 and Claim.CStatus in ('R','P') and (AD.ApplyTreatyCashLossCombineF=0 or (AD.ApplyTreatyCashLossCombineF=1 and Reinsurance.CASHLOSSCOMBINE<=(CArr.EQAmount+CArr.ESP1Amount+CArr.ESP2Amount++CArr.ESP3Amount)))) 
						or
						(CArr.SP1Amount<>0 and Claim.CStatus in ('T','A') and (AD.ApplyTreatyCashLossCombineF=0 or (AD.ApplyTreatyCashLossCombineF=1 and Reinsurance.CASHLOSSCOMBINE<=(CArr.QAmount+CArr.SP1Amount+CArr.SP2Amount++CArr.SP3Amount)))) 
						) then RArr.SP1ID Else '' end = Reinsurance.RID
					)
					or
					(
					Case When AD.DataSurplusF=1 and 
						(
						(CArr.ESP2Amount<>0 and Claim.CStatus in ('R','P') and (AD.ApplyTreatyCashLossCombineF=0 or (AD.ApplyTreatyCashLossCombineF=1 and Reinsurance.CASHLOSSCOMBINE<=(CArr.EQAmount+CArr.ESP1Amount+CArr.ESP2Amount++CArr.ESP3Amount)))) 
						or
						(CArr.SP2Amount<>0 and Claim.CStatus in ('T','A') and (AD.ApplyTreatyCashLossCombineF=0 or (AD.ApplyTreatyCashLossCombineF=1 and Reinsurance.CASHLOSSCOMBINE<=(CArr.QAmount+CArr.SP1Amount+CArr.SP2Amount++CArr.SP3Amount)))) 
						) then RArr.SP2ID Else '' end = Reinsurance.RID
					)
					or
					(
					Case When AD.DataSurplusF=1 and 
						(
						(CArr.ESP3Amount<>0 and Claim.CStatus in ('R','P') and (AD.ApplyTreatyCashLossCombineF=0 or (AD.ApplyTreatyCashLossCombineF=1 and Reinsurance.CASHLOSSCOMBINE<=(CArr.EQAmount+CArr.ESP1Amount+CArr.ESP2Amount++CArr.ESP3Amount)))) 
						or
						(CArr.SP3Amount<>0 and Claim.CStatus in ('T','A') and (AD.ApplyTreatyCashLossCombineF=0 or (AD.ApplyTreatyCashLossCombineF=1 and Reinsurance.CASHLOSSCOMBINE<=(CArr.QAmount+CArr.SP1Amount+CArr.SP2Amount++CArr.SP3Amount)))) 
						) then RArr.SP3ID Else '' end = Reinsurance.RID
					)
					or
					(
					Case When AD.DataXOLF=1 and ((CArr.XL1EAmount<>0 and Claim.CStatus in ('R','P')) or (CArr.XL1Amount<>0 and Claim.CStatus in ('T','A'))) then CArr.XL1ID  Else '' end = Reinsurance.RID
					)
					or
					(
					Case When AD.DataXOLF=1 and ((CArr.XL2EAmount<>0 and Claim.CStatus in ('R','P')) or (CArr.XL2Amount<>0 and Claim.CStatus in ('T','A'))) then CArr.XL2ID  Else '' end = Reinsurance.RID
					)
					or
					(
					Case When AD.DataXOLF=1 and ((CArr.XL3EAmount<>0 and Claim.CStatus in ('R','P')) or (CArr.XL3Amount<>0 and Claim.CStatus in ('T','A'))) then CArr.XL3ID  Else '' end = Reinsurance.RID
					)
					or
					(
					Case When AD.DataXOLF=1 and ((CArr.XL4EAmount<>0 and Claim.CStatus in ('R','P')) or (CArr.XL4Amount<>0 and Claim.CStatus in ('T','A'))) then CArr.XL4ID  Else '' end = Reinsurance.RID
					)
					or
					(
					Case When AD.DataXOLF=1 and ((CArr.XL5EAmount<>0 and Claim.CStatus in ('R','P')) or (CArr.XL5Amount<>0 and Claim.CStatus in ('T','A'))) then CArr.XL5ID  Else '' end = Reinsurance.RID
					)
					or
					(
					Case When AD.DataXOLF=1 and ((CArr.XL6EAmount<>0 and Claim.CStatus in ('R','P')) or (CArr.XL6Amount<>0 and Claim.CStatus in ('T','A'))) then CArr.XL6ID  Else '' end = Reinsurance.RID
					)
					or
					(
					Case When AD.DataXOLF=1 and ((CArr.XL7EAmount<>0 and Claim.CStatus in ('R','P')) or (CArr.XL7Amount<>0 and Claim.CStatus in ('T','A'))) then CArr.XL7ID  Else '' end = Reinsurance.RID
					)
				)
				and RPart.RNO=Reinsurance.RNO

				Union All

				Select FPart.ID, FPart.SlipNO AS DOCNO
				from Claim, CArrHeader, RArrDet, FPart
				Where Claim.CNO=@P_CNO and CArrHeader.CNO=Claim.CNO 
				and (
					(
					AD.DataFacultativeF=1 and ((CArrHeader.EFAmount<>0 and Claim.CStatus in ('R','P')) or (CArrHeader.FAmount<>0 and Claim.CStatus in ('T','A'))) 
					)
				)
				and RArrDet.ANO=Claim.ANO and FPart.ANO=RArrDet.ANO and FPart.FID=RArrDet.FID and RArrDet.Status='A'
			) Reinsurance
			Where AH.AllowedF=1 AND AH.APPTYPE='CLAIM'  
			and ((AD.DataFacultativeF=0 and AD.DataAutoFacF=0 and AD.DataExcessPriorityF=0 and AD.DataTreatyF=0) or coalesce(Reinsurance.DocNo,'')<>'')
		) R ON (AD.RuleID=R.RuleID and AD.Class=R.Class and AD.Version=R.Version and AD.PrintLogoF=R.PrintLogoF)
	)

	Select A.*
	from fn_APDRule A
	Inner Join (
		Select Top 1 A.RuleID
		from APDRuleH A
		Inner Join fn_APDRule B on (B.RuleID=A.RuleID)
		Order by A.PriorityF Desc, A.RuleID
	) B on (A.RuleID=B.RuleID)

)   

GO

DROP function Get_Policy_APRule
GO
Create function Get_Policy_APRule(@P_ANO as int)        
RETURNS Table        
AS RETURN        
(     
 WITH fn_APDRule as (           
   Select AD.RuleID, AD.Class, AD.Version, AD.PrintLogoF, AD.RepName, AD.ExeName, AH.AutoInforceF, R.ApplyeStampDutyF, AD.NeedEmailF, AD.NeedPrintF, AD.NeedeStampDutyF, AD.EmailTo as EmailTo, AD.ShowPremiumCalcF, AD.ShowDiscountF, AD.NeedESignF  
   from APDRuleH AH   
   INNER JOIN APDRULED AD ON (AD.RULEID=AH.RULEID AND AD.AllowedF=1)   
   INNER JOIN   
   (  
    Select AH.RuleID, AD.Class, AD.Version, AD.PrintLogoF, A.ApplyeStampDutyF  
    from APDRuleH AH   
    Inner Join APDRuleD AD on (AD.RULEID=AH.RULEID AND AD.AllowedF=1)   
    CROSS APPLY  
    (    
			Select TOP 1 TOC.ApplyeStampDutyF  
			from Acceptance A  
			Inner Join TOC on (TOC.TOC=A.TOC)  
			Inner Join Cover C on (C.CNO=A.CNO)  
			Inner Join Profile P on (P.ID=C.PHolder)  
			Where A.ANO=@P_ANO   
			and (C.PolicyType=AH.PolicyType or AH.PolicyType='<All>')  
			and (A.ISType=AH.ISType or AH.ISType='<All>')  
			and (TOC.TOC=AH.TOC or TOC.COB=AH.TOC or AH.TOC='<All>')  
			and Not (TOC.TOC=AH.ExTOC or TOC.COB=AH.ExTOC)  
			and (A.TOPRO=AH.TOPRO or AH.TOPRO='<All>')    
			and (P.PType=AH.PType or AH.PType='<All>')  
			and charindex(A.AType,AD.AccAType)<>0  and charindex(A.AStatus,AD.AccAStatus)<>0  and charindex(C.CStatus,AD.CoverCStatus)<>0    
			and (  
			-- Mapping Data with SysClass  
			(AD.Class='CD' and exists (Select Top 1 A1.Type from AccAss A1 Where A1.ANO=A.ANO and A1.Type in ('BB','BA','BO','BC','BP','BD')))  
			or  
			(AD.Class<>'CD')  
			)  
			and (
				(AH.ApplySegmentF=0 and (C.Segment=AH.Segment or AH.Segment='<All>')) or
				(AH.ApplySegmentF=1 and exists (Select top 1 Ad.Segment from APDRuleD_Segment Ad Where Ad.RuleID=AH.RuleID and Ad.Segment=C.Segment))
			)
			and (
				(AH.ApplyPHolderF=0) or
				(AH.ApplyPHolderF=1 and exists (Select top 1 Ad.ID from APDRuleD_PHolder Ad Where Ad.RuleID=AH.RuleID and Ad.ID=C.PHolder))
			)
			and (
				(AH.ApplyPHolderExF=0) or
				(AH.ApplyPHolderExF=1 and Not exists (Select top 1 Ad.ID from APDRuleD_PHolder Ad Where Ad.RuleID=AH.RuleID and Ad.ID=C.PHolder))
			)
			and (
				(AH.ApplyInsuredF=0) or
				(AH.ApplyInsuredF=1 and exists (Select top 1 Ad.ID from APDRuleD_Insured Ad Where Ad.RuleID=AH.RuleID and Ad.ID=A.AID))
			)
			and (
				(AH.ApplyInsuredExF=0) or
				(AH.ApplyInsuredExF=1 and Not exists (Select top 1 Ad.ID from APDRuleD_Insured Ad Where Ad.RuleID=AH.RuleID and Ad.ID=A.AID))
			)
			and (
				(AH.ApplyBranchF=0) or
				(AH.ApplyBranchF=1 and exists (Select top 1 Ad.Branch from APDRuleD_Branch Ad Where Ad.RuleID=AH.RuleID and Ad.Branch=A.Branch))
			)			
			and (
				(AH.ApplySourceF=0) or
				(AH.ApplySourceF=1 and exists (Select top 1 Ad.ID from APDRuleD_Source Ad Where Ad.RuleID=AH.RuleID and Ad.ID=A.Source))
			)
			and (
				(AH.ApplySourceExF=0) or
				(AH.ApplySourceExF=1 and Not exists (Select top 1 Ad.ID from APDRuleD_Source Ad Where Ad.RuleID=AH.RuleID and Ad.ID=A.Source))
			) 
    )  A  
    Where AH.AllowedF=1 AND AH.APPTYPE='POLICY'    
   ) R ON (AD.RuleID=R.RuleID and AD.Class=R.Class and AD.Version=R.Version and AD.PrintLogoF=R.PrintLogoF)  
 )  
  
 Select A.*  
 from fn_APDRule A  
 Inner Join (  
	  Select Top 1 A.RuleID  
	  from APDRuleH A  
	  Inner Join fn_APDRule B on (B.RuleID=A.RuleID)  
	  Order by A.PriorityF Desc, A.RuleID  
 ) B on (A.RuleID=B.RuleID)  
)         

GO
DROP FUNCTION PREMIUM_CALCULATION
GO
CREATE FUNCTION PREMIUM_CALCULATION(@P_ANO int)                  
RETURNS TABLE  AS                  
RETURN (                  

Select ANO, Currency,
sum(Premium) as Premium,
sum(Commission) as Commission,
sum(Discount) as Discount,
dbo.roundCCY(sum(VAT),Currency) as VAT,
dbo.roundCCY(sum(TAX),Currency) as TAX,
Sum(FeeDuty) as FeeDuty      
from
(
	Select T.ANO, T.Code, T.SDate, T.EDate, T.Currency,   
	sum(T.Premium-Case When T.NoRefundF=7 Then T.Premium*coalesce(T1.Commission,0)/100 else 0 end) as Premium,           
	sum(Case When T.NoRefundF=7 Then 0 else T.Premium*coalesce(T1.Commission,0)/100 end) as Commission,           
	sum(T.Premium*dbo.Premium_Discount(T.CANO,Code,PolicyYear)/100) as Discount,           
	sum(Case When T.NoRefundF=7 Then 0 else T.Premium*coalesce(T1.VAT,0)/100 end) as Vat,           
	sum(Case When T.NoRefundF=7 Then 0 else -T.Premium*coalesce(T1.TAX,0)/100 end) as Tax,           
	cast(0 as Float) as FeeDuty      
	
	from PREMIUM_CALCULATION_BASE(@P_ANO) T           
	Outer Apply (
		Select 
		sum(Case When coalesce(T2.NoRefundF, T1.NoRefundF)=0 Then T1.Commission else 0 end) as Commission,
		sum(
			Case 
			When coalesce(T2.NoRefundF, T1.NoRefundF)=0 Then 
				T1.Commission 
				*(Case When (Case When (coalesce(Profile.VATESDate,'01/01/1900')<= A.ADate and coalesce(Profile.VatEEDate,'01/01/1900')>= A.ADate) Then cast(0 as Bit) else Profile.VatF end)=1 Then (case when A.ADate<MParam.Effective then MParam.VatOLD else MParam.Vat end)/100 else 0 end)   
				*(Case   
					When SysTab.TaxMethod in (3) Then  
						case When RateTab.VATCommissionF=1 and (Case When A.ISType not in ('R','N','T','Q','S','A','X','P') or Profile.VATCOMMEXEMPTIF=0 Then cast(1 as Bit) Else 0 END)=1 then 1 else 0 end    	
					Else
						1
				 End) 
			else 0 
			end) as VAT,
		sum(
			Case 
			When coalesce(T2.NoRefundF, T1.NoRefundF)=0 Then 
				T1.Commission 
				*(Case When (Case When (coalesce(Profile.TaxHSDate,'01/01/1900')<= A.ADate and coalesce(Profile.TaxHEDate,'01/01/1900')>= A.ADate) Then cast(0 as Bit) else Profile.TaxF end)=1 Then (Case When TaxType.MTaxType='PASAL21' then MParam.Pasal21*(100-MParam.TaxDiscount)/100 When TaxType.MTaxType='PASAL23' then MParam.Pasal23 When TaxType.MTaxType='PASAL26' then MParam.Pasal26 When TaxType.MTaxType='PASAL4' then MParam.Pasal4 else TaxType.TaxRate end)/100*(Case When Profile.TaxPCT=0 Then 1 else TaxPCT/100 end) else 0 end)    
			else 0 
			end) as TAX
		from Premium_Commission_Table(T.CANO,T.Code,T.PolicyYear,T.MinimumPremiumF) T1
		Left Join Premium_Commission_Table(@P_ANO,T.Code,T.PolicyYear,T.MinimumPremiumF) T2 on (T2.ID=T1.ID and T2.OBSType=T1.BSType)
		Inner Join Acceptance A on (A.ANO=@P_ANO)
		Inner Join MParam on (MParam.Type='B'+T1.BSType)
		Inner Join Profile on (Profile.ID=T1.ID)
		Inner Join RateTab on (RateTab.Code=T.Code)
		Inner Join SysTab on (1=1)
		Left Join TaxType on (TaxType.TaxType=Profile.TaxType)
	) T1
	Group By T.ANO, T.Code, T.SDate, T.EDate, T.Currency          

	Union All                  
                                 
	select A3.ANO, AccAss.RCode as Code, AccAss.SDate, AccAss.EDate, AccAss.Currency_OC as Currency,                  
	sum(Case When AccAss.Code in ('P','U') then (Case When A3.AType='A' and AccAss.AdjMethod='OVERLIMIT' then -AccAss.CAmount*(Case When A3.CPCT<>0 Then A3.CPCT/100 else 1 end)/(Case When AccAss.PProrata<>0 Then AccAss.PProrata else 1 end) else -AccAss.Amount_OC end)*(Case When AccAss.Type='DI' then 100/(100-coalesce(Coinsurance.MShare,0)) else 1 end) else 0 end) as Premium,                  
	sum(Case When AccAss.Code='C' then (Case When A3.AType='A' and AccAss.AdjMethod='OVERLIMIT' then AccAss.CAmount*(Case When A3.CPCT<>0 Then A3.CPCT/100 else 1 end)/(Case When AccAss.PProrata<>0 Then AccAss.PProrata else 1 end) else AccAss.Amount_OC end)*(Case When AccAss.Type='DI' then 100/(100-coalesce(Coinsurance.MShare,0)) else 1 end) else 0 end) as Commission,                  
	sum(Case When AccAss.Code='O' then (Case When A3.AType='A' and AccAss.AdjMethod='OVERLIMIT' then AccAss.CAmount*(Case When A3.CPCT<>0 Then A3.CPCT/100 else 1 end)/(Case When AccAss.PProrata<>0 Then AccAss.PProrata else 1 end) else AccAss.Amount_OC end)*(Case When AccAss.Type='DI' then 100/(100-coalesce(Coinsurance.MShare,0)) else 1 end) else 0 end) as Discount,                  
	sum((Case When A3.AType='A' and AccAss.AdjMethod='OVERLIMIT' then AccAss.CAmount*(Case When A3.CPCT<>0 Then A3.CPCT/100 else 1 end)/(Case When AccAss.PProrata<>0 Then AccAss.PProrata else 1 end) else AccAss.Amount_OC end)*(Case When AccAss.Type='DI' then 100/(100-coalesce(Coinsurance.MShare,0)) else 1 end)*(Case When (Case When (coalesce(Profile.VATESDate,'01/01/1900')<= A2.ADate and coalesce(Profile.VatEEDate,'01/01/1900')>= A2.ADate) Then cast(0 as Bit) else Profile.VatF end)=1 Then MParam.Vat/100 else 0 end)) as Vat,                  
	sum(-(Case When A3.AType='A' and AccAss.AdjMethod='OVERLIMIT' then AccAss.CAmount*(Case When A3.CPCT<>0 Then A3.CPCT/100 else 1 end)/(Case When AccAss.PProrata<>0 Then AccAss.PProrata else 1 end) else AccAss.Amount_OC end)*(Case When AccAss.Type='DI' then 100/(100-coalesce(Coinsurance.MShare,0)) else 1 end)*(Case When (Case When (coalesce(Profile.TaxHSDate,'01/01/1900')<= A2.ADate and coalesce(Profile.TaxHEDate,'01/01/1900')>= A2.ADate) Then cast(0 as Bit) else Profile.TaxF end)=1 Then (Case When TaxType.MTaxType='PASAL21' Then (Case When MParam.UseTaxTypeF=0 Then MParam.PASAL21 Else TaxType.TaxRate End)/100*(100-MParam.TaxDiscount)/100 When TaxType.MTaxType='PASAL23' Then (Case When MParam.UseTaxTypeF=0 Then MParam.PASAL23 Else TaxType.TaxRate End)/100 When TaxType.MTaxType='PASAL26' Then (Case When MParam.UseTaxTypeF=0 Then MParam.PASAL26 Else TaxType.TaxRate End)/100 When TaxType.MTaxType='PASAL4' Then (Case When MParam.UseTaxTypeF=0 Then MParam.PASAL4 Else TaxType.TaxRate End)/100 else 0 end)*(Case When Profile.TaxPCT=0 Then 1 else Profile.TaxPCT/100 end) else Profile.AccruedTax/100 end)) as Tax,      
	sum(Case When AccAss.Code in ('F','D') then -AccAss.Amount_OC else 0 end) as FeeDuty      

	From Acceptance A2 
	inner join AccAss on (AccAss.ANO=A2.ANO)     
	Left join Acceptance pA2  on (pA2.ANO=A2.pANO)     
	Outer Apply (Select Top 1 A.UseCurrTypeF, A.BSType from AccBS A, Acceptance oA Where oA.OANO=A2.OANO and A.ANO=oA.ANO and A.ANO>=A2.ANO and A.UseCurrTypeF=1 and A.ID=AccAss.ID and A.BSType<>A.OBSType and A.OBSType=substring(AccAss.Type,2,1) Order by A.ANO) A4
	Outer Apply (Select Top 1 A.UseCurrTypeF, A.BSType from AAccBS A, Acceptance oA Where oA.OANO=A2.OANO and A.ANO=oA.ANO and A.ANO>=A2.ANO and A.UseCurrTypeF=1 and A.ID=AccAss.ID and A.BSType<>A.OBSType and A.OBSType=substring(AccAss.Type,2,1) Order by A.ANO) A5
	Outer Apply (Select Top 1 A.UseCurrTypeF, A.BSType from AccBS A, Acceptance oA Where oA.OANO=A2.OANO and A.ANO=oA.ANO and A.ANO>=A2.LANO and A.UseCurrTypeF=1 and A.ID=AccAss.ID and A.BSType<>A.OBSType and A.OBSType=substring(AccAss.Type,2,1) Order by A.ANO) A6
	inner join Profile on (Profile.ID=AccAss.ID)      
	Left Join TaxType on (TaxType.TaxType=Profile.TaxType)
	inner join MParam on (MParam.Type=
				Case 
				When coalesce(A5.UseCurrTypeF, coalesce(A4.UseCurrTypeF, coalesce(A6.UseCurrTypeF, Cast(0 as Bit))))=1 and AccAss.Type in ('BB','BA','BO','BC','BP','BD') then
					'B'+coalesce(A5.BSType, coalesce(A4.BSType, coalesce(A6.BSType,'')))
				else
					AccAss.Type
				end
	)	
	Left Join (Select CNO, sum(Share) as MShare from Coinsurance Where PCollectionF=0 Group by CNO) Coinsurance on (Coinsurance.CNO=A2.CNO)      
	Cross Apply (
		Select Top 1 A1.ANO, A1.OANO, A1.CPCT, A1.AType, A1.EMethod, A1.PANO, A1.PDate, A1.PPDate, A2.PDate as CPDate, coalesce(A2.ANO,0) as CANO,
		coalesce((Select Top 1 PANO from Acceptance A3 Where A3.OANO=A1.OANO and A3.Astatus<>'C' and A3.AType='A' and A3.ANO<@P_ANO Order By A3.PANO Desc), A1.PANO) as PADJANO
		from Acceptance A1
		Left Join RArrHeader R on (R.ANO=A1.ANO)
		Outer Apply (Select Top 1 A2.ANO, A2.PDate from Acceptance A2 Where A2.OANO=A1.OANO and A2.Atype='C' and A2.EMethod='A' and A2.ANO<@P_ANO Order by A2.ANO Desc) A2
		Where A1.ANO=@P_ANO
		Order By A1.OANO, A2.ANO Desc
	) A3 
	Where A2.OANO=A3.OANO and A2.ANO<@P_ANO
	and 
	( 
		(
		A3.AType='A' and
		(    
			(  
			pA2.ANO=A3.PANO and A3.PDate<=(Case When pA2.PDate<pA2.SDate then pA2.SDate else pA2.PDate End) and A3.PPDate>=(Case When pA2.PPDate<pA2.SDate then pA2.SDate else pA2.PPDate End) and (A2.AType='E' and coalesce(pA2.AType,'') in ('N','E'))   
			and AccAss.AdjustableF=1 and AccAss.AdjMethod<>'OVERLIMIT' and AccAss.CAmount=0  
			and pA2.ANO<=A3.PADJANO 
			)     
			or   
			(  
			A2.ANO<=A3.PANO and A3.PDate<=(Case When A2.PDate<A2.SDate then A2.SDate else A2.PDate End) and A3.PPDate>=(Case When A2.PPDate<A2.SDate then A2.SDate else A2.PPDate End) and (A2.AType<>'A' and coalesce(pA2.AType,'')<>'A')   
			and AccAss.AdjustableF=1 and AccAss.AdjMethod<>'OVERLIMIT'  
			and A2.ANO<=A3.PADJANO and A2.PANO<>A3.PADJANO and AccAss.CAmount<>0
			)     
			or   
			(  
			A2.ANO<=A3.PANO and A3.PDate<=(Case When pA2.PDate<pA2.SDate then pA2.SDate else pA2.PDate End) and A3.PPDate>=(Case When pA2.PPDate<pA2.SDate then pA2.SDate else pA2.PPDate End) and (A2.AType<>'A' and coalesce(pA2.AType,'')<>'A')   
			and AccAss.AdjustableF=1 and AccAss.AdjMethod<>'OVERLIMIT'  
			and A2.ANO<=A3.PADJANO and A2.PANO<>A3.PADJANO and AccAss.CAmount=0
			)   
			or   
			(  
			A2.ANO<=A3.PANO and A3.PDate<=(Case When A2.PDate<A2.SDate then A2.SDate else A2.PDate End) and A3.PPDate>=(Case When A2.PPDate<A2.SDate then A2.SDate else A2.PPDate End) and (A2.AType<>'A' and coalesce(pA2.AType,'')<>'A')   
			and AccAss.AdjustableF=1 and AccAss.AdjMethod<>'OVERLIMIT' and AccAss.CAmount<>0  
			and A2.PANO=A3.PADJANO
			)     
			or   
			(  
			A2.ANO<=A3.PANO and A3.PDate<=(Case When A2.PDate<A2.SDate then A2.SDate else A2.PDate End) and A3.PPDate>=(Case When A2.PPDate<A2.SDate then A2.SDate else A2.PPDate End) and A2.PDATE<A2.PPDATE and (A2.AType<>'A' and coalesce(pA2.AType,'')<>'A')   
			and AccAss.AdjustableF=1 and AccAss.AdjMethod='OVERLIMIT' and AccAss.CAmount<>0  
			and NOT EXISTS (Select Top 1 PANO from Acceptance A3 Where A3.OANO=A3.OANO and A3.PANO=A2.ANO and A3.Astatus<>'C' and A3.AType='A' and A3.ANO<@P_ANO)  
			)     
		)
		)
		or    
		(  
		--Cancel All
		A3.AType='C' and A3.EMethod='A'and 
		(
		(
		case when A2.ANO<=A3.CANO and A2.PDate>coalesce(A3.CPDate,A2.PDate) Then coalesce(A3.CPDate,A2.PDate) else A2.PDate end>=A3.PDate and AccAss.CAmount<>0
		) 
		or 
		(
		case when A2.ANO<=A3.CANO and coalesce(pA2.pDate,A2.PDate)>coalesce(A3.CPDate,coalesce(pA2.pDate,A2.PDate)) Then coalesce(A3.CPDate,coalesce(pA2.pDate,A2.PDate)) else coalesce(pA2.pDate,A2.PDate) end>=A3.PDate and AccAss.CAmount=0
		)
		)
		)  
		or
		(
		--Adjustment Cancel
		A3.AType='C' and A2.AType='A' and A2.ANO=A3.PANO
		)
	)     	                  
	and 
	(
	(AccAss.Type in ('DI','IC','IR','IT','IX') and AccAss.Code='P') 
	or (AccAss.Type in ('DI','IC') and AccAss.Code='U') 
	Or (AccAss.Type in ('BB','BA','BO','BC','BP','BD') and AccAss.Code='C') 
	or (AccAss.Type in ('DI','IC','IR','IT','IX') and AccAss.Code='O') 
	or (A3.AType='C' and A3.EMethod='A' and AccAss.Type in ('DI') and AccAss.Code in ('F','D'))
	)                  
	Group By A3.ANO, AccAss.RCode, AccAss.SDate, AccAss.EDate, AccAss.Currency_OC
) T          
Group by ANO, Currency


)       
GO

DROP FUNCTION PREMIUM_CALCULATION_BY_RATECODE
GO
CREATE FUNCTION PREMIUM_CALCULATION_BY_RATECODE(@P_ANO int)                  
RETURNS TABLE  AS                  
RETURN (                  

Select ANO, Code, Currency,
sum(Premium) as Premium,
sum(Commission) as Commission,
sum(Discount) as Discount,
dbo.roundCCY(sum(VAT),Currency) as VAT,
dbo.roundCCY(sum(TAX),Currency) as TAX,
Sum(FeeDuty) as FeeDuty      
from
(
	Select T.ANO, T.Code, T.SDate, T.EDate, T.Currency,   
	sum(Premium-Case When NoRefundF=7 Then Premium*coalesce(T1.Commission,0)/100 else 0 end) as Premium,           
	sum(Case When NoRefundF=7 Then 0 else Premium*coalesce(T1.Commission,0)/100 end) as Commission,           
	sum(Premium*dbo.Premium_Discount(CANO,Code,PolicyYear)/100) as Discount,           
	sum(Case When NoRefundF=7 Then 0 else Premium*coalesce(T1.VAT,0)/100 end) as Vat,           
	sum(Case When NoRefundF=7 Then 0 else -Premium*coalesce(T1.TAX,0)/100 end) as Tax,           
	cast(0 as Float) as FeeDuty      
	
	from PREMIUM_CALCULATION_BASE(@P_ANO) T                   
	Outer Apply (
		Select 
		sum(Case When coalesce(T2.NoRefundF, T1.NoRefundF)=0 Then T1.Commission else 0 end) as Commission,
		sum(
			Case 
			When coalesce(T2.NoRefundF, T1.NoRefundF)=0 Then 
				T1.Commission 
				*(Case When (Case When (coalesce(Profile.VATESDate,'01/01/1900')<= T1.ADate and coalesce(Profile.VatEEDate,'01/01/1900')>= T1.ADate) Then cast(0 as Bit) else Profile.VatF end)=1 Then (case when T1.ADate<MParam.Effective then MParam.VatOLD else MParam.Vat end)/100 else 0 end)   
				*(Case   
					When SysTab.TaxMethod in (3) Then  
						case When RateTab.VATCommissionF=1 and (Case When A.ISType not in ('R','N','T','Q','S','A','X','P') or Profile.VATCOMMEXEMPTIF=0 Then cast(1 as Bit) Else 0 END)=1 then 1 else 0 end    	
					Else
						1
				 End) 
			else 0 
			end) as VAT,
		sum(
			Case 
			When coalesce(T2.NoRefundF, T1.NoRefundF)=0 Then 
				T1.Commission 
				*(Case When (Case When (coalesce(Profile.TaxHSDate,'01/01/1900')<= T1.ADate and coalesce(Profile.TaxHEDate,'01/01/1900')>= T1.ADate) Then cast(0 as Bit) else Profile.TaxF end)=1 Then (Case When TaxType.MTaxType='PASAL21' then MParam.Pasal21*(100-MParam.TaxDiscount)/100 When TaxType.MTaxType='PASAL23' then MParam.Pasal23 When TaxType.MTaxType='PASAL26' then MParam.Pasal26 When TaxType.MTaxType='PASAL4' then MParam.Pasal4 else TaxType.TaxRate end)/100*(Case When Profile.TaxPCT=0 Then 1 else TaxPCT/100 end) else 0 end)    
			else 0 
			end) as TAX
		from Premium_Commission_Table(T.CANO,T.Code,T.PolicyYear,T.MinimumPremiumF) T1
		Left Join Premium_Commission_Table(@P_ANO,T.Code,T.PolicyYear,T.MinimumPremiumF) T2 on (T2.ID=T1.ID and T2.OBSType=T1.BSType)
		Inner Join Acceptance A on (A.ANO=@P_ANO)
		Inner Join MParam on (MParam.Type='B'+T1.BSType)
		Inner Join Profile on (Profile.ID=T1.ID)
		Inner Join RateTab on (RateTab.Code=T.Code)
		Inner Join SysTab on (1=1)
		Left Join TaxType on (TaxType.TaxType=Profile.TaxType)
	) T1
	Group By T.ANO, T.Code, T.SDate, T.EDate, T.Currency          

	Union All                  
                                 
	select A3.ANO, AccAss.RCode as Code, AccAss.SDate, AccAss.EDate, AccAss.Currency_OC as Currency,                  
	sum(Case When AccAss.Code in ('P','U') then (Case When A3.AType='A' and AccAss.AdjMethod='OVERLIMIT' then -AccAss.CAmount*(Case When A3.CPCT<>0 Then A3.CPCT/100 else 1 end)/(Case When AccAss.PProrata<>0 Then AccAss.PProrata else 1 end) else -AccAss.Amount_OC end)*(Case When AccAss.Type='DI' then 100/(100-coalesce(Coinsurance.MShare,0)) else 1 end) else 0 end) as Premium,                  
	sum(Case When AccAss.Code='C' then (Case When A3.AType='A' and AccAss.AdjMethod='OVERLIMIT' then AccAss.CAmount*(Case When A3.CPCT<>0 Then A3.CPCT/100 else 1 end)/(Case When AccAss.PProrata<>0 Then AccAss.PProrata else 1 end) else AccAss.Amount_OC end)*(Case When AccAss.Type='DI' then 100/(100-coalesce(Coinsurance.MShare,0)) else 1 end) else 0 end) as Commission,     
	sum(Case When AccAss.Code='O' then (Case When A3.AType='A' and AccAss.AdjMethod='OVERLIMIT' then AccAss.CAmount*(Case When A3.CPCT<>0 Then A3.CPCT/100 else 1 end)/(Case When AccAss.PProrata<>0 Then AccAss.PProrata else 1 end) else AccAss.Amount_OC end)*(Case When AccAss.Type='DI' then 100/(100-coalesce(Coinsurance.MShare,0)) else 1 end) else 0 end) as Discount,                  
	sum((Case When A3.AType='A' and AccAss.AdjMethod='OVERLIMIT' then AccAss.CAmount*(Case When A3.CPCT<>0 Then A3.CPCT/100 else 1 end)/(Case When AccAss.PProrata<>0 Then AccAss.PProrata else 1 end) else AccAss.Amount_OC end)*(Case When AccAss.Type='DI' then 100/(100-coalesce(Coinsurance.MShare,0)) else 1 end)*(Case When (Case When (coalesce(Profile.VATESDate,'01/01/1900')<= A2.ADate and coalesce(Profile.VatEEDate,'01/01/1900')>= A2.ADate) Then cast(0 as Bit) else Profile.VatF end)=1 Then MParam.Vat/100 else 0 end)) as Vat,                  
	sum(-(Case When A3.AType='A' and AccAss.AdjMethod='OVERLIMIT' then AccAss.CAmount*(Case When A3.CPCT<>0 Then A3.CPCT/100 else 1 end)/(Case When AccAss.PProrata<>0 Then AccAss.PProrata else 1 end) else AccAss.Amount_OC end)*(Case When AccAss.Type='DI' then 100/(100-coalesce(Coinsurance.MShare,0)) else 1 end)*(Case When (Case When (coalesce(Profile.TaxHSDate,'01/01/1900')<= A2.ADate and coalesce(Profile.TaxHEDate,'01/01/1900')>= A2.ADate) Then cast(0 as Bit) else Profile.TaxF end)=1 Then (Case When TaxType.MTaxType='PASAL21' Then (Case When MParam.UseTaxTypeF=0 Then MParam.PASAL21 Else TaxType.TaxRate End)/100*(100-MParam.TaxDiscount)/100 When TaxType.MTaxType='PASAL23' Then (Case When MParam.UseTaxTypeF=0 Then MParam.PASAL23 Else TaxType.TaxRate End)/100 When TaxType.MTaxType='PASAL26' Then (Case When MParam.UseTaxTypeF=0 Then MParam.PASAL26 Else TaxType.TaxRate End)/100 When TaxType.MTaxType='PASAL4' Then (Case When MParam.UseTaxTypeF=0 Then MParam.PASAL4 Else TaxType.TaxRate End)/100 else 0 end)*(Case When Profile.TaxPCT=0 Then 1 else Profile.TaxPCT/100 end) else Profile.AccruedTax/100 end)) as Tax,      
	sum(Case When AccAss.Code in ('F','D') then -AccAss.Amount_OC else 0 end) as FeeDuty      

	From Acceptance A2 
	inner join AccAss on (AccAss.ANO=A2.ANO)     
	Left join Acceptance pA2  on (pA2.ANO=A2.pANO)     
	Outer Apply (Select Top 1 A.UseCurrTypeF, A.BSType from AccBS A, Acceptance oA Where oA.OANO=A2.OANO and A.ANO=oA.ANO and A.ANO>=A2.ANO and A.UseCurrTypeF=1 and A.ID=AccAss.ID and A.BSType<>A.OBSType and A.OBSType=substring(AccAss.Type,2,1) Order by A.ANO) A4
	Outer Apply (Select Top 1 A.UseCurrTypeF, A.BSType from AAccBS A, Acceptance oA Where oA.OANO=A2.OANO and A.ANO=oA.ANO and A.ANO>=A2.ANO and A.UseCurrTypeF=1 and A.ID=AccAss.ID and A.BSType<>A.OBSType and A.OBSType=substring(AccAss.Type,2,1) Order by A.ANO) A5
	Outer Apply (Select Top 1 A.UseCurrTypeF, A.BSType from AccBS A, Acceptance oA Where oA.OANO=A2.OANO and A.ANO=oA.ANO and A.ANO>=A2.LANO and A.UseCurrTypeF=1 and A.ID=AccAss.ID and A.BSType<>A.OBSType and A.OBSType=substring(AccAss.Type,2,1) Order by A.ANO) A6
	inner join Profile on (Profile.ID=AccAss.ID)      
	Left Join TaxType on (TaxType.TaxType=Profile.TaxType)
	inner join MParam on (MParam.Type=
				Case 
				When coalesce(A5.UseCurrTypeF, coalesce(A4.UseCurrTypeF, coalesce(A6.UseCurrTypeF, Cast(0 as Bit))))=1 and AccAss.Type in ('BB','BA','BO','BC','BP','BD') then
					'B'+coalesce(A5.BSType, coalesce(A4.BSType, coalesce(A6.BSType,'')))
				else
					AccAss.Type
				end
	)	
	Left Join (Select CNO, sum(Share) as MShare from Coinsurance Where PCollectionF=0 Group by CNO) Coinsurance on (Coinsurance.CNO=A2.CNO)      
	Cross Apply (
		Select Top 1 A1.ANO, A1.OANO, A1.CPCT, A1.AType, A1.EMethod, A1.PANO, A1.PDate, A1.PPDate, A2.PDate as CPDate, coalesce(A2.ANO,0) as CANO,
		coalesce((Select Top 1 PANO from Acceptance A3 Where A3.OANO=A1.OANO and A3.Astatus<>'C' and A3.AType='A' and A3.ANO<@P_ANO Order By A3.PANO Desc), A1.PANO) as PADJANO
		from Acceptance A1
		Left Join RArrHeader R on (R.ANO=A1.ANO)
		Outer Apply (Select Top 1 A2.ANO, A2.PDate from Acceptance A2 Where A2.OANO=A1.OANO and A2.Atype='C' and A2.EMethod='A' and A2.ANO<@P_ANO Order by A2.ANO Desc) A2
		Where A1.ANO=@P_ANO
		Order By A1.OANO, A2.ANO Desc
	) A3 
	Where A2.OANO=A3.OANO and A2.ANO<@P_ANO
	and 
	( 
		(
		A3.AType='A' and
		(    
			(  
			pA2.ANO=A3.PANO and A3.PDate<=(Case When pA2.PDate<pA2.SDate then pA2.SDate else pA2.PDate End) and A3.PPDate>=(Case When pA2.PPDate<pA2.SDate then pA2.SDate else pA2.PPDate End) and (A2.AType='E' and coalesce(pA2.AType,'') in ('N','E'))   
			and AccAss.AdjustableF=1 and AccAss.AdjMethod<>'OVERLIMIT' and AccAss.CAmount=0  
			and pA2.ANO<=A3.PADJANO 
			)     
			or   
			(  
			A2.ANO<=A3.PANO and A3.PDate<=(Case When A2.PDate<A2.SDate then A2.SDate else A2.PDate End) and A3.PPDate>=(Case When A2.PPDate<A2.SDate then A2.SDate else A2.PPDate End) and (A2.AType<>'A' and coalesce(pA2.AType,'')<>'A')   
			and AccAss.AdjustableF=1 and AccAss.AdjMethod<>'OVERLIMIT'  
			and A2.ANO<=A3.PADJANO and A2.PANO<>A3.PADJANO and AccAss.CAmount<>0
			)     
			or   
			(  
			A2.ANO<=A3.PANO and A3.PDate<=(Case When pA2.PDate<pA2.SDate then pA2.SDate else pA2.PDate End) and A3.PPDate>=(Case When pA2.PPDate<pA2.SDate then pA2.SDate else pA2.PPDate End) and (A2.AType<>'A' and coalesce(pA2.AType,'')<>'A')   
			and AccAss.AdjustableF=1 and AccAss.AdjMethod<>'OVERLIMIT'  
			and A2.ANO<=A3.PADJANO and A2.PANO<>A3.PADJANO and AccAss.CAmount=0
			)   
			or   
			(  
			A2.ANO<=A3.PANO and A3.PDate<=(Case When A2.PDate<A2.SDate then A2.SDate else A2.PDate End) and A3.PPDate>=(Case When A2.PPDate<A2.SDate then A2.SDate else A2.PPDate End) and (A2.AType<>'A' and coalesce(pA2.AType,'')<>'A')   
			and AccAss.AdjustableF=1 and AccAss.AdjMethod<>'OVERLIMIT' and AccAss.CAmount<>0  
			and A2.PANO=A3.PADJANO
			)     
			or   
			(  
			A2.ANO<=A3.PANO and A3.PDate<=(Case When A2.PDate<A2.SDate then A2.SDate else A2.PDate End) and A3.PPDate>=(Case When A2.PPDate<A2.SDate then A2.SDate else A2.PPDate End) and A2.PDATE<A2.PPDATE and (A2.AType<>'A' and coalesce(pA2.AType,'')<>'A')   
			and AccAss.AdjustableF=1 and AccAss.AdjMethod='OVERLIMIT' and AccAss.CAmount<>0  
			and NOT EXISTS (Select Top 1 PANO from Acceptance A3 Where A3.OANO=A3.OANO and A3.PANO=A2.ANO and A3.Astatus<>'C' and A3.AType='A' and A3.ANO<@P_ANO)  
			)     
		)
		)
		or    
		(  
		--Cancel All
		A3.AType='C' and A3.EMethod='A'and 
		(
		(
		case when A2.ANO<=A3.CANO and A2.PDate>coalesce(A3.CPDate,A2.PDate) Then coalesce(A3.CPDate,A2.PDate) else A2.PDate end>=A3.PDate and AccAss.CAmount<>0
		) 
		or 
		(
		case when A2.ANO<=A3.CANO and coalesce(pA2.pDate,A2.PDate)>coalesce(A3.CPDate,coalesce(pA2.pDate,A2.PDate)) Then coalesce(A3.CPDate,coalesce(pA2.pDate,A2.PDate)) else coalesce(pA2.pDate,A2.PDate) end>=A3.PDate and AccAss.CAmount=0
		)
		)
		)  
		or
		(
		--Adjustment Cancel
		A3.AType='C' and A2.AType='A' and A2.ANO=A3.PANO
		)
	)     	                  
	and 
	(
	(AccAss.Type in ('DI','IC','IR','IT','IX') and AccAss.Code='P') 
	or (AccAss.Type in ('DI','IC') and AccAss.Code='U') 
	Or (AccAss.Type in ('BB','BA','BO','BC','BP','BD') and AccAss.Code='C') 
	or (AccAss.Type in ('DI','IC','IR','IT','IX') and AccAss.Code='O') 
	or (A3.AType='C' and A3.EMethod='A' and AccAss.Type in ('DI') and AccAss.Code in ('F','D'))
	)                  
	Group By A3.ANO, AccAss.RCode, AccAss.SDate, AccAss.EDate, AccAss.Currency_OC
) T          
Group by ANO, Code, Currency


)       

GO

DROP FUNCTION PREMIUM_CALCULATION_CONSTANT
GO
CREATE FUNCTION PREMIUM_CALCULATION_CONSTANT(@P_ANO int) 
RETURNS TABLE  AS 
RETURN ( 
Select ANO, Currency, sum(Premium) as Premium 
 
from( 
Select ANO, Currency, sum(Premium) as Premium 
 
from ( 
select Acceptance.ANO,RCalc.Currency, 
-case 
when DateDiff(day, acceptance.pdate, rcalc.SDate)>0 and acceptance.pdate between pacceptance.sdate and pacceptance.edate then 1 
when DateDiff(day, rcalc.Edate, acceptance.pdate)>=0 and acceptance.pdate between pacceptance.sdate and pacceptance.edate then 0 
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
			--Prorata Calculation
			Case When pAcceptance.EXCLUSIVEF=0 and pAcceptance.STime<pAcceptance.ETime and RCalc.EDate=pAcceptance.EDate Then
				CASE WHEN RCOVER.CPFORMULA='PRORATE SQ' and Acceptance.AType='C' and Acceptance.EMethod<>'A' THEN
					POWER(dbo.fn_calc_prorata(dbo.fn_Get_Effective_Cancellation_By_Payor_Schedule(Acceptance.ANO, Acceptance.PDate,dateadd(day,1,RCalc.edate)), dateadd(day,1,RCalc.edate), RCalc.Sdate, dateadd(day,1,RCalc.edate), Cover.PPeriod), 2)
				ELSE
					Case When Acceptance.AType='C' and Acceptance.EMethod<>'A' THEN
						dbo.fn_calc_prorata(dbo.fn_Get_Effective_Cancellation_By_Payor_Schedule(Acceptance.ANO, Acceptance.PDate,dateadd(day,1,RCalc.edate)), dateadd(day,1,RCalc.edate), RCalc.Sdate, dateadd(day,1,RCalc.edate), Cover.PPeriod)
					else
						dbo.fn_calc_prorata(acceptance.pDate, dateadd(day,1,RCalc.edate), RCalc.Sdate, dateadd(day,1,RCalc.edate), Cover.PPeriod)
					End
				END			
			else
				CASE WHEN RCOVER.CPFORMULA='PRORATE SQ' and Acceptance.AType='C' and Acceptance.EMethod<>'A' THEN
					POWER(dbo.fn_calc_prorata(dbo.fn_Get_Effective_Cancellation_By_Payor_Schedule(Acceptance.ANO, Acceptance.PDate,RCalc.Edate), RCalc.Edate, RCalc.Sdate, RCalc.EDate, Cover.PPeriod), 2)
				ELSE
					CASE WHEN Acceptance.AType='C' and Acceptance.EMethod<>'A' THEN
						dbo.fn_calc_prorata(dbo.fn_Get_Effective_Cancellation_By_Payor_Schedule(Acceptance.ANO, Acceptance.PDate,RCalc.Edate), RCalc.Edate, RCalc.Sdate, RCalc.EDate, Cover.PPeriod)
					Else
						dbo.fn_calc_prorata(acceptance.pDate, RCalc.Edate, RCalc.Sdate, RCalc.EDate, Cover.PPeriod)
					End
				END			
			End	 
		Else 
		-- Endorsement Period 
			1 
		End 
	End 
End 
* (Case When pAcceptance.Qty=0 Then 1 else pAcceptance.Qty end) 
* (Case When PCalc.Description='Minimum Premium' Then RCalc.Gross else (Case When PCalc.Gross=0 then 0 else Case When PCalc.OGross=0 Then PCalc.Gross else RCalc.OGross*(case When Pcalc.TSI=0 then 1 else PCalc.Ourshare/PCalc.TSI end) *PCalc.Gross/PCalc.OGross end end) end+RCalc.Reinstatement)
* (Case When Acceptance.CPCT=0 and Acceptance.AType='C' and Acceptance.EMethod<>'A' and Acceptance.NoRefundF<>12 and RCover.CPRefund<>0 and not (DateDiff(day, acceptance.pdate, rcalc.SDate)>0 and acceptance.pdate between pacceptance.sdate and pacceptance.edate) Then RCover.CPRefund/100 else 1 end) as Premium      

from Acceptance 
inner join Acceptance pAcceptance on (pAcceptance.ANO=Acceptance.pANO) 
inner Join Cover on (Cover.CNO=pAcceptance.CNO) 
inner join PCalc on (PCalc.ANO=pAcceptance.ANO) inner join RCalc on (RCalc.ANO=PCalc.ANO and RCalc.Currency=PCalc.Currency) 
Left Join RCover on (RCover.ANO=Acceptance.ANO and RCover.Code=RCalc.Code and ((RCover.SDate=Acceptance.SDate and RCover.EDate=Acceptance.EDate and RCalc.SDate=pAcceptance.SDate and RCalc.EDate=pAcceptance.EDate) or (RCover.SDate=RCalc.SDate)))
Where Acceptance.ANO=@P_ANO and Acceptance.AType<>'A' and Not (Acceptance.AType='C' and Acceptance.EMethod='A') and Not (Acceptance.AType='E' and Acceptance.EMethod='S') and pAcceptance.AType not in ('A','C') 
and Not (Acceptance.Atype<>'N' and Acceptance.NoRefundF<>12 and not (Acceptance.NoRefundF=13 and charindex((case when pAcceptance.ISType in ('I','L') Then 'DI' else 'I'+pAcceptance.ISType end),Acceptance.RefundType)<>0) and (coalesce(RCover.NoRefundF,0)=1 or Acceptance.NoRefundF in (2,4) or (Acceptance.NoRefundF in (1) and DateDiff(day, acceptance.pdate, RCalc.SDate) <= 0)))
and Not (DateDiff(day, rcalc.Edate, acceptance.pdate)>=0 and acceptance.pdate between pacceptance.sdate and pacceptance.edate)
and RCalc.Gross<>0 
) T 
 
Group By ANO, Currency 
 
Union All 

select A3.ANO, AccAss.Currency_OC as Currency,                  
sum(Case When AccAss.Code in ('P') then (Case When A3.AType='A' and AccAss.AdjMethod='OVERLIMIT' then -AccAss.CAmount*(Case When A3.CPCT<>0 Then A3.CPCT/100 else 1 end)/(Case When AccAss.PProrata<>0 Then AccAss.PProrata else 1 end) else -AccAss.Amount_OC 
end)*(Case When AccAss.Type='DI' then 100/(100-coalesce(Coinsurance.MShare,0)) else 1 end) else 0 end) as Premium
From Acceptance A2 
inner join AccAss on (AccAss.ANO=A2.ANO)     
Left join Acceptance pA2  on (pA2.ANO=A2.pANO)     
Left Join (Select CNO, sum(Share) as MShare from Coinsurance Where PCollectionF=0 Group by CNO) Coinsurance on (Coinsurance.CNO=A2.CNO)      
Cross Apply (
	Select Top 1 A1.ANO, A1.OANO, A1.CPCT, A1.AType, A1.EMethod, A1.PANO, A1.PDate, A1.PPDate, A2.PDate as CPDate, coalesce(A2.ANO,0) as CANO,
	coalesce((Select Top 1 PANO from Acceptance A3 Where A3.OANO=A1.OANO and A3.Astatus<>'C' and A3.AType='A' and A3.ANO<@P_ANO Order By A3.PANO Desc), A1.PANO) as PADJANO
	from Acceptance A1
	Left Join RArrHeader R on (R.ANO=A1.ANO)
	Outer Apply (Select Top 1 A2.ANO, A2.PDate from Acceptance A2 Where A2.OANO=A1.OANO and A2.Atype='C' and A2.EMethod='A' and A2.ANO<@P_ANO Order by A2.ANO Desc) A2
	Where A1.ANO=@P_ANO
	Order By A1.OANO, A2.ANO Desc
) A3 
Where A2.OANO=A3.OANO and A2.ANO<@P_ANO
and 
( 
	(
	A3.AType='A' and
	(    
		(  
		pA2.ANO=A3.PANO and A3.PDate<=(Case When pA2.PDate<pA2.SDate then pA2.SDate else pA2.PDate End) and A3.PPDate>=(Case When pA2.PPDate<pA2.SDate then pA2.SDate else pA2.PPDate End) and (A2.AType='E' and coalesce(pA2.AType,'') in ('N','E'))   
		and AccAss.AdjustableF=1 and AccAss.AdjMethod<>'OVERLIMIT' and AccAss.CAmount=0  
		and pA2.ANO<=A3.PADJANO 
		)     
		or   
		(  
		A2.ANO<=A3.PANO and A3.PDate<=(Case When A2.PDate<A2.SDate then A2.SDate else A2.PDate End) and A3.PPDate>=(Case When A2.PPDate<A2.SDate then A2.SDate else A2.PPDate End) and (A2.AType<>'A' and coalesce(pA2.AType,'')<>'A')   
		and AccAss.AdjustableF=1 and AccAss.AdjMethod<>'OVERLIMIT'  
		and A2.ANO<=A3.PADJANO and A2.PANO<>A3.PADJANO
		)     
		or   
		(  
		A2.ANO<=A3.PANO and A3.PDate<=(Case When A2.PDate<A2.SDate then A2.SDate else A2.PDate End) and A3.PPDate>=(Case When A2.PPDate<A2.SDate then A2.SDate else A2.PPDate End) and (A2.AType<>'A' and coalesce(pA2.AType,'')<>'A')   
		and AccAss.AdjustableF=1 and AccAss.AdjMethod<>'OVERLIMIT' and AccAss.CAmount<>0  
		and A2.PANO=A3.PADJANO
		)     
		or   
		(  
		A2.ANO<=A3.PANO and A3.PDate<=(Case When A2.PDate<A2.SDate then A2.SDate else A2.PDate End) and A3.PPDate>=(Case When A2.PPDate<A2.SDate then A2.SDate else A2.PPDate End) and A2.PDATE<A2.PPDATE and (A2.AType<>'A' and coalesce(pA2.AType,'')<>'A')   
		and AccAss.AdjustableF=1 and AccAss.AdjMethod='OVERLIMIT' and AccAss.CAmount<>0  
		and NOT EXISTS (Select Top 1 PANO from Acceptance A3 Where A3.OANO=A3.OANO and A3.PANO=A2.ANO and A3.Astatus<>'C' and A3.AType='A' and A3.ANO<@P_ANO)  
		)     
	)
	)
	or    
	(  
	--Cancel All
	A3.AType='C' and A3.EMethod='A'and 
	(
	(
	case when A2.ANO<=A3.CANO and A2.PDate>coalesce(A3.CPDate,A2.PDate) Then coalesce(A3.CPDate,A2.PDate) else A2.PDate end>=A3.PDate and AccAss.CAmount<>0
	) 
	or 
	(
	case when A2.ANO<=A3.CANO and coalesce(pA2.pDate,A2.PDate)>coalesce(A3.CPDate,coalesce(pA2.pDate,A2.PDate)) Then coalesce(A3.CPDate,coalesce(pA2.pDate,A2.PDate)) else coalesce(pA2.pDate,A2.PDate) end>=A3.PDate and AccAss.CAmount=0
	)
	)
	)  
	or
	(
	--Adjustment Cancel
	A3.AType='C' and A2.AType='A' and A2.ANO=A3.PANO
	)
)     
and (AccAss.Type in ('DI','IC','IR') and AccAss.Code='P')
Group By A3.ANO, AccAss.Currency_OC

) T 
 
Group By ANO, Currency 
) 
 
GO

DROP FUNCTION PREMIUM_CALCULATION_FACTOR
GO
CREATE FUNCTION PREMIUM_CALCULATION_FACTOR(@P_ANO int)    
RETURNS TABLE  AS    
RETURN (    
Select ANO, Currency, sum(Premium) as Premium    
                                
from(    
 Select ANO, Currency, sum(Premium) as Premium    
                        
 from (    
  select Acceptance.ANO, RCalc.Currency,    
  case    
  When Acceptance.AType<>'N' then    
   case    
   when DateDiff(day, acceptance.pdate, rcalc.SDate)>0 then 1    
   when DateDiff(day, rcalc.Edate, acceptance.pdate)>=0 then 0    
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
	 	--Prorata Calculation
		Case When Acceptance.EXCLUSIVEF=0 and Acceptance.STime<Acceptance.ETime and RCalc.EDate=Acceptance.EDate Then
			dbo.fn_calc_prorata(acceptance.pDate, dateadd(day,1,RCalc.edate), RCalc.Sdate, dateadd(day,1,RCalc.edate), Cover.PPeriod)
		else
			dbo.fn_calc_prorata(acceptance.pDate, RCalc.Edate, RCalc.Sdate, RCalc.EDate, Cover.PPeriod)
		End
    End    
   End    
  Else    
	1    
  End    
  * (Case When Acceptance.Qty=0 Then 1 else Acceptance.Qty end)    
  * (Case When PCalc.Description='Minimum Premium' Then RCalc.Gross/PCalc.Gross else (Case When PCalc.Gross=0 then 0 else Case When PCalc.OGross=0 Then 1 else RCalc.OGross*(case When Pcalc.TSI=0 then 1 else PCalc.Ourshare/PCalc.TSI end) * 1/PCalc.OGross end end) end+RCalc.Reinstatement) as Premium         
  From RCALC, PCALC, acceptance, cover, RCOVER    
  Where Acceptance.ANO=@P_ANO AND Cover.CNO=Acceptance.CNO    
  and RCOVER.ANO=RCALC.ANO AND RCOVER.CODE=RCALC.CODE AND RCOVER.SDATE=RCALC.SDATE    
  and RCalc.ANO=Acceptance.ANO and PCalc.ANO=RCalc.ANO and PCalc.Currency=RCalc.Currency    
  and Acceptance.AType not in ('A','C')    
  and not (Acceptance.Atype<>'N' and Acceptance.NoRefundF<>12 and not (Acceptance.NoRefundF=13 and charindex((case when Acceptance.ISType in ('I','L') Then 'DI' else 'I'+Acceptance.ISType end),Acceptance.RefundType)<>0) and (RCover.NoRefundF=1 or Acceptance.NoRefundF in (2,4) or (Acceptance.NoRefundF in (1) and DateDiff(day, acceptance.pdate, RCalc.SDate) <= 0)))
  and RCalc.Gross<>0    
                                      
  Union All    
                                                                      
  select Acceptance.ANO, RCalc.Currency,    
  (Case When PCalc.Description='Minimum Premium' Then RCalc.Gross/PCalc.Gross else (Case When PCalc.Gross=0 then 0 else Case When PCalc.OGross=0 Then 1 else RCalc.OGross*1/PCalc.OGross end end) end+RCalc.Reinstatement)*coalesce(sISource.Share/100,(case When Pcalc.TSI=0 then 1 else PCalc.Ourshare/PCalc.TSI end)) as Premium
  From RCALC Left Join Acceptance sAcceptance on (sAcceptance.ANO=RCalc.SANO) Left Join ISource sISource on (sISource.CNO=sAcceptance.CNO), PCALC, acceptance
  Where Acceptance.ANO=@P_ANO and RCalc.ANO=Acceptance.ANO and PCalc.ANO=RCalc.ANO and PCalc.Currency=RCalc.Currency and Acceptance.AType='A'            
 ) T    
                        
 Group By ANO, Currency    
                                                                                   
) T    
                                
Group By ANO, Currency    
                                    
                                    
)    

GO
DROP Function fn_BizMap
GO
CREATE Function fn_BizMap(@P_ANO as int, @P_Source as varchar(10)='') 
RETURNS VarChar(10) 
AS 
 
BEGIN 
Declare @CType varchar(20) 
Declare @PType varchar(20) 
Declare @IType varchar(20) 
Declare @EType varchar(20) 
Declare @CGroup varchar(10) 
Declare @Segment varchar(10) 
Declare @ISType varchar(10) 
Declare @Payor_LOB varchar(10) 
Declare @PHolder_LOB varchar(10) 
Declare @Insured_LOB varchar(10) 
Declare @Source_LOB varchar(10) 
Declare @SegmentGroup varchar(10) 
Declare @BizmapID varchar(10) 
Declare @ID varchar(10) 
 
if @P_ANO>0 
Begin 
	 if @P_Source='' 
	 Begin 
	  Select 
	  @CType=Source.CType, 
	  @PType=case When Source.PType='C' Then 'CAPTIVE' When Source.PType='D' Then 'DIRECT INSURED' When Source.PType='M' Then 'INTERMEDIARIES' else 'OTHERS' end, 
	  @IType=I.IType, 
	  @EType=Case When PHolder.CorporateF=1 Then 'CORPORATE' Else 'INDIVIDUAL' end,
	  @CGroup=PHolder.CGroup, 
	  @Segment=C.Segment, 
	  @ISType=A.ISType, 
	  @Payor_LOB=coalesce(PAPayor.LOB,PMPayor.LOB), 
	  @PHolder_LOB=PHolder.LOB, 
	  @Insured_LOB=Insured.LOB, 
	  @Source_LOB=Source.LOB, 
	  @SegmentGroup=SegmentGroup.SegmentGroup, 
	  @BizmapID=A.BizmapID
	  from Acceptance A
	  Inner join Cover C on (C.CNO=A.CNO)
	  Left Join Segment on (Segment.Segment=C.Segment) 
	  Left join SegmentGroup on (Segment.SegmentGroup=SegmentGroup.SegmentGroup) 
	  Left Join InParty I On (I.CNO=C.CNO)
	  Left Join Payor MPayor on (MPayor.ANO=A.LANO)
	  Left Join Payor APayor on (APayor.ANO=A.ANO)
	  Left Join Profile PMPayor on (PMPayor.ID=MPayor.ID)
	  Left Join Profile PAPayor on (PAPayor.ID=APayor.ID)
	  Left Join Profile PHolder on (PHolder.ID=C.PHolder)
	  Left Join Profile Insured on (Insured.ID=A.AID)
	  Left Join Profile Source on (Source.ID=A.Source)
	  Where A.ANO=@P_ANO 
	 End 
	 Else 
	 Begin 
	  Select 
	  @CType=Source.CType, 
	  @PType=case When Source.PType='C' Then 'CAPTIVE' When Source.PType='D' Then 'DIRECT INSURED' When Source.PType='M' Then 'INTERMEDIARIES' else 'OTHERS' end, 
	  @IType=I.IType, 
	  @EType=Case When PHolder.CorporateF=1 Then 'CORPORATE' Else 'INDIVIDUAL' end,
	  @CGroup=PHolder.CGroup, 
	  @Segment=C.Segment, 
	  @ISType=A.ISType, 
	  @Payor_LOB=coalesce(PAPayor.LOB,PMPayor.LOB), 
	  @PHolder_LOB=PHolder.LOB, 
	  @Insured_LOB=Insured.LOB, 
	  @Source_LOB=Source.LOB, 
	  @SegmentGroup=SegmentGroup.SegmentGroup 
	  from Acceptance A
	  Inner join Cover C on (C.CNO=A.CNO)
	  Left Join Segment on (Segment.Segment=C.Segment) 
	  Left join SegmentGroup on (Segment.SegmentGroup=SegmentGroup.SegmentGroup) 
	  Left Join InParty I On (I.CNO=C.CNO)
	  Left Join Payor MPayor on (MPayor.ANO=A.LANO)
	  Left Join Payor APayor on (APayor.ANO=A.ANO)
	  Left Join Profile PMPayor on (PMPayor.ID=MPayor.ID)
	  Left Join Profile PAPayor on (PAPayor.ID=APayor.ID)
	  Left Join Profile PHolder on (PHolder.ID=C.PHolder)
	  Left Join Profile Insured on (Insured.ID=A.AID)
	  Left Join Profile Source on (Source.ID=@P_Source)
	  Where A.ANO=@P_ANO 
	 End 
End 
ELSE 
BEGIN 
	SELECT 
		@CType=Source.CType, 
		@PType=case When Source.PType='C' Then 'CAPTIVE' When Source.PType='D' Then 'DIRECT INSURED' When Source.PType='M' Then 'INTERMEDIARIES' else 'OTHERS' end, 
		@EType=Case When Source.CorporateF=1 Then 'CORPORATE' Else 'INDIVIDUAL' end,
		@Source_LOB=Source.LOB, 
		@Segment='DIRECT', 
	    @ISType='I' 
	from Profile Source 
	Where Source.ID=@P_Source	 
END 
 
Select Top 1 @ID=B.ID 
from BizMap B 
Where b.Post_Flag = 1 and b.AllowedF=1
and (CType='<ANY>' or CType=@CType) 
and (PType='<ANY>' or PType=@PType) 
and (IType='<ANY>' or IType=@IType) 
and (EType='<ANY>' or EType=@EType) 
and (Cgroup='<ANY>' or CGroup=@CGroup) 
and (EXCgroup='<ANY>' or EXCgroup<>@CGroup) 
and (Segment='<ANY>' or Segment=@Segment) 
and (ISType='<ANY>' or ISType=@ISType) 
and (Payor_LOB='<ANY>' or Payor_LOB=@Payor_LOB) 
and (PHolder_LOB='<ANY>' or PHolder_LOB=@PHolder_LOB) 
and (Insured_LOB='<ANY>' or Insured_LOB=@Insured_LOB) 
and (Source_LOB='<ANY>' or Source_LOB=@Source_LOB) 
and (SegmentGroup='<ANY>' or SegmentGroup=@SegmentGroup) 
Order By OrderNo, ID 

return(coalesce(@ID,@BizMapID)) 
End 


GO
DROP FUNCTION fn_GetPNominalVatCommission_ByRateCode
GO
CREATE FUNCTION fn_GetPNominalVatCommission_ByRateCode(@P_ADMNO as int)  
RETURNS Float  
AS                 
BEGIN                
Declare @P_PNominal_VAT as Float  
  
Select @P_PNominal_VAT=sum(AccAss.Amount)  
from   
AccAss  
Inner Join RateTab on (RateTab.Code=AccAss.RCode and RateTab.VATCommissionF=1)  
Inner Join Profile on (Profile.ID=AccAss.ID)
Inner Join Acceptance on (Acceptance.ANO=AccAss.ANO)
Inner Join Cover on (Cover.CNO=Acceptance.CNO)
Where AccAss.AdmNo=@P_AdmNo   
and AccAss.Type in ('BB','BA','BC','BP','BD') and AccAss.Code in ('C','O')  
and (Case When Acceptance.ISType not in ('R','N','T','Q','S','A','X','P') or Profile.VATCOMMEXEMPTIF=0 Then cast(1 as Bit) Else 0 END)=1
if @P_PNominal_VAT is null   
 Select @P_PNominal_VAT=0  
  
return @P_PNominal_VAT  
END    
  

GO

DROP Function Member_Share
GO
CREATE Function Member_Share(@P_ANO as int)
RETURNS Float
AS
BEGIN
 Declare @Share Float
    
 Select @Share=sum(Coinsurance.Share) 
 from Acceptance
 Inner Join Cover on (Cover.CNO=Acceptance.CNO)
 Inner Join Coinsurance on (Coinsurance.CNO=Acceptance.CNO)
 Where Acceptance.ANO=@P_ANO and Acceptance.ISType='L'
 if @Share is null
 Select @Share=0
    
 return(@Share)
End


GO

DROP PROCEDURE CLView06a
GO
CREATE PROCEDURE CLView06a (@P_CNO as integer)  
AS  
SELECT CLAIM.CLAIMNO, CLAIM.ANO, CLAIM.CNO, CLAIM.LOSSDATE, CLAIM.CTYPE,  
CCalc.Currency,  
CCALC.RATE,   
CCALC.SHARE AS PCTSHARE,  
CCALC.LOSS AS ESTIMATE,  
CCALC.CLAIM AS OURSHARE,  
CCALC.EDEDUCTIBLE,  
CCALC.DEDUCTIBLE,  
  
CCALC.COST,  
CCALC.RCOST,  
CCALC.ECOST,  
CCALC.ERCOST,  
  
CCALC.SALVAGE,  
CCALC.RSALVAGE,  
CCALC.ESALVAGE,  
CCALC.ERSALVAGE,  
  
CCALC.SUBROGATION,  
CCALC.RSUBROGATION,  
CCALC.ESUBROGATION,  
CCALC.ERSUBROGATION,  
COALESCE(ISOURCE.LIMIT,0) AS LIMIT,  
COALESCE(ISOURCE.EXCESS,0) AS EXCESS,  
PCCALC.CLAIM as PrevOURSHARE,  
PCCALC.DEDUCTIBLE as PrevDEDUCTIBLE,  
PCCALC.COST as PrevCost,  
PCCALC.SALVAGE AS PrevSALVAGE,  
PCCALC.SUBROGATION As PrevSUBROGATION,  
TOC.CashCallOnPartialPaymentF, TOC.CashCallOnEstimateF, TOC.CashCallOnGrossF, 
coalesce(Coinsurance.MShare,0) as MShare
From CCALC   
INNER JOIN CLAIM ON (CLAIM.CNO=CCALC.CNO)   
INNER JOIN ACCEPTANCE ON (ACCEPTANCE.ANO=CLAIM.ANO)   
INNER JOIN COVER ON (COVER.CNO=ACCEPTANCE.CNO)   
INNER JOIN TOC on (TOC.TOC=CLAIM.TOC)  
LEFT JOIN ISOURCE ON (ISOURCE.CNO=ACCEPTANCE.CNO)  
Left Join CCalc pCCalc on (pCCalc.CNO=Claim.pCNO and pCCalc.Currency=CCalc.Currency and Claim.CSeqNo>0)  
Outer Apply (
	Select sum(Share) as MShare
	from
	(
		Select Coinsurance.SHARE
		FROM Coinsurance
		WHERE Acceptance.ISTYPE='L' and Coinsurance.ClaimNotFullCoverF=0 and Coinsurance.CNO=ACCEPTANCE.CNO

		Union All

		Select CoinsuranceDET.SHARE
		from Coinsurance 
		INNER JOIN CoinsuranceDET on (CoinsuranceDET.CNO=Coinsurance.CNO and CoinsuranceDET.ID=Coinsurance.ID)
		OUTER APPLY (SELECT TOP 1 LCALC.TOR, LCALC.CODE AS RCODE FROM LCALC WHERE LCALC.CNO=CCALC.CNO Order By Case When LCALC.Currency=CCALC.Currency Then 0 Else 1 End, Code, TOR) LCALC
		WHERE Acceptance.ISTYPE='L' and Coinsurance.ClaimNotFullCoverF=1 and Coinsurance.CNO=ACCEPTANCE.CNO
		And (
			CoinsuranceDET.Code=LCALC.RCODE   
			or   
			Exists (Select Top 1 RCalc.Code from RCalc Inner Join RateCov on (RateCov.Code=CoinsuranceDET.Code and RateCov.TOR=RCalc.TOR) Where RCalc.ANO=ACCEPTANCE.ANO and RCalc.Code=LCALC.RCODE)      
		)  
	) Coinsurance
) Coinsurance
WHERE CCALC.CNO=@P_CNO  
  
  
GO  
  

DROP PROCEDURE Member_Coys
GO
CREATE PROCEDURE Member_Coys (@pANO as Integer)
AS
SELECT COUNT(*)  AS NCOYS, MAX(Acceptance.ISTYPE) AS ISTYPE, SUM(COINSURANCE.SHARE-COINSURANCE.JP) AS MSHARE
FROM Acceptance
Inner join Cover on (Cover.CNO=Acceptance.CNO)
Inner join Coinsurance on (Coinsurance.CNO=Acceptance.CNO)
WHERE Acceptance.ANO=@pANO

GO
DROP Procedure QApproval_Production
GO
CREATE Procedure QApproval_Production (@P_ANO integer)              
AS

Declare @ApplyApprLimitByAccRegF as Bit
Declare @ApplyApprLimitByTOLF as Bit
Declare @ApplyApprLimitOCF as Bit
Declare @LANO as int
Declare @OpenFlag as Bit
Declare @TOC as varchar(10)
Declare @Branch as varchar(10)
Declare @ISType as varchar(10)
Declare @PHolder as varchar(10)
Declare @NoRiskAccumulationF as Bit


Select @NoRiskAccumulationF=A.NoRiskAccumulationF, @TOC=A.TOC, @Branch=A.Branch, @ISType=A.ISType, @PHolder=C.PHolder, @LANO=A.LANO, @OpenFlag=C.OpenFlag, @ApplyApprLimitByTOLF=TOC.ApplyApprLimitByTOLF, @ApplyApprLimitByAccRegF=TOC.ApplyApprLimitByAccRegF, @ApplyApprLimitOCF=TOC.ApplyApprLimitOCF
from Acceptance A
Inner Join Cover C on (C.CNO=A.CNO)
Inner Join TOC on (TOC.TOC=A.TOC)
Where A.ANO=@P_ANO

if @ApplyApprLimitByAccRegF=0 
	if @P_ANO<>@LANO
	Begin
		if @OpenFlag=0
			SELECT top 1 Acceptance.RegID, Acceptance.FLDID, Acceptance.ValueID, Case When Acceptance.ValueID='' Then Acceptance.CertificateNo else '' end as CertificateNo,
			@Branch as Branch,    
			@TOC as TOC, 
			@ISType as ISType,
			Case When @ApplyApprLimitByTOLF=1 Then RARRHEADER.CLIMIT*RARRHEADER.LIMIT*100 ELSE 100 END as ApprLimitPct,  
			(RArrHeader.TAmount-RArrHeader.MAmount) as Amount,
			cast(0 as Float) as TotalAmount
			From Acceptance
			Inner Join RARRHEADER on (RArrheader.ANO=Acceptance.ANO)
			WHERE Acceptance.ANO=@P_ANO
		else
			SELECT top 1 Acceptance.RegID, Acceptance.FLDID, Acceptance.ValueID, Case When Acceptance.ValueID='' Then Acceptance.CertificateNo else '' end as CertificateNo,
			@Branch as Branch,    
			@TOC as TOC, 
			@ISType as ISType,
			Case When @ApplyApprLimitByTOLF=1 Then RARRHEADER.CLIMIT*RARRHEADER.LIMIT*100 ELSE 100 END as ApprLimitPct,  
			(RArrHeader.TAmount-RArrHeader.MAmount) as Amount,
			cast(0 as Float) as TotalAmount		
			From Acceptance
			Inner Join RARRHEADER on (RArrheader.ANO=Acceptance.ANO)
			WHERE Acceptance.ANO=@P_ANO
			-- No Master Acceptance Limit Of Liability
			and (@ApplyApprLimitOCF=1 or not exists (Select Top 1 mA.ANO from Acceptance mA Inner Join ICover I on (I.ANO=mA.ANO) Where mA.ANO=Acceptance.LANO and I.Category='M' and I.Amount<>0))
	end
	else 
	Begin
		if @OpenFlag=1	--Master Open Cover
			SELECT top 1 Acceptance.RegID, Acceptance.FLDID, Acceptance.ValueID, Case When Acceptance.ValueID='' Then Acceptance.CertificateNo else '' end as CertificateNo,
			@Branch as Branch,    
			@TOC as TOC, 
			@ISType as ISType,
			100 as ApprLimitPct,  
			sum(ICover.Amount*dbo.fn_GetReinsuranceRate(Acceptance.TOC,ICover.Currency,Acceptance.SDate,@PHolder)) 
			* coalesce((Select sum(Share) from ISource Where ISource.CNO=Acceptance.CNO),100)/100				
			* (100-coalesce((Select sum(Share) from Coinsurance Where CNO=Acceptance.CNO),0))/100				
			as Amount,
			cast(0 as Float) as TotalAmount
			From Acceptance
			Inner Join ICover on (ICover.ANO=Acceptance.ANO)
			WHERE Acceptance.ANO=@P_ANO
			and ICover.Category='M'
			Group by Acceptance.CNO, Acceptance.RegID, Acceptance.FLDID, Acceptance.ValueID, Case When Acceptance.ValueID='' Then Acceptance.CertificateNo else '' end
		else
			if @NoRiskAccumulationF=0
				SELECT top 1 Acceptance.RegID, Acceptance.FLDID, Acceptance.ValueID, Case When Acceptance.ValueID='' Then Acceptance.CertificateNo else '' end as CertificateNo,
				@Branch as Branch,    
				@TOC as TOC, 
				@ISType as ISType,
				Max(Case When @ApplyApprLimitByTOLF=1 Then RARRHEADER.CLIMIT*RARRHEADER.LIMIT*100 ELSE 100 END) as ApprLimitPct,  
				sum(RArrHeader.TAmount-RArrHeader.MAmount) as Amount,
				cast(0 as Float) as TotalAmount
				From Acceptance mA
				Inner join Acceptance omA on (omA.OANO=mA.OANO)
				Inner Join Acceptance on (Acceptance.LANO=omA.ANO)
				Left Join Acceptance nAcceptance on (nAcceptance.pANO=Acceptance.ANO)
				Inner Join RARRHEADER on (RArrheader.ANO=Acceptance.ANO)
				WHERE mA.ANO=@P_ANO 
				and Acceptance.AType not in ('A','C') and Acceptance.AStatus in ('W','T','I') 
				and (coalesce(nAcceptance.ANO,0)=0 or (coalesce(nAcceptance.LANO,0)=mA.ANO and coalesce(nAcceptance.AType,'')='C' and mA.AType='C'))
				Group By Acceptance.RegID, Acceptance.FLDID, Acceptance.ValueID, Case When Acceptance.ValueID='' Then Acceptance.CertificateNo else '' end
				Order By sum(RArrHeader.TAmount-RArrHeader.MAmount) Desc            
			else
				SELECT top 1 Acceptance.RegID, Acceptance.FLDID, Acceptance.ValueID, Case When Acceptance.ValueID='' Then Acceptance.CertificateNo else '' end as CertificateNo,
				@Branch as Branch,    
				@TOC as TOC, 
				@ISType as ISType,
				Max(Case When @ApplyApprLimitByTOLF=1 Then RARRHEADER.CLIMIT*RARRHEADER.LIMIT*100 ELSE 100 END) as ApprLimitPct,  
				sum(RArrHeader.TAmount-RArrHeader.MAmount) as Amount,
				cast(0 as Float) as TotalAmount
				From Acceptance mA
				Inner Join Acceptance on (Acceptance.LANO=mA.ANO and Acceptance.RegNo=mA.RegNo)
				Inner Join RARRHEADER on (RArrheader.ANO=Acceptance.ANO)
				WHERE mA.ANO=@P_ANO 
				Group By Acceptance.RegID, Acceptance.FLDID, Acceptance.ValueID, Case When Acceptance.ValueID='' Then Acceptance.CertificateNo else '' end
				Order By sum(RArrHeader.TAmount-RArrHeader.MAmount) Desc            
	end
else
	if @P_ANO<>@LANO
	Begin
		if @OpenFlag=0
			SELECT top 1 Acceptance.RegID, Acceptance.FLDID, Acceptance.ValueID, Case When Acceptance.ValueID='' Then Acceptance.CertificateNo else '' end as CertificateNo,
			@Branch as Branch,    
			@TOC as TOC, 
			@ISType as ISType,
			Case When @ApplyApprLimitByTOLF=1 Then RARRHEADER.CLIMIT*RARRHEADER.LIMIT*100 ELSE 100 END as ApprLimitPct,  
			(RArrHeader.TAmount-RArrHeader.MAmount) as Amount,
			(RArrHeader.TAmount-RArrHeader.MAmount)+coalesce(dbo.fn_GetTotalSumInsured(Acceptance.SDate,Acceptance.RegID, Acceptance.FLDID, Acceptance.ValueID,Acceptance.OANO),0) as TotalAmount
			From Acceptance
			Inner Join RARRHEADER on (RArrheader.ANO=Acceptance.ANO)
			WHERE Acceptance.ANO=@P_ANO
		else
			SELECT top 1 Acceptance.RegID, Acceptance.FLDID, Acceptance.ValueID, Case When Acceptance.ValueID='' Then Acceptance.CertificateNo else '' end as CertificateNo,
			@Branch as Branch,    
			@TOC as TOC, 
			@ISType as ISType,
			Case When @ApplyApprLimitByTOLF=1 Then RARRHEADER.CLIMIT*RARRHEADER.LIMIT*100 ELSE 100 END as ApprLimitPct,  
			(RArrHeader.TAmount-RArrHeader.MAmount) as Amount,
			(RArrHeader.TAmount-RArrHeader.MAmount)+coalesce(dbo.fn_GetTotalSumInsured(Acceptance.SDate,Acceptance.RegID, Acceptance.FLDID, Acceptance.ValueID,Acceptance.OANO),0) as TotalAmount
			From Acceptance
			Inner Join RARRHEADER on (RArrheader.ANO=Acceptance.ANO)
			WHERE Acceptance.ANO=@P_ANO
			-- No Master Acceptance Limit Of Liability
			and (@ApplyApprLimitOCF=1 or not exists (Select Top 1 mA.ANO from Acceptance mA Inner Join ICover I on (I.ANO=mA.ANO) Where mA.ANO=Acceptance.LANO and I.Category='M' and I.Amount<>0))
	end
	else 
	Begin
		if @OpenFlag=1	--Master Open Cover
			SELECT top 1 Acceptance.RegID, Acceptance.FLDID, Acceptance.ValueID, Case When Acceptance.ValueID='' Then Acceptance.CertificateNo else '' end as CertificateNo,
			@Branch as Branch,    
			@TOC as TOC, 
			@ISType as ISType,
			100 as ApprLimitPct,  
			sum(ICover.Amount*dbo.fn_GetReinsuranceRate(Acceptance.TOC,ICover.Currency,Acceptance.SDate,@PHolder)) 
			* coalesce((Select sum(Share) from ISource Where ISource.CNO=Acceptance.CNO),100)/100				
			* (100-coalesce((Select sum(Share) from Coinsurance Where CNO=Acceptance.CNO),0))/100				
			as Amount,
			cast(0 as Float) as TotalAmount
			From Acceptance
			Inner Join ICover on (ICover.ANO=Acceptance.ANO)
			WHERE Acceptance.ANO=@P_ANO
			and ICover.Category='M'
			Group by Acceptance.CNO, Acceptance.RegID, Acceptance.FLDID, Acceptance.ValueID, Case When Acceptance.ValueID='' Then Acceptance.CertificateNo else '' end
		else
			SELECT top 1 Acceptance.RegID, Acceptance.FLDID, Acceptance.ValueID, Case When Acceptance.ValueID='' Then Acceptance.CertificateNo else '' end as CertificateNo, 
			@Branch as Branch,    
			@TOC as TOC, 
			@ISType as ISType,
			Max(Case When @ApplyApprLimitByTOLF=1 Then RARRHEADER.CLIMIT*RARRHEADER.LIMIT*100 ELSE 100 END) as ApprLimitPct,  
			Sum(RArrHeader.TAmount-RArrHeader.MAmount) as Amount,
			Sum(RArrHeader.TAmount-RArrHeader.MAmount)+coalesce(dbo.fn_GetTotalSumInsured(Min(Acceptance.SDate),Acceptance.RegID, Acceptance.FLDID, Acceptance.ValueID,Max(mA.OANO)),0) as TotalAmount
			From Acceptance mA
			Inner join Acceptance omA on (omA.OANO=mA.OANO)
			Inner Join Acceptance on (Acceptance.LANO=omA.ANO)
			Left Join Acceptance nAcceptance on (nAcceptance.pANO=Acceptance.ANO)
			Inner Join RARRHEADER on (RArrheader.ANO=Acceptance.ANO)
			WHERE mA.ANO=@P_ANO 
			and Acceptance.AType not in ('A','C') and Acceptance.AStatus in ('W','T','I') 
			and (coalesce(nAcceptance.ANO,0)=0 or (coalesce(nAcceptance.LANO,0)=mA.ANO and coalesce(nAcceptance.AType,'')='C' and mA.AType='C'))
			Group By Acceptance.RegID, Acceptance.FLDID, Acceptance.ValueID, Case When Acceptance.ValueID='' Then Acceptance.CertificateNo else '' end
			Order By Sum(RArrHeader.TAmount-RArrHeader.MAmount)+coalesce(dbo.fn_GetTotalSumInsured(Min(Acceptance.SDate),Acceptance.RegID, Acceptance.FLDID, Acceptance.ValueID,Max(mA.OANO)),0) Desc  

	end

GO

DROP Procedure QCheckMaxOutGo
GO
CREATE Procedure QCheckMaxOutGo(@P_ANO as integer, @ForceCheckMaxOutGo as Bit=0,@P_Period as int=0)   
as   
Declare @Temp_Code Table(ANO Int, Code varchar(10))   
  
Declare @Temp_Comm Table(ANO Int, ID varchar(10), Code varchar(10), BSType varchar(10), Comm Float)   
Declare @Temp_PrevComm Table(ANO Int, ID varchar(10), Code varchar(10), BSType varchar(10), Comm Float)   
  
Declare @Temp_Other Table(ANO Int, Code varchar(10), Disc Float, PrevDisc Float, Inward Float, PrevInward Float, UpFee Float, PrevUpFee Float)   
  
Declare @Temp Table(ANO Int, Code varchar(10), PrevOutGo Float, PrevCommA Float, PrevCommB Float, PrevCommI Float, OutGo Float, CommA Float, CommB Float, CommI Float)   
  
Declare @P_PANO Int  
Declare @P_ISType varchar(1)  
  
Insert Into  @Temp_Code(ANO, Code)  
Select Distinct R.ANO, R.Code  
from RCover R  
Where R.ANO=@P_ANO  
  
Select @P_PANO=A.PANO, @P_ISType=A.ISType from Acceptance A Where A.ANO=@P_ANO  
   
insert into @Temp_Comm(ANO, Code, ID, BSType, Comm)  
Select R.ANO, R.Code, O1.ID, O1.BSType, O1.Commission  
from @Temp_Code R  
Cross Apply (Select * from Premium_Commission_Table(R.ANO, R.Code,@P_Period,0)) O1  
  
if @P_PANO<>-1   
 insert into @Temp_PrevComm(ANO, Code, ID, BSType, Comm)  
 Select R.ANO, R.Code, O1.ID, O1.BSType, O1.Commission  
 from @Temp_Code R  
 Cross Apply (Select * from Premium_Commission_Table(@P_PANO, R.Code,@P_Period,0)) O1  
  
insert into @Temp_Other(ANO, Code, Disc, PrevDisc, Inward, PrevInward, UpFee, PrevUpFee)  
Select R.ANO, R.Code,   
dbo.premium_discount(R.ANO, R.Code,@P_Period) as Disc,   
Case When @P_PANO<>-1 Then dbo.premium_discount(@P_PANO, R.Code,@P_Period) else 0 end as PrevDisc,  
Case When @P_ISType in ('R','N','T','Q','S','A','X','P') Then dbo.Premium_HandlingFee(R.ANO, R.Code,@P_Period) Else 0 end as Inward,   
Case When @P_ISType in ('R','N','T','Q','S','A','X','P') and @P_PANO<>-1 Then dbo.Premium_HandlingFee(@P_PANO, R.Code,@P_Period) else 0 end as PrevInward,  
dbo.Premium_Commission_UpFee(R.ANO, R.Code,@P_Period,0) as UpFee,   
Case When @P_PANO<>-1 Then dbo.Premium_Commission_UpFee(@P_PANO, R.Code,@P_Period,0) else 0 end as PrevUpFee  
from @Temp_Code R  
  
insert into @Temp(ANO, Code, PrevOutGo, PrevCommA, PrevCommB, PrevCommI, OutGo, CommA, CommB, CommI)   
Select T1.ANO, T1.Code,  
Max(T2.PrevDisc)+sum(coalesce(pT3.Comm,0))+Max(T2.PrevInward)-Max(T2.PrevUpFee) as PrevOutGo,  
sum(case When T3.BSType='A' Then coalesce(pT3.Comm,0) Else 0 end) as PrevCommA,  
sum(case When T3.BSType='B' Then coalesce(pT3.Comm,0) Else 0 end) as PrevCommB,  
Case When @P_ISType in ('R','N','T','Q','S','A','X','P') Then sum(coalesce(pT3.Comm,0))+Max(T2.PrevInward) Else 0 end as PrevCommI,  
Max(T2.Disc)+sum(coalesce(T3.Comm,0))+Max(T2.Inward)-Max(T2.UpFee) as OutGo,  
sum(case When T3.BSType='A' Then coalesce(T3.Comm,0) Else 0 end) as CommA,  
sum(case When T3.BSType='B' Then coalesce(T3.Comm,0) Else 0 end) as CommB,  
Case When @P_ISType in ('R','N','T','Q','S','A','X','P') Then sum(coalesce(T3.Comm,0))+Max(T2.Inward) Else 0 end as CommI  
from @Temp_Code T1  
Inner Join @Temp_Other T2 on (T2.ANO=T1.ANO and T2.Code=T1.Code)  
Left Join @Temp_Comm T3 on (T3.ANO=T1.ANO and T3.Code=T1.Code)  
Left Join @Temp_PrevComm pT3 on (pT3.ANO=T3.ANO and pT3.Code=T3.Code and pT3.ID=T3.ID and pT3.BSType=T3.BSType)  
Group By T1.ANO, T1.Code  
  
Select *
from
(
	Select R1.ANO,   
	Case   
	When (R1.PrevOutGo<R1.OutGo or @ForceCheckMaxOutGo=1) and R1.OutGo>R2.MaxOutGo+0.0000000001 and R2.MaxOutGo<>0 Then 'Rate Code ('+R1.Code+') Exceeding Maximum Out Go !' + char(13)+char(10)  
	else ''  
	End  
	+  
	Case   
	When (R1.PrevOutGo<R1.OutGo or @ForceCheckMaxOutGo=1) and R1.OutGo>BR.MaxOutGo+0.0000000001 and BR.MaxOutGo<>0 Then 'Business Rule ('+BR.BizMapID+') Exceeding Maximum Out Go !' + char(13)+char(10)  
	else ''  
	End  
	+  
	Case   
	When @P_ISType Not in ('R','N','T','Q','S','A','X','P') and (R1.PrevCommA<R1.CommA or @ForceCheckMaxOutGo=1) and R1.CommA>R2.MaxCommA+0.0000000001 and R2.MaxCommA<>0 Then 'Rate Code ('+R1.Code+') Exceeding Maximum Commission Agent !' + char(13)+char(10)  
	else ''  
	End  
	+  
	Case   
	When @P_ISType Not in ('R','N','T','Q','S','A','X','P') and (R1.PrevCommB<R1.CommB or @ForceCheckMaxOutGo=1) and R1.CommB>R2.MaxCommB+0.0000000001 and R2.MaxCommB<>0 Then 'Rate Code ('+R1.Code+') Exceeding Maximum Commission Broker !' + char(13)+char(10)  
	else ''  
	End  
	+  
	Case   
	When @P_ISType in ('R','N','T','Q','S','A','X','P') and (R1.PrevCommI<R1.CommI or @ForceCheckMaxOutGo=1) and R1.CommI>R2.MaxCommI+0.0000000001 and R2.MaxCommI<>0 Then 'Rate Code ('+R1.Code+') Exceeding Maximum Commission Inward !' + char(13)+char(10)  
	else ''  
	End as ErrDesc   
	from @Temp R1  
	Inner Join Acceptance A on (A.ANO=R1.ANO)  
	Inner Join RArrHeader R on (R.ANO=A.ANO)   
	Inner Join Cover C on (C.CNO=A.CNO)   
	Inner join RateTab R2 on (R2.Code=R1.Code)   
	Left Join BRRule BR on (BR.TOC=A.TOC and (BR.Branch='<All>' or BR.Branch=A.Branch) and (BR.BizmapID='<All>' or BR.BizMapID=A.BizMapID) and (BR.FacOpt=0 or (BR.FacOpt=1 and R.FAmount<>0) or (BR.FacOpt=2 and R.FAmount=0)))   
	Where   
	(  
	(R1.PrevOutGo<R1.OutGo or @ForceCheckMaxOutGo=1)  
	and ((R2.MaxOutGo<>0 and R1.OutGo>R2.MaxOutGo+0.0000000001) Or (BR.MaxOutGo<>0 and R1.OutGo>BR.MaxOutGo+0.0000000001))   
	)  
	or  
	(  
	@P_ISType Not in ('R','N','T','Q','S','A','X','P') and 
	(R1.PrevCommA<R1.CommA or @ForceCheckMaxOutGo=1)   
	and ((R2.MaxCommA<>0 and R1.CommA>R2.MaxCommA+0.0000000001))    
	)  
	or  
	(  
	@P_ISType Not in ('R','N','T','Q','S','A','X','P') and 
	(R1.PrevCommB<R1.CommB or @ForceCheckMaxOutGo=1)
	and ((R2.MaxCommB<>0 and R1.CommB>R2.MaxCommB+0.0000000001))    
	)  
	or  
	(  
	@P_ISType in ('R','N','T','Q','S','A','X','P') and 
	(R1.PrevCommI<R1.CommI or @ForceCheckMaxOutGo=1)
	and ((R2.MaxCommI<>0 and R1.CommI>R2.MaxCommI+0.0000000001))    
	)  
  
	Union all

	Select T1.ANO,   
	Case   
	When (coalesce(pT3.Comm,0)<T3.Comm or @ForceCheckMaxOutGo=1) and T3.Comm>BS.MaxOutGo+0.0000000001 and BS.MaxOutGo<>0 Then 'Business Source ('+BS.ID+') Exceeding Maximum Out Go !' + char(13)+char(10)  
	else ''  
	End as ErrDesc   
	from @Temp_Code T1  
	Inner Join @Temp_Comm T3 on (T3.ANO=T1.ANO and T3.Code=T1.Code)  
	Left Join @Temp_PrevComm pT3 on (pT3.ANO=T3.ANO and pT3.Code=T3.Code and pT3.ID=T3.ID and pT3.BSType=T3.BSType)  
	Inner join Profile BS on (BS.ID=T3.ID)   
	Where   
	(  
	(coalesce(pT3.Comm,0)<T3.Comm or @ForceCheckMaxOutGo=1)  
	and ((BS.MaxOutGo<>0 and T3.Comm>BS.MaxOutGo+0.0000000001))   
	)  
) T

GO
DROP PROCEDURE QCLACC_3
GO
CREATE PROCEDURE QCLACC_3(@P_POLICYNO AS VARCHAR(255), @P_CERTIFICATENO VARCHAR(255), @P_REFNO varchar(50)='', @P_TOC varchar(10)='', @P_VALUEID varchar(255)='')     
AS     
SELECT TOP 10 ACCEPTANCE.ANO, ACCEPTANCE.POLICYNO, ACCEPTANCE.CERTIFICATENO, ACCEPTANCE.AID, COVER.INSURED, Acceptance.ISTYPE, COVER.SEGMENT, ACCEPTANCE.TOC, ACCEPTANCE.SDATE, ACCEPTANCE.EDATE, Cover.PHolder, ACCEPTANCE.BRANCH, ACCEPTANCE.ANAME, PROFILE.RESTRICTEDF, PROFILE.NAME, ACCEPTANCE.PDATE, ACCEPTANCE.PPDATE, ACCEPTANCE.NCDATE,  ACCEPTANCE.EXTPERIOD,     
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

DROP PROCEDURE QCLACC_4
GO
CREATE PROCEDURE QCLACC_4 (@P_POLICYNO AS VARCHAR(255), @P_CERTIFICATENO AS VARCHAR(255), @P_DATE AS DATETIME, @P_LOSSTIME as varchar(5)='12:00')   
AS   
SELECT top 10 Acceptance.ANO, Acceptance.AName, Acceptance.PDate, Acceptance.PPDate, Acceptance.NCDate, Acceptance.TOC, Acceptance.Branch, Acceptance.IStype
From ACCEPTANCE
Inner Join COVER on (COVER.CNO=ACCEPTANCE.CNO)
Left Join Acceptance mA on (mA.ANO=Acceptance.lANO)
Left Join Acceptance nA on (nA.pANO=Acceptance.ANO and nA.AStatus not in ('W','T') and nA.AType not in ('A') and not (nA.AType='C' and nA.NOREFUNDF in (1,2,4) and nA.PDate=@P_Date))
WHERE ACCEPTANCE.POLICYNO LIKE @P_POLICYNO AND ACCEPTANCE.CERTIFICATENO LIKE @P_CERTIFICATENO 
AND COVER.CStatus not in ('R','P','C') AND ACCEPTANCE.AType Not in ('A','C') AND ACCEPTANCE.AStatus not in ('W','T') AND ACCEPTANCE.ANO<>ACCEPTANCE.LANO   
and coalesce(mA.AStatus, Acceptance.AStatus) not in ('W','T') 
AND 
(
	(Select Top 1 RCover.RetroActiveF from RCover Where RCover.ANO=Acceptance.ANO Order by RCover.RetroActiveF Desc)=1 or
	(ACCEPTANCE.PDATE<=@P_DATE AND ACCEPTANCE.ExclusiveF=1) or 
	((ACCEPTANCE.PDATE<@P_DATE or (ACCEPTANCE.PDATE=@P_DATE AND ACCEPTANCE.STIME<=@P_LOSSTIME)) AND ACCEPTANCE.ExclusiveF=0)
)             
AND 
(
	(dbo.fn_Get_ExtPeriodDate(ACCEPTANCE.ExtRPeriod, 0, dbo.fn_Get_ExtPeriodDate(ACCEPTANCE.ExtPeriod, ACCEPTANCE.ExtPeriodInDaysF, coalesce(nA.PDate, Acceptance.EDate)))>@P_DATE AND ACCEPTANCE.ExclusiveF=1) or 
	((dbo.fn_Get_ExtPeriodDate(ACCEPTANCE.ExtRPeriod, 0, dbo.fn_Get_ExtPeriodDate(ACCEPTANCE.ExtPeriod, ACCEPTANCE.ExtPeriodInDaysF, coalesce(nA.PDate, Acceptance.EDate)))>@P_DATE or 
	(dbo.fn_Get_ExtPeriodDate(ACCEPTANCE.ExtRPeriod, 0, dbo.fn_Get_ExtPeriodDate(ACCEPTANCE.ExtPeriod, ACCEPTANCE.ExtPeriodInDaysF, coalesce(nA.PDate, Acceptance.EDate)))=@P_DATE AND ACCEPTANCE.ETIME>@P_LOSSTIME)) AND ACCEPTANCE.ExclusiveF=0)
) 
AND
(
	Acceptance.PDate<Acceptance.PPDate
)
Order By ACCEPTANCE.ANO Desc   

GO
DROP PROCEDURE QClaimRiskAssLimit
GO
CREATE PROCEDURE QClaimRiskAssLimit(@CNO as integer, @RType as varchar(10)='', @PLossDate as smalldatetime='')                    
AS                    
Declare @ANO Int
Declare @LossDate smalldatetime

Select @ANO=Claim.ANO, @LossDate=Case When coalesce(Event.Category,'R')='E' and Event.TreatyDateF=1 Then Event.Date else @PLossDate end
from Claim Left Join Event on (Event.EventNo=Claim.EventNo) 
Where Claim.CNO=@CNO

SELECT top 1 RiskAss.RiskAss, Case When ReClass.AssessmentExInwardF=1 and Acceptance.ISType in ('R','N','T','Q','S','A','X','P') Then 100 else RiskAss.PLimit end PLimit, Case When ReClass.AssessmentExInwardF=1 and Acceptance.ISType in ('R','N','T','Q','S','A','X','P') Then 100 else RiskAss.Limit end Limit, Acceptance.ISType, RiskAss.Code, RiskAss.HoldF, RiskAss.Share, RiskAss.Rate, RiskAss.Loading, RiskAss.RType                    
From Acceptance 
Inner Join Cover on (Cover.CNO=Acceptance.CNO)
Inner Join AInfo on (AInfo.ANO=Acceptance.ANO)
Inner Join RArrHeader on (RArrHeader.ANO=Acceptance.ANO)
Inner Join Reinsurance on (Reinsurance.RType in ('X1','X2','X3','X4','X5','X6','X7') and @LossDate Between Reinsurance.SDate and Reinsurance.EDate)
Inner Join ReClass on (ReClass.RNO=Reinsurance.RNO and ReClass.TOC=Acceptance.TOC and ReClass.AssessmentF=1)
Left Join RiskAss on (
	(RiskAss.RType='' or RiskAss.RType=@RType or @RType='')
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
WHERE Acceptance.ANO=@ANO
Order by                   
RiskAss.RYear Desc,        
Case When RiskAss.RType=@RType Then 1 Else 0 end Desc,
RiskAss.PriorityF Desc,                  
len(coalesce(RiskAss.ValueID1,'')) Desc, len(coalesce(RiskAss.ValueID2,'')) Desc, len(coalesce(RiskAss.ValueID3,'')) Desc, len(coalesce(RiskAss.ValueID4,'')) Desc, len(coalesce(RiskAss.ValueID5,'')) Desc,                   
len(coalesce(RiskAss.ValueID6,'')) Desc, len(coalesce(RiskAss.ValueID7,'')) Desc, len(coalesce(RiskAss.ValueID8,'')) Desc, len(coalesce(RiskAss.ValueID9,'')) Desc, len(coalesce(RiskAss.ValueID10,'')) Desc,                   
len(coalesce(RiskAss.ValueID11,'')) Desc, len(coalesce(RiskAss.ValueID12,'')) Desc, len(coalesce(RiskAss.ValueID13,'')) Desc, len(coalesce(RiskAss.ValueID14,'')) Desc, len(coalesce(RiskAss.ValueID15,'')) Desc,                   
RiskAss.Limit Desc, RiskAss.Loading, RiskAss.HoldF        

GO
DROP Procedure QGet_AutoApplyFeeDuty
GO
CREATE Procedure QGet_AutoApplyFeeDuty(@P_ANO as integer)
AS
Declare @FDTAB Table(LANO Int, Segment varchar(10), FDID varchar(10), FDType varchar(2), REMARK varchar(255), Currency varchar(10), Amount Float, AmountPCT Float, AmountPCTBased Int)

Declare @P_LANO as integer


insert into @FDTAB
Select A.LANO, C.Segment, F.FDID, F.FDType, F.Description as Remark, F.Currency, F.Amount, F.AmountPCT, F.AMOUNTPCTBASED 
from Acceptance A
Inner Join Cover C on (C.CNO=A.CNO and A.ISType in ('I','L'))
Left Join PCalc P on (P.ANO=A.ANO)
Inner Join SysTab on (1=1)
Inner Join FDTAB F on ((F.Atype='ALL' or F.Atype = A.AType) and F.Currency=coalesce(P.Currency, SysTab.Currency) and F.AutoApplyF=1 and F.FDType in ('F','D'))
Left Join FDTABTOC on (FDTABTOC.FDID=F.FDID and FDTABTOC.TOC=A.TOC)
Where A.ANO=@P_ANO and (F.ApplyTOCF=0 or coalesce(FDTABTOC.TOC,'')<>'')

if exists(
	Select Top 1 F.FDID
	from @FDTAB F
	Inner join FDTABDET Fd on (Fd.FDID=F.FDID and (FD.Segment='<All>' or FD.Segment=F.Segment) and fd.Amount<>0)
)
BEGIN
	Select @P_LANO=LANO from @FDTAB F

	if @P_LANO<>@P_ANO -- Individual or Certificate
	BEGIN
		Select Top 1 F.FDID, F.FDType, F.REMARK, F.Currency, Fd.Amount, 0 as AmountPCT, 0 as AmountPCTBased
		from @FDTAB F
		Cross Apply (
			Select 
			sum(Premium) as Premium,             
			sum(Premium*dbo.Premium_Discount(P.CANO,P.Code,P.PolicyYear)/100) as Discount
			from PREMIUM_CALCULATION_BASE(@P_ANO) P
			Where P.Currency=F.Currency
		) P
		Cross Apply (
			Select Fd.Amount
			from FDTABDET FD
			Where Fd.FDID=F.FDID and (FD.Segment='<All>' or FD.Segment=F.Segment) and (P.Premium-P.Discount) Between fd.Lower and fd.upper and fd.Amount<>0
		) Fd
	End
	ELSE
	BEGIN
		Select Top 1 F.FDID, F.FDType, F.REMARK, F.Currency, Fd.Amount, 0 as AmountPCT, 0 as AmountPCTBased
		from @FDTAB F
		Cross Apply (
			Select sum(P.Premium) as Premium, sum(P.Discount) as Discount
			from Acceptance
			Cross Apply (
				Select 
				sum(Premium) as Premium,             
				sum(Premium*dbo.Premium_Discount(P.CANO,P.Code,P.PolicyYear)/100) as Discount
				from PREMIUM_CALCULATION_BASE(Acceptance.ANO) P
				Where P.Currency=F.Currency
			) P
			Where Acceptance.AType='N' and Acceptance.LANO=@P_ANO 
		) P
		Cross Apply (
			Select Fd.Amount
			from FDTABDET FD
			Where Fd.FDID=F.FDID and (FD.Segment='<All>' or FD.Segment=F.Segment) and (P.Premium-P.Discount) Between fd.Lower and fd.upper and fd.Amount<>0
		) Fd


	END
END
Else
BEGIN
	Select Top 1 F.FDID, F.FDType, F.REMARK, F.Currency, F.Amount, F.AmountPCT as AmountPCT, F.AmountPCTBased as AmountPCTBased
	from @FDTAB F
	Where F.AmountPCT<>0 or F.AMOUNTPCTBASED=2
END

GO
DROP Procedure QGetListClaimCoinsurance
GO
CREATE Procedure QGetListClaimCoinsurance(@P_CNO Integer)      
as       

Declare @Coinsurance as table(CNO Int, ID Int, Share Float, DocNo varchar(20), CCOLLECTIONF bit)

Insert into @Coinsurance
Select COINSURANCE.CNO, COINSURANCE.ID, COINSURANCE.SHARE, COINSURANCE.DOCNO, COINSURANCE.CCOLLECTIONF
FROM CLAIM
INNER JOIN ACCEPTANCE ON (ACCEPTANCE.ANO=CLAIM.ANO)
INNER JOIN COINSURANCE ON (COINSURANCE.CNO=ACCEPTANCE.CNO)
WHERE COINSURANCE.ClaimNotFullCoverF=0 and CLAIM.CNO=@P_CNO

Union All

Select COINSURANCE.CNO, COINSURANCE.ID, COINSURANCEDET.SHARE, COINSURANCE.DOCNO, COINSURANCE.CCOLLECTIONF
FROM CLAIM
INNER JOIN ACCEPTANCE ON (ACCEPTANCE.ANO=CLAIM.ANO)
INNER JOIN COINSURANCE ON (COINSURANCE.CNO=ACCEPTANCE.CNO)
INNER JOIN COINSURANCEDET on (COINSURANCEDET.CNO=COINSURANCE.CNO and COINSURANCEDET.ID=COINSURANCE.ID)
INNER JOIN PROFILE ON (PROFILE.ID=COINSURANCE.ID)
OUTER APPLY (SELECT TOP 1 LCALC.TOR, LCALC.CODE AS RCODE FROM CCALC, LCALC WHERE CCALC.CNO=CLAIM.CNO AND LCALC.CNO=CCALC.CNO Order By Case When LCALC.Currency=CCALC.Currency Then 0 Else 1 End, Code, TOR) LCALC
WHERE COINSURANCE.ClaimNotFullCoverF=1 and CLAIM.CNO=@P_CNO
And (
	COINSURANCEDET.Code=LCALC.RCODE   
	or   
	Exists (Select Top 1 RCalc.Code from RCalc Inner Join RateCov on (RateCov.Code=COINSURANCEDET.Code and RateCov.TOR=RCalc.TOR) Where RCalc.ANO=ACCEPTANCE.ANO and RCalc.Code=LCALC.RCODE)      
)  



SELECT Cast(0 as bit) as ProcessFlag, 'Member' as Type, PROFILE.ID, PROFILE.Salutation + ' ' + PROFILE.NAME as Name, COINSURANCE.DOCNO, COINSURANCE.SHARE, COINSURANCE.CCOLLECTIONF
FROM CLAIM
INNER JOIN ACCEPTANCE ON (ACCEPTANCE.ANO=CLAIM.ANO)
INNER JOIN @COINSURANCE COINSURANCE ON (COINSURANCE.CNO=ACCEPTANCE.CNO)
INNER JOIN PROFILE ON (PROFILE.ID=COINSURANCE.ID)
WHERE CLAIM.CNO=@P_CNO


UNION ALL

SELECT Cast(0 as bit) as ProcessFlag, 'Member' as Type, '' AS ID, SYSTAB.COMPANY AS NAME, ''  AS DOCNO, ISOURCE.SHARE, Cast(0 as bit) as CCOLLECTIONF
FROM CLAIM
INNER JOIN ACCEPTANCE ON (ACCEPTANCE.ANO=CLAIM.ANO)
INNER JOIN COVER ON (COVER.CNO=ACCEPTANCE.CNO)
INNER JOIN ISOURCE ON (ISOURCE.CNO=COVER.CNO)
INNER JOIN SYSTAB ON (1=1)
WHERE Acceptance.ISTYPE='C' AND CLAIM.CNO=@P_CNO

UNION ALL

SELECT Cast(0 as bit) as ProcessFlag, 'LEADER' as Type, Max(PROFILE.ID) as ID, MAX(PROFILE.Salutation + ' ' + PROFILE.NAME) as Name, ''  AS DOCNO, 100-MAX(ISOURCE.SHARE)-coalesce(SUM(COINSURANCE.SHARE),0) as share, Cast(0 as bit) as CCOLLECTIONF
FROM CLAIM
INNER JOIN ACCEPTANCE ON (ACCEPTANCE.ANO=CLAIM.ANO)
INNER JOIN COVER ON (COVER.CNO=ACCEPTANCE.CNO)
INNER JOIN ISOURCE ON (ISOURCE.CNO=COVER.CNO)
INNER JOIN PROFILE ON (PROFILE.ID=ISOURCE.ID)
LEFT JOIN @COINSURANCE COINSURANCE ON (COINSURANCE.CNO=COVER.CNO)
WHERE Acceptance.ISTYPE='C' AND CLAIM.CNO=@P_CNO
HAVING MAX(Acceptance.ISTYPE)='C'

UNION ALL

SELECT Cast(0 as bit) as ProcessFlag, 'LEADER' as Type, '' AS ID, Max(SYSTAB.COMPANY) AS NAME, ''  AS DOCNO, 100-coalesce(SUM(COINSURANCE.SHARE),0) as Share, Cast(0 as bit) as CCOLLECTIONF
FROM CLAIM
INNER JOIN ACCEPTANCE ON (ACCEPTANCE.ANO=CLAIM.ANO)
INNER JOIN COVER ON (COVER.CNO=ACCEPTANCE.CNO)
INNER JOIN @COINSURANCE COINSURANCE ON (COINSURANCE.CNO=COVER.CNO)
INNER JOIN SYSTAB ON (1=1)
WHERE Acceptance.ISTYPE='L' AND CLAIM.CNO=@P_CNO
HAVING MAX(Acceptance.ISTYPE)='L'  
GO

DROP PROCEDURE QMasterAcceptance
GO
CREATE PROCEDURE QMasterAcceptance (@P_ANO as integer)        
AS        
SELECT Acceptance.PolicyNo, Acceptance.CertificateNo, Acceptance.Branch, Acceptance.REGNO, Acceptance.RegDate, Acceptance.ADATE, Acceptance.SDate, Acceptance.EDate, Acceptance.UserID, Acceptance.LUSERID, 
SysTab.Currency AS CCY, 
(SELECT coalesce(SUM(PCALC.TSI*PCALC.RATE),0) FROM  PCALC WHERE PCALC.ANO=ACCEPTANCE.ANO AND ACCEPTANCE.PSTATUS='C')*CASE WHEN ACCEPTANCE.QTY=0 THEN 1 ELSE ACCEPTANCE.QTY END AS TSI,
(SELECT coalesce(SUM(PCALC.OURSHARE*PCALC.RATE),0) FROM  PCALC WHERE PCALC.ANO=ACCEPTANCE.ANO AND ACCEPTANCE.PSTATUS='C')*CASE WHEN ACCEPTANCE.QTY=0 THEN 1 ELSE ACCEPTANCE.QTY END AS OURSHARE, 
(SELECT coalesce(SUM(PCALC.GROSS*PCALC.RATE),0) FROM  PCALC WHERE PCALC.ANO=ACCEPTANCE.ANO AND ACCEPTANCE.PSTATUS='C')*CASE WHEN ACCEPTANCE.QTY=0 THEN 1 ELSE ACCEPTANCE.QTY END AS GROSS,
Year(Acceptance.SDate) as RYear, 
Acceptance.ATYPE, Acceptance.ASTATUS, Acceptance.LANO, Acceptance.ANO, Acceptance.CNO,        
Cover.CDate, Cover.ASource, Cover.PPeriod, Cover.CSTATUS, Cover.CoverNoteF, Cover.Voyage, Cover.OpenFlag, Acceptance.AdjustableF, Acceptance.RenewableF, Acceptance.ISType, Cover.PolicyType, Acceptance.TOC, Cover.MO, Acceptance.BANO,  Acceptance.RANO, Acceptance.RequestF, Acceptance.RequestName,  
ACCCOMPSHEETH.CID, acceptance.CANO , acceptance.ConjunctionF, pAcceptance.AType as pAType, Acceptance.pAStatus
FROM Acceptance 
Inner Join Cover on (Cover.CNO=Acceptance.CNO)
Left Join Acceptance pAcceptance on (pAcceptance.ANO=Acceptance.pANO) 
Left Join ACCCOMPSHEETH on (ACCCOMPSHEETH.ANO=Acceptance.OANO)
Inner join SysTab on (1=1)
WHERE Acceptance.ANO=@P_ANO 

GO
DROP Procedure QPOLICY_DEPOSIT_CURRENT
GO
CREATE Procedure QPOLICY_DEPOSIT_CURRENT(@P_ANO integer, @P_Currency varchar(10)='')                
as                

Declare @AStatus as varchar(1)

Select @AStatus=Acceptance.AStatus from Acceptance Where ANO=@P_ANO

if @AStatus='T' or @AStatus='I' 
	Select     
	AccAss.Currency,     
	sum(Case When AccAss.DepositF=0 Then AccAss.Amount else 0 end) as Total_Premium
	from AccAss    
	Where AccAss.ANO=@P_ANO 
	and ((AccAss.Type in ('DI','IC') and AccAss.Code in ('P','U','O','J')) or (AccAss.Type in ('IR','IT','IX') and AccAss.Code in ('P','O','J')))     
	Group by AccAss.Currency    
Else
	Select D.Currency, D.Premium-D.Discount as Total_Premium
	from Premium_calculation(@P_ANO) D 

GO

DROP Procedure QPolicy_Rate
GO
CREATE Procedure QPolicy_Rate(@P_ANO as int)     
as     
Select ICALC.Code, ICALC.SDate, SUM(ICALC.TSI) as TSI, Max(ICALC.PrevMinRate) as PrevMinRate, Max(ICALC.PrevMaxRate) as PrevMaxRate, Max(ICALC.MinRate) as MinRate, Max(ICALC.MaxRate) as MaxRate     
from     
(     
Select ICALC.Code, ICALC.SDate,     
MAX(ICALC.TSI*(CASE WHEN RCOVER.PCTLOSS=0 THEN 100 ELSE RCOVER.PCTLOSS END)/(CASE WHEN RCOVER.PCTLOSS=0 THEN 100 ELSE RCOVER.PCTLOSS END+RCOVER.PAddition)) as TSI,     
CAST(0 as FLOAT) as PREVMINRATE,     
CAST(0 as FLOAT) as PREVMAXRATE,     
SUM(ICALC.GROSS*100/(100-RCover.Discount)/ICALC.TSI/(Case When RCOVER.LOADING=0 THEN 1 ELSE RCOVER.LOADING END)*Case When ICalc.PCTADJ<>0 Then cast(100 as Float)/ICALC.PCTADJ else 1 end
*Case When RCover.PCalc='F' and Cover.Voyage=0 then 
(
	Case When Acceptance.EXCLUSIVEF=0 and Acceptance.STime<Acceptance.ETime and ICalc.EDate=Acceptance.EDate Then
		1/dbo.fn_Premium_calc_prorata(ICalc.sDate, dateadd(day,1,ICalc.edate), datediff(day,ICalc.SDate,dateadd(month,(Case When TOC.PTerm=0 Then 12 else TOC.PTerm End),ICalc.sDate)), (Case When TOC.PTerm=0 Then 12 else TOC.PTerm End), Cover.PPeriod)
	else
		1/dbo.fn_Premium_calc_prorata(ICalc.sDate, ICalc.EDate, datediff(day,ICalc.SDate,dateadd(month,(Case When TOC.PTerm=0 Then 12 else TOC.PTerm End),ICalc.sDate)), (Case When TOC.PTerm=0 Then 12 else TOC.PTerm End), Cover.PPeriod)
	End
) 
else 
(
	Case When RCover.PCalc='P' and Cover.Voyage=0 then 
		Case When Acceptance.EXCLUSIVEF=0 and Acceptance.STime<Acceptance.ETime and ICalc.EDate=Acceptance.EDate Then
			1/dbo.fn_Premium_calc_prorata(ICalc.sDate, dateadd(day,1,ICalc.edate), Cover.Prorata, (Case When TOC.PTerm=0 Then 12 else TOC.PTerm End), Cover.PPeriod)
		else
			1/dbo.fn_Premium_calc_prorata(ICalc.sDate, ICalc.EDate, Cover.Prorata, (Case When TOC.PTerm=0 Then 12 else TOC.PTerm End), Cover.PPeriod)
		End
	else 
		1/ICALC.Prorata 
	end
) 
end
)*100+0.0000000001 as MINRATE,     

SUM(ICALC.GROSS*100/(100-RCover.Discount)/ICALC.TSI/(Case When RCOVER.LOADING=0 THEN 1 ELSE RCOVER.LOADING END)*Case When ICalc.PCTADJ<>0 Then cast(100 as Float)/ICALC.PCTADJ else 1 end
*Case When RCover.PCalc='F' and Cover.Voyage=0 then 
(
	Case When Acceptance.EXCLUSIVEF=0 and Acceptance.STime<Acceptance.ETime and ICalc.EDate=Acceptance.EDate Then
		1/dbo.fn_Premium_calc_prorata(ICalc.sDate, dateadd(day,1,ICalc.edate), datediff(day,ICalc.SDate,dateadd(month,(Case When TOC.PTerm=0 Then 12 else TOC.PTerm End),ICalc.sDate)), (Case When TOC.PTerm=0 Then 12 else TOC.PTerm End), Cover.PPeriod)
	else
		1/dbo.fn_Premium_calc_prorata(ICalc.sDate, ICalc.EDate, datediff(day,ICalc.SDate,dateadd(month,(Case When TOC.PTerm=0 Then 12 else TOC.PTerm End),ICalc.sDate)), (Case When TOC.PTerm=0 Then 12 else TOC.PTerm End), Cover.PPeriod)
	End
) 
else 
(
	Case When RCover.PCalc='P' and Cover.Voyage=0 then 
		Case When Acceptance.EXCLUSIVEF=0 and Acceptance.STime<Acceptance.ETime and ICalc.EDate=Acceptance.EDate Then
			1/dbo.fn_Premium_calc_prorata(ICalc.sDate, dateadd(day,1,ICalc.edate), Cover.Prorata, (Case When TOC.PTerm=0 Then 12 else TOC.PTerm End), Cover.PPeriod)
		else
			1/dbo.fn_Premium_calc_prorata(ICalc.sDate, ICalc.EDate, Cover.Prorata, (Case When TOC.PTerm=0 Then 12 else TOC.PTerm End), Cover.PPeriod)
		End
	else 
		1/ICALC.Prorata 
	end
) 
end
)*100-0.0000000001 as MAXRATE     
from ACCEPTANCE
Inner Join COVER on (Cover.CNO=Acceptance.CNO)
Inner Join ICalc on (ICalc.ANO=Acceptance.ANO)
Inner Join RCover on (RCover.ANO=ICALC.ANO and RCover.Code=ICALC.Code and RCover.SDate=ICALC.SDate and RCover.EDate=ICALC.EDate)
Inner Join ICover on (ICover.INO=ICalc.INO)
Inner JOin TOC on (TOC.TOC=Acceptance.TOC)
Where ACCEPTANCE.ANO=@P_ANO 
and Acceptance.ISType in ('I','C','L') 
and ICALC.TSI<>0 and ICALC.GROSS<>0
and Cover.PROFORMAF=0
Group By ICalc.INO, ICALC.Code, ICALC.SDate     
     
Union All     
     
Select ICALC.Code, ICALC.SDate,     
0 as TSI,     
SUM(ICALC.GROSS*100/(100-RCover.Discount)/ICALC.TSI/(Case When RCOVER.LOADING=0 THEN 1 ELSE RCOVER.LOADING END)*Case When ICalc.PCTADJ<>0 Then cast(100 as Float)/ICALC.PCTADJ else 1 end
*Case When RCover.PCalc='F' and Cover.Voyage=0 then 
(
	Case When Acceptance.EXCLUSIVEF=0 and Acceptance.STime<Acceptance.ETime and ICalc.EDate=Acceptance.EDate Then
		1/dbo.fn_Premium_calc_prorata(ICalc.sDate, dateadd(day,1,ICalc.edate), datediff(day,ICalc.SDate,dateadd(month,(Case When TOC.PTerm=0 Then 12 else TOC.PTerm End),ICalc.sDate)), (Case When TOC.PTerm=0 Then 12 else TOC.PTerm End), Cover.PPeriod)
	else
		1/dbo.fn_Premium_calc_prorata(ICalc.sDate, ICalc.EDate, datediff(day,ICalc.SDate,dateadd(month,(Case When TOC.PTerm=0 Then 12 else TOC.PTerm End),ICalc.sDate)), (Case When TOC.PTerm=0 Then 12 else TOC.PTerm End), Cover.PPeriod)
	End
) 
else 
(
	Case When RCover.PCalc='P' and Cover.Voyage=0 then 
		Case When Acceptance.EXCLUSIVEF=0 and Acceptance.STime<Acceptance.ETime and ICalc.EDate=Acceptance.EDate Then
			1/dbo.fn_Premium_calc_prorata(ICalc.sDate, dateadd(day,1,ICalc.edate), Cover.Prorata, (Case When TOC.PTerm=0 Then 12 else TOC.PTerm End), Cover.PPeriod)
		else
			1/dbo.fn_Premium_calc_prorata(ICalc.sDate, ICalc.EDate, Cover.Prorata, (Case When TOC.PTerm=0 Then 12 else TOC.PTerm End), Cover.PPeriod)
		End
	else 
		1/ICALC.Prorata 
	end
) 
end
)*100+0.0000000001 as PREVMINRATE,     

SUM(ICALC.GROSS*100/(100-RCover.Discount)/ICALC.TSI/(Case When RCOVER.LOADING=0 THEN 1 ELSE RCOVER.LOADING END)*Case When ICalc.PCTADJ<>0 Then cast(100 as Float)/ICALC.PCTADJ else 1 end
*Case When RCover.PCalc='F' and Cover.Voyage=0 then 
(
	Case When Acceptance.EXCLUSIVEF=0 and Acceptance.STime<Acceptance.ETime and ICalc.EDate=Acceptance.EDate Then
		1/dbo.fn_Premium_calc_prorata(ICalc.sDate, dateadd(day,1,ICalc.edate), datediff(day,ICalc.SDate,dateadd(month,(Case When TOC.PTerm=0 Then 12 else TOC.PTerm End),ICalc.sDate)), (Case When TOC.PTerm=0 Then 12 else TOC.PTerm End), Cover.PPeriod)
	else
		1/dbo.fn_Premium_calc_prorata(ICalc.sDate, ICalc.EDate, datediff(day,ICalc.SDate,dateadd(month,(Case When TOC.PTerm=0 Then 12 else TOC.PTerm End),ICalc.sDate)), (Case When TOC.PTerm=0 Then 12 else TOC.PTerm End), Cover.PPeriod)
	End
) 
else 
(
	Case When RCover.PCalc='P' and Cover.Voyage=0 then 
		Case When Acceptance.EXCLUSIVEF=0 and Acceptance.STime<Acceptance.ETime and ICalc.EDate=Acceptance.EDate Then
			1/dbo.fn_Premium_calc_prorata(ICalc.sDate, dateadd(day,1,ICalc.edate), Cover.Prorata, (Case When TOC.PTerm=0 Then 12 else TOC.PTerm End), Cover.PPeriod)
		else
			1/dbo.fn_Premium_calc_prorata(ICalc.sDate, ICalc.EDate, Cover.Prorata, (Case When TOC.PTerm=0 Then 12 else TOC.PTerm End), Cover.PPeriod)
		End
	else 
		1/ICALC.Prorata 
	end
) 
end
)*100-0.0000000001 as PREVMAXRATE,
CAST(0 as FLOAT) as MINRATE,     
CAST(0 as FLOAT) as MAXRATE     
from ACCEPTANCE
Inner Join ACCEPTANCE PACCEPTANCE on (PACCEPTANCE.ANO=ACCEPTANCE.PANO)
Inner Join COVER on (Cover.CNO=PAcceptance.CNO)
Inner Join ICalc on (ICalc.ANO=PACCEPTANCE.ANO)
Inner Join RCover on (RCover.ANO=ICALC.ANO and RCover.Code=ICALC.Code and RCover.SDate=ICALC.SDate and RCover.EDate=ICALC.EDate)
Inner join ICover on (ICover.INO=ICalc.INO)
Inner Join TOC on (TOC.TOC=Acceptance.TOC)
Where ACCEPTANCE.ANO=@P_ANO 
and PAcceptance.ISType in ('I','C','L')
and ICALC.TSI<>0 and ICALC.GROSS<>0
and Cover.PROFORMAF=0
Group By ICalc.INO, ICALC.Code, ICALC.SDate     
) ICALC     
Group By ICALC.Code, ICALC.SDate     
Having SUM(ICALC.TSI)<>0     



GO

DROP Procedure QProduction_To_Adm
GO
CREATE Procedure QProduction_To_Adm(@P_ANO as int)                                
as                                
Select A1.ID, A1.TOC, A1.Type, A1.Currency, A1.Date, A1.BillDate,
Max(coalesce(Payor.PShortName, coalesce(APayor.PShortName, MPayor.PShortName))) as PShortName,
Case 
When A2.SplitDNCNF=1 and A1.CAmount=0 and Coalesce(A3.ANO,0)<>0 Then 
	Case
	When SysTab.DueByEffectiveF=1 then 
		A3.PDate
	Else 
		A2.ADate
	End
Else 
	A1.BillDate 
end as pBillDate,
A1.DocNo as DocNo, A1.RefNo,    
Case When SysTab.SplitPremiumAndClaimF=1 and A1.Code in ('A','R') Then 'Claim' else 'Premium' end as Subject,         
Max(Case When coalesce(AL.RefNo,'')=A2.RefNo and A2.ISType<>'T' Then coalesce(AL.AName,Case When A2.AName<>'' then A2.AName else A2.Remarks end) else Case When A2.AName<>'' then A2.AName else A2.Remarks end end) as Remarks,                                   
Case When (coalesce(APayor.ScheduleF,coalesce(Payor.ScheduleF,0))=1) or (coalesce(APayor.RiskScheduleF,coalesce(Payor.RiskScheduleF,0))=1) or (Case When isnull(APayor.ANO,0)=0 Then (Case When isnull(MPayor.ANO,0)=0 Then Payor.PolicyYearF else MPayor.PolicyYearF end) else APayor.PolicyYearF end)=1 Then A1.SDate else A2.SDate end as SDate,                                
Min(Case When (coalesce(APayor.ScheduleF,coalesce(Payor.ScheduleF,0))=1) or (coalesce(APayor.RiskScheduleF,coalesce(Payor.RiskScheduleF,0))=1) or (Case When isnull(APayor.ANO,0)=0 Then (Case When isnull(MPayor.ANO,0)=0 Then Payor.PolicyYearF else MPayor.PolicyYearF end) else APayor.PolicyYearF end)=1 Then A1.EDate else A2.EDate end) as EDate,                 
Max(A2.Source) as Source,                                
Cast(Max(Case When A2.SplitDNCNF=1 and A1.CAmount=0 and Coalesce(A3.ANO,0)<>0 Then 1 Else 0 end) as Bit) as DataReversalF,   
Case When A1.CAmount=0 and Coalesce(A3.Branch,'')<>'' Then A3.Branch Else A2.Branch end as Branch,        
cast(Max(cast(A1.CommPoolF as Integer)) as Bit) as CommPoolF,     
cast(Max(cast(MParam.WriteF as Integer)) as Bit) as WriteF,     
Min(A1.SDate) as MINSDate, Max(A1.SDate) as MAXSDate,                  
Min(A1.ACNO)  as MinACNO, Max(A1.ACNO) as MaxACNO,                        
Max(coalesce(RCover.Code, A1.RCode)) as RCode,  
Case When Max(cast(SysTab.CalculationRoundingF as Int))=1 then dbo.RoundCCY(sum(Case When A1.Code='P' then A1.Amount else 0 end), A1.Currency) else sum(Case When A1.Code='P' then A1.Amount else 0 end) end as Amount_1,  
Case When Max(cast(SysTab.CalculationRoundingF as Int))=1 then dbo.RoundCCY(sum(Case When A1.Code='C' then A1.Amount else 0 end), A1.Currency) else sum(Case When A1.Code='C' then A1.Amount else 0 end) end as Amount_2,  
Case When Max(cast(SysTab.CalculationRoundingF as Int))=1 then dbo.RoundCCY(sum(Case When A1.Code='F' and coalesce(A1.CodeExt,'')='' then A1.Amount else 0 end), A1.Currency) else sum(Case When A1.Code='F' and coalesce(A1.CodeExt,'')='' then A1.Amount else 0 end) end as Amount_3,  
Case When Max(cast(SysTab.CalculationRoundingF as Int))=1 then dbo.RoundCCY(sum(Case When (A1.Code='D' and coalesce(A1.CodeExt,'')='') or (A1.Code='G') then A1.Amount else 0 end), A1.Currency) else sum(Case When (A1.Code='D' and coalesce(A1.CodeExt,'')='') or (A1.Code='G') then A1.Amount else 0 end) end as Amount_4,  
Case When Max(cast(SysTab.CalculationRoundingF as Int))=1 then dbo.RoundCCY(sum(Case When A1.Code='O' then A1.Amount else 0 end), A1.Currency) else sum(Case When A1.Code='O' then A1.Amount else 0 end) end as Amount_5,  
Case When Max(cast(SysTab.CalculationRoundingF as Int))=1 then dbo.RoundCCY(sum(Case When A1.Code='A' then A1.Amount else 0 end), A1.Currency) else sum(Case When A1.Code='A' then A1.Amount else 0 end) end as Amount_6,  
Case When Max(cast(SysTab.CalculationRoundingF as Int))=1 then dbo.RoundCCY(sum(Case When A1.Code='R' then A1.Amount else 0 end), A1.Currency) else sum(Case When A1.Code='R' then A1.Amount else 0 end) end as Amount_10,  
Case When Max(cast(SysTab.CalculationRoundingF as Int))=1 then dbo.RoundCCY(sum(Case When A1.Code in ('D','F') and coalesce(A1.CodeExt,'')='3' then A1.Amount else 0 end), A1.Currency) else sum(Case When A1.Code in ('D','F') and coalesce(A1.CodeExt,'')='3' then A1.Amount else 0 end) end as Amount_12,  
Case When Max(cast(SysTab.CalculationRoundingF as Int))=1 then dbo.RoundCCY(sum(Case When A1.Code='V' then A1.Amount else 0 end), A1.Currency) else sum(Case When A1.Code='V' then A1.Amount else 0 end) end as Amount_13,  
Case When Max(cast(SysTab.CalculationRoundingF as Int))=1 then dbo.RoundCCY(sum(Case When A1.Code='T' then A1.Amount else 0 end), A1.Currency) else sum(Case When A1.Code='T' then A1.Amount else 0 end) end as Amount_14,  
Case When Max(cast(SysTab.CalculationRoundingF as Int))=1 then dbo.RoundCCY(sum(Case When A1.Code in ('D','F') and coalesce(A1.CodeExt,'')='1' then A1.Amount else 0 end), A1.Currency) else sum(Case When A1.Code in ('D','F') and coalesce(A1.CodeExt,'')='1' then A1.Amount else 0 end) end as Amount_15,  
Case When Max(cast(SysTab.CalculationRoundingF as Int))=1 then dbo.RoundCCY(sum(Case When A1.Code in ('D','F') and coalesce(A1.CodeExt,'')='2' then A1.Amount else 0 end), A1.Currency) else sum(Case When A1.Code in ('D','F') and coalesce(A1.CodeExt,'')='2' then A1.Amount else 0 end) end as Amount_16,  
Case When Max(cast(SysTab.CalculationRoundingF as Int))=1 then dbo.RoundCCY(sum(Case When A1.Code='J' then A1.Amount else 0 end), A1.Currency) else sum(Case When A1.Code='J' then A1.Amount else 0 end) end as Amount_19,  
Case When Max(cast(SysTab.CalculationRoundingF as Int))=1 then dbo.RoundCCY(sum(Case When A1.Code='U' then A1.Amount else 0 end), A1.Currency) else sum(Case When A1.Code='U' then A1.Amount else 0 end) end as Amount_20  
from AccAss A1                                
Inner Join MParam on (MParam.Type=A1.Type)  
Inner Join Acceptance A2 on (A2.ANO=A1.ANO)                                
Left join  Acceptance A3 on (A3.ANO=A2.pANO)      
Inner Join Cover C on (C.CNO=A2.CNO)                    
Left Join Acceptance AL on (AL.ANO=A2.LANO and C.OpenFlag=0)                    
Left Join APayor on (APayor.ANO=A2.ANO and A2.LANO<>-1 and A2.ANO<>A2.LANO)                                
Left Join Payor on (Payor.ANO=A2.ANO and A2.LANO=-1)                   
Left Join Payor MPayor on (MPayor.ANO=A2.LANO and A2.LANO<>-1)      
Left Join RCover on (RCover.ANO=A2.ANO and RCover.Code=A1.RCode and RCover.SDate=A1.SDate and RCover.Category='M')  
Inner Join SysTab on (1=1)     
Where A1.ANO=@P_ANO                                
Group By A1.DocNo, A1.RefNo, A1.Type, A1.ID, A1.TOC, A1.Currency, A1.Date, A1.BillDate,
Case 
When A2.SplitDNCNF=1 and A1.CAmount=0 and Coalesce(A3.ANO,0)<>0 Then 
	Case
	When SysTab.DueByEffectiveF=1 then 
		A3.PDate
	Else 
		A2.ADate
	End
Else 
	A1.BillDate 
end,         
Case When SysTab.SplitPremiumAndClaimF=1 and A1.Code in ('A','R') Then 'Claim' else 'Premium' end,  
Case When (coalesce(APayor.ScheduleF,coalesce(Payor.ScheduleF,0))=1) or (coalesce(APayor.RiskScheduleF,coalesce(Payor.RiskScheduleF,0))=1) or (Case When isnull(APayor.ANO,0)=0 Then (Case When isnull(MPayor.ANO,0)=0 Then Payor.PolicyYearF else MPayor.PolicyYearF end) else APayor.PolicyYearF end)=1 Then A1.SDate else A2.SDate end,                  
Case When A1.CAmount=0 and Coalesce(A3.Branch,'')<>'' Then A3.Branch Else A2.Branch end   
Order By A1.DocNo, A1.RefNo, A1.Type, A1.ID, A1.TOC, A1.Currency, A1.Date, A1.BillDate,
Case 
When A2.SplitDNCNF=1 and A1.CAmount=0 and Coalesce(A3.ANO,0)<>0 Then 
	Case
	When SysTab.DueByEffectiveF=1 then 
		A3.PDate
	Else 
		A2.ADate
	End
Else 
	A1.BillDate 
end

GO

DROP Procedure QRCESSIONDET 
GO
CREATE Procedure QRCESSIONDET (@P_ANO integer,@P_RID varchar(255), @P_ID varchar(255), @P_DocNo varchar(255), @P_CCY varchar(255), @P_SDate DateTime, @P_EDate DateTime, @P_Code varchar(10), @P_AdjustableF bit,@P_TSI as Float=0, @P_ASDate as DateTime=0)   
              
AS            
Declare @Premium_Treaty_Discount as Float            
Declare @Premium_Discount as Float            
Declare @Premium_Commission as Float            
Declare @Premium_Commission_Inward as Float            
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
Declare @P_OnMinPremiumF as Bit    
Declare @P_PPCT as Float    
Declare @P_OnNetPremiumF as Bit    
Declare @P_RNO as int    
Declare @P_RType as varchar(10)        
Declare @P_OPFEEPCT as Float    
Declare @P_FEE as Float    
Declare @P_OANO as int    
Declare @P_COMMPOLICYF as Bit    
Declare @P_PFactor as Float  
Declare @P_IFee as Float  
Declare @P_Period as Int  
Declare @P_Tabarru as Float  
Declare @P_RITabarruF as Bit  
Declare @P_OPFEEF as Bit  
Declare @P_AEDate as smalldatetime
Declare @P_LANO as Int

Select     
@P_Period=cast(datediff(Month,A.SDate, @P_SDate) as integer) / 12 + 1,  
@P_ASDate=A.SDate,
@P_AEDate=A.EDate,
@P_NOFYEARS=datediff(year,A.SDate, A.EDate),     
@P_TOC=A.TOC,     
@P_AType=A.AType,     
@P_ONGROSSNET=R.ONGROSSNET,     
@P_RateConF=R3.RateConF,     
@P_NETRATE=R2.NETRATE,    
@P_NETRATEDet=R4.NETRATE,    
@P_COMM=CASE WHEN R3.COMM<>0 Then R3.COMM ELSE R2.COMM END,    
@P_COMMN=CASE WHEN R3.COMMN<>0 Then R3.COMMN ELSE R2.COMMN END,    
@P_OnMinPremiumF=R2.OnMinPremiumF,    
@P_PPCT=R2.PPCT,    
@P_OnNetPremiumF=R2.OnNetPremiumF,     
@P_RNO=R1.RNO,    
@P_RType=R1.RType,    
@P_OANO=A.OANO,    
@P_FEE=R2.FEE,    
@P_COMMPOLICYF=R2.COMMPOLICYF,  
@P_PFactor=Case When A.ISType='R' Then (100-I.UJrohCedant)/100*(100+I.UjrohReins)/100 else 1 end,  
@Premium_Commission_Inward=coalesce(I2.Fee+I2.HF,coalesce(I.Fee+I.HF,0))+coalesce(I.OC,0),  
@P_Tabarru=(100-A.Ujroh),  
@P_OPFEEF=R3.OPFEEF,
@P_LANO=A.LANO
from Acceptance A  
Inner Join RarrHeader R on (R.ANO=A.ANO)  
Inner Join Cover C on (C.CNO=A.CNO)  
Left Join ISource I on (I.CNO=A.CNO)  
Left Join ISourceDet I2 on (I2.CNO=A.CNO and I2.Code=@P_Code)  
Inner Join Reinsurance R1 on (R1.RID=@P_RID)  
Inner join RPart R2 on (R2.RNO=R1.RNO and R2.ID=@P_ID and R2.DocNo=@P_DocNo)  
Inner Join ReClass R3 on (R3.RNO=R1.RNO and R3.TOC=A.TOC)  
Left Join ReClassDet R4 on (R4.RNO=R3.RNO AND R4.TOC=R3.TOC AND R4.CODE=@P_CODE)    
Where A.ANO=@P_ANO  
  
if @P_OnNetPremiumF=1  
 Select @Premium_Treaty_Discount=dbo.Premium_Treaty_Discount(@P_ANO, @P_Code,@P_Period)            
else  
 Select @Premium_Treaty_Discount=0  
  
if @P_COMMN<>0  
Begin  
 Select @Premium_Discount=dbo.premium_discount(@P_ANO, @P_Code, @P_Period)    
 Select @Premium_Fee=dbo.Premium_Fee(@P_ANO, @P_Period)    
End  
else  
Begin  
 Select @Premium_Discount=0  
 Select @Premium_Fee=0  
End  
  
if @P_COMMN<>0 or (@P_COMMPOLICYF=1 and @P_COMM=0 and @P_COMMN=0)  
 Select @Premium_Commission=dbo.Premium_Commission(@P_ANO, @P_Code, @P_Period,0)+dbo.Premium_MaxOutGo_Vat(@P_ANO, @P_Code, @P_Period,0)    
Else  
 Select @Premium_Commission=0  
  
Select @Premium_outGo=@Premium_Discount+@Premium_Commission+@Premium_Commission_Inward+@Premium_Fee-(Case When @P_OnNetPremiumF=1 Then @Premium_Treaty_Discount else 0 end)  
Select @P_COMM=CASE WHEN @P_COMMPOLICYF=1 and @P_COMM=0 and @P_COMMN=0 Then @Premium_Commission ELSE @P_COMM END    
  
SELECT @P_OPFEEPCT=Case When ROUND(COALESCE(SUM(Gross),0),4)<>0 Then COALESCE(SUM(FEE),0)/ROUND(COALESCE(SUM(Gross),0),4)*100 Else 0 End, @P_RITabarruF=coalesce(cast(Max(cast(RITabarruF as Int)) as Bit),0)  
FROM  
(  
	SELECT  
	A2.ANO,  
	Premium.Gross,
	Case   
	When coalesce(A1.Amount,0)<>0 Then  
		A1.Amount*Case When A1.RITabarruF=1 Then cast(100 as Float)/@P_Tabarru Else 1 end 
	When coalesce(A1.AmountPCT,0)<>0 then
		(Premium.Gross)*A1.AmountPCT/100*Case When A1.RITabarruF=1 Then cast(100 as Float)/@P_Tabarru Else 1 end 	
	Else
		0
	End as Fee,
	coalesce(A1.RITabarruF,cast(0 as Bit)) as RITabarruF
	from   
	Acceptance A2  
	INNER Join PCalc on (PCalc.ANO=A2.ANO and PCalc.Currency=@P_CCY)  
	Outer Apply (
		Select 
		sum(case When A1.PolicyYear<>0 then 
			A1.Amount*case When A1.ContributionF=1 Then 1 Else 100/coalesce(R.PCTSHARE-R.MSHARE,100) End
		else 
			A1.Amount*case When A1.ContributionF=1 Then 1 Else 100/coalesce(R.PCTSHARE-R.MSHARE,100) End*cast(dbo.fn_Premium_Calc_Prorata(@P_SDate, @P_EDate, 0,1,2) as Float)/cast(dbo.fn_Premium_Calc_Prorata(@P_ASDate, @P_AEDate,0,1,2) as Float)
		End) as Amount,
		sum(A1.AMOUNTPCT) as AMOUNTPCT, MAX(A1.AMOUNTPCTBASED) as AMOUNTPCTBASED, Cast(MAX(Cast(A1.RITabarruF as Int)) as Bit) as RITabarruF
		from AccFD A1
		Inner Join RARRHEADER R on (R.ANO=A2.ANO)
		Inner Join FDTAB on (FDTAB.FDID=A1.FDID and Left(FDTAB.FDType,1)='O')
		Where A1.ANO=A2.ANO and A1.Currency=PCalc.Currency and (A1.ContributionF=1 or A1.CessionF=1) and A1.AmountPCTBased in (0,3) And (A1.PolicyYear=0 or A1.PolicyYear=@P_Period)
	) A1
	Outer APPLY
	(
		Select coalesce(sum(Gross),0) as Gross
		from
		(
			Select   
			Case			
			When coalesce(A1.AMOUNTPCTBASED,0)<>3 then
				D1.Gross*D1.Prorata*P.Gross/P.OGross
			else
				D1.Gross*D1.Prorata*P.Gross/P.OGross*(100-D1.Discount-D1.Commission)/100
			End as Gross
			from Display_Calculation(A2.ANO) D1  
			Inner Join Acceptance A on (A.ANO=D1.ANO)  
			Inner Join PCalc P on (P.ANO=D1.ANO and P.Currency=D1.Currency)  
			Where D1.Currency=@P_CCY  
			and (@P_Period=0 or (D1.SDate>=dateadd(month,12*(@P_Period-1),A.SDate) and D1.SDate<dateadd(month,12*(@P_Period),A.SDate)))
		) Premium
	) Premium
   	Where @P_RType in ('Q','S1','S2','S3','A') and A2.OANO=@P_OANO and A2.ANO<=@P_ANO    
	and A2.ANO>(Select coalesce(Max(ANO),0) from Acceptance Where AType='C' and EMethod='A' and Acceptance.OANO=@P_OANO and Acceptance.ANO<=@P_ANO and AStatus not in ('W','T'))  


	Union All  
  
	--Op Fee from Master Policy  
	SELECT  
	A2.ANO,  
	0 as Gross,
	Case   
	When coalesce(A1.Amount,0)<>0 Then  
		--Not Yet for Master Policy  
		0  
	When coalesce(A1.AmountPCT,0)<>0 Then  
		(Premium.Gross)*A1.AmountPCT/100*Case When A1.RITabarruF=1 Then cast(100 as Float)/@P_Tabarru Else 1 end 	
	Else
		0
	End as Fee,
	coalesce(A1.RITabarruF,cast(0 as Bit)) as RITabarruF
	from   
	Acceptance A2  
	INNER Join PCalc on (PCalc.ANO=A2.ANO and PCalc.Currency=@P_CCY)  
	INNER JOIN Acceptance MA on (MA.PolicyNo<>'' and MA.RegNo=A2.RegNo and MA.ANO=MA.LANO)  
	INNER JOIN COVER C on (C.CNO=MA.CNO and C.OPENFLAG=0)  
	Outer Apply (
		Select 
		sum(case When A1.PolicyYear<>0 then 
			A1.Amount*case When A1.ContributionF=1 Then 1 Else 100/coalesce(R.PCTSHARE-R.MSHARE,100) End
		else 
			A1.Amount*case When A1.ContributionF=1 Then 1 Else 100/coalesce(R.PCTSHARE-R.MSHARE,100) End*cast(dbo.fn_Premium_Calc_Prorata(@P_SDate, @P_EDate, 0,1,2) as Float)/cast(dbo.fn_Premium_Calc_Prorata(@P_ASDate, @P_AEDate,0,1,2) as Float)
		End) as Amount,
		sum(A1.AMOUNTPCT) as AMOUNTPCT, MAX(A1.AMOUNTPCTBASED) as AMOUNTPCTBASED, Cast(MAX(Cast(A1.RITabarruF as Int)) as Bit) as RITabarruF
		from AccFD A1
		Inner Join RArrHeader R on (R.ANO=A2.ANO)
		Inner Join FDTAB on (FDTAB.FDID=A1.FDID and Left(FDTAB.FDType,1)='O')
		Where A1.ANO=MA.ANO and A1.Currency=PCalc.Currency and (A1.ContributionF=1 or A1.CessionF=1) and A1.AmountPCTBased in (0,3) And (A1.PolicyYear=0 or A1.PolicyYear=@P_Period)
	) A1
	Outer APPLY
	(
		Select coalesce(sum(Gross),0) as Gross
		from
		(
			Select   
			Case			
			When coalesce(A1.AMOUNTPCTBASED,0)<>3 then
				D1.Gross*D1.Prorata*P.Gross/P.OGross
			else
				D1.Gross*D1.Prorata*P.Gross/P.OGross*(100-D1.Discount-D1.Commission)/100
			End as Gross
			from Display_Calculation(A2.ANO) D1  
			Inner Join Acceptance A on (A.ANO=D1.ANO)  
			Inner Join PCalc P on (P.ANO=D1.ANO and P.Currency=D1.Currency)  
			Where D1.Currency=@P_CCY  
			and (@P_Period=0 or (D1.SDate>=dateadd(month,12*(@P_Period-1),A.SDate) and D1.SDate<dateadd(month,12*(@P_Period),A.SDate)))
		) Premium
	) Premium
	Where @P_LANO<>-1 and @P_RType in ('Q','S1','S2','S3','A') and A2.OANO=@P_OANO and A2.ANO<=@P_ANO    
	and A2.ANO>(Select coalesce(Max(ANO),0) from Acceptance Where AType='C' and EMethod='A' and Acceptance.OANO=@P_OANO and Acceptance.ANO<=@P_ANO and AStatus not in ('W','T'))  
) A  
Where @P_OPFEEF=1  
  
Select                
sum(Case When OnMinPremiumF=0 Then (case When Gross_1>Gross_2 then Gross_1 else Gross_2 end) else (case When Gross_1<Gross_2 and Gross_1<>0 then Gross_1 else Gross_2 end) end) as Premium,             
sum(Case When OnMinPremiumF=0 Then (case When Gross_1>Gross_2 then Comm_1 else Comm_2 end) else (case When Gross_1<Gross_2 and Gross_1<>0 then Comm_1 else Comm_2 end) end) as Commission,           
sum(Case When OnMinPremiumF=0 Then (case When Gross_1>Gross_2 then Disc_1 else Disc_2 end) else (case When Gross_1<Gross_2 and Gross_1<>0 then Disc_1 else Disc_2 end) end) as Discount,    
sum(Case When OnMinPremiumF=0 Then (case When Gross_1>Gross_2 then Fee_1 else Fee_2 end) else (case When Gross_1<Gross_2 and Gross_1<>0 then Fee_1 else Fee_2 end) end) as Fee                
From            
(
select                
Cast(@P_OnMinPremiumF as integer) as OnMinPremiumF,                
coalesce(SUM((CASE WHEN @P_PPCT<>0 THEN @P_PPCT/100 ELSE (Case When @P_RateConF=1 and (RRateCon.Rate is not null or RateCon.Rate is not null) then 0 else 1 end) END * ICALC.GROSS*(PCALC.PGROSS*@P_PFactor)/PCALC.POGROSS*(100-@Premium_Treaty_Discount)/100-(ICALC.GROSS*PCALC.PGROSS/PCALC.POGROSS*@P_OPFEEPCT/100))*(Case When @P_COMMN=0 Then @P_COMM/100 else (Case When RCover.NetRateF=1 or @P_ONGROSSNET=2 OR (@P_ONGROSSNET=0 AND (100-@Premium_OutGo)/100*(100-@P_COMMN)/100<(100-@P_COMM)/100) Then (100-@Premium_OutGo)/100*(@P_COMMN)/100 else @P_COMM/100 end) end)),0) AS COMM_1,                
coalesce(SUM((Case When @P_RateConF=1 Then (Case When RRateCon.Rate is null then RateCon.Rate*(Case When RateCon.Loading<>0 then RateCon.Loading/100 else RCover.Loading end) else RRateCon.Rate/PCalc.RiskNum*(Case When RRateCon.Loading<>0 then RRateCon.Loading/100 else RCover.Loading end) end) Else coalesce(@P_NETRATEDet,@P_NETRATE/PCalc.RiskNum) end/100*(100-RCover.Discount)/100*ICALC.GROSS/PCALC.GROSS*ICALC.PRORATA *ICALC.TSI*(CASE WHEN RCOVER.PCALC='S' OR RCOVER.PCTLOSS=0 THEN 100 ELSE RCOVER.PCTLOSS END)/(CASE WHEN RCOVER.PCTLOSS=0 THEN 100 ELSE RCOVER.PCTLOSS END+RCOVER.PAddition)*ICALC.PCTADJ/100-(ICALC.GROSS*PCALC.PGROSS/PCALC.POGROSS*@P_OPFEEPCT/100))*(Case When @P_COMMN=0 Then @P_COMM/100 else (Case When RCover.NetRateF=1 or @P_ONGROSSNET=2 OR (@P_ONGROSSNET=0 AND (100-@Premium_OutGo)/100*(100-@P_COMMN)/100<(100-@P_COMM)/100) Then (100-@Premium_OutGo)/100*(@P_COMMN)/100 else @P_COMM/100 end) end)),0) AS COMM_2,                
  
coalesce(SUM((CASE WHEN @P_PPCT<>0 THEN @P_PPCT/100 ELSE (Case When @P_RateConF=1 and (RRateCon.Rate is not null or RateCon.Rate is not null) then 0 else 1 end) END * ICALC.GROSS*(PCALC.PGROSS*@P_PFactor)/PCALC.POGROSS*(100-@Premium_Treaty_Discount)/100)*(Case When @P_COMMN=0 Then 1 else (Case When RCover.NetRateF=1 or @P_ONGROSSNET=2 OR (@P_ONGROSSNET=0 AND (100-@Premium_OutGo)/100*(100-@P_COMMN)/100<(100-@P_COMM)/100) Then 1 else 1 end) end)-(Case When @P_RITabarruF=1 Then 1 Else 0 end)*(ICALC.GROSS*PCALC.PGROSS/PCALC.POGROSS*@P_OPFEEPCT/100)),0) AS GROSS_1,              
coalesce(SUM((Case When @P_RateConF=1 Then (Case When RRateCon.Rate is null then RateCon.Rate*(Case When RateCon.Loading<>0 then RateCon.Loading/100 else RCover.Loading end) else RRateCon.Rate/PCalc.RiskNum*(Case When RRateCon.Loading<>0 then RRateCon.Loading/100 else RCover.Loading end) end) Else coalesce(@P_NETRATEDet,@P_NETRATE/PCalc.RiskNum) end/100*(100-RCover.Discount)/100*ICALC.GROSS/PCALC.GROSS*ICALC.PRORATA *ICALC.TSI*(CASE WHEN RCOVER.PCALC='S' OR RCOVER.PCTLOSS=0 THEN 100 ELSE RCOVER.PCTLOSS END)/(CASE WHEN RCOVER.PCTLOSS=0 THEN 100 ELSE RCOVER.PCTLOSS END+RCOVER.PAddition)*ICALC.PCTADJ/100)*(Case When @P_COMMN=0 Then 1 else (Case When RCover.NetRateF=1 or @P_ONGROSSNET=2 OR (@P_ONGROSSNET=0 AND (100-@Premium_OutGo)/100*(100-@P_COMMN)/100<(100-@P_COMM)/100) Then 1 else 1 end) end)-(Case When @P_RITabarruF=1 Then 1 Else 0 end)*(ICALC.GROSS*PCALC.PGROSS/PCALC.POGROSS*@P_OPFEEPCT/100)),0) AS GROSS_2,                
               
coalesce(SUM((CASE WHEN @P_PPCT<>0 THEN @P_PPCT/100 ELSE (Case When @P_RateConF=1 and (RRateCon.Rate is not null or RateCon.Rate is not null) then 0 else 1 end) END * ICALC.GROSS*(PCALC.PGROSS*@P_PFactor)/PCALC.POGROSS*(100-@Premium_Treaty_Discount)/100-(ICALC.GROSS*PCALC.PGROSS/PCALC.POGROSS*@P_OPFEEPCT/100))*(Case When @P_COMMN=0 Then 0 else (Case When RCover.NetRateF=1 or @P_ONGROSSNET=2 OR (@P_ONGROSSNET=0 AND (100-@Premium_OutGo)/100*(100-@P_COMMN)/100<(100-@P_COMM)/100) Then (@Premium_OutGo)/100 else 0 end) end)),0) AS DISC_1,         
coalesce(SUM((Case When @P_RateConF=1 Then (Case When RRateCon.Rate is null then RateCon.Rate*(Case When RateCon.Loading<>0 then RateCon.Loading/100 else RCover.Loading end) else RRateCon.Rate/PCalc.RiskNum*(Case When RRateCon.Loading<>0 then RRateCon.Loading/100 else RCover.Loading end) end) Else coalesce(@P_NETRATEDet,@P_NETRATE/PCalc.RiskNum) end/100*(100-RCover.Discount)/100*ICALC.GROSS/PCALC.GROSS*ICALC.PRORATA *ICALC.TSI*(CASE WHEN RCOVER.PCALC='S' OR RCOVER.PCTLOSS=0 THEN 100 ELSE RCOVER.PCTLOSS END)/(CASE WHEN RCOVER.PCTLOSS=0 THEN 100 ELSE RCOVER.PCTLOSS END+RCOVER.PAddition)*ICALC.PCTADJ/100-(ICALC.GROSS*PCALC.PGROSS/PCALC.POGROSS*@P_OPFEEPCT/100))*(Case When @P_COMMN=0 Then 0 else (Case When RCover.NetRateF=1 or @P_ONGROSSNET=2 OR (@P_ONGROSSNET=0 AND (100-@Premium_OutGo)/100*(100-@P_COMMN)/100<(100-@P_COMM)/100) Then (@Premium_OutGo)/100 else 0 end) end)),0) AS DISC_2,    
  
coalesce(SUM((CASE WHEN @P_PPCT<>0 THEN @P_PPCT/100 ELSE (Case When @P_RateConF=1 and (RRateCon.Rate is not null or RateCon.Rate is not null) then 0 else 1 end) END * ICALC.GROSS*(PCALC.PGROSS*@P_PFactor)/PCALC.POGROSS*(100-@Premium_Treaty_Discount)/100)*(Case When @P_COMMN=0 Then 1 else (Case When RCover.NetRateF=1 or @P_ONGROSSNET=2 OR (@P_ONGROSSNET=0 AND (100-@Premium_OutGo)/100*(100-@P_COMMN)/100<(100-@P_COMM)/100) Then 1 else 1 end) end)*@P_FEE/100-(Case When @P_RITabarruF=0 Then 1 Else 0 end)*(ICALC.GROSS*PCALC.PGROSS/PCALC.POGROSS*@P_OPFEEPCT/100)),0) AS FEE_1,                
coalesce(SUM((Case When @P_RateConF=1 Then (Case When RRateCon.Rate is null then RateCon.Rate*(Case When RateCon.Loading<>0 then RateCon.Loading/100 else RCover.Loading end) else RRateCon.Rate/PCalc.RiskNum*(Case When RRateCon.Loading<>0 then RRateCon.Loading/100 else RCover.Loading end) end) Else coalesce(@P_NETRATEDet,@P_NETRATE/PCalc.RiskNum) end/100*(100-RCover.Discount)/100*ICALC.GROSS/PCALC.GROSS*ICALC.PRORATA *ICALC.TSI*(CASE WHEN RCOVER.PCALC='S' OR RCOVER.PCTLOSS=0 THEN 100 ELSE RCOVER.PCTLOSS END)/(CASE WHEN RCOVER.PCTLOSS=0 THEN 100 ELSE RCOVER.PCTLOSS END+RCOVER.PAddition)*ICALC.PCTADJ/100)*(Case When @P_COMMN=0 Then 1 else (Case When RCover.NetRateF=1 or @P_ONGROSSNET=2 OR (@P_ONGROSSNET=0 AND (100-@Premium_OutGo)/100*(100-@P_COMMN)/100<(100-@P_COMM)/100) Then 1 else 1 end) end)*@P_FEE/100-(Case When @P_RITabarruF=0 Then 1 Else 0 end)*(ICALC.GROSS*PCALC.PGROSS/PCALC.POGROSS*@P_OPFEEPCT/100)),0) AS FEE_2    
                
FROM ICALC     
INNER JOIN ACCEPTANCE SACCEPTANCE ON (SACCEPTANCE.ANO=ICALC.SANO)    
INNER JOIN RCOVER ON (RCOVER.ANO=ICALC.SANO AND RCOVER.CODE=ICALC.CODE AND (RCOVER.SDATE=ICALC.SDATE OR (@P_AType='A' AND (CASE WHEN RCOVER.SDATE<SACCEPTANCE.PDATE THEN SACCEPTANCE.PDATE ELSE RCOVER.SDATE END)=ICALC.SDATE)))    
LEFT JOIN RPARTDET ON (RPARTDET.RNO=@P_RNO AND RPARTDET.ID=@P_ID AND RPartDet.DocNo=@P_DocNo AND RPARTDET.TOR=ICALC.TOR)    
LEFT Join FN_RateCon(@P_ANO, @P_CODE,@P_TSI,@P_ASDate) RateCon On (@P_RateConF=1 and RateCon.Code=ICalc.Code)    
LEFT Join FN_RRateCon(@P_ANO, @P_RID, @P_TSI) RRateCon On (@P_RateConF=1)                
INNER JOIN ICOVER ON (ICOVER.INO=ICALC.INO AND (ICOVER.ADJUSTABLE=@P_ADJUSTABLEF OR @P_AType='A'))    
INNER JOIN RCALC ON (RCALC.ANO=ICALC.ANO AND RCALC.CURRENCY=ICALC.CURRENCY AND RCALC.CODE=ICALC.CODE AND RCALC.TOR=ICALC.TOR AND RCALC.SDATE=ICALC.SDATE AND RCALC.EDATE=ICALC.EDATE AND RCALC.SANO=ICALC.SANO AND RCALC.EXTREATYF=0)    
INNER JOIN PCALC_ANNUM(@P_ANO) PCALC ON (PCALC.ANO=ICALC.ANO AND PCALC.CODE=ICALC.CODE AND PCALC.SDATE=ICALC.SDATE AND PCALC.EDATE=ICALC.EDATE AND PCALC.INO=ICALC.INO AND PCALC.CURRENCY=ICALC.CURRENCY)    
WHERE ICALC.ANO=@P_ANO AND ICALC.CURRENCY=@P_CCY AND ICALC.SDATE=@P_SDATE AND ICALC.EDATE=@P_EDATE AND ICALC.CODE=@P_CODE                
AND RPARTDET.TOR IS NULL AND PCALC.GROSS<>0    
  
Union All                
  
select                
  
Cast(@P_OnMinPremiumF as integer) as OnMinPremiumF,           
  
coalesce(SUM((CASE WHEN RPARTDET.PPCT<>0 THEN RPARTDET.PPCT/100 ELSE (Case When @P_RateConF=1 and (RRateCon.Rate is not null or RateCon.Rate is not null) then 0 else 1 end) END * ICALC.GROSS*(PCALC.PGROSS*@P_PFactor)/PCALC.POGROSS-(ICALC.GROSS*PCALC.PGROSS/PCALC.POGROSS*@P_OPFEEPCT/100))*(100-@Premium_Treaty_Discount)/100*(Case When RPARTDET.COMMN=0 Then RPARTDET.COMM/100 else (Case When RCover.NetRateF=1 or @P_ONGROSSNET=2 OR (@P_ONGROSSNET=0 AND (100-@Premium_OutGo)/100*(100-RPARTDET.CommN)/100<(100-RPARTDET.COMM)/100) Then (100-@Premium_OutGo)/100*(RPARTDET.CommN)/100 else RPARTDET.COMM/100 end) end)),0) AS COMM_1,                
coalesce(SUM((Case When @P_RateConF=1 Then (Case When RRateCon.Rate is null then RateCon.Rate*(Case When RateCon.Loading<>0 then RateCon.Loading/100 else RCover.Loading end) else RRateCon.Rate/PCalc.RiskNum*(Case When RRateCon.Loading<>0 then RRateCon.Loading/100 else RCover.Loading end) end) Else coalesce(@P_NETRATEDet,RPartDet.NetRate*datediff(day,@P_Sdate, @P_EDate)/datediff(day,@P_ASdate, @P_AEDate)) end/100*(100-RCover.Discount)/100*ICALC.GROSS/PCALC.GROSS*ICALC.PRORATA *ICALC.TSI*(CASE WHEN RCOVER.PCALC='S' OR RCOVER.PCTLOSS=0 THEN 100 ELSE RCOVER.PCTLOSS END)/(CASE WHEN RCOVER.PCTLOSS=0 THEN 100 ELSE RCOVER.PCTLOSS END+RCOVER.PAddition)*ICALC.PCTADJ/100-(ICALC.GROSS*PCALC.PGROSS/PCALC.POGROSS*@P_OPFEEPCT/100))*(Case When RPARTDET.COMMN=0 Then RPARTDET.COMM/100 else (Case When RCover.NetRateF=1 or @P_ONGROSSNET=2 OR (@P_ONGROSSNET=0 AND (100-@Premium_OutGo)/100*(100-RPARTDET.CommN)/100<(100-RPARTDET.COMM)/100) Then (100-@Premium_OutGo)/100*(RPARTDET.CommN)/100 else RPARTDET.COMM/100 end) end)),0) AS COMM_2,                    
                
coalesce(SUM((CASE WHEN RPARTDET.PPCT<>0 THEN RPARTDET.PPCT/100 ELSE (Case When @P_RateConF=1 and (RRateCon.Rate is not null or RateCon.Rate is not null) then 0 else 1 end) END * ICALC.GROSS*(PCALC.PGROSS*@P_PFactor)/PCALC.POGROSS)*(100-@Premium_Treaty_Discount)/100*(Case When RPARTDET.COMMN=0 Then 1 else (Case When RCover.NetRateF=1 or @P_ONGROSSNET=2 OR (@P_ONGROSSNET=0 AND (100-@Premium_OutGo)/100*(100-RPARTDET.CommN)/100<(100-RPARTDET.COMM)/100) Then 1 else 1 end) end)-(Case When @P_RITabarruF=1 Then 1 Else 0 end)*(ICALC.GROSS*PCALC.PGROSS/PCALC.POGROSS*@P_OPFEEPCT/100)),0) AS GROSS_1,                
coalesce(SUM((Case When @P_RateConF=1 Then (Case When RRateCon.Rate is null then RateCon.Rate*(Case When RateCon.Loading<>0 then RateCon.Loading/100 else RCover.Loading end) else RRateCon.Rate/PCalc.RiskNum*(Case When RRateCon.Loading<>0 then RRateCon.Loading/100 else RCover.Loading end) end) Else coalesce(@P_NETRATEDet,RPartDet.NetRate*datediff(day,@P_Sdate, @P_EDate)/datediff(day,@P_ASdate, @P_AEDate)) end/100*(100-RCover.Discount)/100*ICALC.GROSS/PCALC.GROSS*ICALC.PRORATA *ICALC.TSI*(CASE WHEN RCOVER.PCALC='S' OR RCOVER.PCTLOSS=0 THEN 100 ELSE RCOVER.PCTLOSS END)/(CASE WHEN RCOVER.PCTLOSS=0 THEN 100 ELSE RCOVER.PCTLOSS END+RCOVER.PAddition)*ICALC.PCTADJ/100)*(Case When RPARTDET.COMMN=0 Then 1 else (Case When RCover.NetRateF=1 or @P_ONGROSSNET=2 OR (@P_ONGROSSNET=0 AND (100-@Premium_OutGo)/100*(100-RPARTDET.CommN)/100<(100-RPARTDET.COMM)/100) Then 1 else 1 end) end)-(Case When @P_RITabarruF=1 Then 1 Else 0 end)*(ICALC.GROSS*PCALC.PGROSS/PCALC.POGROSS*@P_OPFEEPCT/100)),0) AS GROSS_2,                
  
coalesce(SUM((CASE WHEN RPARTDET.PPCT<>0 THEN RPARTDET.PPCT/100 ELSE (Case When @P_RateConF=1 and (RRateCon.Rate is not null or RateCon.Rate is not null) then 0 else 1 end) END * ICALC.GROSS*(PCALC.PGROSS*@P_PFactor)/PCALC.POGROSS-(ICALC.GROSS*PCALC.PGROSS/PCALC.POGROSS*@P_OPFEEPCT/100))*(100-@Premium_Treaty_Discount)/100*(Case When RPARTDET.COMMN=0 Then 0 else (Case When RCover.NetRateF=1 or @P_ONGROSSNET=2 OR (@P_ONGROSSNET=0 AND (100-@Premium_OutGo)/100*(100-RPARTDET.CommN)/100<(100-RPARTDET.COMM)/100) Then (@Premium_OutGo)/100 else 0 end) end)),0) AS DISC_1,                
coalesce(SUM((Case When @P_RateConF=1 Then (Case When RRateCon.Rate is null then RateCon.Rate*(Case When RateCon.Loading<>0 then RateCon.Loading/100 else RCover.Loading end) else RRateCon.Rate/PCalc.RiskNum*(Case When RRateCon.Loading<>0 then RRateCon.Loading/100 else RCover.Loading end) end) Else coalesce(@P_NETRATEDet,RPartDet.NetRate*datediff(day,@P_Sdate, @P_EDate)/datediff(day,@P_ASdate, @P_AEDate)) end/100*(100-RCover.Discount)/100*ICALC.GROSS/PCALC.GROSS*ICALC.PRORATA *ICALC.TSI*(CASE WHEN RCOVER.PCALC='S' OR RCOVER.PCTLOSS=0 THEN 100 ELSE RCOVER.PCTLOSS END)/(CASE WHEN RCOVER.PCTLOSS=0 THEN 100 ELSE RCOVER.PCTLOSS END+RCOVER.PAddition)*ICALC.PCTADJ/100-(ICALC.GROSS*PCALC.PGROSS/PCALC.POGROSS*@P_OPFEEPCT/100))*(Case When RPARTDET.COMMN=0 Then 0 else (Case When RCover.NetRateF=1 or @P_ONGROSSNET=2 OR (@P_ONGROSSNET=0 AND (100-@Premium_OutGo)/100*(100-RPARTDET.CommN)/100<(100-RPARTDET.COMM)/100) Then (@Premium_OutGo)/100 else 0 end) end)),0) AS DISC_2,                    
  
coalesce(SUM((CASE WHEN RPARTDET.PPCT<>0 THEN RPARTDET.PPCT/100 ELSE (Case When @P_RateConF=1 and (RRateCon.Rate is not null or RateCon.Rate is not null) then 0 else 1 end) END * ICALC.GROSS*(PCALC.PGROSS*@P_PFactor)/PCALC.POGROSS)*(100-@Premium_Treaty_Discount)/100*(Case When RPARTDET.COMMN=0 Then 1 else (Case When RCover.NetRateF=1 or @P_ONGROSSNET=2 OR (@P_ONGROSSNET=0 AND (100-@Premium_OutGo)/100*(100-RPARTDET.CommN)/100<(100-RPARTDET.COMM)/100) Then 1 else 1 end) end)*@P_FEE/100-(Case When @P_RITabarruF=0 Then 1 Else 0 end)*(ICALC.GROSS*PCALC.PGROSS/PCALC.POGROSS*@P_OPFEEPCT/100)),0) AS FEE_1,                
coalesce(SUM((Case When @P_RateConF=1 Then (Case When RRateCon.Rate is null then RateCon.Rate*(Case When RateCon.Loading<>0 then RateCon.Loading/100 else RCover.Loading end) else RRateCon.Rate/PCalc.RiskNum*(Case When RRateCon.Loading<>0 then RRateCon.Loading/100 else RCover.Loading end) end) Else coalesce(@P_NETRATEDet,RPartDet.NetRate*datediff(day,@P_Sdate, @P_EDate)/datediff(day,@P_ASdate, @P_AEDate)) end/100*(100-RCover.Discount)/100*ICALC.GROSS/PCALC.GROSS*ICALC.PRORATA *ICALC.TSI*(CASE WHEN RCOVER.PCALC='S' OR RCOVER.PCTLOSS=0 THEN 100 ELSE RCOVER.PCTLOSS END)/(CASE WHEN RCOVER.PCTLOSS=0 THEN 100 ELSE RCOVER.PCTLOSS END+RCOVER.PAddition)*ICALC.PCTADJ/100)*(Case When RPARTDET.COMMN=0 Then 1 else (Case When RCover.NetRateF=1 or @P_ONGROSSNET=2 OR (@P_ONGROSSNET=0 AND (100-@Premium_OutGo)/100*(100-RPARTDET.CommN)/100<(100-RPARTDET.COMM)/100) Then 1 else 1 end) end)*@P_FEE/100-(Case When @P_RITabarruF=0 Then 1 Else 0 end)*(ICALC.GROSS*PCALC.PGROSS/PCALC.POGROSS*@P_OPFEEPCT/100)),0) AS FEE_2    
  
FROM ICALC     
INNER JOIN ACCEPTANCE SACCEPTANCE ON (SACCEPTANCE.ANO=ICALC.SANO)    
INNER JOIN RCOVER ON (RCOVER.ANO=ICALC.SANO AND RCOVER.CODE=ICALC.CODE AND (RCOVER.SDATE=ICALC.SDATE OR (@P_AType='A' AND (CASE WHEN RCOVER.SDATE<SACCEPTANCE.PDATE THEN SACCEPTANCE.PDATE ELSE RCOVER.SDATE END)=ICALC.SDATE)))    
INNER JOIN RPARTDET ON (RPARTDET.RNO=@P_RNO AND RPARTDET.ID=@P_ID AND RPARTDET.DocNo=@P_DocNo AND RPARTDET.TOR=ICALC.TOR AND (RPARTDET.NOFYEARS=0 OR RPARTDET.NOFYEARS=@P_NOFYEARS) and RPARTDET.EXCLUDEF=0)    
LEFT Join FN_RateCon(@P_ANO, @P_CODE,@P_TSI,@P_ASDate) RateCon On (@P_RateConF=1 and RateCon.Code=ICalc.Code)    
LEFT Join FN_RRateCon(@P_ANO, @P_RID, @P_TSI) RRateCon On (@P_RateConF=1)                
INNER JOIN ICOVER ON (ICOVER.INO=ICALC.INO AND (ICOVER.ADJUSTABLE=@P_ADJUSTABLEF OR @P_AType='A'))    
INNER JOIN RCALC ON (RCALC.ANO=ICALC.ANO AND RCALC.CURRENCY=ICALC.CURRENCY AND RCALC.CODE=ICALC.CODE AND RCALC.TOR=ICALC.TOR AND RCALC.SDATE=ICALC.SDATE AND RCALC.EDATE=ICALC.EDATE AND RCALC.SANO=ICALC.SANO AND RCALC.EXTREATYF=0)    
INNER JOIN PCALC_ANNUM(@P_ANO) PCALC ON (PCALC.ANO=ICALC.ANO AND PCALC.CODE=ICALC.CODE AND PCALC.SDATE=ICALC.SDATE AND PCALC.EDATE=ICALC.EDATE AND PCALC.INO=ICALC.INO AND PCALC.CURRENCY=ICALC.CURRENCY)    
WHERE ICALC.ANO=@P_ANO AND ICALC.CURRENCY=@P_CCY AND ICALC.SDATE=@P_SDATE AND ICALC.EDATE=@P_EDATE AND ICALC.CODE=@P_CODE                
AND PCALC.GROSS<>0    
  
) R          

GO
DROP Procedure QREINSURANCE_CESSION
GO
CREATE Procedure QREINSURANCE_CESSION (@P_ANO integer, @P_ADate smalldatetime, @P_RType varchar(255), @P_TSI Float=0, @P_RID varchar(20)='', @P_ManualF Bit=0, @P_GROSS Float=0)                                
as                                                          

Declare @Amount as float
Declare @SDate as smalldatetime
Declare @EDate as smalldatetime
Declare @RegID as varchar(10)
Declare @FLDID as varchar(255)
Declare @VALUEID as varchar(255)
Declare @EMethod as varchar(1)
Declare @ISType as varchar(1)
Declare @PHolder as varchar(10)
Declare @CGroup as varchar(10)
Declare @Segment as varchar(10)
Declare @TOC as varchar(10)
Declare @BrCurrency as varchar(10)
Declare @RYear as integer
Declare @ManualF as bit
Declare @ORBusinessF as Bit
Declare @RDate as smalldatetime
Declare @NRDate as smalldatetime

Declare @Reinsurance as table(RNO int, TOC varchar(10), ExcRate Float)

Select 
@SDate=Acceptance.SDate, 
@EDate=Acceptance.EDate,
@RegID=Acceptance.RegID, 
@FLDID=Acceptance.FLDID, 
@VALUEID=Acceptance.VALUEID, 
@EMethod=Acceptance.EMethod, 
@ISType=Acceptance.ISType,
@PHolder=Cover.PHOLDER,
@Segment=Cover.Segment,
@CGroup=PHolder.CGroup,
@TOC=Acceptance.TOC,
@BrCurrency=SysTab.Currency,
@RYear=Case When SysTab.RiskAccumulationByTreatyYearF=0 Then 0 else Reinsurance.RYear end,
@ManualF=coalesce(RArrHeader.ManualF,0),
@ORBusinessF=coalesce(RArrHeader.ORBusinessF,0),
@RDate=RArrHeader.RDate,
@NRDate=RArrHeader.NRDate
from Acceptance
Inner Join Cover on (Cover.CNO=Acceptance.CNO)      
Inner Join Profile PHolder on (PHolder.ID=Cover.PHolder)
Inner Join SysTab on (1=1)
Left Join RArrHeader on (RArrHeader.ANO=Acceptance.ANO)
LEFT JOIN Reinsurance on (Reinsurance.RID=RArrHeader.QID)
Where Acceptance.ANO=@P_ANO

if @P_RID=''
	-- from QAccumulation
	Select @Amount=coalesce(sum(AccRegDet.Amount),0)
	from AccRegDet 
	Where (AccRegDet.RegID=@RegID and AccRegDet.FLDID=@FLDID and AccRegDet.ValueID=@ValueID and AccRegDet.RType=@P_RType AND ACCREGDET.TSI<>0 AND (ACCREGDET.RYEAR=@RYear OR @RYear=0))
else
	Select @Amount=0

Insert into @Reinsurance
Select Reinsurance.RNO, ReClass.TOC, Case When coalesce(R1.Rate,0)=0 Then (Case When Reinsurance.Currency='' or Reinsurance.Currency=@BrCurrency Then 1 Else dbo.get_Exchange(@SDate, Reinsurance.Currency) End) else coalesce(R1.Rate,1)*coalesce(R2.Rate,1) end as ExcRate
From Reinsurance 
Inner Join ReClass on (ReClass.RNO=Reinsurance.RNO and ReClass.TOC=@TOC and (ReClass.DirectF=0 or @ISType in ('I','L','C')))      
Left Join ReRate R1 on (R1.TOC=@TOC and R1.RYear=Reinsurance.RYEAR and R1.Currency=Reinsurance.Currency)
left Join ReRate R2 on (R2.TOC=R1.TOC and R2.RYear=R1.RYear and R2.Currency=R1.CCYTo and R1.Currency<>R1.CCYTO)
WHERE Reinsurance.RType=@P_RType And @P_ADATE Between Reinsurance.PDate And Reinsurance.EDate    
and Reinsurance.Status='A'

SELECT (Case When ReClass.PriorityF=1 Then ReClass.PriorityF else Reinsurance.PriorityF end) as PriorityF, Reinsurance.RID, Reinsurance.RType,                                
ReClass.PLimit*R.ExcRate as PLimit, 
Case RECLASS.Limit WHEN 0 then Reinsurance.Limit Else RECLASS.Limit end*R.ExcRate as limit, 
ReClass.ShortFallLimit*R.ExcRate  as ShortFallLimit,              
ReClass.MinTSI*R.ExcRate  as MinTSI, 
ReClass.AssessmentExInwardF,
Reinsurance.UjrohReins, Reinsurance.UjrohCedant, Reinsurance.Share, Reinsurance.PShare, @FLDID as FLDID, @VALUEID as VALUEID, ReClass.CessionF, ReClass.AssessmentF, ReClass.DirectF,
Reinsurance.SDate, Reinsurance.EDate, Reinsurance.CleanCutF, Reinsurance.RShare                               
From @Reinsurance R
Inner Join Reinsurance on (Reinsurance.RNO=R.RNO)
Inner Join ReClass on (ReClass.RNO=R.RNO and ReClass.TOC=R.TOC)
Left Join RePolicy on (RePolicy.RNO=Reinsurance.RNO)      
WHERE Reinsurance.RType=@P_RType
And (@P_RID='' or Reinsurance.RID=@P_RID or @ManualF=0 or @EMethod='T')                            
And (coalesce(RePolicy.ID,'')='' or  coalesce(RePolicy.ID,'')=@PHolder)    
And (@P_ManualF=1 or @ManualF=1 or  
(
	(      
	 (Reinsurance.ORBusinessF=@ORBusinessF)      
	 And (@P_TSI>=ReClass.MinTSI*R.ExcRate  or ReClass.MinTSI*R.ExcRate =0) 
	 and (@P_TSI<=ReClass.MaxTSI*R.ExcRate  or ReClass.MaxTSI*R.ExcRate =0) 
	 and (@P_GROSS>=ReClass.MinGross*R.ExcRate  or ReClass.MinGross*R.ExcRate =0) 
	 and (@P_GROSS<=ReClass.MaxGross*R.ExcRate  or ReClass.MaxGross*R.ExcRate =0)                 
	 And (    
	 (datediff(month, coalesce(@RDate,@SDate), coalesce(@NRDate,@EDate))>=ReClass.MinPeriod)     
	 or (datediff(month, coalesce(@RDate,@SDate), coalesce(@NRDate,@EDate))=ReClass.MinPeriod-1 and day(coalesce(@RDate,@SDate))<day(coalesce(@NRDate,@EDate)))     
	 or ReClass.MinPeriod=0)                               
	 And (    
	 (datediff(month, coalesce(@RDate,@SDate), coalesce(@NRDate,@EDate))<ReClass.MaxPeriod)     
	 or (datediff(month, coalesce(@RDate,@SDate), coalesce(@NRDate,@EDate))=ReClass.MaxPeriod and day(coalesce(@RDate,@SDate))>=day(coalesce(@NRDate,@EDate)))
	 or ReClass.MaxPeriod=0)
	)      
	And 
	(
	 Reinsurance.ApplySegmentF=0 or (exists (Select Segment from ReSegment Where ReSegment.RNO=Reinsurance.RNO and ReSegment.Segment=@Segment))
	)
	And 
	(
	 Reinsurance.ApplyCGroupF=0 or (exists (Select CGroup from ReCGroup Where ReCGroup.RNO=Reinsurance.RNO and ReCGroup.CGroup=@CGroup))
	 )))                    
And Exists (Select Top 1 RCalc.ANO from RCalc Left Join RPartDet on (RPartDet.RNO=Reinsurance.RNO and RPartDet.TOR=RCalc.TOR) Where RCalc.ANO=@P_ANO and coalesce(RPartDet.ExcludeF,0)=0)  
Order By 
Case When Case RECLASS.Limit WHEN 0 then Reinsurance.Limit Else RECLASS.Limit end*R.ExcRate>@Amount then 0 else 1 End,
Case When (@P_ManualF=1 or @ManualF=1) and (Reinsurance.RID=@P_RID or Reinsurance.PRID=@P_RID) Then 0 Else 1 end, 
coalesce(RePolicy.ID,'') Desc, 
(Case When ReClass.PriorityF=1 Then ReClass.PriorityF else Reinsurance.PriorityF end) Desc,
Case RECLASS.Limit WHEN 0 then Reinsurance.Limit Else RECLASS.Limit end*R.ExcRate-@Amount,
Reinsurance.PDate Desc

GO
DROP PROCEDURE QRiskAssLimit 
GO
CREATE PROCEDURE QRiskAssLimit (@PANO as integer, @RType as varchar(10)='')                    
AS                    
SELECT top 1 RiskAss.RiskAss, Case When ReClass.AssessmentExInwardF=1 and Acceptance.ISType in ('R','N','T','Q','S','A','X','P') Then 100 else RiskAss.PLimit end PLimit, Case When ReClass.AssessmentExInwardF=1 and Acceptance.ISType in ('R','N','T','Q','S','A','X','P') Then 100 else RiskAss.Limit end Limit,Acceptance.ISType, RiskAss.Code, RiskAss.HoldF, RiskAss.HoldMessage, RiskAss.Share, RiskAss.Rate, RiskAss.Loading, RiskAss.RType, RiskAss.PShare
From Acceptance
Inner Join Cover on (Cover.CNO=Acceptance.CNO)
Inner Join AInfo on (AInfo.ANO=Acceptance.ANO)
Inner Join RArrHeader on (RArrHeader.ANO=Acceptance.ANO)
Inner Join Reinsurance on (((@RType='' and Reinsurance.RType In ('Q')) or Reinsurance.RType=@RType) and RArrHeader.RDate Between Reinsurance.SDate and Reinsurance.EDate)
Inner Join ReClass on (ReClass.RNO=Reinsurance.RNO and ReClass.TOC=Acceptance.TOC and ReClass.AssessmentF=1)
Left Join RiskAss on (
	(RiskAss.RType='' or RiskAss.RType=@RType or @RType='')
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
Case When RiskAss.RType=@RType Then 1 Else 0 end Desc,
RiskAss.PriorityF Desc,                  
len(coalesce(RiskAss.ValueID1,'')) Desc, len(coalesce(RiskAss.ValueID2,'')) Desc, len(coalesce(RiskAss.ValueID3,'')) Desc, len(coalesce(RiskAss.ValueID4,'')) Desc, len(coalesce(RiskAss.ValueID5,'')) Desc,                   
len(coalesce(RiskAss.ValueID6,'')) Desc, len(coalesce(RiskAss.ValueID7,'')) Desc, len(coalesce(RiskAss.ValueID8,'')) Desc, len(coalesce(RiskAss.ValueID9,'')) Desc, len(coalesce(RiskAss.ValueID10,'')) Desc,                   
len(coalesce(RiskAss.ValueID11,'')) Desc, len(coalesce(RiskAss.ValueID12,'')) Desc, len(coalesce(RiskAss.ValueID13,'')) Desc, len(coalesce(RiskAss.ValueID14,'')) Desc, len(coalesce(RiskAss.ValueID15,'')) Desc,                   
RiskAss.Limit Desc, RiskAss.Loading, RiskAss.HoldF        

GO


DROP PROCEDURE QSRACC_1
GO
CREATE PROCEDURE QSRACC_1 (@P_MO as varchar(10), @P_Segment as varchar(10), @P_Branch as varchar(10), @P_POLICYNO AS VARCHAR(255), @P_CERTIFICATENO VARCHAR(255), @P_STYPE varchar(20)='') 
AS 
SELECT TOP 50 ACCEPTANCE.POLICYNO, ACCEPTANCE.CERTIFICATENO, Acceptance.AID, Acceptance.AName, SysUser.Name as MOName, Acceptance.Branch, Cover.PHolder, COVER.INSURED, Acceptance.TOC, Cover.CoverDate, Cover.ExpDate, RCover.Code, RCover.Coverage, 
TOC.RegID, TOC.Description as TOCDesc, Profile.Name as PHolderName, Profile.Address_1, Profile.Address_2, Profile.Phone_1, Profile.Phone_2, Profile.Fax_1, Profile.Fax_2, PCalc.Currency, PCalc.TSI, PCalc.Gross,
Acceptance.LANO, Acceptance.ANO, Acceptance.Source as BSID, Cover.CNO, Cover.ASource, Cover.PolicyType, Acceptance.ISType, Cover.Segment, Cover.MO, Branch.Name as BranchName, 
Acceptance.TOPRO, TOPRO.Description as TOPRODesc, Acceptance.RefNo, Acceptance.RefDate,
Acceptance.STime, Acceptance.ETime,
ISource.ID as CedingID, ISource.Share as CedingShare
FROM ACCEPTANCE Left Join (Select RCover.ANO, Max(RCover.Code) as Code, Max(RateTab.Description) as Coverage from RCover, RateTab Where RateTab.Code=RCover.Code and RCover.Category='M' Group By RCover.ANO) RCover on (RCover.ANO=Acceptance.ANO) 
Left join TOPRO on (TOPRO.TOPRO=Acceptance.TOPRO) 
Inner Join Cover on (Cover.CNO=Acceptance.CNO) 
inner join TOC on (TOC.TOC=Acceptance.TOC) 
inner join Profile on (Profile.ID=Cover.PHolder) 
inner join SysUser on (SysUser.ID=Cover.MO) 
inner join Branch on (Branch.Branch=Acceptance.Branch) 
Left Join PCalc on (PCalc.ANO=Acceptance.ANO) 
Left Join ISource on (ISource.CNO=Acceptance.CNO)

WHERE ( 
(@P_SType in ('REFERENCE','CLAIM','RENEWAL') and ACCEPTANCE.ATYPE Not In ('A','C') And Cover.CStatus<>'C' and ACCEPTANCE.ASTATUS Not in ('W','T') And ((ACCEPTANCE.PDATE<ACCEPTANCE.PPDATE) or (ACCEPTANCE.PDATE=ACCEPTANCE.PPDATE and ACCEPTANCE.STime<ACCEPTANCE.ETime)) And ACCEPTANCE.PolicyNo<>'')
or 
(@P_SType in ('ENDORSEMENT') and ACCEPTANCE.ATYPE Not In ('A') And ACCEPTANCE.ASTATUS='I')
or 
(@P_SType in ('CANCELLATION') and ACCEPTANCE.ATYPE Not In ('C') And ACCEPTANCE.ASTATUS='I')
or 
(@P_SType Not in ('REFERENCE','CLAIM','ENDORSEMENT') and ACCEPTANCE.ATYPE Not In ('A','C') And ACCEPTANCE.ASTATUS='I' And ((ACCEPTANCE.PDATE<ACCEPTANCE.PPDATE) or (ACCEPTANCE.PDATE=ACCEPTANCE.PPDATE and ACCEPTANCE.STime<ACCEPTANCE.ETime)))
)
And Cover.MO like @P_MO and Cover.Segment Like @P_Segment 
And Acceptance.Branch Like @P_Branch and ACCEPTANCE.POLICYNO LIKE @P_POLICYNO AND ACCEPTANCE.CERTIFICATENO LIKE @P_CERTIFICATENO 
--And Acceptance.ANO<>Acceptance.LANO 
ORDER BY ACCEPTANCE.ANO DESC 

GO

DROP Procedure Treaty_Adjustment_A
GO
CREATE Procedure Treaty_Adjustment_A(@P_ADATE smalldatetime, @P_REGID varchar(10), @P_FLDID varchar ( 255 ), @P_VALUEID varchar ( 255 ), @P_RYEAR as integer=0)    
as    
SELECT QReinsurance.RYear AS RYEAR,       
MAX(REINSURANCE.RSHARE) as RSHARE,          
SUM((RArrHeader.TAmount-RArrHeader.FAmount)-RARRHEADER.MAMOUNT) AS SI,    
MIN(CASE WHEN RECLASS.CESSIONF=1 THEN 1 ELSE 0 END) AS CLIMIT,    
MIN(CASE WHEN RECLASS.ASSESSMENTF=1 THEN 1 ELSE 0 END) AS RLIMIT,    
MIN(CASE WHEN RECLASS.LIMIT<>0 THEN RECLASS.LIMIT ELSE REINSURANCE.LIMIT END*CASE WHEN (Acceptance.ISType not in ('R','N','T','Q','S','A','X','P')) or (ReClass.DirectF=0) Then 1 Else 0 End) AS LIMIT,    
MIN(RECLASS.PLIMIT) as PLIMIT,  
SUM((RARRHEADER.AAMOUNT+RARRHEADER.AFRAmount)) as REGAMOUNT,
SUM((RARRHEADER.AAMOUNT+RARRHEADER.AFRAmount)/(CASE WHEN RECLASS.CESSIONF=1 THEN RARRHEADER.CLIMIT ELSE 1 END)) as AMOUNT    
FROM ACCEPTANCE
INNER JOIN RARRHEADER ON (RARRHEADER.ANO=ACCEPTANCE.ANO)
INNER JOIN REINSURANCE ON (REINSURANCE.RID=RARRHEADER.AID)
INNER JOIN RECLASS ON (RECLASS.RNO=REINSURANCE.RNO AND RECLASS.TOC=ACCEPTANCE.TOC)
INNER JOIN COVER ON (COVER.CNO=ACCEPTANCE.CNO)
LEFT JOIN ISOURCE ON (ISOURCE.CNO=COVER.CNO)
INNER JOIN REINSURANCE QREINSURANCE ON (QREINSURANCE.RID=RARRHEADER.DID)
WHERE ACCEPTANCE.REGID=@P_REGID AND ACCEPTANCE.FLDID=@P_FLDID And ACCEPTANCE.VALUEID=@P_VALUEID 
AND ACCEPTANCE.ASTATUS='W' and RArrHeader.Status='A' AND RARRHEADER.PCTShare<>0    
And (CASE WHEN RECLASS.CESSIONF=1 THEN RARRHEADER.CLIMIT ELSE 1 END)<>0  
and (@P_RYEAR=0 or QREINSURANCE.RYEAR=@P_RYear)
GROUP BY QREINSURANCE.RYEAR    
ORDER BY MIN(CASE WHEN RECLASS.LIMIT<>0 THEN RECLASS.LIMIT ELSE REINSURANCE.LIMIT END*CASE WHEN (Acceptance.ISType not in ('R','N','T','Q','S','A','X','P')) or (ReClass.DirectF=0) Then 1 Else 0 End) DESC    
    
GO

DROP Procedure Treaty_Adjustment_C
GO
CREATE Procedure Treaty_Adjustment_C(@P_ADATE smalldatetime, @P_REGID varchar(10), @P_FLDID varchar ( 255 ), @P_VALUEID varchar ( 255 ), @P_RYEAR as integer=0)      
as      
SELECT QREINSURANCE.RYEAR AS RYEAR,       
MAX(REINSURANCE.RSHARE) as RSHARE,     
SUM((RArrHeader.TAmount-RArrHeader.FAmount)/(RARRHEADER.PCTShare/100)) AS SI,      
MIN(0) AS RLIMIT,      
MIN(0) AS CLIMIT,      
MIN(CASE WHEN RECLASS.LIMIT<>0 THEN RECLASS.LIMIT ELSE REINSURANCE.LIMIT END*CASE WHEN Acceptance.ISType not in ('R','N','T','Q','S','A','X','P') Then 1 Else 0 End) AS LIMIT,      
MIN(RECLASS.PLIMIT) as PLIMIT,  
SUM(RARRHEADER.CAmount / (RARRHEADER.PctShare / 100 * RARRHEADER.PCTLOSS/100 * (100 - RARRHEADER.MShare) / 100)) As REGAMOUNT,
SUM(RARRHEADER.CAmount / (RARRHEADER.PctShare / 100 * RARRHEADER.PCTLOSS/100 * (100 - RARRHEADER.MShare) / 100)) As Amount      
FROM ACCEPTANCE
INNER JOIN RARRHEADER ON (RARRHEADER.ANO=ACCEPTANCE.ANO)
INNER JOIN REINSURANCE ON (REINSURANCE.RID=RARRHEADER.CID)
INNER JOIN RECLASS ON (RECLASS.RNO=REINSURANCE.RNO AND RECLASS.TOC=ACCEPTANCE.TOC)
INNER JOIN COVER ON (COVER.CNO=ACCEPTANCE.CNO)
LEFT JOIN ISOURCE ON (ISOURCE.CNO=COVER.CNO)
INNER JOIN REINSURANCE QREINSURANCE ON (QREINSURANCE.RID=RARRHEADER.QID)
WHERE ACCEPTANCE.REGID=@P_REGID AND ACCEPTANCE.FLDID=@P_FLDID And ACCEPTANCE.VALUEID=@P_VALUEID 
AND ACCEPTANCE.ASTATUS='W' and RArrHeader.Status='A' AND RARRHEADER.PCTShare<>0    
and (@P_RYEAR=0 or QREINSURANCE.RYEAR=@P_RYear)
GROUP BY QREINSURANCE.RYEAR      
ORDER BY MIN(CASE WHEN RECLASS.LIMIT<>0 THEN RECLASS.LIMIT ELSE REINSURANCE.LIMIT END*CASE WHEN Acceptance.ISType not in ('R','N','T','Q','S','A','X','P') Then 1 Else 0 End) DESC      

GO

DROP Procedure Treaty_Adjustment_D
GO
CREATE Procedure Treaty_Adjustment_D(@P_ADATE smalldatetime, @P_REGID varchar(10), @P_FLDID varchar ( 255 ), @P_VALUEID varchar ( 255 ), @P_RYEAR as integer=0)    
as    
SELECT QReinsurance.RYear AS RYEAR,       
MAX(REINSURANCE.RSHARE) as RSHARE,     
SUM((RArrHeader.TAmount-RArrHeader.FAmount)/(RARRHEADER.PCTShare/100 * RARRHEADER.PCTLOSS/100)) AS SI,     
MIN(CASE WHEN RECLASS.CESSIONF=1 THEN 1 ELSE 0 END) AS CLIMIT,    
MIN(CASE WHEN RECLASS.ASSESSMENTF=1 THEN 1 ELSE 0 END) AS RLIMIT,    
MIN(CASE WHEN RECLASS.LIMIT<>0 THEN RECLASS.LIMIT ELSE REINSURANCE.LIMIT END*CASE WHEN (Acceptance.ISType not in ('R','N','T','Q','S','A','X','P')) or (ReClass.DirectF=0) Then 1 Else 0 End) AS LIMIT,      
MIN(RECLASS.PLIMIT) as PLIMIT,  
SUM(RARRHEADER.DAMOUNT / (RARRHEADER.PctShare / 100 * RARRHEADER.PCTLOSS/100 * (100 - RARRHEADER.MShare) / 100)) As REGAMOUNT,
SUM(RARRHEADER.DAMOUNT/(CASE WHEN RECLASS.CESSIONF=1 THEN RARRHEADER.CLIMIT ELSE 1 END) / (RARRHEADER.PctShare / 100 * RARRHEADER.PCTLOSS/100 * (100 - RARRHEADER.MShare) / 100)) As Amount      
FROM ACCEPTANCE
INNER JOIN RARRHEADER ON (RARRHEADER.ANO=ACCEPTANCE.ANO)
INNER JOIN REINSURANCE ON (REINSURANCE.RID=RARRHEADER.XPID)
INNER JOIN RECLASS ON (RECLASS.RNO=REINSURANCE.RNO AND RECLASS.TOC=ACCEPTANCE.TOC)
INNER JOIN COVER ON (COVER.CNO=ACCEPTANCE.CNO)
LEFT JOIN ISOURCE ON (ISOURCE.CNO=COVER.CNO)
INNER JOIN REINSURANCE QREINSURANCE ON (QREINSURANCE.RID=RARRHEADER.DID)
WHERE ACCEPTANCE.REGID=@P_REGID AND ACCEPTANCE.FLDID=@P_FLDID And ACCEPTANCE.VALUEID=@P_VALUEID 
AND ACCEPTANCE.ASTATUS='W' and RArrHeader.Status='A' AND RARRHEADER.PCTShare<>0    
And (CASE WHEN RECLASS.CESSIONF=1 THEN RARRHEADER.CLIMIT ELSE 1 END)<>0  
and (@P_RYEAR=0 or QREINSURANCE.RYEAR=@P_RYear)
GROUP BY QREINSURANCE.RYEAR   
ORDER BY MIN(CASE WHEN RECLASS.LIMIT<>0 THEN RECLASS.LIMIT ELSE REINSURANCE.LIMIT END*CASE WHEN (Acceptance.ISType not in ('R','N','T','Q','S','A','X','P')) or (ReClass.DirectF=0) Then 1 Else 0 End) DESC    

GO

DROP Procedure Treaty_Adjustment_Q
GO
CREATE Procedure Treaty_Adjustment_Q(@P_ADATE smalldatetime, @P_REGID varchar(10), @P_FLDID varchar ( 255 ), @P_VALUEID varchar ( 255 ), @P_RYEAR as integer=0)    
as    
SELECT YEAR(RARRHEADER.RDATE) AS RYEAR,     
MAX(REINSURANCE.RSHARE) as RSHARE,     
SUM((RArrHeader.TAmount-RArrHeader.FAmount)-RARRHEADER.MAMOUNT) AS SI,    
MIN(CASE WHEN RECLASS.CESSIONF=1 THEN 1 ELSE 0 END) AS CLIMIT,    
MIN(CASE WHEN RECLASS.ASSESSMENTF=1 THEN 1 ELSE 0 END) AS RLIMIT,    
MIN(CASE WHEN RECLASS.LIMIT<>0 THEN RECLASS.LIMIT ELSE REINSURANCE.LIMIT END*CASE WHEN (Acceptance.ISType not in ('R','N','T','Q','S','A','X','P')) or (ReClass.DirectF=0) Then 1 Else 0 End) AS LIMIT,    
MIN(RECLASS.PLIMIT) as PLIMIT,  
SUM((RARRHEADER.QAMOUNT+RARRHEADER.QSRAMOUNT)) as REGAMOUNT,
SUM((RARRHEADER.QAMOUNT+RARRHEADER.QSRAMOUNT)/(CASE WHEN RECLASS.CESSIONF=1 THEN RARRHEADER.CLIMIT ELSE 1 END)) as AMOUNT    
From RARRHEADER, acceptance, REINSURANCE, cover, RECLASS    
WHERE COVER.CNO=ACCEPTANCE.CNO AND RECLASS.TOC=ACCEPTANCE.TOC AND RECLASS.RNO=REINSURANCE.RNO AND    
ACCEPTANCE.REGID=@P_REGID AND ACCEPTANCE.FLDID=@P_FLDID And ACCEPTANCE.VALUEID=@P_VALUEID And ACCEPTANCE.ANO=RARRHEADER.ANO and ACCEPTANCE.ASTATUS='W' and RArrHeader.Status='A' And REINSURANCE.RID=RARRHEADER.QID    
And (CASE WHEN RECLASS.CESSIONF=1 THEN RARRHEADER.CLIMIT ELSE 1 END)<>0  
and (@P_RYEAR=0 or Year(RARRHeader.RDate)=@P_RYear)
GROUP BY YEAR(RARRHEADER.RDATE)    
ORDER BY MIN(CASE WHEN RECLASS.LIMIT<>0 THEN RECLASS.LIMIT ELSE REINSURANCE.LIMIT END*CASE WHEN (Acceptance.ISType not in ('R','N','T','Q','S','A','X','P')) or (ReClass.DirectF=0) Then 1 Else 0 End) DESC    

GO
DROP Procedure Treaty_Adjustment_S1
GO
CREATE Procedure Treaty_Adjustment_S1(@P_ADATE smalldatetime, @P_REGID varchar(10), @P_FLDID varchar ( 255 ), @P_VALUEID varchar ( 255 ), @P_RYEAR as integer=0)    
as    
SELECT YEAR(RARRHEADER.RDATE) AS RYEAR,     
MAX(REINSURANCE.RSHARE) as RSHARE,     
SUM((RArrHeader.TAmount-RArrHeader.FAmount)-RARRHEADER.MAMOUNT) AS SI,    
MIN(CASE WHEN RECLASS.CESSIONF=1 THEN 1 ELSE 0 END) AS CLIMIT,    
MIN(CASE WHEN RECLASS.ASSESSMENTF=1 THEN 1 ELSE 0 END) AS RLIMIT,    
MIN(CASE WHEN RECLASS.LIMIT<>0 THEN RECLASS.LIMIT ELSE REINSURANCE.LIMIT END*CASE WHEN (Acceptance.ISType not in ('R','N','T','Q','S','A','X','P')) or (ReClass.DirectF=0) Then 1 Else 0 End) AS LIMIT,    
MIN(RECLASS.PLIMIT) as PLIMIT,  
SUM((RARRHEADER.SP1AMOUNT)) as REGAMOUNT,
SUM((RARRHEADER.SP1AMOUNT)/(CASE WHEN RECLASS.CESSIONF=1 THEN RARRHEADER.CLIMIT ELSE 1 END)) as AMOUNT    
From RARRHEADER, acceptance, REINSURANCE, cover, RECLASS    
WHERE COVER.CNO=ACCEPTANCE.CNO AND RECLASS.TOC=ACCEPTANCE.TOC AND RECLASS.RNO=REINSURANCE.RNO AND    
ACCEPTANCE.REGID=@P_REGID AND ACCEPTANCE.FLDID=@P_FLDID And ACCEPTANCE.VALUEID=@P_VALUEID And ACCEPTANCE.ANO=RARRHEADER.ANO and ACCEPTANCE.ASTATUS='W' and RArrHeader.Status='A' And REINSURANCE.RID=RARRHEADER.SP1ID    
And (CASE WHEN RECLASS.CESSIONF=1 THEN RARRHEADER.CLIMIT ELSE 1 END)<>0  
and (@P_RYEAR=0 or Year(RARRHeader.RDate)=@P_RYear)
GROUP BY YEAR(RARRHEADER.RDATE)    
ORDER BY MIN(CASE WHEN RECLASS.LIMIT<>0 THEN RECLASS.LIMIT ELSE REINSURANCE.LIMIT END*CASE WHEN (Acceptance.ISType not in ('R','N','T','Q','S','A','X','P')) or (ReClass.DirectF=0) Then 1 Else 0 End) DESC    
GO

DROP Procedure Treaty_Adjustment_S2
GO
CREATE Procedure Treaty_Adjustment_S2(@P_ADATE smalldatetime, @P_REGID varchar(10), @P_FLDID varchar ( 255 ), @P_VALUEID varchar ( 255 ), @P_RYEAR as integer=0)    
as    
SELECT YEAR(RARRHEADER.RDATE) AS RYEAR,     
MAX(REINSURANCE.RSHARE) as RSHARE,     
SUM((RArrHeader.TAmount-RArrHeader.FAmount)-RARRHEADER.MAMOUNT) AS SI,    
MIN(CASE WHEN RECLASS.CESSIONF=1 THEN 1 ELSE 0 END) AS CLIMIT,    
MIN(CASE WHEN RECLASS.ASSESSMENTF=1 THEN 1 ELSE 0 END) AS RLIMIT,    
MIN(CASE WHEN RECLASS.LIMIT<>0 THEN RECLASS.LIMIT ELSE REINSURANCE.LIMIT END*CASE WHEN (Acceptance.ISType not in ('R','N','T','Q','S','A','X','P')) or (ReClass.DirectF=0) Then 1 Else 0 End) AS LIMIT,    
MIN(RECLASS.PLIMIT) as PLIMIT,  
SUM((RARRHEADER.SP2AMOUNT)) as REGAMOUNT,
SUM((RARRHEADER.SP2AMOUNT)/(CASE WHEN RECLASS.CESSIONF=1 THEN RARRHEADER.CLIMIT ELSE 1 END)) as AMOUNT    
From RARRHEADER, acceptance, REINSURANCE, cover, RECLASS    
WHERE COVER.CNO=ACCEPTANCE.CNO AND RECLASS.TOC=ACCEPTANCE.TOC AND RECLASS.RNO=REINSURANCE.RNO AND    
ACCEPTANCE.REGID=@P_REGID AND ACCEPTANCE.FLDID=@P_FLDID And ACCEPTANCE.VALUEID=@P_VALUEID And ACCEPTANCE.ANO=RARRHEADER.ANO and ACCEPTANCE.ASTATUS='W' and RArrHeader.Status='A' And REINSURANCE.RID=RARRHEADER.SP2ID    
And (CASE WHEN RECLASS.CESSIONF=1 THEN RARRHEADER.CLIMIT ELSE 1 END)<>0  
and (@P_RYEAR=0 or Year(RARRHeader.RDate)=@P_RYear)
GROUP BY YEAR(RARRHEADER.RDATE)    
ORDER BY MIN(CASE WHEN RECLASS.LIMIT<>0 THEN RECLASS.LIMIT ELSE REINSURANCE.LIMIT END*CASE WHEN (Acceptance.ISType not in ('R','N','T','Q','S','A','X','P')) or (ReClass.DirectF=0) Then 1 Else 0 End) DESC    
GO

DROP Procedure Treaty_Adjustment_S3
GO
CREATE Procedure Treaty_Adjustment_S3(@P_ADATE smalldatetime, @P_REGID varchar(10), @P_FLDID varchar ( 255 ), @P_VALUEID varchar ( 255 ), @P_RYEAR as integer=0)    
as    
SELECT YEAR(RARRHEADER.RDATE) AS RYEAR,     
MAX(REINSURANCE.RSHARE) as RSHARE,     
SUM((RArrHeader.TAmount-RArrHeader.FAmount)-RARRHEADER.MAMOUNT) AS SI,    
MIN(CASE WHEN RECLASS.CESSIONF=1 THEN 1 ELSE 0 END) AS CLIMIT,    
MIN(CASE WHEN RECLASS.ASSESSMENTF=1 THEN 1 ELSE 0 END) AS RLIMIT,    
MIN(CASE WHEN RECLASS.LIMIT<>0 THEN RECLASS.LIMIT ELSE REINSURANCE.LIMIT END*CASE WHEN (Acceptance.ISType not in ('R','N','T','Q','S','A','X','P')) or (ReClass.DirectF=0) Then 1 Else 0 End) AS LIMIT,    
MIN(RECLASS.PLIMIT) as PLIMIT,  
SUM((RARRHEADER.SP3AMOUNT)) as REGAMOUNT,
SUM((RARRHEADER.SP3AMOUNT)/(CASE WHEN RECLASS.CESSIONF=1 THEN RARRHEADER.CLIMIT ELSE 1 END)) as AMOUNT    
From RARRHEADER, acceptance, REINSURANCE, cover, RECLASS    
WHERE COVER.CNO=ACCEPTANCE.CNO AND RECLASS.TOC=ACCEPTANCE.TOC AND RECLASS.RNO=REINSURANCE.RNO AND    
ACCEPTANCE.REGID=@P_REGID AND ACCEPTANCE.FLDID=@P_FLDID And ACCEPTANCE.VALUEID=@P_VALUEID And ACCEPTANCE.ANO=RARRHEADER.ANO and ACCEPTANCE.ASTATUS='W' and RArrHeader.Status='A' And REINSURANCE.RID=RARRHEADER.SP3ID    
And (CASE WHEN RECLASS.CESSIONF=1 THEN RARRHEADER.CLIMIT ELSE 1 END)<>0  
and (@P_RYEAR=0 or Year(RARRHeader.RDate)=@P_RYear)
GROUP BY YEAR(RARRHEADER.RDATE)    
ORDER BY MIN(CASE WHEN RECLASS.LIMIT<>0 THEN RECLASS.LIMIT ELSE REINSURANCE.LIMIT END*CASE WHEN (Acceptance.ISType not in ('R','N','T','Q','S','A','X','P')) or (ReClass.DirectF=0) Then 1 Else 0 End) DESC    

GO
DROP Procedure Treaty_Adjustment_XP
GO
CREATE Procedure Treaty_Adjustment_XP(@P_ADATE smalldatetime, @P_REGID varchar(10), @P_FLDID varchar ( 255 ), @P_VALUEID varchar ( 255 ), @P_RYEAR as integer=0)      
as      
SELECT QReinsurance.RYear AS RYEAR,       
MAX(REINSURANCE.RSHARE) as RSHARE,     
SUM((RArrHeader.TAmount-RArrHeader.FAmount)/(RARRHEADER.PCTShare/100 * RARRHEADER.PCTLOSS/100)) AS SI,      
MIN(0) AS RLIMIT,      
MIN(0) AS CLIMIT,      
MIN(CASE WHEN RECLASS.LIMIT<>0 THEN RECLASS.LIMIT ELSE REINSURANCE.LIMIT END*CASE WHEN Acceptance.ISType not in ('R','N','T','Q','S','A','X','P') Then 1 Else 0 End) AS LIMIT,      
MIN(RECLASS.PLIMIT) as PLIMIT,  
SUM(RARRHEADER.XPAmount / (RARRHEADER.PctShare / 100 * RARRHEADER.PCTLOSS/100 * (100 - RARRHEADER.MShare) / 100)) As REGAMOUNT,
SUM(RARRHEADER.XPAmount / (RARRHEADER.PctShare / 100 * RARRHEADER.PCTLOSS/100 * (100 - RARRHEADER.MShare) / 100)) As Amount      
FROM ACCEPTANCE
INNER JOIN RARRHEADER ON (RARRHEADER.ANO=ACCEPTANCE.ANO)
INNER JOIN REINSURANCE ON (REINSURANCE.RID=RARRHEADER.XPID)
INNER JOIN RECLASS ON (RECLASS.RNO=REINSURANCE.RNO AND RECLASS.TOC=ACCEPTANCE.TOC)
INNER JOIN COVER ON (COVER.CNO=ACCEPTANCE.CNO)
LEFT JOIN ISOURCE ON (ISOURCE.CNO=COVER.CNO)
INNER JOIN REINSURANCE QREINSURANCE ON (QREINSURANCE.RID=RARRHEADER.QID)
WHERE ACCEPTANCE.REGID=@P_REGID AND ACCEPTANCE.FLDID=@P_FLDID And ACCEPTANCE.VALUEID=@P_VALUEID 
AND ACCEPTANCE.ASTATUS='W' and RArrHeader.Status='A' AND RARRHEADER.PCTShare<>0    
and (@P_RYEAR=0 or QREINSURANCE.RYEAR=@P_RYear)
GROUP BY QREINSURANCE.RYEAR      
ORDER BY MIN(CASE WHEN RECLASS.LIMIT<>0 THEN RECLASS.LIMIT ELSE REINSURANCE.LIMIT END*CASE WHEN Acceptance.ISType not in ('R','N','T','Q','S','A','X','P') Then 1 Else 0 End) DESC      
GO

DROP Procedure TREATY_LIMIT
GO
CREATE Procedure TREATY_LIMIT (@P_ANO integer, @P_OurShare Float, @P_NCoys Integer, @P_TSI Float=0)  
as  
SELECT TOP 1 TOL.Limit, TOL.HOLDF  
From Acceptance
Inner Join RARRHEADER on (RArrHeader.ANO=Acceptance.ANO)
Inner Join cover on (Cover.CNO=Acceptance.CNO)
Inner Join REINSURANCE on (RArrHeader.RDate Between Reinsurance.SDate and Reinsurance.EDate and Reinsurance.RType In ('Q','S1','S2','S3'))
Inner Join RECLASS on (ReClass.RNO=Reinsurance.RNO and ReClass.TOC=Acceptance.TOC and ReClass.CessionF=1)
Inner Join TOL on (TOL.RYear=Reinsurance.RYear And TOL.TOC=ReClass.TOC And TOL.IsType=Acceptance.IsType)
WHERE Acceptance.ANO=@P_ANO 
And (TOL.Minrange=0 or TOL.Minrange<=@P_OurShare) And (TOL.MaxRange=0 or TOL.MaxRange>=@P_OurShare)
And (TOL.MinCoys=0 or TOL.MinCoys<=@P_NCoys) And (TOL.MaxCoys=0 or TOL.MaxCoys>=@P_NCoys)
And (TOL.MinYear=0 or TOL.MinYear<=datediff(year,Acceptance.SDate, Acceptance.EDate)) And (TOL.MaxYear=0 or TOL.MaxYear>=datediff(year,Acceptance.SDate, Acceptance.EDate))
And (TOL.MinTSI=0 or TOL.MinTSI<=@P_TSI) And (TOL.MaxTSI=0 or TOL.MaxTSI>=@P_TSI)
Order By TOL.Limit Desc  

GO

DROP Procedure Treaty_Premium_Commission
GO
CREATE Procedure Treaty_Premium_Commission(@P_ANO integer,@P_Code varchar(10),@P_CCY varchar(10), @P_SDate smalldatetime, @P_EDate smalldatetime,@P_RID varchar(255),@P_AdjustableF Bit,@P_TSI Float=0, @P_ID varchar(10)='', @P_DocNo varchar(50)='')    
as    
Declare @Premium_Treaty_Discount as Float            
Declare @Premium_Discount as Float            
Declare @Premium_Commission as Float            
Declare @Premium_Commission_Inward as Float            
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
Declare @P_COMM_C as Float    
Declare @P_COMMN_C as Float    
Declare @P_OnNetPremiumF as Bit    
Declare @P_RNO as int    
Declare @P_RType as varchar(10)        
Declare @P_OPFEEPCT as Float    
Declare @P_OANO as int    
Declare @P_COMMPOLICYF as Bit    
Declare @P_PFactor as Float  
Declare @P_IFee as Float  
Declare @P_Period as Int  
Declare @P_Tabarru as Float  
Declare @P_RITabarruF as Bit  
Declare @P_UjrohCedant as Float
Declare @P_UjrohReins as Float
Declare @P_OPFEEF as Bit  

Declare @P_ASDate as SmallDatetime
Declare @P_AEDate as SmallDatetime
Declare @P_LANO as Int

Select     
@P_Period=cast(datediff(Month,A.SDate, @P_SDate) as integer) / 12 + 1,  
@P_ASDate=A.SDate,
@P_AEDate=A.EDate, 
@P_NOFYEARS=datediff(year,A.sdate, A.edate),     
@P_TOC=A.TOC,     
@P_AType=A.AType,     
@P_ONGROSSNET=R.ONGROSSNET,     
@P_RateConF=R3.RateConF,     
@P_NETRATEDet=R4.NETRATE,    
@P_COMM=CASE WHEN R3.COMM<>0 Then R3.COMM ELSE R2.COMM END,    
@P_COMMN=CASE WHEN R3.COMMN<>0 Then R3.COMMN ELSE R2.COMMN END,
@P_COMM_C=R3.COMM,
@P_COMMN_C=R3.COMMN,
@P_OnNetPremiumF=R2.OnNetPremiumF,     
@P_RNO=R1.RNO,    
@P_RType=R1.RType,    
@P_OANO=A.OANO,    
@P_COMMPOLICYF=R2.COMMPOLICYF,  
@P_PFactor=Case When A.ISType='R' Then (100-I.UJrohCedant)/100*(100+I.UjrohReins)/100 else 1 end,  
@Premium_Commission_Inward=coalesce(I2.Fee+I2.HF,coalesce(I.Fee+I.HF,0))+coalesce(I.OC,0),  
@P_Tabarru=(100-A.Ujroh),  
@P_UjrohCedant=R1.UJROHCEDANT,
@P_UjrohReins=R1.UJROHREINS,
@P_OPFEEF=R3.OPFEEF,
@P_LANO=A.LANO
from Acceptance A  
Inner Join RarrHeader R on (R.ANO=A.ANO)  
Inner Join Cover C on (C.CNO=A.CNO)  
Left Join ISource I on (I.CNO=A.CNO)  
Left Join ISourceDet I2 on (I2.CNO=A.CNO and I2.Code=@P_Code)  
Inner Join Reinsurance R1 on (R1.RID=@P_RID)  
Cross Apply (Select Top 1 COMM, COMMN, OnNetPremiumF, COMMPOLICYF from RPart R2 Where R2.RNO=R1.RNO ) R2
Inner Join ReClass R3 on (R3.RNO=R1.RNO and R3.TOC=A.TOC)  
Left Join ReClassDet R4 on (R4.RNO=R3.RNO AND R4.TOC=R3.TOC AND R4.CODE=@P_CODE)    
Where A.ANO=@P_ANO  

if @P_OnNetPremiumF=1  
 Select @Premium_Treaty_Discount=dbo.Premium_Treaty_Discount(@P_ANO, @P_Code,@P_Period)            
else  
 Select @Premium_Treaty_Discount=0  
  
if @P_COMMN<>0  
Begin  
 Select @Premium_Discount=dbo.premium_discount(@P_ANO, @P_Code, @P_Period)    
 Select @Premium_Fee=dbo.Premium_Fee(@P_ANO, @P_Period)    
End  
else  
Begin  
 Select @Premium_Discount=0  
 Select @Premium_Fee=0  
End  
  
if @P_COMMN<>0 or (@P_COMMPOLICYF=1 and @P_COMM=0 and @P_COMMN=0)  
 Select @Premium_Commission=dbo.Premium_Commission(@P_ANO, @P_Code, @P_Period,0)+dbo.Premium_MaxOutGo_Vat(@P_ANO, @P_Code, @P_Period,0)    
Else  
 Select @Premium_Commission=0  
  
Select @Premium_outGo=@Premium_Discount+@Premium_Commission+@Premium_Commission_Inward+@Premium_Fee-(Case When @P_OnNetPremiumF=1 Then @Premium_Treaty_Discount else 0 end)  
Select @P_COMM=CASE WHEN @P_COMMPOLICYF=1 and @P_COMM=0 and @P_COMMN=0 Then @Premium_Commission ELSE @P_COMM END    

SELECT @P_OPFEEPCT=Case When ROUND(COALESCE(SUM(Gross),0),4)<>0 Then COALESCE(SUM(FEE),0)/ROUND(COALESCE(SUM(Gross),0),4)*100 Else 0 End, @P_RITabarruF=coalesce(cast(Max(cast(RITabarruF as Int)) as Bit),0)  
FROM  
(  
	SELECT  
	A2.ANO,  
	Premium.Gross,
	Case   
	When coalesce(A1.Amount,0)<>0 Then  
		A1.Amount*Case When A1.RITabarruF=1 Then cast(100 as Float)/@P_Tabarru Else 1 end 
	When coalesce(A1.AmountPCT,0)<>0 then
		(Premium.Gross)*A1.AmountPCT/100*Case When A1.RITabarruF=1 Then cast(100 as Float)/@P_Tabarru Else 1 end 	
	Else
		0
	End as Fee,
	coalesce(A1.RITabarruF,cast(0 as Bit)) as RITabarruF
	from   
	Acceptance A2  
	INNER Join PCalc on (PCalc.ANO=A2.ANO and PCalc.Currency=@P_CCY)  
	Outer Apply (
		Select
		sum(case When A1.PolicyYear<>0 then 
			A1.Amount*case When A1.ContributionF=1 Then 1 Else 100/coalesce(R.PCTSHARE-R.MSHARE,100) End
		else 
			A1.Amount*case When A1.ContributionF=1 Then 1 Else 100/coalesce(R.PCTSHARE-R.MSHARE,100) End*cast(dbo.fn_Premium_Calc_Prorata(@P_SDate, @P_EDate, 0,1,2) as Float)/cast(dbo.fn_Premium_Calc_Prorata(@P_ASDate, @P_AEDate,0,1,2) as Float)
		End) as Amount,
		sum(A1.AMOUNTPCT) as AMOUNTPCT, MAX(A1.AMOUNTPCTBASED) as AMOUNTPCTBASED, Cast(MAX(Cast(A1.RITabarruF as Int)) as Bit) as RITabarruF
		from AccFD A1
		Inner Join RArrHeader R on (R.ANO=A2.ANO)
		Inner Join FDTAB on (FDTAB.FDID=A1.FDID and Left(FDTAB.FDType,1)='O')
		Where A1.ANO=A2.ANO and A1.Currency=PCalc.Currency and (A1.ContributionF=1 or A1.CessionF=1) and A1.AmountPCTBased in (0,3) And (A1.PolicyYear=0 or A1.PolicyYear=@P_Period)
	) A1
	Outer APPLY
	(
		Select coalesce(sum(Gross),0) as Gross
		from
		(
			Select   
			Case			
			When coalesce(A1.AMOUNTPCTBASED,0)<>3 then
				D1.Gross*D1.Prorata*P.Gross/P.OGross
			else
				D1.Gross*D1.Prorata*P.Gross/P.OGross*(100-D1.Discount-D1.Commission)/100
			End as Gross
			from Display_Calculation(A2.ANO) D1  
			Inner Join Acceptance A on (A.ANO=D1.ANO)  
			Inner Join PCalc P on (P.ANO=D1.ANO and P.Currency=D1.Currency)  
			Where D1.Currency=@P_CCY  
			and (@P_Period=0 or (D1.SDate>=dateadd(month,12*(@P_Period-1),A.SDate) and D1.SDate<dateadd(month,12*(@P_Period),A.SDate)))
		) Premium
	) Premium
   	Where @P_RType in ('Q','S1','S2','S3','A') and A2.OANO=@P_OANO and A2.ANO<=@P_ANO    
	and A2.ANO>(Select coalesce(Max(ANO),0) from Acceptance Where AType='C' and EMethod='A' and Acceptance.OANO=@P_OANO and Acceptance.ANO<=@P_ANO and AStatus not in ('W','T'))  


	Union All  
  
	--Op Fee from Master Policy  
	SELECT  
	A2.ANO,  
	0 as Gross,
	Case   
	When coalesce(A1.Amount,0)<>0 Then  
	--Not Yet for Master Policy  
		0  
	When coalesce(A1.AmountPCT,0)<>0 Then  
		(Premium.Gross)*A1.AmountPCT/100*Case When A1.RITabarruF=1 Then cast(100 as Float)/@P_Tabarru Else 1 end 	
	Else
		0
	End as Fee,
	coalesce(A1.RITabarruF,cast(0 as Bit)) as RITabarruF
	from   
	Acceptance A2  
	INNER Join PCalc on (PCalc.ANO=A2.ANO and PCalc.Currency=@P_CCY)  
	INNER JOIN Acceptance MA on (MA.PolicyNo<>'' and MA.RegNo=A2.RegNo and MA.ANO=MA.LANO)  
	INNER JOIN COVER C on (C.CNO=MA.CNO and C.OPENFLAG=0)  
	Outer Apply (
		Select 
		sum(case When A1.PolicyYear<>0 then 
			A1.Amount*case When A1.ContributionF=1 Then 1 Else 100/coalesce(R.PCTSHARE-R.MSHARE,100) End
		else 
			A1.Amount*case When A1.ContributionF=1 Then 1 Else 100/coalesce(R.PCTSHARE-R.MSHARE,100) End*cast(dbo.fn_Premium_Calc_Prorata(@P_SDate, @P_EDate, 0,1,2) as Float)/cast(dbo.fn_Premium_Calc_Prorata(@P_ASDate, @P_AEDate,0,1,2) as Float)
		End) as Amount,
		sum(A1.AMOUNTPCT) as AMOUNTPCT, MAX(A1.AMOUNTPCTBASED) as AMOUNTPCTBASED, Cast(MAX(Cast(A1.RITabarruF as Int)) as Bit) as RITabarruF
		from AccFD A1
		Inner Join RArrHeader R on (R.ANO=A2.ANO)
		Inner Join FDTAB on (FDTAB.FDID=A1.FDID and Left(FDTAB.FDType,1)='O')
		Where A1.ANO=MA.ANO and A1.Currency=PCalc.Currency and (A1.ContributionF=1 or A1.CessionF=1) and A1.AmountPCTBased in (0,3) And (A1.PolicyYear=0 or A1.PolicyYear=@P_Period)
	) A1
	Outer APPLY
	(
		Select coalesce(sum(Gross),0) as Gross
		from
		(
			Select   
			Case			
			When coalesce(A1.AMOUNTPCTBASED,0)<>3 then
				D1.Gross*D1.Prorata*P.Gross/P.OGross
			else
				D1.Gross*D1.Prorata*P.Gross/P.OGross*(100-D1.Discount-D1.Commission)/100
			End as Gross
			from Display_Calculation(A2.ANO) D1  
			Inner Join Acceptance A on (A.ANO=D1.ANO)  
			Inner Join PCalc P on (P.ANO=D1.ANO and P.Currency=D1.Currency)  
			Where D1.Currency=@P_CCY  
			and (@P_Period=0 or (D1.SDate>=dateadd(month,12*(@P_Period-1),A.SDate) and D1.SDate<dateadd(month,12*(@P_Period),A.SDate)))
		) Premium
	) Premium
	Where @P_LANO<>-1 and @P_RType in ('Q','S1','S2','S3','A') and A2.OANO=@P_OANO and A2.ANO<=@P_ANO    
	and A2.ANO>(Select coalesce(Max(ANO),0) from Acceptance Where AType='C' and EMethod='A' and Acceptance.OANO=@P_OANO and Acceptance.ANO<=@P_ANO and AStatus not in ('W','T'))  
) A  
Where @P_OPFEEF=1  

--In Base Currency
Select 
	sum(R.Premium*R.Share/100*R.Rate) as Premium,
	sum(R.UjrohCedant*R.Share/100*R.Rate) as UjrohCedant,
	sum(R.UjrohReins*R.Share/100*R.Rate) as UjrohReins,
	sum(R.Commission*R.Share/100*R.Rate) as Commission,
	sum(R.Discount*R.Share/100*R.Rate) as Discount,
	sum(R.Fee*R.Share/100*R.Rate) as Fee
from
(
	Select
	R.ID, 
	R.DocNo,
	Max(R.Rate) as Rate,
	Max(R.Share) as Share,
	sum(Case When OnMinPremiumF=0 Then (case When Gross_1>Gross_2 then Gross_1 else Gross_2 end) else (case When Gross_1<Gross_2 and Gross_1<>0 then Gross_1 else Gross_2 end) end) as Premium,           
	sum(Case When OnMinPremiumF=0 Then (case When Gross_1>Gross_2 then Gross_1 else Gross_2 end) else (case When Gross_1<Gross_2 and Gross_1<>0 then Gross_1 else Gross_2 end) end)*@P_UjrohCedant/100 as UjrohCedant,           
	sum(Case When OnMinPremiumF=0 Then (case When Gross_1>Gross_2 then Gross_1 else Gross_2 end) else (case When Gross_1<Gross_2 and Gross_1<>0 then Gross_1 else Gross_2 end) end)*(100-@P_UjrohCedant)/100*@P_UjrohReins/100 as UjrohReins,           
	sum(Case When OnMinPremiumF=0 Then (case When Gross_1>Gross_2 then Comm_1 else Comm_2 end) else (case When Gross_1<Gross_2 and Gross_1<>0 then Comm_1 else Comm_2 end) end) as Commission,         
	sum(Case When OnMinPremiumF=0 Then (case When Gross_1>Gross_2 then Disc_1 else Disc_2 end) else (case When Gross_1<Gross_2 and Gross_1<>0 then Disc_1 else Disc_2 end) end) as Discount,  
	sum(Case When OnMinPremiumF=0 Then (case When Gross_1>Gross_2 then Fee_1 else Fee_2 end) else (case When Gross_1<Gross_2 and Gross_1<>0 then Fee_1 else Fee_2 end) end) as Fee              
	From          
	(
		select            
		RPart.ID,
		RPart.DocNo,
		Max(PCalc.Rate) as Rate,
		Max(RPart.Share-RPart.JP) as Share,
		cast(Max(Cast(RPart.OnMinPremiumF as integer)) as Bit) as OnMinPremiumF,              

		coalesce(SUM((CASE WHEN RPART.PPCT<>0 THEN RPART.PPCT/100 ELSE (Case When @P_RateConF=1 and (RRateCon.Rate is not null or RateCon.Rate is not null) then 0 else 1 end) END * ICALC.GROSS*(PCALC.PGROSS*@P_PFactor)/PCALC.POGROSS*(100-@Premium_Treaty_Discount)/100-(ICALC.GROSS*PCALC.PGROSS/PCALC.POGROSS*@P_OPFEEPCT/100))*(Case When (CASE WHEN @P_COMMN_C<>0 Then @P_COMMN_C ELSE RPART.COMMN END)=0 Then (CASE WHEN @P_COMM_C<>0 Then @P_COMM_C WHEN RPART.COMM<>0 THEN RPART.COMM ELSE @P_COMM END)/100 else (Case When RCover.NetRateF=1 or @P_ONGROSSNET=2 OR (@P_ONGROSSNET=0 AND (100-@Premium_OutGo)/100*(100-(CASE WHEN @P_COMMN_C<>0 Then @P_COMMN_C ELSE RPART.COMMN END))/100<(100-(CASE WHEN @P_COMM_C<>0 Then @P_COMM_C WHEN RPART.COMM<>0 THEN RPART.COMM ELSE @P_COMM END))/100) Then (100-@Premium_OutGo)/100*((CASE WHEN @P_COMMN_C<>0 Then @P_COMMN_C ELSE RPART.COMMN END))/100 else (CASE WHEN @P_COMM_C<>0 Then @P_COMM_C WHEN RPART.COMM<>0 THEN RPART.COMM ELSE @P_COMM END)/100 end) end)),0) AS COMM_1,                
		coalesce(SUM((Case When @P_RateConF=1 Then (Case When RRateCon.Rate is null then RateCon.Rate*(Case When RateCon.Loading<>0 then RateCon.Loading/100 else RCover.Loading end) else RRateCon.Rate/PCalc.RiskNum*(Case When RRateCon.Loading<>0 then RRateCon.Loading/100 else RCover.Loading end) end) Else coalesce(@P_NETRATEDet,RPART.NETRATE/PCalc.RiskNum) end/100*(100-RCover.Discount)/100*ICALC.GROSS/PCALC.GROSS*ICALC.PRORATA *ICALC.TSI*(CASE WHEN RCOVER.PCALC='S' OR RCOVER.PCTLOSS=0 THEN 100 ELSE RCOVER.PCTLOSS END)/(CASE WHEN RCOVER.PCTLOSS=0 THEN 100 ELSE RCOVER.PCTLOSS END+RCOVER.PAddition)*ICALC.PCTADJ/100-(ICALC.GROSS*PCALC.PGROSS/PCALC.POGROSS*@P_OPFEEPCT/100))*(Case When (CASE WHEN @P_COMMN_C<>0 Then @P_COMMN_C ELSE RPART.COMMN END)=0 Then (CASE WHEN @P_COMM_C<>0 Then @P_COMM_C WHEN RPART.COMM<>0 THEN RPART.COMM ELSE @P_COMM END)/100 else (Case When RCover.NetRateF=1 or @P_ONGROSSNET=2 OR (@P_ONGROSSNET=0 AND (100-@Premium_OutGo)/100*(100-(CASE WHEN @P_COMMN_C<>0 Then @P_COMMN_C ELSE RPART.COMMN END))/100<(100-(CASE WHEN @P_COMM_C<>0 Then @P_COMM_C WHEN RPART.COMM<>0 THEN RPART.COMM ELSE @P_COMM END))/100) Then (100-@Premium_OutGo)/100*((CASE WHEN @P_COMMN_C<>0 Then @P_COMMN_C ELSE RPART.COMMN END))/100 else (CASE WHEN @P_COMM_C<>0 Then @P_COMM_C WHEN RPART.COMM<>0 THEN RPART.COMM ELSE @P_COMM END)/100 end) end)),0) AS COMM_2,                
  
		coalesce(SUM((CASE WHEN RPART.PPCT<>0 THEN RPART.PPCT/100 ELSE (Case When @P_RateConF=1 and (RRateCon.Rate is not null or RateCon.Rate is not null) then 0 else 1 end) END * ICALC.GROSS*(PCALC.PGROSS*@P_PFactor)/PCALC.POGROSS*(100-@Premium_Treaty_Discount)/100)*(Case When (CASE WHEN @P_COMMN_C<>0 Then @P_COMMN_C ELSE RPART.COMMN END)=0 Then 1 else (Case When RCover.NetRateF=1 or @P_ONGROSSNET=2 OR (@P_ONGROSSNET=0 AND (100-@Premium_OutGo)/100*(100-(CASE WHEN @P_COMMN_C<>0 Then @P_COMMN_C ELSE RPART.COMMN END))/100<(100-(CASE WHEN @P_COMM_C<>0 Then @P_COMM_C WHEN RPART.COMM<>0 THEN RPART.COMM ELSE @P_COMM END))/100) Then 1 else 1 end) end)-(Case When @P_RITabarruF=1 Then 1 Else 0 end)*(ICALC.GROSS*PCALC.PGROSS/PCALC.POGROSS*@P_OPFEEPCT/100)),0) AS GROSS_1,              
		coalesce(SUM((Case When @P_RateConF=1 Then (Case When RRateCon.Rate is null then RateCon.Rate*(Case When RateCon.Loading<>0 then RateCon.Loading/100 else RCover.Loading end) else RRateCon.Rate/PCalc.RiskNum*(Case When RRateCon.Loading<>0 then RRateCon.Loading/100 else RCover.Loading end) end) Else coalesce(@P_NETRATEDet,RPART.NETRATE/PCalc.RiskNum) end/100*(100-RCover.Discount)/100*ICALC.GROSS/PCALC.GROSS*ICALC.PRORATA *ICALC.TSI*(CASE WHEN RCOVER.PCALC='S' OR RCOVER.PCTLOSS=0 THEN 100 ELSE RCOVER.PCTLOSS END)/(CASE WHEN RCOVER.PCTLOSS=0 THEN 100 ELSE RCOVER.PCTLOSS END+RCOVER.PAddition)*ICALC.PCTADJ/100)*(Case When (CASE WHEN @P_COMMN_C<>0 Then @P_COMMN_C ELSE RPART.COMMN END)=0 Then 1 else (Case When RCover.NetRateF=1 or @P_ONGROSSNET=2 OR (@P_ONGROSSNET=0 AND (100-@Premium_OutGo)/100*(100-(CASE WHEN @P_COMMN_C<>0 Then @P_COMMN_C ELSE RPART.COMMN END))/100<(100-(CASE WHEN @P_COMM_C<>0 Then @P_COMM_C WHEN RPART.COMM<>0 THEN RPART.COMM ELSE @P_COMM END))/100) Then 1 else 1 end) end)-(Case When @P_RITabarruF=1 Then 1 Else 0 end)*(ICALC.GROSS*PCALC.PGROSS/PCALC.POGROSS*@P_OPFEEPCT/100)),0) AS GROSS_2,                
               
		coalesce(SUM((CASE WHEN RPART.PPCT<>0 THEN RPART.PPCT/100 ELSE (Case When @P_RateConF=1 and (RRateCon.Rate is not null or RateCon.Rate is not null) then 0 else 1 end) END * ICALC.GROSS*(PCALC.PGROSS*@P_PFactor)/PCALC.POGROSS*(100-@Premium_Treaty_Discount)/100-(ICALC.GROSS*PCALC.PGROSS/PCALC.POGROSS*@P_OPFEEPCT/100))*(Case When (CASE WHEN @P_COMMN_C<>0 Then @P_COMMN_C ELSE RPART.COMMN END)=0 Then 0 else (Case When RCover.NetRateF=1 or @P_ONGROSSNET=2 OR (@P_ONGROSSNET=0 AND (100-@Premium_OutGo)/100*(100-(CASE WHEN @P_COMMN_C<>0 Then @P_COMMN_C ELSE RPART.COMMN END))/100<(100-(CASE WHEN @P_COMM_C<>0 Then @P_COMM_C WHEN RPART.COMM<>0 THEN RPART.COMM ELSE @P_COMM END))/100) Then (@Premium_OutGo)/100 else 0 end) end)),0) AS DISC_1,                
		coalesce(SUM((Case When @P_RateConF=1 Then (Case When RRateCon.Rate is null then RateCon.Rate*(Case When RateCon.Loading<>0 then RateCon.Loading/100 else RCover.Loading end) else RRateCon.Rate/PCalc.RiskNum*(Case When RRateCon.Loading<>0 then RRateCon.Loading/100 else RCover.Loading end) end) Else coalesce(@P_NETRATEDet,RPART.NETRATE/PCalc.RiskNum) end/100*(100-RCover.Discount)/100*ICALC.GROSS/PCALC.GROSS*ICALC.PRORATA *ICALC.TSI*(CASE WHEN RCOVER.PCALC='S' OR RCOVER.PCTLOSS=0 THEN 100 ELSE RCOVER.PCTLOSS END)/(CASE WHEN RCOVER.PCTLOSS=0 THEN 100 ELSE RCOVER.PCTLOSS END+RCOVER.PAddition)*ICALC.PCTADJ/100-(ICALC.GROSS*PCALC.PGROSS/PCALC.POGROSS*@P_OPFEEPCT/100))*(Case When (CASE WHEN @P_COMMN_C<>0 Then @P_COMMN_C ELSE RPART.COMMN END)=0 Then 0 else (Case When RCover.NetRateF=1 or @P_ONGROSSNET=2 OR (@P_ONGROSSNET=0 AND (100-@Premium_OutGo)/100*(100-(CASE WHEN @P_COMMN_C<>0 Then @P_COMMN_C ELSE RPART.COMMN END))/100<(100-(CASE WHEN @P_COMM_C<>0 Then @P_COMM_C WHEN RPART.COMM<>0 THEN RPART.COMM ELSE @P_COMM END))/100) Then (@Premium_OutGo)/100 else 0 end) end)),0) AS DISC_2,    
  
		coalesce(SUM((CASE WHEN RPART.PPCT<>0 THEN RPART.PPCT/100 ELSE (Case When @P_RateConF=1 and (RRateCon.Rate is not null or RateCon.Rate is not null) then 0 else 1 end) END * ICALC.GROSS*(PCALC.PGROSS*@P_PFactor)/PCALC.POGROSS*(100-@Premium_Treaty_Discount)/100)*(Case When (CASE WHEN @P_COMMN_C<>0 Then @P_COMMN_C ELSE RPART.COMMN END)=0 Then 1 else (Case When RCover.NetRateF=1 or @P_ONGROSSNET=2 OR (@P_ONGROSSNET=0 AND (100-@Premium_OutGo)/100*(100-(CASE WHEN @P_COMMN_C<>0 Then @P_COMMN_C ELSE RPART.COMMN END))/100<(100-(CASE WHEN @P_COMM_C<>0 Then @P_COMM_C WHEN RPART.COMM<>0 THEN RPART.COMM ELSE @P_COMM END))/100) Then 1 else 1 end) end)*RPART.FEE/100-(Case When @P_RITabarruF=0 Then 1 Else 0 end)*(ICALC.GROSS*PCALC.PGROSS/PCALC.POGROSS*@P_OPFEEPCT/100)),0) AS FEE_1,                
		coalesce(SUM((Case When @P_RateConF=1 Then (Case When RRateCon.Rate is null then RateCon.Rate*(Case When RateCon.Loading<>0 then RateCon.Loading/100 else RCover.Loading end) else RRateCon.Rate/PCalc.RiskNum*(Case When RRateCon.Loading<>0 then RRateCon.Loading/100 else RCover.Loading end) end) Else coalesce(@P_NETRATEDet,RPART.NETRATE/PCalc.RiskNum) end/100*(100-RCover.Discount)/100*ICALC.GROSS/PCALC.GROSS*ICALC.PRORATA *ICALC.TSI*(CASE WHEN RCOVER.PCALC='S' OR RCOVER.PCTLOSS=0 THEN 100 ELSE RCOVER.PCTLOSS END)/(CASE WHEN RCOVER.PCTLOSS=0 THEN 100 ELSE RCOVER.PCTLOSS END+RCOVER.PAddition)*ICALC.PCTADJ/100)*(Case When (CASE WHEN @P_COMMN_C<>0 Then @P_COMMN_C ELSE RPART.COMMN END)=0 Then 1 else (Case When RCover.NetRateF=1 or @P_ONGROSSNET=2 OR (@P_ONGROSSNET=0 AND (100-@Premium_OutGo)/100*(100-(CASE WHEN @P_COMMN_C<>0 Then @P_COMMN_C ELSE RPART.COMMN END))/100<(100-(CASE WHEN @P_COMM_C<>0 Then @P_COMM_C WHEN RPART.COMM<>0 THEN RPART.COMM ELSE @P_COMM END))/100) Then 1 else 1 end) end)*RPART.FEE/100-(Case When @P_RITabarruF=0 Then 1 Else 0 end)*(ICALC.GROSS*PCALC.PGROSS/PCALC.POGROSS*@P_OPFEEPCT/100)),0) AS FEE_2    
                
		FROM ICALC     
		INNER JOIN ACCEPTANCE SACCEPTANCE ON (SACCEPTANCE.ANO=ICALC.SANO)    
		INNER JOIN RCOVER ON (RCOVER.ANO=ICALC.SANO AND RCOVER.CODE=ICALC.CODE AND (RCOVER.SDATE=ICALC.SDATE OR (@P_AType='A' AND (CASE WHEN RCOVER.SDATE<SACCEPTANCE.PDATE THEN SACCEPTANCE.PDATE ELSE RCOVER.SDATE END)=ICALC.SDATE)))    
		INNER JOIN RPART ON (RPART.RNO=@P_RNO and (@P_ID='' or RPart.ID=@P_ID) and (@P_DocNo='' or RPart.DocNo=@P_DocNo))
		LEFT JOIN RPARTDET ON (RPARTDET.RNO=RPART.RNO AND RPARTDET.ID=RPART.ID AND RPartDet.DocNo=RPART.DOCNO AND RPARTDET.TOR=ICALC.TOR)    
		LEFT Join FN_RateCon(@P_ANO, @P_CODE,@P_TSI,@P_ASDate) RateCon On (@P_RateConF=1 and RateCon.Code=ICalc.Code)    
		LEFT Join FN_RRateCon(@P_ANO, @P_RID, @P_TSI) RRateCon On (@P_RateConF=1)                
		INNER JOIN ICOVER ON (ICOVER.INO=ICALC.INO AND (ICOVER.ADJUSTABLE=@P_ADJUSTABLEF OR @P_AType='A'))    
		INNER JOIN RCALC ON (RCALC.ANO=ICALC.ANO AND RCALC.CURRENCY=ICALC.CURRENCY AND RCALC.CODE=ICALC.CODE AND RCALC.TOR=ICALC.TOR AND RCALC.SDATE=ICALC.SDATE AND RCALC.EDATE=ICALC.EDATE AND RCALC.SANO=ICALC.SANO AND RCALC.EXTREATYF=0)    
		INNER JOIN PCALC_ANNUM(@P_ANO) PCALC ON (PCALC.ANO=ICALC.ANO AND PCALC.CODE=ICALC.CODE AND PCALC.SDATE=ICALC.SDATE AND PCALC.EDATE=ICALC.EDATE AND PCALC.INO=ICALC.INO AND PCALC.CURRENCY=ICALC.CURRENCY)    
		WHERE ICALC.ANO=@P_ANO AND ICALC.CURRENCY=@P_CCY AND ICALC.SDATE=@P_SDATE AND ICALC.EDATE=@P_EDATE AND ICALC.CODE=@P_CODE                
		AND RPARTDET.TOR IS NULL AND PCALC.GROSS<>0    
		Group By RPart.ID, RPart.DocNo

		Union All              

		select              
		RPart.ID,
		RPart.DocNo,
		Max(PCalc.Rate) as Rate,
		Max(RPart.Share-RPart.JP) as Share,
		cast(Max(Cast(RPart.OnMinPremiumF as integer)) as Bit) as OnMinPremiumF,              

		coalesce(SUM((CASE WHEN RPARTDET.PPCT<>0 THEN RPARTDET.PPCT/100 ELSE (Case When @P_RateConF=1 and (RRateCon.Rate is not null or RateCon.Rate is not null) then 0 else 1 end) END * ICALC.GROSS*(PCALC.PGROSS*@P_PFactor)/PCALC.POGROSS-(ICALC.GROSS*PCALC.PGROSS/PCALC.POGROSS*@P_OPFEEPCT/100))*(100-@Premium_Treaty_Discount)/100*(Case When RPARTDET.COMMN=0 Then RPARTDET.COMM/100 else (Case When RCover.NetRateF=1 or @P_ONGROSSNET=2 OR (@P_ONGROSSNET=0 AND (100-@Premium_OutGo)/100*(100-RPARTDET.CommN)/100<(100-RPARTDET.COMM)/100) Then (100-@Premium_OutGo)/100*(RPARTDET.CommN)/100 else RPARTDET.COMM/100 end) end)),0) AS COMM_1,                
		coalesce(SUM((Case When @P_RateConF=1 Then (Case When RRateCon.Rate is null then RateCon.Rate*(Case When RateCon.Loading<>0 then RateCon.Loading/100 else RCover.Loading end) else RRateCon.Rate/PCalc.RiskNum*(Case When RRateCon.Loading<>0 then RRateCon.Loading/100 else RCover.Loading end) end) Else coalesce(@P_NETRATEDet,RPartDet.NetRate*datediff(day,@P_Sdate, @P_EDate)/datediff(day,@P_ASdate, @P_AEDate)) end/100*(100-RCover.Discount)/100*ICALC.GROSS/PCALC.GROSS*ICALC.PRORATA *ICALC.TSI*(CASE WHEN RCOVER.PCALC='S' OR RCOVER.PCTLOSS=0 THEN 100 ELSE RCOVER.PCTLOSS END)/(CASE WHEN RCOVER.PCTLOSS=0 THEN 100 ELSE RCOVER.PCTLOSS END+RCOVER.PAddition)*ICALC.PCTADJ/100-(ICALC.GROSS*PCALC.PGROSS/PCALC.POGROSS*@P_OPFEEPCT/100))*(Case When RPARTDET.COMMN=0 Then RPARTDET.COMM/100 else (Case When RCover.NetRateF=1 or @P_ONGROSSNET=2 OR (@P_ONGROSSNET=0 AND (100-@Premium_OutGo)/100*(100-RPARTDET.CommN)/100<(100-RPARTDET.COMM)/100) Then (100-@Premium_OutGo)/100*(RPARTDET.CommN)/100 else RPARTDET.COMM/100 end) end)),0) AS COMM_2,                    
                
		coalesce(SUM((CASE WHEN RPARTDET.PPCT<>0 THEN RPARTDET.PPCT/100 ELSE (Case When @P_RateConF=1 and (RRateCon.Rate is not null or RateCon.Rate is not null) then 0 else 1 end) END * ICALC.GROSS*(PCALC.PGROSS*@P_PFactor)/PCALC.POGROSS)*(100-@Premium_Treaty_Discount)/100*(Case When RPARTDET.COMMN=0 Then 1 else (Case When RCover.NetRateF=1 or @P_ONGROSSNET=2 OR (@P_ONGROSSNET=0 AND (100-@Premium_OutGo)/100*(100-RPARTDET.CommN)/100<(100-RPARTDET.COMM)/100) Then 1 else 1 end) end)-(Case When @P_RITabarruF=1 Then 1 Else 0 end)*(ICALC.GROSS*PCALC.PGROSS/PCALC.POGROSS*@P_OPFEEPCT/100)),0) AS GROSS_1,                
		coalesce(SUM((Case When @P_RateConF=1 Then (Case When RRateCon.Rate is null then RateCon.Rate*(Case When RateCon.Loading<>0 then RateCon.Loading/100 else RCover.Loading end) else RRateCon.Rate/PCalc.RiskNum*(Case When RRateCon.Loading<>0 then RRateCon.Loading/100 else RCover.Loading end) end) Else coalesce(@P_NETRATEDet,RPartDet.NetRate*datediff(day,@P_Sdate, @P_EDate)/datediff(day,@P_ASdate, @P_AEDate)) end/100*(100-RCover.Discount)/100*ICALC.GROSS/PCALC.GROSS*ICALC.PRORATA *ICALC.TSI*(CASE WHEN RCOVER.PCALC='S' OR RCOVER.PCTLOSS=0 THEN 100 ELSE RCOVER.PCTLOSS END)/(CASE WHEN RCOVER.PCTLOSS=0 THEN 100 ELSE RCOVER.PCTLOSS END+RCOVER.PAddition)*ICALC.PCTADJ/100)*(Case When RPARTDET.COMMN=0 Then 1 else (Case When RCover.NetRateF=1 or @P_ONGROSSNET=2 OR (@P_ONGROSSNET=0 AND (100-@Premium_OutGo)/100*(100-RPARTDET.CommN)/100<(100-RPARTDET.COMM)/100) Then 1 else 1 end) end)-(Case When @P_RITabarruF=1 Then 1 Else 0 end)*(ICALC.GROSS*PCALC.PGROSS/PCALC.POGROSS*@P_OPFEEPCT/100)),0) AS GROSS_2,                
  
		coalesce(SUM((CASE WHEN RPARTDET.PPCT<>0 THEN RPARTDET.PPCT/100 ELSE (Case When @P_RateConF=1 and (RRateCon.Rate is not null or RateCon.Rate is not null) then 0 else 1 end) END * ICALC.GROSS*(PCALC.PGROSS*@P_PFactor)/PCALC.POGROSS-(ICALC.GROSS*PCALC.PGROSS/PCALC.POGROSS*@P_OPFEEPCT/100))*(100-@Premium_Treaty_Discount)/100*(Case When RPARTDET.COMMN=0 Then 0 else (Case When RCover.NetRateF=1 or @P_ONGROSSNET=2 OR (@P_ONGROSSNET=0 AND (100-@Premium_OutGo)/100*(100-RPARTDET.CommN)/100<(100-RPARTDET.COMM)/100) Then (@Premium_OutGo)/100 else 0 end) end)),0) AS DISC_1,                
		coalesce(SUM((Case When @P_RateConF=1 Then (Case When RRateCon.Rate is null then RateCon.Rate*(Case When RateCon.Loading<>0 then RateCon.Loading/100 else RCover.Loading end) else RRateCon.Rate/PCalc.RiskNum*(Case When RRateCon.Loading<>0 then RRateCon.Loading/100 else RCover.Loading end) end) Else coalesce(@P_NETRATEDet,RPartDet.NetRate*datediff(day,@P_Sdate, @P_EDate)/datediff(day,@P_ASdate, @P_AEDate)) end/100*(100-RCover.Discount)/100*ICALC.GROSS/PCALC.GROSS*ICALC.PRORATA *ICALC.TSI*(CASE WHEN RCOVER.PCALC='S' OR RCOVER.PCTLOSS=0 THEN 100 ELSE RCOVER.PCTLOSS END)/(CASE WHEN RCOVER.PCTLOSS=0 THEN 100 ELSE RCOVER.PCTLOSS END+RCOVER.PAddition)*ICALC.PCTADJ/100-(ICALC.GROSS*PCALC.PGROSS/PCALC.POGROSS*@P_OPFEEPCT/100))*(Case When RPARTDET.COMMN=0 Then 0 else (Case When RCover.NetRateF=1 or @P_ONGROSSNET=2 OR (@P_ONGROSSNET=0 AND (100-@Premium_OutGo)/100*(100-RPARTDET.CommN)/100<(100-RPARTDET.COMM)/100) Then (@Premium_OutGo)/100 else 0 end) end)),0) AS DISC_2,                    
  
		coalesce(SUM((CASE WHEN RPARTDET.PPCT<>0 THEN RPARTDET.PPCT/100 ELSE (Case When @P_RateConF=1 and (RRateCon.Rate is not null or RateCon.Rate is not null) then 0 else 1 end) END * ICALC.GROSS*(PCALC.PGROSS*@P_PFactor)/PCALC.POGROSS)*(100-@Premium_Treaty_Discount)/100*(Case When RPARTDET.COMMN=0 Then 1 else (Case When RCover.NetRateF=1 or @P_ONGROSSNET=2 OR (@P_ONGROSSNET=0 AND (100-@Premium_OutGo)/100*(100-RPARTDET.CommN)/100<(100-RPARTDET.COMM)/100) Then 1 else 1 end) end)*RPART.FEE/100-(Case When @P_RITabarruF=0 Then 1 Else 0 end)*(ICALC.GROSS*PCALC.PGROSS/PCALC.POGROSS*@P_OPFEEPCT/100)),0) AS FEE_1,                
		coalesce(SUM((Case When @P_RateConF=1 Then (Case When RRateCon.Rate is null then RateCon.Rate*(Case When RateCon.Loading<>0 then RateCon.Loading/100 else RCover.Loading end) else RRateCon.Rate/PCalc.RiskNum*(Case When RRateCon.Loading<>0 then RRateCon.Loading/100 else RCover.Loading end) end) Else coalesce(@P_NETRATEDet,RPartDet.NetRate*datediff(day,@P_Sdate, @P_EDate)/datediff(day,@P_ASdate, @P_AEDate)) end/100*(100-RCover.Discount)/100*ICALC.GROSS/PCALC.GROSS*ICALC.PRORATA *ICALC.TSI*(CASE WHEN RCOVER.PCALC='S' OR RCOVER.PCTLOSS=0 THEN 100 ELSE RCOVER.PCTLOSS END)/(CASE WHEN RCOVER.PCTLOSS=0 THEN 100 ELSE RCOVER.PCTLOSS END+RCOVER.PAddition)*ICALC.PCTADJ/100)*(Case When RPARTDET.COMMN=0 Then 1 else (Case When RCover.NetRateF=1 or @P_ONGROSSNET=2 OR (@P_ONGROSSNET=0 AND (100-@Premium_OutGo)/100*(100-RPARTDET.CommN)/100<(100-RPARTDET.COMM)/100) Then 1 else 1 end) end)*RPART.FEE/100-(Case When @P_RITabarruF=0 Then 1 Else 0 end)*(ICALC.GROSS*PCALC.PGROSS/PCALC.POGROSS*@P_OPFEEPCT/100)),0) AS FEE_2    
  
		FROM ICALC     
		INNER JOIN ACCEPTANCE SACCEPTANCE ON (SACCEPTANCE.ANO=ICALC.SANO)    
		INNER JOIN RCOVER ON (RCOVER.ANO=ICALC.SANO AND RCOVER.CODE=ICALC.CODE AND (RCOVER.SDATE=ICALC.SDATE OR (@P_AType='A' AND (CASE WHEN RCOVER.SDATE<SACCEPTANCE.PDATE THEN SACCEPTANCE.PDATE ELSE RCOVER.SDATE END)=ICALC.SDATE)))    
		INNER JOIN RPART ON (RPART.RNO=@P_RNO and (@P_ID='' or RPart.ID=@P_ID) and (@P_DocNo='' or RPart.DocNo=@P_DocNo))
		INNER JOIN RPARTDET ON (RPARTDET.RNO=RPART.RNO AND RPARTDET.ID=RPART.ID AND RPARTDET.DocNo=RPART.DOCNO AND RPARTDET.TOR=ICALC.TOR AND (RPARTDET.NOFYEARS=0 OR RPARTDET.NOFYEARS=@P_NOFYEARS) and RPARTDET.EXCLUDEF=0)    
		LEFT Join FN_RateCon(@P_ANO, @P_CODE,@P_TSI,@P_ASDate) RateCon On (@P_RateConF=1 and RateCon.Code=ICalc.Code)    
		LEFT Join FN_RRateCon(@P_ANO, @P_RID, @P_TSI) RRateCon On (@P_RateConF=1)                
		INNER JOIN ICOVER ON (ICOVER.INO=ICALC.INO AND (ICOVER.ADJUSTABLE=@P_ADJUSTABLEF OR @P_AType='A'))    
		INNER JOIN RCALC ON (RCALC.ANO=ICALC.ANO AND RCALC.CURRENCY=ICALC.CURRENCY AND RCALC.CODE=ICALC.CODE AND RCALC.TOR=ICALC.TOR AND RCALC.SDATE=ICALC.SDATE AND RCALC.EDATE=ICALC.EDATE AND RCALC.SANO=ICALC.SANO AND RCALC.EXTREATYF=0)    
		INNER JOIN PCALC_ANNUM(@P_ANO) PCALC ON (PCALC.ANO=ICALC.ANO AND PCALC.CODE=ICALC.CODE AND PCALC.SDATE=ICALC.SDATE AND PCALC.EDATE=ICALC.EDATE AND PCALC.INO=ICALC.INO AND PCALC.CURRENCY=ICALC.CURRENCY)    
		WHERE ICALC.ANO=@P_ANO AND ICALC.CURRENCY=@P_CCY AND ICALC.SDATE=@P_SDATE AND ICALC.EDATE=@P_EDATE AND ICALC.CODE=@P_CODE                
		AND PCALC.GROSS<>0    
		Group By RPart.ID, RPart.DocNo
	) R 
	Group By R.ID, R.DocNo
) R

GO

DROP Procedure TreatyReallocation_Process
GO
Create Procedure TreatyReallocation_Process(@P_dbUser as varchar(50), @P_ADate as smalldatetime, @P_PDate as smalldatetime, @P_TOC as varchar(10), @P_Branch as varchar(10))
as
Declare @P_ALLOWQRYALLBRANCH as Bit
Declare @P_ALLOWQRYALLTOC as Bit

Select 
@P_ALLOWQRYALLBRANCH=case When Type='SUPERVISOR' Then cast(1 as Bit) else dbo.GetPrivileges(SysUser.ID, 'ALLOWQRYALLBRANCH') end,
@P_ALLOWQRYALLTOC=case When Type='SUPERVISOR' Then cast(1 as Bit) else dbo.GetPrivileges(SysUser.ID, 'ALLOWQRYALLTOC') end
from sysuser 
where ID=@P_dbUser

Select A1.EMethod, A1.AUserID, A1.PolicyNo, A1.CertificateNo, A1.Branch, 
Case When A1.BackDatedF=1 and datediff(day, @P_ADate, Branch.BackdatedDate)>=0 Then 1 else 0 end as BackDatedF, 
A1.TOC, C1.OpenFlag, A1.RANO, A1.ANO, A1.LANO, A1.AStatus, A1.AType, 
Case When R1.NRDate<A1.EDate and R1.NRDate<=@P_PDate Then R1.NRDate Else A1.PDate end as PDate,
A1.RefNo, A1.RefDate, A1.ADate
from RArrHeader R1 
Inner Join Acceptance A1 on (A1.ANO=R1.ANO)
Inner Join Cover C1 on (C1.CNO=A1.CNO)
Inner Join TOC on (TOC.TOC=A1.TOC)
Inner Join Branch on (Branch.Branch=A1.Branch)
Left Join Acceptance A2 on (A2.AType<>'A' and A2.PANO<>-1 and A2.ANO=A2.LANO and A2.PANO=A1.LANO)
Left Join Acceptance A3 on (A3.AType<>'A' and A3.PANO<>-1 and A3.ANO<>A3.LANO and A3.PANO=A1.ANO)
OUTER APPLY (Select Top 1 C2.CNO from Claim C1 Inner Join CLLoss C2 on (C2.CNO=C1.CNO) Where C1.ANO=A1.ANO and C1.CType<>'C' and (C1.CSTATUS IN ('P','T','A') OR C1.PCSTATUS IN ('A')) and not exists (Select pCNO from Claim Where Claim.pCNO=C1.CNO and Claim
.CStatus<>'R') and C2.CTLF=1) CTL
Where C1.CStatus<>'C' and A1.AType not in ('A','C') and A1.AStatus='I' and A1.ISType<>'T'
--Exclude Claim Total Loss
and coalesce(CTL.CNO,0)=0
and A2.ANO IS NULL and A3.ANO IS NULL
and 
(
-- Anniversary Policy Cession
(A1.AnnualTreatyF=1 and R1.NRDate<A1.EDate and R1.NRDate<=@P_PDate)
or 
--- Clean Cut
(R1.PPDate<R1.NRDate and R1.PPDate<=@P_PDate)
)
and A1.TOC Like @P_TOC+'%' and A1.Branch Like @P_Branch+'%'
and (@P_ALLOWQRYALLBRANCH=1 or Exists (Select TOP 1 S.ID from SysUserBranch S Where S.AllowedF=1 and S.Branch=A1.Branch and S.ID=@P_dbUser))
and (@P_ALLOWQRYALLTOC=1 or Exists (Select TOP 1 S.ID from SysUserTOC S Where S.TOC=A1.TOC and S.ID=@P_dbUser and S.Effective<=@P_PDate))
Order by A1.Branch, A1.LANO, A1.ANO

GO
DROP PROCEDURE View04
GO
CREATE PROCEDURE View04(@P_ANO as integer)       
AS      
SELECT R.*, TOC.REGID, A.AnnualTreatyF, A.NoRiskAccumulationF, A.FLDID, A.ValueID, C.OpenFlag, A.TOC, A.PolicyNo, A.CertificateNo, A.RegNo, C.CoverNo, A.ISType, A.RANO, A.AType, A.AStatus, A.SDate, A.EDate, MA.SDate as M_SDate, MA.EDate as M_EDate
FROM Acceptance A
Inner Join Cover C on (C.CNO=A.CNO)
Inner Join TOC on (TOC.TOC=A.TOC)
Inner Join RArrHeader R on (R.ANO=A.ANO)
Left Join ACCEPTANCE MA on (MA.ANO=A.LANO)
WHERE A.ANO=@P_ANO 

GO
DROP PROCEDURE View05L1
GO
CREATE PROCEDURE View05L1 (@p_ANO as integer)    
AS    

Declare @PremiumCalc Table(Currency varchar(10), Rate float, TSI Float, OurShare Float, Gross Float, CRate Float, Premium FLoat, Discount FLoat, Commission FLoat, VAT Float, TAX FLoat, FeeDuty Float)
Declare @ANO as int
Declare @LANO as int
Declare @RegNo as varchar(50)
Declare @OpenFlag as Bit
Declare @AStatus as varchar(1)
Declare @AType as varchar(1)
Declare @ASource as varchar(10)

Select @ANO=Acceptance.ANO, @LANO=Acceptance.LANO, @RegNo=Acceptance.RegNo, @OpenFlag=Cover.OpenFlag, @AStatus=Acceptance.AStatus, @AType=Acceptance.AType, @ASource=Cover.ASource
from Acceptance 
Inner Join Cover on (Cover.CNO=Acceptance.CNO)
Where Acceptance.ANO=@P_ANO

if @ANO<>@LANO or @OpenFlag=1
Begin
	insert into @PremiumCalc

	SELECT P2.Currency, max(coalesce(P1.Rate,0)) as Rate, max(coalesce(P1.TSI,0)) as TSI, max(coalesce(P1.OurShare,0)) as OurShare, Max(coalesce(P1.Gross,0)) as Gross, max(coalesce(P1.CRate,0)) as CRate, sum(P2.Premium) as Premium, sum(P2.Discount) as Discount, sum(P2.Commission) as Commission, sum(P2.Vat) as Vat, sum(P2.Tax) as Tax, sum(P2.FeeDuty) as FeeDuty   
	FROM PREMIUM_CALCULATION(@P_ANO) P2 
	Left Join PCalc P1 On (P2.ANO=P1.ANO and P2.Currency=P1.Currency)    
	Group By P2.Currency    
                     
	Union All          

	Select AccFD.Currency, 0 as Rate, 0 as TSI, 0 as OurShare, 0 as Gross, 0 as CRate, 0 as Premium, 0 as Discount, 0 as Commission, 0 as Vat, 0 as Tax, 
	Case 
	When FDTab.FDType<>'O' Then (ACCFD.Amount)
	Else -(ACCFD.Amount) End as FeeDuty
	from AccFD
	Inner Join FDTAB on (FDTab.FDID=AccFD.FDID)
	Where AccFD.ANO=@P_ANO and AccFD.Amount<>0

	Union All

	Select AccFD.Currency, 0 as Rate, 0 as TSI, 0 as OurShare, 0 as Gross, 0 as CRate, 0 as Premium, 0 as Discount, 0 as Commission, 0 as Vat, 0 as Tax, 
	sum(
		Case 
		When Left(FDTAB.FDType,1)<>'O' Then 
			Case 
			When AccFd.AMOUNTPCTBASED<>3 then
				D1.Gross*D1.Prorata*P.Gross/P.OGross*P.OurShare/P.TSI*(100-D1.Discount)/100
			else
				D1.Gross*D1.Prorata*P.Gross/P.OGross*P.OurShare/P.TSI*(100-D1.Discount-D1.Commission)/100
			End
		Else
			Case 
			When AccFd.AMOUNTPCTBASED<>3 then
				-D1.Gross*D1.Prorata*P.Gross/P.OGross*P.OurShare/P.TSI
			else
				-D1.Gross*D1.Prorata*P.Gross/P.OGross*P.OurShare/P.TSI*(100-D1.Discount-D1.Commission)/100
			End
		End*AccFD.AmountPCT/100
	) as FeeDuty
	from Display_Calculation(@P_ANO) D1
	Inner join RarrHeader R on (R.ANO=D1.ANO)
	Inner join PCalc P on (P.ANO=D1.ANO and P.Currency=D1.Currency)
	Inner Join AccFD on (AccFD.ANO=@P_ANO and AccFD.Currency=D1.Currency)
	Inner Join FDTAB ON (FDTab.FDID=AccFD.FDID)
	Where  AccFD.Amount=0 and AccFd.AMOUNTPCTBASED in (0,3)
	Group by ACCFD.Currency

	Union All

	Select AccFD.Currency, 0 as Rate, 0 as TSI, 0 as OurShare, 0 as Gross, 0 as CRate, 0 as Premium, 0 as Discount, 0 as Commission, 0 as Vat, 0 as Tax, 
	sum(
		Case 
		When Left(FDTab.FDType,1)<>'O' Then 
			coalesce(P.OurShare,0)-coalesce(PP.OurShare,0)
		Else
			-coalesce(P.OurShare,0)-coalesce(PP.OurShare,0)
		End*AccFD.AmountPCT/100
	) as FeeDuty
	from 
	AccFD
	Inner Join FDTab on (FDTAB.FDID=AccFD.FDID)
	Inner Join Acceptance A on (A.ANO=AccFD.ANO)
	Left Join Acceptance PA on (PA.ANO=A.PANO)
	Left Join PCalc P on (P.ANO=A.ANO and P.Currency=AccFD.Currency and A.AType Not in ('A','C'))
	Left Join RArrHeader R on (R.ANO=A.ANO and A.AType Not in ('A','C'))
	Left Join PCalc PP on (PP.ANO=A.PANO and PP.Currency=P.Currency and PA.AType Not in ('A','C'))
	Left Join RArrHeader PR on (PR.ANO=A.PANO and PA.AType Not in ('A','C'))	
	Where AccFD.ANO=@P_ANO
	and AccFD.Amount=0 and AccFd.AMOUNTPCTBASED Not in (0,3)
	Group by ACCFD.Currency

End
else
Begin
	Declare @Acceptance Table (ANO Int, PANO Int, AType varchar(1))
	if @RegNo='' or @AStatus in ('W','T') or (@ASource='MKT' and @AType='N')
	Begin
		insert into @Acceptance
		Select ANO, PANO, AType from Acceptance A Where A.LANO=@ANO 
	End
	Else
	Begin
		insert into @Acceptance
		Select ANO, PANO, AType from Acceptance A Where A.RegNo=@RegNo 
	End

	insert into @PremiumCalc
	Select P.*
	from @Acceptance A
	Cross Apply
	(
		SELECT P2.Currency, max(coalesce(P1.Rate,0)) as Rate, max(coalesce(P1.TSI,0)) as TSI, max(coalesce(P1.OurShare,0)) as OurShare, Max(coalesce(P1.Gross,0)) as Gross, max(coalesce(P1.CRate,0)) as CRate, sum(P2.Premium) as Premium, sum(P2.Discount) as Discount, sum(P2.Commission) as Commission, sum(P2.Vat) as Vat, sum(P2.Tax) as Tax, sum(P2.FeeDuty) as FeeDuty   
		FROM PREMIUM_CALCULATION(A.ANO) P2 
		Left Join PCalc P1 On (P2.ANO=P1.ANO and P2.Currency=P1.Currency)    
		Group By P2.Currency    
                     
		Union All          

		Select AccFD.Currency, 0 as Rate, 0 as TSI, 0 as OurShare, 0 as Gross, 0 as CRate, 0 as Premium, 0 as Discount, 0 as Commission, 0 as Vat, 0 as Tax, 
		Case 
		When FDTab.FDType<>'O' Then (ACCFD.Amount)
		Else -(ACCFD.Amount) End as FeeDuty
		from AccFD
		Inner Join FDTAB on (FDTab.FDID=AccFD.FDID)
		Where AccFD.ANO=A.ANO and AccFD.Amount<>0

		Union All

		Select AccFD.Currency, 0 as Rate, 0 as TSI, 0 as OurShare, 0 as Gross, 0 as CRate, 0 as Premium, 0 as Discount, 0 as Commission, 0 as Vat, 0 as Tax, 
		sum(
			Case 
			When Left(FDTAB.FDType,1)<>'O' Then 
				Case 
				When AccFd.AMOUNTPCTBASED<>3 then
					D1.Gross*D1.Prorata*P.Gross/P.OGross*P.OurShare/P.TSI*(100-D1.Discount)/100
				else
					D1.Gross*D1.Prorata*P.Gross/P.OGross*P.OurShare/P.TSI*(100-D1.Discount-D1.Commission)/100
				End
			Else
				Case 
				When AccFd.AMOUNTPCTBASED<>3 then
					-D1.Gross*D1.Prorata*P.Gross/P.OGross*P.OurShare/P.TSI
				else
					-D1.Gross*D1.Prorata*P.Gross/P.OGross*P.OurShare/P.TSI*(100-D1.Discount-D1.Commission)/100
				End
			End*AccFD.AmountPCT/100
		) as FeeDuty
		from Display_Calculation(A.ANO) D1
		Inner join RarrHeader R on (R.ANO=D1.ANO)
		Inner join PCalc P on (P.ANO=D1.ANO and P.Currency=D1.Currency)
		Inner Join AccFD on ((AccFD.ANO=A.ANO or AccFD.ANO=@LANO) and AccFD.Currency=D1.Currency)
		Inner Join FDTAB ON (FDTab.FDID=AccFD.FDID)
		Where  AccFD.Amount=0 and AccFd.AMOUNTPCTBASED in (0,3)
		Group by ACCFD.Currency

		Union All

		Select AccFD.Currency, 0 as Rate, 0 as TSI, 0 as OurShare, 0 as Gross, 0 as CRate, 0 as Premium, 0 as Discount, 0 as Commission, 0 as Vat, 0 as Tax, 
		sum(
			Case 
			When Left(FDTab.FDType,1)<>'O' Then 
				coalesce(P.OurShare,0)-coalesce(PP.OurShare,0)
			Else
				-coalesce(P.OurShare,0)-coalesce(PP.OurShare,0)
			End*AccFD.AmountPCT/100
		) as FeeDuty
		from 
		AccFD
		Inner Join FDTab on (FDTAB.FDID=AccFD.FDID)
		Left Join Acceptance PA on (PA.ANO=A.PANO)
		Left Join PCalc P on (P.ANO=A.ANO and P.Currency=AccFD.Currency and A.AType Not in ('A','C'))
		Left Join RArrHeader R on (R.ANO=A.ANO and A.AType Not in ('A','C'))
		Left Join PCalc PP on (PP.ANO=A.PANO and PP.Currency=P.Currency and PA.AType Not in ('A','C'))
		Left Join RArrHeader PR on (PR.ANO=A.PANO and PA.AType Not in ('A','C'))	
		Where AccFD.ANO=A.ANO
		and AccFD.Amount=0 and AccFd.AMOUNTPCTBASED Not in (0,3)
		Group by ACCFD.Currency
	) P	
end


Select @p_ANO ANO, Currency, Max(Rate) as Rate, sum(TSI) as TSI, sum(OurShare) as OurShare, sum(Gross) as Gross, Case When Sum(TSI)<>0 then Sum(Gross)/sum(TSI)*100 else 0 end as CRate, sum(Premium) as Premium, sum(Discount) as Discount, sum(Commission) as Commission, sum(Vat) as Vat, sum(Tax) as Tax, sum(FeeDuty) as FeeDuty    
from @PremiumCalc P
Group By Currency    
GO
DROP PROCEDURE View05L1_BY_RATECODE
GO
CREATE PROCEDURE View05L1_BY_RATECODE (@p_ANO as integer)    
AS    

Select ANO, Code, Currency, sum(Rate) as Rate, sum(TSI) as TSI, sum(OurShare) as OurShare, sum(Gross) as Gross, sum(Premium) as Premium, sum(Discount) as Discount, sum(Commission) as Commission, sum(Vat) as Vat, sum(Tax) as Tax, sum(FeeDuty) as FeeDuty   
       
From    
(    
SELECT @P_ANO as ANO, P2.Code, P2.Currency, max(coalesce(P1.Rate,0)) as Rate, max(coalesce(P1.TSI,0)) as TSI, max(coalesce(P1.OurShare,0)) as OurShare, Max(coalesce(P1.Gross,0)) as Gross, sum(P2.Premium) as Premium, sum(P2.Discount) as Discount, sum(P2.Commission) as Commission, sum(P2.Vat) as Vat, sum(P2.Tax) as Tax, sum(P2.FeeDuty) as FeeDuty   
FROM PREMIUM_CALCULATION_BY_RATECODE(@P_ANO) P2 
Left Join 
(Select R.ANO, R.Code, R.Currency, Max(R.TSI) as TSI, Max(P.Rate) as Rate, Max(R.TSI*P.Ourshare/P.TSI) as OurShare, sum(R.OGross/P.OGross*P.Gross) as Gross from RCalc R, PCalc P Where P.TSI<>0 and P.OGross<>0 and P.ANO=R.ANO and R.Currency=P.Currency Group By R.ANO, R.Code, R.Currency) P1 on (P2.ANO=P1.ANO and P2.Code=P1.Code and P2.Currency=P1.Currency)    
Group By P2.Code, P2.Currency    
) P    
Group By ANO, Code, Currency    
GO

DROP PROCEDURE View07A 
GO
CREATE PROCEDURE View07A (@P_ANO as integer)                
AS                
Declare @PolicyNo as varchar(50)
Declare @MRegNo as varchar(50)  
Declare @MSDate as smalldatetime  
Declare @MEDate as smalldatetime  
Declare @AStatus as varchar(1)  
Declare @AType as varchar(1)  
Declare @ASource as varchar(10)  
  
Select @PolicyNo=A.PolicyNo, @MRegNo=A.RegNo, @MSDate=A.SDate, @MEDate=A.EDate, @AStatus=A.AStatus, @AType=A.AType, @ASource=C.ASource 
from Acceptance A Inner Join Cover C on (C.CNO=A.CNO) Where A.ANO=@P_ANO 
  
Declare @View07 Table (ID varchar(10), Name varchar(255), Type varchar(10), Posted Bit, AdmNo Int, Currency varchar(10), RegNo varchar(50), DocNo varchar(50), RefNo varchar(50), Branch varchar(10), PolicyYear Int, Grace Int, Premium Float, Commision Float, OverridingCommission Float, Fee Float, Duty Float, Discount Float, Acquisition Float, PremiumAdjustment Float, OtherIncome Float, Ujroh Float, Tabarru Float, Deposit Float, ClaimReserve Float, Advance Float, Rounding Float, VAT Float, VATSubsidies Float, VAT_1 Float, VAT_2 Float, TAX Float, TAXSubsidies Float)  
  
if (@MRegNo='' or @AStatus in ('W','T') or (@ASource='MKT' and @AType='N'))  
Begin  
 insert into  @View07  
 SELECT AccAss.ID, Profile.Name, AccAss.Type, AccAss.Posted, AccAss.Admno, AccAss.Currency, Acceptance.RegNo, Accass.DocNo, AccAss.RefNo,        
 Case When AccAss.CAmount=0 and Coalesce(pAcceptance.Branch,'')<>'' Then pAcceptance.Branch Else Acceptance.Branch end Branch,     
 dbo.fn_Get_UWYear(@MSDate, @MEDate, Case When (Case When isnull(APayor.ANO,0)=0 Then (Case When isnull(MPayor.ANO,0)=0 Then Payor.PolicyYearF else MPayor.PolicyYearF end) else APayor.PolicyYearF end)=1 Then AccAss.SDate else Acceptance.SDate end) as PolicyYear,  
 (Case When isnull(APayor.ANO,0)=0 Then (Case When isnull(MPayor.ANO,0)=0 Then Payor.Grace else MPayor.Grace end) else APayor.Grace end) as Grace,  
 sum(                  
  case                  
   when (accass.type in ('IR','IT','IX') and accass.code in ('P','U','F')) or (accass.type in ('DI','IC') and accass.code in ('P','U')) or (AccAss.Type not in ('DI','IC','IR','IT','IX') and AccAss.Code='P') then AccAss.Amount                  
   else 0                  
  end                  
 )   
 +  
 sum(  
  Case   
   When Acceptance.NoRefundF=7 and AccAss.Type in ('BB','BA','BO','BC','BP','BD') and AccAss.Code in ('C') then AccAss.Amount   
   else 0   
  end  
 )   
 AS Premium,                   
 sum(                  
  case                   
   when accass.code='C' and coalesce(accass.codeext,'') in ('','V') then AccAss.Amount                  
   else 0                  
  end                  
 )   
 -  
 sum(  
  Case   
   When Acceptance.NoRefundF=7 and AccAss.Type in ('BB','BA','BO','BC','BP','BD') and AccAss.Code in ('C') then AccAss.Amount   
   else 0   
  end  
 )  
 AS Commision,                   
 sum(                  
  case                   
   when accass.code='C' and coalesce(accass.codeext,'')='1' then AccAss.Amount                  
   else 0                  
  end                  
 ) AS OverridingCommission,                   
 sum(                  
  case                   
   when accass.Type not in ('IR','IT','IX') and accass.code='F' then AccAss.Amount                  
   else 0                  
  end                  
 ) AS Fee,                   
 sum(                  
  case                   
   when accass.code='D' then AccAss.Amount                  
   else 0                  
  end                  
 ) AS Duty,                   
 sum(                  
  case                   
   when accass.type not in ('CP','DC','XP','QS','QP','S1','S2','S3','AF','FO','FP','FX') and accass.code='O' then AccAss.Amount                  
   else 0                  
  end                  
 ) AS Discount,                   
 sum(                  
  case                   
   when accass.type in ('CP','DC','XP','QS','QP','S1','S2','S3','AF','FO','FP','FX') and accass.code='O' and coalesce(accass.CodeExt,'')='' then AccAss.Amount                  
   else 0                  
  end                  
 ) AS Acquisition,     
 sum(                  
  case       
   when accass.type in ('CP','DC','XP','QS','QP','S1','S2','S3','AF','FO','FP','FX') and accass.code='O' and coalesce(accass.CodeExt,'')='1' then AccAss.Amount                  
   else 0                  
  end                  
 ) AS PremiumAdjustment,                                 
 sum(                  
  case                  
   when accass.code='I' then AccAss.Amount                  
   else 0                  
  end                  
 ) AS OtherIncome,                 
 sum(                  
  case                  
   when accass.type in ('IR','IT','IX') and accass.code='F' then -AccAss.Amount  
   when accass.Type in ('DI','IC') and accass.code='U' then -AccAss.Amount          
   when accass.Type Not in ('DI','IC') and accass.code='U' then AccAss.Amount          
   else 0   
  End         
 ) AS Ujroh,        
 sum(                  
  case                  
   when (accass.type in ('IR','IT','IX') and accass.code in ('P','U'))  or (accass.type in ('DI','IC') and accass.code in ('P')) or (AccAss.Type not in ('DI','IC','IR','IT','IX') and AccAss.Code in ('P','U')) then AccAss.Amount                  
   else 0                  
  end                  
 ) AS Tabarru,           
 sum(                  
  case                  
   when accass.type not in ('CP','DC','XP','QS','QP','S1','S2','S3','AF','FO','FP','FX') and accass.code='J' then AccAss.Amount                  
   else 0                  
  end                  
 ) AS Deposit,           
 sum(                  
  case                  
   when accass.type in ('IC','CF') and accass.code='G' then AccAss.Amount                  
   else 0                  
  end                  
 ) AS ClaimReserve,           
 sum(                  
  case                   
   when accass.type in ('CP','DC','XP','QS','QP','S1','S2','S3','AF','FO','FP','FX') and accass.code='J' then AccAss.Amount                  
   else 0                  
  end                  
 ) AS Advance,                    
 dbo.roundccy(sum(AccAss.Amount),AccAss.Currency) - sum(AccAss.Amount)as Rounding,   
 Case   
 When Max(Admlink.AdmNo) is null then  
  dbo.roundccy(  
  sum(  
  AccAss.Amount  
  *(Case  
	When SysTab.TaxMethod in (0,3) Then  
		Case When ((AccAss.Type in ('BB','BA','BC','BP','BD') and AccAss.Code in ('C','O')) or (AccAss.Type in ('OP','OR')) or (AccAss.Type in ('DI','IC','CF','JP','BO') and AccAss.Code in ('P','C','O','J','U')) or (AccAss.Type not in ('BB','BA','BC','BP','BD','OP','OP','DI','IC','CF','JP','BO') and AccAss.Code not in ('F','D'))) then 1 Else 0 End  
	When SysTab.TaxMethod in (4) Then  
		Case When ((AccAss.Type in ('BB','BA','BC','BP','BD') and AccAss.Code in ('C','O')) or (AccAss.Type in ('OP','OR')) or (AccAss.Type in ('DI','IC','CF','JP','BO') and AccAss.Code in ('P','C','D','O','J','U')) or (AccAss.Type not in ('BB','BA','BC','BP','BD','OP','OP','DI','IC','CF','JP','BO') and AccAss.Code not in ('F','D'))) then 1 Else 0 End  
	else  
		Case When ((AccAss.Type in ('CP','DC','QS','QP','S1','S2','S3','AF','XP','FO','FP','FX','IR','IT','IX') and AccAss.Code in ('C')) or (AccAss.Type in ('BB','BA','BC','BP','BD') and AccAss.Code in ('C','O')) or (AccAss.Type in ('OP','OR')) or (AccAss.Type not in ('CP','DC','QS','QP','S1','S2','S3','AF','XP','FO','FP','FX','IR','IT','IX','BB','BA','BC','BP','BD','OP','OR') and AccAss.Code not in ('F','D'))) then 1 Else 0 End     
	end)    
	*(Case   
	When SysTab.TaxMethod in (3) and ((AccAss.Type in ('BB','BA','BC','BP','BD'))) Then  
		case When RateTab.VATCommissionF=1 and (Case When Acceptance.ISType not in ('R','N','T','Q','S','A','X','P') or Profile.VATCOMMEXEMPTIF=0 Then cast(1 as Bit) Else 0 END)=1 then 1 else 0 end    	
	Else
		1
	End)
	*(Case   
	When SysTab.TaxMethod in (0,3,4) Then  
		Case When ((AccAss.Type in ('BB','BA','BC','BP','BD','OP','OR')) or ((AccAss.Type not in ('BB','BA','BC','BP','BD','OP','OR','DI','IC','CF','JP','BO') and TOC.VATBusinessF=1) or (Insured.VATF=1 and TOC.VATBusinessF=1))) Then 1 Else 0 End  
	Else  
		Case When ((AccAss.Type in ('BB','BA','BC','BP','BD','OP','OR')) or ((AccAss.Type not in ('BB','BA','BC','BP','BD','OP','OR','DI','IC','CF','JP','BO')) or (Insured.VATF=1 and TOC.VATBusinessF=1))) Then 1 Else 0 End  
	End)   
  *(Case When Profile.VatF=1 or AccAss.Type in ('DI','IC','CF','JP','BO') Then 1 else 0 end)  
  *(Case When Acceptance.NoRefundF=7 and AccAss.Type in ('BB','BA','BO','BC','BP','BD') and AccAss.Code in ('C','O') then 0 else 1 end)  
  *(Case When Acceptance.NoRefundF in (8,10,14) then 0 else 1 end)  
  )  
  ,Accass.Currency) 
  *(Max(MParam.VAT)/100)  
  +
  dbo.roundccy(sum(case When AccAss.Code='V' Then AccAss.Amount else 0 End),Accass.Currency)
 When Round(Max(coalesce((Admlink.Amount-Admlink.Amount_11-Admlink.Amount_12-(Admlink.Amount_8+Admlink.Amount_13+Admlink.Amount_17+Admlink.Amount_18)-Admlink.Amount_14),0)),2)<>0 then   
  sum((Admlink.Amount_13)*case When AccAss.Code<>'V' Then AccAss.Amount else 0 End)/Max(coalesce((Admlink.Amount-Admlink.Amount_11-Admlink.Amount_12-(Admlink.Amount_8+Admlink.Amount_13+Admlink.Amount_17+Admlink.Amount_18)-Admlink.Amount_14),0))  
 Else 
  sum(case When AccAss.Code='V' Then AccAss.Amount else 0 End)
 end  
 as VAT,          
 Case   
 When Max(Admlink.AdmNo) is null then  
  dbo.roundccy(  
  sum(  
  AccAss.Amount  
  *(Case  
	When SysTab.TaxMethod in (0,3) Then  
		Case When ((AccAss.Type in ('BB','BA','BC','BP','BD') and AccAss.Code in ('C','O')) or (AccAss.Type in ('OP','OR')) or (AccAss.Type in ('DI','IC','CF','JP','BO') and AccAss.Code in ('P','C','O','J','U')) or (AccAss.Type not in ('BB','BA','BC','BP','BD','OP','OP','DI','IC','CF','JP','BO') and AccAss.Code not in ('F','D'))) then 1 Else 0 End  
	When SysTab.TaxMethod in (4) Then  
		Case When ((AccAss.Type in ('BB','BA','BC','BP','BD') and AccAss.Code in ('C','O')) or (AccAss.Type in ('OP','OR')) or (AccAss.Type in ('DI','IC','CF','JP','BO') and AccAss.Code in ('P','C','D','O','J','U')) or (AccAss.Type not in ('BB','BA','BC','BP','BD','OP','OP','DI','IC','CF','JP','BO') and AccAss.Code not in ('F','D'))) then 1 Else 0 End  
	else  
		Case When ((AccAss.Type in ('CP','DC','QS','QP','S1','S2','S3','AF','XP','FO','FP','FX','IR','IT','IX') and AccAss.Code in ('C')) or (AccAss.Type in ('BB','BA','BC','BP','BD') and AccAss.Code in ('C','O')) or (AccAss.Type in ('OP','OR')) or (AccAss.Type not in ('CP','DC','QS','QP','S1','S2','S3','AF','XP','FO','FP','FX','IR','IT','IX','BB','BA','BC','BP','BD','OP','OR') and AccAss.Code not in ('F','D'))) then 1 Else 0 End     
	end)    
	*(Case   
	When SysTab.TaxMethod in (3) and ((AccAss.Type in ('BB','BA','BC','BP','BD'))) Then  
		case When RateTab.VATCommissionF=1 and (Case When Acceptance.ISType not in ('R','N','T','Q','S','A','X','P') or Profile.VATCOMMEXEMPTIF=0 Then cast(1 as Bit) Else 0 END)=1 then 1 else 0 end    	
	Else
		1
	End)
	*(Case   
	When SysTab.TaxMethod in (0,3,4) Then  
		Case When ((AccAss.Type in ('BB','BA','BC','BP','BD','OP','OR')) or ((AccAss.Type not in ('BB','BA','BC','BP','BD','OP','OR','DI','IC','CF','JP','BO') and TOC.VATBusinessF=1) or (Insured.VATF=1 and TOC.VATBusinessF=1))) Then 1 Else 0 End  
	Else  
		Case When ((AccAss.Type in ('BB','BA','BC','BP','BD','OP','OR')) or ((AccAss.Type not in ('BB','BA','BC','BP','BD','OP','OR','DI','IC','CF','JP','BO')) or (Insured.VATF=1 and TOC.VATBusinessF=1))) Then 1 Else 0 End  
	End)
  *(Case When Profile.VatF=1 or AccAss.Type in ('DI','IC','CF','JP','BO') Then 1 else 0 end)  
  *(Case When Acceptance.NoRefundF=7 and AccAss.Type in ('BB','BA','BO','BC','BP','BD') and AccAss.Code in ('C','O') then 0 else 1 end)  
  *(Case When Acceptance.NoRefundF in (8,10,14) then 0 else 1 end)  
  *(Case When SysTab.VATSubsidiesF=1 or Profile.VATSubsidiesF=1 then 1 else 0 end)  
  *(Case When Accass.Type in ('BB','BA') Then 1 else 0 end)
  )  
  ,Accass.Currency)  
  *Case When (Max(MParam.VAT)/100)<0 Then -(Max(MParam.VAT)/100) else 0 end  
 When Round(Max(coalesce((Admlink.Amount-Admlink.Amount_11-Admlink.Amount_12-(Admlink.Amount_8+Admlink.Amount_13+Admlink.Amount_17+Admlink.Amount_18)-Admlink.Amount_14),0)),2)<>0 then   
	Case 
	When round(Max(Admlink.Amount_13+Admlink.Amount_14),4)=round(Max(-Admlink.Amount_8),4) or round(Max(Admlink.Amount_13),4)=round(Max(-Admlink.Amount_8),4) then
		sum((-Admlink.Amount_13)*AccAss.Amount)/Max(coalesce((Admlink.Amount-Admlink.Amount_11-Admlink.Amount_12-(Admlink.Amount_8+Admlink.Amount_13+Admlink.Amount_17+Admlink.Amount_18)-Admlink.Amount_14),0))  
	else
	0
	end
 Else 0 end  
 as VATSubsidies,         
 Case   
 When Max(Admlink.AdmNo) is null then  
  dbo.roundccy(  
  sum(  
  AccAss.Amount  
  *(Case  
	When SysTab.TaxMethod in (0,3) Then  
		Case When ((AccAss.Type in ('BB','BA','BC','BP','BD') and AccAss.Code in ('C','O')) or (AccAss.Type in ('OP','OR')) or (AccAss.Type in ('DI','IC','CF','JP','BO') and AccAss.Code in ('P','C','O','J','U')) or (AccAss.Type not in ('BB','BA','BC','BP','BD','OP','OP','DI','IC','CF','JP','BO') and AccAss.Code not in ('F','D'))) then 1 Else 0 End  
	When SysTab.TaxMethod in (4) Then  
		Case When ((AccAss.Type in ('BB','BA','BC','BP','BD') and AccAss.Code in ('C','O')) or (AccAss.Type in ('OP','OR')) or (AccAss.Type in ('DI','IC','CF','JP','BO') and AccAss.Code in ('P','C','D','O','J','U')) or (AccAss.Type not in ('BB','BA','BC','BP','BD','OP','OP','DI','IC','CF','JP','BO') and AccAss.Code not in ('F','D'))) then 1 Else 0 End  
	else  
		Case When ((AccAss.Type in ('CP','DC','QS','QP','S1','S2','S3','AF','XP','FO','FP','FX','IR','IT','IX') and AccAss.Code in ('C')) or (AccAss.Type in ('BB','BA','BC','BP','BD') and AccAss.Code in ('C','O')) or (AccAss.Type in ('OP','OR')) or (AccAss.Type not in ('CP','DC','QS','QP','S1','S2','S3','AF','XP','FO','FP','FX','IR','IT','IX','BB','BA','BC','BP','BD','OP','OR') and AccAss.Code not in ('F','D'))) then 1 Else 0 End     
	end)    
	*(Case When Profile.BVatF=1 or AccAss.Type in ('DI','IC','CF','JP','BO') Then 1 else 0 end)  
    *(Case When Acceptance.NoRefundF<>11 and Acceptance.NoRefundF<>14 and AccAss.Type in ('DI','IC','CF','JP','BO') and Insured.BVatF=1 then 1 else 0 end)  
  )  
  ,Accass.Currency)  
  *Max((Case When coalesce(Acceptance.OverwriteBVatF,0)=0 Then Branch.VAT else coalesce(Acceptance.BVATPCT,0) end)/100)  
 When Round(Max(coalesce((Admlink.Amount-Admlink.Amount_11-Admlink.Amount_12-(Admlink.Amount_8+Admlink.Amount_13+Admlink.Amount_17+Admlink.Amount_18)-Admlink.Amount_14),0)),2)<>0 then   
  sum((Admlink.Amount_17)*AccAss.Amount)/Max(coalesce((Admlink.Amount-Admlink.Amount_11-Admlink.Amount_12-(Admlink.Amount_8+Admlink.Amount_13+Admlink.Amount_17+Admlink.Amount_18)-Admlink.Amount_14),0))  
 Else 0 end  
 as VAT_1,        
 Case   
 When Max(Admlink.AdmNo) is null then  
  Case when Max(AccAss.Type) in ('DI','IC','CF','JP','BO') Then    
   Case   
   When Max(SysTab.TaxMethod)=2 then  
    dbo.roundccy(  
    sum(  
    AccAss.Amount*Case When (AccAss.Type in ('DI','IC') and Accass.Code in ('P','O','U')) or (AccAss.Type in ('CF','JP') and AccAss.Code in ('P','O')) or (AccAss.Type in ('BO')) Then 1 else 0 end     
    *coalesce(RateCov.Portion,0)/coalesce(pRCover.Portion, RCover.Portion)  
	*(Case When Acceptance.NoRefundF<>11 and Acceptance.NoRefundF<>14 and AccAss.Type in ('DI','IC','CF','JP','BO') and Insured.TVatF=1 then 1 else 0 end)
    )  
    ,Accass.Currency)  
   When Max(SysTab.TaxMethod)=3 then  
    dbo.roundccy(  
    sum(  
    AccAss.Amount*Case When (AccAss.Type in ('DI','IC') and Accass.Code in ('P','O','U')) or (AccAss.Type in ('CF','JP') and AccAss.Code in ('P','O')) or (AccAss.Type in ('BO')) Then 1 else 0 end     
    *case When RateTab.VATF=1 and RateTab.VATEXEMPTF=0 then 1 else 0 end  
	*(Case When Acceptance.NoRefundF<>11 and Acceptance.NoRefundF<>14 and AccAss.Type in ('DI','IC','CF','JP','BO') and Insured.TVatF=1 then 1 else 0 end)
    )  
    ,Accass.Currency)  
   Else  
    dbo.roundccy(  
    sum(  
    AccAss.Amount  
	*(Case  
	When SysTab.TaxMethod in (0,3) Then  
		Case When ((AccAss.Type in ('BB','BA','BC','BP','BD') and AccAss.Code in ('C','O')) or (AccAss.Type in ('OP','OR')) or (AccAss.Type in ('DI','IC','CF','JP','BO') and AccAss.Code in ('P','C','O','J','U')) or (AccAss.Type not in ('BB','BA','BC','BP','BD','OP','OP','DI','IC','CF','JP','BO') and AccAss.Code not in ('F','D'))) then 1 Else 0 End  
	When SysTab.TaxMethod in (4) Then  
		Case When ((AccAss.Type in ('BB','BA','BC','BP','BD') and AccAss.Code in ('C','O')) or (AccAss.Type in ('OP','OR')) or (AccAss.Type in ('DI','IC','CF','JP','BO') and AccAss.Code in ('P','C','D','O','J','U')) or (AccAss.Type not in ('BB','BA','BC','BP','BD','OP','OP','DI','IC','CF','JP','BO') and AccAss.Code not in ('F','D'))) then 1 Else 0 End  
	else  
		Case When ((AccAss.Type in ('CP','DC','QS','QP','S1','S2','S3','AF','XP','FO','FP','FX','IR','IT','IX') and AccAss.Code in ('C')) or (AccAss.Type in ('BB','BA','BC','BP','BD') and AccAss.Code in ('C','O')) or (AccAss.Type in ('OP','OR')) or (AccAss.Type not in ('CP','DC','QS','QP','S1','S2','S3','AF','XP','FO','FP','FX','IR','IT','IX','BB','BA','BC','BP','BD','OP','OR') and AccAss.Code not in ('F','D'))) then 1 Else 0 End     
	end)    
	*(Case   
	When SysTab.TaxMethod in (3) and ((AccAss.Type in ('BB','BA','BC','BP','BD'))) Then  
		case When RateTab.VATCommissionF=1 and (Case When Acceptance.ISType not in ('R','N','T','Q','S','A','X','P') or Profile.VATCOMMEXEMPTIF=0 Then cast(1 as Bit) Else 0 END)=1 then 1 else 0 end    	
	Else
		1
	End)    
	*(Case When Profile.TVatF=1 or (AccAss.Type in ('DI','IC','CF','JP','BO')) Then 1 else 0 end)  
	*(Case When Acceptance.NoRefundF<>11 and Acceptance.NoRefundF<>14 and AccAss.Type in ('DI','IC','CF','JP','BO') and Insured.TVatF=1 then 1 else 0 end)
    )  
    ,Accass.Currency)  
   end  
  else  
   0  
  end      
  *Max((Case When coalesce(Acceptance.OverwriteTVatF,0)=0 Then TOC.VAT else coalesce(Acceptance.TVATPCT,0) end)/100)  
 When Round(Max(coalesce((Admlink.Amount-Admlink.Amount_11-Admlink.Amount_12-(Admlink.Amount_8+Admlink.Amount_13+Admlink.Amount_17+Admlink.Amount_18)-Admlink.Amount_14),0)),2)<>0 then   
  sum((Admlink.Amount_18)*AccAss.Amount)/Max(coalesce((Admlink.Amount-Admlink.Amount_11-Admlink.Amount_12-(Admlink.Amount_8+Admlink.Amount_13+Admlink.Amount_17+Admlink.Amount_18)-Admlink.Amount_14),0))  
 Else 0 end  
 as VAT_2,   
 Case    
 When Max(Admlink.AdmNo) is null then  
  dbo.Roundccy(  
  sum(  
  -(  
   Case   
   When charindex(AccAss.Type,'FOFPQSQPS1S2S3AF')<>0  then  
    Case   
    When TaxType.MTaxType in ('PASAL21','PASAL23','PASAL4') Then  
     Case When AccAss.Code<>'P' then 1 else 0 end      
    else  
     Case When AccAss.Code<>'C' then 1 else 0 end      
    end  
   Else  
    1  
   End  
   *AccAss.Amount  
   )  
  *(Case When Profile.TaxF=1 Then 1 Else 0 End)  
  *(Case   
   When TaxType.MTaxType='PASAL21' Then   
    Case When (Case When MParam.UseTaxTypeF=0 Then MParam.PASAL21 Else TaxType.TaxRate End)<>0 Then (Case When Profile.AccruedTax<>0 Then Profile.AccruedTax else (Case When MParam.UseTaxTypeF=0 Then MParam.PASAL21 Else TaxType.TaxRate End)*(100-MParam.TaxDiscount)/100 end) else 0 end/100  
   When TaxType.MTaxType='PASAL23' Then  
    Case When (Case When MParam.UseTaxTypeF=0 Then MParam.PASAL23 Else TaxType.TaxRate End)<>0 Then (Case When Profile.AccruedTax<>0 Then Profile.AccruedTax else (Case When MParam.UseTaxTypeF=0 Then MParam.PASAL23 Else TaxType.TaxRate End) end) else 0 end/100   
   When TaxType.MTaxType='PASAL26' Then   
    Case When (Case When MParam.UseTaxTypeF=0 Then MParam.PASAL26 Else TaxType.TaxRate End)<>0 Then (Case When Profile.AccruedTax<>0 Then Profile.AccruedTax else (Case When MParam.UseTaxTypeF=0 Then MParam.PASAL26 Else TaxType.TaxRate End) end) else 0 end/100  
   When TaxType.MTaxType='PASAL4' Then   
    Case When (Case When MParam.UseTaxTypeF=0 Then MParam.PASAL4 Else TaxType.TaxRate End)<>0 Then (Case When Profile.AccruedTax<>0 Then Profile.AccruedTax else (Case When MParam.UseTaxTypeF=0 Then MParam.PASAL4 Else TaxType.TaxRate End) end) else 0 end/100  
   ELSE Profile.AccruedTax/100  
    END)  
  *Case When coalesce(Profile.TaxPCT,0)=0 then 1 else Profile.TaxPCT/100 end  
  *(Case When Acceptance.NoRefundF=7 and AccAss.Type in ('BB','BA','BO','BC','BP','BD') and AccAss.Code in ('C') then 0 else 1 end)  
  *(Case When Acceptance.NoRefundF in (9,10) then 0 else 1 end)  
  ),AccAss.Currency)  
 When Round(Max(coalesce((Admlink.Amount-Admlink.Amount_11-Admlink.Amount_12-(Admlink.Amount_8+Admlink.Amount_13+Admlink.Amount_17+Admlink.Amount_18)-Admlink.Amount_14),0)),2)<>0 then   
  sum((Admlink.Amount_14)*AccAss.Amount)/Max(coalesce((Admlink.Amount-Admlink.Amount_11-Admlink.Amount_12-(Admlink.Amount_8+Admlink.Amount_13+Admlink.Amount_17+Admlink.Amount_18)-Admlink.Amount_14),0))  
 Else 0 end  
 as TAX,  
 Case    
 When Max(Admlink.AdmNo) is null then  
  dbo.Roundccy(  
  sum(  
  -(  
   Case   
   When charindex(AccAss.Type,'FOFPQSQPS1S2S3AF')<>0  then  
    Case   
    When TaxType.MTaxType in ('PASAL21','PASAL23','PASAL4') Then  
     Case When AccAss.Code<>'P' then 1 else 0 end      
    else  
     Case When AccAss.Code<>'C' then 1 else 0 end      
    end  
   Else  
    1  
   End  
   *AccAss.Amount  
   )  
  *(Case When Profile.TaxF=1 Then 1 Else 0 End)  
  *(Case   
   When TaxType.MTaxType='PASAL21' Then   
    Case When (Case When MParam.UseTaxTypeF=0 Then MParam.PASAL21 Else TaxType.TaxRate End)<>0 Then (Case When Profile.AccruedTax<>0 Then Profile.AccruedTax else (Case When MParam.UseTaxTypeF=0 Then MParam.PASAL21 Else TaxType.TaxRate End)*(100-MParam.TaxDiscount)/100 end) else 0 end/100  
   When TaxType.MTaxType='PASAL23' Then  
    Case When (Case When MParam.UseTaxTypeF=0 Then MParam.PASAL23 Else TaxType.TaxRate End)<>0 Then (Case When Profile.AccruedTax<>0 Then Profile.AccruedTax else (Case When MParam.UseTaxTypeF=0 Then MParam.PASAL23 Else TaxType.TaxRate End) end) else 0 end/100   
   When TaxType.MTaxType='PASAL26' Then   
    Case When (Case When MParam.UseTaxTypeF=0 Then MParam.PASAL26 Else TaxType.TaxRate End)<>0 Then (Case When Profile.AccruedTax<>0 Then Profile.AccruedTax else (Case When MParam.UseTaxTypeF=0 Then MParam.PASAL26 Else TaxType.TaxRate End) end) else 0 end/100  
   When TaxType.MTaxType='PASAL4' Then   
    Case When (Case When MParam.UseTaxTypeF=0 Then MParam.PASAL4 Else TaxType.TaxRate End)<>0 Then (Case When Profile.AccruedTax<>0 Then Profile.AccruedTax else (Case When MParam.UseTaxTypeF=0 Then MParam.PASAL4 Else TaxType.TaxRate End) end) else 0 end/100  
   ELSE Profile.AccruedTax/100  
    END)  
  *Case When coalesce(Profile.TaxPCT,0)=0 then 1 else Profile.TaxPCT/100 end  
  *(Case When Acceptance.NoRefundF=7 and AccAss.Type in ('BB','BA','BO','BC','BP','BD') and AccAss.Code in ('C') then 0 else 1 end)  
  *(Case When Acceptance.NoRefundF in (9,10) then 0 else 1 end)  
  *(Case When Profile.TAXSubsidiesF=1 then -1 else 0 end) 
  *(Case When Accass.Type in ('BB','BA') Then 1 else 0 end)
  ),AccAss.Currency)  
 When Round(Max(coalesce((Admlink.Amount-Admlink.Amount_11-Admlink.Amount_12-(Admlink.Amount_8+Admlink.Amount_13+Admlink.Amount_17+Admlink.Amount_18)-Admlink.Amount_14),0)),2)<>0 then   
	Case 
	When round(Max(Admlink.Amount_13+Admlink.Amount_14),4)=round(Max(-Admlink.Amount_8),4) or round(Max(Admlink.Amount_14),4)=round(Max(-Admlink.Amount_8),4) then
		sum((-Admlink.Amount_14)*AccAss.Amount)/Max(coalesce((Admlink.Amount-Admlink.Amount_11-Admlink.Amount_12-(Admlink.Amount_8+Admlink.Amount_13+Admlink.Amount_17+Admlink.Amount_18)-Admlink.Amount_14),0))  
	else
	0
	end
 Else 0 end  
 as TAXSubsidies
 FROM Acceptance   
 Inner Join Cover on (Cover.CNO=Acceptance.CNO)  
 Inner Join TOC on (TOC.TOC=Acceptance.TOC)  
 Inner Join Branch on (Branch.Branch=Acceptance.Branch)  
 Inner Join Profile Insured on (Insured.ID=Acceptance.AID)  
 Inner Join AccAss on (Acceptance.ANO=AccAss.ANO)  
 Left Join APayor on (APayor.ANO=Acceptance.ANO and Acceptance.LANO<>-1 and Acceptance.ANO<>Acceptance.LANO)                                
 Left Join Payor on (Payor.ANO=Acceptance.ANO and Acceptance.LANO=-1)                
 Left Join Acceptance pAcceptance on (pAcceptance.ANO=Acceptance.pANO)  
 Left Join Admlink on (Admlink.AdmNo=AccAss.AdmNo)  
 Inner Join Profile on (Profile.ID=AccAss.ID)  
 Left Join TaxType on (TaxType.TaxType=Profile.TaxType)  
 Inner Join Mparam on (MParam.Type=AccAss.Type)  
 Left Join Payor MPayor on (MPayor.ANO=@P_ANO)        
 Inner Join SysTab on (1=1)  
 Left Join RateTab on (RateTab.Code=AccAss.RCode)  
 Left Join RCover on (RCover.ANO=Acceptance.ANO and RCover.Code=AccAss.RCode and RCover.SDate=AccAss.SDate)  
 Left Join RCover pRCover on (AccAss.CAmount=0 and pRCover.ANO=Acceptance.pANO and pRCover.Code=AccAss.RCode and pRCover.SDate=AccAss.SDate)  
 Outer apply (Select sum(RateCov.Portion) as Portion from RateCov Where RateCov.Code=AccAss.RCode and RateCov.VatF=1) as RateCov  
 WHERE Acceptance.LANO=@P_ANO  
 GROUP BY AccAss.ID, Profile.Name, AccAss.Type, AccAss.Posted, AccAss.Admno, AccAss.Currency, Acceptance.RegNo, Accass.DocNo, AccAss.RefNo,        
 Case When AccAss.CAmount=0 and Coalesce(pAcceptance.Branch,'')<>'' Then pAcceptance.Branch Else Acceptance.Branch end,     
 dbo.fn_Get_UWYear(@MSDate, @MEDate, Case When (Case When isnull(APayor.ANO,0)=0 Then (Case When isnull(MPayor.ANO,0)=0 Then Payor.PolicyYearF else MPayor.PolicyYearF end) else APayor.PolicyYearF end)=1 Then AccAss.SDate else Acceptance.SDate end),  
 (Case When isnull(APayor.ANO,0)=0 Then (Case When isnull(MPayor.ANO,0)=0 Then Payor.Grace else MPayor.Grace end) else APayor.Grace end)  
END  
ELSE  
BEGIN  
 insert into  @View07  
 SELECT AccAss.ID, Profile.Name, AccAss.Type, AccAss.Posted, AccAss.Admno, AccAss.Currency, Acceptance.RegNo, Accass.DocNo, AccAss.RefNo,        
 Case When AccAss.CAmount=0 and Coalesce(pAcceptance.Branch,'')<>'' Then pAcceptance.Branch Else Acceptance.Branch end Branch,     
 dbo.fn_Get_UWYear(@MSDate, @MEDate, Case When (Case When isnull(APayor.ANO,0)=0 Then (Case When isnull(MPayor.ANO,0)=0 Then Payor.PolicyYearF else MPayor.PolicyYearF end) else APayor.PolicyYearF end)=1 Then AccAss.SDate else Acceptance.SDate end) as PolicyYear,  
 (Case When isnull(APayor.ANO,0)=0 Then (Case When isnull(MPayor.ANO,0)=0 Then Payor.Grace else MPayor.Grace end) else APayor.Grace end) as Grace,  
 sum(                  
  case                  
   when (accass.type in ('IR','IT','IX') and accass.code in ('P','U','F')) or (accass.type in ('DI','IC') and accass.code in ('P','U')) or (AccAss.Type not in ('DI','IC','IR','IT','IX') and AccAss.Code='P') then AccAss.Amount    
   else 0                  
  end                  
 )   
 +  
 sum(  
Case   
   When Acceptance.NoRefundF=7 and AccAss.Type in ('BB','BA','BO','BC','BP','BD') and AccAss.Code in ('C') then AccAss.Amount   
   else 0   
  end  
 )   
 AS Premium,                   
 sum(                  
  case        
when accass.code='C' and coalesce(accass.codeext,'') in ('','V') then AccAss.Amount                  
   else 0                  
  end                  
 )   
 -  
 sum(  
  Case   
   When Acceptance.NoRefundF=7 and AccAss.Type in ('BB','BA','BO','BC','BP','BD') and AccAss.Code in ('C') then AccAss.Amount   
   else 0   
  end  
 )   
 AS Commision,                   
 sum(                  
  case                   
   when accass.code='C' and coalesce(accass.codeext,'')='1' then AccAss.Amount                  
   else 0                  
  end                  
 ) AS OverridingCommission,                   
 sum(                  
  case              
   when accass.Type not in ('IR','IT','IX') and accass.code='F' then AccAss.Amount                  
   else 0                  
  end                  
 ) AS Fee,              
 sum(                  
  case                   
  when accass.code='D' then AccAss.Amount                  
   else 0                
  end                  
 ) AS Duty,                   
 sum(                  
  case                   
   when accass.type not in ('CP','DC','XP','QS','QP','S1','S2','S3','AF','FO','FP','FX') and accass.code='O' then AccAss.Amount                  
   else 0                  
  end                  
 ) AS Discount,                   
 sum(                  
  case                   
   when accass.type in ('CP','DC','XP','QS','QP','S1','S2','S3','AF','FO','FP','FX') and accass.code='O' and coalesce(accass.CodeExt,'')='' then AccAss.Amount                  
   else 0                  
  end                  
 ) AS Acquisition,     
 sum(                  
  case                   
   when accass.type in ('CP','DC','XP','QS','QP','S1','S2','S3','AF','FO','FP','FX') and accass.code='O' and coalesce(accass.CodeExt,'')='1' then AccAss.Amount                  
   else 0                  
  end                  
 ) AS PremiumAdjustment,                                 
 sum(                  
  case                  
   when accass.code='I' then AccAss.Amount                  
   else 0                  
  end                  
 ) AS OtherIncome,                 
 sum(                  
  case                  
   when accass.type in ('IR','IT','IX') and accass.code='F' then -AccAss.Amount  
   when accass.Type in ('DI','IC') and accass.code='U' then -AccAss.Amount          
   when accass.Type Not in ('DI','IC') and accass.code='U' then AccAss.Amount          
   else 0                  
  End      
 ) AS Ujroh,                
 sum(                  
  case                  
   when (accass.type in ('IR','IT','IX') and accass.code in ('P','U'))  or (accass.type in ('DI','IC') and accass.code in ('P')) or (AccAss.Type not in ('DI','IC','IR','IT','IX') and AccAss.Code in ('P','U')) then AccAss.Amount                  
   else 0                  
  end                  
 ) AS Tabarru,           
 sum(                  
  case                  
   when accass.type not in ('CP','DC','XP','QS','QP','S1','S2','S3','AF','FO','FP','FX') and accass.code='J' then AccAss.Amount                  
   else 0                  
  end                  
 ) AS Deposit,           
 sum(                  
  case                  
   when accass.type in ('IC','CF') and accass.code='G' then AccAss.Amount                  
   else 0                  
  end                  
 ) AS ClaimReserve,           
 sum(                  
  case                   
   when accass.type in ('CP','DC','XP','QS','QP','S1','S2','S3','AF','FO','FP','FX') and accass.code='J' then AccAss.Amount               
   else 0                  
  end                  
 ) AS Advance,                    
 dbo.roundccy(sum(AccAss.Amount),AccAss.Currency) - sum(AccAss.Amount)as Rounding,   
 Case   
 When Max(Admlink.AdmNo) is null then  
  dbo.roundccy(  
  sum(  
  AccAss.Amount  
  *(Case  
	When SysTab.TaxMethod in (0,3) Then  
		Case When ((AccAss.Type in ('BB','BA','BC','BP','BD') and AccAss.Code in ('C','O')) or (AccAss.Type in ('OP','OR')) or (AccAss.Type in ('DI','IC','CF','JP','BO') and AccAss.Code in ('P','C','O','J','U')) or (AccAss.Type not in ('BB','BA','BC','BP','BD','OP','OP','DI','IC','CF','JP','BO') and AccAss.Code not in ('F','D'))) then 1 Else 0 End  
	When SysTab.TaxMethod in (4) Then  
		Case When ((AccAss.Type in ('BB','BA','BC','BP','BD') and AccAss.Code in ('C','O')) or (AccAss.Type in ('OP','OR')) or (AccAss.Type in ('DI','IC','CF','JP','BO') and AccAss.Code in ('P','C','D','O','J','U')) or (AccAss.Type not in ('BB','BA','BC','BP','BD','OP','OP','DI','IC','CF','JP','BO') and AccAss.Code not in ('F','D'))) then 1 Else 0 End  
	else  
		Case When ((AccAss.Type in ('CP','DC','QS','QP','S1','S2','S3','AF','XP','FO','FP','FX','IR','IT','IX') and AccAss.Code in ('C')) or (AccAss.Type in ('BB','BA','BC','BP','BD') and AccAss.Code in ('C','O')) or (AccAss.Type in ('OP','OR')) or (AccAss.Type not in ('CP','DC','QS','QP','S1','S2','S3','AF','XP','FO','FP','FX','IR','IT','IX','BB','BA','BC','BP','BD','OP','OR') and AccAss.Code not in ('F','D'))) then 1 Else 0 End     
	end)    
	*(Case   
	When SysTab.TaxMethod in (3) and ((AccAss.Type in ('BB','BA','BC','BP','BD'))) Then  
		case When RateTab.VATCommissionF=1 and (Case When Acceptance.ISType not in ('R','N','T','Q','S','A','X','P') or Profile.VATCOMMEXEMPTIF=0 Then cast(1 as Bit) Else 0 END)=1 then 1 else 0 end    	
	Else
		1
	End)
	*(Case   
	When SysTab.TaxMethod in (0,3,4) Then  
		Case When ((AccAss.Type in ('BB','BA','BC','BP','BD','OP','OR')) or ((AccAss.Type not in ('BB','BA','BC','BP','BD','OP','OR','DI','IC','CF','JP','BO') and TOC.VATBusinessF=1) or (Insured.VATF=1 and TOC.VATBusinessF=1))) Then 1 Else 0 End  
	Else  
		Case When ((AccAss.Type in ('BB','BA','BC','BP','BD','OP','OR')) or ((AccAss.Type not in ('BB','BA','BC','BP','BD','OP','OR','DI','IC','CF','JP','BO')) or (Insured.VATF=1 and TOC.VATBusinessF=1))) Then 1 Else 0 End  
	End)   
  *(Case When Profile.VatF=1 or AccAss.Type in ('DI','IC','CF','JP','BO') Then 1 else 0 end)  
  *(Case When Acceptance.NoRefundF=7 and AccAss.Type in ('BB','BA','BO','BC','BP','BD') and AccAss.Code in ('C','O') then 0 else 1 end)  
  *(Case When Acceptance.NoRefundF in (8,10,14) then 0 else 1 end)  
  )  
  ,Accass.Currency)  
  *(Max(MParam.VAT)/100)  
  +
  dbo.roundccy(sum(case When AccAss.Code='V' Then AccAss.Amount else 0 End),Accass.Currency)  
 When Round(Max(coalesce((Admlink.Amount-Admlink.Amount_11-Admlink.Amount_12-(Admlink.Amount_8+Admlink.Amount_13+Admlink.Amount_17+Admlink.Amount_18)-Admlink.Amount_14),0)),2)<>0 then   
  sum((Admlink.Amount_13)*case When AccAss.Code<>'V' Then AccAss.Amount else 0 End)/Max(coalesce((Admlink.Amount-Admlink.Amount_11-Admlink.Amount_12-(Admlink.Amount_8+Admlink.Amount_13+Admlink.Amount_17+Admlink.Amount_18)-Admlink.Amount_14),0))  
 Else 
  sum(case When AccAss.Code='V' Then AccAss.Amount else 0 End)
 end  
 as VAT,          
 Case   
 When Max(Admlink.AdmNo) is null then  
  dbo.roundccy(  
  sum(  
  AccAss.Amount  
  *(Case  
	When SysTab.TaxMethod in (0,3) Then  
		Case When ((AccAss.Type in ('BB','BA','BC','BP','BD') and AccAss.Code in ('C','O')) or (AccAss.Type in ('OP','OR')) or (AccAss.Type in ('DI','IC','CF','JP','BO') and AccAss.Code in ('P','C','O','J','U')) or (AccAss.Type not in ('BB','BA','BC','BP','BD','OP','OP','DI','IC','CF','JP','BO') and AccAss.Code not in ('F','D'))) then 1 Else 0 End  
	When SysTab.TaxMethod in (4) Then  
		Case When ((AccAss.Type in ('BB','BA','BC','BP','BD') and AccAss.Code in ('C','O')) or (AccAss.Type in ('OP','OR')) or (AccAss.Type in ('DI','IC','CF','JP','BO') and AccAss.Code in ('P','C','D','O','J','U')) or (AccAss.Type not in ('BB','BA','BC','BP','BD','OP','OP','DI','IC','CF','JP','BO') and AccAss.Code not in ('F','D'))) then 1 Else 0 End  
	else  
		Case When ((AccAss.Type in ('CP','DC','QS','QP','S1','S2','S3','AF','XP','FO','FP','FX','IR','IT','IX') and AccAss.Code in ('C')) or (AccAss.Type in ('BB','BA','BC','BP','BD') and AccAss.Code in ('C','O')) or (AccAss.Type in ('OP','OR')) or (AccAss.Type not in ('CP','DC','QS','QP','S1','S2','S3','AF','XP','FO','FP','FX','IR','IT','IX','BB','BA','BC','BP','BD','OP','OR') and AccAss.Code not in ('F','D'))) then 1 Else 0 End     
	end)    
	*(Case   
	When SysTab.TaxMethod in (3) and ((AccAss.Type in ('BB','BA','BC','BP','BD'))) Then  
		case When RateTab.VATCommissionF=1 and (Case When Acceptance.ISType not in ('R','N','T','Q','S','A','X','P') or Profile.VATCOMMEXEMPTIF=0 Then cast(1 as Bit) Else 0 END)=1 then 1 else 0 end    	
	Else
		1
	End)
	*(Case   
	When SysTab.TaxMethod in (0,3,4) Then  
		Case When ((AccAss.Type in ('BB','BA','BC','BP','BD','OP','OR')) or ((AccAss.Type not in ('BB','BA','BC','BP','BD','OP','OR','DI','IC','CF','JP','BO') and TOC.VATBusinessF=1) or (Insured.VATF=1 and TOC.VATBusinessF=1))) Then 1 Else 0 End  
	Else  
		Case When ((AccAss.Type in ('BB','BA','BC','BP','BD','OP','OR')) or ((AccAss.Type not in ('BB','BA','BC','BP','BD','OP','OR','DI','IC','CF','JP','BO')) or (Insured.VATF=1 and TOC.VATBusinessF=1))) Then 1 Else 0 End  
	End)
  *(Case When Profile.VatF=1 or AccAss.Type in ('DI','IC','CF','JP','BO') Then 1 else 0 end)  
  *(Case When Acceptance.NoRefundF=7 and AccAss.Type in ('BB','BA','BO','BC','BP','BD') and AccAss.Code in ('C','O') then 0 else 1 end)  
  *(Case When Acceptance.NoRefundF in (8,10,14) then 0 else 1 end)  
  *(Case When SysTab.VATSubsidiesF=1 or Profile.VATSubsidiesF=1 then 1 else 0 end)  
  *(Case When Accass.Type in ('BB','BA') Then 1 else 0 end)
  )  
  ,Accass.Currency)  
  *Case When (Max(MParam.VAT)/100)<0 Then -(Max(MParam.VAT)/100) else 0 end  
 When Round(Max(coalesce((Admlink.Amount-Admlink.Amount_11-Admlink.Amount_12-(Admlink.Amount_8+Admlink.Amount_13+Admlink.Amount_17+Admlink.Amount_18)-Admlink.Amount_14),0)),2)<>0 then   
	Case 
	When round(Max(Admlink.Amount_13+Admlink.Amount_14),4)=round(Max(-Admlink.Amount_8),4) or round(Max(Admlink.Amount_13),4)=round(Max(-Admlink.Amount_8),4) then
		sum((-Admlink.Amount_13)*AccAss.Amount)/Max(coalesce((Admlink.Amount-Admlink.Amount_11-Admlink.Amount_12-(Admlink.Amount_8+Admlink.Amount_13+Admlink.Amount_17+Admlink.Amount_18)-Admlink.Amount_14),0))  
	else
	0
	end
 Else 0 end  
 as VATSubsidies,     
 Case   
 When Max(Admlink.AdmNo) is null then  
  dbo.roundccy(  
  sum(  
  AccAss.Amount  
  *(Case  
	When SysTab.TaxMethod in (0,3) Then  
		Case When ((AccAss.Type in ('BB','BA','BC','BP','BD') and AccAss.Code in ('C','O')) or (AccAss.Type in ('OP','OR')) or (AccAss.Type in ('DI','IC','CF','JP','BO') and AccAss.Code in ('P','C','O','J','U')) or (AccAss.Type not in ('BB','BA','BC','BP','BD','OP','OP','DI','IC','CF','JP','BO') and AccAss.Code not in ('F','D'))) then 1 Else 0 End  
	When SysTab.TaxMethod in (4) Then  
		Case When ((AccAss.Type in ('BB','BA','BC','BP','BD') and AccAss.Code in ('C','O')) or (AccAss.Type in ('OP','OR')) or (AccAss.Type in ('DI','IC','CF','JP','BO') and AccAss.Code in ('P','C','D','O','J','U')) or (AccAss.Type not in ('BB','BA','BC','BP','BD','OP','OP','DI','IC','CF','JP','BO') and AccAss.Code not in ('F','D'))) then 1 Else 0 End  
	else  
		Case When ((AccAss.Type in ('CP','DC','QS','QP','S1','S2','S3','AF','XP','FO','FP','FX','IR','IT','IX') and AccAss.Code in ('C')) or (AccAss.Type in ('BB','BA','BC','BP','BD') and AccAss.Code in ('C','O')) or (AccAss.Type in ('OP','OR')) or (AccAss.Type not in ('CP','DC','QS','QP','S1','S2','S3','AF','XP','FO','FP','FX','IR','IT','IX','BB','BA','BC','BP','BD','OP','OR') and AccAss.Code not in ('F','D'))) then 1 Else 0 End     
	end)    
	*(Case When Profile.BVatF=1 or AccAss.Type in ('DI','IC','CF','JP','BO') Then 1 else 0 end)  
    *(Case When Acceptance.NoRefundF<>11 and Acceptance.NoRefundF<>14 and AccAss.Type in ('DI','IC','CF','JP','BO') and Insured.BVatF=1 then 1 else 0 end)  
  )  
  ,Accass.Currency)  
  *Max((Case When coalesce(Acceptance.OverwriteBVatF,0)=0 Then Branch.VAT else coalesce(Acceptance.BVATPCT,0) end)/100)  
 When Round(Max(coalesce((Admlink.Amount-Admlink.Amount_11-Admlink.Amount_12-(Admlink.Amount_8+Admlink.Amount_13+Admlink.Amount_17+Admlink.Amount_18)-Admlink.Amount_14),0)),2)<>0 then   
  sum((Admlink.Amount_17)*AccAss.Amount)/Max(coalesce((Admlink.Amount-Admlink.Amount_11-Admlink.Amount_12-(Admlink.Amount_8+Admlink.Amount_13+Admlink.Amount_17+Admlink.Amount_18)-Admlink.Amount_14),0))  
 Else 0 end  
 as VAT_1,        
 Case   
 When Max(Admlink.AdmNo) is null then  
  Case when Max(AccAss.Type) in ('DI','IC','CF','JP','BO') Then    
   Case   
   When Max(SysTab.TaxMethod)=2 then  
    dbo.roundccy(  
    sum(  
    AccAss.Amount*Case When (AccAss.Type in ('DI','IC') and Accass.Code in ('P','O','U')) or (AccAss.Type in ('CF','JP') and AccAss.Code in ('P','O')) or (AccAss.Type in ('BO')) Then 1 else 0 end     
    *coalesce(RateCov.Portion,0)/coalesce(pRCover.Portion, RCover.Portion)  
    *(Case When Acceptance.NoRefundF<>11 and Acceptance.NoRefundF<>14 and AccAss.Type in ('DI','IC','CF','JP','BO') and Insured.TVatF=1 then 1 else 0 end)
    )  
    ,Accass.Currency)  
   When Max(SysTab.TaxMethod)=3 then  
    dbo.roundccy( 
    sum(  
    AccAss.Amount*Case When (AccAss.Type in ('DI','IC') and Accass.Code in ('P','O','U')) or (AccAss.Type in ('CF','JP') and AccAss.Code in ('P','O')) or (AccAss.Type in ('BO')) Then 1 else 0 end     
    *case When RateTab.VATF=1 and RateTab.VATEXEMPTF=0 then 1 else 0 end
	*(Case When Acceptance.NoRefundF<>11 and Acceptance.NoRefundF<>14 and AccAss.Type in ('DI','IC','CF','JP','BO') and Insured.TVatF=1 then 1 else 0 end)
    )  
    ,Accass.Currency)  
   Else  
    dbo.roundccy(  
    sum(  
    AccAss.Amount  
	*(Case  
	When SysTab.TaxMethod in (0,3) Then  
		Case When ((AccAss.Type in ('BB','BA','BC','BP','BD') and AccAss.Code in ('C','O')) or (AccAss.Type in ('OP','OR')) or (AccAss.Type in ('DI','IC','CF','JP','BO') and AccAss.Code in ('P','C','O','J','U')) or (AccAss.Type not in ('BB','BA','BC','BP','BD','OP','OP','DI','IC','CF','JP','BO') and AccAss.Code not in ('F','D'))) then 1 Else 0 End  
	When SysTab.TaxMethod in (4) Then  
		Case When ((AccAss.Type in ('BB','BA','BC','BP','BD') and AccAss.Code in ('C','O')) or (AccAss.Type in ('OP','OR')) or (AccAss.Type in ('DI','IC','CF','JP','BO') and AccAss.Code in ('P','C','D','O','J','U')) or (AccAss.Type not in ('BB','BA','BC','BP','BD','OP','OP','DI','IC','CF','JP','BO') and AccAss.Code not in ('F','D'))) then 1 Else 0 End  
	else  
		Case When ((AccAss.Type in ('CP','DC','QS','QP','S1','S2','S3','AF','XP','FO','FP','FX','IR','IT','IX') and AccAss.Code in ('C')) or (AccAss.Type in ('BB','BA','BC','BP','BD') and AccAss.Code in ('C','O')) or (AccAss.Type in ('OP','OR')) or (AccAss.Type not in ('CP','DC','QS','QP','S1','S2','S3','AF','XP','FO','FP','FX','IR','IT','IX','BB','BA','BC','BP','BD','OP','OR') and AccAss.Code not in ('F','D'))) then 1 Else 0 End     
	end)    
	*(Case   
	When SysTab.TaxMethod in (3) and ((AccAss.Type in ('BB','BA','BC','BP','BD'))) Then  
		case When RateTab.VATCommissionF=1 and (Case When Acceptance.ISType not in ('R','N','T','Q','S','A','X','P') or Profile.VATCOMMEXEMPTIF=0 Then cast(1 as Bit) Else 0 END)=1 then 1 else 0 end    	
	Else
		1
	End)      
	*(Case When Profile.TVatF=1 or (AccAss.Type in ('DI','IC','CF','JP','BO')) Then 1 else 0 end)  
    *(Case When Acceptance.NoRefundF<>11 and Acceptance.NoRefundF<>14 and AccAss.Type in ('DI','IC','CF','JP','BO') and Insured.TVatF=1 then 1 else 0 end)
    )  
    ,Accass.Currency)  
   end  
  else  
   0  
  end    
  *Max((Case When coalesce(Acceptance.OverwriteTVatF,0)=0 Then TOC.VAT else coalesce(Acceptance.TVATPCT,0) end)/100)  
 When Round(Max(coalesce((Admlink.Amount-Admlink.Amount_11-Admlink.Amount_12-(Admlink.Amount_8+Admlink.Amount_13+Admlink.Amount_17+Admlink.Amount_18)-Admlink.Amount_14),0)),2)<>0 then   
  sum((Admlink.Amount_18)*AccAss.Amount)/Max(coalesce((Admlink.Amount-Admlink.Amount_11-Admlink.Amount_12-(Admlink.Amount_8+Admlink.Amount_13+Admlink.Amount_17+Admlink.Amount_18)-Admlink.Amount_14),0))  
 Else 0 end  
 as VAT_2,   
 Case    
 When Max(Admlink.AdmNo) is null then  
  dbo.Roundccy(  
  sum(  
 -(  
   Case   
   When charindex(AccAss.Type,'FOFPQSQPS1S2S3AF')<>0  then  
    Case   
    When TaxType.MTaxType in ('PASAL21','PASAL23','PASAL4') Then  
     Case When AccAss.Code<>'P' then 1 else 0 end      
    else  
     Case When AccAss.Code<>'C' then 1 else 0 end      
    end  
   Else  
    1  
   End  
   *AccAss.Amount  
   )  
  *(Case When Profile.TaxF=1 Then 1 Else 0 End)  
  *(Case   
   When TaxType.MTaxType='PASAL21' Then   
    Case When (Case When MParam.UseTaxTypeF=0 Then MParam.PASAL21 Else TaxType.TaxRate End)<>0 Then (Case When Profile.AccruedTax<>0 Then Profile.AccruedTax else (Case When MParam.UseTaxTypeF=0 Then MParam.PASAL21 Else TaxType.TaxRate End)*(100-MParam.TaxDiscount)/100 end) else 0 end/100  
   When TaxType.MTaxType='PASAL23' Then  
    Case When (Case When MParam.UseTaxTypeF=0 Then MParam.PASAL23 Else TaxType.TaxRate End)<>0 Then (Case When Profile.AccruedTax<>0 Then Profile.AccruedTax else (Case When MParam.UseTaxTypeF=0 Then MParam.PASAL23 Else TaxType.TaxRate End) end) else 0 end/100   
   When TaxType.MTaxType='PASAL26' Then   
    Case When (Case When MParam.UseTaxTypeF=0 Then MParam.PASAL26 Else TaxType.TaxRate End)<>0 Then (Case When Profile.AccruedTax<>0 Then Profile.AccruedTax else (Case When MParam.UseTaxTypeF=0 Then MParam.PASAL26 Else TaxType.TaxRate End) end) else 0 end/100  
   When TaxType.MTaxType='PASAL4' Then   
    Case When (Case When MParam.UseTaxTypeF=0 Then MParam.PASAL4 Else TaxType.TaxRate End)<>0 Then (Case When Profile.AccruedTax<>0 Then Profile.AccruedTax else (Case When MParam.UseTaxTypeF=0 Then MParam.PASAL4 Else TaxType.TaxRate End) end) else 0 end/100  
   ELSE Profile.AccruedTax/100  
    END)  
  *Case When coalesce(Profile.TaxPCT,0)=0 then 1 else Profile.TaxPCT/100 end  
  *(Case When Acceptance.NoRefundF=7 and AccAss.Type in ('BB','BA','BO','BC','BP','BD') and AccAss.Code in ('C') then 0 else 1 end)  
  *(Case When Acceptance.NoRefundF in (9,10) then 0 else 1 end)  
  ),AccAss.Currency)  
 When Round(Max(coalesce((Admlink.Amount-Admlink.Amount_11-Admlink.Amount_12-(Admlink.Amount_8+Admlink.Amount_13+Admlink.Amount_17+Admlink.Amount_18)-Admlink.Amount_14),0)),2)<>0 then   
  sum((Admlink.Amount_14)*AccAss.Amount)/Max(coalesce((Admlink.Amount-Admlink.Amount_11-Admlink.Amount_12-(Admlink.Amount_8+Admlink.Amount_13+Admlink.Amount_17+Admlink.Amount_18)-Admlink.Amount_14),0))  
 Else 0 end  
 as TAX,
Case    
 When Max(Admlink.AdmNo) is null then  
  dbo.Roundccy(  
  sum(  
 -(  
   Case   
   When charindex(AccAss.Type,'FOFPQSQPS1S2S3AF')<>0  then  
    Case   
    When TaxType.MTaxType in ('PASAL21','PASAL23','PASAL4') Then  
     Case When AccAss.Code<>'P' then 1 else 0 end      
    else  
     Case When AccAss.Code<>'C' then 1 else 0 end      
    end  
   Else  
    1  
   End  
   *AccAss.Amount  
   )  
  *(Case When Profile.TaxF=1 Then 1 Else 0 End)  
  *(Case   
   When TaxType.MTaxType='PASAL21' Then   
    Case When (Case When MParam.UseTaxTypeF=0 Then MParam.PASAL21 Else TaxType.TaxRate End)<>0 Then (Case When Profile.AccruedTax<>0 Then Profile.AccruedTax else (Case When MParam.UseTaxTypeF=0 Then MParam.PASAL21 Else TaxType.TaxRate End)*(100-MParam.TaxDiscount)/100 end) else 0 end/100  
   When TaxType.MTaxType='PASAL23' Then  
    Case When (Case When MParam.UseTaxTypeF=0 Then MParam.PASAL23 Else TaxType.TaxRate End)<>0 Then (Case When Profile.AccruedTax<>0 Then Profile.AccruedTax else (Case When MParam.UseTaxTypeF=0 Then MParam.PASAL23 Else TaxType.TaxRate End) end) else 0 end/100   
   When TaxType.MTaxType='PASAL26' Then   
    Case When (Case When MParam.UseTaxTypeF=0 Then MParam.PASAL26 Else TaxType.TaxRate End)<>0 Then (Case When Profile.AccruedTax<>0 Then Profile.AccruedTax else (Case When MParam.UseTaxTypeF=0 Then MParam.PASAL26 Else TaxType.TaxRate End) end) else 0 end/100  
   When TaxType.MTaxType='PASAL4' Then   
    Case When (Case When MParam.UseTaxTypeF=0 Then MParam.PASAL4 Else TaxType.TaxRate End)<>0 Then (Case When Profile.AccruedTax<>0 Then Profile.AccruedTax else (Case When MParam.UseTaxTypeF=0 Then MParam.PASAL4 Else TaxType.TaxRate End) end) else 0 end/100  
   ELSE Profile.AccruedTax/100  
    END)  
  *Case When coalesce(Profile.TaxPCT,0)=0 then 1 else Profile.TaxPCT/100 end  
  *(Case When Acceptance.NoRefundF=7 and AccAss.Type in ('BB','BA','BO','BC','BP','BD') and AccAss.Code in ('C') then 0 else 1 end)  
  *(Case When Acceptance.NoRefundF in (9,10) then 0 else 1 end)  
  *(Case When Profile.TAXSubsidiesF=1 then -1 else 0 end) 
  *(Case When Accass.Type in ('BB','BA') Then 1 else 0 end)
  ),AccAss.Currency)  
 When Round(Max(coalesce((Admlink.Amount-Admlink.Amount_11-Admlink.Amount_12-(Admlink.Amount_8+Admlink.Amount_13+Admlink.Amount_17+Admlink.Amount_18)-Admlink.Amount_14),0)),2)<>0 then   
	Case 
	When round(Max(Admlink.Amount_13+Admlink.Amount_14),4)=round(Max(-Admlink.Amount_8),4) or round(Max(Admlink.Amount_14),4)=round(Max(-Admlink.Amount_8),4) then
		sum((-Admlink.Amount_14)*AccAss.Amount)/Max(coalesce((Admlink.Amount-Admlink.Amount_11-Admlink.Amount_12-(Admlink.Amount_8+Admlink.Amount_13+Admlink.Amount_17+Admlink.Amount_18)-Admlink.Amount_14),0))  
	else
	0
	end
 Else 0 end  
 as TAXSubsidies
 FROM Acceptance  
 Inner Join Cover on (Cover.CNO=Acceptance.CNO)  
 Inner Join TOC on (TOC.TOC=Acceptance.TOC)  
 Inner Join Branch on (Branch.Branch=Acceptance.Branch)  
 Inner Join Profile Insured on (Insured.ID=Acceptance.AID)  
 Inner Join AccAss on (Acceptance.ANO=AccAss.ANO)  
 Left Join APayor on (APayor.ANO=Acceptance.ANO and Acceptance.LANO<>-1 and Acceptance.ANO<>Acceptance.LANO)                                
 Left Join Payor on (Payor.ANO=Acceptance.ANO and Acceptance.LANO=-1)                
 Left Join Acceptance pAcceptance on (pAcceptance.ANO=Acceptance.pANO)  
 Left Join Admlink on (Admlink.AdmNo=AccAss.AdmNo)  
 Inner Join Profile on (Profile.ID=AccAss.ID)  
 Left Join TaxType on (TaxType.TaxType=Profile.TaxType)  
 Inner Join Mparam on (MParam.Type=AccAss.Type)  
 Left Join Payor MPayor on (MPayor.ANO=@P_ANO)        
 Inner Join SysTab on (1=1)  
 Left Join RateTab on (RateTab.Code=AccAss.RCode)  
 Left Join RCover on (RCover.ANO=Acceptance.ANO and RCover.Code=AccAss.RCode and RCover.SDate=AccAss.SDate)  
 Left Join RCover pRCover on (AccAss.CAmount=0 and pRCover.ANO=Acceptance.pANO and pRCover.Code=AccAss.RCode and pRCover.SDate=AccAss.SDate)  
 Outer apply (Select sum(RateCov.Portion) as Portion from RateCov Where RateCov.Code=AccAss.RCode and RateCov.VatF=1) as RateCov  
 WHERE Acceptance.PolicyNo<>'' and Acceptance.PolicyNo=@PolicyNo and Acceptance.RegNo=@MRegNo  
 GROUP BY AccAss.ID, Profile.Name, AccAss.Type, AccAss.Posted, AccAss.Admno, AccAss.Currency, Acceptance.RegNo, Accass.DocNo, AccAss.RefNo,        
 Case When AccAss.CAmount=0 and Coalesce(pAcceptance.Branch,'')<>'' Then pAcceptance.Branch Else Acceptance.Branch end,     
 dbo.fn_Get_UWYear(@MSDate, @MEDate, Case When (Case When isnull(APayor.ANO,0)=0 Then (Case When isnull(MPayor.ANO,0)=0 Then Payor.PolicyYearF else MPayor.PolicyYearF end) else APayor.PolicyYearF end)=1 Then AccAss.SDate else Acceptance.SDate end),  
 (Case When isnull(APayor.ANO,0)=0 Then (Case When isnull(MPayor.ANO,0)=0 Then Payor.Grace else MPayor.Grace end) else APayor.Grace end)  
END  
  
Select ID, Name, Type, cast(0 as Bit) as Posted, -1 as AdmNo, Currency,'SUMMARY' as RegNo, 'SUMMARY' as DocNo,'SUMMARY' as RefNo, 'SUMMARY' as Branch, 0 as PolicyYear, 0 as Grace,  
sum(Premium) as Premium, sum(Commision) as Commision, sum(OverridingCommission) as OverridingCommission, sum(Fee) as Fee, sum(Duty) as Duty,   
sum(Discount) as Discount, sum(Acquisition) as Acquisition, sum(PremiumAdjustment) as  PremiumAdjustment, sum(OtherIncome) as OtherIncome,   
sum(Ujroh) as Ujroh, sum(Tabarru) as Tabarru, sum(Deposit) as Deposit, sum(ClaimReserve) as ClaimReserve, sum(Advance) as Advance, sum(Rounding) as Rounding,   
sum(VAT) as VAT, sum(VATSubsidies) as VATSubsidies, sum(VAT_1) as VAT_1, sum(VAT_2) as VAT_2, sum(TAX) as TAX, sum(TAXSubsidies) as TAXSubsidies  
  
from @View07 View07  
Group by ID, Name, Type, Currency  
  
Union All  
Select *   
from @View07 View07 

GO

DROP PROCEDURE View07
GO
CREATE PROCEDURE View07 (@p_ANo as integer)                  
AS            
Declare @PolicyNo as varchar(50)
Declare @MRegNo as varchar(50)  
Declare @AStatus as varchar(1)  
Declare @AType as varchar(1)  
Declare @ASource as varchar(10)  
  
Select @PolicyNo=A.PolicyNo, @MRegNo=A.RegNo, @AStatus=A.AStatus, @AType=A.AType, @ASource=C.ASource
from Acceptance A Inner Join Cover C on (C.CNO=A.CNO) Where A.ANO=@P_ANO 

if (@MRegNo='' or @AStatus in ('W','T') or (@ASource='MKT' and @AType='N'))  
Begin  
	SELECT AccAss.ID, Profile.Name, AccAss.Type, AccAss.Posted, AccAss.Admno, AccAss.Currency, Acceptance.RegNo, Accass.DocNo, AccAss.RefNo,        
	Case When AccAss.CAmount=0 and Coalesce(pAcceptance.Branch,'')<>'' Then pAcceptance.Branch Else Acceptance.Branch end Branch,   dbo.fn_Get_UWYear(Acceptance.SDate, Acceptance.EDate, Case When (Case When isnull(APayor.ANO,0)=0 Then (Case When isnull(MPayor.ANO,0)=0 Then Payor.PolicyYearF else MPayor.PolicyYearF end) else APayor.PolicyYearF end)=1 Then AccAss.SDate else Acceptance.SDate end) as PolicyYear,  
	sum(                  
	 case                  
	  when (accass.type in ('IR','IT','IX') and accass.code in ('P','U','F')) or (accass.type in ('DI','IC') and accass.code in ('P','U')) or (AccAss.Type not in ('DI','IC','IR','IT','IX') and AccAss.Code='P') then AccAss.Amount  
	  else 0                  
	 end                  
	)   
	+  
	sum(  
	 Case   
	  When Acceptance.NoRefundF=7 and AccAss.Type in ('BB','BA','BO','BC','BP','BD') and AccAss.Code in ('C') then AccAss.Amount   
	  else 0   
	 end  
	)  
	AS Premium,                   
	sum(                  
	 case                   
	  when accass.code='C' and coalesce(accass.codeext,'') in ('','V') then AccAss.Amount                  
	  else 0                  
	 end                  
	)   
	-  
	sum(  
	 Case   
	  When Acceptance.NoRefundF=7 and AccAss.Type in ('BB','BA','BO','BC','BP','BD') and AccAss.Code in ('C') then AccAss.Amount   
	  else 0   
	 end  
	)  
	AS Commision,                   
	sum(                  
	 case                   
	  when accass.code='C' and coalesce(accass.codeext,'')='1' then AccAss.Amount                  
	  else 0                  
	 end                  
	) AS OverridingCommission,                   
	sum(                  
	 case                   
	  when accass.Type not in ('IR','IT','IX') and accass.code='F' then AccAss.Amount                  
	  else 0                  
	 end                  
	) AS Fee,                   
	sum(                  
	 case                   
	  when accass.code='D' then AccAss.Amount                  
	  else 0                  
	 end                  
	) AS Duty,                   
	sum(                  
	 case                   
	  when accass.type not in ('CP','DC','XP','QS','QP','S1','S2','S3','AF','FO','FP','FX') and accass.code='O' then AccAss.Amount                  
	  else 0                  
	 end                  
	) AS Discount,                   
	sum(                  
	 case                   
	  when accass.type in ('CP','DC','XP','QS','QP','S1','S2','S3','AF','FO','FP','FX') and accass.code='O' and coalesce(accass.CodeExt,'')='' then AccAss.Amount                  
	  else 0                  
	 end                  
	) AS Acquisition,     
	sum(                  
	 case                   
	  when accass.type in ('CP','DC','XP','QS','QP','S1','S2','S3','AF','FO','FP','FX') and accass.code='O' and coalesce(accass.CodeExt,'')='1' then AccAss.Amount                  
	  else 0                  
	 end                  
	) AS PremiumAdjustment,                                 
	sum(                  
	 case                  
	  when accass.code='I' then AccAss.Amount                  
	  else 0                  
	 end                  
	) AS OtherIncome,                 
	sum(                  
	 case                  
	  when accass.type in ('IR','IT','IX') and accass.code='F' then -AccAss.Amount  
	  when accass.Type in ('DI','IC') and accass.code='U' then -AccAss.Amount          
	  when accass.Type Not in ('DI','IC') and accass.code='U' then AccAss.Amount          
	  else 0                  
	 End                  
	) AS Ujroh,                
	sum(                  
	 case                  
	  when (accass.type in ('IR','IT','IX') and accass.code in ('P','U'))  or (accass.type in ('DI','IC') and accass.code in ('P')) or (AccAss.Type not in ('DI','IC','IR','IT','IX') and AccAss.Code in ('P','U')) then AccAss.Amount                  
	  else 0                  
	 end                  
	) AS Tabarru,           
	sum(                  
	 case                  
	  when accass.type not in ('CP','DC','XP','QS','QP','S1','S2','S3','AF','FO','FP','FX') and accass.code='J' then AccAss.Amount                  
	  else 0                  
	 end                  
	) AS Deposit,           
	sum(                  
	 case                  
	  when accass.type in ('IC','CF') and accass.code='G' then AccAss.Amount                  
	  else 0                  
	 end                  
	) AS ClaimReserve,           
	sum(                  
	 case                   
	  when accass.type in ('CP','DC','XP','QS','QP','S1','S2','S3','AF','FO','FP','FX') and accass.code='J' then AccAss.Amount                  
	  else 0                  
	 end                  
	) AS Advance,                    
	dbo.roundccy(sum(AccAss.Amount),AccAss.Currency) - sum(AccAss.Amount)as Rounding,          
	Case   
	When Max(Admlink.AdmNo) is null then  
	 dbo.roundccy(  
	 sum(  
	 AccAss.Amount  
	  *(Case  
		When SysTab.TaxMethod in (0,3) Then  
			Case When ((AccAss.Type in ('BB','BA','BC','BP','BD') and AccAss.Code in ('C','O')) or (AccAss.Type in ('OP','OR')) or (AccAss.Type in ('DI','IC','CF','JP','BO') and AccAss.Code in ('P','C','O','J','U')) or (AccAss.Type not in ('BB','BA','BC','BP','BD','OP','OP','DI','IC','CF','JP','BO') and AccAss.Code not in ('F','D'))) then 1 Else 0 End  
		When SysTab.TaxMethod in (4) Then  
			Case When ((AccAss.Type in ('BB','BA','BC','BP','BD') and AccAss.Code in ('C','O')) or (AccAss.Type in ('OP','OR')) or (AccAss.Type in ('DI','IC','CF','JP','BO') and AccAss.Code in ('P','C','D','O','J','U')) or (AccAss.Type not in ('BB','BA','BC','BP','BD','OP','OP','DI','IC','CF','JP','BO') and AccAss.Code not in ('F','D'))) then 1 Else 0 End  
		else  
			Case When ((AccAss.Type in ('CP','DC','QS','QP','S1','S2','S3','AF','XP','FO','FP','FX','IR','IT','IX') and AccAss.Code in ('C')) or (AccAss.Type in ('BB','BA','BC','BP','BD') and AccAss.Code in ('C','O')) or (AccAss.Type in ('OP','OR')) or (AccAss.Type not in ('CP','DC','QS','QP','S1','S2','S3','AF','XP','FO','FP','FX','IR','IT','IX','BB','BA','BC','BP','BD','OP','OR') and AccAss.Code not in ('F','D'))) then 1 Else 0 End     
		end)    
		*(Case   
		When SysTab.TaxMethod in (3) and ((AccAss.Type in ('BB','BA','BC','BP','BD'))) Then  
			case When RateTab.VATCommissionF=1 and (Case When Acceptance.ISType not in ('R','N','T','Q','S','A','X','P') or Profile.VATCOMMEXEMPTIF=0 Then cast(1 as Bit) Else 0 END)=1 then 1 else 0 end    	
		Else
			1
		End)
		*(Case   
		When SysTab.TaxMethod in (0,3,4) Then  
			Case When ((AccAss.Type in ('BB','BA','BC','BP','BD','OP','OR')) or ((AccAss.Type not in ('BB','BA','BC','BP','BD','OP','OR','DI','IC','CF','JP','BO') and TOC.VATBusinessF=1) or (Insured.VATF=1 and TOC.VATBusinessF=1))) Then 1 Else 0 End  
		Else  
			Case When ((AccAss.Type in ('BB','BA','BC','BP','BD','OP','OR')) or ((AccAss.Type not in ('BB','BA','BC','BP','BD','OP','OR','DI','IC','CF','JP','BO')) or (Insured.VATF=1 and TOC.VATBusinessF=1))) Then 1 Else 0 End  
		End)
	 *(Case When Profile.VatF=1 or AccAss.Type in ('DI','IC','CF','JP','BO') Then 1 else 0 end)  
	 *(Case When Acceptance.NoRefundF=7 and AccAss.Type in ('BB','BA','BO','BC','BP','BD') and AccAss.Code in ('C','O') then 0 else 1 end)  
	 *(Case When Acceptance.NoRefundF in (8,10,14) then 0 else 1 end)  
	 )  
	 ,Accass.Currency)  
	 *(Max(MParam.VAT)/100)  
	 +
	 dbo.roundccy(sum(case When AccAss.Code='V' Then AccAss.Amount else 0 End),Accass.Currency)
	When Round(Max(coalesce((Admlink.Amount-Admlink.Amount_11-Admlink.Amount_12-(Admlink.Amount_8+Admlink.Amount_13+Admlink.Amount_17+Admlink.Amount_18)-Admlink.Amount_14),0)),2)<>0 then   
	 sum((Admlink.Amount_13)*case When AccAss.Code<>'V' Then AccAss.Amount else 0 End)/Max(coalesce((Admlink.Amount-Admlink.Amount_11-Admlink.Amount_12-(Admlink.Amount_8+Admlink.Amount_13+Admlink.Amount_17+Admlink.Amount_18)-Admlink.Amount_14),0))  
	Else 
	 sum(case When AccAss.Code='V' Then AccAss.Amount else 0 End)
	end  
	as VAT,         
	Case   
	 When Max(Admlink.AdmNo) is null then  
	 dbo.roundccy(  
	 sum(  
	  AccAss.Amount  
	  *(Case  
		When SysTab.TaxMethod in (0,3) Then  
			Case When ((AccAss.Type in ('BB','BA','BC','BP','BD') and AccAss.Code in ('C','O')) or (AccAss.Type in ('OP','OR')) or (AccAss.Type in ('DI','IC','CF','JP','BO') and AccAss.Code in ('P','C','O','J','U')) or (AccAss.Type not in ('BB','BA','BC','BP','BD','OP','OP','DI','IC','CF','JP','BO') and AccAss.Code not in ('F','D'))) then 1 Else 0 End  
		When SysTab.TaxMethod in (4) Then  
			Case When ((AccAss.Type in ('BB','BA','BC','BP','BD') and AccAss.Code in ('C','O')) or (AccAss.Type in ('OP','OR')) or (AccAss.Type in ('DI','IC','CF','JP','BO') and AccAss.Code in ('P','C','D','O','J','U')) or (AccAss.Type not in ('BB','BA','BC','BP','BD','OP','OP','DI','IC','CF','JP','BO') and AccAss.Code not in ('F','D'))) then 1 Else 0 End  
		else  
			Case When ((AccAss.Type in ('CP','DC','QS','QP','S1','S2','S3','AF','XP','FO','FP','FX','IR','IT','IX') and AccAss.Code in ('C')) or (AccAss.Type in ('BB','BA','BC','BP','BD') and AccAss.Code in ('C','O')) or (AccAss.Type in ('OP','OR')) or (AccAss.Type not in ('CP','DC','QS','QP','S1','S2','S3','AF','XP','FO','FP','FX','IR','IT','IX','BB','BA','BC','BP','BD','OP','OR') and AccAss.Code not in ('F','D'))) then 1 Else 0 End     
		end)    
		*(Case   
		When SysTab.TaxMethod in (3) and ((AccAss.Type in ('BB','BA','BC','BP','BD'))) Then  
			case When RateTab.VATCommissionF=1 and (Case When Acceptance.ISType not in ('R','N','T','Q','S','A','X','P') or Profile.VATCOMMEXEMPTIF=0 Then cast(1 as Bit) Else 0 END)=1 then 1 else 0 end    	
		Else
			1
		End)
		*(Case   
		When SysTab.TaxMethod in (0,3,4) Then  
			Case When ((AccAss.Type in ('BB','BA','BC','BP','BD','OP','OR')) or ((AccAss.Type not in ('BB','BA','BC','BP','BD','OP','OR','DI','IC','CF','JP','BO') and TOC.VATBusinessF=1) or (Insured.VATF=1 and TOC.VATBusinessF=1))) Then 1 Else 0 End  
		Else  
			Case When ((AccAss.Type in ('BB','BA','BC','BP','BD','OP','OR')) or ((AccAss.Type not in ('BB','BA','BC','BP','BD','OP','OR','DI','IC','CF','JP','BO')) or (Insured.VATF=1 and TOC.VATBusinessF=1))) Then 1 Else 0 End  
		End)
	 *(Case When Profile.VatF=1 or AccAss.Type in ('DI','IC','CF','JP','BO') Then 1 else 0 end)  
	 *(Case When Acceptance.NoRefundF=7 and AccAss.Type in ('BB','BA','BO','BC','BP','BD') and AccAss.Code in ('C','O') then 0 else 1 end)  
	 *(Case When Acceptance.NoRefundF in (8,10,14) then 0 else 1 end)  
	 *(Case When SysTab.VATSubsidiesF=1 or Profile.VATSubsidiesF=1 then 1 else 0 end)  
	 *(Case When Accass.Type in ('BB','BA') Then 1 else 0 end)
	 )  
	 ,Accass.Currency)
	 *Case When (Max(MParam.VAT)/100)<0 Then -(Max(MParam.VAT)/100) else 0 end 
	 When Round(Max(coalesce((Admlink.Amount-Admlink.Amount_11-Admlink.Amount_12-(Admlink.Amount_8+Admlink.Amount_13+Admlink.Amount_17+Admlink.Amount_18)-Admlink.Amount_14),0)),2)<>0 then   
		Case 
		When round(Max(Admlink.Amount_13+Admlink.Amount_14),4)=round(Max(-Admlink.Amount_8),4) or round(Max(Admlink.Amount_13),4)=round(Max(-Admlink.Amount_8),4) then
			sum((-Admlink.Amount_13)*AccAss.Amount)/Max(coalesce((Admlink.Amount-Admlink.Amount_11-Admlink.Amount_12-(Admlink.Amount_8+Admlink.Amount_13+Admlink.Amount_17+Admlink.Amount_18)-Admlink.Amount_14),0))  
		else
		0
		end
	 Else 
	   0
	 end  
	as VATSubsidies,     
	Case   
	When Max(Admlink.AdmNo) is null then  
	 dbo.roundccy(  
	 sum(  
	 AccAss.Amount  
	  *(Case  
		When SysTab.TaxMethod in (0,3) Then  
			Case When ((AccAss.Type in ('BB','BA','BC','BP','BD') and AccAss.Code in ('C','O')) or (AccAss.Type in ('OP','OR')) or (AccAss.Type in ('DI','IC','CF','JP','BO') and AccAss.Code in ('P','C','O','J','U')) or (AccAss.Type not in ('BB','BA','BC','BP','BD','OP','OP','DI','IC','CF','JP','BO') and AccAss.Code not in ('F','D'))) then 1 Else 0 End  
		When SysTab.TaxMethod in (4) Then  
			Case When ((AccAss.Type in ('BB','BA','BC','BP','BD') and AccAss.Code in ('C','O')) or (AccAss.Type in ('OP','OR')) or (AccAss.Type in ('DI','IC','CF','JP','BO') and AccAss.Code in ('P','C','D','O','J','U')) or (AccAss.Type not in ('BB','BA','BC','BP','BD','OP','OP','DI','IC','CF','JP','BO') and AccAss.Code not in ('F','D'))) then 1 Else 0 End  
		else  
			Case When ((AccAss.Type in ('CP','DC','QS','QP','S1','S2','S3','AF','XP','FO','FP','FX','IR','IT','IX') and AccAss.Code in ('C')) or (AccAss.Type in ('BB','BA','BC','BP','BD') and AccAss.Code in ('C','O')) or (AccAss.Type in ('OP','OR')) or (AccAss.Type not in ('CP','DC','QS','QP','S1','S2','S3','AF','XP','FO','FP','FX','IR','IT','IX','BB','BA','BC','BP','BD','OP','OR') and AccAss.Code not in ('F','D'))) then 1 Else 0 End     
		end)    
	 *(Case When Profile.BVatF=1 or AccAss.Type in ('DI','IC','CF','JP','BO') Then 1 else 0 end)  
	 *(Case When Acceptance.NoRefundF<>11 and Acceptance.NoRefundF<>14 and AccAss.Type in ('DI','IC','CF','JP','BO') and Insured.BVatF=1 then 1 else 0 end)  
	 )  
	 ,Accass.Currency)  
	 *Max((Case When coalesce(Acceptance.OverwriteBVatF,0)=0 Then Branch.VAT else coalesce(Acceptance.BVATPCT,0) end)/100)  
	When Round(Max(coalesce((Admlink.Amount-Admlink.Amount_11-Admlink.Amount_12-(Admlink.Amount_8+Admlink.Amount_13+Admlink.Amount_17+Admlink.Amount_18)-Admlink.Amount_14),0)),2)<>0 then   
	 sum((Admlink.Amount_17)*AccAss.Amount)/Max(coalesce((Admlink.Amount-Admlink.Amount_11-Admlink.Amount_12-(Admlink.Amount_8+Admlink.Amount_13+Admlink.Amount_17+Admlink.Amount_18)-Admlink.Amount_14),0))  
	Else 0 end  
	as VAT_1,        
	Case   
	When Max(Admlink.AdmNo) is null then  
	 Case when Max(AccAss.Type) in ('DI','IC','CF','JP','BO') Then    
	  Case   
	  When Max(SysTab.TaxMethod)=2 then  
	   dbo.roundccy(  
	   sum(  
	   AccAss.Amount*Case When (AccAss.Type in ('DI','IC') and Accass.Code in ('P','O','U')) or (AccAss.Type in ('CF','JP') and AccAss.Code in ('P','O')) or (AccAss.Type in ('BO')) Then 1 else 0 end     
	   *coalesce(RateCov.Portion,0)/coalesce(pRCover.Portion, RCover.Portion)  
	   *(Case When Acceptance.NoRefundF<>11 and Acceptance.NoRefundF<>14 and AccAss.Type in ('DI','IC','CF','JP','BO') and Insured.TVatF=1 then 1 else 0 end)
	   )  
	   ,Accass.Currency)  
	  When Max(SysTab.TaxMethod)=3 then  
	   dbo.roundccy(  
	   sum(  
	   AccAss.Amount*Case When (AccAss.Type in ('DI','IC') and Accass.Code in ('P','O','U')) or (AccAss.Type in ('CF','JP') and AccAss.Code in ('P','O')) or (AccAss.Type in ('BO')) Then 1 else 0 end     
	   *case When RateTab.VATF=1 and RateTab.VATEXEMPTF=0 then 1 else 0 end  
	   *(Case When Acceptance.NoRefundF<>11 and Acceptance.NoRefundF<>14 and AccAss.Type in ('DI','IC','CF','JP','BO') and Insured.TVatF=1 then 1 else 0 end)
	   )  
	   ,Accass.Currency)  
	  Else  
	   dbo.roundccy(  
	   sum(  
		 AccAss.Amount  
		  *(Case  
			When SysTab.TaxMethod in (0,3) Then  
				Case When ((AccAss.Type in ('BB','BA','BC','BP','BD') and AccAss.Code in ('C','O')) or (AccAss.Type in ('OP','OR')) or (AccAss.Type in ('DI','IC','CF','JP','BO') and AccAss.Code in ('P','C','O','J','U')) or (AccAss.Type not in ('BB','BA','BC','BP','BD','OP','OP','DI','IC','CF','JP','BO') and AccAss.Code not in ('F','D'))) then 1 Else 0 End  
			When SysTab.TaxMethod in (4) Then  
				Case When ((AccAss.Type in ('BB','BA','BC','BP','BD') and AccAss.Code in ('C','O')) or (AccAss.Type in ('OP','OR')) or (AccAss.Type in ('DI','IC','CF','JP','BO') and AccAss.Code in ('P','C','D','O','J','U')) or (AccAss.Type not in ('BB','BA','BC','BP','BD','OP','OP','DI','IC','CF','JP','BO') and AccAss.Code not in ('F','D'))) then 1 Else 0 End  
			else  
				Case When ((AccAss.Type in ('CP','DC','QS','QP','S1','S2','S3','AF','XP','FO','FP','FX','IR','IT','IX') and AccAss.Code in ('C')) or (AccAss.Type in ('BB','BA','BC','BP','BD') and AccAss.Code in ('C','O')) or (AccAss.Type in ('OP','OR')) or (AccAss.Type not in ('CP','DC','QS','QP','S1','S2','S3','AF','XP','FO','FP','FX','IR','IT','IX','BB','BA','BC','BP','BD','OP','OR') and AccAss.Code not in ('F','D'))) then 1 Else 0 End     
			end)    
			*(Case   
			When SysTab.TaxMethod in (3) and ((AccAss.Type in ('BB','BA','BC','BP','BD'))) Then  
				case When RateTab.VATCommissionF=1 and (Case When Acceptance.ISType not in ('R','N','T','Q','S','A','X','P') or Profile.VATCOMMEXEMPTIF=0 Then cast(1 as Bit) Else 0 END)=1 then 1 else 0 end    	
			Else
				1
			End)    
		  *(Case When Profile.TVatF=1 or (AccAss.Type in ('DI','IC','CF','JP','BO')) Then 1 else 0 end)  
		  *(Case When Acceptance.NoRefundF<>11 and Acceptance.NoRefundF<>14 and AccAss.Type in ('DI','IC','CF','JP','BO') and Insured.TVatF=1 then 1 else 0 end)		
	   )  
	   ,Accass.Currency)  
	  end      
	 else  
	  0  
	 end  
	 *Max((Case When coalesce(Acceptance.OverwriteTVatF,0)=0 Then TOC.VAT else coalesce(Acceptance.TVATPCT,0) end)/100)  
	When Round(Max(coalesce((Admlink.Amount-Admlink.Amount_11-Admlink.Amount_12-(Admlink.Amount_8+Admlink.Amount_13+Admlink.Amount_17+Admlink.Amount_18)-Admlink.Amount_14),0)),2)<>0 then   
	 sum((Admlink.Amount_18)*AccAss.Amount)/Max(coalesce((Admlink.Amount-Admlink.Amount_11-Admlink.Amount_12-(Admlink.Amount_8+Admlink.Amount_13+Admlink.Amount_17+Admlink.Amount_18)-Admlink.Amount_14),0))  
	Else 0 end  
	as VAT_2,   
	Case   
	When Max(Admlink.AdmNo) is null then  
	 dbo.roundccy(  
	 sum(  
	 -(  
	  Case   
	  When charindex(AccAss.Type,'FOFPQSQPS1S2S3AF')<>0  then  
	   Case   
	   When TaxType.MTaxType in ('PASAL21','PASAL23','PASAL4') Then  
		Case When AccAss.Code<>'P' then 1 else 0 end      
	   else  
		Case When AccAss.Code<>'C' then 1 else 0 end      
	   end  
	  Else  
	   1  
	  End  
	  *AccAss.Amount  
	  )  
	 *(Case When Profile.TaxF=1 Then 1 Else 0 End)  
	 *(Case   
	  When TaxType.MTaxType='PASAL21' Then   
	   Case When (Case When MParam.UseTaxTypeF=0 Then MParam.PASAL21 Else TaxType.TaxRate End)<>0 Then (Case When Profile.AccruedTax<>0 Then Profile.AccruedTax else (Case When MParam.UseTaxTypeF=0 Then MParam.PASAL21 Else TaxType.TaxRate End)*(100-MParam.TaxDiscount)/100 end) else 0 end/100    
	  When TaxType.MTaxType='PASAL23' Then  
	   Case When (Case When MParam.UseTaxTypeF=0 Then MParam.PASAL23 Else TaxType.TaxRate End)<>0 Then (Case When Profile.AccruedTax<>0 Then Profile.AccruedTax else (Case When MParam.UseTaxTypeF=0 Then MParam.PASAL23 Else TaxType.TaxRate End) end) else 0 end/100   
	  When TaxType.MTaxType='PASAL26' Then   
	   Case When (Case When MParam.UseTaxTypeF=0 Then MParam.PASAL26 Else TaxType.TaxRate End)<>0 Then (Case When Profile.AccruedTax<>0 Then Profile.AccruedTax else (Case When MParam.UseTaxTypeF=0 Then MParam.PASAL26 Else TaxType.TaxRate End) end) else 0 end/100  
	  When TaxType.MTaxType='PASAL4' Then   
	   Case When (Case When MParam.UseTaxTypeF=0 Then MParam.PASAL4 Else TaxType.TaxRate End)<>0 Then (Case When Profile.AccruedTax<>0 Then Profile.AccruedTax else (Case When MParam.UseTaxTypeF=0 Then MParam.PASAL4 Else TaxType.TaxRate End) end) else 0 end/100  
	  ELSE Profile.AccruedTax/100  
	  END)  
	 *Case When coalesce(Profile.TaxPCT,0)=0 then 1 else Profile.TaxPCT/100 end  
	 *(Case When Acceptance.NoRefundF=7 and AccAss.Type in ('BB','BA','BO','BC','BP','BD') and AccAss.Code in ('C') then 0 else 1 end)  
	 *(Case When Acceptance.NoRefundF in (9,10) then 0 else 1 end)  
	 )  
	 ,AccAss.Currency)  
	When Round(Max(coalesce((Admlink.Amount-Admlink.Amount_11-Admlink.Amount_12-(Admlink.Amount_8+Admlink.Amount_13+Admlink.Amount_17+Admlink.Amount_18)-Admlink.Amount_14),0)),2)<>0 then   
	 sum((Admlink.Amount_14)*AccAss.Amount)/Max(coalesce((Admlink.Amount-Admlink.Amount_11-Admlink.Amount_12-(Admlink.Amount_8+Admlink.Amount_13+Admlink.Amount_17+Admlink.Amount_18)-Admlink.Amount_14),0))  
	Else 0 end  
	as TAX,
	Case   
	When Max(Admlink.AdmNo) is null then  
	 dbo.roundccy(  
	 sum(  
	 -(  
	  Case   
	  When charindex(AccAss.Type,'FOFPQSQPS1S2S3AF')<>0  then  
	   Case   
	   When TaxType.MTaxType in ('PASAL21','PASAL23','PASAL4') Then  
		Case When AccAss.Code<>'P' then 1 else 0 end      
	   else  
		Case When AccAss.Code<>'C' then 1 else 0 end      
	   end  
	  Else  
	   1  
	  End  
	  *AccAss.Amount  
	  )  
	 *(Case When Profile.TaxF=1 Then 1 Else 0 End)  
	 *(Case   
	  When TaxType.MTaxType='PASAL21' Then   
	   Case When (Case When MParam.UseTaxTypeF=0 Then MParam.PASAL21 Else TaxType.TaxRate End)<>0 Then (Case When Profile.AccruedTax<>0 Then Profile.AccruedTax else (Case When MParam.UseTaxTypeF=0 Then MParam.PASAL21 Else TaxType.TaxRate End)*(100-MParam.TaxDiscount)/100 end) else 0 end/100    
	  When TaxType.MTaxType='PASAL23' Then  
	   Case When (Case When MParam.UseTaxTypeF=0 Then MParam.PASAL23 Else TaxType.TaxRate End)<>0 Then (Case When Profile.AccruedTax<>0 Then Profile.AccruedTax else (Case When MParam.UseTaxTypeF=0 Then MParam.PASAL23 Else TaxType.TaxRate End) end) else 0 end/100   
	  When TaxType.MTaxType='PASAL26' Then   
	   Case When (Case When MParam.UseTaxTypeF=0 Then MParam.PASAL26 Else TaxType.TaxRate End)<>0 Then (Case When Profile.AccruedTax<>0 Then Profile.AccruedTax else (Case When MParam.UseTaxTypeF=0 Then MParam.PASAL26 Else TaxType.TaxRate End) end) else 0 end/100  
	  When TaxType.MTaxType='PASAL4' Then   
	   Case When (Case When MParam.UseTaxTypeF=0 Then MParam.PASAL4 Else TaxType.TaxRate End)<>0 Then (Case When Profile.AccruedTax<>0 Then Profile.AccruedTax else (Case When MParam.UseTaxTypeF=0 Then MParam.PASAL4 Else TaxType.TaxRate End) end) else 0 end/100  
	  ELSE Profile.AccruedTax/100  
	  END)  
	 *Case When coalesce(Profile.TaxPCT,0)=0 then 1 else Profile.TaxPCT/100 end  
	 *(Case When Acceptance.NoRefundF=7 and AccAss.Type in ('BB','BA','BO','BC','BP','BD') and AccAss.Code in ('C') then 0 else 1 end)  
	 *(Case When Acceptance.NoRefundF in (9,10) then 0 else 1 end)  
	 *(Case When Profile.TAXSubsidiesF=1 then -1 else 0 end)  
	 *(Case When Accass.Type in ('BB','BA') Then 1 else 0 end)
	 )  
	 ,AccAss.Currency)  
	When Round(Max(coalesce((Admlink.Amount-Admlink.Amount_11-Admlink.Amount_12-(Admlink.Amount_8+Admlink.Amount_13+Admlink.Amount_17+Admlink.Amount_18)-Admlink.Amount_14),0)),2)<>0 then   
		Case 
		When round(Max(Admlink.Amount_13+Admlink.Amount_14),4)=round(Max(-Admlink.Amount_8),4) or round(Max(Admlink.Amount_14),4)=round(Max(-Admlink.Amount_8),4) then
			sum((-Admlink.Amount_14)*AccAss.Amount)/Max(coalesce((Admlink.Amount-Admlink.Amount_11-Admlink.Amount_12-(Admlink.Amount_8+Admlink.Amount_13+Admlink.Amount_17+Admlink.Amount_18)-Admlink.Amount_14),0))  
		else
		0
		end
	Else 0 end  
	as TAXSubsidies
	FROM Acceptance   
	Inner Join Cover on (Cover.CNO=Acceptance.CNO)  
	Inner Join TOC on (TOC.TOC=Acceptance.TOC)  
	Inner Join Branch on (Branch.Branch=Acceptance.Branch)  
	Inner Join Profile Insured on (Insured.ID=Acceptance.AID)  
	Inner Join AccAss on (Acceptance.ANO=AccAss.ANO)  
	Left Join APayor on (APayor.ANO=Acceptance.ANO and Acceptance.LANO<>-1 and Acceptance.ANO<>Acceptance.LANO)                                
	Left Join Payor on (Payor.ANO=Acceptance.ANO and Acceptance.LANO=-1)                
	Left Join Acceptance pAcceptance on (pAcceptance.ANO=Acceptance.pANO)  
	Left Join Admlink on (Admlink.AdmNo=AccAss.AdmNo and not ((Acceptance.LANO<>-1 and Cover.OpenFlag=0) or (Acceptance.BulkF=1))) 
	Inner Join Profile on (Profile.ID=AccAss.ID)  
	Left Join TaxType on (TaxType.TaxType=Profile.TaxType)  
	Inner Join Mparam on (MParam.Type=AccAss.Type)  
	Outer Apply (
		Select Top 1 mPayor.ANO, mPayor.PolicyYearF 
		from Acceptance mAcceptance, Cover mCover, Payor mPayor
		Where mCover.CNO=mAcceptance.CNO and mPayor.ANO=mAcceptance.ANO and mAcceptance.ANO=mAcceptance.LANO and MAcceptance.ANO=Acceptance.LANO 
	) mPayor
	Inner Join SysTab on (1=1)  
	Left Join RateTab on (RateTab.Code=AccAss.RCode)  
	Left Join RCover on (RCover.ANO=Acceptance.ANO and RCover.Code=AccAss.RCode and RCover.SDate=AccAss.SDate)  
	Left Join RCover pRCover on (AccAss.CAmount=0 and pRCover.ANO=Acceptance.pANO and pRCover.Code=AccAss.RCode and pRCover.SDate=AccAss.SDate)  
	Outer apply (Select sum(RateCov.Portion) as Portion from RateCov Where RateCov.Code=AccAss.RCode and RateCov.VatF=1) as RateCov  
	WHERE Acceptance.ANO=@P_ANO          
	GROUP BY AccAss.ID, Profile.Name, AccAss.Type, AccAss.Posted, AccAss.Admno, AccAss.Currency, Acceptance.RegNo, Accass.DocNo, AccAss.RefNo,        
	Case When AccAss.CAmount=0 and Coalesce(pAcceptance.Branch,'')<>'' Then pAcceptance.Branch Else Acceptance.Branch end,   
	dbo.fn_Get_UWYear(Acceptance.SDate, Acceptance.EDate, 
	Case When (Case When isnull(APayor.ANO,0)=0 Then (Case When isnull(MPayor.ANO,0)=0 Then Payor.PolicyYearF else MPayor.PolicyYearF end) else APayor.PolicyYearF end)=1 Then AccAss.SDate else Acceptance.SDate end)   
End
Else
Begin
	SELECT AccAss.ID, Profile.Name, AccAss.Type, AccAss.Posted, AccAss.Admno, AccAss.Currency, Acceptance.RegNo, Accass.DocNo, AccAss.RefNo,        
	Case When AccAss.CAmount=0 and Coalesce(pAcceptance.Branch,'')<>'' Then pAcceptance.Branch Else Acceptance.Branch end Branch,   dbo.fn_Get_UWYear(Acceptance.SDate, Acceptance.EDate, Case When (Case When isnull(APayor.ANO,0)=0 Then (Case When isnull(MPayor.ANO,0)=0 Then Payor.PolicyYearF else MPayor.PolicyYearF end) else APayor.PolicyYearF end)=1 Then AccAss.SDate else Acceptance.SDate end) as PolicyYear,  
	sum(                  
	 case                  
	  when (accass.type in ('IR','IT','IX') and accass.code in ('P','U','F')) or (accass.type in ('DI','IC') and accass.code in ('P','U')) or (AccAss.Type not in ('DI','IC','IR','IT','IX') and AccAss.Code='P') then AccAss.Amount  
	  else 0                  
	 end                  
	)   
	+  
	sum(  
	 Case   
	  When Acceptance.NoRefundF=7 and AccAss.Type in ('BB','BA','BO','BC','BP','BD') and AccAss.Code in ('C') then AccAss.Amount   
	  else 0   
	 end  
	)  
	AS Premium,                   
	sum(                  
	 case                   
	  when accass.code='C' and coalesce(accass.codeext,'') in ('','V') then AccAss.Amount                  
	  else 0                  
	 end                  
	)   
	-  
	sum(  
	 Case   
	  When Acceptance.NoRefundF=7 and AccAss.Type in ('BB','BA','BO','BC','BP','BD') and AccAss.Code in ('C') then AccAss.Amount   
	  else 0   
	 end  
	)  
	AS Commision,                   
	sum(                  
	 case                   
	  when accass.code='C' and coalesce(accass.codeext,'')='1' then AccAss.Amount                  
	  else 0                  
	 end                  
	) AS OverridingCommission,                   
	sum(                  
	 case                   
	  when accass.Type not in ('IR','IT','IX') and accass.code='F' then AccAss.Amount                  
	  else 0                  
	 end                  
	) AS Fee,                   
	sum(                  
	 case                   
	  when accass.code='D' then AccAss.Amount                  
	  else 0                  
	 end                  
	) AS Duty,                   
	sum(                  
	 case                   
	  when accass.type not in ('CP','DC','XP','QS','QP','S1','S2','S3','AF','FO','FP','FX') and accass.code='O' then AccAss.Amount                  
	  else 0                  
	 end                  
	) AS Discount,                   
	sum(                  
	 case                   
	  when accass.type in ('CP','DC','XP','QS','QP','S1','S2','S3','AF','FO','FP','FX') and accass.code='O' and coalesce(accass.CodeExt,'')='' then AccAss.Amount                  
	  else 0                  
	 end                  
	) AS Acquisition,     
	sum(                  
	 case                   
	  when accass.type in ('CP','DC','XP','QS','QP','S1','S2','S3','AF','FO','FP','FX') and accass.code='O' and coalesce(accass.CodeExt,'')='1' then AccAss.Amount                  
	  else 0                  
	 end                  
	) AS PremiumAdjustment,                                 
	sum(                  
	 case                  
	  when accass.code='I' then AccAss.Amount                  
	  else 0                  
	 end                  
	) AS OtherIncome,                 
	sum(                  
	 case                  
	  when accass.type in ('IR','IT','IX') and accass.code='F' then -AccAss.Amount  
	  when accass.Type in ('DI','IC') and accass.code='U' then -AccAss.Amount          
	  when accass.Type Not in ('DI','IC') and accass.code='U' then AccAss.Amount          
	  else 0                  
	 End                  
	) AS Ujroh,                
	sum(                  
	 case                  
	  when (accass.type in ('IR','IT','IX') and accass.code in ('P','U'))  or (accass.type in ('DI','IC') and accass.code in ('P')) or (AccAss.Type not in ('DI','IC','IR','IT','IX') and AccAss.Code in ('P','U')) then AccAss.Amount                  
	  else 0                  
	 end                  
	) AS Tabarru,           
	sum(                  
	 case                  
	  when accass.type not in ('CP','DC','XP','QS','QP','S1','S2','S3','AF','FO','FP','FX') and accass.code='J' then AccAss.Amount                  
	  else 0                  
	 end                  
	) AS Deposit,           
	sum(                  
	 case                  
	  when accass.type in ('IC','CF') and accass.code='G' then AccAss.Amount                  
	  else 0                  
	 end                  
	) AS ClaimReserve,           
	sum(                  
	 case                   
	  when accass.type in ('CP','DC','XP','QS','QP','S1','S2','S3','AF','FO','FP','FX') and accass.code='J' then AccAss.Amount                  
	  else 0                  
	 end                  
	) AS Advance,                    
	dbo.roundccy(sum(AccAss.Amount),AccAss.Currency) - sum(AccAss.Amount)as Rounding,          
	Case   
	When Max(Admlink.AdmNo) is null then  
	 dbo.roundccy(  
	 sum(  
	 AccAss.Amount  
	  *(Case  
		When SysTab.TaxMethod in (0,3) Then  
			Case When ((AccAss.Type in ('BB','BA','BC','BP','BD') and AccAss.Code in ('C','O')) or (AccAss.Type in ('OP','OR')) or (AccAss.Type in ('DI','IC','CF','JP','BO') and AccAss.Code in ('P','C','O','J','U')) or (AccAss.Type not in ('BB','BA','BC','BP','BD','OP','OP','DI','IC','CF','JP','BO') and AccAss.Code not in ('F','D'))) then 1 Else 0 End  
		When SysTab.TaxMethod in (4) Then  
			Case When ((AccAss.Type in ('BB','BA','BC','BP','BD') and AccAss.Code in ('C','O')) or (AccAss.Type in ('OP','OR')) or (AccAss.Type in ('DI','IC','CF','JP','BO') and AccAss.Code in ('P','C','D','O','J','U')) or (AccAss.Type not in ('BB','BA','BC','BP','BD','OP','OP','DI','IC','CF','JP','BO') and AccAss.Code not in ('F','D'))) then 1 Else 0 End  
		else  
			Case When ((AccAss.Type in ('CP','DC','QS','QP','S1','S2','S3','AF','XP','FO','FP','FX','IR','IT','IX') and AccAss.Code in ('C')) or (AccAss.Type in ('BB','BA','BC','BP','BD') and AccAss.Code in ('C','O')) or (AccAss.Type in ('OP','OR')) or (AccAss.Type not in ('CP','DC','QS','QP','S1','S2','S3','AF','XP','FO','FP','FX','IR','IT','IX','BB','BA','BC','BP','BD','OP','OR') and AccAss.Code not in ('F','D'))) then 1 Else 0 End     
		end)    
		*(Case   
		When SysTab.TaxMethod in (3) and ((AccAss.Type in ('BB','BA','BC','BP','BD'))) Then  
			case When RateTab.VATCommissionF=1 and (Case When Acceptance.ISType not in ('R','N','T','Q','S','A','X','P') or Profile.VATCOMMEXEMPTIF=0 Then cast(1 as Bit) Else 0 END)=1 then 1 else 0 end    	
		Else
			1
		End)
		*(Case   
		When SysTab.TaxMethod in (0,3,4) Then  
			Case When ((AccAss.Type in ('BB','BA','BC','BP','BD','OP','OR')) or ((AccAss.Type not in ('BB','BA','BC','BP','BD','OP','OR','DI','IC','CF','JP','BO') and TOC.VATBusinessF=1) or (Insured.VATF=1 and TOC.VATBusinessF=1))) Then 1 Else 0 End  
		Else  
			Case When ((AccAss.Type in ('BB','BA','BC','BP','BD','OP','OR')) or ((AccAss.Type not in ('BB','BA','BC','BP','BD','OP','OR','DI','IC','CF','JP','BO')) or (Insured.VATF=1 and TOC.VATBusinessF=1))) Then 1 Else 0 End  
		End)
	 *(Case When Profile.VatF=1 or AccAss.Type in ('DI','IC','CF','JP','BO') Then 1 else 0 end)  
	 *(Case When Acceptance.NoRefundF=7 and AccAss.Type in ('BB','BA','BO','BC','BP','BD') and AccAss.Code in ('C','O') then 0 else 1 end)  
	 *(Case When Acceptance.NoRefundF in (8,10,14) then 0 else 1 end)  
	 )  
	 ,Accass.Currency)  
	 *(Max(MParam.VAT)/100)  
	 +
	 dbo.roundccy(sum(case When AccAss.Code='V' Then AccAss.Amount else 0 End),Accass.Currency)
	When Round(Max(coalesce((Admlink.Amount-Admlink.Amount_11-Admlink.Amount_12-(Admlink.Amount_8+Admlink.Amount_13+Admlink.Amount_17+Admlink.Amount_18)-Admlink.Amount_14),0)),2)<>0 then   
	   sum((Admlink.Amount_13)*case When AccAss.Code<>'V' Then AccAss.Amount else 0 End)/Max(coalesce((Admlink.Amount-Admlink.Amount_11-Admlink.Amount_12-(Admlink.Amount_8+Admlink.Amount_13+Admlink.Amount_17+Admlink.Amount_18)-Admlink.Amount_14),0))  
	Else 
	   sum(case When AccAss.Code='V' Then AccAss.Amount else 0 End)
	end  
	as VAT,         
	Case   
	 When Max(Admlink.AdmNo) is null then  
	 dbo.roundccy(  
	 sum(  
	  AccAss.Amount  
	  *(Case  
		When SysTab.TaxMethod in (0,3) Then  
			Case When ((AccAss.Type in ('BB','BA','BC','BP','BD') and AccAss.Code in ('C','O')) or (AccAss.Type in ('OP','OR')) or (AccAss.Type in ('DI','IC','CF','JP','BO') and AccAss.Code in ('P','C','O','J','U')) or (AccAss.Type not in ('BB','BA','BC','BP','BD','OP','OP','DI','IC','CF','JP','BO') and AccAss.Code not in ('F','D'))) then 1 Else 0 End  
		When SysTab.TaxMethod in (4) Then  
			Case When ((AccAss.Type in ('BB','BA','BC','BP','BD') and AccAss.Code in ('C','O')) or (AccAss.Type in ('OP','OR')) or (AccAss.Type in ('DI','IC','CF','JP','BO') and AccAss.Code in ('P','C','D','O','J','U')) or (AccAss.Type not in ('BB','BA','BC','BP','BD','OP','OP','DI','IC','CF','JP','BO') and AccAss.Code not in ('F','D'))) then 1 Else 0 End  
		else  
			Case When ((AccAss.Type in ('CP','DC','QS','QP','S1','S2','S3','AF','XP','FO','FP','FX','IR','IT','IX') and AccAss.Code in ('C')) or (AccAss.Type in ('BB','BA','BC','BP','BD') and AccAss.Code in ('C','O')) or (AccAss.Type in ('OP','OR')) or (AccAss.Type not in ('CP','DC','QS','QP','S1','S2','S3','AF','XP','FO','FP','FX','IR','IT','IX','BB','BA','BC','BP','BD','OP','OR') and AccAss.Code not in ('F','D'))) then 1 Else 0 End     
		end)    
		*(Case   
		When SysTab.TaxMethod in (3) and ((AccAss.Type in ('BB','BA','BC','BP','BD'))) Then  
			case When RateTab.VATCommissionF=1 and (Case When Acceptance.ISType not in ('R','N','T','Q','S','A','X','P') or Profile.VATCOMMEXEMPTIF=0 Then cast(1 as Bit) Else 0 END)=1 then 1 else 0 end    	
		Else
			1
		End)
		*(Case   
		When SysTab.TaxMethod in (0,3,4) Then  
			Case When ((AccAss.Type in ('BB','BA','BC','BP','BD','OP','OR')) or ((AccAss.Type not in ('BB','BA','BC','BP','BD','OP','OR','DI','IC','CF','JP','BO') and TOC.VATBusinessF=1) or (Insured.VATF=1 and TOC.VATBusinessF=1))) Then 1 Else 0 End  
		Else  
			Case When ((AccAss.Type in ('BB','BA','BC','BP','BD','OP','OR')) or ((AccAss.Type not in ('BB','BA','BC','BP','BD','OP','OR','DI','IC','CF','JP','BO')) or (Insured.VATF=1 and TOC.VATBusinessF=1))) Then 1 Else 0 End  
		End)
	 *(Case When Profile.VatF=1 or AccAss.Type in ('DI','IC','CF','JP','BO') Then 1 else 0 end)  
	 *(Case When Acceptance.NoRefundF=7 and AccAss.Type in ('BB','BA','BO','BC','BP','BD') and AccAss.Code in ('C','O') then 0 else 1 end)  
	 *(Case When Acceptance.NoRefundF in (8,10,14) then 0 else 1 end)  
	 *(Case When SysTab.VATSubsidiesF=1 or Profile.VATSubsidiesF=1 then 1 else 0 end)  
	 *(Case When Accass.Type in ('BB','BA') Then 1 else 0 end)
	 )  
	 ,Accass.Currency)
	 *Case When (Max(MParam.VAT)/100)<0 Then -(Max(MParam.VAT)/100) else 0 end 
	 When Round(Max(coalesce((Admlink.Amount-Admlink.Amount_11-Admlink.Amount_12-(Admlink.Amount_8+Admlink.Amount_13+Admlink.Amount_17+Admlink.Amount_18)-Admlink.Amount_14),0)),2)<>0 then   
		Case 
		When round(Max(Admlink.Amount_13+Admlink.Amount_14),4)=round(Max(-Admlink.Amount_8),4) or round(Max(Admlink.Amount_13),4)=round(Max(-Admlink.Amount_8),4) then
			sum((-Admlink.Amount_13)*AccAss.Amount)/Max(coalesce((Admlink.Amount-Admlink.Amount_11-Admlink.Amount_12-(Admlink.Amount_8+Admlink.Amount_13+Admlink.Amount_17+Admlink.Amount_18)-Admlink.Amount_14),0))  
		else
		0
		end
	 Else 
	   0
	 end  
	as VATSubsidies,         
	Case   
	When Max(Admlink.AdmNo) is null then  
	 dbo.roundccy(  
	 sum(  
	 AccAss.Amount  
	  *(Case  
		When SysTab.TaxMethod in (0,3) Then  
			Case When ((AccAss.Type in ('BB','BA','BC','BP','BD') and AccAss.Code in ('C','O')) or (AccAss.Type in ('OP','OR')) or (AccAss.Type in ('DI','IC','CF','JP','BO') and AccAss.Code in ('P','C','O','J','U')) or (AccAss.Type not in ('BB','BA','BC','BP','BD','OP','OP','DI','IC','CF','JP','BO') and AccAss.Code not in ('F','D'))) then 1 Else 0 End  
		When SysTab.TaxMethod in (4) Then  
			Case When ((AccAss.Type in ('BB','BA','BC','BP','BD') and AccAss.Code in ('C','O')) or (AccAss.Type in ('OP','OR')) or (AccAss.Type in ('DI','IC','CF','JP','BO') and AccAss.Code in ('P','C','D','O','J','U')) or (AccAss.Type not in ('BB','BA','BC','BP','BD','OP','OP','DI','IC','CF','JP','BO') and AccAss.Code not in ('F','D'))) then 1 Else 0 End  
		else  
			Case When ((AccAss.Type in ('CP','DC','QS','QP','S1','S2','S3','AF','XP','FO','FP','FX','IR','IT','IX') and AccAss.Code in ('C')) or (AccAss.Type in ('BB','BA','BC','BP','BD') and AccAss.Code in ('C','O')) or (AccAss.Type in ('OP','OR')) or (AccAss.Type not in ('CP','DC','QS','QP','S1','S2','S3','AF','XP','FO','FP','FX','IR','IT','IX','BB','BA','BC','BP','BD','OP','OR') and AccAss.Code not in ('F','D'))) then 1 Else 0 End     
		end)    
		*(Case When Profile.BVatF=1 or AccAss.Type in ('DI','IC','CF','JP','BO') Then 1 else 0 end)  
 	    *(Case When Acceptance.NoRefundF<>11 and Acceptance.NoRefundF<>14 and AccAss.Type in ('DI','IC','CF','JP','BO') and Insured.BVatF=1 then 1 else 0 end)  
	 )  
	 ,Accass.Currency)  
	 *Max((Case When coalesce(Acceptance.OverwriteBVatF,0)=0 Then Branch.VAT else coalesce(Acceptance.BVATPCT,0) end)/100)  
	When Round(Max(coalesce((Admlink.Amount-Admlink.Amount_11-Admlink.Amount_12-(Admlink.Amount_8+Admlink.Amount_13+Admlink.Amount_17+Admlink.Amount_18)-Admlink.Amount_14),0)),2)<>0 then   
	 sum((Admlink.Amount_17)*AccAss.Amount)/Max(coalesce((Admlink.Amount-Admlink.Amount_11-Admlink.Amount_12-(Admlink.Amount_8+Admlink.Amount_13+Admlink.Amount_17+Admlink.Amount_18)-Admlink.Amount_14),0))  
	Else 0 end  
	as VAT_1,        
	Case   
	When Max(Admlink.AdmNo) is null then  
	 Case when Max(AccAss.Type) in ('DI','IC','CF','JP','BO') Then    
	  Case   
	  When Max(SysTab.TaxMethod)=2 then  
	   dbo.roundccy(  
	   sum(  
	   AccAss.Amount*Case When (AccAss.Type in ('DI','IC') and Accass.Code in ('P','O','U')) or (AccAss.Type in ('CF','JP') and AccAss.Code in ('P','O')) or (AccAss.Type in ('BO')) Then 1 else 0 end     
	   *coalesce(RateCov.Portion,0)/coalesce(pRCover.Portion, RCover.Portion)  
	   *(Case When Acceptance.NoRefundF<>11 and Acceptance.NoRefundF<>14 and AccAss.Type in ('DI','IC','CF','JP','BO') and Insured.TVatF=1 then 1 else 0 end)
	   )  
	   ,Accass.Currency)  
	  When Max(SysTab.TaxMethod)=3 then  
	   dbo.roundccy(  
	   sum(  
	   AccAss.Amount*Case When (AccAss.Type in ('DI','IC') and Accass.Code in ('P','O','U')) or (AccAss.Type in ('CF','JP') and AccAss.Code in ('P','O')) or (AccAss.Type in ('BO')) Then 1 else 0 end     
	   *case When RateTab.VATF=1 and RateTab.VATEXEMPTF=0 then 1 else 0 end  
	   *(Case When Acceptance.NoRefundF<>11 and Acceptance.NoRefundF<>14 and AccAss.Type in ('DI','IC','CF','JP','BO') and Insured.TVatF=1 then 1 else 0 end)
	   )  
	   ,Accass.Currency)  
	  Else  
	   dbo.roundccy(  
	   sum(  
		 AccAss.Amount  
		  *(Case  
			When SysTab.TaxMethod in (0,3) Then  
				Case When ((AccAss.Type in ('BB','BA','BC','BP','BD') and AccAss.Code in ('C','O')) or (AccAss.Type in ('OP','OR')) or (AccAss.Type in ('DI','IC','CF','JP','BO') and AccAss.Code in ('P','C','O','J','U')) or (AccAss.Type not in ('BB','BA','BC','BP','BD','OP','OP','DI','IC','CF','JP','BO') and AccAss.Code not in ('F','D'))) then 1 Else 0 End  
			When SysTab.TaxMethod in (4) Then  
				Case When ((AccAss.Type in ('BB','BA','BC','BP','BD') and AccAss.Code in ('C','O')) or (AccAss.Type in ('OP','OR')) or (AccAss.Type in ('DI','IC','CF','JP','BO') and AccAss.Code in ('P','C','D','O','J','U')) or (AccAss.Type not in ('BB','BA','BC','BP','BD','OP','OP','DI','IC','CF','JP','BO') and AccAss.Code not in ('F','D'))) then 1 Else 0 End  
			else  
				Case When ((AccAss.Type in ('CP','DC','QS','QP','S1','S2','S3','AF','XP','FO','FP','FX','IR','IT','IX') and AccAss.Code in ('C')) or (AccAss.Type in ('BB','BA','BC','BP','BD') and AccAss.Code in ('C','O')) or (AccAss.Type in ('OP','OR')) or (AccAss.Type not in ('CP','DC','QS','QP','S1','S2','S3','AF','XP','FO','FP','FX','IR','IT','IX','BB','BA','BC','BP','BD','OP','OR') and AccAss.Code not in ('F','D'))) then 1 Else 0 End     
			end)    
			*(Case   
			When SysTab.TaxMethod in (3) and ((AccAss.Type in ('BB','BA','BC','BP','BD'))) Then  
				case When RateTab.VATCommissionF=1 and (Case When Acceptance.ISType not in ('R','N','T','Q','S','A','X','P') or Profile.VATCOMMEXEMPTIF=0 Then cast(1 as Bit) Else 0 END)=1 then 1 else 0 end    	
			Else
				1
			End)    
			*(Case When Profile.TVatF=1 or (AccAss.Type in ('DI','IC','CF','JP','BO')) Then 1 else 0 end)  
		    *(Case When Acceptance.NoRefundF<>11 and Acceptance.NoRefundF<>14 and AccAss.Type in ('DI','IC','CF','JP','BO') and Insured.TVatF=1 then 1 else 0 end)		
	   )  
	   ,Accass.Currency)  
	  end      
	 else  
	  0  
	 end  
	 *Max((Case When coalesce(Acceptance.OverwriteTVatF,0)=0 Then TOC.VAT else coalesce(Acceptance.TVATPCT,0) end)/100)  
	When Round(Max(coalesce((Admlink.Amount-Admlink.Amount_11-Admlink.Amount_12-(Admlink.Amount_8+Admlink.Amount_13+Admlink.Amount_17+Admlink.Amount_18)-Admlink.Amount_14),0)),2)<>0 then   
	 sum((Admlink.Amount_18)*AccAss.Amount)/Max(coalesce((Admlink.Amount-Admlink.Amount_11-Admlink.Amount_12-(Admlink.Amount_8+Admlink.Amount_13+Admlink.Amount_17+Admlink.Amount_18)-Admlink.Amount_14),0))  
	Else 0 end  
	as VAT_2,   
	Case   
	When Max(Admlink.AdmNo) is null then  
	 dbo.roundccy(  
	 sum(  
	 -(  
	  Case   
	  When charindex(AccAss.Type,'FOFPQSQPS1S2S3AF')<>0  then  
	   Case   
	   When TaxType.MTaxType in ('PASAL21','PASAL23','PASAL4') Then  
		Case When AccAss.Code<>'P' then 1 else 0 end      
	   else  
		Case When AccAss.Code<>'C' then 1 else 0 end      
	   end  
	  Else  
	   1  
	  End  
	  *AccAss.Amount  
	  )  
	 *(Case When Profile.TaxF=1 Then 1 Else 0 End)  
	 *(Case   
	  When TaxType.MTaxType='PASAL21' Then   
	   Case When (Case When MParam.UseTaxTypeF=0 Then MParam.PASAL21 Else TaxType.TaxRate End)<>0 Then (Case When Profile.AccruedTax<>0 Then Profile.AccruedTax else (Case When MParam.UseTaxTypeF=0 Then MParam.PASAL21 Else TaxType.TaxRate End)*(100-MParam.TaxDiscount)/100 end) else 0 end/100    
	  When TaxType.MTaxType='PASAL23' Then  
	   Case When (Case When MParam.UseTaxTypeF=0 Then MParam.PASAL23 Else TaxType.TaxRate End)<>0 Then (Case When Profile.AccruedTax<>0 Then Profile.AccruedTax else (Case When MParam.UseTaxTypeF=0 Then MParam.PASAL23 Else TaxType.TaxRate End) end) else 0 end/100   
	  When TaxType.MTaxType='PASAL26' Then   
	   Case When (Case When MParam.UseTaxTypeF=0 Then MParam.PASAL26 Else TaxType.TaxRate End)<>0 Then (Case When Profile.AccruedTax<>0 Then Profile.AccruedTax else (Case When MParam.UseTaxTypeF=0 Then MParam.PASAL26 Else TaxType.TaxRate End) end) else 0 end/100  
	  When TaxType.MTaxType='PASAL4' Then   
	   Case When (Case When MParam.UseTaxTypeF=0 Then MParam.PASAL4 Else TaxType.TaxRate End)<>0 Then (Case When Profile.AccruedTax<>0 Then Profile.AccruedTax else (Case When MParam.UseTaxTypeF=0 Then MParam.PASAL4 Else TaxType.TaxRate End) end) else 0 end/100  
	  ELSE Profile.AccruedTax/100  
	  END)  
	 *Case When coalesce(Profile.TaxPCT,0)=0 then 1 else Profile.TaxPCT/100 end  
	 *(Case When Acceptance.NoRefundF=7 and AccAss.Type in ('BB','BA','BO','BC','BP','BD') and AccAss.Code in ('C') then 0 else 1 end)  
	 *(Case When Acceptance.NoRefundF in (9,10) then 0 else 1 end)  
	 )  
	 ,AccAss.Currency)  
	When Round(Max(coalesce((Admlink.Amount-Admlink.Amount_11-Admlink.Amount_12-(Admlink.Amount_8+Admlink.Amount_13+Admlink.Amount_17+Admlink.Amount_18)-Admlink.Amount_14),0)),2)<>0 then   
	 sum((Admlink.Amount_14)*AccAss.Amount)/Max(coalesce((Admlink.Amount-Admlink.Amount_11-Admlink.Amount_12-(Admlink.Amount_8+Admlink.Amount_13+Admlink.Amount_17+Admlink.Amount_18)-Admlink.Amount_14),0))  
	Else 0 end  
	as TAX,
	Case   
	When Max(Admlink.AdmNo) is null then  
	 dbo.roundccy(  
	 sum(  
	 -(  
	  Case   
	  When charindex(AccAss.Type,'FOFPQSQPS1S2S3AF')<>0  then  
	   Case   
	   When TaxType.MTaxType in ('PASAL21','PASAL23','PASAL4') Then  
		Case When AccAss.Code<>'P' then 1 else 0 end      
	   else  
		Case When AccAss.Code<>'C' then 1 else 0 end      
	   end  
	  Else  
	   1  
	  End  
	  *AccAss.Amount  
	  )  
	 *(Case When Profile.TaxF=1 Then 1 Else 0 End)  
	 *(Case   
	  When TaxType.MTaxType='PASAL21' Then   
	   Case When (Case When MParam.UseTaxTypeF=0 Then MParam.PASAL21 Else TaxType.TaxRate End)<>0 Then (Case When Profile.AccruedTax<>0 Then Profile.AccruedTax else (Case When MParam.UseTaxTypeF=0 Then MParam.PASAL21 Else TaxType.TaxRate End)*(100-MParam.TaxDiscount)/100 end) else 0 end/100    
	  When TaxType.MTaxType='PASAL23' Then  
	   Case When (Case When MParam.UseTaxTypeF=0 Then MParam.PASAL23 Else TaxType.TaxRate End)<>0 Then (Case When Profile.AccruedTax<>0 Then Profile.AccruedTax else (Case When MParam.UseTaxTypeF=0 Then MParam.PASAL23 Else TaxType.TaxRate End) end) else 0 end/100   
	  When TaxType.MTaxType='PASAL26' Then   
	   Case When (Case When MParam.UseTaxTypeF=0 Then MParam.PASAL26 Else TaxType.TaxRate End)<>0 Then (Case When Profile.AccruedTax<>0 Then Profile.AccruedTax else (Case When MParam.UseTaxTypeF=0 Then MParam.PASAL26 Else TaxType.TaxRate End) end) else 0 end/100  
	  When TaxType.MTaxType='PASAL4' Then   
	   Case When (Case When MParam.UseTaxTypeF=0 Then MParam.PASAL4 Else TaxType.TaxRate End)<>0 Then (Case When Profile.AccruedTax<>0 Then Profile.AccruedTax else (Case When MParam.UseTaxTypeF=0 Then MParam.PASAL4 Else TaxType.TaxRate End) end) else 0 end/100  
	  ELSE Profile.AccruedTax/100  
	  END)  
	 *Case When coalesce(Profile.TaxPCT,0)=0 then 1 else Profile.TaxPCT/100 end  
	 *(Case When Acceptance.NoRefundF=7 and AccAss.Type in ('BB','BA','BO','BC','BP','BD') and AccAss.Code in ('C') then 0 else 1 end)  
	 *(Case When Acceptance.NoRefundF in (9,10) then 0 else 1 end)  
	 *(Case When Profile.TAXSubsidiesF=1 then -1 else 0 end)  
	 *(Case When Accass.Type in ('BB','BA') Then 1 else 0 end)
	 )  
	 ,AccAss.Currency)  
	When Round(Max(coalesce((Admlink.Amount-Admlink.Amount_11-Admlink.Amount_12-(Admlink.Amount_8+Admlink.Amount_13+Admlink.Amount_17+Admlink.Amount_18)-Admlink.Amount_14),0)),2)<>0 then   
		Case 
		When round(Max(Admlink.Amount_13+Admlink.Amount_14),4)=round(Max(-Admlink.Amount_8),4) or round(Max(Admlink.Amount_14),4)=round(Max(-Admlink.Amount_8),4) then
			sum((-Admlink.Amount_14)*AccAss.Amount)/Max(coalesce((Admlink.Amount-Admlink.Amount_11-Admlink.Amount_12-(Admlink.Amount_8+Admlink.Amount_13+Admlink.Amount_17+Admlink.Amount_18)-Admlink.Amount_14),0))  
		else
		0
		end
	Else 0 end  
	as TAXSubsidies
	FROM Acceptance   
	Inner Join Cover on (Cover.CNO=Acceptance.CNO)  
	Inner Join TOC on (TOC.TOC=Acceptance.TOC)  
	Inner Join Branch on (Branch.Branch=Acceptance.Branch)  
	Inner Join Profile Insured on (Insured.ID=Acceptance.AID)  
	Inner Join AccAss on (Acceptance.ANO=AccAss.ANO)  
	Left Join APayor on (APayor.ANO=Acceptance.ANO and Acceptance.LANO<>-1 and Acceptance.ANO<>Acceptance.LANO)                                
	Left Join Payor on (Payor.ANO=Acceptance.ANO and Acceptance.LANO=-1)                
	Left Join Acceptance pAcceptance on (pAcceptance.ANO=Acceptance.pANO)  
	Left Join Admlink on (Admlink.AdmNo=AccAss.AdmNo and not ((Acceptance.LANO<>-1 and Cover.OpenFlag=0) or (Acceptance.BulkF=1))) 
	Inner Join Profile on (Profile.ID=AccAss.ID)  
	Left Join TaxType on (TaxType.TaxType=Profile.TaxType)  
	Inner Join Mparam on (MParam.Type=AccAss.Type)  
	Outer Apply (
		Select Top 1 mPayor.ANO, mPayor.PolicyYearF 
		from Acceptance mAcceptance, Cover mCover, Payor mPayor
		Where mCover.CNO=mAcceptance.CNO and mPayor.ANO=mAcceptance.ANO and mAcceptance.ANO=mAcceptance.LANO and MAcceptance.PolicyNo=@PolicyNo and MAcceptance.RegNo=@MRegNo and mCover.ASource=@ASource 
	) mPayor
	Inner Join SysTab on (1=1)  
	Left Join RateTab on (RateTab.Code=AccAss.RCode)  
	Left Join RCover on (RCover.ANO=Acceptance.ANO and RCover.Code=AccAss.RCode and RCover.SDate=AccAss.SDate)  
	Left Join RCover pRCover on (AccAss.CAmount=0 and pRCover.ANO=Acceptance.pANO and pRCover.Code=AccAss.RCode and pRCover.SDate=AccAss.SDate)  
	Outer apply (Select sum(RateCov.Portion) as Portion from RateCov Where RateCov.Code=AccAss.RCode and RateCov.VatF=1) as RateCov  
	WHERE Acceptance.ANO=@P_ANO          
	GROUP BY AccAss.ID, Profile.Name, AccAss.Type, AccAss.Posted, AccAss.Admno, AccAss.Currency, Acceptance.RegNo, Accass.DocNo, AccAss.RefNo,        
	Case When AccAss.CAmount=0 and Coalesce(pAcceptance.Branch,'')<>'' Then pAcceptance.Branch Else Acceptance.Branch end,   
	dbo.fn_Get_UWYear(Acceptance.SDate, Acceptance.EDate, 
	Case When (Case When isnull(APayor.ANO,0)=0 Then (Case When isnull(MPayor.ANO,0)=0 Then Payor.PolicyYearF else MPayor.PolicyYearF end) else APayor.PolicyYearF end)=1 Then AccAss.SDate else Acceptance.SDate end)   

End

GO

DROP PROCEDURE View16
GO
CREATE PROCEDURE View16 (@P_ANO as integer)
AS
SELECT Cover.CoverNo, Cover.CoverDate, Cover.ExpDate, ISource.RType, Acceptance.RegNo, Acceptance.ANO, Payor.ID, Profile.Name, Acceptance.AStatus, Acceptance.TOC, TOC.Description, Acceptance.Branch
FROM Cover, ISource, Acceptance, Payor, Profile, TOC
WHERE Acceptance.ANO=Acceptance.LANO And Cover.CNO=Acceptance.CNO And ISource.CNO=Cover.CNO And Payor.ANO=Acceptance.ANO And Acceptance.ISType='T' And Profile.ID=Payor.ID And TOC.TOC=ACCEPTANCE.TOC And Acceptance.ANO=@P_ANO

GO

DROP FUNCTION DISPLAY_CALCULATION
GO
CREATE FUNCTION DISPLAY_CALCULATION(@P_ANO int)                
RETURNS @PCALC TABLE (ANO Int, INO Int, Code varchar(10), SDate smalldatetime, EDate smalldatetime, Gross Float, TSI Float, Prorata Float, Currency varchar(10), Premium_Calculation Varchar(Max), Prorata_Calculation Varchar(Max), Calculation Varchar(Max), 
Discount Float, Commission Float)
AS
BEGIN
Declare @CalculationRoundingF Bit
Select @CalculationRoundingF=CalculationRoundingF from systab

if @CalculationRoundingF=0
	insert into @PCalc
	Select A.ANO, D1.INO, D1.Code, D1.SDate, D1.EDate, D1.Gross, D1.TSI, D2.Prorata, D1.Currency,  D1.Calculation as Premium_Calculation, D2.Prorata_Calculation,                
	D1.Calculation     
	+ Case When D2.Prorata=0 or D2.Prorata_Calculation='' Then '' else ' x '+D2.Prorata_Calculation end                
	+ Case When A.Qty>1 Then ' x '+ Convert(varchar(25), Cast(A.Qty as Int),1) Else '' end                
	+ ' = '     
	+ 
	Case 
	When convert(varchar(50), cast(D1.Gross*(Case When D2.Prorata<>0 or D2.Prorata_Calculation<>'' Then D2.Prorata else 1 end)*Case When A.Qty>1 Then A.Qty Else 1 End as Money),1)<>'0.00' Then
		convert(varchar(50), cast(D1.Gross*(Case When D2.Prorata<>0 or D2.Prorata_Calculation<>'' Then D2.Prorata else 1 end)*Case When A.Qty>1 Then A.Qty Else 1 End as Money),1)
	else
		convert(varchar(50), D1.Gross*(Case When D2.Prorata<>0 or D2.Prorata_Calculation<>'' Then D2.Prorata else 1 end)*Case When A.Qty>1 Then A.Qty Else 1 End,1)
	end
	as Calculation,                
	dbo.Premium_Discount(D1.ANO, D1.Code,cast(datediff(Month,A.SDate, D1.SDate) as integer) / 12 + 1) as Discount, dbo.Premium_Commission(D1.ANO, D1.Code,cast(datediff(Month,A.SDate, D1.SDate) as integer) / 12 + 1,0) as Commission                
	from Display_Gross_Calculation(@P_ANO) D1, Display_Prorata_Calculation(@P_ANO) D2, Acceptance A                
	Where a.ANO = D1.ANO And D1.ANO = D2.ANO And D1.Currency = D2.Currency And D1.Code = D2.Code And D1.SDate = D2.SDate And D1.EDate = D2.EDate and D2.Prorata<>0                 
else
	insert into @PCalc
	Select A.ANO, D1.INO, D1.Code, D1.SDate, D1.EDate, D1.Gross, D1.TSI, D2.Prorata, D1.Currency,  D1.Calculation as Premium_Calculation, D2.Prorata_Calculation,                
	D1.Calculation     
	+ Case When D2.Prorata=0 or D2.Prorata_Calculation='' Then '' else ' x '+D2.Prorata_Calculation end                
	+ Case When A.Qty>1 Then ' x '+ Convert(varchar(25), Cast(A.Qty as Int),1) Else '' end                
	+ ' = '     
	+ 
	Case 
	When convert(varchar(50), cast(dbo.RoundCCY(D1.Gross*(Case When D2.Prorata<>0 or D2.Prorata_Calculation<>'' Then D2.Prorata else 1 end)*Case When A.Qty>1 Then A.Qty Else 1 End, D1.Currency) as Money),1)<>'0.00' Then
		convert(varchar(50), cast(dbo.RoundCCY(D1.Gross*(Case When D2.Prorata<>0 or D2.Prorata_Calculation<>'' Then D2.Prorata else 1 end)*Case When A.Qty>1 Then A.Qty Else 1 End, D1.Currency) as Money),1)
	else
		convert(varchar(50), dbo.RoundCCY(D1.Gross*(Case When D2.Prorata<>0 or D2.Prorata_Calculation<>'' Then D2.Prorata else 1 end)*Case When A.Qty>1 Then A.Qty Else 1 End, D1.Currency),1)
	end
	as Calculation,                
	dbo.Premium_Discount(D1.ANO, D1.Code,cast(datediff(Month,A.SDate, D1.SDate) as integer) / 12 + 1) as Discount, dbo.Premium_Commission(D1.ANO, D1.Code,cast(datediff(Month,A.SDate, D1.SDate) as integer) / 12 + 1,0) as Commission                
	from Display_Gross_Calculation(@P_ANO) D1, Display_Prorata_Calculation(@P_ANO) D2, Acceptance A                
	Where a.ANO = D1.ANO And D1.ANO = D2.ANO And D1.Currency = D2.Currency And D1.Code = D2.Code And D1.SDate = D2.SDate And D1.EDate = D2.EDate and D2.Prorata<>0                 


RETURN 

END

GO
DROP FUNCTION DISPLAY_CANCELLATION_CALCULATION
GO
CREATE FUNCTION DISPLAY_CANCELLATION_CALCULATION(@P_ANO int, @P_PDate as smalldatetime, @P_CPCT Float, @P_NoRefundF Int, @P_RefundType varchar(255))          
RETURNS @PCALC TABLE (ANO Int, INO Int, Code varchar(10), SDate smalldatetime, EDate smalldatetime, Gross Float, TSI Float, Prorata Float, Currency varchar(10), Premium_Calculation Varchar(Max), Prorata_Calculation Varchar(Max), Calculation Varchar(Max), Discount Float, Commission Float)
AS
BEGIN
Declare @CalculationRoundingF Bit
Select @CalculationRoundingF=CalculationRoundingF from systab

if @CalculationRoundingF=0
	insert into @PCalc
	Select A.ANO, D1.INO, D1.Code, D1.SDate, D1.EDate, D1.Gross, D1.TSI, D2.Prorata, D1.Currency,  D1.Calculation as Premium_Calculation, D2.Prorata_Calculation,                
	D1.Calculation     
	+ Case When D2.Prorata=0 or D2.Prorata_Calculation='' Then '' else ' x '+D2.Prorata_Calculation end                
	+ Case When A.Qty>1 Then ' x '+ Convert(varchar(25), Cast(A.Qty as Int),1) Else '' end                
	+ ' = '     
	+ 
	Case 
	When convert(varchar(50), cast(D1.Gross*(Case When D2.Prorata<>0 or D2.Prorata_Calculation<>'' Then D2.Prorata else 1 end)*Case When A.Qty>1 Then A.Qty Else 1 End as Money),1)<>'0.00' Then
		convert(varchar(50), cast(D1.Gross*(Case When D2.Prorata<>0 or D2.Prorata_Calculation<>'' Then D2.Prorata else 1 end)*Case When A.Qty>1 Then A.Qty Else 1 End as Money),1)
	else
		convert(varchar(50), D1.Gross*(Case When D2.Prorata<>0 or D2.Prorata_Calculation<>'' Then D2.Prorata else 1 end)*Case When A.Qty>1 Then A.Qty Else 1 End,1)
	end
	as Calculation,                
	dbo.Premium_Discount(D1.ANO, D1.Code,cast(datediff(Month,A.SDate, D1.SDate) as integer) / 12 + 1) as Discount, dbo.Premium_Commission(D1.ANO, D1.Code,cast(datediff(Month,A.SDate, D1.SDate) as integer) / 12 + 1,0) as Commission                
	from Display_Gross_Cancellation_Calculation(@P_ANO) D1, Display_Prorata_Cancellation_Calculation(@P_ANO, @P_PDate, @P_CPCT, @P_NoRefundF, @P_RefundType) D2, Acceptance A                
	Where a.ANO = D1.ANO And D1.ANO = D2.ANO And D1.Currency = D2.Currency And D1.Code = D2.Code And D1.SDate = D2.SDate And D1.EDate = D2.EDate and D2.Prorata<>0                 
else
	insert into @PCalc
	Select A.ANO, D1.INO, D1.Code, D1.SDate, D1.EDate, D1.Gross, D1.TSI, D2.Prorata, D1.Currency,  D1.Calculation as Premium_Calculation, D2.Prorata_Calculation,                
	D1.Calculation     
	+ Case When D2.Prorata=0 or D2.Prorata_Calculation='' Then '' else ' x '+D2.Prorata_Calculation end                
	+ Case When A.Qty>1 Then ' x '+ Convert(varchar(25), Cast(A.Qty as Int),1) Else '' end                
	+ ' = '     
	+ 
	Case 
	When convert(varchar(50), cast(dbo.RoundCCY(D1.Gross*(Case When D2.Prorata<>0 or D2.Prorata_Calculation<>'' Then D2.Prorata else 1 end)*Case When A.Qty>1 Then A.Qty Else 1 End, D1.Currency) as Money),1)<>'0.00' Then
		convert(varchar(50), cast(dbo.RoundCCY(D1.Gross*(Case When D2.Prorata<>0 or D2.Prorata_Calculation<>'' Then D2.Prorata else 1 end)*Case When A.Qty>1 Then A.Qty Else 1 End, D1.Currency) as Money),1)
	else
		convert(varchar(50), dbo.RoundCCY(D1.Gross*(Case When D2.Prorata<>0 or D2.Prorata_Calculation<>'' Then D2.Prorata else 1 end)*Case When A.Qty>1 Then A.Qty Else 1 End, D1.Currency),1)
	end
	as Calculation,                
	dbo.Premium_Discount(D1.ANO, D1.Code,cast(datediff(Month,A.SDate, D1.SDate) as integer) / 12 + 1) as Discount, dbo.Premium_Commission(D1.ANO, D1.Code,cast(datediff(Month,A.SDate, D1.SDate) as integer) / 12 + 1,0) as Commission                
	from Display_Gross_Cancellation_Calculation(@P_ANO) D1, Display_Prorata_Cancellation_Calculation(@P_ANO, @P_PDate, @P_CPCT, @P_NoRefundF, @P_RefundType) D2, Acceptance A                
	Where a.ANO = D1.ANO And D1.ANO = D2.ANO And D1.Currency = D2.Currency And D1.Code = D2.Code And D1.SDate = D2.SDate And D1.EDate = D2.EDate and D2.Prorata<>0                 


RETURN 

END


GO



DROP Function FN_Approval_Production
GO
CREATE Function FN_Approval_Production(@P_ANO int)   
RETURNS @Table TABLE (REGID varchar(10), FLDID varchar(255), VALUEID varchar(255), CertificateNo varchar(10), Branch varchar(10), TOC varchar(10), ISType varchar(10), ApprLimitPCT Float, Amount Float, TotalAmount Float)  
AS   
BEGIN   
Declare @ApplyApprLimitByAccRegF as Bit
Declare @ApplyApprLimitByTOLF as Bit
Declare @ApplyApprLimitOCF as Bit
Declare @LANO as int
Declare @OpenFlag as Bit
Declare @TOC as varchar(10)
Declare @Branch as varchar(10)
Declare @ISType as varchar(10)
Declare @PHolder as varchar(10)

Declare @NoRiskAccumulationF as Bit

Select @NoRiskAccumulationF=A.NoRiskAccumulationF, @TOC=A.TOC, @Branch=A.Branch, @ISType=A.ISType, @PHolder=C.PHolder, @LANO=A.LANO, @OpenFlag=C.OpenFlag, @ApplyApprLimitByTOLF=TOC.ApplyApprLimitByTOLF, @ApplyApprLimitByAccRegF=TOC.ApplyApprLimitByAccRegF, @ApplyApprLimitOCF=TOC.ApplyApprLimitOCF
from Acceptance A
Inner Join Cover C on (C.CNO=A.CNO)
Inner Join TOC on (TOC.TOC=A.TOC)
Where A.ANO=@P_ANO

if @ApplyApprLimitByAccRegF=0 
	if @P_ANO<>@LANO
	Begin
		if @OpenFlag=0
			Insert into @Table
			SELECT top 1 Acceptance.RegID, Acceptance.FLDID, Acceptance.ValueID, Case When Acceptance.ValueID='' Then Acceptance.CertificateNo else '' end as CertificateNo,
			@Branch as Branch,    
			@TOC as TOC, 
			@ISType as ISType,
			Case When @ApplyApprLimitByTOLF=1 Then RARRHEADER.CLIMIT*RARRHEADER.LIMIT*100 ELSE 100 END as ApprLimitPct,  
			(RArrHeader.TAmount-RArrHeader.MAmount) as Amount,
			cast(0 as Float) as TotalAmount
			From Acceptance
			Inner Join RARRHEADER on (RArrheader.ANO=Acceptance.ANO)
			WHERE Acceptance.ANO=@P_ANO
		else
			Insert into @Table
			SELECT top 1 Acceptance.RegID, Acceptance.FLDID, Acceptance.ValueID, Case When Acceptance.ValueID='' Then Acceptance.CertificateNo else '' end as CertificateNo,
			@Branch as Branch,    
			@TOC as TOC, 
			@ISType as ISType,
			Case When @ApplyApprLimitByTOLF=1 Then RARRHEADER.CLIMIT*RARRHEADER.LIMIT*100 ELSE 100 END as ApprLimitPct,  
			(RArrHeader.TAmount-RArrHeader.MAmount) as Amount,
			cast(0 as Float) as TotalAmount
			From Acceptance
			Inner Join RARRHEADER on (RArrheader.ANO=Acceptance.ANO)
			WHERE Acceptance.ANO=@P_ANO
			-- No Master Acceptance Limit Of Liability
			and (@ApplyApprLimitOCF=1 or not exists (Select Top 1 mA.ANO from Acceptance mA Inner Join ICover I on (I.ANO=mA.ANO) Where mA.ANO=Acceptance.LANO and I.Category='M' and I.Amount<>0))			
	end
	else 
	Begin
		if @OpenFlag=1	--Master Open Cover
			Insert into @Table
			SELECT top 1 Acceptance.RegID, Acceptance.FLDID, Acceptance.ValueID, Case When Acceptance.ValueID='' Then Acceptance.CertificateNo else '' end as CertificateNo,
			@Branch as Branch,    
			@TOC as TOC, 
			@ISType as ISType,
			100 as ApprLimitPct,  
			sum(ICover.Amount*dbo.fn_GetReinsuranceRate(Acceptance.TOC,ICover.Currency,Acceptance.SDate,@PHolder)) 
			* coalesce((Select sum(Share) from ISource Where ISource.CNO=Acceptance.CNO),100)/100				
			* (100-coalesce((Select sum(Share) from Coinsurance Where CNO=Acceptance.CNO),0))/100				
			as Amount,
			cast(0 as Float) as TotalAmount
			From Acceptance
			Inner Join ICover on (ICover.ANO=Acceptance.ANO)
			WHERE Acceptance.ANO=@P_ANO
			and ICover.Category='M'
			Group by Acceptance.CNO, Acceptance.RegID, Acceptance.FLDID, Acceptance.ValueID, Case When Acceptance.ValueID='' Then Acceptance.CertificateNo else '' end
		else
			if @NoRiskAccumulationF=0 
				Insert into @Table
				SELECT top 1 Acceptance.RegID, Acceptance.FLDID, Acceptance.ValueID, Case When Acceptance.ValueID='' Then Acceptance.CertificateNo else '' end as CertificateNo,
				@Branch as Branch,    
				@TOC as TOC, 
				@ISType as ISType,
				Max(Case When @ApplyApprLimitByTOLF=1 Then RARRHEADER.CLIMIT*RARRHEADER.LIMIT*100 ELSE 100 END) as ApprLimitPct,  
				sum(RArrHeader.TAmount-RArrHeader.MAmount) as Amount,
				cast(0 as Float) as TotalAmount
				From Acceptance mA
				Inner join Acceptance omA on (omA.OANO=mA.OANO)
				Inner Join Acceptance on (Acceptance.LANO=omA.ANO)
				Left Join Acceptance nAcceptance on (nAcceptance.pANO=Acceptance.ANO)
				Inner Join RARRHEADER on (RArrheader.ANO=Acceptance.ANO)
				WHERE mA.ANO=@P_ANO 
				and Acceptance.AType not in ('A','C') and Acceptance.AStatus in ('W','T','I') 
				and (coalesce(nAcceptance.ANO,0)=0 or (coalesce(nAcceptance.LANO,0)=mA.ANO and coalesce(nAcceptance.AType,'')='C' and mA.AType='C'))
				Group By Acceptance.RegID, Acceptance.FLDID, Acceptance.ValueID, Case When Acceptance.ValueID='' Then Acceptance.CertificateNo else '' end
				Order By sum(RArrHeader.TAmount-RArrHeader.MAmount) Desc            
			else
				Insert into @Table
				SELECT top 1 Acceptance.RegID, Acceptance.FLDID, Acceptance.ValueID, Case When Acceptance.ValueID='' Then Acceptance.CertificateNo else '' end as CertificateNo,
				@Branch as Branch,    
				@TOC as TOC, 
				@ISType as ISType,
				Max(Case When @ApplyApprLimitByTOLF=1 Then RARRHEADER.CLIMIT*RARRHEADER.LIMIT*100 ELSE 100 END) as ApprLimitPct,  
				sum(RArrHeader.TAmount-RArrHeader.MAmount) as Amount,
				cast(0 as Float) as TotalAmount
				From Acceptance mA
				Inner Join Acceptance on (Acceptance.LANO=mA.ANO and Acceptance.RegNo=mA.RegNo)
				Inner Join RARRHEADER on (RArrheader.ANO=Acceptance.ANO)
				WHERE mA.ANO=@P_ANO 
				Group By Acceptance.RegID, Acceptance.FLDID, Acceptance.ValueID, Case When Acceptance.ValueID='' Then Acceptance.CertificateNo else '' end
				Order By sum(RArrHeader.TAmount-RArrHeader.MAmount) Desc            
	end
else
	if @P_ANO<>@LANO
	Begin
		if @OpenFlag=0
			Insert into @Table
			SELECT top 1 Acceptance.RegID, Acceptance.FLDID, Acceptance.ValueID, Case When Acceptance.ValueID='' Then Acceptance.CertificateNo else '' end as CertificateNo,
			@Branch as Branch,    
			@TOC as TOC, 
			@ISType as ISType,
			Case When @ApplyApprLimitByTOLF=1 Then RARRHEADER.CLIMIT*RARRHEADER.LIMIT*100 ELSE 100 END as ApprLimitPct,  
			(RArrHeader.TAmount-RArrHeader.MAmount) as Amount,
			(RArrHeader.TAmount-RArrHeader.MAmount)+coalesce(dbo.fn_GetTotalSumInsured(Acceptance.SDate,Acceptance.RegID, Acceptance.FLDID, Acceptance.ValueID,Acceptance.OANO),0) as TotalAmount
			From Acceptance
			Inner Join RARRHEADER on (RArrheader.ANO=Acceptance.ANO)
			WHERE Acceptance.ANO=@P_ANO
		else
			Insert into @Table
			SELECT top 1 Acceptance.RegID, Acceptance.FLDID, Acceptance.ValueID, Case When Acceptance.ValueID='' Then Acceptance.CertificateNo else '' end as CertificateNo,
			@Branch as Branch,    
			@TOC as TOC, 
			@ISType as ISType,
			Case When @ApplyApprLimitByTOLF=1 Then RARRHEADER.CLIMIT*RARRHEADER.LIMIT*100 ELSE 100 END as ApprLimitPct,  
			(RArrHeader.TAmount-RArrHeader.MAmount) as Amount,
			(RArrHeader.TAmount-RArrHeader.MAmount)+coalesce(dbo.fn_GetTotalSumInsured(Acceptance.SDate,Acceptance.RegID, Acceptance.FLDID, Acceptance.ValueID,Acceptance.OANO),0) as TotalAmount
			From Acceptance
			Inner Join RARRHEADER on (RArrheader.ANO=Acceptance.ANO)
			WHERE Acceptance.ANO=@P_ANO
			-- No Master Acceptance Limit Of Liability
			and (@ApplyApprLimitOCF=1 or not exists (Select Top 1 mA.ANO from Acceptance mA Inner Join ICover I on (I.ANO=mA.ANO) Where mA.ANO=Acceptance.LANO and I.Category='M' and I.Amount<>0))
	end
	else 
	Begin
		if @OpenFlag=1	--Master Open Cover
			Insert into @Table
			SELECT top 1 Acceptance.RegID, Acceptance.FLDID, Acceptance.ValueID, Case When Acceptance.ValueID='' Then Acceptance.CertificateNo else '' end as CertificateNo,
			@Branch as Branch,    
			@TOC as TOC, 
			@ISType as ISType,
			100 as ApprLimitPct,  
			sum(ICover.Amount*dbo.fn_GetReinsuranceRate(Acceptance.TOC,ICover.Currency,Acceptance.SDate,@PHolder)) 
			* coalesce((Select sum(Share) from ISource Where ISource.CNO=Acceptance.CNO),100)/100				
			* (100-coalesce((Select sum(Share) from Coinsurance Where CNO=Acceptance.CNO),0))/100				
			as Amount,
			cast(0 as Float) as TotalAmount
			From Acceptance
			Inner Join ICover on (ICover.ANO=Acceptance.ANO)
			WHERE Acceptance.ANO=@P_ANO
			and ICover.Category='M'
			Group by Acceptance.CNO, Acceptance.RegID, Acceptance.FLDID, Acceptance.ValueID, Case When Acceptance.ValueID='' Then Acceptance.CertificateNo else '' end
		else
			Insert into @Table
			SELECT top 1 Acceptance.RegID, Acceptance.FLDID, Acceptance.ValueID, Case When Acceptance.ValueID='' Then Acceptance.CertificateNo else '' end as CertificateNo,
			@Branch as Branch,    
			@TOC as TOC, 
			@ISType as ISType,
			Max(Case When @ApplyApprLimitByTOLF=1 Then RARRHEADER.CLIMIT*RARRHEADER.LIMIT*100 ELSE 100 END) as ApprLimitPct,  
			Sum(RArrHeader.TAmount-RArrHeader.MAmount) as Amount,
			Sum(RArrHeader.TAmount-RArrHeader.MAmount)+coalesce(dbo.fn_GetTotalSumInsured(Min(Acceptance.SDate),Acceptance.RegID, Acceptance.FLDID, Acceptance.ValueID,Max(mA.OANO)),0) as TotalAmount
			From Acceptance mA
			Inner join Acceptance omA on (omA.OANO=mA.OANO)
			Inner Join Acceptance on (Acceptance.LANO=omA.ANO)
			Left Join Acceptance nAcceptance on (nAcceptance.pANO=Acceptance.ANO)
			Inner Join RARRHEADER on (RArrheader.ANO=Acceptance.ANO)
			WHERE mA.ANO=@P_ANO 
			and Acceptance.AType not in ('A','C') and Acceptance.AStatus in ('W','T','I') 
			and (coalesce(nAcceptance.ANO,0)=0 or (coalesce(nAcceptance.LANO,0)=mA.ANO and coalesce(nAcceptance.AType,'')='C' and mA.AType='C'))
			Group By Acceptance.RegID, Acceptance.FLDID, Acceptance.ValueID, Case When Acceptance.ValueID='' Then Acceptance.CertificateNo else '' end
			Order By Sum(RArrHeader.TAmount-RArrHeader.MAmount)+coalesce(dbo.fn_GetTotalSumInsured(Min(Acceptance.SDate),Acceptance.RegID, Acceptance.FLDID, Acceptance.ValueID,Max(mA.OANO)),0) Desc  
	end

	Return
END


GO

DROP Function fn_GetClaimApprovalActionUser
GO
CREATE Function fn_GetClaimApprovalActionUser(@ActionCode varchar(30), @CNO int)   
RETURNS @ActionUser TABLE (ID varchar(50), Name varchar(255), Type varchar(20), ApprovalLimit Float, LastRequestDate Smalldatetime)  
AS   
BEGIN   
 Declare @T table(ID varchar(50), Name varchar(255), Type varchar(20), TypeDesc varchar(255), ApprovalLimit Float)
 Declare @Type varchar(20)

 Declare @LOB Varchar(10)
 Declare @BType varchar(20)
 Declare @SType varchar(20)
 Declare @TOC varchar(10)
 Declare @Branch varchar(10)
 Declare @RCode varchar(10)
 Declare @ISType varchar(1)
 Declare @Amount Float
 Declare @ApprovalLimit Float

 Select 
 @LOB=coalesce(BS.LOB,''), 
 @BType=Case When A.ISTYPE in ('I','C','L') Then 'DIRECT' else 'INDIRECT' end, 
 @SType=Case When PT.STYPE in ('S') Then 'SINGLE' When PT.SType in ('M') Then 'MASTER' else 'OPEN' end,
 @TOC=fc.TOC,
 @Branch=fc.Branch,
 @ISType=fc.ISType,
 @Amount=fc.Amount,
 @RCode=fc.RCode
 from Claim 
 Inner join fn_Approval_Claim(@CNO) fC on (1=1)
 Inner join Acceptance A on (A.ANO=Claim.ANO)
 Inner join Cover C on (C.CNO=A.CNO) 
 Left Join PolicyType PT on (PT.PolicyType=C.PolicyType)
 Left Join Profile BS on (BS.ID=A.Source) 
 Where Claim.CNO=@CNO

 insert into @T
 Select S.ID, S.Name, S.Type, S.TypeDesc, S.ApprovalLimit 
 from
 (
	 Select S.ID, S.Name, S.Type, S.TypeDesc, 
	 dbo.GetApprovalLimit(S.ID, @TOC, @ISType,'Out_1', @Branch,0, @RCode) as ApprovalLimit
	 from
	 (
		Select Distinct S.*
		From
		( 
			Select S2.ID, S2.Name, S5.Type, S5.Description as TypeDesc
			from SysUser S2 
			Cross Apply (Select Top 1 S3.TOC from SysUserTOC S3 Where S3.ID=S2.ID and S3.TOC=@TOC and S3.EFFECTIVE<=cast(convert(varchar(10), getdate(),1) as smalldatetime) Order by S3.Effective Desc) S3
			Inner Join SysUserBranch S4 on (S4.ID=S2.ID and S4.ClaimHandlingF=1 and S4.Branch=@Branch)
			Inner Join SysUserType S5 on (S5.Type=S2.Type)
			Left Join ActionUser S1 on (S1.ActionCode=@ActionCode and S1.ActionUser=S2.ID)
			Left Join ActionUserDet A on (A.ActionCode=S1.ActionCode and A.ActionUser=S1.ActionUser)
			Where S2.AllowedF=1 and cast(convert(varchar(10), getdate(),1) as smalldatetime)<=S2.Expiry and S2.LockedF=0
			and coalesce(S1.ActionCode,'')=@ActionCode
			and (coalesce(A.ActionCode,'')='' or ((A.LOB='<ALL>' or A.LOB=@LOB) and (A.BTYPE='<ALL>' or A.BTYPE=@BTYPE) and (A.STYPE='<ALL>' or A.STYPE=@STYPE)))

			Union All

			Select S2.ID, S2.Name, S5.Type, S5.Description as TypeDesc
			from SysUser S2 
			Cross Apply (Select Top 1 S3.TOC from SysUserTOC S3 Where S3.ID=S2.ID and S3.TOC=@TOC and S3.EFFECTIVE<=cast(convert(varchar(10), getdate(),1) as smalldatetime) Order by S3.Effective Desc) S3
			Inner Join SysUserBranch S4 on (S4.ID=S2.ID and S4.ClaimHandlingF=1 and S4.Branch=@Branch)
			Inner Join SysUserType S5 on (S5.Type=S2.Type)
			Left Join ActionUser S1 on (S1.ActionCode=@ActionCode and S1.ActionUser=S2.Type)
			Left Join ActionUserDet A on (A.ActionCode=S1.ActionCode and A.ActionUser=S1.ActionUser)
			Where S2.AllowedF=1 and cast(convert(varchar(10), getdate(),1) as smalldatetime)<=S2.Expiry and S2.LockedF=0
			and coalesce(S1.ActionCode,'')=@ActionCode
			and (coalesce(A.ActionCode,'')='' or ((A.LOB='<ALL>' or A.LOB=@LOB) and (A.BTYPE='<ALL>' or A.BTYPE=@BTYPE) and (A.STYPE='<ALL>' or A.STYPE=@STYPE)))
		) S
	 ) S
 ) S
 Where (S.ApprovalLimit>=@Amount or dbo.GetPrivileges(S.ID,'ALLOWPASSAPPLIMIT')=1)
 Order by S.ApprovalLimit 

 --Select top 1 @ApprovalLimit=T.ApprovalLimit 
 --from @T T
 --Order by T.ApprovalLimit

 --insert into @ActionUser 
 --Select Top 1 T.Type as ID, T.TypeDesc as Name, 'T' as Type, T.ApprovalLimit, Null as LastRequestDate
 --from @T T
 --Where T.Type=@Type

 insert into @ActionUser 
 Select T.ID as ID, T.Name as Name, 'U' as Type, T.ApprovalLimit, coalesce((Select top 1 convert(varchar(10),UserDate,102)+' '+UserTime from sysrequest Where Status='' and Param1='SEND' and Param2='CLM' and Param5=T.ID order by UserDate Desc),NULL) as lastRequestDate
 from @T T
 --Where abs(T.ApprovalLimit-@ApprovalLimit)>=1
 Order by T.ApprovalLimit

Return   
End 

GO
DROP Function fn_GetClaimExpenseActionUser
GO
CREATE Function fn_GetClaimExpenseActionUser(@ActionCode varchar(30), @ObjectID varchar(50))   
RETURNS @ActionUser TABLE (ID varchar(50), Name varchar(255), Type varchar(20), ApprovalLimit Float, LastRequestDate Smalldatetime)  
AS   
BEGIN   
 Declare @T table(ID varchar(50), Name varchar(255), Type varchar(20), TypeDesc varchar(255), ApprovalLimit Float)
 Declare @Type varchar(20)

 Declare @LOB Varchar(10)
 Declare @BType varchar(20)
 Declare @SType varchar(20)
 Declare @TOC varchar(10)
 Declare @Branch varchar(10)
 Declare @ISType varchar(1)
 Declare @Amount Float
 Declare @ApprLimitPCT Float
 Declare @ApprovalLimit Float

 Select
 @LOB=coalesce(BS.LOB,''), 
 @BType=Case When C2.ISTYPE in ('I','C','L') Then 'DIRECT' else 'INDIRECT' end, 
 @SType=Case When PT.STYPE in ('S') Then 'SINGLE' When PT.SType in ('M') Then 'MASTER' else 'OPEN' end,
 @TOC=A1.TOC,
 @Branch=A1.Branch,
 @ISType=C2.ISType,
 @Amount=C1.Amount*dbo.get_ClaimReinsuranceRate(A1.TOC, C1.Currency, cast(convert(varchar(10), getdate(),1) as smalldatetime),C.PHOLDER)          ,
 @ApprLimitPCT=100
 from CLCOST C1
 Inner Join Claim C2 on (C2.CNO=C1.CNO)
 Inner Join Acceptance A1 on (A1.ANO=C2.ANO)
 Inner join Cover C on (C.CNO=A1.CNO) 
 Left Join PolicyType PT on (PT.PolicyType=C.PolicyType)
 Left Join Profile BS on (BS.ID=A1.Source) 
 where cast(C1.CNO as varchar(10))+'-'+C1.ID+'-'+C1.Currency+'-'+C1.RefNo+'-'+C1.CCType=@ObjectID 

 insert into @T
 Select S.ID, S.Name, S.Type, S.TypeDesc, S.ApprovalLimit 
 from
 (
	 Select S.ID, S.Name, S.Type, S.TypeDesc, 
	 dbo.GetApprovalLimit(S.ID, @TOC, @ISType,'Out', @Branch, @ApprLimitPCT,'') as ApprovalLimit
	 from
	 (
		Select Distinct S.*
		From
		( 
			Select S2.ID, S2.Name, S5.Type, S5.Description as TypeDesc
			from SysUser S2 
			Cross Apply (Select Top 1 S3.TOC from SysUserTOC S3 Where S3.ID=S2.ID and S3.TOC=@TOC and S3.EFFECTIVE<=cast(convert(varchar(10), getdate(),1) as smalldatetime) Order by S3.Effective Desc) S3
			Inner Join SysUserBranch S4 on (S4.ID=S2.ID and S4.AllowedF=1 and S4.Branch=@Branch)
			Inner Join SysUserType S5 on (S5.Type=S2.Type)
			Left Join ActionUser S1 on (S1.ActionCode=@ActionCode and S1.ActionUser=S2.ID)
			Left Join ActionUserDet A on (A.ActionCode=S1.ActionCode and A.ActionUser=S1.ActionUser)
			Where S2.AllowedF=1 and cast(convert(varchar(10), getdate(),1) as smalldatetime)<=S2.Expiry and S2.LockedF=0
			and coalesce(S1.ActionCode,'')=@ActionCode
			and (coalesce(A.ActionCode,'')='' or ((A.LOB='<ALL>' or A.LOB=@LOB) and (A.BTYPE='<ALL>' or A.BTYPE=@BTYPE) and (A.STYPE='<ALL>' or A.STYPE=@STYPE)))

			Union All

			Select S2.ID, S2.Name, S5.Type, S5.Description as TypeDesc
			from SysUser S2 
			Cross Apply (Select Top 1 S3.TOC from SysUserTOC S3 Where S3.ID=S2.ID and S3.TOC=@TOC and S3.EFFECTIVE<=cast(convert(varchar(10), getdate(),1) as smalldatetime) Order by S3.Effective Desc) S3
			Inner Join SysUserBranch S4 on (S4.ID=S2.ID and S4.AllowedF=1 and S4.Branch=@Branch)
			Inner Join SysUserType S5 on (S5.Type=S2.Type)
			Left Join ActionUser S1 on (S1.ActionCode=@ActionCode and S1.ActionUser=S2.Type)
			Left Join ActionUserDet A on (A.ActionCode=S1.ActionCode and A.ActionUser=S1.ActionUser)
			Where S2.AllowedF=1 and cast(convert(varchar(10), getdate(),1) as smalldatetime)<=S2.Expiry and S2.LockedF=0
			and coalesce(S1.ActionCode,'')=@ActionCode
			and (coalesce(A.ActionCode,'')='' or ((A.LOB='<ALL>' or A.LOB=@LOB) and (A.BTYPE='<ALL>' or A.BTYPE=@BTYPE) and (A.STYPE='<ALL>' or A.STYPE=@STYPE)))
		) S
	 ) S
 ) S
 Where (S.ApprovalLimit>=@Amount or dbo.GetPrivileges(S.ID,'ALLOWPASSAPPLIMIT')=1)
 Order by S.ApprovalLimit 

 --Select top 1 @ApprovalLimit=T.ApprovalLimit 
 --from @T T
 --Order by T.ApprovalLimit

 --insert into @ActionUser 
 --Select Top 1 T.Type as ID, T.TypeDesc as Name, 'T' as Type, T.ApprovalLimit, Null as LastRequestDate
 --from @T T
 --Where T.Type=@Type

 insert into @ActionUser 
 Select T.ID as ID, T.Name as Name, 'U' as Type, T.ApprovalLimit, coalesce((Select top 1 convert(varchar(10),UserDate,102)+' '+UserTime from sysrequest Where Status='' and Param1='SEND' and Param2 in ('UND-OBJ') and Param5=T.ID order by UserDate Desc),NULL) as lastRequestDate
 from @T T
 --Where abs(T.ApprovalLimit-@ApprovalLimit)>=1
 Order by T.ApprovalLimit

Return   
End   

GO

DROP Function fn_GetClaimProcessActionUser
GO
CREATE Function fn_GetClaimProcessActionUser(@ActionCode varchar(30), @CNO int)   
RETURNS @ActionUser TABLE (ID varchar(50), Name varchar(255), Type varchar(20), ApprovalLimit Float, LastRequestDate Smalldatetime)  
AS   
BEGIN   
 Declare @T table(ID varchar(50), Name varchar(255), Type varchar(20), TypeDesc varchar(255), ApprovalLimit Float)
 Declare @Type varchar(20)

 Declare @LOB Varchar(10)
 Declare @BType varchar(20)
 Declare @SType varchar(20)
 Declare @TOC varchar(10)
 Declare @Branch varchar(10)
 Declare @RCode varchar(10)
 Declare @ISType varchar(1)
 Declare @Amount Float
 Declare @ApprovalLimit Float

 Select 
 @LOB=coalesce(BS.LOB,''), 
 @BType=Case When Claim.ISTYPE in ('I','C','L') Then 'DIRECT' else 'INDIRECT' end, 
 @SType=Case When PT.STYPE in ('S') Then 'SINGLE' When PT.SType in ('M') Then 'MASTER' else 'OPEN' end,
 @TOC=fc.TOC,
 @Branch=fc.Branch,
 @ISType=fc.ISType,
 @Amount=fc.Estimate,
 @RCode=fc.RCode
 from Claim 
 Inner join fn_Approval_Claim(@CNO) fC on (1=1)
 Inner join Acceptance A on (A.ANO=Claim.ANO)
 Inner join Cover C on (C.CNO=A.CNO) 
 Left Join PolicyType PT on (PT.PolicyType=C.PolicyType)
 Left Join Profile BS on (BS.ID=A.Source) 
 Where Claim.CNO=@CNO

 insert into @T
 Select S.ID, S.Name, S.Type, S.TypeDesc, S.ApprovalLimit 
 from
 (
	 Select S.ID, S.Name, S.Type, S.TypeDesc, 
	 dbo.GetApprovalLimit(S.ID, @TOC, @ISType,'Out', @Branch,0,@RCode) as ApprovalLimit
	 from
	 (
		Select Distinct S.*
		From
		( 
			Select S2.ID, S2.Name, S5.Type, S5.Description as TypeDesc
			from SysUser S2 
			Cross Apply (Select Top 1 S3.TOC from SysUserTOC S3 Where S3.ID=S2.ID and S3.TOC=@TOC and S3.EFFECTIVE<=cast(convert(varchar(10), getdate(),1) as smalldatetime) Order by S3.Effective Desc) S3
			Inner Join SysUserBranch S4 on (S4.ID=S2.ID and S4.ClaimHandlingF=1 and S4.Branch=@Branch)
			Inner Join SysUserType S5 on (S5.Type=S2.Type)
			Left Join ActionUser S1 on (S1.ActionCode=@ActionCode and S1.ActionUser=S2.ID)
			Left Join ActionUserDet A on (A.ActionCode=S1.ActionCode and A.ActionUser=S1.ActionUser)
			Where S2.AllowedF=1 and cast(convert(varchar(10), getdate(),1) as smalldatetime)<=S2.Expiry and S2.LockedF=0
			and coalesce(S1.ActionCode,'')=@ActionCode
			and (coalesce(A.ActionCode,'')='' or ((A.LOB='<ALL>' or A.LOB=@LOB) and (A.BTYPE='<ALL>' or A.BTYPE=@BTYPE) and (A.STYPE='<ALL>' or A.STYPE=@STYPE)))

			Union All

			Select S2.ID, S2.Name, S5.Type, S5.Description as TypeDesc
			from SysUser S2 
			Cross Apply (Select Top 1 S3.TOC from SysUserTOC S3 Where S3.ID=S2.ID and S3.TOC=@TOC and S3.EFFECTIVE<=cast(convert(varchar(10), getdate(),1) as smalldatetime) Order by S3.Effective Desc) S3
			Inner Join SysUserBranch S4 on (S4.ID=S2.ID and S4.ClaimHandlingF=1 and S4.Branch=@Branch)
			Inner Join SysUserType S5 on (S5.Type=S2.Type)
			Left Join ActionUser S1 on (S1.ActionCode=@ActionCode and S1.ActionUser=S2.Type)
			Left Join ActionUserDet A on (A.ActionCode=S1.ActionCode and A.ActionUser=S1.ActionUser)
			Where S2.AllowedF=1 and cast(convert(varchar(10), getdate(),1) as smalldatetime)<=S2.Expiry and S2.LockedF=0
			and coalesce(S1.ActionCode,'')=@ActionCode
			and (coalesce(A.ActionCode,'')='' or ((A.LOB='<ALL>' or A.LOB=@LOB) and (A.BTYPE='<ALL>' or A.BTYPE=@BTYPE) and (A.STYPE='<ALL>' or A.STYPE=@STYPE)))
		) S
	 ) S
 ) S
 Where (S.ApprovalLimit>=@Amount or dbo.GetPrivileges(S.ID,'ALLOWPASSAPPLIMIT')=1)
 Order by S.ApprovalLimit 

 --Select top 1 @ApprovalLimit=T.ApprovalLimit 
 --from @T T
 --Order by T.ApprovalLimit

 --insert into @ActionUser 
 --Select Top 1 T.Type as ID, T.TypeDesc as Name, 'T' as Type, T.ApprovalLimit, Null as LastRequestDate
 --from @T T
 --Where T.Type=@Type

 insert into @ActionUser 
 Select T.ID as ID, T.Name as Name, 'U' as Type, T.ApprovalLimit, coalesce((Select top 1 convert(varchar(10),UserDate,102)+' '+UserTime from sysrequest Where Status='' and Param1='SEND' and Param2='CLM' and Param5=T.ID order by UserDate Desc),NULL) as lastRequestDate
 from @T T
 --Where abs(T.ApprovalLimit-@ApprovalLimit)>=1
 Order by T.ApprovalLimit

Return   
End   
GO

DROP Function fn_GetObjectRegisterActionUser
GO
CREATE Function fn_GetObjectRegisterActionUser(@ActionCode varchar(30), @ObjectID varchar(50))   
RETURNS @ActionUser TABLE (ID varchar(50), Name varchar(255), Type varchar(20), ApprovalLimit Float, LastRequestDate Smalldatetime)  
AS   
BEGIN   
 Declare @T table(ID varchar(50), Name varchar(255), Type varchar(20), TypeDesc varchar(255), ApprovalLimit Float)
 Declare @Type varchar(20)

 Declare @LOB Varchar(10)
 Declare @BType varchar(20)
 Declare @SType varchar(20)
 Declare @TOC varchar(10)
 Declare @Branch varchar(10)
 Declare @ISType varchar(1)
 Declare @Amount Float
 Declare @ApprLimitPCT Float
 Declare @ApprovalLimit Float

 Select
 @LOB=coalesce(BS.LOB,''), 
 @BType=Case When A1.ISTYPE in ('I','C','L') Then 'DIRECT' else 'INDIRECT' end, 
 @SType=Case When PT.STYPE in ('S') Then 'SINGLE' When PT.SType in ('M') Then 'MASTER' else 'OPEN' end,
 @TOC=A1.TOC,
 @Branch=A1.Branch,
 @ISType=A1.ISType,
 @Amount=A2.Limit*dbo.get_ReinsuranceRate(A1.TOC, A2.Currency, cast(convert(varchar(10), getdate(),1) as smalldatetime),C.PHOLDER)          ,
 @ApprLimitPCT=100
 from AInfoDet A2
 Inner Join Acceptance A1 on (A1.ANO=A2.ANO)
 Inner join Cover C on (C.CNO=A1.CNO) 
 Left Join PolicyType PT on (PT.PolicyType=C.PolicyType)
 Left Join Profile BS on (BS.ID=A1.Source) 
 where C.CNO=A1.CNO and A2.ANO=A1.ANO 
 and cast(A2.ANO as varchar(10))+'-'+A2.FLDID+'-'+A2.VALUEID=@ObjectID 
 Order By A2.SeqNo Desc

 insert into @T
 Select S.ID, S.Name, S.Type, S.TypeDesc, S.ApprovalLimit 
 from
 (
	 Select S.ID, S.Name, S.Type, S.TypeDesc, 
	 dbo.GetApprovalLimit(S.ID, @TOC, @ISType,'In', @Branch, @ApprLimitPCT,'') as ApprovalLimit
	 from
	 (
		Select Distinct S.*
		From
		( 
			Select S2.ID, S2.Name, S5.Type, S5.Description as TypeDesc
			from SysUser S2 
			Cross Apply (Select Top 1 S3.TOC from SysUserTOC S3 Where S3.ID=S2.ID and S3.TOC=@TOC and S3.EFFECTIVE<=cast(convert(varchar(10), getdate(),1) as smalldatetime) Order by S3.Effective Desc) S3
			Inner Join SysUserBranch S4 on (S4.ID=S2.ID and S4.AllowedF=1 and S4.Branch=@Branch)
			Inner Join SysUserType S5 on (S5.Type=S2.Type)
			Left Join ActionUser S1 on (S1.ActionCode=@ActionCode and S1.ActionUser=S2.ID)
			Left Join ActionUserDet A on (A.ActionCode=S1.ActionCode and A.ActionUser=S1.ActionUser)
			Where S2.AllowedF=1 and cast(convert(varchar(10), getdate(),1) as smalldatetime)<=S2.Expiry and S2.LockedF=0
			and coalesce(S1.ActionCode,'')=@ActionCode
			and (coalesce(A.ActionCode,'')='' or ((A.LOB='<ALL>' or A.LOB=@LOB) and (A.BTYPE='<ALL>' or A.BTYPE=@BTYPE) and (A.STYPE='<ALL>' or A.STYPE=@STYPE)))

			Union All

			Select S2.ID, S2.Name, S5.Type, S5.Description as TypeDesc
			from SysUser S2 
			Cross Apply (Select Top 1 S3.TOC from SysUserTOC S3 Where S3.ID=S2.ID and S3.TOC=@TOC and S3.EFFECTIVE<=cast(convert(varchar(10), getdate(),1) as smalldatetime) Order by S3.Effective Desc) S3
			Inner Join SysUserBranch S4 on (S4.ID=S2.ID and S4.AllowedF=1 and S4.Branch=@Branch)
			Inner Join SysUserType S5 on (S5.Type=S2.Type)
			Left Join ActionUser S1 on (S1.ActionCode=@ActionCode and S1.ActionUser=S2.Type)
			Left Join ActionUserDet A on (A.ActionCode=S1.ActionCode and A.ActionUser=S1.ActionUser)
			Where S2.AllowedF=1 and cast(convert(varchar(10), getdate(),1) as smalldatetime)<=S2.Expiry and S2.LockedF=0
			and coalesce(S1.ActionCode,'')=@ActionCode
			and (coalesce(A.ActionCode,'')='' or ((A.LOB='<ALL>' or A.LOB=@LOB) and (A.BTYPE='<ALL>' or A.BTYPE=@BTYPE) and (A.STYPE='<ALL>' or A.STYPE=@STYPE)))
		) S
	 ) S
 ) S
 Where (S.ApprovalLimit>=@Amount or dbo.GetPrivileges(S.ID,'ALLOWPASSAPPLIMIT')=1)
 Order by S.ApprovalLimit 

 --Select top 1 @ApprovalLimit=T.ApprovalLimit 
 --from @T T
 --Order by T.ApprovalLimit

 --insert into @ActionUser 
 --Select Top 1 T.Type as ID, T.TypeDesc as Name, 'T' as Type, T.ApprovalLimit, Null as LastRequestDate
 --from @T T
 --Where T.Type=@Type

 insert into @ActionUser 
 Select T.ID as ID, T.Name as Name, 'U' as Type, T.ApprovalLimit, coalesce((Select top 1 convert(varchar(10),UserDate,102)+' '+UserTime from sysrequest Where Status='' and Param1='SEND' and Param2 in ('UND-OBJ') and Param5=T.ID order by UserDate Desc),NULL) as lastRequestDate
 from @T T
 --Where abs(T.ApprovalLimit-@ApprovalLimit)>=1
 Order by T.ApprovalLimit

Return   
End   

GO
DROP Function fn_GetPolicyActionUser
GO
CREATE Function fn_GetPolicyActionUser(@ActionCode varchar(30), @ANO int)   
RETURNS @ActionUser TABLE (ID varchar(50), Name varchar(255), Type varchar(20), ApprovalLimit Float, LastRequestDate Smalldatetime)  
AS   
BEGIN   
 Declare @T table(ID varchar(50), Name varchar(255), Type varchar(20), TypeDesc varchar(255), ApprovalLimit Float)
 Declare @Type varchar(20)

 Declare @LOB Varchar(10)
 Declare @BType varchar(20)
 Declare @SType varchar(20)
 Declare @TOC varchar(10)
 Declare @Branch varchar(10)
 Declare @ISType varchar(1)
 Declare @Amount Float
 Declare @TotalAmount Float
 Declare @ApprLimitPCT Float
 Declare @ApprovalLimit Float

 Select 
 @LOB=coalesce(BS.LOB,''), 
 @BType=Case When A.ISTYPE in ('I','C','L') Then 'DIRECT' else 'INDIRECT' end, 
 @SType=Case When PT.STYPE in ('S') Then 'SINGLE' When PT.SType in ('M') Then 'MASTER' else 'OPEN' end,
 @TOC=fc.TOC,
 @Branch=fc.Branch,
 @ISType=fc.ISType,
 @Amount=fc.Amount,
 @TotalAmount=fc.TotalAmount,
 @ApprLimitPCT=fc.ApprLimitPCT
 from Acceptance A 
 Inner Join fn_Approval_Production(@ANO) fC on (1=1)
 Inner join Cover C on (C.CNO=A.CNO) 
 Left Join PolicyType PT on (PT.PolicyType=C.PolicyType)
 Left Join Profile BS on (BS.ID=A.Source) 
 Where A.ANO=@ANO

 insert into @T
 Select S.ID, S.Name, S.Type, S.TypeDesc, S.ApprovalLimit 
 from
 (
	 Select S.ID, S.Name, S.Type, S.TypeDesc, 
	 dbo.GetApprovalLimit(S.ID, @TOC, @ISType,'In', @Branch, @ApprLimitPCT,'') as ApprovalLimit,
	 S.TotalLimitIn*@ApprLimitPct/100 as TotalApprovalLimit
	 from
	 (
		Select Distinct S.*
		From
		( 
			Select S2.ID, S2.Name, S5.Type, S5.Description as TypeDesc, S3.TotalLimitIn 
			from SysUser S2 
			Cross Apply (Select Top 1 TotalLimitIn from SysUserTOC S3 Where S3.ID=S2.ID and S3.TOC=@TOC and S3.EFFECTIVE<=cast(convert(varchar(10), getdate(),1) as smalldatetime) Order by S3.Effective Desc) S3
			Inner Join SysUserBranch S4 on (S4.ID=S2.ID and S4.AllowedF=1 and S4.Branch=@Branch)
			Inner Join SysUserType S5 on (S5.Type=S2.Type)
			Left Join ActionUser S1 on (S1.ActionCode=@ActionCode and S1.ActionUser=S2.ID)
			Left Join ActionUserDet A on (A.ActionCode=S1.ActionCode and A.ActionUser=S1.ActionUser)
			Where S2.AllowedF=1 and cast(convert(varchar(10), getdate(),1) as smalldatetime)<=S2.Expiry and S2.LockedF=0
			and coalesce(S1.ActionCode,'')=@ActionCode
			and (coalesce(A.ActionCode,'')='' or ((A.LOB='<ALL>' or A.LOB=@LOB) and (A.BTYPE='<ALL>' or A.BTYPE=@BTYPE) and (A.STYPE='<ALL>' or A.STYPE=@STYPE)))

			Union All

			Select S2.ID, S2.Name, S5.Type, S5.Description as TypeDesc, S3.TotalLimitIn 
			from SysUser S2 
			Cross Apply (Select Top 1 TotalLimitIn from SysUserTOC S3 Where S3.ID=S2.ID and S3.TOC=@TOC and S3.EFFECTIVE<=cast(convert(varchar(10), getdate(),1) as smalldatetime) Order by S3.Effective Desc) S3
			Inner Join SysUserBranch S4 on (S4.ID=S2.ID and S4.AllowedF=1 and S4.Branch=@Branch)
			Inner Join SysUserType S5 on (S5.Type=S2.Type)
			Left Join ActionUser S1 on (S1.ActionCode=@ActionCode and S1.ActionUser=S2.Type)
			Left Join ActionUserDet A on (A.ActionCode=S1.ActionCode and A.ActionUser=S1.ActionUser)
			Where S2.AllowedF=1 and cast(convert(varchar(10), getdate(),1) as smalldatetime)<=S2.Expiry and S2.LockedF=0
			and coalesce(S1.ActionCode,'')=@ActionCode
			and (coalesce(A.ActionCode,'')='' or ((A.LOB='<ALL>' or A.LOB=@LOB) and (A.BTYPE='<ALL>' or A.BTYPE=@BTYPE) and (A.STYPE='<ALL>' or A.STYPE=@STYPE)))
		) S
	 ) S
 ) S
 Where (dbo.GetPrivileges(S.ID,'ALLOWPASSAPPLIMIT')=1  or (@TotalAmount=0 and S.ApprovalLimit>=@Amount) or (@TotalAmount<>0 and S.ApprovalLimit>=@Amount and S.TotalApprovalLimit>=@TotalAmount))
 Order by S.ApprovalLimit 

 --Select top 1 @ApprovalLimit=T.ApprovalLimit 
 --from @T T
 --Order by T.ApprovalLimit

 --insert into @ActionUser 
 --Select Top 1 T.Type as ID, T.TypeDesc as Name, 'T' as Type, T.ApprovalLimit, Null as LastRequestDate
 --from @T T
 --Where T.Type=@Type

insert into @ActionUser 
 Select T.ID as ID, T.Name as Name, 'U' as Type, T.ApprovalLimit, coalesce((Select top 1 convert(varchar(10),UserDate,102)+' '+UserTime from sysrequest Where Status='' and Param1='SEND' and Param2 in ('MAR','UND') and Param5=T.ID order by UserDate Desc),NULL) as lastRequestDate
 from @T T
 --Where abs(T.ApprovalLimit-@ApprovalLimit)>=1
 Order by T.ApprovalLimit

Return   
End   
GO

DROP FUNCTION PREMIUM_CALCULATION_BASE
GO
CREATE FUNCTION PREMIUM_CALCULATION_BASE(@P_ANO int)                  

RETURNS @PCALC TABLE (ACNO Int identity, ANO Int, Currency varchar(10), CANO int, Code varchar(10), SDate SmallDatetime, EDate SmallDatetime, PolicyYear Int, NoRefundF Int, MinimumPremiumF Bit, Premium Float)
AS
BEGIN

Declare @CalculationRoundingF Bit
Select @CalculationRoundingF=CalculationRoundingF from systab

DECLARE @ACCEPTANCE TABLE (ANO Int, CNO Int, ISType varchar(1), SDate SmallDateTime, EDate SmallDateTime, STime Varchar(5), ETime varchar(5), NOREFUNDF Int, RefundType Varchar(255), EXCLUSIVEF Bit, AType varchar(10), PDate SmallDateTime, CPCT Float, QTY Int, PANO Int, EMethod varchar(1))
INSERT INTO @ACCEPTANCE
SELECT ANO, CNO, ISType, SDATE, EDate, STime, ETime, NOREFUNDF, RefundType, EXCLUSIVEF, ATYPE, PDATE, CPCT, QTY, PANO, EMETHOD
FROM ACCEPTANCE WHERE ANO=@P_ANO

INSERT INTO @PCALC(ANO, Currency, CANO , Code , SDate, EDate, PolicyYear, NoRefundF, MinimumPremiumF, Premium)
Select ANO, Currency, CANO, Code, SDate, EDate, PolicyYear, NoRefundF, Cast(Max(MinimumPremiumF) as Bit) as MinimumPremiumF, sum(Premium) as Premium
 from (                  
  select Acceptance.ANO, RCalc.Currency, @P_ANO as CANO, RCalc.Code, RCalc.SDate, RCalc.Edate, cast(datediff(Month,Acceptance.SDate, RCalc.SDate) as integer) / 12 + 1  as PolicyYear,          
  Acceptance.NoRefundF,   
  Case When Upper(PCALC.DESCRIPTION) in ('MINIMUM PREMIUM','POLICY MINIMUM PREMIUM') Then 1 else 0 end as MinimumPremiumF,                                       
  case                  
  When Acceptance.Atype<>'N' and Acceptance.NoRefundF<>12 and not (Acceptance.NoRefundF=13 and charindex((case when Acceptance.ISType in ('I','L') Then 'DI' else 'I'+Acceptance.ISType end),Acceptance.RefundType)<>0) and (RCover.NoRefundF=1 or Acceptance.NoRefundF in (2,4) or (Acceptance.NoRefundF in (1) and DateDiff(day, acceptance.pdate, RCalc.SDate) <= 0)) Then 0
  When Acceptance.AType<>'N' then                  
   case                  
   when DateDiff(day, acceptance.pdate, rcalc.SDate)>=0 then 1     
   when DateDiff(day, rcalc.Edate, acceptance.pdate)>=0 then 0                               
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
		--Prorata Calculation
		Case When Acceptance.EXCLUSIVEF=0 and Acceptance.STime<Acceptance.ETime and RCalc.EDate=Acceptance.EDate Then
			dbo.fn_calc_prorata(acceptance.pDate, dateadd(day,1,RCalc.edate), RCalc.Sdate, dateadd(day,1,RCalc.edate), Cover.PPeriod)
		else
			dbo.fn_calc_prorata(acceptance.pDate, RCalc.Edate, RCalc.Sdate, RCalc.EDate, Cover.PPeriod)
		End
    End                  
   End                  
  Else                  
	1                  
  End                  
  * (Case When Acceptance.Qty=0 Then 1 else Acceptance.Qty end)                  
  * (Case When PCALC.DESCRIPTION='Minimum Premium' Then RCALC.GROSS else (Case When PCALC.OGROSS<>0 THEN RCALC.OGROSS*PCALC.GROSS/PCALC.OGROSS ELSE PCALC.GROSS END) END+RCalc.Reinstatement)  
  * coalesce(case When ISource.Limit<>0 then ISource.Limit/(ISource.Limit+ISource.Excess) else 1 end*ISource.Share/100,1) as Premium
  From @Acceptance acceptance
  Inner Join cover on (Cover.CNO=Acceptance.CNO)
  Inner Join RCalc on (RCalc.ANO=Acceptance.ANO)
  Inner Join RCover on (RCOVER.ANO=RCALC.ANO AND RCOVER.CODE=RCALC.CODE AND RCOVER.SDATE=RCALC.SDATE)
  Inner Join PCalc on (PCalc.ANO=RCalc.ANO and PCalc.Currency=RCalc.Currency)
  Left Join ISource on (ISource.CNO=Cover.CNO)
  Where Acceptance.ANO=@P_ANO 
  and Acceptance.AType not in ('A','C')                  
  and PCalc.Gross<>0          
                                                    
  Union All                  
                                                                                  
  select Acceptance.ANO, RCalc.Currency, Acceptance.PANO as CANO, RCalc.Code, RCalc.SDate, RCalc.Edate, cast(datediff(Month,pAcceptance.SDate, RCalc.SDate) as integer) / 12 + 1 as PolicyYear,          
  Acceptance.NoRefundF,   
  Case When Upper(PCALC.DESCRIPTION) in ('MINIMUM PREMIUM','POLICY MINIMUM PREMIUM') Then 1 else 0 end as MinimumPremiumF,                                       
  -case     
  When Acceptance.Atype<>'N' and Acceptance.NoRefundF<>12 and not (Acceptance.NoRefundF=13 and charindex((case when pAcceptance.ISType in ('I','L') Then 'DI' else 'I'+pAcceptance.ISType end),Acceptance.RefundType)<>0) and (coalesce(RCover.NoRefundF,0)=1 or Acceptance.NoRefundF in (2,4) or (Acceptance.NoRefundF in (1) and DateDiff(day, acceptance.pdate, RCalc.SDate) <= 0)) Then 0
  when DateDiff(day, acceptance.pdate, rcalc.SDate)>0 and acceptance.pdate between pacceptance.sdate and pacceptance.edate then 1        
  when DateDiff(day, rcalc.Edate, acceptance.pdate)>=0 and acceptance.pdate between pacceptance.sdate and pacceptance.edate then 0                            
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
		--Prorata Calculation
		Case When pAcceptance.EXCLUSIVEF=0 and pAcceptance.STime<pAcceptance.ETime and RCalc.EDate=pAcceptance.EDate Then
			CASE WHEN RCOVER.CPFORMULA='PRORATE SQ' and Acceptance.AType='C' and Acceptance.EMethod<>'A' THEN
				POWER(dbo.fn_calc_prorata(dbo.fn_Get_Effective_Cancellation_By_Payor_Schedule(Acceptance.ANO, Acceptance.PDate,dateadd(day,1,RCalc.edate)), dateadd(day,1,RCalc.edate), RCalc.Sdate, dateadd(day,1,RCalc.edate), Cover.PPeriod), 2)
			ELSE
				CASE WHEN Acceptance.AType='C' and Acceptance.EMethod<>'A' THEN
					dbo.fn_calc_prorata(dbo.fn_Get_Effective_Cancellation_By_Payor_Schedule(Acceptance.ANO, Acceptance.PDate,dateadd(day,1,RCalc.edate)), dateadd(day,1,RCalc.edate), RCalc.Sdate, dateadd(day,1,RCalc.edate), Cover.PPeriod)
				Else
					dbo.fn_calc_prorata(acceptance.pDate, dateadd(day,1,RCalc.edate), RCalc.Sdate, dateadd(day,1,RCalc.edate), Cover.PPeriod)
				End
			END			
		else
			CASE WHEN RCOVER.CPFORMULA='PRORATE SQ' and Acceptance.AType='C' and Acceptance.EMethod<>'A' THEN
				POWER(dbo.fn_calc_prorata(dbo.fn_Get_Effective_Cancellation_By_Payor_Schedule(Acceptance.ANO, Acceptance.PDate,RCalc.Edate), RCalc.Edate, RCalc.Sdate, RCalc.EDate, Cover.PPeriod), 2)
			ELSE
				CASE WHEN Acceptance.AType='C' and Acceptance.EMethod<>'A' THEN
					dbo.fn_calc_prorata(dbo.fn_Get_Effective_Cancellation_By_Payor_Schedule(Acceptance.ANO, Acceptance.PDate,RCalc.Edate), RCalc.Edate, RCalc.Sdate, RCalc.EDate, Cover.PPeriod)
				Else
					dbo.fn_calc_prorata(acceptance.pDate, RCalc.Edate, RCalc.Sdate, RCalc.EDate, Cover.PPeriod)
				End
			END			
		End
    Else                  
    -- Endorsement Period                  
		1                  
    End                  
   End                  
  End                  
  * (Case When pAcceptance.Qty=0 Then 1 else pAcceptance.Qty end)                  
  * (Case When PCALC.DESCRIPTION='Minimum Premium' Then RCALC.GROSS else (Case When PCALC.OGROSS<>0 THEN RCALC.OGROSS*PCALC.GROSS/PCALC.OGROSS ELSE PCALC.GROSS END) END+RCalc.Reinstatement)
  * coalesce(case When ISource.Limit<>0 then ISource.Limit/(ISource.Limit+ISource.Excess) else 1 end*ISource.Share/100,1) 
  * (Case When Acceptance.CPCT=0 and Acceptance.AType='C' and Acceptance.EMethod<>'A' and Acceptance.NoRefundF<>12 and RCover.CPRefund<>0 and Not (DateDiff(day, acceptance.pdate, rcalc.SDate)>0 and acceptance.pdate between pacceptance.sdate and pacceptance.edate) Then RCover.CPRefund/100 else 1 end) as Premium      
  from @Acceptance Acceptance 
  inner join Acceptance pAcceptance on (pAcceptance.ANO=Acceptance.pANO) 
  inner Join Cover on (Cover.CNO=pAcceptance.CNO)                  
  inner join PCalc on (PCalc.ANO=pAcceptance.ANO) 
  inner join RCalc on (RCalc.ANO=PCalc.ANO and RCalc.Currency=PCalc.Currency)                  
  Left Join ISource on (ISource.CNO=Cover.CNO)
  Left Join RCover on (RCover.ANO=Acceptance.ANO and RCover.Code=RCalc.Code and ((RCover.SDate=Acceptance.SDate and RCover.EDate=Acceptance.EDate and RCalc.SDate=pAcceptance.SDate and RCalc.EDate=pAcceptance.EDate) or (RCover.SDate=RCalc.SDate)))
  Where Acceptance.ANO=@P_ANO and Acceptance.AType<>'A' and Not (Acceptance.AType='C' and Acceptance.EMethod='A') and pAcceptance.AType not in ('A','C')                  
  and PCalc.Gross<>0                    
                                                    
  Union All                  
        
  select Acceptance.ANO, RCalc.Currency, @P_ANO as CANO, RCalc.Code, RCalc.SDate, RCalc.Edate, cast(datediff(Month,Acceptance.SDate, RCalc.SDate) as integer) / 12 + 1 as PolicyYear,      
  Acceptance.NoRefundF,       
  Case When Upper(PCALC.DESCRIPTION) in ('MINIMUM PREMIUM','POLICY MINIMUM PREMIUM') Then 1 else 0 end as MinimumPremiumF,                                       
  (Case When PCALC.DESCRIPTION='Minimum Premium' Then RCALC.GROSS else (Case When PCALC.OGROSS<>0 THEN RCALC.OGROSS*PCALC.GROSS/PCALC.OGROSS ELSE PCALC.GROSS END) END+RCalc.Reinstatement)
  * coalesce(case When ISource.Limit<>0 then ISource.Limit/(ISource.Limit+ISource.Excess) else 1 end*ISource.Share/100,1) as Premium
  From @Acceptance acceptance
  Inner Join RCALC on (RCalc.ANO=Acceptance.ANO)
  Inner Join PCalc on (PCalc.ANO=RCalc.ANO and PCalc.Currency=RCalc.Currency)
  Left Join Acceptance sAcceptance on (sAcceptance.ANO=RCalc.SANO) 
  Left Join ISource on (ISource.CNO=sAcceptance.CNO)
  Where Acceptance.ANO=@P_ANO 
  and Acceptance.AType='A'                  
  and PCalc.Gross<>0   
        
) T                  
                                      
Group By ANO, Currency, CANO, Code, SDate, EDate, PolicyYear, NoRefundF  

if @CalculationRoundingF=1 
	Update P
	Set Premium=coalesce(P1.Premium_Rounded_Total,0)-coalesce(P1.Premium_Rounded_Detail,0)+dbo.RoundCCY(Premium,Currency)
	from @PCalc P
	Left Join 
	(	
	Select Max(ACNO) as ACNO, 
	sum(dbo.RoundCCY(Premium,Currency)) as Premium_Rounded_Detail, 
	dbo.RoundCCY(sum(Premium),Currency) as Premium_Rounded_Total
	from @PCalc P
	Group By P.ANO, P.Currency
	) P1 on (P.ACNO=P1.ACNO)

RETURN

END
GO

DROP FUNCTION PREMIUM_CANCELLATION_SIMULATION
GO
CREATE FUNCTION PREMIUM_CANCELLATION_SIMULATION(@P_ANO int, @PDate as smalldatetime, @CPCT as Float)

RETURNS @PCALC TABLE (Currency varchar(10), Code varchar(10), SDate SmallDatetime, EDate SmallDatetime, Premium Float, Discount Float)
AS
BEGIN

Declare @NoRefundF as int
Declare @AType as varchar(1)
Declare @RefundType as varchar(100)
Declare @CPFORMULA as varchar(100)
Declare @SDate as smalldatetime

Select @NoRefundF=0
Select @AType='C'
Select @RefundType=''
Select @CPFormula=''


Select @SDate=A2.SDate 
from Acceptance A1, Acceptance A2 
Where A1.ANO=@P_ANO and A2.OANO=A1.OANO and A2.AStatus='I' and A2.AType in ('N','E')

insert into @PCalc
Select Currency, Code, SDate, EDate, sum(Premium) as Premium, sum(Premium*dbo.Premium_Discount(@P_ANO,Code,PolicyYear)/100) as Discount
 from (                  
  select RCalc.Currency, RCalc.Code, RCalc.SDate, RCalc.Edate, cast(datediff(Month,pAcceptance.SDate, RCalc.SDate) as integer) / 12 + 1  as PolicyYear,
  -case     
  When @AType<>'N' and @NoRefundF<>12 and not (@NoRefundF=13 and charindex((case when pAcceptance.ISType in ('I','L') Then 'DI' else 'I'+pAcceptance.ISType end),@RefundType)<>0) and (@NoRefundF in (2,4) or (@NoRefundF in (1) and DateDiff(day, @PDate, RCalc.SDate) <= 0)) Then 0
  when DateDiff(day, rcalc.Edate, @PDate)>=0 and @PDate between pAcceptance.SDate and pacceptance.edate then 0                  
  when DateDiff(day, @PDate, rcalc.SDate)>0 and @PDate between pAcceptance.SDate and pacceptance.edate then 1                  
  Else                  
   case                  
   when @CPCT<>0 or Cover.Voyage=1 then                  
    case                  
    when @CPCT<>0 then                  
		@CPCT/100                  
    Else                  
		1                  
    End                  
   Else                  
    case                  
    When @SDate<>@PDate or @NoRefundF=6 then                  
		--Prorata Calculation
		Case When pAcceptance.EXCLUSIVEF=0 and pAcceptance.STime<pAcceptance.ETime and RCalc.EDate=pAcceptance.EDate Then
			CASE WHEN @CPFORMULA='PRORATE SQ' and @AType='C' THEN
				POWER(dbo.fn_calc_prorata(dbo.fn_Get_Effective_Cancellation_By_Payor_Schedule(@P_ANO, @PDate,dateadd(day,1,RCalc.edate)), dateadd(day,1,RCalc.edate), RCalc.Sdate, dateadd(day,1,RCalc.edate), Cover.PPeriod), 2)
			ELSE
				CASE WHEN @AType='C' THEN
					dbo.fn_calc_prorata(dbo.fn_Get_Effective_Cancellation_By_Payor_Schedule(@P_ANO, @PDate,dateadd(day,1,RCalc.edate)), dateadd(day,1,RCalc.edate), RCalc.Sdate, dateadd(day,1,RCalc.edate), Cover.PPeriod)
				Else
					dbo.fn_calc_prorata(@PDate, dateadd(day,1,RCalc.edate), RCalc.Sdate, dateadd(day,1,RCalc.edate), Cover.PPeriod)
				End
			END			
		else
			CASE WHEN @CPFORMULA='PRORATE SQ' and @AType='C'  THEN
				POWER(dbo.fn_calc_prorata(dbo.fn_Get_Effective_Cancellation_By_Payor_Schedule(@P_ANO, @PDate,RCalc.Edate), RCalc.Edate, RCalc.Sdate, RCalc.EDate, Cover.PPeriod), 2)
			ELSE
				CASE WHEN @AType='C'  THEN
					dbo.fn_calc_prorata(dbo.fn_Get_Effective_Cancellation_By_Payor_Schedule(@P_ANO, @PDate,RCalc.Edate), RCalc.Edate, RCalc.Sdate, RCalc.EDate, Cover.PPeriod)
				Else
					dbo.fn_calc_prorata(@PDate, RCalc.Edate, RCalc.Sdate, RCalc.EDate, Cover.PPeriod)
				End
			END			
		End
    Else                  
    -- Endorsement Period                  
		1                  
    End                  
   End                  
  End                  
  * (Case When pAcceptance.Qty=0 Then 1 else pAcceptance.Qty end)                  
  * (Case When PCALC.DESCRIPTION='Minimum Premium' Then RCALC.GROSS else (Case When PCALC.OGROSS<>0 THEN RCALC.OGROSS*PCALC.GROSS/PCALC.OGROSS ELSE PCALC.GROSS END) END+RCalc.Reinstatement)
  * coalesce(case When ISource.Limit<>0 then ISource.Limit/(ISource.Limit+ISource.Excess) else 1 end*ISource.Share/100,1) 
  as Premium      
  from Acceptance pAcceptance 
  inner Join Cover on (Cover.CNO=pAcceptance.CNO)          
  inner join PCalc on (PCalc.ANO=pAcceptance.ANO) 
  inner join RCalc on (RCalc.ANO=PCalc.ANO and RCalc.Currency=PCalc.Currency)                  
  Left Join ISource on (ISource.CNO=Cover.CNO)
  Where pAcceptance.ANO=@P_ANO and @AType<>'A' 
  and PCalc.Gross<>0                                            
) T                  
Group By Currency, Code, SDate, EDate

RETURN

END
