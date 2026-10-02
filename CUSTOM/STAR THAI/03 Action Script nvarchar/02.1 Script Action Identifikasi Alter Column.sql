DROP VIEW [dbo].[SL]
GO

DROP VIEW [dbo].[vProAcc]
GO

DROP View vProfile
GO

DROP View vProfile_Ext
GO

ALTER TABLE [dbo].[AAccBS] ALTER COLUMN [LUserID] nVarChar(50) ;
 GO 
ALTER TABLE [dbo].[ACCASS] ALTER COLUMN [REMARKS] nVarChar(2048) ;
 GO 
ALTER TABLE [dbo].[ACCBS] ALTER COLUMN [LUserID] nVarChar(50) ;
 GO 
ALTER TABLE [dbo].[AccCA] ALTER COLUMN [Address] nVarChar(255) ;
 GO 
ALTER TABLE [dbo].[AccCA] ALTER COLUMN [Attention] nVarChar(255) ;
 GO 
ALTER TABLE [dbo].[AccCA] ALTER COLUMN [Email] nVarChar(512) ;
 GO 
ALTER TABLE [dbo].[ACCCLA] ALTER COLUMN [DESCRIPTION] nVarchar(max) ;
 GO 
ALTER TABLE [dbo].[ACCCLA] ALTER COLUMN [Description_1] nVarchar(max) ;
 GO 
ALTER TABLE [dbo].[ACCCLA] ALTER COLUMN [Last_Opr] nVarChar(50) ;
 GO 
ALTER TABLE [dbo].[ACCCLA] ALTER COLUMN [ORGDESCRIPTION] nVarchar(max) ;
 GO 
ALTER TABLE [dbo].[ACCCLA] ALTER COLUMN [ORGDescription_1] nVarchar(max) ;
 GO 
ALTER TABLE [dbo].[ACCCLA] ALTER COLUMN [SHORTDESC] nVarchar(max) ;
 GO 
ALTER TABLE [dbo].[ACCCLA] ALTER COLUMN [ShortDesc_1] nVarchar(max) ;
 GO 
ALTER TABLE [dbo].[AccClass] ALTER COLUMN [Description] nVarchar(100) ;
 GO 
ALTER TABLE [dbo].[AccClass] ALTER COLUMN [Last_Opr] nVarChar(50) ;
 GO 
ALTER TABLE [dbo].[AccClass] ALTER COLUMN [ShortDesc] nVarchar(100) ;
 GO 
ALTER TABLE [dbo].[AccClassDet] ALTER COLUMN [Description] nVarchar(200) ;
 GO 
ALTER TABLE [dbo].[ACCCNC] ALTER COLUMN [USERID] nVarChar(50) ;
 GO 
ALTER TABLE [dbo].[ACCCOLLATERAL] ALTER COLUMN [DESCRIPTION] nVarchar(255) ;
 GO 
ALTER TABLE [dbo].[ACCCOLLATERAL] ALTER COLUMN [LAST_OPR] nVarChar(50) ;
 GO 
ALTER TABLE [dbo].[ACCCOLLATERAL] ALTER COLUMN [RECEIVEDBYTITLE] nVarChar(100) ;
 GO 
ALTER TABLE [dbo].[ACCCOLLATERAL] ALTER COLUMN [RECEIVEDFROMTITLE] nVarChar(100) ;
 GO 
ALTER TABLE [dbo].[ACCCOLLATERAL] ALTER COLUMN [RELEASEDBYTITLE] nVarChar(100) ;
 GO 
ALTER TABLE [dbo].[ACCCOLLATERAL] ALTER COLUMN [RELEASEDTOTITLE] nVarChar(100) ;
 GO 
ALTER TABLE [dbo].[ACCCOLLATERAL] ALTER COLUMN [REMARKS] nVarChar(512) ;
 GO 
ALTER TABLE [dbo].[ACCCOMPSHEETD] ALTER COLUMN [DESCRIPTION] nVarchar(255) ;
 GO 
ALTER TABLE [dbo].[ACCCOMPSHEETD] ALTER COLUMN [REMARKS] nVarChar(255) ;
 GO 
ALTER TABLE [dbo].[ACCCOMPSHEETD] ALTER COLUMN [RISKDESC] nVarchar(255) ;
 GO 
ALTER TABLE [dbo].[ACCCOMPSHEETD] ALTER COLUMN [SIDDESC] nVarchar(255) ;
 GO 
ALTER TABLE [dbo].[ACCCOMPSHEETH] ALTER COLUMN [AUSERID] nVarChar(50) ;
 GO 
ALTER TABLE [dbo].[ACCCOMPSHEETH] ALTER COLUMN [CUSERID] nVarChar(50) ;
 GO 
ALTER TABLE [dbo].[ACCCOMPSHEETH] ALTER COLUMN [LUSERID] nVarChar(50) ;
 GO 
ALTER TABLE [dbo].[ACCCOMPSHEETH] ALTER COLUMN [PUserID] nVarChar(50) ;
 GO 
ALTER TABLE [dbo].[ACCCOMPSHEETH] ALTER COLUMN [USERID] nVarChar(50) ;
 GO 
ALTER TABLE [dbo].[ACCCON] ALTER COLUMN [DESCRIPTION] nVarchar(max) ;
 GO 
ALTER TABLE [dbo].[ACCCON] ALTER COLUMN [Description_1] nVarchar(max) ;
 GO 
ALTER TABLE [dbo].[ACCCON] ALTER COLUMN [Last_Opr] nVarChar(50) ;
 GO 
ALTER TABLE [dbo].[ACCCON] ALTER COLUMN [ORGDESCRIPTION] nVarchar(max) ;
 GO 
ALTER TABLE [dbo].[ACCCON] ALTER COLUMN [ORGDescription_1] nVarchar(max) ;
 GO 
ALTER TABLE [dbo].[ACCCON] ALTER COLUMN [SHORTDESC] nVarchar(max) ;
 GO 
ALTER TABLE [dbo].[ACCCON] ALTER COLUMN [ShortDesc_1] nVarchar(max) ;
 GO 
ALTER TABLE [dbo].[AccDA] ALTER COLUMN [Address] nVarChar(255) ;
 GO 
ALTER TABLE [dbo].[AccDA] ALTER COLUMN [Attention] nVarChar(255) ;
 GO 
ALTER TABLE [dbo].[AccDA] ALTER COLUMN [Email] nVarChar(512) ;
 GO 
ALTER TABLE [dbo].[ACCDED] ALTER COLUMN [LUserID] nVarChar(50) ;
 GO 
ALTER TABLE [dbo].[ACCDED] ALTER COLUMN [REMARKS] nVarChar(2048) ;
 GO 
ALTER TABLE [dbo].[ACCDED] ALTER COLUMN [REMARKS_1] nVarChar(2048) ;
 GO 
ALTER TABLE [dbo].[ACCDEPOSIT] ALTER COLUMN [Last_Opr] nVarChar(50) ;
 GO 
ALTER TABLE [dbo].[ACCDEPOSIT] ALTER COLUMN [REMARK] nVarChar(255) ;
 GO 
ALTER TABLE [dbo].[ACCDOCLIST] ALTER COLUMN [DESCRIPTION] nVarchar(255) ;
 GO 
ALTER TABLE [dbo].[ACCDOCLIST] ALTER COLUMN [LAST_OPR] nVarChar(50) ;
 GO 
ALTER TABLE [dbo].[ACCDOCLIST] ALTER COLUMN [REMARKS] nVarChar(512) ;
 GO 
ALTER TABLE [dbo].[ACCDOCLISTPIC] ALTER COLUMN [Last_Opr] nVarChar(50) ;
 GO 
ALTER TABLE [dbo].[ACCDOCLISTPIC] ALTER COLUMN [Remark] nVarchar(Max) ;
 GO 
ALTER TABLE [dbo].[ACCDOCLISTPIC] ALTER COLUMN [Title] nVarChar(255) ;
 GO 
ALTER TABLE [dbo].[AccDocStat] ALTER COLUMN [AcceptedBy] nVarChar(100) ;
 GO 
ALTER TABLE [dbo].[AccDocStat] ALTER COLUMN [Last_Opr] nVarChar(50) ;
 GO 
ALTER TABLE [dbo].[AccDocStat] ALTER COLUMN [Remarks] nVarChar(255) ;
 GO 
ALTER TABLE [dbo].[ACCEMPCONTD] ALTER COLUMN [REMARKS] nVarChar(255) ;
 GO 
ALTER TABLE [dbo].[ACCEMPCONTH] ALTER COLUMN [AUSERID] nVarChar(50) ;
 GO 
ALTER TABLE [dbo].[ACCEMPCONTH] ALTER COLUMN [CUSERID] nVarChar(50) ;
 GO 
ALTER TABLE [dbo].[ACCEMPCONTH] ALTER COLUMN [LUSERID] nVarChar(50) ;
 GO 
ALTER TABLE [dbo].[ACCEMPCONTH] ALTER COLUMN [PUserID] nVarChar(50) ;
 GO 
ALTER TABLE [dbo].[ACCEMPCONTH] ALTER COLUMN [REMARKS] nVarChar(512) ;
 GO 
ALTER TABLE [dbo].[ACCEMPCONTH] ALTER COLUMN [USERID] nVarChar(50) ;
 GO 
ALTER TABLE [dbo].[ACCEPTANCE] ALTER COLUMN [AName] nVarChar(max) ;
 GO 
ALTER TABLE [dbo].[ACCEPTANCE] ALTER COLUMN [AUserID] nVarChar(50) ;
 GO 
ALTER TABLE [dbo].[ACCEPTANCE] ALTER COLUMN [COMMENT] nVarchar(Max) ;
 GO 
ALTER TABLE [dbo].[ACCEPTANCE] ALTER COLUMN [CUSERID] nVarChar(50) ;
 GO 
ALTER TABLE [dbo].[ACCEPTANCE] ALTER COLUMN [Location] nVarChar(100) ;
 GO 
ALTER TABLE [dbo].[ACCEPTANCE] ALTER COLUMN [LUserID] nVarChar(50) ;
 GO 
ALTER TABLE [dbo].[ACCEPTANCE] ALTER COLUMN [MEMO] nVarchar(Max) ;
 GO 
ALTER TABLE [dbo].[ACCEPTANCE] ALTER COLUMN [Notes] nVarChar(512) ;
 GO 
ALTER TABLE [dbo].[ACCEPTANCE] ALTER COLUMN [Reason] nVarChar(10) ;
 GO 
ALTER TABLE [dbo].[ACCEPTANCE] ALTER COLUMN [REMARKS] nVarChar(1024) ;
 GO 
ALTER TABLE [dbo].[ACCEPTANCE] ALTER COLUMN [RequestMessage] nVarchar(Max) ;
 GO 
ALTER TABLE [dbo].[ACCEPTANCE] ALTER COLUMN [RequestName] nVarChar(50) ;
 GO 
ALTER TABLE [dbo].[ACCEPTANCE] ALTER COLUMN [RUserID] nVarChar(50) ;
 GO 
ALTER TABLE [dbo].[ACCEPTANCE] ALTER COLUMN [SYSUSERID] nVarChar(50) ;
 GO 
ALTER TABLE [dbo].[ACCEPTANCE] ALTER COLUMN [USERID] nVarChar(50) ;
 GO 
ALTER TABLE [dbo].[ACCEPTANCE] ALTER COLUMN [VALUEDESC] nVarchar(Max) ;
 GO 
ALTER TABLE [dbo].[ACCEX] ALTER COLUMN [DESCRIPTION] nVarchar(max) ;
 GO 
ALTER TABLE [dbo].[ACCEX] ALTER COLUMN [Description_1] nVarchar(max) ;
 GO 
ALTER TABLE [dbo].[ACCEX] ALTER COLUMN [Last_Opr] nVarChar(50) ;
 GO 
ALTER TABLE [dbo].[ACCEX] ALTER COLUMN [ORGDESCRIPTION] nVarchar(max) ;
 GO 
ALTER TABLE [dbo].[ACCEX] ALTER COLUMN [ORGDescription_1] nVarchar(max) ;
 GO 
ALTER TABLE [dbo].[ACCEX] ALTER COLUMN [SHORTDESC] nVarchar(max) ;
 GO 
ALTER TABLE [dbo].[ACCEX] ALTER COLUMN [ShortDesc_1] nVarchar(max) ;
 GO 
ALTER TABLE [dbo].[ACCFD] ALTER COLUMN [LUserID] nVarChar(50) ;
 GO 
ALTER TABLE [dbo].[ACCFD] ALTER COLUMN [REMARK] nVarChar(50) ;
 GO 
ALTER TABLE [dbo].[ACCINVOICE] ALTER COLUMN [InvoiceRemarks] nVarChar(255) ;
 GO 
ALTER TABLE [dbo].[ACCINVOICE] ALTER COLUMN [Last_Opr] nVarChar(50) ;
 GO 
ALTER TABLE [dbo].[ACCLINK] ALTER COLUMN [EXTRA_1] nVarChar(50) ;
 GO 
ALTER TABLE [dbo].[ACCLINK] ALTER COLUMN [EXTRA_10] nVarChar(50) ;
 GO 
ALTER TABLE [dbo].[ACCLINK] ALTER COLUMN [EXTRA_2] nVarChar(50) ;
 GO 
ALTER TABLE [dbo].[ACCLINK] ALTER COLUMN [EXTRA_3] nVarChar(50) ;
 GO 
ALTER TABLE [dbo].[ACCLINK] ALTER COLUMN [EXTRA_4] nVarChar(50) ;
 GO 
ALTER TABLE [dbo].[ACCLINK] ALTER COLUMN [EXTRA_5] nVarChar(50) ;
 GO 
ALTER TABLE [dbo].[ACCLINK] ALTER COLUMN [EXTRA_6] nVarChar(50) ;
 GO 
ALTER TABLE [dbo].[ACCLINK] ALTER COLUMN [EXTRA_7] nVarChar(50) ;
 GO 
ALTER TABLE [dbo].[ACCLINK] ALTER COLUMN [EXTRA_8] nVarChar(50) ;
 GO 
ALTER TABLE [dbo].[ACCLINK] ALTER COLUMN [EXTRA_9] nVarChar(50) ;
 GO 
ALTER TABLE [dbo].[ACCLINK] ALTER COLUMN [LUserID] nVarChar(50) ;
 GO 
ALTER TABLE [dbo].[ACCLINK] ALTER COLUMN [REMARKS] nVarChar(512) ;
 GO 
ALTER TABLE [dbo].[Account] ALTER COLUMN [Description] nVarchar(200) ;
 GO 
ALTER TABLE [dbo].[Account] ALTER COLUMN [Description1] nVarchar(200) ;
 GO 
ALTER TABLE [dbo].[Account] ALTER COLUMN [Last_Opr] nVarChar(50) ;
 GO 
ALTER TABLE [dbo].[ACCPIC] ALTER COLUMN [Last_Opr] nVarChar(50) ;
 GO 
ALTER TABLE [dbo].[ACCPIC] ALTER COLUMN [Remark] nVarchar(Max) ;
 GO 
ALTER TABLE [dbo].[ACCPIC] ALTER COLUMN [Title] nVarChar(255) ;
 GO 
ALTER TABLE [dbo].[ACCSECTION] ALTER COLUMN [DESCRIPTION] nVarchar(max) ;
 GO 
ALTER TABLE [dbo].[ACCSECTION] ALTER COLUMN [SHORTDESC] nVarchar(255) ;
 GO 
ALTER TABLE [dbo].[AccSgn] ALTER COLUMN [SCCTitle] nVarChar(100) ;
 GO 
ALTER TABLE [dbo].[AccSgn] ALTER COLUMN [SCTitle] nVarChar(100) ;
 GO 
ALTER TABLE [dbo].[AccSgn] ALTER COLUMN [SPTitle] nVarChar(100) ;
 GO 
ALTER TABLE [dbo].[ActionFlow] ALTER COLUMN [ActionFlowTitle] nVarChar(100) ;
 GO 
ALTER TABLE [dbo].[ActionList] ALTER COLUMN [Description] nVarchar(255) ;
 GO 
ALTER TABLE [dbo].[ActionUserDet] ALTER COLUMN [Last_Opr] nVarChar(50) ;
 GO 
ALTER TABLE [dbo].[AdmLink] ALTER COLUMN [A_RefNo] nVarChar(50) ;
 GO 
ALTER TABLE [dbo].[AdmLink] ALTER COLUMN [BankName] nVarChar(255) ;
 GO 
ALTER TABLE [dbo].[AdmLink] ALTER COLUMN [BankName_Ext] nVarChar(255) ;
 GO 
ALTER TABLE [dbo].[AdmLink] ALTER COLUMN [Email] nVarChar(512) ;
 GO 
ALTER TABLE [dbo].[AdmLink] ALTER COLUMN [EXTRA_1] nVarChar(50) ;
 GO 
ALTER TABLE [dbo].[AdmLink] ALTER COLUMN [EXTRA_10] nVarChar(50) ;
 GO 
ALTER TABLE [dbo].[AdmLink] ALTER COLUMN [EXTRA_2] nVarChar(50) ;
 GO 
ALTER TABLE [dbo].[AdmLink] ALTER COLUMN [EXTRA_3] nVarChar(50) ;
 GO 
ALTER TABLE [dbo].[AdmLink] ALTER COLUMN [EXTRA_4] nVarChar(50) ;
 GO 
ALTER TABLE [dbo].[AdmLink] ALTER COLUMN [EXTRA_5] nVarChar(50) ;
 GO 
ALTER TABLE [dbo].[AdmLink] ALTER COLUMN [EXTRA_6] nVarChar(50) ;
 GO 
ALTER TABLE [dbo].[AdmLink] ALTER COLUMN [EXTRA_7] nVarChar(50) ;
 GO 
ALTER TABLE [dbo].[AdmLink] ALTER COLUMN [EXTRA_8] nVarChar(50) ;
 GO 
ALTER TABLE [dbo].[AdmLink] ALTER COLUMN [EXTRA_9] nVarChar(50) ;
 GO 
ALTER TABLE [dbo].[AdmLink] ALTER COLUMN [INSURED] nVarChar(2048) ;
 GO 
ALTER TABLE [dbo].[AdmLink] ALTER COLUMN [LUserID] nVarChar(50) ;
 GO 
ALTER TABLE [dbo].[AdmLink] ALTER COLUMN [REMARKS] nVarChar(max) ;
 GO 
ALTER TABLE [dbo].[AdmLink] ALTER COLUMN [VALUEDESC] nVarchar(Max) ;
 GO 
ALTER TABLE [dbo].[AEBucket] ALTER COLUMN [Last_Opr] nVarChar(50) ;
 GO 
ALTER TABLE [dbo].[AIBucket] ALTER COLUMN [Last_Opr] nVarChar(50) ;
 GO 
ALTER TABLE [dbo].[AINFO] ALTER COLUMN [VALUEDESC1] nVarchar(Max) ;
 GO 
ALTER TABLE [dbo].[AINFO] ALTER COLUMN [VALUEDESC10] nVarchar(Max) ;
 GO 
ALTER TABLE [dbo].[AINFO] ALTER COLUMN [VALUEDESC11] nVarchar(Max) ;
 GO 
ALTER TABLE [dbo].[AINFO] ALTER COLUMN [VALUEDESC12] nVarchar(Max) ;
 GO 
ALTER TABLE [dbo].[AINFO] ALTER COLUMN [VALUEDESC13] nVarchar(Max) ;
 GO 
ALTER TABLE [dbo].[AINFO] ALTER COLUMN [VALUEDESC14] nVarchar(Max) ;
 GO 
ALTER TABLE [dbo].[AINFO] ALTER COLUMN [VALUEDESC15] nVarchar(Max) ;
 GO 
ALTER TABLE [dbo].[AINFO] ALTER COLUMN [VALUEDESC2] nVarchar(Max) ;
 GO 
ALTER TABLE [dbo].[AINFO] ALTER COLUMN [VALUEDESC3] nVarchar(Max) ;
 GO 
ALTER TABLE [dbo].[AINFO] ALTER COLUMN [VALUEDESC4] nVarchar(Max) ;
 GO 
ALTER TABLE [dbo].[AINFO] ALTER COLUMN [VALUEDESC5] nVarchar(Max) ;
 GO 
ALTER TABLE [dbo].[AINFO] ALTER COLUMN [VALUEDESC6] nVarchar(Max) ;
 GO 
ALTER TABLE [dbo].[AINFO] ALTER COLUMN [VALUEDESC7] nVarchar(Max) ;
 GO 
ALTER TABLE [dbo].[AINFO] ALTER COLUMN [VALUEDESC8] nVarchar(Max) ;
 GO 
ALTER TABLE [dbo].[AINFO] ALTER COLUMN [VALUEDESC9] nVarchar(Max) ;
 GO 
ALTER TABLE [dbo].[AINFO_EXT] ALTER COLUMN [VALUEDESC16] nVarchar(Max) ;
 GO 
ALTER TABLE [dbo].[AINFO_EXT] ALTER COLUMN [VALUEDESC17] nVarchar(Max) ;
 GO 
ALTER TABLE [dbo].[AINFO_EXT] ALTER COLUMN [VALUEDESC18] nVarchar(Max) ;
 GO 
ALTER TABLE [dbo].[AINFO_EXT] ALTER COLUMN [VALUEDESC19] nVarchar(Max) ;
 GO 
ALTER TABLE [dbo].[AINFO_EXT] ALTER COLUMN [VALUEDESC20] nVarchar(Max) ;
 GO 
ALTER TABLE [dbo].[AINFO_EXT] ALTER COLUMN [VALUEDESC21] nVarchar(Max) ;
 GO 
ALTER TABLE [dbo].[AINFO_EXT] ALTER COLUMN [VALUEDESC22] nVarchar(Max) ;
 GO 
ALTER TABLE [dbo].[AINFO_EXT] ALTER COLUMN [VALUEDESC23] nVarchar(Max) ;
 GO 
ALTER TABLE [dbo].[AINFO_EXT] ALTER COLUMN [VALUEDESC24] nVarchar(Max) ;
 GO 
ALTER TABLE [dbo].[AINFO_EXT] ALTER COLUMN [VALUEDESC25] nVarchar(Max) ;
 GO 
ALTER TABLE [dbo].[AINFO_EXT] ALTER COLUMN [VALUEDESC26] nVarchar(Max) ;
 GO 
ALTER TABLE [dbo].[AINFO_EXT] ALTER COLUMN [VALUEDESC27] nVarchar(Max) ;
 GO 
ALTER TABLE [dbo].[AINFO_EXT] ALTER COLUMN [VALUEDESC28] nVarchar(Max) ;
 GO 
ALTER TABLE [dbo].[AINFO_EXT] ALTER COLUMN [VALUEDESC29] nVarchar(Max) ;
 GO 
ALTER TABLE [dbo].[AINFO_EXT] ALTER COLUMN [VALUEDESC30] nVarchar(Max) ;
 GO 
ALTER TABLE [dbo].[AINFODET] ALTER COLUMN [AUserID] nVarChar(50) ;
 GO 
ALTER TABLE [dbo].[AINFODET] ALTER COLUMN [ContractDescription] nVarchar(512) ;
 GO 
ALTER TABLE [dbo].[AINFODET] ALTER COLUMN [CUserID] nVarChar(50) ;
 GO 
ALTER TABLE [dbo].[AINFODET] ALTER COLUMN [Last_Opr] nVarChar(50) ;
 GO 
ALTER TABLE [dbo].[AINFODET] ALTER COLUMN [Notes] nVarChar(max) ;
 GO 
ALTER TABLE [dbo].[AINFODET] ALTER COLUMN [REMARKS] nVarChar(255) ;
 GO 
ALTER TABLE [dbo].[AINFODET] ALTER COLUMN [RequestMessage] nVarChar(max) ;
 GO 
ALTER TABLE [dbo].[AINFODET] ALTER COLUMN [RequestName] nVarChar(50) ;
 GO 
ALTER TABLE [dbo].[AINFODETPIC] ALTER COLUMN [Last_Opr] nVarChar(50) ;
 GO 
ALTER TABLE [dbo].[AINFODETPIC] ALTER COLUMN [Remark] nVarChar(max) ;
 GO 
ALTER TABLE [dbo].[AINFODETPIC] ALTER COLUMN [Title] nVarChar(255) ;
 GO 
ALTER TABLE [dbo].[ALBucket] ALTER COLUMN [CUserID] nVarChar(50) ;
 GO 
ALTER TABLE [dbo].[ALBucket] ALTER COLUMN [Insured] nVarChar(max) ;
 GO 
ALTER TABLE [dbo].[ALBucket] ALTER COLUMN [Last_Opr] nVarChar(50) ;
 GO 
ALTER TABLE [dbo].[ALBucket] ALTER COLUMN [PUserID] nVarChar(50) ;
 GO 
ALTER TABLE [dbo].[ALBucket] ALTER COLUMN [Remarks] nVarChar(255) ;
 GO 
ALTER TABLE [dbo].[ALRule] ALTER COLUMN [Last_Opr] nVarChar(50) ;
 GO 
ALTER TABLE [dbo].[AmortizationD] ALTER COLUMN [Last_Opr] nVarChar(50) ;
 GO 
ALTER TABLE [dbo].[AmortizationH] ALTER COLUMN [Description] nVarchar(100) ;
 GO 
ALTER TABLE [dbo].[AmortizationH] ALTER COLUMN [Last_Opr] nVarChar(50) ;
 GO 
ALTER TABLE [dbo].[AmorType] ALTER COLUMN [Description] nVarchar(50) ;
 GO 
ALTER TABLE [dbo].[AmorType] ALTER COLUMN [Last_Opr] nVarChar(50) ;
 GO 
ALTER TABLE [dbo].[APayor] ALTER COLUMN [ADDRESS_1] nVarChar(255) ;
 GO 
ALTER TABLE [dbo].[APayor] ALTER COLUMN [ADDRESS_2] nVarChar(255) ;
 GO 
ALTER TABLE [dbo].[APayor] ALTER COLUMN [ADDRESS_3] nVarChar(255) ;
 GO 
ALTER TABLE [dbo].[APayor] ALTER COLUMN [BankName] nVarChar(150) ;
 GO 
ALTER TABLE [dbo].[APayor] ALTER COLUMN [LUserID] nVarChar(50) ;
 GO 
ALTER TABLE [dbo].[APBucket] ALTER COLUMN [Last_Opr] nVarChar(50) ;
 GO 
ALTER TABLE [dbo].[APBucket] ALTER COLUMN [Remarks] nVarChar(255) ;
 GO 
ALTER TABLE [dbo].[APDBucket] ALTER COLUMN [Last_Opr] nVarChar(50) ;
 GO 
ALTER TABLE [dbo].[APDBucket] ALTER COLUMN [SaveLocation] nVarChar(255) ;
 GO 
ALTER TABLE [dbo].[APDBucket] ALTER COLUMN [SaveLocationAttachment_1] nVarChar(255) ;
 GO 
ALTER TABLE [dbo].[APDBucket] ALTER COLUMN [SaveLocationAttachment_2] nVarChar(255) ;
 GO 
ALTER TABLE [dbo].[APDBucket] ALTER COLUMN [SaveLocationAttachment_3] nVarChar(255) ;
 GO 
ALTER TABLE [dbo].[APDBucket] ALTER COLUMN [SaveLocationAttachment_4] nVarChar(255) ;
 GO 
ALTER TABLE [dbo].[APDBucket] ALTER COLUMN [SaveLocationAttachment_5] nVarChar(255) ;
 GO 
ALTER TABLE [dbo].[APDBucket] ALTER COLUMN [SaveLocationAttachment_6] nVarChar(255) ;
 GO 
ALTER TABLE [dbo].[APDBucket] ALTER COLUMN [SaveLocationAttachment_7] nVarChar(255) ;
 GO 
ALTER TABLE [dbo].[APDBucket] ALTER COLUMN [SaveLocationAttachment_8] nVarChar(255) ;
 GO 
ALTER TABLE [dbo].[APDRuleD] ALTER COLUMN [Last_Opr] nVarChar(50) ;
 GO 
ALTER TABLE [dbo].[APDRuleH] ALTER COLUMN [Last_Opr] nVarChar(50) ;
 GO 
ALTER TABLE [dbo].[ARBucket] ALTER COLUMN [Last_Opr] nVarChar(50) ;
 GO 
ALTER TABLE [dbo].[ARBucket] ALTER COLUMN [Remarks] nVarChar(512) ;
 GO 
ALTER TABLE [dbo].[Area] ALTER COLUMN [Description] nVarchar(50) ;
 GO 
ALTER TABLE [dbo].[Area] ALTER COLUMN [Last_Opr] nVarChar(50) ;
 GO 
ALTER TABLE [dbo].[AutoNum] ALTER COLUMN [Description] nVarchar(50) ;
 GO 
ALTER TABLE [dbo].[AutoNum] ALTER COLUMN [Last_Opr] nVarChar(50) ;
 GO 
ALTER TABLE [dbo].[Balance_Type] ALTER COLUMN [Description] nVarchar(100) ;
 GO 
ALTER TABLE [dbo].[Bank] ALTER COLUMN [Description] nVarchar(100) ;
 GO 
ALTER TABLE [dbo].[Bank] ALTER COLUMN [Last_Opr] nVarChar(50) ;
 GO 
ALTER TABLE [dbo].[BankBranch] ALTER COLUMN [Address_1] nVarChar(255) ;
 GO 
ALTER TABLE [dbo].[BankBranch] ALTER COLUMN [Address_2] nVarChar(255) ;
 GO 
ALTER TABLE [dbo].[BankBranch] ALTER COLUMN [Address_3] nVarChar(255) ;
 GO 
ALTER TABLE [dbo].[BankBranch] ALTER COLUMN [Last_Opr] nVarChar(50) ;
 GO 
ALTER TABLE [dbo].[BAssumption_Exchange] ALTER COLUMN [Last_Opr] nVarChar(50) ;
 GO 
ALTER TABLE [dbo].[BAssumption_Growth] ALTER COLUMN [Last_Opr] nVarChar(50) ;
 GO 
ALTER TABLE [dbo].[BAssumption_Rate] ALTER COLUMN [Last_Opr] nVarChar(50) ;
 GO 
ALTER TABLE [dbo].[BAssumption_Ratio] ALTER COLUMN [Last_Opr] nVarChar(50) ;
 GO 
ALTER TABLE [dbo].[Beneficiaries] ALTER COLUMN [Address_1] nVarChar(255) ;
 GO 
ALTER TABLE [dbo].[Beneficiaries] ALTER COLUMN [Address_2] nVarChar(255) ;
 GO 
ALTER TABLE [dbo].[Beneficiaries] ALTER COLUMN [REMARK] nVarChar(255) ;
 GO 
ALTER TABLE [dbo].[BIAsset] ALTER COLUMN [Description] nVarchar(255) ;
 GO 
ALTER TABLE [dbo].[BIType] ALTER COLUMN [Description] nVarchar(255) ;
 GO 
ALTER TABLE [dbo].[BIType] ALTER COLUMN [Last_Opr] nVarChar(50) ;
 GO 
ALTER TABLE [dbo].[BizMap] ALTER COLUMN [Description] nVarchar(100) ;
 GO 
ALTER TABLE [dbo].[BizMap] ALTER COLUMN [Last_Opr] nVarChar(50) ;
 GO 
ALTER TABLE [dbo].[Blanket] ALTER COLUMN [LUserID] nVarChar(50) ;
 GO 
ALTER TABLE [dbo].[Blanket] ALTER COLUMN [UserID] nVarChar(50) ;
 GO 
ALTER TABLE [dbo].[Blanket_Delivery] ALTER COLUMN [LUserID] nVarChar(50) ;
 GO 
ALTER TABLE [dbo].[Blanket_Delivery] ALTER COLUMN [UserID] nVarChar(50) ;
 GO 
ALTER TABLE [dbo].[Blanket_Delivery_Detail] ALTER COLUMN [LUserID] nVarChar(50) ;
 GO 
ALTER TABLE [dbo].[Blanket_Delivery_Detail] ALTER COLUMN [UserID] nVarChar(50) ;
 GO 
ALTER TABLE [dbo].[BPP] ALTER COLUMN [Description] nVarchar(50) ;
 GO 
ALTER TABLE [dbo].[BPP] ALTER COLUMN [Last_Opr] nVarChar(50) ;
 GO 
ALTER TABLE [dbo].[Branch] ALTER COLUMN [Address] nVarChar(70) ;
 GO 
ALTER TABLE [dbo].[Branch] ALTER COLUMN [Email] nVarChar(512) ;
 GO 
ALTER TABLE [dbo].[Branch] ALTER COLUMN [Last_Opr] nVarChar(50) ;
 GO 
ALTER TABLE [dbo].[Branch] ALTER COLUMN [PICTitle] nVarChar(50) ;
 GO 
ALTER TABLE [dbo].[Branch] ALTER COLUMN [SignerTitle] nVarChar(255) ;
 GO 
ALTER TABLE [dbo].[Branch] ALTER COLUMN [SignerTitle_1] nVarChar(255) ;
 GO 
ALTER TABLE [dbo].[Branch] ALTER COLUMN [SignerTitle_2] nVarChar(255) ;
 GO 
ALTER TABLE [dbo].[BRRule] ALTER COLUMN [ExtraCostDesc_1] nVarChar(100) ;
 GO 
ALTER TABLE [dbo].[BRRule] ALTER COLUMN [ExtraCostDesc_2] nVarchar(100) ;
 GO 
ALTER TABLE [dbo].[BRRule] ALTER COLUMN [ExtraCostDesc_3] nVarChar(100) ;
 GO 
ALTER TABLE [dbo].[BRRule] ALTER COLUMN [ExtraCostDesc_4] nVarchar(100) ;
 GO 
ALTER TABLE [dbo].[BRRule] ALTER COLUMN [ExtraCostDesc_5] nVarChar(100) ;
 GO 
ALTER TABLE [dbo].[BRRule] ALTER COLUMN [ExtraCostDesc_6] nVarchar(100) ;
 GO 
ALTER TABLE [dbo].[BRRule] ALTER COLUMN [ExtraCostDesc_7] nVarChar(100) ;
 GO 
ALTER TABLE [dbo].[BRRule] ALTER COLUMN [Last_Opr] nVarChar(50) ;
 GO 
ALTER TABLE [dbo].[BSOPEX] ALTER COLUMN [Last_Opr] nVarChar(50) ;
 GO 
ALTER TABLE [dbo].[BSOPEX] ALTER COLUMN [REMARK] nVarChar(50) ;
 GO 
ALTER TABLE [dbo].[BSOPEXDET] ALTER COLUMN [Last_Opr] nVarChar(50) ;
 GO 
ALTER TABLE [dbo].[BSOPEXDET] ALTER COLUMN [VALUEDESC1] nVarchar(Max) ;
 GO 
ALTER TABLE [dbo].[BSOPEXDET] ALTER COLUMN [VALUEDESC10] nVarchar(Max) ;
 GO 
