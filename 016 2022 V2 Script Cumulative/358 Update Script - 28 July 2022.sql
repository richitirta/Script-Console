

IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'Category' AND Object_ID = Object_ID(N'Budget_AccountGroup'))
BEGIN
ALTER TABLE dbo.Budget_AccountGroup ADD
	Category varchar(10) NULL
DECLARE @v sql_variant 
SET @v = N'Budget Category (ROUTINE/PROJECT)'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'Budget_AccountGroup', N'COLUMN', N'Category'
end
go

IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'AllowedF' AND Object_ID = Object_ID(N'Budget_AccountGroup'))
BEGIN
ALTER TABLE dbo.Budget_AccountGroup ADD
	AllowedF bit NULL
DECLARE @v sql_variant 
SET @v = N'Allow Flag (0 : No, 1 : Yes)'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'Budget_AccountGroup', N'COLUMN', N'AllowedF'
end
GO



IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'AllowedF' AND Object_ID = Object_ID(N'Budget_AccountDetail'))
BEGIN
ALTER TABLE dbo.Budget_AccountDetail ADD
	AllowedF bit NULL
DECLARE @v sql_variant 
SET @v = N'Allow Flag (0 : No, 1 : Yes)'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'Budget_AccountDetail', N'COLUMN', N'AllowedF'
end
GO


IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'AllowedF' AND Object_ID = Object_ID(N'Budget_Account'))
BEGIN
ALTER TABLE dbo.Budget_Account ADD
	AllowedF bit NULL
DECLARE @v sql_variant 
SET @v = N'Allow Flag (0 : No, 1 : Yes)'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'Budget_Account', N'COLUMN', N'AllowedF'
end
GO


IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'Country' AND Object_ID = Object_ID(N'Bank'))
BEGIN
ALTER TABLE dbo.Bank ADD
	Country varchar(10) NULL
DECLARE @v sql_variant 
SET @v = N'Country Code (see Country Table)'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'Bank', N'COLUMN', N'Country'
end

GO




 insert into PatchVersioning
select '358 Update Script - 28 July 2022',GETDATE()
go


Declare @PrevScript varchar(100)
Declare @CurrScript varchar(100)

Select @PrevScript=''
Select @CurrSCript='358 Update Script - 28 July 2022'


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