--Update Cumululative inisialisasi 2020 v.1.3

set transaction isolation level read uncommitted
--16 FEB 2021
Update ProfilePIC Set Last_Time='00:00' Where Last_Time is null
GO

--28 FEB 2021

UPDATE TOL SET MINTSI=0 WHERE MINTSI IS NULL
GO
UPDATE TOL SET MAXTSI=0 WHERE MAXTSI IS NULL
GO

Update accClass Set AccLinkF=0 Where AccLinkF is null
GO

--3 MAR 2021
Update SysLogDownload set Status='P', ErrMsg='' Where Status is null
GO

--Update Cumululative inisialisasi 2020 v.1.3.1

-- 5 MAR 2021 (1)
Update Scheme_Additional set HoldF=0 Where HoldF is null
GO

--24 MAR 2021
--Update A1 Set LastANO=A1.ANO, SeqNo=1, Last_Opr=A2.LUserID, Last_Update=A2.LDate from AINFODet A1, acceptance A2 Where A2.ANO=A1.ANO and A1.LastANO is null
--GO

Update A1 Set  SeqNo=1, Last_Opr=A2.LUserID, Last_Update=A2.LDate from AINFODet A1, acceptance A2 Where A2.ANO=A1.ANO and A1.SeqNo is null
GO

--14 APR 2021
Update MPAram set PASAL4=0.5 Where (PASAL23<>0 or PASAL21<>0) and PASAL4 IS NULL
Update MParam Set PASAL4=0 Where PASAL4 IS NULL
GO

--20 MAY 2021
Update AccFD Set CessionF=0 Where CessionF is null
GO

--25 MAY 2021
Update SysUserVType SEt LimitIn=0, LimitOut=0 Where LimitIn is null
GO

--25 JUN 2021

Update ISource Set CedingID=ID Where coalesce(CedingID,'')=''
GO

--28 JUN 2021
Update TOC Set ConjunctExcessClaimF=0 Where ConjunctExcessClaimF is null
GO

--8 JUL 2021
Update TOC set CashCallOnEstimateF=0 Where CashCallOnEstimateF is null
GO

--8 JUL 2021
Update TOC set CashCallOnGrossF=0 Where CashCallOnGrossF is null
GO

Update RPart Set CashLoss=0 Where CashLoss is null
GO

--15 JUL 2021
Update Profile Set DeferralF=0 Where DeferralF is null
GO

--20 JUL 2021
Update AccInvoice Set INO=ICover.INO from AccInvoice, ICover Where ICover.ANO=AccInvoice.ANO and AccInvoice.INO is null
GO

--22 JUL 2021
Update AInfoDet Set DocDate=Acceptance.PDate from AInfoDet, Acceptance Where AInfoDet.ANO=Acceptance.ANO and DocDate is null
Update AinfoDet Set Status='A', AdmNo=-1 Where Status is null
GO


--24 AGST 2021
Update ACCBS set NoProrataF=0 WHere NoProrataF is null
Update AACCBS set NoProrataF=0 WHere NoProrataF is null
GO


Update doctype set OptionalF=0 where OptionalF is null
go

-- Shrinking LOG 
-- GANTI SEA_CONSOLE_UAT DENGAN DATABASE CLIENT

USE SEA_CONSOLE_UAT;
GO
-- Truncate the log by changing the database recovery model to SIMPLE.
ALTER DATABASE SEA_CONSOLE_UAT
SET RECOVERY SIMPLE;
GO
-- Shrink the truncated log file to 1 MB.
DBCC SHRINKFILE (SEASQL_Log, 1);
GO
-- Reset the database recovery model.
ALTER DATABASE SEA_CONSOLE_UAT
SET RECOVERY FULL;
GO