set transaction isolation level read uncommitted
-- Kumulatif 2018 V.2.1
update TOP_RATE set RETROACTIVEF=0 where RETROACTIVEF is null
update RCOVER set RETROACTIVEF=0 where RETROACTIVEF is null
go


Update Claim Set RUserID=AUserID, RUserDate=AUserDate, RUserTime=AUserTime from Claim WHere RUserID is null and AUserID<>''
Update Claim Set RUserID=PUserID, RUserDate=PUserDate, RUserTime=PUserTime from Claim WHere RUserID is null and PUserID<>'' and CStatus='T'
GO


-- Shrinking LOG 
-- GANTI SEA_RAMA_ORI DENGAN DATABASE CLIENT

USE SEA_RAMA_ORI
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

Update RArrDet Set NotApplyDiscountCFF=0 WHere NotApplyDiscountCFF is null
GO

Update ACCFD Set RITabarruF=0 Where RITabarruF is null
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

Update ICalc Set Loading=0 Where Loading Is Null
GO
Update RCalc Set Loading=0 Where Loading Is Null
GO
Update PCalc Set Loading=0 Where Loading Is Null
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

Update AAccBS Set GrossBLF=0 Where GrossBLF is null
GO


Update ACCBS Set GrossBLF=0 Where GrossBLF is null
GO
Update ACCBS set AgentType='' Where AgentType is null
GO
Update AAccBS set AgentType='' Where AgentType is null
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
UPDATE GENDTAB set FORMULA = '' where FORMULA is null
go

-- Kumulatif 2018 V.2.0
Update RArrHeader Set PDate=Rdate, PPDate=NRDate Where PPDate is null
GO

Update Reinsurance Set CleanCutF=0 Where CleanCutF is null
GO

Update R1 Set PDate=R2.SDate, PPDate=dateadd(day,1,R2.EDate)
from RArrHeader R1, Reinsurance R2 Where R2.RID=R1.QID and R2.CleanCutF=1 
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

Update Scheme_Master Set RoundRF=0 Where RoundRF is null
GO
UPDATE REINSURANCE SET PRID='' WHERE PRID IS NULL
GO

UPDATE ARBucket SET AutoPrintF=0 WHERE AutoPrintF IS NULL
GO

-- Kumulatif 2018 V.1.9

UPDATE TOP_INTEREST SET CURRENCY_OC='' WHERE CURRENCY_OC IS NULL
GO
update sysuser set CCODE='15-DEMO' where ccode is null or ccode=''
go

-- Kumulatif 2018 V.1.8

update ECUTYPE set DefaultF=0 where DefaultF is null
update ECUTYPE set PolicyF=0 where PolicyF is null
update ECUTYPE set CoverF=0 where CoverF is null
go

UPDATE TOP_RATE set NCPERIOD=0 WHERE NCPERIOD IS NULL
GO
UPDATE RCOVER SET NCDATE=SDATE WHERE NCDATE IS NULL
GO

UPDATE TOP_INTEREST SET CURRENCY_OC='' WHERE CURRENCY_OC IS NULL
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

-- Kumulatif 2018 V.1.7
Update RATECON Set HoldF=0 Where HoldF is null
GO
Update RATECON_M1 Set HoldF=0 Where HoldF is null
GO
Update RATECON_M2 Set HoldF=0 Where HoldF is null 
GO
Update RATECON_M3 Set HoldF=0 Where HoldF is null
GO
Update RATECON_M4 Set HoldF=0 Where HoldF is null
GO
Update RATECON_M5 Set HoldF=0 Where HoldF is null
GO
Update RATECON_M6 Set HoldF=0 Where HoldF is null
GO
Update RATECON_M7 Set HoldF=0 Where HoldF is null
GO
Update RATECON_M1 Set MinTSI=0 Where MinTSI is null
GO
Update RATECON_M2 Set MinTSI=0 Where MinTSI is null 
GO
Update RATECON_M3 Set MinTSI=0 Where MinTSI is null
GO
Update RATECON_M4 Set MinTSI=0 Where MinTSI is null
GO
Update RATECON_M5 Set MinTSI=0 Where MinTSI is null
GO
Update RATECON_M6 Set MinTSI=0 Where MinTSI is null
GO
Update RATECON_M7 Set MinTSI=0 Where MinTSI is null
GO
Update RATECON_M1 Set MaxTSI=0 Where MaxTSI is null
GO
Update RATECON_M2 Set MaxTSI=0 Where MaxTSI is null 
GO
Update RATECON_M3 Set MaxTSI=0 Where MaxTSI is null
GO
Update RATECON_M4 Set MaxTSI=0 Where MaxTSI is null
GO
Update RATECON_M5 Set MaxTSI=0 Where MaxTSI is null
GO
Update RATECON_M6 Set MaxTSI=0 Where MaxTSI is null
GO
Update RATECON_M7 Set MaxTSI=0 Where MaxTSI is null
GO
Update Country Set DefaultF=0 Where DefaultF is null
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

