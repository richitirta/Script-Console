IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'Attachment_1' AND Object_ID = Object_ID(N'APDBucket'))
BEGIN
ALTER TABLE dbo.APDBucket ADD
	Attachment_1 varchar(20)
DECLARE @v sql_variant 
SET @v = N'Attachment_1'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'APDBucket', N'COLUMN', N'Attachment_1'
END
GO
IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'SaveLocationAttachment_1' AND Object_ID = Object_ID(N'APDBucket'))
BEGIN
ALTER TABLE dbo.APDBucket ADD
	SaveLocationAttachment_1 varchar(255) 
DECLARE @v sql_variant 
SET @v = N'SaveLocationAttachment_1'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'APDBucket', N'COLUMN', N'SaveLocationAttachment_1'
END
GO
IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'Attachment_2' AND Object_ID = Object_ID(N'APDBucket'))
BEGIN
ALTER TABLE dbo.APDBucket ADD
	Attachment_2 varchar(20)
DECLARE @v sql_variant 
SET @v = N'Attachment_2'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'APDBucket', N'COLUMN', N'Attachment_2'
END
GO
IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'SaveLocationAttachment_2' AND Object_ID = Object_ID(N'APDBucket'))
BEGIN
ALTER TABLE dbo.APDBucket ADD
	SaveLocationAttachment_2 varchar(255)
DECLARE @v sql_variant 
SET @v = N'SaveLocationAttachment_2'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'APDBucket', N'COLUMN', N'SaveLocationAttachment_2'
END
GO
IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'Attachment_3' AND Object_ID = Object_ID(N'APDBucket'))
BEGIN
ALTER TABLE dbo.APDBucket ADD
	Attachment_3 varchar(20)
DECLARE @v sql_variant 
SET @v = N'Attachment_3'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'APDBucket', N'COLUMN', N'Attachment_3'
END
GO
IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'SaveLocationAttachment_3' AND Object_ID = Object_ID(N'APDBucket'))
BEGIN
ALTER TABLE dbo.APDBucket ADD
	SaveLocationAttachment_3 varchar(255)
DECLARE @v sql_variant 
SET @v = N'SaveLocationAttachment_3'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'APDBucket', N'COLUMN', N'SaveLocationAttachment_3'
END
GO
IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'Attachment_4' AND Object_ID = Object_ID(N'APDBucket'))
BEGIN
ALTER TABLE dbo.APDBucket ADD
	Attachment_4 varchar(20)
DECLARE @v sql_variant 
SET @v = N'Attachment_4'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'APDBucket', N'COLUMN', N'Attachment_4'
END
GO
IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'SaveLocationAttachment_4' AND Object_ID = Object_ID(N'APDBucket'))
BEGIN
ALTER TABLE dbo.APDBucket ADD
	SaveLocationAttachment_4 varchar(255)
DECLARE @v sql_variant 
SET @v = N'SaveLocationAttachment_4'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'APDBucket', N'COLUMN', N'SaveLocationAttachment_4'
END
GO
IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'Attachment_5' AND Object_ID = Object_ID(N'APDBucket'))
BEGIN
ALTER TABLE dbo.APDBucket ADD
	Attachment_5 varchar(20)
DECLARE @v sql_variant 
SET @v = N'Attachment_5'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'APDBucket', N'COLUMN', N'Attachment_5'
END
GO
IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'SaveLocationAttachment_5' AND Object_ID = Object_ID(N'APDBucket'))
BEGIN
ALTER TABLE dbo.APDBucket ADD
	SaveLocationAttachment_5 varchar(255)
DECLARE @v sql_variant 
SET @v = N'SaveLocationAttachment_5'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'APDBucket', N'COLUMN', N'SaveLocationAttachment_5'
END
GO
IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'Attachment_6' AND Object_ID = Object_ID(N'APDBucket'))
BEGIN
ALTER TABLE dbo.APDBucket ADD
	Attachment_6 varchar(20)
DECLARE @v sql_variant 
SET @v = N'Attachment_6'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'APDBucket', N'COLUMN', N'Attachment_6'
END
GO
IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'SaveLocationAttachment_6' AND Object_ID = Object_ID(N'APDBucket'))
BEGIN
ALTER TABLE dbo.APDBucket ADD
	SaveLocationAttachment_6 varchar(255)
DECLARE @v sql_variant 
SET @v = N'SaveLocationAttachment_6'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'APDBucket', N'COLUMN', N'SaveLocationAttachment_6'
END
GO
IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'Attachment_7' AND Object_ID = Object_ID(N'APDBucket'))
BEGIN
ALTER TABLE dbo.APDBucket ADD
	Attachment_7 varchar(20)
DECLARE @v sql_variant 
SET @v = N'Attachment_7'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'APDBucket', N'COLUMN', N'Attachment_7'
END
GO
IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'SaveLocationAttachment_7' AND Object_ID = Object_ID(N'APDBucket'))
BEGIN
ALTER TABLE dbo.APDBucket ADD
	SaveLocationAttachment_7 varchar(255)
DECLARE @v sql_variant 
SET @v = N'SaveLocationAttachment_7'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'APDBucket', N'COLUMN', N'SaveLocationAttachment_7'
END
GO
IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'Attachment_8' AND Object_ID = Object_ID(N'APDBucket'))
BEGIN
ALTER TABLE dbo.APDBucket ADD
	Attachment_8 varchar(20)
DECLARE @v sql_variant 
SET @v = N'Attachment_8'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'APDBucket', N'COLUMN', N'Attachment_8'
END
GO
IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'SaveLocationAttachment_8' AND Object_ID = Object_ID(N'APDBucket'))
BEGIN
ALTER TABLE dbo.APDBucket ADD
	SaveLocationAttachment_8 varchar(255)
DECLARE @v sql_variant 
SET @v = N'SaveLocationAttachment_8'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'APDBucket', N'COLUMN', N'SaveLocationAttachment_8'
END
GO
IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'ID' AND Object_ID = Object_ID(N'APDBucket'))
BEGIN
ALTER TABLE dbo.APDBucket ADD
	ID varchar(max)
DECLARE @v sql_variant 
SET @v = N'ID'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'APDBucket', N'COLUMN', N'ID'
END
GO
IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'neddstampdutyF' AND Object_ID = Object_ID(N'APDBucket'))
BEGIN
ALTER TABLE dbo.APDBucket ADD
	neddstampdutyF varchar(max)
DECLARE @v sql_variant 
SET @v = N'ID'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'APDBucket', N'COLUMN', N'neddstampdutyF'
END
GO


  insert into PatchVersioning
select '1126 Update Script APDBucket AutoBilling',GETDATE()
go
  
Declare @PrevScript varchar(100)
Declare @CurrScript varchar(100)

Select @PrevScript=''
Select @CurrSCript='1126 Update Script APDBucket AutoBilling'


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



