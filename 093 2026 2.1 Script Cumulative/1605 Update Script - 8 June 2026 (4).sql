/****** Object:  Table [dbo].[AISOURCE]    Script Date: 6/23/2026 10:10:26 PM ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[AISOURCE]') AND type in (N'U'))
DROP TABLE [dbo].[AISOURCE]
GO

/****** Object:  Table [dbo].[AISOURCE]    Script Date: 6/23/2026 10:10:26 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[AISOURCE](
	[ANO] [int] NOT NULL,
	[ID] [varchar](10) NULL,
	[SHARE] [float] NULL,
	[FEE] [float] NULL,
	[HF] [float] NULL,
	[WPC] [int] NULL,
	[RType] [varchar](2) NULL,
	[OC] [float] NULL,
	[Amount] [float] NULL,
	[CR] [float] NULL,
	[HFAmount] [float] NULL,
	[UJROHREINS] [float] NULL,
	[UJROHCEDANT] [float] NULL,
	[Limit] [float] NULL,
	[Excess] [float] NULL,
	[BinderWarranty] [int] NULL,
	[CedingID] [varchar](10) NULL,
	[VAT] [float] NULL,
 CONSTRAINT [I_AISOURCE] PRIMARY KEY CLUSTERED 
(
	[ANO] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO

ALTER TABLE [dbo].[AISOURCE] SET (LOCK_ESCALATION = DISABLE)
GO

ALTER TABLE [dbo].[AISOURCE]  WITH NOCHECK ADD  CONSTRAINT [FK_AISOURCE_PROFILE] FOREIGN KEY([ID])
REFERENCES [dbo].[Profile] ([ID])
GO

ALTER TABLE [dbo].[AISOURCE] CHECK CONSTRAINT [FK_AISOURCE_PROFILE]
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Acceptance No (see Acceptance)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'AISOURCE', @level2type=N'COLUMN',@level2name=N'ANO'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Insurance Source Profile ID' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'AISOURCE', @level2type=N'COLUMN',@level2name=N'ID'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'% Our Share' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'AISOURCE', @level2type=N'COLUMN',@level2name=N'SHARE'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'% Commission' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'AISOURCE', @level2type=N'COLUMN',@level2name=N'FEE'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'% Handling Fee' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'AISOURCE', @level2type=N'COLUMN',@level2name=N'HF'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Warranty Premium Clause (in Days)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'AISOURCE', @level2type=N'COLUMN',@level2name=N'WPC'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Reinsurance Type (for inward treaty only)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'AISOURCE', @level2type=N'COLUMN',@level2name=N'RType'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'% Overriding Commission' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'AISOURCE', @level2type=N'COLUMN',@level2name=N'OC'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Our Share in Amount' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'AISOURCE', @level2type=N'COLUMN',@level2name=N'Amount'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'% Claim Reserve Portfolio ' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'AISOURCE', @level2type=N'COLUMN',@level2name=N'CR'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Handling Fee in Amount' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'AISOURCE', @level2type=N'COLUMN',@level2name=N'HFAmount'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'% Ujroh Fee for Reinsurer  (0 : Not Apply)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'AISOURCE', @level2type=N'COLUMN',@level2name=N'UJROHREINS'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'% Ujroh Fee for Reinsured/Cedant  (0 : Not Apply)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'AISOURCE', @level2type=N'COLUMN',@level2name=N'UJROHCEDANT'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Limit Of Liability' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'AISOURCE', @level2type=N'COLUMN',@level2name=N'Limit'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'In Excess Limit' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'AISOURCE', @level2type=N'COLUMN',@level2name=N'Excess'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Binder Warranty (in Days)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'AISOURCE', @level2type=N'COLUMN',@level2name=N'BinderWarranty'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Ceding Profile ID (if Insurance Source ID is not a Ceding Company)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'AISOURCE', @level2type=N'COLUMN',@level2name=N'CedingID'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'VAT Inward ; VAT Charged to Member' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'AISOURCE', @level2type=N'COLUMN',@level2name=N'VAT'
GO





/****** Object:  Table [dbo].[AISOURCEDET]    Script Date: 6/23/2026 10:10:58 PM ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[AISOURCEDET]') AND type in (N'U'))
DROP TABLE [dbo].[AISOURCEDET]
GO

/****** Object:  Table [dbo].[AISOURCEDET]    Script Date: 6/23/2026 10:10:58 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[AISOURCEDET](
	[ANO] [int] NOT NULL,
	[Code] [varchar](20) NOT NULL,
	[FEE] [float] NULL,
	[HF] [float] NULL,
 CONSTRAINT [I_AISOURCEDET] PRIMARY KEY CLUSTERED 
(
	[ANO] ASC,
	[Code] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO

ALTER TABLE [dbo].[AISOURCEDET] SET (LOCK_ESCALATION = DISABLE)
GO

ALTER TABLE [dbo].[AISOURCEDET]  WITH NOCHECK ADD  CONSTRAINT [FK_AISOURCEDET_AISOURCE] FOREIGN KEY([ANO])
REFERENCES [dbo].[AISOURCE] ([ANO])
ON UPDATE CASCADE
ON DELETE CASCADE
GO

ALTER TABLE [dbo].[AISOURCEDET] CHECK CONSTRAINT [FK_AISOURCEDET_AISOURCE]
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Cover No (see Cover)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'AISOURCEDET', @level2type=N'COLUMN',@level2name=N'ANO'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Rate Code (see RateTab)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'AISOURCEDET', @level2type=N'COLUMN',@level2name=N'Code'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'% Commision' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'AISOURCEDET', @level2type=N'COLUMN',@level2name=N'FEE'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'% Handling Fee' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'AISOURCEDET', @level2type=N'COLUMN',@level2name=N'HF'
GO

GO

DROP Procedure Drop_Acceptance_Link
GO
Create Procedure Drop_Acceptance_Link(@P_ANO as Int)        
AS         
Delete from RCALC Where ANO=@P_ANO        
Delete from AccDocStat Where ANO=@P_ANO        
Delete from AccSurplus Where ANO=@P_ANO        
Delete from ICalc Where ANO=@P_ANO        
Delete from AINFO Where ANO=@P_ANO        
Delete from AINFO_EXT Where ANO=@P_ANO      
Delete from AAccBS Where ANO=@P_ANO        
Delete from ACCDED Where ANO=@P_ANO        
Delete from ACCBS Where ANO=@P_ANO        
Delete from ACCASS Where ANO=@P_ANO        
Delete from ACCCON Where ANO=@P_ANO        
Delete from ACCPIC Where ANO=@P_ANO        
Delete from PCALC Where ANO=@P_ANO        
Delete from BusinessResult Where ANO=@P_ANO        
Delete from ACCEX Where ANO=@P_ANO        
Delete from RCOVER Where ANO=@P_ANO        
Delete from AccCA Where ANO=@P_ANO        
Delete from AccDA Where ANO=@P_ANO        
Delete from AccSgn Where ANO=@P_ANO        
Delete from ACCCLA Where ANO=@P_ANO        
Delete from ACCCOMPSHEETH Where ANO=@P_ANO        
Delete from ICOVER Where ANO=@P_ANO        
Delete from ACCSECTION Where ANO=@P_ANO        
Delete from ACCFD Where ANO=@P_ANO        
Delete from RARRHEADER Where ANO=@P_ANO        
Delete from ACCDEPOSIT Where ANO=@P_ANO        
Delete from PPrintLog Where ANO=@P_ANO        
Delete from RARRDET Where ANO=@P_ANO        
Delete from ACCSEARCH Where ANO=@P_ANO        
Delete from ACCDOCLIST Where ANO=@P_ANO        
Delete from ACCDOCLISTPIC Where ANO=@P_ANO        
Delete from PAYOR Where ANO=@P_ANO        
Delete from ACCCOLLATERAL Where ANO=@P_ANO        
Delete from APayor Where ANO=@P_ANO        
Delete from AccCard Where ANO=@P_ANO        
Delete from ACCEMPCONTH Where ANO=@P_ANO           
Delete from PNOTIFY Where ANO=@P_ANO          
Delete from PAYOR_SCHEDULE Where ANO=@P_ANO           
Delete from ACCDISCOUNT Where ANO=@P_ANO           
Delete from ACCCNC Where ANO=@P_ANO       
Delete from PNOTES Where ANO=@P_ANO       
Delete from ICOVERPOL Where ANO=@P_ANO       
Delete from ClaimPaymentSchedule Where ANO=@P_ANO       
Delete from AinfoDet Where ANO=@P_ANO       
Delete from AinfoDetPIC Where ANO=@P_ANO       
Delete from ABeneficiaries Where ANO=@P_ANO       
Delete from AInParty Where ANO=@P_ANO       
Delete from AISourceDet Where ANO=@P_ANO       
Delete from AISource Where ANO=@P_ANO       

    
  
  