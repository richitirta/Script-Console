IF  NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'Village') AND type in (N'U'))
BEGIN

CREATE TABLE [dbo].[Village](
       [Village] [nvarchar](50) NOT NULL,
       [Description] [nvarchar](100) NULL,
       [Description_1] [nvarchar](100) NULL,
       [Province] [varchar](10) NULL,
       [District] [nvarchar](50) NULL,
       [SubDistrict] [nvarchar](50) NOT NULL,
       [ZipCode] [varchar](20) NULL,
       [AllowedF] [bit] NULL,
       [Last_Update] [smalldatetime] NULL,
       [Last_OPR] [varchar](10) NULL,
CONSTRAINT [I_Village] PRIMARY KEY CLUSTERED 
(
       [Village] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

SET ANSI_PADDING OFF
end
GO
