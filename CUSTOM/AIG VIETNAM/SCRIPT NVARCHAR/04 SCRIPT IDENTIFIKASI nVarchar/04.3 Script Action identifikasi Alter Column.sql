ALTER TABLE [dbo].[AAccBS] ALTER COLUMN [PICName] nVarChar(255) ;
 GO 
ALTER TABLE [dbo].[AAccBS] ALTER COLUMN [LUserID] nVarChar(50) ;
 GO 
ALTER TABLE [dbo].[AAccBS] ALTER COLUMN [PICEmail] nVarChar(255) ;
 GO 
ALTER TABLE [dbo].[ABeneficiaries] DROP CONSTRAINT [I_ABeneficiaries];
 GO 
DROP INDEX [dbo].[ABeneficiaries].[I_ABeneficiaries_ANO_ID_Name];
 GO 
ALTER TABLE [dbo].[ABeneficiaries] ALTER COLUMN [Name] nVarChar(255) ;
 GO 
ALTER TABLE [dbo].[ABeneficiaries] WITH NOCHECK ADD CONSTRAINT [I_ABeneficiaries] PRIMARY KEY NONCLUSTERED( [ANO] , [Name] ) WITH (ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = OFF) ON [PRIMARY]
 GO 
CREATE NONCLUSTERED INDEX [I_ABeneficiaries_ANO_ID_Name] ON [dbo].[ABeneficiaries] (  [ANO] , [ID] , [Name] )
 GO 
ALTER TABLE [dbo].[ABeneficiaries] ALTER COLUMN [Address_1] nVarChar(1024) ;
 GO 
ALTER TABLE [dbo].[ABeneficiaries] ALTER COLUMN [Address_2] nVarChar(1024) ;
 GO 
ALTER TABLE [dbo].[ABeneficiaries] ALTER COLUMN [REMARK] nVarChar(255) ;
 GO 
ALTER TABLE [dbo].[ABeneficiaries] ALTER COLUMN [Email] nVarChar(512) ;
 GO 
ALTER TABLE [dbo].[ACCBS] ALTER COLUMN [PICName] nVarChar(255) ;
 GO 
ALTER TABLE [dbo].[ACCBS] ALTER COLUMN [LUserID] nVarChar(50) ;
 GO 
ALTER TABLE [dbo].[ACCBS] ALTER COLUMN [PICEmail] nVarChar(255) ;
 GO 
ALTER TABLE [dbo].[AccCA] ALTER COLUMN [Address] nVarChar(1024) ;
 GO 
ALTER TABLE [dbo].[AccCA] ALTER COLUMN [Email] nVarChar(512) ;
 GO 
ALTER TABLE [dbo].[ACCCLA] ALTER COLUMN [SHORTDESC] nVarChar(max) ;
 GO 
ALTER TABLE [dbo].[ACCCLA] ALTER COLUMN [Last_Opr] nVarChar(50) ;
 GO 
ALTER TABLE [dbo].[ACCCLA] ALTER COLUMN [ShortDesc_1] nVarChar(max) ;
 GO 
ALTER TABLE [dbo].[AccClass] ALTER COLUMN [Last_Opr] nVarChar(50) ;
 GO 
ALTER TABLE [dbo].[AccClass] ALTER COLUMN [Description] nVarChar(100) ;
 GO 
ALTER TABLE [dbo].[AccClass] ALTER COLUMN [ShortDesc] nVarChar(100) ;
 GO 
ALTER TABLE [dbo].[AccClassDet] ALTER COLUMN [Description] nVarChar(200) ;
 GO 
ALTER TABLE [dbo].[ACCCNC] ALTER COLUMN [USERID] nVarChar(50) ;
 GO 
ALTER TABLE [dbo].[ACCCOLLATERAL] ALTER COLUMN [REMARKS] nVarChar(512) ;
 GO 
ALTER TABLE [dbo].[ACCCOLLATERAL] ALTER COLUMN [DESCRIPTION] nVarChar(255) ;
 GO 
ALTER TABLE [dbo].[ACCCOLLATERAL] ALTER COLUMN [Attrib_1] nVarChar(100) ;
 GO 
ALTER TABLE [dbo].[ACCCOLLATERAL] ALTER COLUMN [Attrib_2] nVarChar(100) ;
 GO 
ALTER TABLE [dbo].[ACCCOLLATERAL] ALTER COLUMN [Attrib_3] nVarChar(100) ;
 GO 
ALTER TABLE [dbo].[ACCCOLLATERAL] ALTER COLUMN [Attrib_4] nVarChar(100) ;
 GO 
ALTER TABLE [dbo].[ACCCOLLATERAL] ALTER COLUMN [Attrib_5] nVarChar(100) ;
 GO 
ALTER TABLE [dbo].[ACCCOLLATERAL] ALTER COLUMN [Attrib_6] nVarChar(100) ;
 GO 
ALTER TABLE [dbo].[ACCCOLLATERAL] ALTER COLUMN [Attrib_7] nVarChar(100) ;
 GO 
ALTER TABLE [dbo].[ACCCOLLATERAL] ALTER COLUMN [Attrib_8] nVarChar(100) ;
 GO 
ALTER TABLE [dbo].[ACCCOLLATERAL] ALTER COLUMN [Attrib_9] nVarChar(100) ;
 GO 
ALTER TABLE [dbo].[ACCCOLLATERAL] ALTER COLUMN [Attrib_10] nVarChar(100) ;
 GO 
ALTER TABLE [dbo].[ACCCOLLATERAL] ALTER COLUMN [LAST_OPR] nVarChar(50) ;
 GO 
ALTER TABLE [dbo].[ACCCOMPSHEETH] ALTER COLUMN [USERID] nVarChar(50) ;
 GO 
ALTER TABLE [dbo].[ACCCOMPSHEETH] ALTER COLUMN [LUSERID] nVarChar(50) ;
 GO 
ALTER TABLE [dbo].[ACCCOMPSHEETH] ALTER COLUMN [AUSERID] nVarChar(50) ;
 GO 
ALTER TABLE [dbo].[ACCCOMPSHEETH] ALTER COLUMN [CUSERID] nVarChar(50) ;
 GO 
ALTER TABLE [dbo].[ACCCOMPSHEETH] ALTER COLUMN [PUserID] nVarChar(50) ;
 GO 
ALTER TABLE [dbo].[ACCCOMPSHEETH] ALTER COLUMN [COMMENT] nVarChar(max) ;
 GO 
ALTER TABLE [dbo].[ACCCON] ALTER COLUMN [Last_Opr] nVarChar(50) ;
 GO 
ALTER TABLE [dbo].[ACCCON] ALTER COLUMN [SHORTDESC] nVarChar(max) ;
 GO 
ALTER TABLE [dbo].[ACCCON] ALTER COLUMN [ShortDesc_1] nVarChar(max) ;
 GO 
ALTER TABLE [dbo].[AccDA] ALTER COLUMN [Address] nVarChar(1024) ;
 GO 
ALTER TABLE [dbo].[AccDA] ALTER COLUMN [Email] nVarChar(512) ;
 GO 
ALTER TABLE [dbo].[ACCDED] ALTER COLUMN [REMARKS_1] nVarChar(2048) ;
 GO 
ALTER TABLE [dbo].[ACCDED] ALTER COLUMN [LUserID] nVarChar(50) ;
 GO 
ALTER TABLE [dbo].[ACCDEPOSIT] ALTER COLUMN [REMARK] nVarChar(255) ;
 GO 
ALTER TABLE [dbo].[ACCDEPOSIT] ALTER COLUMN [Last_Opr] nVarChar(50) ;
 GO 
ALTER TABLE [dbo].[ACCDOCLIST] ALTER COLUMN [DESCRIPTION] nVarChar(255) ;
 GO 
ALTER TABLE [dbo].[ACCDOCLIST] ALTER COLUMN [REMARKS] nVarChar(512) ;
 GO 
ALTER TABLE [dbo].[ACCDOCLIST] ALTER COLUMN [LAST_OPR] nVarChar(50) ;
 GO 
ALTER TABLE [dbo].[ACCDOCLISTPIC] ALTER COLUMN [Last_Opr] nVarChar(50) ;
 GO 
ALTER TABLE [dbo].[AccDocStat] ALTER COLUMN [Remarks] nVarChar(255) ;
 GO 
ALTER TABLE [dbo].[AccDocStat] ALTER COLUMN [Last_Opr] nVarChar(50) ;
 GO 
ALTER TABLE [dbo].[ACCEMPCONTD] ALTER COLUMN [REMARKS] nVarChar(255) ;
 GO 
ALTER TABLE [dbo].[ACCEMPCONTH] ALTER COLUMN [REMARKS] nVarChar(512) ;
 GO 
ALTER TABLE [dbo].[ACCEMPCONTH] ALTER COLUMN [USERID] nVarChar(50) ;
 GO 
ALTER TABLE [dbo].[ACCEMPCONTH] ALTER COLUMN [LUSERID] nVarChar(50) ;
 GO 
ALTER TABLE [dbo].[ACCEMPCONTH] ALTER COLUMN [AUSERID] nVarChar(50) ;
 GO 
ALTER TABLE [dbo].[ACCEMPCONTH] ALTER COLUMN [CUSERID] nVarChar(50) ;
 GO 
ALTER TABLE [dbo].[ACCEMPCONTH] ALTER COLUMN [PUserID] nVarChar(50) ;
 GO 
ALTER TABLE [dbo].[ACCEPTANCE] ALTER COLUMN [SYSUSERID] nVarChar(50) ;
 GO 
ALTER TABLE [dbo].[ACCEPTANCE] ALTER COLUMN [USERID] nVarChar(50) ;
 GO 
ALTER TABLE [dbo].[ACCEPTANCE] ALTER COLUMN [CUSERID] nVarChar(50) ;
 GO 
ALTER TABLE [dbo].[ACCEPTANCE] ALTER COLUMN [AName] nVarChar(max) ;
 GO 
ALTER TABLE [dbo].[ACCEPTANCE] ALTER COLUMN [LUserID] nVarChar(50) ;
 GO 
ALTER TABLE [dbo].[ACCEPTANCE] ALTER COLUMN [AUserID] nVarChar(50) ;
 GO 
ALTER TABLE [dbo].[ACCEPTANCE] ALTER COLUMN [RequestName] nVarChar(50) ;
 GO 
ALTER TABLE [dbo].[ACCEPTANCE] ALTER COLUMN [Location] nVarChar(100) ;
 GO 
ALTER TABLE [dbo].[ACCEPTANCE] ALTER COLUMN [RUserID] nVarChar(50) ;
 GO 
ALTER TABLE [dbo].[ACCEPTANCE] ALTER COLUMN [ActionUser] nVarChar(50) ;
 GO 
ALTER TABLE [dbo].[ACCEX] ALTER COLUMN [Last_Opr] nVarChar(50) ;
 GO 
ALTER TABLE [dbo].[ACCEX] ALTER COLUMN [SHORTDESC] nVarChar(max) ;
 GO 
ALTER TABLE [dbo].[ACCEX] ALTER COLUMN [ShortDesc_1] nVarChar(max) ;
 GO 
ALTER TABLE [dbo].[ACCFD] ALTER COLUMN [LUserID] nVarChar(50) ;
 GO 
ALTER TABLE [dbo].[ACCINVOICE] ALTER COLUMN [Last_Opr] nVarChar(50) ;
 GO 
ALTER TABLE [dbo].[ACCINVOICE] ALTER COLUMN [InvoiceRemarks] nVarChar(255) ;
 GO 
ALTER TABLE [dbo].[ACCLINK] ALTER COLUMN [LUserID] nVarChar(50) ;
 GO 
ALTER TABLE [dbo].[Account] ALTER COLUMN [Last_Opr] nVarChar(50) ;
 GO 
ALTER TABLE [dbo].[Account] ALTER COLUMN [Description] nVarChar(200) ;
 GO 
ALTER TABLE [dbo].[Account] ALTER COLUMN [Description1] nVarChar(200) ;
 GO 
ALTER TABLE [dbo].[ACCPIC] ALTER COLUMN [UserID] nVarChar(50) ;
 GO 
ALTER TABLE [dbo].[ACCPIC] ALTER COLUMN [Last_Opr] nVarChar(50) ;
 GO 
ALTER TABLE [dbo].[AccType] ALTER COLUMN [Name] nVarChar(50) ;
 GO 
ALTER TABLE [dbo].[ACGROUP] ALTER COLUMN [DESCRIPTION] nVarChar(50) ;
 GO 
ALTER TABLE [dbo].[ActionList] ALTER COLUMN [Description] nVarChar(255) ;
 GO 
ALTER TABLE [dbo].[ActionList] ALTER COLUMN [ActionName] nVarChar(100) ;
 GO 
ALTER TABLE [dbo].[ActionList] ALTER COLUMN [ApprovedFName] nVarChar(50) ;
 GO 
ALTER TABLE [dbo].[ActionLog] ALTER COLUMN [AppName] nVarChar(10) ;
 GO 
ALTER TABLE [dbo].[ActionLog] ALTER COLUMN [ActionUser] nVarChar(50) ;
 GO 
ALTER TABLE [dbo].[ActionNotification] ALTER COLUMN [ActionUser] nVarChar(50) ;
 GO 
ALTER TABLE [dbo].[ActionNotification] ALTER COLUMN [AppName] nVarChar(10) ;
 GO 
ALTER TABLE [dbo].[ActionUser] ALTER COLUMN [ActionUserAuth_1] nVarChar(50) ;
 GO 
ALTER TABLE [dbo].[ActionUser] ALTER COLUMN [ActionUserAuth_7] nVarChar(50) ;
 GO 
ALTER TABLE [dbo].[ActionUser] ALTER COLUMN [ActionUserAuth_4] nVarChar(50) ;
 GO 
ALTER TABLE [dbo].[ActionUser] ALTER COLUMN [ActionUserAuth_10] nVarChar(50) ;
 GO 
ALTER TABLE [dbo].[ActionUser] ALTER COLUMN [ActionUserAuth_2] nVarChar(50) ;
 GO 
ALTER TABLE [dbo].[ActionUserDet] DROP CONSTRAINT [FK_ActionUserDet_ActionUser];
 GO 
DROP INDEX [dbo].[ActionUser].[I_ActionUser];
 GO 
ALTER TABLE [dbo].[ActionUser] ALTER COLUMN [ActionUser] nVarChar(50) ;
 GO 
ALTER TABLE [dbo].[ActionUserDet] WITH NOCHECK ADD CONSTRAINT [FK_ActionUserDet_ActionUser] FOREIGN KEY ([ActionUser]) REFERENCES [dbo].[ActionUser]([ActionUser]);
 GO 
CREATE UNIQUE NONCLUSTERED INDEX [I_ActionUser] ON [dbo].[ActionUser] (  [ActionCode] , [ActionUser] )
 GO 
ALTER TABLE [dbo].[ActionUser] ALTER COLUMN [ActionUserAuth_5] nVarChar(50) ;
 GO 
ALTER TABLE [dbo].[ActionUser] ALTER COLUMN [ActionUserAuth_8] nVarChar(50) ;
 GO 
ALTER TABLE [dbo].[ActionUser] ALTER COLUMN [ActionUserAuth_6] nVarChar(50) ;
 GO 
ALTER TABLE [dbo].[ActionUser] ALTER COLUMN [ActionUserAuth_9] nVarChar(50) ;
 GO 
ALTER TABLE [dbo].[ActionUser] ALTER COLUMN [ActionUserAuth_3] nVarChar(50) ;
 GO 
ALTER TABLE [dbo].[ActionUserDet] DROP CONSTRAINT [FK_ActionUserDet_ActionUser];
 GO 
ALTER TABLE [dbo].[ActionUserDet] DROP CONSTRAINT [I_ActionUserDet];
 GO 
ALTER TABLE [dbo].[ActionUserDet] ALTER COLUMN [ActionUser] nVarChar(50) ;
 GO 
ALTER TABLE [dbo].[ActionUserDet] WITH NOCHECK ADD CONSTRAINT [FK_ActionUserDet_ActionUser] FOREIGN KEY ([ActionUser]) REFERENCES [dbo].[ActionUser]([ActionUser]);
 GO 
ALTER TABLE [dbo].[ActionUserDet] ADD CONSTRAINT [I_ActionUserDet] UNIQUE( [ActionCode] , [ActionUser] , [BType] , [SType] , [LOB] ) WITH (ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = OFF) ON [PRIMARY]
 GO 
ALTER TABLE [dbo].[ActionUserDet] ALTER COLUMN [Last_Opr] nVarChar(50) ;
 GO 
ALTER TABLE [dbo].[AdmLink] ALTER COLUMN [REMARKS] nVarChar(max) ;
 GO 
ALTER TABLE [dbo].[AdmLink] ALTER COLUMN [LUserID] nVarChar(50) ;
 GO 
ALTER TABLE [dbo].[AdmLink] ALTER COLUMN [VALUEDESC] nVarChar(255) ;
 GO 
ALTER TABLE [dbo].[AdmLink] ALTER COLUMN [Email] nVarChar(512) ;
 GO 
ALTER TABLE [dbo].[AEBucket] ALTER COLUMN [Last_Opr] nVarChar(50) ;
 GO 
ALTER TABLE [dbo].[AgeBand] ALTER COLUMN [Last_Opr] nVarChar(10) ;
 GO 
ALTER TABLE [dbo].[AIBucket] ALTER COLUMN [Last_Opr] nVarChar(50) ;
 GO 
ALTER TABLE [dbo].[AINFODET] ALTER COLUMN [CUserID] nVarChar(50) ;
 GO 
ALTER TABLE [dbo].[AINFODET] ALTER COLUMN [AUserID] nVarChar(50) ;
 GO 
ALTER TABLE [dbo].[AINFODET] ALTER COLUMN [RequestMessage] nVarChar(max) ;
 GO 
ALTER TABLE [dbo].[AINFODET] ALTER COLUMN [RequestName] nVarChar(50) ;
 GO 
ALTER TABLE [dbo].[AINFODET] ALTER COLUMN [ContractDescription] nVarChar(512) ;
 GO 
ALTER TABLE [dbo].[AINFODET] ALTER COLUMN [Last_Opr] nVarChar(50) ;
 GO 
ALTER TABLE [dbo].[AINFODETPIC] ALTER COLUMN [Last_Opr] nVarChar(50) ;
 GO 
ALTER TABLE [dbo].[AINPARTY] DROP CONSTRAINT [I_AINPARTY];
 GO 
ALTER TABLE [dbo].[AINPARTY] ALTER COLUMN [Name] nVarChar(255) ;
 GO 
ALTER TABLE [dbo].[AINPARTY] WITH NOCHECK ADD CONSTRAINT [I_AINPARTY] PRIMARY KEY NONCLUSTERED( [ANO] , [Name] ) WITH (ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = OFF) ON [PRIMARY]
 GO 
ALTER TABLE [dbo].[AINPARTY] ALTER COLUMN [Address_1] nVarChar(1024) ;
 GO 
ALTER TABLE [dbo].[AINPARTY] ALTER COLUMN [Address_2] nVarChar(1024) ;
 GO 
ALTER TABLE [dbo].[AINPARTY] ALTER COLUMN [REMARK] nVarChar(255) ;
 GO 
ALTER TABLE [dbo].[AINPARTY] ALTER COLUMN [Email] nVarChar(512) ;
 GO 
ALTER TABLE [dbo].[AINPARTY] ALTER COLUMN [Beneficiary_Name] nVarChar(255) ;
 GO 
ALTER TABLE [dbo].[akun_jkd] ALTER COLUMN [Description] nVarChar(100) ;
 GO 
ALTER TABLE [dbo].[akun_jkd] ALTER COLUMN [Last_Opr] nVarChar(10) ;
 GO 
ALTER TABLE [dbo].[akun_jkd] ALTER COLUMN [Description1] nVarChar(100) ;
 GO 
ALTER TABLE [dbo].[ALBucket] ALTER COLUMN [Remarks] nVarChar(255) ;
 GO 
ALTER TABLE [dbo].[ALBucket] ALTER COLUMN [Last_Opr] nVarChar(50) ;
 GO 
ALTER TABLE [dbo].[ALBucket] ALTER COLUMN [CUserID] nVarChar(50) ;
 GO 
ALTER TABLE [dbo].[ALBucket] ALTER COLUMN [PUserID] nVarChar(50) ;
 GO 
ALTER TABLE [dbo].[ALRule] ALTER COLUMN [Last_Opr] nVarChar(50) ;
 GO 
ALTER TABLE [dbo].[AmortizationD] ALTER COLUMN [Last_Opr] nVarChar(50) ;
 GO 
ALTER TABLE [dbo].[AmortizationH] ALTER COLUMN [Description] nVarChar(100) ;
 GO 
ALTER TABLE [dbo].[AmortizationH] ALTER COLUMN [Last_Opr] nVarChar(50) ;
 GO 
ALTER TABLE [dbo].[AmorType] ALTER COLUMN [Name] nVarChar(50) ;
 GO 
ALTER TABLE [dbo].[AmorType] ALTER COLUMN [Description] nVarChar(50) ;
 GO 
ALTER TABLE [dbo].[AmorType] ALTER COLUMN [Last_Opr] nVarChar(50) ;
 GO 
ALTER TABLE [dbo].[APayor] ALTER COLUMN [ADDRESS_1] nVarChar(1024) ;
 GO 
ALTER TABLE [dbo].[APayor] ALTER COLUMN [ADDRESS_2] nVarChar(1024) ;
 GO 
ALTER TABLE [dbo].[APayor] ALTER COLUMN [ADDRESS_3] nVarChar(1024) ;
 GO 
ALTER TABLE [dbo].[APayor] ALTER COLUMN [Remarks] nVarChar(255) ;
 GO 
ALTER TABLE [dbo].[APayor] ALTER COLUMN [LUserID] nVarChar(50) ;
 GO 
ALTER TABLE [dbo].[APBucket] ALTER COLUMN [Last_Opr] nVarChar(50) ;
 GO 
ALTER TABLE [dbo].[APDBucket] ALTER COLUMN [SaveLocationAttachment_8] nVarChar(255) ;
 GO 
ALTER TABLE [dbo].[APDBucket] ALTER COLUMN [SaveLocationAttachment_1] nVarChar(255) ;
 GO 
ALTER TABLE [dbo].[APDBucket] ALTER COLUMN [RepName] nVarChar(20) ;
 GO 
ALTER TABLE [dbo].[APDBucket] ALTER COLUMN [SaveLocationAttachment_5] nVarChar(255) ;
 GO 
ALTER TABLE [dbo].[APDBucket] ALTER COLUMN [SaveLocation] nVarChar(255) ;
 GO 
ALTER TABLE [dbo].[APDBucket] ALTER COLUMN [SaveLocationAttachment_2] nVarChar(255) ;
 GO 
ALTER TABLE [dbo].[APDBucket] ALTER COLUMN [Last_Opr] nVarChar(50) ;
 GO 
ALTER TABLE [dbo].[APDBucket] ALTER COLUMN [SaveLocationAttachment_3] nVarChar(255) ;
 GO 
ALTER TABLE [dbo].[APDBucket] ALTER COLUMN [SaveLocationAttachment_6] nVarChar(255) ;
 GO 
ALTER TABLE [dbo].[APDBucket] ALTER COLUMN [ExeName] nVarChar(255) ;
 GO 
ALTER TABLE [dbo].[APDBucket] ALTER COLUMN [SaveLocationAttachment_7] nVarChar(255) ;
 GO 
ALTER TABLE [dbo].[APDBucket] ALTER COLUMN [SaveLocationAttachment_4] nVarChar(255) ;
 GO 
ALTER TABLE [dbo].[APDBucket] ALTER COLUMN [EMailTo] nVarChar(10) ;
 GO 
ALTER TABLE [dbo].[APDRuleD] ALTER COLUMN [EMailTo] nVarChar(10) ;
 GO 
ALTER TABLE [dbo].[APDRuleD] ALTER COLUMN [Last_Opr] nVarChar(50) ;
 GO 
ALTER TABLE [dbo].[APDRuleD] ALTER COLUMN [RepName] nVarChar(20) ;
 GO 
ALTER TABLE [dbo].[APDRuleD] ALTER COLUMN [ExeName] nVarChar(255) ;
 GO 
ALTER TABLE [dbo].[APDRuleD_Insured] ALTER COLUMN [Last_Opr] nVarChar(50) ;
 GO 
ALTER TABLE [dbo].[APDRuleD_PHolder] ALTER COLUMN [Last_Opr] nVarChar(50) ;
 GO 
ALTER TABLE [dbo].[APDRuleD_Segment] ALTER COLUMN [Last_Opr] nVarChar(50) ;
 GO 
ALTER TABLE [dbo].[APDRuleH] ALTER COLUMN [EmailFrom] nVarChar(512) ;
 GO 
ALTER TABLE [dbo].[APDRuleH] ALTER COLUMN [EmailCC] nVarChar(512) ;
 GO 
ALTER TABLE [dbo].[APDRuleH] ALTER COLUMN [EmailBCC] nVarChar(512) ;
 GO 
ALTER TABLE [dbo].[APDRuleH] ALTER COLUMN [Last_Opr] nVarChar(50) ;
 GO 
ALTER TABLE [dbo].[ARBucket] ALTER COLUMN [pSLRef_Description_2] nVarChar(50) ;
 GO 
ALTER TABLE [dbo].[ARBucket] ALTER COLUMN [pSLRef_Description_3] nVarChar(50) ;
 GO 
DROP INDEX [dbo].[ARBucket].[I_ARBucket_Bank_AccountNo_Type_Subject_Currency_ProcName];
 GO 
ALTER TABLE [dbo].[ARBucket] ALTER COLUMN [Procname] nVarChar(100) ;
 GO 
CREATE NONCLUSTERED INDEX [I_ARBucket_Bank_AccountNo_Type_Subject_Currency_ProcName] ON [dbo].[ARBucket] (  [Bank] , [AccountNo] , [Type] , [Subject] , [Currency] , [Procname] )
 GO 
ALTER TABLE [dbo].[ARBucket] ALTER COLUMN [pSLRef_Description_1] nVarChar(50) ;
 GO 
ALTER TABLE [dbo].[ARBucket] ALTER COLUMN [Last_Opr] nVarChar(50) ;
 GO 
ALTER TABLE [dbo].[ARBucket] ALTER COLUMN [pSLRef_Description_5] nVarChar(50) ;
 GO 
ALTER TABLE [dbo].[ARBucket] ALTER COLUMN [pSLRef_Description_4] nVarChar(50) ;
 GO 
ALTER TABLE [dbo].[ARBucket_Backup20210301] ALTER COLUMN [Last_Opr] nVarChar(50) ;
 GO 
ALTER TABLE [dbo].[ARBucket_Backup20210301] ALTER COLUMN [Remarks] nVarChar(512) ;
 GO 
ALTER TABLE [dbo].[ARBucket_Backup20210301] ALTER COLUMN [Procname] nVarChar(100) ;
 GO 
ALTER TABLE [dbo].[Area] ALTER COLUMN [Last_Opr] nVarChar(50) ;
 GO 
ALTER TABLE [dbo].[Area] ALTER COLUMN [Description] nVarChar(50) ;
 GO 
ALTER TABLE [dbo].[AROSLog] ALTER COLUMN [CUserID] nVarChar(50) ;
 GO 
ALTER TABLE [dbo].[AROSLog] ALTER COLUMN [TBName] nVarChar(25) ;
 GO 
ALTER TABLE [dbo].[ARPRINTLOG] ALTER COLUMN [UserID] nVarChar(50) ;
 GO 
ALTER TABLE [dbo].[ARPRINTLOG] ALTER COLUMN [Description] nVarChar(50) ;
 GO 
ALTER TABLE [dbo].[AutoNum] ALTER COLUMN [Last_Opr] nVarChar(50) ;
 GO 
ALTER TABLE [dbo].[AutoNum] ALTER COLUMN [Description] nVarChar(50) ;
 GO 
ALTER TABLE [dbo].[AutoNum] ALTER COLUMN [TBName] nVarChar(50) ;
 GO 
ALTER TABLE [dbo].[Balance_Type] ALTER COLUMN [Description] nVarChar(100) ;
 GO 
ALTER TABLE [dbo].[Bank] ALTER COLUMN [ShortName] nVarChar(100) ;
 GO 
ALTER TABLE [dbo].[Bank] ALTER COLUMN [Description] nVarChar(100) ;
 GO 
ALTER TABLE [dbo].[Bank] ALTER COLUMN [Last_Opr] nVarChar(50) ;
 GO 
ALTER TABLE [dbo].[BankBranch] ALTER COLUMN [Last_Opr] nVarChar(50) ;
 GO 
ALTER TABLE [dbo].[BankBranch] ALTER COLUMN [Address_1] nVarChar(1024) ;
 GO 
ALTER TABLE [dbo].[BankBranch] ALTER COLUMN [Address_2] nVarChar(1024) ;
 GO 
ALTER TABLE [dbo].[BankBranch] ALTER COLUMN [Address_3] nVarChar(1024) ;
 GO 
ALTER TABLE [dbo].[BAssumption_Exchange] ALTER COLUMN [Last_Opr] nVarChar(50) ;
 GO 
ALTER TABLE [dbo].[BAssumption_Growth] ALTER COLUMN [Last_Opr] nVarChar(50) ;
 GO 
ALTER TABLE [dbo].[BAssumption_Rate] ALTER COLUMN [Last_Opr] nVarChar(50) ;
 GO 
ALTER TABLE [dbo].[BAssumption_Ratio] ALTER COLUMN [Last_Opr] nVarChar(50) ;
 GO 
ALTER TABLE [dbo].[BatchScreening] ALTER COLUMN [RepName] nVarChar(100) ;
 GO 
ALTER TABLE [dbo].[BDClass] ALTER COLUMN [Last_Opr] nVarChar(10) ;
 GO 
ALTER TABLE [dbo].[Beneficiaries] ALTER COLUMN [Address_1] nVarChar(1024) ;
 GO 
ALTER TABLE [dbo].[Beneficiaries] ALTER COLUMN [Address_2] nVarChar(1024) ;
 GO 
ALTER TABLE [dbo].[Beneficiaries] ALTER COLUMN [Email] nVarChar(512) ;
 GO 
ALTER TABLE [dbo].[Benefit] ALTER COLUMN [Name] nVarChar(200) ;
 GO 
ALTER TABLE [dbo].[Benefit] ALTER COLUMN [Name_1] nVarChar(100) ;
 GO 
ALTER TABLE [dbo].[Benefit] ALTER COLUMN [BShortDesc] nVarChar(16) ;
 GO 
ALTER TABLE [dbo].[Benefit] ALTER COLUMN [Last_Opr] nVarChar(10) ;
 GO 
ALTER TABLE [dbo].[Benefit_ExtMap] ALTER COLUMN [Last_Opr] nVarChar(10) ;
 GO 
ALTER TABLE [dbo].[Benefit_Rate] ALTER COLUMN [Last_Opr] nVarChar(10) ;
 GO 
