/****** Object:  Table [dbo].[CollectionPic]    Script Date: 3/24/2026 11:50:26 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO
IF  NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[CollectionPic]') AND type in (N'U'))

BEGIN
CREATE TABLE [dbo].[CollectionPic](
	[CollNo] [varchar](20) NOT NULL,
	[ImageID] [int] NOT NULL,
	[FileType] [varchar](10) NULL,
	[Title] [varchar](255) NULL,
	[Remark] [varchar](max) NULL,
	[Last_Opr] [varchar](50) NULL,
	[Last_Update] [smalldatetime] NULL,
	[JustMeF] [bit] NULL,
	[Last_Time] [varchar](5) NULL,
	[UserID] [varchar](50) NULL,
	[CDate] [smalldatetime] NULL,
	[CTime] [varchar](5) NULL,
 CONSTRAINT [I_CollectionPic] PRIMARY KEY NONCLUSTERED 
(
	[CollNo] ASC,
	[ImageID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
END
GO

ALTER TABLE [dbo].[CollectionPic]  WITH NOCHECK ADD  CONSTRAINT [FK_CollectionPic_CollectionH] FOREIGN KEY([CollNo])
REFERENCES [dbo].[CollectionH] ([CollNo])
ON UPDATE CASCADE
ON DELETE CASCADE
GO

ALTER TABLE [dbo].[CollectionPic] CHECK CONSTRAINT [FK_CollectionPic_CollectionH]
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Collection No.' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'CollectionPic', @level2type=N'COLUMN',@level2name=N'CollNo'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Image ID (see SysImage)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'CollectionPic', @level2type=N'COLUMN',@level2name=N'ImageID'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Document File Type' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'CollectionPic', @level2type=N'COLUMN',@level2name=N'FileType'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Image Title' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'CollectionPic', @level2type=N'COLUMN',@level2name=N'Title'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Remark' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'CollectionPic', @level2type=N'COLUMN',@level2name=N'Remark'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Just me Flag (0 : Everyone can open, 1 : Only User Owner)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'CollectionPic', @level2type=N'COLUMN',@level2name=N'JustMeF'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Last Update Time' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'CollectionPic', @level2type=N'COLUMN',@level2name=N'Last_Time'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Creation UserID' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'CollectionPic', @level2type=N'COLUMN',@level2name=N'UserID'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Created Date' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'CollectionPic', @level2type=N'COLUMN',@level2name=N'CDate'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Created Time' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'CollectionPic', @level2type=N'COLUMN',@level2name=N'CTime'
GO



insert into PatchVersioning
select '1566 Update Script - 24 March 2026.sql',GETDATE()
go	
  
Declare @PrevScript varchar(100)
Declare @CurrScript varchar(100)

Select @PrevScript=''
Select @CurrSCript='1566 Update Script - 24 March 2026.sql'


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

