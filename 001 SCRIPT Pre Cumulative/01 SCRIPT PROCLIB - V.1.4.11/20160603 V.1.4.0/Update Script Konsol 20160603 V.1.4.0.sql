--Update 27 May 2016
IF EXISTS ( SELECT * FROM   sysobjects WHERE  id = object_id(N'[dbo].[QPCALC_ACCASS]') and OBJECTPROPERTY(id, N'IsProcedure') = 1 ) BEGIN    DROP PROCEDURE [dbo].[QPCALC_ACCASS] END 
IF EXISTS ( SELECT * FROM   sysobjects WHERE  id = object_id(N'[dbo].[BALANCE_ACCASS_ADJUSTMENT]') and OBJECTPROPERTY(id, N'IsProcedure') = 1 ) BEGIN    DROP PROCEDURE [dbo].[BALANCE_ACCASS_ADJUSTMENT] END 
go

CREATE Procedure QPCALC_ACCASS (@P_ANO integer)   
AS   
SELECT ICALC.CURRENCY, ICALC.CODE, ICALC.SDATE, ICALC.EDATE, (Case When A1.AType='A' Then 0 else ICover.Adjustable end) as AdjustableF, ICALC.SANO, A2.LANO,   
Cast(Max(cast(RCover.NoRefundF as Integer)) as Bit) as NoRefundF,   
Max(Case When ICover.Adjustable=1 Then TOI.AdjMethod else '' end) as AdjMethod,   
AVG(ICALC.PRORATA) AS PPRORATA, Max(Case When ISource.Share is null then 100 else ISource.Share end) AS SHARE,   
SUM(Case When PCALC.Description<>'' and PCALC.Description<>'Minimum Premium' then ICALC.GROSS*PCALC.GROSS/PCALC.OGROSS else ICALC.GROSS*RCALC.GROSS/RCALC.OGROSS end) AS GROSS,   
CAST(MAX(Case When Upper(PCALC.DESCRIPTION) in ('MINIMUM PREMIUM','POLICY MINIMUM PREMIUM') Then 1 else 0 end) as Bit) as MinimumPremiumF,   
SUM(ICALC.REINSTATEMENT) AS REINSTATEMENT,   
SUM(ICALC.DISCOUNT) AS DISCOUNT,   
MAX(R.TAmount*100/R.PCTSHARE) as TSI,      --100% Sum Insured for Reinsurance Rate   
MAX(PCALC.Rate) As Rate   
FROM ICover   
inner join ICALC on (ICALC.INO=ICOVER.INO and ICALC.ANO=ICOVER.ANO)   
inner join TOI on (TOI.TOI=ICOVER.TOI)   
inner join RCALC on (ICALC.ANO=RCALC.ANO AND ICALC.CURRENCY=RCALC.CURRENCY AND ICALC.CODE=RCALC.CODE AND ICALC.TOR=RCALC.TOR AND ICALC.SDATE=RCALC.SDATE AND ICALC.EDATE=RCALC.EDATE AND ICALC.SANO=RCALC.SANO)   
inner join PCALC on (PCALC.ANO=ICALC.ANO AND PCALC.CURRENCY=ICALC.CURRENCY)   
Left join RCover on (RCover.ANO=RCalc.ANO and RCover.Code=RCalc.Code and RCover.SDate=RCalc.SDate)   
inner join ACCEPTANCE A1 On (A1.ANO=ICALC.ANO)   
inner join ACCEPTANCE A2 on (A2.ANO=ICALC.SANO)   
Inner Join RArrHeader R on (R.ANO=ICalc.ANO)   
left join ISource on (ISource.CNO=A2.CNO)   
WHERE ICover.ANO=@P_ANO and ICALC.GROSS<>0 AND ICALC.SDATE<>ICALC.EDATE
GROUP BY ICALC.CURRENCY, ICALC.CODE, ICALC.SDATE, ICALC.EDATE, (Case When A1.AType='A' Then 0 else ICover.Adjustable end), ICalc.SANO, A2.LANO   
   

GO

CREATE Procedure BALANCE_ACCASS_ADJUSTMENT(@P_ANO integer)   
as   
Select AccAss.*, A2.PDate, A2.PPDate   
From Acceptance A1   
inner join Acceptance A2 on (A2.OANO=A1.OANO)   
inner join AccAss on (AccAss.ANO=A2.ANO)   
Left join Acceptance pA1  on (pA1.ANO=A2.pANO)   
Where A1.ANO=@P_ANO and A2.ANO<A1.ANO   
and 
(   
	(
	A2.ANO<=A1.PANO and A1.PDate<=A2.PDate and A1.PPDate>=A2.PPDate and A1.AType='A' and (A2.AType<>'A' and coalesce(pA1.AType,'')<>'A') 
	and AccAss.AdjustableF=1 and AccAss.AdjMethod<>'OVERLIMIT'
	and NOT EXISTS (Select PANO from Acceptance A3 Where A3.PANO=A2.ANO and A3.Astatus<>'C' and A3.AType='A' and A3.ANO<>@P_ANO)
	)   
	or 
	(
	A2.ANO<=A1.PANO and A1.PDate<=A2.PDate and A1.PPDate>=A2.PPDate and A1.AType='A' and (A2.AType<>'A' and coalesce(pA1.AType,'')<>'A') 
	and AccAss.AdjustableF=1 and AccAss.AdjMethod='OVERLIMIT' and A2.PDATE<>A2.PPDATE and AccAss.CAmount<>0
	and NOT EXISTS (Select PANO from Acceptance A3 Where A3.PANO=A2.ANO and A3.Astatus<>'C' and A3.AType='A' and A3.ANO<>@P_ANO)
	)   
	or 	
	(
	A1.AType='C' and A1.EMethod='A' and A2.PDate>=A1.PDate and (coalesce(pA1.pDate,A2.PDate)>=A1.PDate or A2.ATYPE='A' or (coalesce(pA1.pDate,A2.PDate)<A1.PDate and AccAss.CAmount<>0))
	)   
)   
GO

-- Update 31 May 2016
IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'ExpDate' AND Object_ID = Object_ID(N'PAYOR'))
BEGIN
	ALTER TABLE dbo.PAYOR ADD ExpDate smalldatetime NULL
END
GO

-- Update 1 jan 2016
IF EXISTS(SELECT * FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS WHERE TABLE_NAME='SysUserTOCBranch' AND CONSTRAINT_NAME='FK_SysUserTOCBranch_SysUserTOC')
BEGIN       
	alter table SysUserTOCBranch drop constraint FK_SysUserTOCBranch_SysUserTOC
END
GO
ALTER TABLE dbo.SysUserTOCBranch WITH NOCHECK ADD CONSTRAINT
	FK_SysUserTOCBranch_SysUserTOC FOREIGN KEY
	(
	ID,
	TOC,
	EFFECTIVE
	) REFERENCES dbo.SysUserTOC
	(
	ID,
	TOC,
	EFFECTIVE
	) ON UPDATE  CASCADE 
	 ON DELETE  CASCADE 
	
GO

update SysTab Set versionNo='20160603 V1.4.0',versionUpdate=getdate()
go