ALTER TABLE [dbo].[BenefitEDCMap] ALTER COLUMN [Last_Opr] nVarChar(10) ;
 GO 
ALTER TABLE [dbo].[BIAsset] ALTER COLUMN [Name] nVarChar(50) ;
 GO 
ALTER TABLE [dbo].[BIAsset] ALTER COLUMN [Description] nVarChar(255) ;
 GO 
ALTER TABLE [dbo].[BIType] ALTER COLUMN [Description] nVarChar(255) ;
 GO 
ALTER TABLE [dbo].[BIType] ALTER COLUMN [Last_Opr] nVarChar(50) ;
 GO 
ALTER TABLE [dbo].[BIType] ALTER COLUMN [Name] nVarChar(50) ;
 GO 
ALTER TABLE [dbo].[BizMap] ALTER COLUMN [Last_Opr] nVarChar(50) ;
 GO 
ALTER TABLE [dbo].[BizMap] ALTER COLUMN [Description] nVarChar(100) ;
 GO 
ALTER TABLE [dbo].[Blanket] ALTER COLUMN [UserID] nVarChar(50) ;
 GO 
ALTER TABLE [dbo].[Blanket] ALTER COLUMN [LUserID] nVarChar(50) ;
 GO 
ALTER TABLE [dbo].[Blanket_Delivery] ALTER COLUMN [UserID] nVarChar(50) ;
 GO 
ALTER TABLE [dbo].[Blanket_Delivery] ALTER COLUMN [LUserID] nVarChar(50) ;
 GO 
ALTER TABLE [dbo].[Blanket_Delivery_Detail] ALTER COLUMN [UserID] nVarChar(50) ;
 GO 
ALTER TABLE [dbo].[Blanket_Delivery_Detail] ALTER COLUMN [LUserID] nVarChar(50) ;
 GO 
ALTER TABLE [dbo].[BPP] ALTER COLUMN [Last_Opr] nVarChar(50) ;
 GO 
ALTER TABLE [dbo].[BPP] ALTER COLUMN [Description] nVarChar(50) ;
 GO 
ALTER TABLE [dbo].[Branch] ALTER COLUMN [Last_Opr] nVarChar(50) ;
 GO 
ALTER TABLE [dbo].[Branch] ALTER COLUMN [Address] nVarChar(1024) ;
 GO 
ALTER TABLE [dbo].[Branch] ALTER COLUMN [SignerName] nVarChar(255) ;
 GO 
ALTER TABLE [dbo].[Branch] ALTER COLUMN [Email] nVarChar(512) ;
 GO 
ALTER TABLE [dbo].[Branch] ALTER COLUMN [SignerName_1] nVarChar(255) ;
 GO 
ALTER TABLE [dbo].[Branch] ALTER COLUMN [SignerName_2] nVarChar(255) ;
 GO 
ALTER TABLE [dbo].[branchcob] ALTER COLUMN [branchname] nVarChar(70) ;
 GO 
ALTER TABLE [dbo].[BranchMailAddress] ALTER COLUMN [RetailEmail] nVarChar(255) ;
 GO 
ALTER TABLE [dbo].[BranchMailAddress] ALTER COLUMN [ClaimEmail] nVarChar(255) ;
 GO 
ALTER TABLE [dbo].[branchtoc] ALTER COLUMN [branchname] nVarChar(70) ;
 GO 
ALTER TABLE [dbo].[BRRule] ALTER COLUMN [Last_Opr] nVarChar(50) ;
 GO 
ALTER TABLE [dbo].[BSOPEX] ALTER COLUMN [REMARK] nVarChar(50) ;
 GO 
ALTER TABLE [dbo].[BSOPEX] ALTER COLUMN [Last_Opr] nVarChar(50) ;
 GO 
ALTER TABLE [dbo].[BSOPEXDET] ALTER COLUMN [VALUEDESC13] nVarChar(255) ;
 GO 
ALTER TABLE [dbo].[BSOPEXDET] ALTER COLUMN [VALUEDESC12] nVarChar(255) ;
 GO 
ALTER TABLE [dbo].[BSOPEXDET] ALTER COLUMN [VALUEDESC15] nVarChar(255) ;
 GO 
ALTER TABLE [dbo].[BSOPEXDET] ALTER COLUMN [VALUEDESC14] nVarChar(255) ;
 GO 
ALTER TABLE [dbo].[BSOPEXDET] ALTER COLUMN [VALUEDESC10] nVarChar(255) ;
 GO 
ALTER TABLE [dbo].[BSOPEXDET] ALTER COLUMN [VALUEDESC7] nVarChar(255) ;
 GO 
ALTER TABLE [dbo].[BSOPEXDET] ALTER COLUMN [VALUEDESC11] nVarChar(255) ;
 GO 
ALTER TABLE [dbo].[BSOPEXDET] ALTER COLUMN [VALUEDESC8] nVarChar(255) ;
 GO 
ALTER TABLE [dbo].[BSOPEXDET] ALTER COLUMN [Last_Opr] nVarChar(50) ;
 GO 
ALTER TABLE [dbo].[BSOPEXDET] ALTER COLUMN [VALUEDESC1] nVarChar(255) ;
 GO 
ALTER TABLE [dbo].[BSOPEXDET] ALTER COLUMN [VALUEDESC6] nVarChar(255) ;
 GO 
ALTER TABLE [dbo].[BSOPEXDET] ALTER COLUMN [VALUEDESC9] nVarChar(255) ;
 GO 
ALTER TABLE [dbo].[BSOPEXDET] ALTER COLUMN [VALUEDESC5] nVarChar(255) ;
 GO 
ALTER TABLE [dbo].[BSOPEXDET] ALTER COLUMN [VALUEDESC3] nVarChar(255) ;
 GO 
ALTER TABLE [dbo].[BSOPEXDET] ALTER COLUMN [VALUEDESC4] nVarChar(255) ;
 GO 
ALTER TABLE [dbo].[BSOPEXDET] ALTER COLUMN [VALUEDESC2] nVarChar(255) ;
 GO 
ALTER TABLE [dbo].[BSTYPE] ALTER COLUMN [DESCRIPTION] nVarChar(20) ;
 GO 
ALTER TABLE [dbo].[CArrDetail] ALTER COLUMN [LUserID] nVarChar(50) ;
 GO 
ALTER TABLE [dbo].[CARRHEADER] ALTER COLUMN [LUserID] nVarChar(50) ;
 GO 
ALTER TABLE [dbo].[CBatchPrintLogH] ALTER COLUMN [UserID] nVarChar(10) ;
 GO 
ALTER TABLE [dbo].[CBatchPrintLogH] ALTER COLUMN [Description] nVarChar(50) ;
 GO 
ALTER TABLE [dbo].[CCTYPE] ALTER COLUMN [Last_Opr] nVarChar(50) ;
 GO 
ALTER TABLE [dbo].[CCTYPE] ALTER COLUMN [Description] nVarChar(255) ;
 GO 
ALTER TABLE [dbo].[CDOCLIST] ALTER COLUMN [DESCRIPTION] nVarChar(255) ;
 GO 
ALTER TABLE [dbo].[CDOCLIST] ALTER COLUMN [REMARKS] nVarChar(512) ;
 GO 
ALTER TABLE [dbo].[CDOCLIST] ALTER COLUMN [LAST_OPR] nVarChar(50) ;
 GO 
ALTER TABLE [dbo].[CDOCLISTPIC] ALTER COLUMN [Last_Opr] nVarChar(50) ;
 GO 
ALTER TABLE [dbo].[CDOCSTAT] ALTER COLUMN [Last_Opr] nVarChar(50) ;
 GO 
ALTER TABLE [dbo].[CFINDICATORD] ALTER COLUMN [REMARKS] nVarChar(255) ;
 GO 
ALTER TABLE [dbo].[CFINDICATORD] ALTER COLUMN [DESCRIPTION] nVarChar(255) ;
 GO 
ALTER TABLE [dbo].[CFINDICATORH] ALTER COLUMN [USERID] nVarChar(50) ;
 GO 
ALTER TABLE [dbo].[CFINDICATORH] ALTER COLUMN [LUSERID] nVarChar(50) ;
 GO 
ALTER TABLE [dbo].[CFINDICATORH] ALTER COLUMN [AUSERID] nVarChar(50) ;
 GO 
ALTER TABLE [dbo].[CFINDICATORH] ALTER COLUMN [CUSERID] nVarChar(50) ;
 GO 
ALTER TABLE [dbo].[CFINDICATORH] ALTER COLUMN [PUserID] nVarChar(50) ;
 GO 
ALTER TABLE [dbo].[CGroup] ALTER COLUMN [Last_Opr] nVarChar(50) ;
 GO 
ALTER TABLE [dbo].[CGroup] ALTER COLUMN [Description] nVarChar(100) ;
 GO 
ALTER TABLE [dbo].[Cheque] ALTER COLUMN [BankName] nVarChar(150) ;
 GO 
ALTER TABLE [dbo].[Cheque] ALTER COLUMN [Address] nVarChar(1024) ;
 GO 
ALTER TABLE [dbo].[Cheque] ALTER COLUMN [Location] nVarChar(10) ;
 GO 
ALTER TABLE [dbo].[Cheque] ALTER COLUMN [Last_Opr] nVarChar(50) ;
 GO 
ALTER TABLE [dbo].[City] ALTER COLUMN [Description_1] nVarChar(512) ;
 GO 
ALTER TABLE [dbo].[City] ALTER COLUMN [Last_OPR] nVarChar(10) ;
 GO 
ALTER TABLE [dbo].[City] ALTER COLUMN [Name] nVarChar(255) ;
 GO 
ALTER TABLE [dbo].[CLAASS] ALTER COLUMN [REFNAME] nVarChar(255) ;
 GO 
ALTER TABLE [dbo].[CLAIM] ALTER COLUMN [Location] nVarChar(10) ;
 GO 
ALTER TABLE [dbo].[CLAIM] ALTER COLUMN [UserID] nVarChar(50) ;
 GO 
ALTER TABLE [dbo].[CLAIM] ALTER COLUMN [CUSERID] nVarChar(50) ;
 GO 
ALTER TABLE [dbo].[CLAIM] ALTER COLUMN [LUserID] nVarChar(50) ;
 GO 
ALTER TABLE [dbo].[CLAIM] ALTER COLUMN [PUserID] nVarChar(50) ;
 GO 
ALTER TABLE [dbo].[CLAIM] ALTER COLUMN [AUserID] nVarChar(50) ;
 GO 
ALTER TABLE [dbo].[CLAIM] ALTER COLUMN [RequestName] nVarChar(50) ;
 GO 
ALTER TABLE [dbo].[CLAIM] ALTER COLUMN [SysUserID] nVarChar(50) ;
 GO 
ALTER TABLE [dbo].[CLAIM] ALTER COLUMN [ClaimantEmail] nVarChar(255) ;
 GO 
ALTER TABLE [dbo].[CLAIM] ALTER COLUMN [RUserID] nVarChar(50) ;
 GO 
ALTER TABLE [dbo].[CLAIM] ALTER COLUMN [ActionUser] nVarChar(50) ;
 GO 
ALTER TABLE [dbo].[CLAIM] ALTER COLUMN [SACAUserID] nVarChar(50) ;
 GO 
ALTER TABLE [dbo].[ClaimantType] ALTER COLUMN [Last_Opr] nVarChar(50) ;
 GO 
ALTER TABLE [dbo].[ClaimantType] ALTER COLUMN [Description] nVarChar(255) ;
 GO 
ALTER TABLE [dbo].[ClaimDailyRemarksDetail] ALTER COLUMN [Item] nVarChar(100) ;
 GO 
ALTER TABLE [dbo].[ClaimLedger] ALTER COLUMN [Description] nVarChar(50) ;
 GO 
ALTER TABLE [dbo].[ClaimPaymentSchedule] ALTER COLUMN [Last_Opr] nVarChar(50) ;
 GO 
ALTER TABLE [dbo].[CLComplaint] ALTER COLUMN [LUserID] nVarChar(50) ;
 GO 
ALTER TABLE [dbo].[CLComplaint] ALTER COLUMN [ReporterEmail] nVarChar(255) ;
 GO 
ALTER TABLE [dbo].[CLComplaint] ALTER COLUMN [CUserID] nVarChar(50) ;
 GO 
ALTER TABLE [dbo].[CLComplaint] ALTER COLUMN [UserID] nVarChar(50) ;
 GO 
ALTER TABLE [dbo].[CLCOST] ALTER COLUMN [RequestMessage] nVarChar(max) ;
 GO 
ALTER TABLE [dbo].[CLCOST] ALTER COLUMN [RequestName] nVarChar(50) ;
 GO 
ALTER TABLE [dbo].[CLCOST] ALTER COLUMN [Last_Opr] nVarChar(50) ;
 GO 
ALTER TABLE [dbo].[CLCOST] ALTER COLUMN [CUserID] nVarChar(50) ;
 GO 
ALTER TABLE [dbo].[CLCOST] ALTER COLUMN [AUserID] nVarChar(50) ;
 GO 
ALTER TABLE [dbo].[CLCOST] ALTER COLUMN [PICEmail] nVarChar(255) ;
 GO 
ALTER TABLE [dbo].[CLCOSTDET] DROP CONSTRAINT [I_CLCOSTDET];
 GO 
ALTER TABLE [dbo].[CLCOSTDET] ALTER COLUMN [Item] nVarChar(50) ;
 GO 
ALTER TABLE [dbo].[CLCOSTDET] WITH NOCHECK ADD CONSTRAINT [I_CLCOSTDET] PRIMARY KEY NONCLUSTERED( [CNO] , [ID] , [Currency] , [RefNo] , [CCTYPE] , [Item] ) WITH (ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = OFF) ON [PRIMARY]
 GO 
ALTER TABLE [dbo].[CLCOSTDET] ALTER COLUMN [Description] nVarChar(255) ;
 GO 
ALTER TABLE [dbo].[CLCOSTPIC] ALTER COLUMN [Remark] nVarChar(max) ;
 GO 
ALTER TABLE [dbo].[CLCOSTPIC] ALTER COLUMN [Last_Opr] nVarChar(50) ;
 GO 
ALTER TABLE [dbo].[CLDED] ALTER COLUMN [Last_Opr] nVarChar(50) ;
 GO 
ALTER TABLE [dbo].[CLDED] ALTER COLUMN [REMARK] nVarChar(2048) ;
 GO 
ALTER TABLE [dbo].[CLDED] ALTER COLUMN [DESCRIPTION] nVarChar(2048) ;
 GO 
ALTER TABLE [dbo].[CLFACDED] ALTER COLUMN [REMARK] nVarChar(2048) ;
 GO 
ALTER TABLE [dbo].[CLFACDED] ALTER COLUMN [Last_Opr] nVarChar(50) ;
 GO 
ALTER TABLE [dbo].[CLFACDED] ALTER COLUMN [DESCRIPTION] nVarChar(2048) ;
 GO 
ALTER TABLE [dbo].[CLFD] ALTER COLUMN [Last_Opr] nVarChar(50) ;
 GO 
ALTER TABLE [dbo].[CLINFO] ALTER COLUMN [Last_Opr] nVarChar(50) ;
 GO 
ALTER TABLE [dbo].[CLINFOSUPL] ALTER COLUMN [Last_Opr] nVarChar(50) ;
 GO 
ALTER TABLE [dbo].[CLINKLOG] ALTER COLUMN [UserID] nVarChar(50) ;
 GO 
ALTER TABLE [dbo].[CLLOSS] ALTER COLUMN [Last_Opr] nVarChar(50) ;
 GO 
ALTER TABLE [dbo].[CLNOTES] ALTER COLUMN [UserID] nVarChar(50) ;
 GO 
ALTER TABLE [dbo].[CLNotify] ALTER COLUMN [UserID] nVarChar(50) ;
 GO 
ALTER TABLE [dbo].[CLNotify] ALTER COLUMN [Last_Opr] nVarChar(50) ;
 GO 
ALTER TABLE [dbo].[CLNStatus] ALTER COLUMN [Last_Opr] nVarChar(50) ;
 GO 
ALTER TABLE [dbo].[CLNStatus] ALTER COLUMN [Description] nVarChar(255) ;
 GO 
ALTER TABLE [dbo].[CLPIC] ALTER COLUMN [UserID] nVarChar(50) ;
 GO 
ALTER TABLE [dbo].[CLPIC] ALTER COLUMN [Last_Opr] nVarChar(50) ;
 GO 
ALTER TABLE [dbo].[CLPrintLog] ALTER COLUMN [Description] nVarChar(50) ;
 GO 
ALTER TABLE [dbo].[CLPrintLog] ALTER COLUMN [UserID] nVarChar(50) ;
 GO 
ALTER TABLE [dbo].[CLProcess] ALTER COLUMN [Last_Opr] nVarChar(50) ;
 GO 
ALTER TABLE [dbo].[CLSAL] ALTER COLUMN [Last_Opr] nVarChar(50) ;
 GO 
ALTER TABLE [dbo].[CLSALITEM] ALTER COLUMN [Location] nVarChar(10) ;
 GO 
ALTER TABLE [dbo].[CLSALITEM] ALTER COLUMN [Last_Opr] nVarChar(50) ;
 GO 
ALTER TABLE [dbo].[CLSub] ALTER COLUMN [PIC_NAME_1] nVarChar(50) ;
 GO 
ALTER TABLE [dbo].[CLSub] ALTER COLUMN [Last_Opr] nVarChar(50) ;
 GO 
ALTER TABLE [dbo].[CLSub] ALTER COLUMN [PIC_NAME_2] nVarChar(50) ;
 GO 
ALTER TABLE [dbo].[CLSub] ALTER COLUMN [Name] nVarChar(255) ;
 GO 
ALTER TABLE [dbo].[CLSub] ALTER COLUMN [Address_1] nVarChar(1024) ;
 GO 
ALTER TABLE [dbo].[CLSub] ALTER COLUMN [Address_2] nVarChar(1024) ;
 GO 
ALTER TABLE [dbo].[CLSub] ALTER COLUMN [Address_3] nVarChar(1024) ;
 GO 
ALTER TABLE [dbo].[CLSub] ALTER COLUMN [PIC_NAME_3] nVarChar(50) ;
 GO 
ALTER TABLE [dbo].[CLSUBPIC] ALTER COLUMN [Remark] nVarChar(max) ;
 GO 
ALTER TABLE [dbo].[CLSUBPIC] ALTER COLUMN [Last_Opr] nVarChar(50) ;
 GO 
ALTER TABLE [dbo].[CLSurvey] ALTER COLUMN [Last_Opr] nVarChar(50) ;
 GO 
ALTER TABLE [dbo].[COB] ALTER COLUMN [Last_Opr] nVarChar(50) ;
 GO 
ALTER TABLE [dbo].[COB] ALTER COLUMN [DESCRIPTION] nVarChar(50) ;
 GO 
ALTER TABLE [dbo].[COB] ALTER COLUMN [DESCRIPTION_1] nVarChar(50) ;
 GO 
ALTER TABLE [dbo].[COBGROUP] ALTER COLUMN [Description] nVarChar(255) ;
 GO 
ALTER TABLE [dbo].[COBGROUP] ALTER COLUMN [Last_Opr] nVarChar(50) ;
 GO 
ALTER TABLE [dbo].[COINSURANCE] ALTER COLUMN [LUserID] nVarChar(50) ;
 GO 
ALTER TABLE [dbo].[COINSURANCE] ALTER COLUMN [USERID] nVarChar(50) ;
 GO 
ALTER TABLE [dbo].[COL] ALTER COLUMN [Last_Opr] nVarChar(50) ;
 GO 
ALTER TABLE [dbo].[COLLATERAL] ALTER COLUMN [LAST_OPR] nVarChar(50) ;
 GO 
ALTER TABLE [dbo].[COLLATERAL] ALTER COLUMN [DESCRIPTION] nVarChar(255) ;
 GO 
ALTER TABLE [dbo].[COLLATERAL] ALTER COLUMN [REMARKS] nVarChar(512) ;
 GO 
ALTER TABLE [dbo].[COLLATERAL] ALTER COLUMN [Attrib_1] nVarChar(100) ;
 GO 
ALTER TABLE [dbo].[COLLATERAL] ALTER COLUMN [Attrib_2] nVarChar(100) ;
 GO 
ALTER TABLE [dbo].[COLLATERAL] ALTER COLUMN [Attrib_3] nVarChar(100) ;
 GO 
ALTER TABLE [dbo].[COLLATERAL] ALTER COLUMN [Attrib_4] nVarChar(100) ;
 GO 
ALTER TABLE [dbo].[COLLATERAL] ALTER COLUMN [Attrib_5] nVarChar(100) ;
 GO 
ALTER TABLE [dbo].[COLLATERAL] ALTER COLUMN [Attrib_6] nVarChar(100) ;
 GO 
ALTER TABLE [dbo].[COLLATERAL] ALTER COLUMN [Attrib_7] nVarChar(100) ;
 GO 
ALTER TABLE [dbo].[COLLATERAL] ALTER COLUMN [Attrib_8] nVarChar(100) ;
 GO 
ALTER TABLE [dbo].[COLLATERAL] ALTER COLUMN [Attrib_9] nVarChar(100) ;
 GO 
ALTER TABLE [dbo].[COLLATERAL] ALTER COLUMN [Attrib_10] nVarChar(100) ;
 GO 
ALTER TABLE [dbo].[COLLATERALPIC] ALTER COLUMN [Remark] nVarChar(max) ;
 GO 
ALTER TABLE [dbo].[COLLATERALPIC] ALTER COLUMN [Last_Opr] nVarChar(50) ;
 GO 
ALTER TABLE [dbo].[COLLATERALSUBTYPE] ALTER COLUMN [Last_Opr] nVarChar(50) ;
 GO 
ALTER TABLE [dbo].[COLLATERALSUBTYPE] ALTER COLUMN [Description] nVarChar(255) ;
 GO 
ALTER TABLE [dbo].[COLLATERALTYPE] ALTER COLUMN [Description] nVarChar(255) ;
 GO 
ALTER TABLE [dbo].[COLLATERALTYPE] ALTER COLUMN [Last_Opr] nVarChar(50) ;
 GO 
ALTER TABLE [dbo].[CollectionB] ALTER COLUMN [BankName] nVarChar(150) ;
 GO 
ALTER TABLE [dbo].[COLLECTIOND] ALTER COLUMN [AName] nVarChar(max) ;
 GO 
ALTER TABLE [dbo].[COLLECTIONH] ALTER COLUMN [Last_Opr] nVarChar(50) ;
 GO 
ALTER TABLE [dbo].[COLLECTIONH] ALTER COLUMN [ContactAddress] nVarChar(255) ;
 GO 
ALTER TABLE [dbo].[COLLRESULT] ALTER COLUMN [Last_Opr] nVarChar(50) ;
 GO 
ALTER TABLE [dbo].[COLLTYPE] ALTER COLUMN [Description] nVarChar(255) ;
 GO 
ALTER TABLE [dbo].[CollType_RRule] ALTER COLUMN [Description] nVarChar(255) ;
 GO 
ALTER TABLE [dbo].[CollType_RRule] ALTER COLUMN [Last_Opr] nVarChar(50) ;
 GO 
ALTER TABLE [dbo].[COLNOCClass] ALTER COLUMN [Last_Opr] nVarChar(50) ;
 GO 
ALTER TABLE [dbo].[COLTAB] ALTER COLUMN [DESCRIPTION] nVarChar(255) ;
 GO 
ALTER TABLE [dbo].[COLTAB] ALTER COLUMN [Last_Opr] nVarChar(50) ;
 GO 
ALTER TABLE [dbo].[ComAcc] ALTER COLUMN [LAST_OPR] nVarChar(50) ;
 GO 
ALTER TABLE [dbo].[ComAcc] ALTER COLUMN [BankName] nVarChar(255) ;
 GO 
ALTER TABLE [dbo].[ComAcc] ALTER COLUMN [PUserID] nVarChar(50) ;
 GO 
ALTER TABLE [dbo].[ComAcc] ALTER COLUMN [USERID] nVarChar(50) ;
 GO 
ALTER TABLE [dbo].[ComAcc_Cheque] ALTER COLUMN [Last_Opr] nVarChar(50) ;
 GO 
ALTER TABLE [dbo].[CompanyRelationType] ALTER COLUMN [Description] nVarChar(255) ;
 GO 
ALTER TABLE [dbo].[CompanyRelationType] ALTER COLUMN [Last_Opr] nVarChar(50) ;
 GO 
ALTER TABLE [dbo].[ComplaintType] ALTER COLUMN [Description] nVarChar(100) ;
 GO 
ALTER TABLE [dbo].[ComplaintType] ALTER COLUMN [Last_Opr] nVarChar(50) ;
 GO 
ALTER TABLE [dbo].[COMPLIANCE] ALTER COLUMN [LAST_OPR] nVarChar(50) ;
 GO 
ALTER TABLE [dbo].[COMPLIANCEI] ALTER COLUMN [LAST_OPR] nVarChar(50) ;
 GO 
ALTER TABLE [dbo].[COMPLIANCER] ALTER COLUMN [LAST_OPR] nVarChar(50) ;
 GO 
ALTER TABLE [dbo].[COMPLIANCES] ALTER COLUMN [SDESCRIPTION] nVarChar(255) ;
 GO 
ALTER TABLE [dbo].[COMPLIANCET] ALTER COLUMN [LAST_OPR] nVarChar(50) ;
 GO 
ALTER TABLE [dbo].[COMPLIANCEU] ALTER COLUMN [LAST_OPR] nVarChar(50) ;
 GO 
ALTER TABLE [dbo].[COMPLIANCEUI] ALTER COLUMN [LAST_OPR] nVarChar(50) ;
 GO 
ALTER TABLE [dbo].[Consent] ALTER COLUMN [Last_OPR] nVarChar(50) ;
 GO 
ALTER TABLE [dbo].[Consent] ALTER COLUMN [Description] nVarChar(512) ;
 GO 
ALTER TABLE [dbo].[Country] ALTER COLUMN [Last_Opr] nVarChar(50) ;
 GO 
ALTER TABLE [dbo].[Country] ALTER COLUMN [Description] nVarChar(50) ;
 GO 
ALTER TABLE [dbo].[CountryGroup] ALTER COLUMN [Description] nVarChar(100) ;
 GO 
ALTER TABLE [dbo].[CountryGroup] ALTER COLUMN [Last_Opr] nVarChar(50) ;
 GO 
ALTER TABLE [dbo].[COVEMPCONTD] ALTER COLUMN [REMARKS] nVarChar(255) ;
 GO 
ALTER TABLE [dbo].[COVEMPCONTH] ALTER COLUMN [REMARKS] nVarChar(512) ;
 GO 
ALTER TABLE [dbo].[COVEMPCONTH] ALTER COLUMN [USERID] nVarChar(50) ;
 GO 
ALTER TABLE [dbo].[COVEMPCONTH] ALTER COLUMN [LUSERID] nVarChar(50) ;
 GO 
ALTER TABLE [dbo].[COVEMPCONTH] ALTER COLUMN [AUSERID] nVarChar(50) ;
 GO 
ALTER TABLE [dbo].[COVEMPCONTH] ALTER COLUMN [CUSERID] nVarChar(50) ;
 GO 
ALTER TABLE [dbo].[COVEMPCONTH] ALTER COLUMN [PUserID] nVarChar(50) ;
 GO 
ALTER TABLE [dbo].[COVER] ALTER COLUMN [USERID] nVarChar(50) ;
 GO 
ALTER TABLE [dbo].[COVER] ALTER COLUMN [LUSERID] nVarChar(50) ;
 GO 
ALTER TABLE [dbo].[COVER] ALTER COLUMN [AUSERID] nVarChar(50) ;
 GO 
ALTER TABLE [dbo].[COVER] ALTER COLUMN [CUSERID] nVarChar(50) ;
 GO 
ALTER TABLE [dbo].[COVER] ALTER COLUMN [PUserID] nVarChar(50) ;
 GO 
ALTER TABLE [dbo].[Cover_Note] ALTER COLUMN [ADDRESS_2] nVarChar(255) ;
 GO 
ALTER TABLE [dbo].[Cover_Note] ALTER COLUMN [VALUEDESC1] nVarChar(255) ;
 GO 
ALTER TABLE [dbo].[Cover_Note] ALTER COLUMN [VALUEDESC3] nVarChar(255) ;
 GO 
ALTER TABLE [dbo].[Cover_Note] ALTER COLUMN [VALUEDESC2] nVarChar(255) ;
 GO 
ALTER TABLE [dbo].[Cover_Note] ALTER COLUMN [LUserID] nVarChar(10) ;
 GO 
ALTER TABLE [dbo].[Cover_Note] ALTER COLUMN [AName] nVarChar(1024) ;
 GO 
ALTER TABLE [dbo].[Cover_Note] ALTER COLUMN [VALUEDESC4] nVarChar(255) ;
 GO 
ALTER TABLE [dbo].[Cover_Note] ALTER COLUMN [CONSIGNEE_ADDRESS] nVarChar(255) ;
 GO 
ALTER TABLE [dbo].[Cover_Note] ALTER COLUMN [INTERESTREMARK] nVarChar(1024) ;
 GO 
ALTER TABLE [dbo].[Cover_Note] ALTER COLUMN [VALUEDESC15] nVarChar(255) ;
 GO 
ALTER TABLE [dbo].[Cover_Note] ALTER COLUMN [Address] nVarChar(255) ;
 GO 
ALTER TABLE [dbo].[Cover_Note] ALTER COLUMN [SurveyAgentName] nVarChar(255) ;
 GO 
ALTER TABLE [dbo].[Cover_Note] ALTER COLUMN [VESSELNAME] nVarChar(255) ;
 GO 
ALTER TABLE [dbo].[Cover_Note] ALTER COLUMN [VALUEDESC10] nVarChar(255) ;
 GO 
ALTER TABLE [dbo].[Cover_Note] ALTER COLUMN [VALUEDESC11] nVarChar(255) ;
 GO 
ALTER TABLE [dbo].[Cover_Note] ALTER COLUMN [VALUEDESC13] nVarChar(255) ;
 GO 
ALTER TABLE [dbo].[Cover_Note] ALTER COLUMN [VALUEDESC] nVarChar(255) ;
 GO 
ALTER TABLE [dbo].[Cover_Note] ALTER COLUMN [VALUEDESC12] nVarChar(255) ;
 GO 
ALTER TABLE [dbo].[Cover_Note] ALTER COLUMN [VALUEDESC14] nVarChar(255) ;
 GO 
ALTER TABLE [dbo].[Cover_Note] ALTER COLUMN [VALUEDESC5] nVarChar(255) ;
 GO 
ALTER TABLE [dbo].[Cover_Note] ALTER COLUMN [VALUEDESC6] nVarChar(255) ;
 GO 
ALTER TABLE [dbo].[Cover_Note] ALTER COLUMN [VALUEDESC8] nVarChar(255) ;
 GO 
ALTER TABLE [dbo].[Cover_Note] ALTER COLUMN [VALUEDESC7] nVarChar(255) ;
 GO 
