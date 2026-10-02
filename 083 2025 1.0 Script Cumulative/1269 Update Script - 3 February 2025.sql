IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'AUserTime' AND Object_ID = Object_ID(N'mVoucher'))
BEGIN

SET QUOTED_IDENTIFIER ON
SET ARITHABORT ON
SET NUMERIC_ROUNDABORT OFF
SET CONCAT_NULL_YIELDS_NULL ON
SET ANSI_NULLS ON
SET ANSI_PADDING ON
SET ANSI_WARNINGS ON

ALTER TABLE dbo.mVoucher ADD
	AUserTime varchar(10) NULL
end
GO

IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'VUserTime' AND Object_ID = Object_ID(N'mVoucher'))
BEGIN

SET QUOTED_IDENTIFIER ON
SET ARITHABORT ON
SET NUMERIC_ROUNDABORT OFF
SET CONCAT_NULL_YIELDS_NULL ON
SET ANSI_NULLS ON
SET ANSI_PADDING ON
SET ANSI_WARNINGS ON

ALTER TABLE dbo.mVoucher ADD
	VUserTime varchar(10) NULL
end
go

IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'AUserID_Ext' AND Object_ID = Object_ID(N'mVoucher'))
BEGIN

SET QUOTED_IDENTIFIER ON
SET ARITHABORT ON
SET NUMERIC_ROUNDABORT OFF
SET CONCAT_NULL_YIELDS_NULL ON
SET ANSI_NULLS ON
SET ANSI_PADDING ON
SET ANSI_WARNINGS ON

ALTER TABLE dbo.mVoucher ADD
	AUserID_Ext varchar(50) NULL
DECLARE @v sql_variant 
SET @v = N'Approving User ID (Extended/Second Approval)'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'mVoucher', N'COLUMN', N'AUserID_Ext'
end
GO

IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'AUserDate_Ext' AND Object_ID = Object_ID(N'mVoucher'))
BEGIN

SET QUOTED_IDENTIFIER ON
SET ARITHABORT ON
SET NUMERIC_ROUNDABORT OFF
SET CONCAT_NULL_YIELDS_NULL ON
SET ANSI_NULLS ON
SET ANSI_PADDING ON
SET ANSI_WARNINGS ON

ALTER TABLE dbo.mVoucher ADD	
	AUserDate_Ext smalldatetime NULL
DECLARE @v sql_variant 
SET @v = N'Approving User Date (Extended/Second Approval)'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'mVoucher', N'COLUMN', N'AUserDate_Ext'
end
GO

IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'AUserTime_Ext' AND Object_ID = Object_ID(N'mVoucher'))
BEGIN

SET QUOTED_IDENTIFIER ON
SET ARITHABORT ON
SET NUMERIC_ROUNDABORT OFF
SET CONCAT_NULL_YIELDS_NULL ON
SET ANSI_NULLS ON
SET ANSI_PADDING ON
SET ANSI_WARNINGS ON

ALTER TABLE dbo.mVoucher ADD
	AUserTime_Ext varchar(10) NULL
end
GO

IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'UVUserID' AND Object_ID = Object_ID(N'mVoucher'))
BEGIN

SET QUOTED_IDENTIFIER ON
SET ARITHABORT ON
SET NUMERIC_ROUNDABORT OFF
SET CONCAT_NULL_YIELDS_NULL ON
SET ANSI_NULLS ON
SET ANSI_PADDING ON
SET ANSI_WARNINGS ON

ALTER TABLE dbo.mVoucher ADD
	UVUserID varchar(50) NULL
DECLARE @v sql_variant 
SET @v = N'Undo Verifying User ID '
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'mVoucher', N'COLUMN', N'UVUserID'
end
GO

IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'UVUserDate' AND Object_ID = Object_ID(N'mVoucher'))
BEGIN

SET QUOTED_IDENTIFIER ON
SET ARITHABORT ON
SET NUMERIC_ROUNDABORT OFF
SET CONCAT_NULL_YIELDS_NULL ON
SET ANSI_NULLS ON
SET ANSI_PADDING ON
SET ANSI_WARNINGS ON

