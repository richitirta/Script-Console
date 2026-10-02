IF EXISTS ( SELECT * FROM   sysobjects WHERE  id = object_id(N'QCLLOSS') and OBJECTPROPERTY(id, N'IsProcedure') = 1 )
BEGIN
DROP PROCEDURE QCLLOSS
END
GO
CREATE PROCEDURE QCLLOSS(@PCNO AS INTEGER, @PINO AS INTEGER,@P_ID AS VARCHAR(255), @P_NOC as VARCHAR(10),@P_Currency as VARCHAR(5), @P_RefNO as varchar(50)='%')   
AS   
SELECT *   
FROM CLLOSS   
WHERE CLLOSS.CNO=@PCNO AND CLLOSS.INO=@PINO and CLLOSS.PAYMENT=@P_ID and CLLOSS.NOC=@P_NOC and CLLOSS.CURRENCY=@P_Currency and CLLOSS.REFNO Like @P_RefNo   
   
GO

insert into PatchVersioning
select '55.27 Update Script - Patch 2020 (27)',GETDATE()
go


Declare @PrevScript varchar(100)
Declare @CurrScript varchar(100)

Select @PrevScript='55.26 Update Script - Patch 2020 (26)'
Select @CurrSCript='55.27 Update Script - Patch 2020 (27)'


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


