SET QUOTED_IDENTIFIER ON
SET ARITHABORT ON
SET NUMERIC_ROUNDABORT OFF
SET CONCAT_NULL_YIELDS_NULL ON
SET ANSI_NULLS ON
SET ANSI_PADDING ON
SET ANSI_WARNINGS ON

IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'RefDate' AND Object_ID = Object_ID(N'dbo.Service'))
BEGIN
ALTER TABLE dbo.Service ADD RefDate Smalldatetime
END
GO

IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'NeedFacultativeF' AND Object_ID = Object_ID(N'dbo.Service'))
BEGIN
ALTER TABLE dbo.Service ADD NeedFacultativeF bit
END
GO

IF  NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'SCOINSURANCE') AND type in (N'U'))
begin
CREATE TABLE [dbo].[SCOINSURANCE](
	[SNO] [int] NOT NULL,
	[ID] [varchar](10) NOT NULL,
	[SHARE] [float] NULL,
	[USERID] [varchar](50) NULL,
	[CDATE] [smalldatetime] NULL,
	[LUserID] [varchar](50) NULL,
	[LDate] [smalldatetime] NULL
 CONSTRAINT [i_SCOINSURANCE] PRIMARY KEY NONCLUSTERED 
(
	[SNO] ASC,
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = OFF) ON [PRIMARY]
) ON [PRIMARY]
END
GO

ALTER TABLE [dbo].[SCOINSURANCE] SET (LOCK_ESCALATION = DISABLE)
GO

ALTER TABLE [dbo].[SCOINSURANCE]  WITH CHECK ADD  CONSTRAINT [FK_SCOINSURANCE_PROFILE] FOREIGN KEY([ID])
REFERENCES [dbo].[Profile] ([ID])
Go
ALTER TABLE [dbo].[SCOINSURANCE] CHECK CONSTRAINT [FK_SCOINSURANCE_PROFILE]
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Service No. (see Service)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'SCOINSURANCE', @level2type=N'COLUMN',@level2name=N'SNO'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Coinsurance Profile ID' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'SCOINSURANCE', @level2type=N'COLUMN',@level2name=N'ID'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'% Member Share' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'SCOINSURANCE', @level2type=N'COLUMN',@level2name=N'SHARE'
GO


IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'USERID' AND Object_ID = Object_ID(N'dbo.Coinsurance'))
BEGIN
ALTER TABLE dbo.Coinsurance ADD [USERID] [varchar](50) NULL
END
GO

IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'CDATE' AND Object_ID = Object_ID(N'dbo.Coinsurance'))
BEGIN
ALTER TABLE dbo.Coinsurance ADD [CDATE] [smalldatetime] NULL
END
GO

IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'LUserID' AND Object_ID = Object_ID(N'dbo.Coinsurance'))
BEGIN
ALTER TABLE dbo.Coinsurance ADD [LUserID] [varchar](50) NULL
END
GO

IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'LDate' AND Object_ID = Object_ID(N'dbo.Coinsurance'))
BEGIN
ALTER TABLE dbo.Coinsurance ADD [LDate] [smalldatetime] NULL
END
GO

--Servicing Facultative

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

IF  NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'SRARRDET') AND type in (N'U'))
begin
CREATE TABLE [dbo].[SRARRDET](
	[SNO] [int] NOT NULL,
	[FID] [varchar](20) NOT NULL,
	[RTYPE] [varchar](2) NULL,
	[STATUS] [varchar](1) NULL,
	[ATYPE] [varchar](30) NULL,
	[SDATE] [smalldatetime] NULL,
	[EDATE] [smalldatetime] NULL,
	[SHARE] [float] NULL,
	[AMOUNT] [float] NULL,
	[PCALC] [varchar](1) NULL,
	[USERID] [varchar](50) NULL,
	[CDATE] [smalldatetime] NULL,
	[LUserID] [varchar](50) NULL,
	[AUserID] [varchar](50) NULL,
	[AUserDate] [smalldatetime] NULL,
	[LDate] [smalldatetime] NULL,
	[AcceptedBy] [varchar](100) NULL,
	[AcceptedDate] [smalldatetime] NULL,
	[SysUserID] [varchar](50) NULL
) ON [PRIMARY] 
END
GO

ALTER TABLE [dbo].[SRARRDET] SET (LOCK_ESCALATION = DISABLE)
GO

