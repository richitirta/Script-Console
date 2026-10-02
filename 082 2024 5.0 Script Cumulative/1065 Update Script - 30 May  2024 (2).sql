IF  NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'CFINDICATORH') AND type in (N'U'))
BEGIN

SET QUOTED_IDENTIFIER ON
SET ARITHABORT ON
SET NUMERIC_ROUNDABORT OFF
SET CONCAT_NULL_YIELDS_NULL ON
SET ANSI_NULLS ON
SET ANSI_PADDING ON
SET ANSI_WARNINGS ON


CREATE TABLE dbo.CFINDICATORH
	(
	CNO int NOT NULL,
	FID varchar(10) NULL,
	FPOINT int NULL,
	STATUS varchar(10) NULL,
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
	MAXFPOINT int NULL,
	INDICATOR varchar(10) NULL
	)  ON [PRIMARY]
end
go
DECLARE @v sql_variant 
SET @v = N'Claim Original CNO'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'CFINDICATORH', N'COLUMN', N'CNO'
go
DECLARE @v sql_variant 
SET @v = N'Fraud Indicator ID ( see FINDICATOR)'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'CFINDICATORH', N'COLUMN', N'FID'
go
DECLARE @v sql_variant 
SET @v = N'Total Fraud Point'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'CFINDICATORH', N'COLUMN', N'FPOINT'
go
DECLARE @v sql_variant 
SET @v = N'Fraud Indicator Status  (''R''equest'', ''P''rocessed, ''A'' : Approved,  ''C''lose / Cancelled)'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'CFINDICATORH', N'COLUMN', N'STATUS'
go
DECLARE @v sql_variant 
SET @v = N'Creation Date'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'CFINDICATORH', N'COLUMN', N'CDATE'
go
DECLARE @v sql_variant 
SET @v = N'Initiating User'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'CFINDICATORH', N'COLUMN', N'USERID'
go
DECLARE @v sql_variant 
SET @v = N'Last User Id'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'CFINDICATORH', N'COLUMN', N'LUSERID'
go
DECLARE @v sql_variant 
SET @v = N'Last Editing date'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'CFINDICATORH', N'COLUMN', N'LDATE'
go
DECLARE @v sql_variant 
SET @v = N'Approving User ID'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'CFINDICATORH', N'COLUMN', N'AUSERID'
go
DECLARE @v sql_variant 
SET @v = N'Released Date'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'CFINDICATORH', N'COLUMN', N'AUSERDATE'
go
DECLARE @v sql_variant 
SET @v = N'Close Date (When Status=''C'')'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'CFINDICATORH', N'COLUMN', N'CLOSEDATE'
go
DECLARE @v sql_variant 
SET @v = N'Closing User ID'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'CFINDICATORH', N'COLUMN', N'CUSERID'
go
DECLARE @v sql_variant 
SET @v = N'Processing User ID'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'CFINDICATORH', N'COLUMN', N'PUserID'
go
DECLARE @v sql_variant 
SET @v = N'Processing Date'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'CFINDICATORH', N'COLUMN', N'PUserDate'
go
DECLARE @v sql_variant 
SET @v = N'Maximum Fraud Point'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'CFINDICATORH', N'COLUMN', N'MAXFPOINT'
go

DECLARE @v sql_variant 
SET @v = N'see FINDICATORI'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'CFINDICATORH', N'COLUMN', N'INDICATOR'
go

IF  NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'CFINDICATORD') AND type in (N'U'))
BEGIN
CREATE TABLE dbo.CFINDICATORD
	(
	CNO int NOT NULL,
	FID varchar(10) NULL,
	RISKNO varchar(10) NULL,
	RISKDESC varchar(255) NULL,
	REMARKS varchar(255) NULL,
	DESCRIPTION varchar(255) NULL,
	SYSTEMF bit NULL,
	FRAUDF bit NULL
	)  ON [PRIMARY]
 end
 go
DECLARE @v sql_variant 
SET @v = N'Claim Original CNO'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'CFINDICATORD', N'COLUMN', N'CNO'
 go
