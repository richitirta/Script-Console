IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'ApplyReinsuranceDepositF' AND Object_ID = Object_ID(N'SysTab'))
BEGIN
ALTER TABLE SysTab ADD ApplyReinsuranceDepositF bit NULL
DECLARE @v sql_variant 
SET @v = N'Apply Reinsurance Deposit (0 : No, 1 : Yes)'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'SysTab', N'COLUMN', N'ApplyReinsuranceDepositF'
END
GO



IF EXISTS ( SELECT * FROM   sysobjects WHERE  id = object_id(N'[dbo].[QDEPOSIT_REINSURANCE_CESSION]') and OBJECTPROPERTY(id, N'IsProcedure') = 1 )
begin
DROP Procedure QDEPOSIT_REINSURANCE_CESSION
end
GO
CREATE Procedure QDEPOSIT_REINSURANCE_CESSION (@P_ANO integer, @P_RType varchar(255))     
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

IF EXISTS ( SELECT * FROM   sysobjects WHERE  id = object_id(N'[dbo].[QPAYMENTNEXTDUE]') and OBJECTPROPERTY(id, N'IsProcedure') = 1 )
begin
DROP Procedure QPAYMENTNEXTDUE
end
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

IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'BIRPermitNo' AND Object_ID = Object_ID(N'Systab'))
BEGIN
Alter Table Systab Add BIRPermitNo Varchar(100)
END
go

IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'BIRIssueDate' AND Object_ID = Object_ID(N'Systab'))
BEGIN
Alter Table Systab Add BIRIssueDate Smalldatetime
END
go


IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'TOC' AND Object_ID = Object_ID(N'PTClass'))
BEGIN
Alter Table PTClass Add TOC varchar(10)
END
GO



IF NOT EXISTS (SELECT *  FROM sys.indexes WHERE name='I_PTCLASS' AND object_id = OBJECT_ID('PTCLASS'))
BEGIN
Create Unique Index I_PTCLASS on PTCLASS(POLICYTYPE, COB,TOC)
END
GO

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[FL_SR_TOC]') AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) ) 
begin
DROP FUNCTION FL_SR_TOC 
end
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

