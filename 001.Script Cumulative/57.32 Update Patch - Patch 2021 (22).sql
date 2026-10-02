insert into PatchVersioning
select 'Update Patch - Patch 2021 (22)',GETDATE()
go

Declare @PrevScript varchar(100)
Declare @CurrScript varchar(100)

Select @PrevScript=''
Select @CurrSCript='Update Patch - Patch 2021 (22)'


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
			DROP Procedure BALANCE_ACCASS_ADJUSTMENT
			DROP FUNCTION PREMIUM_CALCULATION
       END TRY  
       BEGIN CATCH  
       END CATCH;


       Update SysTab Set ExecScript=@CurrScript, ExecScriptStatus='DONE'         
End


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
        

