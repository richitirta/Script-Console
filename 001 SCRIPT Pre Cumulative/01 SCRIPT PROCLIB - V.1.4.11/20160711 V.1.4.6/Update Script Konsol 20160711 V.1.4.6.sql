--V.1.4.6 
--5.	Koreksi pada proses kalkulasi premi pada adjustment polis, dimana nnilai perhitungan prorata period tidak tercampur dengan rate prorata. jika Rate menggunakan scalling Method atau Prorate Premium   
IF EXISTS ( SELECT * FROM   sysobjects WHERE  id = object_id(N'[dbo].[PCALC01_ADJ]') and OBJECTPROPERTY(id, N'IsProcedure') = 1 ) BEGIN    DROP PROCEDURE [dbo].[PCALC01_ADJ] END 
go
CREATE Procedure PCALC01_ADJ(@P_ANO integer)   
As   
SELECT  COVER.TOC,   
COVER.PPERIOD,   
DATEDIFF(DAY,A1.SDATE, A1.EDATE) as PRORATA,   
COVER.VOYAGE,   
RCOVER.UNIT,   
RCOVER.CODE,   
RATECOV.TOR,   
RCOVER.DISCOUNT,   
RCOVER.LOADING,   
RCOVER.RATE*RATECOV.PORTION/RCOVER.PORTION*RCalc.Prorata AS RATE,   
RATECOV.PORTION,   
   
case   
when RCOVER.SDATE<A2.PDATE then A2.PDATE   
Else RCOVER.SDATE end as SDATE,   
Case   
When RCOVER.EDATE>A2.PPDATE then A2.PPDATE   
ELSE RCOVER.EDATE end as EDATE,   
Case WHEN ICOVER.NOTDECRF=1 then 100 else RCOVER.PCTLOSS end as PCTLOSS,   
Case WHEN ICOVER.NOTDECRF=1 then 0 else RCOVER.PADDITION end as PADDITION,   
Case When (Case when RCOVER.SDATE<A2.PDATE then A2.PDATE Else RCOVER.SDATE end)=A1.SDATE 
AND (Case When RCOVER.EDATE>A2.PPDATE then A2.PPDATE ELSE RCOVER.EDATE end)=A1.EDATE Then RCover.PCalc Else 'P' End as PCalc,   
Case when TOI.ADJMETHOD='OVERLIMIT ' then A1.CPCT else (Case When A1.CPCT<>0 then A1.CPCT else 100 end*cast(datediff(day, case when RCOVER.SDATE<A2.PDATE then A2.PDATE Else RCOVER.SDATE end, Case When RCOVER.EDATE>A2.PPDATE then A2.PPDATE ELSE RCOVER.EDATE end) as float)/  cast(DATEDIFF(DAY,A1.SDATE, A1.EDATE) as float)) end as PPRORATA,   
ICOVER.CURRENCY,   
ICOVER.SI,   
ICOVER.Adjustable,   
ICOVER.PCTADJ,   
TOI.ADJMETHOD,   
ICOVER.INO,   
A2.ANO AS SANO,   
PolicyType.SType   
FROM  RCLASS, RATECOV, RCOVER, PCLASS, ICOVER, TOI, RCalc, COVER Left Join PolicyType on (PolicyType.PolicyType=Cover.PolicyType), ACCEPTANCE A1, ACCEPTANCE A2   
Where A1.PDate <= A2.PDate And A1.PPDate >= A2.PPDate And A2.PDate <= A2.PPDate   
and A1.ANO=@P_ANO and A2.OANO=A1.OANO and A2.ANO<=A1.PANO and A2.ANO<@P_ANO and A2.AType not in ('A','C') and Cover.CNO=A1.CNO   
and ICOVER.ANO=A1.ANO and ICOVER.Adjustable=1   
and RCOVER.ANO=A2.ANO   
and RATECOV.CODE=RCOVER.CODE   
and RCLASS.TOC=COVER.TOC   
and RCLASS.TOR=RATECOV.TOR   
and PCLASS.TOR=RATECOV.TOR   
and PCLASS.TOI=ICOVER.TOI   
and TOI.TOI=ICOVER.TOI   
and RCalc.ANO=A2.ANO and RCalc.Currency=ICover.Currency and RCalc.Code=RCover.Code and RCalc.TOR=RateCov.TOR and RCalc.SDate=RCover.SDate   
and NOT EXISTS (Select PANO from Acceptance A3 Where A3.PANO=A2.ANO and A3.AStatus<>'C' and A3.AType='A' and A3.ANO<>@P_ANO)   
and (TOI.ADJMETHOD<>'OVERLIMIT' or A2.ANO=A1.PANO)   
ORDER BY ICOVER.CURRENCY, RCOVER.CODE, RATECOV.TOR, RCOVER.SDATE, A2.ANO   
go

