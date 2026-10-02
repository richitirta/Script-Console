
DROP PROCEDURE [dbo].[QPCOLLATERAL]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

Create Procedure QPCOLLATERAL(@PID AS VARCHAR(20))    
AS    
Select C.COLLATERALNO, MAX(C.COLLATERALTYPE) AS COLLATERALTYPE, MAX(C.DESCRIPTION) AS DESCRIPTION, MAX(C.DOCNO) AS DOCNO, MAX(C.CURRENCY) AS CURRENCY, MAX(C.STATUS) AS STATUS, MAX(C.EXPDATE) AS EXPDATE, MAX(C.RECDATE) AS RECDATE, MAX(C.RECEIVEDBY) AS RECEIVEDBY, MAX(C.RELDATE) AS RELDATE, MAX(C.RELEASEDBY) AS RELEASEDBY, MAX(C.NOMINAL) as NOMINAL, SUM(A.NOMINAL) AS ALLOCATED    
from COLLATERAL C  
OUTER APPLY (SELECT A1.NOMINAL from ACCCOLLATERAL A1, ACCEPTANCE A2 Where A1.COLLATERALNO=C.COLLATERALNO and A2.OANO=A1.ANO and A2.AStatus in ('W','T','I') and A2.AType in ('N','E')) A   
Where c.ID=@PID      
GROUP BY C.COLLATERALNO 
GO



 insert into PatchVersioning
select '862 QPCollateral new',GETDATE()
go


Declare @PrevScript varchar(100)
Declare @CurrScript varchar(100)

Select @PrevScript=''
Select @CurrSCript='862 QPCollateral new'


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
