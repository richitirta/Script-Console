
/****** Object:  Table [dbo].[Occupation]    Script Date: 10/2/2020 11:04:01 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO
IF  NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[Occupation]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[Occupation](
	[Occupation] [varchar](10) NOT NULL,
	[Description] [varchar](50) NULL,
	[ALLOWEDF] [bit] NULL,
	[Last_Opr] [varchar](50) NULL,
	[Last_Update] [smalldatetime] NULL,
	[RiskClass] [int] NULL,
	[Name] [varchar](50) NULL,
 CONSTRAINT [I_Occupation] PRIMARY KEY CLUSTERED 
(
	[Occupation] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Allow Selection Flag (0 : No, 1 : Yes)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Occupation', @level2type=N'COLUMN',@level2name=N'ALLOWEDF'
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Last User Update' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Occupation', @level2type=N'COLUMN',@level2name=N'Last_Opr'
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Last Date Update' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Occupation', @level2type=N'COLUMN',@level2name=N'Last_Update'
ALTER TABLE [dbo].[Occupation] ADD  CONSTRAINT [DF_Occupation_ALLOWEDF]  DEFAULT (0) FOR [ALLOWEDF]
end
GO





   
 insert into PatchVersioning
select '56.10 create table Occuption',GETDATE()
go