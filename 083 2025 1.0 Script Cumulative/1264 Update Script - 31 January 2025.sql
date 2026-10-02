IF Not EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'APDRuleD_PHolder') AND type in (N'U'))
begin

SET ANSI_NULLS ON


SET QUOTED_IDENTIFIER ON


CREATE TABLE [dbo].[APDRuleD_PHolder](
	[RuleID] [int] NOT NULL,
	[ID] [varchar](10) NOT NULL,
	[Last_Opr] [varchar](50) NULL,
	[Last_Update] [smalldatetime] NULL,
) ON [PRIMARY]



Create Unique Index I_APDRuleD_PHolder on APDRuleD_PHolder(RuleID, ID)



ALTER TABLE [dbo].[APDRuleD_PHolder] SET (LOCK_ESCALATION = DISABLE)


ALTER TABLE [dbo].[APDRuleD_PHolder]  WITH NOCHECK ADD  CONSTRAINT [FK_APDRuleD_PHolder_APDRuleH] FOREIGN KEY([RuleID])
REFERENCES [dbo].[APDRuleH] ([RuleID])
ON UPDATE CASCADE
ON DELETE CASCADE


ALTER TABLE [dbo].[APDRuleD_PHolder] CHECK CONSTRAINT [FK_APDRuleD_PHolder_APDRuleH]
END
go

IF Not EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'APDRuleD_Insured') AND type in (N'U'))
begin

SET ANSI_NULLS ON
 

SET QUOTED_IDENTIFIER ON
 

CREATE TABLE [dbo].[APDRuleD_Insured](
	[RuleID] [int] NOT NULL,
	[ID] [varchar](10) NOT NULL,
	[Last_Opr] [varchar](50) NULL,
	[Last_Update] [smalldatetime] NULL,
) ON [PRIMARY]
 

Create Unique Index I_APDRuleD_Insured on APDRuleD_Insured(RuleID, ID)

 

ALTER TABLE [dbo].[APDRuleD_Insured] SET (LOCK_ESCALATION = DISABLE)
 

ALTER TABLE [dbo].[APDRuleD_Insured]  WITH NOCHECK ADD  CONSTRAINT [FK_APDRuleD_Insured_APDRuleH] FOREIGN KEY([RuleID])
REFERENCES [dbo].[APDRuleH] ([RuleID])
ON UPDATE CASCADE
ON DELETE CASCADE


ALTER TABLE [dbo].[APDRuleD_Insured] CHECK CONSTRAINT [FK_APDRuleD_Insured_APDRuleH]
END
go

IF Not EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'APDRuleD_Segment') AND type in (N'U'))
begin
SET ANSI_NULLS ON
 

SET QUOTED_IDENTIFIER ON
 

CREATE TABLE [dbo].[APDRuleD_Segment](
	[RuleID] [int] NOT NULL,
	[Segment] [varchar](10) NOT NULL,
	[Last_Opr] [varchar](50) NULL,
	[Last_Update] [smalldatetime] NULL,
) ON [PRIMARY]
 

Create Unique Index I_APDRuleD_Segment on APDRuleD_Segment(RuleID, Segment)

 

ALTER TABLE [dbo].[APDRuleD_Segment] SET (LOCK_ESCALATION = DISABLE)
 

ALTER TABLE [dbo].[APDRuleD_Segment]  WITH NOCHECK ADD  CONSTRAINT [FK_APDRuleD_Segment_APDRuleH] FOREIGN KEY([RuleID])
REFERENCES [dbo].[APDRuleH] ([RuleID])
ON UPDATE CASCADE
ON DELETE CASCADE
 

ALTER TABLE [dbo].[APDRuleD_Segment] CHECK CONSTRAINT [FK_APDRuleD_Segment_APDRuleH]
END
go


IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'ApplyPHolderF' AND Object_ID = Object_ID(N'APDRuleH'))
BEGIN

SET QUOTED_IDENTIFIER ON
SET ARITHABORT ON
SET NUMERIC_ROUNDABORT OFF
SET CONCAT_NULL_YIELDS_NULL ON
SET ANSI_NULLS ON
SET ANSI_PADDING ON
SET ANSI_WARNINGS ON
 
ALTER TABLE dbo.APDRuleH ADD
	ApplyPHolderF bit NULL

DECLARE @v sql_variant 
SET @v = N'Apply By Policy Holder (0 : No, 1 : Yes)'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'APDRuleH', N'COLUMN', N'ApplyPHolderF'
END
go

IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'ApplyInsuredF' AND Object_ID = Object_ID(N'APDRuleH'))
BEGIN

SET QUOTED_IDENTIFIER ON
SET ARITHABORT ON
SET NUMERIC_ROUNDABORT OFF
SET CONCAT_NULL_YIELDS_NULL ON
SET ANSI_NULLS ON
SET ANSI_PADDING ON
SET ANSI_WARNINGS ON
 
ALTER TABLE dbo.APDRuleH ADD
	ApplyInsuredF bit NULL
DECLARE @v sql_variant 
SET @v = N'Apply By Insured (0 : No, 1 : Yes)'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'APDRuleH', N'COLUMN', N'ApplyInsuredF'
END
go

IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'ApplySegmentF' AND Object_ID = Object_ID(N'APDRuleH'))
BEGIN

SET QUOTED_IDENTIFIER ON
SET ARITHABORT ON
SET NUMERIC_ROUNDABORT OFF
SET CONCAT_NULL_YIELDS_NULL ON
SET ANSI_NULLS ON
SET ANSI_PADDING ON
SET ANSI_WARNINGS ON
 
ALTER TABLE dbo.APDRuleH ADD
	ApplySegmentF bit NULL

DECLARE @v sql_variant 
SET @v = N'Apply by Detail Segment (0 : No, 1 : Yes)'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'APDRuleH', N'COLUMN', N'ApplySegmentF'
END
go


IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'EmailFrom' AND Object_ID = Object_ID(N'APDRuleH'))
BEGIN

SET QUOTED_IDENTIFIER ON
SET ARITHABORT ON
SET NUMERIC_ROUNDABORT OFF
SET CONCAT_NULL_YIELDS_NULL ON
SET ANSI_NULLS ON
SET ANSI_PADDING ON
SET ANSI_WARNINGS ON


ALTER TABLE dbo.APDRuleH ADD
	EmailFrom varchar(512) NULL

DECLARE @v sql_variant 
SET @v = N'Sender Email'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'APDRuleH', N'COLUMN', N'EmailFrom'
end
GO

if exists (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'Get_Policy_APRule') AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) )
BEGIN
DROP function Get_Policy_APRule
end
GO
Create function Get_Policy_APRule(@P_ANO as int)      
RETURNS Table      
AS RETURN      
(   
Select AD.RuleID, AD.Class, AD.Version, AD.RepName, AD.ExeName, AH.AutoInforceF, R.ApplyeStampDutyF, AD.NeedEmailF,AD.NeedPrintF, AD.NeedeStampDutyF, AD.PrintLogoF, AD.EmailTo
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
			(AH.ApplyInsuredF=0) or
			(AH.ApplyInsuredF=1 and exists (Select top 1 Ad.ID from APDRuleD_Insured Ad Where Ad.RuleID=AH.RuleID and Ad.ID=A.AID))
		)
	)  A
	Where AH.AllowedF=1 AND AH.APPTYPE='POLICY'  
) R ON (AD.RuleID=R.RuleID and AD.Class=R.Class and AD.Version=R.Version and AD.PrintLogoF=R.PrintLogoF)
)       

GO
if exists (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'Get_Claim_APRule') AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) )
BEGIN
DROP function Get_Claim_APRule
end
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
if exists (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'Get_RECEIPT_APRule') AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) )
BEGIN
DROP function Get_RECEIPT_APRule
end
GO
Create function Get_RECEIPT_APRule(@VOUCHERNO as varchar(30), @SentTo as int)      
RETURNS Table      
AS RETURN      
(   
Select AD.RuleID, AD.Class, AD.RepName, AD.ExeName, AH.AutoInforceF, cast(0 as Bit) as ApplyeStampDutyF, AD.NeedEmailF, AD.NeedPrintF, AD.NeedeStampDutyF, R.DocNo, R.ID
from APDRuleH AH 
INNER JOIN APDRULED AD ON (AH.RULEID=AD.RULEID AND AD.AllowedF=1) 
INNER JOIN 
(
	Select AH.RuleID, AD.Class, AD.Version, AD.PrintLogoF, pL.DocNo, pL.ID 
	from APDRuleH AH 
	Inner Join APDRuleD AD on (AD.RULEID=AH.RULEID AND AD.AllowedF=1) 
	Cross Apply 	
	(  
		SELECT 
		Distinct 
		pVoucher.Voucher,
		(
			case 
			When @SentTo=0 then ''				-- by Agent/Broker
			When @SentTo=1 then Admlink.A_ID	-- by Insured
			When @SentTo=2 then Admlink.ID		-- by Payor
			When @SentTo=3 then Admlink.A_PolicyNo	-- by PolicyNo
			else
				''
			end
		) as DocNo,
		(
			case 
			When @SentTo=0 then ProAcc.ID		-- by Agent/Broker
			When @SentTo=1 then Admlink.A_ID	-- by Insured
			When @SentTo=2 then Admlink.ID		-- by Payor
			When @SentTo=3 then Admlink.A_ID	-- by PolicyNo
			else
				ProAcc.ID
			end
		) as ID
		FROM pVOUCHER 
		INNER JOIN PROACC on (PROACC.PROACC=PVOUCHER.PROACC)
		INNER JOIN oSL(@VoucherNo) pSL on (pSL.Voucher=pVoucher.Voucher)
		LEFT JOIN ADMLINK on (Admlink.Voucher=pSL.Doc_No and pSL.PaymentF=1)
		WHERE pVOUCHER.VOUCHER=@VOUCHERNO
		--Other Condition Applied
		And pVoucher.SL_Cat='P' and pVoucher.DebtorF=1 and pSL.Nominal>0
		and 
		(
			AD.PremiumReceiveF=1 
			and (Admlink.Code=AH.TOC or AH.TOC='<All>')
			and Admlink.Subject='Premium' and Admlink.Type in ('DI','IC','IR','IT','IX')			
			and 
			(
				(AH.ApplySegmentF=0 and (Admlink.Segment=AH.Segment or AH.Segment='<All>')) or
				(AH.ApplySegmentF=1 and exists (Select top 1 Ad.Segment from APDRuleD_Segment Ad Where Ad.RuleID=AH.RuleID and Ad.Segment=Admlink.Segment))
			)
			--and (
			--	(AH.ApplyPHolderF=0) or
			--	(AH.ApplyPHolderF=1 and exists (Select top 1 Ad.ID from APDRuleD_PHolder Ad Where Ad.RuleID=AH.RuleID and Ad.ID=C.PHolder))
			--)
			and (
				(AH.ApplyInsuredF=0) or
				(AH.ApplyInsuredF=1 and exists (Select top 1 Ad.ID from APDRuleD_Insured Ad Where Ad.RuleID=AH.RuleID and Ad.ID=Admlink.A_ID))
			)
		)		
	) pL
	Where AH.AllowedF=1 AND AH.APPTYPE='RECEIPT'  
	and coalesce(pL.Voucher,'')<>''
) R ON (AD.RuleID=R.RuleID and AD.Class=R.Class and AD.Version=R.Version and AD.PrintLogoF=R.PrintLogoF )
)       


