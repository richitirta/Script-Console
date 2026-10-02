DROP Procedure Get_Fee_Amount_By_Percentage
GO
Create Procedure Get_Fee_Amount_By_Percentage(@P_ANO as Int, @P_Code as varchar(10), @P_FDType as varchar(1), @P_AmountPCT as Float, @P_AmountPCTBased as Int=0, @P_PolicyYear as Int=0)
as
Declare @P_LANO as integer
Declare @P_REGNO as varchar(50)
Declare @P_AStatus as varchar(1)
Declare @P_Fee as Float

Select @P_LANO=LANO, @P_REGNO=REGNO, @P_AStatus=AStatus from Acceptance Where ANO=@P_ANO

if @P_LANO<>@P_ANO -- Individual or Certificate
BEGIN
	if @P_AmountPCTBased=0 or @P_AmountPCTBased=3
	BEGIN
		Select 
		@P_FEE=
		Case 
		When Left(@P_FDTYPE,1)<>'O' Then 
			sum(D1.Gross*(100-D1.Discount)/100*D1.Prorata*P.Gross/P.OGross*P.OurShare/P.TSI*case When @P_AmountPCTBased=3 Then (1-dbo.Premium_Commission(D1.ANO, D1.Code,0,0)/100) else 1 end)
	    Else
			sum(D1.Gross*D1.Prorata*P.Gross/P.OGross*P.OurShare/P.TSI*(100-R.MSHARE)/100*case When @P_AmountPCTBased=3 Then (1-dbo.Premium_Commission(D1.ANO, D1.Code,0,0)/100) else 1 end)
		End*@P_AmountPCT/100
		from Display_Calculation(@P_ANO) D1
		Inner Join Acceptance A on (A.ANO=D1.ANO)
		Inner Join RArrHeader R on (R.ANO=D1.ANO)
		Inner Join PCalc P on (P.ANO=D1.ANO and P.Currency=D1.Currency)
		Where D1.Currency=@P_Code
		and (@P_PolicyYear=0 or (D1.SDate>=dateadd(month,12*(@P_PolicyYear-1),A.SDate) and D1.SDate<dateadd(month,12*(@P_PolicyYear),A.SDate)))
	END
	ELSE
	BEGIN
		Select 
		@P_FEE=
		Case 
		When Left(@P_FDTYPE,1)<>'O' Then 
			coalesce(Max(P.OurShare),0)-coalesce(Max(PP.OurShare),0)
	    Else
			coalesce(Max(P.OurShare*(100-R.MSHARE)/100),0)-coalesce(Max(PP.OurShare*(100-PR.MSHARE)/100),0)
		End*@P_AmountPCT/100
		from Acceptance A
		Left Join Acceptance PA on (PA.ANO=A.PANO)
		Left Join PCalc P on (P.ANO=A.ANO and P.Currency=@P_Code and A.AType Not in ('A','C'))
		Left Join RArrHeader R on (R.ANO=A.ANO and A.AType Not in ('A','C'))
		Left Join PCalc PP on (PP.ANO=A.PANO and PP.Currency=P.Currency and PA.AType Not in ('A','C'))
		Left Join RArrHeader PR on (PR.ANO=A.PANO and PA.AType Not in ('A','C'))		
		Where A.ANO=@P_ANO
	END
END
ELSE	-- Fleet Only
BEGIN
	if @P_AmountPCTBased=0 or @P_AmountPCTBased=3
	BEGIN
		SELECT @P_FEE=SUM(FEE)
		FROM
		(
			SELECT
			ACCEPTANCE.ANO,
			(
				Select 
				Case 
				When Left(@P_FDTYPE,1)<>'O' Then 
					sum(D1.Gross*(100-D1.Discount)/100*D1.Prorata*P.Gross/P.OGross*P.OurShare/P.TSI*case When @P_AmountPCTBased=3 Then (1-dbo.Premium_Commission(D1.ANO, D1.Code,0,0)/100) else 1 end)
				ELSE 
					sum(D1.Gross*D1.Prorata*P.Gross/P.OGross*P.OurShare/P.TSI*(100-R.MSHARE)/100*case When @P_AmountPCTBased=3 Then (1-dbo.Premium_Commission(D1.ANO, D1.Code,0,0)/100) else 1 end)
				End*@P_AmountPCT/100
				from Display_Calculation(ACCEPTANCE.ANO) D1
				Inner Join Acceptance A on (A.ANO=D1.ANO)
				Inner Join RArrHeader R on (R.ANO=D1.ANO)
				Inner Join PCalc P on (P.ANO=D1.ANO and P.Currency=D1.Currency)
				Where D1.Currency=@P_Code
				and (@P_PolicyYear=0 or (D1.SDate>=dateadd(month,12*(@P_PolicyYear-1),A.SDate) and D1.SDate<dateadd(month,12*(@P_PolicyYear),A.SDate)))
			) as FEE
			FROM ACCEPTANCE
			Inner Join COVER on (Cover.CNO=Acceptance.CNO)
			WHERE COVER.OPENFLAG=0 AND ACCEPTANCE.ANO<>ACCEPTANCE.LANO 
			and not (Cover.ASource='MKT' and Acceptance.AType='N' and Cover.CStatus='A') --not Confirm Quotation
			And ((Acceptance.AStatus in ('W','T') and Acceptance.LANO=@P_ANO) or (Acceptance.AStatus not in ('W','T') and Acceptance.RegNo<>'' and Acceptance.RegNo=@P_RegNo))
		) A
	END
	ELSE
	BEGIN
		SELECT @P_FEE=SUM(FEE)
		FROM
		(
			SELECT
			ACCEPTANCE.ANO,
			(
				Select 
				Case 
				When Left(@P_FDTYPE,1)<>'O' Then 
					coalesce(Max(P.OurShare),0)-coalesce(Max(PP.OurShare),0)
				Else
					coalesce(Max(P.OurShare*(100-R.MSHARE)/100),0)-coalesce(Max(PP.OurShare*(100-PR.MSHARE)/100),0)
				End*@P_AmountPCT/100
				from Acceptance A
				Left Join Acceptance PA on (PA.ANO=A.PANO)
				Left Join PCalc P on (P.ANO=A.ANO and P.Currency=@P_Code and A.AType Not in ('A','C'))
				Left Join RArrHeader R on (R.ANO=A.ANO and A.AType Not in ('A','C'))
				Left Join PCalc PP on (PP.ANO=A.PANO and PP.Currency=P.Currency and PA.AType Not in ('A','C'))
				Left Join RArrHeader PR on (PR.ANO=A.PANO and PA.AType Not in ('A','C'))		
				Where A.ANO=ACCEPTANCE.ANO
			) as FEE
			FROM ACCEPTANCE
			Inner Join COVER on (COVER.CNO=ACCEPTANCE.CNO)
			WHERE COVER.OPENFLAG=0 AND ACCEPTANCE.ANO<>ACCEPTANCE.LANO 
			and not (Cover.ASource='MKT' and Acceptance.AType='N' and Cover.CStatus='A') --not Confirm Quotation
			And ((Acceptance.AStatus in ('W','T') and Acceptance.LANO=@P_ANO) or (Acceptance.AStatus not in ('W','T') and Acceptance.RegNo<>'' and Acceptance.RegNo=@P_RegNo))
		) A
	END
END
SELECT @P_FEE AS FEE

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
Declare @P_COMMI as Float  
Declare @P_OnMinPremiumF as Bit  
Declare @P_PPCT as Float  
Declare @P_OnNetPremiumF as Bit  
Declare @P_RNO as int  
Declare @P_RType as varchar(10)  
Declare @P_OPFEE as Float  
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

Select   
@P_Period=cast(datediff(Month,@P_ASDate, @P_SDate) as integer) / 12 + 1,
@P_ASDate=Case When @P_ASDate=0 Then A.SDate else @P_ASDate end,  
@P_NOFYEARS=datediff(year,A.sdate, A.edate),   
@P_TOC=A.TOC,   
@P_AType=A.AType,   
@P_ONGROSSNET=R.ONGROSSNET,   
@P_RateConF=R3.RateConF,   
@P_NETRATE=R2.NETRATE,  
@P_NETRATEDet=R4.NETRATE,  
@P_COMM=CASE WHEN R3.COMM<>0 Then R3.COMM ELSE R2.COMM END,  
@P_COMMN=CASE WHEN R3.COMMN<>0 Then R3.COMMN ELSE R2.COMMN END,  
@P_COMMI=R2.COMMI,  
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

Select @Premium_Treaty_Discount=dbo.Premium_Treaty_Discount(@P_ANO, @P_Code,@P_Period)          
Select @Premium_Discount=dbo.premium_discount(@P_ANO, @P_Code, @P_Period)  
Select @Premium_Commission=dbo.Premium_Commission(@P_ANO, @P_Code, @P_Period,0)+dbo.Premium_MaxOutGo_Vat(@P_ANO, @P_Code, @P_Period,0)  
Select @Premium_Fee=dbo.Premium_Fee(@P_ANO, @P_Period)  
Select @Premium_outGo=@Premium_Discount+@Premium_Commission+@Premium_Commission_Inward+@Premium_Fee-(Case When @P_OnNetPremiumF=1 Then @Premium_Treaty_Discount else 0 end)

SELECT @P_OPFEE=Case When @P_OPFEEF=1 THen COALESCE(SUM(FEE),0) Else 0 End, @P_RITabarruF=coalesce(cast(Max(cast(RITabarruF as Int)) as Bit),0)
FROM
(
       SELECT
       A2.ANO,
       Case 
	   When A1.Amount<>0 Then
            A1.Amount*100/coalesce(R.PCTSHARE-R.MSHARE,100)*Case When A1.RITabarruF=1 Then cast(100 as Float)/@P_Tabarru Else 1 end
	   When A1.AmountPCTBased=0 Then
             (
                    Select 
                    sum(D1.Gross*P.Gross/P.OGross)
                    from Display_Calculation(A2.ANO) D1
					Inner Join Acceptance A on (A.ANO=D1.ANO)
					Inner Join RArrHeader R on (R.ANO=D1.ANO)
					Inner Join PCalc P on (P.ANO=D1.ANO and P.Currency=D1.Currency)
					Where D1.Currency=@P_CCY and A1.RITabarruF=1
             )*A1.AmountPCT/100*Case When A1.RITabarruF=1 Then cast(100 as Float)/@P_Tabarru Else 1 end
       Else
             (
                    Select 
                    sum(D1.Gross*P.Gross/P.OGross*(1-dbo.Premium_Commission(D1.ANO, D1.Code,0,0)/100))
                    from Display_Calculation(A2.ANO) D1
					Inner Join Acceptance A on (A.ANO=D1.ANO)
					Inner Join RArrHeader R on (R.ANO=D1.ANO)
					Inner Join PCalc P on (P.ANO=D1.ANO and P.Currency=D1.Currency)
					Where D1.Currency=@P_CCY and A1.RITabarruF=1
             )*A1.AmountPCT/100*Case When A1.RITabarruF=1 Then cast(100 as Float)/@P_Tabarru Else 1 end
       End    as FEE,
	   A1.RITabarruF
       from 
	   Acceptance A2
       INNER JOIN AccFD A1 on (A1.ANO=A2.ANO and A1.Currency=@P_CCY and (A1.ContributionF=1 or A1.CessionF=1) and A1.AmountPCTBased in (0,3) And (A1.PolicyYear=0 or A1.PolicyYear=@P_Period))
       INNER JOIN FDTAB on (FDTAB.FDID=A1.FDID and Left(FDTAB.FDType,1)='O')
       INNER Join PCalc on (PCalc.ANO=A2.ANO and PCalc.Currency=A1.Currency)
       INNER JOIN RARRHEADER R ON (R.ANO=A2.ANO)
       Where @P_RType in ('Q','S1','S2','S3','A') and A2.OANO=@P_OANO and A2.ANO<=@P_ANO  
	   and A2.ANO>(Select coalesce(Max(ANO),0) from Acceptance Where AType='C' and EMethod='A' and Acceptance.OANO=@P_OANO and Acceptance.ANO<=@P_ANO and AStatus not in ('W','T'))

	   Union All

	   --Op Fee from Master Policy
       SELECT
       A2.ANO,
       Case 
	   When A1.Amount<>0 Then
			--Not Yet for Master Policy
			0
	   When A1.AMOUNTPCTBASED=0 Then
             (
                    Select 
                    sum(D1.Gross*P.Gross/P.OGross)
                    from Display_Calculation(A2.ANO) D1
					Inner Join Acceptance A on (A.ANO=D1.ANO)
					Inner Join RARRHEADER R on (R.ANO=D1.ANO)
					Inner Join PCalc P on (P.ANO=D1.ANO and P.Currency=D1.Currency)
                    Where D1.Currency=@P_CCY
             )*A1.AmountPCT/100*Case When A1.RITabarruF=1 Then cast(100 as Float)/@P_Tabarru Else 1 end
       Else
             (
                    Select 
                    sum(D1.Gross*P.Gross/P.OGross*(1-dbo.Premium_Commission(D1.ANO, D1.Code,0,0)/100))
                    from Display_Calculation(A2.ANO) D1
					Inner Join Acceptance A on (A.ANO=D1.ANO)
					Inner Join RARRHEADER R on (R.ANO=D1.ANO)
					Inner Join PCalc P on (P.ANO=D1.ANO and P.Currency=D1.Currency)
                    Where D1.Currency=@P_CCY
             )*A1.AmountPCT/100*Case When A1.RITabarruF=1 Then cast(100 as Float)/@P_Tabarru Else 1 end
       End    as FEE,
	   A1.RITabarruF
       from 
       Acceptance A2
	   INNER JOIN Acceptance MA on (MA.RegNo=A2.RegNo and MA.ANO=MA.LANO)
	   INNER JOIN COVER C on (C.CNO=MA.CNO and C.OPENFLAG=0)
       INNER JOIN AccFD A1 on (A1.ANO=MA.ANO and A1.Currency=@P_CCY and (A1.ContributionF=1 or A1.CessionF=1) and A1.AmountPCTBased in (0,3) And (A1.PolicyYear=0 or A1.PolicyYear=@P_Period))
       INNER JOIN FDTAB on (FDTAB.FDID=A1.FDID and left(FDTAB.FDType,1)='O')
       INNER Join PCalc on (PCalc.ANO=A2.ANO and PCalc.Currency=A1.Currency)
       INNER JOIN RARRHEADER R ON (R.ANO=A2.ANO)
       Where @P_RType in ('Q','S1','S2','S3','A') and A2.OANO=@P_OANO and A2.ANO<=@P_ANO  
	   and A2.ANO>(Select coalesce(Max(ANO),0) from Acceptance Where AType='C' and EMethod='A' and Acceptance.OANO=@P_OANO and Acceptance.ANO<=@P_ANO and AStatus not in ('W','T'))
) A


