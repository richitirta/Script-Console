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
			and (
					((A.LANO<>-1 and A.ANO<>A.LANO) and Ad.CertificateF=1) or
					(((A.LANO<>-1 and A.ANO=A.LANO) or (A.LANO=-1)) and Ad.MasterF=1) or
					(Ad.MasterF=0 and Ad.CertificateF=0)
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


