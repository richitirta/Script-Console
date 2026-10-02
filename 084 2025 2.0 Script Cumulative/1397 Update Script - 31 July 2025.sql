
SET QUOTED_IDENTIFIER ON
SET ARITHABORT ON
SET NUMERIC_ROUNDABORT OFF
SET CONCAT_NULL_YIELDS_NULL ON
SET ANSI_NULLS ON
SET ANSI_PADDING ON
SET ANSI_WARNINGS ON

IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'DataSurplusF' AND Object_ID = Object_ID(N'dbo.APDRuleD'))
BEGIN
ALTER TABLE dbo.APDRuleD ADD DataSurplusF bit NULL
DECLARE @v sql_variant
SET @v = N'Data With Surplus (1 : Yes)'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'APDRuleD', N'COLUMN', N'DataSurplusF'
END
GO

IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'DataCompulsoryF' AND Object_ID = Object_ID(N'dbo.APDRuleD'))
BEGIN
ALTER TABLE dbo.APDRuleD ADD DataCompulsoryF bit NULL
DECLARE @v sql_variant
SET @v = N'Data With Compulsory (1 : Yes)'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'APDRuleD', N'COLUMN', N'DataCompulsoryF'
END
GO

IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'DataDecreeF' AND Object_ID = Object_ID(N'dbo.APDRuleD'))
BEGIN
ALTER TABLE dbo.APDRuleD ADD DataDecreeF bit NULL
DECLARE @v sql_variant
SET @v = N'Data With Decree (1 : Yes)'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'APDRuleD', N'COLUMN', N'DataDecreeF'
END
GO

IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'DataXOLF' AND Object_ID = Object_ID(N'dbo.APDRuleD'))
BEGIN
ALTER TABLE dbo.APDRuleD ADD DataXOLF bit NULL
DECLARE @v sql_variant 
SET @v = N'Data With XOL (1 : Yes)'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'APDRuleD', N'COLUMN', N'DataXOLF'
END
GO

DECLARE @v sql_variant 
SET @v = N'Data With Quota Share Treaty (1 : Yes)'
EXECUTE sp_updateextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'APDRuleD', N'COLUMN', N'DataTreatyF'
GO

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'Get_Claim_APRule') AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) )
BEGIN DROP FUNCTION Get_Claim_APRule END
GO

