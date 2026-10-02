
IF EXISTS ( SELECT * FROM   sysobjects WHERE  id = object_id(N'QCheckObjectInsured_Upload') and OBJECTPROPERTY(id, N'IsProcedure') = 1 ) 
BEGIN DROP PROCEDURE QCheckObjectInsured_Upload
end
GO
CREATE Procedure QCheckObjectInsured_Upload(@REGID as varchar(10),@FLDID AS varchar(255),@VALUEID AS varchar(255),@PDate AS smalldatetime,@PPDate AS smalldatetime,@REFNO varchar(255),@PExclusiveF as Bit=0) 
as 
 
Select [Quotation No], [CI No], [Policy No], Insured, Inception, Expiry, ANO 
FROM 
( 
Select Top 1 
C1.CoverNo as [Quotation No], 
A1.RegNo as [CI No], 
A1.PolicyNo + case when A1.CertificateNo='' then '' else '-' + A1.CertificateNo end as [Policy No], 
C1.Insured, 
A1.SDate as Inception, 
A1.EDate as Expiry, 
A1.ANO, 
TOC.UniqueRefNoF, 
A1.RefNo 
from Cover C1, Acceptance A1, TOC 
Where C1.CNO=A1.CNO and TOC.TOC=A1.TOC and A1.AType not in ('A','C') 
and A1.LANO<>A1.ANO and Not (A1.AType='N' and A1.AStatus='C' and ((C1.CStatus='A' and C1.ASource='MKT') or C1.CStatus='C')) 
and A1.PDate<A1.PPDate 
and ( 
	(A1.pDate<=@PDate and ((A1.PPDate>@PDate) or (A1.PPDate>=@PDate and A1.ExclusiveF=0 and @PExclusiveF=1))) or 
	(@PDate<=A1.PDate and ((@PPDate>A1.PDate) or (@PPDate>=A1.PDate and @PExclusiveF=0 and A1.ExclusiveF=1))) 
	) 
and A1.RegID=@REGID and A1.FLDID<>'' and A1.FLDID=@FLDID and A1.ValueID=@VALUEID 
Order by Case When A1.RefNo=@RefNo Then 1 else 0 end Desc, A1.ANO
) R 
Where R.UniqueRefNoF=0 or (R.UniqueRefNoF=1 and R.RefNo=@REFNO) 
 
GO

IF EXISTS ( SELECT * FROM   sysobjects WHERE  id = object_id(N'QInterest_Data') and OBJECTPROPERTY(id, N'IsProcedure') = 1 ) 
BEGIN DROP PROCEDURE QInterest_Data
end
GO
CREATE Procedure QInterest_Data(@P_INO integer, @P_ANO integer=0)  
as  
SELECT  
I1.*,  
I2.FLDID1, I2.VALUEID1, I2.VALUEDESC1,  
I2.FLDID2, I2.VALUEID2, I2.VALUEDESC2,  
I2.FLDID3, I2.VALUEID3, I2.VALUEDESC3,  
I2.FLDID4, I2.VALUEID4, I2.VALUEDESC4,  
I2.FLDID5, I2.VALUEID5, I2.VALUEDESC5,  
I2.FLDID6, I2.VALUEID6, I2.VALUEDESC6,  
I2.FLDID7, I2.VALUEID7, I2.VALUEDESC7,  
I2.FLDID8, I2.VALUEID8, I2.VALUEDESC8,  
I2.FLDID9, I2.VALUEID9, I2.VALUEDESC9,  
I2.FLDID10, I2.VALUEID10, I2.VALUEDESC10,  
I2.FLDID11, I2.VALUEID11, I2.VALUEDESC11,  
I2.FLDID12, I2.VALUEID12, I2.VALUEDESC12,  
I2.FLDID13, I2.VALUEID13, I2.VALUEDESC13,  
I2.FLDID14, I2.VALUEID14, I2.VALUEDESC14,  
I2.FLDID15, I2.VALUEID15, I2.VALUEDESC15,  
I3.FLDVALUEF, I3.FLDVALUEL,  
I3.FLDTAG1, I3.FLDVALUE1, I3.FLDOP1,  
I3.FLDTAG2, I3.FLDVALUE2, I3.FLDOP2,  
I3.FLDTAG3, I3.FLDVALUE3, I3.FLDOP3,  
I3.FLDTAG4, I3.FLDVALUE4, I3.FLDOP4,  
I3.FLDTAG5, I3.FLDVALUE5, I3.FLDOP5,  
I3.FLDTAG6 , I3.FLDVALUE6, I3.FLDOP6,
I4.CURRENCY as CURRENCY_POL, I4.AMOUNT as AMOUNT_POL
FROM ICOVER I1 
Left Join IINFO I2 On (I2.INO=I1.INO) 
Left Join ICoverExt I3 ON (I3.INO=I1.INO)  
Left Join ICOVERPOL I4 on (I4.ANO=coalesce(I1.ANO,@P_ANO))
WHERE I1.INO=@P_INO  
        
GO

if exists (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'FN_UserBusinessSource') AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) )
 BEGIN DROP FUNCTION FN_UserBusinessSource 
end
GO
CREATE FUNCTION FN_UserBusinessSource (@P_UserID as varchar(10), @P_PDate as smalldatetime)      
RETURNS TABLE      
as RETURN(      
Select P.ID, P.Name, P.Address_1, P.Address_2, P.Remark, P.Comm, P.TaxType, P.VatF, P.TaxF, P.NetCommF, P.RestrictedF, P.LOB, 
S1.ID as SID, S1.Name as SName,
AIF.AgentType 
From Profile P 
Left Join AIF on (AIF.ID=P.ID)
Left Join SysUserAssignment S on (S.AssType='SOURCE' and S.PID=P.ID and S.ID=@P_UserID)
Left join SysUser S1 on (S1.ID=S.ID and S1.AllowedF=1)
Where coalesce(P.DumpF,0)=0 and P.IntermediaryF=1
and (coalesce(P.LicenseExpiry,cast(convert(varchar(10), @P_PDate,1) as smalldatetime))>=cast(convert(varchar(10), @P_PDate,1) as smalldatetime))
and
(
not exists(Select Top 1 PID from SysUserAssignment S Where S.AssType='SOURCE' and S.ID=@P_UserID)
or coalesce(S1.ID,'')=@P_UserID
)
)    

GO



if exists (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'FN_UserMO') AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) )
 BEGIN DROP FUNCTION FN_UserMO
end
GO
CREATE function FN_UserMO(@P_USERID varchar(50))          
RETURNS Table            
AS RETURN            
(          
SELECT S1.*      
from SysUser S1    
Left join SysUserMO S on (S.MO=S1.ID and S.ID=@P_UserID)
Where S1.AllowedF=1
and 
(
not exists(Select Top 1 MO from SysUserMO S Where S.ID=@P_UserID)
or coalesce(S.ID,'')=@P_UserID
)
)              
    
GO


IF EXISTS ( SELECT * FROM   sysobjects WHERE  id = object_id(N'QRCESSIONDET') and OBJECTPROPERTY(id, N'IsProcedure') = 1 ) 
BEGIN DROP PROCEDURE QRCESSIONDET 
end
GO
CREATE Procedure QRCESSIONDET (@P_ANO integer,@P_RID varchar(255), @P_ID varchar(255), @P_CCY varchar(255), @P_SDate DateTime, @P_EDate DateTime, @P_Code varchar(10), @P_AdjustableF bit,@P_TSI as Float=0, @P_ASDate as DateTime=0)              
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
@P_Tabarru=(100-A.Ujroh)
from Acceptance A, RarrHeader R, Cover C Left Join ISource I on (I.CNO=C.CNO) Left Join ISourceDet I2 on (I2.CNO=I.CNO and I2.Code=@P_Code) , Reinsurance R1, RPart R2, ReClass R3 Left Join ReClassDet R4 ON (R4.RNO=R3.RNO AND R4.TOC=R3.TOC AND R4.CODE=@P_CODE)  
Where C.CNO=A.CNO and R.ANO=A.ANO and A.ANO=@P_ANO and R1.RID=@P_RID and R2.RNO=R1.RNO and R3.RNO=R1.RNO and R2.ID=@P_ID and R3.TOC=A.TOC  

Select @Premium_Treaty_Discount=dbo.Premium_Treaty_Discount(@P_ANO, @P_Code,@P_Period)          
Select @Premium_Discount=dbo.premium_discount(@P_ANO, @P_Code, @P_Period)  
Select @Premium_Commission=dbo.Premium_Commission(@P_ANO, @P_Code, @P_Period,0)+dbo.Premium_Commission_Vat(@P_ANO, @P_Code, @P_Period,0)  
Select @Premium_Fee=dbo.Premium_Fee(@P_ANO, @P_Period)  
Select @Premium_outGo=@Premium_Discount+@Premium_Commission+@Premium_Commission_Inward+@Premium_Fee-(Case When @P_OnNetPremiumF=1 Then @Premium_Treaty_Discount else 0 end)

SELECT @P_OPFEE=COALESCE(SUM(FEE),0), @P_RITabarruF=coalesce(cast(Max(cast(RITabarruF as Int)) as Bit),0)
FROM
(
       SELECT
       A2.ANO,
       Case When A1.Amount<>0 Then
             A1.Amount*100/coalesce(R.PCTSHARE-R.MSHARE,100)*Case When A1.RITabarruF=1 Then cast(100 as Float)/@P_Tabarru Else 1 end
       Else
             (
                    Select 
                    sum(D1.Gross*P.Gross/P.OGross)
                    from Display_Calculation(A2.ANO) D1, Acceptance A, PCalc P, RARRHEADER R
                    Where P.ANO=A.ANO and P.Currency=D1.Currency and A.ANO=D1.ANO and R.ANO=A.ANO and D1.Currency=@P_CCY
             )*A1.AmountPCT/100*Case When A1.RITabarruF=1 Then cast(100 as Float)/@P_Tabarru Else 1 end
       End    as FEE,
	   A1.RITabarruF
       from 
       Acceptance A2
       INNER JOIN AccFD A1 on (A1.ANO=A2.ANO and A1.Currency=@P_CCY and A1.ContributionF=1 and A1.AmountPCTBased=0 And (A1.PolicyYear=0 or A1.PolicyYear=@P_Period))
       INNER JOIN FDTAB on (FDTAB.FDID=A1.FDID and Left(FDTAB.FDType,1)='O')
       INNER Join PCalc on (PCalc.ANO=A2.ANO and PCalc.Currency=A1.Currency)
       INNER JOIN RARRHEADER R ON (R.ANO=A2.ANO)
       Where @P_RType in ('Q','S1','S2','S3') and A2.OANO=@P_OANO and A2.ANO<=@P_ANO  
	   and A2.ANO>(Select coalesce(Max(ANO),0) from Acceptance Where AType='C' and EMethod='A' and Acceptance.OANO=@P_OANO and Acceptance.ANO<=@P_ANO and AStatus not in ('W','T'))

	   Union All

	   --Op Fee from Master Policy
       SELECT
       A2.ANO,
       Case When A1.Amount<>0 Then
			--Not Yet for Master Policy
			0
       Else
             (
                    Select 
                    sum(D1.Gross*P.Gross/P.OGross)
                    from Display_Calculation(A2.ANO) D1, Acceptance A, PCalc P, RARRHEADER R
                    Where P.ANO=A.ANO and P.Currency=D1.Currency and A.ANO=D1.ANO and R.ANO=A.ANO and D1.Currency=@P_CCY
             )*A1.AmountPCT/100*Case When A1.RITabarruF=1 Then cast(100 as Float)/@P_Tabarru Else 1 end
       End    as FEE,
	   A1.RITabarruF
       from 
       Acceptance A2
	   INNER JOIN Acceptance MA on (MA.RegNo=A2.RegNo and MA.ANO=MA.LANO)
	   INNER JOIN COVER C on (C.CNO=MA.CNO and C.OPENFLAG=0)
       INNER JOIN AccFD A1 on (A1.ANO=MA.ANO and A1.Currency=@P_CCY and A1.ContributionF=1 and A1.AmountPCTBased=0 And (A1.PolicyYear=0 or A1.PolicyYear=@P_Period))
       INNER JOIN FDTAB on (FDTAB.FDID=A1.FDID and left(FDTAB.FDType,1)='O')
       INNER Join PCalc on (PCalc.ANO=A2.ANO and PCalc.Currency=A1.Currency)
       INNER JOIN RARRHEADER R ON (R.ANO=A2.ANO)
       Where @P_RType in ('Q','S1','S2','S3') and A2.OANO=@P_OANO and A2.ANO<=@P_ANO  
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
coalesce(SUM((Case When @P_RateConF=1 Then (Case When RRateCon.Rate is null then RateCon.Rate*(Case When RateCon.Loading<>0 then RateCon.Loading/100 else RCover.Loading end) else RRateCon.Rate/PCalc.RiskNum*(Case When RRateCon.Loading<>0 then RRateCon.Loading/100 else RCover.Loading end) end) Else coalesce(@P_NETRATEDet,@P_NETRATE/PCalc.RiskNum) end/100*(100-RCover.Discount)/100*ICALC.GROSS/PCALC.GROSS*ICALC.PRORATA *ICALC.TSI*(CASE WHEN RCOVER.PCALC='S' OR RCOVER.PCTLOSS=0 THEN 100 ELSE RCOVER.PCTLOSS END)/(CASE WHEN RCOVER.PCTLOSS=0 THEN 100 ELSE RCOVER.PCTLOSS END+RCOVER.PAddition)*ICALC.PCTADJ/100)*(Case When @P_COMMN=0 Then 0 else (Case When RCover.NetRateF=1 or @P_ONGROSSNET=2 OR (@P_ONGROSSNET=0 AND (100-@Premium_OutGo)/100*(100-@P_COMMN)/100<(100-@P_COMM)/100) Then (@Premium_OutGo)/100 else 0 end) end)),0) AS DISC_2,  

coalesce(SUM((CASE WHEN @P_PPCT<>0 THEN @P_PPCT/100 ELSE (Case When @P_RateConF=1 and (RRateCon.Rate is not null or RateCon.Rate is not null) then 0 else 1 end) END * ICALC.GROSS*(PCALC.PGROSS*@P_PFactor)/PCALC.POGROSS*(Case When @P_OnNetPremiumF=1 Then (100-@Premium_Treaty_Discount)/100 else 1 end))*(Case When @P_COMMN=0 Then 1 else (Case When RCover.NetRateF=1 or @P_ONGROSSNET=2 OR (@P_ONGROSSNET=0 AND (100-@Premium_OutGo)/100*(100-@P_COMMN)/100<(100-@P_COMM)/100) Then 1 else 1 end) end)*@P_FEE/100-(Case When @P_RITabarruF=0 Then 1 Else 0 end)*(ICALC.GROSS*@P_OPFEE/PCALC.POGROSS)),0) AS FEE_1,              
coalesce(SUM((Case When @P_RateConF=1 Then (Case When RRateCon.Rate is null then RateCon.Rate*(Case When RateCon.Loading<>0 then RateCon.Loading/100 else RCover.Loading end) else RRateCon.Rate/PCalc.RiskNum*(Case When RRateCon.Loading<>0 then RRateCon.Loading/100 else RCover.Loading end) end) Else coalesce(@P_NETRATEDet,@P_NETRATE/PCalc.RiskNum) end/100*(100-RCover.Discount)/100*ICALC.GROSS/PCALC.GROSS*ICALC.PRORATA *ICALC.TSI*(CASE WHEN RCOVER.PCALC='S' OR RCOVER.PCTLOSS=0 THEN 100 ELSE RCOVER.PCTLOSS END)/(CASE WHEN RCOVER.PCTLOSS=0 THEN 100 ELSE RCOVER.PCTLOSS END+RCOVER.PAddition)*ICALC.PCTADJ/100)*(Case When @P_COMMN=0 Then 1 else (Case When RCover.NetRateF=1 or @P_ONGROSSNET=2 OR (@P_ONGROSSNET=0 AND (100-@Premium_OutGo)/100*(100-@P_COMMN)/100<(100-@P_COMM)/100) Then 1 else 1 end) end)*@P_FEE/100-(Case When @P_RITabarruF=0 Then 1 Else 0 end)*(ICALC.GROSS*@P_OPFEE/PCALC.POGROSS)),0) AS FEE_2  
              
FROM ICALC   
INNER JOIN ACCEPTANCE SACCEPTANCE ON (SACCEPTANCE.ANO=ICALC.SANO)  
INNER JOIN RCOVER ON (RCOVER.ANO=ICALC.SANO AND RCOVER.CODE=ICALC.CODE AND (RCOVER.SDATE=ICALC.SDATE OR (@P_AType='A' AND (CASE WHEN RCOVER.SDATE<SACCEPTANCE.PDATE THEN SACCEPTANCE.PDATE ELSE RCOVER.SDATE END)=ICALC.SDATE)))  
LEFT JOIN RPARTDET ON (RPARTDET.RNO=@P_RNO AND RPARTDET.ID=@P_ID AND RPARTDET.TOR=ICALC.TOR)  
LEFT Join FN_RateCon(@P_ANO, @P_CODE,@P_TSI) RateCon On (RateCon.Code=ICalc.Code)  
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
coalesce(SUM((Case When @P_RateConF=1 Then (Case When RRateCon.Rate is null then RateCon.Rate*(Case When RateCon.Loading<>0 then RateCon.Loading/100 else RCover.Loading end) else RRateCon.Rate/PCalc.RiskNum*(Case When RRateCon.Loading<>0 then RRateCon.Loading/100 else RCover.Loading end) end) Else coalesce(@P_NETRATEDet,RPARTDET.NETRate) end/100*(100-RCover.Discount)/100*ICALC.GROSS/PCALC.GROSS*ICALC.PRORATA *ICALC.TSI*(CASE WHEN RCOVER.PCALC='S' OR RCOVER.PCTLOSS=0 THEN 100 ELSE RCOVER.PCTLOSS END)/(CASE WHEN RCOVER.PCTLOSS=0 THEN 100 ELSE RCOVER.PCTLOSS END+RCOVER.PAddition)*ICALC.PCTADJ/100)*(Case When RPARTDET.COMMN=0 Then 0 else (Case When RCover.NetRateF=1 or @P_ONGROSSNET=2 OR (@P_ONGROSSNET=0 AND (100-@Premium_OutGo)/100*(100-RPARTDET.CommN)/100<(100-RPARTDET.COMM)/100) Then (@Premium_OutGo)/100 else 0 end) end)),0) AS DISC_2,  

coalesce(SUM((CASE WHEN RPARTDET.PPCT<>0 THEN RPARTDET.PPCT/100 ELSE (Case When @P_RateConF=1 and (RRateCon.Rate is not null or RateCon.Rate is not null) then 0 else 1 end) END * ICALC.GROSS*(PCALC.PGROSS*@P_PFactor)/PCALC.POGROSS)*(Case When @P_OnNetPremiumF=1 Then (100-@Premium_Treaty_Discount)/100 else 1 end)*(Case When RPARTDET.COMMN=0 Then 1 else (Case When RCover.NetRateF=1 or @P_ONGROSSNET=2 OR (@P_ONGROSSNET=0 AND (100-@Premium_OutGo)/100*(100-RPARTDET.CommN)/100<(100-RPARTDET.COMM)/100) Then 1 else 1 end) end)*@P_FEE/100-(Case When @P_RITabarruF=0 Then 1 Else 0 end)*(ICALC.GROSS*@P_OPFEE/PCALC.POGROSS)),0) AS FEE_1,              
coalesce(SUM((Case When @P_RateConF=1 Then (Case When RRateCon.Rate is null then RateCon.Rate*(Case When RateCon.Loading<>0 then RateCon.Loading/100 else RCover.Loading end) else RRateCon.Rate/PCalc.RiskNum*(Case When RRateCon.Loading<>0 then RRateCon.Loading/100 else RCover.Loading end) end) Else coalesce(@P_NETRATEDet,RPARTDET.NETRate) end/100*(100-RCover.Discount)/100*ICALC.GROSS/PCALC.GROSS*ICALC.PRORATA *ICALC.TSI*(CASE WHEN RCOVER.PCALC='S' OR RCOVER.PCTLOSS=0 THEN 100 ELSE RCOVER.PCTLOSS END)/(CASE WHEN RCOVER.PCTLOSS=0 THEN 100 ELSE RCOVER.PCTLOSS END+RCOVER.PAddition)*ICALC.PCTADJ/100)*(Case When RPARTDET.COMMN=0 Then 1 else (Case When RCover.NetRateF=1 or @P_ONGROSSNET=2 OR (@P_ONGROSSNET=0 AND (100-@Premium_OutGo)/100*(100-RPARTDET.CommN)/100<(100-RPARTDET.COMM)/100) Then 1 else 1 end) end)*@P_FEE/100-(Case When @P_RITabarruF=0 Then 1 Else 0 end)*(ICALC.GROSS*@P_OPFEE/PCALC.POGROSS)),0) AS FEE_2  

FROM ICALC   
INNER JOIN ACCEPTANCE SACCEPTANCE ON (SACCEPTANCE.ANO=ICALC.SANO)  
INNER JOIN RCOVER ON (RCOVER.ANO=ICALC.SANO AND RCOVER.CODE=ICALC.CODE AND (RCOVER.SDATE=ICALC.SDATE OR (@P_AType='A' AND (CASE WHEN RCOVER.SDATE<SACCEPTANCE.PDATE THEN SACCEPTANCE.PDATE ELSE RCOVER.SDATE END)=ICALC.SDATE)))  
INNER JOIN RPARTDET ON (RPARTDET.RNO=@P_RNO AND RPARTDET.ID=@P_ID AND RPARTDET.TOR=ICALC.TOR AND (RPARTDET.NOFYEARS=0 OR RPARTDET.NOFYEARS=@P_NOFYEARS) and RPARTDET.EXCLUDEF=0)  
LEFT Join FN_RateCon(@P_ANO, @P_CODE,@P_TSI) RateCon On (RateCon.Code=ICalc.Code)  
LEFT Join FN_RRateCon(@P_ANO, @P_RID, @P_TSI) RRateCon On (1=1)              
INNER JOIN ICOVER ON (ICOVER.INO=ICALC.INO AND (ICOVER.ADJUSTABLE=@P_ADJUSTABLEF OR @P_AType='A'))  
INNER JOIN RCALC ON (RCALC.ANO=ICALC.ANO AND RCALC.CURRENCY=ICALC.CURRENCY AND RCALC.CODE=ICALC.CODE AND RCALC.TOR=ICALC.TOR AND RCALC.SDATE=ICALC.SDATE AND RCALC.EDATE=ICALC.EDATE AND RCALC.SANO=ICALC.SANO AND RCALC.EXTREATYF=0)  
INNER JOIN PCALC_ANNUM(@P_ANO) PCALC ON (PCALC.ANO=ICALC.ANO AND PCALC.CODE=ICALC.CODE AND PCALC.SDATE=ICALC.SDATE AND PCALC.EDATE=ICALC.EDATE AND PCALC.INO=ICALC.INO AND PCALC.CURRENCY=ICALC.CURRENCY)  
WHERE ICALC.ANO=@P_ANO AND ICALC.CURRENCY=@P_CCY AND ICALC.SDATE=@P_SDATE AND ICALC.EDATE=@P_EDATE AND ICALC.CODE=@P_CODE              
AND PCALC.GROSS<>0  

) R        

GO

IF EXISTS ( SELECT * FROM   sysobjects WHERE  id = object_id(N'Treaty_Premium_Commission') and OBJECTPROPERTY(id, N'IsProcedure') = 1 )
 BEGIN DROP PROCEDURE Treaty_Premium_Commission
end
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
@P_UjrohReins=R1.UJROHREINS 
from Acceptance A, RarrHeader R, Cover C Left Join ISource I on (I.CNO=C.CNO) Left Join ISourceDet I2 on (I2.CNO=I.CNO and I2.Code=@P_Code), Reinsurance R1, ReClass R3 Left Join ReClassDet R4 ON (R4.RNO=R3.RNO AND R4.TOC=R3.TOC AND R4.CODE=@P_CODE)  
Where C.CNO=A.CNO and R.ANO=A.ANO and A.ANO=@P_ANO and R1.RID=@P_RID and R3.RNO=R1.RNO and R3.TOC=A.TOC  

Select @Premium_Treaty_Discount=dbo.Premium_Treaty_Discount(@P_ANO, @P_Code,@P_Period)          
Select @Premium_Discount=dbo.premium_discount(@P_ANO, @P_Code, @P_Period)  
Select @Premium_Commission=dbo.Premium_Commission_Net(@P_ANO, @P_Code, @P_Period,0)+dbo.Premium_Commission_Net_Vat(@P_ANO, @P_Code, @P_Period,0)  
Select @Premium_Fee=dbo.Premium_Fee(@P_ANO, @P_Period)  
Select @Premium_outGo=@Premium_Discount+@Premium_Commission+@Premium_Commission_Inward+@Premium_Fee

