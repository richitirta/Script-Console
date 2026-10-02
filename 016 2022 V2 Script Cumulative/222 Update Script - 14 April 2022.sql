IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'ERSeqNo' AND Object_ID = Object_ID(N'ACCEPTANCE'))
BEGIN
ALTER TABLE dbo.ACCEPTANCE ADD
	ERSeqNo int NULL
DECLARE @v sql_variant 
SET @v = N'Endorsement Restructuring Sequence No'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'ACCEPTANCE', N'COLUMN', N'ERSeqNo'
end
GO



IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'RestructureF' AND Object_ID = Object_ID(N'RCOVER'))
BEGIN
ALTER TABLE dbo.RCOVER ADD
	RestructureF bit NULL
DECLARE @v sql_variant 
SET @v = N'Restructuring Rate (0 : No, 1 : Yes)'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'RCOVER', N'COLUMN', N'RestructureF'
end
GO


IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'RestructureF' AND Object_ID = Object_ID(N'TOP_RATE'))
BEGIN
ALTER TABLE dbo.TOP_RATE ADD
	RestructureF bit NULL
DECLARE @v sql_variant 
SET @v = N'Restructuring Rate (0 : No, 1 : Yes)'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'TOP_RATE', N'COLUMN', N'RestructureF'
end
GO


