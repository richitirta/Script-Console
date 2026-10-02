IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'TOPRO' AND Object_ID = Object_ID(N'BRRule'))
BEGIN
ALTER TABLE dbo.BRRule ADD
	TOPRO varchar(10) NULL
DECLARE @v sql_variant 
SET @v = N'TOPRO ID (see TOPRO)'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'BRRule', N'COLUMN', N'TOPRO'
end
GO


IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'TOPRO' AND Object_ID = Object_ID(N'BRRuleMin'))
BEGIN
ALTER TABLE dbo.BRRuleMin ADD
	TOPRO varchar(10) NULL

DECLARE @v sql_variant 
SET @v = N'TOPRO ID (see TOPRO)'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'BRRuleMin', N'COLUMN', N'TOPRO'
end
GO

IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'FK_BRRuleMin_BRRule') AND parent_object_id = OBJECT_ID(N'BRRuleMin'))
begin
Alter Table BRRuleMin Drop Constraint FK_BRRuleMin_BRRule
end
GO
IF EXISTS (SELECT *  FROM sys.indexes WHERE name='I_BRRule' AND object_id = OBJECT_ID('BRRule'))
BEGIN
drop index brrule.I_BRRule
end
GO
IF not EXISTS (SELECT *  FROM sys.indexes WHERE name='I_BRRule' AND object_id = OBJECT_ID('BRRule'))
BEGIN
Create unique index I_BRRule on BRRule(TOC, Branch, BizMapID, FacOpt, TOPRO)
end
GO
IF EXISTS (SELECT *  FROM sys.indexes WHERE name='I_brrulemin' AND object_id = OBJECT_ID('brrulemin'))
BEGIN
drop index brrulemin.I_brrulemin
end
GO

IF not EXISTS (SELECT *  FROM sys.indexes WHERE name='I_BRRuleMin' AND object_id = OBJECT_ID('BRRuleMin'))
BEGIN
Create unique index I_BRRuleMin on BRRuleMin(TOC, Branch, BizMapID, FacOpt, TOPRO, Currency)
end
GO
IF not EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'FK_BRRuleMin_BRRule') AND parent_object_id = OBJECT_ID(N'BRRuleMin'))
begin
ALTER TABLE [dbo].[BRRuleMin]  WITH NOCHECK ADD  CONSTRAINT [FK_BRRuleMin_BRRule] FOREIGN KEY([TOC], [Branch], [BizMapID], [FacOpt], [TOPRO])
REFERENCES [dbo].[BRRule] ([TOC], [Branch], [BizMapID], [FacOpt], [TOPRO]) ON UPDATE CASCADE
ON DELETE CASCADE
end
GO



 insert into PatchVersioning
select '249 Update Script - 10 May 2022 (1)',GETDATE()
go


Declare @PrevScript varchar(100)
Declare @CurrScript varchar(100)

Select @PrevScript=''
Select @CurrSCript='249 Update Script - 10 May 2022 (1)'


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





