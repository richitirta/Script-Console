/****** Object:  Table [dbo].[IFRS_Calculation_Detail_PAA]    Script Date: 11/8/2023 12:00:09 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

SET ANSI_PADDING OFF
GO

CREATE TABLE [dbo].[IFRS_Calculation_Detail_PAA](
	[GroupID] [int] NOT NULL,
	[GroupType] [varchar](1) NOT NULL,
	[PAA_Start_1] [float] NULL,
	[PAA_Start_2] [float] NULL,
	[PAA_Start_3] [float] NULL,
	[PAA_Start_4] [float] NULL,
	[PAA_Start_5] [float] NULL,
	[PAA_Start_6] [float] NULL,
	[PAA_Start_7] [float] NULL,
	[PAA_Start_8] [float] NULL,
	[PAA_Start_9] [float] NULL,
	[PAA_Start_10] [float] NULL,
	[PAA_Start_11] [float] NULL,
	[PAA_Start_12] [float] NULL,
	[PAA_Start_13] [float] NULL,
	[PAA_Start_14] [float] NULL,
	[PAA_Start_15] [float] NULL,
	[PAA_Start_16] [float] NULL,
	[PAA_Start_17] [float] NULL,
	[PAA_Start_18] [float] NULL,
	[PAA_Start_19] [float] NULL,
	[PAA_Start_20] [float] NULL,
	[PAA_Start_21] [float] NULL,
	[PAA_Start_22] [float] NULL,
	[PAA_Start_23] [float] NULL,
	[PAA_Start_24] [float] NULL,
	[PAA_Start_25] [float] NULL,
	[PAA_Start_26] [float] NULL,
	[PAA_Start_27] [float] NULL,
	[PAA_Start_28] [float] NULL,
	[PAA_Start_29] [float] NULL,
	[PAA_Start_30] [float] NULL,
	[PAA_Interest_Accrete_1] [float] NULL,
	[PAA_Interest_Accrete_2] [float] NULL,
	[PAA_Interest_Accrete_3] [float] NULL,
	[PAA_Interest_Accrete_4] [float] NULL,
	[PAA_Interest_Accrete_5] [float] NULL,
	[PAA_Interest_Accrete_6] [float] NULL,
	[PAA_Interest_Accrete_7] [float] NULL,
	[PAA_Interest_Accrete_8] [float] NULL,
	[PAA_Interest_Accrete_9] [float] NULL,
	[PAA_Interest_Accrete_10] [float] NULL,
	[PAA_Interest_Accrete_11] [float] NULL,
	[PAA_Interest_Accrete_12] [float] NULL,
	[PAA_Interest_Accrete_13] [float] NULL,
	[PAA_Interest_Accrete_14] [float] NULL,
	[PAA_Interest_Accrete_15] [float] NULL,
	[PAA_Interest_Accrete_16] [float] NULL,
	[PAA_Interest_Accrete_17] [float] NULL,
	[PAA_Interest_Accrete_18] [float] NULL,
	[PAA_Interest_Accrete_19] [float] NULL,
	[PAA_Interest_Accrete_20] [float] NULL,
	[PAA_Interest_Accrete_21] [float] NULL,
	[PAA_Interest_Accrete_22] [float] NULL,
	[PAA_Interest_Accrete_23] [float] NULL,
	[PAA_Interest_Accrete_24] [float] NULL,
	[PAA_Interest_Accrete_25] [float] NULL,
	[PAA_Interest_Accrete_26] [float] NULL,
	[PAA_Interest_Accrete_27] [float] NULL,
	[PAA_Interest_Accrete_28] [float] NULL,
	[PAA_Interest_Accrete_29] [float] NULL,
	[PAA_Interest_Accrete_30] [float] NULL,
	[PAA_End_1] [float] NULL,
	[PAA_End_2] [float] NULL,
	[PAA_End_3] [float] NULL,
	[PAA_End_4] [float] NULL,
	[PAA_End_5] [float] NULL,
	[PAA_End_6] [float] NULL,
	[PAA_End_7] [float] NULL,
	[PAA_End_8] [float] NULL,
	[PAA_End_9] [float] NULL,
	[PAA_End_10] [float] NULL,
	[PAA_End_11] [float] NULL,
	[PAA_End_12] [float] NULL,
	[PAA_End_13] [float] NULL,
	[PAA_End_14] [float] NULL,
	[PAA_End_15] [float] NULL,
	[PAA_End_16] [float] NULL,
	[PAA_End_17] [float] NULL,
	[PAA_End_18] [float] NULL,
	[PAA_End_19] [float] NULL,
	[PAA_End_20] [float] NULL,
	[PAA_End_21] [float] NULL,
	[PAA_End_22] [float] NULL,
	[PAA_End_23] [float] NULL,
	[PAA_End_24] [float] NULL,
	[PAA_End_25] [float] NULL,
	[PAA_End_26] [float] NULL,
	[PAA_End_27] [float] NULL,
	[PAA_End_28] [float] NULL,
	[PAA_End_29] [float] NULL,
	[PAA_End_30] [float] NULL,
	[PAA_Amortization_1] [float] NULL,
	[PAA_Amortization_2] [float] NULL,
	[PAA_Amortization_3] [float] NULL,
	[PAA_Amortization_4] [float] NULL,
	[PAA_Amortization_5] [float] NULL,
	[PAA_Amortization_6] [float] NULL,
	[PAA_Amortization_7] [float] NULL,
	[PAA_Amortization_8] [float] NULL,
	[PAA_Amortization_9] [float] NULL,
	[PAA_Amortization_10] [float] NULL,
	[PAA_Amortization_11] [float] NULL,
	[PAA_Amortization_12] [float] NULL,
	[PAA_Amortization_13] [float] NULL,
	[PAA_Amortization_14] [float] NULL,
	[PAA_Amortization_15] [float] NULL,
	[PAA_Amortization_16] [float] NULL,
	[PAA_Amortization_17] [float] NULL,
	[PAA_Amortization_18] [float] NULL,
	[PAA_Amortization_19] [float] NULL,
	[PAA_Amortization_20] [float] NULL,
	[PAA_Amortization_21] [float] NULL,
	[PAA_Amortization_22] [float] NULL,
	[PAA_Amortization_23] [float] NULL,
	[PAA_Amortization_24] [float] NULL,
	[PAA_Amortization_25] [float] NULL,
	[PAA_Amortization_26] [float] NULL,
	[PAA_Amortization_27] [float] NULL,
	[PAA_Amortization_28] [float] NULL,
	[PAA_Amortization_29] [float] NULL,
	[PAA_Amortization_30] [float] NULL,
	[EffMonth] [int] NOT NULL,
	[EffYear] [int] NOT NULL,
 CONSTRAINT [I_IFRS_Calculation_Detail_PAA] PRIMARY KEY CLUSTERED 
(
	[GroupID] ASC,
	[GroupType] ASC,
	[EffYear] ASC,
	[EffMonth] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO

SET ANSI_PADDING OFF
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Effective Month' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'IFRS_Calculation_Detail_PAA', @level2type=N'COLUMN',@level2name=N'EffMonth'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Effective Year' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'IFRS_Calculation_Detail_PAA', @level2type=N'COLUMN',@level2name=N'EffYear'
GO


/****** Object:  Table [dbo].[IFRS_Initial_Detail_PAA]    Script Date: 11/8/2023 12:01:19 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

SET ANSI_PADDING OFF
GO

CREATE TABLE [dbo].[IFRS_Initial_Detail_PAA](
	[DataID] [int] NOT NULL,
	[GroupType] [varchar](1) NOT NULL,
	[PAA_Start_1] [float] NULL,
	[PAA_Start_2] [float] NULL,
	[PAA_Start_3] [float] NULL,
	[PAA_Start_4] [float] NULL,
	[PAA_Start_5] [float] NULL,
	[PAA_Start_6] [float] NULL,
	[PAA_Start_7] [float] NULL,
	[PAA_Start_8] [float] NULL,
	[PAA_Start_9] [float] NULL,
	[PAA_Start_10] [float] NULL,
	[PAA_Start_11] [float] NULL,
	[PAA_Start_12] [float] NULL,
	[PAA_Start_13] [float] NULL,
	[PAA_Start_14] [float] NULL,
	[PAA_Start_15] [float] NULL,
	[PAA_Start_16] [float] NULL,
	[PAA_Start_17] [float] NULL,
	[PAA_Start_18] [float] NULL,
	[PAA_Start_19] [float] NULL,
	[PAA_Start_20] [float] NULL,
	[PAA_Start_21] [float] NULL,
	[PAA_Start_22] [float] NULL,
	[PAA_Start_23] [float] NULL,
	[PAA_Start_24] [float] NULL,
	[PAA_Start_25] [float] NULL,
	[PAA_Start_26] [float] NULL,
	[PAA_Start_27] [float] NULL,
	[PAA_Start_28] [float] NULL,
	[PAA_Start_29] [float] NULL,
	[PAA_Start_30] [float] NULL,
	[PAA_Interest_Accrete_1] [float] NULL,
	[PAA_Interest_Accrete_2] [float] NULL,
	[PAA_Interest_Accrete_3] [float] NULL,
	[PAA_Interest_Accrete_4] [float] NULL,
	[PAA_Interest_Accrete_5] [float] NULL,
	[PAA_Interest_Accrete_6] [float] NULL,
	[PAA_Interest_Accrete_7] [float] NULL,
	[PAA_Interest_Accrete_8] [float] NULL,
	[PAA_Interest_Accrete_9] [float] NULL,
	[PAA_Interest_Accrete_10] [float] NULL,
	[PAA_Interest_Accrete_11] [float] NULL,
	[PAA_Interest_Accrete_12] [float] NULL,
	[PAA_Interest_Accrete_13] [float] NULL,
	[PAA_Interest_Accrete_14] [float] NULL,
	[PAA_Interest_Accrete_15] [float] NULL,
	[PAA_Interest_Accrete_16] [float] NULL,
	[PAA_Interest_Accrete_17] [float] NULL,
	[PAA_Interest_Accrete_18] [float] NULL,
	[PAA_Interest_Accrete_19] [float] NULL,
	[PAA_Interest_Accrete_20] [float] NULL,
	[PAA_Interest_Accrete_21] [float] NULL,
	[PAA_Interest_Accrete_22] [float] NULL,
	[PAA_Interest_Accrete_23] [float] NULL,
	[PAA_Interest_Accrete_24] [float] NULL,
	[PAA_Interest_Accrete_25] [float] NULL,
	[PAA_Interest_Accrete_26] [float] NULL,
	[PAA_Interest_Accrete_27] [float] NULL,
	[PAA_Interest_Accrete_28] [float] NULL,
	[PAA_Interest_Accrete_29] [float] NULL,
	[PAA_Interest_Accrete_30] [float] NULL,
	[PAA_End_1] [float] NULL,
	[PAA_End_2] [float] NULL,
	[PAA_End_3] [float] NULL,
	[PAA_End_4] [float] NULL,
	[PAA_End_5] [float] NULL,
	[PAA_End_6] [float] NULL,
	[PAA_End_7] [float] NULL,
	[PAA_End_8] [float] NULL,
	[PAA_End_9] [float] NULL,
	[PAA_End_10] [float] NULL,
	[PAA_End_11] [float] NULL,
	[PAA_End_12] [float] NULL,
	[PAA_End_13] [float] NULL,
	[PAA_End_14] [float] NULL,
	[PAA_End_15] [float] NULL,
	[PAA_End_16] [float] NULL,
	[PAA_End_17] [float] NULL,
	[PAA_End_18] [float] NULL,
	[PAA_End_19] [float] NULL,
	[PAA_End_20] [float] NULL,
	[PAA_End_21] [float] NULL,
	[PAA_End_22] [float] NULL,
	[PAA_End_23] [float] NULL,
	[PAA_End_24] [float] NULL,
	[PAA_End_25] [float] NULL,
	[PAA_End_26] [float] NULL,
	[PAA_End_27] [float] NULL,
	[PAA_End_28] [float] NULL,
	[PAA_End_29] [float] NULL,
	[PAA_End_30] [float] NULL,
	[PAA_Amortization_1] [float] NULL,
	[PAA_Amortization_2] [float] NULL,
	[PAA_Amortization_3] [float] NULL,
	[PAA_Amortization_4] [float] NULL,
	[PAA_Amortization_5] [float] NULL,
	[PAA_Amortization_6] [float] NULL,
	[PAA_Amortization_7] [float] NULL,
	[PAA_Amortization_8] [float] NULL,
	[PAA_Amortization_9] [float] NULL,
	[PAA_Amortization_10] [float] NULL,
	[PAA_Amortization_11] [float] NULL,
	[PAA_Amortization_12] [float] NULL,
	[PAA_Amortization_13] [float] NULL,
	[PAA_Amortization_14] [float] NULL,
	[PAA_Amortization_15] [float] NULL,
	[PAA_Amortization_16] [float] NULL,
	[PAA_Amortization_17] [float] NULL,
	[PAA_Amortization_18] [float] NULL,
	[PAA_Amortization_19] [float] NULL,
	[PAA_Amortization_20] [float] NULL,
	[PAA_Amortization_21] [float] NULL,
	[PAA_Amortization_22] [float] NULL,
	[PAA_Amortization_23] [float] NULL,
	[PAA_Amortization_24] [float] NULL,
	[PAA_Amortization_25] [float] NULL,
	[PAA_Amortization_26] [float] NULL,
	[PAA_Amortization_27] [float] NULL,
	[PAA_Amortization_28] [float] NULL,
	[PAA_Amortization_29] [float] NULL,
	[PAA_Amortization_30] [float] NULL,
 CONSTRAINT [I_IFRS_Initial_Detail_PAA] PRIMARY KEY CLUSTERED 
(
	[DataID] ASC,
	[GroupType] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO

SET ANSI_PADDING OFF
GO



IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'PAA_Premium_Expected' AND Object_ID = Object_ID(N'IFRS_Movement'))
BEGIN
ALTER TABLE IFRS_Movement ADD PAA_Premium_Expected float(53) NULL
END
GO
IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'PAA_Commission_Expected' AND Object_ID = Object_ID(N'IFRS_Movement'))
BEGIN
ALTER TABLE IFRS_Movement ADD PAA_Commission_Expected float(53) NULL
END
GO
IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'PAA_Interest_Accrete' AND Object_ID = Object_ID(N'IFRS_Movement'))
BEGIN
ALTER TABLE IFRS_Movement ADD PAA_Interest_Accrete float(53) NULL
END
GO
IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'PAA_Amortization' AND Object_ID = Object_ID(N'IFRS_Movement'))
BEGIN
ALTER TABLE IFRS_Movement ADD PAA_Amortization float(53) NULL
END
GO

IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'BEL_Others_Expected_1' AND Object_ID = Object_ID(N'IFRS_Calculation_Detail_BEL'))
BEGIN
ALTER TABLE IFRS_Calculation_Detail_BEL ADD BEL_Others_Expected_1 float(53) NULL
END
GO
IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'BEL_Others_Expected_2' AND Object_ID = Object_ID(N'IFRS_Calculation_Detail_BEL'))
BEGIN
ALTER TABLE IFRS_Calculation_Detail_BEL ADD BEL_Others_Expected_2 float(53) NULL
END
GO
IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'BEL_Others_Expected_3' AND Object_ID = Object_ID(N'IFRS_Calculation_Detail_BEL'))
BEGIN
ALTER TABLE IFRS_Calculation_Detail_BEL ADD BEL_Others_Expected_3 float(53) NULL
END
GO
IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'BEL_Others_Expected_4' AND Object_ID = Object_ID(N'IFRS_Calculation_Detail_BEL'))
BEGIN
ALTER TABLE IFRS_Calculation_Detail_BEL ADD BEL_Others_Expected_4 float(53) NULL
END
GO
IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'BEL_Others_Expected_5' AND Object_ID = Object_ID(N'IFRS_Calculation_Detail_BEL'))
BEGIN
ALTER TABLE IFRS_Calculation_Detail_BEL ADD BEL_Others_Expected_5 float(53) NULL
END
GO
IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'BEL_Others_Expected_6' AND Object_ID = Object_ID(N'IFRS_Calculation_Detail_BEL'))
BEGIN
ALTER TABLE IFRS_Calculation_Detail_BEL ADD BEL_Others_Expected_6 float(53) NULL
END
GO
IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'BEL_Others_Expected_7' AND Object_ID = Object_ID(N'IFRS_Calculation_Detail_BEL'))
BEGIN
ALTER TABLE IFRS_Calculation_Detail_BEL ADD BEL_Others_Expected_7 float(53) NULL
END
GO
IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'BEL_Others_Expected_8' AND Object_ID = Object_ID(N'IFRS_Calculation_Detail_BEL'))
BEGIN
ALTER TABLE IFRS_Calculation_Detail_BEL ADD BEL_Others_Expected_8 float(53) NULL
END
GO
IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'BEL_Others_Expected_9' AND Object_ID = Object_ID(N'IFRS_Calculation_Detail_BEL'))
BEGIN
ALTER TABLE IFRS_Calculation_Detail_BEL ADD BEL_Others_Expected_9 float(53) NULL
END
GO
IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'BEL_Others_Expected_10' AND Object_ID = Object_ID(N'IFRS_Calculation_Detail_BEL'))
BEGIN
ALTER TABLE IFRS_Calculation_Detail_BEL ADD BEL_Others_Expected_10 float(53) NULL
END
GO
IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'BEL_Others_Expected_11' AND Object_ID = Object_ID(N'IFRS_Calculation_Detail_BEL'))
BEGIN
ALTER TABLE IFRS_Calculation_Detail_BEL ADD BEL_Others_Expected_11 float(53) NULL
END
GO
IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'BEL_Others_Expected_12' AND Object_ID = Object_ID(N'IFRS_Calculation_Detail_BEL'))
BEGIN
ALTER TABLE IFRS_Calculation_Detail_BEL ADD BEL_Others_Expected_12 float(53) NULL
END
GO
IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'BEL_Others_Expected_13' AND Object_ID = Object_ID(N'IFRS_Calculation_Detail_BEL'))
BEGIN
ALTER TABLE IFRS_Calculation_Detail_BEL ADD BEL_Others_Expected_13 float(53) NULL
END
GO
IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'BEL_Others_Expected_14' AND Object_ID = Object_ID(N'IFRS_Calculation_Detail_BEL'))
BEGIN
ALTER TABLE IFRS_Calculation_Detail_BEL ADD BEL_Others_Expected_14 float(53) NULL
END
GO
IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'BEL_Others_Expected_15' AND Object_ID = Object_ID(N'IFRS_Calculation_Detail_BEL'))
BEGIN
ALTER TABLE IFRS_Calculation_Detail_BEL ADD BEL_Others_Expected_15 float(53) NULL
END
GO
IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'BEL_Others_Expected_16' AND Object_ID = Object_ID(N'IFRS_Calculation_Detail_BEL'))
BEGIN
ALTER TABLE IFRS_Calculation_Detail_BEL ADD BEL_Others_Expected_16 float(53) NULL
END
GO
IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'BEL_Others_Expected_17' AND Object_ID = Object_ID(N'IFRS_Calculation_Detail_BEL'))
BEGIN
ALTER TABLE IFRS_Calculation_Detail_BEL ADD BEL_Others_Expected_17 float(53) NULL
END
GO
IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'BEL_Others_Expected_18' AND Object_ID = Object_ID(N'IFRS_Calculation_Detail_BEL'))
BEGIN 
ALTER TABLE IFRS_Calculation_Detail_BEL ADD BEL_Others_Expected_18 float(53) NULL
END
GO
IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'BEL_Others_Expected_19' AND Object_ID = Object_ID(N'IFRS_Calculation_Detail_BEL'))
BEGIN
ALTER TABLE IFRS_Calculation_Detail_BEL ADD BEL_Others_Expected_19 float(53) NULL
END
GO
IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'BEL_Others_Expected_20' AND Object_ID = Object_ID(N'IFRS_Calculation_Detail_BEL'))
BEGIN
ALTER TABLE IFRS_Calculation_Detail_BEL ADD BEL_Others_Expected_20 float(53) NULL
END
GO
IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'BEL_Others_Expected_21' AND Object_ID = Object_ID(N'IFRS_Calculation_Detail_BEL'))
BEGIN
ALTER TABLE IFRS_Calculation_Detail_BEL ADD BEL_Others_Expected_21 float(53) NULL
END
GO
IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'BEL_Others_Expected_22' AND Object_ID = Object_ID(N'IFRS_Calculation_Detail_BEL'))
BEGIN
ALTER TABLE IFRS_Calculation_Detail_BEL ADD BEL_Others_Expected_22 float(53) NULL
END
GO
IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'BEL_Others_Expected_23' AND Object_ID = Object_ID(N'IFRS_Calculation_Detail_BEL'))
BEGIN
ALTER TABLE IFRS_Calculation_Detail_BEL ADD BEL_Others_Expected_23 float(53) NULL
END
GO
IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'BEL_Others_Expected_24' AND Object_ID = Object_ID(N'IFRS_Calculation_Detail_BEL'))
BEGIN
ALTER TABLE IFRS_Calculation_Detail_BEL ADD BEL_Others_Expected_24 float(53) NULL
END
GO
IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'BEL_Others_Expected_25' AND Object_ID = Object_ID(N'IFRS_Calculation_Detail_BEL'))
BEGIN
ALTER TABLE IFRS_Calculation_Detail_BEL ADD BEL_Others_Expected_25 float(53) NULL
END
GO
IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'BEL_Others_Expected_26' AND Object_ID = Object_ID(N'IFRS_Calculation_Detail_BEL'))
BEGIN
ALTER TABLE IFRS_Calculation_Detail_BEL ADD BEL_Others_Expected_26 float(53) NULL
END
GO
IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'BEL_Others_Expected_27' AND Object_ID = Object_ID(N'IFRS_Calculation_Detail_BEL'))
BEGIN
ALTER TABLE IFRS_Calculation_Detail_BEL ADD BEL_Others_Expected_27 float(53) NULL
END
GO
IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'BEL_Others_Expected_28' AND Object_ID = Object_ID(N'IFRS_Calculation_Detail_BEL'))
BEGIN
ALTER TABLE IFRS_Calculation_Detail_BEL ADD BEL_Others_Expected_28 float(53) NULL
END
GO
IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'BEL_Others_Expected_29' AND Object_ID = Object_ID(N'IFRS_Calculation_Detail_BEL'))
BEGIN
ALTER TABLE IFRS_Calculation_Detail_BEL ADD BEL_Others_Expected_29 float(53) NULL
END
GO
IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'BEL_Others_Expected_30' AND Object_ID = Object_ID(N'IFRS_Calculation_Detail_BEL'))
BEGIN
ALTER TABLE IFRS_Calculation_Detail_BEL ADD BEL_Others_Expected_30 float(53) NULL
END
GO
IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'BEL_Others_Expected_PAD_1' AND Object_ID = Object_ID(N'IFRS_Calculation_Detail_BEL'))
BEGIN
ALTER TABLE IFRS_Calculation_Detail_BEL ADD BEL_Others_Expected_PAD_1 float(53) NULL
END
GO
IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'BEL_Others_Expected_PAD_2' AND Object_ID = Object_ID(N'IFRS_Calculation_Detail_BEL'))
BEGIN
ALTER TABLE IFRS_Calculation_Detail_BEL ADD BEL_Others_Expected_PAD_2 float(53) NULL
END
GO
IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'BEL_Others_Expected_PAD_3' AND Object_ID = Object_ID(N'IFRS_Calculation_Detail_BEL'))
BEGIN
ALTER TABLE IFRS_Calculation_Detail_BEL ADD BEL_Others_Expected_PAD_3 float(53) NULL
END
GO
IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'BEL_Others_Expected_PAD_4' AND Object_ID = Object_ID(N'IFRS_Calculation_Detail_BEL'))
BEGIN
ALTER TABLE IFRS_Calculation_Detail_BEL ADD BEL_Others_Expected_PAD_4 float(53) NULL
END
GO
IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'BEL_Others_Expected_PAD_5' AND Object_ID = Object_ID(N'IFRS_Calculation_Detail_BEL'))
BEGIN
ALTER TABLE IFRS_Calculation_Detail_BEL ADD BEL_Others_Expected_PAD_5 float(53) NULL
END
GO
IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'BEL_Others_Expected_PAD_6' AND Object_ID = Object_ID(N'IFRS_Calculation_Detail_BEL'))
BEGIN
ALTER TABLE IFRS_Calculation_Detail_BEL ADD BEL_Others_Expected_PAD_6 float(53) NULL
END
GO
IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'BEL_Others_Expected_PAD_7' AND Object_ID = Object_ID(N'IFRS_Calculation_Detail_BEL'))
BEGIN
ALTER TABLE IFRS_Calculation_Detail_BEL ADD BEL_Others_Expected_PAD_7 float(53) NULL
END
GO
IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'BEL_Others_Expected_PAD_8' AND Object_ID = Object_ID(N'IFRS_Calculation_Detail_BEL'))
BEGIN
ALTER TABLE IFRS_Calculation_Detail_BEL ADD BEL_Others_Expected_PAD_8 float(53) NULL
END
GO
IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'BEL_Others_Expected_PAD_9' AND Object_ID = Object_ID(N'IFRS_Calculation_Detail_BEL'))
BEGIN
ALTER TABLE IFRS_Calculation_Detail_BEL ADD BEL_Others_Expected_PAD_9 float(53) NULL
END
GO
IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'BEL_Others_Expected_PAD_10' AND Object_ID = Object_ID(N'IFRS_Calculation_Detail_BEL'))
BEGIN
ALTER TABLE IFRS_Calculation_Detail_BEL ADD BEL_Others_Expected_PAD_10 float(53) NULL
END
GO
IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'BEL_Others_Expected_PAD_11' AND Object_ID = Object_ID(N'IFRS_Calculation_Detail_BEL'))
BEGIN
ALTER TABLE IFRS_Calculation_Detail_BEL ADD BEL_Others_Expected_PAD_11 float(53) NULL
END
GO
IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'BEL_Others_Expected_PAD_12' AND Object_ID = Object_ID(N'IFRS_Calculation_Detail_BEL'))
BEGIN
ALTER TABLE IFRS_Calculation_Detail_BEL ADD BEL_Others_Expected_PAD_12 float(53) NULL
END
GO
IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'BEL_Others_Expected_PAD_13' AND Object_ID = Object_ID(N'IFRS_Calculation_Detail_BEL'))
BEGIN
ALTER TABLE IFRS_Calculation_Detail_BEL ADD BEL_Others_Expected_PAD_13 float(53) NULL
END
GO
IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'BEL_Others_Expected_PAD_14' AND Object_ID = Object_ID(N'IFRS_Calculation_Detail_BEL'))
BEGIN
ALTER TABLE IFRS_Calculation_Detail_BEL ADD BEL_Others_Expected_PAD_14 float(53) NULL
END
GO
IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'BEL_Others_Expected_PAD_15' AND Object_ID = Object_ID(N'IFRS_Calculation_Detail_BEL'))
BEGIN
ALTER TABLE IFRS_Calculation_Detail_BEL ADD BEL_Others_Expected_PAD_15 float(53) NULL
END
GO
IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'BEL_Others_Expected_PAD_16' AND Object_ID = Object_ID(N'IFRS_Calculation_Detail_BEL'))
BEGIN
ALTER TABLE IFRS_Calculation_Detail_BEL ADD BEL_Others_Expected_PAD_16 float(53) NULL
END
GO
IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'BEL_Others_Expected_PAD_17' AND Object_ID = Object_ID(N'IFRS_Calculation_Detail_BEL'))
BEGIN
ALTER TABLE IFRS_Calculation_Detail_BEL ADD BEL_Others_Expected_PAD_17 float(53) NULL
END
GO
IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'BEL_Others_Expected_PAD_18' AND Object_ID = Object_ID(N'IFRS_Calculation_Detail_BEL'))
BEGIN 
ALTER TABLE IFRS_Calculation_Detail_BEL ADD BEL_Others_Expected_PAD_18 float(53) NULL
END
GO
IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'BEL_Others_Expected_PAD_19' AND Object_ID = Object_ID(N'IFRS_Calculation_Detail_BEL'))
BEGIN
ALTER TABLE IFRS_Calculation_Detail_BEL ADD BEL_Others_Expected_PAD_19 float(53) NULL
END
GO
IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'BEL_Others_Expected_PAD_20' AND Object_ID = Object_ID(N'IFRS_Calculation_Detail_BEL'))
BEGIN
ALTER TABLE IFRS_Calculation_Detail_BEL ADD BEL_Others_Expected_PAD_20 float(53) NULL
END
GO
IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'BEL_Others_Expected_PAD_21' AND Object_ID = Object_ID(N'IFRS_Calculation_Detail_BEL'))
BEGIN
ALTER TABLE IFRS_Calculation_Detail_BEL ADD BEL_Others_Expected_PAD_21 float(53) NULL
END
GO
IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'BEL_Others_Expected_PAD_22' AND Object_ID = Object_ID(N'IFRS_Calculation_Detail_BEL'))
BEGIN
ALTER TABLE IFRS_Calculation_Detail_BEL ADD BEL_Others_Expected_PAD_22 float(53) NULL
END
GO
IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'BEL_Others_Expected_PAD_23' AND Object_ID = Object_ID(N'IFRS_Calculation_Detail_BEL'))
BEGIN
ALTER TABLE IFRS_Calculation_Detail_BEL ADD BEL_Others_Expected_PAD_23 float(53) NULL
END
GO
IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'BEL_Others_Expected_PAD_24' AND Object_ID = Object_ID(N'IFRS_Calculation_Detail_BEL'))
BEGIN
ALTER TABLE IFRS_Calculation_Detail_BEL ADD BEL_Others_Expected_PAD_24 float(53) NULL
END
GO
IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'BEL_Others_Expected_PAD_25' AND Object_ID = Object_ID(N'IFRS_Calculation_Detail_BEL'))
BEGIN
ALTER TABLE IFRS_Calculation_Detail_BEL ADD BEL_Others_Expected_PAD_25 float(53) NULL
END
GO
IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'BEL_Others_Expected_PAD_26' AND Object_ID = Object_ID(N'IFRS_Calculation_Detail_BEL'))
BEGIN
ALTER TABLE IFRS_Calculation_Detail_BEL ADD BEL_Others_Expected_PAD_26 float(53) NULL
END
GO
IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'BEL_Others_Expected_PAD_27' AND Object_ID = Object_ID(N'IFRS_Calculation_Detail_BEL'))
BEGIN
ALTER TABLE IFRS_Calculation_Detail_BEL ADD BEL_Others_Expected_PAD_27 float(53) NULL
END
GO
IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'BEL_Others_Expected_PAD_28' AND Object_ID = Object_ID(N'IFRS_Calculation_Detail_BEL'))
BEGIN
ALTER TABLE IFRS_Calculation_Detail_BEL ADD BEL_Others_Expected_PAD_28 float(53) NULL
END
GO
IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'BEL_Others_Expected_PAD_29' AND Object_ID = Object_ID(N'IFRS_Calculation_Detail_BEL'))
BEGIN
ALTER TABLE IFRS_Calculation_Detail_BEL ADD BEL_Others_Expected_PAD_29 float(53) NULL
END
GO
IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'BEL_Others_Expected_PAD_30' AND Object_ID = Object_ID(N'IFRS_Calculation_Detail_BEL'))
BEGIN
ALTER TABLE IFRS_Calculation_Detail_BEL ADD BEL_Others_Expected_PAD_30 float(53) NULL
END
GO


IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'BEL_Others_Expected_1' AND Object_ID = Object_ID(N'IFRS_Initial_Detail_BEL'))
BEGIN
ALTER TABLE IFRS_Initial_Detail_BEL ADD BEL_Others_Expected_1 float(53) NULL
END
GO
IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'BEL_Others_Expected_2' AND Object_ID = Object_ID(N'IFRS_Initial_Detail_BEL'))
BEGIN
ALTER TABLE IFRS_Initial_Detail_BEL ADD BEL_Others_Expected_2 float(53) NULL
END
GO
IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'BEL_Others_Expected_3' AND Object_ID = Object_ID(N'IFRS_Initial_Detail_BEL'))
BEGIN
ALTER TABLE IFRS_Initial_Detail_BEL ADD BEL_Others_Expected_3 float(53) NULL
END
GO
IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'BEL_Others_Expected_4' AND Object_ID = Object_ID(N'IFRS_Initial_Detail_BEL'))
BEGIN
ALTER TABLE IFRS_Initial_Detail_BEL ADD BEL_Others_Expected_4 float(53) NULL
END
GO
IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'BEL_Others_Expected_5' AND Object_ID = Object_ID(N'IFRS_Initial_Detail_BEL'))
BEGIN
ALTER TABLE IFRS_Initial_Detail_BEL ADD BEL_Others_Expected_5 float(53) NULL
END
GO
IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'BEL_Others_Expected_6' AND Object_ID = Object_ID(N'IFRS_Initial_Detail_BEL'))
BEGIN
ALTER TABLE IFRS_Initial_Detail_BEL ADD BEL_Others_Expected_6 float(53) NULL
END
GO
IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'BEL_Others_Expected_7' AND Object_ID = Object_ID(N'IFRS_Initial_Detail_BEL'))
BEGIN
ALTER TABLE IFRS_Initial_Detail_BEL ADD BEL_Others_Expected_7 float(53) NULL
END
GO
IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'BEL_Others_Expected_8' AND Object_ID = Object_ID(N'IFRS_Initial_Detail_BEL'))
BEGIN
ALTER TABLE IFRS_Initial_Detail_BEL ADD BEL_Others_Expected_8 float(53) NULL
END
GO
IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'BEL_Others_Expected_9' AND Object_ID = Object_ID(N'IFRS_Initial_Detail_BEL'))
BEGIN
ALTER TABLE IFRS_Initial_Detail_BEL ADD BEL_Others_Expected_9 float(53) NULL
END
GO
IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'BEL_Others_Expected_10' AND Object_ID = Object_ID(N'IFRS_Initial_Detail_BEL'))
BEGIN
ALTER TABLE IFRS_Initial_Detail_BEL ADD BEL_Others_Expected_10 float(53) NULL
END
GO
IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'BEL_Others_Expected_11' AND Object_ID = Object_ID(N'IFRS_Initial_Detail_BEL'))
BEGIN
ALTER TABLE IFRS_Initial_Detail_BEL ADD BEL_Others_Expected_11 float(53) NULL
END
GO
IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'BEL_Others_Expected_12' AND Object_ID = Object_ID(N'IFRS_Initial_Detail_BEL'))
BEGIN
ALTER TABLE IFRS_Initial_Detail_BEL ADD BEL_Others_Expected_12 float(53) NULL
END
GO
IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'BEL_Others_Expected_13' AND Object_ID = Object_ID(N'IFRS_Initial_Detail_BEL'))
BEGIN
ALTER TABLE IFRS_Initial_Detail_BEL ADD BEL_Others_Expected_13 float(53) NULL
END
GO
IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'BEL_Others_Expected_14' AND Object_ID = Object_ID(N'IFRS_Initial_Detail_BEL'))
BEGIN
ALTER TABLE IFRS_Initial_Detail_BEL ADD BEL_Others_Expected_14 float(53) NULL
END
GO
IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'BEL_Others_Expected_15' AND Object_ID = Object_ID(N'IFRS_Initial_Detail_BEL'))
BEGIN
ALTER TABLE IFRS_Initial_Detail_BEL ADD BEL_Others_Expected_15 float(53) NULL
END
GO
IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'BEL_Others_Expected_16' AND Object_ID = Object_ID(N'IFRS_Initial_Detail_BEL'))
BEGIN
ALTER TABLE IFRS_Initial_Detail_BEL ADD BEL_Others_Expected_16 float(53) NULL
END
GO
IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'BEL_Others_Expected_17' AND Object_ID = Object_ID(N'IFRS_Initial_Detail_BEL'))
BEGIN
ALTER TABLE IFRS_Initial_Detail_BEL ADD BEL_Others_Expected_17 float(53) NULL
END
GO
IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'BEL_Others_Expected_18' AND Object_ID = Object_ID(N'IFRS_Initial_Detail_BEL'))
BEGIN 
ALTER TABLE IFRS_Initial_Detail_BEL ADD BEL_Others_Expected_18 float(53) NULL
END
GO
IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'BEL_Others_Expected_19' AND Object_ID = Object_ID(N'IFRS_Initial_Detail_BEL'))
BEGIN
ALTER TABLE IFRS_Initial_Detail_BEL ADD BEL_Others_Expected_19 float(53) NULL
END
GO
IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'BEL_Others_Expected_20' AND Object_ID = Object_ID(N'IFRS_Initial_Detail_BEL'))
BEGIN
ALTER TABLE IFRS_Initial_Detail_BEL ADD BEL_Others_Expected_20 float(53) NULL
END
GO
IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'BEL_Others_Expected_21' AND Object_ID = Object_ID(N'IFRS_Initial_Detail_BEL'))
BEGIN
ALTER TABLE IFRS_Initial_Detail_BEL ADD BEL_Others_Expected_21 float(53) NULL
END
GO
IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'BEL_Others_Expected_22' AND Object_ID = Object_ID(N'IFRS_Initial_Detail_BEL'))
BEGIN
ALTER TABLE IFRS_Initial_Detail_BEL ADD BEL_Others_Expected_22 float(53) NULL
END
GO
IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'BEL_Others_Expected_23' AND Object_ID = Object_ID(N'IFRS_Initial_Detail_BEL'))
BEGIN
ALTER TABLE IFRS_Initial_Detail_BEL ADD BEL_Others_Expected_23 float(53) NULL
END
GO
IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'BEL_Others_Expected_24' AND Object_ID = Object_ID(N'IFRS_Initial_Detail_BEL'))
BEGIN
ALTER TABLE IFRS_Initial_Detail_BEL ADD BEL_Others_Expected_24 float(53) NULL
END
GO
IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'BEL_Others_Expected_25' AND Object_ID = Object_ID(N'IFRS_Initial_Detail_BEL'))
BEGIN
ALTER TABLE IFRS_Initial_Detail_BEL ADD BEL_Others_Expected_25 float(53) NULL
END
GO
IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'BEL_Others_Expected_26' AND Object_ID = Object_ID(N'IFRS_Initial_Detail_BEL'))
BEGIN
ALTER TABLE IFRS_Initial_Detail_BEL ADD BEL_Others_Expected_26 float(53) NULL
END
GO
IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'BEL_Others_Expected_27' AND Object_ID = Object_ID(N'IFRS_Initial_Detail_BEL'))
BEGIN
ALTER TABLE IFRS_Initial_Detail_BEL ADD BEL_Others_Expected_27 float(53) NULL
END
GO
IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'BEL_Others_Expected_28' AND Object_ID = Object_ID(N'IFRS_Initial_Detail_BEL'))
BEGIN
ALTER TABLE IFRS_Initial_Detail_BEL ADD BEL_Others_Expected_28 float(53) NULL
END
GO
IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'BEL_Others_Expected_29' AND Object_ID = Object_ID(N'IFRS_Initial_Detail_BEL'))
BEGIN
ALTER TABLE IFRS_Initial_Detail_BEL ADD BEL_Others_Expected_29 float(53) NULL
END
GO
IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'BEL_Others_Expected_30' AND Object_ID = Object_ID(N'IFRS_Initial_Detail_BEL'))
BEGIN
ALTER TABLE IFRS_Initial_Detail_BEL ADD BEL_Others_Expected_30 float(53) NULL
END
GO
IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'BEL_Others_Expected_PAD_1' AND Object_ID = Object_ID(N'IFRS_Initial_Detail_BEL'))
BEGIN
ALTER TABLE IFRS_Initial_Detail_BEL ADD BEL_Others_Expected_PAD_1 float(53) NULL
END
GO
IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'BEL_Others_Expected_PAD_2' AND Object_ID = Object_ID(N'IFRS_Initial_Detail_BEL'))
BEGIN
ALTER TABLE IFRS_Initial_Detail_BEL ADD BEL_Others_Expected_PAD_2 float(53) NULL
END
GO
IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'BEL_Others_Expected_PAD_3' AND Object_ID = Object_ID(N'IFRS_Initial_Detail_BEL'))
BEGIN
ALTER TABLE IFRS_Initial_Detail_BEL ADD BEL_Others_Expected_PAD_3 float(53) NULL
END
GO
IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'BEL_Others_Expected_PAD_4' AND Object_ID = Object_ID(N'IFRS_Initial_Detail_BEL'))
BEGIN
ALTER TABLE IFRS_Initial_Detail_BEL ADD BEL_Others_Expected_PAD_4 float(53) NULL
END
GO
IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'BEL_Others_Expected_PAD_5' AND Object_ID = Object_ID(N'IFRS_Initial_Detail_BEL'))
BEGIN
ALTER TABLE IFRS_Initial_Detail_BEL ADD BEL_Others_Expected_PAD_5 float(53) NULL
END
GO
IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'BEL_Others_Expected_PAD_6' AND Object_ID = Object_ID(N'IFRS_Initial_Detail_BEL'))
BEGIN
ALTER TABLE IFRS_Initial_Detail_BEL ADD BEL_Others_Expected_PAD_6 float(53) NULL
END
GO
IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'BEL_Others_Expected_PAD_7' AND Object_ID = Object_ID(N'IFRS_Initial_Detail_BEL'))
BEGIN
ALTER TABLE IFRS_Initial_Detail_BEL ADD BEL_Others_Expected_PAD_7 float(53) NULL
END
GO
IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'BEL_Others_Expected_PAD_8' AND Object_ID = Object_ID(N'IFRS_Initial_Detail_BEL'))
BEGIN
ALTER TABLE IFRS_Initial_Detail_BEL ADD BEL_Others_Expected_PAD_8 float(53) NULL
END
GO
IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'BEL_Others_Expected_PAD_9' AND Object_ID = Object_ID(N'IFRS_Initial_Detail_BEL'))
BEGIN
ALTER TABLE IFRS_Initial_Detail_BEL ADD BEL_Others_Expected_PAD_9 float(53) NULL
END
GO
IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'BEL_Others_Expected_PAD_10' AND Object_ID = Object_ID(N'IFRS_Initial_Detail_BEL'))
BEGIN
ALTER TABLE IFRS_Initial_Detail_BEL ADD BEL_Others_Expected_PAD_10 float(53) NULL
END
GO
IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'BEL_Others_Expected_PAD_11' AND Object_ID = Object_ID(N'IFRS_Initial_Detail_BEL'))
BEGIN
ALTER TABLE IFRS_Initial_Detail_BEL ADD BEL_Others_Expected_PAD_11 float(53) NULL
END
GO
IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'BEL_Others_Expected_PAD_12' AND Object_ID = Object_ID(N'IFRS_Initial_Detail_BEL'))
BEGIN
ALTER TABLE IFRS_Initial_Detail_BEL ADD BEL_Others_Expected_PAD_12 float(53) NULL
END
GO
IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'BEL_Others_Expected_PAD_13' AND Object_ID = Object_ID(N'IFRS_Initial_Detail_BEL'))
BEGIN
ALTER TABLE IFRS_Initial_Detail_BEL ADD BEL_Others_Expected_PAD_13 float(53) NULL
END
GO
IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'BEL_Others_Expected_PAD_14' AND Object_ID = Object_ID(N'IFRS_Initial_Detail_BEL'))
BEGIN
ALTER TABLE IFRS_Initial_Detail_BEL ADD BEL_Others_Expected_PAD_14 float(53) NULL
END
GO
IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'BEL_Others_Expected_PAD_15' AND Object_ID = Object_ID(N'IFRS_Initial_Detail_BEL'))
BEGIN
ALTER TABLE IFRS_Initial_Detail_BEL ADD BEL_Others_Expected_PAD_15 float(53) NULL
END
GO
IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'BEL_Others_Expected_PAD_16' AND Object_ID = Object_ID(N'IFRS_Initial_Detail_BEL'))
BEGIN
ALTER TABLE IFRS_Initial_Detail_BEL ADD BEL_Others_Expected_PAD_16 float(53) NULL
END
GO
IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'BEL_Others_Expected_PAD_17' AND Object_ID = Object_ID(N'IFRS_Initial_Detail_BEL'))
BEGIN
ALTER TABLE IFRS_Initial_Detail_BEL ADD BEL_Others_Expected_PAD_17 float(53) NULL
END
GO
IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'BEL_Others_Expected_PAD_18' AND Object_ID = Object_ID(N'IFRS_Initial_Detail_BEL'))
BEGIN 
ALTER TABLE IFRS_Initial_Detail_BEL ADD BEL_Others_Expected_PAD_18 float(53) NULL
END
GO
IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'BEL_Others_Expected_PAD_19' AND Object_ID = Object_ID(N'IFRS_Initial_Detail_BEL'))
BEGIN
ALTER TABLE IFRS_Initial_Detail_BEL ADD BEL_Others_Expected_PAD_19 float(53) NULL
END
GO
IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'BEL_Others_Expected_PAD_20' AND Object_ID = Object_ID(N'IFRS_Initial_Detail_BEL'))
BEGIN
ALTER TABLE IFRS_Initial_Detail_BEL ADD BEL_Others_Expected_PAD_20 float(53) NULL
END
GO
IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'BEL_Others_Expected_PAD_21' AND Object_ID = Object_ID(N'IFRS_Initial_Detail_BEL'))
BEGIN
ALTER TABLE IFRS_Initial_Detail_BEL ADD BEL_Others_Expected_PAD_21 float(53) NULL
END
GO
IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'BEL_Others_Expected_PAD_22' AND Object_ID = Object_ID(N'IFRS_Initial_Detail_BEL'))
BEGIN
ALTER TABLE IFRS_Initial_Detail_BEL ADD BEL_Others_Expected_PAD_22 float(53) NULL
END
GO
IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'BEL_Others_Expected_PAD_23' AND Object_ID = Object_ID(N'IFRS_Initial_Detail_BEL'))
BEGIN
ALTER TABLE IFRS_Initial_Detail_BEL ADD BEL_Others_Expected_PAD_23 float(53) NULL
END
GO
IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'BEL_Others_Expected_PAD_24' AND Object_ID = Object_ID(N'IFRS_Initial_Detail_BEL'))
BEGIN
ALTER TABLE IFRS_Initial_Detail_BEL ADD BEL_Others_Expected_PAD_24 float(53) NULL
END
GO
IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'BEL_Others_Expected_PAD_25' AND Object_ID = Object_ID(N'IFRS_Initial_Detail_BEL'))
BEGIN
ALTER TABLE IFRS_Initial_Detail_BEL ADD BEL_Others_Expected_PAD_25 float(53) NULL
END
GO
IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'BEL_Others_Expected_PAD_26' AND Object_ID = Object_ID(N'IFRS_Initial_Detail_BEL'))
BEGIN
ALTER TABLE IFRS_Initial_Detail_BEL ADD BEL_Others_Expected_PAD_26 float(53) NULL
END
GO
IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'BEL_Others_Expected_PAD_27' AND Object_ID = Object_ID(N'IFRS_Initial_Detail_BEL'))
BEGIN
ALTER TABLE IFRS_Initial_Detail_BEL ADD BEL_Others_Expected_PAD_27 float(53) NULL
END
GO
IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'BEL_Others_Expected_PAD_28' AND Object_ID = Object_ID(N'IFRS_Initial_Detail_BEL'))
BEGIN
ALTER TABLE IFRS_Initial_Detail_BEL ADD BEL_Others_Expected_PAD_28 float(53) NULL
END
GO
IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'BEL_Others_Expected_PAD_29' AND Object_ID = Object_ID(N'IFRS_Initial_Detail_BEL'))
BEGIN
ALTER TABLE IFRS_Initial_Detail_BEL ADD BEL_Others_Expected_PAD_29 float(53) NULL
END
GO
IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'BEL_Others_Expected_PAD_30' AND Object_ID = Object_ID(N'IFRS_Initial_Detail_BEL'))
BEGIN
ALTER TABLE IFRS_Initial_Detail_BEL ADD BEL_Others_Expected_PAD_30 float(53) NULL
END
GO


IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'BEL_Others_Expected' AND Object_ID = Object_ID(N'IFRS_Movement'))
BEGIN
ALTER TABLE IFRS_Movement ADD BEL_Others_Expected float(53) NULL
END
GO
IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'Loss_Portion_from_Others_Release' AND Object_ID = Object_ID(N'IFRS_Movement'))
BEGIN
ALTER TABLE IFRS_Movement ADD Loss_Portion_from_Others_Release float(53) NULL
END
GO


IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'Others_Expected_1' AND Object_ID = Object_ID(N'IFRS_Assumption_Detail'))
BEGIN
ALTER TABLE IFRS_Assumption_Detail ADD Others_Expected_1 float(53) NULL
END
GO
IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'Others_Expected_2' AND Object_ID = Object_ID(N'IFRS_Assumption_Detail'))
BEGIN
ALTER TABLE IFRS_Assumption_Detail ADD Others_Expected_2 float(53) NULL
END
GO
IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'Others_Expected_3' AND Object_ID = Object_ID(N'IFRS_Assumption_Detail'))
BEGIN
ALTER TABLE IFRS_Assumption_Detail ADD Others_Expected_3 float(53) NULL
END
GO
IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'Others_Expected_4' AND Object_ID = Object_ID(N'IFRS_Assumption_Detail'))
BEGIN
ALTER TABLE IFRS_Assumption_Detail ADD Others_Expected_4 float(53) NULL
END
GO
IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'Others_Expected_5' AND Object_ID = Object_ID(N'IFRS_Assumption_Detail'))
BEGIN
ALTER TABLE IFRS_Assumption_Detail ADD Others_Expected_5 float(53) NULL
END
GO
IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'ApplyFAForPAAF' AND Object_ID = Object_ID(N'IFRS_Assumption_Detail'))
BEGIN
ALTER TABLE IFRS_Assumption_Detail ADD ApplyFAForPAAF bit NULL
END
GO


IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'Amount_32' AND Object_ID = Object_ID(N'Acclink'))
BEGIN
ALTER TABLE Acclink ADD Amount_32 float(53) NULL
END
GO
IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'Amount_33' AND Object_ID = Object_ID(N'Acclink'))
BEGIN
ALTER TABLE Acclink ADD Amount_33 float(53) NULL
END
GO
IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'Amount_34' AND Object_ID = Object_ID(N'Acclink'))
BEGIN
ALTER TABLE Acclink ADD Amount_34 float(53) NULL
END
GO
IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'Amount_35' AND Object_ID = Object_ID(N'Acclink'))
BEGIN
ALTER TABLE Acclink ADD Amount_35 float(53) NULL
END
GO


IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'Loss_Portion_from_Others_Release_1' AND Object_ID = Object_ID(N'IFRS_Calculation_Detail_LOSS'))
BEGIN
ALTER TABLE IFRS_Calculation_Detail_LOSS ADD Loss_Portion_from_Others_Release_1 float(53) NULL
END
GO
IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'Loss_Portion_from_Others_Release_2' AND Object_ID = Object_ID(N'IFRS_Calculation_Detail_LOSS'))
BEGIN
ALTER TABLE IFRS_Calculation_Detail_LOSS ADD Loss_Portion_from_Others_Release_2 float(53) NULL
END
GO
IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'Loss_Portion_from_Others_Release_3' AND Object_ID = Object_ID(N'IFRS_Calculation_Detail_LOSS'))
BEGIN
ALTER TABLE IFRS_Calculation_Detail_LOSS ADD Loss_Portion_from_Others_Release_3 float(53) NULL
END
GO
IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'Loss_Portion_from_Others_Release_4' AND Object_ID = Object_ID(N'IFRS_Calculation_Detail_LOSS'))
BEGIN
ALTER TABLE IFRS_Calculation_Detail_LOSS ADD Loss_Portion_from_Others_Release_4 float(53) NULL
END
GO
IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'Loss_Portion_from_Others_Release_5' AND Object_ID = Object_ID(N'IFRS_Calculation_Detail_LOSS'))
BEGIN
ALTER TABLE IFRS_Calculation_Detail_LOSS ADD Loss_Portion_from_Others_Release_5 float(53) NULL
END
GO
IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'Loss_Portion_from_Others_Release_6' AND Object_ID = Object_ID(N'IFRS_Calculation_Detail_LOSS'))
BEGIN
ALTER TABLE IFRS_Calculation_Detail_LOSS ADD Loss_Portion_from_Others_Release_6 float(53) NULL
END
GO
IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'Loss_Portion_from_Others_Release_7' AND Object_ID = Object_ID(N'IFRS_Calculation_Detail_LOSS'))
BEGIN
ALTER TABLE IFRS_Calculation_Detail_LOSS ADD Loss_Portion_from_Others_Release_7 float(53) NULL
END
GO
IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'Loss_Portion_from_Others_Release_8' AND Object_ID = Object_ID(N'IFRS_Calculation_Detail_LOSS'))
BEGIN
ALTER TABLE IFRS_Calculation_Detail_LOSS ADD Loss_Portion_from_Others_Release_8 float(53) NULL
END
GO
IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'Loss_Portion_from_Others_Release_9' AND Object_ID = Object_ID(N'IFRS_Calculation_Detail_LOSS'))
BEGIN
ALTER TABLE IFRS_Calculation_Detail_LOSS ADD Loss_Portion_from_Others_Release_9 float(53) NULL
END
GO
IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'Loss_Portion_from_Others_Release_10' AND Object_ID = Object_ID(N'IFRS_Calculation_Detail_LOSS'))
BEGIN
ALTER TABLE IFRS_Calculation_Detail_LOSS ADD Loss_Portion_from_Others_Release_10 float(53) NULL
END
GO
IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'Loss_Portion_from_Others_Release_11' AND Object_ID = Object_ID(N'IFRS_Calculation_Detail_LOSS'))
BEGIN
ALTER TABLE IFRS_Calculation_Detail_LOSS ADD Loss_Portion_from_Others_Release_11 float(53) NULL
END
GO
IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'Loss_Portion_from_Others_Release_12' AND Object_ID = Object_ID(N'IFRS_Calculation_Detail_LOSS'))
BEGIN
ALTER TABLE IFRS_Calculation_Detail_LOSS ADD Loss_Portion_from_Others_Release_12 float(53) NULL
END
GO
IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'Loss_Portion_from_Others_Release_13' AND Object_ID = Object_ID(N'IFRS_Calculation_Detail_LOSS'))
BEGIN
ALTER TABLE IFRS_Calculation_Detail_LOSS ADD Loss_Portion_from_Others_Release_13 float(53) NULL
END
GO
IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'Loss_Portion_from_Others_Release_14' AND Object_ID = Object_ID(N'IFRS_Calculation_Detail_LOSS'))
BEGIN
ALTER TABLE IFRS_Calculation_Detail_LOSS ADD Loss_Portion_from_Others_Release_14 float(53) NULL
END
GO
IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'Loss_Portion_from_Others_Release_15' AND Object_ID = Object_ID(N'IFRS_Calculation_Detail_LOSS'))
BEGIN
ALTER TABLE IFRS_Calculation_Detail_LOSS ADD Loss_Portion_from_Others_Release_15 float(53) NULL
END
GO
IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'Loss_Portion_from_Others_Release_16' AND Object_ID = Object_ID(N'IFRS_Calculation_Detail_LOSS'))
BEGIN
ALTER TABLE IFRS_Calculation_Detail_LOSS ADD Loss_Portion_from_Others_Release_16 float(53) NULL
END
GO
IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'Loss_Portion_from_Others_Release_17' AND Object_ID = Object_ID(N'IFRS_Calculation_Detail_LOSS'))
BEGIN
ALTER TABLE IFRS_Calculation_Detail_LOSS ADD Loss_Portion_from_Others_Release_17 float(53) NULL
END
GO
IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'Loss_Portion_from_Others_Release_18' AND Object_ID = Object_ID(N'IFRS_Calculation_Detail_LOSS'))
BEGIN 
ALTER TABLE IFRS_Calculation_Detail_LOSS ADD Loss_Portion_from_Others_Release_18 float(53) NULL
END
GO
IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'Loss_Portion_from_Others_Release_19' AND Object_ID = Object_ID(N'IFRS_Calculation_Detail_LOSS'))
BEGIN
ALTER TABLE IFRS_Calculation_Detail_LOSS ADD Loss_Portion_from_Others_Release_19 float(53) NULL
END
GO
IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'Loss_Portion_from_Others_Release_20' AND Object_ID = Object_ID(N'IFRS_Calculation_Detail_LOSS'))
BEGIN
ALTER TABLE IFRS_Calculation_Detail_LOSS ADD Loss_Portion_from_Others_Release_20 float(53) NULL
END
GO
IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'Loss_Portion_from_Others_Release_21' AND Object_ID = Object_ID(N'IFRS_Calculation_Detail_LOSS'))
BEGIN
ALTER TABLE IFRS_Calculation_Detail_LOSS ADD Loss_Portion_from_Others_Release_21 float(53) NULL
END
GO
IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'Loss_Portion_from_Others_Release_22' AND Object_ID = Object_ID(N'IFRS_Calculation_Detail_LOSS'))
BEGIN
ALTER TABLE IFRS_Calculation_Detail_LOSS ADD Loss_Portion_from_Others_Release_22 float(53) NULL
END
GO
IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'Loss_Portion_from_Others_Release_23' AND Object_ID = Object_ID(N'IFRS_Calculation_Detail_LOSS'))
BEGIN
ALTER TABLE IFRS_Calculation_Detail_LOSS ADD Loss_Portion_from_Others_Release_23 float(53) NULL
END
GO
IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'Loss_Portion_from_Others_Release_24' AND Object_ID = Object_ID(N'IFRS_Calculation_Detail_LOSS'))
BEGIN
ALTER TABLE IFRS_Calculation_Detail_LOSS ADD Loss_Portion_from_Others_Release_24 float(53) NULL
END
GO
IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'Loss_Portion_from_Others_Release_25' AND Object_ID = Object_ID(N'IFRS_Calculation_Detail_LOSS'))
BEGIN
ALTER TABLE IFRS_Calculation_Detail_LOSS ADD Loss_Portion_from_Others_Release_25 float(53) NULL
END
GO
IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'Loss_Portion_from_Others_Release_26' AND Object_ID = Object_ID(N'IFRS_Calculation_Detail_LOSS'))
BEGIN
ALTER TABLE IFRS_Calculation_Detail_LOSS ADD Loss_Portion_from_Others_Release_26 float(53) NULL
END
GO
IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'Loss_Portion_from_Others_Release_27' AND Object_ID = Object_ID(N'IFRS_Calculation_Detail_LOSS'))
BEGIN
ALTER TABLE IFRS_Calculation_Detail_LOSS ADD Loss_Portion_from_Others_Release_27 float(53) NULL
END
GO
IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'Loss_Portion_from_Others_Release_28' AND Object_ID = Object_ID(N'IFRS_Calculation_Detail_LOSS'))
BEGIN
ALTER TABLE IFRS_Calculation_Detail_LOSS ADD Loss_Portion_from_Others_Release_28 float(53) NULL
END
GO
IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'Loss_Portion_from_Others_Release_29' AND Object_ID = Object_ID(N'IFRS_Calculation_Detail_LOSS'))
BEGIN
ALTER TABLE IFRS_Calculation_Detail_LOSS ADD Loss_Portion_from_Others_Release_29 float(53) NULL
END
GO
IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'Loss_Portion_from_Others_Release_30' AND Object_ID = Object_ID(N'IFRS_Calculation_Detail_LOSS'))
BEGIN
ALTER TABLE IFRS_Calculation_Detail_LOSS ADD Loss_Portion_from_Others_Release_30 float(53) NULL
END
GO



IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'ApplyFAForPAAF' AND Object_ID = Object_ID(N'IFRS_Calculation'))
BEGIN
ALTER TABLE IFRS_Calculation ADD ApplyFAForPAAF bit NULL
DECLARE @v sql_variant 
SET @v = N'Apply Financial Adjustment for PAA'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'IFRS_Calculation', N'COLUMN', N'ApplyFAForPAAF'
END
GO

IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'ApplyFAForPAAF' AND Object_ID = Object_ID(N'IFRS_Initial'))
BEGIN
ALTER TABLE IFRS_Initial ADD ApplyFAForPAAF bit NULL
DECLARE @v sql_variant 
SET @v = N'Apply Financial Adjustment for PAA'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'IFRS_Initial', N'COLUMN', N'ApplyFAForPAAF'
END
GO

insert into PatchVersioning
select '856 Update Script - IFRS Patch #29',GETDATE()
go


Declare @PrevScript varchar(100)
Declare @CurrScript varchar(100)

Select @PrevScript=''
Select @CurrSCript='856 Update Script - IFRS Patch #29'


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