SELECT @P_OPFEE=COALESCE(SUM(FEE),0), @P_RITabarruF=coalesce(cast(Max(cast(RITabarruF as Int)) as Bit),0)
FROM
(
       SELECT
       A2.ANO,
       Case When A1.Amount<>0 Then
             A1.Amount*100/coalesce(R.PCTSHARE-R.MSHARE,100)*Case When A1.RITabarruF=1 Then cast(100 as Float)/@P_Tabarru Else 1 end
       Else
             (
                    Select 
                    sum(D1.Gross*P.Gross/P.OGross)
                    from Display_Calculation(A2.ANO) D1, Acceptance A, PCalc P, RARRHEADER R
                    Where P.ANO=A.ANO and P.Currency=D1.Currency and A.ANO=D1.ANO and R.ANO=A.ANO and D1.Currency=@P_CCY
             )*A1.AmountPCT/100*Case When A1.RITabarruF=1 Then cast(100 as Float)/@P_Tabarru Else 1 end
       End    as FEE,
	   A1.RITabarruF 
       from 
       Acceptance A2
       INNER JOIN AccFD A1 on (A1.ANO=A2.ANO and A1.Currency=@P_CCY and A1.ContributionF=1 and A1.AmountPCTBased=0 And (A1.PolicyYear=0 or A1.PolicyYear=@P_Period))
       INNER JOIN FDTAB on (FDTAB.FDID=A1.FDID and Left(FDTAB.FDType,1)='O')
       INNER Join PCalc on (PCalc.ANO=A2.ANO and PCalc.Currency=A1.Currency)
       INNER JOIN RARRHEADER R ON (R.ANO=A2.ANO)
       Where @P_RType in ('Q','S1','S2','S3') and A2.OANO=@P_OANO and A2.ANO<=@P_ANO  
	   and A2.ANO>(Select coalesce(Max(ANO),0) from Acceptance Where AType='C' and EMethod='A' and Acceptance.OANO=@P_OANO and Acceptance.ANO<=@P_ANO and AStatus not in ('W','T'))

	   Union All

	   --Op Fee from Master Policy
       SELECT
       A2.ANO,
       Case When A1.Amount<>0 Then
			--Not Yet for Master Policy
			0
       Else
             (
                    Select 
                    sum(D1.Gross*P.Gross/P.OGross)
                    from Display_Calculation(A2.ANO) D1, Acceptance A, PCalc P, RARRHEADER R
                    Where P.ANO=A.ANO and P.Currency=D1.Currency and A.ANO=D1.ANO and R.ANO=A.ANO and D1.Currency=@P_CCY
             )*A1.AmountPCT/100*Case When A1.RITabarruF=1 Then cast(100 as Float)/@P_Tabarru Else 1 end
       End    as FEE,	   
	   A1.RITabarruF 
       from 
       Acceptance A2
	   INNER JOIN Acceptance MA on (MA.RegNo=A2.RegNo and MA.ANO=MA.LANO)
	   INNER JOIN COVER C on (C.CNO=MA.CNO and C.OPENFLAG=0)
       INNER JOIN AccFD A1 on (A1.ANO=MA.ANO and A1.Currency=@P_CCY and A1.ContributionF=1 and A1.AmountPCTBased=0 And (A1.PolicyYear=0 or A1.PolicyYear=@P_Period))
       INNER JOIN FDTAB on (FDTAB.FDID=A1.FDID and Left(FDTAB.FDType,1)='O')
       INNER Join PCalc on (PCalc.ANO=A2.ANO and PCalc.Currency=A1.Currency)
       INNER JOIN RARRHEADER R ON (R.ANO=A2.ANO)
       Where @P_RType in ('Q','S1','S2','S3') and A2.OANO=@P_OANO and A2.ANO<=@P_ANO  
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
coalesce(SUM((Case When @P_RateConF=1 Then (Case When RRateCon.Rate is null then RateCon.Rate*(Case When RateCon.Loading<>0 then RateCon.Loading/100 else RCover.Loading end) else RRateCon.Rate/PCalc.RiskNum*(Case When RRateCon.Loading<>0 then RRateCon.Loading/100 else RCover.Loading end) end) Else coalesce(@P_NETRATEDet,RPart.NetRate/PCalc.RiskNum) end/100*(100-RCover.Discount)/100*ICALC.GROSS/PCALC.GROSS*ICALC.PRORATA *ICALC.TSI*(CASE WHEN RCOVER.PCALC='S' OR RCOVER.PCTLOSS=0 THEN 100 ELSE RCOVER.PCTLOSS END)/(CASE WHEN RCOVER.PCTLOSS=0 THEN 100 ELSE RCOVER.PCTLOSS END+RCOVER.PAddition)*ICALC.PCTADJ/100)*(Case When (CASE WHEN @P_COMMN<>0 Then @P_COMMN ELSE RPART.COMMN END)=0 Then 0 else (Case When RCover.NetRateF=1 or @P_ONGROSSNET=2 OR (@P_ONGROSSNET=0 AND (100-(@Premium_outGo-(Case When RPart.OnNetPremiumF=1 Then @Premium_Treaty_Discount else 0 end)))/100*(100-(CASE WHEN @P_COMMN<>0 Then @P_COMMN ELSE RPART.COMMN END))/100<(100-(CASE WHEN @P_COMM<>0 Then @P_COMM ELSE RPART.COMM END))/100) Then ((@Premium_outGo-(Case When RPart.OnNetPremiumF=1 Then @Premium_Treaty_Discount else 0 end)))/100 else 0 end) end)*RPart.share/100*PCalc.Rate),0) AS DISC_2,  

coalesce(SUM((CASE WHEN RPart.PPCT<>0 THEN RPart.PPCT/100 ELSE (Case When @P_RateConF=1 and (RRateCon.Rate is not null or RateCon.Rate is not null) then 0 else 1 end) END * ICALC.GROSS*(PCALC.PGROSS*@P_PFactor)/PCALC.POGROSS*(Case When RPart.OnNetPremiumF=1 Then (100-@Premium_Treaty_Discount)/100 else 1 end))*(Case When (CASE WHEN @P_COMMN<>0 Then @P_COMMN ELSE RPART.COMMN END)=0 Then 1 else (Case When RCover.NetRateF=1 or @P_ONGROSSNET=2 OR (@P_ONGROSSNET=0 AND (100-(@Premium_outGo-(Case When RPart.OnNetPremiumF=1 Then @Premium_Treaty_Discount else 0 end)))/100*(100-(CASE WHEN @P_COMMN<>0 Then @P_COMMN ELSE RPART.COMMN END))/100<(100-(CASE WHEN @P_COMM<>0 Then @P_COMM ELSE RPART.COMM END))/100) Then 1 else 1 end) end)*RPart.Fee/100*RPart.share/100*PCalc.Rate-(Case When @P_RITabarruF=0 Then 1 Else 0 end)*(ICALC.GROSS*@P_OPFEE/PCALC.POGROSS)*RPart.share/100*PCalc.Rate),0) AS FEE_1,            
coalesce(SUM((Case When @P_RateConF=1 Then (Case When RRateCon.Rate is null then RateCon.Rate*(Case When RateCon.Loading<>0 then RateCon.Loading/100 else RCover.Loading end) else RRateCon.Rate/PCalc.RiskNum*(Case When RRateCon.Loading<>0 then RRateCon.Loading/100 else RCover.Loading end) end) Else coalesce(@P_NETRATEDet,RPart.NetRate/PCalc.RiskNum) end/100*(100-RCover.Discount)/100*ICALC.GROSS/PCALC.GROSS*ICALC.PRORATA *ICALC.TSI*(CASE WHEN RCOVER.PCALC='S' OR RCOVER.PCTLOSS=0 THEN 100 ELSE RCOVER.PCTLOSS END)/(CASE WHEN RCOVER.PCTLOSS=0 THEN 100 ELSE RCOVER.PCTLOSS END+RCOVER.PAddition)*ICALC.PCTADJ/100)*(Case When (CASE WHEN @P_COMMN<>0 Then @P_COMMN ELSE RPART.COMMN END)=0 Then 1 else (Case When RCover.NetRateF=1 or @P_ONGROSSNET=2 OR (@P_ONGROSSNET=0 AND (100-(@Premium_outGo-(Case When RPart.OnNetPremiumF=1 Then @Premium_Treaty_Discount else 0 end)))/100*(100-(CASE WHEN @P_COMMN<>0 Then @P_COMMN ELSE RPART.COMMN END))/100<(100-(CASE WHEN @P_COMM<>0 Then @P_COMM ELSE RPART.COMM END))/100) Then 1 else 1 end) end)*RPart.Fee/100*RPart.share/100*PCalc.Rate-(Case When @P_RITabarruF=0 Then 1 Else 0 end)*(ICALC.GROSS*@P_OPFEE/PCALC.POGROSS)*RPart.share/100*PCalc.Rate),0) AS FEE_2
              
FROM ICALC   
INNER JOIN ACCEPTANCE SACCEPTANCE ON (SACCEPTANCE.ANO=ICALC.SANO)  
INNER JOIN RCOVER ON (RCOVER.ANO=ICALC.SANO AND RCOVER.CODE=ICALC.CODE AND (RCOVER.SDATE=ICALC.SDATE OR (@P_AType='A' AND (CASE WHEN RCOVER.SDATE<SACCEPTANCE.PDATE THEN SACCEPTANCE.PDATE ELSE RCOVER.SDATE END)=ICALC.SDATE)))  
INNER JOIN REINSURANCE ON (REINSURANCE.RID=@P_RID)
INNER JOIN RPART ON (RPART.RNO=REINSURANCE.RNO)
LEFT JOIN RPARTDET ON (RPARTDET.RNO=@P_RNO AND RPARTDET.ID=RPART.ID AND RPARTDET.TOR=ICALC.TOR)  
LEFT Join FN_RateCon(@P_ANO, @P_CODE,@P_TSI) RateCon On (RateCon.Code=ICalc.Code)  
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
coalesce(SUM((Case When @P_RateConF=1 Then (Case When RRateCon.Rate is null then RateCon.Rate*(Case When RateCon.Loading<>0 then RateCon.Loading/100 else RCover.Loading end) else RRateCon.Rate/PCalc.RiskNum*(Case When RRateCon.Loading<>0 then RRateCon.Loading/100 else RCover.Loading end) end) Else coalesce(@P_NETRATEDet,RPARTDET.NETRate) end/100*(100-RCover.Discount)/100*ICALC.GROSS/PCALC.GROSS*ICALC.PRORATA *ICALC.TSI*(CASE WHEN RCOVER.PCALC='S' OR RCOVER.PCTLOSS=0 THEN 100 ELSE RCOVER.PCTLOSS END)/(CASE WHEN RCOVER.PCTLOSS=0 THEN 100 ELSE RCOVER.PCTLOSS END+RCOVER.PAddition)*ICALC.PCTADJ/100)*(Case When RPARTDET.COMMN=0 Then 0 else (Case When RCover.NetRateF=1 or @P_ONGROSSNET=2 OR (@P_ONGROSSNET=0 AND (100-(@Premium_outGo-(Case When RPart.OnNetPremiumF=1 Then @Premium_Treaty_Discount else 0 end)))/100*(100-RPARTDET.CommN)/100<(100-RPARTDET.COMM)/100) Then ((@Premium_outGo-(Case When RPart.OnNetPremiumF=1 Then @Premium_Treaty_Discount else 0 end)))/100 else 0 end) end)*RPart.share/100*PCalc.Rate),0) AS DISC_2,  

coalesce(SUM((CASE WHEN RPARTDET.PPCT<>0 THEN RPARTDET.PPCT/100 ELSE (Case When @P_RateConF=1 and (RRateCon.Rate is not null or RateCon.Rate is not null) then 0 else 1 end) END * ICALC.GROSS*(PCALC.PGROSS*@P_PFactor)/PCALC.POGROSS)*(Case When RPart.OnNetPremiumF=1 Then (100-@Premium_Treaty_Discount)/100 else 1 end)*(Case When RPARTDET.COMMN=0 Then 1 else (Case When RCover.NetRateF=1 or @P_ONGROSSNET=2 OR (@P_ONGROSSNET=0 AND (100-(@Premium_outGo-(Case When RPart.OnNetPremiumF=1 Then @Premium_Treaty_Discount else 0 end)))/100*(100-RPARTDET.CommN)/100<(100-RPARTDET.COMM)/100) Then 1 else 1 end) end)*RPart.Fee/100*RPart.share/100*PCalc.Rate-(Case When @P_RITabarruF=0 Then 1 Else 0 end)*(ICALC.GROSS*@P_OPFEE/PCALC.POGROSS)*RPart.share/100*PCalc.Rate),0) AS FEE_1,              
coalesce(SUM((Case When @P_RateConF=1 Then (Case When RRateCon.Rate is null then RateCon.Rate*(Case When RateCon.Loading<>0 then RateCon.Loading/100 else RCover.Loading end) else RRateCon.Rate/PCalc.RiskNum*(Case When RRateCon.Loading<>0 then RRateCon.Loading/100 else RCover.Loading end) end) Else coalesce(@P_NETRATEDet,RPARTDET.NETRate) end/100*(100-RCover.Discount)/100*ICALC.GROSS/PCALC.GROSS*ICALC.PRORATA *ICALC.TSI*(CASE WHEN RCOVER.PCALC='S' OR RCOVER.PCTLOSS=0 THEN 100 ELSE RCOVER.PCTLOSS END)/(CASE WHEN RCOVER.PCTLOSS=0 THEN 100 ELSE RCOVER.PCTLOSS END+RCOVER.PAddition)*ICALC.PCTADJ/100)*(Case When RPARTDET.COMMN=0 Then 1 else (Case When RCover.NetRateF=1 or @P_ONGROSSNET=2 OR (@P_ONGROSSNET=0 AND (100-(@Premium_outGo-(Case When RPart.OnNetPremiumF=1 Then @Premium_Treaty_Discount else 0 end)))/100*(100-RPARTDET.CommN)/100<(100-RPARTDET.COMM)/100) Then 1 else 1 end) end)*RPart.Fee/100*RPart.share/100*PCalc.Rate-(Case When @P_RITabarruF=0 Then 1 Else 0 end)*(ICALC.GROSS*@P_OPFEE/PCALC.POGROSS)*RPart.share/100*PCalc.Rate),0) AS FEE_2
FROM ICALC   
INNER JOIN ACCEPTANCE SACCEPTANCE ON (SACCEPTANCE.ANO=ICALC.SANO)  
INNER JOIN RCOVER ON (RCOVER.ANO=ICALC.SANO AND RCOVER.CODE=ICALC.CODE AND (RCOVER.SDATE=ICALC.SDATE OR (@P_AType='A' AND (CASE WHEN RCOVER.SDATE<SACCEPTANCE.PDATE THEN SACCEPTANCE.PDATE ELSE RCOVER.SDATE END)=ICALC.SDATE)))  
INNER JOIN REINSURANCE ON (REINSURANCE.RID=@P_RID)
INNER JOIN RPART ON (RPART.RNO=REINSURANCE.RNO)
INNER JOIN RPARTDET ON (RPARTDET.RNO=@P_RNO AND RPARTDET.ID=RPART.ID AND RPARTDET.TOR=ICALC.TOR AND (RPARTDET.NOFYEARS=0 OR RPARTDET.NOFYEARS=@P_NOFYEARS) and RPARTDET.EXCLUDEF=0)  
LEFT Join FN_RateCon(@P_ANO, @P_CODE,@P_TSI) RateCon On (RateCon.Code=ICalc.Code)  
LEFT Join FN_RRateCon(@P_ANO, @P_RID, @P_TSI) RRateCon On (1=1)              
INNER JOIN ICOVER ON (ICOVER.INO=ICALC.INO AND (ICOVER.ADJUSTABLE=@P_ADJUSTABLEF OR @P_AType='A'))  
INNER JOIN RCALC ON (RCALC.ANO=ICALC.ANO AND RCALC.CURRENCY=ICALC.CURRENCY AND RCALC.CODE=ICALC.CODE AND RCALC.TOR=ICALC.TOR AND RCALC.SDATE=ICALC.SDATE AND RCALC.EDATE=ICALC.EDATE AND RCALC.SANO=ICALC.SANO AND RCALC.EXTREATYF=0)  
INNER JOIN PCALC_ANNUM(@P_ANO) PCALC ON (PCALC.ANO=ICALC.ANO AND PCALC.CODE=ICALC.CODE AND PCALC.SDATE=ICALC.SDATE AND PCALC.EDATE=ICALC.EDATE AND PCALC.INO=ICALC.INO AND PCALC.CURRENCY=ICALC.CURRENCY)  
WHERE ICALC.ANO=@P_ANO AND ICALC.CURRENCY=@P_CCY AND ICALC.SDATE=@P_SDATE AND ICALC.EDATE=@P_EDATE AND ICALC.CODE=@P_CODE              
AND PCALC.GROSS<>0  
Group By RPart.ID


) R        



GO


if exists (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'fn_Age') AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) ) 
BEGIN DROP FUNCTION fn_Age
end
GO
CREATE Function fn_Age(@sBirthDate varchar(100),@ComparisonDate as Date, @AgeMethod as int)        
RETURNS Float AS          
BEGIN        
declare @BirthDate as Date
declare @temp as FLoat
set @temp=0          
if isdate(@sBirthDate)=1 
	set @BirthDate=cast(@sBirthDate as Date)
else
	set @BirthDate=@ComparisonDate
        
if @comparisondate<=@BirthDate          
      set @temp=0          
else          
begin          
 set @temp=datediff(year,@BirthDate,@ComparisonDate)       
  if @AgeMethod=4  -- Nearest Birth Date by Month-Day    
  begin              
      if DateAdd(year,@Temp,@BirthDate)>@ComparisonDate      
            set @Temp=@Temp-1      
      if DateDiff(Month,Dateadd(Year,@Temp,@BirthDate),@ComparisonDate) = DateDiff(Month,@ComparisonDate, Dateadd(Year,@Temp+1,@BirthDate))      
      Begin  
  if DateAdd(Month, DateDiff(Month,Dateadd(Year,@Temp,@BirthDate),@ComparisonDate),Dateadd(Year,@Temp,@BirthDate))<@ComparisonDate  
   set @Temp=@Temp+1            
   End  
      else   
      Begin  
  if DateDiff(Month,Dateadd(Year,@Temp,@BirthDate),@ComparisonDate) > DateDiff(Month,@ComparisonDate, Dateadd(Year,@Temp+1,@BirthDate))      
            set @Temp=@Temp+1       
      End  
  end      
  else  
  if @AgeMethod=3 --Next Birth Day      
  begin              
      if DateAdd(year,@Temp,@BirthDate)>@ComparisonDate      
            set @Temp=@Temp-1      
      if DateDiff(day,Dateadd(Year,@Temp,@BirthDate),@ComparisonDate) > 0      
            set @Temp=@Temp+1          
  end        
  else       
  if @AgeMethod=2  -- Nearest Birth Date by Day    
  begin            
      if DateAdd(year,@Temp,@BirthDate)>@ComparisonDate    
            set @Temp=@Temp-1    
      if DateDiff(day,Dateadd(Year,@Temp,@BirthDate),@ComparisonDate) > DateDiff(day,@ComparisonDate, Dateadd(Year,@Temp+1,@BirthDate))    
            set @Temp=@Temp+1        
  end        
  else        
  if @AgeMethod=1 -- Nearest Birth Date by Month      
  begin        
      if DateAdd(year,@Temp,@BirthDate)>@ComparisonDate      
            set @Temp=@Temp-1      
      if DateDiff(Month,Dateadd(Year,@Temp,@BirthDate),@ComparisonDate) > DateDiff(Month,@ComparisonDate, Dateadd(Year,@Temp+1,@BirthDate))      
            set @Temp=@Temp+1       
  end            
  else   -- Year Lapse      
  begin         
      if @temp>0          
       if month(@ComparisonDate)< month(@BirthDate) or (month(@BirthDate)=month(@ComparisonDate) and day(@ComparisonDate)<day(@BirthDate))          
        set @temp=@temp-1            
  end      
end        
        
return @temp      
End

GO

IF EXISTS ( SELECT * FROM   sysobjects WHERE  id = object_id(N'QMasterAcceptance') and OBJECTPROPERTY(id, N'IsProcedure') = 1 )
BEGIN DROP PROCEDURE QMasterAcceptance 
end
GO
CREATE PROCEDURE QMasterAcceptance (@P_ANO as integer)        
AS        
SELECT Acceptance.PolicyNo, Acceptance.CertificateNo, Acceptance.Branch, Acceptance.REGNO, Acceptance.ADATE, Acceptance.SDate, Acceptance.EDate, Acceptance.UserID, Acceptance.LUSERID, 
SysTab.Currency AS CCY, 
QPCalc.TSI,        
QPCalc.OurShare, 
QPCalc.Amount, 
QPCalc.Gross, 
QPCalc.Premium,  
Year(Acceptance.SDate) as RYear, 
Acceptance.ATYPE, Acceptance.ASTATUS, Acceptance.LANO, Acceptance.ANO, Acceptance.CNO,        
Cover.ASource, Cover.PPeriod, Cover.CSTATUS, Cover.CoverNoteF, Cover.Voyage, Cover.OpenFlag, Acceptance.AdjustableF, Acceptance.RenewableF, Cover.ISType, Cover.PolicyType, Acceptance.TOC, Cover.MO, Acceptance.BANO,  Acceptance.RANO, Acceptance.RequestF, Acceptance.RequestName,  
ACCCOMPSHEETH.CID, acceptance.CANO , acceptance.ConjunctionF, pAcceptance.AType as pAType        
FROM Acceptance 
Left Join Acceptance pAcceptance on (pAcceptance.ANO=Acceptance.pANO) 
Left Join ACCCOMPSHEETH on (ACCCOMPSHEETH.ANO=Acceptance.OANO), FN_PCalc(@P_ANO) AS QPCalc, SysTab, Cover        
WHERE Acceptance.ANO=@P_ANO And Acceptance.CNO=Cover.CNO And QPCalc.ANO=Acceptance.ANO        

GO

if exists (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'FN_PCalc') AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) )
 BEGIN DROP FUNCTION FN_PCalc
end
GO
Create FUNCTION FN_PCalc (@P_ANO as integer)            
RETURNS Table            
AS RETURN (            
SELECT  Acceptance.ANO,            
 Count(PCalc.Currency) AS NUMCCY,          
 MAX(PCALC.RATE) AS RATE,          
 MAX(CASE When Acceptance.QTY=0 Then 1 Else Acceptance.QTY end) as NumRisk,
 sum(PCalc.TSI*PCalc.Rate*Case When Acceptance.QTY=0 Then 1 Else Acceptance.QTY end) AS TSI,            
 sum(PCalc.OurShare*PCalc.Rate*Case When Acceptance.QTY=0 Then 1 Else Acceptance.QTY end) AS OurShare,            
 sum(PCalc.Amount*PCalc.Rate*Case When Acceptance.QTY=0 Then 1 Else Acceptance.QTY end) AS Amount,            
 sum(PCalc.Gross*PCalc.Rate*Case When Acceptance.QTY=0 Then 1 Else Acceptance.QTY end) AS Gross,            
 sum(PCalc.Claim*PCalc.Rate*Case When Acceptance.QTY=0 Then 1 Else Acceptance.QTY end) AS Claim,            
 sum(case when PCalc.TSI=0 then 0 else PCalc.OurShare*PCalc.Rate*Case When Acceptance.QTY=0 Then 1 Else Acceptance.QTY end end)/            
 sum(case when PCalc.TSI=0 then 1 else PCalc.TSI*PCalc.Rate*Case When Acceptance.QTY=0 Then 1 Else Acceptance.QTY end end)*            
 sum(PCalc.Gross*PCalc.Rate*Case When Acceptance.QTY=0 Then 1 Else Acceptance.QTY end) as Premium,            
 MAX(CASE WHEN PCALC.TSI<>0 AND COALESCE(ISOURCE.LIMIT,0)<>0 THEN PCALC.OURSHARE/PCALC.TSI*100 ELSE COALESCE(ISOURCE.SHARE,100) END) as PCTSHARE, 
 MAX(RARRHEADER.MSHARE) as MSHARE
FROM  Acceptance with(NOLOCK)       
LEFT JOIN Pcalc with(NOLOCK) ON (Acceptance.ANO=PCalc.ANO and Acceptance.PStatus='C')       
LEFT JOIN RArrHeader with(NOLOCK) On (RArrHeader.ANO=Acceptance.ANO)      
LEFT JOIN ISOURCE with (NOLOCK) ON (ISOURCE.CNO=ACCEPTANCE.CNO)            
Where Acceptance.ANO=@P_ANO            
GROUP BY Acceptance.ANO            
)            


GO

IF EXISTS ( SELECT * FROM   sysobjects WHERE  id = object_id(N'List_By_Ano') and OBJECTPROPERTY(id, N'IsProcedure') = 1 )
 BEGIN DROP PROCEDURE List_By_Ano
end
GO

CREATE PROCEDURE List_By_Ano (@P_ANO as integer) 
AS
SELECT Cast(0 as bit) as ProcessFlag,	
	Cover.COVERNO, 
	Cast(Acceptance.AName as varchar(128)) as Insured,
	Cover.CNO, 
	Cover.CStatus, 
	Acceptance.lANO, 
	Acceptance.ANO, 
	Acceptance.REGNO, 
	Acceptance.ADATE, 
	Acceptance.LUSERID as USERID, 
	SysTab.Currency, 
	QPCalc.TSI, 
	QPCalc.OurShare, 
	QPCalc.Gross, 
	Year(Acceptance.SDate) as RYear,
	Acceptance.ASTATUS, 
	Acceptance.ATYPE, 
	Acceptance.SDate, 
	Acceptance.EDate, 
	Cover.ISType, 
	Acceptance.Renewal, 
	Acceptance.ESeqNo, 
	Acceptance.PolicyNo, 
	Acceptance.CertificateNo
FROM 	Acceptance, Cover, SysTab, FN_PCALC(@P_ANO) AS QPCalc
WHERE 	Cover.CNO=Acceptance.CNO 
	And QPCalc.ANO=Acceptance.ANO 
	And (Acceptance.ANO=Acceptance.LANO Or Acceptance.LANO=-1) 
	And Acceptance.ANO=@P_ANO

GO

if exists (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'fn_toval') AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) )
 BEGIN DROP FUNCTION fn_toval
end
GO
CREATE Function fn_toval(@sValue varchar(255))        
RETURNS Float AS          
BEGIN        
declare @temp as FLoat
set @temp=0          
if isNumeric(@sValue)=1 
	set @temp=cast(@svalue as Float)
else
    set @temp=0          
        
return @temp      
End
GO

if exists (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'Get_RateLoading') AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) ) 
BEGIN DROP FUNCTION Get_RateLoading
end
GO
CREATE Function Get_RateLoading(@P_ANO as int,@P_Code as varchar(20), @P_PDate as datetime, @P_TSI as Float) 
RETURNS @RateCon TABLE (Loading Float, HoldF bit, HoldMessage varchar(512))   
AS     
BEGIN       
Declare @RateTab Table (
Code varchar(10),
SPeriod Int,
SDate smalldatetime, 
EDate smalldatetime,
ValueID1 varchar(15),
ValueID2 varchar(15),
ValueID3 varchar(15),
ValueID4 varchar(15),
ValueID5 varchar(15),
ValueID6 varchar(15),
ValueID7 varchar(15),
ValueID8 varchar(15),
ValueID9 varchar(15),
ValueID10 varchar(15),
ValueID11 varchar(15),
ValueID12 varchar(15),
ValueID13 varchar(15),
ValueID14 varchar(15),
ValueID15 varchar(15)
)

insert into @RateTab
SELECT Top 1 
RateTab.Code, 
RateTab.SPeriod,
Acceptance.Sdate,
Acceptance.EDate,
G1.ValueID as ValueID1,
G2.ValueID as ValueID2,
G3.ValueID as ValueID3,
G4.ValueID as ValueID4,
G5.ValueID as ValueID5,
G6.ValueID as ValueID6,
G7.ValueID as ValueID7,
G8.ValueID as ValueID8,
G9.ValueID as ValueID9,
G10.ValueID as ValueID10,
G11.ValueID as ValueID11,
G12.ValueID as ValueID12,
G13.ValueID as ValueID13,
G14.ValueID as ValueID14,
G15.ValueID as ValueID15

From Acceptance
 INNER JOIN AINFO on (AINFO.ANO=ACCEPTANCE.ANO)
 INNER JOIN RateTab ON (RateTab.Code=@P_Code)     
 Left Join GenHTab H1 on (H1.FLDID=AInfo.FLDID1)
 Left Join GenHTab H2 on (H2.FLDID=AInfo.FLDID2)
 Left Join GenHTab H3 on (H3.FLDID=AInfo.FLDID3)
 Left Join GenHTab H4 on (H4.FLDID=AInfo.FLDID4)
 Left Join GenHTab H5 on (H5.FLDID=AInfo.FLDID5)
 Left Join GenHTab H6 on (H6.FLDID=AInfo.FLDID6)
 Left Join GenHTab H7 on (H7.FLDID=AInfo.FLDID7)
 Left Join GenHTab H8 on (H8.FLDID=AInfo.FLDID8)
 Left Join GenHTab H9 on (H9.FLDID=AInfo.FLDID9)
 Left Join GenHTab H10 on (H10.FLDID=AInfo.FLDID10)
 Left Join GenHTab H11 on (H11.FLDID=AInfo.FLDID11)
 Left Join GenHTab H12 on (H12.FLDID=AInfo.FLDID12)
 Left Join GenHTab H13 on (H13.FLDID=AInfo.FLDID13)
 Left Join GenHTab H14 on (H14.FLDID=AInfo.FLDID14)
 Left Join GenHTab H15 on (H15.FLDID=AInfo.FLDID15)           
 Left Join GenDTab G1 on (G1.FLDID=AInfo.FLDID1 and ((G1.Formula='AGE' and dbo.fn_Age(AInfo.ValueDesc1,@P_PDate, H1.AGEMETHOD) Between dbo.fn_toval(G1.FLower) and dbo.fn_toval(G1.FUpper)) or (G1.Formula<>'AGE' and G1.ValueID=AInfo.ValueID1)))            
 Left Join GenDTab G2 on (G2.FLDID=AInfo.FLDID2 and ((G2.Formula='AGE' and dbo.fn_Age(AInfo.ValueDesc2,@P_PDate, H2.AGEMETHOD) Between dbo.fn_toval(G2.FLower) and dbo.fn_toval(G2.FUpper)) or (G2.Formula<>'AGE' and G2.ValueID=AInfo.ValueID2)))             
 Left Join GenDTab G3 on (G3.FLDID=AInfo.FLDID3 and ((G3.Formula='AGE' and dbo.fn_Age(AInfo.ValueDesc3,@P_PDate, H3.AGEMETHOD) Between dbo.fn_toval(G3.FLower) and dbo.fn_toval(G3.FUpper)) or (G3.Formula<>'AGE' and G3.ValueID=AInfo.ValueID3)))          
 Left Join GenDTab G4 on (G4.FLDID=AInfo.FLDID4 and ((G4.Formula='AGE' and dbo.fn_Age(AInfo.ValueDesc4,@P_PDate, H4.AGEMETHOD) Between dbo.fn_toval(G4.FLower) and dbo.fn_toval(G4.FUpper)) or (G4.Formula<>'AGE' and G4.ValueID=AInfo.ValueID4)))          
 Left Join GenDTab G5 on (G5.FLDID=AInfo.FLDID5 and ((G5.Formula='AGE' and dbo.fn_Age(AInfo.ValueDesc5,@P_PDate, H5.AGEMETHOD) Between dbo.fn_toval(G5.FLower) and dbo.fn_toval(G5.FUpper)) or (G5.Formula<>'AGE' and G5.ValueID=AInfo.ValueID5)))          
 Left Join GenDTab G6 on (G6.FLDID=AInfo.FLDID6 and ((G6.Formula='AGE' and dbo.fn_Age(AInfo.ValueDesc6,@P_PDate, H6.AGEMETHOD) Between dbo.fn_toval(G6.FLower) and dbo.fn_toval(G6.FUpper)) or (G6.Formula<>'AGE' and G6.ValueID=AInfo.ValueID6)))          
 Left Join GenDTab G7 on (G7.FLDID=AInfo.FLDID7 and ((G7.Formula='AGE' and dbo.fn_Age(AInfo.ValueDesc7,@P_PDate, H7.AGEMETHOD) Between dbo.fn_toval(G7.FLower) and dbo.fn_toval(G7.FUpper)) or (G7.Formula<>'AGE' and G7.ValueID=AInfo.ValueID7)))          
 Left Join GenDTab G8 on (G8.FLDID=AInfo.FLDID8 and ((G8.Formula='AGE' and dbo.fn_Age(AInfo.ValueDesc8,@P_PDate, H8.AGEMETHOD) Between dbo.fn_toval(G8.FLower) and dbo.fn_toval(G8.FUpper)) or (G8.Formula<>'AGE' and G8.ValueID=AInfo.ValueID8)))          
 Left Join GenDTab G9 on (G9.FLDID=AInfo.FLDID9 and ((G9.Formula='AGE' and dbo.fn_Age(AInfo.ValueDesc9,@P_PDate, H9.AGEMETHOD) Between dbo.fn_toval(G9.FLower) and dbo.fn_toval(G9.FUpper)) or (G9.Formula<>'AGE' and G9.ValueID=AInfo.ValueID9)))          
 Left Join GenDTab G10 on (G10.FLDID=AInfo.FLDID10 and ((G10.Formula='AGE' and dbo.fn_Age(AInfo.ValueDesc10,@P_PDate, H10.AGEMETHOD) Between dbo.fn_toval(G10.FLower) and dbo.fn_toval(G10.FUpper)) or (G10.Formula<>'AGE' and G10.ValueID=AInfo.ValueID10)))          
 Left Join GenDTab G11 on (G11.FLDID=AInfo.FLDID11 and ((G11.Formula='AGE' and dbo.fn_Age(AInfo.ValueDesc11,@P_PDate, H11.AGEMETHOD) Between dbo.fn_toval(G11.FLower) and dbo.fn_toval(G11.FUpper)) or (G11.Formula<>'AGE' and G11.ValueID=AInfo.ValueID11)))          
 Left Join GenDTab G12 on (G12.FLDID=AInfo.FLDID12 and ((G12.Formula='AGE' and dbo.fn_Age(AInfo.ValueDesc12,@P_PDate, H12.AGEMETHOD) Between dbo.fn_toval(G12.FLower) and dbo.fn_toval(G12.FUpper)) or (G12.Formula<>'AGE' and G12.ValueID=AInfo.ValueID12)))          
 Left Join GenDTab G13 on (G13.FLDID=AInfo.FLDID13 and ((G13.Formula='AGE' and dbo.fn_Age(AInfo.ValueDesc13,@P_PDate, H13.AGEMETHOD) Between dbo.fn_toval(G13.FLower) and dbo.fn_toval(G13.FUpper)) or (G13.Formula<>'AGE' and G13.ValueID=AInfo.ValueID13)))          
 Left Join GenDTab G14 on (G14.FLDID=AInfo.FLDID14 and ((G14.Formula='AGE' and dbo.fn_Age(AInfo.ValueDesc14,@P_PDate, H14.AGEMETHOD) Between dbo.fn_toval(G14.FLower) and dbo.fn_toval(G14.FUpper)) or (G14.Formula<>'AGE' and G14.ValueID=AInfo.ValueID14)))          
 Left Join GenDTab G15 on (G15.FLDID=AInfo.FLDID15 and ((G15.Formula='AGE' and dbo.fn_Age(AInfo.ValueDesc15,@P_PDate, H15.AGEMETHOD) Between dbo.fn_toval(G15.FLower) and dbo.fn_toval(G15.FUpper)) or (G15.Formula<>'AGE' and G15.ValueID=AInfo.ValueID15)))          
WHERE ACCEPTANCE.ANO=@P_ANO                       
Order by RateTab.Effective Desc

Declare @Loading as Float
Declare @HoldF as Bit
Declare @HoldMessage as varchar(512)

Declare @Temp_Loading as Float
Declare @Temp_HoldF as Bit
Declare @Temp_HoldMessage as varchar(512)


Select @Loading=1
Select @HoldF=0
Select @HoldMessage=''

--Rate Loading #1
Select @Temp_Loading=Null
Select @Temp_HoldF=Null
Select @Temp_HoldMessage=Null

