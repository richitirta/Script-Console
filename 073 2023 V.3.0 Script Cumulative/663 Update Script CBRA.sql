--TABLE 1
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[CBRADepartment](
	[Department] [varchar](50) NOT NULL,
	[AllowedF] [bit] NULL,
 CONSTRAINT [I_Department] PRIMARY KEY CLUSTERED 
(
	[Department] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO

SET ANSI_PADDING OFF
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Allow Selection Flag (0  : No, 1 : Yes)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'CBRADepartment', @level2type=N'COLUMN',@level2name=N'AllowedF'
GO

update CBRADepartment set Department = '' where Department is null
go

update CBRADepartment set AllowedF = 1 where AllowedF is null
go

INSERT INTO CBRADepartment VALUES ('Account & Finance',1)
GO

--TABLE 2
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[CBRAAgreementStatus](
	[AgreementStatus] [varchar](50) NOT NULL,
	[AllowedF] [bit] NULL,
 CONSTRAINT [I_AgreementStatus] PRIMARY KEY CLUSTERED 
(
	[AgreementStatus] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO

SET ANSI_PADDING OFF
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Allow Selection Flag (0  : No, 1 : Yes)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'CBRAAgreementStatus', @level2type=N'COLUMN',@level2name=N'AllowedF'
GO

update CBRAAgreementStatus set AgreementStatus = '' where AgreementStatus is null
go

update CBRAAgreementStatus set AllowedF = 1 where AllowedF is null
go

INSERT INTO CBRAAgreementStatus VALUES ('Active',1)
GO


--TABLE 3
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[CBRATPTYPE](
	[TPTYPE] [varchar](50) NOT NULL,
	[AllowedF] [bit] NULL,
 CONSTRAINT [I_TPTYPE] PRIMARY KEY CLUSTERED 
(
	[TPTYPE] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO

SET ANSI_PADDING OFF
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Allow Selection Flag (0  : No, 1 : Yes)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'CBRATPTYPE', @level2type=N'COLUMN',@level2name=N'AllowedF'
GO

update CBRATPTYPE set TPTYPE = '' where TPTYPE is null
go

update CBRATPTYPE set AllowedF = 1 where AllowedF is null
go

INSERT INTO CBRATPTYPE VALUES ('Global',1)
GO


--TABLE 4
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[CBRAAgreement](
	[Agreement] [varchar](50) NOT NULL,
	[AllowedF] [bit] NULL,
 CONSTRAINT [I_Agreement] PRIMARY KEY CLUSTERED 
(
	[Agreement] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO

SET ANSI_PADDING OFF
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Allow Selection Flag (0  : No, 1 : Yes)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'CBRAAgreement', @level2type=N'COLUMN',@level2name=N'AllowedF'
GO

update CBRAAgreement set Agreement = '' where Agreement is null
go

update CBRAAgreement set AllowedF = 1 where AllowedF is null
go

INSERT INTO CBRAAgreement VALUES ('Yes',1)
GO


--TABLE 5
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[CBRAOBDDStatus](
	[BDDStatus] [varchar](50) NOT NULL,
	[AllowedF] [bit] NULL,
 CONSTRAINT [I_BDDStatus] PRIMARY KEY CLUSTERED 
(
	[BDDStatus] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO

SET ANSI_PADDING OFF
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Allow Selection Flag (0  : No, 1 : Yes)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'CBRAOBDDStatus', @level2type=N'COLUMN',@level2name=N'AllowedF'
GO

update CBRAOBDDStatus set BDDStatus = '' where BDDStatus is null
go

update CBRAOBDDStatus set AllowedF = 1 where AllowedF is null
go

INSERT INTO CBRAOBDDStatus VALUES ('Completed',1)
GO


--TABLE 6
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[CBRAOBDDRating](
	[BDDRating] [varchar](50) NOT NULL,
	[AllowedF] [bit] NULL,
 CONSTRAINT [I_BDDRating] PRIMARY KEY CLUSTERED 
(
	[BDDRating] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO

SET ANSI_PADDING OFF
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Allow Selection Flag (0  : No, 1 : Yes)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'CBRAOBDDRating', @level2type=N'COLUMN',@level2name=N'AllowedF'
GO

update CBRAOBDDRating set BDDRating = '' where BDDRating is null
go

update CBRAOBDDRating set AllowedF = 1 where AllowedF is null
go

INSERT INTO CBRAOBDDRating VALUES ('Elevated',1)
GO



--TABLE 7
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[CBRAODDSTPDate](
	[DDSTPDate] [varchar](50) NOT NULL,
	[AllowedF] [bit] NULL,
 CONSTRAINT [I_DDSTPDate] PRIMARY KEY CLUSTERED 
(
	[DDSTPDate] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO

SET ANSI_PADDING OFF
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Allow Selection Flag (0  : No, 1 : Yes)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'CBRAODDSTPDate', @level2type=N'COLUMN',@level2name=N'AllowedF'
GO

update CBRAODDSTPDate set DDSTPDate = '' where DDSTPDate is null
go

update CBRAODDSTPDate set AllowedF = 1 where AllowedF is null
go

INSERT INTO CBRAODDSTPDate VALUES ('Passed Due',1)
GO





--TABLE 8
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[CBRAODDIRTPStatus](
	[DDIRTPStatus] [varchar](50) NOT NULL,
	[AllowedF] [bit] NULL,
 CONSTRAINT [I_DDIRTPStatus] PRIMARY KEY CLUSTERED 
(
	[DDIRTPStatus] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO

SET ANSI_PADDING OFF
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Allow Selection Flag (0  : No, 1 : Yes)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'CBRAODDIRTPStatus', @level2type=N'COLUMN',@level2name=N'AllowedF'
GO

update CBRAODDIRTPStatus set DDIRTPStatus = '' where DDIRTPStatus is null
go

update CBRAODDIRTPStatus set AllowedF = 1 where AllowedF is null
go

INSERT INTO CBRAODDIRTPStatus VALUES ('Passed Due',1)
GO


--TABLE 9
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[CBRANDASTATUS](
	[NDASTATUS] [varchar](50) NOT NULL,
	[AllowedF] [bit] NULL,
 CONSTRAINT [I_NDASTATUS] PRIMARY KEY CLUSTERED 
(
	[NDASTATUS] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO

SET ANSI_PADDING OFF
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Allow Selection Flag (0  : No, 1 : Yes)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'CBRANDASTATUS', @level2type=N'COLUMN',@level2name=N'AllowedF'
GO

update CBRANDASTATUS set NDASTATUS = '' where NDASTATUS is null
go

update CBRANDASTATUS set AllowedF = 1 where AllowedF is null
go

INSERT INTO CBRANDASTATUS VALUES ('Active',1)
GO


--TABLE 10
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[CBRATPStatus](
	[TPStatus] [varchar](50) NOT NULL,
	[AllowedF] [bit] NULL,
 CONSTRAINT [I_TPStatus] PRIMARY KEY CLUSTERED 
(
	[TPStatus] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO

SET ANSI_PADDING OFF
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Allow Selection Flag (0  : No, 1 : Yes)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'CBRATPStatus', @level2type=N'COLUMN',@level2name=N'AllowedF'
GO

update CBRATPStatus set TPStatus = '' where TPStatus is null
go

update CBRATPStatus set AllowedF = 1 where AllowedF is null
go

INSERT INTO CBRATPStatus VALUES ('Active',1)
GO