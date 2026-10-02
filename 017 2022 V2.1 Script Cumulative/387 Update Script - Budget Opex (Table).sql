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
BEGIN TRANSACTION
GO
ALTER TABLE dbo.pSL ADD
	GID varchar(10) NULL,
	Description varchar(512) NULL
GO
COMMIT

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
BEGIN TRANSACTION
GO
ALTER TABLE dbo.SL_Request ADD
	GID varchar(10) NULL,
	Description varchar(512) NULL
GO
COMMIT

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
BEGIN TRANSACTION
GO
ALTER TABLE dbo.ProAcc ADD
	PRDays int NULL
GO
DECLARE @v sql_variant 
SET @v = N'Payment Reminder in Days'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'ProAcc', N'COLUMN', N'PRDays'
GO
Update ProAcc Set PRDays=0 Where PRDays is null
GO
COMMIT

GO

CREATE TABLE [dbo].RequestExt(
	[Request] [varchar](20) NOT NULL,
	[Name] [varchar](255) NULL,
	[CoyName] [varchar](255) NULL,
	[Position] [varchar](255) NULL,
	[Business] [varchar](255) NULL,
	[Ent_Place] [varchar](255) NULL,
	[Ent_Address] [varchar](255) NULL,
	[Ent_Type] [varchar](255) NULL,
	[Last_Date]	[smalldatetime]	NULL,
	[Last_Opr]	[varchar](50)	NULL,
	[Last_Time]	[varchar](8)	NULL,
) ON [PRIMARY]

GO

Create Unique Index I_RequestExt on RequestExt(Request)

GO

SET ANSI_PADDING OFF
GO

ALTER TABLE [dbo].RequestExt  WITH NOCHECK ADD  CONSTRAINT [FK_RequestExt_Request] FOREIGN KEY([Request])
REFERENCES [dbo].[Request] ([Request])
ON UPDATE CASCADE
ON DELETE CASCADE
GO

ALTER TABLE [dbo].RequestExt CHECK CONSTRAINT [FK_RequestExt_Request]
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
BEGIN TRANSACTION
GO
ALTER TABLE dbo.pVoucher ADD
	AUserID_Ext varchar(50) NULL,
	AUserDate_Ext smalldatetime NULL
GO
DECLARE @v sql_variant 
SET @v = N'Approving User ID (Extended/Second Approval)'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'pVoucher', N'COLUMN', N'AUserID_Ext'
GO
DECLARE @v sql_variant 
SET @v = N'Approving User Date (Extended/Second Approval)'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'pVoucher', N'COLUMN', N'AUserDate_Ext'
GO
Update pVoucher Set AUserID_Ext=AUserID, AUserDate_Ext=AUserDate Where AUserID_Ext is null
GO
COMMIT

GO

Create Unique index I_Budget_AccountDetail_GID_Account_Dr_Account_Cr on budget_accountDetail(GID, Account_Dr, Account_CR)
GO


BEGIN TRANSACTION
SET QUOTED_IDENTIFIER ON
SET ARITHABORT ON
SET NUMERIC_ROUNDABORT OFF
SET CONCAT_NULL_YIELDS_NULL ON
SET ANSI_NULLS ON
SET ANSI_PADDING ON
SET ANSI_WARNINGS ON
COMMIT
BEGIN TRANSACTION
GO
ALTER TABLE dbo.Budget_Entry ADD
	Last_Opr varchar(50) NULL,
	Last_Update smalldatetime NULL
GO
COMMIT

GO
BEGIN TRANSACTION
SET QUOTED_IDENTIFIER ON
SET ARITHABORT ON
SET NUMERIC_ROUNDABORT OFF
SET CONCAT_NULL_YIELDS_NULL ON
SET ANSI_NULLS ON
SET ANSI_PADDING ON
SET ANSI_WARNINGS ON
COMMIT
BEGIN TRANSACTION
GO
ALTER TABLE dbo.Budget_Entry ADD
	AUserID varchar(50) NULL,
	AUserDate smalldatetime NULL
GO
COMMIT

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
BEGIN TRANSACTION
GO
ALTER TABLE dbo.Budget_Entry ADD
	Hist_No int NULL
GO
DECLARE @v sql_variant 
SET @v = N'Last History No'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'Budget_Entry', N'COLUMN', N'Hist_No'
GO
Update Budget_Entry Set Hist_No=0 Where Hist_No is null
GO
COMMIT

GO

/****** Object:  Table [dbo].[Budget_Entry_Hist]    Script Date: 8/16/2022 9:24:31 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

SET ANSI_PADDING ON
GO

CREATE TABLE [dbo].[Budget_Entry_Hist](
	[Year] [int] NOT NULL,
	[Branch] [varchar](10) NOT NULL,
	[CT] [varchar](20) NOT NULL,
	[GID] [varchar](10) NOT NULL,
	[ID] [varchar](10) NOT NULL,
	[Type] [varchar](1) NULL,
	[Currency] [varchar](5) NULL,
	[Remarks] [varchar](50) NULL,
	[Month_1] [float] NULL,
	[Month_2] [float] NULL,
	[Month_3] [float] NULL,
	[Month_4] [float] NULL,
	[Month_5] [float] NULL,
	[Month_6] [float] NULL,
	[Month_7] [float] NULL,
	[Month_8] [float] NULL,
	[Month_9] [float] NULL,
	[Month_10] [float] NULL,
	[Month_11] [float] NULL,
	[Month_12] [float] NULL,
	[Total] [float] NULL,
	[Actual_1] [float] NULL,
	[Actual_2] [float] NULL,
	[Actual_3] [float] NULL,
	[Actual_4] [float] NULL,
	[Actual_5] [float] NULL,
	[Actual_6] [float] NULL,
	[Actual_7] [float] NULL,
	[Actual_8] [float] NULL,
	[Actual_9] [float] NULL,
	[Actual_10] [float] NULL,
	[Actual_11] [float] NULL,
	[Actual_12] [float] NULL,
	[TotalActual] [float] NULL,
	[Status] [varchar](1) NULL,
	[Last_Opr] [varchar](50) NULL,
	[Last_Update] [smalldatetime] NULL,
	[Hist_No] [int] NOT NULL,
 CONSTRAINT [I_Budget_Entry_Hist] PRIMARY KEY CLUSTERED 
(
	[Year] ASC,
	[Branch] ASC,
	[CT] ASC,
	[GID] ASC,
	[ID] ASC,
	[Hist_No] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO

SET ANSI_PADDING OFF
GO

ALTER TABLE [dbo].[Budget_Entry_Hist]  WITH NOCHECK ADD  CONSTRAINT [FK_Budget_Entry_Hist_Budget_Entry] FOREIGN KEY([Year],[Branch],[CT],[GID],[ID])
REFERENCES [dbo].[Budget_Entry] ([Year],[Branch],[CT],[GID],[ID])
ON UPDATE CASCADE
ON DELETE CASCADE
GO

ALTER TABLE [dbo].[Budget_Entry_Hist] CHECK CONSTRAINT [FK_Budget_Entry_Hist_Budget_Entry]
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Last History No' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Budget_Entry_Hist', @level2type=N'COLUMN',@level2name=N'Hist_No'
GO





 insert into PatchVersioning
select '387 Update Script - Budget Opex (Table)',GETDATE()
go


Declare @PrevScript varchar(100)
Declare @CurrScript varchar(100)

Select @PrevScript=''
Select @CurrSCript='387 Update Script - Budget Opex (Table)'


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






