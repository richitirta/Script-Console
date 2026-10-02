
SET QUOTED_IDENTIFIER ON
SET ARITHABORT ON
SET NUMERIC_ROUNDABORT OFF
SET CONCAT_NULL_YIELDS_NULL ON
SET ANSI_NULLS ON
SET ANSI_PADDING ON
SET ANSI_WARNINGS ON

IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'EmailCC' AND Object_ID = Object_ID(N'dbo.APDRuleH'))
BEGIN
ALTER TABLE dbo.APDRuleH ADD EmailCC varchar(512) NULL
DECLARE @v sql_variant  
SET @v = N'Email CC'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'APDRuleH', N'COLUMN', N'EmailCC' 
END
GO

IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'EmailBCC' AND Object_ID = Object_ID(N'dbo.APDRuleH'))
BEGIN
ALTER TABLE dbo.APDRuleH ADD EmailBCC varchar(512) NULL
DECLARE @v sql_variant  
SET @v = N'Email BCC'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'APDRuleH', N'COLUMN', N'EmailBCC' 
END
GO

IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'ApplyPHolderExF' AND Object_ID = Object_ID(N'dbo.APDRuleH'))
BEGIN
ALTER TABLE dbo.APDRuleH ADD ApplyPHolderExF bit NULL
DECLARE @v sql_variant  
SET @v = N'Apply By Policy Holder Exclusion (0 : No, 1 : Yes)'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'APDRuleH', N'COLUMN', N'ApplyPHolderExF' 
END
GO

IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'ApplyInsuredExF' AND Object_ID = Object_ID(N'dbo.APDRuleH'))
BEGIN
ALTER TABLE dbo.APDRuleH ADD ApplyInsuredExF bit NULL
DECLARE @v sql_variant  
SET @v = N'Apply By Insured Exclusion (0 : No, 1 : Yes)'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'APDRuleH', N'COLUMN', N'ApplyInsuredExF' 
END
GO

Update APDRuleH Set ApplyPHolderExF=0 Where ApplyPHolderExF IS NULL
GO
Update APDRuleH Set ApplyInsuredExF=0 Where ApplyInsuredExF IS NULL
GO


SET QUOTED_IDENTIFIER ON
SET ARITHABORT ON
SET NUMERIC_ROUNDABORT OFF
SET CONCAT_NULL_YIELDS_NULL ON
SET ANSI_NULLS ON
SET ANSI_PADDING ON
SET ANSI_WARNINGS ON


IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'ApplyTreatyCashLossCombineF' AND Object_ID = Object_ID(N'dbo.APDRuleD'))
BEGIN
ALTER TABLE dbo.APDRuleD ADD ApplyTreatyCashLossCombineF bit NULL
DECLARE @v sql_variant  
SET @v = N'Apply Treaty Cash Loss Combine (0 : No, 1 : Yes)'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'APDRuleD', N'COLUMN', N'ApplyTreatyCashLossCombineF' 
END
GO

UPDATE APDRULED Set ApplyTreatyCashLossCombineF=0 Where ApplyTreatyCashLossCombineF IS NULL
GO


SET QUOTED_IDENTIFIER ON
SET ARITHABORT ON
SET NUMERIC_ROUNDABORT OFF
SET CONCAT_NULL_YIELDS_NULL ON
SET ANSI_NULLS ON
SET ANSI_PADDING ON
SET ANSI_WARNINGS ON


IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'AttachmentF' AND Object_ID = Object_ID(N'dbo.CLPIC'))
BEGIN
ALTER TABLE dbo.CLPIC ADD AttachmentF bit NULL
DECLARE @v sql_variant  
SET @v = N'Use this Document as Attachment (0 : No, 1 : Yes)'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'CLPIC', N'COLUMN', N'AttachmentF' 
END
GO