Select @P_COMM=CASE WHEN @P_COMMPOLICYF=1 and @P_COMM=0 and @P_COMMN=0 Then @Premium_Commission ELSE @P_COMM END  
 
Select              
sum(Case When OnMinPremiumF=0 Then (case When Gross_1>Gross_2 then Gross_1 else Gross_2 end) else (case When Gross_1<Gross_2 and Gross_1<>0 then Gross_1 else Gross_2 end) end) as Premium,           
sum(Case When OnMinPremiumF=0 Then (case When Gross_1>Gross_2 then Comm_1 else Comm_2 end) else (case When Gross_1<Gross_2 and Gross_1<>0 then Comm_1 else Comm_2 end) end) as Commission,         
sum(Case When OnMinPremiumF=0 Then (case When Gross_1>Gross_2 then Disc_1 else Disc_2 end) else (case When Gross_1<Gross_2 and Gross_1<>0 then Disc_1 else Disc_2 end) end) as Discount,  
sum(Case When OnMinPremiumF=0 Then (case When Gross_1>Gross_2 then Fee_1 else Fee_2 end) else (case When Gross_1<Gross_2 and Gross_1<>0 then Fee_1 else Fee_2 end) end) as Fee              
From          
(select              
Cast(@P_OnMinPremiumF as integer) as OnMinPremiumF,              
coalesce(SUM((CASE WHEN @P_PPCT<>0 THEN @P_PPCT/100 ELSE (Case When @P_RateConF=1 and (RRateCon.Rate is not null or RateCon.Rate is not null) then 0 else 1 end) END * ICALC.GROSS*(PCALC.PGROSS*@P_PFactor)/PCALC.POGROSS*(Case When @P_OnNetPremiumF=1 Then (100-@Premium_Treaty_Discount)/100 else 1 end)-(ICALC.GROSS*@P_OPFEE/PCALC.POGROSS))*(Case When @P_COMMN=0 Then @P_COMM/100 else (Case When RCover.NetRateF=1 or @P_ONGROSSNET=2 OR (@P_ONGROSSNET=0 AND (100-@Premium_OutGo)/100*(100-@P_COMMN)/100<(100-@P_COMM)/100) Then (100-@Premium_OutGo)/100*(@P_COMMN)/100 else @P_COMM/100 end) end)),0) AS COMM_1,              
coalesce(SUM((Case When @P_RateConF=1 Then (Case When RRateCon.Rate is null then RateCon.Rate*(Case When RateCon.Loading<>0 then RateCon.Loading/100 else RCover.Loading end) else RRateCon.Rate/PCalc.RiskNum*(Case When RRateCon.Loading<>0 then RRateCon.Loading/100 else RCover.Loading end) end) Else coalesce(@P_NETRATEDet,@P_NETRATE/PCalc.RiskNum) end/100*(100-RCover.Discount)/100*ICALC.GROSS/PCALC.GROSS*ICALC.PRORATA *ICALC.TSI*(CASE WHEN RCOVER.PCALC='S' OR RCOVER.PCTLOSS=0 THEN 100 ELSE RCOVER.PCTLOSS END)/(CASE WHEN RCOVER.PCTLOSS=0 THEN 100 ELSE RCOVER.PCTLOSS END+RCOVER.PAddition)*ICALC.PCTADJ/100-(ICALC.GROSS*@P_OPFEE/PCALC.POGROSS))*(Case When @P_COMMN=0 Then @P_COMM/100 else (Case When RCover.NetRateF=1 or @P_ONGROSSNET=2 OR (@P_ONGROSSNET=0 AND (100-@Premium_OutGo)/100*(100-@P_COMMN)/100<(100-@P_COMM)/100) Then (100-@Premium_OutGo)/100*(@P_COMMN)/100 else @P_COMM/100 end) end)),0) AS COMM_2,              

coalesce(SUM((CASE WHEN @P_PPCT<>0 THEN @P_PPCT/100 ELSE (Case When @P_RateConF=1 and (RRateCon.Rate is not null or RateCon.Rate is not null) then 0 else 1 end) END * ICALC.GROSS*(PCALC.PGROSS*@P_PFactor)/PCALC.POGROSS*(Case When @P_OnNetPremiumF=1 Then (100-@Premium_Treaty_Discount)/100 else 1 end))*(Case When @P_COMMN=0 Then 1 else (Case When RCover.NetRateF=1 or @P_ONGROSSNET=2 OR (@P_ONGROSSNET=0 AND (100-@Premium_OutGo)/100*(100-@P_COMMN)/100<(100-@P_COMM)/100) Then 1 else 1 end) end)-(Case When @P_RITabarruF=1 Then 1 Else 0 end)*(ICALC.GROSS*@P_OPFEE/PCALC.POGROSS)),0) AS GROSS_1,            
coalesce(SUM((Case When @P_RateConF=1 Then (Case When RRateCon.Rate is null then RateCon.Rate*(Case When RateCon.Loading<>0 then RateCon.Loading/100 else RCover.Loading end) else RRateCon.Rate/PCalc.RiskNum*(Case When RRateCon.Loading<>0 then RRateCon.Loading/100 else RCover.Loading end) end) Else coalesce(@P_NETRATEDet,@P_NETRATE/PCalc.RiskNum) end/100*(100-RCover.Discount)/100*ICALC.GROSS/PCALC.GROSS*ICALC.PRORATA *ICALC.TSI*(CASE WHEN RCOVER.PCALC='S' OR RCOVER.PCTLOSS=0 THEN 100 ELSE RCOVER.PCTLOSS END)/(CASE WHEN RCOVER.PCTLOSS=0 THEN 100 ELSE RCOVER.PCTLOSS END+RCOVER.PAddition)*ICALC.PCTADJ/100)*(Case When @P_COMMN=0 Then 1 else (Case When RCover.NetRateF=1 or @P_ONGROSSNET=2 OR (@P_ONGROSSNET=0 AND (100-@Premium_OutGo)/100*(100-@P_COMMN)/100<(100-@P_COMM)/100) Then 1 else 1 end) end)-(Case When @P_RITabarruF=1 Then 1 Else 0 end)*(ICALC.GROSS*@P_OPFEE/PCALC.POGROSS)),0) AS GROSS_2,              
             
coalesce(SUM((CASE WHEN @P_PPCT<>0 THEN @P_PPCT/100 ELSE (Case When @P_RateConF=1 and (RRateCon.Rate is not null or RateCon.Rate is not null) then 0 else 1 end) END * ICALC.GROSS*(PCALC.PGROSS*@P_PFactor)/PCALC.POGROSS*(Case When @P_OnNetPremiumF=1 Then (100-@Premium_Treaty_Discount)/100 else 1 end)-(ICALC.GROSS*@P_OPFEE/PCALC.POGROSS))*(Case When @P_COMMN=0 Then 0 else (Case When RCover.NetRateF=1 or @P_ONGROSSNET=2 OR (@P_ONGROSSNET=0 AND (100-@Premium_OutGo)/100*(100-@P_COMMN)/100<(100-@P_COMM)/100) Then (@Premium_OutGo)/100 else 0 end) end)),0) AS DISC_1,              
coalesce(SUM((Case When @P_RateConF=1 Then (Case When RRateCon.Rate is null then RateCon.Rate*(Case When RateCon.Loading<>0 then RateCon.Loading/100 else RCover.Loading end) else RRateCon.Rate/PCalc.RiskNum*(Case When RRateCon.Loading<>0 then RRateCon.Loading/100 else RCover.Loading end) end) Else coalesce(@P_NETRATEDet,@P_NETRATE/PCalc.RiskNum) end/100*(100-RCover.Discount)/100*ICALC.GROSS/PCALC.GROSS*ICALC.PRORATA *ICALC.TSI*(CASE WHEN RCOVER.PCALC='S' OR RCOVER.PCTLOSS=0 THEN 100 ELSE RCOVER.PCTLOSS END)/(CASE WHEN RCOVER.PCTLOSS=0 THEN 100 ELSE RCOVER.PCTLOSS END+RCOVER.PAddition)*ICALC.PCTADJ/100-(ICALC.GROSS*@P_OPFEE/PCALC.POGROSS))*(Case When @P_COMMN=0 Then 0 else (Case When RCover.NetRateF=1 or @P_ONGROSSNET=2 OR (@P_ONGROSSNET=0 AND (100-@Premium_OutGo)/100*(100-@P_COMMN)/100<(100-@P_COMM)/100) Then (@Premium_OutGo)/100 else 0 end) end)),0) AS DISC_2,  

coalesce(SUM((CASE WHEN @P_PPCT<>0 THEN @P_PPCT/100 ELSE (Case When @P_RateConF=1 and (RRateCon.Rate is not null or RateCon.Rate is not null) then 0 else 1 end) END * ICALC.GROSS*(PCALC.PGROSS*@P_PFactor)/PCALC.POGROSS*(Case When @P_OnNetPremiumF=1 Then (100-@Premium_Treaty_Discount)/100 else 1 end))*(Case When @P_COMMN=0 Then 1 else (Case When RCover.NetRateF=1 or @P_ONGROSSNET=2 OR (@P_ONGROSSNET=0 AND (100-@Premium_OutGo)/100*(100-@P_COMMN)/100<(100-@P_COMM)/100) Then 1 else 1 end) end)*@P_FEE/100-(Case When @P_RITabarruF=0 Then 1 Else 0 end)*(ICALC.GROSS*@P_OPFEE/PCALC.POGROSS)),0) AS FEE_1,              
coalesce(SUM((Case When @P_RateConF=1 Then (Case When RRateCon.Rate is null then RateCon.Rate*(Case When RateCon.Loading<>0 then RateCon.Loading/100 else RCover.Loading end) else RRateCon.Rate/PCalc.RiskNum*(Case When RRateCon.Loading<>0 then RRateCon.Loading/100 else RCover.Loading end) end) Else coalesce(@P_NETRATEDet,@P_NETRATE/PCalc.RiskNum) end/100*(100-RCover.Discount)/100*ICALC.GROSS/PCALC.GROSS*ICALC.PRORATA *ICALC.TSI*(CASE WHEN RCOVER.PCALC='S' OR RCOVER.PCTLOSS=0 THEN 100 ELSE RCOVER.PCTLOSS END)/(CASE WHEN RCOVER.PCTLOSS=0 THEN 100 ELSE RCOVER.PCTLOSS END+RCOVER.PAddition)*ICALC.PCTADJ/100)*(Case When @P_COMMN=0 Then 1 else (Case When RCover.NetRateF=1 or @P_ONGROSSNET=2 OR (@P_ONGROSSNET=0 AND (100-@Premium_OutGo)/100*(100-@P_COMMN)/100<(100-@P_COMM)/100) Then 1 else 1 end) end)*@P_FEE/100-(Case When @P_RITabarruF=0 Then 1 Else 0 end)*(ICALC.GROSS*@P_OPFEE/PCALC.POGROSS)),0) AS FEE_2  
              
FROM ICALC   
INNER JOIN ACCEPTANCE SACCEPTANCE ON (SACCEPTANCE.ANO=ICALC.SANO)  
INNER JOIN RCOVER ON (RCOVER.ANO=ICALC.SANO AND RCOVER.CODE=ICALC.CODE AND (RCOVER.SDATE=ICALC.SDATE OR (@P_AType='A' AND (CASE WHEN RCOVER.SDATE<SACCEPTANCE.PDATE THEN SACCEPTANCE.PDATE ELSE RCOVER.SDATE END)=ICALC.SDATE)))  
LEFT JOIN RPARTDET ON (RPARTDET.RNO=@P_RNO AND RPARTDET.ID=@P_ID AND RPartDet.DocNo=@P_DocNo AND RPARTDET.TOR=ICALC.TOR)  
LEFT Join FN_RateCon(@P_ANO, @P_CODE,@P_TSI,@P_ASDate) RateCon On (RateCon.Code=ICalc.Code)  
LEFT Join FN_RRateCon(@P_ANO, @P_RID, @P_TSI) RRateCon On (1=1)              
INNER JOIN ICOVER ON (ICOVER.INO=ICALC.INO AND (ICOVER.ADJUSTABLE=@P_ADJUSTABLEF OR @P_AType='A'))  
INNER JOIN RCALC ON (RCALC.ANO=ICALC.ANO AND RCALC.CURRENCY=ICALC.CURRENCY AND RCALC.CODE=ICALC.CODE AND RCALC.TOR=ICALC.TOR AND RCALC.SDATE=ICALC.SDATE AND RCALC.EDATE=ICALC.EDATE AND RCALC.SANO=ICALC.SANO AND RCALC.EXTREATYF=0)  
INNER JOIN PCALC_ANNUM(@P_ANO) PCALC ON (PCALC.ANO=ICALC.ANO AND PCALC.CODE=ICALC.CODE AND PCALC.SDATE=ICALC.SDATE AND PCALC.EDATE=ICALC.EDATE AND PCALC.INO=ICALC.INO AND PCALC.CURRENCY=ICALC.CURRENCY)  
WHERE ICALC.ANO=@P_ANO AND ICALC.CURRENCY=@P_CCY AND ICALC.SDATE=@P_SDATE AND ICALC.EDATE=@P_EDATE AND ICALC.CODE=@P_CODE              
AND RPARTDET.TOR IS NULL AND PCALC.GROSS<>0  

Union All              

select              

Cast(@P_OnMinPremiumF as integer) as OnMinPremiumF,              

coalesce(SUM((CASE WHEN RPARTDET.PPCT<>0 THEN RPARTDET.PPCT/100 ELSE (Case When @P_RateConF=1 and (RRateCon.Rate is not null or RateCon.Rate is not null) then 0 else 1 end) END * ICALC.GROSS*(PCALC.PGROSS*@P_PFactor)/PCALC.POGROSS-(ICALC.GROSS*@P_OPFEE/PCALC.POGROSS))*(Case When @P_OnNetPremiumF=1 Then (100-@Premium_Treaty_Discount)/100 else 1 end)*(Case When RPARTDET.COMMN=0 Then RPARTDET.COMM/100 else (Case When RCover.NetRateF=1 or @P_ONGROSSNET=2 OR (@P_ONGROSSNET=0 AND (100-@Premium_OutGo)/100*(100-RPARTDET.CommN)/100<(100-RPARTDET.COMM)/100) Then (100-@Premium_OutGo)/100*(RPARTDET.CommN)/100 else RPARTDET.COMM/100 end) end)),0) AS COMM_1,              
coalesce(SUM((Case When @P_RateConF=1 Then (Case When RRateCon.Rate is null then RateCon.Rate*(Case When RateCon.Loading<>0 then RateCon.Loading/100 else RCover.Loading end) else RRateCon.Rate/PCalc.RiskNum*(Case When RRateCon.Loading<>0 then RRateCon.Loading/100 else RCover.Loading end) end) Else coalesce(@P_NETRATEDet,RPARTDET.NETRate) end/100*(100-RCover.Discount)/100*ICALC.GROSS/PCALC.GROSS*ICALC.PRORATA *ICALC.TSI*(CASE WHEN RCOVER.PCALC='S' OR RCOVER.PCTLOSS=0 THEN 100 ELSE RCOVER.PCTLOSS END)/(CASE WHEN RCOVER.PCTLOSS=0 THEN 100 ELSE RCOVER.PCTLOSS END+RCOVER.PAddition)*ICALC.PCTADJ/100-(ICALC.GROSS*@P_OPFEE/PCALC.POGROSS))*(Case When RPARTDET.COMMN=0 Then RPARTDET.COMM/100 else (Case When RCover.NetRateF=1 or @P_ONGROSSNET=2 OR (@P_ONGROSSNET=0 AND (100-@Premium_OutGo)/100*(100-RPARTDET.CommN)/100<(100-RPARTDET.COMM)/100) Then (100-@Premium_OutGo)/100*(RPARTDET.CommN)/100 else RPARTDET.COMM/100 end) end)),0) AS COMM_2,                  
              
coalesce(SUM((CASE WHEN RPARTDET.PPCT<>0 THEN RPARTDET.PPCT/100 ELSE (Case When @P_RateConF=1 and (RRateCon.Rate is not null or RateCon.Rate is not null) then 0 else 1 end) END * ICALC.GROSS*(PCALC.PGROSS*@P_PFactor)/PCALC.POGROSS)*(Case When @P_OnNetPremiumF=1 Then (100-@Premium_Treaty_Discount)/100 else 1 end)*(Case When RPARTDET.COMMN=0 Then 1 else (Case When RCover.NetRateF=1 or @P_ONGROSSNET=2 OR (@P_ONGROSSNET=0 AND (100-@Premium_OutGo)/100*(100-RPARTDET.CommN)/100<(100-RPARTDET.COMM)/100) Then 1 else 1 end) end)-(Case When @P_RITabarruF=1 Then 1 Else 0 end)*(ICALC.GROSS*@P_OPFEE/PCALC.POGROSS)),0) AS GROSS_1,              
coalesce(SUM((Case When @P_RateConF=1 Then (Case When RRateCon.Rate is null then RateCon.Rate*(Case When RateCon.Loading<>0 then RateCon.Loading/100 else RCover.Loading end) else RRateCon.Rate/PCalc.RiskNum*(Case When RRateCon.Loading<>0 then RRateCon.Loading/100 else RCover.Loading end) end) Else coalesce(@P_NETRATEDet,RPARTDET.NETRate) end/100*(100-RCover.Discount)/100*ICALC.GROSS/PCALC.GROSS*ICALC.PRORATA *ICALC.TSI*(CASE WHEN RCOVER.PCALC='S' OR RCOVER.PCTLOSS=0 THEN 100 ELSE RCOVER.PCTLOSS END)/(CASE WHEN RCOVER.PCTLOSS=0 THEN 100 ELSE RCOVER.PCTLOSS END+RCOVER.PAddition)*ICALC.PCTADJ/100)*(Case When RPARTDET.COMMN=0 Then 1 else (Case When RCover.NetRateF=1 or @P_ONGROSSNET=2 OR (@P_ONGROSSNET=0 AND (100-@Premium_OutGo)/100*(100-RPARTDET.CommN)/100<(100-RPARTDET.COMM)/100) Then 1 else 1 end) end)-(Case When @P_RITabarruF=1 Then 1 Else 0 end)*(ICALC.GROSS*@P_OPFEE/PCALC.POGROSS)),0) AS GROSS_2,              

coalesce(SUM((CASE WHEN RPARTDET.PPCT<>0 THEN RPARTDET.PPCT/100 ELSE (Case When @P_RateConF=1 and (RRateCon.Rate is not null or RateCon.Rate is not null) then 0 else 1 end) END * ICALC.GROSS*(PCALC.PGROSS*@P_PFactor)/PCALC.POGROSS-(ICALC.GROSS*@P_OPFEE/PCALC.POGROSS))*(Case When @P_OnNetPremiumF=1 Then (100-@Premium_Treaty_Discount)/100 else 1 end)*(Case When RPARTDET.COMMN=0 Then 0 else (Case When RCover.NetRateF=1 or @P_ONGROSSNET=2 OR (@P_ONGROSSNET=0 AND (100-@Premium_OutGo)/100*(100-RPARTDET.CommN)/100<(100-RPARTDET.COMM)/100) Then (@Premium_OutGo)/100 else 0 end) end)),0) AS DISC_1,              
coalesce(SUM((Case When @P_RateConF=1 Then (Case When RRateCon.Rate is null then RateCon.Rate*(Case When RateCon.Loading<>0 then RateCon.Loading/100 else RCover.Loading end) else RRateCon.Rate/PCalc.RiskNum*(Case When RRateCon.Loading<>0 then RRateCon.Loading/100 else RCover.Loading end) end) Else coalesce(@P_NETRATEDet,RPARTDET.NETRate) end/100*(100-RCover.Discount)/100*ICALC.GROSS/PCALC.GROSS*ICALC.PRORATA *ICALC.TSI*(CASE WHEN RCOVER.PCALC='S' OR RCOVER.PCTLOSS=0 THEN 100 ELSE RCOVER.PCTLOSS END)/(CASE WHEN RCOVER.PCTLOSS=0 THEN 100 ELSE RCOVER.PCTLOSS END+RCOVER.PAddition)*ICALC.PCTADJ/100-(ICALC.GROSS*@P_OPFEE/PCALC.POGROSS))*(Case When RPARTDET.COMMN=0 Then 0 else (Case When RCover.NetRateF=1 or @P_ONGROSSNET=2 OR (@P_ONGROSSNET=0 AND (100-@Premium_OutGo)/100*(100-RPARTDET.CommN)/100<(100-RPARTDET.COMM)/100) Then (@Premium_OutGo)/100 else 0 end) end)),0) AS DISC_2,                  

coalesce(SUM((CASE WHEN RPARTDET.PPCT<>0 THEN RPARTDET.PPCT/100 ELSE (Case When @P_RateConF=1 and (RRateCon.Rate is not null or RateCon.Rate is not null) then 0 else 1 end) END * ICALC.GROSS*(PCALC.PGROSS*@P_PFactor)/PCALC.POGROSS)*(Case When @P_OnNetPremiumF=1 Then (100-@Premium_Treaty_Discount)/100 else 1 end)*(Case When RPARTDET.COMMN=0 Then 1 else (Case When RCover.NetRateF=1 or @P_ONGROSSNET=2 OR (@P_ONGROSSNET=0 AND (100-@Premium_OutGo)/100*(100-RPARTDET.CommN)/100<(100-RPARTDET.COMM)/100) Then 1 else 1 end) end)*@P_FEE/100-(Case When @P_RITabarruF=0 Then 1 Else 0 end)*(ICALC.GROSS*@P_OPFEE/PCALC.POGROSS)),0) AS FEE_1,              
coalesce(SUM((Case When @P_RateConF=1 Then (Case When RRateCon.Rate is null then RateCon.Rate*(Case When RateCon.Loading<>0 then RateCon.Loading/100 else RCover.Loading end) else RRateCon.Rate/PCalc.RiskNum*(Case When RRateCon.Loading<>0 then RRateCon.Loading/100 else RCover.Loading end) end) Else coalesce(@P_NETRATEDet,RPARTDET.NETRate) end/100*(100-RCover.Discount)/100*ICALC.GROSS/PCALC.GROSS*ICALC.PRORATA *ICALC.TSI*(CASE WHEN RCOVER.PCALC='S' OR RCOVER.PCTLOSS=0 THEN 100 ELSE RCOVER.PCTLOSS END)/(CASE WHEN RCOVER.PCTLOSS=0 THEN 100 ELSE RCOVER.PCTLOSS END+RCOVER.PAddition)*ICALC.PCTADJ/100)*(Case When RPARTDET.COMMN=0 Then 1 else (Case When RCover.NetRateF=1 or @P_ONGROSSNET=2 OR (@P_ONGROSSNET=0 AND (100-@Premium_OutGo)/100*(100-RPARTDET.CommN)/100<(100-RPARTDET.COMM)/100) Then 1 else 1 end) end)*@P_FEE/100-(Case When @P_RITabarruF=0 Then 1 Else 0 end)*(ICALC.GROSS*@P_OPFEE/PCALC.POGROSS)),0) AS FEE_2  

FROM ICALC   
INNER JOIN ACCEPTANCE SACCEPTANCE ON (SACCEPTANCE.ANO=ICALC.SANO)  
INNER JOIN RCOVER ON (RCOVER.ANO=ICALC.SANO AND RCOVER.CODE=ICALC.CODE AND (RCOVER.SDATE=ICALC.SDATE OR (@P_AType='A' AND (CASE WHEN RCOVER.SDATE<SACCEPTANCE.PDATE THEN SACCEPTANCE.PDATE ELSE RCOVER.SDATE END)=ICALC.SDATE)))  
INNER JOIN RPARTDET ON (RPARTDET.RNO=@P_RNO AND RPARTDET.ID=@P_ID AND RPARTDET.DocNo=@P_DocNo AND RPARTDET.TOR=ICALC.TOR AND (RPARTDET.NOFYEARS=0 OR RPARTDET.NOFYEARS=@P_NOFYEARS) and RPARTDET.EXCLUDEF=0)  
LEFT Join FN_RateCon(@P_ANO, @P_CODE,@P_TSI,@P_ASDate) RateCon On (RateCon.Code=ICalc.Code)  
LEFT Join FN_RRateCon(@P_ANO, @P_RID, @P_TSI) RRateCon On (1=1)              
INNER JOIN ICOVER ON (ICOVER.INO=ICALC.INO AND (ICOVER.ADJUSTABLE=@P_ADJUSTABLEF OR @P_AType='A'))  
INNER JOIN RCALC ON (RCALC.ANO=ICALC.ANO AND RCALC.CURRENCY=ICALC.CURRENCY AND RCALC.CODE=ICALC.CODE AND RCALC.TOR=ICALC.TOR AND RCALC.SDATE=ICALC.SDATE AND RCALC.EDATE=ICALC.EDATE AND RCALC.SANO=ICALC.SANO AND RCALC.EXTREATYF=0)  
INNER JOIN PCALC_ANNUM(@P_ANO) PCALC ON (PCALC.ANO=ICALC.ANO AND PCALC.CODE=ICALC.CODE AND PCALC.SDATE=ICALC.SDATE AND PCALC.EDATE=ICALC.EDATE AND PCALC.INO=ICALC.INO AND PCALC.CURRENCY=ICALC.CURRENCY)  
WHERE ICALC.ANO=@P_ANO AND ICALC.CURRENCY=@P_CCY AND ICALC.SDATE=@P_SDATE AND ICALC.EDATE=@P_EDATE AND ICALC.CODE=@P_CODE              
AND PCALC.GROSS<>0  

) R        


