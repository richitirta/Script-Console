
/****** Object:  Table [dbo].[SCHEME_ACCEMPCONTD]    Script Date: 6/19/2026 9:17:45 PM ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SCHEME_ACCEMPCONTD]') AND type in (N'U'))
DROP TABLE [dbo].[SCHEME_ACCEMPCONTD]
GO

/****** Object:  Table [dbo].[SCHEME_ACCEMPCONTD]    Script Date: 6/19/2026 9:17:45 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[SCHEME_ACCEMPCONTD](
	[TrNo] [int] NOT NULL,
	[ID] [varchar](50) NOT NULL,
	[REMARKS] [varchar](255) NULL,
	[PCT] [float] NULL,
	[ECUTYPE] [varchar](50) NULL,
 CONSTRAINT [I_SCHEME_ACCEMPCONTD] PRIMARY KEY CLUSTERED 
(
	[TrNo] ASC,
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO

ALTER TABLE [dbo].[SCHEME_ACCEMPCONTD] SET (LOCK_ESCALATION = DISABLE)
GO
ALTER TABLE [dbo].[SCHEME_ACCEMPCONTD]  WITH NOCHECK ADD  CONSTRAINT [FK_SCHEME_ACCEMPCONTD_Scheme_Transaction] FOREIGN KEY([TrNo])
REFERENCES [dbo].[Scheme_Transaction] ([TrNo])
ON UPDATE CASCADE
ON DELETE CASCADE
GO

ALTER TABLE [dbo].[SCHEME_ACCEMPCONTD] CHECK CONSTRAINT [FK_SCHEME_ACCEMPCONTD_Scheme_Transaction]
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Scheme Transaction (see TrNo)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'SCHEME_ACCEMPCONTD', @level2type=N'COLUMN',@level2name=N'TrNo'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Employee ID (see SysUser)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'SCHEME_ACCEMPCONTD', @level2type=N'COLUMN',@level2name=N'ID'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Remarks' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'SCHEME_ACCEMPCONTD', @level2type=N'COLUMN',@level2name=N'REMARKS'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Percentage Contribution (%)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'SCHEME_ACCEMPCONTD', @level2type=N'COLUMN',@level2name=N'PCT'
GO