--4.	Perbaikan pada script pemeriksaan minimum dan maximum rate, dimana Rate didasarkan pada rate sesuai period Term-nya (tidak selalu disetahunkan)

IF EXISTS ( SELECT * FROM   sysobjects WHERE  id = object_id(N'[dbo].[QPolicy_Rate]') and OBJECTPROPERTY(id, N'IsProcedure') = 1 ) BEGIN    DROP PROCEDURE [dbo].[QPolicy_Rate] END 
go
Create Procedure QPolicy_Rate(@P_ANO as int)     
as     
Select ICALC.Code, ICALC.SDate, SUM(ICALC.TSI) as TSI, Max(ICALC.PrevMinRate) as PrevMinRate, Max(ICALC.PrevMaxRate) as PrevMaxRate, Max(ICALC.MinRate) as MinRate, Max(ICALC.MaxRate) as MaxRate     
from     
(     
Select ICALC.Code, ICALC.SDate,     
MAX((Case When ICover.Category='M' then ICALC.TSI else 0 end)*(CASE WHEN RCOVER.PCTLOSS=0 THEN 100 ELSE RCOVER.PCTLOSS END)/(CASE WHEN RCOVER.PCTLOSS=0 THEN 100 ELSE RCOVER.PCTLOSS END+RCOVER.PAddition)) as TSI,     
CAST(0 as FLOAT) as PREVMINRATE,     
CAST(0 as FLOAT) as PREVMAXRATE,     
ROUND(SUM(ICALC.GROSS*100/(100-RCover.Discount)/ICALC.TSI/(Case When RCOVER.LOADING=0 THEN 1 ELSE RCOVER.LOADING END)*Case When ICalc.PCTADJ<>0 Then cast(100 as Float)/ICALC.PCTADJ else 1 end*Case When ICALC.Prorata=1 then (Case When Day(ICALC.SDate)<>Day(ICALC.EDate) then cast(Cover.Prorata as Float)/datediff(day,ICALC.SDate, ICALC.EDate) else cast(case When TOC.PTerm=0 Then 12 else TOC.PTerm end as Float)/datediff(Month, ICALC.SDate, ICALC.EDate) end) else (Case When RCover.PCalc='P' and Cover.Voyage=0 then Case When day(ICalc.SDate)<>day(ICalc.EDate) or Cover.PPeriod=1 then cast(Cover.Prorata as Float)/datediff(day,ICalc.SDate, ICalc.EDate) else cast(case When TOC.PTerm=0 Then 12 else TOC.PTerm end as Float)/datediff(month,ICalc.SDate, ICalc.EDate) end else 1/ICALC.Prorata end) end)*100,13) as MINRATE,     
ROUND(SUM(ICALC.GROSS*100/(100-RCover.Discount)/ICALC.TSI/(Case When RCOVER.LOADING=0 THEN 1 ELSE RCOVER.LOADING END)*Case When ICalc.PCTADJ<>0 Then cast(100 as Float)/ICALC.PCTADJ else 1 end*Case When ICALC.Prorata=1 then (Case When Day(ICALC.SDate)<>Day(ICALC.EDate) then cast(Cover.Prorata as Float)/datediff(day,ICALC.SDate, ICALC.EDate) else cast(case When TOC.PTerm=0 Then 12 else TOC.PTerm end as Float)/datediff(Month, ICALC.SDate, ICALC.EDate) end) else (Case When RCover.PCalc='P' and Cover.Voyage=0 then Case When day(ICalc.SDate)<>day(ICalc.EDate) or Cover.PPeriod=1 then cast(Cover.Prorata as Float)/datediff(day,ICalc.SDate, ICalc.EDate) else cast(case When TOC.PTerm=0 Then 12 else TOC.PTerm end as Float)/datediff(month,ICalc.SDate, ICalc.EDate) end else 1/ICALC.Prorata end) end)*100,13) as MAXRATE     
from COVER, ACCEPTANCE, ICover, ICALC, RCover, TOC
Where ACCEPTANCE.ANO=@P_ANO and COVER.CNO=ACCEPTANCE.CNO and COVER.ISType in ('I','C','L') and RCover.ANO=Acceptance.ANO     
and RCover.ANO=ICALC.ANO and RCover.Code=ICALC.Code and RCover.SDate=ICALC.SDate and RCover.EDate=ICALC.EDate and datediff(month, ICALC.SDate, ICALC.EDate)<>0     
and ICover.INO=ICalc.INO and ICALC.TSI<>0     
and TOC.TOC=Cover.TOC
Group By ICalc.INO, ICALC.Code, ICALC.SDate     
     
Union All     
     
Select ICALC.Code, ICALC.SDate,     
0 as TSI,     
ROUND(SUM(ICALC.GROSS*100/(100-RCover.Discount)/ICALC.TSI/(Case When RCOVER.LOADING=0 THEN 1 ELSE RCOVER.LOADING END)*Case When ICalc.PCTADJ<>0 Then cast(100 as Float)/ICALC.PCTADJ else 1 end*Case When ICALC.Prorata=1 then (Case When Day(ICALC.SDate)<>Day(ICALC.EDate) then cast(Cover.Prorata as Float)/datediff(day,ICALC.SDate, ICALC.EDate) else cast(case When TOC.PTerm=0 Then 12 else TOC.PTerm end as Float)/datediff(Month, ICALC.SDate, ICALC.EDate) end) else (Case When RCover.PCalc='P' and Cover.Voyage=0 then Case When day(ICalc.SDate)<>day(ICalc.EDate) or Cover.PPeriod=1 then cast(Cover.Prorata as Float)/datediff(day,ICalc.SDate, ICalc.EDate) else cast(case When TOC.PTerm=0 Then 12 else TOC.PTerm end as Float)/datediff(month,ICalc.SDate, ICalc.EDate) end else 1/ICALC.Prorata end) end)*100,13) as PREVMINRATE,     
ROUND(SUM(ICALC.GROSS*100/(100-RCover.Discount)/ICALC.TSI/(Case When RCOVER.LOADING=0 THEN 1 ELSE RCOVER.LOADING END)*Case When ICalc.PCTADJ<>0 Then cast(100 as Float)/ICALC.PCTADJ else 1 end*Case When ICALC.Prorata=1 then (Case When Day(ICALC.SDate)<>Day(ICALC.EDate) then cast(Cover.Prorata as Float)/datediff(day,ICALC.SDate, ICALC.EDate) else cast(case When TOC.PTerm=0 Then 12 else TOC.PTerm end as Float)/datediff(Month, ICALC.SDate, ICALC.EDate) end) else (Case When RCover.PCalc='P' and Cover.Voyage=0 then Case When day(ICalc.SDate)<>day(ICalc.EDate) or Cover.PPeriod=1 then cast(Cover.Prorata as Float)/datediff(day,ICalc.SDate, ICalc.EDate) else cast(case When TOC.PTerm=0 Then 12 else TOC.PTerm end as Float)/datediff(month,ICalc.SDate, ICalc.EDate) end else 1/ICALC.Prorata end) end)*100,13) as PREVMAXRATE,     
CAST(0 as FLOAT) as MINRATE,     
CAST(0 as FLOAT) as MAXRATE     
from COVER, ACCEPTANCE, ACCEPTANCE PACCEPTANCE, ICover, ICALC, RCover, TOC
Where ACCEPTANCE.ANO=@P_ANO and COVER.CNO=ACCEPTANCE.CNO and COVER.ISType in ('I','C','L') and PACCEPTANCE.ANO=ACCEPTANCE.PANO and RCOVER.ANO=PACCEPTANCE.ANO     
and RCover.ANO=ICALC.ANO and RCover.Code=ICALC.Code and RCover.SDate=ICALC.SDate and RCover.EDate=ICALC.EDate and datediff(month, ICALC.SDate, ICALC.EDate)<>0     
and ICover.INO=ICalc.INO and ICALC.TSI<>0     
and TOC.TOC=Cover.TOC
Group By ICalc.INO, ICALC.Code, ICALC.SDate     
) ICALC     
Group By ICALC.Code, ICALC.SDate     
Having SUM(ICALC.TSI)<>0     
go