ALTER TABLE [dbo].[Cover_Note] ALTER COLUMN [ADDRESS_3] nVarChar(255) ;
 GO 
ALTER TABLE [dbo].[Cover_Note] ALTER COLUMN [VALUEDESC9] nVarChar(255) ;
 GO 
ALTER TABLE [dbo].[CoverNote_SI] ALTER COLUMN [Description] nVarChar(1024) ;
 GO 
ALTER TABLE [dbo].[CoverNote_Transhipment] ALTER COLUMN [VesselName] nVarChar(150) ;
 GO 
DROP INDEX [dbo].[CPrintLog].[I_CPrintLog_CollNo_DocNo_Description];
 GO 
ALTER TABLE [dbo].[CPrintLog] ALTER COLUMN [Description] nVarChar(50) ;
 GO 
CREATE NONCLUSTERED INDEX [I_CPrintLog_CollNo_DocNo_Description] ON [dbo].[CPrintLog] (  [CollNo] , [DocNo] , [Description] )
 GO 
ALTER TABLE [dbo].[CPrintLog] ALTER COLUMN [UserID] nVarChar(50) ;
 GO 
ALTER TABLE [dbo].[CPrintLogH] ALTER COLUMN [Description] nVarChar(50) ;
 GO 
ALTER TABLE [dbo].[CPrintLogH] ALTER COLUMN [UserID] nVarChar(10) ;
 GO 
ALTER TABLE [dbo].[CSTALLOCATIONH] ALTER COLUMN [Last_Opr] nVarChar(50) ;
 GO 
ALTER TABLE [dbo].[CSType] ALTER COLUMN [Last_Opr] nVarChar(50) ;
 GO 
ALTER TABLE [dbo].[CSType] ALTER COLUMN [Description] nVarChar(255) ;
 GO 
ALTER TABLE [dbo].[CT] ALTER COLUMN [Last_Opr] nVarChar(50) ;
 GO 
ALTER TABLE [dbo].[CT] ALTER COLUMN [Description] nVarChar(50) ;
 GO 
ALTER TABLE [dbo].[Currency] ALTER COLUMN [Description] nVarChar(50) ;
 GO 
ALTER TABLE [dbo].[Currency] ALTER COLUMN [Last_Opr] nVarChar(50) ;
 GO 
ALTER TABLE [dbo].[DConvD] ALTER COLUMN [FName] nVarChar(50) ;
 GO 
ALTER TABLE [dbo].[DConvH] ALTER COLUMN [Description] nVarChar(50) ;
 GO 
ALTER TABLE [dbo].[DebtorGroup] ALTER COLUMN [Description] nVarChar(255) ;
 GO 
ALTER TABLE [dbo].[DebtorGroup] ALTER COLUMN [Last_Opr] nVarChar(50) ;
 GO 
ALTER TABLE [dbo].[DEDTAB] ALTER COLUMN [REMARKS] nVarChar(2048) ;
 GO 
ALTER TABLE [dbo].[DEDTAB] ALTER COLUMN [REMARKS_1] nVarChar(2048) ;
 GO 
ALTER TABLE [dbo].[DEDTAB] ALTER COLUMN [Last_Opr] nVarChar(50) ;
 GO 
ALTER TABLE [dbo].[DefCLA] ALTER COLUMN [SHORTDESC] nVarChar(max) ;
 GO 
ALTER TABLE [dbo].[DefCLA] ALTER COLUMN [ShortDesc_1] nVarChar(max) ;
 GO 
ALTER TABLE [dbo].[DefCON] ALTER COLUMN [SHORTDESC] nVarChar(max) ;
 GO 
ALTER TABLE [dbo].[DefCON] ALTER COLUMN [ShortDesc_1] nVarChar(max) ;
 GO 
ALTER TABLE [dbo].[DefEX] ALTER COLUMN [SHORTDESC] nVarChar(max) ;
 GO 
ALTER TABLE [dbo].[DefEX] ALTER COLUMN [ShortDesc_1] nVarChar(max) ;
 GO 
ALTER TABLE [dbo].[DelAdd] ALTER COLUMN [ADDRESS] nVarChar(255) ;
 GO 
ALTER TABLE [dbo].[Department] ALTER COLUMN [Description] nVarChar(255) ;
 GO 
ALTER TABLE [dbo].[Department] ALTER COLUMN [Last_Opr] nVarChar(50) ;
 GO 
ALTER TABLE [dbo].[Deposit] ALTER COLUMN [LUserID] nVarChar(50) ;
 GO 
ALTER TABLE [dbo].[Deposit] ALTER COLUMN [AUserID] nVarChar(50) ;
 GO 
ALTER TABLE [dbo].[Deposit] ALTER COLUMN [CUserID] nVarChar(50) ;
 GO 
ALTER TABLE [dbo].[DepositRecovery] ALTER COLUMN [Remarks] nVarChar(255) ;
 GO 
ALTER TABLE [dbo].[Diagnosis] ALTER COLUMN [Name] nVarChar(255) ;
 GO 
ALTER TABLE [dbo].[Diagnosis] ALTER COLUMN [Last_Opr] nVarChar(10) ;
 GO 
ALTER TABLE [dbo].[DISTAB] ALTER COLUMN [DESCRIPTION] nVarChar(255) ;
 GO 
ALTER TABLE [dbo].[DISTAB] ALTER COLUMN [Last_Opr] nVarChar(50) ;
 GO 
ALTER TABLE [dbo].[District] ALTER COLUMN [Last_OPR] nVarChar(10) ;
 GO 
ALTER TABLE [dbo].[Division] ALTER COLUMN [Last_Opr] nVarChar(50) ;
 GO 
ALTER TABLE [dbo].[Division] ALTER COLUMN [Description] nVarChar(255) ;
 GO 
ALTER TABLE [dbo].[DOCLIST] ALTER COLUMN [DESCRIPTION] nVarChar(255) ;
 GO 
ALTER TABLE [dbo].[DocStat] ALTER COLUMN [Description] nVarChar(100) ;
 GO 
ALTER TABLE [dbo].[DocStat] ALTER COLUMN [Last_Opr] nVarChar(50) ;
 GO 
ALTER TABLE [dbo].[DOCTYPE] ALTER COLUMN [DESCRIPTION] nVarChar(255) ;
 GO 
ALTER TABLE [dbo].[DOCTYPE] ALTER COLUMN [Last_Opr] nVarChar(50) ;
 GO 
ALTER TABLE [dbo].[DType] ALTER COLUMN [Description] nVarChar(255) ;
 GO 
ALTER TABLE [dbo].[DType] ALTER COLUMN [Last_Opr] nVarChar(50) ;
 GO 
ALTER TABLE [dbo].[Due_Date] ALTER COLUMN [Name] nVarChar(50) ;
 GO 
ALTER TABLE [dbo].[ECUTYPE] ALTER COLUMN [Description] nVarChar(512) ;
 GO 
ALTER TABLE [dbo].[EIS_HEADER] ALTER COLUMN [Last_OPR] nVarChar(50) ;
 GO 
ALTER TABLE [dbo].[EIS_HEADER] ALTER COLUMN [Description] nVarChar(255) ;
 GO 
ALTER TABLE [dbo].[EIS_Profile] ALTER COLUMN [Last_OPR] nVarChar(50) ;
 GO 
ALTER TABLE [dbo].[Email_Accumulation_Address] DROP CONSTRAINT [PK_Email_Accumulation_Address];
 GO 
ALTER TABLE [dbo].[Email_Accumulation_Address] ALTER COLUMN [EmailAddress] nVarChar(255) ;
 GO 
ALTER TABLE [dbo].[Email_Accumulation_Address] WITH NOCHECK ADD CONSTRAINT [PK_Email_Accumulation_Address] PRIMARY KEY NONCLUSTERED( [EmailAddress] ) WITH (ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = OFF) ON [PRIMARY]
 GO 
ALTER TABLE [dbo].[Email_Notification_Address] DROP CONSTRAINT [PK_Email_Notification_Address];
 GO 
ALTER TABLE [dbo].[Email_Notification_Address] ALTER COLUMN [EmailAddress] nVarChar(255) ;
 GO 
ALTER TABLE [dbo].[Email_Notification_Address] WITH NOCHECK ADD CONSTRAINT [PK_Email_Notification_Address] PRIMARY KEY NONCLUSTERED( [ID] , [EmailAddress] ) WITH (ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = OFF) ON [PRIMARY]
 GO 
ALTER TABLE [dbo].[Email_Parameter] DROP CONSTRAINT [PK_Email_Parameter];
 GO 
ALTER TABLE [dbo].[Email_Parameter] ALTER COLUMN [EmailSender] nVarChar(255) ;
 GO 
ALTER TABLE [dbo].[Email_Parameter] WITH NOCHECK ADD CONSTRAINT [PK_Email_Parameter] PRIMARY KEY NONCLUSTERED( [EmailSender] ) WITH (ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = OFF) ON [PRIMARY]
 GO 
ALTER TABLE [dbo].[Email_Parameter] ALTER COLUMN [AssuredName] nVarChar(255) ;
 GO 
ALTER TABLE [dbo].[EMPLOYMENT] ALTER COLUMN [Last_Opr] nVarChar(50) ;
 GO 
ALTER TABLE [dbo].[EMPLOYMENT] ALTER COLUMN [Description] nVarChar(255) ;
 GO 
ALTER TABLE [dbo].[EncryptField] ALTER COLUMN [ControlName] nVarChar(255) ;
 GO 
ALTER TABLE [dbo].[EncryptField] ALTER COLUMN [FormName] nVarChar(255) ;
 GO 
ALTER TABLE [dbo].[EncryptField] ALTER COLUMN [LUserID] nVarChar(50) ;
 GO 
ALTER TABLE [dbo].[EncryptField] ALTER COLUMN [FieldName] nVarChar(255) ;
 GO 
ALTER TABLE [dbo].[EUnit] ALTER COLUMN [REMARK] nVarChar(100) ;
 GO 
ALTER TABLE [dbo].[EUnit] ALTER COLUMN [DESCRIPTION] nVarChar(100) ;
 GO 
ALTER TABLE [dbo].[EUnit] ALTER COLUMN [REMARK_1] nVarChar(100) ;
 GO 
ALTER TABLE [dbo].[EUnit] ALTER COLUMN [DESCRIPTION_1] nVarChar(100) ;
 GO 
ALTER TABLE [dbo].[Event] ALTER COLUMN [Last_Opr] nVarChar(50) ;
 GO 
ALTER TABLE [dbo].[Event] ALTER COLUMN [Location] nVarChar(10) ;
 GO 
ALTER TABLE [dbo].[Excel] ALTER COLUMN [Excel_Name] nVarChar(100) ;
 GO 
ALTER TABLE [dbo].[Excel] ALTER COLUMN [Description] nVarChar(250) ;
 GO 
ALTER TABLE [dbo].[Excel] ALTER COLUMN [Last_Opr] nVarChar(50) ;
 GO 
ALTER TABLE [dbo].[Exchange] ALTER COLUMN [Last_Opr] nVarChar(50) ;
 GO 
ALTER TABLE [dbo].[FACCLA] ALTER COLUMN [ShortDesc_1] nVarChar(max) ;
 GO 
ALTER TABLE [dbo].[FACCLA] ALTER COLUMN [SHORTDESC] nVarChar(max) ;
 GO 
ALTER TABLE [dbo].[FACCON] ALTER COLUMN [SHORTDESC] nVarChar(max) ;
 GO 
ALTER TABLE [dbo].[FACCON] ALTER COLUMN [ShortDesc_1] nVarChar(max) ;
 GO 
ALTER TABLE [dbo].[FACEX] ALTER COLUMN [ShortDesc_1] nVarChar(max) ;
 GO 
ALTER TABLE [dbo].[FACEX] ALTER COLUMN [SHORTDESC] nVarChar(max) ;
 GO 
ALTER TABLE [dbo].[FACPIC] ALTER COLUMN [Remark] nVarChar(max) ;
 GO 
ALTER TABLE [dbo].[FACPIC] ALTER COLUMN [UserID] nVarChar(50) ;
 GO 
ALTER TABLE [dbo].[FACPIC] ALTER COLUMN [Last_Opr] nVarChar(50) ;
 GO 
ALTER TABLE [dbo].[FANOTES] ALTER COLUMN [UserID] nVarChar(50) ;
 GO 
ALTER TABLE [dbo].[FDEDUCTIBLE] ALTER COLUMN [REMARKS] nVarChar(2048) ;
 GO 
ALTER TABLE [dbo].[FDEDUCTIBLE] ALTER COLUMN [REMARKS_1] nVarChar(2048) ;
 GO 
ALTER TABLE [dbo].[FDTAB] ALTER COLUMN [DESCRIPTION] nVarChar(50) ;
 GO 
ALTER TABLE [dbo].[FDTAB] ALTER COLUMN [Last_Opr] nVarChar(50) ;
 GO 
ALTER TABLE [dbo].[FDTABDET] ALTER COLUMN [Last_Opr] nVarChar(50) ;
 GO 
ALTER TABLE [dbo].[FINDICATOR] ALTER COLUMN [LAST_OPR] nVarChar(50) ;
 GO 
ALTER TABLE [dbo].[FINDICATOR] ALTER COLUMN [DESCRIPTION] nVarChar(255) ;
 GO 
ALTER TABLE [dbo].[FINDICATORI] ALTER COLUMN [LAST_OPR] nVarChar(50) ;
 GO 
ALTER TABLE [dbo].[FINDICATORR] ALTER COLUMN [DESCRIPTION] nVarChar(255) ;
 GO 
ALTER TABLE [dbo].[FINDICATORR] ALTER COLUMN [SPNAME] nVarChar(255) ;
 GO 
ALTER TABLE [dbo].[FINDICATORR] ALTER COLUMN [LAST_OPR] nVarChar(50) ;
 GO 
ALTER TABLE [dbo].[FINDICATORT] ALTER COLUMN [LAST_OPR] nVarChar(50) ;
 GO 
ALTER TABLE [dbo].[FINDICATORU] ALTER COLUMN [LAST_OPR] nVarChar(50) ;
 GO 
ALTER TABLE [dbo].[FINDICATORUI] ALTER COLUMN [LAST_OPR] nVarChar(50) ;
 GO 
ALTER TABLE [dbo].[FLScaleTab] ALTER COLUMN [Last_Opr] nVarChar(50) ;
 GO 
DROP INDEX [dbo].[FSAMAPPING].[I_FSAMAPPING];
 GO 
ALTER TABLE [dbo].[FSAMAPPING] ALTER COLUMN [TBName] nVarChar(50) ;
 GO 
CREATE UNIQUE NONCLUSTERED INDEX [I_FSAMAPPING] ON [dbo].[FSAMAPPING] (  [TBName] , [Code] )
 GO 
ALTER TABLE [dbo].[FSAMAPPING] ALTER COLUMN [FSADESCRIPTION] nVarChar(255) ;
 GO 
ALTER TABLE [dbo].[FSAMappingIDRef] ALTER COLUMN [Description] nVarChar(255) ;
 GO 
ALTER TABLE [dbo].[GENCLA] ALTER COLUMN [SHORTDESC] nVarChar(max) ;
 GO 
ALTER TABLE [dbo].[GENCLA] ALTER COLUMN [ShortDesc_1] nVarChar(max) ;
 GO 
ALTER TABLE [dbo].[GENCON] ALTER COLUMN [ShortDesc_1] nVarChar(max) ;
 GO 
ALTER TABLE [dbo].[GENCON] ALTER COLUMN [SHORTDESC] nVarChar(max) ;
 GO 
ALTER TABLE [dbo].[GENDER] ALTER COLUMN [DESCRIPTION] nVarChar(50) ;
 GO 
ALTER TABLE [dbo].[GENDTAB] ALTER COLUMN [Last_Opr] nVarChar(50) ;
 GO 
ALTER TABLE [dbo].[GENEX] ALTER COLUMN [SHORTDESC] nVarChar(max) ;
 GO 
ALTER TABLE [dbo].[GENEX] ALTER COLUMN [ShortDesc_1] nVarChar(max) ;
 GO 
ALTER TABLE [dbo].[GENHTAB] ALTER COLUMN [Last_Opr] nVarChar(50) ;
 GO 
ALTER TABLE [dbo].[GL_AuditH] ALTER COLUMN [Description] nVarChar(50) ;
 GO 
ALTER TABLE [dbo].[GL_AuditH] ALTER COLUMN [Last_Opr] nVarChar(50) ;
 GO 
ALTER TABLE [dbo].[GL_FiscalH] ALTER COLUMN [Last_Opr] nVarChar(50) ;
 GO 
ALTER TABLE [dbo].[GL_FiscalH] ALTER COLUMN [Description] nVarChar(50) ;
 GO 
ALTER TABLE [dbo].[GLPrintLogH] ALTER COLUMN [Description] nVarChar(50) ;
 GO 
ALTER TABLE [dbo].[GLPrintLogH] ALTER COLUMN [UserID] nVarChar(10) ;
 GO 
ALTER TABLE [dbo].[GNOTES] ALTER COLUMN [Last_Opr] nVarChar(10) ;
 GO 
ALTER TABLE [dbo].[GNOTES] ALTER COLUMN [Description] nVarChar(2000) ;
 GO 
ALTER TABLE [dbo].[HBizMap] ALTER COLUMN [Description16] nVarChar(255) ;
 GO 
ALTER TABLE [dbo].[HBizMap] ALTER COLUMN [Description18] nVarChar(255) ;
 GO 
ALTER TABLE [dbo].[HBizMap] ALTER COLUMN [Description19] nVarChar(255) ;
 GO 
ALTER TABLE [dbo].[HBizMap] ALTER COLUMN [Description20] nVarChar(255) ;
 GO 
ALTER TABLE [dbo].[HBizMap] ALTER COLUMN [Description21] nVarChar(255) ;
 GO 
ALTER TABLE [dbo].[HBizMap] ALTER COLUMN [Description15] nVarChar(255) ;
 GO 
ALTER TABLE [dbo].[HBizMap] ALTER COLUMN [Description14] nVarChar(255) ;
 GO 
ALTER TABLE [dbo].[HBizMap] ALTER COLUMN [Description17] nVarChar(255) ;
 GO 
ALTER TABLE [dbo].[HBizMap] ALTER COLUMN [Description13] nVarChar(255) ;
 GO 
ALTER TABLE [dbo].[HBizMap] ALTER COLUMN [Description12] nVarChar(255) ;
 GO 
ALTER TABLE [dbo].[HBizMap] ALTER COLUMN [Description11] nVarChar(255) ;
 GO 
ALTER TABLE [dbo].[HBizMap] ALTER COLUMN [Description30] nVarChar(255) ;
 GO 
ALTER TABLE [dbo].[HBizMap] ALTER COLUMN [Description9] nVarChar(255) ;
 GO 
ALTER TABLE [dbo].[HBizMap] ALTER COLUMN [Description10] nVarChar(255) ;
 GO 
ALTER TABLE [dbo].[HBizMap] ALTER COLUMN [Last_Opr] nVarChar(10) ;
 GO 
ALTER TABLE [dbo].[HBizMap] ALTER COLUMN [Description29] nVarChar(255) ;
 GO 
ALTER TABLE [dbo].[HBizMap] ALTER COLUMN [Description28] nVarChar(255) ;
 GO 
ALTER TABLE [dbo].[HBizMap] ALTER COLUMN [Description8] nVarChar(255) ;
 GO 
ALTER TABLE [dbo].[HBizMap] ALTER COLUMN [Description7] nVarChar(255) ;
 GO 
ALTER TABLE [dbo].[HBizMap] ALTER COLUMN [Description6] nVarChar(255) ;
 GO 
ALTER TABLE [dbo].[HBizMap] ALTER COLUMN [Description27] nVarChar(255) ;
 GO 
ALTER TABLE [dbo].[HBizMap] ALTER COLUMN [Description1] nVarChar(255) ;
 GO 
ALTER TABLE [dbo].[HBizMap] ALTER COLUMN [Description22] nVarChar(255) ;
 GO 
ALTER TABLE [dbo].[HBizMap] ALTER COLUMN [Description2] nVarChar(255) ;
 GO 
ALTER TABLE [dbo].[HBizMap] ALTER COLUMN [Description24] nVarChar(255) ;
 GO 
ALTER TABLE [dbo].[HBizMap] ALTER COLUMN [Description3] nVarChar(255) ;
 GO 
ALTER TABLE [dbo].[HBizMap] ALTER COLUMN [Description5] nVarChar(255) ;
 GO 
ALTER TABLE [dbo].[HBizMap] ALTER COLUMN [Description26] nVarChar(255) ;
 GO 
ALTER TABLE [dbo].[HBizMap] ALTER COLUMN [Description23] nVarChar(255) ;
 GO 
ALTER TABLE [dbo].[HBizMap] ALTER COLUMN [Description25] nVarChar(255) ;
 GO 
ALTER TABLE [dbo].[HBizMap] ALTER COLUMN [Description4] nVarChar(255) ;
 GO 
ALTER TABLE [dbo].[HCard] ALTER COLUMN [Last_Opr] nVarChar(50) ;
 GO 
ALTER TABLE [dbo].[HCard] ALTER COLUMN [CardName] nVarChar(50) ;
 GO 
ALTER TABLE [dbo].[HCard_Detail] DROP CONSTRAINT [PK_HCard_Detail];
 GO 
ALTER TABLE [dbo].[HCard_Detail] ALTER COLUMN [LocationID] nVarChar(10) ;
 GO 
ALTER TABLE [dbo].[HCard_Detail] WITH NOCHECK ADD CONSTRAINT [PK_HCard_Detail] PRIMARY KEY NONCLUSTERED( [Card] , [LocationID] , [Condition] ) WITH (ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = OFF) ON [PRIMARY]
 GO 
ALTER TABLE [dbo].[HCardTransfer] ALTER COLUMN [LocationFrom] nVarChar(10) ;
 GO 
ALTER TABLE [dbo].[HCardTransfer] ALTER COLUMN [LocationTo] nVarChar(10) ;
 GO 
ALTER TABLE [dbo].[HCardTransfer_Detail] ALTER COLUMN [Remarks] nVarChar(225) ;
 GO 
ALTER TABLE [dbo].[HDeliveryOrder] ALTER COLUMN [LocationID] nVarChar(10) ;
 GO 
ALTER TABLE [dbo].[HDOPrintLogH] ALTER COLUMN [Description] nVarChar(500) ;
 GO 
ALTER TABLE [dbo].[HDOPrintLogH] ALTER COLUMN [UserID] nVarChar(50) ;
 GO 
ALTER TABLE [dbo].[HEALTH_PendingTable] ALTER COLUMN [Remarks] nVarChar(255) ;
 GO 
ALTER TABLE [dbo].[HEALTH_SysLOG] ALTER COLUMN [Remarks] nVarChar(255) ;
 GO 
ALTER TABLE [dbo].[HEALTH_SysLOG] ALTER COLUMN [UserID] nVarChar(10) ;
 GO 
ALTER TABLE [dbo].[HEALTH_SysLOG] ALTER COLUMN [PROCNAME] nVarChar(50) ;
 GO 
ALTER TABLE [dbo].[HEALTH_SysRequest] ALTER COLUMN [LUserID] nVarChar(10) ;
 GO 
ALTER TABLE [dbo].[HEALTH_SysRequest] ALTER COLUMN [UserID] nVarChar(10) ;
 GO 
ALTER TABLE [dbo].[HEALTH_SysRequest] ALTER COLUMN [Remarks] nVarChar(255) ;
 GO 
ALTER TABLE [dbo].[HEALTH_SysRequest] ALTER COLUMN [ProcName] nVarChar(50) ;
 GO 
ALTER TABLE [dbo].[HEmail_Log] ALTER COLUMN [EmailTime] nVarChar(8) ;
 GO 
ALTER TABLE [dbo].[HEmail_Rule] ALTER COLUMN [Last_Opr] nVarChar(50) ;
 GO 
ALTER TABLE [dbo].[HGroupSize] ALTER COLUMN [Description] nVarChar(50) ;
 GO 
ALTER TABLE [dbo].[HGroupSize] ALTER COLUMN [Last_Opr] nVarChar(10) ;
 GO 
ALTER TABLE [dbo].[HInsurance] ALTER COLUMN [Name] nVarChar(50) ;
 GO 
ALTER TABLE [dbo].[HInsurance] ALTER COLUMN [Last_Opr] nVarChar(10) ;
 GO 
ALTER TABLE [dbo].[Hint] ALTER COLUMN [Last_Opr] nVarChar(50) ;
 GO 
ALTER TABLE [dbo].[HLoading] ALTER COLUMN [Last_Opr] nVarChar(10) ;
 GO 
ALTER TABLE [dbo].[HLoading] ALTER COLUMN [Description] nVarChar(50) ;
 GO 
ALTER TABLE [dbo].[HLoading_Ext] ALTER COLUMN [Last_Opr] nVarChar(10) ;
 GO 
ALTER TABLE [dbo].[HLoading_Ext] ALTER COLUMN [Description] nVarChar(50) ;
 GO 
ALTER TABLE [dbo].[HLoading_Ext_LOB] ALTER COLUMN [Last_Opr] nVarChar(10) ;
 GO 
ALTER TABLE [dbo].[HLOB] ALTER COLUMN [Description] nVarChar(50) ;
 GO 
ALTER TABLE [dbo].[HLOB] ALTER COLUMN [Last_Opr] nVarChar(10) ;
 GO 
ALTER TABLE [dbo].[HLocation] ALTER COLUMN [Last_Opr] nVarChar(50) ;
 GO 
ALTER TABLE [dbo].[HLocation] DROP CONSTRAINT [PK_HLocation];
 GO 
ALTER TABLE [dbo].[HLocation] ALTER COLUMN [LocationID] nVarChar(10) ;
 GO 
ALTER TABLE [dbo].[HLocation] WITH NOCHECK ADD CONSTRAINT [PK_HLocation] PRIMARY KEY NONCLUSTERED( [LocationID] ) WITH (ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = OFF) ON [PRIMARY]
 GO 
ALTER TABLE [dbo].[HLocation] ALTER COLUMN [LocationDesc] nVarChar(50) ;
 GO 
ALTER TABLE [dbo].[HNOP] ALTER COLUMN [Last_Opr] nVarChar(10) ;
 GO 
ALTER TABLE [dbo].[HNOP] ALTER COLUMN [Description] nVarChar(50) ;
 GO 
ALTER TABLE [dbo].[HOccupation] ALTER COLUMN [Last_Opr] nVarChar(10) ;
 GO 
ALTER TABLE [dbo].[HOccupation] ALTER COLUMN [Name] nVarChar(50) ;
 GO 
ALTER TABLE [dbo].[HOccupation] ALTER COLUMN [Description] nVarChar(50) ;
 GO 
ALTER TABLE [dbo].[Holiday] ALTER COLUMN [Last_Opr] nVarChar(10) ;
 GO 
ALTER TABLE [dbo].[Holiday] ALTER COLUMN [Name] nVarChar(50) ;
 GO 
ALTER TABLE [dbo].[HospitalCode] ALTER COLUMN [Last_Opr] nVarChar(50) ;
 GO 
ALTER TABLE [dbo].[HPayment_Ext] ALTER COLUMN [Remarks] nVarChar(1000) ;
 GO 
ALTER TABLE [dbo].[HPaymentPrintLogH] ALTER COLUMN [Description] nVarChar(500) ;
 GO 
ALTER TABLE [dbo].[HPaymentPrintLogH] ALTER COLUMN [UserID] nVarChar(50) ;
 GO 
ALTER TABLE [dbo].[HPolicyNotes] ALTER COLUMN [Description_1] nVarChar(2000) ;
 GO 
ALTER TABLE [dbo].[HPolicyNotes] ALTER COLUMN [Description] nVarChar(2000) ;
 GO 
ALTER TABLE [dbo].[HPolicyNotes] ALTER COLUMN [Last_Opr] nVarChar(10) ;
 GO 
ALTER TABLE [dbo].[HPOPrintLogH] ALTER COLUMN [Description] nVarChar(500) ;
 GO 
ALTER TABLE [dbo].[HPOPrintLogH] ALTER COLUMN [UserID] nVarChar(50) ;
 GO 
ALTER TABLE [dbo].[HProviderLevel] ALTER COLUMN [Last_Opr] nVarChar(10) ;
 GO 
ALTER TABLE [dbo].[HProviderLevel] ALTER COLUMN [Description] nVarChar(50) ;
 GO 
ALTER TABLE [dbo].[HPurchaseOrder_Document] ALTER COLUMN [FileName] nVarChar(255) ;
 GO 
ALTER TABLE [dbo].[HPurchaseOrder_Document] ALTER COLUMN [Description] nVarChar(50) ;
 GO 
ALTER TABLE [dbo].[HRegion] ALTER COLUMN [Last_Opr] nVarChar(10) ;
 GO 
ALTER TABLE [dbo].[HRegion] ALTER COLUMN [Description] nVarChar(50) ;
 GO 
ALTER TABLE [dbo].[HRoom] ALTER COLUMN [Last_Opr] nVarChar(50) ;
 GO 
ALTER TABLE [dbo].[HRoom] ALTER COLUMN [Description] nVarChar(500) ;
 GO 
ALTER TABLE [dbo].[HSCode] ALTER COLUMN [Description] nVarChar(255) ;
 GO 
ALTER TABLE [dbo].[HSCode] ALTER COLUMN [Last_Opr] nVarChar(50) ;
 GO 
ALTER TABLE [dbo].[HSMS_Rule] ALTER COLUMN [Description] nVarChar(50) ;
 GO 
ALTER TABLE [dbo].[HSMS_Rule] ALTER COLUMN [Last_Opr] nVarChar(10) ;
 GO 
ALTER TABLE [dbo].[HSOPrintLogH] ALTER COLUMN [StockOpnameNo] nVarChar(50) ;
 GO 
ALTER TABLE [dbo].[HSOPrintLogH] ALTER COLUMN [Description] nVarChar(500) ;
 GO 
ALTER TABLE [dbo].[HSOPrintLogH] ALTER COLUMN [UserID] nVarChar(50) ;
 GO 
ALTER TABLE [dbo].[HStockOpname_Ext] DROP CONSTRAINT [FK_HStockOpname_Ext_HStockOpname];
 GO 
ALTER TABLE [dbo].[HStockOpname] DROP CONSTRAINT [PK_HStockOpname_1];
 GO 
ALTER TABLE [dbo].[HStockOpname] ALTER COLUMN [StockOpnameNo] nVarChar(50) ;
 GO 
ALTER TABLE [dbo].[HStockOpname_Ext] WITH CHECK ADD CONSTRAINT [FK_HStockOpname_Ext_HStockOpname] FOREIGN KEY ([StockOpnameNo]) REFERENCES [dbo].[HStockOpname]([StockOpnameNo]);
 GO 
ALTER TABLE [dbo].[HStockOpname] WITH NOCHECK ADD CONSTRAINT [PK_HStockOpname_1] PRIMARY KEY NONCLUSTERED( [StockOpnameNo] ) WITH (ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = OFF) ON [PRIMARY]
 GO 
