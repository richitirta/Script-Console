
IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS WHERE TABLE_NAME='pSLSUM' AND CONSTRAINT_NAME='I_PSLSUM')
Begin
Alter Table pSLSUM drop constraint I_PSLSUM
end
GO
IF not EXISTS (SELECT * FROM sys.indexes WHERE name='I_pSLSum' AND object_id = OBJECT_ID(N'pSLSum'))
Begin
Create unique index I_pSLSum on pSLSum(Voucher, Branch, Account)
end
go



insert into PatchVersioning
select '985 Update Script - Patch 2024 (19)',GETDATE()
go


Declare @PrevScript varchar(100)
Declare @CurrScript varchar(100)

Select @PrevScript=''
Select @CurrSCript='985 Update Script - Patch 2024 (19)'


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
