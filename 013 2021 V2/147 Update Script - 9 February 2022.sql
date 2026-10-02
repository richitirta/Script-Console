
IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'Amount' AND Object_ID = Object_ID(N'TOP_Interest'))
BEGIN
ALTER TABLE dbo.TOP_Interest ADD
	Amount float(53) NULL
DECLARE @v sql_variant 
SET @v = N'Default Limit Liability'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'TOP_Interest', N'COLUMN', N'Amount'
end
GO

IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'Amount_AOE' AND Object_ID = Object_ID(N'TOP_Interest'))
BEGIN
ALTER TABLE dbo.TOP_Interest ADD
	Amount_AOE float(53) NULL
DECLARE @v sql_variant 
SET @v = N'Default Max Liability'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'TOP_Interest', N'COLUMN', N'Amount_AOE'
end
GO


IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'SI' AND Object_ID = Object_ID(N'TOP_Interest'))
BEGIN
ALTER TABLE dbo.TOP_Interest ADD
	SI float(53) NULL
DECLARE @v sql_variant 
SET @v = N'Default Sum Insured'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'TOP_Interest', N'COLUMN', N'SI'
end
GO


IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'Total' AND Object_ID = Object_ID(N'TOP_Interest'))
BEGIN
ALTER TABLE dbo.TOP_Interest ADD
	Total float(53) NULL
DECLARE @v sql_variant 
SET @v = N'Default Total SI (Aggregate)'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'TOP_Interest', N'COLUMN', N'Total'
end
GO

	


 insert into PatchVersioning
select '147 Update Script - 9 February 2022',GETDATE()
go


Declare @PrevScript varchar(100)
Declare @CurrScript varchar(100)

Select @PrevScript=''
Select @CurrSCript='147 Update Script - 9 February 2022'


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