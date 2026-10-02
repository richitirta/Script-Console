IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'DOCNO' AND Object_ID = Object_ID(N'Security'))
BEGIN
ALTER TABLE dbo.Security ADD
	DOCNO varchar(20) NULL
DECLARE @v sql_variant 
SET @v = N'Reinsurance Document Number (For SOA Grouping)'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'Security', N'COLUMN', N'DOCNO'
end
GO


IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'DOCNO' AND Object_ID = Object_ID(N'RPartDet'))
BEGIN
ALTER TABLE dbo.RPartDet ADD
	DOCNO varchar(20) NULL
DECLARE @v sql_variant 
SET @v = N'Reinsurance Document Number (For SOA Grouping)'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'RPartDet', N'COLUMN', N'DOCNO'
end
GO


Update Security set DocNo=RPart.DocNo from Security, RPart Where RPart.RNO=Security.RNO and RPart.ID=Security.ID
GO

Update RPartDet set DocNo=RPart.DocNo from RPartDet, RPart Where RPart.RNO=RPartDet.RNO and RPart.ID=RPartDet.ID
GO


IF EXISTS(SELECT * FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS WHERE TABLE_NAME='RPArtDet' AND CONSTRAINT_NAME='RPARTRPARTDET')
Begin
alter table RPArtDet Drop Constraint RPARTRPARTDET
end
GO
IF EXISTS(SELECT * FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS WHERE TABLE_NAME='Security' AND CONSTRAINT_NAME='FK_Security_RPART')
Begin
alter table Security Drop Constraint FK_Security_RPART
end
GO

IF EXISTS(SELECT * FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS WHERE TABLE_NAME='RPartDet' AND CONSTRAINT_NAME='FK_RPartDet_RPart')
Begin
alter table RPartDet drop constraint FK_RPartDet_RPart
end
go
IF EXISTS(SELECT * FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS WHERE TABLE_NAME='RPArt' AND CONSTRAINT_NAME='I_RPART')
Begin
alter table RPArt Drop Constraint I_RPART
end
GO
IF EXISTS (SELECT * FROM sys.indexes WHERE name='I_RPart_DocNo_ID' AND object_id = OBJECT_ID(N'RPart'))
Begin
drop index RPart.I_RPart_DocNo_ID
end
GO


alter table RPart alter column DocNo varchar(20) Not Null
GO


IF not EXISTS(SELECT * FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS WHERE TABLE_NAME='RPart' AND CONSTRAINT_NAME='I_RPart')
Begin
Alter Table [dbo].[RPArt] add constraint I_RPart Primary Key (RNO, ID, DocNo)
end
GO


alter table Security alter column DocNo varchar(20) Not Null
GO
alter table RPartDet alter column DocNo varchar(20) Not Null
GO


IF EXISTS(SELECT * FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS WHERE TABLE_NAME='Security' AND CONSTRAINT_NAME='I_Security')
Begin
Alter table Security drop constraint I_Security
end
GO
IF not EXISTS(SELECT * FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS WHERE TABLE_NAME='Security' AND CONSTRAINT_NAME='I_Security')
Begin
Alter Table [dbo].[Security] add constraint I_Security Primary Key (RNO, ID, DocNo, SID)
end
GO

IF EXISTS(SELECT * FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS WHERE TABLE_NAME='RPartDet' AND CONSTRAINT_NAME='I_RPARTDET')
Begin
Alter table RPartDet drop constraint I_RPARTDET
end
GO
Alter Table [dbo].[RPArtDet] add constraint I_RPARTDET Primary Key (RNO, ID, DocNo, TOR, NOfYears)
GO

IF not EXISTS(SELECT * FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS WHERE TABLE_NAME='RPartDet' AND CONSTRAINT_NAME='FK_RPartDet_RPart')
Begin
ALTER TABLE [dbo].[RPartDet]  WITH NOCHECK ADD  CONSTRAINT [FK_RPartDet_RPart] FOREIGN KEY(RNO, ID, DocNo)
REFERENCES [dbo].[RPart] (RNO, ID, DocNo) ON UPDATE CASCADE ON DELETE CASCADE
end
GO
IF not EXISTS(SELECT * FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS WHERE TABLE_NAME='Security' AND CONSTRAINT_NAME='FK_Security_RPart')
Begin
ALTER TABLE [dbo].[Security]  WITH NOCHECK ADD  CONSTRAINT [FK_Security_RPart] FOREIGN KEY(RNO, ID, DocNo)
REFERENCES [dbo].[RPart] (RNO, ID, DocNo) ON UPDATE CASCADE ON DELETE CASCADE

end
GO

IF not EXISTS (SELECT * FROM sys.indexes WHERE name='I_RPart_DocNo_ID' AND object_id = OBJECT_ID(N'RPart'))
Begin
Create Index I_RPart_DocNo_ID on RPart(DocNo, ID)
end
go




 insert into PatchVersioning
select '148 Update Script - 16 February 2022',GETDATE()
go


Declare @PrevScript varchar(100)
Declare @CurrScript varchar(100)

Select @PrevScript=''
Select @CurrSCript='148 Update Script - 16 February 2022'


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