ALTER TABLE dbo.mVoucher ADD
	UVUserDate smalldatetime NULL
DECLARE @v sql_variant 
SET @v = N'Undo Verifying  User Date'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'mVoucher', N'COLUMN', N'UVUserDate'
end
GO

IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'UAUserID' AND Object_ID = Object_ID(N'mVoucher'))
BEGIN

SET QUOTED_IDENTIFIER ON
SET ARITHABORT ON
SET NUMERIC_ROUNDABORT OFF
SET CONCAT_NULL_YIELDS_NULL ON
SET ANSI_NULLS ON
SET ANSI_PADDING ON
SET ANSI_WARNINGS ON

ALTER TABLE dbo.mVoucher ADD
	UAUserID varchar(50) NULL
DECLARE @v sql_variant 
SET @v = N'Undo Approving User ID '
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'mVoucher', N'COLUMN', N'UAUserID'
end
GO

IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'UAUserDate' AND Object_ID = Object_ID(N'mVoucher'))
BEGIN

SET QUOTED_IDENTIFIER ON
SET ARITHABORT ON
SET NUMERIC_ROUNDABORT OFF
SET CONCAT_NULL_YIELDS_NULL ON
SET ANSI_NULLS ON
SET ANSI_PADDING ON
SET ANSI_WARNINGS ON

ALTER TABLE dbo.mVoucher ADD
	UAUserDate smalldatetime NULL
DECLARE @v sql_variant 
SET @v = N'Undo Approving User Date '
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'mVoucher', N'COLUMN', N'UAUserDate'
end
GO

IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'UAUserID_Ext' AND Object_ID = Object_ID(N'mVoucher'))
BEGIN

SET QUOTED_IDENTIFIER ON
SET ARITHABORT ON
SET NUMERIC_ROUNDABORT OFF
SET CONCAT_NULL_YIELDS_NULL ON
SET ANSI_NULLS ON
SET ANSI_PADDING ON
SET ANSI_WARNINGS ON

ALTER TABLE dbo.mVoucher ADD
	UAUserID_Ext varchar(50) NULL
DECLARE @v sql_variant 
SET @v = N'Undo Approving User ID (Extended/Second Approval)'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'mVoucher', N'COLUMN', N'UAUserID_Ext'
end
GO

IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'UAUserDate_Ext' AND Object_ID = Object_ID(N'mVoucher'))
BEGIN

SET QUOTED_IDENTIFIER ON
SET ARITHABORT ON
SET NUMERIC_ROUNDABORT OFF
SET CONCAT_NULL_YIELDS_NULL ON
SET ANSI_NULLS ON
SET ANSI_PADDING ON
SET ANSI_WARNINGS ON

ALTER TABLE dbo.mVoucher ADD
	UAUserDate_Ext smalldatetime NULL
DECLARE @v sql_variant 
SET @v = N'Undo Approving User Date (Extended/Second  Approval)'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'mVoucher', N'COLUMN', N'UAUserDate_Ext'
end
GO






IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'UVUserID' AND Object_ID = Object_ID(N'pVoucher'))
BEGIN

SET QUOTED_IDENTIFIER ON
SET ARITHABORT ON
SET NUMERIC_ROUNDABORT OFF
SET CONCAT_NULL_YIELDS_NULL ON
SET ANSI_NULLS ON
SET ANSI_PADDING ON
SET ANSI_WARNINGS ON


ALTER TABLE dbo.pVoucher ADD
	UVUserID varchar(50) NULL
DECLARE @v sql_variant 
SET @v = N'Undo Verifying User ID '
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'pVoucher', N'COLUMN', N'UVUserID'
end
GO

IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'UVUserDate' AND Object_ID = Object_ID(N'pVoucher'))
BEGIN

SET QUOTED_IDENTIFIER ON
SET ARITHABORT ON
SET NUMERIC_ROUNDABORT OFF
SET CONCAT_NULL_YIELDS_NULL ON
SET ANSI_NULLS ON
SET ANSI_PADDING ON
SET ANSI_WARNINGS ON


ALTER TABLE dbo.pVoucher ADD
	UVUserDate smalldatetime NULL
	DECLARE @v sql_variant 