SELECT Top 1 @Temp_Loading=RateCon.Loading, @Temp_HoldF=RateCon.HoldF, @Temp_HoldMessage=RateCon.HoldMessage
From @RateTab RateTab
INNER JOIN RateCon_M1 RateCon  on (
RateCon.Code=RateTab.Code and RateCon.AllowedF=1
And ((Case When @P_TSI=0 Then 1 Else @P_TSI End)>=RateCon.MinTSI or RateCon.MinTSI=0) 
and ((Case When @P_TSI=0 Then 1 Else @P_TSI End)<=RateCon.MaxTSI or RateCon.MaxTSI=0)     
And (
	 (RateTab.SPeriod=0 and (    
	 (datediff(month, RateTab.sdate, RateTab.edate)>=RateCon.MinPeriod)     
	 or (datediff(month, RateTab.sdate, RateTab.edate)=RateCon.MinPeriod-1 and day(RateTab.sdate)<day(RateTab.edate))     
	 or RateCon.MinPeriod=0)                               
	 And (    
	 (datediff(month, RateTab.sdate, RateTab.edate)<RateCon.MaxPeriod)     
	 or (datediff(month, RateTab.sdate, RateTab.edate)=RateCon.MaxPeriod and day(RateTab.sdate)>=day(RateTab.edate))     
	 or RateCon.MaxPeriod=0)) OR
	(RateTab.SPeriod=1 
	 and ((datediff(day, RateTab.sdate, RateTab.edate)>=RateCon.MinPeriod) or RateCon.MinPeriod=0)
	 And ((datediff(day, RateTab.sdate, RateTab.edate)<=RateCon.MaxPeriod) or RateCon.MaxPeriod=0))
	 )     
and (coalesce(RateCon.ValueID1,'')='' or RateTab.ValueID1 =RateCon.ValueID1)                
And (coalesce(RateCon.ValueID2,'')='' or RateTab.ValueID2 =RateCon.ValueID2)                
And (coalesce(RateCon.ValueID3,'')='' or RateTab.ValueID3 =RateCon.ValueID3)                
And (coalesce(RateCon.ValueID4,'')='' or RateTab.ValueID4 =RateCon.ValueID4)                
And (coalesce(RateCon.ValueID5,'')='' or RateTab.ValueID5 =RateCon.ValueID5)                
And (coalesce(RateCon.ValueID6,'')='' or RateTab.ValueID6 =RateCon.ValueID6)                
And (coalesce(RateCon.ValueID7,'')='' or RateTab.ValueID7 =RateCon.ValueID7)                
And (coalesce(RateCon.ValueID8,'')='' or RateTab.ValueID8 =RateCon.ValueID8)                
And (coalesce(RateCon.ValueID9,'')='' or RateTab.ValueID9 =RateCon.ValueID9)                
And (coalesce(RateCon.ValueID10,'')='' or RateTab.ValueID10 =RateCon.ValueID10)                
And (coalesce(RateCon.ValueID11,'')='' or RateTab.ValueID11 =RateCon.ValueID11)                
And (coalesce(RateCon.ValueID12,'')='' or RateTab.ValueID12 =RateCon.ValueID12)                
And (coalesce(RateCon.ValueID13,'')='' or RateTab.ValueID13 =RateCon.ValueID13)                
And (coalesce(RateCon.ValueID14,'')='' or RateTab.ValueID14 =RateCon.ValueID14)                
And (coalesce(RateCon.ValueID15,'')='' or RateTab.ValueID15 =RateCon.ValueID15)                       
)
Order by   
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

if @Temp_Loading is null
	Select @Temp_Loading=1
	
Select @Loading=@Loading*@Temp_Loading

if @Temp_HoldF is null
	Select @Temp_HoldF=0

if @Temp_HoldF=1 
Begin
	Select @HoldF=@Temp_HoldF
	Select @HoldMessage=@HoldMessage+char(13)+char(10)+@Temp_HoldMessage 
End
	
--Rate Loading #2
Select @Temp_Loading=Null
Select @Temp_HoldF=Null
Select @Temp_HoldMessage=Null

SELECT Top 1 @Temp_Loading=RateCon.Loading, @Temp_HoldF=RateCon.HoldF, @Temp_HoldMessage=RateCon.HoldMessage
From @RateTab RateTab
INNER JOIN RateCon_M2 RateCon  on (
RateCon.Code=RateTab.Code and RateCon.AllowedF=1                 
And ((Case When @P_TSI=0 Then 1 Else @P_TSI End)>=RateCon.MinTSI or RateCon.MinTSI=0) 
and ((Case When @P_TSI=0 Then 1 Else @P_TSI End)<=RateCon.MaxTSI or RateCon.MaxTSI=0)     
And (
	 (RateTab.SPeriod=0 and (    
	 (datediff(month, RateTab.sdate, RateTab.edate)>=RateCon.MinPeriod)     
	 or (datediff(month, RateTab.sdate, RateTab.edate)=RateCon.MinPeriod-1 and day(RateTab.sdate)<day(RateTab.edate))     
	 or RateCon.MinPeriod=0)                               
	 And (    
	 (datediff(month, RateTab.sdate, RateTab.edate)<RateCon.MaxPeriod)     
	 or (datediff(month, RateTab.sdate, RateTab.edate)=RateCon.MaxPeriod and day(RateTab.sdate)>=day(RateTab.edate))     
	 or RateCon.MaxPeriod=0)) OR
	(RateTab.SPeriod=1 
	 and ((datediff(day, RateTab.sdate, RateTab.edate)>=RateCon.MinPeriod) or RateCon.MinPeriod=0)
	 And ((datediff(day, RateTab.sdate, RateTab.edate)<=RateCon.MaxPeriod) or RateCon.MaxPeriod=0))
	 )     
and (coalesce(RateCon.ValueID1,'')='' or RateTab.ValueID1 =RateCon.ValueID1)                
And (coalesce(RateCon.ValueID2,'')='' or RateTab.ValueID2 =RateCon.ValueID2)                
And (coalesce(RateCon.ValueID3,'')='' or RateTab.ValueID3 =RateCon.ValueID3)                
And (coalesce(RateCon.ValueID4,'')='' or RateTab.ValueID4 =RateCon.ValueID4)                
And (coalesce(RateCon.ValueID5,'')='' or RateTab.ValueID5 =RateCon.ValueID5)                
And (coalesce(RateCon.ValueID6,'')='' or RateTab.ValueID6 =RateCon.ValueID6)                
And (coalesce(RateCon.ValueID7,'')='' or RateTab.ValueID7 =RateCon.ValueID7)                
And (coalesce(RateCon.ValueID8,'')='' or RateTab.ValueID8 =RateCon.ValueID8)                
And (coalesce(RateCon.ValueID9,'')='' or RateTab.ValueID9 =RateCon.ValueID9)                
And (coalesce(RateCon.ValueID10,'')='' or RateTab.ValueID10 =RateCon.ValueID10)                
And (coalesce(RateCon.ValueID11,'')='' or RateTab.ValueID11 =RateCon.ValueID11)                
And (coalesce(RateCon.ValueID12,'')='' or RateTab.ValueID12 =RateCon.ValueID12)                
And (coalesce(RateCon.ValueID13,'')='' or RateTab.ValueID13 =RateCon.ValueID13)                
And (coalesce(RateCon.ValueID14,'')='' or RateTab.ValueID14 =RateCon.ValueID14)                
And (coalesce(RateCon.ValueID15,'')='' or RateTab.ValueID15 =RateCon.ValueID15)                       
)
Order by   
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

if @Temp_Loading is null
	Select @Temp_Loading=1
	
Select @Loading=@Loading*@Temp_Loading

if @Temp_HoldF is null
	Select @Temp_HoldF=0

if @Temp_HoldF=1 
Begin
	Select @HoldF=@Temp_HoldF
	Select @HoldMessage=@HoldMessage+char(13)+char(10)+@Temp_HoldMessage 
End

--Rate Loading #3
Select @Temp_Loading=Null
Select @Temp_HoldF=Null
Select @Temp_HoldMessage=Null

SELECT Top 1 @Temp_Loading=RateCon.Loading, @Temp_HoldF=RateCon.HoldF, @Temp_HoldMessage=RateCon.HoldMessage
From @RateTab RateTab
INNER JOIN RateCon_M3 RateCon  on (
RateCon.Code=RateTab.Code and RateCon.AllowedF=1                 
And ((Case When @P_TSI=0 Then 1 Else @P_TSI End)>=RateCon.MinTSI or RateCon.MinTSI=0) 
and ((Case When @P_TSI=0 Then 1 Else @P_TSI End)<=RateCon.MaxTSI or RateCon.MaxTSI=0)     
And (
	 (RateTab.SPeriod=0 and (    
	 (datediff(month, RateTab.sdate, RateTab.edate)>=RateCon.MinPeriod)     
	 or (datediff(month, RateTab.sdate, RateTab.edate)=RateCon.MinPeriod-1 and day(RateTab.sdate)<day(RateTab.edate))     
	 or RateCon.MinPeriod=0)                               
	 And (    
	 (datediff(month, RateTab.sdate, RateTab.edate)<RateCon.MaxPeriod)     
	 or (datediff(month, RateTab.sdate, RateTab.edate)=RateCon.MaxPeriod and day(RateTab.sdate)>=day(RateTab.edate))     
	 or RateCon.MaxPeriod=0)) OR
	(RateTab.SPeriod=1 
	 and ((datediff(day, RateTab.sdate, RateTab.edate)>=RateCon.MinPeriod) or RateCon.MinPeriod=0)
	 And ((datediff(day, RateTab.sdate, RateTab.edate)<=RateCon.MaxPeriod) or RateCon.MaxPeriod=0))
	 )     
and (coalesce(RateCon.ValueID1,'')='' or RateTab.ValueID1 =RateCon.ValueID1)                
And (coalesce(RateCon.ValueID2,'')='' or RateTab.ValueID2 =RateCon.ValueID2)                
And (coalesce(RateCon.ValueID3,'')='' or RateTab.ValueID3 =RateCon.ValueID3)                
And (coalesce(RateCon.ValueID4,'')='' or RateTab.ValueID4 =RateCon.ValueID4)                
And (coalesce(RateCon.ValueID5,'')='' or RateTab.ValueID5 =RateCon.ValueID5)                
And (coalesce(RateCon.ValueID6,'')='' or RateTab.ValueID6 =RateCon.ValueID6)                
And (coalesce(RateCon.ValueID7,'')='' or RateTab.ValueID7 =RateCon.ValueID7)                
And (coalesce(RateCon.ValueID8,'')='' or RateTab.ValueID8 =RateCon.ValueID8)                
And (coalesce(RateCon.ValueID9,'')='' or RateTab.ValueID9 =RateCon.ValueID9)                
And (coalesce(RateCon.ValueID10,'')='' or RateTab.ValueID10 =RateCon.ValueID10)                
And (coalesce(RateCon.ValueID11,'')='' or RateTab.ValueID11 =RateCon.ValueID11)                
And (coalesce(RateCon.ValueID12,'')='' or RateTab.ValueID12 =RateCon.ValueID12)                
And (coalesce(RateCon.ValueID13,'')='' or RateTab.ValueID13 =RateCon.ValueID13)                
And (coalesce(RateCon.ValueID14,'')='' or RateTab.ValueID14 =RateCon.ValueID14)                
And (coalesce(RateCon.ValueID15,'')='' or RateTab.ValueID15 =RateCon.ValueID15)                       
)
Order by   
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

if @Temp_Loading is null
	Select @Temp_Loading=1
	
Select @Loading=@Loading*@Temp_Loading

if @Temp_HoldF is null
	Select @Temp_HoldF=0

if @Temp_HoldF=1 
Begin
	Select @HoldF=@Temp_HoldF
	Select @HoldMessage=@HoldMessage+char(13)+char(10)+@Temp_HoldMessage 
End


--Rate Loading #4
Select @Temp_Loading=Null
Select @Temp_HoldF=Null
Select @Temp_HoldMessage=Null

SELECT Top 1 @Temp_Loading=RateCon.Loading, @Temp_HoldF=RateCon.HoldF, @Temp_HoldMessage=RateCon.HoldMessage
From @RateTab RateTab
INNER JOIN RateCon_M4 RateCon  on (
RateCon.Code=RateTab.Code and RateCon.AllowedF=1                 
And ((Case When @P_TSI=0 Then 1 Else @P_TSI End)>=RateCon.MinTSI or RateCon.MinTSI=0) 
and ((Case When @P_TSI=0 Then 1 Else @P_TSI End)<=RateCon.MaxTSI or RateCon.MaxTSI=0)     
And (
	 (RateTab.SPeriod=0 and (    
	 (datediff(month, RateTab.sdate, RateTab.edate)>=RateCon.MinPeriod)     
	 or (datediff(month, RateTab.sdate, RateTab.edate)=RateCon.MinPeriod-1 and day(RateTab.sdate)<day(RateTab.edate))     
	 or RateCon.MinPeriod=0)                               
	 And (    
	 (datediff(month, RateTab.sdate, RateTab.edate)<RateCon.MaxPeriod)     
	 or (datediff(month, RateTab.sdate, RateTab.edate)=RateCon.MaxPeriod and day(RateTab.sdate)>=day(RateTab.edate))     
	 or RateCon.MaxPeriod=0)) OR
	(RateTab.SPeriod=1 
	 and ((datediff(day, RateTab.sdate, RateTab.edate)>=RateCon.MinPeriod) or RateCon.MinPeriod=0)
	 And ((datediff(day, RateTab.sdate, RateTab.edate)<=RateCon.MaxPeriod) or RateCon.MaxPeriod=0))
	 )     
and (coalesce(RateCon.ValueID1,'')='' or RateTab.ValueID1 =RateCon.ValueID1)                
And (coalesce(RateCon.ValueID2,'')='' or RateTab.ValueID2 =RateCon.ValueID2)                
And (coalesce(RateCon.ValueID3,'')='' or RateTab.ValueID3 =RateCon.ValueID3)                
And (coalesce(RateCon.ValueID4,'')='' or RateTab.ValueID4 =RateCon.ValueID4)                
And (coalesce(RateCon.ValueID5,'')='' or RateTab.ValueID5 =RateCon.ValueID5)                
And (coalesce(RateCon.ValueID6,'')='' or RateTab.ValueID6 =RateCon.ValueID6)                
And (coalesce(RateCon.ValueID7,'')='' or RateTab.ValueID7 =RateCon.ValueID7)                
And (coalesce(RateCon.ValueID8,'')='' or RateTab.ValueID8 =RateCon.ValueID8)                
And (coalesce(RateCon.ValueID9,'')='' or RateTab.ValueID9 =RateCon.ValueID9)                
And (coalesce(RateCon.ValueID10,'')='' or RateTab.ValueID10 =RateCon.ValueID10)                
And (coalesce(RateCon.ValueID11,'')='' or RateTab.ValueID11 =RateCon.ValueID11)                
And (coalesce(RateCon.ValueID12,'')='' or RateTab.ValueID12 =RateCon.ValueID12)                
And (coalesce(RateCon.ValueID13,'')='' or RateTab.ValueID13 =RateCon.ValueID13)                
And (coalesce(RateCon.ValueID14,'')='' or RateTab.ValueID14 =RateCon.ValueID14)                
And (coalesce(RateCon.ValueID15,'')='' or RateTab.ValueID15 =RateCon.ValueID15)                       
)
Order by   
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

if @Temp_Loading is null
	Select @Temp_Loading=1
	
Select @Loading=@Loading*@Temp_Loading

if @Temp_HoldF is null
	Select @Temp_HoldF=0

if @Temp_HoldF=1 
Begin
	Select @HoldF=@Temp_HoldF
	Select @HoldMessage=@HoldMessage+char(13)+char(10)+@Temp_HoldMessage 
End


--Rate Loading #5
Select @Temp_Loading=Null
Select @Temp_HoldF=Null
Select @Temp_HoldMessage=Null

SELECT Top 1 @Temp_Loading=RateCon.Loading, @Temp_HoldF=RateCon.HoldF, @Temp_HoldMessage=RateCon.HoldMessage
From @RateTab RateTab
INNER JOIN RateCon_M5 RateCon  on (
RateCon.Code=RateTab.Code and RateCon.AllowedF=1                 
And ((Case When @P_TSI=0 Then 1 Else @P_TSI End)>=RateCon.MinTSI or RateCon.MinTSI=0) 
and ((Case When @P_TSI=0 Then 1 Else @P_TSI End)<=RateCon.MaxTSI or RateCon.MaxTSI=0)     
And (
	 (RateTab.SPeriod=0 and (    
	 (datediff(month, RateTab.sdate, RateTab.edate)>=RateCon.MinPeriod)     
	 or (datediff(month, RateTab.sdate, RateTab.edate)=RateCon.MinPeriod-1 and day(RateTab.sdate)<day(RateTab.edate))     
	 or RateCon.MinPeriod=0)                               
	 And (    
	 (datediff(month, RateTab.sdate, RateTab.edate)<RateCon.MaxPeriod)     
	 or (datediff(month, RateTab.sdate, RateTab.edate)=RateCon.MaxPeriod and day(RateTab.sdate)>=day(RateTab.edate))     
	 or RateCon.MaxPeriod=0)) OR
	(RateTab.SPeriod=1 
	 and ((datediff(day, RateTab.sdate, RateTab.edate)>=RateCon.MinPeriod) or RateCon.MinPeriod=0)
	 And ((datediff(day, RateTab.sdate, RateTab.edate)<=RateCon.MaxPeriod) or RateCon.MaxPeriod=0))
	 )     
and (coalesce(RateCon.ValueID1,'')='' or RateTab.ValueID1 =RateCon.ValueID1)                
And (coalesce(RateCon.ValueID2,'')='' or RateTab.ValueID2 =RateCon.ValueID2)                
And (coalesce(RateCon.ValueID3,'')='' or RateTab.ValueID3 =RateCon.ValueID3)                
And (coalesce(RateCon.ValueID4,'')='' or RateTab.ValueID4 =RateCon.ValueID4)                
And (coalesce(RateCon.ValueID5,'')='' or RateTab.ValueID5 =RateCon.ValueID5)                
And (coalesce(RateCon.ValueID6,'')='' or RateTab.ValueID6 =RateCon.ValueID6)                
And (coalesce(RateCon.ValueID7,'')='' or RateTab.ValueID7 =RateCon.ValueID7)                
And (coalesce(RateCon.ValueID8,'')='' or RateTab.ValueID8 =RateCon.ValueID8)                
And (coalesce(RateCon.ValueID9,'')='' or RateTab.ValueID9 =RateCon.ValueID9)                
And (coalesce(RateCon.ValueID10,'')='' or RateTab.ValueID10 =RateCon.ValueID10)                
And (coalesce(RateCon.ValueID11,'')='' or RateTab.ValueID11 =RateCon.ValueID11)                
And (coalesce(RateCon.ValueID12,'')='' or RateTab.ValueID12 =RateCon.ValueID12)                
And (coalesce(RateCon.ValueID13,'')='' or RateTab.ValueID13 =RateCon.ValueID13)                
And (coalesce(RateCon.ValueID14,'')='' or RateTab.ValueID14 =RateCon.ValueID14)                
And (coalesce(RateCon.ValueID15,'')='' or RateTab.ValueID15 =RateCon.ValueID15)                       
)
Order by   
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

if @Temp_Loading is null
	Select @Temp_Loading=1
	
Select @Loading=@Loading*@Temp_Loading

if @Temp_HoldF is null
	Select @Temp_HoldF=0

if @Temp_HoldF=1 
Begin
	Select @HoldF=@Temp_HoldF
	Select @HoldMessage=@HoldMessage+char(13)+char(10)+@Temp_HoldMessage 
End

--Rate Loading #6
Select @Temp_Loading=Null
Select @Temp_HoldF=Null
Select @Temp_HoldMessage=Null

SELECT Top 1 @Temp_Loading=RateCon.Loading, @Temp_HoldF=RateCon.HoldF, @Temp_HoldMessage=RateCon.HoldMessage
From @RateTab RateTab
INNER JOIN RateCon_M6 RateCon  on (
RateCon.Code=RateTab.Code and RateCon.AllowedF=1                 
And ((Case When @P_TSI=0 Then 1 Else @P_TSI End)>=RateCon.MinTSI or RateCon.MinTSI=0) 
and ((Case When @P_TSI=0 Then 1 Else @P_TSI End)<=RateCon.MaxTSI or RateCon.MaxTSI=0)     
And (
	 (RateTab.SPeriod=0 and (    
	 (datediff(month, RateTab.sdate, RateTab.edate)>=RateCon.MinPeriod)     
	 or (datediff(month, RateTab.sdate, RateTab.edate)=RateCon.MinPeriod-1 and day(RateTab.sdate)<day(RateTab.edate))     
	 or RateCon.MinPeriod=0)                               
	 And (    
	 (datediff(month, RateTab.sdate, RateTab.edate)<RateCon.MaxPeriod)     
	 or (datediff(month, RateTab.sdate, RateTab.edate)=RateCon.MaxPeriod and day(RateTab.sdate)>=day(RateTab.edate))     
	 or RateCon.MaxPeriod=0)) OR
	(RateTab.SPeriod=1 
	 and ((datediff(day, RateTab.sdate, RateTab.edate)>=RateCon.MinPeriod) or RateCon.MinPeriod=0)
	 And ((datediff(day, RateTab.sdate, RateTab.edate)<=RateCon.MaxPeriod) or RateCon.MaxPeriod=0))
	 )     
and (coalesce(RateCon.ValueID1,'')='' or RateTab.ValueID1 =RateCon.ValueID1)                
And (coalesce(RateCon.ValueID2,'')='' or RateTab.ValueID2 =RateCon.ValueID2)                
And (coalesce(RateCon.ValueID3,'')='' or RateTab.ValueID3 =RateCon.ValueID3)                
And (coalesce(RateCon.ValueID4,'')='' or RateTab.ValueID4 =RateCon.ValueID4)                
And (coalesce(RateCon.ValueID5,'')='' or RateTab.ValueID5 =RateCon.ValueID5)                
And (coalesce(RateCon.ValueID6,'')='' or RateTab.ValueID6 =RateCon.ValueID6)                
And (coalesce(RateCon.ValueID7,'')='' or RateTab.ValueID7 =RateCon.ValueID7)                
And (coalesce(RateCon.ValueID8,'')='' or RateTab.ValueID8 =RateCon.ValueID8)                
And (coalesce(RateCon.ValueID9,'')='' or RateTab.ValueID9 =RateCon.ValueID9)                
And (coalesce(RateCon.ValueID10,'')='' or RateTab.ValueID10 =RateCon.ValueID10)                
And (coalesce(RateCon.ValueID11,'')='' or RateTab.ValueID11 =RateCon.ValueID11)                
And (coalesce(RateCon.ValueID12,'')='' or RateTab.ValueID12 =RateCon.ValueID12)                
And (coalesce(RateCon.ValueID13,'')='' or RateTab.ValueID13 =RateCon.ValueID13)                
And (coalesce(RateCon.ValueID14,'')='' or RateTab.ValueID14 =RateCon.ValueID14)                
And (coalesce(RateCon.ValueID15,'')='' or RateTab.ValueID15 =RateCon.ValueID15)                       
)
Order by   
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

if @Temp_Loading is null
	Select @Temp_Loading=1
	
Select @Loading=@Loading*@Temp_Loading

if @Temp_HoldF is null
	Select @Temp_HoldF=0

if @Temp_HoldF=1 
Begin
	Select @HoldF=@Temp_HoldF
	Select @HoldMessage=@HoldMessage+char(13)+char(10)+@Temp_HoldMessage 
End


--Rate Loading #7
Select @Temp_Loading=Null
Select @Temp_HoldF=Null
Select @Temp_HoldMessage=Null

SELECT Top 1 @Temp_Loading=RateCon.Loading, @Temp_HoldF=RateCon.HoldF, @Temp_HoldMessage=RateCon.HoldMessage
From @RateTab RateTab
INNER JOIN RateCon_M7 RateCon  on (
RateCon.Code=RateTab.Code and RateCon.AllowedF=1                 
And ((Case When @P_TSI=0 Then 1 Else @P_TSI End)>=RateCon.MinTSI or RateCon.MinTSI=0) 
and ((Case When @P_TSI=0 Then 1 Else @P_TSI End)<=RateCon.MaxTSI or RateCon.MaxTSI=0)     
And (
	 (RateTab.SPeriod=0 and (    
	 (datediff(month, RateTab.sdate, RateTab.edate)>=RateCon.MinPeriod)     
	 or (datediff(month, RateTab.sdate, RateTab.edate)=RateCon.MinPeriod-1 and day(RateTab.sdate)<day(RateTab.edate))     
	 or RateCon.MinPeriod=0)                               
	 And (    
	 (datediff(month, RateTab.sdate, RateTab.edate)<RateCon.MaxPeriod)     
	 or (datediff(month, RateTab.sdate, RateTab.edate)=RateCon.MaxPeriod and day(RateTab.sdate)>=day(RateTab.edate))     
	 or RateCon.MaxPeriod=0)) OR
	(RateTab.SPeriod=1 
	 and ((datediff(day, RateTab.sdate, RateTab.edate)>=RateCon.MinPeriod) or RateCon.MinPeriod=0)
	 And ((datediff(day, RateTab.sdate, RateTab.edate)<=RateCon.MaxPeriod) or RateCon.MaxPeriod=0))
	 )     
and (coalesce(RateCon.ValueID1,'')='' or RateTab.ValueID1 =RateCon.ValueID1)                
And (coalesce(RateCon.ValueID2,'')='' or RateTab.ValueID2 =RateCon.ValueID2)                
And (coalesce(RateCon.ValueID3,'')='' or RateTab.ValueID3 =RateCon.ValueID3)                
And (coalesce(RateCon.ValueID4,'')='' or RateTab.ValueID4 =RateCon.ValueID4)                
And (coalesce(RateCon.ValueID5,'')='' or RateTab.ValueID5 =RateCon.ValueID5)                
And (coalesce(RateCon.ValueID6,'')='' or RateTab.ValueID6 =RateCon.ValueID6)                
And (coalesce(RateCon.ValueID7,'')='' or RateTab.ValueID7 =RateCon.ValueID7)           
And (coalesce(RateCon.ValueID8,'')='' or RateTab.ValueID8 =RateCon.ValueID8)                
And (coalesce(RateCon.ValueID9,'')='' or RateTab.ValueID9 =RateCon.ValueID9)                
And (coalesce(RateCon.ValueID10,'')='' or RateTab.ValueID10 =RateCon.ValueID10)                
And (coalesce(RateCon.ValueID11,'')='' or RateTab.ValueID11 =RateCon.ValueID11)                
And (coalesce(RateCon.ValueID12,'')='' or RateTab.ValueID12 =RateCon.ValueID12)                
And (coalesce(RateCon.ValueID13,'')='' or RateTab.ValueID13 =RateCon.ValueID13)                
And (coalesce(RateCon.ValueID14,'')='' or RateTab.ValueID14 =RateCon.ValueID14)                
And (coalesce(RateCon.ValueID15,'')='' or RateTab.ValueID15 =RateCon.ValueID15)                       
)
Order by   
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

if @Temp_Loading is null
	Select @Temp_Loading=1
	
Select @Loading=@Loading*@Temp_Loading

if @Temp_HoldF is null
	Select @Temp_HoldF=0

if @Temp_HoldF=1 
Begin
	Select @HoldF=@Temp_HoldF
	Select @HoldMessage=@HoldMessage+char(13)+char(10)+@Temp_HoldMessage 
End

insert into @RateCon Select @Loading, @HoldF,@HoldMessage
Return
END  
  

GO

IF EXISTS ( SELECT * FROM   sysobjects WHERE  id = object_id(N'List_Prev') and OBJECTPROPERTY(id, N'IsProcedure') = 1 )
 BEGIN DROP PROCEDURE List_Prev
end
GO
CREATE PROCEDURE List_Prev (@P_ANO as integer)   
AS  
Declare @P_PCNO as Int
Declare @P_PANO as Int
Declare @P_RANO as Int
Declare @P_CertificateNo as varchar(10)
Select @P_RANO=Acceptance.RANO, @P_PCNO=Cover.PCNO, @P_PANO=Acceptance.PANO, @P_CertificateNo=CERTIFICATENO from Acceptance, Cover Where Cover.CNO=Acceptance.CNO and Acceptance.ANO=@P_ANO

SELECT Cast(0 as bit) as ProcessFlag,  
 Cover.COVERNO,   
 Cast(Acceptance.AName as varchar(128)) as Insured,   
 Cover.CNO,   
 Cover.CStatus,   
 Acceptance.lANO,   
 Acceptance.ANO,   
 Acceptance.REGNO,   
 Acceptance.ADATE,   
 Acceptance.LUSERID as USERID,   
 SysTab.Currency,   
 (SELECT coalesce(SUM(PCALC.TSI*PCALC.RATE),0) FROM  PCALC WHERE PCALC.ANO=ACCEPTANCE.ANO AND ACCEPTANCE.PSTATUS='C')*CASE WHEN ACCEPTANCE.QTY=0 THEN 1 ELSE ACCEPTANCE.QTY END AS TSI,
 (SELECT coalesce(SUM(PCALC.OURSHARE*PCALC.RATE),0) FROM  PCALC WHERE PCALC.ANO=ACCEPTANCE.ANO AND ACCEPTANCE.PSTATUS='C')*CASE WHEN ACCEPTANCE.QTY=0 THEN 1 ELSE ACCEPTANCE.QTY END AS OURSHARE, 
 (SELECT coalesce(SUM(PCALC.GROSS*PCALC.RATE),0) FROM  PCALC WHERE PCALC.ANO=ACCEPTANCE.ANO AND ACCEPTANCE.PSTATUS='C')*CASE WHEN ACCEPTANCE.QTY=0 THEN 1 ELSE ACCEPTANCE.QTY END AS GROSS,
 Acceptance.ASTATUS,   
 Acceptance.ATYPE,   
 Acceptance.SDate,   
 Acceptance.EDate,   
 Year(Acceptance.SDate) AS RYear, 
 Cover.ISType,   
 Acceptance.Renewal,   
 Acceptance.ESeqNo,   
 Acceptance.PolicyNo,   
 Acceptance.CertificateNo  
FROM Acceptance, Cover, SysTab
WHERE Cover.CNO=Acceptance.CNO And (Acceptance.ANO=Acceptance.LANO Or Acceptance.LANO=-1) And Cover.ISType<>'T' 
And (@P_PANO<>-1 and Acceptance.ANO=@P_PANO)

Union All

SELECT Cast(0 as bit) as ProcessFlag,  
 Cover.COVERNO,   
 Cast(Acceptance.AName as varchar(128)) as Insured,   
 Cover.CNO,   
 Cover.CStatus,   
 Acceptance.lANO,   
 Acceptance.ANO,   
 Acceptance.REGNO,   
 Acceptance.ADATE,   
 Acceptance.LUSERID as USERID,   
 SysTab.Currency,   
 (SELECT coalesce(SUM(PCALC.TSI*PCALC.RATE),0) FROM  PCALC WHERE PCALC.ANO=ACCEPTANCE.ANO AND ACCEPTANCE.PSTATUS='C')*CASE WHEN ACCEPTANCE.QTY=0 THEN 1 ELSE ACCEPTANCE.QTY END AS TSI,
 (SELECT coalesce(SUM(PCALC.OURSHARE*PCALC.RATE),0) FROM  PCALC WHERE PCALC.ANO=ACCEPTANCE.ANO AND ACCEPTANCE.PSTATUS='C')*CASE WHEN ACCEPTANCE.QTY=0 THEN 1 ELSE ACCEPTANCE.QTY END AS OURSHARE, 
 (SELECT coalesce(SUM(PCALC.GROSS*PCALC.RATE),0) FROM  PCALC WHERE PCALC.ANO=ACCEPTANCE.ANO AND ACCEPTANCE.PSTATUS='C')*CASE WHEN ACCEPTANCE.QTY=0 THEN 1 ELSE ACCEPTANCE.QTY END AS GROSS,
 Acceptance.ASTATUS,   
 Acceptance.ATYPE,   
 Acceptance.SDate,   
 Acceptance.EDate,   
 Year(Acceptance.SDate) AS RYear, 
 Cover.ISType,   
 Acceptance.Renewal,   
 Acceptance.ESeqNo,   
 Acceptance.PolicyNo,   
 Acceptance.CertificateNo  