ALTER TABLE [dbo].[HStockOpname_Ext] ALTER COLUMN [LocationID] nVarChar(10) ;
 GO 
ALTER TABLE [dbo].[HStockOpname_Ext] DROP CONSTRAINT [FK_HStockOpname_Ext_HStockOpname];
 GO 
ALTER TABLE [dbo].[HStockOpname_Ext] DROP CONSTRAINT [PK_HStockOpname_Ext_1];
 GO 
ALTER TABLE [dbo].[HStockOpname_Ext] ALTER COLUMN [StockOpnameNo] nVarChar(50) ;
 GO 
ALTER TABLE [dbo].[HStockOpname_Ext] WITH CHECK ADD CONSTRAINT [FK_HStockOpname_Ext_HStockOpname] FOREIGN KEY ([StockOpnameNo]) REFERENCES [dbo].[HStockOpname]([StockOpnameNo]);
 GO 
ALTER TABLE [dbo].[HStockOpname_Ext] WITH NOCHECK ADD CONSTRAINT [PK_HStockOpname_Ext_1] PRIMARY KEY NONCLUSTERED( [StockOpnameNo] , [Card] ) WITH (ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = OFF) ON [PRIMARY]
 GO 
ALTER TABLE [dbo].[HSupplier] ALTER COLUMN [SupplierName] nVarChar(50) ;
 GO 
ALTER TABLE [dbo].[HSupplier] ALTER COLUMN [Address] nVarChar(500) ;
 GO 
ALTER TABLE [dbo].[HSupplier] ALTER COLUMN [Last_Opr] nVarChar(10) ;
 GO 
ALTER TABLE [dbo].[ICOVER] ALTER COLUMN [LUserID] nVarChar(50) ;
 GO 
ALTER TABLE [dbo].[ICOVERPOL] ALTER COLUMN [LUserID] nVarChar(5) ;
 GO 
ALTER TABLE [dbo].[ICR_Master] ALTER COLUMN [MainRateRemark] nVarChar(512) ;
 GO 
ALTER TABLE [dbo].[ICR_Master] ALTER COLUMN [MainInterestRemark] nVarChar(512) ;
 GO 
ALTER TABLE [dbo].[ICR_Master] ALTER COLUMN [MainExtInterestRemark] nVarChar(512) ;
 GO 
ALTER TABLE [dbo].[ICR_Master] ALTER COLUMN [MainDeductibleRemark] nVarChar(255) ;
 GO 
ALTER TABLE [dbo].[ICR_Master] ALTER COLUMN [AddRateRemark_1] nVarChar(512) ;
 GO 
ALTER TABLE [dbo].[ICR_Master] ALTER COLUMN [AddInterestRemark_1] nVarChar(512) ;
 GO 
ALTER TABLE [dbo].[ICR_Master] ALTER COLUMN [AddDeductibleRemark_1] nVarChar(255) ;
 GO 
ALTER TABLE [dbo].[ICR_Master] ALTER COLUMN [AddRateRemark_2] nVarChar(512) ;
 GO 
ALTER TABLE [dbo].[ICR_Master] ALTER COLUMN [AddInterestRemark_2] nVarChar(512) ;
 GO 
ALTER TABLE [dbo].[ICR_Master] ALTER COLUMN [AddDeductibleRemark_2] nVarChar(255) ;
 GO 
ALTER TABLE [dbo].[ICR_Master] ALTER COLUMN [AddRateRemark_3] nVarChar(512) ;
 GO 
ALTER TABLE [dbo].[ICR_Master] ALTER COLUMN [AddInterestRemark_3] nVarChar(512) ;
 GO 
ALTER TABLE [dbo].[ICR_Master] ALTER COLUMN [AddDeductibleRemark_3] nVarChar(255) ;
 GO 
ALTER TABLE [dbo].[ICR_Master] ALTER COLUMN [AddRateRemark_4] nVarChar(512) ;
 GO 
ALTER TABLE [dbo].[ICR_Master] ALTER COLUMN [AddInterestRemark_4] nVarChar(512) ;
 GO 
ALTER TABLE [dbo].[ICR_Master] ALTER COLUMN [AddDeductibleRemark_4] nVarChar(255) ;
 GO 
ALTER TABLE [dbo].[ICR_Master] ALTER COLUMN [AddRateRemark_5] nVarChar(512) ;
 GO 
ALTER TABLE [dbo].[ICR_Master] ALTER COLUMN [AddInterestRemark_5] nVarChar(512) ;
 GO 
ALTER TABLE [dbo].[ICR_Master] ALTER COLUMN [AddDeductibleRemark_5] nVarChar(255) ;
 GO 
ALTER TABLE [dbo].[ICR_Master] ALTER COLUMN [AddRateRemark_6] nVarChar(512) ;
 GO 
ALTER TABLE [dbo].[ICR_Master] ALTER COLUMN [AddInterestRemark_6] nVarChar(512) ;
 GO 
ALTER TABLE [dbo].[ICR_Master] ALTER COLUMN [AddDeductibleRemark_6] nVarChar(255) ;
 GO 
ALTER TABLE [dbo].[ICR_Master] ALTER COLUMN [AddRateRemark_7] nVarChar(512) ;
 GO 
ALTER TABLE [dbo].[ICR_Master] ALTER COLUMN [AddInterestRemark_7] nVarChar(512) ;
 GO 
ALTER TABLE [dbo].[ICR_Master] ALTER COLUMN [AddDeductibleRemark_7] nVarChar(255) ;
 GO 
ALTER TABLE [dbo].[ICR_Master] ALTER COLUMN [AddRateRemark_8] nVarChar(512) ;
 GO 
ALTER TABLE [dbo].[ICR_Master] ALTER COLUMN [AddInterestRemark_8] nVarChar(512) ;
 GO 
ALTER TABLE [dbo].[ICR_Master] ALTER COLUMN [AddDeductibleRemark_8] nVarChar(255) ;
 GO 
ALTER TABLE [dbo].[ICR_Transaction] ALTER COLUMN [PHolder_ContactAddress] nVarChar(255) ;
 GO 
ALTER TABLE [dbo].[ICR_Transaction] ALTER COLUMN [Insured_ContactAddress] nVarChar(255) ;
 GO 
ALTER TABLE [dbo].[ICR_Transaction] ALTER COLUMN [USERID] nVarChar(50) ;
 GO 
ALTER TABLE [dbo].[ICR_Transaction] ALTER COLUMN [LUserID] nVarChar(50) ;
 GO 
ALTER TABLE [dbo].[ICR_Transaction] ALTER COLUMN [Payor_Address_3] nVarChar(255) ;
 GO 
ALTER TABLE [dbo].[ICR_Transaction] ALTER COLUMN [PHolder_Address_3] nVarChar(255) ;
 GO 
ALTER TABLE [dbo].[ICR_Transaction] ALTER COLUMN [DCode_Remark_4] nVarChar(255) ;
 GO 
ALTER TABLE [dbo].[ICR_Transaction] ALTER COLUMN [DCode_Remark_1] nVarChar(255) ;
 GO 
ALTER TABLE [dbo].[ICR_Transaction] ALTER COLUMN [PHolder_Name] nVarChar(255) ;
 GO 
ALTER TABLE [dbo].[ICR_Transaction] ALTER COLUMN [Insured_EMail] nVarChar(255) ;
 GO 
ALTER TABLE [dbo].[ICR_Transaction] ALTER COLUMN [DCode_Remark_3] nVarChar(255) ;
 GO 
ALTER TABLE [dbo].[ICR_Transaction] ALTER COLUMN [PHolder_Address_1] nVarChar(255) ;
 GO 
ALTER TABLE [dbo].[ICR_Transaction] ALTER COLUMN [Payor_Address_1] nVarChar(255) ;
 GO 
ALTER TABLE [dbo].[ICR_Transaction] ALTER COLUMN [Insured_Address_2] nVarChar(255) ;
 GO 
ALTER TABLE [dbo].[ICR_Transaction] ALTER COLUMN [Addremark_3b] nVarChar(255) ;
 GO 
ALTER TABLE [dbo].[ICR_Transaction] ALTER COLUMN [Addremark_3a] nVarChar(255) ;
 GO 
ALTER TABLE [dbo].[ICR_Transaction] ALTER COLUMN [Payor_Address_2] nVarChar(255) ;
 GO 
ALTER TABLE [dbo].[ICR_Transaction] ALTER COLUMN [PHolder_Address_2] nVarChar(255) ;
 GO 
ALTER TABLE [dbo].[ICR_Transaction] ALTER COLUMN [Addremark_2a] nVarChar(255) ;
 GO 
ALTER TABLE [dbo].[ICR_Transaction] ALTER COLUMN [Payor_EMail] nVarChar(255) ;
 GO 
ALTER TABLE [dbo].[ICR_Transaction] ALTER COLUMN [PHolder_EMail] nVarChar(255) ;
 GO 
ALTER TABLE [dbo].[ICR_Transaction] ALTER COLUMN [DCode_Remark_5] nVarChar(255) ;
 GO 
ALTER TABLE [dbo].[ICR_Transaction] ALTER COLUMN [Insured_Address_1] nVarChar(255) ;
 GO 
ALTER TABLE [dbo].[ICR_Transaction] ALTER COLUMN [DCode_Remark_2] nVarChar(255) ;
 GO 
ALTER TABLE [dbo].[ICR_Transaction] ALTER COLUMN [Insured_Address_3] nVarChar(255) ;
 GO 
ALTER TABLE [dbo].[ICR_Transaction] ALTER COLUMN [Addremark_2b] nVarChar(255) ;
 GO 
ALTER TABLE [dbo].[ICR_Transaction] ALTER COLUMN [AName] nVarChar(512) ;
 GO 
ALTER TABLE [dbo].[ICR_Transaction] ALTER COLUMN [Insured_Name] nVarChar(255) ;
 GO 
ALTER TABLE [dbo].[ID_TYPE] ALTER COLUMN [Description] nVarChar(255) ;
 GO 
ALTER TABLE [dbo].[ID_TYPE] ALTER COLUMN [Last_Opr] nVarChar(50) ;
 GO 
ALTER TABLE [dbo].[IFRS_Assumption] ALTER COLUMN [Description] nVarChar(255) ;
 GO 
ALTER TABLE [dbo].[IFRS_Assumption] ALTER COLUMN [Last_Opr] nVarChar(50) ;
 GO 
ALTER TABLE [dbo].[IFRS_Assumption_Detail] ALTER COLUMN [Last_Opr] nVarChar(50) ;
 GO 
ALTER TABLE [dbo].[IFRS_CancelRate] ALTER COLUMN [Last_Opr] nVarChar(50) ;
 GO 
ALTER TABLE [dbo].[IFRS_CancelRate] ALTER COLUMN [Description] nVarChar(255) ;
 GO 
ALTER TABLE [dbo].[IFRS_CancelRate_Detail] ALTER COLUMN [Last_Opr] nVarChar(50) ;
 GO 
ALTER TABLE [dbo].[IFRS_DiscRate] ALTER COLUMN [Last_Opr] nVarChar(50) ;
 GO 
ALTER TABLE [dbo].[IFRS_DiscRate] ALTER COLUMN [Description] nVarChar(255) ;
 GO 
ALTER TABLE [dbo].[IFRS_DiscRate_Detail] ALTER COLUMN [Last_Opr] nVarChar(50) ;
 GO 
ALTER TABLE [dbo].[IFRS_InfRate] ALTER COLUMN [Last_Opr] nVarChar(50) ;
 GO 
ALTER TABLE [dbo].[IFRS_InfRate] ALTER COLUMN [Description] nVarChar(255) ;
 GO 
ALTER TABLE [dbo].[IFRS_InfRate_Detail] ALTER COLUMN [Last_Opr] nVarChar(50) ;
 GO 
ALTER TABLE [dbo].[IFRS_Movement] ALTER COLUMN [Description] nVarChar(255) ;
 GO 
ALTER TABLE [dbo].[INPARTY] ALTER COLUMN [Address_1] nVarChar(1024) ;
 GO 
ALTER TABLE [dbo].[INPARTY] ALTER COLUMN [Address_2] nVarChar(1024) ;
 GO 
ALTER TABLE [dbo].[INPARTY] ALTER COLUMN [Email] nVarChar(512) ;
 GO 
ALTER TABLE [dbo].[ISTYPE] ALTER COLUMN [DESCRIPTION] nVarChar(50) ;
 GO 
ALTER TABLE [dbo].[IUNIT] ALTER COLUMN [DESCRIPTION] nVarChar(100) ;
 GO 
ALTER TABLE [dbo].[IUNIT] ALTER COLUMN [DESCRIPTION_1] nVarChar(100) ;
 GO 
ALTER TABLE [dbo].[IUNIT] ALTER COLUMN [REMARK] nVarChar(100) ;
 GO 
ALTER TABLE [dbo].[IUNIT] ALTER COLUMN [REMARK_1] nVarChar(100) ;
 GO 
DROP INDEX [dbo].[KOL].[I_KOL_Description];
 GO 
ALTER TABLE [dbo].[KOL] ALTER COLUMN [Description] nVarChar(100) ;
 GO 
CREATE NONCLUSTERED INDEX [I_KOL_Description] ON [dbo].[KOL] (  [Description] )
 GO 
ALTER TABLE [dbo].[KOLTab] ALTER COLUMN [Description] nVarChar(100) ;
 GO 
ALTER TABLE [dbo].[KOLTab] ALTER COLUMN [Last_Opr] nVarChar(50) ;
 GO 
ALTER TABLE [dbo].[KOLValue] ALTER COLUMN [VALUEDESC1] nVarChar(255) ;
 GO 
ALTER TABLE [dbo].[KOLValue] ALTER COLUMN [VALUEDESC2] nVarChar(255) ;
 GO 
ALTER TABLE [dbo].[KOLValue] ALTER COLUMN [VALUEDESC3] nVarChar(255) ;
 GO 
ALTER TABLE [dbo].[KOLValue] ALTER COLUMN [VALUEDESC4] nVarChar(255) ;
 GO 
ALTER TABLE [dbo].[KOLValue] ALTER COLUMN [VALUEDESC5] nVarChar(255) ;
 GO 
ALTER TABLE [dbo].[KOLValue] ALTER COLUMN [VALUEDESC6] nVarChar(255) ;
 GO 
ALTER TABLE [dbo].[KOLValue] ALTER COLUMN [VALUEDESC7] nVarChar(255) ;
 GO 
ALTER TABLE [dbo].[KOLValue] ALTER COLUMN [VALUEDESC8] nVarChar(255) ;
 GO 
ALTER TABLE [dbo].[KOLValue] ALTER COLUMN [VALUEDESC9] nVarChar(255) ;
 GO 
ALTER TABLE [dbo].[KOLValue] ALTER COLUMN [VALUEDESC10] nVarChar(255) ;
 GO 
ALTER TABLE [dbo].[KOLValue] ALTER COLUMN [VALUEDESC11] nVarChar(255) ;
 GO 
ALTER TABLE [dbo].[KOLValue] ALTER COLUMN [VALUEDESC12] nVarChar(255) ;
 GO 
ALTER TABLE [dbo].[KOLValue] ALTER COLUMN [VALUEDESC13] nVarChar(255) ;
 GO 
ALTER TABLE [dbo].[KOLValue] ALTER COLUMN [VALUEDESC14] nVarChar(255) ;
 GO 
ALTER TABLE [dbo].[KOLValue] ALTER COLUMN [VALUEDESC15] nVarChar(255) ;
 GO 
ALTER TABLE [dbo].[KOLValue] ALTER COLUMN [Last_Opr] nVarChar(50) ;
 GO 
ALTER TABLE [dbo].[LastEducation] ALTER COLUMN [Last_Opr] nVarChar(10) ;
 GO 
ALTER TABLE [dbo].[LastEducation] ALTER COLUMN [Description] nVarChar(100) ;
 GO 
ALTER TABLE [dbo].[LinkExcel] ALTER COLUMN [Description] nVarChar(100) ;
 GO 
ALTER TABLE [dbo].[LLLog] ALTER COLUMN [FILENAME] nVarChar(255) ;
 GO 
ALTER TABLE [dbo].[LLLog] ALTER COLUMN [TBName] nVarChar(50) ;
 GO 
ALTER TABLE [dbo].[LOB] ALTER COLUMN [Description] nVarChar(50) ;
 GO 
ALTER TABLE [dbo].[LOB] ALTER COLUMN [Last_Opr] nVarChar(50) ;
 GO 
ALTER TABLE [dbo].[Location] DROP CONSTRAINT [i_Location];
 GO 
ALTER TABLE [dbo].[Location] ALTER COLUMN [Location] nVarChar(10) ;
 GO 
ALTER TABLE [dbo].[Location] WITH NOCHECK ADD CONSTRAINT [i_Location] PRIMARY KEY NONCLUSTERED( [Location] ) WITH (ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = OFF) ON [PRIMARY]
 GO 
ALTER TABLE [dbo].[Location] ALTER COLUMN [Name] nVarChar(50) ;
 GO 
ALTER TABLE [dbo].[Location] ALTER COLUMN [Remarks] nVarChar(255) ;
 GO 
ALTER TABLE [dbo].[Location] ALTER COLUMN [Last_Opr] nVarChar(50) ;
 GO 
ALTER TABLE [dbo].[Location] ALTER COLUMN [Address_3] nVarChar(1024) ;
 GO 
ALTER TABLE [dbo].[Location] ALTER COLUMN [Address_2] nVarChar(1024) ;
 GO 
ALTER TABLE [dbo].[Location] ALTER COLUMN [Address_1] nVarChar(1024) ;
 GO 
ALTER TABLE [dbo].[M_Poly] ALTER COLUMN [Description] nVarChar(50) ;
 GO 
ALTER TABLE [dbo].[MAP_FIELD] ALTER COLUMN [LAST_OPR] nVarChar(50) ;
 GO 
ALTER TABLE [dbo].[MAP_HEADER] ALTER COLUMN [Description] nVarChar(100) ;
 GO 
ALTER TABLE [dbo].[MAP_HEADER] ALTER COLUMN [Last_Opr] nVarChar(50) ;
 GO 
DROP INDEX [dbo].[MAP_REFERENCE].[I_MAP_REFERENCE_MapCode_MapType_SDate_EDate_RefNo_ShortDesc];
 GO 
ALTER TABLE [dbo].[MAP_REFERENCE] ALTER COLUMN [ShortDesc] nVarChar(50) ;
 GO 
CREATE NONCLUSTERED INDEX [I_MAP_REFERENCE_MapCode_MapType_SDate_EDate_RefNo_ShortDesc] ON [dbo].[MAP_REFERENCE] (  [MapCode] , [MapType] , [SDate] , [EDate] , [RefNo] , [ShortDesc] )
 GO 
ALTER TABLE [dbo].[MAP_REFERENCE] ALTER COLUMN [LAST_OPR] nVarChar(50) ;
 GO 
ALTER TABLE [dbo].[MAP_VALUE] ALTER COLUMN [Last_Opr] nVarChar(50) ;
 GO 
ALTER TABLE [dbo].[MaritalStatus] ALTER COLUMN [Description] nVarChar(255) ;
 GO 
ALTER TABLE [dbo].[MaritalStatus] ALTER COLUMN [Last_Opr] nVarChar(10) ;
 GO 
ALTER TABLE [dbo].[MasterPrint] ALTER COLUMN [Description] nVarChar(255) ;
 GO 
ALTER TABLE [dbo].[Matters] ALTER COLUMN [Description] nVarChar(100) ;
 GO 
ALTER TABLE [dbo].[Matters] ALTER COLUMN [Last_Opr] nVarChar(50) ;
 GO 
ALTER TABLE [dbo].[MDocumentClaim] ALTER COLUMN [Remarks] nVarChar(255) ;
 GO 
ALTER TABLE [dbo].[MedicalCode] ALTER COLUMN [Last_Opr] nVarChar(50) ;
 GO 
ALTER TABLE [dbo].[MenuSetD] ALTER COLUMN [LAST_OPR] nVarChar(50) ;
 GO 
ALTER TABLE [dbo].[MenuSetH] ALTER COLUMN [Last_Opr] nVarChar(50) ;
 GO 
ALTER TABLE [dbo].[MenuSetH] ALTER COLUMN [Description] nVarChar(100) ;
 GO 
ALTER TABLE [dbo].[Method] ALTER COLUMN [Name] nVarChar(50) ;
 GO 
ALTER TABLE [dbo].[MFactor] ALTER COLUMN [Last_Opr] nVarChar(10) ;
 GO 
ALTER TABLE [dbo].[mJournal] ALTER COLUMN [Description] nVarChar(512) ;
 GO 
ALTER TABLE [dbo].[mJournal] ALTER COLUMN [Last_Opr] nVarChar(50) ;
 GO 
ALTER TABLE [dbo].[MParam] ALTER COLUMN [Remarks] nVarChar(50) ;
 GO 
ALTER TABLE [dbo].[MParam] ALTER COLUMN [Last_Opr] nVarChar(50) ;
 GO 
ALTER TABLE [dbo].[MSCode] ALTER COLUMN [Last_Opr] nVarChar(50) ;
 GO 
ALTER TABLE [dbo].[MSCode] ALTER COLUMN [Description] nVarChar(100) ;
 GO 
ALTER TABLE [dbo].[MSCode_Assignment] ALTER COLUMN [Last_Opr] nVarChar(50) ;
 GO 
ALTER TABLE [dbo].[MSCode_Type] ALTER COLUMN [Last_Opr] nVarChar(50) ;
 GO 
ALTER TABLE [dbo].[MSCode_Type] ALTER COLUMN [Description] nVarChar(50) ;
 GO 
ALTER TABLE [dbo].[MType] ALTER COLUMN [Description] nVarChar(50) ;
 GO 
ALTER TABLE [dbo].[MType] ALTER COLUMN [Last_Opr] nVarChar(50) ;
 GO 
ALTER TABLE [dbo].[MultH] ALTER COLUMN [Name] nVarChar(50) ;
 GO 
ALTER TABLE [dbo].[MultH] ALTER COLUMN [Last_Opr] nVarChar(10) ;
 GO 
ALTER TABLE [dbo].[mVoucher] ALTER COLUMN [Remarks] nVarChar(max) ;
 GO 
ALTER TABLE [dbo].[mVoucher] ALTER COLUMN [Last_Opr] nVarChar(50) ;
 GO 
ALTER TABLE [dbo].[mVoucher] ALTER COLUMN [RequestName] nVarChar(50) ;
 GO 
ALTER TABLE [dbo].[mVoucher] ALTER COLUMN [AUserID] nVarChar(50) ;
 GO 
ALTER TABLE [dbo].[mVoucher] ALTER COLUMN [VUserID] nVarChar(50) ;
 GO 
ALTER TABLE [dbo].[mVoucher] ALTER COLUMN [AUserID_Ext] nVarChar(50) ;
 GO 
ALTER TABLE [dbo].[mVoucher] ALTER COLUMN [UVUserID] nVarChar(50) ;
 GO 
ALTER TABLE [dbo].[mVoucher] ALTER COLUMN [UAUserID] nVarChar(50) ;
 GO 
ALTER TABLE [dbo].[mVoucher] ALTER COLUMN [UAUserID_Ext] nVarChar(50) ;
 GO 
ALTER TABLE [dbo].[mVoucher] ALTER COLUMN [USERID] nVarChar(50) ;
 GO 
ALTER TABLE [dbo].[nJournal] ALTER COLUMN [Description] nVarChar(100) ;
 GO 
ALTER TABLE [dbo].[nJournal] ALTER COLUMN [Last_Opr] nVarChar(50) ;
 GO 
ALTER TABLE [dbo].[NOC] ALTER COLUMN [DESCRIPTION] nVarChar(255) ;
 GO 
ALTER TABLE [dbo].[NOCTab] ALTER COLUMN [DESCRIPTION] nVarChar(255) ;
 GO 
ALTER TABLE [dbo].[NOCTab] ALTER COLUMN [Last_Opr] nVarChar(50) ;
 GO 
ALTER TABLE [dbo].[Notes] ALTER COLUMN [Description] nVarChar(50) ;
 GO 
ALTER TABLE [dbo].[nVoucher] ALTER COLUMN [USERID] nVarChar(50) ;
 GO 
ALTER TABLE [dbo].[nVoucher] ALTER COLUMN [Remarks] nVarChar(max) ;
 GO 
ALTER TABLE [dbo].[nVoucher] ALTER COLUMN [Last_Opr] nVarChar(50) ;
 GO 
ALTER TABLE [dbo].[nVoucher] ALTER COLUMN [RequestName] nVarChar(50) ;
 GO 
ALTER TABLE [dbo].[ObjectRegister] ALTER COLUMN [VALUEDESC10] nVarChar(255) ;
 GO 
ALTER TABLE [dbo].[ObjectRegister] ALTER COLUMN [VALUEDESC7] nVarChar(255) ;
 GO 
ALTER TABLE [dbo].[ObjectRegister] ALTER COLUMN [VALUEDESC9] nVarChar(255) ;
 GO 
ALTER TABLE [dbo].[ObjectRegister] ALTER COLUMN [VALUEDESC11] nVarChar(255) ;
 GO 
ALTER TABLE [dbo].[ObjectRegister] ALTER COLUMN [VALUEDESC8] nVarChar(255) ;
 GO 
ALTER TABLE [dbo].[ObjectRegister] ALTER COLUMN [VALUEDESC6] nVarChar(255) ;
 GO 
ALTER TABLE [dbo].[ObjectRegister] ALTER COLUMN [VALUEDESC15] nVarChar(255) ;
 GO 
ALTER TABLE [dbo].[ObjectRegister] ALTER COLUMN [VALUEDESC14] nVarChar(255) ;
 GO 
ALTER TABLE [dbo].[ObjectRegister] ALTER COLUMN [VALUEDESC12] nVarChar(255) ;
 GO 
ALTER TABLE [dbo].[ObjectRegister] ALTER COLUMN [VALUEDESC13] nVarChar(255) ;
 GO 
ALTER TABLE [dbo].[ObjectRegister] ALTER COLUMN [VALUEDESC4] nVarChar(255) ;
 GO 
ALTER TABLE [dbo].[ObjectRegister] ALTER COLUMN [VALUEDESC3] nVarChar(255) ;
 GO 
ALTER TABLE [dbo].[ObjectRegister] ALTER COLUMN [VALUEDESC1] nVarChar(255) ;
 GO 
ALTER TABLE [dbo].[ObjectRegister] ALTER COLUMN [VALUEDESC5] nVarChar(255) ;
 GO 
ALTER TABLE [dbo].[ObjectRegister] ALTER COLUMN [Last_Opr] nVarChar(50) ;
 GO 
ALTER TABLE [dbo].[ObjectRegister] ALTER COLUMN [VALUEDESC2] nVarChar(255) ;
 GO 
ALTER TABLE [dbo].[Occupation] ALTER COLUMN [Name] nVarChar(50) ;
 GO 
ALTER TABLE [dbo].[Occupation] ALTER COLUMN [Description] nVarChar(50) ;
 GO 
ALTER TABLE [dbo].[Occupation] ALTER COLUMN [Last_Opr] nVarChar(50) ;
 GO 
ALTER TABLE [dbo].[OfficerPosition] ALTER COLUMN [Description] nVarChar(255) ;
 GO 
ALTER TABLE [dbo].[OfficerPosition] ALTER COLUMN [Last_Opr] nVarChar(50) ;
 GO 
ALTER TABLE [dbo].[OGIS_ERROR] ALTER COLUMN [Last_opr] nVarChar(50) ;
 GO 
ALTER TABLE [dbo].[OGIS_ERROR] ALTER COLUMN [OGIS_ERROR_DESCRIPTION] nVarChar(500) ;
 GO 
ALTER TABLE [dbo].[OGIS_LOG_DETAIL] ALTER COLUMN [Last_Opr] nVarChar(50) ;
 GO 
ALTER TABLE [dbo].[OGIS_LOG_DOWNLOAD] ALTER COLUMN [UserID] nVarChar(50) ;
 GO 
ALTER TABLE [dbo].[OGIS_LOG_HEADER] ALTER COLUMN [USERID] nVarChar(50) ;
 GO 
ALTER TABLE [dbo].[OGIS_LOG_HEADER] ALTER COLUMN [FILENAME] nVarChar(255) ;
 GO 
ALTER TABLE [dbo].[OGIS_MAP_DETAIL] ALTER COLUMN [Last_opr] nVarChar(50) ;
 GO 
ALTER TABLE [dbo].[OGIS_MAP_HEADER] ALTER COLUMN [SOURCE_FIELD_NAME] nVarChar(50) ;
 GO 
ALTER TABLE [dbo].[OGIS_MAP_HEADER] ALTER COLUMN [OGIS_FIELD_NAME] nVarChar(50) ;
 GO 
ALTER TABLE [dbo].[OGIS_MAP_HEADER] ALTER COLUMN [OGIS_FIELD_DESCRIPTION] nVarChar(500) ;
 GO 
ALTER TABLE [dbo].[OGIS_MAP_HEADER] ALTER COLUMN [Last_opr] nVarChar(50) ;
 GO 
ALTER TABLE [dbo].[OneCardD] ALTER COLUMN [Email] nVarChar(512) ;
 GO 
ALTER TABLE [dbo].[OneCardD] ALTER COLUMN [LAST_OPR] nVarChar(50) ;
 GO 
ALTER TABLE [dbo].[OneCardD] ALTER COLUMN [Address] nVarChar(1024) ;
 GO 
ALTER TABLE [dbo].[OneCardH] ALTER COLUMN [CardRemarks] nVarChar(512) ;
 GO 
ALTER TABLE [dbo].[OneCardH] ALTER COLUMN [LAST_OPR] nVarChar(50) ;
 GO 
ALTER TABLE [dbo].[OneCardH] ALTER COLUMN [AUSERID] nVarChar(50) ;
 GO 
ALTER TABLE [dbo].[OneCardH] ALTER COLUMN [CUSERID] nVarChar(50) ;
 GO 
ALTER TABLE [dbo].[OneCardH] ALTER COLUMN [USERID] nVarChar(50) ;
 GO 
ALTER TABLE [dbo].[OneCardH] ALTER COLUMN [CardName] nVarChar(255) ;
 GO 
ALTER TABLE [dbo].[OneCardH] ALTER COLUMN [CardEmail] nVarChar(255) ;
 GO 
ALTER TABLE [dbo].[OneCardP] ALTER COLUMN [DESCRIPTION] nVarChar(255) ;
 GO 
ALTER TABLE [dbo].[OneCardP] ALTER COLUMN [LAST_OPR] nVarChar(50) ;
 GO 
ALTER TABLE [dbo].[OneCardP] ALTER COLUMN [AUSERID] nVarChar(50) ;
 GO 
ALTER TABLE [dbo].[OneCardP] ALTER COLUMN [CUSERID] nVarChar(50) ;
 GO 
