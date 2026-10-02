SET QUOTED_IDENTIFIER ON
SET ARITHABORT ON
SET NUMERIC_ROUNDABORT OFF
SET CONCAT_NULL_YIELDS_NULL ON
SET ANSI_NULLS ON
SET ANSI_PADDING ON
SET ANSI_WARNINGS ON


IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'REFID' AND Object_ID = Object_ID(N'dbo.CLAASS'))
BEGIN
ALTER TABLE dbo.CLAASS ADD REFID varchar(10) NULL
DECLARE @v sql_variant 
SET @v = N'Reference Profile ID (see Facultative Security ID)'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'CLAASS', N'COLUMN', N'REFID'
END
GO

IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'REFNAME' AND Object_ID = Object_ID(N'dbo.CLAASS'))
BEGIN
ALTER TABLE dbo.CLAASS ADD REFNAME varchar(255) NULL
DECLARE @v sql_variant 
SET @v = N'Reference Profile Name (see Facultative Security ID)'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'CLAASS', N'COLUMN', N'REFNAME'
END
GO


SET QUOTED_IDENTIFIER ON
SET ARITHABORT ON
SET NUMERIC_ROUNDABORT OFF
SET CONCAT_NULL_YIELDS_NULL ON
SET ANSI_NULLS ON
SET ANSI_PADDING ON
SET ANSI_WARNINGS ON


IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'CLAIMBYSECURITYF' AND Object_ID = Object_ID(N'dbo.FPART'))
BEGIN
ALTER TABLE dbo.FPART ADD CLAIMBYSECURITYF bit NULL
DECLARE @v sql_variant
SET @v = N'Claim Payment By Security (0 : No, 1 : Yes)'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'FPART', N'COLUMN', N'CLAIMBYSECURITYF'
END
GO


IF EXISTS ( SELECT * FROM   sysobjects WHERE  id = object_id(N'QFacultative_Data') and OBJECTPROPERTY(id, N'IsProcedure') = 1 )
BEGIN DROP PROCEDURE QFacultative_Data END
GO

CREATE Procedure QFacultative_Data(@P_ANO integer, @P_FID varchar(20))                    
AS                                  
SELECT R.FID, R.AType, F.SLIPNO, F.DocNo, R.SDATE, R.EDATE, R.RTYPE, F.ID, R.SHARE, F.Share as RShare, R.FLPCT, R.AMOUNT, R.LIMIT, R.EXCESS, R.RETENTION, R.UJROHREINS, R.UJROHCEDANT,                    
R.UserID, R.CDate,                  
R.LUserID, R.LDate,                  
R.AUserID, R.AUserDate,            
R.AcceptedBy, R.AcceptedDate,    
R.SysUserID,         
R.CurrencyL, R.RateL, R.ClaimCOOP, R.PrecedeFacCessionF, R.NoRefundF, R.NotApplyDiscountCFF,
F.Code, F.COMM, F.OCOMM, F.ACQCOST, F.NETRATE, F.Currency, F.Unit, R.PCALC, R.CPCT, R.Memo, F.REMARKS, F.WPC, F.BinderNo, F.BinderWarranty, R.FULLCOVERF, R.ORIGINALF, R.OnGrossAfterCommF, R.OnNetRateF, R.CPRefund, F.PERIOD, F.INSTALLMENT,       
F.GRACE, R.JPSLIPNO, R.JPSHARE, R.JPCOMM, F.CPDays, 
F.CommAmount, F.OCommAmount, F.ProfitSharing, F.Discount, F.DiscAmount, F.BRID, F.BRComm, F.CLAIMBYSECURITYF,
F.IDATE_1, F.IPCT_1,                    
F.IDATE_2, F.IPCT_2,                    
F.IDATE_3, F.IPCT_3,                    
F.IDATE_4, F.IPCT_4,                    
F.IDATE_5, F.IPCT_5,                    
F.IDATE_6, F.IPCT_6,                    
F.IDATE_7, F.IPCT_7,                    
F.IDATE_8, F.IPCT_8,                    
F.IDATE_9, F.IPCT_9,                    
F.IDATE_10, F.IPCT_10,                    
F.IDATE_11, F.IPCT_11,                    
F.IDATE_12 , F.IPCT_12,      
F.IDATE_13 , F.IPCT_13,                    
F.IDATE_14 , F.IPCT_14,                    
F.IDATE_15 , F.IPCT_15,                    
F.IDATE_16 , F.IPCT_16,                    
F.IDATE_17 , F.IPCT_17,                    
F.IDATE_18 , F.IPCT_18,                    
F.IDATE_19 , F.IPCT_19,                    
F.IDATE_20 , F.IPCT_20,                    
F.IDATE_21 , F.IPCT_21,                    
F.IDATE_22 , F.IPCT_22,                    
F.IDATE_23 , F.IPCT_23,                    
F.IDATE_24 , F.IPCT_24      
FROM RARRDET R
INNER JOIN FPART F on (F.ANO=R.ANO AND F.FID=R.FID)
WHERE R.ANO=@P_ANO AND R.FID=@P_FID