ALTER TABLE [dbo].[BSOPEXDET] ALTER COLUMN [VALUEDESC11] nVarchar(Max) ;
 GO 
ALTER TABLE [dbo].[BSOPEXDET] ALTER COLUMN [VALUEDESC12] nVarchar(Max) ;
 GO 
ALTER TABLE [dbo].[BSOPEXDET] ALTER COLUMN [VALUEDESC13] nVarchar(Max) ;
 GO 
ALTER TABLE [dbo].[BSOPEXDET] ALTER COLUMN [VALUEDESC14] nVarchar(Max) ;
 GO 
ALTER TABLE [dbo].[BSOPEXDET] ALTER COLUMN [VALUEDESC15] nVarchar(Max) ;
 GO 
ALTER TABLE [dbo].[BSOPEXDET] ALTER COLUMN [VALUEDESC2] nVarchar(Max) ;
 GO 
ALTER TABLE [dbo].[BSOPEXDET] ALTER COLUMN [VALUEDESC3] nVarchar(Max) ;
 GO 
ALTER TABLE [dbo].[BSOPEXDET] ALTER COLUMN [VALUEDESC4] nVarchar(Max) ;
 GO 
ALTER TABLE [dbo].[BSOPEXDET] ALTER COLUMN [VALUEDESC5] nVarchar(Max) ;
 GO 
ALTER TABLE [dbo].[BSOPEXDET] ALTER COLUMN [VALUEDESC6] nVarchar(Max) ;
 GO 
ALTER TABLE [dbo].[BSOPEXDET] ALTER COLUMN [VALUEDESC7] nVarchar(Max) ;
 GO 
ALTER TABLE [dbo].[BSOPEXDET] ALTER COLUMN [VALUEDESC8] nVarchar(Max) ;
 GO 
ALTER TABLE [dbo].[BSOPEXDET] ALTER COLUMN [VALUEDESC9] nVarchar(Max) ;
 GO 
ALTER TABLE [dbo].[BSTYPE] ALTER COLUMN [DESCRIPTION] nVarchar(20) ;
 GO 
ALTER TABLE [dbo].[Budget_Account] ALTER COLUMN [Description] nVarchar(100) ;
 GO 
ALTER TABLE [dbo].[Budget_Account] ALTER COLUMN [Last_Opr] nVarChar(50) ;
 GO 
ALTER TABLE [dbo].[Budget_AccountDetail] ALTER COLUMN [Description] nVarchar(100) ;
 GO 
ALTER TABLE [dbo].[Budget_AccountDetail] ALTER COLUMN [Last_Opr] nVarChar(50) ;
 GO 
ALTER TABLE [dbo].[Budget_AccountGroup] ALTER COLUMN [Description] nVarchar(50) ;
 GO 
ALTER TABLE [dbo].[Budget_AccountGroup] ALTER COLUMN [Last_Opr] nVarChar(50) ;
 GO 
ALTER TABLE [dbo].[Budget_Activity] ALTER COLUMN [Last_Opr] nVarChar(50) ;
 GO 
ALTER TABLE [dbo].[Budget_Center] ALTER COLUMN [Last_Opr] nVarChar(50) ;
 GO 
ALTER TABLE [dbo].[Budget_Entry] ALTER COLUMN [AUserID] nVarChar(50) ;
 GO 
ALTER TABLE [dbo].[Budget_Entry] ALTER COLUMN [Last_Opr] nVarChar(50) ;
 GO 
ALTER TABLE [dbo].[Budget_Entry] ALTER COLUMN [Remarks] nVarChar(50) ;
 GO 
ALTER TABLE [dbo].[Budget_Entry_Hist] ALTER COLUMN [Last_Opr] nVarChar(50) ;
 GO 
ALTER TABLE [dbo].[Budget_Entry_Hist] ALTER COLUMN [Remarks] nVarChar(50) ;
 GO 
ALTER TABLE [dbo].[BusinessResult] ALTER COLUMN [ExtraCostDesc_1] nVarChar(100) ;
 GO 
ALTER TABLE [dbo].[BusinessResult] ALTER COLUMN [ExtraCostDesc_2] nVarchar(100) ;
 GO 
ALTER TABLE [dbo].[BusinessResult] ALTER COLUMN [ExtraCostDesc_3] nVarChar(100) ;
 GO 
ALTER TABLE [dbo].[BusinessResult] ALTER COLUMN [ExtraCostDesc_4] nVarchar(100) ;
 GO 
ALTER TABLE [dbo].[BusinessResult] ALTER COLUMN [ExtraCostDesc_5] nVarChar(100) ;
 GO 
ALTER TABLE [dbo].[BusinessResult] ALTER COLUMN [ExtraCostDesc_6] nVarchar(100) ;
 GO 
ALTER TABLE [dbo].[BusinessResult] ALTER COLUMN [ExtraCostDesc_7] nVarChar(100) ;
 GO 
ALTER TABLE [dbo].[CArrDetail] ALTER COLUMN [LUserID] nVarChar(50) ;
 GO 
ALTER TABLE [dbo].[CARRHEADER] ALTER COLUMN [LUserID] nVarChar(50) ;
 GO 
ALTER TABLE [dbo].[CCTYPE] ALTER COLUMN [Description] nVarchar(255) ;
 GO 
ALTER TABLE [dbo].[CCTYPE] ALTER COLUMN [Last_Opr] nVarChar(50) ;
 GO 
ALTER TABLE [dbo].[CDOCLIST] ALTER COLUMN [DESCRIPTION] nVarchar(255) ;
 GO 
ALTER TABLE [dbo].[CDOCLIST] ALTER COLUMN [LAST_OPR] nVarChar(50) ;
 GO 
ALTER TABLE [dbo].[CDOCLIST] ALTER COLUMN [REMARKS] nVarChar(512) ;
 GO 
ALTER TABLE [dbo].[CDOCLISTPIC] ALTER COLUMN [Last_Opr] nVarChar(50) ;
 GO 
ALTER TABLE [dbo].[CDOCLISTPIC] ALTER COLUMN [Remark] nVarChar(Max) ;
 GO 
ALTER TABLE [dbo].[CDOCLISTPIC] ALTER COLUMN [Title] nVarChar(255) ;
 GO 
ALTER TABLE [dbo].[CDOCSTAT] ALTER COLUMN [Last_Opr] nVarChar(50) ;
 GO 
ALTER TABLE [dbo].[CGroup] ALTER COLUMN [Description] nVarchar(100) ;
 GO 
ALTER TABLE [dbo].[CGroup] ALTER COLUMN [Last_Opr] nVarChar(50) ;
 GO 
ALTER TABLE [dbo].[Cheque] ALTER COLUMN [Address] nVarChar(50) ;
 GO 
ALTER TABLE [dbo].[Cheque] ALTER COLUMN [BankName] nVarChar(150) ;
 GO 
ALTER TABLE [dbo].[Cheque] ALTER COLUMN [Last_Opr] nVarChar(50) ;
 GO 
ALTER TABLE [dbo].[Cheque] ALTER COLUMN [Location] nVarChar(10) ;
 GO 
ALTER TABLE [dbo].[Cheque] ALTER COLUMN [Remarks] nVarChar(255) ;
 GO 
ALTER TABLE [dbo].[CINFO] ALTER COLUMN [VALUEDESC1] nVarchar(Max) ;
 GO 
ALTER TABLE [dbo].[CINFO] ALTER COLUMN [VALUEDESC10] nVarchar(Max) ;
 GO 
ALTER TABLE [dbo].[CINFO] ALTER COLUMN [VALUEDESC11] nVarchar(Max) ;
 GO 
ALTER TABLE [dbo].[CINFO] ALTER COLUMN [VALUEDESC12] nVarchar(Max) ;
 GO 
ALTER TABLE [dbo].[CINFO] ALTER COLUMN [VALUEDESC13] nVarchar(Max) ;
 GO 
ALTER TABLE [dbo].[CINFO] ALTER COLUMN [VALUEDESC14] nVarchar(Max) ;
 GO 
ALTER TABLE [dbo].[CINFO] ALTER COLUMN [VALUEDESC15] nVarchar(Max) ;
 GO 
ALTER TABLE [dbo].[CINFO] ALTER COLUMN [VALUEDESC2] nVarchar(Max) ;
 GO 
ALTER TABLE [dbo].[CINFO] ALTER COLUMN [VALUEDESC3] nVarchar(Max) ;
 GO 
ALTER TABLE [dbo].[CINFO] ALTER COLUMN [VALUEDESC4] nVarchar(Max) ;
 GO 
ALTER TABLE [dbo].[CINFO] ALTER COLUMN [VALUEDESC5] nVarchar(Max) ;
 GO 
ALTER TABLE [dbo].[CINFO] ALTER COLUMN [VALUEDESC6] nVarchar(Max) ;
 GO 
ALTER TABLE [dbo].[CINFO] ALTER COLUMN [VALUEDESC7] nVarchar(Max) ;
 GO 
ALTER TABLE [dbo].[CINFO] ALTER COLUMN [VALUEDESC8] nVarchar(Max) ;
 GO 
ALTER TABLE [dbo].[CINFO] ALTER COLUMN [VALUEDESC9] nVarchar(Max) ;
 GO 
ALTER TABLE [dbo].[City] ALTER COLUMN [Description] nVarchar(50) ;
 GO 
ALTER TABLE [dbo].[City] ALTER COLUMN [Last_Opr] nVarChar(50) ;
 GO 
ALTER TABLE [dbo].[CLAASS] ALTER COLUMN [REMARKS] nVarChar(1024) ;
 GO 
ALTER TABLE [dbo].[CLAIM] ALTER COLUMN [Assessor] nVarChar(50) ;
 GO 
ALTER TABLE [dbo].[CLAIM] ALTER COLUMN [AUserID] nVarChar(50) ;
 GO 
ALTER TABLE [dbo].[CLAIM] DROP CONSTRAINT [FK_CLAIM_Profile];
 GO 
ALTER TABLE [dbo].[CLAIM] ALTER COLUMN [Claimant] nVarChar(50) ;
 GO 
ALTER TABLE [dbo].[CLAIM] WITH NOCHECK ADD CONSTRAINT [FK_CLAIM_Profile] FOREIGN KEY ([Claimant]) REFERENCES [dbo].[Profile]([ID]);
 GO 
ALTER TABLE [dbo].[CLAIM] ALTER COLUMN [ClaimantEmail] nVarChar(255) ;
 GO 
ALTER TABLE [dbo].[CLAIM] ALTER COLUMN [ClaimantInfo] nVarChar(255) ;
 GO 
ALTER TABLE [dbo].[CLAIM] ALTER COLUMN [ClaimantMobile] nVarChar(30) ;
 GO 
ALTER TABLE [dbo].[CLAIM] ALTER COLUMN [ClaimantPhone] nVarChar(30) ;
 GO 
ALTER TABLE [dbo].[CLAIM] ALTER COLUMN [Comment] nVarchar(Max) ;
 GO 
ALTER TABLE [dbo].[CLAIM] ALTER COLUMN [CUSERID] nVarChar(50) ;
 GO 
ALTER TABLE [dbo].[CLAIM] ALTER COLUMN [Description] nVarchar(max) ;
 GO 
ALTER TABLE [dbo].[CLAIM] ALTER COLUMN [EventName] nVarChar(50) ;
 GO 
ALTER TABLE [dbo].[CLAIM] ALTER COLUMN [Location] nVarChar(10) ;
 GO 
ALTER TABLE [dbo].[CLAIM] ALTER COLUMN [LossPlace] nVarChar(150) ;
 GO 
ALTER TABLE [dbo].[CLAIM] ALTER COLUMN [LUserID] nVarChar(50) ;
 GO 
ALTER TABLE [dbo].[CLAIM] ALTER COLUMN [Notes] nVarChar(512) ;
 GO 
ALTER TABLE [dbo].[CLAIM] ALTER COLUMN [PUserID] nVarChar(50) ;
 GO 
ALTER TABLE [dbo].[CLAIM] ALTER COLUMN [Reason] nVarChar(10) ;
 GO 
ALTER TABLE [dbo].[CLAIM] ALTER COLUMN [Remarks] nVarchar(Max) ;
 GO 
ALTER TABLE [dbo].[CLAIM] ALTER COLUMN [RequestMessage] nVarchar(Max) ;
 GO 
ALTER TABLE [dbo].[CLAIM] ALTER COLUMN [RequestName] nVarChar(50) ;
 GO 
ALTER TABLE [dbo].[CLAIM] ALTER COLUMN [RUserID] nVarChar(50) ;
 GO 
ALTER TABLE [dbo].[CLAIM] ALTER COLUMN [SACAUserID] nVarChar(50) ;
 GO 
ALTER TABLE [dbo].[CLAIM] ALTER COLUMN [Surveyor] nVarChar(50) ;
 GO 
ALTER TABLE [dbo].[CLAIM] ALTER COLUMN [SysUserID] nVarChar(50) ;
 GO 
ALTER TABLE [dbo].[CLAIM] ALTER COLUMN [UserID] nVarChar(50) ;
 GO 
ALTER TABLE [dbo].[ClaimantType] ALTER COLUMN [Description] nVarchar(255) ;
 GO 
ALTER TABLE [dbo].[ClaimantType] ALTER COLUMN [Last_Opr] nVarChar(50) ;
 GO 
ALTER TABLE [dbo].[ClaimPaymentSchedule] ALTER COLUMN [Last_Opr] nVarChar(50) ;
 GO 
ALTER TABLE [dbo].[CLComplaint] ALTER COLUMN [CDESCRIPTION] nVarchar(max) ;
 GO 
ALTER TABLE [dbo].[CLComplaint] ALTER COLUMN [COMMENT] nVarChar(255) ;
 GO 
ALTER TABLE [dbo].[CLComplaint] ALTER COLUMN [CUserID] nVarChar(50) ;
 GO 
ALTER TABLE [dbo].[CLComplaint] ALTER COLUMN [LUserID] nVarChar(50) ;
 GO 
ALTER TABLE [dbo].[CLComplaint] ALTER COLUMN [REMARKS] nVarChar(255) ;
 GO 
ALTER TABLE [dbo].[CLComplaint] ALTER COLUMN [ReporterEmail] nVarChar(255) ;
 GO 
ALTER TABLE [dbo].[CLComplaint] ALTER COLUMN [UserID] nVarChar(50) ;
 GO 
ALTER TABLE [dbo].[CLCOST] ALTER COLUMN [AUserID] nVarChar(50) ;
 GO 
ALTER TABLE [dbo].[CLCOST] ALTER COLUMN [CUserID] nVarChar(50) ;
 GO 
ALTER TABLE [dbo].[CLCOST] ALTER COLUMN [Last_Opr] nVarChar(50) ;
 GO 
ALTER TABLE [dbo].[CLCOST] ALTER COLUMN [PICEmail] nVarChar(255) ;
 GO 
ALTER TABLE [dbo].[CLCOST] ALTER COLUMN [Remark] nVarChar(255) ;
 GO 
ALTER TABLE [dbo].[CLCOST] ALTER COLUMN [RequestMessage] nVarChar(max) ;
 GO 
ALTER TABLE [dbo].[CLCOST] ALTER COLUMN [RequestName] nVarChar(50) ;
 GO 
ALTER TABLE [dbo].[CLCOSTPIC] ALTER COLUMN [Last_Opr] nVarChar(50) ;
 GO 
ALTER TABLE [dbo].[CLCOSTPIC] ALTER COLUMN [Remark] nVarChar(max) ;
 GO 
ALTER TABLE [dbo].[CLCOSTPIC] ALTER COLUMN [Title] nVarChar(255) ;
 GO 
ALTER TABLE [dbo].[CLDED] ALTER COLUMN [DESCRIPTION] nVarchar(2048) ;
 GO 
ALTER TABLE [dbo].[CLDED] ALTER COLUMN [Last_Opr] nVarChar(50) ;
 GO 
ALTER TABLE [dbo].[CLDED] ALTER COLUMN [REMARK] nVarChar(2048) ;
 GO 
ALTER TABLE [dbo].[CLDED] ALTER COLUMN [REMARKS_1] nVarChar(900) ;
 GO 
ALTER TABLE [dbo].[CLFACDED] ALTER COLUMN [DESCRIPTION] nVarchar(2048) ;
 GO 
ALTER TABLE [dbo].[CLFACDED] ALTER COLUMN [Last_Opr] nVarChar(50) ;
 GO 
ALTER TABLE [dbo].[CLFACDED] ALTER COLUMN [REMARK] nVarChar(2048) ;
 GO 
ALTER TABLE [dbo].[CLFACDED] ALTER COLUMN [REMARKS_1] nVarChar(255) ;
 GO 
ALTER TABLE [dbo].[CLFD] ALTER COLUMN [Last_Opr] nVarChar(50) ;
 GO 
ALTER TABLE [dbo].[CLFD] ALTER COLUMN [REMARK] nVarChar(50) ;
 GO 
DROP INDEX [dbo].[CLINFO].[I_CLINFO];
 GO 
ALTER TABLE [dbo].[CLINFO] ALTER COLUMN [CLaimant] nVarChar(10) NOT NULL;
 GO 
CREATE UNIQUE NONCLUSTERED INDEX [I_CLINFO] ON [dbo].[CLINFO] (  [CNO] , [INO] , [NOC] , [CLaimant] )
 GO 
ALTER TABLE [dbo].[CLINFO] ALTER COLUMN [Last_Opr] nVarChar(50) ;
 GO 
ALTER TABLE [dbo].[CLINFO] ALTER COLUMN [VALUEDESC1] nVarchar(Max) ;
 GO 
ALTER TABLE [dbo].[CLINFO] ALTER COLUMN [VALUEDESC10] nVarchar(Max) ;
 GO 
ALTER TABLE [dbo].[CLINFO] ALTER COLUMN [VALUEDESC11] nVarchar(Max) ;
 GO 
ALTER TABLE [dbo].[CLINFO] ALTER COLUMN [VALUEDESC12] nVarchar(Max) ;
 GO 
ALTER TABLE [dbo].[CLINFO] ALTER COLUMN [VALUEDESC13] nVarchar(Max) ;
 GO 
ALTER TABLE [dbo].[CLINFO] ALTER COLUMN [VALUEDESC14] nVarchar(Max) ;
 GO 
ALTER TABLE [dbo].[CLINFO] ALTER COLUMN [VALUEDESC15] nVarchar(Max) ;
 GO 
ALTER TABLE [dbo].[CLINFO] ALTER COLUMN [VALUEDESC2] nVarchar(Max) ;
 GO 
ALTER TABLE [dbo].[CLINFO] ALTER COLUMN [VALUEDESC3] nVarchar(Max) ;
 GO 
ALTER TABLE [dbo].[CLINFO] ALTER COLUMN [VALUEDESC4] nVarchar(Max) ;
 GO 
ALTER TABLE [dbo].[CLINFO] ALTER COLUMN [VALUEDESC5] nVarchar(Max) ;
 GO 
ALTER TABLE [dbo].[CLINFO] ALTER COLUMN [VALUEDESC6] nVarchar(Max) ;
 GO 
ALTER TABLE [dbo].[CLINFO] ALTER COLUMN [VALUEDESC7] nVarchar(Max) ;
 GO 
ALTER TABLE [dbo].[CLINFO] ALTER COLUMN [VALUEDESC8] nVarchar(Max) ;
 GO 
ALTER TABLE [dbo].[CLINFO] ALTER COLUMN [VALUEDESC9] nVarchar(Max) ;
 GO 
ALTER TABLE [dbo].[CLINFOSUPL] ALTER COLUMN [Last_Opr] nVarChar(50) ;
 GO 
ALTER TABLE [dbo].[CLINFOSUPL] ALTER COLUMN [VALUEDESC1] nVarchar(Max) ;
 GO 
ALTER TABLE [dbo].[CLINFOSUPL] ALTER COLUMN [VALUEDESC10] nVarchar(Max) ;
 GO 
ALTER TABLE [dbo].[CLINFOSUPL] ALTER COLUMN [VALUEDESC11] nVarchar(Max) ;
 GO 
ALTER TABLE [dbo].[CLINFOSUPL] ALTER COLUMN [VALUEDESC12] nVarchar(Max) ;
 GO 
ALTER TABLE [dbo].[CLINFOSUPL] ALTER COLUMN [VALUEDESC13] nVarchar(Max) ;
 GO 
ALTER TABLE [dbo].[CLINFOSUPL] ALTER COLUMN [VALUEDESC14] nVarchar(Max) ;
 GO 
ALTER TABLE [dbo].[CLINFOSUPL] ALTER COLUMN [VALUEDESC15] nVarchar(Max) ;
 GO 
ALTER TABLE [dbo].[CLINFOSUPL] ALTER COLUMN [VALUEDESC2] nVarchar(Max) ;
 GO 
ALTER TABLE [dbo].[CLINFOSUPL] ALTER COLUMN [VALUEDESC3] nVarchar(Max) ;
 GO 
ALTER TABLE [dbo].[CLINFOSUPL] ALTER COLUMN [VALUEDESC4] nVarchar(Max) ;
 GO 
ALTER TABLE [dbo].[CLINFOSUPL] ALTER COLUMN [VALUEDESC5] nVarchar(Max) ;
 GO 
ALTER TABLE [dbo].[CLINFOSUPL] ALTER COLUMN [VALUEDESC6] nVarchar(Max) ;
 GO 
ALTER TABLE [dbo].[CLINFOSUPL] ALTER COLUMN [VALUEDESC7] nVarchar(Max) ;
 GO 
ALTER TABLE [dbo].[CLINFOSUPL] ALTER COLUMN [VALUEDESC8] nVarchar(Max) ;
 GO 
ALTER TABLE [dbo].[CLINFOSUPL] ALTER COLUMN [VALUEDESC9] nVarchar(Max) ;
 GO 
DROP INDEX [dbo].[CLItem].[I_CLITEM];
 GO 
ALTER TABLE [dbo].[CLItem] ALTER COLUMN [Description] nVarchar(255) NOT NULL;
 GO 
CREATE UNIQUE NONCLUSTERED INDEX [I_CLITEM] ON [dbo].[CLItem] (  [CNO] , [INO] , [NOC] , [Payment] , [Currency] , [RefNo] , [Item] , [Description] )
 GO 
ALTER TABLE [dbo].[CLLOSS] ALTER COLUMN [Claimant] nVarChar(10) ;
 GO 
ALTER TABLE [dbo].[CLLOSS] ALTER COLUMN [DeliveredTo] nVarChar(512) ;
 GO 
ALTER TABLE [dbo].[CLLOSS] ALTER COLUMN [Description] nVarchar(2048) ;
 GO 
ALTER TABLE [dbo].[CLLOSS] ALTER COLUMN [InvoiceRemarks] nVarChar(255) ;
 GO 
ALTER TABLE [dbo].[CLLOSS] ALTER COLUMN [Last_Opr] nVarChar(50) ;
 GO 
ALTER TABLE [dbo].[CLLOSS] ALTER COLUMN [Remark] nVarChar(2048) ;
 GO 
ALTER TABLE [dbo].[CLNOTES] ALTER COLUMN [LBLNotes_1] nVarChar(100) ;
 GO 
ALTER TABLE [dbo].[CLNOTES] ALTER COLUMN [LBLNotes_10] nVarChar(100) ;
 GO 
ALTER TABLE [dbo].[CLNOTES] ALTER COLUMN [LBLNotes_2] nVarChar(100) ;
 GO 
ALTER TABLE [dbo].[CLNOTES] ALTER COLUMN [LBLNotes_3] nVarChar(100) ;
 GO 
ALTER TABLE [dbo].[CLNOTES] ALTER COLUMN [LBLNotes_4] nVarChar(100) ;
 GO 
ALTER TABLE [dbo].[CLNOTES] ALTER COLUMN [LBLNotes_5] nVarChar(100) ;
 GO 
ALTER TABLE [dbo].[CLNOTES] ALTER COLUMN [LBLNotes_6] nVarChar(100) ;
 GO 
ALTER TABLE [dbo].[CLNOTES] ALTER COLUMN [LBLNotes_7] nVarChar(100) ;
 GO 
ALTER TABLE [dbo].[CLNOTES] ALTER COLUMN [LBLNotes_8] nVarChar(100) ;
 GO 
ALTER TABLE [dbo].[CLNOTES] ALTER COLUMN [LBLNotes_9] nVarChar(100) ;
 GO 
ALTER TABLE [dbo].[CLNOTES] ALTER COLUMN [Notes] nVarChar(max) ;
 GO 
ALTER TABLE [dbo].[CLNOTES] ALTER COLUMN [Notes_1] nVarChar(max) ;
 GO 
ALTER TABLE [dbo].[CLNOTES] ALTER COLUMN [Notes_10] nVarChar(max) ;
 GO 
ALTER TABLE [dbo].[CLNOTES] ALTER COLUMN [Notes_2] nVarChar(max) ;
 GO 
ALTER TABLE [dbo].[CLNOTES] ALTER COLUMN [Notes_3] nVarChar(max) ;
 GO 
ALTER TABLE [dbo].[CLNOTES] ALTER COLUMN [Notes_4] nVarChar(max) ;
 GO 
ALTER TABLE [dbo].[CLNOTES] ALTER COLUMN [Notes_5] nVarChar(max) ;
 GO 
ALTER TABLE [dbo].[CLNOTES] ALTER COLUMN [Notes_6] nVarChar(max) ;
 GO 
ALTER TABLE [dbo].[CLNOTES] ALTER COLUMN [Notes_7] nVarChar(max) ;
 GO 
ALTER TABLE [dbo].[CLNOTES] ALTER COLUMN [Notes_8] nVarChar(max) ;
 GO 
ALTER TABLE [dbo].[CLNOTES] ALTER COLUMN [Notes_9] nVarChar(max) ;
 GO 
ALTER TABLE [dbo].[CLNOTES] ALTER COLUMN [UserID] nVarChar(50) ;
 GO 
ALTER TABLE [dbo].[CLNotify] ALTER COLUMN [AcceptedBy] nVarChar(100) ;
 GO 
ALTER TABLE [dbo].[CLNotify] ALTER COLUMN [Last_Opr] nVarChar(50) ;
 GO 
ALTER TABLE [dbo].[CLNotify] ALTER COLUMN [Remarks] nVarchar(Max) ;
 GO 
ALTER TABLE [dbo].[CLNotify] ALTER COLUMN [UserID] nVarChar(50) ;
 GO 
ALTER TABLE [dbo].[CLPIC] ALTER COLUMN [Last_Opr] nVarChar(50) ;
 GO 
ALTER TABLE [dbo].[CLPIC] ALTER COLUMN [Remark] nVarchar(Max) ;
 GO 
ALTER TABLE [dbo].[CLPIC] ALTER COLUMN [Title] nVarChar(255) ;
 GO 
ALTER TABLE [dbo].[CLPrintLog] ALTER COLUMN [Description] nVarchar(50) ;
 GO 
ALTER TABLE [dbo].[CLPrintLog] ALTER COLUMN [UserID] nVarChar(50) ;
 GO 
ALTER TABLE [dbo].[CLProcess] ALTER COLUMN [Last_Opr] nVarChar(50) ;
 GO 
ALTER TABLE [dbo].[CLSAL] ALTER COLUMN [Description] nVarchar(255) ;
 GO 
ALTER TABLE [dbo].[CLSAL] ALTER COLUMN [Last_Opr] nVarChar(50) ;
 GO 
ALTER TABLE [dbo].[CLSAL] ALTER COLUMN [Remark] nVarchar(Max) ;
 GO 
ALTER TABLE [dbo].[CLSALDET] ALTER COLUMN [Description] nVarchar(255) ;
 GO 
ALTER TABLE [dbo].[CLSALITEM] ALTER COLUMN [Description] nVarchar(255) ;
 GO 
ALTER TABLE [dbo].[CLSALITEM] ALTER COLUMN [Last_Opr] nVarChar(50) ;
 GO 
ALTER TABLE [dbo].[CLSALITEM] ALTER COLUMN [Location] nVarChar(10) ;
 GO 
ALTER TABLE [dbo].[CLSALITEM] ALTER COLUMN [Remarks] nVarChar(255) ;
 GO 
ALTER TABLE [dbo].[CLSub] ALTER COLUMN [Address_1] nVarChar(255) ;
 GO 
ALTER TABLE [dbo].[CLSub] ALTER COLUMN [Address_2] nVarChar(255) ;
 GO 
ALTER TABLE [dbo].[CLSub] ALTER COLUMN [Address_3] nVarChar(255) ;
 GO 
ALTER TABLE [dbo].[CLSub] ALTER COLUMN [Last_Opr] nVarChar(50) ;
 GO 
ALTER TABLE [dbo].[CLSub] ALTER COLUMN [PIC_NAME_1] nVarChar(50) ;
 GO 
ALTER TABLE [dbo].[CLSub] ALTER COLUMN [PIC_NAME_2] nVarChar(50) ;
 GO 
ALTER TABLE [dbo].[CLSub] ALTER COLUMN [PIC_NAME_3] nVarChar(50) ;
 GO 
ALTER TABLE [dbo].[CLSub] ALTER COLUMN [PIC_TITLE_1] nVarChar(255) ;
 GO 
ALTER TABLE [dbo].[CLSub] ALTER COLUMN [PIC_TITLE_2] nVarChar(255) ;
 GO 
ALTER TABLE [dbo].[CLSub] ALTER COLUMN [PIC_TITLE_3] nVarChar(255) ;
 GO 
ALTER TABLE [dbo].[CLSub] ALTER COLUMN [Remark] nVarChar(255) ;
 GO 
ALTER TABLE [dbo].[CLSub] ALTER COLUMN [ShortDesc] nVarchar(255) ;
 GO 
ALTER TABLE [dbo].[CLSUBDET] ALTER COLUMN [Description] nVarchar(255) ;
 GO 
ALTER TABLE [dbo].[CLSUBPIC] ALTER COLUMN [Last_Opr] nVarChar(50) ;
 GO 
ALTER TABLE [dbo].[CLSUBPIC] ALTER COLUMN [Remark] nVarChar(max) ;
 GO 
ALTER TABLE [dbo].[CLSUBPIC] ALTER COLUMN [Title] nVarChar(255) ;
 GO 
ALTER TABLE [dbo].[CLSurvey] ALTER COLUMN [COMMENT] nVarChar(255) ;
 GO 
ALTER TABLE [dbo].[CLSurvey] ALTER COLUMN [Last_Opr] nVarChar(50) ;
 GO 
ALTER TABLE [dbo].[CLSurvey] ALTER COLUMN [LOCATION] nVarChar(255) ;
 GO 
ALTER TABLE [dbo].[CLSurvey] ALTER COLUMN [REMARKS] nVarChar(255) ;
 GO 
ALTER TABLE [dbo].[COB] ALTER COLUMN [DESCRIPTION] nVarchar(50) ;
 GO 
ALTER TABLE [dbo].[COB] ALTER COLUMN [Last_Opr] nVarChar(50) ;
 GO 
ALTER TABLE [dbo].[COL] ALTER COLUMN [Last_Opr] nVarChar(50) ;
 GO 
ALTER TABLE [dbo].[COLLATERAL] ALTER COLUMN [DESCRIPTION] nVarchar(255) ;
 GO 
ALTER TABLE [dbo].[COLLATERAL] ALTER COLUMN [LAST_OPR] nVarChar(50) ;
 GO 
ALTER TABLE [dbo].[COLLATERAL] ALTER COLUMN [RECEIVEDBYTITLE] nVarChar(100) ;
 GO 
ALTER TABLE [dbo].[COLLATERAL] ALTER COLUMN [RECEIVEDFROMTITLE] nVarChar(100) ;
 GO 
ALTER TABLE [dbo].[COLLATERAL] ALTER COLUMN [RELEASEDBYTITLE] nVarChar(100) ;
 GO 
ALTER TABLE [dbo].[COLLATERAL] ALTER COLUMN [RELEASEDTOTITLE] nVarChar(100) ;
 GO 
ALTER TABLE [dbo].[COLLATERAL] ALTER COLUMN [REMARKS] nVarChar(512) ;
 GO 
ALTER TABLE [dbo].[COLLATERALPIC] ALTER COLUMN [Last_Opr] nVarChar(50) ;
 GO 
ALTER TABLE [dbo].[COLLATERALPIC] ALTER COLUMN [Remark] nVarChar(max) ;
 GO 
ALTER TABLE [dbo].[COLLATERALPIC] ALTER COLUMN [Title] nVarChar(255) ;
 GO 
ALTER TABLE [dbo].[COLLATERALSUBTYPE] ALTER COLUMN [Description] nVarchar(255) ;
 GO 
ALTER TABLE [dbo].[COLLATERALSUBTYPE] ALTER COLUMN [Last_Opr] nVarChar(50) ;
 GO 
ALTER TABLE [dbo].[COLLATERALTYPE] ALTER COLUMN [AttDesc_1] nVarchar(50) ;
 GO 
ALTER TABLE [dbo].[COLLATERALTYPE] ALTER COLUMN [AttDesc_10] nVarchar(50) ;
 GO 
ALTER TABLE [dbo].[COLLATERALTYPE] ALTER COLUMN [AttDesc_2] nVarchar(50) ;
 GO 
ALTER TABLE [dbo].[COLLATERALTYPE] ALTER COLUMN [AttDesc_3] nVarchar(50) ;
 GO 
ALTER TABLE [dbo].[COLLATERALTYPE] ALTER COLUMN [AttDesc_4] nVarchar(50) ;
 GO 
ALTER TABLE [dbo].[COLLATERALTYPE] ALTER COLUMN [AttDesc_5] nVarchar(50) ;
 GO 
ALTER TABLE [dbo].[COLLATERALTYPE] ALTER COLUMN [AttDesc_6] nVarchar(50) ;
 GO 
ALTER TABLE [dbo].[COLLATERALTYPE] ALTER COLUMN [AttDesc_7] nVarchar(50) ;
 GO 
ALTER TABLE [dbo].[COLLATERALTYPE] ALTER COLUMN [AttDesc_8] nVarchar(50) ;
 GO 
ALTER TABLE [dbo].[COLLATERALTYPE] ALTER COLUMN [AttDesc_9] nVarchar(50) ;
 GO 
ALTER TABLE [dbo].[COLLATERALTYPE] ALTER COLUMN [Description] nVarchar(255) ;
 GO 
ALTER TABLE [dbo].[COLLATERALTYPE] ALTER COLUMN [Last_Opr] nVarChar(50) ;
 GO 
ALTER TABLE [dbo].[CollectionB] ALTER COLUMN [BankName] nVarChar(150) NOT NULL;
 GO 
ALTER TABLE [dbo].[COLLECTIOND] ALTER COLUMN [AcceptedBy] nVarChar(255) ;
 GO 
ALTER TABLE [dbo].[COLLECTIOND] ALTER COLUMN [AName] nVarChar(max) ;
 GO 
ALTER TABLE [dbo].[COLLECTIONH] ALTER COLUMN [BankName] nVarChar(255) ;
 GO 
