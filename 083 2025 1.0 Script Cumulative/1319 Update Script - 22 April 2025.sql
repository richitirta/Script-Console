IF  NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'OGIS_LOG_DOWNLOAD') AND type in (N'U'))
BEGIN
SET ANSI_NULLS ON
 
SET QUOTED_IDENTIFIER ON
 
CREATE TABLE [dbo].[OGIS_LOG_DOWNLOAD](
	[LOGID] [int] IDENTITY(1,1) NOT NULL,
	[OGIS_TYPE] [varchar](10) NOT NULL,
	[PDATE] [smalldatetime] NOT NULL,
	[FTYPE] [varchar](20) NOT NULL,
	[UserID] [varchar](50) NULL,
	[Date] [smalldatetime] NULL,
	[Time] [varchar](8) NULL,
 CONSTRAINT [I_OGIS_LOG_DOWNLOAD] PRIMARY KEY CLUSTERED 
(
	[LOGID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
 

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Initiating User' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'OGIS_LOG_DOWNLOAD', @level2type=N'COLUMN',@level2name=N'UserID'
 
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Date Time' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'OGIS_LOG_DOWNLOAD', @level2type=N'COLUMN',@level2name=N'Date'
 
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Time' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'OGIS_LOG_DOWNLOAD', @level2type=N'COLUMN',@level2name=N'Time'
 
 end
 go

  insert into PatchVersioning
select '1319 Update Script - 22 April 2025',GETDATE()
go	
  

Declare @PrevScript varchar(100)
Declare @CurrScript varchar(100)

Select @PrevScript=''
Select @CurrSCript='1319 Update Script - 22 April 2025'


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


