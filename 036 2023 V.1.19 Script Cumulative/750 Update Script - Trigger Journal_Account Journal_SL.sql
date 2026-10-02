
IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS WHERE TABLE_NAME='Journal_Account' AND CONSTRAINT_NAME='FK_Journal_ACCOUNT_Source')
Begin
Alter Table Journal_Account drop constraint FK_Journal_ACCOUNT_Source
end
GO
IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS WHERE TABLE_NAME='Journal_SL' AND CONSTRAINT_NAME='FK_Journal_SL_Source')
Begin
Alter Table Journal_SL drop constraint FK_Journal_SL_Source
END
GO
DROP TRIGGER DROP_SOURCE_LINK
GO
CREATE TRIGGER DROP_SOURCE_LINK
ON SOURCE
AFTER DELETE
AS
BEGIN
       Delete I from Journal_Account I, Deleted D Where I.Source=D.Source
          Delete I from Journal_SL I, Deleted D Where I.Source=D.Source
END
go


 insert into PatchVersioning	
select '750 Update Script - Trigger Journal_Account Journal_SL',GETDATE()
go





Declare @PrevScript varchar(100)
Declare @CurrScript varchar(1004)

Select @PrevScript=''
Select @CurrSCript='750 Update Script - Trigger Journal_Account Journal_SL'


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