GO

IF EXISTS ( SELECT * FROM   sysobjects WHERE  id = object_id(N'QCLAIMFACOUT') and OBJECTPROPERTY(id, N'IsProcedure') = 1 )
BEGIN DROP PROCEDURE QCLAIMFACOUT END
GO

CREATE Procedure QCLAIMFACOUT(@P_CNO integer,@P_SecurityF Bit=0)                    
as                    
SELECT Distinct RArrDet.FID, RArrDet.FLPct, RArrDet.Status, RArrDet.AType, RArrDet.RType, RArrDet.SDate, RArrDet.EDate, FPart.CPDays,
(Case When RArrDet.Limit<>0 Then (RArrDet.Limit*RArrDet.RateL)/RArrHeader.TAmount*100*(RArrDet.Share-RArrDet.JPShare)/100 else (RArrDet.Share-RArrDet.JPShare) end) as Share, 
(Case When RArrDet.Limit<>0 Then (RArrDet.Limit*RArrDet.RateL)/RArrHeader.TAmount*100*(RArrDet.JPShare)/100 else (RArrDet.JPShare) end) as JPShare, 
RArrDet.Amount*RArrDet.RateL as Amount, 
RArrDet.Limit*RArrDet.RateL as Limit, 
RArrDet.Excess*RArrDet.RateL as Excess, 
RArrDet.Retention*RArrDet.RateL as Retention, 
Profile.ID, Profile.Name, SProfile.ID as RefID, sProfile.Name as RefName,
FPart.SlipNo, RArrDet.JPSLIPNO, FPart.Share*coalesce(FSecurity.Share,100)/100 AS RShare, RArrDet.FullCoverF, RArrDet.OriginalF, Cast(FPart.Remarks as varchar(512)) as Remarks, 
RArrDet.ClaimCoop*RArrDet.RateL as ClaimCoop, 
RArrHeader.TAmount,
Case When RArrDet.Excess<>0 or RArrDet.Limit<>0 Then   
 Case When CArrHeader.ETAmount>RArrDet.Excess*RArrDet.RateL Then 
	Case When CArrHeader.ETAmount>(RArrDet.Excess+RArrDet.Limit)*RArrDet.RateL Then
		(RArrDet.Limit*RArrDet.RateL)*(RArrDet.Share)/100*FPart.Share/100
	Else	
		(CArrHeader.ETAmount-RArrDet.Excess*RArrDet.RateL) *(RArrDet.Share)/100*FPart.Share/100
	End
 Else	
	0
 End
Else
	Case 
	When CArrHeader.ETAmount*(RArrDet.Share)/100*FPart.Share/100>RArrDet.Retention*RArrDet.RateL or RArrDet.Retention=0 then
		CArrHeader.ETAmount*(RArrDet.Share)/100*FPart.Share/100-RArrDet.Retention*RArrDet.RateL
	else
		0
	end
End*(RArrDet.Share-RArrDet.JPShare)/RArrDet.Share
as Estimate,

Case When RArrDet.Excess<>0 or RArrDet.Limit<>0 Then   
 Case When CArrHeader.TAmount>RArrDet.Excess*RArrDet.RateL Then 
	Case When CArrHeader.TAmount>(RArrDet.Excess+RArrDet.Limit)*RArrDet.RateL Then
		(RArrDet.Limit*RArrDet.RateL)*(RArrDet.Share)/100*FPart.Share/100
	Else	
		(CArrHeader.TAmount-RArrDet.Excess*RArrDet.RateL) *(RArrDet.Share)/100*FPart.Share/100
	End
 Else	
	0
 End
Else
	Case
	When CArrHeader.TAmount*(RArrDet.Share)/100*FPart.Share/100>RArrDet.Retention*RArrDet.RateL or RArrDet.Retention=0 then
		CArrHeader.TAmount*(RArrDet.Share)/100*FPart.Share/100-RArrDet.Retention*RArrDet.RateL
	else
		0
	end
End*(RArrDet.Share-RArrDet.JPShare)/RArrDet.Share
as Claim,