Update pVoucher Set RefCCYDate=Date Where RefCCYDate is null
GO
Update nVoucher Set RefCCYDate=Date Where RefCCYDate is null
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

Update nVoucher Set CollNo='' Where CollNo is null
go

-- Kumulatif 2018 V.1.6

UPDATE ICOVER SET EML=0 Where EML IS NULL
GO
UPDATE ICOVER SET EML_OC=0 Where EML_OC IS NULL
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

UPDATE RARRHEADER SET LOLBASED=0 WHERE LOLBASED IS NULL
GO
Update VAccount set XApplyVSCGroupF=0 Where XApplyVSCGroupF is null
GO

Update R1 Set 
FShare=R2.FShare,
FAmount=R2.FShare/100*R1.TAmount,
Retention=100-(QAmount+QSRAmount)/TAmount*100-DShare-CShare-XPShare-Sp1Share-sp2share-sp3share-(AAMOUNT+AFRAmount)/TAmount*100-R2.FShare,
RAmount=(100-(QAmount+QSRAmount)/TAmount*100-DShare-CShare-XPShare-Sp1Share-sp2share-sp3share-(AAMOUNT+AFRAmount)/TAmount*100-R2.FShare)/100*R1.TAmount
from RArrHeader R1, 
(
Select A.ANO, sum((Case When R.Limit<>0 Then (R.Limit)/R2.TAmount*(R.Share-R.JPShare)/100 else (R.Share-R.JPShare)/100 end)*F.Share/100*100) as FShare
from FPart F, RArrDet R, Acceptance A, RArrheader R2 
Where R2.ANO=A.ANO and A.ANO=R.ANO and R.status='A' and F.ANO=R.ANO and F.FID=R.FID and R.Excess<>0
Group by A.ANO
) R2 
Where R2.ANO=R1.ANO
GO

UPDATE APDRULEH SET PTYPE='<ALL>' WHERE PTYPE IS NULL
GO

Update Segment set AutoInforceF=0 Where AutoInforceF is null
GO

UPDATE ACCEPTANCE SET BATCHNO='' WHERE BATCHNO IS NULL
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

-- Kumulatif 2018 V.1.5

Update pVoucher Set RefCCYDate=Date Where RefCCYDate is null
go

UPDATE RECLASS SET RISKF=0 WHERE RISKF IS NULl
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

Update nVoucher Set TaxPayment_OC=nSL.Nominal_OC 
from nVoucher, nSL, VType WHere nSL.Voucher=nVoucher.VOucher and VType.VType=nVoucher.VType and VType.TaxF=1 and nSL.TaxPayment_OC is null
GO

UPDATE NVOUCHER SEt RefCCYDate=Date from nVoucher Where RefCCYdate is null
GO
Update SysTab SEt UseExchRateOnLossDate=0 Where UseExchRateOnLossDate is null
GO
Update ReClassDet Set RateAdjF=1 Where RateAdjF is null
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

-- Kumulatif 2018 V.1.4 (KOSONG)
-- Kumulatif 2018 V.1.1 (KOSONG)

-- Kumulatif 2018 V.1.0
Update A Set CT=V.CT from pVoucher V, Asset A Where A.Asset=V.Asset and V.AssetF=1 and V.SL_Cat='F' and A.CT is null
GO

Update Reinsurance Set ApplyCGroupF=0 Where ApplyCGroupF is null
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