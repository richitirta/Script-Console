/* To prevent any potential data loss issues, you should review this script in detail before running it outside the context of the database designer.*/
BEGIN TRANSACTION
SET QUOTED_IDENTIFIER ON
SET ARITHABORT ON
SET NUMERIC_ROUNDABORT OFF
SET CONCAT_NULL_YIELDS_NULL ON
SET ANSI_NULLS ON
SET ANSI_PADDING ON
SET ANSI_WARNINGS ON
COMMIT


IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'FLDREP31' AND Object_ID = Object_ID(N'TOC_EXT'))
BEGIN
ALTER TABLE dbo.TOC_EXT ADD
	FLDREP31 bit NULL
END
GO


IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'DefValue31' AND Object_ID = Object_ID(N'TOC_EXT'))
BEGIN
ALTER TABLE dbo.TOC_EXT ADD
	DefValue31 varchar(255) NULL
END
GO


IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'FLDREP32' AND Object_ID = Object_ID(N'TOC_EXT'))
BEGIN
ALTER TABLE dbo.TOC_EXT ADD
	FLDREP32 bit NULL
END
GO


IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'DefValue32' AND Object_ID = Object_ID(N'TOC_EXT'))
BEGIN
ALTER TABLE dbo.TOC_EXT ADD
	DefValue32 varchar(255) NULL
END
GO


IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'FLDREP33' AND Object_ID = Object_ID(N'TOC_EXT'))
BEGIN
ALTER TABLE dbo.TOC_EXT ADD
	FLDREP33 bit NULL
END
GO


IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'DefValue33' AND Object_ID = Object_ID(N'TOC_EXT'))
BEGIN
ALTER TABLE dbo.TOC_EXT ADD
	DefValue33 varchar(255) NULL
END
GO


IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'FLDREP34' AND Object_ID = Object_ID(N'TOC_EXT'))
BEGIN
ALTER TABLE dbo.TOC_EXT ADD
	FLDREP34 bit NULL
END
GO


IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'DefValue34' AND Object_ID = Object_ID(N'TOC_EXT'))
BEGIN
ALTER TABLE dbo.TOC_EXT ADD
	DefValue34 varchar(255) NULL
END
GO


IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'FLDREP35' AND Object_ID = Object_ID(N'TOC_EXT'))
BEGIN
ALTER TABLE dbo.TOC_EXT ADD
	FLDREP35 bit NULL
END
GO


IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'DefValue35' AND Object_ID = Object_ID(N'TOC_EXT'))
BEGIN
ALTER TABLE dbo.TOC_EXT ADD
	DefValue35 varchar(255) NULL
END
GO


IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'FLDREP36' AND Object_ID = Object_ID(N'TOC_EXT'))
BEGIN
ALTER TABLE dbo.TOC_EXT ADD
	FLDREP36 bit NULL
END
GO


IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'DefValue36' AND Object_ID = Object_ID(N'TOC_EXT'))
BEGIN
ALTER TABLE dbo.TOC_EXT ADD
	DefValue36 varchar(255) NULL
END
GO


IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'FLDREP37' AND Object_ID = Object_ID(N'TOC_EXT'))
BEGIN
ALTER TABLE dbo.TOC_EXT ADD
	FLDREP37 bit NULL
END
GO


IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'DefValue37' AND Object_ID = Object_ID(N'TOC_EXT'))
BEGIN
ALTER TABLE dbo.TOC_EXT ADD
	DefValue37 varchar(255) NULL
END
GO


IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'FLDREP38' AND Object_ID = Object_ID(N'TOC_EXT'))
BEGIN
ALTER TABLE dbo.TOC_EXT ADD
	FLDREP38 bit NULL
END
GO


IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'DefValue38' AND Object_ID = Object_ID(N'TOC_EXT'))
BEGIN
ALTER TABLE dbo.TOC_EXT ADD
	DefValue38 varchar(255) NULL
END
GO


IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'FLDREP39' AND Object_ID = Object_ID(N'TOC_EXT'))
BEGIN
ALTER TABLE dbo.TOC_EXT ADD
	FLDREP39 bit NULL
END
GO


IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'DefValue39' AND Object_ID = Object_ID(N'TOC_EXT'))
BEGIN
ALTER TABLE dbo.TOC_EXT ADD
	DefValue39 varchar(255) NULL
END
GO


IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'FLDREP40' AND Object_ID = Object_ID(N'TOC_EXT'))
BEGIN
ALTER TABLE dbo.TOC_EXT ADD
	FLDREP40 bit NULL
END
GO


IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'DefValue40' AND Object_ID = Object_ID(N'TOC_EXT'))
BEGIN
ALTER TABLE dbo.TOC_EXT ADD
	DefValue40 varchar(255) NULL
END
GO


IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'FLDREP41' AND Object_ID = Object_ID(N'TOC_EXT'))
BEGIN
ALTER TABLE dbo.TOC_EXT ADD
	FLDREP41 bit NULL
END
GO


IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'DefValue41' AND Object_ID = Object_ID(N'TOC_EXT'))
BEGIN
ALTER TABLE dbo.TOC_EXT ADD
	DefValue41 varchar(255) NULL
END
GO


IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'FLDREP42' AND Object_ID = Object_ID(N'TOC_EXT'))
BEGIN
ALTER TABLE dbo.TOC_EXT ADD
	FLDREP42 bit NULL
END
GO


IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'DefValue42' AND Object_ID = Object_ID(N'TOC_EXT'))
BEGIN
ALTER TABLE dbo.TOC_EXT ADD
	DefValue42 varchar(255) NULL
END
GO


IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'FLDREP43' AND Object_ID = Object_ID(N'TOC_EXT'))
BEGIN
ALTER TABLE dbo.TOC_EXT ADD
	FLDREP43 bit NULL
END
GO


IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'DefValue43' AND Object_ID = Object_ID(N'TOC_EXT'))
BEGIN
ALTER TABLE dbo.TOC_EXT ADD
	DefValue43 varchar(255) NULL
END
GO


IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'FLDREP44' AND Object_ID = Object_ID(N'TOC_EXT'))
BEGIN
ALTER TABLE dbo.TOC_EXT ADD
	FLDREP44 bit NULL
END
GO


IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'DefValue44' AND Object_ID = Object_ID(N'TOC_EXT'))
BEGIN
ALTER TABLE dbo.TOC_EXT ADD
	DefValue44 varchar(255) NULL
END
GO


IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'FLDREP45' AND Object_ID = Object_ID(N'TOC_EXT'))
BEGIN
ALTER TABLE dbo.TOC_EXT ADD
	FLDREP45 bit NULL
END
GO

IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'DefValue45' AND Object_ID = Object_ID(N'TOC_EXT'))
BEGIN
ALTER TABLE dbo.TOC_EXT ADD
	DefValue45 varchar(255) NULL
END
GO


EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TOC_EXT', @level2type=N'COLUMN',@level2name=N'FLDREP31'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TOC_EXT', @level2type=N'COLUMN',@level2name=N'DefValue31'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TOC_EXT', @level2type=N'COLUMN',@level2name=N'FLDREP32'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TOC_EXT', @level2type=N'COLUMN',@level2name=N'DefValue32'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TOC_EXT', @level2type=N'COLUMN',@level2name=N'FLDREP33'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TOC_EXT', @level2type=N'COLUMN',@level2name=N'DefValue33'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TOC_EXT', @level2type=N'COLUMN',@level2name=N'FLDREP34'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TOC_EXT', @level2type=N'COLUMN',@level2name=N'DefValue34'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TOC_EXT', @level2type=N'COLUMN',@level2name=N'FLDREP35'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TOC_EXT', @level2type=N'COLUMN',@level2name=N'DefValue35'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TOC_EXT', @level2type=N'COLUMN',@level2name=N'FLDREP36'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TOC_EXT', @level2type=N'COLUMN',@level2name=N'DefValue36'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TOC_EXT', @level2type=N'COLUMN',@level2name=N'FLDREP37'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TOC_EXT', @level2type=N'COLUMN',@level2name=N'DefValue37'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TOC_EXT', @level2type=N'COLUMN',@level2name=N'FLDREP38'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TOC_EXT', @level2type=N'COLUMN',@level2name=N'DefValue38'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TOC_EXT', @level2type=N'COLUMN',@level2name=N'FLDREP39'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TOC_EXT', @level2type=N'COLUMN',@level2name=N'DefValue39'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TOC_EXT', @level2type=N'COLUMN',@level2name=N'FLDREP40'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TOC_EXT', @level2type=N'COLUMN',@level2name=N'DefValue40'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TOC_EXT', @level2type=N'COLUMN',@level2name=N'FLDREP41'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TOC_EXT', @level2type=N'COLUMN',@level2name=N'DefValue41'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TOC_EXT', @level2type=N'COLUMN',@level2name=N'FLDREP42'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TOC_EXT', @level2type=N'COLUMN',@level2name=N'DefValue42'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TOC_EXT', @level2type=N'COLUMN',@level2name=N'FLDREP43'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TOC_EXT', @level2type=N'COLUMN',@level2name=N'DefValue43'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TOC_EXT', @level2type=N'COLUMN',@level2name=N'FLDREP44'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TOC_EXT', @level2type=N'COLUMN',@level2name=N'DefValue44'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TOC_EXT', @level2type=N'COLUMN',@level2name=N'FLDREP45'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TOC_EXT', @level2type=N'COLUMN',@level2name=N'DefValue45'
GO
--oke




/* To prevent any potential data loss issues, you should review this script in detail before running it outside the context of the database designer.*/
BEGIN TRANSACTION
SET QUOTED_IDENTIFIER ON
SET ARITHABORT ON
SET NUMERIC_ROUNDABORT OFF
SET CONCAT_NULL_YIELDS_NULL ON
SET ANSI_NULLS ON
SET ANSI_PADDING ON
SET ANSI_WARNINGS ON
COMMIT


IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'FLDID31' AND Object_ID = Object_ID(N'AINFO_EXT'))
BEGIN
ALTER TABLE dbo.AINFO_EXT ADD
	FLDID31 varchar(10) NULL
END
GO


IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'VALUEID31' AND Object_ID = Object_ID(N'AINFO_EXT'))
BEGIN
ALTER TABLE dbo.AINFO_EXT ADD
	VALUEID31 varchar(15) NULL
END
GO


IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'VALUEDESC31' AND Object_ID = Object_ID(N'AINFO_EXT'))
BEGIN
ALTER TABLE dbo.AINFO_EXT ADD
	VALUEDESC31 varchar(8000) NULL
END
GO


IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'FLDID32' AND Object_ID = Object_ID(N'AINFO_EXT'))
BEGIN
ALTER TABLE dbo.AINFO_EXT ADD
	FLDID32 varchar(10) NULL
END
GO


IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'VALUEID32' AND Object_ID = Object_ID(N'AINFO_EXT'))
BEGIN
ALTER TABLE dbo.AINFO_EXT ADD
	VALUEID32 varchar(15) NULL
END
GO


IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'VALUEDESC32' AND Object_ID = Object_ID(N'AINFO_EXT'))
BEGIN
ALTER TABLE dbo.AINFO_EXT ADD
	VALUEDESC32 varchar(8000) NULL
END
GO


IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'FLDID33' AND Object_ID = Object_ID(N'AINFO_EXT'))
BEGIN
ALTER TABLE dbo.AINFO_EXT ADD
	FLDID33 varchar(10) NULL
END
GO


IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'VALUEID33' AND Object_ID = Object_ID(N'AINFO_EXT'))
BEGIN
ALTER TABLE dbo.AINFO_EXT ADD
	VALUEID33 varchar(15) NULL
END
GO


IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'VALUEDESC33' AND Object_ID = Object_ID(N'AINFO_EXT'))
BEGIN
ALTER TABLE dbo.AINFO_EXT ADD
	VALUEDESC33 varchar(8000) NULL
END
GO


IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'FLDID34' AND Object_ID = Object_ID(N'AINFO_EXT'))
BEGIN
ALTER TABLE dbo.AINFO_EXT ADD
	FLDID34 varchar(10) NULL
END
GO


IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'VALUEID34' AND Object_ID = Object_ID(N'AINFO_EXT'))
BEGIN
ALTER TABLE dbo.AINFO_EXT ADD
	VALUEID34 varchar(15) NULL
END
GO


IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'VALUEDESC34' AND Object_ID = Object_ID(N'AINFO_EXT'))
BEGIN
ALTER TABLE dbo.AINFO_EXT ADD
	VALUEDESC34 varchar(8000) NULL
END
GO


IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'FLDID35' AND Object_ID = Object_ID(N'AINFO_EXT'))
BEGIN
ALTER TABLE dbo.AINFO_EXT ADD
	FLDID35 varchar(10) NULL
END
GO


IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'VALUEID35' AND Object_ID = Object_ID(N'AINFO_EXT'))
BEGIN
ALTER TABLE dbo.AINFO_EXT ADD
	VALUEID35 varchar(15) NULL
END
GO


IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'VALUEDESC35' AND Object_ID = Object_ID(N'AINFO_EXT'))
BEGIN
ALTER TABLE dbo.AINFO_EXT ADD
	VALUEDESC35 varchar(8000) NULL
END
GO


IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'FLDID36' AND Object_ID = Object_ID(N'AINFO_EXT'))
BEGIN
ALTER TABLE dbo.AINFO_EXT ADD
	FLDID36 varchar(10) NULL
END
GO


IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'VALUEID36' AND Object_ID = Object_ID(N'AINFO_EXT'))
BEGIN
ALTER TABLE dbo.AINFO_EXT ADD
	VALUEID36 varchar(15) NULL
END
GO


IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'VALUEDESC36' AND Object_ID = Object_ID(N'AINFO_EXT'))
BEGIN
ALTER TABLE dbo.AINFO_EXT ADD
	VALUEDESC36 varchar(8000) NULL
END
GO


IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'FLDID37' AND Object_ID = Object_ID(N'AINFO_EXT'))
BEGIN
ALTER TABLE dbo.AINFO_EXT ADD
	FLDID37 varchar(10) NULL
END
GO


IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'VALUEID37' AND Object_ID = Object_ID(N'AINFO_EXT'))
BEGIN
ALTER TABLE dbo.AINFO_EXT ADD
	VALUEID37 varchar(15) NULL
END
GO


IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'VALUEDESC37' AND Object_ID = Object_ID(N'AINFO_EXT'))
BEGIN
ALTER TABLE dbo.AINFO_EXT ADD
	VALUEDESC37 varchar(8000) NULL
END
GO


IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'FLDID38' AND Object_ID = Object_ID(N'AINFO_EXT'))
BEGIN
ALTER TABLE dbo.AINFO_EXT ADD
	FLDID38 varchar(10) NULL
END
GO


IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'VALUEID38' AND Object_ID = Object_ID(N'AINFO_EXT'))
BEGIN
ALTER TABLE dbo.AINFO_EXT ADD
	VALUEID38 varchar(15) NULL
END
GO


IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'VALUEDESC38' AND Object_ID = Object_ID(N'AINFO_EXT'))
BEGIN
ALTER TABLE dbo.AINFO_EXT ADD
	VALUEDESC38 varchar(8000) NULL
END
GO


IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'FLDID39' AND Object_ID = Object_ID(N'AINFO_EXT'))
BEGIN
ALTER TABLE dbo.AINFO_EXT ADD
	FLDID39 varchar(10) NULL
END
GO


IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'VALUEID39' AND Object_ID = Object_ID(N'AINFO_EXT'))
BEGIN
ALTER TABLE dbo.AINFO_EXT ADD
	VALUEID39 varchar(15) NULL
END
GO


IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'VALUEDESC39' AND Object_ID = Object_ID(N'AINFO_EXT'))
BEGIN
ALTER TABLE dbo.AINFO_EXT ADD
	VALUEDESC39 varchar(8000) NULL
END
GO


IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'FLDID40' AND Object_ID = Object_ID(N'AINFO_EXT'))
BEGIN
ALTER TABLE dbo.AINFO_EXT ADD
	FLDID40 varchar(10) NULL
END
GO


IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'VALUEID40' AND Object_ID = Object_ID(N'AINFO_EXT'))
BEGIN
ALTER TABLE dbo.AINFO_EXT ADD
	VALUEID40 varchar(15) NULL
END
GO


IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'VALUEDESC40' AND Object_ID = Object_ID(N'AINFO_EXT'))
BEGIN
ALTER TABLE dbo.AINFO_EXT ADD
	VALUEDESC40 varchar(8000) NULL
END
GO


IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'FLDID41' AND Object_ID = Object_ID(N'AINFO_EXT'))
BEGIN
ALTER TABLE dbo.AINFO_EXT ADD
	FLDID41 varchar(10) NULL
END
GO


IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'VALUEID41' AND Object_ID = Object_ID(N'AINFO_EXT'))
BEGIN
ALTER TABLE dbo.AINFO_EXT ADD
	VALUEID41 varchar(15) NULL
END
GO


IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'VALUEDESC41' AND Object_ID = Object_ID(N'AINFO_EXT'))
BEGIN
ALTER TABLE dbo.AINFO_EXT ADD
	VALUEDESC41 varchar(8000) NULL
END
GO


IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'FLDID42' AND Object_ID = Object_ID(N'AINFO_EXT'))
BEGIN
ALTER TABLE dbo.AINFO_EXT ADD
	FLDID42 varchar(10) NULL
END
GO


IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'VALUEID42' AND Object_ID = Object_ID(N'AINFO_EXT'))
BEGIN
ALTER TABLE dbo.AINFO_EXT ADD
	VALUEID42 varchar(15) NULL
END
GO


IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'VALUEDESC42' AND Object_ID = Object_ID(N'AINFO_EXT'))
BEGIN
ALTER TABLE dbo.AINFO_EXT ADD
	VALUEDESC42 varchar(8000) NULL
END
GO


IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'FLDID43' AND Object_ID = Object_ID(N'AINFO_EXT'))
BEGIN
ALTER TABLE dbo.AINFO_EXT ADD
	FLDID43 varchar(10) NULL
END
GO


IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'VALUEID43' AND Object_ID = Object_ID(N'AINFO_EXT'))
BEGIN
ALTER TABLE dbo.AINFO_EXT ADD
	VALUEID43 varchar(15) NULL
END
GO


IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'VALUEDESC43' AND Object_ID = Object_ID(N'AINFO_EXT'))
BEGIN
ALTER TABLE dbo.AINFO_EXT ADD
	VALUEDESC43 varchar(8000) NULL
END
GO


IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'FLDID44' AND Object_ID = Object_ID(N'AINFO_EXT'))
BEGIN
ALTER TABLE dbo.AINFO_EXT ADD
	FLDID44 varchar(10) NULL
END
GO


IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'VALUEID44' AND Object_ID = Object_ID(N'AINFO_EXT'))
BEGIN
ALTER TABLE dbo.AINFO_EXT ADD
	VALUEID44 varchar(15) NULL
END
GO


IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'VALUEDESC44' AND Object_ID = Object_ID(N'AINFO_EXT'))
BEGIN
ALTER TABLE dbo.AINFO_EXT ADD
	VALUEDESC44 varchar(8000) NULL
END
GO


IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'FLDID45' AND Object_ID = Object_ID(N'AINFO_EXT'))
BEGIN
ALTER TABLE dbo.AINFO_EXT ADD
	FLDID45 varchar(10) NULL
END
GO


IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'VALUEID45' AND Object_ID = Object_ID(N'AINFO_EXT'))
BEGIN
ALTER TABLE dbo.AINFO_EXT ADD
	VALUEID45 varchar(15) NULL
END
GO


IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'VALUEDESC45' AND Object_ID = Object_ID(N'AINFO_EXT'))
BEGIN
ALTER TABLE dbo.AINFO_EXT ADD
	VALUEDESC45 varchar(8000) NULL
END
GO


EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'AINFO_EXT', @level2type=N'COLUMN',@level2name=N'FLDID31'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'AINFO_EXT', @level2type=N'COLUMN',@level2name=N'VALUEID31'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'AINFO_EXT', @level2type=N'COLUMN',@level2name=N'VALUEDESC31'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'AINFO_EXT', @level2type=N'COLUMN',@level2name=N'FLDID32'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'AINFO_EXT', @level2type=N'COLUMN',@level2name=N'VALUEID32'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'AINFO_EXT', @level2type=N'COLUMN',@level2name=N'VALUEDESC32'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'AINFO_EXT', @level2type=N'COLUMN',@level2name=N'FLDID33'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'AINFO_EXT', @level2type=N'COLUMN',@level2name=N'VALUEID33'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'AINFO_EXT', @level2type=N'COLUMN',@level2name=N'VALUEDESC33'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'AINFO_EXT', @level2type=N'COLUMN',@level2name=N'FLDID34'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'AINFO_EXT', @level2type=N'COLUMN',@level2name=N'VALUEID34'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'AINFO_EXT', @level2type=N'COLUMN',@level2name=N'VALUEDESC34'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'AINFO_EXT', @level2type=N'COLUMN',@level2name=N'FLDID35'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'AINFO_EXT', @level2type=N'COLUMN',@level2name=N'VALUEID35'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'AINFO_EXT', @level2type=N'COLUMN',@level2name=N'VALUEDESC35'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'AINFO_EXT', @level2type=N'COLUMN',@level2name=N'FLDID36'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'AINFO_EXT', @level2type=N'COLUMN',@level2name=N'VALUEID36'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'AINFO_EXT', @level2type=N'COLUMN',@level2name=N'VALUEDESC36'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'AINFO_EXT', @level2type=N'COLUMN',@level2name=N'FLDID37'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'AINFO_EXT', @level2type=N'COLUMN',@level2name=N'VALUEID37'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'AINFO_EXT', @level2type=N'COLUMN',@level2name=N'VALUEDESC37'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'AINFO_EXT', @level2type=N'COLUMN',@level2name=N'FLDID38'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'AINFO_EXT', @level2type=N'COLUMN',@level2name=N'VALUEID38'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'AINFO_EXT', @level2type=N'COLUMN',@level2name=N'VALUEDESC38'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'AINFO_EXT', @level2type=N'COLUMN',@level2name=N'FLDID39'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'AINFO_EXT', @level2type=N'COLUMN',@level2name=N'VALUEID39'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'AINFO_EXT', @level2type=N'COLUMN',@level2name=N'VALUEDESC39'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'AINFO_EXT', @level2type=N'COLUMN',@level2name=N'FLDID40'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'AINFO_EXT', @level2type=N'COLUMN',@level2name=N'VALUEID40'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'AINFO_EXT', @level2type=N'COLUMN',@level2name=N'VALUEDESC40'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'AINFO_EXT', @level2type=N'COLUMN',@level2name=N'FLDID41'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'AINFO_EXT', @level2type=N'COLUMN',@level2name=N'VALUEID41'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'AINFO_EXT', @level2type=N'COLUMN',@level2name=N'VALUEDESC41'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'AINFO_EXT', @level2type=N'COLUMN',@level2name=N'FLDID42'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'AINFO_EXT', @level2type=N'COLUMN',@level2name=N'VALUEID42'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'AINFO_EXT', @level2type=N'COLUMN',@level2name=N'VALUEDESC42'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'AINFO_EXT', @level2type=N'COLUMN',@level2name=N'FLDID43'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'AINFO_EXT', @level2type=N'COLUMN',@level2name=N'VALUEID43'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'AINFO_EXT', @level2type=N'COLUMN',@level2name=N'VALUEDESC43'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'AINFO_EXT', @level2type=N'COLUMN',@level2name=N'FLDID44'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'AINFO_EXT', @level2type=N'COLUMN',@level2name=N'VALUEID44'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'AINFO_EXT', @level2type=N'COLUMN',@level2name=N'VALUEDESC44'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'AINFO_EXT', @level2type=N'COLUMN',@level2name=N'FLDID45'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'AINFO_EXT', @level2type=N'COLUMN',@level2name=N'VALUEID45'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'AINFO_EXT', @level2type=N'COLUMN',@level2name=N'VALUEDESC45'
GO