Case When RArrDet.ClaimCoop>0 and (RArrDet.ClaimCoop*RArrDet.RateL<=CArrHeader.ETAmount*(Case When RArrDet.Limit<>0 Then (RArrDet.Limit)/RArrHeader.TAmount*(RArrDet.Share)/100 else (RArrDet.Share)/100 end)*FPart.Share/100) Then Cast(1 as Bit) else Cast(0 as Bit) end as ClaimCoopF        
From Claim
Inner Join CArrHeader on (CArrHeader.CNO=Claim.CNO)
Inner Join Acceptance on (Acceptance.ANO=Claim.ANO)
Inner Join RArrHeader on (RArrHeader.ANO=Claim.ANO)
Inner Join RArrDet on (RArrDet.ANO=Claim.ANO)
INner Join FPart on (FPart.ANO=RArrDet.ANO and FPart.FID=RArrDet.FID)
Left Join FSecurity on (@P_SecurityF=1 and FPart.ClaimBySecurityF=1 and FSecurity.ANO=FPart.ANO and FSecurity.FID=FPart.FID)
Inner Join Profile on (Profile.ID=FPart.ID)
Left Join Profile sProfile on (sProfile.ID=FSecurity.ID)
WHERE Claim.CNO=@P_CNO 
AND ((RARRDET.SDATE<=CLAIM.LOSSDATE AND ACCEPTANCE.ExclusiveF=1) or ((RARRDET.SDATE<CLAIM.LOSSDATE or (RARRDET.SDATE=CLAIM.LOSSDATE AND ACCEPTANCE.STIME<=Claim.LossTime)) AND ACCEPTANCE.ExclusiveF=0))                   
AND ((dbo.fn_Get_ExtPeriodDate(ACCEPTANCE.ExtRPeriod, 0, dbo.fn_Get_ExtPeriodDate(ACCEPTANCE.ExtPeriod, ACCEPTANCE.ExtPeriodInDaysF, RARRDET.EDATE))>CLAIM.LOSSDATE AND ACCEPTANCE.ExclusiveF=1) or ((dbo.fn_Get_ExtPeriodDate(ACCEPTANCE.ExtRPeriod, 0, dbo.fn_Get_ExtPeriodDate(ACCEPTANCE.ExtPeriod, ACCEPTANCE.ExtPeriodInDaysF, RARRDET.EDATE))>CLAIM.LOSSDATE or (dbo.fn_Get_ExtPeriodDate(ACCEPTANCE.ExtRPeriod, 0, dbo.fn_Get_ExtPeriodDate(ACCEPTANCE.ExtPeriod, ACCEPTANCE.ExtPeriodInDaysF, RARRDET.EDATE))=CLAIM.LOSSDATE AND ACCEPTANCE.ETIME>Claim.LossTime)) AND ACCEPTANCE.ExclusiveF=0))                  
AND RArrDet.FullCoverF=1               
AND (FPart.Code='' or EXISTS (Select Top 1 RateCov.Code from COL Inner Join RateCov on (RateCov.Code=FPart.Code AND RateCov.TOR=COL.TOR) Where COL.COL=Claim.COL))  
AND RArrDet.Status='A'           
                          
Union All                    
                          
SELECT Distinct RArrDet.FID, RArrDet.FLPct, RArrDet.Status, RArrDet.AType, RArrDet.RType, RArrDet.SDate, RArrDet.EDate, FPart.CPDays,
(Case When RArrDet.Limit<>0 Then (RArrDet.Limit*RArrDet.RateL)/RArrHeader.TAmount*100*(RArrDet.Share-RArrDet.JPShare)/100 else (RArrDet.Share-RArrDet.JPShare) end)*(CASE WHEN CCALC.LOSS<>0 THEN LCALC.LOSS/CCALC.LOSS WHEN CCALC.INDEMNITY<>0 THEN LCALC.INDEMNITY/CCALC.INDEMNITY ELSE 0 END) as Share, 
(Case When RArrDet.Limit<>0 Then (RArrDet.Limit*RArrDet.RateL)/RArrHeader.TAmount*100*(RArrDet.JPShare)/100 else (RArrDet.JPShare) end)*(CASE WHEN CCALC.LOSS<>0 THEN LCALC.LOSS/CCALC.LOSS WHEN CCALC.INDEMNITY<>0 THEN LCALC.INDEMNITY/CCALC.INDEMNITY ELSE 0 END) as JPShare, 
RArrDet.Amount*RArrDet.RateL as Amount, 
RArrDet.Limit*RArrDet.RateL as Limit, 
RArrDet.Excess*RArrDet.RateL as Excess, 
RArrDet.Retention*RArrDet.RateL as Retention, 
Profile.ID, Profile.Name, SProfile.ID as RefID, sProfile.Name as RefName,
FPart.SlipNo, RArrDet.JPSLIPNO, FPart.Share*coalesce(FSecurity.Share,100)/100 AS RShare, RArrDet.FullCoverF, RArrDet.OriginalF, Cast(FPart.Remarks as varchar(512)) as Remarks, 
RArrDet.ClaimCoop*RArrDet.RateL as ClaimCoop, 
RArrHeader.TAmount,

