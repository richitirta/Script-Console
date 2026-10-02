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
ALTER TABLE dbo.PAlias ADD
	PShortName varchar(10) NULL
GO
DECLARE @v sql_variant 
SET @v = N'Short Name, Short Account Name'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'PAlias', N'COLUMN', N'PShortName'
GO
Update PAlias Set PShortName=case When MID<>'' Then MID else ID end from PAlias where PShortName is null

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
ALTER TABLE dbo.PAlias WITH NOCHECK ADD CONSTRAINT 
	I_PAlias_ID_PShortName UNIQUE NONCLUSTERED 
	(
	ID,
	PShortName
	) 

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
ALTER TABLE dbo.PAYOR ADD
	PShortName varchar(10) NULL
GO
DECLARE @v sql_variant 
SET @v = N'Profile Alias (PAlias) Short Name'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'PAYOR', N'COLUMN', N'PShortName'
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
ALTER TABLE dbo.APayor ADD
	PShortName varchar(10) NULL
GO
DECLARE @v sql_variant 
SET @v = N'Profile Alias (PAlias) Short Name'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'APayor', N'COLUMN', N'PShortName'
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
	PShortName varchar(10) NULL
GO
DECLARE @v sql_variant 
SET @v = N'Profile Alias ShortName (see PAlias)'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'ProAcc', N'COLUMN', N'PShortName'
GO
Update ProAcc Set PShortName='' Where PShortName is null
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
ALTER TABLE dbo.AdmLink ADD
	PShortName varchar(10) NULL
GO
DECLARE @v sql_variant 
SET @v = N'Payor Short Name (see Payor and PAlias)'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'AdmLink', N'COLUMN', N'PShortName'
GO
COMMIT

GO

DROP Procedure QProduction_To_Adm
GO
CREATE Procedure QProduction_To_Adm(@P_ANO as int)                                
as                                
Select A1.ID, A1.TOC, A1.Type, A1.Currency, A1.Date, A1.BillDate,
Max(coalesce(Payor.PShortName, coalesce(APayor.PShortName, MPayor.PShortName))) as PShortName,
Case 
When A2.SplitDNCNF=1 and A1.CAmount=0 and Coalesce(A3.ANO,0)<>0 Then 
	Case
	When SysTab.DueByEffectiveF=1 then 
		A3.PDate
	Else 
		A2.ADate
	End
Else 
	A1.BillDate 
