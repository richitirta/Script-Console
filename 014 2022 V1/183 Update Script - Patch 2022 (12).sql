DROP Procedure QRCESSION 
GO
CREATE Procedure QRCESSION (@P_RID varchar(255))      
as      
Select R1.ID, R1.SHARE, R1.OnMinPremiumF, R1.OnNetPremiumF, R1.COMM, R1.COMMI, R1.COMMN, R1.Fee, R1.JP,R2.RID, R1.BRID, R1.BRCOMM, R2.CESSION, CASE WHEN COALESCE(R1.DOCNO,'')='' THEN R2.DOCNO ELSE R1.DOCNO END AS DOCNO, R2.LIMIT, R2.MDP, CASE WHEN R1.CASHLOSS<>0 THEN R1.CASHLOSS ELSE R2.CASHLOSS END as CASHLOSS, R2.PRIORITYF, R2.STATEMENT, R2.UJROHREINS, R2.UJROHCEDANT, R2.TPPERIOD, R2.POLICYRUNOFFF  
from Reinsurance R2
Inner Join RPart R1 on (R1.RNO=R2.RNO AND R1.SHARE<>0)      
WHERE R2.RID=@P_RID 
GO


 insert into PatchVersioning
select '183 Update Script - Patch 2022 (12)',GETDATE()
go


Declare @PrevScript varchar(100)
Declare @CurrScript varchar(100)

Select @PrevScript=''
Select @CurrSCript='183 Update Script - Patch 2022 (12)'


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