/* To prevent any potential data loss issues, you should review this script in detail before running it outside the context of the database designer.*/
BEGIN TRANSACTION
SET QUOTED_IDENTIFIER ON
SET ARITHABORT ON
SET NUMERIC_ROUNDABORT OFF
SET CONCAT_NULL_YIELDS_NULL ON
SET ANSI_NULLS ON
SET ANSI_PADDING ON
SET ANSI_WARNINGS ON
COMMIT


IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'FLDID31' AND Object_ID = Object_ID(N'TOC'))
BEGIN
ALTER TABLE dbo.TOC ADD
	FLDID31 varchar(10) NULL
END
GO

IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'FLDTAG31' AND Object_ID = Object_ID(N'TOC'))
BEGIN
ALTER TABLE dbo.TOC ADD
	FLDTAG31 varchar(30) NULL
END
GO

IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'FLDTAGA31' AND Object_ID = Object_ID(N'TOC'))
BEGIN
ALTER TABLE dbo.TOC ADD
	FLDTAGA31 varchar(30) NULL
END
GO

IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'FLDID32' AND Object_ID = Object_ID(N'TOC'))
BEGIN
ALTER TABLE dbo.TOC ADD
	FLDID32 varchar(10) NULL
END
GO

IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'FLDTAG32' AND Object_ID = Object_ID(N'TOC'))
BEGIN
ALTER TABLE dbo.TOC ADD
	FLDTAG32 varchar(30) NULL
END
GO

IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'FLDTAGA32' AND Object_ID = Object_ID(N'TOC'))
BEGIN
ALTER TABLE dbo.TOC ADD
	FLDTAGA32 varchar(30) NULL
END
GO

IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'FLDID33' AND Object_ID = Object_ID(N'TOC'))
BEGIN
ALTER TABLE dbo.TOC ADD
	FLDID33 varchar(10) NULL
END
GO

IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'FLDTAG33' AND Object_ID = Object_ID(N'TOC'))
BEGIN
ALTER TABLE dbo.TOC ADD
	FLDTAG33 varchar(30) NULL
END
GO

IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'FLDTAGA33' AND Object_ID = Object_ID(N'TOC'))
BEGIN
ALTER TABLE dbo.TOC ADD
	FLDTAGA33 varchar(30) NULL
END
GO

IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'FLDID34' AND Object_ID = Object_ID(N'TOC'))
BEGIN
ALTER TABLE dbo.TOC ADD
	FLDID34 varchar(10) NULL
END
GO

IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'FLDTAG34' AND Object_ID = Object_ID(N'TOC'))
BEGIN
ALTER TABLE dbo.TOC ADD
	FLDTAG34 varchar(30) NULL
END
GO

IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'FLDTAGA34' AND Object_ID = Object_ID(N'TOC'))
BEGIN
ALTER TABLE dbo.TOC ADD
	FLDTAGA34 varchar(30) NULL
END
GO

IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'FLDID35' AND Object_ID = Object_ID(N'TOC'))
BEGIN
ALTER TABLE dbo.TOC ADD
	FLDID35 varchar(10) NULL
END
GO

IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'FLDTAG35' AND Object_ID = Object_ID(N'TOC'))
BEGIN
ALTER TABLE dbo.TOC ADD
	FLDTAG35 varchar(30) NULL
END
GO

IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'FLDTAGA35' AND Object_ID = Object_ID(N'TOC'))
BEGIN
ALTER TABLE dbo.TOC ADD
	FLDTAGA35 varchar(30) NULL
END
GO

IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'FLDID36' AND Object_ID = Object_ID(N'TOC'))
BEGIN
ALTER TABLE dbo.TOC ADD
	FLDID36 varchar(10) NULL
END
GO

IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'FLDTAG36' AND Object_ID = Object_ID(N'TOC'))
BEGIN
ALTER TABLE dbo.TOC ADD
	FLDTAG36 varchar(30) NULL
END
GO

IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'FLDTAGA36' AND Object_ID = Object_ID(N'TOC'))
BEGIN
ALTER TABLE dbo.TOC ADD
	FLDTAGA36 varchar(30) NULL
END
GO

IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'FLDID37' AND Object_ID = Object_ID(N'TOC'))
BEGIN
ALTER TABLE dbo.TOC ADD
	FLDID37 varchar(10) NULL
END
GO

IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'FLDTAG37' AND Object_ID = Object_ID(N'TOC'))
BEGIN
ALTER TABLE dbo.TOC ADD
	FLDTAG37 varchar(30) NULL
END
GO

IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'FLDTAGA37' AND Object_ID = Object_ID(N'TOC'))
BEGIN
ALTER TABLE dbo.TOC ADD
	FLDTAGA37 varchar(30) NULL
END
GO

IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'FLDID38' AND Object_ID = Object_ID(N'TOC'))
BEGIN
ALTER TABLE dbo.TOC ADD
	FLDID38 varchar(10) NULL
END
GO

IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'FLDTAG38' AND Object_ID = Object_ID(N'TOC'))
BEGIN
ALTER TABLE dbo.TOC ADD
	FLDTAG38 varchar(30) NULL
END
GO

IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'FLDTAGA38' AND Object_ID = Object_ID(N'TOC'))
BEGIN
ALTER TABLE dbo.TOC ADD
	FLDTAGA38 varchar(30) NULL
END
GO

IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'FLDID39' AND Object_ID = Object_ID(N'TOC'))
BEGIN
ALTER TABLE dbo.TOC ADD
	FLDID39 varchar(10) NULL
END
GO

IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'FLDTAG39' AND Object_ID = Object_ID(N'TOC'))
BEGIN
ALTER TABLE dbo.TOC ADD
	FLDTAG39 varchar(30) NULL
END
GO

IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'FLDTAGA39' AND Object_ID = Object_ID(N'TOC'))
BEGIN
ALTER TABLE dbo.TOC ADD
	FLDTAGA39 varchar(30) NULL
END
GO

IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'FLDID40' AND Object_ID = Object_ID(N'TOC'))
BEGIN
ALTER TABLE dbo.TOC ADD
	FLDID40 varchar(10) NULL
END
GO

IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'FLDTAG40' AND Object_ID = Object_ID(N'TOC'))
BEGIN
ALTER TABLE dbo.TOC ADD
	FLDTAG40 varchar(30) NULL
END
GO

IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'FLDTAGA40' AND Object_ID = Object_ID(N'TOC'))
BEGIN
ALTER TABLE dbo.TOC ADD
	FLDTAGA40 varchar(30) NULL
END
GO

IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'FLDID41' AND Object_ID = Object_ID(N'TOC'))
BEGIN
ALTER TABLE dbo.TOC ADD
	FLDID41 varchar(10) NULL
END
GO

IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'FLDTAG41' AND Object_ID = Object_ID(N'TOC'))
BEGIN
ALTER TABLE dbo.TOC ADD
	FLDTAG41 varchar(30) NULL
END
GO

IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'FLDTAGA41' AND Object_ID = Object_ID(N'TOC'))
BEGIN
ALTER TABLE dbo.TOC ADD
	FLDTAGA41 varchar(30) NULL
END
GO

IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'FLDID42' AND Object_ID = Object_ID(N'TOC'))
BEGIN
ALTER TABLE dbo.TOC ADD
	FLDID42 varchar(10) NULL
END
GO

IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'FLDTAG42' AND Object_ID = Object_ID(N'TOC'))
BEGIN
ALTER TABLE dbo.TOC ADD
	FLDTAG42 varchar(30) NULL
END
GO

IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'FLDTAGA42' AND Object_ID = Object_ID(N'TOC'))
BEGIN
ALTER TABLE dbo.TOC ADD
	FLDTAGA42 varchar(30) NULL
END
GO

IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'FLDID43' AND Object_ID = Object_ID(N'TOC'))
BEGIN
ALTER TABLE dbo.TOC ADD
	FLDID43 varchar(10) NULL
END
GO

IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'FLDTAG43' AND Object_ID = Object_ID(N'TOC'))
BEGIN
ALTER TABLE dbo.TOC ADD
	FLDTAG43 varchar(30) NULL
END
GO

IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'FLDTAGA43' AND Object_ID = Object_ID(N'TOC'))
BEGIN
ALTER TABLE dbo.TOC ADD
	FLDTAGA43 varchar(30) NULL
END
GO

IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'FLDID44' AND Object_ID = Object_ID(N'TOC'))
BEGIN
ALTER TABLE dbo.TOC ADD
	FLDID44 varchar(10) NULL
END
GO

IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'FLDTAG44' AND Object_ID = Object_ID(N'TOC'))
BEGIN
ALTER TABLE dbo.TOC ADD
	FLDTAG44 varchar(30) NULL
END
GO

IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'FLDTAGA44' AND Object_ID = Object_ID(N'TOC'))
BEGIN
ALTER TABLE dbo.TOC ADD
	FLDTAGA44 varchar(30) NULL
END
GO

IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'FLDID45' AND Object_ID = Object_ID(N'TOC'))
BEGIN
ALTER TABLE dbo.TOC ADD
	FLDID45 varchar(10) NULL
END
GO

IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'FLDTAG45' AND Object_ID = Object_ID(N'TOC'))
BEGIN
ALTER TABLE dbo.TOC ADD
	FLDTAG45 varchar(30) NULL
END
GO

IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'FLDTAGA45' AND Object_ID = Object_ID(N'TOC'))
BEGIN
ALTER TABLE dbo.TOC ADD
	FLDTAGA45 varchar(30) NULL
END
GO




EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TOC', @level2type=N'COLUMN',@level2name=N'FLDID31'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TOC', @level2type=N'COLUMN',@level2name=N'FLDTAG31'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TOC', @level2type=N'COLUMN',@level2name=N'FLDTAGA31'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TOC', @level2type=N'COLUMN',@level2name=N'FLDID32'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TOC', @level2type=N'COLUMN',@level2name=N'FLDTAG32'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TOC', @level2type=N'COLUMN',@level2name=N'FLDTAGA32'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TOC', @level2type=N'COLUMN',@level2name=N'FLDID33'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TOC', @level2type=N'COLUMN',@level2name=N'FLDTAG33'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TOC', @level2type=N'COLUMN',@level2name=N'FLDTAGA33'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TOC', @level2type=N'COLUMN',@level2name=N'FLDID34'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TOC', @level2type=N'COLUMN',@level2name=N'FLDTAG34'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TOC', @level2type=N'COLUMN',@level2name=N'FLDTAGA34'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TOC', @level2type=N'COLUMN',@level2name=N'FLDID35'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TOC', @level2type=N'COLUMN',@level2name=N'FLDTAG35'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TOC', @level2type=N'COLUMN',@level2name=N'FLDTAGA35'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TOC', @level2type=N'COLUMN',@level2name=N'FLDID36'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TOC', @level2type=N'COLUMN',@level2name=N'FLDTAG36'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TOC', @level2type=N'COLUMN',@level2name=N'FLDTAGA36'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TOC', @level2type=N'COLUMN',@level2name=N'FLDID37'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TOC', @level2type=N'COLUMN',@level2name=N'FLDTAG37'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TOC', @level2type=N'COLUMN',@level2name=N'FLDTAGA37'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TOC', @level2type=N'COLUMN',@level2name=N'FLDID38'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TOC', @level2type=N'COLUMN',@level2name=N'FLDTAG38'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TOC', @level2type=N'COLUMN',@level2name=N'FLDTAGA38'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TOC', @level2type=N'COLUMN',@level2name=N'FLDID39'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TOC', @level2type=N'COLUMN',@level2name=N'FLDTAG39'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TOC', @level2type=N'COLUMN',@level2name=N'FLDTAGA39'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TOC', @level2type=N'COLUMN',@level2name=N'FLDID40'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TOC', @level2type=N'COLUMN',@level2name=N'FLDTAG40'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TOC', @level2type=N'COLUMN',@level2name=N'FLDTAGA40'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TOC', @level2type=N'COLUMN',@level2name=N'FLDID41'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TOC', @level2type=N'COLUMN',@level2name=N'FLDTAG41'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TOC', @level2type=N'COLUMN',@level2name=N'FLDTAGA41'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TOC', @level2type=N'COLUMN',@level2name=N'FLDID42'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TOC', @level2type=N'COLUMN',@level2name=N'FLDTAG42'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TOC', @level2type=N'COLUMN',@level2name=N'FLDTAGA42'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TOC', @level2type=N'COLUMN',@level2name=N'FLDID43'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TOC', @level2type=N'COLUMN',@level2name=N'FLDTAG43'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TOC', @level2type=N'COLUMN',@level2name=N'FLDTAGA43'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TOC', @level2type=N'COLUMN',@level2name=N'FLDID44'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TOC', @level2type=N'COLUMN',@level2name=N'FLDTAG44'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TOC', @level2type=N'COLUMN',@level2name=N'FLDTAGA44'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TOC', @level2type=N'COLUMN',@level2name=N'FLDID45'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TOC', @level2type=N'COLUMN',@level2name=N'FLDTAG45'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TOC', @level2type=N'COLUMN',@level2name=N'FLDTAGA45'
GO



