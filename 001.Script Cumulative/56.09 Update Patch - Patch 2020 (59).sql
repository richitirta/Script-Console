IF EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'FK_GENDTOC_GENDTAB') AND parent_object_id = OBJECT_ID(N'GenDTOC'))
begin
Alter Table GenDTOC drop constraint FK_GENDTOC_GENDTAB
end
GO
IF EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'FK_GenDISType_GENDTAB') AND parent_object_id = OBJECT_ID(N'GenDISType'))
begin
Alter Table GenDISType drop constraint FK_GenDISType_GENDTAB
end
GO
IF EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'FK_GenDSegment_GENDTAB') AND parent_object_id = OBJECT_ID(N'GenDSegment'))
begin
Alter Table GenDSegment drop constraint FK_GenDSegment_GENDTAB
end
GO

IF EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'FK_ACCSEARCH_GENDTAB') AND parent_object_id = OBJECT_ID(N'ACCSEARCH'))
begin
alter table ACCSEARCH drop FK_ACCSEARCH_GENDTAB
end
go
IF EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'FK_GENDISTYPE_GENDTAB') AND parent_object_id = OBJECT_ID(N'gendistype'))
begin
alter table gendistype drop FK_GENDISTYPE_GENDTAB
end
go
IF EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'FK_GENDSEGMENT_GENDTAB') AND parent_object_id = OBJECT_ID(N'GENDSEGMENT'))
begin
alter table GENDSEGMENT drop FK_GENDSEGMENT_GENDTAB
end
go
IF EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'FK_GENDTOC_GENDTAB') AND parent_object_id = OBJECT_ID(N'GENDTOC'))
begin
alter table GENDTOC drop FK_GENDTOC_GENDTAB
end
go


--drop fk gendtab
--SEA_RAMA.dbo.GENDISTYPE: FK_GENDISTYPE_GENDTAB
--SEA_RAMA.dbo.GENDSEGMENT: FK_GENDSEGMENT_GENDTAB
--SEA_RAMA.dbo.GENDTOC: FK_GENDTOC_GENDTAB

IF EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[FK_GENDISTYPE_GENDTAB]') AND parent_object_id = OBJECT_ID(N'[GENDISTYPE]'))
begin
ALTER TABLE [dbo].[GENDISTYPE] DROP CONSTRAINT [FK_GENDISTYPE_GENDTAB]
end
GO
IF EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[FK_GENDSEGMENT_GENDTAB]') AND parent_object_id = OBJECT_ID(N'[GENDSEGMENT]'))
begin
ALTER TABLE [dbo].[GENDSEGMENT] DROP CONSTRAINT [FK_GENDSEGMENT_GENDTAB]
end
GO
IF EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[FK_GENDTOC_GENDTAB]') AND parent_object_id = OBJECT_ID(N'[GENDTOC]'))
begin
ALTER TABLE [dbo].[GENDTOC] DROP CONSTRAINT [FK_GENDTOC_GENDTAB]
end
GO

--drop index GenDTab
IF EXISTS(SELECT * FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS WHERE TABLE_NAME='GenDTab' AND CONSTRAINT_NAME='I_GenDTab')
BEGIN
alter table GenDTab drop I_GenDTab
--drop index I_GenDTab on GenDTab
end
GO
--create index GenDTab
IF not EXISTS (SELECT *  FROM sys.indexes WHERE name='I_genDTab' AND object_id = OBJECT_ID('gendtab'))
BEGIN
create unique index I_genDTab on gendtab(FLDID, VALUEID) include(Formula, AllowedF)
end
GO
--create fk GenDTab
ALTER TABLE [dbo].[GENDISTYPE]  WITH NOCHECK ADD  CONSTRAINT [FK_GENDISTYPE_GENDTAB] FOREIGN KEY([FLDID], [VALUEID])
REFERENCES [dbo].[GENDTAB] ([FLDID], [VALUEID])
ON UPDATE CASCADE
ON DELETE CASCADE
GO

ALTER TABLE [dbo].[GENDISTYPE] CHECK CONSTRAINT [FK_GENDISTYPE_GENDTAB]
GO


ALTER TABLE [dbo].[GENDSEGMENT]  WITH NOCHECK ADD  CONSTRAINT [FK_GENDSEGMENT_GENDTAB] FOREIGN KEY([FLDID], [VALUEID])
REFERENCES [dbo].[GENDTAB] ([FLDID], [VALUEID])
ON UPDATE CASCADE
ON DELETE CASCADE
GO

ALTER TABLE [dbo].[GENDSEGMENT] CHECK CONSTRAINT [FK_GENDSEGMENT_GENDTAB]
GO

ALTER TABLE [dbo].[GENDTOC]  WITH NOCHECK ADD  CONSTRAINT [FK_GENDTOC_GENDTAB] FOREIGN KEY([FLDID], [VALUEID])
REFERENCES [dbo].[GENDTAB] ([FLDID], [VALUEID])
ON UPDATE CASCADE
ON DELETE CASCADE
GO