ALTER TABLE [dbo].[OneCardP] ALTER COLUMN [USERID] nVarChar(50) ;
 GO 
ALTER TABLE [dbo].[ORPrintLog] ALTER COLUMN [Description] nVarChar(50) ;
 GO 
ALTER TABLE [dbo].[ORPrintLog] ALTER COLUMN [UserID] nVarChar(50) ;
 GO 
ALTER TABLE [dbo].[Owner] ALTER COLUMN [Last_Opr] nVarChar(50) ;
 GO 
ALTER TABLE [dbo].[Owner] ALTER COLUMN [Description] nVarChar(50) ;
 GO 
ALTER TABLE [dbo].[PAlias] ALTER COLUMN [Email] nVarChar(512) ;
 GO 
ALTER TABLE [dbo].[PAlias] ALTER COLUMN [LAST_OPR] nVarChar(50) ;
 GO 
DROP INDEX [dbo].[PAlias].[I_PAlias];
 GO 
ALTER TABLE [dbo].[PAlias] ALTER COLUMN [Address] nVarChar(1024) ;
 GO 
CREATE NONCLUSTERED INDEX [I_PAlias] ON [dbo].[PAlias] (  [ID] , [MID] , [Name] , [Address] )
 GO 
ALTER TABLE [dbo].[PAYOR] ALTER COLUMN [ADDRESS_1] nVarChar(1024) ;
 GO 
ALTER TABLE [dbo].[PAYOR] ALTER COLUMN [ADDRESS_2] nVarChar(1024) ;
 GO 
ALTER TABLE [dbo].[PAYOR] ALTER COLUMN [ADDRESS_3] nVarChar(1024) ;
 GO 
ALTER TABLE [dbo].[PAYOR] ALTER COLUMN [Remarks] nVarChar(255) ;
 GO 
ALTER TABLE [dbo].[PAYOR] ALTER COLUMN [LUserID] nVarChar(50) ;
 GO 
ALTER TABLE [dbo].[PBenefit] ALTER COLUMN [Last_Opr] nVarChar(10) ;
 GO 
ALTER TABLE [dbo].[PCLASS] ALTER COLUMN [Last_Opr] nVarChar(50) ;
 GO 
ALTER TABLE [dbo].[PCoasuransi] ALTER COLUMN [Last_Opr] nVarChar(10) ;
 GO 
ALTER TABLE [dbo].[PCSummary] ALTER COLUMN [Last_Opr] nVarChar(50) ;
 GO 
ALTER TABLE [dbo].[PDOCLIST] ALTER COLUMN [DESCRIPTION] nVarChar(255) ;
 GO 
ALTER TABLE [dbo].[PERIOD] ALTER COLUMN [Description] nVarChar(20) ;
 GO 
ALTER TABLE [dbo].[PettyCashH] ALTER COLUMN [RName] nVarChar(50) ;
 GO 
ALTER TABLE [dbo].[PettyCashH] ALTER COLUMN [Last_Opr] nVarChar(50) ;
 GO 
ALTER TABLE [dbo].[PettyCashH] ALTER COLUMN [CUSERID] nVarChar(50) ;
 GO 
ALTER TABLE [dbo].[PettyCashH] ALTER COLUMN [AUserID] nVarChar(50) ;
 GO 
ALTER TABLE [dbo].[PettyCashH] ALTER COLUMN [UserID] nVarChar(50) ;
 GO 
ALTER TABLE [dbo].[PettyCashType] ALTER COLUMN [Description] nVarChar(50) ;
 GO 
ALTER TABLE [dbo].[PettyCashType] ALTER COLUMN [Last_Opr] nVarChar(50) ;
 GO 
ALTER TABLE [dbo].[PFLScale] ALTER COLUMN [Last_Opr] nVarChar(50) ;
 GO 
ALTER TABLE [dbo].[PHOLDER] ALTER COLUMN [UserID] nVarChar(50) ;
 GO 
ALTER TABLE [dbo].[PHOLDER] ALTER COLUMN [Last_Opr] nVarChar(50) ;
 GO 
ALTER TABLE [dbo].[pJournal] ALTER COLUMN [Description] nVarChar(100) ;
 GO 
ALTER TABLE [dbo].[pJournal] ALTER COLUMN [Last_Opr] nVarChar(50) ;
 GO 
ALTER TABLE [dbo].[PNOTES] ALTER COLUMN [UserID] nVarChar(50) ;
 GO 
ALTER TABLE [dbo].[PNotify] ALTER COLUMN [UserID] nVarChar(50) ;
 GO 
ALTER TABLE [dbo].[PNStatus] ALTER COLUMN [Last_Opr] nVarChar(50) ;
 GO 
ALTER TABLE [dbo].[PNStatus] ALTER COLUMN [Description] nVarChar(255) ;
 GO 
ALTER TABLE [dbo].[PolicyType] ALTER COLUMN [Last_Opr] nVarChar(50) ;
 GO 
ALTER TABLE [dbo].[PolicyType] ALTER COLUMN [Description] nVarChar(50) ;
 GO 
ALTER TABLE [dbo].[Port] ALTER COLUMN [Last_Opr] nVarChar(50) ;
 GO 
ALTER TABLE [dbo].[Port] ALTER COLUMN [Description] nVarChar(255) ;
 GO 
ALTER TABLE [dbo].[PPrintLog] ALTER COLUMN [Description] nVarChar(50) ;
 GO 
ALTER TABLE [dbo].[PPrintLog] ALTER COLUMN [UserID] nVarChar(50) ;
 GO 
ALTER TABLE [dbo].[PPrintLogH] ALTER COLUMN [Description] nVarChar(50) ;
 GO 
ALTER TABLE [dbo].[PPrintLogH] ALTER COLUMN [UserID] nVarChar(10) ;
 GO 
ALTER TABLE [dbo].[ProAcc] ALTER COLUMN [PUserID] nVarChar(50) ;
 GO 
ALTER TABLE [dbo].[ProAcc] ALTER COLUMN [USERID] nVarChar(50) ;
 GO 
ALTER TABLE [dbo].[ProAcc] ALTER COLUMN [LAST_OPR] nVarChar(50) ;
 GO 
ALTER TABLE [dbo].[Profile] ALTER COLUMN [Address_1] nVarChar(1024) ;
 GO 
ALTER TABLE [dbo].[Profile] ALTER COLUMN [Address_2] nVarChar(1024) ;
 GO 
ALTER TABLE [dbo].[Profile] ALTER COLUMN [Address_3] nVarChar(1024) ;
 GO 
DROP INDEX [dbo].[Profile].[I_Profile_Email];
 GO 
ALTER TABLE [dbo].[Profile] ALTER COLUMN [Email] nVarChar(512) ;
 GO 
CREATE NONCLUSTERED INDEX [I_Profile_Email] ON [dbo].[Profile] (  [Email] )
 GO 
ALTER TABLE [dbo].[Profile] ALTER COLUMN [Email_2] nVarChar(512) ;
 GO 
ALTER TABLE [dbo].[Profile] ALTER COLUMN [LAST_OPR] nVarChar(50) ;
 GO 
ALTER TABLE [dbo].[Profile] ALTER COLUMN [REMARK] nVarChar(255) ;
 GO 
ALTER TABLE [dbo].[Profile] ALTER COLUMN [RedFlagDescription] nVarChar(255) ;
 GO 
ALTER TABLE [dbo].[Profile] ALTER COLUMN [Email_3] nVarChar(512) ;
 GO 
ALTER TABLE [dbo].[Profile] ALTER COLUMN [RequestMessage] nVarChar(max) ;
 GO 
ALTER TABLE [dbo].[Profile] ALTER COLUMN [RequestName] nVarChar(1) ;
 GO 
ALTER TABLE [dbo].[Profile] ALTER COLUMN [USERID] nVarChar(50) ;
 GO 
ALTER TABLE [dbo].[Profile] ALTER COLUMN [MName] nVarChar(255) ;
 GO 
ALTER TABLE [dbo].[Profile] ALTER COLUMN [ShortName] nVarChar(5) ;
 GO 
ALTER TABLE [dbo].[Profile] ALTER COLUMN [LName] nVarChar(255) ;
 GO 
ALTER TABLE [dbo].[Profile] ALTER COLUMN [FName] nVarChar(255) ;
 GO 
ALTER TABLE [dbo].[Profile_Batch] ALTER COLUMN [PIC_NAME_2] nVarChar(50) ;
 GO 
ALTER TABLE [dbo].[Profile_Batch] ALTER COLUMN [TaxAddress] nVarChar(255) ;
 GO 
ALTER TABLE [dbo].[Profile_Batch] ALTER COLUMN [Address_4] nVarChar(255) ;
 GO 
ALTER TABLE [dbo].[Profile_Batch] ALTER COLUMN [Address_2] nVarChar(1024) ;
 GO 
ALTER TABLE [dbo].[Profile_Batch] ALTER COLUMN [ID_Name] nVarChar(255) ;
 GO 
ALTER TABLE [dbo].[Profile_Batch] ALTER COLUMN [LastName] nVarChar(255) ;
 GO 
ALTER TABLE [dbo].[Profile_Batch] ALTER COLUMN [NickName] nVarChar(255) ;
 GO 
ALTER TABLE [dbo].[Profile_Batch] ALTER COLUMN [REMARK] nVarChar(255) ;
 GO 
ALTER TABLE [dbo].[Profile_Batch] ALTER COLUMN [BOD_Address_2] nVarChar(1024) ;
 GO 
ALTER TABLE [dbo].[Profile_Batch] ALTER COLUMN [CAddress] nVarChar(255) ;
 GO 
ALTER TABLE [dbo].[Profile_Batch] ALTER COLUMN [Email_1] nVarChar(512) ;
 GO 
ALTER TABLE [dbo].[Profile_Batch] ALTER COLUMN [BOD_Address_3] nVarChar(1024) ;
 GO 
ALTER TABLE [dbo].[Profile_Batch] ALTER COLUMN [Email_3] nVarChar(512) ;
 GO 
ALTER TABLE [dbo].[Profile_Batch] ALTER COLUMN [ShortName] nVarChar(5) ;
 GO 
ALTER TABLE [dbo].[Profile_Batch] ALTER COLUMN [CUSERID] nVarChar(50) ;
 GO 
ALTER TABLE [dbo].[Profile_Batch] ALTER COLUMN [DomicileAddress] nVarChar(512) ;
 GO 
ALTER TABLE [dbo].[Profile_Batch] ALTER COLUMN [PIC_NAME_1] nVarChar(50) ;
 GO 
ALTER TABLE [dbo].[Profile_Batch] ALTER COLUMN [FirstName] nVarChar(255) ;
 GO 
ALTER TABLE [dbo].[Profile_Batch] ALTER COLUMN [USERID] nVarChar(50) ;
 GO 
ALTER TABLE [dbo].[Profile_Batch] ALTER COLUMN [ID_Name_Ext] nVarChar(255) ;
 GO 
ALTER TABLE [dbo].[Profile_Batch] ALTER COLUMN [Last_OPR] nVarChar(50) ;
 GO 
ALTER TABLE [dbo].[Profile_Batch] ALTER COLUMN [FName] nVarChar(255) ;
 GO 
ALTER TABLE [dbo].[Profile_Batch] ALTER COLUMN [PUSERID] nVarChar(50) ;
 GO 
ALTER TABLE [dbo].[Profile_Batch] ALTER COLUMN [ContactAddress_3] nVarChar(225) ;
 GO 
ALTER TABLE [dbo].[Profile_Batch] ALTER COLUMN [TaxName] nVarChar(255) ;
 GO 
ALTER TABLE [dbo].[Profile_Batch] ALTER COLUMN [Address_1] nVarChar(1024) ;
 GO 
ALTER TABLE [dbo].[Profile_Batch] ALTER COLUMN [PIC_NAME_3] nVarChar(50) ;
 GO 
ALTER TABLE [dbo].[Profile_Batch] ALTER COLUMN [CName] nVarChar(255) ;
 GO 
ALTER TABLE [dbo].[Profile_Batch] ALTER COLUMN [MidName] nVarChar(255) ;
 GO 
ALTER TABLE [dbo].[Profile_Batch] ALTER COLUMN [LName] nVarChar(255) ;
 GO 
ALTER TABLE [dbo].[Profile_Batch] ALTER COLUMN [PICAddress] nVarChar(255) ;
 GO 
ALTER TABLE [dbo].[Profile_Batch] ALTER COLUMN [Name] nVarChar(255) ;
 GO 
ALTER TABLE [dbo].[Profile_Batch] ALTER COLUMN [ContactAddress_1] nVarChar(255) ;
 GO 
ALTER TABLE [dbo].[Profile_Batch] ALTER COLUMN [Address_3] nVarChar(1024) ;
 GO 
ALTER TABLE [dbo].[Profile_Batch] ALTER COLUMN [PICNAME] nVarChar(50) ;
 GO 
ALTER TABLE [dbo].[Profile_Batch] ALTER COLUMN [EMail_2] nVarChar(512) ;
 GO 
ALTER TABLE [dbo].[Profile_Batch] ALTER COLUMN [BOD_Address_1] nVarChar(1024) ;
 GO 
ALTER TABLE [dbo].[Profile_Batch] ALTER COLUMN [MName] nVarChar(255) ;
 GO 
ALTER TABLE [dbo].[Profile_Batch] ALTER COLUMN [MothersName] nVarChar(255) ;
 GO 
ALTER TABLE [dbo].[Profile_Consent] ALTER COLUMN [Last_Opr] nVarChar(50) ;
 GO 
ALTER TABLE [dbo].[Profile_Ext] ALTER COLUMN [DomicileAddress] nVarChar(512) ;
 GO 
ALTER TABLE [dbo].[Profile_Ext] ALTER COLUMN [BOD_Address_1] nVarChar(1024) ;
 GO 
ALTER TABLE [dbo].[Profile_Ext] ALTER COLUMN [BOD_Address_2] nVarChar(1024) ;
 GO 
ALTER TABLE [dbo].[Profile_Ext] ALTER COLUMN [BOD_Address_3] nVarChar(1024) ;
 GO 
ALTER TABLE [dbo].[Profile_Ext] ALTER COLUMN [MothersName] nVarChar(255) ;
 GO 
ALTER TABLE [dbo].[Profile_FS] ALTER COLUMN [Last_Opr] nVarChar(50) ;
 GO 
ALTER TABLE [dbo].[Profile_Income] DROP CONSTRAINT [I_Profile_Income];
 GO 
ALTER TABLE [dbo].[Profile_Income] ALTER COLUMN [Description] nVarChar(100) ;
 GO 
ALTER TABLE [dbo].[Profile_Income] WITH NOCHECK ADD CONSTRAINT [I_Profile_Income] PRIMARY KEY NONCLUSTERED( [Income] , [Description] , [AllowedF] , [CorporateF] ) WITH (ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = OFF) ON [PRIMARY]
 GO 
ALTER TABLE [dbo].[Profile_IncomeSource] DROP CONSTRAINT [I_Profile_IncomeSource];
 GO 
ALTER TABLE [dbo].[Profile_IncomeSource] ALTER COLUMN [Description] nVarChar(20) ;
 GO 
ALTER TABLE [dbo].[Profile_IncomeSource] WITH NOCHECK ADD CONSTRAINT [I_Profile_IncomeSource] PRIMARY KEY NONCLUSTERED( [IncomeSource] , [Description] , [AllowedF] , [CorporateF] ) WITH (ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = OFF) ON [PRIMARY]
 GO 
ALTER TABLE [dbo].[Profile_Mandatory] ALTER COLUMN [ControlName] nVarChar(128) ;
 GO 
ALTER TABLE [dbo].[Profile_Mandatory] ALTER COLUMN [PanelName] nVarChar(128) ;
 GO 
ALTER TABLE [dbo].[Profile_Mandatory] ALTER COLUMN [FieldName] nVarChar(128) ;
 GO 
ALTER TABLE [dbo].[Profile_Mandatory] ALTER COLUMN [Description] nVarChar(255) ;
 GO 
ALTER TABLE [dbo].[Profile_Ref] ALTER COLUMN [SaveLocation] nVarChar(255) ;
 GO 
ALTER TABLE [dbo].[Profile_Ref] ALTER COLUMN [TaxAddress] nVarChar(255) ;
 GO 
ALTER TABLE [dbo].[Profile_Ref] ALTER COLUMN [Address] nVarChar(1024) ;
 GO 
ALTER TABLE [dbo].[Profile_Ref] ALTER COLUMN [Name] nVarChar(255) ;
 GO 
ALTER TABLE [dbo].[Profile_Ref] ALTER COLUMN [TaxName] nVarChar(255) ;
 GO 
ALTER TABLE [dbo].[ProfilePIC] ALTER COLUMN [Last_Opr] nVarChar(50) ;
 GO 
ALTER TABLE [dbo].[Province] ALTER COLUMN [Last_OPR] nVarChar(10) ;
 GO 
ALTER TABLE [dbo].[PScale] ALTER COLUMN [Last_Opr] nVarChar(50) ;
 GO 
ALTER TABLE [dbo].[pSL] ALTER COLUMN [Description] nVarChar(512) ;
 GO 
ALTER TABLE [dbo].[pSLRef] ALTER COLUMN [Description] nVarChar(50) ;
 GO 
ALTER TABLE [dbo].[PTClass] ALTER COLUMN [Last_Opr] nVarChar(50) ;
 GO 
ALTER TABLE [dbo].[PTermCon] ALTER COLUMN [Remarks] nVarChar(1000) ;
 GO 
ALTER TABLE [dbo].[PTermCon] ALTER COLUMN [Description_1] nVarChar(512) ;
 GO 
ALTER TABLE [dbo].[PTermCon] ALTER COLUMN [Description] nVarChar(512) ;
 GO 
ALTER TABLE [dbo].[pType] ALTER COLUMN [Last_Opr] nVarChar(10) ;
 GO 
ALTER TABLE [dbo].[pType] ALTER COLUMN [Description] nVarChar(50) ;
 GO 
ALTER TABLE [dbo].[pVoucher] ALTER COLUMN [USERID] nVarChar(50) ;
 GO 
ALTER TABLE [dbo].[pVoucher] ALTER COLUMN [Remarks] nVarChar(max) ;
 GO 
ALTER TABLE [dbo].[pVoucher] ALTER COLUMN [Last_Opr] nVarChar(50) ;
 GO 
ALTER TABLE [dbo].[pVoucher] ALTER COLUMN [RequestName] nVarChar(50) ;
 GO 
ALTER TABLE [dbo].[pVoucher] ALTER COLUMN [AUserID] nVarChar(50) ;
 GO 
ALTER TABLE [dbo].[pVoucher] ALTER COLUMN [AUserID_Ext] nVarChar(50) ;
 GO 
ALTER TABLE [dbo].[pVoucher] ALTER COLUMN [VUserID] nVarChar(50) ;
 GO 
ALTER TABLE [dbo].[pVoucher] ALTER COLUMN [UVUserID] nVarChar(50) ;
 GO 
ALTER TABLE [dbo].[pVoucher] ALTER COLUMN [UAUserID] nVarChar(50) ;
 GO 
ALTER TABLE [dbo].[pVoucher] ALTER COLUMN [UAUserID_Ext] nVarChar(50) ;
 GO 
ALTER TABLE [dbo].[pYearSetup] ALTER COLUMN [Description] nVarChar(20) ;
 GO 
ALTER TABLE [dbo].[QPrintLog] ALTER COLUMN [Description] nVarChar(50) ;
 GO 
ALTER TABLE [dbo].[QPrintLog] ALTER COLUMN [UserID] nVarChar(50) ;
 GO 
ALTER TABLE [dbo].[RAccClassDet] ALTER COLUMN [Description] nVarChar(200) ;
 GO 
ALTER TABLE [dbo].[RARRDET] ALTER COLUMN [USERID] nVarChar(50) ;
 GO 
ALTER TABLE [dbo].[RARRDET] ALTER COLUMN [LUserID] nVarChar(50) ;
 GO 
ALTER TABLE [dbo].[RARRDET] ALTER COLUMN [AUserID] nVarChar(50) ;
 GO 
ALTER TABLE [dbo].[RARRDET] ALTER COLUMN [SysUserID] nVarChar(50) ;
 GO 
ALTER TABLE [dbo].[RARRHEADER] ALTER COLUMN [LUserID] nVarChar(50) ;
 GO 
ALTER TABLE [dbo].[RATECON] ALTER COLUMN [Last_Opr] nVarChar(50) ;
 GO 
ALTER TABLE [dbo].[RATECON] ALTER COLUMN [HoldMessage] nVarChar(512) ;
 GO 
ALTER TABLE [dbo].[RATECON_M1] ALTER COLUMN [Last_Opr] nVarChar(50) ;
 GO 
ALTER TABLE [dbo].[RATECON_M1] ALTER COLUMN [HoldMessage] nVarChar(512) ;
 GO 
ALTER TABLE [dbo].[RATECON_M2] ALTER COLUMN [Last_Opr] nVarChar(50) ;
 GO 
ALTER TABLE [dbo].[RATECON_M2] ALTER COLUMN [HoldMessage] nVarChar(512) ;
 GO 
ALTER TABLE [dbo].[RATECON_M3] ALTER COLUMN [Last_Opr] nVarChar(50) ;
 GO 
ALTER TABLE [dbo].[RATECON_M3] ALTER COLUMN [HoldMessage] nVarChar(512) ;
 GO 
ALTER TABLE [dbo].[RATECON_M4] ALTER COLUMN [Last_Opr] nVarChar(50) ;
 GO 
ALTER TABLE [dbo].[RATECON_M4] ALTER COLUMN [HoldMessage] nVarChar(512) ;
 GO 
ALTER TABLE [dbo].[RATECON_M5] ALTER COLUMN [HoldMessage] nVarChar(512) ;
 GO 
ALTER TABLE [dbo].[RATECON_M5] ALTER COLUMN [Last_Opr] nVarChar(50) ;
 GO 
ALTER TABLE [dbo].[RATECON_M6] ALTER COLUMN [HoldMessage] nVarChar(512) ;
 GO 
ALTER TABLE [dbo].[RATECON_M6] ALTER COLUMN [Last_Opr] nVarChar(50) ;
 GO 
ALTER TABLE [dbo].[RATECON_M7] ALTER COLUMN [Last_Opr] nVarChar(50) ;
 GO 
ALTER TABLE [dbo].[RATECON_M7] ALTER COLUMN [HoldMessage] nVarChar(512) ;
 GO 
ALTER TABLE [dbo].[RATECOV] ALTER COLUMN [DESCRIPTION] nVarChar(255) ;
 GO 
ALTER TABLE [dbo].[RATECOV] ALTER COLUMN [Last_Opr] nVarChar(50) ;
 GO 
ALTER TABLE [dbo].[RateIndemnity] ALTER COLUMN [Last_Opr] nVarChar(50) ;
 GO 
ALTER TABLE [dbo].[RateMin] ALTER COLUMN [Last_Opr] nVarChar(50) ;
 GO 
ALTER TABLE [dbo].[RATETAB] ALTER COLUMN [Last_Opr] nVarChar(50) ;
 GO 
ALTER TABLE [dbo].[RATETAB] ALTER COLUMN [DESCRIPTION] nVarChar(255) ;
 GO 
ALTER TABLE [dbo].[RateTabCla] ALTER COLUMN [SHORTDESC] nVarChar(max) ;
 GO 
ALTER TABLE [dbo].[RateTabCla] ALTER COLUMN [ShortDesc_1] nVarChar(max) ;
 GO 
ALTER TABLE [dbo].[RateTabCon] ALTER COLUMN [ShortDesc_1] nVarChar(max) ;
 GO 
ALTER TABLE [dbo].[RateTabCon] ALTER COLUMN [SHORTDESC] nVarChar(max) ;
 GO 
ALTER TABLE [dbo].[RateTabEx] ALTER COLUMN [SHORTDESC] nVarChar(max) ;
 GO 
ALTER TABLE [dbo].[RateTabEx] ALTER COLUMN [ShortDesc_1] nVarChar(max) ;
 GO 
ALTER TABLE [dbo].[RatingAgency] ALTER COLUMN [Description] nVarChar(255) ;
 GO 
ALTER TABLE [dbo].[RatingAgency] ALTER COLUMN [Last_Opr] nVarChar(50) ;
 GO 
ALTER TABLE [dbo].[RCCode] ALTER COLUMN [Last_Opr] nVarChar(50) ;
 GO 
ALTER TABLE [dbo].[RCCode] ALTER COLUMN [Description] nVarChar(255) ;
 GO 
ALTER TABLE [dbo].[RCLASS] ALTER COLUMN [Last_Opr] nVarChar(50) ;
 GO 
ALTER TABLE [dbo].[RCOVER] ALTER COLUMN [LUserID] nVarChar(50) ;
 GO 
ALTER TABLE [dbo].[RCOVER] ALTER COLUMN [REMARK] nVarChar(max) ;
 GO 
ALTER TABLE [dbo].[RDOCLIST] ALTER COLUMN [DESCRIPTION] nVarChar(255) ;
 GO 
ALTER TABLE [dbo].[RDOCLIST] ALTER COLUMN [REMARKS] nVarChar(512) ;
 GO 
ALTER TABLE [dbo].[RDOCLIST] ALTER COLUMN [LAST_OPR] nVarChar(50) ;
 GO 
ALTER TABLE [dbo].[RDOCLISTPIC] ALTER COLUMN [Last_Opr] nVarChar(50) ;
 GO 
ALTER TABLE [dbo].[Reason] ALTER COLUMN [Last_Opr] nVarChar(50) ;
 GO 
ALTER TABLE [dbo].[Reason] ALTER COLUMN [Description] nVarChar(100) ;
 GO 
ALTER TABLE [dbo].[RECLASS] ALTER COLUMN [Last_Opr] nVarChar(50) ;
 GO 
ALTER TABLE [dbo].[RefProfile] ALTER COLUMN [Name] nVarChar(512) ;
 GO 
ALTER TABLE [dbo].[RefProfile] ALTER COLUMN [Address_1] nVarChar(255) ;
 GO 
ALTER TABLE [dbo].[RefProfile] ALTER COLUMN [Address_2] nVarChar(255) ;
 GO 
ALTER TABLE [dbo].[RefProfile] ALTER COLUMN [Address_3] nVarChar(255) ;
 GO 
ALTER TABLE [dbo].[ReinsPIC] ALTER COLUMN [Last_Opr] nVarChar(50) ;
 GO 
ALTER TABLE [dbo].[REINSURANCE] ALTER COLUMN [Last_Opr] nVarChar(50) ;
 GO 
ALTER TABLE [dbo].[REINSURANCE] ALTER COLUMN [REMARKS] nVarChar(255) ;
 GO 
ALTER TABLE [dbo].[REINSURANCE] ALTER COLUMN [DESCRIPTION] nVarChar(255) ;
 GO 
ALTER TABLE [dbo].[Reminder] ALTER COLUMN [Description] nVarChar(50) ;
 GO 
ALTER TABLE [dbo].[ReminderD] ALTER COLUMN [Last_Opr] nVarChar(50) ;
 GO 
ALTER TABLE [dbo].[ReminderV] ALTER COLUMN [Last_Opr] nVarChar(50) ;
 GO 
ALTER TABLE [dbo].[Renewal] ALTER COLUMN [AName] nVarChar(max) ;
 GO 
ALTER TABLE [dbo].[Renewal] ALTER COLUMN [USERID] nVarChar(50) ;
 GO 
ALTER TABLE [dbo].[Renewal] ALTER COLUMN [LUserID] nVarChar(50) ;
 GO 
ALTER TABLE [dbo].[RenewalDA] ALTER COLUMN [Address] nVarChar(1024) ;
 GO 
ALTER TABLE [dbo].[RenewalDA] ALTER COLUMN [Email] nVarChar(512) ;
 GO 
ALTER TABLE [dbo].[RenewalRight] ALTER COLUMN [Description] nVarChar(150) ;
 GO 
ALTER TABLE [dbo].[RenewalRight] ALTER COLUMN [Last_Opr] nVarChar(50) ;
 GO 
ALTER TABLE [dbo].[RenewalRule] ALTER COLUMN [Last_Opr] nVarChar(50) ;
 GO 
ALTER TABLE [dbo].[REPOLICY] ALTER COLUMN [Last_Opr] nVarChar(50) ;
 GO 
ALTER TABLE [dbo].[Report_Portal] ALTER COLUMN [Name] nVarChar(255) ;
 GO 
ALTER TABLE [dbo].[Request] ALTER COLUMN [USERID] nVarChar(50) ;
 GO 
ALTER TABLE [dbo].[Request] ALTER COLUMN [Last_Opr] nVarChar(50) ;
 GO 
ALTER TABLE [dbo].[Request] ALTER COLUMN [AUserID] nVarChar(50) ;
 GO 
ALTER TABLE [dbo].[Request] ALTER COLUMN [CUSERID] nVarChar(50) ;
 GO 
ALTER TABLE [dbo].[Request] ALTER COLUMN [VUserID] nVarChar(50) ;
 GO 
ALTER TABLE [dbo].[Request] ALTER COLUMN [AUserID_Ext] nVarChar(50) ;
 GO 
ALTER TABLE [dbo].[Request] ALTER COLUMN [VUserID_Ext] nVarChar(50) ;
 GO 
ALTER TABLE [dbo].[Request] ALTER COLUMN [AUserID_Ext_2] nVarChar(50) ;
 GO 
ALTER TABLE [dbo].[Request] ALTER COLUMN [VUserID_Ext_2] nVarChar(50) ;
 GO 
ALTER TABLE [dbo].[Request] ALTER COLUMN [UVUserID] nVarChar(50) ;
 GO 
ALTER TABLE [dbo].[Request] ALTER COLUMN [UVUserID_Ext] nVarChar(50) ;
 GO 
ALTER TABLE [dbo].[Request] ALTER COLUMN [UVUserID_Ext_2] nVarChar(50) ;
 GO 
ALTER TABLE [dbo].[Request] ALTER COLUMN [UAUserID] nVarChar(50) ;
 GO 
ALTER TABLE [dbo].[Request] ALTER COLUMN [UAUserID_Ext] nVarChar(50) ;
 GO 
ALTER TABLE [dbo].[Request] ALTER COLUMN [UAUserID_Ext_2] nVarChar(50) ;
 GO 
ALTER TABLE [dbo].[RequestExt] ALTER COLUMN [Ent_Address] nVarChar(255) ;
 GO 
ALTER TABLE [dbo].[RequestExt] ALTER COLUMN [Last_Opr] nVarChar(50) ;
 GO 
ALTER TABLE [dbo].[RequestExt] ALTER COLUMN [CoyName] nVarChar(255) ;
 GO 
ALTER TABLE [dbo].[RequestExt] ALTER COLUMN [Name] nVarChar(255) ;
 GO 
ALTER TABLE [dbo].[RequestPic] ALTER COLUMN [Last_Opr] nVarChar(50) ;
 GO 
ALTER TABLE [dbo].[RequestPic] ALTER COLUMN [UserID] nVarChar(50) ;
 GO 
