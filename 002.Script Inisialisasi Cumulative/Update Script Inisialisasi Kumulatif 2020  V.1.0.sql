set transaction isolation level read uncommitted
Update Payor Set SIScheduleF=ScheduleF Where SIScheduleF is null
Update APayor Set SIScheduleF=ScheduleF Where SIScheduleF is null
GO
Update Payor_Schedule Set InstSIPCT=100 Where InstSIPCT is null
GO
UPDATE COMPLIANCE SET MUSTAPPLYF=0 WHERE MUSTAPPLYF IS NULL
GO
Update TOP_RTERM set PTerm=0 where PTerm is null
Update TOP_RTERM set PUnit=1000 where Punit is null
GO
UPDATE TOP_RATE SET CPREFUND=0 WHERE CPREFUND IS NULL
UPDATE TOP_RATE SET CPFORMULA='' WHERE CPFORMULA IS NULL
GO

Update RCover Set PortFromID=Port.Port from RCover, Port Where Port.Description=RCover.PortFrom and PortFromID is null
Update RCover Set PortToID=Port.Port from RCover, Port Where Port.Description=RCover.PortTo and PortToID is null
Update RCover Set VoyageFromID=Country.Country from RCover, Country Where Country.Description=RCover.VoyageFrom and VoyageFromID is null
Update RCover Set VoyageToID=Country.Country from RCover, Country Where Country.Description=RCover.VoyageTo and VoyageToID is null
GO
UPDATE COLLTYPE Set AutoCollby='' Where AutoCollby Is Null
GO



Update ACCBSDET Set InceptionF=0 Where InceptionF is null
GO
Update AACCBSDET Set InceptionF=0 Where InceptionF is null
GO
Update Payor_Schedule Set CPRefund=0 Where CPRefund is null
GO
Update Reinsurance Set DCYear=0 Where DCYear is null
GO

Update TOPRO set CheckRateConSIBy=0 Where CheckRateConSIBy is null
GO
Update ARBucket Set NetPaidF=0 Where NetPaidF is null
go
Update SysProcess Set RepetitiveF=0 Where RepetitiveF is null
GO
Update Matters set PURPOSE='ALL' Where Purpose is null
GO
UPDATE GENHTAB SET FLDMAP='' WHERE FLDMAP IS NULL
GO

Update ReClass Set OpFeeF=1 Where OpFeeF Is null
GO
Update SysUserTypeTOCTOL Set MINTSI=0, MAXTSI=0, MinPeriod=0, MaxPeriod=0 Where MINTSI IS NULL
GO
Update Beneficiaries Set PCTLOSS=0 Where PCTLOSS is null
GO
Update TOC Set ClaimDeductionRefundF=0 Where ClaimDeductionRefundF is null
GO
Update TOC Set ApplyApprLimitByAccRegF=0 Where ApplyApprLimitByAccRegF is null
GO
Update TOC Set ApplyApprLimitByAccRegF=0 Where ApplyApprLimitByAccRegF is null
GO
Update TOPRO set PHolderF=0 Where PHolderF is null
GO
Update V2 Set PDate = A.BillDate, NDueDate=A.BillDate from vAccount V1, vAccountD V2, Admlink A Where V1.VID=V2.VID and A.Bank=V1.Bank and A.AccountNo=V2.AccountNo and A.RefType='VIRTUAL' and A.PDate is null
GO
Update TOPRO set InsuredF=0 Where InsuredF is null
GO
Update TOC Set AutoClaimPaymentF=0 Where AutoClaimPaymentF is null
GO
Update V2 Set PDate = A.BillDate, NDueDate=A.BillDate from vAccount V1, vAccountD V2, Admlink A Where V1.VID=V2.VID and A.Bank=V1.Bank and A.AccountNo=V2.AccountNo and A.RefType='VIRTUAL' and A.PDate is null
GO
Update TOP_Interest Set FilterCode='' Where FilterCode is null
GO
Update TOP_NOC Set FilterCode='' Where FilterCode is null
GO
Update MParam set WriteF=0 where WriteF is null
GO
Update SysProcID set ZipPassword='' where ZipPassword is null
GO
Update TOC Set PremiumFullPaymentOnClaimF=0 Where PremiumFullPaymentOnClaimF is null
GO
Update TOP_DEDUCTIBLE set DED_AMOUNTSOURCE='' Where DED_AMOUNTSOURCE IS NULL
go
Update TOP_CLA set FilterCode='' Where FilterCode is null
GO
Update TOP_CON set FilterCode='' Where FilterCode is null
GO
Update TOP_EX set FilterCode='' Where FilterCode is null
GO
Update sysuserTOC set TotalLimitIn=0 Where TotalLimitIn is null
GO
Update TOC set AGEMETHOD=-1 Where AGEMETHOD is null
GO
UPDATE ACCEPTANCE SET PASTATUS='' WHERE PASTATUS IS NULL
GO
Update sysRequest set RequestingUser=UserID from SysRequest Where RequestingUser is null
go
Update ActionList Set ApprovedFName='' Where ApprovedFName is null
GO
Update CGroup Set ID='' Where ID is null
GO
Update RPBucket Set NotBackEndProcessF=0 Where NotBackEndProcessF is null
Update RPBucket Set GPID=0 Where GPID is null
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