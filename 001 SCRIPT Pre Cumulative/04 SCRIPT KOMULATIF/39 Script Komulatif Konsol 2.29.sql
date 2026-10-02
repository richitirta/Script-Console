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
ALTER TABLE dbo.SysTab ADD
	ApplyReinsuranceDepositF bit NULL
GO
DECLARE @v sql_variant 
SET @v = N'Apply Reinsurance Deposit (0 : No, 1 : Yes)'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'SysTab', N'COLUMN', N'ApplyReinsuranceDepositF'
GO
ALTER TABLE dbo.SysTab SET (LOCK_ESCALATION = TABLE)
GO
UPDATE SYSTAB SET ApplyReinsuranceDepositF=1 Where ApplyReinsuranceDepositF is null
GO
COMMIT
GO

DROP Procedure [dbo].[QDEPOSIT_REINSURANCE_CESSION] 
GO
CREATE Procedure [dbo].[QDEPOSIT_REINSURANCE_CESSION] (@P_ANO integer, @P_RType varchar(255))     
AS                           
SELECT Top 1 Reinsurance.RID, Reinsurance.SHARE
From Acceptance       
Inner Join Cover on (Cover.CNO=Acceptance.CNO)      
Inner Join Reinsurance on (Reinsurance.RType='Q')      
Inner Join ReClass on (ReClass.RNO=Reinsurance.RNO and ReClass.TOC=ACCEPTANCE.TOC)      
Left Join RePolicy on (RePolicy.RNO=Reinsurance.RNO)      
Inner Join SysTab on (1=1 and ApplyReinsuranceDepositF=1)
WHERE ACCEPTANCE.ANO=@P_ANO
And Acceptance.SDate Between Reinsurance.SDate And Reinsurance.EDate       
And (coalesce(RePolicy.ID,'')='' or  coalesce(RePolicy.ID,'')=Cover.PHolder)    
Order By coalesce(RePolicy.ID,'') Desc, (Case When ReClass.PriorityF=1 Then ReClass.PriorityF else Reinsurance.PriorityF end) Desc                   
  


go

DROP PROCEDURE QPAYMENTNEXTDUE 
GO
CREATE PROCEDURE QPAYMENTNEXTDUE (@P_ANO AS INTEGER,@P_PDate as smalldatetime)                      

AS 

Declare @P_APolicyNo as varchar(50)        
Declare @P_AdmNo as int
Select   
Top 1
@P_APolicyNo=Case When Cover.OpenFlag=1 and Acceptance.BulkF=0 Then Acceptance.PolicyNo+Case When Acceptance.CertificateNo<>'' Then '-'+Acceptance.CertificateNo else '' end else Acceptance.PolicyNo end,  
@P_AdmNo=Admlink.AdmNo
from Acceptance   
Inner Join AccAss on (AccAss.ANO=Acceptance.ANO)
Inner Join Admlink on (Admlink.Admno=AccAss.AdmNo and Admlink.Type in ('DI','IC','IR'))
Inner Join Cover on (Cover.CNO=Acceptance.CNO)  
Where Acceptance.ANO=@P_ANO                
Order by Admlink.AdmNo desc


Select
nVoucher.Currency,
nVoucher.Voucher,
Max(Currency.Rate) as Rate,
Max(CASE WHEN nVoucher.DEBTORF=1 THEN (Voucher_Due.AmountDue-nVoucher.Payment_CC) ELSE -(Voucher_Due.AmountDue-nVoucher.Payment_CC) END) as AmountDue
FROM Admlink 
Inner Join nVoucher on (nVoucher.Voucher=Admlink.Voucher)   
Inner Join Voucher_AmountNextDue(@P_PDate) Voucher_Due on (Voucher_Due.Voucher=nVoucher.Voucher)          
Inner Join fn_Exchange(@P_PDate) Currency on (Currency.Currency=Admlink.Currency)
Where Admlink.Subject='Premium' and Admlink.Type in ('DI','IC','IR') 
and Admlink.A_PolicyNo=@P_APolicyNo and Admlink.AdmNo<=@P_ADMNO
Group by nVoucher.Currency,nVoucher.Voucher
Having Max(CASE WHEN nVoucher.DEBTORF=1 THEN (Voucher_Due.AmountDue-nVoucher.Payment_CC) ELSE -(Voucher_Due.AmountDue-nVoucher.Payment_CC) END)>=0


go

Alter Table Systab Add BIRPermitNo Varchar(100)
go
Alter Table Systab Add BIRIssueDate Smalldatetime
go
Update Systab Set BIRPermitNo = '0910-116-00109 CBA/AR', BIRIssueDate = '03/26/2013'
go

