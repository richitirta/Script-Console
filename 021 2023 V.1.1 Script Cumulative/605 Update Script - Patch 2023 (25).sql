IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'FK_ACCINVOICE_ICOVER') AND parent_object_id = OBJECT_ID(N'ACCInvoice'))
begin
alter table ACCInvoice drop constraint FK_ACCINVOICE_ICOVER
end
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'ICOVERICOVERDET') AND parent_object_id = OBJECT_ID(N'ICoverDet'))
begin
alter table ICoverDet drop constraint ICOVERICOVERDET
end
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'FK_ICoverDet_ICOVER') AND parent_object_id = OBJECT_ID(N'ICoverDet'))
begin
alter table ICoverDet drop constraint FK_ICoverDet_ICOVER
end
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'FK_ICOVEREXT_ICOVER') AND parent_object_id = OBJECT_ID(N'ICOVEREXT'))
begin
alter table ICOVEREXT drop constraint FK_ICOVEREXT_ICOVER
end
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'ICOVERICOVERNOC') AND parent_object_id = OBJECT_ID(N'ICOVERNOC'))
begin
alter table ICOVERNOC drop constraint ICOVERICOVERNOC
end
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'FK_ICOVERNOC_ICOVER') AND parent_object_id = OBJECT_ID(N'ICOVERNOC'))
begin
alter table ICOVERNOC drop constraint FK_ICOVERNOC_ICOVER
end
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'ICOVERIINFO') AND parent_object_id = OBJECT_ID(N'IINFO'))
begin
alter table IINFO drop constraint ICOVERIINFO
end
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'FK_IINFO_ICOVER') AND parent_object_id = OBJECT_ID(N'IINFO'))
begin
alter table IINFO drop constraint FK_IINFO_ICOVER
end
GO

IF  not EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'FK_ACCINVOICE_ICOVER') AND parent_object_id = OBJECT_ID(N'ACCINVOICE'))
begin
ALTER TABLE [dbo].[ACCINVOICE]  WITH NOCHECK ADD  CONSTRAINT [FK_ACCINVOICE_ICOVER] FOREIGN KEY(INO)
REFERENCES [dbo].[ICOVER] (INO)
ON UPDATE CASCADE
ON DELETE CASCADE
end
GO

ALTER TABLE [dbo].[ACCINVOICE] CHECK CONSTRAINT [FK_ACCINVOICE_ICOVER]
GO

IF  not EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'FK_ICOVERDET_ICOVER') AND parent_object_id = OBJECT_ID(N'ICOVERDET'))
begin
ALTER TABLE [dbo].[ICOVERDET]  WITH NOCHECK ADD  CONSTRAINT [FK_ICOVERDET_ICOVER] FOREIGN KEY(INO)
REFERENCES [dbo].[ICOVER] (INO)
ON UPDATE CASCADE
ON DELETE CASCADE
end
GO

ALTER TABLE [dbo].[ICOVERDET] CHECK CONSTRAINT [FK_ICOVERDET_ICOVER]
GO

IF  not EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'FK_ICOVEREXT_ICOVER') AND parent_object_id = OBJECT_ID(N'ICOVEREXT'))
begin
ALTER TABLE [dbo].[ICOVEREXT]  WITH NOCHECK ADD  CONSTRAINT [FK_ICOVEREXT_ICOVER] FOREIGN KEY(INO)
REFERENCES [dbo].[ICOVER] (INO)
ON UPDATE CASCADE
ON DELETE CASCADE
end
GO

ALTER TABLE [dbo].[ICOVEREXT] CHECK CONSTRAINT [FK_ICOVEREXT_ICOVER]
GO

IF  not EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'FK_ICOVERNOC_ICOVER') AND parent_object_id = OBJECT_ID(N'ICOVERNOC'))
begin
ALTER TABLE [dbo].[ICOVERNOC]  WITH NOCHECK ADD  CONSTRAINT [FK_ICOVERNOC_ICOVER] FOREIGN KEY(INO)
REFERENCES [dbo].[ICOVER] (INO)
ON UPDATE CASCADE
ON DELETE CASCADE
end
GO

ALTER TABLE [dbo].[ICOVERNOC] CHECK CONSTRAINT [FK_ICOVERNOC_ICOVER]
GO

IF  not EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'FK_IINFO_ICOVER') AND parent_object_id = OBJECT_ID(N'IINFO'))
begin
ALTER TABLE [dbo].[IINFO]  WITH NOCHECK ADD  CONSTRAINT [FK_IINFO_ICOVER] FOREIGN KEY(INO)
REFERENCES [dbo].[ICOVER] (INO)
ON UPDATE CASCADE
ON DELETE CASCADE
end
GO

ALTER TABLE [dbo].[IINFO] CHECK CONSTRAINT [FK_IINFO_ICOVER]
GO

IF EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'I_ACCINVOICE') AND parent_object_id = OBJECT_ID(N'ACCINVOICE'))
begin
alter table ACCINVOICE drop constraint I_ACCINVOICE
end
GO
IF not EXISTS (SELECT *  FROM sys.indexes WHERE name='I_ACCINVOICE' AND object_id = OBJECT_ID('ACCINVOICE'))
begin
create unique index I_ACCINVOICE on ACCINVOICE(INO)
end
GO
IF not EXISTS (SELECT *  FROM sys.indexes WHERE name='I_ACCINVOICE_ANO' AND object_id = OBJECT_ID('ACCINVOICE'))
begin
create index I_ACCINVOICE_ANO on ACCINVOICE(ANO)
end
go



 insert into PatchVersioning	
select '605 Update Script - Patch 2023 (25)',GETDATE()
go





Declare @PrevScript varchar(100)
Declare @CurrScript varchar(100)

Select @PrevScript=''
Select @CurrSCript='605 Update Script - Patch 2023 (25)'


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


