--tuning upload
 IF Not EXISTS (SELECT Name FROM sysindexes WHERE Name = 'I_SysBatchUp_BatchNo_RefNo') 
BEGIN
Create Index I_SysBatchUp_BatchNo_RefNo on SysBatchUp(BatchNo, RefNo)
end
GO

 IF Not EXISTS (SELECT Name FROM sysindexes WHERE Name = 'I_SysBatchSC_BatchNo_RefNo') 
BEGIN
Create Index I_SysBatchSC_BatchNo_RefNo on SysBatchSC(BatchNo, RefNo)
end
GO

 IF Not EXISTS (SELECT Name FROM sysindexes WHERE Name = 'I_Acceptance_BatchNo_RefNo') 
BEGIN
Create Index I_Acceptance_BatchNo_RefNo on Acceptance(BatchNo, RefNo)
end
GO

 IF Not EXISTS (SELECT Name FROM sysindexes WHERE Name = 'I_Scheme_Transaction_BatchNo_ContractNo') 
BEGIN
Create Index I_Scheme_Transaction_BatchNo_ContractNo on Scheme_Transaction(BatchNo, ContractNo)
end
GO

 IF EXISTS (SELECT Name FROM sysindexes WHERE Name = 'I_Acceptance_LUserID') 
BEGIN
drop index Acceptance.I_Acceptance_LUserID
end
GO
 IF EXISTS (SELECT Name FROM sysindexes WHERE Name = 'I_Acceptance_EDate') 
BEGIN
drop index Acceptance.I_Acceptance_EDate
end
GO
 IF EXISTS (SELECT Name FROM sysindexes WHERE Name = 'I_Acceptance_AName') 
BEGIN
drop index Acceptance.I_Acceptance_AName
end
GO
 IF EXISTS (SELECT Name FROM sysindexes WHERE Name = 'I_Acceptance_AID') 
BEGIN
drop index Acceptance.I_Acceptance_AID
end
GO
 IF EXISTS (SELECT Name FROM sysindexes WHERE Name = 'i_ACCEPTANCE_Branch') 
BEGIN
drop index Acceptance.i_ACCEPTANCE_Branch
end
GO
 IF EXISTS (SELECT Name FROM sysindexes WHERE Name = 'I_Claim_ADate') 
BEGIN
drop index Claim.I_Claim_ADate
end
GO
 IF EXISTS (SELECT Name FROM sysindexes WHERE Name = 'I_Claim_Branch') 
BEGIN
drop index Claim.I_Claim_Branch
end
GO
 IF EXISTS (SELECT Name FROM sysindexes WHERE Name = 'I_Claim_TOC') 
BEGIN
drop index Claim.I_Claim_TOC
end
GO

IF EXISTS(SELECT * FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS WHERE TABLE_NAME='SysBatchOriginalSC' AND CONSTRAINT_NAME='I_SysBatchoriginalsc')
begin
Alter Table SysBatchOriginalSC drop constraint I_SysBatchoriginalsc
end
GO
IF EXISTS(SELECT * FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS WHERE TABLE_NAME='SysBatchOriginalUP' AND CONSTRAINT_NAME='I_SysBatchoriginalUP')
begin
Alter Table SysBatchOriginalUP drop constraint I_SysBatchoriginalUP
end
GO
IF EXISTS(SELECT * FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS WHERE TABLE_NAME='SysBatchOriginalBE' AND CONSTRAINT_NAME='I_SysBatchoriginalBE')
begin
Alter Table SysBatchOriginalBE drop constraint I_SysBatchoriginalBE
end
GO
IF EXISTS(SELECT * FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS WHERE TABLE_NAME='SysBatchOriginalBC' AND CONSTRAINT_NAME='I_SysBatchoriginalBC')
begin
Alter Table SysBatchOriginalBC drop constraint I_SysBatchoriginalBC
end
GO

IF EXISTS(SELECT * FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS WHERE TABLE_NAME='SysBatchBC' AND CONSTRAINT_NAME='I_sysbatchBC')
begin
Alter Table SysBatchBC drop constraint I_sysbatchBC
end
GO
IF EXISTS(SELECT * FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS WHERE TABLE_NAME='SysBatchBE' AND CONSTRAINT_NAME='I_sysbatchBE')
begin
Alter Table SysBatchBE drop constraint I_sysbatchBE
end
GO
IF EXISTS(SELECT * FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS WHERE TABLE_NAME='SysBatchUP' AND CONSTRAINT_NAME='I_sysbatchup')
begin
Alter Table SysBatchUP drop constraint I_sysbatchup
end
GO
IF EXISTS(SELECT * FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS WHERE TABLE_NAME='SysBatchSC' AND CONSTRAINT_NAME='I_SysBatchSC')
begin
Alter Table SysBatchSC drop constraint I_SysBatchSC
end
GO

IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].FK_SysBatchOriginalBC_SysBatchH') AND parent_object_id = OBJECT_ID(N'[dbo].SysBatchOriginalBC'))
begin
Alter Table SysBatchOriginalBC drop constraint FK_SysBatchOriginalBC_SysBatchH
end
GO

IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].FK_SysBatchOriginalBE_SysBatchH') AND parent_object_id = OBJECT_ID(N'[dbo].SysBatchOriginalBE'))
begin
Alter Table SysBatchOriginalBE drop constraint FK_SysBatchOriginalBE_SysBatchH
end
GO

IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].FK_SysBatchOriginalSC_SysBatchH') AND parent_object_id = OBJECT_ID(N'[dbo].SysBatchOriginalSC'))
begin
Alter Table SysBatchOriginalSC drop constraint FK_SysBatchOriginalSC_SysBatchH
end
GO

IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].FK_SysBatchOriginalUP_SysBatchH') AND parent_object_id = OBJECT_ID(N'[dbo].SysBatchOriginalUP'))
begin
Alter Table SysBatchOriginalUP drop constraint FK_SysBatchOriginalUP_SysBatchH
end
GO

IF Not EXISTS (SELECT *  FROM sys.indexes WHERE name='I_SysBatchSC' AND object_id = OBJECT_ID('SysBatchSC'))
BEGIN
Create Unique Index I_SysBatchSC on SysBatchSC(BID)
end
GO
IF Not EXISTS (SELECT *  FROM sys.indexes WHERE name='I_SysBatchUP' AND object_id = OBJECT_ID('SysBatchUP'))
BEGIN
Create Unique Index I_SysBatchUP on SysBatchUP(BID)
end
GO
IF Not EXISTS (SELECT *  FROM sys.indexes WHERE name='I_SysBatchUP' AND object_id = OBJECT_ID('SysBatchUP'))
BEGIN
Create Unique Index I_SysBatchBE on SysBatchBE(BID)
end
GO
IF Not EXISTS (SELECT *  FROM sys.indexes WHERE name='I_SysBatchUP' AND object_id = OBJECT_ID('SysBatchUP'))
BEGIN
Create Unique Index I_SysBatchBC on SysBatchBC(BID)
end
GO
IF Not EXISTS (SELECT *  FROM sys.indexes WHERE name='I_SysBatchOriginalSC' AND object_id = OBJECT_ID('I_SysBatchOriginalSC'))
BEGIN
Create Unique Index I_SysBatchOriginalSC on SysBatchOriginalSC(BID)
end
GO
IF Not EXISTS (SELECT *  FROM sys.indexes WHERE name='I_SysBatchOriginalUP' AND object_id = OBJECT_ID('SysBatchOriginalUP'))
BEGIN
Create Unique Index I_SysBatchOriginalUP on SysBatchOriginalUP(BID)
end
GO
IF Not EXISTS (SELECT *  FROM sys.indexes WHERE name='I_SysBatchOriginalBE' AND object_id = OBJECT_ID('SysBatchOriginalBE'))
BEGIN
Create Unique Index I_SysBatchOriginalBE on SysBatchOriginalBE(BID)
end
GO
IF Not EXISTS (SELECT *  FROM sys.indexes WHERE name='I_SysBatchOriginalBC' AND object_id = OBJECT_ID('SysBatchOriginalBC'))
BEGIN
Create Unique Index I_SysBatchOriginalBC on SysBatchOriginalBC(BID)
end
GO



--Penambahan Detail Reference di Receipt Request
IF Not EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SL_RequestRef]') AND type in (N'U'))
begin
CREATE TABLE [dbo].[SL_RequestRef](
	[Request] [varchar](20) NOT NULL,
	[Description] [varchar](50) NOT NULL,
	[Nominal] [float] NULL,
	[RefDate] [smalldatetime] NULL,
	[RefNo] [varchar](50) NULL,
	[RefType] [varchar](50) NULL
) ON [PRIMARY]
ALTER TABLE [dbo].[SL_RequestRef]  WITH CHECK ADD  CONSTRAINT [FK_SL_RequestRef_Request] FOREIGN KEY([Request])
REFERENCES [dbo].[Request] ([Request])
ON UPDATE CASCADE
ON DELETE CASCADE
ALTER TABLE [dbo].[SL_RequestRef] CHECK CONSTRAINT [FK_SL_RequestRef_Request]
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Voucher No (see pVoucher)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'SL_RequestRef', @level2type=N'COLUMN',@level2name=N'Request'
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Reference No.(Payment Voucher No. / Overbooking Voucher No. for Adjustment or Overbooking)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'SL_RequestRef', @level2type=N'COLUMN',@level2name=N'RefNo'
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Reference Type (''Cheque'', ''Giro'')' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'SL_RequestRef', @level2type=N'COLUMN',@level2name=N'RefType'
end
go


IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'RefAmount' AND Object_ID = Object_ID(N'Request'))
BEGIN
ALTER TABLE dbo.Request ADD	RefAmount float(53) NULL
end
go

if exists (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[FL_SL_ACCOUNT]') AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) )
BEGIN
DROP FUNCTION FL_SL_ACCOUNT
end
GO
CREATE FUNCTION FL_SL_ACCOUNT(@P_GID varchar(10), @P_Voucher varchar(20), @P_VType varchar(10), @P_ComAcc varchar(30), @P_Doc_No varchar(20),@P_CCY varchar(10), @P_Payment_Flag bit) 
RETURNS @TSL_Account TABLE (Account Varchar(10), Open_ItemF Bit, Branch Varchar(15), Hint Int, Description varchar(512), Currency varchar(10), AccGroup varchar(10), Outstanding Float) 
AS 
BEGIN 
Declare @P_SL_Cat varchar(1) 
if @P_Payment_Flag=1 
Begin 
Select @P_SL_Cat=SL_Cat from pVoucher Where Voucher=@P_Doc_No 
if @P_SL_Cat is null 
Begin 
Select @P_SL_Cat='N' 
End 
if @P_SL_Cat='P' 
Begin 
insert into @TSL_Account 
Select A1.Account, A2.Open_ItemF, A1.Branch, A1.Hint, A2.Description, V.Currency, A2.AccGroup, 
(Case When VType.DebtorF=1 Then 1 Else -1 end)*(Case When V.DebtorF=1 then -(Max(A1.Nominal_OC)-sum(Case When SL_Alloc.Nominal_OC is null then 0 else SL_Alloc.Nominal_OC end)) else (Max(A1.Nominal_OC)-sum(Case When SL_Alloc.Nominal_OC is null then 0 else SL_Alloc.Nominal_OC end)) end) as Outstanding 
from pVoucher V 
Inner Join Get_Open_Item_Hint_P(@P_Doc_No,@P_VType) A1 on (A1.Voucher=V.Voucher) 
Inner join VType on (VType.VType=@P_VType) 
Inner Join Account A2 on (A2.Account=A1.Account) 
Left Join ComAcc on (ComAcc.ComAcc=@P_ComAcc) 
Left Join Open_Item_Allocated(@P_Doc_No) SL_Alloc on (SL_Alloc.Voucher<>@P_Voucher and SL_Alloc.Doc_no=A1.Voucher and SL_Alloc.Branch=A1.Branch and SL_Alloc.Account=A1.Account) 
Where @P_Doc_No<>'' and A1.Voucher=V.Voucher 
and ((coalesce(ComAcc.ComAcc,'')='' and A2.AccGroup='') or (coalesce(ComAcc.ComAcc,'')<>'' and (Coalesce(ComAcc.AccGroup,'')='' or A2.AccGroup='' or Coalesce(ComAcc.AccGroup,'')=A2.AccGroup))) 
Group By A1.Account, A2.Open_ItemF, A1.Branch, A1.Hint, VType.DebtorF, V.DebtorF, V.SL_Cat, A2.Description, V.Currency , A2.AccGroup 
Having round(Max(A1.Nominal_OC),2)<>round(sum(Case When SL_Alloc.Nominal_OC is null then 0 else SL_Alloc.Nominal_OC end),2) 
End 
else 
Begin 
insert into @TSL_Account 
Select A1.Account, A2.Open_ItemF, A1.Branch, A1.Hint, A2.Description, V.Currency, A2.AccGroup,
(Case When VType.DebtorF=1 Then 1 Else -1 end)*(Case When V.DebtorF=1 then (Max(A1.Nominal_OC)-sum(Case When SL_Alloc.Nominal_OC is null then 0 else SL_Alloc.Nominal_OC end)) else (Max(A1.Nominal_OC)-sum(Case When SL_Alloc.Nominal_OC is null then 0 else SL_Alloc.Nominal_OC end)) end) as Outstanding 
from nVoucher V 
Inner Join Get_Open_Item_Hint_N(@P_Doc_No,@P_VType) A1 on (A1.Voucher=V.Voucher) 
Inner join VType on (VType.VType=@P_VType) 
Inner Join Account A2 on (A2.Account=A1.Account) 
Left Join ComAcc on (ComAcc.ComAcc=@P_ComAcc)
Left Join Open_Item_Allocated(@P_Doc_No) SL_Alloc on (SL_Alloc.Voucher<>@P_Voucher and SL_Alloc.Doc_no=A1.Voucher and SL_Alloc.Branch=A1.Branch and SL_Alloc.Account=A1.Account) 
Where @P_Doc_No<>'' and A1.Voucher=V.Voucher 
and ((coalesce(ComAcc.ComAcc,'')='' and A2.AccGroup='') or (coalesce(ComAcc.ComAcc,'')<>'' and (Coalesce(ComAcc.AccGroup,'')='' or A2.AccGroup='' or Coalesce(ComAcc.AccGroup,'')=A2.AccGroup))) 
Group By A1.Account, A2.Open_ItemF, A1.Branch, A1.Hint, VType.DebtorF, V.DebtorF, V.SL_Cat, A2.Description, V.Currency, A2.AccGroup 
Having round(Max(A1.Nominal_OC),2)<>round(sum(Case When SL_Alloc.Nominal_OC is null then 0 else SL_Alloc.Nominal_OC end),2) 
End 
End 
Else 
Begin 
if @P_GID='' 
Begin 
insert into @TSL_Account 
Select A1.Account, A1.Open_ItemF, '' as Branch, max(CASE WHEN vtype.debtorf=1 THEN vPattern.Credit ELSE vpattern.debit end) as Hint, A1.Description, Case When @P_CCY='' then SysTab.Currency else @P_CCY end as Currency, A1.AccGroup, 0 as Outstanding 
from Account A1 
Left Join ComAcc on (ComAcc.ComAcc=@P_ComAcc), Account a2, vPattern, SysTab, VType 
Where A1.AllowedF=1 and a1.post_flag=1 and a1.parent=a2.parent and a2.account=vPattern.account and vPattern.Constant_Flag=1 and ((vPattern.Credit<0 AND VType.DebtorF = 1) or (vPattern.Debit<0 AND VType.CreditorF = 1)) and VType.Vtype=@P_VType AND VType.VType = VPattern.VType and (A1.Hold_Flag<>1 or A1.Suspend_Flag=1) 
and ((coalesce(ComAcc.ComAcc,'')='' and A1.AccGroup='') or (coalesce(ComAcc.ComAcc,'')<>'' and (Coalesce(ComAcc.AccGroup,'')='' or A1.AccGroup='' or Coalesce(ComAcc.AccGroup,'')=A1.AccGroup))) 
Group By A1.Account, A1.Open_ItemF, A1.Description, SysTab.Currency, A1.AccGroup 
End 
Else 
Begin 
insert into @TSL_Account 
Select A1.Account, A1.Open_ItemF, '' as Branch, max(CASE WHEN vtype.debtorf=1 THEN vPattern.Credit ELSE vpattern.debit end) as Hint, B.Description, Case When @P_CCY='' then SysTab.Currency else @P_CCY end as Currency, A1.AccGroup, 0 as Outstanding 
from Budget_AccountDetail B, Account A1 
Left Join ComAcc on (ComAcc.ComAcc=@P_ComAcc), Account a2, vPattern, SysTab, VType 
Where B.GID=@P_GID and B.ID=@P_Doc_No and (A1.Account=B.Account_Dr or A1.Account=B.Account_Cr) and A1.AllowedF=1 and a1.post_flag=1 and a1.parent=a2.parent and a2.account=vPattern.account and vPattern.Constant_Flag=1 and ((vPattern.Credit<0 AND VType.DebtorF = 1) or (vPattern.Debit<0 AND VType.CreditorF = 1)) and VType.Vtype=@P_VType AND VType.VType = VPattern.VType and (A1.Hold_Flag<>1 or A1.Suspend_Flag=1) 
and ((coalesce(ComAcc.ComAcc,'')='' and A1.AccGroup='') or (coalesce(ComAcc.ComAcc,'')<>'' and (Coalesce(ComAcc.AccGroup,'')='' or A1.AccGroup='' or Coalesce(ComAcc.AccGroup,'')=A1.AccGroup))) 
Group By A1.Account, A1.Open_ItemF, B.Description, SysTab.Currency, A1.AccGroup 
End 
End 
Return 
END 
go


drop table [CompanyType]
go
CREATE TABLE [dbo].[CompanyType](
	[CompanyType] [varchar](50) NULL,
	[CompDesc] [varchar](50) NULL
) ON [PRIMARY]

GO

INSERT INTO CompanyType VALUES ('','')
INSERT INTO CompanyType VALUES ('GOVERNMENT','Government')
INSERT INTO CompanyType VALUES ('PRIVATE','Private')
INSERT INTO CompanyType VALUES ('J. VENTURE','Join Venture')
INSERT INTO CompanyType VALUES ('BUMN','BUMN')
INSERT INTO CompanyType VALUES ('BUMD','BUMD')
INSERT INTO CompanyType VALUES ('CAPTIVE','Captive')
INSERT INTO CompanyType VALUES ('TEST','TEST desc')
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
ALTER TABLE dbo.CARRHEADER ADD
	XLExcess float(53) NULL,
	XLEExcess float(53) NULL
GO
DECLARE @v sql_variant 
SET @v = N'Amount Excess before XOL Event (by Indemnity Amount)'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'CARRHEADER', N'COLUMN', N'XLExcess'
GO
DECLARE @v sql_variant 
SET @v = N'Amount Excess Before Event XOL (By Estimate Claim)'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'CARRHEADER', N'COLUMN', N'XLEExcess'
GO
ALTER TABLE dbo.CARRHEADER SET (LOCK_ESCALATION = TABLE)
GO
COMMIT

DROP PROCEDURE QObjectValuation
GO
CREATE PROCEDURE QObjectValuation(@P_INO as integer, @P_VDate as smalldatetime='1900/01/01', @P_SI as Float=0)     
AS     
Declare @P_Value as float
Declare @P_ValuePCT as Float

if @P_VDate='1900/01/01'   
 Select @P_VDate=ACCEPTANCE.SDATE from ICOVER, ACCEPTANCE WHERE ACCEPTANCE.ANO=ICOVER.ANO AND ICOVER.INO=@P_INO     

Select @P_Value=Value, @P_ValuePCT=ValuePCT from fn_ObjectValuation(@P_INO, @P_VDATE)     

if @P_SI<>0
Begin
	Select @P_SI = @P_SI * (100+@P_ValuePCT)/100
End
Else
Begin
	Select @P_SI = @P_Value
End

if @P_Value<>0 and @P_SI>@P_Value 
Begin
	Select @P_SI = @P_Value
End

Select @P_Value as Value, @P_ValuePCT as ValuePCT, @P_SI as SI

go

UPDATE CLLOSS SET EDepreciation=0 WHERE  EDepreciation IS NULL
UPDATE CLLOSS SET Depreciation=0 WHERE  Depreciation IS NULL
go


EXEC sys.sp_dropextendedproperty @name=N'MS_Description' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RESEGMENT', @level2type=N'COLUMN',@level2name=N'SEGMENT'

GO

EXEC sys.sp_dropextendedproperty @name=N'MS_Description' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RESEGMENT', @level2type=N'COLUMN',@level2name=N'RNO'

GO

ALTER TABLE [dbo].[RESEGMENT] DROP CONSTRAINT [FK_RESEGMENT_REINSURANCE1]
GO

/****** Object:  Table [dbo].[RESEGMENT]    Script Date: 1/9/2018 7:42:40 PM ******/
DROP TABLE [dbo].[RESEGMENT]
GO

/****** Object:  Table [dbo].[RESEGMENT]    Script Date: 1/9/2018 7:42:40 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

SET ANSI_PADDING ON
GO

CREATE TABLE [dbo].[RESEGMENT](
	[RNO] [int] NOT NULL,
	[SEGMENT] [varchar](10) NOT NULL
) ON [PRIMARY]

GO

SET ANSI_PADDING OFF
GO

ALTER TABLE [dbo].[RESEGMENT]  WITH CHECK ADD  CONSTRAINT [FK_RESEGMENT_REINSURANCE1] FOREIGN KEY([RNO])
REFERENCES [dbo].[REINSURANCE] ([RNO])
ON UPDATE CASCADE
ON DELETE CASCADE
GO

ALTER TABLE [dbo].[RESEGMENT] CHECK CONSTRAINT [FK_RESEGMENT_REINSURANCE1]
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Reinsurance No. (see Reinsurance)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RESEGMENT', @level2type=N'COLUMN',@level2name=N'RNO'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Type Of Cover (see TOC)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RESEGMENT', @level2type=N'COLUMN',@level2name=N'SEGMENT'
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
ALTER TABLE dbo.REINSURANCE ADD
	ApplySegmentF bit NULL
GO
DECLARE @v sql_variant 
SET @v = N'Apply Treaty By Segment (0 : No, 1 : Yes)'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'REINSURANCE', N'COLUMN', N'ApplySegmentF'
GO
ALTER TABLE dbo.REINSURANCE SET (LOCK_ESCALATION = TABLE)
GO
UPDATE Reinsurance SET ApplySegmentF=0 Where ApplySegmentF is null
COMMIT
GO
DROP Procedure QREINSURANCE_CESSION 
GO
CREATE Procedure QREINSURANCE_CESSION (@P_ANO integer, @P_ADate smalldatetime, @P_RType varchar(255), @P_TSI Float=0, @P_RID varchar(20)='', @P_ManualF Bit=0, @P_GROSS Float=0)                                
as                                                          
SELECT (Case When ReClass.PriorityF=1 Then ReClass.PriorityF else Reinsurance.PriorityF end) as PriorityF, Reinsurance.RID, Reinsurance.RType,                                
ReClass.PLimit*Case When coalesce(R1.Rate,0)=0 Then (Case When Reinsurance.Currency='' or Reinsurance.Currency=SysTab.Currency Then 1 Else (Select Rate from fn_exchange(Acceptance.SDate) Currency Where Currency=Reinsurance.Currency) End) else coalesce(R1.Rate,1)*coalesce(R2.Rate,1) end as PLimit, 
Case RECLASS.Limit WHEN 0 then Reinsurance.Limit Else RECLASS.Limit end*Case When coalesce(R1.Rate,0)=0 Then (Case When Reinsurance.Currency='' or Reinsurance.Currency=SysTab.Currency Then 1 Else (Select Rate from fn_exchange(Acceptance.SDate) Currency Where Currency=Reinsurance.Currency) End) else coalesce(R1.Rate,1)*coalesce(R2.Rate,1) end  as limit, 
ReClass.ShortFallLimit*Case When coalesce(R1.Rate,0)=0 Then (Case When Reinsurance.Currency='' or Reinsurance.Currency=SysTab.Currency Then 1 Else (Select Rate from fn_exchange(Acceptance.SDate) Currency Where Currency=Reinsurance.Currency) End) else coalesce(R1.Rate,1)*coalesce(R2.Rate,1) end  as ShortFallLimit,              
ReClass.MinTSI*Case When coalesce(R1.Rate,0)=0 Then (Case When Reinsurance.Currency='' or Reinsurance.Currency=SysTab.Currency Then 1 Else (Select Rate from fn_exchange(Acceptance.SDate) Currency Where Currency=Reinsurance.Currency) End) else coalesce(R1.Rate,1)*coalesce(R2.Rate,1) end  as MinTI, 
ReClass.AssessmentExInwardF,
Reinsurance.UjrohReins, Reinsurance.UjrohCedant, Reinsurance.Share, Reinsurance.PShare, Acceptance.FLDID, Acceptance.ValueID, ReClass.CessionF, ReClass.AssessmentF, ReClass.DirectF                                
From Acceptance       
Inner Join Cover on (Cover.CNO=Acceptance.CNO)      
Left Join RArrHeader on (RArrHeader.ANO=Acceptance.ANO)      
Inner Join Reinsurance on (Reinsurance.RType=@P_RType)      
Inner Join ReClass on (ReClass.RNO=Reinsurance.RNO and ReClass.TOC=Acceptance.TOC and (ReClass.DirectF=0 or Cover.ISType in ('I','L','C')))      
Left Join RePolicy on (RePolicy.RNO=Reinsurance.RNO)      
Left Join ReRate R1 on (R1.TOC=Acceptance.TOC and R1.RYear=Reinsurance.RYEAR and R1.Currency=Reinsurance.Currency)
left Join ReRate R2 on (R2.TOC=R1.TOC and R2.RYear=R1.RYear and R2.Currency=R1.CCYTo)
Inner Join SysTab on (1=1)
WHERE ACCEPTANCE.ANO=@P_ANO         
And Case When Reinsurance.PolicyRunOffF=1 Then Acceptance.SDate else @P_ADATE end Between Reinsurance.SDate And Reinsurance.EDate         
And (@P_RID='' or Reinsurance.RID=@P_RID or RArrHeader.ManualF=0 or Acceptance.EMethod='T')                            
And (coalesce(RePolicy.ID,'')='' or  coalesce(RePolicy.ID,'')=Cover.PHolder)    
And (@P_ManualF=1 or RArrHeader.ManualF=1 or       
(      
 (Reinsurance.ORBusinessF=RArrHeader.ORBusinessF)      
 And (@P_TSI>=ReClass.MinTSI*Case When coalesce(R1.Rate,0)=0 Then (Case When Reinsurance.Currency='' or Reinsurance.Currency=SysTab.Currency Then 1 Else (Select Rate from fn_exchange(Acceptance.SDate) Currency Where Currency=Reinsurance.Currency) End) else coalesce(R1.Rate,1)*coalesce(R2.Rate,1) end  or ReClass.MinTSI*Case When coalesce(R1.Rate,0)=0 Then (Case When Reinsurance.Currency='' or Reinsurance.Currency=SysTab.Currency Then 1 Else (Select Rate from fn_exchange(Acceptance.SDate) Currency Where Currency=Reinsurance.Currency) End) else coalesce(R1.Rate,1)*coalesce(R2.Rate,1) end =0) and (@P_TSI<=ReClass.MaxTSI*Case When coalesce(R1.Rate,0)=0 Then (Case When Reinsurance.Currency='' or Reinsurance.Currency=SysTab.Currency Then 1 Else (Select Rate from fn_exchange(Acceptance.SDate) Currency Where Currency=Reinsurance.Currency) End) else coalesce(R1.Rate,1)*coalesce(R2.Rate,1) end  or ReClass.MaxTSI*Case When coalesce(R1.Rate,0)=0 Then (Case When Reinsurance.Currency='' or Reinsurance.Currency=SysTab.Currency Then 1 Else (Select Rate from fn_exchange(Acceptance.SDate) Currency Where Currency=Reinsurance.Currency) End) else coalesce(R1.Rate,1)*coalesce(R2.Rate,1) end =0) 
 and (@P_GROSS>=ReClass.MinGross*Case When coalesce(R1.Rate,0)=0 Then (Case When Reinsurance.Currency='' or Reinsurance.Currency=SysTab.Currency Then 1 Else (Select Rate from fn_exchange(Acceptance.SDate) Currency Where Currency=Reinsurance.Currency) End) else coalesce(R1.Rate,1)*coalesce(R2.Rate,1) end  or ReClass.MinGross*Case When coalesce(R1.Rate,0)=0 Then (Case When Reinsurance.Currency='' or Reinsurance.Currency=SysTab.Currency Then 1 Else (Select Rate from fn_exchange(Acceptance.SDate) Currency Where Currency=Reinsurance.Currency) End) else coalesce(R1.Rate,1)*coalesce(R2.Rate,1) end =0) and (@P_GROSS<=ReClass.MaxGross*Case When coalesce(R1.Rate,0)=0 Then (Case When Reinsurance.Currency='' or Reinsurance.Currency=SysTab.Currency Then 1 Else (Select Rate from fn_exchange(Acceptance.SDate) Currency Where Currency=Reinsurance.Currency) End) else coalesce(R1.Rate,1)*coalesce(R2.Rate,1) end  or ReClass.MaxGross*Case When coalesce(R1.Rate,0)=0 Then (Case When Reinsurance.Currency='' or Reinsurance.Currency=SysTab.Currency Then 1 Else (Select Rate from fn_exchange(Acceptance.SDate) Currency Where Currency=Reinsurance.Currency) End) else coalesce(R1.Rate,1)*coalesce(R2.Rate,1) end =0)                 
 And (    
 (datediff(month, Case When Reinsurance.PolicyRunOffF=1 then Acceptance.SDate else coalesce(RArrHeader.RDate,acceptance.sdate) end, Case When Reinsurance.PolicyRunOffF=1 then Acceptance.EDate else coalesce(RArrHeader.NRDate,Acceptance.EDate) end)>=ReClass.MinPeriod)     
 or (datediff(month, Case When Reinsurance.PolicyRunOffF=1 then Acceptance.SDate else coalesce(RArrHeader.RDate,acceptance.sdate) end, Case When Reinsurance.PolicyRunOffF=1 then Acceptance.EDate else coalesce(RArrHeader.NRDate,Acceptance.EDate) end)=ReClass.MinPeriod-1 and day(Case When Reinsurance.PolicyRunOffF=1 then Acceptance.SDate else coalesce(RArrHeader.RDate,acceptance.sdate) end)<day(Case When Reinsurance.PolicyRunOffF=1 then Acceptance.EDate else coalesce(RArrHeader.NRDate,Acceptance.EDate) end))     
 or ReClass.MinPeriod=0)                               
 And (    
 (datediff(month, Case When Reinsurance.PolicyRunOffF=1 then Acceptance.SDate else coalesce(RArrHeader.RDate,acceptance.sdate) end, Case When Reinsurance.PolicyRunOffF=1 then Acceptance.EDate else coalesce(RArrHeader.NRDate,Acceptance.EDate) end)<ReClass.MaxPeriod)     
 or (datediff(month, Case When Reinsurance.PolicyRunOffF=1 then Acceptance.SDate else coalesce(RArrHeader.RDate,acceptance.sdate) end, Case When Reinsurance.PolicyRunOffF=1 then Acceptance.EDate else coalesce(RArrHeader.NRDate,Acceptance.EDate) end)=ReClass.MaxPeriod and day(Case When Reinsurance.PolicyRunOffF=1 then Acceptance.SDate else coalesce(RArrHeader.RDate,acceptance.sdate) end)>=day(Case When Reinsurance.PolicyRunOffF=1 then Acceptance.EDate else coalesce(RArrHeader.NRDate,Acceptance.EDate) end))
 or ReClass.MaxPeriod=0))      
 And (
 Reinsurance.ApplySegmentF=0
 or (exists (Select Segment from ReSegment Where ReSegment.RNO=Reinsurance.RNO and ReSegment.Segment=Cover.Segment))
 )
)                    
And Exists (Select Top 1 RCalc.ANO from RCalc Left Join RPartDet on (RPartDet.RNO=Reinsurance.RNO and RPartDet.TOR=RCalc.TOR) Where RCalc.ANO=Acceptance.ANO and coalesce(RPartDet.ExcludeF,0)=0)  
Order By coalesce(RePolicy.ID,'') Desc, (Case When ReClass.PriorityF=1 Then ReClass.PriorityF else Reinsurance.PriorityF end) Desc                   
  


GO

ALTER Procedure qPolicy_Data(@P_ANO integer)                                    
as                                    
SELECT                                    
C.CNO, C.COVERNO, A1.TOC, C.MO, C.SEGMENT, A1.Location, C.VALIDATION, C.REFNO as CREFNO, C.PRORATA, C.PHOLDER, C.PPERIOD, C.CStatus,                                    
A1.ASource, P.ID as PayorID, C.ISType, C.OpenFlag, C.Voyage, C.PolicyType, C.VSeqNo, C.TBAF,          
A1.ANO, A1.OANO, A1.LANO, A1.CANO, A1.PANO, A1.RANO, A1.REGNO, A1.REGDATE, A1.BRANCH, A1.CT, A1.AStatus, A1.ATYPE, A1.POLICYNO, A1.POLICYDATE, A1.CPOLICYNO, A1.REFNO, A1.REFDATE, A1.RENEWABLEF, A1.CONJUNCTIONF, A1.EXCLUSIVEF, 
A1.SDATE, A1.EDATE, A1.STIME, A1.ETIME,         
          
A1.REMARKS, A1.EXTPERIOD, A1.ExtPeriodInDaysF, A1.ADATE, A1.PDATE, A1.PPDATE, A1.AID, A1.ANAME, A1.BUSINESS, A1.TOPRO, A1.Ujroh, A1.WeightedAvgUjrohF,                           
A1.ESeqNo, A1.EESeqNo, A1.Renewal, A1.BatchNo, A1.BankersClause,               
C.PUserID, C.PUserDate, C.PUserTime,                           
C.AUSERID as CAUserID, C.AUserDate as CAUserDate, C.AUserTime as CAUserTime,                        
C.CUSERID as CCUserID, C.CLOSEDATE as CCLOSEDATE, C.CloseTime as CCloseTime,    
A1.UserID, A1.CDate, A1.CTime,                                   
A1.CUserID, A1.CloseDate, A1.CloseTime,                             
A1.LUSERID, A1.LDate, A1.LTime,     
A1.AUSERID, A1.AUserDate, A1.AUserTime,                
CACCEPTANCE.REGNO as CREGNO,              
CCOVER.COVERNO AS CCOVERNO, A1.PWordingID,       
A1.CPCT, A1.SYSUSERID,             
Interest.Currency, Interest.TSI, Interest.ATSI,                              
A2.FLDID1, A2.VALUEID1, A2.VALUEDESC1, 0 as FLDSEARCH1,                                    
A2.FLDID2, A2.VALUEID2, A2.VALUEDESC2, 0 as FLDSEARCH2,                                    
A2.FLDID3, A2.VALUEID3, A2.VALUEDESC3, 0 as FLDSEARCH3,                                    
A2.FLDID4, A2.VALUEID4, A2.VALUEDESC4, 0 as FLDSEARCH4,                                    
A2.FLDID5, A2.VALUEID5, A2.VALUEDESC5, 0 as FLDSEARCH5,                                    
A2.FLDID6, A2.VALUEID6, A2.VALUEDESC6, 0 as FLDSEARCH6,                                    
A2.FLDID7, A2.VALUEID7, A2.VALUEDESC7, 0 as FLDSEARCH7,                                    
A2.FLDID8, A2.VALUEID8, A2.VALUEDESC8, 0 as FLDSEARCH8,                                    
A2.FLDID9, A2.VALUEID9, A2.VALUEDESC9, 0 as FLDSEARCH9,                                    
A2.FLDID10, A2.VALUEID10, A2.VALUEDESC10, 0 as FLDSEARCH10,                                    
A2.FLDID11, A2.VALUEID11, A2.VALUEDESC11, 0 as FLDSEARCH11,                                    
A2.FLDID12, A2.VALUEID12, A2.VALUEDESC12, 0 as FLDSEARCH12,                                    
A2.FLDID13, A2.VALUEID13, A2.VALUEDESC13, 0 as FLDSEARCH13,                                    
A2.FLDID14, A2.VALUEID14, A2.VALUEDESC14, 0 as FLDSEARCH14,                                    
A2.FLDID15, A2.VALUEID15, A2.VALUEDESC15, 0 as FLDSEARCH15                                    
FROM COVER C                        
INNER JOIN ACCEPTANCE A1 ON (C.CNO=A1.CNO)                         
INNER JOIN PAYOR P on (P.ANO=A1.ANO)
LEFT JOIN ACCEPTANCE CACCEPTANCE ON (CACCEPTANCE.ANO=A1.CANO)                        
LEFT JOIN COVER CCOVER ON (CCOVER.CNO=CACCEPTANCE.CNO)                        
Left Join AINFO A2 On (A2.ANO=A1.ANO)                         
Left Join FN_SumInsured(@P_ANO) Interest On (Interest.ANO=A1.ANO and Interest.TSI<>0)                              
WHERE A1.ANO=@P_ANO 

GO
--VERSIONING
insert into versioning
select '2017 V.2.28.0',GETDATE(),'2017 V.2.0.0',GETDATE(),'K: 2017 V.2.0.0',GETDATE()
go