SET @v = N'Undo Verifying  User Date'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'pVoucher', N'COLUMN', N'UVUserDate'
end
GO

IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'UAUserID' AND Object_ID = Object_ID(N'pVoucher'))
BEGIN

SET QUOTED_IDENTIFIER ON
SET ARITHABORT ON
SET NUMERIC_ROUNDABORT OFF
SET CONCAT_NULL_YIELDS_NULL ON
SET ANSI_NULLS ON
SET ANSI_PADDING ON
SET ANSI_WARNINGS ON


ALTER TABLE dbo.pVoucher ADD
	UAUserID varchar(50) NULL
	DECLARE @v sql_variant 
SET @v = N'Undo Approving User ID '
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'pVoucher', N'COLUMN', N'UAUserID'
end
GO



IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'UAUserDate' AND Object_ID = Object_ID(N'pVoucher'))
BEGIN

SET QUOTED_IDENTIFIER ON
SET ARITHABORT ON
SET NUMERIC_ROUNDABORT OFF
SET CONCAT_NULL_YIELDS_NULL ON
SET ANSI_NULLS ON
SET ANSI_PADDING ON
SET ANSI_WARNINGS ON


ALTER TABLE dbo.pVoucher ADD
	UAUserDate smalldatetime NULL
DECLARE @v sql_variant 
SET @v = N'Undo Approving User Date '
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'pVoucher', N'COLUMN', N'UAUserDate'
end
GO

IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'UAUserID_Ext' AND Object_ID = Object_ID(N'pVoucher'))
BEGIN

SET QUOTED_IDENTIFIER ON
SET ARITHABORT ON
SET NUMERIC_ROUNDABORT OFF
SET CONCAT_NULL_YIELDS_NULL ON
SET ANSI_NULLS ON
SET ANSI_PADDING ON
SET ANSI_WARNINGS ON


ALTER TABLE dbo.pVoucher ADD
	UAUserID_Ext varchar(50) NULL
DECLARE @v sql_variant 
SET @v = N'Undo Approving User ID (Extended/Second Approval)'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'pVoucher', N'COLUMN', N'UAUserID_Ext'
end
GO

IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'UAUserDate_Ext' AND Object_ID = Object_ID(N'pVoucher'))
BEGIN

SET QUOTED_IDENTIFIER ON
SET ARITHABORT ON
SET NUMERIC_ROUNDABORT OFF
SET CONCAT_NULL_YIELDS_NULL ON
SET ANSI_NULLS ON
SET ANSI_PADDING ON
SET ANSI_WARNINGS ON


ALTER TABLE dbo.pVoucher ADD
	UAUserDate_Ext smalldatetime NULL
end

GO


