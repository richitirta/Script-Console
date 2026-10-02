/* To prevent any potential data loss issues, you should review this script in detail before running it outside the context of the database designer.*/
BEGIN TRANSACTION
SET QUOTED_IDENTIFIER ON
SET ARITHABORT ON
SET NUMERIC_ROUNDABORT OFF
SET CONCAT_NULL_YIELDS_NULL ON
SET ANSI_NULLS ON
SET ANSI_PADDING ON
SET ANSI_WARNINGS ON
COMMIT

IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'ApplySourceF' AND Object_ID = Object_ID(N'APDRuleH'))

BEGIN

ALTER TABLE dbo.APDRuleH ADD
	ApplySourceF bit NULL
END
GO
DECLARE @v sql_variant 
SET @v = N'Apply By Business Source (0 : No, 1 : Yes)'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'APDRuleH', N'COLUMN', N'ApplySourceF'
GO


IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'ApplySourceExF' AND Object_ID = Object_ID(N'APDRuleH'))

BEGIN

ALTER TABLE dbo.APDRuleH ADD
	ApplySourceExF bit NULL
END
GO
DECLARE @v sql_variant 
SET @v = N'Apply By Business Source (0 : No, 1 : Yes)'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'APDRuleH', N'COLUMN', N'ApplySourceExF'
GO


IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'ApplyBranchF' AND Object_ID = Object_ID(N'APDRuleH'))

BEGIN

ALTER TABLE dbo.APDRuleH ADD
	ApplyBranchF bit NULL
END
GO
DECLARE @v sql_variant 
SET @v = N'Apply By Branch (0 : No, 1 : Yes)'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'APDRuleH', N'COLUMN', N'ApplyBranchF'
GO

/****** Object:  Table [dbo].[APDRuleD_Source]    Script Date: 4/2/2026 1:22:26 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[APDRuleD_Source](
	[RuleID] [int] NOT NULL,
	[ID] [varchar](10) NOT NULL,
	[Last_Opr] [varchar](50) NULL,
	[Last_Update] [smalldatetime] NULL
) ON [PRIMARY]
GO

ALTER TABLE [dbo].[APDRuleD_Source] SET (LOCK_ESCALATION = DISABLE)
GO

ALTER TABLE [dbo].[APDRuleD_Source]  WITH NOCHECK ADD  CONSTRAINT [FK_APDRuleD_Source_APDRuleH] FOREIGN KEY([RuleID])
REFERENCES [dbo].[APDRuleH] ([RuleID])
ON UPDATE CASCADE
ON DELETE CASCADE
GO

ALTER TABLE [dbo].[APDRuleD_Source] CHECK CONSTRAINT [FK_APDRuleD_Source_APDRuleH]
GO


/****** Object:  Table [dbo].[APDRuleD_Branch]    Script Date: 4/2/2026 1:22:26 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[APDRuleD_Branch](
	[RuleID] [int] NOT NULL,
	[Branch] [varchar](10) NOT NULL,
	[Last_Opr] [varchar](50) NULL,
	[Last_Update] [smalldatetime] NULL
) ON [PRIMARY]
GO

ALTER TABLE [dbo].[APDRuleD_Branch] SET (LOCK_ESCALATION = DISABLE)
GO

ALTER TABLE [dbo].[APDRuleD_Branch]  WITH NOCHECK ADD  CONSTRAINT [FK_APDRuleD_Branch_APDRuleH] FOREIGN KEY([RuleID])
REFERENCES [dbo].[APDRuleH] ([RuleID])
ON UPDATE CASCADE
ON DELETE CASCADE
GO

ALTER TABLE [dbo].[APDRuleD_Branch] CHECK CONSTRAINT [FK_APDRuleD_Branch_APDRuleH]
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
			and (C.ISType=AH.ISType or AH.ISType='<All>')  
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
				and (C.ISType=AH.ISType or AH.ISType='<All>')
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


 insert into PatchVersioning
select '1573 Update Script - 2 April 2026.sql',GETDATE()
go	
  
Declare @PrevScript varchar(100)
Declare @CurrScript varchar(100)

Select @PrevScript=''
Select @CurrSCript='1573 Update Script - 2 April 2026.sql'


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

GO 