FROM Acceptance, Cover, SysTab
WHERE Cover.CNO=Acceptance.CNO And (Acceptance.ANO=Acceptance.LANO Or Acceptance.LANO=-1) And Cover.ISType<>'T' 
And (@P_RANO<>-1 and Acceptance.ANO=@P_RANO)
And Not (@P_PANO<>-1 and Acceptance.ANO=@P_PANO)

Union All

SELECT Cast(0 as bit) as ProcessFlag,  
 Cover.COVERNO,   
 Cast(Acceptance.AName as varchar(128)) as Insured,   
 Cover.CNO,   
 Cover.CStatus,   
 Acceptance.lANO,   
 Acceptance.ANO,   
 Acceptance.REGNO,   
 Acceptance.ADATE,   
 Acceptance.LUSERID as USERID,   
 SysTab.Currency,   
 (SELECT coalesce(SUM(PCALC.TSI*PCALC.RATE),0) FROM  PCALC WHERE PCALC.ANO=ACCEPTANCE.ANO AND ACCEPTANCE.PSTATUS='C')*CASE WHEN ACCEPTANCE.QTY=0 THEN 1 ELSE ACCEPTANCE.QTY END AS TSI,
 (SELECT coalesce(SUM(PCALC.OURSHARE*PCALC.RATE),0) FROM  PCALC WHERE PCALC.ANO=ACCEPTANCE.ANO AND ACCEPTANCE.PSTATUS='C')*CASE WHEN ACCEPTANCE.QTY=0 THEN 1 ELSE ACCEPTANCE.QTY END AS OURSHARE, 
 (SELECT coalesce(SUM(PCALC.GROSS*PCALC.RATE),0) FROM  PCALC WHERE PCALC.ANO=ACCEPTANCE.ANO AND ACCEPTANCE.PSTATUS='C')*CASE WHEN ACCEPTANCE.QTY=0 THEN 1 ELSE ACCEPTANCE.QTY END AS GROSS,
 Acceptance.ASTATUS,   
 Acceptance.ATYPE,   
 Acceptance.SDate,   
 Acceptance.EDate,   
 Year(Acceptance.SDate) AS RYear, 
 Cover.ISType,   
 Acceptance.Renewal,   
 Acceptance.ESeqNo,   
 Acceptance.PolicyNo,   
 Acceptance.CertificateNo  
FROM Acceptance, Cover, SysTab
WHERE Cover.CNO=Acceptance.CNO And (Acceptance.ANO=Acceptance.LANO Or Acceptance.LANO=-1) And Cover.ISType<>'T' 
And (@P_PCNO<>-1 and Cover.CNO=@P_PCNO and Acceptance.CERTIFICATENO=@P_CertificateNo)
And not (@P_RANO<>-1 and Acceptance.ANO=@P_RANO)
And Not (@P_PANO<>-1 and Acceptance.ANO=@P_PANO)
Order by Acceptance.ANO Desc

GO
IF EXISTS ( SELECT * FROM   sysobjects WHERE  id = object_id(N'List_Next') and OBJECTPROPERTY(id, N'IsProcedure') = 1 ) 
BEGIN DROP PROCEDURE List_Next
end
GO
CREATE PROCEDURE List_Next (@P_ANO as integer)  
AS  

Declare @P_CNO as Int
Declare @P_CertificateNo as varchar(10)
Select @P_CNO=CNO, @P_CertificateNo=CERTIFICATENO from Acceptance Where ANO=@P_ANO

SELECT Cast(0 as bit) as ProcessFlag,  
 Cover.COVERNO,   
 Cast(Acceptance.AName as varchar(128)) as Insured,   
 Cover.CNO,   
 Cover.CStatus,   
 Acceptance.lANO,   
 Acceptance.ANO,   
 Acceptance.REGNO,   
 Acceptance.ADATE,   
 Acceptance.LUSERID as USERID,   
 SysTab.Currency,   
 (SELECT coalesce(SUM(PCALC.TSI*PCALC.RATE),0) FROM  PCALC WHERE PCALC.ANO=ACCEPTANCE.ANO AND ACCEPTANCE.PSTATUS='C')*CASE WHEN ACCEPTANCE.QTY=0 THEN 1 ELSE ACCEPTANCE.QTY END AS TSI,
 (SELECT coalesce(SUM(PCALC.OURSHARE*PCALC.RATE),0) FROM  PCALC WHERE PCALC.ANO=ACCEPTANCE.ANO AND ACCEPTANCE.PSTATUS='C')*CASE WHEN ACCEPTANCE.QTY=0 THEN 1 ELSE ACCEPTANCE.QTY END AS OURSHARE, 
 (SELECT coalesce(SUM(PCALC.GROSS*PCALC.RATE),0) FROM  PCALC WHERE PCALC.ANO=ACCEPTANCE.ANO AND ACCEPTANCE.PSTATUS='C')*CASE WHEN ACCEPTANCE.QTY=0 THEN 1 ELSE ACCEPTANCE.QTY END AS GROSS,
 Acceptance.ASTATUS,   
 Acceptance.ATYPE,   
 Acceptance.SDate,   
 Acceptance.EDate,   
 Year(Acceptance.SDate) AS RYear, 
 Cover.ISType,   
 Acceptance.Renewal,   
 Acceptance.ESeqNo,   
 Acceptance.PolicyNo,   
 Acceptance.CertificateNo  
FROM Acceptance, Cover, SysTab
WHERE Cover.CNO=Acceptance.CNO And (Acceptance.ANO=Acceptance.LANO Or Acceptance.LANO=-1) And Cover.ISType<>'T' 
and (Acceptance.PANO<>-1 and Acceptance.PANO=@P_ANO)

Union All

SELECT Cast(0 as bit) as ProcessFlag,  
 Cover.COVERNO,   
 Cast(Acceptance.AName as varchar(128)) as Insured,   
 Cover.CNO,   
 Cover.CStatus,   
 Acceptance.lANO,   
 Acceptance.ANO,   
 Acceptance.REGNO,   
 Acceptance.ADATE,   
 Acceptance.LUSERID as USERID,   
 SysTab.Currency,   
 (SELECT coalesce(SUM(PCALC.TSI*PCALC.RATE),0) FROM  PCALC WHERE PCALC.ANO=ACCEPTANCE.ANO AND ACCEPTANCE.PSTATUS='C')*CASE WHEN ACCEPTANCE.QTY=0 THEN 1 ELSE ACCEPTANCE.QTY END AS TSI,
 (SELECT coalesce(SUM(PCALC.OURSHARE*PCALC.RATE),0) FROM  PCALC WHERE PCALC.ANO=ACCEPTANCE.ANO AND ACCEPTANCE.PSTATUS='C')*CASE WHEN ACCEPTANCE.QTY=0 THEN 1 ELSE ACCEPTANCE.QTY END AS OURSHARE, 
 (SELECT coalesce(SUM(PCALC.GROSS*PCALC.RATE),0) FROM  PCALC WHERE PCALC.ANO=ACCEPTANCE.ANO AND ACCEPTANCE.PSTATUS='C')*CASE WHEN ACCEPTANCE.QTY=0 THEN 1 ELSE ACCEPTANCE.QTY END AS GROSS,
 Acceptance.ASTATUS,   
 Acceptance.ATYPE,   
 Acceptance.SDate,   
 Acceptance.EDate,   
 Year(Acceptance.SDate) AS RYear, 
 Cover.ISType,   
 Acceptance.Renewal,   
 Acceptance.ESeqNo,   
 Acceptance.PolicyNo,   
 Acceptance.CertificateNo  
FROM Acceptance, Cover, SysTab
WHERE Cover.CNO=Acceptance.CNO And (Acceptance.ANO=Acceptance.LANO Or Acceptance.LANO=-1) And Cover.ISType<>'T' 
and (Acceptance.RANO<>-1 and Acceptance.RANO=@P_ANO)
and not (Acceptance.PANO<>-1 and Acceptance.PANO=@P_ANO)

Union All

SELECT Cast(0 as bit) as ProcessFlag,  
 Cover.COVERNO,   
 Cast(Acceptance.AName as varchar(128)) as Insured,   
 Cover.CNO,   
 Cover.CStatus,   
 Acceptance.lANO,   
 Acceptance.ANO,   
 Acceptance.REGNO,   
 Acceptance.ADATE,   
 Acceptance.LUSERID as USERID,   
 SysTab.Currency,   
 (SELECT coalesce(SUM(PCALC.TSI*PCALC.RATE),0) FROM  PCALC WHERE PCALC.ANO=ACCEPTANCE.ANO AND ACCEPTANCE.PSTATUS='C')*CASE WHEN ACCEPTANCE.QTY=0 THEN 1 ELSE ACCEPTANCE.QTY END AS TSI,
 (SELECT coalesce(SUM(PCALC.OURSHARE*PCALC.RATE),0) FROM  PCALC WHERE PCALC.ANO=ACCEPTANCE.ANO AND ACCEPTANCE.PSTATUS='C')*CASE WHEN ACCEPTANCE.QTY=0 THEN 1 ELSE ACCEPTANCE.QTY END AS OURSHARE, 
 (SELECT coalesce(SUM(PCALC.GROSS*PCALC.RATE),0) FROM  PCALC WHERE PCALC.ANO=ACCEPTANCE.ANO AND ACCEPTANCE.PSTATUS='C')*CASE WHEN ACCEPTANCE.QTY=0 THEN 1 ELSE ACCEPTANCE.QTY END AS GROSS,
 Acceptance.ASTATUS,   
 Acceptance.ATYPE,   
 Acceptance.SDate,   
 Acceptance.EDate,   
 Year(Acceptance.SDate) AS RYear, 
 Cover.ISType,   
 Acceptance.Renewal,   
 Acceptance.ESeqNo,   
 Acceptance.PolicyNo,   
 Acceptance.CertificateNo  
FROM Acceptance, Cover, SysTab
WHERE Cover.CNO=Acceptance.CNO And (Acceptance.ANO=Acceptance.LANO Or Acceptance.LANO=-1) And Cover.ISType<>'T' 
and (Cover.pCNO<>-1 and Cover.pCNO=@P_CNO and Acceptance.CERTIFICATENO=@P_CertificateNo)
and not (Acceptance.RANO<>-1 and Acceptance.RANO=@P_ANO)
and not (Acceptance.PANO<>-1 and Acceptance.PANO=@P_ANO)
Order by Acceptance.ANO Asc
  
GO

IF EXISTS ( SELECT * FROM   sysobjects WHERE  id = object_id(N'ListDet_Prev') and OBJECTPROPERTY(id, N'IsProcedure') = 1 ) 
BEGIN DROP PROCEDURE ListDet_Prev
end
GO
CREATE PROCEDURE ListDet_Prev (@P_ANO as integer)   
AS  
Declare @P_PCNO as Int
Declare @P_PANO as Int
Declare @P_RANO as Int
Declare @P_CertificateNo as varchar(10)
Select @P_RANO=Acceptance.RANO, @P_PCNO=Cover.PCNO, @P_PANO=Acceptance.PANO, @P_CertificateNo=CERTIFICATENO from Acceptance, Cover Where Cover.CNO=Acceptance.CNO and Acceptance.ANO=@P_ANO

SELECT Cast(0 as bit) as ProcessFlag,Acceptance.CertificateNo, Acceptance.ESeqNo, Cast(Acceptance.AName as varchar(128)) as AName, Acceptance.ANO, Acceptance.REGNO, Acceptance.ADATE,Acceptance.LUSERID as USERID, SysTab.Currency, 
(SELECT coalesce(SUM(PCALC.TSI*PCALC.RATE),0) FROM  PCALC WHERE PCALC.ANO=ACCEPTANCE.ANO AND ACCEPTANCE.PSTATUS='C')*CASE WHEN ACCEPTANCE.QTY=0 THEN 1 ELSE ACCEPTANCE.QTY END AS TSI,
(SELECT coalesce(SUM(PCALC.OURSHARE*PCALC.RATE),0) FROM  PCALC WHERE PCALC.ANO=ACCEPTANCE.ANO AND ACCEPTANCE.PSTATUS='C')*CASE WHEN ACCEPTANCE.QTY=0 THEN 1 ELSE ACCEPTANCE.QTY END AS OURSHARE, 
(SELECT coalesce(SUM(PCALC.GROSS*PCALC.RATE),0) FROM  PCALC WHERE PCALC.ANO=ACCEPTANCE.ANO AND ACCEPTANCE.PSTATUS='C')*CASE WHEN ACCEPTANCE.QTY=0 THEN 1 ELSE ACCEPTANCE.QTY END AS GROSS,
Year(Acceptance.SDate) as RYear, Acceptance.ASTATUS, Acceptance.ATYPE, Acceptance.SDate, Acceptance.EDate, Acceptance.ValueID, Acceptance.ValueDesc, Acceptance.BatchNo
FROM Acceptance, Cover, SysTab
WHERE Cover.CNO=Acceptance.CNO And Acceptance.LANO<>-1 
And (@P_PANO<>-1 and Acceptance.ANO=@P_PANO)

Union All

SELECT Cast(0 as bit) as ProcessFlag,Acceptance.CertificateNo, Acceptance.ESeqNo, Cast(Acceptance.AName as varchar(128)) as AName, Acceptance.ANO, Acceptance.REGNO, Acceptance.ADATE,Acceptance.LUSERID as USERID, SysTab.Currency, 
(SELECT coalesce(SUM(PCALC.TSI*PCALC.RATE),0) FROM  PCALC WHERE PCALC.ANO=ACCEPTANCE.ANO AND ACCEPTANCE.PSTATUS='C')*CASE WHEN ACCEPTANCE.QTY=0 THEN 1 ELSE ACCEPTANCE.QTY END AS TSI,
(SELECT coalesce(SUM(PCALC.OURSHARE*PCALC.RATE),0) FROM  PCALC WHERE PCALC.ANO=ACCEPTANCE.ANO AND ACCEPTANCE.PSTATUS='C')*CASE WHEN ACCEPTANCE.QTY=0 THEN 1 ELSE ACCEPTANCE.QTY END AS OURSHARE, 
(SELECT coalesce(SUM(PCALC.GROSS*PCALC.RATE),0) FROM  PCALC WHERE PCALC.ANO=ACCEPTANCE.ANO AND ACCEPTANCE.PSTATUS='C')*CASE WHEN ACCEPTANCE.QTY=0 THEN 1 ELSE ACCEPTANCE.QTY END AS GROSS,
Year(Acceptance.SDate) as RYear, Acceptance.ASTATUS, Acceptance.ATYPE, Acceptance.SDate, Acceptance.EDate, Acceptance.ValueID, Acceptance.ValueDesc, Acceptance.BatchNo    
FROM Acceptance, Cover, SysTab
WHERE Cover.CNO=Acceptance.CNO And Acceptance.LANO<>-1 
And (@P_RANO<>-1 and Acceptance.ANO=@P_RANO)
And Not (@P_PANO<>-1 and Acceptance.ANO=@P_PANO)

Union All

SELECT Cast(0 as bit) as ProcessFlag,Acceptance.CertificateNo, Acceptance.ESeqNo, Cast(Acceptance.AName as varchar(128)) as AName, Acceptance.ANO, Acceptance.REGNO, Acceptance.ADATE,Acceptance.LUSERID as USERID, SysTab.Currency, 
(SELECT coalesce(SUM(PCALC.TSI*PCALC.RATE),0) FROM  PCALC WHERE PCALC.ANO=ACCEPTANCE.ANO AND ACCEPTANCE.PSTATUS='C')*CASE WHEN ACCEPTANCE.QTY=0 THEN 1 ELSE ACCEPTANCE.QTY END AS TSI,
(SELECT coalesce(SUM(PCALC.OURSHARE*PCALC.RATE),0) FROM  PCALC WHERE PCALC.ANO=ACCEPTANCE.ANO AND ACCEPTANCE.PSTATUS='C')*CASE WHEN ACCEPTANCE.QTY=0 THEN 1 ELSE ACCEPTANCE.QTY END AS OURSHARE, 
(SELECT coalesce(SUM(PCALC.GROSS*PCALC.RATE),0) FROM  PCALC WHERE PCALC.ANO=ACCEPTANCE.ANO AND ACCEPTANCE.PSTATUS='C')*CASE WHEN ACCEPTANCE.QTY=0 THEN 1 ELSE ACCEPTANCE.QTY END AS GROSS,
Year(Acceptance.SDate) as RYear, Acceptance.ASTATUS, Acceptance.ATYPE, Acceptance.SDate, Acceptance.EDate, Acceptance.ValueID, Acceptance.ValueDesc, Acceptance.BatchNo    
FROM Acceptance, Cover, SysTab
WHERE Cover.CNO=Acceptance.CNO And Acceptance.LANO<>-1 
And (@P_PCNO<>-1 and Cover.CNO=@P_PCNO and Acceptance.CERTIFICATENO=@P_CertificateNo)
And Not (@P_RANO<>-1 and Acceptance.ANO=@P_RANO)
And Not (@P_PANO<>-1 and Acceptance.ANO=@P_PANO)



GO
IF EXISTS ( SELECT * FROM   sysobjects WHERE  id = object_id(N'ListDet_Next') and OBJECTPROPERTY(id, N'IsProcedure') = 1 ) 
BEGIN DROP PROCEDURE ListDet_Next
end
GO
CREATE PROCEDURE ListDet_Next (@P_ANO as integer)     
AS    
Declare @P_CNO as Int
Declare @P_CertificateNo as varchar(10)
Select @P_CNO=CNO, @P_CertificateNo=CERTIFICATENO from Acceptance Where ANO=@P_ANO

SELECT Cast(0 as bit) as ProcessFlag,Acceptance.CertificateNo, Acceptance.ESeqNo, Cast(Acceptance.AName as varchar(128)) as AName, Acceptance.ANO, Acceptance.REGNO, Acceptance.ADATE, Acceptance.LUSERID as USERID, SysTab.Currency, 
(SELECT coalesce(SUM(PCALC.TSI*PCALC.RATE),0) FROM  PCALC WHERE PCALC.ANO=ACCEPTANCE.ANO AND ACCEPTANCE.PSTATUS='C')*CASE WHEN ACCEPTANCE.QTY=0 THEN 1 ELSE ACCEPTANCE.QTY END AS TSI,
(SELECT coalesce(SUM(PCALC.OURSHARE*PCALC.RATE),0) FROM  PCALC WHERE PCALC.ANO=ACCEPTANCE.ANO AND ACCEPTANCE.PSTATUS='C')*CASE WHEN ACCEPTANCE.QTY=0 THEN 1 ELSE ACCEPTANCE.QTY END AS OURSHARE, 
(SELECT coalesce(SUM(PCALC.GROSS*PCALC.RATE),0) FROM  PCALC WHERE PCALC.ANO=ACCEPTANCE.ANO AND ACCEPTANCE.PSTATUS='C')*CASE WHEN ACCEPTANCE.QTY=0 THEN 1 ELSE ACCEPTANCE.QTY END AS GROSS,
Year(Acceptance.SDate) as RYear, Acceptance.ASTATUS, Acceptance.ATYPE, Acceptance.SDate, Acceptance.EDate, Acceptance.ValueID, Acceptance.ValueDesc, Acceptance.BatchNo    
FROM Acceptance, Cover, SysTab
WHERE Cover.CNO=Acceptance.CNO and Acceptance.LANO<>-1 
and (Acceptance.PANO<>-1 and Acceptance.PANO=@P_ANO)

Union All

SELECT Cast(0 as bit) as ProcessFlag,Acceptance.CertificateNo, Acceptance.ESeqNo, Cast(Acceptance.AName as varchar(128)) as AName, Acceptance.ANO, Acceptance.REGNO, Acceptance.ADATE, Acceptance.LUSERID as USERID, SysTab.Currency, 
(SELECT coalesce(SUM(PCALC.TSI*PCALC.RATE),0) FROM  PCALC WHERE PCALC.ANO=ACCEPTANCE.ANO AND ACCEPTANCE.PSTATUS='C')*CASE WHEN ACCEPTANCE.QTY=0 THEN 1 ELSE ACCEPTANCE.QTY END AS TSI,
(SELECT coalesce(SUM(PCALC.OURSHARE*PCALC.RATE),0) FROM  PCALC WHERE PCALC.ANO=ACCEPTANCE.ANO AND ACCEPTANCE.PSTATUS='C')*CASE WHEN ACCEPTANCE.QTY=0 THEN 1 ELSE ACCEPTANCE.QTY END AS OURSHARE, 
(SELECT coalesce(SUM(PCALC.GROSS*PCALC.RATE),0) FROM  PCALC WHERE PCALC.ANO=ACCEPTANCE.ANO AND ACCEPTANCE.PSTATUS='C')*CASE WHEN ACCEPTANCE.QTY=0 THEN 1 ELSE ACCEPTANCE.QTY END AS GROSS,
Year(Acceptance.SDate) as RYear, Acceptance.ASTATUS, Acceptance.ATYPE, Acceptance.SDate, Acceptance.EDate, Acceptance.ValueID, Acceptance.ValueDesc, Acceptance.BatchNo    
FROM Acceptance, Cover, SysTab
WHERE Cover.CNO=Acceptance.CNO and Acceptance.LANO<>-1 
and (Acceptance.RANO<>-1 and Acceptance.RANO=@P_ANO)
and Not (Acceptance.PANO<>-1 and Acceptance.PANO=@P_ANO)

Union All

SELECT Cast(0 as bit) as ProcessFlag,Acceptance.CertificateNo, Acceptance.ESeqNo, Cast(Acceptance.AName as varchar(128)) as AName, Acceptance.ANO, Acceptance.REGNO, Acceptance.ADATE, Acceptance.LUSERID as USERID, SysTab.Currency, 
(SELECT coalesce(SUM(PCALC.TSI*PCALC.RATE),0) FROM  PCALC WHERE PCALC.ANO=ACCEPTANCE.ANO AND ACCEPTANCE.PSTATUS='C')*CASE WHEN ACCEPTANCE.QTY=0 THEN 1 ELSE ACCEPTANCE.QTY END AS TSI,
(SELECT coalesce(SUM(PCALC.OURSHARE*PCALC.RATE),0) FROM  PCALC WHERE PCALC.ANO=ACCEPTANCE.ANO AND ACCEPTANCE.PSTATUS='C')*CASE WHEN ACCEPTANCE.QTY=0 THEN 1 ELSE ACCEPTANCE.QTY END AS OURSHARE, 
(SELECT coalesce(SUM(PCALC.GROSS*PCALC.RATE),0) FROM  PCALC WHERE PCALC.ANO=ACCEPTANCE.ANO AND ACCEPTANCE.PSTATUS='C')*CASE WHEN ACCEPTANCE.QTY=0 THEN 1 ELSE ACCEPTANCE.QTY END AS GROSS,
Year(Acceptance.SDate) as RYear, Acceptance.ASTATUS, Acceptance.ATYPE, Acceptance.SDate, Acceptance.EDate, Acceptance.ValueID, Acceptance.ValueDesc, Acceptance.BatchNo    
FROM Acceptance, Cover, SysTab
WHERE Cover.CNO=Acceptance.CNO and Acceptance.LANO<>-1 
and (Cover.pCNO<>-1 and Cover.pCNO=@P_CNO and Acceptance.CERTIFICATENO=@P_CertificateNo)
and Not (Acceptance.RANO<>-1 and Acceptance.RANO=@P_ANO)
and Not (Acceptance.PANO<>-1 and Acceptance.PANO=@P_ANO)

GO

IF EXISTS ( SELECT * FROM   sysobjects WHERE  id = object_id(N'QOverlapped_Risk') and OBJECTPROPERTY(id, N'IsProcedure') = 1 )
 BEGIN DROP PROCEDURE QOverlapped_Risk
end
GO
CREATE Procedure QOverlapped_Risk(@P_ANO integer) 
as 
Select Top 1 A1.ANO 
from RCover R1, Acceptance A1 
Where A1.ANO=@P_ANO and A1.ANO=R1.ANO and R1.Category='M' 
--and not ((R1.SDate=A1.SDate or  R1.SDate=A1.PDate) and R1.EDate=A1.EDate) 
and Exists
( 
Select Top 1 R2.ANO 
from RCover R2 
Where R2.ANO=R1.ANO and R2.Category='M' 
and not (R2.ANO=R1.ANO and R2.Code=R1.Code and R2.Sdate=R1.Sdate) 
and 
( 
(R2.Sdate<R1.Edate and R2.Edate>=R1.Edate) or (R2.Sdate<=R1.Sdate and R2.Edate>R1.Sdate) or 
(R1.Sdate<=R2.Sdate and R1.Edate>R2.Sdate) or (R1.Sdate<R2.Edate and R1.Edate>=R2.Edate) 
) 
) 

GO

if exists (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'OS_VOUCHER_P') AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) )
 BEGIN DROP FUNCTION OS_VOUCHER_P 
end
GO
CREATE function OS_VOUCHER_P (@P_Voucher Varchar(20))                  
RETURNS Table                  
AS RETURN                  
(                  
SELECT VOUCHER.VOUCHER, VOUCHER.DATE, VOUCHER.CURRENCY, VOUCHER.PROACC, VOUCHER.DEBTORF,VOUCHER.CREDITORF,VOUCHER.SL_CAT,                  
CASE WHEN PV.VOUCHER IS NULL THEN VOUCHER.BRANCH ELSE PV.BRANCH END AS BRANCH, VOUCHER.REFNO,VOUCHER.REFDATE, VOUCHER.DOCNO,VOUCHER.VTYPE, VOUCHER.REMARKS, VOUCHER.REFTYPE, VOUCHER.ACCOUNTNO, ' ' as A_RefNo,                  
CASE WHEN VP.VOUCHER IS NULL THEN PV.NOMINAL_CC ELSE VOUCHER.NOMINAL_CC-VOUCHER.DIFF_CC END AS NOMINAL,                  
Cast(0 as Float) as TAX,
CASE WHEN VP.VOUCHER IS NULL THEN PV.PAYMENT_CC ELSE VOUCHER.NOMINAL_CC-VOUCHER.DIFF_CC-VP.NOMINAL END AS PAYMENT,                  
CASE WHEN VP.VOUCHER IS NULL THEN PV.NOMINAL_CC-PV.PAYMENT_CC ELSE VP.NOMINAL END AS OUTSTANDING,
PV.ACCOUNT,
PV.HINT                 
FROM pVoucher VOUCHER                  
Inner JOIN VType ON (VType.VType=Voucher.VType and VType.Code<>'INTERBANK')              
Inner JOIN         
(        
 SELECT VOUCHER, BRANCH, ACCOUNT, MAX(HINT) AS HINT, SUM(NOMINAL_CC) AS NOMINAL_CC, SUM(PAYMENT_CC) AS PAYMENT_CC        
 FROM        
 (        
 SELECT VOUCHER, BRANCH, ACCOUNT, HINT, SL.NOMINAL AS NOMINAL_CC,0 as PAYMENT_CC FROM PSLSUM SL
 Union All        
 SELECT PVOUCHER.VOUCHER, SL.BRANCH, SL.ACCOUNT, MAX(SL.HINT) AS HINT, 0 as NOMINAL_CC, SUM(SL.NOMINAL_OC) AS PAYMENT_CC 
 FROM R_SL_ALLOCATED_BY_VOUCHER('') SL, PVOUCHER
 WHERE PVOUCHER.NPAYMENT<>0 and PVOUCHER.VOUCHER=SL.DOC_NO 
 Group By PVOUCHER.VOUCHER, SL.BRANCH, SL.ACCOUNT
 ) PV GROUP BY VOUCHER, BRANCH, ACCOUNT        
) PV ON (PV.VOUCHER=VOUCHER.VOUCHER)        
LEFT JOIN PAID_VOUCHER_P(@P_Voucher) VP ON(VP.VOUCHER=VOUCHER.VOUCHER)                  
WHERE VOUCHER.STATUS<>'N' and VOUCHER.REQUESTF=0                  
AND ROUND(CASE WHEN VP.VOUCHER IS NULL THEN PV.NOMINAL_CC-PV.PAYMENT_CC ELSE VP.NOMINAL END,4)<>0        
) 


GO
if exists (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'Get_Payment_Percentage') AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) ) 
BEGIN DROP FUNCTION Get_Payment_Percentage
end
GO
CREATE Function Get_Payment_Percentage(@P_A_PolicyNo varchar(50), @P_DocNO varchar(50), @P_Date smalldatetime)
RETURNS Float AS        
  
BEGIN       
Declare @PCT as Float

Select 
@PCT=
sum(case When V.DebtorF=1 Then (V.Payment_CC) Else -(V.Payment_CC) end)/sum(case When V.DebtorF=1 Then (V.Nominal_CC) Else -(V.Nominal_CC) end)*100

from (

	Select V.Voucher, 
	cast(Max(Cast(V.DebtorF as Int)) as Bit) as DebtorF,
	Case 
	When Max(V.Payment_CC)<sum((case When V.DebtorF=1 Then 1 else -1 end)*(A.LAmount)) Then 0
	Else Max(V.Payment_CC)-sum((case When V.DebtorF=1 Then 1 else -1 end)*(A.LAmount))
	End as Payment_CC,

	sum((case When V.DebtorF=1 Then 1 else -1 end)*(A.Amount-(A.LAmount))) as Nominal_CC
	from nVoucher V, Admlink A
	Where A.Voucher=V.Voucher
	and A.Date<=@P_Date and A.A_PolicyNo=@P_A_PolicyNo and A.DocNo<=@P_DocNo and A.Subject='Premium' and V.DebtorF=1 and A.Type in ('DI','IC','IR')
	Group By V.Voucher
) V

Having sum(case When V.DebtorF=1 Then (V.Nominal_CC) Else -(V.Nominal_CC) end)<>0

if @PCT IS NULL 
	SELECT @PCT=100

Return @PCT
End




GO