end as pBillDate,
A1.DocNo as DocNo, A1.RefNo,    
Case When SysTab.SplitPremiumAndClaimF=1 and A1.Code in ('A','R') Then 'Claim' else 'Premium' end as Subject,         
Max(Case When coalesce(AL.RefNo,'')=A2.RefNo and C.ISType<>'T' Then coalesce(AL.AName,Case When A2.AName<>'' then A2.AName else A2.Remarks end) else Case When A2.AName<>'' then A2.AName else A2.Remarks end end) as Remarks,                                   
Case When (coalesce(APayor.ScheduleF,coalesce(Payor.ScheduleF,0))=1) or (Case When isnull(APayor.ANO,0)=0 Then (Case When isnull(MPayor.ANO,0)=0 Then Payor.PolicyYearF else MPayor.PolicyYearF end) else APayor.PolicyYearF end)=1 Then A1.SDate else A2.SDate end as SDate,                                
Min(Case When (coalesce(APayor.ScheduleF,coalesce(Payor.ScheduleF,0))=1) or (Case When isnull(APayor.ANO,0)=0 Then (Case When isnull(MPayor.ANO,0)=0 Then Payor.PolicyYearF else MPayor.PolicyYearF end) else APayor.PolicyYearF end)=1 Then A1.EDate else A2.EDate end) as EDate,                 
Max(A2.Source) as Source,                                
Cast(Max(Case When A2.SplitDNCNF=1 and A1.CAmount=0 and Coalesce(A3.ANO,0)<>0 Then 1 Else 0 end) as Bit) as DataReversalF,   
Case When A1.CAmount=0 and Coalesce(A3.Branch,'')<>'' Then A3.Branch Else A2.Branch end as Branch,        
cast(Max(cast(A1.CommPoolF as Integer)) as Bit) as CommPoolF,     
cast(Max(cast(MParam.WriteF as Integer)) as Bit) as WriteF,     
Min(A1.SDate) as MINSDate, Max(A1.SDate) as MAXSDate,                  
Min(A1.ACNO)  as MinACNO, Max(A1.ACNO) as MaxACNO,                        
Max(coalesce(RCover.Code, A1.RCode)) as RCode,  
Case When Max(cast(SysTab.CalculationRoundingF as Int))=1 then dbo.RoundCCY(sum(Case When A1.Code='P' then A1.Amount else 0 end), A1.Currency) else sum(Case When A1.Code='P' then A1.Amount else 0 end) end as Amount_1,  
Case When Max(cast(SysTab.CalculationRoundingF as Int))=1 then dbo.RoundCCY(sum(Case When A1.Code='C' then A1.Amount else 0 end), A1.Currency) else sum(Case When A1.Code='C' then A1.Amount else 0 end) end as Amount_2,  
Case When Max(cast(SysTab.CalculationRoundingF as Int))=1 then dbo.RoundCCY(sum(Case When A1.Code='F' and coalesce(A1.CodeExt,'')='' then A1.Amount else 0 end), A1.Currency) else sum(Case When A1.Code='F' and coalesce(A1.CodeExt,'')='' then A1.Amount else 0 end) end as Amount_3,  
Case When Max(cast(SysTab.CalculationRoundingF as Int))=1 then dbo.RoundCCY(sum(Case When (A1.Code='D' and coalesce(A1.CodeExt,'')='') or (A1.Code='G') then A1.Amount else 0 end), A1.Currency) else sum(Case When (A1.Code='D' and coalesce(A1.CodeExt,'')='') or (A1.Code='G') then A1.Amount else 0 end) end as Amount_4,  
Case When Max(cast(SysTab.CalculationRoundingF as Int))=1 then dbo.RoundCCY(sum(Case When A1.Code='O' then A1.Amount else 0 end), A1.Currency) else sum(Case When A1.Code='O' then A1.Amount else 0 end) end as Amount_5,  
Case When Max(cast(SysTab.CalculationRoundingF as Int))=1 then dbo.RoundCCY(sum(Case When A1.Code='A' then A1.Amount else 0 end), A1.Currency) else sum(Case When A1.Code='A' then A1.Amount else 0 end) end as Amount_6,  
Case When Max(cast(SysTab.CalculationRoundingF as Int))=1 then dbo.RoundCCY(sum(Case When A1.Code='R' then A1.Amount else 0 end), A1.Currency) else sum(Case When A1.Code='R' then A1.Amount else 0 end) end as Amount_10,  
Case When Max(cast(SysTab.CalculationRoundingF as Int))=1 then dbo.RoundCCY(sum(Case When A1.Code in ('D','F') and coalesce(A1.CodeExt,'')='3' then A1.Amount else 0 end), A1.Currency) else sum(Case When A1.Code in ('D','F') and coalesce(A1.CodeExt,'')='3' then A1.Amount else 0 end) end as Amount_12,  
Case When Max(cast(SysTab.CalculationRoundingF as Int))=1 then dbo.RoundCCY(sum(Case When A1.Code='V' then A1.Amount else 0 end), A1.Currency) else sum(Case When A1.Code='V' then A1.Amount else 0 end) end as Amount_13,  
Case When Max(cast(SysTab.CalculationRoundingF as Int))=1 then dbo.RoundCCY(sum(Case When A1.Code='T' then A1.Amount else 0 end), A1.Currency) else sum(Case When A1.Code='T' then A1.Amount else 0 end) end as Amount_14,  
Case When Max(cast(SysTab.CalculationRoundingF as Int))=1 then dbo.RoundCCY(sum(Case When A1.Code in ('D','F') and coalesce(A1.CodeExt,'')='1' then A1.Amount else 0 end), A1.Currency) else sum(Case When A1.Code in ('D','F') and coalesce(A1.CodeExt,'')='1' then A1.Amount else 0 end) end as Amount_15,  
Case When Max(cast(SysTab.CalculationRoundingF as Int))=1 then dbo.RoundCCY(sum(Case When A1.Code in ('D','F') and coalesce(A1.CodeExt,'')='2' then A1.Amount else 0 end), A1.Currency) else sum(Case When A1.Code in ('D','F') and coalesce(A1.CodeExt,'')='2' then A1.Amount else 0 end) end as Amount_16,  
Case When Max(cast(SysTab.CalculationRoundingF as Int))=1 then dbo.RoundCCY(sum(Case When A1.Code='J' then A1.Amount else 0 end), A1.Currency) else sum(Case When A1.Code='J' then A1.Amount else 0 end) end as Amount_19,  
Case When Max(cast(SysTab.CalculationRoundingF as Int))=1 then dbo.RoundCCY(sum(Case When A1.Code='U' then A1.Amount else 0 end), A1.Currency) else sum(Case When A1.Code='U' then A1.Amount else 0 end) end as Amount_20  
from AccAss A1                                
Inner Join MParam on (MParam.Type=A1.Type)  
Inner Join Acceptance A2 on (A2.ANO=A1.ANO)                                
Left join  Acceptance A3 on (A3.ANO=A2.pANO)      
Inner Join Cover C on (C.CNO=A2.CNO)                    
Left Join Acceptance AL on (AL.ANO=A2.LANO and C.OpenFlag=0)                    
Left Join APayor on (APayor.ANO=A2.ANO and A2.LANO<>-1 and A2.ANO<>A2.LANO)                                
Left Join Payor on (Payor.ANO=A2.ANO and A2.LANO=-1)                   
Left Join Payor MPayor on (MPayor.ANO=A2.LANO and A2.LANO<>-1)      
Left Join RCover on (RCover.ANO=A2.ANO and RCover.Code=A1.RCode and RCover.SDate=A1.SDate and RCover.Category='M')  
Inner Join SysTab on (1=1)     
Where A1.ANO=@P_ANO                                
Group By A1.DocNo, A1.RefNo, A1.Type, A1.ID, A1.TOC, A1.Currency, A1.Date, A1.BillDate,
Case 
When A2.SplitDNCNF=1 and A1.CAmount=0 and Coalesce(A3.ANO,0)<>0 Then 
	Case
	When SysTab.DueByEffectiveF=1 then 
		A3.PDate
	Else 
		A2.ADate
	End