ALTER TABLE [dbo].[COLLECTIONH] ALTER COLUMN [ContactAddress] nVarChar(255) ;
 GO 
ALTER TABLE [dbo].[COLLECTIONH] ALTER COLUMN [Last_Opr] nVarChar(50) ;
 GO 
ALTER TABLE [dbo].[COLLECTIONH] ALTER COLUMN [Memo] nVarchar(Max) ;
 GO 
ALTER TABLE [dbo].[COLLECTIONH] ALTER COLUMN [PICTitle] nVarChar(30) ;
 GO 
ALTER TABLE [dbo].[COLLECTIONH] ALTER COLUMN [Remarks] nVarChar(255) ;
 GO 
ALTER TABLE [dbo].[COLLECTIONV] ALTER COLUMN [Remarks] nVarChar(255) ;
 GO 
ALTER TABLE [dbo].[COLLRESULT] ALTER COLUMN [Last_Opr] nVarChar(50) ;
 GO 
ALTER TABLE [dbo].[COLLTYPE] ALTER COLUMN [Description] nVarchar(255) ;
 GO 
ALTER TABLE [dbo].[CollType_RRule] ALTER COLUMN [Description] nVarchar(255) ;
 GO 
ALTER TABLE [dbo].[CollType_RRule] ALTER COLUMN [Last_Opr] nVarChar(50) ;
 GO 
ALTER TABLE [dbo].[COLNOCClass] ALTER COLUMN [Last_Opr] nVarChar(50) ;
 GO 
ALTER TABLE [dbo].[COLTAB] ALTER COLUMN [DESCRIPTION] nVarchar(255) ;
 GO 
ALTER TABLE [dbo].[COLTAB] ALTER COLUMN [Last_Opr] nVarChar(50) ;
 GO 
ALTER TABLE [dbo].[ComAcc] ALTER COLUMN [BankName] nVarChar(255) ;
 GO 
ALTER TABLE [dbo].[ComAcc] ALTER COLUMN [Description] nVarchar(255) ;
 GO 
ALTER TABLE [dbo].[ComAcc] ALTER COLUMN [LAST_OPR] nVarChar(50) ;
 GO 
ALTER TABLE [dbo].[ComAcc] ALTER COLUMN [PUserID] nVarChar(50) ;
 GO 
ALTER TABLE [dbo].[ComAcc] ALTER COLUMN [Remarks] nVarChar(512) ;
 GO 
ALTER TABLE [dbo].[ComAcc] ALTER COLUMN [USERID] nVarChar(50) ;
 GO 
ALTER TABLE [dbo].[ComAcc_Cheque] ALTER COLUMN [Description] nVarchar(50) ;
 GO 
ALTER TABLE [dbo].[ComAcc_Cheque] ALTER COLUMN [Last_Opr] nVarChar(50) NOT NULL;
 GO 
ALTER TABLE [dbo].[CompanyType] ALTER COLUMN [CompDesc] nVarchar(50) ;
 GO 
ALTER TABLE [dbo].[ComplaintType] ALTER COLUMN [Description] nVarchar(100) ;
 GO 
ALTER TABLE [dbo].[ComplaintType] ALTER COLUMN [Last_Opr] nVarChar(50) ;
 GO 
ALTER TABLE [dbo].[COMPLIANCE] ALTER COLUMN [DESCRIPTION] nVarchar(255) ;
 GO 
ALTER TABLE [dbo].[COMPLIANCE] ALTER COLUMN [LAST_OPR] nVarChar(50) ;
 GO 
ALTER TABLE [dbo].[COMPLIANCEI] ALTER COLUMN [LAST_OPR] nVarChar(50) ;
 GO 
ALTER TABLE [dbo].[COMPLIANCER] ALTER COLUMN [DESCRIPTION] nVarchar(255) ;
 GO 
ALTER TABLE [dbo].[COMPLIANCER] ALTER COLUMN [LAST_OPR] nVarChar(50) ;
 GO 
ALTER TABLE [dbo].[COMPLIANCES] ALTER COLUMN [SDESCRIPTION] nVarchar(255) ;
 GO 
ALTER TABLE [dbo].[COMPLIANCET] ALTER COLUMN [LAST_OPR] nVarChar(50) ;
 GO 
ALTER TABLE [dbo].[COMPLIANCEU] ALTER COLUMN [LAST_OPR] nVarChar(50) ;
 GO 
ALTER TABLE [dbo].[COMPLIANCEUI] ALTER COLUMN [LAST_OPR] nVarChar(50) ;
 GO 
ALTER TABLE [dbo].[Country] ALTER COLUMN [Description] nVarchar(50) ;
 GO 
ALTER TABLE [dbo].[Country] ALTER COLUMN [Last_Opr] nVarChar(50) ;
 GO 
ALTER TABLE [dbo].[CountryGroup] ALTER COLUMN [Description] nVarchar(100) ;
 GO 
ALTER TABLE [dbo].[CountryGroup] ALTER COLUMN [Last_Opr] nVarChar(50) ;
 GO 
ALTER TABLE [dbo].[COVEMPCONTD] ALTER COLUMN [REMARKS] nVarChar(255) ;
 GO 
ALTER TABLE [dbo].[COVEMPCONTH] ALTER COLUMN [AUSERID] nVarChar(50) ;
 GO 
ALTER TABLE [dbo].[COVEMPCONTH] ALTER COLUMN [CUSERID] nVarChar(50) ;
 GO 
ALTER TABLE [dbo].[COVEMPCONTH] ALTER COLUMN [LUSERID] nVarChar(50) ;
 GO 
ALTER TABLE [dbo].[COVEMPCONTH] ALTER COLUMN [PUserID] nVarChar(50) ;
 GO 
ALTER TABLE [dbo].[COVEMPCONTH] ALTER COLUMN [REMARKS] nVarChar(512) ;
 GO 
ALTER TABLE [dbo].[COVEMPCONTH] ALTER COLUMN [USERID] nVarChar(50) ;
 GO 
ALTER TABLE [dbo].[COVER] ALTER COLUMN [AUSERID] nVarChar(50) ;
 GO 
ALTER TABLE [dbo].[COVER] ALTER COLUMN [COMMENT] nVarchar(Max) ;
 GO 
ALTER TABLE [dbo].[COVER] ALTER COLUMN [CUSERID] nVarChar(50) ;
 GO 
ALTER TABLE [dbo].[COVER] ALTER COLUMN [INSURED] nVarChar(max) ;
 GO 
ALTER TABLE [dbo].[COVER] ALTER COLUMN [LUSERID] nVarChar(50) ;
 GO 
ALTER TABLE [dbo].[COVER] ALTER COLUMN [MEMO] nVarchar(Max) ;
 GO 
ALTER TABLE [dbo].[COVER] ALTER COLUMN [PUserID] nVarChar(50) ;
 GO 
ALTER TABLE [dbo].[COVER] ALTER COLUMN [USERID] nVarChar(50) ;
 GO 
DROP INDEX [dbo].[CPrintLog].[I_CPrintLog_CollNo_DocNo_Description];
 GO 
ALTER TABLE [dbo].[CPrintLog] ALTER COLUMN [Description] nVarchar(50) NOT NULL;
 GO 
CREATE NONCLUSTERED INDEX [I_CPrintLog_CollNo_DocNo_Description] ON [dbo].[CPrintLog] (  [CollNo] , [DocNo] , [Description] )
 GO 
ALTER TABLE [dbo].[CPrintLog] ALTER COLUMN [UserID] nVarChar(50) ;
 GO 
ALTER TABLE [dbo].[CSTALLOCATIONH] ALTER COLUMN [Last_Opr] nVarChar(50) ;
 GO 
ALTER TABLE [dbo].[CSType] ALTER COLUMN [Description] nVarchar(255) ;
 GO 
ALTER TABLE [dbo].[CSType] ALTER COLUMN [Last_Opr] nVarChar(50) ;
 GO 
ALTER TABLE [dbo].[CT] ALTER COLUMN [Description] nVarchar(50) ;
 GO 
ALTER TABLE [dbo].[CT] ALTER COLUMN [Last_Opr] nVarChar(50) ;
 GO 
ALTER TABLE [dbo].[Currency] ALTER COLUMN [Description] nVarchar(50) ;
 GO 
ALTER TABLE [dbo].[Currency] ALTER COLUMN [Last_Opr] nVarChar(50) ;
 GO 
ALTER TABLE [dbo].[DConvH] ALTER COLUMN [Description] nVarchar(50) ;
 GO 
ALTER TABLE [dbo].[DEDTAB] ALTER COLUMN [Last_Opr] nVarChar(50) ;
 GO 
ALTER TABLE [dbo].[DEDTAB] ALTER COLUMN [REMARKS] nVarChar(2048) ;
 GO 
ALTER TABLE [dbo].[DEDTAB] ALTER COLUMN [REMARKS_1] nVarChar(2048) ;
 GO 
ALTER TABLE [dbo].[DefCLA] ALTER COLUMN [DESCRIPTION] nVarchar(max) ;
 GO 
ALTER TABLE [dbo].[DefCLA] ALTER COLUMN [Description_1] nVarchar(max) ;
 GO 
ALTER TABLE [dbo].[DefCLA] ALTER COLUMN [SHORTDESC] nVarchar(max) ;
 GO 
ALTER TABLE [dbo].[DefCLA] ALTER COLUMN [ShortDesc_1] nVarchar(max) ;
 GO 
ALTER TABLE [dbo].[DefCON] ALTER COLUMN [DESCRIPTION] nVarchar(max) ;
 GO 
ALTER TABLE [dbo].[DefCON] ALTER COLUMN [Description_1] nVarchar(max) ;
 GO 
ALTER TABLE [dbo].[DefCON] ALTER COLUMN [SHORTDESC] nVarchar(max) ;
 GO 
ALTER TABLE [dbo].[DefCON] ALTER COLUMN [ShortDesc_1] nVarchar(max) ;
 GO 
ALTER TABLE [dbo].[DefEX] ALTER COLUMN [DESCRIPTION] nVarchar(max) ;
 GO 
ALTER TABLE [dbo].[DefEX] ALTER COLUMN [Description_1] nVarchar(max) ;
 GO 
ALTER TABLE [dbo].[DefEX] ALTER COLUMN [SHORTDESC] nVarchar(max) ;
 GO 
ALTER TABLE [dbo].[DefEX] ALTER COLUMN [ShortDesc_1] nVarchar(max) ;
 GO 
ALTER TABLE [dbo].[DISTAB] ALTER COLUMN [DESCRIPTION] nVarchar(255) ;
 GO 
ALTER TABLE [dbo].[DISTAB] ALTER COLUMN [Last_Opr] nVarChar(50) ;
 GO 
ALTER TABLE [dbo].[District] ALTER COLUMN [Description] nVarChar(200) ;
 GO 
ALTER TABLE [dbo].[District] ALTER COLUMN [Description_1] nVarChar(200) ;
 GO 
ALTER TABLE [dbo].[District] ALTER COLUMN [Last_OPR] nVarChar(50) ;
 GO 
ALTER TABLE [dbo].[DOCLIST] ALTER COLUMN [DESCRIPTION] nVarchar(255) ;
 GO 
ALTER TABLE [dbo].[DocStat] ALTER COLUMN [Description] nVarchar(100) ;
 GO 
ALTER TABLE [dbo].[DocStat] ALTER COLUMN [Last_Opr] nVarChar(50) ;
 GO 
ALTER TABLE [dbo].[DOCTYPE] ALTER COLUMN [DESCRIPTION] nVarchar(255) ;
 GO 
ALTER TABLE [dbo].[DOCTYPE] ALTER COLUMN [Last_Opr] nVarChar(50) ;
 GO 
ALTER TABLE [dbo].[DType] ALTER COLUMN [Description] nVarchar(255) ;
 GO 
ALTER TABLE [dbo].[DType] ALTER COLUMN [Last_Opr] nVarChar(50) ;
 GO 
ALTER TABLE [dbo].[ECUTYPE] ALTER COLUMN [Description] nVarchar(512) ;
 GO 
ALTER TABLE [dbo].[EIS_HEADER] ALTER COLUMN [Description] nVarchar(255) ;
 GO 
ALTER TABLE [dbo].[EIS_HEADER] ALTER COLUMN [Last_OPR] nVarChar(50) ;
 GO 
ALTER TABLE [dbo].[EncryptField] ALTER COLUMN [LUserID] nVarChar(50) ;
 GO 
ALTER TABLE [dbo].[EUnit] ALTER COLUMN [DESCRIPTION] nVarchar(100) ;
 GO 
ALTER TABLE [dbo].[EUnit] ALTER COLUMN [DESCRIPTION_1] nVarchar(100) ;
 GO 
ALTER TABLE [dbo].[EUnit] ALTER COLUMN [REMARK] nVarChar(100) ;
 GO 
ALTER TABLE [dbo].[EUnit] ALTER COLUMN [REMARK_1] nVarChar(100) ;
 GO 
ALTER TABLE [dbo].[Event] ALTER COLUMN [Description] nVarchar(255) ;
 GO 
DROP INDEX [dbo].[Event].[I_Event_EventName];
 GO 
ALTER TABLE [dbo].[Event] ALTER COLUMN [EventName] nVarChar(50) ;
 GO 
CREATE NONCLUSTERED INDEX [I_Event_EventName] ON [dbo].[Event] (  [EventName] )
 GO 
ALTER TABLE [dbo].[Event] ALTER COLUMN [Last_Opr] nVarChar(50) ;
 GO 
ALTER TABLE [dbo].[Event] ALTER COLUMN [Location] nVarChar(10) ;
 GO 
ALTER TABLE [dbo].[Event] ALTER COLUMN [Remark] nVarChar(255) ;
 GO 
ALTER TABLE [dbo].[Excel] ALTER COLUMN [Description] nVarchar(50) ;
 GO 
ALTER TABLE [dbo].[Excel] ALTER COLUMN [Last_Opr] nVarChar(50) ;
 GO 
ALTER TABLE [dbo].[Exchange] ALTER COLUMN [Last_Opr] nVarChar(50) ;
 GO 
ALTER TABLE [dbo].[FACCLA] ALTER COLUMN [DESCRIPTION] nVarchar(max) ;
 GO 
ALTER TABLE [dbo].[FACCLA] ALTER COLUMN [Description_1] nVarchar(max) ;
 GO 
ALTER TABLE [dbo].[FACCLA] ALTER COLUMN [SHORTDESC] nVarchar(max) ;
 GO 
ALTER TABLE [dbo].[FACCLA] ALTER COLUMN [ShortDesc_1] nVarchar(max) ;
 GO 
ALTER TABLE [dbo].[FACCON] ALTER COLUMN [DESCRIPTION] nVarchar(max) ;
 GO 
ALTER TABLE [dbo].[FACCON] ALTER COLUMN [Description_1] nVarchar(max) ;
 GO 
ALTER TABLE [dbo].[FACCON] ALTER COLUMN [SHORTDESC] nVarchar(max) ;
 GO 
ALTER TABLE [dbo].[FACCON] ALTER COLUMN [ShortDesc_1] nVarchar(max) ;
 GO 
ALTER TABLE [dbo].[FACEX] ALTER COLUMN [DESCRIPTION] nVarchar(max) ;
 GO 
ALTER TABLE [dbo].[FACEX] ALTER COLUMN [Description_1] nVarchar(max) ;
 GO 
ALTER TABLE [dbo].[FACEX] ALTER COLUMN [SHORTDESC] nVarchar(max) ;
 GO 
ALTER TABLE [dbo].[FACEX] ALTER COLUMN [ShortDesc_1] nVarchar(max) ;
 GO 
ALTER TABLE [dbo].[FANOTES] ALTER COLUMN [Notes] nVarChar(max) ;
 GO 
ALTER TABLE [dbo].[FANOTES] ALTER COLUMN [UserID] nVarChar(50) ;
 GO 
ALTER TABLE [dbo].[FDEDUCTIBLE] ALTER COLUMN [REMARKS] nVarChar(2048) ;
 GO 
ALTER TABLE [dbo].[FDEDUCTIBLE] ALTER COLUMN [REMARKS_1] nVarChar(2048) ;
 GO 
ALTER TABLE [dbo].[FDTAB] ALTER COLUMN [DESCRIPTION] nVarchar(50) ;
 GO 
ALTER TABLE [dbo].[FDTAB] ALTER COLUMN [Last_Opr] nVarChar(50) ;
 GO 
ALTER TABLE [dbo].[FDTABDET] ALTER COLUMN [Last_Opr] nVarChar(50) ;
 GO 
ALTER TABLE [dbo].[FINFO] ALTER COLUMN [VALUEDESC1] nVarchar(Max) ;
 GO 
ALTER TABLE [dbo].[FINFO] ALTER COLUMN [VALUEDESC10] nVarchar(Max) ;
 GO 
ALTER TABLE [dbo].[FINFO] ALTER COLUMN [VALUEDESC11] nVarchar(Max) ;
 GO 
ALTER TABLE [dbo].[FINFO] ALTER COLUMN [VALUEDESC12] nVarchar(Max) ;
 GO 
ALTER TABLE [dbo].[FINFO] ALTER COLUMN [VALUEDESC13] nVarchar(Max) ;
 GO 
ALTER TABLE [dbo].[FINFO] ALTER COLUMN [VALUEDESC14] nVarchar(Max) ;
 GO 
ALTER TABLE [dbo].[FINFO] ALTER COLUMN [VALUEDESC15] nVarchar(Max) ;
 GO 
ALTER TABLE [dbo].[FINFO] ALTER COLUMN [VALUEDESC2] nVarchar(Max) ;
 GO 
ALTER TABLE [dbo].[FINFO] ALTER COLUMN [VALUEDESC3] nVarchar(Max) ;
 GO 
ALTER TABLE [dbo].[FINFO] ALTER COLUMN [VALUEDESC4] nVarchar(Max) ;
 GO 
ALTER TABLE [dbo].[FINFO] ALTER COLUMN [VALUEDESC5] nVarchar(Max) ;
 GO 
ALTER TABLE [dbo].[FINFO] ALTER COLUMN [VALUEDESC6] nVarchar(Max) ;
 GO 
ALTER TABLE [dbo].[FINFO] ALTER COLUMN [VALUEDESC7] nVarchar(Max) ;
 GO 
ALTER TABLE [dbo].[FINFO] ALTER COLUMN [VALUEDESC8] nVarchar(Max) ;
 GO 
ALTER TABLE [dbo].[FINFO] ALTER COLUMN [VALUEDESC9] nVarchar(Max) ;
 GO 
ALTER TABLE [dbo].[FLScaleTab] ALTER COLUMN [Last_Opr] nVarChar(50) ;
 GO 
ALTER TABLE [dbo].[FPART] ALTER COLUMN [REMARKS] nVarchar(Max) ;
 GO 
ALTER TABLE [dbo].[FSecurity] ALTER COLUMN [REMARKS] nVarChar(255) ;
 GO 
ALTER TABLE [dbo].[GENCLA] ALTER COLUMN [DESCRIPTION] nVarchar(max) ;
 GO 
ALTER TABLE [dbo].[GENCLA] ALTER COLUMN [Description_1] nVarchar(max) ;
 GO 
ALTER TABLE [dbo].[GENCLA] ALTER COLUMN [SHORTDESC] nVarchar(max) ;
 GO 
ALTER TABLE [dbo].[GENCLA] ALTER COLUMN [ShortDesc_1] nVarchar(max) ;
 GO 
ALTER TABLE [dbo].[GENCON] ALTER COLUMN [DESCRIPTION] nVarchar(max) ;
 GO 
ALTER TABLE [dbo].[GENCON] ALTER COLUMN [Description_1] nVarchar(max) ;
 GO 
ALTER TABLE [dbo].[GENCON] ALTER COLUMN [SHORTDESC] nVarchar(max) ;
 GO 
ALTER TABLE [dbo].[GENCON] ALTER COLUMN [ShortDesc_1] nVarchar(max) ;
 GO 
DROP INDEX [dbo].[GENDTAB].[I_GENDTAB_FLDID_Description];
 GO 
ALTER TABLE [dbo].[GENDTAB] ALTER COLUMN [DESCRIPTION] nVarchar(4000) ;
 GO 
CREATE NONCLUSTERED INDEX [I_GENDTAB_FLDID_Description] ON [dbo].[GENDTAB] (  [FLDID] , [DESCRIPTION] )
 GO 
ALTER TABLE [dbo].[GENDTAB] ALTER COLUMN [Last_Opr] nVarChar(50) ;
 GO 
ALTER TABLE [dbo].[GENDTAB] ALTER COLUMN [NEWVALUEDESC] nVarchar(Max) ;
 GO 
ALTER TABLE [dbo].[GENDTAB] ALTER COLUMN [VALUEDESC1] nVarchar(Max) ;
 GO 
ALTER TABLE [dbo].[GENDTAB] ALTER COLUMN [VALUEDESC10] nVarchar(Max) ;
 GO 
ALTER TABLE [dbo].[GENDTAB] ALTER COLUMN [VALUEDESC11] nVarchar(Max) ;
 GO 
ALTER TABLE [dbo].[GENDTAB] ALTER COLUMN [VALUEDESC12] nVarchar(Max) ;
 GO 
ALTER TABLE [dbo].[GENDTAB] ALTER COLUMN [VALUEDESC13] nVarchar(Max) ;
 GO 
ALTER TABLE [dbo].[GENDTAB] ALTER COLUMN [VALUEDESC14] nVarchar(Max) ;
 GO 
ALTER TABLE [dbo].[GENDTAB] ALTER COLUMN [VALUEDESC15] nVarchar(Max) ;
 GO 
ALTER TABLE [dbo].[GENDTAB] ALTER COLUMN [VALUEDESC2] nVarchar(Max) ;
 GO 
ALTER TABLE [dbo].[GENDTAB] ALTER COLUMN [VALUEDESC3] nVarchar(Max) ;
 GO 
ALTER TABLE [dbo].[GENDTAB] ALTER COLUMN [VALUEDESC4] nVarchar(Max) ;
 GO 
ALTER TABLE [dbo].[GENDTAB] ALTER COLUMN [VALUEDESC5] nVarchar(Max) ;
 GO 
ALTER TABLE [dbo].[GENDTAB] ALTER COLUMN [VALUEDESC6] nVarchar(Max) ;
 GO 
ALTER TABLE [dbo].[GENDTAB] ALTER COLUMN [VALUEDESC7] nVarchar(Max) ;
 GO 
ALTER TABLE [dbo].[GENDTAB] ALTER COLUMN [VALUEDESC8] nVarchar(Max) ;
 GO 
ALTER TABLE [dbo].[GENDTAB] ALTER COLUMN [VALUEDESC9] nVarchar(Max) ;
 GO 
ALTER TABLE [dbo].[GENEX] ALTER COLUMN [DESCRIPTION] nVarchar(max) ;
 GO 
ALTER TABLE [dbo].[GENEX] ALTER COLUMN [Description_1] nVarchar(max) ;
 GO 
ALTER TABLE [dbo].[GENEX] ALTER COLUMN [SHORTDESC] nVarchar(max) ;
 GO 
ALTER TABLE [dbo].[GENEX] ALTER COLUMN [ShortDesc_1] nVarchar(max) ;
 GO 
ALTER TABLE [dbo].[GENHTAB] ALTER COLUMN [Last_Opr] nVarChar(50) ;
 GO 
ALTER TABLE [dbo].[GL_Audit] ALTER COLUMN [Remarks] nVarChar(512) ;
 GO 
ALTER TABLE [dbo].[GL_AuditH] ALTER COLUMN [Description] nVarchar(50) ;
 GO 
ALTER TABLE [dbo].[GL_AuditH] ALTER COLUMN [Last_Opr] nVarChar(50) ;
 GO 
ALTER TABLE [dbo].[GL_Fiscal] ALTER COLUMN [Remarks] nVarChar(512) NOT NULL;
 GO 
ALTER TABLE [dbo].[GL_FiscalH] ALTER COLUMN [Description] nVarchar(50) ;
 GO 
ALTER TABLE [dbo].[GL_FiscalH] ALTER COLUMN [Last_Opr] nVarChar(50) ;
 GO 
ALTER TABLE [dbo].[HEmail_Rule] ALTER COLUMN [Last_Opr] nVarChar(50) ;
 GO 
ALTER TABLE [dbo].[Hint] ALTER COLUMN [Last_Opr] nVarChar(50) ;
 GO 
ALTER TABLE [dbo].[Hint] ALTER COLUMN [Remarks] nVarChar(50) ;
 GO 
ALTER TABLE [dbo].[Hint] ALTER COLUMN [Remarks_1] nVarChar(50) ;
 GO 
ALTER TABLE [dbo].[Hint] ALTER COLUMN [ShortDesc] nVarchar(20) ;
 GO 
ALTER TABLE [dbo].[Hint] ALTER COLUMN [ShortDesc_1] nVarchar(20) ;
 GO 
ALTER TABLE [dbo].[HSCode] ALTER COLUMN [Description] nVarchar(255) ;
 GO 
ALTER TABLE [dbo].[HSCode] ALTER COLUMN [Last_Opr] nVarChar(50) ;
 GO 
ALTER TABLE [dbo].[HSMS_Rule] ALTER COLUMN [Description] nVarchar(50) ;
 GO 
ALTER TABLE [dbo].[HSMS_Rule] ALTER COLUMN [Last_Opr] nVarChar(10) ;
 GO 
ALTER TABLE [dbo].[ICOVER] ALTER COLUMN [LUserID] nVarChar(50) ;
 GO 
ALTER TABLE [dbo].[ICOVER] ALTER COLUMN [REMARK] nVarChar(max) ;
 GO 
ALTER TABLE [dbo].[ICOVERDET] ALTER COLUMN [DESCRIPTION] nVarchar(255) ;
 GO 
ALTER TABLE [dbo].[ICOVERDET] ALTER COLUMN [MEMO] nVarchar(Max) ;
 GO 
ALTER TABLE [dbo].[ICOVERNOC] ALTER COLUMN [DESCRIPTION] nVarchar(max) ;
 GO 
ALTER TABLE [dbo].[ICOVERPOL] ALTER COLUMN [LUserID] nVarChar(5) ;
 GO 
ALTER TABLE [dbo].[IFRS_Assumption] ALTER COLUMN [Description] nVarchar(255) ;
 GO 
ALTER TABLE [dbo].[IFRS_Assumption] ALTER COLUMN [Last_Opr] nVarChar(50) ;
 GO 
ALTER TABLE [dbo].[IFRS_Assumption_Detail] ALTER COLUMN [Last_Opr] nVarChar(50) ;
 GO 
ALTER TABLE [dbo].[IFRS_CancelRate] ALTER COLUMN [Description] nVarchar(255) ;
 GO 
ALTER TABLE [dbo].[IFRS_CancelRate] ALTER COLUMN [Last_Opr] nVarChar(50) ;
 GO 
ALTER TABLE [dbo].[IFRS_CancelRate_Detail] ALTER COLUMN [Last_Opr] nVarChar(50) ;
 GO 
ALTER TABLE [dbo].[IFRS_DiscRate] ALTER COLUMN [Description] nVarchar(255) ;
 GO 
ALTER TABLE [dbo].[IFRS_DiscRate] ALTER COLUMN [Last_Opr] nVarChar(50) ;
 GO 
ALTER TABLE [dbo].[IFRS_DiscRate_Detail] ALTER COLUMN [Last_Opr] nVarChar(50) ;
 GO 
ALTER TABLE [dbo].[IFRS_ERatio] ALTER COLUMN [Description] nVarchar(255) ;
 GO 
ALTER TABLE [dbo].[IFRS_ERatio] ALTER COLUMN [Last_Opr] nVarChar(50) ;
 GO 
ALTER TABLE [dbo].[IFRS_ERatio_Detail] ALTER COLUMN [Last_Opr] nVarChar(50) ;
 GO 
ALTER TABLE [dbo].[IFRS_InfRate] ALTER COLUMN [Description] nVarchar(255) ;
 GO 
ALTER TABLE [dbo].[IFRS_InfRate] ALTER COLUMN [Last_Opr] nVarChar(50) ;
 GO 
ALTER TABLE [dbo].[IFRS_InfRate_Detail] ALTER COLUMN [Last_Opr] nVarChar(50) ;
 GO 
ALTER TABLE [dbo].[IFRS_Movement] ALTER COLUMN [Description] nVarchar(255) ;
 GO 
ALTER TABLE [dbo].[IINFO] ALTER COLUMN [VALUEDESC1] nVarchar(Max) ;
 GO 
ALTER TABLE [dbo].[IINFO] ALTER COLUMN [VALUEDESC10] nVarchar(Max) ;
 GO 
ALTER TABLE [dbo].[IINFO] ALTER COLUMN [VALUEDESC11] nVarchar(Max) ;
 GO 
ALTER TABLE [dbo].[IINFO] ALTER COLUMN [VALUEDESC12] nVarchar(Max) ;
 GO 
ALTER TABLE [dbo].[IINFO] ALTER COLUMN [VALUEDESC13] nVarchar(Max) ;
 GO 
ALTER TABLE [dbo].[IINFO] ALTER COLUMN [VALUEDESC14] nVarchar(Max) ;
 GO 
ALTER TABLE [dbo].[IINFO] ALTER COLUMN [VALUEDESC15] nVarchar(Max) ;
 GO 
ALTER TABLE [dbo].[IINFO] ALTER COLUMN [VALUEDESC2] nVarchar(Max) ;
 GO 
ALTER TABLE [dbo].[IINFO] ALTER COLUMN [VALUEDESC3] nVarchar(Max) ;
 GO 
ALTER TABLE [dbo].[IINFO] ALTER COLUMN [VALUEDESC4] nVarchar(Max) ;
 GO 
ALTER TABLE [dbo].[IINFO] ALTER COLUMN [VALUEDESC5] nVarchar(Max) ;
 GO 
ALTER TABLE [dbo].[IINFO] ALTER COLUMN [VALUEDESC6] nVarchar(Max) ;
 GO 
ALTER TABLE [dbo].[IINFO] ALTER COLUMN [VALUEDESC7] nVarchar(Max) ;
 GO 
ALTER TABLE [dbo].[IINFO] ALTER COLUMN [VALUEDESC8] nVarchar(Max) ;
 GO 
ALTER TABLE [dbo].[IINFO] ALTER COLUMN [VALUEDESC9] nVarchar(Max) ;
 GO 
ALTER TABLE [dbo].[INPARTY] ALTER COLUMN [Address_1] nVarChar(255) ;
 GO 
ALTER TABLE [dbo].[INPARTY] ALTER COLUMN [Address_2] nVarChar(255) ;
 GO 
ALTER TABLE [dbo].[INPARTY] ALTER COLUMN [REMARK] nVarChar(255) ;
 GO 
ALTER TABLE [dbo].[InsertFields] ALTER COLUMN [InsertDesc] nVarchar(512) ;
 GO 
ALTER TABLE [dbo].[ISTYPE] ALTER COLUMN [DESCRIPTION] nVarchar(50) ;
 GO 
ALTER TABLE [dbo].[IUNIT] ALTER COLUMN [DESCRIPTION] nVarchar(100) ;
 GO 
ALTER TABLE [dbo].[IUNIT] ALTER COLUMN [DESCRIPTION_1] nVarchar(100) ;
 GO 
ALTER TABLE [dbo].[IUNIT] ALTER COLUMN [REMARK] nVarChar(100) ;
 GO 
ALTER TABLE [dbo].[IUNIT] ALTER COLUMN [REMARK_1] nVarChar(100) ;
 GO 
DROP INDEX [dbo].[KOL].[I_KOL_Description];
 GO 
ALTER TABLE [dbo].[KOL] ALTER COLUMN [Description] nVarchar(100) ;
 GO 
CREATE NONCLUSTERED INDEX [I_KOL_Description] ON [dbo].[KOL] (  [Description] )
 GO 
ALTER TABLE [dbo].[KOLTab] ALTER COLUMN [Description] nVarchar(100) ;
 GO 
ALTER TABLE [dbo].[KOLTab] ALTER COLUMN [Last_Opr] nVarChar(50) ;
 GO 
ALTER TABLE [dbo].[KOLValue] ALTER COLUMN [Last_Opr] nVarChar(50) ;
 GO 
ALTER TABLE [dbo].[KOLValue] ALTER COLUMN [VALUEDESC1] nVarchar(Max) ;
 GO 
ALTER TABLE [dbo].[KOLValue] ALTER COLUMN [VALUEDESC10] nVarchar(Max) ;
 GO 
ALTER TABLE [dbo].[KOLValue] ALTER COLUMN [VALUEDESC11] nVarchar(Max) ;
 GO 
ALTER TABLE [dbo].[KOLValue] ALTER COLUMN [VALUEDESC12] nVarchar(Max) ;
 GO 
ALTER TABLE [dbo].[KOLValue] ALTER COLUMN [VALUEDESC13] nVarchar(Max) ;
 GO 
ALTER TABLE [dbo].[KOLValue] ALTER COLUMN [VALUEDESC14] nVarchar(Max) ;
 GO 
ALTER TABLE [dbo].[KOLValue] ALTER COLUMN [VALUEDESC15] nVarchar(Max) ;
 GO 
ALTER TABLE [dbo].[KOLValue] ALTER COLUMN [VALUEDESC2] nVarchar(Max) ;
 GO 
ALTER TABLE [dbo].[KOLValue] ALTER COLUMN [VALUEDESC3] nVarchar(Max) ;
 GO 
ALTER TABLE [dbo].[KOLValue] ALTER COLUMN [VALUEDESC4] nVarchar(Max) ;
 GO 
ALTER TABLE [dbo].[KOLValue] ALTER COLUMN [VALUEDESC5] nVarchar(Max) ;
 GO 
ALTER TABLE [dbo].[KOLValue] ALTER COLUMN [VALUEDESC6] nVarchar(Max) ;
 GO 
ALTER TABLE [dbo].[KOLValue] ALTER COLUMN [VALUEDESC7] nVarchar(Max) ;
 GO 
ALTER TABLE [dbo].[KOLValue] ALTER COLUMN [VALUEDESC8] nVarchar(Max) ;
 GO 
ALTER TABLE [dbo].[KOLValue] ALTER COLUMN [VALUEDESC9] nVarchar(Max) ;
 GO 
ALTER TABLE [dbo].[LinkExcel] DROP [DF__LinkExcel__Descr__127623D2];
 GO 
ALTER TABLE [dbo].[LinkExcel] ALTER COLUMN [Description] nVarchar(100) ;
 GO 
ALTER TABLE [dbo].[LinkExcel] ADD CONSTRAINT [DF__LinkExcel__Descr__127623D2] DEFAULT ('(none)') FOR [Description];
 GO 
ALTER TABLE [dbo].[LinkExcel] ALTER COLUMN [SQLDesc] nVarchar(255) ;
 GO 
ALTER TABLE [dbo].[LOB] ALTER COLUMN [Description] nVarchar(50) ;
 GO 
ALTER TABLE [dbo].[LOB] ALTER COLUMN [Last_Opr] nVarChar(50) ;
 GO 