Case When RArrDet.Excess<>0 or RArrDet.Limit<>0 Then   
 Case When CArrHeader.ETAmount*(CASE WHEN CCALC.LOSS<>0 THEN LCALC.LOSS/CCALC.LOSS ELSE 0 END)>RArrDet.Excess*RArrDet.RateL Then 
	Case When CArrHeader.ETAmount*(CASE WHEN CCALC.LOSS<>0 THEN LCALC.LOSS/CCALC.LOSS ELSE 0 END)>(RArrDet.Excess+RArrDet.Limit)*RArrDet.RateL Then
		(RArrDet.Limit*RArrDet.RateL)*(RArrDet.Share)/100*FPart.Share/100
	Else	
		(CArrHeader.ETAmount*(CASE WHEN CCALC.LOSS<>0 THEN LCALC.LOSS/CCALC.LOSS ELSE 0 END)-RArrDet.Excess*RArrDet.RateL)*(RArrDet.Share)/100*FPart.Share/100
	End
 Else	
	0
 End
Else
	Case 
	When CArrHeader.ETAmount*(CASE WHEN CCALC.LOSS<>0 THEN LCALC.LOSS/CCALC.LOSS ELSE 0 END)*(RArrDet.Share)/100*FPart.Share/100>RArrDet.Retention*RArrDet.RateL or RArrDet.Retention=0 then
		CArrHeader.ETAmount*(CASE WHEN CCALC.LOSS<>0 THEN LCALC.LOSS/CCALC.LOSS ELSE 0 END)*(RArrDet.Share)/100*FPart.Share/100-RArrDet.Retention*RArrDet.RateL
	else
		0
	end
End*(RArrDet.Share-RArrDet.JPShare)/RArrDet.Share
as Estimate,

Case When RArrDet.Excess<>0 or RArrDet.Limit<>0 Then   
 Case When CArrHeader.TAmount*(CASE WHEN CCALC.INDEMNITY<>0 THEN LCALC.Indemnity/CCALC.INDEMNITY ELSE 0 END)>RArrDet.Excess*RArrDet.RateL Then 
	Case When CArrHeader.TAmount*(CASE WHEN CCALC.INDEMNITY<>0 THEN LCALC.Indemnity/CCALC.INDEMNITY ELSE 0 END)>(RArrDet.Excess+RArrDet.Limit)*RArrDet.RateL Then
		(RArrDet.Limit*RArrDet.RateL)*(RArrDet.Share)/100*FPart.Share/100
	Else	
		(CArrHeader.TAmount*(CASE WHEN CCALC.INDEMNITY<>0 THEN LCALC.Indemnity/CCALC.INDEMNITY ELSE 0 END)-RArrDet.Excess*RArrDet.RateL)*(RArrDet.Share)/100*FPart.Share/100
	End
 Else	
	0
 End
Else
	Case 
	When CArrHeader.TAmount*(CASE WHEN CCALC.INDEMNITY<>0 THEN LCALC.Indemnity/CCALC.INDEMNITY ELSE 0 END)*(RArrDet.Share)/100*FPart.Share/100>RArrDet.Retention*RArrDet.RateL or RArrDet.Retention=0 then
		CArrHeader.TAmount*(CASE WHEN CCALC.INDEMNITY<>0 THEN LCALC.Indemnity/CCALC.INDEMNITY ELSE 0 END)*(RArrDet.Share)/100*FPart.Share/100-RArrDet.Retention*RArrDet.RateL
	else
		0
	end	
End*(RArrDet.Share-RArrDet.JPShare)/RArrDet.Share
as Claim,