Alter Table PTClass Add TOC varchar(10)
GO
Update PTClass Set TOC='<All>' Where TOC is null
GO
Alter Table PTClass drop constraint I_PTCLASS
GO
Create Unique Index I_PTCLASS on PTCLASS(POLICYTYPE, COB,TOC)
GO
DROP function FL_SR_TOC
GO
Create function FL_SR_TOC(@P_USERID varchar(50), @P_TOC varchar(10),@P_PolicyType varchar(10))  
RETURNS Table  
AS RETURN  
(

Select Distinct TOC.TOC,TOC.Description 
From TOC, PTClass, SysUserTOC S 
Where TOC.AllowedF=1 and S.ID=@P_USERID and S.TOC=TOC.TOC and PTClass.COB=TOC.COB and PTClass.PolicyType like @P_PolicyType+'%' and (PTCLASS.TOC='<All>' or PTCLASS.TOC=TOC.TOC) and TOC.TOC like @P_TOC+'%' 
and S.Effective<=cast(convert(varchar(10),getdate(),1) as smalldatetime)
and not exists (Select S1.ID from SysUserTOC S1 Where S1.TOC=S.TOC and S1.ID=S.ID and S1.Effective<=cast(convert(varchar(10),getdate(),1) as smalldatetime) and S1.Effective>S.Effective)
)

go

CREATE TABLE [dbo].[CLNOTES](
	[PID] [int] IDENTITY(1,1) NOT NULL,
	[CNO] [int] NULL,
	[Date] [smalldatetime] NOT NULL,
	[Time] [smalldatetime] NULL,
	[UserID] [varchar](50) NULL,
	[Category] [varchar](50) NULL,
	[Notes] [varchar](1024) NULL,
 CONSTRAINT [I_CLNOTES] PRIMARY KEY CLUSTERED 
(
	[PID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO

CREATE INDEX I_CLNOTES_CNO on CLNOTES(CNO)
GO
SET ANSI_PADDING OFF
GO

GO


alter table clnotes 
add systemF bit
go

update CLNOTES set SYSTEMF=0 where SYSTEMF is null
go

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



go


CREATE TABLE [dbo].[PNOTES](
	[PID] [int] IDENTITY(1,1) NOT NULL,
	[ANO] [int] NULL,
	[Date] [smalldatetime] NOT NULL,
	[Time] [smalldatetime] NULL,
	[UserID] [varchar](50) NULL,
	[Category] [varchar](50) NULL,
	[Notes] [varchar](1024) NULL,
	[SYSTEMF] [Bit] NULL,
 CONSTRAINT [I_PNOTES] PRIMARY KEY CLUSTERED 
(
	[PID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO

CREATE INDEX I_PNOTES_ANO on PNOTES(ANO)
GO
SET ANSI_PADDING OFF
GO

alter table clnotes 
alter column time varchar(10)
go

alter table PNOTES 
alter column time varchar(10)
go


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


go

Alter Table Branch_TOC drop constraint I_BRanch_TOC
GO
Alter Table Branch_TOC alter column Branch varchar(10) Not Null
GO
Alter Table Branch_TOC alter column TOC varchar(10) Not Null
GO
Alter Table Branch_TOC add TAlias varchar(10) Null
GO

ALTER TABLE dbo.Branch_TOC ADD CONSTRAINT
	I_Branch_TOC PRIMARY KEY CLUSTERED 
	(
	Branch,
	TOC
	) WITH( STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]

GO


Insert into SysForm(FName, Description, FCode) Select 'REQRDLG', 'Entry Request Multi Reference (Reqeuest)','FINANCE'
go


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
ALTER TABLE dbo.CLINFO
	DROP CONSTRAINT I_CLINFO
GO
ALTER TABLE dbo.CLINFO SET (LOCK_ESCALATION = TABLE)
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
ALTER TABLE dbo.CLINFO ADD
	CLaimant varchar(10) NULL
GO
ALTER TABLE dbo.CLINFO SET (LOCK_ESCALATION = TABLE)
GO
COMMIT
GO
UPDATE CLINFO SET CLaimant=CLLOSS.CLaimant FROM CLINFO, CLLOSS WHERE CLINFO.CLaimant IS NULL AND CLLOSS.CNO=CLINFO.CNO AND CLLOSS.INO=CLINFO.INO AND CLLOSS.NOC=CLINFO.NOC
GO
CREATE UNIQUE INDEX I_CLINFO ON CLINFO (CNO, INO, NOC, CLaimant)

GO

DROP PROCEDURE CLVIEW01L 
GO
CREATE PROCEDURE CLVIEW01L (@PCNO AS INTEGER)   
AS  
SELECT CLLOSS.*, PPayment.Name as Payment_Name, PClaimant.Name as Claimant_Name, NOCTab.Description as NOC_Desc

FROM CLLOSS
Left Join Profile PPayment on (PPayment.ID=CLLOSS.Payment)
Left Join Profile PClaimant on (PClaimant.ID=CLLOSS.Claimant)
Left Join NOCTAB on (NOCTAB.NOC=CLLOSS.NOC)
WHERE CNO=@PCNO 







go


Update CollectionH SEt RepDate=CollDate from CollectionH Where CollStatus='R' and RepDate Is null
go



alter table pslRef Add DocRefNo varchar(50)
GO
Alter table pslRef Add RefStatus varchar(20)
GO
Update pSLRef Set DocRefNo='' Where DocRefNO is null
Update pSLRef Set RefStatus='' Where RefStatus is null

go



insert into MParam(Type, Remarks) Select 'VT','VAT Payable'
go

--VERSIONING
insert into versioning
select '2017 V.2.29.0',GETDATE(),'2017 V.2.0.0',GETDATE(),'K: 2017 V.2.0.0',GETDATE()
go
