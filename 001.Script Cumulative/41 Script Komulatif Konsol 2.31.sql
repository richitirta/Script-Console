--30 jan 2018
IF EXISTS ( SELECT * FROM   sysobjects WHERE  id = object_id(N'[dbo].[QFACOUT]') and OBJECTPROPERTY(id, N'IsProcedure') = 1 )
begin
DROP Procedure QFACOUT
end
GO
CREATE Procedure QFACOUT(@P_ANO integer)      
as      
SELECT RArrDet.FID, RArrDet.Status, RArrDet.AType, RArrDet.RType, RArrDet.SDate, RArrDet.EDate, RArrDet.Share, RArrDet.Amount, RArrDet.Limit, RArrDet.Excess, RArrDet.Prorata, Profile.Name,     
FPart.SlipNo, FPart.SlipRetF, FPart.ID, FPart.Share AS RShare, FPart.Comm, FPart.WPC,      
FPart.NetRate , FPart.Unit, RArrDet.PCALC, RArrDet.CPct, RArrDet.FullCoverF, RArrDet.OriginalF, RArrDet.PrecedeFacCessionF, FPart.Remarks,
FPart.Grace, FPart.Installment, RArrDet.AcceptedBy, RArrDet.AcceptedDate 
From RArrDet, FPart, Profile      
WHERE RArrDet.ANO=@P_ANO And FPart.ANO=RArrDet.ANO And FPart.FID=RArrDet.FID And Profile.ID=FPart.ID;      

go

IF NOT EXISTS(SELECT * FROM SysForm WHERE FName='CANCELONUNPAIDPREMIUM')
BEGIN
insert into Sysform(Fname, Description, FCode)
Select 'CANCELONUNPAIDPREMIUM','Allow Cancel On UnPaid Premium','ACTIVITIES'
END
go

IF NOT EXISTS(SELECT * FROM SysForm WHERE FName='ALLOWCHANGEHF')
BEGIN
insert into Sysform(Fname, Description, FCode)
Select 'ALLOWCHANGEHF', 'ALLOW CHANGE HANDING FEE','ACTIVITIES'
END
go