DROP PROCEDURE QTOC_EXT_GENHTAB 
GO
CREATE PROCEDURE QTOC_EXT_GENHTAB (@P_TOC AS VARCHAR(25), @P_Segment as varchar(10)='')  
AS         
SELECT  TOP 1         
TOC.FLDID16, TOC.FLDTAG16, TOC.FLDTAGA16, GENHTAB_16.FLDTAB AS FLDTAB16, GENHTAB_16.FLDCOM AS FLDCOM16, GENHTAB_16.FLDCOMA AS FLDCOMA16, GENHTAB_16.FLDDFORMAT AS FLDDFORMAT16, GENHTAB_16.FLDIFORMAT AS FLDIFORMAT16, GENHTAB_16.FLDTYPE AS FLDTYPE16, GENHTAB_16.SUBLINKF AS SUBLINKF16,  GENHTAB_16.FLDSEARCH AS FLDSEARCH16, GENHTAB_16.FLDCRITERIA AS FLDCRITERIA16, GENHTAB_16.FLDCHGINF as FLDCHGINF16, GENHTAB_16.FLDLOWER as FLDLOWER16, GENHTAB_16.FLDUPPER as FLDUPPER16, GENHTAB_16.FLDREGEX as FLDREGEX16, GENHTAB_16.FLDFUNC as FLDFUNC16, GENHTAB_16.FLDMAP as FLDMAP16, CASE WHEN GENHTAB_16.FLDID1<>'' Then Cast(1 as Bit) else Cast(0 as Bit) end as SpreadInfoF16,
TOC.FLDID17, TOC.FLDTAG17, TOC.FLDTAGA17, GENHTAB_17.FLDTAB AS FLDTAB17, GENHTAB_17.FLDCOM AS FLDCOM17, GENHTAB_17.FLDCOMA AS FLDCOMA17, GENHTAB_17.FLDDFORMAT AS FLDDFORMAT17, GENHTAB_17.FLDIFORMAT AS FLDIFORMAT17, GENHTAB_17.FLDTYPE AS FLDTYPE17, GENHTAB_17.SUBLINKF AS SUBLINKF17,  GENHTAB_17.FLDSEARCH AS FLDSEARCH17, GENHTAB_17.FLDCRITERIA AS FLDCRITERIA17, GENHTAB_17.FLDCHGINF as FLDCHGINF17, GENHTAB_17.FLDLOWER as FLDLOWER17, GENHTAB_17.FLDUPPER as FLDUPPER17, GENHTAB_17.FLDREGEX as FLDREGEX17, GENHTAB_17.FLDFUNC as FLDFUNC17, GENHTAB_17.FLDMAP as FLDMAP17, CASE WHEN GENHTAB_17.FLDID1<>'' Then Cast(1 as Bit) else Cast(0 as Bit) end as SpreadInfoF17,
TOC.FLDID18, TOC.FLDTAG18, TOC.FLDTAGA18, GENHTAB_18.FLDTAB AS FLDTAB18, GENHTAB_18.FLDCOM AS FLDCOM18, GENHTAB_19.FLDCOMA AS FLDCOMA18, GENHTAB_18.FLDDFORMAT AS FLDDFORMAT18, GENHTAB_18.FLDIFORMAT AS FLDIFORMAT18, GENHTAB_18.FLDTYPE AS FLDTYPE18, GENHTAB_18.SUBLINKF AS SUBLINKF18,  GENHTAB_18.FLDSEARCH AS FLDSEARCH18, GENHTAB_18.FLDCRITERIA AS FLDCRITERIA18, GENHTAB_18.FLDCHGINF as FLDCHGINF18, GENHTAB_18.FLDLOWER as FLDLOWER18, GENHTAB_18.FLDUPPER as FLDUPPER18, GENHTAB_18.FLDREGEX as FLDREGEX18, GENHTAB_18.FLDFUNC as FLDFUNC18, GENHTAB_18.FLDMAP as FLDMAP18, CASE WHEN GENHTAB_18.FLDID1<>'' Then Cast(1 as Bit) else Cast(0 as Bit) end as SpreadInfoF18,
TOC.FLDID19, TOC.FLDTAG19, TOC.FLDTAGA19, GENHTAB_19.FLDTAB AS FLDTAB19, GENHTAB_19.FLDCOM AS FLDCOM19, GENHTAB_19.FLDCOMA AS FLDCOMA19, GENHTAB_19.FLDDFORMAT AS FLDDFORMAT19, GENHTAB_19.FLDIFORMAT AS FLDIFORMAT19, GENHTAB_19.FLDTYPE AS FLDTYPE19, GENHTAB_19.SUBLINKF AS SUBLINKF19,  GENHTAB_19.FLDSEARCH AS FLDSEARCH19, GENHTAB_19.FLDCRITERIA AS FLDCRITERIA19, GENHTAB_19.FLDCHGINF as FLDCHGINF19, GENHTAB_19.FLDLOWER as FLDLOWER19, GENHTAB_19.FLDUPPER as FLDUPPER19, GENHTAB_19.FLDREGEX as FLDREGEX19, GENHTAB_19.FLDFUNC as FLDFUNC19, GENHTAB_19.FLDMAP as FLDMAP10, CASE WHEN GENHTAB_19.FLDID1<>'' Then Cast(1 as Bit) else Cast(0 as Bit) end as SpreadInfoF19,
TOC.FLDID20, TOC.FLDTAG20, TOC.FLDTAGA20, GENHTAB_20.FLDTAB AS FLDTAB20, GENHTAB_20.FLDCOM AS FLDCOM20, GENHTAB_20.FLDCOMA AS FLDCOMA20, GENHTAB_20.FLDDFORMAT AS FLDDFORMAT20, GENHTAB_20.FLDIFORMAT AS FLDIFORMAT20, GENHTAB_20.FLDTYPE AS FLDTYPE20, GENHTAB_20.SUBLINKF AS SUBLINKF20,  GENHTAB_20.FLDSEARCH AS FLDSEARCH20, GENHTAB_20.FLDCRITERIA AS FLDCRITERIA20, GENHTAB_20.FLDCHGINF as FLDCHGINF20, GENHTAB_20.FLDLOWER as FLDLOWER20, GENHTAB_20.FLDUPPER as FLDUPPER20, GENHTAB_20.FLDREGEX as FLDREGEX20, GENHTAB_20.FLDFUNC as FLDFUNC20, GENHTAB_20.FLDMAP as FLDMAP20, CASE WHEN GENHTAB_20.FLDID1<>'' Then Cast(1 as Bit) else Cast(0 as Bit) end as SpreadInfoF20,
TOC.FLDID21, TOC.FLDTAG21, TOC.FLDTAGA21, GENHTAB_21.FLDTAB AS FLDTAB21, GENHTAB_21.FLDCOM AS FLDCOM21, GENHTAB_21.FLDCOMA AS FLDCOMA21, GENHTAB_21.FLDDFORMAT AS FLDDFORMAT21, GENHTAB_21.FLDIFORMAT AS FLDIFORMAT21, GENHTAB_21.FLDTYPE AS FLDTYPE21, GENHTAB_21.SUBLINKF AS SUBLINKF21,  GENHTAB_21.FLDSEARCH AS FLDSEARCH21, GENHTAB_21.FLDCRITERIA AS FLDCRITERIA21, GENHTAB_21.FLDCHGINF as FLDCHGINF21, GENHTAB_21.FLDLOWER as FLDLOWER21, GENHTAB_21.FLDUPPER as FLDUPPER21, GENHTAB_21.FLDREGEX as FLDREGEX21, GENHTAB_21.FLDFUNC as FLDFUNC21, GENHTAB_21.FLDMAP as FLDMAP21, CASE WHEN GENHTAB_21.FLDID1<>'' Then Cast(1 as Bit) else Cast(0 as Bit) end as SpreadInfoF21,
TOC.FLDID22, TOC.FLDTAG22, TOC.FLDTAGA22, GENHTAB_22.FLDTAB AS FLDTAB22, GENHTAB_22.FLDCOM AS FLDCOM22, GENHTAB_22.FLDCOMA AS FLDCOMA22, GENHTAB_22.FLDDFORMAT AS FLDDFORMAT22, GENHTAB_22.FLDIFORMAT AS FLDIFORMAT22, GENHTAB_22.FLDTYPE AS FLDTYPE22, GENHTAB_22.SUBLINKF AS SUBLINKF22,  GENHTAB_22.FLDSEARCH AS FLDSEARCH22, GENHTAB_22.FLDCRITERIA AS FLDCRITERIA22, GENHTAB_22.FLDCHGINF as FLDCHGINF22, GENHTAB_22.FLDLOWER as FLDLOWER22, GENHTAB_22.FLDUPPER as FLDUPPER22, GENHTAB_22.FLDREGEX as FLDREGEX22, GENHTAB_22.FLDFUNC as FLDFUNC22, GENHTAB_22.FLDMAP as FLDMAP22, CASE WHEN GENHTAB_22.FLDID1<>'' Then Cast(1 as Bit) else Cast(0 as Bit) end as SpreadInfoF22,
TOC.FLDID23, TOC.FLDTAG23, TOC.FLDTAGA23, GENHTAB_23.FLDTAB AS FLDTAB23, GENHTAB_23.FLDCOM AS FLDCOM23, GENHTAB_23.FLDCOMA AS FLDCOMA23, GENHTAB_23.FLDDFORMAT AS FLDDFORMAT23, GENHTAB_23.FLDIFORMAT AS FLDIFORMAT23, GENHTAB_23.FLDTYPE AS FLDTYPE23, GENHTAB_23.SUBLINKF AS SUBLINKF23,  GENHTAB_23.FLDSEARCH AS FLDSEARCH23, GENHTAB_23.FLDCRITERIA AS FLDCRITERIA23, GENHTAB_23.FLDCHGINF as FLDCHGINF23, GENHTAB_23.FLDLOWER as FLDLOWER23, GENHTAB_23.FLDUPPER as FLDUPPER23, GENHTAB_23.FLDREGEX as FLDREGEX23, GENHTAB_23.FLDFUNC as FLDFUNC23, GENHTAB_23.FLDMAP as FLDMAP23, CASE WHEN GENHTAB_23.FLDID1<>'' Then Cast(1 as Bit) else Cast(0 as Bit) end as SpreadInfoF23,
TOC.FLDID24, TOC.FLDTAG24, TOC.FLDTAGA23, GENHTAB_24.FLDTAB AS FLDTAB24, GENHTAB_24.FLDCOM AS FLDCOM24, GENHTAB_24.FLDCOMA AS FLDCOMA24, GENHTAB_24.FLDDFORMAT AS FLDDFORMAT24, GENHTAB_24.FLDIFORMAT AS FLDIFORMAT24, GENHTAB_24.FLDTYPE AS FLDTYPE24, GENHTAB_24.SUBLINKF AS SUBLINKF24,  GENHTAB_24.FLDSEARCH AS FLDSEARCH24, GENHTAB_24.FLDCRITERIA AS FLDCRITERIA24, GENHTAB_24.FLDCHGINF as FLDCHGINF24, GENHTAB_24.FLDLOWER as FLDLOWER24, GENHTAB_24.FLDUPPER as FLDUPPER24, GENHTAB_24.FLDREGEX as FLDREGEX24, GENHTAB_24.FLDFUNC as FLDFUNC24, GENHTAB_24.FLDMAP as FLDMAP24, CASE WHEN GENHTAB_24.FLDID1<>'' Then Cast(1 as Bit) else Cast(0 as Bit) end as SpreadInfoF24,
TOC.FLDID25, TOC.FLDTAG25, TOC.FLDTAGA25, GENHTAB_25.FLDTAB AS FLDTAB25, GENHTAB_25.FLDCOM AS FLDCOM25, GENHTAB_25.FLDCOMA AS FLDCOMA25, GENHTAB_25.FLDDFORMAT AS FLDDFORMAT25, GENHTAB_25.FLDIFORMAT AS FLDIFORMAT25, GENHTAB_25.FLDTYPE AS FLDTYPE25, GENHTAB_25.SUBLINKF AS SUBLINKF25,  GENHTAB_25.FLDSEARCH AS FLDSEARCH25, GENHTAB_25.FLDCRITERIA AS FLDCRITERIA25, GENHTAB_25.FLDCHGINF as FLDCHGINF25, GENHTAB_25.FLDLOWER as FLDLOWER25, GENHTAB_25.FLDUPPER as FLDUPPER25, GENHTAB_25.FLDREGEX as FLDREGEX25, GENHTAB_25.FLDFUNC as FLDFUNC25, GENHTAB_25.FLDMAP as FLDMAP25, CASE WHEN GENHTAB_25.FLDID1<>'' Then Cast(1 as Bit) else Cast(0 as Bit) end as SpreadInfoF25,
TOC.FLDID26, TOC.FLDTAG26, TOC.FLDTAGA26, GENHTAB_26.FLDTAB AS FLDTAB26, GENHTAB_26.FLDCOM AS FLDCOM26, GENHTAB_26.FLDCOMA AS FLDCOMA26, GENHTAB_26.FLDDFORMAT AS FLDDFORMAT26, GENHTAB_26.FLDIFORMAT AS FLDIFORMAT26, GENHTAB_26.FLDTYPE AS FLDTYPE26, GENHTAB_26.SUBLINKF AS SUBLINKF26,  GENHTAB_26.FLDSEARCH AS FLDSEARCH26, GENHTAB_26.FLDCRITERIA AS FLDCRITERIA26, GENHTAB_26.FLDCHGINF as FLDCHGINF26, GENHTAB_26.FLDLOWER as FLDLOWER26, GENHTAB_26.FLDUPPER as FLDUPPER26, GENHTAB_26.FLDREGEX as FLDREGEX26, GENHTAB_26.FLDFUNC as FLDFUNC26, GENHTAB_26.FLDMAP as FLDMAP26, CASE WHEN GENHTAB_26.FLDID1<>'' Then Cast(1 as Bit) else Cast(0 as Bit) end as SpreadInfoF26,
TOC.FLDID27, TOC.FLDTAG27, TOC.FLDTAGA27, GENHTAB_27.FLDTAB AS FLDTAB27, GENHTAB_27.FLDCOM AS FLDCOM27, GENHTAB_27.FLDCOMA AS FLDCOMA27, GENHTAB_27.FLDDFORMAT AS FLDDFORMAT27, GENHTAB_27.FLDIFORMAT AS FLDIFORMAT27, GENHTAB_27.FLDTYPE AS FLDTYPE27, GENHTAB_27.SUBLINKF AS SUBLINKF27,  GENHTAB_27.FLDSEARCH AS FLDSEARCH27, GENHTAB_27.FLDCRITERIA AS FLDCRITERIA27, GENHTAB_27.FLDCHGINF as FLDCHGINF27, GENHTAB_27.FLDLOWER as FLDLOWER27, GENHTAB_27.FLDUPPER as FLDUPPER27, GENHTAB_27.FLDREGEX as FLDREGEX27, GENHTAB_27.FLDFUNC as FLDFUNC27, GENHTAB_27.FLDMAP as FLDMAP27, CASE WHEN GENHTAB_27.FLDID1<>'' Then Cast(1 as Bit) else Cast(0 as Bit) end as SpreadInfoF27,
TOC.FLDID28, TOC.FLDTAG28, TOC.FLDTAGA28, GENHTAB_28.FLDTAB AS FLDTAB28, GENHTAB_28.FLDCOM AS FLDCOM28, GENHTAB_28.FLDCOMA AS FLDCOMA28, GENHTAB_28.FLDDFORMAT AS FLDDFORMAT28, GENHTAB_28.FLDIFORMAT AS FLDIFORMAT28, GENHTAB_28.FLDTYPE AS FLDTYPE28, GENHTAB_28.SUBLINKF AS SUBLINKF28,  GENHTAB_28.FLDSEARCH AS FLDSEARCH28, GENHTAB_28.FLDCRITERIA AS FLDCRITERIA28, GENHTAB_28.FLDCHGINF as FLDCHGINF28, GENHTAB_28.FLDLOWER as FLDLOWER28, GENHTAB_28.FLDUPPER as FLDUPPER28, GENHTAB_28.FLDREGEX as FLDREGEX28, GENHTAB_28.FLDFUNC as FLDFUNC28, GENHTAB_28.FLDMAP as FLDMAP28, CASE WHEN GENHTAB_28.FLDID1<>'' Then Cast(1 as Bit) else Cast(0 as Bit) end as SpreadInfoF28,
TOC.FLDID29, TOC.FLDTAG29, TOC.FLDTAGA29, GENHTAB_29.FLDTAB AS FLDTAB29, GENHTAB_29.FLDCOM AS FLDCOM29, GENHTAB_29.FLDCOMA AS FLDCOMA29, GENHTAB_29.FLDDFORMAT AS FLDDFORMAT29, GENHTAB_29.FLDIFORMAT AS FLDIFORMAT29, GENHTAB_29.FLDTYPE AS FLDTYPE29, GENHTAB_29.SUBLINKF AS SUBLINKF29,  GENHTAB_29.FLDSEARCH AS FLDSEARCH29, GENHTAB_29.FLDCRITERIA AS FLDCRITERIA29, GENHTAB_29.FLDCHGINF as FLDCHGINF29, GENHTAB_29.FLDLOWER as FLDLOWER29, GENHTAB_29.FLDUPPER as FLDUPPER29, GENHTAB_29.FLDREGEX as FLDREGEX29, GENHTAB_29.FLDFUNC as FLDFUNC29, GENHTAB_29.FLDMAP as FLDMAP29, CASE WHEN GENHTAB_29.FLDID1<>'' Then Cast(1 as Bit) else Cast(0 as Bit) end as SpreadInfoF29,
TOC.FLDID30, TOC.FLDTAG30, TOC.FLDTAGA30, GENHTAB_30.FLDTAB AS FLDTAB30, GENHTAB_30.FLDCOM AS FLDCOM30, GENHTAB_30.FLDCOMA AS FLDCOMA30, GENHTAB_30.FLDDFORMAT AS FLDDFORMAT30, GENHTAB_30.FLDIFORMAT AS FLDIFORMAT30, GENHTAB_30.FLDTYPE AS FLDTYPE30, GENHTAB_30.SUBLINKF AS SUBLINKF30,  GENHTAB_30.FLDSEARCH AS FLDSEARCH30, GENHTAB_30.FLDCRITERIA AS FLDCRITERIA30, GENHTAB_30.FLDCHGINF as FLDCHGINF30, GENHTAB_30.FLDLOWER as FLDLOWER30, GENHTAB_30.FLDUPPER as FLDUPPER30, GENHTAB_30.FLDREGEX as FLDREGEX30, GENHTAB_30.FLDFUNC as FLDFUNC30, GENHTAB_30.FLDMAP as FLDMAP30, CASE WHEN GENHTAB_30.FLDID1<>'' Then Cast(1 as Bit) else Cast(0 as Bit) end as SpreadInfoF30,
TOC.FLDID31, TOC.FLDTAG31, TOC.FLDTAGA31, GENHTAB_31.FLDTAB AS FLDTAB31, GENHTAB_31.FLDCOM AS FLDCOM31, GENHTAB_31.FLDCOMA AS FLDCOMA31, GENHTAB_31.FLDDFORMAT AS FLDDFORMAT31, GENHTAB_31.FLDIFORMAT AS FLDIFORMAT31, GENHTAB_31.FLDTYPE AS FLDTYPE31, GENHTAB_31.SUBLINKF AS SUBLINKF31,  GENHTAB_31.FLDSEARCH AS FLDSEARCH31, GENHTAB_31.FLDCRITERIA AS FLDCRITERIA31, GENHTAB_31.FLDCHGINF as FLDCHGINF31, GENHTAB_31.FLDLOWER as FLDLOWER31, GENHTAB_31.FLDUPPER as FLDUPPER31, GENHTAB_31.FLDREGEX as FLDREGEX31, GENHTAB_31.FLDFUNC as FLDFUNC31, GENHTAB_31.FLDMAP as FLDMAP31, CASE WHEN GENHTAB_31.FLDID1<>'' Then Cast(1 as Bit) else Cast(0 as Bit) end as SpreadInfoF31,
TOC.FLDID32, TOC.FLDTAG32, TOC.FLDTAGA32, GENHTAB_32.FLDTAB AS FLDTAB32, GENHTAB_32.FLDCOM AS FLDCOM32, GENHTAB_32.FLDCOMA AS FLDCOMA32, GENHTAB_32.FLDDFORMAT AS FLDDFORMAT32, GENHTAB_32.FLDIFORMAT AS FLDIFORMAT32, GENHTAB_32.FLDTYPE AS FLDTYPE32, GENHTAB_32.SUBLINKF AS SUBLINKF32,  GENHTAB_32.FLDSEARCH AS FLDSEARCH32, GENHTAB_32.FLDCRITERIA AS FLDCRITERIA32, GENHTAB_32.FLDCHGINF as FLDCHGINF32, GENHTAB_32.FLDLOWER as FLDLOWER32, GENHTAB_32.FLDUPPER as FLDUPPER32, GENHTAB_32.FLDREGEX as FLDREGEX32, GENHTAB_32.FLDFUNC as FLDFUNC32, GENHTAB_32.FLDMAP as FLDMAP32, CASE WHEN GENHTAB_32.FLDID1<>'' Then Cast(1 as Bit) else Cast(0 as Bit) end as SpreadInfoF32,
TOC.FLDID33, TOC.FLDTAG33, TOC.FLDTAGA33, GENHTAB_33.FLDTAB AS FLDTAB33, GENHTAB_33.FLDCOM AS FLDCOM33, GENHTAB_33.FLDCOMA AS FLDCOMA33, GENHTAB_33.FLDDFORMAT AS FLDDFORMAT33, GENHTAB_33.FLDIFORMAT AS FLDIFORMAT33, GENHTAB_33.FLDTYPE AS FLDTYPE33, GENHTAB_33.SUBLINKF AS SUBLINKF33,  GENHTAB_33.FLDSEARCH AS FLDSEARCH33, GENHTAB_33.FLDCRITERIA AS FLDCRITERIA33, GENHTAB_33.FLDCHGINF as FLDCHGINF33, GENHTAB_33.FLDLOWER as FLDLOWER33, GENHTAB_33.FLDUPPER as FLDUPPER33, GENHTAB_33.FLDREGEX as FLDREGEX33, GENHTAB_33.FLDFUNC as FLDFUNC33, GENHTAB_33.FLDMAP as FLDMAP33, CASE WHEN GENHTAB_33.FLDID1<>'' Then Cast(1 as Bit) else Cast(0 as Bit) end as SpreadInfoF33,
TOC.FLDID34, TOC.FLDTAG34, TOC.FLDTAGA33, GENHTAB_34.FLDTAB AS FLDTAB34, GENHTAB_34.FLDCOM AS FLDCOM34, GENHTAB_34.FLDCOMA AS FLDCOMA34, GENHTAB_34.FLDDFORMAT AS FLDDFORMAT34, GENHTAB_34.FLDIFORMAT AS FLDIFORMAT34, GENHTAB_34.FLDTYPE AS FLDTYPE34, GENHTAB_34.SUBLINKF AS SUBLINKF34,  GENHTAB_34.FLDSEARCH AS FLDSEARCH34, GENHTAB_34.FLDCRITERIA AS FLDCRITERIA34, GENHTAB_34.FLDCHGINF as FLDCHGINF34, GENHTAB_34.FLDLOWER as FLDLOWER34, GENHTAB_34.FLDUPPER as FLDUPPER34, GENHTAB_34.FLDREGEX as FLDREGEX34, GENHTAB_34.FLDFUNC as FLDFUNC34, GENHTAB_34.FLDMAP as FLDMAP34, CASE WHEN GENHTAB_34.FLDID1<>'' Then Cast(1 as Bit) else Cast(0 as Bit) end as SpreadInfoF34,
TOC.FLDID35, TOC.FLDTAG35, TOC.FLDTAGA35, GENHTAB_35.FLDTAB AS FLDTAB35, GENHTAB_35.FLDCOM AS FLDCOM35, GENHTAB_35.FLDCOMA AS FLDCOMA35, GENHTAB_35.FLDDFORMAT AS FLDDFORMAT35, GENHTAB_35.FLDIFORMAT AS FLDIFORMAT35, GENHTAB_35.FLDTYPE AS FLDTYPE35, GENHTAB_35.SUBLINKF AS SUBLINKF35,  GENHTAB_35.FLDSEARCH AS FLDSEARCH35, GENHTAB_35.FLDCRITERIA AS FLDCRITERIA35, GENHTAB_35.FLDCHGINF as FLDCHGINF35, GENHTAB_35.FLDLOWER as FLDLOWER35, GENHTAB_35.FLDUPPER as FLDUPPER35, GENHTAB_35.FLDREGEX as FLDREGEX35, GENHTAB_35.FLDFUNC as FLDFUNC35, GENHTAB_35.FLDMAP as FLDMAP35, CASE WHEN GENHTAB_35.FLDID1<>'' Then Cast(1 as Bit) else Cast(0 as Bit) end as SpreadInfoF35,
TOC.FLDID36, TOC.FLDTAG36, TOC.FLDTAGA36, GENHTAB_36.FLDTAB AS FLDTAB36, GENHTAB_36.FLDCOM AS FLDCOM36, GENHTAB_36.FLDCOMA AS FLDCOMA36, GENHTAB_36.FLDDFORMAT AS FLDDFORMAT36, GENHTAB_36.FLDIFORMAT AS FLDIFORMAT36, GENHTAB_36.FLDTYPE AS FLDTYPE36, GENHTAB_36.SUBLINKF AS SUBLINKF36,  GENHTAB_36.FLDSEARCH AS FLDSEARCH36, GENHTAB_36.FLDCRITERIA AS FLDCRITERIA36, GENHTAB_36.FLDCHGINF as FLDCHGINF36, GENHTAB_36.FLDLOWER as FLDLOWER36, GENHTAB_36.FLDUPPER as FLDUPPER36, GENHTAB_36.FLDREGEX as FLDREGEX36, GENHTAB_36.FLDFUNC as FLDFUNC36, GENHTAB_36.FLDMAP as FLDMAP36, CASE WHEN GENHTAB_36.FLDID1<>'' Then Cast(1 as Bit) else Cast(0 as Bit) end as SpreadInfoF36,
TOC.FLDID37, TOC.FLDTAG37, TOC.FLDTAGA37, GENHTAB_37.FLDTAB AS FLDTAB37, GENHTAB_37.FLDCOM AS FLDCOM37, GENHTAB_37.FLDCOMA AS FLDCOMA37, GENHTAB_37.FLDDFORMAT AS FLDDFORMAT37, GENHTAB_37.FLDIFORMAT AS FLDIFORMAT37, GENHTAB_37.FLDTYPE AS FLDTYPE37, GENHTAB_37.SUBLINKF AS SUBLINKF37,  GENHTAB_37.FLDSEARCH AS FLDSEARCH37, GENHTAB_37.FLDCRITERIA AS FLDCRITERIA37, GENHTAB_37.FLDCHGINF as FLDCHGINF37, GENHTAB_37.FLDLOWER as FLDLOWER37, GENHTAB_37.FLDUPPER as FLDUPPER37, GENHTAB_37.FLDREGEX as FLDREGEX37, GENHTAB_37.FLDFUNC as FLDFUNC37, GENHTAB_37.FLDMAP as FLDMAP37, CASE WHEN GENHTAB_37.FLDID1<>'' Then Cast(1 as Bit) else Cast(0 as Bit) end as SpreadInfoF37,
TOC.FLDID38, TOC.FLDTAG38, TOC.FLDTAGA38, GENHTAB_38.FLDTAB AS FLDTAB38, GENHTAB_38.FLDCOM AS FLDCOM38, GENHTAB_38.FLDCOMA AS FLDCOMA38, GENHTAB_38.FLDDFORMAT AS FLDDFORMAT38, GENHTAB_38.FLDIFORMAT AS FLDIFORMAT38, GENHTAB_38.FLDTYPE AS FLDTYPE38, GENHTAB_38.SUBLINKF AS SUBLINKF38,  GENHTAB_38.FLDSEARCH AS FLDSEARCH38, GENHTAB_38.FLDCRITERIA AS FLDCRITERIA38, GENHTAB_38.FLDCHGINF as FLDCHGINF38, GENHTAB_38.FLDLOWER as FLDLOWER38, GENHTAB_38.FLDUPPER as FLDUPPER38, GENHTAB_38.FLDREGEX as FLDREGEX38, GENHTAB_38.FLDFUNC as FLDFUNC38, GENHTAB_38.FLDMAP as FLDMAP38, CASE WHEN GENHTAB_38.FLDID1<>'' Then Cast(1 as Bit) else Cast(0 as Bit) end as SpreadInfoF38,
TOC.FLDID39, TOC.FLDTAG39, TOC.FLDTAGA39, GENHTAB_39.FLDTAB AS FLDTAB39, GENHTAB_39.FLDCOM AS FLDCOM39, GENHTAB_39.FLDCOMA AS FLDCOMA39, GENHTAB_39.FLDDFORMAT AS FLDDFORMAT39, GENHTAB_39.FLDIFORMAT AS FLDIFORMAT39, GENHTAB_39.FLDTYPE AS FLDTYPE39, GENHTAB_39.SUBLINKF AS SUBLINKF39,  GENHTAB_39.FLDSEARCH AS FLDSEARCH39, GENHTAB_39.FLDCRITERIA AS FLDCRITERIA39, GENHTAB_39.FLDCHGINF as FLDCHGINF39, GENHTAB_39.FLDLOWER as FLDLOWER39, GENHTAB_39.FLDUPPER as FLDUPPER39, GENHTAB_39.FLDREGEX as FLDREGEX39, GENHTAB_39.FLDFUNC as FLDFUNC39, GENHTAB_39.FLDMAP as FLDMAP39, CASE WHEN GENHTAB_39.FLDID1<>'' Then Cast(1 as Bit) else Cast(0 as Bit) end as SpreadInfoF39,
TOC.FLDID40, TOC.FLDTAG40, TOC.FLDTAGA40, GENHTAB_40.FLDTAB AS FLDTAB40, GENHTAB_40.FLDCOM AS FLDCOM40, GENHTAB_40.FLDCOMA AS FLDCOMA40, GENHTAB_40.FLDDFORMAT AS FLDDFORMAT40, GENHTAB_40.FLDIFORMAT AS FLDIFORMAT40, GENHTAB_40.FLDTYPE AS FLDTYPE40, GENHTAB_40.SUBLINKF AS SUBLINKF40,  GENHTAB_40.FLDSEARCH AS FLDSEARCH40, GENHTAB_40.FLDCRITERIA AS FLDCRITERIA40, GENHTAB_40.FLDCHGINF as FLDCHGINF40, GENHTAB_40.FLDLOWER as FLDLOWER40, GENHTAB_40.FLDUPPER as FLDUPPER40, GENHTAB_40.FLDREGEX as FLDREGEX40, GENHTAB_40.FLDFUNC as FLDFUNC40, GENHTAB_40.FLDMAP as FLDMAP40, CASE WHEN GENHTAB_40.FLDID1<>'' Then Cast(1 as Bit) else Cast(0 as Bit) end as SpreadInfoF40,
TOC.FLDID41, TOC.FLDTAG41, TOC.FLDTAGA41, GENHTAB_41.FLDTAB AS FLDTAB41, GENHTAB_41.FLDCOM AS FLDCOM41, GENHTAB_41.FLDCOMA AS FLDCOMA41, GENHTAB_41.FLDDFORMAT AS FLDDFORMAT41, GENHTAB_41.FLDIFORMAT AS FLDIFORMAT41, GENHTAB_41.FLDTYPE AS FLDTYPE41, GENHTAB_41.SUBLINKF AS SUBLINKF41,  GENHTAB_41.FLDSEARCH AS FLDSEARCH41, GENHTAB_41.FLDCRITERIA AS FLDCRITERIA41, GENHTAB_41.FLDCHGINF as FLDCHGINF41, GENHTAB_41.FLDLOWER as FLDLOWER41, GENHTAB_41.FLDUPPER as FLDUPPER41, GENHTAB_41.FLDREGEX as FLDREGEX41, GENHTAB_41.FLDFUNC as FLDFUNC41, GENHTAB_41.FLDMAP as FLDMAP41, CASE WHEN GENHTAB_41.FLDID1<>'' Then Cast(1 as Bit) else Cast(0 as Bit) end as SpreadInfoF41,
TOC.FLDID42, TOC.FLDTAG42, TOC.FLDTAGA42, GENHTAB_42.FLDTAB AS FLDTAB42, GENHTAB_42.FLDCOM AS FLDCOM42, GENHTAB_42.FLDCOMA AS FLDCOMA42, GENHTAB_42.FLDDFORMAT AS FLDDFORMAT42, GENHTAB_42.FLDIFORMAT AS FLDIFORMAT42, GENHTAB_42.FLDTYPE AS FLDTYPE42, GENHTAB_42.SUBLINKF AS SUBLINKF42,  GENHTAB_42.FLDSEARCH AS FLDSEARCH42, GENHTAB_42.FLDCRITERIA AS FLDCRITERIA42, GENHTAB_42.FLDCHGINF as FLDCHGINF42, GENHTAB_42.FLDLOWER as FLDLOWER42, GENHTAB_42.FLDUPPER as FLDUPPER42, GENHTAB_42.FLDREGEX as FLDREGEX42, GENHTAB_42.FLDFUNC as FLDFUNC42, GENHTAB_42.FLDMAP as FLDMAP42, CASE WHEN GENHTAB_42.FLDID1<>'' Then Cast(1 as Bit) else Cast(0 as Bit) end as SpreadInfoF42,
TOC.FLDID43, TOC.FLDTAG43, TOC.FLDTAGA43, GENHTAB_43.FLDTAB AS FLDTAB43, GENHTAB_43.FLDCOM AS FLDCOM43, GENHTAB_43.FLDCOMA AS FLDCOMA43, GENHTAB_43.FLDDFORMAT AS FLDDFORMAT43, GENHTAB_43.FLDIFORMAT AS FLDIFORMAT43, GENHTAB_43.FLDTYPE AS FLDTYPE43, GENHTAB_43.SUBLINKF AS SUBLINKF43,  GENHTAB_43.FLDSEARCH AS FLDSEARCH43, GENHTAB_43.FLDCRITERIA AS FLDCRITERIA43, GENHTAB_43.FLDCHGINF as FLDCHGINF43, GENHTAB_43.FLDLOWER as FLDLOWER43, GENHTAB_43.FLDUPPER as FLDUPPER43, GENHTAB_43.FLDREGEX as FLDREGEX43, GENHTAB_43.FLDFUNC as FLDFUNC43, GENHTAB_43.FLDMAP as FLDMAP43, CASE WHEN GENHTAB_43.FLDID1<>'' Then Cast(1 as Bit) else Cast(0 as Bit) end as SpreadInfoF43,
TOC.FLDID44, TOC.FLDTAG44, TOC.FLDTAGA44, GENHTAB_44.FLDTAB AS FLDTAB44, GENHTAB_44.FLDCOM AS FLDCOM44, GENHTAB_44.FLDCOMA AS FLDCOMA44, GENHTAB_44.FLDDFORMAT AS FLDDFORMAT44, GENHTAB_44.FLDIFORMAT AS FLDIFORMAT44, GENHTAB_44.FLDTYPE AS FLDTYPE44, GENHTAB_44.SUBLINKF AS SUBLINKF44,  GENHTAB_44.FLDSEARCH AS FLDSEARCH44, GENHTAB_44.FLDCRITERIA AS FLDCRITERIA44, GENHTAB_44.FLDCHGINF as FLDCHGINF44, GENHTAB_44.FLDLOWER as FLDLOWER44, GENHTAB_44.FLDUPPER as FLDUPPER44, GENHTAB_44.FLDREGEX as FLDREGEX44, GENHTAB_44.FLDFUNC as FLDFUNC44, GENHTAB_44.FLDMAP as FLDMAP44, CASE WHEN GENHTAB_44.FLDID1<>'' Then Cast(1 as Bit) else Cast(0 as Bit) end as SpreadInfoF44,
TOC.FLDID45, TOC.FLDTAG45, TOC.FLDTAGA45, GENHTAB_45.FLDTAB AS FLDTAB45, GENHTAB_45.FLDCOM AS FLDCOM45, GENHTAB_45.FLDCOMA AS FLDCOMA45, GENHTAB_45.FLDDFORMAT AS FLDDFORMAT45, GENHTAB_45.FLDIFORMAT AS FLDIFORMAT45, GENHTAB_45.FLDTYPE AS FLDTYPE45, GENHTAB_45.SUBLINKF AS SUBLINKF45,  GENHTAB_45.FLDSEARCH AS FLDSEARCH45, GENHTAB_45.FLDCRITERIA AS FLDCRITERIA45, GENHTAB_45.FLDCHGINF as FLDCHGINF45, GENHTAB_45.FLDLOWER as FLDLOWER45, GENHTAB_45.FLDUPPER as FLDUPPER45, GENHTAB_45.FLDREGEX as FLDREGEX45, GENHTAB_45.FLDFUNC as FLDFUNC45, GENHTAB_45.FLDMAP as FLDMAP45, CASE WHEN GENHTAB_45.FLDID1<>'' Then Cast(1 as Bit) else Cast(0 as Bit) end as SpreadInfoF45
FROM         
TOC         
OUTER APPLY (SELECT * FROM FN_GENHTAB(TOC.FLDID16, @P_SEGMENT, @P_TOC)) AS GENHTAB_16
OUTER APPLY (SELECT * FROM FN_GENHTAB(TOC.FLDID17, @P_SEGMENT, @P_TOC)) AS GENHTAB_17
OUTER APPLY (SELECT * FROM FN_GENHTAB(TOC.FLDID18, @P_SEGMENT, @P_TOC)) AS GENHTAB_18
OUTER APPLY (SELECT * FROM FN_GENHTAB(TOC.FLDID19, @P_SEGMENT, @P_TOC)) AS GENHTAB_19
OUTER APPLY (SELECT * FROM FN_GENHTAB(TOC.FLDID20, @P_SEGMENT, @P_TOC)) AS GENHTAB_20
OUTER APPLY (SELECT * FROM FN_GENHTAB(TOC.FLDID21, @P_SEGMENT, @P_TOC)) AS GENHTAB_21
OUTER APPLY (SELECT * FROM FN_GENHTAB(TOC.FLDID22, @P_SEGMENT, @P_TOC)) AS GENHTAB_22
OUTER APPLY (SELECT * FROM FN_GENHTAB(TOC.FLDID23, @P_SEGMENT, @P_TOC)) AS GENHTAB_23
OUTER APPLY (SELECT * FROM FN_GENHTAB(TOC.FLDID24, @P_SEGMENT, @P_TOC)) AS GENHTAB_24
OUTER APPLY (SELECT * FROM FN_GENHTAB(TOC.FLDID25, @P_SEGMENT, @P_TOC)) AS GENHTAB_25
OUTER APPLY (SELECT * FROM FN_GENHTAB(TOC.FLDID26, @P_SEGMENT, @P_TOC)) AS GENHTAB_26
OUTER APPLY (SELECT * FROM FN_GENHTAB(TOC.FLDID27, @P_SEGMENT, @P_TOC)) AS GENHTAB_27
OUTER APPLY (SELECT * FROM FN_GENHTAB(TOC.FLDID28, @P_SEGMENT, @P_TOC)) AS GENHTAB_28
OUTER APPLY (SELECT * FROM FN_GENHTAB(TOC.FLDID29, @P_SEGMENT, @P_TOC)) AS GENHTAB_29
OUTER APPLY (SELECT * FROM FN_GENHTAB(TOC.FLDID30, @P_SEGMENT, @P_TOC)) AS GENHTAB_30 
OUTER APPLY (SELECT * FROM FN_GENHTAB(TOC.FLDID31, @P_SEGMENT, @P_TOC)) AS GENHTAB_31
OUTER APPLY (SELECT * FROM FN_GENHTAB(TOC.FLDID32, @P_SEGMENT, @P_TOC)) AS GENHTAB_32
OUTER APPLY (SELECT * FROM FN_GENHTAB(TOC.FLDID33, @P_SEGMENT, @P_TOC)) AS GENHTAB_33
OUTER APPLY (SELECT * FROM FN_GENHTAB(TOC.FLDID34, @P_SEGMENT, @P_TOC)) AS GENHTAB_34
OUTER APPLY (SELECT * FROM FN_GENHTAB(TOC.FLDID35, @P_SEGMENT, @P_TOC)) AS GENHTAB_35
OUTER APPLY (SELECT * FROM FN_GENHTAB(TOC.FLDID36, @P_SEGMENT, @P_TOC)) AS GENHTAB_36
OUTER APPLY (SELECT * FROM FN_GENHTAB(TOC.FLDID37, @P_SEGMENT, @P_TOC)) AS GENHTAB_37
OUTER APPLY (SELECT * FROM FN_GENHTAB(TOC.FLDID38, @P_SEGMENT, @P_TOC)) AS GENHTAB_38
OUTER APPLY (SELECT * FROM FN_GENHTAB(TOC.FLDID39, @P_SEGMENT, @P_TOC)) AS GENHTAB_39
OUTER APPLY (SELECT * FROM FN_GENHTAB(TOC.FLDID40, @P_SEGMENT, @P_TOC)) AS GENHTAB_40
OUTER APPLY (SELECT * FROM FN_GENHTAB(TOC.FLDID41, @P_SEGMENT, @P_TOC)) AS GENHTAB_41
OUTER APPLY (SELECT * FROM FN_GENHTAB(TOC.FLDID42, @P_SEGMENT, @P_TOC)) AS GENHTAB_42
OUTER APPLY (SELECT * FROM FN_GENHTAB(TOC.FLDID43, @P_SEGMENT, @P_TOC)) AS GENHTAB_43
OUTER APPLY (SELECT * FROM FN_GENHTAB(TOC.FLDID44, @P_SEGMENT, @P_TOC)) AS GENHTAB_44
OUTER APPLY (SELECT * FROM FN_GENHTAB(TOC.FLDID45, @P_SEGMENT, @P_TOC)) AS GENHTAB_45
WHERE  TOC.TOC = @P_TOC 
and (TOC.FLDID16<>'')