GO

DROP PROCEDURE View05L1 
GO
CREATE PROCEDURE View05L1 (@p_ANO as integer)    
AS    

Declare @PremiumCalc Table(Currency varchar(10), Rate float, TSI Float, OurShare Float, Gross Float, CRate Float, Premium FLoat, Discount FLoat, Commission FLoat, VAT Float, TAX FLoat, FeeDuty Float)
Declare @ANO as int
Declare @LANO as int
Declare @RegNo as varchar(50)
Declare @OpenFlag as Bit

Select @ANO=Acceptance.ANO, @LANO=Acceptance.LANO, @RegNo=Acceptance.RegNo, @OpenFlag=Cover.OpenFlag
from Acceptance 
Inner Join Cover on (Cover.CNO=Acceptance.CNO)
Where Acceptance.ANO=@P_ANO

if @ANO<>@LANO or @OpenFlag=1
Begin
	insert into @PremiumCalc

	SELECT P2.Currency, max(coalesce(P1.Rate,0)) as Rate, max(coalesce(P1.TSI,0)) as TSI, max(coalesce(P1.OurShare,0)) as OurShare, Max(coalesce(P1.Gross,0)) as Gross, max(coalesce(P1.CRate,0)) as CRate, sum(P2.Premium) as Premium, sum(P2.Discount) as Discount, sum(P2.Commission) as Commission, sum(P2.Vat) as Vat, sum(P2.Tax) as Tax, sum(P2.FeeDuty) as FeeDuty   
	FROM PREMIUM_CALCULATION(@P_ANO) P2 
	Left Join PCalc P1 On (P2.ANO=P1.ANO and P2.Currency=P1.Currency)    
	Group By P2.Currency    
                     
	Union All          

	Select AccFD.Currency, 0 as Rate, 0 as TSI, 0 as OurShare, 0 as Gross, 0 as CRate, 0 as Premium, 0 as Discount, 0 as Commission, 0 as Vat, 0 as Tax, 
	Case 
	When FDTab.FDType<>'O' Then (ACCFD.Amount)
	Else -(ACCFD.Amount) End as FeeDuty
	from AccFD
	Inner Join FDTAB on (FDTab.FDID=AccFD.FDID)
	Where AccFD.ANO=@P_ANO and AccFD.Amount<>0

	Union All

	Select AccFD.Currency, 0 as Rate, 0 as TSI, 0 as OurShare, 0 as Gross, 0 as CRate, 0 as Premium, 0 as Discount, 0 as Commission, 0 as Vat, 0 as Tax, 
	sum(
	Case 
	When FDTab.FDType<>'O' Then 
		  (D1.Gross*(100-D1.Discount)/100*D1.Prorata*P.Gross/P.OGross*P.OurShare/P.TSI*AccFD.AmountPCT/100*case When AccFD.AMOUNTPCTBASED=3 Then (1-dbo.Premium_Commission(D1.ANO, D1.Code,0,0)/100) else 1 end)
	Else
		  -(D1.Gross*D1.Prorata*P.Gross/P.OGross*P.OurShare/P.TSI*(100-R.MSHARE)/100*AccFD.AmountPCT/100*case When AccFD.AMOUNTPCTBASED=3 Then (1-dbo.Premium_Commission(D1.ANO, D1.Code,0,0)/100) else 1 end)
	End 
	) as FeeDuty
	from Display_Calculation(@P_ANO) D1
	Inner join RarrHeader R on (R.ANO=D1.ANO)
	Inner join PCalc P on (P.ANO=D1.ANO and P.Currency=D1.Currency)
	Inner Join AccFD on (AccFD.ANO=@P_ANO and AccFD.Currency=D1.Currency)
	Inner Join FDTAB ON (FDTab.FDID=AccFD.FDID)
	Where  AccFD.Amount=0 and AccFd.AMOUNTPCTBASED in (0,3)
	Group by ACCFD.Currency

	Union All

	Select AccFD.Currency, 0 as Rate, 0 as TSI, 0 as OurShare, 0 as Gross, 0 as CRate, 0 as Premium, 0 as Discount, 0 as Commission, 0 as Vat, 0 as Tax, 
	sum(
	Case 
	When FDTab.FDType<>'O' Then 
		(coalesce(P.OurShare,0)-coalesce(PP.OurShare,0))*AccFD.AmountPCT/100
	Else
		-coalesce(P.OurShare*(100-R.MSHARE)/100,0)-coalesce(PP.OurShare*(100-PR.MSHARE)/100,0)*AccFD.AmountPCT/100
	End
	) as FeeDuty
	from 
	AccFD
	Inner Join FDTab on (FDTAB.FDID=AccFD.FDID)
	Inner Join Acceptance A on (A.ANO=AccFD.ANO)
	Left Join Acceptance PA on (PA.ANO=A.PANO)
	Left Join PCalc P on (P.ANO=A.ANO and P.Currency=AccFD.Currency and A.AType Not in ('A','C'))
	Left Join RArrHeader R on (R.ANO=A.ANO and A.AType Not in ('A','C'))
	Left Join PCalc PP on (PP.ANO=A.PANO and PP.Currency=P.Currency and PA.AType Not in ('A','C'))
	Left Join RArrHeader PR on (PR.ANO=A.PANO and PA.AType Not in ('A','C'))	
	Where AccFD.ANO=@P_ANO
	and AccFD.Amount=0 and AccFd.AMOUNTPCTBASED Not in (0,3)
	Group by ACCFD.Currency

