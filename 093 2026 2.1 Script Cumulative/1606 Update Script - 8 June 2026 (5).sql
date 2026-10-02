DROP FUNCTION PREMIUM_CANCELLATION_SIMULATION
GO
CREATE FUNCTION PREMIUM_CANCELLATION_SIMULATION(@P_ANO int, @PDate as smalldatetime, @CPCT as Float)

RETURNS @PCALC TABLE (Currency varchar(10), Code varchar(10), SDate SmallDatetime, EDate SmallDatetime, Premium Float, Discount Float)
AS
BEGIN

Declare @NoRefundF as int
Declare @AType as varchar(1)
Declare @RefundType as varchar(100)
Declare @CPFORMULA as varchar(100)
Declare @SDate as smalldatetime

Select @NoRefundF=0
Select @AType='C'
Select @RefundType=''
Select @CPFormula=''


Select @SDate=A2.SDate 
from Acceptance A1, Acceptance A2 
Where A1.ANO=@P_ANO and A2.OANO=A1.OANO and A2.AStatus='I' and A2.AType in ('N','E')

insert into @PCalc
Select Currency, Code, SDate, EDate, sum(Premium) as Premium, sum(Premium*dbo.Premium_Discount(@P_ANO,Code,PolicyYear)/100) as Discount
 from (                  
  select RCalc.Currency, RCalc.Code, RCalc.SDate, RCalc.Edate, cast(datediff(Month,pAcceptance.SDate, RCalc.SDate) as integer) / 12 + 1  as PolicyYear,
  -case     
  When @AType<>'N' and @NoRefundF<>12 and not (@NoRefundF=13 and charindex((case when Cover.ISType in ('I','L') Then 'DI' else 'I'+Cover.ISType end),@RefundType)<>0) and (@NoRefundF in (2,4) or (@NoRefundF in (1) and DateDiff(day, @PDate, RCalc.SDate) <= 0)) Then 0
  when DateDiff(day, rcalc.Edate, @PDate)>=0 and @PDate between pAcceptance.SDate and pacceptance.edate then 0                  
  when DateDiff(day, @PDate, rcalc.SDate)>0 and @PDate between pAcceptance.SDate and pacceptance.edate then 1                  
  Else                  
   case                  
   when @CPCT<>0 or Cover.Voyage=1 then                  
    case                  
    when @CPCT<>0 then                  
		@CPCT/100                  
    Else                  
		1                  
    End                  
   Else                  
    case                  
    When @SDate<>@PDate or @NoRefundF=6 then                  
		--Prorata Calculation
		Case When pAcceptance.EXCLUSIVEF=0 and pAcceptance.STime<pAcceptance.ETime and RCalc.EDate=pAcceptance.EDate Then
			CASE WHEN @CPFORMULA='PRORATE SQ' and @AType='C' THEN
				POWER(dbo.fn_calc_prorata(dbo.fn_Get_Effective_Cancellation_By_Payor_Schedule(@P_ANO, @PDate,dateadd(day,1,RCalc.edate)), dateadd(day,1,RCalc.edate), RCalc.Sdate, dateadd(day,1,RCalc.edate), Cover.PPeriod), 2)
			ELSE
				CASE WHEN @AType='C' THEN
					dbo.fn_calc_prorata(dbo.fn_Get_Effective_Cancellation_By_Payor_Schedule(@P_ANO, @PDate,dateadd(day,1,RCalc.edate)), dateadd(day,1,RCalc.edate), RCalc.Sdate, dateadd(day,1,RCalc.edate), Cover.PPeriod)
				Else
					dbo.fn_calc_prorata(@PDate, dateadd(day,1,RCalc.edate), RCalc.Sdate, dateadd(day,1,RCalc.edate), Cover.PPeriod)
				End
			END			
		else
			CASE WHEN @CPFORMULA='PRORATE SQ' and @AType='C'  THEN
				POWER(dbo.fn_calc_prorata(dbo.fn_Get_Effective_Cancellation_By_Payor_Schedule(@P_ANO, @PDate,RCalc.Edate), RCalc.Edate, RCalc.Sdate, RCalc.EDate, Cover.PPeriod), 2)
			ELSE
				CASE WHEN @AType='C'  THEN
					dbo.fn_calc_prorata(dbo.fn_Get_Effective_Cancellation_By_Payor_Schedule(@P_ANO, @PDate,RCalc.Edate), RCalc.Edate, RCalc.Sdate, RCalc.EDate, Cover.PPeriod)
				Else
					dbo.fn_calc_prorata(@PDate, RCalc.Edate, RCalc.Sdate, RCalc.EDate, Cover.PPeriod)
				End
			END			
		End
    Else                  
    -- Endorsement Period                  
		1                  
    End                  
   End                  
  End                  
  * (Case When pAcceptance.Qty=0 Then 1 else pAcceptance.Qty end)                  
  * (Case When PCALC.DESCRIPTION='Minimum Premium' Then RCALC.GROSS else (Case When PCALC.OGROSS<>0 THEN RCALC.OGROSS*PCALC.GROSS/PCALC.OGROSS ELSE PCALC.GROSS END) END+RCalc.Reinstatement)
  * coalesce(case When ISource.Limit<>0 then ISource.Limit/(ISource.Limit+ISource.Excess) else 1 end*ISource.Share/100,1) 
  as Premium      
  from Acceptance pAcceptance 
  inner Join Cover on (Cover.CNO=pAcceptance.CNO)          
  inner join PCalc on (PCalc.ANO=pAcceptance.ANO) 
  inner join RCalc on (RCalc.ANO=PCalc.ANO and RCalc.Currency=PCalc.Currency)                  
  Left Join AISource ISource on (ISource.ANO=pAcceptance.ANO)
  Where pAcceptance.ANO=@P_ANO and @AType<>'A' 
  and PCalc.Gross<>0                                            
) T                  
Group By Currency, Code, SDate, EDate

RETURN

END

GO

DROP PROCEDURE QClaimShare 
GO
CREATE PROCEDURE QClaimShare (@P_CNO as integer)
AS
SELECT ISource.Share AS ISShare
FROM CLAIM
Inner join Acceptance on (Acceptance.ANO=Claim.ANO)
Inner join AISource ISource on (ISource.ANO=Acceptance.ANO)
Where Claim.CNO=@P_CNO

GO
DROP PROCEDURE CLVIEW06B
GO
CREATE PROCEDURE CLVIEW06B (@P_CNO AS INTEGER)       
AS      
SELECT C.*, C.TAmount as OurShare, Claim.ClaimNo, Claim.ANO, Claim.LossDate, C.ETAmount as Estimate, 
R.CID, R.QID, R.DID, R.XPID, R.SP1ID, R.SP2ID, R.SP3ID, R.AID, coalesce(ISOURCE.SHARE,100) as PCTSHARE,
CASE WHEN CLAIM.PSTATUS='C' and (C.CAMOUNT<>0 OR C.ECAMOUNT<>0) THEN CASE WHEN C.CAMOUNT<>0 THEN C.CAMOUNT/C.TAMOUNT*100 ELSE C.ECAMOUNT/C.ETAMOUNT*100 END ELSE 0 END AS CSHARE,
CASE WHEN CLAIM.PSTATUS='C' and (C.DAMOUNT<>0 OR C.EDAMOUNT<>0) THEN CASE WHEN C.DAMOUNT<>0 THEN C.DAMOUNT/C.TAMOUNT*100 ELSE C.EDAMOUNT/C.ETAMOUNT*100 END ELSE 0 END AS DSHARE,
CASE WHEN CLAIM.PSTATUS='C' and (C.QAMOUNT<>0 OR C.EQAMOUNT<>0) THEN CASE WHEN C.QAMOUNT<>0 THEN C.QAMOUNT/C.TAMOUNT*100 ELSE C.EQAMOUNT/C.ETAMOUNT*100 END ELSE 0 END AS QSHARE,
CASE WHEN CLAIM.PSTATUS='C' and (C.XPAMOUNT<>0 OR C.EXPAMOUNT<>0) THEN CASE WHEN C.XPAMOUNT<>0 THEN C.XPAMOUNT/C.TAMOUNT*100 ELSE C.EXPAMOUNT/C.ETAMOUNT*100 END ELSE 0 END AS XPSHARE,
CASE WHEN CLAIM.PSTATUS='C' and (C.SP1AMOUNT<>0 OR C.ESP1AMOUNT<>0) THEN CASE WHEN C.SP1AMOUNT<>0 THEN C.SP1AMOUNT/C.TAMOUNT*100 ELSE C.ESP1AMOUNT/C.ETAMOUNT*100 END ELSE 0 END AS SP1SHARE,
CASE WHEN CLAIM.PSTATUS='C' and (C.SP2AMOUNT<>0 OR C.ESP2AMOUNT<>0) THEN CASE WHEN C.SP2AMOUNT<>0 THEN C.SP2AMOUNT/C.TAMOUNT*100 ELSE C.ESP2AMOUNT/C.ETAMOUNT*100 END ELSE 0 END AS SP2SHARE,
CASE WHEN CLAIM.PSTATUS='C' and (C.SP3AMOUNT<>0 OR C.ESP3AMOUNT<>0) THEN CASE WHEN C.SP3AMOUNT<>0 THEN C.SP3AMOUNT/C.TAMOUNT*100 ELSE C.ESP3AMOUNT/C.ETAMOUNT*100 END ELSE 0 END AS SP3SHARE,
CASE WHEN CLAIM.PSTATUS='C' and (C.AAMOUNT<>0 OR C.EAAMOUNT<>0) THEN CASE WHEN C.AAMOUNT<>0 THEN C.AAMOUNT/C.TAMOUNT*100 ELSE C.EAAMOUNT/C.ETAMOUNT*100 END ELSE 0 END AS ASHARE,
CASE WHEN CLAIM.PSTATUS='C' and (C.FAMOUNT<>0) THEN C.FAMOUNT/C.TAMOUNT*100 ELSE 0 END AS FSHARE,
CASE WHEN CLAIM.PSTATUS='C' and (C.EFAMOUNT<>0) THEN C.EFAMOUNT/C.ETAMOUNT*100 ELSE 0 END AS EFSHARE,pC.TAmount as PrevOurShare, pC.MAmount as PrevMAmount,
pC.CAMOUNT as PREVCAMOUNT, pc.XPAMOUNT as PREVXPAMOUNT, pC.DAmount as PREVDAmount, pC.QAMOUNT as PREVQAMOUNT, pC.SP1AMOUNT as PREVSP1AMOUNT, pC.SP2AMOUNT as PREVSP2AMOUNT, pC.SP3AMOUNT as PREVSP3AMOUNT, pC.AAmount as PREVAAmount, pC.FAmount as PrevFAmount,
pc.XL1AMOUNT as PREVXL1AMOUNT, pc.XL2AMOUNT as PREVXL2AMOUNT, pc.XL3AMOUNT as PREVXL3AMOUNT,pc.XL4AMOUNT as PREVXL4AMOUNT,pc.XL5AMOUNT as PREVXL5AMOUNT,pc.XL6AMOUNT as PREVXL6AMOUNT,pc.XL7AMOUNT as PREVXL7AMOUNT,pC.QXOLAMOUNT as PREVQXOLAMOUNT, pc.RAMOUNT as PREVRAMOUNT,
R.QSSFShare, R.SPRShare, 
TOC.CashCallOnPartialPaymentF, TOC.CashCallOnEstimateF, TOC.CashCallOnGrossF
FROM CLAIM
INNER JOIN ACCEPTANCE ON (ACCEPTANCE.ANO=CLAIM.ANO)
INNER JOIN TOC on (TOC.TOC=CLAIM.TOC)
INNER JOIN CARRHEADER C ON (C.CNO=CLAIM.CNO)
INNER JOIN RARRHEADER R ON (R.ANO=ACCEPTANCE.ANO)
LEFT JOIN AISOURCE ISOURCE ON (ISOURCE.ANO=ACCEPTANCE.ANO)
LEFT JOIN CARRHEADER pC ON (pC.CNO=CLAIM.pCNO and CLAIM.CSEQNO>0)
WHERE CLAIM.CNO=@P_CNO 

GO


DROP PROCEDURE QCCALC_1 
GO
CREATE PROCEDURE QCCALC_1 (@PCNO as integer) 
AS
SELECT CCALC.*, LCALC.RCODE, LCALC.TOR, ISOURCE.LIMIT, ISOURCE.EXCESS
FROM CCALC 
INNER JOIN CLAIM ON (CLAIM.CNO=CCALC.CNO) 
INNER JOIN ACCEPTANCE ON (ACCEPTANCE.ANO=CLAIM.ANO ) 
LEFT JOIN AISOURCE ISOURCE ON (ISOURCE.ANO=ACCEPTANCE.ANO)
OUTER APPLY (SELECT TOP 1 TOR, CODE AS RCODE FROM LCALC WHERE CNO=CCALC.CNO Order By Case When LCALC.Currency=CCALC.Currency Then 0 Else 1 End, Code, TOR) LCALC
WHERE CCALC.CNO=@PCNO   
GO

DROP PROCEDURE QCLACC_3
GO
CREATE PROCEDURE QCLACC_3(@P_POLICYNO AS VARCHAR(255), @P_CERTIFICATENO VARCHAR(255), @P_REFNO varchar(50)='', @P_TOC varchar(10)='', @P_VALUEID varchar(255)='')     
AS     
SELECT TOP 10 ACCEPTANCE.ANO, ACCEPTANCE.POLICYNO, ACCEPTANCE.CERTIFICATENO, ACCEPTANCE.AID, COVER.INSURED, Acceptance.ISTYPE, COVER.SEGMENT, ACCEPTANCE.TOC, ACCEPTANCE.SDATE, ACCEPTANCE.EDATE, Cover.PHolder, ACCEPTANCE.BRANCH, ACCEPTANCE.ANAME, PROFILE.RESTRICTEDF, PROFILE.NAME, ACCEPTANCE.PDATE, ACCEPTANCE.PPDATE, ACCEPTANCE.NCDATE,  ACCEPTANCE.EXTPERIOD,     
Case When GenDTab.Description is not null then ACCEPTANCE.ValueDesc else '' end as Description,     
coalesce(InParty.ID, coalesce(ISource.ID, Acceptance.AID)) as Payment,
coalesce(IProfile.Name, coalesce(PProfile.Name, Profile.Name)) as Payment_Name
FROM ACCEPTANCE WITH (INDEX(I_Acceptance_PolicyNo_CertificateNo))  
Left Join Acceptance mA on (mA.ANO=Acceptance.LANO)
Left Join GenDTab On (GenDTab.FLDID=ACCEPTANCE.FLDID AND GenDTab.ValueID=ACCEPTANCE.ValueID)  
Inner Join COVER on (Cover.CNO=Acceptance.CNO)  
Left Join AISource ISource On (ISource.ANO=Acceptance.ANO)   
Left Join InParty on (InParty.CNO=Cover.CNO and InParty.IType in ('MORTGAGE'))
Left Join Profile PProfile On (PProfile.ID=ISource.ID)  
Left Join Profile IProfile On (IProfile.ID=InParty.ID)  
Left Join Profile on (Profile.ID=Acceptance.AID)  
WHERE ACCEPTANCE.ATYPE Not In ('A','C') AND ACCEPTANCE.AStatus not in ('W','T') and COVER.CStatus not in ('R','P','C')     
and coalesce(mA.AStatus, Acceptance.AStatus) not in ('W','T')
And ((ACCEPTANCE.PDATE<ACCEPTANCE.PPDATE) or (ACCEPTANCE.PDATE=ACCEPTANCE.PPDATE and ACCEPTANCE.STime<ACCEPTANCE.ETime)) AND ACCEPTANCE.ANO<>ACCEPTANCE.LANO   
AND ACCEPTANCE.POLICYNO<>'' AND ACCEPTANCE.POLICYNO LIKE @P_POLICYNO AND ACCEPTANCE.CERTIFICATENO LIKE @P_CERTIFICATENO     
AND ACCEPTANCE.TOC LIKE @P_TOC+'%' AND ACCEPTANCE.REFNO LIKE @P_REFNO+'%'  
AND ACCEPTANCE.VALUEID LIKE @P_VALUEID+'%'
ORDER BY ACCEPTANCE.ANO DESC 

GO
DROP PROCEDURE QSRACC_1
GO
CREATE PROCEDURE QSRACC_1 (@P_MO as varchar(10), @P_Segment as varchar(10), @P_Branch as varchar(10), @P_POLICYNO AS VARCHAR(255), @P_CERTIFICATENO VARCHAR(255), @P_STYPE varchar(20)='') 
AS 
SELECT TOP 50 ACCEPTANCE.POLICYNO, ACCEPTANCE.CERTIFICATENO, Acceptance.AID, Acceptance.AName, SysUser.Name as MOName, Acceptance.Branch, Cover.PHolder, COVER.INSURED, Acceptance.TOC, Cover.CoverDate, Cover.ExpDate, RCover.Code, RCover.Coverage, 
TOC.RegID, TOC.Description as TOCDesc, Profile.Name as PHolderName, Profile.Address_1, Profile.Address_2, Profile.Phone_1, Profile.Phone_2, Profile.Fax_1, Profile.Fax_2, PCalc.Currency, PCalc.TSI, PCalc.Gross,
Acceptance.LANO, Acceptance.ANO, Acceptance.Source as BSID, Cover.CNO, Cover.ASource, Cover.PolicyType, Acceptance.ISType, Cover.Segment, Cover.MO, Branch.Name as BranchName, 
Acceptance.TOPRO, TOPRO.Description as TOPRODesc, Acceptance.RefNo, Acceptance.RefDate,
Acceptance.STime, Acceptance.ETime,
ISource.ID as CedingID, ISource.Share as CedingShare
FROM ACCEPTANCE Left Join (Select RCover.ANO, Max(RCover.Code) as Code, Max(RateTab.Description) as Coverage from RCover, RateTab Where RateTab.Code=RCover.Code and RCover.Category='M' Group By RCover.ANO) RCover on (RCover.ANO=Acceptance.ANO) 
Left join TOPRO on (TOPRO.TOPRO=Acceptance.TOPRO) 
Inner Join Cover on (Cover.CNO=Acceptance.CNO) 
inner join TOC on (TOC.TOC=Acceptance.TOC) 
inner join Profile on (Profile.ID=Cover.PHolder) 
inner join SysUser on (SysUser.ID=Cover.MO) 
inner join Branch on (Branch.Branch=Acceptance.Branch) 
Left Join PCalc on (PCalc.ANO=Acceptance.ANO) 
Left Join AISource ISource on (ISource.ANO=Acceptance.ANO)

WHERE ( 
(@P_SType in ('REFERENCE','CLAIM','RENEWAL') and ACCEPTANCE.ATYPE Not In ('A','C') And Cover.CStatus<>'C' and ACCEPTANCE.ASTATUS Not in ('W','T') And ((ACCEPTANCE.PDATE<ACCEPTANCE.PPDATE) or (ACCEPTANCE.PDATE=ACCEPTANCE.PPDATE and ACCEPTANCE.STime<ACCEPTANCE.ETime)) And ACCEPTANCE.PolicyNo<>'')
or 
(@P_SType in ('ENDORSEMENT') and ACCEPTANCE.ATYPE Not In ('A') And ACCEPTANCE.ASTATUS='I')
or 
(@P_SType in ('CANCELLATION') and ACCEPTANCE.ATYPE Not In ('C') And ACCEPTANCE.ASTATUS='I')
or 
(@P_SType Not in ('REFERENCE','CLAIM','ENDORSEMENT') and ACCEPTANCE.ATYPE Not In ('A','C') And ACCEPTANCE.ASTATUS='I' And ((ACCEPTANCE.PDATE<ACCEPTANCE.PPDATE) or (ACCEPTANCE.PDATE=ACCEPTANCE.PPDATE and ACCEPTANCE.STime<ACCEPTANCE.ETime)))
)
And Cover.MO like @P_MO and Cover.Segment Like @P_Segment 
And Acceptance.Branch Like @P_Branch and ACCEPTANCE.POLICYNO LIKE @P_POLICYNO AND ACCEPTANCE.CERTIFICATENO LIKE @P_CERTIFICATENO 
--And Acceptance.ANO<>Acceptance.LANO 
ORDER BY ACCEPTANCE.ANO DESC 

GO
DROP Procedure QRCESSIONDET 
GO
CREATE Procedure QRCESSIONDET (@P_ANO integer,@P_RID varchar(255), @P_ID varchar(255), @P_DocNo varchar(255), @P_CCY varchar(255), @P_SDate DateTime, @P_EDate DateTime, @P_Code varchar(10), @P_AdjustableF bit,@P_TSI as Float=0, @P_ASDate as DateTime=0)   

              
AS            
Declare @Premium_Treaty_Discount as Float            
Declare @Premium_Discount as Float            
Declare @Premium_Commission as Float            
Declare @Premium_Commission_Inward as Float            
Declare @Premium_Fee as Float            
Declare @Premium_OutGo as Float            
Declare @P_TOC as varchar(10)    
Declare @P_AType as varchar(1)    
Declare @P_ONGROSSNet as int    
Declare @P_RateConF as Bit    
Declare @P_NETRATE as Float    
Declare @P_NETRATEDet as Float    
Declare @P_NOFYEARS as Int    
Declare @P_COMM as Float
Declare @P_COMMN as Float    
Declare @P_OnMinPremiumF as Bit    
Declare @P_PPCT as Float    
Declare @P_OnNetPremiumF as Bit    
Declare @P_RNO as int    
Declare @P_RType as varchar(10)        
Declare @P_OPFEEPCT as Float    
Declare @P_FEE as Float    
Declare @P_OANO as int    
Declare @P_COMMPOLICYF as Bit    
Declare @P_PFactor as Float  
Declare @P_IFee as Float  
Declare @P_Period as Int  
Declare @P_Tabarru as Float  
Declare @P_RITabarruF as Bit  
Declare @P_OPFEEF as Bit  
Declare @P_AEDate as smalldatetime
Declare @P_LANO as Int

Select     
@P_Period=cast(datediff(Month,A.SDate, @P_SDate) as integer) / 12 + 1,  
@P_ASDate=A.SDate,
@P_AEDate=A.EDate,
@P_NOFYEARS=datediff(year,A.SDate, A.EDate),     
@P_TOC=A.TOC,     
@P_AType=A.AType,     
@P_ONGROSSNET=R.ONGROSSNET,     
@P_RateConF=R3.RateConF,     
@P_NETRATE=R2.NETRATE,    
@P_NETRATEDet=R4.NETRATE,    
@P_COMM=CASE WHEN R3.COMM<>0 Then R3.COMM ELSE R2.COMM END,    
@P_COMMN=CASE WHEN R3.COMMN<>0 Then R3.COMMN ELSE R2.COMMN END,    
@P_OnMinPremiumF=R2.OnMinPremiumF,    
@P_PPCT=R2.PPCT,    
@P_OnNetPremiumF=R2.OnNetPremiumF,     
@P_RNO=R1.RNO,    
@P_RType=R1.RType,    
@P_OANO=A.OANO,    
@P_FEE=R2.FEE,    
@P_COMMPOLICYF=R2.COMMPOLICYF,  
@P_PFactor=Case When A.ISType='R' Then (100-I.UJrohCedant)/100*(100+I.UjrohReins)/100 else 1 end,  
@Premium_Commission_Inward=coalesce(I2.Fee+I2.HF,coalesce(I.Fee+I.HF,0))+coalesce(I.OC,0),  
@P_Tabarru=(100-A.Ujroh),  
@P_OPFEEF=R3.OPFEEF,
@P_LANO=A.LANO
from Acceptance A  
Inner Join RarrHeader R on (R.ANO=A.ANO)  
Inner Join Cover C on (C.CNO=A.CNO)  
Left Join AISource I on (I.ANO=A.ANO)  
Left Join AISourceDet I2 on (I2.ANO=I.ANO and I2.Code=@P_Code)  
Inner Join Reinsurance R1 on (R1.RID=@P_RID)  
Inner join RPart R2 on (R2.RNO=R1.RNO and R2.ID=@P_ID and R2.DocNo=@P_DocNo)  
Inner Join ReClass R3 on (R3.RNO=R1.RNO and R3.TOC=A.TOC)  
Left Join ReClassDet R4 on (R4.RNO=R3.RNO AND R4.TOC=R3.TOC AND R4.CODE=@P_CODE)    
Where A.ANO=@P_ANO  
  
if @P_OnNetPremiumF=1  
 Select @Premium_Treaty_Discount=dbo.Premium_Treaty_Discount(@P_ANO, @P_Code,@P_Period)            
else  
 Select @Premium_Treaty_Discount=0  
  
if @P_COMMN<>0  
Begin  
 Select @Premium_Discount=dbo.premium_discount(@P_ANO, @P_Code, @P_Period)    
 Select @Premium_Fee=dbo.Premium_Fee(@P_ANO, @P_Period)    
End  
else  
Begin  
 Select @Premium_Discount=0  
 Select @Premium_Fee=0  
End  
  
if @P_COMMN<>0 or (@P_COMMPOLICYF=1 and @P_COMM=0 and @P_COMMN=0)  
 Select @Premium_Commission=dbo.Premium_Commission(@P_ANO, @P_Code, @P_Period,0)+dbo.Premium_MaxOutGo_Vat(@P_ANO, @P_Code, @P_Period,0)    
Else  
 Select @Premium_Commission=0  
  
