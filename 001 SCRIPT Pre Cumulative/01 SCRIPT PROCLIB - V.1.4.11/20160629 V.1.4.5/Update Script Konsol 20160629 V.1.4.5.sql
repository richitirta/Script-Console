--V.1.4.5 

IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'InforceBulkF' AND Object_ID = Object_ID(N'SysBatchUP'))
BEGIN
Alter Table SysBatchUP Add
 InforceBulkF Bit default(0)
END
GO

IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'InforceBulkF' AND Object_ID = Object_ID(N'SysBatchOriginalUP'))
BEGIN
Alter Table SysBatchOriginalUP Add
 InforceBulkF Bit default(0)
END
GO

IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'BatchNo' AND Object_ID = Object_ID(N'AIBucket'))
BEGIN
Alter Table AIBucket Add
 BatchNo varchar(20)
END
GO

Update AIBucket Set BatchNo='' Where BatchNo is null
GO

IF NOT EXISTS (SELECT *  FROM sys.indexes  
			WHERE name='I_AIBucket_RegNo_BatchNo_Last_Update' AND object_id = OBJECT_ID('AIBucket'))
BEGIN
Create Index I_AIBucket_RegNo_BatchNo_Last_Update on AIBucket(RegNo, BatchNo, Last_Update)
end
go

IF EXISTS ( SELECT * FROM   sysobjects WHERE  id = object_id(N'[dbo].[AutoInforce_Process]') and OBJECTPROPERTY(id, N'IsProcedure') = 1 ) BEGIN    DROP PROCEDURE [dbo].AutoInforce_Process END 
go

CREATE Procedure AutoInforce_Process(@P_PDate as smalldatetime)                                            
as                                   
--Individual Polis First
Select AIBucket.ADate, AIBucket.PID, Acceptance.ANO, Acceptance.LANO, Acceptance.RegNo, Acceptance.BatchNo, cast(0 as Bit) as BulkF              
from AIBucket, Acceptance, Cover                
where AIBucket.Status='R' 
and Acceptance.RegNo=AIBucket.RegNo and Acceptance.LANO=-1
and Cover.CNO=Acceptance.CNO and Cover.CStatus='A' and Acceptance.AStatus='W'     
and Acceptance.CDate<=AIBucket.Last_Update 

Union All

--Certificate Second
Select AIBucket.ADate, AIBucket.PID, Acceptance.ANO, Acceptance.LANO, Acceptance.RegNo, Acceptance.BatchNo, cast(0 as Bit) as BulkF
from AIBucket, Acceptance, Cover                
where AIBucket.Status='R' 
and Acceptance.RegNo=AIBucket.RegNo and Acceptance.CertificateNo<>'' and Acceptance.CertificateNo=AIBucket.CertificateNo and Acceptance.ANO<>Acceptance.LANO and Cover.OpenFlag=1              
and Cover.CNO=Acceptance.CNO and Cover.CStatus='A' and Acceptance.AStatus='W'     
and Acceptance.CDate<=AIBucket.Last_Update 

Union All

--Bulk Inforce Certificate
Select AIBucket.ADate, AIBucket.PID, Max(Acceptance.LANO) as ANO, Max(Acceptance.LANO) as LANO, Max(Acceptance.RegNo) as RegNo, Acceptance.BatchNo, cast(1 as Bit) as BulkF              
from AIBucket, Acceptance, Cover                
where AIBucket.Status='R' 
and Acceptance.RegNo=AIBucket.RegNo and Acceptance.BatchNo<>'' and Acceptance.BatchNo=AIBucket.BatchNo and Acceptance.ANO<>Acceptance.LANO and Cover.OpenFlag=1              
and Cover.CNO=Acceptance.CNO and Cover.CStatus='A' and Acceptance.AStatus='W'     
and Acceptance.CDate<=AIBucket.Last_Update 
Group By AIBucket.ADate, AIBucket.PID, Acceptance.BatchNo

Union All

--Fleet Polis Last
Select AIBucket.ADate, AIBucket.PID, Acceptance.ANO, Acceptance.LANO, Acceptance.RegNo, Acceptance.BatchNo, cast(0 as Bit) as BulkF
from AIBucket, Acceptance, Cover                
where AIBucket.Status='R' 
and Acceptance.RegNo=AIBucket.RegNo and Acceptance.BatchNo='' and Acceptance.CertificateNo='' and Acceptance.ANO=Acceptance.LANO
and Cover.CNO=Acceptance.CNO and Cover.CStatus='A' and Acceptance.AStatus='W'     
and Acceptance.CDate<=AIBucket.Last_Update 
go



update SysTab Set versionNo='20160629 V1.4.5',versionUpdate=getdate()
go