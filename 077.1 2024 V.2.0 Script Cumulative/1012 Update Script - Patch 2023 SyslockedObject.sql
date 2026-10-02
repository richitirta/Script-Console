DROP PROCEDURE SP_getIdentity
GO
CREATE PROCEDURE SP_getIdentity(@ObjName varchar(50))            
AS             
BEGIN             
  DECLARE @SeqNo as int  
  DECLARE @LSeqNo as int  
  select @SeqNo=0          
  Insert Into SysLockedObject with(ROWLOCK)(ObjName,Status,db_user) Values('SysSeqNo'+@ObjName,'L','')            
  IF @@ROWCOUNT<>0       
  BEGIN
	   Select @Seqno=SeqNo from SysSeqNo Where ObjName=@ObjName
	   IF @@ROWCOUNT=0            
	   BEGIN            
			SET @seqno=0
			INSERT INTO sysseqno(ObjName,SeqNo) VALUES (@ObjName,@seqno)                     
	   END            

	   Select @Seqno=@Seqno+1			
	  
	  -- SeqNo Exclusion not Yet Used
	  -- WHILE (1=1)
	  -- BEGIN
			--Select @Seqno=@Seqno+1			
			--SELECT @LSeqNo=LSeqNo from SysSeqNo_Ex Where ObjName=@ObjName and @SeqNo Between FSeqNo and LSeqNo Order by FSeqNo
			--IF @@ROWCOUNT=0
			--	BREAK
			--Select @SeqNo=@LSeqNo
	  -- END
	   UPDATE SysSeqNo SET SeqNo=@SeqNo WHERE Objname=@ObjName       
	   IF @@ROWCOUNT=0            
	   BEGIN            
			SET @seqno=0
	   END            	            
	   Delete from SysLockedObject with(ROWLOCK) Where ObjName='SysSeqNo'+@ObjName
  END      
        
  SELECT @SeqNo              
END

go

DROP PROCEDURE SP_getSeqNo
GO
CREATE PROCEDURE SP_getSeqNo(@AutoNum as varchar(5), @LDocNo as varchar(20), @RDocNo as varchar(20))            
AS             
BEGIN             
      
  DECLARE @SeqNo as int  
  select @SeqNo=0   
  Insert Into SysLockedObject with(ROWLOCK)(ObjName,Status,db_user) Values('SeqNo'+'-'+@AutoNum+'-'+@LDocNo+'-'+@RDocNo,'L','')            
  IF @@ROWCOUNT<>0       
  BEGIN             
	   Select @Seqno=SeqNo from SeqNo WHERE AutoNum=@AutoNum and LDocNo=@LDocNo and RDocNo=@RDocNo      
	   IF @@ROWCOUNT=0            
	   BEGIN            
			SET @seqno=0
			INSERT INTO SeqNo(AutoNum, LDocNo, RDocNo, SeqNo) VALUES (@AutoNum, @LDocNo, @RDocNo, @seqno)
	   END            

	   Select @Seqno=@Seqno+1	

	   UPDATE SeqNo SET SeqNo=@Seqno WHERE AutoNum=@AutoNum and LDocNo=@LDocNo and RDocNo=@RDocNo      
	   IF @@ROWCOUNT=0            
	   BEGIN            
			SET @seqno=0
	   END            
	   Delete from SysLockedObject with(ROWLOCK) Where ObjName='SeqNo'+'-'+@AutoNum+'-'+@LDocNo+'-'+@RDocNo
  END      
        
  SELECT @SeqNo              
END        
  
GO

/****** Object:  Table [dbo].[SysLockedObject]    Script Date: 10/25/2023 8:33:44 PM ******/
DROP TABLE [dbo].[SysLockedObject]
GO

/****** Object:  Table [dbo].[SysLockedObject]    Script Date: 10/25/2023 8:33:44 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

SET ANSI_PADDING ON
GO

CREATE TABLE [dbo].[SysLockedObject](
	[ObjName] [varchar](50) NOT NULL,
	[Status] [varchar](1) NULL,
	[db_user] [varchar](50) NULL
) ON [PRIMARY]

GO

SET ANSI_PADDING OFF
GO

ALTER TABLE [dbo].[SysLockedObject] SET (LOCK_ESCALATION = DISABLE)
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Object Name' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'SysLockedObject', @level2type=N'COLUMN',@level2name=N'ObjName'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Locked Object Status ''U''nlocked, ''L''ocked' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'SysLockedObject', @level2type=N'COLUMN',@level2name=N'Status'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Processing User' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'SysLockedObject', @level2type=N'COLUMN',@level2name=N'db_user'
GO


BEGIN TRANSACTION
SET QUOTED_IDENTIFIER ON
SET ARITHABORT ON
SET NUMERIC_ROUNDABORT OFF
SET CONCAT_NULL_YIELDS_NULL ON
SET ANSI_NULLS ON
SET ANSI_PADDING ON
SET ANSI_WARNINGS ON
COMMIT
BEGIN TRANSACTION
GO
ALTER TABLE dbo.SysLockedObject ADD CONSTRAINT
	I_SysLockedObject PRIMARY KEY NONCLUSTERED 
	(
	ObjName
	) WITH( STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]

GO
ALTER TABLE dbo.SysLockedObject SET (LOCK_ESCALATION = DISABLE)
GO
COMMIT






ALTER TABLE dbo.SysLockedObject ADD SPIDFILTER SMALLINT NOT NULL DEFAULT @@spid
go
ALTER TABLE dbo.SysLockedObject ADD CONSTRAINT chSPidFIlter CHECK (SPIDFILTER = @@SPID)
go
CREATE CLUSTERED INDEX I_SysLockedObject_SPID ON dbo.SysLockedObject (SPIDFILTER )
go



insert into PatchVersioning
select '1012 Update Script - Patch 2023 SyslockedObject',GETDATE()
go
	

Declare @PrevScript varchar(100)
Declare @CurrScript varchar(100)

Select @PrevScript=''
Select @CurrSCript='1012 Update Script - Patch 2023 SyslockedObject'


Declare @ExecScript varchar(100)
Declare @ExecScriptStatus varchar(100)
Declare @Error varchar(200)

Select @Error=''

Begin 
       Select @ExecScript=Execscript,  @ExecScriptStatus=ExecScriptStatus from systab 
       if @PrevScript<>'' and @ExecSCript<>@PrevScript
              THROW 51000, 'Not the Next Sequence Script', 1;
       else 
              if @ExecScriptStatus<>'' and @ExecScriptStatus<>'DONE'
              THROW 51000, 'Pending Script Execution', 1;

       Update SysTab Set ExecScript=@CurrScript, ExecScriptStatus='PENDING'             
       
       BEGIN TRY            
			PRINT '--EXECUTE DONE--'
       END TRY  
       BEGIN CATCH  
       END CATCH;


       Update SysTab Set ExecScript=@CurrScript, ExecScriptStatus='DONE'         
End




go