Select @Premium_outGo=@Premium_Discount+@Premium_Commission+@Premium_Commission_Inward+@Premium_Fee-(Case When @P_OnNetPremiumF=1 Then @Premium_Treaty_Discount else 0 end)  
Select @P_COMM=CASE WHEN @P_COMMPOLICYF=1 and @P_COMM=0 and @P_COMMN=0 Then @Premium_Commission ELSE @P_COMM END    
  
SELECT @P_OPFEEPCT=Case When ROUND(COALESCE(SUM(Gross),0),4)<>0 Then COALESCE(SUM(FEE),0)/ROUND(COALESCE(SUM(Gross),0),4)*100 Else 0 End, @P_RITabarruF=coalesce(cast(Max(cast(RITabarruF as Int)) as Bit),0)  
FROM  
(  
	SELECT  
	A2.ANO,  
	Premium.Gross,
	Case   
	When coalesce(A1.Amount,0)<>0 Then  
		A1.Amount*Case When A1.RITabarruF=1 Then cast(100 as Float)/@P_Tabarru Else 1 end 
	When coalesce(A1.AmountPCT,0)<>0 then
		(Premium.Gross)*A1.AmountPCT/100*Case When A1.RITabarruF=1 Then cast(100 as Float)/@P_Tabarru Else 1 end 	
	Else
		0
	End as Fee,
	coalesce(A1.RITabarruF,cast(0 as Bit)) as RITabarruF
	from   
	Acceptance A2  
	INNER Join PCalc on (PCalc.ANO=A2.ANO and PCalc.Currency=@P_CCY)  
	Outer Apply (
		Select 
		sum(case When A1.PolicyYear<>0 then 
			A1.Amount*case When A1.ContributionF=1 Then 1 Else 100/coalesce(R.PCTSHARE-R.MSHARE,100) End
		else 
			A1.Amount*case When A1.ContributionF=1 Then 1 Else 100/coalesce(R.PCTSHARE-R.MSHARE,100) End*cast(dbo.fn_Premium_Calc_Prorata(@P_SDate, @P_EDate, 0,1,2) as Float)/cast(dbo.fn_Premium_Calc_Prorata(@P_ASDate, @P_AEDate,0,1,2) as Float)
		End) as Amount,
		sum(A1.AMOUNTPCT) as AMOUNTPCT, MAX(A1.AMOUNTPCTBASED) as AMOUNTPCTBASED, Cast(MAX(Cast(A1.RITabarruF as Int)) as Bit) as RITabarruF
		from AccFD A1
		Inner Join RARRHEADER R on (R.ANO=A2.ANO)
		Inner Join FDTAB on (FDTAB.FDID=A1.FDID and Left(FDTAB.FDType,1)='O')
		Where A1.ANO=A2.ANO and A1.Currency=PCalc.Currency and (A1.ContributionF=1 or A1.CessionF=1) and A1.AmountPCTBased in (0,3) And (A1.PolicyYear=0 or A1.PolicyYear=@P_Period)
	) A1
	Outer APPLY
	(
		Select coalesce(sum(Gross),0) as Gross
		from
		(
			Select   
			Case			
			When coalesce(A1.AMOUNTPCTBASED,0)<>3 then
				D1.Gross*D1.Prorata*P.Gross/P.OGross
			else
				D1.Gross*D1.Prorata*P.Gross/P.OGross*(100-D1.Discount-D1.Commission)/100
			End as Gross
			from Display_Calculation(A2.ANO) D1  
			Inner Join Acceptance A on (A.ANO=D1.ANO)  
			Inner Join PCalc P on (P.ANO=D1.ANO and P.Currency=D1.Currency)  
			Where D1.Currency=@P_CCY  
			and (@P_Period=0 or (D1.SDate>=dateadd(month,12*(@P_Period-1),A.SDate) and D1.SDate<dateadd(month,12*(@P_Period),A.SDate)))
		) Premium
	) Premium
   	Where @P_RType in ('Q','S1','S2','S3','A') and A2.OANO=@P_OANO and A2.ANO<=@P_ANO    
	and A2.ANO>(Select coalesce(Max(ANO),0) from Acceptance Where AType='C' and EMethod='A' and Acceptance.OANO=@P_OANO and Acceptance.ANO<=@P_ANO and AStatus not in ('W','T'))  


	Union All  
  
	--Op Fee from Master Policy  
	SELECT  
	A2.ANO,  
	0 as Gross,
	Case   
	When coalesce(A1.Amount,0)<>0 Then  
		--Not Yet for Master Policy  
		0  
	When coalesce(A1.AmountPCT,0)<>0 Then  
		(Premium.Gross)*A1.AmountPCT/100*Case When A1.RITabarruF=1 Then cast(100 as Float)/@P_Tabarru Else 1 end 	
	Else
		0
	End as Fee,
	coalesce(A1.RITabarruF,cast(0 as Bit)) as RITabarruF
	from   
	Acceptance A2  
	INNER Join PCalc on (PCalc.ANO=A2.ANO and PCalc.Currency=@P_CCY)  
	INNER JOIN Acceptance MA on (MA.PolicyNo<>'' and MA.RegNo=A2.RegNo and MA.ANO=MA.LANO)  
	INNER JOIN COVER C on (C.CNO=MA.CNO and C.OPENFLAG=0)  
	Outer Apply (
		Select 
		sum(case When A1.PolicyYear<>0 then 
			A1.Amount*case When A1.ContributionF=1 Then 1 Else 100/coalesce(R.PCTSHARE-R.MSHARE,100) End
		else 
			A1.Amount*case When A1.ContributionF=1 Then 1 Else 100/coalesce(R.PCTSHARE-R.MSHARE,100) End*cast(dbo.fn_Premium_Calc_Prorata(@P_SDate, @P_EDate, 0,1,2) as Float)/cast(dbo.fn_Premium_Calc_Prorata(@P_ASDate, @P_AEDate,0,1,2) as Float)
		End) as Amount,
		sum(A1.AMOUNTPCT) as AMOUNTPCT, MAX(A1.AMOUNTPCTBASED) as AMOUNTPCTBASED, Cast(MAX(Cast(A1.RITabarruF as Int)) as Bit) as RITabarruF
		from AccFD A1
		Inner Join RArrHeader R on (R.ANO=A2.ANO)
		Inner Join FDTAB on (FDTAB.FDID=A1.FDID and Left(FDTAB.FDType,1)='O')
		Where A1.ANO=MA.ANO and A1.Currency=PCalc.Currency and (A1.ContributionF=1 or A1.CessionF=1) and A1.AmountPCTBased in (0,3) And (A1.PolicyYear=0 or A1.PolicyYear=@P_Period)
	) A1
	Outer APPLY
	(
		Select coalesce(sum(Gross),0) as Gross
		from
		(
			Select   
			Case			
			When coalesce(A1.AMOUNTPCTBASED,0)<>3 then
				D1.Gross*D1.Prorata*P.Gross/P.OGross
			else
				D1.Gross*D1.Prorata*P.Gross/P.OGross*(100-D1.Discount-D1.Commission)/100
			End as Gross
			from Display_Calculation(A2.ANO) D1  
			Inner Join Acceptance A on (A.ANO=D1.ANO)  
			Inner Join PCalc P on (P.ANO=D1.ANO and P.Currency=D1.Currency)  
			Where D1.Currency=@P_CCY  
			and (@P_Period=0 or (D1.SDate>=dateadd(month,12*(@P_Period-1),A.SDate) and D1.SDate<dateadd(month,12*(@P_Period),A.SDate)))
		) Premium
	) Premium
	Where @P_LANO<>-1 and @P_RType in ('Q','S1','S2','S3','A') and A2.OANO=@P_OANO and A2.ANO<=@P_ANO    
	and A2.ANO>(Select coalesce(Max(ANO),0) from Acceptance Where AType='C' and EMethod='A' and Acceptance.OANO=@P_OANO and Acceptance.ANO<=@P_ANO and AStatus not in ('W','T'))  
) A  
Where @P_OPFEEF=1  
  
Select                
sum(Case When OnMinPremiumF=0 Then (case When Gross_1>Gross_2 then Gross_1 else Gross_2 end) else (case When Gross_1<Gross_2 and Gross_1<>0 then Gross_1 else Gross_2 end) end) as Premium,             
sum(Case When OnMinPremiumF=0 Then (case When Gross_1>Gross_2 then Comm_1 else Comm_2 end) else (case When Gross_1<Gross_2 and Gross_1<>0 then Comm_1 else Comm_2 end) end) as Commission,           
sum(Case When OnMinPremiumF=0 Then (case When Gross_1>Gross_2 then Disc_1 else Disc_2 end) else (case When Gross_1<Gross_2 and Gross_1<>0 then Disc_1 else Disc_2 end) end) as Discount,    
sum(Case When OnMinPremiumF=0 Then (case When Gross_1>Gross_2 then Fee_1 else Fee_2 end) else (case When Gross_1<Gross_2 and Gross_1<>0 then Fee_1 else Fee_2 end) end) as Fee                
From            
(
select                
Cast(@P_OnMinPremiumF as integer) as OnMinPremiumF,                
coalesce(SUM((CASE WHEN @P_PPCT<>0 THEN @P_PPCT/100 ELSE (Case When @P_RateConF=1 and (RRateCon.Rate is not null or RateCon.Rate is not null) then 0 else 1 end) END * ICALC.GROSS*(PCALC.PGROSS*@P_PFactor)/PCALC.POGROSS*(100-@Premium_Treaty_Discount)/100-(ICALC.GROSS*PCALC.PGROSS/PCALC.POGROSS*@P_OPFEEPCT/100))*(Case When @P_COMMN=0 Then @P_COMM/100 else (Case When RCover.NetRateF=1 or @P_ONGROSSNET=2 OR (@P_ONGROSSNET=0 AND (100-@Premium_OutGo)/100*(100-@P_COMMN)/100<(100-@P_COMM)/100) Then (100-@Premium_OutGo)/100*(@P_COMMN)/100 else @P_COMM/100 end) end)),0) AS COMM_1,                
coalesce(SUM((Case When @P_RateConF=1 Then (Case When RRateCon.Rate is null then RateCon.Rate*(Case When RateCon.Loading<>0 then RateCon.Loading/100 else RCover.Loading end) else RRateCon.Rate/PCalc.RiskNum*(Case When RRateCon.Loading<>0 then RRateCon.Loading/100 else RCover.Loading end) end) Else coalesce(@P_NETRATEDet,@P_NETRATE/PCalc.RiskNum) end/100*(100-RCover.Discount)/100*ICALC.GROSS/PCALC.GROSS*ICALC.PRORATA *ICALC.TSI*(CASE WHEN RCOVER.PCALC='S' OR RCOVER.PCTLOSS=0 THEN 100 ELSE RCOVER.PCTLOSS END)/(CASE WHEN RCOVER.PCTLOSS=0 THEN 100 ELSE RCOVER.PCTLOSS END+RCOVER.PAddition)*ICALC.PCTADJ/100-(ICALC.GROSS*PCALC.PGROSS/PCALC.POGROSS*@P_OPFEEPCT/100))*(Case When @P_COMMN=0 Then @P_COMM/100 else (Case When RCover.NetRateF=1 or @P_ONGROSSNET=2 OR (@P_ONGROSSNET=0 AND (100-@Premium_OutGo)/100*(100-@P_COMMN)/100<(100-@P_COMM)/100) Then (100-@Premium_OutGo)/100*(@P_COMMN)/100 else @P_COMM/100 end) end)),0) AS COMM_2,                
  
coalesce(SUM((CASE WHEN @P_PPCT<>0 THEN @P_PPCT/100 ELSE (Case When @P_RateConF=1 and (RRateCon.Rate is not null or RateCon.Rate is not null) then 0 else 1 end) END * ICALC.GROSS*(PCALC.PGROSS*@P_PFactor)/PCALC.POGROSS*(100-@Premium_Treaty_Discount)/100)*(Case When @P_COMMN=0 Then 1 else (Case When RCover.NetRateF=1 or @P_ONGROSSNET=2 OR (@P_ONGROSSNET=0 AND (100-@Premium_OutGo)/100*(100-@P_COMMN)/100<(100-@P_COMM)/100) Then 1 else 1 end) end)-(Case When @P_RITabarruF=1 Then 1 Else 0 end)*(ICALC.GROSS*PCALC.PGROSS/PCALC.POGROSS*@P_OPFEEPCT/100)),0) AS GROSS_1,              
coalesce(SUM((Case When @P_RateConF=1 Then (Case When RRateCon.Rate is null then RateCon.Rate*(Case When RateCon.Loading<>0 then RateCon.Loading/100 else RCover.Loading end) else RRateCon.Rate/PCalc.RiskNum*(Case When RRateCon.Loading<>0 then RRateCon.Loading/100 else RCover.Loading end) end) Else coalesce(@P_NETRATEDet,@P_NETRATE/PCalc.RiskNum) end/100*(100-RCover.Discount)/100*ICALC.GROSS/PCALC.GROSS*ICALC.PRORATA *ICALC.TSI*(CASE WHEN RCOVER.PCALC='S' OR RCOVER.PCTLOSS=0 THEN 100 ELSE RCOVER.PCTLOSS END)/(CASE WHEN RCOVER.PCTLOSS=0 THEN 100 ELSE RCOVER.PCTLOSS END+RCOVER.PAddition)*ICALC.PCTADJ/100)*(Case When @P_COMMN=0 Then 1 else (Case When RCover.NetRateF=1 or @P_ONGROSSNET=2 OR (@P_ONGROSSNET=0 AND (100-@Premium_OutGo)/100*(100-@P_COMMN)/100<(100-@P_COMM)/100) Then 1 else 1 end) end)-(Case When @P_RITabarruF=1 Then 1 Else 0 end)*(ICALC.GROSS*PCALC.PGROSS/PCALC.POGROSS*@P_OPFEEPCT/100)),0) AS GROSS_2,                
               
coalesce(SUM((CASE WHEN @P_PPCT<>0 THEN @P_PPCT/100 ELSE (Case When @P_RateConF=1 and (RRateCon.Rate is not null or RateCon.Rate is not null) then 0 else 1 end) END * ICALC.GROSS*(PCALC.PGROSS*@P_PFactor)/PCALC.POGROSS*(100-@Premium_Treaty_Discount)/100-(ICALC.GROSS*PCALC.PGROSS/PCALC.POGROSS*@P_OPFEEPCT/100))*(Case When @P_COMMN=0 Then 0 else (Case When RCover.NetRateF=1 or @P_ONGROSSNET=2 OR (@P_ONGROSSNET=0 AND (100-@Premium_OutGo)/100*(100-@P_COMMN)/100<(100-@P_COMM)/100) Then (@Premium_OutGo)/100 else 0 end) end)),0) AS DISC_1,         
coalesce(SUM((Case When @P_RateConF=1 Then (Case When RRateCon.Rate is null then RateCon.Rate*(Case When RateCon.Loading<>0 then RateCon.Loading/100 else RCover.Loading end) else RRateCon.Rate/PCalc.RiskNum*(Case When RRateCon.Loading<>0 then RRateCon.Loading/100 else RCover.Loading end) end) Else coalesce(@P_NETRATEDet,@P_NETRATE/PCalc.RiskNum) end/100*(100-RCover.Discount)/100*ICALC.GROSS/PCALC.GROSS*ICALC.PRORATA *ICALC.TSI*(CASE WHEN RCOVER.PCALC='S' OR RCOVER.PCTLOSS=0 THEN 100 ELSE RCOVER.PCTLOSS END)/(CASE WHEN RCOVER.PCTLOSS=0 THEN 100 ELSE RCOVER.PCTLOSS END+RCOVER.PAddition)*ICALC.PCTADJ/100-(ICALC.GROSS*PCALC.PGROSS/PCALC.POGROSS*@P_OPFEEPCT/100))*(Case When @P_COMMN=0 Then 0 else (Case When RCover.NetRateF=1 or @P_ONGROSSNET=2 OR (@P_ONGROSSNET=0 AND (100-@Premium_OutGo)/100*(100-@P_COMMN)/100<(100-@P_COMM)/100) Then (@Premium_OutGo)/100 else 0 end) end)),0) AS DISC_2,    
  
coalesce(SUM((CASE WHEN @P_PPCT<>0 THEN @P_PPCT/100 ELSE (Case When @P_RateConF=1 and (RRateCon.Rate is not null or RateCon.Rate is not null) then 0 else 1 end) END * ICALC.GROSS*(PCALC.PGROSS*@P_PFactor)/PCALC.POGROSS*(100-@Premium_Treaty_Discount)/100)*(Case When @P_COMMN=0 Then 1 else (Case When RCover.NetRateF=1 or @P_ONGROSSNET=2 OR (@P_ONGROSSNET=0 AND (100-@Premium_OutGo)/100*(100-@P_COMMN)/100<(100-@P_COMM)/100) Then 1 else 1 end) end)*@P_FEE/100-(Case When @P_RITabarruF=0 Then 1 Else 0 end)*(ICALC.GROSS*PCALC.PGROSS/PCALC.POGROSS*@P_OPFEEPCT/100)),0) AS FEE_1,                
coalesce(SUM((Case When @P_RateConF=1 Then (Case When RRateCon.Rate is null then RateCon.Rate*(Case When RateCon.Loading<>0 then RateCon.Loading/100 else RCover.Loading end) else RRateCon.Rate/PCalc.RiskNum*(Case When RRateCon.Loading<>0 then RRateCon.Loading/100 else RCover.Loading end) end) Else coalesce(@P_NETRATEDet,@P_NETRATE/PCalc.RiskNum) end/100*(100-RCover.Discount)/100*ICALC.GROSS/PCALC.GROSS*ICALC.PRORATA *ICALC.TSI*(CASE WHEN RCOVER.PCALC='S' OR RCOVER.PCTLOSS=0 THEN 100 ELSE RCOVER.PCTLOSS END)/(CASE WHEN RCOVER.PCTLOSS=0 THEN 100 ELSE RCOVER.PCTLOSS END+RCOVER.PAddition)*ICALC.PCTADJ/100)*(Case When @P_COMMN=0 Then 1 else (Case When RCover.NetRateF=1 or @P_ONGROSSNET=2 OR (@P_ONGROSSNET=0 AND (100-@Premium_OutGo)/100*(100-@P_COMMN)/100<(100-@P_COMM)/100) Then 1 else 1 end) end)*@P_FEE/100-(Case When @P_RITabarruF=0 Then 1 Else 0 end)*(ICALC.GROSS*PCALC.PGROSS/PCALC.POGROSS*@P_OPFEEPCT/100)),0) AS FEE_2    
                
FROM ICALC     
INNER JOIN ACCEPTANCE SACCEPTANCE ON (SACCEPTANCE.ANO=ICALC.SANO)    
INNER JOIN RCOVER ON (RCOVER.ANO=ICALC.SANO AND RCOVER.CODE=ICALC.CODE AND (RCOVER.SDATE=ICALC.SDATE OR (@P_AType='A' AND (CASE WHEN RCOVER.SDATE<SACCEPTANCE.PDATE THEN SACCEPTANCE.PDATE ELSE RCOVER.SDATE END)=ICALC.SDATE)))    
LEFT JOIN RPARTDET ON (RPARTDET.RNO=@P_RNO AND RPARTDET.ID=@P_ID AND RPartDet.DocNo=@P_DocNo AND RPARTDET.TOR=ICALC.TOR)    
LEFT Join FN_RateCon(@P_ANO, @P_CODE,@P_TSI,@P_ASDate) RateCon On (@P_RateConF=1 and RateCon.Code=ICalc.Code)    
LEFT Join FN_RRateCon(@P_ANO, @P_RID, @P_TSI) RRateCon On (@P_RateConF=1)                
INNER JOIN ICOVER ON (ICOVER.INO=ICALC.INO AND (ICOVER.ADJUSTABLE=@P_ADJUSTABLEF OR @P_AType='A'))    
INNER JOIN RCALC ON (RCALC.ANO=ICALC.ANO AND RCALC.CURRENCY=ICALC.CURRENCY AND RCALC.CODE=ICALC.CODE AND RCALC.TOR=ICALC.TOR AND RCALC.SDATE=ICALC.SDATE AND RCALC.EDATE=ICALC.EDATE AND RCALC.SANO=ICALC.SANO AND RCALC.EXTREATYF=0)    
INNER JOIN PCALC_ANNUM(@P_ANO) PCALC ON (PCALC.ANO=ICALC.ANO AND PCALC.CODE=ICALC.CODE AND PCALC.SDATE=ICALC.SDATE AND PCALC.EDATE=ICALC.EDATE AND PCALC.INO=ICALC.INO AND PCALC.CURRENCY=ICALC.CURRENCY)    
WHERE ICALC.ANO=@P_ANO AND ICALC.CURRENCY=@P_CCY AND ICALC.SDATE=@P_SDATE AND ICALC.EDATE=@P_EDATE AND ICALC.CODE=@P_CODE                
AND RPARTDET.TOR IS NULL AND PCALC.GROSS<>0    
  
Union All                
  
select                
  
Cast(@P_OnMinPremiumF as integer) as OnMinPremiumF,           
  
coalesce(SUM((CASE WHEN RPARTDET.PPCT<>0 THEN RPARTDET.PPCT/100 ELSE (Case When @P_RateConF=1 and (RRateCon.Rate is not null or RateCon.Rate is not null) then 0 else 1 end) END * ICALC.GROSS*(PCALC.PGROSS*@P_PFactor)/PCALC.POGROSS-(ICALC.GROSS*PCALC.PGROSS/PCALC.POGROSS*@P_OPFEEPCT/100))*(100-@Premium_Treaty_Discount)/100*(Case When RPARTDET.COMMN=0 Then RPARTDET.COMM/100 else (Case When RCover.NetRateF=1 or @P_ONGROSSNET=2 OR (@P_ONGROSSNET=0 AND (100-@Premium_OutGo)/100*(100-RPARTDET.CommN)/100<(100-RPARTDET.COMM)/100) Then (100-@Premium_OutGo)/100*(RPARTDET.CommN)/100 else RPARTDET.COMM/100 end) end)),0) AS COMM_1,                
coalesce(SUM((Case When @P_RateConF=1 Then (Case When RRateCon.Rate is null then RateCon.Rate*(Case When RateCon.Loading<>0 then RateCon.Loading/100 else RCover.Loading end) else RRateCon.Rate/PCalc.RiskNum*(Case When RRateCon.Loading<>0 then RRateCon.Loading/100 else RCover.Loading end) end) Else coalesce(@P_NETRATEDet,RPartDet.NetRate*datediff(day,@P_Sdate, @P_EDate)/datediff(day,@P_ASdate, @P_AEDate)) end/100*(100-RCover.Discount)/100*ICALC.GROSS/PCALC.GROSS*ICALC.PRORATA *ICALC.TSI*(CASE WHEN RCOVER.PCALC='S' OR RCOVER.PCTLOSS=0 THEN 100 ELSE RCOVER.PCTLOSS END)/(CASE WHEN RCOVER.PCTLOSS=0 THEN 100 ELSE RCOVER.PCTLOSS END+RCOVER.PAddition)*ICALC.PCTADJ/100-(ICALC.GROSS*PCALC.PGROSS/PCALC.POGROSS*@P_OPFEEPCT/100))*(Case When RPARTDET.COMMN=0 Then RPARTDET.COMM/100 else (Case When RCover.NetRateF=1 or @P_ONGROSSNET=2 OR (@P_ONGROSSNET=0 AND (100-@Premium_OutGo)/100*(100-RPARTDET.CommN)/100<(100-RPARTDET.COMM)/100) Then (100-@Premium_OutGo)/100*(RPARTDET.CommN)/100 else RPARTDET.COMM/100 end) end)),0) AS COMM_2,                    
                
coalesce(SUM((CASE WHEN RPARTDET.PPCT<>0 THEN RPARTDET.PPCT/100 ELSE (Case When @P_RateConF=1 and (RRateCon.Rate is not null or RateCon.Rate is not null) then 0 else 1 end) END * ICALC.GROSS*(PCALC.PGROSS*@P_PFactor)/PCALC.POGROSS)*(100-@Premium_Treaty_Discount)/100*(Case When RPARTDET.COMMN=0 Then 1 else (Case When RCover.NetRateF=1 or @P_ONGROSSNET=2 OR (@P_ONGROSSNET=0 AND (100-@Premium_OutGo)/100*(100-RPARTDET.CommN)/100<(100-RPARTDET.COMM)/100) Then 1 else 1 end) end)-(Case When @P_RITabarruF=1 Then 1 Else 0 end)*(ICALC.GROSS*PCALC.PGROSS/PCALC.POGROSS*@P_OPFEEPCT/100)),0) AS GROSS_1,                
coalesce(SUM((Case When @P_RateConF=1 Then (Case When RRateCon.Rate is null then RateCon.Rate*(Case When RateCon.Loading<>0 then RateCon.Loading/100 else RCover.Loading end) else RRateCon.Rate/PCalc.RiskNum*(Case When RRateCon.Loading<>0 then RRateCon.Loading/100 else RCover.Loading end) end) Else coalesce(@P_NETRATEDet,RPartDet.NetRate*datediff(day,@P_Sdate, @P_EDate)/datediff(day,@P_ASdate, @P_AEDate)) end/100*(100-RCover.Discount)/100*ICALC.GROSS/PCALC.GROSS*ICALC.PRORATA *ICALC.TSI*(CASE WHEN RCOVER.PCALC='S' OR RCOVER.PCTLOSS=0 THEN 100 ELSE RCOVER.PCTLOSS END)/(CASE WHEN RCOVER.PCTLOSS=0 THEN 100 ELSE RCOVER.PCTLOSS END+RCOVER.PAddition)*ICALC.PCTADJ/100)*(Case When RPARTDET.COMMN=0 Then 1 else (Case When RCover.NetRateF=1 or @P_ONGROSSNET=2 OR (@P_ONGROSSNET=0 AND (100-@Premium_OutGo)/100*(100-RPARTDET.CommN)/100<(100-RPARTDET.COMM)/100) Then 1 else 1 end) end)-(Case When @P_RITabarruF=1 Then 1 Else 0 end)*(ICALC.GROSS*PCALC.PGROSS/PCALC.POGROSS*@P_OPFEEPCT/100)),0) AS GROSS_2,                
  
coalesce(SUM((CASE WHEN RPARTDET.PPCT<>0 THEN RPARTDET.PPCT/100 ELSE (Case When @P_RateConF=1 and (RRateCon.Rate is not null or RateCon.Rate is not null) then 0 else 1 end) END * ICALC.GROSS*(PCALC.PGROSS*@P_PFactor)/PCALC.POGROSS-(ICALC.GROSS*PCALC.PGROSS/PCALC.POGROSS*@P_OPFEEPCT/100))*(100-@Premium_Treaty_Discount)/100*(Case When RPARTDET.COMMN=0 Then 0 else (Case When RCover.NetRateF=1 or @P_ONGROSSNET=2 OR (@P_ONGROSSNET=0 AND (100-@Premium_OutGo)/100*(100-RPARTDET.CommN)/100<(100-RPARTDET.COMM)/100) Then (@Premium_OutGo)/100 else 0 end) end)),0) AS DISC_1,                
coalesce(SUM((Case When @P_RateConF=1 Then (Case When RRateCon.Rate is null then RateCon.Rate*(Case When RateCon.Loading<>0 then RateCon.Loading/100 else RCover.Loading end) else RRateCon.Rate/PCalc.RiskNum*(Case When RRateCon.Loading<>0 then RRateCon.Loading/100 else RCover.Loading end) end) Else coalesce(@P_NETRATEDet,RPartDet.NetRate*datediff(day,@P_Sdate, @P_EDate)/datediff(day,@P_ASdate, @P_AEDate)) end/100*(100-RCover.Discount)/100*ICALC.GROSS/PCALC.GROSS*ICALC.PRORATA *ICALC.TSI*(CASE WHEN RCOVER.PCALC='S' OR RCOVER.PCTLOSS=0 THEN 100 ELSE RCOVER.PCTLOSS END)/(CASE WHEN RCOVER.PCTLOSS=0 THEN 100 ELSE RCOVER.PCTLOSS END+RCOVER.PAddition)*ICALC.PCTADJ/100-(ICALC.GROSS*PCALC.PGROSS/PCALC.POGROSS*@P_OPFEEPCT/100))*(Case When RPARTDET.COMMN=0 Then 0 else (Case When RCover.NetRateF=1 or @P_ONGROSSNET=2 OR (@P_ONGROSSNET=0 AND (100-@Premium_OutGo)/100*(100-RPARTDET.CommN)/100<(100-RPARTDET.COMM)/100) Then (@Premium_OutGo)/100 else 0 end) end)),0) AS DISC_2,                    
  
coalesce(SUM((CASE WHEN RPARTDET.PPCT<>0 THEN RPARTDET.PPCT/100 ELSE (Case When @P_RateConF=1 and (RRateCon.Rate is not null or RateCon.Rate is not null) then 0 else 1 end) END * ICALC.GROSS*(PCALC.PGROSS*@P_PFactor)/PCALC.POGROSS)*(100-@Premium_Treaty_Discount)/100*(Case When RPARTDET.COMMN=0 Then 1 else (Case When RCover.NetRateF=1 or @P_ONGROSSNET=2 OR (@P_ONGROSSNET=0 AND (100-@Premium_OutGo)/100*(100-RPARTDET.CommN)/100<(100-RPARTDET.COMM)/100) Then 1 else 1 end) end)*@P_FEE/100-(Case When @P_RITabarruF=0 Then 1 Else 0 end)*(ICALC.GROSS*PCALC.PGROSS/PCALC.POGROSS*@P_OPFEEPCT/100)),0) AS FEE_1,                
coalesce(SUM((Case When @P_RateConF=1 Then (Case When RRateCon.Rate is null then RateCon.Rate*(Case When RateCon.Loading<>0 then RateCon.Loading/100 else RCover.Loading end) else RRateCon.Rate/PCalc.RiskNum*(Case When RRateCon.Loading<>0 then RRateCon.Loading/100 else RCover.Loading end) end) Else coalesce(@P_NETRATEDet,RPartDet.NetRate*datediff(day,@P_Sdate, @P_EDate)/datediff(day,@P_ASdate, @P_AEDate)) end/100*(100-RCover.Discount)/100*ICALC.GROSS/PCALC.GROSS*ICALC.PRORATA *ICALC.TSI*(CASE WHEN RCOVER.PCALC='S' OR RCOVER.PCTLOSS=0 THEN 100 ELSE RCOVER.PCTLOSS END)/(CASE WHEN RCOVER.PCTLOSS=0 THEN 100 ELSE RCOVER.PCTLOSS END+RCOVER.PAddition)*ICALC.PCTADJ/100)*(Case When RPARTDET.COMMN=0 Then 1 else (Case When RCover.NetRateF=1 or @P_ONGROSSNET=2 OR (@P_ONGROSSNET=0 AND (100-@Premium_OutGo)/100*(100-RPARTDET.CommN)/100<(100-RPARTDET.COMM)/100) Then 1 else 1 end) end)*@P_FEE/100-(Case When @P_RITabarruF=0 Then 1 Else 0 end)*(ICALC.GROSS*PCALC.PGROSS/PCALC.POGROSS*@P_OPFEEPCT/100)),0) AS FEE_2    
  
FROM ICALC     
INNER JOIN ACCEPTANCE SACCEPTANCE ON (SACCEPTANCE.ANO=ICALC.SANO)    
INNER JOIN RCOVER ON (RCOVER.ANO=ICALC.SANO AND RCOVER.CODE=ICALC.CODE AND (RCOVER.SDATE=ICALC.SDATE OR (@P_AType='A' AND (CASE WHEN RCOVER.SDATE<SACCEPTANCE.PDATE THEN SACCEPTANCE.PDATE ELSE RCOVER.SDATE END)=ICALC.SDATE)))    
INNER JOIN RPARTDET ON (RPARTDET.RNO=@P_RNO AND RPARTDET.ID=@P_ID AND RPARTDET.DocNo=@P_DocNo AND RPARTDET.TOR=ICALC.TOR AND (RPARTDET.NOFYEARS=0 OR RPARTDET.NOFYEARS=@P_NOFYEARS) and RPARTDET.EXCLUDEF=0)    
LEFT Join FN_RateCon(@P_ANO, @P_CODE,@P_TSI,@P_ASDate) RateCon On (@P_RateConF=1 and RateCon.Code=ICalc.Code)    
LEFT Join FN_RRateCon(@P_ANO, @P_RID, @P_TSI) RRateCon On (@P_RateConF=1)                
INNER JOIN ICOVER ON (ICOVER.INO=ICALC.INO AND (ICOVER.ADJUSTABLE=@P_ADJUSTABLEF OR @P_AType='A'))    
INNER JOIN RCALC ON (RCALC.ANO=ICALC.ANO AND RCALC.CURRENCY=ICALC.CURRENCY AND RCALC.CODE=ICALC.CODE AND RCALC.TOR=ICALC.TOR AND RCALC.SDATE=ICALC.SDATE AND RCALC.EDATE=ICALC.EDATE AND RCALC.SANO=ICALC.SANO AND RCALC.EXTREATYF=0)    
INNER JOIN PCALC_ANNUM(@P_ANO) PCALC ON (PCALC.ANO=ICALC.ANO AND PCALC.CODE=ICALC.CODE AND PCALC.SDATE=ICALC.SDATE AND PCALC.EDATE=ICALC.EDATE AND PCALC.INO=ICALC.INO AND PCALC.CURRENCY=ICALC.CURRENCY)    
WHERE ICALC.ANO=@P_ANO AND ICALC.CURRENCY=@P_CCY AND ICALC.SDATE=@P_SDATE AND ICALC.EDATE=@P_EDATE AND ICALC.CODE=@P_CODE                
AND PCALC.GROSS<>0    
  
) R          

