IF  NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'ARPRINTLOG') AND type in (N'U'))
BEGIN
SET ANSI_NULLS ON
 
SET QUOTED_IDENTIFIER ON
 

CREATE TABLE [dbo].[ARPRINTLOG](
	[Request] [varchar](20) NULL,
	[DocNo] [varchar](50) NULL,
	[ARNO] [varchar](50) NULL,
	[ARPrintNo] [int] NULL,
	[UserID] [varchar](50) NULL,
	[Date] [smalldatetime] NULL,
	[Time] [varchar](8) NULL,
	[LogID] [int] IDENTITY(1,1) NOT NULL,
	[ImageID] [int] NOT NULL,
	[FileType] [varchar](10) NULL,
	[Description] [varchar](50) NOT NULL,
 CONSTRAINT [I_ARPRINTLOG] PRIMARY KEY CLUSTERED 
(
	[LogID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = OFF) ON [PRIMARY],
 CONSTRAINT [I_ARPRINTLOG_Request_DocNo] UNIQUE NONCLUSTERED 
(
	[Request] ASC,
	[DocNo] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = OFF) ON [PRIMARY]
) ON [PRIMARY]
 

ALTER TABLE [dbo].[ARPRINTLOG] SET (LOCK_ESCALATION = DISABLE)
 


EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Receipt Request ' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'ARPRINTLOG', @level2type=N'COLUMN',@level2name=N'Request'
 
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Reference Document No.' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'ARPRINTLOG', @level2type=N'COLUMN',@level2name=N'DocNo'
 
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Official Receipt No. (No. Kwitansi)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'ARPRINTLOG', @level2type=N'COLUMN',@level2name=N'ARNO'
 
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Print Sequences No.' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'ARPRINTLOG', @level2type=N'COLUMN',@level2name=N'ARPrintNo'
 
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Initiating User' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'ARPRINTLOG', @level2type=N'COLUMN',@level2name=N'UserID'
 
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Date Time' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'ARPRINTLOG', @level2type=N'COLUMN',@level2name=N'Date'
 

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Time' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'ARPRINTLOG', @level2type=N'COLUMN',@level2name=N'Time'
 

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Image ID (see SysImage)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'ARPRINTLOG', @level2type=N'COLUMN',@level2name=N'ImageID'
 

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Document File Type' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'ARPRINTLOG', @level2type=N'COLUMN',@level2name=N'FileType'
END
GO



  insert into PatchVersioning
select '1293 Update Script - Patch 2025 (8)',GETDATE()
go	
  

Declare @PrevScript varchar(100)
Declare @CurrScript varchar(100)

Select @PrevScript=''
Select @CurrSCript='1293 Update Script - Patch 2025 (8)'


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