if exists (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'Voucher') )
begin
DROP View Voucher  
end
GO
CREATE View Voucher     
as      
Select V.Voucher, V.Date, V.VType, V.Remarks, V.Currency, V.Nominal_CC, V.Rate, V.Rate_RC, V.Nominal, V.Branch, V.Num_Doc, V.SL_Cat, V.ProAcc, V.ComAcc, V.RefNo, V.RefDate, V.RefType, V.DueDate, V.DebtorF, V.ChequeF, V.CreditorF, V.Diff_CC, V.Diff, V.Vat_CC,      
V.Tax_CC, V.VatF, V.TaxF, V.PaymentF, V.ReceiptF, V.TaxType, V.BranchF, V.CT, V.NDueDate, V.MDueDate, V.DocNo, V.BackDatedF, V.AccountNo, V.BankAccount, V.BankName, V.Last_Date, V.Last_Time, V.Last_Opr, V.PDate, V.Payment_CC, V.Payment_OC, V.NPayment, V.TaxPayment_CC,      
V.TaxPayment_OC, V.Status, V.PrintDate, V.PrintUser, V.Source, V.SourceF, V.Posting_Flag, V.Investment, V.InvestmentF, V.Asset, V.AssetF,  
V.REQUESTF , V.RequestMessage, V.RequestName, V.UserID
from dbo.nVoucher V      
Union All      
Select V.Voucher, V.Date, V.VType, V.Remarks, V.Currency, V.Nominal_CC, V.Rate, V.Rate_RC, V.Nominal, V.Branch, V.Num_Doc, V.SL_Cat, V.ProAcc, V.ComAcc, V.RefNo, V.RefDate, V.RefType, V.DueDate, V.DebtorF, V.ChequeF, V.CreditorF, V.Diff_CC, V.Diff, V.Vat_CC,      
V.Tax_CC, V.VatF, V.TaxF, V.PaymentF, V.ReceiptF, V.TaxType, V.BranchF, V.CT, V.NDueDate, V.MDueDate, V.DocNo, V.BackDatedF, V.AccountNo, V.BankAccount, V.BankName, V.Last_Date, V.Last_Time, V.Last_Opr, V.PDate, V.Payment_CC, V.Payment_OC, V.NPayment, V.TaxPayment_CC,           
V.TaxPayment_OC, V.Status, V.PrintDate, V.PrintUser, V.Source, V.SourceF, V.Posting_Flag, V.Investment, V.InvestmentF, V.Asset, V.AssetF,  
V.REQUESTF , V.RequestMessage, V.RequestName, V.UserID  
from dbo.pVoucher V      
Union All      
Select V.Voucher, V.Date, V.VType, V.Remarks, V.Currency, V.Nominal_CC, V.Rate, V.Rate_RC, V.Nominal, V.Branch, V.Num_Doc, V.SL_Cat, V.ProAcc, V.ComAcc, V.RefNo, V.RefDate, V.RefType, V.DueDate, V.DebtorF, V.ChequeF, V.CreditorF, V.Diff_CC, V.Diff, V.Vat_CC,      
V.Tax_CC, V.VatF, V.TaxF, V.PaymentF, V.ReceiptF, V.TaxType, V.BranchF, V.CT, V.NDueDate, V.MDueDate, V.DocNo, V.BackDatedF, V.AccountNo, V.BankAccount, V.BankName, V.Last_Date, V.Last_Time, V.Last_Opr, V.PDate, V.Payment_CC, V.Payment_OC, V.NPayment, V.TaxPayment_CC,           
V.TaxPayment_OC, V.Status, V.PrintDate, V.PrintUser, V.Source, V.SourceF, V.Posting_Flag, V.Investment, V.InvestmentF,  V.Asset, V.AssetF,  
V.REQUESTF , V.RequestMessage, V.RequestName, V.UserID  
from dbo.mVoucher V   
  

