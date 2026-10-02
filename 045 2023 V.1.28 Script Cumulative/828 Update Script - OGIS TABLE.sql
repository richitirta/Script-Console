
IF  NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'OGIS_ERROR') AND type in (N'U'))
BEGIN

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
SET ANSI_PADDING ON

CREATE TABLE [dbo].[OGIS_ERROR](
	[OGIS_ERROR_ID] [varchar](10) NOT NULL,
	[OGIS_ERROR_MESSAGE] [varchar](500) NULL,
	[OGIS_ERROR_DESCRIPTION] [varchar](500) NULL,
	[Last_Update] [smalldatetime] NULL,
	[Last_opr] [varchar](50) NULL,
 CONSTRAINT [I_OGIS_ERROR] PRIMARY KEY CLUSTERED 
(
	[OGIS_ERROR_ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

SET ANSI_PADDING OFF
END
GO


IF  NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'OGIS_LOG_DETAIL') AND type in (N'U'))
BEGIN

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
SET ANSI_PADDING ON


CREATE TABLE [dbo].[OGIS_LOG_DETAIL](
	[OGIS_LOGID] [int] NOT NULL,
	[OGIS_RECID] [int] NOT NULL,
	[OGIS_ERROR_ID] [varchar](10) NULL,
	[OGIS_ERROR_MESSAGE] [varchar](500) NULL,
	[RECSTATUS] [varchar](10) NULL,
	[APPID] [varchar](20) NULL,
	[APPTYPE] [varchar](10) NULL,
	[OGIS_ID_1] [varchar](10) NULL,
	[OGIS_VALUE_1] [varchar](250) NULL,
	[OGIS_ID_2] [varchar](10) NULL,
	[OGIS_VALUE_2] [varchar](250) NULL,
	[OGIS_ID_3] [varchar](10) NULL,
	[OGIS_VALUE_3] [varchar](250) NULL,
	[OGIS_ID_4] [varchar](10) NULL,
	[OGIS_VALUE_4] [varchar](250) NULL,
	[OGIS_ID_5] [varchar](10) NULL,
	[OGIS_VALUE_5] [varchar](250) NULL,
	[OGIS_ID_6] [varchar](10) NULL,
	[OGIS_VALUE_6] [varchar](250) NULL,
	[OGIS_ID_7] [varchar](10) NULL,
	[OGIS_VALUE_7] [varchar](250) NULL,
	[OGIS_ID_8] [varchar](10) NULL,
	[OGIS_VALUE_8] [varchar](250) NULL,
	[OGIS_ID_9] [varchar](10) NULL,
	[OGIS_VALUE_9] [varchar](250) NULL,
	[OGIS_ID_10] [varchar](10) NULL,
	[OGIS_VALUE_10] [varchar](250) NULL,
	[OGIS_ID_11] [varchar](10) NULL,
	[OGIS_VALUE_11] [varchar](250) NULL,
	[OGIS_ID_12] [varchar](10) NULL,
	[OGIS_VALUE_12] [varchar](250) NULL,
	[OGIS_ID_13] [varchar](10) NULL,
	[OGIS_VALUE_13] [varchar](250) NULL,
	[OGIS_ID_14] [varchar](10) NULL,
	[OGIS_VALUE_14] [varchar](250) NULL,
	[OGIS_ID_15] [varchar](10) NULL,
	[OGIS_VALUE_15] [varchar](250) NULL,
	[OGIS_ID_16] [varchar](10) NULL,
	[OGIS_VALUE_16] [varchar](250) NULL,
	[OGIS_ID_17] [varchar](10) NULL,
	[OGIS_VALUE_17] [varchar](250) NULL,
	[OGIS_ID_18] [varchar](10) NULL,
	[OGIS_VALUE_18] [varchar](250) NULL,
	[OGIS_ID_19] [varchar](10) NULL,
	[OGIS_VALUE_19] [varchar](250) NULL,
	[OGIS_ID_20] [varchar](10) NULL,
	[OGIS_VALUE_20] [varchar](250) NULL,
	[OGIS_ID_21] [varchar](10) NULL,
	[OGIS_VALUE_21] [varchar](250) NULL,
	[OGIS_ID_22] [varchar](10) NULL,
	[OGIS_VALUE_22] [varchar](250) NULL,
	[OGIS_ID_23] [varchar](10) NULL,
	[OGIS_VALUE_23] [varchar](250) NULL,
	[OGIS_ID_24] [varchar](10) NULL,
	[OGIS_VALUE_24] [varchar](250) NULL,
	[OGIS_ID_25] [varchar](10) NULL,
	[OGIS_VALUE_25] [varchar](250) NULL,
	[OGIS_ID_26] [varchar](10) NULL,
	[OGIS_VALUE_26] [varchar](250) NULL,
	[OGIS_ID_27] [varchar](10) NULL,
	[OGIS_VALUE_27] [varchar](250) NULL,
	[OGIS_ID_28] [varchar](10) NULL,
	[OGIS_VALUE_28] [varchar](250) NULL,
	[OGIS_ID_29] [varchar](10) NULL,
	[OGIS_VALUE_29] [varchar](250) NULL,
	[OGIS_ID_30] [varchar](10) NULL,
	[OGIS_VALUE_30] [varchar](250) NULL,
	[OGIS_ID_31] [varchar](10) NULL,
	[OGIS_VALUE_31] [varchar](250) NULL,
	[OGIS_ID_32] [varchar](10) NULL,
	[OGIS_VALUE_32] [varchar](250) NULL,
	[OGIS_ID_33] [varchar](10) NULL,
	[OGIS_VALUE_33] [varchar](250) NULL,
	[OGIS_ID_34] [varchar](10) NULL,
	[OGIS_VALUE_34] [varchar](250) NULL,
	[OGIS_ID_35] [varchar](10) NULL,
	[OGIS_VALUE_35] [varchar](250) NULL,
	[OGIS_ID_36] [varchar](10) NULL,
	[OGIS_VALUE_36] [varchar](250) NULL,
	[OGIS_ID_37] [varchar](10) NULL,
	[OGIS_VALUE_37] [varchar](250) NULL,
	[OGIS_ID_38] [varchar](10) NULL,
	[OGIS_VALUE_38] [varchar](250) NULL,
	[OGIS_ID_39] [varchar](10) NULL,
	[OGIS_VALUE_39] [varchar](250) NULL,
	[OGIS_ID_40] [varchar](10) NULL,
	[OGIS_VALUE_40] [varchar](250) NULL,
	[OGIS_ID_41] [varchar](10) NULL,
	[OGIS_VALUE_41] [varchar](250) NULL,
	[OGIS_ID_42] [varchar](10) NULL,
	[OGIS_VALUE_42] [varchar](250) NULL,
	[OGIS_ID_43] [varchar](10) NULL,
	[OGIS_VALUE_43] [varchar](250) NULL,
	[OGIS_ID_44] [varchar](10) NULL,
	[OGIS_VALUE_44] [varchar](250) NULL,
	[OGIS_ID_45] [varchar](10) NULL,
	[OGIS_VALUE_45] [varchar](250) NULL,
	[OGIS_ID_46] [varchar](10) NULL,
	[OGIS_VALUE_46] [varchar](250) NULL,
	[OGIS_ID_47] [varchar](10) NULL,
	[OGIS_VALUE_47] [varchar](250) NULL,
	[OGIS_ID_48] [varchar](10) NULL,
	[OGIS_VALUE_48] [varchar](250) NULL,
	[OGIS_ID_49] [varchar](10) NULL,
	[OGIS_VALUE_49] [varchar](250) NULL,
	[OGIS_ID_50] [varchar](10) NULL,
	[OGIS_VALUE_50] [varchar](250) NULL,
	[OGIS_ID_51] [varchar](10) NULL,
	[OGIS_VALUE_51] [varchar](250) NULL,
	[OGIS_ID_52] [varchar](10) NULL,
	[OGIS_VALUE_52] [varchar](250) NULL,
	[OGIS_ID_53] [varchar](10) NULL,
	[OGIS_VALUE_53] [varchar](250) NULL,
	[OGIS_ID_54] [varchar](10) NULL,
	[OGIS_VALUE_54] [varchar](250) NULL,
	[OGIS_ID_55] [varchar](10) NULL,
	[OGIS_VALUE_55] [varchar](250) NULL,
	[OGIS_ID_56] [varchar](10) NULL,
	[OGIS_VALUE_56] [varchar](250) NULL,
	[OGIS_ID_57] [varchar](10) NULL,
	[OGIS_VALUE_57] [varchar](250) NULL,
	[OGIS_ID_58] [varchar](10) NULL,
	[OGIS_VALUE_58] [varchar](250) NULL,
	[OGIS_ID_59] [varchar](10) NULL,
	[OGIS_VALUE_59] [varchar](250) NULL,
	[OGIS_ID_60] [varchar](10) NULL,
	[OGIS_VALUE_60] [varchar](250) NULL,
	[OGIS_ID_61] [varchar](10) NULL,
	[OGIS_VALUE_61] [varchar](250) NULL,
	[OGIS_ID_62] [varchar](10) NULL,
	[OGIS_VALUE_62] [varchar](250) NULL,
	[OGIS_ID_63] [varchar](10) NULL,
	[OGIS_VALUE_63] [varchar](250) NULL,
	[OGIS_ID_64] [varchar](10) NULL,
	[OGIS_VALUE_64] [varchar](250) NULL,
	[OGIS_ID_65] [varchar](10) NULL,
	[OGIS_VALUE_65] [varchar](250) NULL,
	[OGIS_ID_66] [varchar](10) NULL,
	[OGIS_VALUE_66] [varchar](250) NULL,
	[OGIS_ID_67] [varchar](10) NULL,
	[OGIS_VALUE_67] [varchar](250) NULL,
	[OGIS_ID_68] [varchar](10) NULL,
	[OGIS_VALUE_68] [varchar](250) NULL,
	[OGIS_ID_69] [varchar](10) NULL,
	[OGIS_VALUE_69] [varchar](250) NULL,
	[OGIS_ID_70] [varchar](10) NULL,
	[OGIS_VALUE_70] [varchar](250) NULL,
	[OGIS_ID_71] [varchar](10) NULL,
	[OGIS_VALUE_71] [varchar](250) NULL,
	[OGIS_ID_72] [varchar](10) NULL,
	[OGIS_VALUE_72] [varchar](250) NULL,
	[OGIS_ID_73] [varchar](10) NULL,
	[OGIS_VALUE_73] [varchar](250) NULL,
	[OGIS_ID_74] [varchar](10) NULL,
	[OGIS_VALUE_74] [varchar](250) NULL,
	[OGIS_ID_75] [varchar](10) NULL,
	[OGIS_VALUE_75] [varchar](250) NULL,
	[OGIS_ID_76] [varchar](10) NULL,
	[OGIS_VALUE_76] [varchar](250) NULL,
	[OGIS_ID_77] [varchar](10) NULL,
	[OGIS_VALUE_77] [varchar](250) NULL,
	[OGIS_ID_78] [varchar](10) NULL,
	[OGIS_VALUE_78] [varchar](250) NULL,
	[OGIS_ID_79] [varchar](10) NULL,
	[OGIS_VALUE_79] [varchar](250) NULL,
	[OGIS_ID_80] [varchar](10) NULL,
	[OGIS_VALUE_80] [varchar](250) NULL,
	[OGIS_ID_81] [varchar](10) NULL,
	[OGIS_VALUE_81] [varchar](250) NULL,
	[OGIS_ID_82] [varchar](10) NULL,
	[OGIS_VALUE_82] [varchar](250) NULL,
	[OGIS_ID_83] [varchar](10) NULL,
	[OGIS_VALUE_83] [varchar](250) NULL,
	[OGIS_ID_84] [varchar](10) NULL,
	[OGIS_VALUE_84] [varchar](250) NULL,
	[OGIS_ID_85] [varchar](10) NULL,
	[OGIS_VALUE_85] [varchar](250) NULL,
	[OGIS_ID_86] [varchar](10) NULL,
	[OGIS_VALUE_86] [varchar](250) NULL,
	[OGIS_ID_87] [varchar](10) NULL,
	[OGIS_VALUE_87] [varchar](250) NULL,
	[OGIS_ID_88] [varchar](10) NULL,
	[OGIS_VALUE_88] [varchar](250) NULL,
	[OGIS_ID_89] [varchar](10) NULL,
	[OGIS_VALUE_89] [varchar](250) NULL,
	[OGIS_ID_90] [varchar](10) NULL,
	[OGIS_VALUE_90] [varchar](250) NULL,
	[OGIS_ID_91] [varchar](10) NULL,
	[OGIS_VALUE_91] [varchar](250) NULL,
	[OGIS_ID_92] [varchar](10) NULL,
	[OGIS_VALUE_92] [varchar](250) NULL,
	[OGIS_ID_93] [varchar](10) NULL,
	[OGIS_VALUE_93] [varchar](250) NULL,
	[OGIS_ID_94] [varchar](10) NULL,
	[OGIS_VALUE_94] [varchar](250) NULL,
	[OGIS_ID_95] [varchar](10) NULL,
	[OGIS_VALUE_95] [varchar](250) NULL,
	[OGIS_ID_96] [varchar](10) NULL,
	[OGIS_VALUE_96] [varchar](250) NULL,
	[OGIS_ID_97] [varchar](10) NULL,
	[OGIS_VALUE_97] [varchar](250) NULL,
	[OGIS_ID_98] [varchar](10) NULL,
	[OGIS_VALUE_98] [varchar](250) NULL,
	[OGIS_ID_99] [varchar](10) NULL,
	[OGIS_VALUE_99] [varchar](250) NULL,
	[OGIS_ID_100] [varchar](10) NULL,
	[OGIS_VALUE_100] [varchar](250) NULL,
 CONSTRAINT [I_OGIS_LOG_DETAIL] PRIMARY KEY CLUSTERED 
(
	[OGIS_LOGID] ASC,
	[OGIS_RECID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]


SET ANSI_PADDING OFF
END
GO


IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'OGIS_LOG_HEADER') AND type in (N'U'))
BEGIN

SET ANSI_NULLS ON

SET QUOTED_IDENTIFIER ON

SET ANSI_PADDING ON

CREATE TABLE [dbo].[OGIS_LOG_HEADER](
	[OGIS_LOGID] [int] NOT NULL,
	[FILENAME] [varchar](255) NULL,
	[OGIS_TYPE] [varchar](15) NULL,
	[PDATE] [smalldatetime] NULL,
	[PTIME] [varchar](8) NULL,
	[USERID] [varchar](50) NULL,
	[LOGSTATUS] [varchar](50) NULL,
	[LDATE] [smalldatetime] NULL,
	[LTIME] [varchar](8) NULL,
 CONSTRAINT [I_OGIS_LOG_HEADER] PRIMARY KEY CLUSTERED 
(
	[OGIS_LOGID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]



SET ANSI_PADDING OFF

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Last Date Processed' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'OGIS_LOG_HEADER', @level2type=N'COLUMN',@level2name=N'LDATE'

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Last Time Processed' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'OGIS_LOG_HEADER', @level2type=N'COLUMN',@level2name=N'LTIME'

END
GO



IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'OGIS_MAP_DETAIL') AND type in (N'U'))
BEGIN

SET ANSI_NULLS ON

SET QUOTED_IDENTIFIER ON

SET ANSI_PADDING ON

CREATE TABLE [dbo].[OGIS_MAP_DETAIL](
	[OGIS_ID] [varchar](10) NOT NULL,
	[SOURCE_VALUE] [varchar](100) NOT NULL,
	[OGIS_VALUE] [varchar](100) NULL,
	[EFFECTIVE_DATE] [smalldatetime] NOT NULL,
	[Last_Update] [smalldatetime] NULL,
	[Last_opr] [varchar](50) NULL,
 CONSTRAINT [I_OGIS_MAP_DETAIL] PRIMARY KEY CLUSTERED 
(
	[OGIS_ID] ASC,
	[SOURCE_VALUE] ASC,
	[EFFECTIVE_DATE] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]


SET ANSI_PADDING OFF

end
GO


IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'OGIS_MAP_HEADER') AND type in (N'U'))
BEGIN

