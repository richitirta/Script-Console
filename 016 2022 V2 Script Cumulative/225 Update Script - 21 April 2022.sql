IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'RegisteredNo' AND Object_ID = Object_ID(N'TOC'))
BEGIN
ALTER TABLE dbo.TOC ADD
	RegisteredNo varchar(20) NULL
DECLARE @v sql_variant 
SET @v = N'Product Registered Number'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'TOC', N'COLUMN', N'RegisteredNo'
end
GO
IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'RegisteredName' AND Object_ID = Object_ID(N'TOC'))
BEGIN
ALTER TABLE dbo.TOC ADD
	RegisteredName varchar(255) NULL
DECLARE @v sql_variant 
SET @v = N'Product Registered Name'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'TOC', N'COLUMN', N'RegisteredName'
end
GO
IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'RegisteredDescription' AND Object_ID = Object_ID(N'TOC'))
BEGIN
ALTER TABLE dbo.TOC ADD
	RegisteredDescription varchar(512) NULL
DECLARE @v sql_variant 
SET @v = N'Product Registered Description'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'TOC', N'COLUMN', N'RegisteredDescription'
end
GO
IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'RegisteredDate' AND Object_ID = Object_ID(N'TOC'))
BEGIN
ALTER TABLE dbo.TOC ADD
	RegisteredDate smalldatetime NULL
DECLARE @v sql_variant 
SET @v = N'Product Registered Date'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'TOC', N'COLUMN', N'RegisteredDate'
end
GO




 insert into PatchVersioning
select '225 Update Script - 21 April 2022',GETDATE()
go


Declare @PrevScript varchar(100)
Declare @CurrScript varchar(100)

Select @PrevScript=''
Select @CurrSCript='225 Update Script - 21 April 2022'


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