GO
if exists (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'fn_GetVoucherActionUser') AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) )
BEGIN 
DROP Function fn_GetVoucherActionUser
end
GO
CREATE Function fn_GetVoucherActionUser(@ActionCode varchar(10), @Voucher varchar(20))   
RETURNS @ActionUser TABLE (ID varchar(50), Name varchar(255), Type varchar(20), ApprovalLimit Float, LastRequestDate Smalldatetime)  
AS   
BEGIN   
 Declare @T table(ID varchar(50), Name varchar(255), Type varchar(20), TypeDesc varchar(255), ApprovalLimit Float)
 Declare @Type varchar(20)


 Declare @Branch varchar(10)
 Declare @InOut varchar(10)
 Declare @Privileges varchar(50)
 Declare @VType varchar(10)
 Declare @CT varchar(10)
 Declare @Amount Float 
 Declare @Condition Int

 Select 
 @Branch=R.Branch,
 @CT=R.CT,
 @InOut = Case When R.DebtorF=1 Then 'In' Else 'Out' end,
 @Privileges = 
	Case 
	When R.SL_Cat='M' Then 'ALLOWMANUALJOURNAL'
	When R.SL_Cat='P' and R.DebtorF=1 and VType.Code='MATCHING' then 'ALLOWMATCHING'
	When R.SL_Cat='P' and R.DebtorF=1 then 'ALLOWRECEIPT'
	Else 'ALLOWPAYMENT'
	End,
 @VType = R.VType,
 @Amount=R.Nominal-R.Diff
 from Voucher R
 Inner Join VType on (VType.VType=R.VType)
 Where R.Voucher=@Voucher

 Select @Condition=coalesce(nA.Condition,0)
 from ActionList AL
 Outer Apply (
	Select Top 1 S.ActionCode from SysRequest S Where S.Param2='FA' and S.Param6=@Voucher order by S.ID Desc
 ) S
 Left Join ActionFlow A on (A.ActionCodeSrc=S.ActionCode and A.ActionCodeDest=AL.ActionCode)
 Left Join ActionFlow nA on (nA.ActionCodeSrc=AL.ActionCode and coalesce(nA.Condition,0)>coalesce(A.Condition,0))
 Where AL.ActionCode=@ActionCode 

 insert into @T
 Select S.ID, S.Name, S.Type, S.TypeDesc, S.ApprovalLimit 
 from
 (
	 Select S.ID, S.Name, S.Type, S.TypeDesc, 
	 dbo.GetApprovalLimitFA(S.ID, @VType, @InOut) as ApprovalLimit
	 from
	 (
		Select Distinct S.*
		From
		( 
			Select S2.ID, S2.Name, S5.Type, S5.Description as TypeDesc
			from SysUser S2 
			Inner Join SysUserBranch S4 on (S4.ID=S2.ID and S4.AllowedF=1 and S4.Branch=@Branch)
			Inner Join SysUserType S5 on (S5.Type=S2.Type)
			Inner Join ActionUser S1 on (S1.ActionCode=@ActionCode and S1.ActionUser=S2.ID)
			Where S2.AllowedF=1 and cast(convert(varchar(10), getdate(),1) as smalldatetime)<=S2.Expiry and S2.LockedF=0
			and coalesce(S1.ActionCode,'')=@ActionCode
			and (@CT='' or exists(Select CT from fn_UserCT(S2.ID,@Branch,'') CT Where CT.CT=@CT))
            and (exists(Select VType from Fn_UserVType(S2.ID) VType Where VType.VType=@VType))

			Union All

			Select S2.ID, S2.Name, S5.Type, S5.Description as TypeDesc
			from SysUser S2 
			Inner Join SysUserBranch S4 on (S4.ID=S2.ID and S4.AllowedF=1 and S4.Branch=@Branch)
			Inner Join SysUserType S5 on (S5.Type=S2.Type)
			Inner Join ActionUser S1 on (S1.ActionCode=@ActionCode and S1.ActionUser=S2.Type)
			Where S2.AllowedF=1 and cast(convert(varchar(10), getdate(),1) as smalldatetime)<=S2.Expiry and S2.LockedF=0
			and coalesce(S1.ActionCode,'')=@ActionCode
			and (@CT='' or exists(Select CT from fn_UserCT(S2.ID,@Branch,'') CT Where CT.CT=@CT))
            and (exists(Select VType from Fn_UserVType(S2.ID) VType Where VType.VType=@VType))
		) S
	 ) S
 ) S
  --18 for Voucher Verification don't need Approval Checking and Privilege ALLOWPAYMENT/ALLOWRECEIPT
 Where (((S.ApprovalLimit>=@Amount or @Privileges Not in ('ALLOWRECEIPT','ALLOWPAYMENT')) and dbo.GetPrivileges(S.ID,@Privileges)=1) or coalesce(@Condition,0) in (18)) 
 Order by S.ApprovalLimit 

 --Select top 1 @ApprovalLimit=T.ApprovalLimit 
 --from @T T
 --Order by T.ApprovalLimit

 --insert into @ActionUser 
 --Select Top 1 T.Type as ID, T.TypeDesc as Name, 'T' as Type, T.ApprovalLimit, Null as LastRequestDate
 --from @T T
 --Where T.Type=@Type

insert into @ActionUser 
 Select T.ID as ID, T.Name as Name, 'U' as Type, T.ApprovalLimit, coalesce((Select top 1 convert(varchar(10),UserDate,102)+' '+UserTime from sysrequest Where Status='' and Param1='SEND' and Param2 in ('RQ') and Param5=T.ID order by UserDate Desc),NULL) as
 lastRequestDate
 from @T T
 --Where abs(T.ApprovalLimit-@ApprovalLimit)>=1
 Order by T.ApprovalLimit