ALTER TABLE [dbo].[Location] ALTER COLUMN [Address_1] nVarChar(50) ;
 GO 
ALTER TABLE [dbo].[Location] ALTER COLUMN [Address_2] nVarChar(50) ;
 GO 
ALTER TABLE [dbo].[Location] ALTER COLUMN [Address_3] nVarChar(50) ;
 GO 
ALTER TABLE [dbo].[Location] ALTER COLUMN [Last_Opr] nVarChar(50) ;
 GO 
ALTER TABLE [dbo].[Location] DROP CONSTRAINT [i_Location];
 GO 
ALTER TABLE [dbo].[Location] ALTER COLUMN [Location] nVarChar(10) NOT NULL;
 GO 
ALTER TABLE [dbo].[Location] WITH NOCHECK ADD CONSTRAINT [i_Location] PRIMARY KEY NONCLUSTERED( [Location] ) WITH (ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = OFF) ON [PRIMARY]
 GO 
ALTER TABLE [dbo].[Location] ALTER COLUMN [Remarks] nVarChar(255) ;
 GO 
ALTER TABLE [dbo].[MAP_FIELD] ALTER COLUMN [LAST_OPR] nVarChar(50) ;
 GO 
ALTER TABLE [dbo].[MAP_HEADER] ALTER COLUMN [Description] nVarchar(100) ;
 GO 
ALTER TABLE [dbo].[MAP_HEADER] ALTER COLUMN [Last_Opr] nVarChar(50) ;
 GO 
ALTER TABLE [dbo].[MAP_REFERENCE] ALTER COLUMN [LAST_OPR] nVarChar(50) ;
 GO 
ALTER TABLE [dbo].[MAP_REFERENCE] DROP CONSTRAINT [I_MAP_REFERENCE_MapCode_MapType_SDate_EDate_RefNo_ShortDesc];
 GO 
ALTER TABLE [dbo].[MAP_REFERENCE] ALTER COLUMN [ShortDesc] nVarchar(50) ;
 GO 
ALTER TABLE [dbo].[MAP_REFERENCE] ADD CONSTRAINT [I_MAP_REFERENCE_MapCode_MapType_SDate_EDate_RefNo_ShortDesc] UNIQUE( [MapCode] , [MapType] , [SDate] , [EDate] , [RefNo] , [ShortDesc] ) WITH (ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = OFF) ON [PRIMARY]
 GO 
ALTER TABLE [dbo].[MAP_VALUE] ALTER COLUMN [Last_Opr] nVarChar(50) ;
 GO 
ALTER TABLE [dbo].[MaritalStatus] ALTER COLUMN [Description] nVarchar(255) ;
 GO 
ALTER TABLE [dbo].[Matters] ALTER COLUMN [Description] nVarchar(100) ;
 GO 
ALTER TABLE [dbo].[Matters] ALTER COLUMN [Last_Opr] nVarChar(50) ;
 GO 
ALTER TABLE [dbo].[MenuSetD] ALTER COLUMN [LAST_OPR] nVarChar(50) ;
 GO 
ALTER TABLE [dbo].[MenuSetH] ALTER COLUMN [Description] nVarchar(100) ;
 GO 
ALTER TABLE [dbo].[MenuSetH] ALTER COLUMN [Last_Opr] nVarChar(50) ;
 GO 
ALTER TABLE [dbo].[mJournal] ALTER COLUMN [Description] nVarchar(100) ;
 GO 
ALTER TABLE [dbo].[mJournal] ALTER COLUMN [Last_Opr] nVarChar(50) ;
 GO 
ALTER TABLE [dbo].[MParam] ALTER COLUMN [Last_Opr] nVarChar(50) ;
 GO 
ALTER TABLE [dbo].[MParam] ALTER COLUMN [Remarks] nVarChar(50) ;
 GO 
ALTER TABLE [dbo].[MSCode] ALTER COLUMN [Description] nVarchar(100) ;
 GO 
ALTER TABLE [dbo].[MSCode] ALTER COLUMN [Last_Opr] nVarChar(50) ;
 GO 
ALTER TABLE [dbo].[MSCode_Assignment] ALTER COLUMN [Last_Opr] nVarChar(50) ;
 GO 
ALTER TABLE [dbo].[mSL] ALTER COLUMN [Remarks] nVarChar(4000) ;
 GO 
ALTER TABLE [dbo].[mVoucher] ALTER COLUMN [AUserID] nVarChar(50) ;
 GO 
ALTER TABLE [dbo].[mVoucher] ALTER COLUMN [BankName] nVarChar(255) ;
 GO 
ALTER TABLE [dbo].[mVoucher] ALTER COLUMN [Last_Opr] nVarChar(50) ;
 GO 
ALTER TABLE [dbo].[mVoucher] ALTER COLUMN [Remarks] nVarChar(max) ;
 GO 
ALTER TABLE [dbo].[mVoucher] ALTER COLUMN [RequestMessage] nVarChar(512) ;
 GO 
ALTER TABLE [dbo].[mVoucher] ALTER COLUMN [RequestName] nVarChar(50) ;
 GO 
ALTER TABLE [dbo].[mVoucher] ALTER COLUMN [USERID] nVarChar(50) ;
 GO 
ALTER TABLE [dbo].[mVoucher] ALTER COLUMN [VUserID] nVarChar(50) ;
 GO 
ALTER TABLE [dbo].[nJournal] ALTER COLUMN [Description] nVarchar(100) ;
 GO 
ALTER TABLE [dbo].[nJournal] ALTER COLUMN [Last_Opr] nVarChar(50) ;
 GO 
ALTER TABLE [dbo].[NOC] ALTER COLUMN [DESCRIPTION] nVarchar(255) ;
 GO 
ALTER TABLE [dbo].[NOCTab] ALTER COLUMN [DESCRIPTION] nVarchar(255) ;
 GO 
ALTER TABLE [dbo].[NOCTab] ALTER COLUMN [Last_Opr] nVarChar(50) ;
 GO 
ALTER TABLE [dbo].[Notes] ALTER COLUMN [Description] nVarchar(50) ;
 GO 
ALTER TABLE [dbo].[Notes] DROP CONSTRAINT [I_Notes];
 GO 
ALTER TABLE [dbo].[Notes] ALTER COLUMN [Notes] nVarChar(20) Not NULL;
 GO 
ALTER TABLE [dbo].[Notes] WITH NOCHECK ADD CONSTRAINT [I_Notes] PRIMARY KEY NONCLUSTERED( [Notes] ) WITH (ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = OFF) ON [PRIMARY]
 GO 
ALTER TABLE [dbo].[nSL] ALTER COLUMN [Remarks] nVarChar(4000) ;
 GO 
ALTER TABLE [dbo].[nVoucher] ALTER COLUMN [AcceptedBy] nVarChar(255) ;
 GO 
ALTER TABLE [dbo].[nVoucher] ALTER COLUMN [AcceptedRefNo] nVarChar(100) ;
 GO 
ALTER TABLE [dbo].[nVoucher] ALTER COLUMN [AcceptedRemarks] nVarChar(512) ;
 GO 
ALTER TABLE [dbo].[nVoucher] ALTER COLUMN [BankName] nVarChar(255) ;
 GO 
ALTER TABLE [dbo].[nVoucher] ALTER COLUMN [Last_Opr] nVarChar(50) ;
 GO 
ALTER TABLE [dbo].[nVoucher] ALTER COLUMN [Remarks] nVarChar(max) ;
 GO 
ALTER TABLE [dbo].[nVoucher] ALTER COLUMN [RequestMessage] nVarChar(512) ;
 GO 
ALTER TABLE [dbo].[nVoucher] ALTER COLUMN [RequestName] nVarChar(50) ;
 GO 
ALTER TABLE [dbo].[nVoucher] ALTER COLUMN [USERID] nVarChar(50) ;
 GO 
ALTER TABLE [dbo].[ObjectRegister] ALTER COLUMN [Last_Opr] nVarChar(50) ;
 GO 
ALTER TABLE [dbo].[ObjectRegister] ALTER COLUMN [VALUEDESC1] nVarchar(Max) ;
 GO 
ALTER TABLE [dbo].[ObjectRegister] ALTER COLUMN [VALUEDESC10] nVarchar(Max) ;
 GO 
ALTER TABLE [dbo].[ObjectRegister] ALTER COLUMN [VALUEDESC11] nVarchar(Max) ;
 GO 
ALTER TABLE [dbo].[ObjectRegister] ALTER COLUMN [VALUEDESC12] nVarchar(Max) ;
 GO 
ALTER TABLE [dbo].[ObjectRegister] ALTER COLUMN [VALUEDESC13] nVarchar(Max) ;
 GO 
ALTER TABLE [dbo].[ObjectRegister] ALTER COLUMN [VALUEDESC14] nVarchar(Max) ;
 GO 
ALTER TABLE [dbo].[ObjectRegister] ALTER COLUMN [VALUEDESC15] nVarchar(Max) ;
 GO 
ALTER TABLE [dbo].[ObjectRegister] ALTER COLUMN [VALUEDESC2] nVarchar(Max) ;
 GO 
ALTER TABLE [dbo].[ObjectRegister] ALTER COLUMN [VALUEDESC3] nVarchar(Max) ;
 GO 
ALTER TABLE [dbo].[ObjectRegister] ALTER COLUMN [VALUEDESC4] nVarchar(Max) ;
 GO 
ALTER TABLE [dbo].[ObjectRegister] ALTER COLUMN [VALUEDESC5] nVarchar(Max) ;
 GO 
ALTER TABLE [dbo].[ObjectRegister] ALTER COLUMN [VALUEDESC6] nVarchar(Max) ;
 GO 
ALTER TABLE [dbo].[ObjectRegister] ALTER COLUMN [VALUEDESC7] nVarchar(Max) ;
 GO 
ALTER TABLE [dbo].[ObjectRegister] ALTER COLUMN [VALUEDESC8] nVarchar(Max) ;
 GO 
ALTER TABLE [dbo].[ObjectRegister] ALTER COLUMN [VALUEDESC9] nVarchar(Max) ;
 GO 
ALTER TABLE [dbo].[Occupation] ALTER COLUMN [Description] nVarchar(50) ;
 GO 
ALTER TABLE [dbo].[Occupation] ALTER COLUMN [Last_Opr] nVarChar(50) ;
 GO 
ALTER TABLE [dbo].[OGIS_ERROR] ALTER COLUMN [Last_opr] nVarChar(50) ;
 GO 
ALTER TABLE [dbo].[OGIS_ERROR] ALTER COLUMN [OGIS_ERROR_DESCRIPTION] nVarchar(500) ;
 GO 
ALTER TABLE [dbo].[OGIS_LOG_HEADER] ALTER COLUMN [USERID] nVarChar(50) ;
 GO 
ALTER TABLE [dbo].[OGIS_MAP_DETAIL] ALTER COLUMN [Last_opr] nVarChar(50) ;
 GO 
ALTER TABLE [dbo].[OGIS_MAP_HEADER] ALTER COLUMN [Last_opr] nVarChar(50) ;
 GO 
ALTER TABLE [dbo].[OGIS_MAP_HEADER] ALTER COLUMN [OGIS_FIELD_DESCRIPTION] nVarchar(500) ;
 GO 
ALTER TABLE [dbo].[OneCardD] ALTER COLUMN [Address] nVarChar(255) ;
 GO 
ALTER TABLE [dbo].[OneCardD] ALTER COLUMN [Email] nVarChar(512) ;
 GO 
ALTER TABLE [dbo].[OneCardD] ALTER COLUMN [LAST_OPR] nVarChar(50) ;
 GO 
ALTER TABLE [dbo].[OneCardD] ALTER COLUMN [Notes] nVarChar(255) ;
 GO 
ALTER TABLE [dbo].[OneCardH] ALTER COLUMN [AUSERID] nVarChar(50) ;
 GO 
ALTER TABLE [dbo].[OneCardH] ALTER COLUMN [CardEmail] nVarChar(255) ;
 GO 
ALTER TABLE [dbo].[OneCardH] ALTER COLUMN [CardRemarks] nVarChar(512) ;
 GO 
ALTER TABLE [dbo].[OneCardH] ALTER COLUMN [CUSERID] nVarChar(50) ;
 GO 
ALTER TABLE [dbo].[OneCardH] ALTER COLUMN [LAST_OPR] nVarChar(50) ;
 GO 
ALTER TABLE [dbo].[OneCardH] ALTER COLUMN [USERID] nVarChar(50) ;
 GO 
ALTER TABLE [dbo].[OneCardP] ALTER COLUMN [AUSERID] nVarChar(50) ;
 GO 
ALTER TABLE [dbo].[OneCardP] ALTER COLUMN [CUSERID] nVarChar(50) ;
 GO 
ALTER TABLE [dbo].[OneCardP] ALTER COLUMN [DESCRIPTION] nVarchar(255) ;
 GO 
ALTER TABLE [dbo].[OneCardP] ALTER COLUMN [LAST_OPR] nVarChar(50) ;
 GO 
ALTER TABLE [dbo].[OneCardP] ALTER COLUMN [USERID] nVarChar(50) ;
 GO 
ALTER TABLE [dbo].[ORPrintLog] ALTER COLUMN [Description] nVarchar(50) ;
 GO 
ALTER TABLE [dbo].[ORPrintLog] ALTER COLUMN [UserID] nVarChar(50) ;
 GO 
ALTER TABLE [dbo].[Owner] ALTER COLUMN [Description] nVarchar(50) ;
 GO 
ALTER TABLE [dbo].[Owner] ALTER COLUMN [Last_Opr] nVarChar(50) ;
 GO 
DROP INDEX [dbo].[PAlias].[I_PAlias];
 GO 
ALTER TABLE [dbo].[PAlias] ALTER COLUMN [Address] nVarChar(1024) ;
 GO 
CREATE UNIQUE NONCLUSTERED INDEX [I_PAlias] ON [dbo].[PAlias] (  [ID] , [MID] , [Name] , [Address] )
 GO 
ALTER TABLE [dbo].[PAlias] ALTER COLUMN [Email] nVarChar(512) ;
 GO 
ALTER TABLE [dbo].[PAlias] ALTER COLUMN [LAST_OPR] nVarChar(50) ;
 GO 
ALTER TABLE [dbo].[PAlias] ALTER COLUMN [Notes] nVarChar(255) ;
 GO 
ALTER TABLE [dbo].[PAYOR] ALTER COLUMN [ADDRESS_1] nVarChar(255) ;
 GO 
ALTER TABLE [dbo].[PAYOR] ALTER COLUMN [ADDRESS_2] nVarChar(255) ;
 GO 
ALTER TABLE [dbo].[PAYOR] ALTER COLUMN [ADDRESS_3] nVarChar(255) ;
 GO 
ALTER TABLE [dbo].[PAYOR] ALTER COLUMN [BankName] nVarChar(150) ;
 GO 
ALTER TABLE [dbo].[PAYOR] ALTER COLUMN [LUserID] nVarChar(50) ;
 GO 
ALTER TABLE [dbo].[PCALC] ALTER COLUMN [Description] nVarchar(max) ;
 GO 
ALTER TABLE [dbo].[PCLASS] ALTER COLUMN [Last_Opr] nVarChar(50) ;
 GO 
ALTER TABLE [dbo].[PCSummary] ALTER COLUMN [Last_Opr] nVarChar(50) ;
 GO 
ALTER TABLE [dbo].[PCSummary] ALTER COLUMN [Remarks] nVarChar(512) ;
 GO 
ALTER TABLE [dbo].[PDOCLIST] ALTER COLUMN [DESCRIPTION] nVarchar(255) ;
 GO 
ALTER TABLE [dbo].[PERIOD] ALTER COLUMN [Description] nVarchar(20) ;
 GO 
ALTER TABLE [dbo].[PettyCashD] ALTER COLUMN [Remarks] nVarChar(100) ;
 GO 
ALTER TABLE [dbo].[PettyCashH] ALTER COLUMN [AUserID] nVarChar(50) ;
 GO 
ALTER TABLE [dbo].[PettyCashH] ALTER COLUMN [CUSERID] nVarChar(50) ;
 GO 
ALTER TABLE [dbo].[PettyCashH] ALTER COLUMN [Last_Opr] nVarChar(50) ;
 GO 
ALTER TABLE [dbo].[PettyCashH] ALTER COLUMN [Remarks] nVarChar(100) ;
 GO 
ALTER TABLE [dbo].[PettyCashH] ALTER COLUMN [UserID] nVarChar(50) ;
 GO 
ALTER TABLE [dbo].[PettyCashType] ALTER COLUMN [Description] nVarchar(50) ;
 GO 
ALTER TABLE [dbo].[PettyCashType] ALTER COLUMN [Last_Opr] nVarChar(50) ;
 GO 
ALTER TABLE [dbo].[PFLScale] ALTER COLUMN [Last_Opr] nVarChar(50) ;
 GO 
ALTER TABLE [dbo].[PHOLDER] ALTER COLUMN [Last_Opr] nVarChar(50) ;
 GO 
ALTER TABLE [dbo].[PHOLDER] ALTER COLUMN [UserID] nVarChar(50) ;
 GO 
ALTER TABLE [dbo].[pJournal] ALTER COLUMN [Description] nVarchar(100) ;
 GO 
ALTER TABLE [dbo].[pJournal] ALTER COLUMN [Last_Opr] nVarChar(50) ;
 GO 
ALTER TABLE [dbo].[PNOTES] ALTER COLUMN [LBLNotes_1] nVarChar(100) ;
 GO 
ALTER TABLE [dbo].[PNOTES] ALTER COLUMN [LBLNotes_10] nVarChar(100) ;
 GO 
ALTER TABLE [dbo].[PNOTES] ALTER COLUMN [LBLNotes_2] nVarChar(100) ;
 GO 
ALTER TABLE [dbo].[PNOTES] ALTER COLUMN [LBLNotes_3] nVarChar(100) ;
 GO 
ALTER TABLE [dbo].[PNOTES] ALTER COLUMN [LBLNotes_4] nVarChar(100) ;
 GO 
ALTER TABLE [dbo].[PNOTES] ALTER COLUMN [LBLNotes_5] nVarChar(100) ;
 GO 
ALTER TABLE [dbo].[PNOTES] ALTER COLUMN [LBLNotes_6] nVarChar(100) ;
 GO 
ALTER TABLE [dbo].[PNOTES] ALTER COLUMN [LBLNotes_7] nVarChar(100) ;
 GO 
ALTER TABLE [dbo].[PNOTES] ALTER COLUMN [LBLNotes_8] nVarChar(100) ;
 GO 
ALTER TABLE [dbo].[PNOTES] ALTER COLUMN [LBLNotes_9] nVarChar(100) ;
 GO 
ALTER TABLE [dbo].[PNOTES] ALTER COLUMN [Notes] nVarChar(max) ;
 GO 
ALTER TABLE [dbo].[PNOTES] ALTER COLUMN [Notes_1] nVarChar(max) ;
 GO 
ALTER TABLE [dbo].[PNOTES] ALTER COLUMN [Notes_10] nVarChar(max) ;
 GO 
ALTER TABLE [dbo].[PNOTES] ALTER COLUMN [Notes_2] nVarChar(max) ;
 GO 
ALTER TABLE [dbo].[PNOTES] ALTER COLUMN [Notes_3] nVarChar(max) ;
 GO 
ALTER TABLE [dbo].[PNOTES] ALTER COLUMN [Notes_4] nVarChar(max) ;
 GO 
ALTER TABLE [dbo].[PNOTES] ALTER COLUMN [Notes_5] nVarChar(max) ;
 GO 
ALTER TABLE [dbo].[PNOTES] ALTER COLUMN [Notes_6] nVarChar(max) ;
 GO 
ALTER TABLE [dbo].[PNOTES] ALTER COLUMN [Notes_7] nVarChar(max) ;
 GO 
ALTER TABLE [dbo].[PNOTES] ALTER COLUMN [Notes_8] nVarChar(max) ;
 GO 
ALTER TABLE [dbo].[PNOTES] ALTER COLUMN [Notes_9] nVarChar(max) ;
 GO 
ALTER TABLE [dbo].[PNOTES] ALTER COLUMN [UserID] nVarChar(50) ;
 GO 
ALTER TABLE [dbo].[PNotify] ALTER COLUMN [Remarks] nVarchar(Max) ;
 GO 
ALTER TABLE [dbo].[PNotify] ALTER COLUMN [UserID] nVarChar(50) ;
 GO 
ALTER TABLE [dbo].[PolicyType] ALTER COLUMN [Description] nVarchar(50) ;
 GO 
ALTER TABLE [dbo].[PolicyType] ALTER COLUMN [Last_Opr] nVarChar(50) ;
 GO 
ALTER TABLE [dbo].[Port] ALTER COLUMN [Description] nVarchar(255) ;
 GO 
ALTER TABLE [dbo].[Port] ALTER COLUMN [Last_Opr] nVarChar(50) ;
 GO 
ALTER TABLE [dbo].[PPrintLog] ALTER COLUMN [Description] nVarchar(50) NOT NULL;
 GO 
ALTER TABLE [dbo].[PPrintLog] ALTER COLUMN [UserID] nVarChar(50) ;
 GO 
ALTER TABLE [dbo].[ProAcc] ALTER COLUMN [BankName] nVarChar(255) ;
 GO 
ALTER TABLE [dbo].[ProAcc] ALTER COLUMN [Description] nVarchar(255) ;
 GO 
ALTER TABLE [dbo].[ProAcc] ALTER COLUMN [LAST_OPR] nVarChar(50) ;
 GO 
ALTER TABLE [dbo].[ProAcc] ALTER COLUMN [PUserID] nVarChar(50) ;
 GO 
ALTER TABLE [dbo].[ProAcc] ALTER COLUMN [Remarks] nVarChar(512) ;
 GO 
ALTER TABLE [dbo].[ProAcc] ALTER COLUMN [USERID] nVarChar(50) ;
 GO 
ALTER TABLE [dbo].[Profile] ALTER COLUMN [Address_1] nVarChar(510) ;
 GO 
ALTER TABLE [dbo].[Profile] ALTER COLUMN [Address_2] nVarChar(510) ;
 GO 
ALTER TABLE [dbo].[Profile] ALTER COLUMN [Address_3] nVarChar(510) ;
 GO 
ALTER TABLE [dbo].[Profile] ALTER COLUMN [Building] nVarChar(200) ;
 GO 
ALTER TABLE [dbo].[Profile] ALTER COLUMN [City] nVarChar(100) ;
 GO 
ALTER TABLE [dbo].[Profile] ALTER COLUMN [Contact] nVarChar(100) ;
 GO 
ALTER TABLE [dbo].[Profile] ALTER COLUMN [Contact_1] nVarChar(100) ;
 GO 
ALTER TABLE [dbo].[Profile] ALTER COLUMN [Contact_3] nVarChar(100) ;
 GO 
ALTER TABLE [dbo].[Profile] ALTER COLUMN [ContactAddress] nVarChar(510) ;
 GO 
ALTER TABLE [dbo].[Profile] ALTER COLUMN [ContactAddress_1] nVarChar(510) ;
 GO 
ALTER TABLE [dbo].[Profile] ALTER COLUMN [ContactAddress_3] nVarChar(450) ;
 GO 
ALTER TABLE [dbo].[Profile] ALTER COLUMN [ContactPhone] nVarChar(60) ;
 GO 
ALTER TABLE [dbo].[Profile] ALTER COLUMN [ContactPhone_1] nVarChar(60) ;
 GO 
ALTER TABLE [dbo].[Profile] ALTER COLUMN [ContactPhone_3] nVarChar(40) ;
 GO 
ALTER TABLE [dbo].[Profile] ALTER COLUMN [ContactTitle] nVarChar(100) ;
 GO 
ALTER TABLE [dbo].[Profile] ALTER COLUMN [Country] nVarChar(20) ;
 GO 
ALTER TABLE [dbo].[Profile] ALTER COLUMN [District] nVarChar(1020) ;
 GO 
ALTER TABLE [dbo].[Profile] ALTER COLUMN [Email] nVarChar(1024) ;
 GO 
ALTER TABLE [dbo].[Profile] ALTER COLUMN [Email_2] nVarChar(1024) ;
 GO 
ALTER TABLE [dbo].[Profile] ALTER COLUMN [Ext_1] nVarChar(40) ;
 GO 
ALTER TABLE [dbo].[Profile] ALTER COLUMN [FirstName] nVarChar(510) ;
 GO 
ALTER TABLE [dbo].[Profile] ALTER COLUMN [FName] nVarChar(510) ;
 GO 
ALTER TABLE [dbo].[Profile] ALTER COLUMN [HomeNo] nVarChar(200) ;
 GO 
ALTER TABLE [dbo].[Profile] ALTER COLUMN [Initial] nVarChar(10) ;
 GO 
ALTER TABLE [dbo].[Profile] ALTER COLUMN [LAST_OPR] nVarChar(100) ;
 GO 
ALTER TABLE [dbo].[Profile] ALTER COLUMN [LastName] nVarChar(510) ;
 GO 
ALTER TABLE [dbo].[Profile] ALTER COLUMN [LName] nVarChar(510) ;
 GO 
ALTER TABLE [dbo].[Profile] ALTER COLUMN [MidName] nVarChar(510) ;
 GO 
ALTER TABLE [dbo].[Profile] ALTER COLUMN [MName] nVarChar(510) ;
 GO 
ALTER TABLE [dbo].[Profile] ALTER COLUMN [MOO] nVarChar(200) ;
 GO 
DROP INDEX [dbo].[Profile].[I_Profile_Name];
 GO 
ALTER TABLE [dbo].[Profile] ALTER COLUMN [Name] nVarChar(510) ;
 GO 
CREATE NONCLUSTERED INDEX [I_Profile_Name] ON [dbo].[Profile] (  [Name] )
 GO 
ALTER TABLE [dbo].[Profile] ALTER COLUMN [Province] nVarChar(50) ;
 GO 
ALTER TABLE [dbo].[Profile] ALTER COLUMN [RedFlagDescription] nVarChar(510) ;
 GO 
ALTER TABLE [dbo].[Profile] ALTER COLUMN [RedFlagUser] nVarChar(100) ;
 GO 
ALTER TABLE [dbo].[Profile] ALTER COLUMN [Regency] nVarChar(20) ;
 GO 
ALTER TABLE [dbo].[Profile] ALTER COLUMN [REMARK] nVarChar(510) ;
 GO 
ALTER TABLE [dbo].[Profile] ALTER COLUMN [Road] nVarChar(200) ;
 GO 
ALTER TABLE [dbo].[Profile] ALTER COLUMN [RoomNo] nVarChar(200) ;
 GO 
ALTER TABLE [dbo].[Profile] ALTER COLUMN [Salutation] nVarChar(200) ;
 GO 
ALTER TABLE [dbo].[Profile] ALTER COLUMN [ShortName] nVarChar(10) ;
 GO 
ALTER TABLE [dbo].[Profile] ALTER COLUMN [SOI] nVarChar(200) ;
 GO 
ALTER TABLE [dbo].[Profile] ALTER COLUMN [SubDistrict] nVarChar(1020) ;
 GO 
ALTER TABLE [dbo].[Profile] ALTER COLUMN [SYNCERRORMESSAGE] nVarChar(MAX) ;
 GO 
ALTER TABLE [dbo].[Profile] ALTER COLUMN [TaxAddress] nVarChar(510) ;
 GO 
ALTER TABLE [dbo].[Profile] ALTER COLUMN [TaxName] nVarChar(510) ;
 GO 
ALTER TABLE [dbo].[Profile] ALTER COLUMN [Title] nVarChar(100) ;
 GO 
ALTER TABLE [dbo].[Profile] ALTER COLUMN [Title_1] nVarChar(100) ;
 GO 
ALTER TABLE [dbo].[Profile] ALTER COLUMN [Title_3] nVarChar(50) ;
 GO 
ALTER TABLE [dbo].[Profile] ALTER COLUMN [USERID] nVarChar(100) ;
 GO 
ALTER TABLE [dbo].[Profile] ALTER COLUMN [VerifiedBy] nVarChar(100) ;
 GO 
ALTER TABLE [dbo].[Profile] ALTER COLUMN [Village] nVarChar(200) ;
 GO 
ALTER TABLE [dbo].[Profile_Ext] ALTER COLUMN [ADDHOMEPAGE] nVarChar(100) ;
 GO 
ALTER TABLE [dbo].[Profile_Ext] ALTER COLUMN [BeneficiaryOwner] nVarChar(510) ;
 GO 
ALTER TABLE [dbo].[Profile_Ext] ALTER COLUMN [BirthPlace] nVarChar(200) ;
 GO 
ALTER TABLE [dbo].[Profile_Ext] ALTER COLUMN [BLPlace] nVarChar(510) ;
 GO 
ALTER TABLE [dbo].[Profile_Ext] ALTER COLUMN [BOD_1] nVarChar(510) ;
 GO 
ALTER TABLE [dbo].[Profile_Ext] ALTER COLUMN [BOD_2] nVarChar(510) ;
 GO 
ALTER TABLE [dbo].[Profile_Ext] ALTER COLUMN [BOD_3] nVarChar(510) ;
 GO 
ALTER TABLE [dbo].[Profile_Ext] ALTER COLUMN [BODFunction_1] nVarChar(510) ;
 GO 
ALTER TABLE [dbo].[Profile_Ext] ALTER COLUMN [BODFunction_2] nVarChar(510) ;
 GO 
ALTER TABLE [dbo].[Profile_Ext] ALTER COLUMN [BODFunction_3] nVarChar(510) ;
 GO 
ALTER TABLE [dbo].[Profile_Ext] ALTER COLUMN [CAddress] nVarChar(510) ;
 GO 
ALTER TABLE [dbo].[Profile_Ext] ALTER COLUMN [Citizen] nVarChar(100) ;
 GO 
ALTER TABLE [dbo].[Profile_Ext] ALTER COLUMN [CName] nVarChar(510) ;
 GO 
ALTER TABLE [dbo].[Profile_Ext] ALTER COLUMN [HOMEPAGE] nVarChar(100) ;
 GO 
ALTER TABLE [dbo].[Profile_Ext] ALTER COLUMN [ID_Name] nVarChar(510) ;
 GO 
ALTER TABLE [dbo].[Profile_Ext] ALTER COLUMN [ID_Name_Ext] nVarChar(510) ;
 GO 
ALTER TABLE [dbo].[Profile_Ext] ALTER COLUMN [JOBTitle] nVarChar(510) ;
 GO 
ALTER TABLE [dbo].[Profile_Ext] ALTER COLUMN [MothersName] nVarChar(510) ;
 GO 
ALTER TABLE [dbo].[Profile_Ext] ALTER COLUMN [NickName] nVarChar(510) ;
 GO 
ALTER TABLE [dbo].[Profile_Ext] ALTER COLUMN [PIC_NAME_1] nVarChar(100) ;
 GO 
ALTER TABLE [dbo].[Profile_Ext] ALTER COLUMN [PIC_NAME_2] nVarChar(100) ;
 GO 
ALTER TABLE [dbo].[Profile_Ext] ALTER COLUMN [PIC_NAME_3] nVarChar(100) ;
 GO 
ALTER TABLE [dbo].[Profile_Ext] ALTER COLUMN [PIC_TITLE_1] nVarChar(510) ;
 GO 
ALTER TABLE [dbo].[Profile_Ext] ALTER COLUMN [PIC_TITLE_2] nVarChar(100) ;
 GO 
ALTER TABLE [dbo].[Profile_Ext] ALTER COLUMN [PIC_TITLE_3] nVarChar(100) ;
 GO 
ALTER TABLE [dbo].[Profile_Ext] ALTER COLUMN [SHolder_1] nVarChar(510) ;
 GO 
ALTER TABLE [dbo].[Profile_Ext] ALTER COLUMN [SHolder_2] nVarChar(510) ;
 GO 
ALTER TABLE [dbo].[Profile_Ext] ALTER COLUMN [SHolder_3] nVarChar(510) ;
 GO 
ALTER TABLE [dbo].[Profile_Income] DROP CONSTRAINT [I_Profile_Income];
 GO 
ALTER TABLE [dbo].[Profile_Income] ALTER COLUMN [Description] nVarChar(200) NOT NULL;
 GO 
ALTER TABLE [dbo].[Profile_Income] WITH NOCHECK ADD CONSTRAINT [I_Profile_Income] PRIMARY KEY NONCLUSTERED( [Income] , [Description] , [AllowedF] , [CorporateF] ) WITH (ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = OFF) ON [PRIMARY]
 GO 
ALTER TABLE [dbo].[Profile_IncomeSource] DROP CONSTRAINT [I_Profile_IncomeSource];
 GO 
ALTER TABLE [dbo].[Profile_IncomeSource] ALTER COLUMN [Description] nVarChar(100) NOT NULL;
 GO 
ALTER TABLE [dbo].[Profile_IncomeSource] WITH NOCHECK ADD CONSTRAINT [I_Profile_IncomeSource] PRIMARY KEY NONCLUSTERED( [IncomeSource] , [Description] , [AllowedF] , [CorporateF] ) WITH (ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = OFF) ON [PRIMARY]
 GO 
ALTER TABLE [dbo].[ProfilePIC] ALTER COLUMN [Last_Opr] nVarChar(100) ;
 GO 
ALTER TABLE [dbo].[ProfilePIC] ALTER COLUMN [Remark] nVarChar(Max) ;
 GO 
ALTER TABLE [dbo].[ProfilePIC] ALTER COLUMN [Title] nVarChar(510) ;
 GO 
ALTER TABLE [dbo].[Province] ALTER COLUMN [Description] nVarchar(50) ;
 GO 
ALTER TABLE [dbo].[Province] ALTER COLUMN [Description_1] nVarChar(100) ;
 GO 
ALTER TABLE [dbo].[Province] ALTER COLUMN [Last_OPR] nVarChar(50) ;
 GO 
ALTER TABLE [dbo].[PScale] ALTER COLUMN [Last_Opr] nVarChar(50) ;
 GO 
ALTER TABLE [dbo].[pSL] ALTER COLUMN [Description] nVarchar(512) ;
 GO 
ALTER TABLE [dbo].[pSL] ALTER COLUMN [Remarks] nVarChar(4000) ;
 GO 
ALTER TABLE [dbo].[pSLRef] ALTER COLUMN [Description] nVarchar(50) NOT NULL;
 GO 
ALTER TABLE [dbo].[PTClass] ALTER COLUMN [Last_Opr] nVarChar(50) ;
 GO 
ALTER TABLE [dbo].[PTermCon] ALTER COLUMN [Description] nVarchar(512) ;
 GO 
ALTER TABLE [dbo].[PTermCon] ALTER COLUMN [Description_1] nVarchar(512) ;
 GO 
ALTER TABLE [dbo].[PTermCon] ALTER COLUMN [Remarks] nVarChar(1000) ;
 GO 
ALTER TABLE [dbo].[pType] ALTER COLUMN [Description] nVarchar(50) ;
 GO 