IF  NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'CLNOTES') AND type in (N'U'))
BEGIN
CREATE TABLE CLNOTES(
	PID int IDENTITY(1,1) NOT NULL,
	CNO int NULL,
	Date smalldatetime NOT NULL,
	Time smalldatetime NULL,
	UserID varchar(50) NULL,
	Category varchar(50) NULL,
	Notes varchar(1024) NULL,
 CONSTRAINT I_CLNOTES PRIMARY KEY CLUSTERED 
(
	PID ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
END
GO

IF EXISTS (SELECT *  FROM sys.indexes WHERE name='I_CLNOTES_CNO' AND object_id = OBJECT_ID('CLNOTES'))
BEGIN
DROP INDEX I_CLNOTES_CNO ON CLNOTES
END
CREATE INDEX I_CLNOTES_CNO on CLNOTES(CNO)
GO


IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'systemF' AND Object_ID = Object_ID(N'clnotes'))
BEGIN
alter table clnotes add systemF bit
END
go

IF EXISTS ( SELECT * FROM   sysobjects WHERE  id = object_id(N'[dbo].[Drop_Claim_Link]') and OBJECTPROPERTY(id, N'IsProcedure') = 1 )
begin
DROP Procedure Drop_Claim_Link
end
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

IF  NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'PNOTES') AND type in (N'U'))
BEGIN
CREATE TABLE PNOTES(
	PID int IDENTITY(1,1) NOT NULL,
	ANO int NULL,
	Date smalldatetime NOT NULL,
	Time smalldatetime NULL,
	UserID varchar(50) NULL,
	Category varchar(50) NULL,
	Notes varchar(1024) NULL,
	SYSTEMF Bit NULL,
 CONSTRAINT I_PNOTES PRIMARY KEY CLUSTERED 
(
	PID ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
END
GO

IF EXISTS (SELECT *  FROM sys.indexes WHERE name='I_PNOTES_ANO' AND object_id = OBJECT_ID('PNOTES'))
BEGIN
DROP INDEX I_PNOTES_ANO ON PNOTES
END
CREATE INDEX I_PNOTES_ANO on PNOTES(ANO)
GO


alter table clnotes 
alter column time varchar(10)
go

alter table PNOTES 
alter column time varchar(10)
go

IF EXISTS ( SELECT * FROM   sysobjects WHERE  id = object_id(N'Drop_Acceptance_Link') and OBJECTPROPERTY(id, N'IsProcedure') = 1 )
BEGIN
DROP Procedure Drop_Acceptance_Link
end
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

IF EXISTS(SELECT * FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS WHERE TABLE_NAME='Branch_TOC' AND CONSTRAINT_NAME='I_BRanch_TOC')
begin
Alter Table Branch_TOC drop constraint I_BRanch_TOC
end
GO

Alter Table Branch_TOC alter column Branch varchar(10) Not Null
GO
Alter Table Branch_TOC alter column TOC varchar(10) Not Null
GO

IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'TAlias' AND Object_ID = Object_ID(N'Branch_TOC'))
BEGIN
Alter Table Branch_TOC add TAlias varchar(10) Null
END
GO

IF EXISTS (SELECT *  FROM sys.indexes WHERE name='I_Branch_TOC' AND object_id = OBJECT_ID('Branch_TOC'))
BEGIN
	ALTER TABLE Branch_TOC DROP CONSTRAINT I_Branch_TOC
END
GO
ALTER TABLE Branch_TOC ADD CONSTRAINT
	I_Branch_TOC PRIMARY KEY CLUSTERED 
	(
	Branch,
	TOC
	) WITH( STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO

IF NOT EXISTS(SELECT * FROM SysForm WHERE FName='REQRDLG')
BEGIN
Insert into SysForm(FName, Description, FCode) Select 'REQRDLG', 'Entry Request Multi Reference (Reqeuest)','FINANCE'
END
GO

IF EXISTS(SELECT * FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS WHERE TABLE_NAME='CLINFO' AND CONSTRAINT_NAME='I_CLINFO')
begin                           

ALTER TABLE CLINFO DROP CONSTRAINT I_CLINFO
END
GO

IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'CLaimant' AND Object_ID = Object_ID(N'CLINFO'))
BEGIN
ALTER TABLE CLINFO ADD CLaimant varchar(10) NULL
END
GO
ALTER TABLE CLINFO SET (LOCK_ESCALATION = TABLE)
GO

IF EXISTS (SELECT *  FROM sys.indexes WHERE name='I_CLINFO' AND object_id = OBJECT_ID('CLINFO'))
BEGIN
	DROP INDEX I_CLINFO ON CLINFO
END
GO
CREATE UNIQUE INDEX I_CLINFO ON CLINFO (CNO, INO, NOC, CLaimant)
GO

IF EXISTS ( SELECT * FROM   sysobjects WHERE  id = object_id(N'CLVIEW01L') and OBJECTPROPERTY(id, N'IsProcedure') = 1 )
BEGIN
DROP PROCEDURE CLVIEW01L 
end
GO
CREATE PROCEDURE CLVIEW01L (@PCNO AS INTEGER)   
AS  
SELECT CLLOSS.*, PPayment.Name as Payment_Name, PClaimant.Name as Claimant_Name, NOCTab.Description as NOC_Desc

FROM CLLOSS
Left Join Profile PPayment on (PPayment.ID=CLLOSS.Payment)
Left Join Profile PClaimant on (PClaimant.ID=CLLOSS.Claimant)
Left Join NOCTAB on (NOCTAB.NOC=CLLOSS.NOC)
WHERE CNO=@PCNO 
GO


IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'DocRefNo' AND Object_ID = Object_ID(N'pslRef'))
BEGIN
alter table pslRef Add DocRefNo varchar(50)
END
GO

IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'RefStatus' AND Object_ID = Object_ID(N'pslRef'))
BEGIN
Alter table pslRef Add RefStatus varchar(20)
END
GO

IF NOT EXISTS(SELECT * FROM MParam WHERE Type='VT')
BEGIN
insert into MParam(Type, Remarks) Select 'VT','VAT Payable'
END
GO


--VERSIONING
insert into versioning
select '2017 V.2.29.0',GETDATE(),'2017 V.2.0.0',GETDATE(),'K: 2017 V.2.0.0',GETDATE()
go


Declare @PrevScript varchar(100)
Declare @CurrScript varchar(100)

Select @PrevScript='38 Script Komulatif Konsol 2.28'
Select @CurrSCript='39 Script Komulatif Konsol 2.29'


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