GO
DROP FUNCTION PREMIUM_CALCULATION_FACTOR
GO
CREATE FUNCTION PREMIUM_CALCULATION_FACTOR(@P_ANO int)    
RETURNS TABLE  AS    
RETURN (    
Select ANO, Currency, sum(Premium) as Premium    
                                
from(    
 Select ANO, Currency, sum(Premium) as Premium    
                        
 from (    
  select Acceptance.ANO, RCalc.Currency,    
  case    
  When Acceptance.AType<>'N' then    
   case    
   when DateDiff(day, acceptance.pdate, rcalc.SDate)>0 then 1    
   when DateDiff(day, rcalc.Edate, acceptance.pdate)>=0 then 0    
   Else    
    case    
    when acceptance.cpct<>0 or Cover.Voyage=1 then    
     case    
     when acceptance.cpct<>0 then    
      acceptance.cpct/100    
     Else    
		1    
     End    
    Else         
	 	--Prorata Calculation
		Case When Acceptance.EXCLUSIVEF=0 and Acceptance.STime<Acceptance.ETime and RCalc.EDate=Acceptance.EDate Then
			dbo.fn_calc_prorata(acceptance.pDate, dateadd(day,1,RCalc.edate), RCalc.Sdate, dateadd(day,1,RCalc.edate), Cover.PPeriod)
		else
			dbo.fn_calc_prorata(acceptance.pDate, RCalc.Edate, RCalc.Sdate, RCalc.EDate, Cover.PPeriod)
		End
    End    
   End    
  Else    
	1    
  End    
  * (Case When Acceptance.Qty=0 Then 1 else Acceptance.Qty end)    
  * (Case When PCalc.Description='Minimum Premium' Then RCalc.Gross/PCalc.Gross else (Case When PCalc.Gross=0 then 0 else Case When PCalc.OGross=0 Then 1 else RCalc.OGross*(case When Pcalc.TSI=0 then 1 else PCalc.Ourshare/PCalc.TSI end) * 1/PCalc.OGross end end) end+RCalc.Reinstatement) as Premium         
  From RCALC, PCALC, acceptance, cover, RCOVER    
  Where Acceptance.ANO=@P_ANO AND Cover.CNO=Acceptance.CNO    
  and RCOVER.ANO=RCALC.ANO AND RCOVER.CODE=RCALC.CODE AND RCOVER.SDATE=RCALC.SDATE    
  and RCalc.ANO=Acceptance.ANO and PCalc.ANO=RCalc.ANO and PCalc.Currency=RCalc.Currency    
  and Acceptance.AType not in ('A','C')    
  and not (Acceptance.Atype<>'N' and Acceptance.NoRefundF<>12 and not (Acceptance.NoRefundF=13 and charindex((case when Acceptance.ISType in ('I','L') Then 'DI' else 'I'+Acceptance.ISType end),Acceptance.RefundType)<>0) and (RCover.NoRefundF=1 or Acceptance.NoRefundF in (2,4) or (Acceptance.NoRefundF in (1) and DateDiff(day, acceptance.pdate, RCalc.SDate) <= 0)))
  and RCalc.Gross<>0    
                                      
  Union All    
                                                                      
  select Acceptance.ANO, RCalc.Currency,    
  (Case When PCalc.Description='Minimum Premium' Then RCalc.Gross/PCalc.Gross else (Case When PCalc.Gross=0 then 0 else Case When PCalc.OGross=0 Then 1 else RCalc.OGross*1/PCalc.OGross end end) end+RCalc.Reinstatement)*coalesce(sISource.Share/100,(case When Pcalc.TSI=0 then 1 else PCalc.Ourshare/PCalc.TSI end)) as Premium
  From Acceptance
  Inner Join RCALC on (RCAlc.ANO=Acceptance.ANO)
  Left Join Acceptance sAcceptance on (sAcceptance.ANO=RCalc.SANO) 
  Left Join AISource sISource on (sISource.ANO=sAcceptance.ANO)
  Inner Join PCalc on (PCalc.ANO=RCalc.ANO and PCalc.Currency=RCalc.Currency)
  Where Acceptance.ANO=@P_ANO and Acceptance.AType='A'            
 ) T    
                        
 Group By ANO, Currency    
                                                                                   
) T    
                                
Group By ANO, Currency    
                                    
                                    
)    

GO
DROP PROCEDURE List10
GO
CREATE PROCEDURE List10(@P_TOC as varchar(10), @P_Branch as varchar(10), @P_PolicyNO as varchar(50), @P_SDate as smalldatetime, @P_EDate as smalldatetime, @P_AStatus as varchar(1), @P_RefNo as varchar(50)='', @P_RegNo as varchar(50)='', @P_RType as varchar(10)='', @P_ID as varchar(10)='', @P_BSID as varchar(10)='')             
AS            
SELECT Cast(0 as bit) as ProcessFlag, Acceptance.ANO AS ANO,             
 Cover.CNO,            
 Cover.CoverDate,            
 Cover.ExpDate,            
 Cast(Acceptance.AName as varchar(128)) as Insured,            
 Cover.UserID,            
 Cover.CStatus,            
 ISource.RType,          
 Acceptance.PolicyNo, 
 Acceptance.RefNo, 
 Acceptance.RegNo,             
 Profile.Name,             
 Acceptance.AStatus,             
 TOC.Description,             
 Acceptance.Branch, 
 ISource.Share, 
 ISource.Fee
FROM  Cover
Inner Join Acceptance on (Acceptance.CNO=Cover.CNO and Acceptance.ANO=Acceptance.LANO)
Inner join AISource ISource on (ISource.ANO=Acceptance.ANO)
Inner join Payor on (Payor.ANO=Acceptance.ANO)
Inner Join Profile on (Profile.ID=Payor.ID)
Inner join TOC on (TOC.TOC=Acceptance.TOC)
Left Join AccBS A3 on (A3.ANO=Acceptance.ANO and A3.BSType='B')        
WHERE  Cover.ISType='T' and Cover.ProformaF=0  
 And TOC.TOC Like @P_TOC+'%'        
 And Acceptance.Branch Like @P_Branch+'%'        
 And Acceptance.PolicyNo Like @P_PolicyNo +'%'        
 And Acceptance.RegNo Like @P_RegNo +'%'        
 And Acceptance.RefNo Like @P_RefNo +'%'        
 And (Acceptance.AStatus=@P_AStatus or @P_AStatus='')    
 And (@P_SDate between Cover.CoverDate and Cover.ExpDate  or @P_EDate between Cover.CoverDate and Cover.ExpDate or Cover.CoverDate Between @P_SDate and @P_EDate or Cover.ExpDate Between @P_SDate and @P_EDate)      
 and ISource.RType Like @P_RType+'%'
 and ISource.ID Like @P_ID +'%'
 and coalesce(A3.ID,'') Like @P_BSID + '%'
 order by ACCEPTANCE.RegNo 

 GO
DROP Procedure Treaty_Premium_Commission
GO
CREATE Procedure Treaty_Premium_Commission(@P_ANO integer,@P_Code varchar(10),@P_CCY varchar(10), @P_SDate smalldatetime, @P_EDate smalldatetime,@P_RID varchar(255),@P_AdjustableF Bit,@P_TSI Float=0, @P_ID varchar(10)='', @P_DocNo varchar(50)='')    
as    
Declare @Premium_Treaty_Discount as Float            
Declare @Premium_Discount as Float            
Declare @Premium_Commission as Float            
Declare @Premium_Commission_Inward as Float            
Declare @Premium_Fee as Float            
Declare @Premium_OutGo as Float            
Declare @P_TOC as varchar(10)    
Declare @P_AType as varchar(1)    
Declare @P_ONGROSSNet as int    
Declare @P_RateConF as Bit    
Declare @P_NETRATEDet as Float    
Declare @P_NOFYEARS as Int    
Declare @P_COMM as Float    
Declare @P_COMMN as Float    
Declare @P_COMM_C as Float    
Declare @P_COMMN_C as Float    
Declare @P_OnNetPremiumF as Bit    
Declare @P_RNO as int    
Declare @P_RType as varchar(10)        
Declare @P_OPFEEPCT as Float    
Declare @P_OANO as int    
Declare @P_COMMPOLICYF as Bit    
Declare @P_PFactor as Float  
Declare @P_IFee as Float  
Declare @P_Period as Int  
Declare @P_Tabarru as Float  
Declare @P_RITabarruF as Bit  
Declare @P_UjrohCedant as Float
Declare @P_UjrohReins as Float
Declare @P_OPFEEF as Bit  

Declare @P_ASDate as SmallDatetime
Declare @P_AEDate as SmallDatetime
Declare @P_LANO as Int

Select     
@P_Period=cast(datediff(Month,A.SDate, @P_SDate) as integer) / 12 + 1,  
@P_ASDate=A.SDate,
@P_AEDate=A.EDate, 
@P_NOFYEARS=datediff(year,A.sdate, A.edate),     
@P_TOC=A.TOC,     
@P_AType=A.AType,     
@P_ONGROSSNET=R.ONGROSSNET,     
@P_RateConF=R3.RateConF,     
@P_NETRATEDet=R4.NETRATE,    
@P_COMM=CASE WHEN R3.COMM<>0 Then R3.COMM ELSE R2.COMM END,    
@P_COMMN=CASE WHEN R3.COMMN<>0 Then R3.COMMN ELSE R2.COMMN END,
@P_COMM_C=R3.COMM,
@P_COMMN_C=R3.COMMN,
@P_OnNetPremiumF=R2.OnNetPremiumF,     
@P_RNO=R1.RNO,    
@P_RType=R1.RType,    
@P_OANO=A.OANO,    
@P_COMMPOLICYF=R2.COMMPOLICYF,  
@P_PFactor=Case When A.ISType='R' Then (100-I.UJrohCedant)/100*(100+I.UjrohReins)/100 else 1 end,  
@Premium_Commission_Inward=coalesce(I2.Fee+I2.HF,coalesce(I.Fee+I.HF,0))+coalesce(I.OC,0),  
@P_Tabarru=(100-A.Ujroh),  
@P_UjrohCedant=R1.UJROHCEDANT,
@P_UjrohReins=R1.UJROHREINS,
@P_OPFEEF=R3.OPFEEF,
@P_LANO=A.LANO
from Acceptance A  
Inner Join RarrHeader R on (R.ANO=A.ANO)  
Inner Join Cover C on (C.CNO=A.CNO)  
Left Join AISource I on (I.ANO=A.ANO)  
Left Join AISourceDet I2 on (I2.ANO=I.ANO and I2.Code=@P_Code)  
Inner Join Reinsurance R1 on (R1.RID=@P_RID)  
Cross Apply (Select Top 1 COMM, COMMN, OnNetPremiumF, COMMPOLICYF from RPart R2 Where R2.RNO=R1.RNO ) R2
Inner Join ReClass R3 on (R3.RNO=R1.RNO and R3.TOC=A.TOC)  
Left Join ReClassDet R4 on (R4.RNO=R3.RNO AND R4.TOC=R3.TOC AND R4.CODE=@P_CODE)    
Where A.ANO=@P_ANO  

if @P_OnNetPremiumF=1  
 Select @Premium_Treaty_Discount=dbo.Premium_Treaty_Discount(@P_ANO, @P_Code,@P_Period)            
else  
 Select @Premium_Treaty_Discount=0  
  
if @P_COMMN<>0  
Begin  
 Select @Premium_Discount=dbo.premium_discount(@P_ANO, @P_Code, @P_Period)    
 Select @Premium_Fee=dbo.Premium_Fee(@P_ANO, @P_Period)    
End  
else  
Begin  
 Select @Premium_Discount=0  
 Select @Premium_Fee=0  
End  
  
if @P_COMMN<>0 or (@P_COMMPOLICYF=1 and @P_COMM=0 and @P_COMMN=0)  
 Select @Premium_Commission=dbo.Premium_Commission(@P_ANO, @P_Code, @P_Period,0)+dbo.Premium_MaxOutGo_Vat(@P_ANO, @P_Code, @P_Period,0)    
Else  
 Select @Premium_Commission=0  
  
Select @Premium_outGo=@Premium_Discount+@Premium_Commission+@Premium_Commission_Inward+@Premium_Fee-(Case When @P_OnNetPremiumF=1 Then @Premium_Treaty_Discount else 0 end)  
Select @P_COMM=CASE WHEN @P_COMMPOLICYF=1 and @P_COMM=0 and @P_COMMN=0 Then @Premium_Commission ELSE @P_COMM END    

SELECT @P_OPFEEPCT=Case When ROUND(COALESCE(SUM(Gross),0),4)<>0 Then COALESCE(SUM(FEE),0)/ROUND(COALESCE(SUM(Gross),0),4)*100 Else 0 End, @P_RITabarruF=coalesce(cast(Max(cast(RITabarruF as Int)) as Bit),0)  
FROM  
(  
	SELECT  
	A2.ANO,  
	Premium.Gross,
	Case   
	When coalesce(A1.Amount,0)<>0 Then  
		A1.Amount*Case When A1.RITabarruF=1 Then cast(100 as Float)/@P_Tabarru Else 1 end 
	When coalesce(A1.AmountPCT,0)<>0 then
		(Premium.Gross)*A1.AmountPCT/100*Case When A1.RITabarruF=1 Then cast(100 as Float)/@P_Tabarru Else 1 end 	
	Else
		0
	End as Fee,
	coalesce(A1.RITabarruF,cast(0 as Bit)) as RITabarruF
	from   
	Acceptance A2  
	INNER Join PCalc on (PCalc.ANO=A2.ANO and PCalc.Currency=@P_CCY)  
	Outer Apply (
		Select
		sum(case When A1.PolicyYear<>0 then 
			A1.Amount*case When A1.ContributionF=1 Then 1 Else 100/coalesce(R.PCTSHARE-R.MSHARE,100) End
		else 
			A1.Amount*case When A1.ContributionF=1 Then 1 Else 100/coalesce(R.PCTSHARE-R.MSHARE,100) End*cast(dbo.fn_Premium_Calc_Prorata(@P_SDate, @P_EDate, 0,1,2) as Float)/cast(dbo.fn_Premium_Calc_Prorata(@P_ASDate, @P_AEDate,0,1,2) as Float)
		End) as Amount,
		sum(A1.AMOUNTPCT) as AMOUNTPCT, MAX(A1.AMOUNTPCTBASED) as AMOUNTPCTBASED, Cast(MAX(Cast(A1.RITabarruF as Int)) as Bit) as RITabarruF
		from AccFD A1
		Inner Join RArrHeader R on (R.ANO=A2.ANO)
		Inner Join FDTAB on (FDTAB.FDID=A1.FDID and Left(FDTAB.FDType,1)='O')
		Where A1.ANO=A2.ANO and A1.Currency=PCalc.Currency and (A1.ContributionF=1 or A1.CessionF=1) and A1.AmountPCTBased in (0,3) And (A1.PolicyYear=0 or A1.PolicyYear=@P_Period)
	) A1
	Outer APPLY
	(
		Select coalesce(sum(Gross),0) as Gross
		from
		(
			Select   
			Case			
			When coalesce(A1.AMOUNTPCTBASED,0)<>3 then
				D1.Gross*D1.Prorata*P.Gross/P.OGross
			else
				D1.Gross*D1.Prorata*P.Gross/P.OGross*(100-D1.Discount-D1.Commission)/100
			End as Gross
			from Display_Calculation(A2.ANO) D1  
			Inner Join Acceptance A on (A.ANO=D1.ANO)  
			Inner Join PCalc P on (P.ANO=D1.ANO and P.Currency=D1.Currency)  
			Where D1.Currency=@P_CCY  
			and (@P_Period=0 or (D1.SDate>=dateadd(month,12*(@P_Period-1),A.SDate) and D1.SDate<dateadd(month,12*(@P_Period),A.SDate)))
		) Premium
	) Premium
   	Where @P_RType in ('Q','S1','S2','S3','A') and A2.OANO=@P_OANO and A2.ANO<=@P_ANO    
	and A2.ANO>(Select coalesce(Max(ANO),0) from Acceptance Where AType='C' and EMethod='A' and Acceptance.OANO=@P_OANO and Acceptance.ANO<=@P_ANO and AStatus not in ('W','T'))  


	Union All  
  
	--Op Fee from Master Policy  
	SELECT  
	A2.ANO,  
	0 as Gross,
	Case   
	When coalesce(A1.Amount,0)<>0 Then  
	--Not Yet for Master Policy  
		0  
	When coalesce(A1.AmountPCT,0)<>0 Then  
		(Premium.Gross)*A1.AmountPCT/100*Case When A1.RITabarruF=1 Then cast(100 as Float)/@P_Tabarru Else 1 end 	
	Else
		0
	End as Fee,
	coalesce(A1.RITabarruF,cast(0 as Bit)) as RITabarruF
	from   
	Acceptance A2  
	INNER Join PCalc on (PCalc.ANO=A2.ANO and PCalc.Currency=@P_CCY)  
	INNER JOIN Acceptance MA on (MA.PolicyNo<>'' and MA.RegNo=A2.RegNo and MA.ANO=MA.LANO)  
	INNER JOIN COVER C on (C.CNO=MA.CNO and C.OPENFLAG=0)  
	Outer Apply (
		Select 
		sum(case When A1.PolicyYear<>0 then 
			A1.Amount*case When A1.ContributionF=1 Then 1 Else 100/coalesce(R.PCTSHARE-R.MSHARE,100) End
		else 
			A1.Amount*case When A1.ContributionF=1 Then 1 Else 100/coalesce(R.PCTSHARE-R.MSHARE,100) End*cast(dbo.fn_Premium_Calc_Prorata(@P_SDate, @P_EDate, 0,1,2) as Float)/cast(dbo.fn_Premium_Calc_Prorata(@P_ASDate, @P_AEDate,0,1,2) as Float)
		End) as Amount,
		sum(A1.AMOUNTPCT) as AMOUNTPCT, MAX(A1.AMOUNTPCTBASED) as AMOUNTPCTBASED, Cast(MAX(Cast(A1.RITabarruF as Int)) as Bit) as RITabarruF
		from AccFD A1
		Inner Join RArrHeader R on (R.ANO=A2.ANO)
		Inner Join FDTAB on (FDTAB.FDID=A1.FDID and Left(FDTAB.FDType,1)='O')
		Where A1.ANO=MA.ANO and A1.Currency=PCalc.Currency and (A1.ContributionF=1 or A1.CessionF=1) and A1.AmountPCTBased in (0,3) And (A1.PolicyYear=0 or A1.PolicyYear=@P_Period)
	) A1
	Outer APPLY
	(
		Select coalesce(sum(Gross),0) as Gross
		from
		(
			Select   
			Case			
			When coalesce(A1.AMOUNTPCTBASED,0)<>3 then
				D1.Gross*D1.Prorata*P.Gross/P.OGross
			else
				D1.Gross*D1.Prorata*P.Gross/P.OGross*(100-D1.Discount-D1.Commission)/100
			End as Gross
			from Display_Calculation(A2.ANO) D1  
			Inner Join Acceptance A on (A.ANO=D1.ANO)  
			Inner Join PCalc P on (P.ANO=D1.ANO and P.Currency=D1.Currency)  
			Where D1.Currency=@P_CCY  
			and (@P_Period=0 or (D1.SDate>=dateadd(month,12*(@P_Period-1),A.SDate) and D1.SDate<dateadd(month,12*(@P_Period),A.SDate)))
		) Premium
	) Premium
	Where @P_LANO<>-1 and @P_RType in ('Q','S1','S2','S3','A') and A2.OANO=@P_OANO and A2.ANO<=@P_ANO    
	and A2.ANO>(Select coalesce(Max(ANO),0) from Acceptance Where AType='C' and EMethod='A' and Acceptance.OANO=@P_OANO and Acceptance.ANO<=@P_ANO and AStatus not in ('W','T'))  
) A  
Where @P_OPFEEF=1  