Case When RArrDet.ClaimCoop>0 and (RArrDet.ClaimCoop*RArrDet.RateL<=CArrHeader.ETAmount*(CASE WHEN CCALC.LOSS<>0 THEN LCALC.LOSS/CCALC.LOSS ELSE 0 END)*(Case When RArrDet.Limit<>0 Then (RArrDet.Limit)/RArrHeader.TAmount*(RArrDet.Share)/100 else (RArrDet.Share)/100 end)*FPart.Share/100) Then Cast(1 as Bit) else Cast(0 as Bit) end as ClaimCoopF        
From Claim
Inner Join COL on (COL.COL=Claim.COL)
Inner Join CArrHeader on (CarrHeader.CNO=Claim.CNO)
Inner Join Acceptance on (Acceptance.ANO=Claim.ANO)
Inner Join RArrHeader on (RArrHeader.ANO=Claim.ANO)
Inner Join RArrDet on (RArrDet.ANO=Claim.ANO)
Inner Join FPart on (FPart.ANO=RArrDet.ANO and FPart.FID=RArrDet.FID)
Left Join FSecurity on (@P_SecurityF=1 and FPart.ClaimBySecurityF=1 and FSecurity.ANO=FPart.ANO and FSecurity.FID=FPart.FID)
Inner Join FPartDet on (FPartDet.ANO=RArrDet.ANO AND FPartDet.FID=RArrDet.FID AND FPartDet.ID=FPart.ID)
Inner Join RateCov on (RateCov.Code=FPartDet.Code AND RateCov.TOR=COL.TOR)
Inner Join Profile on (Profile.ID=FPart.ID)
Left Join Profile sProfile on (sProfile.ID=FSecurity.ID)
Cross Apply
(
	SELECT L.CNO, L.TOR, SUM((L.LOSS-L.EDEDUCTIBLE-L.ESALVAGE)*C.RATE) AS LOSS, SUM((L.INDEMNITY-L.DEDUCTIBLE-L.SALVAGE)*C.RATE) AS INDEMNITY
	FROM CCALC C 
	Inner Join LCALC L on (L.CNO=C.CNO and L.Currency=C.Currency)
	WHERE L.CNO=Claim.CNO AND L.TOR=COL.TOR
	GROUP BY L.CNO, L.TOR
) LCALC 
Cross Apply
(
	SELECT C.CNO, SUM((C.LOSS-C.EDEDUCTIBLE-C.ESALVAGE)*C.RATE) AS LOSS, SUM((C.CLAIM-C.DEDUCTIBLE-C.SALVAGE)*C.RATE) AS INDEMNITY
	FROM CCALC C
	WHERE C.CNO=Claim.CNO
	GROUP BY C.CNO
) CCALC 
WHERE Claim.CNO=@P_CNO 
AND ((RARRDET.SDATE<=CLAIM.LOSSDATE AND ACCEPTANCE.ExclusiveF=1) or ((RARRDET.SDATE<CLAIM.LOSSDATE or (RARRDET.SDATE=CLAIM.LOSSDATE AND ACCEPTANCE.STIME<=Claim.LossTime)) AND ACCEPTANCE.ExclusiveF=0))                   
AND ((dbo.fn_Get_ExtPeriodDate(ACCEPTANCE.ExtRPeriod, 0, dbo.fn_Get_ExtPeriodDate(ACCEPTANCE.ExtPeriod, ACCEPTANCE.ExtPeriodInDaysF, RARRDET.EDATE))>CLAIM.LOSSDATE AND ACCEPTANCE.ExclusiveF=1) or ((dbo.fn_Get_ExtPeriodDate(ACCEPTANCE.ExtRPeriod, 0, dbo.fn_Get_ExtPeriodDate(ACCEPTANCE.ExtPeriod, ACCEPTANCE.ExtPeriodInDaysF, RARRDET.EDATE))>CLAIM.LOSSDATE or (dbo.fn_Get_ExtPeriodDate(ACCEPTANCE.ExtRPeriod, 0, dbo.fn_Get_ExtPeriodDate(ACCEPTANCE.ExtPeriod, ACCEPTANCE.ExtPeriodInDaysF, RARRDET.EDATE))=CLAIM.LOSSDATE AND ACCEPTANCE.ETIME>Claim.LossTime)) AND ACCEPTANCE.ExclusiveF=0))                  
AND RArrDet.FullCoverF=0                    
AND RArrDet.Status='A'     

GO

IF EXISTS ( SELECT * FROM   sysobjects WHERE  id = object_id(N'QClaim_To_Adm') and OBJECTPROPERTY(id, N'IsProcedure') = 1 )
BEGIN DROP PROCEDURE QClaim_To_Adm END
GO

CREATE Procedure QClaim_To_Adm(@P_CNO as int)                              
as   
Select C1.ID, C1.TOC, C1.Type, C1.Currency, C1.RefNo, C1.RefID, C1.RefName,
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


insert into PatchVersioning
select '1391 Update Script - 29 July 2025 (1)',GETDATE()
go	
  
Declare @PrevScript varchar(100)
Declare @CurrScript varchar(100)

Select @PrevScript=''
Select @CurrSCript='1391 Update Script - 29 July 2025 (1)'


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

GO