Update CLPic set AttachmentF=0 Where AttachmentF is null
GO

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'Get_Claim_APRule') AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) )
BEGIN DROP FUNCTION Get_Claim_APRule END
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
					Case When AD.DataExcessPriorityF=1 and ((CArr.EXPAmount<>0 and Claim.CStatus='P') or (CArr.XPAmount<>0 and Claim.CStatus='A')) then RArr.XPID Else '' end = Reinsurance.RID
					)
					or
					(
					Case When AD.DataAutoFacF=1 and ((CArr.EAAmount<>0 and Claim.CStatus='P') or (CArr.AAmount<>0 and Claim.CStatus='A')) then RArr.AID Else '' end = Reinsurance.RID
					)
					or
					(
					Case When AD.DataCompulsoryF=1 and ((CArr.ECAmount<>0 and Claim.CStatus='P') or (CArr.CAmount<>0 and Claim.CStatus='A')) then RArr.CID Else '' end = Reinsurance.RID
					)
					or
					(
					Case When AD.DataDecreeF=1 and ((CArr.EDAmount<>0 and Claim.CStatus='P') or (CArr.DAmount<>0 and Claim.CStatus='A')) then RArr.DID Else '' end = Reinsurance.RID
					)
					or
					(
					Case When AD.DataTreatyF=1 and 
						(
						(CArr.EQAmount<>0 and Claim.CStatus='P' and (AD.ApplyTreatyCashLossCombineF=0 or (AD.ApplyTreatyCashLossCombineF=1 and Reinsurance.CASHLOSSCOMBINE<=(CArr.EQAmount+CArr.ESP1Amount+CArr.ESP2Amount++CArr.ESP3Amount)))) 
						or 
						(CArr.QAmount<>0 and Claim.CStatus='A' and (AD.ApplyTreatyCashLossCombineF=0 or (AD.ApplyTreatyCashLossCombineF=1 and Reinsurance.CASHLOSSCOMBINE<=(CArr.QAmount+CArr.SP1Amount+CArr.SP2Amount++CArr.SP3Amount)))) 
						) then RArr.QID Else '' end = Reinsurance.RID
					)
					or
					(
					Case When AD.DataSurplusF=1 and 
						(
						(CArr.ESP1Amount<>0 and Claim.CStatus='P' and (AD.ApplyTreatyCashLossCombineF=0 or (AD.ApplyTreatyCashLossCombineF=1 and Reinsurance.CASHLOSSCOMBINE<=(CArr.EQAmount+CArr.ESP1Amount+CArr.ESP2Amount++CArr.ESP3Amount)))) 
						or
						(CArr.SP1Amount<>0 and Claim.CStatus='A' and (AD.ApplyTreatyCashLossCombineF=0 or (AD.ApplyTreatyCashLossCombineF=1 and Reinsurance.CASHLOSSCOMBINE<=(CArr.QAmount+CArr.SP1Amount+CArr.SP2Amount++CArr.SP3Amount)))) 
						) then RArr.SP1ID Else '' end = Reinsurance.RID
					)
					or
					(
					Case When AD.DataSurplusF=1 and 
						(
						(CArr.ESP2Amount<>0 and Claim.CStatus='P' and (AD.ApplyTreatyCashLossCombineF=0 or (AD.ApplyTreatyCashLossCombineF=1 and Reinsurance.CASHLOSSCOMBINE<=(CArr.EQAmount+CArr.ESP1Amount+CArr.ESP2Amount++CArr.ESP3Amount)))) 
						or
						(CArr.SP2Amount<>0 and Claim.CStatus='A' and (AD.ApplyTreatyCashLossCombineF=0 or (AD.ApplyTreatyCashLossCombineF=1 and Reinsurance.CASHLOSSCOMBINE<=(CArr.QAmount+CArr.SP1Amount+CArr.SP2Amount++CArr.SP3Amount)))) 
						) then RArr.SP2ID Else '' end = Reinsurance.RID
					)
					or
					(
					Case When AD.DataSurplusF=1 and 
						(
						(CArr.ESP3Amount<>0 and Claim.CStatus='P' and (AD.ApplyTreatyCashLossCombineF=0 or (AD.ApplyTreatyCashLossCombineF=1 and Reinsurance.CASHLOSSCOMBINE<=(CArr.EQAmount+CArr.ESP1Amount+CArr.ESP2Amount++CArr.ESP3Amount)))) 
						or
						(CArr.SP3Amount<>0 and Claim.CStatus='A' and (AD.ApplyTreatyCashLossCombineF=0 or (AD.ApplyTreatyCashLossCombineF=1 and Reinsurance.CASHLOSSCOMBINE<=(CArr.QAmount+CArr.SP1Amount+CArr.SP2Amount++CArr.SP3Amount)))) 
						) then RArr.SP3ID Else '' end = Reinsurance.RID
					)
					or
					(
					Case When AD.DataXOLF=1 and ((CArr.XL1EAmount<>0 and Claim.CStatus='P') or (CArr.XL1Amount<>0 and Claim.CStatus='A')) then CArr.XL1ID  Else '' end = Reinsurance.RID
					)
					or
					(
					Case When AD.DataXOLF=1 and ((CArr.XL2EAmount<>0 and Claim.CStatus='P') or (CArr.XL2Amount<>0 and Claim.CStatus='A')) then CArr.XL2ID  Else '' end = Reinsurance.RID
					)
					or
					(
					Case When AD.DataXOLF=1 and ((CArr.XL3EAmount<>0 and Claim.CStatus='P') or (CArr.XL3Amount<>0 and Claim.CStatus='A')) then CArr.XL3ID  Else '' end = Reinsurance.RID
					)
					or
					(
					Case When AD.DataXOLF=1 and ((CArr.XL4EAmount<>0 and Claim.CStatus='P') or (CArr.XL4Amount<>0 and Claim.CStatus='A')) then CArr.XL4ID  Else '' end = Reinsurance.RID
					)
					or
					(
					Case When AD.DataXOLF=1 and ((CArr.XL5EAmount<>0 and Claim.CStatus='P') or (CArr.XL5Amount<>0 and Claim.CStatus='A')) then CArr.XL5ID  Else '' end = Reinsurance.RID
					)
					or
					(
					Case When AD.DataXOLF=1 and ((CArr.XL6EAmount<>0 and Claim.CStatus='P') or (CArr.XL6Amount<>0 and Claim.CStatus='A')) then CArr.XL6ID  Else '' end = Reinsurance.RID
					)
					or
					(
					Case When AD.DataXOLF=1 and ((CArr.XL7EAmount<>0 and Claim.CStatus='P') or (CArr.XL7Amount<>0 and Claim.CStatus='A')) then CArr.XL7ID  Else '' end = Reinsurance.RID
					)
				)
				and RPart.RNO=Reinsurance.RNO

				Union All

				Select FPart.ID, FPart.SlipNO AS DOCNO
				from Claim, CArrHeader, RArrDet, FPart
				Where Claim.CNO=@P_CNO and CArrHeader.CNO=Claim.CNO 
				and (
					(
					AD.DataFacultativeF=1 and ((CArrHeader.EFAmount<>0 and Claim.CStatus='P') or (CArrHeader.FAmount<>0 and Claim.CStatus='A')) 
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
select '1430 Update Script - 2 September 2025',GETDATE()
go	
  
Declare @PrevScript varchar(100)
Declare @CurrScript varchar(100)

Select @PrevScript=''
Select @CurrScript='1430 Update Script - 2 September 2025'


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