--6.	Koreksi Column SysUserActivity
IF EXISTS(SELECT * FROM sys.columns WHERE Name = N'Last_Activity_Time' AND Object_ID = Object_ID(N'SysUserActivity'))
BEGIN 
alter table SysUserActivity drop column Last_Actvity_Time
END
GO
IF EXISTS(SELECT * FROM sys.columns WHERE Name = N'Last_Activity_Date' AND Object_ID = Object_ID(N'SysUserActivity'))
BEGIN 
alter table SysUserActivity drop column Last_Actvity_Date
END
GO


IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'Last_Activity_Date' AND Object_ID = Object_ID(N'SysUserActivity'))
BEGIN 
alter table SysUserActivity add 
	Last_Activity_Date smalldatetime
END
GO

IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'Last_Activity_Time' AND Object_ID = Object_ID(N'SysUserActivity'))
BEGIN 
alter table SysUserActivity add 
	Last_Activity_Time varchar(5)
END
GO


--1.	Koreksi untuk pengambilan nilai Reinsurance Limit Liability pada sesi Reinsurance (Script dan fungsi Reinsurance_Cession)
IF EXISTS ( SELECT * FROM   sysobjects WHERE  id = object_id(N'[dbo].[Reinsurance_Limit_Liability]') and OBJECTPROPERTY(id, N'IsProcedure') = 1 ) BEGIN    DROP PROCEDURE [dbo].[Reinsurance_Limit_Liability] END 
GO
CREATE Procedure Reinsurance_Limit_Liability(@P_ANO integer, @P_RDate smalldatetime)     
AS     
SELECT  SUM(ICOVER.AMOUNT*ICALC.PCTLOSS/100*PCALC.RATE) AS AMOUNT, Max(ICALC.PML) as PML, Max(ICALC.PCTLOSS) as PCTLOSS     
From ICOVER     
inner join PCALC On (PCalc.ANO=ICover.ANO and PCalc.Currency=ICover.Currency)     
Left Join     
(     
 Select ICalc.INO, Max(ICalc.CURRENCY) as Currency, Max(ICalc.PCTLOSS) as PCTLOSS, Max(RCover.PML) as PML
 from ICalc, RCover     
 Where RCover.Category='M' and RCover.ANO=ICalc.ANO and RCover.Code=ICalc.Code and RCover.SDate=ICalc.SDate and ICalc.ANO=@P_ANO and @P_RDate between ICalc.SDate and ICalc.EDate     
 and Exists (Select max(R.SDATE) from RCover R Where R.ANO=@P_ANO and R.Category='M' and R.Code=RCover.Code and R.SDate=RCover.SDate and @P_RDate between R.SDate and R.EDate having max(R.SDATE)=RCover.SDate)     
 Group By ICalc.INO
) ICalc     
On (ICalc.INO=ICover.INO and ICalc.Currency=ICover.Currency)     
WHERE  ICOVER.ANO=@P_ANO AND ICOVER.CATEGORY='M'     
go 

