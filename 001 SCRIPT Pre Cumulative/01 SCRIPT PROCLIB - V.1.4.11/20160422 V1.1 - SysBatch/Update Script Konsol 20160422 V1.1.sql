-- Update 19 Apr 2016
IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'ICoverNOCTOI' AND Object_ID = Object_ID(N'SysBatchOriginalUP')) BEGIN Alter table SysBatchOriginalUP add  ICoverNOCTOI varchar(10) end
IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'ICoverNoc1' AND Object_ID = Object_ID(N'SysBatchOriginalUP')) BEGIN Alter table SysBatchOriginalUP add  ICoverNoc1 varchar(10) end
IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'IcoverNOCPCT1' AND Object_ID = Object_ID(N'SysBatchOriginalUP')) BEGIN Alter table SysBatchOriginalUP add  IcoverNOCPCT1 float end
IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'ICoverNOCAmount1' AND Object_ID = Object_ID(N'SysBatchOriginalUP')) BEGIN Alter table SysBatchOriginalUP add  ICoverNOCAmount1 float end
IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'ICoverNOCLimit1' AND Object_ID = Object_ID(N'SysBatchOriginalUP')) BEGIN Alter table SysBatchOriginalUP add  ICoverNOCLimit1 float end 
IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'ICoverNoc2' AND Object_ID = Object_ID(N'SysBatchOriginalUP')) BEGIN Alter table SysBatchOriginalUP add  ICoverNoc2 varchar(10) end
IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'IcoverNOCPCT2' AND Object_ID = Object_ID(N'SysBatchOriginalUP')) BEGIN Alter table SysBatchOriginalUP add  IcoverNOCPCT2 float end
IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'ICoverNOCAmount2' AND Object_ID = Object_ID(N'SysBatchOriginalUP')) BEGIN Alter table SysBatchOriginalUP add  ICoverNOCAmount2 float end
IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'ICoverNOCLimit2' AND Object_ID = Object_ID(N'SysBatchOriginalUP')) BEGIN Alter table SysBatchOriginalUP add  ICoverNOCLimit2 float end 
IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'ICoverNoc3' AND Object_ID = Object_ID(N'SysBatchOriginalUP')) BEGIN Alter table SysBatchOriginalUP add  ICoverNoc3 varchar(10) end
IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'IcoverNOCPCT3' AND Object_ID = Object_ID(N'SysBatchOriginalUP')) BEGIN Alter table SysBatchOriginalUP add  IcoverNOCPCT3 float end
IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'ICoverNOCAmount3' AND Object_ID = Object_ID(N'SysBatchOriginalUP')) BEGIN Alter table SysBatchOriginalUP add  ICoverNOCAmount3 float end
IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'ICoverNOCLimit3' AND Object_ID = Object_ID(N'SysBatchOriginalUP')) BEGIN Alter table SysBatchOriginalUP add  ICoverNOCLimit3 float end 
IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'ICoverNoc4' AND Object_ID = Object_ID(N'SysBatchOriginalUP')) BEGIN Alter table SysBatchOriginalUP add  ICoverNoc4 varchar(10) end
IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'IcoverNOCPCT4' AND Object_ID = Object_ID(N'SysBatchOriginalUP')) BEGIN Alter table SysBatchOriginalUP add  IcoverNOCPCT4 float end
IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'ICoverNOCAmount4' AND Object_ID = Object_ID(N'SysBatchOriginalUP')) BEGIN Alter table SysBatchOriginalUP add  ICoverNOCAmount4 float end
IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'ICoverNOCLimit4' AND Object_ID = Object_ID(N'SysBatchOriginalUP')) BEGIN Alter table SysBatchOriginalUP add  ICoverNOCLimit4 float end 
IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'ICoverNoc5' AND Object_ID = Object_ID(N'SysBatchOriginalUP')) BEGIN Alter table SysBatchOriginalUP add  ICoverNoc5 varchar(10) end
IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'IcoverNOCPCT5' AND Object_ID = Object_ID(N'SysBatchOriginalUP')) BEGIN Alter table SysBatchOriginalUP add  IcoverNOCPCT5 float end
IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'ICoverNOCAmount5' AND Object_ID = Object_ID(N'SysBatchOriginalUP')) BEGIN Alter table SysBatchOriginalUP add  ICoverNOCAmount5 float end
IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'ICoverNOCLimit5' AND Object_ID = Object_ID(N'SysBatchOriginalUP')) BEGIN Alter table SysBatchOriginalUP add  ICoverNOCLimit5 float end 
IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'ICoverNoc6' AND Object_ID = Object_ID(N'SysBatchOriginalUP')) BEGIN Alter table SysBatchOriginalUP add  ICoverNoc6 varchar(10) end
IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'IcoverNOCPCT6' AND Object_ID = Object_ID(N'SysBatchOriginalUP')) BEGIN Alter table SysBatchOriginalUP add  IcoverNOCPCT6 float end
IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'ICoverNOCAmount6' AND Object_ID = Object_ID(N'SysBatchOriginalUP')) BEGIN Alter table SysBatchOriginalUP add  ICoverNOCAmount6 float end
IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'ICoverNOCLimit6' AND Object_ID = Object_ID(N'SysBatchOriginalUP')) BEGIN Alter table SysBatchOriginalUP add  ICoverNOCLimit6 float end 
IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'ICoverNoc7' AND Object_ID = Object_ID(N'SysBatchOriginalUP')) BEGIN Alter table SysBatchOriginalUP add  ICoverNoc7 varchar(10) end
IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'IcoverNOCPCT7' AND Object_ID = Object_ID(N'SysBatchOriginalUP')) BEGIN Alter table SysBatchOriginalUP add  IcoverNOCPCT7 float end
IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'ICoverNOCAmount7' AND Object_ID = Object_ID(N'SysBatchOriginalUP')) BEGIN Alter table SysBatchOriginalUP add  ICoverNOCAmount7 float end
IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'ICoverNOCLimit7' AND Object_ID = Object_ID(N'SysBatchOriginalUP')) BEGIN Alter table SysBatchOriginalUP add  ICoverNOCLimit7 float end
IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'AutoPrintF' AND Object_ID = Object_ID(N'SysBatchOriginalUP')) BEGIN alter table sysbatchoriginalup add AutoPrintF bit end