GO
if exists (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'Get_PAYMENT_APRule') AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) )
BEGIN 
DROP function Get_PAYMENT_APRule
end
GO
Create function Get_PAYMENT_APRule(@VOUCHERNO as varchar(30))      
RETURNS Table      
AS RETURN      
(   
Select AD.RuleID, AD.Class, AD.RepName, AD.ExeName, AH.AutoInforceF, cast(0 as Bit) as ApplyeStampDutyF, AD.NeedEmailF, AD.NeedPrintF, AD.NeedeStampDutyF
from APDRuleH AH 
INNER JOIN APDRULED AD ON (AH.RULEID=AD.RULEID AND AD.AllowedF=1) 
INNER JOIN 
(
	Select AH.RuleID, AD.Class, AD.Version, AD.PrintLogoF
	from APDRuleH AH 
	Inner Join APDRuleD AD on (AD.RULEID=AH.RULEID AND AD.AllowedF=1) 
	Where AH.AllowedF=1 AND AH.APPTYPE='PAYMENT'  
	and exists
	(  
		SELECT 1
		FROM pVOUCHER 
		INNER JOIN oSL(@VoucherNo) pSL on (pSL.Voucher=pVoucher.Voucher)
		LEFT JOIN ADMLINK on (Admlink.Voucher=pSL.Doc_No and pSL.PaymentF=1)
		INNER JOIN ACCOUNT on (ACCOUNT.ACCOUNT=pSL.ACCOUNT)
		INNER JOIN TYPE on (TYPE.TYPE=ACCOUNT.TYPE)
		WHERE pVOUCHER.VOUCHER=@VOUCHERNO 
		--Other Condition Applied
		And pVoucher.SL_Cat='P' and pVoucher.CreditorF=1 and pSL.Nominal>0
		and 
		(
			(
				AD.ClaimPaymentF=1 
				and (Admlink.Code=AH.TOC or AH.TOC='<All>')
				and Admlink.Subject='Claim' and Admlink.Type in ('DI','IC','IR','IT','IX','OP')
				and 
				(
					(AH.ApplySegmentF=0 and (Admlink.Segment=AH.Segment or AH.Segment='<All>')) or
					(AH.ApplySegmentF=1 and exists (Select top 1 Ad.Segment from APDRuleD_Segment Ad Where Ad.RuleID=AH.RuleID and Ad.Segment=Admlink.Segment))
				)
				--and (
				--	(AH.ApplyPHolderF=0) or
				--	(AH.ApplyPHolderF=1 and exists (Select top 1 Ad.ID from APDRuleD_PHolder Ad Where Ad.RuleID=AH.RuleID and Ad.ID=C.PHolder))
				--)
				and (
					(AH.ApplyInsuredF=0) or
					(AH.ApplyInsuredF=1 and exists (Select top 1 Ad.ID from APDRuleD_Insured Ad Where Ad.RuleID=AH.RuleID and Ad.ID=Admlink.A_ID))
				)
			)
			or
			(
				AD.ExpensePaymentF=1 
				and pSL.PaymentF=0 and Type.PL_FLAG=1 and TYPE.sign=1 --Expense Account
			)
		)
	)  
) R ON (AD.RuleID=R.RuleID and AD.Class=R.Class and AD.Version=R.Version and AD.PrintLogoF=R.PrintLogoF )
)       



GO



  insert into PatchVersioning
select '1264 Update Script - 31 January 2025',GETDATE()
go	
  
Declare @PrevScript varchar(100)
Declare @CurrScript varchar(100)

Select @PrevScript=''
Select @CurrSCript='1264 Update Script - 31 January 2025'


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