--2 FEB 2018
IF  NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'EMPLOYMENT') AND type in (N'U'))
begin
CREATE TABLE EMPLOYMENT(
	EMPLOYMENT varchar(20) NOT NULL,
 CONSTRAINT I_EMPLOYMENT PRIMARY KEY CLUSTERED 
(
	EMPLOYMENT ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
END
GO

INSERT INTO EMPLOYMENT
SELECT ' '
UNION ALL
SELECT 'PNS'
UNION ALL
SELECT 'TNI/POLRI'
UNION ALL
SELECT 'Wiraswasta'
UNION ALL
SELECT 'Karyawan Swasta'
UNION ALL
SELECT 'Ibu Rumah Tangga'
UNION ALL
SELECT 'Pelajar/Mahasiswa'
UNION ALL
SELECT 'Lainnya'
GO

--description HINT
Begin tran
Delete from HInt

Insert into Hint(Hint, Remarks, ShortDesc, ProAccf, Last_Opr, Last_Update, Remarks_1,ShortDesc_1) 
Select -20,'Ujroh Cedant','Ujroh Cedant','0','CARE','12/31/2017','--Un-Used--','--Un-Used--'
Insert into Hint(Hint, Remarks, ShortDesc, ProAccf, Last_Opr, Last_Update, Remarks_1,ShortDesc_1) 
Select -19,'Deposit/Reserve','Deposit/Reserve','0','CARE','12/31/2017','--Un-Used--','--Un-Used--'
Insert into Hint(Hint, Remarks, ShortDesc, ProAccf, Last_Opr, Last_Update, Remarks_1,ShortDesc_1) 
Select -18,'Others Tax #2','Others Tax #2','0','CARE','12/31/2017','--Un-Used--','--Un-Used--'
Insert into Hint(Hint, Remarks, ShortDesc, ProAccf, Last_Opr, Last_Update, Remarks_1,ShortDesc_1) 
Select -17,'Others Tax #1','Others Tax #1','0','CARE','12/31/2017','Claim Adjustment','Claim Adjustment'
Insert into Hint(Hint, Remarks, ShortDesc, ProAccf, Last_Opr, Last_Update, Remarks_1,ShortDesc_1) 
Select -16,'Others Fee/Stamp Duty #2','Others Fee/Duty #2','0','CARE','12/31/2017','Claim Stamp Duty','Claim Stamp Duty'
Insert into Hint(Hint, Remarks, ShortDesc, ProAccf, Last_Opr, Last_Update, Remarks_1,ShortDesc_1) 
Select -15,'Others Fee/Stamp Duty #1','Others Fee/Duty #1','0','CARE','12/31/2017','Others Fee','Others Fee'
Insert into Hint(Hint, Remarks, ShortDesc, ProAccf, Last_Opr, Last_Update, Remarks_1,ShortDesc_1) 
Select -14,'Pajak Penghasilan','PPH (TAX)','0','CARE','12/31/2017','Pajak Penghasilan','PPH (TAX)'
Insert into Hint(Hint, Remarks, ShortDesc, ProAccf, Last_Opr, Last_Update, Remarks_1,ShortDesc_1) 
Select -13,'Pajak Pertambahan Nilai','PPN (VAT)','0','CARE','12/31/2017','Pajak Pertambahan Nilai','PPN (VAT)'
Insert into Hint(Hint, Remarks, ShortDesc, ProAccf, Last_Opr, Last_Update, Remarks_1,ShortDesc_1) 
Select -12,'--Un-Used--','--Un-Used--','0','CARE','12/31/2017','Other Income (Claim)','Other Income'
Insert into Hint(Hint, Remarks, ShortDesc, ProAccf, Last_Opr, Last_Update, Remarks_1,ShortDesc_1) 
Select -11,'Other Income (Premium)','Other Income','0','CARE','12/31/2017','--Un-Used--','--Un-Used--'
Insert into Hint(Hint, Remarks, ShortDesc, ProAccf, Last_Opr, Last_Update, Remarks_1,ShortDesc_1) 
Select -10,'Subrogation','Subrogation','0','CARE','12/31/2017','Subrogation Amount','Subrogation'
Insert into Hint(Hint, Remarks, ShortDesc, ProAccf, Last_Opr, Last_Update, Remarks_1,ShortDesc_1) 
Select -9,'Overriding Commission','Overriding Comm','0','CARE','12/31/2017','Claim Expenses','Claim Expenses'
Insert into Hint(Hint, Remarks, ShortDesc, ProAccf, Last_Opr, Last_Update, Remarks_1,ShortDesc_1) 
Select -8,'Profit Sharing','Profit Sharing','0','CARE','12/31/2017','Salvage','Salvage Amount'
Insert into Hint(Hint, Remarks, ShortDesc, ProAccf, Last_Opr, Last_Update, Remarks_1,ShortDesc_1) 
Select -7,'Premium Adjustment','Premium Adjustment','0','CARE','12/31/2017','Deductible Amount','Deductible'
Insert into Hint(Hint, Remarks, ShortDesc, ProAccf, Last_Opr, Last_Update, Remarks_1,ShortDesc_1) 
Select -6,'Claim Amount','Claim Amount','0','CARE','12/31/2017','Claim Amount','Claim Amount'
Insert into Hint(Hint, Remarks, ShortDesc, ProAccf, Last_Opr, Last_Update, Remarks_1,ShortDesc_1) 
Select -5,'Discount/Overriding','Disc. (Over.)','0','CARE','12/31/2017','--Un-Used--','--Un-Used--'
Insert into Hint(Hint, Remarks, ShortDesc, ProAccf, Last_Opr, Last_Update, Remarks_1,ShortDesc_1) 
Select -4,'Stamp Duty/Guarantee Fund','Stamp Duty/G.Fund','0','CARE','12/31/2017','--Un-Used--','--Un-Used--'
Insert into Hint(Hint, Remarks, ShortDesc, ProAccf, Last_Opr, Last_Update, Remarks_1,ShortDesc_1) 
Select -3,'Fee','Fee','0','CARE','12/31/2017','--Un-Used--','--Un-Used--'
Insert into Hint(Hint, Remarks, ShortDesc, ProAccf, Last_Opr, Last_Update, Remarks_1,ShortDesc_1) 
Select -2,'Commission','Commission','0','CARE','12/31/2017','--Un-Used--','--Un-Used--'
Insert into Hint(Hint, Remarks, ShortDesc, ProAccf, Last_Opr, Last_Update, Remarks_1,ShortDesc_1) 
Select -1,'Premium','Premium','0','CARE','12/31/2017','--Un-Used--','--Un-Used--'

commit tran

IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'AlreadyScreeningF' AND Object_ID = Object_ID(N'Claim'))
BEGIN
Alter Table Claim Add AlreadyScreeningF Bit
END
Go


IF NOT EXISTS(SELECT * FROM SysForm WHERE FName='ALLOWPASSSCREENING')
BEGIN
insert into sysform(FName, Description, FCode)
Select 'ALLOWPASSSCREENING', 'ALLOW PASS SCREENING', 'ACTIVITIES'
END
GO

IF NOT EXISTS(SELECT * FROM SysForm WHERE FName='ALLOWPASSHOLDCESSION')
BEGIN
insert into sysform(FName, Description, FCode)
Select 'ALLOWPASSHOLDCESSION', 'ALLOW PASS HOLD CESSION', 'ACTIVITIES'
END
go


IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'NeedEmailF' AND Object_ID = Object_ID(N'APDRuleD'))
BEGIN
ALTER TABLE APDRuleD ADD NeedEmailF bit NULL
END
GO

IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'NeedPrintF' AND Object_ID = Object_ID(N'APDRuleD'))
BEGIN
ALTER TABLE APDRuleD ADD NeedPrintF bit NULL
END
GO

IF NOT EXISTS (SELECT * FROM SYS.EXTENDED_PROPERTIES WHERE major_id = OBJECT_ID('APDRuleD') AND name = N'MS_Description' AND minor_id = (SELECT column_id FROM SYS.COLUMNS WHERE name = 'NeedEmailF' AND object_id = OBJECT_ID('APDRuleD')))
BEGIN
DECLARE @v sql_variant 
SET @v = N'Need Email Flag (0 : No, 1 : Yes)'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'APDRuleD', N'COLUMN', N'NeedEmailF'
END
GO

IF NOT EXISTS (SELECT * FROM SYS.EXTENDED_PROPERTIES WHERE major_id = OBJECT_ID('APDRuleD') AND name = N'MS_Description' AND minor_id = (SELECT column_id FROM SYS.COLUMNS WHERE name = 'NeedPrintF' AND object_id = OBJECT_ID('APDRuleD')))
BEGIN
DECLARE @v sql_variant 
SET @v = N'Need Printing Flag (0 : No, 1 : Yes)'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'APDRuleD', N'COLUMN', N'NeedPrintF'
END
GO


IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Get_Policy_APRule]') AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) ) 
begin
DROP FUNCTION Get_Policy_APRule 
end
GO
Create function Get_Policy_APRule(@P_ANO as int)      
RETURNS Table      
AS RETURN      
(      
Select AD.RuleID, AD.Class, AD.RepName, AD.ExeName, AH.AutoInforceF, TOC.ApplyeStampDutyF, AD.NeedEmailF,AD.NeedPrintF
from APDRuleH AH 
INNER JOIN APDRULED AD ON (AH.RULEID=AD.RULEID) INNER JOIN SYSCLASS S ON (S.CLASS=AD.CLASS)  
INNER JOIN TOC ON (TOC.TOC=AH.TOC)
Where AH.AllowedF=1 AND AH.APPTYPE='POLICY'  
and 1 in   
(  
Select 1 from Acceptance A, Cover C   
Where A.ANO=@P_ANO and C.CNO=A.CNO and C.PolicyType=AH.PolicyType and C.ISType=AH.ISType and (C.Segment=AH.Segment or AH.Segment='<All>') and A.TOC=AH.TOC and (A.TOPRO=AH.TOPRO or AH.TOPRO='<All>')  
and charindex(A.AType,S.AccAType)<>0  
and charindex(A.AStatus,S.AccAStatus)<>0  
and charindex(C.CStatus,S.CoverCStatus)<>0  
)  
)       

GO

--3 feb 2018
IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'LockedF' AND Object_ID = Object_ID(N'pSL'))
BEGIN
alter table pSL Add LockedF bit
END
GO

IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'LockedF' AND Object_ID = Object_ID(N'SL_Request'))
BEGIN
alter table SL_Request Add LockedF bit
END
GO

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[oSL]') AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) ) 
begin
DROP FUNCTION oSL 
end
GO

CREATE Function oSL(@P_Voucher varchar(20)) 
RETURNS Table 
as Return 
( 
Select pSL.Voucher, pSL.Doc_No, pSL.Doc_Date, pSL.Doc_CCY, pSL.Nominal_OC, pSL.CT, pSL.Nominal, pSL.Remarks, pSL.Hint, 
Case When OSL.PaymentF is null then pSL.PaymentF else OSL.PaymentF end as PaymentF, 
Case When OSL.Account is null then pSL.Account else OSL.Account end as Account, 
Case When OBranch.Branch is null then pVoucher.Branch else OBranch.Branch end as Branch, pSL.Nominator, pSL.Denominator, pSL.Rate, pSL.SortNo, pSL.pVoucher, pSL.LockedF
From dbo.pSL 
Inner Join dbo.pVoucher on (pVoucher.Voucher=pSL.Voucher) 
Left join dbo.Branch OBranch on (OBranch.IO_Account=pSL.Account) 
Left Join dbo.pVoucher OVoucher on (OBranch.Branch=OVoucher.Branch and OVoucher.RefNo=pSL.Voucher and OVoucher.SL_Cat='B' and OVoucher.RefType='INTEROFFICE') 
Left join dbo.pSL OSL on (OSL.Voucher=OVoucher.Voucher and OSL.Doc_No=pSL.Doc_No and OSL.Nominal=pSL.Nominal and (oSL.SortNo=0 or oSL.SortNo=pSL.SortNo)) 
Where (pVoucher.Voucher=@P_Voucher) 
) 
 
 
 