--In Base Currency
Select 
	sum(R.Premium*R.Share/100*R.Rate) as Premium,
	sum(R.UjrohCedant*R.Share/100*R.Rate) as UjrohCedant,
	sum(R.UjrohReins*R.Share/100*R.Rate) as UjrohReins,
	sum(R.Commission*R.Share/100*R.Rate) as Commission,
	sum(R.Discount*R.Share/100*R.Rate) as Discount,
	sum(R.Fee*R.Share/100*R.Rate) as Fee
from
(
	Select
	R.ID, 
	R.DocNo,
	Max(R.Rate) as Rate,
	Max(R.Share) as Share,
	sum(Case When OnMinPremiumF=0 Then (case When Gross_1>Gross_2 then Gross_1 else Gross_2 end) else (case When Gross_1<Gross_2 and Gross_1<>0 then Gross_1 else Gross_2 end) end) as Premium,           
	sum(Case When OnMinPremiumF=0 Then (case When Gross_1>Gross_2 then Gross_1 else Gross_2 end) else (case When Gross_1<Gross_2 and Gross_1<>0 then Gross_1 else Gross_2 end) end)*@P_UjrohCedant/100 as UjrohCedant,           
	sum(Case When OnMinPremiumF=0 Then (case When Gross_1>Gross_2 then Gross_1 else Gross_2 end) else (case When Gross_1<Gross_2 and Gross_1<>0 then Gross_1 else Gross_2 end) end)*(100-@P_UjrohCedant)/100*@P_UjrohReins/100 as UjrohReins,           
	sum(Case When OnMinPremiumF=0 Then (case When Gross_1>Gross_2 then Comm_1 else Comm_2 end) else (case When Gross_1<Gross_2 and Gross_1<>0 then Comm_1 else Comm_2 end) end) as Commission,         
	sum(Case When OnMinPremiumF=0 Then (case When Gross_1>Gross_2 then Disc_1 else Disc_2 end) else (case When Gross_1<Gross_2 and Gross_1<>0 then Disc_1 else Disc_2 end) end) as Discount,  
	sum(Case When OnMinPremiumF=0 Then (case When Gross_1>Gross_2 then Fee_1 else Fee_2 end) else (case When Gross_1<Gross_2 and Gross_1<>0 then Fee_1 else Fee_2 end) end) as Fee              
	From          
	(
		select            
		RPart.ID,
		RPart.DocNo,
		Max(PCalc.Rate) as Rate,
		Max(RPart.Share-RPart.JP) as Share,
		cast(Max(Cast(RPart.OnMinPremiumF as integer)) as Bit) as OnMinPremiumF,              

		coalesce(SUM((CASE WHEN RPART.PPCT<>0 THEN RPART.PPCT/100 ELSE (Case When @P_RateConF=1 and (RRateCon.Rate is not null or RateCon.Rate is not null) then 0 else 1 end) END * ICALC.GROSS*(PCALC.PGROSS*@P_PFactor)/PCALC.POGROSS*(100-@Premium_Treaty_Discount)/100-(ICALC.GROSS*PCALC.PGROSS/PCALC.POGROSS*@P_OPFEEPCT/100))*(Case When (CASE WHEN @P_COMMN_C<>0 Then @P_COMMN_C ELSE RPART.COMMN END)=0 Then (CASE WHEN @P_COMM_C<>0 Then @P_COMM_C WHEN RPART.COMM<>0 THEN RPART.COMM ELSE @P_COMM END)/100 else (Case When RCover.NetRateF=1 or @P_ONGROSSNET=2 OR (@P_ONGROSSNET=0 AND (100-@Premium_OutGo)/100*(100-(CASE WHEN @P_COMMN_C<>0 Then @P_COMMN_C ELSE RPART.COMMN END))/100<(100-(CASE WHEN @P_COMM_C<>0 Then @P_COMM_C WHEN RPART.COMM<>0 THEN RPART.COMM ELSE @P_COMM END))/100) Then (100-@Premium_OutGo)/100*((CASE WHEN @P_COMMN_C<>0 Then @P_COMMN_C ELSE RPART.COMMN END))/100 else (CASE WHEN @P_COMM_C<>0 Then @P_COMM_C WHEN RPART.COMM<>0 THEN RPART.COMM ELSE @P_COMM END)/100 end) end)),0) AS COMM_1,                
		coalesce(SUM((Case When @P_RateConF=1 Then (Case When RRateCon.Rate is null then RateCon.Rate*(Case When RateCon.Loading<>0 then RateCon.Loading/100 else RCover.Loading end) else RRateCon.Rate/PCalc.RiskNum*(Case When RRateCon.Loading<>0 then RRateCon.Loading/100 else RCover.Loading end) end) Else coalesce(@P_NETRATEDet,RPART.NETRATE/PCalc.RiskNum) end/100*(100-RCover.Discount)/100*ICALC.GROSS/PCALC.GROSS*ICALC.PRORATA *ICALC.TSI*(CASE WHEN RCOVER.PCALC='S' OR RCOVER.PCTLOSS=0 THEN 100 ELSE RCOVER.PCTLOSS END)/(CASE WHEN RCOVER.PCTLOSS=0 THEN 100 ELSE RCOVER.PCTLOSS END+RCOVER.PAddition)*ICALC.PCTADJ/100-(ICALC.GROSS*PCALC.PGROSS/PCALC.POGROSS*@P_OPFEEPCT/100))*(Case When (CASE WHEN @P_COMMN_C<>0 Then @P_COMMN_C ELSE RPART.COMMN END)=0 Then (CASE WHEN @P_COMM_C<>0 Then @P_COMM_C WHEN RPART.COMM<>0 THEN RPART.COMM ELSE @P_COMM END)/100 else (Case When RCover.NetRateF=1 or @P_ONGROSSNET=2 OR (@P_ONGROSSNET=0 AND (100-@Premium_OutGo)/100*(100-(CASE WHEN @P_COMMN_C<>0 Then @P_COMMN_C ELSE RPART.COMMN END))/100<(100-(CASE WHEN @P_COMM_C<>0 Then @P_COMM_C WHEN RPART.COMM<>0 THEN RPART.COMM ELSE @P_COMM END))/100) Then (100-@Premium_OutGo)/100*((CASE WHEN @P_COMMN_C<>0 Then @P_COMMN_C ELSE RPART.COMMN END))/100 else (CASE WHEN @P_COMM_C<>0 Then @P_COMM_C WHEN RPART.COMM<>0 THEN RPART.COMM ELSE @P_COMM END)/100 end) end)),0) AS COMM_2,                
  
		coalesce(SUM((CASE WHEN RPART.PPCT<>0 THEN RPART.PPCT/100 ELSE (Case When @P_RateConF=1 and (RRateCon.Rate is not null or RateCon.Rate is not null) then 0 else 1 end) END * ICALC.GROSS*(PCALC.PGROSS*@P_PFactor)/PCALC.POGROSS*(100-@Premium_Treaty_Discount)/100)*(Case When (CASE WHEN @P_COMMN_C<>0 Then @P_COMMN_C ELSE RPART.COMMN END)=0 Then 1 else (Case When RCover.NetRateF=1 or @P_ONGROSSNET=2 OR (@P_ONGROSSNET=0 AND (100-@Premium_OutGo)/100*(100-(CASE WHEN @P_COMMN_C<>0 Then @P_COMMN_C ELSE RPART.COMMN END))/100<(100-(CASE WHEN @P_COMM_C<>0 Then @P_COMM_C WHEN RPART.COMM<>0 THEN RPART.COMM ELSE @P_COMM END))/100) Then 1 else 1 end) end)-(Case When @P_RITabarruF=1 Then 1 Else 0 end)*(ICALC.GROSS*PCALC.PGROSS/PCALC.POGROSS*@P_OPFEEPCT/100)),0) AS GROSS_1,              
		coalesce(SUM((Case When @P_RateConF=1 Then (Case When RRateCon.Rate is null then RateCon.Rate*(Case When RateCon.Loading<>0 then RateCon.Loading/100 else RCover.Loading end) else RRateCon.Rate/PCalc.RiskNum*(Case When RRateCon.Loading<>0 then RRateCon.Loading/100 else RCover.Loading end) end) Else coalesce(@P_NETRATEDet,RPART.NETRATE/PCalc.RiskNum) end/100*(100-RCover.Discount)/100*ICALC.GROSS/PCALC.GROSS*ICALC.PRORATA *ICALC.TSI*(CASE WHEN RCOVER.PCALC='S' OR RCOVER.PCTLOSS=0 THEN 100 ELSE RCOVER.PCTLOSS END)/(CASE WHEN RCOVER.PCTLOSS=0 THEN 100 ELSE RCOVER.PCTLOSS END+RCOVER.PAddition)*ICALC.PCTADJ/100)*(Case When (CASE WHEN @P_COMMN_C<>0 Then @P_COMMN_C ELSE RPART.COMMN END)=0 Then 1 else (Case When RCover.NetRateF=1 or @P_ONGROSSNET=2 OR (@P_ONGROSSNET=0 AND (100-@Premium_OutGo)/100*(100-(CASE WHEN @P_COMMN_C<>0 Then @P_COMMN_C ELSE RPART.COMMN END))/100<(100-(CASE WHEN @P_COMM_C<>0 Then @P_COMM_C WHEN RPART.COMM<>0 THEN RPART.COMM ELSE @P_COMM END))/100) Then 1 else 1 end) end)-(Case When @P_RITabarruF=1 Then 1 Else 0 end)*(ICALC.GROSS*PCALC.PGROSS/PCALC.POGROSS*@P_OPFEEPCT/100)),0) AS GROSS_2,                
               
		coalesce(SUM((CASE WHEN RPART.PPCT<>0 THEN RPART.PPCT/100 ELSE (Case When @P_RateConF=1 and (RRateCon.Rate is not null or RateCon.Rate is not null) then 0 else 1 end) END * ICALC.GROSS*(PCALC.PGROSS*@P_PFactor)/PCALC.POGROSS*(100-@Premium_Treaty_Discount)/100-(ICALC.GROSS*PCALC.PGROSS/PCALC.POGROSS*@P_OPFEEPCT/100))*(Case When (CASE WHEN @P_COMMN_C<>0 Then @P_COMMN_C ELSE RPART.COMMN END)=0 Then 0 else (Case When RCover.NetRateF=1 or @P_ONGROSSNET=2 OR (@P_ONGROSSNET=0 AND (100-@Premium_OutGo)/100*(100-(CASE WHEN @P_COMMN_C<>0 Then @P_COMMN_C ELSE RPART.COMMN END))/100<(100-(CASE WHEN @P_COMM_C<>0 Then @P_COMM_C WHEN RPART.COMM<>0 THEN RPART.COMM ELSE @P_COMM END))/100) Then (@Premium_OutGo)/100 else 0 end) end)),0) AS DISC_1,                
		coalesce(SUM((Case When @P_RateConF=1 Then (Case When RRateCon.Rate is null then RateCon.Rate*(Case When RateCon.Loading<>0 then RateCon.Loading/100 else RCover.Loading end) else RRateCon.Rate/PCalc.RiskNum*(Case When RRateCon.Loading<>0 then RRateCon.Loading/100 else RCover.Loading end) end) Else coalesce(@P_NETRATEDet,RPART.NETRATE/PCalc.RiskNum) end/100*(100-RCover.Discount)/100*ICALC.GROSS/PCALC.GROSS*ICALC.PRORATA *ICALC.TSI*(CASE WHEN RCOVER.PCALC='S' OR RCOVER.PCTLOSS=0 THEN 100 ELSE RCOVER.PCTLOSS END)/(CASE WHEN RCOVER.PCTLOSS=0 THEN 100 ELSE RCOVER.PCTLOSS END+RCOVER.PAddition)*ICALC.PCTADJ/100-(ICALC.GROSS*PCALC.PGROSS/PCALC.POGROSS*@P_OPFEEPCT/100))*(Case When (CASE WHEN @P_COMMN_C<>0 Then @P_COMMN_C ELSE RPART.COMMN END)=0 Then 0 else (Case When RCover.NetRateF=1 or @P_ONGROSSNET=2 OR (@P_ONGROSSNET=0 AND (100-@Premium_OutGo)/100*(100-(CASE WHEN @P_COMMN_C<>0 Then @P_COMMN_C ELSE RPART.COMMN END))/100<(100-(CASE WHEN @P_COMM_C<>0 Then @P_COMM_C WHEN RPART.COMM<>0 THEN RPART.COMM ELSE @P_COMM END))/100) Then (@Premium_OutGo)/100 else 0 end) end)),0) AS DISC_2,    
  
		coalesce(SUM((CASE WHEN RPART.PPCT<>0 THEN RPART.PPCT/100 ELSE (Case When @P_RateConF=1 and (RRateCon.Rate is not null or RateCon.Rate is not null) then 0 else 1 end) END * ICALC.GROSS*(PCALC.PGROSS*@P_PFactor)/PCALC.POGROSS*(100-@Premium_Treaty_Discount)/100)*(Case When (CASE WHEN @P_COMMN_C<>0 Then @P_COMMN_C ELSE RPART.COMMN END)=0 Then 1 else (Case When RCover.NetRateF=1 or @P_ONGROSSNET=2 OR (@P_ONGROSSNET=0 AND (100-@Premium_OutGo)/100*(100-(CASE WHEN @P_COMMN_C<>0 Then @P_COMMN_C ELSE RPART.COMMN END))/100<(100-(CASE WHEN @P_COMM_C<>0 Then @P_COMM_C WHEN RPART.COMM<>0 THEN RPART.COMM ELSE @P_COMM END))/100) Then 1 else 1 end) end)*RPART.FEE/100-(Case When @P_RITabarruF=0 Then 1 Else 0 end)*(ICALC.GROSS*PCALC.PGROSS/PCALC.POGROSS*@P_OPFEEPCT/100)),0) AS FEE_1,                
		coalesce(SUM((Case When @P_RateConF=1 Then (Case When RRateCon.Rate is null then RateCon.Rate*(Case When RateCon.Loading<>0 then RateCon.Loading/100 else RCover.Loading end) else RRateCon.Rate/PCalc.RiskNum*(Case When RRateCon.Loading<>0 then RRateCon.Loading/100 else RCover.Loading end) end) Else coalesce(@P_NETRATEDet,RPART.NETRATE/PCalc.RiskNum) end/100*(100-RCover.Discount)/100*ICALC.GROSS/PCALC.GROSS*ICALC.PRORATA *ICALC.TSI*(CASE WHEN RCOVER.PCALC='S' OR RCOVER.PCTLOSS=0 THEN 100 ELSE RCOVER.PCTLOSS END)/(CASE WHEN RCOVER.PCTLOSS=0 THEN 100 ELSE RCOVER.PCTLOSS END+RCOVER.PAddition)*ICALC.PCTADJ/100)*(Case When (CASE WHEN @P_COMMN_C<>0 Then @P_COMMN_C ELSE RPART.COMMN END)=0 Then 1 else (Case When RCover.NetRateF=1 or @P_ONGROSSNET=2 OR (@P_ONGROSSNET=0 AND (100-@Premium_OutGo)/100*(100-(CASE WHEN @P_COMMN_C<>0 Then @P_COMMN_C ELSE RPART.COMMN END))/100<(100-(CASE WHEN @P_COMM_C<>0 Then @P_COMM_C WHEN RPART.COMM<>0 THEN RPART.COMM ELSE @P_COMM END))/100) Then 1 else 1 end) end)*RPART.FEE/100-(Case When @P_RITabarruF=0 Then 1 Else 0 end)*(ICALC.GROSS*PCALC.PGROSS/PCALC.POGROSS*@P_OPFEEPCT/100)),0) AS FEE_2    
                
		FROM ICALC     
		INNER JOIN ACCEPTANCE SACCEPTANCE ON (SACCEPTANCE.ANO=ICALC.SANO)    
		INNER JOIN RCOVER ON (RCOVER.ANO=ICALC.SANO AND RCOVER.CODE=ICALC.CODE AND (RCOVER.SDATE=ICALC.SDATE OR (@P_AType='A' AND (CASE WHEN RCOVER.SDATE<SACCEPTANCE.PDATE THEN SACCEPTANCE.PDATE ELSE RCOVER.SDATE END)=ICALC.SDATE)))    
		INNER JOIN RPART ON (RPART.RNO=@P_RNO and (@P_ID='' or RPart.ID=@P_ID) and (@P_DocNo='' or RPart.DocNo=@P_DocNo))
		LEFT JOIN RPARTDET ON (RPARTDET.RNO=RPART.RNO AND RPARTDET.ID=RPART.ID AND RPartDet.DocNo=RPART.DOCNO AND RPARTDET.TOR=ICALC.TOR)    
		LEFT Join FN_RateCon(@P_ANO, @P_CODE,@P_TSI,@P_ASDate) RateCon On (@P_RateConF=1 and RateCon.Code=ICalc.Code)    
		LEFT Join FN_RRateCon(@P_ANO, @P_RID, @P_TSI) RRateCon On (@P_RateConF=1)                
		INNER JOIN ICOVER ON (ICOVER.INO=ICALC.INO AND (ICOVER.ADJUSTABLE=@P_ADJUSTABLEF OR @P_AType='A'))    
		INNER JOIN RCALC ON (RCALC.ANO=ICALC.ANO AND RCALC.CURRENCY=ICALC.CURRENCY AND RCALC.CODE=ICALC.CODE AND RCALC.TOR=ICALC.TOR AND RCALC.SDATE=ICALC.SDATE AND RCALC.EDATE=ICALC.EDATE AND RCALC.SANO=ICALC.SANO AND RCALC.EXTREATYF=0)    
		INNER JOIN PCALC_ANNUM(@P_ANO) PCALC ON (PCALC.ANO=ICALC.ANO AND PCALC.CODE=ICALC.CODE AND PCALC.SDATE=ICALC.SDATE AND PCALC.EDATE=ICALC.EDATE AND PCALC.INO=ICALC.INO AND PCALC.CURRENCY=ICALC.CURRENCY)    
		WHERE ICALC.ANO=@P_ANO AND ICALC.CURRENCY=@P_CCY AND ICALC.SDATE=@P_SDATE AND ICALC.EDATE=@P_EDATE AND ICALC.CODE=@P_CODE                
		AND RPARTDET.TOR IS NULL AND PCALC.GROSS<>0    
		Group By RPart.ID, RPart.DocNo

		Union All              

		select              
		RPart.ID,
		RPart.DocNo,
		Max(PCalc.Rate) as Rate,
		Max(RPart.Share-RPart.JP) as Share,
		cast(Max(Cast(RPart.OnMinPremiumF as integer)) as Bit) as OnMinPremiumF,              

		coalesce(SUM((CASE WHEN RPARTDET.PPCT<>0 THEN RPARTDET.PPCT/100 ELSE (Case When @P_RateConF=1 and (RRateCon.Rate is not null or RateCon.Rate is not null) then 0 else 1 end) END * ICALC.GROSS*(PCALC.PGROSS*@P_PFactor)/PCALC.POGROSS-(ICALC.GROSS*PCALC.PGROSS/PCALC.POGROSS*@P_OPFEEPCT/100))*(100-@Premium_Treaty_Discount)/100*(Case When RPARTDET.COMMN=0 Then RPARTDET.COMM/100 else (Case When RCover.NetRateF=1 or @P_ONGROSSNET=2 OR (@P_ONGROSSNET=0 AND (100-@Premium_OutGo)/100*(100-RPARTDET.CommN)/100<(100-RPARTDET.COMM)/100) Then (100-@Premium_OutGo)/100*(RPARTDET.CommN)/100 else RPARTDET.COMM/100 end) end)),0) AS COMM_1,                
		coalesce(SUM((Case When @P_RateConF=1 Then (Case When RRateCon.Rate is null then RateCon.Rate*(Case When RateCon.Loading<>0 then RateCon.Loading/100 else RCover.Loading end) else RRateCon.Rate/PCalc.RiskNum*(Case When RRateCon.Loading<>0 then RRateCon.Loading/100 else RCover.Loading end) end) Else coalesce(@P_NETRATEDet,RPartDet.NetRate*datediff(day,@P_Sdate, @P_EDate)/datediff(day,@P_ASdate, @P_AEDate)) end/100*(100-RCover.Discount)/100*ICALC.GROSS/PCALC.GROSS*ICALC.PRORATA *ICALC.TSI*(CASE WHEN RCOVER.PCALC='S' OR RCOVER.PCTLOSS=0 THEN 100 ELSE RCOVER.PCTLOSS END)/(CASE WHEN RCOVER.PCTLOSS=0 THEN 100 ELSE RCOVER.PCTLOSS END+RCOVER.PAddition)*ICALC.PCTADJ/100-(ICALC.GROSS*PCALC.PGROSS/PCALC.POGROSS*@P_OPFEEPCT/100))*(Case When RPARTDET.COMMN=0 Then RPARTDET.COMM/100 else (Case When RCover.NetRateF=1 or @P_ONGROSSNET=2 OR (@P_ONGROSSNET=0 AND (100-@Premium_OutGo)/100*(100-RPARTDET.CommN)/100<(100-RPARTDET.COMM)/100) Then (100-@Premium_OutGo)/100*(RPARTDET.CommN)/100 else RPARTDET.COMM/100 end) end)),0) AS COMM_2,                    
                
		coalesce(SUM((CASE WHEN RPARTDET.PPCT<>0 THEN RPARTDET.PPCT/100 ELSE (Case When @P_RateConF=1 and (RRateCon.Rate is not null or RateCon.Rate is not null) then 0 else 1 end) END * ICALC.GROSS*(PCALC.PGROSS*@P_PFactor)/PCALC.POGROSS)*(100-@Premium_Treaty_Discount)/100*(Case When RPARTDET.COMMN=0 Then 1 else (Case When RCover.NetRateF=1 or @P_ONGROSSNET=2 OR (@P_ONGROSSNET=0 AND (100-@Premium_OutGo)/100*(100-RPARTDET.CommN)/100<(100-RPARTDET.COMM)/100) Then 1 else 1 end) end)-(Case When @P_RITabarruF=1 Then 1 Else 0 end)*(ICALC.GROSS*PCALC.PGROSS/PCALC.POGROSS*@P_OPFEEPCT/100)),0) AS GROSS_1,                
		coalesce(SUM((Case When @P_RateConF=1 Then (Case When RRateCon.Rate is null then RateCon.Rate*(Case When RateCon.Loading<>0 then RateCon.Loading/100 else RCover.Loading end) else RRateCon.Rate/PCalc.RiskNum*(Case When RRateCon.Loading<>0 then RRateCon.Loading/100 else RCover.Loading end) end) Else coalesce(@P_NETRATEDet,RPartDet.NetRate*datediff(day,@P_Sdate, @P_EDate)/datediff(day,@P_ASdate, @P_AEDate)) end/100*(100-RCover.Discount)/100*ICALC.GROSS/PCALC.GROSS*ICALC.PRORATA *ICALC.TSI*(CASE WHEN RCOVER.PCALC='S' OR RCOVER.PCTLOSS=0 THEN 100 ELSE RCOVER.PCTLOSS END)/(CASE WHEN RCOVER.PCTLOSS=0 THEN 100 ELSE RCOVER.PCTLOSS END+RCOVER.PAddition)*ICALC.PCTADJ/100)*(Case When RPARTDET.COMMN=0 Then 1 else (Case When RCover.NetRateF=1 or @P_ONGROSSNET=2 OR (@P_ONGROSSNET=0 AND (100-@Premium_OutGo)/100*(100-RPARTDET.CommN)/100<(100-RPARTDET.COMM)/100) Then 1 else 1 end) end)-(Case When @P_RITabarruF=1 Then 1 Else 0 end)*(ICALC.GROSS*PCALC.PGROSS/PCALC.POGROSS*@P_OPFEEPCT/100)),0) AS GROSS_2,                
  
		coalesce(SUM((CASE WHEN RPARTDET.PPCT<>0 THEN RPARTDET.PPCT/100 ELSE (Case When @P_RateConF=1 and (RRateCon.Rate is not null or RateCon.Rate is not null) then 0 else 1 end) END * ICALC.GROSS*(PCALC.PGROSS*@P_PFactor)/PCALC.POGROSS-(ICALC.GROSS*PCALC.PGROSS/PCALC.POGROSS*@P_OPFEEPCT/100))*(100-@Premium_Treaty_Discount)/100*(Case When RPARTDET.COMMN=0 Then 0 else (Case When RCover.NetRateF=1 or @P_ONGROSSNET=2 OR (@P_ONGROSSNET=0 AND (100-@Premium_OutGo)/100*(100-RPARTDET.CommN)/100<(100-RPARTDET.COMM)/100) Then (@Premium_OutGo)/100 else 0 end) end)),0) AS DISC_1,                
		coalesce(SUM((Case When @P_RateConF=1 Then (Case When RRateCon.Rate is null then RateCon.Rate*(Case When RateCon.Loading<>0 then RateCon.Loading/100 else RCover.Loading end) else RRateCon.Rate/PCalc.RiskNum*(Case When RRateCon.Loading<>0 then RRateCon.Loading/100 else RCover.Loading end) end) Else coalesce(@P_NETRATEDet,RPartDet.NetRate*datediff(day,@P_Sdate, @P_EDate)/datediff(day,@P_ASdate, @P_AEDate)) end/100*(100-RCover.Discount)/100*ICALC.GROSS/PCALC.GROSS*ICALC.PRORATA *ICALC.TSI*(CASE WHEN RCOVER.PCALC='S' OR RCOVER.PCTLOSS=0 THEN 100 ELSE RCOVER.PCTLOSS END)/(CASE WHEN RCOVER.PCTLOSS=0 THEN 100 ELSE RCOVER.PCTLOSS END+RCOVER.PAddition)*ICALC.PCTADJ/100-(ICALC.GROSS*PCALC.PGROSS/PCALC.POGROSS*@P_OPFEEPCT/100))*(Case When RPARTDET.COMMN=0 Then 0 else (Case When RCover.NetRateF=1 or @P_ONGROSSNET=2 OR (@P_ONGROSSNET=0 AND (100-@Premium_OutGo)/100*(100-RPARTDET.CommN)/100<(100-RPARTDET.COMM)/100) Then (@Premium_OutGo)/100 else 0 end) end)),0) AS DISC_2,                    
  
		coalesce(SUM((CASE WHEN RPARTDET.PPCT<>0 THEN RPARTDET.PPCT/100 ELSE (Case When @P_RateConF=1 and (RRateCon.Rate is not null or RateCon.Rate is not null) then 0 else 1 end) END * ICALC.GROSS*(PCALC.PGROSS*@P_PFactor)/PCALC.POGROSS)*(100-@Premium_Treaty_Discount)/100*(Case When RPARTDET.COMMN=0 Then 1 else (Case When RCover.NetRateF=1 or @P_ONGROSSNET=2 OR (@P_ONGROSSNET=0 AND (100-@Premium_OutGo)/100*(100-RPARTDET.CommN)/100<(100-RPARTDET.COMM)/100) Then 1 else 1 end) end)*RPART.FEE/100-(Case When @P_RITabarruF=0 Then 1 Else 0 end)*(ICALC.GROSS*PCALC.PGROSS/PCALC.POGROSS*@P_OPFEEPCT/100)),0) AS FEE_1,                
		coalesce(SUM((Case When @P_RateConF=1 Then (Case When RRateCon.Rate is null then RateCon.Rate*(Case When RateCon.Loading<>0 then RateCon.Loading/100 else RCover.Loading end) else RRateCon.Rate/PCalc.RiskNum*(Case When RRateCon.Loading<>0 then RRateCon.Loading/100 else RCover.Loading end) end) Else coalesce(@P_NETRATEDet,RPartDet.NetRate*datediff(day,@P_Sdate, @P_EDate)/datediff(day,@P_ASdate, @P_AEDate)) end/100*(100-RCover.Discount)/100*ICALC.GROSS/PCALC.GROSS*ICALC.PRORATA *ICALC.TSI*(CASE WHEN RCOVER.PCALC='S' OR RCOVER.PCTLOSS=0 THEN 100 ELSE RCOVER.PCTLOSS END)/(CASE WHEN RCOVER.PCTLOSS=0 THEN 100 ELSE RCOVER.PCTLOSS END+RCOVER.PAddition)*ICALC.PCTADJ/100)*(Case When RPARTDET.COMMN=0 Then 1 else (Case When RCover.NetRateF=1 or @P_ONGROSSNET=2 OR (@P_ONGROSSNET=0 AND (100-@Premium_OutGo)/100*(100-RPARTDET.CommN)/100<(100-RPARTDET.COMM)/100) Then 1 else 1 end) end)*RPART.FEE/100-(Case When @P_RITabarruF=0 Then 1 Else 0 end)*(ICALC.GROSS*PCALC.PGROSS/PCALC.POGROSS*@P_OPFEEPCT/100)),0) AS FEE_2    
  
		FROM ICALC     
		INNER JOIN ACCEPTANCE SACCEPTANCE ON (SACCEPTANCE.ANO=ICALC.SANO)    
		INNER JOIN RCOVER ON (RCOVER.ANO=ICALC.SANO AND RCOVER.CODE=ICALC.CODE AND (RCOVER.SDATE=ICALC.SDATE OR (@P_AType='A' AND (CASE WHEN RCOVER.SDATE<SACCEPTANCE.PDATE THEN SACCEPTANCE.PDATE ELSE RCOVER.SDATE END)=ICALC.SDATE)))    
		INNER JOIN RPART ON (RPART.RNO=@P_RNO and (@P_ID='' or RPart.ID=@P_ID) and (@P_DocNo='' or RPart.DocNo=@P_DocNo))
		INNER JOIN RPARTDET ON (RPARTDET.RNO=RPART.RNO AND RPARTDET.ID=RPART.ID AND RPARTDET.DocNo=RPART.DOCNO AND RPARTDET.TOR=ICALC.TOR AND (RPARTDET.NOFYEARS=0 OR RPARTDET.NOFYEARS=@P_NOFYEARS) and RPARTDET.EXCLUDEF=0)    
		LEFT Join FN_RateCon(@P_ANO, @P_CODE,@P_TSI,@P_ASDate) RateCon On (@P_RateConF=1 and RateCon.Code=ICalc.Code)    
		LEFT Join FN_RRateCon(@P_ANO, @P_RID, @P_TSI) RRateCon On (@P_RateConF=1)                
		INNER JOIN ICOVER ON (ICOVER.INO=ICALC.INO AND (ICOVER.ADJUSTABLE=@P_ADJUSTABLEF OR @P_AType='A'))    
		INNER JOIN RCALC ON (RCALC.ANO=ICALC.ANO AND RCALC.CURRENCY=ICALC.CURRENCY AND RCALC.CODE=ICALC.CODE AND RCALC.TOR=ICALC.TOR AND RCALC.SDATE=ICALC.SDATE AND RCALC.EDATE=ICALC.EDATE AND RCALC.SANO=ICALC.SANO AND RCALC.EXTREATYF=0)    
		INNER JOIN PCALC_ANNUM(@P_ANO) PCALC ON (PCALC.ANO=ICALC.ANO AND PCALC.CODE=ICALC.CODE AND PCALC.SDATE=ICALC.SDATE AND PCALC.EDATE=ICALC.EDATE AND PCALC.INO=ICALC.INO AND PCALC.CURRENCY=ICALC.CURRENCY)    
		WHERE ICALC.ANO=@P_ANO AND ICALC.CURRENCY=@P_CCY AND ICALC.SDATE=@P_SDATE AND ICALC.EDATE=@P_EDATE AND ICALC.CODE=@P_CODE                
		AND PCALC.GROSS<>0    
		Group By RPart.ID, RPart.DocNo
	) R 
	Group By R.ID, R.DocNo
) R

