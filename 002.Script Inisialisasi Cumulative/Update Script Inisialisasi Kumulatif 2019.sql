set transaction isolation level read uncommitted
-- Kumulatif 2019 V.2.0
UPDATE XACCOUNT SET ShariaF = 0 WHERE ShariaF is null
UPDATE XACCOUNT SET GeneratedF = 0 WHERE GeneratedF is null
go
Update TOC Set CLPaymentInvoiceF=0 Where CLPaymentInvoiceF is null
GO
Update Reinsurance Set CashLossCombine=0 Where CashLossCombine is null
GO
Update Payor Set IRate=0 Where IRate is null
GO
Update APayor Set IRate=0 Where IRate is null
GO


-- Shrinking LOG 
-- GANTI SEA_RAMA_ORI DENGAN DATABASE CLIENT

USE SEA_RAMA_ORI;
GO
-- Truncate the log by changing the database recovery model to SIMPLE.
ALTER DATABASE SEA_RAMA_ORI
SET RECOVERY SIMPLE;
GO
-- Shrink the truncated log file to 1 MB.
DBCC SHRINKFILE (SEASQL_Log, 1);
GO
-- Reset the database recovery model.
ALTER DATABASE SEA_RAMA_ORI
SET RECOVERY FULL;
GO

Update APayor Set ScheduleF=0 Where ScheduleF is null
GO
Update Payor Set DecreaseF=0 Where DecreaseF is null
GO
Update APayor Set DecreaseF=0 Where DecreaseF is null
GO


-- Shrinking LOG 
-- GANTI SEA_RAMA_ORI DENGAN DATABASE CLIENT

USE SEA_RAMA_ORI;
GO
-- Truncate the log by changing the database recovery model to SIMPLE.
ALTER DATABASE SEA_RAMA_ORI
SET RECOVERY SIMPLE;
GO
-- Shrink the truncated log file to 1 MB.
DBCC SHRINKFILE (SEASQL_Log, 1);
GO
-- Reset the database recovery model.
ALTER DATABASE SEA_RAMA_ORI
SET RECOVERY FULL;
GO

Update pSL Set FundingF=0 Where FundingF is null
GO
Update SL_Request Set FundingF=0 Where FundingF is null
GO
Update FSecurity Set Limit=0, Excess=0 from FSecurity Where Limit Is null
GO
Update Excel Set CT_ROw=0, CT_Col=0 Where CT_Row is null
GO
Update APDRuleD Set Version='' Where Version is null
GO
Update APDRuleD Set PrintLogoF=0 Where PrintLogoF is null
GO
Update TOP_RATE Set FilterCode=Case When PolicyYear=0 Then Code Else Code+'/'+cast(PolicyYear as varchar(2)) End from TOP_RATE WHere FilterCode is null
GO


-- Shrinking LOG 
-- GANTI SEA_RAMA_ORI DENGAN DATABASE CLIENT

USE SEA_RAMA_ORI;
GO
-- Truncate the log by changing the database recovery model to SIMPLE.
ALTER DATABASE SEA_RAMA_ORI
SET RECOVERY SIMPLE;
GO
-- Shrink the truncated log file to 1 MB.
DBCC SHRINKFILE (SEASQL_Log, 1);
GO
-- Reset the database recovery model.
ALTER DATABASE SEA_RAMA_ORI
SET RECOVERY FULL;
GO

-- Kumulatif 2019 V.1.1
Update APDRuleD 
Set
	CoverCStatus=S.CoverCStatus,
	AccAType=S.AccAType,
	AccAStatus=S.AccAStatus,
	ClaimCType=S.ClaimCType,
	ClaimCStatus=S.ClaimCStatus,
	CoverNoteF=S.CoverNoteF,
	OpenFlag=S.OpenFlag,
	AdjustableF=S.AdjustableF,
	RenewalF=S.RenewalF,
	CertificateF=S.CertificateF,
	PCoverNoteF=S.PCoverNoteF,
	MasterF=S.MasterF,
	ClaimRejectedF=S.ClaimRejectedF
	from APDRuleD, SysClass S Where S.Class=APDRuleD.Class and APDRuleD.CoverCStatus is null