IF EXISTS ( SELECT * FROM   sysobjects WHERE  id = object_id(N'QCLACC02') and OBJECTPROPERTY(id, N'IsProcedure') = 1 ) 
BEGIN DROP PROCEDURE QCLACC02
end
GO
CREATE PROCEDURE QCLACC02 (@P_CNO AS INTEGER)   
AS   
SELECT DISTINCT CLAIM.CNO, CLAIM.REGDATE, CLAIM.ISTYPE, ACCDED.TOR, ACCDED.DCODE, '' as Payment, ACCDED.REMARKS, ACCDED.REMARKS_1, ACCDED.CURRENCY   
From CLAIM, ACCDED, COL, ACCEPTANCE, RCALC, RCOVER
WHERE CLAIM.CNO=@P_CNO 
AND ACCDED.ANO=CLAIM.ANO AND ACCEPTANCE.ANO=ACCDED.ANO 
and RCalc.ANO=ACCDED.ANO and ACCDED.TOR=RCalc.TOR
and RCover.ANO=RCalc.ANO and RCover.Code=RCalc.Code and RCover.SDate=Rcalc.Sdate  
AND (RCover.RetroActiveF=1 or (ACCDED.SDATE<=CLAIM.LOSSDATE AND ACCEPTANCE.ExclusiveF=1) or ((ACCDED.SDATE<CLAIM.LOSSDATE or (ACCDED.SDATE=CLAIM.LOSSDATE AND ACCEPTANCE.STIME<=Claim.LossTime)) AND ACCEPTANCE.ExclusiveF=0))     
AND ((dbo.fn_Get_ExtPeriodDate(ACCEPTANCE.ExtPeriod, ACCEPTANCE.ExtPeriodInDaysF, ACCDED.EDATE)>CLAIM.LOSSDATE AND ACCEPTANCE.ExclusiveF=1) or ((dbo.fn_Get_ExtPeriodDate(ACCEPTANCE.ExtPeriod, ACCEPTANCE.ExtPeriodInDaysF, ACCDED.EDATE)>CLAIM.LOSSDATE or (dbo.fn_Get_ExtPeriodDate(ACCEPTANCE.ExtPeriod, ACCEPTANCE.ExtPeriodInDaysF, ACCDED.EDATE)=CLAIM.LOSSDATE AND ACCEPTANCE.STIME>Claim.LossTime)) AND ACCEPTANCE.ExclusiveF=0)) 
AND (RCover.RetroActiveF=1 or (RCalc.SDATE<=CLAIM.LOSSDATE AND ACCEPTANCE.ExclusiveF=1) or ((RCalc.SDATE<CLAIM.LOSSDATE or (RCalc.SDATE=CLAIM.LOSSDATE AND ACCEPTANCE.STIME<=Claim.LossTime)) AND ACCEPTANCE.ExclusiveF=0))     
AND ((dbo.fn_Get_ExtPeriodDate(ACCEPTANCE.ExtPeriod, ACCEPTANCE.ExtPeriodInDaysF, RCalc.EDATE)>CLAIM.LOSSDATE AND ACCEPTANCE.ExclusiveF=1) or ((dbo.fn_Get_ExtPeriodDate(ACCEPTANCE.ExtPeriod, ACCEPTANCE.ExtPeriodInDaysF, RCalc.EDATE)>CLAIM.LOSSDATE or (dbo.fn_Get_ExtPeriodDate(ACCEPTANCE.ExtPeriod, ACCEPTANCE.ExtPeriodInDaysF, RCalc.EDATE)=CLAIM.LOSSDATE AND ACCEPTANCE.STIME>Claim.LossTime)) AND ACCEPTANCE.ExclusiveF=0)) 
AND COL.COL=CLAIM.COL AND ACCDED.TOR=COL.TOR    

GO

IF EXISTS ( SELECT * FROM   sysobjects WHERE  id = object_id(N'BALANCE_ACCASS_ADJUSTMENT') and OBJECTPROPERTY(id, N'IsProcedure') = 1 ) 
BEGIN DROP PROCEDURE BALANCE_ACCASS_ADJUSTMENT
end
GO
CREATE Procedure BALANCE_ACCASS_ADJUSTMENT(@P_ANO integer)     
as     
Select AccAss.*, A2.PDate, A2.PPDate, R.ManualF     
From Acceptance A1   
Inner Join RArrHeader R on (R.ANO=A1.ANO)  
inner join Acceptance A2 on (A2.OANO=A1.OANO)     
inner join AccAss on (AccAss.ANO=A2.ANO)     
Left join Acceptance pA1  on (pA1.ANO=A1.pANO)     
Left join Acceptance pA2  on (pA2.ANO=A2.pANO)     
Where A1.ANO=@P_ANO and A2.ANO<A1.ANO     
and   
(     
 (  
 A2.ANO<=A1.PANO and A1.PDate<=A2.PDate and A1.PPDate>=A2.PPDate and A1.AType='A' and (A2.AType<>'A' and coalesce(pA2.AType,'')<>'A')   
 and AccAss.AdjustableF=1 and AccAss.AdjMethod<>'OVERLIMIT'  
 and NOT EXISTS (Select PANO from Acceptance A3 Where A3.PANO=A2.ANO and A3.Astatus<>'C' and A3.AType='A' and A3.ANO<>@P_ANO)  
 )     
 or   
 (  
 A2.ANO<=A1.PANO and A1.PDate<=A2.PDate and A1.PPDate>=A2.PPDate and A1.AType='A' and (A2.AType<>'A' and coalesce(pA2.AType,'')<>'A')   
 and AccAss.AdjustableF=1 and AccAss.AdjMethod='OVERLIMIT' and A2.PDATE<A2.PPDATE and AccAss.CAmount<>0  
 and NOT EXISTS (Select PANO from Acceptance A3 Where A3.PANO=A2.ANO and A3.Astatus<>'C' and A3.AType='A' and A3.ANO<>@P_ANO)  
 )     
 or    
 (  
 --Cancel All
 A1.AType='C' and pA1.AType<>'A' and A1.EMethod='A' and A2.PDate>=A1.PDate and (coalesce(pA2.pDate,A2.PDate)>=A1.PDate or (coalesce(pA2.pDate,A2.PDate)<A1.PDate and AccAss.CAmount<>0))  
 )     
 or
 (
 --Adjustment Cancel
 A2.ANO=A1.PANO and A1.AType='C' and pA1.AType='A'
 )
)     

GO

IF EXISTS ( SELECT * FROM   sysobjects WHERE  id = object_id(N'QTOC_GENHTAB') and OBJECTPROPERTY(id, N'IsProcedure') = 1 ) 
BEGIN DROP PROCEDURE QSRACC_1
end
GO
CREATE PROCEDURE QSRACC_1 (@P_MO as varchar(10), @P_Segment as varchar(10), @P_Branch as varchar(10), @P_POLICYNO AS VARCHAR(255), @P_CERTIFICATENO VARCHAR(255), @P_STYPE varchar(20)='') 
AS 
SELECT TOP 50 ACCEPTANCE.POLICYNO, ACCEPTANCE.CERTIFICATENO, Acceptance.AID, Acceptance.AName, SysUser.Name as MOName, Acceptance.Branch, Cover.PHolder, COVER.INSURED, Acceptance.TOC, Cover.CoverDate, Cover.ExpDate, RCover.Code, RCover.Coverage, TOC.RegID, 
TOC.Description as TOCDesc, Profile.Name as PHolderName, Profile.Address_1, Profile.Address_2, Profile.Phone_1, Profile.Phone_2, PCalc.Currency, PCalc.TSI, 
Acceptance.LANO, Acceptance.ANO, Acceptance.Source as BSID, Cover.CNO, Cover.ASource, Cover.PolicyType, Cover.ISType, Cover.Segment, Cover.MO, Branch.Name as BranchName, 
Acceptance.TOPRO, TOPRO.Description as TOPRODesc, Acceptance.RefNo 
FROM ACCEPTANCE Left Join (Select RCover.ANO, Max(RCover.Code) as Code, Max(RateTab.Description) as Coverage from RCover, RateTab Where RateTab.Code=RCover.Code and RCover.Category='M' Group By RCover.ANO) RCover on (RCover.ANO=Acceptance.ANO) 
Left join TOPRO on (TOPRO.TOPRO=Acceptance.TOPRO) 
Inner Join Cover on (Cover.CNO=Acceptance.CNO) 
inner join TOC on (TOC.TOC=Acceptance.TOC) 
inner join Profile on (Profile.ID=Cover.PHolder) 
inner join SysUser on (SysUser.ID=Cover.MO) 
inner join Branch on (Branch.Branch=Acceptance.Branch) 
Left Join PCalc on (PCalc.ANO=Acceptance.ANO) 

WHERE ( 
(@P_SType in ('REFERENCE','CLAIM') and ACCEPTANCE.ATYPE Not In ('A','C') And Cover.CStatus<>'C' and ACCEPTANCE.ASTATUS Not in ('W','T') And ACCEPTANCE.PDATE<>ACCEPTANCE.PPDATE)
or 
(@P_SType in ('ENDORSEMENT') and ACCEPTANCE.ATYPE Not In ('A') And ACCEPTANCE.ASTATUS='I')
or 
(@P_SType Not in ('REFERENCE','CLAIM','ENDORSEMENT') and ACCEPTANCE.ATYPE Not In ('A','C') And ACCEPTANCE.ASTATUS='I' And ACCEPTANCE.PDATE<>ACCEPTANCE.PPDATE)
)
And Cover.MO like @P_MO and Cover.Segment Like @P_Segment 
And Acceptance.Branch Like @P_Branch and ACCEPTANCE.POLICYNO LIKE @P_POLICYNO AND ACCEPTANCE.CERTIFICATENO LIKE @P_CERTIFICATENO 
--And Acceptance.ANO<>Acceptance.LANO 
ORDER BY ACCEPTANCE.ANO DESC 
 
GO

IF EXISTS ( SELECT * FROM   sysobjects WHERE  id = object_id(N'QCHECKDECLAREDVALUE') and OBJECTPROPERTY(id, N'IsProcedure') = 1 ) 
BEGIN DROP PROCEDURE QCHECKDECLAREDVALUE 
end
GO
CREATE PROCEDURE QCHECKDECLAREDVALUE (@PCNO AS INTEGER)   
AS
Select SUM(CLLOSS.Estimate/CLLOSS.Rate) as Estimate, SUM(CLLOSS.Amount/CLLOSS.Rate) as Amount, 
MAX(Case When ICOVER.AMOUNT<>0 and ICOVER.AMOUNT_AOE<>0 THEN CLLOSS.DECLARED*ICOVER.AMOUNT_AOE/ICOVER.AMOUNT ELSE CLLOSS.DECLARED END) as DECLARED
from CLLOSS 
INNER JOIN CLAIM ON (CLAIM.CNO=CLLOSS.CNO)
INNER JOIN ACCEPTANCE ON (ACCEPTANCE.ANO=CLAIM.ANO)
INNER JOIN NOCTAB ON (NOCTAB.NOC=CLLOSS.NOC) 
INNER JOIN ICOVER ON (ICOVER.INO=CLLOSS.INO)
LEFT JOIN ICOVERNOC ON (
(ICoverNOC.PCT<>0 or (ICoverNOC.Amount<>0 and ICoverNOC.MaxQty=0)) 
and ICOVERNOC.INO=CLLOSS.INO and ICOVERNOC.NOC=CLLOSS.NOC
AND ((Select Top 1 RCover.RetroActiveF from RCover Where RCover.ANO=Acceptance.ANO Order by RCover.RetroActiveF Desc)=1 or (ICOVERNOC.SDATE<=CLAIM.LossDate AND ACCEPTANCE.ExclusiveF=1) or ((ICOVERNOC.SDATE<CLAIM.LossDate or (ICOVERNOC.SDATE=CLAIM.LossDate AND ACCEPTANCE.STIME<=CLAIM.LossTime)) AND ACCEPTANCE.ExclusiveF=0))                     
AND ((dbo.fn_Get_ExtPeriodDate(ACCEPTANCE.ExtPeriod, ACCEPTANCE.ExtPeriodInDaysF, ICOVERNOC.EDATE)>CLAIM.LossDate AND ACCEPTANCE.ExclusiveF=1) or ((dbo.fn_Get_ExtPeriodDate(ACCEPTANCE.ExtPeriod, ACCEPTANCE.ExtPeriodInDaysF, ICOVERNOC.EDATE)>CLAIM.LossDate or (dbo.fn_Get_ExtPeriodDate(ACCEPTANCE.ExtPeriod, ACCEPTANCE.ExtPeriodInDaysF, ICOVERNOC.EDATE)=CLAIM.LossDate AND ACCEPTANCE.ETIME>CLAIM.LossTime)) AND ACCEPTANCE.ExclusiveF=0))                              
) 
Where CLLOSS.Declared>1 and CLLoss.CNO=@PCNO
and (NOCTAB.SubLimitF=0 or coalesce(ICoverNOC.NOC,'')<>'') 
Group by CLLOSS.CNO, CLLOSS.INO, coalesce(ICoverNOC.NOC,'') 
having SUM(CLLOSS.Estimate/Rate)>MAX(Case When ICOVER.AMOUNT<>0 and ICOVER.AMOUNT_AOE<>0 THEN CLLOSS.DECLARED*ICOVER.AMOUNT_AOE/ICOVER.AMOUNT ELSE CLLOSS.DECLARED END) or SUM(CLLOSS.Amount/Rate)>MAX(Case When ICOVER.AMOUNT<>0 and ICOVER.AMOUNT_AOE<>0 THEN CLLOSS.DECLARED*ICOVER.AMOUNT_AOE/ICOVER.AMOUNT ELSE CLLOSS.DECLARED END)

GO

IF EXISTS ( SELECT * FROM   sysobjects WHERE  id = object_id(N'QPREMIUMAMOUNT') and OBJECTPROPERTY(id, N'IsProcedure') = 1 ) 
BEGIN DROP PROCEDURE QPREMIUMAMOUNT 
end
GO
CREATE PROCEDURE QPREMIUMAMOUNT (@P_ANO AS INTEGER,@P_PDate as smalldatetime)                      

AS                     

Declare @P_APolicyNo as varchar(50)        
Declare @P_WPC as int  
Declare @P_BillDate as smalldatetime  
Declare @P_MinAdmNo as int
Declare @P_MaxAdmNo as int
Declare @P_BackdatedF as bit

Select   
@P_APolicyNo=Max(Case When Cover.OpenFlag=1 and Acceptance.BulkF=0 Then Acceptance.PolicyNo+Case When Acceptance.CertificateNo<>'' Then '-'+Acceptance.CertificateNo else '' end else Acceptance.PolicyNo end),  
@P_WPC=Max(coalesce(APayor.WPC, Payor.WPC)),  
@P_BillDate=  
Max(
dateadd(day,coalesce(APayor.Grace, Payor.Grace),
Case   
When Acceptance.AType='A' Then Acceptance.ADate   
else   
 Case When Cover.OpenFlag=0 Then   
  Case When SysTab.DueByEffectiveF=0 Then coalesce(mAcceptance.ADate,Acceptance.ADate) else coalesce(mAcceptance.PDate,Acceptance.PDate) end  
 else  
  Case When SysTab.DueByEffectiveF=0 Then Acceptance.ADate else Acceptance.PDate end  
 end  
end)
),  
@P_MinAdmNo=Min(coalesce(Admlink.AdmNo,0)),
@P_MaxAdmNo=Max(coalesce(Admlink.AdmNo,0)),
@P_BackdatedF=cast(max(cast(Acceptance.BackDatedF as Int)) as Bit)
from Acceptance   
Left Join Acceptance oAcceptance on (oAcceptance.oANO=Acceptance.OANO and oAcceptance.ANO<=@P_ANO)
Left Join Acceptance mAcceptance on (mAcceptance.ANO=mAcceptance.LANO and mAcceptance.ANO=Acceptance.LANO)  
Left Join APayor on (APayor.ANO=oAcceptance.ANO)  
Left Join Payor on (Payor.ANO=coalesce(mAcceptance.ANO, oAcceptance.ANO))  
Left Join AccAss on (AccAss.ANO=oAcceptance.ANO)
Left Join Admlink on (Admlink.Admno=AccAss.AdmNo and Admlink.Type in ('DI','IC','IR'))
Inner Join Cover on (Cover.CNO=Acceptance.CNO)  
Inner Join SysTab on (1=1)  
Where Acceptance.ANO=@P_ANO                


Select           
@P_BackdatedF as BackdatedF,
sum(Voucher.PremiumAmount) as PremiumAmount,          
coalesce(Min(Voucher.DueDate),dateadd(day,@P_WPC,@P_BillDate)) as DueDate,      
datediff(day,coalesce(Min(Voucher.DueDate),dateadd(day,@P_WPC,@P_BillDate)),@P_PDate) as Lapse,
sum(Voucher.PremiumPaid) as PremiumPaid,          
sum(Voucher.PremiumOutstanding) as PremiumOutstanding,          
@P_WPC as WPC,  
@P_BillDate as BillDate,  
Max(Voucher.PDate) as Date          
From          
(           
	SELECT                      
	DISTINCT  
	nVoucher.Voucher,  
	CASE WHEN nVoucher.DEBTORF=1 THEN (Case When Voucher_Due.Voucher is null then nVoucher.Nominal_CC-nVoucher.Diff_CC else Voucher_Due.AmountDue end) ELSE -(Case When Voucher_Due.Voucher is null then nVoucher.Nominal_CC-nVoucher.Diff_CC else Voucher_Due.AmountDue end) END*nVoucher.RATE as PremiumAmount,                      
	Case When Round(nVoucher.Payment_CC,2)<round((Case When Voucher_Due.Voucher is null then nVoucher.Nominal_CC-nVoucher.Diff_CC else Voucher_Due.AmountDue end),2) Then isnull(Voucher_Due.DueDate, nVoucher.DueDate) else Null end AS DUEDATE,                
	CASE WHEN nVoucher.DEBTORF=1 THEN nVoucher.Nominal_CC-nVOucher.Diff_CC-nVoucher.PAYMENT_CC ELSE -(nVoucher.Nominal_CC-nVOucher.Diff_CC-nVoucher.PAYMENT_CC) END*nVoucher.RATE as PremiumOutstanding,                      
	CASE WHEN nVoucher.DEBTORF=1 THEN nVoucher.PAYMENT_CC ELSE -nVoucher.PAYMENT_CC END*nVoucher.RATE as PremiumPaid,                      
	(Select Max(Case When coalesce(OVoucher.RefDate, pVoucher.RefDate)<coalesce(OVoucher.PDate, pVoucher.PDate) Then coalesce(OVoucher.RefDate, pVoucher.RefDate) else coalesce(OVoucher.PDate, pVoucher.PDate) end)     
	from pSL 
	Inner Join pVoucher on (pVoucher.Voucher=pSL.Voucher)     
	Left Join pVoucher oVoucher on (oVoucher.Voucher=pVoucher.RefNo and oVoucher.SL_Cat='P')     
	Where pSL.PaymentF=1 and pSL.Doc_No=nVoucher.Voucher    
	) as PDate                
	FROM Admlink 
	Inner Join nVoucher on (nVoucher.Voucher=Admlink.Voucher)   
	Left Join Voucher_AmountWPCDue(@P_PDate) Voucher_Due on (Voucher_Due.Voucher=nVoucher.Voucher)          
	Where Admlink.Subject='Premium' and Admlink.Type in ('DI','IC','IR') 
	and Admlink.A_PolicyNo=@P_APolicyNo and Admlink.AdmNo Between @P_MinAdmNo and @P_MaxAdmNo
) Voucher 


GO

IF EXISTS ( SELECT * FROM   sysobjects WHERE  id = object_id(N'BALANCE_ACCASS_ADJUSTMENT') and OBJECTPROPERTY(id, N'IsProcedure') = 1 ) 
BEGIN DROP PROCEDURE BALANCE_ACCASS_ADJUSTMENT
end
GO
CREATE Procedure BALANCE_ACCASS_ADJUSTMENT(@P_ANO integer)     
as     
Select AccAss.*, A2.PDate, A2.PPDate, coalesce(R.ManualF,0) as ManualF     
From Acceptance A1   
Left Join RArrHeader R on (R.ANO=A1.ANO)  
inner join Acceptance A2 on (A2.OANO=A1.OANO)     
inner join AccAss on (AccAss.ANO=A2.ANO)     
Left join Acceptance pA1  on (pA1.ANO=A1.pANO)     
Left join Acceptance pA2  on (pA2.ANO=A2.pANO)     
Where A1.ANO=@P_ANO and A2.ANO<A1.ANO     
and   
(     
 (  
 A2.ANO<=A1.PANO and A1.PDate<=A2.PDate and A1.PPDate>=A2.PPDate and A1.AType='A' and (A2.AType<>'A' and coalesce(pA2.AType,'')<>'A')   
 and AccAss.AdjustableF=1 and AccAss.AdjMethod<>'OVERLIMIT'  
 and NOT EXISTS (Select PANO from Acceptance A3 Where A3.PANO=A2.ANO and A3.Astatus<>'C' and A3.AType='A' and A3.ANO<>@P_ANO)  
 )     
 or   
 (  
 A2.ANO<=A1.PANO and A1.PDate<=A2.PDate and A1.PPDate>=A2.PPDate and A1.AType='A' and (A2.AType<>'A' and coalesce(pA2.AType,'')<>'A')   
 and AccAss.AdjustableF=1 and AccAss.AdjMethod='OVERLIMIT' and A2.PDATE<A2.PPDATE and AccAss.CAmount<>0  
 and NOT EXISTS (Select PANO from Acceptance A3 Where A3.PANO=A2.ANO and A3.Astatus<>'C' and A3.AType='A' and A3.ANO<>@P_ANO)  
 )     
 or    
 (  
 --Cancel All
 A1.AType='C' and pA1.AType<>'A' and A1.EMethod='A' and A2.PDate>=A1.PDate and (coalesce(pA2.pDate,A2.PDate)>=A1.PDate or (coalesce(pA2.pDate,A2.PDate)<A1.PDate and AccAss.CAmount<>0))  
 )     
 or
 (
 --Adjustment Cancel
 A2.ANO=A1.PANO and A1.AType='C' and pA1.AType='A'
 )
)     

GO



IF EXISTS ( SELECT * FROM   sysobjects WHERE  id = object_id(N'QACCBSDET_1') and OBJECTPROPERTY(id, N'IsProcedure') = 1 )
 BEGIN DROP PROCEDURE QACCBSDET_1
end
GO
CREATE Procedure QACCBSDET_1(@P_ANO integer, @P_ID varchar(255), @P_BSType as varchar(10), @P_CODE varchar(255),@P_PERIOD int)
as
SELECT A.ANO, A.ID, A.BSType, A.Code, A.Period, A.Fee, A.FeeAmount/(Select Count(Distinct cast(R.SDATE as varchar(11))+' '+Cast(Case When Ac.AType='A' Then 0 Else I.Adjustable End as varchar(3))) from ICalc R, Acceptance Ac, ICover I Where I.INO=R.INO and Ac.ANO=R.ANO and R.ANO=@P_ANO and R.Code=@P_Code and (A.Period=0 or cast(DateDiff(month, AC.SDATE, R.SDATE) as Integer) / 12 + 1=@P_Period)) as FeeAmount, A.Discount
From AccBSDet A, Acceptance AC
WHERE AC.ANO=@P_ANO and A.ANO=AC.ANO And A.ID=@P_ID And A.BSType=@P_BSType And A.CODE=@P_CODE 
AND (A.PERIOD=0 or A.PERIOD=@P_PERIOD)
GO
GO
IF EXISTS ( SELECT * FROM   sysobjects WHERE  id = object_id(N'QAACCBSDET_1') and OBJECTPROPERTY(id, N'IsProcedure') = 1 ) 
BEGIN DROP PROCEDURE QAACCBSDET_1
end
GO
CREATE Procedure QAACCBSDET_1(@P_ANO integer, @P_ID varchar(255), @P_BSType as varchar(10), @P_CODE varchar(255),@P_PERIOD int)
as
SELECT A.ANO, A.ID, A.BSType, A.Code, A.Period, A.Fee, A.FeeAmount/(Select Count(Distinct cast(R.SDATE as varchar(11))+' '+Cast(Case When Ac.AType='A' Then 0 Else I.Adjustable End as varchar(3))) from ICalc R, Acceptance Ac, ICover I Where I.INO=R.INO and Ac.ANO=R.ANO and R.ANO=@P_ANO and R.Code=@P_Code and (A.Period=0 or cast(DateDiff(month, AC.SDATE, R.SDATE) as Integer) / 12 + 1=@P_Period)) as FeeAmount, A.Discount
From AAccBSDet A, Acceptance AC
WHERE AC.ANO=@P_ANO and A.ANO=AC.ANO And A.ID=@P_ID And A.BSType=@P_BSType And A.CODE=@P_CODE 
AND (A.PERIOD=0 or A.PERIOD=@P_PERIOD)

GO


if exists (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'fn_Calc_Prorata') AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) )
 BEGIN DROP FUNCTION fn_Calc_Prorata
end
GO
CREATE FUNCTION fn_Calc_Prorata(@P_PSDate as smalldatetime, @P_PEDate as smalldatetime, @P_SDate as smalldatetime, @P_EDate as smalldatetime, @P_PPeriod as integer)              
RETURNS Float
AS               
BEGIN              

Declare @P_Prorata as Float
Declare @P_Nominator as Float
Declare @P_Denominator as Float

if @P_PPeriod=2
Begin
	Select @P_Nominator=cast(datediff(Month,@P_PSDate, @P_PEDate) as Float)
	if day(@P_PSDate)>day(@P_PEDate) 
	Begin
		Select @P_Nominator=@P_Nominator-1
			if @P_Nominator<0
				Select @P_Nominator=0
	End

	Select @P_Denominator=cast(datediff(Month,@P_SDate, @P_EDate) as Float)
	if day(@P_SDate)>day(@P_EDate) 
	Begin
		Select @P_Denominator=@P_Denominator-1
			if @P_Denominator<0
				Select @P_Denominator=0
	End
End
Else 
Begin
	if day(@P_PSDate)=day(@P_PEdate) and day(@P_PSDate)=day(@P_Edate) and day(@P_SDate)=day(@P_Edate) and @P_PPeriod<>1 and datediff(month,@P_Sdate,@P_Edate)<>0
	Begin
		Select @P_Nominator=cast(datediff(month,@P_PSDate, @P_PEDate) as Float)
		Select @P_Denominator=cast(datediff(month,@P_SDate, @P_EDate) as Float)
	End
	else
	Begin
		Select @P_Nominator=cast(datediff(day,@P_PSDate, @P_PEDate) as Float)
		Select @P_Denominator=cast(datediff(day,@P_SDate, @P_EDate) as Float)
	End
End

if @P_Nominator<>0 and @P_Denominator<>0
	Select @P_Prorata=@P_Nominator/@P_Denominator
else
	Select @P_Prorata=0

Return @P_Prorata

END  

GO

IF EXISTS ( SELECT * FROM   sysobjects WHERE  id = object_id(N'Facultative_Premium') and OBJECTPROPERTY(id, N'IsProcedure') = 1 )
 BEGIN DROP PROCEDURE Facultative_Premium
end
GO
CREATE Procedure Facultative_Premium(@P_ANO integer,@P_Code varchar(10), @P_CCY varchar(10), @P_SDate smalldatetime, @P_EDate smalldatetime, @P_FID varchar(255),@P_AdjustableF bit)    
as    
Select sum(Premium) as Premium    
From    
(    
	SELECT 
	CASE
	WHEN SUM(FPART.NETRATE)<>0 THEN
		(Case 
		When MAX(FPart.Unit)='F' Then 
			SUM(FPart.NetRate/I.RiskNum*100/coalesce(ISource.Share,100))
		When MAX(FPart.Unit)='M' Then 
			SUM(FPart.NetRate/PCALC.RiskNum/1000*(Case When RArrDet.Limit*100/coalesce(ISource.Share,100)<>0 Then RArrDet.Limit*100/coalesce(ISource.Share,100) else ICALC.TSI end)*ICALC.PCTADJ/100*ICALC.GROSS/PCALC.GROSS) 
		else
			SUM(FPart.NetRate/PCALC.RiskNum/100*(Case When RArrDet.Limit*100/coalesce(ISource.Share,100)<>0 Then RArrDet.Limit*100/coalesce(ISource.Share,100) else ICALC.TSI end)*ICALC.PCTADJ/100*ICALC.GROSS/PCALC.GROSS) 		 
		end)
		*Max((Case When RArrDet.PCalc='P' or datediff(month,RArrDet.SDate, RArrDet.EDate)=0 or Cover.Voyage=1 Then 1 else 12/cast(datediff(month,RArrDet.SDate, RArrDet.EDate) as float) end))
	ELSE
		sum((ICALC.GROSS/PCALC.POGROSS*PCALC.PGROSS)/ICALC.PRORATA) 
	END*MAX(PCalc.Rate) AS PREMIUM

    FROM ICALC, ICOVER, PCALC_ANNUM(@P_ANO) PCALC, FPART, RARRDET, ACCEPTANCE LEFT JOIN ISOURCE ON (ISOURCE.CNO=ACCEPTANCE.CNO), COVER, (Select I.ANO, I.Currency, I.SDate, I.EDate, Count(*) as RiskNum from ICalc I Where I.Gross<>0 and I.ANO=@P_ANO Group By I.ANO, I.Currency, I.SDate, I.EDate) I      
    WHERE RARRDET.ANO=@P_ANO AND RARRDET.FID=@P_FID AND FPART.ANO=RARRDET.ANO AND FPART.FID=RARRDET.FID
    AND ICOVER.INO=ICALC.INO AND (ICOVER.ADJUSTABLE=@P_ADJUSTABLEF OR ACCEPTANCE.ATYPE='A')      
    AND ICALC.ANO=@P_ANO AND ICALC.CURRENCY=@P_CCY      
    AND PCALC.ANO=ICALC.ANO AND PCALC.CODE=ICALC.CODE AND PCALC.SDATE=ICALC.SDATE AND PCALC.EDATE=ICALC.EDATE AND PCALC.INO=ICALC.INO AND PCALC.CURRENCY=ICALC.CURRENCY 
    AND ICALC.SDATE=@P_SDATE AND ICALC.EDATE=@P_EDATE AND ICALC.CODE=@P_CODE      
	AND I.ANO=ICALC.ANO AND I.Currency=ICALC.Currency and I.SDate=ICALC.SDATE and I.EDATE=ICALC.EDATE
    AND ACCEPTANCE.ANO=ICALC.ANO AND COVER.CNO=ACCEPTANCE.CNO      
    AND PCALC.GROSS<>0 AND ICALC.GROSS<>0 
    AND RARRDET.FULLCOVERF=1      
	Group by ICalc.INO
  
	Union All      

	SELECT 
	CASE
	WHEN SUM(FPART.NETRATE)<>0 THEN
		(Case 
		When MAX(FPart.Unit)='F' Then 
			SUM(FPart.NetRate/I.RiskNum*100/coalesce(ISource.Share,100))
		When MAX(FPart.Unit)='M' Then 
			Max(FPart.NetRate/1000*(Case When RArrDet.Limit*100/coalesce(ISource.Share,100)<>0 Then RArrDet.Limit*100/coalesce(ISource.Share,100) else ICALC.TSI end)*ICALC.PCTADJ/100) 
		else 
			Max(FPart.NetRate/100*(Case When RArrDet.Limit*100/coalesce(ISource.Share,100)<>0 Then RArrDet.Limit*100/coalesce(ISource.Share,100) else ICALC.TSI end)*ICALC.PCTADJ/100) 
		end)
		*Max((Case When RArrDet.PCalc='P' or datediff(month,RArrDet.SDate, RArrDet.EDate)=0 or Cover.Voyage=1 Then 1 else 12/cast(datediff(month,RArrDet.SDate, RArrDet.EDate) as float) end))
	ELSE
		sum((ICALC.GROSS/PCALC.POGROSS*PCALC.PGROSS)/ICALC.PRORATA) 
	END*MAX(PCalc.Rate) AS PREMIUM
	
	FROM ICALC, ICOVER, PCALC_ANNUM(@P_ANO) PCALC, FPARTDET FPART, RATECOV, RARRDET, ACCEPTANCE LEFT JOIN ISOURCE ON (ISOURCE.CNO=ACCEPTANCE.CNO), COVER, (Select I.ANO, I.Currency, I.Code, I.SDate, I.EDate, Count(*) as RiskNum from ICalc I Where I.Gross<>0 and I.ANO=@P_ANO and I.Code=@P_Code Group By I.ANO, I.Currency, I.Code, I.SDate, I.EDate) I       
	WHERE RARRDET.ANO=@P_ANO AND RARRDET.FID=@P_FID AND FPART.ANO=RARRDET.ANO AND FPART.FID=RARRDET.FID AND RATECOV.CODE=FPART.CODE
	AND ICOVER.INO=ICALC.INO AND (ICOVER.ADJUSTABLE=@P_ADJUSTABLEF OR ACCEPTANCE.ATYPE='A')      
	AND ICALC.ANO=@P_ANO AND ICALC.CURRENCY=@P_CCY      
	AND PCALC.ANO=ICALC.ANO AND PCALC.CODE=ICALC.CODE AND PCALC.SDATE=ICALC.SDATE AND PCALC.EDATE=ICALC.EDATE AND PCALC.INO=ICALC.INO AND PCALC.CURRENCY=ICALC.CURRENCY 
	AND ICALC.SDATE=@P_SDATE AND ICALC.EDATE=@P_EDATE AND ICALC.CODE=@P_CODE AND ICALC.TOR=RATECOV.TOR
	AND I.ANO=ICALC.ANO AND I.Currency=ICALC.Currency and I.Code=ICalc.Code and I.SDate=ICALC.SDATE and I.EDATE=ICALC.EDATE
	AND ACCEPTANCE.ANO=ICALC.ANO AND COVER.CNO=ACCEPTANCE.CNO      
	AND PCALC.GROSS<>0 AND ICALC.GROSS<>0 
	AND RARRDET.FULLCOVERF=0           
	Group by ICalc.INO
) F    



