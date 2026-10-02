

IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'OCollNo' AND Object_ID = Object_ID(N'COLLECTIONH'))
BEGIN
ALTER TABLE dbo.COLLECTIONH ADD
	OCollNo varchar(20) NULL
DECLARE @v sql_variant 
SET @v = N'Original Collection No (CollNo from Reminder=0)'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'COLLECTIONH', N'COLUMN', N'OCollNo'
END
GO

IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'{39C11D32-8159-40BD-8E95-0BAA7EC0E8F5}') AND parent_object_id = OBJECT_ID(N'CollectionH'))
ALTER TABLE CollectionH Drop constraint [{39C11D32-8159-40BD-8E95-0BAA7EC0E8F5}]
GO

IF not EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS WHERE TABLE_NAME='CollectionH' AND CONSTRAINT_NAME='FK_CollectionH_CollType')
Begin
ALTER TABLE CollectionH  WITH NOCHECK ADD  CONSTRAINT [FK_CollectionH_CollType] FOREIGN KEY([CollType])
REFERENCES [dbo].[CollType] ([CollType]) 
end
GO

IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'FK_CollectionH_CollType') AND parent_object_id = OBJECT_ID(N'CollectionH'))
ALTER TABLE CollectionH  WITH NOCHECK ADD  CONSTRAINT [FK_CollectionH_CollType] FOREIGN KEY([CollType])
REFERENCES [dbo].[CollType] ([CollType]) 
GO

ALTER TABLE [dbo].[COLLECTIONH] CHECK CONSTRAINT [FK_CollectionH_CollType]
GO


IF NOT EXISTS (SELECT *  FROM sys.indexes WHERE name='I_CollectionH_OCollNo' AND object_id = OBJECT_ID('CollectionH'))
BEGIN
Create Index I_CollectionH_OCollNo on CollectionH(OCollNo)
end
go


 insert into PatchVersioning
select '444 Update Script - 19 October 2022 - REV',GETDATE()
go


Declare @PrevScript varchar(100)
Declare @CurrScript varchar(100)

Select @PrevScript=''
Select @CurrSCript='444 Update Script - 19 October 2022 - REV'


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