GO
Update VAccountD Set IMessage='' Where IMEssage is null
GO
Update BRRule Set AutoGenerateAutoPaymentF=0 Where AutoGenerateAutoPaymentF is null
GO
Update COLLTYPE set TOC='' Where TOC is null
GO
Update VAccountD Set LIMessage='' WHere LIMessage is null
Update VAccountD Set Nominal=0 WHere Nominal is null
GO
Update SysUserForm Set ModifyF=0 Where ModifyF is null
GO
Update SysUserGrants Set ModifyF=0 Where ModifyF is null
GO
Update SysTab Set XOLReinstatementByAmountF=0 Where XOLReinstatementByAmountF is null
GO
UPDATE GENHTAB SET ISTYPEF=0 WHERE ISTYPEF IS NULL
GO
Update SysUserComAcc Set AllowedF=1 Where AllowedF is null
Update SysUserComAcc Set ChangeF=1 Where ChangeF is null
GO
UPDATE BIZMAP SET ALLOWEDF=1 WHERE ALLOWEDF IS NULL
GO


-- Shrinking LOG 
-- GANTI SEA_RAMA_ORI DENGAN DATABASE CLIENT

USE SEA_RAMA_ORI;
GO
-- Truncate the log by changing the database recovery model to SIMPLE.
ALTER DATABASE SEA_RAMA_ORI
SET RECOVERY SIMPLE;
GO
-- Shrink the truncated log file to 1 MB.
DBCC SHRINKFILE (SEASQL_Log, 1);
GO
-- Reset the database recovery model.
ALTER DATABASE SEA_RAMA_ORI
SET RECOVERY FULL;
GO
UPDATE ADMLINK SET BIZMAPID=ACCASS.BIZMAPID from Admlink, AccAss Where AccAss.AdmNo=Admlink.AdmNo and Admlink.BizmapID is null
UPDATE ADMLINK SET BIZMAPID=CLAASS.BIZMAPID from Admlink, CLAASS Where CLAASS.AdmNo=Admlink.AdmNo and Admlink.BizmapID is null
go


-- Shrinking LOG 
-- GANTI SEA_RAMA_ORI DENGAN DATABASE CLIENT

USE SEA_RAMA_ORI;
GO
-- Truncate the log by changing the database recovery model to SIMPLE.
ALTER DATABASE SEA_RAMA_ORI
SET RECOVERY SIMPLE;
GO
-- Shrink the truncated log file to 1 MB.
DBCC SHRINKFILE (SEASQL_Log, 1);
GO
-- Reset the database recovery model.
ALTER DATABASE SEA_RAMA_ORI
SET RECOVERY FULL;
GO
UPDATE TOC SET CDDAYS=14 WHERE CDDAYS IS NULL
GO
UPDATE TOP_Deductible Set Section='' Where Section is null
GO
Update TOC SEt AutoEmailClaimProcessF=0 WHere AutoEmailClaimProcessF is null
Update TOC SEt AutoEmailRenewalNoticeF=0 WHere AutoEmailRenewalNoticeF is null
Update TOC SEt AutoEmailPolicyExpiredF=0 WHere AutoEmailPolicyExpiredF is null
go
IF EXISTS(SELECT * FROM SYSTAB WHERE Currency_1=Currency) 
BEGIN
Update SysTab Set Currency_1=Currency
Update nVoucher Set Rate_RC=Rate
Update pVoucher Set Rate_RC=Rate
Update mVoucher set Rate_RC=Rate
END
GO


-- Shrinking LOG 
-- GANTI SEA_RAMA_ORI DENGAN DATABASE CLIENT

USE SEA_RAMA_ORI;
GO
-- Truncate the log by changing the database recovery model to SIMPLE.
ALTER DATABASE SEA_RAMA_ORI
SET RECOVERY SIMPLE;
GO
-- Shrink the truncated log file to 1 MB.
DBCC SHRINKFILE (SEASQL_Log, 1);
GO
-- Reset the database recovery model.
ALTER DATABASE SEA_RAMA_ORI
SET RECOVERY FULL;
GO

Update TOP_Rate set PolicyYear=0 Where PolicyYear is null
GO

update sysuseractivity set userhostname=''
go
Update CLLOSS set IStatus='F' Where IStatus is null
go




