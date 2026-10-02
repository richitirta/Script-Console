
IF  NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'SysLogDownLoadImage') AND type in (N'U'))
BEGIN

/****** Object:  Table [dbo].[SysLogDownLoadImage]    Script Date: 1/24/2024 1:49:14 PM ******/
SET ANSI_NULLS ON

SET QUOTED_IDENTIFIER ON


CREATE TABLE [dbo].[SysLogDownLoadImage](
	[IMAGEID] [int] NOT NULL,
	[DOCTYPE] [varchar](50) NULL,
	[DOCNO] [varchar](50) NULL,
	[PDATE] [smalldatetime] NULL,
	[PTIME] [varchar](8) NULL,
	[USERID] [varchar](50) NULL,
	[ID] [int] IDENTITY(1,1) NOT NULL
) ON [PRIMARY]

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'IMAGE ID ' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'SysLogDownLoadImage', @level2type=N'COLUMN',@level2name=N'ImageID'

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'DOCUMENT TYPE TO DOWNLOAD (''REQUEST'', ''PVOUCHER'')' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'SysLogDownLoadImage', @level2type=N'COLUMN',@level2name=N'DOCTYPE'


EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Document No. (Request No/Voucher No)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'SysLogDownLoadImage', @level2type=N'COLUMN',@level2name=N'DOCNO'


EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Processing Date' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'SysLogDownLoadImage', @level2type=N'COLUMN',@level2name=N'PDATE'


EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Processing Time' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'SysLogDownLoadImage', @level2type=N'COLUMN',@level2name=N'PTIME'


EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Processing User ID' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'SysLogDownLoadImage', @level2type=N'COLUMN',@level2name=N'USERID'

Create Unique Index I_SysLogDownLoadImage on SysLogDownLoadImage(ID)

END
go

insert into PatchVersioning
select '932 Update Script - 24 January 2024',GETDATE()
go


Declare @PrevScript varchar(100)
Declare @CurrScript varchar(100)

Select @PrevScript=''
Select @CurrSCript='932 Update Script - 24 January 2024'


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
