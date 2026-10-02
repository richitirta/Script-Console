IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'Month' AND Object_ID = Object_ID(N'TaxTable'))
BEGIN

SET QUOTED_IDENTIFIER ON
SET ARITHABORT ON
SET NUMERIC_ROUNDABORT OFF
SET CONCAT_NULL_YIELDS_NULL ON
SET ANSI_NULLS ON
SET ANSI_PADDING ON
SET ANSI_WARNINGS ON


ALTER TABLE dbo.TaxTable ADD
	Month int NULL
end
GO
Update TaxTable Set Month=0 Where Month is null
GO


IF EXISTS(SELECT * FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS WHERE TABLE_NAME='TaxTable' AND CONSTRAINT_NAME='I_TaxTable')
begin
Alter Table dbo.TaxTable drop constraint I_TaxTable
end
GO

Alter Table dbo.TaxTable alter column Month Int Not Null
GO

IF not EXISTS(SELECT * FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS WHERE TABLE_NAME='TaxTable' AND CONSTRAINT_NAME='I_TaxTable')
begin
Alter Table dbo.TaxTable add constraint I_TaxTable primary key nonclustered (Year,Month, ID,Currency)
end
GO


IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'Month' AND Object_ID = Object_ID(N'TaxTablePaid'))
BEGIN

SET QUOTED_IDENTIFIER ON
SET ARITHABORT ON
SET NUMERIC_ROUNDABORT OFF
SET CONCAT_NULL_YIELDS_NULL ON
SET ANSI_NULLS ON
SET ANSI_PADDING ON
SET ANSI_WARNINGS ON


ALTER TABLE dbo.TaxTablePaid ADD
	Month int NULL
end
GO
Update TaxTablePaid Set Month=0 Where Month is null
GO

IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS WHERE TABLE_NAME='TaxTablePaid' AND CONSTRAINT_NAME='I_TaxTablePaid')
Begin
ALTER TABLE [dbo].TaxTablePaid DROP CONSTRAINT I_TaxTablePaid
END
GO

IF EXISTS (SELECT *  FROM sys.indexes WHERE name='I_TaxTablePaid' AND object_id = OBJECT_ID('TaxTablePaid'))
BEGIN
drop index TaxTablePaid.I_TaxTablePaid
end
GO

Alter Table dbo.TaxTablePaid Alter Column Month Int Not Null
GO
Alter Table dbo.TaxTablePaid Alter Column Year Int  Not Null
GO
Alter Table dbo.TaxTablePaid Alter Column ID varchar(10) Not Null
GO

Alter Table dbo.TaxTablePaid add constraint I_TaxTablePaid primary key  nonclustered (Year,Month, ID)
GO




insert into PatchVersioning
select '934 Update Script - 1 February  2024',GETDATE()
go


Declare @PrevScript varchar(100)
Declare @CurrScript varchar(100)

Select @PrevScript=''
Select @CurrSCript='934 Update Script - 1 February  2024'


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