GO

IF EXISTS ( SELECT * FROM   sysobjects WHERE  id = object_id(N'QRFACDET') and OBJECTPROPERTY(id, N'IsProcedure') = 1 ) 
BEGIN DROP PROCEDURE QRFACDET 
end
GO
Create Procedure QRFACDET (@P_SANO integer, @P_ANO integer,@P_FID varchar(255), @P_CCY varchar(255), @P_SDate DateTime, @P_EDate DateTime, @P_Code varchar(10),@P_AdjustableF bit)      
as      
Select sum(Gross) as Gross
from
(   
	SELECT 
	CASE
	WHEN SUM(FPART.NETRATE)<>0 THEN
		(Case 
		When MAX(FPart.Unit)='F' Then 
			SUM(FPart.NetRate/I.RiskNum*100/coalesce(ISource.Share,100))
		When MAX(FPart.Unit)='M' Then 
			SUM(FPart.NetRate/PCALC.RiskNum/1000*(Case When RArrDet.Limit*100/coalesce(ISource.Share,100)<>0 Then RArrDet.Limit*100/coalesce(ISource.Share,100) else ICALC.TSI end)*ICALC.PCTADJ/100*ICALC.GROSS/PCALC.GROSS) 
		else 
			SUM(FPart.NetRate/PCALC.RiskNum/100*(Case When RArrDet.Limit*100/coalesce(ISource.Share,100)<>0 Then RArrDet.Limit*100/coalesce(ISource.Share,100) else ICALC.TSI end)*ICALC.PCTADJ/100*ICALC.GROSS/PCALC.GROSS) 
		end)
		*Max((Case When RArrDet.PCalc='P' or datediff(month,RArrDet.SDate, RArrDet.EDate)=0 or Cover.Voyage=1 Then 1 else 12/cast(datediff(month,RArrDet.SDate, RArrDet.EDate) as float) end))
	ELSE
		sum((ICALC.GROSS/PCALC.POGROSS*PCALC.PGROSS)/ICALC.PRORATA) 
	END AS GROSS

    FROM ICALC, ICOVER, PCALC_ANNUM(@P_ANO) PCALC, FPART, RARRDET, ACCEPTANCE LEFT JOIN ISOURCE ON (ISOURCE.CNO=ACCEPTANCE.CNO), COVER, (Select I.ANO, I.Currency, I.SDate, I.EDate, Count(*) as RiskNum from ICalc I Where I.Gross<>0 and I.ANO=@P_ANO Group By I.ANO, I.Currency, I.SDate, I.EDate) I      
    WHERE RARRDET.ANO=@P_SANO AND RARRDET.FID=@P_FID AND FPART.ANO=RARRDET.ANO AND FPART.FID=RARRDET.FID
    AND ICOVER.INO=ICALC.INO AND (ICOVER.ADJUSTABLE=@P_ADJUSTABLEF OR ACCEPTANCE.ATYPE='A')      
    AND ICALC.ANO=@P_ANO AND ICALC.CURRENCY=@P_CCY      
    AND PCALC.ANO=ICALC.ANO AND PCALC.CODE=ICALC.CODE AND PCALC.SDATE=ICALC.SDATE AND PCALC.EDATE=ICALC.EDATE AND PCALC.INO=ICALC.INO AND PCALC.CURRENCY=ICALC.CURRENCY 
    AND ICALC.SDATE=@P_SDATE AND ICALC.EDATE=@P_EDATE AND ICALC.CODE=@P_CODE      
	AND I.ANO=ICALC.ANO AND I.Currency=ICALC.Currency and I.SDate=ICALC.SDATE and I.EDATE=ICALC.EDATE
    AND ACCEPTANCE.ANO=ICALC.ANO AND COVER.CNO=ACCEPTANCE.CNO      
    AND PCALC.GROSS<>0 AND ICALC.GROSS<>0 AND RARRDET.STATUS<>'O'      
    AND RARRDET.FULLCOVERF=1      
	Group by ICalc.INO
  
	Union All      

	SELECT 
	CASE
	WHEN SUM(FPART.NETRATE)<>0 THEN
		(Case 
		When MAX(FPart.Unit)='F' Then 
			SUM(FPart.NetRate/I.RiskNum*100/coalesce(ISource.Share,100))
		When MAX(FPart.Unit)='M' Then 
			Max(FPart.NetRate/1000*(Case When RArrDet.Limit*100/coalesce(ISource.Share,100)<>0 Then RArrDet.Limit*100/coalesce(ISource.Share,100) else ICALC.TSI end)*ICALC.PCTADJ/100) 
		else 
			Max(FPart.NetRate/100*(Case When RArrDet.Limit*100/coalesce(ISource.Share,100)<>0 Then RArrDet.Limit*100/coalesce(ISource.Share,100) else ICALC.TSI end)*ICALC.PCTADJ/100) 
		end)
		*Max((Case When RArrDet.PCalc='P' or datediff(month,RArrDet.SDate, RArrDet.EDate)=0 or Cover.Voyage=1 Then 1 else 12/cast(datediff(month,RArrDet.SDate, RArrDet.EDate) as float) end))
	ELSE
		sum((ICALC.GROSS/PCALC.POGROSS*PCALC.PGROSS)/ICALC.PRORATA) 
	END AS GROSS
	
	FROM ICALC, ICOVER, PCALC_ANNUM(@P_ANO) PCALC, FPARTDET FPART, RATECOV, RARRDET, ACCEPTANCE LEFT JOIN ISOURCE ON (ISOURCE.CNO=ACCEPTANCE.CNO), COVER, (Select I.ANO, I.Currency, I.Code, I.SDate, I.EDate, Count(*) as RiskNum from ICalc I Where I.Gross<>0 and I.ANO=@P_ANO and I.Code=@P_Code Group By I.ANO, I.Currency, I.Code, I.SDate, I.EDate) I       
	WHERE RARRDET.ANO=@P_SANO AND RARRDET.FID=@P_FID AND FPART.ANO=RARRDET.ANO AND FPART.FID=RARRDET.FID AND RATECOV.CODE=FPART.CODE
	AND ICOVER.INO=ICALC.INO AND (ICOVER.ADJUSTABLE=@P_ADJUSTABLEF OR ACCEPTANCE.ATYPE='A')      
	AND ICALC.ANO=@P_ANO AND ICALC.CURRENCY=@P_CCY      
	AND PCALC.ANO=ICALC.ANO AND PCALC.CODE=ICALC.CODE AND PCALC.SDATE=ICALC.SDATE AND PCALC.EDATE=ICALC.EDATE AND PCALC.INO=ICALC.INO AND PCALC.CURRENCY=ICALC.CURRENCY 
	AND ICALC.SDATE=@P_SDATE AND ICALC.EDATE=@P_EDATE AND ICALC.CODE=@P_CODE AND ICALC.TOR=RATECOV.TOR
	AND I.ANO=ICALC.ANO AND I.Currency=ICALC.Currency and I.Code=ICalc.Code and I.SDate=ICALC.SDATE and I.EDATE=ICALC.EDATE
	AND ACCEPTANCE.ANO=ICALC.ANO AND COVER.CNO=ACCEPTANCE.CNO      
	AND PCALC.GROSS<>0 AND ICALC.GROSS<>0 AND RARRDET.STATUS<>'O'      
	AND RARRDET.FULLCOVERF=0           
	Group by ICalc.INO
) F  

GO

if exists (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'DISPLAY_FACULTATIVE_CALCULATION') AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) )
 BEGIN DROP FUNCTION DISPLAY_FACULTATIVE_CALCULATION
end
GO
CREATE FUNCTION DISPLAY_FACULTATIVE_CALCULATION(@P_ANO int, @P_FID varchar(20))            
RETURNS TABLE  AS            
RETURN (            
Select A.ANO, CASE WHEN D1.FCODE<>'' THEN D1.FCODE ELSE D1.CODE END Code, D1.SDate, D1.EDate, D1.Gross, D2.Prorata, D1.Currency,  D1.Calculation as Premium_Calculation, D2.Prorata_Calculation,            
D1.Calculation + Case When D2.Prorata=0 or D2.Prorata_Calculation='' Then '' else ' x '+D2.Prorata_Calculation end            
+ Case When A.Qty>1 Then ' x '+ Convert(varchar(25), Cast(A.Qty as Int),1) Else '' end            
+ ' = ' + Convert(varchar(50), Cast(D1.Gross*(Case When D2.Prorata<>0 or D2.Prorata_Calculation<>'' Then D2.Prorata else 1 end)*Case When A.Qty>1 Then A.Qty Else 1 End as Money),1) as Calculation      
from Display_Gross_Facultative_Calculation(@P_ANO, @P_FID) D1, DISPLAY_FACULTATIVE_BALANCE_PRORATA_CALCULATION(@P_ANO, @P_FID) D2, Acceptance A
Where a.ANO = D1.ANO And D1.ANO = D2.ANO And D1.Currency = D2.Currency And D1.Code = D2.Code And D1.SDate = D2.SDate And D1.EDate = D2.EDate and D2.Prorata<>0  
)              
          
GO
if exists (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'DISPLAY_GROSS_FACULTATIVE_CALCULATION') AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) )
 BEGIN DROP FUNCTION DISPLAY_GROSS_FACULTATIVE_CALCULATION
end
GO
CREATE FUNCTION DISPLAY_GROSS_FACULTATIVE_CALCULATION(@P_ANO int, @P_FID Varchar(20))      
RETURNS @PCALC TABLE (ANO Int, Currency varchar(10), Code varchar(10), FCode varchar(10), SDate SmallDateTime, EDate SmallDateTime, Gross Float, Calculation varchar(1024))
AS
BEGIN

DECLARE @ACCEPTANCE TABLE (ANO Int, CNO Int, PANO Int, ATYPE varchar(1), EMethod varchar(1))
INSERT INTO @ACCEPTANCE
SELECT ANO, CNO, PANO, ATYPE, EMethod FROM ACCEPTANCE WHERE ANO=@P_ANO

DECLARE @RARRDET TABLE (ANO Int, FID varchar(20), Limit Float, PCalc varchar(1), SDate SmallDateTime, EDate SmallDateTime, Share Float, FLPCT Float, OnGrossAfterCommF Bit, FullCoverF Bit, NoRefundF Bit)
INSERT INTO @RARRDET
Select ANO, FID, Limit, PCalc, SDate, EDate, Share, FLPCT, OnGrossAfterCommF, FullCoverF, NOREFUNDF FROM RarrDet Where ANO=@P_ANO and FID=@P_FID

Declare @P_FullcoverF Bit
Declare @P_PANO Int

Select @P_PANO=PANO from @ACCEPTANCE 
Select @P_FullcoverF=FullCoverF from @RArrDet


if @P_FullcoverF=1
Begin
	--1
	Insert into @PCALC
	Select ICalc.ANO, ICalc.Currency, ICalc.Code, ICalc.FCode, ICalc.SDate, ICalc.EDate,   
	Gross=    
	Case     
	 When sum(ICalc.NetRate)=0 then    
	  case When Max(ICalc.FLPCT)=0 Then    
		Case When Max(ICalc.Unit)='F' Then
			sum(ICalc.PCTShare/100*ICalc.Gross*(Case When ICalc.OnGrossAfterCommF=1 Then (100-dbo.Premium_Commission(ICalc.ANO, ICalc.Code,0,0))/100 else 1 end)/Icalc.PProrata)*max(ICalc.FacProrata)
		Else
			sum(ICalc.PCTShare/100*ICalc.Gross*(Case When ICalc.OnGrossAfterCommF=1 Then (100-dbo.Premium_Commission(ICalc.ANO, ICalc.Code,0,0))/100 else 1 end)/Icalc.PProrata)*max(ICalc.FacProrata)*max(ICalc.Share)/100    
		End
	  else    
	   sum(ICalc.PCTShare/100*ICalc.Gross*(Case When ICalc.OnGrossAfterCommF=1 Then (100-dbo.Premium_Commission(ICalc.ANO, ICalc.Code,0,0))/100 else 1 end)/Icalc.PProrata)*max(ICalc.FacProrata)    
	  end  
	 else    
	  case When Max(ICalc.FLPCT)=0 Then    
		   Case 
		   When Max(ICalc.Unit)='F' Then
			sum(ICalc.NetRate)*max(ICalc.FacProrata)
		   When Max(ICalc.Unit)='M' Then
			sum(ICalc.PCTShare/100*Icalc.TSI*ICalc.PCTADJ/100)*sum(ICalc.NetRate)/1000*max(ICalc.FacProrata)*max(ICalc.Share)/100   
		   else
			sum(ICalc.PCTShare/100*Icalc.TSI*ICalc.PCTADJ/100)*sum(ICalc.NetRate)/100*max(ICalc.FacProrata)*max(ICalc.Share)/100   			
		   end
	  else    
		   Case 
		   When Max(ICalc.Unit)='F' Then
			sum(ICalc.NetRate)*max(ICalc.FacProrata)       
		   When Max(ICalc.Unit)='M' Then
		    sum(ICalc.PCTShare/100*Icalc.TSI*ICalc.PCTADJ/100)*sum(ICalc.NetRate)/1000*max(ICalc.FacProrata)       
		   else
			sum(ICalc.PCTShare/100*Icalc.TSI*ICalc.PCTADJ/100)*sum(ICalc.NetRate)/100*max(ICalc.FacProrata)       
		   end  
	  end    
	 end,     
	Calculation=      
	Case     
	 When sum(ICalc.NetRate)=0 Then    
	  case When Max(ICalc.FLPCT)=0 Then    
		Case When Max(ICalc.Unit)='F' Then
			   convert(varchar(25), cast(sum(ICalc.PCTShare/100*ICalc.Gross*(Case When ICalc.OnGrossAfterCommF=1 Then (100-dbo.Premium_Commission(ICalc.ANO, ICalc.Code,0,0))/100 else 1 end)/ICalc.PProrata) as Money),1) + Case When max(ICalc.FacProrata_Calculation)='' or Max(ICalc.FacProrata)=1 Then '' Else ' x ' + max(ICalc.FacProrata_Calculation) End
		Else
			convert(varchar(25), cast(sum(ICalc.PCTShare/100*ICalc.Gross*(Case When ICalc.OnGrossAfterCommF=1 Then (100-dbo.Premium_Commission(ICalc.ANO, ICalc.Code,0,0))/100 else 1 end)/ICalc.PProrata) as Money),1) + Case When max(ICalc.FacProrata_Calculation)='' or Max(ICalc.FacProrata)=1 Then '' Else ' x ' + max(ICalc.FacProrata_Calculation) End + ' x '+convert(varchar(25), Max(ICalc.Share),3)+'%'    
		End
	  else    
	   convert(varchar(25), cast(sum(ICalc.PCTShare/100*ICalc.Gross*(Case When ICalc.OnGrossAfterCommF=1 Then (100-dbo.Premium_Commission(ICalc.ANO, ICalc.Code,0,0))/100 else 1 end)/ICalc.PProrata) as Money),1) + Case When max(ICalc.FacProrata_Calculation)='' or Max(ICalc.FacProrata)=1 Then '' Else ' x ' + max(ICalc.FacProrata_Calculation) End    
	  end    
	 else    
	  Case When Max(ICalc.FacProrata*ICalc.NetRateProrata)=1 then    

	   case When Max(ICalc.FLPCT)=0 Then    
			case 
			When Max(ICalc.Unit)='F' Then
				convert(varchar(25), Cast(sum(ICalc.NetRate/ICalc.NetRateProrata) as Money),1) + Case When max(ICalc.FacProrata_Calculation)='' or Max(ICalc.FacProrata*ICalc.NetRateProrata)=1 Then '' Else ' x ' + max(ICalc.FacProrata_Calculation) End 
			When Max(ICalc.Unit)='M' Then
				convert(varchar(25), cast(sum(ICalc.PCTShare/100*Icalc.TSI*ICalc.PCTADJ/100) as Money),1) + ' x '+convert(varchar(25), cast(sum(ICalc.NetRate/ICalc.NetRateProrata) as Money),2)+'‰' + Case When max(ICalc.FacProrata_Calculation)='' or Max(ICalc.FacProrata*ICalc.NetRateProrata)=1 Then '' Else ' x ' + max(ICalc.FacProrata_Calculation) End + ' x '+convert(varchar(25), Max(ICalc.Share),3)+'%'    
			else
				convert(varchar(25), cast(sum(ICalc.PCTShare/100*Icalc.TSI*ICalc.PCTADJ/100) as Money),1) + ' x '+convert(varchar(25), cast(sum(ICalc.NetRate/ICalc.NetRateProrata) as Money),2)+'%' + Case When max(ICalc.FacProrata_Calculation)='' or Max(ICalc.FacProrata*ICalc.NetRateProrata)=1 Then '' Else ' x ' + max(ICalc.FacProrata_Calculation) End + ' x '+convert(varchar(25), Max(ICalc.Share),3)+'%'    
			end
	   else 
			Case 
			When Max(ICalc.Unit)='F' Then		   
				convert(varchar(25), Cast(sum(ICalc.NetRate/ICalc.NetRateProrata) as Money),1) + Case When max(ICalc.FacProrata_Calculation)='' or Max(ICalc.FacProrata*ICalc.NetRateProrata)=1 Then '' Else ' x ' + max(ICalc.FacProrata_Calculation) End     
			When Max(ICalc.Unit)='M' Then		   
				convert(varchar(25), cast(sum(ICalc.PCTShare/100*Icalc.TSI*ICalc.PCTADJ/100) as Money),1) + ' x '+convert(varchar(25), cast(sum(ICalc.NetRate/ICalc.NetRateProrata) as Money),2)+'‰' + Case When max(ICalc.FacProrata_Calculation)='' or Max(ICalc.FacProrata*ICalc.NetRateProrata)=1 Then '' Else ' x ' + max(ICalc.FacProrata_Calculation) End 		
			else
				convert(varchar(25), cast(sum(ICalc.PCTShare/100*Icalc.TSI*ICalc.PCTADJ/100) as Money),1) + ' x '+convert(varchar(25), cast(sum(ICalc.NetRate/ICalc.NetRateProrata) as Money),2)+'%' + Case When max(ICalc.FacProrata_Calculation)='' or Max(ICalc.FacProrata*ICalc.NetRateProrata)=1 Then '' Else ' x ' + max(ICalc.FacProrata_Calculation) End 		
			end
	   end    
	  
	  else    
	   case When Max(ICalc.FLPCT)=0 Then    
			Case 
			When Max(ICalc.Unit)='F' Then
				convert(varchar(25), sum(ICalc.NetRate),1) + Case When max(ICalc.FacProrata_Calculation)='' or Max(ICalc.FacProrata)=1 Then '' Else ' x ' + max(ICalc.FacProrata_Calculation) End
			When Max(ICalc.Unit)='M' Then
				convert(varchar(25), cast(sum(ICalc.PCTShare/100*Icalc.TSI*ICalc.PCTADJ/100) as Money),1) + ' x '+convert(varchar(25), sum(ICalc.NetRate),3)+'‰' + Case When max(ICalc.FacProrata_Calculation)='' or Max(ICalc.FacProrata)=1 Then '' Else ' x ' + max(ICalc.FacProrata_Calculation) End + ' x '+convert(varchar(25), Max(ICalc.Share),3)+'%'    		
			else
				convert(varchar(25), cast(sum(ICalc.PCTShare/100*Icalc.TSI*ICalc.PCTADJ/100) as Money),1) + ' x '+convert(varchar(25), sum(ICalc.NetRate),3)+'%' + Case When max(ICalc.FacProrata_Calculation)='' or Max(ICalc.FacProrata)=1 Then '' Else ' x ' + max(ICalc.FacProrata_Calculation) End + ' x '+convert(varchar(25), Max(ICalc.Share),3)+'%'    		
			end
	   else    
			Case 
			When Max(ICalc.Unit)='F' then
				convert(varchar(25), sum(ICalc.NetRate),1) + Case When max(ICalc.FacProrata_Calculation)='' or Max(ICalc.FacProrata)=1 Then '' Else ' x ' + max(ICalc.FacProrata_Calculation) End     
			When Max(ICalc.Unit)='M' then
				convert(varchar(25), cast(sum(ICalc.PCTShare/100*Icalc.TSI*ICalc.PCTADJ/100) as Money),1) + ' x '+convert(varchar(25), sum(ICalc.NetRate),3)+'‰' + Case When max(ICalc.FacProrata_Calculation)='' or Max(ICalc.FacProrata)=1 Then '' Else ' x ' + max(ICalc.FacProrata_Calculation) End     		
			else
				convert(varchar(25), cast(sum(ICalc.PCTShare/100*Icalc.TSI*ICalc.PCTADJ/100) as Money),1) + ' x '+convert(varchar(25), sum(ICalc.NetRate),3)+'%' + Case When max(ICalc.FacProrata_Calculation)='' or Max(ICalc.FacProrata)=1 Then '' Else ' x ' + max(ICalc.FacProrata_Calculation) End     		
			end
	   end      
	  end    
	 
	 End    
	From      
	(Select ICalc.ANO, ICalc.INO, ICalc.Currency, ICalc.Code, ICalc.Sdate, ICalc.Edate, ICalc.PCTAdj,    
	Max(FPart.Code) as FCode,
	Max(D.FacProrata_Calculation) as FacProrata_calculation,    
	Max(D.FacProrata) as FacProrata,     
	SUM(Case When PCALC.Description<>'' and PCALC.Description<>'Minimum Premium' then ICALC.GROSS*PCALC.GROSS/PCALC.OGROSS else ICALC.GROSS*D.GROSS/D.OGROSS end) AS GROSS,          
	AVG(ICalc.Prorata) as PProrata,     
	Max(PCalc.Ourshare/PCalc.TSI*100) as PCTShare,     
	Max(ICalc.SRate) as SRate,     
	Max((Case When RArrDet.Limit*PCalc.TSI/PCalc.OurShare<>0 Then RArrDet.Limit*PCalc.TSI/PCalc.OurShare else ICalc.TSI end)) as TSI,     
	SUM(ICalc.Rate) as Rate,     
	Max(Case When RArrDet.PCalc='P' or datediff(month,RArrDet.SDate, RArrDet.EDate)=0 or Cover.Voyage=1 Then 1 else 12/cast(datediff(month,RArrDet.SDate, RArrDet.EDate) as float) end) as NetRateProrata,    
	Sum(FPart.NetRate*Case When RArrDet.PCalc='P' or datediff(month,RArrDet.SDate, RArrDet.EDate)=0 or Cover.Voyage=1 Then 1 else 12/cast(datediff(month,RArrDet.SDate, RArrDet.EDate) as float) end/I.RiskNum) as NetRate,    
	Max(FPart.Unit) as Unit,
	Max(RArrDet.Share) as Share,    
	Max(RArrDet.FLPCT) as FLPCT,    
	Max(ICalc.sProrata) as sProrata,  
	Max(Cast(RArrDet.OnGrossAfterCommF as Integer)) as OnGrossAfterCommF  
	from ICalc, PCalc, (Select ANO, Currency, SDate, EDate, Count(*) as RiskNum from ICalc Where Gross<>0 and ANO=@P_ANO Group By ANO, Currency, SDate, EDate) I, DISPLAY_FACULTATIVE_PRORATA_CALCULATION(@P_ANO, @P_FID) D, FPart, @RARRDET RArrDet, @Acceptance Acceptance, Cover    
	Where Acceptance.ANO=@P_ANO and Cover.CNO=Acceptance.CNO and ICalc.ANO=Acceptance.ANO and ICalc.Rate<>0 and PCalc.ANO=ICalc.ANO and PCalc.Currency=ICalc.Currency    
	and I.ANO=ICalc.ANO and I.Currency=ICalc.Currency and I.SDate=ICalc.SDate and I.EDate=ICalc.EDate        
	and D.ANO=ICalc.ANO and D.Currency=ICalc.Currency and D.Code=ICalc.Code and D.SDate=ICalc.Sdate and D.EDate=ICalc.EDate and D.TOR=ICalc.TOR    
	and RArrDet.FullCoverF=1 and RArrDet.ANO=D.ANO and RArrDet.FID=@P_FID and FPart.ANO=RArrDet.ANO and FPart.FID=RArrdet.FID    
	and RArrDet.NoRefundF=0
	Group By ICalc.ANO, ICalc.INO, ICalc.Currency, ICalc.Code, ICalc.SDate, ICalc.EDate, ICalc.PCTAdj    
	) ICalc    
	Group By ICalc.ANO, ICalc.Currency, ICalc.Code, ICalc.FCode, ICalc.SDate, ICalc.EDate, ICalc.SRate, ICalc.sProrata, ICalc.PCTadj      
End
    