ALTER TABLE [dbo].[RERATE] ALTER COLUMN [Last_Opr] nVarChar(50) ;
 GO 
ALTER TABLE [dbo].[REXCLA] ALTER COLUMN [SHORTDESC] nVarChar(max) ;
 GO 
ALTER TABLE [dbo].[RISKASS] ALTER COLUMN [HoldMessage] nVarChar(512) ;
 GO 
ALTER TABLE [dbo].[RISKASS] ALTER COLUMN [Last_Opr] nVarChar(50) ;
 GO 
ALTER TABLE [dbo].[RLTable] ALTER COLUMN [Last_Opr] nVarChar(50) ;
 GO 
ALTER TABLE [dbo].[RLTableC] ALTER COLUMN [Last_Opr] nVarChar(50) ;
 GO 
ALTER TABLE [dbo].[RLTableH] ALTER COLUMN [Description] nVarChar(255) ;
 GO 
ALTER TABLE [dbo].[RLTableH] ALTER COLUMN [Last_Opr] nVarChar(50) ;
 GO 
ALTER TABLE [dbo].[RLTableR] ALTER COLUMN [Last_Opr] nVarChar(50) ;
 GO 
ALTER TABLE [dbo].[RPART] ALTER COLUMN [Last_Opr] nVarChar(50) ;
 GO 
ALTER TABLE [dbo].[RPART] ALTER COLUMN [REMARKS] nVarChar(255) ;
 GO 
ALTER TABLE [dbo].[RPBucket] ALTER COLUMN [pSLRef_Description_2] nVarChar(50) ;
 GO 
ALTER TABLE [dbo].[RPBucket] ALTER COLUMN [BankName] nVarChar(255) ;
 GO 
ALTER TABLE [dbo].[RPBucket] ALTER COLUMN [Last_Opr] nVarChar(10) ;
 GO 
ALTER TABLE [dbo].[RPBucket] ALTER COLUMN [pSLRef_Description_3] nVarChar(50) ;
 GO 
ALTER TABLE [dbo].[RPBucket] ALTER COLUMN [pSLRef_Description_4] nVarChar(50) ;
 GO 
ALTER TABLE [dbo].[RPBucket] ALTER COLUMN [pSLRef_Description_1] nVarChar(50) ;
 GO 
ALTER TABLE [dbo].[RPBucket] ALTER COLUMN [pSLRef_Description_5] nVarChar(50) ;
 GO 
ALTER TABLE [dbo].[RPrintLog] ALTER COLUMN [Description] nVarChar(50) ;
 GO 
ALTER TABLE [dbo].[RPrintLog] ALTER COLUMN [UserID] nVarChar(50) ;
 GO 
DROP INDEX [dbo].[RQPrintLog].[I_RQPrintLog_Request_DocNo_Description];
 GO 
ALTER TABLE [dbo].[RQPrintLog] ALTER COLUMN [Description] nVarChar(50) ;
 GO 
CREATE NONCLUSTERED INDEX [I_RQPrintLog_Request_DocNo_Description] ON [dbo].[RQPrintLog] (  [Request] , [DocNo] , [Description] )
 GO 
ALTER TABLE [dbo].[RQPrintLog] ALTER COLUMN [UserID] nVarChar(50) ;
 GO 
ALTER TABLE [dbo].[RTYPE] ALTER COLUMN [Description] nVarChar(20) ;
 GO 
ALTER TABLE [dbo].[SAccCA] ALTER COLUMN [Address] nVarChar(1024) ;
 GO 
ALTER TABLE [dbo].[SAccCA] ALTER COLUMN [Email] nVarChar(512) ;
 GO 
ALTER TABLE [dbo].[SAccDA] ALTER COLUMN [Address] nVarChar(1024) ;
 GO 
ALTER TABLE [dbo].[SAccDA] ALTER COLUMN [Email] nVarChar(512) ;
 GO 
ALTER TABLE [dbo].[SAccPic] ALTER COLUMN [UserID] nVarChar(50) ;
 GO 
ALTER TABLE [dbo].[SAccPic] ALTER COLUMN [Last_Opr] nVarChar(50) ;
 GO 
ALTER TABLE [dbo].[SaldoAwalComAcc] ALTER COLUMN [Description] nVarChar(255) ;
 GO 
ALTER TABLE [dbo].[SAP_FSG_TABLE] ALTER COLUMN [Description] nVarChar(255) ;
 GO 
ALTER TABLE [dbo].[SAP_JOURNAL] ALTER COLUMN [Description] nVarChar(100) ;
 GO 
ALTER TABLE [dbo].[SAP_JOURNAL] ALTER COLUMN [Last_Opr] nVarChar(50) ;
 GO 
ALTER TABLE [dbo].[SAPLog] ALTER COLUMN [FILENAME] nVarChar(255) ;
 GO 
ALTER TABLE [dbo].[SAPLogDetail] ALTER COLUMN [DESCRIPTION] nVarChar(255) ;
 GO 
ALTER TABLE [dbo].[ScaleTab] ALTER COLUMN [Last_Opr] nVarChar(50) ;
 GO 
ALTER TABLE [dbo].[SCGroup] ALTER COLUMN [Description] nVarChar(100) ;
 GO 
ALTER TABLE [dbo].[SCGroup] ALTER COLUMN [Last_Opr] nVarChar(50) ;
 GO 
ALTER TABLE [dbo].[Scheme_Additional] ALTER COLUMN [Last_Opr] nVarChar(50) ;
 GO 
ALTER TABLE [dbo].[Scheme_Assignment] ALTER COLUMN [Last_Opr] nVarChar(50) ;
 GO 
ALTER TABLE [dbo].[Scheme_Assignment] ALTER COLUMN [Description] nVarChar(100) ;
 GO 
ALTER TABLE [dbo].[Scheme_Beneficiary] DROP CONSTRAINT [I_Scheme_Beneficiary];
 GO 
ALTER TABLE [dbo].[Scheme_Beneficiary] ALTER COLUMN [Name] nVarChar(255) ;
 GO 
ALTER TABLE [dbo].[Scheme_Beneficiary] WITH NOCHECK ADD CONSTRAINT [I_Scheme_Beneficiary] PRIMARY KEY NONCLUSTERED( [TrNo] , [ID] , [Name] ) WITH (ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = OFF) ON [PRIMARY]
 GO 
ALTER TABLE [dbo].[Scheme_Beneficiary] ALTER COLUMN [Address_1] nVarChar(1024) ;
 GO 
ALTER TABLE [dbo].[Scheme_Beneficiary] ALTER COLUMN [Address_2] nVarChar(1024) ;
 GO 
ALTER TABLE [dbo].[Scheme_Beneficiary] ALTER COLUMN [REMARK] nVarChar(255) ;
 GO 
ALTER TABLE [dbo].[Scheme_CA] ALTER COLUMN [Address] nVarChar(1024) ;
 GO 
ALTER TABLE [dbo].[Scheme_CA] ALTER COLUMN [Email] nVarChar(512) ;
 GO 
ALTER TABLE [dbo].[Scheme_Cla] ALTER COLUMN [SHORTDESC] nVarChar(max) ;
 GO 
ALTER TABLE [dbo].[Scheme_Cla] ALTER COLUMN [ShortDesc_1] nVarChar(max) ;
 GO 
ALTER TABLE [dbo].[Scheme_Class] ALTER COLUMN [VALUEDESC2] nVarChar(255) ;
 GO 
ALTER TABLE [dbo].[Scheme_Class] ALTER COLUMN [Last_Opr] nVarChar(50) ;
 GO 
ALTER TABLE [dbo].[Scheme_Class] ALTER COLUMN [VALUEDESC13] nVarChar(255) ;
 GO 
ALTER TABLE [dbo].[Scheme_Class] ALTER COLUMN [VALUEDESC14] nVarChar(255) ;
 GO 
ALTER TABLE [dbo].[Scheme_Class] ALTER COLUMN [VALUEDESC15] nVarChar(255) ;
 GO 
ALTER TABLE [dbo].[Scheme_Class] DROP CONSTRAINT [I_Scheme_Class_SchemeNo_Description];
 GO 
DROP INDEX [dbo].[Scheme_Class].[I_Scheme_Class_Description];
 GO 
ALTER TABLE [dbo].[Scheme_Class] ALTER COLUMN [Description] nVarChar(100) ;
 GO 
ALTER TABLE [dbo].[Scheme_Class] ADD CONSTRAINT [I_Scheme_Class_SchemeNo_Description] UNIQUE( [SchemeNo] , [Description] ) WITH (ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = OFF) ON [PRIMARY]
 GO 
CREATE NONCLUSTERED INDEX [I_Scheme_Class_Description] ON [dbo].[Scheme_Class] (  [Description] )
 GO 
ALTER TABLE [dbo].[Scheme_Class] ALTER COLUMN [VALUEDESC1] nVarChar(255) ;
 GO 
ALTER TABLE [dbo].[Scheme_Class] ALTER COLUMN [VALUEDESC5] nVarChar(255) ;
 GO 
ALTER TABLE [dbo].[Scheme_Class] ALTER COLUMN [VALUEDESC6] nVarChar(255) ;
 GO 
ALTER TABLE [dbo].[Scheme_Class] ALTER COLUMN [VALUEDESC7] nVarChar(255) ;
 GO 
ALTER TABLE [dbo].[Scheme_Class] ALTER COLUMN [VALUEDESC12] nVarChar(255) ;
 GO 
ALTER TABLE [dbo].[Scheme_Class] ALTER COLUMN [VALUEDESC3] nVarChar(255) ;
 GO 
ALTER TABLE [dbo].[Scheme_Class] ALTER COLUMN [VALUEDESC4] nVarChar(255) ;
 GO 
ALTER TABLE [dbo].[Scheme_Class] ALTER COLUMN [VALUEDESC9] nVarChar(255) ;
 GO 
ALTER TABLE [dbo].[Scheme_Class] ALTER COLUMN [VALUEDESC11] nVarChar(255) ;
 GO 
ALTER TABLE [dbo].[Scheme_Class] ALTER COLUMN [VALUEDESC8] nVarChar(255) ;
 GO 
ALTER TABLE [dbo].[Scheme_Class] ALTER COLUMN [VALUEDESC10] nVarChar(255) ;
 GO 
ALTER TABLE [dbo].[Scheme_Con] ALTER COLUMN [SHORTDESC] nVarChar(max) ;
 GO 
ALTER TABLE [dbo].[Scheme_Con] ALTER COLUMN [ShortDesc_1] nVarChar(max) ;
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
ALTER TABLE [dbo].[Scheme_Detail] ALTER COLUMN [DESCRIPTION] nVarChar(255) ;
 GO 
ALTER TABLE [dbo].[Scheme_Detail] WITH NOCHECK ADD CONSTRAINT [I_Scheme_Detail] PRIMARY KEY NONCLUSTERED( [TrNo] , [IntNo] , [DESCRIPTION] ) WITH (ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = OFF) ON [PRIMARY]
 GO 
ALTER TABLE [dbo].[Scheme_Endorsement] ALTER COLUMN [Last_Opr] nVarChar(50) ;
 GO 
ALTER TABLE [dbo].[Scheme_Ex] ALTER COLUMN [SHORTDESC] nVarChar(max) ;
 GO 
ALTER TABLE [dbo].[Scheme_Ex] ALTER COLUMN [ShortDesc_1] nVarChar(max) ;
 GO 
ALTER TABLE [dbo].[Scheme_Indemnity] ALTER COLUMN [Last_Opr] nVarChar(50) ;
 GO 
ALTER TABLE [dbo].[SCHEME_INPARTY] ALTER COLUMN [Beneficiary_Name] nVarChar(255) ;
 GO 
ALTER TABLE [dbo].[SCHEME_INPARTY] DROP CONSTRAINT [I_SCHEME_INPARTY];
 GO 
ALTER TABLE [dbo].[SCHEME_INPARTY] ALTER COLUMN [Name] nVarChar(255) ;
 GO 
ALTER TABLE [dbo].[SCHEME_INPARTY] WITH NOCHECK ADD CONSTRAINT [I_SCHEME_INPARTY] PRIMARY KEY NONCLUSTERED( [TrNo] , [Name] ) WITH (ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = OFF) ON [PRIMARY]
 GO 
ALTER TABLE [dbo].[SCHEME_INPARTY] ALTER COLUMN [Address_1] nVarChar(1024) ;
 GO 
ALTER TABLE [dbo].[SCHEME_INPARTY] ALTER COLUMN [Address_2] nVarChar(1024) ;
 GO 
ALTER TABLE [dbo].[SCHEME_INPARTY] ALTER COLUMN [REMARK] nVarChar(255) ;
 GO 
ALTER TABLE [dbo].[Scheme_Interest] ALTER COLUMN [Last_Opr] nVarChar(50) ;
 GO 
ALTER TABLE [dbo].[Scheme_InterestType] ALTER COLUMN [Last_Opr] nVarChar(50) ;
 GO 
ALTER TABLE [dbo].[Scheme_Master] ALTER COLUMN [Last_Opr] nVarChar(50) ;
 GO 
ALTER TABLE [dbo].[Scheme_Master] ALTER COLUMN [Description] nVarChar(100) ;
 GO 
ALTER TABLE [dbo].[Scheme_Payor] ALTER COLUMN [ADDRESS_1] nVarChar(1024) ;
 GO 
ALTER TABLE [dbo].[Scheme_Payor] ALTER COLUMN [ADDRESS_2] nVarChar(1024) ;
 GO 
ALTER TABLE [dbo].[Scheme_Payor] ALTER COLUMN [ADDRESS_3] nVarChar(1024) ;
 GO 
ALTER TABLE [dbo].[Scheme_Payor] ALTER COLUMN [BankName] nVarChar(150) ;
 GO 
ALTER TABLE [dbo].[Scheme_Payor] ALTER COLUMN [LUserID] nVarChar(50) ;
 GO 
ALTER TABLE [dbo].[Scheme_Transaction] ALTER COLUMN [VALUEDESC17] nVarChar(8000) ;
 GO 
ALTER TABLE [dbo].[Scheme_Transaction] ALTER COLUMN [VALUEDESC19] nVarChar(8000) ;
 GO 
ALTER TABLE [dbo].[Scheme_Transaction] ALTER COLUMN [VALUEDESC13] nVarChar(255) ;
 GO 
ALTER TABLE [dbo].[Scheme_Transaction] ALTER COLUMN [Correspondence_Email] nVarChar(50) ;
 GO 
ALTER TABLE [dbo].[Scheme_Transaction] ALTER COLUMN [VALUEDESC18] nVarChar(8000) ;
 GO 
ALTER TABLE [dbo].[Scheme_Transaction] ALTER COLUMN [VALUEDESC15] nVarChar(255) ;
 GO 
ALTER TABLE [dbo].[Scheme_Transaction] ALTER COLUMN [VALUEDESC21] nVarChar(8000) ;
 GO 
ALTER TABLE [dbo].[Scheme_Transaction] ALTER COLUMN [VALUEDESC20] nVarChar(8000) ;
 GO 
ALTER TABLE [dbo].[Scheme_Transaction] ALTER COLUMN [VALUEDESC14] nVarChar(255) ;
 GO 
ALTER TABLE [dbo].[Scheme_Transaction] ALTER COLUMN [VALUEDESC10] nVarChar(255) ;
 GO 
ALTER TABLE [dbo].[Scheme_Transaction] ALTER COLUMN [VALUEDESC11] nVarChar(255) ;
 GO 
ALTER TABLE [dbo].[Scheme_Transaction] ALTER COLUMN [VALUEDESC12] nVarChar(255) ;
 GO 
ALTER TABLE [dbo].[Scheme_Transaction] ALTER COLUMN [VALUEDESC27] nVarChar(8000) ;
 GO 
ALTER TABLE [dbo].[Scheme_Transaction] ALTER COLUMN [VALUEDESC9] nVarChar(255) ;
 GO 
ALTER TABLE [dbo].[Scheme_Transaction] ALTER COLUMN [VALUEDESC7] nVarChar(255) ;
 GO 
ALTER TABLE [dbo].[Scheme_Transaction] ALTER COLUMN [VALUEDESC8] nVarChar(255) ;
 GO 
ALTER TABLE [dbo].[Scheme_Transaction] ALTER COLUMN [AName] nVarChar(max) ;
 GO 
ALTER TABLE [dbo].[Scheme_Transaction] ALTER COLUMN [VALUEDESC1] nVarChar(255) ;
 GO 
ALTER TABLE [dbo].[Scheme_Transaction] ALTER COLUMN [LUserID] nVarChar(50) ;
 GO 
ALTER TABLE [dbo].[Scheme_Transaction] ALTER COLUMN [VALUEDESC] nVarChar(255) ;
 GO 
ALTER TABLE [dbo].[Scheme_Transaction] ALTER COLUMN [Address] nVarChar(1024) ;
 GO 
ALTER TABLE [dbo].[Scheme_Transaction] ALTER COLUMN [Email] nVarChar(512) ;
 GO 
ALTER TABLE [dbo].[Scheme_Transaction] ALTER COLUMN [VALUEDESC16] nVarChar(8000) ;
 GO 
ALTER TABLE [dbo].[Scheme_Transaction] ALTER COLUMN [REMARKS] nVarChar(255) ;
 GO 
ALTER TABLE [dbo].[Scheme_Transaction] ALTER COLUMN [CUSERID] nVarChar(50) ;
 GO 
ALTER TABLE [dbo].[Scheme_Transaction] ALTER COLUMN [RUSERID] nVarChar(50) ;
 GO 
ALTER TABLE [dbo].[Scheme_Transaction] ALTER COLUMN [LOCATION] nVarChar(100) ;
 GO 
ALTER TABLE [dbo].[Scheme_Transaction] ALTER COLUMN [Correspondence_Address] nVarChar(255) ;
 GO 
ALTER TABLE [dbo].[Scheme_Transaction] ALTER COLUMN [VALUEDESC24] nVarChar(8000) ;
 GO 
ALTER TABLE [dbo].[Scheme_Transaction] ALTER COLUMN [VALUEDESC23] nVarChar(8000) ;
 GO 
ALTER TABLE [dbo].[Scheme_Transaction] ALTER COLUMN [VALUEDESC25] nVarChar(8000) ;
 GO 
ALTER TABLE [dbo].[Scheme_Transaction] ALTER COLUMN [VALUEDESC26] nVarChar(8000) ;
 GO 
ALTER TABLE [dbo].[Scheme_Transaction] ALTER COLUMN [VALUEDESC2] nVarChar(255) ;
 GO 
ALTER TABLE [dbo].[Scheme_Transaction] ALTER COLUMN [VALUEDESC29] nVarChar(8000) ;
 GO 
ALTER TABLE [dbo].[Scheme_Transaction] ALTER COLUMN [VALUEDESC4] nVarChar(255) ;
 GO 
ALTER TABLE [dbo].[Scheme_Transaction] ALTER COLUMN [VALUEDESC28] nVarChar(8000) ;
 GO 
ALTER TABLE [dbo].[Scheme_Transaction] ALTER COLUMN [VALUEDESC3] nVarChar(255) ;
 GO 
ALTER TABLE [dbo].[Scheme_Transaction] ALTER COLUMN [VALUEDESC30] nVarChar(8000) ;
 GO 
ALTER TABLE [dbo].[Scheme_Transaction] ALTER COLUMN [VALUEDESC5] nVarChar(255) ;
 GO 
ALTER TABLE [dbo].[Scheme_Transaction] ALTER COLUMN [VALUEDESC6] nVarChar(255) ;
 GO 
ALTER TABLE [dbo].[Scheme_Transaction] ALTER COLUMN [VALUEDESC22] nVarChar(8000) ;
 GO 
ALTER TABLE [dbo].[Scheme_TransactionDet] DROP CONSTRAINT [I_Scheme_TransactionDet];
 GO 
ALTER TABLE [dbo].[Scheme_TransactionDet] ALTER COLUMN [DESCRIPTION] nVarChar(255) ;
 GO 
ALTER TABLE [dbo].[Scheme_TransactionDet] WITH NOCHECK ADD CONSTRAINT [I_Scheme_TransactionDet] PRIMARY KEY NONCLUSTERED( [TrNo] , [DESCRIPTION] ) WITH (ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = OFF) ON [PRIMARY]
 GO 
ALTER TABLE [dbo].[SCOINSURANCE] ALTER COLUMN [LUserID] nVarChar(50) ;
 GO 
ALTER TABLE [dbo].[SCOINSURANCE] ALTER COLUMN [USERID] nVarChar(50) ;
 GO 
ALTER TABLE [dbo].[Scoring] ALTER COLUMN [LAST_OPR] nVarChar(50) ;
 GO 
ALTER TABLE [dbo].[ScoringV] ALTER COLUMN [LAST_OPR] nVarChar(50) ;
 GO 
ALTER TABLE [dbo].[SECTION] ALTER COLUMN [Last_Opr] nVarChar(50) ;
 GO 
ALTER TABLE [dbo].[SectionD] ALTER COLUMN [Name] nVarChar(255) ;
 GO 
ALTER TABLE [dbo].[SectionH] ALTER COLUMN [Last_Opr] nVarChar(10) ;
 GO 
ALTER TABLE [dbo].[SectionH] ALTER COLUMN [Name] nVarChar(255) ;
 GO 
ALTER TABLE [dbo].[Security] ALTER COLUMN [Last_Opr] nVarChar(50) ;
 GO 
ALTER TABLE [dbo].[Segment] ALTER COLUMN [Last_Opr] nVarChar(50) ;
 GO 
ALTER TABLE [dbo].[Segment] ALTER COLUMN [Description] nVarChar(255) ;
 GO 
ALTER TABLE [dbo].[Segment_AAUI] ALTER COLUMN [Description] nVarChar(255) ;
 GO 
ALTER TABLE [dbo].[Segment_AAUI] ALTER COLUMN [Last_Opr] nVarChar(50) ;
 GO 
ALTER TABLE [dbo].[SEGMENTGROUP] ALTER COLUMN [Last_Opr] nVarChar(50) ;
 GO 
ALTER TABLE [dbo].[SEGMENTGROUP] ALTER COLUMN [DESCRIPTION] nVarChar(100) ;
 GO 
ALTER TABLE [dbo].[Service] ALTER COLUMN [Name] nVarChar(255) ;
 GO 
ALTER TABLE [dbo].[Service] ALTER COLUMN [Address_1] nVarChar(1024) ;
 GO 
ALTER TABLE [dbo].[Service] ALTER COLUMN [Address_2] nVarChar(1024) ;
 GO 
ALTER TABLE [dbo].[Service] ALTER COLUMN [BSName] nVarChar(255) ;
 GO 
ALTER TABLE [dbo].[Service] ALTER COLUMN [USERID] nVarChar(50) ;
 GO 
ALTER TABLE [dbo].[Service] ALTER COLUMN [LUSERID] nVarChar(50) ;
 GO 
ALTER TABLE [dbo].[Service] ALTER COLUMN [REMARKS] nVarChar(255) ;
 GO 
ALTER TABLE [dbo].[Service] ALTER COLUMN [CUSERID] nVarChar(50) ;
 GO 
ALTER TABLE [dbo].[Service] ALTER COLUMN [AUSERID] nVarChar(50) ;
 GO 
ALTER TABLE [dbo].[Service] ALTER COLUMN [PUserID] nVarChar(50) ;
 GO 
ALTER TABLE [dbo].[Service] ALTER COLUMN [VALUEDESC] nVarChar(255) ;
 GO 
ALTER TABLE [dbo].[Service] ALTER COLUMN [RequestMessage] nVarChar(512) ;
 GO 
ALTER TABLE [dbo].[Service] ALTER COLUMN [RequestName] nVarChar(50) ;
 GO 
ALTER TABLE [dbo].[Service] ALTER COLUMN [RUserID] nVarChar(50) ;
 GO 
ALTER TABLE [dbo].[Service] ALTER COLUMN [ClaimantName] nVarChar(255) ;
 GO 
ALTER TABLE [dbo].[Service] ALTER COLUMN [ClaimantEmail] nVarChar(255) ;
 GO 
ALTER TABLE [dbo].[Service] ALTER COLUMN [Location] nVarChar(10) ;
 GO 
ALTER TABLE [dbo].[Service] ALTER COLUMN [Description] nVarChar(max) ;
 GO 
ALTER TABLE [dbo].[Service] ALTER COLUMN [SurveyLocation] nVarChar(255) ;
 GO 
ALTER TABLE [dbo].[Service] ALTER COLUMN [Comment] nVarChar(max) ;
 GO 
ALTER TABLE [dbo].[Service] ALTER COLUMN [PIC_NAME_1] nVarChar(50) ;
 GO 
ALTER TABLE [dbo].[Service] ALTER COLUMN [PIC_NAME_3] nVarChar(50) ;
 GO 
ALTER TABLE [dbo].[Service] ALTER COLUMN [PIC_NAME_2] nVarChar(50) ;
 GO 
ALTER TABLE [dbo].[SFPART] ALTER COLUMN [Remarks] nVarChar(255) ;
 GO 
ALTER TABLE [dbo].[ShortPeriod] ALTER COLUMN [Last_Opr] nVarChar(10) ;
 GO 
ALTER TABLE [dbo].[SL_Cat] ALTER COLUMN [Description] nVarChar(30) ;
 GO 
ALTER TABLE [dbo].[SL_Request] ALTER COLUMN [Description] nVarChar(512) ;
 GO 
ALTER TABLE [dbo].[SL_RequestRef] ALTER COLUMN [Description] nVarChar(50) ;
 GO 
ALTER TABLE [dbo].[SPayor] ALTER COLUMN [ADDRESS_1] nVarChar(1024) ;
 GO 
ALTER TABLE [dbo].[SPayor] ALTER COLUMN [ADDRESS_2] nVarChar(1024) ;
 GO 
ALTER TABLE [dbo].[SPayor] ALTER COLUMN [ADDRESS_3] nVarChar(1024) ;
 GO 
ALTER TABLE [dbo].[SPayor] ALTER COLUMN [BankName] nVarChar(150) ;
 GO 
ALTER TABLE [dbo].[SPrintLog] ALTER COLUMN [Description] nVarChar(50) ;
 GO 
ALTER TABLE [dbo].[SPrintLog] ALTER COLUMN [UserID] nVarChar(50) ;
 GO 
ALTER TABLE [dbo].[SRARRDET] ALTER COLUMN [AUserID] nVarChar(50) ;
 GO 
ALTER TABLE [dbo].[SRARRDET] ALTER COLUMN [USERID] nVarChar(50) ;
 GO 
ALTER TABLE [dbo].[SRARRDET] ALTER COLUMN [SysUserID] nVarChar(50) ;
 GO 
ALTER TABLE [dbo].[SRARRDET] ALTER COLUMN [LUserID] nVarChar(50) ;
 GO 
ALTER TABLE [dbo].[SubDistrict] ALTER COLUMN [Last_OPR] nVarChar(10) ;
 GO 
ALTER TABLE [dbo].[SUINFO] ALTER COLUMN [VALUEDESC1] nVarChar(max) ;
 GO 
ALTER TABLE [dbo].[SUINFO] ALTER COLUMN [VALUEDESC2] nVarChar(max) ;
 GO 
ALTER TABLE [dbo].[SUINFO] ALTER COLUMN [VALUEDESC3] nVarChar(max) ;
 GO 
ALTER TABLE [dbo].[SUINFO] ALTER COLUMN [VALUEDESC4] nVarChar(max) ;
 GO 
ALTER TABLE [dbo].[SUINFO] ALTER COLUMN [VALUEDESC5] nVarChar(max) ;
 GO 
ALTER TABLE [dbo].[SUINFO] ALTER COLUMN [VALUEDESC6] nVarChar(max) ;
 GO 
ALTER TABLE [dbo].[SUINFO] ALTER COLUMN [VALUEDESC7] nVarChar(max) ;
 GO 
ALTER TABLE [dbo].[SUINFO] ALTER COLUMN [VALUEDESC8] nVarChar(max) ;
 GO 
ALTER TABLE [dbo].[SUINFO] ALTER COLUMN [VALUEDESC9] nVarChar(max) ;
 GO 
ALTER TABLE [dbo].[SUINFO] ALTER COLUMN [VALUEDESC10] nVarChar(max) ;
 GO 
ALTER TABLE [dbo].[SUINFO] ALTER COLUMN [VALUEDESC11] nVarChar(max) ;
 GO 
ALTER TABLE [dbo].[SUINFO] ALTER COLUMN [VALUEDESC12] nVarChar(max) ;
 GO 
ALTER TABLE [dbo].[SUINFO] ALTER COLUMN [VALUEDESC13] nVarChar(max) ;
 GO 
ALTER TABLE [dbo].[SUINFO] ALTER COLUMN [VALUEDESC14] nVarChar(max) ;
 GO 
ALTER TABLE [dbo].[SUINFO] ALTER COLUMN [VALUEDESC15] nVarChar(max) ;
 GO 
ALTER TABLE [dbo].[SURVEYOR] ALTER COLUMN [REMARKS] nVarChar(255) ;
 GO 
ALTER TABLE [dbo].[SysBatchBE] ALTER COLUMN [Correspondence_Email] nVarChar(50) ;
 GO 
ALTER TABLE [dbo].[SysBatchBE_Ext] ALTER COLUMN [Duty_Remark_1] nVarChar(50) ;
 GO 
DROP INDEX [dbo].[SysBatchH].[I_sysBatchH_ProcName_Status];
 GO 
ALTER TABLE [dbo].[SysBatchH] ALTER COLUMN [ProcName] nVarChar(100) ;
 GO 
CREATE NONCLUSTERED INDEX [I_sysBatchH_ProcName_Status] ON [dbo].[SysBatchH] (  [ProcName] , [Status] )
 GO 
ALTER TABLE [dbo].[SysBatchOriginalBE] ALTER COLUMN [CLADESCRIPTION_05] nVarChar(255) ;
 GO 
ALTER TABLE [dbo].[SysBatchOriginalBE] ALTER COLUMN [CLADESCRIPTION_02] nVarChar(255) ;
 GO 
ALTER TABLE [dbo].[SysBatchOriginalBE] ALTER COLUMN [Correspondence_Email] nVarChar(50) ;
 GO 
ALTER TABLE [dbo].[SysBatchOriginalBE] ALTER COLUMN [CLADESCRIPTION_07] nVarChar(255) ;
 GO 
ALTER TABLE [dbo].[SysBatchOriginalBE] ALTER COLUMN [CLADESCRIPTION_14] nVarChar(255) ;
 GO 
ALTER TABLE [dbo].[SysBatchOriginalBE] ALTER COLUMN [CLADESCRIPTION_11] nVarChar(255) ;
 GO 
ALTER TABLE [dbo].[SysBatchOriginalBE] ALTER COLUMN [CLADESCRIPTION_13] nVarChar(255) ;
 GO 
ALTER TABLE [dbo].[SysBatchOriginalBE] ALTER COLUMN [CLADESCRIPTION_10] nVarChar(255) ;
 GO 