End
else
Begin

	insert into @PremiumCalc
	Select P.*
	from Acceptance A
	Cross Apply
	(
		SELECT P2.Currency, max(coalesce(P1.Rate,0)) as Rate, max(coalesce(P1.TSI,0)) as TSI, max(coalesce(P1.OurShare,0)) as OurShare, Max(coalesce(P1.Gross,0)) as Gross, max(coalesce(P1.CRate,0)) as CRate, sum(P2.Premium) as Premium, sum(P2.Discount) as Discount, sum(P2.Commission) as Commission, sum(P2.Vat) as Vat, sum(P2.Tax) as Tax, sum(P2.FeeDuty) as FeeDuty   
		FROM PREMIUM_CALCULATION(A.ANO) P2 
		Left Join PCalc P1 On (P2.ANO=P1.ANO and P2.Currency=P1.Currency)    
		Group By P2.Currency    
                     
		Union All          

		Select AccFD.Currency, 0 as Rate, 0 as TSI, 0 as OurShare, 0 as Gross, 0 as CRate, 0 as Premium, 0 as Discount, 0 as Commission, 0 as Vat, 0 as Tax, 
		Case 
		When FDTab.FDType<>'O' Then (ACCFD.Amount)
		Else -(ACCFD.Amount) End as FeeDuty
		from AccFD
		Inner Join FDTAB on (FDTab.FDID=AccFD.FDID)
		Where AccFD.ANO=A.ANO and AccFD.Amount<>0

		Union All

		Select AccFD.Currency, 0 as Rate, 0 as TSI, 0 as OurShare, 0 as Gross, 0 as CRate, 0 as Premium, 0 as Discount, 0 as Commission, 0 as Vat, 0 as Tax, 
		sum(
		Case 
		When FDTab.FDType<>'O' Then 
			  (D1.Gross*(100-D1.Discount)/100*D1.Prorata*P.Gross/P.OGross*P.OurShare/P.TSI*AccFD.AmountPCT/100*case When AccFD.AMOUNTPCTBASED=3 Then (1-dbo.Premium_Commission(D1.ANO, D1.Code,0,0)/100) else 1 end)
		Else
			  -(D1.Gross*D1.Prorata*P.Gross/P.OGross*P.OurShare/P.TSI*(100-R.MSHARE)/100*AccFD.AmountPCT/100*case When AccFD.AMOUNTPCTBASED=3 Then (1-dbo.Premium_Commission(D1.ANO, D1.Code,0,0)/100) else 1 end)
		End 
		) as FeeDuty
		from Display_Calculation(A.ANO) D1
		Inner join RarrHeader R on (R.ANO=D1.ANO)
		Inner join PCalc P on (P.ANO=D1.ANO and P.Currency=D1.Currency)
		Inner Join AccFD on (AccFD.ANO=A.ANO and AccFD.Currency=D1.Currency)
		Inner Join FDTAB ON (FDTab.FDID=AccFD.FDID)
		Where  AccFD.Amount=0 and AccFd.AMOUNTPCTBASED in (0,3)
		Group by ACCFD.Currency

		Union All

		Select AccFD.Currency, 0 as Rate, 0 as TSI, 0 as OurShare, 0 as Gross, 0 as CRate, 0 as Premium, 0 as Discount, 0 as Commission, 0 as Vat, 0 as Tax, 
		sum(
		Case 
		When FDTab.FDType<>'O' Then 
			(coalesce(P.OurShare,0)-coalesce(PP.OurShare,0))*AccFD.AmountPCT/100
		Else
			-coalesce(P.OurShare*(100-R.MSHARE)/100,0)-coalesce(PP.OurShare*(100-PR.MSHARE)/100,0)*AccFD.AmountPCT/100
		End
		) as FeeDuty
		from 
		AccFD
		Inner Join FDTab on (FDTAB.FDID=AccFD.FDID)
		Left Join Acceptance PA on (PA.ANO=A.PANO)
		Left Join PCalc P on (P.ANO=A.ANO and P.Currency=AccFD.Currency and A.AType Not in ('A','C'))
		Left Join RArrHeader R on (R.ANO=A.ANO and A.AType Not in ('A','C'))
		Left Join PCalc PP on (PP.ANO=A.PANO and PP.Currency=P.Currency and PA.AType Not in ('A','C'))
		Left Join RArrHeader PR on (PR.ANO=A.PANO and PA.AType Not in ('A','C'))	
		Where AccFD.ANO=A.ANO
		and AccFD.Amount=0 and AccFd.AMOUNTPCTBASED Not in (0,3)
		Group by ACCFD.Currency
	) P
	Where A.LANO=@ANO and A.RegNo=@RegNo 
