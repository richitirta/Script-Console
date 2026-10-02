Update ALRule set Source='<All>' Where Source is null
GO

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

update acceptance set AutoGenerateRenewalF = 0 where AutoGenerateRenewalF is null
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


update acceptance set OverwriteBVatF = 0 where OverwriteBVatF is null
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