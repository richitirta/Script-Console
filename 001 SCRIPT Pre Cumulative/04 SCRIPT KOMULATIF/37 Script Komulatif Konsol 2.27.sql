IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'sAccount' AND Object_ID = Object_ID(N'ARBucket'))
BEGIN
ALTER TABLE dbo.ARBucket ADD	sAccount varchar(10) NULL
DECLARE @v sql_variant 
SET @v = N'Account COA for Payment Difference'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'ARBucket', N'COLUMN', N'sAccount'
end
GO

IF EXISTS ( SELECT * FROM   sysobjects WHERE  id = object_id(N'[dbo].AutoReceipt_Process') and OBJECTPROPERTY(id, N'IsProcedure') = 1 )
BEGIN
DROP Procedure AutoReceipt_Process
end
GO
CREATE Procedure AutoReceipt_Process(@P_PDate as smalldatetime)                                            
as                                      
Select ARBucket.PID, ARBucket.Last_Opr, ARBucket.ComAcc, ARBucket.Branch, ARBucket.RefType, ARBucket.RefDate, ARBucket.RefNo, ARBucket.AmountPaid, ARBucket.Rate, ARBucket.SAccount, Admlink.ID, nVoucher.Voucher, nVoucher.DebtorF, nVoucher.Remarks, nVoucher.Date, nVoucher.ProAcc, nVoucher.Branch, nVoucher.Currency, Case When nVoucher.DebtorF=1 Then (nVoucher.Nominal_CC-nVoucher.Diff_CC-nVoucher.Payment_CC) else -(nVoucher.Nominal_CC-nVoucher.Diff_CC-nVoucher.Payment_CC) end as Outstanding              
from ARBucket      
Left Join Admlink on (  
(  
 (Admlink.A_PolicyNo=ARBucket.A_PolicyNo and ARBucket.A_PolicyNo<>'') or    
 (Admlink.Voucher=ARBucket.Voucher and ARBucket.Voucher<>'') or   
 (Admlink.RefNo=ARBucket.RefNo and ARBucket.RefNo<>'') or   
 (Admlink.Bank=ARBucket.Bank and Admlink.AccountNo=ARBucket.AccountNo and ARBucket.AccountNo<>'') or  
 (Admlink.Bank_Ext=ARBucket.Bank and Admlink.AccountNo_Ext=ARBucket.AccountNo and ARBucket.AccountNo<>'')  
)  
and Admlink.Type in ('DI','IC','IR','IT','IX') and Admlink.Date<=ARBucket.RefDate and Admlink.Date<=@P_PDate   
)      
Left Join nVoucher on (nVoucher.Voucher=Admlink.Voucher)      
Where ARBucket.Status='R'              
and round(coalesce(nVoucher.Nominal_CC-nVoucher.Diff_CC-nVoucher.Payment_CC,0),2)>=0
and not Exists (Select CollectionV.Voucher from CollectionV, CollectionH where CollectionV.CollNo=CollectionH.CollNo and CollectionH.CollStatus<>'C' and CollectionV.Voucher=nVoucher.Voucher)              
and not Exists (Select SL.doc_no from SL_Request SL, Request R Where R.Status<>'C' and R.Voucher='' and R.Request=SL.Request and SL.doc_no=nVoucher.Voucher)               
order by ARBucket.PID, Admlink.AdmNo

go
update [Profile] set vat=0 where vat is null
go

IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_Profile_VAT]') AND type = 'D')
BEGIN   
ALTER TABLE [dbo].[Profile] DROP CONSTRAINT [DF_Profile_VAT]
end
GO
ALTER TABLE [dbo].[Profile] ADD  CONSTRAINT [DF_Profile_VAT]  DEFAULT ((0)) FOR [VAT]
GO

update [Profile] set tax=0 where tax is null
go
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_Profile_TAX]') AND type = 'D')
BEGIN  
ALTER TABLE [dbo].[Profile] DROP CONSTRAINT [DF_Profile_TAX]
end
GO

ALTER TABLE [dbo].[Profile] ADD  CONSTRAINT [DF_Profile_TAX]  DEFAULT ((0)) FOR [TAX]
GO


IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'Closing_12' AND Object_ID = Object_ID(N'GL'))
BEGIN
Alter Table GL Add Closing_12 Float
end
GO
IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'Closing_RC_12' AND Object_ID = Object_ID(N'GL'))
BEGIN
Alter Table GL Add  Closing_RC_12 Float
end
GO
IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'Closing_12' AND Object_ID = Object_ID(N'GL_FX'))
BEGIN
Alter Table GL_FX Add Closing_12 Float
end
GO
IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'Closing_BC_12' AND Object_ID = Object_ID(N'GL_FX'))
BEGIN
Alter Table GL_FX Add Closing_BC_12 Float
end
GO
IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'Closing_RC_12' AND Object_ID = Object_ID(N'GL_FX'))
BEGIN
Alter Table GL_FX Add Closing_RC_12 Float
end
GO
IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'Closing_12' AND Object_ID = Object_ID(N'SL_FX'))
BEGIN
Alter Table SL_FX Add Closing_12 Float
end
GO
IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'Closing_BC_12' AND Object_ID = Object_ID(N'SL_FX'))
BEGIN
Alter Table SL_FX Add  Closing_BC_12 Float
end
GO
IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'Closing_RC_12' AND Object_ID = Object_ID(N'SL_FX'))
BEGIN
Alter Table SL_FX Add   Closing_RC_12 Float
end
GO
IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'Closing_12' AND Object_ID = Object_ID(N'CA_FX'))
BEGIN
Alter Table CA_FX Add Closing_12 Float
end
GO
IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'Closing_BC_12' AND Object_ID = Object_ID(N'CA_FX'))
BEGIN
Alter Table CA_FX Add  Closing_BC_12 Float
end
GO
IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'Closing_RC_12' AND Object_ID = Object_ID(N'CA_FX'))
BEGIN
Alter Table CA_FX Add   Closing_RC_12 Float
end
GO

IF EXISTS ( SELECT * FROM   sysobjects WHERE  id = object_id(N'[dbo].Update_Closing_Balance_GL') and OBJECTPROPERTY(id, N'IsProcedure') = 1 )
BEGIN
DROP Procedure Update_Closing_Balance_GL 
end
GO
CREATE Procedure Update_Closing_Balance_GL (@P_Branch Varchar(10), @P_pMth as Smallint, @P_pYr as Smallint,@P_Mth as Smallint, @P_Yr as Smallint)
as  
Insert into GL(Branch,[Month],[Year],Account,Starting,Ending,Closing, Starting_RC, Ending_RC, Closing_RC, Revaluation, Revaluation_RC, Closing_12, Closing_RC_12)
Select Branch,@P_Mth, @P_Yr,Account,
Ending,Ending, Case When @P_Mth<>1 Then Closing+Ending-Starting Else 0 End,
Ending_RC, Ending_RC, Case When @P_Mth<>1 Then Closing_RC+Ending_RC-Starting_RC Else 0 End,0,0,
Case When @P_Mth<>12 Then Closing+Ending-Starting Else 0 End,
Case When @P_Mth<>12 Then Closing_RC+Ending_RC-Starting_RC Else 0 End
From GL Where GL.Branch=@P_Branch and GL.[Month]=@P_pMth and GL.[Year]=@P_pYr


GO