end


Select @p_ANO ANO, Currency, Max(Rate) as Rate, sum(TSI) as TSI, sum(OurShare) as OurShare, sum(Gross) as Gross, Case When Sum(TSI)<>0 then Sum(Gross)/sum(TSI)*100 else 0 end as CRate, sum(Premium) as Premium, sum(Discount) as Discount, sum(Commission) as Commission, sum(Vat) as Vat, sum(Tax) as Tax, sum(FeeDuty) as FeeDuty    
from @PremiumCalc P
Group By Currency    


GO


DROP Procedure Treaty_Premium_Commission
GO
CREATE Procedure Treaty_Premium_Commission(@P_ANO integer,@P_Code varchar(10),@P_CCY varchar(10), @P_SDate smalldatetime, @P_EDate smalldatetime,@P_RID varchar(255),@P_AdjustableF Bit,@P_TSI Float=0)    
as    
Declare @Premium_Treaty_Discount as Float          
Declare @Premium_Discount as Float          
Declare @Premium_Commission as Float          
Declare @Premium_Commission_Inward as float
Declare @Premium_Fee as Float          
Declare @Premium_outGo as Float          
Declare @P_TOC as varchar(10)  
Declare @P_AType as varchar(1)  
Declare @P_ONGROSSNet as int  
Declare @P_RateConF as Bit   
Declare @P_NETRATEDet as Float  
Declare @P_NOFYEARS as Int  
Declare @P_COMM as Float  
Declare @P_COMMN as Float  
Declare @P_RNO as int  
Declare @P_RType as varchar(10)  
Declare @P_OPFEE as Float  
Declare @P_OPFEEPCT as Float  
Declare @P_OANO as int   
Declare @P_PFactor as Float
Declare @P_ASDate as smalldatetime
Declare @P_Period as Int
Declare @P_Tabarru as Float
Declare @P_RITabarruF as bit
Declare @P_UjrohCedant as Float
Declare @P_UjrohReins as Float
Declare @P_OPFEEF as bit

Select   
@P_Period=cast(datediff(Month,@P_ASDate, @P_SDate) as integer) / 12 + 1,   
@P_ASDate=A.SDate,  
@P_NOFYEARS=datediff(year,A.sdate, A.edate),   
@P_TOC=A.TOC,   
@P_AType=A.AType,   
@P_ONGROSSNET=R.ONGROSSNET,   
@P_RateConF=R3.RateConF,   
@P_NETRATEDet=R4.NETRATE,  
@P_COMM=R3.COMM,
@P_COMMN=R3.COMMN,
@P_RNO=R1.RNO,  
@P_RType=R1.RType,  
@P_OANO=A.OANO,  

@P_PFactor=Case When C.ISType='R' Then (100-I.UJrohCedant)/100*(100+I.UjrohReins)/100 else 1 end,
@Premium_Commission_Inward=coalesce(I2.Fee+I2.HF,coalesce(I.Fee+I.HF,0))+coalesce(I.OC,0),
@P_Tabarru=(100-A.Ujroh),
@P_UjrohCedant=R1.UJROHCEDANT,
@P_UjrohReins=R1.UJROHREINS,
@P_OPFEEF=R3.OPFEEF
from Acceptance A
Inner Join RarrHeader R on (R.ANO=A.ANO)
Inner Join Cover C on (C.CNO=A.CNO)
Left Join ISource I on (I.CNO=C.CNO) 
Left Join ISourceDet I2 on (I2.CNO=I.CNO and I2.Code=@P_Code)
Inner Join Reinsurance R1 on (R1.RID=@P_RID)
Inner Join ReClass R3 on (R3.RNO=R1.RNO and R3.TOC=A.TOC)
Left Join ReClassDet R4 ON (R4.RNO=R3.RNO AND R4.TOC=R3.TOC AND R4.CODE=@P_CODE)  
Where A.ANO=@P_ANO


Select @Premium_Treaty_Discount=dbo.Premium_Treaty_Discount(@P_ANO, @P_Code,@P_Period)          
Select @Premium_Discount=dbo.premium_discount(@P_ANO, @P_Code, @P_Period)  
Select @Premium_Commission=dbo.Premium_Commission(@P_ANO, @P_Code, @P_Period,0)+dbo.Premium_MaxOutGo_Vat(@P_ANO, @P_Code, @P_Period,0)  
Select @Premium_Fee=dbo.Premium_Fee(@P_ANO, @P_Period)  
Select @Premium_outGo=@Premium_Discount+@Premium_Commission+@Premium_Commission_Inward+@Premium_Fee

SELECT @P_OPFEE=Case When @P_OPFEEF=1 THen COALESCE(SUM(FEE),0) Else 0 End, @P_RITabarruF=coalesce(cast(Max(cast(RITabarruF as Int)) as Bit),0)
FROM
(
       SELECT
       A2.ANO,
       Case 
	   When A1.Amount<>0 Then
             A1.Amount*100/coalesce(R.PCTSHARE-R.MSHARE,100)*Case When A1.RITabarruF=1 Then cast(100 as Float)/@P_Tabarru Else 1 end
	   When A1.AMOUNTPCTBASED=0 then
             (
                    Select 
                    sum(D1.Gross*P.Gross/P.OGross)
                    from Display_Calculation(A2.ANO) D1
					Inner Join Acceptance A on (A.ANO=D1.ANO)
					Inner Join RArrHeader R on (R.ANO=D1.ANO)
					Inner Join PCalc P on (P.ANO=D1.ANO and P.Currency=D1.Currency)
					Where D1.Currency=@P_CCY
             )*A1.AmountPCT/100*Case When A1.RITabarruF=1 Then cast(100 as Float)/@P_Tabarru Else 1 end
       Else
             (
                    Select 
                    sum(D1.Gross*P.Gross/P.OGross*(1-dbo.Premium_Commission(D1.ANO, D1.Code,0,0)/100))
                    from Display_Calculation(A2.ANO) D1
					Inner Join Acceptance A on (A.ANO=D1.ANO)
					Inner Join RArrHeader R on (R.ANO=D1.ANO)
					Inner Join PCalc P on (P.ANO=D1.ANO and P.Currency=D1.Currency)
					Where D1.Currency=@P_CCY
             )*A1.AmountPCT/100*Case When A1.RITabarruF=1 Then cast(100 as Float)/@P_Tabarru Else 1 end
       End    as FEE,
	   A1.RITabarruF
       from 
	   Acceptance A2
       INNER JOIN AccFD A1 on (A1.ANO=A2.ANO and A1.Currency=@P_CCY and (A1.ContributionF=1 or A1.CessionF=1) and A1.AmountPCTBased in (0,3) And (A1.PolicyYear=0 or A1.PolicyYear=@P_Period))
       INNER JOIN FDTAB on (FDTAB.FDID=A1.FDID and Left(FDTAB.FDType,1)='O')
       INNER Join PCalc on (PCalc.ANO=A2.ANO and PCalc.Currency=A1.Currency)
       INNER JOIN RARRHEADER R ON (R.ANO=A2.ANO)
	   Where @P_RType in ('Q','S1','S2','S3','A') and A2.OANO=@P_OANO and A2.ANO<=@P_ANO  
	   and A2.ANO>(Select coalesce(Max(ANO),0) from Acceptance Where AType='C' and EMethod='A' and Acceptance.OANO=@P_OANO and Acceptance.ANO<=@P_ANO and AStatus not in ('W','T'))


	   Union All

	   --Op Fee from Master Policy
       SELECT
       A2.ANO,
       Case 
	   When A1.Amount<>0 Then
			--Not Yet for Master Policy
			0
	   When A1.AMOUNTPCTBASED=0 Then
             (
                    Select 
                    sum(D1.Gross*P.Gross/P.OGross)
                    from Display_Calculation(A2.ANO) D1
					Inner Join Acceptance A on (A.ANO=D1.ANO)
					Inner Join RARRHEADER R on (R.ANO=D1.ANO)
					Inner Join PCalc P on (P.ANO=D1.ANO and P.Currency=D1.Currency)
                    Where D1.Currency=@P_CCY
             )*A1.AmountPCT/100*Case When A1.RITabarruF=1 Then cast(100 as Float)/@P_Tabarru Else 1 end
       Else
             (
                    Select 
                    sum(D1.Gross*P.Gross/P.OGross*(1-dbo.Premium_Commission(D1.ANO, D1.Code,0,0)/100))
                    from Display_Calculation(A2.ANO) D1
					Inner Join Acceptance A on (A.ANO=D1.ANO)
					Inner Join RARRHEADER R on (R.ANO=D1.ANO)
					Inner Join PCalc P on (P.ANO=D1.ANO and P.Currency=D1.Currency)
                    Where D1.Currency=@P_CCY
             )*A1.AmountPCT/100*Case When A1.RITabarruF=1 Then cast(100 as Float)/@P_Tabarru Else 1 end
       End    as FEE,
	   A1.RITabarruF
       from 
       Acceptance A2
	   INNER JOIN Acceptance MA on (MA.RegNo=A2.RegNo and MA.ANO=MA.LANO)
	   INNER JOIN COVER C on (C.CNO=MA.CNO and C.OPENFLAG=0)
       INNER JOIN AccFD A1 on (A1.ANO=MA.ANO and A1.Currency=@P_CCY and (A1.ContributionF=1 or A1.CessionF=1) and A1.AmountPCTBased in (0,3) And (A1.PolicyYear=0 or A1.PolicyYear=@P_Period))
       INNER JOIN FDTAB on (FDTAB.FDID=A1.FDID and left(FDTAB.FDType,1)='O')
       INNER Join PCalc on (PCalc.ANO=A2.ANO and PCalc.Currency=A1.Currency)
       INNER JOIN RARRHEADER R ON (R.ANO=A2.ANO)
       Where @P_RType in ('Q','S1','S2','S3','A') and A2.OANO=@P_OANO and A2.ANO<=@P_ANO  
	   and A2.ANO>(Select coalesce(Max(ANO),0) from Acceptance Where AType='C' and EMethod='A' and Acceptance.OANO=@P_OANO and Acceptance.ANO<=@P_ANO and AStatus not in ('W','T'))

) A


