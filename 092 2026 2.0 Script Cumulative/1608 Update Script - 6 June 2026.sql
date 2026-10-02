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
IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'RiskScheduleF' AND Object_ID = Object_ID(N'Payor'))

ALTER TABLE dbo.PAYOR ADD
	RiskScheduleF bit NULL
GO
DECLARE @v sql_variant 
SET @v = N'Sum Insured Schedule/Payor Schedule (0 : No, 1 : Yes, Create Payor_Schedule)'
EXECUTE sp_updateextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'PAYOR', N'COLUMN', N'SIScheduleF'
GO
DECLARE @v sql_variant 
SET @v = N'Billing by Risk Schedule (0 : No, 1 : Yes)'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'PAYOR', N'COLUMN', N'RiskScheduleF'
GO
Update Payor Set RiskScheduleF=0 Where RiskScheduleF is null
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

GO
IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'RiskScheduleF' AND Object_ID = Object_ID(N'APayor'))

ALTER TABLE dbo.APayor ADD
	RiskScheduleF bit NULL
GO
DECLARE @v sql_variant 
SET @v = N'Sum Insured Schedule/Payor Schedule (0 : No, 1 : Yes, Create Payor_Schedule)'
EXECUTE sp_updateextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'PAYOR', N'COLUMN', N'SIScheduleF'
GO
DECLARE @v sql_variant 
SET @v = N'Billing by Risk Schedule (0 : No, 1 : Yes)'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'PAYOR', N'COLUMN', N'RiskScheduleF'
GO
Update APayor Set RiskScheduleF=0 Where RiskScheduleF is null
GO
DROP Procedure QPCALC_ACCASS
GO
CREATE Procedure QPCALC_ACCASS (@P_ANO integer)     
AS     
SELECT ICALC.CURRENCY, ICALC.CODE, 
Min(ICalc.SDATE) as ISDate,
Max(ICalc.EDate) as IEDate,
(Case When coalesce(APayor.PolicyYearF,Payor.PolicyYearF)=1 then ICalc.SDate else coalesce(P.InstDate, ICalc.SDate) end) as SDate,
(Case When coalesce(APayor.PolicyYearF,Payor.PolicyYearF)=1 then ICalc.EDate else coalesce(P.InstLDate, ICalc.EDate) end) as EDate,
(Case When A1.AType='A' Then 0 else ICover.Adjustable end) as AdjustableF, 
ICALC.SANO, A2.LANO,     
Cast(Max(cast(RCover.NoRefundF as Integer)) as Bit) as NoRefundF,     
Max(Case When ICover.Adjustable=1 Then TOI.AdjMethod else '' end) as AdjMethod,     
AVG(ICALC.PRORATA) AS PPRORATA, 
MAX(CASE WHEN PCALC.TSI<>0 AND COALESCE(ISOURCE.LIMIT,0)<>0 THEN PCALC.OURSHARE/PCALC.TSI*100 ELSE COALESCE(ISOURCE.SHARE,100) END) as SHARE, 
MAX(Case When PCalc.Description='Premium by Decreasing SI' then coalesce(P.InstSIPCT,100) else 100 end) AS InstSIPCT,     
SUM(
Case 
When (coalesce(APayor.ScheduleF,Payor.ScheduleF)=1 or (coalesce(APayor.PolicyYearF,Payor.PolicyYearF)=1 and coalesce(APayor.DecreasePremiumF,Payor.DecreasePremiumF)=1)) then coalesce(P.InstAmount,0)
else (Case When (PCALC.Description<>'' and PCALC.Description<>'Minimum Premium') then ICALC.GROSS*PCALC.GROSS/PCALC.OGROSS else ICALC.GROSS*RCALC.GROSS/RCALC.OGROSS end)
End
) as GROSS,
--SUM(Case When PCalc.Description='Premium by Decreasing SI' then coalesce(P.InstAmount,0) else coalesce(P.InstPCT,100)/100*(Case When (PCALC.Description<>'' and PCALC.Description<>'Minimum Premium') then ICALC.GROSS*PCALC.GROSS/PCALC.OGROSS else ICALC.GROSS*RCALC.GROSS/RCALC.OGROSS end) end) AS GROSS,     
MAX(PCALC.GROSS) as TOTALGROSS,
CAST(MAX(Case When Upper(PCALC.DESCRIPTION) in ('MINIMUM PREMIUM','POLICY MINIMUM PREMIUM') Then 1 else 0 end) as Bit) as MinimumPremiumF,     
SUM(ICALC.REINSTATEMENT) AS REINSTATEMENT,     
SUM(ICALC.DISCOUNT) AS DISCOUNT,     
SUM(ICALC.LOADING) AS LOADING,     
MAX(PCALC.TSI) as TSI,      --100% Sum Insured for Reinsurance Rate     
MAX(PCALC.Rate) As Rate,
MAX(RateTab.BPComm) as BPComm
FROM ICover     
inner join ICALC on (ICALC.INO=ICOVER.INO and ICALC.ANO=ICOVER.ANO)     
inner join TOI on (TOI.TOI=ICOVER.TOI)     
inner join RCALC on (ICALC.ANO=RCALC.ANO AND ICALC.CURRENCY=RCALC.CURRENCY AND ICALC.CODE=RCALC.CODE AND ICALC.TOR=RCALC.TOR AND ICALC.SDATE=RCALC.SDATE AND ICALC.EDATE=RCALC.EDATE AND ICALC.SANO=RCALC.SANO)     
inner join PCALC on (PCALC.ANO=ICALC.ANO AND PCALC.CURRENCY=ICALC.CURRENCY)     
Left join RCover on (RCover.ANO=RCalc.ANO and RCover.Code=RCalc.Code and RCover.SDate=RCalc.SDate)     
Inner Join RateTab on (RateTab.Code=ICalc.Code)
inner join ACCEPTANCE A1 On (A1.ANO=ICALC.ANO)     
inner join ACCEPTANCE A2 on (A2.ANO=ICALC.SANO)     
Inner Join RArrHeader R on (R.ANO=ICalc.ANO)     
left join ISource on (ISource.CNO=A2.CNO)   
Left Join Payor on (Payor.ANO=@P_ANO)
Left Join APayor on (APayor.ANO=@P_ANO)  
Left Join Payor_Schedule P on (
	P.ANO=@P_ANO 
	and coalesce(APayor.SIScheduleF,Payor.SIScheduleF)=1
	and 
	(
	((coalesce(APayor.ScheduleF,Payor.ScheduleF)=1 or (coalesce(APayor.PolicyYearF,Payor.PolicyYearF)=1 and coalesce(APayor.DecreasePremiumF,Payor.DecreasePremiumF)=1)) and P.InstDate Between ICalc.SDate and dateadd(day,-1,ICalc.EDate)) 
	or
	((coalesce(APayor.RiskScheduleF,Payor.RiskScheduleF)=1) and ICalc.SDate Between P.InstDate and dateadd(day,-1,P.InstLDate))
	)
	)
