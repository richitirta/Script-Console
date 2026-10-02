IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'CBRAID' AND Object_ID = Object_ID(N'Profile'))
BEGIN
ALTER TABLE dbo.Profile ADD
	CBRAID varchar(255) NULL
DECLARE @v sql_variant 
SET @v = N'Category Based Risk Assessment ID'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'Profile', N'COLUMN', N'CBRAID'
end
GO

IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'CBRADATE' AND Object_ID = Object_ID(N'Profile'))
BEGIN
ALTER TABLE dbo.Profile ADD
	CBRADATE smallint NULL
DECLARE @v sql_variant 
SET @v = N'Category Based Risk Assessment Date'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'Profile', N'COLUMN', N'CBRADATE'
end
GO

IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'CBRANRDATE' AND Object_ID = Object_ID(N'Profile'))
BEGIN
ALTER TABLE dbo.Profile ADD
	CBRANRDATE smalldatetime NULL
DECLARE @v sql_variant 
SET @v = N'Category Based Risk Assessment Next Refresh Date'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'Profile', N'COLUMN', N'CBRANRDATE'
end
GO




 insert into PatchVersioning
select '250 Update Script - 13 May 2022 (1)',GETDATE()
go


Declare @PrevScript varchar(100)
Declare @CurrScript varchar(100)

Select @PrevScript=''
Select @CurrSCript='250 Update Script - 13 May 2022 (1)'


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




