--Update Script 2020 V1.3
--16 FEB 2021
IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'Last_Time' AND Object_ID = Object_ID(N'ProfilePIC'))
BEGIN
ALTER TABLE ProfilePIC ADD
	Last_Time varchar(5) NULL
END
GO


--28 FEB 2021
IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'MINTSI' AND Object_ID = Object_ID(N'TOL'))
BEGIN
ALTER TABLE TOL ADD
	MINTSI float(53) NULL
DECLARE @v sql_variant 
SET @v = N'Minimum TSI (0 : Not Applied)'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'TOL', N'COLUMN', N'MINTSI'	
END
GO

IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'MAXTSI' AND Object_ID = Object_ID(N'TOL'))
BEGIN
ALTER TABLE TOL ADD
	MAXTSI float(53) NULL
	DECLARE @v sql_variant 
SET @v = N'Maximum TSI (0 : Not Applied)'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'TOL', N'COLUMN', N'MAXTSI'
END
GO
IF EXISTS(SELECT * FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS WHERE TABLE_NAME='TOL' AND CONSTRAINT_NAME='I_TOL')
Begin
Alter Table TOL drop constraint I_TOL
END
GO
Create Unique Index I_TOL on TOL(RYEAR, TOC, ISTYPE, MINRANGE, MINYEAR, MINCOYS, MINTSI)
GO

IF EXISTS ( SELECT * FROM   sysobjects WHERE  id = object_id(N'TREATY_LIMIT') and OBJECTPROPERTY(id, N'IsProcedure') = 1 )
BEGIN
DROP Procedure TREATY_LIMIT 
END
GO
CREATE Procedure TREATY_LIMIT (@P_ANO integer, @P_OurShare Float, @P_NCoys Integer, @P_TSI Float=0)  
as  
SELECT TOP 1 TOL.Limit, TOL.HOLDF  
From Acceptance
Inner Join RARRHEADER on (RArrHeader.ANO=Acceptance.ANO)
Inner Join cover on (Cover.CNO=Acceptance.CNO)
Inner Join REINSURANCE on (RArrHeader.RDate Between Reinsurance.SDate and Reinsurance.EDate and Reinsurance.RType In ('Q','S1','S2','S3'))
Inner Join RECLASS on (ReClass.RNO=Reinsurance.RNO and ReClass.TOC=Acceptance.TOC and ReClass.CessionF=1)
Inner Join TOL on (TOL.RYear=Reinsurance.RYear And TOL.TOC=ReClass.TOC And TOL.IsType=Cover.IsType)
WHERE Acceptance.ANO=@P_ANO 
And (TOL.Minrange=0 or TOL.Minrange<=@P_OurShare) And (TOL.MaxRange=0 or TOL.MaxRange>=@P_OurShare)
And (TOL.MinCoys=0 or TOL.MinCoys<=@P_NCoys) And (TOL.MaxCoys=0 or TOL.MaxCoys>=@P_NCoys)
And (TOL.MinYear=0 or TOL.MinYear<=datediff(year,Acceptance.SDate, Acceptance.EDate)) And (TOL.MaxYear=0 or TOL.MaxYear>=datediff(year,Acceptance.SDate, Acceptance.EDate))
And (TOL.MinTSI=0 or TOL.MinTSI<=@P_TSI) And (TOL.MaxTSI=0 or TOL.MaxTSI>=@P_TSI)
Order By TOL.Limit Desc  


GO

--28 FEB 2021 (1)
IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'AccLinkF' AND Object_ID = Object_ID(N'AccClass'))
BEGIN
ALTER TABLE AccClass ADD
	AccLinkF bit NULL
DECLARE @v sql_variant 
SET @v = N'Journal Adjustmet from Account Link (Accounting Link Type - Mparam with CashFlowF=1)'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'AccClass', N'COLUMN', N'AccLinkF'
END
GO

GO


--28 FEB 2021 (2)
IF NOT EXISTS(SELECT * FROM SYSFORM WHERE FNAME='ALLOWINFORCEONPOLICYCANCELLATION')
BEGIN
insert into sysform(FName, Description, FCode, RequestF) 
Select 'ALLOWINFORCEONPOLICYCANCELLATION', 'ALLOW INFORCE ON POLICY CANCELLATION','ACTIVITIES',0
END
GO

--3 MAR 2021 
IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'Status' AND Object_ID = Object_ID(N'SysLogDownload'))
BEGIN
ALTER TABLE SysLogDownload ADD
	Status varchar(1) NULL
	DECLARE @v sql_variant 