ALTER TABLE [dbo].[SysBatchOriginalBE] ALTER COLUMN [CLADESCRIPTION_01] nVarChar(255) ;
 GO 
ALTER TABLE [dbo].[SysBatchOriginalBE] ALTER COLUMN [CLADESCRIPTION_04] nVarChar(255) ;
 GO 
ALTER TABLE [dbo].[SysBatchOriginalBE] ALTER COLUMN [CLADESCRIPTION_12] nVarChar(255) ;
 GO 
ALTER TABLE [dbo].[SysBatchOriginalBE] ALTER COLUMN [CLADESCRIPTION_15] nVarChar(255) ;
 GO 
ALTER TABLE [dbo].[SysBatchOriginalBE] ALTER COLUMN [CLADESCRIPTION_03] nVarChar(255) ;
 GO 
ALTER TABLE [dbo].[SysBatchOriginalBE] ALTER COLUMN [CLADESCRIPTION_09] nVarChar(255) ;
 GO 
ALTER TABLE [dbo].[SysBatchOriginalBE] ALTER COLUMN [CLADESCRIPTION_08] nVarChar(255) ;
 GO 
ALTER TABLE [dbo].[SysBatchOriginalBE] ALTER COLUMN [CLADESCRIPTION_06] nVarChar(255) ;
 GO 
ALTER TABLE [dbo].[SysBatchOriginalBE_Ext] ALTER COLUMN [Duty_Remark_1] nVarChar(50) ;
 GO 
ALTER TABLE [dbo].[SysBatchOriginalSC] ALTER COLUMN [DESCRIPTION6] nVarChar(8000) ;
 GO 
ALTER TABLE [dbo].[SysBatchOriginalSC] ALTER COLUMN [DESCRIPTION9] nVarChar(8000) ;
 GO 
ALTER TABLE [dbo].[SysBatchOriginalSC] ALTER COLUMN [DESCRIPTION12] nVarChar(8000) ;
 GO 
ALTER TABLE [dbo].[SysBatchOriginalSC] ALTER COLUMN [DESCRIPTION3] nVarChar(8000) ;
 GO 
ALTER TABLE [dbo].[SysBatchOriginalSC] ALTER COLUMN [DESCRIPTION4] nVarChar(8000) ;
 GO 
ALTER TABLE [dbo].[SysBatchOriginalSC] ALTER COLUMN [ADDRESS_3] nVarChar(255) ;
 GO 
ALTER TABLE [dbo].[SysBatchOriginalSC] ALTER COLUMN [DESCRIPTION1] nVarChar(8000) ;
 GO 
ALTER TABLE [dbo].[SysBatchOriginalSC] ALTER COLUMN [DESCRIPTION7] nVarChar(8000) ;
 GO 
ALTER TABLE [dbo].[SysBatchOriginalSC] ALTER COLUMN [ADDINTERESTREMARK3] nVarChar(255) ;
 GO 
ALTER TABLE [dbo].[SysBatchOriginalSC] ALTER COLUMN [location] nVarChar(255) ;
 GO 
ALTER TABLE [dbo].[SysBatchOriginalSC] ALTER COLUMN [DESCRIPTION15] nVarChar(8000) ;
 GO 
ALTER TABLE [dbo].[SysBatchOriginalSC] ALTER COLUMN [ADDRESS_2] nVarChar(255) ;
 GO 
ALTER TABLE [dbo].[SysBatchOriginalSC] ALTER COLUMN [DESCRIPTION5] nVarChar(8000) ;
 GO 
ALTER TABLE [dbo].[SysBatchOriginalSC] ALTER COLUMN [ADDRESS_1] nVarChar(255) ;
 GO 
ALTER TABLE [dbo].[SysBatchOriginalSC] ALTER COLUMN [Correspondence_Address] nVarChar(255) ;
 GO 
ALTER TABLE [dbo].[SysBatchOriginalSC] ALTER COLUMN [ADDINTERESTREMARK5] nVarChar(255) ;
 GO 
ALTER TABLE [dbo].[SysBatchOriginalSC] ALTER COLUMN [DESCRIPTION14] nVarChar(8000) ;
 GO 
ALTER TABLE [dbo].[SysBatchOriginalSC] ALTER COLUMN [DESCRIPTION11] nVarChar(8000) ;
 GO 
ALTER TABLE [dbo].[SysBatchOriginalSC] ALTER COLUMN [ADDINTERESTREMARK2] nVarChar(255) ;
 GO 
ALTER TABLE [dbo].[SysBatchOriginalSC] ALTER COLUMN [Email] nVarChar(512) ;
 GO 
ALTER TABLE [dbo].[SysBatchOriginalSC] ALTER COLUMN [DESCRIPTION8] nVarChar(8000) ;
 GO 
ALTER TABLE [dbo].[SysBatchOriginalSC] ALTER COLUMN [ADDINTERESTREMARK4] nVarChar(255) ;
 GO 
ALTER TABLE [dbo].[SysBatchOriginalSC] ALTER COLUMN [ADDINTERESTREMARK1] nVarChar(255) ;
 GO 
ALTER TABLE [dbo].[SysBatchOriginalSC] ALTER COLUMN [Correspondence_Email] nVarChar(50) ;
 GO 
ALTER TABLE [dbo].[SysBatchOriginalSC] ALTER COLUMN [DESCRIPTION10] nVarChar(8000) ;
 GO 
ALTER TABLE [dbo].[SysBatchOriginalSC] ALTER COLUMN [REMARKS] nVarChar(255) ;
 GO 
ALTER TABLE [dbo].[SysBatchOriginalSC] ALTER COLUMN [DESCRIPTION13] nVarChar(8000) ;
 GO 
ALTER TABLE [dbo].[SysBatchOriginalSC] ALTER COLUMN [DESCRIPTION2] nVarChar(8000) ;
 GO 
ALTER TABLE [dbo].[SysBatchOriginalUp] ALTER COLUMN [Email] nVarChar(512) ;
 GO 
ALTER TABLE [dbo].[SysBatchOriginalUp_Ext] ALTER COLUMN [Maincoverageremarks] nVarChar(50) ;
 GO 
ALTER TABLE [dbo].[SysBatchOriginalUp_Ext] ALTER COLUMN [Duty_remark_3] nVarChar(255) ;
 GO 
ALTER TABLE [dbo].[SysBatchOriginalUp_Ext] ALTER COLUMN [Duty_remark_2] nVarChar(255) ;
 GO 
ALTER TABLE [dbo].[SysBatchSC] ALTER COLUMN [DESCRIPTION5] nVarChar(8000) ;
 GO 
ALTER TABLE [dbo].[SysBatchSC] ALTER COLUMN [DESCRIPTION2] nVarChar(8000) ;
 GO 
ALTER TABLE [dbo].[SysBatchSC] ALTER COLUMN [DESCRIPTION8] nVarChar(8000) ;
 GO 
ALTER TABLE [dbo].[SysBatchSC] ALTER COLUMN [ADDRESS_2] nVarChar(255) ;
 GO 
ALTER TABLE [dbo].[SysBatchSC] ALTER COLUMN [DESCRIPTION11] nVarChar(8000) ;
 GO 
ALTER TABLE [dbo].[SysBatchSC] ALTER COLUMN [DESCRIPTION4] nVarChar(8000) ;
 GO 
ALTER TABLE [dbo].[SysBatchSC] ALTER COLUMN [DESCRIPTION10] nVarChar(8000) ;
 GO 
ALTER TABLE [dbo].[SysBatchSC] ALTER COLUMN [DESCRIPTION13] nVarChar(8000) ;
 GO 
ALTER TABLE [dbo].[SysBatchSC] ALTER COLUMN [Email] nVarChar(512) ;
 GO 
ALTER TABLE [dbo].[SysBatchSC] ALTER COLUMN [Correspondence_Email] nVarChar(50) ;
 GO 
ALTER TABLE [dbo].[SysBatchSC] ALTER COLUMN [DESCRIPTION7] nVarChar(8000) ;
 GO 
ALTER TABLE [dbo].[SysBatchSC] ALTER COLUMN [ADDRESS_1] nVarChar(255) ;
 GO 
ALTER TABLE [dbo].[SysBatchSC] ALTER COLUMN [location] nVarChar(255) ;
 GO 
ALTER TABLE [dbo].[SysBatchSC] ALTER COLUMN [DESCRIPTION3] nVarChar(8000) ;
 GO 
ALTER TABLE [dbo].[SysBatchSC] ALTER COLUMN [DESCRIPTION6] nVarChar(8000) ;
 GO 
ALTER TABLE [dbo].[SysBatchSC] ALTER COLUMN [REMARKS] nVarChar(255) ;
 GO 
ALTER TABLE [dbo].[SysBatchSC] ALTER COLUMN [Correspondence_Address] nVarChar(255) ;
 GO 
ALTER TABLE [dbo].[SysBatchSC] ALTER COLUMN [DESCRIPTION14] nVarChar(8000) ;
 GO 
ALTER TABLE [dbo].[SysBatchSC] ALTER COLUMN [DESCRIPTION1] nVarChar(8000) ;
 GO 
ALTER TABLE [dbo].[SysBatchSC] ALTER COLUMN [DESCRIPTION12] nVarChar(8000) ;
 GO 
ALTER TABLE [dbo].[SysBatchSC] ALTER COLUMN [ADDRESS_3] nVarChar(255) ;
 GO 
ALTER TABLE [dbo].[SysBatchSC] ALTER COLUMN [DESCRIPTION9] nVarChar(8000) ;
 GO 
ALTER TABLE [dbo].[SysBatchSC] ALTER COLUMN [DESCRIPTION15] nVarChar(8000) ;
 GO 
ALTER TABLE [dbo].[SysBatchUp] ALTER COLUMN [Email] nVarChar(512) ;
 GO 
ALTER TABLE [dbo].[SysBatchUp] ALTER COLUMN [Description17] nVarChar(255) ;
 GO 
ALTER TABLE [dbo].[SysBatchUp] ALTER COLUMN [Description20] nVarChar(255) ;
 GO 
ALTER TABLE [dbo].[SysBatchUp] ALTER COLUMN [DESCRIPTION23] nVarChar(255) ;
 GO 
ALTER TABLE [dbo].[SysBatchUp] ALTER COLUMN [DESCRIPTION26] nVarChar(255) ;
 GO 
ALTER TABLE [dbo].[SysBatchUp] ALTER COLUMN [DeclareDescription] nVarChar(255) ;
 GO 
ALTER TABLE [dbo].[SysBatchUp] ALTER COLUMN [Description28] nVarChar(255) ;
 GO 
ALTER TABLE [dbo].[SysBatchUp] ALTER COLUMN [Correspondence_Email] nVarChar(50) ;
 GO 
ALTER TABLE [dbo].[SysBatchUp] ALTER COLUMN [DESCRIPTION25] nVarChar(255) ;
 GO 
ALTER TABLE [dbo].[SysBatchUp] ALTER COLUMN [DESCRIPTION24] nVarChar(255) ;
 GO 
ALTER TABLE [dbo].[SysBatchUp] ALTER COLUMN [Description16] nVarChar(255) ;
 GO 
ALTER TABLE [dbo].[SysBatchUp] ALTER COLUMN [Description19] nVarChar(255) ;
 GO 
ALTER TABLE [dbo].[SysBatchUp] ALTER COLUMN [DESCRIPTION21] nVarChar(255) ;
 GO 
ALTER TABLE [dbo].[SysBatchUp] ALTER COLUMN [Description29] nVarChar(255) ;
 GO 
ALTER TABLE [dbo].[SysBatchUp] ALTER COLUMN [Description30] nVarChar(255) ;
 GO 
ALTER TABLE [dbo].[SysBatchUp] ALTER COLUMN [Description27] nVarChar(255) ;
 GO 
ALTER TABLE [dbo].[SysBatchUp] ALTER COLUMN [DESCRIPTION22] nVarChar(255) ;
 GO 
ALTER TABLE [dbo].[SysBatchUp] ALTER COLUMN [Description18] nVarChar(255) ;
 GO 
ALTER TABLE [dbo].[SysBatchUp_Ext] ALTER COLUMN [REMARKS6] nVarChar(8000) ;
 GO 
ALTER TABLE [dbo].[SysBatchUp_Ext] ALTER COLUMN [REMARKS7] nVarChar(8000) ;
 GO 
ALTER TABLE [dbo].[SysBatchUp_Ext] ALTER COLUMN [ADDCOVERAGEREMARK7] nVarChar(8000) ;
 GO 
ALTER TABLE [dbo].[SysBatchUp_Ext] ALTER COLUMN [ADDCOVERAGEREMARK12] nVarChar(8000) ;
 GO 
ALTER TABLE [dbo].[SysBatchUp_Ext] ALTER COLUMN [REMARKS4] nVarChar(8000) ;
 GO 
ALTER TABLE [dbo].[SysBatchUp_Ext] ALTER COLUMN [InParty_Address2] nVarChar(8000) ;
 GO 
ALTER TABLE [dbo].[SysBatchUp_Ext] ALTER COLUMN [OP_REMARK2] nVarChar(8000) ;
 GO 
ALTER TABLE [dbo].[SysBatchUp_Ext] ALTER COLUMN [InParty_Remark2] nVarChar(8000) ;
 GO 
ALTER TABLE [dbo].[SysBatchUp_Ext] ALTER COLUMN [REMARKS1] nVarChar(8000) ;
 GO 
ALTER TABLE [dbo].[SysBatchUp_Ext] ALTER COLUMN [CADDRESS] nVarChar(50) ;
 GO 
ALTER TABLE [dbo].[SysBatchUp_Ext] ALTER COLUMN [beneficiaries_Address3] nVarChar(8000) ;
 GO 
ALTER TABLE [dbo].[SysBatchUp_Ext] ALTER COLUMN [ADDINTERESTREMARK5] nVarChar(8000) ;
 GO 
ALTER TABLE [dbo].[SysBatchUp_Ext] ALTER COLUMN [Address_2] nVarChar(8000) ;
 GO 
ALTER TABLE [dbo].[SysBatchUp_Ext] ALTER COLUMN [MAINCOVERAGEREMARK1] nVarChar(8000) ;
 GO 
ALTER TABLE [dbo].[SysBatchUp_Ext] ALTER COLUMN [FEE_REMARK] nVarChar(8000) ;
 GO 
ALTER TABLE [dbo].[SysBatchUp_Ext] ALTER COLUMN [ADDINTERESTREMARK10] nVarChar(8000) ;
 GO 
ALTER TABLE [dbo].[SysBatchUp_Ext] ALTER COLUMN [MAINCOVERAGEREMARK4] nVarChar(8000) ;
 GO 
ALTER TABLE [dbo].[SysBatchUp_Ext] ALTER COLUMN [MAINCOVERAGEREMARK5] nVarChar(8000) ;
 GO 
ALTER TABLE [dbo].[SysBatchUp_Ext] ALTER COLUMN [ADDCOVERAGEREMARK1] nVarChar(8000) ;
 GO 
ALTER TABLE [dbo].[SysBatchUp_Ext] ALTER COLUMN [ADDCOVERAGEREMARK15] nVarChar(8000) ;
 GO 
ALTER TABLE [dbo].[SysBatchUp_Ext] ALTER COLUMN [HolderAddress_2] nVarChar(8000) ;
 GO 
ALTER TABLE [dbo].[SysBatchUp_Ext] ALTER COLUMN [ADDINTERESTREMARK3] nVarChar(8000) ;
 GO 
ALTER TABLE [dbo].[SysBatchUp_Ext] ALTER COLUMN [InsuredAddress_2] nVarChar(8000) ;
 GO 
ALTER TABLE [dbo].[SysBatchUp_Ext] ALTER COLUMN [MAININTERESTREMARK] nVarChar(8000) ;
 GO 
ALTER TABLE [dbo].[SysBatchUp_Ext] ALTER COLUMN [ICoverDetDescription1] nVarChar(8000) ;
 GO 
ALTER TABLE [dbo].[SysBatchUp_Ext] ALTER COLUMN [Correspondence_Address] nVarChar(8000) ;
 GO 
ALTER TABLE [dbo].[SysBatchUp_Ext] ALTER COLUMN [ADDINTERESTREMARK8] nVarChar(8000) ;
 GO 
ALTER TABLE [dbo].[SysBatchUp_Ext] ALTER COLUMN [RISKLOCATIONREMARK] nVarChar(8000) ;
 GO 
ALTER TABLE [dbo].[SysBatchUp_Ext] ALTER COLUMN [MAINCOVERAGEREMARK2] nVarChar(8000) ;
 GO 
ALTER TABLE [dbo].[SysBatchUp_Ext] ALTER COLUMN [DUTY_REMARK] nVarChar(8000) ;
 GO 
ALTER TABLE [dbo].[SysBatchUp_Ext] ALTER COLUMN [REMARKS11] nVarChar(8000) ;
 GO 
ALTER TABLE [dbo].[SysBatchUp_Ext] ALTER COLUMN [ICoverDetDescription2] nVarChar(50) ;
 GO 
ALTER TABLE [dbo].[SysBatchUp_Ext] ALTER COLUMN [InParty_Address1] nVarChar(50) ;
 GO 
ALTER TABLE [dbo].[SysBatchUp_Ext] ALTER COLUMN [Remarks10] nVarChar(8000) ;
 GO 
ALTER TABLE [dbo].[SysBatchUp_Ext] ALTER COLUMN [ADDCOVERAGEREMARK4] nVarChar(8000) ;
 GO 
ALTER TABLE [dbo].[SysBatchUp_Ext] ALTER COLUMN [Address_3] nVarChar(8000) ;
 GO 
ALTER TABLE [dbo].[SysBatchUp_Ext] ALTER COLUMN [ADDCOVERAGEREMARK3] nVarChar(8000) ;
 GO 
ALTER TABLE [dbo].[SysBatchUp_Ext] ALTER COLUMN [ADDINTERESTREMARK2] nVarChar(8000) ;
 GO 
ALTER TABLE [dbo].[SysBatchUp_Ext] ALTER COLUMN [InsuredAddress_1] nVarChar(8000) ;
 GO 
ALTER TABLE [dbo].[SysBatchUp_Ext] ALTER COLUMN [Maincoverageremarks] nVarChar(50) ;
 GO 
ALTER TABLE [dbo].[SysBatchUp_Ext] ALTER COLUMN [REMARKS] nVarChar(8000) ;
 GO 
ALTER TABLE [dbo].[SysBatchUp_Ext] ALTER COLUMN [beneficiaries_Address1] nVarChar(8000) ;
 GO 
ALTER TABLE [dbo].[SysBatchUp_Ext] ALTER COLUMN [ADDCOVERAGEREMARK5] nVarChar(8000) ;
 GO 
ALTER TABLE [dbo].[SysBatchUp_Ext] ALTER COLUMN [OP_REMARK1] nVarChar(8000) ;
 GO 
ALTER TABLE [dbo].[SysBatchUp_Ext] ALTER COLUMN [MAINCOVERAGEREMARK] nVarChar(8000) ;
 GO 
ALTER TABLE [dbo].[SysBatchUp_Ext] ALTER COLUMN [InParty_Remark1] nVarChar(8000) ;
 GO 
ALTER TABLE [dbo].[SysBatchUp_Ext] ALTER COLUMN [InParty_Address3] nVarChar(8000) ;
 GO 
ALTER TABLE [dbo].[SysBatchUp_Ext] ALTER COLUMN [REMARKS8] nVarChar(8000) ;
 GO 
ALTER TABLE [dbo].[SysBatchUp_Ext] ALTER COLUMN [REMARKS3] nVarChar(8000) ;
 GO 
ALTER TABLE [dbo].[SysBatchUp_Ext] ALTER COLUMN [ADDCOVERAGEREMARK17] nVarChar(8000) ;
 GO 
ALTER TABLE [dbo].[SysBatchUp_Ext] ALTER COLUMN [ADDCOVERAGEREMARK9] nVarChar(8000) ;
 GO 
ALTER TABLE [dbo].[SysBatchUp_Ext] ALTER COLUMN [Address_1] nVarChar(8000) ;
 GO 
ALTER TABLE [dbo].[SysBatchUp_Ext] ALTER COLUMN [ADDCOVERAGEREMARK14] nVarChar(8000) ;
 GO 
ALTER TABLE [dbo].[SysBatchUp_Ext] ALTER COLUMN [ADDCOVERAGEREMARK6] nVarChar(8000) ;
 GO 
ALTER TABLE [dbo].[SysBatchUp_Ext] ALTER COLUMN [ADDINTERESTREMARK7] nVarChar(8000) ;
 GO 
ALTER TABLE [dbo].[SysBatchUp_Ext] ALTER COLUMN [ADDCOVERAGEREMARK8] nVarChar(8000) ;
 GO 
ALTER TABLE [dbo].[SysBatchUp_Ext] ALTER COLUMN [ICoverDetDescription3] nVarChar(8000) ;
 GO 
ALTER TABLE [dbo].[SysBatchUp_Ext] ALTER COLUMN [ADDCOVERAGEREMARK11] nVarChar(8000) ;
 GO 
ALTER TABLE [dbo].[SysBatchUp_Ext] ALTER COLUMN [HolderAddress_1] nVarChar(8000) ;
 GO 
ALTER TABLE [dbo].[SysBatchUp_Ext] ALTER COLUMN [InParty_Remark3] nVarChar(8000) ;
 GO 
ALTER TABLE [dbo].[SysBatchUp_Ext] ALTER COLUMN [REMARKS2] nVarChar(8000) ;
 GO 
ALTER TABLE [dbo].[SysBatchUp_Ext] ALTER COLUMN [ADDCOVERAGEREMARK13] nVarChar(8000) ;
 GO 
ALTER TABLE [dbo].[SysBatchUp_Ext] ALTER COLUMN [REMARKS5] nVarChar(8000) ;
 GO 
ALTER TABLE [dbo].[SysBatchUp_Ext] ALTER COLUMN [beneficiaries_Address2] nVarChar(8000) ;
 GO 
ALTER TABLE [dbo].[SysBatchUp_Ext] ALTER COLUMN [ICoverDetDescription4] nVarChar(8000) ;
 GO 
ALTER TABLE [dbo].[SysBatchUp_Ext] ALTER COLUMN [ADDCOVERAGEREMARK19] nVarChar(8000) ;
 GO 
ALTER TABLE [dbo].[SysBatchUp_Ext] ALTER COLUMN [ADDCOVERAGEREMARK10] nVarChar(8000) ;
 GO 
ALTER TABLE [dbo].[SysBatchUp_Ext] ALTER COLUMN [ADDCOVERAGEREMARK18] nVarChar(8000) ;
 GO 
ALTER TABLE [dbo].[SysBatchUp_Ext] ALTER COLUMN [ADDINTERESTREMARK6] nVarChar(8000) ;
 GO 
ALTER TABLE [dbo].[SysBatchUp_Ext] ALTER COLUMN [InsuredAddress_3] nVarChar(8000) ;
 GO 
ALTER TABLE [dbo].[SysBatchUp_Ext] ALTER COLUMN [ADDINTERESTREMARK1] nVarChar(8000) ;
 GO 
ALTER TABLE [dbo].[SysBatchUp_Ext] ALTER COLUMN [MAINCOVERAGEREMARK3] nVarChar(8000) ;
 GO 
ALTER TABLE [dbo].[SysBatchUp_Ext] ALTER COLUMN [ADDINTERESTREMARK9] nVarChar(8000) ;
 GO 
ALTER TABLE [dbo].[SysBatchUp_Ext] ALTER COLUMN [ADDCOVERAGEREMARK2] nVarChar(8000) ;
 GO 
ALTER TABLE [dbo].[SysBatchUp_Ext] ALTER COLUMN [ADDINTERESTREMARK4] nVarChar(8000) ;
 GO 
ALTER TABLE [dbo].[SysBatchUp_Ext] ALTER COLUMN [ADDCOVERAGEREMARK16] nVarChar(8000) ;
 GO 
ALTER TABLE [dbo].[SysBatchUp_Ext] ALTER COLUMN [HolderAddress_3] nVarChar(8000) ;
 GO 
ALTER TABLE [dbo].[SysBatchUp_Ext] ALTER COLUMN [ICoverDetDescription5] nVarChar(8000) ;
 GO 
ALTER TABLE [dbo].[SysCategory] ALTER COLUMN [DESCRIPTION] nVarChar(255) ;
 GO 
ALTER TABLE [dbo].[SysCategory] ALTER COLUMN [Last_Opr] nVarChar(50) ;
 GO 
ALTER TABLE [dbo].[SysClass] ALTER COLUMN [Last_Opr] nVarChar(50) ;
 GO 
ALTER TABLE [dbo].[SysClass] ALTER COLUMN [DESCRIPTION] nVarChar(255) ;
 GO 
ALTER TABLE [dbo].[SysDocType] ALTER COLUMN [DocLocation] nVarChar(512) ;
 GO 
ALTER TABLE [dbo].[SysUserForm] DROP CONSTRAINT [FK_SysUserForm_SysForm];
 GO 
ALTER TABLE [dbo].[SysUserGrants] DROP CONSTRAINT [FK_SysUserGrants_SysForm];
 GO 
DROP INDEX [dbo].[SysForm].[I_SysForm];
 GO 
ALTER TABLE [dbo].[SysForm] ALTER COLUMN [FName] nVarChar(50) ;
 GO 
ALTER TABLE [dbo].[SysUserForm] WITH NOCHECK ADD CONSTRAINT [FK_SysUserForm_SysForm] FOREIGN KEY ([FName]) REFERENCES [dbo].[SysForm]([FName]);
 GO 
ALTER TABLE [dbo].[SysUserGrants] WITH NOCHECK ADD CONSTRAINT [FK_SysUserGrants_SysForm] FOREIGN KEY ([FName]) REFERENCES [dbo].[SysForm]([FName]);
 GO 
CREATE UNIQUE NONCLUSTERED INDEX [I_SysForm] ON [dbo].[SysForm] (  [FName] )
 GO 
ALTER TABLE [dbo].[SysForm] ALTER COLUMN [Description] nVarChar(255) ;
 GO 
ALTER TABLE [dbo].[SysFormWeb] ALTER COLUMN [FName] nVarChar(25) ;
 GO 
ALTER TABLE [dbo].[SysGroup] ALTER COLUMN [Description] nVarChar(255) ;
 GO 
ALTER TABLE [dbo].[SysGroup] ALTER COLUMN [Last_Opr] nVarChar(50) ;
 GO 
ALTER TABLE [dbo].[SysInforce] DROP CONSTRAINT [i_SysInforce];
 GO 
ALTER TABLE [dbo].[SysInforce] ALTER COLUMN [ProcName] nVarChar(50) ;
 GO 
ALTER TABLE [dbo].[SysInforce] WITH NOCHECK ADD CONSTRAINT [i_SysInforce] PRIMARY KEY NONCLUSTERED( [ID] , [ProcName] , [Param3] ) WITH (ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = OFF) ON [PRIMARY]
 GO 
ALTER TABLE [dbo].[SysInforce] ALTER COLUMN [Remarks] nVarChar(100) ;
 GO 
ALTER TABLE [dbo].[SysInforce] ALTER COLUMN [UserID] nVarChar(50) ;
 GO 
ALTER TABLE [dbo].[SysLockedObject] DROP CONSTRAINT [I_SysLockedObject];
 GO 
ALTER TABLE [dbo].[SysLockedObject] ALTER COLUMN [ObjName] nVarChar(50) ;
 GO 
ALTER TABLE [dbo].[SysLockedObject] WITH NOCHECK ADD CONSTRAINT [I_SysLockedObject] PRIMARY KEY NONCLUSTERED( [ObjName] ) WITH (ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = OFF) ON [PRIMARY]
 GO 
ALTER TABLE [dbo].[SysLogDownload] ALTER COLUMN [FILENAME] nVarChar(255) ;
 GO 
ALTER TABLE [dbo].[SysLogDownload] ALTER COLUMN [USERID] nVarChar(50) ;
 GO 
ALTER TABLE [dbo].[SysLogDownload] ALTER COLUMN [LUSERID] nVarChar(50) ;
 GO 
ALTER TABLE [dbo].[SysLogDownLoadImage] ALTER COLUMN [USERID] nVarChar(50) ;
 GO 
ALTER TABLE [dbo].[SysLoginUsers] ALTER COLUMN [UserHostName] nVarChar(50) ;
 GO 
ALTER TABLE [dbo].[SysLogObject] ALTER COLUMN [Remarks] nVarChar(max) ;
 GO 
ALTER TABLE [dbo].[SysLogObject] ALTER COLUMN [ColName] nVarChar(50) ;
 GO 
ALTER TABLE [dbo].[SysLogObject] ALTER COLUMN [Last_Opr] nVarChar(50) ;
 GO 
DROP INDEX [dbo].[SysLogObject].[I_SysLogObject_LogName_LogID];
 GO 
ALTER TABLE [dbo].[SysLogObject] ALTER COLUMN [LogName] nVarChar(50) ;
 GO 
CREATE NONCLUSTERED INDEX [I_SysLogObject_LogName_LogID] ON [dbo].[SysLogObject] (  [LogName] , [LogID] )
 GO 
ALTER TABLE [dbo].[SysLogoutUsers] ALTER COLUMN [UserHostName] nVarChar(50) ;
 GO 
ALTER TABLE [dbo].[SysLogProcess] ALTER COLUMN [UserID] nVarChar(50) ;
 GO 
ALTER TABLE [dbo].[SysLogProcess] ALTER COLUMN [ProcName] nVarChar(100) ;
 GO 
ALTER TABLE [dbo].[SysLogReport] ALTER COLUMN [Remarks] nVarChar(512) ;
 GO 
ALTER TABLE [dbo].[SysLogReport] ALTER COLUMN [EXENAME] nVarChar(255) ;
 GO 
ALTER TABLE [dbo].[SysLogReport] ALTER COLUMN [Description] nVarChar(255) ;
 GO 
ALTER TABLE [dbo].[SysLogReport] ALTER COLUMN [UserID] nVarChar(50) ;
 GO 
ALTER TABLE [dbo].[SysLogReport] ALTER COLUMN [REPNAME] nVarChar(20) ;
 GO 
ALTER TABLE [dbo].[SysLogReportBatchScreening] ALTER COLUMN [Remarks] nVarChar(512) ;
 GO 
ALTER TABLE [dbo].[SysLogReportBatchScreening] ALTER COLUMN [EXENAME] nVarChar(255) ;
 GO 
ALTER TABLE [dbo].[SysLogReportBatchScreening] ALTER COLUMN [UserID] nVarChar(50) ;
 GO 
ALTER TABLE [dbo].[SysLogReportBatchScreening] ALTER COLUMN [Description] nVarChar(255) ;
 GO 
ALTER TABLE [dbo].[SysLogReportBatchScreening] ALTER COLUMN [REPNAME] nVarChar(50) ;
 GO 
DROP INDEX [dbo].[SysProcess].[I_SysProcess_MainProcName];
 GO 
ALTER TABLE [dbo].[SysProcess] ALTER COLUMN [MainProcName] nVarChar(100) ;
 GO 
