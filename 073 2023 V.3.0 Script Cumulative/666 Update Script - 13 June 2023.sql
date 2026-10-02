IF  NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'RQPrintLog') AND type in (N'U'))
BEGIN

SET ANSI_NULLS ON

SET QUOTED_IDENTIFIER ON

SET ANSI_PADDING ON

CREATE TABLE [dbo].[RQPrintLog](
	[Request] [varchar](20) NOT NULL,
	[DocNo] [varchar](20) NOT NULL,
	[Description] [varchar](50) NOT NULL,
	[UserID] [varchar](50) NULL,
	[Date] [smalldatetime] NULL,
	[Time] [varchar](8) NULL,
	[LogID] [int] IDENTITY(1,1) NOT NULL,
	[ImageID] [int] NOT NULL,
	[FileType] [varchar](10) NULL,
 CONSTRAINT [I_RQPrintLog] PRIMARY KEY CLUSTERED 
(
	[LogID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]


SET ANSI_PADDING OFF


EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Acceptance No. (see Acceptance)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RQPrintLog', @level2type=N'COLUMN',@level2name=N'Request'


EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Document Number' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RQPrintLog', @level2type=N'COLUMN',@level2name=N'DocNo'


EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Document Description' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RQPrintLog', @level2type=N'COLUMN',@level2name=N'Description'


EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Initiating User' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RQPrintLog', @level2type=N'COLUMN',@level2name=N'UserID'


EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Date Time' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RQPrintLog', @level2type=N'COLUMN',@level2name=N'Date'


EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Time' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RQPrintLog', @level2type=N'COLUMN',@level2name=N'Time'


EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Image ID (see SysImage)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RQPrintLog', @level2type=N'COLUMN',@level2name=N'ImageID'


EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Document File Type' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RQPrintLog', @level2type=N'COLUMN',@level2name=N'FileType'



Create Index I_RQPrintLog_Request_DocNo_Description on RQPrintLog(Request, DocNo, Description)
end
go


 insert into PatchVersioning	
select '666 Update Script - 13 June 2023',GETDATE()
go





Declare @PrevScript varchar(100)
Declare @CurrScript varchar(100)

Select @PrevScript=''
Select @CurrSCript='666 Update Script - 13 June 2023'


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