DROP FUNCTION fn_RateCon
GO
CREATE FUNCTION fn_RateCon(@P_ANO as int,@P_Code as varchar(20),@P_TSI as Float, @P_SDate as smalldatetime)       
RETURNS Table       
AS RETURN (       
Select Top 1 *
From
(
	SELECT Top 1 cast(0 as Bit) as ProgressiveF, RateTab.Code, RateCon.AllowedF, 
	case 
	When RateCon.minPeriod=0 and RateCon.MaxPeriod=0 then RateCon.MinRate 
	Else 
		case 
		When RateTab.SPeriod=1 Then Cover.Prorata/(RateCon.MaxPeriod-RateCon.MinPeriod+1)*RateCon.MinRate
		else Case When TOC.PTerm=0 Then 12 else TOC.PTerm End /(RateCon.MaxPeriod-RateCon.MinPeriod+1)*RateCon.MinRate
		End
	End as MinRate,
	case 
	When RateCon.minPeriod=0 and RateCon.MaxPeriod=0 then RateCon.MaxRate
	Else 
		case 
		When RateTab.SPeriod=1 Then Cover.Prorata/(RateCon.MaxPeriod-RateCon.MinPeriod+1)*RateCon.MaxRate
		else Case When TOC.PTerm=0 Then 12 else TOC.PTerm End/(RateCon.MaxPeriod-RateCon.MinPeriod+1)*RateCon.MaxRate
		End
	End as MaxRate,
	RateCon.PML, RateCon.TExcess, RateTab.RateLoadingF,       
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
	INNER JOIN Acceptance pAcceptance on (pAcceptance.ANO=Acceptance.pANO and Acceptance.EMethod='S')
	INNER JOIN TOC on (TOC.TOC=Acceptance.TOC)
	INNER JOIN AInfo on (AInfo.ANO=Acceptance.ANO)       
	INNER JOIN COVER ON (COVER.CNO=ACCEPTANCE.CNO)       
	INNER JOIN RateTab ON (RateTab.Code=@P_Code) 
	INNER JOIN RateCon on (    
	 RateCon.Code=RateTab.Code 
	 And ((Case When @P_TSI=0 Then 1 Else @P_TSI End)>=RateCon.MinTSI or RateCon.MinTSI=0) and ((Case When @P_TSI=0 Then 1 Else @P_TSI End)<=RateCon.MaxTSI or RateCon.MaxTSI=0)     
	 And RateCon.ALLOWEDF=1
	 And RateCon.ProgressiveF=0
	 And (
	 (
	 RateTab.SPeriod=0 
	 and 
	 (    
		 (
			ceiling(dbo.fn_Premium_Calc_Prorata(@P_SDate, Case When Acceptance.ExclusiveF=0 and Acceptance.STime<Acceptance.ETime Then dateadd(day,1,Acceptance.EDate) else Acceptance.EDate end,Cover.Prorata,12,Case When Cover.PPeriod in (0,1,2) Then 2 Else Cover.PPeriod End)*12)
			-
			Case 
			When Acceptance.EMethod='S' then
				ceiling(dbo.fn_Premium_Calc_Prorata(@P_SDate, Case When pAcceptance.ExclusiveF=0 and pAcceptance.STime<pAcceptance.ETime Then dateadd(day,1,pAcceptance.EDate) else pAcceptance.EDate end,Cover.Prorata,12,Case When Cover.PPeriod in (0,1,2) Then 2 Else Cover.PPeriod End)*12)
			else 0
			end
			>=RateCon.MinPeriod
		 )
	 or RateCon.MinPeriod=0
	 )                               
	 And 
	 (    
		 (
			ceiling(dbo.fn_Premium_Calc_Prorata(@P_SDate, Case When Acceptance.ExclusiveF=0 and Acceptance.STime<Acceptance.ETime Then dateadd(day,1,Acceptance.EDate) else Acceptance.EDate end,Cover.Prorata,12,Case When Cover.PPeriod in (0,1,2) Then 2 Else Cover.PPeriod End)*12)
			-
			Case 
			When Acceptance.EMethod='S' then
				ceiling(dbo.fn_Premium_Calc_Prorata(@P_SDate, Case When pAcceptance.ExclusiveF=0 and pAcceptance.STime<pAcceptance.ETime Then dateadd(day,1,pAcceptance.EDate) else pAcceptance.EDate end,Cover.Prorata,12,Case When Cover.PPeriod in (0,1,2) Then 2 Else Cover.PPeriod End)*12)
			else 0
			end
			<=RateCon.MaxPeriod
		 )     
	 or RateCon.MaxPeriod=0
	 )
	 ) OR
	 (
	 RateTab.SPeriod=1 
	 and 
		(
			(
				datediff(day, @P_SDate, acceptance.edate)
				-
				Case 
				When Acceptance.EMethod='S' then
					datediff(day, @P_SDate, pacceptance.edate)
				else 0
				end
				>=RateCon.MinPeriod
			) 
		or RateCon.MinPeriod=0
		)
	 And 
		(
			(
				datediff(day, @P_SDate, acceptance.edate)
				-
				Case 
				When Acceptance.EMethod='S' then
					datediff(day, @P_SDate, pacceptance.edate)
				else 0
				end
				<=RateCon.MaxPeriod
			) 
		or RateCon.MaxPeriod=0
		)
	 ) 
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
	Cast(Max(Cast(RateCon.AllowedF as Int)) as Bit) as AllowedF, 
	sum(Case When (Case When @P_TSI=0 Then 1 Else @P_TSI End)>=RateCon.MaxTSI Then RateCon.MaxTSI-RateCon.MinTSI+1 Else (Case When @P_TSI=0 Then 1 Else @P_TSI End)-RateCon.MinTSI+1 end*RateCon.MinRate/(Case When @P_TSI=0 Then 1 Else @P_TSI End)) as MinRate,

	sum(Case When (Case When @P_TSI=0 Then 1 Else @P_TSI End)>=RateCon.MaxTSI Then RateCon.MaxTSI-RateCon.MinTSI+1 Else (Case When @P_TSI=0 Then 1 Else @P_TSI End)-RateCon.MinTSI+1 end*RateCon.MaxRate/(Case When @P_TSI=0 Then 1 Else @P_TSI End)) as MaxRate,

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
		Case When (Case When @P_TSI=0 Then 1 Else @P_TSI End)>=RateCon.MaxTSI Then RateCon.MaxTSI-RateCon.MinTSI+1 Else (Case When @P_TSI=0 Then 1 Else @P_TSI End)-RateCon.MinTSI+1 end*RateCon.Rate/10/(Case When @P_TSI=0 Then 1 Else @P_TSI End) 
	else Case When (Case When @P_TSI=0 Then 1 Else @P_TSI End)>=RateCon.MaxTSI Then RateCon.MaxTSI-RateCon.MinTSI+1 Else (Case When @P_TSI=0 Then 1 Else @P_TSI End)-RateCon.MinTSI+1 end*RateCon.Rate/(Case When @P_TSI=0 Then 1 Else @P_TSI End) end 
	)as Rate,
	Max(RateCon.MaxTSI) as MaxTSI,
	Max(RateCon.PCalc) as PCalc
	From Acceptance       
	INNER JOIN Acceptance pAcceptance on (pAcceptance.ANO=Acceptance.pANO and Acceptance.EMethod='S')
	INNER JOIN TOC on (TOC.TOC=Acceptance.TOC)
	INNER JOIN AInfo on (AInfo.ANO=Acceptance.ANO)       
	INNER JOIN COVER ON (COVER.CNO=ACCEPTANCE.CNO)       
	INNER JOIN RateTab ON (RateTab.Code=@P_Code)       
	INNER JOIN RateCon on (    
	 RateCon.Code=RateTab.Code 
	 And ((Case When @P_TSI=0 Then 1 Else @P_TSI End) Between RateCon.MinTSI and RateCon.MaxTSI or RateCon.MaxTSI<=(Case When @P_TSI=0 Then 1 Else @P_TSI End))
	 And RateCon.ALLOWEDF=1
	 And RateCon.ProgressiveF=1
	 And (
	 (
	 RateTab.SPeriod=0 
	 and 
	 (    
		 (
			ceiling(dbo.fn_Premium_Calc_Prorata(@P_SDate, Case When Acceptance.ExclusiveF=0 and Acceptance.STime<Acceptance.ETime Then dateadd(day,1,Acceptance.EDate) else Acceptance.EDate end,Cover.Prorata,12,Case When Cover.PPeriod in (0,1,2) Then 2 Else Cover.PPeriod End)*12)
			-
			Case 
			When Acceptance.EMethod='S' then
				ceiling(dbo.fn_Premium_Calc_Prorata(@P_SDate, Case When pAcceptance.ExclusiveF=0 and pAcceptance.STime<pAcceptance.ETime Then dateadd(day,1,pAcceptance.EDate) else pAcceptance.EDate end,Cover.Prorata,12,Case When Cover.PPeriod in (0,1,2) Then 2 Else Cover.PPeriod End)*12)
			else 0
			end
			>=RateCon.MinPeriod
		 )
	 or RateCon.MinPeriod=0
	 )                               
	 And 
	 (    
		 (
			ceiling(dbo.fn_Premium_Calc_Prorata(@P_SDate, Case When Acceptance.ExclusiveF=0 and Acceptance.STime<Acceptance.ETime Then dateadd(day,1,Acceptance.EDate) else Acceptance.EDate end,Cover.Prorata,12,Case When Cover.PPeriod in (0,1,2) Then 2 Else Cover.PPeriod End)*12)
			-
			Case 
			When Acceptance.EMethod='S' then
				ceiling(dbo.fn_Premium_Calc_Prorata(@P_SDate, Case When pAcceptance.ExclusiveF=0 and pAcceptance.STime<pAcceptance.ETime Then dateadd(day,1,pAcceptance.EDate) else pAcceptance.EDate end,Cover.Prorata,12,Case When Cover.PPeriod in (0,1,2) Then 2 Else Cover.PPeriod End)*12)
			else 0
			end
			<=RateCon.MaxPeriod
		 )     
	 or RateCon.MaxPeriod=0
	 )
	 ) OR
	 (
	 RateTab.SPeriod=1 
	 and 
		(
			(
				datediff(day, @P_SDate, acceptance.edate)
				-
				Case 
				When Acceptance.EMethod='S' then
					datediff(day, @P_SDate, pacceptance.edate)
				else 0
				end
				>=RateCon.MinPeriod
			) 
		or RateCon.MinPeriod=0
		)
	 And 
		(
			(
				datediff(day, @P_SDate, acceptance.edate)
				-
				Case 
				When Acceptance.EMethod='S' then
					datediff(day, @P_SDate, pacceptance.edate)
				else 0
				end
				<=RateCon.MaxPeriod
			) 
		or RateCon.MaxPeriod=0
		)
	 ) 
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

GO

DROP Procedure PCALC01
GO
CREATE Procedure PCALC01(@P_ANO integer)    
As    
SELECT  ACCEPTANCE.TOC,    
  COVER.PPERIOD,    
  COVER.PRORATA,    
  COVER.VOYAGE,    
  CASE WHEN RCOVER.UNIT='L' Then 'C' ELSE RCOVER.UNIT END AS UNIT,    
  RCOVER.CODE,    
  RATECOV.TOR,    
  Case 
  When RCOVER.DISCUNIT='M' THEN
	(RCOVER.DISCOUNT+RCOVER.DISCOUNT_EXT)/10
  When RCOVER.DISCUNIT='F' THEN
	  (RCOVER.DISCOUNT+RCOVER.DISCOUNT_EXT)
	  /
	  (
	  CASE 
	  WHEN RCOVER.UNIT='L' Then 0 
	  WHEN RCOVER.CATEGORY='M' AND ICOVER.CATEGORY='M' THEN RCOVER.RATE
	  ELSE RCOVER.RATE
	  END
	  *
	  CASE
	  WHEN RCOVER.UNIT='C' THEN ICOVER.SI/100
	  WHEN RCOVER.UNIT='M' THEN ICOVER.SI/1000
	  WHEN RCOVER.UNIT='F' THEN 1
	  END
	  )*100
  ELSE
	(RCOVER.DISCOUNT+RCOVER.DISCOUNT_EXT)
  END AS DISCOUNT,
  RCOVER.LOADING*CASE WHEN RCOVER.CATEGORY='M' AND ICOVER.CATEGORY='M' THEN DBO.FN_RATE_LOADING(RCOVER.ANO) ELSE 1 END AS LOADING,
  CASE 
  WHEN RCOVER.UNIT='L' Then 0 
  WHEN RCOVER.CATEGORY='M' AND ICOVER.CATEGORY='M' THEN RCOVER.RATE*RATECOV.PORTION/RCOVER.PORTION
  ELSE RCOVER.RATE*RATECOV.PORTION/RCOVER.PORTION
  END AS RATE,
  RATECOV.PORTION,    
  RCOVER.SDATE,    
  RCOVER.EDATE,    
  RCOVER.PCALC,    
  Case WHEN ICOVER.NOTDECRF=1 OR ICOVER.NOTFLF=1 then 100 else RCOVER.PCTLOSS end as PCTLOSS,    
  Case WHEN ICOVER.NOTDECRF=1 OR ICOVER.NOTFLF=1 then 0 else RCOVER.PADDITION end as PADDITION,    
  CASE WHEN ICOVER.NOTFLF=1 THEN 100 ELSE RCOVER.PPRORATA END AS PPRORATA,
  ICOVER.CURRENCY,    
  ICOVER.SI,    
  ICOVER.INDEMNITY,    
  (Select sum(DDiscount) from AccDed Where ANO=ICover.ANO and (Currency='' or Currency=ICover.Currency) and TOR=RateCov.TOR) as DDISCOUNT,
  ICOVER.Adjustable,    
  ICOVER.PCTADJ,    
  ICOVER.INO,    
  ACCEPTANCE.ANO as SANO,    
  PolicyType.SType
FROM  ACCEPTANCE
INNER JOIN COVER ON (COVER.CNO=ACCEPTANCE.CNO)
Left Join PolicyType on (PolicyType.PolicyType=Cover.PolicyType)
INNER JOIN RCOVER ON (RCOVER.ANO=ACCEPTANCE.ANO)
INNER JOIN ICOVER ON (ICOVER.ANO=ACCEPTANCE.ANO)
INNER JOIN RCLASS ON (RCLASS.TOC=ACCEPTANCE.TOC)
INNER JOIN RATECOV ON (RATECOV.CODE=RCOVER.CODE And RATECOV.TOR=RCLASS.TOR)
INNER JOIN PCLASS ON (PCLASS.TOR=RATECOV.TOR And PCLASS.TOI=ICOVER.TOI)
INNER JOIN TOI ON (TOI.TOI=ICOVER.TOI)
WHERE  ACCEPTANCE.ANO=@P_ANO    
and (ACCEPTANCE.EMethod<>'S' or coalesce(RCover.RestructureF,0)=1)
ORDER BY ICOVER.CURRENCY, RCOVER.CODE, RATECOV.TOR,RCOVER.SDATE, ACCEPTANCE.ANO

GO

DROP Procedure BALANCE_ACCASS
GO
CREATE Procedure BALANCE_ACCASS(@P_ANO integer)                
as                
SELECT A3.LANO, A1.ACNO, A1.BizmapID, A2.AType, A1.Type,A1.ID, A1.Code, A1.MSCode,          
Case When A2.AType='A' then A1.Amount_OC else A1.CAmount end as CAmount,         
A1.Currency_OC, A1.Rate, A1.Currency, A1.TOC, A1.PolicyNo, A1.Remarks, A1.Prorata, A1.SDate, A1.EDate, A1.Date, A1.BillDate, A1.PProrata, A1.DocNo, A1.RefNo, A1.AdjustableF, A1.RCode,  
CASE 
WHEN COALESCE(R1.NOREFUNDF,0)=1 THEN R1.NOREFUNDF 
ELSE COALESCE(R2.NOREFUNDF,COALESCE(COALESCE(A5.NOREFUNDF,COALESCE(A4.NOREFUNDF,A6.NOREFUNDF)),CAST(A1.NOREFUNDF as BIT))) 
END AS NOREFUNDF,        
coalesce(A5.NoProrataF, coalesce(A4.NoProrataF, coalesce(A6.NoProrataF, Cast(0 as Bit)))) as NoProrataF,
Case 
When A3.AType='C' and A3.EMethod<>'A' Then 
	Case When A1.Type in ('DI','IC','IR','BB','BA','BO','BC','BP','BD','OP') Then R1.CPRefund else coalesce(R2.CPRefund,0) end
else
	0
end as CPRefund,

Case 
When A3.AType='C' and A3.EMethod<>'A' Then 
	Case When A1.Type in ('DI','IC','IR','BB','BA','BO','BC','BP','BD','OP') Then R1.CPFormula else '' end
else
	0
end as CPFormula,
A1.ADJMETHOD, A1.Source, A1.CommPoolF
FROM ACCEPTANCE A2
INNER JOIN ACCASS A1 ON (A1.ANO=A2.ANO)         
INNER JOIN ACCEPTANCE A3 ON (A3.PANO=A2.ANO AND A3.AType<>'A')         
Left Join RCover R1 on (R1.ANO=A3.ANO and R1.Code=A1.RCode and ((R1.SDate=A3.SDate and R1.EDate=A3.EDate and A1.SDate=A2.SDate and A1.EDate=A2.EDate) or (R1.SDate=A1.SDate)))
Left Join ACCBS A4 on (A4.ANO=A3.ANO and A4.ID=A1.ID and A4.BSType=substring(A1.Type,2,1))        
Left Join AAccBS A5 on (A5.ANO=A3.ANO and A5.ID=A1.ID and A5.BSType=substring(A1.Type,2,1))       
Left Join ACCBS A6 on (A6.ANO=A3.LANO and A6.ID=A1.ID and A6.BSType=substring(A1.Type,2,1))       
Left Join FPart F on (F.ANO=A3.ANO and F.SlipNo=A1.RefNo and F.ID=A1.ID)      
Left Join RArrDet R2 on (R2.ANO=A3.ANO and R2.FID=F.FID and ((R2.RType='F' and A1.Type in ('FO','FP')) or (R2.RType<>'F' and A1.Type=Case When R2.RType in ('JP') Then 'IC' else R2.RType end)) and R2.Status<>'O')      
WHERE A2.ANO=@P_ANO AND (A1.CAMOUNT<>0 OR A2.AType='A')     
AND A1.DepositF=0
AND Not (

(A1.TYPE in ('DI','OP') AND A1.CODE IN ('F')) or 
(A1.TYPE in ('DI','IC') AND A1.CODE IN ('D')) or
(A1.TYPE in ('CF') AND A1.CODE IN ('F','D') 
and exists (
	Select TOP 1 ACCFD.ANO
	from Coinsurance
    Inner Join ACCFD on (ACCFD.ANO=A2.ANO and ACCFD.ID=Coinsurance.ID)
    Inner join FDTAB on (FDTAB.FDID=ACCFD.FDID AND Left(FDTAB.FDTYPE,1)<>'O')
    Where Coinsurance.CNO=A2.CNO And ACCFD.CONTRIBUTIONF = 1
    and COINSURANCE.DOCNO=A1.REFNO AND COINSURANCE.PCOLLECTIONF=1 AND COINSURANCE.HF=0 AND COINSURANCE.HFAMOUNT=0
	)
)
) 




GO



 insert into PatchVersioning
select '222 Update Script - 14 April 2022',GETDATE()
go


Declare @PrevScript varchar(100)
Declare @CurrScript varchar(100)

Select @PrevScript=''
Select @CurrSCript='222 Update Script - 14 April 2022'


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



	