CREATE UNIQUE NONCLUSTERED INDEX [I_SRARRDET] ON [dbo].[SRARRDET]
(
	[SNO] ASC,
	[FID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = OFF) ON [PRIMARY]
GO

CREATE NONCLUSTERED INDEX [I_SRARRDET_SNO] ON [dbo].[SRARRDET]
(
	[SNO] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = OFF) ON [PRIMARY]
GO
ALTER TABLE [dbo].[SRARRDET]  WITH CHECK ADD  CONSTRAINT [FK_SRARRDET_Service] FOREIGN KEY([SNO])
REFERENCES [dbo].[Service] ([SNO])
ON UPDATE CASCADE
ON DELETE CASCADE
GO

ALTER TABLE [dbo].[SRARRDET] CHECK CONSTRAINT [FK_SRARRDET_Service]
GO



SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

IF  NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'SFPART') AND type in (N'U'))
begin
CREATE TABLE [dbo].[SFPART](
	[SNO] [int] NOT NULL,
	[FID] [varchar](20) NOT NULL,
	[ID] [varchar](10) NOT NULL,
	[SHARE] [float] NULL,
	[SLIPNO] [varchar](50) NOT NULL,
	[WPC] [int] NULL,
	[Grace] [int] NULL,
 CONSTRAINT [I_SFPART] PRIMARY KEY NONCLUSTERED 
(
	[SNO] ASC,
	[FID] ASC,
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = OFF) ON [PRIMARY]
) ON [PRIMARY] 
End
GO

ALTER TABLE [dbo].[SFPART] SET (LOCK_ESCALATION = DISABLE)
GO

CREATE UNIQUE NONCLUSTERED INDEX [I_SFPART_SNO_SlipNo_ID] ON [dbo].SFPART
(
	[SNO] ASC,
	[SLIPNO] ASC,
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = OFF) ON [PRIMARY]
GO



ALTER TABLE [dbo].SFPART  WITH CHECK ADD  CONSTRAINT [FK_SFPART_Profile] FOREIGN KEY([ID])
REFERENCES [dbo].[Profile] ([ID])
GO

ALTER TABLE [dbo].SFPART CHECK CONSTRAINT [FK_SFPART_Profile]
GO



ALTER TABLE [dbo].SFPART  WITH CHECK ADD  CONSTRAINT [FK_SFPART_SRARRDET] FOREIGN KEY([SNO], [FID])
REFERENCES [dbo].[SRARRDET] ([SNO], [FID])
ON UPDATE CASCADE
ON DELETE CASCADE
GO

ALTER TABLE [dbo].SFPART CHECK CONSTRAINT [FK_SFPart_SRARRDET]
GO


--Servicing Additional Info 

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

IF  NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'SUINFO') AND type in (N'U'))
begin
CREATE TABLE [dbo].SUINFO(
	[SNO] [int] NOT NULL,
	[FLDID1] [varchar](10) NULL,
	[VALUEID1] [varchar](15) NULL,
	[VALUEDESC1] [varchar](max) NULL,
	[FLDID2] [varchar](10) NULL,
	[VALUEID2] [varchar](15) NULL,
	[VALUEDESC2] [varchar](max) NULL,
	[FLDID3] [varchar](10) NULL,
	[VALUEID3] [varchar](15) NULL,
	[VALUEDESC3] [varchar](max) NULL,
	[FLDID4] [varchar](10) NULL,
	[VALUEID4] [varchar](15) NULL,
	[VALUEDESC4] [varchar](max) NULL,
	[FLDID5] [varchar](10) NULL,
	[VALUEID5] [varchar](15) NULL,
	[VALUEDESC5] [varchar](max) NULL,
	[FLDID6] [varchar](10) NULL,
	[VALUEID6] [varchar](15) NULL,
	[VALUEDESC6] [varchar](max) NULL,
	[FLDID7] [varchar](10) NULL,
	[VALUEID7] [varchar](15) NULL,
	[VALUEDESC7] [varchar](max) NULL,
	[FLDID8] [varchar](10) NULL,
	[VALUEID8] [varchar](15) NULL,
	[VALUEDESC8] [varchar](max) NULL,
	[FLDID9] [varchar](10) NULL,
	[VALUEID9] [varchar](15) NULL,
	[VALUEDESC9] [varchar](max) NULL,
	[FLDID10] [varchar](10) NULL,
	[VALUEID10] [varchar](15) NULL,
	[VALUEDESC10] [varchar](max) NULL,
	[FLDID11] [varchar](10) NULL,
	[VALUEID11] [varchar](15) NULL,
	[VALUEDESC11] [varchar](max) NULL,
	[FLDID12] [varchar](10) NULL,
	[VALUEID12] [varchar](15) NULL,
	[VALUEDESC12] [varchar](max) NULL,
	[FLDID13] [varchar](10) NULL,
	[VALUEID13] [varchar](15) NULL,
	[VALUEDESC13] [varchar](max) NULL,
	[FLDID14] [varchar](10) NULL,
	[VALUEID14] [varchar](15) NULL,
	[VALUEDESC14] [varchar](max) NULL,
	[FLDID15] [varchar](10) NULL,
	[VALUEID15] [varchar](15) NULL,
	[VALUEDESC15] [varchar](max) NULL,
 CONSTRAINT [i_SUINFO] PRIMARY KEY NONCLUSTERED 
(
	[SNO] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = OFF) ON [PRIMARY]
) ON [PRIMARY]
END 
GO