GO
DROP PROCEDURE ISShare
GO
CREATE PROCEDURE ISShare (@PANO as Integer)
AS
Select ISource.Share as ISShare
FROM Acceptance
INNER JOIN AISOURCE ISOURCE on (ISOURCE.ANO=ACCEPTANCE.ANO)
WHERE Acceptance.ANO=@PANO 
GO

DROP PROCEDURE CLCostTo 
GO
CREATE PROCEDURE CLCostTo (@P_CNO as integer, @P_Currency as varchar(10)) 
AS 
SELECT C2.cno, C2.id, coalesce(I.ID, C2.ID) as LeaderID, C2.currency, Case When C2.RefNo='' Then C1.RefNo else C2.RefNo end as RefNo, C2.CCType, Max(coalesce(CCType.CodeExt,'L')) as CodeExt,
Max(C1.Payment) as Payment,
Max(Coalesce(CoShare.CoShare,0)) as CoShare,
Case When C1.ISType='I' or C2.CCOLLECTIONF=1 then cast(0 as Bit) else C2.ContributionF end as ContributionF, C2.CCollectionF, sum(C2.amount) AS amount, sum(C2.tax) as tax
From CLAIM C1 
INNER JOIN CLCOST C2 ON (C1.CNO=C2.CNO) 
LEFT JOIN CCTYPE ON (CCTYPE.CCTYPE=C2.CCTYPE)
OUTER APPLY (SELECT TOP 1 TOR, CODE AS RCODE FROM LCALC WHERE CNO=C2.CNO Order By Case When LCALC.Currency=C2.Currency Then 0 Else 1 End, Code, TOR) LCALC
INNER JOIN ACCEPTANCE A ON (A.ANO=C1.ANO) 
LEFT JOIN AISOURCE I ON (I.ANO=A.ANO) 
Outer Apply (
	Select Top 1 RCover.CoShare 
	from RCover 
	Where RCover.ANO=C1.ANO and RCover.Code=LCALC.RCODE
	AND (RCover.RetroActiveF=1 or (RCOVER.SDATE<=C1.LOSSDATE AND A.ExclusiveF=1) or ((RCOVER.SDATE<C1.LOSSDATE or (RCOVER.SDATE=C1.LOSSDATE AND A.STIME<=C1.LossTime)) AND A.ExclusiveF=0))           
	AND ((dbo.fn_Get_ExtPeriodDate(A.ExtRPeriod, 0, dbo.fn_Get_ExtPeriodDate(A.ExtPeriod, A.ExtPeriodInDaysF, RCOVER.EDATE))>C1.LOSSDATE AND A.ExclusiveF=1) or ((dbo.fn_Get_ExtPeriodDate(A.ExtRPeriod, 0, dbo.fn_Get_ExtPeriodDate(A.ExtPeriod, A.ExtPeriodInDaysF, RCOVER.EDATE))>C1.LOSSDATE or (dbo.fn_Get_ExtPeriodDate(A.ExtRPeriod, 0, dbo.fn_Get_ExtPeriodDate(A.ExtPeriod, A.ExtPeriodInDaysF, RCOVER.EDATE))=C1.LOSSDATE AND A.ETIME>C1.LossTime)) AND A.ExclusiveF=0))          	
	And (C1.ISType in ('I','L') or (C1.ISType in ('C') and C2.ContributionF=0))
	And C2.ApplyCoShareF=1
	) CoShare
WHERE C2.CNO=@p_cno and C2.currency=@p_currency and C2.Status='P' 
GROUP BY C2.cno, C2.id, I.ID, C2.currency, Case When C2.RefNo='' Then C1.RefNo else C2.RefNo end, C2.CCtype, Case When C1.ISType='I' or C2.CCOLLECTIONF=1 then cast(0 as Bit) else C2.ContributionF end, C2.CCollectionF 
GO

DROP PROCEDURE View16 
GO
CREATE PROCEDURE View16 (@P_ANO as integer)
AS
SELECT Cover.CoverNo, Cover.CoverDate, Cover.ExpDate, ISource.RType, Acceptance.RegNo, Acceptance.ANO, Payor.ID, Profile.Name, Acceptance.AStatus, Acceptance.TOC, TOC.Description, Acceptance.Branch
FROM Cover, AISource ISource, Acceptance, Payor, Profile, TOC
WHERE Acceptance.ANO=Acceptance.LANO And Cover.CNO=Acceptance.CNO And ISource.ANO=Acceptance.ANO And Payor.ANO=Acceptance.ANO And Acceptance.ISType='T' And Profile.ID=Payor.ID And TOC.TOC=ACCEPTANCE.TOC And Acceptance.ANO=@P_ANO
GO
DROP PROCEDURE CLView06a 
GO
CREATE PROCEDURE CLView06a (@P_CNO as integer)  
AS  
SELECT CLAIM.CLAIMNO, CLAIM.ANO, CLAIM.CNO, CLAIM.LOSSDATE, CLAIM.CTYPE,  
CCalc.Currency,  
CCALC.RATE,   
CCALC.SHARE AS PCTSHARE,  
CCALC.LOSS AS ESTIMATE,  
CCALC.CLAIM AS OURSHARE,  
CCALC.EDEDUCTIBLE,  
CCALC.DEDUCTIBLE,  
  
CCALC.COST,  
CCALC.RCOST,  
CCALC.ECOST,  
CCALC.ERCOST,  
  
CCALC.SALVAGE,  
CCALC.RSALVAGE,  
CCALC.ESALVAGE,  
CCALC.ERSALVAGE,  
  
CCALC.SUBROGATION,  
CCALC.RSUBROGATION,  
CCALC.ESUBROGATION,  
CCALC.ERSUBROGATION,  
COALESCE(ISOURCE.LIMIT,0) AS LIMIT,  
COALESCE(ISOURCE.EXCESS,0) AS EXCESS,  
PCCALC.CLAIM as PrevOURSHARE,  
PCCALC.DEDUCTIBLE as PrevDEDUCTIBLE,  
PCCALC.COST as PrevCost,  
PCCALC.SALVAGE AS PrevSALVAGE,  
PCCALC.SUBROGATION As PrevSUBROGATION,  
TOC.CashCallOnPartialPaymentF, TOC.CashCallOnEstimateF, TOC.CashCallOnGrossF, 
coalesce(Coinsurance.MShare,0) as MShare
From CCALC   
INNER JOIN CLAIM ON (CLAIM.CNO=CCALC.CNO)   
INNER JOIN ACCEPTANCE ON (ACCEPTANCE.ANO=CLAIM.ANO)   
INNER JOIN COVER ON (COVER.CNO=ACCEPTANCE.CNO)   
INNER JOIN TOC on (TOC.TOC=CLAIM.TOC)  
LEFT JOIN AISOURCE ISOURCE ON (ISOURCE.ANO=ACCEPTANCE.ANO)  
Left Join CCalc pCCalc on (pCCalc.CNO=Claim.pCNO and pCCalc.Currency=CCalc.Currency and Claim.CSeqNo>0)  
Outer Apply (
	Select sum(Share) as MShare
	from
	(
		Select Coinsurance.SHARE
		FROM Coinsurance
		WHERE Acceptance.ISTYPE='L' and Coinsurance.ClaimNotFullCoverF=0 and Coinsurance.CNO=ACCEPTANCE.CNO

		Union All

		Select CoinsuranceDET.SHARE
		from Coinsurance 
		INNER JOIN CoinsuranceDET on (CoinsuranceDET.CNO=Coinsurance.CNO and CoinsuranceDET.ID=Coinsurance.ID)
		OUTER APPLY (SELECT TOP 1 LCALC.TOR, LCALC.CODE AS RCODE FROM LCALC WHERE LCALC.CNO=CCALC.CNO Order By Case When LCALC.Currency=CCALC.Currency Then 0 Else 1 End, Code, TOR) LCALC
		WHERE Acceptance.ISTYPE='L' and Coinsurance.ClaimNotFullCoverF=1 and Coinsurance.CNO=ACCEPTANCE.CNO
		And (
			CoinsuranceDET.Code=LCALC.RCODE   
			or   
			Exists (Select Top 1 RCalc.Code from RCalc Inner Join RateCov on (RateCov.Code=CoinsuranceDET.Code and RateCov.TOR=RCalc.TOR) Where RCalc.ANO=ACCEPTANCE.ANO and RCalc.Code=LCALC.RCODE)      
		)  
	) Coinsurance
) Coinsurance
WHERE CCALC.CNO=@P_CNO  
  
GO  

DROP Function Premium_HandlingFee
GO
CREATE Function Premium_HandlingFee(@P_ANO as int,@P_Code as varchar(10),@P_Period Int)          
RETURNS Float          
AS          
BEGIN          
 Declare @FEE Float 
 Declare @DetailF bit          
                                            
 Select Top 1 @DetailF=1 from AISourceDet ISourceDet, Acceptance Where ISourceDet.ANO=Acceptance.ANO and Acceptance.ANO=@P_ANO                  
 if @DetailF is null   
 Select @DetailF=0     
   
 if @DetailF=1  
 Begin   
	Select @FEE=ISourceDet.FEE+ISourceDet.HF 
	from Acceptance 
	inner join AISourceDet ISourceDet on (ISourceDet.ANO=Acceptance.ANO and ISourceDet.Code=@P_Code)
	Where Acceptance.ANO=@P_ANO 
 end   
 else 
 Begin   
	Select @FEE=ISource.FEE+ISource.HF+ISource.OC 
	from Acceptance 
	Inner Join AISource ISource on (ISource.ANO=Acceptance.ANO)
	Where Acceptance.ANO=@P_ANO 
 end  
                  
 if @FEE is null          
   Select @FEE=0          
                  
 return(@FEE)          
End          
GO
DROP Function FN_Approval_Production
GO
CREATE Function FN_Approval_Production(@P_ANO int)   
RETURNS @Table TABLE (REGID varchar(10), FLDID varchar(255), VALUEID varchar(255), CertificateNo varchar(10), Branch varchar(10), TOC varchar(10), ISType varchar(10), ApprLimitPCT Float, Amount Float, TotalAmount Float)  
AS   
BEGIN   
Declare @ApplyApprLimitByAccRegF as Bit
Declare @ApplyApprLimitByTOLF as Bit
Declare @ApplyApprLimitOCF as Bit
Declare @LANO as int
Declare @OpenFlag as Bit
Declare @TOC as varchar(10)
Declare @Branch as varchar(10)
Declare @ISType as varchar(10)
Declare @PHolder as varchar(10)

Declare @NoRiskAccumulationF as Bit

Select @NoRiskAccumulationF=A.NoRiskAccumulationF, @TOC=A.TOC, @Branch=A.Branch, @ISType=A.ISType, @PHolder=C.PHolder, @LANO=A.LANO, @OpenFlag=C.OpenFlag, @ApplyApprLimitByTOLF=TOC.ApplyApprLimitByTOLF, @ApplyApprLimitByAccRegF=TOC.ApplyApprLimitByAccRegF
, @ApplyApprLimitOCF=TOC.ApplyApprLimitOCF
from Acceptance A
Inner Join Cover C on (C.CNO=A.CNO)
Inner Join TOC on (TOC.TOC=A.TOC)
Where A.ANO=@P_ANO

if @ApplyApprLimitByAccRegF=0 
	if @P_ANO<>@LANO
	Begin
		if @OpenFlag=0
			Insert into @Table
			SELECT top 1 Acceptance.RegID, Acceptance.FLDID, Acceptance.ValueID, Case When Acceptance.ValueID='' Then Acceptance.CertificateNo else '' end as CertificateNo,
			@Branch as Branch,    
			@TOC as TOC, 
			@ISType as ISType,
			Case When @ApplyApprLimitByTOLF=1 Then RARRHEADER.CLIMIT*RARRHEADER.LIMIT*100 ELSE 100 END as ApprLimitPct,  
			(RArrHeader.TAmount-RArrHeader.MAmount) as Amount,
			cast(0 as Float) as TotalAmount
			From Acceptance
			Inner Join RARRHEADER on (RArrheader.ANO=Acceptance.ANO)
			WHERE Acceptance.ANO=@P_ANO
		else
			Insert into @Table
			SELECT top 1 Acceptance.RegID, Acceptance.FLDID, Acceptance.ValueID, Case When Acceptance.ValueID='' Then Acceptance.CertificateNo else '' end as CertificateNo,
			@Branch as Branch,    
			@TOC as TOC, 
			@ISType as ISType,
			Case When @ApplyApprLimitByTOLF=1 Then RARRHEADER.CLIMIT*RARRHEADER.LIMIT*100 ELSE 100 END as ApprLimitPct,  
			(RArrHeader.TAmount-RArrHeader.MAmount) as Amount,
			cast(0 as Float) as TotalAmount
			From Acceptance
			Inner Join RARRHEADER on (RArrheader.ANO=Acceptance.ANO)
			WHERE Acceptance.ANO=@P_ANO
			-- No Master Acceptance Limit Of Liability
			and (@ApplyApprLimitOCF=1 or not exists (Select Top 1 mA.ANO from Acceptance mA Inner Join ICover I on (I.ANO=mA.ANO) Where mA.ANO=Acceptance.LANO and I.Category='M' and I.Amount<>0))			
	end
	else 
	Begin
		if @OpenFlag=1	--Master Open Cover
			Insert into @Table
			SELECT top 1 Acceptance.RegID, Acceptance.FLDID, Acceptance.ValueID, Case When Acceptance.ValueID='' Then Acceptance.CertificateNo else '' end as CertificateNo,
			@Branch as Branch,    
			@TOC as TOC, 
			@ISType as ISType,
			100 as ApprLimitPct,  
			sum(ICover.Amount*dbo.fn_GetReinsuranceRate(Acceptance.TOC,ICover.Currency,Acceptance.SDate,@PHolder)) 
			* coalesce((Select sum(Share) from AISource ISource Where ISource.ANO=Acceptance.ANO),100)/100				
			* (100-coalesce((Select sum(Share) from Coinsurance Where CNO=Acceptance.CNO),0))/100				
			as Amount,
			cast(0 as Float) as TotalAmount
			From Acceptance
			Inner Join ICover on (ICover.ANO=Acceptance.ANO)
			WHERE Acceptance.ANO=@P_ANO
			and ICover.Category='M'
			Group by Acceptance.CNO, Acceptance.ANO, Acceptance.RegID, Acceptance.FLDID, Acceptance.ValueID, Case When Acceptance.ValueID='' Then Acceptance.CertificateNo else '' end
		else
			if @NoRiskAccumulationF=0 
				Insert into @Table
				SELECT top 1 Acceptance.RegID, Acceptance.FLDID, Acceptance.ValueID, Case When Acceptance.ValueID='' Then Acceptance.CertificateNo else '' end as CertificateNo,
				@Branch as Branch,    
				@TOC as TOC, 
				@ISType as ISType,
				Max(Case When @ApplyApprLimitByTOLF=1 Then RARRHEADER.CLIMIT*RARRHEADER.LIMIT*100 ELSE 100 END) as ApprLimitPct,  
				sum(RArrHeader.TAmount-RArrHeader.MAmount) as Amount,
				cast(0 as Float) as TotalAmount
				From Acceptance mA
				Inner join Acceptance omA on (omA.OANO=mA.OANO)
				Inner Join Acceptance on (Acceptance.LANO=omA.ANO)
				Left Join Acceptance nAcceptance on (nAcceptance.pANO=Acceptance.ANO)
				Inner Join RARRHEADER on (RArrheader.ANO=Acceptance.ANO)
				WHERE mA.ANO=@P_ANO 
				and Acceptance.AType not in ('A','C') and Acceptance.AStatus in ('W','T','I') 
				and (coalesce(nAcceptance.ANO,0)=0 or (coalesce(nAcceptance.LANO,0)=mA.ANO and coalesce(nAcceptance.AType,'')='C' and mA.AType='C'))
				Group By Acceptance.RegID, Acceptance.FLDID, Acceptance.ValueID, Case When Acceptance.ValueID='' Then Acceptance.CertificateNo else '' end
				Order By sum(RArrHeader.TAmount-RArrHeader.MAmount) Desc            
			else
				Insert into @Table
				SELECT top 1 Acceptance.RegID, Acceptance.FLDID, Acceptance.ValueID, Case When Acceptance.ValueID='' Then Acceptance.CertificateNo else '' end as CertificateNo,
				@Branch as Branch,    
				@TOC as TOC, 
				@ISType as ISType,
				Max(Case When @ApplyApprLimitByTOLF=1 Then RARRHEADER.CLIMIT*RARRHEADER.LIMIT*100 ELSE 100 END) as ApprLimitPct,  
				sum(RArrHeader.TAmount-RArrHeader.MAmount) as Amount,
				cast(0 as Float) as TotalAmount
				From Acceptance mA
				Inner Join Acceptance on (Acceptance.LANO=mA.ANO and Acceptance.RegNo=mA.RegNo)
				Inner Join RARRHEADER on (RArrheader.ANO=Acceptance.ANO)
				WHERE mA.ANO=@P_ANO 
				Group By Acceptance.RegID, Acceptance.FLDID, Acceptance.ValueID, Case When Acceptance.ValueID='' Then Acceptance.CertificateNo else '' end
				Order By sum(RArrHeader.TAmount-RArrHeader.MAmount) Desc            
	end