-- Kumulatif 2019 V.1.0
Update TOP_NOC set MaxQty=0, MaxFreq=0 from TOP_NOC where MaxQty Is null
GO
Update ICoverNOC SEt MaxQty=0, MaxFreq=0 from ICoverNOC Where MaxQTY is null
GO
Update NOC Set MaxQty=0, MaxFreq=0 from NOC Where MaxQty Is null
GO
Update Asset set OAsset='' Where OAsset is null
Update A2 Set OAsset=A1.Asset
from Asset A1, Asset A2
Where A1.Asset=A2.pAsset and A1.pAsset=''

Update A2 Set OAsset=A1.OAsset
from Asset A1, Asset A2
Where A1.Asset=A2.pAsset and A1.OAsset<>'' and A2.OAsset=''

Update A2 Set OAsset=A1.OAsset
from Asset A1, Asset A2
Where A1.Asset=A2.pAsset and A1.OAsset<>'' and A2.OAsset=''

Update A2 Set OAsset=A1.OAsset
from Asset A1, Asset A2
Where A1.Asset=A2.pAsset and A1.OAsset<>'' and A2.OAsset=''

Update Asset set OAsset=Asset Where OAsset=''
GO


-- Shrinking LOG 
-- GANTI SEA_RAMA_ORI DENGAN DATABASE CLIENT

USE SEA_RAMA_ORI;
GO
-- Truncate the log by changing the database recovery model to SIMPLE.
ALTER DATABASE SEA_RAMA_ORI
SET RECOVERY SIMPLE;
GO
-- Shrink the truncated log file to 1 MB.
DBCC SHRINKFILE (SEASQL_Log, 1);
GO
-- Reset the database recovery model.
ALTER DATABASE SEA_RAMA_ORI
SET RECOVERY FULL;
GO

Update Scheme_Indemnity Set ProgressiveF=0 Where ProgressiveF is null
GO
Update Scheme_Master Set OverwriteRefPremiumF=0 Where OverwriteRefPremiumF is null
GO
Update ICalc Set Loading=0 Where Loading Is Null
GO

Update RCalc Set Loading=0 Where Loading Is Null
GO
Update PCalc Set Loading=0 Where Loading Is Null
GO
Update AAccBS Set GrossBLF=0 Where GrossBLF is null
GO
Update ACCBS Set GrossBLF=0 Where GrossBLF is null
GO
Update CArrHeader Set Limit=1 Where Limit is null
GO


-- Shrinking LOG 
-- GANTI SEA_RAMA_ORI DENGAN DATABASE CLIENT

USE SEA_RAMA_ORI;
GO
-- Truncate the log by changing the database recovery model to SIMPLE.
ALTER DATABASE SEA_RAMA_ORI
SET RECOVERY SIMPLE;
GO
-- Shrink the truncated log file to 1 MB.
DBCC SHRINKFILE (SEASQL_Log, 1);
GO
-- Reset the database recovery model.
ALTER DATABASE SEA_RAMA_ORI
SET RECOVERY FULL;
GO
update sysseqno set seqno = 0 where seqno is null
go

UPDATE GENDTAB set FORMULA = '' where FORMULA is null
go
UPDATE BRRULE SET FORCEDISABLECANCELEFFPERIOD=0 Where FORCEDISABLECANCELEFFPERIOD IS NULL
GO
Update ARBucket Set Currency='' Where Currency is null
Update ARBucket Set Subject='' Where Subject is null
GO
Update ProAcc Set ExcludeTaxF=0 Where ExcludeTaxF is null
GO
Update TOPRO Set Discount=0 Where DIscount is null
GO

Update VAccount Set UsedByCollectionF=0 where UsedByCollectionF is null
GO
Update VAccountD Set CollNo='' where CollNo is null
GO
Update CollType Set UseVAF=0 Where UseVAF is null
GO
Update CollType Set Segment='' Where Segment is null
Update CollType Set CGroup='' Where CGroup is null
GO
Update nsl set TaxPayment_OC=0 where TaxPayment_OC is null
Go

-- Shrinking LOG 
-- GANTI SEA_RAMA_ORI DENGAN DATABASE CLIENT

USE SEA_RAMA_ORI;
GO
-- Truncate the log by changing the database recovery model to SIMPLE.
ALTER DATABASE SEA_RAMA_ORI
SET RECOVERY SIMPLE;
GO
-- Shrink the truncated log file to 1 MB.
DBCC SHRINKFILE (SEASQL_Log, 1);
GO
-- Reset the database recovery model.
ALTER DATABASE SEA_RAMA_ORI
SET RECOVERY FULL;
GO