--Select @P_COMM=CASE WHEN @P_COMMPOLICYF=1 and @P_COMM=0 and @P_COMMN=0 Then @Premium_Commission ELSE @P_COMM END  
 
Select              
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
cast(Max(Cast(RPart.OnMinPremiumF as integer)) as Bit) as OnMinPremiumF,              

coalesce(SUM((CASE WHEN RPart.PPCT<>0 THEN RPart.PPCT/100 ELSE (Case When @P_RateConF=1 and (RRateCon.Rate is not null or RateCon.Rate is not null) then 0 else 1 end) END * ICALC.GROSS*(PCALC.PGROSS*@P_PFactor)/PCALC.POGROSS*(Case When RPart.OnNetPremiumF=1 Then (100-@Premium_Treaty_Discount)/100 else 1 end)-(ICALC.GROSS*@P_OPFEE/PCALC.POGROSS))*(Case When (CASE WHEN @P_COMMN<>0 Then @P_COMMN ELSE RPART.COMMN END)=0 Then (CASE WHEN @P_COMM<>0 Then @P_COMM ELSE RPART.COMM END)/100 else (Case When RCover.NetRateF=1 or @P_ONGROSSNET=2 OR (@P_ONGROSSNET=0 AND (100-(@Premium_outGo-(Case When RPart.OnNetPremiumF=1 Then @Premium_Treaty_Discount else 0 end)))/100*(100-(CASE WHEN @P_COMMN<>0 Then @P_COMMN ELSE RPART.COMMN END))/100<(100-(CASE WHEN @P_COMM<>0 Then @P_COMM ELSE RPART.COMM END))/100) Then (100-(@Premium_outGo-(Case When RPart.OnNetPremiumF=1 Then @Premium_Treaty_Discount else 0 end)))/100*((CASE WHEN @P_COMMN<>0 Then @P_COMMN ELSE RPART.COMMN END))/100 else (CASE WHEN @P_COMM<>0 Then @P_COMM ELSE RPART.COMM END)/100 end) end)*RPart.share/100*PCalc.Rate),0) AS COMM_1,              
coalesce(SUM((Case When @P_RateConF=1 Then (Case When RRateCon.Rate is null then RateCon.Rate*(Case When RateCon.Loading<>0 then RateCon.Loading/100 else RCover.Loading end) else RRateCon.Rate/PCalc.RiskNum*(Case When RRateCon.Loading<>0 then RRateCon.Loading/100 else RCover.Loading end) end) Else coalesce(@P_NETRATEDet,RPart.NetRate/PCalc.RiskNum) end/100*(100-RCover.Discount)/100*ICALC.GROSS/PCALC.GROSS*ICALC.PRORATA *ICALC.TSI*(CASE WHEN RCOVER.PCALC='S' OR RCOVER.PCTLOSS=0 THEN 100 ELSE RCOVER.PCTLOSS END)/(CASE WHEN RCOVER.PCTLOSS=0 THEN 100 ELSE RCOVER.PCTLOSS END+RCOVER.PAddition)*ICALC.PCTADJ/100-(ICALC.GROSS*@P_OPFEE/PCALC.POGROSS))*(Case When (CASE WHEN @P_COMMN<>0 Then @P_COMMN ELSE RPART.COMMN END)=0 Then (CASE WHEN @P_COMM<>0 Then @P_COMM ELSE RPART.COMM END)/100 else (Case When RCover.NetRateF=1 or @P_ONGROSSNET=2 OR (@P_ONGROSSNET=0 AND (100-(@Premium_outGo-(Case When RPart.OnNetPremiumF=1 Then @Premium_Treaty_Discount else 0 end)))/100*(100-(CASE WHEN @P_COMMN<>0 Then @P_COMMN ELSE RPART.COMMN END))/100<(100-(CASE WHEN @P_COMM<>0 Then @P_COMM ELSE RPART.COMM END))/100) Then (100-(@Premium_outGo-(Case When RPart.OnNetPremiumF=1 Then @Premium_Treaty_Discount else 0 end)))/100*((CASE WHEN @P_COMMN<>0 Then @P_COMMN ELSE RPART.COMMN END))/100 else (CASE WHEN @P_COMM<>0 Then @P_COMM ELSE RPART.COMM END)/100 end) end)*RPart.share/100*PCalc.Rate),0) AS COMM_2,              

coalesce(SUM((CASE WHEN RPart.PPCT<>0 THEN RPart.PPCT/100 ELSE (Case When @P_RateConF=1 and (RRateCon.Rate is not null or RateCon.Rate is not null) then 0 else 1 end) END * ICALC.GROSS*(PCALC.PGROSS*@P_PFactor)/PCALC.POGROSS*(Case When RPart.OnNetPremiumF=1 Then (100-@Premium_Treaty_Discount)/100 else 1 end))*(Case When (CASE WHEN @P_COMMN<>0 Then @P_COMMN ELSE RPART.COMMN END)=0 Then 1 else (Case When RCover.NetRateF=1 or @P_ONGROSSNET=2 OR (@P_ONGROSSNET=0 AND (100-(@Premium_outGo-(Case When RPart.OnNetPremiumF=1 Then @Premium_Treaty_Discount else 0 end)))/100*(100-(CASE WHEN @P_COMMN<>0 Then @P_COMMN ELSE RPART.COMMN END))/100<(100-(CASE WHEN @P_COMM<>0 Then @P_COMM ELSE RPART.COMM END))/100) Then 1 else 1 end) end)*RPart.share/100*PCalc.Rate-(Case When @P_RITabarruF=1 Then 1 Else 0 end)*(ICALC.GROSS*@P_OPFEE/PCALC.POGROSS)*RPart.share/100*PCalc.Rate),0) AS GROSS_1,            
coalesce(SUM((Case When @P_RateConF=1 Then (Case When RRateCon.Rate is null then RateCon.Rate*(Case When RateCon.Loading<>0 then RateCon.Loading/100 else RCover.Loading end) else RRateCon.Rate/PCalc.RiskNum*(Case When RRateCon.Loading<>0 then RRateCon.Loading/100 else RCover.Loading end) end) Else coalesce(@P_NETRATEDet,RPart.NetRate/PCalc.RiskNum) end/100*(100-RCover.Discount)/100*ICALC.GROSS/PCALC.GROSS*ICALC.PRORATA *ICALC.TSI*(CASE WHEN RCOVER.PCALC='S' OR RCOVER.PCTLOSS=0 THEN 100 ELSE RCOVER.PCTLOSS END)/(CASE WHEN RCOVER.PCTLOSS=0 THEN 100 ELSE RCOVER.PCTLOSS END+RCOVER.PAddition)*ICALC.PCTADJ/100)*(Case When (CASE WHEN @P_COMMN<>0 Then @P_COMMN ELSE RPART.COMMN END)=0 Then 1 else (Case When RCover.NetRateF=1 or @P_ONGROSSNET=2 OR (@P_ONGROSSNET=0 AND (100-(@Premium_outGo-(Case When RPart.OnNetPremiumF=1 Then @Premium_Treaty_Discount else 0 end)))/100*(100-(CASE WHEN @P_COMMN<>0 Then @P_COMMN ELSE RPART.COMMN END))/100<(100-(CASE WHEN @P_COMM<>0 Then @P_COMM ELSE RPART.COMM END))/100) Then 1 else 1 end) end)*RPart.share/100*PCalc.Rate-(Case When @P_RITabarruF=1 Then 1 Else 0 end)*(ICALC.GROSS*@P_OPFEE/PCALC.POGROSS)*RPart.share/100*PCalc.Rate),0) AS GROSS_2,              
             
coalesce(SUM((CASE WHEN RPart.PPCT<>0 THEN RPart.PPCT/100 ELSE (Case When @P_RateConF=1 and (RRateCon.Rate is not null or RateCon.Rate is not null) then 0 else 1 end) END * ICALC.GROSS*(PCALC.PGROSS*@P_PFactor)/PCALC.POGROSS*(Case When RPart.OnNetPremiumF=1 Then (100-@Premium_Treaty_Discount)/100 else 1 end)-(ICALC.GROSS*@P_OPFEE/PCALC.POGROSS))*(Case When (CASE WHEN @P_COMMN<>0 Then @P_COMMN ELSE RPART.COMMN END)=0 Then 0 else (Case When RCover.NetRateF=1 or @P_ONGROSSNET=2 OR (@P_ONGROSSNET=0 AND (100-(@Premium_outGo-(Case When RPart.OnNetPremiumF=1 Then @Premium_Treaty_Discount else 0 end)))/100*(100-(CASE WHEN @P_COMMN<>0 Then @P_COMMN ELSE RPART.COMMN END))/100<(100-(CASE WHEN @P_COMM<>0 Then @P_COMM ELSE RPART.COMM END))/100) Then ((@Premium_outGo-(Case When RPart.OnNetPremiumF=1 Then @Premium_Treaty_Discount else 0 end)))/100 else 0 end) end)*RPart.share/100*PCalc.Rate),0) AS DISC_1,              
coalesce(SUM((Case When @P_RateConF=1 Then (Case When RRateCon.Rate is null then RateCon.Rate*(Case When RateCon.Loading<>0 then RateCon.Loading/100 else RCover.Loading end) else RRateCon.Rate/PCalc.RiskNum*(Case When RRateCon.Loading<>0 then RRateCon.Loading/100 else RCover.Loading end) end) Else coalesce(@P_NETRATEDet,RPart.NetRate/PCalc.RiskNum) end/100*(100-RCover.Discount)/100*ICALC.GROSS/PCALC.GROSS*ICALC.PRORATA *ICALC.TSI*(CASE WHEN RCOVER.PCALC='S' OR RCOVER.PCTLOSS=0 THEN 100 ELSE RCOVER.PCTLOSS END)/(CASE WHEN RCOVER.PCTLOSS=0 THEN 100 ELSE RCOVER.PCTLOSS END+RCOVER.PAddition)*ICALC.PCTADJ/100-(ICALC.GROSS*@P_OPFEE/PCALC.POGROSS))*(Case When (CASE WHEN @P_COMMN<>0 Then @P_COMMN ELSE RPART.COMMN END)=0 Then 0 else (Case When RCover.NetRateF=1 or @P_ONGROSSNET=2 OR (@P_ONGROSSNET=0 AND (100-(@Premium_outGo-(Case When RPart.OnNetPremiumF=1 Then @Premium_Treaty_Discount else 0 end)))/100*(100-(CASE WHEN @P_COMMN<>0 Then @P_COMMN ELSE RPART.COMMN END))/100<(100-(CASE WHEN @P_COMM<>0 Then @P_COMM ELSE RPART.COMM END))/100) Then ((@Premium_outGo-(Case When RPart.OnNetPremiumF=1 Then @Premium_Treaty_Discount else 0 end)))/100 else 0 end) end)*RPart.share/100*PCalc.Rate),0) AS DISC_2,              