else
	if @P_ANO<>@LANO
	Begin
		if @OpenFlag=0
			Insert into @Table
			SELECT top 1 Acceptance.RegID, Acceptance.FLDID, Acceptance.ValueID, Case When Acceptance.ValueID='' Then Acceptance.CertificateNo else '' end as CertificateNo,
			@Branch as Branch,    
			@TOC as TOC, 
			@ISType as ISType,
			Case When @ApplyApprLimitByTOLF=1 Then RARRHEADER.CLIMIT*RARRHEADER.LIMIT*100 ELSE 100 END as ApprLimitPct,  
			(RArrHeader.TAmount-RArrHeader.MAmount) as Amount,
			(RArrHeader.TAmount-RArrHeader.MAmount)+coalesce(dbo.fn_GetTotalSumInsured(Acceptance.SDate,Acceptance.RegID, Acceptance.FLDID, Acceptance.ValueID,Acceptance.OANO),0) as TotalAmount
			From Acceptance
			Inner Join RARRHEADER on (RArrheader.ANO=Acceptance.ANO)
			WHERE Acceptance.ANO=@P_ANO
		else
			Insert into @Table
			SELECT top 1 Acceptance.RegID, Acceptance.FLDID, Acceptance.ValueID, Case When Acceptance.ValueID='' Then Acceptance.CertificateNo else '' end as CertificateNo,
			@Branch as Branch,    
			@TOC as TOC, 
			@ISType as ISType,
			Case When @ApplyApprLimitByTOLF=1 Then RARRHEADER.CLIMIT*RARRHEADER.LIMIT*100 ELSE 100 END as ApprLimitPct,  
			(RArrHeader.TAmount-RArrHeader.MAmount) as Amount,
			(RArrHeader.TAmount-RArrHeader.MAmount)+coalesce(dbo.fn_GetTotalSumInsured(Acceptance.SDate,Acceptance.RegID, Acceptance.FLDID, Acceptance.ValueID,Acceptance.OANO),0) as TotalAmount
			From Acceptance
			Inner Join RARRHEADER on (RArrheader.ANO=Acceptance.ANO)
			WHERE Acceptance.ANO=@P_ANO
			-- No Master Acceptance Limit Of Liability
			and (@ApplyApprLimitOCF=1 or not exists (Select Top 1 mA.ANO from Acceptance mA Inner Join ICover I on (I.ANO=mA.ANO) Where mA.ANO=Acceptance.LANO and I.Category='M' and I.Amount<>0))
	end
	else 
	Begin
		if @OpenFlag=1	--Master Open Cover
			Insert into @Table
			SELECT top 1 Acceptance.RegID, Acceptance.FLDID, Acceptance.ValueID, Case When Acceptance.ValueID='' Then Acceptance.CertificateNo else '' end as CertificateNo,
			@Branch as Branch,    
			@TOC as TOC, 
			@ISType as ISType,
			100 as ApprLimitPct,  
			sum(ICover.Amount*dbo.fn_GetReinsuranceRate(Acceptance.TOC,ICover.Currency,Acceptance.SDate,@PHolder)) 
			* coalesce((Select sum(Share) from AISource ISource Where ISource.ANO=Acceptance.ANO),100)/100				
			* (100-coalesce((Select sum(Share) from Coinsurance Where CNO=Acceptance.CNO),0))/100				
			as Amount,
			cast(0 as Float) as TotalAmount
			From Acceptance
			Inner Join ICover on (ICover.ANO=Acceptance.ANO)
			WHERE Acceptance.ANO=@P_ANO
			and ICover.Category='M'
			Group by Acceptance.CNO, Acceptance.ANO, Acceptance.RegID, Acceptance.FLDID, Acceptance.ValueID, Case When Acceptance.ValueID='' Then Acceptance.CertificateNo else '' end
		else
			Insert into @Table
			SELECT top 1 Acceptance.RegID, Acceptance.FLDID, Acceptance.ValueID, Case When Acceptance.ValueID='' Then Acceptance.CertificateNo else '' end as CertificateNo,
			@Branch as Branch,    
			@TOC as TOC, 
			@ISType as ISType,
			Max(Case When @ApplyApprLimitByTOLF=1 Then RARRHEADER.CLIMIT*RARRHEADER.LIMIT*100 ELSE 100 END) as ApprLimitPct,  
			Sum(RArrHeader.TAmount-RArrHeader.MAmount) as Amount,
			Sum(RArrHeader.TAmount-RArrHeader.MAmount)+coalesce(dbo.fn_GetTotalSumInsured(Min(Acceptance.SDate),Acceptance.RegID, Acceptance.FLDID, Acceptance.ValueID,Max(mA.OANO)),0) as TotalAmount
			From Acceptance mA
			Inner join Acceptance omA on (omA.OANO=mA.OANO)
			Inner Join Acceptance on (Acceptance.LANO=omA.ANO)
			Left Join Acceptance nAcceptance on (nAcceptance.pANO=Acceptance.ANO)
			Inner Join RARRHEADER on (RArrheader.ANO=Acceptance.ANO)
			WHERE mA.ANO=@P_ANO 
			and Acceptance.AType not in ('A','C') and Acceptance.AStatus in ('W','T','I') 
			and (coalesce(nAcceptance.ANO,0)=0 or (coalesce(nAcceptance.LANO,0)=mA.ANO and coalesce(nAcceptance.AType,'')='C' and mA.AType='C'))
			Group By Acceptance.RegID, Acceptance.FLDID, Acceptance.ValueID, Case When Acceptance.ValueID='' Then Acceptance.CertificateNo else '' end
			Order By Sum(RArrHeader.TAmount-RArrHeader.MAmount)+coalesce(dbo.fn_GetTotalSumInsured(Min(Acceptance.SDate),Acceptance.RegID, Acceptance.FLDID, Acceptance.ValueID,Max(mA.OANO)),0) Desc  
	end

	Return
END

GO

DROP FUNCTION FN_PCalc 
GO
Create FUNCTION FN_PCalc (@P_ANO as integer)                
RETURNS Table                
AS RETURN (                
SELECT  Acceptance.ANO,                
 Count(PCalc.Currency) AS NUMCCY,              
 MAX(PCALC.LMFACTOR) AS LMFACTOR,    
 MAX(PCALC.RATE) AS RATE,              
 MAX(PCALC.CRATE) AS CRATE,             
 MAX(CASE When Acceptance.QTY=0 Then 1 Else Acceptance.QTY end) as NumRisk,    
 sum(PCalc.TSI*PCalc.Rate*Case When Acceptance.QTY=0 Then 1 Else Acceptance.QTY end) AS TSI,                
 sum(PCalc.OurShare*PCalc.Rate*Case When Acceptance.QTY=0 Then 1 Else Acceptance.QTY end) AS OurShare,                
 sum(PCalc.Amount*PCalc.Rate*Case When Acceptance.QTY=0 Then 1 Else Acceptance.QTY end) AS Amount,                
 sum(PCalc.Gross*PCalc.Rate*Case When Acceptance.QTY=0 Then 1 Else Acceptance.QTY end) AS Gross,                
 sum(PCalc.OGross*PCalc.Rate*Case When Acceptance.QTY=0 Then 1 Else Acceptance.QTY end/dbo.fn_Premium_Calc_Prorata(Acceptance.Sdate, case When Acceptance.EXCLUSIVEF=0 and Acceptance.STime<Acceptance.ETime Then dateadd(day,1,Acceptance.EDate) else Acceptance.EDate End,Cover.Prorata, 12,CASE WHEN Cover.PPeriod in (0,1,2) Then 2 ELSE Cover.PPeriod END)) AS OGross,           
 sum(PCalc.Claim*PCalc.Rate*Case When Acceptance.QTY=0 Then 1 Else Acceptance.QTY end) AS Claim,                
 sum(CASE WHEN PCALC.TSI<>0 THEN PCALC.OURSHARE/PCALC.TSI*100 ELSE COALESCE(ISOURCE.SHARE,100) END/100*PCalc.Gross*PCalc.Rate*Case When Acceptance.QTY=0 Then 1 Else Acceptance.QTY end) as Premium,                
 MAX(CASE WHEN PCALC.TSI<>0 THEN PCALC.OURSHARE/PCALC.TSI*100 ELSE COALESCE(ISOURCE.SHARE,100) END) as PCTSHARE,     
 MAX(RARRHEADER.MSHARE) as MSHARE,    
 MAX(YEAR(RARRHEADER.RDATE)) as RYEAR,  
 MAX(PCALC.Description) as Description  
FROM  Acceptance            
INNER JOIN COVER ON (COVER.CNO=ACCEPTANCE.CNO)    
LEFT JOIN Pcalc ON (Acceptance.ANO=PCalc.ANO and Acceptance.PStatus='C')           
LEFT JOIN RArrHeader On (RArrHeader.ANO=Acceptance.ANO)          
LEFT JOIN AISOURCE ISOURCE ON (ISOURCE.ANO=ACCEPTANCE.ANO)                
Where Acceptance.ANO=@P_ANO                
GROUP BY Acceptance.ANO                
)                

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
left join AISource ISource on (ISource.ANO=A2.ANO)   
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
DROP FUNCTION PREMIUM_CALCULATION_BASE
GO
CREATE FUNCTION PREMIUM_CALCULATION_BASE(@P_ANO int)                  

RETURNS @PCALC TABLE (ACNO Int identity, ANO Int, Currency varchar(10), CANO int, Code varchar(10), SDate SmallDatetime, EDate SmallDatetime, PolicyYear Int, NoRefundF Int, MinimumPremiumF Bit, Premium Float)
AS
BEGIN

Declare @CalculationRoundingF Bit
Select @CalculationRoundingF=CalculationRoundingF from systab

DECLARE @ACCEPTANCE TABLE (ANO Int, CNO Int, ISType varchar(1), SDate SmallDateTime, EDate SmallDateTime, STime Varchar(5), ETime varchar(5), NOREFUNDF Int, RefundType Varchar(255), EXCLUSIVEF Bit, AType varchar(10), PDate SmallDateTime, CPCT Float, QTY Int, PANO Int, EMethod varchar(1))
INSERT INTO @ACCEPTANCE
SELECT ANO, CNO, ISType, SDATE, EDate, STime, ETime, NOREFUNDF, RefundType, EXCLUSIVEF, ATYPE, PDATE, CPCT, QTY, PANO, EMETHOD
FROM ACCEPTANCE WHERE ANO=@P_ANO

INSERT INTO @PCALC(ANO, Currency, CANO , Code , SDate, EDate, PolicyYear, NoRefundF, MinimumPremiumF, Premium)
Select ANO, Currency, CANO, Code, SDate, EDate, PolicyYear, NoRefundF, Cast(Max(MinimumPremiumF) as Bit) as MinimumPremiumF, sum(Premium) as Premium
 from (                  
  select Acceptance.ANO, RCalc.Currency, @P_ANO as CANO, RCalc.Code, RCalc.SDate, RCalc.Edate, cast(datediff(Month,Acceptance.SDate, RCalc.SDate) as integer) / 12 + 1  as PolicyYear,          
  Acceptance.NoRefundF,   
  Case When Upper(PCALC.DESCRIPTION) in ('MINIMUM PREMIUM','POLICY MINIMUM PREMIUM') Then 1 else 0 end as MinimumPremiumF,                                       
  case                  
  When Acceptance.Atype<>'N' and Acceptance.NoRefundF<>12 and not (Acceptance.NoRefundF=13 and charindex((case when Acceptance.ISType in ('I','L') Then 'DI' else 'I'+Acceptance.ISType end),Acceptance.RefundType)<>0) and (RCover.NoRefundF=1 or Acceptance.NoRefundF in (2,4) or (Acceptance.NoRefundF in (1) and DateDiff(day, acceptance.pdate, RCalc.SDate) <= 0)) Then 0
  When Acceptance.AType<>'N' then                  
   case                  
   when DateDiff(day, acceptance.pdate, rcalc.SDate)>=0 then 1     
   when DateDiff(day, rcalc.Edate, acceptance.pdate)>=0 then 0                               
   Else                  
    case                  
    when acceptance.cpct<>0 or Cover.Voyage=1 then                  
     case                  
     when acceptance.cpct<>0 then                  
		acceptance.cpct/100                  
     Else                  
		1                  
     End                  
    Else                  
		--Prorata Calculation
		Case When Acceptance.EXCLUSIVEF=0 and Acceptance.STime<Acceptance.ETime and RCalc.EDate=Acceptance.EDate Then
			dbo.fn_calc_prorata(acceptance.pDate, dateadd(day,1,RCalc.edate), RCalc.Sdate, dateadd(day,1,RCalc.edate), Cover.PPeriod)
		else
			dbo.fn_calc_prorata(acceptance.pDate, RCalc.Edate, RCalc.Sdate, RCalc.EDate, Cover.PPeriod)
		End
    End                  
   End                  
  Else                  
	1                  
  End                  
  * (Case When Acceptance.Qty=0 Then 1 else Acceptance.Qty end)                  
  * (Case When PCALC.DESCRIPTION='Minimum Premium' Then RCALC.GROSS else (Case When PCALC.OGROSS<>0 THEN RCALC.OGROSS*PCALC.GROSS/PCALC.OGROSS ELSE PCALC.GROSS END) END+RCalc.Reinstatement)  
  * coalesce(case When ISource.Limit<>0 then ISource.Limit/(ISource.Limit+ISource.Excess) else 1 end*ISource.Share/100,1) as Premium
  From @Acceptance acceptance
  Inner Join cover on (Cover.CNO=Acceptance.CNO)
  Inner Join RCalc on (RCalc.ANO=Acceptance.ANO)
  Inner Join RCover on (RCOVER.ANO=RCALC.ANO AND RCOVER.CODE=RCALC.CODE AND RCOVER.SDATE=RCALC.SDATE)
  Inner Join PCalc on (PCalc.ANO=RCalc.ANO and PCalc.Currency=RCalc.Currency)
  Left Join AISource ISource on (ISource.ANO=Acceptance.ANO)
  Where Acceptance.ANO=@P_ANO 
  and Acceptance.AType not in ('A','C')                  
  and PCalc.Gross<>0          
                                                    
  Union All                  
                                                                                  
  select Acceptance.ANO, RCalc.Currency, Acceptance.PANO as CANO, RCalc.Code, RCalc.SDate, RCalc.Edate, cast(datediff(Month,pAcceptance.SDate, RCalc.SDate) as integer) / 12 + 1 as PolicyYear,          
  Acceptance.NoRefundF,   
  Case When Upper(PCALC.DESCRIPTION) in ('MINIMUM PREMIUM','POLICY MINIMUM PREMIUM') Then 1 else 0 end as MinimumPremiumF,                                       
  -case     
  When Acceptance.Atype<>'N' and Acceptance.NoRefundF<>12 and not (Acceptance.NoRefundF=13 and charindex((case when pAcceptance.ISType in ('I','L') Then 'DI' else 'I'+pAcceptance.ISType end),Acceptance.RefundType)<>0) and (coalesce(RCover.NoRefundF,0)=1 or Acceptance.NoRefundF in (2,4) or (Acceptance.NoRefundF in (1) and DateDiff(day, acceptance.pdate, RCalc.SDate) <= 0)) Then 0
  when DateDiff(day, acceptance.pdate, rcalc.SDate)>0 and acceptance.pdate between pacceptance.sdate and pacceptance.edate then 1        
  when DateDiff(day, rcalc.Edate, acceptance.pdate)>=0 and acceptance.pdate between pacceptance.sdate and pacceptance.edate then 0                            
  Else                  
   case                  
   when acceptance.cpct<>0 or Cover.Voyage=1 then                  
    case                  
    when acceptance.cpct<>0 then                  
		acceptance.cpct/100                  
    Else                  
		1                  
    End                  
   Else                  
    case                  
    When Acceptance.SDate<>Acceptance.PDate or Acceptance.NoRefundF=6 then                  
		--Prorata Calculation
		Case When pAcceptance.EXCLUSIVEF=0 and pAcceptance.STime<pAcceptance.ETime and RCalc.EDate=pAcceptance.EDate Then
			CASE WHEN RCOVER.CPFORMULA='PRORATE SQ' and Acceptance.AType='C' and Acceptance.EMethod<>'A' THEN
				POWER(dbo.fn_calc_prorata(dbo.fn_Get_Effective_Cancellation_By_Payor_Schedule(Acceptance.ANO, Acceptance.PDate,dateadd(day,1,RCalc.edate)), dateadd(day,1,RCalc.edate), RCalc.Sdate, dateadd(day,1,RCalc.edate), Cover.PPeriod), 2)
			ELSE
				CASE WHEN Acceptance.AType='C' and Acceptance.EMethod<>'A' THEN
					dbo.fn_calc_prorata(dbo.fn_Get_Effective_Cancellation_By_Payor_Schedule(Acceptance.ANO, Acceptance.PDate,dateadd(day,1,RCalc.edate)), dateadd(day,1,RCalc.edate), RCalc.Sdate, dateadd(day,1,RCalc.edate), Cover.PPeriod)
				Else
					dbo.fn_calc_prorata(acceptance.pDate, dateadd(day,1,RCalc.edate), RCalc.Sdate, dateadd(day,1,RCalc.edate), Cover.PPeriod)
				End
			END			
		else
			CASE WHEN RCOVER.CPFORMULA='PRORATE SQ' and Acceptance.AType='C' and Acceptance.EMethod<>'A' THEN
				POWER(dbo.fn_calc_prorata(dbo.fn_Get_Effective_Cancellation_By_Payor_Schedule(Acceptance.ANO, Acceptance.PDate,RCalc.Edate), RCalc.Edate, RCalc.Sdate, RCalc.EDate, Cover.PPeriod), 2)
			ELSE
				CASE WHEN Acceptance.AType='C' and Acceptance.EMethod<>'A' THEN
					dbo.fn_calc_prorata(dbo.fn_Get_Effective_Cancellation_By_Payor_Schedule(Acceptance.ANO, Acceptance.PDate,RCalc.Edate), RCalc.Edate, RCalc.Sdate, RCalc.EDate, Cover.PPeriod)
				Else
					dbo.fn_calc_prorata(acceptance.pDate, RCalc.Edate, RCalc.Sdate, RCalc.EDate, Cover.PPeriod)
				End
			END			
		End
    Else                  
    -- Endorsement Period                  
		1                  
    End                  
   End                  
  End                  
  * (Case When pAcceptance.Qty=0 Then 1 else pAcceptance.Qty end)                  
  * (Case When PCALC.DESCRIPTION='Minimum Premium' Then RCALC.GROSS else (Case When PCALC.OGROSS<>0 THEN RCALC.OGROSS*PCALC.GROSS/PCALC.OGROSS ELSE PCALC.GROSS END) END+RCalc.Reinstatement)
  * coalesce(case When ISource.Limit<>0 then ISource.Limit/(ISource.Limit+ISource.Excess) else 1 end*ISource.Share/100,1) 
  * (Case When Acceptance.CPCT=0 and Acceptance.AType='C' and Acceptance.EMethod<>'A' and Acceptance.NoRefundF<>12 and RCover.CPRefund<>0 and Not (DateDiff(day, acceptance.pdate, rcalc.SDate)>0 and acceptance.pdate between pacceptance.sdate and pacceptance.edate) Then RCover.CPRefund/100 else 1 end) as Premium      
  from @Acceptance Acceptance 
  inner join Acceptance pAcceptance on (pAcceptance.ANO=Acceptance.pANO) 
  inner Join Cover on (Cover.CNO=pAcceptance.CNO)                  
  inner join PCalc on (PCalc.ANO=pAcceptance.ANO) 
  inner join RCalc on (RCalc.ANO=PCalc.ANO and RCalc.Currency=PCalc.Currency)                  
  Left Join AISource ISource on (ISource.ANO=pAcceptance.ANO)
  Left Join RCover on (RCover.ANO=Acceptance.ANO and RCover.Code=RCalc.Code and ((RCover.SDate=Acceptance.SDate and RCover.EDate=Acceptance.EDate and RCalc.SDate=pAcceptance.SDate and RCalc.EDate=pAcceptance.EDate) or (RCover.SDate=RCalc.SDate)))
  Where Acceptance.ANO=@P_ANO and Acceptance.AType<>'A' and Not (Acceptance.AType='C' and Acceptance.EMethod='A') and pAcceptance.AType not in ('A','C')                  
  and PCalc.Gross<>0                    
                                                    
  Union All                  
        
  select Acceptance.ANO, RCalc.Currency, @P_ANO as CANO, RCalc.Code, RCalc.SDate, RCalc.Edate, cast(datediff(Month,Acceptance.SDate, RCalc.SDate) as integer) / 12 + 1 as PolicyYear,      
  Acceptance.NoRefundF,       
  Case When Upper(PCALC.DESCRIPTION) in ('MINIMUM PREMIUM','POLICY MINIMUM PREMIUM') Then 1 else 0 end as MinimumPremiumF,                                       
  (Case When PCALC.DESCRIPTION='Minimum Premium' Then RCALC.GROSS else (Case When PCALC.OGROSS<>0 THEN RCALC.OGROSS*PCALC.GROSS/PCALC.OGROSS ELSE PCALC.GROSS END) END+RCalc.Reinstatement)
  * coalesce(case When ISource.Limit<>0 then ISource.Limit/(ISource.Limit+ISource.Excess) else 1 end*ISource.Share/100,1) as Premium
  From @Acceptance acceptance
  Inner Join RCALC on (RCalc.ANO=Acceptance.ANO)
  Inner Join PCalc on (PCalc.ANO=RCalc.ANO and PCalc.Currency=RCalc.Currency)
  Left Join Acceptance sAcceptance on (sAcceptance.ANO=RCalc.SANO) 
  Left Join AISource ISource on (ISource.ANO=sAcceptance.ANO)
  Where Acceptance.ANO=@P_ANO 
  and Acceptance.AType='A'                  
  and PCalc.Gross<>0   
        
) T                  
                                      
Group By ANO, Currency, CANO, Code, SDate, EDate, PolicyYear, NoRefundF  

if @CalculationRoundingF=1 
	Update P
	Set Premium=coalesce(P1.Premium_Rounded_Total,0)-coalesce(P1.Premium_Rounded_Detail,0)+dbo.RoundCCY(Premium,Currency)
	from @PCalc P
	Left Join 
	(	
	Select Max(ACNO) as ACNO, 
	sum(dbo.RoundCCY(Premium,Currency)) as Premium_Rounded_Detail, 
	dbo.RoundCCY(sum(Premium),Currency) as Premium_Rounded_Total
	from @PCalc P
	Group By P.ANO, P.Currency
	) P1 on (P.ACNO=P1.ACNO)

RETURN

END
GO
DROP Procedure QApproval_Production 
GO
CREATE Procedure QApproval_Production (@P_ANO integer)              
AS

Declare @ApplyApprLimitByAccRegF as Bit
Declare @ApplyApprLimitByTOLF as Bit
Declare @ApplyApprLimitOCF as Bit
Declare @LANO as int
Declare @OpenFlag as Bit
Declare @TOC as varchar(10)
Declare @Branch as varchar(10)
Declare @ISType as varchar(10)
Declare @PHolder as varchar(10)
Declare @NoRiskAccumulationF as Bit


Select @NoRiskAccumulationF=A.NoRiskAccumulationF, @TOC=A.TOC, @Branch=A.Branch, @ISType=A.ISType, @PHolder=C.PHolder, @LANO=A.LANO, @OpenFlag=C.OpenFlag, @ApplyApprLimitByTOLF=TOC.ApplyApprLimitByTOLF, @ApplyApprLimitByAccRegF=TOC.ApplyApprLimitByAccRegF, @ApplyApprLimitOCF=TOC.ApplyApprLimitOCF
from Acceptance A
Inner Join Cover C on (C.CNO=A.CNO)
Inner Join TOC on (TOC.TOC=A.TOC)
Where A.ANO=@P_ANO

