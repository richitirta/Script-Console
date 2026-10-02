

IF  NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'COMPLIANCEI') AND type in (N'U'))
BEGIN
CREATE TABLE dbo.COMPLIANCEI
	(
	CID varchar(10) NOT NULL,
	INDICATOR varchar(10) NOT NULL,
	SLOWER int NULL,
	SUPPER int NULL,
	LAST_UPDATE smalldatetime NULL,
	LAST_OPR varchar(50) NULL
	)  ON [PRIMARY]

DECLARE @v sql_variant 
SET @v = N'Compliance Risk ID (see COMPLIANCE)'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'COMPLIANCEI', N'COLUMN', N'CID'

DECLARE @x sql_variant 
SET @x = N'Indicator'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'COMPLIANCEI', N'COLUMN', N'INDICATOR'

DECLARE @y sql_variant 
SET @y = N'Score Lower'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'COMPLIANCEI', N'COLUMN', N'SLOWER'

DECLARE @z sql_variant 
SET @z = N'Score Upper'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'COMPLIANCEI', N'COLUMN', N'SUPPER'

DECLARE @a sql_variant 
SET @a = N'Last Update Date'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'COMPLIANCEI', N'COLUMN', N'LAST_UPDATE'

DECLARE @b sql_variant 
SET @b = N'Last User Update '
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'COMPLIANCEI', N'COLUMN', N'LAST_OPR'
end
go

IF NOT EXISTS(SELECT * FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS WHERE TABLE_NAME='COMPLIANCEI' AND CONSTRAINT_NAME='I_COMPLIANCEI')
BEGIN
ALTER TABLE COMPLIANCEI ADD CONSTRAINT
	I_COMPLIANCEI PRIMARY KEY CLUSTERED 
	(
	CID,
	INDICATOR
	) WITH( STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
end
GO

IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS WHERE TABLE_NAME='COMPLIANCEI' AND CONSTRAINT_NAME='FK_COMPLIANCEI_COMPLIANCE')
BEGIN
ALTER TABLE [dbo].[COMPLIANCEI]  WITH NOCHECK ADD  CONSTRAINT [FK_COMPLIANCEI_COMPLIANCE] FOREIGN KEY([CID])
REFERENCES [dbo].[COMPLIANCE] ([CID])
ON UPDATE CASCADE
ON DELETE CASCADE
end
GO

ALTER TABLE [dbo].[COMPLIANCEI] CHECK CONSTRAINT [FK_COMPLIANCEI_COMPLIANCE]
GO



IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'INDICATOR' AND Object_ID = Object_ID(N'ACCCOMPSHEETH'))
BEGIN
ALTER TABLE dbo.ACCCOMPSHEETH ADD
	INDICATOR varchar(10) NULL
DECLARE @v sql_variant 
SET @v = N'see ComplianceI'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'ACCCOMPSHEETH', N'COLUMN', N'INDICATOR'
end
GO

ALTER TABLE ACCCOMPSHEETH SET (LOCK_ESCALATION = DISABLE)
GO



 insert into PatchVersioning
select '346 Update Script - 14 July 2022',GETDATE()
go


Declare @PrevScript varchar(100)
Declare @CurrScript varchar(100)

Select @PrevScript=''
Select @CurrSCript='346 Update Script - 14 July 2022'


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

