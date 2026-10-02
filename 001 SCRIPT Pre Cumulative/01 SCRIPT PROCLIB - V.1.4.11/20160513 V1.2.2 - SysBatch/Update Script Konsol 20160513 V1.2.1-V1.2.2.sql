--V.1.2.1 : tidak ada update script

--V.1.2.2

-- Update 13 May 2016
IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'NCDATE' AND Object_ID = Object_ID(N'sysbatchoriginalup')) BEGIN Alter table SysBatchOriginalup add  NCDATE smalldatetime end
IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'NCDATE' AND Object_ID = Object_ID(N'sysbatchup')) BEGIN Alter table SysBatchup add  NCDATE smalldatetime end

IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'NCDATE' AND Object_ID = Object_ID(N'sysbatchoriginalbe')) BEGIN Alter table SysBatchOriginalbe add  NCDATE smalldatetime end
IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'SMSRule' AND Object_ID = Object_ID(N'SysBatchOriginalbe')) BEGIN Alter table SysBatchOriginalbe add  SMSRule varchar(50) end
IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'ImmediateInforceF' AND Object_ID = Object_ID(N'SysBatchOriginalbe')) BEGIN Alter table SysBatchOriginalbe add  ImmediateInforceF bit end
IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'TOPRO' AND Object_ID = Object_ID(N'SysBatchOriginalbe')) BEGIN Alter table SysBatchOriginalbe add  TOPRO varchar(10) end
IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'TOPRO_Currency' AND Object_ID = Object_ID(N'SysBatchOriginalbe')) BEGIN Alter table SysBatchOriginalbe add  TOPRO_Currency varchar(5) end 
IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'TOPRO_TSI' AND Object_ID = Object_ID(N'SysBatchOriginalbe')) BEGIN Alter table SysBatchOriginalbe add  TOPRO_TSI float end
IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'TOPRO_ATSI' AND Object_ID = Object_ID(N'SysBatchOriginalbe')) BEGIN Alter table SysBatchOriginalbe add  TOPRO_ATSI float end
IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'BSID1' AND Object_ID = Object_ID(N'SysBatchOriginalbe')) BEGIN Alter table SysBatchOriginalbe add  BSID1 varchar(255) end
IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'BSFee1' AND Object_ID = Object_ID(N'SysBatchOriginalbe')) BEGIN Alter table SysBatchOriginalbe add  BSFee1 float end 
IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'BSType1' AND Object_ID = Object_ID(N'SysBatchOriginalbe')) BEGIN Alter table SysBatchOriginalbe add  BSType1 varchar(1) end
IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'BSFeeAmount1' AND Object_ID = Object_ID(N'SysBatchOriginalbe')) BEGIN Alter table SysBatchOriginalbe add  BSFeeAmount1 float end
IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'BSID2' AND Object_ID = Object_ID(N'SysBatchOriginalbe')) BEGIN Alter table SysBatchOriginalbe add  BSID2 varchar(255) end
IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'BSFee2' AND Object_ID = Object_ID(N'SysBatchOriginalbe')) BEGIN Alter table SysBatchOriginalbe add  BSFee2 float end 
IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'BSType2' AND Object_ID = Object_ID(N'SysBatchOriginalbe')) BEGIN Alter table SysBatchOriginalbe add  BSType2 varchar(1) end
IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'BSFeeAmount2' AND Object_ID = Object_ID(N'SysBatchOriginalbe')) BEGIN Alter table SysBatchOriginalbe add  BSFeeAmount2 float end
IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'BSID3' AND Object_ID = Object_ID(N'SysBatchOriginalbe')) BEGIN Alter table SysBatchOriginalbe add  BSID3 varchar(255) end
IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'BSFee3' AND Object_ID = Object_ID(N'SysBatchOriginalbe')) BEGIN Alter table SysBatchOriginalbe add  BSFee3 float end 
IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'BSType3' AND Object_ID = Object_ID(N'SysBatchOriginalbe')) BEGIN Alter table SysBatchOriginalbe add  BSType3 varchar(1) end
IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'BSFeeAmount3' AND Object_ID = Object_ID(N'SysBatchOriginalbe')) BEGIN Alter table SysBatchOriginalbe add  BSFeeAmount3 float end
IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'Correspondence_Address' AND Object_ID = Object_ID(N'SysBatchOriginalbe')) BEGIN Alter table SysBatchOriginalbe add  Correspondence_Address varchar (255) end
IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'Correspondence_Phone' AND Object_ID = Object_ID(N'SysBatchOriginalbe')) BEGIN Alter table SysBatchOriginalbe add  Correspondence_Phone varchar (30) end 
IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'Correspondence_Email' AND Object_ID = Object_ID(N'SysBatchOriginalbe')) BEGIN Alter table SysBatchOriginalbe add  Correspondence_Email varchar(50) end

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


IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'NCDATE' AND Object_ID = Object_ID(N'sysbatchbe')) BEGIN Alter table sysbatchbe add  NCDATE smalldatetime end
IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'SMSRule' AND Object_ID = Object_ID(N'sysbatchbe')) BEGIN Alter table sysbatchbe add  SMSRule varchar(50) end
IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'ImmediateInforceF' AND Object_ID = Object_ID(N'sysbatchbe')) BEGIN Alter table sysbatchbe add  ImmediateInforceF bit end
IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'TOPRO' AND Object_ID = Object_ID(N'sysbatchbe')) BEGIN Alter table sysbatchbe add  TOPRO varchar(10) end
IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'TOPRO_Currency' AND Object_ID = Object_ID(N'sysbatchbe')) BEGIN Alter table sysbatchbe add  TOPRO_Currency varchar(5) end 
IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'TOPRO_TSI' AND Object_ID = Object_ID(N'sysbatchbe')) BEGIN Alter table sysbatchbe add  TOPRO_TSI float end
IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'TOPRO_ATSI' AND Object_ID = Object_ID(N'sysbatchbe')) BEGIN Alter table sysbatchbe add  TOPRO_ATSI float end
IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'BSID1' AND Object_ID = Object_ID(N'sysbatchbe')) BEGIN Alter table sysbatchbe add  BSID1 varchar(255) end
IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'BSFee1' AND Object_ID = Object_ID(N'sysbatchbe')) BEGIN Alter table sysbatchbe add  BSFee1 float end 
IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'BSType1' AND Object_ID = Object_ID(N'sysbatchbe')) BEGIN Alter table sysbatchbe add  BSType1 varchar(1) end
IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'BSFeeAmount1' AND Object_ID = Object_ID(N'sysbatchbe')) BEGIN Alter table sysbatchbe add  BSFeeAmount1 float end
IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'BSID2' AND Object_ID = Object_ID(N'sysbatchbe')) BEGIN Alter table sysbatchbe add  BSID2 varchar(255) end
IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'BSFee2' AND Object_ID = Object_ID(N'sysbatchbe')) BEGIN Alter table sysbatchbe add  BSFee2 float end 
IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'BSType2' AND Object_ID = Object_ID(N'sysbatchbe')) BEGIN Alter table sysbatchbe add  BSType2 varchar(1) end
IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'BSFeeAmount2' AND Object_ID = Object_ID(N'sysbatchbe')) BEGIN Alter table sysbatchbe add  BSFeeAmount2 float end
IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'BSID3' AND Object_ID = Object_ID(N'sysbatchbe')) BEGIN Alter table sysbatchbe add  BSID3 varchar(255) end
IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'BSFee3' AND Object_ID = Object_ID(N'sysbatchbe')) BEGIN Alter table sysbatchbe add  BSFee3 float end 
IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'BSType3' AND Object_ID = Object_ID(N'sysbatchbe')) BEGIN Alter table sysbatchbe add  BSType3 varchar(1) end
IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'BSFeeAmount3' AND Object_ID = Object_ID(N'sysbatchbe')) BEGIN Alter table sysbatchbe add  BSFeeAmount3 float end
IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'Correspondence_Address' AND Object_ID = Object_ID(N'sysbatchbe')) BEGIN Alter table sysbatchbe add  Correspondence_Address varchar (255) end
IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'Correspondence_Phone' AND Object_ID = Object_ID(N'sysbatchbe')) BEGIN Alter table sysbatchbe add  Correspondence_Phone varchar (30) end 
IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'Correspondence_Email' AND Object_ID = Object_ID(N'sysbatchbe')) BEGIN Alter table sysbatchbe add  Correspondence_Email varchar(50) end

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


update SysTab Set versionNo='20160513 V1.2.2',versionUpdate=getdate()
go