

IF  NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'CLSUBPIC') AND type in (N'U'))
BEGIN
CREATE TABLE dbo.CLSUBPIC
	(
	CNO int NOT NULL,
	ID varchar(10) NOT NULL,
	Currency varchar(5) NOT NULL,
	RefNo varchar(20) NULL,
	ImageID int NOT NULL,
	FileType varchar(10) NULL,
	Title varchar(255) NULL,
	Remark varchar(MAX) NULL,
	Last_Opr varchar(50) NULL,
	Last_Update smalldatetime NULL,
	Last_Time varchar(8) NULL
	)  ON [PRIMARY]
	 TEXTIMAGE_ON [PRIMARY]

DECLARE @v sql_variant 
SET @v = cast(N'Claim No (see Claim)' as varchar(20))
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'CLSUBPIC', N'COLUMN', N'CNO'

DECLARE @x sql_variant 
SET @x = cast(N'Subrogor ( see Profile)' as varchar(23))
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'CLSUBPIC', N'COLUMN', N'ID'

DECLARE @y sql_variant 
SET @y = cast(N'Currency' as varchar(8))
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'CLSUBPIC', N'COLUMN', N'Currency'

DECLARE @z sql_variant 
SET @z = N'Reference No.'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'CLSUBPIC', N'COLUMN', N'RefNo'

DECLARE @a sql_variant 
SET @a = N'Image ID (see SysImage)'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'CLSUBPIC', N'COLUMN', N'ImageID'

DECLARE @b sql_variant 
SET @b = N'Document File Type'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'CLSUBPIC', N'COLUMN', N'FileType'

DECLARE @c sql_variant 
SET @c = N'Image Title'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'CLSUBPIC', N'COLUMN', N'Title'

DECLARE @d sql_variant 
SET @d = N'Remark'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'CLSUBPIC', N'COLUMN', N'Remark'
end
go

IF NOT EXISTS (SELECT *  FROM sys.indexes WHERE name='I_CLSUBPIC' AND object_id = OBJECT_ID('CLSUBPIC'))
BEGIN
Create Unique Index I_CLSUBPIC on CLSUBPIC(CNO, ID, Currency, RefNo, ImageID)
end
GO


IF  NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'CLCOSTPIC') AND type in (N'U'))
BEGIN
CREATE TABLE dbo.CLCOSTPIC
	(
	CNO int NOT NULL,
	ID varchar(10) NOT NULL,
	Currency varchar(5) NOT NULL,
	RefNo varchar(20) NULL,
	ImageID int NOT NULL,
	FileType varchar(10) NULL,
	Title varchar(255) NULL,
	Remark varchar(MAX) NULL,
	Last_Opr varchar(50) NULL,
	Last_Update smalldatetime NULL,
	Last_Time varchar(8) NULL
	)  ON [PRIMARY]
	 TEXTIMAGE_ON [PRIMARY]

DECLARE @v sql_variant 
SET @v = cast(N'Claim No (see Claim)' as varchar(20))
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'CLCOSTPIC', N'COLUMN', N'CNO'

DECLARE @x sql_variant 
SET @x = cast(N'Subrogor ( see Profile)' as varchar(23))
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'CLCOSTPIC', N'COLUMN', N'ID'

DECLARE @y sql_variant 
SET @y = cast(N'Currency' as varchar(8))
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'CLCOSTPIC', N'COLUMN', N'Currency'

DECLARE @z sql_variant 
SET @z = N'Reference No.'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'CLCOSTPIC', N'COLUMN', N'RefNo'

DECLARE @a sql_variant 
SET @a = N'Image ID (see SysImage)'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'CLCOSTPIC', N'COLUMN', N'ImageID'

DECLARE @b sql_variant 
SET @b = N'Document File Type'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'CLCOSTPIC', N'COLUMN', N'FileType'

DECLARE @c sql_variant 
SET @c = N'Image Title'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'CLCOSTPIC', N'COLUMN', N'Title'

DECLARE @d sql_variant 
SET @d = N'Remark'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'CLCOSTPIC', N'COLUMN', N'Remark'

end
go

IF NOT EXISTS (SELECT *  FROM sys.indexes WHERE name='I_CLCOSTPIC' AND object_id = OBJECT_ID('CLCOSTPIC'))
BEGIN
Create Unique Index I_CLCOSTPIC on CLCOSTPIC(CNO, ID, Currency, RefNo, ImageID)
end
GO


IF EXISTS ( SELECT * FROM   sysobjects WHERE  id = object_id(N'Drop_Claim_Link') and OBJECTPROPERTY(id, N'IsProcedure') = 1 )
BEGIN
DROP Procedure Drop_Claim_Link
end
GO
Create Procedure Drop_Claim_Link(@P_CNO as Int)  
AS   
  
Delete From CLAASS Where CNO=@P_CNO  
Delete From CLFD Where CNO=@P_CNO  
Delete From CLINFO Where CNO=@P_CNO  
Delete From CLFACDED Where CNO=@P_CNO  
Delete From CINFO Where CNO=@P_CNO  
Delete From CLSALITEM Where CNO=@P_CNO  
Delete From CLDED Where CNO=@P_CNO  
Delete From LCALC Where CNO=@P_CNO  
Delete From CLLOSS Where CNO=@P_CNO  
Delete From CLSAL Where CNO=@P_CNO  
Delete From CLNotify Where CNO=@P_CNO  
Delete From CLPIC Where CNO=@P_CNO  
Delete From CLCOST Where CNO=@P_CNO  
Delete From CLPrintLog Where CNO=@P_CNO  
Delete From CDOCSTAT Where CNO=@P_CNO  
Delete From CARRHEADER Where CNO=@P_CNO  
Delete From CLSub Where CNO=@P_CNO  
Delete From CCALC Where CNO=@P_CNO  
Delete From CLSurvey Where CNO=@P_CNO  
Delete From CDOCLIST Where CNO=@P_CNO  
Delete From CDOCLISTPIC Where CNO=@P_CNO  
Delete From CArrDetail Where CNO=@P_CNO  
Delete From CLNotes Where CNO=@P_CNO
Delete From CLINFOSUPL Where CNO=@P_CNO
Delete From CLSUBPIC Where CNO=@P_CNO
Delete From CLCOSTPIC Where CNO=@P_CNO

go


 insert into PatchVersioning
select '343 Update Script - 11 July 2022',GETDATE()
go


Declare @PrevScript varchar(100)
Declare @CurrScript varchar(100)

Select @PrevScript=''
Select @CurrSCript='343 Update Script - 11 July 2022'


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