IF EXISTS ( SELECT * FROM   sysobjects WHERE  id = object_id(N'[dbo].Update_Closing_Balance_GL_FX') and OBJECTPROPERTY(id, N'IsProcedure') = 1 )
BEGIN
DROP Procedure Update_Closing_Balance_GL_FX 
end
GO
CREATE  Procedure Update_Closing_Balance_GL_FX (@P_Branch Varchar(10), @P_pMth as Smallint, @P_pYr as Smallint,@P_Mth as Smallint, @P_Yr as Smallint)
as
Insert into GL_FX(Branch,[Month],[Year],Account,Currency,Starting,Ending, Closing, Starting_BC, Ending_BC, Closing_BC, Starting_RC, Ending_RC, Closing_RC, Revaluation, Revaluation_RC, Closing_12, Closing_BC_12, Closing_RC_12)
Select Branch,@P_Mth, @P_Yr,Account,Currency,
Ending,Ending,Case When @P_Mth<>1 Then Closing+Ending-Starting Else 0 End,
Ending_BC,Ending_BC,Case When @P_Mth<>1 Then Closing_BC+Ending_BC-Starting_BC Else 0 end,
Ending_RC,Ending_RC,Case When @P_Mth<>1 Then Closing_RC+Ending_RC-Starting_RC Else 0 end,0,0,
Case When @P_Mth<>12 Then Closing+Ending-Starting Else 0 End,
Case When @P_Mth<>12 Then Closing_BC+Ending_BC-Starting_BC Else 0 end,
Case When @P_Mth<>12 Then Closing_RC+Ending_RC-Starting_RC Else 0 end
From GL_FX Where GL_FX.Branch=@P_Branch and GL_FX.[Month]=@P_pMth and GL_FX.[Year]=@P_pYr

GO

IF EXISTS ( SELECT * FROM   sysobjects WHERE  id = object_id(N'[dbo].Update_Closing_Balance_CA_FX') and OBJECTPROPERTY(id, N'IsProcedure') = 1 )
BEGIN
DROP Procedure Update_Closing_Balance_CA_FX 
end
GO
CREATE Procedure Update_Closing_Balance_CA_FX (@P_Branch Varchar(10), @P_pMth as Smallint, @P_pYr as Smallint,@P_Mth as Smallint, @P_Yr as Smallint)
as
Insert into CA_FX(Branch,[Month],[Year],Account,Currency,ComAcc,Starting,Ending, Closing, Starting_BC, Ending_BC, Closing_BC, Starting_RC, Ending_RC, Closing_RC, Revaluation, Revaluation_RC, Closing_12, Closing_BC_12, Closing_RC_12)
Select Branch,@P_Mth, @P_Yr,Account,Currency,ComAcc, 
Ending,Ending,Case When @P_Mth<>1 Then Closing+Ending-Starting Else 0 End,
Ending_BC,Ending_BC,Case When @P_Mth<>1 Then Closing_BC+Ending_BC-Starting_BC Else 0 end,
Ending_RC,Ending_RC,Case When @P_Mth<>1 Then Closing_RC+Ending_RC-Starting_RC Else 0 end,0,0,
Case When @P_Mth<>12 Then Closing+Ending-Starting Else 0 End,
Case When @P_Mth<>12 Then Closing_BC+Ending_BC-Starting_BC Else 0 end,
Case When @P_Mth<>12 Then Closing_RC+Ending_RC-Starting_RC Else 0 end
From CA_FX Where CA_FX.Branch=@P_Branch and CA_FX.[Month]=@P_pMth and CA_FX.[Year]=@P_pYr


GO