--7.	Pengembangan fungsi Paid Elimination yang digunakan tidak hanya untuk melakukan eliminasi untuk akun hutang/piutang pengelola peserta ke rekening antar dana tetapi juga digunakan untuk melakukan auto balancing atau eliminasi jika terdapat selisih pembukuan antara akun2 peserta/pengelola yang ditransaksikan, dimana hasil eliminasi adalah ke antar rekening antar dana.

IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'FElimination_Flag' AND Object_ID = Object_ID(N'CLProcess'))
BEGIN 
ALTER TABLE dbo.CLProcess ADD
	FElimination_Flag bit NULL
END
GO

IF NOT EXISTS (SELECT * FROM SYS.EXTENDED_PROPERTIES WHERE [major_id] = OBJECT_ID('CLProcess') AND [name] = N'MS_Description' AND [minor_id] = (SELECT [column_id] FROM SYS.COLUMNS WHERE [name] = 'FElimination_Flag' AND [object_id] = OBJECT_ID('CLProcess')))
BEGIN
DECLARE @v sql_variant 
SET @v = N'End Of Month Fund Balance Elimination Process Flag (0 : No, 1 : Yes)'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'CLProcess', N'COLUMN', N'FElimination_Flag'
end
GO

IF NOT EXISTS(SELECT * FROM sys.default_constraints WHERE object_id = OBJECT_ID('[dbo].[DF_CLProcess_FElimination_Flag]') AND parent_object_id = OBJECT_ID('[dbo].[CLProcess]'))
BEGIN
ALTER TABLE dbo.CLProcess ADD CONSTRAINT
	DF_CLProcess_FElimination_Flag DEFAULT ((0)) FOR FElimination_Flag
END
GO


--Update CLProcess Set FElimination_Flag=0 Where FElimination_Flag is null
--go


update SysTab Set versionNo='20160711 V1.4.6',versionUpdate=getdate()
go