-- Truncate the log by changing the database recovery model to SIMPLE.
ALTER DATABASE SEA
SET RECOVERY SIMPLE;
GO
-- Shrink the truncated log file to 1 MB.
DBCC SHRINKFILE (SEASQL_log, 1);
GO
-- Reset the database recovery model.
ALTER DATABASE SEA
SET RECOVERY FULL;
GO


IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'ICoverNOCTOI' AND Object_ID = Object_ID(N'SysBatchUP')) BEGIN Alter table SysBatchUP add  ICoverNOCTOI varchar(10) end
IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'ICoverNoc1' AND Object_ID = Object_ID(N'SysBatchUP')) BEGIN Alter table SysBatchUP add  ICoverNoc1 varchar(10) end
IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'IcoverNOCPCT1' AND Object_ID = Object_ID(N'SysBatchUP')) BEGIN Alter table SysBatchUP add  IcoverNOCPCT1 float end
IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'ICoverNOCAmount1' AND Object_ID = Object_ID(N'SysBatchUP')) BEGIN Alter table SysBatchUP add  ICoverNOCAmount1 float end
IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'ICoverNOCLimit1' AND Object_ID = Object_ID(N'SysBatchUP')) BEGIN Alter table SysBatchUP add  ICoverNOCLimit1 float end 
IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'ICoverNoc2' AND Object_ID = Object_ID(N'SysBatchUP')) BEGIN Alter table SysBatchUP add  ICoverNoc2 varchar(10) end
IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'IcoverNOCPCT2' AND Object_ID = Object_ID(N'SysBatchUP')) BEGIN Alter table SysBatchUP add  IcoverNOCPCT2 float end
IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'ICoverNOCAmount2' AND Object_ID = Object_ID(N'SysBatchUP')) BEGIN Alter table SysBatchUP add  ICoverNOCAmount2 float end
IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'ICoverNOCLimit2' AND Object_ID = Object_ID(N'SysBatchUP')) BEGIN Alter table SysBatchUP add  ICoverNOCLimit2 float end 
IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'ICoverNoc3' AND Object_ID = Object_ID(N'SysBatchUP')) BEGIN Alter table SysBatchUP add  ICoverNoc3 varchar(10) end
IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'IcoverNOCPCT3' AND Object_ID = Object_ID(N'SysBatchUP')) BEGIN Alter table SysBatchUP add  IcoverNOCPCT3 float end
IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'ICoverNOCAmount3' AND Object_ID = Object_ID(N'SysBatchUP')) BEGIN Alter table SysBatchUP add  ICoverNOCAmount3 float end
IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'ICoverNOCLimit3' AND Object_ID = Object_ID(N'SysBatchUP')) BEGIN Alter table SysBatchUP add  ICoverNOCLimit3 float end 
IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'ICoverNoc4' AND Object_ID = Object_ID(N'SysBatchUP')) BEGIN Alter table SysBatchUP add  ICoverNoc4 varchar(10) end
IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'IcoverNOCPCT4' AND Object_ID = Object_ID(N'SysBatchUP')) BEGIN Alter table SysBatchUP add  IcoverNOCPCT4 float end
IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'ICoverNOCAmount4' AND Object_ID = Object_ID(N'SysBatchUP')) BEGIN Alter table SysBatchUP add  ICoverNOCAmount4 float end
IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'ICoverNOCLimit4' AND Object_ID = Object_ID(N'SysBatchUP')) BEGIN Alter table SysBatchUP add  ICoverNOCLimit4 float end 
IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'ICoverNoc5' AND Object_ID = Object_ID(N'SysBatchUP')) BEGIN Alter table SysBatchUP add  ICoverNoc5 varchar(10) end
IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'IcoverNOCPCT5' AND Object_ID = Object_ID(N'SysBatchUP')) BEGIN Alter table SysBatchUP add  IcoverNOCPCT5 float end
IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'ICoverNOCAmount5' AND Object_ID = Object_ID(N'SysBatchUP')) BEGIN Alter table SysBatchUP add  ICoverNOCAmount5 float end
IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'ICoverNOCLimit5' AND Object_ID = Object_ID(N'SysBatchUP')) BEGIN Alter table SysBatchUP add  ICoverNOCLimit5 float end 
IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'ICoverNoc6' AND Object_ID = Object_ID(N'SysBatchUP')) BEGIN Alter table SysBatchUP add  ICoverNoc6 varchar(10) end
IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'IcoverNOCPCT6' AND Object_ID = Object_ID(N'SysBatchUP')) BEGIN Alter table SysBatchUP add  IcoverNOCPCT6 float end
IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'ICoverNOCAmount6' AND Object_ID = Object_ID(N'SysBatchUP')) BEGIN Alter table SysBatchUP add  ICoverNOCAmount6 float end
IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'ICoverNOCLimit6' AND Object_ID = Object_ID(N'SysBatchUP')) BEGIN Alter table SysBatchUP add  ICoverNOCLimit6 float end 
IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'ICoverNoc7' AND Object_ID = Object_ID(N'SysBatchUP')) BEGIN Alter table SysBatchUP add  ICoverNoc7 varchar(10) end
IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'IcoverNOCPCT7' AND Object_ID = Object_ID(N'SysBatchUP')) BEGIN Alter table SysBatchUP add  IcoverNOCPCT7 float end
IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'ICoverNOCAmount7' AND Object_ID = Object_ID(N'SysBatchUP')) BEGIN Alter table SysBatchUP add  ICoverNOCAmount7 float end
IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'ICoverNOCLimit7' AND Object_ID = Object_ID(N'SysBatchUP')) BEGIN Alter table SysBatchUP add  ICoverNOCLimit7 float end
IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'AutoPrintF' AND Object_ID = Object_ID(N'SysBatchUP')) BEGIN alter table SysBatchUP add AutoPrintF bit end
go

-- Truncate the log by changing the database recovery model to SIMPLE.
ALTER DATABASE SEA
SET RECOVERY SIMPLE;
GO
-- Shrink the truncated log file to 1 MB.
DBCC SHRINKFILE (SEASQL_log, 1);
GO
-- Reset the database recovery model.
ALTER DATABASE SEA
SET RECOVERY FULL;
GO

update SysTab Set versionNo='20160422 V1.1',versionUpdate=getdate()
go