ALTER TABLE [dbo].SUINFO SET (LOCK_ESCALATION = DISABLE)
GO

ALTER TABLE [dbo].SUINFO  WITH CHECK ADD  CONSTRAINT [FK_SUINFO_Service] FOREIGN KEY([SNO])
REFERENCES [dbo].[Service] ([SNO])
ON UPDATE CASCADE
ON DELETE CASCADE
GO

ALTER TABLE [dbo].SUINFO CHECK CONSTRAINT [FK_SUINFO_Service]
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Field ID 1 (see GENHTAB)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'SUINFO', @level2type=N'COLUMN',@level2name=N'FLDID1'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Value ID 1 (see GenDTab)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'SUINFO', @level2type=N'COLUMN',@level2name=N'VALUEID1'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Value Desc 1' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'SUINFO', @level2type=N'COLUMN',@level2name=N'VALUEDESC1'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'-' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'SUINFO', @level2type=N'COLUMN',@level2name=N'FLDID2'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'-' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'SUINFO', @level2type=N'COLUMN',@level2name=N'VALUEID2'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'-' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'SUINFO', @level2type=N'COLUMN',@level2name=N'VALUEDESC2'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'-' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'SUINFO', @level2type=N'COLUMN',@level2name=N'FLDID3'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'-' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'SUINFO', @level2type=N'COLUMN',@level2name=N'VALUEID3'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'-' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'SUINFO', @level2type=N'COLUMN',@level2name=N'VALUEDESC3'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'-' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'SUINFO', @level2type=N'COLUMN',@level2name=N'FLDID4'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'-' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'SUINFO', @level2type=N'COLUMN',@level2name=N'VALUEID4'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'-' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'SUINFO', @level2type=N'COLUMN',@level2name=N'VALUEDESC4'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'-' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'SUINFO', @level2type=N'COLUMN',@level2name=N'FLDID5'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'-' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'SUINFO', @level2type=N'COLUMN',@level2name=N'VALUEID5'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'-' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'SUINFO', @level2type=N'COLUMN',@level2name=N'VALUEDESC5'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'-' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'SUINFO', @level2type=N'COLUMN',@level2name=N'FLDID6'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'-' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'SUINFO', @level2type=N'COLUMN',@level2name=N'VALUEID6'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'-' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'SUINFO', @level2type=N'COLUMN',@level2name=N'VALUEDESC6'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'-' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'SUINFO', @level2type=N'COLUMN',@level2name=N'FLDID7'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'-' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'SUINFO', @level2type=N'COLUMN',@level2name=N'VALUEID7'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'-' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'SUINFO', @level2type=N'COLUMN',@level2name=N'VALUEDESC7'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'-' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'SUINFO', @level2type=N'COLUMN',@level2name=N'FLDID8'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'-' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'SUINFO', @level2type=N'COLUMN',@level2name=N'VALUEID8'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'-' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'SUINFO', @level2type=N'COLUMN',@level2name=N'VALUEDESC8'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'-' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'SUINFO', @level2type=N'COLUMN',@level2name=N'FLDID9'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'-' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'SUINFO', @level2type=N'COLUMN',@level2name=N'VALUEID9'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'-' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'SUINFO', @level2type=N'COLUMN',@level2name=N'VALUEDESC9'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'-' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'SUINFO', @level2type=N'COLUMN',@level2name=N'FLDID10'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'-' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'SUINFO', @level2type=N'COLUMN',@level2name=N'VALUEID10'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'-' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'SUINFO', @level2type=N'COLUMN',@level2name=N'VALUEDESC10'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'-' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'SUINFO', @level2type=N'COLUMN',@level2name=N'FLDID11'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'-' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'SUINFO', @level2type=N'COLUMN',@level2name=N'VALUEID11'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'-' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'SUINFO', @level2type=N'COLUMN',@level2name=N'VALUEDESC11'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'-' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'SUINFO', @level2type=N'COLUMN',@level2name=N'FLDID12'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'-' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'SUINFO', @level2type=N'COLUMN',@level2name=N'VALUEID12'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'-' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'SUINFO', @level2type=N'COLUMN',@level2name=N'VALUEDESC12'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'-' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'SUINFO', @level2type=N'COLUMN',@level2name=N'FLDID13'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'-' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'SUINFO', @level2type=N'COLUMN',@level2name=N'VALUEID13'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'-' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'SUINFO', @level2type=N'COLUMN',@level2name=N'VALUEDESC13'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'-' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'SUINFO', @level2type=N'COLUMN',@level2name=N'FLDID14'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'-' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'SUINFO', @level2type=N'COLUMN',@level2name=N'VALUEID14'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'-' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'SUINFO', @level2type=N'COLUMN',@level2name=N'VALUEDESC14'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'-' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'SUINFO', @level2type=N'COLUMN',@level2name=N'FLDID15'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'-' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'SUINFO', @level2type=N'COLUMN',@level2name=N'VALUEID15'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'-' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'SUINFO', @level2type=N'COLUMN',@level2name=N'VALUEDESC15'
GO