Create function Get_Claim_APRule(@P_CNO as int)      
RETURNS Table      
AS RETURN      
(      
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
			(AH.ApplyInsuredF=0) or
			(AH.ApplyInsuredF=1 and exists (Select top 1 Ad.ID from APDRuleD_Insured Ad Where Ad.RuleID=AH.RuleID and Ad.ID=A.AID))
		)
	)  A

	Outer Apply (
		Select RPart.ID, CASE WHEN COALESCE(RPart.DOCNO,'')='' THEN RPart.DOCNO ELSE Reinsurance.DOCNO END AS DOCNO
		from Claim, RArrHeader, CArrHeader, Reinsurance, RPart
		Where Claim.CNO=@P_CNO and CArrheader.CNO=Claim.CNO and RArrHeader.ANO=Claim.ANO
		and (
			(
			Case When AD.DataExcessPriorityF=1 and ((CArrHeader.EXPAmount<>0 and Claim.CStatus='P') or (CArrHeader.XPAmount<>0 and Claim.CStatus='A')) then RArrHeader.XPID Else '' end = Reinsurance.RID
			)
			or
			(
			Case When AD.DataTreatyF=1 and ((CArrHeader.EQAmount<>0 and Claim.CStatus='P') or (CArrHeader.QAmount<>0 and Claim.CStatus='A')) then RArrHeader.QID Else '' end = Reinsurance.RID
			)
			or
			(
			Case When AD.DataAutoFacF=1 and ((CArrHeader.EAAmount<>0 and Claim.CStatus='P') or (CArrHeader.AAmount<>0 and Claim.CStatus='A')) then RArrHeader.AID Else '' end = Reinsurance.RID
			)
			or
			(
			Case When AD.DataCompulsoryF=1 and ((CArrHeader.ECAmount<>0 and Claim.CStatus='P') or (CArrHeader.CAmount<>0 and Claim.CStatus='A')) then RArrHeader.CID Else '' end = Reinsurance.RID
			)
			or
			(
			Case When AD.DataDecreeF=1 and ((CArrHeader.EDAmount<>0 and Claim.CStatus='P') or (CArrHeader.DAmount<>0 and Claim.CStatus='A')) then RArrHeader.DID Else '' end = Reinsurance.RID
			)
			or
			(
			Case When AD.DataSurplusF=1 and ((CArrHeader.ESP1Amount<>0 and Claim.CStatus='P') or (CArrHeader.SP1Amount<>0 and Claim.CStatus='A')) then RArrHeader.SP1ID Else '' end = Reinsurance.RID
			)
			or
			(
			Case When AD.DataSurplusF=1 and ((CArrHeader.ESP2Amount<>0 and Claim.CStatus='P') or (CArrHeader.SP2Amount<>0 and Claim.CStatus='A')) then RArrHeader.SP2ID Else '' end = Reinsurance.RID
			)
			or
			(
			Case When AD.DataSurplusF=1 and ((CArrHeader.ESP3Amount<>0 and Claim.CStatus='P') or (CArrHeader.SP3Amount<>0 and Claim.CStatus='A')) then RArrHeader.SP3ID Else '' end = Reinsurance.RID
			)
			or
			(
			Case When AD.DataXOLF=1 and ((CArrHeader.XL1EAmount<>0 and Claim.CStatus='P') or (CArrHeader.XL1Amount<>0 and Claim.CStatus='A')) then CArrHeader.XL1ID  Else '' end = Reinsurance.RID
			)
			or
			(
			Case When AD.DataXOLF=1 and ((CArrHeader.XL2EAmount<>0 and Claim.CStatus='P') or (CArrHeader.XL2Amount<>0 and Claim.CStatus='A')) then CArrHeader.XL2ID  Else '' end = Reinsurance.RID
			)
			or
			(
			Case When AD.DataXOLF=1 and ((CArrHeader.XL3EAmount<>0 and Claim.CStatus='P') or (CArrHeader.XL3Amount<>0 and Claim.CStatus='A')) then CArrHeader.XL3ID  Else '' end = Reinsurance.RID
			)
			or
			(
			Case When AD.DataXOLF=1 and ((CArrHeader.XL4EAmount<>0 and Claim.CStatus='P') or (CArrHeader.XL4Amount<>0 and Claim.CStatus='A')) then CArrHeader.XL4ID  Else '' end = Reinsurance.RID
			)
			or
			(
			Case When AD.DataXOLF=1 and ((CArrHeader.XL5EAmount<>0 and Claim.CStatus='P') or (CArrHeader.XL5Amount<>0 and Claim.CStatus='A')) then CArrHeader.XL5ID  Else '' end = Reinsurance.RID
			)
			or
			(
			Case When AD.DataXOLF=1 and ((CArrHeader.XL6EAmount<>0 and Claim.CStatus='P') or (CArrHeader.XL6Amount<>0 and Claim.CStatus='A')) then CArrHeader.XL6ID  Else '' end = Reinsurance.RID
			)
			or
			(
			Case When AD.DataXOLF=1 and ((CArrHeader.XL7EAmount<>0 and Claim.CStatus='P') or (CArrHeader.XL7Amount<>0 and Claim.CStatus='A')) then CArrHeader.XL7ID  Else '' end = Reinsurance.RID
			)
		)
		and RPart.RNO=Reinsurance.RNO

		Union All

		Select FPart.ID, FPart.SlipNO AS DOCNO
		from Claim, CArrHeader, RArrDet, FPart
		Where Claim.CNO=@P_CNO and CArrheader.CNO=Claim.CNO 
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


GO

insert into PatchVersioning
select '1397 Update Script - 31 July 2025',GETDATE()
go	
  
Declare @PrevScript varchar(100)
Declare @CurrScript varchar(100)

Select @PrevScript=''
Select @CurrSCript='1397 Update Script - 31 July 2025'


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