if @ApplyApprLimitByAccRegF=0 
	if @P_ANO<>@LANO
	Begin
		if @OpenFlag=0
			SELECT top 1 Acceptance.RegID, Acceptance.FLDID, Acceptance.ValueID, Case When Acceptance.ValueID='' Then Acceptance.CertificateNo else '' end as CertificateNo,
			@Branch as Branch,    
			@TOC as TOC, 
			@ISType as ISType,
			Case When @ApplyApprLimitByTOLF=1 Then RARRHEADER.CLIMIT*RARRHEADER.LIMIT*100 ELSE 100 END as ApprLimitPct,  
			(RArrHeader.TAmount-RArrHeader.MAmount) as Amount,
			cast(0 as Float) as TotalAmount
			From Acceptance
			Inner Join RARRHEADER on (RArrheader.ANO=Acceptance.ANO)
			WHERE Acceptance.ANO=@P_ANO
		else
			SELECT top 1 Acceptance.RegID, Acceptance.FLDID, Acceptance.ValueID, Case When Acceptance.ValueID='' Then Acceptance.CertificateNo else '' end as CertificateNo,
			@Branch as Branch,    
			@TOC as TOC, 
			@ISType as ISType,
			Case When @ApplyApprLimitByTOLF=1 Then RARRHEADER.CLIMIT*RARRHEADER.LIMIT*100 ELSE 100 END as ApprLimitPct,  
			(RArrHeader.TAmount-RArrHeader.MAmount) as Amount,
			cast(0 as Float) as TotalAmount		
			From Acceptance
			Inner Join RARRHEADER on (RArrheader.ANO=Acceptance.ANO)
			WHERE Acceptance.ANO=@P_ANO
			-- No Master Acceptance Limit Of Liability
			and (@ApplyApprLimitOCF=1 or not exists (Select Top 1 mA.ANO from Acceptance mA Inner Join ICover I on (I.ANO=mA.ANO) Where mA.ANO=Acceptance.LANO and I.Category='M' and I.Amount<>0))
	end
	else 
	Begin
		if @OpenFlag=1	--Master Open Cover
			SELECT top 1 Acceptance.RegID, Acceptance.FLDID, Acceptance.ValueID, Case When Acceptance.ValueID='' Then Acceptance.CertificateNo else '' end as CertificateNo,
			@Branch as Branch,    
			@TOC as TOC, 
			@ISType as ISType,
			100 as ApprLimitPct,  
			sum(ICover.Amount*dbo.fn_GetReinsuranceRate(Acceptance.TOC,ICover.Currency,Acceptance.SDate,@PHolder)) 
			* coalesce((Select sum(Share) from AISource ISource Where ISource.ANO=Acceptance.ANO),100)/100				
			* (100-coalesce((Select sum(Share) from Coinsurance Where CNO=Acceptance.CNO),0))/100				
			as Amount,
			cast(0 as Float) as TotalAmount
			From Acceptance
			Inner Join ICover on (ICover.ANO=Acceptance.ANO)
			WHERE Acceptance.ANO=@P_ANO
			and ICover.Category='M'
			Group by Acceptance.CNO, Acceptance.ANO, Acceptance.RegID, Acceptance.FLDID, Acceptance.ValueID, Case When Acceptance.ValueID='' Then Acceptance.CertificateNo else '' end
		else
			if @NoRiskAccumulationF=0
				SELECT top 1 Acceptance.RegID, Acceptance.FLDID, Acceptance.ValueID, Case When Acceptance.ValueID='' Then Acceptance.CertificateNo else '' end as CertificateNo,
				@Branch as Branch,    
				@TOC as TOC, 
				@ISType as ISType,
				Max(Case When @ApplyApprLimitByTOLF=1 Then RARRHEADER.CLIMIT*RARRHEADER.LIMIT*100 ELSE 100 END) as ApprLimitPct,  
				sum(RArrHeader.TAmount-RArrHeader.MAmount) as Amount,
				cast(0 as Float) as TotalAmount
				From Acceptance mA
				Inner join Acceptance omA on (omA.OANO=mA.OANO)
				Inner Join Acceptance on (Acceptance.LANO=omA.ANO)
				Left Join Acceptance nAcceptance on (nAcceptance.pANO=Acceptance.ANO)
				Inner Join RARRHEADER on (RArrheader.ANO=Acceptance.ANO)
				WHERE mA.ANO=@P_ANO 
				and Acceptance.AType not in ('A','C') and Acceptance.AStatus in ('W','T','I') 
				and (coalesce(nAcceptance.ANO,0)=0 or (coalesce(nAcceptance.LANO,0)=mA.ANO and coalesce(nAcceptance.AType,'')='C' and mA.AType='C'))
				Group By Acceptance.RegID, Acceptance.FLDID, Acceptance.ValueID, Case When Acceptance.ValueID='' Then Acceptance.CertificateNo else '' end
				Order By sum(RArrHeader.TAmount-RArrHeader.MAmount) Desc            
			else
				SELECT top 1 Acceptance.RegID, Acceptance.FLDID, Acceptance.ValueID, Case When Acceptance.ValueID='' Then Acceptance.CertificateNo else '' end as CertificateNo,
				@Branch as Branch,    
				@TOC as TOC, 
				@ISType as ISType,
				Max(Case When @ApplyApprLimitByTOLF=1 Then RARRHEADER.CLIMIT*RARRHEADER.LIMIT*100 ELSE 100 END) as ApprLimitPct,  
				sum(RArrHeader.TAmount-RArrHeader.MAmount) as Amount,
				cast(0 as Float) as TotalAmount
				From Acceptance mA
				Inner Join Acceptance on (Acceptance.LANO=mA.ANO and Acceptance.RegNo=mA.RegNo)
				Inner Join RARRHEADER on (RArrheader.ANO=Acceptance.ANO)
				WHERE mA.ANO=@P_ANO 
				Group By Acceptance.RegID, Acceptance.FLDID, Acceptance.ValueID, Case When Acceptance.ValueID='' Then Acceptance.CertificateNo else '' end
				Order By sum(RArrHeader.TAmount-RArrHeader.MAmount) Desc            
	end
else
	if @P_ANO<>@LANO
	Begin
		if @OpenFlag=0
			SELECT top 1 Acceptance.RegID, Acceptance.FLDID, Acceptance.ValueID, Case When Acceptance.ValueID='' Then Acceptance.CertificateNo else '' end as CertificateNo,
			@Branch as Branch,    
			@TOC as TOC, 
			@ISType as ISType,
			Case When @ApplyApprLimitByTOLF=1 Then RARRHEADER.CLIMIT*RARRHEADER.LIMIT*100 ELSE 100 END as ApprLimitPct,  
			(RArrHeader.TAmount-RArrHeader.MAmount) as Amount,
			(RArrHeader.TAmount-RArrHeader.MAmount)+coalesce(dbo.fn_GetTotalSumInsured(Acceptance.SDate,Acceptance.RegID, Acceptance.FLDID, Acceptance.ValueID,Acceptance.OANO),0) as TotalAmount
			From Acceptance
			Inner Join RARRHEADER on (RArrheader.ANO=Acceptance.ANO)
			WHERE Acceptance.ANO=@P_ANO
		else
			SELECT top 1 Acceptance.RegID, Acceptance.FLDID, Acceptance.ValueID, Case When Acceptance.ValueID='' Then Acceptance.CertificateNo else '' end as CertificateNo,
			@Branch as Branch,    
			@TOC as TOC, 
			@ISType as ISType,
			Case When @ApplyApprLimitByTOLF=1 Then RARRHEADER.CLIMIT*RARRHEADER.LIMIT*100 ELSE 100 END as ApprLimitPct,  
			(RArrHeader.TAmount-RArrHeader.MAmount) as Amount,
			(RArrHeader.TAmount-RArrHeader.MAmount)+coalesce(dbo.fn_GetTotalSumInsured(Acceptance.SDate,Acceptance.RegID, Acceptance.FLDID, Acceptance.ValueID,Acceptance.OANO),0) as TotalAmount
			From Acceptance
			Inner Join RARRHEADER on (RArrheader.ANO=Acceptance.ANO)
			WHERE Acceptance.ANO=@P_ANO
			-- No Master Acceptance Limit Of Liability
			and (@ApplyApprLimitOCF=1 or not exists (Select Top 1 mA.ANO from Acceptance mA Inner Join ICover I on (I.ANO=mA.ANO) Where mA.ANO=Acceptance.LANO and I.Category='M' and I.Amount<>0))
	end
	else 
	Begin
		if @OpenFlag=1	--Master Open Cover
			SELECT top 1 Acceptance.RegID, Acceptance.FLDID, Acceptance.ValueID, Case When Acceptance.ValueID='' Then Acceptance.CertificateNo else '' end as CertificateNo,
			@Branch as Branch,    
			@TOC as TOC, 
			@ISType as ISType,
			100 as ApprLimitPct,  
			sum(ICover.Amount*dbo.fn_GetReinsuranceRate(Acceptance.TOC,ICover.Currency,Acceptance.SDate,@PHolder)) 
			* coalesce((Select sum(Share) from AISource ISource Where ISource.ANO=Acceptance.ANO),100)/100				
			* (100-coalesce((Select sum(Share) from Coinsurance Where CNO=Acceptance.CNO),0))/100				
			as Amount,
			cast(0 as Float) as TotalAmount
			From Acceptance
			Inner Join ICover on (ICover.ANO=Acceptance.ANO)
			WHERE Acceptance.ANO=@P_ANO
			and ICover.Category='M'
			Group by Acceptance.CNO, Acceptance.ANO, Acceptance.RegID, Acceptance.FLDID, Acceptance.ValueID, Case When Acceptance.ValueID='' Then Acceptance.CertificateNo else '' end
		else
			SELECT top 1 Acceptance.RegID, Acceptance.FLDID, Acceptance.ValueID, Case When Acceptance.ValueID='' Then Acceptance.CertificateNo else '' end as CertificateNo, 
			@Branch as Branch,    
			@TOC as TOC, 
			@ISType as ISType,
			Max(Case When @ApplyApprLimitByTOLF=1 Then RARRHEADER.CLIMIT*RARRHEADER.LIMIT*100 ELSE 100 END) as ApprLimitPct,  
			Sum(RArrHeader.TAmount-RArrHeader.MAmount) as Amount,
			Sum(RArrHeader.TAmount-RArrHeader.MAmount)+coalesce(dbo.fn_GetTotalSumInsured(Min(Acceptance.SDate),Acceptance.RegID, Acceptance.FLDID, Acceptance.ValueID,Max(mA.OANO)),0) as TotalAmount
			From Acceptance mA
			Inner join Acceptance omA on (omA.OANO=mA.OANO)
			Inner Join Acceptance on (Acceptance.LANO=omA.ANO)
			Left Join Acceptance nAcceptance on (nAcceptance.pANO=Acceptance.ANO)
			Inner Join RARRHEADER on (RArrheader.ANO=Acceptance.ANO)
			WHERE mA.ANO=@P_ANO 
			and Acceptance.AType not in ('A','C') and Acceptance.AStatus in ('W','T','I') 
			and (coalesce(nAcceptance.ANO,0)=0 or (coalesce(nAcceptance.LANO,0)=mA.ANO and coalesce(nAcceptance.AType,'')='C' and mA.AType='C'))
			Group By Acceptance.RegID, Acceptance.FLDID, Acceptance.ValueID, Case When Acceptance.ValueID='' Then Acceptance.CertificateNo else '' end
			Order By Sum(RArrHeader.TAmount-RArrHeader.MAmount)+coalesce(dbo.fn_GetTotalSumInsured(Min(Acceptance.SDate),Acceptance.RegID, Acceptance.FLDID, Acceptance.ValueID,Max(mA.OANO)),0) Desc  

	end

GO

DROP Procedure QRCESSIONDET
GO
CREATE Procedure QRCESSIONDET (@P_ANO integer,@P_RID varchar(255), @P_ID varchar(255), @P_DocNo varchar(255), @P_CCY varchar(255), @P_SDate DateTime, @P_EDate DateTime, @P_Code varchar(10), @P_AdjustableF bit,@P_TSI as Float=0, @P_ASDate as DateTime=0)   

              
AS            
Declare @Premium_Treaty_Discount as Float            
Declare @Premium_Discount as Float            
Declare @Premium_Commission as Float            
Declare @Premium_Commission_Inward as Float            
Declare @Premium_Fee as Float            
Declare @Premium_OutGo as Float            
Declare @P_TOC as varchar(10)    
Declare @P_AType as varchar(1)    
Declare @P_ONGROSSNet as int    
Declare @P_RateConF as Bit    
Declare @P_NETRATE as Float    
Declare @P_NETRATEDet as Float    
Declare @P_NOFYEARS as Int    
Declare @P_COMM as Float
Declare @P_COMMN as Float    
Declare @P_OnMinPremiumF as Bit    
Declare @P_PPCT as Float    
Declare @P_OnNetPremiumF as Bit    
Declare @P_RNO as int    
Declare @P_RType as varchar(10)        
Declare @P_OPFEEPCT as Float    
Declare @P_FEE as Float    
Declare @P_OANO as int    
Declare @P_COMMPOLICYF as Bit    
Declare @P_PFactor as Float  
Declare @P_IFee as Float  
Declare @P_Period as Int  
Declare @P_Tabarru as Float  
Declare @P_RITabarruF as Bit  
Declare @P_OPFEEF as Bit  
Declare @P_AEDate as smalldatetime
Declare @P_LANO as Int

Select     
@P_Period=cast(datediff(Month,A.SDate, @P_SDate) as integer) / 12 + 1,  
@P_ASDate=A.SDate,
@P_AEDate=A.EDate,
@P_NOFYEARS=datediff(year,A.SDate, A.EDate),     
@P_TOC=A.TOC,     
@P_AType=A.AType,     
@P_ONGROSSNET=R.ONGROSSNET,     
@P_RateConF=R3.RateConF,     
@P_NETRATE=R2.NETRATE,    
@P_NETRATEDet=R4.NETRATE,    
@P_COMM=CASE WHEN R3.COMM<>0 Then R3.COMM ELSE R2.COMM END,    
@P_COMMN=CASE WHEN R3.COMMN<>0 Then R3.COMMN ELSE R2.COMMN END,    
@P_OnMinPremiumF=R2.OnMinPremiumF,    
@P_PPCT=R2.PPCT,    
@P_OnNetPremiumF=R2.OnNetPremiumF,     
@P_RNO=R1.RNO,    
@P_RType=R1.RType,    
@P_OANO=A.OANO,    
@P_FEE=R2.FEE,    
@P_COMMPOLICYF=R2.COMMPOLICYF,  
@P_PFactor=Case When A.ISType='R' Then (100-I.UJrohCedant)/100*(100+I.UjrohReins)/100 else 1 end,  
@Premium_Commission_Inward=coalesce(I2.Fee+I2.HF,coalesce(I.Fee+I.HF,0))+coalesce(I.OC,0),  
@P_Tabarru=(100-A.Ujroh),  
@P_OPFEEF=R3.OPFEEF,
@P_LANO=A.LANO
from Acceptance A  
Inner Join RarrHeader R on (R.ANO=A.ANO)  
Inner Join Cover C on (C.CNO=A.CNO)  
Left Join AISource I on (I.ANO=A.ANO)  
Left Join AISourceDet I2 on (I2.ANO=I.ANO and I2.Code=@P_Code)  
Inner Join Reinsurance R1 on (R1.RID=@P_RID)  
Inner join RPart R2 on (R2.RNO=R1.RNO and R2.ID=@P_ID and R2.DocNo=@P_DocNo)  
Inner Join ReClass R3 on (R3.RNO=R1.RNO and R3.TOC=A.TOC)  
Left Join ReClassDet R4 on (R4.RNO=R3.RNO AND R4.TOC=R3.TOC AND R4.CODE=@P_CODE)    
Where A.ANO=@P_ANO  
  
if @P_OnNetPremiumF=1  
 Select @Premium_Treaty_Discount=dbo.Premium_Treaty_Discount(@P_ANO, @P_Code,@P_Period)            
else  
 Select @Premium_Treaty_Discount=0  
  
if @P_COMMN<>0  
Begin  
 Select @Premium_Discount=dbo.premium_discount(@P_ANO, @P_Code, @P_Period)    
 Select @Premium_Fee=dbo.Premium_Fee(@P_ANO, @P_Period)    
End  
else  
Begin  
 Select @Premium_Discount=0  
 Select @Premium_Fee=0  
End  
  
if @P_COMMN<>0 or (@P_COMMPOLICYF=1 and @P_COMM=0 and @P_COMMN=0)  
 Select @Premium_Commission=dbo.Premium_Commission(@P_ANO, @P_Code, @P_Period,0)+dbo.Premium_MaxOutGo_Vat(@P_ANO, @P_Code, @P_Period,0)    
Else  
 Select @Premium_Commission=0  
  
Select @Premium_outGo=@Premium_Discount+@Premium_Commission+@Premium_Commission_Inward+@Premium_Fee-(Case When @P_OnNetPremiumF=1 Then @Premium_Treaty_Discount else 0 end)  
Select @P_COMM=CASE WHEN @P_COMMPOLICYF=1 and @P_COMM=0 and @P_COMMN=0 Then @Premium_Commission ELSE @P_COMM END    
  
SELECT @P_OPFEEPCT=Case When ROUND(COALESCE(SUM(Gross),0),4)<>0 Then COALESCE(SUM(FEE),0)/ROUND(COALESCE(SUM(Gross),0),4)*100 Else 0 End, @P_RITabarruF=coalesce(cast(Max(cast(RITabarruF as Int)) as Bit),0)  
FROM  
(  
	SELECT  
	A2.ANO,  
	Premium.Gross,
	Case   
	When coalesce(A1.Amount,0)<>0 Then  
		A1.Amount*Case When A1.RITabarruF=1 Then cast(100 as Float)/@P_Tabarru Else 1 end 
	When coalesce(A1.AmountPCT,0)<>0 then
		(Premium.Gross)*A1.AmountPCT/100*Case When A1.RITabarruF=1 Then cast(100 as Float)/@P_Tabarru Else 1 end 	
	Else
		0
	End as Fee,
	coalesce(A1.RITabarruF,cast(0 as Bit)) as RITabarruF
	from   
	Acceptance A2  
	INNER Join PCalc on (PCalc.ANO=A2.ANO and PCalc.Currency=@P_CCY)  
	Outer Apply (
		Select 
		sum(case When A1.PolicyYear<>0 then 
			A1.Amount*case When A1.ContributionF=1 Then 1 Else 100/coalesce(R.PCTSHARE-R.MSHARE,100) End
		else 
			A1.Amount*case When A1.ContributionF=1 Then 1 Else 100/coalesce(R.PCTSHARE-R.MSHARE,100) End*cast(dbo.fn_Premium_Calc_Prorata(@P_SDate, @P_EDate, 0,1,2) as Float)/cast(dbo.fn_Premium_Calc_Prorata(@P_ASDate, @P_AEDate,0,1,2) as Float)
		End) as Amount,
		sum(A1.AMOUNTPCT) as AMOUNTPCT, MAX(A1.AMOUNTPCTBASED) as AMOUNTPCTBASED, Cast(MAX(Cast(A1.RITabarruF as Int)) as Bit) as RITabarruF
		from AccFD A1
		Inner Join RARRHEADER R on (R.ANO=A2.ANO)
		Inner Join FDTAB on (FDTAB.FDID=A1.FDID and Left(FDTAB.FDType,1)='O')
		Where A1.ANO=A2.ANO and A1.Currency=PCalc.Currency and (A1.ContributionF=1 or A1.CessionF=1) and A1.AmountPCTBased in (0,3) And (A1.PolicyYear=0 or A1.PolicyYear=@P_Period)
	) A1
	Outer APPLY
	(
		Select coalesce(sum(Gross),0) as Gross
		from
		(
			Select   
			Case			
			When coalesce(A1.AMOUNTPCTBASED,0)<>3 then
				D1.Gross*D1.Prorata*P.Gross/P.OGross
			else
				D1.Gross*D1.Prorata*P.Gross/P.OGross*(100-D1.Discount-D1.Commission)/100
			End as Gross
			from Display_Calculation(A2.ANO) D1  
			Inner Join Acceptance A on (A.ANO=D1.ANO)  
			Inner Join PCalc P on (P.ANO=D1.ANO and P.Currency=D1.Currency)  
			Where D1.Currency=@P_CCY  
			and (@P_Period=0 or (D1.SDate>=dateadd(month,12*(@P_Period-1),A.SDate) and D1.SDate<dateadd(month,12*(@P_Period),A.SDate)))
		) Premium
	) Premium
   	Where @P_RType in ('Q','S1','S2','S3','A') and A2.OANO=@P_OANO and A2.ANO<=@P_ANO    
	and A2.ANO>(Select coalesce(Max(ANO),0) from Acceptance Where AType='C' and EMethod='A' and Acceptance.OANO=@P_OANO and Acceptance.ANO<=@P_ANO and AStatus not in ('W','T'))  


	Union All  
  
	--Op Fee from Master Policy  
	SELECT  
	A2.ANO,  
	0 as Gross,
	Case   
	When coalesce(A1.Amount,0)<>0 Then  
		--Not Yet for Master Policy  
		0  
	When coalesce(A1.AmountPCT,0)<>0 Then  
		(Premium.Gross)*A1.AmountPCT/100*Case When A1.RITabarruF=1 Then cast(100 as Float)/@P_Tabarru Else 1 end 	
	Else
		0
	End as Fee,
	coalesce(A1.RITabarruF,cast(0 as Bit)) as RITabarruF
	from   
	Acceptance A2  
	INNER Join PCalc on (PCalc.ANO=A2.ANO and PCalc.Currency=@P_CCY)  
	INNER JOIN Acceptance MA on (MA.PolicyNo<>'' and MA.RegNo=A2.RegNo and MA.ANO=MA.LANO)  
	INNER JOIN COVER C on (C.CNO=MA.CNO and C.OPENFLAG=0)  
	Outer Apply (
		Select 
		sum(case When A1.PolicyYear<>0 then 
			A1.Amount*case When A1.ContributionF=1 Then 1 Else 100/coalesce(R.PCTSHARE-R.MSHARE,100) End
		else 
			A1.Amount*case When A1.ContributionF=1 Then 1 Else 100/coalesce(R.PCTSHARE-R.MSHARE,100) End*cast(dbo.fn_Premium_Calc_Prorata(@P_SDate, @P_EDate, 0,1,2) as Float)/cast(dbo.fn_Premium_Calc_Prorata(@P_ASDate, @P_AEDate,0,1,2) as Float)
		End) as Amount,
		sum(A1.AMOUNTPCT) as AMOUNTPCT, MAX(A1.AMOUNTPCTBASED) as AMOUNTPCTBASED, Cast(MAX(Cast(A1.RITabarruF as Int)) as Bit) as RITabarruF
		from AccFD A1
		Inner Join RArrHeader R on (R.ANO=A2.ANO)
		Inner Join FDTAB on (FDTAB.FDID=A1.FDID and Left(FDTAB.FDType,1)='O')
		Where A1.ANO=MA.ANO and A1.Currency=PCalc.Currency and (A1.ContributionF=1 or A1.CessionF=1) and A1.AmountPCTBased in (0,3) And (A1.PolicyYear=0 or A1.PolicyYear=@P_Period)
	) A1
	Outer APPLY
	(
		Select coalesce(sum(Gross),0) as Gross
		from
		(
			Select   
			Case			
			When coalesce(A1.AMOUNTPCTBASED,0)<>3 then
				D1.Gross*D1.Prorata*P.Gross/P.OGross
			else
				D1.Gross*D1.Prorata*P.Gross/P.OGross*(100-D1.Discount-D1.Commission)/100
			End as Gross
			from Display_Calculation(A2.ANO) D1  
			Inner Join Acceptance A on (A.ANO=D1.ANO)  
			Inner Join PCalc P on (P.ANO=D1.ANO and P.Currency=D1.Currency)  
			Where D1.Currency=@P_CCY  
			and (@P_Period=0 or (D1.SDate>=dateadd(month,12*(@P_Period-1),A.SDate) and D1.SDate<dateadd(month,12*(@P_Period),A.SDate)))
		) Premium
	) Premium
	Where @P_LANO<>-1 and @P_RType in ('Q','S1','S2','S3','A') and A2.OANO=@P_OANO and A2.ANO<=@P_ANO    
	and A2.ANO>(Select coalesce(Max(ANO),0) from Acceptance Where AType='C' and EMethod='A' and Acceptance.OANO=@P_OANO and Acceptance.ANO<=@P_ANO and AStatus not in ('W','T'))  
) A  
Where @P_OPFEEF=1  
  
