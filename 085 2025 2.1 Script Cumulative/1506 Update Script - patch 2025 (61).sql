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
	Select T.ANO, T.Code, T.SDate, T.EDate, T.Currency,   
	sum(T.Premium-Case When T.NoRefundF=7 Then T.Premium*coalesce(T1.Commission,0)/100 else 0 end) as Premium,           
	sum(Case When T.NoRefundF=7 Then 0 else T.Premium*coalesce(T1.Commission,0)/100 end) as Commission,           
	sum(T.Premium*dbo.Premium_Discount(T.CANO,Code,PolicyYear)/100) as Discount,           
	sum(Case When T.NoRefundF=7 Then 0 else T.Premium*coalesce(T1.VAT,0)/100 end) as Vat,           
	sum(Case When T.NoRefundF=7 Then 0 else -T.Premium*coalesce(T1.TAX,0)/100 end) as Tax,           
	cast(0 as Float) as FeeDuty      
	
	from PREMIUM_CALCULATION_BASE(@P_ANO) T           
	Outer Apply (
		Select 
		sum(Case When coalesce(T2.NoRefundF, T1.NoRefundF)=0 Then T1.Commission else 0 end) as Commission,
		sum(
			Case 
			When coalesce(T2.NoRefundF, T1.NoRefundF)=0 Then 
				T1.Commission 
				*(Case When (Case When (coalesce(Profile.VATESDate,'01/01/1900')<= A.ADate and coalesce(Profile.VatEEDate,'01/01/1900')>= A.ADate) Then cast(0 as Bit) else Profile.VatF end)=1 Then (case when A.ADate<MParam.Effective then MParam.VatOLD else MParam.Vat end)/100 else 0 end)   
				*(Case   
					When SysTab.TaxMethod in (3) Then  
						case When RateTab.VATCommissionF=1 and (Case When Cover.ISType not in ('T','R') or Profile.VATCOMMEXEMPTIF=0 Then cast(1 as Bit) Else 0 END)=1 then 1 else 0 end    	
					Else
						1
				 End) 
			else 0 
			end) as VAT,
		sum(
			Case 
			When coalesce(T2.NoRefundF, T1.NoRefundF)=0 Then 
				T1.Commission 
				*(Case When (Case When (coalesce(Profile.TaxHSDate,'01/01/1900')<= A.ADate and coalesce(Profile.TaxHEDate,'01/01/1900')>= A.ADate) Then cast(0 as Bit) else Profile.TaxF end)=1 Then (Case When TaxType.MTaxType='PASAL21' then MParam.Pasal21*(100-MParam.TaxDiscount)/100 When TaxType.MTaxType='PASAL23' then MParam.Pasal23 When TaxType.MTaxType='PASAL26' then MParam.Pasal26 When TaxType.MTaxType='PASAL4' then MParam.Pasal4 else TaxType.TaxRate end)/100*(Case When Profile.TaxPCT=0 Then 1 else TaxPCT/100 end) else 0 end)    
			else 0 
			end) as TAX
		from Premium_Commission_Table(T.CANO,T.Code,T.PolicyYear,T.MinimumPremiumF) T1
		Left Join Premium_Commission_Table(@P_ANO,T.Code,T.PolicyYear,T.MinimumPremiumF) T2 on (T2.ID=T1.ID and T2.OBSType=T1.BSType)
		Inner Join Acceptance A on (A.ANO=@P_ANO)
		Inner Join MParam on (MParam.Type='B'+T1.BSType)
		Inner Join Profile on (Profile.ID=T1.ID)
		Inner Join RateTab on (RateTab.Code=T.Code)
		Inner Join SysTab on (1=1)
		Inner Join Cover on (Cover.CNO=T.CNO)
		Left Join TaxType on (TaxType.TaxType=Profile.TaxType)
	) T1
	Group By T.ANO, T.Code, T.SDate, T.EDate, T.Currency          

	Union All                  
                                 
	select A3.ANO, AccAss.RCode as Code, AccAss.SDate, AccAss.EDate, AccAss.Currency_OC as Currency,                  
	sum(Case When AccAss.Code in ('P','U') then (Case When A3.AType='A' and AccAss.AdjMethod='OVERLIMIT' then -AccAss.CAmount*(Case When A3.CPCT<>0 Then A3.CPCT/100 else 1 end)/(Case When AccAss.PProrata<>0 Then AccAss.PProrata else 1 end) else -AccAss.Amount_OC end)*(Case When AccAss.Type='DI' then 100/(100-coalesce(Coinsurance.MShare,0)) else 1 end) else 0 end) as Premium,                  
	sum(Case When AccAss.Code='C' then (Case When A3.AType='A' and AccAss.AdjMethod='OVERLIMIT' then AccAss.CAmount*(Case When A3.CPCT<>0 Then A3.CPCT/100 else 1 end)/(Case When AccAss.PProrata<>0 Then AccAss.PProrata else 1 end) else AccAss.Amount_OC end)*(Case When AccAss.Type='DI' then 100/(100-coalesce(Coinsurance.MShare,0)) else 1 end) else 0 end) as Commission,                  
	sum(Case When AccAss.Code='O' then (Case When A3.AType='A' and AccAss.AdjMethod='OVERLIMIT' then AccAss.CAmount*(Case When A3.CPCT<>0 Then A3.CPCT/100 else 1 end)/(Case When AccAss.PProrata<>0 Then AccAss.PProrata else 1 end) else AccAss.Amount_OC end)*(Case When AccAss.Type='DI' then 100/(100-coalesce(Coinsurance.MShare,0)) else 1 end) else 0 end) as Discount,                  
	sum((Case When A3.AType='A' and AccAss.AdjMethod='OVERLIMIT' then AccAss.CAmount*(Case When A3.CPCT<>0 Then A3.CPCT/100 else 1 end)/(Case When AccAss.PProrata<>0 Then AccAss.PProrata else 1 end) else AccAss.Amount_OC end)*(Case When AccAss.Type='DI' then 100/(100-coalesce(Coinsurance.MShare,0)) else 1 end)*(Case When (Case When (coalesce(Profile.VATESDate,'01/01/1900')<= A2.ADate and coalesce(Profile.VatEEDate,'01/01/1900')>= A2.ADate) Then cast(0 as Bit) else Profile.VatF end)=1 Then MParam.Vat/100 else 0 end)) as Vat,                  
	sum(-(Case When A3.AType='A' and AccAss.AdjMethod='OVERLIMIT' then AccAss.CAmount*(Case When A3.CPCT<>0 Then A3.CPCT/100 else 1 end)/(Case When AccAss.PProrata<>0 Then AccAss.PProrata else 1 end) else AccAss.Amount_OC end)*(Case When AccAss.Type='DI' then 100/(100-coalesce(Coinsurance.MShare,0)) else 1 end)*(Case When (Case When (coalesce(Profile.TaxHSDate,'01/01/1900')<= A2.ADate and coalesce(Profile.TaxHEDate,'01/01/1900')>= A2.ADate) Then cast(0 as Bit) else Profile.TaxF end)=1 Then (Case When TaxType.MTaxType='PASAL21' Then (Case When MParam.UseTaxTypeF=0 Then MParam.PASAL21 Else TaxType.TaxRate End)/100*(100-MParam.TaxDiscount)/100 When TaxType.MTaxType='PASAL23' Then (Case When MParam.UseTaxTypeF=0 Then MParam.PASAL23 Else TaxType.TaxRate End)/100 When TaxType.MTaxType='PASAL26' Then (Case When MParam.UseTaxTypeF=0 Then MParam.PASAL26 Else TaxType.TaxRate End)/100 When TaxType.MTaxType='PASAL4' Then (Case When MParam.UseTaxTypeF=0 Then MParam.PASAL4 Else TaxType.TaxRate End)/100 else 0 end)*(Case When Profile.TaxPCT=0 Then 1 else Profile.TaxPCT/100 end) else Profile.AccruedTax/100 end)) as Tax,      
	sum(Case When AccAss.Code in ('F','D') then -AccAss.Amount_OC else 0 end) as FeeDuty      

	From Acceptance A2 
	inner join AccAss on (AccAss.ANO=A2.ANO)     
	Left join Acceptance pA2  on (pA2.ANO=A2.pANO)     
	Outer Apply (Select Top 1 A.UseCurrTypeF, A.BSType from AccBS A, Acceptance oA Where oA.OANO=A2.OANO and A.ANO=oA.ANO and A.ANO>=A2.ANO and A.UseCurrTypeF=1 and A.ID=AccAss.ID and A.BSType<>A.OBSType and A.OBSType=substring(AccAss.Type,2,1) Order by A.ANO) A4
	Outer Apply (Select Top 1 A.UseCurrTypeF, A.BSType from AAccBS A, Acceptance oA Where oA.OANO=A2.OANO and A.ANO=oA.ANO and A.ANO>=A2.ANO and A.UseCurrTypeF=1 and A.ID=AccAss.ID and A.BSType<>A.OBSType and A.OBSType=substring(AccAss.Type,2,1) Order by A.ANO) A5
	Outer Apply (Select Top 1 A.UseCurrTypeF, A.BSType from AccBS A, Acceptance oA Where oA.OANO=A2.OANO and A.ANO=oA.ANO and A.ANO>=A2.LANO and A.UseCurrTypeF=1 and A.ID=AccAss.ID and A.BSType<>A.OBSType and A.OBSType=substring(AccAss.Type,2,1) Order by A.ANO) A6
	inner join Profile on (Profile.ID=AccAss.ID)      
	Left Join TaxType on (TaxType.TaxType=Profile.TaxType)
	inner join MParam on (MParam.Type=
				Case 
				When coalesce(A5.UseCurrTypeF, coalesce(A4.UseCurrTypeF, coalesce(A6.UseCurrTypeF, Cast(0 as Bit))))=1 and AccAss.Type in ('BB','BA','BO','BC','BP','BD') then
					'B'+coalesce(A5.BSType, coalesce(A4.BSType, coalesce(A6.BSType,'')))
				else
					AccAss.Type
				end
	)	
	Left Join (Select CNO, sum(Share) as MShare from Coinsurance Where PCollectionF=0 Group by CNO) Coinsurance on (Coinsurance.CNO=A2.CNO)      
	Cross Apply (
		Select Top 1 A1.ANO, A1.OANO, A1.CPCT, A1.AType, A1.EMethod, A1.PANO, A1.PDate, A1.PPDate, A2.PDate as CPDate, coalesce(A2.ANO,0) as CANO,
		coalesce((Select Top 1 PANO from Acceptance A3 Where A3.OANO=A1.OANO and A3.Astatus<>'C' and A3.AType='A' and A3.ANO<@P_ANO Order By A3.PANO Desc), A1.PANO) as PADJANO
		from Acceptance A1
		Left Join RArrHeader R on (R.ANO=A1.ANO)
		Outer Apply (Select Top 1 A2.ANO, A2.PDate from Acceptance A2 Where A2.OANO=A1.OANO and A2.Atype='C' and A2.EMethod='A' and A2.ANO<@P_ANO Order by A2.ANO Desc) A2
		Where A1.ANO=@P_ANO
		Order By A1.OANO, A2.ANO Desc
	) A3 
	Where A2.OANO=A3.OANO and A2.ANO<@P_ANO
	and 
	( 
		(
		A3.AType='A' and
		(    
			(  
			pA2.ANO=A3.PANO and A3.PDate<=(Case When pA2.PDate<pA2.SDate then pA2.SDate else pA2.PDate End) and A3.PPDate>=(Case When pA2.PPDate<pA2.SDate then pA2.SDate else pA2.PPDate End) and (A2.AType='E' and coalesce(pA2.AType,'') in ('N','E'))   
			and AccAss.AdjustableF=1 and AccAss.AdjMethod<>'OVERLIMIT' and AccAss.CAmount=0  
			and pA2.ANO<=A3.PADJANO 
			)     
			or   
			(  
			A2.ANO<=A3.PANO and A3.PDate<=(Case When A2.PDate<A2.SDate then A2.SDate else A2.PDate End) and A3.PPDate>=(Case When A2.PPDate<A2.SDate then A2.SDate else A2.PPDate End) and (A2.AType<>'A' and coalesce(pA2.AType,'')<>'A')   
			and AccAss.AdjustableF=1 and AccAss.AdjMethod<>'OVERLIMIT'  
			and A2.ANO<=A3.PADJANO and A2.PANO<>A3.PADJANO and AccAss.CAmount<>0
			)     
			or   
			(  
			A2.ANO<=A3.PANO and A3.PDate<=(Case When pA2.PDate<pA2.SDate then pA2.SDate else pA2.PDate End) and A3.PPDate>=(Case When pA2.PPDate<pA2.SDate then pA2.SDate else pA2.PPDate End) and (A2.AType<>'A' and coalesce(pA2.AType,'')<>'A')   
			and AccAss.AdjustableF=1 and AccAss.AdjMethod<>'OVERLIMIT'  
			and A2.ANO<=A3.PADJANO and A2.PANO<>A3.PADJANO and AccAss.CAmount=0
			)   
			or   
			(  
			A2.ANO<=A3.PANO and A3.PDate<=(Case When A2.PDate<A2.SDate then A2.SDate else A2.PDate End) and A3.PPDate>=(Case When A2.PPDate<A2.SDate then A2.SDate else A2.PPDate End) and (A2.AType<>'A' and coalesce(pA2.AType,'')<>'A')   
			and AccAss.AdjustableF=1 and AccAss.AdjMethod<>'OVERLIMIT' and AccAss.CAmount<>0  
			and A2.PANO=A3.PADJANO
			)     
			or   
			(  
			A2.ANO<=A3.PANO and A3.PDate<=(Case When A2.PDate<A2.SDate then A2.SDate else A2.PDate End) and A3.PPDate>=(Case When A2.PPDate<A2.SDate then A2.SDate else A2.PPDate End) and A2.PDATE<A2.PPDATE and (A2.AType<>'A' and coalesce(pA2.AType,'')<>'A')   
			and AccAss.AdjustableF=1 and AccAss.AdjMethod='OVERLIMIT' and AccAss.CAmount<>0  
			and NOT EXISTS (Select Top 1 PANO from Acceptance A3 Where A3.OANO=A3.OANO and A3.PANO=A2.ANO and A3.Astatus<>'C' and A3.AType='A' and A3.ANO<@P_ANO)  
			)     
		)
		)
		or    
		(  
		--Cancel All
		A3.AType='C' and A3.EMethod='A'and 
		(
		(
		case when A2.ANO<=A3.CANO and A2.PDate>coalesce(A3.CPDate,A2.PDate) Then coalesce(A3.CPDate,A2.PDate) else A2.PDate end>=A3.PDate and AccAss.CAmount<>0
		) 
		or 
		(
		case when A2.ANO<=A3.CANO and coalesce(pA2.pDate,A2.PDate)>coalesce(A3.CPDate,coalesce(pA2.pDate,A2.PDate)) Then coalesce(A3.CPDate,coalesce(pA2.pDate,A2.PDate)) else coalesce(pA2.pDate,A2.PDate) end>=A3.PDate and AccAss.CAmount=0
		)
		)
		)  
		or
		(
		--Adjustment Cancel
		A3.AType='C' and A2.AType='A' and A2.ANO=A3.PANO
		)
	)     	                  
	and 
	(
	(AccAss.Type in ('DI','IC','IR','IT','IX') and AccAss.Code='P') 
	or (AccAss.Type in ('DI','IC') and AccAss.Code='U') 
	Or (AccAss.Type in ('BB','BA','BO','BC','BP','BD') and AccAss.Code='C') 
	or (AccAss.Type in ('DI','IC','IR','IT','IX') and AccAss.Code='O') 
	or (A3.AType='C' and A3.EMethod='A' and AccAss.Type in ('DI') and AccAss.Code in ('F','D'))
	)                  
	Group By A3.ANO, AccAss.RCode, AccAss.SDate, AccAss.EDate, AccAss.Currency_OC
) T          
Group by ANO, Currency


)       

go

insert into PatchVersioning
select '1506 Update Script - patch 2025 (61).sql',GETDATE()
go	
  
Declare @PrevScript varchar(100)
Declare @CurrScript varchar(100)

Select @PrevScript=''
Select @CurrSCript='1506 Update Script - patch 2025 (61).sql'


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