SET QUOTED_IDENTIFIER ON
SET ARITHABORT ON
SET NUMERIC_ROUNDABORT OFF
SET CONCAT_NULL_YIELDS_NULL ON
SET ANSI_NULLS ON
SET ANSI_PADDING ON
SET ANSI_WARNINGS ON

IF EXISTS ( SELECT * FROM   sysobjects WHERE  id = object_id(N'[dbo].[QFACCDOC]') and OBJECTPROPERTY(id, N'IsProcedure') = 1 )
BEGIN DROP PROCEDURE [dbo].[QFACCDOC] END
GO

CREATE Procedure [dbo].[QFACCDOC] (@P_ANO integer,@FID Varchar(20))       
as       
SELECT A.OANO, A.ANO, A.POLICYNO, F.FID, P.ID, P.Name ReinsuranceName
FROM PROFILE P, ACCEPTANCE A
INNER JOIN FPART F ON (A.ANO=F.ANO)
WHERE P.ID=F.ID
AND A.OANO=@P_ANO      
AND F.FID=@FID      
GO

insert into PatchVersioning
select '1420 Update Script 15 Agst 2025 QFaccDoc',GETDATE()
go	
  
Declare @PrevScript varchar(100)
Declare @CurrScript varchar(100)

Select @PrevScript=''
Select @CurrScript='1420 Update Script 15 Agst 2025 QFaccDoc'


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