ALTER TABLE [dbo].[pType] ALTER COLUMN [Last_Opr] nVarChar(10) ;
 GO 
ALTER TABLE [dbo].[pVoucher] ALTER COLUMN [AcceptedBy] nVarChar(255) ;
 GO 
ALTER TABLE [dbo].[pVoucher] ALTER COLUMN [AUserID] nVarChar(50) ;
 GO 
ALTER TABLE [dbo].[pVoucher] ALTER COLUMN [AUserID_Ext] nVarChar(50) ;
 GO 
ALTER TABLE [dbo].[pVoucher] ALTER COLUMN [BankName] nVarChar(255) ;
 GO 
ALTER TABLE [dbo].[pVoucher] ALTER COLUMN [Last_Opr] nVarChar(50) ;
 GO 
ALTER TABLE [dbo].[pVoucher] ALTER COLUMN [Otorized2By] nVarChar(10) ;
 GO 
ALTER TABLE [dbo].[pVoucher] ALTER COLUMN [Otorized2ByTitle] nVarChar(100) ;
 GO 
ALTER TABLE [dbo].[pVoucher] ALTER COLUMN [OtorizedBy] nVarChar(10) ;
 GO 
ALTER TABLE [dbo].[pVoucher] ALTER COLUMN [OtorizedByTitle] nVarChar(100) ;
 GO 
ALTER TABLE [dbo].[pVoucher] ALTER COLUMN [Remarks] nVarChar(max) ;
 GO 
ALTER TABLE [dbo].[pVoucher] ALTER COLUMN [RequestMessage] nVarChar(512) ;
 GO 
ALTER TABLE [dbo].[pVoucher] ALTER COLUMN [RequestName] nVarChar(50) ;
 GO 
ALTER TABLE [dbo].[pVoucher] ALTER COLUMN [USERID] nVarChar(50) ;
 GO 
ALTER TABLE [dbo].[pVoucher] ALTER COLUMN [VerifiedBy] nVarChar(10) ;
 GO 
ALTER TABLE [dbo].[pVoucher] ALTER COLUMN [VerifiedByTitle] nVarChar(100) ;
 GO 
ALTER TABLE [dbo].[pYearSetup] ALTER COLUMN [Description] nVarchar(20) ;
 GO 
ALTER TABLE [dbo].[QPrintLog] ALTER COLUMN [Description] nVarchar(50) ;
 GO 
ALTER TABLE [dbo].[QPrintLog] ALTER COLUMN [UserID] nVarChar(50) ;
 GO 
ALTER TABLE [dbo].[RAccClassDet] ALTER COLUMN [Description] nVarchar(200) ;
 GO 
ALTER TABLE [dbo].[RARRDET] ALTER COLUMN [AcceptedBy] nVarChar(100) ;
 GO 
ALTER TABLE [dbo].[RARRDET] ALTER COLUMN [AUserID] nVarChar(50) ;
 GO 
ALTER TABLE [dbo].[RARRDET] ALTER COLUMN [Description] nVarchar(255) ;
 GO 
ALTER TABLE [dbo].[RARRDET] ALTER COLUMN [LUserID] nVarChar(50) ;
 GO 
ALTER TABLE [dbo].[RARRDET] ALTER COLUMN [MEMO] nVarchar(Max) ;
 GO 
ALTER TABLE [dbo].[RARRDET] ALTER COLUMN [SysUserID] nVarChar(50) ;
 GO 
ALTER TABLE [dbo].[RARRDET] ALTER COLUMN [USERID] nVarChar(50) ;
 GO 
ALTER TABLE [dbo].[RARRHEADER] ALTER COLUMN [LUserID] nVarChar(50) ;
 GO 
ALTER TABLE [dbo].[RATECON] ALTER COLUMN [Last_Opr] nVarChar(50) ;
 GO 
ALTER TABLE [dbo].[RATECON] ALTER COLUMN [VALUEDESC1] nVarchar(Max) ;
 GO 
ALTER TABLE [dbo].[RATECON] ALTER COLUMN [VALUEDESC10] nVarchar(Max) ;
 GO 
ALTER TABLE [dbo].[RATECON] ALTER COLUMN [VALUEDESC11] nVarchar(Max) ;
 GO 
ALTER TABLE [dbo].[RATECON] ALTER COLUMN [VALUEDESC12] nVarchar(Max) ;
 GO 
ALTER TABLE [dbo].[RATECON] ALTER COLUMN [VALUEDESC13] nVarchar(Max) ;
 GO 
ALTER TABLE [dbo].[RATECON] ALTER COLUMN [VALUEDESC14] nVarchar(Max) ;
 GO 
ALTER TABLE [dbo].[RATECON] ALTER COLUMN [VALUEDESC15] nVarchar(Max) ;
 GO 
ALTER TABLE [dbo].[RATECON] ALTER COLUMN [VALUEDESC2] nVarchar(Max) ;
 GO 
ALTER TABLE [dbo].[RATECON] ALTER COLUMN [VALUEDESC3] nVarchar(Max) ;
 GO 
ALTER TABLE [dbo].[RATECON] ALTER COLUMN [VALUEDESC4] nVarchar(Max) ;
 GO 
ALTER TABLE [dbo].[RATECON] ALTER COLUMN [VALUEDESC5] nVarchar(Max) ;
 GO 
ALTER TABLE [dbo].[RATECON] ALTER COLUMN [VALUEDESC6] nVarchar(Max) ;
 GO 
ALTER TABLE [dbo].[RATECON] ALTER COLUMN [VALUEDESC7] nVarchar(Max) ;
 GO 
ALTER TABLE [dbo].[RATECON] ALTER COLUMN [VALUEDESC8] nVarchar(Max) ;
 GO 
ALTER TABLE [dbo].[RATECON] ALTER COLUMN [VALUEDESC9] nVarchar(Max) ;
 GO 
ALTER TABLE [dbo].[RATECON_M1] ALTER COLUMN [Last_Opr] nVarChar(50) ;
 GO 
ALTER TABLE [dbo].[RATECON_M1] ALTER COLUMN [VALUEDESC1] nVarchar(Max) ;
 GO 
ALTER TABLE [dbo].[RATECON_M1] ALTER COLUMN [VALUEDESC10] nVarchar(Max) ;
 GO 
ALTER TABLE [dbo].[RATECON_M1] ALTER COLUMN [VALUEDESC11] nVarchar(Max) ;
 GO 
ALTER TABLE [dbo].[RATECON_M1] ALTER COLUMN [VALUEDESC12] nVarchar(Max) ;
 GO 
ALTER TABLE [dbo].[RATECON_M1] ALTER COLUMN [VALUEDESC13] nVarchar(Max) ;
 GO 
ALTER TABLE [dbo].[RATECON_M1] ALTER COLUMN [VALUEDESC14] nVarchar(Max) ;
 GO 
ALTER TABLE [dbo].[RATECON_M1] ALTER COLUMN [VALUEDESC15] nVarchar(Max) ;
 GO 
ALTER TABLE [dbo].[RATECON_M1] ALTER COLUMN [VALUEDESC2] nVarchar(Max) ;
 GO 
ALTER TABLE [dbo].[RATECON_M1] ALTER COLUMN [VALUEDESC3] nVarchar(Max) ;
 GO 
ALTER TABLE [dbo].[RATECON_M1] ALTER COLUMN [VALUEDESC4] nVarchar(Max) ;
 GO 
ALTER TABLE [dbo].[RATECON_M1] ALTER COLUMN [VALUEDESC5] nVarchar(Max) ;
 GO 
ALTER TABLE [dbo].[RATECON_M1] ALTER COLUMN [VALUEDESC6] nVarchar(Max) ;
 GO 
ALTER TABLE [dbo].[RATECON_M1] ALTER COLUMN [VALUEDESC7] nVarchar(Max) ;
 GO 
ALTER TABLE [dbo].[RATECON_M1] ALTER COLUMN [VALUEDESC8] nVarchar(Max) ;
 GO 
ALTER TABLE [dbo].[RATECON_M1] ALTER COLUMN [VALUEDESC9] nVarchar(Max) ;
 GO 
ALTER TABLE [dbo].[RATECON_M2] ALTER COLUMN [Last_Opr] nVarChar(50) ;
 GO 
ALTER TABLE [dbo].[RATECON_M2] ALTER COLUMN [VALUEDESC1] nVarchar(Max) ;
 GO 
ALTER TABLE [dbo].[RATECON_M2] ALTER COLUMN [VALUEDESC10] nVarchar(Max) ;
 GO 
ALTER TABLE [dbo].[RATECON_M2] ALTER COLUMN [VALUEDESC11] nVarchar(Max) ;
 GO 
ALTER TABLE [dbo].[RATECON_M2] ALTER COLUMN [VALUEDESC12] nVarchar(Max) ;
 GO 
ALTER TABLE [dbo].[RATECON_M2] ALTER COLUMN [VALUEDESC13] nVarchar(Max) ;
 GO 
ALTER TABLE [dbo].[RATECON_M2] ALTER COLUMN [VALUEDESC14] nVarchar(Max) ;
 GO 
ALTER TABLE [dbo].[RATECON_M2] ALTER COLUMN [VALUEDESC15] nVarchar(Max) ;
 GO 
ALTER TABLE [dbo].[RATECON_M2] ALTER COLUMN [VALUEDESC2] nVarchar(Max) ;
 GO 
ALTER TABLE [dbo].[RATECON_M2] ALTER COLUMN [VALUEDESC3] nVarchar(Max) ;
 GO 
ALTER TABLE [dbo].[RATECON_M2] ALTER COLUMN [VALUEDESC4] nVarchar(Max) ;
 GO 
ALTER TABLE [dbo].[RATECON_M2] ALTER COLUMN [VALUEDESC5] nVarchar(Max) ;
 GO 
ALTER TABLE [dbo].[RATECON_M2] ALTER COLUMN [VALUEDESC6] nVarchar(Max) ;
 GO 
ALTER TABLE [dbo].[RATECON_M2] ALTER COLUMN [VALUEDESC7] nVarchar(Max) ;
 GO 
ALTER TABLE [dbo].[RATECON_M2] ALTER COLUMN [VALUEDESC8] nVarchar(Max) ;
 GO 
ALTER TABLE [dbo].[RATECON_M2] ALTER COLUMN [VALUEDESC9] nVarchar(Max) ;
 GO 
ALTER TABLE [dbo].[RATECON_M3] ALTER COLUMN [Last_Opr] nVarChar(50) ;
 GO 
ALTER TABLE [dbo].[RATECON_M3] ALTER COLUMN [VALUEDESC1] nVarchar(Max) ;
 GO 
ALTER TABLE [dbo].[RATECON_M3] ALTER COLUMN [VALUEDESC10] nVarchar(Max) ;
 GO 
ALTER TABLE [dbo].[RATECON_M3] ALTER COLUMN [VALUEDESC11] nVarchar(Max) ;
 GO 
ALTER TABLE [dbo].[RATECON_M3] ALTER COLUMN [VALUEDESC12] nVarchar(Max) ;
 GO 
ALTER TABLE [dbo].[RATECON_M3] ALTER COLUMN [VALUEDESC13] nVarchar(Max) ;
 GO 
ALTER TABLE [dbo].[RATECON_M3] ALTER COLUMN [VALUEDESC14] nVarchar(Max) ;
 GO 
ALTER TABLE [dbo].[RATECON_M3] ALTER COLUMN [VALUEDESC15] nVarchar(Max) ;
 GO 
ALTER TABLE [dbo].[RATECON_M3] ALTER COLUMN [VALUEDESC2] nVarchar(Max) ;
 GO 
ALTER TABLE [dbo].[RATECON_M3] ALTER COLUMN [VALUEDESC3] nVarchar(Max) ;
 GO 
ALTER TABLE [dbo].[RATECON_M3] ALTER COLUMN [VALUEDESC4] nVarchar(Max) ;
 GO 
ALTER TABLE [dbo].[RATECON_M3] ALTER COLUMN [VALUEDESC5] nVarchar(Max) ;
 GO 
ALTER TABLE [dbo].[RATECON_M3] ALTER COLUMN [VALUEDESC6] nVarchar(Max) ;
 GO 
ALTER TABLE [dbo].[RATECON_M3] ALTER COLUMN [VALUEDESC7] nVarchar(Max) ;
 GO 
ALTER TABLE [dbo].[RATECON_M3] ALTER COLUMN [VALUEDESC8] nVarchar(Max) ;
 GO 
ALTER TABLE [dbo].[RATECON_M3] ALTER COLUMN [VALUEDESC9] nVarchar(Max) ;
 GO 
ALTER TABLE [dbo].[RATECON_M4] ALTER COLUMN [Last_Opr] nVarChar(50) ;
 GO 
ALTER TABLE [dbo].[RATECON_M4] ALTER COLUMN [VALUEDESC1] nVarchar(Max) ;
 GO 
ALTER TABLE [dbo].[RATECON_M4] ALTER COLUMN [VALUEDESC10] nVarchar(Max) ;
 GO 
ALTER TABLE [dbo].[RATECON_M4] ALTER COLUMN [VALUEDESC11] nVarchar(Max) ;
 GO 
ALTER TABLE [dbo].[RATECON_M4] ALTER COLUMN [VALUEDESC12] nVarchar(Max) ;
 GO 
ALTER TABLE [dbo].[RATECON_M4] ALTER COLUMN [VALUEDESC13] nVarchar(Max) ;
 GO 
ALTER TABLE [dbo].[RATECON_M4] ALTER COLUMN [VALUEDESC14] nVarchar(Max) ;
 GO 
ALTER TABLE [dbo].[RATECON_M4] ALTER COLUMN [VALUEDESC15] nVarchar(Max) ;
 GO 
ALTER TABLE [dbo].[RATECON_M4] ALTER COLUMN [VALUEDESC2] nVarchar(Max) ;
 GO 
ALTER TABLE [dbo].[RATECON_M4] ALTER COLUMN [VALUEDESC3] nVarchar(Max) ;
 GO 
ALTER TABLE [dbo].[RATECON_M4] ALTER COLUMN [VALUEDESC4] nVarchar(Max) ;
 GO 
ALTER TABLE [dbo].[RATECON_M4] ALTER COLUMN [VALUEDESC5] nVarchar(Max) ;
 GO 
ALTER TABLE [dbo].[RATECON_M4] ALTER COLUMN [VALUEDESC6] nVarchar(Max) ;
 GO 
ALTER TABLE [dbo].[RATECON_M4] ALTER COLUMN [VALUEDESC7] nVarchar(Max) ;
 GO 
ALTER TABLE [dbo].[RATECON_M4] ALTER COLUMN [VALUEDESC8] nVarchar(Max) ;
 GO 
ALTER TABLE [dbo].[RATECON_M4] ALTER COLUMN [VALUEDESC9] nVarchar(Max) ;
 GO 
ALTER TABLE [dbo].[RATECON_M5] ALTER COLUMN [Last_Opr] nVarChar(50) ;
 GO 
ALTER TABLE [dbo].[RATECON_M5] ALTER COLUMN [VALUEDESC1] nVarchar(Max) ;
 GO 
ALTER TABLE [dbo].[RATECON_M5] ALTER COLUMN [VALUEDESC10] nVarchar(Max) ;
 GO 
ALTER TABLE [dbo].[RATECON_M5] ALTER COLUMN [VALUEDESC11] nVarchar(Max) ;
 GO 
ALTER TABLE [dbo].[RATECON_M5] ALTER COLUMN [VALUEDESC12] nVarchar(Max) ;
 GO 
ALTER TABLE [dbo].[RATECON_M5] ALTER COLUMN [VALUEDESC13] nVarchar(Max) ;
 GO 
ALTER TABLE [dbo].[RATECON_M5] ALTER COLUMN [VALUEDESC14] nVarchar(Max) ;
 GO 
ALTER TABLE [dbo].[RATECON_M5] ALTER COLUMN [VALUEDESC15] nVarchar(Max) ;
 GO 
ALTER TABLE [dbo].[RATECON_M5] ALTER COLUMN [VALUEDESC2] nVarchar(Max) ;
 GO 
ALTER TABLE [dbo].[RATECON_M5] ALTER COLUMN [VALUEDESC3] nVarchar(Max) ;
 GO 
ALTER TABLE [dbo].[RATECON_M5] ALTER COLUMN [VALUEDESC4] nVarchar(Max) ;
 GO 
ALTER TABLE [dbo].[RATECON_M5] ALTER COLUMN [VALUEDESC5] nVarchar(Max) ;
 GO 
ALTER TABLE [dbo].[RATECON_M5] ALTER COLUMN [VALUEDESC6] nVarchar(Max) ;
 GO 
ALTER TABLE [dbo].[RATECON_M5] ALTER COLUMN [VALUEDESC7] nVarchar(Max) ;
 GO 
ALTER TABLE [dbo].[RATECON_M5] ALTER COLUMN [VALUEDESC8] nVarchar(Max) ;
 GO 
ALTER TABLE [dbo].[RATECON_M5] ALTER COLUMN [VALUEDESC9] nVarchar(Max) ;
 GO 
ALTER TABLE [dbo].[RATECON_M6] ALTER COLUMN [Last_Opr] nVarChar(50) ;
 GO 
ALTER TABLE [dbo].[RATECON_M6] ALTER COLUMN [VALUEDESC1] nVarchar(Max) ;
 GO 
ALTER TABLE [dbo].[RATECON_M6] ALTER COLUMN [VALUEDESC10] nVarchar(Max) ;
 GO 
ALTER TABLE [dbo].[RATECON_M6] ALTER COLUMN [VALUEDESC11] nVarchar(Max) ;
 GO 
ALTER TABLE [dbo].[RATECON_M6] ALTER COLUMN [VALUEDESC12] nVarchar(Max) ;
 GO 
ALTER TABLE [dbo].[RATECON_M6] ALTER COLUMN [VALUEDESC13] nVarchar(Max) ;
 GO 
ALTER TABLE [dbo].[RATECON_M6] ALTER COLUMN [VALUEDESC14] nVarchar(Max) ;
 GO 
ALTER TABLE [dbo].[RATECON_M6] ALTER COLUMN [VALUEDESC15] nVarchar(Max) ;
 GO 
ALTER TABLE [dbo].[RATECON_M6] ALTER COLUMN [VALUEDESC2] nVarchar(Max) ;
 GO 
ALTER TABLE [dbo].[RATECON_M6] ALTER COLUMN [VALUEDESC3] nVarchar(Max) ;
 GO 
ALTER TABLE [dbo].[RATECON_M6] ALTER COLUMN [VALUEDESC4] nVarchar(Max) ;
 GO 
ALTER TABLE [dbo].[RATECON_M6] ALTER COLUMN [VALUEDESC5] nVarchar(Max) ;
 GO 
ALTER TABLE [dbo].[RATECON_M6] ALTER COLUMN [VALUEDESC6] nVarchar(Max) ;
 GO 
ALTER TABLE [dbo].[RATECON_M6] ALTER COLUMN [VALUEDESC7] nVarchar(Max) ;
 GO 
ALTER TABLE [dbo].[RATECON_M6] ALTER COLUMN [VALUEDESC8] nVarchar(Max) ;
 GO 
ALTER TABLE [dbo].[RATECON_M6] ALTER COLUMN [VALUEDESC9] nVarchar(Max) ;
 GO 
ALTER TABLE [dbo].[RATECON_M7] ALTER COLUMN [Last_Opr] nVarChar(50) ;
 GO 
ALTER TABLE [dbo].[RATECON_M7] ALTER COLUMN [VALUEDESC1] nVarchar(Max) ;
 GO 
ALTER TABLE [dbo].[RATECON_M7] ALTER COLUMN [VALUEDESC10] nVarchar(Max) ;
 GO 
ALTER TABLE [dbo].[RATECON_M7] ALTER COLUMN [VALUEDESC11] nVarchar(Max) ;
 GO 
ALTER TABLE [dbo].[RATECON_M7] ALTER COLUMN [VALUEDESC12] nVarchar(Max) ;
 GO 
ALTER TABLE [dbo].[RATECON_M7] ALTER COLUMN [VALUEDESC13] nVarchar(Max) ;
 GO 
ALTER TABLE [dbo].[RATECON_M7] ALTER COLUMN [VALUEDESC14] nVarchar(Max) ;
 GO 
ALTER TABLE [dbo].[RATECON_M7] ALTER COLUMN [VALUEDESC15] nVarchar(Max) ;
 GO 
ALTER TABLE [dbo].[RATECON_M7] ALTER COLUMN [VALUEDESC2] nVarchar(Max) ;
 GO 
ALTER TABLE [dbo].[RATECON_M7] ALTER COLUMN [VALUEDESC3] nVarchar(Max) ;
 GO 
ALTER TABLE [dbo].[RATECON_M7] ALTER COLUMN [VALUEDESC4] nVarchar(Max) ;
 GO 
ALTER TABLE [dbo].[RATECON_M7] ALTER COLUMN [VALUEDESC5] nVarchar(Max) ;
 GO 
ALTER TABLE [dbo].[RATECON_M7] ALTER COLUMN [VALUEDESC6] nVarchar(Max) ;
 GO 
ALTER TABLE [dbo].[RATECON_M7] ALTER COLUMN [VALUEDESC7] nVarchar(Max) ;
 GO 
ALTER TABLE [dbo].[RATECON_M7] ALTER COLUMN [VALUEDESC8] nVarchar(Max) ;
 GO 
ALTER TABLE [dbo].[RATECON_M7] ALTER COLUMN [VALUEDESC9] nVarchar(Max) ;
 GO 
ALTER TABLE [dbo].[RATECOV] ALTER COLUMN [DESCRIPTION] nVarchar(255) ;
 GO 
ALTER TABLE [dbo].[RATECOV] ALTER COLUMN [Last_Opr] nVarChar(50) ;
 GO 
ALTER TABLE [dbo].[RateIndemnity] ALTER COLUMN [Last_Opr] nVarChar(50) ;
 GO 
ALTER TABLE [dbo].[RateMin] ALTER COLUMN [Last_Opr] nVarChar(50) ;
 GO 
ALTER TABLE [dbo].[RATETAB] ALTER COLUMN [DESCRIPTION] nVarchar(255) ;
 GO 
ALTER TABLE [dbo].[RATETAB] ALTER COLUMN [Last_Opr] nVarChar(50) ;
 GO 
ALTER TABLE [dbo].[RateTabCla] ALTER COLUMN [DESCRIPTION] nVarchar(max) ;
 GO 
ALTER TABLE [dbo].[RateTabCla] ALTER COLUMN [Description_1] nVarchar(max) ;
 GO 
ALTER TABLE [dbo].[RateTabCla] ALTER COLUMN [SHORTDESC] nVarchar(max) ;
 GO 
ALTER TABLE [dbo].[RateTabCla] ALTER COLUMN [ShortDesc_1] nVarchar(max) ;
 GO 
ALTER TABLE [dbo].[RateTabCon] ALTER COLUMN [DESCRIPTION] nVarchar(max) ;
 GO 
ALTER TABLE [dbo].[RateTabCon] ALTER COLUMN [Description_1] nVarchar(max) ;
 GO 
ALTER TABLE [dbo].[RateTabCon] ALTER COLUMN [SHORTDESC] nVarchar(max) ;
 GO 
ALTER TABLE [dbo].[RateTabCon] ALTER COLUMN [ShortDesc_1] nVarchar(max) ;
 GO 
ALTER TABLE [dbo].[RateTabEx] ALTER COLUMN [DESCRIPTION] nVarchar(max) ;
 GO 
ALTER TABLE [dbo].[RateTabEx] ALTER COLUMN [Description_1] nVarchar(max) ;
 GO 
ALTER TABLE [dbo].[RateTabEx] ALTER COLUMN [SHORTDESC] nVarchar(max) ;
 GO 
ALTER TABLE [dbo].[RateTabEx] ALTER COLUMN [ShortDesc_1] nVarchar(max) ;
 GO 
ALTER TABLE [dbo].[RCLASS] ALTER COLUMN [Last_Opr] nVarChar(50) ;
 GO 
ALTER TABLE [dbo].[RCOVER] ALTER COLUMN [CADDRESS] nVarChar(255) ;
 GO 
ALTER TABLE [dbo].[RCOVER] ALTER COLUMN [LUserID] nVarChar(50) ;
 GO 
ALTER TABLE [dbo].[RCOVER] ALTER COLUMN [REMARK] nVarChar(max) ;
 GO 
ALTER TABLE [dbo].[RDOCLIST] ALTER COLUMN [DESCRIPTION] nVarchar(255) ;
 GO 
ALTER TABLE [dbo].[RDOCLIST] ALTER COLUMN [LAST_OPR] nVarChar(50) ;
 GO 
ALTER TABLE [dbo].[RDOCLIST] ALTER COLUMN [REMARKS] nVarChar(512) ;
 GO 
ALTER TABLE [dbo].[RDOCLISTPIC] ALTER COLUMN [Last_Opr] nVarChar(50) ;
 GO 
ALTER TABLE [dbo].[RDOCLISTPIC] ALTER COLUMN [Remark] nVarchar(Max) ;
 GO 
ALTER TABLE [dbo].[RDOCLISTPIC] ALTER COLUMN [Title] nVarChar(255) ;
 GO 
ALTER TABLE [dbo].[Reason] ALTER COLUMN [Description] nVarchar(100) ;
 GO 
ALTER TABLE [dbo].[Reason] ALTER COLUMN [Last_Opr] nVarChar(50) ;
 GO 
ALTER TABLE [dbo].[Reason] DROP CONSTRAINT [I_Reason];
 GO 
ALTER TABLE [dbo].[Reason] ALTER COLUMN [Reason] nVarChar(10) NOT NULL;
 GO 
ALTER TABLE [dbo].[Reason] WITH NOCHECK ADD CONSTRAINT [I_Reason] PRIMARY KEY NONCLUSTERED( [Reason] ) WITH (ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = OFF) ON [PRIMARY]
 GO 
ALTER TABLE [dbo].[RECLASS] ALTER COLUMN [Last_Opr] nVarChar(50) ;
 GO 
ALTER TABLE [dbo].[ReinsPIC] ALTER COLUMN [Last_Opr] nVarChar(50) ;
 GO 
ALTER TABLE [dbo].[ReinsPIC] ALTER COLUMN [Remark] nVarchar(Max) ;
 GO 
ALTER TABLE [dbo].[ReinsPIC] ALTER COLUMN [Title] nVarChar(255) ;
 GO 
ALTER TABLE [dbo].[REINSURANCE] ALTER COLUMN [DESCRIPTION] nVarchar(255) ;
 GO 
ALTER TABLE [dbo].[REINSURANCE] ALTER COLUMN [Last_Opr] nVarChar(50) ;
 GO 
ALTER TABLE [dbo].[REINSURANCE] ALTER COLUMN [REMARKS] nVarChar(255) ;
 GO 
ALTER TABLE [dbo].[Reminder] ALTER COLUMN [Description] nVarchar(50) ;
 GO 
ALTER TABLE [dbo].[ReminderD] ALTER COLUMN [Last_Opr] nVarChar(50) ;
 GO 
ALTER TABLE [dbo].[ReminderV] ALTER COLUMN [Last_Opr] nVarChar(50) ;
 GO 
ALTER TABLE [dbo].[ReminderV] ALTER COLUMN [Memo] nVarChar(512) ;
 GO 
ALTER TABLE [dbo].[Renewal] ALTER COLUMN [AName] nVarChar(max) ;
 GO 
ALTER TABLE [dbo].[Renewal] ALTER COLUMN [LUserID] nVarChar(50) ;
 GO 
ALTER TABLE [dbo].[Renewal] ALTER COLUMN [Notes] nVarChar(1024) ;
 GO 
ALTER TABLE [dbo].[Renewal] ALTER COLUMN [Reason] nVarChar(10) ;
 GO 
ALTER TABLE [dbo].[Renewal] ALTER COLUMN [USERID] nVarChar(50) ;
 GO 
ALTER TABLE [dbo].[RenewalDA] ALTER COLUMN [Address] nVarChar(255) ;
 GO 
ALTER TABLE [dbo].[RenewalDA] ALTER COLUMN [Attention] nVarChar(255) ;
 GO 
ALTER TABLE [dbo].[RenewalDA] ALTER COLUMN [Email] nVarChar(512) ;
 GO 
ALTER TABLE [dbo].[RenewalRight] ALTER COLUMN [Description] nVarchar(150) ;
 GO 
ALTER TABLE [dbo].[RenewalRight] ALTER COLUMN [Last_Opr] nVarChar(50) ;
 GO 
ALTER TABLE [dbo].[RenewalRight] ALTER COLUMN [Notes] nVarChar(512) ;
 GO 
ALTER TABLE [dbo].[RenewalRule] ALTER COLUMN [Last_Opr] nVarChar(50) ;
 GO 
ALTER TABLE [dbo].[REPOLICY] ALTER COLUMN [Last_Opr] nVarChar(50) ;
 GO 
ALTER TABLE [dbo].[Request] ALTER COLUMN [AcceptedBy] nVarChar(255) ;
 GO 
ALTER TABLE [dbo].[Request] ALTER COLUMN [AUserID] nVarChar(50) ;
 GO 
ALTER TABLE [dbo].[Request] ALTER COLUMN [AUserID_Ext] nVarChar(50) ;
 GO 
ALTER TABLE [dbo].[Request] ALTER COLUMN [BankName] nVarChar(150) ;
 GO 
ALTER TABLE [dbo].[Request] ALTER COLUMN [CUSERID] nVarChar(50) ;
 GO 
ALTER TABLE [dbo].[Request] ALTER COLUMN [Last_Opr] nVarChar(50) ;
 GO 
ALTER TABLE [dbo].[Request] ALTER COLUMN [Otorized2By] nVarChar(10) ;
 GO 
ALTER TABLE [dbo].[Request] ALTER COLUMN [Otorized2ByTitle] nVarChar(100) ;
 GO 
ALTER TABLE [dbo].[Request] ALTER COLUMN [OtorizedBy] nVarChar(10) ;
 GO 
ALTER TABLE [dbo].[Request] ALTER COLUMN [OtorizedByTitle] nVarChar(100) ;
 GO 
ALTER TABLE [dbo].[Request] ALTER COLUMN [Remarks] nVarChar(255) ;
 GO 
ALTER TABLE [dbo].[Request] ALTER COLUMN [RequestMessage] nVarChar(512) ;
 GO 
ALTER TABLE [dbo].[Request] ALTER COLUMN [RequestName] nVarChar(50) ;
 GO 
ALTER TABLE [dbo].[Request] ALTER COLUMN [USERID] nVarChar(50) ;
 GO 
ALTER TABLE [dbo].[Request] ALTER COLUMN [VerifiedBy] nVarChar(10) ;
 GO 
ALTER TABLE [dbo].[Request] ALTER COLUMN [VerifiedByTitle] nVarChar(100) ;
 GO 
ALTER TABLE [dbo].[Request] ALTER COLUMN [VUserID] nVarChar(50) ;
 GO 
ALTER TABLE [dbo].[RequestExt] ALTER COLUMN [Ent_Address] nVarChar(255) ;
 GO 
ALTER TABLE [dbo].[RequestExt] ALTER COLUMN [Last_Opr] nVarChar(50) ;
 GO 
ALTER TABLE [dbo].[RequestPic] ALTER COLUMN [Last_Opr] nVarChar(50) ;
 GO 
ALTER TABLE [dbo].[RequestPic] ALTER COLUMN [Remark] nVarchar(Max) ;
 GO 
ALTER TABLE [dbo].[RequestPic] ALTER COLUMN [Title] nVarChar(255) ;
 GO 
ALTER TABLE [dbo].[RERATE] ALTER COLUMN [Last_Opr] nVarChar(50) ;
 GO 
ALTER TABLE [dbo].[REXCLA] ALTER COLUMN [DESCRIPTION] nVarchar(max) ;
 GO 
ALTER TABLE [dbo].[REXCLA] ALTER COLUMN [SHORTDESC] nVarchar(max) ;
 GO 
ALTER TABLE [dbo].[RISKASS] ALTER COLUMN [Last_Opr] nVarChar(50) ;
 GO 
ALTER TABLE [dbo].[RISKASS] ALTER COLUMN [VALUEDESC1] nVarchar(Max) ;
 GO 
ALTER TABLE [dbo].[RISKASS] ALTER COLUMN [VALUEDESC10] nVarchar(Max) ;
 GO 
ALTER TABLE [dbo].[RISKASS] ALTER COLUMN [VALUEDESC11] nVarchar(Max) ;
 GO 
ALTER TABLE [dbo].[RISKASS] ALTER COLUMN [VALUEDESC12] nVarchar(Max) ;
 GO 
ALTER TABLE [dbo].[RISKASS] ALTER COLUMN [VALUEDESC13] nVarchar(Max) ;
 GO 
ALTER TABLE [dbo].[RISKASS] ALTER COLUMN [VALUEDESC14] nVarchar(Max) ;
 GO 
ALTER TABLE [dbo].[RISKASS] ALTER COLUMN [VALUEDESC15] nVarchar(Max) ;
 GO 
ALTER TABLE [dbo].[RISKASS] ALTER COLUMN [VALUEDESC2] nVarchar(Max) ;
 GO 
ALTER TABLE [dbo].[RISKASS] ALTER COLUMN [VALUEDESC3] nVarchar(Max) ;
 GO 
ALTER TABLE [dbo].[RISKASS] ALTER COLUMN [VALUEDESC4] nVarchar(Max) ;
 GO 
ALTER TABLE [dbo].[RISKASS] ALTER COLUMN [VALUEDESC5] nVarchar(Max) ;
 GO 
ALTER TABLE [dbo].[RISKASS] ALTER COLUMN [VALUEDESC6] nVarchar(Max) ;
 GO 
ALTER TABLE [dbo].[RISKASS] ALTER COLUMN [VALUEDESC7] nVarchar(Max) ;
 GO 
ALTER TABLE [dbo].[RISKASS] ALTER COLUMN [VALUEDESC8] nVarchar(Max) ;
 GO 
ALTER TABLE [dbo].[RISKASS] ALTER COLUMN [VALUEDESC9] nVarchar(Max) ;
 GO 
ALTER TABLE [dbo].[RLTable] ALTER COLUMN [Last_Opr] nVarChar(50) ;
 GO 
ALTER TABLE [dbo].[RLTableC] ALTER COLUMN [Last_Opr] nVarChar(50) ;
 GO 
ALTER TABLE [dbo].[RLTableH] ALTER COLUMN [Description] nVarchar(255) ;
 GO 
ALTER TABLE [dbo].[RLTableH] ALTER COLUMN [Last_Opr] nVarChar(50) ;
 GO 
ALTER TABLE [dbo].[RLTableR] ALTER COLUMN [Last_Opr] nVarChar(50) ;
 GO 
ALTER TABLE [dbo].[RPART] ALTER COLUMN [Last_Opr] nVarChar(50) ;
 GO 
ALTER TABLE [dbo].[RPART] ALTER COLUMN [REMARKS] nVarChar(255) ;
 GO 