--2 (Refund from Endorsement)    
If @P_PANO<>-1 AND @P_FullcoverF=1
BEGIN
	Insert into @PCALC
	Select ICalc.ANO, ICalc.Currency, ICalc.Code, ICalc.FCode, ICalc.SDate, ICalc.EDate,   
	Gross=-    
	Case     
	 When sum(ICalc.NetRate)=0 then    
	  case When Max(ICalc.FLPCT)=0 Then    
		Case When Max(ICalc.Unit)='F' Then
			sum(ICalc.PCTShare/100*ICalc.Gross*(Case When ICalc.OnGrossAfterCommF=1 Then (100-dbo.Premium_Commission(ICalc.ANO, ICalc.Code,0,0))/100 else 1 end)/Icalc.PProrata)*max(ICalc.FacProrata)
		Else
			sum(ICalc.PCTShare/100*ICalc.Gross*(Case When ICalc.OnGrossAfterCommF=1 Then (100-dbo.Premium_Commission(ICalc.ANO, ICalc.Code,0,0))/100 else 1 end)/Icalc.PProrata)*max(ICalc.FacProrata)*max(ICalc.Share)/100    
		End
	  else    
		sum(ICalc.PCTShare/100*ICalc.Gross*(Case When ICalc.OnGrossAfterCommF=1 Then (100-dbo.Premium_Commission(ICalc.ANO, ICalc.Code,0,0))/100 else 1 end)/Icalc.PProrata)*max(ICalc.FacProrata)    
	  end    
	 else    
	  case When Max(ICalc.FLPCT)=0 Then    
		   Case 
		   When Max(ICalc.Unit)='F' Then
			Sum(ICalc.NetRate)*max(ICalc.FacProrata)
		   When Max(ICalc.Unit)='M' Then
		    sum(ICalc.PCTShare/100*Icalc.TSI*ICalc.PCTADJ/100)*Sum(ICalc.NetRate)/1000*max(ICalc.FacProrata)*max(ICalc.Share)/100   
		   else
			sum(ICalc.PCTShare/100*Icalc.TSI*ICalc.PCTADJ/100)*Sum(ICalc.NetRate)/100*max(ICalc.FacProrata)*max(ICalc.Share)/100   
		   end
	  else    
		   Case 
		   When Max(ICalc.Unit)='F' Then
			Sum(ICalc.NetRate)*max(ICalc.FacProrata)       
		   When Max(ICalc.Unit)='M' Then
		    sum(ICalc.PCTShare/100*Icalc.TSI*ICalc.PCTADJ/100)*Sum(ICalc.NetRate)/1000*max(ICalc.FacProrata)       
		   else
			sum(ICalc.PCTShare/100*Icalc.TSI*ICalc.PCTADJ/100)*Sum(ICalc.NetRate)/100*max(ICalc.FacProrata)       
		   end  
	  end  
	 end
	 * Case When Max(ICalc.AType)='C' and Max(ICalc.EMethod)<>'A' and Max(ICalc.CPRefund)<>0 then Max(ICalc.CPRefund)/100 else 1 end,
	Calculation=      
	Case     
	 When Sum(ICalc.NetRate)=0 Then    
	  case When Max(ICalc.FLPCT)=0 Then    
		Case When Max(ICalc.Unit)='F' Then
			'- ' + convert(varchar(25), cast(sum(ICalc.PCTShare/100*ICalc.Gross*(Case When ICalc.OnGrossAfterCommF=1 Then (100-dbo.Premium_Commission(ICalc.ANO, ICalc.Code,0,0))/100 else 1 end)/ICalc.PProrata) as Money),1) + Case When max(ICalc.FacProrata_Calculation)='' or Max(ICalc.FacProrata)=1 Then '' Else ' x ' + max(ICalc.FacProrata_Calculation) End
		Else
			'- ' + convert(varchar(25), cast(sum(ICalc.PCTShare/100*ICalc.Gross*(Case When ICalc.OnGrossAfterCommF=1 Then (100-dbo.Premium_Commission(ICalc.ANO, ICalc.Code,0,0))/100 else 1 end)/ICalc.PProrata) as Money),1) + Case When max(ICalc.FacProrata_Calculation)='' or Max(ICalc.FacProrata)=1 Then '' Else ' x ' + max(ICalc.FacProrata_Calculation) End + ' x '+convert(varchar(25), Max(ICalc.Share),3)+'%'    
		End
	  else    
	   '- ' + convert(varchar(25), cast(sum(ICalc.PCTShare/100*ICalc.Gross*(Case When ICalc.OnGrossAfterCommF=1 Then (100-dbo.Premium_Commission(ICalc.ANO, ICalc.Code,0,0))/100 else 1 end)/ICalc.PProrata) as Money),1) + Case When max(ICalc.FacProrata_Calculation)='' or Max(ICalc.FacProrata)=1 Then '' Else ' x ' + max(ICalc.FacProrata_Calculation) End    
	  end    
	 else    
	  Case When Max(ICalc.FacProrata*ICalc.NetRateProrata)=1 then    
	   case When Max(ICalc.FLPCT)=0 Then    
			case 
			When Max(ICalc.Unit)='F' Then
				'- ' + convert(varchar(25), Cast(Sum(ICalc.NetRate/ICalc.NetRateProrata) as Money),1) + Case When max(ICalc.FacProrata_Calculation)='' or Max(ICalc.FacProrata*ICalc.NetRateProrata)=1 Then '' Else ' x ' + max(ICalc.FacProrata_Calculation) End
			When Max(ICalc.Unit)='M' Then
				'- ' + convert(varchar(25), cast(sum(ICalc.PCTShare/100*Icalc.TSI*ICalc.PCTADJ/100) as Money),1) + ' x '+convert(varchar(25), cast(Sum(ICalc.NetRate/ICalc.NetRateProrata) as Money),2)+'‰' + Case When max(ICalc.FacProrata_Calculation)='' or Max(ICalc.FacProrata*ICalc.NetRateProrata)=1 Then '' Else ' x ' + max(ICalc.FacProrata_Calculation) End + ' x '+convert(varchar(25), Max(ICalc.Share),3)+'%'    
			else
				'- ' + convert(varchar(25), cast(sum(ICalc.PCTShare/100*Icalc.TSI*ICalc.PCTADJ/100) as Money),1) + ' x '+convert(varchar(25), cast(Sum(ICalc.NetRate/ICalc.NetRateProrata) as Money),2)+'%' + Case When max(ICalc.FacProrata_Calculation)='' or Max(ICalc.FacProrata*ICalc.NetRateProrata)=1 Then '' Else ' x ' + max(ICalc.FacProrata_Calculation) End + ' x '+convert(varchar(25), Max(ICalc.Share),3)+'%'    
			end
	   else 
			Case 
			When Max(ICalc.Unit)='F' Then		   
				'- ' + convert(varchar(25), Cast(Sum(ICalc.NetRate/ICalc.NetRateProrata) as Money),1) + Case When max(ICalc.FacProrata_Calculation)='' or Max(ICalc.FacProrata*ICalc.NetRateProrata)=1 Then '' Else ' x ' + max(ICalc.FacProrata_Calculation) End     
			When Max(ICalc.Unit)='M' Then		   
				'- ' + convert(varchar(25), cast(sum(ICalc.PCTShare/100*Icalc.TSI*ICalc.PCTADJ/100) as Money),1) + ' x '+convert(varchar(25), cast(Sum(ICalc.NetRate/ICalc.NetRateProrata) as Money),2)+'‰' + Case When max(ICalc.FacProrata_Calculation)='' or Max(ICalc.FacProrata*ICalc.NetRateProrata)=1 Then '' Else ' x ' + max(ICalc.FacProrata_Calculation) End 		
			else
				'- ' + convert(varchar(25), cast(sum(ICalc.PCTShare/100*Icalc.TSI*ICalc.PCTADJ/100) as Money),1) + ' x '+convert(varchar(25), cast(Sum(ICalc.NetRate/ICalc.NetRateProrata) as Money),2)+'%' + Case When max(ICalc.FacProrata_Calculation)='' or Max(ICalc.FacProrata*ICalc.NetRateProrata)=1 Then '' Else ' x ' + max(ICalc.FacProrata_Calculation) End 		
			end
	   end    
	  else    
	   case When Max(ICalc.FLPCT)=0 Then    
			Case 
			When Max(ICalc.Unit)='F' Then
				'- ' + convert(varchar(25), Sum(ICalc.NetRate),1) + Case When max(ICalc.FacProrata_Calculation)='' or Max(ICalc.FacProrata)=1 Then '' Else ' x ' + max(ICalc.FacProrata_Calculation) End
			When Max(ICalc.Unit)='M' Then
				'- ' + convert(varchar(25), cast(sum(ICalc.PCTShare/100*Icalc.TSI*ICalc.PCTADJ/100) as Money),1) + ' x '+convert(varchar(25), Sum(ICalc.NetRate),3)+'‰' + Case When max(ICalc.FacProrata_Calculation)='' or Max(ICalc.FacProrata)=1 Then '' Else ' x ' + max(ICalc.FacProrata_Calculation) End + ' x '+convert(varchar(25), Max(ICalc.Share),3)+'%'    		
			else
				'- ' + convert(varchar(25), cast(sum(ICalc.PCTShare/100*Icalc.TSI*ICalc.PCTADJ/100) as Money),1) + ' x '+convert(varchar(25), Sum(ICalc.NetRate),3)+'%' + Case When max(ICalc.FacProrata_Calculation)='' or Max(ICalc.FacProrata)=1 Then '' Else ' x ' + max(ICalc.FacProrata_Calculation) End + ' x '+convert(varchar(25), Max(ICalc.Share),3)+'%'    		
			end
	   else    
			Case 
			When Max(ICalc.Unit)='F' then
				'- ' + convert(varchar(25), Sum(ICalc.NetRate),1) + Case When max(ICalc.FacProrata_Calculation)='' or Max(ICalc.FacProrata)=1 Then '' Else ' x ' + max(ICalc.FacProrata_Calculation) End     
			When Max(ICalc.Unit)='M' then
				'- ' + convert(varchar(25), cast(sum(ICalc.PCTShare/100*Icalc.TSI*ICalc.PCTADJ/100) as Money),1) + ' x '+convert(varchar(25), Sum(ICalc.NetRate),3)+'‰' + Case When max(ICalc.FacProrata_Calculation)='' or Max(ICalc.FacProrata)=1 Then '' Else ' x ' + max(ICalc.FacProrata_Calculation) End     		
			else
				'- ' + convert(varchar(25), cast(sum(ICalc.PCTShare/100*Icalc.TSI*ICalc.PCTADJ/100) as Money),1) + ' x '+convert(varchar(25), Sum(ICalc.NetRate),3)+'%' + Case When max(ICalc.FacProrata_Calculation)='' or Max(ICalc.FacProrata)=1 Then '' Else ' x ' + max(ICalc.FacProrata_Calculation) End     		
			end
	   end      
	  end     
	 End    
	  +  
	  Case When Max(ICalc.AType)='C' and Max(ICalc.EMethod)<>'A' and Max(ICalc.CPRefund)<>0 then ' x '+convert(varchar(25),Max(ICalc.CPRefund),3)+'%' else '' end     
	From      
	(Select ICalc.ANO, ICalc.INO, ICalc.Currency, ICalc.Code, ICalc.Sdate, ICalc.Edate, ICalc.PCTAdj,    
	Max(FPart.Code) as FCode,
	Max(D.FacProrata_Calculation) as FacProrata_calculation,    
	Max(D.FacProrata) as FacProrata,     
	SUM(Case When PCALC.Description<>'' and PCALC.Description<>'Minimum Premium' then ICALC.GROSS*PCALC.GROSS/PCALC.OGROSS else ICALC.GROSS*D.GROSS/D.OGROSS end) AS GROSS,          
	AVG(ICalc.Prorata) as PProrata,     
	Max(PCalc.Ourshare/PCalc.TSI*100) as PCTShare,     
	Max(ICalc.SRate) as SRate,     
	Max((Case When RArrDet.Limit*PCalc.TSI/PCalc.OurShare<>0 Then RArrDet.Limit*PCalc.TSI/PCalc.OurShare else ICalc.TSI end)) as TSI,     
	SUM(ICalc.Rate) as Rate,     
	Max(Case When RArrDet.PCalc='P' or datediff(month,RArrDet.SDate, RArrDet.EDate)=0 or Cover.Voyage=1 Then 1 else 12/cast(datediff(month,RArrDet.SDate, RArrDet.EDate) as float) end) as NetRateProrata,    
	Sum(FPart.NetRate*Case When RArrDet.PCalc='P' or datediff(month,RArrDet.SDate, RArrDet.EDate)=0 or Cover.Voyage=1 Then 1 else 12/cast(datediff(month,RArrDet.SDate, RArrDet.EDate) as float) end/I.RiskNum) as NetRate,    
	Max(FPart.Unit) as Unit,
	Max(RArrDet.Share) as Share,    
	Max(RArrDet.FLPCT) as FLPCT,    
	Max(RArrDet.CPRefund) as CPRefund,
	Max(pAcceptance.AType) as AType,
	Max(pAcceptance.EMethod) as EMethod,
	Max(ICalc.sProrata) as sProrata,  
	Max(Cast(RArrDet.OnGrossAfterCommF as Integer)) as OnGrossAfterCommF  
	from ICalc, PCalc, (Select I.ANO, I.Currency, I.SDate, I.EDate, Count(*) as RiskNum from ICalc I, Acceptance A Where I.Gross<>0 and I.ANO=A.PANO and A.ANO=@P_ANO Group By I.ANO, I.Currency, I.SDate, I.EDate) I, DISPLAY_FACULTATIVE_PRORATA_CALCULATION(@P_ANO, @P_FID) D, FPart, RArrDet, @RARRDET pRArrDet, @Acceptance pAcceptance, Acceptance, Cover    
	Where pAcceptance.ANO=@P_ANO and Acceptance.ANO=pAcceptance.PANO and Cover.CNO=Acceptance.CNO and ICalc.ANO=Acceptance.ANO and ICalc.Rate<>0 and PCalc.ANO=ICalc.ANO and PCalc.Currency=ICalc.Currency    
	and I.ANO=ICalc.ANO and I.Currency=ICalc.Currency and I.SDate=ICalc.SDate and I.EDate=ICalc.EDate        
	and D.ANO=ICalc.ANO and D.Currency=ICalc.Currency and D.Code=ICalc.Code and D.SDate=ICalc.Sdate and D.EDate=ICalc.EDate and D.TOR=ICalc.TOR    
	and RArrDet.Status in ('A','R') and RArrDet.FullCoverF=1 and RArrDet.ANO=D.ANO and RArrDet.FID=@P_FID and FPart.ANO=RArrDet.ANO and FPart.FID=RArrdet.FID    
	and pRArrDet.ANO=pAcceptance.ANO and pRArrDet.FID=@P_FID and pRArrDet.NoRefundF=0
	Group By ICalc.ANO, ICalc.INO, ICalc.Currency, ICalc.Code, ICalc.SDate, ICalc.EDate, ICalc.PCTAdj    
	) ICalc    
	Group By ICalc.ANO, ICalc.Currency, ICalc.Code, ICalc.FCode, ICalc.SDate, ICalc.EDate, ICalc.SRate, ICalc.sProrata, ICalc.PCTadj                  
End

--3 Detail    
IF @P_FullcoverF=0
BEGIN
	Insert into @PCALC
	Select ICalc.ANO, ICalc.Currency, ICalc.Code, ICalc.FCode, ICalc.SDate, ICalc.EDate,   
	Gross=    
	Case     
	 When sum(ICalc.NetRate)=0 then    
	  case When Max(ICalc.FLPCT)=0 Then    
		Case When Max(ICalc.Unit)='F' Then
			sum(ICalc.PCTShare/100*ICalc.Gross*(Case When ICalc.OnGrossAfterCommF=1 Then (100-dbo.Premium_Commission(ICalc.ANO, ICalc.Code,0,0))/100 else 1 end)/Icalc.PProrata)*max(ICalc.FacProrata)
		Else
			sum(ICalc.PCTShare/100*ICalc.Gross*(Case When ICalc.OnGrossAfterCommF=1 Then (100-dbo.Premium_Commission(ICalc.ANO, ICalc.Code,0,0))/100 else 1 end)/Icalc.PProrata)*max(ICalc.FacProrata)*max(ICalc.Share)/100    
		End
	  else    
	   sum(ICalc.PCTShare/100*ICalc.Gross*(Case When ICalc.OnGrossAfterCommF=1 Then (100-dbo.Premium_Commission(ICalc.ANO, ICalc.Code,0,0))/100 else 1 end)/Icalc.PProrata)*max(ICalc.FacProrata)    
	  end  
	 else    
	  case When Max(ICalc.FLPCT)=0 Then    
		   Case 
		   When Max(ICalc.Unit)='F' Then
			sum(ICalc.NetRate)*max(ICalc.FacProrata)
		   When Max(ICalc.Unit)='M' Then
		    sum(ICalc.PCTShare/100*Icalc.TSI*ICalc.PCTADJ/100)*sum(ICalc.NetRate)/1000*max(ICalc.FacProrata)*max(ICalc.Share)/100   
		   else
			sum(ICalc.PCTShare/100*Icalc.TSI*ICalc.PCTADJ/100)*sum(ICalc.NetRate)/100*max(ICalc.FacProrata)*max(ICalc.Share)/100   
		   end
	  else    
		   Case 
		   When Max(ICalc.Unit)='F' Then
			sum(ICalc.NetRate)*max(ICalc.FacProrata)       
		   When Max(ICalc.Unit)='M' Then
		    sum(ICalc.PCTShare/100*Icalc.TSI*ICalc.PCTADJ/100)*sum(ICalc.NetRate)/1000*max(ICalc.FacProrata)       
		   else
			sum(ICalc.PCTShare/100*Icalc.TSI*ICalc.PCTADJ/100)*sum(ICalc.NetRate)/100*max(ICalc.FacProrata)       
		   end  
	  end    
	 end,     
	Calculation=      
	Case     
	 When sum(ICalc.NetRate)=0 Then    
	  case When Max(ICalc.FLPCT)=0 Then    
		Case When Max(ICalc.Unit)='F' Then
			   convert(varchar(25), cast(sum(ICalc.PCTShare/100*ICalc.Gross*(Case When ICalc.OnGrossAfterCommF=1 Then (100-dbo.Premium_Commission(ICalc.ANO, ICalc.Code,0,0))/100 else 1 end)/ICalc.PProrata) as Money),1) + Case When max(ICalc.FacProrata_Calculation)='' or Max(ICalc.FacProrata)=1 Then '' Else ' x ' + max(ICalc.FacProrata_Calculation) End
		Else
			convert(varchar(25), cast(sum(ICalc.PCTShare/100*ICalc.Gross*(Case When ICalc.OnGrossAfterCommF=1 Then (100-dbo.Premium_Commission(ICalc.ANO, ICalc.Code,0,0))/100 else 1 end)/ICalc.PProrata) as Money),1) + Case When max(ICalc.FacProrata_Calculation)='' or Max(ICalc.FacProrata)=1 Then '' Else ' x ' + max(ICalc.FacProrata_Calculation) End + ' x '+convert(varchar(25), Max(ICalc.Share),3)+'%'    
		End
	  else    
	   convert(varchar(25), cast(sum(ICalc.PCTShare/100*ICalc.Gross*(Case When ICalc.OnGrossAfterCommF=1 Then (100-dbo.Premium_Commission(ICalc.ANO, ICalc.Code,0,0))/100 else 1 end)/ICalc.PProrata) as Money),1) + Case When max(ICalc.FacProrata_Calculation)='' or Max(ICalc.FacProrata)=1 Then '' Else ' x ' + max(ICalc.FacProrata_Calculation) End    
	  end    
	 else    
	  Case When Max(ICalc.FacProrata*ICalc.NetRateProrata)=1 then    

	   case When Max(ICalc.FLPCT)=0 Then    
			case 
			When Max(ICalc.Unit)='F' Then
				convert(varchar(25), Cast(sum(ICalc.NetRate/ICalc.NetRateProrata) as Money),1) + Case When max(ICalc.FacProrata_Calculation)='' or Max(ICalc.FacProrata*ICalc.NetRateProrata)=1 Then '' Else ' x ' + max(ICalc.FacProrata_Calculation) End 
			When Max(ICalc.Unit)='M' Then
				convert(varchar(25), cast(sum(ICalc.PCTShare/100*Icalc.TSI*ICalc.PCTADJ/100) as Money),1) + ' x '+convert(varchar(25), cast(sum(ICalc.NetRate/ICalc.NetRateProrata) as Money),2)+'‰' + Case When max(ICalc.FacProrata_Calculation)='' or Max(ICalc.FacProrata*ICalc.NetRateProrata)=1 Then '' Else ' x ' + max(ICalc.FacProrata_Calculation) End + ' x '+convert(varchar(25), Max(ICalc.Share),3)+'%'    
			else
				convert(varchar(25), cast(sum(ICalc.PCTShare/100*Icalc.TSI*ICalc.PCTADJ/100) as Money),1) + ' x '+convert(varchar(25), cast(sum(ICalc.NetRate/ICalc.NetRateProrata) as Money),2)+'%' + Case When max(ICalc.FacProrata_Calculation)='' or Max(ICalc.FacProrata*ICalc.NetRateProrata)=1 Then '' Else ' x ' + max(ICalc.FacProrata_Calculation) End + ' x '+convert(varchar(25), Max(ICalc.Share),3)+'%'    
			end
	   else 
			Case 
			When Max(ICalc.Unit)='F' Then		   
				convert(varchar(25), Cast(sum(ICalc.NetRate/ICalc.NetRateProrata) as Money),1) + Case When max(ICalc.FacProrata_Calculation)='' or Max(ICalc.FacProrata*ICalc.NetRateProrata)=1 Then '' Else ' x ' + max(ICalc.FacProrata_Calculation) End     
			When Max(ICalc.Unit)='M' Then		   
				convert(varchar(25), cast(sum(ICalc.PCTShare/100*Icalc.TSI*ICalc.PCTADJ/100) as Money),1) + ' x '+convert(varchar(25), cast(sum(ICalc.NetRate/ICalc.NetRateProrata) as Money),2)+'‰' + Case When max(ICalc.FacProrata_Calculation)='' or Max(ICalc.FacProrata*ICalc.NetRateProrata)=1 Then '' Else ' x ' + max(ICalc.FacProrata_Calculation) End 		
			else
				convert(varchar(25), cast(sum(ICalc.PCTShare/100*Icalc.TSI*ICalc.PCTADJ/100) as Money),1) + ' x '+convert(varchar(25), cast(sum(ICalc.NetRate/ICalc.NetRateProrata) as Money),2)+'%' + Case When max(ICalc.FacProrata_Calculation)='' or Max(ICalc.FacProrata*ICalc.NetRateProrata)=1 Then '' Else ' x ' + max(ICalc.FacProrata_Calculation) End 		
			end
	   end    
	  
	  else    
	   case When Max(ICalc.FLPCT)=0 Then    
			Case 
			When Max(ICalc.Unit)='F' Then
				convert(varchar(25), sum(ICalc.NetRate),1) + Case When max(ICalc.FacProrata_Calculation)='' or Max(ICalc.FacProrata)=1 Then '' Else ' x ' + max(ICalc.FacProrata_Calculation) End
			When Max(ICalc.Unit)='M' Then
				convert(varchar(25), cast(sum(ICalc.PCTShare/100*Icalc.TSI*ICalc.PCTADJ/100) as Money),1) + ' x '+convert(varchar(25), sum(ICalc.NetRate),3)+'‰' + Case When max(ICalc.FacProrata_Calculation)='' or Max(ICalc.FacProrata)=1 Then '' Else ' x ' + max(ICalc.FacProrata_Calculation) End + ' x '+convert(varchar(25), Max(ICalc.Share),3)+'%'    		
			else
				convert(varchar(25), cast(sum(ICalc.PCTShare/100*Icalc.TSI*ICalc.PCTADJ/100) as Money),1) + ' x '+convert(varchar(25), sum(ICalc.NetRate),3)+'%' + Case When max(ICalc.FacProrata_Calculation)='' or Max(ICalc.FacProrata)=1 Then '' Else ' x ' + max(ICalc.FacProrata_Calculation) End + ' x '+convert(varchar(25), Max(ICalc.Share),3)+'%'    		
			end
	   else    
			Case 
			When Max(ICalc.Unit)='F' then
				convert(varchar(25), sum(ICalc.NetRate),1) + Case When max(ICalc.FacProrata_Calculation)='' or Max(ICalc.FacProrata)=1 Then '' Else ' x ' + max(ICalc.FacProrata_Calculation) End     
			When Max(ICalc.Unit)='M' then
				convert(varchar(25), cast(sum(ICalc.PCTShare/100*Icalc.TSI*ICalc.PCTADJ/100) as Money),1) + ' x '+convert(varchar(25), sum(ICalc.NetRate),3)+'‰' + Case When max(ICalc.FacProrata_Calculation)='' or Max(ICalc.FacProrata)=1 Then '' Else ' x ' + max(ICalc.FacProrata_Calculation) End     		
			else
				convert(varchar(25), cast(sum(ICalc.PCTShare/100*Icalc.TSI*ICalc.PCTADJ/100) as Money),1) + ' x '+convert(varchar(25), sum(ICalc.NetRate),3)+'%' + Case When max(ICalc.FacProrata_Calculation)='' or Max(ICalc.FacProrata)=1 Then '' Else ' x ' + max(ICalc.FacProrata_Calculation) End     		
			end
	   end      
	  end    
	 
	 End    
	From      
	(Select ICalc.ANO, ICalc.INO, ICalc.Currency, ICalc.Code, ICalc.Sdate, ICalc.Edate, ICalc.PCTAdj,    
	Max(FPart.Code) as FCode,
	Max(D.FacProrata_Calculation) as FacProrata_calculation,    
	Max(D.FacProrata) as FacProrata,     
	SUM(Case When PCALC.Description<>'' and PCALC.Description<>'Minimum Premium' then ICALC.GROSS*PCALC.GROSS/PCALC.OGROSS else ICALC.GROSS*D.GROSS/D.OGROSS end) AS GROSS,          
	AVG(ICalc.Prorata) as PProrata,     
	Max(PCalc.Ourshare/PCalc.TSI*100) as PCTShare,     
	Max(ICalc.SRate) as SRate,     
	Max((Case When RArrDet.Limit*PCalc.TSI/PCalc.OurShare<>0 Then RArrDet.Limit*PCalc.TSI/PCalc.OurShare else ICalc.TSI end)) as TSI,     
	SUM(ICalc.Rate) as Rate,     
	Max(Case When RArrDet.PCalc='P' or datediff(month,RArrDet.SDate, RArrDet.EDate)=0 or Cover.Voyage=1 Then 1 else 12/cast(datediff(month,RArrDet.SDate, RArrDet.EDate) as float) end) as NetRateProrata,    
	Max(FPart.NetRate*Case When RArrDet.PCalc='P' or datediff(month,RArrDet.SDate, RArrDet.EDate)=0 or Cover.Voyage=1 Then 1 else 12/cast(datediff(month,RArrDet.SDate, RArrDet.EDate) as float) end) as NetRate,    
	Max(FPart.Unit) as Unit,
	Max(RArrDet.Share) as Share,    
	Max(RArrDet.FLPCT) as FLPCT,    
	Max(ICalc.sProrata) as sProrata,  
	Max(Cast(RArrDet.OnGrossAfterCommF as Integer)) as OnGrossAfterCommF  
	from ICalc, PCalc, DISPLAY_FACULTATIVE_PRORATA_CALCULATION(@P_ANO, @P_FID) D, FPartDet FPart, RateCov, @RARRDET RArrDet, @Acceptance Acceptance, Cover    
	Where Acceptance.ANO=@P_ANO and Cover.CNO=Acceptance.CNO and ICalc.ANO=Acceptance.ANO and ICalc.Rate<>0 and PCalc.ANO=ICalc.ANO and PCalc.Currency=ICalc.Currency    
	and D.ANO=ICalc.ANO and D.Currency=ICalc.Currency and D.SDate=ICalc.Sdate and D.EDate=ICalc.EDate and D.TOR=ICalc.TOR    
	and RArrDet.FullCoverF=0 and RArrDet.ANO=D.ANO 
	and RArrDet.FID=@P_FID and FPart.ANO=RArrDet.ANO and FPart.FID=RArrdet.FID and RateCov.Code=FPart.Code and RateCov.TOR=ICalc.TOR
	and RArrDet.NoRefundF=0
	Group By ICalc.ANO, ICalc.INO, ICalc.Currency, ICalc.Code, ICalc.SDate, ICalc.EDate, ICalc.PCTAdj 
	) ICalc    
	Group By ICalc.ANO, ICalc.Currency, ICalc.Code, ICalc.FCode, ICalc.SDate, ICalc.EDate, ICalc.SRate, ICalc.sProrata, ICalc.PCTadj      
END

