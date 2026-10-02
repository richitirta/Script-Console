IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'RECEIVEDBYID_NO' AND Object_ID = Object_ID(N'COLLATERAL'))
BEGIN

SET QUOTED_IDENTIFIER ON
SET ARITHABORT ON
SET NUMERIC_ROUNDABORT OFF
SET CONCAT_NULL_YIELDS_NULL ON
SET ANSI_NULLS ON
SET ANSI_PADDING ON
SET ANSI_WARNINGS ON

ALTER TABLE dbo.COLLATERAL ADD
	RECEIVEDBYID_NO varchar(30) NULL
DECLARE @v sql_variant 
SET @v = N'Received By ID NO (KTP NO)'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'COLLATERAL', N'COLUMN', N'RECEIVEDBYID_NO'
end
go


IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'RELEASEDBYID_NO' AND Object_ID = Object_ID(N'COLLATERAL'))
BEGIN

SET QUOTED_IDENTIFIER ON
SET ARITHABORT ON
SET NUMERIC_ROUNDABORT OFF
SET CONCAT_NULL_YIELDS_NULL ON
SET ANSI_NULLS ON
SET ANSI_PADDING ON
SET ANSI_WARNINGS ON

ALTER TABLE dbo.COLLATERAL ADD
	RELEASEDBYID_NO varchar(30) NULL
DECLARE @v sql_variant 
SET @v = N'Released By ID NO (KTP NO)'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'COLLATERAL', N'COLUMN', N'RELEASEDBYID_NO'
end
GO



IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'RECEIVEDBYID_NO' AND Object_ID = Object_ID(N'ACCCOLLATERAL'))
BEGIN

SET QUOTED_IDENTIFIER ON
SET ARITHABORT ON
SET NUMERIC_ROUNDABORT OFF
SET CONCAT_NULL_YIELDS_NULL ON
SET ANSI_NULLS ON
SET ANSI_PADDING ON
SET ANSI_WARNINGS ON

ALTER TABLE dbo.ACCCOLLATERAL ADD
	RECEIVEDBYID_NO varchar(30) NULL
DECLARE @v sql_variant 
SET @v = N'Received By ID NO (KTP NO)'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'ACCCOLLATERAL', N'COLUMN', N'RECEIVEDBYID_NO'
end
go

IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'RELEASEDBYID_NO' AND Object_ID = Object_ID(N'ACCCOLLATERAL'))
BEGIN

SET QUOTED_IDENTIFIER ON
SET ARITHABORT ON
SET NUMERIC_ROUNDABORT OFF
SET CONCAT_NULL_YIELDS_NULL ON
SET ANSI_NULLS ON
SET ANSI_PADDING ON
SET ANSI_WARNINGS ON

ALTER TABLE dbo.ACCCOLLATERAL ADD
	RELEASEDBYID_NO varchar(30) NULL
DECLARE @v sql_variant 
SET @v = N'Released By ID NO (KTP NO)'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'ACCCOLLATERAL', N'COLUMN', N'RELEASEDBYID_NO'
end
GO



IF  NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'COLLATERALPIC') AND type in (N'U'))
BEGIN
SET ANSI_NULLS ON


SET QUOTED_IDENTIFIER ON

CREATE TABLE [dbo].[COLLATERALPIC](
	[CollateralNo] [varchar](20) NOT NULL,
	[ImageID] [int] NOT NULL,
	[FileType] [varchar](10) NULL,
	[Title] [varchar](255) NULL,
	[Remark] [varchar](max) NULL,
	[Last_Opr] [varchar](50) NULL,
	[Last_Update] [smalldatetime] NULL,
	[JustMeF] [bit] NULL,
 CONSTRAINT [I_COLLATERALPIC] PRIMARY KEY CLUSTERED 
(
	[CollateralNo] ASC,
	[ImageID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON)
)


ALTER TABLE [dbo].[COLLATERALPIC] SET (LOCK_ESCALATION = DISABLE)


EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Refer to Collateral Table' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'COLLATERALPIC', @level2type=N'COLUMN',@level2name=N'CollateralNo'


EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Image ID (see SysImage)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'COLLATERALPIC', @level2type=N'COLUMN',@level2name=N'ImageID'


EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Document File Type' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'COLLATERALPIC', @level2type=N'COLUMN',@level2name=N'FileType'


EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Image Title' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'COLLATERALPIC', @level2type=N'COLUMN',@level2name=N'Title'


EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Remark' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'COLLATERALPIC', @level2type=N'COLUMN',@level2name=N'Remark'


EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Just me Flag (0 : Everyone can open, 1 : Only User Owner)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'COLLATERALPIC', @level2type=N'COLUMN',@level2name=N'JustMeF'

end
go



insert into PatchVersioning
select '921 Update Script - 8 January 2024',GETDATE()
go


Declare @PrevScript varchar(100)
Declare @CurrScript varchar(100)

Select @PrevScript=''
Select @CurrSCript='921 Update Script - 8 January 2024'


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