ALTER TABLE [dbo].[RPBucket] ALTER COLUMN [BankName] nVarChar(255) ;
 GO 
ALTER TABLE [dbo].[RPBucket] ALTER COLUMN [Last_Opr] nVarChar(50) ;
 GO 
ALTER TABLE [dbo].[RPBucket] ALTER COLUMN [Remarks] nVarChar(512) ;
 GO 
ALTER TABLE [dbo].[RPrintLog] ALTER COLUMN [Description] nVarchar(50) ;
 GO 
ALTER TABLE [dbo].[RPrintLog] ALTER COLUMN [UserID] nVarChar(50) ;
 GO 
DROP INDEX [dbo].[RQPrintLog].[I_RQPrintLog_Request_DocNo_Description];
 GO 
ALTER TABLE [dbo].[RQPrintLog] ALTER COLUMN [Description] nVarchar(50) NOT NULL;
 GO 
CREATE NONCLUSTERED INDEX [I_RQPrintLog_Request_DocNo_Description] ON [dbo].[RQPrintLog] (  [Request] , [DocNo] , [Description] )
 GO 
ALTER TABLE [dbo].[RQPrintLog] ALTER COLUMN [UserID] nVarChar(50) ;
 GO 
ALTER TABLE [dbo].[RTYPE] ALTER COLUMN [Description] nVarchar(20) ;
 GO 
ALTER TABLE [dbo].[SAccCA] ALTER COLUMN [Address] nVarChar(255) ;
 GO 
ALTER TABLE [dbo].[SAccCA] ALTER COLUMN [Attention] nVarChar(255) ;
 GO 
ALTER TABLE [dbo].[SAccCA] ALTER COLUMN [Email] nVarChar(512) ;
 GO 
ALTER TABLE [dbo].[SAccDA] ALTER COLUMN [Address] nVarChar(255) ;
 GO 
ALTER TABLE [dbo].[SAccDA] ALTER COLUMN [Attention] nVarChar(255) ;
 GO 
ALTER TABLE [dbo].[SAccDA] ALTER COLUMN [Email] nVarChar(512) ;
 GO 
ALTER TABLE [dbo].[SAccPic] ALTER COLUMN [Last_Opr] nVarChar(50) ;
 GO 
ALTER TABLE [dbo].[SAccPic] ALTER COLUMN [Remark] nVarchar(Max) ;
 GO 
ALTER TABLE [dbo].[SAccPic] ALTER COLUMN [Title] nVarChar(255) ;
 GO 
ALTER TABLE [dbo].[SAP_FSG_TABLE] ALTER COLUMN [Description] nVarchar(255) ;
 GO 
ALTER TABLE [dbo].[ScaleTab] ALTER COLUMN [Last_Opr] nVarChar(50) ;
 GO 
ALTER TABLE [dbo].[SCGroup] ALTER COLUMN [Description] nVarchar(100) ;
 GO 
ALTER TABLE [dbo].[SCGroup] ALTER COLUMN [Last_Opr] nVarChar(50) ;
 GO 
ALTER TABLE [dbo].[Scheme_Additional] ALTER COLUMN [Last_Opr] nVarChar(50) ;
 GO 
ALTER TABLE [dbo].[Scheme_Assignment] ALTER COLUMN [Description] nVarchar(100) ;
 GO 
ALTER TABLE [dbo].[Scheme_Assignment] ALTER COLUMN [Last_Opr] nVarChar(50) ;
 GO 
ALTER TABLE [dbo].[Scheme_Beneficiary] ALTER COLUMN [Address_1] nVarChar(255) ;
 GO 
ALTER TABLE [dbo].[Scheme_Beneficiary] ALTER COLUMN [Address_2] nVarChar(255) ;
 GO 
ALTER TABLE [dbo].[Scheme_Beneficiary] ALTER COLUMN [REMARK] nVarChar(255) ;
 GO 
ALTER TABLE [dbo].[Scheme_CA] ALTER COLUMN [Address] nVarChar(255) ;
 GO 
ALTER TABLE [dbo].[Scheme_CA] ALTER COLUMN [Attention] nVarChar(255) ;
 GO 
ALTER TABLE [dbo].[Scheme_CA] ALTER COLUMN [Email] nVarChar(512) ;
 GO 
ALTER TABLE [dbo].[Scheme_Cla] ALTER COLUMN [DESCRIPTION] nVarchar(max) ;
 GO 
ALTER TABLE [dbo].[Scheme_Cla] ALTER COLUMN [Description_1] nVarchar(max) ;
 GO 
ALTER TABLE [dbo].[Scheme_Cla] ALTER COLUMN [SHORTDESC] nVarchar(max) ;
 GO 
ALTER TABLE [dbo].[Scheme_Cla] ALTER COLUMN [ShortDesc_1] nVarchar(max) ;
 GO 
ALTER TABLE [dbo].[Scheme_Class] DROP CONSTRAINT [I_Scheme_Class_SchemeNo_Description];
 GO 
DROP INDEX [dbo].[Scheme_Class].[I_Scheme_Class_Description];
 GO 
ALTER TABLE [dbo].[Scheme_Class] ALTER COLUMN [Description] nVarchar(100) ;
 GO 
ALTER TABLE [dbo].[Scheme_Class] ADD CONSTRAINT [I_Scheme_Class_SchemeNo_Description] UNIQUE( [SchemeNo] , [Description] ) WITH (ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = OFF) ON [PRIMARY]
 GO 
CREATE NONCLUSTERED INDEX [I_Scheme_Class_Description] ON [dbo].[Scheme_Class] (  [Description] )
 GO 
ALTER TABLE [dbo].[Scheme_Class] ALTER COLUMN [Last_Opr] nVarChar(50) ;
 GO 
ALTER TABLE [dbo].[Scheme_Class] ALTER COLUMN [VALUEDESC1] nVarchar(Max) ;
 GO 
ALTER TABLE [dbo].[Scheme_Class] ALTER COLUMN [VALUEDESC10] nVarchar(Max) ;
 GO 
ALTER TABLE [dbo].[Scheme_Class] ALTER COLUMN [VALUEDESC11] nVarchar(Max) ;
 GO 
ALTER TABLE [dbo].[Scheme_Class] ALTER COLUMN [VALUEDESC12] nVarchar(Max) ;
 GO 
ALTER TABLE [dbo].[Scheme_Class] ALTER COLUMN [VALUEDESC13] nVarchar(Max) ;
 GO 
ALTER TABLE [dbo].[Scheme_Class] ALTER COLUMN [VALUEDESC14] nVarchar(Max) ;
 GO 
ALTER TABLE [dbo].[Scheme_Class] ALTER COLUMN [VALUEDESC15] nVarchar(Max) ;
 GO 
ALTER TABLE [dbo].[Scheme_Class] ALTER COLUMN [VALUEDESC2] nVarchar(Max) ;
 GO 
ALTER TABLE [dbo].[Scheme_Class] ALTER COLUMN [VALUEDESC3] nVarchar(Max) ;
 GO 
ALTER TABLE [dbo].[Scheme_Class] ALTER COLUMN [VALUEDESC4] nVarchar(Max) ;
 GO 
ALTER TABLE [dbo].[Scheme_Class] ALTER COLUMN [VALUEDESC5] nVarchar(Max) ;
 GO 
ALTER TABLE [dbo].[Scheme_Class] ALTER COLUMN [VALUEDESC6] nVarchar(Max) ;
 GO 
ALTER TABLE [dbo].[Scheme_Class] ALTER COLUMN [VALUEDESC7] nVarchar(Max) ;
 GO 
ALTER TABLE [dbo].[Scheme_Class] ALTER COLUMN [VALUEDESC8] nVarchar(Max) ;
 GO 
ALTER TABLE [dbo].[Scheme_Class] ALTER COLUMN [VALUEDESC9] nVarchar(Max) ;
 GO 
ALTER TABLE [dbo].[Scheme_Con] ALTER COLUMN [DESCRIPTION] nVarchar(max) ;
 GO 
ALTER TABLE [dbo].[Scheme_Con] ALTER COLUMN [Description_1] nVarchar(max) ;
 GO 
ALTER TABLE [dbo].[Scheme_Con] ALTER COLUMN [SHORTDESC] nVarchar(max) ;
 GO 
ALTER TABLE [dbo].[Scheme_Con] ALTER COLUMN [ShortDesc_1] nVarchar(max) ;
 GO 
ALTER TABLE [dbo].[Scheme_Coverage] ALTER COLUMN [Last_Opr] nVarChar(50) ;
 GO 
ALTER TABLE [dbo].[Scheme_CoverageType] ALTER COLUMN [Last_Opr] nVarChar(50) ;
 GO 
ALTER TABLE [dbo].[Scheme_Deductible] ALTER COLUMN [Last_Opr] nVarChar(50) ;
 GO 
ALTER TABLE [dbo].[Scheme_Deductible] ALTER COLUMN [REMARKS] nVarChar(2048) ;
 GO 
ALTER TABLE [dbo].[Scheme_Deductible] ALTER COLUMN [REMARKS_1] nVarChar(2048) ;
 GO 
ALTER TABLE [dbo].[Scheme_Detail] DROP CONSTRAINT [I_Scheme_Detail];
 GO 
ALTER TABLE [dbo].[Scheme_Detail] ALTER COLUMN [DESCRIPTION] nVarchar(255) NOT NULL;
 GO 
ALTER TABLE [dbo].[Scheme_Detail] WITH NOCHECK ADD CONSTRAINT [I_Scheme_Detail] PRIMARY KEY NONCLUSTERED( [TrNo] , [IntNo] , [DESCRIPTION] ) WITH (ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = OFF) ON [PRIMARY]
 GO 
ALTER TABLE [dbo].[Scheme_Detail] ALTER COLUMN [MEMO] nVarchar(Max) ;
 GO 
ALTER TABLE [dbo].[Scheme_Endorsement] ALTER COLUMN [Last_Opr] nVarChar(50) ;
 GO 
ALTER TABLE [dbo].[Scheme_Ex] ALTER COLUMN [DESCRIPTION] nVarchar(max) ;
 GO 
ALTER TABLE [dbo].[Scheme_Ex] ALTER COLUMN [Description_1] nVarchar(max) ;
 GO 
ALTER TABLE [dbo].[Scheme_Ex] ALTER COLUMN [SHORTDESC] nVarchar(max) ;
 GO 
ALTER TABLE [dbo].[Scheme_Ex] ALTER COLUMN [ShortDesc_1] nVarchar(max) ;
 GO 
ALTER TABLE [dbo].[Scheme_Indemnity] ALTER COLUMN [Last_Opr] nVarChar(50) ;
 GO 
ALTER TABLE [dbo].[SCHEME_INPARTY] ALTER COLUMN [Address_1] nVarChar(255) ;
 GO 
ALTER TABLE [dbo].[SCHEME_INPARTY] ALTER COLUMN [Address_2] nVarChar(255) ;
 GO 
ALTER TABLE [dbo].[SCHEME_INPARTY] ALTER COLUMN [REMARK] nVarChar(255) ;
 GO 
ALTER TABLE [dbo].[Scheme_Interest] ALTER COLUMN [Last_Opr] nVarChar(50) ;
 GO 
ALTER TABLE [dbo].[Scheme_InterestType] ALTER COLUMN [Last_Opr] nVarChar(50) ;
 GO 
ALTER TABLE [dbo].[Scheme_Master] ALTER COLUMN [Description] nVarchar(100) ;
 GO 
ALTER TABLE [dbo].[Scheme_Master] ALTER COLUMN [Last_Opr] nVarChar(50) ;
 GO 
ALTER TABLE [dbo].[Scheme_Payor] ALTER COLUMN [ADDRESS_1] nVarChar(255) ;
 GO 
ALTER TABLE [dbo].[Scheme_Payor] ALTER COLUMN [ADDRESS_2] nVarChar(255) ;
 GO 
ALTER TABLE [dbo].[Scheme_Payor] ALTER COLUMN [ADDRESS_3] nVarChar(255) ;
 GO 
ALTER TABLE [dbo].[Scheme_Payor] ALTER COLUMN [BankName] nVarChar(150) ;
 GO 
ALTER TABLE [dbo].[Scheme_Payor] ALTER COLUMN [LUserID] nVarChar(50) ;
 GO 
ALTER TABLE [dbo].[Scheme_Transaction] ALTER COLUMN [ADDINTERESTREMARK1] nVarChar(Max) ;
 GO 
ALTER TABLE [dbo].[Scheme_Transaction] ALTER COLUMN [ADDINTERESTREMARK2] nVarChar(Max) ;
 GO 
ALTER TABLE [dbo].[Scheme_Transaction] ALTER COLUMN [ADDINTERESTREMARK3] nVarChar(Max) ;
 GO 
ALTER TABLE [dbo].[Scheme_Transaction] ALTER COLUMN [ADDINTERESTREMARK4] nVarChar(Max) ;
 GO 
ALTER TABLE [dbo].[Scheme_Transaction] ALTER COLUMN [ADDINTERESTREMARK5] nVarChar(Max) ;
 GO 
ALTER TABLE [dbo].[Scheme_Transaction] ALTER COLUMN [Address] nVarChar(255) ;
 GO 
ALTER TABLE [dbo].[Scheme_Transaction] ALTER COLUMN [AName] nVarChar(max) ;
 GO 
ALTER TABLE [dbo].[Scheme_Transaction] ALTER COLUMN [Attention] nVarChar(255) ;
 GO 
ALTER TABLE [dbo].[Scheme_Transaction] ALTER COLUMN [Correspondence_Address] nVarChar(255) ;
 GO 
ALTER TABLE [dbo].[Scheme_Transaction] ALTER COLUMN [Correspondence_Email] nVarChar(50) ;
 GO 
ALTER TABLE [dbo].[Scheme_Transaction] ALTER COLUMN [CUSERID] nVarChar(50) ;
 GO 
ALTER TABLE [dbo].[Scheme_Transaction] ALTER COLUMN [Email] nVarChar(512) ;
 GO 
ALTER TABLE [dbo].[Scheme_Transaction] ALTER COLUMN [EXTRA_1] nVarChar(50) ;
 GO 
ALTER TABLE [dbo].[Scheme_Transaction] ALTER COLUMN [EXTRA_2] nVarChar(50) ;
 GO 
ALTER TABLE [dbo].[Scheme_Transaction] ALTER COLUMN [EXTRA_3] nVarChar(50) ;
 GO 
ALTER TABLE [dbo].[Scheme_Transaction] ALTER COLUMN [EXTRA_4] nVarChar(50) ;
 GO 
ALTER TABLE [dbo].[Scheme_Transaction] ALTER COLUMN [EXTRA_5] nVarChar(50) ;
 GO 
ALTER TABLE [dbo].[Scheme_Transaction] ALTER COLUMN [LOCATION] nVarChar(100) ;
 GO 
ALTER TABLE [dbo].[Scheme_Transaction] ALTER COLUMN [LUserID] nVarChar(50) ;
 GO 
ALTER TABLE [dbo].[Scheme_Transaction] ALTER COLUMN [MEMO] nVarChar(Max) ;
 GO 
ALTER TABLE [dbo].[Scheme_Transaction] ALTER COLUMN [REASON] nVarChar(10) ;
 GO 
ALTER TABLE [dbo].[Scheme_Transaction] ALTER COLUMN [REMARKS] nVarChar(255) ;
 GO 
ALTER TABLE [dbo].[Scheme_Transaction] ALTER COLUMN [RUSERID] nVarChar(50) ;
 GO 
ALTER TABLE [dbo].[Scheme_Transaction] ALTER COLUMN [VALUEDESC] nVarchar(Max) ;
 GO 
ALTER TABLE [dbo].[Scheme_Transaction] ALTER COLUMN [VALUEDESC1] nVarchar(Max) ;
 GO 
ALTER TABLE [dbo].[Scheme_Transaction] ALTER COLUMN [VALUEDESC10] nVarchar(Max) ;
 GO 
ALTER TABLE [dbo].[Scheme_Transaction] ALTER COLUMN [VALUEDESC11] nVarchar(Max) ;
 GO 
ALTER TABLE [dbo].[Scheme_Transaction] ALTER COLUMN [VALUEDESC12] nVarchar(Max) ;
 GO 
ALTER TABLE [dbo].[Scheme_Transaction] ALTER COLUMN [VALUEDESC13] nVarchar(Max) ;
 GO 
ALTER TABLE [dbo].[Scheme_Transaction] ALTER COLUMN [VALUEDESC14] nVarchar(Max) ;
 GO 
ALTER TABLE [dbo].[Scheme_Transaction] ALTER COLUMN [VALUEDESC15] nVarchar(Max) ;
 GO 
ALTER TABLE [dbo].[Scheme_Transaction] ALTER COLUMN [VALUEDESC16] nVarchar(Max) ;
 GO 
ALTER TABLE [dbo].[Scheme_Transaction] ALTER COLUMN [VALUEDESC17] nVarchar(Max) ;
 GO 
ALTER TABLE [dbo].[Scheme_Transaction] ALTER COLUMN [VALUEDESC18] nVarchar(Max) ;
 GO 
ALTER TABLE [dbo].[Scheme_Transaction] ALTER COLUMN [VALUEDESC19] nVarchar(Max) ;
 GO 
ALTER TABLE [dbo].[Scheme_Transaction] ALTER COLUMN [VALUEDESC2] nVarchar(Max) ;
 GO 
ALTER TABLE [dbo].[Scheme_Transaction] ALTER COLUMN [VALUEDESC20] nVarchar(Max) ;
 GO 
ALTER TABLE [dbo].[Scheme_Transaction] ALTER COLUMN [VALUEDESC21] nVarchar(Max) ;
 GO 
ALTER TABLE [dbo].[Scheme_Transaction] ALTER COLUMN [VALUEDESC22] nVarchar(Max) ;
 GO 
ALTER TABLE [dbo].[Scheme_Transaction] ALTER COLUMN [VALUEDESC23] nVarchar(Max) ;
 GO 
ALTER TABLE [dbo].[Scheme_Transaction] ALTER COLUMN [VALUEDESC24] nVarchar(Max) ;
 GO 
ALTER TABLE [dbo].[Scheme_Transaction] ALTER COLUMN [VALUEDESC25] nVarchar(Max) ;
 GO 
ALTER TABLE [dbo].[Scheme_Transaction] ALTER COLUMN [VALUEDESC26] nVarchar(Max) ;
 GO 
ALTER TABLE [dbo].[Scheme_Transaction] ALTER COLUMN [VALUEDESC27] nVarchar(Max) ;
 GO 
ALTER TABLE [dbo].[Scheme_Transaction] ALTER COLUMN [VALUEDESC28] nVarchar(Max) ;
 GO 
ALTER TABLE [dbo].[Scheme_Transaction] ALTER COLUMN [VALUEDESC29] nVarchar(Max) ;
 GO 
ALTER TABLE [dbo].[Scheme_Transaction] ALTER COLUMN [VALUEDESC3] nVarchar(Max) ;
 GO 
ALTER TABLE [dbo].[Scheme_Transaction] ALTER COLUMN [VALUEDESC30] nVarchar(Max) ;
 GO 
ALTER TABLE [dbo].[Scheme_Transaction] ALTER COLUMN [VALUEDESC4] nVarchar(Max) ;
 GO 
ALTER TABLE [dbo].[Scheme_Transaction] ALTER COLUMN [VALUEDESC5] nVarchar(Max) ;
 GO 
ALTER TABLE [dbo].[Scheme_Transaction] ALTER COLUMN [VALUEDESC6] nVarchar(Max) ;
 GO 
ALTER TABLE [dbo].[Scheme_Transaction] ALTER COLUMN [VALUEDESC7] nVarchar(Max) ;
 GO 
ALTER TABLE [dbo].[Scheme_Transaction] ALTER COLUMN [VALUEDESC8] nVarchar(Max) ;
 GO 
ALTER TABLE [dbo].[Scheme_Transaction] ALTER COLUMN [VALUEDESC9] nVarchar(Max) ;
 GO 
ALTER TABLE [dbo].[Scheme_TransactionDet] DROP CONSTRAINT [I_Scheme_TransactionDet];
 GO 
ALTER TABLE [dbo].[Scheme_TransactionDet] ALTER COLUMN [DESCRIPTION] nVarchar(255) NOT NULL;
 GO 
ALTER TABLE [dbo].[Scheme_TransactionDet] WITH NOCHECK ADD CONSTRAINT [I_Scheme_TransactionDet] PRIMARY KEY NONCLUSTERED( [TrNo] , [DESCRIPTION] ) WITH (ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = OFF) ON [PRIMARY]
 GO 
ALTER TABLE [dbo].[Scoring] ALTER COLUMN [DESCRIPTION] nVarchar(255) ;
 GO 
ALTER TABLE [dbo].[Scoring] ALTER COLUMN [LAST_OPR] nVarChar(50) ;
 GO 
ALTER TABLE [dbo].[ScoringV] DROP CONSTRAINT [I_ScoringV];
 GO 
ALTER TABLE [dbo].[ScoringV] ALTER COLUMN [Description] nVarchar(255) NOT NULL;
 GO 
ALTER TABLE [dbo].[ScoringV] WITH NOCHECK ADD CONSTRAINT [I_ScoringV] PRIMARY KEY NONCLUSTERED( [SID] , [Description] ) WITH (ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = OFF) ON [PRIMARY]
 GO 
ALTER TABLE [dbo].[ScoringV] ALTER COLUMN [LAST_OPR] nVarChar(50) ;
 GO 
ALTER TABLE [dbo].[SECTION] ALTER COLUMN [DESCRIPTION] nVarchar(max) ;
 GO 
ALTER TABLE [dbo].[SECTION] ALTER COLUMN [Last_Opr] nVarChar(50) ;
 GO 
ALTER TABLE [dbo].[SECTION] ALTER COLUMN [SHORTDESC] nVarchar(255) ;
 GO 
ALTER TABLE [dbo].[Security] ALTER COLUMN [Last_Opr] nVarChar(50) ;
 GO 
ALTER TABLE [dbo].[Security] ALTER COLUMN [REMARKS] nVarChar(255) ;
 GO 
ALTER TABLE [dbo].[Segment] ALTER COLUMN [Description] nVarchar(255) ;
 GO 
ALTER TABLE [dbo].[Segment] ALTER COLUMN [Last_Opr] nVarChar(50) ;
 GO 
ALTER TABLE [dbo].[SEGMENTGROUP] ALTER COLUMN [DESCRIPTION] nVarchar(100) ;
 GO 
ALTER TABLE [dbo].[SEGMENTGROUP] ALTER COLUMN [Last_Opr] nVarChar(50) ;
 GO 
ALTER TABLE [dbo].[Service] ALTER COLUMN [Address_1] nVarChar(255) ;
 GO 
ALTER TABLE [dbo].[Service] ALTER COLUMN [Address_2] nVarChar(255) ;
 GO 
ALTER TABLE [dbo].[Service] ALTER COLUMN [AUSERID] nVarChar(50) ;
 GO 
ALTER TABLE [dbo].[Service] ALTER COLUMN [Comment] nVarChar(max) ;
 GO 
ALTER TABLE [dbo].[Service] ALTER COLUMN [CUSERID] nVarChar(50) ;
 GO 
ALTER TABLE [dbo].[Service] ALTER COLUMN [INSURED] nVarChar(max) ;
 GO 
ALTER TABLE [dbo].[Service] ALTER COLUMN [LUSERID] nVarChar(50) ;
 GO 
ALTER TABLE [dbo].[Service] ALTER COLUMN [Memo] nVarChar(max) ;
 GO 
ALTER TABLE [dbo].[Service] ALTER COLUMN [PIC_NAME_1] nVarChar(50) ;
 GO 
ALTER TABLE [dbo].[Service] ALTER COLUMN [PIC_NAME_2] nVarChar(50) ;
 GO 
ALTER TABLE [dbo].[Service] ALTER COLUMN [PIC_NAME_3] nVarChar(50) ;
 GO 
ALTER TABLE [dbo].[Service] ALTER COLUMN [PIC_TITLE_1] nVarChar(255) ;
 GO 
ALTER TABLE [dbo].[Service] ALTER COLUMN [PIC_TITLE_2] nVarChar(255) ;
 GO 
ALTER TABLE [dbo].[Service] ALTER COLUMN [PIC_TITLE_3] nVarChar(255) ;
 GO 
ALTER TABLE [dbo].[Service] ALTER COLUMN [PUserID] nVarChar(50) ;
 GO 
ALTER TABLE [dbo].[Service] ALTER COLUMN [REMARKS] nVarChar(255) ;
 GO 
ALTER TABLE [dbo].[Service] ALTER COLUMN [RequestMessage] nVarChar(Max) ;
 GO 
ALTER TABLE [dbo].[Service] ALTER COLUMN [RequestName] nVarChar(50) ;
 GO 
ALTER TABLE [dbo].[Service] ALTER COLUMN [RUserID] nVarChar(50) ;
 GO 
ALTER TABLE [dbo].[Service] ALTER COLUMN [USERID] nVarChar(50) ;
 GO 
ALTER TABLE [dbo].[Service] ALTER COLUMN [VALUEDESC] nVarchar(Max) ;
 GO 
ALTER TABLE [dbo].[SINFO] ALTER COLUMN [VALUEDESC1] nVarchar(max) ;
 GO 
ALTER TABLE [dbo].[SINFO] ALTER COLUMN [VALUEDESC10] nVarchar(max) ;
 GO 
ALTER TABLE [dbo].[SINFO] ALTER COLUMN [VALUEDESC11] nVarchar(max) ;
 GO 
ALTER TABLE [dbo].[SINFO] ALTER COLUMN [VALUEDESC12] nVarchar(max) ;
 GO 
ALTER TABLE [dbo].[SINFO] ALTER COLUMN [VALUEDESC13] nVarchar(max) ;
 GO 
ALTER TABLE [dbo].[SINFO] ALTER COLUMN [VALUEDESC14] nVarchar(max) ;
 GO 
ALTER TABLE [dbo].[SINFO] ALTER COLUMN [VALUEDESC15] nVarchar(max) ;
 GO 
ALTER TABLE [dbo].[SINFO] ALTER COLUMN [VALUEDESC2] nVarchar(max) ;
 GO 
ALTER TABLE [dbo].[SINFO] ALTER COLUMN [VALUEDESC3] nVarchar(max) ;
 GO 
ALTER TABLE [dbo].[SINFO] ALTER COLUMN [VALUEDESC4] nVarchar(max) ;
 GO 
ALTER TABLE [dbo].[SINFO] ALTER COLUMN [VALUEDESC5] nVarchar(max) ;
 GO 
ALTER TABLE [dbo].[SINFO] ALTER COLUMN [VALUEDESC6] nVarchar(max) ;
 GO 
ALTER TABLE [dbo].[SINFO] ALTER COLUMN [VALUEDESC7] nVarchar(max) ;
 GO 
ALTER TABLE [dbo].[SINFO] ALTER COLUMN [VALUEDESC8] nVarchar(max) ;
 GO 
ALTER TABLE [dbo].[SINFO] ALTER COLUMN [VALUEDESC9] nVarchar(max) ;
 GO 
ALTER TABLE [dbo].[SL_Cat] ALTER COLUMN [Description] nVarchar(30) ;
 GO 
ALTER TABLE [dbo].[SL_Request] ALTER COLUMN [Description] nVarchar(512) ;
 GO 
ALTER TABLE [dbo].[SL_Request] ALTER COLUMN [Remarks] nVarChar(4000) ;
 GO 
ALTER TABLE [dbo].[SL_RequestRef] ALTER COLUMN [Description] nVarchar(50) NOT NULL;
 GO 
ALTER TABLE [dbo].[SOV] ALTER COLUMN [AComment] nVarChar(510) ;
 GO 
ALTER TABLE [dbo].[SOV] ALTER COLUMN [Description] nVarchar(510) ;
 GO 
ALTER TABLE [dbo].[SPayor] ALTER COLUMN [ADDRESS_1] nVarChar(255) ;
 GO 
ALTER TABLE [dbo].[SPayor] ALTER COLUMN [ADDRESS_2] nVarChar(255) ;
 GO 
ALTER TABLE [dbo].[SPayor] ALTER COLUMN [ADDRESS_3] nVarChar(255) ;
 GO 
ALTER TABLE [dbo].[SPayor] ALTER COLUMN [BankName] nVarChar(150) ;
 GO 
ALTER TABLE [dbo].[SPrintLog] ALTER COLUMN [Description] nVarchar(50) ;
 GO 
ALTER TABLE [dbo].[SPrintLog] ALTER COLUMN [UserID] nVarChar(50) ;
 GO 
ALTER TABLE [dbo].[SubDistrict] ALTER COLUMN [Description] nVarchar(200) ;
 GO 
ALTER TABLE [dbo].[SubDistrict] ALTER COLUMN [Description_1] nVarchar(200) ;
 GO 
ALTER TABLE [dbo].[SubDistrict] ALTER COLUMN [Last_OPR] nVarChar(50) ;
 GO 
ALTER TABLE [dbo].[SURVEYOR] ALTER COLUMN [COMMENT] nVarChar(Max) ;
 GO 
ALTER TABLE [dbo].[SURVEYOR] ALTER COLUMN [REMARKS] nVarChar(255) ;
 GO 
ALTER TABLE [dbo].[SysBatchBC] ALTER COLUMN [DUTY_REMARK] nVarChar(510) ;
 GO 
ALTER TABLE [dbo].[SysBatchBC] ALTER COLUMN [Extra_1] nVarChar(100) ;
 GO 
ALTER TABLE [dbo].[SysBatchBC] ALTER COLUMN [Extra_2] nVarChar(100) ;
 GO 
ALTER TABLE [dbo].[SysBatchBC] ALTER COLUMN [Extra_3] nVarChar(100) ;
 GO 
ALTER TABLE [dbo].[SysBatchBC] ALTER COLUMN [Extra_4] nVarChar(100) ;
 GO 
ALTER TABLE [dbo].[SysBatchBC] ALTER COLUMN [Extra_5] nVarChar(100) ;
 GO 
ALTER TABLE [dbo].[SysBatchBC] ALTER COLUMN [FEE_REMARK] nVarChar(510) ;
 GO 
ALTER TABLE [dbo].[SysBatchBC] ALTER COLUMN [INSURED] nVarChar(1024) ;
 GO 
ALTER TABLE [dbo].[SysBatchBC] ALTER COLUMN [REMARKS] nVarChar(510) ;
 GO 
ALTER TABLE [dbo].[SysBatchBE] ALTER COLUMN [ADDCOVERAGEREMARK1] nVarChar(510) ;
 GO 
ALTER TABLE [dbo].[SysBatchBE] ALTER COLUMN [ADDCOVERAGEREMARK2] nVarChar(510) ;
 GO 
ALTER TABLE [dbo].[SysBatchBE] ALTER COLUMN [ADDCOVERAGEREMARK3] nVarChar(510) ;
 GO 
ALTER TABLE [dbo].[SysBatchBE] ALTER COLUMN [ADDCOVERAGEREMARK4] nVarChar(510) ;
 GO 
ALTER TABLE [dbo].[SysBatchBE] ALTER COLUMN [ADDCOVERAGEREMARK5] nVarChar(510) ;
 GO 
ALTER TABLE [dbo].[SysBatchBE] ALTER COLUMN [ADDCOVERAGEREMARK6] VarChar(255) ;
 GO 
ALTER TABLE [dbo].[SysBatchBE] ALTER COLUMN [ADDCOVERAGEREMARK7] VarChar(255) ;
 GO 
ALTER TABLE [dbo].[SysBatchBE] ALTER COLUMN [Correspondence_Address] nVarChar(510) ;
 GO 
ALTER TABLE [dbo].[SysBatchBE] ALTER COLUMN [Correspondence_Email] nVarChar(100) ;
 GO 
ALTER TABLE [dbo].[SysBatchBE] ALTER COLUMN [DUTY_REMARK] nVarChar(100) ;
 GO 
ALTER TABLE [dbo].[SysBatchBE] ALTER COLUMN [FEE_REMARK] nVarChar(100) ;
 GO 
ALTER TABLE [dbo].[SysBatchBE] ALTER COLUMN [ICoverDetDescription1] nVarChar(510) ;
 GO 
ALTER TABLE [dbo].[SysBatchBE] ALTER COLUMN [ICoverDetDescription2] nVarChar(510) ;
 GO 
ALTER TABLE [dbo].[SysBatchBE] ALTER COLUMN [ICoverDetDescription3] nVarChar(510) ;
 GO 
ALTER TABLE [dbo].[SysBatchBE] ALTER COLUMN [ICoverDetDescription4] nVarChar(510) ;
 GO 
ALTER TABLE [dbo].[SysBatchBE] ALTER COLUMN [ICoverDetDescription5] nVarChar(510) ;
 GO 
ALTER TABLE [dbo].[SysBatchBE] ALTER COLUMN [INSURED] nVarChar(1024) ;
 GO 
ALTER TABLE [dbo].[SysBatchBE] ALTER COLUMN [REMARKS] nVarChar(510) ;
 GO 
ALTER TABLE [dbo].[SysBatchBE] ALTER COLUMN [REMARKS1] nVarChar(510) ;
 GO 
ALTER TABLE [dbo].[SysBatchBE] ALTER COLUMN [REMARKS2] nVarChar(510) ;
 GO 
ALTER TABLE [dbo].[SysBatchBE] ALTER COLUMN [REMARKS3] nVarChar(510) ;
 GO 
ALTER TABLE [dbo].[SysBatchBE] ALTER COLUMN [REMARKS4] nVarChar(510) ;
 GO 
ALTER TABLE [dbo].[SysBatchBE] ALTER COLUMN [REMARKS5] nVarChar(510) ;
 GO 
ALTER TABLE [dbo].[SysBatchOriginalBC] ALTER COLUMN [Comment] nVarChar(510) ;
 GO 
ALTER TABLE [dbo].[SysBatchOriginalBC] ALTER COLUMN [DUTY_REMARK] nVarChar(510) ;
 GO 
ALTER TABLE [dbo].[SysBatchOriginalBC] ALTER COLUMN [Extra_1] nVarChar(100) ;
 GO 
ALTER TABLE [dbo].[SysBatchOriginalBC] ALTER COLUMN [Extra_2] nVarChar(100) ;
 GO 
ALTER TABLE [dbo].[SysBatchOriginalBC] ALTER COLUMN [Extra_3] nVarChar(100) ;
 GO 
ALTER TABLE [dbo].[SysBatchOriginalBC] ALTER COLUMN [Extra_4] nVarChar(100) ;
 GO 
ALTER TABLE [dbo].[SysBatchOriginalBC] ALTER COLUMN [Extra_5] nVarChar(100) ;
 GO 
ALTER TABLE [dbo].[SysBatchOriginalBC] ALTER COLUMN [FEE_REMARK] nVarChar(510) ;
 GO 
ALTER TABLE [dbo].[SysBatchOriginalBC] ALTER COLUMN [INSURED] nVarChar(1024) ;
 GO 
