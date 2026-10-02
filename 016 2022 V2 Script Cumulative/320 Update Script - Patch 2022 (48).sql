IF EXISTS(SELECT * FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS WHERE TABLE_NAME='SysLockedObject' AND CONSTRAINT_NAME='I_SysLockedObject')
Begin
Alter Table SysLockedObject drop constraint I_SysLockedObject
END
GO
IF NOT EXISTS (SELECT * FROM sys.indexes WHERE name='I_SysLockedObject' AND object_id = OBJECT_ID(N'SysLockedObject'))
Begin
Create Unique Index I_SysLockedObject on SysLockedObject(objName)
END
GO
IF EXISTS(SELECT * FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS WHERE TABLE_NAME='SysSeqNo' AND CONSTRAINT_NAME='I_SysSeqNo')
Begin
Alter Table SysSeqNo drop constraint I_SysSeqNo
END
GO
IF NOT EXISTS (SELECT * FROM sys.indexes WHERE name='I_SysSeqNo' AND object_id = OBJECT_ID(N'SysSeqNo'))
Begin
Create Unique Index I_SysSeqNo on SysSeqNo(objName)
END
GO
IF EXISTS(SELECT * FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS WHERE TABLE_NAME='SeqNo' AND CONSTRAINT_NAME='I_SEQNO')
Begin
Alter Table SeqNo drop constraint I_SEQNO
END
GO
IF NOT EXISTS (SELECT * FROM sys.indexes WHERE name='I_SEQNO' AND object_id = OBJECT_ID(N'SeqNo'))
Begin
Create Unique Index I_SEQNO on SeqNo(LDocNo, RDocNo, AutoNum)
END
GO
IF EXISTS(SELECT * FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS WHERE TABLE_NAME='sysseqno' AND CONSTRAINT_NAME='DF_SysSeqNo_SeqNo')
Begin
alter table sysseqno drop constraint DF_SysSeqNo_SeqNo
END
GO
DROP PROCEDURE SP_getSeqNo
GO
CREATE PROCEDURE SP_getSeqNo(@AutoNum as varchar(5), @LDocNo as varchar(20), @RDocNo as varchar(20))            
AS             
BEGIN             
      
  DECLARE @SeqNo as int  
  select @SeqNo=0   
  Insert Into SysLockedObject (ObjName,Status,db_user) Values('SeqNo'+'-'+@AutoNum+'-'+@LDocNo+'-'+@RDocNo,'L','')            
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
	   Delete from SysLockedObject Where ObjName='SeqNo'+'-'+@AutoNum+'-'+@LDocNo+'-'+@RDocNo and Status='L'           
  END      
        
  SELECT @SeqNo              
END        
  


GO

DROP PROCEDURE SP_getIdentity
GO
CREATE PROCEDURE SP_getIdentity(@ObjName varchar(50))            
AS             
BEGIN             
  DECLARE @SeqNo as int  
  DECLARE @LSeqNo as int  
  select @SeqNo=0          
  Insert Into SysLockedObject (ObjName,Status,db_user) Values('SysSeqNo'+@ObjName,'L','')            
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
	   Delete from SysLockedObject Where ObjName='SysSeqNo'+@ObjName and Status='L'           
  END      
        
  SELECT @SeqNo              
END        



GO


 insert into PatchVersioning
select '320 Update Script - Patch 2022 (48)',GETDATE()
go


Declare @PrevScript varchar(100)
Declare @CurrScript varchar(100)

Select @PrevScript=''
Select @CurrSCript='320 Update Script - Patch 2022 (48)'


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


