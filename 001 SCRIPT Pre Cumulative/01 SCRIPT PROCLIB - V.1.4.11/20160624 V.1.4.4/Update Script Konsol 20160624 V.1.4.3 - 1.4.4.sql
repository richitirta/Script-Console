--V.1.4.3 : tidak ada update script
--V.1.4.4 
--SCRIPT SP_
IF EXISTS ( SELECT * FROM   sysobjects WHERE  id = object_id(N'[dbo].[SP_getIdentity]') and OBJECTPROPERTY(id, N'IsProcedure') = 1 ) BEGIN    DROP PROCEDURE [dbo].[SP_getIdentity] END 
IF EXISTS ( SELECT * FROM   sysobjects WHERE  id = object_id(N'[dbo].[SP_getSeqNo]') and OBJECTPROPERTY(id, N'IsProcedure') = 1 ) BEGIN    DROP PROCEDURE [dbo].[SP_getSeqNo] END 
GO
CREATE PROCEDURE SP_getIdentity(@ObjName varchar(50))          
AS           
BEGIN           
  DECLARE @SeqNo as int
  select @SeqNo=0        
  Insert Into SysLockedObject with(NOWAIT) (ObjName,Status,db_user) Values('SysSeqNo'+@ObjName,'L','')          
  IF @@ROWCOUNT<>0     
  BEGIN           
   UPDATE SysSeqNo SET SeqNo=SeqNo+1 WHERE Objname=@ObjName              
   IF @@ROWCOUNT=0          
   BEGIN          
  SET @seqno=1    
  INSERT INTO sysseqno(ObjName,SeqNo) VALUES (@ObjName,@seqno)                   
   END          
   ELSE          
   BEGIN          
  Select @Seqno=SeqNo from SysSeqNo Where ObjName=@ObjName          
   END          
    
   Delete from SysLockedObject with(NOWAIT) Where ObjName='SysSeqNo'+@ObjName and Status='L'         
  END    
      
  SELECT @SeqNo            
END      
    
go
CREATE PROCEDURE SP_getSeqNo(@AutoNum as varchar(5), @LDocNo as varchar(20), @RDocNo as varchar(20))          
AS           
BEGIN           
    
  DECLARE @SeqNo as int
  select @SeqNo=0 
  Insert Into SysLockedObject with(NOWAIT) (ObjName,Status,db_user) Values('SeqNo'+'-'+@AutoNum+'-'+@LDocNo+'-'+@RDocNo,'L','')          
  IF @@ROWCOUNT<>0     
  BEGIN           
   UPDATE SeqNo SET SeqNo=SeqNo+1 WHERE AutoNum=@AutoNum and LDocNo=@LDocNo and RDocNo=@RDocNo    
   IF @@ROWCOUNT=0          
   BEGIN          
  SET @seqno=1    
  INSERT INTO SeqNo(AutoNum, LDocNo, RDocNo, SeqNo) VALUES (@AutoNum, @LDocNo, @RDocNo, @seqno)                   
   END          
   ELSE          
   BEGIN          
  Select @Seqno=SeqNo from SeqNo WHERE AutoNum=@AutoNum and LDocNo=@LDocNo and RDocNo=@RDocNo    
   END          
    
   Delete from SysLockedObject with(NOWAIT) Where ObjName='SeqNo'+'-'+@AutoNum+'-'+@LDocNo+'-'+@RDocNo and Status='L'         
  END    
      
  SELECT @SeqNo            
END      


GO

-- 20 jun 2016


IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'BSID' AND Object_ID = Object_ID(N'Scheme_Transaction'))
BEGIN
ALTER TABLE dbo.Scheme_Transaction ADD
	BSID varchar(10) NULL
END
GO

IF NOT EXISTS (SELECT * FROM SYS.EXTENDED_PROPERTIES WHERE [major_id] = OBJECT_ID('Scheme_Transaction') AND [name] = N'MS_Description' AND [minor_id] = (SELECT [column_id] FROM SYS.COLUMNS WHERE [name] = 'BSID' AND [object_id] = OBJECT_ID('Scheme_Transaction')))
BEGIN
DECLARE @v sql_variant 
SET @v = N'BrokerID (see Profile)'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'Scheme_Transaction', N'COLUMN', N'BSID'
END
GO


IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'BSFEE' AND Object_ID = Object_ID(N'Scheme_Transaction'))
BEGIN
ALTER TABLE dbo.Scheme_Transaction ADD
	BSFEE float(53) NULL
END
GO

IF NOT EXISTS (SELECT * FROM SYS.EXTENDED_PROPERTIES WHERE [major_id] = OBJECT_ID('Scheme_Transaction') AND [name] = N'MS_Description' AND [minor_id] = (SELECT [column_id] FROM SYS.COLUMNS WHERE [name] = 'BSFEE' AND [object_id] = OBJECT_ID('Scheme_Transaction')))
BEGIN
DECLARE @v sql_variant 
SET @v = N'Broker Fee in %'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'Scheme_Transaction', N'COLUMN', N'BSFEE'
END
GO

IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'BSFEEAMOUNT' AND Object_ID = Object_ID(N'Scheme_Transaction'))
BEGIN
ALTER TABLE dbo.Scheme_Transaction ADD
	BSFEEAMOUNT float(53) NULL
END
GO

IF NOT EXISTS (SELECT * FROM SYS.EXTENDED_PROPERTIES WHERE [major_id] = OBJECT_ID('Scheme_Transaction') AND [name] = N'MS_Description' AND [minor_id] = (SELECT [column_id] FROM SYS.COLUMNS WHERE [name] = 'BSFEEAMOUNT' AND [object_id] = OBJECT_ID('Scheme_Transaction')))
BEGIN
DECLARE @v sql_variant 
SET @v = N'Broker Fee in Amount'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'Scheme_Transaction', N'COLUMN', N'BSFEEAMOUNT'
END
GO

IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'BSFEEAMOUNT' AND Object_ID = Object_ID(N'SysBatchSC'))
BEGIN
ALTER TABLE dbo.SysBatchSC ADD
	BSFEEAMOUNT float(53) NULL
END
GO

IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'BSFEEAMOUNT' AND Object_ID = Object_ID(N'SysBatchOriginalSC'))
BEGIN
ALTER TABLE dbo.SysBatchOriginalSC ADD
	BSFEEAMOUNT float(53) NULL
END
GO

update SysTab Set versionNo='20160624 V1.4.4',versionUpdate=getdate()
go