ALTER TABLE [dbo].[SysBatchOriginalBC] ALTER COLUMN [REMARKS] nVarChar(510) ;
 GO 
ALTER TABLE [dbo].[SysBatchOriginalBE] ALTER COLUMN [ADDCOVERAGEREMARK1] nVarChar(510) ;
 GO 
ALTER TABLE [dbo].[SysBatchOriginalBE] ALTER COLUMN [ADDCOVERAGEREMARK2] nVarChar(510) ;
 GO 
ALTER TABLE [dbo].[SysBatchOriginalBE] ALTER COLUMN [ADDCOVERAGEREMARK3] nVarChar(510) ;
 GO 
ALTER TABLE [dbo].[SysBatchOriginalBE] ALTER COLUMN [ADDCOVERAGEREMARK4] nVarChar(510) ;
 GO 
ALTER TABLE [dbo].[SysBatchOriginalBE] ALTER COLUMN [ADDCOVERAGEREMARK5] nVarChar(510) ;
 GO 
ALTER TABLE [dbo].[SysBatchOriginalBE] ALTER COLUMN [ADDCOVERAGEREMARK6] VarChar(255) ;
 GO 
ALTER TABLE [dbo].[SysBatchOriginalBE] ALTER COLUMN [ADDCOVERAGEREMARK7] VarChar(255) ;
 GO 
ALTER TABLE [dbo].[SysBatchOriginalBE] ALTER COLUMN [ADDSUMINSURED1] nVarChar(60) ;
 GO 
ALTER TABLE [dbo].[SysBatchOriginalBE] ALTER COLUMN [ADDSUMINSURED2] nVarChar(60) ;
 GO 
ALTER TABLE [dbo].[SysBatchOriginalBE] ALTER COLUMN [ADDSUMINSURED3] nVarChar(60) ;
 GO 
ALTER TABLE [dbo].[SysBatchOriginalBE] ALTER COLUMN [ADDSUMINSURED4] nVarChar(60) ;
 GO 
ALTER TABLE [dbo].[SysBatchOriginalBE] ALTER COLUMN [ADDSUMINSURED5] nVarChar(60) ;
 GO 
ALTER TABLE [dbo].[SysBatchOriginalBE] ALTER COLUMN [Correspondence_Address] nVarChar(510) ;
 GO 
ALTER TABLE [dbo].[SysBatchOriginalBE] ALTER COLUMN [Correspondence_Email] nVarChar(100) ;
 GO 
ALTER TABLE [dbo].[SysBatchOriginalBE] ALTER COLUMN [DUTY_REMARK] nVarChar(100) ;
 GO 
ALTER TABLE [dbo].[SysBatchOriginalBE] ALTER COLUMN [FEE_REMARK] nVarChar(100) ;
 GO 
ALTER TABLE [dbo].[SysBatchOriginalBE] ALTER COLUMN [ICoverDetDescription1] nVarChar(510) ;
 GO 
ALTER TABLE [dbo].[SysBatchOriginalBE] ALTER COLUMN [ICoverDetDescription2] nVarChar(510) ;
 GO 
ALTER TABLE [dbo].[SysBatchOriginalBE] ALTER COLUMN [ICoverDetDescription3] nVarChar(510) ;
 GO 
ALTER TABLE [dbo].[SysBatchOriginalBE] ALTER COLUMN [ICoverDetDescription4] nVarChar(510) ;
 GO 
ALTER TABLE [dbo].[SysBatchOriginalBE] ALTER COLUMN [ICoverDetDescription5] nVarChar(510) ;
 GO 
ALTER TABLE [dbo].[SysBatchOriginalBE] ALTER COLUMN [INSURED] nVarChar(1024) ;
 GO 
ALTER TABLE [dbo].[SysBatchOriginalBE] ALTER COLUMN [REMARKS] nVarChar(510) ;
 GO 
ALTER TABLE [dbo].[SysBatchOriginalBE] ALTER COLUMN [REMARKS1] nVarChar(510) ;
 GO 
ALTER TABLE [dbo].[SysBatchOriginalBE] ALTER COLUMN [REMARKS2] nVarChar(510) ;
 GO 
ALTER TABLE [dbo].[SysBatchOriginalBE] ALTER COLUMN [REMARKS3] nVarChar(510) ;
 GO 
ALTER TABLE [dbo].[SysBatchOriginalBE] ALTER COLUMN [REMARKS4] nVarChar(510) ;
 GO 
ALTER TABLE [dbo].[SysBatchOriginalBE] ALTER COLUMN [REMARKS5] nVarChar(510) ;
 GO 
ALTER TABLE [dbo].[SysBatchOriginalSC] ALTER COLUMN [ADDINTERESTREMARK1] nVarChar(510) ;
 GO 
ALTER TABLE [dbo].[SysBatchOriginalSC] ALTER COLUMN [ADDINTERESTREMARK2] nVarChar(510) ;
 GO 
ALTER TABLE [dbo].[SysBatchOriginalSC] ALTER COLUMN [ADDINTERESTREMARK3] nVarChar(510) ;
 GO 
ALTER TABLE [dbo].[SysBatchOriginalSC] ALTER COLUMN [ADDINTERESTREMARK4] nVarChar(510) ;
 GO 
ALTER TABLE [dbo].[SysBatchOriginalSC] ALTER COLUMN [ADDINTERESTREMARK5] nVarChar(510) ;
 GO 
ALTER TABLE [dbo].[SysBatchOriginalSC] ALTER COLUMN [ADDRESS_1] nVarChar(510) ;
 GO 
ALTER TABLE [dbo].[SysBatchOriginalSC] ALTER COLUMN [ADDRESS_2] nVarChar(510) ;
 GO 
ALTER TABLE [dbo].[SysBatchOriginalSC] ALTER COLUMN [ADDRESS_3] nVarChar(510) ;
 GO 
ALTER TABLE [dbo].[SysBatchOriginalSC] ALTER COLUMN [Correspondence_Address] nVarChar(510) ;
 GO 
ALTER TABLE [dbo].[SysBatchOriginalSC] ALTER COLUMN [Correspondence_Email] nVarChar(100) ;
 GO 
ALTER TABLE [dbo].[SysBatchOriginalSC] ALTER COLUMN [Email] nVarChar(1024) ;
 GO 
ALTER TABLE [dbo].[SysBatchOriginalSC] ALTER COLUMN [Extra_1] nVarChar(100) ;
 GO 
ALTER TABLE [dbo].[SysBatchOriginalSC] ALTER COLUMN [Extra_2] nVarChar(100) ;
 GO 
ALTER TABLE [dbo].[SysBatchOriginalSC] ALTER COLUMN [Extra_3] nVarChar(100) ;
 GO 
ALTER TABLE [dbo].[SysBatchOriginalSC] ALTER COLUMN [Extra_4] nVarChar(100) ;
 GO 
ALTER TABLE [dbo].[SysBatchOriginalSC] ALTER COLUMN [Extra_5] nVarChar(100) ;
 GO 
ALTER TABLE [dbo].[SysBatchOriginalSC] ALTER COLUMN [INSURED] nVarChar(510) ;
 GO 
ALTER TABLE [dbo].[SysBatchOriginalSC] ALTER COLUMN [InsuredF] nVarChar(510) ;
 GO 
ALTER TABLE [dbo].[SysBatchOriginalSC] ALTER COLUMN [location] nVarChar(510) ;
 GO 
ALTER TABLE [dbo].[SysBatchOriginalSC] ALTER COLUMN [MAINSUMINSURED] nVarChar(510) ;
 GO 
ALTER TABLE [dbo].[SysBatchOriginalSC] ALTER COLUMN [MEMO] nVarChar(510) ;
 GO 
ALTER TABLE [dbo].[SysBatchOriginalSC] ALTER COLUMN [SUMINSURED1] nVarChar(510) ;
 GO 
ALTER TABLE [dbo].[SysBatchOriginalSC] ALTER COLUMN [SUMINSURED2] nVarChar(510) ;
 GO 
ALTER TABLE [dbo].[SysBatchOriginalSC] ALTER COLUMN [SUMINSURED3] nVarChar(510) ;
 GO 
ALTER TABLE [dbo].[SysBatchOriginalSC] ALTER COLUMN [SUMINSURED4] nVarChar(510) ;
 GO 
ALTER TABLE [dbo].[SysBatchOriginalSC] ALTER COLUMN [SUMINSURED5] nVarChar(510) ;
 GO 
ALTER TABLE [dbo].[SysBatchOriginalUp] ALTER COLUMN [ADDCOVERAGEREMARK10] nVarChar(510) ;
 GO 
ALTER TABLE [dbo].[SysBatchOriginalUp] ALTER COLUMN [ADDCOVERAGEREMARK6] nVarChar(510) ;
 GO 
ALTER TABLE [dbo].[SysBatchOriginalUp] ALTER COLUMN [ADDCOVERAGEREMARK7] nVarChar(510) ;
 GO 
ALTER TABLE [dbo].[SysBatchOriginalUp] ALTER COLUMN [ADDCOVERAGEREMARK8] nVarChar(510) ;
 GO 
ALTER TABLE [dbo].[SysBatchOriginalUp] ALTER COLUMN [ADDCOVERAGEREMARK9] nVarChar(510) ;
 GO 
ALTER TABLE [dbo].[SysBatchOriginalUp] ALTER COLUMN [ADDINTERESTREMARK10] nVarChar(510) ;
 GO 
ALTER TABLE [dbo].[SysBatchOriginalUp] ALTER COLUMN [ADDINTERESTREMARK6] nVarChar(510) ;
 GO 
ALTER TABLE [dbo].[SysBatchOriginalUp] ALTER COLUMN [ADDINTERESTREMARK7] nVarChar(510) ;
 GO 
ALTER TABLE [dbo].[SysBatchOriginalUp] ALTER COLUMN [ADDINTERESTREMARK8] nVarChar(510) ;
 GO 
ALTER TABLE [dbo].[SysBatchOriginalUp] ALTER COLUMN [ADDINTERESTREMARK9] nVarChar(510) ;
 GO 
ALTER TABLE [dbo].[SysBatchOriginalUp] ALTER COLUMN [Address_1] nVarChar(510) ;
 GO 
ALTER TABLE [dbo].[SysBatchOriginalUp] ALTER COLUMN [Address_2] nVarChar(510) ;
 GO 
ALTER TABLE [dbo].[SysBatchOriginalUp] ALTER COLUMN [Address_3] nVarChar(510) ;
 GO 
ALTER TABLE [dbo].[SysBatchOriginalUp] ALTER COLUMN [ADDSUMINSURED_OC1] nVarChar(510) ;
 GO 
ALTER TABLE [dbo].[SysBatchOriginalUp] ALTER COLUMN [ADDSUMINSURED_OC10] nVarChar(510) ;
 GO 
ALTER TABLE [dbo].[SysBatchOriginalUp] ALTER COLUMN [ADDSUMINSURED_OC2] nVarChar(510) ;
 GO 
ALTER TABLE [dbo].[SysBatchOriginalUp] ALTER COLUMN [ADDSUMINSURED_OC3] nVarChar(510) ;
 GO 
ALTER TABLE [dbo].[SysBatchOriginalUp] ALTER COLUMN [ADDSUMINSURED_OC4] nVarChar(510) ;
 GO 
ALTER TABLE [dbo].[SysBatchOriginalUp] ALTER COLUMN [ADDSUMINSURED_OC5] nVarChar(510) ;
 GO 
ALTER TABLE [dbo].[SysBatchOriginalUp] ALTER COLUMN [ADDSUMINSURED_OC6] nVarChar(510) ;
 GO 
ALTER TABLE [dbo].[SysBatchOriginalUp] ALTER COLUMN [ADDSUMINSURED_OC7] nVarChar(510) ;
 GO 
ALTER TABLE [dbo].[SysBatchOriginalUp] ALTER COLUMN [ADDSUMINSURED_OC8] nVarChar(510) ;
 GO 
ALTER TABLE [dbo].[SysBatchOriginalUp] ALTER COLUMN [ADDSUMINSURED_OC9] nVarChar(510) ;
 GO 
ALTER TABLE [dbo].[SysBatchOriginalUp] ALTER COLUMN [ADDSUMINSURED1] nVarChar(100) ;
 GO 
ALTER TABLE [dbo].[SysBatchOriginalUp] ALTER COLUMN [ADDSUMINSURED10] nVarChar(100) ;
 GO 
ALTER TABLE [dbo].[SysBatchOriginalUp] ALTER COLUMN [ADDSUMINSURED2] nVarChar(100) ;
 GO 
ALTER TABLE [dbo].[SysBatchOriginalUp] ALTER COLUMN [ADDSUMINSURED3] nVarChar(100) ;
 GO 
ALTER TABLE [dbo].[SysBatchOriginalUp] ALTER COLUMN [ADDSUMINSURED4] nVarChar(100) ;
 GO 
ALTER TABLE [dbo].[SysBatchOriginalUp] ALTER COLUMN [ADDSUMINSURED5] nVarChar(100) ;
 GO 
ALTER TABLE [dbo].[SysBatchOriginalUp] ALTER COLUMN [ADDSUMINSURED6] nVarChar(100) ;
 GO 
ALTER TABLE [dbo].[SysBatchOriginalUp] ALTER COLUMN [ADDSUMINSURED7] nVarChar(100) ;
 GO 
ALTER TABLE [dbo].[SysBatchOriginalUp] ALTER COLUMN [ADDSUMINSURED8] nVarChar(100) ;
 GO 
ALTER TABLE [dbo].[SysBatchOriginalUp] ALTER COLUMN [ADDSUMINSURED9] nVarChar(100) ;
 GO 
ALTER TABLE [dbo].[SysBatchOriginalUp] ALTER COLUMN [beneficiaries_Address1] nVarChar(510) ;
 GO 
ALTER TABLE [dbo].[SysBatchOriginalUp] ALTER COLUMN [beneficiaries_Address2] nVarChar(510) ;
 GO 
ALTER TABLE [dbo].[SysBatchOriginalUp] ALTER COLUMN [beneficiaries_Address3] nVarChar(510) ;
 GO 
ALTER TABLE [dbo].[SysBatchOriginalUp] ALTER COLUMN [CADDRESS] nVarChar(510) ;
 GO 
ALTER TABLE [dbo].[SysBatchOriginalUp] ALTER COLUMN [Correspondence_Address] nVarChar(510) ;
 GO 
ALTER TABLE [dbo].[SysBatchOriginalUp] ALTER COLUMN [Correspondence_Email] nVarChar(100) ;
 GO 
ALTER TABLE [dbo].[SysBatchOriginalUp] ALTER COLUMN [CRefNo] nVarChar(100) ;
 GO 
ALTER TABLE [dbo].[SysBatchOriginalUp] ALTER COLUMN [DeclareDescription] nVarChar(510) ;
 GO 
ALTER TABLE [dbo].[SysBatchOriginalUp] ALTER COLUMN [DUTY_REMARK] nVarChar(100) ;
 GO 
ALTER TABLE [dbo].[SysBatchOriginalUp] ALTER COLUMN [Email] nVarChar(1024) ;
 GO 
ALTER TABLE [dbo].[SysBatchOriginalUp] ALTER COLUMN [FEE_REMARK] nVarChar(100) ;
 GO 
ALTER TABLE [dbo].[SysBatchOriginalUp] ALTER COLUMN [HolderAddress_1] nVarChar(510) ;
 GO 
ALTER TABLE [dbo].[SysBatchOriginalUp] ALTER COLUMN [HolderAddress_2] nVarChar(510) ;
 GO 
ALTER TABLE [dbo].[SysBatchOriginalUp] ALTER COLUMN [HolderAddress_3] nVarChar(510) ;
 GO 
ALTER TABLE [dbo].[SysBatchOriginalUp] ALTER COLUMN [ICoverDetDescription1] nVarChar(510) ;
 GO 
ALTER TABLE [dbo].[SysBatchOriginalUp] ALTER COLUMN [ICoverDetDescription2] nVarChar(510) ;
 GO 
ALTER TABLE [dbo].[SysBatchOriginalUp] ALTER COLUMN [ICoverDetDescription3] nVarChar(510) ;
 GO 
ALTER TABLE [dbo].[SysBatchOriginalUp] ALTER COLUMN [ICoverDetDescription4] nVarChar(510) ;
 GO 
ALTER TABLE [dbo].[SysBatchOriginalUp] ALTER COLUMN [ICoverDetDescription5] nVarChar(510) ;
 GO 
ALTER TABLE [dbo].[SysBatchOriginalUp] ALTER COLUMN [InParty_Address1] nVarChar(510) ;
 GO 
ALTER TABLE [dbo].[SysBatchOriginalUp] ALTER COLUMN [InParty_Address2] nVarChar(510) ;
 GO 
ALTER TABLE [dbo].[SysBatchOriginalUp] ALTER COLUMN [InParty_Address3] nVarChar(510) ;
 GO 
ALTER TABLE [dbo].[SysBatchOriginalUp] ALTER COLUMN [InParty_Address4] nVarChar(510) ;
 GO 
ALTER TABLE [dbo].[SysBatchOriginalUp] ALTER COLUMN [InParty_Remark1] nVarChar(510) ;
 GO 
ALTER TABLE [dbo].[SysBatchOriginalUp] ALTER COLUMN [InParty_Remark2] nVarChar(510) ;
 GO 
ALTER TABLE [dbo].[SysBatchOriginalUp] ALTER COLUMN [InParty_Remark3] nVarChar(510) ;
 GO 
ALTER TABLE [dbo].[SysBatchOriginalUp] ALTER COLUMN [InParty_Remark4] nVarChar(510) ;
 GO 
ALTER TABLE [dbo].[SysBatchOriginalUp] ALTER COLUMN [Insured] nVarChar(1024) ;
 GO 
ALTER TABLE [dbo].[SysBatchOriginalUp] ALTER COLUMN [InsuredAddress_1] nVarChar(510) ;
 GO 
ALTER TABLE [dbo].[SysBatchOriginalUp] ALTER COLUMN [InsuredAddress_2] nVarChar(510) ;
 GO 
ALTER TABLE [dbo].[SysBatchOriginalUp] ALTER COLUMN [InsuredAddress_3] nVarChar(510) ;
 GO 
ALTER TABLE [dbo].[SysBatchOriginalUp] ALTER COLUMN [InsuredID] nVarChar(510) ;
 GO 
ALTER TABLE [dbo].[SysBatchOriginalUp] ALTER COLUMN [InsuredName] nVarChar(510) ;
 GO 
ALTER TABLE [dbo].[SysBatchOriginalUp] ALTER COLUMN [Location] nVarChar(200) ;
 GO 
ALTER TABLE [dbo].[SysBatchOriginalUp] ALTER COLUMN [MAINSUMINSURED] nVarChar(100) ;
 GO 
ALTER TABLE [dbo].[SysBatchOriginalUp] ALTER COLUMN [MAINSUMINSURED_OC] nVarChar(510) ;
 GO 
ALTER TABLE [dbo].[SysBatchOriginalUp] ALTER COLUMN [OP_REMARK1] nVarChar(100) ;
 GO 
ALTER TABLE [dbo].[SysBatchOriginalUp] ALTER COLUMN [OP_REMARK2] nVarChar(100) ;
 GO 
ALTER TABLE [dbo].[SysBatchOriginalUp] ALTER COLUMN [Remarks] nVarChar(510) ;
 GO 
ALTER TABLE [dbo].[SysBatchOriginalUp] ALTER COLUMN [REMARKS1] nVarChar(510) ;
 GO 
ALTER TABLE [dbo].[SysBatchOriginalUp] ALTER COLUMN [REMARKS11] nVarChar(510) ;
 GO 
ALTER TABLE [dbo].[SysBatchOriginalUp] ALTER COLUMN [REMARKS2] nVarChar(510) ;
 GO 
ALTER TABLE [dbo].[SysBatchOriginalUp] ALTER COLUMN [REMARKS3] nVarChar(510) ;
 GO 
ALTER TABLE [dbo].[SysBatchOriginalUp] ALTER COLUMN [REMARKS4] nVarChar(510) ;
 GO 
ALTER TABLE [dbo].[SysBatchOriginalUp] ALTER COLUMN [REMARKS5] nVarChar(510) ;
 GO 
ALTER TABLE [dbo].[SysBatchOriginalUp] ALTER COLUMN [REMARKS6] nVarChar(510) ;
 GO 
ALTER TABLE [dbo].[SysBatchSC] ALTER COLUMN [ADDRESS_1] nVarChar(510) ;
 GO 
ALTER TABLE [dbo].[SysBatchSC] ALTER COLUMN [ADDRESS_2] nVarChar(510) ;
 GO 
ALTER TABLE [dbo].[SysBatchSC] ALTER COLUMN [ADDRESS_3] nVarChar(510) ;
 GO 
ALTER TABLE [dbo].[SysBatchSC] ALTER COLUMN [Correspondence_Address] nVarChar(510) ;
 GO 
ALTER TABLE [dbo].[SysBatchSC] ALTER COLUMN [Correspondence_Email] nVarChar(100) ;
 GO 
ALTER TABLE [dbo].[SysBatchSC] ALTER COLUMN [Email] nVarChar(1024) ;
 GO 
ALTER TABLE [dbo].[SysBatchSC] ALTER COLUMN [Extra_1] nVarChar(100) ;
 GO 
ALTER TABLE [dbo].[SysBatchSC] ALTER COLUMN [Extra_2] nVarChar(100) ;
 GO 
ALTER TABLE [dbo].[SysBatchSC] ALTER COLUMN [Extra_3] nVarChar(100) ;
 GO 
ALTER TABLE [dbo].[SysBatchSC] ALTER COLUMN [Extra_4] nVarChar(100) ;
 GO 
ALTER TABLE [dbo].[SysBatchSC] ALTER COLUMN [Extra_5] nVarChar(100) ;
 GO 
ALTER TABLE [dbo].[SysBatchSC] ALTER COLUMN [INSURED] nVarChar(1024) ;
 GO 
ALTER TABLE [dbo].[SysBatchSC] ALTER COLUMN [location] nVarChar(510) ;
 GO 
ALTER TABLE [dbo].[SysBatchUp] ALTER COLUMN [ADDCOVERAGEREMARK1] nVarChar(510) ;
 GO 
ALTER TABLE [dbo].[SysBatchUp] ALTER COLUMN [ADDCOVERAGEREMARK10] nVarChar(510) ;
 GO 
ALTER TABLE [dbo].[SysBatchUp] ALTER COLUMN [ADDCOVERAGEREMARK2] nVarChar(510) ;
 GO 
ALTER TABLE [dbo].[SysBatchUp] ALTER COLUMN [ADDCOVERAGEREMARK3] nVarChar(510) ;
 GO 
ALTER TABLE [dbo].[SysBatchUp] ALTER COLUMN [ADDCOVERAGEREMARK4] nVarChar(510) ;
 GO 
ALTER TABLE [dbo].[SysBatchUp] ALTER COLUMN [ADDCOVERAGEREMARK5] nVarChar(510) ;
 GO 
ALTER TABLE [dbo].[SysBatchUp] ALTER COLUMN [ADDCOVERAGEREMARK6] nVarChar(510) ;
 GO 
ALTER TABLE [dbo].[SysBatchUp] ALTER COLUMN [ADDCOVERAGEREMARK7] nVarChar(510) ;
 GO 
ALTER TABLE [dbo].[SysBatchUp] ALTER COLUMN [ADDCOVERAGEREMARK8] nVarChar(510) ;
 GO 
ALTER TABLE [dbo].[SysBatchUp] ALTER COLUMN [ADDCOVERAGEREMARK9] nVarChar(510) ;
 GO 
ALTER TABLE [dbo].[SysBatchUp] ALTER COLUMN [ADDINTERESTREMARK10] nVarChar(510) ;
 GO 
ALTER TABLE [dbo].[SysBatchUp] ALTER COLUMN [ADDINTERESTREMARK6] nVarChar(510) ;
 GO 
ALTER TABLE [dbo].[SysBatchUp] ALTER COLUMN [ADDINTERESTREMARK7] nVarChar(510) ;
 GO 
ALTER TABLE [dbo].[SysBatchUp] ALTER COLUMN [ADDINTERESTREMARK8] nVarChar(510) ;
 GO 
ALTER TABLE [dbo].[SysBatchUp] ALTER COLUMN [ADDINTERESTREMARK9] nVarChar(510) ;
 GO 
ALTER TABLE [dbo].[SysBatchUp] ALTER COLUMN [Address_1] nVarChar(510) ;
 GO 
ALTER TABLE [dbo].[SysBatchUp] ALTER COLUMN [Address_2] nVarChar(510) ;
 GO 
ALTER TABLE [dbo].[SysBatchUp] ALTER COLUMN [Address_3] nVarChar(510) ;
 GO 
ALTER TABLE [dbo].[SysBatchUp] ALTER COLUMN [beneficiaries_Address1] nVarChar(510) ;
 GO 
ALTER TABLE [dbo].[SysBatchUp] ALTER COLUMN [beneficiaries_Address2] nVarChar(510) ;
 GO 
ALTER TABLE [dbo].[SysBatchUp] ALTER COLUMN [beneficiaries_Address3] nVarChar(510) ;
 GO 
ALTER TABLE [dbo].[SysBatchUp] ALTER COLUMN [CADDRESS] nVarChar(510) ;
 GO 
ALTER TABLE [dbo].[SysBatchUp] ALTER COLUMN [Correspondence_Address] nVarChar(510) ;
 GO 
ALTER TABLE [dbo].[SysBatchUp] ALTER COLUMN [Correspondence_Email] nVarChar(100) ;
 GO 
ALTER TABLE [dbo].[SysBatchUp] ALTER COLUMN [CRefNo] nVarChar(100) ;
 GO 
ALTER TABLE [dbo].[SysBatchUp] ALTER COLUMN [DeclareDescription] nVarChar(510) ;
 GO 
ALTER TABLE [dbo].[SysBatchUp] ALTER COLUMN [DUTY_REMARK] nVarChar(100) ;
 GO 
ALTER TABLE [dbo].[SysBatchUp] ALTER COLUMN [Email] nVarChar(1024) ;
 GO 
ALTER TABLE [dbo].[SysBatchUp] ALTER COLUMN [FEE_REMARK] nVarChar(100) ;
 GO 
ALTER TABLE [dbo].[SysBatchUp] ALTER COLUMN [HolderAddress_1] nVarChar(510) ;
 GO 
ALTER TABLE [dbo].[SysBatchUp] ALTER COLUMN [HolderAddress_2] nVarChar(510) ;
 GO 
ALTER TABLE [dbo].[SysBatchUp] ALTER COLUMN [HolderAddress_3] nVarChar(510) ;
 GO 
ALTER TABLE [dbo].[SysBatchUp] ALTER COLUMN [ICoverDetDescription1] nVarChar(510) ;
 GO 
ALTER TABLE [dbo].[SysBatchUp] ALTER COLUMN [ICoverDetDescription2] nVarChar(510) ;
 GO 
ALTER TABLE [dbo].[SysBatchUp] ALTER COLUMN [ICoverDetDescription3] nVarChar(510) ;
 GO 
ALTER TABLE [dbo].[SysBatchUp] ALTER COLUMN [ICoverDetDescription4] nVarChar(510) ;
 GO 
ALTER TABLE [dbo].[SysBatchUp] ALTER COLUMN [ICoverDetDescription5] nVarChar(510) ;
 GO 
ALTER TABLE [dbo].[SysBatchUp] ALTER COLUMN [InParty_Address1] nVarChar(510) ;
 GO 
ALTER TABLE [dbo].[SysBatchUp] ALTER COLUMN [InParty_Address2] nVarChar(510) ;
 GO 
ALTER TABLE [dbo].[SysBatchUp] ALTER COLUMN [InParty_Address3] nVarChar(510) ;
 GO 
ALTER TABLE [dbo].[SysBatchUp] ALTER COLUMN [InParty_Address4] nVarChar(510) ;
 GO 
ALTER TABLE [dbo].[SysBatchUp] ALTER COLUMN [InParty_Remark1] nVarChar(510) ;
 GO 
ALTER TABLE [dbo].[SysBatchUp] ALTER COLUMN [InParty_Remark2] nVarChar(510) ;
 GO 
ALTER TABLE [dbo].[SysBatchUp] ALTER COLUMN [InParty_Remark3] nVarChar(510) ;
 GO 
ALTER TABLE [dbo].[SysBatchUp] ALTER COLUMN [InParty_Remark4] nVarChar(510) ;
 GO 
ALTER TABLE [dbo].[SysBatchUp] ALTER COLUMN [Insured] nVarChar(1024) ;
 GO 
ALTER TABLE [dbo].[SysBatchUp] ALTER COLUMN [InsuredAddress_1] nVarChar(510) ;
 GO 
ALTER TABLE [dbo].[SysBatchUp] ALTER COLUMN [InsuredAddress_2] nVarChar(510) ;
 GO 
ALTER TABLE [dbo].[SysBatchUp] ALTER COLUMN [InsuredAddress_3] nVarChar(510) ;
 GO 
ALTER TABLE [dbo].[SysBatchUp] ALTER COLUMN [InsuredID] nVarChar(510) ;
 GO 
ALTER TABLE [dbo].[SysBatchUp] ALTER COLUMN [InsuredName] nVarChar(510) ;
 GO 
ALTER TABLE [dbo].[SysBatchUp] ALTER COLUMN [Location] nVarChar(200) ;
 GO 
ALTER TABLE [dbo].[SysBatchUp] ALTER COLUMN [OP_REMARK1] nVarChar(100) ;
 GO 
ALTER TABLE [dbo].[SysBatchUp] ALTER COLUMN [OP_REMARK2] nVarChar(100) ;
 GO 
ALTER TABLE [dbo].[SysBatchUp] ALTER COLUMN [Remarks] nVarChar(510) ;
 GO 
ALTER TABLE [dbo].[SysBatchUp] ALTER COLUMN [REMARKS1] nVarChar(510) ;
 GO 
ALTER TABLE [dbo].[SysBatchUp] ALTER COLUMN [REMARKS11] nVarChar(510) ;
 GO 
ALTER TABLE [dbo].[SysBatchUp] ALTER COLUMN [REMARKS2] nVarChar(510) ;
 GO 
ALTER TABLE [dbo].[SysBatchUp] ALTER COLUMN [REMARKS3] nVarChar(510) ;
 GO 
ALTER TABLE [dbo].[SysBatchUp] ALTER COLUMN [REMARKS4] nVarChar(510) ;
 GO 
ALTER TABLE [dbo].[SysBatchUp] ALTER COLUMN [REMARKS5] nVarChar(510) ;
 GO 
ALTER TABLE [dbo].[SysBatchUp] ALTER COLUMN [REMARKS6] nVarChar(510) ;
 GO 
ALTER TABLE [dbo].[SysCategory] ALTER COLUMN [DESCRIPTION] nVarchar(255) ;
 GO 
ALTER TABLE [dbo].[SysCategory] ALTER COLUMN [Last_Opr] nVarChar(50) ;
 GO 
ALTER TABLE [dbo].[SysClass] ALTER COLUMN [DESCRIPTION] nVarchar(255) ;
 GO 
ALTER TABLE [dbo].[SysClass] ALTER COLUMN [Last_Opr] nVarChar(50) ;
 GO 
ALTER TABLE [dbo].[SysDocType] ALTER COLUMN [DocLocation] nVarChar(512) ;
 GO 
ALTER TABLE [dbo].[SysErrors] ALTER COLUMN [ErrDesc] nVarchar(1024) ;
 GO 
ALTER TABLE [dbo].[SysForm] ALTER COLUMN [Description] nVarchar(255) ;
 GO 
ALTER TABLE [dbo].[SysInforce] ALTER COLUMN [Remarks] nVarChar(100) ;
 GO 
ALTER TABLE [dbo].[SysInforce] ALTER COLUMN [UserID] nVarChar(50) ;
 GO 
ALTER TABLE [dbo].[SysLogDownload] ALTER COLUMN [LUSERID] nVarChar(50) ;
 GO 
ALTER TABLE [dbo].[SysLogDownload] ALTER COLUMN [USERID] nVarChar(50) ;
 GO 
ALTER TABLE [dbo].[SysLogDownLoadImage] ALTER COLUMN [USERID] nVarChar(50) ;
 GO 
ALTER TABLE [dbo].[SysLogObject] ALTER COLUMN [Last_Opr] nVarChar(50) ;
 GO 
ALTER TABLE [dbo].[SysLogObject] ALTER COLUMN [Remarks] nVarChar(max) ;
 GO 
ALTER TABLE [dbo].[SysLogProcess] ALTER COLUMN [UserID] nVarChar(50) ;
 GO 
ALTER TABLE [dbo].[SysLogReport] ALTER COLUMN [Description] nVarchar(512) ;
 GO 
ALTER TABLE [dbo].[SysLogReport] ALTER COLUMN [REMARKS] nVarChar(512) ;
 GO 
ALTER TABLE [dbo].[SysLogReport] ALTER COLUMN [UserID] nVarChar(50) ;
 GO 
ALTER TABLE [dbo].[SysProcess] ALTER COLUMN [Last_Opr] nVarChar(50) ;
 GO 
ALTER TABLE [dbo].[SysProcess] ALTER COLUMN [UserID] nVarChar(50) ;
 GO 
DROP INDEX [dbo].[SysProcH].[UserID];
 GO 
ALTER TABLE [dbo].[SysProcH] ALTER COLUMN [UserID] nVarChar(50) ;
 GO 
CREATE NONCLUSTERED INDEX [UserID] ON [dbo].[SysProcH] (  [UserID] )
 GO 
ALTER TABLE [dbo].[SysProcID] ALTER COLUMN [DESCRIPTION] nVarchar(255) ;
 GO 
ALTER TABLE [dbo].[SysProcID] ALTER COLUMN [Last_Opr] nVarChar(50) ;
 GO 
ALTER TABLE [dbo].[SysProcID] ALTER COLUMN [VALUEDESC1] nVarchar(Max) ;
 GO 
ALTER TABLE [dbo].[SysProcID] ALTER COLUMN [VALUEDESC10] nVarchar(Max) ;
 GO 
ALTER TABLE [dbo].[SysProcID] ALTER COLUMN [VALUEDESC11] nVarchar(Max) ;
 GO 
ALTER TABLE [dbo].[SysProcID] ALTER COLUMN [VALUEDESC12] nVarchar(Max) ;
 GO 
ALTER TABLE [dbo].[SysProcID] ALTER COLUMN [VALUEDESC13] nVarchar(Max) ;
 GO 
ALTER TABLE [dbo].[SysProcID] ALTER COLUMN [VALUEDESC14] nVarchar(Max) ;
 GO 
ALTER TABLE [dbo].[SysProcID] ALTER COLUMN [VALUEDESC15] nVarchar(Max) ;
 GO 
ALTER TABLE [dbo].[SysProcID] ALTER COLUMN [VALUEDESC2] nVarchar(Max) ;
 GO 
ALTER TABLE [dbo].[SysProcID] ALTER COLUMN [VALUEDESC3] nVarchar(Max) ;
 GO 