SET ANSI_NULLS ON

SET QUOTED_IDENTIFIER ON

SET ANSI_PADDING ON

CREATE TABLE [dbo].[OGIS_MAP_HEADER](
	[OGIS_ID] [varchar](10) NOT NULL,
	[OGIS_FIELD_NAME] [varchar](50) NULL,
	[SOURCE_FIELD_NAME] [varchar](50) NULL,
	[MAXLENGTH] [int] NULL,
	[OGIS_MAP_DETAIL_FLAG] [bit] NULL,
	[OGIS_FIELD_DESCRIPTION] [varchar](500) NULL,
	[OGIS_TYPE] [varchar](15) NULL,
	[Last_Update] [smalldatetime] NULL,
	[Last_opr] [varchar](50) NULL,
 CONSTRAINT [I_OGIS_MAP_HEADER] PRIMARY KEY CLUSTERED 
(
	[OGIS_ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]


SET ANSI_PADDING OFF

end
go


IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'OGIS_SUMMARIZATION') AND type in (N'U'))
BEGIN

SET ANSI_NULLS ON

SET QUOTED_IDENTIFIER ON

SET ANSI_PADDING OFF

CREATE TABLE [dbo].[OGIS_SUMMARIZATION](
	[TREATY_ID] [varchar](50) NOT NULL,
	[PARTICIPANT_ID] [varchar](20) NOT NULL,
	[SUMMARIZATION_1] [varchar](20) NULL,
	[SUMMARIZATION_2] [varchar](20) NULL,
	[SUMMARIZATION_3] [varchar](20) NULL,
 CONSTRAINT [PK_OGIS_SUMMARIZATION] PRIMARY KEY CLUSTERED 
(
	[TREATY_ID] ASC,
	[PARTICIPANT_ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]


SET ANSI_PADDING OFF

end
GO



 insert into PatchVersioning
select '828 Update Script - OGIS TABLE',GETDATE()
go


Declare @PrevScript varchar(100)
Declare @CurrScript varchar(100)

Select @PrevScript=''
Select @CurrSCript='828 Update Script - OGIS TABLE'


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