go



IF EXISTS(SELECT * FROM sys.default_constraints WHERE object_id = OBJECT_ID('DF_Admlink_PNominal_Vat') AND parent_object_id = OBJECT_ID('Admlink'))
BEGIN
ALTER TABLE Admlink DROP CONSTRAINT DF_Admlink_PNominal_Vat
END
GO

IF EXISTS(SELECT * FROM sys.default_constraints WHERE object_id = OBJECT_ID('DF_Admlink_PNominal_Vat') AND parent_object_id = OBJECT_ID('Admlink'))
BEGIN
ALTER TABLE Admlink ADD  CONSTRAINT DF_Admlink_PNominal_Vat  DEFAULT ((0)) FOR PNominal_Vat
END
GO

IF EXISTS(SELECT * FROM sys.default_constraints WHERE object_id = OBJECT_ID('DF_Admlink_PNominal_Tax') AND parent_object_id = OBJECT_ID('Admlink'))
BEGIN
ALTER TABLE Admlink DROP CONSTRAINT DF_Admlink_PNominal_Tax
END
GO

IF EXISTS(SELECT * FROM sys.default_constraints WHERE object_id = OBJECT_ID('DF_Admlink_PNominal_Tax') AND parent_object_id = OBJECT_ID('Admlink'))
BEGIN
ALTER TABLE Admlink ADD  CONSTRAINT DF_Admlink_PNominal_Tax  DEFAULT ((0)) FOR PNominal_Tax
END
GO


IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'LockedF' AND Object_ID = Object_ID(N'pSL'))
BEGIN
alter table pSL Add LockedF bit
END
GO

IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'LockedF' AND Object_ID = Object_ID(N'SL_Request'))
BEGIN
alter table SL_Request Add LockedF bit
END
GO


IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[oSL]') AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) ) 
begin
DROP FUNCTION oSL 
end
GO

CREATE Function oSL(@P_Voucher varchar(20)) 
RETURNS Table 
as Return 
( 
Select pSL.Voucher, pSL.Doc_No, pSL.Doc_Date, pSL.Doc_CCY, pSL.Nominal_OC, pSL.CT, pSL.Nominal, pSL.Remarks, pSL.Hint, 
Case When OSL.PaymentF is null then pSL.PaymentF else OSL.PaymentF end as PaymentF, 
Case When OSL.Account is null then pSL.Account else OSL.Account end as Account, 
Case When OBranch.Branch is null then pVoucher.Branch else OBranch.Branch end as Branch, pSL.Nominator, pSL.Denominator, pSL.Rate, pSL.SortNo, pSL.pVoucher, pSL.LockedF
From dbo.pSL 
Inner Join dbo.pVoucher on (pVoucher.Voucher=pSL.Voucher) 
Left join dbo.Branch OBranch on (OBranch.IO_Account=pSL.Account) 
Left Join dbo.pVoucher OVoucher on (OBranch.Branch=OVoucher.Branch and OVoucher.RefNo=pSL.Voucher and OVoucher.SL_Cat='B' and OVoucher.RefType='INTEROFFICE') 
Left join dbo.pSL OSL on (OSL.Voucher=OVoucher.Voucher and OSL.Doc_No=pSL.Doc_No and OSL.Nominal=pSL.Nominal and (oSL.SortNo=0 or oSL.SortNo=pSL.SortNo)) 
Where (pVoucher.Voucher=@P_Voucher) 
) 
go

IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'Charges' AND Object_ID = Object_ID(N'ARBucket'))
BEGIN
Alter Table ARBucket Add Charges Float
END
GO
IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'EAccount' AND Object_ID = Object_ID(N'ARBucket'))
BEGIN
Alter Table ARBucket Add EAccount Float
END
GO
--VERSIONING
insert into versioning
select '2017 V.2.31.0',GETDATE(),'2017 V.2.0.0',GETDATE(),'K: 2017 V.2.0.0',GETDATE()
go


Declare @PrevScript varchar(100)
Declare @CurrScript varchar(100)

Select @PrevScript='40 Script Komulatif Konsol 2.30'
Select @CurrSCript='41 Script Komulatif Konsol 2.31'


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