IF EXISTS ( SELECT * FROM   sysobjects WHERE  id = object_id(N'[dbo].GL_Consolidation') and OBJECTPROPERTY(id, N'IsProcedure') = 1 )
BEGIN
DROP Procedure GL_Consolidation 
end
GO
CREATE Procedure GL_Consolidation (@P_Branch Varchar(10), @P_Mth as Smallint, @P_Yr as Smallint)  
as  
Select @P_Branch, @P_Mth, @P_Yr, Account, 
sum(Starting) as Starting, sum(Ending) as Ending, sum(Debit) as Debit, sum(Credit) as Credit, sum(Revaluation) as Revaluation, sum(Closing) as Closing,  
sum(Starting_RC) as Starting_RC, sum(Ending_RC) as Ending_RC, sum(Debit_RC) as Debit_RC, sum(Credit_RC) as Credit_RC, sum(Revaluation_RC) as Revaluation_RC, sum(Closing_RC) as Closing_RC,  
sum(Closing_12) as Closing_12, sum(Closing_RC_12) as Closing_RC_12,
sum(Balance_1) as Balance_1, sum(Balance_2) as Balance_2, sum(Balance_3) as Balance_3, sum(Balance_4) as Balance_4, sum(Balance_5) as Balance_5, sum(Balance_6) as Balance_6, sum(Balance_7) as Balance_7, sum(Balance_8) as Balance_8, sum(Balance_9) as Balance_9, sum(Balance_10) as Balance_10,  
sum(Balance_11) as Balance_11, sum(Balance_12) as Balance_12, sum(Balance_13) as Balance_13, sum(Balance_14) as Balance_14, sum(Balance_15) as Balance_15, sum(Balance_16) as Balance_16, sum(Balance_17) as Balance_17, sum(Balance_18) as Balance_18, sum(Balance_19) as Balance_19, sum(Balance_20) as Balance_20,  
sum(Balance_21) as Balance_21, sum(Balance_22) as Balance_22, sum(Balance_23) as Balance_23, sum(Balance_24) as Balance_24, sum(Balance_25) as Balance_25, sum(Balance_26) as Balance_26, sum(Balance_27) as Balance_27, sum(Balance_28) as Balance_28, sum(Balance_29) as Balance_29, sum(Balance_30) as Balance_30,  
sum(Balance_31) As Balance_31,
sum(Balance_RC_1) as Balance_RC_1, sum(Balance_RC_2) as Balance_RC_2, sum(Balance_RC_3) as Balance_RC_3, sum(Balance_RC_4) as Balance_RC_4, sum(Balance_RC_5) as Balance_RC_5, sum(Balance_RC_6) as Balance_RC_6, sum(Balance_RC_7) as Balance_RC_7, sum(Balance_RC_8) as Balance_RC_8, sum(Balance_RC_9) as Balance_RC_9, sum(Balance_RC_10) as Balance_RC_10,  
sum(Balance_RC_11) as Balance_RC_11, sum(Balance_RC_12) as Balance_RC_12, sum(Balance_RC_13) as Balance_RC_13, sum(Balance_RC_14) as Balance_RC_14, sum(Balance_RC_15) as Balance_RC_15, sum(Balance_RC_16) as Balance_RC_16, sum(Balance_RC_17) as Balance_RC_17, sum(Balance_RC_18) as Balance_RC_18, sum(Balance_RC_19) as Balance_RC_19, sum(Balance_RC_20) as Balance_RC_20,  
sum(Balance_RC_21) as Balance_RC_21, sum(Balance_RC_22) as Balance_RC_22, sum(Balance_RC_23) as Balance_RC_23, sum(Balance_RC_24) as Balance_RC_24, sum(Balance_RC_25) as Balance_RC_25, sum(Balance_RC_26) as Balance_RC_26, sum(Balance_RC_27) as Balance_RC_27, sum(Balance_RC_28) as Balance_RC_28, sum(Balance_RC_29) as Balance_RC_29, sum(Balance_RC_30) as Balance_RC_30,  
sum(Balance_RC_31) As Balance_RC_31  
From GL, Branch  
Where GL.Branch=Branch.Branch and Branch.Parent=@P_Branch  and GL.Month=@P_mth and GL.Year=@P_yr  
Group By Account  

GO