DECLARE @v sql_variant 
SET @v = N'Fraud Indicator ID ( see FINDICATOR)'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'CFINDICATORD', N'COLUMN', N'FID'
 go
DECLARE @v sql_variant 
SET @v = N'Fraud Risk No'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'CFINDICATORD', N'COLUMN', N'RISKNO'
 go
DECLARE @v sql_variant 
SET @v = N'Risk Item Description'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'CFINDICATORD', N'COLUMN', N'RISKDESC'
 go
DECLARE @v sql_variant 
SET @v = N'Remarks'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'CFINDICATORD', N'COLUMN', N'REMARKS'
 go
DECLARE @v sql_variant 
SET @v = N'Scoring Value Description'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'CFINDICATORD', N'COLUMN', N'DESCRIPTION'
 go
DECLARE @v sql_variant 
SET @v = N'System Generated (0 : No, 1 : Yes)'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'CFINDICATORD', N'COLUMN', N'SYSTEMF'
 go
DECLARE @v sql_variant 
SET @v = N'Fraud Yes No (0 : No Fraud, 1 : Yes)'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'CFINDICATORD', N'COLUMN', N'FRAUDF'
go

Create Unique Index I_CFINDICATORH on CFINDICATORH(CNO, FID)
GO
Create Unique Index I_CFINDICATORD on CFINDICATORD(CNO, FID, RISKNO)
GO

ALTER TABLE [dbo].[CFINDICATORD]  WITH NOCHECK ADD  CONSTRAINT [FK_CFINDICATORD_CFINDICATORH] FOREIGN KEY([CNO], [FID])
REFERENCES [dbo].[CFINDICATORH] ([CNO], [FID])
ON UPDATE CASCADE
ON DELETE CASCADE
GO

ALTER TABLE [dbo].[CFINDICATORD] CHECK CONSTRAINT [FK_CFINDICATORD_CFINDICATORH]
GO



DROP Procedure Drop_Claim_Link
GO
Create Procedure Drop_Claim_Link(@P_CNO as Int)    
AS     
    
Delete From CLAASS Where CNO=@P_CNO    
Delete From CLFD Where CNO=@P_CNO    
Delete From CLINFO Where CNO=@P_CNO    
Delete From CLFACDED Where CNO=@P_CNO    
Delete From CINFO Where CNO=@P_CNO    
Delete From CLSALITEM Where CNO=@P_CNO    
Delete From CLDED Where CNO=@P_CNO    
Delete From LCALC Where CNO=@P_CNO    
Delete From CLLOSS Where CNO=@P_CNO    
Delete From CLSAL Where CNO=@P_CNO    
Delete From CLNotify Where CNO=@P_CNO    
Delete From CLPIC Where CNO=@P_CNO    
Delete From CLCOST Where CNO=@P_CNO    
Delete From CLPrintLog Where CNO=@P_CNO    
Delete From CDOCSTAT Where CNO=@P_CNO    
Delete From CARRHEADER Where CNO=@P_CNO    
Delete From CLSub Where CNO=@P_CNO    
Delete From CCALC Where CNO=@P_CNO    
Delete From CLSurvey Where CNO=@P_CNO    
Delete From CDOCLIST Where CNO=@P_CNO    
Delete From CDOCLISTPIC Where CNO=@P_CNO    
Delete From CArrDetail Where CNO=@P_CNO    
Delete From CLNotes Where CNO=@P_CNO  
Delete From CLINFOSUPL Where CNO=@P_CNO  
Delete From CLSUBPIC Where CNO=@P_CNO  
Delete From CLCOSTPIC Where CNO=@P_CNO  
Delete From CFINDICATORH Where CNO=@P_CNO  
  
  
go


insert into PatchVersioning
select '1065 Update Script - 30 May  2024 (2)',GETDATE()
go
	

Declare @PrevScript varchar(100)
Declare @CurrScript varchar(100)

Select @PrevScript=''
Select @CurrSCript='1065 Update Script - 30 May  2024 (2)'


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

  
  
  