Return   
End   

GO
if exists (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'fn_GetRequestActionUser') AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) )
BEGIN
DROP Function fn_GetRequestActionUser
end
GO
CREATE Function fn_GetRequestActionUser(@ActionCode varchar(10), @Request varchar(20))   
RETURNS @ActionUser TABLE (ID varchar(50), Name varchar(255), Type varchar(20), ApprovalLimit Float, LastRequestDate Smalldatetime)  
AS   
BEGIN   
 Declare @T table(ID varchar(50), Name varchar(255), Type varchar(20), TypeDesc varchar(255), ApprovalLimit Float)
 Declare @Type varchar(20)


 Declare @Branch varchar(10)
 Declare @InOut varchar(10)
 Declare @Privileges varchar(50)
 Declare @VType varchar(10)
 Declare @CT varchar(10)
 Declare @Amount Float 
 Declare @Condition Int

 Select 
 @Branch=R.Branch,
 @CT=R.CT,
 @InOut = Case When R.DebtorF=1 Then 'In' Else 'Out' end,
 @Privileges = Case When R.DebtorF=1 Then 'ALLOWRECEIPTREQUEST' Else 'ALLOWPAYMENTREQUEST' end,
 @VType = R.VType,
 @Amount=R.Nominal-R.Diff
 from Request R
 Where R.Request=@Request 


 Select @Condition=coalesce(nA.Condition,0)
 from ActionList AL
 Outer Apply (
	Select Top 1 S.ActionCode from SysRequest S Where S.Param2='RQ' and S.Param6=@Request order by S.ID Desc
 ) S
 Left Join ActionFlow A on (A.ActionCodeSrc=S.ActionCode and A.ActionCodeDest=AL.ActionCode)
 Left Join ActionFlow nA on (nA.ActionCodeSrc=AL.ActionCode and coalesce(nA.Condition,0)>coalesce(A.Condition,0))
 Where AL.ActionCode=@ActionCode 

 insert into @T
 Select S.ID, S.Name, S.Type, S.TypeDesc, S.ApprovalLimit 
 from
 (
	 Select S.ID, S.Name, S.Type, S.TypeDesc, 
	 dbo.GetApprovalLimitFA(S.ID, @VType, @InOut) as ApprovalLimit
	 from
	 (
		Select Distinct S.*
		From
		( 
			Select S2.ID, S2.Name, S5.Type, S5.Description as TypeDesc
			from SysUser S2 
			Inner Join SysUserBranch S4 on (S4.ID=S2.ID and S4.RequestF=1 and S4.Branch=@Branch)
			Inner Join SysUserType S5 on (S5.Type=S2.Type)
			Inner Join ActionUser S1 on (S1.ActionCode=@ActionCode and S1.ActionUser=S2.ID)
			Where S2.AllowedF=1 and cast(convert(varchar(10), getdate(),1) as smalldatetime)<=S2.Expiry and S2.LockedF=0
			and coalesce(S1.ActionCode,'')=@ActionCode
			and (@CT='' or exists(Select CT from fn_UserCT(S2.ID,@Branch,'') CT Where CT.CT=@CT))
            and (exists(Select VType from Fn_UserVType(S2.ID) VType Where VType.VType=@VType))

			Union All

			Select S2.ID, S2.Name, S5.Type, S5.Description as TypeDesc
			from SysUser S2 
			Inner Join SysUserBranch S4 on (S4.ID=S2.ID and S4.RequestF=1 and S4.Branch=@Branch)
			Inner Join SysUserType S5 on (S5.Type=S2.Type)
			Inner Join ActionUser S1 on (S1.ActionCode=@ActionCode and S1.ActionUser=S2.Type)
			Where S2.AllowedF=1 and cast(convert(varchar(10), getdate(),1) as smalldatetime)<=S2.Expiry and S2.LockedF=0
			and coalesce(S1.ActionCode,'')=@ActionCode
			and (@CT='' or exists(Select CT from fn_UserCT(S2.ID,@Branch,'') CT Where CT.CT=@CT))
            and (exists(Select VType from Fn_UserVType(S2.ID) VType Where VType.VType=@VType))
		) S
	 ) S
 ) S
 --12, 13, 14 for Request Verification don't need Approval Checking and Privilege ALLOWPAYMENTREQUEST/ALLOWRECEIPTREQUEST
 Where ((S.ApprovalLimit>=@Amount and dbo.GetPrivileges(S.ID,@Privileges)=1) or coalesce(@Condition,0) in (12,13,14)) 
 Order by S.ApprovalLimit 

 --Select top 1 @ApprovalLimit=T.ApprovalLimit 
 --from @T T
 --Order by T.ApprovalLimit

 --insert into @ActionUser 
 --Select Top 1 T.Type as ID, T.TypeDesc as Name, 'T' as Type, T.ApprovalLimit, Null as LastRequestDate
 --from @T T
 --Where T.Type=@Type

