IF EXISTS ( SELECT * FROM   sysobjects WHERE  id = object_id(N'QSchemeBeneficiaries') and OBJECTPROPERTY(id, N'IsProcedure') = 1 )
BEGIN
DROP PROCEDURE QSchemeBeneficiaries 
END
GO
CREATE PROCEDURE QSchemeBeneficiaries (@P_TrNo as integer, @P_ID varchar(10), @P_Name varchar(255))     
AS    
Select *
from Scheme_Beneficiary 
Where TrNo=@P_TrNo and ID=@P_ID and Name=@P_Name
go




 insert into PatchVersioning
select '332 Update Script - QSchemeBeneficiaris',GETDATE()
go


Declare @PrevScript varchar(100)
Declare @CurrScript varchar(100)

Select @PrevScript=''
Select @CurrSCript='332 Update Script - QSchemeBeneficiaris'


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


