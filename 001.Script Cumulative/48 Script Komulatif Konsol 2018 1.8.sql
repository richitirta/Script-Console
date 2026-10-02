--Employee Contribution
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'dbo.FK_ACCEMPCONTD_ACCEMPCONTH') AND parent_object_id = OBJECT_ID(N'dbo.ACCEMPCONTD'))
ALTER TABLE ACCEMPCONTD DROP CONSTRAINT FK_ACCEMPCONTD_ACCEMPCONTH
GO

IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID('ACCEMPCONTD'))
BEGIN
CREATE TABLE ACCEMPCONTD(
	ANO int NOT NULL,
	ID varchar(50) NOT NULL,
	REMARKS varchar(255) NULL,
	PCT float NULL,
	ECUTYPE varchar(50) NULL,
 CONSTRAINT I_ACCEMPCONTD PRIMARY KEY CLUSTERED 
(
	ANO ASC,
	ID ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
ALTER TABLE ACCEMPCONTD  WITH CHECK ADD  CONSTRAINT FK_ACCEMPCONTD_ACCEMPCONTH FOREIGN KEY(ANO)
REFERENCES dbo.ACCEMPCONTH (ANO)
ON UPDATE CASCADE
ALTER TABLE ACCEMPCONTD CHECK CONSTRAINT FK_ACCEMPCONTD_ACCEMPCONTH
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Acceptance ANO (see Acceptance)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'ACCEMPCONTD', @level2type=N'COLUMN',@level2name=N'ANO'
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Employee ID (see SysUser)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'ACCEMPCONTD', @level2type=N'COLUMN',@level2name=N'ID'
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Remarks' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'ACCEMPCONTD', @level2type=N'COLUMN',@level2name=N'REMARKS'
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Percentage Contribution (%)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'ACCEMPCONTD', @level2type=N'COLUMN',@level2name=N'PCT'
END
GO



IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID('ACCEMPCONTH'))
BEGIN
CREATE TABLE ACCEMPCONTH(
	ANO int NOT NULL,
	REMARKS varchar(512) NULL,
	TOTALPCT float NULL,
	STATUS varchar(1) NULL,
	CDATE smalldatetime NULL,
	USERID varchar(50) NULL,
	LUSERID varchar(50) NULL,
	LDATE smalldatetime NULL,
	AUSERID varchar(50) NULL,
	AUSERDATE smalldatetime NULL,
	CLOSEDATE smalldatetime NULL,
	CUSERID varchar(50) NULL,
	PUserID varchar(50) NULL,
	PUserDate smalldatetime NULL,
 CONSTRAINT I_ACCEMPCONTH PRIMARY KEY CLUSTERED 
(
	ANO ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Acceptance ANO (see Acceptance)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'ACCEMPCONTH', @level2type=N'COLUMN',@level2name=N'ANO'
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Remarks' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'ACCEMPCONTH', @level2type=N'COLUMN',@level2name=N'REMARKS'
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Total Contribution (%)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'ACCEMPCONTH', @level2type=N'COLUMN',@level2name=N'TOTALPCT'
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Sheet Contribution Status  (''R''equest'', ''P''rocessed, ''A'' : Approved,  ''C''lose / Cancelled)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'ACCEMPCONTH', @level2type=N'COLUMN',@level2name=N'STATUS'
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Creation Date' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'ACCEMPCONTH', @level2type=N'COLUMN',@level2name=N'CDATE'
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Initiating User' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'ACCEMPCONTH', @level2type=N'COLUMN',@level2name=N'USERID'
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Last User Id' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'ACCEMPCONTH', @level2type=N'COLUMN',@level2name=N'LUSERID'
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Last Editing date' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'ACCEMPCONTH', @level2type=N'COLUMN',@level2name=N'LDATE'
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Approving User ID' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'ACCEMPCONTH', @level2type=N'COLUMN',@level2name=N'AUSERID'
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Released Date' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'ACCEMPCONTH', @level2type=N'COLUMN',@level2name=N'AUSERDATE'
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Close Date (When Status=''C'')' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'ACCEMPCONTH', @level2type=N'COLUMN',@level2name=N'CLOSEDATE'
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Closing User ID' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'ACCEMPCONTH', @level2type=N'COLUMN',@level2name=N'CUSERID'
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Processing User ID' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'ACCEMPCONTH', @level2type=N'COLUMN',@level2name=N'PUserID'
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Processing Date' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'ACCEMPCONTH', @level2type=N'COLUMN',@level2name=N'PUserDate'
END
GO

IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID('ECUTYPE'))
BEGIN
CREATE TABLE ECUTYPE(
	ECUTYPE varchar(50) NOT NULL,
	Description varchar(512) NULL,
	PolicyF bit NULL,
	CoverF bit NULL,
 CONSTRAINT I_ECUTYPE PRIMARY KEY CLUSTERED 
(
	ECUTYPE ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
END
GO

IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'DefaultF' AND Object_ID = Object_ID(N'ECUTYPE'))
BEGIN
alter table  ECUTYPE add DefaultF bit NULL
END
go


IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID('COVEMPCONTH'))
BEGIN
CREATE TABLE COVEMPCONTH(
	CNO int NOT NULL,
	REMARKS varchar(512) NULL,
	TOTALPCT float NULL,
	STATUS varchar(1) NULL,
	CDATE smalldatetime NULL,
	USERID varchar(50) NULL,
	LUSERID varchar(50) NULL,
	LDATE smalldatetime NULL,
	AUSERID varchar(50) NULL,
	AUSERDATE smalldatetime NULL,
	CLOSEDATE smalldatetime NULL,
	CUSERID varchar(50) NULL,
	PUserID varchar(50) NULL,
	PUserDate smalldatetime NULL,
 CONSTRAINT I_COVEMPCONTH PRIMARY KEY CLUSTERED 
(
	CNO ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Cover CNO (see Cover)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'COVEMPCONTH', @level2type=N'COLUMN',@level2name=N'CNO'
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Remarks' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'COVEMPCONTH', @level2type=N'COLUMN',@level2name=N'REMARKS'
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Total Contribution (%)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'COVEMPCONTH', @level2type=N'COLUMN',@level2name=N'TOTALPCT'
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Sheet Contribution Status  (''R''equest'', ''P''rocessed, ''A'' : Approved,  ''C''lose / Cancelled)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'COVEMPCONTH', @level2type=N'COLUMN',@level2name=N'STATUS'
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Creation Date' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'COVEMPCONTH', @level2type=N'COLUMN',@level2name=N'CDATE'
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Initiating User' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'COVEMPCONTH', @level2type=N'COLUMN',@level2name=N'USERID'
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Last User Id' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'COVEMPCONTH', @level2type=N'COLUMN',@level2name=N'LUSERID'
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Last Editing date' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'COVEMPCONTH', @level2type=N'COLUMN',@level2name=N'LDATE'
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Approving User ID' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'COVEMPCONTH', @level2type=N'COLUMN',@level2name=N'AUSERID'
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Released Date' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'COVEMPCONTH', @level2type=N'COLUMN',@level2name=N'AUSERDATE'
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Close Date (When Status=''C'')' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'COVEMPCONTH', @level2type=N'COLUMN',@level2name=N'CLOSEDATE'
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Closing User ID' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'COVEMPCONTH', @level2type=N'COLUMN',@level2name=N'CUSERID'
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Processing User ID' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'COVEMPCONTH', @level2type=N'COLUMN',@level2name=N'PUserID'
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Processing Date' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'COVEMPCONTH', @level2type=N'COLUMN',@level2name=N'PUserDate'
END
GO


IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID('COVEMPCONTD'))
BEGIN
CREATE TABLE COVEMPCONTD(
	CNO int NOT NULL,
	ID varchar(50) NOT NULL,
	REMARKS varchar(255) NULL,
	PCT float NULL,
	ECUTYPE varchar(50) NULL,
 CONSTRAINT I_COVEMPCONTD PRIMARY KEY CLUSTERED 
(
	CNO ASC,
	ID ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

ALTER TABLE COVEMPCONTD  WITH CHECK ADD  CONSTRAINT FK_COVEMPCONTD_COVEMPCONTH FOREIGN KEY(CNO)
REFERENCES dbo.COVEMPCONTH (CNO)
ON UPDATE CASCADE
ON DELETE CASCADE
ALTER TABLE COVEMPCONTD CHECK CONSTRAINT FK_COVEMPCONTD_COVEMPCONTH
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Cover CNO (see Cover)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'COVEMPCONTD', @level2type=N'COLUMN',@level2name=N'CNO'
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Employee ID (see SysUser)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'COVEMPCONTD', @level2type=N'COLUMN',@level2name=N'ID'
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Remarks' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'COVEMPCONTD', @level2type=N'COLUMN',@level2name=N'REMARKS'
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Percentage Contribution (%)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'COVEMPCONTD', @level2type=N'COLUMN',@level2name=N'PCT'
END
GO


--24 may 2018
/* To prevent any potential data loss issues, you should review this script in detail before running it outside the context of the database designer.*/
IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'FLDFUNC' AND Object_ID = Object_ID(N'GENHTAB'))
BEGIN
ALTER TABLE GENHTAB ADD
	FLDFUNC varchar(255) NULL
DECLARE @v sql_variant 
SET @v = N'Name Of UDF Functions for Value Validations'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'GENHTAB', N'COLUMN', N'FLDFUNC'
END
GO

IF EXISTS ( SELECT * FROM   sysobjects WHERE  id = object_id(N'QTOC_EXT_GENHTAB') and OBJECTPROPERTY(id, N'IsProcedure') = 1 )
BEGIN
DROP PROCEDURE QTOC_EXT_GENHTAB 
end
GO
CREATE PROCEDURE QTOC_EXT_GENHTAB (@P_TOC AS VARCHAR(25))         
AS         
SELECT  TOP 1         
TOC.TOC, TOC.DESCRIPTION, TOC.ANNUALTREATYF, TOC.NORISKACCUMULATIONF, TOC.BlanketTypeVer, TOC.IACCREG, TOC.REGID, TOC.LBL_PHOLDER, TOC.LBL_AID, TOC.EXCLUSIVEF,         
TOC.FLDID16, TOC.FLDTAG16, TOC.FLDTAGA16, GENHTAB_16.FLDTAB AS FLDTAB16, GENHTAB_16.FLDCOM AS FLDCOM16, GENHTAB_16.FLDCOMA AS FLDCOMA16, GENHTAB_16.FLDDFORMAT AS FLDDFORMAT16, GENHTAB_16.FLDIFORMAT AS FLDIFORMAT16, GENHTAB_16.FLDTYPE AS FLDTYPE16, GENHTAB_16.SUBLINKF AS SUBLINKF16,  GENHTAB_16.FLDSEARCH AS FLDSEARCH16, GENHTAB_16.FLDCRITERIA AS FLDCRITERIA16, GENHTAB_16.FLDCHGINF as FLDCHGINF16, GENHTAB_16.FLDLOWER as FLDLOWER16, GENHTAB_16.FLDUPPER as FLDUPPER16, GENHTAB_16.FLDREGEX as FLDREGEX16, GENHTAB_16.FLDFUNC as FLDFUNC16, 
TOC.FLDID17, TOC.FLDTAG17, TOC.FLDTAGA17, GENHTAB_17.FLDTAB AS FLDTAB17, GENHTAB_17.FLDCOM AS FLDCOM17, GENHTAB_17.FLDCOMA AS FLDCOMA17, GENHTAB_17.FLDDFORMAT AS FLDDFORMAT17, GENHTAB_17.FLDIFORMAT AS FLDIFORMAT17, GENHTAB_17.FLDTYPE AS FLDTYPE17, GENHTAB_17.SUBLINKF AS SUBLINKF17,  GENHTAB_17.FLDSEARCH AS FLDSEARCH17, GENHTAB_17.FLDCRITERIA AS FLDCRITERIA17, GENHTAB_17.FLDCHGINF as FLDCHGINF17, GENHTAB_17.FLDLOWER as FLDLOWER17, GENHTAB_17.FLDUPPER as FLDUPPER17, GENHTAB_17.FLDREGEX as FLDREGEX17, GENHTAB_17.FLDFUNC as FLDFUNC17, 
TOC.FLDID18, TOC.FLDTAG18, TOC.FLDTAGA18, GENHTAB_18.FLDTAB AS FLDTAB18, GENHTAB_18.FLDCOM AS FLDCOM18, GENHTAB_19.FLDCOMA AS FLDCOMA18, GENHTAB_18.FLDDFORMAT AS FLDDFORMAT18, GENHTAB_18.FLDIFORMAT AS FLDIFORMAT18, GENHTAB_18.FLDTYPE AS FLDTYPE18, GENHTAB_18.SUBLINKF AS SUBLINKF18,  GENHTAB_18.FLDSEARCH AS FLDSEARCH18, GENHTAB_18.FLDCRITERIA AS FLDCRITERIA18, GENHTAB_18.FLDCHGINF as FLDCHGINF18, GENHTAB_18.FLDLOWER as FLDLOWER18, GENHTAB_18.FLDUPPER as FLDUPPER18, GENHTAB_18.FLDREGEX as FLDREGEX18, GENHTAB_18.FLDFUNC as FLDFUNC18,   
TOC.FLDID19, TOC.FLDTAG19, TOC.FLDTAGA19, GENHTAB_19.FLDTAB AS FLDTAB19, GENHTAB_19.FLDCOM AS FLDCOM19, GENHTAB_19.FLDCOMA AS FLDCOMA19, GENHTAB_19.FLDDFORMAT AS FLDDFORMAT19, GENHTAB_19.FLDIFORMAT AS FLDIFORMAT19, GENHTAB_19.FLDTYPE AS FLDTYPE19, GENHTAB_19.SUBLINKF AS SUBLINKF19,  GENHTAB_19.FLDSEARCH AS FLDSEARCH19, GENHTAB_19.FLDCRITERIA AS FLDCRITERIA19, GENHTAB_19.FLDCHGINF as FLDCHGINF19, GENHTAB_19.FLDLOWER as FLDLOWER19, GENHTAB_19.FLDUPPER as FLDUPPER19, GENHTAB_19.FLDREGEX as FLDREGEX19, GENHTAB_19.FLDFUNC as FLDFUNC19,   
TOC.FLDID20, TOC.FLDTAG20, TOC.FLDTAGA20, GENHTAB_20.FLDTAB AS FLDTAB20, GENHTAB_20.FLDCOM AS FLDCOM20, GENHTAB_20.FLDCOMA AS FLDCOMA20, GENHTAB_20.FLDDFORMAT AS FLDDFORMAT20, GENHTAB_20.FLDIFORMAT AS FLDIFORMAT20, GENHTAB_20.FLDTYPE AS FLDTYPE20, GENHTAB_20.SUBLINKF AS SUBLINKF20,  GENHTAB_20.FLDSEARCH AS FLDSEARCH20, GENHTAB_20.FLDCRITERIA AS FLDCRITERIA20, GENHTAB_20.FLDCHGINF as FLDCHGINF20, GENHTAB_20.FLDLOWER as FLDLOWER20, GENHTAB_20.FLDUPPER as FLDUPPER20, GENHTAB_20.FLDREGEX as FLDREGEX20, GENHTAB_20.FLDFUNC as FLDFUNC20,   
TOC.FLDID21, TOC.FLDTAG21, TOC.FLDTAGA21, GENHTAB_21.FLDTAB AS FLDTAB21, GENHTAB_21.FLDCOM AS FLDCOM21, GENHTAB_21.FLDCOMA AS FLDCOMA21, GENHTAB_21.FLDDFORMAT AS FLDDFORMAT21, GENHTAB_21.FLDIFORMAT AS FLDIFORMAT21, GENHTAB_21.FLDTYPE AS FLDTYPE21, GENHTAB_21.SUBLINKF AS SUBLINKF21,  GENHTAB_21.FLDSEARCH AS FLDSEARCH21, GENHTAB_21.FLDCRITERIA AS FLDCRITERIA21, GENHTAB_21.FLDCHGINF as FLDCHGINF21, GENHTAB_21.FLDLOWER as FLDLOWER21, GENHTAB_21.FLDUPPER as FLDUPPER21, GENHTAB_21.FLDREGEX as FLDREGEX21, GENHTAB_21.FLDFUNC as FLDFUNC21,   
TOC.FLDID22, TOC.FLDTAG22, TOC.FLDTAGA22, GENHTAB_22.FLDTAB AS FLDTAB22, GENHTAB_22.FLDCOM AS FLDCOM22, GENHTAB_22.FLDCOMA AS FLDCOMA22, GENHTAB_22.FLDDFORMAT AS FLDDFORMAT22, GENHTAB_22.FLDIFORMAT AS FLDIFORMAT22, GENHTAB_22.FLDTYPE AS FLDTYPE22, GENHTAB_22.SUBLINKF AS SUBLINKF22,  GENHTAB_22.FLDSEARCH AS FLDSEARCH22, GENHTAB_22.FLDCRITERIA AS FLDCRITERIA22, GENHTAB_22.FLDCHGINF as FLDCHGINF22, GENHTAB_22.FLDLOWER as FLDLOWER22, GENHTAB_22.FLDUPPER as FLDUPPER22, GENHTAB_22.FLDREGEX as FLDREGEX22, GENHTAB_22.FLDFUNC as FLDFUNC22,   
TOC.FLDID23, TOC.FLDTAG23, TOC.FLDTAGA23, GENHTAB_23.FLDTAB AS FLDTAB23, GENHTAB_23.FLDCOM AS FLDCOM23, GENHTAB_23.FLDCOMA AS FLDCOMA23, GENHTAB_23.FLDDFORMAT AS FLDDFORMAT23, GENHTAB_23.FLDIFORMAT AS FLDIFORMAT23, GENHTAB_23.FLDTYPE AS FLDTYPE23, GENHTAB_23.SUBLINKF AS SUBLINKF23,  GENHTAB_23.FLDSEARCH AS FLDSEARCH23, GENHTAB_23.FLDCRITERIA AS FLDCRITERIA23, GENHTAB_23.FLDCHGINF as FLDCHGINF23, GENHTAB_23.FLDLOWER as FLDLOWER23, GENHTAB_23.FLDUPPER as FLDUPPER23, GENHTAB_23.FLDREGEX as FLDREGEX23, GENHTAB_23.FLDFUNC as FLDFUNC23,   
TOC.FLDID24, TOC.FLDTAG24, TOC.FLDTAGA23, GENHTAB_24.FLDTAB AS FLDTAB24, GENHTAB_24.FLDCOM AS FLDCOM24, GENHTAB_24.FLDCOMA AS FLDCOMA24, GENHTAB_24.FLDDFORMAT AS FLDDFORMAT24, GENHTAB_24.FLDIFORMAT AS FLDIFORMAT24, GENHTAB_24.FLDTYPE AS FLDTYPE24, GENHTAB_24.SUBLINKF AS SUBLINKF24,  GENHTAB_24.FLDSEARCH AS FLDSEARCH24, GENHTAB_24.FLDCRITERIA AS FLDCRITERIA24, GENHTAB_24.FLDCHGINF as FLDCHGINF24, GENHTAB_24.FLDLOWER as FLDLOWER24, GENHTAB_24.FLDUPPER as FLDUPPER24, GENHTAB_24.FLDREGEX as FLDREGEX24, GENHTAB_24.FLDFUNC as FLDFUNC24,   
TOC.FLDID25, TOC.FLDTAG25, TOC.FLDTAGA25, GENHTAB_25.FLDTAB AS FLDTAB25, GENHTAB_25.FLDCOM AS FLDCOM25, GENHTAB_25.FLDCOMA AS FLDCOMA25, GENHTAB_25.FLDDFORMAT AS FLDDFORMAT25, GENHTAB_25.FLDIFORMAT AS FLDIFORMAT25, GENHTAB_25.FLDTYPE AS FLDTYPE25, GENHTAB_25.SUBLINKF AS SUBLINKF25,  GENHTAB_25.FLDSEARCH AS FLDSEARCH25, GENHTAB_25.FLDCRITERIA AS FLDCRITERIA25, GENHTAB_25.FLDCHGINF as FLDCHGINF25, GENHTAB_25.FLDLOWER as FLDLOWER25, GENHTAB_25.FLDUPPER as FLDUPPER25, GENHTAB_25.FLDREGEX as FLDREGEX25, GENHTAB_25.FLDFUNC as FLDFUNC25,   
TOC.FLDID26, TOC.FLDTAG26, TOC.FLDTAGA26, GENHTAB_26.FLDTAB AS FLDTAB26, GENHTAB_26.FLDCOM AS FLDCOM26, GENHTAB_26.FLDCOMA AS FLDCOMA26, GENHTAB_26.FLDDFORMAT AS FLDDFORMAT26, GENHTAB_26.FLDIFORMAT AS FLDIFORMAT26, GENHTAB_26.FLDTYPE AS FLDTYPE26, GENHTAB_26.SUBLINKF AS SUBLINKF26,  GENHTAB_26.FLDSEARCH AS FLDSEARCH26, GENHTAB_26.FLDCRITERIA AS FLDCRITERIA26, GENHTAB_26.FLDCHGINF as FLDCHGINF26, GENHTAB_26.FLDLOWER as FLDLOWER26, GENHTAB_26.FLDUPPER as FLDUPPER26, GENHTAB_26.FLDREGEX as FLDREGEX26, GENHTAB_26.FLDFUNC as FLDFUNC26,   
TOC.FLDID27, TOC.FLDTAG27, TOC.FLDTAGA27, GENHTAB_27.FLDTAB AS FLDTAB27, GENHTAB_27.FLDCOM AS FLDCOM27, GENHTAB_27.FLDCOMA AS FLDCOMA27, GENHTAB_27.FLDDFORMAT AS FLDDFORMAT27, GENHTAB_27.FLDIFORMAT AS FLDIFORMAT27, GENHTAB_27.FLDTYPE AS FLDTYPE27, GENHTAB_27.SUBLINKF AS SUBLINKF27,  GENHTAB_27.FLDSEARCH AS FLDSEARCH27, GENHTAB_27.FLDCRITERIA AS FLDCRITERIA27, GENHTAB_27.FLDCHGINF as FLDCHGINF27, GENHTAB_27.FLDLOWER as FLDLOWER27, GENHTAB_27.FLDUPPER as FLDUPPER27, GENHTAB_27.FLDREGEX as FLDREGEX27, GENHTAB_27.FLDFUNC as FLDFUNC27,   
TOC.FLDID28, TOC.FLDTAG28, TOC.FLDTAGA28, GENHTAB_28.FLDTAB AS FLDTAB28, GENHTAB_28.FLDCOM AS FLDCOM28, GENHTAB_28.FLDCOMA AS FLDCOMA28, GENHTAB_28.FLDDFORMAT AS FLDDFORMAT28, GENHTAB_28.FLDIFORMAT AS FLDIFORMAT28, GENHTAB_28.FLDTYPE AS FLDTYPE28, GENHTAB_28.SUBLINKF AS SUBLINKF28,  GENHTAB_28.FLDSEARCH AS FLDSEARCH28, GENHTAB_28.FLDCRITERIA AS FLDCRITERIA28, GENHTAB_28.FLDCHGINF as FLDCHGINF28, GENHTAB_28.FLDLOWER as FLDLOWER28, GENHTAB_28.FLDUPPER as FLDUPPER28, GENHTAB_28.FLDREGEX as FLDREGEX28, GENHTAB_28.FLDFUNC as FLDFUNC28,   
TOC.FLDID29, TOC.FLDTAG29, TOC.FLDTAGA29, GENHTAB_29.FLDTAB AS FLDTAB29, GENHTAB_29.FLDCOM AS FLDCOM29, GENHTAB_29.FLDCOMA AS FLDCOMA29, GENHTAB_29.FLDDFORMAT AS FLDDFORMAT29, GENHTAB_29.FLDIFORMAT AS FLDIFORMAT29, GENHTAB_29.FLDTYPE AS FLDTYPE29, GENHTAB_29.SUBLINKF AS SUBLINKF29,  GENHTAB_29.FLDSEARCH AS FLDSEARCH29, GENHTAB_29.FLDCRITERIA AS FLDCRITERIA29, GENHTAB_29.FLDCHGINF as FLDCHGINF29, GENHTAB_29.FLDLOWER as FLDLOWER29, GENHTAB_29.FLDUPPER as FLDUPPER29, GENHTAB_29.FLDREGEX as FLDREGEX29, GENHTAB_29.FLDFUNC as FLDFUNC29,   
TOC.FLDID30, TOC.FLDTAG30, TOC.FLDTAGA30, GENHTAB_30.FLDTAB AS FLDTAB30, GENHTAB_30.FLDCOM AS FLDCOM30, GENHTAB_30.FLDCOMA AS FLDCOMA30, GENHTAB_30.FLDDFORMAT AS FLDDFORMAT30, GENHTAB_30.FLDIFORMAT AS FLDIFORMAT30, GENHTAB_30.FLDTYPE AS FLDTYPE30, GENHTAB_30.SUBLINKF AS SUBLINKF30,  GENHTAB_30.FLDSEARCH AS FLDSEARCH30, GENHTAB_30.FLDCRITERIA AS FLDCRITERIA30, GENHTAB_30.FLDCHGINF as FLDCHGINF30, GENHTAB_30.FLDLOWER as FLDLOWER30, GENHTAB_30.FLDUPPER as FLDUPPER30, GENHTAB_30.FLDREGEX as FLDREGEX30, GENHTAB_30.FLDFUNC as FLDFUNC30
FROM         
TOC         
LEFT OUTER JOIN GENHTAB as GENHTAB_16 ON TOC.FLDID16<>'' AND TOC.FLDID16 = GENHTAB_16.FLDID   
LEFT OUTER JOIN GENHTAB as GENHTAB_17 ON TOC.FLDID17<>'' AND TOC.FLDID17 = GENHTAB_17.FLDID         
LEFT OUTER JOIN GENHTAB as GENHTAB_18 ON TOC.FLDID18<>'' AND TOC.FLDID18 = GENHTAB_18.FLDID         
LEFT OUTER JOIN GENHTAB as GENHTAB_19 ON TOC.FLDID19<>'' AND TOC.FLDID19 = GENHTAB_19.FLDID         
LEFT OUTER JOIN GENHTAB as GENHTAB_20 ON TOC.FLDID20<>'' AND TOC.FLDID20 = GENHTAB_20.FLDID         
LEFT OUTER JOIN GENHTAB as GENHTAB_21 ON TOC.FLDID21<>'' AND TOC.FLDID21 = GENHTAB_21.FLDID         
LEFT OUTER JOIN GENHTAB as GENHTAB_22 ON TOC.FLDID22<>'' AND TOC.FLDID22 = GENHTAB_22.FLDID         
LEFT OUTER JOIN GENHTAB as GENHTAB_23 ON TOC.FLDID23<>'' AND TOC.FLDID23 = GENHTAB_23.FLDID         
LEFT OUTER JOIN GENHTAB as GENHTAB_24 ON TOC.FLDID24<>'' AND TOC.FLDID24 = GENHTAB_24.FLDID         
LEFT OUTER JOIN GENHTAB as GENHTAB_25 ON TOC.FLDID25<>'' AND TOC.FLDID25 = GENHTAB_25.FLDID         
LEFT OUTER JOIN GENHTAB as GENHTAB_26 ON TOC.FLDID26<>'' AND TOC.FLDID26 = GENHTAB_26.FLDID         
LEFT OUTER JOIN GENHTAB as GENHTAB_27 ON TOC.FLDID27<>'' AND TOC.FLDID27 = GENHTAB_27.FLDID         
LEFT OUTER JOIN GENHTAB as GENHTAB_28 ON TOC.FLDID28<>'' AND TOC.FLDID28 = GENHTAB_28.FLDID         
LEFT OUTER JOIN GENHTAB as GENHTAB_29 ON TOC.FLDID29<>'' AND TOC.FLDID29 = GENHTAB_29.FLDID         
LEFT OUTER JOIN GENHTAB as GENHTAB_30 ON TOC.FLDID30<>'' AND TOC.FLDID30 = GENHTAB_30.FLDID         
WHERE  TOC.TOC = @P_TOC 
and (
TOC.FLDID16<>'' or TOC.FLDID17<>'' or TOC.FLDID18<>'' or TOC.FLDID19<>'' or TOC.FLDID20<>'' or TOC.FLDID21<>'' or TOC.FLDID22<>'' or TOC.FLDID23<>'' or TOC.FLDID24<>''
or TOC.FLDID25<>'' or TOC.FLDID26<>'' or TOC.FLDID28<>'' or TOC.FLDID29<>'' or TOC.FLDID30<>'')


go

IF EXISTS ( SELECT * FROM   sysobjects WHERE  id = object_id(N'QScheme_Verify_5') and OBJECTPROPERTY(id, N'IsProcedure') = 1 )
BEGIN
DROP Procedure QScheme_Verify_5  
end
GO
CREATE Procedure QScheme_Verify_5  
@p_TSI as float,  
@P_Coverage as varchar(255),  
@p_SchemeNo as varchar (10),  
@p_Description as varchar (255)  
as  
Select S1.DCode, S1.PCTTSI, S1.PCTCL, S1.FIXEDMIN, S1.FIXEDMAX, S1.Currency, S1.IUNIT, S1.Remarks, S1.TOR, S1.STRTSI  
from Scheme_Deductible S1, Scheme_Class S2, Scheme_Coverage S3, RateCov  
Where  
S1.Coverage=@P_Coverage  
and S1.Lower<=@p_TSI  
and S1.Upper>=@p_TSI  
and S2.ClassNo=S1.ClassNo  
and S2.SchemeNo=@p_SchemeNO  
and @p_Description Like S2.Description  
and S3.Coverage=@P_Coverage  
and S3.ClassNo=S2.ClassNo  
and RateCov.Code=S3.Code  
and S1.TOR=RateCov.TOR  
and S2.Priority in (Select Max(S3.Priority) from Scheme_Class S3 Where S3.SchemeNo=@P_SchemeNo and @P_Description like S3.Description)  
      
go

--tuning withholdingtax
IF EXISTS (SELECT *  FROM sys.indexes WHERE name='I_nSL_pVoucher' AND object_id = OBJECT_ID('nSL'))
BEGIN
drop Index nSL.I_nSL_pVoucher
END
GO
IF EXISTS (SELECT *  FROM sys.indexes WHERE name='I_SL_Doc_No' AND object_id = OBJECT_ID('nSL'))
BEGIN
drop Index nSL.I_SL_Doc_No
END
GO
IF EXISTS (SELECT *  FROM sys.indexes WHERE name='IX_nSL_PVoucher' AND object_id = OBJECT_ID('nSL'))
BEGIN
drop index nSL.IX_nSL_PVoucher
END
GO
IF NOT EXISTS (SELECT *  FROM sys.indexes WHERE name='I_nSL_Doc_No_PVoucher' AND object_id = OBJECT_ID('nSL'))
BEGIN
Create Index I_nSL_Doc_No_PVoucher on nSL(Doc_No, PVoucher)
END
go

--tunning inforce
IF NOT EXISTS (SELECT *  FROM sys.indexes WHERE name='I_ClaAss_CNO_ID_TOC_TYPE_CURRENCY_REFNO' AND object_id = OBJECT_ID('ClaAss'))
BEGIN

Create Index I_ClaAss_CNO_ID_TOC_TYPE_CURRENCY_REFNO on ClaAss(CNO,ID,TOC,TYPE,CURRENCY,REFNO)
END
GO

IF EXISTS ( SELECT * FROM   sysobjects WHERE  id = object_id(N'QClaim_To_Adm') and OBJECTPROPERTY(id, N'IsProcedure') = 1 )
BEGIN
DROP Procedure QClaim_To_Adm
end
GO
CREATE Procedure QClaim_To_Adm(@P_CNO as int)                              
as   
Select ID, TOC, Type, Currency, RefNo, 
Max(DocNo) as DocNo,
Max(Remarks) as Remarks, 
cast(Max(cast(CashLossF as int)) as Bit) as CashLossF,

sum(Case When C1.Code='P' then C1.Amount else 0 end) as Amount_1,                              
sum(Case When C1.Code='A' then C1.Amount else 0 end) as Amount_6,                              
sum(Case When C1.Code='E' then C1.Amount else 0 end) as Amount_7,                              
sum(Case When C1.Code='S' then C1.Amount else 0 end) as Amount_8,                              
sum(Case When C1.Code='L' then C1.Amount else 0 end) as Amount_9,                              
sum(Case When C1.Code='R' then C1.Amount else 0 end) as Amount_10,                              
sum(Case When C1.Code='V' then C1.Amount else 0 end) as Amount_13,                              
sum(Case When C1.Code='T' then C1.Amount else 0 end) as Amount_14,                              
sum(Case When C1.Code='F' then C1.Amount else 0 end) as Amount_15,                              
sum(Case When C1.Code='D' then C1.Amount else 0 end) as Amount_16,                              
sum(Case When C1.Code='I' then C1.Amount else 0 end) as Amount_17
from ClaAss C1
Where C1.CNO=@P_CNO
Group by ID, TOC, Type, Currency, RefNo
go

--Bugs Approval harusnya TOC mengambil Cover
IF EXISTS ( SELECT * FROM   sysobjects WHERE  id = object_id(N'QApproval_Production') and OBJECTPROPERTY(id, N'IsProcedure') = 1 )
BEGIN
DROP Procedure QApproval_Production
end
GO
CREATE Procedure QApproval_Production (@P_ANO integer)              
AS              
SELECT top 1 Acceptance.PolicyNo, Acceptance.CertificateNo, 
Max(Case When Acceptance.ANO=@P_ANO Then Acceptance.Branch else '' end) as Branch,    
Max(ACCEPTANCE.TOC) as TOC, Max(Cover.ISType) as ISType,   
MIN(Case When TOC.ApplyApprLimitByTOLF=1 Then RARRHEADER.CLIMIT*RARRHEADER.LIMIT*100 ELSE 100 END) as ApprLimitPct,  
sum(PCALC.AMOUNT*RARRHEADER.PCTSHARE/100*(1-RARRHEADER.MSHARE/100)*PCALC.Rate) as Amount              
From PCALC, Acceptance, Cover, RARRHEADER, TOC              
WHERE ((ACCEPTANCE.ANO=@P_ANO And (Cover.OpenFlag=1 or Acceptance.ANO<>Acceptance.LANO)) or (ACCEPTANCE.LANO=@P_ANO And Cover.OpenFlag=0))        
and Cover.CNO=Acceptance.CNO and PCALC.ANO=ACCEPTANCE.ANO AND RARRHEADER.ANO=ACCEPTANCE.ANO              
and TOC.TOC=COVER.TOC  -- MAIN TOC
Group By Acceptance.PolicyNo, Acceptance.CertificateNo
Order By sum(PCALC.AMOUNT*RARRHEADER.PCTSHARE/100*(1-RARRHEADER.MSHARE/100)*PCALC.Rate) Desc            
GO

--PENAMBAHAN NCDATE DI RISK COVERAGE (TIDAK DIDISPLAY) DAN SETTING NO CLAIM PERIOD IN MONTH DI TOPRO
/* To prevent any potential data loss issues, you should review this script in detail before running it outside the context of the database designer.*/
IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'NCPERIOD' AND Object_ID = Object_ID(N'TOP_Rate'))
BEGIN
ALTER TABLE TOP_Rate ADD NCPERIOD int NULL
DECLARE @v sql_variant 
SET @v = N'No Claim Period (in Month)'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'TOP_Rate', N'COLUMN', N'NCPERIOD'
END
GO


/* To prevent any potential data loss issues, you should review this script in detail before running it outside the context of the database designer.*/
IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'NCDate' AND Object_ID = Object_ID(N'RCOVER'))
BEGIN
ALTER TABLE RCOVER ADD
	NCDate smalldatetime NULL
DECLARE @v sql_variant 
SET @v = N'No Claim Date Until '
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'RCOVER', N'COLUMN', N'NCDate'
END
GO

if exists (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'Get_Policy_APRule') AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) )
BEGIN
DROP function Get_Policy_APRule
end
GO
Create function Get_Policy_APRule(@P_ANO as int)      
RETURNS Table      
AS RETURN      
(   
Select AD.RuleID, AD.Class, AD.RepName, AD.ExeName, AH.AutoInforceF, TOC.ApplyeStampDutyF, AD.NeedEmailF,AD.NeedPrintF
from APDRuleH AH 
INNER JOIN APDRULED AD ON (AH.RULEID=AD.RULEID) 
INNER JOIN TOC ON (TOC.TOC=AH.TOC)
INNER JOIN 
(
       Select Top 1 AH.RuleID
       from APDRuleH AH 
       Where AH.AllowedF=1 AND AH.APPTYPE='POLICY'  
       and exists
       (  
             Select 1 
             from Acceptance A, Cover C, Profile P
             Where A.ANO=@P_ANO and C.CNO=A.CNO and P.ID=C.PHolder 
             and C.PolicyType=AH.PolicyType and C.ISType=AH.ISType 
             and (C.Segment=AH.Segment or AH.Segment='<All>') and A.TOC=AH.TOC and (A.TOPRO=AH.TOPRO or AH.TOPRO='<All>')  
             and (P.PType=AH.PType or AH.PType='<All>')
       )  
       Order by AH.RuleID
) R ON (AH.RULEID=R.RULEID)
INNER JOIN SYSCLASS S ON (S.CLASS=AD.CLASS)  
INNER JOIN ACCEPTANCE A ON (A.ANO=@P_ANO)
INNER JOIN COVER C ON (C.CNO=A.CNO)
WHERE charindex(A.AType,S.AccAType)<>0  and charindex(A.AStatus,S.AccAStatus)<>0  and charindex(C.CStatus,S.CoverCStatus)<>0  
)       

