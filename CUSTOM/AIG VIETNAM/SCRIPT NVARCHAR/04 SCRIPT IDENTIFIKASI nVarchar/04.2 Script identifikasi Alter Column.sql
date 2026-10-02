Exec sp_alter_column dbo,  AAccBS ,PICName ,PICName,'nVarChar(255)','',0
GO
Exec sp_alter_column dbo,  AAccBS ,LUserID ,LUserID,'nVarChar(50)','',0
GO
Exec sp_alter_column dbo,  AAccBS ,PICEmail ,PICEmail,'nVarChar(255)','',0
GO
Exec sp_alter_column dbo,  ABeneficiaries ,Name ,Name,'nVarChar(255)','',0
GO
Exec sp_alter_column dbo,  ABeneficiaries ,Address_1 ,Address_1,'nVarChar(1024)','',0
GO
Exec sp_alter_column dbo,  ABeneficiaries ,Address_2 ,Address_2,'nVarChar(1024)','',0
GO
Exec sp_alter_column dbo,  ABeneficiaries ,REMARK ,REMARK,'nVarChar(255)','',0
GO
Exec sp_alter_column dbo,  ABeneficiaries ,Email ,Email,'nVarChar(512)','',0
GO
Exec sp_alter_column dbo,  ACCBS ,PICName ,PICName,'nVarChar(255)','',0
GO
Exec sp_alter_column dbo,  ACCBS ,LUserID ,LUserID,'nVarChar(50)','',0
GO
Exec sp_alter_column dbo,  ACCBS ,PICEmail ,PICEmail,'nVarChar(255)','',0
GO
Exec sp_alter_column dbo,  AccCA ,Address ,Address,'nVarChar(1024)','',0
GO
Exec sp_alter_column dbo,  AccCA ,Email ,Email,'nVarChar(512)','',0
GO
Exec sp_alter_column dbo,  ACCCLA ,SHORTDESC ,SHORTDESC,'nVarChar(max)','',0
GO
Exec sp_alter_column dbo,  ACCCLA ,Last_Opr ,Last_Opr,'nVarChar(50)','',0
GO
Exec sp_alter_column dbo,  ACCCLA ,ShortDesc_1 ,ShortDesc_1,'nVarChar(max)','',0
GO
Exec sp_alter_column dbo,  AccClass ,Last_Opr ,Last_Opr,'nVarChar(50)','',0
GO
Exec sp_alter_column dbo,  AccClass ,Description ,Description,'nVarChar(100)','',0
GO
Exec sp_alter_column dbo,  AccClass ,ShortDesc ,ShortDesc,'nVarChar(100)','',0
GO
Exec sp_alter_column dbo,  AccClassDet ,Description ,Description,'nVarChar(200)','',0
GO
Exec sp_alter_column dbo,  ACCCNC ,USERID ,USERID,'nVarChar(50)','',0
GO
Exec sp_alter_column dbo,  ACCCOLLATERAL ,REMARKS ,REMARKS,'nVarChar(512)','',0
GO
Exec sp_alter_column dbo,  ACCCOLLATERAL ,DESCRIPTION ,DESCRIPTION,'nVarChar(255)','',0
GO
Exec sp_alter_column dbo,  ACCCOLLATERAL ,Attrib_1 ,Attrib_1,'nVarChar(100)','',0
GO
Exec sp_alter_column dbo,  ACCCOLLATERAL ,Attrib_2 ,Attrib_2,'nVarChar(100)','',0
GO
Exec sp_alter_column dbo,  ACCCOLLATERAL ,Attrib_3 ,Attrib_3,'nVarChar(100)','',0
GO
Exec sp_alter_column dbo,  ACCCOLLATERAL ,Attrib_4 ,Attrib_4,'nVarChar(100)','',0
GO
Exec sp_alter_column dbo,  ACCCOLLATERAL ,Attrib_5 ,Attrib_5,'nVarChar(100)','',0
GO
Exec sp_alter_column dbo,  ACCCOLLATERAL ,Attrib_6 ,Attrib_6,'nVarChar(100)','',0
GO
Exec sp_alter_column dbo,  ACCCOLLATERAL ,Attrib_7 ,Attrib_7,'nVarChar(100)','',0
GO
Exec sp_alter_column dbo,  ACCCOLLATERAL ,Attrib_8 ,Attrib_8,'nVarChar(100)','',0
GO
Exec sp_alter_column dbo,  ACCCOLLATERAL ,Attrib_9 ,Attrib_9,'nVarChar(100)','',0
GO
Exec sp_alter_column dbo,  ACCCOLLATERAL ,Attrib_10 ,Attrib_10,'nVarChar(100)','',0
GO
Exec sp_alter_column dbo,  ACCCOLLATERAL ,LAST_OPR ,LAST_OPR,'nVarChar(50)','',0
GO
Exec sp_alter_column dbo,  ACCCOMPSHEETH ,USERID ,USERID,'nVarChar(50)','',0
GO
Exec sp_alter_column dbo,  ACCCOMPSHEETH ,LUSERID ,LUSERID,'nVarChar(50)','',0
GO
Exec sp_alter_column dbo,  ACCCOMPSHEETH ,AUSERID ,AUSERID,'nVarChar(50)','',0
GO
Exec sp_alter_column dbo,  ACCCOMPSHEETH ,CUSERID ,CUSERID,'nVarChar(50)','',0
GO
Exec sp_alter_column dbo,  ACCCOMPSHEETH ,PUserID ,PUserID,'nVarChar(50)','',0
GO
Exec sp_alter_column dbo,  ACCCOMPSHEETH ,COMMENT ,COMMENT,'nVarChar(max)','',0
GO
Exec sp_alter_column dbo,  ACCCON ,Last_Opr ,Last_Opr,'nVarChar(50)','',0
GO
Exec sp_alter_column dbo,  ACCCON ,SHORTDESC ,SHORTDESC,'nVarChar(max)','',0
GO
Exec sp_alter_column dbo,  ACCCON ,ShortDesc_1 ,ShortDesc_1,'nVarChar(max)','',0
GO
Exec sp_alter_column dbo,  AccDA ,Address ,Address,'nVarChar(1024)','',0
GO
Exec sp_alter_column dbo,  AccDA ,Email ,Email,'nVarChar(512)','',0
GO
Exec sp_alter_column dbo,  ACCDED ,REMARKS_1 ,REMARKS_1,'nVarChar(2048)','',0
GO
Exec sp_alter_column dbo,  ACCDED ,LUserID ,LUserID,'nVarChar(50)','',0
GO
Exec sp_alter_column dbo,  ACCDEPOSIT ,REMARK ,REMARK,'nVarChar(255)','',0
GO
Exec sp_alter_column dbo,  ACCDEPOSIT ,Last_Opr ,Last_Opr,'nVarChar(50)','',0
GO
Exec sp_alter_column dbo,  ACCDOCLIST ,DESCRIPTION ,DESCRIPTION,'nVarChar(255)','',0
GO
Exec sp_alter_column dbo,  ACCDOCLIST ,REMARKS ,REMARKS,'nVarChar(512)','',0
GO
Exec sp_alter_column dbo,  ACCDOCLIST ,LAST_OPR ,LAST_OPR,'nVarChar(50)','',0
GO
Exec sp_alter_column dbo,  ACCDOCLISTPIC ,Last_Opr ,Last_Opr,'nVarChar(50)','',0
GO
Exec sp_alter_column dbo,  AccDocStat ,Remarks ,Remarks,'nVarChar(255)','',0
GO
Exec sp_alter_column dbo,  AccDocStat ,Last_Opr ,Last_Opr,'nVarChar(50)','',0
GO
Exec sp_alter_column dbo,  ACCEMPCONTD ,REMARKS ,REMARKS,'nVarChar(255)','',0
GO
Exec sp_alter_column dbo,  ACCEMPCONTH ,REMARKS ,REMARKS,'nVarChar(512)','',0
GO
Exec sp_alter_column dbo,  ACCEMPCONTH ,USERID ,USERID,'nVarChar(50)','',0
GO
Exec sp_alter_column dbo,  ACCEMPCONTH ,LUSERID ,LUSERID,'nVarChar(50)','',0
GO
Exec sp_alter_column dbo,  ACCEMPCONTH ,AUSERID ,AUSERID,'nVarChar(50)','',0
GO
Exec sp_alter_column dbo,  ACCEMPCONTH ,CUSERID ,CUSERID,'nVarChar(50)','',0
GO
Exec sp_alter_column dbo,  ACCEMPCONTH ,PUserID ,PUserID,'nVarChar(50)','',0
GO
Exec sp_alter_column dbo,  ACCEPTANCE ,SYSUSERID ,SYSUSERID,'nVarChar(50)','',0
GO
Exec sp_alter_column dbo,  ACCEPTANCE ,USERID ,USERID,'nVarChar(50)','',0
GO
Exec sp_alter_column dbo,  ACCEPTANCE ,CUSERID ,CUSERID,'nVarChar(50)','',0
GO
Exec sp_alter_column dbo,  ACCEPTANCE ,AName ,AName,'nVarChar(max)','',0
GO
Exec sp_alter_column dbo,  ACCEPTANCE ,LUserID ,LUserID,'nVarChar(50)','',0
GO
Exec sp_alter_column dbo,  ACCEPTANCE ,AUserID ,AUserID,'nVarChar(50)','',0
GO
Exec sp_alter_column dbo,  ACCEPTANCE ,RequestName ,RequestName,'nVarChar(50)','',0
GO
Exec sp_alter_column dbo,  ACCEPTANCE ,Location ,Location,'nVarChar(100)','',0
GO
Exec sp_alter_column dbo,  ACCEPTANCE ,RUserID ,RUserID,'nVarChar(50)','',0
GO
Exec sp_alter_column dbo,  ACCEPTANCE ,ActionUser ,ActionUser,'nVarChar(50)','',0
GO
Exec sp_alter_column dbo,  ACCEX ,Last_Opr ,Last_Opr,'nVarChar(50)','',0
GO
Exec sp_alter_column dbo,  ACCEX ,SHORTDESC ,SHORTDESC,'nVarChar(max)','',0
GO
Exec sp_alter_column dbo,  ACCEX ,ShortDesc_1 ,ShortDesc_1,'nVarChar(max)','',0
GO
Exec sp_alter_column dbo,  ACCFD ,LUserID ,LUserID,'nVarChar(50)','',0
GO
Exec sp_alter_column dbo,  ACCINVOICE ,Last_Opr ,Last_Opr,'nVarChar(50)','',0
GO
Exec sp_alter_column dbo,  ACCINVOICE ,InvoiceRemarks ,InvoiceRemarks,'nVarChar(255)','',0
GO
Exec sp_alter_column dbo,  ACCLINK ,LUserID ,LUserID,'nVarChar(50)','',0
GO
Exec sp_alter_column dbo,  Account ,Last_Opr ,Last_Opr,'nVarChar(50)','',0
GO
Exec sp_alter_column dbo,  Account ,Description ,Description,'nVarChar(200)','',0
GO
Exec sp_alter_column dbo,  Account ,Description1 ,Description1,'nVarChar(200)','',0
GO
Exec sp_alter_column dbo,  ACCPIC ,UserID ,UserID,'nVarChar(50)','',0
GO
Exec sp_alter_column dbo,  ACCPIC ,Last_Opr ,Last_Opr,'nVarChar(50)','',0
GO
Exec sp_alter_column dbo,  AccType ,Name ,Name,'nVarChar(50)','',0
GO
Exec sp_alter_column dbo,  ACGROUP ,DESCRIPTION ,DESCRIPTION,'nVarChar(50)','',0
GO
Exec sp_alter_column dbo,  ActionList ,Description ,Description,'nVarChar(255)','',0
GO
Exec sp_alter_column dbo,  ActionList ,ActionName ,ActionName,'nVarChar(100)','',0
GO
Exec sp_alter_column dbo,  ActionList ,ApprovedFName ,ApprovedFName,'nVarChar(50)','',0
GO
Exec sp_alter_column dbo,  ActionLog ,AppName ,AppName,'nVarChar(10)','',0
GO
Exec sp_alter_column dbo,  ActionLog ,ActionUser ,ActionUser,'nVarChar(50)','',0
GO
Exec sp_alter_column dbo,  ActionNotification ,ActionUser ,ActionUser,'nVarChar(50)','',0
GO
Exec sp_alter_column dbo,  ActionNotification ,AppName ,AppName,'nVarChar(10)','',0
GO
Exec sp_alter_column dbo,  ActionUser ,ActionUserAuth_1 ,ActionUserAuth_1,'nVarChar(50)','',0
GO
Exec sp_alter_column dbo,  ActionUser ,ActionUserAuth_7 ,ActionUserAuth_7,'nVarChar(50)','',0
GO
Exec sp_alter_column dbo,  ActionUser ,ActionUserAuth_4 ,ActionUserAuth_4,'nVarChar(50)','',0
GO
Exec sp_alter_column dbo,  ActionUser ,ActionUserAuth_10 ,ActionUserAuth_10,'nVarChar(50)','',0
GO
Exec sp_alter_column dbo,  ActionUser ,ActionUserAuth_2 ,ActionUserAuth_2,'nVarChar(50)','',0
GO
Exec sp_alter_column dbo,  ActionUser ,ActionUser ,ActionUser,'nVarChar(50)','',0
GO
Exec sp_alter_column dbo,  ActionUser ,ActionUserAuth_5 ,ActionUserAuth_5,'nVarChar(50)','',0
GO
Exec sp_alter_column dbo,  ActionUser ,ActionUserAuth_8 ,ActionUserAuth_8,'nVarChar(50)','',0
GO
Exec sp_alter_column dbo,  ActionUser ,ActionUserAuth_6 ,ActionUserAuth_6,'nVarChar(50)','',0
GO
Exec sp_alter_column dbo,  ActionUser ,ActionUserAuth_9 ,ActionUserAuth_9,'nVarChar(50)','',0
GO
Exec sp_alter_column dbo,  ActionUser ,ActionUserAuth_3 ,ActionUserAuth_3,'nVarChar(50)','',0
GO
Exec sp_alter_column dbo,  ActionUserDet ,ActionUser ,ActionUser,'nVarChar(50)','',0
GO
Exec sp_alter_column dbo,  ActionUserDet ,Last_Opr ,Last_Opr,'nVarChar(50)','',0
GO
Exec sp_alter_column dbo,  AdmLink ,REMARKS ,REMARKS,'nVarChar(max)','',0
GO
Exec sp_alter_column dbo,  AdmLink ,LUserID ,LUserID,'nVarChar(50)','',0
GO
Exec sp_alter_column dbo,  AdmLink ,VALUEDESC ,VALUEDESC,'nVarChar(255)','',0
GO
Exec sp_alter_column dbo,  AdmLink ,Email ,Email,'nVarChar(512)','',0
GO
Exec sp_alter_column dbo,  AEBucket ,Last_Opr ,Last_Opr,'nVarChar(50)','',0
GO
Exec sp_alter_column dbo,  AgeBand ,Last_Opr ,Last_Opr,'nVarChar(10)','',0
GO
Exec sp_alter_column dbo,  AIBucket ,Last_Opr ,Last_Opr,'nVarChar(50)','',0
GO
Exec sp_alter_column dbo,  AINFODET ,CUserID ,CUserID,'nVarChar(50)','',0
GO
Exec sp_alter_column dbo,  AINFODET ,AUserID ,AUserID,'nVarChar(50)','',0
GO
Exec sp_alter_column dbo,  AINFODET ,RequestMessage ,RequestMessage,'nVarChar(max)','',0
GO
Exec sp_alter_column dbo,  AINFODET ,RequestName ,RequestName,'nVarChar(50)','',0
GO
Exec sp_alter_column dbo,  AINFODET ,ContractDescription ,ContractDescription,'nVarChar(512)','',0
GO
Exec sp_alter_column dbo,  AINFODET ,Last_Opr ,Last_Opr,'nVarChar(50)','',0
GO
Exec sp_alter_column dbo,  AINFODETPIC ,Last_Opr ,Last_Opr,'nVarChar(50)','',0
GO
Exec sp_alter_column dbo,  AINPARTY ,Name ,Name,'nVarChar(255)','',0
GO
Exec sp_alter_column dbo,  AINPARTY ,Address_1 ,Address_1,'nVarChar(1024)','',0
GO
Exec sp_alter_column dbo,  AINPARTY ,Address_2 ,Address_2,'nVarChar(1024)','',0
GO
Exec sp_alter_column dbo,  AINPARTY ,REMARK ,REMARK,'nVarChar(255)','',0
GO
Exec sp_alter_column dbo,  AINPARTY ,Email ,Email,'nVarChar(512)','',0
GO
Exec sp_alter_column dbo,  AINPARTY ,Beneficiary_Name ,Beneficiary_Name,'nVarChar(255)','',0
GO
Exec sp_alter_column dbo,  akun_jkd ,Description ,Description,'nVarChar(100)','',0
GO
Exec sp_alter_column dbo,  akun_jkd ,Last_Opr ,Last_Opr,'nVarChar(10)','',0
GO
Exec sp_alter_column dbo,  akun_jkd ,Description1 ,Description1,'nVarChar(100)','',0
GO
Exec sp_alter_column dbo,  ALBucket ,Remarks ,Remarks,'nVarChar(255)','',0
GO
Exec sp_alter_column dbo,  ALBucket ,Last_Opr ,Last_Opr,'nVarChar(50)','',0
GO
Exec sp_alter_column dbo,  ALBucket ,CUserID ,CUserID,'nVarChar(50)','',0
GO
Exec sp_alter_column dbo,  ALBucket ,PUserID ,PUserID,'nVarChar(50)','',0
GO
Exec sp_alter_column dbo,  ALRule ,Last_Opr ,Last_Opr,'nVarChar(50)','',0
GO
Exec sp_alter_column dbo,  AmortizationD ,Last_Opr ,Last_Opr,'nVarChar(50)','',0
GO
Exec sp_alter_column dbo,  AmortizationH ,Description ,Description,'nVarChar(100)','',0
GO
Exec sp_alter_column dbo,  AmortizationH ,Last_Opr ,Last_Opr,'nVarChar(50)','',0
GO
Exec sp_alter_column dbo,  AmorType ,Name ,Name,'nVarChar(50)','',0
GO
Exec sp_alter_column dbo,  AmorType ,Description ,Description,'nVarChar(50)','',0
GO
Exec sp_alter_column dbo,  AmorType ,Last_Opr ,Last_Opr,'nVarChar(50)','',0
GO
Exec sp_alter_column dbo,  APayor ,ADDRESS_1 ,ADDRESS_1,'nVarChar(1024)','',0
GO
Exec sp_alter_column dbo,  APayor ,ADDRESS_2 ,ADDRESS_2,'nVarChar(1024)','',0
GO
Exec sp_alter_column dbo,  APayor ,ADDRESS_3 ,ADDRESS_3,'nVarChar(1024)','',0
GO
Exec sp_alter_column dbo,  APayor ,Remarks ,Remarks,'nVarChar(255)','',0
GO
Exec sp_alter_column dbo,  APayor ,LUserID ,LUserID,'nVarChar(50)','',0
GO
Exec sp_alter_column dbo,  APBucket ,Last_Opr ,Last_Opr,'nVarChar(50)','',0
GO
Exec sp_alter_column dbo,  APDBucket ,SaveLocationAttachment_8 ,SaveLocationAttachment_8,'nVarChar(255)','',0
GO
Exec sp_alter_column dbo,  APDBucket ,SaveLocationAttachment_1 ,SaveLocationAttachment_1,'nVarChar(255)','',0
GO
Exec sp_alter_column dbo,  APDBucket ,RepName ,RepName,'nVarChar(20)','',0
GO
Exec sp_alter_column dbo,  APDBucket ,SaveLocationAttachment_5 ,SaveLocationAttachment_5,'nVarChar(255)','',0
GO
Exec sp_alter_column dbo,  APDBucket ,SaveLocation ,SaveLocation,'nVarChar(255)','',0
GO
Exec sp_alter_column dbo,  APDBucket ,SaveLocationAttachment_2 ,SaveLocationAttachment_2,'nVarChar(255)','',0
GO
Exec sp_alter_column dbo,  APDBucket ,Last_Opr ,Last_Opr,'nVarChar(50)','',0
GO
Exec sp_alter_column dbo,  APDBucket ,SaveLocationAttachment_3 ,SaveLocationAttachment_3,'nVarChar(255)','',0
GO
Exec sp_alter_column dbo,  APDBucket ,SaveLocationAttachment_6 ,SaveLocationAttachment_6,'nVarChar(255)','',0
GO
Exec sp_alter_column dbo,  APDBucket ,ExeName ,ExeName,'nVarChar(255)','',0
GO
Exec sp_alter_column dbo,  APDBucket ,SaveLocationAttachment_7 ,SaveLocationAttachment_7,'nVarChar(255)','',0
GO
Exec sp_alter_column dbo,  APDBucket ,SaveLocationAttachment_4 ,SaveLocationAttachment_4,'nVarChar(255)','',0
GO
Exec sp_alter_column dbo,  APDBucket ,EMailTo ,EMailTo,'nVarChar(10)','',0
GO
Exec sp_alter_column dbo,  APDRuleD ,EMailTo ,EMailTo,'nVarChar(10)','',0
GO
Exec sp_alter_column dbo,  APDRuleD ,Last_Opr ,Last_Opr,'nVarChar(50)','',0
GO
Exec sp_alter_column dbo,  APDRuleD ,RepName ,RepName,'nVarChar(20)','',0
GO
Exec sp_alter_column dbo,  APDRuleD ,ExeName ,ExeName,'nVarChar(255)','',0
GO
Exec sp_alter_column dbo,  APDRuleD_Insured ,Last_Opr ,Last_Opr,'nVarChar(50)','',0
GO
Exec sp_alter_column dbo,  APDRuleD_PHolder ,Last_Opr ,Last_Opr,'nVarChar(50)','',0
GO
Exec sp_alter_column dbo,  APDRuleD_Segment ,Last_Opr ,Last_Opr,'nVarChar(50)','',0
GO
Exec sp_alter_column dbo,  APDRuleH ,EmailFrom ,EmailFrom,'nVarChar(512)','',0
GO
Exec sp_alter_column dbo,  APDRuleH ,EmailCC ,EmailCC,'nVarChar(512)','',0
GO
Exec sp_alter_column dbo,  APDRuleH ,EmailBCC ,EmailBCC,'nVarChar(512)','',0
GO
Exec sp_alter_column dbo,  APDRuleH ,Last_Opr ,Last_Opr,'nVarChar(50)','',0
GO
Exec sp_alter_column dbo,  ARBucket ,pSLRef_Description_2 ,pSLRef_Description_2,'nVarChar(50)','',0
GO
Exec sp_alter_column dbo,  ARBucket ,pSLRef_Description_3 ,pSLRef_Description_3,'nVarChar(50)','',0
GO
Exec sp_alter_column dbo,  ARBucket ,Procname ,Procname,'nVarChar(100)','',0
GO
Exec sp_alter_column dbo,  ARBucket ,pSLRef_Description_1 ,pSLRef_Description_1,'nVarChar(50)','',0
GO
Exec sp_alter_column dbo,  ARBucket ,Last_Opr ,Last_Opr,'nVarChar(50)','',0
GO
Exec sp_alter_column dbo,  ARBucket ,pSLRef_Description_5 ,pSLRef_Description_5,'nVarChar(50)','',0
GO
Exec sp_alter_column dbo,  ARBucket ,pSLRef_Description_4 ,pSLRef_Description_4,'nVarChar(50)','',0
GO
Exec sp_alter_column dbo,  ARBucket_Backup20210301 ,Last_Opr ,Last_Opr,'nVarChar(50)','',0
GO
Exec sp_alter_column dbo,  ARBucket_Backup20210301 ,Remarks ,Remarks,'nVarChar(512)','',0
GO
Exec sp_alter_column dbo,  ARBucket_Backup20210301 ,Procname ,Procname,'nVarChar(100)','',0
GO
Exec sp_alter_column dbo,  Area ,Last_Opr ,Last_Opr,'nVarChar(50)','',0
GO
Exec sp_alter_column dbo,  Area ,Description ,Description,'nVarChar(50)','',0
GO
Exec sp_alter_column dbo,  AROSLog ,CUserID ,CUserID,'nVarChar(50)','',0
GO
Exec sp_alter_column dbo,  AROSLog ,TBName ,TBName,'nVarChar(25)','',0
GO
Exec sp_alter_column dbo,  ARPRINTLOG ,UserID ,UserID,'nVarChar(50)','',0
GO
Exec sp_alter_column dbo,  ARPRINTLOG ,Description ,Description,'nVarChar(50)','',0
GO
Exec sp_alter_column dbo,  AutoNum ,Last_Opr ,Last_Opr,'nVarChar(50)','',0
GO
Exec sp_alter_column dbo,  AutoNum ,Description ,Description,'nVarChar(50)','',0
GO
Exec sp_alter_column dbo,  AutoNum ,TBName ,TBName,'nVarChar(50)','',0
GO
Exec sp_alter_column dbo,  Balance_Type ,Description ,Description,'nVarChar(100)','',0
GO
Exec sp_alter_column dbo,  Bank ,ShortName ,ShortName,'nVarChar(100)','',0
GO
Exec sp_alter_column dbo,  Bank ,Description ,Description,'nVarChar(100)','',0
GO
Exec sp_alter_column dbo,  Bank ,Last_Opr ,Last_Opr,'nVarChar(50)','',0
GO
Exec sp_alter_column dbo,  BankBranch ,Last_Opr ,Last_Opr,'nVarChar(50)','',0
GO
Exec sp_alter_column dbo,  BankBranch ,Address_1 ,Address_1,'nVarChar(1024)','',0
GO
Exec sp_alter_column dbo,  BankBranch ,Address_2 ,Address_2,'nVarChar(1024)','',0
GO
Exec sp_alter_column dbo,  BankBranch ,Address_3 ,Address_3,'nVarChar(1024)','',0
GO
Exec sp_alter_column dbo,  BAssumption_Exchange ,Last_Opr ,Last_Opr,'nVarChar(50)','',0
GO
Exec sp_alter_column dbo,  BAssumption_Growth ,Last_Opr ,Last_Opr,'nVarChar(50)','',0
GO
Exec sp_alter_column dbo,  BAssumption_Rate ,Last_Opr ,Last_Opr,'nVarChar(50)','',0
GO
Exec sp_alter_column dbo,  BAssumption_Ratio ,Last_Opr ,Last_Opr,'nVarChar(50)','',0
GO
Exec sp_alter_column dbo,  BatchScreening ,RepName ,RepName,'nVarChar(100)','',0
GO
Exec sp_alter_column dbo,  BDClass ,Last_Opr ,Last_Opr,'nVarChar(10)','',0
GO
Exec sp_alter_column dbo,  Beneficiaries ,Address_1 ,Address_1,'nVarChar(1024)','',0
GO
Exec sp_alter_column dbo,  Beneficiaries ,Address_2 ,Address_2,'nVarChar(1024)','',0
GO
Exec sp_alter_column dbo,  Beneficiaries ,Email ,Email,'nVarChar(512)','',0
GO
Exec sp_alter_column dbo,  Benefit ,Name ,Name,'nVarChar(200)','',0
GO
Exec sp_alter_column dbo,  Benefit ,Name_1 ,Name_1,'nVarChar(100)','',0
GO
Exec sp_alter_column dbo,  Benefit ,BShortDesc ,BShortDesc,'nVarChar(16)','',0
GO
Exec sp_alter_column dbo,  Benefit ,Last_Opr ,Last_Opr,'nVarChar(10)','',0
GO
Exec sp_alter_column dbo,  Benefit_ExtMap ,Last_Opr ,Last_Opr,'nVarChar(10)','',0
GO
Exec sp_alter_column dbo,  Benefit_Rate ,Last_Opr ,Last_Opr,'nVarChar(10)','',0
GO
Exec sp_alter_column dbo,  BenefitEDCMap ,Last_Opr ,Last_Opr,'nVarChar(10)','',0
GO
Exec sp_alter_column dbo,  BIAsset ,Name ,Name,'nVarChar(50)','',0
GO
Exec sp_alter_column dbo,  BIAsset ,Description ,Description,'nVarChar(255)','',0
GO
Exec sp_alter_column dbo,  BIType ,Description ,Description,'nVarChar(255)','',0
GO
Exec sp_alter_column dbo,  BIType ,Last_Opr ,Last_Opr,'nVarChar(50)','',0
GO
Exec sp_alter_column dbo,  BIType ,Name ,Name,'nVarChar(50)','',0
GO
Exec sp_alter_column dbo,  BizMap ,Last_Opr ,Last_Opr,'nVarChar(50)','',0
GO
Exec sp_alter_column dbo,  BizMap ,Description ,Description,'nVarChar(100)','',0
GO
Exec sp_alter_column dbo,  Blanket ,UserID ,UserID,'nVarChar(50)','',0
GO
Exec sp_alter_column dbo,  Blanket ,LUserID ,LUserID,'nVarChar(50)','',0
GO
Exec sp_alter_column dbo,  Blanket_Delivery ,UserID ,UserID,'nVarChar(50)','',0
GO
Exec sp_alter_column dbo,  Blanket_Delivery ,LUserID ,LUserID,'nVarChar(50)','',0
GO
Exec sp_alter_column dbo,  Blanket_Delivery_Detail ,UserID ,UserID,'nVarChar(50)','',0
GO
Exec sp_alter_column dbo,  Blanket_Delivery_Detail ,LUserID ,LUserID,'nVarChar(50)','',0
GO
Exec sp_alter_column dbo,  BPP ,Last_Opr ,Last_Opr,'nVarChar(50)','',0
GO
Exec sp_alter_column dbo,  BPP ,Description ,Description,'nVarChar(50)','',0
GO
Exec sp_alter_column dbo,  Branch ,Last_Opr ,Last_Opr,'nVarChar(50)','',0
GO
Exec sp_alter_column dbo,  Branch ,Address ,Address,'nVarChar(1024)','',0
GO
Exec sp_alter_column dbo,  Branch ,SignerName ,SignerName,'nVarChar(255)','',0
GO
Exec sp_alter_column dbo,  Branch ,Email ,Email,'nVarChar(512)','',0
GO
Exec sp_alter_column dbo,  Branch ,SignerName_1 ,SignerName_1,'nVarChar(255)','',0
GO
Exec sp_alter_column dbo,  Branch ,SignerName_2 ,SignerName_2,'nVarChar(255)','',0
GO
Exec sp_alter_column dbo,  branchcob ,branchname ,branchname,'nVarChar(70)','',0
GO
Exec sp_alter_column dbo,  BranchMailAddress ,RetailEmail ,RetailEmail,'nVarChar(255)','',0
GO
Exec sp_alter_column dbo,  BranchMailAddress ,ClaimEmail ,ClaimEmail,'nVarChar(255)','',0
GO
Exec sp_alter_column dbo,  branchtoc ,branchname ,branchname,'nVarChar(70)','',0
GO
Exec sp_alter_column dbo,  BRRule ,Last_Opr ,Last_Opr,'nVarChar(50)','',0
GO
Exec sp_alter_column dbo,  BSOPEX ,REMARK ,REMARK,'nVarChar(50)','',0
GO
Exec sp_alter_column dbo,  BSOPEX ,Last_Opr ,Last_Opr,'nVarChar(50)','',0
GO
Exec sp_alter_column dbo,  BSOPEXDET ,VALUEDESC13 ,VALUEDESC13,'nVarChar(255)','',0
GO
Exec sp_alter_column dbo,  BSOPEXDET ,VALUEDESC12 ,VALUEDESC12,'nVarChar(255)','',0
GO
Exec sp_alter_column dbo,  BSOPEXDET ,VALUEDESC15 ,VALUEDESC15,'nVarChar(255)','',0
GO
Exec sp_alter_column dbo,  BSOPEXDET ,VALUEDESC14 ,VALUEDESC14,'nVarChar(255)','',0
GO
Exec sp_alter_column dbo,  BSOPEXDET ,VALUEDESC10 ,VALUEDESC10,'nVarChar(255)','',0
GO
Exec sp_alter_column dbo,  BSOPEXDET ,VALUEDESC7 ,VALUEDESC7,'nVarChar(255)','',0
GO
Exec sp_alter_column dbo,  BSOPEXDET ,VALUEDESC11 ,VALUEDESC11,'nVarChar(255)','',0
GO
Exec sp_alter_column dbo,  BSOPEXDET ,VALUEDESC8 ,VALUEDESC8,'nVarChar(255)','',0
GO
Exec sp_alter_column dbo,  BSOPEXDET ,Last_Opr ,Last_Opr,'nVarChar(50)','',0
GO
Exec sp_alter_column dbo,  BSOPEXDET ,VALUEDESC1 ,VALUEDESC1,'nVarChar(255)','',0
GO
Exec sp_alter_column dbo,  BSOPEXDET ,VALUEDESC6 ,VALUEDESC6,'nVarChar(255)','',0
GO
Exec sp_alter_column dbo,  BSOPEXDET ,VALUEDESC9 ,VALUEDESC9,'nVarChar(255)','',0
GO
Exec sp_alter_column dbo,  BSOPEXDET ,VALUEDESC5 ,VALUEDESC5,'nVarChar(255)','',0
GO
Exec sp_alter_column dbo,  BSOPEXDET ,VALUEDESC3 ,VALUEDESC3,'nVarChar(255)','',0
GO
Exec sp_alter_column dbo,  BSOPEXDET ,VALUEDESC4 ,VALUEDESC4,'nVarChar(255)','',0
GO
Exec sp_alter_column dbo,  BSOPEXDET ,VALUEDESC2 ,VALUEDESC2,'nVarChar(255)','',0
GO
Exec sp_alter_column dbo,  BSTYPE ,DESCRIPTION ,DESCRIPTION,'nVarChar(20)','',0
GO
Exec sp_alter_column dbo,  CArrDetail ,LUserID ,LUserID,'nVarChar(50)','',0
GO
Exec sp_alter_column dbo,  CARRHEADER ,LUserID ,LUserID,'nVarChar(50)','',0
GO
Exec sp_alter_column dbo,  CBatchPrintLogH ,UserID ,UserID,'nVarChar(10)','',0
GO
Exec sp_alter_column dbo,  CBatchPrintLogH ,Description ,Description,'nVarChar(50)','',0
GO
Exec sp_alter_column dbo,  CCTYPE ,Last_Opr ,Last_Opr,'nVarChar(50)','',0
GO
Exec sp_alter_column dbo,  CCTYPE ,Description ,Description,'nVarChar(255)','',0
GO
Exec sp_alter_column dbo,  CDOCLIST ,DESCRIPTION ,DESCRIPTION,'nVarChar(255)','',0
GO
Exec sp_alter_column dbo,  CDOCLIST ,REMARKS ,REMARKS,'nVarChar(512)','',0
GO
Exec sp_alter_column dbo,  CDOCLIST ,LAST_OPR ,LAST_OPR,'nVarChar(50)','',0
GO
Exec sp_alter_column dbo,  CDOCLISTPIC ,Last_Opr ,Last_Opr,'nVarChar(50)','',0
GO
Exec sp_alter_column dbo,  CDOCSTAT ,Last_Opr ,Last_Opr,'nVarChar(50)','',0
GO
Exec sp_alter_column dbo,  CFINDICATORD ,REMARKS ,REMARKS,'nVarChar(255)','',0
GO
Exec sp_alter_column dbo,  CFINDICATORD ,DESCRIPTION ,DESCRIPTION,'nVarChar(255)','',0
GO
Exec sp_alter_column dbo,  CFINDICATORH ,USERID ,USERID,'nVarChar(50)','',0
GO
Exec sp_alter_column dbo,  CFINDICATORH ,LUSERID ,LUSERID,'nVarChar(50)','',0
GO
Exec sp_alter_column dbo,  CFINDICATORH ,AUSERID ,AUSERID,'nVarChar(50)','',0
GO
Exec sp_alter_column dbo,  CFINDICATORH ,CUSERID ,CUSERID,'nVarChar(50)','',0
GO
Exec sp_alter_column dbo,  CFINDICATORH ,PUserID ,PUserID,'nVarChar(50)','',0
GO
Exec sp_alter_column dbo,  CGroup ,Last_Opr ,Last_Opr,'nVarChar(50)','',0
GO
Exec sp_alter_column dbo,  CGroup ,Description ,Description,'nVarChar(100)','',0
GO
Exec sp_alter_column dbo,  Cheque ,BankName ,BankName,'nVarChar(150)','',0
GO
Exec sp_alter_column dbo,  Cheque ,Address ,Address,'nVarChar(1024)','',0
GO
Exec sp_alter_column dbo,  Cheque ,Location ,Location,'nVarChar(10)','',0
GO
Exec sp_alter_column dbo,  Cheque ,Last_Opr ,Last_Opr,'nVarChar(50)','',0
GO
Exec sp_alter_column dbo,  City ,Description_1 ,Description_1,'nVarChar(512)','',0
GO
Exec sp_alter_column dbo,  City ,Last_OPR ,Last_OPR,'nVarChar(10)','',0
GO
Exec sp_alter_column dbo,  City ,Name ,Name,'nVarChar(255)','',0
GO
Exec sp_alter_column dbo,  CLAASS ,REFNAME ,REFNAME,'nVarChar(255)','',0
GO
Exec sp_alter_column dbo,  CLAIM ,Location ,Location,'nVarChar(10)','',0
GO
Exec sp_alter_column dbo,  CLAIM ,UserID ,UserID,'nVarChar(50)','',0
GO
Exec sp_alter_column dbo,  CLAIM ,CUSERID ,CUSERID,'nVarChar(50)','',0
GO
Exec sp_alter_column dbo,  CLAIM ,LUserID ,LUserID,'nVarChar(50)','',0
GO
Exec sp_alter_column dbo,  CLAIM ,PUserID ,PUserID,'nVarChar(50)','',0
GO
Exec sp_alter_column dbo,  CLAIM ,AUserID ,AUserID,'nVarChar(50)','',0
GO
Exec sp_alter_column dbo,  CLAIM ,RequestName ,RequestName,'nVarChar(50)','',0
GO
Exec sp_alter_column dbo,  CLAIM ,SysUserID ,SysUserID,'nVarChar(50)','',0
GO
Exec sp_alter_column dbo,  CLAIM ,ClaimantEmail ,ClaimantEmail,'nVarChar(255)','',0
GO
Exec sp_alter_column dbo,  CLAIM ,RUserID ,RUserID,'nVarChar(50)','',0
GO
Exec sp_alter_column dbo,  CLAIM ,ActionUser ,ActionUser,'nVarChar(50)','',0
GO
Exec sp_alter_column dbo,  CLAIM ,SACAUserID ,SACAUserID,'nVarChar(50)','',0
GO
Exec sp_alter_column dbo,  ClaimantType ,Last_Opr ,Last_Opr,'nVarChar(50)','',0
GO
Exec sp_alter_column dbo,  ClaimantType ,Description ,Description,'nVarChar(255)','',0
GO
Exec sp_alter_column dbo,  ClaimDailyRemarksDetail ,Item ,Item,'nVarChar(100)','',0
GO
Exec sp_alter_column dbo,  ClaimLedger ,Description ,Description,'nVarChar(50)','',0
GO
Exec sp_alter_column dbo,  ClaimPaymentSchedule ,Last_Opr ,Last_Opr,'nVarChar(50)','',0
GO
Exec sp_alter_column dbo,  CLComplaint ,LUserID ,LUserID,'nVarChar(50)','',0
GO
Exec sp_alter_column dbo,  CLComplaint ,ReporterEmail ,ReporterEmail,'nVarChar(255)','',0
GO
Exec sp_alter_column dbo,  CLComplaint ,CUserID ,CUserID,'nVarChar(50)','',0
GO
Exec sp_alter_column dbo,  CLComplaint ,UserID ,UserID,'nVarChar(50)','',0
GO
Exec sp_alter_column dbo,  CLCOST ,RequestMessage ,RequestMessage,'nVarChar(max)','',0
GO
Exec sp_alter_column dbo,  CLCOST ,RequestName ,RequestName,'nVarChar(50)','',0
GO
Exec sp_alter_column dbo,  CLCOST ,Last_Opr ,Last_Opr,'nVarChar(50)','',0
GO
Exec sp_alter_column dbo,  CLCOST ,CUserID ,CUserID,'nVarChar(50)','',0
GO
Exec sp_alter_column dbo,  CLCOST ,AUserID ,AUserID,'nVarChar(50)','',0
GO
Exec sp_alter_column dbo,  CLCOST ,PICEmail ,PICEmail,'nVarChar(255)','',0
GO
Exec sp_alter_column dbo,  CLCOSTDET ,Item ,Item,'nVarChar(50)','',0
GO
Exec sp_alter_column dbo,  CLCOSTDET ,Description ,Description,'nVarChar(255)','',0
GO
Exec sp_alter_column dbo,  CLCOSTPIC ,Remark ,Remark,'nVarChar(max)','',0
GO
Exec sp_alter_column dbo,  CLCOSTPIC ,Last_Opr ,Last_Opr,'nVarChar(50)','',0
GO
Exec sp_alter_column dbo,  CLDED ,Last_Opr ,Last_Opr,'nVarChar(50)','',0
GO
Exec sp_alter_column dbo,  CLDED ,REMARK ,REMARK,'nVarChar(2048)','',0
GO
Exec sp_alter_column dbo,  CLDED ,DESCRIPTION ,DESCRIPTION,'nVarChar(2048)','',0
GO
Exec sp_alter_column dbo,  CLFACDED ,REMARK ,REMARK,'nVarChar(2048)','',0
GO
Exec sp_alter_column dbo,  CLFACDED ,Last_Opr ,Last_Opr,'nVarChar(50)','',0
GO
Exec sp_alter_column dbo,  CLFACDED ,DESCRIPTION ,DESCRIPTION,'nVarChar(2048)','',0
GO
Exec sp_alter_column dbo,  CLFD ,Last_Opr ,Last_Opr,'nVarChar(50)','',0
GO
Exec sp_alter_column dbo,  CLINFO ,Last_Opr ,Last_Opr,'nVarChar(50)','',0
GO
Exec sp_alter_column dbo,  CLINFOSUPL ,Last_Opr ,Last_Opr,'nVarChar(50)','',0
GO
Exec sp_alter_column dbo,  CLINKLOG ,UserID ,UserID,'nVarChar(50)','',0
GO
Exec sp_alter_column dbo,  CLLOSS ,Last_Opr ,Last_Opr,'nVarChar(50)','',0
GO
Exec sp_alter_column dbo,  CLNOTES ,UserID ,UserID,'nVarChar(50)','',0
GO
Exec sp_alter_column dbo,  CLNotify ,UserID ,UserID,'nVarChar(50)','',0
GO
Exec sp_alter_column dbo,  CLNotify ,Last_Opr ,Last_Opr,'nVarChar(50)','',0
GO
Exec sp_alter_column dbo,  CLNStatus ,Last_Opr ,Last_Opr,'nVarChar(50)','',0
GO
Exec sp_alter_column dbo,  CLNStatus ,Description ,Description,'nVarChar(255)','',0
GO
Exec sp_alter_column dbo,  CLPIC ,UserID ,UserID,'nVarChar(50)','',0
GO
Exec sp_alter_column dbo,  CLPIC ,Last_Opr ,Last_Opr,'nVarChar(50)','',0
GO
Exec sp_alter_column dbo,  CLPrintLog ,Description ,Description,'nVarChar(50)','',0
GO
Exec sp_alter_column dbo,  CLPrintLog ,UserID ,UserID,'nVarChar(50)','',0
GO
Exec sp_alter_column dbo,  CLProcess ,Last_Opr ,Last_Opr,'nVarChar(50)','',0
GO
Exec sp_alter_column dbo,  CLSAL ,Last_Opr ,Last_Opr,'nVarChar(50)','',0
GO
Exec sp_alter_column dbo,  CLSALITEM ,Location ,Location,'nVarChar(10)','',0
GO
Exec sp_alter_column dbo,  CLSALITEM ,Last_Opr ,Last_Opr,'nVarChar(50)','',0
GO
Exec sp_alter_column dbo,  CLSub ,PIC_NAME_1 ,PIC_NAME_1,'nVarChar(50)','',0
GO
Exec sp_alter_column dbo,  CLSub ,Last_Opr ,Last_Opr,'nVarChar(50)','',0
GO
Exec sp_alter_column dbo,  CLSub ,PIC_NAME_2 ,PIC_NAME_2,'nVarChar(50)','',0
GO
Exec sp_alter_column dbo,  CLSub ,Name ,Name,'nVarChar(255)','',0
GO
Exec sp_alter_column dbo,  CLSub ,Address_1 ,Address_1,'nVarChar(1024)','',0
GO
Exec sp_alter_column dbo,  CLSub ,Address_2 ,Address_2,'nVarChar(1024)','',0
GO
Exec sp_alter_column dbo,  CLSub ,Address_3 ,Address_3,'nVarChar(1024)','',0
GO
Exec sp_alter_column dbo,  CLSub ,PIC_NAME_3 ,PIC_NAME_3,'nVarChar(50)','',0
GO
Exec sp_alter_column dbo,  CLSUBPIC ,Remark ,Remark,'nVarChar(max)','',0
GO
Exec sp_alter_column dbo,  CLSUBPIC ,Last_Opr ,Last_Opr,'nVarChar(50)','',0
GO
Exec sp_alter_column dbo,  CLSurvey ,Last_Opr ,Last_Opr,'nVarChar(50)','',0
GO
Exec sp_alter_column dbo,  COB ,Last_Opr ,Last_Opr,'nVarChar(50)','',0
GO
Exec sp_alter_column dbo,  COB ,DESCRIPTION ,DESCRIPTION,'nVarChar(50)','',0
GO
Exec sp_alter_column dbo,  COB ,DESCRIPTION_1 ,DESCRIPTION_1,'nVarChar(50)','',0
GO
Exec sp_alter_column dbo,  COBGROUP ,Description ,Description,'nVarChar(255)','',0
GO
Exec sp_alter_column dbo,  COBGROUP ,Last_Opr ,Last_Opr,'nVarChar(50)','',0
GO
Exec sp_alter_column dbo,  COINSURANCE ,LUserID ,LUserID,'nVarChar(50)','',0
GO
Exec sp_alter_column dbo,  COINSURANCE ,USERID ,USERID,'nVarChar(50)','',0
GO
Exec sp_alter_column dbo,  COL ,Last_Opr ,Last_Opr,'nVarChar(50)','',0
GO
Exec sp_alter_column dbo,  COLLATERAL ,LAST_OPR ,LAST_OPR,'nVarChar(50)','',0
GO
Exec sp_alter_column dbo,  COLLATERAL ,DESCRIPTION ,DESCRIPTION,'nVarChar(255)','',0
GO
Exec sp_alter_column dbo,  COLLATERAL ,REMARKS ,REMARKS,'nVarChar(512)','',0
GO
Exec sp_alter_column dbo,  COLLATERAL ,Attrib_1 ,Attrib_1,'nVarChar(100)','',0
GO
Exec sp_alter_column dbo,  COLLATERAL ,Attrib_2 ,Attrib_2,'nVarChar(100)','',0
GO
Exec sp_alter_column dbo,  COLLATERAL ,Attrib_3 ,Attrib_3,'nVarChar(100)','',0
GO
Exec sp_alter_column dbo,  COLLATERAL ,Attrib_4 ,Attrib_4,'nVarChar(100)','',0
GO
Exec sp_alter_column dbo,  COLLATERAL ,Attrib_5 ,Attrib_5,'nVarChar(100)','',0
GO
Exec sp_alter_column dbo,  COLLATERAL ,Attrib_6 ,Attrib_6,'nVarChar(100)','',0
GO
Exec sp_alter_column dbo,  COLLATERAL ,Attrib_7 ,Attrib_7,'nVarChar(100)','',0
GO
Exec sp_alter_column dbo,  COLLATERAL ,Attrib_8 ,Attrib_8,'nVarChar(100)','',0
GO
Exec sp_alter_column dbo,  COLLATERAL ,Attrib_9 ,Attrib_9,'nVarChar(100)','',0
GO
Exec sp_alter_column dbo,  COLLATERAL ,Attrib_10 ,Attrib_10,'nVarChar(100)','',0
GO
Exec sp_alter_column dbo,  COLLATERALPIC ,Remark ,Remark,'nVarChar(max)','',0
GO
Exec sp_alter_column dbo,  COLLATERALPIC ,Last_Opr ,Last_Opr,'nVarChar(50)','',0
GO
Exec sp_alter_column dbo,  COLLATERALSUBTYPE ,Last_Opr ,Last_Opr,'nVarChar(50)','',0
GO
Exec sp_alter_column dbo,  COLLATERALSUBTYPE ,Description ,Description,'nVarChar(255)','',0
GO
Exec sp_alter_column dbo,  COLLATERALTYPE ,Description ,Description,'nVarChar(255)','',0
GO
Exec sp_alter_column dbo,  COLLATERALTYPE ,Last_Opr ,Last_Opr,'nVarChar(50)','',0
GO
Exec sp_alter_column dbo,  CollectionB ,BankName ,BankName,'nVarChar(150)','',0
GO
Exec sp_alter_column dbo,  COLLECTIOND ,AName ,AName,'nVarChar(max)','',0
GO
Exec sp_alter_column dbo,  COLLECTIONH ,Last_Opr ,Last_Opr,'nVarChar(50)','',0
GO
Exec sp_alter_column dbo,  COLLECTIONH ,ContactAddress ,ContactAddress,'nVarChar(255)','',0
GO
Exec sp_alter_column dbo,  COLLRESULT ,Last_Opr ,Last_Opr,'nVarChar(50)','',0
GO
Exec sp_alter_column dbo,  COLLTYPE ,Description ,Description,'nVarChar(255)','',0
GO
Exec sp_alter_column dbo,  CollType_RRule ,Description ,Description,'nVarChar(255)','',0
GO
Exec sp_alter_column dbo,  CollType_RRule ,Last_Opr ,Last_Opr,'nVarChar(50)','',0
GO
Exec sp_alter_column dbo,  COLNOCClass ,Last_Opr ,Last_Opr,'nVarChar(50)','',0
GO
Exec sp_alter_column dbo,  COLTAB ,DESCRIPTION ,DESCRIPTION,'nVarChar(255)','',0
GO
Exec sp_alter_column dbo,  COLTAB ,Last_Opr ,Last_Opr,'nVarChar(50)','',0
GO
Exec sp_alter_column dbo,  ComAcc ,LAST_OPR ,LAST_OPR,'nVarChar(50)','',0
GO
Exec sp_alter_column dbo,  ComAcc ,BankName ,BankName,'nVarChar(255)','',0
GO
Exec sp_alter_column dbo,  ComAcc ,PUserID ,PUserID,'nVarChar(50)','',0
GO
Exec sp_alter_column dbo,  ComAcc ,USERID ,USERID,'nVarChar(50)','',0
GO
Exec sp_alter_column dbo,  ComAcc_Cheque ,Last_Opr ,Last_Opr,'nVarChar(50)','',0
GO
Exec sp_alter_column dbo,  CompanyRelationType ,Description ,Description,'nVarChar(255)','',0
GO
Exec sp_alter_column dbo,  CompanyRelationType ,Last_Opr ,Last_Opr,'nVarChar(50)','',0
GO
Exec sp_alter_column dbo,  ComplaintType ,Description ,Description,'nVarChar(100)','',0
GO
Exec sp_alter_column dbo,  ComplaintType ,Last_Opr ,Last_Opr,'nVarChar(50)','',0
GO
Exec sp_alter_column dbo,  COMPLIANCE ,LAST_OPR ,LAST_OPR,'nVarChar(50)','',0
GO
Exec sp_alter_column dbo,  COMPLIANCEI ,LAST_OPR ,LAST_OPR,'nVarChar(50)','',0
GO
Exec sp_alter_column dbo,  COMPLIANCER ,LAST_OPR ,LAST_OPR,'nVarChar(50)','',0
GO
Exec sp_alter_column dbo,  COMPLIANCES ,SDESCRIPTION ,SDESCRIPTION,'nVarChar(255)','',0
GO
Exec sp_alter_column dbo,  COMPLIANCET ,LAST_OPR ,LAST_OPR,'nVarChar(50)','',0
GO
Exec sp_alter_column dbo,  COMPLIANCEU ,LAST_OPR ,LAST_OPR,'nVarChar(50)','',0
GO
Exec sp_alter_column dbo,  COMPLIANCEUI ,LAST_OPR ,LAST_OPR,'nVarChar(50)','',0
GO
Exec sp_alter_column dbo,  Consent ,Last_OPR ,Last_OPR,'nVarChar(50)','',0
GO
Exec sp_alter_column dbo,  Consent ,Description ,Description,'nVarChar(512)','',0
GO
Exec sp_alter_column dbo,  Country ,Last_Opr ,Last_Opr,'nVarChar(50)','',0
GO
Exec sp_alter_column dbo,  Country ,Description ,Description,'nVarChar(50)','',0
GO
Exec sp_alter_column dbo,  CountryGroup ,Description ,Description,'nVarChar(100)','',0
GO
Exec sp_alter_column dbo,  CountryGroup ,Last_Opr ,Last_Opr,'nVarChar(50)','',0
GO
Exec sp_alter_column dbo,  COVEMPCONTD ,REMARKS ,REMARKS,'nVarChar(255)','',0
GO
Exec sp_alter_column dbo,  COVEMPCONTH ,REMARKS ,REMARKS,'nVarChar(512)','',0
GO
Exec sp_alter_column dbo,  COVEMPCONTH ,USERID ,USERID,'nVarChar(50)','',0
GO
Exec sp_alter_column dbo,  COVEMPCONTH ,LUSERID ,LUSERID,'nVarChar(50)','',0
GO
Exec sp_alter_column dbo,  COVEMPCONTH ,AUSERID ,AUSERID,'nVarChar(50)','',0
GO
Exec sp_alter_column dbo,  COVEMPCONTH ,CUSERID ,CUSERID,'nVarChar(50)','',0
GO
Exec sp_alter_column dbo,  COVEMPCONTH ,PUserID ,PUserID,'nVarChar(50)','',0
GO
Exec sp_alter_column dbo,  COVER ,USERID ,USERID,'nVarChar(50)','',0
GO
Exec sp_alter_column dbo,  COVER ,LUSERID ,LUSERID,'nVarChar(50)','',0
GO
Exec sp_alter_column dbo,  COVER ,AUSERID ,AUSERID,'nVarChar(50)','',0
GO
Exec sp_alter_column dbo,  COVER ,CUSERID ,CUSERID,'nVarChar(50)','',0
GO
Exec sp_alter_column dbo,  COVER ,PUserID ,PUserID,'nVarChar(50)','',0
GO
Exec sp_alter_column dbo,  Cover_Note ,ADDRESS_2 ,ADDRESS_2,'nVarChar(255)','',0
GO
Exec sp_alter_column dbo,  Cover_Note ,VALUEDESC1 ,VALUEDESC1,'nVarChar(255)','',0
GO
Exec sp_alter_column dbo,  Cover_Note ,VALUEDESC3 ,VALUEDESC3,'nVarChar(255)','',0
GO
Exec sp_alter_column dbo,  Cover_Note ,VALUEDESC2 ,VALUEDESC2,'nVarChar(255)','',0
GO
Exec sp_alter_column dbo,  Cover_Note ,LUserID ,LUserID,'nVarChar(10)','',0
GO
Exec sp_alter_column dbo,  Cover_Note ,AName ,AName,'nVarChar(1024)','',0
GO
Exec sp_alter_column dbo,  Cover_Note ,VALUEDESC4 ,VALUEDESC4,'nVarChar(255)','',0
GO
Exec sp_alter_column dbo,  Cover_Note ,CONSIGNEE_ADDRESS ,CONSIGNEE_ADDRESS,'nVarChar(255)','',0
GO
Exec sp_alter_column dbo,  Cover_Note ,INTERESTREMARK ,INTERESTREMARK,'nVarChar(1024)','',0
GO
Exec sp_alter_column dbo,  Cover_Note ,VALUEDESC15 ,VALUEDESC15,'nVarChar(255)','',0
GO
Exec sp_alter_column dbo,  Cover_Note ,Address ,Address,'nVarChar(255)','',0
GO
Exec sp_alter_column dbo,  Cover_Note ,SurveyAgentName ,SurveyAgentName,'nVarChar(255)','',0
GO
Exec sp_alter_column dbo,  Cover_Note ,VESSELNAME ,VESSELNAME,'nVarChar(255)','',0
GO
Exec sp_alter_column dbo,  Cover_Note ,VALUEDESC10 ,VALUEDESC10,'nVarChar(255)','',0
GO
Exec sp_alter_column dbo,  Cover_Note ,VALUEDESC11 ,VALUEDESC11,'nVarChar(255)','',0
GO
Exec sp_alter_column dbo,  Cover_Note ,VALUEDESC13 ,VALUEDESC13,'nVarChar(255)','',0
GO
Exec sp_alter_column dbo,  Cover_Note ,VALUEDESC ,VALUEDESC,'nVarChar(255)','',0
GO
Exec sp_alter_column dbo,  Cover_Note ,VALUEDESC12 ,VALUEDESC12,'nVarChar(255)','',0
GO
Exec sp_alter_column dbo,  Cover_Note ,VALUEDESC14 ,VALUEDESC14,'nVarChar(255)','',0
GO
Exec sp_alter_column dbo,  Cover_Note ,VALUEDESC5 ,VALUEDESC5,'nVarChar(255)','',0
GO
Exec sp_alter_column dbo,  Cover_Note ,VALUEDESC6 ,VALUEDESC6,'nVarChar(255)','',0
GO
Exec sp_alter_column dbo,  Cover_Note ,VALUEDESC8 ,VALUEDESC8,'nVarChar(255)','',0
GO
Exec sp_alter_column dbo,  Cover_Note ,VALUEDESC7 ,VALUEDESC7,'nVarChar(255)','',0
GO
Exec sp_alter_column dbo,  Cover_Note ,ADDRESS_3 ,ADDRESS_3,'nVarChar(255)','',0
GO
Exec sp_alter_column dbo,  Cover_Note ,VALUEDESC9 ,VALUEDESC9,'nVarChar(255)','',0
GO
Exec sp_alter_column dbo,  CoverNote_SI ,Description ,Description,'nVarChar(1024)','',0
GO
Exec sp_alter_column dbo,  CoverNote_Transhipment ,VesselName ,VesselName,'nVarChar(150)','',0
GO
Exec sp_alter_column dbo,  CPrintLog ,Description ,Description,'nVarChar(50)','',0
GO
Exec sp_alter_column dbo,  CPrintLog ,UserID ,UserID,'nVarChar(50)','',0
GO
Exec sp_alter_column dbo,  CPrintLogH ,Description ,Description,'nVarChar(50)','',0
GO
Exec sp_alter_column dbo,  CPrintLogH ,UserID ,UserID,'nVarChar(10)','',0
GO
Exec sp_alter_column dbo,  CSTALLOCATIONH ,Last_Opr ,Last_Opr,'nVarChar(50)','',0
GO
Exec sp_alter_column dbo,  CSType ,Last_Opr ,Last_Opr,'nVarChar(50)','',0
GO
Exec sp_alter_column dbo,  CSType ,Description ,Description,'nVarChar(255)','',0
GO
Exec sp_alter_column dbo,  CT ,Last_Opr ,Last_Opr,'nVarChar(50)','',0
GO
Exec sp_alter_column dbo,  CT ,Description ,Description,'nVarChar(50)','',0
GO
Exec sp_alter_column dbo,  Currency ,Description ,Description,'nVarChar(50)','',0
GO
Exec sp_alter_column dbo,  Currency ,Last_Opr ,Last_Opr,'nVarChar(50)','',0
GO
Exec sp_alter_column dbo,  DConvD ,FName ,FName,'nVarChar(50)','',0
GO
Exec sp_alter_column dbo,  DConvH ,Description ,Description,'nVarChar(50)','',0
GO
Exec sp_alter_column dbo,  DebtorGroup ,Description ,Description,'nVarChar(255)','',0
GO
Exec sp_alter_column dbo,  DebtorGroup ,Last_Opr ,Last_Opr,'nVarChar(50)','',0
GO
Exec sp_alter_column dbo,  DEDTAB ,REMARKS ,REMARKS,'nVarChar(2048)','',0
GO
Exec sp_alter_column dbo,  DEDTAB ,REMARKS_1 ,REMARKS_1,'nVarChar(2048)','',0
GO
Exec sp_alter_column dbo,  DEDTAB ,Last_Opr ,Last_Opr,'nVarChar(50)','',0
GO
Exec sp_alter_column dbo,  DefCLA ,SHORTDESC ,SHORTDESC,'nVarChar(max)','',0
GO
Exec sp_alter_column dbo,  DefCLA ,ShortDesc_1 ,ShortDesc_1,'nVarChar(max)','',0
GO
Exec sp_alter_column dbo,  DefCON ,SHORTDESC ,SHORTDESC,'nVarChar(max)','',0
GO
Exec sp_alter_column dbo,  DefCON ,ShortDesc_1 ,ShortDesc_1,'nVarChar(max)','',0
GO
Exec sp_alter_column dbo,  DefEX ,SHORTDESC ,SHORTDESC,'nVarChar(max)','',0
GO
Exec sp_alter_column dbo,  DefEX ,ShortDesc_1 ,ShortDesc_1,'nVarChar(max)','',0
GO
Exec sp_alter_column dbo,  DelAdd ,ADDRESS ,ADDRESS,'nVarChar(255)','',0
GO
Exec sp_alter_column dbo,  Department ,Description ,Description,'nVarChar(255)','',0
GO
Exec sp_alter_column dbo,  Department ,Last_Opr ,Last_Opr,'nVarChar(50)','',0
GO
Exec sp_alter_column dbo,  Deposit ,LUserID ,LUserID,'nVarChar(50)','',0
GO
Exec sp_alter_column dbo,  Deposit ,AUserID ,AUserID,'nVarChar(50)','',0
GO
Exec sp_alter_column dbo,  Deposit ,CUserID ,CUserID,'nVarChar(50)','',0
GO
Exec sp_alter_column dbo,  DepositRecovery ,Remarks ,Remarks,'nVarChar(255)','',0
GO
Exec sp_alter_column dbo,  Diagnosis ,Name ,Name,'nVarChar(255)','',0
GO
Exec sp_alter_column dbo,  Diagnosis ,Last_Opr ,Last_Opr,'nVarChar(10)','',0
GO
Exec sp_alter_column dbo,  DISTAB ,DESCRIPTION ,DESCRIPTION,'nVarChar(255)','',0
GO
Exec sp_alter_column dbo,  DISTAB ,Last_Opr ,Last_Opr,'nVarChar(50)','',0
GO
Exec sp_alter_column dbo,  District ,Last_OPR ,Last_OPR,'nVarChar(10)','',0
GO
Exec sp_alter_column dbo,  Division ,Last_Opr ,Last_Opr,'nVarChar(50)','',0
GO
Exec sp_alter_column dbo,  Division ,Description ,Description,'nVarChar(255)','',0
GO
Exec sp_alter_column dbo,  DOCLIST ,DESCRIPTION ,DESCRIPTION,'nVarChar(255)','',0
GO
Exec sp_alter_column dbo,  DocStat ,Description ,Description,'nVarChar(100)','',0
GO
Exec sp_alter_column dbo,  DocStat ,Last_Opr ,Last_Opr,'nVarChar(50)','',0
GO
Exec sp_alter_column dbo,  DOCTYPE ,DESCRIPTION ,DESCRIPTION,'nVarChar(255)','',0
GO
Exec sp_alter_column dbo,  DOCTYPE ,Last_Opr ,Last_Opr,'nVarChar(50)','',0
GO
Exec sp_alter_column dbo,  DType ,Description ,Description,'nVarChar(255)','',0
GO
Exec sp_alter_column dbo,  DType ,Last_Opr ,Last_Opr,'nVarChar(50)','',0
GO
Exec sp_alter_column dbo,  Due_Date ,Name ,Name,'nVarChar(50)','',0
GO
Exec sp_alter_column dbo,  ECUTYPE ,Description ,Description,'nVarChar(512)','',0
GO
Exec sp_alter_column dbo,  EIS_HEADER ,Last_OPR ,Last_OPR,'nVarChar(50)','',0
GO
Exec sp_alter_column dbo,  EIS_HEADER ,Description ,Description,'nVarChar(255)','',0
GO
Exec sp_alter_column dbo,  EIS_Profile ,Last_OPR ,Last_OPR,'nVarChar(50)','',0
GO
Exec sp_alter_column dbo,  Email_Accumulation_Address ,EmailAddress ,EmailAddress,'nVarChar(255)','',0
GO
Exec sp_alter_column dbo,  Email_Notification_Address ,EmailAddress ,EmailAddress,'nVarChar(255)','',0
GO
Exec sp_alter_column dbo,  Email_Parameter ,EmailSender ,EmailSender,'nVarChar(255)','',0
GO
Exec sp_alter_column dbo,  Email_Parameter ,AssuredName ,AssuredName,'nVarChar(255)','',0
GO
Exec sp_alter_column dbo,  EMPLOYMENT ,Last_Opr ,Last_Opr,'nVarChar(50)','',0
GO
Exec sp_alter_column dbo,  EMPLOYMENT ,Description ,Description,'nVarChar(255)','',0
GO
Exec sp_alter_column dbo,  EncryptField ,ControlName ,ControlName,'nVarChar(255)','',0
GO
Exec sp_alter_column dbo,  EncryptField ,FormName ,FormName,'nVarChar(255)','',0
GO
Exec sp_alter_column dbo,  EncryptField ,LUserID ,LUserID,'nVarChar(50)','',0
GO
Exec sp_alter_column dbo,  EncryptField ,FieldName ,FieldName,'nVarChar(255)','',0
GO
Exec sp_alter_column dbo,  EUnit ,REMARK ,REMARK,'nVarChar(100)','',0
GO
Exec sp_alter_column dbo,  EUnit ,DESCRIPTION ,DESCRIPTION,'nVarChar(100)','',0
GO
Exec sp_alter_column dbo,  EUnit ,REMARK_1 ,REMARK_1,'nVarChar(100)','',0
GO
Exec sp_alter_column dbo,  EUnit ,DESCRIPTION_1 ,DESCRIPTION_1,'nVarChar(100)','',0
GO
Exec sp_alter_column dbo,  Event ,Last_Opr ,Last_Opr,'nVarChar(50)','',0
GO
Exec sp_alter_column dbo,  Event ,Location ,Location,'nVarChar(10)','',0
GO
Exec sp_alter_column dbo,  Excel ,Excel_Name ,Excel_Name,'nVarChar(100)','',0
GO
Exec sp_alter_column dbo,  Excel ,Description ,Description,'nVarChar(250)','',0
GO
Exec sp_alter_column dbo,  Excel ,Last_Opr ,Last_Opr,'nVarChar(50)','',0
GO
Exec sp_alter_column dbo,  Exchange ,Last_Opr ,Last_Opr,'nVarChar(50)','',0
GO
Exec sp_alter_column dbo,  FACCLA ,ShortDesc_1 ,ShortDesc_1,'nVarChar(max)','',0
GO
Exec sp_alter_column dbo,  FACCLA ,SHORTDESC ,SHORTDESC,'nVarChar(max)','',0
GO
Exec sp_alter_column dbo,  FACCON ,SHORTDESC ,SHORTDESC,'nVarChar(max)','',0
GO
Exec sp_alter_column dbo,  FACCON ,ShortDesc_1 ,ShortDesc_1,'nVarChar(max)','',0
GO
Exec sp_alter_column dbo,  FACEX ,ShortDesc_1 ,ShortDesc_1,'nVarChar(max)','',0
GO
Exec sp_alter_column dbo,  FACEX ,SHORTDESC ,SHORTDESC,'nVarChar(max)','',0
GO
Exec sp_alter_column dbo,  FACPIC ,Remark ,Remark,'nVarChar(max)','',0
GO
Exec sp_alter_column dbo,  FACPIC ,UserID ,UserID,'nVarChar(50)','',0
GO
Exec sp_alter_column dbo,  FACPIC ,Last_Opr ,Last_Opr,'nVarChar(50)','',0
GO
Exec sp_alter_column dbo,  FANOTES ,UserID ,UserID,'nVarChar(50)','',0
GO
Exec sp_alter_column dbo,  FDEDUCTIBLE ,REMARKS ,REMARKS,'nVarChar(2048)','',0
GO
Exec sp_alter_column dbo,  FDEDUCTIBLE ,REMARKS_1 ,REMARKS_1,'nVarChar(2048)','',0
GO
Exec sp_alter_column dbo,  FDTAB ,DESCRIPTION ,DESCRIPTION,'nVarChar(50)','',0
GO
Exec sp_alter_column dbo,  FDTAB ,Last_Opr ,Last_Opr,'nVarChar(50)','',0
GO
Exec sp_alter_column dbo,  FDTABDET ,Last_Opr ,Last_Opr,'nVarChar(50)','',0
GO
Exec sp_alter_column dbo,  FINDICATOR ,LAST_OPR ,LAST_OPR,'nVarChar(50)','',0
GO
Exec sp_alter_column dbo,  FINDICATOR ,DESCRIPTION ,DESCRIPTION,'nVarChar(255)','',0
GO
Exec sp_alter_column dbo,  FINDICATORI ,LAST_OPR ,LAST_OPR,'nVarChar(50)','',0
GO
Exec sp_alter_column dbo,  FINDICATORR ,DESCRIPTION ,DESCRIPTION,'nVarChar(255)','',0
GO
Exec sp_alter_column dbo,  FINDICATORR ,SPNAME ,SPNAME,'nVarChar(255)','',0
GO
Exec sp_alter_column dbo,  FINDICATORR ,LAST_OPR ,LAST_OPR,'nVarChar(50)','',0
GO
Exec sp_alter_column dbo,  FINDICATORT ,LAST_OPR ,LAST_OPR,'nVarChar(50)','',0
GO
Exec sp_alter_column dbo,  FINDICATORU ,LAST_OPR ,LAST_OPR,'nVarChar(50)','',0
GO
Exec sp_alter_column dbo,  FINDICATORUI ,LAST_OPR ,LAST_OPR,'nVarChar(50)','',0
GO
Exec sp_alter_column dbo,  FLScaleTab ,Last_Opr ,Last_Opr,'nVarChar(50)','',0
GO
Exec sp_alter_column dbo,  FSAMAPPING ,TBName ,TBName,'nVarChar(50)','',0
GO
Exec sp_alter_column dbo,  FSAMAPPING ,FSADESCRIPTION ,FSADESCRIPTION,'nVarChar(255)','',0
GO
Exec sp_alter_column dbo,  FSAMappingIDRef ,Description ,Description,'nVarChar(255)','',0
GO
Exec sp_alter_column dbo,  GENCLA ,SHORTDESC ,SHORTDESC,'nVarChar(max)','',0
GO
Exec sp_alter_column dbo,  GENCLA ,ShortDesc_1 ,ShortDesc_1,'nVarChar(max)','',0
GO
Exec sp_alter_column dbo,  GENCON ,ShortDesc_1 ,ShortDesc_1,'nVarChar(max)','',0
GO
Exec sp_alter_column dbo,  GENCON ,SHORTDESC ,SHORTDESC,'nVarChar(max)','',0
GO
Exec sp_alter_column dbo,  GENDER ,DESCRIPTION ,DESCRIPTION,'nVarChar(50)','',0
GO
Exec sp_alter_column dbo,  GENDTAB ,Last_Opr ,Last_Opr,'nVarChar(50)','',0
GO
Exec sp_alter_column dbo,  GENEX ,SHORTDESC ,SHORTDESC,'nVarChar(max)','',0
GO
Exec sp_alter_column dbo,  GENEX ,ShortDesc_1 ,ShortDesc_1,'nVarChar(max)','',0
GO
Exec sp_alter_column dbo,  GENHTAB ,Last_Opr ,Last_Opr,'nVarChar(50)','',0
GO
Exec sp_alter_column dbo,  GL_AuditH ,Description ,Description,'nVarChar(50)','',0
GO
Exec sp_alter_column dbo,  GL_AuditH ,Last_Opr ,Last_Opr,'nVarChar(50)','',0
GO
Exec sp_alter_column dbo,  GL_FiscalH ,Last_Opr ,Last_Opr,'nVarChar(50)','',0
GO
Exec sp_alter_column dbo,  GL_FiscalH ,Description ,Description,'nVarChar(50)','',0
GO
Exec sp_alter_column dbo,  GLPrintLogH ,Description ,Description,'nVarChar(50)','',0
GO
Exec sp_alter_column dbo,  GLPrintLogH ,UserID ,UserID,'nVarChar(10)','',0
GO
Exec sp_alter_column dbo,  GNOTES ,Last_Opr ,Last_Opr,'nVarChar(10)','',0
GO
Exec sp_alter_column dbo,  GNOTES ,Description ,Description,'nVarChar(2000)','',0
GO
Exec sp_alter_column dbo,  HBizMap ,Description16 ,Description16,'nVarChar(255)','',0
GO
Exec sp_alter_column dbo,  HBizMap ,Description18 ,Description18,'nVarChar(255)','',0
GO
Exec sp_alter_column dbo,  HBizMap ,Description19 ,Description19,'nVarChar(255)','',0
GO
Exec sp_alter_column dbo,  HBizMap ,Description20 ,Description20,'nVarChar(255)','',0
GO
Exec sp_alter_column dbo,  HBizMap ,Description21 ,Description21,'nVarChar(255)','',0
GO
Exec sp_alter_column dbo,  HBizMap ,Description15 ,Description15,'nVarChar(255)','',0
GO
Exec sp_alter_column dbo,  HBizMap ,Description14 ,Description14,'nVarChar(255)','',0
GO
Exec sp_alter_column dbo,  HBizMap ,Description17 ,Description17,'nVarChar(255)','',0
GO
Exec sp_alter_column dbo,  HBizMap ,Description13 ,Description13,'nVarChar(255)','',0
GO
Exec sp_alter_column dbo,  HBizMap ,Description12 ,Description12,'nVarChar(255)','',0
GO
Exec sp_alter_column dbo,  HBizMap ,Description11 ,Description11,'nVarChar(255)','',0
GO
Exec sp_alter_column dbo,  HBizMap ,Description30 ,Description30,'nVarChar(255)','',0
GO
Exec sp_alter_column dbo,  HBizMap ,Description9 ,Description9,'nVarChar(255)','',0
GO
Exec sp_alter_column dbo,  HBizMap ,Description10 ,Description10,'nVarChar(255)','',0
GO
Exec sp_alter_column dbo,  HBizMap ,Last_Opr ,Last_Opr,'nVarChar(10)','',0
GO
Exec sp_alter_column dbo,  HBizMap ,Description29 ,Description29,'nVarChar(255)','',0
GO
Exec sp_alter_column dbo,  HBizMap ,Description28 ,Description28,'nVarChar(255)','',0
GO
Exec sp_alter_column dbo,  HBizMap ,Description8 ,Description8,'nVarChar(255)','',0
GO
Exec sp_alter_column dbo,  HBizMap ,Description7 ,Description7,'nVarChar(255)','',0
GO
Exec sp_alter_column dbo,  HBizMap ,Description6 ,Description6,'nVarChar(255)','',0
GO
Exec sp_alter_column dbo,  HBizMap ,Description27 ,Description27,'nVarChar(255)','',0
GO
Exec sp_alter_column dbo,  HBizMap ,Description1 ,Description1,'nVarChar(255)','',0
GO
Exec sp_alter_column dbo,  HBizMap ,Description22 ,Description22,'nVarChar(255)','',0
GO
Exec sp_alter_column dbo,  HBizMap ,Description2 ,Description2,'nVarChar(255)','',0
GO
Exec sp_alter_column dbo,  HBizMap ,Description24 ,Description24,'nVarChar(255)','',0
GO
Exec sp_alter_column dbo,  HBizMap ,Description3 ,Description3,'nVarChar(255)','',0
GO
Exec sp_alter_column dbo,  HBizMap ,Description5 ,Description5,'nVarChar(255)','',0
GO
Exec sp_alter_column dbo,  HBizMap ,Description26 ,Description26,'nVarChar(255)','',0
GO
Exec sp_alter_column dbo,  HBizMap ,Description23 ,Description23,'nVarChar(255)','',0
GO
Exec sp_alter_column dbo,  HBizMap ,Description25 ,Description25,'nVarChar(255)','',0
GO
Exec sp_alter_column dbo,  HBizMap ,Description4 ,Description4,'nVarChar(255)','',0
GO
Exec sp_alter_column dbo,  HCard ,Last_Opr ,Last_Opr,'nVarChar(50)','',0
GO
Exec sp_alter_column dbo,  HCard ,CardName ,CardName,'nVarChar(50)','',0
GO
Exec sp_alter_column dbo,  HCard_Detail ,LocationID ,LocationID,'nVarChar(10)','',0
GO
Exec sp_alter_column dbo,  HCardTransfer ,LocationFrom ,LocationFrom,'nVarChar(10)','',0
GO
Exec sp_alter_column dbo,  HCardTransfer ,LocationTo ,LocationTo,'nVarChar(10)','',0
GO
Exec sp_alter_column dbo,  HCardTransfer_Detail ,Remarks ,Remarks,'nVarChar(225)','',0
GO
Exec sp_alter_column dbo,  HDeliveryOrder ,LocationID ,LocationID,'nVarChar(10)','',0
GO
Exec sp_alter_column dbo,  HDOPrintLogH ,Description ,Description,'nVarChar(500)','',0
GO
Exec sp_alter_column dbo,  HDOPrintLogH ,UserID ,UserID,'nVarChar(50)','',0
GO
Exec sp_alter_column dbo,  HEALTH_PendingTable ,Remarks ,Remarks,'nVarChar(255)','',0
GO
Exec sp_alter_column dbo,  HEALTH_SysLOG ,Remarks ,Remarks,'nVarChar(255)','',0
GO
Exec sp_alter_column dbo,  HEALTH_SysLOG ,UserID ,UserID,'nVarChar(10)','',0
GO
Exec sp_alter_column dbo,  HEALTH_SysLOG ,PROCNAME ,PROCNAME,'nVarChar(50)','',0
GO
Exec sp_alter_column dbo,  HEALTH_SysRequest ,LUserID ,LUserID,'nVarChar(10)','',0
GO
Exec sp_alter_column dbo,  HEALTH_SysRequest ,UserID ,UserID,'nVarChar(10)','',0
GO
Exec sp_alter_column dbo,  HEALTH_SysRequest ,Remarks ,Remarks,'nVarChar(255)','',0
GO
Exec sp_alter_column dbo,  HEALTH_SysRequest ,ProcName ,ProcName,'nVarChar(50)','',0
GO
Exec sp_alter_column dbo,  HEmail_Log ,EmailTime ,EmailTime,'nVarChar(8)','',0
GO
Exec sp_alter_column dbo,  HEmail_Rule ,Last_Opr ,Last_Opr,'nVarChar(50)','',0
GO
Exec sp_alter_column dbo,  HGroupSize ,Description ,Description,'nVarChar(50)','',0
GO
Exec sp_alter_column dbo,  HGroupSize ,Last_Opr ,Last_Opr,'nVarChar(10)','',0
GO
Exec sp_alter_column dbo,  HInsurance ,Name ,Name,'nVarChar(50)','',0
GO
Exec sp_alter_column dbo,  HInsurance ,Last_Opr ,Last_Opr,'nVarChar(10)','',0
GO
Exec sp_alter_column dbo,  Hint ,Last_Opr ,Last_Opr,'nVarChar(50)','',0
GO
Exec sp_alter_column dbo,  HLoading ,Last_Opr ,Last_Opr,'nVarChar(10)','',0
GO
Exec sp_alter_column dbo,  HLoading ,Description ,Description,'nVarChar(50)','',0
GO
Exec sp_alter_column dbo,  HLoading_Ext ,Last_Opr ,Last_Opr,'nVarChar(10)','',0
GO
Exec sp_alter_column dbo,  HLoading_Ext ,Description ,Description,'nVarChar(50)','',0
GO
Exec sp_alter_column dbo,  HLoading_Ext_LOB ,Last_Opr ,Last_Opr,'nVarChar(10)','',0
GO
Exec sp_alter_column dbo,  HLOB ,Description ,Description,'nVarChar(50)','',0
GO
Exec sp_alter_column dbo,  HLOB ,Last_Opr ,Last_Opr,'nVarChar(10)','',0
GO
Exec sp_alter_column dbo,  HLocation ,Last_Opr ,Last_Opr,'nVarChar(50)','',0
GO
Exec sp_alter_column dbo,  HLocation ,LocationID ,LocationID,'nVarChar(10)','',0
GO
Exec sp_alter_column dbo,  HLocation ,LocationDesc ,LocationDesc,'nVarChar(50)','',0
GO
Exec sp_alter_column dbo,  HNOP ,Last_Opr ,Last_Opr,'nVarChar(10)','',0
GO
Exec sp_alter_column dbo,  HNOP ,Description ,Description,'nVarChar(50)','',0
GO
Exec sp_alter_column dbo,  HOccupation ,Last_Opr ,Last_Opr,'nVarChar(10)','',0
GO
Exec sp_alter_column dbo,  HOccupation ,Name ,Name,'nVarChar(50)','',0
GO
Exec sp_alter_column dbo,  HOccupation ,Description ,Description,'nVarChar(50)','',0
GO
Exec sp_alter_column dbo,  Holiday ,Last_Opr ,Last_Opr,'nVarChar(10)','',0
GO
Exec sp_alter_column dbo,  Holiday ,Name ,Name,'nVarChar(50)','',0
GO
Exec sp_alter_column dbo,  HospitalCode ,Last_Opr ,Last_Opr,'nVarChar(50)','',0
GO
Exec sp_alter_column dbo,  HPayment_Ext ,Remarks ,Remarks,'nVarChar(1000)','',0
GO
Exec sp_alter_column dbo,  HPaymentPrintLogH ,Description ,Description,'nVarChar(500)','',0
GO
Exec sp_alter_column dbo,  HPaymentPrintLogH ,UserID ,UserID,'nVarChar(50)','',0
GO
Exec sp_alter_column dbo,  HPolicyNotes ,Description_1 ,Description_1,'nVarChar(2000)','',0
GO
Exec sp_alter_column dbo,  HPolicyNotes ,Description ,Description,'nVarChar(2000)','',0
GO
Exec sp_alter_column dbo,  HPolicyNotes ,Last_Opr ,Last_Opr,'nVarChar(10)','',0
GO
Exec sp_alter_column dbo,  HPOPrintLogH ,Description ,Description,'nVarChar(500)','',0
GO
Exec sp_alter_column dbo,  HPOPrintLogH ,UserID ,UserID,'nVarChar(50)','',0
GO
Exec sp_alter_column dbo,  HProviderLevel ,Last_Opr ,Last_Opr,'nVarChar(10)','',0
GO
Exec sp_alter_column dbo,  HProviderLevel ,Description ,Description,'nVarChar(50)','',0
GO
Exec sp_alter_column dbo,  HPurchaseOrder_Document ,FileName ,FileName,'nVarChar(255)','',0
GO
Exec sp_alter_column dbo,  HPurchaseOrder_Document ,Description ,Description,'nVarChar(50)','',0
GO
Exec sp_alter_column dbo,  HRegion ,Last_Opr ,Last_Opr,'nVarChar(10)','',0
GO
Exec sp_alter_column dbo,  HRegion ,Description ,Description,'nVarChar(50)','',0
GO
Exec sp_alter_column dbo,  HRoom ,Last_Opr ,Last_Opr,'nVarChar(50)','',0
GO
Exec sp_alter_column dbo,  HRoom ,Description ,Description,'nVarChar(500)','',0
GO
Exec sp_alter_column dbo,  HSCode ,Description ,Description,'nVarChar(255)','',0
GO
Exec sp_alter_column dbo,  HSCode ,Last_Opr ,Last_Opr,'nVarChar(50)','',0
GO
Exec sp_alter_column dbo,  HSMS_Rule ,Description ,Description,'nVarChar(50)','',0
GO
Exec sp_alter_column dbo,  HSMS_Rule ,Last_Opr ,Last_Opr,'nVarChar(10)','',0
GO
Exec sp_alter_column dbo,  HSOPrintLogH ,StockOpnameNo ,StockOpnameNo,'nVarChar(50)','',0
GO
Exec sp_alter_column dbo,  HSOPrintLogH ,Description ,Description,'nVarChar(500)','',0
GO
Exec sp_alter_column dbo,  HSOPrintLogH ,UserID ,UserID,'nVarChar(50)','',0
GO
Exec sp_alter_column dbo,  HStockOpname ,StockOpnameNo ,StockOpnameNo,'nVarChar(50)','',0
GO
Exec sp_alter_column dbo,  HStockOpname_Ext ,LocationID ,LocationID,'nVarChar(10)','',0
GO
Exec sp_alter_column dbo,  HStockOpname_Ext ,StockOpnameNo ,StockOpnameNo,'nVarChar(50)','',0
GO
Exec sp_alter_column dbo,  HSupplier ,SupplierName ,SupplierName,'nVarChar(50)','',0
GO
Exec sp_alter_column dbo,  HSupplier ,Address ,Address,'nVarChar(500)','',0
GO
Exec sp_alter_column dbo,  HSupplier ,Last_Opr ,Last_Opr,'nVarChar(10)','',0
GO
Exec sp_alter_column dbo,  ICOVER ,LUserID ,LUserID,'nVarChar(50)','',0
GO
Exec sp_alter_column dbo,  ICOVERPOL ,LUserID ,LUserID,'nVarChar(5)','',0
GO
Exec sp_alter_column dbo,  ICR_Master ,MainRateRemark ,MainRateRemark,'nVarChar(512)','',0
GO
Exec sp_alter_column dbo,  ICR_Master ,MainInterestRemark ,MainInterestRemark,'nVarChar(512)','',0
GO
Exec sp_alter_column dbo,  ICR_Master ,MainExtInterestRemark ,MainExtInterestRemark,'nVarChar(512)','',0
GO
Exec sp_alter_column dbo,  ICR_Master ,MainDeductibleRemark ,MainDeductibleRemark,'nVarChar(255)','',0
GO
Exec sp_alter_column dbo,  ICR_Master ,AddRateRemark_1 ,AddRateRemark_1,'nVarChar(512)','',0
GO
Exec sp_alter_column dbo,  ICR_Master ,AddInterestRemark_1 ,AddInterestRemark_1,'nVarChar(512)','',0
GO
Exec sp_alter_column dbo,  ICR_Master ,AddDeductibleRemark_1 ,AddDeductibleRemark_1,'nVarChar(255)','',0
GO
Exec sp_alter_column dbo,  ICR_Master ,AddRateRemark_2 ,AddRateRemark_2,'nVarChar(512)','',0
GO
Exec sp_alter_column dbo,  ICR_Master ,AddInterestRemark_2 ,AddInterestRemark_2,'nVarChar(512)','',0
GO
Exec sp_alter_column dbo,  ICR_Master ,AddDeductibleRemark_2 ,AddDeductibleRemark_2,'nVarChar(255)','',0
GO
Exec sp_alter_column dbo,  ICR_Master ,AddRateRemark_3 ,AddRateRemark_3,'nVarChar(512)','',0
GO
Exec sp_alter_column dbo,  ICR_Master ,AddInterestRemark_3 ,AddInterestRemark_3,'nVarChar(512)','',0
GO
Exec sp_alter_column dbo,  ICR_Master ,AddDeductibleRemark_3 ,AddDeductibleRemark_3,'nVarChar(255)','',0
GO
Exec sp_alter_column dbo,  ICR_Master ,AddRateRemark_4 ,AddRateRemark_4,'nVarChar(512)','',0
GO
Exec sp_alter_column dbo,  ICR_Master ,AddInterestRemark_4 ,AddInterestRemark_4,'nVarChar(512)','',0
GO
Exec sp_alter_column dbo,  ICR_Master ,AddDeductibleRemark_4 ,AddDeductibleRemark_4,'nVarChar(255)','',0
GO
Exec sp_alter_column dbo,  ICR_Master ,AddRateRemark_5 ,AddRateRemark_5,'nVarChar(512)','',0
GO
Exec sp_alter_column dbo,  ICR_Master ,AddInterestRemark_5 ,AddInterestRemark_5,'nVarChar(512)','',0
GO
Exec sp_alter_column dbo,  ICR_Master ,AddDeductibleRemark_5 ,AddDeductibleRemark_5,'nVarChar(255)','',0
GO
Exec sp_alter_column dbo,  ICR_Master ,AddRateRemark_6 ,AddRateRemark_6,'nVarChar(512)','',0
GO
Exec sp_alter_column dbo,  ICR_Master ,AddInterestRemark_6 ,AddInterestRemark_6,'nVarChar(512)','',0
GO
Exec sp_alter_column dbo,  ICR_Master ,AddDeductibleRemark_6 ,AddDeductibleRemark_6,'nVarChar(255)','',0
GO
Exec sp_alter_column dbo,  ICR_Master ,AddRateRemark_7 ,AddRateRemark_7,'nVarChar(512)','',0
GO
Exec sp_alter_column dbo,  ICR_Master ,AddInterestRemark_7 ,AddInterestRemark_7,'nVarChar(512)','',0
GO
Exec sp_alter_column dbo,  ICR_Master ,AddDeductibleRemark_7 ,AddDeductibleRemark_7,'nVarChar(255)','',0
GO
Exec sp_alter_column dbo,  ICR_Master ,AddRateRemark_8 ,AddRateRemark_8,'nVarChar(512)','',0
GO
Exec sp_alter_column dbo,  ICR_Master ,AddInterestRemark_8 ,AddInterestRemark_8,'nVarChar(512)','',0
GO
Exec sp_alter_column dbo,  ICR_Master ,AddDeductibleRemark_8 ,AddDeductibleRemark_8,'nVarChar(255)','',0
GO
Exec sp_alter_column dbo,  ICR_Transaction ,PHolder_ContactAddress ,PHolder_ContactAddress,'nVarChar(255)','',0
GO
Exec sp_alter_column dbo,  ICR_Transaction ,Insured_ContactAddress ,Insured_ContactAddress,'nVarChar(255)','',0
GO
Exec sp_alter_column dbo,  ICR_Transaction ,USERID ,USERID,'nVarChar(50)','',0
GO
Exec sp_alter_column dbo,  ICR_Transaction ,LUserID ,LUserID,'nVarChar(50)','',0
GO
Exec sp_alter_column dbo,  ICR_Transaction ,Payor_Address_3 ,Payor_Address_3,'nVarChar(255)','',0
GO
Exec sp_alter_column dbo,  ICR_Transaction ,PHolder_Address_3 ,PHolder_Address_3,'nVarChar(255)','',0
GO
Exec sp_alter_column dbo,  ICR_Transaction ,DCode_Remark_4 ,DCode_Remark_4,'nVarChar(255)','',0
GO
Exec sp_alter_column dbo,  ICR_Transaction ,DCode_Remark_1 ,DCode_Remark_1,'nVarChar(255)','',0
GO
Exec sp_alter_column dbo,  ICR_Transaction ,PHolder_Name ,PHolder_Name,'nVarChar(255)','',0
GO
Exec sp_alter_column dbo,  ICR_Transaction ,Insured_EMail ,Insured_EMail,'nVarChar(255)','',0
GO
Exec sp_alter_column dbo,  ICR_Transaction ,DCode_Remark_3 ,DCode_Remark_3,'nVarChar(255)','',0
GO
Exec sp_alter_column dbo,  ICR_Transaction ,PHolder_Address_1 ,PHolder_Address_1,'nVarChar(255)','',0
GO
Exec sp_alter_column dbo,  ICR_Transaction ,Payor_Address_1 ,Payor_Address_1,'nVarChar(255)','',0
GO
Exec sp_alter_column dbo,  ICR_Transaction ,Insured_Address_2 ,Insured_Address_2,'nVarChar(255)','',0
GO
Exec sp_alter_column dbo,  ICR_Transaction ,Addremark_3b ,Addremark_3b,'nVarChar(255)','',0
GO
Exec sp_alter_column dbo,  ICR_Transaction ,Addremark_3a ,Addremark_3a,'nVarChar(255)','',0
GO
Exec sp_alter_column dbo,  ICR_Transaction ,Payor_Address_2 ,Payor_Address_2,'nVarChar(255)','',0
GO
Exec sp_alter_column dbo,  ICR_Transaction ,PHolder_Address_2 ,PHolder_Address_2,'nVarChar(255)','',0
GO
Exec sp_alter_column dbo,  ICR_Transaction ,Addremark_2a ,Addremark_2a,'nVarChar(255)','',0
GO
Exec sp_alter_column dbo,  ICR_Transaction ,Payor_EMail ,Payor_EMail,'nVarChar(255)','',0
GO
Exec sp_alter_column dbo,  ICR_Transaction ,PHolder_EMail ,PHolder_EMail,'nVarChar(255)','',0
GO
Exec sp_alter_column dbo,  ICR_Transaction ,DCode_Remark_5 ,DCode_Remark_5,'nVarChar(255)','',0
GO
Exec sp_alter_column dbo,  ICR_Transaction ,Insured_Address_1 ,Insured_Address_1,'nVarChar(255)','',0
GO
Exec sp_alter_column dbo,  ICR_Transaction ,DCode_Remark_2 ,DCode_Remark_2,'nVarChar(255)','',0
GO
Exec sp_alter_column dbo,  ICR_Transaction ,Insured_Address_3 ,Insured_Address_3,'nVarChar(255)','',0
GO
Exec sp_alter_column dbo,  ICR_Transaction ,Addremark_2b ,Addremark_2b,'nVarChar(255)','',0
GO
Exec sp_alter_column dbo,  ICR_Transaction ,AName ,AName,'nVarChar(512)','',0
GO
Exec sp_alter_column dbo,  ICR_Transaction ,Insured_Name ,Insured_Name,'nVarChar(255)','',0
GO
Exec sp_alter_column dbo,  ID_TYPE ,Description ,Description,'nVarChar(255)','',0
GO
Exec sp_alter_column dbo,  ID_TYPE ,Last_Opr ,Last_Opr,'nVarChar(50)','',0
GO
Exec sp_alter_column dbo,  IFRS_Assumption ,Description ,Description,'nVarChar(255)','',0
GO
Exec sp_alter_column dbo,  IFRS_Assumption ,Last_Opr ,Last_Opr,'nVarChar(50)','',0
GO
Exec sp_alter_column dbo,  IFRS_Assumption_Detail ,Last_Opr ,Last_Opr,'nVarChar(50)','',0
GO
Exec sp_alter_column dbo,  IFRS_CancelRate ,Last_Opr ,Last_Opr,'nVarChar(50)','',0
GO
Exec sp_alter_column dbo,  IFRS_CancelRate ,Description ,Description,'nVarChar(255)','',0
GO
Exec sp_alter_column dbo,  IFRS_CancelRate_Detail ,Last_Opr ,Last_Opr,'nVarChar(50)','',0
GO
Exec sp_alter_column dbo,  IFRS_DiscRate ,Last_Opr ,Last_Opr,'nVarChar(50)','',0
GO
Exec sp_alter_column dbo,  IFRS_DiscRate ,Description ,Description,'nVarChar(255)','',0
GO
Exec sp_alter_column dbo,  IFRS_DiscRate_Detail ,Last_Opr ,Last_Opr,'nVarChar(50)','',0
GO
Exec sp_alter_column dbo,  IFRS_InfRate ,Last_Opr ,Last_Opr,'nVarChar(50)','',0
GO
Exec sp_alter_column dbo,  IFRS_InfRate ,Description ,Description,'nVarChar(255)','',0
GO
Exec sp_alter_column dbo,  IFRS_InfRate_Detail ,Last_Opr ,Last_Opr,'nVarChar(50)','',0
GO
Exec sp_alter_column dbo,  IFRS_Movement ,Description ,Description,'nVarChar(255)','',0
GO
Exec sp_alter_column dbo,  INPARTY ,Address_1 ,Address_1,'nVarChar(1024)','',0
GO
Exec sp_alter_column dbo,  INPARTY ,Address_2 ,Address_2,'nVarChar(1024)','',0
GO
Exec sp_alter_column dbo,  INPARTY ,Email ,Email,'nVarChar(512)','',0
GO
Exec sp_alter_column dbo,  ISTYPE ,DESCRIPTION ,DESCRIPTION,'nVarChar(50)','',0
GO
Exec sp_alter_column dbo,  IUNIT ,DESCRIPTION ,DESCRIPTION,'nVarChar(100)','',0
GO
Exec sp_alter_column dbo,  IUNIT ,DESCRIPTION_1 ,DESCRIPTION_1,'nVarChar(100)','',0
GO
Exec sp_alter_column dbo,  IUNIT ,REMARK ,REMARK,'nVarChar(100)','',0
GO
Exec sp_alter_column dbo,  IUNIT ,REMARK_1 ,REMARK_1,'nVarChar(100)','',0
GO
Exec sp_alter_column dbo,  KOL ,Description ,Description,'nVarChar(100)','',0
GO
Exec sp_alter_column dbo,  KOLTab ,Description ,Description,'nVarChar(100)','',0
GO
Exec sp_alter_column dbo,  KOLTab ,Last_Opr ,Last_Opr,'nVarChar(50)','',0
GO
Exec sp_alter_column dbo,  KOLValue ,VALUEDESC1 ,VALUEDESC1,'nVarChar(255)','',0
GO
Exec sp_alter_column dbo,  KOLValue ,VALUEDESC2 ,VALUEDESC2,'nVarChar(255)','',0
GO
Exec sp_alter_column dbo,  KOLValue ,VALUEDESC3 ,VALUEDESC3,'nVarChar(255)','',0
GO
Exec sp_alter_column dbo,  KOLValue ,VALUEDESC4 ,VALUEDESC4,'nVarChar(255)','',0
GO
Exec sp_alter_column dbo,  KOLValue ,VALUEDESC5 ,VALUEDESC5,'nVarChar(255)','',0
GO
Exec sp_alter_column dbo,  KOLValue ,VALUEDESC6 ,VALUEDESC6,'nVarChar(255)','',0
GO
Exec sp_alter_column dbo,  KOLValue ,VALUEDESC7 ,VALUEDESC7,'nVarChar(255)','',0
GO
Exec sp_alter_column dbo,  KOLValue ,VALUEDESC8 ,VALUEDESC8,'nVarChar(255)','',0
GO
Exec sp_alter_column dbo,  KOLValue ,VALUEDESC9 ,VALUEDESC9,'nVarChar(255)','',0
GO
Exec sp_alter_column dbo,  KOLValue ,VALUEDESC10 ,VALUEDESC10,'nVarChar(255)','',0
GO
Exec sp_alter_column dbo,  KOLValue ,VALUEDESC11 ,VALUEDESC11,'nVarChar(255)','',0
GO
Exec sp_alter_column dbo,  KOLValue ,VALUEDESC12 ,VALUEDESC12,'nVarChar(255)','',0
GO
Exec sp_alter_column dbo,  KOLValue ,VALUEDESC13 ,VALUEDESC13,'nVarChar(255)','',0
GO
Exec sp_alter_column dbo,  KOLValue ,VALUEDESC14 ,VALUEDESC14,'nVarChar(255)','',0
GO
Exec sp_alter_column dbo,  KOLValue ,VALUEDESC15 ,VALUEDESC15,'nVarChar(255)','',0
GO
Exec sp_alter_column dbo,  KOLValue ,Last_Opr ,Last_Opr,'nVarChar(50)','',0
GO
Exec sp_alter_column dbo,  LastEducation ,Last_Opr ,Last_Opr,'nVarChar(10)','',0
GO
Exec sp_alter_column dbo,  LastEducation ,Description ,Description,'nVarChar(100)','',0
GO
Exec sp_alter_column dbo,  LinkExcel ,Description ,Description,'nVarChar(100)','',0
GO
Exec sp_alter_column dbo,  LLLog ,FILENAME ,FILENAME,'nVarChar(255)','',0
GO
Exec sp_alter_column dbo,  LLLog ,TBName ,TBName,'nVarChar(50)','',0
GO
Exec sp_alter_column dbo,  LOB ,Description ,Description,'nVarChar(50)','',0
GO
Exec sp_alter_column dbo,  LOB ,Last_Opr ,Last_Opr,'nVarChar(50)','',0
GO
Exec sp_alter_column dbo,  Location ,Location ,Location,'nVarChar(10)','',0
GO
Exec sp_alter_column dbo,  Location ,Name ,Name,'nVarChar(50)','',0
GO
Exec sp_alter_column dbo,  Location ,Remarks ,Remarks,'nVarChar(255)','',0
GO
Exec sp_alter_column dbo,  Location ,Last_Opr ,Last_Opr,'nVarChar(50)','',0
GO
Exec sp_alter_column dbo,  Location ,Address_3 ,Address_3,'nVarChar(1024)','',0
GO
Exec sp_alter_column dbo,  Location ,Address_2 ,Address_2,'nVarChar(1024)','',0
GO
Exec sp_alter_column dbo,  Location ,Address_1 ,Address_1,'nVarChar(1024)','',0
GO
Exec sp_alter_column dbo,  M_Poly ,Description ,Description,'nVarChar(50)','',0
GO
Exec sp_alter_column dbo,  MAP_FIELD ,LAST_OPR ,LAST_OPR,'nVarChar(50)','',0
GO
Exec sp_alter_column dbo,  MAP_HEADER ,Description ,Description,'nVarChar(100)','',0
GO
Exec sp_alter_column dbo,  MAP_HEADER ,Last_Opr ,Last_Opr,'nVarChar(50)','',0
GO
Exec sp_alter_column dbo,  MAP_REFERENCE ,ShortDesc ,ShortDesc,'nVarChar(50)','',0
GO
Exec sp_alter_column dbo,  MAP_REFERENCE ,LAST_OPR ,LAST_OPR,'nVarChar(50)','',0
GO
Exec sp_alter_column dbo,  MAP_VALUE ,Last_Opr ,Last_Opr,'nVarChar(50)','',0
GO
Exec sp_alter_column dbo,  MaritalStatus ,Description ,Description,'nVarChar(255)','',0
GO
Exec sp_alter_column dbo,  MaritalStatus ,Last_Opr ,Last_Opr,'nVarChar(10)','',0
GO
Exec sp_alter_column dbo,  MasterPrint ,Description ,Description,'nVarChar(255)','',0
GO
Exec sp_alter_column dbo,  Matters ,Description ,Description,'nVarChar(100)','',0
GO
Exec sp_alter_column dbo,  Matters ,Last_Opr ,Last_Opr,'nVarChar(50)','',0
GO
Exec sp_alter_column dbo,  MDocumentClaim ,Remarks ,Remarks,'nVarChar(255)','',0
GO
Exec sp_alter_column dbo,  MedicalCode ,Last_Opr ,Last_Opr,'nVarChar(50)','',0
GO
Exec sp_alter_column dbo,  MenuSetD ,LAST_OPR ,LAST_OPR,'nVarChar(50)','',0
GO
Exec sp_alter_column dbo,  MenuSetH ,Last_Opr ,Last_Opr,'nVarChar(50)','',0
GO
Exec sp_alter_column dbo,  MenuSetH ,Description ,Description,'nVarChar(100)','',0
GO
Exec sp_alter_column dbo,  Method ,Name ,Name,'nVarChar(50)','',0
GO
Exec sp_alter_column dbo,  MFactor ,Last_Opr ,Last_Opr,'nVarChar(10)','',0
GO
Exec sp_alter_column dbo,  mJournal ,Description ,Description,'nVarChar(512)','',0
GO
Exec sp_alter_column dbo,  mJournal ,Last_Opr ,Last_Opr,'nVarChar(50)','',0
GO
Exec sp_alter_column dbo,  MParam ,Remarks ,Remarks,'nVarChar(50)','',0
GO
Exec sp_alter_column dbo,  MParam ,Last_Opr ,Last_Opr,'nVarChar(50)','',0
GO
Exec sp_alter_column dbo,  MSCode ,Last_Opr ,Last_Opr,'nVarChar(50)','',0
GO
Exec sp_alter_column dbo,  MSCode ,Description ,Description,'nVarChar(100)','',0
GO
Exec sp_alter_column dbo,  MSCode_Assignment ,Last_Opr ,Last_Opr,'nVarChar(50)','',0
GO
Exec sp_alter_column dbo,  MSCode_Type ,Last_Opr ,Last_Opr,'nVarChar(50)','',0
GO
Exec sp_alter_column dbo,  MSCode_Type ,Description ,Description,'nVarChar(50)','',0
GO
Exec sp_alter_column dbo,  MType ,Description ,Description,'nVarChar(50)','',0
GO
Exec sp_alter_column dbo,  MType ,Last_Opr ,Last_Opr,'nVarChar(50)','',0
GO
Exec sp_alter_column dbo,  MultH ,Name ,Name,'nVarChar(50)','',0
GO
Exec sp_alter_column dbo,  MultH ,Last_Opr ,Last_Opr,'nVarChar(10)','',0
GO
Exec sp_alter_column dbo,  mVoucher ,Remarks ,Remarks,'nVarChar(max)','',0
GO
Exec sp_alter_column dbo,  mVoucher ,Last_Opr ,Last_Opr,'nVarChar(50)','',0
GO
Exec sp_alter_column dbo,  mVoucher ,RequestName ,RequestName,'nVarChar(50)','',0
GO
Exec sp_alter_column dbo,  mVoucher ,AUserID ,AUserID,'nVarChar(50)','',0
GO
Exec sp_alter_column dbo,  mVoucher ,VUserID ,VUserID,'nVarChar(50)','',0
GO
Exec sp_alter_column dbo,  mVoucher ,AUserID_Ext ,AUserID_Ext,'nVarChar(50)','',0
GO
Exec sp_alter_column dbo,  mVoucher ,UVUserID ,UVUserID,'nVarChar(50)','',0
GO
Exec sp_alter_column dbo,  mVoucher ,UAUserID ,UAUserID,'nVarChar(50)','',0
GO
Exec sp_alter_column dbo,  mVoucher ,UAUserID_Ext ,UAUserID_Ext,'nVarChar(50)','',0
GO
Exec sp_alter_column dbo,  mVoucher ,USERID ,USERID,'nVarChar(50)','',0
GO
Exec sp_alter_column dbo,  nJournal ,Description ,Description,'nVarChar(100)','',0
GO
Exec sp_alter_column dbo,  nJournal ,Last_Opr ,Last_Opr,'nVarChar(50)','',0
GO
Exec sp_alter_column dbo,  NOC ,DESCRIPTION ,DESCRIPTION,'nVarChar(255)','',0
GO
Exec sp_alter_column dbo,  NOCTab ,DESCRIPTION ,DESCRIPTION,'nVarChar(255)','',0
GO
Exec sp_alter_column dbo,  NOCTab ,Last_Opr ,Last_Opr,'nVarChar(50)','',0
GO
Exec sp_alter_column dbo,  Notes ,Description ,Description,'nVarChar(50)','',0
GO
Exec sp_alter_column dbo,  nVoucher ,USERID ,USERID,'nVarChar(50)','',0
GO
Exec sp_alter_column dbo,  nVoucher ,Remarks ,Remarks,'nVarChar(max)','',0
GO
Exec sp_alter_column dbo,  nVoucher ,Last_Opr ,Last_Opr,'nVarChar(50)','',0
GO
Exec sp_alter_column dbo,  nVoucher ,RequestName ,RequestName,'nVarChar(50)','',0
GO
Exec sp_alter_column dbo,  ObjectRegister ,VALUEDESC10 ,VALUEDESC10,'nVarChar(255)','',0
GO
Exec sp_alter_column dbo,  ObjectRegister ,VALUEDESC7 ,VALUEDESC7,'nVarChar(255)','',0
GO
Exec sp_alter_column dbo,  ObjectRegister ,VALUEDESC9 ,VALUEDESC9,'nVarChar(255)','',0
GO
Exec sp_alter_column dbo,  ObjectRegister ,VALUEDESC11 ,VALUEDESC11,'nVarChar(255)','',0
GO
Exec sp_alter_column dbo,  ObjectRegister ,VALUEDESC8 ,VALUEDESC8,'nVarChar(255)','',0
GO
Exec sp_alter_column dbo,  ObjectRegister ,VALUEDESC6 ,VALUEDESC6,'nVarChar(255)','',0
GO
Exec sp_alter_column dbo,  ObjectRegister ,VALUEDESC15 ,VALUEDESC15,'nVarChar(255)','',0
GO
Exec sp_alter_column dbo,  ObjectRegister ,VALUEDESC14 ,VALUEDESC14,'nVarChar(255)','',0
GO
Exec sp_alter_column dbo,  ObjectRegister ,VALUEDESC12 ,VALUEDESC12,'nVarChar(255)','',0
GO
Exec sp_alter_column dbo,  ObjectRegister ,VALUEDESC13 ,VALUEDESC13,'nVarChar(255)','',0
GO
Exec sp_alter_column dbo,  ObjectRegister ,VALUEDESC4 ,VALUEDESC4,'nVarChar(255)','',0
GO
Exec sp_alter_column dbo,  ObjectRegister ,VALUEDESC3 ,VALUEDESC3,'nVarChar(255)','',0
GO
Exec sp_alter_column dbo,  ObjectRegister ,VALUEDESC1 ,VALUEDESC1,'nVarChar(255)','',0
GO
Exec sp_alter_column dbo,  ObjectRegister ,VALUEDESC5 ,VALUEDESC5,'nVarChar(255)','',0
GO
Exec sp_alter_column dbo,  ObjectRegister ,Last_Opr ,Last_Opr,'nVarChar(50)','',0
GO
Exec sp_alter_column dbo,  ObjectRegister ,VALUEDESC2 ,VALUEDESC2,'nVarChar(255)','',0
GO
Exec sp_alter_column dbo,  Occupation ,Name ,Name,'nVarChar(50)','',0
GO
Exec sp_alter_column dbo,  Occupation ,Description ,Description,'nVarChar(50)','',0
GO
Exec sp_alter_column dbo,  Occupation ,Last_Opr ,Last_Opr,'nVarChar(50)','',0
GO
Exec sp_alter_column dbo,  OfficerPosition ,Description ,Description,'nVarChar(255)','',0
GO
Exec sp_alter_column dbo,  OfficerPosition ,Last_Opr ,Last_Opr,'nVarChar(50)','',0
GO
Exec sp_alter_column dbo,  OGIS_ERROR ,Last_opr ,Last_opr,'nVarChar(50)','',0
GO
Exec sp_alter_column dbo,  OGIS_ERROR ,OGIS_ERROR_DESCRIPTION ,OGIS_ERROR_DESCRIPTION,'nVarChar(500)','',0
GO
Exec sp_alter_column dbo,  OGIS_LOG_DETAIL ,Last_Opr ,Last_Opr,'nVarChar(50)','',0
GO
Exec sp_alter_column dbo,  OGIS_LOG_DOWNLOAD ,UserID ,UserID,'nVarChar(50)','',0
GO
Exec sp_alter_column dbo,  OGIS_LOG_HEADER ,USERID ,USERID,'nVarChar(50)','',0
GO
Exec sp_alter_column dbo,  OGIS_LOG_HEADER ,FILENAME ,FILENAME,'nVarChar(255)','',0
GO
Exec sp_alter_column dbo,  OGIS_MAP_DETAIL ,Last_opr ,Last_opr,'nVarChar(50)','',0
GO
Exec sp_alter_column dbo,  OGIS_MAP_HEADER ,SOURCE_FIELD_NAME ,SOURCE_FIELD_NAME,'nVarChar(50)','',0
GO
Exec sp_alter_column dbo,  OGIS_MAP_HEADER ,OGIS_FIELD_NAME ,OGIS_FIELD_NAME,'nVarChar(50)','',0
GO
Exec sp_alter_column dbo,  OGIS_MAP_HEADER ,OGIS_FIELD_DESCRIPTION ,OGIS_FIELD_DESCRIPTION,'nVarChar(500)','',0
GO
Exec sp_alter_column dbo,  OGIS_MAP_HEADER ,Last_opr ,Last_opr,'nVarChar(50)','',0
GO
Exec sp_alter_column dbo,  OneCardD ,Email ,Email,'nVarChar(512)','',0
GO
Exec sp_alter_column dbo,  OneCardD ,LAST_OPR ,LAST_OPR,'nVarChar(50)','',0
GO
Exec sp_alter_column dbo,  OneCardD ,Address ,Address,'nVarChar(1024)','',0
GO
Exec sp_alter_column dbo,  OneCardH ,CardRemarks ,CardRemarks,'nVarChar(512)','',0
GO
Exec sp_alter_column dbo,  OneCardH ,LAST_OPR ,LAST_OPR,'nVarChar(50)','',0
GO
Exec sp_alter_column dbo,  OneCardH ,AUSERID ,AUSERID,'nVarChar(50)','',0
GO
Exec sp_alter_column dbo,  OneCardH ,CUSERID ,CUSERID,'nVarChar(50)','',0
GO
Exec sp_alter_column dbo,  OneCardH ,USERID ,USERID,'nVarChar(50)','',0
GO
Exec sp_alter_column dbo,  OneCardH ,CardName ,CardName,'nVarChar(255)','',0
GO
Exec sp_alter_column dbo,  OneCardH ,CardEmail ,CardEmail,'nVarChar(255)','',0
GO
Exec sp_alter_column dbo,  OneCardP ,DESCRIPTION ,DESCRIPTION,'nVarChar(255)','',0
GO
Exec sp_alter_column dbo,  OneCardP ,LAST_OPR ,LAST_OPR,'nVarChar(50)','',0
GO
Exec sp_alter_column dbo,  OneCardP ,AUSERID ,AUSERID,'nVarChar(50)','',0
GO
Exec sp_alter_column dbo,  OneCardP ,CUSERID ,CUSERID,'nVarChar(50)','',0
GO
Exec sp_alter_column dbo,  OneCardP ,USERID ,USERID,'nVarChar(50)','',0
GO
Exec sp_alter_column dbo,  ORPrintLog ,Description ,Description,'nVarChar(50)','',0
GO
Exec sp_alter_column dbo,  ORPrintLog ,UserID ,UserID,'nVarChar(50)','',0
GO
Exec sp_alter_column dbo,  Owner ,Last_Opr ,Last_Opr,'nVarChar(50)','',0
GO
Exec sp_alter_column dbo,  Owner ,Description ,Description,'nVarChar(50)','',0
GO
Exec sp_alter_column dbo,  PAlias ,Email ,Email,'nVarChar(512)','',0
GO
Exec sp_alter_column dbo,  PAlias ,LAST_OPR ,LAST_OPR,'nVarChar(50)','',0
GO
Exec sp_alter_column dbo,  PAlias ,Address ,Address,'nVarChar(1024)','',0
GO
Exec sp_alter_column dbo,  PAYOR ,ADDRESS_1 ,ADDRESS_1,'nVarChar(1024)','',0
GO
Exec sp_alter_column dbo,  PAYOR ,ADDRESS_2 ,ADDRESS_2,'nVarChar(1024)','',0
GO
Exec sp_alter_column dbo,  PAYOR ,ADDRESS_3 ,ADDRESS_3,'nVarChar(1024)','',0
GO
Exec sp_alter_column dbo,  PAYOR ,Remarks ,Remarks,'nVarChar(255)','',0
GO
Exec sp_alter_column dbo,  PAYOR ,LUserID ,LUserID,'nVarChar(50)','',0
GO
Exec sp_alter_column dbo,  PBenefit ,Last_Opr ,Last_Opr,'nVarChar(10)','',0
GO
Exec sp_alter_column dbo,  PCLASS ,Last_Opr ,Last_Opr,'nVarChar(50)','',0
GO
Exec sp_alter_column dbo,  PCoasuransi ,Last_Opr ,Last_Opr,'nVarChar(10)','',0
GO
Exec sp_alter_column dbo,  PCSummary ,Last_Opr ,Last_Opr,'nVarChar(50)','',0
GO
Exec sp_alter_column dbo,  PDOCLIST ,DESCRIPTION ,DESCRIPTION,'nVarChar(255)','',0
GO
Exec sp_alter_column dbo,  PERIOD ,Description ,Description,'nVarChar(20)','',0
GO
Exec sp_alter_column dbo,  PettyCashH ,RName ,RName,'nVarChar(50)','',0
GO
Exec sp_alter_column dbo,  PettyCashH ,Last_Opr ,Last_Opr,'nVarChar(50)','',0
GO
Exec sp_alter_column dbo,  PettyCashH ,CUSERID ,CUSERID,'nVarChar(50)','',0
GO
Exec sp_alter_column dbo,  PettyCashH ,AUserID ,AUserID,'nVarChar(50)','',0
GO
Exec sp_alter_column dbo,  PettyCashH ,UserID ,UserID,'nVarChar(50)','',0
GO
Exec sp_alter_column dbo,  PettyCashType ,Description ,Description,'nVarChar(50)','',0
GO
Exec sp_alter_column dbo,  PettyCashType ,Last_Opr ,Last_Opr,'nVarChar(50)','',0
GO
Exec sp_alter_column dbo,  PFLScale ,Last_Opr ,Last_Opr,'nVarChar(50)','',0
GO
Exec sp_alter_column dbo,  PHOLDER ,UserID ,UserID,'nVarChar(50)','',0
GO
Exec sp_alter_column dbo,  PHOLDER ,Last_Opr ,Last_Opr,'nVarChar(50)','',0
GO
Exec sp_alter_column dbo,  pJournal ,Description ,Description,'nVarChar(100)','',0
GO
Exec sp_alter_column dbo,  pJournal ,Last_Opr ,Last_Opr,'nVarChar(50)','',0
GO
Exec sp_alter_column dbo,  PNOTES ,UserID ,UserID,'nVarChar(50)','',0
GO
Exec sp_alter_column dbo,  PNotify ,UserID ,UserID,'nVarChar(50)','',0
GO
Exec sp_alter_column dbo,  PNStatus ,Last_Opr ,Last_Opr,'nVarChar(50)','',0
GO
Exec sp_alter_column dbo,  PNStatus ,Description ,Description,'nVarChar(255)','',0
GO
Exec sp_alter_column dbo,  PolicyType ,Last_Opr ,Last_Opr,'nVarChar(50)','',0
GO
Exec sp_alter_column dbo,  PolicyType ,Description ,Description,'nVarChar(50)','',0
GO
Exec sp_alter_column dbo,  Port ,Last_Opr ,Last_Opr,'nVarChar(50)','',0
GO
Exec sp_alter_column dbo,  Port ,Description ,Description,'nVarChar(255)','',0
GO
Exec sp_alter_column dbo,  PPrintLog ,Description ,Description,'nVarChar(50)','',0
GO
Exec sp_alter_column dbo,  PPrintLog ,UserID ,UserID,'nVarChar(50)','',0
GO
Exec sp_alter_column dbo,  PPrintLogH ,Description ,Description,'nVarChar(50)','',0
GO
Exec sp_alter_column dbo,  PPrintLogH ,UserID ,UserID,'nVarChar(10)','',0
GO
Exec sp_alter_column dbo,  ProAcc ,PUserID ,PUserID,'nVarChar(50)','',0
GO
Exec sp_alter_column dbo,  ProAcc ,USERID ,USERID,'nVarChar(50)','',0
GO
Exec sp_alter_column dbo,  ProAcc ,LAST_OPR ,LAST_OPR,'nVarChar(50)','',0
GO
Exec sp_alter_column dbo,  Profile ,Address_1 ,Address_1,'nVarChar(1024)','',0
GO
Exec sp_alter_column dbo,  Profile ,Address_2 ,Address_2,'nVarChar(1024)','',0
GO
Exec sp_alter_column dbo,  Profile ,Address_3 ,Address_3,'nVarChar(1024)','',0
GO
Exec sp_alter_column dbo,  Profile ,Email ,Email,'nVarChar(512)','',0
GO
Exec sp_alter_column dbo,  Profile ,Email_2 ,Email_2,'nVarChar(512)','',0
GO
Exec sp_alter_column dbo,  Profile ,LAST_OPR ,LAST_OPR,'nVarChar(50)','',0
GO
Exec sp_alter_column dbo,  Profile ,REMARK ,REMARK,'nVarChar(255)','',0
GO
Exec sp_alter_column dbo,  Profile ,RedFlagDescription ,RedFlagDescription,'nVarChar(255)','',0
GO
Exec sp_alter_column dbo,  Profile ,Email_3 ,Email_3,'nVarChar(512)','',0
GO
Exec sp_alter_column dbo,  Profile ,RequestMessage ,RequestMessage,'nVarChar(max)','',0
GO
Exec sp_alter_column dbo,  Profile ,RequestName ,RequestName,'nVarChar(1)','',0
GO
Exec sp_alter_column dbo,  Profile ,USERID ,USERID,'nVarChar(50)','',0
GO
Exec sp_alter_column dbo,  Profile ,MName ,MName,'nVarChar(255)','',0
GO
Exec sp_alter_column dbo,  Profile ,ShortName ,ShortName,'nVarChar(5)','',0
GO
Exec sp_alter_column dbo,  Profile ,LName ,LName,'nVarChar(255)','',0
GO
Exec sp_alter_column dbo,  Profile ,FName ,FName,'nVarChar(255)','',0
GO
Exec sp_alter_column dbo,  Profile_Batch ,PIC_NAME_2 ,PIC_NAME_2,'nVarChar(50)','',0
GO
Exec sp_alter_column dbo,  Profile_Batch ,TaxAddress ,TaxAddress,'nVarChar(255)','',0
GO
Exec sp_alter_column dbo,  Profile_Batch ,Address_4 ,Address_4,'nVarChar(255)','',0
GO
Exec sp_alter_column dbo,  Profile_Batch ,Address_2 ,Address_2,'nVarChar(1024)','',0
GO
Exec sp_alter_column dbo,  Profile_Batch ,ID_Name ,ID_Name,'nVarChar(255)','',0
GO
Exec sp_alter_column dbo,  Profile_Batch ,LastName ,LastName,'nVarChar(255)','',0
GO
Exec sp_alter_column dbo,  Profile_Batch ,NickName ,NickName,'nVarChar(255)','',0
GO
Exec sp_alter_column dbo,  Profile_Batch ,REMARK ,REMARK,'nVarChar(255)','',0
GO
Exec sp_alter_column dbo,  Profile_Batch ,BOD_Address_2 ,BOD_Address_2,'nVarChar(1024)','',0
GO
Exec sp_alter_column dbo,  Profile_Batch ,CAddress ,CAddress,'nVarChar(255)','',0
GO
Exec sp_alter_column dbo,  Profile_Batch ,Email_1 ,Email_1,'nVarChar(512)','',0
GO
Exec sp_alter_column dbo,  Profile_Batch ,BOD_Address_3 ,BOD_Address_3,'nVarChar(1024)','',0
GO
Exec sp_alter_column dbo,  Profile_Batch ,Email_3 ,Email_3,'nVarChar(512)','',0
GO
Exec sp_alter_column dbo,  Profile_Batch ,ShortName ,ShortName,'nVarChar(5)','',0
GO
Exec sp_alter_column dbo,  Profile_Batch ,CUSERID ,CUSERID,'nVarChar(50)','',0
GO
Exec sp_alter_column dbo,  Profile_Batch ,DomicileAddress ,DomicileAddress,'nVarChar(512)','',0
GO
Exec sp_alter_column dbo,  Profile_Batch ,PIC_NAME_1 ,PIC_NAME_1,'nVarChar(50)','',0
GO
Exec sp_alter_column dbo,  Profile_Batch ,FirstName ,FirstName,'nVarChar(255)','',0
GO
Exec sp_alter_column dbo,  Profile_Batch ,USERID ,USERID,'nVarChar(50)','',0
GO
Exec sp_alter_column dbo,  Profile_Batch ,ID_Name_Ext ,ID_Name_Ext,'nVarChar(255)','',0
GO
Exec sp_alter_column dbo,  Profile_Batch ,Last_OPR ,Last_OPR,'nVarChar(50)','',0
GO
Exec sp_alter_column dbo,  Profile_Batch ,FName ,FName,'nVarChar(255)','',0
GO
Exec sp_alter_column dbo,  Profile_Batch ,PUSERID ,PUSERID,'nVarChar(50)','',0
GO
Exec sp_alter_column dbo,  Profile_Batch ,ContactAddress_3 ,ContactAddress_3,'nVarChar(225)','',0
GO
Exec sp_alter_column dbo,  Profile_Batch ,TaxName ,TaxName,'nVarChar(255)','',0
GO
Exec sp_alter_column dbo,  Profile_Batch ,Address_1 ,Address_1,'nVarChar(1024)','',0
GO
Exec sp_alter_column dbo,  Profile_Batch ,PIC_NAME_3 ,PIC_NAME_3,'nVarChar(50)','',0
GO
Exec sp_alter_column dbo,  Profile_Batch ,CName ,CName,'nVarChar(255)','',0
GO
Exec sp_alter_column dbo,  Profile_Batch ,MidName ,MidName,'nVarChar(255)','',0
GO
Exec sp_alter_column dbo,  Profile_Batch ,LName ,LName,'nVarChar(255)','',0
GO
Exec sp_alter_column dbo,  Profile_Batch ,PICAddress ,PICAddress,'nVarChar(255)','',0
GO
Exec sp_alter_column dbo,  Profile_Batch ,Name ,Name,'nVarChar(255)','',0
GO
Exec sp_alter_column dbo,  Profile_Batch ,ContactAddress_1 ,ContactAddress_1,'nVarChar(255)','',0
GO
Exec sp_alter_column dbo,  Profile_Batch ,Address_3 ,Address_3,'nVarChar(1024)','',0
GO
Exec sp_alter_column dbo,  Profile_Batch ,PICNAME ,PICNAME,'nVarChar(50)','',0
GO
Exec sp_alter_column dbo,  Profile_Batch ,EMail_2 ,EMail_2,'nVarChar(512)','',0
GO
Exec sp_alter_column dbo,  Profile_Batch ,BOD_Address_1 ,BOD_Address_1,'nVarChar(1024)','',0
GO
Exec sp_alter_column dbo,  Profile_Batch ,MName ,MName,'nVarChar(255)','',0
GO
Exec sp_alter_column dbo,  Profile_Batch ,MothersName ,MothersName,'nVarChar(255)','',0
GO
Exec sp_alter_column dbo,  Profile_Consent ,Last_Opr ,Last_Opr,'nVarChar(50)','',0
GO
Exec sp_alter_column dbo,  Profile_Ext ,DomicileAddress ,DomicileAddress,'nVarChar(512)','',0
GO
Exec sp_alter_column dbo,  Profile_Ext ,BOD_Address_1 ,BOD_Address_1,'nVarChar(1024)','',0
GO
Exec sp_alter_column dbo,  Profile_Ext ,BOD_Address_2 ,BOD_Address_2,'nVarChar(1024)','',0
GO
Exec sp_alter_column dbo,  Profile_Ext ,BOD_Address_3 ,BOD_Address_3,'nVarChar(1024)','',0
GO
Exec sp_alter_column dbo,  Profile_Ext ,MothersName ,MothersName,'nVarChar(255)','',0
GO
Exec sp_alter_column dbo,  Profile_FS ,Last_Opr ,Last_Opr,'nVarChar(50)','',0
GO
Exec sp_alter_column dbo,  Profile_Income ,Description ,Description,'nVarChar(100)','',0
GO
Exec sp_alter_column dbo,  Profile_IncomeSource ,Description ,Description,'nVarChar(20)','',0
GO
Exec sp_alter_column dbo,  Profile_Mandatory ,ControlName ,ControlName,'nVarChar(128)','',0
GO
Exec sp_alter_column dbo,  Profile_Mandatory ,PanelName ,PanelName,'nVarChar(128)','',0
GO
Exec sp_alter_column dbo,  Profile_Mandatory ,FieldName ,FieldName,'nVarChar(128)','',0
GO
Exec sp_alter_column dbo,  Profile_Mandatory ,Description ,Description,'nVarChar(255)','',0
GO
Exec sp_alter_column dbo,  Profile_Ref ,SaveLocation ,SaveLocation,'nVarChar(255)','',0
GO
Exec sp_alter_column dbo,  Profile_Ref ,TaxAddress ,TaxAddress,'nVarChar(255)','',0
GO
Exec sp_alter_column dbo,  Profile_Ref ,Address ,Address,'nVarChar(1024)','',0
GO
Exec sp_alter_column dbo,  Profile_Ref ,Name ,Name,'nVarChar(255)','',0
GO
Exec sp_alter_column dbo,  Profile_Ref ,TaxName ,TaxName,'nVarChar(255)','',0
GO
Exec sp_alter_column dbo,  ProfilePIC ,Last_Opr ,Last_Opr,'nVarChar(50)','',0
GO
Exec sp_alter_column dbo,  Province ,Last_OPR ,Last_OPR,'nVarChar(10)','',0
GO
Exec sp_alter_column dbo,  PScale ,Last_Opr ,Last_Opr,'nVarChar(50)','',0
GO
Exec sp_alter_column dbo,  pSL ,Description ,Description,'nVarChar(512)','',0
GO
Exec sp_alter_column dbo,  pSLRef ,Description ,Description,'nVarChar(50)','',0
GO
Exec sp_alter_column dbo,  PTClass ,Last_Opr ,Last_Opr,'nVarChar(50)','',0
GO
Exec sp_alter_column dbo,  PTermCon ,Remarks ,Remarks,'nVarChar(1000)','',0
GO
Exec sp_alter_column dbo,  PTermCon ,Description_1 ,Description_1,'nVarChar(512)','',0
GO
Exec sp_alter_column dbo,  PTermCon ,Description ,Description,'nVarChar(512)','',0
GO
Exec sp_alter_column dbo,  pType ,Last_Opr ,Last_Opr,'nVarChar(10)','',0
GO
Exec sp_alter_column dbo,  pType ,Description ,Description,'nVarChar(50)','',0
GO
Exec sp_alter_column dbo,  pVoucher ,USERID ,USERID,'nVarChar(50)','',0
GO
Exec sp_alter_column dbo,  pVoucher ,Remarks ,Remarks,'nVarChar(max)','',0
GO
Exec sp_alter_column dbo,  pVoucher ,Last_Opr ,Last_Opr,'nVarChar(50)','',0
GO
Exec sp_alter_column dbo,  pVoucher ,RequestName ,RequestName,'nVarChar(50)','',0
GO
Exec sp_alter_column dbo,  pVoucher ,AUserID ,AUserID,'nVarChar(50)','',0
GO
Exec sp_alter_column dbo,  pVoucher ,AUserID_Ext ,AUserID_Ext,'nVarChar(50)','',0
GO
Exec sp_alter_column dbo,  pVoucher ,VUserID ,VUserID,'nVarChar(50)','',0
GO
Exec sp_alter_column dbo,  pVoucher ,UVUserID ,UVUserID,'nVarChar(50)','',0
GO
Exec sp_alter_column dbo,  pVoucher ,UAUserID ,UAUserID,'nVarChar(50)','',0
GO
Exec sp_alter_column dbo,  pVoucher ,UAUserID_Ext ,UAUserID_Ext,'nVarChar(50)','',0
GO
Exec sp_alter_column dbo,  pYearSetup ,Description ,Description,'nVarChar(20)','',0
GO
Exec sp_alter_column dbo,  QPrintLog ,Description ,Description,'nVarChar(50)','',0
GO
Exec sp_alter_column dbo,  QPrintLog ,UserID ,UserID,'nVarChar(50)','',0
GO
Exec sp_alter_column dbo,  RAccClassDet ,Description ,Description,'nVarChar(200)','',0
GO
Exec sp_alter_column dbo,  RARRDET ,USERID ,USERID,'nVarChar(50)','',0
GO
Exec sp_alter_column dbo,  RARRDET ,LUserID ,LUserID,'nVarChar(50)','',0
GO
Exec sp_alter_column dbo,  RARRDET ,AUserID ,AUserID,'nVarChar(50)','',0
GO
Exec sp_alter_column dbo,  RARRDET ,SysUserID ,SysUserID,'nVarChar(50)','',0
GO
Exec sp_alter_column dbo,  RARRHEADER ,LUserID ,LUserID,'nVarChar(50)','',0
GO
Exec sp_alter_column dbo,  RATECON ,Last_Opr ,Last_Opr,'nVarChar(50)','',0
GO
Exec sp_alter_column dbo,  RATECON ,HoldMessage ,HoldMessage,'nVarChar(512)','',0
GO
Exec sp_alter_column dbo,  RATECON_M1 ,Last_Opr ,Last_Opr,'nVarChar(50)','',0
GO
Exec sp_alter_column dbo,  RATECON_M1 ,HoldMessage ,HoldMessage,'nVarChar(512)','',0
GO
Exec sp_alter_column dbo,  RATECON_M2 ,Last_Opr ,Last_Opr,'nVarChar(50)','',0
GO
Exec sp_alter_column dbo,  RATECON_M2 ,HoldMessage ,HoldMessage,'nVarChar(512)','',0
GO
Exec sp_alter_column dbo,  RATECON_M3 ,Last_Opr ,Last_Opr,'nVarChar(50)','',0
GO
Exec sp_alter_column dbo,  RATECON_M3 ,HoldMessage ,HoldMessage,'nVarChar(512)','',0
GO
Exec sp_alter_column dbo,  RATECON_M4 ,Last_Opr ,Last_Opr,'nVarChar(50)','',0
GO
Exec sp_alter_column dbo,  RATECON_M4 ,HoldMessage ,HoldMessage,'nVarChar(512)','',0
GO
Exec sp_alter_column dbo,  RATECON_M5 ,HoldMessage ,HoldMessage,'nVarChar(512)','',0
GO
Exec sp_alter_column dbo,  RATECON_M5 ,Last_Opr ,Last_Opr,'nVarChar(50)','',0
GO
Exec sp_alter_column dbo,  RATECON_M6 ,HoldMessage ,HoldMessage,'nVarChar(512)','',0
GO
Exec sp_alter_column dbo,  RATECON_M6 ,Last_Opr ,Last_Opr,'nVarChar(50)','',0
GO
Exec sp_alter_column dbo,  RATECON_M7 ,Last_Opr ,Last_Opr,'nVarChar(50)','',0
GO
Exec sp_alter_column dbo,  RATECON_M7 ,HoldMessage ,HoldMessage,'nVarChar(512)','',0
GO
Exec sp_alter_column dbo,  RATECOV ,DESCRIPTION ,DESCRIPTION,'nVarChar(255)','',0
GO
Exec sp_alter_column dbo,  RATECOV ,Last_Opr ,Last_Opr,'nVarChar(50)','',0
GO
Exec sp_alter_column dbo,  RateIndemnity ,Last_Opr ,Last_Opr,'nVarChar(50)','',0
GO
Exec sp_alter_column dbo,  RateMin ,Last_Opr ,Last_Opr,'nVarChar(50)','',0
GO
Exec sp_alter_column dbo,  RATETAB ,Last_Opr ,Last_Opr,'nVarChar(50)','',0
GO
Exec sp_alter_column dbo,  RATETAB ,DESCRIPTION ,DESCRIPTION,'nVarChar(255)','',0
GO
Exec sp_alter_column dbo,  RateTabCla ,SHORTDESC ,SHORTDESC,'nVarChar(max)','',0
GO
Exec sp_alter_column dbo,  RateTabCla ,ShortDesc_1 ,ShortDesc_1,'nVarChar(max)','',0
GO
Exec sp_alter_column dbo,  RateTabCon ,ShortDesc_1 ,ShortDesc_1,'nVarChar(max)','',0
GO
Exec sp_alter_column dbo,  RateTabCon ,SHORTDESC ,SHORTDESC,'nVarChar(max)','',0
GO
Exec sp_alter_column dbo,  RateTabEx ,SHORTDESC ,SHORTDESC,'nVarChar(max)','',0
GO
Exec sp_alter_column dbo,  RateTabEx ,ShortDesc_1 ,ShortDesc_1,'nVarChar(max)','',0
GO
Exec sp_alter_column dbo,  RatingAgency ,Description ,Description,'nVarChar(255)','',0
GO
Exec sp_alter_column dbo,  RatingAgency ,Last_Opr ,Last_Opr,'nVarChar(50)','',0
GO
Exec sp_alter_column dbo,  RCCode ,Last_Opr ,Last_Opr,'nVarChar(50)','',0
GO
Exec sp_alter_column dbo,  RCCode ,Description ,Description,'nVarChar(255)','',0
GO
Exec sp_alter_column dbo,  RCLASS ,Last_Opr ,Last_Opr,'nVarChar(50)','',0
GO
Exec sp_alter_column dbo,  RCOVER ,LUserID ,LUserID,'nVarChar(50)','',0
GO
Exec sp_alter_column dbo,  RCOVER ,REMARK ,REMARK,'nVarChar(max)','',0
GO
Exec sp_alter_column dbo,  RDOCLIST ,DESCRIPTION ,DESCRIPTION,'nVarChar(255)','',0
GO
Exec sp_alter_column dbo,  RDOCLIST ,REMARKS ,REMARKS,'nVarChar(512)','',0
GO
Exec sp_alter_column dbo,  RDOCLIST ,LAST_OPR ,LAST_OPR,'nVarChar(50)','',0
GO
Exec sp_alter_column dbo,  RDOCLISTPIC ,Last_Opr ,Last_Opr,'nVarChar(50)','',0
GO
Exec sp_alter_column dbo,  Reason ,Last_Opr ,Last_Opr,'nVarChar(50)','',0
GO
Exec sp_alter_column dbo,  Reason ,Description ,Description,'nVarChar(100)','',0
GO
Exec sp_alter_column dbo,  RECLASS ,Last_Opr ,Last_Opr,'nVarChar(50)','',0
GO
Exec sp_alter_column dbo,  RefProfile ,Name ,Name,'nVarChar(512)','',0
GO
Exec sp_alter_column dbo,  RefProfile ,Address_1 ,Address_1,'nVarChar(255)','',0
GO
Exec sp_alter_column dbo,  RefProfile ,Address_2 ,Address_2,'nVarChar(255)','',0
GO
Exec sp_alter_column dbo,  RefProfile ,Address_3 ,Address_3,'nVarChar(255)','',0
GO
Exec sp_alter_column dbo,  ReinsPIC ,Last_Opr ,Last_Opr,'nVarChar(50)','',0
GO
Exec sp_alter_column dbo,  REINSURANCE ,Last_Opr ,Last_Opr,'nVarChar(50)','',0
GO
Exec sp_alter_column dbo,  REINSURANCE ,REMARKS ,REMARKS,'nVarChar(255)','',0
GO
Exec sp_alter_column dbo,  REINSURANCE ,DESCRIPTION ,DESCRIPTION,'nVarChar(255)','',0
GO
Exec sp_alter_column dbo,  Reminder ,Description ,Description,'nVarChar(50)','',0
GO
Exec sp_alter_column dbo,  ReminderD ,Last_Opr ,Last_Opr,'nVarChar(50)','',0
GO
Exec sp_alter_column dbo,  ReminderV ,Last_Opr ,Last_Opr,'nVarChar(50)','',0
GO
Exec sp_alter_column dbo,  Renewal ,AName ,AName,'nVarChar(max)','',0
GO
Exec sp_alter_column dbo,  Renewal ,USERID ,USERID,'nVarChar(50)','',0
GO
Exec sp_alter_column dbo,  Renewal ,LUserID ,LUserID,'nVarChar(50)','',0
GO
Exec sp_alter_column dbo,  RenewalDA ,Address ,Address,'nVarChar(1024)','',0
GO
Exec sp_alter_column dbo,  RenewalDA ,Email ,Email,'nVarChar(512)','',0
GO
Exec sp_alter_column dbo,  RenewalRight ,Description ,Description,'nVarChar(150)','',0
GO
Exec sp_alter_column dbo,  RenewalRight ,Last_Opr ,Last_Opr,'nVarChar(50)','',0
GO
Exec sp_alter_column dbo,  RenewalRule ,Last_Opr ,Last_Opr,'nVarChar(50)','',0
GO
Exec sp_alter_column dbo,  REPOLICY ,Last_Opr ,Last_Opr,'nVarChar(50)','',0
GO
Exec sp_alter_column dbo,  Report_Portal ,Name ,Name,'nVarChar(255)','',0
GO
Exec sp_alter_column dbo,  Request ,USERID ,USERID,'nVarChar(50)','',0
GO
Exec sp_alter_column dbo,  Request ,Last_Opr ,Last_Opr,'nVarChar(50)','',0
GO
Exec sp_alter_column dbo,  Request ,AUserID ,AUserID,'nVarChar(50)','',0
GO
Exec sp_alter_column dbo,  Request ,CUSERID ,CUSERID,'nVarChar(50)','',0
GO
Exec sp_alter_column dbo,  Request ,VUserID ,VUserID,'nVarChar(50)','',0
GO
Exec sp_alter_column dbo,  Request ,AUserID_Ext ,AUserID_Ext,'nVarChar(50)','',0
GO
Exec sp_alter_column dbo,  Request ,VUserID_Ext ,VUserID_Ext,'nVarChar(50)','',0
GO
Exec sp_alter_column dbo,  Request ,AUserID_Ext_2 ,AUserID_Ext_2,'nVarChar(50)','',0
GO
Exec sp_alter_column dbo,  Request ,VUserID_Ext_2 ,VUserID_Ext_2,'nVarChar(50)','',0
GO
Exec sp_alter_column dbo,  Request ,UVUserID ,UVUserID,'nVarChar(50)','',0
GO
Exec sp_alter_column dbo,  Request ,UVUserID_Ext ,UVUserID_Ext,'nVarChar(50)','',0
GO
Exec sp_alter_column dbo,  Request ,UVUserID_Ext_2 ,UVUserID_Ext_2,'nVarChar(50)','',0
GO
Exec sp_alter_column dbo,  Request ,UAUserID ,UAUserID,'nVarChar(50)','',0
GO
Exec sp_alter_column dbo,  Request ,UAUserID_Ext ,UAUserID_Ext,'nVarChar(50)','',0
GO
Exec sp_alter_column dbo,  Request ,UAUserID_Ext_2 ,UAUserID_Ext_2,'nVarChar(50)','',0
GO
Exec sp_alter_column dbo,  RequestExt ,Ent_Address ,Ent_Address,'nVarChar(255)','',0
GO
Exec sp_alter_column dbo,  RequestExt ,Last_Opr ,Last_Opr,'nVarChar(50)','',0
GO
Exec sp_alter_column dbo,  RequestExt ,CoyName ,CoyName,'nVarChar(255)','',0
GO
Exec sp_alter_column dbo,  RequestExt ,Name ,Name,'nVarChar(255)','',0
GO
Exec sp_alter_column dbo,  RequestPic ,Last_Opr ,Last_Opr,'nVarChar(50)','',0
GO
Exec sp_alter_column dbo,  RequestPic ,UserID ,UserID,'nVarChar(50)','',0
GO
Exec sp_alter_column dbo,  RERATE ,Last_Opr ,Last_Opr,'nVarChar(50)','',0
GO
Exec sp_alter_column dbo,  REXCLA ,SHORTDESC ,SHORTDESC,'nVarChar(max)','',0
GO
Exec sp_alter_column dbo,  RISKASS ,HoldMessage ,HoldMessage,'nVarChar(512)','',0
GO
Exec sp_alter_column dbo,  RISKASS ,Last_Opr ,Last_Opr,'nVarChar(50)','',0
GO
Exec sp_alter_column dbo,  RLTable ,Last_Opr ,Last_Opr,'nVarChar(50)','',0
GO
Exec sp_alter_column dbo,  RLTableC ,Last_Opr ,Last_Opr,'nVarChar(50)','',0
GO
Exec sp_alter_column dbo,  RLTableH ,Description ,Description,'nVarChar(255)','',0
GO
Exec sp_alter_column dbo,  RLTableH ,Last_Opr ,Last_Opr,'nVarChar(50)','',0
GO
Exec sp_alter_column dbo,  RLTableR ,Last_Opr ,Last_Opr,'nVarChar(50)','',0
GO
Exec sp_alter_column dbo,  RPART ,Last_Opr ,Last_Opr,'nVarChar(50)','',0
GO
Exec sp_alter_column dbo,  RPART ,REMARKS ,REMARKS,'nVarChar(255)','',0
GO
Exec sp_alter_column dbo,  RPBucket ,pSLRef_Description_2 ,pSLRef_Description_2,'nVarChar(50)','',0
GO
Exec sp_alter_column dbo,  RPBucket ,BankName ,BankName,'nVarChar(255)','',0
GO
Exec sp_alter_column dbo,  RPBucket ,Last_Opr ,Last_Opr,'nVarChar(10)','',0
GO
Exec sp_alter_column dbo,  RPBucket ,pSLRef_Description_3 ,pSLRef_Description_3,'nVarChar(50)','',0
GO
Exec sp_alter_column dbo,  RPBucket ,pSLRef_Description_4 ,pSLRef_Description_4,'nVarChar(50)','',0
GO
Exec sp_alter_column dbo,  RPBucket ,pSLRef_Description_1 ,pSLRef_Description_1,'nVarChar(50)','',0
GO
Exec sp_alter_column dbo,  RPBucket ,pSLRef_Description_5 ,pSLRef_Description_5,'nVarChar(50)','',0
GO
Exec sp_alter_column dbo,  RPrintLog ,Description ,Description,'nVarChar(50)','',0
GO
Exec sp_alter_column dbo,  RPrintLog ,UserID ,UserID,'nVarChar(50)','',0
GO
Exec sp_alter_column dbo,  RQPrintLog ,Description ,Description,'nVarChar(50)','',0
GO
Exec sp_alter_column dbo,  RQPrintLog ,UserID ,UserID,'nVarChar(50)','',0
GO
Exec sp_alter_column dbo,  RTYPE ,Description ,Description,'nVarChar(20)','',0
GO
Exec sp_alter_column dbo,  SAccCA ,Address ,Address,'nVarChar(1024)','',0
GO
Exec sp_alter_column dbo,  SAccCA ,Email ,Email,'nVarChar(512)','',0
GO
Exec sp_alter_column dbo,  SAccDA ,Address ,Address,'nVarChar(1024)','',0
GO
Exec sp_alter_column dbo,  SAccDA ,Email ,Email,'nVarChar(512)','',0
GO
Exec sp_alter_column dbo,  SAccPic ,UserID ,UserID,'nVarChar(50)','',0
GO
Exec sp_alter_column dbo,  SAccPic ,Last_Opr ,Last_Opr,'nVarChar(50)','',0
GO
Exec sp_alter_column dbo,  SaldoAwalComAcc ,Description ,Description,'nVarChar(255)','',0
GO
Exec sp_alter_column dbo,  SAP_FSG_TABLE ,Description ,Description,'nVarChar(255)','',0
GO
Exec sp_alter_column dbo,  SAP_JOURNAL ,Description ,Description,'nVarChar(100)','',0
GO
Exec sp_alter_column dbo,  SAP_JOURNAL ,Last_Opr ,Last_Opr,'nVarChar(50)','',0
GO
Exec sp_alter_column dbo,  SAPLog ,FILENAME ,FILENAME,'nVarChar(255)','',0
GO
Exec sp_alter_column dbo,  SAPLogDetail ,DESCRIPTION ,DESCRIPTION,'nVarChar(255)','',0
GO
Exec sp_alter_column dbo,  ScaleTab ,Last_Opr ,Last_Opr,'nVarChar(50)','',0
GO
Exec sp_alter_column dbo,  SCGroup ,Description ,Description,'nVarChar(100)','',0
GO
Exec sp_alter_column dbo,  SCGroup ,Last_Opr ,Last_Opr,'nVarChar(50)','',0
GO
Exec sp_alter_column dbo,  Scheme_Additional ,Last_Opr ,Last_Opr,'nVarChar(50)','',0
GO
Exec sp_alter_column dbo,  Scheme_Assignment ,Last_Opr ,Last_Opr,'nVarChar(50)','',0
GO
Exec sp_alter_column dbo,  Scheme_Assignment ,Description ,Description,'nVarChar(100)','',0
GO
Exec sp_alter_column dbo,  Scheme_Beneficiary ,Name ,Name,'nVarChar(255)','',0
GO
Exec sp_alter_column dbo,  Scheme_Beneficiary ,Address_1 ,Address_1,'nVarChar(1024)','',0
GO
Exec sp_alter_column dbo,  Scheme_Beneficiary ,Address_2 ,Address_2,'nVarChar(1024)','',0
GO
Exec sp_alter_column dbo,  Scheme_Beneficiary ,REMARK ,REMARK,'nVarChar(255)','',0
GO
Exec sp_alter_column dbo,  Scheme_CA ,Address ,Address,'nVarChar(1024)','',0
GO
Exec sp_alter_column dbo,  Scheme_CA ,Email ,Email,'nVarChar(512)','',0
GO
Exec sp_alter_column dbo,  Scheme_Cla ,SHORTDESC ,SHORTDESC,'nVarChar(max)','',0
GO
Exec sp_alter_column dbo,  Scheme_Cla ,ShortDesc_1 ,ShortDesc_1,'nVarChar(max)','',0
GO
Exec sp_alter_column dbo,  Scheme_Class ,VALUEDESC2 ,VALUEDESC2,'nVarChar(255)','',0
GO
Exec sp_alter_column dbo,  Scheme_Class ,Last_Opr ,Last_Opr,'nVarChar(50)','',0
GO
Exec sp_alter_column dbo,  Scheme_Class ,VALUEDESC13 ,VALUEDESC13,'nVarChar(255)','',0
GO
Exec sp_alter_column dbo,  Scheme_Class ,VALUEDESC14 ,VALUEDESC14,'nVarChar(255)','',0
GO
Exec sp_alter_column dbo,  Scheme_Class ,VALUEDESC15 ,VALUEDESC15,'nVarChar(255)','',0
GO
Exec sp_alter_column dbo,  Scheme_Class ,Description ,Description,'nVarChar(100)','',0
GO
Exec sp_alter_column dbo,  Scheme_Class ,VALUEDESC1 ,VALUEDESC1,'nVarChar(255)','',0
GO
Exec sp_alter_column dbo,  Scheme_Class ,VALUEDESC5 ,VALUEDESC5,'nVarChar(255)','',0
GO
Exec sp_alter_column dbo,  Scheme_Class ,VALUEDESC6 ,VALUEDESC6,'nVarChar(255)','',0
GO
Exec sp_alter_column dbo,  Scheme_Class ,VALUEDESC7 ,VALUEDESC7,'nVarChar(255)','',0
GO
Exec sp_alter_column dbo,  Scheme_Class ,VALUEDESC12 ,VALUEDESC12,'nVarChar(255)','',0
GO
Exec sp_alter_column dbo,  Scheme_Class ,VALUEDESC3 ,VALUEDESC3,'nVarChar(255)','',0
GO
Exec sp_alter_column dbo,  Scheme_Class ,VALUEDESC4 ,VALUEDESC4,'nVarChar(255)','',0
GO
Exec sp_alter_column dbo,  Scheme_Class ,VALUEDESC9 ,VALUEDESC9,'nVarChar(255)','',0
GO
Exec sp_alter_column dbo,  Scheme_Class ,VALUEDESC11 ,VALUEDESC11,'nVarChar(255)','',0
GO
Exec sp_alter_column dbo,  Scheme_Class ,VALUEDESC8 ,VALUEDESC8,'nVarChar(255)','',0
GO
Exec sp_alter_column dbo,  Scheme_Class ,VALUEDESC10 ,VALUEDESC10,'nVarChar(255)','',0
GO
Exec sp_alter_column dbo,  Scheme_Con ,SHORTDESC ,SHORTDESC,'nVarChar(max)','',0
GO
Exec sp_alter_column dbo,  Scheme_Con ,ShortDesc_1 ,ShortDesc_1,'nVarChar(max)','',0
GO
Exec sp_alter_column dbo,  Scheme_Coverage ,Last_Opr ,Last_Opr,'nVarChar(50)','',0
GO
Exec sp_alter_column dbo,  Scheme_CoverageType ,Last_Opr ,Last_Opr,'nVarChar(50)','',0
GO
Exec sp_alter_column dbo,  Scheme_Deductible ,Last_Opr ,Last_Opr,'nVarChar(50)','',0
GO
Exec sp_alter_column dbo,  Scheme_Deductible ,REMARKS ,REMARKS,'nVarChar(2048)','',0
GO
Exec sp_alter_column dbo,  Scheme_Deductible ,REMARKS_1 ,REMARKS_1,'nVarChar(2048)','',0
GO
Exec sp_alter_column dbo,  Scheme_Detail ,DESCRIPTION ,DESCRIPTION,'nVarChar(255)','',0
GO
Exec sp_alter_column dbo,  Scheme_Endorsement ,Last_Opr ,Last_Opr,'nVarChar(50)','',0
GO
Exec sp_alter_column dbo,  Scheme_Ex ,SHORTDESC ,SHORTDESC,'nVarChar(max)','',0
GO
Exec sp_alter_column dbo,  Scheme_Ex ,ShortDesc_1 ,ShortDesc_1,'nVarChar(max)','',0
GO
Exec sp_alter_column dbo,  Scheme_Indemnity ,Last_Opr ,Last_Opr,'nVarChar(50)','',0
GO
Exec sp_alter_column dbo,  SCHEME_INPARTY ,Beneficiary_Name ,Beneficiary_Name,'nVarChar(255)','',0
GO
Exec sp_alter_column dbo,  SCHEME_INPARTY ,Name ,Name,'nVarChar(255)','',0
GO
Exec sp_alter_column dbo,  SCHEME_INPARTY ,Address_1 ,Address_1,'nVarChar(1024)','',0
GO
Exec sp_alter_column dbo,  SCHEME_INPARTY ,Address_2 ,Address_2,'nVarChar(1024)','',0
GO
Exec sp_alter_column dbo,  SCHEME_INPARTY ,REMARK ,REMARK,'nVarChar(255)','',0
GO
Exec sp_alter_column dbo,  Scheme_Interest ,Last_Opr ,Last_Opr,'nVarChar(50)','',0
GO
Exec sp_alter_column dbo,  Scheme_InterestType ,Last_Opr ,Last_Opr,'nVarChar(50)','',0
GO
Exec sp_alter_column dbo,  Scheme_Master ,Last_Opr ,Last_Opr,'nVarChar(50)','',0
GO
Exec sp_alter_column dbo,  Scheme_Master ,Description ,Description,'nVarChar(100)','',0
GO
Exec sp_alter_column dbo,  Scheme_Payor ,ADDRESS_1 ,ADDRESS_1,'nVarChar(1024)','',0
GO
Exec sp_alter_column dbo,  Scheme_Payor ,ADDRESS_2 ,ADDRESS_2,'nVarChar(1024)','',0
GO
Exec sp_alter_column dbo,  Scheme_Payor ,ADDRESS_3 ,ADDRESS_3,'nVarChar(1024)','',0
GO
Exec sp_alter_column dbo,  Scheme_Payor ,BankName ,BankName,'nVarChar(150)','',0
GO
Exec sp_alter_column dbo,  Scheme_Payor ,LUserID ,LUserID,'nVarChar(50)','',0
GO
Exec sp_alter_column dbo,  Scheme_Transaction ,VALUEDESC17 ,VALUEDESC17,'nVarChar(8000)','',0
GO
Exec sp_alter_column dbo,  Scheme_Transaction ,VALUEDESC19 ,VALUEDESC19,'nVarChar(8000)','',0
GO
Exec sp_alter_column dbo,  Scheme_Transaction ,VALUEDESC13 ,VALUEDESC13,'nVarChar(255)','',0
GO
Exec sp_alter_column dbo,  Scheme_Transaction ,Correspondence_Email ,Correspondence_Email,'nVarChar(50)','',0
GO
Exec sp_alter_column dbo,  Scheme_Transaction ,VALUEDESC18 ,VALUEDESC18,'nVarChar(8000)','',0
GO
Exec sp_alter_column dbo,  Scheme_Transaction ,VALUEDESC15 ,VALUEDESC15,'nVarChar(255)','',0
GO
Exec sp_alter_column dbo,  Scheme_Transaction ,VALUEDESC21 ,VALUEDESC21,'nVarChar(8000)','',0
GO
Exec sp_alter_column dbo,  Scheme_Transaction ,VALUEDESC20 ,VALUEDESC20,'nVarChar(8000)','',0
GO
Exec sp_alter_column dbo,  Scheme_Transaction ,VALUEDESC14 ,VALUEDESC14,'nVarChar(255)','',0
GO
Exec sp_alter_column dbo,  Scheme_Transaction ,VALUEDESC10 ,VALUEDESC10,'nVarChar(255)','',0
GO
Exec sp_alter_column dbo,  Scheme_Transaction ,VALUEDESC11 ,VALUEDESC11,'nVarChar(255)','',0
GO
Exec sp_alter_column dbo,  Scheme_Transaction ,VALUEDESC12 ,VALUEDESC12,'nVarChar(255)','',0
GO
Exec sp_alter_column dbo,  Scheme_Transaction ,VALUEDESC27 ,VALUEDESC27,'nVarChar(8000)','',0
GO
Exec sp_alter_column dbo,  Scheme_Transaction ,VALUEDESC9 ,VALUEDESC9,'nVarChar(255)','',0
GO
Exec sp_alter_column dbo,  Scheme_Transaction ,VALUEDESC7 ,VALUEDESC7,'nVarChar(255)','',0
GO
Exec sp_alter_column dbo,  Scheme_Transaction ,VALUEDESC8 ,VALUEDESC8,'nVarChar(255)','',0
GO
Exec sp_alter_column dbo,  Scheme_Transaction ,AName ,AName,'nVarChar(max)','',0
GO
Exec sp_alter_column dbo,  Scheme_Transaction ,VALUEDESC1 ,VALUEDESC1,'nVarChar(255)','',0
GO
Exec sp_alter_column dbo,  Scheme_Transaction ,LUserID ,LUserID,'nVarChar(50)','',0
GO
Exec sp_alter_column dbo,  Scheme_Transaction ,VALUEDESC ,VALUEDESC,'nVarChar(255)','',0
GO
Exec sp_alter_column dbo,  Scheme_Transaction ,Address ,Address,'nVarChar(1024)','',0
GO
Exec sp_alter_column dbo,  Scheme_Transaction ,Email ,Email,'nVarChar(512)','',0
GO
Exec sp_alter_column dbo,  Scheme_Transaction ,VALUEDESC16 ,VALUEDESC16,'nVarChar(8000)','',0
GO
Exec sp_alter_column dbo,  Scheme_Transaction ,REMARKS ,REMARKS,'nVarChar(255)','',0
GO
Exec sp_alter_column dbo,  Scheme_Transaction ,CUSERID ,CUSERID,'nVarChar(50)','',0
GO
Exec sp_alter_column dbo,  Scheme_Transaction ,RUSERID ,RUSERID,'nVarChar(50)','',0
GO
Exec sp_alter_column dbo,  Scheme_Transaction ,LOCATION ,LOCATION,'nVarChar(100)','',0
GO
Exec sp_alter_column dbo,  Scheme_Transaction ,Correspondence_Address ,Correspondence_Address,'nVarChar(255)','',0
GO
Exec sp_alter_column dbo,  Scheme_Transaction ,VALUEDESC24 ,VALUEDESC24,'nVarChar(8000)','',0
GO
Exec sp_alter_column dbo,  Scheme_Transaction ,VALUEDESC23 ,VALUEDESC23,'nVarChar(8000)','',0
GO
Exec sp_alter_column dbo,  Scheme_Transaction ,VALUEDESC25 ,VALUEDESC25,'nVarChar(8000)','',0
GO
Exec sp_alter_column dbo,  Scheme_Transaction ,VALUEDESC26 ,VALUEDESC26,'nVarChar(8000)','',0
GO
Exec sp_alter_column dbo,  Scheme_Transaction ,VALUEDESC2 ,VALUEDESC2,'nVarChar(255)','',0
GO
Exec sp_alter_column dbo,  Scheme_Transaction ,VALUEDESC29 ,VALUEDESC29,'nVarChar(8000)','',0
GO
Exec sp_alter_column dbo,  Scheme_Transaction ,VALUEDESC4 ,VALUEDESC4,'nVarChar(255)','',0
GO
Exec sp_alter_column dbo,  Scheme_Transaction ,VALUEDESC28 ,VALUEDESC28,'nVarChar(8000)','',0
GO
Exec sp_alter_column dbo,  Scheme_Transaction ,VALUEDESC3 ,VALUEDESC3,'nVarChar(255)','',0
GO
Exec sp_alter_column dbo,  Scheme_Transaction ,VALUEDESC30 ,VALUEDESC30,'nVarChar(8000)','',0
GO
Exec sp_alter_column dbo,  Scheme_Transaction ,VALUEDESC5 ,VALUEDESC5,'nVarChar(255)','',0
GO
Exec sp_alter_column dbo,  Scheme_Transaction ,VALUEDESC6 ,VALUEDESC6,'nVarChar(255)','',0
GO
Exec sp_alter_column dbo,  Scheme_Transaction ,VALUEDESC22 ,VALUEDESC22,'nVarChar(8000)','',0
GO
Exec sp_alter_column dbo,  Scheme_TransactionDet ,DESCRIPTION ,DESCRIPTION,'nVarChar(255)','',0
GO
Exec sp_alter_column dbo,  SCOINSURANCE ,LUserID ,LUserID,'nVarChar(50)','',0
GO
Exec sp_alter_column dbo,  SCOINSURANCE ,USERID ,USERID,'nVarChar(50)','',0
GO
Exec sp_alter_column dbo,  Scoring ,LAST_OPR ,LAST_OPR,'nVarChar(50)','',0
GO
Exec sp_alter_column dbo,  ScoringV ,LAST_OPR ,LAST_OPR,'nVarChar(50)','',0
GO
Exec sp_alter_column dbo,  SECTION ,Last_Opr ,Last_Opr,'nVarChar(50)','',0
GO
Exec sp_alter_column dbo,  SectionD ,Name ,Name,'nVarChar(255)','',0
GO
Exec sp_alter_column dbo,  SectionH ,Last_Opr ,Last_Opr,'nVarChar(10)','',0
GO
Exec sp_alter_column dbo,  SectionH ,Name ,Name,'nVarChar(255)','',0
GO
Exec sp_alter_column dbo,  Security ,Last_Opr ,Last_Opr,'nVarChar(50)','',0
GO
Exec sp_alter_column dbo,  Segment ,Last_Opr ,Last_Opr,'nVarChar(50)','',0
GO
Exec sp_alter_column dbo,  Segment ,Description ,Description,'nVarChar(255)','',0
GO
Exec sp_alter_column dbo,  Segment_AAUI ,Description ,Description,'nVarChar(255)','',0
GO
Exec sp_alter_column dbo,  Segment_AAUI ,Last_Opr ,Last_Opr,'nVarChar(50)','',0
GO
Exec sp_alter_column dbo,  SEGMENTGROUP ,Last_Opr ,Last_Opr,'nVarChar(50)','',0
GO
Exec sp_alter_column dbo,  SEGMENTGROUP ,DESCRIPTION ,DESCRIPTION,'nVarChar(100)','',0
GO
Exec sp_alter_column dbo,  Service ,Name ,Name,'nVarChar(255)','',0
GO
Exec sp_alter_column dbo,  Service ,Address_1 ,Address_1,'nVarChar(1024)','',0
GO
Exec sp_alter_column dbo,  Service ,Address_2 ,Address_2,'nVarChar(1024)','',0
GO
Exec sp_alter_column dbo,  Service ,BSName ,BSName,'nVarChar(255)','',0
GO
Exec sp_alter_column dbo,  Service ,USERID ,USERID,'nVarChar(50)','',0
GO
Exec sp_alter_column dbo,  Service ,LUSERID ,LUSERID,'nVarChar(50)','',0
GO
Exec sp_alter_column dbo,  Service ,REMARKS ,REMARKS,'nVarChar(255)','',0
GO
Exec sp_alter_column dbo,  Service ,CUSERID ,CUSERID,'nVarChar(50)','',0
GO
Exec sp_alter_column dbo,  Service ,AUSERID ,AUSERID,'nVarChar(50)','',0
GO
Exec sp_alter_column dbo,  Service ,PUserID ,PUserID,'nVarChar(50)','',0
GO
Exec sp_alter_column dbo,  Service ,VALUEDESC ,VALUEDESC,'nVarChar(255)','',0
GO
Exec sp_alter_column dbo,  Service ,RequestMessage ,RequestMessage,'nVarChar(512)','',0
GO
Exec sp_alter_column dbo,  Service ,RequestName ,RequestName,'nVarChar(50)','',0
GO
Exec sp_alter_column dbo,  Service ,RUserID ,RUserID,'nVarChar(50)','',0
GO
Exec sp_alter_column dbo,  Service ,ClaimantName ,ClaimantName,'nVarChar(255)','',0
GO
Exec sp_alter_column dbo,  Service ,ClaimantEmail ,ClaimantEmail,'nVarChar(255)','',0
GO
Exec sp_alter_column dbo,  Service ,Location ,Location,'nVarChar(10)','',0
GO
Exec sp_alter_column dbo,  Service ,Description ,Description,'nVarChar(max)','',0
GO
Exec sp_alter_column dbo,  Service ,SurveyLocation ,SurveyLocation,'nVarChar(255)','',0
GO
Exec sp_alter_column dbo,  Service ,Comment ,Comment,'nVarChar(max)','',0
GO
Exec sp_alter_column dbo,  Service ,PIC_NAME_1 ,PIC_NAME_1,'nVarChar(50)','',0
GO
Exec sp_alter_column dbo,  Service ,PIC_NAME_3 ,PIC_NAME_3,'nVarChar(50)','',0
GO
Exec sp_alter_column dbo,  Service ,PIC_NAME_2 ,PIC_NAME_2,'nVarChar(50)','',0
GO
Exec sp_alter_column dbo,  SFPART ,Remarks ,Remarks,'nVarChar(255)','',0
GO
Exec sp_alter_column dbo,  ShortPeriod ,Last_Opr ,Last_Opr,'nVarChar(10)','',0
GO
Exec sp_alter_column dbo,  SL_Cat ,Description ,Description,'nVarChar(30)','',0
GO
Exec sp_alter_column dbo,  SL_Request ,Description ,Description,'nVarChar(512)','',0
GO
Exec sp_alter_column dbo,  SL_RequestRef ,Description ,Description,'nVarChar(50)','',0
GO
Exec sp_alter_column dbo,  SPayor ,ADDRESS_1 ,ADDRESS_1,'nVarChar(1024)','',0
GO
Exec sp_alter_column dbo,  SPayor ,ADDRESS_2 ,ADDRESS_2,'nVarChar(1024)','',0
GO
Exec sp_alter_column dbo,  SPayor ,ADDRESS_3 ,ADDRESS_3,'nVarChar(1024)','',0
GO
Exec sp_alter_column dbo,  SPayor ,BankName ,BankName,'nVarChar(150)','',0
GO
Exec sp_alter_column dbo,  SPrintLog ,Description ,Description,'nVarChar(50)','',0
GO
Exec sp_alter_column dbo,  SPrintLog ,UserID ,UserID,'nVarChar(50)','',0
GO
Exec sp_alter_column dbo,  SRARRDET ,AUserID ,AUserID,'nVarChar(50)','',0
GO
Exec sp_alter_column dbo,  SRARRDET ,USERID ,USERID,'nVarChar(50)','',0
GO
Exec sp_alter_column dbo,  SRARRDET ,SysUserID ,SysUserID,'nVarChar(50)','',0
GO
Exec sp_alter_column dbo,  SRARRDET ,LUserID ,LUserID,'nVarChar(50)','',0
GO
Exec sp_alter_column dbo,  SubDistrict ,Last_OPR ,Last_OPR,'nVarChar(10)','',0
GO
Exec sp_alter_column dbo,  SUINFO ,VALUEDESC1 ,VALUEDESC1,'nVarChar(max)','',0
GO
Exec sp_alter_column dbo,  SUINFO ,VALUEDESC2 ,VALUEDESC2,'nVarChar(max)','',0
GO
Exec sp_alter_column dbo,  SUINFO ,VALUEDESC3 ,VALUEDESC3,'nVarChar(max)','',0
GO
Exec sp_alter_column dbo,  SUINFO ,VALUEDESC4 ,VALUEDESC4,'nVarChar(max)','',0
GO
Exec sp_alter_column dbo,  SUINFO ,VALUEDESC5 ,VALUEDESC5,'nVarChar(max)','',0
GO
Exec sp_alter_column dbo,  SUINFO ,VALUEDESC6 ,VALUEDESC6,'nVarChar(max)','',0
GO
Exec sp_alter_column dbo,  SUINFO ,VALUEDESC7 ,VALUEDESC7,'nVarChar(max)','',0
GO
Exec sp_alter_column dbo,  SUINFO ,VALUEDESC8 ,VALUEDESC8,'nVarChar(max)','',0
GO
Exec sp_alter_column dbo,  SUINFO ,VALUEDESC9 ,VALUEDESC9,'nVarChar(max)','',0
GO
Exec sp_alter_column dbo,  SUINFO ,VALUEDESC10 ,VALUEDESC10,'nVarChar(max)','',0
GO
Exec sp_alter_column dbo,  SUINFO ,VALUEDESC11 ,VALUEDESC11,'nVarChar(max)','',0
GO
Exec sp_alter_column dbo,  SUINFO ,VALUEDESC12 ,VALUEDESC12,'nVarChar(max)','',0
GO
Exec sp_alter_column dbo,  SUINFO ,VALUEDESC13 ,VALUEDESC13,'nVarChar(max)','',0
GO
Exec sp_alter_column dbo,  SUINFO ,VALUEDESC14 ,VALUEDESC14,'nVarChar(max)','',0
GO
Exec sp_alter_column dbo,  SUINFO ,VALUEDESC15 ,VALUEDESC15,'nVarChar(max)','',0
GO
Exec sp_alter_column dbo,  SURVEYOR ,REMARKS ,REMARKS,'nVarChar(255)','',0
GO
Exec sp_alter_column dbo,  SysBatchBE ,Correspondence_Email ,Correspondence_Email,'nVarChar(50)','',0
GO
Exec sp_alter_column dbo,  SysBatchBE_Ext ,Duty_Remark_1 ,Duty_Remark_1,'nVarChar(50)','',0
GO
Exec sp_alter_column dbo,  SysBatchH ,ProcName ,ProcName,'nVarChar(100)','',0
GO
Exec sp_alter_column dbo,  SysBatchOriginalBE ,CLADESCRIPTION_05 ,CLADESCRIPTION_05,'nVarChar(255)','',0
GO
Exec sp_alter_column dbo,  SysBatchOriginalBE ,CLADESCRIPTION_02 ,CLADESCRIPTION_02,'nVarChar(255)','',0
GO
Exec sp_alter_column dbo,  SysBatchOriginalBE ,Correspondence_Email ,Correspondence_Email,'nVarChar(50)','',0
GO
Exec sp_alter_column dbo,  SysBatchOriginalBE ,CLADESCRIPTION_07 ,CLADESCRIPTION_07,'nVarChar(255)','',0
GO
Exec sp_alter_column dbo,  SysBatchOriginalBE ,CLADESCRIPTION_14 ,CLADESCRIPTION_14,'nVarChar(255)','',0
GO
Exec sp_alter_column dbo,  SysBatchOriginalBE ,CLADESCRIPTION_11 ,CLADESCRIPTION_11,'nVarChar(255)','',0
GO
Exec sp_alter_column dbo,  SysBatchOriginalBE ,CLADESCRIPTION_13 ,CLADESCRIPTION_13,'nVarChar(255)','',0
GO
Exec sp_alter_column dbo,  SysBatchOriginalBE ,CLADESCRIPTION_10 ,CLADESCRIPTION_10,'nVarChar(255)','',0
GO
Exec sp_alter_column dbo,  SysBatchOriginalBE ,CLADESCRIPTION_01 ,CLADESCRIPTION_01,'nVarChar(255)','',0
GO
Exec sp_alter_column dbo,  SysBatchOriginalBE ,CLADESCRIPTION_04 ,CLADESCRIPTION_04,'nVarChar(255)','',0
GO
Exec sp_alter_column dbo,  SysBatchOriginalBE ,CLADESCRIPTION_12 ,CLADESCRIPTION_12,'nVarChar(255)','',0
GO
Exec sp_alter_column dbo,  SysBatchOriginalBE ,CLADESCRIPTION_15 ,CLADESCRIPTION_15,'nVarChar(255)','',0
GO
Exec sp_alter_column dbo,  SysBatchOriginalBE ,CLADESCRIPTION_03 ,CLADESCRIPTION_03,'nVarChar(255)','',0
GO
Exec sp_alter_column dbo,  SysBatchOriginalBE ,CLADESCRIPTION_09 ,CLADESCRIPTION_09,'nVarChar(255)','',0
GO
Exec sp_alter_column dbo,  SysBatchOriginalBE ,CLADESCRIPTION_08 ,CLADESCRIPTION_08,'nVarChar(255)','',0
GO
Exec sp_alter_column dbo,  SysBatchOriginalBE ,CLADESCRIPTION_06 ,CLADESCRIPTION_06,'nVarChar(255)','',0
GO
Exec sp_alter_column dbo,  SysBatchOriginalBE_Ext ,Duty_Remark_1 ,Duty_Remark_1,'nVarChar(50)','',0
GO
Exec sp_alter_column dbo,  SysBatchOriginalSC ,DESCRIPTION6 ,DESCRIPTION6,'nVarChar(8000)','',0
GO
Exec sp_alter_column dbo,  SysBatchOriginalSC ,DESCRIPTION9 ,DESCRIPTION9,'nVarChar(8000)','',0
GO
Exec sp_alter_column dbo,  SysBatchOriginalSC ,DESCRIPTION12 ,DESCRIPTION12,'nVarChar(8000)','',0
GO
Exec sp_alter_column dbo,  SysBatchOriginalSC ,DESCRIPTION3 ,DESCRIPTION3,'nVarChar(8000)','',0
GO
Exec sp_alter_column dbo,  SysBatchOriginalSC ,DESCRIPTION4 ,DESCRIPTION4,'nVarChar(8000)','',0
GO
Exec sp_alter_column dbo,  SysBatchOriginalSC ,ADDRESS_3 ,ADDRESS_3,'nVarChar(255)','',0
GO
Exec sp_alter_column dbo,  SysBatchOriginalSC ,DESCRIPTION1 ,DESCRIPTION1,'nVarChar(8000)','',0
GO
Exec sp_alter_column dbo,  SysBatchOriginalSC ,DESCRIPTION7 ,DESCRIPTION7,'nVarChar(8000)','',0
GO
Exec sp_alter_column dbo,  SysBatchOriginalSC ,ADDINTERESTREMARK3 ,ADDINTERESTREMARK3,'nVarChar(255)','',0
GO
Exec sp_alter_column dbo,  SysBatchOriginalSC ,location ,location,'nVarChar(255)','',0
GO
Exec sp_alter_column dbo,  SysBatchOriginalSC ,DESCRIPTION15 ,DESCRIPTION15,'nVarChar(8000)','',0
GO
Exec sp_alter_column dbo,  SysBatchOriginalSC ,ADDRESS_2 ,ADDRESS_2,'nVarChar(255)','',0
GO
Exec sp_alter_column dbo,  SysBatchOriginalSC ,DESCRIPTION5 ,DESCRIPTION5,'nVarChar(8000)','',0
GO
Exec sp_alter_column dbo,  SysBatchOriginalSC ,ADDRESS_1 ,ADDRESS_1,'nVarChar(255)','',0
GO
Exec sp_alter_column dbo,  SysBatchOriginalSC ,Correspondence_Address ,Correspondence_Address,'nVarChar(255)','',0
GO
Exec sp_alter_column dbo,  SysBatchOriginalSC ,ADDINTERESTREMARK5 ,ADDINTERESTREMARK5,'nVarChar(255)','',0
GO
Exec sp_alter_column dbo,  SysBatchOriginalSC ,DESCRIPTION14 ,DESCRIPTION14,'nVarChar(8000)','',0
GO
Exec sp_alter_column dbo,  SysBatchOriginalSC ,DESCRIPTION11 ,DESCRIPTION11,'nVarChar(8000)','',0
GO
Exec sp_alter_column dbo,  SysBatchOriginalSC ,ADDINTERESTREMARK2 ,ADDINTERESTREMARK2,'nVarChar(255)','',0
GO
Exec sp_alter_column dbo,  SysBatchOriginalSC ,Email ,Email,'nVarChar(512)','',0
GO
Exec sp_alter_column dbo,  SysBatchOriginalSC ,DESCRIPTION8 ,DESCRIPTION8,'nVarChar(8000)','',0
GO
Exec sp_alter_column dbo,  SysBatchOriginalSC ,ADDINTERESTREMARK4 ,ADDINTERESTREMARK4,'nVarChar(255)','',0
GO
Exec sp_alter_column dbo,  SysBatchOriginalSC ,ADDINTERESTREMARK1 ,ADDINTERESTREMARK1,'nVarChar(255)','',0
GO
Exec sp_alter_column dbo,  SysBatchOriginalSC ,Correspondence_Email ,Correspondence_Email,'nVarChar(50)','',0
GO
Exec sp_alter_column dbo,  SysBatchOriginalSC ,DESCRIPTION10 ,DESCRIPTION10,'nVarChar(8000)','',0
GO
Exec sp_alter_column dbo,  SysBatchOriginalSC ,REMARKS ,REMARKS,'nVarChar(255)','',0
GO
Exec sp_alter_column dbo,  SysBatchOriginalSC ,DESCRIPTION13 ,DESCRIPTION13,'nVarChar(8000)','',0
GO
Exec sp_alter_column dbo,  SysBatchOriginalSC ,DESCRIPTION2 ,DESCRIPTION2,'nVarChar(8000)','',0
GO
Exec sp_alter_column dbo,  SysBatchOriginalUp ,Email ,Email,'nVarChar(512)','',0
GO
Exec sp_alter_column dbo,  SysBatchOriginalUp_Ext ,Maincoverageremarks ,Maincoverageremarks,'nVarChar(50)','',0
GO
Exec sp_alter_column dbo,  SysBatchOriginalUp_Ext ,Duty_remark_3 ,Duty_remark_3,'nVarChar(255)','',0
GO
Exec sp_alter_column dbo,  SysBatchOriginalUp_Ext ,Duty_remark_2 ,Duty_remark_2,'nVarChar(255)','',0
GO
Exec sp_alter_column dbo,  SysBatchSC ,DESCRIPTION5 ,DESCRIPTION5,'nVarChar(8000)','',0
GO
Exec sp_alter_column dbo,  SysBatchSC ,DESCRIPTION2 ,DESCRIPTION2,'nVarChar(8000)','',0
GO
Exec sp_alter_column dbo,  SysBatchSC ,DESCRIPTION8 ,DESCRIPTION8,'nVarChar(8000)','',0
GO
Exec sp_alter_column dbo,  SysBatchSC ,ADDRESS_2 ,ADDRESS_2,'nVarChar(255)','',0
GO
Exec sp_alter_column dbo,  SysBatchSC ,DESCRIPTION11 ,DESCRIPTION11,'nVarChar(8000)','',0
GO
Exec sp_alter_column dbo,  SysBatchSC ,DESCRIPTION4 ,DESCRIPTION4,'nVarChar(8000)','',0
GO
Exec sp_alter_column dbo,  SysBatchSC ,DESCRIPTION10 ,DESCRIPTION10,'nVarChar(8000)','',0
GO
Exec sp_alter_column dbo,  SysBatchSC ,DESCRIPTION13 ,DESCRIPTION13,'nVarChar(8000)','',0
GO
Exec sp_alter_column dbo,  SysBatchSC ,Email ,Email,'nVarChar(512)','',0
GO
Exec sp_alter_column dbo,  SysBatchSC ,Correspondence_Email ,Correspondence_Email,'nVarChar(50)','',0
GO
Exec sp_alter_column dbo,  SysBatchSC ,DESCRIPTION7 ,DESCRIPTION7,'nVarChar(8000)','',0
GO
Exec sp_alter_column dbo,  SysBatchSC ,ADDRESS_1 ,ADDRESS_1,'nVarChar(255)','',0
GO
Exec sp_alter_column dbo,  SysBatchSC ,location ,location,'nVarChar(255)','',0
GO
Exec sp_alter_column dbo,  SysBatchSC ,DESCRIPTION3 ,DESCRIPTION3,'nVarChar(8000)','',0
GO
Exec sp_alter_column dbo,  SysBatchSC ,DESCRIPTION6 ,DESCRIPTION6,'nVarChar(8000)','',0
GO
Exec sp_alter_column dbo,  SysBatchSC ,REMARKS ,REMARKS,'nVarChar(255)','',0
GO
Exec sp_alter_column dbo,  SysBatchSC ,Correspondence_Address ,Correspondence_Address,'nVarChar(255)','',0
GO
Exec sp_alter_column dbo,  SysBatchSC ,DESCRIPTION14 ,DESCRIPTION14,'nVarChar(8000)','',0
GO
Exec sp_alter_column dbo,  SysBatchSC ,DESCRIPTION1 ,DESCRIPTION1,'nVarChar(8000)','',0
GO
Exec sp_alter_column dbo,  SysBatchSC ,DESCRIPTION12 ,DESCRIPTION12,'nVarChar(8000)','',0
GO
Exec sp_alter_column dbo,  SysBatchSC ,ADDRESS_3 ,ADDRESS_3,'nVarChar(255)','',0
GO
Exec sp_alter_column dbo,  SysBatchSC ,DESCRIPTION9 ,DESCRIPTION9,'nVarChar(8000)','',0
GO
Exec sp_alter_column dbo,  SysBatchSC ,DESCRIPTION15 ,DESCRIPTION15,'nVarChar(8000)','',0
GO
Exec sp_alter_column dbo,  SysBatchUp ,Email ,Email,'nVarChar(512)','',0
GO
Exec sp_alter_column dbo,  SysBatchUp ,Description17 ,Description17,'nVarChar(255)','',0
GO
Exec sp_alter_column dbo,  SysBatchUp ,Description20 ,Description20,'nVarChar(255)','',0
GO
Exec sp_alter_column dbo,  SysBatchUp ,DESCRIPTION23 ,DESCRIPTION23,'nVarChar(255)','',0
GO
Exec sp_alter_column dbo,  SysBatchUp ,DESCRIPTION26 ,DESCRIPTION26,'nVarChar(255)','',0
GO
Exec sp_alter_column dbo,  SysBatchUp ,DeclareDescription ,DeclareDescription,'nVarChar(255)','',0
GO
Exec sp_alter_column dbo,  SysBatchUp ,Description28 ,Description28,'nVarChar(255)','',0
GO
Exec sp_alter_column dbo,  SysBatchUp ,Correspondence_Email ,Correspondence_Email,'nVarChar(50)','',0
GO
Exec sp_alter_column dbo,  SysBatchUp ,DESCRIPTION25 ,DESCRIPTION25,'nVarChar(255)','',0
GO
Exec sp_alter_column dbo,  SysBatchUp ,DESCRIPTION24 ,DESCRIPTION24,'nVarChar(255)','',0
GO
Exec sp_alter_column dbo,  SysBatchUp ,Description16 ,Description16,'nVarChar(255)','',0
GO
Exec sp_alter_column dbo,  SysBatchUp ,Description19 ,Description19,'nVarChar(255)','',0
GO
Exec sp_alter_column dbo,  SysBatchUp ,DESCRIPTION21 ,DESCRIPTION21,'nVarChar(255)','',0
GO
Exec sp_alter_column dbo,  SysBatchUp ,Description29 ,Description29,'nVarChar(255)','',0
GO
Exec sp_alter_column dbo,  SysBatchUp ,Description30 ,Description30,'nVarChar(255)','',0
GO
Exec sp_alter_column dbo,  SysBatchUp ,Description27 ,Description27,'nVarChar(255)','',0
GO
Exec sp_alter_column dbo,  SysBatchUp ,DESCRIPTION22 ,DESCRIPTION22,'nVarChar(255)','',0
GO
Exec sp_alter_column dbo,  SysBatchUp ,Description18 ,Description18,'nVarChar(255)','',0
GO
Exec sp_alter_column dbo,  SysBatchUp_Ext ,REMARKS6 ,REMARKS6,'nVarChar(8000)','',0
GO
Exec sp_alter_column dbo,  SysBatchUp_Ext ,REMARKS7 ,REMARKS7,'nVarChar(8000)','',0
GO
Exec sp_alter_column dbo,  SysBatchUp_Ext ,ADDCOVERAGEREMARK7 ,ADDCOVERAGEREMARK7,'nVarChar(8000)','',0
GO
Exec sp_alter_column dbo,  SysBatchUp_Ext ,ADDCOVERAGEREMARK12 ,ADDCOVERAGEREMARK12,'nVarChar(8000)','',0
GO
Exec sp_alter_column dbo,  SysBatchUp_Ext ,REMARKS4 ,REMARKS4,'nVarChar(8000)','',0
GO
Exec sp_alter_column dbo,  SysBatchUp_Ext ,InParty_Address2 ,InParty_Address2,'nVarChar(8000)','',0
GO
Exec sp_alter_column dbo,  SysBatchUp_Ext ,OP_REMARK2 ,OP_REMARK2,'nVarChar(8000)','',0
GO
Exec sp_alter_column dbo,  SysBatchUp_Ext ,InParty_Remark2 ,InParty_Remark2,'nVarChar(8000)','',0
GO
Exec sp_alter_column dbo,  SysBatchUp_Ext ,REMARKS1 ,REMARKS1,'nVarChar(8000)','',0
GO
Exec sp_alter_column dbo,  SysBatchUp_Ext ,CADDRESS ,CADDRESS,'nVarChar(50)','',0
GO
Exec sp_alter_column dbo,  SysBatchUp_Ext ,beneficiaries_Address3 ,beneficiaries_Address3,'nVarChar(8000)','',0
GO
Exec sp_alter_column dbo,  SysBatchUp_Ext ,ADDINTERESTREMARK5 ,ADDINTERESTREMARK5,'nVarChar(8000)','',0
GO
Exec sp_alter_column dbo,  SysBatchUp_Ext ,Address_2 ,Address_2,'nVarChar(8000)','',0
GO
Exec sp_alter_column dbo,  SysBatchUp_Ext ,MAINCOVERAGEREMARK1 ,MAINCOVERAGEREMARK1,'nVarChar(8000)','',0
GO
Exec sp_alter_column dbo,  SysBatchUp_Ext ,FEE_REMARK ,FEE_REMARK,'nVarChar(8000)','',0
GO
Exec sp_alter_column dbo,  SysBatchUp_Ext ,ADDINTERESTREMARK10 ,ADDINTERESTREMARK10,'nVarChar(8000)','',0
GO
Exec sp_alter_column dbo,  SysBatchUp_Ext ,MAINCOVERAGEREMARK4 ,MAINCOVERAGEREMARK4,'nVarChar(8000)','',0
GO
Exec sp_alter_column dbo,  SysBatchUp_Ext ,MAINCOVERAGEREMARK5 ,MAINCOVERAGEREMARK5,'nVarChar(8000)','',0
GO
Exec sp_alter_column dbo,  SysBatchUp_Ext ,ADDCOVERAGEREMARK1 ,ADDCOVERAGEREMARK1,'nVarChar(8000)','',0
GO
Exec sp_alter_column dbo,  SysBatchUp_Ext ,ADDCOVERAGEREMARK15 ,ADDCOVERAGEREMARK15,'nVarChar(8000)','',0
GO
Exec sp_alter_column dbo,  SysBatchUp_Ext ,HolderAddress_2 ,HolderAddress_2,'nVarChar(8000)','',0
GO
Exec sp_alter_column dbo,  SysBatchUp_Ext ,ADDINTERESTREMARK3 ,ADDINTERESTREMARK3,'nVarChar(8000)','',0
GO
Exec sp_alter_column dbo,  SysBatchUp_Ext ,InsuredAddress_2 ,InsuredAddress_2,'nVarChar(8000)','',0
GO
Exec sp_alter_column dbo,  SysBatchUp_Ext ,MAININTERESTREMARK ,MAININTERESTREMARK,'nVarChar(8000)','',0
GO
Exec sp_alter_column dbo,  SysBatchUp_Ext ,ICoverDetDescription1 ,ICoverDetDescription1,'nVarChar(8000)','',0
GO
Exec sp_alter_column dbo,  SysBatchUp_Ext ,Correspondence_Address ,Correspondence_Address,'nVarChar(8000)','',0
GO
Exec sp_alter_column dbo,  SysBatchUp_Ext ,ADDINTERESTREMARK8 ,ADDINTERESTREMARK8,'nVarChar(8000)','',0
GO
Exec sp_alter_column dbo,  SysBatchUp_Ext ,RISKLOCATIONREMARK ,RISKLOCATIONREMARK,'nVarChar(8000)','',0
GO
Exec sp_alter_column dbo,  SysBatchUp_Ext ,MAINCOVERAGEREMARK2 ,MAINCOVERAGEREMARK2,'nVarChar(8000)','',0
GO
Exec sp_alter_column dbo,  SysBatchUp_Ext ,DUTY_REMARK ,DUTY_REMARK,'nVarChar(8000)','',0
GO
Exec sp_alter_column dbo,  SysBatchUp_Ext ,REMARKS11 ,REMARKS11,'nVarChar(8000)','',0
GO
Exec sp_alter_column dbo,  SysBatchUp_Ext ,ICoverDetDescription2 ,ICoverDetDescription2,'nVarChar(50)','',0
GO
Exec sp_alter_column dbo,  SysBatchUp_Ext ,InParty_Address1 ,InParty_Address1,'nVarChar(50)','',0
GO
Exec sp_alter_column dbo,  SysBatchUp_Ext ,Remarks10 ,Remarks10,'nVarChar(8000)','',0
GO
Exec sp_alter_column dbo,  SysBatchUp_Ext ,ADDCOVERAGEREMARK4 ,ADDCOVERAGEREMARK4,'nVarChar(8000)','',0
GO
Exec sp_alter_column dbo,  SysBatchUp_Ext ,Address_3 ,Address_3,'nVarChar(8000)','',0
GO
Exec sp_alter_column dbo,  SysBatchUp_Ext ,ADDCOVERAGEREMARK3 ,ADDCOVERAGEREMARK3,'nVarChar(8000)','',0
GO
Exec sp_alter_column dbo,  SysBatchUp_Ext ,ADDINTERESTREMARK2 ,ADDINTERESTREMARK2,'nVarChar(8000)','',0
GO
Exec sp_alter_column dbo,  SysBatchUp_Ext ,InsuredAddress_1 ,InsuredAddress_1,'nVarChar(8000)','',0
GO
Exec sp_alter_column dbo,  SysBatchUp_Ext ,Maincoverageremarks ,Maincoverageremarks,'nVarChar(50)','',0
GO
Exec sp_alter_column dbo,  SysBatchUp_Ext ,REMARKS ,REMARKS,'nVarChar(8000)','',0
GO
Exec sp_alter_column dbo,  SysBatchUp_Ext ,beneficiaries_Address1 ,beneficiaries_Address1,'nVarChar(8000)','',0
GO
Exec sp_alter_column dbo,  SysBatchUp_Ext ,ADDCOVERAGEREMARK5 ,ADDCOVERAGEREMARK5,'nVarChar(8000)','',0
GO
Exec sp_alter_column dbo,  SysBatchUp_Ext ,OP_REMARK1 ,OP_REMARK1,'nVarChar(8000)','',0
GO
Exec sp_alter_column dbo,  SysBatchUp_Ext ,MAINCOVERAGEREMARK ,MAINCOVERAGEREMARK,'nVarChar(8000)','',0
GO
Exec sp_alter_column dbo,  SysBatchUp_Ext ,InParty_Remark1 ,InParty_Remark1,'nVarChar(8000)','',0
GO
Exec sp_alter_column dbo,  SysBatchUp_Ext ,InParty_Address3 ,InParty_Address3,'nVarChar(8000)','',0
GO
Exec sp_alter_column dbo,  SysBatchUp_Ext ,REMARKS8 ,REMARKS8,'nVarChar(8000)','',0
GO
Exec sp_alter_column dbo,  SysBatchUp_Ext ,REMARKS3 ,REMARKS3,'nVarChar(8000)','',0
GO
Exec sp_alter_column dbo,  SysBatchUp_Ext ,ADDCOVERAGEREMARK17 ,ADDCOVERAGEREMARK17,'nVarChar(8000)','',0
GO
Exec sp_alter_column dbo,  SysBatchUp_Ext ,ADDCOVERAGEREMARK9 ,ADDCOVERAGEREMARK9,'nVarChar(8000)','',0
GO
Exec sp_alter_column dbo,  SysBatchUp_Ext ,Address_1 ,Address_1,'nVarChar(8000)','',0
GO
Exec sp_alter_column dbo,  SysBatchUp_Ext ,ADDCOVERAGEREMARK14 ,ADDCOVERAGEREMARK14,'nVarChar(8000)','',0
GO
Exec sp_alter_column dbo,  SysBatchUp_Ext ,ADDCOVERAGEREMARK6 ,ADDCOVERAGEREMARK6,'nVarChar(8000)','',0
GO
Exec sp_alter_column dbo,  SysBatchUp_Ext ,ADDINTERESTREMARK7 ,ADDINTERESTREMARK7,'nVarChar(8000)','',0
GO
Exec sp_alter_column dbo,  SysBatchUp_Ext ,ADDCOVERAGEREMARK8 ,ADDCOVERAGEREMARK8,'nVarChar(8000)','',0
GO
Exec sp_alter_column dbo,  SysBatchUp_Ext ,ICoverDetDescription3 ,ICoverDetDescription3,'nVarChar(8000)','',0
GO
Exec sp_alter_column dbo,  SysBatchUp_Ext ,ADDCOVERAGEREMARK11 ,ADDCOVERAGEREMARK11,'nVarChar(8000)','',0
GO
Exec sp_alter_column dbo,  SysBatchUp_Ext ,HolderAddress_1 ,HolderAddress_1,'nVarChar(8000)','',0
GO
Exec sp_alter_column dbo,  SysBatchUp_Ext ,InParty_Remark3 ,InParty_Remark3,'nVarChar(8000)','',0
GO
Exec sp_alter_column dbo,  SysBatchUp_Ext ,REMARKS2 ,REMARKS2,'nVarChar(8000)','',0
GO
Exec sp_alter_column dbo,  SysBatchUp_Ext ,ADDCOVERAGEREMARK13 ,ADDCOVERAGEREMARK13,'nVarChar(8000)','',0
GO
Exec sp_alter_column dbo,  SysBatchUp_Ext ,REMARKS5 ,REMARKS5,'nVarChar(8000)','',0
GO
Exec sp_alter_column dbo,  SysBatchUp_Ext ,beneficiaries_Address2 ,beneficiaries_Address2,'nVarChar(8000)','',0
GO
Exec sp_alter_column dbo,  SysBatchUp_Ext ,ICoverDetDescription4 ,ICoverDetDescription4,'nVarChar(8000)','',0
GO
Exec sp_alter_column dbo,  SysBatchUp_Ext ,ADDCOVERAGEREMARK19 ,ADDCOVERAGEREMARK19,'nVarChar(8000)','',0
GO
Exec sp_alter_column dbo,  SysBatchUp_Ext ,ADDCOVERAGEREMARK10 ,ADDCOVERAGEREMARK10,'nVarChar(8000)','',0
GO
Exec sp_alter_column dbo,  SysBatchUp_Ext ,ADDCOVERAGEREMARK18 ,ADDCOVERAGEREMARK18,'nVarChar(8000)','',0
GO
Exec sp_alter_column dbo,  SysBatchUp_Ext ,ADDINTERESTREMARK6 ,ADDINTERESTREMARK6,'nVarChar(8000)','',0
GO
Exec sp_alter_column dbo,  SysBatchUp_Ext ,InsuredAddress_3 ,InsuredAddress_3,'nVarChar(8000)','',0
GO
Exec sp_alter_column dbo,  SysBatchUp_Ext ,ADDINTERESTREMARK1 ,ADDINTERESTREMARK1,'nVarChar(8000)','',0
GO
Exec sp_alter_column dbo,  SysBatchUp_Ext ,MAINCOVERAGEREMARK3 ,MAINCOVERAGEREMARK3,'nVarChar(8000)','',0
GO
Exec sp_alter_column dbo,  SysBatchUp_Ext ,ADDINTERESTREMARK9 ,ADDINTERESTREMARK9,'nVarChar(8000)','',0
GO
Exec sp_alter_column dbo,  SysBatchUp_Ext ,ADDCOVERAGEREMARK2 ,ADDCOVERAGEREMARK2,'nVarChar(8000)','',0
GO
Exec sp_alter_column dbo,  SysBatchUp_Ext ,ADDINTERESTREMARK4 ,ADDINTERESTREMARK4,'nVarChar(8000)','',0
GO
Exec sp_alter_column dbo,  SysBatchUp_Ext ,ADDCOVERAGEREMARK16 ,ADDCOVERAGEREMARK16,'nVarChar(8000)','',0
GO
Exec sp_alter_column dbo,  SysBatchUp_Ext ,HolderAddress_3 ,HolderAddress_3,'nVarChar(8000)','',0
GO
Exec sp_alter_column dbo,  SysBatchUp_Ext ,ICoverDetDescription5 ,ICoverDetDescription5,'nVarChar(8000)','',0
GO
Exec sp_alter_column dbo,  SysCategory ,DESCRIPTION ,DESCRIPTION,'nVarChar(255)','',0
GO
Exec sp_alter_column dbo,  SysCategory ,Last_Opr ,Last_Opr,'nVarChar(50)','',0
GO
Exec sp_alter_column dbo,  SysClass ,Last_Opr ,Last_Opr,'nVarChar(50)','',0
GO
Exec sp_alter_column dbo,  SysClass ,DESCRIPTION ,DESCRIPTION,'nVarChar(255)','',0
GO
Exec sp_alter_column dbo,  SysDocType ,DocLocation ,DocLocation,'nVarChar(512)','',0
GO
Exec sp_alter_column dbo,  SysForm ,FName ,FName,'nVarChar(50)','',0
GO
Exec sp_alter_column dbo,  SysForm ,Description ,Description,'nVarChar(255)','',0
GO
Exec sp_alter_column dbo,  SysFormWeb ,FName ,FName,'nVarChar(25)','',0
GO
Exec sp_alter_column dbo,  SysGroup ,Description ,Description,'nVarChar(255)','',0
GO
Exec sp_alter_column dbo,  SysGroup ,Last_Opr ,Last_Opr,'nVarChar(50)','',0
GO
Exec sp_alter_column dbo,  SysInforce ,ProcName ,ProcName,'nVarChar(50)','',0
GO
Exec sp_alter_column dbo,  SysInforce ,Remarks ,Remarks,'nVarChar(100)','',0
GO
Exec sp_alter_column dbo,  SysInforce ,UserID ,UserID,'nVarChar(50)','',0
GO
Exec sp_alter_column dbo,  SysLockedObject ,ObjName ,ObjName,'nVarChar(50)','',0
GO
Exec sp_alter_column dbo,  SysLogDownload ,FILENAME ,FILENAME,'nVarChar(255)','',0
GO
Exec sp_alter_column dbo,  SysLogDownload ,USERID ,USERID,'nVarChar(50)','',0
GO
Exec sp_alter_column dbo,  SysLogDownload ,LUSERID ,LUSERID,'nVarChar(50)','',0
GO
Exec sp_alter_column dbo,  SysLogDownLoadImage ,USERID ,USERID,'nVarChar(50)','',0
GO
Exec sp_alter_column dbo,  SysLoginUsers ,UserHostName ,UserHostName,'nVarChar(50)','',0
GO
Exec sp_alter_column dbo,  SysLogObject ,Remarks ,Remarks,'nVarChar(max)','',0
GO
Exec sp_alter_column dbo,  SysLogObject ,ColName ,ColName,'nVarChar(50)','',0
GO
Exec sp_alter_column dbo,  SysLogObject ,Last_Opr ,Last_Opr,'nVarChar(50)','',0
GO
Exec sp_alter_column dbo,  SysLogObject ,LogName ,LogName,'nVarChar(50)','',0
GO
Exec sp_alter_column dbo,  SysLogoutUsers ,UserHostName ,UserHostName,'nVarChar(50)','',0
GO
Exec sp_alter_column dbo,  SysLogProcess ,UserID ,UserID,'nVarChar(50)','',0
GO
Exec sp_alter_column dbo,  SysLogProcess ,ProcName ,ProcName,'nVarChar(100)','',0
GO
Exec sp_alter_column dbo,  SysLogReport ,Remarks ,Remarks,'nVarChar(512)','',0
GO
Exec sp_alter_column dbo,  SysLogReport ,EXENAME ,EXENAME,'nVarChar(255)','',0
GO
Exec sp_alter_column dbo,  SysLogReport ,Description ,Description,'nVarChar(255)','',0
GO
Exec sp_alter_column dbo,  SysLogReport ,UserID ,UserID,'nVarChar(50)','',0
GO
Exec sp_alter_column dbo,  SysLogReport ,REPNAME ,REPNAME,'nVarChar(20)','',0
GO
Exec sp_alter_column dbo,  SysLogReportBatchScreening ,Remarks ,Remarks,'nVarChar(512)','',0
GO
Exec sp_alter_column dbo,  SysLogReportBatchScreening ,EXENAME ,EXENAME,'nVarChar(255)','',0
GO
Exec sp_alter_column dbo,  SysLogReportBatchScreening ,UserID ,UserID,'nVarChar(50)','',0
GO
Exec sp_alter_column dbo,  SysLogReportBatchScreening ,Description ,Description,'nVarChar(255)','',0
GO
Exec sp_alter_column dbo,  SysLogReportBatchScreening ,REPNAME ,REPNAME,'nVarChar(50)','',0
GO
Exec sp_alter_column dbo,  SysProcess ,MainProcName ,MainProcName,'nVarChar(100)','',0
GO
Exec sp_alter_column dbo,  SysProcess ,ProcName ,ProcName,'nVarChar(100)','',0
GO
Exec sp_alter_column dbo,  SysProcess ,UserID ,UserID,'nVarChar(50)','',0
GO
Exec sp_alter_column dbo,  SysProcess ,Last_Opr ,Last_Opr,'nVarChar(50)','',0
GO
Exec sp_alter_column dbo,  SysProcH ,ExeName ,ExeName,'nVarChar(100)','',0
GO
Exec sp_alter_column dbo,  SysProcH ,UserID ,UserID,'nVarChar(50)','',0
GO
Exec sp_alter_column dbo,  SysProcID ,REPNAME ,REPNAME,'nVarChar(20)','',0
GO
Exec sp_alter_column dbo,  SysProcID ,EXENAME ,EXENAME,'nVarChar(255)','',0
GO
Exec sp_alter_column dbo,  SysProcID ,SERVICENAME ,SERVICENAME,'nVarChar(100)','',0
GO
Exec sp_alter_column dbo,  SysProcID ,DESCRIPTION ,DESCRIPTION,'nVarChar(255)','',0
GO
Exec sp_alter_column dbo,  SysProcID ,VALUEDESC1 ,VALUEDESC1,'nVarChar(255)','',0
GO
Exec sp_alter_column dbo,  SysProcID ,VALUEDESC2 ,VALUEDESC2,'nVarChar(255)','',0
GO
Exec sp_alter_column dbo,  SysProcID ,VALUEDESC3 ,VALUEDESC3,'nVarChar(255)','',0
GO
Exec sp_alter_column dbo,  SysProcID ,VALUEDESC4 ,VALUEDESC4,'nVarChar(255)','',0
GO
Exec sp_alter_column dbo,  SysProcID ,VALUEDESC5 ,VALUEDESC5,'nVarChar(255)','',0
GO
Exec sp_alter_column dbo,  SysProcID ,VALUEDESC6 ,VALUEDESC6,'nVarChar(255)','',0
GO
Exec sp_alter_column dbo,  SysProcID ,VALUEDESC7 ,VALUEDESC7,'nVarChar(255)','',0
GO
Exec sp_alter_column dbo,  SysProcID ,VALUEDESC8 ,VALUEDESC8,'nVarChar(255)','',0
GO
Exec sp_alter_column dbo,  SysProcID ,VALUEDESC9 ,VALUEDESC9,'nVarChar(255)','',0
GO
Exec sp_alter_column dbo,  SysProcID ,VALUEDESC10 ,VALUEDESC10,'nVarChar(255)','',0
GO
Exec sp_alter_column dbo,  SysProcID ,VALUEDESC11 ,VALUEDESC11,'nVarChar(255)','',0
GO
Exec sp_alter_column dbo,  SysProcID ,VALUEDESC12 ,VALUEDESC12,'nVarChar(255)','',0
GO
Exec sp_alter_column dbo,  SysProcID ,VALUEDESC13 ,VALUEDESC13,'nVarChar(255)','',0
GO
Exec sp_alter_column dbo,  SysProcID ,VALUEDESC14 ,VALUEDESC14,'nVarChar(255)','',0
GO
Exec sp_alter_column dbo,  SysProcID ,VALUEDESC15 ,VALUEDESC15,'nVarChar(255)','',0
GO
Exec sp_alter_column dbo,  SysProcID ,Last_Opr ,Last_Opr,'nVarChar(50)','',0
GO
Exec sp_alter_column dbo,  SysProclib ,ProcName ,ProcName,'nVarChar(100)','',0
GO
Exec sp_alter_column dbo,  SysQuery ,SQLName ,SQLName,'nVarChar(255)','',0
GO
Exec sp_alter_column dbo,  SysQuery ,AuthorName ,AuthorName,'nVarChar(100)','',0
GO
Exec sp_alter_column dbo,  SysReport ,RepName ,RepName,'nVarChar(20)','',0
GO
Exec sp_alter_column dbo,  SysReport ,Description ,Description,'nVarChar(255)','',0
GO
Exec sp_alter_column dbo,  SysReportDefinitions ,ClassDescription ,ClassDescription,'nVarChar(255)','',0
GO
Exec sp_alter_column dbo,  SysReportDefinitions ,RepName ,RepName,'nVarChar(278)','',0
GO
Exec sp_alter_column dbo,  SysReportDefinitions ,Description ,Description,'nVarChar(255)','',0
GO
Exec sp_alter_column dbo,  SysRequest ,ProcName ,ProcName,'nVarChar(50)','',0
GO
Exec sp_alter_column dbo,  SysRequest ,Remarks ,Remarks,'nVarChar(max)','',0
GO
Exec sp_alter_column dbo,  SysRequest ,ApprovedFName ,ApprovedFName,'nVarChar(50)','',0
GO
Exec sp_alter_column dbo,  SysRequest ,UserID ,UserID,'nVarChar(50)','',0
GO
Exec sp_alter_column dbo,  SysRequest ,LUserID ,LUserID,'nVarChar(50)','',0
GO
Exec sp_alter_column dbo,  SysSeqNo ,ObjName ,ObjName,'nVarChar(50)','',0
GO
Exec sp_alter_column dbo,  SysSeqNo_Ex ,Remarks ,Remarks,'nVarChar(255)','',0
GO
Exec sp_alter_column dbo,  SysSeqNo_Ex ,ObjName ,ObjName,'nVarChar(50)','',0
GO
Exec sp_alter_column dbo,  SysTab ,Name_2 ,Name_2,'nVarChar(50)','',0
GO
Exec sp_alter_column dbo,  SysTab ,r_sName ,r_sName,'nVarChar(50)','',0
GO
Exec sp_alter_column dbo,  SysTab ,r_dbName ,r_dbName,'nVarChar(50)','',0
GO
Exec sp_alter_column dbo,  SysTab ,SMTPEMail ,SMTPEMail,'nVarChar(255)','',0
GO
Exec sp_alter_column dbo,  SysTab ,CompanyAddress ,CompanyAddress,'nVarChar(255)','',0
GO
Exec sp_alter_column dbo,  SysTab ,LogoName ,LogoName,'nVarChar(255)','',0
GO
Exec sp_alter_column dbo,  SysTab ,LogoName_Ext ,LogoName_Ext,'nVarChar(255)','',0
GO
Exec sp_alter_column dbo,  SysTab ,Name_1 ,Name_1,'nVarChar(50)','',0
GO
Exec sp_alter_column dbo,  SysTab ,db_Name ,db_Name,'nVarChar(50)','',0
GO
Exec sp_alter_column dbo,  SysUpload ,ProcName ,ProcName,'nVarChar(50)','',0
GO
Exec sp_alter_column dbo,  SysUpload ,UserID ,UserID,'nVarChar(50)','',0
GO
Exec sp_alter_column dbo,  SysUpload ,Remarks ,Remarks,'nVarChar(100)','',0
GO
Exec sp_alter_column dbo,  SysUser ,Last_Opr ,Last_Opr,'nVarChar(50)','',0
GO
Exec sp_alter_column dbo,  SysUser ,Name ,Name,'nVarChar(30)','',0
GO
Exec sp_alter_column dbo,  SysUser ,EMail ,EMail,'nVarChar(512)','',0
GO
Exec sp_alter_column dbo,  SysUser ,LOCATION ,LOCATION,'nVarChar(10)','',0
GO
Exec sp_alter_column dbo,  SysUser ,SignerName ,SignerName,'nVarChar(255)','',0
GO
Exec sp_alter_column dbo,  SysUser ,CUserID ,CUserID,'nVarChar(50)','',0
GO
Exec sp_alter_column dbo,  SysUserActivity ,last_login_Address ,last_login_Address,'nVarChar(20)','',0
GO
Exec sp_alter_column dbo,  SysUserActivity ,UserHostName ,UserHostName,'nVarChar(50)','',0
GO
Exec sp_alter_column dbo,  SysUserAssignment ,Description ,Description,'nVarChar(100)','',0
GO
Exec sp_alter_column dbo,  SysUserDelegation ,Description ,Description,'nVarChar(100)','',0
GO
Exec sp_alter_column dbo,  SysUserForm ,FName ,FName,'nVarChar(50)','',0
GO
Exec sp_alter_column dbo,  SysUserGrants ,FName ,FName,'nVarChar(50)','',0
GO
Exec sp_alter_column dbo,  SysUserGroup ,UserID ,UserID,'nVarChar(50)','',0
GO
Exec sp_alter_column dbo,  SysUserGroup ,Last_Opr ,Last_Opr,'nVarChar(50)','',0
GO
Exec sp_alter_column dbo,  SysUserHostName ,UserHostName ,UserHostName,'nVarChar(50)','',0
GO
Exec sp_alter_column dbo,  SysUserType ,Description ,Description,'nVarChar(50)','',0
GO
Exec sp_alter_column dbo,  SysUserTypeTOCTOL ,VALUEDESC12 ,VALUEDESC12,'nVarChar(255)','',0
GO
Exec sp_alter_column dbo,  SysUserTypeTOCTOL ,VALUEDESC11 ,VALUEDESC11,'nVarChar(255)','',0
GO
Exec sp_alter_column dbo,  SysUserTypeTOCTOL ,VALUEDESC10 ,VALUEDESC10,'nVarChar(255)','',0
GO
Exec sp_alter_column dbo,  SysUserTypeTOCTOL ,VALUEDESC14 ,VALUEDESC14,'nVarChar(255)','',0
GO
Exec sp_alter_column dbo,  SysUserTypeTOCTOL ,VALUEDESC5 ,VALUEDESC5,'nVarChar(255)','',0
GO
Exec sp_alter_column dbo,  SysUserTypeTOCTOL ,VALUEDESC13 ,VALUEDESC13,'nVarChar(255)','',0
GO
Exec sp_alter_column dbo,  SysUserTypeTOCTOL ,VALUEDESC7 ,VALUEDESC7,'nVarChar(255)','',0
GO
Exec sp_alter_column dbo,  SysUserTypeTOCTOL ,VALUEDESC6 ,VALUEDESC6,'nVarChar(255)','',0
GO
Exec sp_alter_column dbo,  SysUserTypeTOCTOL ,Last_Opr ,Last_Opr,'nVarChar(50)','',0
GO
Exec sp_alter_column dbo,  SysUserTypeTOCTOL ,VALUEDESC8 ,VALUEDESC8,'nVarChar(255)','',0
GO
Exec sp_alter_column dbo,  SysUserTypeTOCTOL ,VALUEDESC9 ,VALUEDESC9,'nVarChar(255)','',0
GO
Exec sp_alter_column dbo,  SysUserTypeTOCTOL ,VALUEDESC15 ,VALUEDESC15,'nVarChar(255)','',0
GO
Exec sp_alter_column dbo,  SysUserTypeTOCTOL ,VALUEDESC4 ,VALUEDESC4,'nVarChar(255)','',0
GO
Exec sp_alter_column dbo,  SysUserTypeTOCTOL ,VALUEDESC2 ,VALUEDESC2,'nVarChar(255)','',0
GO
Exec sp_alter_column dbo,  SysUserTypeTOCTOL ,VALUEDESC3 ,VALUEDESC3,'nVarChar(255)','',0
GO
Exec sp_alter_column dbo,  SysUserTypeTOCTOL ,VALUEDESC1 ,VALUEDESC1,'nVarChar(255)','',0
GO
Exec sp_alter_column dbo,  SysVerify ,FileName ,FileName,'nVarChar(255)','',0
GO
Exec sp_alter_column dbo,  T_SAP_CODE ,Country_Name ,Country_Name,'nVarChar(255)','',0
GO
Exec sp_alter_column dbo,  TaxCode ,Description ,Description,'nVarChar(255)','',0
GO
Exec sp_alter_column dbo,  TAXTYPE ,DESCRIPTION ,DESCRIPTION,'nVarChar(500)','',0
GO
Exec sp_alter_column dbo,  TC ,ShortDesc ,ShortDesc,'nVarChar(8000)','',0
GO
Exec sp_alter_column dbo,  TC ,Last_Opr ,Last_Opr,'nVarChar(10)','',0
GO
Exec sp_alter_column dbo,  tCOVER ,USERID ,USERID,'nVarChar(10)','',0
GO
Exec sp_alter_column dbo,  tCOVER ,LUSERID ,LUSERID,'nVarChar(10)','',0
GO
Exec sp_alter_column dbo,  tCOVER ,AUSERID ,AUSERID,'nVarChar(10)','',0
GO
Exec sp_alter_column dbo,  tCOVER ,CUserID ,CUserID,'nVarChar(10)','',0
GO
Exec sp_alter_column dbo,  tCOVER ,PUserID ,PUserID,'nVarChar(10)','',0
GO
Exec sp_alter_column dbo,  TOC ,DESCRIPTION ,DESCRIPTION,'nVarChar(50)','',0
GO
Exec sp_alter_column dbo,  TOC ,VATDESCRIPTION ,VATDESCRIPTION,'nVarChar(255)','',0
GO
Exec sp_alter_column dbo,  TOC ,RegisteredName ,RegisteredName,'nVarChar(255)','',0
GO
Exec sp_alter_column dbo,  TOC ,RegisteredDescription ,RegisteredDescription,'nVarChar(512)','',0
GO
Exec sp_alter_column dbo,  TOC ,Last_Opr ,Last_Opr,'nVarChar(50)','',0
GO
Exec sp_alter_column dbo,  TOCGROUP ,DESCRIPTION ,DESCRIPTION,'nVarChar(100)','',0
GO
Exec sp_alter_column dbo,  TOCGROUP ,Last_Opr ,Last_Opr,'nVarChar(50)','',0
GO
Exec sp_alter_column dbo,  TOI ,Last_Opr ,Last_Opr,'nVarChar(50)','',0
GO
Exec sp_alter_column dbo,  TOI ,DESCRIPTION ,DESCRIPTION,'nVarChar(8000)','',0
GO
Exec sp_alter_column dbo,  TOIVALUE ,VALUEDESC1 ,VALUEDESC1,'nVarChar(255)','',0
GO
Exec sp_alter_column dbo,  TOIVALUE ,VALUEDESC2 ,VALUEDESC2,'nVarChar(255)','',0
GO
Exec sp_alter_column dbo,  TOIVALUE ,VALUEDESC3 ,VALUEDESC3,'nVarChar(255)','',0
GO
Exec sp_alter_column dbo,  TOIVALUE ,VALUEDESC4 ,VALUEDESC4,'nVarChar(255)','',0
GO
Exec sp_alter_column dbo,  TOIVALUE ,VALUEDESC5 ,VALUEDESC5,'nVarChar(255)','',0
GO
Exec sp_alter_column dbo,  TOIVALUE ,VALUEDESC6 ,VALUEDESC6,'nVarChar(255)','',0
GO
Exec sp_alter_column dbo,  TOIVALUE ,VALUEDESC7 ,VALUEDESC7,'nVarChar(255)','',0
GO
Exec sp_alter_column dbo,  TOIVALUE ,VALUEDESC8 ,VALUEDESC8,'nVarChar(255)','',0
GO
Exec sp_alter_column dbo,  TOIVALUE ,VALUEDESC9 ,VALUEDESC9,'nVarChar(255)','',0
GO
Exec sp_alter_column dbo,  TOIVALUE ,VALUEDESC10 ,VALUEDESC10,'nVarChar(255)','',0
GO
Exec sp_alter_column dbo,  TOIVALUE ,VALUEDESC11 ,VALUEDESC11,'nVarChar(255)','',0
GO
Exec sp_alter_column dbo,  TOIVALUE ,VALUEDESC12 ,VALUEDESC12,'nVarChar(255)','',0
GO
Exec sp_alter_column dbo,  TOIVALUE ,VALUEDESC13 ,VALUEDESC13,'nVarChar(255)','',0
GO
Exec sp_alter_column dbo,  TOIVALUE ,VALUEDESC14 ,VALUEDESC14,'nVarChar(255)','',0
GO
Exec sp_alter_column dbo,  TOIVALUE ,VALUEDESC15 ,VALUEDESC15,'nVarChar(255)','',0
GO
Exec sp_alter_column dbo,  TOIVALUE ,AUserID ,AUserID,'nVarChar(50)','',0
GO
Exec sp_alter_column dbo,  TOIVALUE ,Last_Opr ,Last_Opr,'nVarChar(50)','',0
GO
Exec sp_alter_column dbo,  TOL ,Last_Opr ,Last_Opr,'nVarChar(50)','',0
GO
Exec sp_alter_column dbo,  TOP_CLA ,SHORTDESC ,SHORTDESC,'nVarChar(max)','',0
GO
Exec sp_alter_column dbo,  TOP_CLA ,ShortDesc_1 ,ShortDesc_1,'nVarChar(max)','',0
GO
Exec sp_alter_column dbo,  TOP_CON ,SHORTDESC ,SHORTDESC,'nVarChar(max)','',0
GO
Exec sp_alter_column dbo,  TOP_CON ,ShortDesc_1 ,ShortDesc_1,'nVarChar(max)','',0
GO
Exec sp_alter_column dbo,  TOP_Deductible ,REMARKS ,REMARKS,'nVarChar(2048)','',0
GO
Exec sp_alter_column dbo,  TOP_Deductible ,REMARKS_1 ,REMARKS_1,'nVarChar(2048)','',0
GO
Exec sp_alter_column dbo,  TOP_Deductible ,Last_Opr ,Last_Opr,'nVarChar(50)','',0
GO
Exec sp_alter_column dbo,  TOP_EX ,ShortDesc_1 ,ShortDesc_1,'nVarChar(max)','',0
GO
Exec sp_alter_column dbo,  TOP_EX ,SHORTDESC ,SHORTDESC,'nVarChar(max)','',0
GO
Exec sp_alter_column dbo,  TOP_FD ,REMARK ,REMARK,'nVarChar(50)','',0
GO
Exec sp_alter_column dbo,  TOP_FD ,Last_Opr ,Last_Opr,'nVarChar(50)','',0
GO
Exec sp_alter_column dbo,  TOP_Interest ,Last_Opr ,Last_Opr,'nVarChar(50)','',0
GO
Exec sp_alter_column dbo,  TOP_NOC ,Description ,Description,'nVarChar(255)','',0
GO
Exec sp_alter_column dbo,  TOP_Rate ,Last_Opr ,Last_Opr,'nVarChar(50)','',0
GO
Exec sp_alter_column dbo,  TOP_RTERM ,Last_Opr ,Last_Opr,'nVarChar(50)','',0
GO
Exec sp_alter_column dbo,  TOP_SECTION ,SHORTDESC ,SHORTDESC,'nVarChar(255)','',0
GO
Exec sp_alter_column dbo,  TOPRO ,Description ,Description,'nVarChar(255)','',0
GO
Exec sp_alter_column dbo,  TOPRO ,Last_Opr ,Last_Opr,'nVarChar(50)','',0
GO
Exec sp_alter_column dbo,  TOPRO_RATECON ,HoldMessage ,HoldMessage,'nVarChar(512)','',0
GO
Exec sp_alter_column dbo,  TOPRO_RATECON ,Last_Opr ,Last_Opr,'nVarChar(50)','',0
GO
Exec sp_alter_column dbo,  TOPRO_RATECON ,VALUEDESC1 ,VALUEDESC1,'nVarChar(255)','',0
GO
Exec sp_alter_column dbo,  TOPRO_RATECON ,VALUEDESC2 ,VALUEDESC2,'nVarChar(255)','',0
GO
Exec sp_alter_column dbo,  TOPRO_RATECON ,VALUEDESC3 ,VALUEDESC3,'nVarChar(255)','',0
GO
Exec sp_alter_column dbo,  TOPRO_RATECON ,VALUEDESC4 ,VALUEDESC4,'nVarChar(255)','',0
GO
Exec sp_alter_column dbo,  TOPRO_RATECON ,VALUEDESC5 ,VALUEDESC5,'nVarChar(255)','',0
GO
Exec sp_alter_column dbo,  TOPRO_RATECON ,VALUEDESC6 ,VALUEDESC6,'nVarChar(255)','',0
GO
Exec sp_alter_column dbo,  TOPRO_RATECON ,VALUEDESC7 ,VALUEDESC7,'nVarChar(255)','',0
GO
Exec sp_alter_column dbo,  TOPRO_RATECON ,VALUEDESC8 ,VALUEDESC8,'nVarChar(255)','',0
GO
Exec sp_alter_column dbo,  TOPRO_RATECON ,VALUEDESC9 ,VALUEDESC9,'nVarChar(255)','',0
GO
Exec sp_alter_column dbo,  TOPRO_RATECON ,VALUEDESC10 ,VALUEDESC10,'nVarChar(255)','',0
GO
Exec sp_alter_column dbo,  TOPRO_RATECON ,VALUEDESC11 ,VALUEDESC11,'nVarChar(255)','',0
GO
Exec sp_alter_column dbo,  TOPRO_RATECON ,VALUEDESC12 ,VALUEDESC12,'nVarChar(255)','',0
GO
Exec sp_alter_column dbo,  TOPRO_RATECON ,VALUEDESC13 ,VALUEDESC13,'nVarChar(255)','',0
GO
Exec sp_alter_column dbo,  TOPRO_RATECON ,VALUEDESC14 ,VALUEDESC14,'nVarChar(255)','',0
GO
Exec sp_alter_column dbo,  TOPRO_RATECON ,VALUEDESC15 ,VALUEDESC15,'nVarChar(255)','',0
GO
Exec sp_alter_column dbo,  TOR ,DESCRIPTION ,DESCRIPTION,'nVarChar(255)','',0
GO
Exec sp_alter_column dbo,  TOR ,Last_Opr ,Last_Opr,'nVarChar(50)','',0
GO
Exec sp_alter_column dbo,  TORSUB ,Last_Opr ,Last_Opr,'nVarChar(50)','',0
GO
Exec sp_alter_column dbo,  TType ,Description ,Description,'nVarChar(50)','',0
GO
Exec sp_alter_column dbo,  TType ,Location ,Location,'nVarChar(10)','',0
GO
Exec sp_alter_column dbo,  Type ,Description ,Description,'nVarChar(20)','',0
GO
Exec sp_alter_column dbo,  Type ,Last_Opr ,Last_Opr,'nVarChar(50)','',0
GO
Exec sp_alter_column dbo,  Unit ,Last_Opr ,Last_Opr,'nVarChar(10)','',0
GO
Exec sp_alter_column dbo,  Unit ,Description ,Description,'nVarChar(255)','',0
GO
Exec sp_alter_column dbo,  UploadFile ,Name ,Name,'nVarChar(255)','',0
GO
Exec sp_alter_column dbo,  UploadFile ,Remarks ,Remarks,'nVarChar(255)','',0
GO
Exec sp_alter_column dbo,  UploadProvider ,Name ,Name,'nVarChar(255)','',0
GO
Exec sp_alter_column dbo,  VAccount ,BankName ,BankName,'nVarChar(255)','',0
GO
Exec sp_alter_column dbo,  VAccount ,LAST_OPR ,LAST_OPR,'nVarChar(50)','',0
GO
Exec sp_alter_column dbo,  VAccountD ,Last_Opr ,Last_Opr,'nVarChar(50)','',0
GO
Exec sp_alter_column dbo,  VDOCLIST ,LAST_OPR ,LAST_OPR,'nVarChar(50)','',0
GO
Exec sp_alter_column dbo,  VDOCLIST ,DESCRIPTION ,DESCRIPTION,'nVarChar(255)','',0
GO
Exec sp_alter_column dbo,  VDOCLIST ,REMARKS ,REMARKS,'nVarChar(512)','',0
GO
Exec sp_alter_column dbo,  VDOCLISTPIC ,Remark ,Remark,'nVarChar(max)','',0
GO
Exec sp_alter_column dbo,  VDOCLISTPIC ,Last_Opr ,Last_Opr,'nVarChar(50)','',0
GO
Exec sp_alter_column dbo,  Village ,Last_OPR ,Last_OPR,'nVarChar(10)','',0
GO
Exec sp_alter_column dbo,  VLinkPrintLogH ,Description ,Description,'nVarChar(50)','',0
GO
Exec sp_alter_column dbo,  VLinkPrintLogH ,UserID ,UserID,'nVarChar(10)','',0
GO
Exec sp_alter_column dbo,  VoucherLinkH ,Remarks ,Remarks,'nVarChar(255)','',0
GO
Exec sp_alter_column dbo,  VoucherLinkH ,UserID ,UserID,'nVarChar(10)','',0
GO
Exec sp_alter_column dbo,  VoucherPic ,UserID ,UserID,'nVarChar(50)','',0
GO
Exec sp_alter_column dbo,  VoucherPic ,Last_Opr ,Last_Opr,'nVarChar(50)','',0
GO
Exec sp_alter_column dbo,  VPrintLog ,Description ,Description,'nVarChar(50)','',0
GO
Exec sp_alter_column dbo,  VPrintLog ,UserID ,UserID,'nVarChar(50)','',0
GO
Exec sp_alter_column dbo,  vType ,Description ,Description,'nVarChar(100)','',0
GO
Exec sp_alter_column dbo,  vType ,Last_Opr ,Last_Opr,'nVarChar(50)','',0
GO
Exec sp_alter_column dbo,  Wording ,Last_Opr ,Last_Opr,'nVarChar(50)','',0
GO
Exec sp_alter_column dbo,  Wording ,ShortDesc ,ShortDesc,'nVarChar(255)','',0
GO