--4 Refund/Endorsement Detail    
IF @P_PANO<>-1 AND @P_FullcoverF=0    
BEGIN
	Insert into @PCALC
	Select ICalc.ANO, ICalc.Currency, ICalc.Code, ICalc.FCode, ICalc.SDate, ICalc.EDate,   
	Gross=-    
	Case     
	 When sum(ICalc.NetRate)=0 then    
	  case When Max(ICalc.FLPCT)=0 Then    
		Case When Max(ICalc.Unit)='F' Then
			sum(ICalc.PCTShare/100*ICalc.Gross*(Case When ICalc.OnGrossAfterCommF=1 Then (100-dbo.Premium_Commission(ICalc.ANO, ICalc.Code,0,0))/100 else 1 end)/Icalc.PProrata)*max(ICalc.FacProrata)
		Else
			sum(ICalc.PCTShare/100*ICalc.Gross*(Case When ICalc.OnGrossAfterCommF=1 Then (100-dbo.Premium_Commission(ICalc.ANO, ICalc.Code,0,0))/100 else 1 end)/Icalc.PProrata)*max(ICalc.FacProrata)*max(ICalc.Share)/100    
		End
	  else    
		sum(ICalc.PCTShare/100*ICalc.Gross*(Case When ICalc.OnGrossAfterCommF=1 Then (100-dbo.Premium_Commission(ICalc.ANO, ICalc.Code,0,0))/100 else 1 end)/Icalc.PProrata)*max(ICalc.FacProrata)    
	  end    
	 else    
	  case When Max(ICalc.FLPCT)=0 Then    
		   Case 
		   When Max(ICalc.Unit)='F' Then
			Sum(ICalc.NetRate)*max(ICalc.FacProrata)
		   When Max(ICalc.Unit)='M' Then
		    sum(ICalc.PCTShare/100*Icalc.TSI*ICalc.PCTADJ/100)*Sum(ICalc.NetRate)/1000*max(ICalc.FacProrata)*max(ICalc.Share)/100   
		   else
			sum(ICalc.PCTShare/100*Icalc.TSI*ICalc.PCTADJ/100)*Sum(ICalc.NetRate)/100*max(ICalc.FacProrata)*max(ICalc.Share)/100   
		   end
	  else    
		   Case 
		   When Max(ICalc.Unit)='F' Then
			Sum(ICalc.NetRate)*max(ICalc.FacProrata)       
		   When Max(ICalc.Unit)='M' Then
		    sum(ICalc.PCTShare/100*Icalc.TSI*ICalc.PCTADJ/100)*Sum(ICalc.NetRate)/1000*max(ICalc.FacProrata)       
		   else
			sum(ICalc.PCTShare/100*Icalc.TSI*ICalc.PCTADJ/100)*Sum(ICalc.NetRate)/100*max(ICalc.FacProrata)       
		   end  
	  end  
	 end
	 * Case When Max(ICalc.AType)='C' and Max(ICalc.EMethod)<>'A' and Max(ICalc.CPRefund)<>0 then Max(ICalc.CPRefund)/100 else 1 end,
	Calculation=      
	Case     
	 When Sum(ICalc.NetRate)=0 Then    
	  case When Max(ICalc.FLPCT)=0 Then    
		Case When Max(ICalc.Unit)='F' Then
			'- ' + convert(varchar(25), cast(sum(ICalc.PCTShare/100*ICalc.Gross*(Case When ICalc.OnGrossAfterCommF=1 Then (100-dbo.Premium_Commission(ICalc.ANO, ICalc.Code,0,0))/100 else 1 end)/ICalc.PProrata) as Money),1) + Case When max(ICalc.FacProrata_Calculation)='' or Max(ICalc.FacProrata)=1 Then '' Else ' x ' + max(ICalc.FacProrata_Calculation) End
		Else
			'- ' + convert(varchar(25), cast(sum(ICalc.PCTShare/100*ICalc.Gross*(Case When ICalc.OnGrossAfterCommF=1 Then (100-dbo.Premium_Commission(ICalc.ANO, ICalc.Code,0,0))/100 else 1 end)/ICalc.PProrata) as Money),1) + Case When max(ICalc.FacProrata_Calculation)='' or Max(ICalc.FacProrata)=1 Then '' Else ' x ' + max(ICalc.FacProrata_Calculation) End + ' x '+convert(varchar(25), Max(ICalc.Share),3)+'%'    
		End
	  else    
	   '- ' + convert(varchar(25), cast(sum(ICalc.PCTShare/100*ICalc.Gross*(Case When ICalc.OnGrossAfterCommF=1 Then (100-dbo.Premium_Commission(ICalc.ANO, ICalc.Code,0,0))/100 else 1 end)/ICalc.PProrata) as Money),1) + Case When max(ICalc.FacProrata_Calculation)='' or Max(ICalc.FacProrata)=1 Then '' Else ' x ' + max(ICalc.FacProrata_Calculation) End    
	  end    
	 else    
	  Case When Max(ICalc.FacProrata*ICalc.NetRateProrata)=1 then    
	   case When Max(ICalc.FLPCT)=0 Then    
			case 
			When Max(ICalc.Unit)='F' Then
				'- ' + convert(varchar(25), Cast(Sum(ICalc.NetRate/ICalc.NetRateProrata) as Money),1) + Case When max(ICalc.FacProrata_Calculation)='' or Max(ICalc.FacProrata*ICalc.NetRateProrata)=1 Then '' Else ' x ' + max(ICalc.FacProrata_Calculation) End
			When Max(ICalc.Unit)='M' Then
				'- ' + convert(varchar(25), cast(sum(ICalc.PCTShare/100*Icalc.TSI*ICalc.PCTADJ/100) as Money),1) + ' x '+convert(varchar(25), cast(Sum(ICalc.NetRate/ICalc.NetRateProrata) as Money),2)+'‰' + Case When max(ICalc.FacProrata_Calculation)='' or Max(ICalc.FacProrata*ICalc.NetRateProrata)=1 Then '' Else ' x ' + max(ICalc.FacProrata_Calculation) End + ' x '+convert(varchar(25), Max(ICalc.Share),3)+'%'    
			else
				'- ' + convert(varchar(25), cast(sum(ICalc.PCTShare/100*Icalc.TSI*ICalc.PCTADJ/100) as Money),1) + ' x '+convert(varchar(25), cast(Sum(ICalc.NetRate/ICalc.NetRateProrata) as Money),2)+'%' + Case When max(ICalc.FacProrata_Calculation)='' or Max(ICalc.FacProrata*ICalc.NetRateProrata)=1 Then '' Else ' x ' + max(ICalc.FacProrata_Calculation) End + ' x '+convert(varchar(25), Max(ICalc.Share),3)+'%'    
			end
	   else 
			Case 
			When Max(ICalc.Unit)='F' Then		   
				'- ' + convert(varchar(25), Cast(Sum(ICalc.NetRate/ICalc.NetRateProrata) as Money),1) + Case When max(ICalc.FacProrata_Calculation)='' or Max(ICalc.FacProrata*ICalc.NetRateProrata)=1 Then '' Else ' x ' + max(ICalc.FacProrata_Calculation) End     
			When Max(ICalc.Unit)='M' Then		   
				'- ' + convert(varchar(25), cast(sum(ICalc.PCTShare/100*Icalc.TSI*ICalc.PCTADJ/100) as Money),1) + ' x '+convert(varchar(25), cast(Sum(ICalc.NetRate/ICalc.NetRateProrata) as Money),2)+'‰' + Case When max(ICalc.FacProrata_Calculation)='' or Max(ICalc.FacProrata*ICalc.NetRateProrata)=1 Then '' Else ' x ' + max(ICalc.FacProrata_Calculation) End 		
			else
				'- ' + convert(varchar(25), cast(sum(ICalc.PCTShare/100*Icalc.TSI*ICalc.PCTADJ/100) as Money),1) + ' x '+convert(varchar(25), cast(Sum(ICalc.NetRate/ICalc.NetRateProrata) as Money),2)+'%' + Case When max(ICalc.FacProrata_Calculation)='' or Max(ICalc.FacProrata*ICalc.NetRateProrata)=1 Then '' Else ' x ' + max(ICalc.FacProrata_Calculation) End 		
			end
	   end    
	  else    
	   case When Max(ICalc.FLPCT)=0 Then    
			Case 
			When Max(ICalc.Unit)='F' Then
				'- ' + convert(varchar(25), Sum(ICalc.NetRate),1) + Case When max(ICalc.FacProrata_Calculation)='' or Max(ICalc.FacProrata)=1 Then '' Else ' x ' + max(ICalc.FacProrata_Calculation) End
			When Max(ICalc.Unit)='M' Then
				'- ' + convert(varchar(25), cast(sum(ICalc.PCTShare/100*Icalc.TSI*ICalc.PCTADJ/100) as Money),1) + ' x '+convert(varchar(25), Sum(ICalc.NetRate),3)+'‰' + Case When max(ICalc.FacProrata_Calculation)='' or Max(ICalc.FacProrata)=1 Then '' Else ' x ' + max(ICalc.FacProrata_Calculation) End + ' x '+convert(varchar(25), Max(ICalc.Share),3)+'%'    		
			else
				'- ' + convert(varchar(25), cast(sum(ICalc.PCTShare/100*Icalc.TSI*ICalc.PCTADJ/100) as Money),1) + ' x '+convert(varchar(25), Sum(ICalc.NetRate),3)+'%' + Case When max(ICalc.FacProrata_Calculation)='' or Max(ICalc.FacProrata)=1 Then '' Else ' x ' + max(ICalc.FacProrata_Calculation) End + ' x '+convert(varchar(25), Max(ICalc.Share),3)+'%'    		
			end
	   else    
			Case 
			When Max(ICalc.Unit)='F' then
				'- ' + convert(varchar(25), Sum(ICalc.NetRate),1) + Case When max(ICalc.FacProrata_Calculation)='' or Max(ICalc.FacProrata)=1 Then '' Else ' x ' + max(ICalc.FacProrata_Calculation) End     
			When Max(ICalc.Unit)='M' then
				'- ' + convert(varchar(25), cast(sum(ICalc.PCTShare/100*Icalc.TSI*ICalc.PCTADJ/100) as Money),1) + ' x '+convert(varchar(25), Sum(ICalc.NetRate),3)+'‰' + Case When max(ICalc.FacProrata_Calculation)='' or Max(ICalc.FacProrata)=1 Then '' Else ' x ' + max(ICalc.FacProrata_Calculation) End     		
			else
				'- ' + convert(varchar(25), cast(sum(ICalc.PCTShare/100*Icalc.TSI*ICalc.PCTADJ/100) as Money),1) + ' x '+convert(varchar(25), Sum(ICalc.NetRate),3)+'%' + Case When max(ICalc.FacProrata_Calculation)='' or Max(ICalc.FacProrata)=1 Then '' Else ' x ' + max(ICalc.FacProrata_Calculation) End     		
			end
	   end      
	  end     
	 End    
	  +  
	  Case When Max(ICalc.AType)='C' and Max(ICalc.EMethod)<>'A' and Max(ICalc.CPRefund)<>0 then ' x '+convert(varchar(25),Max(ICalc.CPRefund),3)+'%' else '' end     
	From      
	(Select ICalc.ANO, ICalc.INO, ICalc.Currency, ICalc.Code, ICalc.Sdate, ICalc.Edate, ICalc.PCTAdj,    
	Max(FPart.Code) as FCode,
	Max(D.FacProrata_Calculation) as FacProrata_calculation,    
	Max(D.FacProrata) as FacProrata,     
	SUM(Case When PCALC.Description<>'' and PCALC.Description<>'Minimum Premium' then ICALC.GROSS*PCALC.GROSS/PCALC.OGROSS else ICALC.GROSS*D.GROSS/D.OGROSS end) AS GROSS,          
	AVG(ICalc.Prorata) as PProrata,     
	Max(PCalc.Ourshare/PCalc.TSI*100) as PCTShare,     
	Max(ICalc.SRate) as SRate,     
	Max((Case When RArrDet.Limit*PCalc.TSI/PCalc.OurShare<>0 Then RArrDet.Limit*PCalc.TSI/PCalc.OurShare else ICalc.TSI end)) as TSI,     
	SUM(ICalc.Rate) as Rate,     
	Max(Case When RArrDet.PCalc='P' or datediff(month,RArrDet.SDate, RArrDet.EDate)=0 or Cover.Voyage=1 Then 1 else 12/cast(datediff(month,RArrDet.SDate, RArrDet.EDate) as float) end) as NetRateProrata,    
	Max(FPart.NetRate*Case When RArrDet.PCalc='P' or datediff(month,RArrDet.SDate, RArrDet.EDate)=0 or Cover.Voyage=1 Then 1 else 12/cast(datediff(month,RArrDet.SDate, RArrDet.EDate) as float) end) as NetRate,    
	Max(FPart.Unit) as Unit,
	Max(RArrDet.Share) as Share,    
	Max(RArrDet.FLPCT) as FLPCT,    
	Max(RArrDet.CPRefund) as CPRefund,
	Max(pAcceptance.AType) as AType,
	Max(pAcceptance.EMethod) as EMethod,
	Max(ICalc.sProrata) as sProrata,  
	Max(Cast(RArrDet.OnGrossAfterCommF as Integer)) as OnGrossAfterCommF  
	from ICalc, PCalc, DISPLAY_FACULTATIVE_PRORATA_CALCULATION(@P_ANO, @P_FID) D, FPartDet FPart, RateCov, RArrDet, @RARRDET pRArrDet, @Acceptance pAcceptance, Acceptance, Cover    
	Where pAcceptance.ANO=@P_ANO and Acceptance.ANO=pAcceptance.PANO and Cover.CNO=Acceptance.CNO and ICalc.ANO=Acceptance.ANO and ICalc.Rate<>0 and PCalc.ANO=ICalc.ANO and PCalc.Currency=ICalc.Currency    
	and D.ANO=ICalc.ANO and D.Currency=ICalc.Currency and D.SDate=ICalc.Sdate and D.EDate=ICalc.EDate and D.TOR=ICalc.TOR    
	and RArrDet.Status in ('A','R') and RArrDet.FullCoverF=0 and RArrDet.ANO=D.ANO 
	and RArrDet.FID=@P_FID and FPart.ANO=RArrDet.ANO and FPart.FID=RArrdet.FID and RateCov.Code=FPart.Code and RateCov.TOR=ICalc.TOR
	and pRArrDet.ANO=pAcceptance.ANO and pRArrDet.FID=@P_FID and pRArrDet.NoRefundF=0
	Group By ICalc.ANO, ICalc.INO, ICalc.Currency, ICalc.Code, ICalc.SDate, ICalc.EDate, ICalc.PCTAdj 
	) ICalc
	Group By ICalc.ANO, ICalc.Currency, ICalc.Code, ICalc.FCode, ICalc.SDate, ICalc.EDate, ICalc.SRate, ICalc.sProrata, ICalc.PCTadj        
END
    
RETURN
END
GO

if exists (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'DISPLAY_FACULTATIVE_BALANCE_PRORATA_CALCULATION') AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) ) 
BEGIN DROP FUNCTION DISPLAY_FACULTATIVE_BALANCE_PRORATA_CALCULATION
end
GO
CREATE FUNCTION DISPLAY_FACULTATIVE_BALANCE_PRORATA_CALCULATION(@P_ANO int, @P_FID Varchar(20))          
-- From Display_Prorata Calculation   
-- RCalc.Sdate Replaced with RArrDet.SDate  
-- Rcalc.EDate Replaced with RArrDet.EDate  
-- Acceptance.AType Replaced with RArrDet.AType  
RETURNS TABLE  AS          
RETURN (          
select          
Distinct          
RCalc.ANO,          
RCalc.Code,          
RCalc.Currency,          
RCalc.SDate,  
RCalc.EDate,  
Prorata_Calculation=          
case          
When RArrDet.AType<>'N' then          
 case          
 when DateDiff(day, (Case When Datediff(day, RCalc.EDate, RArrDet.EDate)>=0 Then RCalc.EDate else RArrDet.EDate end), acceptance.pdate)>=0 then ''
 when DateDiff(day, acceptance.pdate, (Case When Datediff(day, RArrDet.SDate, RCalc.SDate)>=0 Then RCalc.SDate else RArrDet.SDate end))>0 then ''          
 Else          
  case          
  when acceptance.cpct<>0 or Cover.Voyage=1 then          
   case when acceptance.cpct<>0 and acceptance.cpct<>100 then convert(varchar(25),Cast(Acceptance.CPCT as float),3)+'%' else '' end          
  Else          
    case          
     when day(acceptance.pdate)=day((Case When Datediff(day, RCalc.EDate, RArrDet.EDate)>=0 Then RCalc.EDate else RArrDet.EDate end)) and day((Case When Datediff(day, RArrDet.SDate, RCalc.SDate)>=0 Then RCalc.SDate else RArrDet.SDate end))=day((Case When Datediff(day, RCalc.EDate, RArrDet.EDate)>=0 Then RCalc.EDate else RArrDet.EDate end)) and Cover.PPeriod<>1 and datediff(month,(Case When Datediff(day, RArrDet.SDate, RCalc.SDate)>=0 Then RCalc.SDate else RArrDet.SDate end),(Case When Datediff(day, RCalc.EDate, RArrDet.EDate)>=0 Then RCalc.EDate else RArrDet.EDate end))<>0 then          
  Case When DateDiff(month, acceptance.pdate, (Case When Datediff(day, RCalc.EDate, RArrDet.EDate)>=0 Then RCalc.EDate else RArrDet.EDate end))<>datediff(month,(Case When Datediff(day, RArrDet.SDate, RCalc.SDate)>=0 Then RCalc.SDate else RArrDet.SDate end),(Case When Datediff(day, RCalc.EDate, RArrDet.EDate)>=0 Then RCalc.EDate else RArrDet.EDate end)) then          
       convert(varchar(25),DateDiff(month, acceptance.pdate, (Case When Datediff(day, RCalc.EDate, RArrDet.EDate)>=0 Then RCalc.EDate else RArrDet.EDate end)))+'/'+convert(varchar(25),datediff(month,(Case When Datediff(day, RArrDet.SDate, RCalc.SDate)>=0 Then RCalc.SDate else RArrDet.SDate end),(Case When Datediff(day, RCalc.EDate, RArrDet.EDate)>=0 Then RCalc.EDate else RArrDet.EDate end)))          
  Else          
   ''          
  End          
    Else          
  Case When DateDiff(day, acceptance.pdate, (Case When Datediff(day, RCalc.EDate, RArrDet.EDate)>=0 Then RCalc.EDate else RArrDet.EDate end))<>datediff(day,(Case When Datediff(day, RArrDet.SDate, RCalc.SDate)>=0 Then RCalc.SDate else RArrDet.SDate end),(Case When Datediff(day, RCalc.EDate, RArrDet.EDate)>=0 Then RCalc.EDate else RArrDet.EDate end)) then          
       convert(varchar(25),DateDiff(day, acceptance.pdate, (Case When Datediff(day, RCalc.EDate, RArrDet.EDate)>=0 Then RCalc.EDate else RArrDet.EDate end)))+'/'+convert(varchar(25),datediff(day,(Case When Datediff(day, RArrDet.SDate, RCalc.SDate)>=0 Then RCalc.SDate else RArrDet.SDate end),(Case When Datediff(day, RCalc.EDate, RArrDet.EDate)>=0 Then RCalc.EDate else RArrDet.EDate end)))          
  Else          
   ''          
  End          
            
    End          
  End          
 End          
Else          
 ''          
end,          
            
Prorata=          
case          
When RArrDet.AType<>'N' then          
 case          
 when DateDiff(day, (Case When Datediff(day, RCalc.EDate, RArrDet.EDate)>=0 Then RCalc.EDate else RArrDet.EDate end), acceptance.pdate)>=0 then 0          
 when DateDiff(day, acceptance.pdate, (Case When Datediff(day, RArrDet.SDate, RCalc.SDate)>=0 Then RCalc.SDate else RArrDet.SDate end))>0 then 1          
 Else          
  case  
  when acceptance.cpct<>0 or Cover.Voyage=1 then          
   case when acceptance.cpct<>0 and acceptance.cpct<>100 then Acceptance.CPCT/100 else 1 end          
  Else          
    case          
     when day(acceptance.pdate)=day((Case When Datediff(day, RCalc.EDate, RArrDet.EDate)>=0 Then RCalc.EDate else RArrDet.EDate end)) and day((Case When Datediff(day, RArrDet.SDate, RCalc.SDate)>=0 Then RCalc.SDate else RArrDet.SDate end))=day((Case When Datediff(day, RCalc.EDate, RArrDet.EDate)>=0 Then RCalc.EDate else RArrDet.EDate end)) and Cover.PPeriod<>1 and datediff(month,(Case When Datediff(day, RArrDet.SDate, RCalc.SDate)>=0 Then RCalc.SDate else RArrDet.SDate end),(Case When Datediff(day, RCalc.EDate, RArrDet.EDate)>=0 Then RCalc.EDate else RArrDet.EDate end))<>0 then          
  Case When DateDiff(month, acceptance.pdate, (Case When Datediff(day, RCalc.EDate, RArrDet.EDate)>=0 Then RCalc.EDate else RArrDet.EDate end))<>datediff(month,(Case When Datediff(day, RArrDet.SDate, RCalc.SDate)>=0 Then RCalc.SDate else RArrDet.SDate end),(Case When Datediff(day, RCalc.EDate, RArrDet.EDate)>=0 Then RCalc.EDate else RArrDet.EDate end)) then          
       Cast(DateDiff(month, acceptance.pdate, (Case When Datediff(day, RCalc.EDate, RArrDet.EDate)>=0 Then RCalc.EDate else RArrDet.EDate end)) as Float)/Cast(datediff(month,(Case When Datediff(day, RArrDet.SDate, RCalc.SDate)>=0 Then RCalc.SDate else RArrDet.SDate end),(Case When Datediff(day, RCalc.EDate, RArrDet.EDate)>=0 Then RCalc.EDate else RArrDet.EDate end)) as Float)          
  Else          
1          
  End          
    Else          
  Case When DateDiff(day, acceptance.pdate, (Case When Datediff(day, RCalc.EDate, RArrDet.EDate)>=0 Then RCalc.EDate else RArrDet.EDate end))<>datediff(day,(Case When Datediff(day, RArrDet.SDate, RCalc.SDate)>=0 Then RCalc.SDate else RArrDet.SDate end),(Case When Datediff(day, RCalc.EDate, RArrDet.EDate)>=0 Then RCalc.EDate else RArrDet.EDate end)) then          
       Cast(DateDiff(Day, acceptance.pdate, (Case When Datediff(day, RCalc.EDate, RArrDet.EDate)>=0 Then RCalc.EDate else RArrDet.EDate end)) as Float)/Cast(datediff(Day,(Case When Datediff(day, RArrDet.SDate, RCalc.SDate)>=0 Then RCalc.SDate else RArrDet.SDate end),(Case When Datediff(day, RCalc.EDate, RArrDet.EDate)>=0 Then RCalc.EDate else RArrDet.EDate end)) as Float)          
  Else          
1          
  End          
            
    End          
  End          
 End          
Else          
1          
End                                
From acceptance          
inner Join Cover on (Cover.CNO=Acceptance.CNO)          
inner join PCalc on (PCalc.ANO=Acceptance.ANO)          
inner join RCalc on (RCalc.ANO=PCalc.ANO and RCalc.Currency=PCalc.Currency)          
inner join RArrDet on (RArrDet.ANO=Acceptance.ANO and RArrDet.FID=@P_FID)    
inner Join RCover on (RCover.ANO=Acceptance.ANO and RCover.Code=RCalc.Code and RCover.SDate=RCalc.SDate)        
Where RArrDet.AType not in ('A','C')        
and (RArrDet.AType='N' or (Acceptance.NoRefundF not in (2) and RCover.NoRefundF=0 and RArrDet.NoRefundF=0 and (Acceptance.NoRefundF in (0,3,4,5,6) or (DateDiff(day, acceptance.pdate, (Case When Datediff(day, RArrDet.SDate, RCalc.SDate)>=0 Then RCalc.SDate
 else RArrDet.SDate end))>0))))
and Acceptance.ANO=@P_ANO        
            
Union All          
            
select          
Distinct          
RCalc.ANO,          
RCalc.Code,          
RCalc.Currency,          
RCalc.SDate,  
RCalc.EDate,  
Prorata_Calculation=          
case          
when DateDiff(day, (Case When Datediff(day, RCalc.EDate, RArrDet.EDate)>=0 Then RCalc.EDate else RArrDet.EDate end), acceptance.pdate)>=0 and acceptance.pdate between pacceptance.sdate and pacceptance.edate then ''
when DateDiff(day, acceptance.pdate, (Case When Datediff(day, RArrDet.SDate, RCalc.SDate)>=0 Then RCalc.SDate else RArrDet.SDate end))>0 and acceptance.pdate between pacceptance.sdate and pacceptance.edate then ''          
Else          
  case          
  when acceptance.cpct<>0 or Cover.Voyage=1 then          
    case when acceptance.cpct<>0 and acceptance.cpct<>100 then convert(varchar(25),Cast(Acceptance.CPCT as float),3)+'%' else '' end        Else          
    case          
  When Acceptance.SDate<>Acceptance.PDate or Acceptance.NoRefundF=6 then          
      case          
       when day(acceptance.pdate)=day((Case When Datediff(day, RCalc.EDate, RArrDet.EDate)>=0 Then RCalc.EDate else RArrDet.EDate end)) and day((Case When Datediff(day, RArrDet.SDate, RCalc.SDate)>=0 Then RCalc.SDate else RArrDet.SDate end))=day((Case When Datediff(day, RCalc.EDate, RArrDet.EDate)>=0 Then RCalc.EDate else RArrDet.EDate end)) and Cover.PPeriod<>1 and datediff(month,(Case When Datediff(day, RArrDet.SDate, RCalc.SDate)>=0 Then RCalc.SDate else RArrDet.SDate end),(Case When Datediff(day, RCalc.EDate, RArrDet.EDate)>=0 Then RCalc.EDate else RArrDet.EDate end))<>0 then          
    Case When DateDiff(month, acceptance.pdate, (Case When Datediff(day, RCalc.EDate, RArrDet.EDate)>=0 Then RCalc.EDate else RArrDet.EDate end))<>datediff(month,(Case When Datediff(day, RArrDet.SDate, RCalc.SDate)>=0 Then RCalc.SDate else RArrDet.SDate end),(Case When Datediff(day, RCalc.EDate, RArrDet.EDate)>=0 Then RCalc.EDate else RArrDet.EDate end)) then          
         convert(varchar(25),DateDiff(month, acceptance.pdate, (Case When Datediff(day, RCalc.EDate, RArrDet.EDate)>=0 Then RCalc.EDate else RArrDet.EDate end)))+'/'+convert(varchar(25),datediff(month,(Case When Datediff(day, RArrDet.SDate, RCalc.SDate)>=0 Then RCalc.SDate else RArrDet.SDate end),(Case When Datediff(day, RCalc.EDate, RArrDet.EDate)>=0 Then RCalc.EDate else RArrDet.EDate end)))          
    Else          
     ''          
    End          
      Else          
    Case When DateDiff(day, acceptance.pdate, (Case When Datediff(day, RCalc.EDate, RArrDet.EDate)>=0 Then RCalc.EDate else RArrDet.EDate end))<>datediff(day,(Case When Datediff(day, RArrDet.SDate, RCalc.SDate)>=0 Then RCalc.SDate else RArrDet.SDate end),(Case When Datediff(day, RCalc.EDate, RArrDet.EDate)>=0 Then RCalc.EDate else RArrDet.EDate end)) then          
         convert(varchar(25),DateDiff(day, acceptance.pdate, (Case When Datediff(day, RCalc.EDate, RArrDet.EDate)>=0 Then RCalc.EDate else RArrDet.EDate end)))+'/'+convert(varchar(25),datediff(day,(Case When Datediff(day, RArrDet.SDate, RCalc.SDate)>=0 Then RCalc.SDate else RArrDet.SDate end),(Case When Datediff(day, RCalc.EDate, RArrDet.EDate)>=0 Then RCalc.EDate else RArrDet.EDate end)))          
    Else          
     ''          
    End          
              
      End          
    Else          
     -- Endorsement Period          
      ''          
    End          
  End          
end,          
Prorata=          
case          
when DateDiff(day, (Case When Datediff(day, RCalc.EDate, RArrDet.EDate)>=0 Then RCalc.EDate else RArrDet.EDate end), acceptance.pdate)>=0 and acceptance.pdate between pacceptance.sdate and pacceptance.edate then 0          
when DateDiff(day, acceptance.pdate, (Case When Datediff(day, RArrDet.SDate, RCalc.SDate)>=0 Then RCalc.SDate else RArrDet.SDate end))>0  and acceptance.pdate between pacceptance.sdate and pacceptance.edate then 1          
Else          
  case          
  when acceptance.cpct<>0 or Cover.Voyage=1 then          
    case when acceptance.cpct<>0 and acceptance.cpct<>100 then Acceptance.CPCT/100 else 1 end          
  Else          
    case          
  When Acceptance.SDate<>Acceptance.PDate or Acceptance.NoRefundF=6 then          
      case          
       when day(acceptance.pdate)=day((Case When Datediff(day, RCalc.EDate, RArrDet.EDate)>=0 Then RCalc.EDate else RArrDet.EDate end)) and day((Case When Datediff(day, RArrDet.SDate, RCalc.SDate)>=0 Then RCalc.SDate else RArrDet.SDate end))=day((Case When Datediff(day, RCalc.EDate, RArrDet.EDate)>=0 Then RCalc.EDate else RArrDet.EDate end)) and Cover.PPeriod<>1 and datediff(month,(Case When Datediff(day, RArrDet.SDate, RCalc.SDate)>=0 Then RCalc.SDate else RArrDet.SDate end),(Case When Datediff(day, RCalc.EDate, RArrDet.EDate)>=0 Then RCalc.EDate else RArrDet.EDate end))<>0 then          
    Case When DateDiff(month, acceptance.pdate, (Case When Datediff(day, RCalc.EDate, RArrDet.EDate)>=0 Then RCalc.EDate else RArrDet.EDate end))<>datediff(month,(Case When Datediff(day, RArrDet.SDate, RCalc.SDate)>=0 Then RCalc.SDate else RArrDet.SDate end),(Case When Datediff(day, RCalc.EDate, RArrDet.EDate)>=0 Then RCalc.EDate else RArrDet.EDate end)) then          
         Cast(DateDiff(month, acceptance.pdate, (Case When Datediff(day, RCalc.EDate, RArrDet.EDate)>=0 Then RCalc.EDate else RArrDet.EDate end)) as Float)/Cast(datediff(month,(Case When Datediff(day, RArrDet.SDate, RCalc.SDate)>=0 Then RCalc.SDate else RArrDet.SDate end),(Case When Datediff(day, RCalc.EDate, RArrDet.EDate)>=0 Then RCalc.EDate else RArrDet.EDate end)) as Float)          
    Else          
 1          
    End          
      Else          
    Case When DateDiff(day, acceptance.pdate, (Case When Datediff(day, RCalc.EDate, RArrDet.EDate)>=0 Then RCalc.EDate else RArrDet.EDate end))<>datediff(day,(Case When Datediff(day, RArrDet.SDate, RCalc.SDate)>=0 Then RCalc.SDate else RArrDet.SDate end),(Case When Datediff(day, RCalc.EDate, RArrDet.EDate)>=0 Then RCalc.EDate else RArrDet.EDate end)) then          
         Cast(DateDiff(Day, acceptance.pdate, (Case When Datediff(day, RCalc.EDate, RArrDet.EDate)>=0 Then RCalc.EDate else RArrDet.EDate end)) as Float)/Cast(datediff(Day,(Case When Datediff(day, RArrDet.SDate, RCalc.SDate)>=0 Then RCalc.SDate else RArrDet.SDate end),(Case When Datediff(day, RCalc.EDate, RArrDet.EDate)>=0 Then RCalc.EDate else RArrDet.EDate end)) as Float)          
    Else          
 1          
    End          
              
      End          
    Else          
     -- Endorsement Period          
 1          
    End          
  End          
End          
            
From acceptance          
inner Join Cover on (Cover.CNO=Acceptance.CNO)          
inner join Acceptance pAcceptance on (pAcceptance.ANO=Acceptance.pANO)          
inner join PCalc on (PCalc.ANO=pAcceptance.ANO)          
inner join RCalc on (RCalc.ANO=PCalc.ANO and RCalc.Currency=PCalc.Currency)     
inner join RArrDet on (RArrDet.ANO=pAcceptance.ANO and RArrDet.FID=@P_FID)         
Left Join RCover on (RCover.ANO=pAcceptance.ANO and RCover.Code=RCalc.Code and RCover.SDate=RCalc.SDate)          
Where Acceptance.AType<>'A' and Not (Acceptance.AType='C' and Acceptance.EMethod='A') and pAcceptance.AType not in ('A','C')        
and Acceptance.NoRefundF Not in (2) and coalesce(RCover.NoRefundF,0)=0 and coalesce(RArrDet.NoRefundF,0)=0
and (Acceptance.NoRefundF in (0,3,4,5,6) or (DateDiff(day, acceptance.pdate, (Case When Datediff(day, RArrDet.SDate, RCalc.SDate)>=0 Then RCalc.SDate else RArrDet.SDate end))>0  and acceptance.pdate between pacceptance.sdate and pacceptance.edate))      
and Acceptance.ANO=@P_ANO        
)

GO

IF EXISTS ( SELECT * FROM   sysobjects WHERE  id = object_id(N'QCLACC01') and OBJECTPROPERTY(id, N'IsProcedure') = 1 ) 
BEGIN DROP PROCEDURE QCLACC01
end
GO
CREATE PROCEDURE QCLACC01 (@PCNO AS INTEGER,@PINO AS INTEGER=0)        
AS        
SELECT Distinct cast(ICOVER.REMARK as varchar(255)) AS REMARK, ICOVER.CURRENCY,        
CASE        
 WHEN CLAIM.EVENTNO=-1 THEN        
        CASE        
        WHEN ICOVER.NOTDECRF=1 OR RCOVER.PCTLOSS=0 THEN ICOVER.AMOUNT        
        ELSE ICOVER.AMOUNT*RCOVER.PCTLOSS/100 END        
 Else        
        CASE        
        WHEN ICOVER.NOTDECRF=1 OR RCOVER.PCTLOSS=0 THEN ICOVER.AMOUNT_AOE        
        ELSE ICOVER.AMOUNT_AOE*RCOVER.PCTLOSS/100 END        
 END AS SI, ICOVER.INO, ICOVER.TOI, ICOVER.TOTAL, ICOVER.INDEMNITY, ICOVER.ESTIMATE, TOI.AGREEDVALF, ICOVER.CURRENCY_OC, ICOVER.RATE_OC       
From ICOVER, CLAIM, Col, ICALC, RCOVER, TOI, ACCEPTANCE        
WHERE CLAIM.CNO=@PCNO AND ACCEPTANCE.ANO=CLAIM.ANO 
AND ICOVER.ANO=CLAIM.ANO AND (@PINO=0 or ICOVER.INO=@PINO) 
AND TOI.TOI=ICOVER.TOI
AND COL.COL=CLAIM.COL
AND RCOVER.ANO=ACCEPTANCE.ANO        
AND (RCover.RetroActiveF=1 or (RCOVER.SDATE<=CLAIM.LOSSDATE AND ACCEPTANCE.ExclusiveF=1) or ((RCOVER.SDATE<CLAIM.LOSSDATE or (RCOVER.SDATE=CLAIM.LOSSDATE AND ACCEPTANCE.STIME<=Claim.LossTime)) AND ACCEPTANCE.ExclusiveF=0))       
AND ((dbo.fn_Get_ExtPeriodDate(ACCEPTANCE.ExtPeriod, ACCEPTANCE.ExtPeriodInDaysF, RCOVER.EDATE)>CLAIM.LOSSDATE AND ACCEPTANCE.ExclusiveF=1) or ((dbo.fn_Get_ExtPeriodDate(ACCEPTANCE.ExtPeriod, ACCEPTANCE.ExtPeriodInDaysF, RCOVER.EDATE)>CLAIM.LOSSDATE or (dbo.fn_Get_ExtPeriodDate(ACCEPTANCE.ExtPeriod, ACCEPTANCE.ExtPeriodInDaysF, RCOVER.EDATE)=CLAIM.LOSSDATE AND ACCEPTANCE.ETIME>Claim.LossTime)) AND ACCEPTANCE.ExclusiveF=0))      
AND ICALC.ANO=CLAIM.ANO AND ICalc.Currency=ICOVER.Currency AND ICalc.Code=RCover.Code AND ICALC.TOR=COL.TOR and ICalc.INO=ICover.INO and ICalc.SDate=RCover.SDate


GO

IF EXISTS ( SELECT * FROM   sysobjects WHERE  id = object_id(N'QCheck_ContractNo_SysBatchSC') and OBJECTPROPERTY(id, N'IsProcedure') = 1 ) 
BEGIN DROP PROCEDURE QCheck_ContractNo_SysBatchSC
end
GO
CREATE Procedure QCheck_ContractNo_SysBatchSC(@ContractNo as varchar(50),@ORDERNO AS varchar(50),@DOCNO AS varchar(50),@POLICYNO AS VARCHAR(50)) 
as 
SELECT  Top 1 
S2.BID, 
S2.PolicyNo as [Policy No], 
S2.Insured, 
S2.Inception, 
S2.Expiry, 
S2.ANO 
from 
SysBatchSC S2, 
SysBatchH S1 
Where 
S1.BatchNO = S2.BatchNO 
and S1.Status in ('T','R','P') 
and (S2.Status in ('W') or (S2.Status in ('N') and S2.ErrMsg in ('On-Progress...')))
and S2.PolicyNo=@POLICYNO and S2.ContractNo=@ContractNo and S2.ORDERNO=@ORDERNO and S2.DOCNO=@DOCNO 
go

 
insert into PatchVersioning
select '53.2 Update Script - Patch 2019 (1) (Execute Before Kom 2019 v.2)',GETDATE()
go

Declare @PrevScript varchar(100)
Declare @CurrScript varchar(100)

Select @PrevScript='53.1 Update Script - Functions (Execute Before Kom 2019 v.2)'
Select @CurrSCript='53.2 Update Script - Patch 2019 (1) (Execute Before Kom 2019 v.2)'


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