coalesce(SUM((CASE WHEN RPart.PPCT<>0 THEN RPart.PPCT/100 ELSE (Case When @P_RateConF=1 and (RRateCon.Rate is not null or RateCon.Rate is not null) then 0 else 1 end) END * ICALC.GROSS*(PCALC.PGROSS*@P_PFactor)/PCALC.POGROSS*(Case When RPart.OnNetPremiumF=1 Then (100-@Premium_Treaty_Discount)/100 else 1 end))*(Case When (CASE WHEN @P_COMMN<>0 Then @P_COMMN ELSE RPART.COMMN END)=0 Then 1 else (Case When RCover.NetRateF=1 or @P_ONGROSSNET=2 OR (@P_ONGROSSNET=0 AND (100-(@Premium_outGo-(Case When RPart.OnNetPremiumF=1 Then @Premium_Treaty_Discount else 0 end)))/100*(100-(CASE WHEN @P_COMMN<>0 Then @P_COMMN ELSE RPART.COMMN END))/100<(100-(CASE WHEN @P_COMM<>0 Then @P_COMM ELSE RPART.COMM END))/100) Then 1 else 1 end) end)*RPart.Fee/100*RPart.share/100*PCalc.Rate-(Case When @P_RITabarruF=0 Then 1 Else 0 end)*(ICALC.GROSS*@P_OPFEE/PCALC.POGROSS)*RPart.share/100*PCalc.Rate),0) AS FEE_1,            
coalesce(SUM((Case When @P_RateConF=1 Then (Case When RRateCon.Rate is null then RateCon.Rate*(Case When RateCon.Loading<>0 then RateCon.Loading/100 else RCover.Loading end) else RRateCon.Rate/PCalc.RiskNum*(Case When RRateCon.Loading<>0 then RRateCon.Loading/100 else RCover.Loading end) end) Else coalesce(@P_NETRATEDet,RPart.NetRate/PCalc.RiskNum) end/100*(100-RCover.Discount)/100*ICALC.GROSS/PCALC.GROSS*ICALC.PRORATA *ICALC.TSI*(CASE WHEN RCOVER.PCALC='S' OR RCOVER.PCTLOSS=0 THEN 100 ELSE RCOVER.PCTLOSS END)/(CASE WHEN RCOVER.PCTLOSS=0 THEN 100 ELSE RCOVER.PCTLOSS END+RCOVER.PAddition)*ICALC.PCTADJ/100)*(Case When (CASE WHEN @P_COMMN<>0 Then @P_COMMN ELSE RPART.COMMN END)=0 Then 1 else (Case When RCover.NetRateF=1 or @P_ONGROSSNET=2 OR (@P_ONGROSSNET=0 AND (100-(@Premium_outGo-(Case When RPart.OnNetPremiumF=1 Then @Premium_Treaty_Discount else 0 end)))/100*(100-(CASE WHEN @P_COMMN<>0 Then @P_COMMN ELSE RPART.COMMN END))/100<(100-(CASE WHEN @P_COMM<>0 Then @P_COMM ELSE RPART.COMM END))/100) Then 1 else 1 end) end)*RPart.Fee/100*RPart.share/100*PCalc.Rate-(Case When @P_RITabarruF=0 Then 1 Else 0 end)*(ICALC.GROSS*@P_OPFEE/PCALC.POGROSS)*RPart.share/100*PCalc.Rate),0) AS FEE_2
              
FROM ICALC   
INNER JOIN ACCEPTANCE SACCEPTANCE ON (SACCEPTANCE.ANO=ICALC.SANO)  
INNER JOIN RCOVER ON (RCOVER.ANO=ICALC.SANO AND RCOVER.CODE=ICALC.CODE AND (RCOVER.SDATE=ICALC.SDATE OR (@P_AType='A' AND (CASE WHEN RCOVER.SDATE<SACCEPTANCE.PDATE THEN SACCEPTANCE.PDATE ELSE RCOVER.SDATE END)=ICALC.SDATE)))  
INNER JOIN REINSURANCE ON (REINSURANCE.RID=@P_RID)
INNER JOIN RPART ON (RPART.RNO=REINSURANCE.RNO)
LEFT JOIN RPARTDET ON (RPARTDET.RNO=@P_RNO AND RPARTDET.ID=RPART.ID AND RPARTDET.DOCNO=RPART.DOCNO AND RPARTDET.TOR=ICALC.TOR)  
LEFT Join FN_RateCon(@P_ANO, @P_CODE,@P_TSI,@P_ASDate) RateCon On (RateCon.Code=ICalc.Code)  
LEFT Join FN_RRateCon(@P_ANO, @P_RID, @P_TSI) RRateCon On (1=1)  
INNER JOIN ICOVER ON (ICOVER.INO=ICALC.INO AND (ICOVER.ADJUSTABLE=@P_ADJUSTABLEF OR @P_AType='A'))  
INNER JOIN RCALC ON (RCALC.ANO=ICALC.ANO AND RCALC.CURRENCY=ICALC.CURRENCY AND RCALC.CODE=ICALC.CODE AND RCALC.TOR=ICALC.TOR AND RCALC.SDATE=ICALC.SDATE AND RCALC.EDATE=ICALC.EDATE AND RCALC.SANO=ICALC.SANO AND RCALC.EXTREATYF=0)  
INNER JOIN PCALC_ANNUM(@P_ANO) PCALC ON (PCALC.ANO=ICALC.ANO AND PCALC.CODE=ICALC.CODE AND PCALC.SDATE=ICALC.SDATE AND PCALC.EDATE=ICALC.EDATE AND PCALC.INO=ICALC.INO AND PCALC.CURRENCY=ICALC.CURRENCY)  
WHERE ICALC.ANO=@P_ANO AND ICALC.CURRENCY=@P_CCY AND ICALC.SDATE=@P_SDATE AND ICALC.EDATE=@P_EDATE AND ICALC.CODE=@P_CODE              
AND RPARTDET.TOR IS NULL AND PCALC.GROSS<>0  
Group By RPart.ID

Union All              

select              
RPart.ID,
cast(Max(Cast(RPart.OnMinPremiumF as integer)) as Bit) as OnMinPremiumF,              

coalesce(SUM((CASE WHEN RPARTDET.PPCT<>0 THEN RPARTDET.PPCT/100 ELSE (Case When @P_RateConF=1 and (RRateCon.Rate is not null or RateCon.Rate is not null) then 0 else 1 end) END * ICALC.GROSS*(PCALC.PGROSS*@P_PFactor)/PCALC.POGROSS-(ICALC.GROSS*@P_OPFEE/PCALC.POGROSS))*(Case When RPart.OnNetPremiumF=1 Then (100-@Premium_Treaty_Discount)/100 else 1 end)*(Case When RPARTDET.COMMN=0 Then RPARTDET.COMM/100 else (Case When RCover.NetRateF=1 or @P_ONGROSSNET=2 OR (@P_ONGROSSNET=0 AND (100-(@Premium_outGo-(Case When RPart.OnNetPremiumF=1 Then @Premium_Treaty_Discount else 0 end)))/100*(100-RPARTDET.CommN)/100<(100-RPARTDET.COMM)/100) Then (100-(@Premium_outGo-(Case When RPart.OnNetPremiumF=1 Then @Premium_Treaty_Discount else 0 end)))/100*(RPARTDET.CommN)/100 else RPARTDET.COMM/100 end) end)*RPart.share/100*PCalc.Rate),0) AS COMM_1,              
coalesce(SUM((Case When @P_RateConF=1 Then (Case When RRateCon.Rate is null then RateCon.Rate*(Case When RateCon.Loading<>0 then RateCon.Loading/100 else RCover.Loading end) else RRateCon.Rate/PCalc.RiskNum*(Case When RRateCon.Loading<>0 then RRateCon.Loading/100 else RCover.Loading end) end) Else coalesce(@P_NETRATEDet,RPARTDET.NETRate) end/100*(100-RCover.Discount)/100*ICALC.GROSS/PCALC.GROSS*ICALC.PRORATA *ICALC.TSI*(CASE WHEN RCOVER.PCALC='S' OR RCOVER.PCTLOSS=0 THEN 100 ELSE RCOVER.PCTLOSS END)/(CASE WHEN RCOVER.PCTLOSS=0 THEN 100 ELSE RCOVER.PCTLOSS END+RCOVER.PAddition)*ICALC.PCTADJ/100-(ICALC.GROSS*@P_OPFEE/PCALC.POGROSS))*(Case When RPARTDET.COMMN=0 Then RPARTDET.COMM/100 else (Case When RCover.NetRateF=1 or @P_ONGROSSNET=2 OR (@P_ONGROSSNET=0 AND (100-(@Premium_outGo-(Case When RPart.OnNetPremiumF=1 Then @Premium_Treaty_Discount else 0 end)))/100*(100-RPARTDET.CommN)/100<(100-RPARTDET.COMM)/100) Then (100-(@Premium_outGo-(Case When RPart.OnNetPremiumF=1 Then @Premium_Treaty_Discount else 0 end)))/100*(RPARTDET.CommN)/100 else RPARTDET.COMM/100 end) end)*RPart.share/100*PCalc.Rate),0) AS COMM_2,                  
              
coalesce(SUM((CASE WHEN RPARTDET.PPCT<>0 THEN RPARTDET.PPCT/100 ELSE (Case When @P_RateConF=1 and (RRateCon.Rate is not null or RateCon.Rate is not null) then 0 else 1 end) END * ICALC.GROSS*(PCALC.PGROSS*@P_PFactor)/PCALC.POGROSS)*(Case When RPart.OnNetPremiumF=1 Then (100-@Premium_Treaty_Discount)/100 else 1 end)*(Case When RPARTDET.COMMN=0 Then 1 else (Case When RCover.NetRateF=1 or @P_ONGROSSNET=2 OR (@P_ONGROSSNET=0 AND (100-(@Premium_outGo-(Case When RPart.OnNetPremiumF=1 Then @Premium_Treaty_Discount else 0 end)))/100*(100-RPARTDET.CommN)/100<(100-RPARTDET.COMM)/100) Then 1 else 1 end) end)*RPart.share/100*PCalc.Rate-(Case When @P_RITabarruF=1 Then 1 Else 0 end)*(ICALC.GROSS*@P_OPFEE/PCALC.POGROSS)*RPart.share/100*PCalc.Rate),0) AS GROSS_1,            
coalesce(SUM((Case When @P_RateConF=1 Then (Case When RRateCon.Rate is null then RateCon.Rate*(Case When RateCon.Loading<>0 then RateCon.Loading/100 else RCover.Loading end) else RRateCon.Rate/PCalc.RiskNum*(Case When RRateCon.Loading<>0 then RRateCon.Loading/100 else RCover.Loading end) end) Else coalesce(@P_NETRATEDet,RPARTDET.NETRate) end/100*(100-RCover.Discount)/100*ICALC.GROSS/PCALC.GROSS*ICALC.PRORATA *ICALC.TSI*(CASE WHEN RCOVER.PCALC='S' OR RCOVER.PCTLOSS=0 THEN 100 ELSE RCOVER.PCTLOSS END)/(CASE WHEN RCOVER.PCTLOSS=0 THEN 100 ELSE RCOVER.PCTLOSS END+RCOVER.PAddition)*ICALC.PCTADJ/100)*(Case When RPARTDET.COMMN=0 Then 1 else (Case When RCover.NetRateF=1 or @P_ONGROSSNET=2 OR (@P_ONGROSSNET=0 AND (100-(@Premium_outGo-(Case When RPart.OnNetPremiumF=1 Then @Premium_Treaty_Discount else 0 end)))/100*(100-RPARTDET.CommN)/100<(100-RPARTDET.COMM)/100) Then 1 else 1 end) end)*RPart.share/100*PCalc.Rate-(Case When @P_RITabarruF=1 Then 1 Else 0 end)*(ICALC.GROSS*@P_OPFEE/PCALC.POGROSS)*RPart.share/100*PCalc.Rate),0) AS GROSS_2,           

coalesce(SUM((CASE WHEN RPARTDET.PPCT<>0 THEN RPARTDET.PPCT/100 ELSE (Case When @P_RateConF=1 and (RRateCon.Rate is not null or RateCon.Rate is not null) then 0 else 1 end) END * ICALC.GROSS*(PCALC.PGROSS*@P_PFactor)/PCALC.POGROSS-(ICALC.GROSS*@P_OPFEE/PCALC.POGROSS))*(Case When RPart.OnNetPremiumF=1 Then (100-@Premium_Treaty_Discount)/100 else 1 end)*(Case When RPARTDET.COMMN=0 Then 0 else (Case When RCover.NetRateF=1 or @P_ONGROSSNET=2 OR (@P_ONGROSSNET=0 AND (100-(@Premium_outGo-(Case When RPart.OnNetPremiumF=1 Then @Premium_Treaty_Discount else 0 end)))/100*(100-RPARTDET.CommN)/100<(100-RPARTDET.COMM)/100) Then ((@Premium_outGo-(Case When RPart.OnNetPremiumF=1 Then @Premium_Treaty_Discount else 0 end)))/100 else 0 end) end)*RPart.share/100*PCalc.Rate),0) AS DISC_1,              
coalesce(SUM((Case When @P_RateConF=1 Then (Case When RRateCon.Rate is null then RateCon.Rate*(Case When RateCon.Loading<>0 then RateCon.Loading/100 else RCover.Loading end) else RRateCon.Rate/PCalc.RiskNum*(Case When RRateCon.Loading<>0 then RRateCon.Loading/100 else RCover.Loading end) end) Else coalesce(@P_NETRATEDet,RPARTDET.NETRate) end/100*(100-RCover.Discount)/100*ICALC.GROSS/PCALC.GROSS*ICALC.PRORATA *ICALC.TSI*(CASE WHEN RCOVER.PCALC='S' OR RCOVER.PCTLOSS=0 THEN 100 ELSE RCOVER.PCTLOSS END)/(CASE WHEN RCOVER.PCTLOSS=0 THEN 100 ELSE RCOVER.PCTLOSS END+RCOVER.PAddition)*ICALC.PCTADJ/100-(ICALC.GROSS*@P_OPFEE/PCALC.POGROSS))*(Case When RPARTDET.COMMN=0 Then 0 else (Case When RCover.NetRateF=1 or @P_ONGROSSNET=2 OR (@P_ONGROSSNET=0 AND (100-(@Premium_outGo-(Case When RPart.OnNetPremiumF=1 Then @Premium_Treaty_Discount else 0 end)))/100*(100-RPARTDET.CommN)/100<(100-RPARTDET.COMM)/100) Then ((@Premium_outGo-(Case When RPart.OnNetPremiumF=1 Then @Premium_Treaty_Discount else 0 end)))/100 else 0 end) end)*RPart.share/100*PCalc.Rate),0) AS DISC_2,                  

