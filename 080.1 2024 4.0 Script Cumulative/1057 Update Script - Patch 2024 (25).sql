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
@P_PFactor=Case When C.ISType='R' Then (100-I.UJrohCedant)/100*(100+I.UjrohReins)/100 else 1 end,  
@Premium_Commission_Inward=coalesce(I2.Fee+I2.HF,coalesce(I.Fee+I.HF,0))+coalesce(I.OC,0),  
@P_Tabarru=(100-A.Ujroh),  
@P_OPFEEF=R3.OPFEEF  
from Acceptance A  
Inner Join RarrHeader R on (R.ANO=A.ANO)  
Inner Join Cover C on (C.CNO=A.CNO)  
Left Join ISource I on (I.CNO=A.CNO)  
Left Join ISourceDet I2 on (I2.CNO=A.CNO and I2.Code=@P_Code)  
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
		A1.Amount*100/coalesce(R.PCTSHARE-R.MSHARE,100)*Case When A1.RITabarruF=1 Then cast(100 as Float)/@P_Tabarru Else 1 end 
	When coalesce(A1.AmountPCT,0)<>0 then
		(Premium.Gross-Case When A1.AmountPCTBased=3 Then Premium.Commission Else 0 end)*A1.AmountPCT/100*Case When A1.RITabarruF=1 Then cast(100 as Float)/@P_Tabarru Else 1 end 	
	Else
		0
	End as Fee,
	coalesce(A1.RITabarruF,cast(0 as Bit)) as RITabarruF
	from   
	Acceptance A2  
	INNER JOIN RARRHEADER R ON (R.ANO=A2.ANO)  
	INNER Join PCalc on (PCalc.ANO=A2.ANO and PCalc.Currency=@P_CCY)  
	Outer Apply (
		Select 
		case When A1.PolicyYear<>0 then 
			A1.Amount 
		else 
			A1.Amount*cast(dbo.fn_Premium_Calc_Prorata(@P_SDate, @P_EDate, 0,1,2) as Float)/cast(dbo.fn_Premium_Calc_Prorata(@P_ASDate, @P_AEDate,0,1,2) as Float)
		End as Amount,
		A1.AMOUNTPCT, A1.AMOUNTPCTBASED, A1.RITabarruF 
		from AccFD A1, FDTAB 
		Where A1.ANO=A2.ANO and A1.Currency=PCalc.Currency and (A1.ContributionF=1 or A1.CessionF=1) and A1.AmountPCTBased in (0,3) And (A1.PolicyYear=0 or A1.PolicyYear=@P_Period)
		and FDTAB.FDID=A1.FDID and Left(FDTAB.FDType,1)='O'
	) A1
	Cross APPLY
	(
		Select sum(Gross) as Gross, sum(Commission) as Commission
		from
		(
			Select   
			D1.Gross*P.Gross/P.OGross as Gross,
			D1.Gross*P.Gross/P.OGross*dbo.Premium_Commission(D1.ANO, D1.Code,@P_Period,0) as Commission
			from Display_Calculation(A2.ANO) D1  
			Inner Join Acceptance A on (A.ANO=D1.ANO)  
			Inner Join RARRHEADER R on (R.ANO=D1.ANO)  
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
	Premium.Gross,
	Case   
	When coalesce(A1.Amount,0)<>0 Then  
	--Not Yet for Master Policy  
		0  
	When coalesce(A1.AmountPCT,0)<>0 Then  
		(Premium.Gross-Case When A1.AmountPCTBased=3 Then Premium.Commission Else 0 end)*A1.AmountPCT/100*Case When A1.RITabarruF=1 Then cast(100 as Float)/@P_Tabarru Else 1 end 	
	Else
		0
	End as Fee,
	coalesce(A1.RITabarruF,cast(0 as Bit)) as RITabarruF
	from   
	Acceptance A2  
	INNER JOIN RARRHEADER R ON (R.ANO=A2.ANO)  
	INNER Join PCalc on (PCalc.ANO=A2.ANO and PCalc.Currency=@P_CCY)  
	INNER JOIN Acceptance MA on (MA.RegNo=A2.RegNo and MA.ANO=MA.LANO)  
	INNER JOIN COVER C on (C.CNO=MA.CNO and C.OPENFLAG=0)  
	Outer Apply (
		Select 
		case When A1.PolicyYear<>0 then 
			A1.Amount 
		else 
			A1.Amount*cast(dbo.fn_Premium_Calc_Prorata(@P_SDate, @P_EDate, 0,1,2) as Float)/cast(dbo.fn_Premium_Calc_Prorata(@P_ASDate, @P_AEDate,0,1,2) as Float)
		End as Amount,
		A1.AMOUNTPCT, A1.AMOUNTPCTBASED, A1.RITabarruF 
		from AccFD A1, FDTAB 
		Where A1.ANO=MA.ANO and A1.Currency=PCalc.Currency and (A1.ContributionF=1 or A1.CessionF=1) and A1.AmountPCTBased in (0,3) And (A1.PolicyYear=0 or A1.PolicyYear=@P_Period)
		and FDTAB.FDID=A1.FDID and Left(FDTAB.FDType,1)='O'
	) A1
	Cross APPLY
	(
		Select sum(Gross) as Gross, sum(Commission) as Commission
		from
		(
			Select   
			D1.Gross*P.Gross/P.OGross as Gross,
			D1.Gross*P.Gross/P.OGross*dbo.Premium_Commission(D1.ANO, D1.Code,@P_Period,0) as Commission
			from Display_Calculation(A2.ANO) D1  
			Inner Join Acceptance A on (A.ANO=D1.ANO)  
			Inner Join RARRHEADER R on (R.ANO=D1.ANO)  
			Inner Join PCalc P on (P.ANO=D1.ANO and P.Currency=D1.Currency)  
			Where D1.Currency=@P_CCY  
			and (@P_Period=0 or (D1.SDate>=dateadd(month,12*(@P_Period-1),A.SDate) and D1.SDate<dateadd(month,12*(@P_Period),A.SDate)))
		) Premium
	) Premium
	Where @P_RType in ('Q','S1','S2','S3','A') and A2.OANO=@P_OANO and A2.ANO<=@P_ANO    
	and A2.ANO>(Select coalesce(Max(ANO),0) from Acceptance Where AType='C' and EMethod='A' and Acceptance.OANO=@P_OANO and Acceptance.ANO<=@P_ANO and AStatus not in ('W','T'))  
) A  
Where @P_OPFEEF=1  
  
Select                
sum(Case When OnMinPremiumF=0 Then (case When Gross_1>Gross_2 then Gross_1 else Gross_2 end) else (case When Gross_1<Gross_2 and Gross_1<>0 then Gross_1 else Gross_2 end) end) as Premium,             
sum(Case When OnMinPremiumF=0 Then (case When Gross_1>Gross_2 then Comm_1 else Comm_2 end) else (case When Gross_1<Gross_2 and Gross_1<>0 then Comm_1 else Comm_2 end) end) as Commission,           
sum(Case When OnMinPremiumF=0 Then (case When Gross_1>Gross_2 then Disc_1 else Disc_2 end) else (case When Gross_1<Gross_2 and Gross_1<>0 then Disc_1 else Disc_2 end) end) as Discount,    
sum(Case When OnMinPremiumF=0 Then (case When Gross_1>Gross_2 then Fee_1 else Fee_2 end) else (case When Gross_1<Gross_2 and Gross_1<>0 then Fee_1 else Fee_2 end) end) as Fee                
From            
(select                
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
coalesce(SUM((Case When @P_RateConF=1 Then (Case When RRateCon.Rate is null then RateCon.Rate*(Case When RateCon.Loading<>0 then RateCon.Loading/100 else RCover.Loading end) else RRateCon.Rate/PCalc.RiskNum*(Case When RRateCon.Loading<>0 then RRateCon.Loading/100 else RCover.Loading end) end) Else coalesce(@P_NETRATEDet,RPARTDET.NETRate) end/100*(100-RCover.Discount)/100*ICALC.GROSS/PCALC.GROSS*ICALC.PRORATA *ICALC.TSI*(CASE WHEN RCOVER.PCALC='S' OR RCOVER.PCTLOSS=0 THEN 100 ELSE RCOVER.PCTLOSS END)/(CASE WHEN RCOVER.PCTLOSS=0 THEN 100 ELSE RCOVER.PCTLOSS END+RCOVER.PAddition)*ICALC.PCTADJ/100-(ICALC.GROSS*PCALC.PGROSS/PCALC.POGROSS*@P_OPFEEPCT/100))*(Case When RPARTDET.COMMN=0 Then RPARTDET.COMM/100 else (Case When RCover.NetRateF=1 or @P_ONGROSSNET=2 OR (@P_ONGROSSNET=0 AND (100-@Premium_OutGo)/100*(100-RPARTDET.CommN)/100<(100-RPARTDET.COMM)/100) Then (100-@Premium_OutGo)/100*(RPARTDET.CommN)/100 else RPARTDET.COMM/100 end) end)),0) AS COMM_2,                    
                
coalesce(SUM((CASE WHEN RPARTDET.PPCT<>0 THEN RPARTDET.PPCT/100 ELSE (Case When @P_RateConF=1 and (RRateCon.Rate is not null or RateCon.Rate is not null) then 0 else 1 end) END * ICALC.GROSS*(PCALC.PGROSS*@P_PFactor)/PCALC.POGROSS)*(100-@Premium_Treaty_Discount)/100*(Case When RPARTDET.COMMN=0 Then 1 else (Case When RCover.NetRateF=1 or @P_ONGROSSNET=2 OR (@P_ONGROSSNET=0 AND (100-@Premium_OutGo)/100*(100-RPARTDET.CommN)/100<(100-RPARTDET.COMM)/100) Then 1 else 1 end) end)-(Case When @P_RITabarruF=1 Then 1 Else 0 end)*(ICALC.GROSS*PCALC.PGROSS/PCALC.POGROSS*@P_OPFEEPCT/100)),0) AS GROSS_1,                
coalesce(SUM((Case When @P_RateConF=1 Then (Case When RRateCon.Rate is null then RateCon.Rate*(Case When RateCon.Loading<>0 then RateCon.Loading/100 else RCover.Loading end) else RRateCon.Rate/PCalc.RiskNum*(Case When RRateCon.Loading<>0 then RRateCon.Loading/100 else RCover.Loading end) end) Else coalesce(@P_NETRATEDet,RPARTDET.NETRate) end/100*(100-RCover.Discount)/100*ICALC.GROSS/PCALC.GROSS*ICALC.PRORATA *ICALC.TSI*(CASE WHEN RCOVER.PCALC='S' OR RCOVER.PCTLOSS=0 THEN 100 ELSE RCOVER.PCTLOSS END)/(CASE WHEN RCOVER.PCTLOSS=0 THEN 100 ELSE RCOVER.PCTLOSS END+RCOVER.PAddition)*ICALC.PCTADJ/100)*(Case When RPARTDET.COMMN=0 Then 1 else (Case When RCover.NetRateF=1 or @P_ONGROSSNET=2 OR (@P_ONGROSSNET=0 AND (100-@Premium_OutGo)/100*(100-RPARTDET.CommN)/100<(100-RPARTDET.COMM)/100) Then 1 else 1 end) end)-(Case When @P_RITabarruF=1 Then 1 Else 0 end)*(ICALC.GROSS*PCALC.PGROSS/PCALC.POGROSS*@P_OPFEEPCT/100)),0) AS GROSS_2,                
  
coalesce(SUM((CASE WHEN RPARTDET.PPCT<>0 THEN RPARTDET.PPCT/100 ELSE (Case When @P_RateConF=1 and (RRateCon.Rate is not null or RateCon.Rate is not null) then 0 else 1 end) END * ICALC.GROSS*(PCALC.PGROSS*@P_PFactor)/PCALC.POGROSS-(ICALC.GROSS*PCALC.PGROSS/PCALC.POGROSS*@P_OPFEEPCT/100))*(100-@Premium_Treaty_Discount)/100*(Case When RPARTDET.COMMN=0 Then 0 else (Case When RCover.NetRateF=1 or @P_ONGROSSNET=2 OR (@P_ONGROSSNET=0 AND (100-@Premium_OutGo)/100*(100-RPARTDET.CommN)/100<(100-RPARTDET.COMM)/100) Then (@Premium_OutGo)/100 else 0 end) end)),0) AS DISC_1,                
coalesce(SUM((Case When @P_RateConF=1 Then (Case When RRateCon.Rate is null then RateCon.Rate*(Case When RateCon.Loading<>0 then RateCon.Loading/100 else RCover.Loading end) else RRateCon.Rate/PCalc.RiskNum*(Case When RRateCon.Loading<>0 then RRateCon.Loading/100 else RCover.Loading end) end) Else coalesce(@P_NETRATEDet,RPARTDET.NETRate) end/100*(100-RCover.Discount)/100*ICALC.GROSS/PCALC.GROSS*ICALC.PRORATA *ICALC.TSI*(CASE WHEN RCOVER.PCALC='S' OR RCOVER.PCTLOSS=0 THEN 100 ELSE RCOVER.PCTLOSS END)/(CASE WHEN RCOVER.PCTLOSS=0 THEN 100 ELSE RCOVER.PCTLOSS END+RCOVER.PAddition)*ICALC.PCTADJ/100-(ICALC.GROSS*PCALC.PGROSS/PCALC.POGROSS*@P_OPFEEPCT/100))*(Case When RPARTDET.COMMN=0 Then 0 else (Case When RCover.NetRateF=1 or @P_ONGROSSNET=2 OR (@P_ONGROSSNET=0 AND (100-@Premium_OutGo)/100*(100-RPARTDET.CommN)/100<(100-RPARTDET.COMM)/100) Then (@Premium_OutGo)/100 else 0 end) end)),0) AS DISC_2,                    
  
coalesce(SUM((CASE WHEN RPARTDET.PPCT<>0 THEN RPARTDET.PPCT/100 ELSE (Case When @P_RateConF=1 and (RRateCon.Rate is not null or RateCon.Rate is not null) then 0 else 1 end) END * ICALC.GROSS*(PCALC.PGROSS*@P_PFactor)/PCALC.POGROSS)*(100-@Premium_Treaty_Discount)/100*(Case When RPARTDET.COMMN=0 Then 1 else (Case When RCover.NetRateF=1 or @P_ONGROSSNET=2 OR (@P_ONGROSSNET=0 AND (100-@Premium_OutGo)/100*(100-RPARTDET.CommN)/100<(100-RPARTDET.COMM)/100) Then 1 else 1 end) end)*@P_FEE/100-(Case When @P_RITabarruF=0 Then 1 Else 0 end)*(ICALC.GROSS*PCALC.PGROSS/PCALC.POGROSS*@P_OPFEEPCT/100)),0) AS FEE_1,                
coalesce(SUM((Case When @P_RateConF=1 Then (Case When RRateCon.Rate is null then RateCon.Rate*(Case When RateCon.Loading<>0 then RateCon.Loading/100 else RCover.Loading end) else RRateCon.Rate/PCalc.RiskNum*(Case When RRateCon.Loading<>0 then RRateCon.Loading/100 else RCover.Loading end) end) Else coalesce(@P_NETRATEDet,RPARTDET.NETRate) end/100*(100-RCover.Discount)/100*ICALC.GROSS/PCALC.GROSS*ICALC.PRORATA *ICALC.TSI*(CASE WHEN RCOVER.PCALC='S' OR RCOVER.PCTLOSS=0 THEN 100 ELSE RCOVER.PCTLOSS END)/(CASE WHEN RCOVER.PCTLOSS=0 THEN 100 ELSE RCOVER.PCTLOSS END+RCOVER.PAddition)*ICALC.PCTADJ/100)*(Case When RPARTDET.COMMN=0 Then 1 else (Case When RCover.NetRateF=1 or @P_ONGROSSNET=2 OR (@P_ONGROSSNET=0 AND (100-@Premium_OutGo)/100*(100-RPARTDET.CommN)/100<(100-RPARTDET.COMM)/100) Then 1 else 1 end) end)*@P_FEE/100-(Case When @P_RITabarruF=0 Then 1 Else 0 end)*(ICALC.GROSS*PCALC.PGROSS/PCALC.POGROSS*@P_OPFEEPCT/100)),0) AS FEE_2    
  
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
@P_PFactor=Case When C.ISType='R' Then (100-I.UJrohCedant)/100*(100+I.UjrohReins)/100 else 1 end,  
@Premium_Commission_Inward=coalesce(I2.Fee+I2.HF,coalesce(I.Fee+I.HF,0))+coalesce(I.OC,0),  
@P_Tabarru=(100-A.Ujroh),  
@P_UjrohCedant=R1.UJROHCEDANT,
@P_UjrohReins=R1.UJROHREINS,
@P_OPFEEF=R3.OPFEEF  
from Acceptance A  
Inner Join RarrHeader R on (R.ANO=A.ANO)  
Inner Join Cover C on (C.CNO=A.CNO)  
Left Join ISource I on (I.CNO=A.CNO)  
Left Join ISourceDet I2 on (I2.CNO=A.CNO and I2.Code=@P_Code)  
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
		A1.Amount*100/coalesce(R.PCTSHARE-R.MSHARE,100)*Case When A1.RITabarruF=1 Then cast(100 as Float)/@P_Tabarru Else 1 end 
	When coalesce(A1.AmountPCT,0)<>0 then
		(Premium.Gross-Case When A1.AmountPCTBased=3 Then Premium.Commission Else 0 end)*A1.AmountPCT/100*Case When A1.RITabarruF=1 Then cast(100 as Float)/@P_Tabarru Else 1 end 	
	Else
		0
	End as Fee,
	coalesce(A1.RITabarruF,cast(0 as Bit)) as RITabarruF
	from   
	Acceptance A2  
	INNER JOIN RARRHEADER R ON (R.ANO=A2.ANO)  
	INNER Join PCalc on (PCalc.ANO=A2.ANO and PCalc.Currency=@P_CCY)  
	Outer Apply (
		Select
		case When A1.PolicyYear<>0 then 
			A1.Amount 
		else 
			A1.Amount*cast(dbo.fn_Premium_Calc_Prorata(@P_SDate, @P_EDate, 0,1,2) as Float)/cast(dbo.fn_Premium_Calc_Prorata(@P_ASDate, @P_AEDate,0,1,2) as Float)
		End as Amount,
		A1.AMOUNTPCT, A1.AMOUNTPCTBASED, A1.RITabarruF 
		from AccFD A1, FDTAB 
		Where A1.ANO=A2.ANO and A1.Currency=PCalc.Currency and (A1.ContributionF=1 or A1.CessionF=1) and A1.AmountPCTBased in (0,3) And (A1.PolicyYear=0 or A1.PolicyYear=@P_Period)
		and FDTAB.FDID=A1.FDID and Left(FDTAB.FDType,1)='O'
	) A1
	Cross APPLY
	(
		Select sum(Gross) as Gross, sum(Commission) as Commission
		from
		(
			Select   
			D1.Gross*P.Gross/P.OGross as Gross,
			D1.Gross*P.Gross/P.OGross*dbo.Premium_Commission(D1.ANO, D1.Code,@P_Period,0) as Commission
			from Display_Calculation(A2.ANO) D1  
			Inner Join Acceptance A on (A.ANO=D1.ANO)  
			Inner Join RARRHEADER R on (R.ANO=D1.ANO)  
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
	Premium.Gross,
	Case   
	When coalesce(A1.Amount,0)<>0 Then  
	--Not Yet for Master Policy  
		0  
	When coalesce(A1.AmountPCT,0)<>0 Then  
		(Premium.Gross-Case When A1.AmountPCTBased=3 Then Premium.Commission Else 0 end)*A1.AmountPCT/100*Case When A1.RITabarruF=1 Then cast(100 as Float)/@P_Tabarru Else 1 end 	
	Else
		0
	End as Fee,
	coalesce(A1.RITabarruF,cast(0 as Bit)) as RITabarruF
	from   
	Acceptance A2  
	INNER JOIN RARRHEADER R ON (R.ANO=A2.ANO)  
	INNER Join PCalc on (PCalc.ANO=A2.ANO and PCalc.Currency=@P_CCY)  
	INNER JOIN Acceptance MA on (MA.RegNo=A2.RegNo and MA.ANO=MA.LANO)  
	INNER JOIN COVER C on (C.CNO=MA.CNO and C.OPENFLAG=0)  
	Outer Apply (
		Select 
		case When A1.PolicyYear<>0 then 
			A1.Amount 
		else 
			A1.Amount*cast(dbo.fn_Premium_Calc_Prorata(@P_SDate, @P_EDate, 0,1,2) as Float)/cast(dbo.fn_Premium_Calc_Prorata(@P_ASDate, @P_AEDate,0,1,2) as Float)
		End as Amount,
		A1.AMOUNTPCT, A1.AMOUNTPCTBASED, A1.RITabarruF 
		from AccFD A1, FDTAB 
		Where A1.ANO=MA.ANO and A1.Currency=PCalc.Currency and (A1.ContributionF=1 or A1.CessionF=1) and A1.AmountPCTBased in (0,3) And (A1.PolicyYear=0 or A1.PolicyYear=@P_Period)
		and FDTAB.FDID=A1.FDID and Left(FDTAB.FDType,1)='O'
	) A1
	Cross APPLY
	(
		Select sum(Gross) as Gross, sum(Commission) as Commission
		from
		(
			Select   
			D1.Gross*P.Gross/P.OGross as Gross,
			D1.Gross*P.Gross/P.OGross*dbo.Premium_Commission(D1.ANO, D1.Code,@P_Period,0) as Commission
			from Display_Calculation(A2.ANO) D1  
			Inner Join Acceptance A on (A.ANO=D1.ANO)  
			Inner Join RARRHEADER R on (R.ANO=D1.ANO)  
			Inner Join PCalc P on (P.ANO=D1.ANO and P.Currency=D1.Currency)  
			Where D1.Currency=@P_CCY  
			and (@P_Period=0 or (D1.SDate>=dateadd(month,12*(@P_Period-1),A.SDate) and D1.SDate<dateadd(month,12*(@P_Period),A.SDate)))
		) Premium
	) Premium
	Where @P_RType in ('Q','S1','S2','S3','A') and A2.OANO=@P_OANO and A2.ANO<=@P_ANO    
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
		coalesce(SUM((Case When @P_RateConF=1 Then (Case When RRateCon.Rate is null then RateCon.Rate*(Case When RateCon.Loading<>0 then RateCon.Loading/100 else RCover.Loading end) else RRateCon.Rate/PCalc.RiskNum*(Case When RRateCon.Loading<>0 then RRateCon.Loading/100 else RCover.Loading end) end) Else coalesce(@P_NETRATEDet,RPARTDET.NETRate) end/100*(100-RCover.Discount)/100*ICALC.GROSS/PCALC.GROSS*ICALC.PRORATA *ICALC.TSI*(CASE WHEN RCOVER.PCALC='S' OR RCOVER.PCTLOSS=0 THEN 100 ELSE RCOVER.PCTLOSS END)/(CASE WHEN RCOVER.PCTLOSS=0 THEN 100 ELSE RCOVER.PCTLOSS END+RCOVER.PAddition)*ICALC.PCTADJ/100-(ICALC.GROSS*PCALC.PGROSS/PCALC.POGROSS*@P_OPFEEPCT/100))*(Case When RPARTDET.COMMN=0 Then RPARTDET.COMM/100 else (Case When RCover.NetRateF=1 or @P_ONGROSSNET=2 OR (@P_ONGROSSNET=0 AND (100-@Premium_OutGo)/100*(100-RPARTDET.CommN)/100<(100-RPARTDET.COMM)/100) Then (100-@Premium_OutGo)/100*(RPARTDET.CommN)/100 else RPARTDET.COMM/100 end) end)),0) AS COMM_2,                    
                
		coalesce(SUM((CASE WHEN RPARTDET.PPCT<>0 THEN RPARTDET.PPCT/100 ELSE (Case When @P_RateConF=1 and (RRateCon.Rate is not null or RateCon.Rate is not null) then 0 else 1 end) END * ICALC.GROSS*(PCALC.PGROSS*@P_PFactor)/PCALC.POGROSS)*(100-@Premium_Treaty_Discount)/100*(Case When RPARTDET.COMMN=0 Then 1 else (Case When RCover.NetRateF=1 or @P_ONGROSSNET=2 OR (@P_ONGROSSNET=0 AND (100-@Premium_OutGo)/100*(100-RPARTDET.CommN)/100<(100-RPARTDET.COMM)/100) Then 1 else 1 end) end)-(Case When @P_RITabarruF=1 Then 1 Else 0 end)*(ICALC.GROSS*PCALC.PGROSS/PCALC.POGROSS*@P_OPFEEPCT/100)),0) AS GROSS_1,                
		coalesce(SUM((Case When @P_RateConF=1 Then (Case When RRateCon.Rate is null then RateCon.Rate*(Case When RateCon.Loading<>0 then RateCon.Loading/100 else RCover.Loading end) else RRateCon.Rate/PCalc.RiskNum*(Case When RRateCon.Loading<>0 then RRateCon.Loading/100 else RCover.Loading end) end) Else coalesce(@P_NETRATEDet,RPARTDET.NETRate) end/100*(100-RCover.Discount)/100*ICALC.GROSS/PCALC.GROSS*ICALC.PRORATA *ICALC.TSI*(CASE WHEN RCOVER.PCALC='S' OR RCOVER.PCTLOSS=0 THEN 100 ELSE RCOVER.PCTLOSS END)/(CASE WHEN RCOVER.PCTLOSS=0 THEN 100 ELSE RCOVER.PCTLOSS END+RCOVER.PAddition)*ICALC.PCTADJ/100)*(Case When RPARTDET.COMMN=0 Then 1 else (Case When RCover.NetRateF=1 or @P_ONGROSSNET=2 OR (@P_ONGROSSNET=0 AND (100-@Premium_OutGo)/100*(100-RPARTDET.CommN)/100<(100-RPARTDET.COMM)/100) Then 1 else 1 end) end)-(Case When @P_RITabarruF=1 Then 1 Else 0 end)*(ICALC.GROSS*PCALC.PGROSS/PCALC.POGROSS*@P_OPFEEPCT/100)),0) AS GROSS_2,                
  
		coalesce(SUM((CASE WHEN RPARTDET.PPCT<>0 THEN RPARTDET.PPCT/100 ELSE (Case When @P_RateConF=1 and (RRateCon.Rate is not null or RateCon.Rate is not null) then 0 else 1 end) END * ICALC.GROSS*(PCALC.PGROSS*@P_PFactor)/PCALC.POGROSS-(ICALC.GROSS*PCALC.PGROSS/PCALC.POGROSS*@P_OPFEEPCT/100))*(100-@Premium_Treaty_Discount)/100*(Case When RPARTDET.COMMN=0 Then 0 else (Case When RCover.NetRateF=1 or @P_ONGROSSNET=2 OR (@P_ONGROSSNET=0 AND (100-@Premium_OutGo)/100*(100-RPARTDET.CommN)/100<(100-RPARTDET.COMM)/100) Then (@Premium_OutGo)/100 else 0 end) end)),0) AS DISC_1,                
		coalesce(SUM((Case When @P_RateConF=1 Then (Case When RRateCon.Rate is null then RateCon.Rate*(Case When RateCon.Loading<>0 then RateCon.Loading/100 else RCover.Loading end) else RRateCon.Rate/PCalc.RiskNum*(Case When RRateCon.Loading<>0 then RRateCon.Loading/100 else RCover.Loading end) end) Else coalesce(@P_NETRATEDet,RPARTDET.NETRate) end/100*(100-RCover.Discount)/100*ICALC.GROSS/PCALC.GROSS*ICALC.PRORATA *ICALC.TSI*(CASE WHEN RCOVER.PCALC='S' OR RCOVER.PCTLOSS=0 THEN 100 ELSE RCOVER.PCTLOSS END)/(CASE WHEN RCOVER.PCTLOSS=0 THEN 100 ELSE RCOVER.PCTLOSS END+RCOVER.PAddition)*ICALC.PCTADJ/100-(ICALC.GROSS*PCALC.PGROSS/PCALC.POGROSS*@P_OPFEEPCT/100))*(Case When RPARTDET.COMMN=0 Then 0 else (Case When RCover.NetRateF=1 or @P_ONGROSSNET=2 OR (@P_ONGROSSNET=0 AND (100-@Premium_OutGo)/100*(100-RPARTDET.CommN)/100<(100-RPARTDET.COMM)/100) Then (@Premium_OutGo)/100 else 0 end) end)),0) AS DISC_2,                    
  
		coalesce(SUM((CASE WHEN RPARTDET.PPCT<>0 THEN RPARTDET.PPCT/100 ELSE (Case When @P_RateConF=1 and (RRateCon.Rate is not null or RateCon.Rate is not null) then 0 else 1 end) END * ICALC.GROSS*(PCALC.PGROSS*@P_PFactor)/PCALC.POGROSS)*(100-@Premium_Treaty_Discount)/100*(Case When RPARTDET.COMMN=0 Then 1 else (Case When RCover.NetRateF=1 or @P_ONGROSSNET=2 OR (@P_ONGROSSNET=0 AND (100-@Premium_OutGo)/100*(100-RPARTDET.CommN)/100<(100-RPARTDET.COMM)/100) Then 1 else 1 end) end)*RPART.FEE/100-(Case When @P_RITabarruF=0 Then 1 Else 0 end)*(ICALC.GROSS*PCALC.PGROSS/PCALC.POGROSS*@P_OPFEEPCT/100)),0) AS FEE_1,                
		coalesce(SUM((Case When @P_RateConF=1 Then (Case When RRateCon.Rate is null then RateCon.Rate*(Case When RateCon.Loading<>0 then RateCon.Loading/100 else RCover.Loading end) else RRateCon.Rate/PCalc.RiskNum*(Case When RRateCon.Loading<>0 then RRateCon.Loading/100 else RCover.Loading end) end) Else coalesce(@P_NETRATEDet,RPARTDET.NETRate) end/100*(100-RCover.Discount)/100*ICALC.GROSS/PCALC.GROSS*ICALC.PRORATA *ICALC.TSI*(CASE WHEN RCOVER.PCALC='S' OR RCOVER.PCTLOSS=0 THEN 100 ELSE RCOVER.PCTLOSS END)/(CASE WHEN RCOVER.PCTLOSS=0 THEN 100 ELSE RCOVER.PCTLOSS END+RCOVER.PAddition)*ICALC.PCTADJ/100)*(Case When RPARTDET.COMMN=0 Then 1 else (Case When RCover.NetRateF=1 or @P_ONGROSSNET=2 OR (@P_ONGROSSNET=0 AND (100-@Premium_OutGo)/100*(100-RPARTDET.CommN)/100<(100-RPARTDET.COMM)/100) Then 1 else 1 end) end)*RPART.FEE/100-(Case When @P_RITabarruF=0 Then 1 Else 0 end)*(ICALC.GROSS*PCALC.PGROSS/PCALC.POGROSS*@P_OPFEEPCT/100)),0) AS FEE_2    
  
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



insert into PatchVersioning
select '1057 Update Script - Patch 2024 (25)',GETDATE()
go
	

Declare @PrevScript varchar(100)
Declare @CurrScript varchar(100)

Select @PrevScript=''
Select @CurrSCript='1057 Update Script - Patch 2024 (25)'


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