UPDATE RPART Set DocNo=Reinsurance.DocNo FROM RPART, REINSURANCE WHERE REINSURANCE.RNO=RPART.RNO AND COALESCE(RPART.DOCNO,'')=''
GO

UPDATE RPART SET ODOCNO=DOCNO WHERE ODOCNO IS NULL
GO

UPDATE REINSURANCE SET PDATE=SDATE, AUSERID=Last_Opr, AUSERDATE=LAST_UPDATE, VSEQNO=0, ORID=RID, ODOCNO=DOCNO WHERE ODOCNO IS NULL
GO



insert into PatchVersioning
select '1581.1 Inisialisasi Update Script - 18 April 2026.sql',GETDATE()
go	
  
Declare @PrevScript varchar(100)
Declare @CurrScript varchar(100)

Select @PrevScript=''
Select @CurrSCript='1581.1 Inisialisasi Update Script - 18 April 2026.sql'


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

GO