/****** Object:  Table [dbo].[IFRS_CancelRate]    Script Date: 6/16/2023 6:05:36 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

SET ANSI_PADDING ON
GO

CREATE TABLE [dbo].[IFRS_CancelRate](
	[CancelRateID] [varchar](10) NOT NULL,
	[Description] [varchar](255) NULL,
	[Last_Opr] [varchar](50) NULL,
	[Last_Update] [smalldatetime] NULL,
	[AllowedF] [bit] NULL,
 CONSTRAINT [I_IFRS_CancelRate] PRIMARY KEY CLUSTERED 
(
	[CancelRateID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO

SET ANSI_PADDING OFF
GO

/****** Object:  Table [dbo].[IFRS_CancelRate_Detail]    Script Date: 6/16/2023 6:05:36 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

SET ANSI_PADDING ON
GO

CREATE TABLE [dbo].[IFRS_CancelRate_Detail](
	[CancelRateID] [varchar](10) NOT NULL,
	[VDate] [smalldatetime] NOT NULL,
	[Tenor] [int] NOT NULL,
	[CancelRate_1] [float] NULL,
	[CancelRate_2] [float] NULL,
	[CancelRate_3] [float] NULL,
	[CancelRate_4] [float] NULL,
	[CancelRate_5] [float] NULL,
	[CancelRate_6] [float] NULL,
	[CancelRate_7] [float] NULL,
	[CancelRate_8] [float] NULL,
	[CancelRate_9] [float] NULL,
	[CancelRate_10] [float] NULL,
	[CancelRate_11] [float] NULL,
	[CancelRate_12] [float] NULL,
	[CancelRate_13] [float] NULL,
	[CancelRate_14] [float] NULL,
	[CancelRate_15] [float] NULL,
	[CancelRate_16] [float] NULL,
	[CancelRate_17] [float] NULL,
	[CancelRate_18] [float] NULL,
	[CancelRate_19] [float] NULL,
	[CancelRate_20] [float] NULL,
	[CancelRate_21] [float] NULL,
	[CancelRate_22] [float] NULL,
	[CancelRate_23] [float] NULL,
	[CancelRate_24] [float] NULL,
	[CancelRate_25] [float] NULL,
	[CancelRate_26] [float] NULL,
	[CancelRate_27] [float] NULL,
	[CancelRate_28] [float] NULL,
	[CancelRate_29] [float] NULL,
	[CancelRate_30] [float] NULL,
	[Last_Opr] [varchar](50) NULL,
	[Last_Update] [smalldatetime] NULL,
 CONSTRAINT [I_IFRS_CancelRate_Detail] PRIMARY KEY CLUSTERED 
(
	[CancelRateID] ASC,
	[VDate] ASC,
	[Tenor] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO

SET ANSI_PADDING OFF
GO

ALTER TABLE [dbo].[IFRS_CancelRate_Detail]  WITH CHECK ADD  CONSTRAINT [FK_IFRS_CancelRate_Detail_IFRS_CancelRate] FOREIGN KEY([CancelRateID])
REFERENCES [dbo].[IFRS_CancelRate] ([CancelRateID])
ON UPDATE CASCADE
ON DELETE CASCADE
GO

ALTER TABLE [dbo].[IFRS_CancelRate_Detail] CHECK CONSTRAINT [FK_IFRS_CancelRate_Detail_IFRS_CancelRate]
GO




 insert into PatchVersioning	
select '671 Update Script - IFRS Patch #14',GETDATE()
go





Declare @PrevScript varchar(100)
Declare @CurrScript varchar(100)

Select @PrevScript=''
Select @CurrSCript='671 Update Script - IFRS Patch #14'


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