GO

IF EXISTS (SELECT *  FROM sys.indexes WHERE name='I_nSL_pVoucher' AND object_id = OBJECT_ID('nSL'))
BEGIN
drop index nSL.I_nSL_pVoucher
END
GO
IF EXISTS (SELECT *  FROM sys.indexes WHERE name='IX_nSL_PVoucher' AND object_id = OBJECT_ID('nSL'))
BEGIN
drop index nSL.IX_nSL_PVoucher
END
GO
IF EXISTS (SELECT *  FROM sys.indexes WHERE name='I_SL_Doc_No' AND object_id = OBJECT_ID('nSL'))
BEGIN
drop index nSL.I_SL_Doc_No
END
GO

IF NOT EXISTS (SELECT *  FROM sys.indexes  
			WHERE name='I_nSL_Doc_No_PVoucher' AND object_id = OBJECT_ID('nSL'))
BEGIN
Create Index I_nSL_Doc_No_PVoucher on nSL(Doc_No, PVoucher)
END
go

--12 jun 2018
/* To prevent any potential data loss issues, you should review this script in detail before running it outside the context of the database designer.*/
IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'CURRENCY_OC' AND Object_ID = Object_ID(N'TOP_Interest'))
BEGIN
ALTER TABLE TOP_Interest ADD
	CURRENCY_OC varchar(10) NULL
DECLARE @v sql_variant 
SET @v = N'If Filled, Fixed Interest Currency'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'TOP_Interest', N'COLUMN', N'CURRENCY_OC'
END
GO

--VERSIONING
insert into versioning
select '2018 V.1.8.0',GETDATE(),'2018 V.1.8.0',GETDATE(),'K: 2018 V.1.8.0',GETDATE()
go



Declare @PrevScript varchar(100)
Declare @CurrScript varchar(100)

Select @PrevScript='47 Script Komulatif Konsol 2018 1.7'
Select @CurrSCript='48 Script Komulatif Konsol 2018 1.8'


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
