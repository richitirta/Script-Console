
insert into PatchVersioning
select '56.17 Update Patch - Patch 2020 (73)',GETDATE()
go

Declare @PrevScript varchar(100)
Declare @CurrScript varchar(100)

Select @PrevScript='56.16 Update Patch - Patch 2020 (70)'
Select @CurrSCript='56.17 Update Patch - Patch 2020 (73)'


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
			DROP PROCEDURE SP_getIdentity
			DROP PROCEDURE SP_getSeqNo
       END TRY  
       BEGIN CATCH  
       END CATCH;


       Update SysTab Set ExecScript=@CurrScript, ExecScriptStatus='DONE'         
End


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
  