GO



DROP PROCEDURE QTOC_DEFVALUE 
GO
CREATE PROCEDURE QTOC_DEFVALUE (@P_TOC AS VARCHAR(10))         
AS         
Select   
G1.ValueID as ValueID1, coalesce(G1.Description, T.DefValue1) as ValueDesc1,  
G2.ValueID as ValueID2, coalesce(G2.Description, T.DefValue2) as ValueDesc2,  
G3.ValueID as ValueID3, coalesce(G3.Description, T.DefValue3) as ValueDesc3,  
G4.ValueID as ValueID4, coalesce(G4.Description, T.DefValue4) as ValueDesc4,  
G5.ValueID as ValueID5, coalesce(G5.Description, T.DefValue5) as ValueDesc5,  
G6.ValueID as ValueID6, coalesce(G6.Description, T.DefValue6) as ValueDesc6,  
G7.ValueID as ValueID7, coalesce(G7.Description, T.DefValue7) as ValueDesc7,  
G8.ValueID as ValueID8, coalesce(G8.Description, T.DefValue8) as ValueDesc8,  
G9.ValueID as ValueID9, coalesce(G9.Description, T.DefValue9) as ValueDesc9,  
G10.ValueID as ValueID10, coalesce(G10.Description, T.DefValue10) as ValueDesc10,  
G11.ValueID as ValueID11, coalesce(G11.Description, T.DefValue11) as ValueDesc11,  
G12.ValueID as ValueID12, coalesce(G12.Description, T.DefValue12) as ValueDesc12,  
G13.ValueID as ValueID13, coalesce(G13.Description, T.DefValue13) as ValueDesc13,  
G14.ValueID as ValueID14, coalesce(G14.Description, T.DefValue14) as ValueDesc14,  
G15.ValueID as ValueID15, coalesce(G15.Description, T.DefValue15) as ValueDesc15,  
G16.ValueID as ValueID16, coalesce(G16.Description, T.DefValue16) as ValueDesc16,  
G17.ValueID as ValueID17, coalesce(G17.Description, T.DefValue17) as ValueDesc17,  
G18.ValueID as ValueID18, coalesce(G18.Description, T.DefValue18) as ValueDesc18,  
G19.ValueID as ValueID19, coalesce(G19.Description, T.DefValue19) as ValueDesc19,  
G20.ValueID as ValueID20, coalesce(G20.Description, T.DefValue20) as ValueDesc20,  
G21.ValueID as ValueID21, coalesce(G21.Description, T.DefValue21) as ValueDesc21,
G22.ValueID as ValueID22, coalesce(G22.Description, T.DefValue22) as ValueDesc22,  
G23.ValueID as ValueID23, coalesce(G23.Description, T.DefValue23) as ValueDesc23,  
G24.ValueID as ValueID24, coalesce(G24.Description, T.DefValue24) as ValueDesc24,  
G25.ValueID as ValueID25, coalesce(G25.Description, T.DefValue25) as ValueDesc25,  
G26.ValueID as ValueID26, coalesce(G26.Description, T.DefValue26) as ValueDesc26,  
G27.ValueID as ValueID27, coalesce(G27.Description, T.DefValue27) as ValueDesc27,
G28.ValueID as ValueID28, coalesce(G28.Description, T.DefValue28) as ValueDesc28,  
G29.ValueID as ValueID29, coalesce(G29.Description, T.DefValue29) as ValueDesc29,  
G30.ValueID as ValueID30, coalesce(G30.Description, T.DefValue30) as ValueDesc30,  
G31.ValueID as ValueID31, coalesce(G31.Description, T.DefValue31) as ValueDesc31,  
G32.ValueID as ValueID32, coalesce(G32.Description, T.DefValue32) as ValueDesc32,  
G33.ValueID as ValueID33, coalesce(G33.Description, T.DefValue33) as ValueDesc33,
G34.ValueID as ValueID34, coalesce(G34.Description, T.DefValue34) as ValueDesc34,  
G35.ValueID as ValueID35, coalesce(G35.Description, T.DefValue35) as ValueDesc35,  
G36.ValueID as ValueID36, coalesce(G36.Description, T.DefValue36) as ValueDesc36,  
G37.ValueID as ValueID37, coalesce(G37.Description, T.DefValue37) as ValueDesc37,  
G38.ValueID as ValueID38, coalesce(G38.Description, T.DefValue38) as ValueDesc38,  
G39.ValueID as ValueID39, coalesce(G39.Description, T.DefValue39) as ValueDesc39,
G40.ValueID as ValueID40, coalesce(G40.Description, T.DefValue40) as ValueDesc40,  
G41.ValueID as ValueID41, coalesce(G41.Description, T.DefValue41) as ValueDesc41,  
G42.ValueID as ValueID42, coalesce(G42.Description, T.DefValue42) as ValueDesc42,  
G43.ValueID as ValueID43, coalesce(G43.Description, T.DefValue43) as ValueDesc43,  
G44.ValueID as ValueID44, coalesce(G44.Description, T.DefValue44) as ValueDesc44,  
G45.ValueID as ValueID45, coalesce(G45.Description, T.DefValue45) as ValueDesc45
from TOC  
Inner Join TOC_Ext T on (TOC.TOC=T.TOC)  
Left Join GenDTab G1 on (G1.FLDID=TOC.FLDID1 and G1.VALUEID=T.DefValue1)   
Left Join GenDTab G2 on (G2.FLDID=TOC.FLDID2 and G2.VALUEID=T.DefValue2)   
Left Join GenDTab G3 on (G3.FLDID=TOC.FLDID3 and G3.VALUEID=T.DefValue3)   
Left Join GenDTab G4 on (G4.FLDID=TOC.FLDID4 and G4.VALUEID=T.DefValue4)   
Left Join GenDTab G5 on (G5.FLDID=TOC.FLDID5 and G5.VALUEID=T.DefValue5)   
Left Join GenDTab G6 on (G6.FLDID=TOC.FLDID6 and G6.VALUEID=T.DefValue6)   
Left Join GenDTab G7 on (G7.FLDID=TOC.FLDID7 and G7.VALUEID=T.DefValue7)   
Left Join GenDTab G8 on (G8.FLDID=TOC.FLDID8 and G8.VALUEID=T.DefValue8)   
Left Join GenDTab G9 on (G9.FLDID=TOC.FLDID9 and G9.VALUEID=T.DefValue9)   
Left Join GenDTab G10 on (G10.FLDID=TOC.FLDID10 and G10.VALUEID=T.DefValue10)   
Left Join GenDTab G11 on (G11.FLDID=TOC.FLDID11 and G11.VALUEID=T.DefValue11)   
Left Join GenDTab G12 on (G12.FLDID=TOC.FLDID12 and G12.VALUEID=T.DefValue12)   
Left Join GenDTab G13 on (G13.FLDID=TOC.FLDID13 and G13.VALUEID=T.DefValue13)   
Left Join GenDTab G14 on (G14.FLDID=TOC.FLDID14 and G14.VALUEID=T.DefValue14)   
Left Join GenDTab G15 on (G15.FLDID=TOC.FLDID15 and G15.VALUEID=T.DefValue15)   
Left Join GenDTab G16 on (G16.FLDID=TOC.FLDID10 and G16.VALUEID=T.DefValue16)   
Left Join GenDTab G17 on (G17.FLDID=TOC.FLDID11 and G17.VALUEID=T.DefValue17)   
Left Join GenDTab G18 on (G18.FLDID=TOC.FLDID12 and G18.VALUEID=T.DefValue18)   
Left Join GenDTab G19 on (G19.FLDID=TOC.FLDID13 and G19.VALUEID=T.DefValue19)   
Left Join GenDTab G20 on (G20.FLDID=TOC.FLDID14 and G20.VALUEID=T.DefValue20)   
Left Join GenDTab G21 on (G21.FLDID=TOC.FLDID15 and G21.VALUEID=T.DefValue21)   
Left Join GenDTab G22 on (G22.FLDID=TOC.FLDID10 and G22.VALUEID=T.DefValue22)   
Left Join GenDTab G23 on (G23.FLDID=TOC.FLDID11 and G23.VALUEID=T.DefValue23)   
Left Join GenDTab G24 on (G24.FLDID=TOC.FLDID12 and G24.VALUEID=T.DefValue24)   
Left Join GenDTab G25 on (G25.FLDID=TOC.FLDID13 and G25.VALUEID=T.DefValue25)   
Left Join GenDTab G26 on (G26.FLDID=TOC.FLDID14 and G26.VALUEID=T.DefValue26)   
Left Join GenDTab G27 on (G27.FLDID=TOC.FLDID15 and G27.VALUEID=T.DefValue27)   
Left Join GenDTab G28 on (G28.FLDID=TOC.FLDID10 and G28.VALUEID=T.DefValue28)   
Left Join GenDTab G29 on (G29.FLDID=TOC.FLDID11 and G29.VALUEID=T.DefValue29)   
Left Join GenDTab G30 on (G30.FLDID=TOC.FLDID12 and G30.VALUEID=T.DefValue30)   
Left Join GenDTab G31 on (G31.FLDID=TOC.FLDID13 and G31.VALUEID=T.DefValue31)   
Left Join GenDTab G32 on (G32.FLDID=TOC.FLDID14 and G32.VALUEID=T.DefValue32)   
Left Join GenDTab G33 on (G33.FLDID=TOC.FLDID15 and G33.VALUEID=T.DefValue33)   
Left Join GenDTab G34 on (G34.FLDID=TOC.FLDID10 and G34.VALUEID=T.DefValue34)   
Left Join GenDTab G35 on (G35.FLDID=TOC.FLDID11 and G35.VALUEID=T.DefValue35)   
Left Join GenDTab G36 on (G36.FLDID=TOC.FLDID12 and G36.VALUEID=T.DefValue36)   
Left Join GenDTab G37 on (G37.FLDID=TOC.FLDID13 and G37.VALUEID=T.DefValue37)   
Left Join GenDTab G38 on (G38.FLDID=TOC.FLDID14 and G38.VALUEID=T.DefValue38)   
Left Join GenDTab G39 on (G39.FLDID=TOC.FLDID15 and G39.VALUEID=T.DefValue39)   
Left Join GenDTab G40 on (G40.FLDID=TOC.FLDID10 and G40.VALUEID=T.DefValue40)   
Left Join GenDTab G41 on (G41.FLDID=TOC.FLDID11 and G41.VALUEID=T.DefValue41)   
Left Join GenDTab G42 on (G42.FLDID=TOC.FLDID12 and G42.VALUEID=T.DefValue42)   
Left Join GenDTab G43 on (G43.FLDID=TOC.FLDID13 and G43.VALUEID=T.DefValue43)   
Left Join GenDTab G44 on (G44.FLDID=TOC.FLDID14 and G44.VALUEID=T.DefValue44)   
Left Join GenDTab G45 on (G45.FLDID=TOC.FLDID15 and G45.VALUEID=T.DefValue45)   
WHERE  TOC.TOC = @P_TOC 
GO


insert into PatchVersioning
select '1547 Update Script - 13 February 2026.sql',GETDATE()
go	
  
Declare @PrevScript varchar(100)
Declare @CurrScript varchar(100)

Select @PrevScript=''
Select @CurrSCript='1547 Update Script - 13 February 2026.sql'


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

GO 