Select                
sum(Case When OnMinPremiumF=0 Then (case When Gross_1>Gross_2 then Gross_1 else Gross_2 end) else (case When Gross_1<Gross_2 and Gross_1<>0 then Gross_1 else Gross_2 end) end) as Premium,             
sum(Case When OnMinPremiumF=0 Then (case When Gross_1>Gross_2 then Comm_1 else Comm_2 end) else (case When Gross_1<Gross_2 and Gross_1<>0 then Comm_1 else Comm_2 end) end) as Commission,           
sum(Case When OnMinPremiumF=0 Then (case When Gross_1>Gross_2 then Disc_1 else Disc_2 end) else (case When Gross_1<Gross_2 and Gross_1<>0 then Disc_1 else Disc_2 end) end) as Discount,    
sum(Case When OnMinPremiumF=0 Then (case When Gross_1>Gross_2 then Fee_1 else Fee_2 end) else (case When Gross_1<Gross_2 and Gross_1<>0 then Fee_1 else Fee_2 end) end) as Fee                
From            
(
select                
Cast(@P_OnMinPremiumF as integer) as OnMinPremiumF,                
coalesce(SUM((CASE WHEN @P_PPCT<>0 THEN @P_PPCT/100 ELSE (Case When @P_RateConF=1 and (RRateCon.Rate is not null or RateCon.Rate is not null) then 0 else 1 end) END * ICALC.GROSS*(PCALC.PGROSS*@P_PFactor)/PCALC.POGROSS*(100-@Premium_Treaty_Discount)/100-(ICALC.GROSS*PCALC.PGROSS/PCALC.POGROSS*@P_OPFEEPCT/100))*(Case When @P_COMMN=0 Then @P_COMM/100 else (Case When RCover.NetRateF=1 or @P_ONGROSSNET=2 OR (@P_ONGROSSNET=0 AND (100-@Premium_OutGo)/100*(100-@P_COMMN)/100<(100-@P_COMM)/100) Then (100-@Premium_OutGo)/100*(@P_COMMN)/100 else @P_COMM/100 end) end)),0) AS COMM_1,                
coalesce(SUM((Case When @P_RateConF=1 Then (Case When RRateCon.Rate is null then RateCon.Rate*(Case When RateCon.Loading<>0 then RateCon.Loading/100 else RCover.Loading end) else RRateCon.Rate/PCalc.RiskNum*(Case When RRateCon.Loading<>0 then RRateCon.Loading/100 else RCover.Loading end) end) Else coalesce(@P_NETRATEDet,@P_NETRATE/PCalc.RiskNum) end/100*(100-RCover.Discount)/100*ICALC.GROSS/PCALC.GROSS*ICALC.PRORATA *ICALC.TSI*(CASE WHEN RCOVER.PCALC='S' OR RCOVER.PCTLOSS=0 THEN 100 ELSE RCOVER.PCTLOSS END)/(CASE WHEN RCOVER.PCTLOSS=0 THEN 100 ELSE RCOVER.PCTLOSS END+RCOVER.PAddition)*ICALC.PCTADJ/100-(ICALC.GROSS*PCALC.PGROSS/PCALC.POGROSS*@P_OPFEEPCT/100))*(Case When @P_COMMN=0 Then @P_COMM/100 else (Case When RCover.NetRateF=1 or @P_ONGROSSNET=2 OR (@P_ONGROSSNET=0 AND (100-@Premium_OutGo)/100*(100-@P_COMMN)/100<(100-@P_COMM)/100) Then (100-@Premium_OutGo)/100*(@P_COMMN)/100 else @P_COMM/100 end) end)),0) AS COMM_2,                
  
coalesce(SUM((CASE WHEN @P_PPCT<>0 THEN @P_PPCT/100 ELSE (Case When @P_RateConF=1 and (RRateCon.Rate is not null or RateCon.Rate is not null) then 0 else 1 end) END * ICALC.GROSS*(PCALC.PGROSS*@P_PFactor)/PCALC.POGROSS*(100-@Premium_Treaty_Discount)/100)*(Case When @P_COMMN=0 Then 1 else (Case When RCover.NetRateF=1 or @P_ONGROSSNET=2 OR (@P_ONGROSSNET=0 AND (100-@Premium_OutGo)/100*(100-@P_COMMN)/100<(100-@P_COMM)/100) Then 1 else 1 end) end)-(Case When @P_RITabarruF=1 Then 1 Else 0 end)*(ICALC.GROSS*PCALC.PGROSS/PCALC.POGROSS*@P_OPFEEPCT/100)),0) AS GROSS_1,              
coalesce(SUM((Case When @P_RateConF=1 Then (Case When RRateCon.Rate is null then RateCon.Rate*(Case When RateCon.Loading<>0 then RateCon.Loading/100 else RCover.Loading end) else RRateCon.Rate/PCalc.RiskNum*(Case When RRateCon.Loading<>0 then RRateCon.Loading/100 else RCover.Loading end) end) Else coalesce(@P_NETRATEDet,@P_NETRATE/PCalc.RiskNum) end/100*(100-RCover.Discount)/100*ICALC.GROSS/PCALC.GROSS*ICALC.PRORATA *ICALC.TSI*(CASE WHEN RCOVER.PCALC='S' OR RCOVER.PCTLOSS=0 THEN 100 ELSE RCOVER.PCTLOSS END)/(CASE WHEN RCOVER.PCTLOSS=0 THEN 100 ELSE RCOVER.PCTLOSS END+RCOVER.PAddition)*ICALC.PCTADJ/100)*(Case When @P_COMMN=0 Then 1 else (Case When RCover.NetRateF=1 or @P_ONGROSSNET=2 OR (@P_ONGROSSNET=0 AND (100-@Premium_OutGo)/100*(100-@P_COMMN)/100<(100-@P_COMM)/100) Then 1 else 1 end) end)-(Case When @P_RITabarruF=1 Then 1 Else 0 end)*(ICALC.GROSS*PCALC.PGROSS/PCALC.POGROSS*@P_OPFEEPCT/100)),0) AS GROSS_2,                
               
coalesce(SUM((CASE WHEN @P_PPCT<>0 THEN @P_PPCT/100 ELSE (Case When @P_RateConF=1 and (RRateCon.Rate is not null or RateCon.Rate is not null) then 0 else 1 end) END * ICALC.GROSS*(PCALC.PGROSS*@P_PFactor)/PCALC.POGROSS*(100-@Premium_Treaty_Discount)/100-(ICALC.GROSS*PCALC.PGROSS/PCALC.POGROSS*@P_OPFEEPCT/100))*(Case When @P_COMMN=0 Then 0 else (Case When RCover.NetRateF=1 or @P_ONGROSSNET=2 OR (@P_ONGROSSNET=0 AND (100-@Premium_OutGo)/100*(100-@P_COMMN)/100<(100-@P_COMM)/100) Then (@Premium_OutGo)/100 else 0 end) end)),0) AS DISC_1,         
coalesce(SUM((Case When @P_RateConF=1 Then (Case When RRateCon.Rate is null then RateCon.Rate*(Case When RateCon.Loading<>0 then RateCon.Loading/100 else RCover.Loading end) else RRateCon.Rate/PCalc.RiskNum*(Case When RRateCon.Loading<>0 then RRateCon.Loading/100 else RCover.Loading end) end) Else coalesce(@P_NETRATEDet,@P_NETRATE/PCalc.RiskNum) end/100*(100-RCover.Discount)/100*ICALC.GROSS/PCALC.GROSS*ICALC.PRORATA *ICALC.TSI*(CASE WHEN RCOVER.PCALC='S' OR RCOVER.PCTLOSS=0 THEN 100 ELSE RCOVER.PCTLOSS END)/(CASE WHEN RCOVER.PCTLOSS=0 THEN 100 ELSE RCOVER.PCTLOSS END+RCOVER.PAddition)*ICALC.PCTADJ/100-(ICALC.GROSS*PCALC.PGROSS/PCALC.POGROSS*@P_OPFEEPCT/100))*(Case When @P_COMMN=0 Then 0 else (Case When RCover.NetRateF=1 or @P_ONGROSSNET=2 OR (@P_ONGROSSNET=0 AND (100-@Premium_OutGo)/100*(100-@P_COMMN)/100<(100-@P_COMM)/100) Then (@Premium_OutGo)/100 else 0 end) end)),0) AS DISC_2,    
  
coalesce(SUM((CASE WHEN @P_PPCT<>0 THEN @P_PPCT/100 ELSE (Case When @P_RateConF=1 and (RRateCon.Rate is not null or RateCon.Rate is not null) then 0 else 1 end) END * ICALC.GROSS*(PCALC.PGROSS*@P_PFactor)/PCALC.POGROSS*(100-@Premium_Treaty_Discount)/100)*(Case When @P_COMMN=0 Then 1 else (Case When RCover.NetRateF=1 or @P_ONGROSSNET=2 OR (@P_ONGROSSNET=0 AND (100-@Premium_OutGo)/100*(100-@P_COMMN)/100<(100-@P_COMM)/100) Then 1 else 1 end) end)*@P_FEE/100-(Case When @P_RITabarruF=0 Then 1 Else 0 end)*(ICALC.GROSS*PCALC.PGROSS/PCALC.POGROSS*@P_OPFEEPCT/100)),0) AS FEE_1,                
coalesce(SUM((Case When @P_RateConF=1 Then (Case When RRateCon.Rate is null then RateCon.Rate*(Case When RateCon.Loading<>0 then RateCon.Loading/100 else RCover.Loading end) else RRateCon.Rate/PCalc.RiskNum*(Case When RRateCon.Loading<>0 then RRateCon.Loading/100 else RCover.Loading end) end) Else coalesce(@P_NETRATEDet,@P_NETRATE/PCalc.RiskNum) end/100*(100-RCover.Discount)/100*ICALC.GROSS/PCALC.GROSS*ICALC.PRORATA *ICALC.TSI*(CASE WHEN RCOVER.PCALC='S' OR RCOVER.PCTLOSS=0 THEN 100 ELSE RCOVER.PCTLOSS END)/(CASE WHEN RCOVER.PCTLOSS=0 THEN 100 ELSE RCOVER.PCTLOSS END+RCOVER.PAddition)*ICALC.PCTADJ/100)*(Case When @P_COMMN=0 Then 1 else (Case When RCover.NetRateF=1 or @P_ONGROSSNET=2 OR (@P_ONGROSSNET=0 AND (100-@Premium_OutGo)/100*(100-@P_COMMN)/100<(100-@P_COMM)/100) Then 1 else 1 end) end)*@P_FEE/100-(Case When @P_RITabarruF=0 Then 1 Else 0 end)*(ICALC.GROSS*PCALC.PGROSS/PCALC.POGROSS*@P_OPFEEPCT/100)),0) AS FEE_2    
                
FROM ICALC     
INNER JOIN ACCEPTANCE SACCEPTANCE ON (SACCEPTANCE.ANO=ICALC.SANO)    
INNER JOIN RCOVER ON (RCOVER.ANO=ICALC.SANO AND RCOVER.CODE=ICALC.CODE AND (RCOVER.SDATE=ICALC.SDATE OR (@P_AType='A' AND (CASE WHEN RCOVER.SDATE<SACCEPTANCE.PDATE THEN SACCEPTANCE.PDATE ELSE RCOVER.SDATE END)=ICALC.SDATE)))    
LEFT JOIN RPARTDET ON (RPARTDET.RNO=@P_RNO AND RPARTDET.ID=@P_ID AND RPartDet.DocNo=@P_DocNo AND RPARTDET.TOR=ICALC.TOR)    
LEFT Join FN_RateCon(@P_ANO, @P_CODE,@P_TSI,@P_ASDate) RateCon On (@P_RateConF=1 and RateCon.Code=ICalc.Code)    
LEFT Join FN_RRateCon(@P_ANO, @P_RID, @P_TSI) RRateCon On (@P_RateConF=1)                
INNER JOIN ICOVER ON (ICOVER.INO=ICALC.INO AND (ICOVER.ADJUSTABLE=@P_ADJUSTABLEF OR @P_AType='A'))    
INNER JOIN RCALC ON (RCALC.ANO=ICALC.ANO AND RCALC.CURRENCY=ICALC.CURRENCY AND RCALC.CODE=ICALC.CODE AND RCALC.TOR=ICALC.TOR AND RCALC.SDATE=ICALC.SDATE AND RCALC.EDATE=ICALC.EDATE AND RCALC.SANO=ICALC.SANO AND RCALC.EXTREATYF=0)    
INNER JOIN PCALC_ANNUM(@P_ANO) PCALC ON (PCALC.ANO=ICALC.ANO AND PCALC.CODE=ICALC.CODE AND PCALC.SDATE=ICALC.SDATE AND PCALC.EDATE=ICALC.EDATE AND PCALC.INO=ICALC.INO AND PCALC.CURRENCY=ICALC.CURRENCY)    
WHERE ICALC.ANO=@P_ANO AND ICALC.CURRENCY=@P_CCY AND ICALC.SDATE=@P_SDATE AND ICALC.EDATE=@P_EDATE AND ICALC.CODE=@P_CODE                
AND RPARTDET.TOR IS NULL AND PCALC.GROSS<>0    
  
Union All                
  
select                
  
Cast(@P_OnMinPremiumF as integer) as OnMinPremiumF,           
  
coalesce(SUM((CASE WHEN RPARTDET.PPCT<>0 THEN RPARTDET.PPCT/100 ELSE (Case When @P_RateConF=1 and (RRateCon.Rate is not null or RateCon.Rate is not null) then 0 else 1 end) END * ICALC.GROSS*(PCALC.PGROSS*@P_PFactor)/PCALC.POGROSS-(ICALC.GROSS*PCALC.PGROSS/PCALC.POGROSS*@P_OPFEEPCT/100))*(100-@Premium_Treaty_Discount)/100*(Case When RPARTDET.COMMN=0 Then RPARTDET.COMM/100 else (Case When RCover.NetRateF=1 or @P_ONGROSSNET=2 OR (@P_ONGROSSNET=0 AND (100-@Premium_OutGo)/100*(100-RPARTDET.CommN)/100<(100-RPARTDET.COMM)/100) Then (100-@Premium_OutGo)/100*(RPARTDET.CommN)/100 else RPARTDET.COMM/100 end) end)),0) AS COMM_1,                
coalesce(SUM((Case When @P_RateConF=1 Then (Case When RRateCon.Rate is null then RateCon.Rate*(Case When RateCon.Loading<>0 then RateCon.Loading/100 else RCover.Loading end) else RRateCon.Rate/PCalc.RiskNum*(Case When RRateCon.Loading<>0 then RRateCon.Loading/100 else RCover.Loading end) end) Else coalesce(@P_NETRATEDet,RPartDet.NetRate*datediff(day,@P_Sdate, @P_EDate)/datediff(day,@P_ASdate, @P_AEDate)) end/100*(100-RCover.Discount)/100*ICALC.GROSS/PCALC.GROSS*ICALC.PRORATA *ICALC.TSI*(CASE WHEN RCOVER.PCALC='S' OR RCOVER.PCTLOSS=0 THEN 100 ELSE RCOVER.PCTLOSS END)/(CASE WHEN RCOVER.PCTLOSS=0 THEN 100 ELSE RCOVER.PCTLOSS END+RCOVER.PAddition)*ICALC.PCTADJ/100-(ICALC.GROSS*PCALC.PGROSS/PCALC.POGROSS*@P_OPFEEPCT/100))*(Case When RPARTDET.COMMN=0 Then RPARTDET.COMM/100 else (Case When RCover.NetRateF=1 or @P_ONGROSSNET=2 OR (@P_ONGROSSNET=0 AND (100-@Premium_OutGo)/100*(100-RPARTDET.CommN)/100<(100-RPARTDET.COMM)/100) Then (100-@Premium_OutGo)/100*(RPARTDET.CommN)/100 else RPARTDET.COMM/100 end) end)),0) AS COMM_2,                    
                
coalesce(SUM((CASE WHEN RPARTDET.PPCT<>0 THEN RPARTDET.PPCT/100 ELSE (Case When @P_RateConF=1 and (RRateCon.Rate is not null or RateCon.Rate is not null) then 0 else 1 end) END * ICALC.GROSS*(PCALC.PGROSS*@P_PFactor)/PCALC.POGROSS)*(100-@Premium_Treaty_Discount)/100*(Case When RPARTDET.COMMN=0 Then 1 else (Case When RCover.NetRateF=1 or @P_ONGROSSNET=2 OR (@P_ONGROSSNET=0 AND (100-@Premium_OutGo)/100*(100-RPARTDET.CommN)/100<(100-RPARTDET.COMM)/100) Then 1 else 1 end) end)-(Case When @P_RITabarruF=1 Then 1 Else 0 end)*(ICALC.GROSS*PCALC.PGROSS/PCALC.POGROSS*@P_OPFEEPCT/100)),0) AS GROSS_1,                
coalesce(SUM((Case When @P_RateConF=1 Then (Case When RRateCon.Rate is null then RateCon.Rate*(Case When RateCon.Loading<>0 then RateCon.Loading/100 else RCover.Loading end) else RRateCon.Rate/PCalc.RiskNum*(Case When RRateCon.Loading<>0 then RRateCon.Loading/100 else RCover.Loading end) end) Else coalesce(@P_NETRATEDet,RPartDet.NetRate*datediff(day,@P_Sdate, @P_EDate)/datediff(day,@P_ASdate, @P_AEDate)) end/100*(100-RCover.Discount)/100*ICALC.GROSS/PCALC.GROSS*ICALC.PRORATA *ICALC.TSI*(CASE WHEN RCOVER.PCALC='S' OR RCOVER.PCTLOSS=0 THEN 100 ELSE RCOVER.PCTLOSS END)/(CASE WHEN RCOVER.PCTLOSS=0 THEN 100 ELSE RCOVER.PCTLOSS END+RCOVER.PAddition)*ICALC.PCTADJ/100)*(Case When RPARTDET.COMMN=0 Then 1 else (Case When RCover.NetRateF=1 or @P_ONGROSSNET=2 OR (@P_ONGROSSNET=0 AND (100-@Premium_OutGo)/100*(100-RPARTDET.CommN)/100<(100-RPARTDET.COMM)/100) Then 1 else 1 end) end)-(Case When @P_RITabarruF=1 Then 1 Else 0 end)*(ICALC.GROSS*PCALC.PGROSS/PCALC.POGROSS*@P_OPFEEPCT/100)),0) AS GROSS_2,                
  
coalesce(SUM((CASE WHEN RPARTDET.PPCT<>0 THEN RPARTDET.PPCT/100 ELSE (Case When @P_RateConF=1 and (RRateCon.Rate is not null or RateCon.Rate is not null) then 0 else 1 end) END * ICALC.GROSS*(PCALC.PGROSS*@P_PFactor)/PCALC.POGROSS-(ICALC.GROSS*PCALC.PGROSS/PCALC.POGROSS*@P_OPFEEPCT/100))*(100-@Premium_Treaty_Discount)/100*(Case When RPARTDET.COMMN=0 Then 0 else (Case When RCover.NetRateF=1 or @P_ONGROSSNET=2 OR (@P_ONGROSSNET=0 AND (100-@Premium_OutGo)/100*(100-RPARTDET.CommN)/100<(100-RPARTDET.COMM)/100) Then (@Premium_OutGo)/100 else 0 end) end)),0) AS DISC_1,                
coalesce(SUM((Case When @P_RateConF=1 Then (Case When RRateCon.Rate is null then RateCon.Rate*(Case When RateCon.Loading<>0 then RateCon.Loading/100 else RCover.Loading end) else RRateCon.Rate/PCalc.RiskNum*(Case When RRateCon.Loading<>0 then RRateCon.Loading/100 else RCover.Loading end) end) Else coalesce(@P_NETRATEDet,RPartDet.NetRate*datediff(day,@P_Sdate, @P_EDate)/datediff(day,@P_ASdate, @P_AEDate)) end/100*(100-RCover.Discount)/100*ICALC.GROSS/PCALC.GROSS*ICALC.PRORATA *ICALC.TSI*(CASE WHEN RCOVER.PCALC='S' OR RCOVER.PCTLOSS=0 THEN 100 ELSE RCOVER.PCTLOSS END)/(CASE WHEN RCOVER.PCTLOSS=0 THEN 100 ELSE RCOVER.PCTLOSS END+RCOVER.PAddition)*ICALC.PCTADJ/100-(ICALC.GROSS*PCALC.PGROSS/PCALC.POGROSS*@P_OPFEEPCT/100))*(Case When RPARTDET.COMMN=0 Then 0 else (Case When RCover.NetRateF=1 or @P_ONGROSSNET=2 OR (@P_ONGROSSNET=0 AND (100-@Premium_OutGo)/100*(100-RPARTDET.CommN)/100<(100-RPARTDET.COMM)/100) Then (@Premium_OutGo)/100 else 0 end) end)),0) AS DISC_2,                    
  
coalesce(SUM((CASE WHEN RPARTDET.PPCT<>0 THEN RPARTDET.PPCT/100 ELSE (Case When @P_RateConF=1 and (RRateCon.Rate is not null or RateCon.Rate is not null) then 0 else 1 end) END * ICALC.GROSS*(PCALC.PGROSS*@P_PFactor)/PCALC.POGROSS)*(100-@Premium_Treaty_Discount)/100*(Case When RPARTDET.COMMN=0 Then 1 else (Case When RCover.NetRateF=1 or @P_ONGROSSNET=2 OR (@P_ONGROSSNET=0 AND (100-@Premium_OutGo)/100*(100-RPARTDET.CommN)/100<(100-RPARTDET.COMM)/100) Then 1 else 1 end) end)*@P_FEE/100-(Case When @P_RITabarruF=0 Then 1 Else 0 end)*(ICALC.GROSS*PCALC.PGROSS/PCALC.POGROSS*@P_OPFEEPCT/100)),0) AS FEE_1,                
coalesce(SUM((Case When @P_RateConF=1 Then (Case When RRateCon.Rate is null then RateCon.Rate*(Case When RateCon.Loading<>0 then RateCon.Loading/100 else RCover.Loading end) else RRateCon.Rate/PCalc.RiskNum*(Case When RRateCon.Loading<>0 then RRateCon.Loading/100 else RCover.Loading end) end) Else coalesce(@P_NETRATEDet,RPartDet.NetRate*datediff(day,@P_Sdate, @P_EDate)/datediff(day,@P_ASdate, @P_AEDate)) end/100*(100-RCover.Discount)/100*ICALC.GROSS/PCALC.GROSS*ICALC.PRORATA *ICALC.TSI*(CASE WHEN RCOVER.PCALC='S' OR RCOVER.PCTLOSS=0 THEN 100 ELSE RCOVER.PCTLOSS END)/(CASE WHEN RCOVER.PCTLOSS=0 THEN 100 ELSE RCOVER.PCTLOSS END+RCOVER.PAddition)*ICALC.PCTADJ/100)*(Case When RPARTDET.COMMN=0 Then 1 else (Case When RCover.NetRateF=1 or @P_ONGROSSNET=2 OR (@P_ONGROSSNET=0 AND (100-@Premium_OutGo)/100*(100-RPARTDET.CommN)/100<(100-RPARTDET.COMM)/100) Then 1 else 1 end) end)*@P_FEE/100-(Case When @P_RITabarruF=0 Then 1 Else 0 end)*(ICALC.GROSS*PCALC.PGROSS/PCALC.POGROSS*@P_OPFEEPCT/100)),0) AS FEE_2    
  
FROM ICALC     
INNER JOIN ACCEPTANCE SACCEPTANCE ON (SACCEPTANCE.ANO=ICALC.SANO)    
INNER JOIN RCOVER ON (RCOVER.ANO=ICALC.SANO AND RCOVER.CODE=ICALC.CODE AND (RCOVER.SDATE=ICALC.SDATE OR (@P_AType='A' AND (CASE WHEN RCOVER.SDATE<SACCEPTANCE.PDATE THEN SACCEPTANCE.PDATE ELSE RCOVER.SDATE END)=ICALC.SDATE)))    
INNER JOIN RPARTDET ON (RPARTDET.RNO=@P_RNO AND RPARTDET.ID=@P_ID AND RPARTDET.DocNo=@P_DocNo AND RPARTDET.TOR=ICALC.TOR AND (RPARTDET.NOFYEARS=0 OR RPARTDET.NOFYEARS=@P_NOFYEARS) and RPARTDET.EXCLUDEF=0)    
LEFT Join FN_RateCon(@P_ANO, @P_CODE,@P_TSI,@P_ASDate) RateCon On (@P_RateConF=1 and RateCon.Code=ICalc.Code)    
LEFT Join FN_RRateCon(@P_ANO, @P_RID, @P_TSI) RRateCon On (@P_RateConF=1)                
INNER JOIN ICOVER ON (ICOVER.INO=ICALC.INO AND (ICOVER.ADJUSTABLE=@P_ADJUSTABLEF OR @P_AType='A'))    
INNER JOIN RCALC ON (RCALC.ANO=ICALC.ANO AND RCALC.CURRENCY=ICALC.CURRENCY AND RCALC.CODE=ICALC.CODE AND RCALC.TOR=ICALC.TOR AND RCALC.SDATE=ICALC.SDATE AND RCALC.EDATE=ICALC.EDATE AND RCALC.SANO=ICALC.SANO AND RCALC.EXTREATYF=0)    
INNER JOIN PCALC_ANNUM(@P_ANO) PCALC ON (PCALC.ANO=ICALC.ANO AND PCALC.CODE=ICALC.CODE AND PCALC.SDATE=ICALC.SDATE AND PCALC.EDATE=ICALC.EDATE AND PCALC.INO=ICALC.INO AND PCALC.CURRENCY=ICALC.CURRENCY)    
WHERE ICALC.ANO=@P_ANO AND ICALC.CURRENCY=@P_CCY AND ICALC.SDATE=@P_SDATE AND ICALC.EDATE=@P_EDATE AND ICALC.CODE=@P_CODE                
AND PCALC.GROSS<>0    
  
) R          

GO
DROP Function Premium_HandlingFee
GO
CREATE Function Premium_HandlingFee(@P_ANO as int,@P_Code as varchar(10),@P_Period Int)          
RETURNS Float          
AS          
BEGIN          
 Declare @FEE Float 
 Declare @DetailF bit          
                                            
 Select Top 1 @DetailF=1 from AISourceDet ISourceDet, Acceptance Where ISourceDet.ANO=Acceptance.ANO and Acceptance.ANO=@P_ANO                  
 if @DetailF is null   
 Select @DetailF=0     
   
 if @DetailF=1  
 Begin   
	Select @FEE=ISourceDet.FEE+ISourceDet.HF 
	from Acceptance 
	inner join AISourceDet ISourceDet on (ISourceDet.ANO=Acceptance.ANO and ISourceDet.Code=@P_Code)
	Where Acceptance.ANO=@P_ANO 
 end   
 else 
 Begin   
	Select @FEE=ISource.FEE+ISource.HF+ISource.OC 
	from Acceptance 
	Inner Join AISource ISource on (ISource.ANO=Acceptance.ANO)
	Where Acceptance.ANO=@P_ANO 
 end  
                  
 if @FEE is null          
   Select @FEE=0          
                  
 return(@FEE)          
End          