insert into @ActionUser 
 Select T.ID as ID, T.Name as Name, 'U' as Type, T.ApprovalLimit, coalesce((Select top 1 convert(varchar(10),UserDate,102)+' '+UserTime from sysrequest Where Status='' and Param1='SEND' and Param2 in ('RQ') and Param5=T.ID order by UserDate Desc),NULL) as
 lastRequestDate
 from @T T
 --Where abs(T.ApprovalLimit-@ApprovalLimit)>=1
 Order by T.ApprovalLimit

Return   
End   


  
GO
if exists (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'fn_GetRequestCreateVoucherActionUser') AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) )
BEGIN
DROP Function fn_GetRequestCreateVoucherActionUser
end
GO
CREATE Function fn_GetRequestCreateVoucherActionUser(@ActionCode varchar(10), @Request varchar(20))   
RETURNS @ActionUser TABLE (ID varchar(50), Name varchar(255), Type varchar(20), ApprovalLimit Float, LastRequestDate Smalldatetime)  
AS   
BEGIN   
 Declare @T table(ID varchar(50), Name varchar(255), Type varchar(20), TypeDesc varchar(255), ApprovalLimit Float)
 Declare @Type varchar(20)


 Declare @Branch varchar(10)
 Declare @InOut varchar(10)
 Declare @VType varchar(10)
 Declare @CT varchar(10)
 Declare @Amount Float 

 Select 
 @Branch=R.Branch,
 @CT=R.CT,
 @InOut = Case When R.DebtorF=1 Then 'In' Else 'Out' end,
 @VType = R.VType,
 @Amount=R.Nominal-R.Diff
 from Request R
 Where R.Request=@Request 

 insert into @T
 Select S.ID, S.Name, S.Type, S.TypeDesc, S.ApprovalLimit 
 from
 (
	 Select S.ID, S.Name, S.Type, S.TypeDesc, 
	 dbo.GetApprovalLimitFA(S.ID, @VType, @InOut) as ApprovalLimit
	 from
	 (
		Select Distinct S.*
		From
		( 
			Select S2.ID, S2.Name, S5.Type, S5.Description as TypeDesc
			from SysUser S2 
			Inner Join SysUserBranch S4 on (S4.ID=S2.ID and S4.AllowedF=1 and S4.Branch=@Branch)
			Inner Join SysUserType S5 on (S5.Type=S2.Type)
			Inner Join ActionUser S1 on (S1.ActionCode=@ActionCode and S1.ActionUser=S2.ID)
			Where S2.AllowedF=1 and cast(convert(varchar(10), getdate(),1) as smalldatetime)<=S2.Expiry and S2.LockedF=0
			and coalesce(S1.ActionCode,'')=@ActionCode
			and (@CT='' or exists(Select CT from fn_UserCT(S2.ID,@Branch,'') CT Where CT.CT=@CT))
            and (exists(Select VType from Fn_UserVType(S2.ID) VType Where VType.VType=@VType))

			Union All

			Select S2.ID, S2.Name, S5.Type, S5.Description as TypeDesc
			from SysUser S2 
			Inner Join SysUserBranch S4 on (S4.ID=S2.ID and S4.AllowedF=1 and S4.Branch=@Branch)
			Inner Join SysUserType S5 on (S5.Type=S2.Type)
			Inner Join ActionUser S1 on (S1.ActionCode=@ActionCode and S1.ActionUser=S2.Type)
			Where S2.AllowedF=1 and cast(convert(varchar(10), getdate(),1) as smalldatetime)<=S2.Expiry and S2.LockedF=0
			and coalesce(S1.ActionCode,'')=@ActionCode
			and (@CT='' or exists(Select CT from fn_UserCT(S2.ID,@Branch,'') CT Where CT.CT=@CT))
            and (exists(Select VType from Fn_UserVType(S2.ID) VType Where VType.VType=@VType))
		) S
	 ) S
 ) S
 Order by S.ApprovalLimit 

 --Select top 1 @ApprovalLimit=T.ApprovalLimit 
 --from @T T
 --Order by T.ApprovalLimit

 --insert into @ActionUser 
 --Select Top 1 T.Type as ID, T.TypeDesc as Name, 'T' as Type, T.ApprovalLimit, Null as LastRequestDate
 --from @T T
 --Where T.Type=@Type

