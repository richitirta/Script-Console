SET QUOTED_IDENTIFIER ON
SET ARITHABORT ON
SET NUMERIC_ROUNDABORT OFF
SET CONCAT_NULL_YIELDS_NULL ON
SET ANSI_NULLS ON
SET ANSI_PADDING ON
SET ANSI_WARNINGS ON

IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'Last_Time' AND Object_ID = Object_ID(N'dbo.VoucherPic'))
BEGIN
ALTER TABLE dbo.VoucherPic ADD Last_Time varchar(5) NULL
DECLARE @v sql_variant 
SET @v = N'Last Update Time'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'VoucherPic', N'COLUMN', N'Last_Time'
END
GO

IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'UserID' AND Object_ID = Object_ID(N'dbo.VoucherPic'))
BEGIN
ALTER TABLE dbo.VoucherPic ADD UserID varchar(50) NULL
DECLARE @v sql_variant 
SET @v = N'Creation UserID'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'VoucherPic', N'COLUMN', N'UserID'
END
GO

IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'CDate' AND Object_ID = Object_ID(N'dbo.VoucherPic'))
BEGIN
ALTER TABLE dbo.VoucherPic ADD CDate smalldatetime NULL
DECLARE @v sql_variant 
SET @v = N'Created Date'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'VoucherPic', N'COLUMN', N'CDate'
END
GO

IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'CTime' AND Object_ID = Object_ID(N'dbo.VoucherPic'))
BEGIN
ALTER TABLE dbo.VoucherPic ADD CTime varchar(5) NULL
DECLARE @v sql_variant 
SET @v = N'Created Time'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'VoucherPic', N'COLUMN', N'CTime'
END
GO


SET QUOTED_IDENTIFIER ON
SET ARITHABORT ON
SET NUMERIC_ROUNDABORT OFF
SET CONCAT_NULL_YIELDS_NULL ON
SET ANSI_NULLS ON
SET ANSI_PADDING ON
SET ANSI_WARNINGS ON

IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'Last_Time' AND Object_ID = Object_ID(N'dbo.RequestPIC'))
BEGIN
ALTER TABLE dbo.RequestPIC ADD Last_Time varchar(5) NULL
DECLARE @v sql_variant 
SET @v = N'Last Update Time'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'RequestPIC', N'COLUMN', N'Last_Time'
END
GO

IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'UserID' AND Object_ID = Object_ID(N'dbo.RequestPIC'))
BEGIN
ALTER TABLE dbo.RequestPIC ADD UserID varchar(50) NULL
DECLARE @v sql_variant 
SET @v = N'Creation UserID'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'RequestPIC', N'COLUMN', N'UserID'

END
GO

IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'CDate' AND Object_ID = Object_ID(N'dbo.RequestPIC'))
BEGIN
ALTER TABLE dbo.RequestPIC ADD CDate smalldatetime NULL
DECLARE @v sql_variant 
SET @v = N'Created Date'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'RequestPIC', N'COLUMN', N'CDate'
END
GO

IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'CTime' AND Object_ID = Object_ID(N'dbo.RequestPIC'))
BEGIN
ALTER TABLE dbo.RequestPIC ADD CTime varchar(5) NULL
DECLARE @v sql_variant 
SET @v = N'Created Time'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'RequestPIC', N'COLUMN', N'CTime'
END
GO


SET QUOTED_IDENTIFIER ON
SET ARITHABORT ON
SET NUMERIC_ROUNDABORT OFF
SET CONCAT_NULL_YIELDS_NULL ON
SET ANSI_NULLS ON
SET ANSI_PADDING ON
SET ANSI_WARNINGS ON

IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'Last_Time' AND Object_ID = Object_ID(N'dbo.ACCPIC'))
BEGIN
ALTER TABLE dbo.ACCPIC ADD Last_Time varchar(5) NULL
DECLARE @v sql_variant 
SET @v = N'Last Update Time'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'ACCPIC', N'COLUMN', N'Last_Time'
END
GO

IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'UserID' AND Object_ID = Object_ID(N'dbo.ACCPIC'))
BEGIN
ALTER TABLE dbo.ACCPIC ADD UserID varchar(50) NULL
DECLARE @v sql_variant 
SET @v = N'Creation UserID'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'ACCPIC', N'COLUMN', N'UserID'
END
GO

IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'CDate' AND Object_ID = Object_ID(N'dbo.ACCPIC'))
BEGIN
ALTER TABLE dbo.ACCPIC ADD CDate smalldatetime NULL
DECLARE @v sql_variant 
SET @v = N'Created Date'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'ACCPIC', N'COLUMN', N'CDate'
END
GO

IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'CTime' AND Object_ID = Object_ID(N'dbo.ACCPIC'))
BEGIN
ALTER TABLE dbo.ACCPIC ADD CTime varchar(5) NULL
DECLARE @v sql_variant 
SET @v = N'Created Time'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'ACCPIC', N'COLUMN', N'CTime'
END
GO


SET QUOTED_IDENTIFIER ON
SET ARITHABORT ON
SET NUMERIC_ROUNDABORT OFF
SET CONCAT_NULL_YIELDS_NULL ON
SET ANSI_NULLS ON
SET ANSI_PADDING ON
SET ANSI_WARNINGS ON

IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'Last_Time' AND Object_ID = Object_ID(N'dbo.CLPIC'))
BEGIN
ALTER TABLE dbo.CLPIC ADD Last_Time varchar(5) NULL
DECLARE @v sql_variant 
SET @v = N'Last Update Time'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'CLPIC', N'COLUMN', N'Last_Time'
END
GO

IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'UserID' AND Object_ID = Object_ID(N'dbo.CLPIC'))
BEGIN
ALTER TABLE dbo.CLPIC ADD UserID varchar(50) NULL
DECLARE @v sql_variant 
SET @v = N'Creation UserID'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'CLPIC', N'COLUMN', N'UserID'
END
GO

IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'CDate' AND Object_ID = Object_ID(N'dbo.CLPIC'))
BEGIN
ALTER TABLE dbo.CLPIC ADD CDate smalldatetime NULL
DECLARE @v sql_variant 
SET @v = N'Created Date'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'CLPIC', N'COLUMN', N'CDate'
END
GO

IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'CTime' AND Object_ID = Object_ID(N'dbo.CLPIC'))
BEGIN
ALTER TABLE dbo.CLPIC ADD CTime varchar(5) NULL  
DECLARE @v sql_variant 
SET @v = N'Created Time'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'CLPIC', N'COLUMN', N'CTime'
END
GO

SET QUOTED_IDENTIFIER ON
SET ARITHABORT ON
SET NUMERIC_ROUNDABORT OFF
SET CONCAT_NULL_YIELDS_NULL ON
SET ANSI_NULLS ON
SET ANSI_PADDING ON
SET ANSI_WARNINGS ON

IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'JustMeF' AND Object_ID = Object_ID(N'dbo.SAccPic'))
BEGIN
ALTER TABLE dbo.SAccPic ADD JustMeF bit NULL
DECLARE @v sql_variant 
SET @v = N'Just me Flag (0 : Everyone can open, 1 : Only User Owner)'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'SAccPic', N'COLUMN', N'JustMeF'
END
GO

IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'Last_Time' AND Object_ID = Object_ID(N'dbo.SAccPic'))
BEGIN
ALTER TABLE dbo.SAccPic ADD Last_Time varchar(5) NULL
DECLARE @v sql_variant 
SET @v = N'Last Update Time'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'SAccPic', N'COLUMN', N'Last_Time'
END
GO

IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'UserID' AND Object_ID = Object_ID(N'dbo.SAccPic'))
BEGIN
ALTER TABLE dbo.SAccPic ADD UserID varchar(50) NULL
DECLARE @v sql_variant 
SET @v = N'Creation UserID'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'SAccPic', N'COLUMN', N'UserID'
END
GO

IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'CDate' AND Object_ID = Object_ID(N'dbo.SAccPic'))
BEGIN
ALTER TABLE dbo.SAccPic ADD CDate smalldatetime NULL   
DECLARE @v sql_variant 
SET @v = N'Created Date'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'SAccPic', N'COLUMN', N'CDate'
END
GO

IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'CTime' AND Object_ID = Object_ID(N'dbo.SAccPic'))
BEGIN
ALTER TABLE dbo.SAccPic ADD CTime varchar(5) NULL   
DECLARE @v sql_variant 
SET @v = N'Created Time'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'SAccPic', N'COLUMN', N'CTime'
END
GO

/****** Object:  Table [dbo].[FACPIC]    Script Date: 8/11/2025 3:45:10 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

IF  NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'FACPIC') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[FACPIC](
	[ANO] [int] NOT NULL,
	[FID] [varchar](20) NOT NULL,
	[ImageID] [int] NOT NULL,
	[FileType] [varchar](10) NULL,
	[Title] [varchar](255) NULL,
	[Remark] [varchar](max) NULL,
	[Last_Opr] [varchar](50) NULL,
	[Last_Update] [smalldatetime] NULL,
	[JustMeF] [bit] NULL,
	[Last_Time] [varchar](5) NOT NULL,
	[UserID] [varchar](50) NULL,
	[CDate] [smalldatetime] NULL,
	[CTime] [varchar](5) NULL,
 CONSTRAINT [I_FACPIC] UNIQUE NONCLUSTERED 
(
	[ANO] ASC,
	[FID] ASC,
	[ImageID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
ALTER TABLE [dbo].[FACPIC]  WITH NOCHECK ADD  CONSTRAINT [FK_FACPIC_RARRDET] FOREIGN KEY([ANO], [FID])
REFERENCES [dbo].[RARRDET] ([ANO], [FID])
ON UPDATE CASCADE
ON DELETE CASCADE
ALTER TABLE [dbo].[FACPIC] CHECK CONSTRAINT [FK_FACPIC_RARRDET]
END
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Acceptance Original ANO' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'FACPIC', @level2type=N'COLUMN',@level2name=N'ANO'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Facultative ID' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'FACPIC', @level2type=N'COLUMN',@level2name=N'FID'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Image ID (see SysImage)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'FACPIC', @level2type=N'COLUMN',@level2name=N'ImageID'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Document File Type' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'FACPIC', @level2type=N'COLUMN',@level2name=N'FileType'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Image Title' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'FACPIC', @level2type=N'COLUMN',@level2name=N'Title'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Remark' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'FACPIC', @level2type=N'COLUMN',@level2name=N'Remark'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Just me Flag (0 : Everyone can open, 1 : Only User Owner)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'FACPIC', @level2type=N'COLUMN',@level2name=N'JustMeF'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Last Update Time' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'FACPIC', @level2type=N'COLUMN',@level2name=N'Last_Time'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Creation UserID' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'FACPIC', @level2type=N'COLUMN',@level2name=N'UserID'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Created Date' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'FACPIC', @level2type=N'COLUMN',@level2name=N'CDate'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Created Time' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'FACPIC', @level2type=N'COLUMN',@level2name=N'CTime'
GO


insert into PatchVersioning
select '1396 Update Script - 30 July 2025 (1)',GETDATE()
go	
  
Declare @PrevScript varchar(100)
Declare @CurrScript varchar(100)

Select @PrevScript=''
Select @CurrSCript='1396 Update Script - 30 July 2025 (1)'


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

GO