coalesce(SUM((CASE WHEN RPARTDET.PPCT<>0 THEN RPARTDET.PPCT/100 ELSE (Case When @P_RateConF=1 and (RRateCon.Rate is not null or RateCon.Rate is not null) then 0 else 1 end) END * ICALC.GROSS*(PCALC.PGROSS*@P_PFactor)/PCALC.POGROSS)*(Case When RPart.OnNetPremiumF=1 Then (100-@Premium_Treaty_Discount)/100 else 1 end)*(Case When RPARTDET.COMMN=0 Then 1 else (Case When RCover.NetRateF=1 or @P_ONGROSSNET=2 OR (@P_ONGROSSNET=0 AND (100-(@Premium_outGo-(Case When RPart.OnNetPremiumF=1 Then @Premium_Treaty_Discount else 0 end)))/100*(100-RPARTDET.CommN)/100<(100-RPARTDET.COMM)/100) Then 1 else 1 end) end)*RPart.Fee/100*RPart.share/100*PCalc.Rate-(Case When @P_RITabarruF=0 Then 1 Else 0 end)*(ICALC.GROSS*@P_OPFEE/PCALC.POGROSS)*RPart.share/100*PCalc.Rate),0) AS FEE_1,            
coalesce(SUM((Case When @P_RateConF=1 Then (Case When RRateCon.Rate is null then RateCon.Rate*(Case When RateCon.Loading<>0 then RateCon.Loading/100 else RCover.Loading end) else RRateCon.Rate/PCalc.RiskNum*(Case When RRateCon.Loading<>0 then RRateCon.Loading/100 else RCover.Loading end) end) Else coalesce(@P_NETRATEDet,RPARTDET.NETRate) end/100*(100-RCover.Discount)/100*ICALC.GROSS/PCALC.GROSS*ICALC.PRORATA *ICALC.TSI*(CASE WHEN RCOVER.PCALC='S' OR RCOVER.PCTLOSS=0 THEN 100 ELSE RCOVER.PCTLOSS END)/(CASE WHEN RCOVER.PCTLOSS=0 THEN 100 ELSE RCOVER.PCTLOSS END+RCOVER.PAddition)*ICALC.PCTADJ/100)*(Case When RPARTDET.COMMN=0 Then 1 else (Case When RCover.NetRateF=1 or @P_ONGROSSNET=2 OR (@P_ONGROSSNET=0 AND (100-(@Premium_outGo-(Case When RPart.OnNetPremiumF=1 Then @Premium_Treaty_Discount else 0 end)))/100*(100-RPARTDET.CommN)/100<(100-RPARTDET.COMM)/100) Then 1 else 1 end) end)*RPart.Fee/100*RPart.share/100*PCalc.Rate-(Case When @P_RITabarruF=0 Then 1 Else 0 end)*(ICALC.GROSS*@P_OPFEE/PCALC.POGROSS)*RPart.share/100*PCalc.Rate),0) AS FEE_2
FROM ICALC   
INNER JOIN ACCEPTANCE SACCEPTANCE ON (SACCEPTANCE.ANO=ICALC.SANO)  
INNER JOIN RCOVER ON (RCOVER.ANO=ICALC.SANO AND RCOVER.CODE=ICALC.CODE AND (RCOVER.SDATE=ICALC.SDATE OR (@P_AType='A' AND (CASE WHEN RCOVER.SDATE<SACCEPTANCE.PDATE THEN SACCEPTANCE.PDATE ELSE RCOVER.SDATE END)=ICALC.SDATE)))  
INNER JOIN REINSURANCE ON (REINSURANCE.RID=@P_RID)
INNER JOIN RPART ON (RPART.RNO=REINSURANCE.RNO)
INNER JOIN RPARTDET ON (RPARTDET.RNO=@P_RNO AND RPARTDET.ID=RPART.ID AND RPARTDET.DOCNO=RPART.DOCNO AND RPARTDET.TOR=ICALC.TOR AND (RPARTDET.NOFYEARS=0 OR RPARTDET.NOFYEARS=@P_NOFYEARS) and RPARTDET.EXCLUDEF=0)  
LEFT Join FN_RateCon(@P_ANO, @P_CODE,@P_TSI,@P_ASDate) RateCon On (RateCon.Code=ICalc.Code)  
LEFT Join FN_RRateCon(@P_ANO, @P_RID, @P_TSI) RRateCon On (1=1)              
INNER JOIN ICOVER ON (ICOVER.INO=ICALC.INO AND (ICOVER.ADJUSTABLE=@P_ADJUSTABLEF OR @P_AType='A'))  
INNER JOIN RCALC ON (RCALC.ANO=ICALC.ANO AND RCALC.CURRENCY=ICALC.CURRENCY AND RCALC.CODE=ICALC.CODE AND RCALC.TOR=ICALC.TOR AND RCALC.SDATE=ICALC.SDATE AND RCALC.EDATE=ICALC.EDATE AND RCALC.SANO=ICALC.SANO AND RCALC.EXTREATYF=0)  
INNER JOIN PCALC_ANNUM(@P_ANO) PCALC ON (PCALC.ANO=ICALC.ANO AND PCALC.CODE=ICALC.CODE AND PCALC.SDATE=ICALC.SDATE AND PCALC.EDATE=ICALC.EDATE AND PCALC.INO=ICALC.INO AND PCALC.CURRENCY=ICALC.CURRENCY)  
WHERE ICALC.ANO=@P_ANO AND ICALC.CURRENCY=@P_CCY AND ICALC.SDATE=@P_SDATE AND ICALC.EDATE=@P_EDATE AND ICALC.CODE=@P_CODE              
AND PCALC.GROSS<>0  
Group By RPart.ID


) R        

GO

DROP Function Premium_Fee
GO
CREATE Function Premium_Fee(@P_ANO as int,@P_Period int=0) 
RETURNS Float 
AS 
BEGIN 

Declare @P_OPFEEPCT Float


Select @P_OPFEEPCT=Sum(Fee)
From
(
	Select
		sum(Fee*Pcalc.Rate)/Max(Pcalc.Gross*Pcalc.Rate)*100 as Fee
	from
	(
		SELECT 
		A1.Currency,
		Case 
		When A1.Amount<>0 Then
			A1.Amount*100/coalesce(R.PCTSHARE-R.MSHARE,100)
		When A1.AMOUNTPCTBASED=0 Then
			(
				Select 
				sum(D1.Gross*P.Gross/P.OGross)
				from Display_Calculation(A2.ANO) D1, Acceptance A, PCalc P
				Where P.ANO=A.ANO and P.Currency=D1.Currency and A.ANO=D1.ANO and D1.Currency=A1.Currency
			)*A1.AmountPCT/100
		Else
			(
				Select 
				sum(D1.Gross*P.Gross/P.OGross*(1-dbo.Premium_Commission(D1.ANO, D1.Code,0,0)/100))
				from Display_Calculation(A2.ANO) D1, Acceptance A, PCalc P
				Where P.ANO=A.ANO and P.Currency=D1.Currency and A.ANO=D1.ANO and D1.Currency=A1.Currency
			)*A1.AmountPCT/100
		End    as FEE
		from 
		Acceptance A3
		Inner Join Acceptance A2 on (A2.OANO=A3.OANO and A2.ANO<=@P_ANO)
		INNER JOIN AccFD A1 on (A1.ANO=A2.ANO and A1.ContributionF=0 and A1.CessionF=0 And A1.AmountPCTBased in (0,3) And (A1.PolicyYear=0 or A1.PolicyYear=@P_Period))
		INNER JOIN FDTAB on (FDTAB.FDID=A1.FDID AND Left(FDTAB.FDType,1)='O')
		INNER JOIN RARRHEADER R ON (R.ANO=A3.ANO)
		Where A3.ANO=@P_ANO and A2.ANO>(Select coalesce(Max(ANO),0) from Acceptance Where AType='C' and EMethod='A' and Acceptance.OANO=A2.OANO and Acceptance.ANO<=@P_ANO and AStatus not in ('W','T'))
	) R
	Inner Join PCalc on (PCalc.ANO=@P_ANO and PCalc.Currency=R.Currency)	

	Union All

	--Op Fee from Master Policy
	Select
		sum(Fee*Pcalc.Rate)/Max(Pcalc.Gross*Pcalc.Rate)*100 as Fee
	from
	(
		SELECT
		A1.Currency,
		Case 
		When A1.Amount<>0 Then
			--Not Yet for Master Policy
			0
		When A1.AMOUNTPCTBASED=0 Then
			(
				Select 
				sum(D1.Gross*P.Gross/P.OGross)
				from Display_Calculation(A2.ANO) D1, Acceptance A, PCalc P
				Where P.ANO=A.ANO and P.Currency=D1.Currency and A.ANO=D1.ANO and D1.Currency=A1.Currency
			)*A1.AmountPCT/100
		Else
			(
				Select 
				sum(D1.Gross*P.Gross/P.OGross*(1-dbo.Premium_Commission(D1.ANO, D1.Code,0,0)/100))
				from Display_Calculation(A2.ANO) D1, Acceptance A, PCalc P
				Where P.ANO=A.ANO and P.Currency=D1.Currency and A.ANO=D1.ANO and D1.Currency=A1.Currency
			)*A1.AmountPCT/100
		End    as FEE
		from
		Acceptance A3 
		Inner Join Acceptance A2 on (A2.OANO=A3.OANO and A2.ANO<=@P_ANO)
		INNER JOIN Acceptance MA on (MA.RegNo=A2.RegNo and MA.ANO=MA.LANO)
		INNER JOIN COVER C on (C.CNO=MA.CNO and C.OPENFLAG=0)
		INNER JOIN AccFD A1 on (A1.ANO=MA.ANO and A1.ContributionF=0 and A1.CessionF=0 and A1.AmountPCTBased in (0,3) And (A1.PolicyYear=0 or A1.PolicyYear=@P_Period))
		INNER JOIN FDTAB on (FDTAB.FDID=A1.FDID and left(FDTAB.FDType,1)='O')
		INNER JOIN RARRHEADER R ON (R.ANO=A2.ANO)
		Where A3.ANO=@P_ANO and A2.ANO>(Select coalesce(Max(ANO),0) from Acceptance Where AType='C' and EMethod='A' and Acceptance.OANO=A2.OANO and Acceptance.ANO<=@P_ANO and AStatus not in ('W','T'))
	) R
	Inner Join PCalc on (PCalc.ANO=@P_ANO and PCalc.Currency=R.Currency)	
) A

if @P_OPFEEPCT is null 
	Select @P_OPFEEPCT=0

return (@P_OPFEEPCT) 
 
End


go


 insert into PatchVersioning	
select '687 Update Script - Patch 2023 (63)',GETDATE()
go





Declare @PrevScript varchar(100)
Declare @CurrScript varchar(100)

Select @PrevScript=''
Select @CurrSCript='687 Update Script - Patch 2023 (63)'


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