insert into @ActionUser 
 Select T.ID as ID, T.Name as Name, 'U' as Type, T.ApprovalLimit, coalesce((Select top 1 convert(varchar(10),UserDate,102)+' '+UserTime from sysrequest Where Status='' and Param1='SEND' and Param2 in ('RQ') and Param5=T.ID order by UserDate Desc),NULL) as

 lastRequestDate
 from @T T
 --Where abs(T.ApprovalLimit-@ApprovalLimit)>=1
 Order by T.ApprovalLimit

Return   
End 

GO

IF EXISTS(SELECT * FROM SYSFORM WHERE FNAME='ALLOWUNDOAPPROVEVOUCHER')
BEGIN
Delete from SysForm Where FName='ALLOWUNDOAPPROVEVOUCHER'
end
go

IF NOT EXISTS(SELECT * FROM SYSFORM WHERE FNAME in ('ALLOWUNDOAPPROVEPAYMENT','ALLOWUNDOAPPROVERECEIPT','ALLOWUNDOAPPROVEMATCHING','ALLOWUNDOAPPROVEJOURNAL','ALLOWUNDOVERIFYPAYMENT','ALLOWUNDOVERIFYRECEIPT','ALLOWUNDOVERIFYMATCHING','ALLOWUNDOVERIFYJOURNAL'))
BEGIN
insert into SysForm(FName, Description, FCode, RequestF)
Select 'ALLOWUNDOAPPROVEPAYMENT','ALLOW UNDO APPROVE PAYMENT VOUCHER','ACTIVITIES',0
Union all
Select 'ALLOWUNDOAPPROVERECEIPT','ALLOW UNDO APPROVE RECEIPT VOUCHER','ACTIVITIES',0
Union all
Select 'ALLOWUNDOAPPROVEMATCHING','ALLOW UNDO APPROVE MATCHING VOUCHER','ACTIVITIES',0
Union all
Select 'ALLOWUNDOAPPROVEJOURNAL','ALLOW UNDO APPROVE JOURNAL VOUCHER','ACTIVITIES',0
Union All
Select 'ALLOWUNDOVERIFYPAYMENT','ALLOW UNDO VERIFY PAYMENT VOUCHER','ACTIVITIES',0
Union all
Select 'ALLOWUNDOVERIFYRECEIPT','ALLOW UNDO VERIFY RECEIPT VOUCHER','ACTIVITIES',0
Union all
Select 'ALLOWUNDOVERIFYMATCHING','ALLOW UNDO VERIFY MATCHING VOUCHER','ACTIVITIES',0
Union all
Select 'ALLOWUNDOVERIFYJOURNAL','ALLOW UNDO VERIFY JOURNAL VOUCHER','ACTIVITIES',0
end
go


  insert into PatchVersioning
select '1269 Update Script - 3 February 2025',GETDATE()
go	
  
Declare @PrevScript varchar(100)
Declare @CurrScript varchar(100)

Select @PrevScript=''
Select @CurrSCript='1269 Update Script - 3 February 2025'


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