--QFacultative_DataServicing
IF EXISTS ( SELECT * FROM   sysobjects WHERE  id = object_id(N'QFacultative_DataServicing') and OBJECTPROPERTY(id, N'IsProcedure') = 1 )
BEGIN DROP PROCEDURE QFacultative_DataServicing END
GO

CREATE Procedure QFacultative_DataServicing(@P_SNO integer, @P_FID varchar(20))                    
AS                                  
SELECT R.FID, R.AType, F.SLIPNO, R.SDATE, R.EDATE, R.RTYPE, F.ID, R.SHARE, F.Share as RShare, R.AMOUNT,                    
R.UserID, R.CDate,                  
R.LUserID, R.LDate,                  
R.AUserID, R.AUserDate,            
R.AcceptedBy, R.AcceptedDate,    
R.SysUserID,         
R.PCALC, F.WPC,       
F.GRACE
FROM SRARRDET R
INNER JOIN SFPART F on (F.SNO=R.SNO AND F.FID=R.FID)
WHERE R.SNO=@P_SNO AND R.FID=@P_FID
GO

--QSRArrDet
IF EXISTS ( SELECT * FROM   sysobjects WHERE  id = object_id(N'QSRArrDet') and OBJECTPROPERTY(id, N'IsProcedure') = 1 )
BEGIN DROP PROCEDURE QSRArrDet END
GO

CREATE PROCEDURE [dbo].[QSRArrDet] (@P_SNO as integer, @P_FID as varchar(255)) 
AS
SELECT rarrdet.*
FROM SRARRDET rarrdet
WHERE SNO=@P_SNO and FID=@P_FID
GO

IF EXISTS ( SELECT * FROM   sysobjects WHERE  id = object_id(N'QFacultativeServicing_List') and OBJECTPROPERTY(id, N'IsProcedure') = 1 )
BEGIN DROP PROCEDURE QFacultativeServicing_List END
GO

Create Procedure QFacultativeServicing_List(@P_SNO int)
AS
SELECT Cast(0 as bit) as ProcessFlag, RArrDet.FID, RArrDet.Status, RArrDet.AType, RArrDet.RType, RArrDet.SDate, RArrDet.EDate, RArrDet.Share
, RArrDet.Amount,Profile.Name, FPart.SlipNo, FPart.ID, FPart.Share AS RShare,  FPart.WPC, 
FPart.Grace, RArrDet.AcceptedBy, RArrDet.AcceptedDate

From sRArrDet RArrDet
Inner Join SFPart FPart on (FPart.SNO=RArrDet.SNO And FPart.FID=RArrDet.FID)
Inner Join Profile on (Profile.ID=FPart.ID)
WHERE RArrDet.SNO=@P_SNO
Order By RArrDet.FID
go

IF EXISTS ( SELECT * FROM   sysobjects WHERE  id = object_id(N'qServicing_Data') and OBJECTPROPERTY(id, N'IsProcedure') = 1 )
BEGIN DROP PROCEDURE qServicing_Data END
GO