WHERE ICover.ANO=@P_ANO and ICALC.GROSS<>0
GROUP BY ICALC.CURRENCY, ICALC.CODE, 
(Case When coalesce(APayor.PolicyYearF,Payor.PolicyYearF)=1 then ICalc.SDate else coalesce(P.InstDate, ICalc.SDate) end),
(Case When coalesce(APayor.PolicyYearF,Payor.PolicyYearF)=1 then ICalc.EDate else coalesce(P.InstLDate, ICalc.EDate) end),
(Case When A1.AType='A' Then 0 else ICover.Adjustable end), ICalc.SANO, A2.LANO     


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
  
Case When (coalesce(APayor.ScheduleF,coalesce(Payor.ScheduleF,0))=1) or (coalesce(APayor.RiskScheduleF,coalesce(Payor.RiskScheduleF,0))=1) or (Case When isnull(APayor.ANO,0)=0 Then (Case When isnull(MPayor.ANO,0)=0 Then Payor.PolicyYearF else MPayor.PolicyYearF end) else APayor.PolicyYearF end)=1 Then A1.SDate else A2.SDate end as SDate,                                
Min(Case When (coalesce(APayor.ScheduleF,coalesce(Payor.ScheduleF,0))=1) or (coalesce(APayor.RiskScheduleF,coalesce(Payor.RiskScheduleF,0))=1) or (Case When isnull(APayor.ANO,0)=0 Then (Case When isnull(MPayor.ANO,0)=0 Then Payor.PolicyYearF else MPayor.PolicyYearF end) else APayor.PolicyYearF end)=1 Then A1.EDate else A2.EDate end) as EDate,                 
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
Case When (coalesce(APayor.ScheduleF,coalesce(Payor.ScheduleF,0))=1) or (coalesce(APayor.RiskScheduleF,coalesce(Payor.RiskScheduleF,0))=1) or (Case When isnull(APayor.ANO,0)=0 Then (Case When isnull(MPayor.ANO,0)=0 Then Payor.PolicyYearF else MPayor.PolicyYearF end) else APayor.PolicyYearF end)=1 Then A1.SDate else A2.SDate end,                  
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



