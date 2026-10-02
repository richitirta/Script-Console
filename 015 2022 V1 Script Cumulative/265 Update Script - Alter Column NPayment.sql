
IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS WHERE TABLE_NAME='pVoucher' AND CONSTRAINT_NAME='DF_pVoucher_NPayment')
Begin
alter table pVoucher drop constraint DF_pVoucher_NPayment
end
GO

IF EXISTS(SELECT default_constraints.name FROM sys.all_columns INNER JOIN sys.tables ON all_columns.object_id = tables.object_id INNER JOIN sys.schemas ON tables.schema_id = schemas.schema_id INNER JOIN sys.default_constraints ON all_columns.default_object_id = default_constraints.object_id
WHERE schemas.name = 'dbo' AND tables.name = 'pVoucher' AND default_constraints.name = 'DF_pVoucher_NPayment')
Begin
alter table pVoucher drop constraint DF_pVoucher_NPayment
end
GO

alter table pVoucher Alter Column NPayment Int

GO

IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS WHERE TABLE_NAME='nVoucher' AND CONSTRAINT_NAME='DF_nVoucher_NPayment')
Begin
alter table nVoucher drop constraint DF_nVoucher_NPayment
end
GO

IF EXISTS(SELECT default_constraints.name FROM sys.all_columns INNER JOIN sys.tables ON all_columns.object_id = tables.object_id INNER JOIN sys.schemas ON tables.schema_id = schemas.schema_id INNER JOIN sys.default_constraints ON all_columns.default_object_id = default_constraints.object_id
WHERE schemas.name = 'dbo' AND tables.name = 'nVoucher' AND default_constraints.name = 'DF_nVoucher_NPayment')
Begin
alter table nVoucher drop constraint DF_nVoucher_NPayment
end
GO

alter table nVoucher Alter Column NPayment Int

GO
IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS WHERE TABLE_NAME='mVoucher' AND CONSTRAINT_NAME='DF_mVoucher_NPayment')
Begin
alter table mVoucher drop constraint DF_mVoucher_NPayment
end
GO

IF EXISTS(SELECT default_constraints.name FROM sys.all_columns INNER JOIN sys.tables ON all_columns.object_id = tables.object_id INNER JOIN sys.schemas ON tables.schema_id = schemas.schema_id INNER JOIN sys.default_constraints ON all_columns.default_object_id = default_constraints.object_id
WHERE schemas.name = 'dbo' AND tables.name = 'mVoucher' AND default_constraints.name = 'DF_mVoucher_NPayment')
Begin
alter table mVoucher drop constraint DF_mVoucher_NPayment
end
GO

alter table mVoucher Alter Column NPayment Int
go



 insert into PatchVersioning
select '265 Update Script - Alter Column NPayment',GETDATE()
go


Declare @PrevScript varchar(100)
Declare @CurrScript varchar(100)

Select @PrevScript=''
Select @CurrSCript='265 Update Script - Alter Column NPayment'


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
