
Update TOC set MinBackDatedPolicy=0, MaxBackDatedPolicy=0 Where MinBackDatedPolicy is null
GO

-- Shrinking LOG 
-- GANTI SEA_CONSOLE DENGAN DATABASE CLIENT

USE SEA_CONSOLE;
GO
-- Truncate the log by changing the database recovery model to SIMPLE.
ALTER DATABASE SEA_CONSOLE
SET RECOVERY SIMPLE;
GO
-- Shrink the truncated log file to 1 MB.
DBCC SHRINKFILE (SEASQL_Log, 1);
GO
-- Reset the database recovery model.
ALTER DATABASE SEA_CONSOLE
SET RECOVERY FULL;
GO