Else 
	A1.BillDate 
end,         
Case When SysTab.SplitPremiumAndClaimF=1 and A1.Code in ('A','R') Then 'Claim' else 'Premium' end,  
Case When (coalesce(APayor.ScheduleF,coalesce(Payor.ScheduleF,0))=1) or (Case When isnull(APayor.ANO,0)=0 Then (Case When isnull(MPayor.ANO,0)=0 Then Payor.PolicyYearF else MPayor.PolicyYearF end) else APayor.PolicyYearF end)=1 Then A1.SDate else A2.SDate end,                  
Case When A1.CAmount=0 and Coalesce(A3.Branch,'')<>'' Then A3.Branch Else A2.Branch end   
Order By A1.DocNo, A1.RefNo, A1.Type, A1.ID, A1.TOC, A1.Currency, A1.Date, A1.BillDate,
Case 
When A2.SplitDNCNF=1 and A1.CAmount=0 and Coalesce(A3.ANO,0)<>0 Then 
	Case
	When SysTab.DueByEffectiveF=1 then 
		A3.PDate
	Else 
		A2.ADate
	End
Else 
	A1.BillDate 
end

GO

DROP Procedure QClaim_To_Adm
GO
CREATE Procedure QClaim_To_Adm(@P_CNO as int)                              
as   
Select C1.ID, C1.TOC, C1.Type, C1.Currency, C1.RefNo, C1.RefID, C1.RefName,
Max(coalesce(Payor.PShortName, coalesce(APayor.PShortName, MPayor.PShortName))) as PShortName,
Max(C1.CodeExt) as CodeExt,
Max(C1.Date) as Date,
Max(C1.BillDate) as BillDate,
Max(C1.DocNo) as DocNo,
Max(CLSub.ComAcc) as ComAcc,
Max(C1.Remarks) as Remarks, 
Cast(Max(cast(coalesce(PCLCOST.EXGRATIAF,coalesce(CLCOST.EXGRATIAF,0)) as Integer)) as Bit) as EXGRATIAF,
Case When TOC.CashCallOnPartialPaymentF=1 then cast(0 as bit) else C1.CashLossF end as CashLossGroup, 
Cast(Max(Case When TOC.CashCallOnPartialPaymentF=1 and C1.CAmount=0 then cast(0 as Int) else cast(C1.CashLossF as Int) end) as Bit) as CashLossF,
Max(C1.RCode) as RCode, 
Case When Max(cast(SysTab.CalculationRoundingF as Int))=1 then dbo.RoundCCY(sum(Case When C1.Code='P' then C1.Amount else 0 end), C1.CURRENCY) else sum(Case When C1.Code='P' then C1.Amount else 0 end) end as Amount_1,                              
Case When Max(cast(SysTab.CalculationRoundingF as Int))=1 then dbo.RoundCCY(sum(Case When C1.Code='A' then C1.Amount else 0 end), C1.CURRENCY) else sum(Case When C1.Code='A' then C1.Amount else 0 end) end as Amount_6,                              
Case When Max(cast(SysTab.CalculationRoundingF as Int))=1 then dbo.RoundCCY(sum(Case When C1.Code='E' then C1.Amount else 0 end), C1.CURRENCY) else sum(Case When C1.Code='E' then C1.Amount else 0 end) end as Amount_7,                              
Case When Max(cast(SysTab.CalculationRoundingF as Int))=1 then dbo.RoundCCY(sum(Case When C1.Code='S' then C1.Amount else 0 end), C1.CURRENCY) else sum(Case When C1.Code='S' then C1.Amount else 0 end) end as Amount_8,                              
Case When Max(cast(SysTab.CalculationRoundingF as Int))=1 then dbo.RoundCCY(sum(Case When C1.Code='L' then C1.Amount else 0 end), C1.CURRENCY) else sum(Case When C1.Code='L' then C1.Amount else 0 end) end as Amount_9,                              
Case When Max(cast(SysTab.CalculationRoundingF as Int))=1 then dbo.RoundCCY(sum(Case When C1.Code='R' then C1.Amount else 0 end), C1.CURRENCY) else sum(Case When C1.Code='R' then C1.Amount else 0 end) end as Amount_10,                              
Case When Max(cast(SysTab.CalculationRoundingF as Int))=1 then dbo.RoundCCY(sum(Case When C1.Code='V' then C1.Amount else 0 end), C1.CURRENCY) else sum(Case When C1.Code='V' then C1.Amount else 0 end) end as Amount_13,                              
Case When Max(cast(SysTab.CalculationRoundingF as Int))=1 then dbo.RoundCCY(sum(Case When C1.Code='T' then C1.Amount else 0 end), C1.CURRENCY) else sum(Case When C1.Code='T' then C1.Amount else 0 end) end as Amount_14,                              
Case When Max(cast(SysTab.CalculationRoundingF as Int))=1 then dbo.RoundCCY(sum(Case When C1.Code='F' then C1.Amount else 0 end), C1.CURRENCY) else sum(Case When C1.Code='F' then C1.Amount else 0 end) end as Amount_15,                              
Case When Max(cast(SysTab.CalculationRoundingF as Int))=1 then dbo.RoundCCY(sum(Case When C1.Code='D' then C1.Amount else 0 end), C1.CURRENCY) else sum(Case When C1.Code='D' then C1.Amount else 0 end) end as Amount_16,                              
Case When Max(cast(SysTab.CalculationRoundingF as Int))=1 then dbo.RoundCCY(sum(Case When C1.Code='I' then C1.Amount else 0 end), C1.CURRENCY) else sum(Case When C1.Code='I' then C1.Amount else 0 end) end as Amount_17
from ClaAss C1
INNER JOIN CLAIM C2 on (C2.CNO=C1.CNO)
INNER JOIN ACCEPTANCE A2 on (A2.ANO=C2.ANO)
Left Join APayor on (APayor.ANO=A2.ANO and A2.LANO<>-1 and A2.ANO<>A2.LANO)                                
Left Join Payor on (Payor.ANO=A2.ANO and A2.LANO=-1)                   
Left Join Payor MPayor on (MPayor.ANO=A2.LANO and A2.LANO<>-1)   
INNER JOIN TOC on (TOC.TOC=C2.TOC)
LEFT JOIN CLAIM pC2 on (pC2.CNO=C2.PCNO)
Inner Join SysTab on (1=1)   
Outer Apply (
	Select CLCOST.CNO, CLCOST.ID, CLCOST.Currency, CASE WHEN CLCOST.REFNO<>'' THEN CLCOST.REFNO ELSE C2.REFNO END AS RefNo, cast(Max(cast(CLCOST.ExGratiaF as integer)) as Bit) as ExGratiaF 
	from CLCOST 
	WHERE C1.CAMOUNT<>0 AND C1.Type='OP' and C1.Code='L' 
	AND CLCOST.CNO=C2.CNO AND CLCOST.ID=C1.ID AND CASE WHEN CLCOST.REFNO<>'' THEN CLCOST.REFNO ELSE C2.REFNO END=C1.REFNO AND CLCOST.CURRENCY=C1.CURRENCY
	Group By CLCOST.CNO, CLCOST.ID, CLCOST.Currency, CASE WHEN CLCOST.REFNO<>'' THEN CLCOST.REFNO ELSE C2.REFNO END
) CLCOST
Outer Apply (
	Select CLCOST.CNO, CLCOST.ID, CLCOST.Currency, CASE WHEN CLCOST.REFNO<>'' THEN CLCOST.REFNO ELSE pC2.REFNO END AS RefNo, cast(Max(cast(CLCOST.ExGratiaF as integer)) as Bit) as ExGratiaF 
	from CLCOST
	WHERE C1.CAMOUNT=0 AND C1.Type='OP' and C1.Code='L' 
	AND CLCOST.CNO=pC2.CNO AND CLCOST.ID=C1.ID AND CASE WHEN CLCOST.REFNO<>'' THEN CLCOST.REFNO ELSE pC2.REFNO END=C1.REFNO AND CLCOST.CURRENCY=C1.CURRENCY
	Group By CLCOST.CNO, CLCOST.ID, CLCOST.Currency, CASE WHEN CLCOST.REFNO<>'' THEN CLCOST.REFNO ELSE pC2.REFNO END
) PCLCOST
Outer Apply (
	Select CLSUB.CNO, CLSUB.ID, CLSUB.Currency, CASE WHEN CLSUB.REFNO<>'' THEN CLSUB.REFNO ELSE C2.REFNO END AS RefNo, Max(CLSUB.COMACC) as ComAcc
	from CLSUB
	WHERE C1.CAMOUNT<>0 AND C1.Type='OP' and C1.Code='R' 
	and CLSUB.CNO=C2.CNO AND CLSUB.ID=C1.ID AND CASE WHEN CLSUB.REFNO<>'' THEN CLSUB.REFNO ELSE C2.REFNO END=C1.REFNO AND CLSUB.CURRENCY=C1.CURRENCY
	Group By CLSUB.CNO, CLSUB.ID, CLSUB.Currency, CASE WHEN CLSUB.REFNO<>'' THEN CLSUB.REFNO ELSE C2.REFNO END
) CLSUB
Where C1.CNO=@P_CNO
Group by C1.ID, C1.TOC, C1.Type, C1.Currency, C1.RefNo, C1.RefID, C1.RefName, Case When TOC.CashCallOnPartialPaymentF=1 then cast(0 as bit) else C1.CashLossF end

GO