IF EXISTS ( SELECT * FROM   sysobjects WHERE  id = object_id(N'[dbo].GL_FX_Consolidation') and OBJECTPROPERTY(id, N'IsProcedure') = 1 )
BEGIN
DROP Procedure GL_FX_Consolidation 
end
GO
CREATE Procedure GL_FX_Consolidation (@P_Branch Varchar(10), @P_Mth as Smallint, @P_Yr as Smallint)  
as  
Select @P_Branch, @P_Mth, @P_Yr, Account, [Currency], 
sum(Starting) as Starting, sum(Ending) as Ending, sum(Debit) as Debit, sum(Credit) as Credit, sum(Closing) as Closing, 
sum(Starting_BC) as Starting_BC, sum(Ending_BC) as Ending_BC, sum(Debit_BC) as Debit_BC, sum(Credit_BC) as Credit_BC, sum(Revaluation) as Revaluation, sum(Closing_BC) as Closing_BC,  
sum(Starting_RC) as Starting_RC, sum(Ending_RC) as Ending_RC, sum(Debit_RC) as Debit_RC, sum(Credit_RC) as Credit_RC, sum(Revaluation_RC) as Revaluation_RC, sum(Closing_RC) as Closing_BC,  
sum(Closing_12) as CLosing_12, sum(Closing_BC_12) as Closing_BC_12, sum(Closing_RC_12) as Closing_RC_12,
sum(Balance_1) as Balance_1, sum(Balance_2) as Balance_2, sum(Balance_3) as Balance_3, sum(Balance_4) as Balance_4, sum(Balance_5) as Balance_5, sum(Balance_6) as Balance_6, sum(Balance_7) as Balance_7, sum(Balance_8) as Balance_8, sum(Balance_9) as Balance_9, sum(Balance_10) as Balance_10,  
sum(Balance_11) as Balance_11, sum(Balance_12) as Balance_12, sum(Balance_13) as Balance_13, sum(Balance_14) as Balance_14, sum(Balance_15) as Balance_15, sum(Balance_16) as Balance_16, sum(Balance_17) as Balance_17, sum(Balance_18) as Balance_18, sum(Balance_19) as Balance_19, sum(Balance_20) as Balance_20,  
sum(Balance_21) as Balance_21, sum(Balance_22) as Balance_22, sum(Balance_23) as Balance_23, sum(Balance_24) as Balance_24, sum(Balance_25) as Balance_25, sum(Balance_26) as Balance_26, sum(Balance_27) as Balance_27, sum(Balance_28) as Balance_28, sum(Balance_29) as Balance_29, sum(Balance_30) as Balance_30,  
sum(Balance_31) As Balance_31  
From GL_FX, Branch  
Where GL_FX.Branch=Branch.Branch and Branch.Parent=@P_Branch  and GL_FX.Month=@P_mth and GL_FX.Year=@P_yr  
Group By Account, Currency  
    
GO

IF EXISTS ( SELECT * FROM   sysobjects WHERE  id = object_id(N'[dbo].CTL_Consolidation') and OBJECTPROPERTY(id, N'IsProcedure') = 1 )
BEGIN
DROP Procedure CTL_Consolidation 
end
GO
CREATE Procedure CTL_Consolidation (@P_Branch Varchar(10), @P_Mth as Smallint, @P_Yr as Smallint)  
as  
Select @P_Branch, @P_Mth, @P_Yr, Account, CT, sum(Balance) as Balance, sum(Balance_RC) as Balance_RC
from CTL, Branch 
Where CTL.Branch=Branch.Branch and Branch.Parent=@P_Branch  and CTL.Month=@P_mth and CTL.Year=@P_yr Group By Account, CT  
go

IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'PCALC' AND Object_ID = Object_ID(N'RATECON'))
BEGIN
ALTER TABLE dbo.RATECON ADD	PCALC varchar(1) NULL
DECLARE @v sql_variant 
SET @v = N'Premium Calculation Method (''Full, ''P''rorata,'''' default)'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'RATECON', N'COLUMN', N'PCALC'
end
go
UPDATE RATECON SET PCALC='' WHERE PCALC IS NULL
GO

if exists (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[fn_RateCon]') AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) )
BEGIN
DROP FUNCTION fn_RateCon
end
GO
CREATE FUNCTION fn_RateCon(@P_ANO as int,@P_Code as varchar(20),@P_TSI as Float=0)       
RETURNS Table       
AS RETURN (       
Select Top 1 *
From
(
	SELECT Top 1 cast(0 as Bit) as ProgressiveF, RateTab.Code, Acceptance.Sdate, RateCon.AllowedF, RateCon.MinRate, RateCon.MaxRate, RateCon.PML, RateCon.TExcess, RateTab.RateLoadingF,       
	Case When coalesce(RateCon.Loading,0)=0 Then 100 else RateCon.Loading end as Loading,       
	Case When coalesce(RateCon.PCTLOSS,0)=0 Then 100 else RateCon.PCTLOSS end as PCTLOSS,       
	--Rate Always in Percent       
	Case       
	When RateCon.Unit='F' then (Case When (Case When @P_TSI=0 Then 1 Else @P_TSI End)<>0 Then RateCon.Rate/(Case When @P_TSI=0 Then 1 Else @P_TSI End)*100 else 0 end)       
	When RateCon.Unit='M' then RateCon.Rate/10       
	else RateCon.Rate end as Rate,       
	RateCon.MaxTSI as MaxTSI,
	RateCon.PCalc     
	From Acceptance       
	INNER JOIN AInfo on (AInfo.ANO=Acceptance.ANO)       
	INNER JOIN COVER ON (COVER.CNO=ACCEPTANCE.CNO)       
	INNER JOIN RateTab ON ((RateTab.TOC=substring(Acceptance.TOC,1,len(RateTab.TOC))) and RateTab.Effective<=Acceptance.SDate and RateTab.Code=@P_Code) 
	INNER JOIN RateCon on (    
	 RateCon.Code=RateTab.Code And ((Case When @P_TSI=0 Then 1 Else @P_TSI End)>=RateCon.MinTSI or RateCon.MinTSI=0) and ((Case When @P_TSI=0 Then 1 Else @P_TSI End)<=RateCon.MaxTSI or RateCon.MaxTSI=0)     
	 And RateCon.ALLOWEDF=1
	 And RateCon.ProgressiveF=0
	 And (
	 (RateTab.SPeriod=0 and (    
	 (datediff(month, acceptance.sdate, acceptance.edate)>=RateCon.MinPeriod)     
	 or (datediff(month, acceptance.sdate, acceptance.edate)=RateCon.MinPeriod-1 and day(acceptance.sdate)<day(acceptance.edate))     
	 or RateCon.MinPeriod=0)                               
	 And (    
	 (datediff(month, acceptance.sdate, acceptance.edate)<RateCon.MaxPeriod)     
	 or (datediff(month, acceptance.sdate, acceptance.edate)=RateCon.MaxPeriod and day(acceptance.sdate)>=day(acceptance.edate))     
	 or RateCon.MaxPeriod=0)) OR
	(RateTab.SPeriod=1 
	 and ((datediff(day, acceptance.sdate, acceptance.edate)>=RateCon.MinPeriod) or RateCon.MinPeriod=0)
	 And ((datediff(day, acceptance.sdate, acceptance.edate)<=RateCon.MaxPeriod) or RateCon.MaxPeriod=0))
	 )     
	) 
	WHERE Acceptance.ANO=@P_ANO       
	And (coalesce(RateCon.ValueID1,'')='' or AINFO.VALUEID1 =RateCon.ValueID1)       
	And (coalesce(RateCon.ValueID2,'')='' or AINFO.VALUEID2 =RateCon.ValueID2)       
	And (coalesce(RateCon.ValueID3,'')='' or AINFO.VALUEID3 =RateCon.ValueID3)       
	And (coalesce(RateCon.ValueID4,'')='' or AINFO.VALUEID4 =RateCon.ValueID4)       
	And (coalesce(RateCon.ValueID5,'')='' or AINFO.VALUEID5 =RateCon.ValueID5)       
	And (coalesce(RateCon.ValueID6,'')='' or AINFO.VALUEID6 =RateCon.ValueID6)       
	And (coalesce(RateCon.ValueID7,'')='' or AINFO.VALUEID7 =RateCon.ValueID7)       
	And (coalesce(RateCon.ValueID8,'')='' or AINFO.VALUEID8 =RateCon.ValueID8)       
	And (coalesce(RateCon.ValueID9,'')='' or AINFO.VALUEID9 =RateCon.ValueID9)       
	And (coalesce(RateCon.ValueID10,'')='' or AINFO.VALUEID10 =RateCon.ValueID10)       
	And (coalesce(RateCon.ValueID11,'')='' or AINFO.VALUEID11 =RateCon.ValueID11)       
	And (coalesce(RateCon.ValueID12,'')='' or AINFO.VALUEID12 =RateCon.ValueID12)       
	And (coalesce(RateCon.ValueID13,'')='' or AINFO.VALUEID13 =RateCon.ValueID13)       
	And (coalesce(RateCon.ValueID14,'')='' or AINFO.VALUEID14 =RateCon.ValueID14)       
	And (coalesce(RateCon.ValueID15,'')='' or AINFO.VALUEID15 =RateCon.ValueID15)       
	Order by       
	RateTab.Effective Desc,       
	len(coalesce(RateCon.ValueID1,'')) Desc,       
	len(coalesce(RateCon.ValueID2,'')) Desc,       
	len(coalesce(RateCon.ValueID3,'')) Desc,       
	len(coalesce(RateCon.ValueID4,'')) Desc,       
	len(coalesce(RateCon.ValueID5,'')) Desc,       
	len(coalesce(RateCon.ValueID6,'')) Desc,       
	len(coalesce(RateCon.ValueID7,'')) Desc,       
	len(coalesce(RateCon.ValueID8,'')) Desc,       
	len(coalesce(RateCon.ValueID9,'')) Desc,       
	len(coalesce(RateCon.ValueID10,'')) Desc,       
	len(coalesce(RateCon.ValueID11,'')) Desc,       
	len(coalesce(RateCon.ValueID12,'')) Desc,       
	len(coalesce(RateCon.ValueID13,'')) Desc,       
	len(coalesce(RateCon.ValueID14,'')) Desc,       
	len(coalesce(RateCon.ValueID15,'')) Desc       

	UNION ALL

	SELECT 
	cast(1 as Bit) as ProgressiveF,
	RateTab.Code, 
	Max(Acceptance.Sdate) as Sdate,
	Cast(Max(Cast(RateCon.AllowedF as Int)) as Bit) as AllowedF, 
	sum(Case When (Case When @P_TSI=0 Then 1 Else @P_TSI End)>=RateCon.MaxTSI Then RateCon.MaxTSI-RateCon.MinTSI Else (Case When @P_TSI=0 Then 1 Else @P_TSI End)-RateCon.MinTSI end*RateCon.MinRate/(Case When @P_TSI=0 Then 1 Else @P_TSI End)) as MinRate,
	sum(Case When (Case When @P_TSI=0 Then 1 Else @P_TSI End)>=RateCon.MaxTSI Then RateCon.MaxTSI-RateCon.MinTSI Else (Case When @P_TSI=0 Then 1 Else @P_TSI End)-RateCon.MinTSI end*RateCon.MaxRate/(Case When @P_TSI=0 Then 1 Else @P_TSI End)) as MaxRate,
	Max(RateCon.PML) as PML, 
	Max(RateCon.TExcess) as TExcess, 
	cast(Max(cast(RateTab.RateLoadingF as Int)) as Bit) as RateLoadingF,       
	Max(Case When coalesce(RateCon.Loading,0)=0 Then 100 else RateCon.Loading end) as Loading,       
	Max(Case When coalesce(RateCon.PCTLOSS,0)=0 Then 100 else RateCon.PCTLOSS end) as PCTLOSS,       
	--Rate Always in Percent       
	sum(
	Case       
	When RateCon.Unit='F' then (Case When (Case When @P_TSI=0 Then 1 Else @P_TSI End)<>0 Then RateCon.Rate/(Case When @P_TSI=0 Then 1 Else @P_TSI End)*100 else 0 end)       
	When RateCon.Unit='M' then 
		Case When (Case When @P_TSI=0 Then 1 Else @P_TSI End)>=RateCon.MaxTSI Then RateCon.MaxTSI-RateCon.MinTSI Else (Case When @P_TSI=0 Then 1 Else @P_TSI End)-RateCon.MinTSI end*RateCon.Rate/10/(Case When @P_TSI=0 Then 1 Else @P_TSI End) 
	else Case When (Case When @P_TSI=0 Then 1 Else @P_TSI End)>=RateCon.MaxTSI Then RateCon.MaxTSI-RateCon.MinTSI Else (Case When @P_TSI=0 Then 1 Else @P_TSI End)-RateCon.MinTSI end*RateCon.Rate/(Case When @P_TSI=0 Then 1 Else @P_TSI End) end 
	)as Rate,
	Max(RateCon.MaxTSI) as MaxTSI,
	Max(RateCon.PCalc) as PCalc
	From Acceptance       
	INNER JOIN AInfo on (AInfo.ANO=Acceptance.ANO)       
	INNER JOIN COVER ON (COVER.CNO=ACCEPTANCE.CNO)       
	INNER JOIN RateTab ON ((RateTab.TOC=substring(Acceptance.TOC,1,len(RateTab.TOC))) and RateTab.Effective<=Acceptance.SDate and RateTab.Code=@P_Code)       
	INNER JOIN RateCon on (    
	 RateCon.Code=RateTab.Code 
	 And ((Case When @P_TSI=0 Then 1 Else @P_TSI End) Between RateCon.MinTSI and RateCon.MaxTSI or RateCon.MaxTSI<=(Case When @P_TSI=0 Then 1 Else @P_TSI End))
	 And RateCon.ALLOWEDF=1
	 And RateCon.ProgressiveF=1
	 And (
	 (RateTab.SPeriod=0 and (    
	 (datediff(month, acceptance.sdate, acceptance.edate)>=RateCon.MinPeriod)     
	 or (datediff(month, acceptance.sdate, acceptance.edate)=RateCon.MinPeriod-1 and day(acceptance.sdate)<day(acceptance.edate))     
	 or RateCon.MinPeriod=0)                               
	 And (    
	 (datediff(month, acceptance.sdate, acceptance.edate)<RateCon.MaxPeriod)     
	 or (datediff(month, acceptance.sdate, acceptance.edate)=RateCon.MaxPeriod and day(acceptance.sdate)>=day(acceptance.edate))     
	 or RateCon.MaxPeriod=0)) OR
	(RateTab.SPeriod=1 
	 and ((datediff(day, acceptance.sdate, acceptance.edate)>=RateCon.MinPeriod) or RateCon.MinPeriod=0)
	 And ((datediff(day, acceptance.sdate, acceptance.edate)<=RateCon.MaxPeriod) or RateCon.MaxPeriod=0))
	 )     
	) 
	WHERE Acceptance.ANO=@P_ANO       
	And (coalesce(RateCon.ValueID1,'')='' or AINFO.VALUEID1 =RateCon.ValueID1)       
	And (coalesce(RateCon.ValueID2,'')='' or AINFO.VALUEID2 =RateCon.ValueID2)       
	And (coalesce(RateCon.ValueID3,'')='' or AINFO.VALUEID3 =RateCon.ValueID3)       
	And (coalesce(RateCon.ValueID4,'')='' or AINFO.VALUEID4 =RateCon.ValueID4)       
	And (coalesce(RateCon.ValueID5,'')='' or AINFO.VALUEID5 =RateCon.ValueID5)       
	And (coalesce(RateCon.ValueID6,'')='' or AINFO.VALUEID6 =RateCon.ValueID6)       
	And (coalesce(RateCon.ValueID7,'')='' or AINFO.VALUEID7 =RateCon.ValueID7)       
	And (coalesce(RateCon.ValueID8,'')='' or AINFO.VALUEID8 =RateCon.ValueID8)       
	And (coalesce(RateCon.ValueID9,'')='' or AINFO.VALUEID9 =RateCon.ValueID9)       
	And (coalesce(RateCon.ValueID10,'')='' or AINFO.VALUEID10 =RateCon.ValueID10)       
	And (coalesce(RateCon.ValueID11,'')='' or AINFO.VALUEID11 =RateCon.ValueID11)       
	And (coalesce(RateCon.ValueID12,'')='' or AINFO.VALUEID12 =RateCon.ValueID12)       
	And (coalesce(RateCon.ValueID13,'')='' or AINFO.VALUEID13 =RateCon.ValueID13)       
	And (coalesce(RateCon.ValueID14,'')='' or AINFO.VALUEID14 =RateCon.ValueID14)       
	And (coalesce(RateCon.ValueID15,'')='' or AINFO.VALUEID15 =RateCon.ValueID15)       
	Group By RateTab.Code
) R
)       


go

--VERSIONING
insert into versioning
select '2017 V.2.27.0',GETDATE(),'2017 V.2.0.0',GETDATE(),'K: 2017 V.2.0.0',GETDATE()
go
