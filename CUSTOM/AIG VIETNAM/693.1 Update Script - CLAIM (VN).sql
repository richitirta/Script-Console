DROP PROCEDURE CLCostMemberTo 
GO
CREATE PROCEDURE CLCostMemberTo (@P_CNO as integer, @P_Currency as varchar(10)) 
AS 
SELECT sum(CLCost.Amount-CLCost.VAT) AS Amount
FROM CLCost 
WHERE cno=@P_CNO and currency=@P_Currency and Status='P' and ContributionF=1 and CCollectionF=1
GO



 insert into PatchVersioning	
select '693.1 Update Script - CLAIM (VN)',GETDATE()
go





Declare @PrevScript varchar(100)
Declare @CurrScript varchar(100)

Select @PrevScript=''
Select @CurrSCript='693.1 Update Script - CLAIM (VN)'


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