SET @v = N'''P''ending, ''C''losed/Rejected; ''A''ccepted'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'SysLogDownload', N'COLUMN', N'Status'
END
GO

GO

IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'ErrMsg' AND Object_ID = Object_ID(N'SysLogDownload'))
BEGIN
ALTER TABLE SysLogDownload ADD
	ErrMsg varchar(255) NULL
	DECLARE @v sql_variant 
SET @v = N'Error Message'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'SysLogDownload', N'COLUMN', N'ErrMsg'
END
GO

GO

IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'LDATE' AND Object_ID = Object_ID(N'SysLogDownload'))
BEGIN
ALTER TABLE SysLogDownload ADD
	LDATE smalldatetime NULL
	DECLARE @v sql_variant 
SET @v = N'Last Update Date'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'SysLogDownload', N'COLUMN', N'LDATE'
END
GO

GO

IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'LTIME' AND Object_ID = Object_ID(N'SysLogDownload'))
BEGIN
ALTER TABLE SysLogDownload ADD
	LTIME varchar(8) NULL
	DECLARE @v sql_variant 
SET @v = N'Last Update Time'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'SysLogDownload', N'COLUMN', N'LTIME'
END
GO

GO

IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'LUSERID' AND Object_ID = Object_ID(N'SysLogDownload'))
BEGIN
ALTER TABLE SysLogDownload ADD
	LUSERID varchar(50) NULL
	DECLARE @v sql_variant 
SET @v = N'Last Update User ID'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'SysLogDownload', N'COLUMN', N'LUSERID'
END
GO

--PATCH 2021 (22)
			DROP Procedure BALANCE_ACCASS_ADJUSTMENT
			GO
			DROP FUNCTION PREMIUM_CALCULATION
			GO
			GO
CREATE Procedure BALANCE_ACCASS_ADJUSTMENT(@P_ANO integer)     
as     

Declare @OANO as Int
Declare @PANO as int
Declare @PDate as smalldatetime
Declare @PPDate as smalldatetime
Declare @CPDate as smalldatetime
Declare @CANO as Int
Declare @ManualF as bit
Declare @AType varchar(1)
Declare @EMethod varchar(1)

Select Top 1 @OANO=A1.OANO, @AType=A1.AType, @EMethod=A1.EMethod, @PANO=A1.PANO, @PDate=A1.PDate, @PPDate=A1.PPDate, @CPDate=A2.PDate, @CANO=coalesce(A2.ANO,0), @ManualF=coalesce(R.ManualF,0)
from Acceptance A1
Left Join RArrHeader R on (R.ANO=A1.ANO)
Left Join Acceptance A2 on (A2.OANO=A1.OANO and A2.Atype='C' and A2.EMethod='A' and A2.ANO<@P_ANO)
Where A1.ANO=@P_ANO
Order By A1.OANO, A2.ANO Desc


Select AccAss.*, A2.PDate, A2.PPDate, @ManualF     
From Acceptance A2 
inner join AccAss on (AccAss.ANO=A2.ANO)     
Left join Acceptance pA2  on (pA2.ANO=A2.pANO)     
Where A2.OANO=@OANO and A2.ANO<@P_ANO
and   
(     
 (  
 A2.ANO<=@PANO and @PDate<=A2.PDate and @PPDate>=A2.PPDate and @AType='A' and (A2.AType<>'A' and coalesce(pA2.AType,'')<>'A')   
 and AccAss.AdjustableF=1 and AccAss.AdjMethod<>'OVERLIMIT'  
 and NOT EXISTS (Select PANO from Acceptance A3 Where A3.PANO=A2.ANO and A3.Astatus<>'C' and A3.AType='A' and A3.ANO<>@P_ANO)  
 )     
 or   
 (  
 A2.ANO<=@PANO and @PDate<=A2.PDate and @PPDate>=A2.PPDate and @AType='A' and (A2.AType<>'A' and coalesce(pA2.AType,'')<>'A')   
 and AccAss.AdjustableF=1 and AccAss.AdjMethod='OVERLIMIT' and A2.PDATE<A2.PPDATE and AccAss.CAmount<>0  
 and NOT EXISTS (Select PANO from Acceptance A3 Where A3.PANO=A2.ANO and A3.Astatus<>'C' and A3.AType='A' and A3.ANO<>@P_ANO)  
 )     
 or    
 (  
 --Cancel All
 @AType='C' and @EMethod='A'  
 and (
 (
	case when A2.ANO<=@CANO and A2.PDate>coalesce(@CPDate,A2.PDate) Then coalesce(@CPDate,A2.PDate) else A2.PDate end>=@PDate and AccAss.CAmount<>0
 ) or 
 (
	case when A2.ANO<=@CANO and coalesce(pA2.pDate,A2.PDate)>coalesce(@CPDate,coalesce(pA2.pDate,A2.PDate)) Then coalesce(@CPDate,coalesce(pA2.pDate,A2.PDate)) else coalesce(pA2.pDate,A2.PDate) end>=@PDate and AccAss.CAmount=0
 )
 )
 )  
 or
 (
 --Adjustment Cancel
 A2.ANO=@PANO and @AType='C' and A2.AType='A'
 )
)     


GO


GO
CREATE FUNCTION PREMIUM_CALCULATION(@P_ANO int)                  
RETURNS TABLE  AS                  
RETURN (                  

Select ANO, Currency,
sum(Premium) as Premium,
sum(Commission) as Commission,
sum(Discount) as Discount,
dbo.roundCCY(sum(VAT),Currency) as VAT,
dbo.roundCCY(sum(TAX),Currency) as TAX,
Sum(FeeDuty) as FeeDuty      
from
(
	Select ANO, Code, SDate, EDate, Currency,   
	sum(Premium-Case When NoRefundF=7 Then Premium*dbo.Premium_Commission(CANO,Code,PolicyYear,MinimumPremiumF)/100 else 0 end) as Premium,           
	sum(Case When NoRefundF=7 Then 0 else Premium*dbo.Premium_Commission(CANO,Code,PolicyYear,MinimumPremiumF)/100 end) as Commission,           
	sum(Premium*dbo.Premium_Discount(CANO,Code,PolicyYear)/100) as Discount,           
	sum(Case When NoRefundF=7 Then 0 else Premium*dbo.Premium_Commission_Vat(CANO,Code,PolicyYear,MinimumPremiumF)/100 end) as Vat,           
	sum(Case When NoRefundF=7 Then 0 else Premium*dbo.Premium_Commission_Tax(CANO,Code,PolicyYear,MinimumPremiumF)/100 end) as Tax,
	cast(0 as Float) as FeeDuty      
	from PREMIUM_CALCULATION_BASE(@P_ANO) T                                              
	Group By ANO, Code, SDate, EDate, Currency          

	Union All                  
                                 
	select A1.ANO, AccAss.Code, AccAss.SDate, AccAss.EDate, AccAss.Currency_OC as Currency,                  
	sum(Case When AccAss.Code in ('P','U') then (Case When A1.AType='A' and AccAss.AdjMethod='OVERLIMIT' then -AccAss.CAmount*(Case When A1.CPCT<>0 Then A1.CPCT/100 else 1 end)/(Case When AccAss.PProrata<>0 Then AccAss.PProrata else 1 end) else -AccAss.Amount_OC end)*(Case When AccAss.Type='DI' then 100/(100-coalesce(Coinsurance.MShare,0)) else 1 end) else 0 end) as Premium,                  
	sum(Case When AccAss.Code='C' then (Case When A1.AType='A' and AccAss.AdjMethod='OVERLIMIT' then AccAss.CAmount*(Case When A1.CPCT<>0 Then A1.CPCT/100 else 1 end)/(Case When AccAss.PProrata<>0 Then AccAss.PProrata else 1 end) else AccAss.Amount_OC end)*(Case When AccAss.Type='DI' then 100/(100-coalesce(Coinsurance.MShare,0)) else 1 end) else 0 end) as Commission,                  
	sum(Case When AccAss.Code='O' then (Case When A1.AType='A' and AccAss.AdjMethod='OVERLIMIT' then AccAss.CAmount*(Case When A1.CPCT<>0 Then A1.CPCT/100 else 1 end)/(Case When AccAss.PProrata<>0 Then AccAss.PProrata else 1 end) else AccAss.Amount_OC end)*(Case When AccAss.Type='DI' then 100/(100-coalesce(Coinsurance.MShare,0)) else 1 end) else 0 end) as Discount,                  
	sum((Case When A1.AType='A' and AccAss.AdjMethod='OVERLIMIT' then AccAss.CAmount*(Case When A1.CPCT<>0 Then A1.CPCT/100 else 1 end)/(Case When AccAss.PProrata<>0 Then AccAss.PProrata else 1 end) else AccAss.Amount_OC end)*(Case When AccAss.Type='DI' then 100/(100-coalesce(Coinsurance.MShare,0)) else 1 end)*(Case When Profile.VatF=1 Then MParam.Vat/100 else 0 end)) as Vat,                  
	sum((Case When A1.AType='A' and AccAss.AdjMethod='OVERLIMIT' then AccAss.CAmount*(Case When A1.CPCT<>0 Then A1.CPCT/100 else 1 end)/(Case When AccAss.PProrata<>0 Then AccAss.PProrata else 1 end) else AccAss.Amount_OC end)*(Case When AccAss.Type='DI' then 100/(100-coalesce(Coinsurance.MShare,0)) else 1 end)*(Case When Profile.TaxF=1 Then (Case When TaxType.MTaxType='PASAL21' Then MParam.Pasal21/100*(100-MParam.TaxDiscount)/100 When TaxType.MTaxType='PASAL23' Then MParam.Pasal23/100 When TaxType.MTaxType='PASAL26' Then MParam.Pasal26/100 else 0 end)*(Case When Profile.TaxPCT=0 Then 1 else Profile.TaxPCT/100 end) else Profile.AccruedTax/100 end)) as Tax,      
	sum(Case When AccAss.Code in ('F','D') then -AccAss.Amount_OC else 0 end) as FeeDuty      
	from Acceptance A1       
	inner join Acceptance A2 on (A2.OANO=A1.OANO)    
	inner join AccAss on (AccAss.ANO=A2.ANO)      
	inner join Profile on (Profile.ID=AccAss.ID)      
	Left Join TaxType on (TaxType.TaxType=Profile.TaxType)
	inner join MParam on (MParam.Type=Accass.Type)      
	Left Join (Select CNO, sum(Share) as MShare from Coinsurance Where PCollectionF=0 Group by CNO) Coinsurance on (Coinsurance.CNO=A2.CNO)      
	Left join Acceptance pA2 on (pA2.ANO=A2.PANO)      
	Left Join (
		Select Top 1 A1.ANO, A2.PDate as CPDate, coalesce(A2.ANO,0) as CANO from Acceptance A1 Left Join Acceptance A2 on (A2.OANO=A1.OANO and A2.Atype='C' and A2.EMethod='A' and A2.ANO<@P_ANO) Where A1.ANO=@P_ANO Order By A1.OANO, A2.ANO Desc
	) A3 on (A3.ANO=A1.ANO)
	Where A1.ANO=@P_ANO     
	and (                  
	(
	A2.ANO<=A1.PANO AND A2.ANO<@P_ANO AND A1.PDate<=A2.PDate and A1.PPDate>=A2.PPDate and A1.AType='A' and (A2.AType<>'A' and coalesce(pA2.AType,'')<>'A') and AccAss.AdjustableF=1 and (AccAss.AdjMethod<>'OVERLIMIT' or AccAss.CAmount<>0) and NOT EXISTS (Select PANO from Acceptance A3 Where A3.PANO=A2.ANO and A3.AStatus<>'C' and A3.AType='A' and A3.ANO<>@P_ANO)
	)                  
	or 
	(
	A2.ANO<@P_ANO AND A1.AType='C' and A1.EMethod='A' 
	and (
	 (
		case when A2.ANO<=A3.CANO and A2.PDate>coalesce(A3.CPDate,A2.PDate) Then coalesce(A3.CPDate,A2.PDate) else A2.PDate end>=A1.PDate and AccAss.CAmount<>0
	 ) or 
	 (
		case when A2.ANO<=A3.CANO and coalesce(pA2.pDate,A2.PDate)>coalesce(A3.CPDate,coalesce(pA2.pDate,A2.PDate)) Then coalesce(A3.CPDate,coalesce(pA2.pDate,A2.PDate)) else coalesce(pA2.pDate,A2.PDate) end>=A1.PDate and AccAss.CAmount=0
	 )
	 )
	)                  
	or 
	(A2.ANO=A1.PANO and A1.AType='C' and A2.AType='A')
	)                  
	and ((AccAss.Type in ('DI','IC','IR') and AccAss.Code='P') or (AccAss.Type in ('DI','IC') and AccAss.Code='U') Or (AccAss.Type in ('BB','BA','BO') and AccAss.Code='C') or (AccAss.Type in ('DI','IC','IR') and AccAss.Code='O') or (A1.AType='C' and A1.EMethod='A' and AccAss.Type in ('DI') and AccAss.Code in ('F','D')))                  
	Group By A1.ANO, AccAss.Code, AccAss.SDate, AccAss.EDate, AccAss.Currency_OC                                                                             
) T          
Group by ANO, Currency


)           
        
GO

--PATCH 2021 (25)
DROP FUNCTION DISPLAY_GROSS_CALCULATION
GO

CREATE FUNCTION DISPLAY_GROSS_CALCULATION(@P_ANO int)      
RETURNS TABLE  AS      
RETURN (      
Select ICalc.ANO, ICalc.Currency, ICalc.Code, ICalc.SDate, ICalc.EDate, sum(ICalc.Gross) as Gross,      
Calculation=      
Case When Max(ICalc.SRate)<>'Flat' then convert(varchar(25),Cast(sum(ICalc.TSI) as Money),1) + ' x ' + (case When Max(RCover.Unit)='C' then convert(varchar(25), Cast(sum(ICalc.Rate*100)/Count(*) as Numeric(38,8)),2)+'%' else convert(varchar(25), Cast(sum(ICalc.Rate*1000)/Count(*) as Numeric(38,8)),3)+'‰' end) else convert(varchar(25), Cast(sum(ICalc.Rate) as Money),1) end +      
Case When Max(ICalc.sProrata)<>'' then ' x '+Max(ICalc.sProrata) else '' end +      
Case When Max(ICalc.SRate)<>'Flat' and ICalc.PCTAdj<>100 then ' x '+Cast(Icalc.PCTAdj as varchar(10))+'%' else '' end +
Case When Max(cast(Case When ICalc.LMFactor=0 Then 1 Else ICalc.LMFactor End as Numeric(38,8)))<>1 Then ' x '+cast(Max(cast(Case When ICalc.LMFactor=0 Then 1 Else ICalc.LMFactor End as Numeric(38,8))) as varchar(10)) else '' end
From      
(
Select ICalc.ANO, ICalc.INO, ICalc.Currency, ICalc.Code, ICalc.SDate, ICalc.EDate, Case When ICalc.SRate='Flat' then 100 else ICalc.PCTAdj end as PCTAdj, sum(ICalc.Gross) as Gross, Max(ICalc.SRate) as SRate, Max(ICalc.TSI) as TSI, sum(ICalc.Rate) as Rate, Max(ICalc.sProrata) as sProrata, Max(coalesce(ICALC.LMFACTOR,0)) as LMFACTOR      
from ICalc, Acceptance Where ICalc.ANO=Acceptance.ANO and Acceptance.ANO=@P_ANO and ICalc.Rate<>0      
Group By ICalc.ANO, ICalc.INO, ICalc.Currency, ICalc.Code, ICalc.SDate, ICalc.EDate, Case When ICalc.SRate='Flat' then 100 else ICalc.PCTAdj end      
) ICalc, RCover      
Where RCOVER.ANO = ICALC.ANO And RCOVER.Code = ICALC.Code And RCOVER.SDate = ICALC.SDate And RCOVER.EDate = ICALC.EDate      
Group By ICalc.ANO, ICalc.Currency, ICalc.Code, ICalc.SDate, ICalc.EDate, ICalc.PCTadj      
                
Union All      
                
Select ICalc.ANO, ICalc.Currency, ICalc.Code, ICalc.SDate, ICalc.EDate, -sum(ICalc.Gross) as Gross,      
Calculation='- '+      
Case When Max(ICalc.SRate)<>'Flat' then convert(varchar(25),Cast(sum(ICalc.TSI) as Money),1) + ' x ' + (case When Max(RCover.Unit)='C' then convert(varchar(25), Cast(sum(ICalc.Rate*100)/Count(*) as Numeric(38,8)),2)+'%' else convert(varchar(25), Cast(sum(ICalc.Rate*1000)/Count(*) as Numeric(38,8)),3)+'‰' end) else convert(varchar(25), Cast(sum(ICalc.Rate) as Money),1) end +      
Case When Max(ICalc.sProrata)<>'' then ' x '+Max(ICalc.sProrata) else '' end +      
Case When Max(ICalc.SRate)<>'Flat' and ICalc.PCTAdj<>100 then ' x '+Cast(Icalc.PCTAdj as varchar(10))+'%' else '' end +  
Case When Max(cast(Case When ICalc.LMFactor=0 Then 1 Else ICalc.LMFactor End as Numeric(38,8)))<>1 Then ' x '+cast(Max(cast(Case When ICalc.LMFactor=0 Then 1 Else ICalc.LMFactor End as Numeric(38,8))) as varchar(10)) else '' end 
From      
(
Select Acceptance.AType, Acceptance.EMethod, ICalc.ANO, ICalc.INO, ICalc.Currency, ICalc.Code, ICalc.SDate, ICalc.EDate, Case When ICalc.SRate='Flat' then 100 else ICalc.PCTAdj end as PCTAdj, sum(ICalc.Gross) as Gross, Max(ICalc.SRate) as SRate, Max(ICalc.TSI) as TSI, sum(ICalc.Rate) as Rate, Max(ICalc.sProrata) as sProrata, Max(coalesce(ICALC.LMFACTOR,0)) as LMFACTOR      
from ICalc, Acceptance Where ICalc.ANO=Acceptance.PANO and Acceptance.ANO=@P_ANO and ICalc.Rate<>0      
Group By Acceptance.AType, Acceptance.EMethod, ICalc.ANO, ICalc.INO, ICalc.Currency, ICalc.Code, ICalc.SDate, ICalc.EDate, Case When ICalc.SRate='Flat' then 100 else ICalc.PCTAdj end      
) ICalc, RCover      
Where RCOVER.ANO = ICALC.ANO And RCOVER.Code = ICALC.Code And RCOVER.SDate = ICALC.SDate And RCOVER.EDate = ICALC.EDate      
Group By ICalc.ANO, ICalc.Currency, ICalc.Code, ICalc.SDate, ICalc.EDate, ICalc.PCTadj      
      
Union All      
        
Select ICalc.ANO, ICalc.Currency, ICalc.Code, ICalc.SDate, ICalc.EDate, sum(ICalc.Gross) as Gross,      
Calculation=      
Case When Max(ICalc.SRate)<>'Flat' then convert(varchar(25),Cast(sum(ICalc.TSI) as Money),1) + ' x ' + (case When Max(RCover.Unit)='C' then convert(varchar(25), Cast(sum(ICalc.Rate*100)/Count(*) as Numeric(38,8)),2)+'%' else convert(varchar(25), Cast(sum(ICalc.Rate*1000)/Count(*) as Numeric(38,8)),3)+'‰' end) else convert(varchar(25), Cast(sum(ICalc.Rate) as Money),1) end +      
Case When Max(ICalc.sProrata)<>'' then ' x '+Max(ICalc.sProrata) else '' end +      
Case When Max(ICalc.SRate)<>'Flat' and ICalc.PCTAdj<>100 then ' x '+Cast(Icalc.PCTAdj as varchar(10))+'%' else '' end +
Case When Max(cast(Case When ICalc.LMFactor=0 Then 1 Else ICalc.LMFactor End as Numeric(38,8)))<>1 Then ' x '+cast(Max(cast(Case When ICalc.LMFactor=0 Then 1 Else ICalc.LMFactor End as Numeric(38,8))) as varchar(10)) else '' end
From      
(
Select ICalc.ANO, ICalc.INO, ICalc.Currency, ICalc.Code, ICalc.SDate, ICalc.EDate, Case When ICalc.SRate='Flat' then 100 else ICalc.PCTAdj end as PCTAdj, sum(ICalc.Reinstatement) as Gross, Max(ICalc.SRate) as SRate, Max(ICalc.Indemnity) as TSI, sum(ICalc.Rate) as Rate, Max(ICalc.sProrata) as sProrata, Max(coalesce(ICALC.LMFACTOR,0)) as LMFACTOR      
from ICalc, Acceptance Where Acceptance.EMethod='R' and ICalc.ANO=Acceptance.ANO and Acceptance.ANO=@P_ANO and ICalc.Rate<>0      
Group By ICalc.ANO, ICalc.INO, ICalc.Currency, ICalc.Code, ICalc.SDate, ICalc.EDate, Case When ICalc.SRate='Flat' then 100 else ICalc.PCTAdj end      
) ICalc, RCover      
Where RCOVER.ANO = ICALC.ANO And RCOVER.Code = ICALC.Code And RCOVER.SDate = ICALC.SDate And RCOVER.EDate = ICALC.EDate      
Group By ICalc.ANO, ICalc.Currency, ICalc.Code, ICalc.SDate, ICalc.EDate, ICalc.PCTadj      
)     



GO

--PATCH 2021 (26)

DROP FUNCTION PREMIUM_CALCULATION_BASE
GO
CREATE FUNCTION PREMIUM_CALCULATION_BASE(@P_ANO int)                  

RETURNS @PCALC TABLE (ANO Int, Currency varchar(10), CANO int, Code varchar(10), SDate SmallDatetime, EDate SmallDatetime, PolicyYear Int, NoRefundF Int, MinimumPremiumF Bit, Premium Float)
AS
BEGIN

DECLARE @ACCEPTANCE TABLE (ANO Int, CNO Int, SDate SmallDateTime, EDate SmallDateTime, STime Varchar(5), ETime varchar(5), NOREFUNDF Int, EXCLUSIVEF Bit, AType varchar(10), PDate SmallDateTime, CPCT Float, QTY Int, PANO Int, EMethod varchar(1))
INSERT INTO @ACCEPTANCE
SELECT ANO, CNO, SDATE, EDate, STime, ETime, NOREFUNDF, EXCLUSIVEF, ATYPE, PDATE, CPCT, QTY, PANO, EMETHOD 
FROM ACCEPTANCE WHERE ANO=@P_ANO

INSERT INTO @PCALC
Select ANO, Currency, CANO, Code, SDate, EDate, PolicyYear, NoRefundF, Cast(Max(MinimumPremiumF) as Bit) as MinimumPremiumF, sum(Premium) as Premium
 from (                  
  select Acceptance.ANO, RCalc.Currency, @P_ANO as CANO, RCalc.Code,  RCalc.SDate, RCalc.Edate, cast(datediff(Month,Acceptance.SDate, RCalc.SDate) as integer) / 12 + 1  as PolicyYear,          
  Acceptance.NoRefundF,   
  Case When Upper(PCALC.DESCRIPTION) in ('MINIMUM PREMIUM','POLICY MINIMUM PREMIUM') Then 1 else 0 end as MinimumPremiumF,                                       
  case                  
  When Acceptance.Atype<>'N' and (RCover.NoRefundF=1 or Acceptance.NoRefundF in (2,4) or (Acceptance.NoRefundF in (1) and DateDiff(day, acceptance.pdate, RCalc.SDate) <= 0)) Then 0
  When Acceptance.AType<>'N' then                  
   case                  
   when DateDiff(day, rcalc.Edate, acceptance.pdate)>=0 then 0                  
   when DateDiff(day, acceptance.pdate, rcalc.SDate)>0 then 1                  
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
  Left Join ISource on (ISource.CNO=Cover.CNO)
  Where Acceptance.ANO=@P_ANO 
  and Acceptance.AType not in ('A','C')                  
  and PCalc.Gross<>0          
                                                    
  Union All                  
                                                                                             
  select Acceptance.ANO, RCalc.Currency, Acceptance.PANO as CANO, RCalc.Code, RCalc.SDate, RCalc.Edate, cast(datediff(Month,pAcceptance.SDate, RCalc.SDate) as integer) / 12 + 1 as PolicyYear,          
  Acceptance.NoRefundF,   
  Case When Upper(PCALC.DESCRIPTION) in ('MINIMUM PREMIUM','POLICY MINIMUM PREMIUM') Then 1 else 0 end as MinimumPremiumF,                                       
  -case     
  When Acceptance.Atype<>'N' and (coalesce(RCover.NoRefundF,0)=1 or Acceptance.NoRefundF in (2,4) or (Acceptance.NoRefundF in (1) and DateDiff(day, acceptance.pdate, RCalc.SDate) <= 0)) Then 0
  when DateDiff(day, rcalc.Edate, acceptance.pdate)>=0 and acceptance.pdate between pacceptance.sdate and pacceptance.edate then 0                  
  when DateDiff(day, acceptance.pdate, rcalc.SDate)>0 and acceptance.pdate between pacceptance.sdate and pacceptance.edate then 1                  
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
  * (Case When Acceptance.CPCT=0 and Acceptance.AType='C' and Acceptance.EMethod<>'A' and RCover.CPRefund<>0 and Not (DateDiff(day, acceptance.pdate, rcalc.SDate)>0 and acceptance.pdate between pacceptance.sdate and pacceptance.edate) Then RCover.CPRefund/100 else 1 end) as Premium      
  from @Acceptance Acceptance 
  inner join Acceptance pAcceptance on (pAcceptance.ANO=Acceptance.pANO) 
  inner Join Cover on (Cover.CNO=pAcceptance.CNO)                  
  inner join PCalc on (PCalc.ANO=pAcceptance.ANO) 
  inner join RCalc on (RCalc.ANO=PCalc.ANO and RCalc.Currency=PCalc.Currency)                  
  Left Join ISource on (ISource.CNO=Cover.CNO)
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
  Left Join ISource on (ISource.CNO=sAcceptance.CNO)
  Where Acceptance.ANO=@P_ANO 
  and Acceptance.AType='A'                  
  and PCalc.Gross<>0   
        
) T                  
                                      
Group By ANO, Currency, CANO, Code, SDate, EDate, PolicyYear, NoRefundF  

RETURN

END


GO

--PATCH 2021 (27)
DROP Function Get_RateLoading
GO
CREATE Function Get_RateLoading(@P_ANO as int,@P_Code as varchar(20), @P_PDate as datetime, @P_TSI as Float) 
RETURNS @RateCon TABLE (Loading Float, HoldF bit, HoldMessage varchar(512), CID varchar(512), AggregateTSI Float, SRate Float)   
AS     
BEGIN       
Declare @SPeriod Int
Declare @SDate smalldatetime
Declare @EDate smalldatetime
Declare @TOPRO varchar(10)
Declare @PHolder varchar(10)
Declare @AID varchar(10)
Declare @CheckRateConSIBy int
Declare @OANO Int
Declare @REGID varchar(10)
Declare @FLDID varchar(255)
Declare @VALUEID varchar(255)
Declare @AgeMethod Int


Declare @RateTab Table (
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

Declare @Loading as Float
Declare @HoldF as Bit
Declare @HoldMessage as varchar(512)
Declare @CID as varchar(512)
Declare @SRate as Float
Declare @Prorata as int
Declare @PPeriod as int
Declare @ExclusiveF as bit
Declare @STime as varchar(10)
Declare @ETime as varchar(10)

Select @Loading=1
Select @HoldF=0
Select @HoldMessage=''
Select @CID=''
Select @SRate=0


Select @AgeMethod=TOC.AgeMethod, @OANO=A.OANO, @RegID=A.RegID, @FLDID=A.FLDID, @ValueID=A.ValueID, @PHolder=C.PHolder, @AID=A.AID, @SDate=@P_PDate, @EDate=A.EDate, @TOPRO=A.TOPRO, @CheckRateConSIBy=coalesce(T.CheckRateConSIBy,0), @SPeriod=RateTab.SPeriod, @Prorata=C.PRORATA, @PPERIOD=C.PPERIOD, @ExclusiveF=A.EXCLUSIVEF, @STime=A.STime, @ETime=A.ETime
from Acceptance A 
Inner Join Cover C on (C.CNO=A.CNO) 
Inner Join TOC on (TOC.TOC=A.TOC) 
Left Join TOPRO T on (T.TOPRO=A.TOPRO)
Inner join RateTab on (RateTab.Code=@P_Code)
Where A.ANO=@P_ANO 

Select @P_TSI=@P_TSI+case 
	When @CheckRateConSIBy=1 Then dbo.fn_GetTotalSumInsuredByProduct(@P_PDate,@TOPRO,@RegID, @FLDID, @VALUEID,@OANO)
	When @CheckRateConSIBy=2 Then dbo.fn_GetTotalSumInsuredByPHolder(@P_PDate,@PHolder,@RegID, @FLDID, @VALUEID,@OANO)
	When @CheckRateConSIBy=3 Then dbo.fn_GetTotalSumInsured(@P_PDate,@RegID, @FLDID, @VALUEID,@OANO)
	When @CheckRateConSIBy=4 Then dbo.fn_GetTotalSumInsuredByProductAndPHolder(@P_PDate,@TOPRO, @PHolder, @OANO)
	When @CheckRateConSIBy=5 Then dbo.fn_GetTotalSumInsuredByProductAndInsured(@P_PDate,@TOPRO, @AID, @OANO)	
	else 0
	end

insert into @RateTab
SELECT Top 1 
coalesce(G1.ValueID,(Select Top 1 G.ValueID from GendTab G Where G.FLDID=AInfo.FLDID1 and G.AllowedF=1 and ((G.Formula='AGE' and dbo.fn_Age(AInfo.ValueDesc1,@P_PDate, Case When @AgeMethod>=0 then @AgeMethod else H1.AgeMethod end) between dbo.fn_toval(G.FLower) and dbo.fn_toval(G.FUpper)) or (G.Formula='VALUE' and dbo.fn_toval(AInfo.ValueDesc1) between dbo.fn_toval(G.FLower) and dbo.fn_toval(G.FUpper))))) as ValueID1,
coalesce(G2.ValueID,(Select Top 1 G.ValueID from GendTab G Where G.FLDID=AInfo.FLDID2 and G.AllowedF=1 and ((G.Formula='AGE' and dbo.fn_Age(AInfo.ValueDesc2,@P_PDate, Case When @AgeMethod>=0 then @AgeMethod else H2.AgeMethod end) between dbo.fn_toval(G.FLower) and dbo.fn_toval(G.FUpper)) or (G.Formula='VALUE' and dbo.fn_toval(AInfo.ValueDesc2) between dbo.fn_toval(G.FLower) and dbo.fn_toval(G.FUpper))))) as ValueID2,
coalesce(G3.ValueID,(Select Top 1 G.ValueID from GendTab G Where G.FLDID=AInfo.FLDID3 and G.AllowedF=1 and ((G.Formula='AGE' and dbo.fn_Age(AInfo.ValueDesc3,@P_PDate, Case When @AgeMethod>=0 then @AgeMethod else H3.AgeMethod end) between dbo.fn_toval(G.FLower) and dbo.fn_toval(G.FUpper)) or (G.Formula='VALUE' and dbo.fn_toval(AInfo.ValueDesc3) between dbo.fn_toval(G.FLower) and dbo.fn_toval(G.FUpper))))) as ValueID3,
coalesce(G4.ValueID,(Select Top 1 G.ValueID from GendTab G Where G.FLDID=AInfo.FLDID4 and G.AllowedF=1 and ((G.Formula='AGE' and dbo.fn_Age(AInfo.ValueDesc4,@P_PDate, Case When @AgeMethod>=0 then @AgeMethod else H4.AgeMethod end) between dbo.fn_toval(G.FLower) and dbo.fn_toval(G.FUpper)) or (G.Formula='VALUE' and dbo.fn_toval(AInfo.ValueDesc4) between dbo.fn_toval(G.FLower) and dbo.fn_toval(G.FUpper))))) as ValueID4,
coalesce(G5.ValueID,(Select Top 1 G.ValueID from GendTab G Where G.FLDID=AInfo.FLDID5 and G.AllowedF=1 and ((G.Formula='AGE' and dbo.fn_Age(AInfo.ValueDesc5,@P_PDate, Case When @AgeMethod>=0 then @AgeMethod else H5.AgeMethod end) between dbo.fn_toval(G.FLower) and dbo.fn_toval(G.FUpper)) or (G.Formula='VALUE' and dbo.fn_toval(AInfo.ValueDesc5) between dbo.fn_toval(G.FLower) and dbo.fn_toval(G.FUpper))))) as ValueID5,
coalesce(G6.ValueID,(Select Top 1 G.ValueID from GendTab G Where G.FLDID=AInfo.FLDID6 and G.AllowedF=1 and ((G.Formula='AGE' and dbo.fn_Age(AInfo.ValueDesc6,@P_PDate, Case When @AgeMethod>=0 then @AgeMethod else H6.AgeMethod end) between dbo.fn_toval(G.FLower) and dbo.fn_toval(G.FUpper)) or (G.Formula='VALUE' and dbo.fn_toval(AInfo.ValueDesc6) between dbo.fn_toval(G.FLower) and dbo.fn_toval(G.FUpper))))) as ValueID6,
coalesce(G7.ValueID,(Select Top 1 G.ValueID from GendTab G Where G.FLDID=AInfo.FLDID7 and G.AllowedF=1 and ((G.Formula='AGE' and dbo.fn_Age(AInfo.ValueDesc7,@P_PDate, Case When @AgeMethod>=0 then @AgeMethod else H7.AgeMethod end) between dbo.fn_toval(G.FLower) and dbo.fn_toval(G.FUpper)) or (G.Formula='VALUE' and dbo.fn_toval(AInfo.ValueDesc7) between dbo.fn_toval(G.FLower) and dbo.fn_toval(G.FUpper))))) as ValueID7,
coalesce(G8.ValueID,(Select Top 1 G.ValueID from GendTab G Where G.FLDID=AInfo.FLDID8 and G.AllowedF=1 and ((G.Formula='AGE' and dbo.fn_Age(AInfo.ValueDesc8,@P_PDate, Case When @AgeMethod>=0 then @AgeMethod else H8.AgeMethod end) between dbo.fn_toval(G.FLower) and dbo.fn_toval(G.FUpper)) or (G.Formula='VALUE' and dbo.fn_toval(AInfo.ValueDesc8) between dbo.fn_toval(G.FLower) and dbo.fn_toval(G.FUpper))))) as ValueID8,
coalesce(G9.ValueID,(Select Top 1 G.ValueID from GendTab G Where G.FLDID=AInfo.FLDID9 and G.AllowedF=1 and ((G.Formula='AGE' and dbo.fn_Age(AInfo.ValueDesc9,@P_PDate, Case When @AgeMethod>=0 then @AgeMethod else H9.AgeMethod end) between dbo.fn_toval(G.FLower) and dbo.fn_toval(G.FUpper)) or (G.Formula='VALUE' and dbo.fn_toval(AInfo.ValueDesc9) between dbo.fn_toval(G.FLower) and dbo.fn_toval(G.FUpper))))) as ValueID9,
coalesce(G10.ValueID,(Select Top 1 G.ValueID from GendTab G Where G.FLDID=AInfo.FLDID10 and G.AllowedF=1 and ((G.Formula='AGE' and dbo.fn_Age(AInfo.ValueDesc10,@P_PDate, Case When @AgeMethod>=0 then @AgeMethod else H10.AgeMethod end) between dbo.fn_toval(G.FLower) and dbo.fn_toval(G.FUpper)) or (G.Formula='VALUE' and dbo.fn_toval(AInfo.ValueDesc10) between dbo.fn_toval(G.FLower) and dbo.fn_toval(G.FUpper))))) as ValueID10,
coalesce(G11.ValueID,(Select Top 1 G.ValueID from GendTab G Where G.FLDID=AInfo.FLDID11 and G.AllowedF=1 and ((G.Formula='AGE' and dbo.fn_Age(AInfo.ValueDesc11,@P_PDate, Case When @AgeMethod>=0 then @AgeMethod else H11.AgeMethod end) between dbo.fn_toval(G.FLower) and dbo.fn_toval(G.FUpper)) or (G.Formula='VALUE' and dbo.fn_toval(AInfo.ValueDesc11) between dbo.fn_toval(G.FLower) and dbo.fn_toval(G.FUpper))))) as ValueID11,
coalesce(G12.ValueID,(Select Top 1 G.ValueID from GendTab G Where G.FLDID=AInfo.FLDID12 and G.AllowedF=1 and ((G.Formula='AGE' and dbo.fn_Age(AInfo.ValueDesc12,@P_PDate, Case When @AgeMethod>=0 then @AgeMethod else H12.AgeMethod end) between dbo.fn_toval(G.FLower) and dbo.fn_toval(G.FUpper)) or (G.Formula='VALUE' and dbo.fn_toval(AInfo.ValueDesc12) between dbo.fn_toval(G.FLower) and dbo.fn_toval(G.FUpper))))) as ValueID12,
coalesce(G13.ValueID,(Select Top 1 G.ValueID from GendTab G Where G.FLDID=AInfo.FLDID13 and G.AllowedF=1 and ((G.Formula='AGE' and dbo.fn_Age(AInfo.ValueDesc13,@P_PDate, Case When @AgeMethod>=0 then @AgeMethod else H13.AgeMethod end) between dbo.fn_toval(G.FLower) and dbo.fn_toval(G.FUpper)) or (G.Formula='VALUE' and dbo.fn_toval(AInfo.ValueDesc13) between dbo.fn_toval(G.FLower) and dbo.fn_toval(G.FUpper))))) as ValueID13,
coalesce(G14.ValueID,(Select Top 1 G.ValueID from GendTab G Where G.FLDID=AInfo.FLDID14 and G.AllowedF=1 and ((G.Formula='AGE' and dbo.fn_Age(AInfo.ValueDesc14,@P_PDate, Case When @AgeMethod>=0 then @AgeMethod else H14.AgeMethod end) between dbo.fn_toval(G.FLower) and dbo.fn_toval(G.FUpper)) or (G.Formula='VALUE' and dbo.fn_toval(AInfo.ValueDesc14) between dbo.fn_toval(G.FLower) and dbo.fn_toval(G.FUpper))))) as ValueID14,
coalesce(G15.ValueID,(Select Top 1 G.ValueID from GendTab G Where G.FLDID=AInfo.FLDID15 and G.AllowedF=1 and ((G.Formula='AGE' and dbo.fn_Age(AInfo.ValueDesc15,@P_PDate, Case When @AgeMethod>=0 then @AgeMethod else H15.AgeMethod end) between dbo.fn_toval(G.FLower) and dbo.fn_toval(G.FUpper)) or (G.Formula='VALUE' and dbo.fn_toval(AInfo.ValueDesc15) between dbo.fn_toval(G.FLower) and dbo.fn_toval(G.FUpper))))) as ValueID15
From AINFO
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
 Left Join GenDTab G1 on (H1.FLDTAB=1 and G1.FLDID=AInfo.FLDID1 and G1.ValueID=AInfo.ValueID1)
 Left Join GenDTab G2 on (H2.FLDTAB=1 and G2.FLDID=AInfo.FLDID2 and G2.ValueID=AInfo.ValueID2)
 Left Join GenDTab G3 on (H3.FLDTAB=1 and G3.FLDID=AInfo.FLDID3 and G3.ValueID=AInfo.ValueID3)
 Left Join GenDTab G4 on (H4.FLDTAB=1 and G4.FLDID=AInfo.FLDID4 and G4.ValueID=AInfo.ValueID4)
 Left Join GenDTab G5 on (H5.FLDTAB=1 and G5.FLDID=AInfo.FLDID5 and G5.ValueID=AInfo.ValueID5)
 Left Join GenDTab G6 on (H6.FLDTAB=1 and G6.FLDID=AInfo.FLDID6 and G6.ValueID=AInfo.ValueID6)
 Left Join GenDTab G7 on (H7.FLDTAB=1 and G7.FLDID=AInfo.FLDID7 and G7.ValueID=AInfo.ValueID7)
 Left Join GenDTab G8 on (H8.FLDTAB=1 and G8.FLDID=AInfo.FLDID8 and G8.ValueID=AInfo.ValueID8)
 Left Join GenDTab G9 on (H9.FLDTAB=1 and G9.FLDID=AInfo.FLDID9 and G9.ValueID=AInfo.ValueID9)
 Left Join GenDTab G10 on (H10.FLDTAB=1 and G10.FLDID=AInfo.FLDID10 and G10.ValueID=AInfo.ValueID10)
 Left Join GenDTab G11 on (H11.FLDTAB=1 and G11.FLDID=AInfo.FLDID11 and G11.ValueID=AInfo.ValueID11)
 Left Join GenDTab G12 on (H12.FLDTAB=1 and G12.FLDID=AInfo.FLDID12 and G12.ValueID=AInfo.ValueID12)
 Left Join GenDTab G13 on (H13.FLDTAB=1 and G13.FLDID=AInfo.FLDID13 and G13.ValueID=AInfo.ValueID13)
 Left Join GenDTab G14 on (H14.FLDTAB=1 and G14.FLDID=AInfo.FLDID14 and G14.ValueID=AInfo.ValueID14)
 Left Join GenDTab G15 on (H15.FLDTAB=1 and G15.FLDID=AInfo.FLDID15 and G15.ValueID=AInfo.ValueID15)
WHERE AINFO.ANO=@P_ANO                       

Declare @Temp_Loading as Float
Declare @Temp_HoldF as Bit
Declare @Temp_HoldMessage as varchar(512)
Declare @Temp_CID as varchar(512)
Declare @Temp_SRate as Float

--Rate Loading #1
Select @Temp_Loading=Null
Select @Temp_HoldF=Null
Select @Temp_HoldMessage=Null
Select @Temp_CID=Null
Select @Temp_SRate=Null

SELECT Top 1 @Temp_Loading=RateCon.Loading, @Temp_HoldF=RateCon.HoldF, @Temp_HoldMessage=RateCon.HoldMessage, @Temp_CID=RateCon.CID, @Temp_SRate=RateCon.SRate
From @RateTab RateTab
INNER JOIN RateCon_M1 RateCon  on (
RateCon.Code=@P_Code and RateCon.AllowedF=1
And ((Case When @P_TSI=0 Then 1 Else @P_TSI End)>=RateCon.MinTSI or RateCon.MinTSI=0) 
and ((Case When @P_TSI=0 Then 1 Else @P_TSI End)<=RateCon.MaxTSI or RateCon.MaxTSI=0)     
And (
	 (@SPeriod=0 and (    
	 (ceiling(dbo.fn_Premium_Calc_Prorata(@SDate, case When @ExclusiveF=0 and @STime<@ETime Then dateadd(day,1,@EDate) else @EDate End,@Prorata,12,CASE WHEN @PPeriod in (0,1,2) Then 2 ELSE @PPeriod END)*12)>=RateCon.MinPeriod)     
	 or RateCon.MinPeriod=0)             
	 And (    
	 (ceiling(dbo.fn_Premium_Calc_Prorata(@SDate, case When @ExclusiveF=0 and @STime<@ETime Then dateadd(day,1,@EDate) else @EDate End,@Prorata,12,CASE WHEN @PPeriod in (0,1,2) Then 2 ELSE @PPeriod END)*12)<=RateCon.MaxPeriod)     
	 or RateCon.MaxPeriod=0)) OR
	(@SPeriod=1 
	 and ((datediff(day, @SDate, @EDate)>=RateCon.MinPeriod) or RateCon.MinPeriod=0)
	 And ((datediff(day, @SDate, @EDate)<=RateCon.MaxPeriod) or RateCon.MaxPeriod=0))
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

if @Temp_CID is null
	Select @Temp_CID=''

if @Temp_CID<>''
Begin
	Select @CID=@CID+'|'+@Temp_CID
End

if @Temp_SRate is null
	Select @Temp_SRate=0

Select @SRate=@SRate+@Temp_SRate 
	
--Rate Loading #2
Select @Temp_Loading=Null
Select @Temp_HoldF=Null
Select @Temp_HoldMessage=Null
Select @Temp_CID=Null
Select @Temp_SRate=Null

SELECT Top 1 @Temp_Loading=RateCon.Loading, @Temp_HoldF=RateCon.HoldF, @Temp_HoldMessage=RateCon.HoldMessage, @Temp_CID=RateCon.CID, @Temp_SRate=RateCon.SRate
From @RateTab RateTab
INNER JOIN RateCon_M2 RateCon  on (
RateCon.Code=@P_Code and RateCon.AllowedF=1                 
And ((Case When @P_TSI=0 Then 1 Else @P_TSI End)>=RateCon.MinTSI or RateCon.MinTSI=0) 
and ((Case When @P_TSI=0 Then 1 Else @P_TSI End)<=RateCon.MaxTSI or RateCon.MaxTSI=0)     
And (
	 (@SPeriod=0 and (    
	 (ceiling(dbo.fn_Premium_Calc_Prorata(@SDate, case When @ExclusiveF=0 and @STime<@ETime Then dateadd(day,1,@EDate) else @EDate End,@Prorata,12,CASE WHEN @PPeriod in (0,1,2) Then 2 ELSE @PPeriod END)*12)>=RateCon.MinPeriod)     
	 or RateCon.MinPeriod=0)                               
	 And (    
	 (ceiling(dbo.fn_Premium_Calc_Prorata(@SDate, case When @ExclusiveF=0 and @STime<@ETime Then dateadd(day,1,@EDate) else @EDate End,@Prorata,12,CASE WHEN @PPeriod in (0,1,2) Then 2 ELSE @PPeriod END)*12)<=RateCon.MaxPeriod)     
	 or RateCon.MaxPeriod=0)) OR
	(@SPeriod=1 
	 and ((datediff(day, @SDate, @EDate)>=RateCon.MinPeriod) or RateCon.MinPeriod=0)
	 And ((datediff(day, @SDate, @EDate)<=RateCon.MaxPeriod) or RateCon.MaxPeriod=0))
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

if @Temp_CID is null
	Select @Temp_CID=''

if @Temp_CID<>''
Begin
	Select @CID=@CID+'|'+@Temp_CID
End

if @Temp_SRate is null
	Select @Temp_SRate=0

Select @SRate=@SRate+@Temp_SRate 

--Rate Loading #3
Select @Temp_Loading=Null
Select @Temp_HoldF=Null
Select @Temp_HoldMessage=Null
Select @Temp_CID=Null
Select @Temp_SRate=Null

SELECT Top 1 @Temp_Loading=RateCon.Loading, @Temp_HoldF=RateCon.HoldF, @Temp_HoldMessage=RateCon.HoldMessage, @Temp_CID=RateCon.CID, @Temp_SRate=RateCon.SRate
From @RateTab RateTab
INNER JOIN RateCon_M3 RateCon  on (
RateCon.Code=@P_Code and RateCon.AllowedF=1                 
And ((Case When @P_TSI=0 Then 1 Else @P_TSI End)>=RateCon.MinTSI or RateCon.MinTSI=0) 
and ((Case When @P_TSI=0 Then 1 Else @P_TSI End)<=RateCon.MaxTSI or RateCon.MaxTSI=0)     
And (
	 (@SPeriod=0 and (    
	 (ceiling(dbo.fn_Premium_Calc_Prorata(@SDate, case When @ExclusiveF=0 and @STime<@ETime Then dateadd(day,1,@EDate) else @EDate End,@Prorata,12,CASE WHEN @PPeriod in (0,1,2) Then 2 ELSE @PPeriod END)*12)>=RateCon.MinPeriod)     
	 or RateCon.MinPeriod=0)                               
	 And (    
	 (ceiling(dbo.fn_Premium_Calc_Prorata(@SDate, case When @ExclusiveF=0 and @STime<@ETime Then dateadd(day,1,@EDate) else @EDate End,@Prorata,12,CASE WHEN @PPeriod in (0,1,2) Then 2 ELSE @PPeriod END)*12)<=RateCon.MaxPeriod)     
	 or RateCon.MaxPeriod=0)) OR
	(@SPeriod=1 
	 and ((datediff(day, @SDate, @EDate)>=RateCon.MinPeriod) or RateCon.MinPeriod=0)
	 And ((datediff(day, @SDate, @EDate)<=RateCon.MaxPeriod) or RateCon.MaxPeriod=0))
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

if @Temp_CID is null
	Select @Temp_CID=''

if @Temp_CID<>''
Begin
	Select @CID=@CID+'|'+@Temp_CID
End

if @Temp_SRate is null
	Select @Temp_SRate=0

Select @SRate=@SRate+@Temp_SRate 

--Rate Loading #4
Select @Temp_Loading=Null
Select @Temp_HoldF=Null
Select @Temp_HoldMessage=Null
Select @Temp_CID=Null
Select @Temp_SRate=Null

SELECT Top 1 @Temp_Loading=RateCon.Loading, @Temp_HoldF=RateCon.HoldF, @Temp_HoldMessage=RateCon.HoldMessage, @Temp_CID=RateCon.CID, @Temp_SRate=RateCon.SRate
From @RateTab RateTab
INNER JOIN RateCon_M4 RateCon  on (
RateCon.Code=@P_Code and RateCon.AllowedF=1                 
And ((Case When @P_TSI=0 Then 1 Else @P_TSI End)>=RateCon.MinTSI or RateCon.MinTSI=0) 
and ((Case When @P_TSI=0 Then 1 Else @P_TSI End)<=RateCon.MaxTSI or RateCon.MaxTSI=0)     
And (
	 (@SPeriod=0 and (    
	 (ceiling(dbo.fn_Premium_Calc_Prorata(@SDate, case When @ExclusiveF=0 and @STime<@ETime Then dateadd(day,1,@EDate) else @EDate End,@Prorata,12,CASE WHEN @PPeriod in (0,1,2) Then 2 ELSE @PPeriod END)*12)>=RateCon.MinPeriod)     
	 or RateCon.MinPeriod=0)                               
	 And (    
	 (ceiling(dbo.fn_Premium_Calc_Prorata(@SDate, case When @ExclusiveF=0 and @STime<@ETime Then dateadd(day,1,@EDate) else @EDate End,@Prorata,12,CASE WHEN @PPeriod in (0,1,2) Then 2 ELSE @PPeriod END)*12)<=RateCon.MaxPeriod)     
	 or RateCon.MaxPeriod=0)) OR
	(@SPeriod=1 
	 and ((datediff(day, @SDate, @EDate)>=RateCon.MinPeriod) or RateCon.MinPeriod=0)
	 And ((datediff(day, @SDate, @EDate)<=RateCon.MaxPeriod) or RateCon.MaxPeriod=0))
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

if @Temp_CID is null
	Select @Temp_CID=''

if @Temp_CID<>''
Begin
	Select @CID=@CID+'|'+@Temp_CID
End

if @Temp_SRate is null
	Select @Temp_SRate=0

Select @SRate=@SRate+@Temp_SRate 

--Rate Loading #5
Select @Temp_Loading=Null
Select @Temp_HoldF=Null
Select @Temp_HoldMessage=Null
Select @Temp_CID=Null
Select @Temp_SRate=Null

SELECT Top 1 @Temp_Loading=RateCon.Loading, @Temp_HoldF=RateCon.HoldF, @Temp_HoldMessage=RateCon.HoldMessage, @Temp_CID=RateCon.CID, @Temp_SRate=RateCon.SRate
From @RateTab RateTab
INNER JOIN RateCon_M5 RateCon  on (
RateCon.Code=@P_Code and RateCon.AllowedF=1                 
And ((Case When @P_TSI=0 Then 1 Else @P_TSI End)>=RateCon.MinTSI or RateCon.MinTSI=0) 
and ((Case When @P_TSI=0 Then 1 Else @P_TSI End)<=RateCon.MaxTSI or RateCon.MaxTSI=0)     
And (
	 (@SPeriod=0 and (    
	 (ceiling(dbo.fn_Premium_Calc_Prorata(@SDate, case When @ExclusiveF=0 and @STime<@ETime Then dateadd(day,1,@EDate) else @EDate End,@Prorata,12,CASE WHEN @PPeriod in (0,1,2) Then 2 ELSE @PPeriod END)*12)>=RateCon.MinPeriod)     
	 or RateCon.MinPeriod=0)      
	 And (    
	 (ceiling(dbo.fn_Premium_Calc_Prorata(@SDate, case When @ExclusiveF=0 and @STime<@ETime Then dateadd(day,1,@EDate) else @EDate End,@Prorata,12,CASE WHEN @PPeriod in (0,1,2) Then 2 ELSE @PPeriod END)*12)<=RateCon.MaxPeriod)     
	 or RateCon.MaxPeriod=0)) OR
	(@SPeriod=1 
	 and ((datediff(day, @SDate, @EDate)>=RateCon.MinPeriod) or RateCon.MinPeriod=0)
	 And ((datediff(day, @SDate, @EDate)<=RateCon.MaxPeriod) or RateCon.MaxPeriod=0))
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

if @Temp_CID is null
	Select @Temp_CID=''

if @Temp_CID<>''
Begin
	Select @CID=@CID+'|'+@Temp_CID
End

if @Temp_SRate is null
	Select @Temp_SRate=0

Select @SRate=@SRate+@Temp_SRate 

--Rate Loading #6
Select @Temp_Loading=Null
Select @Temp_HoldF=Null
Select @Temp_HoldMessage=Null
Select @Temp_CID=Null
Select @Temp_SRate=Null

SELECT Top 1 @Temp_Loading=RateCon.Loading, @Temp_HoldF=RateCon.HoldF, @Temp_HoldMessage=RateCon.HoldMessage, @Temp_CID=RateCon.CID, @Temp_SRate=RateCon.SRate
From @RateTab RateTab
INNER JOIN RateCon_M6 RateCon  on (
RateCon.Code=@P_Code and RateCon.AllowedF=1                 
And ((Case When @P_TSI=0 Then 1 Else @P_TSI End)>=RateCon.MinTSI or RateCon.MinTSI=0) 
and ((Case When @P_TSI=0 Then 1 Else @P_TSI End)<=RateCon.MaxTSI or RateCon.MaxTSI=0)     
And (
	 (@SPeriod=0 and (    
	 (ceiling(dbo.fn_Premium_Calc_Prorata(@SDate, case When @ExclusiveF=0 and @STime<@ETime Then dateadd(day,1,@EDate) else @EDate End,@Prorata,12,CASE WHEN @PPeriod in (0,1,2) Then 2 ELSE @PPeriod END)*12)>=RateCon.MinPeriod)     
	 or RateCon.MinPeriod=0)                               
	 And (    
	 (ceiling(dbo.fn_Premium_Calc_Prorata(@SDate, case When @ExclusiveF=0 and @STime<@ETime Then dateadd(day,1,@EDate) else @EDate End,@Prorata,12,CASE WHEN @PPeriod in (0,1,2) Then 2 ELSE @PPeriod END)*12)<=RateCon.MaxPeriod)     
	 or RateCon.MaxPeriod=0)) OR
	(@SPeriod=1 
	 and ((datediff(day, @SDate, @EDate)>=RateCon.MinPeriod) or RateCon.MinPeriod=0)
	 And ((datediff(day, @SDate, @EDate)<=RateCon.MaxPeriod) or RateCon.MaxPeriod=0))
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

if @Temp_CID is null
	Select @Temp_CID=''

if @Temp_CID<>''
Begin
	Select @CID=@CID+'|'+@Temp_CID
End

if @Temp_SRate is null
	Select @Temp_SRate=0

Select @SRate=@SRate+@Temp_SRate 

--Rate Loading #7
Select @Temp_Loading=Null
Select @Temp_HoldF=Null
Select @Temp_HoldMessage=Null
Select @Temp_CID=Null
Select @Temp_SRate=Null

SELECT Top 1 @Temp_Loading=RateCon.Loading, @Temp_HoldF=RateCon.HoldF, @Temp_HoldMessage=RateCon.HoldMessage, @Temp_CID=RateCon.CID, @Temp_SRate=RateCon.SRate
From @RateTab RateTab
INNER JOIN RateCon_M7 RateCon  on (
RateCon.Code=@P_Code and RateCon.AllowedF=1                 
And ((Case When @P_TSI=0 Then 1 Else @P_TSI End)>=RateCon.MinTSI or RateCon.MinTSI=0) 
and ((Case When @P_TSI=0 Then 1 Else @P_TSI End)<=RateCon.MaxTSI or RateCon.MaxTSI=0)     
And (
	 (@SPeriod=0 and (    
	 (ceiling(dbo.fn_Premium_Calc_Prorata(@SDate, case When @ExclusiveF=0 and @STime<@ETime Then dateadd(day,1,@EDate) else @EDate End,@Prorata,12,CASE WHEN @PPeriod in (0,1,2) Then 2 ELSE @PPeriod END)*12)>=RateCon.MinPeriod)     
	 or RateCon.MinPeriod=0)                               
	 And (    
	 (ceiling(dbo.fn_Premium_Calc_Prorata(@SDate, case When @ExclusiveF=0 and @STime<@ETime Then dateadd(day,1,@EDate) else @EDate End,@Prorata,12,CASE WHEN @PPeriod in (0,1,2) Then 2 ELSE @PPeriod END)*12)<=RateCon.MaxPeriod)     
	 or RateCon.MaxPeriod=0)) OR
	(@SPeriod=1 
	 and ((datediff(day, @SDate, @EDate)>=RateCon.MinPeriod) or RateCon.MinPeriod=0)
	 And ((datediff(day, @SDate, @EDate)<=RateCon.MaxPeriod) or RateCon.MaxPeriod=0))
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

if @Temp_CID is null
	Select @Temp_CID=''

if @Temp_CID<>''
Begin
	Select @CID=@CID+'|'+@Temp_CID
End

if @Temp_SRate is null
	Select @Temp_SRate=0

Select @SRate=@SRate+@Temp_SRate 

insert into @RateCon Select @Loading, @HoldF,@HoldMessage,@CID, @P_TSI, @SRate
Return
END  
GO

--PATCH 2021 (28)
DROP Function Get_Payment_Percentage
GO

CREATE Function Get_Payment_Percentage(@P_A_PolicyNo varchar(50), @P_Type varchar(10), @P_DocNO varchar(50), @P_Date smalldatetime, @P_Currency varchar(10))
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
       When @P_TYPE in ('PI','PL') Then Max(V.Payment_CC)
       When Max(V.Payment_CC*V.Rate)<sum((case When V.DebtorF=1 Then 1 else -1 end)*(A.LAmount)*V.Rate) Then 0
       Else Max(V.Payment_CC*V.Rate)-sum((case When V.DebtorF=1 Then 1 else -1 end)*(A.LAmount)*V.Rate)
       End as Payment_CC,

       sum(
              (case When V.DebtorF=1 Then 1 else -1 end)*
              Case
              When @P_Type in ('PI','PL') then (A.Amount)
              Else (A.Amount-A.LAmount)
              End*V.Rate
       ) as Nominal_CC
       from Admlink A
	   Inner Join nVoucher V on (V.Voucher=A.Voucher)
		Where A.Date<=@P_Date and A.A_PolicyNo=@P_A_PolicyNo and A.Currency=@P_Currency
		and A.Subject='Premium' and A.Type in ('DI','IC','IR')
		and (substring(A.DocNo,1,50)+space(50-len(A.DocNo))+convert(varchar(50), A.Date,102))<=(substring(@P_DocNo,1,50)+space(50-len(@P_DocNo))+convert(varchar(50), @P_Date,102)) 
		and (substring(A.DocNo,1,50)+space(50-len(A.DocNo))+convert(varchar(50), A.Date,102))>
		coalesce(
		(
		Select Top 1 (substring(B.DocNo,1,50)+space(50-len(B.DocNo))+convert(varchar(50), B.Date,102)) 
		from Admlink B
		Inner Join Admlink C on (C.Subject='Premium' and C.Type in ('DI','IC','IR') and C.A_PolicyNo=B.A_PolicyNo and C.DocNo=B.DocNO and C.Date=B.Date)
		Where B.Date<=@P_Date and B.A_PolicyNo=@P_A_PolicyNo and B.Currency=@P_Currency
		and (substring(B.DocNo,1,50)+space(50-len(B.DocNo))+convert(varchar(50), B.Date,102))<(substring(@P_DocNo,1,50)+space(50-len(@P_DocNo))+convert(varchar(50), @P_Date,102))  
		and B.Subject='Premium' and B.Type=@P_Type 
		order by B.AdmNo Desc
		),'')
       Group By V.Voucher
) V

Having sum(case When V.DebtorF=1 Then (V.Nominal_CC) Else -(V.Nominal_CC) end)<>0

if @PCT IS NULL 
       SELECT @PCT=100

if @PCT<0
       SELECT @PCT=0

if @PCT>100
       SELECT @PCT=100

Return @PCT
End



GO

--PATCH 2021 (29)
DROP PROCEDURE QCLACC_3
GO
CREATE PROCEDURE QCLACC_3(@P_POLICYNO AS VARCHAR(255), @P_CERTIFICATENO VARCHAR(255), @P_REFNO varchar(50)='', @P_TOC varchar(10)='')     
AS     
SELECT TOP 10 ACCEPTANCE.ANO, ACCEPTANCE.POLICYNO, ACCEPTANCE.CERTIFICATENO, ACCEPTANCE.AID, COVER.INSURED, COVER.ISTYPE, ACCEPTANCE.TOC, ACCEPTANCE.SDATE, ACCEPTANCE.EDATE, Cover.PHolder, ACCEPTANCE.BRANCH, ACCEPTANCE.ANAME, PROFILE.RESTRICTEDF, PROFILE.NAME, ACCEPTANCE.PDATE, ACCEPTANCE.PPDATE, ACCEPTANCE.NCDATE,  ACCEPTANCE.EXTPERIOD,     
Case When GenDTab.Description is not null then ACCEPTANCE.ValueDesc else '' end as Description,     
coalesce(InParty.ID, coalesce(ISource.ID, Acceptance.AID)) as Payment,
coalesce(IProfile.Name, coalesce(PProfile.Name, Profile.Name)) as Payment_Name
FROM ACCEPTANCE WITH (INDEX(I_Acceptance_PolicyNo_CertificateNo))  
Left Join GenDTab On (GenDTab.FLDID=ACCEPTANCE.FLDID AND GenDTab.ValueID=ACCEPTANCE.ValueID)  
Inner Join COVER on (Cover.CNO=Acceptance.CNO)  
Left Join ISource On (ISource.CNO=Cover.CNO)   
Left Join InParty on (InParty.CNO=Cover.CNO and InParty.IType in ('MORTGAGE'))
Left Join Profile PProfile On (PProfile.ID=ISource.ID)  
Left Join Profile IProfile On (IProfile.ID=InParty.ID)  
Left Join Profile on (Profile.ID=Acceptance.AID)  
WHERE ACCEPTANCE.ATYPE Not In ('A','C') AND ACCEPTANCE.AStatus not in ('W','T') and COVER.CStatus not in ('R','P','C')     
AND ACCEPTANCE.PDATE<ACCEPTANCE.PPDATE AND ACCEPTANCE.ANO<>ACCEPTANCE.LANO   
AND ACCEPTANCE.POLICYNO<>'' AND ACCEPTANCE.POLICYNO LIKE @P_POLICYNO AND ACCEPTANCE.CERTIFICATENO LIKE @P_CERTIFICATENO     
AND ACCEPTANCE.TOC LIKE @P_TOC+'%' AND ACCEPTANCE.REFNO LIKE @P_REFNO+'%'  
ORDER BY ACCEPTANCE.ANO DESC     

GO
--2020 V.1.3.1
--4 Mar 2021
IF  NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'CustomErrors') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[CustomErrors](
	[ErrFrom] [varchar](50) NULL,
	[ErrType] [varchar](50) NULL,
	[ErrCat] [varchar](50) NULL,
	[ErrCode] [varchar](50) NULL,
	[ErrMessage] [varchar](255) NULL
) ON [PRIMARY]
Create Unique Index I_CustomErrors on CustomErrors(ErrFrom, ErrType, ErrCat, ErrCode, ErrMessage)
END
GO


--5 MAR 2021
IF NOT EXISTS(SELECT * FROM SYSFORM WHERE FNAME='ALLOWENDORSEWITHCLAIMINCURRED')
BEGIN
insert into sysform(FName, Description, FCode, RequestF)
Select 'ALLOWENDORSEWITHCLAIMINCURRED', 'Allow Endorse With Already Claim Incurred (UW)','ACTIVITIES',0
END
GO

-- 5 MAR 2021 (1)
IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'HoldF' AND Object_ID = Object_ID(N'Scheme_Additional'))
BEGIN
ALTER TABLE Scheme_Additional ADD
	HoldF bit NULL
DECLARE @v sql_variant 
SET @v = N'Hold Flag (0 : No, 1 : Yes)'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'Scheme_Additional', N'COLUMN', N'HoldF'
END
GO


GO
DROP Procedure QScheme_Verify_6 
GO
CREATE Procedure QScheme_Verify_6 
@p_Coverage as varchar (255), 
@p_Interest as varchar (20), 
@p_TSI as float, 
@P_NOfYears as float, 
@p_SchemeNo as varchar (10), 
@p_Description as varchar (255) 
as 

Declare @p_ClassNo int 
Select Top 1 @p_ClassNo=S.ClassNo 
from 
Scheme_Class S
Inner Join Scheme_Coverage S1 on (S1.ClassNo=S.ClassNo and S1.Coverage=@p_Coverage)
Where S.SchemeNo=@P_SchemeNo and @P_Description like S.Description 
Order by S.Priority Desc

Select Top 1 *
from 
(
	Select Top 1 
	S1.Code, 
	cast(0 as Bit) as ProgressiveF,
	(Case When @p_TSI=0 then (Case When S1.IncludeF=1 Then S1.SI else 0 end) else @P_TSI end) as SI, 
	Case       
	When S1.Unit='F' then Case When (Case When @p_TSI=0 then (Case When S1.IncludeF=1 Then S1.SI else 0 end) else @P_TSI end)<>0 Then S1.Rate/(Case When @p_TSI=0 then (Case When S1.IncludeF=1 Then S1.SI else 0 end) else @P_TSI end)*100 else 0 end
	When S1.Unit='M' then S1.Rate/10
	else S1.Rate end
	as Rate,
	S1.Unit, S1.Category, S1.Portion, S1.TOI, S1.NOTDECRF, S1.RateBasedID, 
	TOI.Description as TOIDesc, 
	TOI.Adjustable, 
	RateTab.Description as RateDesc,
	S1.Upper,
	S1.HoldF
	from 
	Scheme_Additional S1
	Inner Join RateTab on (RateTab.Code=S1.Code)
	Inner Join TOI on (TOI.TOI=S1.TOI)
	Where 
	S1.ClassNo=@P_ClassNo and (S1.Coverage='' or S1.Coverage=@P_Coverage) 
	and S1.Interest=@p_Interest 
	and (S1.Lower<=(Case When @p_TSI=0 then (Case When S1.IncludeF=1 Then S1.SI else 0 end) else @P_TSI end) or S1.Lower=0) 
	and (S1.Upper>=(Case When @p_TSI=0 then (Case When S1.IncludeF=1 Then S1.SI else 0 end) else @P_TSI end) or S1.Upper=0) 
	and (S1.NOfYearsL<=@p_NOfYears or S1.NOfYearsL=0) 
	and (S1.NOfYearsU>=@p_NOfYears or S1.NOfYearsU=0) 
	and S1.ProgressiveF=0

	Union All

	Select Top 1 
	S1.Code, 
	cast(1 as Bit) as ProgressiveF,
	Max((Case When @p_TSI=0 then (Case When S1.IncludeF=1 Then S1.SI else 0 end) else @P_TSI end)) as SI, 
	sum(Case       
	When S1.Unit='F' then Case When (Case When @p_TSI=0 then (Case When S1.IncludeF=1 Then S1.SI else 0 end) else @P_TSI end)<>0 Then S1.Rate/
	(Case When @p_TSI=0 then (Case When S1.IncludeF=1 Then S1.SI else 0 end) else @P_TSI end)*100 else 0 end
	When S1.Unit='M' then 
		Case When (Case When @p_TSI=0 then (Case When S1.IncludeF=1 Then S1.SI else 0 end) else @P_TSI end)>=S1.Upper Then S1.Upper-S1.Lower Else (Case When @p_TSI=0 then (Case When S1.IncludeF=1 Then S1.SI else 0 end) else @P_TSI end)-S1.Lower end*S1.Rate/10/(Case When @p_TSI=0 then (Case When S1.IncludeF=1 Then S1.SI else 0 end) else @P_TSI end)
	else 
	    Case When (Case When @p_TSI=0 then (Case When S1.IncludeF=1 Then S1.SI else 0 end) else @P_TSI end)>=S1.Upper Then S1.Upper-S1.Lower Else (Case When @p_TSI=0 then (Case When S1.IncludeF=1 Then S1.SI else 0 end) else @P_TSI end)-S1.Lower end*S1.Rate/(Case When @p_TSI=0 then (Case When S1.IncludeF=1 Then S1.SI else 0 end) else @P_TSI end) end 
	) as Rate,
	Max(S1.Unit) as Unit, Max(S1.Category) as Category, Max(S1.Portion) as Portion, 
	Max(S1.TOI) as TOI, 
	cast(Max(Cast(S1.NOTDECRF as Int)) as Bit) as NOTDECRF, 
	Max(S1.RateBasedID) as RateBasedID, 
	Max(TOI.Description) as TOIDesc, 
	cast(Max(Cast(TOI.Adjustable as Int)) as Bit) as Adjustable, 
	Max(RateTab.Description) as RateDesc,
	Max(S1.Upper) as Upper,
	Cast(Max(cast(S1.HoldF as Int)) as Bit) as HoldF
	from Scheme_Additional S1
	Inner Join RateTab on (RateTab.Code=S1.Code)
	Inner Join TOI on (TOI.TOI=S1.TOI)
	Where S1.ClassNo=@p_ClassNo 	
	and (S1.Coverage='' or S1.Coverage=@P_Coverage) 
	and S1.Interest=@p_Interest 
	and ((Case When @p_TSI=0 then (Case When S1.IncludeF=1 Then S1.SI else 0 end) else @P_TSI end) Between S1.Lower and S1.Upper or (Case When @p_TSI=0 then (Case When S1.IncludeF=1 Then S1.SI else 0 end) else @P_TSI end)>=S1.Upper)
	and (S1.NOfYearsL<=@p_NOfYears or S1.NOfYearsL=0) 
	and (S1.NOfYearsU>=@p_NOfYears or S1.NOfYearsU=0) 
	and S1.ProgressiveF=1 and (Case When @p_TSI=0 then (Case When S1.IncludeF=1 Then S1.SI else 0 end) else @P_TSI end)<>0
	Group BY S1.Code
) R

GO

DROP procedure QSchemeViewAdditional
GO
CREATE procedure QSchemeViewAdditional(@p_SchemeNo varchar(10),@P_Class_Desc as varchar(100))   
as      
select top 50000
 Cast(0 as bit) as ProcessFlag, 
 additional.classno,      
 class.description as class_desc,   
 additional.coverage,  
 additional.interest,      
 additional.toi,      
 toi.description as toi_desc,      
 additional.lower, additional.upper,      
 additional.NOfYearsL, additional.NOfYearsU,      
 additional.SI,    
 additional.code,ratetab.description as ratetab_desc,      
 additional.rate,      
 case       
 when additional.unit = 'M' then 'Per Mil'      
 when additional.unit = 'C' then 'Percentage'      
 when additional.unit = 'F' then 'Flat'      
 else additional.unit      
 end as unit,      
 case       
 when additional.category='A' then 'Additional'      
 when additional.category='M' then 'Main'      
 else additional.category      
 end as category,
 Additional.ProgressiveF,
 Additional.HoldF
from scheme_additional as additional, scheme_class as class, toi,ratetab      
where additional.classno=class.classno 
and additional.toi =toi.toi 
and additional.code=ratetab.code 
and class.schemeno=@p_schemeno and (@P_Class_Desc='<All>' or class.description=@P_Class_Desc)
  
     




     
GO

--10 MAR 2021
DROP Procedure QCDOCLIST
GO
CREATE Procedure QCDOCLIST(@P_CNO integer, @P_INO integer, @P_NOC varchar(10))   
as   
Select CDOCLIST.ProcessFlag, CDOCLIST.RequiredF, CDOCLIST.RequiredBy, CDOCList.RequiredDate, CDOCLIST.MandatoryF, CDOCLIST.DocType, CDOCLIST.Description, CDOCLIST.AvailableF, CDOCLIST.CollectionF, CDOCLIST.RecDate, CDOCLIST.OptionalF, CDOCLIST.REMARKS, Max(CDOCLISTPIC.IMAGEID) as IMAGEID, Count(CDOCLISTPIC.IMAGEID) as CountImage
from   
(   
	select Cast(coalesce(CDOCLIST.AvailableF, 0) as bit) as ProcessFlag, Cast(coalesce(CDOCLIST.requiredF, 0) as bit) as requiredF, CDOCLIST.RequiredBy, CDOCList.RequiredDate, cast(coalesce(DOCLIST.MandatoryF,0) as Bit) as MandatoryF, DOCLIST.DocType, DOCLIST.Description, coalesce(CDOCLIST.AvailableF, 0) as AvailableF, cast(coalesce(DOCTYPE.CollectionF,0) as Bit) as CollectionF, CDOCLIST.RecDate, cast(coalesce(DocType.OptionalF,0) as Bit) as OptionalF, '' as Remarks
	from ICover
	Inner join DocList on (DocList.NOC=@P_NOC and DocList.TOI=ICover.TOI)
	Left join DOCTYPE on (DOCTYPE.DOCTYPE=DOCLIST.DOCTYPE) 
	Left Join CDOCLIST on (CDOCLIST.CNO=@P_CNO and CDOCLIST.INO=ICover.INO and CDOCLIST.DOCTYPE=DOCLIST.DOCTYPE)   
	Where ICover.INO=@P_INO and coalesce(CDOCLIST.DOCTYPE,'')=''
	   
	Union All   
   
	select Cast(coalesce(CDOCLIST.AvailableF, 0) as bit) as ProcessFlag, Cast(coalesce(CDOCLIST.requiredF, 0) as bit) as requiredF, CDOCLIST.RequiredBy, CDOCList.RequiredDate, cast(coalesce(DOCLIST.MandatoryF,0) as Bit) as MandatoryF, CDOCList.DocType, CDOCLIST.Description, CDOCLIST.AvailableF, cast(coalesce(DOCTYPE.CollectionF,0) as Bit) as CollectionF, CDOCLIST.RecDate, cast(coalesce(DocType.OptionalF,0) as Bit) as OptionalF, CDoclist.REMARKS 
	from CDOCLIST 
	Inner Join ICover on (ICover.INO=@P_INO)
	Left Join DocList On (DocList.NOC=CDocList.NOC and DocList.TOI=ICover.TOI and DocList.DocType=CDocList.DocType)
	Left Join DOCTYPE on (DOCTYPE.DOCTYPE=CDOCLIST.DOCTYPE)   
	Where CDOCLIST.CNO=@P_CNO AND CDOCLIST.INO=@P_INO   
) CDOCLIST 
LEFT JOIN CDOCLISTPIC ON (CDOCLISTPIC.CNO=@P_CNO AND CDOCLISTPIC.DOCTYPE=CDOCLIST.DOCTYPE)
Group by CDOCLIST.ProcessFlag, CDOCLIST.RequiredF, CDOCLIST.RequiredBy, CDOCList.RequiredDate, CDOCLIST.MandatoryF, CDOCLIST.DocType, CDOCLIST.Description, CDOCLIST.AvailableF, CDOCLIST.CollectionF, CDOCLIST.RecDate, CDOCLIST.OptionalF, CDOCLIST.REMARKS
Order By CDOCLIST.DOCTYPE   
   





GO

--14 MARET 2021
if exists (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'fn_Get_Effective_Cancellation_By_Payor_Schedule') AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) )
BEGIN
DROP FUNCTION fn_Get_Effective_Cancellation_By_Payor_Schedule
END
GO
CREATE FUNCTION fn_Get_Effective_Cancellation_By_Payor_Schedule(@P_ANO Integer, @P_PDate smalldatetime, @P_EDate smalldatetime)              
RETURNS smalldatetime
AS               
BEGIN              
	Select @P_PDate=coalesce((Select Top 1 Case When InstLDate<@P_Edate then InstlDate else @P_Edate end from Payor_Schedule Where ANO=@P_ANO and InstDate<=@P_PDate and InstLDate>@P_PDate order by InstDate Desc),@P_PDate)
	Return @P_PDate

END  

GO

DROP FUNCTION DISPLAY_PRORATA_CALCULATION
GO
CREATE FUNCTION DISPLAY_PRORATA_CALCULATION(@P_ANO int)        
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
When Acceptance.AType<>'N' then        

 case        
 when DateDiff(day, RCalc.Edate, acceptance.pdate)>=0 then ''
 when DateDiff(day, acceptance.pdate, RCalc.SDate)>0 then ''        
 Else        
  case        
  when acceptance.cpct<>0 or Cover.Voyage=1 then        
   case when acceptance.cpct<>0 and acceptance.cpct<>100 then convert(varchar(25),Cast(Acceptance.CPCT as float),0)+'%' else '' end        
  Else        
	--Prorata Calculation
	Case When Acceptance.EXCLUSIVEF=0 and Acceptance.STime<Acceptance.ETime and RCalc.EDate=Acceptance.EDate Then
		dbo.fn_calc_sprorata(acceptance.pDate, dateadd(day,1,RCalc.edate), RCalc.Sdate, dateadd(day,1,RCalc.edate), Cover.PPeriod)
	else
		dbo.fn_calc_sprorata(acceptance.pDate, RCalc.Edate, RCalc.Sdate, RCalc.EDate, Cover.PPeriod)
	End
  End
 End        
Else        
 ''        
end,        
          
Prorata=        
case        
When Acceptance.AType<>'N' then        
 case        
 when DateDiff(day, RCalc.Edate, acceptance.pdate)>=0 then 0        
 when DateDiff(day, acceptance.pdate, RCalc.SDate)>0 then 1        
 Else        
  case        
  when acceptance.cpct<>0 or Cover.Voyage=1 then        
   case when acceptance.cpct<>0 and acceptance.cpct<>100 then Acceptance.CPCT/100 else 1 end        
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
                                
From acceptance        
inner Join Cover on (Cover.CNO=Acceptance.CNO)        
inner join PCalc on (PCalc.ANO=Acceptance.ANO)        
inner join RCalc on (RCalc.ANO=PCalc.ANO and RCalc.Currency=PCalc.Currency)        
inner Join RCover on (RCover.ANO=Acceptance.ANO and RCover.Code=RCalc.Code and RCover.SDate=RCalc.SDate)        
Where Acceptance.AType not in ('A','C')        
and not (Acceptance.Atype<>'N' and (RCover.NoRefundF=1 or Acceptance.NoRefundF in (2,4) or (Acceptance.NoRefundF in (1) and DateDiff(day, acceptance.pdate, RCalc.SDate) <= 0)))
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
when DateDiff(day, rcalc.Edate, acceptance.pdate)>=0 and acceptance.pdate between pacceptance.sdate and pacceptance.edate then ''        
when DateDiff(day, acceptance.pdate, rcalc.SDate)>0 and acceptance.pdate between pacceptance.sdate and pacceptance.edate then ''        

Else        
  case        
  when acceptance.cpct<>0 or Cover.Voyage=1 then        
    case when acceptance.cpct<>0 and acceptance.cpct<>100 then convert(varchar(25),Cast(Acceptance.CPCT as float),0)+'%' else '' end        
  Else        
    case        
		When Acceptance.SDate<>Acceptance.PDate or Acceptance.NoRefundF=6 then        
			--Prorata Calculation
			Case When pAcceptance.EXCLUSIVEF=0 and pAcceptance.STime<pAcceptance.ETime and RCalc.EDate=pAcceptance.EDate Then
				CASE WHEN RCOVER.CPFORMULA = 'PRORATE SQ' and Acceptance.AType='C' and Acceptance.EMethod<>'A' THEN
					'('+dbo.fn_Calc_SProrata(dbo.fn_Get_Effective_Cancellation_By_Payor_Schedule(Acceptance.ANO, Acceptance.PDate,dateadd(day,1,RCalc.edate)), dateadd(day,1,RCalc.edate), RCalc.Sdate, dateadd(day,1,RCalc.edate), Cover.PPeriod)+') ^ 2'
				ELSE
					CASE WHEN Acceptance.AType='C' and Acceptance.EMethod<>'A' THEN
						dbo.fn_Calc_SProrata(dbo.fn_Get_Effective_Cancellation_By_Payor_Schedule(Acceptance.ANO, Acceptance.PDate,dateadd(day,1,RCalc.edate)), dateadd(day,1,RCalc.edate), RCalc.Sdate, dateadd(day,1,RCalc.edate), Cover.PPeriod)
					Else
						dbo.fn_Calc_SProrata(acceptance.pDate, dateadd(day,1,RCalc.edate), RCalc.Sdate, dateadd(day,1,RCalc.edate), Cover.PPeriod)
					End
				END				
			else
				CASE WHEN RCOVER.CPFORMULA = 'PRORATE SQ' and Acceptance.AType='C' and Acceptance.EMethod<>'A' THEN
					'('+dbo.fn_Calc_SProrata(dbo.fn_Get_Effective_Cancellation_By_Payor_Schedule(Acceptance.ANO, Acceptance.PDate,RCalc.Edate), RCalc.Edate, RCalc.Sdate, RCalc.EDate, Cover.PPeriod)+') ^ 2'
				ELSE
					CASE WHEN Acceptance.AType='C' and Acceptance.EMethod<>'A' THEN
						dbo.fn_Calc_SProrata(dbo.fn_Get_Effective_Cancellation_By_Payor_Schedule(Acceptance.ANO, Acceptance.PDate,RCalc.Edate), RCalc.Edate, RCalc.Sdate, RCalc.EDate, Cover.PPeriod)
					Else
						dbo.fn_Calc_SProrata(acceptance.pDate, RCalc.Edate, RCalc.Sdate, RCalc.EDate, Cover.PPeriod)
					End
				END				
			End

		Else        
		 -- Endorsement Period        
			''        
		End       
	End        
End        
+ (Case When Acceptance.CPCT=0 and Acceptance.AType='C' and Acceptance.EMethod<>'A' and RCover.CPRefund<>0 and not (DateDiff(day, acceptance.pdate, rcalc.SDate)>0 and acceptance.pdate between pacceptance.sdate and pacceptance.edate) Then ' x '+convert(varchar(25),RCover.CPRefund,0)+'%' else '' end)
,        
Prorata=        
case        
when DateDiff(day, rcalc.Edate, acceptance.pdate)>=0 and acceptance.pdate between pacceptance.sdate and pacceptance.edate then 0        
when DateDiff(day, acceptance.pdate, rcalc.SDate)>0  and acceptance.pdate between pacceptance.sdate and pacceptance.edate then 1        

Else        
  case        
  when acceptance.cpct<>0 or Cover.Voyage=1 then        
    case when acceptance.cpct<>0 and acceptance.cpct<>100 then Acceptance.CPCT/100 else 1 end        
  Else        
    case        
		When Acceptance.SDate<>Acceptance.PDate or Acceptance.NoRefundF=6 then        
			--Prorata Calculation
			Case When pAcceptance.EXCLUSIVEF=0 and pAcceptance.STime<pAcceptance.ETime and RCalc.EDate=pAcceptance.EDate Then
				CASE WHEN RCOVER.CPFORMULA = 'PRORATE SQ' and Acceptance.AType='C' and Acceptance.EMethod<>'A' THEN
					POWER(dbo.fn_calc_prorata(dbo.fn_Get_Effective_Cancellation_By_Payor_Schedule(Acceptance.ANO, Acceptance.PDate,dateadd(day,1,RCalc.edate)), dateadd(day,1,RCalc.edate), RCalc.Sdate, dateadd(day,1,RCalc.edate), Cover.PPeriod),2)
				ELSE
					Case When Acceptance.AType='C' and Acceptance.EMethod<>'A' THEN
						dbo.fn_calc_prorata(dbo.fn_Get_Effective_Cancellation_By_Payor_Schedule(Acceptance.ANO, Acceptance.PDate,dateadd(day,1,RCalc.edate)), dateadd(day,1,RCalc.edate), RCalc.Sdate, dateadd(day,1,RCalc.edate), Cover.PPeriod)
					Else
						dbo.fn_calc_prorata(acceptance.pDate, dateadd(day,1,RCalc.edate), RCalc.Sdate, dateadd(day,1,RCalc.edate), Cover.PPeriod)
					End
				END				
			else
				CASE WHEN RCOVER.CPFORMULA = 'PRORATE SQ' and Acceptance.AType='C' and Acceptance.EMethod<>'A' THEN
					POWER(dbo.fn_calc_prorata(dbo.fn_Get_Effective_Cancellation_By_Payor_Schedule(Acceptance.ANO, Acceptance.PDate,RCalc.Edate), RCalc.Edate, RCalc.Sdate, RCalc.EDate, Cover.PPeriod),2)
				ELSE
					Case When Acceptance.AType='C' and Acceptance.EMethod<>'A' THEN
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
* (Case When Acceptance.CPCT=0 and Acceptance.AType='C' and Acceptance.EMethod<>'A' and RCover.CPRefund<>0 and not (DateDiff(day, acceptance.pdate, rcalc.SDate)>0 and acceptance.pdate between pacceptance.sdate and pacceptance.edate) Then RCover.CPRefund/100 else 1 end)

From acceptance        
inner Join Cover on (Cover.CNO=Acceptance.CNO)        
inner join Acceptance pAcceptance on (pAcceptance.ANO=Acceptance.pANO)        
inner join PCalc on (PCalc.ANO=pAcceptance.ANO)        
inner join RCalc on (RCalc.ANO=PCalc.ANO and RCalc.Currency=PCalc.Currency)        
Left Join RCover on (RCover.ANO=Acceptance.ANO and RCover.Code=RCalc.Code and ((RCover.SDate=Acceptance.SDate and RCover.EDate=Acceptance.EDate and RCalc.SDate=pAcceptance.SDate and RCalc.EDate=pAcceptance.EDate) or (RCover.SDate=RCalc.SDate)))
Where Acceptance.AType<>'A' and Not (Acceptance.AType='C' and Acceptance.EMethod='A') and pAcceptance.AType not in ('A','C')        
and Not (Acceptance.Atype<>'N' and (coalesce(RCover.NoRefundF,0)=1 or Acceptance.NoRefundF in (2,4) or (Acceptance.NoRefundF in (1) and DateDiff(day, acceptance.pdate, RCalc.SDate) <= 0)))
and Not (DateDiff(day, rcalc.Edate, acceptance.pdate)>=0 and acceptance.pdate between pacceptance.sdate and pacceptance.edate)
and Acceptance.ANO=@P_ANO        
)        
       

GO

DROP FUNCTION PREMIUM_CALCULATION_CONSTANT
GO
CREATE FUNCTION PREMIUM_CALCULATION_CONSTANT(@P_ANO int) 
RETURNS TABLE  AS 
RETURN ( 
Select ANO, Currency, sum(Premium) as Premium 
 
from( 
Select ANO, Currency, sum(Premium) as Premium 
 
from ( 
select Acceptance.ANO,RCalc.Currency, 
-case 
when DateDiff(day, rcalc.Edate, acceptance.pdate)>=0 and acceptance.pdate between pacceptance.sdate and pacceptance.edate then 0 
when DateDiff(day, acceptance.pdate, rcalc.SDate)>0 and acceptance.pdate between pacceptance.sdate and pacceptance.edate then 1 
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
					Case When Acceptance.AType='C' and Acceptance.EMethod<>'A' THEN
						dbo.fn_calc_prorata(dbo.fn_Get_Effective_Cancellation_By_Payor_Schedule(Acceptance.ANO, Acceptance.PDate,dateadd(day,1,RCalc.edate)), dateadd(day,1,RCalc.edate), RCalc.Sdate, dateadd(day,1,RCalc.edate), Cover.PPeriod)
					else
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
* (Case When PCalc.Description='Minimum Premium' Then RCalc.Gross else (Case When PCalc.Gross=0 then 0 else Case When PCalc.OGross=0 Then PCalc.Gross else RCalc.OGross*(case When Pcalc.TSI=0 then 1 else PCalc.Ourshare/PCalc.TSI end) *PCalc.Gross/PCalc.OGross end end) end+RCalc.Reinstatement)* (Case When Acceptance.CPCT=0 and Acceptance.AType='C' and Acceptance.EMethod<>'A' and RCover.CPRefund<>0 and not (DateDiff(day, acceptance.pdate, rcalc.SDate)>0 and acceptance.pdate between pacceptance.sdate and pacceptance.edate) Then RCover.CPRefund/100 else 1 end) as Premium      

from Acceptance inner join Acceptance pAcceptance on (pAcceptance.ANO=Acceptance.pANO) inner Join Cover on (Cover.CNO=Acceptance.CNO) 
inner join PCalc on (PCalc.ANO=pAcceptance.ANO) inner join RCalc on (RCalc.ANO=PCalc.ANO and RCalc.Currency=PCalc.Currency) 
Left Join RCover on (RCover.ANO=Acceptance.ANO and RCover.Code=RCalc.Code and ((RCover.SDate=Acceptance.SDate and RCover.EDate=Acceptance.EDate and RCalc.SDate=pAcceptance.SDate and RCalc.EDate=pAcceptance.EDate) or (RCover.SDate=RCalc.SDate)))
Where Acceptance.ANO=@P_ANO and Acceptance.AType<>'A' and Not (Acceptance.AType='C' and Acceptance.EMethod='A') and pAcceptance.AType not in ('A','C') 
and Not (Acceptance.Atype<>'N' and (coalesce(RCover.NoRefundF,0)=1 or Acceptance.NoRefundF in (2,4) or (Acceptance.NoRefundF in (1) and DateDiff(day, acceptance.pdate, RCalc.SDate) <= 0)))
and Not (DateDiff(day, rcalc.Edate, acceptance.pdate)>=0 and acceptance.pdate between pacceptance.sdate and pacceptance.edate)
and RCalc.Gross<>0 
) T 
 
Group By ANO, Currency 
 
Union All 
 
select A1.ANO, AccAss.Currency_OC as Currency, 
sum(Case When AccAss.Code='P' then (Case When A1.AType='A' and AccAss.AdjMethod='OVERLIMIT' then -AccAss.CAmount*(Case When A1.CPCT<>0 Then A1.CPCT/100 else 1 end)/(Case When AccAss.PProrata<>0 Then AccAss.PProrata else 1 end) else -AccAss.Amount_OC end)*(Case When AccAss.Type='DI' then 100/(100-coalesce(Coinsurance.MShare,0)) else 1 end) else 0 end) as Premium 
from Acceptance A1 
inner join Acceptance A2 on (A2.OANO=A1.OANO) 
inner join AccAss on (AccAss.ANO=A2.ANO) 
inner join Profile on (Profile.ID=AccAss.ID) 
inner join MParam on (MParam.Type=Accass.Type) 
Left Join (Select CNO, sum(Share) as MShare from Coinsurance Where PCollectionF=0 Group by CNO) Coinsurance on (Coinsurance.CNO=A2.CNO) 
Left join Acceptance pA2 on (pA2.ANO=A2.PANO) 
Where A1.ANO=@P_ANO 
and ( 
(A2.ANO<=A1.PANO AND A2.ANO<@P_ANO AND A1.PDate<=A2.PDate and A1.PPDate>=A2.PPDate and A1.AType='A' and AccAss.AdjustableF=1 and (AccAss.AdjMethod<>'OVERLIMIT' or AccAss.CAmount<>0) and NOT EXISTS (Select PANO from Acceptance A3 Where A3.PANO=A2.ANO and A3.AStatus<>'C' and A3.AType='A' and A3.ANO<>@P_ANO)) 
or (A2.ANO<@P_ANO AND A1.AType='C' and A1.EMethod='A' and A2.PDate>=A1.PDate and (coalesce(pA2.pDate,A2.PDate)>=A1.PDate or A2.ATYPE='A' or (coalesce(pA2.pDate,A2.PDate)<A1.PDate and AccAss.CAmount<>0))) 
or (A2.ANO=A1.PANO and A2.AType='A' and A1.AType='C')) 
and ((AccAss.Type in ('DI','IC','IR') and AccAss.Code='P') Or (AccAss.Type in ('BB','BA','BO') and AccAss.Code='C') or (AccAss.Type in ('DI','IC','IR') and AccAss.Code='O') or (A1.AType='C' and A1.EMethod='A' and AccAss.Type in ('DI') and AccAss.Code in ('F','D'))) 
Group By A1.ANO, AccAss.Currency_OC 
) T 
 
Group By ANO, Currency 
) 
 
GO

DROP FUNCTION PREMIUM_CALCULATION_BASE
GO
CREATE FUNCTION PREMIUM_CALCULATION_BASE(@P_ANO int)                  

RETURNS @PCALC TABLE (ANO Int, Currency varchar(10), CANO int, Code varchar(10), SDate SmallDatetime, EDate SmallDatetime, PolicyYear Int, NoRefundF Int, MinimumPremiumF Bit, Premium Float)
AS
BEGIN

DECLARE @ACCEPTANCE TABLE (ANO Int, CNO Int, SDate SmallDateTime, EDate SmallDateTime, STime Varchar(5), ETime varchar(5), NOREFUNDF Int, EXCLUSIVEF Bit, AType varchar(10), PDate SmallDateTime, CPCT Float, QTY Int, PANO Int, EMethod varchar(1))
INSERT INTO @ACCEPTANCE
SELECT ANO, CNO, SDATE, EDate, STime, ETime, NOREFUNDF, EXCLUSIVEF, ATYPE, PDATE, CPCT, QTY, PANO, EMETHOD 
FROM ACCEPTANCE WHERE ANO=@P_ANO

INSERT INTO @PCALC
Select ANO, Currency, CANO, Code, SDate, EDate, PolicyYear, NoRefundF, Cast(Max(MinimumPremiumF) as Bit) as MinimumPremiumF, sum(Premium) as Premium
 from (                  
  select Acceptance.ANO, RCalc.Currency, @P_ANO as CANO, RCalc.Code,  RCalc.SDate, RCalc.Edate, cast(datediff(Month,Acceptance.SDate, RCalc.SDate) as integer) / 12 + 1  as PolicyYear,          
  Acceptance.NoRefundF,   
  Case When Upper(PCALC.DESCRIPTION) in ('MINIMUM PREMIUM','POLICY MINIMUM PREMIUM') Then 1 else 0 end as MinimumPremiumF,                                       
  case                  
  When Acceptance.Atype<>'N' and (RCover.NoRefundF=1 or Acceptance.NoRefundF in (2,4) or (Acceptance.NoRefundF in (1) and DateDiff(day, acceptance.pdate, RCalc.SDate) <= 0)) Then 0
  When Acceptance.AType<>'N' then                  
   case                  
   when DateDiff(day, rcalc.Edate, acceptance.pdate)>=0 then 0                  
   when DateDiff(day, acceptance.pdate, rcalc.SDate)>0 then 1                  
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
  * (Case When PCALC.DESCRIPTION='Minimum Premium' Then RCALC.GROSS else (Case When PCALC.OGROSS<>0 THEN RCALC.OGROSS*PCALC.GROSS/PCALC.OGROSS ELSE PCALC.GROSS END) END+RCalc.Reinstatement)*(case When Pcalc.TSI=0 then 1 else PCalc.Ourshare/PCalc.TSI end) as Premium
  From @Acceptance acceptance
  Inner Join cover on (Cover.CNO=Acceptance.CNO)
  Inner Join RCalc on (RCalc.ANO=Acceptance.ANO)
  Inner Join RCover on (RCOVER.ANO=RCALC.ANO AND RCOVER.CODE=RCALC.CODE AND RCOVER.SDATE=RCALC.SDATE)
  Inner Join PCalc on (PCalc.ANO=RCalc.ANO and PCalc.Currency=RCalc.Currency)
  Where Acceptance.ANO=@P_ANO 
  and Acceptance.AType not in ('A','C')                  
  and PCalc.Gross<>0          
                                                    
  Union All                  
                                                                                             
  select Acceptance.ANO, RCalc.Currency, Acceptance.PANO as CANO, RCalc.Code, RCalc.SDate, RCalc.Edate, cast(datediff(Month,pAcceptance.SDate, RCalc.SDate) as integer) / 12 + 1 as PolicyYear,          
  Acceptance.NoRefundF,   
  Case When Upper(PCALC.DESCRIPTION) in ('MINIMUM PREMIUM','POLICY MINIMUM PREMIUM') Then 1 else 0 end as MinimumPremiumF,                                       
  -case     
  When Acceptance.Atype<>'N' and (coalesce(RCover.NoRefundF,0)=1 or Acceptance.NoRefundF in (2,4) or (Acceptance.NoRefundF in (1) and DateDiff(day, acceptance.pdate, RCalc.SDate) <= 0)) Then 0
  when DateDiff(day, rcalc.Edate, acceptance.pdate)>=0 and acceptance.pdate between pacceptance.sdate and pacceptance.edate then 0                  
  when DateDiff(day, acceptance.pdate, rcalc.SDate)>0 and acceptance.pdate between pacceptance.sdate and pacceptance.edate then 1                  
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
  * (Case When PCALC.DESCRIPTION='Minimum Premium' Then RCALC.GROSS else (Case When PCALC.OGROSS<>0 THEN RCALC.OGROSS*PCALC.GROSS/PCALC.OGROSS ELSE PCALC.GROSS END) END+RCalc.Reinstatement)*(case When Pcalc.TSI=0 then 1 else PCalc.Ourshare/PCalc.TSI end)
  * (Case When Acceptance.CPCT=0 and Acceptance.AType='C' and Acceptance.EMethod<>'A' and RCover.CPRefund<>0 and Not (DateDiff(day, acceptance.pdate, rcalc.SDate)>0 and acceptance.pdate between pacceptance.sdate and pacceptance.edate) Then RCover.CPRefund/100 else 1 end) as Premium      
  from @Acceptance Acceptance 
  inner join Acceptance pAcceptance on (pAcceptance.ANO=Acceptance.pANO) 
  inner Join Cover on (Cover.CNO=Acceptance.CNO)                  
  inner join PCalc on (PCalc.ANO=pAcceptance.ANO) 
  inner join RCalc on (RCalc.ANO=PCalc.ANO and RCalc.Currency=PCalc.Currency)                  
  Left Join RCover on (RCover.ANO=Acceptance.ANO and RCover.Code=RCalc.Code and ((RCover.SDate=Acceptance.SDate and RCover.EDate=Acceptance.EDate and RCalc.SDate=pAcceptance.SDate and RCalc.EDate=pAcceptance.EDate) or (RCover.SDate=RCalc.SDate)))
  Where Acceptance.ANO=@P_ANO and Acceptance.AType<>'A' and Not (Acceptance.AType='C' and Acceptance.EMethod='A') and pAcceptance.AType not in ('A','C')                  
  and PCalc.Gross<>0                    
                                                    
  Union All                  
        
  select Acceptance.ANO, RCalc.Currency, @P_ANO as CANO, RCalc.Code, RCalc.SDate, RCalc.Edate, cast(datediff(Month,Acceptance.SDate, RCalc.SDate) as integer) / 12 + 1 as PolicyYear,      
  Acceptance.NoRefundF,       
  Case When Upper(PCALC.DESCRIPTION) in ('MINIMUM PREMIUM','POLICY MINIMUM PREMIUM') Then 1 else 0 end as MinimumPremiumF,                                       
  (Case When PCALC.DESCRIPTION='Minimum Premium' Then RCALC.GROSS else (Case When PCALC.OGROSS<>0 THEN RCALC.OGROSS*PCALC.GROSS/PCALC.OGROSS ELSE PCALC.GROSS END) END+RCalc.Reinstatement)*coalesce(sISource.Share/100,(case When Pcalc.TSI=0 then 1 else PCalc.Ourshare/PCalc.TSI end)) as Premium      
  From @Acceptance acceptance
  Inner Join RCALC on (RCalc.ANO=Acceptance.ANO)
  Inner Join PCalc on (PCalc.ANO=RCalc.ANO and PCalc.Currency=RCalc.Currency)
  Left Join Acceptance sAcceptance on (sAcceptance.ANO=RCalc.SANO) 
  Left Join ISource sISource on (sISource.CNO=sAcceptance.CNO)
  Where Acceptance.ANO=@P_ANO 
  and Acceptance.AType='A'                  
  and PCalc.Gross<>0   
        
) T                  
                                      
Group By ANO, Currency, CANO, Code, SDate, EDate, PolicyYear, NoRefundF  

RETURN

END

GO

DROP FUNCTION DISPLAY_FACULTATIVE_BALANCE_PRORATA_CALCULATION
GO
CREATE FUNCTION DISPLAY_FACULTATIVE_BALANCE_PRORATA_CALCULATION(@P_ANO int, @P_FID Varchar(20))          
-- From Display_Prorata Calculation   
-- RCalc.Sdate Replaced with (Case When Datediff(day, RArrDet.SDate, RCalc.SDate)>=0 Then RCalc.SDate else RArrDet.SDate end) 
-- RCalc.Edate Replaced with (Case When Datediff(day, RCalc.EDate, RArrDet.EDate)>=0 Then RCalc.EDate else RArrDet.EDate end) 
-- Acceptance.AType Replaced with RArrDet.AType  
RETURNS TABLE  AS          
RETURN (          
select          
Distinct          
RCalc.ANO,          
RCalc.Code,          
RCalc.Currency,          
RCalc.Sdate,
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
   case when acceptance.cpct<>0 and acceptance.cpct<>100 then convert(varchar(25),Cast(Acceptance.CPCT as float),0)+'%' else '' end        
  Else        
	--Prorata Calculation
	Case When Acceptance.EXCLUSIVEF=0 and Acceptance.STime<Acceptance.ETime and (Case When Datediff(day, RCalc.EDate, RArrDet.EDate)>=0 Then RCalc.EDate else RArrDet.EDate end)=Acceptance.EDate Then
		dbo.fn_calc_sprorata(acceptance.pDate, dateadd(day,1,(Case When Datediff(day, RCalc.EDate, RArrDet.EDate)>=0 Then RCalc.EDate else RArrDet.EDate end)), (Case When Datediff(day, RArrDet.SDate, RCalc.SDate)>=0 Then RCalc.SDate else RArrDet.SDate end), dateadd(day,1,(Case When Datediff(day, RCalc.EDate, RArrDet.EDate)>=0 Then RCalc.EDate else RArrDet.EDate end)), Cover.PPeriod)
	else
		dbo.fn_calc_sprorata(acceptance.pDate, (Case When Datediff(day, RCalc.EDate, RArrDet.EDate)>=0 Then RCalc.EDate else RArrDet.EDate end), (Case When Datediff(day, RArrDet.SDate, RCalc.SDate)>=0 Then RCalc.SDate else RArrDet.SDate end), (Case When Datediff(day, RCalc.EDate, RArrDet.EDate)>=0 Then RCalc.EDate else RArrDet.EDate end), Cover.PPeriod)
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
	--Prorata Calculation
	Case When Acceptance.EXCLUSIVEF=0 and Acceptance.STime<Acceptance.ETime and (Case When Datediff(day, RCalc.EDate, RArrDet.EDate)>=0 Then RCalc.EDate else RArrDet.EDate end)=Acceptance.EDate Then
		dbo.fn_calc_prorata(acceptance.pDate, dateadd(day,1,(Case When Datediff(day, RCalc.EDate, RArrDet.EDate)>=0 Then RCalc.EDate else RArrDet.EDate end)), (Case When Datediff(day, RArrDet.SDate, RCalc.SDate)>=0 Then RCalc.SDate else RArrDet.SDate end), dateadd(day,1,(Case When Datediff(day, RCalc.EDate, RArrDet.EDate)>=0 Then RCalc.EDate else RArrDet.EDate end)), Cover.PPeriod)
	else
		dbo.fn_calc_prorata(acceptance.pDate, (Case When Datediff(day, RCalc.EDate, RArrDet.EDate)>=0 Then RCalc.EDate else RArrDet.EDate end), (Case When Datediff(day, RArrDet.SDate, RCalc.SDate)>=0 Then RCalc.SDate else RArrDet.SDate end), (Case When Datediff(day, RCalc.EDate, RArrDet.EDate)>=0 Then RCalc.EDate else RArrDet.EDate end), Cover.PPeriod)
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
and not (RArrDet.AType<>'N' and (RCover.NoRefundF=1 or RArrDet.NoRefundF=1 or Acceptance.NoRefundF in (2) or (Acceptance.NoRefundF in (1) and DateDiff(day, acceptance.pdate, (Case When Datediff(day, RArrDet.SDate, RCalc.SDate)>=0 Then RCalc.SDate else RArrDet.SDate end)) <= 0)))
and Acceptance.ANO=@P_ANO        
            
Union All          
            
select          
Distinct          
RCalc.ANO,          
RCalc.Code,          
RCalc.Currency,          
RCalc.Sdate,
RCalc.EDate,
Prorata_Calculation=        
case        
when DateDiff(day, (Case When Datediff(day, RCalc.EDate, RArrDet.EDate)>=0 Then RCalc.EDate else RArrDet.EDate end), acceptance.pdate)>=0 and acceptance.pdate between pacceptance.sdate and pacceptance.edate then ''        
when DateDiff(day, acceptance.pdate, (Case When Datediff(day, RArrDet.SDate, RCalc.SDate)>=0 Then RCalc.SDate else RArrDet.SDate end))>0 and acceptance.pdate between pacceptance.sdate and pacceptance.edate then ''        

Else        
  case        
  when acceptance.cpct<>0 or Cover.Voyage=1 then        
    case when acceptance.cpct<>0 and acceptance.cpct<>100 then convert(varchar(25),Cast(Acceptance.CPCT as float),0)+'%' else '' end        
  Else        
    case        
		When Acceptance.SDate<>Acceptance.PDate or Acceptance.NoRefundF=6 then        
			--Prorata Calculation
			Case When pAcceptance.EXCLUSIVEF=0 and pAcceptance.STime<pAcceptance.ETime and (Case When Datediff(day, RCalc.EDate, RArrDet.EDate)>=0 Then RCalc.EDate else RArrDet.EDate end)=pAcceptance.EDate Then
				CASE WHEN RCOVER.CPFORMULA = 'PRORATE SQ' and RArrDet.AType='C' and Acceptance.EMethod<>'A' THEN
					'('+dbo.fn_Calc_SProrata(dbo.fn_Get_Effective_Cancellation_By_Payor_Schedule(Acceptance.ANO, Acceptance.PDate,dateadd(day,1,(Case When Datediff(day, RCalc.EDate, RArrDet.EDate)>=0 Then RCalc.EDate else RArrDet.EDate end))), dateadd(day,1,(Case When Datediff(day, RCalc.EDate, RArrDet.EDate)>=0 Then RCalc.EDate else RArrDet.EDate end)), (Case When Datediff(day, RArrDet.SDate, RCalc.SDate)>=0 Then RCalc.SDate else RArrDet.SDate end), dateadd(day,1,(Case When Datediff(day, RCalc.EDate, RArrDet.EDate)>=0 Then RCalc.EDate else RArrDet.EDate end)), Cover.PPeriod)+') ^ 2'
				ELSE
					CASE WHEN RArrDet.AType='C' and Acceptance.EMethod<>'A' THEN
						dbo.fn_Calc_SProrata(dbo.fn_Get_Effective_Cancellation_By_Payor_Schedule(Acceptance.ANO, Acceptance.PDate,dateadd(day,1,(Case When Datediff(day, RCalc.EDate, RArrDet.EDate)>=0 Then RCalc.EDate else RArrDet.EDate end))), dateadd(day,1,(Case When Datediff(day, RCalc.EDate, RArrDet.EDate)>=0 Then RCalc.EDate else RArrDet.EDate end)), (Case When Datediff(day, RArrDet.SDate, RCalc.SDate)>=0 Then RCalc.SDate else RArrDet.SDate end), dateadd(day,1,(Case When Datediff(day, RCalc.EDate, RArrDet.EDate)>=0 Then RCalc.EDate else RArrDet.EDate end)), Cover.PPeriod)
					Else
						dbo.fn_Calc_SProrata(acceptance.pDate, dateadd(day,1,(Case When Datediff(day, RCalc.EDate, RArrDet.EDate)>=0 Then RCalc.EDate else RArrDet.EDate end)), (Case When Datediff(day, RArrDet.SDate, RCalc.SDate)>=0 Then RCalc.SDate else RArrDet.SDate end), dateadd(day,1,(Case When Datediff(day, RCalc.EDate, RArrDet.EDate)>=0 Then RCalc.EDate else RArrDet.EDate end)), Cover.PPeriod)
					End
				END				
			else
				CASE WHEN RCOVER.CPFORMULA = 'PRORATE SQ' and RArrDet.AType='C' and Acceptance.EMethod<>'A' THEN
					'('+dbo.fn_Calc_SProrata(dbo.fn_Get_Effective_Cancellation_By_Payor_Schedule(Acceptance.ANO, Acceptance.PDate,(Case When Datediff(day, RCalc.EDate, RArrDet.EDate)>=0 Then RCalc.EDate else RArrDet.EDate end)), (Case When Datediff(day, RCalc.EDate, RArrDet.EDate)>=0 Then RCalc.EDate else RArrDet.EDate end), (Case When Datediff(day, RArrDet.SDate, RCalc.SDate)>=0 Then RCalc.SDate else RArrDet.SDate end), (Case When Datediff(day, RCalc.EDate, RArrDet.EDate)>=0 Then RCalc.EDate else RArrDet.EDate end), Cover.PPeriod)+') ^ 2'
				ELSE
					CASE WHEN RArrDet.AType='C' and Acceptance.EMethod<>'A' THEN
						dbo.fn_Calc_SProrata(dbo.fn_Get_Effective_Cancellation_By_Payor_Schedule(Acceptance.ANO, Acceptance.PDate,(Case When Datediff(day, RCalc.EDate, RArrDet.EDate)>=0 Then RCalc.EDate else RArrDet.EDate end)), (Case When Datediff(day, RCalc.EDate, RArrDet.EDate)>=0 Then RCalc.EDate else RArrDet.EDate end), (Case When Datediff(day, RArrDet.SDate, RCalc.SDate)>=0 Then RCalc.SDate else RArrDet.SDate end), (Case When Datediff(day, RCalc.EDate, RArrDet.EDate)>=0 Then RCalc.EDate else RArrDet.EDate end), Cover.PPeriod)
					Else
						dbo.fn_Calc_SProrata(acceptance.pDate, (Case When Datediff(day, RCalc.EDate, RArrDet.EDate)>=0 Then RCalc.EDate else RArrDet.EDate end), (Case When Datediff(day, RArrDet.SDate, RCalc.SDate)>=0 Then RCalc.SDate else RArrDet.SDate end), (Case When Datediff(day, RCalc.EDate, RArrDet.EDate)>=0 Then RCalc.EDate else RArrDet.EDate end), Cover.PPeriod)
					End
				END				
			End

		Else        
		 -- Endorsement Period        
			''        
		End       
	End        
End        
+ (Case When Acceptance.CPCT=0 and Acceptance.AType='C' and Acceptance.EMethod<>'A' and NRarrDet.CPRefund<>0 Then ' x '+convert(varchar(25),NRArrDet.CPRefund,0)+'%' else '' end)

,        
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
			--Prorata Calculation
			Case When pAcceptance.EXCLUSIVEF=0 and pAcceptance.STime<pAcceptance.ETime and (Case When Datediff(day, RCalc.EDate, RArrDet.EDate)>=0 Then RCalc.EDate else RArrDet.EDate end)=pAcceptance.EDate Then
				CASE WHEN RCOVER.CPFORMULA = 'PRORATE SQ' and RArrDet.AType='C' and Acceptance.EMethod<>'A' THEN
					POWER(dbo.fn_calc_prorata(dbo.fn_Get_Effective_Cancellation_By_Payor_Schedule(Acceptance.ANO, Acceptance.PDate,dateadd(day,1,(Case When Datediff(day, RCalc.EDate, RArrDet.EDate)>=0 Then RCalc.EDate else RArrDet.EDate end))), dateadd(day,1,(Case When Datediff(day, RCalc.EDate, RArrDet.EDate)>=0 Then RCalc.EDate else RArrDet.EDate end)), (Case When Datediff(day, RArrDet.SDate, RCalc.SDate)>=0 Then RCalc.SDate else RArrDet.SDate end), dateadd(day,1,(Case When Datediff(day, RCalc.EDate, RArrDet.EDate)>=0 Then RCalc.EDate else RArrDet.EDate end)), Cover.PPeriod),2)
				ELSE
					CASE WHEN RArrDet.AType='C' and Acceptance.EMethod<>'A' THEN
						dbo.fn_calc_prorata(dbo.fn_Get_Effective_Cancellation_By_Payor_Schedule(Acceptance.ANO, Acceptance.PDate,dateadd(day,1,(Case When Datediff(day, RCalc.EDate, RArrDet.EDate)>=0 Then RCalc.EDate else RArrDet.EDate end))), dateadd(day,1,(Case When Datediff(day, RCalc.EDate, RArrDet.EDate)>=0 Then RCalc.EDate else RArrDet.EDate end)), (Case When Datediff(day, RArrDet.SDate, RCalc.SDate)>=0 Then RCalc.SDate else RArrDet.SDate end), dateadd(day,1,(Case When Datediff(day, RCalc.EDate, RArrDet.EDate)>=0 Then RCalc.EDate else RArrDet.EDate end)), Cover.PPeriod)
					Else
						dbo.fn_calc_prorata(acceptance.pDate, dateadd(day,1,(Case When Datediff(day, RCalc.EDate, RArrDet.EDate)>=0 Then RCalc.EDate else RArrDet.EDate end)), (Case When Datediff(day, RArrDet.SDate, RCalc.SDate)>=0 Then RCalc.SDate else RArrDet.SDate end), dateadd(day,1,(Case When Datediff(day, RCalc.EDate, RArrDet.EDate)>=0 Then RCalc.EDate else RArrDet.EDate end)), Cover.PPeriod)
					End
				END				
			else
				CASE WHEN RCOVER.CPFORMULA = 'PRORATE SQ' and RArrDet.AType='C' and Acceptance.EMethod<>'A' THEN
					POWER(dbo.fn_calc_prorata(dbo.fn_Get_Effective_Cancellation_By_Payor_Schedule(Acceptance.ANO, Acceptance.PDate,(Case When Datediff(day, RCalc.EDate, RArrDet.EDate)>=0 Then RCalc.EDate else RArrDet.EDate end)), (Case When Datediff(day, RCalc.EDate, RArrDet.EDate)>=0 Then RCalc.EDate else RArrDet.EDate end), (Case When Datediff(day, RArrDet.SDate, RCalc.SDate)>=0 Then RCalc.SDate else RArrDet.SDate end), (Case When Datediff(day, RCalc.EDate, RArrDet.EDate)>=0 Then RCalc.EDate else RArrDet.EDate end), Cover.PPeriod),2)
				ELSE
					CASE WHEN RArrDet.AType='C' and Acceptance.EMethod<>'A' THEN
						dbo.fn_calc_prorata(dbo.fn_Get_Effective_Cancellation_By_Payor_Schedule(Acceptance.ANO, Acceptance.PDate,(Case When Datediff(day, RCalc.EDate, RArrDet.EDate)>=0 Then RCalc.EDate else RArrDet.EDate end)), (Case When Datediff(day, RCalc.EDate, RArrDet.EDate)>=0 Then RCalc.EDate else RArrDet.EDate end), (Case When Datediff(day, RArrDet.SDate, RCalc.SDate)>=0 Then RCalc.SDate else RArrDet.SDate end), (Case When Datediff(day, RCalc.EDate, RArrDet.EDate)>=0 Then RCalc.EDate else RArrDet.EDate end), Cover.PPeriod)
					Else
						dbo.fn_calc_prorata(acceptance.pDate, (Case When Datediff(day, RCalc.EDate, RArrDet.EDate)>=0 Then RCalc.EDate else RArrDet.EDate end), (Case When Datediff(day, RArrDet.SDate, RCalc.SDate)>=0 Then RCalc.SDate else RArrDet.SDate end), (Case When Datediff(day, RCalc.EDate, RArrDet.EDate)>=0 Then RCalc.EDate else RArrDet.EDate end), Cover.PPeriod)
					End
				END				
			End
		Else        
		 -- Endorsement Period        
			1        
		End        
	End        
End        
* (Case When Acceptance.CPCT=0 and Acceptance.AType='C' and Acceptance.EMethod<>'A' and NRarrDet.CPRefund<>0 Then NRarrDet.CPRefund/100 else 1 end)
	             
From acceptance          
inner Join Cover on (Cover.CNO=Acceptance.CNO)          
inner join Acceptance pAcceptance on (pAcceptance.ANO=Acceptance.pANO)          
inner join PCalc on (PCalc.ANO=pAcceptance.ANO)          
inner join RCalc on (RCalc.ANO=PCalc.ANO and RCalc.Currency=PCalc.Currency)     
inner join RArrDet NRArrDet on (NRArrDet.ANO=Acceptance.ANO and NRArrDet.FID=@P_FID)         
inner join RArrDet on (RArrDet.ANO=pAcceptance.ANO and RArrDet.FID=@P_FID)         
Left Join RCover on (RCover.ANO=Acceptance.ANO and RCover.Code=Rcalc.Code and ((RCover.SDate=Acceptance.SDate and RCover.EDate=Acceptance.EDate and RCalc.SDate=pAcceptance.SDate and RCalc.EDate=pAcceptance.EDate) or (RCover.SDate=RCalc.SDate)))
Where NRArrDet.AType<>'A' and Not (NRArrDet.AType='C' and Acceptance.EMethod='A') and RArrDet.AType not in ('A','C')        
and Not (NRArrDet.AType<>'N' and (coalesce(RCover.NoRefundF,0)=1 or NRArrDet.NoRefundF=1 or Acceptance.NoRefundF in (2) or (Acceptance.NoRefundF in (1) and DateDiff(day, acceptance.pdate, (Case When Datediff(day, RArrDet.SDate, RCalc.SDate)>=0 Then RCalc.
SDate else RArrDet.SDate end)) <= 0)))
and Not (DateDiff(day, (Case When Datediff(day, RCalc.EDate, RArrDet.EDate)>=0 Then RCalc.EDate else RArrDet.EDate end), acceptance.pdate)>=0 and acceptance.pdate between pacceptance.sdate and pacceptance.edate)
and Acceptance.ANO=@P_ANO        
)

GO

--14 MAR 2021 : PENAMBAHAN LAST ANO, LAST OPR DAN LAST UPDATE

IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'LastANO' AND Object_ID = Object_ID(N'AINFODET'))
BEGIN
ALTER TABLE AINFODET ADD
	LastANO int NULL
END
GO

IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'Last_Opr' AND Object_ID = Object_ID(N'AINFODET'))
BEGIN
ALTER TABLE AINFODET ADD
	Last_Opr varchar(50) NULL
END
GO

IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'Last_Update' AND Object_ID = Object_ID(N'AINFODET'))
BEGIN
ALTER TABLE AINFODET ADD
	Last_Update smalldatetime
END
GO

IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'SeqNo' AND Object_ID = Object_ID(N'AINFODET'))
BEGIN
ALTER TABLE AINFODET ADD
	SeqNo int NULL
DECLARE @v sql_variant 
SET @v = N'Sequence No (Revision No)'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'AINFODET', N'COLUMN', N'SeqNo'
END
GO

--14 APR 2021 : Penambahan Pasal 4
IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'PASAL4' AND Object_ID = Object_ID(N'MParam'))
BEGIN
ALTER TABLE MParam ADD
	PASAL4 float(53) NULL
DECLARE @v sql_variant 
SET @v = N'TAX (Pasal 4) in %'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'MParam', N'COLUMN', N'PASAL4'
END
GO


DROP PROCEDURE View07 
GO
CREATE PROCEDURE View07 (@p_ANo as integer)                
AS                
SELECT AccAss.ID, Profile.Name, AccAss.Type, AccAss.Posted, AccAss.Admno, AccAss.Currency, Acceptance.RegNo, Accass.DocNo, AccAss.RefNo,      
Case When AccAss.CAmount=0 and Coalesce(pAcceptance.Branch,'')<>'' Then pAcceptance.Branch Else Acceptance.Branch end Branch,   
dbo.fn_Get_UWYear(Acceptance.SDate, Acceptance.EDate, Case When (Case When isnull(APayor.ANO,0)=0 Then (Case When isnull(MPayor.ANO,0)=0 Then Payor.PolicyYearF else MPayor.PolicyYearF end) else APayor.PolicyYearF end)=1 Then AccAss.SDate else Acceptance.SDate end) as PolicyYear,
sum(                
 case                
  when (accass.type in ('IR','IT','IX') and accass.code in ('P','U','F')) or (accass.type in ('DI','IC') and accass.code in ('P','U')) or (AccAss.Type not in ('DI','IC','IR','IT','IX') and AccAss.Code='P') then AccAss.Amount
  else 0                
 end                
) 
+
sum(
 Case 
  When Acceptance.NoRefundF=7 and AccAss.Type in ('BB','BA','BO','BC') and AccAss.Code in ('C') then AccAss.Amount 
  else 0 
 end
)
AS Premium,                 
sum(                
 case                 
  when accass.code='C' and coalesce(accass.codeext,'')='' then AccAss.Amount                
  else 0                
 end                
) 
-
sum(
 Case 
  When Acceptance.NoRefundF=7 and AccAss.Type in ('BB','BA','BO','BC') and AccAss.Code in ('C') then AccAss.Amount 
  else 0 
 end
)
AS Commision,                 
sum(                
 case                 
  when accass.code='C' and coalesce(accass.codeext,'')='1' then AccAss.Amount                
  else 0                
 end                
) AS OverridingCommission,                 
sum(                
 case                 
  when accass.Type not in ('IR','IT','IX') and accass.code='F' then AccAss.Amount                
  else 0                
 end                
) AS Fee,                 
sum(                
 case                 
  when accass.code='D' then AccAss.Amount                
  else 0                
 end                
) AS Duty,                 
sum(                
 case                 
  when accass.type not in ('CP','DC','XP','QS','QP','S1','S2','S3','AF','FO') and accass.code='O' then AccAss.Amount                
  else 0                
 end                
) AS Discount,                 
sum(                
 case                 
  when accass.type in ('CP','DC','XP','QS','QP','S1','S2','S3','AF','FO') and accass.code='O' and coalesce(accass.CodeExt,'')='' then AccAss.Amount                
  else 0                
 end                
) AS Acquisition,   
sum(                
 case                 
  when accass.type in ('CP','DC','XP','QS','QP','S1','S2','S3','AF','FO') and accass.code='O' and coalesce(accass.CodeExt,'')='1' then AccAss.Amount                
  else 0                
 end                
) AS PremiumAdjustment,                               
sum(                
 case                
  when accass.code='I' then AccAss.Amount                
  else 0                
 end                
) AS OtherIncome,               
sum(                
 case                
  when accass.type in ('IR','IT','IX') and accass.code='F' then -AccAss.Amount
  when accass.Type in ('DI','IC') and accass.code='U' then -AccAss.Amount        
  when accass.Type Not in ('DI','IC') and accass.code='U' then AccAss.Amount        
  else 0                
 End                
) AS Ujroh,              
sum(                
 case                
  when (accass.type in ('IR','IT','IX') and accass.code in ('P','U'))  or (accass.type in ('DI','IC') and accass.code in ('P')) or (AccAss.Type not in ('DI','IC','IR','IT','IX') and AccAss.Code in ('P','U')) then AccAss.Amount                
  else 0                
 end                
) AS Tabarru,         
sum(                
 case                
  when accass.type not in ('CP','DC','XP','QS','QP','S1','S2','S3','AF','FO') and accass.code='J' then AccAss.Amount                
  else 0                
 end                
) AS Deposit,         
sum(                
 case                 
  when accass.type in ('CP','DC','XP','QS','QP','S1','S2','S3','AF','FO') and accass.code='J' then AccAss.Amount                
  else 0                
 end                
) AS Advance,                  
dbo.roundccy(sum(AccAss.Amount),AccAss.Currency) - sum(AccAss.Amount)as Rounding,        
sum(
Case 
When Admlink.Amount is null then
	dbo.roundccy(
	AccAss.Amount
	*(Case When (AccAss.Type in ('BB','BA','BC','BP','OP') and Profile.VATF=1) or (AccAss.Type not in ('BB','BA','BC','BP','OP','DI','IC','CF','JP','BO') and Profile.VATF=1 and TOC.VATBusinessF=1) or (AccAss.Type in ('DI','IC','CF','JP','BO') and PHolder.VATF=1 and TOC.VATBusinessF=1) Then 1 Else 0 End)
	*(MParam.VAT/100)
	*(Case When SysTab.TaxMethod=0 or (Accass.Type in ('CP','DC','QS','QP','S1','S2','S3','AF','XP','FO','FP','IR','IX') and AccAss.Code='C') or (Accass.Type Not in ('CP','DC','QS','QP','S1','S2','S3','AF','XP','FO','FP','IR','IX') and AccAss.Code Not in ('F','D')) Then 1 else 0 end)
	*(Case When Acceptance.NoRefundF=7 and AccAss.Type in ('BB','BA','BO','BC') and AccAss.Code in ('C') then 0 else 1 end)
	*(Case When Acceptance.NoRefundF in (8,10) then 0 else 1 end)
	,AccAss.Currency)
When coalesce((Admlink.Amount-Admlink.Amount_11-Admlink.Amount_12-(Admlink.Amount_13+Admlink.Amount_17+Admlink.Amount_18)-Admlink.Amount_14),0)<>0 then 
	(Admlink.Amount_13)*AccAss.Amount/(Admlink.Amount-Admlink.Amount_11-Admlink.Amount_12-(Admlink.Amount_13+Admlink.Amount_17+Admlink.Amount_18)-Admlink.Amount_14) 
Else 0 end
)as VAT,        
sum(Case When coalesce((Admlink.Amount-Admlink.Amount_11-Admlink.Amount_12-(Admlink.Amount_13+Admlink.Amount_17+Admlink.Amount_18)-Admlink.Amount_14),0)<>0 then (Admlink.Amount_17)*AccAss.Amount/(Admlink.Amount-Admlink.Amount_11-Admlink.Amount_12-(Admlink.Amount_13+Admlink.Amount_17+Admlink.Amount_18)-Admlink.Amount_14) else 0 end)as VAT_1,        
sum(Case When coalesce((Admlink.Amount-Admlink.Amount_11-Admlink.Amount_12-(Admlink.Amount_13+Admlink.Amount_17+Admlink.Amount_18)-Admlink.Amount_14),0)<>0 then (Admlink.Amount_18)*AccAss.Amount/(Admlink.Amount-Admlink.Amount_11-Admlink.Amount_12-(Admlink.Amount_13+Admlink.Amount_17+Admlink.Amount_18)-Admlink.Amount_14) else 0 end)as VAT_2,        
sum(
Case 
When Admlink.Amount is null then
	dbo.roundccy(
	-(Case When AccAss.Code<>'C' or charindex(AccAss.Type,'FOFPQSQPS1S2S3AF')=0 then AccAss.Amount Else 0 end)
	*(Case When Profile.TaxF=1 Then 1 Else 0 End)
	*(Case 
		When TaxType.MTaxType='PASAL21' Then 
			Case When MParam.PASAL21<>0 Then (Case When Profile.AccruedTax<>0 Then Profile.AccruedTax else MParam.Pasal21*(100-MParam.TaxDiscount)/100 end) else 0 end/100
		When TaxType.MTaxType='PASAL23' Then
			Case When MParam.PASAL23<>0 Then (Case When Profile.AccruedTax<>0 Then Profile.AccruedTax else MParam.PASAL23 end) else 0 end/100 
		When TaxType.MTaxType='PASAL26' Then 
			Case When MParam.PASAL26<>0 Then (Case When Profile.AccruedTax<>0 Then Profile.AccruedTax else MParam.PASAL26 end) else 0 end/100
		When TaxType.MTaxType='PASAL4' Then 
			Case When MParam.PASAL4<>0 Then (Case When Profile.AccruedTax<>0 Then Profile.AccruedTax else MParam.PASAL4 end) else 0 end/100
		ELSE Profile.AccruedTax/100
		END)
	*Case When coalesce(Profile.TaxPCT,0)=0 then 1 else Profile.TaxPCT/100 end
	*(Case When Acceptance.NoRefundF=7 and AccAss.Type in ('BB','BA','BO','BC') and AccAss.Code in ('C') then 0 else 1 end)
	*(Case When Acceptance.NoRefundF in (9,10) then 0 else 1 end)
	,AccAss.Currency)
When coalesce((Admlink.Amount-Admlink.Amount_11-Admlink.Amount_12-(Admlink.Amount_13+Admlink.Amount_17+Admlink.Amount_18)-Admlink.Amount_14),0)<>0 then 
	Admlink.Amount_14*AccAss.Amount/(Admlink.Amount-Admlink.Amount_11-Admlink.Amount_12-(Admlink.Amount_13+Admlink.Amount_17+Admlink.Amount_18)-Admlink.Amount_14) 
Else 0 end
)as TAX    
FROM Acceptance 
Inner Join Cover on (Cover.CNO=Acceptance.CNO)
Inner Join TOC on (TOC.TOC=Acceptance.TOC)
Inner Join Profile PHolder on (PHolder.ID=Cover.PHOLDER)
Inner Join AccAss on (Acceptance.ANO=AccAss.ANO)
Left Join APayor on (APayor.ANO=Acceptance.ANO and Acceptance.LANO<>-1 and Acceptance.ANO<>Acceptance.LANO)                              
Left Join Payor on (Payor.ANO=Acceptance.ANO and Acceptance.LANO=-1)              
Left Join Acceptance pAcceptance on (pAcceptance.ANO=Acceptance.pANO)
Left Join Admlink on (Admlink.AdmNo=AccAss.AdmNo)
Inner Join Profile on (Profile.ID=AccAss.ID)
Left Join TaxType on (TaxType.TaxType=Profile.TaxType)
Inner Join Mparam on (MParam.Type=AccAss.Type)
Left Join Acceptance mAcceptance on (((Acceptance.RegNo<>'' and Acceptance.RegNo=mAcceptance.RegNo) or (Acceptance.RegNo='' and Acceptance.LANO=MAcceptance.ANO)) and MAcceptance.ANO=MAcceptance.LANO and MAcceptance.CNO=Acceptance.CNO)
Left Join Payor MPayor on (MPayor.ANO=mAcceptance.ANO)      
Inner Join SysTab on (1=1)
WHERE Acceptance.ANO=@P_ANO        
GROUP BY AccAss.ID, Profile.Name, AccAss.Type, AccAss.Posted, AccAss.Admno, AccAss.Currency, Acceptance.RegNo, Accass.DocNo, AccAss.RefNo,      
Case When AccAss.CAmount=0 and Coalesce(pAcceptance.Branch,'')<>'' Then pAcceptance.Branch Else Acceptance.Branch end,   
dbo.fn_Get_UWYear(Acceptance.SDate, Acceptance.EDate, Case When (Case When isnull(APayor.ANO,0)=0 Then (Case When isnull(MPayor.ANO,0)=0 Then Payor.PolicyYearF else MPayor.PolicyYearF end) else APayor.PolicyYearF end)=1 Then AccAss.SDate else Acceptance.SDate end) 


GO
DROP PROCEDURE View07A 
GO
CREATE PROCEDURE View07A (@p_ANo as integer)              
AS              
Declare @MRegNo as varchar(50)
Declare @MSDate as smalldatetime
Declare @MEDate as smalldatetime

Select @MRegNo=RegNo, @MSDate=SDate, @MEDate=EDate from Acceptance Where ANO=@P_ANO

if @MRegNo=''
Begin
	SELECT AccAss.ID, Profile.Name, AccAss.Type, AccAss.Posted, AccAss.Admno, AccAss.Currency, Acceptance.RegNo, Accass.DocNo, AccAss.RefNo,      
	Case When AccAss.CAmount=0 and Coalesce(pAcceptance.Branch,'')<>'' Then pAcceptance.Branch Else Acceptance.Branch end Branch,   
	dbo.fn_Get_UWYear(@MSDate, @MEDate, Case When (Case When isnull(APayor.ANO,0)=0 Then (Case When isnull(MPayor.ANO,0)=0 Then Payor.PolicyYearF else MPayor.PolicyYearF end) else APayor.PolicyYearF end)=1 Then AccAss.SDate else Acceptance.SDate end) as PolicyYear,
	(Case When isnull(APayor.ANO,0)=0 Then (Case When isnull(MPayor.ANO,0)=0 Then Payor.Grace else MPayor.Grace end) else APayor.Grace end) as Grace,
	sum(                
	 case                
	  when (accass.type in ('IR','IT','IX') and accass.code in ('P','U','F')) or (accass.type in ('DI','IC') and accass.code in ('P','U')) or (AccAss.Type not in ('DI','IC','IR','IT','IX') and AccAss.Code='P') then AccAss.Amount                
	  else 0                
	 end                
	) 
	+
	sum(
	 Case 
	  When Acceptance.NoRefundF=7 and AccAss.Type in ('BB','BA','BO','BC') and AccAss.Code in ('C') then AccAss.Amount 
	  else 0 
	 end
	)	
	AS Premium,                 
	sum(                
	 case                 
	  when accass.code='C' and coalesce(accass.codeext,'')='' then AccAss.Amount                
	  else 0                
	 end                
	) 
	-
	sum(
	 Case 
	  When Acceptance.NoRefundF=7 and AccAss.Type in ('BB','BA','BO','BC') and AccAss.Code in ('C') then AccAss.Amount 
	  else 0 
	 end
	)
	AS Commision,                 
	sum(                
	 case                 
	  when accass.code='C' and coalesce(accass.codeext,'')='1' then AccAss.Amount                
	  else 0                
	 end                
	) AS OverridingCommission,                 
	sum(                
	 case                 
	  when accass.Type not in ('IR','IT','IX') and accass.code='F' then AccAss.Amount                
	  else 0                
	 end                
	) AS Fee,                 
	sum(                
	 case                 
	  when accass.code='D' then AccAss.Amount                
	  else 0                
	 end                
	) AS Duty,                 
	sum(                
	 case                 
	  when accass.type not in ('CP','DC','XP','QS','QP','S1','S2','S3','AF','FO') and accass.code='O' then AccAss.Amount                
	  else 0                
	 end                
	) AS Discount,                 
	sum(                
	 case                 
	  when accass.type in ('CP','DC','XP','QS','QP','S1','S2','S3','AF','FO') and accass.code='O' and coalesce(accass.CodeExt,'')='' then AccAss.Amount                
	  else 0                
	 end                
	) AS Acquisition,   
	sum(                
	 case                 
	  when accass.type in ('CP','DC','XP','QS','QP','S1','S2','S3','AF','FO') and accass.code='O' and coalesce(accass.CodeExt,'')='1' then AccAss.Amount                
	  else 0                
	 end                
	) AS PremiumAdjustment,                               
	sum(                
	 case                
	  when accass.code='I' then AccAss.Amount                
	  else 0                
	 end                
	) AS OtherIncome,               
	sum(                
	 case                
	  when accass.type in ('IR','IT','IX') and accass.code='F' then -AccAss.Amount
	  when accass.Type in ('DI','IC') and accass.code='U' then -AccAss.Amount        
	  when accass.Type Not in ('DI','IC') and accass.code='U' then AccAss.Amount        
	  else 0                
	 End                
	) AS Ujroh,      
	sum(                
	 case                
	  when (accass.type in ('IR','IT','IX') and accass.code in ('P','U'))  or (accass.type in ('DI','IC') and accass.code in ('P')) or (AccAss.Type not in ('DI','IC','IR','IT','IX') and AccAss.Code in ('P','U')) then AccAss.Amount                
	  else 0                
	 end                
	) AS Tabarru,         
	sum(                
	 case                
	  when accass.type not in ('CP','DC','XP','QS','QP','S1','S2','S3','AF','FO') and accass.code='J' then AccAss.Amount                
	  else 0                
	 end                
	) AS Deposit,         
	sum(                
	 case                 
	  when accass.type in ('CP','DC','XP','QS','QP','S1','S2','S3','AF','FO') and accass.code='J' then AccAss.Amount                
	  else 0                
	 end                
	) AS Advance,                  
	dbo.roundccy(sum(AccAss.Amount),AccAss.Currency) - sum(AccAss.Amount)as Rounding, 
	sum(
	Case 
	When Admlink.Amount is null then
		dbo.roundccy(
		AccAss.Amount
		*(Case When (AccAss.Type in ('BB','BA','BC','BP','OP') and Profile.VATF=1) or (AccAss.Type not in ('BB','BA','BC','BP','OP','DI','IC','CF','JP','BO') and Profile.VATF=1 and TOC.VATBusinessF=1) or (AccAss.Type in ('DI','IC','CF','JP','BO') and PHolder.VATF=1 and TOC.VATBusinessF=1) Then 1 Else 0 End)
		*(MParam.VAT/100)
		*(Case When SysTab.TaxMethod=0 or (Accass.Type in ('CP','DC','QS','QP','S1','S2','S3','AF','XP','FO','FP','IR','IX') and AccAss.Code='C') or (Accass.Type Not in ('CP','DC','QS','QP','S1','S2','S3','AF','XP','FO','FP','IR','IX') and AccAss.Code Not in ('F','D')) Then 1 else 0 end)
		*(Case When Acceptance.NoRefundF=7 and AccAss.Type in ('BB','BA','BO','BC') and AccAss.Code in ('C') then 0 else 1 end)
		*(Case When Acceptance.NoRefundF in (8,10) then 0 else 1 end)
		,Accass.Currency)
	When coalesce((Admlink.Amount-Admlink.Amount_11-Admlink.Amount_12-(Admlink.Amount_13+Admlink.Amount_17+Admlink.Amount_18)-Admlink.Amount_14),0)<>0 then 
		(Admlink.Amount_13)*AccAss.Amount/(Admlink.Amount-Admlink.Amount_11-Admlink.Amount_12-(Admlink.Amount_13+Admlink.Amount_17+Admlink.Amount_18)-Admlink.Amount_14) 
	Else 0 end
	)as VAT,        
	sum(Case When coalesce((Admlink.Amount-Admlink.Amount_11-Admlink.Amount_12-(Admlink.Amount_13+Admlink.Amount_17+Admlink.Amount_18)-Admlink.Amount_14),0)<>0 then (Admlink.Amount_17)*AccAss.Amount/(Admlink.Amount-Admlink.Amount_11-Admlink.Amount_12-(Admlink.Amount_13+Admlink.Amount_17+Admlink.Amount_18)-Admlink.Amount_14) else 0 end)as VAT_1,        
	sum(Case When coalesce((Admlink.Amount-Admlink.Amount_11-Admlink.Amount_12-(Admlink.Amount_13+Admlink.Amount_17+Admlink.Amount_18)-Admlink.Amount_14),0)<>0 then (Admlink.Amount_18)*AccAss.Amount/(Admlink.Amount-Admlink.Amount_11-Admlink.Amount_12-(Admlink.Amount_13+Admlink.Amount_17+Admlink.Amount_18)-Admlink.Amount_14) else 0 end)as VAT_2,        
	sum(
	Case 	
	When Admlink.Amount is null then
		dbo.Roundccy(
		-(Case When AccAss.Code<>'C' or charindex(AccAss.Type,'FOFPQSQPS1S2S3AF')=0 then AccAss.Amount Else 0 end)
		*(Case When Profile.TaxF=1 Then 1 Else 0 End)
		*(Case 
			When TaxType.MTaxType='PASAL21' Then 
				Case When MParam.PASAL21<>0 Then (Case When Profile.AccruedTax<>0 Then Profile.AccruedTax else MParam.Pasal21*(100-MParam.TaxDiscount)/100 end) else 0 end/100
			When TaxType.MTaxType='PASAL23' Then
				Case When MParam.PASAL23<>0 Then (Case When Profile.AccruedTax<>0 Then Profile.AccruedTax else MParam.PASAL23 end) else 0 end/100 
			When TaxType.MTaxType='PASAL26' Then 
				Case When MParam.PASAL26<>0 Then (Case When Profile.AccruedTax<>0 Then Profile.AccruedTax else MParam.PASAL26 end) else 0 end/100
			When TaxType.MTaxType='PASAL4' Then 
				Case When MParam.PASAL4<>0 Then (Case When Profile.AccruedTax<>0 Then Profile.AccruedTax else MParam.PASAL4 end) else 0 end/100
			ELSE Profile.AccruedTax/100
		  END)
		*Case When coalesce(Profile.TaxPCT,0)=0 then 1 else Profile.TaxPCT/100 end
		*(Case When Acceptance.NoRefundF=7 and AccAss.Type in ('BB','BA','BO','BC') and AccAss.Code in ('C') then 0 else 1 end)
		*(Case When Acceptance.NoRefundF in (9,10) then 0 else 1 end)
		,AccAss.Currency)
	When coalesce((Admlink.Amount-Admlink.Amount_11-Admlink.Amount_12-(Admlink.Amount_13+Admlink.Amount_17+Admlink.Amount_18)-Admlink.Amount_14),0)<>0 then 
		Admlink.Amount_14*AccAss.Amount/(Admlink.Amount-Admlink.Amount_11-Admlink.Amount_12-(Admlink.Amount_13+Admlink.Amount_17+Admlink.Amount_18)-Admlink.Amount_14) 
	Else 0 end
	)as TAX    
	FROM Acceptance 
	Inner Join Cover on (Cover.CNO=Acceptance.CNO)
	Inner Join TOC on (TOC.TOC=Acceptance.TOC)
	Inner Join Profile PHolder on (PHolder.ID=Cover.PHOLDER)
	Inner Join AccAss on (Acceptance.ANO=AccAss.ANO)
	Left Join APayor on (APayor.ANO=Acceptance.ANO and Acceptance.LANO<>-1 and Acceptance.ANO<>Acceptance.LANO)                              
	Left Join Payor on (Payor.ANO=Acceptance.ANO and Acceptance.LANO=-1)              
	Left Join Acceptance pAcceptance on (pAcceptance.ANO=Acceptance.pANO)
	Left Join Admlink on (Admlink.AdmNo=AccAss.AdmNo)
	Inner Join Profile on (Profile.ID=AccAss.ID)
	Left Join TaxType on (TaxType.TaxType=Profile.TaxType)
	Inner Join Mparam on (MParam.Type=AccAss.Type)
	Left Join Payor MPayor on (MPayor.ANO=@P_ANO)      
	Inner Join SysTab on (1=1)
	WHERE Acceptance.LANO=@P_ANO
	GROUP BY AccAss.ID, Profile.Name, AccAss.Type, AccAss.Posted, AccAss.Admno, AccAss.Currency, Acceptance.RegNo, Accass.DocNo, AccAss.RefNo,      
	Case When AccAss.CAmount=0 and Coalesce(pAcceptance.Branch,'')<>'' Then pAcceptance.Branch Else Acceptance.Branch end,   
	dbo.fn_Get_UWYear(@MSDate, @MEDate, Case When (Case When isnull(APayor.ANO,0)=0 Then (Case When isnull(MPayor.ANO,0)=0 Then Payor.PolicyYearF else MPayor.PolicyYearF end) else APayor.PolicyYearF end)=1 Then AccAss.SDate else Acceptance.SDate end),
	(Case When isnull(APayor.ANO,0)=0 Then (Case When isnull(MPayor.ANO,0)=0 Then Payor.Grace else MPayor.Grace end) else APayor.Grace end)
END
ELSE
BEGIN
	SELECT AccAss.ID, Profile.Name, AccAss.Type, AccAss.Posted, AccAss.Admno, AccAss.Currency, Acceptance.RegNo, Accass.DocNo, AccAss.RefNo,      
	Case When AccAss.CAmount=0 and Coalesce(pAcceptance.Branch,'')<>'' Then pAcceptance.Branch Else Acceptance.Branch end Branch,   
	dbo.fn_Get_UWYear(@MSDate, @MEDate, Case When (Case When isnull(APayor.ANO,0)=0 Then (Case When isnull(MPayor.ANO,0)=0 Then Payor.PolicyYearF else MPayor.PolicyYearF end) else APayor.PolicyYearF end)=1 Then AccAss.SDate else Acceptance.SDate end) as PolicyYear,
	(Case When isnull(APayor.ANO,0)=0 Then (Case When isnull(MPayor.ANO,0)=0 Then Payor.Grace else MPayor.Grace end) else APayor.Grace end) as Grace,
	sum(                
	 case                
	  when (accass.type in ('IR','IT','IX') and accass.code in ('P','U','F')) or (accass.type in ('DI','IC') and accass.code in ('P','U')) or (AccAss.Type not in ('DI','IC','IR','IT','IX') and AccAss.Code='P') then AccAss.Amount                
	  else 0                
	 end                
	) 
	+
	sum(
	 Case 
	  When Acceptance.NoRefundF=7 and AccAss.Type in ('BB','BA','BO','BC') and AccAss.Code in ('C') then AccAss.Amount 
	  else 0 
	 end
	)	
	AS Premium,                 
	sum(                
	 case                 
	  when accass.code='C' and coalesce(accass.codeext,'')='' then AccAss.Amount                
	  else 0                
	 end                
	) 
	-
	sum(
	 Case 
	  When Acceptance.NoRefundF=7 and AccAss.Type in ('BB','BA','BO','BC') and AccAss.Code in ('C') then AccAss.Amount 
	  else 0 
	 end
	)	
	AS Commision,                 
	sum(                
	 case                 
	  when accass.code='C' and coalesce(accass.codeext,'')='1' then AccAss.Amount                
	  else 0                
	 end                
	) AS OverridingCommission,                 
	sum(                
	 case                 
	  when accass.Type not in ('IR','IT','IX') and accass.code='F' then AccAss.Amount                
	  else 0                
	 end                
	) AS Fee,            
	sum(                
	 case                 
	  when accass.code='D' then AccAss.Amount                
	  else 0                
	 end                
	) AS Duty,                 
	sum(                
	 case                 
	  when accass.type not in ('CP','DC','XP','QS','QP','S1','S2','S3','AF','FO') and accass.code='O' then AccAss.Amount                
	  else 0                
	 end                
	) AS Discount,                 
	sum(                
	 case                 
	  when accass.type in ('CP','DC','XP','QS','QP','S1','S2','S3','AF','FO') and accass.code='O' and coalesce(accass.CodeExt,'')='' then AccAss.Amount                
	  else 0                
	 end                
	) AS Acquisition,   
	sum(                
	 case                 
	  when accass.type in ('CP','DC','XP','QS','QP','S1','S2','S3','AF','FO') and accass.code='O' and coalesce(accass.CodeExt,'')='1' then AccAss.Amount                
	  else 0                
	 end                
	) AS PremiumAdjustment,                               
	sum(                
	 case                
	  when accass.code='I' then AccAss.Amount                
	  else 0                
	 end                
	) AS OtherIncome,               
	sum(                
	 case                
	  when accass.type in ('IR','IT','IX') and accass.code='F' then -AccAss.Amount
	  when accass.Type in ('DI','IC') and accass.code='U' then -AccAss.Amount        
	  when accass.Type Not in ('DI','IC') and accass.code='U' then AccAss.Amount        
	  else 0                
	 End                
	) AS Ujroh,              
	sum(                
	 case                
	  when (accass.type in ('IR','IT','IX') and accass.code in ('P','U'))  or (accass.type in ('DI','IC') and accass.code in ('P')) or (AccAss.Type not in ('DI','IC','IR','IT','IX') and AccAss.Code in ('P','U')) then AccAss.Amount                
	  else 0                
	 end                
	) AS Tabarru,         
	sum(                
	 case                
	  when accass.type not in ('CP','DC','XP','QS','QP','S1','S2','S3','AF','FO') and accass.code='J' then AccAss.Amount                
	  else 0                
	 end                
	) AS Deposit,         
	sum(                
	 case                 
	  when accass.type in ('CP','DC','XP','QS','QP','S1','S2','S3','AF','FO') and accass.code='J' then AccAss.Amount                
	  else 0                
	 end                
	) AS Advance,                  
	dbo.roundccy(sum(AccAss.Amount),AccAss.Currency) - sum(AccAss.Amount)as Rounding, 
	sum(
	Case 
	When Admlink.Amount is null then
		dbo.roundccy(
		AccAss.Amount
		*(Case When (AccAss.Type in ('BB','BA','BC','BP','OP') and Profile.VATF=1) or (AccAss.Type not in ('BB','BA','BC','BP','OP','DI','IC','CF','JP','BO') and Profile.VATF=1 and TOC.VATBusinessF=1) or (AccAss.Type in ('DI','IC','CF','JP','BO') and PHolder.VATF=1 and TOC.VATBusinessF=1) Then 1 Else 0 End)
		*(MParam.VAT/100)
		*(Case When SysTab.TaxMethod=0 or (Accass.Type in ('CP','DC','QS','QP','S1','S2','S3','AF','XP','FO','FP','IR','IX') and AccAss.Code='C') or (Accass.Type Not in ('CP','DC','QS','QP','S1','S2','S3','AF','XP','FO','FP','IR','IX') and AccAss.Code Not in ('F','D')) Then 1 else 0 end)
		*(Case When Acceptance.NoRefundF=7 and AccAss.Type in ('BB','BA','BO','BC') and AccAss.Code in ('C') then 0 else 1 end)
		*(Case When Acceptance.NoRefundF in (8,10) then 0 else 1 end)
		,AccAss.Currency)
	When coalesce((Admlink.Amount-Admlink.Amount_11-Admlink.Amount_12-(Admlink.Amount_13+Admlink.Amount_17+Admlink.Amount_18)-Admlink.Amount_14),0)<>0 then 
		(Admlink.Amount_13)*AccAss.Amount/(Admlink.Amount-Admlink.Amount_11-Admlink.Amount_12-(Admlink.Amount_13+Admlink.Amount_17+Admlink.Amount_18)-Admlink.Amount_14) 
	Else 0 end
	)as VAT,        
	sum(Case When coalesce((Admlink.Amount-Admlink.Amount_11-Admlink.Amount_12-(Admlink.Amount_13+Admlink.Amount_17+Admlink.Amount_18)-Admlink.Amount_14),0)<>0 then (Admlink.Amount_17)*AccAss.Amount/(Admlink.Amount-Admlink.Amount_11-Admlink.Amount_12-(Admlink.Amount_13+Admlink.Amount_17+Admlink.Amount_18)-Admlink.Amount_14) else 0 end)as VAT_1,        
	sum(Case When coalesce((Admlink.Amount-Admlink.Amount_11-Admlink.Amount_12-(Admlink.Amount_13+Admlink.Amount_17+Admlink.Amount_18)-Admlink.Amount_14),0)<>0 then (Admlink.Amount_18)*AccAss.Amount/(Admlink.Amount-Admlink.Amount_11-Admlink.Amount_12-(Admlink.Amount_13+Admlink.Amount_17+Admlink.Amount_18)-Admlink.Amount_14) else 0 end)as VAT_2,        
	sum(
	Case 
	When Admlink.Amount is null then
		dbo.roundccy(
		-(Case When AccAss.Code<>'C' or charindex(AccAss.Type,'FOFPQSQPS1S2S3AF')=0 then AccAss.Amount Else 0 end)
		*(Case When Profile.TaxF=1 Then 1 Else 0 End)
		*(Case 
			When TaxType.MTaxType='PASAL21' Then 
				Case When MParam.PASAL21<>0 Then (Case When Profile.AccruedTax<>0 Then Profile.AccruedTax else MParam.Pasal21*(100-MParam.TaxDiscount)/100 end) else 0 end/100
			When TaxType.MTaxType='PASAL23' Then
				Case When MParam.PASAL23<>0 Then (Case When Profile.AccruedTax<>0 Then Profile.AccruedTax else MParam.PASAL23 end) else 0 end/100 
			When TaxType.MTaxType='PASAL26' Then 
				Case When MParam.PASAL26<>0 Then (Case When Profile.AccruedTax<>0 Then Profile.AccruedTax else MParam.PASAL26 end) else 0 end/100
			When TaxType.MTaxType='PASAL4' Then 
				Case When MParam.PASAL4<>0 Then (Case When Profile.AccruedTax<>0 Then Profile.AccruedTax else MParam.PASAL4 end) else 0 end/100
			ELSE Profile.AccruedTax/100
		  END)
		*Case When coalesce(Profile.TaxPCT,0)=0 then 1 else Profile.TaxPCT/100 end
		*(Case When Acceptance.NoRefundF=7 and AccAss.Type in ('BB','BA','BO','BC') and AccAss.Code in ('C') then 0 else 1 end)
		*(Case When Acceptance.NoRefundF in (9,10) then 0 else 1 end)
		,AccAss.Currency)
	When coalesce((Admlink.Amount-Admlink.Amount_11-Admlink.Amount_12-(Admlink.Amount_13+Admlink.Amount_17+Admlink.Amount_18)-Admlink.Amount_14),0)<>0 then 
		Admlink.Amount_14*AccAss.Amount/(Admlink.Amount-Admlink.Amount_11-Admlink.Amount_12-(Admlink.Amount_13+Admlink.Amount_17+Admlink.Amount_18)-Admlink.Amount_14) 
	Else 0 end
	)as TAX    
	FROM Acceptance
	Inner Join Cover on (Cover.CNO=Acceptance.CNO)
	Inner Join TOC on (TOC.TOC=Acceptance.TOC)
	Inner Join Profile PHolder on (PHolder.ID=Cover.PHOLDER)
	Inner Join AccAss on (Acceptance.ANO=AccAss.ANO)
	Left Join APayor on (APayor.ANO=Acceptance.ANO and Acceptance.LANO<>-1 and Acceptance.ANO<>Acceptance.LANO)                              
	Left Join Payor on (Payor.ANO=Acceptance.ANO and Acceptance.LANO=-1)              
	Left Join Acceptance pAcceptance on (pAcceptance.ANO=Acceptance.pANO)
	Left Join Admlink on (Admlink.AdmNo=AccAss.AdmNo)
	Inner Join Profile on (Profile.ID=AccAss.ID)
	Left Join TaxType on (TaxType.TaxType=Profile.TaxType)
	Inner Join Mparam on (MParam.Type=AccAss.Type)
	Left Join Payor MPayor on (MPayor.ANO=@P_ANO)      
	Inner Join SysTab on (1=1)
	WHERE Acceptance.RegNo=@MRegNo
	GROUP BY AccAss.ID, Profile.Name, AccAss.Type, AccAss.Posted, AccAss.Admno, AccAss.Currency, Acceptance.RegNo, Accass.DocNo, AccAss.RefNo,      
	Case When AccAss.CAmount=0 and Coalesce(pAcceptance.Branch,'')<>'' Then pAcceptance.Branch Else Acceptance.Branch end,   
	dbo.fn_Get_UWYear(@MSDate, @MEDate, Case When (Case When isnull(APayor.ANO,0)=0 Then (Case When isnull(MPayor.ANO,0)=0 Then Payor.PolicyYearF else MPayor.PolicyYearF end) else APayor.PolicyYearF end)=1 Then AccAss.SDate else Acceptance.SDate end),
	(Case When isnull(APayor.ANO,0)=0 Then (Case When isnull(MPayor.ANO,0)=0 Then Payor.Grace else MPayor.Grace end) else APayor.Grace end)
END


GO

DROP FUNCTION PREMIUM_CALCULATION
GO
CREATE FUNCTION PREMIUM_CALCULATION(@P_ANO int)                  
RETURNS TABLE  AS                  
RETURN (                  

Select ANO, Currency,
sum(Premium) as Premium,
sum(Commission) as Commission,
sum(Discount) as Discount,
dbo.roundCCY(sum(VAT),Currency) as VAT,
dbo.roundCCY(sum(TAX),Currency) as TAX,
Sum(FeeDuty) as FeeDuty      
from
(
	Select ANO, Code, SDate, EDate, Currency,   
	sum(Premium-Case When NoRefundF=7 Then Premium*dbo.Premium_Commission(CANO,Code,PolicyYear,MinimumPremiumF)/100 else 0 end) as Premium,           
	sum(Case When NoRefundF=7 Then 0 else Premium*dbo.Premium_Commission(CANO,Code,PolicyYear,MinimumPremiumF)/100 end) as Commission,           
	sum(Premium*dbo.Premium_Discount(CANO,Code,PolicyYear)/100) as Discount,           
	sum(Case When NoRefundF=7 Then 0 else Premium*dbo.Premium_Commission_Vat(CANO,Code,PolicyYear,MinimumPremiumF)/100 end) as Vat,           
	sum(Case When NoRefundF=7 Then 0 else Premium*dbo.Premium_Commission_Tax(CANO,Code,PolicyYear,MinimumPremiumF)/100 end) as Tax,
	cast(0 as Float) as FeeDuty      
	from PREMIUM_CALCULATION_BASE(@P_ANO) T                                              
	Group By ANO, Code, SDate, EDate, Currency          

	Union All                  
                                 
	select A1.ANO, AccAss.Code, AccAss.SDate, AccAss.EDate, AccAss.Currency_OC as Currency,                  
	sum(Case When AccAss.Code in ('P','U') then (Case When A1.AType='A' and AccAss.AdjMethod='OVERLIMIT' then -AccAss.CAmount*(Case When A1.CPCT<>0 Then A1.CPCT/100 else 1 end)/(Case When AccAss.PProrata<>0 Then AccAss.PProrata else 1 end) else -AccAss.Amount_OC end)*(Case When AccAss.Type='DI' then 100/(100-coalesce(Coinsurance.MShare,0)) else 1 end) else 0 end) as Premium,                  
	sum(Case When AccAss.Code='C' then (Case When A1.AType='A' and AccAss.AdjMethod='OVERLIMIT' then AccAss.CAmount*(Case When A1.CPCT<>0 Then A1.CPCT/100 else 1 end)/(Case When AccAss.PProrata<>0 Then AccAss.PProrata else 1 end) else AccAss.Amount_OC end)*(Case When AccAss.Type='DI' then 100/(100-coalesce(Coinsurance.MShare,0)) else 1 end) else 0 end) as Commission,                  
	sum(Case When AccAss.Code='O' then (Case When A1.AType='A' and AccAss.AdjMethod='OVERLIMIT' then AccAss.CAmount*(Case When A1.CPCT<>0 Then A1.CPCT/100 else 1 end)/(Case When AccAss.PProrata<>0 Then AccAss.PProrata else 1 end) else AccAss.Amount_OC end)*(Case When AccAss.Type='DI' then 100/(100-coalesce(Coinsurance.MShare,0)) else 1 end) else 0 end) as Discount,                  
	sum((Case When A1.AType='A' and AccAss.AdjMethod='OVERLIMIT' then AccAss.CAmount*(Case When A1.CPCT<>0 Then A1.CPCT/100 else 1 end)/(Case When AccAss.PProrata<>0 Then AccAss.PProrata else 1 end) else AccAss.Amount_OC end)*(Case When AccAss.Type='DI' then 100/(100-coalesce(Coinsurance.MShare,0)) else 1 end)*(Case When Profile.VatF=1 Then MParam.Vat/100 else 0 end)) as Vat,                  
	sum((Case When A1.AType='A' and AccAss.AdjMethod='OVERLIMIT' then AccAss.CAmount*(Case When A1.CPCT<>0 Then A1.CPCT/100 else 1 end)/(Case When AccAss.PProrata<>0 Then AccAss.PProrata else 1 end) else AccAss.Amount_OC end)*(Case When AccAss.Type='DI' then 100/(100-coalesce(Coinsurance.MShare,0)) else 1 end)*(Case When Profile.TaxF=1 Then (Case When TaxType.MTaxType='PASAL21' Then MParam.Pasal21/100*(100-MParam.TaxDiscount)/100 When TaxType.MTaxType='PASAL23' Then MParam.Pasal23/100 When TaxType.MTaxType='PASAL26' Then MParam.Pasal26/100 When TaxType.MTaxType='PASAL4' Then MParam.PASAL4/100 else 0 end)*(Case When Profile.TaxPCT=0 Then 1 else Profile.TaxPCT/100 end) else Profile.AccruedTax/100 end)) as Tax,      
	sum(Case When AccAss.Code in ('F','D') then -AccAss.Amount_OC else 0 end) as FeeDuty      
	from Acceptance A1       
	inner join Acceptance A2 on (A2.OANO=A1.OANO)    
	inner join AccAss on (AccAss.ANO=A2.ANO)      
	inner join Profile on (Profile.ID=AccAss.ID)      
	Left Join TaxType on (TaxType.TaxType=Profile.TaxType)
	inner join MParam on (MParam.Type=Accass.Type)      
	Left Join (Select CNO, sum(Share) as MShare from Coinsurance Where PCollectionF=0 Group by CNO) Coinsurance on (Coinsurance.CNO=A2.CNO)      
	Left join Acceptance pA2 on (pA2.ANO=A2.PANO)      
	Left Join (
		Select Top 1 A1.ANO, A2.PDate as CPDate, coalesce(A2.ANO,0) as CANO from Acceptance A1 Left Join Acceptance A2 on (A2.OANO=A1.OANO and A2.Atype='C' and A2.EMethod='A' and A2.ANO<@P_ANO) Where A1.ANO=@P_ANO Order By A1.OANO, A2.ANO Desc
	) A3 on (A3.ANO=A1.ANO)
	Where A1.ANO=@P_ANO     
	and (                  
	(
	A2.ANO<=A1.PANO AND A2.ANO<@P_ANO AND A1.PDate<=A2.PDate and A1.PPDate>=A2.PPDate and A1.AType='A' and (A2.AType<>'A' and coalesce(pA2.AType,'')<>'A') and AccAss.AdjustableF=1 and (AccAss.AdjMethod<>'OVERLIMIT' or AccAss.CAmount<>0) and NOT EXISTS (Select PANO from Acceptance A3 Where A3.PANO=A2.ANO and A3.AStatus<>'C' and A3.AType='A' and A3.ANO<>@P_ANO)
	)                  
	or 
	(
	A2.ANO<@P_ANO AND A1.AType='C' and A1.EMethod='A' 
	and (
	 (
		case when A2.ANO<=A3.CANO and A2.PDate>coalesce(A3.CPDate,A2.PDate) Then coalesce(A3.CPDate,A2.PDate) else A2.PDate end>=A1.PDate and AccAss.CAmount<>0
	 ) or 
	 (
		case when A2.ANO<=A3.CANO and coalesce(pA2.pDate,A2.PDate)>coalesce(A3.CPDate,coalesce(pA2.pDate,A2.PDate)) Then coalesce(A3.CPDate,coalesce(pA2.pDate,A2.PDate)) else coalesce(pA2.pDate,A2.PDate) end>=A1.PDate and AccAss.CAmount=0
	 )
	 )
	)                  
	or 
	(A2.ANO=A1.PANO and A1.AType='C' and A2.AType='A')
	)                  
	and ((AccAss.Type in ('DI','IC','IR') and AccAss.Code='P') or (AccAss.Type in ('DI','IC') and AccAss.Code='U') Or (AccAss.Type in ('BB','BA','BO') and AccAss.Code='C') or (AccAss.Type in ('DI','IC','IR') and AccAss.Code='O') or (A1.AType='C' and A1.EMethod='A' and AccAss.Type in ('DI') and AccAss.Code in ('F','D')))                  
	Group By A1.ANO, AccAss.Code, AccAss.SDate, AccAss.EDate, AccAss.Currency_OC                                                                             
) T          
Group by ANO, Currency


)           
GO

--16 APR 2021 : TUNNING AUTOGENERATE
IF NOT EXISTS (SELECT * FROM sys.indexes WHERE name='I_Admlink_A_PolicyNo_Currency_Subject_Type_DocNo_Date' AND object_id = OBJECT_ID(N'Admlink'))
Begin
create index I_Admlink_A_PolicyNo_Currency_Subject_Type_DocNo_Date on Admlink(A_PolicyNo, Currency, Subject, Type, DocNo, Date)
END
GO
IF NOT EXISTS (SELECT * FROM sys.indexes WHERE name='I_ARBucket_A_PolicyNo_RefNo_Type_Subject' AND object_id = OBJECT_ID(N'ARBucket'))
Begin
create index I_ARBucket_A_PolicyNo_RefNo_Type_Subject on ARBucket(A_PolicyNo, RefNo, Type, Subject)
END
GO
IF EXISTS (SELECT * FROM sys.indexes WHERE name='I_Admlink_A_PolicyNo' AND object_id = OBJECT_ID(N'Admlink'))
Begin
drop index Admlink.I_Admlink_A_PolicyNo
END
GO
IF EXISTS (SELECT * FROM sys.indexes WHERE name='I_Admlink_BillDate' AND object_id = OBJECT_ID(N'Admlink'))
Begin
drop index Admlink.I_Admlink_BillDate
END
GO

--2020 V.1.3.2

--5 Mar 2021
IF NOT EXISTS(SELECT * FROM SYSFORM WHERE FNAME='ALLOWENDORSEWITHCLAIMINCURRED')
BEGIN
insert into sysform(FName, Description, FCode, RequestF)
Select 'ALLOWENDORSEWITHCLAIMINCURRED', 'Allow Endorse With Already Claim Incurred (UW)','ACTIVITIES',0
END
go

--26 Apr 2021
/* To prevent any potential data loss issues, you should review this script in detail before running it outside the context of the database designer.*/

SET QUOTED_IDENTIFIER ON
SET ARITHABORT ON
SET NUMERIC_ROUNDABORT OFF
SET CONCAT_NULL_YIELDS_NULL ON
SET ANSI_NULLS ON
SET ANSI_PADDING ON
SET ANSI_WARNINGS ON


GO
IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'CessionF' AND Object_ID = Object_ID(N'ACCFD'))
BEGIN
ALTER TABLE ACCFD ADD
	CessionF bit NULL
DECLARE @v sql_variant 
SET @v = N'Share to Outward Treaty (0 : No, 1 : Yes)'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'ACCFD', N'COLUMN', N'CessionF'
END
GO


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
		Case When A1.Amount<>0 Then
			A1.Amount*100/coalesce(R.PCTSHARE-R.MSHARE,100)
		Else
			(
				Select 
				sum(D1.Gross*P.Gross/P.OGross)
				from Display_Calculation(A2.ANO) D1, Acceptance A, PCalc P
				Where P.ANO=A.ANO and P.Currency=D1.Currency and A.ANO=D1.ANO and D1.Currency=A1.Currency
			)*A1.AmountPCT/100
		End    as FEE
		from 
		Acceptance A3
		Inner Join Acceptance A2 on (A2.OANO=A3.OANO and A2.ANO<=@P_ANO)
		INNER JOIN AccFD A1 on (A1.ANO=A2.ANO and A1.ContributionF=0 and A1.CessionF=0 And A1.AmountPCTBased=0 And (A1.PolicyYear=0 or A1.PolicyYear=@P_Period))
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
		Case When A1.Amount<>0 Then
			--Not Yet for Master Policy
			0
		Else
			(
				Select 
				sum(D1.Gross*P.Gross/P.OGross)
				from Display_Calculation(A2.ANO) D1, Acceptance A, PCalc P
				Where P.ANO=A.ANO and P.Currency=D1.Currency and A.ANO=D1.ANO and D1.Currency=A1.Currency
			)*A1.AmountPCT/100
		End    as FEE
		from
		Acceptance A3 
		Inner Join Acceptance A2 on (A2.OANO=A3.OANO and A2.ANO<=@P_ANO)
		INNER JOIN Acceptance MA on (MA.RegNo=A2.RegNo and MA.ANO=MA.LANO)
		INNER JOIN COVER C on (C.CNO=MA.CNO and C.OPENFLAG=0)
		INNER JOIN AccFD A1 on (A1.ANO=MA.ANO and A1.ContributionF=0 and A1.CessionF=0 and A1.AmountPCTBased=0 And (A1.PolicyYear=0 or A1.PolicyYear=@P_Period))
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

GO


DROP Procedure QRCESSIONDET 
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
Inner join RPart R2 on (R2.RNO=R1.RNO and R2.ID=@P_ID)
Inner Join ReClass R3 on (R3.RNO=R1.RNO and R3.TOC=A.TOC)
Left Join ReClassDet R4 on (R4.RNO=R3.RNO AND R4.TOC=R3.TOC AND R4.CODE=@P_CODE)  
Where A.ANO=@P_ANO

Select @Premium_Treaty_Discount=dbo.Premium_Treaty_Discount(@P_ANO, @P_Code,@P_Period)          
Select @Premium_Discount=dbo.premium_discount(@P_ANO, @P_Code, @P_Period)  
Select @Premium_Commission=dbo.Premium_Commission(@P_ANO, @P_Code, @P_Period,0)+dbo.Premium_Commission_Vat(@P_ANO, @P_Code, @P_Period,0)  
Select @Premium_Fee=dbo.Premium_Fee(@P_ANO, @P_Period)  
Select @Premium_outGo=@Premium_Discount+@Premium_Commission+@Premium_Commission_Inward+@Premium_Fee-(Case When @P_OnNetPremiumF=1 Then @Premium_Treaty_Discount else 0 end)

SELECT @P_OPFEE=Case When @P_OPFEEF=1 THen COALESCE(SUM(FEE),0) Else 0 End, @P_RITabarruF=coalesce(cast(Max(cast(RITabarruF as Int)) as Bit),0)
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
       INNER JOIN AccFD A1 on (A1.ANO=A2.ANO and A1.Currency=@P_CCY and (A1.ContributionF=1 or A1.CessionF=1) and A1.AmountPCTBased=0 And (A1.PolicyYear=0 or A1.PolicyYear=@P_Period))
       INNER JOIN FDTAB on (FDTAB.FDID=A1.FDID and Left(FDTAB.FDType,1)='O')
       INNER Join PCalc on (PCalc.ANO=A2.ANO and PCalc.Currency=A1.Currency)
       INNER JOIN RARRHEADER R ON (R.ANO=A2.ANO)
       Where @P_RType in ('Q','S1','S2','S3','A') and A2.OANO=@P_OANO and A2.ANO<=@P_ANO  
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
       INNER JOIN AccFD A1 on (A1.ANO=MA.ANO and A1.Currency=@P_CCY and (A1.ContributionF=1 or A1.CessionF=1) and A1.AmountPCTBased=0 And (A1.PolicyYear=0 or A1.PolicyYear=@P_Period))
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
LEFT JOIN RPARTDET ON (RPARTDET.RNO=@P_RNO AND RPARTDET.ID=@P_ID AND RPARTDET.TOR=ICALC.TOR)  
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
INNER JOIN RPARTDET ON (RPARTDET.RNO=@P_RNO AND RPARTDET.ID=@P_ID AND RPARTDET.TOR=ICALC.TOR AND (RPARTDET.NOFYEARS=0 OR RPARTDET.NOFYEARS=@P_NOFYEARS) and RPARTDET.EXCLUDEF=0)  
LEFT Join FN_RateCon(@P_ANO, @P_CODE,@P_TSI,@P_ASDate) RateCon On (RateCon.Code=ICalc.Code)  
LEFT Join FN_RRateCon(@P_ANO, @P_RID, @P_TSI) RRateCon On (1=1)              
INNER JOIN ICOVER ON (ICOVER.INO=ICALC.INO AND (ICOVER.ADJUSTABLE=@P_ADJUSTABLEF OR @P_AType='A'))  
INNER JOIN RCALC ON (RCALC.ANO=ICALC.ANO AND RCALC.CURRENCY=ICALC.CURRENCY AND RCALC.CODE=ICALC.CODE AND RCALC.TOR=ICALC.TOR AND RCALC.SDATE=ICALC.SDATE AND RCALC.EDATE=ICALC.EDATE AND RCALC.SANO=ICALC.SANO AND RCALC.EXTREATYF=0)  
INNER JOIN PCALC_ANNUM(@P_ANO) PCALC ON (PCALC.ANO=ICALC.ANO AND PCALC.CODE=ICALC.CODE AND PCALC.SDATE=ICALC.SDATE AND PCALC.EDATE=ICALC.EDATE AND PCALC.INO=ICALC.INO AND PCALC.CURRENCY=ICALC.CURRENCY)  
WHERE ICALC.ANO=@P_ANO AND ICALC.CURRENCY=@P_CCY AND ICALC.SDATE=@P_SDATE AND ICALC.EDATE=@P_EDATE AND ICALC.CODE=@P_CODE              
AND PCALC.GROSS<>0  

) R        


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
Select @Premium_Commission=dbo.Premium_Commission_Net(@P_ANO, @P_Code, @P_Period,0)+dbo.Premium_Commission_Net_Vat(@P_ANO, @P_Code, @P_Period,0)  
Select @Premium_Fee=dbo.Premium_Fee(@P_ANO, @P_Period)  
Select @Premium_outGo=@Premium_Discount+@Premium_Commission+@Premium_Commission_Inward+@Premium_Fee

SELECT @P_OPFEE=CASE WHEN @P_OPFEEF=1 THEN COALESCE(SUM(FEE),0) ELSE 0 END, @P_RITabarruF=coalesce(cast(Max(cast(RITabarruF as Int)) as Bit),0)
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
                    from Display_Calculation(A2.ANO) D1
					Inner Join Acceptance A on (A.ANO=D1.ANO)
					Inner Join RArrHeader R on (R.ANO=D1.ANO)
					Inner Join PCalc P on (P.ANO=D1.ANO and P.Currency=D1.Currency)
                    Where  D1.Currency=@P_CCY
             )*A1.AmountPCT/100*Case When A1.RITabarruF=1 Then cast(100 as Float)/@P_Tabarru Else 1 end
       End    as FEE,
	   A1.RITabarruF 
       from 
       Acceptance A2
       INNER JOIN AccFD A1 on (A1.ANO=A2.ANO and A1.Currency=@P_CCY and (A1.ContributionF=1 or A1.CessionF=1) and A1.AmountPCTBased=0 And (A1.PolicyYear=0 or A1.PolicyYear=@P_Period))
       INNER JOIN FDTAB on (FDTAB.FDID=A1.FDID and Left(FDTAB.FDType,1)='O')
       INNER Join PCalc on (PCalc.ANO=A2.ANO and PCalc.Currency=A1.Currency)
       INNER JOIN RARRHEADER R ON (R.ANO=A2.ANO)
       Where @P_RType in ('Q','S1','S2','S3','A') and A2.OANO=@P_OANO and A2.ANO<=@P_ANO  
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
	   INNER JOIN Acceptance MA on (MA.RegNo=A2.RegNo and MA.ANO=MA.LANO)
	   INNER JOIN COVER C on (C.CNO=MA.CNO and C.OPENFLAG=0)
       INNER JOIN AccFD A1 on (A1.ANO=MA.ANO and A1.Currency=@P_CCY and (A1.ContributionF=1 or A1.CessionF=1) and A1.AmountPCTBased=0 And (A1.PolicyYear=0 or A1.PolicyYear=@P_Period))
       INNER JOIN FDTAB on (FDTAB.FDID=A1.FDID and Left(FDTAB.FDType,1)='O')
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
LEFT JOIN RPARTDET ON (RPARTDET.RNO=@P_RNO AND RPARTDET.ID=RPART.ID AND RPARTDET.TOR=ICALC.TOR)  
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
INNER JOIN RPARTDET ON (RPARTDET.RNO=@P_RNO AND RPARTDET.ID=RPART.ID AND RPARTDET.TOR=ICALC.TOR AND (RPARTDET.NOFYEARS=0 OR RPARTDET.NOFYEARS=@P_NOFYEARS) and RPARTDET.EXCLUDEF=0)  
LEFT Join FN_RateCon(@P_ANO, @P_CODE,@P_TSI,@P_ASDate) RateCon On (RateCon.Code=ICalc.Code)  
LEFT Join FN_RRateCon(@P_ANO, @P_RID, @P_TSI) RRateCon On (1=1)              
INNER JOIN ICOVER ON (ICOVER.INO=ICALC.INO AND (ICOVER.ADJUSTABLE=@P_ADJUSTABLEF OR @P_AType='A'))  
INNER JOIN RCALC ON (RCALC.ANO=ICALC.ANO AND RCALC.CURRENCY=ICALC.CURRENCY AND RCALC.CODE=ICALC.CODE AND RCALC.TOR=ICALC.TOR AND RCALC.SDATE=ICALC.SDATE AND RCALC.EDATE=ICALC.EDATE AND RCALC.SANO=ICALC.SANO AND RCALC.EXTREATYF=0)  
INNER JOIN PCALC_ANNUM(@P_ANO) PCALC ON (PCALC.ANO=ICALC.ANO AND PCALC.CODE=ICALC.CODE AND PCALC.SDATE=ICALC.SDATE AND PCALC.EDATE=ICALC.EDATE AND PCALC.INO=ICALC.INO AND PCALC.CURRENCY=ICALC.CURRENCY)  
WHERE ICALC.ANO=@P_ANO AND ICALC.CURRENCY=@P_CCY AND ICALC.SDATE=@P_SDATE AND ICALC.EDATE=@P_EDATE AND ICALC.CODE=@P_CODE              
AND PCALC.GROSS<>0  
Group By RPart.ID


) R        




go

--27 Apr 2021 : Penambahan Servicing WorkFlow
if exists (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'fn_GetServicingActionUser') AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) )
BEGIN
DROP Function fn_GetServicingActionUser
END
GO
CREATE Function fn_GetServicingActionUser(@ActionCode varchar(10), @SNO int)   
RETURNS @ActionUser TABLE (ID varchar(50), Name varchar(255), Type varchar(10), ApprovalLimit Float, LastRequestDate Smalldatetime)  
AS   
BEGIN   
 Declare @T table(ID varchar(50), Name varchar(255), Type varchar(10), TypeDesc varchar(255), ApprovalLimit Float)
 Declare @Type varchar(10)

 Declare @LOB Varchar(10)
 Declare @BType Varchar(10)
 Declare @SType varchar(10)
 Declare @TOC varchar(10)
 Declare @Branch varchar(10)
 Declare @ISType varchar(1)
 Declare @Amount Float
 Declare @ApprLimitPCT Float

 Select
 @LOB=coalesce(BS.LOB,''), 
 @BType=Case When S.ISTYPE in ('I','C','L') Then 'DIRECT' else 'INDIRECT' end, 
 @SType=Case When PT.STYPE in ('S') Then 'SINGLE' When PT.SType in ('M') Then 'MASTER' else 'OPEN' end,
 @TOC=S.TOC,
 @Branch=S.Branch,
 @ISType=S.ISType,
 @Amount=S.TSI,
 @ApprLimitPCT=100
 from Service S
 Left Join PolicyType PT on (PT.PolicyType=S.PolicyType)
 Left Join Profile BS on (BS.ID=S.BSID) 
 Where S.SNO=@SNO

 insert into @T
 Select S.ID, S.Name, S.Type, S.TypeDesc, S.ApprovalLimit 
 from
 (
	 Select S.ID, S.Name, S.Type, S.TypeDesc, 
	 dbo.GetApprovalLimit(S.ID, @TOC, @ISType,'In', @Branch, @ApprLimitPCT) as ApprovalLimit
	 from
	 (
		Select Distinct S.*
		From
		( 
			Select S2.ID, S2.Name, S5.Type, S5.Description as TypeDesc
			from ActionUser S1
			Inner Join SysUser S2 on (S2.ID=S1.ActionUser and S2.AllowedF=1 and cast(convert(varchar(10), getdate(),1) as smalldatetime)<=S2.Expiry and S2.LockedF=0)
			Inner Join SysUserTOC S3 on (S3.ID=S2.ID and S3.TOC=@TOC and S3.EFFECTIVE<=cast(convert(varchar(10), getdate(),1) as smalldatetime))
			Inner Join SysUserBranch S4 on (S4.ID=S2.ID and S4.AllowedF=1 and S4.Branch=@Branch)
			Inner Join SysUserType S5 on (S5.Type=S2.Type)
			Left Join ActionUserDet A on (A.ActionCode=S1.ActionCode and A.ActionUser=S1.ActionUser)
			Where  S1.ActionCode=@ActionCode and coalesce(A.ActionCode,'')='' or ((A.LOB='<ALL>' or A.LOB=@LOB) and (A.BTYPE='<ALL>' or A.BTYPE=@BTYPE) and (A.STYPE='<ALL>' or A.STYPE=@STYPE))

			Union All

			Select S2.ID, S2.Name, S5.Type, S5.Description as TypeDesc
			from ActionUser S1
			Inner Join SysUser S2 on (S2.Type=S1.ActionUser and S2.AllowedF=1 and cast(convert(varchar(10), getdate(),1) as smalldatetime)<=S2.Expiry and S2.LockedF=0)
			Inner Join SysUserTOC S3 on (S3.ID=S2.ID and S3.TOC=@TOC and S3.EFFECTIVE<=cast(convert(varchar(10), getdate(),1) as smalldatetime))
			Inner Join SysUserBranch S4 on (S4.ID=S2.ID and S4.AllowedF=1 and S4.Branch=@Branch)
			Inner Join SysUserType S5 on (S5.Type=S2.Type)
			Left Join ActionUserDet A on (A.ActionCode=S1.ActionCode and A.ActionUser=S1.ActionUser)
			Where  S1.ActionCode=@ActionCode and coalesce(A.ActionCode,'')='' or ((A.LOB='<ALL>' or A.LOB=@LOB) and (A.BTYPE='<ALL>' or A.BTYPE=@BTYPE) and (A.STYPE='<ALL>' or A.STYPE=@STYPE))
		) S
	 ) S
 ) S
 Where (S.ApprovalLimit>=@Amount or dbo.GetPrivileges(S.ID,'ALLOWPASSAPPLIMIT')=1)

 Select top 1 @Type=T.Type from @T T
 Order by T.ApprovalLimit

 --insert into @ActionUser 
 --Select Top 1 T.Type as ID, T.TypeDesc as Name, 'T' as Type, T.ApprovalLimit, Null as LastRequestDate
 --from @T T
 --Where T.Type=@Type

 insert into @ActionUser 
 Select T.ID as ID, T.Name as Name, 'U' as Type, T.ApprovalLimit, coalesce((Select top 1 convert(varchar(10),UserDate,102)+' '+UserTime from sysrequest Where Status='' and Param1='SEND' and Param2 in ('MAR','UND') and Param5=T.ID order by UserDate Desc),NULL) as lastRequestDate
 from @T T
 Where T.Type=@Type

Return   
End   


go

--28 APR 2021 : PENAMBAHAN STIME DAN ETIME PADA REGISTER SERVICING
/* To prevent any potential data loss issues, you should review this script in detail before running it outside the context of the database designer.*/

SET QUOTED_IDENTIFIER ON
SET ARITHABORT ON
SET NUMERIC_ROUNDABORT OFF
SET CONCAT_NULL_YIELDS_NULL ON
SET ANSI_NULLS ON
SET ANSI_PADDING ON
SET ANSI_WARNINGS ON


GO
IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'STime' AND Object_ID = Object_ID(N'Service'))
BEGIN
ALTER TABLE Service ADD
	STime varchar(8) NULL
DECLARE @v sql_variant 
SET @v = N'Start Time Of Insurance Period'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'Service', N'COLUMN', N'STime'
END
GO

IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'ETime' AND Object_ID = Object_ID(N'Service'))
BEGIN
ALTER TABLE Service ADD
	ETime varchar(8) NULL
DECLARE @v sql_variant 
SET @v = N'End Time Of Insurance Period'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'Service', N'COLUMN', N'ETime'
END
GO

GO
DROP Procedure qServicing_Data
GO
CREATE Procedure qServicing_Data(@P_SNO integer) 
AS 
Select S1.SNO, S1.ServiceNo, S1.ServiceDate, S1.SType, S1.Subject, S1.ServiceInfo, S1.Validation, 
S1.PolicyNo, S1.CertificateNo, S1.RefNo, S1.ClaimNo, S1.TOC, S1.TopRO, S1.CoverDate, S1.ExpDate, S1.PID, S1.Name, S1.Address_1, S1.Address_2, S1.Phone_1, S1.Fax_1,S1.PType,S1.CGroup, S1.Area, S1.AID, S1.Insured, 
S1.MO, S1.Segment, S1.Branch, S1.CT, S1.ISType, S1.PolicyType, S1.Code, S1.Coverage, S1.Currency, S1.TSI, S1.ATSI, S1.Rate, S1.Premium, S1.SStatus, S1.BSID, S1.BSName, S1.BSType, S1.TBAF, 
S1.UserID, S1.CDate, S1.CTime, 
S1.LUserID, S1.LDate, S1.LTime, 
S1.CUserID, S1.CloseDate, S1.CloseTime, 
S1.PUserID, S1.PUserDate, S1.PUserTime, 
S1.AUserID, S1.AUserDate, S1.AUserTime, 
S1.PANO, S1.ANO, S1.LANO, S1.CNO, S1.PSNO, S1.VSeqNo, S1.Remarks, S1.ASource, S1.RegID, S1.FLDID, S1.ValueID, S1.ValueDesc, S1.InfoF, S1.SurveyF, S1.Priority, S1.RequestF, S1.RequestMessage, S1.RequestName, 
S1.STime, S1.ETime,
S2.FLDID1, S2.VALUEID1, S2.VALUEDESC1, 0 as FLDSEARCH1, 
S2.FLDID2, S2.VALUEID2, S2.VALUEDESC2, 0 as FLDSEARCH2, 
S2.FLDID3, S2.VALUEID3, S2.VALUEDESC3, 0 as FLDSEARCH3, 
S2.FLDID4, S2.VALUEID4, S2.VALUEDESC4, 0 as FLDSEARCH4, 
S2.FLDID5, S2.VALUEID5, S2.VALUEDESC5, 0 as FLDSEARCH5, 
S2.FLDID6, S2.VALUEID6, S2.VALUEDESC6, 0 as FLDSEARCH6, 
S2.FLDID7, S2.VALUEID7, S2.VALUEDESC7, 0 as FLDSEARCH7, 
S2.FLDID8, S2.VALUEID8, S2.VALUEDESC8, 0 as FLDSEARCH8, 
S2.FLDID9, S2.VALUEID9, S2.VALUEDESC9, 0 as FLDSEARCH9, 
S2.FLDID10, S2.VALUEID10, S2.VALUEDESC10, 0 as FLDSEARCH10, 
S2.FLDID11, S2.VALUEID11, S2.VALUEDESC11, 0 as FLDSEARCH11, 
S2.FLDID12, S2.VALUEID12, S2.VALUEDESC12, 0 as FLDSEARCH12, 
S2.FLDID13, S2.VALUEID13, S2.VALUEDESC13, 0 as FLDSEARCH13, 
S2.FLDID14, S2.VALUEID14, S2.VALUEDESC14, 0 as FLDSEARCH14, 
S2.FLDID15, S2.VALUEID15, S2.VALUEDESC15, 0 as FLDSEARCH15 
from Service S1 Left Join SInfo S2 on (S2.SNO=S1.SNO) 
Where S1.SNO=@P_SNO 
 
 

GO

--4 MAY 2021 : PENAMBAHAN UPPING FEE
/* To prevent any potential data loss issues, you should review this script in detail before running it outside the context of the database designer.*/

SET QUOTED_IDENTIFIER ON
SET ARITHABORT ON
SET NUMERIC_ROUNDABORT OFF
SET CONCAT_NULL_YIELDS_NULL ON
SET ANSI_NULLS ON
SET ANSI_PADDING ON
SET ANSI_WARNINGS ON


GO
IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'BSUPFEE' AND Object_ID = Object_ID(N'Scheme_Transaction'))
BEGIN
ALTER TABLE Scheme_Transaction ADD
	BSUPFEE float(53) NULL
DECLARE @v sql_variant 
SET @v = N'Upping Fee in %'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'Scheme_Transaction', N'COLUMN', N'BSUPFEE'
END
GO

IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'BSUPFEEAMOUNT' AND Object_ID = Object_ID(N'Scheme_Transaction'))
BEGIN
ALTER TABLE Scheme_Transaction ADD
	BSUPFEEAMOUNT float(53) NULL
DECLARE @v sql_variant 
SET @v = N'Upping Fee in Amount'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'Scheme_Transaction', N'COLUMN', N'BSUPFEEAMOUNT'
END
GO


--13 MAY 2021
DROP FUNCTION DISPLAY_PRORATA_CALCULATION
GO
CREATE FUNCTION DISPLAY_PRORATA_CALCULATION(@P_ANO int)        
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
When Acceptance.AType<>'N' then        

 case        
 when DateDiff(day, RCalc.Edate, acceptance.pdate)>=0 then ''
 when DateDiff(day, acceptance.pdate, RCalc.SDate)>0 then ''        
 Else        
  case        
  when acceptance.cpct<>0 or Cover.Voyage=1 then        
   case when acceptance.cpct<>0 and acceptance.cpct<>100 then convert(varchar(25),Cast(Acceptance.CPCT as float),0)+'%' else '' end        
  Else        
	--Prorata Calculation
	Case When Acceptance.EXCLUSIVEF=0 and Acceptance.STime<Acceptance.ETime and RCalc.EDate=Acceptance.EDate Then
		dbo.fn_calc_sprorata(acceptance.pDate, dateadd(day,1,RCalc.edate), RCalc.Sdate, dateadd(day,1,RCalc.edate), Cover.PPeriod)
	else
		dbo.fn_calc_sprorata(acceptance.pDate, RCalc.Edate, RCalc.Sdate, RCalc.EDate, Cover.PPeriod)
	End
  End
 End        
Else        
 ''        
end,        
          
Prorata=        
case        
When Acceptance.AType<>'N' then        
 case        
 when DateDiff(day, RCalc.Edate, acceptance.pdate)>=0 then 0        
 when DateDiff(day, acceptance.pdate, RCalc.SDate)>0 then 1        
 Else        
  case        
  when acceptance.cpct<>0 or Cover.Voyage=1 then        
   case when acceptance.cpct<>0 and acceptance.cpct<>100 then Acceptance.CPCT/100 else 1 end        
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
                                
From acceptance        
inner Join Cover on (Cover.CNO=Acceptance.CNO)        
inner join PCalc on (PCalc.ANO=Acceptance.ANO)        
inner join RCalc on (RCalc.ANO=PCalc.ANO and RCalc.Currency=PCalc.Currency)        
inner Join RCover on (RCover.ANO=Acceptance.ANO and RCover.Code=RCalc.Code and RCover.SDate=RCalc.SDate)        
Where Acceptance.AType not in ('A','C')        
and not (Acceptance.Atype<>'N' and Acceptance.NoRefundF<>12 and (RCover.NoRefundF=1 or Acceptance.NoRefundF in (2,4) or (Acceptance.NoRefundF in (1) and DateDiff(day, acceptance.pdate, RCalc.SDate) <= 0)))
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
when DateDiff(day, rcalc.Edate, acceptance.pdate)>=0 and acceptance.pdate between pacceptance.sdate and pacceptance.edate then ''        
when DateDiff(day, acceptance.pdate, rcalc.SDate)>0 and acceptance.pdate between pacceptance.sdate and pacceptance.edate then ''        

Else        
  case        
  when acceptance.cpct<>0 or Cover.Voyage=1 then        
    case when acceptance.cpct<>0 and acceptance.cpct<>100 then convert(varchar(25),Cast(Acceptance.CPCT as float),0)+'%' else '' end        
  Else        
    case        
		When Acceptance.SDate<>Acceptance.PDate or Acceptance.NoRefundF=6 then        
			--Prorata Calculation
			Case When pAcceptance.EXCLUSIVEF=0 and pAcceptance.STime<pAcceptance.ETime and RCalc.EDate=pAcceptance.EDate Then
				CASE WHEN RCOVER.CPFORMULA = 'PRORATE SQ' and Acceptance.AType='C' and Acceptance.EMethod<>'A' THEN
					'('+dbo.fn_Calc_SProrata(dbo.fn_Get_Effective_Cancellation_By_Payor_Schedule(Acceptance.ANO, Acceptance.PDate,dateadd(day,1,RCalc.edate)), dateadd(day,1,RCalc.edate), RCalc.Sdate, dateadd(day,1,RCalc.edate), Cover.PPeriod)+') ^ 2'
				ELSE
					CASE WHEN Acceptance.AType='C' and Acceptance.EMethod<>'A' THEN
						dbo.fn_Calc_SProrata(dbo.fn_Get_Effective_Cancellation_By_Payor_Schedule(Acceptance.ANO, Acceptance.PDate,dateadd(day,1,RCalc.edate)), dateadd(day,1,RCalc.edate), RCalc.Sdate, dateadd(day,1,RCalc.edate), Cover.PPeriod)
					Else
						dbo.fn_Calc_SProrata(acceptance.pDate, dateadd(day,1,RCalc.edate), RCalc.Sdate, dateadd(day,1,RCalc.edate), Cover.PPeriod)
					End
				END				
			else
				CASE WHEN RCOVER.CPFORMULA = 'PRORATE SQ' and Acceptance.AType='C' and Acceptance.EMethod<>'A' THEN
					'('+dbo.fn_Calc_SProrata(dbo.fn_Get_Effective_Cancellation_By_Payor_Schedule(Acceptance.ANO, Acceptance.PDate,RCalc.Edate), RCalc.Edate, RCalc.Sdate, RCalc.EDate, Cover.PPeriod)+') ^ 2'
				ELSE
					CASE WHEN Acceptance.AType='C' and Acceptance.EMethod<>'A' THEN
						dbo.fn_Calc_SProrata(dbo.fn_Get_Effective_Cancellation_By_Payor_Schedule(Acceptance.ANO, Acceptance.PDate,RCalc.Edate), RCalc.Edate, RCalc.Sdate, RCalc.EDate, Cover.PPeriod)
					Else
						dbo.fn_Calc_SProrata(acceptance.pDate, RCalc.Edate, RCalc.Sdate, RCalc.EDate, Cover.PPeriod)
					End
				END				
			End

		Else        
		 -- Endorsement Period        
			''        
		End       
	End        
End        
+ (Case When Acceptance.CPCT=0 and Acceptance.AType='C' and Acceptance.EMethod<>'A' and Acceptance.NoRefundF<>12 and RCover.CPRefund<>0 and not (DateDiff(day, acceptance.pdate, rcalc.SDate)>0 and acceptance.pdate between pacceptance.sdate and pacceptance.edate) Then ' x '+convert(varchar(25),RCover.CPRefund,0)+'%' else '' end)
,        
Prorata=        
case        
when DateDiff(day, rcalc.Edate, acceptance.pdate)>=0 and acceptance.pdate between pacceptance.sdate and pacceptance.edate then 0        
when DateDiff(day, acceptance.pdate, rcalc.SDate)>0  and acceptance.pdate between pacceptance.sdate and pacceptance.edate then 1        

Else        
  case        
  when acceptance.cpct<>0 or Cover.Voyage=1 then        
    case when acceptance.cpct<>0 and acceptance.cpct<>100 then Acceptance.CPCT/100 else 1 end        
  Else        
    case        
		When Acceptance.SDate<>Acceptance.PDate or Acceptance.NoRefundF=6 then        
			--Prorata Calculation
			Case When pAcceptance.EXCLUSIVEF=0 and pAcceptance.STime<pAcceptance.ETime and RCalc.EDate=pAcceptance.EDate Then
				CASE WHEN RCOVER.CPFORMULA = 'PRORATE SQ' and Acceptance.AType='C' and Acceptance.EMethod<>'A' THEN
					POWER(dbo.fn_calc_prorata(dbo.fn_Get_Effective_Cancellation_By_Payor_Schedule(Acceptance.ANO, Acceptance.PDate,dateadd(day,1,RCalc.edate)), dateadd(day,1,RCalc.edate), RCalc.Sdate, dateadd(day,1,RCalc.edate), Cover.PPeriod),2)
				ELSE
					Case When Acceptance.AType='C' and Acceptance.EMethod<>'A' THEN
						dbo.fn_calc_prorata(dbo.fn_Get_Effective_Cancellation_By_Payor_Schedule(Acceptance.ANO, Acceptance.PDate,dateadd(day,1,RCalc.edate)), dateadd(day,1,RCalc.edate), RCalc.Sdate, dateadd(day,1,RCalc.edate), Cover.PPeriod)
					Else
						dbo.fn_calc_prorata(acceptance.pDate, dateadd(day,1,RCalc.edate), RCalc.Sdate, dateadd(day,1,RCalc.edate), Cover.PPeriod)
					End
				END				
			else
				CASE WHEN RCOVER.CPFORMULA = 'PRORATE SQ' and Acceptance.AType='C' and Acceptance.EMethod<>'A' THEN
					POWER(dbo.fn_calc_prorata(dbo.fn_Get_Effective_Cancellation_By_Payor_Schedule(Acceptance.ANO, Acceptance.PDate,RCalc.Edate), RCalc.Edate, RCalc.Sdate, RCalc.EDate, Cover.PPeriod),2)
				ELSE
					Case When Acceptance.AType='C' and Acceptance.EMethod<>'A' THEN
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
* (Case When Acceptance.CPCT=0 and Acceptance.AType='C' and Acceptance.EMethod<>'A' and Acceptance.NoRefundF<>12 and RCover.CPRefund<>0 and not (DateDiff(day, acceptance.pdate, rcalc.SDate)>0 and acceptance.pdate between pacceptance.sdate and pacceptance.edate) Then RCover.CPRefund/100 else 1 end)

From acceptance        
inner Join Cover on (Cover.CNO=Acceptance.CNO)        
inner join Acceptance pAcceptance on (pAcceptance.ANO=Acceptance.pANO)        
inner join PCalc on (PCalc.ANO=pAcceptance.ANO)        
inner join RCalc on (RCalc.ANO=PCalc.ANO and RCalc.Currency=PCalc.Currency)        
Left Join RCover on (RCover.ANO=Acceptance.ANO and RCover.Code=RCalc.Code and ((RCover.SDate=Acceptance.SDate and RCover.EDate=Acceptance.EDate and RCalc.SDate=pAcceptance.SDate and RCalc.EDate=pAcceptance.EDate) or (RCover.SDate=RCalc.SDate)))
Where Acceptance.AType<>'A' and Not (Acceptance.AType='C' and Acceptance.EMethod='A') and pAcceptance.AType not in ('A','C')        
and Not (Acceptance.Atype<>'N' and Acceptance.NoRefundF<>12 and (coalesce(RCover.NoRefundF,0)=1 or Acceptance.NoRefundF in (2,4) or (Acceptance.NoRefundF in (1) and DateDiff(day, acceptance.pdate, RCalc.SDate) <= 0)))
and Not (DateDiff(day, rcalc.Edate, acceptance.pdate)>=0 and acceptance.pdate between pacceptance.sdate and pacceptance.edate)
and Acceptance.ANO=@P_ANO        
)        
       
GO

DROP FUNCTION PREMIUM_CALCULATION_CONSTANT
GO
CREATE FUNCTION PREMIUM_CALCULATION_CONSTANT(@P_ANO int) 
RETURNS TABLE  AS 
RETURN ( 
Select ANO, Currency, sum(Premium) as Premium 
 
from( 
Select ANO, Currency, sum(Premium) as Premium 
 
from ( 
select Acceptance.ANO,RCalc.Currency, 
-case 
when DateDiff(day, rcalc.Edate, acceptance.pdate)>=0 and acceptance.pdate between pacceptance.sdate and pacceptance.edate then 0 
when DateDiff(day, acceptance.pdate, rcalc.SDate)>0 and acceptance.pdate between pacceptance.sdate and pacceptance.edate then 1 
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
					Case When Acceptance.AType='C' and Acceptance.EMethod<>'A' THEN
						dbo.fn_calc_prorata(dbo.fn_Get_Effective_Cancellation_By_Payor_Schedule(Acceptance.ANO, Acceptance.PDate,dateadd(day,1,RCalc.edate)), dateadd(day,1,RCalc.edate), RCalc.Sdate, dateadd(day,1,RCalc.edate), Cover.PPeriod)
					else
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
* (Case When PCalc.Description='Minimum Premium' Then RCalc.Gross else (Case When PCalc.Gross=0 then 0 else Case When PCalc.OGross=0 Then PCalc.Gross else RCalc.OGross*(case When Pcalc.TSI=0 then 1 else PCalc.Ourshare/PCalc.TSI end) *PCalc.Gross/PCalc.OGross end end) end+RCalc.Reinstatement)
* (Case When Acceptance.CPCT=0 and Acceptance.AType='C' and Acceptance.EMethod<>'A' and Acceptance.NoRefundF<>12 and RCover.CPRefund<>0 and not (DateDiff(day, acceptance.pdate, rcalc.SDate)>0 and acceptance.pdate between pacceptance.sdate and pacceptance.edate) Then RCover.CPRefund/100 else 1 end) as Premium      

from Acceptance inner join Acceptance pAcceptance on (pAcceptance.ANO=Acceptance.pANO) inner Join Cover on (Cover.CNO=Acceptance.CNO) 
inner join PCalc on (PCalc.ANO=pAcceptance.ANO) inner join RCalc on (RCalc.ANO=PCalc.ANO and RCalc.Currency=PCalc.Currency) 
Left Join RCover on (RCover.ANO=Acceptance.ANO and RCover.Code=RCalc.Code and ((RCover.SDate=Acceptance.SDate and RCover.EDate=Acceptance.EDate and RCalc.SDate=pAcceptance.SDate and RCalc.EDate=pAcceptance.EDate) or (RCover.SDate=RCalc.SDate)))
Where Acceptance.ANO=@P_ANO and Acceptance.AType<>'A' and Not (Acceptance.AType='C' and Acceptance.EMethod='A') and pAcceptance.AType not in ('A','C') 
and Not (Acceptance.Atype<>'N' and Acceptance.NoRefundF<>12 and (coalesce(RCover.NoRefundF,0)=1 or Acceptance.NoRefundF in (2,4) or (Acceptance.NoRefundF in (1) and DateDiff(day, acceptance.pdate, RCalc.SDate) <= 0)))
and Not (DateDiff(day, rcalc.Edate, acceptance.pdate)>=0 and acceptance.pdate between pacceptance.sdate and pacceptance.edate)
and RCalc.Gross<>0 
) T 
 
Group By ANO, Currency 
 
Union All 
 
select A1.ANO, AccAss.Currency_OC as Currency, 
sum(Case When AccAss.Code='P' then (Case When A1.AType='A' and AccAss.AdjMethod='OVERLIMIT' then -AccAss.CAmount*(Case When A1.CPCT<>0 Then A1.CPCT/100 else 1 end)/(Case When AccAss.PProrata<>0 Then AccAss.PProrata else 1 end) else -AccAss.Amount_OC end)*
(Case When AccAss.Type='DI' then 100/(100-coalesce(Coinsurance.MShare,0)) else 1 end) else 0 end) as Premium 
from Acceptance A1 
inner join Acceptance A2 on (A2.OANO=A1.OANO) 
inner join AccAss on (AccAss.ANO=A2.ANO) 
inner join Profile on (Profile.ID=AccAss.ID) 
inner join MParam on (MParam.Type=Accass.Type) 
Left Join (Select CNO, sum(Share) as MShare from Coinsurance Where PCollectionF=0 Group by CNO) Coinsurance on (Coinsurance.CNO=A2.CNO) 
Left join Acceptance pA2 on (pA2.ANO=A2.PANO) 
Where A1.ANO=@P_ANO 
and ( 
(A2.ANO<=A1.PANO AND A2.ANO<@P_ANO AND A1.PDate<=A2.PDate and A1.PPDate>=A2.PPDate and A1.AType='A' and AccAss.AdjustableF=1 and (AccAss.AdjMethod<>'OVERLIMIT' or AccAss.CAmount<>0) and NOT EXISTS (Select PANO from Acceptance A3 Where A3.PANO=A2.ANO and A3.AStatus<>'C' and A3.AType='A' and A3.ANO<>@P_ANO)) 
or (A2.ANO<@P_ANO AND A1.AType='C' and A1.EMethod='A' and A2.PDate>=A1.PDate and (coalesce(pA2.pDate,A2.PDate)>=A1.PDate or A2.ATYPE='A' or (coalesce(pA2.pDate,A2.PDate)<A1.PDate and AccAss.CAmount<>0))) 
or (A2.ANO=A1.PANO and A2.AType='A' and A1.AType='C')) 
and ((AccAss.Type in ('DI','IC','IR') and AccAss.Code='P') Or (AccAss.Type in ('BB','BA','BO') and AccAss.Code='C') or (AccAss.Type in ('DI','IC','IR') and AccAss.Code='O') or (A1.AType='C' and A1.EMethod='A' and AccAss.Type in ('DI') and AccAss.Code in ('F','D'))) 
Group By A1.ANO, AccAss.Currency_OC 
) T 
 
Group By ANO, Currency 
) 
 
GO

DROP FUNCTION PREMIUM_CALCULATION_BASE
GO
CREATE FUNCTION PREMIUM_CALCULATION_BASE(@P_ANO int)                  

RETURNS @PCALC TABLE (ANO Int, Currency varchar(10), CANO int, Code varchar(10), SDate SmallDatetime, EDate SmallDatetime, PolicyYear Int, NoRefundF Int, MinimumPremiumF Bit, Premium Float)
AS
BEGIN

DECLARE @ACCEPTANCE TABLE (ANO Int, CNO Int, SDate SmallDateTime, EDate SmallDateTime, STime Varchar(5), ETime varchar(5), NOREFUNDF Int, EXCLUSIVEF Bit, AType varchar(10), PDate SmallDateTime, CPCT Float, QTY Int, PANO Int, EMethod varchar(1))
INSERT INTO @ACCEPTANCE
SELECT ANO, CNO, SDATE, EDate, STime, ETime, NOREFUNDF, EXCLUSIVEF, ATYPE, PDATE, CPCT, QTY, PANO, EMETHOD 
FROM ACCEPTANCE WHERE ANO=@P_ANO

INSERT INTO @PCALC
Select ANO, Currency, CANO, Code, SDate, EDate, PolicyYear, NoRefundF, Cast(Max(MinimumPremiumF) as Bit) as MinimumPremiumF, sum(Premium) as Premium
 from (                  
  select Acceptance.ANO, RCalc.Currency, @P_ANO as CANO, RCalc.Code,  RCalc.SDate, RCalc.Edate, cast(datediff(Month,Acceptance.SDate, RCalc.SDate) as integer) / 12 + 1  as PolicyYear,          
  Acceptance.NoRefundF,   
  Case When Upper(PCALC.DESCRIPTION) in ('MINIMUM PREMIUM','POLICY MINIMUM PREMIUM') Then 1 else 0 end as MinimumPremiumF,                                       
  case                  
  When Acceptance.Atype<>'N' and Acceptance.NoRefundF<>12 and (RCover.NoRefundF=1 or Acceptance.NoRefundF in (2,4) or (Acceptance.NoRefundF in (1) and DateDiff(day, acceptance.pdate, RCalc.SDate) <= 0)) Then 0
  When Acceptance.AType<>'N' then                  
   case                  
   when DateDiff(day, rcalc.Edate, acceptance.pdate)>=0 then 0                  
   when DateDiff(day, acceptance.pdate, rcalc.SDate)>0 then 1                  
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
  Left Join ISource on (ISource.CNO=Cover.CNO)
  Where Acceptance.ANO=@P_ANO 
  and Acceptance.AType not in ('A','C')                  
  and PCalc.Gross<>0          
                                                    
  Union All                  
                                                                                             
  select Acceptance.ANO, RCalc.Currency, Acceptance.PANO as CANO, RCalc.Code, RCalc.SDate, RCalc.Edate, cast(datediff(Month,pAcceptance.SDate, RCalc.SDate) as integer) / 12 + 1 as PolicyYear,          
  Acceptance.NoRefundF,   
  Case When Upper(PCALC.DESCRIPTION) in ('MINIMUM PREMIUM','POLICY MINIMUM PREMIUM') Then 1 else 0 end as MinimumPremiumF,                                       
  -case     
  When Acceptance.Atype<>'N' and Acceptance.NoRefundF<>12 and (coalesce(RCover.NoRefundF,0)=1 or Acceptance.NoRefundF in (2,4) or (Acceptance.NoRefundF in (1) and DateDiff(day, acceptance.pdate, RCalc.SDate) <= 0)) Then 0
  when DateDiff(day, rcalc.Edate, acceptance.pdate)>=0 and acceptance.pdate between pacceptance.sdate and pacceptance.edate then 0                  
  when DateDiff(day, acceptance.pdate, rcalc.SDate)>0 and acceptance.pdate between pacceptance.sdate and pacceptance.edate then 1                  
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
  Left Join ISource on (ISource.CNO=Cover.CNO)
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
  Left Join ISource on (ISource.CNO=sAcceptance.CNO)
  Where Acceptance.ANO=@P_ANO 
  and Acceptance.AType='A'                  
  and PCalc.Gross<>0   
        
) T                  
                                      
Group By ANO, Currency, CANO, Code, SDate, EDate, PolicyYear, NoRefundF  

RETURN

END

GO


  
--17 MAY 2021
DROP FUNCTION FN_GENDTAB
GO
CREATE FUNCTION FN_GENDTAB (@P_FLDID as varchar(10), @P_TOC as varchar(10),@P_SEGMENT as varchar(10), @P_ISTYPE as varchar(1))     
RETURNS TABLE     
as RETURN(     
Select G1.*, coalesce((Select Top 1 ANO from AccSearch Where AccSearch.FLDID=G1.FLDID and AccSearch.ValueID=G1.ValueID order by ANO Desc),0) as RecentUsed    
from GenDTab G1 
Inner Join GenHTab G2 on (G2.FLDID=G1.FLDID)     
Where     
G1.FLDID=@P_FLDID
and
(     
G2.SubClassF=0 or @P_TOC=''     
or (G2.SubClassF=1 and EXISTS (Select Top 1 ValueID from GenDTOC G3 Where G3.FLDID=G1.FLDID and G3.VALUEID=G1.VALUEID and (G3.TOC='<All>' or G3.TOC=@P_TOC)))     
)  
and      
(     
G2.SegmentF=0 or @P_SEGMENT=''     
or (G2.SegmentF=1 and EXISTS (Select Top 1 ValueID from GenDSegment G3 Where G3.FLDID=G1.FLDID and G3.VALUEID=G1.VALUEID and (G3.SEGMENT='<All>' or G3.SEGMENT=@P_SEGMENT)))     
)  
and      
(     
G2.SegmentF=0 or @P_SEGMENT=''     
or (G2.SegmentF=1 and EXISTS (Select Top 1 ValueID from GenDSegment G3 Where G3.FLDID=G1.FLDID and G3.VALUEID=G1.VALUEID and (G3.SEGMENT='<All>' or G3.SEGMENT=@P_SEGMENT)))     
)  
and
(     
G2.ISTYPEF=0 or @P_ISTYPE=''     
or (G2.ISTYPEF=1 and EXISTS (Select Top 1 ValueID from GenDISTYPE G3 Where G3.FLDID=G1.FLDID and G3.VALUEID=G1.VALUEID and (G3.ISTYPE='<All>' or G3.ISTYPE=@P_ISTYPE)))     
)  
) 




GO

--10 MAY 2021
/* To prevent any potential data loss issues, you should review this script in detail before running it outside the context of the database designer.*/

SET QUOTED_IDENTIFIER ON
SET ARITHABORT ON
SET NUMERIC_ROUNDABORT OFF
SET CONCAT_NULL_YIELDS_NULL ON
SET ANSI_NULLS ON
SET ANSI_PADDING ON
SET ANSI_WARNINGS ON


GO
IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'FLDENCRYPTF' AND Object_ID = Object_ID(N'GENHTAB'))
BEGIN
ALTER TABLE GENHTAB ADD
	FLDENCRYPTF bit NULL
DECLARE @v sql_variant 
SET @v = N'Display as Encrypt Field (0 : No, 1 : Yes) - see Usage ini Additional Claim Information'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'GENHTAB', N'COLUMN', N'FLDENCRYPTF'
END
GO


GO
DROP PROCEDURE QCOBEXT_GENHTAB
GO
CREATE PROCEDURE QCOBEXT_GENHTAB (@P_COB AS VARCHAR(10))
AS
SELECT  TOP 1
 COB.COB,
 COB.FLDID1, COB.FLDTAG1, GENHTAB_1.FLDTAB AS FLDTAB1, GENHTAB_1.FLDCOM AS FLDCOM1, GENHTAB_1.FLDDFORMAT AS FLDDFORMAT1, GENHTAB_1.FLDIFORMAT AS FLDIFORMAT1, GENHTAB_1.FLDTYPE AS FLDTYPE1, GENHTAB_1.SUBLINKF AS SUBLINKF1,  GENHTAB_1.FLDSEARCH AS FLDSEARCH1, GENHTAB_1.FLDCRITERIA AS FLDCRITERIA1,GENHTAB_1.FLDENCRYPTF AS FLDENCRYPTF1,
 COB.FLDID2, COB.FLDTAG2, GENHTAB_2.FLDTAB AS FLDTAB2, GENHTAB_2.FLDCOM AS FLDCOM2, GENHTAB_2.FLDDFORMAT AS FLDDFORMAT2, GENHTAB_2.FLDIFORMAT AS FLDIFORMAT2, GENHTAB_2.FLDTYPE AS FLDTYPE2, GENHTAB_2.SUBLINKF AS SUBLINKF2,  GENHTAB_2.FLDSEARCH AS FLDSEARCH2, GENHTAB_2.FLDCRITERIA AS FLDCRITERIA2,GENHTAB_2.FLDENCRYPTF AS FLDENCRYPTF2,
 COB.FLDID3, COB.FLDTAG3, GENHTAB_3.FLDTAB AS FLDTAB3, GENHTAB_3.FLDCOM AS FLDCOM3, GENHTAB_3.FLDDFORMAT AS FLDDFORMAT3, GENHTAB_3.FLDIFORMAT AS FLDIFORMAT3, GENHTAB_3.FLDTYPE AS FLDTYPE3, GENHTAB_3.SUBLINKF AS SUBLINKF3,  GENHTAB_3.FLDSEARCH AS FLDSEARCH3, GENHTAB_3.FLDCRITERIA AS FLDCRITERIA3,GENHTAB_3.FLDENCRYPTF AS FLDENCRYPTF3,
 COB.FLDID4, COB.FLDTAG4, GENHTAB_4.FLDTAB AS FLDTAB4, GENHTAB_4.FLDCOM AS FLDCOM4, GENHTAB_4.FLDDFORMAT AS FLDDFORMAT4, GENHTAB_4.FLDIFORMAT AS FLDIFORMAT4, GENHTAB_4.FLDTYPE AS FLDTYPE4, GENHTAB_4.SUBLINKF AS SUBLINKF4,  GENHTAB_4.FLDSEARCH AS FLDSEARCH4, GENHTAB_4.FLDCRITERIA AS FLDCRITERIA4,GENHTAB_4.FLDENCRYPTF AS FLDENCRYPTF4,
 COB.FLDID5, COB.FLDTAG5, GENHTAB_5.FLDTAB AS FLDTAB5, GENHTAB_5.FLDCOM AS FLDCOM5, GENHTAB_5.FLDDFORMAT AS FLDDFORMAT5, GENHTAB_5.FLDIFORMAT AS FLDIFORMAT5, GENHTAB_5.FLDTYPE AS FLDTYPE5, GENHTAB_5.SUBLINKF AS SUBLINKF5,  GENHTAB_5.FLDSEARCH AS FLDSEARCH5, GENHTAB_5.FLDCRITERIA AS FLDCRITERIA5,GENHTAB_5.FLDENCRYPTF AS FLDENCRYPTF5,
 COB.FLDID6, COB.FLDTAG6, GENHTAB_6.FLDTAB AS FLDTAB6, GENHTAB_6.FLDCOM AS FLDCOM6, GENHTAB_6.FLDDFORMAT AS FLDDFORMAT6, GENHTAB_6.FLDIFORMAT AS FLDIFORMAT6, GENHTAB_6.FLDTYPE AS FLDTYPE6, GENHTAB_6.SUBLINKF AS SUBLINKF6,  GENHTAB_6.FLDSEARCH AS FLDSEARCH6, GENHTAB_6.FLDCRITERIA AS FLDCRITERIA6,GENHTAB_6.FLDENCRYPTF AS FLDENCRYPTF6,
 COB.FLDID7, COB.FLDTAG7, GENHTAB_7.FLDTAB AS FLDTAB7, GENHTAB_7.FLDCOM AS FLDCOM7, GENHTAB_7.FLDDFORMAT AS FLDDFORMAT7, GENHTAB_7.FLDIFORMAT AS FLDIFORMAT7, GENHTAB_7.FLDTYPE AS FLDTYPE7, GENHTAB_7.SUBLINKF AS SUBLINKF7,  GENHTAB_7.FLDSEARCH AS FLDSEARCH7, GENHTAB_7.FLDCRITERIA AS FLDCRITERIA7,GENHTAB_7.FLDENCRYPTF AS FLDENCRYPTF7,
 COB.FLDID8, COB.FLDTAG8, GENHTAB_8.FLDTAB AS FLDTAB8, GENHTAB_8.FLDCOM AS FLDCOM8, GENHTAB_8.FLDDFORMAT AS FLDDFORMAT8, GENHTAB_8.FLDIFORMAT AS FLDIFORMAT8, GENHTAB_8.FLDTYPE AS FLDTYPE8, GENHTAB_8.SUBLINKF AS SUBLINKF8,  GENHTAB_8.FLDSEARCH AS FLDSEARCH8, GENHTAB_8.FLDCRITERIA AS FLDCRITERIA8,GENHTAB_8.FLDENCRYPTF AS FLDENCRYPTF8,
 COB.FLDID9, COB.FLDTAG9, GENHTAB_9.FLDTAB AS FLDTAB9, GENHTAB_9.FLDCOM AS FLDCOM9, GENHTAB_9.FLDDFORMAT AS FLDDFORMAT9, GENHTAB_9.FLDIFORMAT AS FLDIFORMAT9, GENHTAB_9.FLDTYPE AS FLDTYPE9, GENHTAB_9.SUBLINKF AS SUBLINKF9,  GENHTAB_9.FLDSEARCH AS FLDSEARCH9, GENHTAB_9.FLDCRITERIA AS FLDCRITERIA9,GENHTAB_9.FLDENCRYPTF AS FLDENCRYPTF9,
 COB.FLDID10, COB.FLDTAG10, GENHTAB_10.FLDTAB AS FLDTAB10, GENHTAB_10.FLDCOM AS FLDCOM10, GENHTAB_10.FLDDFORMAT AS FLDDFORMAT10, GENHTAB_10.FLDIFORMAT AS FLDIFORMAT10, GENHTAB_10.FLDTYPE AS FLDTYPE10, GENHTAB_10.SUBLINKF AS SUBLINKF10,  GENHTAB_10.FLDSEARCH AS FLDSEARCH10, GENHTAB_10.FLDCRITERIA AS FLDCRITERIA10,GENHTAB_10.FLDENCRYPTF AS FLDENCRYPTF10,
 COB.FLDID11, COB.FLDTAG11, GENHTAB_11.FLDTAB AS FLDTAB11, GENHTAB_11.FLDCOM AS FLDCOM11, GENHTAB_11.FLDDFORMAT AS FLDDFORMAT11, GENHTAB_11.FLDIFORMAT AS FLDIFORMAT11, GENHTAB_11.FLDTYPE AS FLDTYPE11, GENHTAB_11.SUBLINKF AS SUBLINKF11,  GENHTAB_11.FLDSEARCH AS FLDSEARCH11, GENHTAB_11.FLDCRITERIA AS FLDCRITERIA11,GENHTAB_11.FLDENCRYPTF AS FLDENCRYPTF11,
 COB.FLDID12, COB.FLDTAG12, GENHTAB_12.FLDTAB AS FLDTAB12, GENHTAB_12.FLDCOM AS FLDCOM12, GENHTAB_12.FLDDFORMAT AS FLDDFORMAT12, GENHTAB_12.FLDIFORMAT AS FLDIFORMAT12, GENHTAB_12.FLDTYPE AS FLDTYPE12, GENHTAB_12.SUBLINKF AS SUBLINKF12,  GENHTAB_12.FLDSEARCH AS FLDSEARCH12, GENHTAB_12.FLDCRITERIA AS FLDCRITERIA12,GENHTAB_12.FLDENCRYPTF AS FLDENCRYPTF12,
 COB.FLDID13, COB.FLDTAG13, GENHTAB_13.FLDTAB AS FLDTAB13, GENHTAB_13.FLDCOM AS FLDCOM13, GENHTAB_13.FLDDFORMAT AS FLDDFORMAT13, GENHTAB_13.FLDIFORMAT AS FLDIFORMAT13, GENHTAB_13.FLDTYPE AS FLDTYPE13, GENHTAB_13.SUBLINKF AS SUBLINKF13,  GENHTAB_13.FLDSEARCH AS FLDSEARCH13, GENHTAB_13.FLDCRITERIA AS FLDCRITERIA13,GENHTAB_13.FLDENCRYPTF AS FLDENCRYPTF13,
 COB.FLDID14, COB.FLDTAG14, GENHTAB_14.FLDTAB AS FLDTAB14, GENHTAB_14.FLDCOM AS FLDCOM14, GENHTAB_14.FLDDFORMAT AS FLDDFORMAT14, GENHTAB_14.FLDIFORMAT AS FLDIFORMAT14, GENHTAB_14.FLDTYPE AS FLDTYPE14, GENHTAB_14.SUBLINKF AS SUBLINKF14,  GENHTAB_14.FLDSEARCH AS FLDSEARCH14, GENHTAB_14.FLDCRITERIA AS FLDCRITERIA14,GENHTAB_14.FLDENCRYPTF AS FLDENCRYPTF14,
 COB.FLDID15, COB.FLDTAG15, GENHTAB_15.FLDTAB AS FLDTAB15, GENHTAB_15.FLDCOM AS FLDCOM15, GENHTAB_15.FLDDFORMAT AS FLDDFORMAT15, GENHTAB_15.FLDIFORMAT AS FLDIFORMAT15, GENHTAB_15.FLDTYPE AS FLDTYPE15, GENHTAB_15.SUBLINKF AS SUBLINKF15,  GENHTAB_15.FLDSEARCH AS FLDSEARCH15, GENHTAB_15.FLDCRITERIA AS FLDCRITERIA15,GENHTAB_15.FLDENCRYPTF AS FLDENCRYPTF15
From
 COBEXT COB
 LEFT OUTER JOIN GENHTAB as GENHTAB_1 ON COB.FLDID1 = GENHTAB_1.FLDID
 LEFT OUTER JOIN GENHTAB as GENHTAB_2 ON COB.FLDID2 = GENHTAB_2.FLDID
 LEFT OUTER JOIN GENHTAB as GENHTAB_3 ON COB.FLDID3 = GENHTAB_3.FLDID
 LEFT OUTER JOIN GENHTAB as GENHTAB_4 ON COB.FLDID4 = GENHTAB_4.FLDID
 LEFT OUTER JOIN GENHTAB as GENHTAB_5 ON COB.FLDID5 = GENHTAB_5.FLDID
 LEFT OUTER JOIN GENHTAB as GENHTAB_6 ON COB.FLDID6 = GENHTAB_6.FLDID
 LEFT OUTER JOIN GENHTAB as GENHTAB_7 ON COB.FLDID7 = GENHTAB_7.FLDID
 LEFT OUTER JOIN GENHTAB as GENHTAB_8 ON COB.FLDID8 = GENHTAB_8.FLDID
 LEFT OUTER JOIN GENHTAB as GENHTAB_9 ON COB.FLDID9 = GENHTAB_9.FLDID
 LEFT OUTER JOIN GENHTAB as GENHTAB_10 ON COB.FLDID10 = GENHTAB_10.FLDID
 LEFT OUTER JOIN GENHTAB as GENHTAB_11 ON COB.FLDID11 = GENHTAB_11.FLDID
 LEFT OUTER JOIN GENHTAB as GENHTAB_12 ON COB.FLDID12 = GENHTAB_12.FLDID
 LEFT OUTER JOIN GENHTAB as GENHTAB_13 ON COB.FLDID13 = GENHTAB_13.FLDID
 LEFT OUTER JOIN GENHTAB as GENHTAB_14 ON COB.FLDID14 = GENHTAB_14.FLDID
 LEFT OUTER JOIN GENHTAB as GENHTAB_15 ON COB.FLDID15 = GENHTAB_15.FLDID
WHERE  COB.COB = @P_COB





GO

--2020 V.1.3.3
--20 MAY 2021: UPDATE CLAIM REVIEW SUPAYA RESULTNYA SAMA SEPERTI CLAIM APPROVAL

DROP PROCEDURE BALANCE_CLAASS
GO
CREATE PROCEDURE BALANCE_CLAASS(@P_CNO as Integer)
AS
SELECT CLAASS.*, F.CPDAYS
FROM CLAASS
INNER JOIN CLAIM on (CLAIM.CNO=CLAASS.CNO)
Left Join FPart F on (F.ANO=CLAIM.ANO and F.SlipNo=CLAASS.RefNo and F.ID=CLAASS.ID)      
WHERE CLAASS.CNO=@P_CNO AND CLAASS.CODE NOT IN ('F','D') AND CLAASS.CAMOUNT<>0



GO

--24 MAY 2021 : PENAMBAHAN FACULTATIVE DEPOSIT

IF EXISTS ( SELECT * FROM   sysobjects WHERE  id = object_id(N'QDEPOSIT_FACULTATIVE_CESSION') and OBJECTPROPERTY(id, N'IsProcedure') = 1 )
BEGIN
DROP Procedure QDEPOSIT_FACULTATIVE_CESSION 
END
GO
CREATE Procedure QDEPOSIT_FACULTATIVE_CESSION (@P_ANO integer, @P_RType varchar(255))     
AS                           
SELECT FPart.ID, RArrDet.RType, FPart.SlipNo, RArrDet.Share, FPart.Comm
From Acceptance       
Inner Join Cover on (Cover.CNO=Acceptance.CNO)      
Inner Join RArrDet on (RArrDet.ANO=Acceptance.ANO and RArrDet.RType=@P_RType and RArrDet.Status='R')      
Inner Join FPart on (FPart.ANO=RArrDet.ANO And FPart.FID=RArrDet.FID)
WHERE ACCEPTANCE.ANO=@P_ANO

GO

DROP Procedure QREINSURANCE_DEPOSIT
GO
CREATE Procedure QREINSURANCE_DEPOSIT(@P_LANO integer)                
as                
Select     
AccAss.Currency,
AccAss.ID, 
AccAss.Type as Type,
AccAss.RefNo as RefNo, 
sum(-AccAss.Amount) as Total_Deposit, 
Max(coalesce(RPart.Comm, FPart.Comm)) as Comm 
from Acceptance MA1     
Inner Join Acceptance MA2 on (MA2.OANO=MA1.OANO)    
Inner join AccAss on (AccAss.ANO=MA2.ANO)    
Left Join RPart on (Accass.Type in ('QS','QP') and RPart.DocNo=AccAss.RefNo and RPart.ID=AccAss.ID)
Left Join Reinsurance on (Reinsurance.RNO=RPart.RNO)
Left Join FPart on (AccAss.Type in ('FO') and FPart.ANO=AccAss.ANO and FPart.SlipNo=AccAss.RefNo and FPart.ID=AccAss.ID)
Left Join RArrDet on (RArrDet.ANO=FPart.ANO and RArrDet.FID=FPArt.FID)
Where MA1.ANO=@P_LANO and MA2.ANO<=@P_LANO and AccAss.DepositF=1 and AccAss.Type in ('QS','QP','FO')
Group by AccAss.Currency, AccAss.ID, AccAss.Type, AccAss.RefNo


GO

DROP Procedure QREINSURANCE_DEPOSIT_USAGE
GO
CREATE Procedure QREINSURANCE_DEPOSIT_USAGE(@P_ANO integer, @P_ID as varchar(10), @P_Currency varchar(10)='', @P_Type varchar(10)='', @P_RefNo varchar(50)='')                
as                
Select     
AccAss.Currency,     
sum(Case When AccAss.DepositF=0 Then -AccAss.Amount else 0 end) as Total_Premium,    
sum(Case When AccAss.DepositF=1 Then AccAss.Amount else 0 end) as Deposit_Usage   
from Acceptance A1    
Inner Join Acceptance MA1 on (MA1.ANO=A1.LANO)    
Inner Join Acceptance MA2 on (MA2.OANO=MA1.OANO AND MA2.ANO<=MA1.ANO)    
Inner Join Acceptance A2 on (A2.LANO=MA2.LANO and A2.ANO<>A2.LANO)    
Inner Join AccAss on (AccAss.ANO=A2.ANO)    
Where A1.ANO=@P_ANO and AccAss.ID=@P_ID and (A2.AStatus Not in ('W','T') or A2.ANO=@P_ANO)
and (@P_Currency='' or AccAss.Currency=@P_Currency) 
and (@P_Type='' or AccAss.Type=@P_Type) 
and (@P_RefNo='' or AccAss.RefNo=@P_RefNo)
Group by AccAss.Currency 
having round(sum(Case When AccAss.DepositF=0 Then -AccAss.Amount else 0 end),2)<>0 or round(sum(Case When AccAss.DepositF=1 Then AccAss.Amount else 0 end),2)<>0



GO

--25 MAY 2021 : PENAMBAHAN SEGMENT PADA INWARD TREATY
DROP Procedure QInwardTreaty_Data
GO
CREATE Procedure QInwardTreaty_Data(@P_ANO integer)            
as            
Select A1.CNO, A1.ANO, A1.RegNo, A1.Branch, A1.CT, A1.NCDate, C.Segment, C.CoverDate, C.Insured, C.ExpDate, A1.TOC, C.RefNo, C.RefDate, C.MO, R.Code, I.RType, I.ID, I.Share, I.Fee as RIComm, I.UJROHCEDANT, I.UJROHREINS,    
A1.CDate,    
A1.UserID,     
A1.LDate,    
A1.LUserID,    
A1.AUserID,    
A1.AUserDate,
A2.FLDID1, A2.VALUEID1, A2.VALUEDESC1, 0 as FLDSEARCH1,                
A2.FLDID2, A2.VALUEID2, A2.VALUEDESC2, 0 as FLDSEARCH2,                
A2.FLDID3, A2.VALUEID3, A2.VALUEDESC3, 0 as FLDSEARCH3,                
A2.FLDID4, A2.VALUEID4, A2.VALUEDESC4, 0 as FLDSEARCH4,                
A2.FLDID5, A2.VALUEID5, A2.VALUEDESC5, 0 as FLDSEARCH5,                
A2.FLDID6, A2.VALUEID6, A2.VALUEDESC6, 0 as FLDSEARCH6,                
A2.FLDID7, A2.VALUEID7, A2.VALUEDESC7, 0 as FLDSEARCH7,                
A2.FLDID8, A2.VALUEID8, A2.VALUEDESC8, 0 as FLDSEARCH8,                
A2.FLDID9, A2.VALUEID9, A2.VALUEDESC9, 0 as FLDSEARCH9,                
A2.FLDID10, A2.VALUEID10, A2.VALUEDESC10, 0 as FLDSEARCH10,                
A2.FLDID11, A2.VALUEID11, A2.VALUEDESC11, 0 as FLDSEARCH11,                
A2.FLDID12, A2.VALUEID12, A2.VALUEDESC12, 0 as FLDSEARCH12,                
A2.FLDID13, A2.VALUEID13, A2.VALUEDESC13, 0 as FLDSEARCH13,                
A2.FLDID14, A2.VALUEID14, A2.VALUEDESC14, 0 as FLDSEARCH14,                
A2.FLDID15, A2.VALUEID15, A2.VALUEDESC15, 0 as FLDSEARCH15,
A3.ID as BSID, A3.Fee as BSFee, A4.ID as OtherID, A4.Fee as OtherFee
from Cover C    
Inner Join Acceptance A1 on (C.CNO=A1.CNO)    
Left Join AINFO A2 On (A2.ANO=A1.ANO) 
Left join ISource I on (I.CNO=C.CNO)    
Left Join RCover R On (R.ANO=A1.ANO)    
Left Join AccBS A3 on (A3.ANO=A1.ANO and A3.BSType='B')    
Left Join AccBS A4 on (A4.ANO=A1.ANO and A4.BSType='O')    
Where A1.ANO=@P_ANO    
GO

--25 MAY 2021 (1) : PENAMBAHAN APPROVAL LIMIT FA BERDASARKAN VOUCHER TYPE
/* To prevent any potential data loss issues, you should review this script in detail before running it outside the context of the database designer.*/

SET QUOTED_IDENTIFIER ON
SET ARITHABORT ON
SET NUMERIC_ROUNDABORT OFF
SET CONCAT_NULL_YIELDS_NULL ON
SET ANSI_NULLS ON
SET ANSI_PADDING ON
SET ANSI_WARNINGS ON


GO
IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'LimitIn' AND Object_ID = Object_ID(N'SysUserVType'))
BEGIN
ALTER TABLE SysUserVType ADD
	LimitIn float(53) NULL
DECLARE @v sql_variant 
SET @v = N'Max. Limit Amount In'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'SysUserVType', N'COLUMN', N'LimitIn'
END
GO

IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'LimitOut' AND Object_ID = Object_ID(N'SysUserVType'))
BEGIN
ALTER TABLE dbo.SysUserVType ADD
	LimitOut float(53) NULL
DECLARE @v sql_variant 
SET @v = N'Max. Limit Amount Out'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'SysUserVType', N'COLUMN', N'LimitOut'
END
GO
GO



GO

if exists (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'GetApprovalLimitFA') AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) )
BEGIN
DROP Function GetApprovalLimitFA
END
GO
CREATE Function GetApprovalLimitFA(@UserID varchar(50), @VType varchar(10), @InOut varchar(10))
RETURNS Float AS        
BEGIN      
	Declare @LimitIn as Float
	Declare @LimitOut as Float

	Declare @tempLimitIn as Float
	Declare @tempLimitOut as Float
	Declare @ApprovalLimit as Float

	Declare @PDate as smalldatetime

	Select @PDate=cast(year(getdate()) as varchar(4))+'/'+right('0'+cast(Month(getdate()) as varchar(4)),2)+'/'+right('0'+cast(Day(getdate()) as varchar(4)),2)

	select 
	@LimitIn=Case When S1.LimitIn<>0 then S1.LimitIn else S2.LimitIn end,
	@LimitOut=Case When S1.LimitOut<>0 then S1.LimitOut else S2.LimitOut end 
	from sysuser S1
	Inner Join SysUserType S2 on (S2.Type=S1.Type)
	where S1.ID=@UserID
    

	if @VType<>''
	Begin
		Select Top 1 @tempLimitIn=LimitIn, @tempLimitOut=LimitOut 
		from SysUserVType 
		Where ID=@UserID and VType=@VType
		if @tempLimitIn<>0 
			Select @LimitIn=@TempLimitIn

		if @tempLimitOut<>0 
			Select @LimitOut=@tempLimitOut
	End

	if @InOut='IN'
		Select @ApprovalLimit=@LimitIn
	else
		Select @ApprovalLimit=@LimitOut

	return @ApprovalLimit
END        
GO

--31 MAY 2021 : PENYESUAIAN DENGAN MIDDLEWARE
DROP PROCEDURE QTOC_GENHTAB 
GO
CREATE PROCEDURE QTOC_GENHTAB (@P_TOC AS VARCHAR(10))       
AS       
SELECT  TOP 1       
TOC.TOC, TOC.DESCRIPTION, TOC.ANNUALTREATYF, TOC.NORISKACCUMULATIONF, TOC.ObjectRestrictionF, TOC.BlanketTypeVer, TOC.IACCREG, TOC.REGID, TOC.LBL_PHOLDER, TOC.LBL_AID, TOC.EXCLUSIVEF, TOC.VOYAGE, TOC.PTERM, TOC.PRORATA, 
TOC.FLDID1, TOC.FLDTAG1, TOC.FLDTAGA1, GENHTAB_1.FLDTAB AS FLDTAB1, GENHTAB_1.FLDCOM AS FLDCOM1, GENHTAB_1.FLDCOMA AS FLDCOMA1, GENHTAB_1.FLDDFORMAT AS FLDDFORMAT1, GENHTAB_1.FLDIFORMAT AS FLDIFORMAT1, GENHTAB_1.FLDTYPE AS FLDTYPE1, GENHTAB_1.SUBLINKF AS SUBLINKF1,  GENHTAB_1.FLDSEARCH AS FLDSEARCH1, GENHTAB_1.FLDCRITERIA AS FLDCRITERIA1, GENHTAB_1.FLDCHGINF as FLDCHGINF1, GENHTAB_1.FLDLOWER as FLDLOWER1, GENHTAB_1.FLDUPPER as FLDUPPER1, GENHTAB_1.FLDREGEX as FLDREGEX1, GENHTAB_1.FLDMAP as FLDMAP1,
TOC.FLDID2, TOC.FLDTAG2, TOC.FLDTAGA2, GENHTAB_2.FLDTAB AS FLDTAB2, GENHTAB_2.FLDCOM AS FLDCOM2, GENHTAB_2.FLDCOMA AS FLDCOMA2, GENHTAB_2.FLDDFORMAT AS FLDDFORMAT2, GENHTAB_2.FLDIFORMAT AS FLDIFORMAT2, GENHTAB_2.FLDTYPE AS FLDTYPE2, GENHTAB_2.SUBLINKF AS SUBLINKF2,  GENHTAB_2.FLDSEARCH AS FLDSEARCH2, GENHTAB_2.FLDCRITERIA AS FLDCRITERIA2, GENHTAB_2.FLDCHGINF as FLDCHGINF2, GENHTAB_2.FLDLOWER as FLDLOWER2, GENHTAB_2.FLDUPPER as FLDUPPER2, GENHTAB_2.FLDREGEX as FLDREGEX2, GENHTAB_2.FLDMAP as FLDMAP2,
TOC.FLDID3, TOC.FLDTAG3, TOC.FLDTAGA3, GENHTAB_3.FLDTAB AS FLDTAB3, GENHTAB_3.FLDCOM AS FLDCOM3, GENHTAB_3.FLDCOMA AS FLDCOMA3, GENHTAB_3.FLDDFORMAT AS FLDDFORMAT3, GENHTAB_3.FLDIFORMAT AS FLDIFORMAT3, GENHTAB_3.FLDTYPE AS FLDTYPE3, GENHTAB_3.SUBLINKF AS SUBLINKF3,  GENHTAB_3.FLDSEARCH AS FLDSEARCH3, GENHTAB_3.FLDCRITERIA AS FLDCRITERIA3, GENHTAB_3.FLDCHGINF as FLDCHGINF3, GENHTAB_3.FLDLOWER as FLDLOWER3, GENHTAB_3.FLDUPPER as FLDUPPER3, GENHTAB_3.FLDREGEX as FLDREGEX3, GENHTAB_3.FLDMAP as FLDMAP3, 
TOC.FLDID4, TOC.FLDTAG4, TOC.FLDTAGA4, GENHTAB_4.FLDTAB AS FLDTAB4, GENHTAB_4.FLDCOM AS FLDCOM4, GENHTAB_4.FLDCOMA AS FLDCOMA4, GENHTAB_4.FLDDFORMAT AS FLDDFORMAT4, GENHTAB_4.FLDIFORMAT AS FLDIFORMAT4, GENHTAB_4.FLDTYPE AS FLDTYPE4, GENHTAB_4.SUBLINKF AS SUBLINKF4,  GENHTAB_4.FLDSEARCH AS FLDSEARCH4, GENHTAB_4.FLDCRITERIA AS FLDCRITERIA4, GENHTAB_4.FLDCHGINF as FLDCHGINF4, GENHTAB_4.FLDLOWER as FLDLOWER4, GENHTAB_4.FLDUPPER as FLDUPPER4, GENHTAB_4.FLDREGEX as FLDREGEX4, GENHTAB_4.FLDMAP as FLDMAP4,
TOC.FLDID5, TOC.FLDTAG5, TOC.FLDTAGA5, GENHTAB_5.FLDTAB AS FLDTAB5, GENHTAB_5.FLDCOM AS FLDCOM5, GENHTAB_5.FLDCOMA AS FLDCOMA5, GENHTAB_5.FLDDFORMAT AS FLDDFORMAT5, GENHTAB_5.FLDIFORMAT AS FLDIFORMAT5, GENHTAB_5.FLDTYPE AS FLDTYPE5, GENHTAB_5.SUBLINKF AS SUBLINKF5,  GENHTAB_5.FLDSEARCH AS FLDSEARCH5, GENHTAB_5.FLDCRITERIA AS FLDCRITERIA5, GENHTAB_5.FLDCHGINF as FLDCHGINF5, GENHTAB_5.FLDLOWER as FLDLOWER5, GENHTAB_5.FLDUPPER as FLDUPPER5, GENHTAB_5.FLDREGEX as FLDREGEX5, GENHTAB_5.FLDMAP as FLDMAP5,
TOC.FLDID6, TOC.FLDTAG6, TOC.FLDTAGA6, GENHTAB_6.FLDTAB AS FLDTAB6, GENHTAB_6.FLDCOM AS FLDCOM6, GENHTAB_6.FLDCOMA AS FLDCOMA6, GENHTAB_6.FLDDFORMAT AS FLDDFORMAT6, GENHTAB_6.FLDIFORMAT AS FLDIFORMAT6, GENHTAB_6.FLDTYPE AS FLDTYPE6, GENHTAB_6.SUBLINKF AS SUBLINKF6,  GENHTAB_6.FLDSEARCH AS FLDSEARCH6, GENHTAB_6.FLDCRITERIA AS FLDCRITERIA6, GENHTAB_6.FLDCHGINF as FLDCHGINF6, GENHTAB_6.FLDLOWER as FLDLOWER6, GENHTAB_6.FLDUPPER as FLDUPPER6, GENHTAB_6.FLDREGEX as FLDREGEX6, GENHTAB_6.FLDMAP as FLDMAP6,
TOC.FLDID7, TOC.FLDTAG7, TOC.FLDTAGA7, GENHTAB_7.FLDTAB AS FLDTAB7, GENHTAB_7.FLDCOM AS FLDCOM7, GENHTAB_7.FLDCOMA AS FLDCOMA7, GENHTAB_7.FLDDFORMAT AS FLDDFORMAT7, GENHTAB_7.FLDIFORMAT AS FLDIFORMAT7, GENHTAB_7.FLDTYPE AS FLDTYPE7, GENHTAB_7.SUBLINKF AS SUBLINKF7,  GENHTAB_7.FLDSEARCH AS FLDSEARCH7, GENHTAB_7.FLDCRITERIA AS FLDCRITERIA7, GENHTAB_7.FLDCHGINF as FLDCHGINF7, GENHTAB_7.FLDLOWER as FLDLOWER7, GENHTAB_7.FLDUPPER as FLDUPPER7, GENHTAB_7.FLDREGEX as FLDREGEX7, GENHTAB_7.FLDMAP as FLDMAP7,
TOC.FLDID8, TOC.FLDTAG8, TOC.FLDTAGA8, GENHTAB_8.FLDTAB AS FLDTAB8, GENHTAB_8.FLDCOM AS FLDCOM8, GENHTAB_8.FLDCOMA AS FLDCOMA8, GENHTAB_8.FLDDFORMAT AS FLDDFORMAT8, GENHTAB_8.FLDIFORMAT AS FLDIFORMAT8, GENHTAB_8.FLDTYPE AS FLDTYPE8, GENHTAB_8.SUBLINKF AS SUBLINKF8,  GENHTAB_8.FLDSEARCH AS FLDSEARCH8, GENHTAB_8.FLDCRITERIA AS FLDCRITERIA8, GENHTAB_8.FLDCHGINF as FLDCHGINF8, GENHTAB_8.FLDLOWER as FLDLOWER8, GENHTAB_8.FLDUPPER as FLDUPPER8, GENHTAB_8.FLDREGEX as FLDREGEX8, GENHTAB_8.FLDMAP as FLDMAP8,
TOC.FLDID9, TOC.FLDTAG9, TOC.FLDTAGA9, GENHTAB_9.FLDTAB AS FLDTAB9, GENHTAB_9.FLDCOM AS FLDCOM9, GENHTAB_9.FLDCOMA AS FLDCOMA9, GENHTAB_9.FLDDFORMAT AS FLDDFORMAT9, GENHTAB_9.FLDIFORMAT AS FLDIFORMAT9, GENHTAB_9.FLDTYPE AS FLDTYPE9, GENHTAB_9.SUBLINKF AS SUBLINKF9,  GENHTAB_9.FLDSEARCH AS FLDSEARCH9, GENHTAB_9.FLDCRITERIA AS FLDCRITERIA9, GENHTAB_9.FLDCHGINF as FLDCHGINF9, GENHTAB_9.FLDLOWER as FLDLOWER9, GENHTAB_9.FLDUPPER as FLDUPPER9, GENHTAB_9.FLDREGEX as FLDREGEX9, GENHTAB_9.FLDMAP as FLDMAP9,
TOC.FLDID10, TOC.FLDTAG10, TOC.FLDTAGA10, GENHTAB_10.FLDTAB AS FLDTAB10, GENHTAB_10.FLDCOM AS FLDCOM10, GENHTAB_10.FLDCOMA AS FLDCOMA10, GENHTAB_10.FLDDFORMAT AS FLDDFORMAT10, GENHTAB_10.FLDIFORMAT AS FLDIFORMAT10, GENHTAB_10.FLDTYPE AS FLDTYPE10, GENHTAB_10.SUBLINKF AS SUBLINKF10,  GENHTAB_10.FLDSEARCH AS FLDSEARCH10, GENHTAB_10.FLDCRITERIA AS FLDCRITERIA10, GENHTAB_10.FLDCHGINF as FLDCHGINF10, GENHTAB_10.FLDLOWER as FLDLOWER10, GENHTAB_10.FLDUPPER as FLDUPPER10, GENHTAB_10.FLDREGEX as FLDREGEX10, GENHTAB_10.FLDMAP as FLDMAP10, 
TOC.FLDID11, TOC.FLDTAG11, TOC.FLDTAGA11, GENHTAB_11.FLDTAB AS FLDTAB11, GENHTAB_11.FLDCOM AS FLDCOM11, GENHTAB_11.FLDCOMA AS FLDCOMA11, GENHTAB_11.FLDDFORMAT AS FLDDFORMAT11, GENHTAB_11.FLDIFORMAT AS FLDIFORMAT11, GENHTAB_11.FLDTYPE AS FLDTYPE11, GENHTAB_11.SUBLINKF AS SUBLINKF11,  GENHTAB_11.FLDSEARCH AS FLDSEARCH11, GENHTAB_11.FLDCRITERIA AS FLDCRITERIA11, GENHTAB_11.FLDCHGINF as FLDCHGINF11, GENHTAB_11.FLDLOWER as FLDLOWER11, GENHTAB_11.FLDUPPER as FLDUPPER11, GENHTAB_11.FLDREGEX as FLDREGEX11, GENHTAB_11.FLDMAP as FLDMAP11,
TOC.FLDID12, TOC.FLDTAG12, TOC.FLDTAGA12, GENHTAB_12.FLDTAB AS FLDTAB12, GENHTAB_12.FLDCOM AS FLDCOM12, GENHTAB_12.FLDCOMA AS FLDCOMA12, GENHTAB_12.FLDDFORMAT AS FLDDFORMAT12, GENHTAB_12.FLDIFORMAT AS FLDIFORMAT12, GENHTAB_12.FLDTYPE AS FLDTYPE12, GENHTAB_12.SUBLINKF AS SUBLINKF12,  GENHTAB_12.FLDSEARCH AS FLDSEARCH12, GENHTAB_12.FLDCRITERIA AS FLDCRITERIA12, GENHTAB_12.FLDCHGINF as FLDCHGINF12, GENHTAB_12.FLDLOWER as FLDLOWER12, GENHTAB_12.FLDUPPER as FLDUPPER12, GENHTAB_12.FLDREGEX as FLDREGEX12, GENHTAB_12.FLDMAP as FLDMAP12,
TOC.FLDID13, TOC.FLDTAG13, TOC.FLDTAGA13, GENHTAB_13.FLDTAB AS FLDTAB13, GENHTAB_13.FLDCOM AS FLDCOM13, GENHTAB_13.FLDCOMA AS FLDCOMA13, GENHTAB_13.FLDDFORMAT AS FLDDFORMAT13, GENHTAB_13.FLDIFORMAT AS FLDIFORMAT13, GENHTAB_13.FLDTYPE AS FLDTYPE13, GENHTAB_13.SUBLINKF AS SUBLINKF13,  GENHTAB_13.FLDSEARCH AS FLDSEARCH13, GENHTAB_13.FLDCRITERIA AS FLDCRITERIA13, GENHTAB_13.FLDCHGINF as FLDCHGINF13, GENHTAB_13.FLDLOWER as FLDLOWER13, GENHTAB_13.FLDUPPER as FLDUPPER13, GENHTAB_13.FLDREGEX as FLDREGEX13, GENHTAB_13.FLDMAP as FLDMAP13,
TOC.FLDID14, TOC.FLDTAG14, TOC.FLDTAGA14, GENHTAB_14.FLDTAB AS FLDTAB14, GENHTAB_14.FLDCOM AS FLDCOM14, GENHTAB_14.FLDCOMA AS FLDCOMA14, GENHTAB_14.FLDDFORMAT AS FLDDFORMAT14, GENHTAB_14.FLDIFORMAT AS FLDIFORMAT14, GENHTAB_14.FLDTYPE AS FLDTYPE14, GENHTAB_14.SUBLINKF AS SUBLINKF14,  GENHTAB_14.FLDSEARCH AS FLDSEARCH14, GENHTAB_14.FLDCRITERIA AS FLDCRITERIA14, GENHTAB_14.FLDCHGINF as FLDCHGINF14, GENHTAB_14.FLDLOWER as FLDLOWER14, GENHTAB_14.FLDUPPER as FLDUPPER14, GENHTAB_14.FLDREGEX as FLDREGEX14, GENHTAB_14.FLDMAP as FLDMAP14,
TOC.FLDID15, TOC.FLDTAG15, TOC.FLDTAGA15, GENHTAB_15.FLDTAB AS FLDTAB15, GENHTAB_15.FLDCOM AS FLDCOM15, GENHTAB_15.FLDCOMA AS FLDCOMA15, GENHTAB_15.FLDDFORMAT AS FLDDFORMAT15, GENHTAB_15.FLDIFORMAT AS FLDIFORMAT15, GENHTAB_15.FLDTYPE AS FLDTYPE15, GENHTAB_15.SUBLINKF AS SUBLINKF15,  GENHTAB_15.FLDSEARCH AS FLDSEARCH15, GENHTAB_15.FLDCRITERIA AS FLDCRITERIA15, GENHTAB_15.FLDCHGINF as FLDCHGINF15, GENHTAB_15.FLDLOWER as FLDLOWER15, GENHTAB_15.FLDUPPER as FLDUPPER15, GENHTAB_15.FLDREGEX as FLDREGEX15, GENHTAB_15.FLDMAP as FLDMAP15
FROM       
TOC       
LEFT OUTER JOIN GENHTAB as GENHTAB_1 ON TOC.FLDID1<>'' AND TOC.FLDID1 = GENHTAB_1.FLDID       
LEFT OUTER JOIN GENHTAB as GENHTAB_2 ON TOC.FLDID2<>'' AND TOC.FLDID2 = GENHTAB_2.FLDID       
LEFT OUTER JOIN GENHTAB as GENHTAB_3 ON TOC.FLDID3<>'' AND TOC.FLDID3 = GENHTAB_3.FLDID       
LEFT OUTER JOIN GENHTAB as GENHTAB_4 ON TOC.FLDID4<>'' AND TOC.FLDID4 = GENHTAB_4.FLDID       
LEFT OUTER JOIN GENHTAB as GENHTAB_5 ON TOC.FLDID5<>'' AND TOC.FLDID5 = GENHTAB_5.FLDID       
LEFT OUTER JOIN GENHTAB as GENHTAB_6 ON TOC.FLDID6<>'' AND TOC.FLDID6 = GENHTAB_6.FLDID       
LEFT OUTER JOIN GENHTAB as GENHTAB_7 ON TOC.FLDID7<>'' AND TOC.FLDID7 = GENHTAB_7.FLDID       
LEFT OUTER JOIN GENHTAB as GENHTAB_8 ON TOC.FLDID8<>'' AND TOC.FLDID8 = GENHTAB_8.FLDID       
LEFT OUTER JOIN GENHTAB as GENHTAB_9 ON TOC.FLDID9<>'' AND TOC.FLDID9 = GENHTAB_9.FLDID       
LEFT OUTER JOIN GENHTAB as GENHTAB_10 ON TOC.FLDID10<>'' AND TOC.FLDID10 = GENHTAB_10.FLDID       
LEFT OUTER JOIN GENHTAB as GENHTAB_11 ON TOC.FLDID11<>'' AND TOC.FLDID11 = GENHTAB_11.FLDID       
LEFT OUTER JOIN GENHTAB as GENHTAB_12 ON TOC.FLDID12<>'' AND TOC.FLDID12 = GENHTAB_12.FLDID       
LEFT OUTER JOIN GENHTAB as GENHTAB_13 ON TOC.FLDID13<>'' AND TOC.FLDID13 = GENHTAB_13.FLDID       
LEFT OUTER JOIN GENHTAB as GENHTAB_14 ON TOC.FLDID14<>'' AND TOC.FLDID14 = GENHTAB_14.FLDID       
LEFT OUTER JOIN GENHTAB as GENHTAB_15 ON TOC.FLDID15<>'' AND TOC.FLDID15 = GENHTAB_15.FLDID       
WHERE  TOC.TOC = @P_TOC 

GO
IF EXISTS ( SELECT * FROM   sysobjects WHERE  id = object_id(N'GetObjectRestrictionByObjectInfo') and OBJECTPROPERTY(id, N'IsProcedure') = 1 )
BEGIN
DROP PROCEDURE  GetObjectRestrictionByObjectInfo
END
GO
CREATE PROCEDURE  GetObjectRestrictionByObjectInfo(  
@P_TOC as varchar(10),  
@P_VALUEID1 as varchar(15),  
@P_VALUEID2 as varchar(15),  
@P_VALUEID3 as varchar(15),  
@P_VALUEID4 as varchar(15),  
@P_VALUEID5 as varchar(15),  
@P_VALUEID6 as varchar(15),  
@P_VALUEID7 as varchar(15),  
@P_VALUEID8 as varchar(15),  
@P_VALUEID9 as varchar(15),  
@P_VALUEID10 as varchar(15),  
@P_VALUEID11 as varchar(15),  
@P_VALUEID12 as varchar(15),  
@P_VALUEID13 as varchar(15),  
@P_VALUEID14 as varchar(15),  
@P_VALUEID15 as varchar(15)  
)       
as   
Select top 1 ObjectRegister.RestrictedF
from ObjectRegister
WHERE ObjectRegister.TOC=@P_TOC
And ((ObjectRegister.ValueID1='' and @P_VALUEID1 Like ObjectRegister.ValueDesc1+'%') or (ObjectRegister.ValueID1<>'' and @P_VALUEID1 Like ObjectRegister.ValueID1+'%') or (ObjectRegister.ValueID1 is null))                    
And ((ObjectRegister.ValueID2='' and @P_VALUEID2 Like ObjectRegister.ValueDesc2+'%') or (ObjectRegister.ValueID2<>'' and @P_VALUEID2 Like ObjectRegister.ValueID2+'%') or (ObjectRegister.ValueID2 is null))                    
And ((ObjectRegister.ValueID3='' and @P_VALUEID3 Like ObjectRegister.ValueDesc3+'%') or (ObjectRegister.ValueID3<>'' and @P_VALUEID3 Like ObjectRegister.ValueID3+'%') or (ObjectRegister.ValueID3 is null))                    
And ((ObjectRegister.ValueID4='' and @P_VALUEID4 Like ObjectRegister.ValueDesc4+'%') or (ObjectRegister.ValueID4<>'' and @P_VALUEID4 Like ObjectRegister.ValueID4+'%') or (ObjectRegister.ValueID4 is null))                    
And ((ObjectRegister.ValueID5='' and @P_VALUEID5 Like ObjectRegister.ValueDesc5+'%') or (ObjectRegister.ValueID5<>'' and @P_VALUEID5 Like ObjectRegister.ValueID5+'%') or (ObjectRegister.ValueID5 is null))                    
And ((ObjectRegister.ValueID6='' and @P_VALUEID6 Like ObjectRegister.ValueDesc6+'%') or (ObjectRegister.ValueID6<>'' and @P_VALUEID6 Like ObjectRegister.ValueID6+'%') or (ObjectRegister.ValueID6 is null))                    
And ((ObjectRegister.ValueID7='' and @P_VALUEID7 Like ObjectRegister.ValueDesc7+'%') or (ObjectRegister.ValueID7<>'' and @P_VALUEID7 Like ObjectRegister.ValueID7+'%') or (ObjectRegister.ValueID7 is null))                    
And ((ObjectRegister.ValueID8='' and @P_VALUEID8 Like ObjectRegister.ValueDesc8+'%') or (ObjectRegister.ValueID8<>'' and @P_VALUEID8 Like ObjectRegister.ValueID8+'%') or (ObjectRegister.ValueID8 is null))                    
And ((ObjectRegister.ValueID9='' and @P_VALUEID9 Like ObjectRegister.ValueDesc9+'%') or (ObjectRegister.ValueID9<>'' and @P_VALUEID9 Like ObjectRegister.ValueID9+'%') or (ObjectRegister.ValueID9 is null))                    
And ((ObjectRegister.ValueID10='' and @P_VALUEID10 Like ObjectRegister.ValueDesc10+'%') or (ObjectRegister.ValueID10<>'' and @P_VALUEID10 Like ObjectRegister.ValueID10+'%') or (ObjectRegister.ValueID10 is null))                    
And ((ObjectRegister.ValueID11='' and @P_VALUEID11 Like ObjectRegister.ValueDesc11+'%') or (ObjectRegister.ValueID11<>'' and @P_VALUEID11 Like ObjectRegister.ValueID11+'%') or (ObjectRegister.ValueID11 is null))                    
And ((ObjectRegister.ValueID12='' and @P_VALUEID12 Like ObjectRegister.ValueDesc12+'%') or (ObjectRegister.ValueID12<>'' and @P_VALUEID12 Like ObjectRegister.ValueID12+'%') or (ObjectRegister.ValueID12 is null))                    
And ((ObjectRegister.ValueID13='' and @P_VALUEID13 Like ObjectRegister.ValueDesc13+'%') or (ObjectRegister.ValueID13<>'' and @P_VALUEID13 Like ObjectRegister.ValueID13+'%') or (ObjectRegister.ValueID13 is null))                    
And ((ObjectRegister.ValueID14='' and @P_VALUEID14 Like ObjectRegister.ValueDesc14+'%') or (ObjectRegister.ValueID14<>'' and @P_VALUEID14 Like ObjectRegister.ValueID14+'%') or (ObjectRegister.ValueID14 is null))     
And ((ObjectRegister.ValueID15='' and @P_VALUEID15 Like ObjectRegister.ValueDesc15+'%') or (ObjectRegister.ValueID15<>'' and @P_VALUEID15 Like ObjectRegister.ValueID15+'%') or (ObjectRegister.ValueID15 is null))      


GO


--8 JUN 2021 : PENAMBAHAN KOLOM CURRENCY UNTUK Pemilihan Fee Duty dan Currency
if exists (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'FN_Currency') AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) )
BEGIN
DROP Function FN_Currency
END
GO
Create Function FN_Currency(@P_ANO as integer)
RETURNS Table 
AS RETURN ( 
Select Currency.Currency, Currency.Description
from Currency 
Inner Join SysTab on (1=1)
Left Join (Select Distinct ANO, Currency from ICover Where ANO=@P_ANO) ICover on (ICover.ANO=@P_ANO)
Where Currency.AllowedF=1 
and ((coalesce(ICover.ANO,0)=0 and Currency.Currency=SysTab.Currency) or Currency.Currency=ICover.Currency)
) 

GO


--VERSIONING
alter table versioning alter column vernoapp varchar(50)
go
alter table versioning alter column vernows varchar(50)
go
alter table versioning alter column vernoproclib varchar(50)
go
insert into versioning
select '2020 V.1.3.3',GETDATE(),'2020 V.1.3.3',GETDATE(),'K: 2020 V.1.3.3',GETDATE()
go



Declare @PrevScript varchar(100)
Declare @CurrScript varchar(100)

Select @PrevScript=''
Select @CurrSCript='58 Script Komulatif Konsol 2020 V.1.3'


Declare @ExecScript varchar(100)
Declare @ExecScriptStatus varchar(100)
Declare @Error varchar(200)

Select @Error=''

Begin 
       Select @ExecScript=Execscript,  @ExecScriptStatus=ExecScriptStatus from systab 
      if @PrevScript<>'' and @ExecSCript<>@PrevScript
              --THROW 51000, 'Not the Next Sequence Script', 1;
			  RAISERROR('Not the Next Sequence Script',16,1)
       else 
              if @ExecScriptStatus<>'' and @ExecScriptStatus<>'DONE'
              --THROW 51000, 'Pending Script Execution', 1;
			  RAISERROR('Pending Script Execution',16,1)

       Update SysTab Set ExecScript=@CurrScript, ExecScriptStatus='PENDING'             
       
       BEGIN TRY            
			PRINT '--EXECUTE DONE--'
       END TRY  
       BEGIN CATCH  
       END CATCH;


       Update SysTab Set ExecScript=@CurrScript, ExecScriptStatus='DONE'         
End