CREATE NONCLUSTERED INDEX [I_SysProcess_MainProcName] ON [dbo].[SysProcess] (  [MainProcName] )
 GO 
ALTER TABLE [dbo].[SysProcess] DROP CONSTRAINT [I_SysProcess];
 GO 
ALTER TABLE [dbo].[SysProcess] ALTER COLUMN [ProcName] nVarChar(100) ;
 GO 
ALTER TABLE [dbo].[SysProcess] WITH NOCHECK ADD CONSTRAINT [I_SysProcess] PRIMARY KEY NONCLUSTERED( [ProcName] ) WITH (ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = OFF) ON [PRIMARY]
 GO 
ALTER TABLE [dbo].[SysProcess] ALTER COLUMN [UserID] nVarChar(50) ;
 GO 
ALTER TABLE [dbo].[SysProcess] ALTER COLUMN [Last_Opr] nVarChar(50) ;
 GO 
ALTER TABLE [dbo].[SysProcH] ALTER COLUMN [ExeName] nVarChar(100) ;
 GO 
DROP INDEX [dbo].[SysProcH].[UserID];
 GO 
ALTER TABLE [dbo].[SysProcH] ALTER COLUMN [UserID] nVarChar(50) ;
 GO 
CREATE NONCLUSTERED INDEX [UserID] ON [dbo].[SysProcH] (  [UserID] )
 GO 
ALTER TABLE [dbo].[SysProcID] ALTER COLUMN [REPNAME] nVarChar(20) ;
 GO 
ALTER TABLE [dbo].[SysProcID] ALTER COLUMN [EXENAME] nVarChar(255) ;
 GO 
ALTER TABLE [dbo].[SysProcID] ALTER COLUMN [SERVICENAME] nVarChar(100) ;
 GO 
ALTER TABLE [dbo].[SysProcID] ALTER COLUMN [DESCRIPTION] nVarChar(255) ;
 GO 
ALTER TABLE [dbo].[SysProcID] ALTER COLUMN [VALUEDESC1] nVarChar(255) ;
 GO 
ALTER TABLE [dbo].[SysProcID] ALTER COLUMN [VALUEDESC2] nVarChar(255) ;
 GO 
ALTER TABLE [dbo].[SysProcID] ALTER COLUMN [VALUEDESC3] nVarChar(255) ;
 GO 
ALTER TABLE [dbo].[SysProcID] ALTER COLUMN [VALUEDESC4] nVarChar(255) ;
 GO 
ALTER TABLE [dbo].[SysProcID] ALTER COLUMN [VALUEDESC5] nVarChar(255) ;
 GO 
ALTER TABLE [dbo].[SysProcID] ALTER COLUMN [VALUEDESC6] nVarChar(255) ;
 GO 
ALTER TABLE [dbo].[SysProcID] ALTER COLUMN [VALUEDESC7] nVarChar(255) ;
 GO 
ALTER TABLE [dbo].[SysProcID] ALTER COLUMN [VALUEDESC8] nVarChar(255) ;
 GO 
ALTER TABLE [dbo].[SysProcID] ALTER COLUMN [VALUEDESC9] nVarChar(255) ;
 GO 
ALTER TABLE [dbo].[SysProcID] ALTER COLUMN [VALUEDESC10] nVarChar(255) ;
 GO 
ALTER TABLE [dbo].[SysProcID] ALTER COLUMN [VALUEDESC11] nVarChar(255) ;
 GO 
ALTER TABLE [dbo].[SysProcID] ALTER COLUMN [VALUEDESC12] nVarChar(255) ;
 GO 
ALTER TABLE [dbo].[SysProcID] ALTER COLUMN [VALUEDESC13] nVarChar(255) ;
 GO 
ALTER TABLE [dbo].[SysProcID] ALTER COLUMN [VALUEDESC14] nVarChar(255) ;
 GO 
ALTER TABLE [dbo].[SysProcID] ALTER COLUMN [VALUEDESC15] nVarChar(255) ;
 GO 
ALTER TABLE [dbo].[SysProcID] ALTER COLUMN [Last_Opr] nVarChar(50) ;
 GO 
DROP INDEX [dbo].[SysProclib].[i_SysProclib_Ext];
 GO 
ALTER TABLE [dbo].[SysProclib] ALTER COLUMN [ProcName] nVarChar(100) ;
 GO 
CREATE NONCLUSTERED INDEX [i_SysProclib_Ext] ON [dbo].[SysProclib] (  [Proclib] , [ProcName] , [Param1] , [Param2] , [Param3] , [Param4] , [Param5] , [Param6] )
 GO 
ALTER TABLE [dbo].[SysQuery] ALTER COLUMN [SQLName] nVarChar(255) ;
 GO 
ALTER TABLE [dbo].[SysQuery] ALTER COLUMN [AuthorName] nVarChar(100) ;
 GO 
ALTER TABLE [dbo].[SysReport] DROP CONSTRAINT [I_SysReport];
 GO 
ALTER TABLE [dbo].[SysReport] ALTER COLUMN [RepName] nVarChar(20) ;
 GO 
ALTER TABLE [dbo].[SysReport] WITH NOCHECK ADD CONSTRAINT [I_SysReport] PRIMARY KEY NONCLUSTERED( [Code] , [RepName] ) WITH (ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = OFF) ON [PRIMARY]
 GO 
ALTER TABLE [dbo].[SysReport] ALTER COLUMN [Description] nVarChar(255) ;
 GO 
ALTER TABLE [dbo].[SysReportDefinitions] ALTER COLUMN [ClassDescription] nVarChar(255) ;
 GO 
ALTER TABLE [dbo].[SysReportDefinitions] ALTER COLUMN [RepName] nVarChar(278) ;
 GO 
ALTER TABLE [dbo].[SysReportDefinitions] ALTER COLUMN [Description] nVarChar(255) ;
 GO 
ALTER TABLE [dbo].[SysRequest] ALTER COLUMN [ProcName] nVarChar(50) ;
 GO 
DROP INDEX [dbo].[SysRequest].[I_get_SysRequest];
 GO 
ALTER TABLE [dbo].[SysRequest] ALTER COLUMN [Remarks] nVarChar(max) ;
 GO 
CREATE NONCLUSTERED INDEX [I_get_SysRequest] ON [dbo].[SysRequest] (  [Param1] , [UserID] , [Status] , [Param2] )
 GO 
ALTER TABLE [dbo].[SysRequest] ALTER COLUMN [ApprovedFName] nVarChar(50) ;
 GO 
DROP INDEX [dbo].[SysRequest].[I_get_SysRequest];
 GO 
DROP INDEX [dbo].[SysRequest].[I_SysRequest_Param1_Param2_USERID];
 GO 
DROP INDEX [dbo].[SysRequest].[I_SysRequest_UserID_Param2_Param1];
 GO 
ALTER TABLE [dbo].[SysRequest] ALTER COLUMN [UserID] nVarChar(50) ;
 GO 
CREATE NONCLUSTERED INDEX [I_SysRequest_UserID_Param2_Param1] ON [dbo].[SysRequest] (  [UserID] , [Param2] , [Param1] )
 GO 
CREATE NONCLUSTERED INDEX [I_get_SysRequest] ON [dbo].[SysRequest] (  [Param1] , [UserID] , [Status] , [Param2] )
 GO 
CREATE NONCLUSTERED INDEX [I_SysRequest_Param1_Param2_USERID] ON [dbo].[SysRequest] (  [Param1] , [Param2] , [UserID] )
 GO 
ALTER TABLE [dbo].[SysRequest] ALTER COLUMN [LUserID] nVarChar(50) ;
 GO 
DROP INDEX [dbo].[SysSeqNo].[I_SysSeqNo];
 GO 
ALTER TABLE [dbo].[SysSeqNo] ALTER COLUMN [ObjName] nVarChar(50) ;
 GO 
CREATE UNIQUE NONCLUSTERED INDEX [I_SysSeqNo] ON [dbo].[SysSeqNo] (  [ObjName] )
 GO 
ALTER TABLE [dbo].[SysSeqNo_Ex] ALTER COLUMN [Remarks] nVarChar(255) ;
 GO 
DROP INDEX [dbo].[SysSeqNo_Ex].[I_SysSeqNo_Ex_ObjName];
 GO 
ALTER TABLE [dbo].[SysSeqNo_Ex] ALTER COLUMN [ObjName] nVarChar(50) ;
 GO 
CREATE NONCLUSTERED INDEX [I_SysSeqNo_Ex_ObjName] ON [dbo].[SysSeqNo_Ex] (  [ObjName] )
 GO 
ALTER TABLE [dbo].[SysTab] ALTER COLUMN [Name_2] nVarChar(50) ;
 GO 
ALTER TABLE [dbo].[SysTab] ALTER COLUMN [r_sName] nVarChar(50) ;
 GO 
ALTER TABLE [dbo].[SysTab] ALTER COLUMN [r_dbName] nVarChar(50) ;
 GO 
ALTER TABLE [dbo].[SysTab] ALTER COLUMN [SMTPEMail] nVarChar(255) ;
 GO 
ALTER TABLE [dbo].[SysTab] ALTER COLUMN [CompanyAddress] nVarChar(255) ;
 GO 
ALTER TABLE [dbo].[SysTab] ALTER COLUMN [LogoName] nVarChar(255) ;
 GO 
ALTER TABLE [dbo].[SysTab] ALTER COLUMN [LogoName_Ext] nVarChar(255) ;
 GO 
ALTER TABLE [dbo].[SysTab] ALTER COLUMN [Name_1] nVarChar(50) ;
 GO 
ALTER TABLE [dbo].[SysTab] ALTER COLUMN [db_Name] nVarChar(50) ;
 GO 
ALTER TABLE [dbo].[SysUpload] ALTER COLUMN [ProcName] nVarChar(50) ;
 GO 
ALTER TABLE [dbo].[SysUpload] ALTER COLUMN [UserID] nVarChar(50) ;
 GO 
ALTER TABLE [dbo].[SysUpload] ALTER COLUMN [Remarks] nVarChar(100) ;
 GO 
ALTER TABLE [dbo].[SysUser] ALTER COLUMN [Last_Opr] nVarChar(50) ;
 GO 
ALTER TABLE [dbo].[SysUser] ALTER COLUMN [Name] nVarChar(30) ;
 GO 
ALTER TABLE [dbo].[SysUser] ALTER COLUMN [EMail] nVarChar(512) ;
 GO 
ALTER TABLE [dbo].[SysUser] ALTER COLUMN [LOCATION] nVarChar(10) ;
 GO 
ALTER TABLE [dbo].[SysUser] ALTER COLUMN [SignerName] nVarChar(255) ;
 GO 
ALTER TABLE [dbo].[SysUser] ALTER COLUMN [CUserID] nVarChar(50) ;
 GO 
ALTER TABLE [dbo].[SysUserActivity] ALTER COLUMN [last_login_Address] nVarChar(20) ;
 GO 
ALTER TABLE [dbo].[SysUserActivity] ALTER COLUMN [UserHostName] nVarChar(50) ;
 GO 
ALTER TABLE [dbo].[SysUserAssignment] ALTER COLUMN [Description] nVarChar(100) ;
 GO 
ALTER TABLE [dbo].[SysUserDelegation] ALTER COLUMN [Description] nVarChar(100) ;
 GO 
ALTER TABLE [dbo].[SysUserForm] DROP CONSTRAINT [FK_SysUserForm_SysForm];
 GO 
DROP INDEX [dbo].[SysUserForm].[I_SysUserForm];
 GO 
ALTER TABLE [dbo].[SysUserForm] ALTER COLUMN [FName] nVarChar(50) ;
 GO 
ALTER TABLE [dbo].[SysUserForm] WITH NOCHECK ADD CONSTRAINT [FK_SysUserForm_SysForm] FOREIGN KEY ([FName]) REFERENCES [dbo].[SysForm]([FName]);
 GO 
CREATE UNIQUE NONCLUSTERED INDEX [I_SysUserForm] ON [dbo].[SysUserForm] (  [Type] , [FName] )
 GO 
ALTER TABLE [dbo].[SysUserGrants] DROP CONSTRAINT [FK_SysUserGrants_SysForm];
 GO 
DROP INDEX [dbo].[SysUserGrants].[I_sysuserGrants];
 GO 
ALTER TABLE [dbo].[SysUserGrants] ALTER COLUMN [FName] nVarChar(50) ;
 GO 
ALTER TABLE [dbo].[SysUserGrants] WITH NOCHECK ADD CONSTRAINT [FK_SysUserGrants_SysForm] FOREIGN KEY ([FName]) REFERENCES [dbo].[SysForm]([FName]);
 GO 
CREATE UNIQUE NONCLUSTERED INDEX [I_sysuserGrants] ON [dbo].[SysUserGrants] (  [ID] , [FName] )
 GO 
ALTER TABLE [dbo].[SysUserGroup] DROP CONSTRAINT [i_SysUserGroup];
 GO 
ALTER TABLE [dbo].[SysUserGroup] ALTER COLUMN [UserID] nVarChar(50) ;
 GO 
ALTER TABLE [dbo].[SysUserGroup] WITH NOCHECK ADD CONSTRAINT [i_SysUserGroup] PRIMARY KEY NONCLUSTERED( [Group] , [UserID] ) WITH (ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = OFF) ON [PRIMARY]
 GO 
ALTER TABLE [dbo].[SysUserGroup] ALTER COLUMN [Last_Opr] nVarChar(50) ;
 GO 
DROP INDEX [dbo].[SysUserHostName].[I_SysUserHostName];
 GO 
ALTER TABLE [dbo].[SysUserHostName] ALTER COLUMN [UserHostName] nVarChar(50) ;
 GO 
CREATE UNIQUE CLUSTERED INDEX [I_SysUserHostName] ON [dbo].[SysUserHostName] (  [UserHostName] )
 GO 
ALTER TABLE [dbo].[SysUserType] ALTER COLUMN [Description] nVarChar(50) ;
 GO 
ALTER TABLE [dbo].[SysUserTypeTOCTOL] ALTER COLUMN [VALUEDESC12] nVarChar(255) ;
 GO 
ALTER TABLE [dbo].[SysUserTypeTOCTOL] ALTER COLUMN [VALUEDESC11] nVarChar(255) ;
 GO 
ALTER TABLE [dbo].[SysUserTypeTOCTOL] ALTER COLUMN [VALUEDESC10] nVarChar(255) ;
 GO 
ALTER TABLE [dbo].[SysUserTypeTOCTOL] ALTER COLUMN [VALUEDESC14] nVarChar(255) ;
 GO 
ALTER TABLE [dbo].[SysUserTypeTOCTOL] ALTER COLUMN [VALUEDESC5] nVarChar(255) ;
 GO 
ALTER TABLE [dbo].[SysUserTypeTOCTOL] ALTER COLUMN [VALUEDESC13] nVarChar(255) ;
 GO 
ALTER TABLE [dbo].[SysUserTypeTOCTOL] ALTER COLUMN [VALUEDESC7] nVarChar(255) ;
 GO 
ALTER TABLE [dbo].[SysUserTypeTOCTOL] ALTER COLUMN [VALUEDESC6] nVarChar(255) ;
 GO 
ALTER TABLE [dbo].[SysUserTypeTOCTOL] ALTER COLUMN [Last_Opr] nVarChar(50) ;
 GO 
ALTER TABLE [dbo].[SysUserTypeTOCTOL] ALTER COLUMN [VALUEDESC8] nVarChar(255) ;
 GO 
ALTER TABLE [dbo].[SysUserTypeTOCTOL] ALTER COLUMN [VALUEDESC9] nVarChar(255) ;
 GO 
ALTER TABLE [dbo].[SysUserTypeTOCTOL] ALTER COLUMN [VALUEDESC15] nVarChar(255) ;
 GO 
ALTER TABLE [dbo].[SysUserTypeTOCTOL] ALTER COLUMN [VALUEDESC4] nVarChar(255) ;
 GO 
ALTER TABLE [dbo].[SysUserTypeTOCTOL] ALTER COLUMN [VALUEDESC2] nVarChar(255) ;
 GO 
ALTER TABLE [dbo].[SysUserTypeTOCTOL] ALTER COLUMN [VALUEDESC3] nVarChar(255) ;
 GO 
ALTER TABLE [dbo].[SysUserTypeTOCTOL] ALTER COLUMN [VALUEDESC1] nVarChar(255) ;
 GO 
ALTER TABLE [dbo].[SysVerify] DROP CONSTRAINT [I_SysVerify];
 GO 
ALTER TABLE [dbo].[SysVerify] ALTER COLUMN [FileName] nVarChar(255) ;
 GO 
ALTER TABLE [dbo].[SysVerify] WITH NOCHECK ADD CONSTRAINT [I_SysVerify] PRIMARY KEY NONCLUSTERED( [FileName] ) WITH (ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = OFF) ON [PRIMARY]
 GO 
ALTER TABLE [dbo].[T_SAP_CODE] ALTER COLUMN [Country_Name] nVarChar(255) ;
 GO 
ALTER TABLE [dbo].[TaxCode] ALTER COLUMN [Description] nVarChar(255) ;
 GO 
ALTER TABLE [dbo].[TAXTYPE] ALTER COLUMN [DESCRIPTION] nVarChar(500) ;
 GO 
ALTER TABLE [dbo].[TC] ALTER COLUMN [ShortDesc] nVarChar(8000) ;
 GO 
ALTER TABLE [dbo].[TC] ALTER COLUMN [Last_Opr] nVarChar(10) ;
 GO 
ALTER TABLE [dbo].[tCOVER] ALTER COLUMN [USERID] nVarChar(10) ;
 GO 
ALTER TABLE [dbo].[tCOVER] ALTER COLUMN [LUSERID] nVarChar(10) ;
 GO 
ALTER TABLE [dbo].[tCOVER] ALTER COLUMN [AUSERID] nVarChar(10) ;
 GO 
ALTER TABLE [dbo].[tCOVER] ALTER COLUMN [CUserID] nVarChar(10) ;
 GO 
ALTER TABLE [dbo].[tCOVER] ALTER COLUMN [PUserID] nVarChar(10) ;
 GO 
ALTER TABLE [dbo].[TOC] ALTER COLUMN [DESCRIPTION] nVarChar(50) ;
 GO 
ALTER TABLE [dbo].[TOC] ALTER COLUMN [VATDESCRIPTION] nVarChar(255) ;
 GO 
ALTER TABLE [dbo].[TOC] ALTER COLUMN [RegisteredName] nVarChar(255) ;
 GO 
ALTER TABLE [dbo].[TOC] ALTER COLUMN [RegisteredDescription] nVarChar(512) ;
 GO 
ALTER TABLE [dbo].[TOC] ALTER COLUMN [Last_Opr] nVarChar(50) ;
 GO 
ALTER TABLE [dbo].[TOCGROUP] ALTER COLUMN [DESCRIPTION] nVarChar(100) ;
 GO 
ALTER TABLE [dbo].[TOCGROUP] ALTER COLUMN [Last_Opr] nVarChar(50) ;
 GO 
ALTER TABLE [dbo].[TOI] ALTER COLUMN [Last_Opr] nVarChar(50) ;
 GO 
ALTER TABLE [dbo].[TOI] ALTER COLUMN [DESCRIPTION] nVarChar(8000) ;
 GO 
ALTER TABLE [dbo].[TOIVALUE] ALTER COLUMN [VALUEDESC1] nVarChar(255) ;
 GO 
ALTER TABLE [dbo].[TOIVALUE] ALTER COLUMN [VALUEDESC2] nVarChar(255) ;
 GO 
ALTER TABLE [dbo].[TOIVALUE] ALTER COLUMN [VALUEDESC3] nVarChar(255) ;
 GO 
ALTER TABLE [dbo].[TOIVALUE] ALTER COLUMN [VALUEDESC4] nVarChar(255) ;
 GO 
ALTER TABLE [dbo].[TOIVALUE] ALTER COLUMN [VALUEDESC5] nVarChar(255) ;
 GO 
ALTER TABLE [dbo].[TOIVALUE] ALTER COLUMN [VALUEDESC6] nVarChar(255) ;
 GO 
ALTER TABLE [dbo].[TOIVALUE] ALTER COLUMN [VALUEDESC7] nVarChar(255) ;
 GO 
ALTER TABLE [dbo].[TOIVALUE] ALTER COLUMN [VALUEDESC8] nVarChar(255) ;
 GO 
ALTER TABLE [dbo].[TOIVALUE] ALTER COLUMN [VALUEDESC9] nVarChar(255) ;
 GO 
ALTER TABLE [dbo].[TOIVALUE] ALTER COLUMN [VALUEDESC10] nVarChar(255) ;
 GO 
ALTER TABLE [dbo].[TOIVALUE] ALTER COLUMN [VALUEDESC11] nVarChar(255) ;
 GO 
ALTER TABLE [dbo].[TOIVALUE] ALTER COLUMN [VALUEDESC12] nVarChar(255) ;
 GO 
ALTER TABLE [dbo].[TOIVALUE] ALTER COLUMN [VALUEDESC13] nVarChar(255) ;
 GO 
ALTER TABLE [dbo].[TOIVALUE] ALTER COLUMN [VALUEDESC14] nVarChar(255) ;
 GO 
ALTER TABLE [dbo].[TOIVALUE] ALTER COLUMN [VALUEDESC15] nVarChar(255) ;
 GO 
ALTER TABLE [dbo].[TOIVALUE] ALTER COLUMN [AUserID] nVarChar(50) ;
 GO 
ALTER TABLE [dbo].[TOIVALUE] ALTER COLUMN [Last_Opr] nVarChar(50) ;
 GO 
ALTER TABLE [dbo].[TOL] ALTER COLUMN [Last_Opr] nVarChar(50) ;
 GO 
ALTER TABLE [dbo].[TOP_CLA] ALTER COLUMN [SHORTDESC] nVarChar(max) ;
 GO 
ALTER TABLE [dbo].[TOP_CLA] ALTER COLUMN [ShortDesc_1] nVarChar(max) ;
 GO 
ALTER TABLE [dbo].[TOP_CON] ALTER COLUMN [SHORTDESC] nVarChar(max) ;
 GO 
ALTER TABLE [dbo].[TOP_CON] ALTER COLUMN [ShortDesc_1] nVarChar(max) ;
 GO 
ALTER TABLE [dbo].[TOP_Deductible] ALTER COLUMN [REMARKS] nVarChar(2048) ;
 GO 
ALTER TABLE [dbo].[TOP_Deductible] ALTER COLUMN [REMARKS_1] nVarChar(2048) ;
 GO 
ALTER TABLE [dbo].[TOP_Deductible] ALTER COLUMN [Last_Opr] nVarChar(50) ;
 GO 
ALTER TABLE [dbo].[TOP_EX] ALTER COLUMN [ShortDesc_1] nVarChar(max) ;
 GO 
ALTER TABLE [dbo].[TOP_EX] ALTER COLUMN [SHORTDESC] nVarChar(max) ;
 GO 
ALTER TABLE [dbo].[TOP_FD] ALTER COLUMN [REMARK] nVarChar(50) ;
 GO 
ALTER TABLE [dbo].[TOP_FD] ALTER COLUMN [Last_Opr] nVarChar(50) ;
 GO 
ALTER TABLE [dbo].[TOP_Interest] ALTER COLUMN [Last_Opr] nVarChar(50) ;
 GO 
ALTER TABLE [dbo].[TOP_NOC] ALTER COLUMN [Description] nVarChar(255) ;
 GO 
ALTER TABLE [dbo].[TOP_Rate] ALTER COLUMN [Last_Opr] nVarChar(50) ;
 GO 
ALTER TABLE [dbo].[TOP_RTERM] ALTER COLUMN [Last_Opr] nVarChar(50) ;
 GO 
ALTER TABLE [dbo].[TOP_SECTION] ALTER COLUMN [SHORTDESC] nVarChar(255) ;
 GO 
ALTER TABLE [dbo].[TOPRO] ALTER COLUMN [Description] nVarChar(255) ;
 GO 
ALTER TABLE [dbo].[TOPRO] ALTER COLUMN [Last_Opr] nVarChar(50) ;
 GO 
ALTER TABLE [dbo].[TOPRO_RATECON] ALTER COLUMN [HoldMessage] nVarChar(512) ;
 GO 
ALTER TABLE [dbo].[TOPRO_RATECON] ALTER COLUMN [Last_Opr] nVarChar(50) ;
 GO 
ALTER TABLE [dbo].[TOPRO_RATECON] ALTER COLUMN [VALUEDESC1] nVarChar(255) ;
 GO 
ALTER TABLE [dbo].[TOPRO_RATECON] ALTER COLUMN [VALUEDESC2] nVarChar(255) ;
 GO 
ALTER TABLE [dbo].[TOPRO_RATECON] ALTER COLUMN [VALUEDESC3] nVarChar(255) ;
 GO 
ALTER TABLE [dbo].[TOPRO_RATECON] ALTER COLUMN [VALUEDESC4] nVarChar(255) ;
 GO 
ALTER TABLE [dbo].[TOPRO_RATECON] ALTER COLUMN [VALUEDESC5] nVarChar(255) ;
 GO 
ALTER TABLE [dbo].[TOPRO_RATECON] ALTER COLUMN [VALUEDESC6] nVarChar(255) ;
 GO 
ALTER TABLE [dbo].[TOPRO_RATECON] ALTER COLUMN [VALUEDESC7] nVarChar(255) ;
 GO 
ALTER TABLE [dbo].[TOPRO_RATECON] ALTER COLUMN [VALUEDESC8] nVarChar(255) ;
 GO 
ALTER TABLE [dbo].[TOPRO_RATECON] ALTER COLUMN [VALUEDESC9] nVarChar(255) ;
 GO 
ALTER TABLE [dbo].[TOPRO_RATECON] ALTER COLUMN [VALUEDESC10] nVarChar(255) ;
 GO 
ALTER TABLE [dbo].[TOPRO_RATECON] ALTER COLUMN [VALUEDESC11] nVarChar(255) ;
 GO 
ALTER TABLE [dbo].[TOPRO_RATECON] ALTER COLUMN [VALUEDESC12] nVarChar(255) ;
 GO 
ALTER TABLE [dbo].[TOPRO_RATECON] ALTER COLUMN [VALUEDESC13] nVarChar(255) ;
 GO 
ALTER TABLE [dbo].[TOPRO_RATECON] ALTER COLUMN [VALUEDESC14] nVarChar(255) ;
 GO 
ALTER TABLE [dbo].[TOPRO_RATECON] ALTER COLUMN [VALUEDESC15] nVarChar(255) ;
 GO 
ALTER TABLE [dbo].[TOR] ALTER COLUMN [DESCRIPTION] nVarChar(255) ;
 GO 
ALTER TABLE [dbo].[TOR] ALTER COLUMN [Last_Opr] nVarChar(50) ;
 GO 
ALTER TABLE [dbo].[TORSUB] ALTER COLUMN [Last_Opr] nVarChar(50) ;
 GO 
ALTER TABLE [dbo].[TType] ALTER COLUMN [Description] nVarChar(50) ;
 GO 
ALTER TABLE [dbo].[TType] ALTER COLUMN [Location] nVarChar(10) ;
 GO 
ALTER TABLE [dbo].[Type] ALTER COLUMN [Description] nVarChar(20) ;
 GO 
ALTER TABLE [dbo].[Type] ALTER COLUMN [Last_Opr] nVarChar(50) ;
 GO 
ALTER TABLE [dbo].[Unit] ALTER COLUMN [Last_Opr] nVarChar(10) ;
 GO 
ALTER TABLE [dbo].[Unit] ALTER COLUMN [Description] nVarChar(255) ;
 GO 
ALTER TABLE [dbo].[UploadFile] ALTER COLUMN [Name] nVarChar(255) ;
 GO 
ALTER TABLE [dbo].[UploadFile] ALTER COLUMN [Remarks] nVarChar(255) ;
 GO 
ALTER TABLE [dbo].[UploadProvider] ALTER COLUMN [Name] nVarChar(255) ;
 GO 
ALTER TABLE [dbo].[VAccount] ALTER COLUMN [BankName] nVarChar(255) ;
 GO 
ALTER TABLE [dbo].[VAccount] ALTER COLUMN [LAST_OPR] nVarChar(50) ;
 GO 
ALTER TABLE [dbo].[VAccountD] ALTER COLUMN [Last_Opr] nVarChar(50) ;
 GO 
ALTER TABLE [dbo].[VDOCLIST] ALTER COLUMN [LAST_OPR] nVarChar(50) ;
 GO 
ALTER TABLE [dbo].[VDOCLIST] ALTER COLUMN [DESCRIPTION] nVarChar(255) ;
 GO 
ALTER TABLE [dbo].[VDOCLIST] ALTER COLUMN [REMARKS] nVarChar(512) ;
 GO 
ALTER TABLE [dbo].[VDOCLISTPIC] ALTER COLUMN [Remark] nVarChar(max) ;
 GO 
ALTER TABLE [dbo].[VDOCLISTPIC] ALTER COLUMN [Last_Opr] nVarChar(50) ;
 GO 
ALTER TABLE [dbo].[Village] ALTER COLUMN [Last_OPR] nVarChar(10) ;
 GO 
ALTER TABLE [dbo].[VLinkPrintLogH] ALTER COLUMN [Description] nVarChar(50) ;
 GO 
ALTER TABLE [dbo].[VLinkPrintLogH] ALTER COLUMN [UserID] nVarChar(10) ;
 GO 
ALTER TABLE [dbo].[VoucherLinkH] ALTER COLUMN [Remarks] nVarChar(255) ;
 GO 
ALTER TABLE [dbo].[VoucherLinkH] ALTER COLUMN [UserID] nVarChar(10) ;
 GO 
ALTER TABLE [dbo].[VoucherPic] ALTER COLUMN [UserID] nVarChar(50) ;
 GO 
ALTER TABLE [dbo].[VoucherPic] ALTER COLUMN [Last_Opr] nVarChar(50) ;
 GO 
DROP INDEX [dbo].[VPrintLog].[I_VPrintLog_Voucher_DocNo_Description];
 GO 
ALTER TABLE [dbo].[VPrintLog] ALTER COLUMN [Description] nVarChar(50) ;
 GO 
CREATE NONCLUSTERED INDEX [I_VPrintLog_Voucher_DocNo_Description] ON [dbo].[VPrintLog] (  [Voucher] , [DocNo] , [Description] )
 GO 
ALTER TABLE [dbo].[VPrintLog] ALTER COLUMN [UserID] nVarChar(50) ;
 GO 
ALTER TABLE [dbo].[vType] ALTER COLUMN [Description] nVarChar(100) ;
 GO 
ALTER TABLE [dbo].[vType] ALTER COLUMN [Last_Opr] nVarChar(50) ;
 GO 
ALTER TABLE [dbo].[Wording] ALTER COLUMN [Last_Opr] nVarChar(50) ;
 GO 
ALTER TABLE [dbo].[Wording] ALTER COLUMN [ShortDesc] nVarChar(255) ;
 GO 