CREATE Procedure qServicing_Data(@P_SNO integer) 
AS 
Select S1.SNO, S1.ServiceNo, S1.ServiceDate, S1.SType, S1.Subject, S1.ServiceInfo, S1.Validation, 
S1.PolicyNo, S1.CertificateNo, S1.RefNo, S1.ClaimNo, S1.TOC, S1.TopRO, S1.CoverDate, S1.ExpDate, S1.PID, S1.Name, S1.Address_1, S1.Address_2, S1.Phone_1, S1.Fax_1,S1.PType,S1.CGroup, S1.Area, S1.AID, S1.Insured, 
S1.MO, S1.Segment, S1.Branch, S1.CT, S1.ISType, S1.PolicyType, S1.Code, S1.Coverage, S1.Currency, S1.TSI, S1.ATSI, S1.Rate, S1.Premium, S1.SStatus, S1.BSID, S1.BSName, S1.BSType, S1.TBAF, 
S1.UserID, S1.CDate, S1.CTime, 
S1.LUserID, S1.LDate, S1.LTime, 
S1.CUserID, S1.CloseDate, S1.CloseTime, 
S1.PUserID, S1.PUserDate, S1.PUserTime, 
S1.RUserID, S1.RUserDate, S1.RUserTime, 
S1.AUserID, S1.AUserDate, S1.AUserTime, 
S1.PANO, S1.ANO, S1.LANO, S1.CNO, S1.PSNO, S1.VSeqNo, S1.Remarks, S1.ASource, S1.RegID, S1.FLDID, S1.ValueID, S1.ValueDesc, S1.InfoF, S1.SurveyF, S1.Priority, S1.RequestF, S1.RequestMessage, S1.RequestName, 
S1.STime, S1.ETime, S1.CedingID , S1.CedingShare , 
S1.PIC_TITLE_1, S1.PIC_NAME_1, 
S1.PIC_TITLE_2, S1.PIC_NAME_2, 
S1.PIC_TITLE_3, S1.PIC_NAME_3, 
S1.PrivilegeType,
S1.HOMEPAGE, 
S1.RefDate,
S1.NeedFacultativeF,
S2.FLDID1, S2.VALUEID1, S2.VALUEDESC1, 0 as FLDSEARCH1, 
S2.FLDID2, S2.VALUEID2, S2.VALUEDESC2, 0 as FLDSEARCH2, 
S2.FLDID3, S2.VALUEID3, S2.VALUEDESC3, 0 as FLDSEARCH3, 
S2.FLDID4, S2.VALUEID4, S2.VALUEDESC4, 0 as FLDSEARCH4, 
S2.FLDID5, S2.VALUEID5, S2.VALUEDESC5, 0 as FLDSEARCH5, 
S2.FLDID6, S2.VALUEID6, S2.VALUEDESC6, 0 as FLDSEARCH6, 
S2.FLDID7, S2.VALUEID7, S2.VALUEDESC7, 0 as FLDSEARCH7, 
S2.FLDID8, S2.VALUEID8, S2.VALUEDESC8, 0 as FLDSEARCH8, 
S2.FLDID9, S2.VALUEID9, S2.VALUEDESC9, 0 as FLDSEARCH9, 
S2.FLDID10, S2.VALUEID10, S2.VALUEDESC10, 0 as FLDSEARCH10, 
S2.FLDID11, S2.VALUEID11, S2.VALUEDESC11, 0 as FLDSEARCH11, 
S2.FLDID12, S2.VALUEID12, S2.VALUEDESC12, 0 as FLDSEARCH12, 
S2.FLDID13, S2.VALUEID13, S2.VALUEDESC13, 0 as FLDSEARCH13, 
S2.FLDID14, S2.VALUEID14, S2.VALUEDESC14, 0 as FLDSEARCH14, 
S2.FLDID15, S2.VALUEID15, S2.VALUEDESC15, 0 as FLDSEARCH15 
from Service S1 Left Join SInfo S2 on (S2.SNO=S1.SNO) 
Where S1.SNO=@P_SNO 
go

insert into PatchVersioning
select '1342 Update Script Service May 2025',GETDATE()
go	
  

Declare @PrevScript varchar(100)
Declare @CurrScript varchar(100)

Select @PrevScript=''
Select @CurrSCript='1342 Update Script Service May 2025'


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