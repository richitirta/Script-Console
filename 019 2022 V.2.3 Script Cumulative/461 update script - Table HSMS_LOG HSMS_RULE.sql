
select * into temp_HSMSRULE from [HSMS_Rule]
GO

select * into temp_HSMSLOG from [HSMS_Log]
GO

/****** Object:  Table [dbo].[HSMS_Rule]    Script Date: 11/15/2022 10:10:03 PM ******/
DROP TABLE [dbo].[HSMS_Rule]
GO

/****** Object:  Table [dbo].[HSMS_Log]    Script Date: 11/15/2022 10:10:03 PM ******/
DROP TABLE [dbo].[HSMS_Log]
GO

/****** Object:  Table [dbo].[HSMS_Log]    Script Date: 11/15/2022 10:10:03 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

SET ANSI_PADDING ON
GO

CREATE TABLE [dbo].[HSMS_Log](
	[ID] [int] NOT NULL,
	[TrDate] [smalldatetime] NULL,
	[SMSRule] [varchar](10) NULL,
	[Param1] [varchar](50) NULL,
	[Param2] [varchar](50) NULL,
	[Param3] [varchar](50) NULL,
	[Param4] [varchar](50) NULL,
	[Param5] [varchar](50) NULL,
	[MobileNo] [varchar](20) NULL,
	[Message] [varchar](160) NULL,
	[Status] [varchar](10) NULL,
	[TrxID] [varchar](50) NULL,
	[TrxErrMsg] [varchar](255) NULL,
 CONSTRAINT [I_HSMS_Log] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO

SET ANSI_PADDING OFF
GO

/****** Object:  Table [dbo].[HSMS_Rule]    Script Date: 11/15/2022 10:10:03 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

SET ANSI_PADDING ON
GO

CREATE TABLE [dbo].[HSMS_Rule](
	[SMSRule] [varchar](10) NOT NULL,
	[Description] [varchar](50) NULL,
	[GatewayURL] [varchar](255) NULL,
	[MobileNoQS] [varchar](50) NULL,
	[MessageQS] [varchar](50) NULL,
	[Message] [varchar](512) NULL,
	[SQL] [varchar](2000) NULL,
	[Param01] [varchar](50) NULL,
	[Param02] [varchar](50) NULL,
	[Param03] [varchar](50) NULL,
	[Param04] [varchar](50) NULL,
	[Param05] [varchar](50) NULL,
	[Param06] [varchar](255) NULL,
	[Param07] [varchar](50) NULL,
	[Param08] [varchar](50) NULL,
	[Param09] [varchar](50) NULL,
	[Param10] [varchar](50) NULL,
	[Last_Opr] [varchar](10) NULL,
	[Last_Update] [smalldatetime] NULL,
	[LastEmail] [smalldatetime] NULL,
	[CID] [varchar](10) NULL,
	[CPwd] [varchar](20) NULL,
 CONSTRAINT [I_HSMS_Rule] PRIMARY KEY CLUSTERED 
(
	[SMSRule] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO

SET ANSI_PADDING OFF
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Transaction ID' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'HSMS_Log', @level2type=N'COLUMN',@level2name=N'ID'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Refer to HSMS_Rule' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'HSMS_Log', @level2type=N'COLUMN',@level2name=N'SMSRule'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'ClaimNo' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'HSMS_Log', @level2type=N'COLUMN',@level2name=N'Param1'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'BatchNo' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'HSMS_Log', @level2type=N'COLUMN',@level2name=N'Param2'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Reserved' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'HSMS_Log', @level2type=N'COLUMN',@level2name=N'Param3'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Reserved' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'HSMS_Log', @level2type=N'COLUMN',@level2name=N'Param4'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Reserved' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'HSMS_Log', @level2type=N'COLUMN',@level2name=N'Param5'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Destination Mobile Number' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'HSMS_Log', @level2type=N'COLUMN',@level2name=N'MobileNo'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Message' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'HSMS_Log', @level2type=N'COLUMN',@level2name=N'Message'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Message Status' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'HSMS_Log', @level2type=N'COLUMN',@level2name=N'Status'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'SMS Gateway TrxID' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'HSMS_Log', @level2type=N'COLUMN',@level2name=N'TrxID'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Error Message' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'HSMS_Log', @level2type=N'COLUMN',@level2name=N'TrxErrMsg'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'SMS Rule Code' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'HSMS_Rule', @level2type=N'COLUMN',@level2name=N'SMSRule'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'SMS Rule Description' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'HSMS_Rule', @level2type=N'COLUMN',@level2name=N'Description'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'SMS Gateway URL Address' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'HSMS_Rule', @level2type=N'COLUMN',@level2name=N'GatewayURL'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Mobile No URL QueryString' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'HSMS_Rule', @level2type=N'COLUMN',@level2name=N'MobileNoQS'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Message URL QueryString' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'HSMS_Rule', @level2type=N'COLUMN',@level2name=N'MessageQS'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Message Content' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'HSMS_Rule', @level2type=N'COLUMN',@level2name=N'Message'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'SQL Statement' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'HSMS_Rule', @level2type=N'COLUMN',@level2name=N'SQL'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'SQL Field taken from SQL Statement using @@PARAM01' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'HSMS_Rule', @level2type=N'COLUMN',@level2name=N'Param01'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Last User' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'HSMS_Rule', @level2type=N'COLUMN',@level2name=N'Last_Opr'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Last Update' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'HSMS_Rule', @level2type=N'COLUMN',@level2name=N'Last_Update'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Last Send' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'HSMS_Rule', @level2type=N'COLUMN',@level2name=N'LastEmail'
GO



 insert into PatchVersioning
select '461 update script - Table HSMS_LOG HSMS_RULE',GETDATE()
go


Declare @PrevScript varchar(100)
Declare @CurrScript varchar(100)

Select @PrevScript=''
Select @CurrSCript='461 update script - Table HSMS_LOG HSMS_RULE'


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
