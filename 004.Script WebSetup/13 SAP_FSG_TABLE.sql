
IF  NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SAP_FSG_TABLE]') AND type in (N'U'))
begin
/****** Object:  Table [dbo].[SAP_FSG_TABLE]    Script Date: 10/21/2020 9:36:00 PM ******/
SET ANSI_NULLS ON


SET QUOTED_IDENTIFIER ON


CREATE TABLE [dbo].[SAP_FSG_TABLE](
	[Account] [varchar](10) NOT NULL,
	[Description] [varchar](255) NULL,
	[CCode] [varchar](20) NULL,
	[ProfitCenter] [varchar](20) NULL,
	[CostCenter] [varchar](20) NULL,
	[TPartner] [varchar](20) NULL,
	[LOB] [varchar](20) NULL,
	[ProdOffice] [varchar](20) NULL,
	[Blocked_1] [bit] NULL,
	[Blocked_2] [bit] NULL
) ON [PRIMARY]



ALTER TABLE [dbo].[SAP_FSG_TABLE] ADD  DEFAULT ((0)) FOR [Blocked_1]


ALTER TABLE [dbo].[SAP_FSG_TABLE] ADD  DEFAULT ((0)) FOR [Blocked_2]
end
GO


insert into PatchVersioning
select 'SAP_FSG_TABLE',GETDATE()
go