ALTER TABLE [dbo].[SysProcID] ALTER COLUMN [VALUEDESC4] nVarchar(Max) ;
 GO 
ALTER TABLE [dbo].[SysProcID] ALTER COLUMN [VALUEDESC5] nVarchar(Max) ;
 GO 
ALTER TABLE [dbo].[SysProcID] ALTER COLUMN [VALUEDESC6] nVarchar(Max) ;
 GO 
ALTER TABLE [dbo].[SysProcID] ALTER COLUMN [VALUEDESC7] nVarchar(Max) ;
 GO 
ALTER TABLE [dbo].[SysProcID] ALTER COLUMN [VALUEDESC8] nVarchar(Max) ;
 GO 
ALTER TABLE [dbo].[SysProcID] ALTER COLUMN [VALUEDESC9] nVarchar(Max) ;
 GO 
ALTER TABLE [dbo].[SysQuery] ALTER COLUMN [SQLDesc] nVarchar(max) ;
 GO 
ALTER TABLE [dbo].[SysReport] ALTER COLUMN [Description] nVarchar(255) ;
 GO 
ALTER TABLE [dbo].[SysReportDefinitions] ALTER COLUMN [ClassDescription] nVarchar(255) ;
 GO 
ALTER TABLE [dbo].[SysReportDefinitions] ALTER COLUMN [Description] nVarchar(255) ;
 GO 
ALTER TABLE [dbo].[SysRequest] ALTER COLUMN [ApprovedRemarks] nVarChar(255) ;
 GO 
ALTER TABLE [dbo].[SysRequest] ALTER COLUMN [LUserID] nVarChar(50) ;
 GO 
DROP INDEX [dbo].[SysRequest].[I_get_SysRequest];
 GO 
ALTER TABLE [dbo].[SysRequest] ALTER COLUMN [Remarks] nVarChar(max) ;
 GO 
CREATE NONCLUSTERED INDEX [I_get_SysRequest] ON [dbo].[SysRequest] (  [Param1] , [UserID] , [Status] , [Param2] )
 GO 
DROP INDEX [dbo].[SysRequest].[I_get_SysRequest];
 GO 
DROP INDEX [dbo].[SysRequest].[I_SysRequest_Param1_Param2_UserID];
 GO 
DROP INDEX [dbo].[SysRequest].[I_SysRequest_UserID_Param2_Param1];
 GO 
ALTER TABLE [dbo].[SysRequest] ALTER COLUMN [UserID] nVarChar(50) ;
 GO 
CREATE NONCLUSTERED INDEX [I_SysRequest_UserID_Param2_Param1] ON [dbo].[SysRequest] (  [UserID] , [Param2] , [Param1] )
 GO 
CREATE NONCLUSTERED INDEX [I_get_SysRequest] ON [dbo].[SysRequest] (  [Param1] , [UserID] , [Status] , [Param2] )
 GO 
CREATE NONCLUSTERED INDEX [I_SysRequest_Param1_Param2_UserID] ON [dbo].[SysRequest] (  [Param1] , [Param2] , [UserID] )
 GO 
ALTER TABLE [dbo].[SysSeqNo_Ex] ALTER COLUMN [Remarks] nVarChar(255) ;
 GO 
ALTER TABLE [dbo].[SysTab] ALTER COLUMN [CompanyAddress] nVarChar(255) ;
 GO 
ALTER TABLE [dbo].[SysTab] ALTER COLUMN [LogoTitle] nVarChar(255) ;
 GO 
ALTER TABLE [dbo].[SysTab] ALTER COLUMN [LogoTitle_Ext] nVarChar(255) ;
 GO 
ALTER TABLE [dbo].[SysTab] ALTER COLUMN [SMTPEMail] nVarChar(255) ;
 GO 
ALTER TABLE [dbo].[SysUpload] ALTER COLUMN [Remarks] nVarChar(100) ;
 GO 
ALTER TABLE [dbo].[SysUpload] ALTER COLUMN [UserID] nVarChar(50) ;
 GO 
ALTER TABLE [dbo].[SysUser] ALTER COLUMN [EMail] nVarChar(512) ;
 GO 
ALTER TABLE [dbo].[SysUser] ALTER COLUMN [Last_Opr] nVarChar(50) ;
 GO 
ALTER TABLE [dbo].[SysUser] ALTER COLUMN [LOCATION] nVarChar(10) ;
 GO 
ALTER TABLE [dbo].[SysUser] ALTER COLUMN [SignerTitle] nVarChar(255) ;
 GO 
ALTER TABLE [dbo].[SysUser] ALTER COLUMN [Title] nVarChar(100) ;
 GO 
ALTER TABLE [dbo].[SysUserAssignment] ALTER COLUMN [Description] nVarchar(100) ;
 GO 
ALTER TABLE [dbo].[SysUserDelegation] ALTER COLUMN [Description] nVarchar(100) ;
 GO 
ALTER TABLE [dbo].[SysUserType] ALTER COLUMN [Description] nVarchar(50) ;
 GO 
ALTER TABLE [dbo].[SysUserTypeTOCTOL] ALTER COLUMN [Last_Opr] nVarChar(50) ;
 GO 
ALTER TABLE [dbo].[SysUserTypeTOCTOL] ALTER COLUMN [VALUEDESC1] nVarchar(Max) ;
 GO 
ALTER TABLE [dbo].[SysUserTypeTOCTOL] ALTER COLUMN [VALUEDESC10] nVarchar(Max) ;
 GO 
ALTER TABLE [dbo].[SysUserTypeTOCTOL] ALTER COLUMN [VALUEDESC11] nVarchar(Max) ;
 GO 
ALTER TABLE [dbo].[SysUserTypeTOCTOL] ALTER COLUMN [VALUEDESC12] nVarchar(Max) ;
 GO 
ALTER TABLE [dbo].[SysUserTypeTOCTOL] ALTER COLUMN [VALUEDESC13] nVarchar(Max) ;
 GO 
ALTER TABLE [dbo].[SysUserTypeTOCTOL] ALTER COLUMN [VALUEDESC14] nVarchar(Max) ;
 GO 
ALTER TABLE [dbo].[SysUserTypeTOCTOL] ALTER COLUMN [VALUEDESC15] nVarchar(Max) ;
 GO 
ALTER TABLE [dbo].[SysUserTypeTOCTOL] ALTER COLUMN [VALUEDESC2] nVarchar(Max) ;
 GO 
ALTER TABLE [dbo].[SysUserTypeTOCTOL] ALTER COLUMN [VALUEDESC3] nVarchar(Max) ;
 GO 
ALTER TABLE [dbo].[SysUserTypeTOCTOL] ALTER COLUMN [VALUEDESC4] nVarchar(Max) ;
 GO 
ALTER TABLE [dbo].[SysUserTypeTOCTOL] ALTER COLUMN [VALUEDESC5] nVarchar(Max) ;
 GO 
ALTER TABLE [dbo].[SysUserTypeTOCTOL] ALTER COLUMN [VALUEDESC6] nVarchar(Max) ;
 GO 
ALTER TABLE [dbo].[SysUserTypeTOCTOL] ALTER COLUMN [VALUEDESC7] nVarchar(Max) ;
 GO 
ALTER TABLE [dbo].[SysUserTypeTOCTOL] ALTER COLUMN [VALUEDESC8] nVarchar(Max) ;
 GO 
ALTER TABLE [dbo].[SysUserTypeTOCTOL] ALTER COLUMN [VALUEDESC9] nVarchar(Max) ;
 GO 
ALTER TABLE [dbo].[TaxCode] ALTER COLUMN [Description] nVarchar(255) ;
 GO 
ALTER TABLE [dbo].[TAXTYPE] ALTER COLUMN [DESCRIPTION] nVarchar(255) ;
 GO 
ALTER TABLE [dbo].[TOC] ALTER COLUMN [DESCRIPTION] nVarchar(60) ;
 GO 
ALTER TABLE [dbo].[TOC] ALTER COLUMN [Last_Opr] nVarChar(50) ;
 GO 
ALTER TABLE [dbo].[TOC] ALTER COLUMN [POLICYTITLE] nVarChar(150) ;
 GO 
ALTER TABLE [dbo].[TOC] ALTER COLUMN [POLICYTITLE_1] nVarChar(150) ;
 GO 
ALTER TABLE [dbo].[TOC] ALTER COLUMN [RegisteredDescription] nVarchar(512) ;
 GO 
ALTER TABLE [dbo].[TOC] ALTER COLUMN [VATDESCRIPTION] nVarchar(255) ;
 GO 
ALTER TABLE [dbo].[TOCGROUP] ALTER COLUMN [DESCRIPTION] nVarchar(100) ;
 GO 
ALTER TABLE [dbo].[TOCGROUP] ALTER COLUMN [Last_Opr] nVarChar(50) ;
 GO 
ALTER TABLE [dbo].[TOI] ALTER COLUMN [DESCRIPTION] nVarchar(Max) ;
 GO 
ALTER TABLE [dbo].[TOI] ALTER COLUMN [Last_Opr] nVarChar(50) ;
 GO 
ALTER TABLE [dbo].[TOIVALUE] ALTER COLUMN [AUserID] nVarChar(50) ;
 GO 
ALTER TABLE [dbo].[TOIVALUE] ALTER COLUMN [Last_Opr] nVarChar(50) ;
 GO 
ALTER TABLE [dbo].[TOIVALUE] ALTER COLUMN [VALUEDESC1] nVarchar(Max) ;
 GO 
ALTER TABLE [dbo].[TOIVALUE] ALTER COLUMN [VALUEDESC10] nVarchar(Max) ;
 GO 
ALTER TABLE [dbo].[TOIVALUE] ALTER COLUMN [VALUEDESC11] nVarchar(Max) ;
 GO 
ALTER TABLE [dbo].[TOIVALUE] ALTER COLUMN [VALUEDESC12] nVarchar(Max) ;
 GO 
ALTER TABLE [dbo].[TOIVALUE] ALTER COLUMN [VALUEDESC13] nVarchar(Max) ;
 GO 
ALTER TABLE [dbo].[TOIVALUE] ALTER COLUMN [VALUEDESC14] nVarchar(Max) ;
 GO 
ALTER TABLE [dbo].[TOIVALUE] ALTER COLUMN [VALUEDESC15] nVarchar(Max) ;
 GO 
ALTER TABLE [dbo].[TOIVALUE] ALTER COLUMN [VALUEDESC2] nVarchar(Max) ;
 GO 
ALTER TABLE [dbo].[TOIVALUE] ALTER COLUMN [VALUEDESC3] nVarchar(Max) ;
 GO 
ALTER TABLE [dbo].[TOIVALUE] ALTER COLUMN [VALUEDESC4] nVarchar(Max) ;
 GO 
ALTER TABLE [dbo].[TOIVALUE] ALTER COLUMN [VALUEDESC5] nVarchar(Max) ;
 GO 
ALTER TABLE [dbo].[TOIVALUE] ALTER COLUMN [VALUEDESC6] nVarchar(Max) ;
 GO 
ALTER TABLE [dbo].[TOIVALUE] ALTER COLUMN [VALUEDESC7] nVarchar(Max) ;
 GO 
ALTER TABLE [dbo].[TOIVALUE] ALTER COLUMN [VALUEDESC8] nVarchar(Max) ;
 GO 
ALTER TABLE [dbo].[TOIVALUE] ALTER COLUMN [VALUEDESC9] nVarchar(Max) ;
 GO 
ALTER TABLE [dbo].[TOL] ALTER COLUMN [Last_Opr] nVarChar(50) ;
 GO 
ALTER TABLE [dbo].[TOP_CLA] ALTER COLUMN [DESCRIPTION] nVarchar(max) ;
 GO 
ALTER TABLE [dbo].[TOP_CLA] ALTER COLUMN [Description_1] nVarchar(max) ;
 GO 
ALTER TABLE [dbo].[TOP_CLA] ALTER COLUMN [SHORTDESC] nVarchar(max) ;
 GO 
ALTER TABLE [dbo].[TOP_CLA] ALTER COLUMN [ShortDesc_1] nVarchar(max) ;
 GO 
ALTER TABLE [dbo].[TOP_CON] ALTER COLUMN [DESCRIPTION] nVarchar(max) ;
 GO 
ALTER TABLE [dbo].[TOP_CON] ALTER COLUMN [Description_1] nVarchar(max) ;
 GO 
ALTER TABLE [dbo].[TOP_CON] ALTER COLUMN [SHORTDESC] nVarchar(max) ;
 GO 
ALTER TABLE [dbo].[TOP_CON] ALTER COLUMN [ShortDesc_1] nVarchar(max) ;
 GO 
ALTER TABLE [dbo].[TOP_Deductible] ALTER COLUMN [Last_Opr] nVarChar(50) ;
 GO 
ALTER TABLE [dbo].[TOP_Deductible] ALTER COLUMN [REMARKS] nVarChar(2048) ;
 GO 
ALTER TABLE [dbo].[TOP_Deductible] ALTER COLUMN [REMARKS_1] nVarChar(2048) ;
 GO 
ALTER TABLE [dbo].[TOP_EX] ALTER COLUMN [DESCRIPTION] nVarchar(max) ;
 GO 
ALTER TABLE [dbo].[TOP_EX] ALTER COLUMN [Description_1] nVarchar(max) ;
 GO 
ALTER TABLE [dbo].[TOP_EX] ALTER COLUMN [SHORTDESC] nVarchar(max) ;
 GO 
ALTER TABLE [dbo].[TOP_EX] ALTER COLUMN [ShortDesc_1] nVarchar(max) ;
 GO 
ALTER TABLE [dbo].[TOP_FD] ALTER COLUMN [Last_Opr] nVarChar(50) ;
 GO 
ALTER TABLE [dbo].[TOP_FD] ALTER COLUMN [REMARK] nVarChar(50) ;
 GO 
ALTER TABLE [dbo].[TOP_Interest] ALTER COLUMN [Last_Opr] nVarChar(50) ;
 GO 
ALTER TABLE [dbo].[TOP_Interest] ALTER COLUMN [Remark] nVarchar(Max) ;
 GO 
ALTER TABLE [dbo].[TOP_NOC] ALTER COLUMN [Description] nVarchar(255) ;
 GO 
ALTER TABLE [dbo].[TOP_Rate] ALTER COLUMN [Last_Opr] nVarChar(50) ;
 GO 
ALTER TABLE [dbo].[TOP_Rate] ALTER COLUMN [Remark] nVarchar(Max) ;
 GO 
ALTER TABLE [dbo].[TOP_RTERM] ALTER COLUMN [Last_Opr] nVarChar(50) ;
 GO 
ALTER TABLE [dbo].[TOP_SECTION] ALTER COLUMN [DESCRIPTION] nVarchar(max) ;
 GO 
ALTER TABLE [dbo].[TOP_SECTION] ALTER COLUMN [SHORTDESC] nVarchar(255) ;
 GO 
ALTER TABLE [dbo].[TOPRO] ALTER COLUMN [Description] nVarchar(255) ;
 GO 
ALTER TABLE [dbo].[TOPRO] ALTER COLUMN [Last_Opr] nVarChar(50) ;
 GO 
ALTER TABLE [dbo].[TOPRO_RATECON] ALTER COLUMN [Last_Opr] nVarChar(50) ;
 GO 
ALTER TABLE [dbo].[TOPRO_RATECON] ALTER COLUMN [VALUEDESC1] nVarchar(Max) ;
 GO 
ALTER TABLE [dbo].[TOPRO_RATECON] ALTER COLUMN [VALUEDESC10] nVarchar(Max) ;
 GO 
ALTER TABLE [dbo].[TOPRO_RATECON] ALTER COLUMN [VALUEDESC11] nVarchar(Max) ;
 GO 
ALTER TABLE [dbo].[TOPRO_RATECON] ALTER COLUMN [VALUEDESC12] nVarchar(Max) ;
 GO 
ALTER TABLE [dbo].[TOPRO_RATECON] ALTER COLUMN [VALUEDESC13] nVarchar(Max) ;
 GO 
ALTER TABLE [dbo].[TOPRO_RATECON] ALTER COLUMN [VALUEDESC14] nVarchar(Max) ;
 GO 
ALTER TABLE [dbo].[TOPRO_RATECON] ALTER COLUMN [VALUEDESC15] nVarchar(Max) ;
 GO 
ALTER TABLE [dbo].[TOPRO_RATECON] ALTER COLUMN [VALUEDESC2] nVarchar(Max) ;
 GO 
ALTER TABLE [dbo].[TOPRO_RATECON] ALTER COLUMN [VALUEDESC3] nVarchar(Max) ;
 GO 
ALTER TABLE [dbo].[TOPRO_RATECON] ALTER COLUMN [VALUEDESC4] nVarchar(Max) ;
 GO 
ALTER TABLE [dbo].[TOPRO_RATECON] ALTER COLUMN [VALUEDESC5] nVarchar(Max) ;
 GO 
ALTER TABLE [dbo].[TOPRO_RATECON] ALTER COLUMN [VALUEDESC6] nVarchar(Max) ;
 GO 
ALTER TABLE [dbo].[TOPRO_RATECON] ALTER COLUMN [VALUEDESC7] nVarchar(Max) ;
 GO 
ALTER TABLE [dbo].[TOPRO_RATECON] ALTER COLUMN [VALUEDESC8] nVarchar(Max) ;
 GO 
ALTER TABLE [dbo].[TOPRO_RATECON] ALTER COLUMN [VALUEDESC9] nVarchar(Max) ;
 GO 
ALTER TABLE [dbo].[TOR] ALTER COLUMN [DESCRIPTION] nVarchar(255) ;
 GO 
ALTER TABLE [dbo].[TOR] ALTER COLUMN [Last_Opr] nVarChar(50) ;
 GO 
ALTER TABLE [dbo].[TORSUB] ALTER COLUMN [Last_Opr] nVarChar(50) ;
 GO 
ALTER TABLE [dbo].[TType] ALTER COLUMN [Description] nVarchar(50) ;
 GO 
ALTER TABLE [dbo].[TType] ALTER COLUMN [Location] nVarChar(10) ;
 GO 
ALTER TABLE [dbo].[Type] ALTER COLUMN [Description] nVarchar(20) ;
 GO 
ALTER TABLE [dbo].[Type] ALTER COLUMN [Last_Opr] nVarChar(50) ;
 GO 
ALTER TABLE [dbo].[UINFO] ALTER COLUMN [VALUEDESC1] nVarchar(max) ;
 GO 
ALTER TABLE [dbo].[UINFO] ALTER COLUMN [VALUEDESC10] nVarchar(max) ;
 GO 
ALTER TABLE [dbo].[UINFO] ALTER COLUMN [VALUEDESC11] nVarchar(max) ;
 GO 
ALTER TABLE [dbo].[UINFO] ALTER COLUMN [VALUEDESC12] nVarchar(max) ;
 GO 
ALTER TABLE [dbo].[UINFO] ALTER COLUMN [VALUEDESC13] nVarchar(max) ;
 GO 
ALTER TABLE [dbo].[UINFO] ALTER COLUMN [VALUEDESC14] nVarchar(max) ;
 GO 
ALTER TABLE [dbo].[UINFO] ALTER COLUMN [VALUEDESC15] nVarchar(max) ;
 GO 
ALTER TABLE [dbo].[UINFO] ALTER COLUMN [VALUEDESC2] nVarchar(max) ;
 GO 
ALTER TABLE [dbo].[UINFO] ALTER COLUMN [VALUEDESC3] nVarchar(max) ;
 GO 
ALTER TABLE [dbo].[UINFO] ALTER COLUMN [VALUEDESC4] nVarchar(max) ;
 GO 
ALTER TABLE [dbo].[UINFO] ALTER COLUMN [VALUEDESC5] nVarchar(max) ;
 GO 
ALTER TABLE [dbo].[UINFO] ALTER COLUMN [VALUEDESC6] nVarchar(max) ;
 GO 
ALTER TABLE [dbo].[UINFO] ALTER COLUMN [VALUEDESC7] nVarchar(max) ;
 GO 
ALTER TABLE [dbo].[UINFO] ALTER COLUMN [VALUEDESC8] nVarchar(max) ;
 GO 
ALTER TABLE [dbo].[UINFO] ALTER COLUMN [VALUEDESC9] nVarchar(max) ;
 GO 
ALTER TABLE [dbo].[VAccount] ALTER COLUMN [BankName] nVarChar(255) ;
 GO 
ALTER TABLE [dbo].[VAccount] ALTER COLUMN [LAST_OPR] nVarChar(50) ;
 GO 
ALTER TABLE [dbo].[VAccountD] ALTER COLUMN [Last_Opr] nVarChar(50) ;
 GO 
ALTER TABLE [dbo].[Village] ALTER COLUMN [Description] nVarChar(200) ;
 GO 
ALTER TABLE [dbo].[Village] ALTER COLUMN [Description_1] nVarChar(200) ;
 GO 
ALTER TABLE [dbo].[Village] ALTER COLUMN [Last_OPR] nVarChar(10) ;
 GO 
ALTER TABLE [dbo].[VoucherLinkH] ALTER COLUMN [UserID] nVarChar(50) ;
 GO 
ALTER TABLE [dbo].[VoucherPic] ALTER COLUMN [Last_Opr] nVarChar(50) ;
 GO 
ALTER TABLE [dbo].[VoucherPic] ALTER COLUMN [Remark] nVarchar(Max) ;
 GO 
ALTER TABLE [dbo].[VoucherPic] ALTER COLUMN [Title] nVarChar(255) ;
 GO 
DROP INDEX [dbo].[VPrintLog].[I_VPrintLog_Voucher_DocNo_Description];
 GO 
ALTER TABLE [dbo].[VPrintLog] ALTER COLUMN [Description] nVarchar(50) NOT NULL;
 GO 
CREATE NONCLUSTERED INDEX [I_VPrintLog_Voucher_DocNo_Description] ON [dbo].[VPrintLog] (  [Voucher] , [DocNo] , [Description] )
 GO 
ALTER TABLE [dbo].[VPrintLog] ALTER COLUMN [UserID] nVarChar(50) ;
 GO 
ALTER TABLE [dbo].[vType] ALTER COLUMN [Description] nVarchar(100) ;
 GO 
ALTER TABLE [dbo].[vType] ALTER COLUMN [Last_Opr] nVarChar(50) ;
 GO 
ALTER TABLE [dbo].[Wording] ALTER COLUMN [Description] nVarchar(max) ;
 GO 
ALTER TABLE [dbo].[Wording] ALTER COLUMN [Last_Opr] nVarChar(50) ;
 GO 
ALTER TABLE [dbo].[Wording] ALTER COLUMN [ShortDesc] nVarchar(255) ;
 GO 
ALTER TABLE [dbo].[VoucherLinkH] ALTER COLUMN [UserID] nVarChar(50) ;
 GO 
ALTER TABLE [dbo].[VoucherPic] ALTER COLUMN [Last_Opr] nVarChar(50) ;
 GO 
ALTER TABLE [dbo].[VoucherPic] ALTER COLUMN [Remark] nVarchar(Max) ;
 GO 
ALTER TABLE [dbo].[VoucherPic] ALTER COLUMN [Title] nVarChar(255) ;
 GO 
DROP INDEX [dbo].[VPrintLog].[I_VPrintLog_Voucher_DocNo_Description];
 GO 
ALTER TABLE [dbo].[VPrintLog] ALTER COLUMN [Description] nVarchar(50) ;
 GO 
CREATE NONCLUSTERED INDEX [I_VPrintLog_Voucher_DocNo_Description] ON [dbo].[VPrintLog] (  [Voucher] , [DocNo] , [Description] )
 GO 
ALTER TABLE [dbo].[VPrintLog] ALTER COLUMN [UserID] nVarChar(50) ;
 GO 
ALTER TABLE [dbo].[vType] ALTER COLUMN [Description] nVarchar(100) ;
 GO 
ALTER TABLE [dbo].[vType] ALTER COLUMN [Last_Opr] nVarChar(50) ;
 GO 
ALTER TABLE [dbo].[Wording] ALTER COLUMN [Description] nVarchar(max) ;
 GO 
ALTER TABLE [dbo].[Wording] ALTER COLUMN [Last_Opr] nVarChar(50) ;
 GO 
ALTER TABLE [dbo].[Wording] ALTER COLUMN [ShortDesc] nVarchar(255) ;
 GO 

 Create View [dbo].[SL] with schemabinding as
Select Voucher,Doc_No, Doc_Date, Remarks, Nominal, Doc_CCY, Nominal_OC, Rate, Hint, PaymentF, Account, Nominator, Denominator, CT, SortNo
from dbo.nSL SL
Union All
Select Voucher,Doc_No, Doc_Date, Remarks, Nominal, Doc_CCY, Nominal_OC, Rate, Hint, PaymentF, Account, Nominator, Denominator, CT, SortNo
from dbo.pSL SL
Union All
Select Voucher,Doc_No, Doc_Date, Remarks, Nominal, Doc_CCY, Nominal_OC, Rate, Hint, PaymentF, Account, Nominator, Denominator, CT, SortNo
from dbo.mSL SL
GO

Create View [dbo].[vProAcc]
WITH SCHEMABINDING
AS
select 
ProAcc.ProAcc, 
ProAcc.Description, 
ProAcc.Currency, 
ProAcc.ID, 
dbo.fn_DECRYPTTEXT(SysTab.EncryptionPassPhrase,ProAcc.AccountNo) as AccountNO, 
dbo.fn_DECRYPTTEXT(SysTab.EncryptionPassPhrase,ProAcc.BankAccount) as BankAccount, 
ProAcc.BankName, 
ProAcc.Bank,
ProAcc.BankBranch,
ProAcc.RestrictedF, 
ProAcc.Last_Opr, 
ProAcc.Last_Update, 
ProAcc.UserID, 
ProAcc.CDate, 
ProAcc.BCTransferBy, 
ProAcc.RESTRICTAFTERUSEDF, 
ProAcc.Remarks, 
ProAcc.PUserID, 
ProAcc.PUserDate,
ProAcc.ExcludeTaxF, 
ProAcc.RefType, 
ProAcc.PRDays, 
ProAcc.Purpose, 
ProAcc.Account_DR, 
ProAcc.Account_CR
from dbo.Proacc ProAcc
Inner Join dbo.SysTab SysTab on (1=1)

GO


Create View vProfile
WITH SCHEMABINDING
AS
select 
	Profile.ID
	,Profile.Salutation
	,Profile.FirstName
	,Profile.MidName
	,Profile.LastName
	,Profile.Name
	,Profile.Initial
	,Profile.Address_1
	,Profile.Address_2
	,Profile.Address_3
	,Profile.City
	,Profile.ZipCode
	,Profile.Phone_1
	,Profile.Phone_2
	,Profile.Mobile_1
	,Profile.Mobile_2
	,Profile.Fax_1
	,Profile.Fax_2
	,Profile.Contact
	,Profile.ContactAddress
	,Profile.ContactPhone
	,Profile.Title
	,Profile.PTYPE
	,Profile.RefID
	,dbo.fn_DECRYPTTEXT(SysTab.EncryptionPassPhrase,Profile.TaxID) as TaxID
	,dbo.fn_DECRYPTTEXT(SysTab.EncryptionPassPhrase,Profile.Email) as Email
	,dbo.fn_DECRYPTTEXT(SysTab.EncryptionPassPhrase,Profile.Email_2) as Email_2
	,Profile.TaxName
	,Profile.TaxAddress
	,Profile.VatF
	,Profile.TaxF
	,Profile.LOB
	,Profile.Country
	,Profile.CorporateF
	,Profile.IntermediaryF
	,Profile.Rating
	,Profile.CGroup
	,Profile.SCGroup
	,Profile.Area
	,Profile.TaxType
	,Profile.VAT
	,Profile.TAX
	,Profile.TAXPCT
	,Profile.NTAXINCOME
	,Profile.LAST_OPR
	,Profile.LAST_UPDATE
	,Profile.PID
	,Profile.COMM
	,Profile.Disc
	,Profile.RESTRICTEDF
	,Profile.PREFERREDF
	,Profile.REMARK
	,Profile.CTYPE
	,Profile.ProviderF
	,Profile.RedFlag
	,Profile.RedFlagDate
	,Profile.RedFlagTime
	,Profile.RedFlagDescription
	,Profile.RedFlagUser
	,Profile.DumpF
	,dbo.fn_DECRYPTTEXT(SysTab.EncryptionPassPhrase,Profile.USERID) as USERID
	,Profile.CDATE
	,Profile.ASource
	,Profile.Owner
	,Profile.WPC
	,Profile.Grace
	,Profile.Branch
	,Profile.NetCommF
	,Profile.MaxOutGo
	,Profile.LicenseNo
	,Profile.TPAF
	,Profile.Province
	,Profile.XProfileID
	,Profile.ICPSF
	,Profile.RType
	,Profile.LicenseDate
	,Profile.LicenseExpiry
	,Profile.ContactTitle
	,Profile.TAXHSDate
	,Profile.TAXHEDate
	,Profile.MOID
	,Profile.HSCode
	,Profile.BIType
	,Profile.AccruedTax
	,Profile.Last_Time
	,Profile.Regency
	,Profile.SubsidiaryF
	,Profile.Latitude
	,Profile.Longtitude
	,Profile.District
	,Profile.SubDistrict
	,Profile.RoomNo
	,Profile.FloorNo
	,Profile.HomeNo
	,Profile.MOO
	,Profile.SOI
	,Profile.Village
	,Profile.Building
	,Profile.Road
	,Profile.SyncDate
	,Profile.SyncTime
	,Profile.SYNCERRORMESSAGE
	,Profile.BVATF
	,Profile.TVATF
	,Profile.RestrictedDate
	,Profile.RestrictedTime
	,Profile.RestrictedUser
	--,Profile.OJKRegion
	--,Profile.OJKSchemeNo
	,Profile.PrivilegeType
	,Profile.DeferralF
	,Profile.VerifiedBy
	,Profile.VerifiedDate
	,Profile.VerifiedTime
	,Profile.VATOLD
	,Profile.VATSubsidiesF
	,Profile.VATESDate
	,Profile.VATEEDate
	,Profile.CBRAID
	,Profile.CBRADATE
	,Profile.CBRANRDATE
	,Profile.ConsentOnDataKeepByCompanyF
	,Profile.ConsentOnDataPrivacyToThirdPartyF
	,Profile.ConsentOnProductAndServiceOfferingF
	,Profile.VerifiedF
	,Profile.AccruedVAT
	,Profile.TAXIDOLD
	,Profile.Email_3
	,Profile.VATCOMMEXEMPTIF
from dbo.Profile Profile
Inner Join dbo.SysTab SysTab on (1=1)

GO

Create View vProfile_Ext
WITH SCHEMABINDING
AS
select 
	Profile.ID
	,Profile.BLNo
	,Profile.BLDate
	,Profile.BOD_1
	,Profile.BODFunction_1
	,Profile.BOD_2
	,Profile.BODFunction_2
	,Profile.BOD_3
	,Profile.BODFunction_3
	,Profile.SHolder_1
	,Profile.SHolder_2
	,Profile.SHolder_3
	,Profile.WNIF
	,Profile.NickName
	,Profile.Citizen
	,Profile.CName
	,Profile.CAddress
	,Profile.CPhone_1
	,Profile.CPhone_2
	,Profile.Employment
	,Profile.Income
	,Profile.OtherIncome
	,Profile.ID_Date
	,dbo.fn_DECRYPTTEXT(SysTab.EncryptionPassPhrase,Profile.ID_No) as ID_No
	,dbo.fn_DECRYPTTEXT(SysTab.EncryptionPassPhrase,Profile.ID_Type) as ID_Type 
	,dbo.fn_DECRYPTTEXT(SysTab.EncryptionPassPhrase,Profile.PassportNo) as PassportNo 
	,dbo.fn_DECRYPTTEXT(SysTab.EncryptionPassPhrase,Profile.Gender) as Gender 
	,dbo.fn_DECRYPTTEXT(SysTab.EncryptionPassPhrase,Profile.MothersName) as MothersName 
	,dbo.fn_DECRYPTDATE(SysTab.EncryptionPassPhrase,Profile.BirthDate) as BirthDate 
	,Profile.ID_Name
	,Profile.BirthPlace
	,Profile.Religion
	,Profile.Purpose
	,Profile.SIUP
	,Profile.TDP
	,Profile.Marital
	,Profile.JOBTitle
	,Profile.PIC_TITLE_1
	,Profile.PIC_NAME_1
	,Profile.PIC_TITLE_2
	,Profile.PIC_NAME_2
	,Profile.PIC_TITLE_3
	,Profile.PIC_NAME_3
	,Profile.HOMEPAGE
	,Profile.ID_Date_Ext
	,Profile.ID_No_Ext
	,Profile.ID_Name_Ext
	,Profile.ID_Type_Ext
	,Profile.ADDHOMEPAGE
	,Profile.BLPlace
	,Profile.CBRAFLAG
	,Profile.CBRATPMID
	,Profile.CBRADepartment
	,Profile.CBRACOID
	,Profile.CBRATPRMID
	,Profile.CBRATPStatus
	,Profile.CBRATPTYPE
	,Profile.CBRATPRMSCOPE
	,Profile.CBRANDASTATUS
	,Profile.CBRANDAEFFDATE
	,Profile.CBRANDAEXPDATE
	,Profile.CBRAAgreement
	,Profile.CBRAAgreementStatus
	,Profile.CBRAAgreementEffDate
	,Profile.CBRAAgreementExpDate
	,Profile.CBRAOBDDDate
	,Profile.CBRAOBDDStatus
	,Profile.CBRAOBDDRating
	,Profile.CBRALODDID
	,Profile.CBRALODDStatus
	,Profile.CBRALODDCreateDate
	,Profile.CBRALODDCompDate
	,Profile.CBRALatestResRisk
	,Profile.CBRALatestMaxInfoSec
	,Profile.CBRALatestMaxBCM
	,Profile.CBRALatestMaxCompliance
	,Profile.CBRALatestCurrFVA
	,Profile.CBRALatestMaxMateriality
	,Profile.CBRANDDSInfoSecDate
	,Profile.CBRANDDSBusContDate
	,Profile.CBRANDDSFVADate
	,Profile.CBRANDDSMaterialityDate
	,Profile.CBRANDDSISODate
	,Profile.CBRAODDSDate
	,Profile.CBRAODDSTPDate
	,Profile.BeneficiaryOwner
	,Profile.CBRAOBID
	,Profile.CBRAOBCDDate
	,Profile.CBRANOREFDATE
	,Profile.CBRATPEForm
	,Profile.CBRATPEFormSubDate
	,Profile.CBRAODDCDate
	,Profile.DomicileAddress
	,Profile.AddressSameIDF
	,Profile.PIDExpDate
	,Profile.NoPIDExpDateF
	,Profile.LastEducation
	,Profile.MonthlyIncome
	,Profile.MonthlyExpenses
from dbo.Profile_Ext Profile
Inner Join dbo.SysTab SysTab on (1=1)


GO

