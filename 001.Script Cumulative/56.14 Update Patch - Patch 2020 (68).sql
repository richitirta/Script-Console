IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'FK_ReClassDet_RECLASS') AND parent_object_id = OBJECT_ID(N'ReclassDet'))
begin
Alter Table ReclassDet drop constraint FK_ReClassDet_RECLASS
END
GO
IF EXISTS(SELECT * FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS WHERE TABLE_NAME='REclass' AND CONSTRAINT_NAME='I_RECLASS')
Begin
alter table REclass drop constraint I_RECLASS
END
GO
IF EXISTS (SELECT *  FROM sys.indexes WHERE name='I_ReClass' AND object_id = OBJECT_ID('REclass'))
BEGIN
drop index REclass.I_ReClass
end
GO

ALTER TABLE dbo.RECLASS ADD CONSTRAINT
	I_RECLASS PRIMARY KEY CLUSTERED 
	(
	RNO,
	TOC
	) WITH( STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]

GO

ALTER TABLE [dbo].[RECLASSDET]  WITH NOCHECK ADD  CONSTRAINT [FK_ReClassDet_RECLASS] FOREIGN KEY([RNO], [TOC])
REFERENCES [dbo].[RECLASS] ([RNO], [TOC])
ON UPDATE CASCADE
ON DELETE CASCADE
GO

ALTER TABLE [dbo].[RECLASSDET] CHECK CONSTRAINT [FK_ReClassDet_RECLASS]

GO

IF EXISTS (SELECT *  FROM sys.indexes WHERE name='I_CLAIM_EventNo' AND object_id = OBJECT_ID('Claim'))
BEGIN
Drop index Claim.I_CLAIM_EventNo
end
GO

create index I_CLAIM_EventNo on Claim(EventNO) Include(CNO, TOC)

GO


insert into PatchVersioning
select '56.14 Update Patch - Patch 2020 (68)',GETDATE()
go

Declare @PrevScript varchar(100)
Declare @CurrScript varchar(100)

Select @PrevScript='56.13 Update Patch - Patch 2020 (67)'
Select @CurrSCript='56.14 Update Patch - Patch 2020 (68)'


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