ALTER TABLE [dbo].[GENDTOC] CHECK CONSTRAINT [FK_GENDTOC_GENDTAB]
GO



IF EXISTS (SELECT *  FROM sys.indexes WHERE name='I_GENDTAB_Description' AND object_id = OBJECT_ID('gendtab'))
BEGIN
drop index gendtab.I_GENDTAB_Description
end
GO
IF EXISTS (SELECT *  FROM sys.indexes WHERE name='I_GENDTAB_FLDID_Description' AND object_id = OBJECT_ID('gendtab'))
BEGIN
Drop index gendtab.I_GENDTAB_FLDID_Description
end
GO
IF EXISTS (SELECT *  FROM sys.indexes WHERE name='I_GENDTAB_FLDID_SFLDID_SVALUEID' AND object_id = OBJECT_ID('gendtab'))
BEGIN
Drop index gendtab.I_GENDTAB_FLDID_SFLDID_SVALUEID
end
GO
IF EXISTS (SELECT *  FROM sys.indexes WHERE name='I_GenDTab_FLDID_FORMULA_FLOWER_FUPPER' AND object_id = OBJECT_ID('gendtab'))
BEGIN
Drop index gendtab.I_GenDTab_FLDID_FORMULA_FLOWER_FUPPER
end
GO
create index I_GENDTAB_FLDID_Description on GENDTAB (FLDID, DESCRIPTION) include(ValueID, AllowedF)
GO
Create index I_GENDTAB_FLDID_SFLDID_SVALUEID on GENDTAB (FLDID, SFLDID, SVALUEID) include(ValueID, AllowedF)
GO
Create Index I_GenDTab_FLDID_FORMULA_FLOWER_FUPPER on GenDTab(FLDID,FORMULA,FLOWER,FUPPER) include(ValueID, AllowedF)
GO

IF not EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'FK_GENDTOC_GENDTAB') AND parent_object_id = OBJECT_ID(N'GENDTOC'))
begin
ALTER TABLE [dbo].[GENDTOC]  WITH NOCHECK ADD  CONSTRAINT [FK_GENDTOC_GENDTAB] FOREIGN KEY([FLDID], [VALUEID])
REFERENCES [dbo].[GENDTAB] ([FLDID], [VALUEID])
ON UPDATE CASCADE
ON DELETE CASCADE
ALTER TABLE [dbo].[GENDTOC] CHECK CONSTRAINT [FK_GENDTOC_GENDTAB]
end
GO


IF not EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[FK_GENDISTYPE_GENDTAB]') AND parent_object_id = OBJECT_ID(N'[GENDISTYPE]'))
begin
ALTER TABLE [dbo].[GENDISTYPE]  WITH NOCHECK ADD  CONSTRAINT [FK_GENDISTYPE_GENDTAB] FOREIGN KEY([FLDID], [VALUEID])
REFERENCES [dbo].[GENDTAB] ([FLDID], [VALUEID])
ON UPDATE CASCADE
ON DELETE CASCADE
ALTER TABLE [dbo].[GENDISTYPE] CHECK CONSTRAINT [FK_GENDISTYPE_GENDTAB]
end
GO


IF not EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[FK_GENDSEGMENT_GENDTAB]') AND parent_object_id = OBJECT_ID(N'[GENDSEGMENT]'))
begin
ALTER TABLE [dbo].[GENDSEGMENT]  WITH NOCHECK ADD  CONSTRAINT [FK_GENDSEGMENT_GENDTAB] FOREIGN KEY([FLDID], [VALUEID])
REFERENCES [dbo].[GENDTAB] ([FLDID], [VALUEID])
ON UPDATE CASCADE
ON DELETE CASCADE
ALTER TABLE [dbo].[GENDSEGMENT] CHECK CONSTRAINT [FK_GENDSEGMENT_GENDTAB]
end
GO


IF not EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[FK_ACCSEARCH_GENDTAB]') AND parent_object_id = OBJECT_ID(N'[ACCSEARCH]'))
begin
ALTER TABLE [dbo].[ACCSEARCH]  WITH NOCHECK ADD  CONSTRAINT [FK_ACCSEARCH_GENDTAB] FOREIGN KEY([FLDID], [VALUEID])
REFERENCES [dbo].[GENDTAB] ([FLDID], [VALUEID])
ON UPDATE CASCADE
ON DELETE CASCADE
ALTER TABLE [dbo].[ACCSEARCH] CHECK CONSTRAINT [FK_ACCSEARCH_GENDTAB]
end
GO





insert into PatchVersioning
select '56.9 Update Patch - Patch 2020 (59)',GETDATE()
go

Declare @PrevScript varchar(100)
Declare @CurrScript varchar(100)

Select @PrevScript=''
Select @CurrSCript='56.9 Update Patch - Patch 2020 (59)'


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
