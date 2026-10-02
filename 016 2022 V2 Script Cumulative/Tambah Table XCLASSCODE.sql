/****** Object:  Table [dbo].[XCLASSCODE]    Script Date: 8/9/2022 5:02:24 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO
IF  NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'XCLASSCODE') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[XCLASSCODE](
	[ClassCode] [varchar](50) NOT NULL,
	[ClassDesc1] [varchar](255) NULL,
	[ClassDesc2] [varchar](255) NULL,
	[RateCode] [varchar](50) NULL,
	[RateDesc] [varchar](255) NULL,
	[TOC] [varchar](20) NULL,
	[TOCDesc] [varchar](255) NULL,
 CONSTRAINT [i_XCLASSCODE] PRIMARY KEY CLUSTERED 
(
	[ClassCode] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
END
GO


