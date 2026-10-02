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
	Inner Join PCalc P on (P.ANO=AccFD.ANO and P.Currency=AccFD.Currency)
	Inner Join FDTAB on (FDTab.FDID=AccFD.FDID)
	Where AccFD.ANO=@P_ANO and AccFD.Amount<>0

	Union All

	Select AccFD.Currency, 0 as Rate, 0 as TSI, 0 as OurShare, 0 as Gross, 0 as CRate, 0 as Premium, 0 as Discount, 0 as Commission, 0 as Vat, 0 as Tax, 
	sum(
	Case 
	When FDTab.FDType<>'O' Then 
		  (D1.Gross*(100-D1.Discount)/100*D1.Prorata*P.Gross/P.OGross*P.OurShare/P.TSI*AccFD.AmountPCT/100)
	Else
		  -(D1.Gross*D1.Prorata*P.Gross/P.OGross*P.OurShare/P.TSI*(100-R.MSHARE)/100*AccFD.AmountPCT/100) 		  
	End 
	) as FeeDuty
	from Display_Calculation(@P_ANO) D1
	Inner join RarrHeader R on (R.ANO=D1.ANO)
	Inner join PCalc P on (P.ANO=D1.ANO and P.Currency=D1.Currency)
	Inner Join AccFD on (AccFD.ANO=@P_ANO and AccFD.Currency=D1.Currency)
	Inner Join FDTAB ON (FDTab.FDID=AccFD.FDID)
	Where  AccFD.Amount=0 and AccFd.AMOUNTPCTBASED=0
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
	and AccFD.Amount=0 and AccFd.AMOUNTPCTBASED<>0
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
		Inner Join PCalc P on (P.ANO=AccFD.ANO and P.Currency=AccFD.Currency)
		Inner Join FDTAB on (FDTab.FDID=AccFD.FDID)
		Where AccFD.ANO=A.ANO and AccFD.Amount<>0

		Union All

		Select AccFD.Currency, 0 as Rate, 0 as TSI, 0 as OurShare, 0 as Gross, 0 as CRate, 0 as Premium, 0 as Discount, 0 as Commission, 0 as Vat, 0 as Tax, 
		sum(
		Case 
		When FDTab.FDType<>'O' Then 
			  (D1.Gross*(100-D1.Discount)/100*D1.Prorata*P.Gross/P.OGross*P.OurShare/P.TSI*AccFD.AmountPCT/100)
		Else
			  -(D1.Gross*D1.Prorata*P.Gross/P.OGross*P.OurShare/P.TSI*(100-R.MSHARE)/100*AccFD.AmountPCT/100) 		  
		End 
		) as FeeDuty
		from Display_Calculation(A.ANO) D1
		Inner join RarrHeader R on (R.ANO=D1.ANO)
		Inner join PCalc P on (P.ANO=D1.ANO and P.Currency=D1.Currency)
		Inner Join AccFD on (AccFD.ANO=A.ANO and AccFD.Currency=D1.Currency)
		Inner Join FDTAB ON (FDTab.FDID=AccFD.FDID)
		Where  AccFD.Amount=0 and AccFd.AMOUNTPCTBASED=0
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
		and AccFD.Amount=0 and AccFd.AMOUNTPCTBASED<>0
		Group by ACCFD.Currency
	) P
	Where A.LANO=@ANO and A.RegNo=@RegNo 
end


Select @p_ANO ANO, Currency, Max(Rate) as Rate, sum(TSI) as TSI, sum(OurShare) as OurShare, sum(Gross) as Gross, Case When Sum(TSI)<>0 then Sum(Gross)/sum(TSI)*100 else 0 end as CRate, sum(Premium) as Premium, sum(Discount) as Discount, sum(Commission) as Commission, sum(Vat) as Vat, sum(Tax) as Tax, sum(FeeDuty) as FeeDuty    
from @PremiumCalc P
Group By Currency    



go



 insert into PatchVersioning	
select '687 Update Script - Patch 2023 (62)',GETDATE()
go





Declare @PrevScript varchar(100)
Declare @CurrScript varchar(100)

Select @PrevScript=''
Select @CurrSCript='687 Update Script - Patch 2023 (62)'


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








