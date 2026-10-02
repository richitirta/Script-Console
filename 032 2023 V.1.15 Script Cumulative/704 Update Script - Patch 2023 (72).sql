DROP function Open_Item_Voucher_N
GO
CREATE  function Open_Item_Voucher_N(@P_Branch Varchar(5))  
RETURNS Table  
AS RETURN  
(  
select Voucher.Voucher, Voucher.Branch, Voucher.Payment_CC+Voucher.Payment_OC as Payment_CC, Voucher.Nominal_CC-Voucher.Diff_CC as Nominal_CC 
from nVoucher Voucher Where Voucher.Branch Like @P_Branch+'%'  
)  
    
GO
DROP function OPEN_VOUCHER_N
GO
CREATE function OPEN_VOUCHER_N(@P_VOUCHER VARCHAR(20),@P_Branch Varchar(10)='', @P_Account varchar(10)='')
RETURNS Table
AS RETURN
(
select Voucher.Voucher, Voucher.Branch, Voucher.DebtorF, Voucher.CreditorF, Voucher.SL_Cat, Voucher.Remarks, Voucher.Payment_CC+Voucher.Payment_OC as Payment_CC, Voucher.Nominal_CC-Voucher.Diff_CC as Nominal_CC, Case When ProAcc.ExcludeTaxF=1 Then Voucher.Tax_CC Else 0 end as Tax_CC
from nVoucher Voucher Inner 
Join ProAcc on (ProAcc.ProAcc=Voucher.ProAcc) Where VOUCHER.VOUCHER=@P_VOUCHER
)
          
GO
DROP function OS_VOUCHER_I
GO
CREATE function OS_VOUCHER_I (@P_Voucher Varchar(20))    
RETURNS Table    
AS RETURN    
(    
SELECT VOUCHER.VOUCHER, VOUCHER.DATE, VOUCHER.CURRENCY, VOUCHER.PROACC, VOUCHER.DEBTORF,VOUCHER.CREDITORF,VOUCHER.SL_CAT,    
VOUCHER.BRANCH, VOUCHER.REFNO,VOUCHER.REFDATE, VOUCHER.DOCNO,VOUCHER.VTYPE, VOUCHER.REMARKS, VOUCHER.REFTYPE, VOUCHER.ACCOUNTNO, ' ' as A_RefNo,    
VOUCHER.NOMINAL_CC-VOUCHER.DIFF_CC AS NOMINAL,    
VOUCHER.TAX_CC as TAX,
CASE WHEN VP.VOUCHER IS NULL THEN VOUCHER.PAYMENT_CC+VOUCHER.PAYMENT_OC ELSE VOUCHER.NOMINAL_CC-VOUCHER.DIFF_CC-VP.NOMINAL END AS PAYMENT,    
CASE WHEN VP.VOUCHER IS NULL THEN VOUCHER.NOMINAL_CC-VOUCHER.DIFF_CC-VOUCHER.PAYMENT_CC-VOUCHER.PAYMENT_OC ELSE VP.NOMINAL END AS OUTSTANDING,  
'' AS ACCOUNT,
cast(0 as Smallint) as HINT   
FROM NVoucher VOUCHER    
LEFT JOIN PAID_VOUCHER_N(@P_Voucher) VP ON(VOUCHER.VOUCHER=VP.VOUCHER)    
WHERE VOUCHER.INVESTMENTF=1 AND VOUCHER.REQUESTF=0 AND ROUND(CASE WHEN VP.VOUCHER IS NULL THEN VOUCHER.NOMINAL_CC-VOUCHER.DIFF_CC-VOUCHER.PAYMENT_CC-VOUCHER.PAYMENT_OC ELSE VP.NOMINAL END,4)<>0    
)    
GO

DROP function OS_VOUCHER_M
GO
CREATE function OS_VOUCHER_M (@P_Voucher Varchar(20))    
RETURNS Table    
AS RETURN    
(    
SELECT VOUCHER.VOUCHER, VOUCHER.DATE, VOUCHER.CURRENCY, VOUCHER.PROACC, VOUCHER.DEBTORF,VOUCHER.CREDITORF,VOUCHER.SL_CAT,    
VOUCHER.BRANCH, VOUCHER.REFNO,VOUCHER.REFDATE, VOUCHER.DOCNO,VOUCHER.VTYPE, VOUCHER.REMARKS, VOUCHER.REFTYPE, VOUCHER.ACCOUNTNO, '  ' as A_RefNo,    
VOUCHER.NOMINAL_CC-VOUCHER.DIFF_CC AS NOMINAL, 
VOUCHER.TAX_CC as TAX,
CASE WHEN VP.VOUCHER IS NULL THEN VOUCHER.PAYMENT_CC+VOUCHER.PAYMENT_OC ELSE VOUCHER.NOMINAL_CC-VOUCHER.DIFF_CC-VP.NOMINAL END AS PAYMENT,    
CASE WHEN VP.VOUCHER IS NULL THEN VOUCHER.NOMINAL_CC-VOUCHER.DIFF_CC-VOUCHER.PAYMENT_CC-VOUCHER.PAYMENT_OC ELSE VP.NOMINAL END AS OUTSTANDING,  
'' AS ACCOUNT,
cast(0 as Smallint) as HINT  
FROM NVoucher VOUCHER    
INNER JOIN VTYPE ON (VTYPE.VTYPE=VOUCHER.VTYPE)    
LEFT JOIN PAID_VOUCHER_N(@P_Voucher) VP ON(VOUCHER.VOUCHER=VP.VOUCHER)    
WHERE Voucher.SL_Tag=1	-- Manual Voucher
AND VOUCHER.INVESTMENTF=0 AND VTYPE.TAXF=0 AND VOUCHER.REQUESTF=0 AND ROUND(CASE WHEN VP.VOUCHER IS NULL THEN VOUCHER.NOMINAL_CC-VOUCHER.DIFF_CC-VOUCHER.PAYMENT_CC-VOUCHER.PAYMENT_OC ELSE VP.NOMINAL END,4)<>0    
)    
       
GO
DROP function OS_VOUCHER_N
GO
CREATE function OS_VOUCHER_N (@P_Voucher Varchar(30))        
RETURNS Table        
AS RETURN        
(        
SELECT VOUCHER.VOUCHER, VOUCHER.DATE, VOUCHER.CURRENCY, VOUCHER.PROACC, VOUCHER.DEBTORF,VOUCHER.CREDITORF,VOUCHER.SL_CAT,        
VOUCHER.BRANCH, VOUCHER.REFNO,VOUCHER.REFDATE,VOUCHER.DOCNO,VOUCHER.VTYPE, VOUCHER.REMARKS, VOUCHER.REFTYPE, VOUCHER.ACCOUNTNO, Admlink.A_RefNo,        
VOUCHER.NOMINAL_CC-VOUCHER.DIFF_CC AS NOMINAL,        
VOUCHER.TAX_CC as TAX,
CASE WHEN VP.VOUCHER IS NULL THEN VOUCHER.PAYMENT_CC+VOUCHER.PAYMENT_OC ELSE VOUCHER.NOMINAL_CC-VOUCHER.DIFF_CC-VP.NOMINAL END AS PAYMENT,        
CASE WHEN VP.VOUCHER IS NULL THEN VOUCHER.NOMINAL_CC-VOUCHER.DIFF_CC-VOUCHER.PAYMENT_CC-VOUCHER.PAYMENT_OC ELSE VP.NOMINAL END AS OUTSTANDING,    
'' AS ACCOUNT,  
cast(0 as Smallint) as HINT    
FROM NVoucher VOUCHER 
Cross Apply (Select TOp 1 A_RefNo from Admlink Where Admlink.Voucher=Voucher.Voucher) Admlink
LEFT JOIN PAID_VOUCHER_N(@P_Voucher) VP ON(VOUCHER.VOUCHER=VP.VOUCHER)        
WHERE VOUCHER.STATUS<>'C' AND VOUCHER.REQUESTF=0 AND ROUND(CASE WHEN VP.VOUCHER IS NULL THEN VOUCHER.NOMINAL_CC-VOUCHER.DIFF_CC-VOUCHER.PAYMENT_CC-VOUCHER.PAYMENT_OC ELSE VP.NOMINAL END,4)<>0        
)        

GO
DROP function OS_VOUCHER_T
GO
CREATE function OS_VOUCHER_T (@P_Voucher Varchar(20))    
RETURNS Table    
AS RETURN    
(    
SELECT VOUCHER.VOUCHER, VOUCHER.DATE, VOUCHER.CURRENCY, VOUCHER.PROACC, VOUCHER.DEBTORF,VOUCHER.CREDITORF,VOUCHER.SL_CAT,    
VOUCHER.BRANCH, VOUCHER.REFNO,VOUCHER.REFDATE, VOUCHER.DOCNO,VOUCHER.VTYPE, VOUCHER.REMARKS, VOUCHER.REFTYPE, VOUCHER.ACCOUNTNO, ' ' as A_RefNo,    
VOUCHER.NOMINAL_CC-VOUCHER.DIFF_CC AS NOMINAL,    
CASE WHEN VP.VOUCHER IS NULL THEN VOUCHER.PAYMENT_CC+VOUCHER.PAYMENT_OC ELSE VOUCHER.NOMINAL_CC-VOUCHER.DIFF_CC-VP.NOMINAL END AS PAYMENT,    
CASE WHEN VP.VOUCHER IS NULL THEN VOUCHER.NOMINAL_CC-VOUCHER.DIFF_CC-VOUCHER.PAYMENT_CC-VOUCHER.PAYMENT_OC ELSE VP.NOMINAL END AS OUTSTANDING,  
'' AS ACCOUNT,
cast(0 as Smallint) as HINT  
FROM NVoucher VOUCHER Inner Join VType on (VType.VType=Voucher.VType and VType.TaxF=1)    
LEFT JOIN PAID_VOUCHER_N(@P_Voucher) VP ON(VOUCHER.VOUCHER=VP.VOUCHER)    
WHERE VOUCHER.REQUESTF=0 AND ROUND(CASE WHEN VP.VOUCHER IS NULL THEN VOUCHER.NOMINAL_CC-VOUCHER.DIFF_CC-VOUCHER.PAYMENT_CC-VOUCHER.PAYMENT_OC ELSE VP.NOMINAL END,4)<>0    
)    

GO
DROP function OS_VOUCHER_V
GO
CREATE function OS_VOUCHER_V (@P_Voucher Varchar(20))    
RETURNS Table    
AS RETURN    
(    
SELECT VOUCHER.VOUCHER, VOUCHER.DATE, VOUCHER.CURRENCY, VOUCHER.PROACC, VOUCHER.DEBTORF,VOUCHER.CREDITORF,VOUCHER.SL_CAT,    
VOUCHER.BRANCH, VOUCHER.REFNO,VOUCHER.REFDATE, VOUCHER.DOCNO,VOUCHER.VTYPE, VOUCHER.REMARKS, VOUCHER.REFTYPE, VOUCHER.ACCOUNTNO, ' ' as A_RefNo,    
VOUCHER.NOMINAL_CC-VOUCHER.DIFF_CC AS NOMINAL,    
CASE WHEN VP.VOUCHER IS NULL THEN VOUCHER.PAYMENT_CC+VOUCHER.PAYMENT_OC ELSE VOUCHER.NOMINAL_CC-VOUCHER.DIFF_CC-VP.NOMINAL END AS PAYMENT,    
CASE WHEN VP.VOUCHER IS NULL THEN VOUCHER.NOMINAL_CC-VOUCHER.DIFF_CC-VOUCHER.PAYMENT_CC-VOUCHER.PAYMENT_OC ELSE VP.NOMINAL END AS OUTSTANDING,  
'' AS ACCOUNT,
cast(0 as Smallint) as HINT  
FROM NVoucher VOUCHER Inner Join VType on (VType.VType=Voucher.VType and VType.VatF=1)    
LEFT JOIN PAID_VOUCHER_N(@P_Voucher) VP ON(VOUCHER.VOUCHER=VP.VOUCHER)    
WHERE VOUCHER.REQUESTF=0 AND ROUND(CASE WHEN VP.VOUCHER IS NULL THEN VOUCHER.NOMINAL_CC-VOUCHER.DIFF_CC-VOUCHER.PAYMENT_CC-VOUCHER.PAYMENT_OC ELSE VP.NOMINAL END,4)<>0    
)    


GO
DROP function OS_WITHHOLDING
GO
CREATE function OS_WITHHOLDING  (@P_Voucher Varchar(20))
RETURNS Table
AS RETURN
(
Select Voucher.Voucher, Voucher.TaxType, Voucher.PDate, Voucher.Date, Voucher.CT,
ProAcc.Description, Voucher.Currency, Voucher.Tax_CC, Voucher.TaxPayment_CC as TaxPayment_CC, Voucher.Nominal_CC, Voucher.Diff_CC, Voucher.Payment_CC+Voucher.Payment_OC as Payment_CC,
Voucher.DebtorF , Voucher.CreditorF, Voucher.Branch, ProAcc.ID
from nVoucher Voucher, ProAcc
Where ProAcc.ProAcc = Voucher.ProAcc And Voucher.TaxF = 1 And Round(Voucher.Tax_CC, 2) <> Round(Voucher.TaxPayment_CC, 2)
and Voucher.Voucher not in (Select SL.Doc_No from nSL SL Where Voucher.Voucher=SL.Doc_No and SL.PaymentF=1 and SL.Voucher=@P_Voucher)
Union All
Select Voucher.Voucher, Voucher.TaxType, Voucher.PDate, Voucher.Date, Voucher.CT,
ProAcc.Description, Voucher.Currency, Voucher.Tax_CC, Voucher.TaxPayment_CC+case when Voucher.creditorF=1 then SL.Nominal_OC else -SL.Nominal_OC end as TaxPayment_CC, Voucher.Nominal_CC, Voucher.Diff_CC,
Voucher.Payment_CC+Voucher.Payment_OC as Payment_CC , Voucher.DebtorF, Voucher.CreditorF, Voucher.Branch, ProAcc.ID
from nSL SL, nVoucher Voucher, ProAcc
Where ProAcc.ProAcc=Voucher.ProAcc and Voucher.Voucher=SL.Doc_No and SL.PaymentF=1 and SL.Voucher=@P_Voucher
)
  
  
  
GO  

DROP Function Get_Payment_Percentage
GO
CREATE Function Get_Payment_Percentage(@P_A_PolicyNo varchar(50), @P_Subject varchar(10), @P_Type varchar(10), @P_DocNO varchar(50), @P_Date smalldatetime, @P_Currency varchar(10), @P_DebtorF bit)
RETURNS Float AS        
  
BEGIN       
Declare @PCT as Float

Declare @Admlink Table(AdmNo int, DocNo varchar(50), Date SmallDatetime, Voucher varchar(50), Amount Float, LAmount Float)

if @P_DebtorF=1
	Return 100

if @P_Subject='Premium'
Begin
	insert into @Admlink(AdmNo, DocNo, Date, Voucher, Amount, LAmount)
	Select A.AdmNo, A.DocNo, A.Date, A.Voucher, A.Amount, A.LAmount
	from Admlink A
	Inner Join nVoucher V on (V.Voucher=A.Voucher)
	Where A.Date<=@P_Date and A.A_PolicyNo=@P_A_PolicyNo and A.Currency=@P_Currency and A.Subject='Premium' and A.Type in ('DI','IC','IR')
	and (substring(A.DocNo,1,50)+space(50-len(A.DocNo))+convert(varchar(50), A.Date,102))<=(substring(@P_DocNo,1,50)+space(50-len(@P_DocNo))+convert(varchar(50), @P_Date,102)) 
	and Round(V.Nominal_CC-V.Diff_CC,4)>0

	Select Top 1 @P_DocNo=A.DocNo, @P_Date=A.Date
	from @Admlink A
	Order by AdmNo Desc

	Select 
	@PCT=
	sum(case When V.DebtorF=1 Then (V.Payment_CC) Else -(V.Payment_CC) end)/sum(case When V.DebtorF=1 Then (V.Nominal_CC) Else -(V.Nominal_CC) end)*100

	from (

		   Select V.Voucher, 
		   cast(Max(Cast(V.DebtorF as Int)) as Bit) as DebtorF,
		   Case 
		   When @P_TYPE in ('PI','PL') Then Max((V.Payment_CC+V.Payment_OC)*V.Rate)
		   When Max((V.Payment_CC+V.Payment_OC)*V.Rate)<sum((case When V.DebtorF=1 Then 1 else -1 end)*(A.LAmount)*V.Rate) Then 0
		   Else Max((V.Payment_CC+V.Payment_OC)*V.Rate)-sum((case When V.DebtorF=1 Then 1 else -1 end)*(A.LAmount)*V.Rate)
		   End as Payment_CC,

		   sum(
				  (case When V.DebtorF=1 Then 1 else -1 end)*
				  Case
				  When @P_Type in ('PI','PL') then (A.Amount)
				  Else (A.Amount-A.LAmount)
				  End*V.Rate
		   ) as Nominal_CC
		   from @Admlink A
		   Inner Join nVoucher V on (V.Voucher=A.Voucher)
			Where (substring(A.DocNo,1,50)+space(50-len(A.DocNo))+convert(varchar(50), A.Date,102))>
			coalesce(
			(
			Select Top 1 (substring(B.DocNo,1,50)+space(50-len(B.DocNo))+convert(varchar(50), B.Date,102)) 
			from Admlink B
			Inner Join @Admlink C on (C.DocNo=B.DocNo and C.Date=B.Date)
			Where B.Date<=@P_Date and B.A_PolicyNo=@P_A_PolicyNo and B.Currency=@P_Currency and B.Subject=@P_Subject and B.Type=@P_Type 
			and (substring(B.DocNo,1,50)+space(50-len(B.DocNo))+convert(varchar(50), B.Date,102))<(substring(@P_DocNo,1,50)+space(50-len(@P_DocNo))+convert(varchar(50), @P_Date,102))  
			order by B.AdmNo Desc
			),'')
		   Group By V.Voucher
	) V

	Having sum(case When V.DebtorF=1 Then (V.Nominal_CC) Else -(V.Nominal_CC) end)<>0
End
else
Begin
	Declare @LossDate as smalldatetime

	Select top 1 @LossDate=case when isdate(Extra_2)=1 then cast(extra_2 as smalldatetime) else Null end
	from Admlink Where Subject=@P_Subject and Type=@P_Type and DocNo=@P_DocNo and Currency=@P_Currency and Date=@P_Date

	if @LossDate is null
		set @LossDate=@P_Date 

	insert into @Admlink(AdmNo, DocNo, Date, Voucher, Amount, LAmount)
	Select A.AdmNo, A.DocNo, A.Date, A.Voucher, A.Amount*case when V.DebtorF=1 Then V.AmountDue/(V.Nominal_CC-V.Diff_CC) else -V.AmountDue/(V.Nominal_CC-V.Diff_CC) end as Amount, A.LAmount
	from Admlink A
	Inner Join VOUCHER_AMOUNTDUE(@LossDate) V on (V.Voucher=A.Voucher)
	Where A.Date<=@P_Date and A.A_PolicyNo=@P_A_PolicyNo and A.Currency=@P_Currency and A.Subject='Premium' and A.Type in ('DI','IC','IR')
	and (substring(A.A_PolicyNo,1,50)+space(50-len(A.A_PolicyNo))+convert(varchar(50), A.Date,102))<=(substring(@P_A_PolicyNo,1,50)+space(50-len(@P_A_PolicyNo))+convert(varchar(50), @P_Date,102)) 
	and Round(V.Nominal_CC-V.Diff_CC,4)>0

	Select 
	@PCT=
	sum(case When V.DebtorF=1 Then (V.Payment_CC) Else -(V.Payment_CC) end)/sum(case When V.DebtorF=1 Then (V.Nominal_CC) Else -(V.Nominal_CC) end)*100

	from (

		   Select V.Voucher, 
		   cast(Max(Cast(V.DebtorF as Int)) as Bit) as DebtorF,
		   Case 
		   When @P_TYPE in ('PI','PL') Then Max((V.Payment_CC+V.Payment_OC)*V.Rate)
		   When Max((V.Payment_CC+V.Payment_OC)*V.Rate)<sum((case When V.DebtorF=1 Then 1 else -1 end)*(A.LAmount)*V.Rate) Then 0
		   Else Max((V.Payment_CC+V.Payment_OC)*V.Rate)-sum((case When V.DebtorF=1 Then 1 else -1 end)*(A.LAmount)*V.Rate)
		   End as Payment_CC,

		   sum(
				  (case When V.DebtorF=1 Then 1 else -1 end)*
				  Case
				  When @P_Type in ('PI','PL') then (A.Amount)
				  Else (A.Amount-A.LAmount)
				  End*V.Rate
		   ) as Nominal_CC
		   from @Admlink A
		   Inner Join nVoucher V on (V.Voucher=A.Voucher)
		   Group By V.Voucher
	) V

	Having sum(case When V.DebtorF=1 Then (V.Nominal_CC) Else -(V.Nominal_CC) end)<>0
End

if @PCT IS NULL 
       SELECT @PCT=100

if @PCT<0
       SELECT @PCT=0

if @PCT>100
       SELECT @PCT=100

Return @PCT
End


GO

DROP Function FN_Get_Payment_Percentage
GO
CREATE Function FN_Get_Payment_Percentage(@P_A_PolicyNo varchar(50), @P_Subject varchar(10), @P_Type varchar(10), @P_DocNO varchar(50), @P_Date smalldatetime, @P_Currency varchar(10))
RETURNS @Info TABLE (PCT Float, PDate smalldatetime)
AS    
BEGIN    
-- from Get_Payment_Percentage function (add Payment Date)

Declare @PCT as Float
Declare @PDate as Smalldatetime

Declare @Admlink Table(AdmNo int, DocNo varchar(50), Date SmallDatetime, Voucher varchar(50), Amount Float, LAmount Float)

if @P_Subject='Premium'
Begin
	insert into @Admlink(AdmNo, DocNo, Date, Voucher, Amount, LAmount)
	Select A.AdmNo, A.DocNo, A.Date, A.Voucher, A.Amount, A.LAmount
	from Admlink A
	Inner Join nVoucher V on (V.Voucher=A.Voucher)
	Where A.Date<=@P_Date and A.A_PolicyNo=@P_A_PolicyNo and A.Currency=@P_Currency and A.Subject='Premium' and A.Type in ('DI','IC','IR')
	and (substring(A.DocNo,1,50)+space(50-len(A.DocNo))+convert(varchar(50), A.Date,102))<=(substring(@P_DocNo,1,50)+space(50-len(@P_DocNo))+convert(varchar(50), @P_Date,102)) 
	and Round(V.Nominal_CC-V.Diff_CC,4)>0

	Select Top 1 @P_DocNo=A.DocNo, @P_Date=A.Date
	from @Admlink A
	Order by AdmNo Desc

	Select 
	@PDate=Max(V.PDate),
	@PCT=
	sum(case When V.DebtorF=1 Then (V.Payment_CC) Else -(V.Payment_CC) end)/sum(case When V.DebtorF=1 Then (V.Nominal_CC) Else -(V.Nominal_CC) end)*100

	from (

		   Select V.Voucher, 
		   Max(V.PDate) as Pdate,
		   cast(Max(Cast(V.DebtorF as Int)) as Bit) as DebtorF,
		   Case 
		   When @P_TYPE in ('PI','PL') Then Max((V.Payment_CC+V.Payment_OC)*V.Rate)
		   When Max((V.Payment_CC+V.Payment_OC)*V.Rate)<sum((case When V.DebtorF=1 Then 1 else -1 end)*(A.LAmount)*V.Rate) Then 0
		   Else Max((V.Payment_CC+V.Payment_OC)*V.Rate)-sum((case When V.DebtorF=1 Then 1 else -1 end)*(A.LAmount)*V.Rate)
		   End as Payment_CC,

		   sum(
				  (case When V.DebtorF=1 Then 1 else -1 end)*
				  Case
				  When @P_Type in ('PI','PL') then (A.Amount)
				  Else (A.Amount-A.LAmount)
				  End*V.Rate
		   ) as Nominal_CC
		   from @Admlink A
		   Inner Join nVoucher V on (V.Voucher=A.Voucher)
			Where (substring(A.DocNo,1,50)+space(50-len(A.DocNo))+convert(varchar(50), A.Date,102))>
			coalesce(
			(
			Select Top 1 (substring(B.DocNo,1,50)+space(50-len(B.DocNo))+convert(varchar(50), B.Date,102)) 
			from Admlink B
			Inner Join @Admlink C on (C.DocNo=B.DocNo and C.Date=B.Date)
			Where B.Date<=@P_Date and B.A_PolicyNo=@P_A_PolicyNo and B.Currency=@P_Currency and B.Subject=@P_Subject and B.Type=@P_Type 
			and (substring(B.DocNo,1,50)+space(50-len(B.DocNo))+convert(varchar(50), B.Date,102))<(substring(@P_DocNo,1,50)+space(50-len(@P_DocNo))+convert(varchar(50), @P_Date,102))  
			order by B.AdmNo Desc
			),'')
		   Group By V.Voucher
	) V

	Having sum(case When V.DebtorF=1 Then (V.Nominal_CC) Else -(V.Nominal_CC) end)<>0
End
else
Begin
	Declare @LossDate as smalldatetime

	Select top 1 @LossDate=case when isdate(Extra_2)=1 then cast(extra_2 as smalldatetime) else Null end
	from Admlink Where Subject=@P_Subject and Type=@P_Type and DocNo=@P_DocNo and Currency=@P_Currency and Date=@P_Date

	if @LossDate is null
		set @LossDate=@P_Date 

	insert into @Admlink(AdmNo, DocNo, Date, Voucher, Amount, LAmount)
	Select A.AdmNo, A.DocNo, A.Date, A.Voucher, A.Amount*case when V.DebtorF=1 Then V.AmountDue/(V.Nominal_CC-V.Diff_CC) else -V.AmountDue/(V.Nominal_CC-V.Diff_CC) end as Amount, A.LAmount
	from Admlink A
	Inner Join VOUCHER_AMOUNTDUE(@LossDate) V on (V.Voucher=A.Voucher)
	Where A.Date<=@P_Date and A.A_PolicyNo=@P_A_PolicyNo and A.Currency=@P_Currency and A.Subject='Premium' and A.Type in ('DI','IC','IR')
	and (substring(A.A_PolicyNo,1,50)+space(50-len(A.A_PolicyNo))+convert(varchar(50), A.Date,102))<=(substring(@P_A_PolicyNo,1,50)+space(50-len(@P_A_PolicyNo))+convert(varchar(50), @P_Date,102)) 
	and Round(V.Nominal_CC-V.Diff_CC,4)>0

	Select 
	@PDate=Max(V.PDate),
	@PCT=
	sum(case When V.DebtorF=1 Then (V.Payment_CC) Else -(V.Payment_CC) end)/sum(case When V.DebtorF=1 Then (V.Nominal_CC) Else -(V.Nominal_CC) end)*100

	from (

		   Select V.Voucher, 
		   Max(V.PDate) as Pdate,
		   cast(Max(Cast(V.DebtorF as Int)) as Bit) as DebtorF,
		   Case 
		   When @P_TYPE in ('PI','PL') Then Max((V.Payment_CC+V.Payment_OC)*V.Rate)
		   When Max((V.Payment_CC+V.Payment_OC)*V.Rate)<sum((case When V.DebtorF=1 Then 1 else -1 end)*(A.LAmount)*V.Rate) Then 0
		   Else Max((V.Payment_CC+V.Payment_OC)*V.Rate)-sum((case When V.DebtorF=1 Then 1 else -1 end)*(A.LAmount)*V.Rate)
		   End as Payment_CC,

		   sum(
				  (case When V.DebtorF=1 Then 1 else -1 end)*
				  Case
				  When @P_Type in ('PI','PL') then (A.Amount)
				  Else (A.Amount-A.LAmount)
				  End*V.Rate
		   ) as Nominal_CC
		   from @Admlink A
		   Inner Join nVoucher V on (V.Voucher=A.Voucher)
		   Group By V.Voucher
	) V

	Having sum(case When V.DebtorF=1 Then (V.Nominal_CC) Else -(V.Nominal_CC) end)<>0
End

if @PCT IS NULL 
       SELECT @PCT=100

if @PCT<0
       SELECT @PCT=0

if @PCT>100
       SELECT @PCT=100

if @PDate IS NULL
	Select @PDate=cast(convert(varchar(10), getdate(),1) as smalldatetime)

insert into @Info Select @PCT, @PDate 

Return
end

GO


DROP function VOUCHER_AMOUNTDUE
GO
CREATE function VOUCHER_AMOUNTDUE(@P_Date as smalldatetime) 
RETURNS Table 
AS RETURN 
( 
Select V.Voucher, V.Remarks, V.CollNo, V.Branch, V.ProAcc, V.RefNo, V.DocNo, V.Currency, V.Installment, V.Nominal_CC, V.Diff_CC, (V.Payment_CC+V.Payment_OC) as Payment_CC, cast(0 as Float) as Payment_OC,  V.DebtorF, V.CreditorF, V.StatID, V.ActionBy, V.ActionDate,  V.AcceptedBy, V.AcceptedDate
, 
(Case When V.Installment=0 and V.DueDate <=@P_Date Then V.Nominal_CC-V.Diff_CC else 0 end+ 
Case When V.Installment>=1 and V.DueDate_1 <=@P_Date Then V.AmountDue_1 else 0 end+ 
Case When V.Installment>=2 and V.DueDate_2 <=@P_Date Then V.AmountDue_2 else 0 end+ 
Case When V.Installment>=3 and V.DueDate_3 <=@P_Date Then V.AmountDue_3 else 0 end+ 
Case When V.Installment>=4 and V.DueDate_4 <=@P_Date Then V.AmountDue_4 else 0 end+ 
Case When V.Installment>=5 and V.DueDate_5 <=@P_Date Then V.AmountDue_5 else 0 end+ 
Case When V.Installment>=6 and V.DueDate_6 <=@P_Date Then V.AmountDue_6 else 0 end+ 
Case When V.Installment>=7 and V.DueDate_7 <=@P_Date Then V.AmountDue_7 else 0 end+ 
Case When V.Installment>=8 and V.DueDate_8 <=@P_Date Then V.AmountDue_8 else 0 end+ 
Case When V.Installment>=9 and V.DueDate_9 <=@P_Date Then V.AmountDue_9 else 0 end+ 
Case When V.Installment>=10 and V.DueDate_10 <=@P_Date Then V.AmountDue_10 else 0 end+ 
Case When V.Installment>=11 and V.DueDate_11 <=@P_Date Then V.AmountDue_11 else 0 end+ 
Case When V.Installment>=12 and V.DueDate_12 <=@P_Date Then V.AmountDue_12 else 0 end+ 
Case When V.Installment>=13 and V.DueDate_13 <=@P_Date Then V.AmountDue_13 else 0 end+ 
Case When V.Installment>=14 and V.DueDate_14 <=@P_Date Then V.AmountDue_14 else 0 end+ 
Case When V.Installment>=15 and V.DueDate_15 <=@P_Date Then V.AmountDue_15 else 0 end+ 
Case When V.Installment>=16 and V.DueDate_16 <=@P_Date Then V.AmountDue_16 else 0 end+ 
Case When V.Installment>=17 and V.DueDate_17 <=@P_Date Then V.AmountDue_17 else 0 end+ 
Case When V.Installment>=18 and V.DueDate_18 <=@P_Date Then V.AmountDue_18 else 0 end+ 
Case When V.Installment>=19 and V.DueDate_19 <=@P_Date Then V.AmountDue_19 else 0 end+ 
Case When V.Installment>=20 and V.DueDate_20 <=@P_Date Then V.AmountDue_20 else 0 end+ 
Case When V.Installment>=21 and V.DueDate_21 <=@P_Date Then V.AmountDue_21 else 0 end+ 
Case When V.Installment>=22 and V.DueDate_22 <=@P_Date Then V.AmountDue_22 else 0 end+ 
Case When V.Installment>=23 and V.DueDate_23 <=@P_Date Then V.AmountDue_23 else 0 end+ 
Case When V.Installment>=24 and V.DueDate_24 <=@P_Date Then V.AmountDue_24 else 0 end) as AmountDue, 

Case When V.Installment=0 then 0
When (V.Payment_CC+V.Payment_OC)<(V.AmountDue_1) then (V.AmountDue_1)-(V.Payment_CC+V.Payment_OC)
When (V.Payment_CC+V.Payment_OC)<(V.AmountDue_1+V.AmountDue_2) then (V.AmountDue_1+V.AmountDue_2)-(V.Payment_CC+V.Payment_OC)
When (V.Payment_CC+V.Payment_OC)<(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3) then (V.AmountDue_1+V.AmountDue_2+V.AmountDue_3)-(V.Payment_CC+V.Payment_OC)
When (V.Payment_CC+V.Payment_OC)<(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4) then (V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4)-(V.Payment_CC+V.Payment_OC)
When (V.Payment_CC+V.Payment_OC)<(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5) then (V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5)-(V.Payment_CC+V.Payment_OC)
When (V.Payment_CC+V.Payment_OC)<(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6) then (V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6)-(V.Payment_CC+V.Payment_OC)
When (V.Payment_CC+V.Payment_OC)<(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7) then (V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7)-(V.Payment_CC+V.Payment_OC)
When (V.Payment_CC+V.Payment_OC)<(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8) then (V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8)-(V.Payment_CC+V.Payment_OC)
When (V.Payment_CC+V.Payment_OC)<(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9) then (V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9)-(V.Payment_CC+V.Payment_OC)
When (V.Payment_CC+V.Payment_OC)<(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10) then (V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10)-(V.Payment_CC+V.Payment_OC)
When (V.Payment_CC+V.Payment_OC)<(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11) then (V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11)-(V.Payment_CC+V.Payment_OC)
When (V.Payment_CC+V.Payment_OC)<(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12) then (V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12)-(V.Payment_CC+V.Payment_OC)
When (V.Payment_CC+V.Payment_OC)<(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13) then (V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13)-(V.Payment_CC+V.Payment_OC)
When (V.Payment_CC+V.Payment_OC)<(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14) then (V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14)-(V.Payment_CC+V.Payment_OC)
When (V.Payment_CC+V.Payment_OC)<(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15) then (V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15)-(V.Payment_CC+V.Payment_OC)
When (V.Payment_CC+V.Payment_OC)<(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16) then (V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16)-(V.Payment_CC+V.Payment_OC)
When (V.Payment_CC+V.Payment_OC)<(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16+V.AmountDue_17) then (V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16+V.AmountDue_17)-(V.Payment_CC+V.Payment_OC)
When (V.Payment_CC+V.Payment_OC)<(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16+V.AmountDue_17+V.AmountDue_18) then (V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16+V.AmountDue_17+V.AmountDue_18)-(V.Payment_CC+V.Payment_OC)
When (V.Payment_CC+V.Payment_OC)<(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16+V.AmountDue_17+V.AmountDue_18+V.AmountDue_19) then (V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16+V.AmountDue_17+V.AmountDue_18+V.AmountDue_19)-(V.Payment_CC+V.Payment_OC)
When (V.Payment_CC+V.Payment_OC)<(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16+V.AmountDue_17+V.AmountDue_18+V.AmountDue_19+V.AmountDue_20) then (V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16+V.AmountDue_17+V.AmountDue_18+V.AmountDue_19+V.AmountDue_20)-(V.Payment_CC+V.Payment_OC)
When (V.Payment_CC+V.Payment_OC)<(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16+V.AmountDue_17+V.AmountDue_18+V.AmountDue_19+V.AmountDue_20+V.AmountDue_21) then (V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16+V.AmountDue_17+V.AmountDue_18+V.AmountDue_19+V.AmountDue_20+V.AmountDue_21)-(V.Payment_CC+V.Payment_OC)
When (V.Payment_CC+V.Payment_OC)<(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16+V.AmountDue_17+V.AmountDue_18+V.AmountDue_19+V.AmountDue_20+V.AmountDue_21+V.AmountDue_22) then (V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16+V.AmountDue_17+V.AmountDue_18+V.AmountDue_19+V.AmountDue_20+V.AmountDue_21+V.AmountDue_22)-(V.Payment_CC+V.Payment_OC)
When (V.Payment_CC+V.Payment_OC)<(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16+V.AmountDue_17+V.AmountDue_18+V.AmountDue_19+V.AmountDue_20+V.AmountDue_21+V.AmountDue_22+V.AmountDue_23) then (V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16+V.AmountDue_17+V.AmountDue_18+V.AmountDue_19+V.AmountDue_20+V.AmountDue_21+V.AmountDue_22+V.AmountDue_23)-(V.Payment_CC+V.Payment_OC)
Else 0
end as AmountNextDue, 

Case 
When V.Installment>=1 and V.DueDate_1 <=@P_Date and (V.Payment_CC+V.Payment_OC)<V.AmountDue_1 then V.DueDate_1 
When V.Installment>=2 and V.DueDate_2 <=@P_Date and (V.Payment_CC+V.Payment_OC)<V.AmountDue_1+V.AmountDue_2 then V.DueDate_2 
When V.Installment>=3 and V.DueDate_3 <=@P_Date and (V.Payment_CC+V.Payment_OC)<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3 then V.DueDate_3 
When V.Installment>=4 and V.DueDate_4 <=@P_Date and (V.Payment_CC+V.Payment_OC)<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4 then V.DueDate_4 
When V.Installment>=5 and V.DueDate_5 <=@P_Date and (V.Payment_CC+V.Payment_OC)<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5 then V.DueDate_5 
When V.Installment>=6 and V.DueDate_6 <=@P_Date and (V.Payment_CC+V.Payment_OC)<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6 then V.DueDate_6 
When V.Installment>=7 and V.DueDate_7 <=@P_Date and (V.Payment_CC+V.Payment_OC)<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7 then V.DueDate_7 
When V.Installment>=8 and V.DueDate_8 <=@P_Date and (V.Payment_CC+V.Payment_OC)<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8 then V.DueDate_8 
When V.Installment>=9 and V.DueDate_9 <=@P_Date and (V.Payment_CC+V.Payment_OC)<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9 then V.DueDate_9 
When V.Installment>=10 and V.DueDate_10 <=@P_Date and (V.Payment_CC+V.Payment_OC)<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10 then V.DueDate_10 
When V.Installment>=11 and V.DueDate_11 <=@P_Date and (V.Payment_CC+V.Payment_OC)<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11 then V.DueDate_11 
When V.Installment>=12 and V.DueDate_12 <=@P_Date and (V.Payment_CC+V.Payment_OC)<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12 then V.DueDate_12 
When V.Installment>=13 and V.DueDate_13 <=@P_Date and (V.Payment_CC+V.Payment_OC)<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13 then V.DueDate_13 
When V.Installment>=14 and V.DueDate_14 <=@P_Date and (V.Payment_CC+V.Payment_OC)<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14 then V.DueDate_14 
When V.Installment>=15 and V.DueDate_15 <=@P_Date and (V.Payment_CC+V.Payment_OC)<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15 then V.DueDate_15 
When V.Installment>=16 and V.DueDate_16 <=@P_Date and (V.Payment_CC+V.Payment_OC)<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16 then V.DueDate_16 
When V.Installment>=17 and V.DueDate_17 <=@P_Date and (V.Payment_CC+V.Payment_OC)<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16+V.AmountDue_17 then V.DueDate_17 
When V.Installment>=18 and V.DueDate_18 <=@P_Date and (V.Payment_CC+V.Payment_OC)<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16+V.AmountDue_17+V.AmountDue_18 then V.DueDate_18 
When V.Installment>=19 and V.DueDate_19 <=@P_Date and (V.Payment_CC+V.Payment_OC)<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16+V.AmountDue_17+V.AmountDue_18+V.AmountDue_19 then V.DueDate_19 
When V.Installment>=20 and V.DueDate_20 <=@P_Date and (V.Payment_CC+V.Payment_OC)<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16+V.AmountDue_17+V.AmountDue_18+V.AmountDue_19+V.AmountDue_20 then V.DueDate_20 
When V.Installment>=21 and V.DueDate_21 <=@P_Date and (V.Payment_CC+V.Payment_OC)<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16+V.AmountDue_17+V.AmountDue_18+V.AmountDue_19+V.AmountDue_20+V.AmountDue_21 then V.DueDate_21 
When V.Installment>=22 and V.DueDate_22 <=@P_Date and (V.Payment_CC+V.Payment_OC)<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16+V.AmountDue_17+V.AmountDue_18+V.AmountDue_19+V.AmountDue_20+V.AmountDue_21+V.AmountDue_22 then V.DueDate_22 
When V.Installment>=23 and V.DueDate_23 <=@P_Date and (V.Payment_CC+V.Payment_OC)<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16+V.AmountDue_17+V.AmountDue_18+V.AmountDue_19+V.AmountDue_20+V.AmountDue_21+V.AmountDue_22+V.AmountDue_23 then V.DueDate_23 
When V.Installment>=24 and V.DueDate_24 <=@P_Date and (V.Payment_CC+V.Payment_OC)<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16+V.AmountDue_17+V.AmountDue_18+V.AmountDue_19+V.AmountDue_20+V.AmountDue_21+V.AmountDue_22+V.AmountDue_23+V.AmountDue_24 then V.DueDate_24
Else V.DueDate
end as DueDate, 

Case When V.INSTALLMENT=0 Then (V.Nominal_CC-V.Diff_CC)-(V.Payment_CC+V.Payment_OC) else 0 end as Outstanding_0,

Case 
When V.AmountDue_1<(V.Payment_CC+V.Payment_OC) Then 0
else V.AmountDue_1-(V.Payment_CC+V.Payment_OC) end 
+
Case WHen V.Installment=1 and (V.Payment_CC+V.Payment_OC)>(V.Nominal_CC-V.Diff_CC) Then (V.Nominal_CC-V.Diff_CC)-(V.Payment_CC+V.Payment_OC) else 0 end
as Outstanding_1,

Case 
When V.AmountDue_2<((V.Payment_CC+V.Payment_OC)-V.AmountDue_1) Then 0
When ((V.Payment_CC+V.Payment_OC)-V.AmountDue_1)<0 then V.AmountDue_2
else V.AmountDue_2-((V.Payment_CC+V.Payment_OC)-V.AmountDue_1) end 
+
Case WHen V.Installment=2 and (V.Payment_CC+V.Payment_OC)>(V.Nominal_CC-V.Diff_CC) Then (V.Nominal_CC-V.Diff_CC)-(V.Payment_CC+V.Payment_OC) else 0 end
as Outstanding_2,

Case 
When V.AmountDue_3<((V.Payment_CC+V.Payment_OC)-(V.AmountDue_1+V.AmountDue_2)) Then 0
When ((V.Payment_CC+V.Payment_OC)-(V.AmountDue_1+V.AmountDue_2))<0 then V.AmountDue_3
else V.AmountDue_3-((V.Payment_CC+V.Payment_OC)-(V.AmountDue_1+V.AmountDue_2)) end 
+
Case WHen V.Installment=3 and (V.Payment_CC+V.Payment_OC)>(V.Nominal_CC-V.Diff_CC) Then (V.Nominal_CC-V.Diff_CC)-(V.Payment_CC+V.Payment_OC) else 0 end
as Outstanding_3,

Case 
When V.AmountDue_4<((V.Payment_CC+V.Payment_OC)-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3)) Then 0
When ((V.Payment_CC+V.Payment_OC)-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3))<0 then V.AmountDue_4
else V.AmountDue_4-((V.Payment_CC+V.Payment_OC)-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3)) end 
+
Case WHen V.Installment=4 and (V.Payment_CC+V.Payment_OC)>(V.Nominal_CC-V.Diff_CC) Then (V.Nominal_CC-V.Diff_CC)-(V.Payment_CC+V.Payment_OC) else 0 end
as Outstanding_4,

Case 
When V.AmountDue_5<((V.Payment_CC+V.Payment_OC)-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4)) Then 0
When ((V.Payment_CC+V.Payment_OC)-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4))<0 then V.AmountDue_5
else V.AmountDue_5-((V.Payment_CC+V.Payment_OC)-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4)) end 
+
Case WHen V.Installment=5 and (V.Payment_CC+V.Payment_OC)>(V.Nominal_CC-V.Diff_CC) Then (V.Nominal_CC-V.Diff_CC)-(V.Payment_CC+V.Payment_OC) else 0 end
as Outstanding_5,

Case 
When V.AmountDue_6<((V.Payment_CC+V.Payment_OC)-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5)) Then 0
When ((V.Payment_CC+V.Payment_OC)-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5))<0 then V.AmountDue_6
else V.AmountDue_6-((V.Payment_CC+V.Payment_OC)-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5)) end 
+
Case WHen V.Installment=6 and (V.Payment_CC+V.Payment_OC)>(V.Nominal_CC-V.Diff_CC) Then (V.Nominal_CC-V.Diff_CC)-(V.Payment_CC+V.Payment_OC) else 0 end
as Outstanding_6,

Case 
When V.AmountDue_7<((V.Payment_CC+V.Payment_OC)-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6)) Then 0
When ((V.Payment_CC+V.Payment_OC)-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6))<0 then V.AmountDue_7
else V.AmountDue_7-((V.Payment_CC+V.Payment_OC)-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6)) end 
+
Case WHen V.Installment=7 and (V.Payment_CC+V.Payment_OC)>(V.Nominal_CC-V.Diff_CC) Then (V.Nominal_CC-V.Diff_CC)-(V.Payment_CC+V.Payment_OC) else 0 end
as Outstanding_7,

Case 
When V.AmountDue_8<((V.Payment_CC+V.Payment_OC)-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7)) Then 0
When ((V.Payment_CC+V.Payment_OC)-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7))<0 then V.AmountDue_8
else V.AmountDue_8-((V.Payment_CC+V.Payment_OC)-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7)) end 
+
Case WHen V.Installment=8 and (V.Payment_CC+V.Payment_OC)>(V.Nominal_CC-V.Diff_CC) Then (V.Nominal_CC-V.Diff_CC)-(V.Payment_CC+V.Payment_OC) else 0 end
as Outstanding_8,

Case 
When V.AmountDue_9<((V.Payment_CC+V.Payment_OC)-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8)) Then 0
When ((V.Payment_CC+V.Payment_OC)-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8))<0 then V.AmountDue_9
else V.AmountDue_9-((V.Payment_CC+V.Payment_OC)-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8)) end 
+
Case WHen V.Installment=9 and (V.Payment_CC+V.Payment_OC)>(V.Nominal_CC-V.Diff_CC) Then (V.Nominal_CC-V.Diff_CC)-(V.Payment_CC+V.Payment_OC) else 0 end
as Outstanding_9,

Case 
When V.AmountDue_10<((V.Payment_CC+V.Payment_OC)-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9)) Then 0
When ((V.Payment_CC+V.Payment_OC)-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9))<0 then V.AmountDue_10
else V.AmountDue_10-((V.Payment_CC+V.Payment_OC)-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9)) end 
+
Case WHen V.Installment=10 and (V.Payment_CC+V.Payment_OC)>(V.Nominal_CC-V.Diff_CC) Then (V.Nominal_CC-V.Diff_CC)-(V.Payment_CC+V.Payment_OC) else 0 end
as Outstanding_10,

Case 
When V.AmountDue_11<((V.Payment_CC+V.Payment_OC)-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10)) Then 0
When ((V.Payment_CC+V.Payment_OC)-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10))<0 then V.AmountDue_11
else V.AmountDue_11-((V.Payment_CC+V.Payment_OC)-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10)) end 
+
Case WHen V.Installment=11 and (V.Payment_CC+V.Payment_OC)>(V.Nominal_CC-V.Diff_CC) Then (V.Nominal_CC-V.Diff_CC)-(V.Payment_CC+V.Payment_OC) else 0 end
as Outstanding_11,
  
Case 
When V.AmountDue_12<((V.Payment_CC+V.Payment_OC)-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11)) Then 0
When ((V.Payment_CC+V.Payment_OC)-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11))<0 then V.AmountDue_12
else V.AmountDue_12-((V.Payment_CC+V.Payment_OC)-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11)) end 
+
Case WHen V.Installment=12 and (V.Payment_CC+V.Payment_OC)>(V.Nominal_CC-V.Diff_CC) Then (V.Nominal_CC-V.Diff_CC)-(V.Payment_CC+V.Payment_OC) else 0 end
as Outstanding_12,

Case 
When V.AmountDue_13<((V.Payment_CC+V.Payment_OC)-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12)) Then 0
When ((V.Payment_CC+V.Payment_OC)-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12))<0 then V.AmountDue_13
else V.AmountDue_13-((V.Payment_CC+V.Payment_OC)-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12)) end 
+
Case WHen V.Installment=13 and (V.Payment_CC+V.Payment_OC)>(V.Nominal_CC-V.Diff_CC) Then (V.Nominal_CC-V.Diff_CC)-(V.Payment_CC+V.Payment_OC) else 0 end
as Outstanding_13,

Case 
When V.AmountDue_14<((V.Payment_CC+V.Payment_OC)-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13)) Then 0
When ((V.Payment_CC+V.Payment_OC)-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13))<0 then V.AmountDue_14
else V.AmountDue_14-((V.Payment_CC+V.Payment_OC)-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13)) end 
+
Case WHen V.Installment=14 and (V.Payment_CC+V.Payment_OC)>(V.Nominal_CC-V.Diff_CC) Then (V.Nominal_CC-V.Diff_CC)-(V.Payment_CC+V.Payment_OC) else 0 end
as Outstanding_14, 
 
Case 
When V.AmountDue_15<((V.Payment_CC+V.Payment_OC)-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14)) Then 0
When ((V.Payment_CC+V.Payment_OC)-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14))<0 then V.AmountDue_15
else V.AmountDue_15-((V.Payment_CC+V.Payment_OC)-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14)) end 
+
Case WHen V.Installment=15 and (V.Payment_CC+V.Payment_OC)>(V.Nominal_CC-V.Diff_CC) Then (V.Nominal_CC-V.Diff_CC)-(V.Payment_CC+V.Payment_OC) else 0 end
as Outstanding_15, 
 
Case 
When V.AmountDue_16<((V.Payment_CC+V.Payment_OC)-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15)) Then 0
When ((V.Payment_CC+V.Payment_OC)-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15))<0 then V.AmountDue_16
else V.AmountDue_16-((V.Payment_CC+V.Payment_OC)-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15)) end 
+
Case WHen V.Installment=16 and (V.Payment_CC+V.Payment_OC)>(V.Nominal_CC-V.Diff_CC) Then (V.Nominal_CC-V.Diff_CC)-(V.Payment_CC+V.Payment_OC) else 0 end
as Outstanding_16, 

Case 
When V.AmountDue_17<((V.Payment_CC+V.Payment_OC)-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16)) Then 0
When ((V.Payment_CC+V.Payment_OC)-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16))<0 then V.AmountDue_17
else V.AmountDue_17-((V.Payment_CC+V.Payment_OC)-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16)) end 
+
Case WHen V.Installment=17 and (V.Payment_CC+V.Payment_OC)>(V.Nominal_CC-V.Diff_CC) Then (V.Nominal_CC-V.Diff_CC)-(V.Payment_CC+V.Payment_OC) else 0 end
as Outstanding_17, 

Case 
When V.AmountDue_18<((V.Payment_CC+V.Payment_OC)-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16+V.AmountDue_17)) Then 0
When ((V.Payment_CC+V.Payment_OC)-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16+V.AmountDue_17))<0 then V.AmountDue_18
else V.AmountDue_18-((V.Payment_CC+V.Payment_OC)-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16+V.AmountDue_17)) end 
+
Case WHen V.Installment=18 and (V.Payment_CC+V.Payment_OC)>(V.Nominal_CC-V.Diff_CC) Then (V.Nominal_CC-V.Diff_CC)-(V.Payment_CC+V.Payment_OC) else 0 end
as Outstanding_18, 

Case 
When V.AmountDue_19<((V.Payment_CC+V.Payment_OC)-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16+V.AmountDue_17+V.AmountDue_18)) Then 0
When ((V.Payment_CC+V.Payment_OC)-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16+V.AmountDue_17+V.AmountDue_18))<0 then V.AmountDue_19
else V.AmountDue_19-((V.Payment_CC+V.Payment_OC)-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16+V.AmountDue_17+V.AmountDue_18)) end 
+
Case WHen V.Installment=19 and (V.Payment_CC+V.Payment_OC)>(V.Nominal_CC-V.Diff_CC) Then (V.Nominal_CC-V.Diff_CC)-(V.Payment_CC+V.Payment_OC) else 0 end
as Outstanding_19, 

Case 
When V.AmountDue_20<((V.Payment_CC+V.Payment_OC)-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16+V.AmountDue_17+V.AmountDue_18+V.AmountDue_19)) Then 0
When ((V.Payment_CC+V.Payment_OC)-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16+V.AmountDue_17+V.AmountDue_18+V.AmountDue_19))<0 then V.AmountDue_20
else V.AmountDue_20-((V.Payment_CC+V.Payment_OC)-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16+V.AmountDue_17+V.AmountDue_18+V.AmountDue_19)) end 
+
Case WHen V.Installment=20 and (V.Payment_CC+V.Payment_OC)>(V.Nominal_CC-V.Diff_CC) Then (V.Nominal_CC-V.Diff_CC)-(V.Payment_CC+V.Payment_OC) else 0 end
as Outstanding_20, 
  
Case 
When V.AmountDue_21<((V.Payment_CC+V.Payment_OC)-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16+V.AmountDue_17+V.AmountDue_18+V.AmountDue_19+V.AmountDue_20)) Then 0
When ((V.Payment_CC+V.Payment_OC)-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16+V.AmountDue_17+V.AmountDue_18+V.AmountDue_19+V.AmountDue_20))<0 then V.AmountDue_21
else V.AmountDue_21-((V.Payment_CC+V.Payment_OC)-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16+V.AmountDue_17+V.AmountDue_18+V.AmountDue_19+V.AmountDue_20)) end 
+
Case WHen V.Installment=21 and (V.Payment_CC+V.Payment_OC)>(V.Nominal_CC-V.Diff_CC) Then (V.Nominal_CC-V.Diff_CC)-(V.Payment_CC+V.Payment_OC) else 0 end
as Outstanding_21, 

Case 
When V.AmountDue_22<((V.Payment_CC+V.Payment_OC)-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16+V.AmountDue_17+V.AmountDue_18+V.AmountDue_19+V.AmountDue_20+V.AmountDue_21)) Then 0
When ((V.Payment_CC+V.Payment_OC)-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16+V.AmountDue_17+V.AmountDue_18+V.AmountDue_19+V.AmountDue_20+V.AmountDue_21))<0 then V.AmountDue_22
else V.AmountDue_22-((V.Payment_CC+V.Payment_OC)-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16+V.AmountDue_17+V.AmountDue_18+V.AmountDue_19+V.AmountDue_20+V.AmountDue_21)) end 
+
Case WHen V.Installment=22 and (V.Payment_CC+V.Payment_OC)>(V.Nominal_CC-V.Diff_CC) Then (V.Nominal_CC-V.Diff_CC)-(V.Payment_CC+V.Payment_OC) else 0 end
as Outstanding_22, 

Case 
When V.AmountDue_23<((V.Payment_CC+V.Payment_OC)-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16+V.AmountDue_17+V.AmountDue_18+V.AmountDue_19+V.AmountDue_20+V.AmountDue_21+V.AmountDue_22)) Then 0
When ((V.Payment_CC+V.Payment_OC)-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16+V.AmountDue_17+V.AmountDue_18+V.AmountDue_19+V.AmountDue_20+V.AmountDue_21+V.AmountDue_22))<0 then V.AmountDue_23
else V.AmountDue_23-((V.Payment_CC+V.Payment_OC)-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16+V.AmountDue_17+V.AmountDue_18+V.AmountDue_19+V.AmountDue_20+V.AmountDue_21+V.AmountDue_22)) end 
+
Case WHen V.Installment=23 and (V.Payment_CC+V.Payment_OC)>(V.Nominal_CC-V.Diff_CC) Then (V.Nominal_CC-V.Diff_CC)-(V.Payment_CC+V.Payment_OC) else 0 end
as Outstanding_23, 
 
Case 
When V.AmountDue_24<((V.Payment_CC+V.Payment_OC)-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16+V.AmountDue_17+V.AmountDue_18+V.AmountDue_19+V.AmountDue_20+V.AmountDue_21+V.AmountDue_22+V.AmountDue_23)) Then 0
When ((V.Payment_CC+V.Payment_OC)-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16+V.AmountDue_17+V.AmountDue_18+V.AmountDue_19+V.AmountDue_20+V.AmountDue_21+V.AmountDue_22+V.AmountDue_23))<0 then V.AmountDue_24
else V.AmountDue_24-((V.Payment_CC+V.Payment_OC)-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16+V.AmountDue_17+V.AmountDue_18+V.AmountDue_19+V.AmountDue_20+V.AmountDue_21+V.AmountDue_22+V.AmountDue_23)) End
+
Case WHen V.Installment=24 and (V.Payment_CC+V.Payment_OC)>(V.Nominal_CC-V.Diff_CC) Then (V.Nominal_CC-V.Diff_CC)-(V.Payment_CC+V.Payment_OC) else 0 end
as Outstanding_24,

(Case When V.Installment<>0 then ' Installment No. ' else '' end+      
Case When V.Installment>=1 and V.DueDate_1 <=@P_Date and (V.Payment_CC+V.Payment_OC)<V.AmountDue_1 Then '1 ' else '' end+
Case When V.Installment>=2 and V.DueDate_2 <=@P_Date and (V.Payment_CC+V.Payment_OC)<V.AmountDue_1+V.AmountDue_2 Then '2 ' else '' end+
Case When V.Installment>=3 and V.DueDate_3 <=@P_Date and (V.Payment_CC+V.Payment_OC)<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3 Then '3 ' else '' end+
Case When V.Installment>=4 and V.DueDate_4 <=@P_Date and (V.Payment_CC+V.Payment_OC)<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4 Then '4 ' else '' end+
Case When V.Installment>=5 and V.DueDate_5 <=@P_Date and (V.Payment_CC+V.Payment_OC)<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5 Then '5 ' else '' end+
Case When V.Installment>=6 and V.DueDate_6 <=@P_Date and (V.Payment_CC+V.Payment_OC)<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6 Then '6 ' else '' end+
Case When V.Installment>=7 and V.DueDate_7 <=@P_Date and (V.Payment_CC+V.Payment_OC)<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7 Then '7 ' else '' end+
Case When V.Installment>=8 and V.DueDate_8 <=@P_Date and (V.Payment_CC+V.Payment_OC)<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8 Then '8 ' else '' end+
Case When V.Installment>=9 and V.DueDate_9 <=@P_Date and (V.Payment_CC+V.Payment_OC)<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9 Then '9 ' else '' end+
Case When V.Installment>=10 and V.DueDate_10 <=@P_Date and (V.Payment_CC+V.Payment_OC)<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10 Then '10 ' else '' end+
Case When V.Installment>=11 and V.DueDate_11 <=@P_Date and (V.Payment_CC+V.Payment_OC)<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11 Then '11 ' else '' end+
Case When V.Installment>=12 and V.DueDate_12 <=@P_Date and (V.Payment_CC+V.Payment_OC)<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12 Then '12 ' else '' end+
Case When V.Installment>=13 and V.DueDate_13 <=@P_Date and (V.Payment_CC+V.Payment_OC)<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13 Then '13 ' else '' end+
Case When V.Installment>=14 and V.DueDate_14 <=@P_Date and (V.Payment_CC+V.Payment_OC)<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14 Then '14 ' else '' end+
Case When V.Installment>=15 and V.DueDate_15 <=@P_Date and (V.Payment_CC+V.Payment_OC)<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15 Then '15 ' else '' end+
Case When V.Installment>=16 and V.DueDate_16 <=@P_Date and (V.Payment_CC+V.Payment_OC)<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16 Then '16 ' else '' end+
Case When V.Installment>=17 and V.DueDate_17 <=@P_Date and (V.Payment_CC+V.Payment_OC)<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16+V.AmountDue_17 Then '17 ' else '' end+
Case When V.Installment>=18 and V.DueDate_18 <=@P_Date and (V.Payment_CC+V.Payment_OC)<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16+V.AmountDue_17+V.AmountDue_18 Then '18 ' else '' end+
Case When V.Installment>=19 and V.DueDate_19 <=@P_Date and (V.Payment_CC+V.Payment_OC)<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16+V.AmountDue_17+V.AmountDue_18+V.AmountDue_19 Then '19 ' else '' end+
Case When V.Installment>=20 and V.DueDate_20 <=@P_Date and (V.Payment_CC+V.Payment_OC)<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16+V.AmountDue_17+V.AmountDue_18+V.AmountDue_19+V.AmountDue_20 Then '20 ' else '' end+
Case When V.Installment>=21 and V.DueDate_21 <=@P_Date and (V.Payment_CC+V.Payment_OC)<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16+V.AmountDue_17+V.AmountDue_18+V.AmountDue_19+V.AmountDue_20+V.AmountDue_21 Then '21 ' else '' end+
Case When V.Installment>=22 and V.DueDate_22 <=@P_Date and (V.Payment_CC+V.Payment_OC)<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16+V.AmountDue_17+V.AmountDue_18+V.AmountDue_19+V.AmountDue_20+V.AmountDue_21+V.AmountDue_22 Then '22 ' else '' end+
Case When V.Installment>=23 and V.DueDate_23 <=@P_Date and (V.Payment_CC+V.Payment_OC)<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16+V.AmountDue_17+V.AmountDue_18+V.AmountDue_19+V.AmountDue_20+V.AmountDue_21+V.AmountDue_22+V.AmountDue_23 Then '23 ' else '' end+
Case When V.Installment>=24 and V.DueDate_24 <=@P_Date and (V.Payment_CC+V.Payment_OC)<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16+V.AmountDue_17+V.AmountDue_18+V.AmountDue_19+V.AmountDue_20+V.AmountDue_21+V.AmountDue_22+V.AmountDue_23+V.AmountDue_24 Then '24 ' else '' end
+      
Case When V.Installment<>0 then 'of '+cast(V.Installment as varchar(255)) else '' end) as sInstallment,

(
Case When V.Installment>=1 and V.DueDate_1 <=@P_Date and (V.Payment_CC+V.Payment_OC)<V.AmountDue_1 
	Then ' Installment 1 : ' + 
	convert(varchar(50), cast(
	Case 
	When V.AmountDue_1<(V.Payment_CC+V.Payment_OC) Then 0
	else V.AmountDue_1-(V.Payment_CC+V.Payment_OC) end 
	+
	Case WHen V.Installment=1 and (V.Payment_CC+V.Payment_OC)>(V.Nominal_CC-V.Diff_CC) Then (V.Nominal_CC-V.Diff_CC)-(V.Payment_CC+V.Payment_OC) else 0 end
	as Money),1)+char(13)+char(10)
	else '' end+ 

Case When V.Installment>=2 and V.DueDate_2 <=@P_Date and (V.Payment_CC+V.Payment_OC)<V.AmountDue_1+V.AmountDue_2 
	Then ' Installment 2 : ' + 
	convert(varchar(50), cast(
	Case 
	When V.AmountDue_2<((V.Payment_CC+V.Payment_OC)-V.AmountDue_1) Then 0
	When ((V.Payment_CC+V.Payment_OC)-V.AmountDue_1)<0 then V.AmountDue_2
	else V.AmountDue_2-((V.Payment_CC+V.Payment_OC)-V.AmountDue_1) end 
	+
	Case WHen V.Installment=2 and (V.Payment_CC+V.Payment_OC)>(V.Nominal_CC-V.Diff_CC) Then (V.Nominal_CC-V.Diff_CC)-(V.Payment_CC+V.Payment_OC) else 0 end
	as Money),1)+char(13)+char(10)
	else '' end+ 

Case When V.Installment>=3 and V.DueDate_3 <=@P_Date and (V.Payment_CC+V.Payment_OC)<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3 
	Then ' Installment 3 : ' + 
	convert(varchar(50), cast(
	Case 
	When V.AmountDue_3<((V.Payment_CC+V.Payment_OC)-(V.AmountDue_1+V.AmountDue_2)) Then 0
	When ((V.Payment_CC+V.Payment_OC)-(V.AmountDue_1+V.AmountDue_2))<0 then V.AmountDue_3
	else V.AmountDue_3-((V.Payment_CC+V.Payment_OC)-(V.AmountDue_1+V.AmountDue_2)) end 
	+
	Case WHen V.Installment=3 and (V.Payment_CC+V.Payment_OC)>(V.Nominal_CC-V.Diff_CC) Then (V.Nominal_CC-V.Diff_CC)-(V.Payment_CC+V.Payment_OC) else 0 end
	as Money),1)+char(13)+char(10)
	else '' end+ 

Case When V.Installment>=4 and V.DueDate_4 <=@P_Date and (V.Payment_CC+V.Payment_OC)<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4 
	Then ' Installment 4 : ' + 
	convert(varchar(50), cast(
	Case 
	When V.AmountDue_4<((V.Payment_CC+V.Payment_OC)-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3)) Then 0
	When ((V.Payment_CC+V.Payment_OC)-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3))<0 then V.AmountDue_4
	else V.AmountDue_4-((V.Payment_CC+V.Payment_OC)-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3)) end 
	+
	Case WHen V.Installment=4 and (V.Payment_CC+V.Payment_OC)>(V.Nominal_CC-V.Diff_CC) Then (V.Nominal_CC-V.Diff_CC)-(V.Payment_CC+V.Payment_OC) else 0 end
	as Money),1)+char(13)+char(10)
	else '' end+ 

Case When V.Installment>=5 and V.DueDate_5 <=@P_Date and (V.Payment_CC+V.Payment_OC)<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5 
	Then ' Installment 5 : ' + 
	convert(varchar(50), cast(
	Case 
	When V.AmountDue_5<((V.Payment_CC+V.Payment_OC)-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4)) Then 0
	When ((V.Payment_CC+V.Payment_OC)-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4))<0 then V.AmountDue_5
	else V.AmountDue_5-((V.Payment_CC+V.Payment_OC)-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4)) end 
	+
	Case WHen V.Installment=5 and (V.Payment_CC+V.Payment_OC)>(V.Nominal_CC-V.Diff_CC) Then (V.Nominal_CC-V.Diff_CC)-(V.Payment_CC+V.Payment_OC) else 0 end
	as Money),1)+char(13)+char(10)
	else '' end+ 

Case When V.Installment>=6 and V.DueDate_6 <=@P_Date and (V.Payment_CC+V.Payment_OC)<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6 
	Then ' Installment 6 : ' + 
	convert(varchar(50), cast(
	Case 
	When V.AmountDue_6<((V.Payment_CC+V.Payment_OC)-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5)) Then 0
	When ((V.Payment_CC+V.Payment_OC)-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5))<0 then V.AmountDue_6
	else V.AmountDue_6-((V.Payment_CC+V.Payment_OC)-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5)) end 
	+
	Case WHen V.Installment=6 and (V.Payment_CC+V.Payment_OC)>(V.Nominal_CC-V.Diff_CC) Then (V.Nominal_CC-V.Diff_CC)-(V.Payment_CC+V.Payment_OC) else 0 end
	as Money),1)+char(13)+char(10)
	else '' end+ 

Case When V.Installment>=7 and V.DueDate_7 <=@P_Date and (V.Payment_CC+V.Payment_OC)<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7 
	Then ' Installment 7 : ' + 
	convert(varchar(50), cast(
	Case 
	When V.AmountDue_7<((V.Payment_CC+V.Payment_OC)-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6)) Then 0
	When ((V.Payment_CC+V.Payment_OC)-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6))<0 then V.AmountDue_7
	else V.AmountDue_7-((V.Payment_CC+V.Payment_OC)-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6)) end 
	+
	Case WHen V.Installment=7 and (V.Payment_CC+V.Payment_OC)>(V.Nominal_CC-V.Diff_CC) Then (V.Nominal_CC-V.Diff_CC)-(V.Payment_CC+V.Payment_OC) else 0 end
	as Money),1)+char(13)+char(10)
	else '' end+ 

Case When V.Installment>=8 and V.DueDate_8 <=@P_Date and (V.Payment_CC+V.Payment_OC)<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8 
	Then ' Installment 8 : ' + 
	convert(varchar(50), cast(
	Case 
	When V.AmountDue_8<((V.Payment_CC+V.Payment_OC)-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7)) Then 0
	When ((V.Payment_CC+V.Payment_OC)-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7))<0 then V.AmountDue_8
	else V.AmountDue_8-((V.Payment_CC+V.Payment_OC)-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7)) end 
	+
	Case WHen V.Installment=8 and (V.Payment_CC+V.Payment_OC)>(V.Nominal_CC-V.Diff_CC) Then (V.Nominal_CC-V.Diff_CC)-(V.Payment_CC+V.Payment_OC) else 0 end
	as Money),1)+char(13)+char(10)
	else '' end+ 

Case When V.Installment>=9 and V.DueDate_9 <=@P_Date and (V.Payment_CC+V.Payment_OC)<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9 
	Then ' Installment 2 : ' + 
	convert(varchar(50), cast(
	Case 
	When V.AmountDue_9<((V.Payment_CC+V.Payment_OC)-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8)) Then 0
	When ((V.Payment_CC+V.Payment_OC)-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8))<0 then V.AmountDue_9
	else V.AmountDue_9-((V.Payment_CC+V.Payment_OC)-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8)) end 
	+
	Case WHen V.Installment=9 and (V.Payment_CC+V.Payment_OC)>(V.Nominal_CC-V.Diff_CC) Then (V.Nominal_CC-V.Diff_CC)-(V.Payment_CC+V.Payment_OC) else 0 end
	as Money),1)+char(13)+char(10)
	else '' end+ 

Case When V.Installment>=10 and V.DueDate_10 <=@P_Date and (V.Payment_CC+V.Payment_OC)<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10  
	Then ' Installment 10 : ' + 
	convert(varchar(50), cast(
	Case 
	When V.AmountDue_10<((V.Payment_CC+V.Payment_OC)-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9)) Then 0
	When ((V.Payment_CC+V.Payment_OC)-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9))<0 then V.AmountDue_10
	else V.AmountDue_10-((V.Payment_CC+V.Payment_OC)-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9)) end 
	+
	Case WHen V.Installment=10 and (V.Payment_CC+V.Payment_OC)>(V.Nominal_CC-V.Diff_CC) Then (V.Nominal_CC-V.Diff_CC)-(V.Payment_CC+V.Payment_OC) else 0 end
	as Money),1)+char(13)+char(10)
	else '' end+ 

Case When V.Installment>=11 and V.DueDate_11 <=@P_Date and (V.Payment_CC+V.Payment_OC)<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11 
	Then ' Installment 11 : ' + 
	convert(varchar(50), cast(
	Case 
	When V.AmountDue_11<((V.Payment_CC+V.Payment_OC)-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10)) Then 0
	When ((V.Payment_CC+V.Payment_OC)-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10))<0 then V.AmountDue_11
	else V.AmountDue_11-((V.Payment_CC+V.Payment_OC)-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10)) end 
	+
	Case WHen V.Installment=11 and (V.Payment_CC+V.Payment_OC)>(V.Nominal_CC-V.Diff_CC) Then (V.Nominal_CC-V.Diff_CC)-(V.Payment_CC+V.Payment_OC) else 0 end
	as Money),1)+char(13)+char(10)
	else '' end+ 

Case When V.Installment>=12 and V.DueDate_12 <=@P_Date and (V.Payment_CC+V.Payment_OC)<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12 
	Then ' Installment 12 : ' + 
	convert(varchar(50), cast(
	Case 
	When V.AmountDue_12<((V.Payment_CC+V.Payment_OC)-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11)) Then 0
	When ((V.Payment_CC+V.Payment_OC)-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11))<0 then V.AmountDue_12
	else V.AmountDue_12-((V.Payment_CC+V.Payment_OC)-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11)) end 
	+
	Case WHen V.Installment=12 and (V.Payment_CC+V.Payment_OC)>(V.Nominal_CC-V.Diff_CC) Then (V.Nominal_CC-V.Diff_CC)-(V.Payment_CC+V.Payment_OC) else 0 end
	as Money),1)+char(13)+char(10)
	else '' end+ 

Case When V.Installment>=13 and V.DueDate_13 <=@P_Date and (V.Payment_CC+V.Payment_OC)<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13 
	Then ' Installment 13 : ' + 
	convert(varchar(50), cast(
	Case 
	When V.AmountDue_14<((V.Payment_CC+V.Payment_OC)-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13)) Then 0
	When ((V.Payment_CC+V.Payment_OC)-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13))<0 then V.AmountDue_14
	else V.AmountDue_14-((V.Payment_CC+V.Payment_OC)-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13)) end 
	+
	Case WHen V.Installment=13 and (V.Payment_CC+V.Payment_OC)>(V.Nominal_CC-V.Diff_CC) Then (V.Nominal_CC-V.Diff_CC)-(V.Payment_CC+V.Payment_OC) else 0 end
	as Money),1)+char(13)+char(10)
	else '' end+ 

Case When V.Installment>=14 and V.DueDate_14 <=@P_Date and (V.Payment_CC+V.Payment_OC)<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14 
	Then ' Installment 14 : ' + 
	convert(varchar(50), cast(
	Case 
	When V.AmountDue_2<((V.Payment_CC+V.Payment_OC)-V.AmountDue_1) Then 0
	When ((V.Payment_CC+V.Payment_OC)-V.AmountDue_1)<0 then V.AmountDue_2
	else V.AmountDue_2-((V.Payment_CC+V.Payment_OC)-V.AmountDue_1) end 
	+
	Case WHen V.Installment=2 and (V.Payment_CC+V.Payment_OC)>(V.Nominal_CC-V.Diff_CC) Then (V.Nominal_CC-V.Diff_CC)-(V.Payment_CC+V.Payment_OC) else 0 end
	as Money),1)+char(13)+char(10)
	else '' end+ 

Case When V.Installment>=15 and V.DueDate_15 <=@P_Date and (V.Payment_CC+V.Payment_OC)<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15 
	Then ' Installment 15 : ' + 
	convert(varchar(50), cast(
	Case 
	When V.AmountDue_15<((V.Payment_CC+V.Payment_OC)-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14)) Then 0
	When ((V.Payment_CC+V.Payment_OC)-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14))<0 then V.AmountDue_15
	else V.AmountDue_15-((V.Payment_CC+V.Payment_OC)-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14)) end 
	+
	Case WHen V.Installment=15 and (V.Payment_CC+V.Payment_OC)>(V.Nominal_CC-V.Diff_CC) Then (V.Nominal_CC-V.Diff_CC)-(V.Payment_CC+V.Payment_OC) else 0 end
	as Money),1)+char(13)+char(10)
	else '' end+ 

Case When V.Installment>=16 and V.DueDate_16 <=@P_Date and (V.Payment_CC+V.Payment_OC)<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16 
	Then ' Installment 16 : ' + 
	convert(varchar(50), cast(
	Case 
	When V.AmountDue_16<((V.Payment_CC+V.Payment_OC)-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15)) Then 0
	When ((V.Payment_CC+V.Payment_OC)-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15))<0 then V.AmountDue_16
	else V.AmountDue_16-((V.Payment_CC+V.Payment_OC)-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15)) end 
	+
	Case WHen V.Installment=16 and (V.Payment_CC+V.Payment_OC)>(V.Nominal_CC-V.Diff_CC) Then (V.Nominal_CC-V.Diff_CC)-(V.Payment_CC+V.Payment_OC) else 0 end
	as Money),1)+char(13)+char(10)
	else '' end+ 

Case When V.Installment>=17 and V.DueDate_17 <=@P_Date and (V.Payment_CC+V.Payment_OC)<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16+V.AmountDue_17 
	Then ' Installment 17 : ' + 
	convert(varchar(50), cast(
	Case 
	When V.AmountDue_17<((V.Payment_CC+V.Payment_OC)-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16)) Then 0
	When ((V.Payment_CC+V.Payment_OC)-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16))<0 then V.AmountDue_17
	else V.AmountDue_17-((V.Payment_CC+V.Payment_OC)-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16)) end 
	+
	Case WHen V.Installment=17 and (V.Payment_CC+V.Payment_OC)>(V.Nominal_CC-V.Diff_CC) Then (V.Nominal_CC-V.Diff_CC)-(V.Payment_CC+V.Payment_OC) else 0 end
	as Money),1)+char(13)+char(10)
	else '' end+ 

Case When V.Installment>=18 and V.DueDate_18 <=@P_Date and (V.Payment_CC+V.Payment_OC)<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16+V.AmountDue_17+V.AmountDue_18 
	Then ' Installment 18 : ' + 
	convert(varchar(50), cast(
	Case 
	When V.AmountDue_18<((V.Payment_CC+V.Payment_OC)-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16+V.AmountDue_17)) Then 0
	When ((V.Payment_CC+V.Payment_OC)-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16+V.AmountDue_17))<0 then V.AmountDue_18
	else V.AmountDue_18-((V.Payment_CC+V.Payment_OC)-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16+V.AmountDue_17)) end 
	+
	Case WHen V.Installment=18 and (V.Payment_CC+V.Payment_OC)>(V.Nominal_CC-V.Diff_CC) Then (V.Nominal_CC-V.Diff_CC)-(V.Payment_CC+V.Payment_OC) else 0 end
	as Money),1)+char(13)+char(10)
	else '' end+ 

Case When V.Installment>=19 and V.DueDate_19 <=@P_Date and (V.Payment_CC+V.Payment_OC)<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16+V.AmountDue_17+V.AmountDue_18+V.AmountDue_19 
	Then ' Installment 19 : ' + 
	convert(varchar(50), cast(
	Case 
	When V.AmountDue_19<((V.Payment_CC+V.Payment_OC)-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16+V.AmountDue_17+V.AmountDue_18)) Then 0
	When ((V.Payment_CC+V.Payment_OC)-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16+V.AmountDue_17+V.AmountDue_18))<0 then V.AmountDue_19
	else V.AmountDue_19-((V.Payment_CC+V.Payment_OC)-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16+V.AmountDue_17+V.AmountDue_18)) end 
	+
	Case WHen V.Installment=19 and (V.Payment_CC+V.Payment_OC)>(V.Nominal_CC-V.Diff_CC) Then (V.Nominal_CC-V.Diff_CC)-(V.Payment_CC+V.Payment_OC) else 0 end
	as Money),1)+char(13)+char(10)
	else '' end+ 

Case When V.Installment>=20 and V.DueDate_20 <=@P_Date and (V.Payment_CC+V.Payment_OC)<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16+V.AmountDue_17+V.AmountDue_18+V.AmountDue_19+V.AmountDue_20 
	Then ' Installment 20 : ' + 
	convert(varchar(50), cast(
	Case 
	When V.AmountDue_20<((V.Payment_CC+V.Payment_OC)-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16+V.AmountDue_17+V.AmountDue_18+V.AmountDue_19)) Then 0
	When ((V.Payment_CC+V.Payment_OC)-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16+V.AmountDue_17+V.AmountDue_18+V.AmountDue_19))<0 then V.AmountDue_20
	else V.AmountDue_20-((V.Payment_CC+V.Payment_OC)-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16+V.AmountDue_17+V.AmountDue_18+V.AmountDue_19)) end 
	+
	Case WHen V.Installment=20 and (V.Payment_CC+V.Payment_OC)>(V.Nominal_CC-V.Diff_CC) Then (V.Nominal_CC-V.Diff_CC)-(V.Payment_CC+V.Payment_OC) else 0 end
	as Money),1)+char(13)+char(10)
	else '' end+ 

Case When V.Installment>=21 and V.DueDate_21 <=@P_Date and (V.Payment_CC+V.Payment_OC)<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16+V.AmountDue_17+V.AmountDue_18+V.AmountDue_19+V.AmountDue_20+V.AmountDue_21 
	Then ' Installment 21 : ' + 
	convert(varchar(50), cast(
	Case 
	When V.AmountDue_21<((V.Payment_CC+V.Payment_OC)-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16+V.AmountDue_17+V.AmountDue_18+V.AmountDue_19+V.AmountDue_20)) Then 0
	When ((V.Payment_CC+V.Payment_OC)-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16+V.AmountDue_17+V.AmountDue_18+V.AmountDue_19+V.AmountDue_20))<0 then V.AmountDue_21
	else V.AmountDue_21-((V.Payment_CC+V.Payment_OC)-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16+V.AmountDue_17+V.AmountDue_18+V.AmountDue_19+V.AmountDue_20)) end 
	+
	Case WHen V.Installment=21 and (V.Payment_CC+V.Payment_OC)>(V.Nominal_CC-V.Diff_CC) Then (V.Nominal_CC-V.Diff_CC)-(V.Payment_CC+V.Payment_OC) else 0 end
	as Money),1)+char(13)+char(10)
	else '' end+ 

Case When V.Installment>=22 and V.DueDate_22 <=@P_Date and (V.Payment_CC+V.Payment_OC)<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16+V.AmountDue_17+V.AmountDue_18+V.AmountDue_19+V.AmountDue_20+V.AmountDue_21+V.AmountDue_22 
	Then ' Installment 22 : ' + 
	convert(varchar(50), cast(
	Case 
	When V.AmountDue_22<((V.Payment_CC+V.Payment_OC)-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16+V.AmountDue_17+V.AmountDue_18+V.AmountDue_19+V.AmountDue_20+V.AmountDue_21)) Then 0
	When ((V.Payment_CC+V.Payment_OC)-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16+V.AmountDue_17+V.AmountDue_18+V.AmountDue_19+V.AmountDue_20+V.AmountDue_21))<0 then V.AmountDue_22
	else V.AmountDue_22-((V.Payment_CC+V.Payment_OC)-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16+V.AmountDue_17+V.AmountDue_18+V.AmountDue_19+V.AmountDue_20+V.AmountDue_21)) end 
	+
	Case WHen V.Installment=22 and (V.Payment_CC+V.Payment_OC)>(V.Nominal_CC-V.Diff_CC) Then (V.Nominal_CC-V.Diff_CC)-(V.Payment_CC+V.Payment_OC) else 0 end
	as Money),1)+char(13)+char(10)
	else '' end+ 

Case When V.Installment>=23 and V.DueDate_23 <=@P_Date and (V.Payment_CC+V.Payment_OC)<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16+V.AmountDue_17+V.AmountDue_18+V.AmountDue_19+V.AmountDue_20+V.AmountDue_21+V.AmountDue_22+V.AmountDue_23 
	Then ' Installment 23 : ' + 
	convert(varchar(50), cast(
	Case 
	When V.AmountDue_23<((V.Payment_CC+V.Payment_OC)-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16+V.AmountDue_17+V.AmountDue_18+V.AmountDue_19+V.AmountDue_20+V.AmountDue_21+V.AmountDue_22)) Then 0
	When ((V.Payment_CC+V.Payment_OC)-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16+V.AmountDue_17+V.AmountDue_18+V.AmountDue_19+V.AmountDue_20+V.AmountDue_21+V.AmountDue_22))<0 then V.AmountDue_23
	else V.AmountDue_23-((V.Payment_CC+V.Payment_OC)-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16+V.AmountDue_17+V.AmountDue_18+V.AmountDue_19+V.AmountDue_20+V.AmountDue_21+V.AmountDue_22)) end 
	+
	Case WHen V.Installment=23 and (V.Payment_CC+V.Payment_OC)>(V.Nominal_CC-V.Diff_CC) Then (V.Nominal_CC-V.Diff_CC)-(V.Payment_CC+V.Payment_OC) else 0 end
	as Money),1)+char(13)+char(10)
	else '' end+ 

Case When V.Installment>=24 and V.DueDate_24 <=@P_Date and (V.Payment_CC+V.Payment_OC)<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16+V.AmountDue_17+V.AmountDue_18+V.AmountDue_19+V.AmountDue_20+V.AmountDue_21+V.AmountDue_22+V.AmountDue_23+V.AmountDue_24 
	Then ' Installment 24 : ' + 
	convert(varchar(50), cast(
	Case 
	When V.AmountDue_24<((V.Payment_CC+V.Payment_OC)-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16+V.AmountDue_17+V.AmountDue_18+V.AmountDue_19+V.AmountDue_20+V.AmountDue_21+V.AmountDue_22+V.AmountDue_23)) Then 0
	When ((V.Payment_CC+V.Payment_OC)-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16+V.AmountDue_17+V.AmountDue_18+V.AmountDue_19+V.AmountDue_20+V.AmountDue_21+V.AmountDue_22+V.AmountDue_23))<0 then V.AmountDue_24
	else V.AmountDue_24-((V.Payment_CC+V.Payment_OC)-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16+V.AmountDue_17+V.AmountDue_18+V.AmountDue_19+V.AmountDue_20+V.AmountDue_21+V.AmountDue_22+V.AmountDue_23)) End
	+
	Case WHen V.Installment=24 and (V.Payment_CC+V.Payment_OC)>(V.Nominal_CC-V.Diff_CC) Then (V.Nominal_CC-V.Diff_CC)-(V.Payment_CC+V.Payment_OC) else 0 end
	as Money),1)+char(13)+char(10)
	else '' end 

) as sInstallment_Ext
from nVoucher V 
Where (Round(V.Nominal_CC-V.Diff_CC-(V.Payment_CC+V.Payment_OC),4)<>0 or V.PDate>@P_Date) 
) 

GO

DROP function VOUCHER_AMOUNTPERIODDUE
GO
CREATE function VOUCHER_AMOUNTPERIODDUE(@P_SDate as smalldatetime, @P_EDate as smalldatetime)      
RETURNS Table      
AS RETURN      
(      
Select V.Voucher, V.Branch, V.ProAcc, V.RefNo, V.DocNo, V.Currency, V.Installment, V.Nominal_CC, V.Diff_CC, (V.Payment_CC+V.Payment_OC) as Payment_CC, cast(0 as Float) as Payment_OC,  V.DebtorF, V.CreditorF, V.StatID, V.ActionBy, V.ActionDate,  V.AcceptedBy, V.AcceptedDate, V.Remarks,        
(
Case When V.Installment=0 and dateadd(day,A.WPC, V.DueDate) Between @P_SDate and @P_EDate Then V.Nominal_CC-V.Diff_CC else 0 end+      
Case When V.Installment>=1 and V.DueDate_1 Between @P_SDate and @P_EDate  Then V.AmountDue_1 else 0 end+      
Case When V.Installment>=2 and V.DueDate_2 Between @P_SDate and @P_EDate  Then V.AmountDue_2 else 0 end+      
Case When V.Installment>=3 and V.DueDate_3 Between @P_SDate and @P_EDate  Then V.AmountDue_3 else 0 end+      
Case When V.Installment>=4 and V.DueDate_4 Between @P_SDate and @P_EDate  Then V.AmountDue_4 else 0 end+      
Case When V.Installment>=5 and V.DueDate_5 Between @P_SDate and @P_EDate  Then V.AmountDue_5 else 0 end+      
Case When V.Installment>=6 and V.DueDate_6 Between @P_SDate and @P_EDate  Then V.AmountDue_6 else 0 end+      
Case When V.Installment>=7 and V.DueDate_7 Between @P_SDate and @P_EDate  Then V.AmountDue_7 else 0 end+      
Case When V.Installment>=8 and V.DueDate_8 Between @P_SDate and @P_EDate  Then V.AmountDue_8 else 0 end+      
Case When V.Installment>=9 and V.DueDate_9 Between @P_SDate and @P_EDate  Then V.AmountDue_9 else 0 end+      
Case When V.Installment>=10 and V.DueDate_10 Between @P_SDate and @P_EDate  Then V.AmountDue_10 else 0 end+      
Case When V.Installment>=11 and V.DueDate_11 Between @P_SDate and @P_EDate  Then V.AmountDue_11 else 0 end+      
Case When V.Installment>=12 and V.DueDate_12 Between @P_SDate and @P_EDate  Then V.AmountDue_12 else 0 end+
Case When V.Installment>=13 and V.DueDate_13 Between @P_SDate and @P_EDate  Then V.AmountDue_13 else 0 end+      
Case When V.Installment>=14 and V.DueDate_14 Between @P_SDate and @P_EDate  Then V.AmountDue_14 else 0 end+      
Case When V.Installment>=15 and V.DueDate_15 Between @P_SDate and @P_EDate  Then V.AmountDue_15 else 0 end+      
Case When V.Installment>=16 and V.DueDate_16 Between @P_SDate and @P_EDate  Then V.AmountDue_16 else 0 end+      
Case When V.Installment>=17 and V.DueDate_17 Between @P_SDate and @P_EDate  Then V.AmountDue_17 else 0 end+      
Case When V.Installment>=18 and V.DueDate_18 Between @P_SDate and @P_EDate  Then V.AmountDue_18 else 0 end+      
Case When V.Installment>=19 and V.DueDate_19 Between @P_SDate and @P_EDate  Then V.AmountDue_19 else 0 end+      
Case When V.Installment>=20 and V.DueDate_20 Between @P_SDate and @P_EDate  Then V.AmountDue_20 else 0 end+      
Case When V.Installment>=21 and V.DueDate_21 Between @P_SDate and @P_EDate  Then V.AmountDue_21 else 0 end+      
Case When V.Installment>=22 and V.DueDate_22 Between @P_SDate and @P_EDate  Then V.AmountDue_22 else 0 end+      
Case When V.Installment>=23 and V.DueDate_23 Between @P_SDate and @P_EDate  Then V.AmountDue_23 else 0 end+      
Case When V.Installment>=24 and V.DueDate_24 Between @P_SDate and @P_EDate  Then V.AmountDue_24 else 0 end
) as AmountDue,      

Case 
When V.Installment>=1 and V.DueDate_1 Between @P_SDate and @P_EDate and (V.Payment_CC+V.Payment_OC)<V.AmountDue_1 then V.DueDate_1 
When V.Installment>=2 and V.DueDate_2 Between @P_SDate and @P_EDate and (V.Payment_CC+V.Payment_OC)<V.AmountDue_1+V.AmountDue_2 then V.DueDate_2 
When V.Installment>=3 and V.DueDate_3 Between @P_SDate and @P_EDate and (V.Payment_CC+V.Payment_OC)<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3 then V.DueDate_3 
When V.Installment>=4 and V.DueDate_4 Between @P_SDate and @P_EDate and (V.Payment_CC+V.Payment_OC)<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4 then V.DueDate_4 
When V.Installment>=5 and V.DueDate_5 Between @P_SDate and @P_EDate and (V.Payment_CC+V.Payment_OC)<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5 then V.DueDate_5 
When V.Installment>=6 and V.DueDate_6 Between @P_SDate and @P_EDate and (V.Payment_CC+V.Payment_OC)<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6 then V.DueDate_6 
When V.Installment>=7 and V.DueDate_7 Between @P_SDate and @P_EDate and (V.Payment_CC+V.Payment_OC)<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7 then V.DueDate_7 
When V.Installment>=8 and V.DueDate_8 Between @P_SDate and @P_EDate and (V.Payment_CC+V.Payment_OC)<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8 then V.DueDate_8 
When V.Installment>=9 and V.DueDate_9 Between @P_SDate and @P_EDate and (V.Payment_CC+V.Payment_OC)<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9 then V.DueDate_9 
When V.Installment>=10 and V.DueDate_10 Between @P_SDate and @P_EDate and (V.Payment_CC+V.Payment_OC)<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10 then V.DueDate_10 
When V.Installment>=11 and V.DueDate_11 Between @P_SDate and @P_EDate and (V.Payment_CC+V.Payment_OC)<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11 then V.DueDate_11 
When V.Installment>=12 and V.DueDate_12 Between @P_SDate and @P_EDate and (V.Payment_CC+V.Payment_OC)<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12 then V.DueDate_12 
When V.Installment>=13 and V.DueDate_13 Between @P_SDate and @P_EDate and (V.Payment_CC+V.Payment_OC)<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13 then V.DueDate_13 
When V.Installment>=14 and V.DueDate_14 Between @P_SDate and @P_EDate and (V.Payment_CC+V.Payment_OC)<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14 then V.DueDate_14 
When V.Installment>=15 and V.DueDate_15 Between @P_SDate and @P_EDate and (V.Payment_CC+V.Payment_OC)<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15 then V.DueDate_15 
When V.Installment>=16 and V.DueDate_16 Between @P_SDate and @P_EDate and (V.Payment_CC+V.Payment_OC)<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16 then V.DueDate_16 
When V.Installment>=17 and V.DueDate_17 Between @P_SDate and @P_EDate and (V.Payment_CC+V.Payment_OC)<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16+V.AmountDue_17 then V.DueDate_17 
When V.Installment>=18 and V.DueDate_18 Between @P_SDate and @P_EDate and (V.Payment_CC+V.Payment_OC)<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16+V.AmountDue_17+V.AmountDue_18 then V.DueDate_18 
When V.Installment>=19 and V.DueDate_19 Between @P_SDate and @P_EDate and (V.Payment_CC+V.Payment_OC)<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16+V.AmountDue_17+V.AmountDue_18+V.AmountDue_19 then V.DueDate_19 
When V.Installment>=20 and V.DueDate_20 Between @P_SDate and @P_EDate and (V.Payment_CC+V.Payment_OC)<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16+V.AmountDue_17+V.AmountDue_18+V.AmountDue_19+V.AmountDue_20 then V.DueDate_20 
When V.Installment>=21 and V.DueDate_21 Between @P_SDate and @P_EDate and (V.Payment_CC+V.Payment_OC)<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16+V.AmountDue_17+V.AmountDue_18+V.AmountDue_19+V.AmountDue_20+V.AmountDue_21 then V.DueDate_21 
When V.Installment>=22 and V.DueDate_22 Between @P_SDate and @P_EDate and (V.Payment_CC+V.Payment_OC)<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16+V.AmountDue_17+V.AmountDue_18+V.AmountDue_19+V.AmountDue_20+V.AmountDue_21+V.AmountDue_22 then V.DueDate_22 
When V.Installment>=23 and V.DueDate_23 Between @P_SDate and @P_EDate and (V.Payment_CC+V.Payment_OC)<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16+V.AmountDue_17+V.AmountDue_18+V.AmountDue_19+V.AmountDue_20+V.AmountDue_21+V.AmountDue_22+V.AmountDue_23 then V.DueDate_23 
When V.Installment>=24 and V.DueDate_24 Between @P_SDate and @P_EDate and (V.Payment_CC+V.Payment_OC)<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16+V.AmountDue_17+V.AmountDue_18+V.AmountDue_19+V.AmountDue_20+V.AmountDue_21+V.AmountDue_22+V.AmountDue_23+V.AmountDue_24 then V.DueDate_24
Else dateadd(day,A.WPC, V.DueDate)
end as DueDate, 

Case When V.INSTALLMENT=0 and dateadd(day,A.WPC, V.DueDate) Between @P_SDate and @P_EDate then
	(V.Nominal_CC-V.Diff_CC)-(V.Payment_CC+V.Payment_OC)
else 0
End +
Case When V.Installment>=1 and V.DueDate_1 Between @P_SDate and @P_EDate Then 
	Case 
	When V.AmountDue_1<(V.Payment_CC+V.Payment_OC) Then 0
	else V.AmountDue_1-(V.Payment_CC+V.Payment_OC) end 
	+
	Case WHen V.Installment=1 and (V.Payment_CC+V.Payment_OC)>(V.Nominal_CC-V.Diff_CC) Then (V.Nominal_CC-V.Diff_CC)-(V.Payment_CC+V.Payment_OC) else 0 end
Else 0
end +

Case When V.Installment>=2 and V.DueDate_2 Between @P_SDate and @P_EDate Then 
	Case 
	When V.AmountDue_2<((V.Payment_CC+V.Payment_OC)-V.AmountDue_1) Then 0
	When ((V.Payment_CC+V.Payment_OC)-V.AmountDue_1)<0 then V.AmountDue_2
	else V.AmountDue_2-((V.Payment_CC+V.Payment_OC)-V.AmountDue_1) end 
	+
	Case WHen V.Installment=2 and (V.Payment_CC+V.Payment_OC)>(V.Nominal_CC-V.Diff_CC) Then (V.Nominal_CC-V.Diff_CC)-(V.Payment_CC+V.Payment_OC) else 0 end
Else 0
end +

Case When V.Installment>=3 and V.DueDate_3 Between @P_SDate and @P_EDate Then 
	Case 
	When V.AmountDue_3<((V.Payment_CC+V.Payment_OC)-(V.AmountDue_1+V.AmountDue_2)) Then 0
	When ((V.Payment_CC+V.Payment_OC)-(V.AmountDue_1+V.AmountDue_2))<0 then V.AmountDue_3
	else V.AmountDue_3-((V.Payment_CC+V.Payment_OC)-(V.AmountDue_1+V.AmountDue_2)) end 
	+
	Case WHen V.Installment=3 and (V.Payment_CC+V.Payment_OC)>(V.Nominal_CC-V.Diff_CC) Then (V.Nominal_CC-V.Diff_CC)-(V.Payment_CC+V.Payment_OC) else 0 end
Else 0
end +

Case When V.Installment>=4 and V.DueDate_4 Between @P_SDate and @P_EDate Then 
	Case 
	When V.AmountDue_4<((V.Payment_CC+V.Payment_OC)-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3)) Then 0
	When ((V.Payment_CC+V.Payment_OC)-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3))<0 then V.AmountDue_4
	else V.AmountDue_4-((V.Payment_CC+V.Payment_OC)-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3)) end 
	+
	Case WHen V.Installment=4 and (V.Payment_CC+V.Payment_OC)>(V.Nominal_CC-V.Diff_CC) Then (V.Nominal_CC-V.Diff_CC)-(V.Payment_CC+V.Payment_OC) else 0 end
Else 0
end +

Case When V.Installment>=5 and V.DueDate_5 Between @P_SDate and @P_EDate Then 
	Case 
	When V.AmountDue_5<((V.Payment_CC+V.Payment_OC)-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4)) Then 0
	When ((V.Payment_CC+V.Payment_OC)-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4))<0 then V.AmountDue_5
	else V.AmountDue_5-((V.Payment_CC+V.Payment_OC)-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4)) end 
	+
	Case WHen V.Installment=5 and (V.Payment_CC+V.Payment_OC)>(V.Nominal_CC-V.Diff_CC) Then (V.Nominal_CC-V.Diff_CC)-(V.Payment_CC+V.Payment_OC) else 0 end
Else 0
end +

Case When V.Installment>=6 and V.DueDate_6 Between @P_SDate and @P_EDate Then 
	Case 
	When V.AmountDue_6<((V.Payment_CC+V.Payment_OC)-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5)) Then 0
	When ((V.Payment_CC+V.Payment_OC)-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5))<0 then V.AmountDue_6
	else V.AmountDue_6-((V.Payment_CC+V.Payment_OC)-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5)) end 
	+
	Case WHen V.Installment=6 and (V.Payment_CC+V.Payment_OC)>(V.Nominal_CC-V.Diff_CC) Then (V.Nominal_CC-V.Diff_CC)-(V.Payment_CC+V.Payment_OC) else 0 end
Else 0
end +

Case When V.Installment>=7 and V.DueDate_7 Between @P_SDate and @P_EDate Then 
	Case 
	When V.AmountDue_7<((V.Payment_CC+V.Payment_OC)-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6)) Then 0
	When ((V.Payment_CC+V.Payment_OC)-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6))<0 then V.AmountDue_7
	else V.AmountDue_7-((V.Payment_CC+V.Payment_OC)-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6)) end 
	+
	Case WHen V.Installment=7 and (V.Payment_CC+V.Payment_OC)>(V.Nominal_CC-V.Diff_CC) Then (V.Nominal_CC-V.Diff_CC)-(V.Payment_CC+V.Payment_OC) else 0 end
Else 0
end +

Case When V.Installment>=8 and V.DueDate_8 Between @P_SDate and @P_EDate Then 
	Case 
	When V.AmountDue_8<((V.Payment_CC+V.Payment_OC)-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7)) Then 0
	When ((V.Payment_CC+V.Payment_OC)-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7))<0 then V.AmountDue_8
	else V.AmountDue_8-((V.Payment_CC+V.Payment_OC)-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7)) end 
	+
	Case WHen V.Installment=8 and (V.Payment_CC+V.Payment_OC)>(V.Nominal_CC-V.Diff_CC) Then (V.Nominal_CC-V.Diff_CC)-(V.Payment_CC+V.Payment_OC) else 0 end
Else 0
end +

Case When V.Installment>=9 and V.DueDate_9 Between @P_SDate and @P_EDate Then 
	Case 
	When V.AmountDue_9<((V.Payment_CC+V.Payment_OC)-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8)) Then 0
	When ((V.Payment_CC+V.Payment_OC)-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8))<0 then V.AmountDue_9
	else V.AmountDue_9-((V.Payment_CC+V.Payment_OC)-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8)) end 
	+
	Case WHen V.Installment=9 and (V.Payment_CC+V.Payment_OC)>(V.Nominal_CC-V.Diff_CC) Then (V.Nominal_CC-V.Diff_CC)-(V.Payment_CC+V.Payment_OC) else 0 end
Else 0
end +

Case When V.Installment>=10 and V.DueDate_10 Between @P_SDate and @P_EDate Then 
	Case 
	When V.AmountDue_10<((V.Payment_CC+V.Payment_OC)-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9)) Then 0
	When ((V.Payment_CC+V.Payment_OC)-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9))<0 then V.AmountDue_10
	else V.AmountDue_10-((V.Payment_CC+V.Payment_OC)-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9)) end 
	+
	Case WHen V.Installment=10 and (V.Payment_CC+V.Payment_OC)>(V.Nominal_CC-V.Diff_CC) Then (V.Nominal_CC-V.Diff_CC)-(V.Payment_CC+V.Payment_OC) else 0 end
Else 0
end +

Case When V.Installment>=11 and V.DueDate_11 Between @P_SDate and @P_EDate Then 
	Case 
	When V.AmountDue_11<((V.Payment_CC+V.Payment_OC)-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10)) Then 0
	When ((V.Payment_CC+V.Payment_OC)-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10))<0 then V.AmountDue_11
	else V.AmountDue_11-((V.Payment_CC+V.Payment_OC)-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10)) end 
	+
	Case WHen V.Installment=11 and (V.Payment_CC+V.Payment_OC)>(V.Nominal_CC-V.Diff_CC) Then (V.Nominal_CC-V.Diff_CC)-(V.Payment_CC+V.Payment_OC) else 0 end
Else 0
end +

Case When V.Installment>=12 and V.DueDate_12 Between @P_SDate and @P_EDate Then 
	Case 
	When V.AmountDue_12<((V.Payment_CC+V.Payment_OC)-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11)) Then 0
	When ((V.Payment_CC+V.Payment_OC)-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11))<0 then V.AmountDue_12
	else V.AmountDue_12-((V.Payment_CC+V.Payment_OC)-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11)) end 
	+
	Case WHen V.Installment=12 and (V.Payment_CC+V.Payment_OC)>(V.Nominal_CC-V.Diff_CC) Then (V.Nominal_CC-V.Diff_CC)-(V.Payment_CC+V.Payment_OC) else 0 end
Else 0
end +

Case When V.Installment>=13 and V.DueDate_13 Between @P_SDate and @P_EDate Then 
	Case 
	When V.AmountDue_13<((V.Payment_CC+V.Payment_OC)-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12)) Then 0
	When ((V.Payment_CC+V.Payment_OC)-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12))<0 then V.AmountDue_13
	else V.AmountDue_13-((V.Payment_CC+V.Payment_OC)-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12)) end 
	+
	Case WHen V.Installment=13 and (V.Payment_CC+V.Payment_OC)>(V.Nominal_CC-V.Diff_CC) Then (V.Nominal_CC-V.Diff_CC)-(V.Payment_CC+V.Payment_OC) else 0 end
Else 0
end +

Case When V.Installment>=14 and V.DueDate_14 Between @P_SDate and @P_EDate Then 
	Case 
	When V.AmountDue_14<((V.Payment_CC+V.Payment_OC)-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13)) Then 0
	When ((V.Payment_CC+V.Payment_OC)-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13))<0 then V.AmountDue_14
	else V.AmountDue_14-((V.Payment_CC+V.Payment_OC)-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13)) end 
	+
	Case WHen V.Installment=14 and (V.Payment_CC+V.Payment_OC)>(V.Nominal_CC-V.Diff_CC) Then (V.Nominal_CC-V.Diff_CC)-(V.Payment_CC+V.Payment_OC) else 0 end

Else 0
end +

Case When V.Installment>=15 and V.DueDate_15 Between @P_SDate and @P_EDate Then 
	Case 
	When V.AmountDue_15<((V.Payment_CC+V.Payment_OC)-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14)) Then 0
	When ((V.Payment_CC+V.Payment_OC)-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14))<0 then V.AmountDue_15
	else V.AmountDue_15-((V.Payment_CC+V.Payment_OC)-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14)) end 
	+
	Case WHen V.Installment=15 and (V.Payment_CC+V.Payment_OC)>(V.Nominal_CC-V.Diff_CC) Then (V.Nominal_CC-V.Diff_CC)-(V.Payment_CC+V.Payment_OC) else 0 end
Else 0
end +

Case When V.Installment>=16 and V.DueDate_16 Between @P_SDate and @P_EDate Then  
	Case 
	When V.AmountDue_16<((V.Payment_CC+V.Payment_OC)-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15)) Then 0
	When ((V.Payment_CC+V.Payment_OC)-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15))<0 then V.AmountDue_16
	else V.AmountDue_16-((V.Payment_CC+V.Payment_OC)-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15)) end 
	+
	Case WHen V.Installment=16 and (V.Payment_CC+V.Payment_OC)>(V.Nominal_CC-V.Diff_CC) Then (V.Nominal_CC-V.Diff_CC)-(V.Payment_CC+V.Payment_OC) else 0 end
Else 0
end +

Case When V.Installment>=17 and V.DueDate_17 Between @P_SDate and @P_EDate Then  
	Case 
	When V.AmountDue_17<((V.Payment_CC+V.Payment_OC)-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16)) Then 0
	When ((V.Payment_CC+V.Payment_OC)-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16))<0 then V.AmountDue_17
	else V.AmountDue_17-((V.Payment_CC+V.Payment_OC)-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16)) end 
	+
	Case WHen V.Installment=17 and (V.Payment_CC+V.Payment_OC)>(V.Nominal_CC-V.Diff_CC) Then (V.Nominal_CC-V.Diff_CC)-(V.Payment_CC+V.Payment_OC) else 0 end
Else 0
end +

Case When V.Installment>=18 and V.DueDate_18 Between @P_SDate and @P_EDate Then  
	Case 
	When V.AmountDue_18<((V.Payment_CC+V.Payment_OC)-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16+V.AmountDue_17)) Then 0
	When ((V.Payment_CC+V.Payment_OC)-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16+V.AmountDue_17))<0 then V.AmountDue_18
	else V.AmountDue_18-((V.Payment_CC+V.Payment_OC)-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16+V.AmountDue_17)) end 
	+
	Case WHen V.Installment=18 and (V.Payment_CC+V.Payment_OC)>(V.Nominal_CC-V.Diff_CC) Then (V.Nominal_CC-V.Diff_CC)-(V.Payment_CC+V.Payment_OC) else 0 end
Else 0
end +

Case When V.Installment>=19 and V.DueDate_19 Between @P_SDate and @P_EDate Then  
	Case 
	When V.AmountDue_19<((V.Payment_CC+V.Payment_OC)-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16+V.AmountDue_17+V.AmountDue_18)) Then 0
	When ((V.Payment_CC+V.Payment_OC)-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16+V.AmountDue_17+V.AmountDue_18))<0 then V.AmountDue_19
	else V.AmountDue_19-((V.Payment_CC+V.Payment_OC)-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16+V.AmountDue_17+V.AmountDue_18)) end 
	+
	Case WHen V.Installment=19 and (V.Payment_CC+V.Payment_OC)>(V.Nominal_CC-V.Diff_CC) Then (V.Nominal_CC-V.Diff_CC)-(V.Payment_CC+V.Payment_OC) else 0 end
Else 0
end +

Case When V.Installment>=20 and V.DueDate_20 Between @P_SDate and @P_EDate Then  
	Case 
	When V.AmountDue_20<((V.Payment_CC+V.Payment_OC)-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16+V.AmountDue_17+V.AmountDue_18+V.AmountDue_19)) Then 0
	When ((V.Payment_CC+V.Payment_OC)-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16+V.AmountDue_17+V.AmountDue_18+V.AmountDue_19))<0 then V.AmountDue_20
	else V.AmountDue_20-((V.Payment_CC+V.Payment_OC)-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16+V.AmountDue_17+V.AmountDue_18+V.AmountDue_19)) end 
	+
	Case WHen V.Installment=20 and (V.Payment_CC+V.Payment_OC)>(V.Nominal_CC-V.Diff_CC) Then (V.Nominal_CC-V.Diff_CC)-(V.Payment_CC+V.Payment_OC) else 0 end
Else 0
end +
  
Case When V.Installment>=21 and V.DueDate_21 Between @P_SDate and @P_EDate Then  
	Case 
	When V.AmountDue_21<((V.Payment_CC+V.Payment_OC)-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16+V.AmountDue_17+V.AmountDue_18+V.AmountDue_19+V.AmountDue_20)) Then 0
	When ((V.Payment_CC+V.Payment_OC)-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16+V.AmountDue_17+V.AmountDue_18+V.AmountDue_19+V.AmountDue_20))<0 then V.AmountDue_21
	else V.AmountDue_21-((V.Payment_CC+V.Payment_OC)-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16+V.AmountDue_17+V.AmountDue_18+V.AmountDue_19+V.AmountDue_20)) end 
	+
	Case WHen V.Installment=21 and (V.Payment_CC+V.Payment_OC)>(V.Nominal_CC-V.Diff_CC) Then (V.Nominal_CC-V.Diff_CC)-(V.Payment_CC+V.Payment_OC) else 0 end
Else 0
end +

Case When V.Installment>=22 and V.DueDate_22 Between @P_SDate and @P_EDate Then  
	Case 
	When V.AmountDue_22<((V.Payment_CC+V.Payment_OC)-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16+V.AmountDue_17+V.AmountDue_18+V.AmountDue_19+V.AmountDue_20+V.AmountDue_21)) Then 0
	When ((V.Payment_CC+V.Payment_OC)-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16+V.AmountDue_17+V.AmountDue_18+V.AmountDue_19+V.AmountDue_20+V.AmountDue_21))<0 then V.AmountDue_22
	else V.AmountDue_22-((V.Payment_CC+V.Payment_OC)-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16+V.AmountDue_17+V.AmountDue_18+V.AmountDue_19+V.AmountDue_20+V.AmountDue_21)) end 
	+
	Case WHen V.Installment=22 and (V.Payment_CC+V.Payment_OC)>(V.Nominal_CC-V.Diff_CC) Then (V.Nominal_CC-V.Diff_CC)-(V.Payment_CC+V.Payment_OC) else 0 end
Else 0
end +

Case When V.Installment>=23 and V.DueDate_23 Between @P_SDate and @P_EDate Then  
	Case 
	When V.AmountDue_23<((V.Payment_CC+V.Payment_OC)-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16+V.AmountDue_17+V.AmountDue_18+V.AmountDue_19+V.AmountDue_20+V.AmountDue_21+V.AmountDue_22)) Then 0
	When ((V.Payment_CC+V.Payment_OC)-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16+V.AmountDue_17+V.AmountDue_18+V.AmountDue_19+V.AmountDue_20+V.AmountDue_21+V.AmountDue_22))<0 then V.AmountDue_23
	else V.AmountDue_23-((V.Payment_CC+V.Payment_OC)-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16+V.AmountDue_17+V.AmountDue_18+V.AmountDue_19+V.AmountDue_20+V.AmountDue_21+V.AmountDue_22)) end 
	+
	Case WHen V.Installment=23 and (V.Payment_CC+V.Payment_OC)>(V.Nominal_CC-V.Diff_CC) Then (V.Nominal_CC-V.Diff_CC)-(V.Payment_CC+V.Payment_OC) else 0 end
Else 0
end +

Case When V.Installment>=24 and V.DueDate_24 Between @P_SDate and @P_EDate Then   
	Case 
	When V.AmountDue_24<((V.Payment_CC+V.Payment_OC)-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16+V.AmountDue_17+V.AmountDue_18+V.AmountDue_19+V.AmountDue_20+V.AmountDue_21+V.AmountDue_22+V.AmountDue_23)) Then 0
	When ((V.Payment_CC+V.Payment_OC)-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16+V.AmountDue_17+V.AmountDue_18+V.AmountDue_19+V.AmountDue_20+V.AmountDue_21+V.AmountDue_22+V.AmountDue_23))<0 then V.AmountDue_24
	else V.AmountDue_24-((V.Payment_CC+V.Payment_OC)-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16+V.AmountDue_17+V.AmountDue_18+V.AmountDue_19+V.AmountDue_20+V.AmountDue_21+V.AmountDue_22+V.AmountDue_23)) End
	+
	Case WHen V.Installment=24 and (V.Payment_CC+V.Payment_OC)>(V.Nominal_CC-V.Diff_CC) Then (V.Nominal_CC-V.Diff_CC)-(V.Payment_CC+V.Payment_OC) else 0 end
Else 0
end as Outstanding,

(Case When V.Installment<>0 then ' Installment No. ' else '' end+      
Case When V.Installment>=1 and V.DueDate_1 Between @P_SDate and @P_EDate and (V.Payment_CC+V.Payment_OC)<V.AmountDue_1 Then '1 ' else '' end+
Case When V.Installment>=2 and V.DueDate_2 Between @P_SDate and @P_EDate and (V.Payment_CC+V.Payment_OC)<V.AmountDue_1+V.AmountDue_2 Then '2 ' else '' end+
Case When V.Installment>=3 and V.DueDate_3 Between @P_SDate and @P_EDate and (V.Payment_CC+V.Payment_OC)<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3 Then '3 ' else '' end+
Case When V.Installment>=4 and V.DueDate_4 Between @P_SDate and @P_EDate and (V.Payment_CC+V.Payment_OC)<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4 Then '4 ' else '' end+
Case When V.Installment>=5 and V.DueDate_5 Between @P_SDate and @P_EDate and (V.Payment_CC+V.Payment_OC)<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5 Then '5 ' else '' end+
Case When V.Installment>=6 and V.DueDate_6 Between @P_SDate and @P_EDate and (V.Payment_CC+V.Payment_OC)<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6 Then '6 ' else '' end+
Case When V.Installment>=7 and V.DueDate_7 Between @P_SDate and @P_EDate and (V.Payment_CC+V.Payment_OC)<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7 Then '7 ' else '' end+
Case When V.Installment>=8 and V.DueDate_8 Between @P_SDate and @P_EDate and (V.Payment_CC+V.Payment_OC)<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8 Then '8 ' else '' end+
Case When V.Installment>=9 and V.DueDate_9 Between @P_SDate and @P_EDate and (V.Payment_CC+V.Payment_OC)<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9 Then '9 ' else '' end+
Case When V.Installment>=10 and V.DueDate_10 Between @P_SDate and @P_EDate and (V.Payment_CC+V.Payment_OC)<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10 Then '10 ' else '' end+
Case When V.Installment>=11 and V.DueDate_11 Between @P_SDate and @P_EDate and (V.Payment_CC+V.Payment_OC)<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11 Then '11 ' else '' end+
Case When V.Installment>=12 and V.DueDate_12 Between @P_SDate and @P_EDate and (V.Payment_CC+V.Payment_OC)<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12 Then '12 ' else '' end+
Case When V.Installment>=13 and V.DueDate_13 Between @P_SDate and @P_EDate and (V.Payment_CC+V.Payment_OC)<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13 Then '13 ' else '' end+
Case When V.Installment>=14 and V.DueDate_14 Between @P_SDate and @P_EDate and (V.Payment_CC+V.Payment_OC)<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14 Then '14 ' else '' end+
Case When V.Installment>=15 and V.DueDate_15 Between @P_SDate and @P_EDate and (V.Payment_CC+V.Payment_OC)<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15 Then '15 ' else '' end+
Case When V.Installment>=16 and V.DueDate_16 Between @P_SDate and @P_EDate and (V.Payment_CC+V.Payment_OC)<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16 Then '16 ' else '' end+
Case When V.Installment>=17 and V.DueDate_17 Between @P_SDate and @P_EDate and (V.Payment_CC+V.Payment_OC)<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16+V.AmountDue_17 Then '17 ' else '' end+
Case When V.Installment>=18 and V.DueDate_18 Between @P_SDate and @P_EDate and (V.Payment_CC+V.Payment_OC)<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16+V.AmountDue_17+V.AmountDue_18 Then '18 ' else '' end+
Case When V.Installment>=19 and V.DueDate_19 Between @P_SDate and @P_EDate and (V.Payment_CC+V.Payment_OC)<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16+V.AmountDue_17+V.AmountDue_18+V.AmountDue_19 Then '19 ' else '' end+
Case When V.Installment>=20 and V.DueDate_20 Between @P_SDate and @P_EDate and (V.Payment_CC+V.Payment_OC)<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16+V.AmountDue_17+V.AmountDue_18+V.AmountDue_19+V.AmountDue_20 Then '20 ' else '' end+
Case When V.Installment>=21 and V.DueDate_21 Between @P_SDate and @P_EDate and (V.Payment_CC+V.Payment_OC)<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16+V.AmountDue_17+V.AmountDue_18+V.AmountDue_19+V.AmountDue_20+V.AmountDue_21 Then '21 ' else '' end+
Case When V.Installment>=22 and V.DueDate_22 Between @P_SDate and @P_EDate and (V.Payment_CC+V.Payment_OC)<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16+V.AmountDue_17+V.AmountDue_18+V.AmountDue_19+V.AmountDue_20+V.AmountDue_21+V.AmountDue_22 Then '22 ' else '' end+
Case When V.Installment>=23 and V.DueDate_23 Between @P_SDate and @P_EDate and (V.Payment_CC+V.Payment_OC)<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16+V.AmountDue_17+V.AmountDue_18+V.AmountDue_19+V.AmountDue_20+V.AmountDue_21+V.AmountDue_22+V.AmountDue_23 Then '23 ' else '' end+
Case When V.Installment>=24 and V.DueDate_24 Between @P_SDate and @P_EDate and (V.Payment_CC+V.Payment_OC)<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16+V.AmountDue_17+V.AmountDue_18+V.AmountDue_19+V.AmountDue_20+V.AmountDue_21+V.AmountDue_22+V.AmountDue_23+V.AmountDue_24 Then '24 ' else '' end
+      
Case When V.Installment<>0 then 'of '+cast(V.Installment as varchar(255)) else '' end) as sInstallment,

(
Case When V.Installment>=1 and V.DueDate_1 Between @P_SDate and @P_EDate and (V.Payment_CC+V.Payment_OC)<V.AmountDue_1 
	Then ' Installment 1 : ' + 
	convert(varchar(50), cast(
	Case 
	When V.AmountDue_1<(V.Payment_CC+V.Payment_OC) Then 0
	else V.AmountDue_1-(V.Payment_CC+V.Payment_OC) end 
	+
	Case WHen V.Installment=1 and (V.Payment_CC+V.Payment_OC)>(V.Nominal_CC-V.Diff_CC) Then (V.Nominal_CC-V.Diff_CC)-(V.Payment_CC+V.Payment_OC) else 0 end
	as Money),1)+char(13)+char(10)
	else '' end+ 

Case When V.Installment>=2 and V.DueDate_2 Between @P_SDate and @P_EDate and (V.Payment_CC+V.Payment_OC)<V.AmountDue_1+V.AmountDue_2 
	Then ' Installment 2 : ' + 
	convert(varchar(50), cast(
	Case 
	When V.AmountDue_2<((V.Payment_CC+V.Payment_OC)-V.AmountDue_1) Then 0
	When ((V.Payment_CC+V.Payment_OC)-V.AmountDue_1)<0 then V.AmountDue_2
	else V.AmountDue_2-((V.Payment_CC+V.Payment_OC)-V.AmountDue_1) end 
	+
	Case WHen V.Installment=2 and (V.Payment_CC+V.Payment_OC)>(V.Nominal_CC-V.Diff_CC) Then (V.Nominal_CC-V.Diff_CC)-(V.Payment_CC+V.Payment_OC) else 0 end
	as Money),1)+char(13)+char(10)
	else '' end+ 

Case When V.Installment>=3 and V.DueDate_3 Between @P_SDate and @P_EDate and (V.Payment_CC+V.Payment_OC)<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3 
	Then ' Installment 3 : ' + 
	convert(varchar(50), cast(
	Case 
	When V.AmountDue_3<((V.Payment_CC+V.Payment_OC)-(V.AmountDue_1+V.AmountDue_2)) Then 0
	When ((V.Payment_CC+V.Payment_OC)-(V.AmountDue_1+V.AmountDue_2))<0 then V.AmountDue_3
	else V.AmountDue_3-((V.Payment_CC+V.Payment_OC)-(V.AmountDue_1+V.AmountDue_2)) end 
	+
	Case WHen V.Installment=3 and (V.Payment_CC+V.Payment_OC)>(V.Nominal_CC-V.Diff_CC) Then (V.Nominal_CC-V.Diff_CC)-(V.Payment_CC+V.Payment_OC) else 0 end
	as Money),1)+char(13)+char(10)
	else '' end+ 

Case When V.Installment>=4 and V.DueDate_4 Between @P_SDate and @P_EDate and (V.Payment_CC+V.Payment_OC)<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4 
	Then ' Installment 4 : ' + 
	convert(varchar(50), cast(
	Case 
	When V.AmountDue_4<((V.Payment_CC+V.Payment_OC)-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3)) Then 0
	When ((V.Payment_CC+V.Payment_OC)-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3))<0 then V.AmountDue_4
	else V.AmountDue_4-((V.Payment_CC+V.Payment_OC)-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3)) end 
	+
	Case WHen V.Installment=4 and (V.Payment_CC+V.Payment_OC)>(V.Nominal_CC-V.Diff_CC) Then (V.Nominal_CC-V.Diff_CC)-(V.Payment_CC+V.Payment_OC) else 0 end
	as Money),1)+char(13)+char(10)
	else '' end+ 

Case When V.Installment>=5 and V.DueDate_5 Between @P_SDate and @P_EDate and (V.Payment_CC+V.Payment_OC)<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5 
	Then ' Installment 5 : ' + 
	convert(varchar(50), cast(
	Case 
	When V.AmountDue_5<((V.Payment_CC+V.Payment_OC)-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4)) Then 0
	When ((V.Payment_CC+V.Payment_OC)-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4))<0 then V.AmountDue_5
	else V.AmountDue_5-((V.Payment_CC+V.Payment_OC)-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4)) end 
	+
	Case WHen V.Installment=5 and (V.Payment_CC+V.Payment_OC)>(V.Nominal_CC-V.Diff_CC) Then (V.Nominal_CC-V.Diff_CC)-(V.Payment_CC+V.Payment_OC) else 0 end
	as Money),1)+char(13)+char(10)
	else '' end+ 

Case When V.Installment>=6 and V.DueDate_6 Between @P_SDate and @P_EDate and (V.Payment_CC+V.Payment_OC)<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6 
	Then ' Installment 6 : ' + 
	convert(varchar(50), cast(
	Case 
	When V.AmountDue_6<((V.Payment_CC+V.Payment_OC)-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5)) Then 0
	When ((V.Payment_CC+V.Payment_OC)-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5))<0 then V.AmountDue_6
	else V.AmountDue_6-((V.Payment_CC+V.Payment_OC)-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5)) end 
	+
	Case WHen V.Installment=6 and (V.Payment_CC+V.Payment_OC)>(V.Nominal_CC-V.Diff_CC) Then (V.Nominal_CC-V.Diff_CC)-(V.Payment_CC+V.Payment_OC) else 0 end
	as Money),1)+char(13)+char(10)
	else '' end+ 

Case When V.Installment>=7 and V.DueDate_7 Between @P_SDate and @P_EDate and (V.Payment_CC+V.Payment_OC)<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7 
	Then ' Installment 7 : ' + 
	convert(varchar(50), cast(
	Case 
	When V.AmountDue_7<((V.Payment_CC+V.Payment_OC)-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6)) Then 0
	When ((V.Payment_CC+V.Payment_OC)-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6))<0 then V.AmountDue_7
	else V.AmountDue_7-((V.Payment_CC+V.Payment_OC)-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6)) end 
	+
	Case WHen V.Installment=7 and (V.Payment_CC+V.Payment_OC)>(V.Nominal_CC-V.Diff_CC) Then (V.Nominal_CC-V.Diff_CC)-(V.Payment_CC+V.Payment_OC) else 0 end
	as Money),1)+char(13)+char(10)
	else '' end+ 

Case When V.Installment>=8 and V.DueDate_8 Between @P_SDate and @P_EDate and (V.Payment_CC+V.Payment_OC)<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8 
	Then ' Installment 8 : ' + 
	convert(varchar(50), cast(
	Case 
	When V.AmountDue_8<((V.Payment_CC+V.Payment_OC)-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7)) Then 0
	When ((V.Payment_CC+V.Payment_OC)-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7))<0 then V.AmountDue_8
	else V.AmountDue_8-((V.Payment_CC+V.Payment_OC)-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7)) end 
	+
	Case WHen V.Installment=8 and (V.Payment_CC+V.Payment_OC)>(V.Nominal_CC-V.Diff_CC) Then (V.Nominal_CC-V.Diff_CC)-(V.Payment_CC+V.Payment_OC) else 0 end
	as Money),1)+char(13)+char(10)
	else '' end+ 

Case When V.Installment>=9 and V.DueDate_9 Between @P_SDate and @P_EDate and (V.Payment_CC+V.Payment_OC)<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9 
	Then ' Installment 2 : ' + 
	convert(varchar(50), cast(
	Case 
	When V.AmountDue_9<((V.Payment_CC+V.Payment_OC)-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8)) Then 0
	When ((V.Payment_CC+V.Payment_OC)-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8))<0 then V.AmountDue_9
	else V.AmountDue_9-((V.Payment_CC+V.Payment_OC)-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8)) end 
	+
	Case WHen V.Installment=9 and (V.Payment_CC+V.Payment_OC)>(V.Nominal_CC-V.Diff_CC) Then (V.Nominal_CC-V.Diff_CC)-(V.Payment_CC+V.Payment_OC) else 0 end
	as Money),1)+char(13)+char(10)
	else '' end+ 

Case When V.Installment>=10 and V.DueDate_10 Between @P_SDate and @P_EDate and (V.Payment_CC+V.Payment_OC)<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10  
	Then ' Installment 10 : ' + 
	convert(varchar(50), cast(
	Case 
	When V.AmountDue_10<((V.Payment_CC+V.Payment_OC)-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9)) Then 0
	When ((V.Payment_CC+V.Payment_OC)-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9))<0 then V.AmountDue_10
	else V.AmountDue_10-((V.Payment_CC+V.Payment_OC)-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9)) end 
	+
	Case WHen V.Installment=10 and (V.Payment_CC+V.Payment_OC)>(V.Nominal_CC-V.Diff_CC) Then (V.Nominal_CC-V.Diff_CC)-(V.Payment_CC+V.Payment_OC) else 0 end
	as Money),1)+char(13)+char(10)
	else '' end+ 

Case When V.Installment>=11 and V.DueDate_11 Between @P_SDate and @P_EDate and (V.Payment_CC+V.Payment_OC)<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11 
	Then ' Installment 11 : ' + 
	convert(varchar(50), cast(
	Case 
	When V.AmountDue_11<((V.Payment_CC+V.Payment_OC)-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10)) Then 0
	When ((V.Payment_CC+V.Payment_OC)-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10))<0 then V.AmountDue_11
	else V.AmountDue_11-((V.Payment_CC+V.Payment_OC)-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10)) end 
	+
	Case WHen V.Installment=11 and (V.Payment_CC+V.Payment_OC)>(V.Nominal_CC-V.Diff_CC) Then (V.Nominal_CC-V.Diff_CC)-(V.Payment_CC+V.Payment_OC) else 0 end
	as Money),1)+char(13)+char(10)
	else '' end+ 

Case When V.Installment>=12 and V.DueDate_12 Between @P_SDate and @P_EDate and (V.Payment_CC+V.Payment_OC)<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12 
	Then ' Installment 12 : ' + 
	convert(varchar(50), cast(
	Case 
	When V.AmountDue_12<((V.Payment_CC+V.Payment_OC)-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11)) Then 0
	When ((V.Payment_CC+V.Payment_OC)-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11))<0 then V.AmountDue_12
	else V.AmountDue_12-((V.Payment_CC+V.Payment_OC)-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11)) end 
	+
	Case WHen V.Installment=12 and (V.Payment_CC+V.Payment_OC)>(V.Nominal_CC-V.Diff_CC) Then (V.Nominal_CC-V.Diff_CC)-(V.Payment_CC+V.Payment_OC) else 0 end
	as Money),1)+char(13)+char(10)
	else '' end+ 

Case When V.Installment>=13 and V.DueDate_13 Between @P_SDate and @P_EDate and (V.Payment_CC+V.Payment_OC)<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13 
	Then ' Installment 13 : ' + 
	convert(varchar(50), cast(
	Case 
	When V.AmountDue_14<((V.Payment_CC+V.Payment_OC)-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13)) Then 0
	When ((V.Payment_CC+V.Payment_OC)-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13))<0 then V.AmountDue_14
	else V.AmountDue_14-((V.Payment_CC+V.Payment_OC)-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13)) end 
	+
	Case WHen V.Installment=13 and (V.Payment_CC+V.Payment_OC)>(V.Nominal_CC-V.Diff_CC) Then (V.Nominal_CC-V.Diff_CC)-(V.Payment_CC+V.Payment_OC) else 0 end
	as Money),1)+char(13)+char(10)
	else '' end+ 

Case When V.Installment>=14 and V.DueDate_14 Between @P_SDate and @P_EDate and (V.Payment_CC+V.Payment_OC)<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14 
	Then ' Installment 14 : ' + 
	convert(varchar(50), cast(
	Case 
	When V.AmountDue_2<((V.Payment_CC+V.Payment_OC)-V.AmountDue_1) Then 0
	When ((V.Payment_CC+V.Payment_OC)-V.AmountDue_1)<0 then V.AmountDue_2
	else V.AmountDue_2-((V.Payment_CC+V.Payment_OC)-V.AmountDue_1) end 
	+
	Case WHen V.Installment=2 and (V.Payment_CC+V.Payment_OC)>(V.Nominal_CC-V.Diff_CC) Then (V.Nominal_CC-V.Diff_CC)-(V.Payment_CC+V.Payment_OC) else 0 end
	as Money),1)+char(13)+char(10)
	else '' end+ 

Case When V.Installment>=15 and V.DueDate_15 Between @P_SDate and @P_EDate and (V.Payment_CC+V.Payment_OC)<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15 
	Then ' Installment 15 : ' + 
	convert(varchar(50), cast(
	Case 
	When V.AmountDue_15<((V.Payment_CC+V.Payment_OC)-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14)) Then 0
	When ((V.Payment_CC+V.Payment_OC)-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14))<0 then V.AmountDue_15
	else V.AmountDue_15-((V.Payment_CC+V.Payment_OC)-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14)) end 
	+
	Case WHen V.Installment=15 and (V.Payment_CC+V.Payment_OC)>(V.Nominal_CC-V.Diff_CC) Then (V.Nominal_CC-V.Diff_CC)-(V.Payment_CC+V.Payment_OC) else 0 end
	as Money),1)+char(13)+char(10)
	else '' end+ 

Case When V.Installment>=16 and V.DueDate_16 Between @P_SDate and @P_EDate and (V.Payment_CC+V.Payment_OC)<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16 
	Then ' Installment 16 : ' + 
	convert(varchar(50), cast(
	Case 
	When V.AmountDue_16<((V.Payment_CC+V.Payment_OC)-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15)) Then 0
	When ((V.Payment_CC+V.Payment_OC)-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15))<0 then V.AmountDue_16
	else V.AmountDue_16-((V.Payment_CC+V.Payment_OC)-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15)) end 
	+
	Case WHen V.Installment=16 and (V.Payment_CC+V.Payment_OC)>(V.Nominal_CC-V.Diff_CC) Then (V.Nominal_CC-V.Diff_CC)-(V.Payment_CC+V.Payment_OC) else 0 end
	as Money),1)+char(13)+char(10)
	else '' end+ 

Case When V.Installment>=17 and V.DueDate_17 Between @P_SDate and @P_EDate and (V.Payment_CC+V.Payment_OC)<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16+V.AmountDue_17 
	Then ' Installment 17 : ' + 
	convert(varchar(50), cast(
	Case 
	When V.AmountDue_17<((V.Payment_CC+V.Payment_OC)-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16)) Then 0
	When ((V.Payment_CC+V.Payment_OC)-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16))<0 then V.AmountDue_17
	else V.AmountDue_17-((V.Payment_CC+V.Payment_OC)-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16)) end 
	+
	Case WHen V.Installment=17 and (V.Payment_CC+V.Payment_OC)>(V.Nominal_CC-V.Diff_CC) Then (V.Nominal_CC-V.Diff_CC)-(V.Payment_CC+V.Payment_OC) else 0 end
	as Money),1)+char(13)+char(10)
	else '' end+ 

Case When V.Installment>=18 and V.DueDate_18 Between @P_SDate and @P_EDate and (V.Payment_CC+V.Payment_OC)<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16+V.AmountDue_17+V.AmountDue_18 
	Then ' Installment 18 : ' + 
	convert(varchar(50), cast(
	Case 
	When V.AmountDue_18<((V.Payment_CC+V.Payment_OC)-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16+V.AmountDue_17)) Then 0
	When ((V.Payment_CC+V.Payment_OC)-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16+V.AmountDue_17))<0 then V.AmountDue_18
	else V.AmountDue_18-((V.Payment_CC+V.Payment_OC)-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16+V.AmountDue_17)) end 
	+
	Case WHen V.Installment=18 and (V.Payment_CC+V.Payment_OC)>(V.Nominal_CC-V.Diff_CC) Then (V.Nominal_CC-V.Diff_CC)-(V.Payment_CC+V.Payment_OC) else 0 end
	as Money),1)+char(13)+char(10)
	else '' end+ 

Case When V.Installment>=19 and V.DueDate_19 Between @P_SDate and @P_EDate and (V.Payment_CC+V.Payment_OC)<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16+V.AmountDue_17+V.AmountDue_18+V.AmountDue_19 
	Then ' Installment 19 : ' + 
	convert(varchar(50), cast(
	Case 
	When V.AmountDue_19<((V.Payment_CC+V.Payment_OC)-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16+V.AmountDue_17+V.AmountDue_18)) Then 0
	When ((V.Payment_CC+V.Payment_OC)-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16+V.AmountDue_17+V.AmountDue_18))<0 then V.AmountDue_19
	else V.AmountDue_19-((V.Payment_CC+V.Payment_OC)-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16+V.AmountDue_17+V.AmountDue_18)) end 
	+
	Case WHen V.Installment=19 and (V.Payment_CC+V.Payment_OC)>(V.Nominal_CC-V.Diff_CC) Then (V.Nominal_CC-V.Diff_CC)-(V.Payment_CC+V.Payment_OC) else 0 end
	as Money),1)+char(13)+char(10)
	else '' end+ 

Case When V.Installment>=20 and V.DueDate_20 Between @P_SDate and @P_EDate and (V.Payment_CC+V.Payment_OC)<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16+V.AmountDue_17+V.AmountDue_18+V.AmountDue_19+V.AmountDue_20 
	Then ' Installment 20 : ' + 
	convert(varchar(50), cast(
	Case 
	When V.AmountDue_20<((V.Payment_CC+V.Payment_OC)-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16+V.AmountDue_17+V.AmountDue_18+V.AmountDue_19)) Then 0
	When ((V.Payment_CC+V.Payment_OC)-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16+V.AmountDue_17+V.AmountDue_18+V.AmountDue_19))<0 then V.AmountDue_20
	else V.AmountDue_20-((V.Payment_CC+V.Payment_OC)-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16+V.AmountDue_17+V.AmountDue_18+V.AmountDue_19)) end 
	+
	Case WHen V.Installment=20 and (V.Payment_CC+V.Payment_OC)>(V.Nominal_CC-V.Diff_CC) Then (V.Nominal_CC-V.Diff_CC)-(V.Payment_CC+V.Payment_OC) else 0 end
	as Money),1)+char(13)+char(10)
	else '' end+ 

Case When V.Installment>=21 and V.DueDate_21 Between @P_SDate and @P_EDate and (V.Payment_CC+V.Payment_OC)<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16+V.AmountDue_17+V.AmountDue_18+V.AmountDue_19+V.AmountDue_20+V.AmountDue_21 
	Then ' Installment 21 : ' + 
	convert(varchar(50), cast(
	Case 
	When V.AmountDue_21<((V.Payment_CC+V.Payment_OC)-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16+V.AmountDue_17+V.AmountDue_18+V.AmountDue_19+V.AmountDue_20)) Then 0
	When ((V.Payment_CC+V.Payment_OC)-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16+V.AmountDue_17+V.AmountDue_18+V.AmountDue_19+V.AmountDue_20))<0 then V.AmountDue_21
	else V.AmountDue_21-((V.Payment_CC+V.Payment_OC)-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16+V.AmountDue_17+V.AmountDue_18+V.AmountDue_19+V.AmountDue_20)) end 
	+
	Case WHen V.Installment=21 and (V.Payment_CC+V.Payment_OC)>(V.Nominal_CC-V.Diff_CC) Then (V.Nominal_CC-V.Diff_CC)-(V.Payment_CC+V.Payment_OC) else 0 end
	as Money),1)+char(13)+char(10)
	else '' end+ 

Case When V.Installment>=22 and V.DueDate_22 Between @P_SDate and @P_EDate and (V.Payment_CC+V.Payment_OC)<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16+V.AmountDue_17+V.AmountDue_18+V.AmountDue_19+V.AmountDue_20+V.AmountDue_21+V.AmountDue_22 
	Then ' Installment 22 : ' + 
	convert(varchar(50), cast(
	Case 
	When V.AmountDue_22<((V.Payment_CC+V.Payment_OC)-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16+V.AmountDue_17+V.AmountDue_18+V.AmountDue_19+V.AmountDue_20+V.AmountDue_21)) Then 0
	When ((V.Payment_CC+V.Payment_OC)-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16+V.AmountDue_17+V.AmountDue_18+V.AmountDue_19+V.AmountDue_20+V.AmountDue_21))<0 then V.AmountDue_22
	else V.AmountDue_22-((V.Payment_CC+V.Payment_OC)-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16+V.AmountDue_17+V.AmountDue_18+V.AmountDue_19+V.AmountDue_20+V.AmountDue_21)) end 
	+
	Case WHen V.Installment=22 and (V.Payment_CC+V.Payment_OC)>(V.Nominal_CC-V.Diff_CC) Then (V.Nominal_CC-V.Diff_CC)-(V.Payment_CC+V.Payment_OC) else 0 end
	as Money),1)+char(13)+char(10)
	else '' end+ 

Case When V.Installment>=23 and V.DueDate_23 Between @P_SDate and @P_EDate and (V.Payment_CC+V.Payment_OC)<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16+V.AmountDue_17+V.AmountDue_18+V.AmountDue_19+V.AmountDue_20+V.AmountDue_21+V.AmountDue_22+V.AmountDue_23 
	Then ' Installment 23 : ' + 
	convert(varchar(50), cast(
	Case 
	When V.AmountDue_23<((V.Payment_CC+V.Payment_OC)-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16+V.AmountDue_17+V.AmountDue_18+V.AmountDue_19+V.AmountDue_20+V.AmountDue_21+V.AmountDue_22)) Then 0
	When ((V.Payment_CC+V.Payment_OC)-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16+V.AmountDue_17+V.AmountDue_18+V.AmountDue_19+V.AmountDue_20+V.AmountDue_21+V.AmountDue_22))<0 then V.AmountDue_23
	else V.AmountDue_23-((V.Payment_CC+V.Payment_OC)-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16+V.AmountDue_17+V.AmountDue_18+V.AmountDue_19+V.AmountDue_20+V.AmountDue_21+V.AmountDue_22)) end 
	+
	Case WHen V.Installment=23 and (V.Payment_CC+V.Payment_OC)>(V.Nominal_CC-V.Diff_CC) Then (V.Nominal_CC-V.Diff_CC)-(V.Payment_CC+V.Payment_OC) else 0 end
	as Money),1)+char(13)+char(10)
	else '' end+ 

Case When V.Installment>=24 and V.DueDate_24 Between @P_SDate and @P_EDate and (V.Payment_CC+V.Payment_OC)<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16+V.AmountDue_17+V.AmountDue_18+V.AmountDue_19+V.AmountDue_20+V.AmountDue_21+V.AmountDue_22+V.AmountDue_23+V.AmountDue_24 
	Then ' Installment 24 : ' + 
	convert(varchar(50), cast(
	Case 
	When V.AmountDue_24<((V.Payment_CC+V.Payment_OC)-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16+V.AmountDue_17+V.AmountDue_18+V.AmountDue_19+V.AmountDue_20+V.AmountDue_21+V.AmountDue_22+V.AmountDue_23)) Then 0
	When ((V.Payment_CC+V.Payment_OC)-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16+V.AmountDue_17+V.AmountDue_18+V.AmountDue_19+V.AmountDue_20+V.AmountDue_21+V.AmountDue_22+V.AmountDue_23))<0 then V.AmountDue_24
	else V.AmountDue_24-((V.Payment_CC+V.Payment_OC)-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16+V.AmountDue_17+V.AmountDue_18+V.AmountDue_19+V.AmountDue_20+V.AmountDue_21+V.AmountDue_22+V.AmountDue_23)) End
	+
	Case WHen V.Installment=24 and (V.Payment_CC+V.Payment_OC)>(V.Nominal_CC-V.Diff_CC) Then (V.Nominal_CC-V.Diff_CC)-(V.Payment_CC+V.Payment_OC) else 0 end
	as Money),1)+char(13)+char(10)
	else '' end 

) as sInstallment_Ext
    
from nVoucher V 
Outer Apply (Select top 1 WPC from Admlink A Where A.Voucher=V.Voucher) A

)      


GO

DROP function VOUCHER_AMOUNTWPCDUE
GO
CREATE function VOUCHER_AMOUNTWPCDUE(@P_Date as smalldatetime) 
RETURNS Table 
AS RETURN 
( 
Select V.Voucher, V.Remarks, V.CollNo, V.Branch, V.ProAcc, V.RefNo, V.DocNo, V.Currency, V.Installment, V.Nominal_CC, V.Diff_CC, (V.Payment_CC+V.Payment_OC) as Payment_CC, cast(0 as Float) as Payment_OC,  V.DebtorF, V.CreditorF, V.StatID, V.ActionBy, V.ActionDate,  V.AcceptedBy, V.AcceptedDate
, 
(Case When V.Installment=0 and dateadd(day, A.WPC, V.DueDate) <=@P_Date Then V.Nominal_CC-V.Diff_CC else 0 end+ 
Case When V.Installment>=1 and V.DueDate_1 <=@P_Date Then V.AmountDue_1 else 0 end+ 
Case When V.Installment>=2 and V.DueDate_2 <=@P_Date Then V.AmountDue_2 else 0 end+ 
Case When V.Installment>=3 and V.DueDate_3 <=@P_Date Then V.AmountDue_3 else 0 end+ 
Case When V.Installment>=4 and V.DueDate_4 <=@P_Date Then V.AmountDue_4 else 0 end+ 
Case When V.Installment>=5 and V.DueDate_5 <=@P_Date Then V.AmountDue_5 else 0 end+ 
Case When V.Installment>=6 and V.DueDate_6 <=@P_Date Then V.AmountDue_6 else 0 end+ 
Case When V.Installment>=7 and V.DueDate_7 <=@P_Date Then V.AmountDue_7 else 0 end+ 
Case When V.Installment>=8 and V.DueDate_8 <=@P_Date Then V.AmountDue_8 else 0 end+ 
Case When V.Installment>=9 and V.DueDate_9 <=@P_Date Then V.AmountDue_9 else 0 end+ 
Case When V.Installment>=10 and V.DueDate_10 <=@P_Date Then V.AmountDue_10 else 0 end+ 
Case When V.Installment>=11 and V.DueDate_11 <=@P_Date Then V.AmountDue_11 else 0 end+ 
Case When V.Installment>=12 and V.DueDate_12 <=@P_Date Then V.AmountDue_12 else 0 end+ 
Case When V.Installment>=13 and V.DueDate_13 <=@P_Date Then V.AmountDue_13 else 0 end+ 
Case When V.Installment>=14 and V.DueDate_14 <=@P_Date Then V.AmountDue_14 else 0 end+ 
Case When V.Installment>=15 and V.DueDate_15 <=@P_Date Then V.AmountDue_15 else 0 end+ 
Case When V.Installment>=16 and V.DueDate_16 <=@P_Date Then V.AmountDue_16 else 0 end+ 
Case When V.Installment>=17 and V.DueDate_17 <=@P_Date Then V.AmountDue_17 else 0 end+ 
Case When V.Installment>=18 and V.DueDate_18 <=@P_Date Then V.AmountDue_18 else 0 end+ 
Case When V.Installment>=19 and V.DueDate_19 <=@P_Date Then V.AmountDue_19 else 0 end+ 
Case When V.Installment>=20 and V.DueDate_20 <=@P_Date Then V.AmountDue_20 else 0 end+ 
Case When V.Installment>=21 and V.DueDate_21 <=@P_Date Then V.AmountDue_21 else 0 end+ 
Case When V.Installment>=22 and V.DueDate_22 <=@P_Date Then V.AmountDue_22 else 0 end+ 
Case When V.Installment>=23 and V.DueDate_23 <=@P_Date Then V.AmountDue_23 else 0 end+ 
Case When V.Installment>=24 and V.DueDate_24 <=@P_Date Then V.AmountDue_24 else 0 end) as AmountDue, 

Case When V.Installment=0 then 0
When (V.Payment_CC+V.Payment_OC)<(V.AmountDue_1) then (V.AmountDue_1)-(V.Payment_CC+V.Payment_OC)
When (V.Payment_CC+V.Payment_OC)<(V.AmountDue_1+V.AmountDue_2) then (V.AmountDue_1+V.AmountDue_2)-(V.Payment_CC+V.Payment_OC)
When (V.Payment_CC+V.Payment_OC)<(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3) then (V.AmountDue_1+V.AmountDue_2+V.AmountDue_3)-(V.Payment_CC+V.Payment_OC)
When (V.Payment_CC+V.Payment_OC)<(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4) then (V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4)-(V.Payment_CC+V.Payment_OC)
When (V.Payment_CC+V.Payment_OC)<(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5) then (V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5)-(V.Payment_CC+V.Payment_OC)
When (V.Payment_CC+V.Payment_OC)<(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6) then (V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6)-(V.Payment_CC+V.Payment_OC)
When (V.Payment_CC+V.Payment_OC)<(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7) then (V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7)-(V.Payment_CC+V.Payment_OC)
When (V.Payment_CC+V.Payment_OC)<(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8) then (V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8)-(V.Payment_CC+V.Payment_OC)
When (V.Payment_CC+V.Payment_OC)<(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9) then (V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9)-(V.Payment_CC+V.Payment_OC)
When (V.Payment_CC+V.Payment_OC)<(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10) then (V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10)-(V.Payment_CC+V.Payment_OC)
When (V.Payment_CC+V.Payment_OC)<(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11) then (V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11)-(V.Payment_CC+V.Payment_OC)
When (V.Payment_CC+V.Payment_OC)<(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12) then (V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12)-(V.Payment_CC+V.Payment_OC)
When (V.Payment_CC+V.Payment_OC)<(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13) then (V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13)-(V.Payment_CC+V.Payment_OC)
When (V.Payment_CC+V.Payment_OC)<(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14) then (V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14)-(V.Payment_CC+V.Payment_OC)
When (V.Payment_CC+V.Payment_OC)<(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15) then (V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15)-(V.Payment_CC+V.Payment_OC)
When (V.Payment_CC+V.Payment_OC)<(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16) then (V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16)-(V.Payment_CC+V.Payment_OC)
When (V.Payment_CC+V.Payment_OC)<(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16+V.AmountDue_17) then (V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16+V.AmountDue_17)-(V.Payment_CC+V.Payment_OC)
When (V.Payment_CC+V.Payment_OC)<(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16+V.AmountDue_17+V.AmountDue_18) then (V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16+V.AmountDue_17+V.AmountDue_18)-(V.Payment_CC+V.Payment_OC)
When (V.Payment_CC+V.Payment_OC)<(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16+V.AmountDue_17+V.AmountDue_18+V.AmountDue_19) then (V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16+V.AmountDue_17+V.AmountDue_18+V.AmountDue_19)-(V.Payment_CC+V.Payment_OC)
When (V.Payment_CC+V.Payment_OC)<(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16+V.AmountDue_17+V.AmountDue_18+V.AmountDue_19+V.AmountDue_20) then (V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16+V.AmountDue_17+V.AmountDue_18+V.AmountDue_19+V.AmountDue_20)-(V.Payment_CC+V.Payment_OC)
When (V.Payment_CC+V.Payment_OC)<(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16+V.AmountDue_17+V.AmountDue_18+V.AmountDue_19+V.AmountDue_20+V.AmountDue_21) then (V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16+V.AmountDue_17+V.AmountDue_18+V.AmountDue_19+V.AmountDue_20+V.AmountDue_21)-(V.Payment_CC+V.Payment_OC)
When (V.Payment_CC+V.Payment_OC)<(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16+V.AmountDue_17+V.AmountDue_18+V.AmountDue_19+V.AmountDue_20+V.AmountDue_21+V.AmountDue_22) then (V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16+V.AmountDue_17+V.AmountDue_18+V.AmountDue_19+V.AmountDue_20+V.AmountDue_21+V.AmountDue_22)-(V.Payment_CC+V.Payment_OC)
When (V.Payment_CC+V.Payment_OC)<(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16+V.AmountDue_17+V.AmountDue_18+V.AmountDue_19+V.AmountDue_20+V.AmountDue_21+V.AmountDue_22+V.AmountDue_23) then (V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16+V.AmountDue_17+V.AmountDue_18+V.AmountDue_19+V.AmountDue_20+V.AmountDue_21+V.AmountDue_22+V.AmountDue_23)-(V.Payment_CC+V.Payment_OC)
Else 0
end as AmountNextDue, 

Case 
When V.Installment>=1 and V.DueDate_1 <=@P_Date and (V.Payment_CC+V.Payment_OC)<V.AmountDue_1 then V.DueDate_1 
When V.Installment>=2 and V.DueDate_2 <=@P_Date and (V.Payment_CC+V.Payment_OC)<V.AmountDue_1+V.AmountDue_2 then V.DueDate_2 
When V.Installment>=3 and V.DueDate_3 <=@P_Date and (V.Payment_CC+V.Payment_OC)<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3 then V.DueDate_3 
When V.Installment>=4 and V.DueDate_4 <=@P_Date and (V.Payment_CC+V.Payment_OC)<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4 then V.DueDate_4 
When V.Installment>=5 and V.DueDate_5 <=@P_Date and (V.Payment_CC+V.Payment_OC)<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5 then V.DueDate_5 
When V.Installment>=6 and V.DueDate_6 <=@P_Date and (V.Payment_CC+V.Payment_OC)<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6 then V.DueDate_6 
When V.Installment>=7 and V.DueDate_7 <=@P_Date and (V.Payment_CC+V.Payment_OC)<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7 then V.DueDate_7 
When V.Installment>=8 and V.DueDate_8 <=@P_Date and (V.Payment_CC+V.Payment_OC)<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8 then V.DueDate_8 
When V.Installment>=9 and V.DueDate_9 <=@P_Date and (V.Payment_CC+V.Payment_OC)<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9 then V.DueDate_9 
When V.Installment>=10 and V.DueDate_10 <=@P_Date and (V.Payment_CC+V.Payment_OC)<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10 then V.DueDate_10 
When V.Installment>=11 and V.DueDate_11 <=@P_Date and (V.Payment_CC+V.Payment_OC)<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11 then V.DueDate_11 
When V.Installment>=12 and V.DueDate_12 <=@P_Date and (V.Payment_CC+V.Payment_OC)<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12 then V.DueDate_12 
When V.Installment>=13 and V.DueDate_13 <=@P_Date and (V.Payment_CC+V.Payment_OC)<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13 then V.DueDate_13 
When V.Installment>=14 and V.DueDate_14 <=@P_Date and (V.Payment_CC+V.Payment_OC)<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14 then V.DueDate_14 
When V.Installment>=15 and V.DueDate_15 <=@P_Date and (V.Payment_CC+V.Payment_OC)<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15 then V.DueDate_15 
When V.Installment>=16 and V.DueDate_16 <=@P_Date and (V.Payment_CC+V.Payment_OC)<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16 then V.DueDate_16 
When V.Installment>=17 and V.DueDate_17 <=@P_Date and (V.Payment_CC+V.Payment_OC)<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16+V.AmountDue_17 then V.DueDate_17 
When V.Installment>=18 and V.DueDate_18 <=@P_Date and (V.Payment_CC+V.Payment_OC)<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16+V.AmountDue_17+V.AmountDue_18 then V.DueDate_18 
When V.Installment>=19 and V.DueDate_19 <=@P_Date and (V.Payment_CC+V.Payment_OC)<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16+V.AmountDue_17+V.AmountDue_18+V.AmountDue_19 then V.DueDate_19 
When V.Installment>=20 and V.DueDate_20 <=@P_Date and (V.Payment_CC+V.Payment_OC)<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16+V.AmountDue_17+V.AmountDue_18+V.AmountDue_19+V.AmountDue_20 then V.DueDate_20 
When V.Installment>=21 and V.DueDate_21 <=@P_Date and (V.Payment_CC+V.Payment_OC)<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16+V.AmountDue_17+V.AmountDue_18+V.AmountDue_19+V.AmountDue_20+V.AmountDue_21 then V.DueDate_21 
When V.Installment>=22 and V.DueDate_22 <=@P_Date and (V.Payment_CC+V.Payment_OC)<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16+V.AmountDue_17+V.AmountDue_18+V.AmountDue_19+V.AmountDue_20+V.AmountDue_21+V.AmountDue_22 then V.DueDate_22 
When V.Installment>=23 and V.DueDate_23 <=@P_Date and (V.Payment_CC+V.Payment_OC)<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16+V.AmountDue_17+V.AmountDue_18+V.AmountDue_19+V.AmountDue_20+V.AmountDue_21+V.AmountDue_22+V.AmountDue_23 then V.DueDate_23 
When V.Installment>=24 and V.DueDate_24 <=@P_Date and (V.Payment_CC+V.Payment_OC)<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16+V.AmountDue_17+V.AmountDue_18+V.AmountDue_19+V.AmountDue_20+V.AmountDue_21+V.AmountDue_22+V.AmountDue_23+V.AmountDue_24 then V.DueDate_24
Else dateadd(day, A.WPC, V.DueDate)
end as DueDate, 

Case When V.INSTALLMENT=0 Then (V.Nominal_CC-V.Diff_CC)-(V.Payment_CC+V.Payment_OC) else 0 end as Outstanding_0,

Case 
When V.AmountDue_1<(V.Payment_CC+V.Payment_OC) Then 0
else V.AmountDue_1-(V.Payment_CC+V.Payment_OC) end 
+
Case WHen V.Installment=1 and (V.Payment_CC+V.Payment_OC)>(V.Nominal_CC-V.Diff_CC) Then (V.Nominal_CC-V.Diff_CC)-(V.Payment_CC+V.Payment_OC) else 0 end
as Outstanding_1,

Case 
When V.AmountDue_2<((V.Payment_CC+V.Payment_OC)-V.AmountDue_1) Then 0
When ((V.Payment_CC+V.Payment_OC)-V.AmountDue_1)<0 then V.AmountDue_2
else V.AmountDue_2-((V.Payment_CC+V.Payment_OC)-V.AmountDue_1) end 
+
Case WHen V.Installment=2 and (V.Payment_CC+V.Payment_OC)>(V.Nominal_CC-V.Diff_CC) Then (V.Nominal_CC-V.Diff_CC)-(V.Payment_CC+V.Payment_OC) else 0 end
as Outstanding_2,

Case 
When V.AmountDue_3<((V.Payment_CC+V.Payment_OC)-(V.AmountDue_1+V.AmountDue_2)) Then 0
When ((V.Payment_CC+V.Payment_OC)-(V.AmountDue_1+V.AmountDue_2))<0 then V.AmountDue_3
else V.AmountDue_3-((V.Payment_CC+V.Payment_OC)-(V.AmountDue_1+V.AmountDue_2)) end 
+
Case WHen V.Installment=3 and (V.Payment_CC+V.Payment_OC)>(V.Nominal_CC-V.Diff_CC) Then (V.Nominal_CC-V.Diff_CC)-(V.Payment_CC+V.Payment_OC) else 0 end
as Outstanding_3,

Case 
When V.AmountDue_4<((V.Payment_CC+V.Payment_OC)-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3)) Then 0
When ((V.Payment_CC+V.Payment_OC)-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3))<0 then V.AmountDue_4
else V.AmountDue_4-((V.Payment_CC+V.Payment_OC)-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3)) end 
+
Case WHen V.Installment=4 and (V.Payment_CC+V.Payment_OC)>(V.Nominal_CC-V.Diff_CC) Then (V.Nominal_CC-V.Diff_CC)-(V.Payment_CC+V.Payment_OC) else 0 end
as Outstanding_4,

Case 
When V.AmountDue_5<((V.Payment_CC+V.Payment_OC)-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4)) Then 0
When ((V.Payment_CC+V.Payment_OC)-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4))<0 then V.AmountDue_5
else V.AmountDue_5-((V.Payment_CC+V.Payment_OC)-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4)) end 
+
Case WHen V.Installment=5 and (V.Payment_CC+V.Payment_OC)>(V.Nominal_CC-V.Diff_CC) Then (V.Nominal_CC-V.Diff_CC)-(V.Payment_CC+V.Payment_OC) else 0 end
as Outstanding_5,

Case 
When V.AmountDue_6<((V.Payment_CC+V.Payment_OC)-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5)) Then 0
When ((V.Payment_CC+V.Payment_OC)-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5))<0 then V.AmountDue_6
else V.AmountDue_6-((V.Payment_CC+V.Payment_OC)-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5)) end 
+
Case WHen V.Installment=6 and (V.Payment_CC+V.Payment_OC)>(V.Nominal_CC-V.Diff_CC) Then (V.Nominal_CC-V.Diff_CC)-(V.Payment_CC+V.Payment_OC) else 0 end
as Outstanding_6,

Case 
When V.AmountDue_7<((V.Payment_CC+V.Payment_OC)-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6)) Then 0
When ((V.Payment_CC+V.Payment_OC)-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6))<0 then V.AmountDue_7
else V.AmountDue_7-((V.Payment_CC+V.Payment_OC)-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6)) end 
+
Case WHen V.Installment=7 and (V.Payment_CC+V.Payment_OC)>(V.Nominal_CC-V.Diff_CC) Then (V.Nominal_CC-V.Diff_CC)-(V.Payment_CC+V.Payment_OC) else 0 end
as Outstanding_7,

Case 
When V.AmountDue_8<((V.Payment_CC+V.Payment_OC)-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7)) Then 0
When ((V.Payment_CC+V.Payment_OC)-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7))<0 then V.AmountDue_8
else V.AmountDue_8-((V.Payment_CC+V.Payment_OC)-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7)) end 
+
Case WHen V.Installment=8 and (V.Payment_CC+V.Payment_OC)>(V.Nominal_CC-V.Diff_CC) Then (V.Nominal_CC-V.Diff_CC)-(V.Payment_CC+V.Payment_OC) else 0 end
as Outstanding_8,

Case 
When V.AmountDue_9<((V.Payment_CC+V.Payment_OC)-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8)) Then 0
When ((V.Payment_CC+V.Payment_OC)-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8))<0 then V.AmountDue_9
else V.AmountDue_9-((V.Payment_CC+V.Payment_OC)-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8)) end 
+
Case WHen V.Installment=9 and (V.Payment_CC+V.Payment_OC)>(V.Nominal_CC-V.Diff_CC) Then (V.Nominal_CC-V.Diff_CC)-(V.Payment_CC+V.Payment_OC) else 0 end
as Outstanding_9,

Case 
When V.AmountDue_10<((V.Payment_CC+V.Payment_OC)-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9)) Then 0
When ((V.Payment_CC+V.Payment_OC)-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9))<0 then V.AmountDue_10
else V.AmountDue_10-((V.Payment_CC+V.Payment_OC)-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9)) end 
+
Case WHen V.Installment=10 and (V.Payment_CC+V.Payment_OC)>(V.Nominal_CC-V.Diff_CC) Then (V.Nominal_CC-V.Diff_CC)-(V.Payment_CC+V.Payment_OC) else 0 end
as Outstanding_10,

Case 
When V.AmountDue_11<((V.Payment_CC+V.Payment_OC)-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10)) Then 0
When ((V.Payment_CC+V.Payment_OC)-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10))<0 then V.AmountDue_11
else V.AmountDue_11-((V.Payment_CC+V.Payment_OC)-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10)) end 
+
Case WHen V.Installment=11 and (V.Payment_CC+V.Payment_OC)>(V.Nominal_CC-V.Diff_CC) Then (V.Nominal_CC-V.Diff_CC)-(V.Payment_CC+V.Payment_OC) else 0 end
as Outstanding_11,
  
Case 
When V.AmountDue_12<((V.Payment_CC+V.Payment_OC)-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11)) Then 0
When ((V.Payment_CC+V.Payment_OC)-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11))<0 then V.AmountDue_12
else V.AmountDue_12-((V.Payment_CC+V.Payment_OC)-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11)) end 
+
Case WHen V.Installment=12 and (V.Payment_CC+V.Payment_OC)>(V.Nominal_CC-V.Diff_CC) Then (V.Nominal_CC-V.Diff_CC)-(V.Payment_CC+V.Payment_OC) else 0 end
as Outstanding_12,

Case 
When V.AmountDue_13<((V.Payment_CC+V.Payment_OC)-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12)) Then 0
When ((V.Payment_CC+V.Payment_OC)-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12))<0 then V.AmountDue_13
else V.AmountDue_13-((V.Payment_CC+V.Payment_OC)-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12)) end 
+
Case WHen V.Installment=13 and (V.Payment_CC+V.Payment_OC)>(V.Nominal_CC-V.Diff_CC) Then (V.Nominal_CC-V.Diff_CC)-(V.Payment_CC+V.Payment_OC) else 0 end
as Outstanding_13,

Case 
When V.AmountDue_14<((V.Payment_CC+V.Payment_OC)-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13)) Then 0
When ((V.Payment_CC+V.Payment_OC)-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13))<0 then V.AmountDue_14
else V.AmountDue_14-((V.Payment_CC+V.Payment_OC)-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13)) end 
+
Case WHen V.Installment=14 and (V.Payment_CC+V.Payment_OC)>(V.Nominal_CC-V.Diff_CC) Then (V.Nominal_CC-V.Diff_CC)-(V.Payment_CC+V.Payment_OC) else 0 end
as Outstanding_14, 
 
Case 
When V.AmountDue_15<((V.Payment_CC+V.Payment_OC)-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14)) Then 0
When ((V.Payment_CC+V.Payment_OC)-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14))<0 then V.AmountDue_15
else V.AmountDue_15-((V.Payment_CC+V.Payment_OC)-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14)) end 
+
Case WHen V.Installment=15 and (V.Payment_CC+V.Payment_OC)>(V.Nominal_CC-V.Diff_CC) Then (V.Nominal_CC-V.Diff_CC)-(V.Payment_CC+V.Payment_OC) else 0 end
as Outstanding_15, 
 
Case 
When V.AmountDue_16<((V.Payment_CC+V.Payment_OC)-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15)) Then 0
When ((V.Payment_CC+V.Payment_OC)-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15))<0 then V.AmountDue_16
else V.AmountDue_16-((V.Payment_CC+V.Payment_OC)-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15)) end 
+
Case WHen V.Installment=16 and (V.Payment_CC+V.Payment_OC)>(V.Nominal_CC-V.Diff_CC) Then (V.Nominal_CC-V.Diff_CC)-(V.Payment_CC+V.Payment_OC) else 0 end
as Outstanding_16, 

Case 
When V.AmountDue_17<((V.Payment_CC+V.Payment_OC)-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16)) Then 0
When ((V.Payment_CC+V.Payment_OC)-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16))<0 then V.AmountDue_17
else V.AmountDue_17-((V.Payment_CC+V.Payment_OC)-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16)) end 
+
Case WHen V.Installment=17 and (V.Payment_CC+V.Payment_OC)>(V.Nominal_CC-V.Diff_CC) Then (V.Nominal_CC-V.Diff_CC)-(V.Payment_CC+V.Payment_OC) else 0 end
as Outstanding_17, 

Case 
When V.AmountDue_18<((V.Payment_CC+V.Payment_OC)-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16+V.AmountDue_17)) Then 0
When ((V.Payment_CC+V.Payment_OC)-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16+V.AmountDue_17))<0 then V.AmountDue_18
else V.AmountDue_18-((V.Payment_CC+V.Payment_OC)-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16+V.AmountDue_17)) end 
+
Case WHen V.Installment=18 and (V.Payment_CC+V.Payment_OC)>(V.Nominal_CC-V.Diff_CC) Then (V.Nominal_CC-V.Diff_CC)-(V.Payment_CC+V.Payment_OC) else 0 end
as Outstanding_18, 

Case 
When V.AmountDue_19<((V.Payment_CC+V.Payment_OC)-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16+V.AmountDue_17+V.AmountDue_18)) Then 0
When ((V.Payment_CC+V.Payment_OC)-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16+V.AmountDue_17+V.AmountDue_18))<0 then V.AmountDue_19
else V.AmountDue_19-((V.Payment_CC+V.Payment_OC)-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16+V.AmountDue_17+V.AmountDue_18)) end 
+
Case WHen V.Installment=19 and (V.Payment_CC+V.Payment_OC)>(V.Nominal_CC-V.Diff_CC) Then (V.Nominal_CC-V.Diff_CC)-(V.Payment_CC+V.Payment_OC) else 0 end
as Outstanding_19, 

Case 
When V.AmountDue_20<((V.Payment_CC+V.Payment_OC)-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16+V.AmountDue_17+V.AmountDue_18+V.AmountDue_19)) Then 0
When ((V.Payment_CC+V.Payment_OC)-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16+V.AmountDue_17+V.AmountDue_18+V.AmountDue_19))<0 then V.AmountDue_20
else V.AmountDue_20-((V.Payment_CC+V.Payment_OC)-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16+V.AmountDue_17+V.AmountDue_18+V.AmountDue_19)) end 
+
Case WHen V.Installment=20 and (V.Payment_CC+V.Payment_OC)>(V.Nominal_CC-V.Diff_CC) Then (V.Nominal_CC-V.Diff_CC)-(V.Payment_CC+V.Payment_OC) else 0 end
as Outstanding_20, 
  
Case 
When V.AmountDue_21<((V.Payment_CC+V.Payment_OC)-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16+V.AmountDue_17+V.AmountDue_18+V.AmountDue_19+V.AmountDue_20)) Then 0
When ((V.Payment_CC+V.Payment_OC)-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16+V.AmountDue_17+V.AmountDue_18+V.AmountDue_19+V.AmountDue_20))<0 then V.AmountDue_21
else V.AmountDue_21-((V.Payment_CC+V.Payment_OC)-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16+V.AmountDue_17+V.AmountDue_18+V.AmountDue_19+V.AmountDue_20)) end 
+
Case WHen V.Installment=21 and (V.Payment_CC+V.Payment_OC)>(V.Nominal_CC-V.Diff_CC) Then (V.Nominal_CC-V.Diff_CC)-(V.Payment_CC+V.Payment_OC) else 0 end
as Outstanding_21, 

Case 
When V.AmountDue_22<((V.Payment_CC+V.Payment_OC)-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16+V.AmountDue_17+V.AmountDue_18+V.AmountDue_19+V.AmountDue_20+V.AmountDue_21)) Then 0
When ((V.Payment_CC+V.Payment_OC)-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16+V.AmountDue_17+V.AmountDue_18+V.AmountDue_19+V.AmountDue_20+V.AmountDue_21))<0 then V.AmountDue_22
else V.AmountDue_22-((V.Payment_CC+V.Payment_OC)-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16+V.AmountDue_17+V.AmountDue_18+V.AmountDue_19+V.AmountDue_20+V.AmountDue_21)) end 
+
Case WHen V.Installment=22 and (V.Payment_CC+V.Payment_OC)>(V.Nominal_CC-V.Diff_CC) Then (V.Nominal_CC-V.Diff_CC)-(V.Payment_CC+V.Payment_OC) else 0 end
as Outstanding_22, 

Case 
When V.AmountDue_23<((V.Payment_CC+V.Payment_OC)-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16+V.AmountDue_17+V.AmountDue_18+V.AmountDue_19+V.AmountDue_20+V.AmountDue_21+V.AmountDue_22)) Then 0
When ((V.Payment_CC+V.Payment_OC)-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16+V.AmountDue_17+V.AmountDue_18+V.AmountDue_19+V.AmountDue_20+V.AmountDue_21+V.AmountDue_22))<0 then V.AmountDue_23
else V.AmountDue_23-((V.Payment_CC+V.Payment_OC)-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16+V.AmountDue_17+V.AmountDue_18+V.AmountDue_19+V.AmountDue_20+V.AmountDue_21+V.AmountDue_22)) end 
+
Case WHen V.Installment=23 and (V.Payment_CC+V.Payment_OC)>(V.Nominal_CC-V.Diff_CC) Then (V.Nominal_CC-V.Diff_CC)-(V.Payment_CC+V.Payment_OC) else 0 end
as Outstanding_23, 
 
Case 
When V.AmountDue_24<((V.Payment_CC+V.Payment_OC)-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16+V.AmountDue_17+V.AmountDue_18+V.AmountDue_19+V.AmountDue_20+V.AmountDue_21+V.AmountDue_22+V.AmountDue_23)) Then 0
When ((V.Payment_CC+V.Payment_OC)-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16+V.AmountDue_17+V.AmountDue_18+V.AmountDue_19+V.AmountDue_20+V.AmountDue_21+V.AmountDue_22+V.AmountDue_23))<0 then V.AmountDue_24
else V.AmountDue_24-((V.Payment_CC+V.Payment_OC)-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16+V.AmountDue_17+V.AmountDue_18+V.AmountDue_19+V.AmountDue_20+V.AmountDue_21+V.AmountDue_22+V.AmountDue_23)) End
+
Case WHen V.Installment=24 and (V.Payment_CC+V.Payment_OC)>(V.Nominal_CC-V.Diff_CC) Then (V.Nominal_CC-V.Diff_CC)-(V.Payment_CC+V.Payment_OC) else 0 end
as Outstanding_24,

(Case When V.Installment<>0 then ' Installment No. ' else '' end+      
Case When V.Installment>=1 and V.DueDate_1 <=@P_Date and (V.Payment_CC+V.Payment_OC)<V.AmountDue_1 Then '1 ' else '' end+
Case When V.Installment>=2 and V.DueDate_2 <=@P_Date and (V.Payment_CC+V.Payment_OC)<V.AmountDue_1+V.AmountDue_2 Then '2 ' else '' end+
Case When V.Installment>=3 and V.DueDate_3 <=@P_Date and (V.Payment_CC+V.Payment_OC)<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3 Then '3 ' else '' end+
Case When V.Installment>=4 and V.DueDate_4 <=@P_Date and (V.Payment_CC+V.Payment_OC)<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4 Then '4 ' else '' end+
Case When V.Installment>=5 and V.DueDate_5 <=@P_Date and (V.Payment_CC+V.Payment_OC)<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5 Then '5 ' else '' end+
Case When V.Installment>=6 and V.DueDate_6 <=@P_Date and (V.Payment_CC+V.Payment_OC)<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6 Then '6 ' else '' end+
Case When V.Installment>=7 and V.DueDate_7 <=@P_Date and (V.Payment_CC+V.Payment_OC)<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7 Then '7 ' else '' end+
Case When V.Installment>=8 and V.DueDate_8 <=@P_Date and (V.Payment_CC+V.Payment_OC)<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8 Then '8 ' else '' end+
Case When V.Installment>=9 and V.DueDate_9 <=@P_Date and (V.Payment_CC+V.Payment_OC)<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9 Then '9 ' else '' end+
Case When V.Installment>=10 and V.DueDate_10 <=@P_Date and (V.Payment_CC+V.Payment_OC)<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10 Then '10 ' else '' end+
Case When V.Installment>=11 and V.DueDate_11 <=@P_Date and (V.Payment_CC+V.Payment_OC)<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11 Then '11 ' else '' end+
Case When V.Installment>=12 and V.DueDate_12 <=@P_Date and (V.Payment_CC+V.Payment_OC)<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12 Then '12 ' else '' end+
Case When V.Installment>=13 and V.DueDate_13 <=@P_Date and (V.Payment_CC+V.Payment_OC)<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13 Then '13 ' else '' end+
Case When V.Installment>=14 and V.DueDate_14 <=@P_Date and (V.Payment_CC+V.Payment_OC)<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14 Then '14 ' else '' end+
Case When V.Installment>=15 and V.DueDate_15 <=@P_Date and (V.Payment_CC+V.Payment_OC)<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15 Then '15 ' else '' end+
Case When V.Installment>=16 and V.DueDate_16 <=@P_Date and (V.Payment_CC+V.Payment_OC)<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16 Then '16 ' else '' end+
Case When V.Installment>=17 and V.DueDate_17 <=@P_Date and (V.Payment_CC+V.Payment_OC)<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16+V.AmountDue_17 Then '17 ' else '' end+
Case When V.Installment>=18 and V.DueDate_18 <=@P_Date and (V.Payment_CC+V.Payment_OC)<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16+V.AmountDue_17+V.AmountDue_18 Then '18 ' else '' end+
Case When V.Installment>=19 and V.DueDate_19 <=@P_Date and (V.Payment_CC+V.Payment_OC)<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16+V.AmountDue_17+V.AmountDue_18+V.AmountDue_19 Then '19 ' else '' end+
Case When V.Installment>=20 and V.DueDate_20 <=@P_Date and (V.Payment_CC+V.Payment_OC)<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16+V.AmountDue_17+V.AmountDue_18+V.AmountDue_19+V.AmountDue_20 Then '20 ' else '' end+
Case When V.Installment>=21 and V.DueDate_21 <=@P_Date and (V.Payment_CC+V.Payment_OC)<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16+V.AmountDue_17+V.AmountDue_18+V.AmountDue_19+V.AmountDue_20+V.AmountDue_21 Then '21 ' else '' end+
Case When V.Installment>=22 and V.DueDate_22 <=@P_Date and (V.Payment_CC+V.Payment_OC)<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16+V.AmountDue_17+V.AmountDue_18+V.AmountDue_19+V.AmountDue_20+V.AmountDue_21+V.AmountDue_22 Then '22 ' else '' end+
Case When V.Installment>=23 and V.DueDate_23 <=@P_Date and (V.Payment_CC+V.Payment_OC)<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16+V.AmountDue_17+V.AmountDue_18+V.AmountDue_19+V.AmountDue_20+V.AmountDue_21+V.AmountDue_22+V.AmountDue_23 Then '23 ' else '' end+
Case When V.Installment>=24 and V.DueDate_24 <=@P_Date and (V.Payment_CC+V.Payment_OC)<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16+V.AmountDue_17+V.AmountDue_18+V.AmountDue_19+V.AmountDue_20+V.AmountDue_21+V.AmountDue_22+V.AmountDue_23+V.AmountDue_24 Then '24 ' else '' end
+      
Case When V.Installment<>0 then 'of '+cast(V.Installment as varchar(255)) else '' end) as sInstallment,

(
Case When V.Installment>=1 and V.DueDate_1 <=@P_Date and (V.Payment_CC+V.Payment_OC)<V.AmountDue_1 
	Then ' Installment 1 : ' + 
	convert(varchar(50), cast(
	Case 
	When V.AmountDue_1<(V.Payment_CC+V.Payment_OC) Then 0
	else V.AmountDue_1-(V.Payment_CC+V.Payment_OC) end 
	+
	Case WHen V.Installment=1 and (V.Payment_CC+V.Payment_OC)>(V.Nominal_CC-V.Diff_CC) Then (V.Nominal_CC-V.Diff_CC)-(V.Payment_CC+V.Payment_OC) else 0 end
	as Money),1)+char(13)+char(10)
	else '' end+ 

Case When V.Installment>=2 and V.DueDate_2 <=@P_Date and (V.Payment_CC+V.Payment_OC)<V.AmountDue_1+V.AmountDue_2 
	Then ' Installment 2 : ' + 
	convert(varchar(50), cast(
	Case 
	When V.AmountDue_2<((V.Payment_CC+V.Payment_OC)-V.AmountDue_1) Then 0
	When ((V.Payment_CC+V.Payment_OC)-V.AmountDue_1)<0 then V.AmountDue_2
	else V.AmountDue_2-((V.Payment_CC+V.Payment_OC)-V.AmountDue_1) end 
	+
	Case WHen V.Installment=2 and (V.Payment_CC+V.Payment_OC)>(V.Nominal_CC-V.Diff_CC) Then (V.Nominal_CC-V.Diff_CC)-(V.Payment_CC+V.Payment_OC) else 0 end
	as Money),1)+char(13)+char(10)
	else '' end+ 

Case When V.Installment>=3 and V.DueDate_3 <=@P_Date and (V.Payment_CC+V.Payment_OC)<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3 
	Then ' Installment 3 : ' + 
	convert(varchar(50), cast(
	Case 
	When V.AmountDue_3<((V.Payment_CC+V.Payment_OC)-(V.AmountDue_1+V.AmountDue_2)) Then 0
	When ((V.Payment_CC+V.Payment_OC)-(V.AmountDue_1+V.AmountDue_2))<0 then V.AmountDue_3
	else V.AmountDue_3-((V.Payment_CC+V.Payment_OC)-(V.AmountDue_1+V.AmountDue_2)) end 
	+
	Case WHen V.Installment=3 and (V.Payment_CC+V.Payment_OC)>(V.Nominal_CC-V.Diff_CC) Then (V.Nominal_CC-V.Diff_CC)-(V.Payment_CC+V.Payment_OC) else 0 end
	as Money),1)+char(13)+char(10)
	else '' end+ 

Case When V.Installment>=4 and V.DueDate_4 <=@P_Date and (V.Payment_CC+V.Payment_OC)<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4 
	Then ' Installment 4 : ' + 
	convert(varchar(50), cast(
	Case 
	When V.AmountDue_4<((V.Payment_CC+V.Payment_OC)-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3)) Then 0
	When ((V.Payment_CC+V.Payment_OC)-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3))<0 then V.AmountDue_4
	else V.AmountDue_4-((V.Payment_CC+V.Payment_OC)-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3)) end 
	+
	Case WHen V.Installment=4 and (V.Payment_CC+V.Payment_OC)>(V.Nominal_CC-V.Diff_CC) Then (V.Nominal_CC-V.Diff_CC)-(V.Payment_CC+V.Payment_OC) else 0 end
	as Money),1)+char(13)+char(10)
	else '' end+ 

Case When V.Installment>=5 and V.DueDate_5 <=@P_Date and (V.Payment_CC+V.Payment_OC)<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5 
	Then ' Installment 5 : ' + 
	convert(varchar(50), cast(
	Case 
	When V.AmountDue_5<((V.Payment_CC+V.Payment_OC)-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4)) Then 0
	When ((V.Payment_CC+V.Payment_OC)-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4))<0 then V.AmountDue_5
	else V.AmountDue_5-((V.Payment_CC+V.Payment_OC)-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4)) end 
	+
	Case WHen V.Installment=5 and (V.Payment_CC+V.Payment_OC)>(V.Nominal_CC-V.Diff_CC) Then (V.Nominal_CC-V.Diff_CC)-(V.Payment_CC+V.Payment_OC) else 0 end
	as Money),1)+char(13)+char(10)
	else '' end+ 

Case When V.Installment>=6 and V.DueDate_6 <=@P_Date and (V.Payment_CC+V.Payment_OC)<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6 
	Then ' Installment 6 : ' + 
	convert(varchar(50), cast(
	Case 
	When V.AmountDue_6<((V.Payment_CC+V.Payment_OC)-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5)) Then 0
	When ((V.Payment_CC+V.Payment_OC)-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5))<0 then V.AmountDue_6
	else V.AmountDue_6-((V.Payment_CC+V.Payment_OC)-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5)) end 
	+
	Case WHen V.Installment=6 and (V.Payment_CC+V.Payment_OC)>(V.Nominal_CC-V.Diff_CC) Then (V.Nominal_CC-V.Diff_CC)-(V.Payment_CC+V.Payment_OC) else 0 end
	as Money),1)+char(13)+char(10)
	else '' end+ 

Case When V.Installment>=7 and V.DueDate_7 <=@P_Date and (V.Payment_CC+V.Payment_OC)<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7 
	Then ' Installment 7 : ' + 
	convert(varchar(50), cast(
	Case 
	When V.AmountDue_7<((V.Payment_CC+V.Payment_OC)-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6)) Then 0
	When ((V.Payment_CC+V.Payment_OC)-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6))<0 then V.AmountDue_7
	else V.AmountDue_7-((V.Payment_CC+V.Payment_OC)-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6)) end 
	+
	Case WHen V.Installment=7 and (V.Payment_CC+V.Payment_OC)>(V.Nominal_CC-V.Diff_CC) Then (V.Nominal_CC-V.Diff_CC)-(V.Payment_CC+V.Payment_OC) else 0 end
	as Money),1)+char(13)+char(10)
	else '' end+ 

Case When V.Installment>=8 and V.DueDate_8 <=@P_Date and (V.Payment_CC+V.Payment_OC)<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8 
	Then ' Installment 8 : ' + 
	convert(varchar(50), cast(
	Case 
	When V.AmountDue_8<((V.Payment_CC+V.Payment_OC)-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7)) Then 0
	When ((V.Payment_CC+V.Payment_OC)-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7))<0 then V.AmountDue_8
	else V.AmountDue_8-((V.Payment_CC+V.Payment_OC)-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7)) end 
	+
	Case WHen V.Installment=8 and (V.Payment_CC+V.Payment_OC)>(V.Nominal_CC-V.Diff_CC) Then (V.Nominal_CC-V.Diff_CC)-(V.Payment_CC+V.Payment_OC) else 0 end
	as Money),1)+char(13)+char(10)
	else '' end+ 

Case When V.Installment>=9 and V.DueDate_9 <=@P_Date and (V.Payment_CC+V.Payment_OC)<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9 
	Then ' Installment 2 : ' + 
	convert(varchar(50), cast(
	Case 
	When V.AmountDue_9<((V.Payment_CC+V.Payment_OC)-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8)) Then 0
	When ((V.Payment_CC+V.Payment_OC)-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8))<0 then V.AmountDue_9
	else V.AmountDue_9-((V.Payment_CC+V.Payment_OC)-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8)) end 
	+
	Case WHen V.Installment=9 and (V.Payment_CC+V.Payment_OC)>(V.Nominal_CC-V.Diff_CC) Then (V.Nominal_CC-V.Diff_CC)-(V.Payment_CC+V.Payment_OC) else 0 end
	as Money),1)+char(13)+char(10)
	else '' end+ 

Case When V.Installment>=10 and V.DueDate_10 <=@P_Date and (V.Payment_CC+V.Payment_OC)<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10  
	Then ' Installment 10 : ' + 
	convert(varchar(50), cast(
	Case 
	When V.AmountDue_10<((V.Payment_CC+V.Payment_OC)-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9)) Then 0
	When ((V.Payment_CC+V.Payment_OC)-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9))<0 then V.AmountDue_10
	else V.AmountDue_10-((V.Payment_CC+V.Payment_OC)-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9)) end 
	+
	Case WHen V.Installment=10 and (V.Payment_CC+V.Payment_OC)>(V.Nominal_CC-V.Diff_CC) Then (V.Nominal_CC-V.Diff_CC)-(V.Payment_CC+V.Payment_OC) else 0 end
	as Money),1)+char(13)+char(10)
	else '' end+ 

Case When V.Installment>=11 and V.DueDate_11 <=@P_Date and (V.Payment_CC+V.Payment_OC)<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11 
	Then ' Installment 11 : ' + 
	convert(varchar(50), cast(
	Case 
	When V.AmountDue_11<((V.Payment_CC+V.Payment_OC)-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10)) Then 0
	When ((V.Payment_CC+V.Payment_OC)-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10))<0 then V.AmountDue_11
	else V.AmountDue_11-((V.Payment_CC+V.Payment_OC)-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10)) end 
	+
	Case WHen V.Installment=11 and (V.Payment_CC+V.Payment_OC)>(V.Nominal_CC-V.Diff_CC) Then (V.Nominal_CC-V.Diff_CC)-(V.Payment_CC+V.Payment_OC) else 0 end
	as Money),1)+char(13)+char(10)
	else '' end+ 

Case When V.Installment>=12 and V.DueDate_12 <=@P_Date and (V.Payment_CC+V.Payment_OC)<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12 
	Then ' Installment 12 : ' + 
	convert(varchar(50), cast(
	Case 
	When V.AmountDue_12<((V.Payment_CC+V.Payment_OC)-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11)) Then 0
	When ((V.Payment_CC+V.Payment_OC)-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11))<0 then V.AmountDue_12
	else V.AmountDue_12-((V.Payment_CC+V.Payment_OC)-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11)) end 
	+
	Case WHen V.Installment=12 and (V.Payment_CC+V.Payment_OC)>(V.Nominal_CC-V.Diff_CC) Then (V.Nominal_CC-V.Diff_CC)-(V.Payment_CC+V.Payment_OC) else 0 end
	as Money),1)+char(13)+char(10)
	else '' end+ 

Case When V.Installment>=13 and V.DueDate_13 <=@P_Date and (V.Payment_CC+V.Payment_OC)<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13 
	Then ' Installment 13 : ' + 
	convert(varchar(50), cast(
	Case 
	When V.AmountDue_14<((V.Payment_CC+V.Payment_OC)-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13)) Then 0
	When ((V.Payment_CC+V.Payment_OC)-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13))<0 then V.AmountDue_14
	else V.AmountDue_14-((V.Payment_CC+V.Payment_OC)-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13)) end 
	+
	Case WHen V.Installment=13 and (V.Payment_CC+V.Payment_OC)>(V.Nominal_CC-V.Diff_CC) Then (V.Nominal_CC-V.Diff_CC)-(V.Payment_CC+V.Payment_OC) else 0 end
	as Money),1)+char(13)+char(10)
	else '' end+ 

Case When V.Installment>=14 and V.DueDate_14 <=@P_Date and (V.Payment_CC+V.Payment_OC)<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14 
	Then ' Installment 14 : ' + 
	convert(varchar(50), cast(
	Case 
	When V.AmountDue_2<((V.Payment_CC+V.Payment_OC)-V.AmountDue_1) Then 0
	When ((V.Payment_CC+V.Payment_OC)-V.AmountDue_1)<0 then V.AmountDue_2
	else V.AmountDue_2-((V.Payment_CC+V.Payment_OC)-V.AmountDue_1) end 
	+
	Case WHen V.Installment=2 and (V.Payment_CC+V.Payment_OC)>(V.Nominal_CC-V.Diff_CC) Then (V.Nominal_CC-V.Diff_CC)-(V.Payment_CC+V.Payment_OC) else 0 end
	as Money),1)+char(13)+char(10)
	else '' end+ 

Case When V.Installment>=15 and V.DueDate_15 <=@P_Date and (V.Payment_CC+V.Payment_OC)<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15 
	Then ' Installment 15 : ' + 
	convert(varchar(50), cast(
	Case 
	When V.AmountDue_15<((V.Payment_CC+V.Payment_OC)-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14)) Then 0
	When ((V.Payment_CC+V.Payment_OC)-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14))<0 then V.AmountDue_15
	else V.AmountDue_15-((V.Payment_CC+V.Payment_OC)-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14)) end 
	+
	Case WHen V.Installment=15 and (V.Payment_CC+V.Payment_OC)>(V.Nominal_CC-V.Diff_CC) Then (V.Nominal_CC-V.Diff_CC)-(V.Payment_CC+V.Payment_OC) else 0 end
	as Money),1)+char(13)+char(10)
	else '' end+ 

Case When V.Installment>=16 and V.DueDate_16 <=@P_Date and (V.Payment_CC+V.Payment_OC)<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16 
	Then ' Installment 16 : ' + 
	convert(varchar(50), cast(
	Case 
	When V.AmountDue_16<((V.Payment_CC+V.Payment_OC)-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15)) Then 0
	When ((V.Payment_CC+V.Payment_OC)-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15))<0 then V.AmountDue_16
	else V.AmountDue_16-((V.Payment_CC+V.Payment_OC)-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15)) end 
	+
	Case WHen V.Installment=16 and (V.Payment_CC+V.Payment_OC)>(V.Nominal_CC-V.Diff_CC) Then (V.Nominal_CC-V.Diff_CC)-(V.Payment_CC+V.Payment_OC) else 0 end
	as Money),1)+char(13)+char(10)
	else '' end+ 

Case When V.Installment>=17 and V.DueDate_17 <=@P_Date and (V.Payment_CC+V.Payment_OC)<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16+V.AmountDue_17 
	Then ' Installment 17 : ' + 
	convert(varchar(50), cast(
	Case 
	When V.AmountDue_17<((V.Payment_CC+V.Payment_OC)-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16)) Then 0
	When ((V.Payment_CC+V.Payment_OC)-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16))<0 then V.AmountDue_17
	else V.AmountDue_17-((V.Payment_CC+V.Payment_OC)-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16)) end 
	+
	Case WHen V.Installment=17 and (V.Payment_CC+V.Payment_OC)>(V.Nominal_CC-V.Diff_CC) Then (V.Nominal_CC-V.Diff_CC)-(V.Payment_CC+V.Payment_OC) else 0 end
	as Money),1)+char(13)+char(10)
	else '' end+ 

Case When V.Installment>=18 and V.DueDate_18 <=@P_Date and (V.Payment_CC+V.Payment_OC)<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16+V.AmountDue_17+V.AmountDue_18 
	Then ' Installment 18 : ' + 
	convert(varchar(50), cast(
	Case 
	When V.AmountDue_18<((V.Payment_CC+V.Payment_OC)-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16+V.AmountDue_17)) Then 0
	When ((V.Payment_CC+V.Payment_OC)-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16+V.AmountDue_17))<0 then V.AmountDue_18
	else V.AmountDue_18-((V.Payment_CC+V.Payment_OC)-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16+V.AmountDue_17)) end 
	+
	Case WHen V.Installment=18 and (V.Payment_CC+V.Payment_OC)>(V.Nominal_CC-V.Diff_CC) Then (V.Nominal_CC-V.Diff_CC)-(V.Payment_CC+V.Payment_OC) else 0 end
	as Money),1)+char(13)+char(10)
	else '' end+ 

Case When V.Installment>=19 and V.DueDate_19 <=@P_Date and (V.Payment_CC+V.Payment_OC)<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16+V.AmountDue_17+V.AmountDue_18+V.AmountDue_19 
	Then ' Installment 19 : ' + 
	convert(varchar(50), cast(
	Case 
	When V.AmountDue_19<((V.Payment_CC+V.Payment_OC)-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16+V.AmountDue_17+V.AmountDue_18)) Then 0
	When ((V.Payment_CC+V.Payment_OC)-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16+V.AmountDue_17+V.AmountDue_18))<0 then V.AmountDue_19
	else V.AmountDue_19-((V.Payment_CC+V.Payment_OC)-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16+V.AmountDue_17+V.AmountDue_18)) end 
	+
	Case WHen V.Installment=19 and (V.Payment_CC+V.Payment_OC)>(V.Nominal_CC-V.Diff_CC) Then (V.Nominal_CC-V.Diff_CC)-(V.Payment_CC+V.Payment_OC) else 0 end
	as Money),1)+char(13)+char(10)
	else '' end+ 

Case When V.Installment>=20 and V.DueDate_20 <=@P_Date and (V.Payment_CC+V.Payment_OC)<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16+V.AmountDue_17+V.AmountDue_18+V.AmountDue_19+V.AmountDue_20 
	Then ' Installment 20 : ' + 
	convert(varchar(50), cast(
	Case 
	When V.AmountDue_20<((V.Payment_CC+V.Payment_OC)-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16+V.AmountDue_17+V.AmountDue_18+V.AmountDue_19)) Then 0
	When ((V.Payment_CC+V.Payment_OC)-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16+V.AmountDue_17+V.AmountDue_18+V.AmountDue_19))<0 then V.AmountDue_20
	else V.AmountDue_20-((V.Payment_CC+V.Payment_OC)-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16+V.AmountDue_17+V.AmountDue_18+V.AmountDue_19)) end 
	+
	Case WHen V.Installment=20 and (V.Payment_CC+V.Payment_OC)>(V.Nominal_CC-V.Diff_CC) Then (V.Nominal_CC-V.Diff_CC)-(V.Payment_CC+V.Payment_OC) else 0 end
	as Money),1)+char(13)+char(10)
	else '' end+ 

Case When V.Installment>=21 and V.DueDate_21 <=@P_Date and (V.Payment_CC+V.Payment_OC)<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16+V.AmountDue_17+V.AmountDue_18+V.AmountDue_19+V.AmountDue_20+V.AmountDue_21 
	Then ' Installment 21 : ' + 
	convert(varchar(50), cast(
	Case 
	When V.AmountDue_21<((V.Payment_CC+V.Payment_OC)-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16+V.AmountDue_17+V.AmountDue_18+V.AmountDue_19+V.AmountDue_20)) Then 0
	When ((V.Payment_CC+V.Payment_OC)-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16+V.AmountDue_17+V.AmountDue_18+V.AmountDue_19+V.AmountDue_20))<0 then V.AmountDue_21
	else V.AmountDue_21-((V.Payment_CC+V.Payment_OC)-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16+V.AmountDue_17+V.AmountDue_18+V.AmountDue_19+V.AmountDue_20)) end 
	+
	Case WHen V.Installment=21 and (V.Payment_CC+V.Payment_OC)>(V.Nominal_CC-V.Diff_CC) Then (V.Nominal_CC-V.Diff_CC)-(V.Payment_CC+V.Payment_OC) else 0 end
	as Money),1)+char(13)+char(10)
	else '' end+ 

Case When V.Installment>=22 and V.DueDate_22 <=@P_Date and (V.Payment_CC+V.Payment_OC)<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16+V.AmountDue_17+V.AmountDue_18+V.AmountDue_19+V.AmountDue_20+V.AmountDue_21+V.AmountDue_22 
	Then ' Installment 22 : ' + 
	convert(varchar(50), cast(
	Case 
	When V.AmountDue_22<((V.Payment_CC+V.Payment_OC)-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16+V.AmountDue_17+V.AmountDue_18+V.AmountDue_19+V.AmountDue_20+V.AmountDue_21)) Then 0
	When ((V.Payment_CC+V.Payment_OC)-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16+V.AmountDue_17+V.AmountDue_18+V.AmountDue_19+V.AmountDue_20+V.AmountDue_21))<0 then V.AmountDue_22
	else V.AmountDue_22-((V.Payment_CC+V.Payment_OC)-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16+V.AmountDue_17+V.AmountDue_18+V.AmountDue_19+V.AmountDue_20+V.AmountDue_21)) end 
	+
	Case WHen V.Installment=22 and (V.Payment_CC+V.Payment_OC)>(V.Nominal_CC-V.Diff_CC) Then (V.Nominal_CC-V.Diff_CC)-(V.Payment_CC+V.Payment_OC) else 0 end
	as Money),1)+char(13)+char(10)
	else '' end+ 

Case When V.Installment>=23 and V.DueDate_23 <=@P_Date and (V.Payment_CC+V.Payment_OC)<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16+V.AmountDue_17+V.AmountDue_18+V.AmountDue_19+V.AmountDue_20+V.AmountDue_21+V.AmountDue_22+V.AmountDue_23 
	Then ' Installment 23 : ' + 
	convert(varchar(50), cast(
	Case 
	When V.AmountDue_23<((V.Payment_CC+V.Payment_OC)-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16+V.AmountDue_17+V.AmountDue_18+V.AmountDue_19+V.AmountDue_20+V.AmountDue_21+V.AmountDue_22)) Then 0
	When ((V.Payment_CC+V.Payment_OC)-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16+V.AmountDue_17+V.AmountDue_18+V.AmountDue_19+V.AmountDue_20+V.AmountDue_21+V.AmountDue_22))<0 then V.AmountDue_23
	else V.AmountDue_23-((V.Payment_CC+V.Payment_OC)-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16+V.AmountDue_17+V.AmountDue_18+V.AmountDue_19+V.AmountDue_20+V.AmountDue_21+V.AmountDue_22)) end 
	+
	Case WHen V.Installment=23 and (V.Payment_CC+V.Payment_OC)>(V.Nominal_CC-V.Diff_CC) Then (V.Nominal_CC-V.Diff_CC)-(V.Payment_CC+V.Payment_OC) else 0 end
	as Money),1)+char(13)+char(10)
	else '' end+ 

Case When V.Installment>=24 and V.DueDate_24 <=@P_Date and (V.Payment_CC+V.Payment_OC)<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16+V.AmountDue_17+V.AmountDue_18+V.AmountDue_19+V.AmountDue_20+V.AmountDue_21+V.AmountDue_22+V.AmountDue_23+V.AmountDue_24 
	Then ' Installment 24 : ' + 
	convert(varchar(50), cast(
	Case 
	When V.AmountDue_24<((V.Payment_CC+V.Payment_OC)-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16+V.AmountDue_17+V.AmountDue_18+V.AmountDue_19+V.AmountDue_20+V.AmountDue_21+V.AmountDue_22+V.AmountDue_23)) Then 0
	When ((V.Payment_CC+V.Payment_OC)-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16+V.AmountDue_17+V.AmountDue_18+V.AmountDue_19+V.AmountDue_20+V.AmountDue_21+V.AmountDue_22+V.AmountDue_23))<0 then V.AmountDue_24
	else V.AmountDue_24-((V.Payment_CC+V.Payment_OC)-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16+V.AmountDue_17+V.AmountDue_18+V.AmountDue_19+V.AmountDue_20+V.AmountDue_21+V.AmountDue_22+V.AmountDue_23)) End
	+
	Case WHen V.Installment=24 and (V.Payment_CC+V.Payment_OC)>(V.Nominal_CC-V.Diff_CC) Then (V.Nominal_CC-V.Diff_CC)-(V.Payment_CC+V.Payment_OC) else 0 end
	as Money),1)+char(13)+char(10)
	else '' end 

) as sInstallment_Ext
from nVoucher V 
Outer Apply (Select top 1 WPC from Admlink A Where A.Voucher=V.Voucher) A
Where (Round(V.Nominal_CC-V.Diff_CC-(V.Payment_CC+V.Payment_OC),4)<>0 or V.PDate>@P_Date) 
) 

GO

DROP function VOUCHER_REMINDERDUE
GO
CREATE function VOUCHER_REMINDERDUE(@P_Reminder as int, @P_Date as smalldatetime)      
RETURNS Table      
AS RETURN      
(      
Select V.Voucher, V.Date, V.Branch, V.VType, V.ProAcc, V.RefNo, V.SL_Cat, V.Remarks, V.DocNo, V.Currency, V.Installment, (V.Payment_CC+V.Payment_OC) as Payment_CC, cast(0 as Float) as Payment_OC,  V.DebtorF, V.CreditorF,                  
(Case When V.Installment=0 and datediff(day, V.DueDate, @P_Date)>=(Case When RD.ID is null then R.Day_1 else RD.Day_1 end) Then V.Nominal_CC-V.Diff_CC else 0 end+      
Case When V.Installment>=1 and datediff(day, V.DueDate_1, @P_Date)>=(Case When RD.ID is null then R.Day_1 else RD.Day_1 end) Then V.AmountDue_1 else 0 end+      
Case When V.Installment>=2 and datediff(day, V.DueDate_2, @P_Date)>=(Case When RD.ID is null then R.Day_1 else RD.Day_1 end) Then V.AmountDue_2 else 0 end+      
Case When V.Installment>=3 and datediff(day, V.DueDate_3, @P_Date)>=(Case When RD.ID is null then R.Day_1 else RD.Day_1 end) Then V.AmountDue_3 else 0 end+      
Case When V.Installment>=4 and datediff(day, V.DueDate_4, @P_Date)>=(Case When RD.ID is null then R.Day_1 else RD.Day_1 end) Then V.AmountDue_4 else 0 end+      
Case When V.Installment>=5 and datediff(day, V.DueDate_5, @P_Date)>=(Case When RD.ID is null then R.Day_1 else RD.Day_1 end) Then V.AmountDue_5 else 0 end+      
Case When V.Installment>=6 and datediff(day, V.DueDate_6, @P_Date)>=(Case When RD.ID is null then R.Day_1 else RD.Day_1 end) Then V.AmountDue_6 else 0 end+      
Case When V.Installment>=7 and datediff(day, V.DueDate_7, @P_Date)>=(Case When RD.ID is null then R.Day_1 else RD.Day_1 end) Then V.AmountDue_7 else 0 end+      
Case When V.Installment>=8 and datediff(day, V.DueDate_8, @P_Date)>=(Case When RD.ID is null then R.Day_1 else RD.Day_1 end) Then V.AmountDue_8 else 0 end+      
Case When V.Installment>=9 and datediff(day, V.DueDate_9, @P_Date)>=(Case When RD.ID is null then R.Day_1 else RD.Day_1 end) Then V.AmountDue_9 else 0 end+      
Case When V.Installment>=10 and datediff(day, V.DueDate_10, @P_Date)>=(Case When RD.ID is null then R.Day_1 else RD.Day_1 end) Then V.AmountDue_10 else 0 end+      
Case When V.Installment>=11 and datediff(day, V.DueDate_11, @P_Date)>=(Case When RD.ID is null then R.Day_1 else RD.Day_1 end) Then V.AmountDue_11 else 0 end+      
Case When V.Installment>=12 and datediff(day, V.DueDate_12, @P_Date)>=(Case When RD.ID is null then R.Day_1 else RD.Day_1 end) Then V.AmountDue_12 else 0 end+
Case When V.Installment>=13 and datediff(day, V.DueDate_13, @P_Date)>=(Case When RD.ID is null then R.Day_1 else RD.Day_1 end) Then V.AmountDue_13 else 0 end+      
Case When V.Installment>=14 and datediff(day, V.DueDate_14, @P_Date)>=(Case When RD.ID is null then R.Day_1 else RD.Day_1 end) Then V.AmountDue_14 else 0 end+      
Case When V.Installment>=15 and datediff(day, V.DueDate_15, @P_Date)>=(Case When RD.ID is null then R.Day_1 else RD.Day_1 end) Then V.AmountDue_15 else 0 end+      
Case When V.Installment>=16 and datediff(day, V.DueDate_16, @P_Date)>=(Case When RD.ID is null then R.Day_1 else RD.Day_1 end) Then V.AmountDue_16 else 0 end+      
Case When V.Installment>=17 and datediff(day, V.DueDate_17, @P_Date)>=(Case When RD.ID is null then R.Day_1 else RD.Day_1 end) Then V.AmountDue_17 else 0 end+      
Case When V.Installment>=18 and datediff(day, V.DueDate_18, @P_Date)>=(Case When RD.ID is null then R.Day_1 else RD.Day_1 end) Then V.AmountDue_18 else 0 end+      
Case When V.Installment>=19 and datediff(day, V.DueDate_19, @P_Date)>=(Case When RD.ID is null then R.Day_1 else RD.Day_1 end) Then V.AmountDue_19 else 0 end+      
Case When V.Installment>=20 and datediff(day, V.DueDate_20, @P_Date)>=(Case When RD.ID is null then R.Day_1 else RD.Day_1 end) Then V.AmountDue_20 else 0 end+      
Case When V.Installment>=21 and datediff(day, V.DueDate_21, @P_Date)>=(Case When RD.ID is null then R.Day_1 else RD.Day_1 end) Then V.AmountDue_21 else 0 end+      
Case When V.Installment>=22 and datediff(day, V.DueDate_22, @P_Date)>=(Case When RD.ID is null then R.Day_1 else RD.Day_1 end) Then V.AmountDue_22 else 0 end+      
Case When V.Installment>=23 and datediff(day, V.DueDate_23, @P_Date)>=(Case When RD.ID is null then R.Day_1 else RD.Day_1 end) Then V.AmountDue_23 else 0 end+      
Case When V.Installment>=24 and datediff(day, V.DueDate_24, @P_Date)>=(Case When RD.ID is null then R.Day_1 else RD.Day_1 end) Then V.AmountDue_24 else 0 end
) as AmountDue,  
    
V.Nominal_CC-V.Diff_CC-
      
(Case When V.Installment=0 and datediff(day, V.DueDate, @P_Date)>=(Case When RD.ID is null then R.Day_1 else RD.Day_1 end) Then V.Nominal_CC-V.Diff_CC else 0 end+      
Case When V.Installment>=1 and datediff(day, V.DueDate_1, @P_Date)>=(Case When RD.ID is null then R.Day_1 else RD.Day_1 end) Then V.AmountDue_1 else 0 end+      
Case When V.Installment>=2 and datediff(day, V.DueDate_2, @P_Date)>=(Case When RD.ID is null then R.Day_1 else RD.Day_1 end) Then V.AmountDue_2 else 0 end+      
Case When V.Installment>=3 and datediff(day, V.DueDate_3, @P_Date)>=(Case When RD.ID is null then R.Day_1 else RD.Day_1 end) Then V.AmountDue_3 else 0 end+      
Case When V.Installment>=4 and datediff(day, V.DueDate_4, @P_Date)>=(Case When RD.ID is null then R.Day_1 else RD.Day_1 end) Then V.AmountDue_4 else 0 end+      
Case When V.Installment>=5 and datediff(day, V.DueDate_5, @P_Date)>=(Case When RD.ID is null then R.Day_1 else RD.Day_1 end) Then V.AmountDue_5 else 0 end+      
Case When V.Installment>=6 and datediff(day, V.DueDate_6, @P_Date)>=(Case When RD.ID is null then R.Day_1 else RD.Day_1 end) Then V.AmountDue_6 else 0 end+      
Case When V.Installment>=7 and datediff(day, V.DueDate_7, @P_Date)>=(Case When RD.ID is null then R.Day_1 else RD.Day_1 end) Then V.AmountDue_7 else 0 end+      
Case When V.Installment>=8 and datediff(day, V.DueDate_8, @P_Date)>=(Case When RD.ID is null then R.Day_1 else RD.Day_1 end) Then V.AmountDue_8 else 0 end+      
Case When V.Installment>=9 and datediff(day, V.DueDate_9, @P_Date)>=(Case When RD.ID is null then R.Day_1 else RD.Day_1 end) Then V.AmountDue_9 else 0 end+      
Case When V.Installment>=10 and datediff(day, V.DueDate_10, @P_Date)>=(Case When RD.ID is null then R.Day_1 else RD.Day_1 end) Then V.AmountDue_10 else 0 end+      
Case When V.Installment>=11 and datediff(day, V.DueDate_11, @P_Date)>=(Case When RD.ID is null then R.Day_1 else RD.Day_1 end) Then V.AmountDue_11 else 0 end+      
Case When V.Installment>=12 and datediff(day, V.DueDate_12, @P_Date)>=(Case When RD.ID is null then R.Day_1 else RD.Day_1 end) Then V.AmountDue_12 else 0 end+
Case When V.Installment>=13 and datediff(day, V.DueDate_13, @P_Date)>=(Case When RD.ID is null then R.Day_1 else RD.Day_1 end) Then V.AmountDue_13 else 0 end+      
Case When V.Installment>=14 and datediff(day, V.DueDate_14, @P_Date)>=(Case When RD.ID is null then R.Day_1 else RD.Day_1 end) Then V.AmountDue_14 else 0 end+      
Case When V.Installment>=15 and datediff(day, V.DueDate_15, @P_Date)>=(Case When RD.ID is null then R.Day_1 else RD.Day_1 end) Then V.AmountDue_15 else 0 end+      
Case When V.Installment>=16 and datediff(day, V.DueDate_16, @P_Date)>=(Case When RD.ID is null then R.Day_1 else RD.Day_1 end) Then V.AmountDue_16 else 0 end+      
Case When V.Installment>=17 and datediff(day, V.DueDate_17, @P_Date)>=(Case When RD.ID is null then R.Day_1 else RD.Day_1 end) Then V.AmountDue_17 else 0 end+      
Case When V.Installment>=18 and datediff(day, V.DueDate_18, @P_Date)>=(Case When RD.ID is null then R.Day_1 else RD.Day_1 end) Then V.AmountDue_18 else 0 end+      
Case When V.Installment>=19 and datediff(day, V.DueDate_19, @P_Date)>=(Case When RD.ID is null then R.Day_1 else RD.Day_1 end) Then V.AmountDue_19 else 0 end+      
Case When V.Installment>=20 and datediff(day, V.DueDate_20, @P_Date)>=(Case When RD.ID is null then R.Day_1 else RD.Day_1 end) Then V.AmountDue_20 else 0 end+      
Case When V.Installment>=21 and datediff(day, V.DueDate_21, @P_Date)>=(Case When RD.ID is null then R.Day_1 else RD.Day_1 end) Then V.AmountDue_21 else 0 end+      
Case When V.Installment>=22 and datediff(day, V.DueDate_22, @P_Date)>=(Case When RD.ID is null then R.Day_1 else RD.Day_1 end) Then V.AmountDue_22 else 0 end+      
Case When V.Installment>=23 and datediff(day, V.DueDate_23, @P_Date)>=(Case When RD.ID is null then R.Day_1 else RD.Day_1 end) Then V.AmountDue_23 else 0 end+      
Case When V.Installment>=24 and datediff(day, V.DueDate_24, @P_Date)>=(Case When RD.ID is null then R.Day_1 else RD.Day_1 end) Then V.AmountDue_24 else 0 end
) as AmountUnDue,     
            
Case When V.Installment=0 then V.DueDate   
When (V.Payment_CC+V.Payment_OC)<V.AmountDue_1 then V.DueDate_1   
When (V.Payment_CC+V.Payment_OC)<V.AmountDue_1+V.AmountDue_2 then V.DueDate_2   
When (V.Payment_CC+V.Payment_OC)<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3 then V.DueDate_3   
When (V.Payment_CC+V.Payment_OC)<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4 then V.DueDate_4   
When (V.Payment_CC+V.Payment_OC)<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5 then V.DueDate_5   
When (V.Payment_CC+V.Payment_OC)<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6 then V.DueDate_6   
When (V.Payment_CC+V.Payment_OC)<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7 then V.DueDate_7   
When (V.Payment_CC+V.Payment_OC)<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8 then V.DueDate_8   
When (V.Payment_CC+V.Payment_OC)<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9 then V.DueDate_9   
When (V.Payment_CC+V.Payment_OC)<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10 then V.DueDate_10   
When (V.Payment_CC+V.Payment_OC)<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11 then V.DueDate_11   
When (V.Payment_CC+V.Payment_OC)<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12 then V.DueDate_12   
When (V.Payment_CC+V.Payment_OC)<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13 then V.DueDate_13   
When (V.Payment_CC+V.Payment_OC)<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14 then V.DueDate_14   
When (V.Payment_CC+V.Payment_OC)<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15 then V.DueDate_15   
When (V.Payment_CC+V.Payment_OC)<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16 then V.DueDate_16   
When (V.Payment_CC+V.Payment_OC)<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16+V.AmountDue_17 then V.DueDate_17   
When (V.Payment_CC+V.Payment_OC)<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16+V.AmountDue_17+V.AmountDue_18 then V.DueDate_18   
When (V.Payment_CC+V.Payment_OC)<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16+V.AmountDue_17+V.AmountDue_18+V.AmountDue_19 then V.DueDate_19   
When (V.Payment_CC+V.Payment_OC)<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16+V.AmountDue_17+V.AmountDue_18+V.AmountDue_19+V.AmountDue_20 then V.DueDate_20   
When (V.Payment_CC+V.Payment_OC)<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16+V.AmountDue_17+V.AmountDue_18+V.AmountDue_19+V.AmountDue_20+V.AmountDue_21 then V.DueDate_21   
When (V.Payment_CC+V.Payment_OC)<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16+V.AmountDue_17+V.AmountDue_18+V.AmountDue_19+V.AmountDue_20+V.AmountDue_21+V.AmountDue_22 then V.DueDate_22   
When (V.Payment_CC+V.Payment_OC)<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16+V.AmountDue_17+V.AmountDue_18+V.AmountDue_19+V.AmountDue_20+V.AmountDue_21+V.AmountDue_22+V.AmountDue_23 then V.DueDate_23   
Else V.DueDate_24   
end as DueDate,   
(Case When V.Installment<>0 then ' Installment No. ' else '' end+   
Case When V.Installment>=1 and datediff(day, V.DueDate_1, @P_Date)>=(Case When RD.ID is null then R.Day_1 else RD.Day_1 end) and (V.Payment_CC+V.Payment_OC)<V.AmountDue_1 Then '1 ' else '' end+   
Case When V.Installment>=2 and datediff(day, V.DueDate_2, @P_Date)>=(Case When RD.ID is null then R.Day_1 else RD.Day_1 end) and (V.Payment_CC+V.Payment_OC)<V.AmountDue_1+V.AmountDue_2 Then '2 ' else '' end+   
Case When V.Installment>=3 and datediff(day, V.DueDate_3, @P_Date)>=(Case When RD.ID is null then R.Day_1 else RD.Day_1 end) and (V.Payment_CC+V.Payment_OC)<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3 Then '3 ' else '' end+   
Case When V.Installment>=4 and datediff(day, V.DueDate_4, @P_Date)>=(Case When RD.ID is null then R.Day_1 else RD.Day_1 end) and (V.Payment_CC+V.Payment_OC)<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4 Then '4 ' else '' end+   
Case When V.Installment>=5 and datediff(day, V.DueDate_5, @P_Date)>=(Case When RD.ID is null then R.Day_1 else RD.Day_1 end) and (V.Payment_CC+V.Payment_OC)<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5 Then '5 ' else '' end+   
Case When V.Installment>=6 and datediff(day, V.DueDate_6, @P_Date)>=(Case When RD.ID is null then R.Day_1 else RD.Day_1 end) and (V.Payment_CC+V.Payment_OC)<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6 Then '6 ' else '' end+   
Case When V.Installment>=7 and datediff(day, V.DueDate_7, @P_Date)>=(Case When RD.ID is null then R.Day_1 else RD.Day_1 end) and (V.Payment_CC+V.Payment_OC)<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7 Then '7 ' else '' end+   
Case When V.Installment>=8 and datediff(day, V.DueDate_8, @P_Date)>=(Case When RD.ID is null then R.Day_1 else RD.Day_1 end) and (V.Payment_CC+V.Payment_OC)<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8 Then '8 ' else '' end+   
Case When V.Installment>=9 and datediff(day, V.DueDate_9, @P_Date)>=(Case When RD.ID is null then R.Day_1 else RD.Day_1 end) and (V.Payment_CC+V.Payment_OC)<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9 Then '9 ' else '' end+   
Case When V.Installment>=10 and datediff(day, V.DueDate_10, @P_Date)>=(Case When RD.ID is null then R.Day_1 else RD.Day_1 end) and (V.Payment_CC+V.Payment_OC)<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10  Then '10 ' else '' end+   
Case When V.Installment>=11 and datediff(day, V.DueDate_11, @P_Date)>=(Case When RD.ID is null then R.Day_1 else RD.Day_1 end) and (V.Payment_CC+V.Payment_OC)<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11 Then '11 ' else '' end+   
Case When V.Installment>=12 and datediff(day, V.DueDate_12, @P_Date)>=(Case When RD.ID is null then R.Day_1 else RD.Day_1 end) and (V.Payment_CC+V.Payment_OC)<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12 Then '12 ' else '' end+   
Case When V.Installment>=13 and datediff(day, V.DueDate_13, @P_Date)>=(Case When RD.ID is null then R.Day_1 else RD.Day_1 end) and (V.Payment_CC+V.Payment_OC)<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13 Then '13 ' else '' end+   
Case When V.Installment>=14 and datediff(day, V.DueDate_14, @P_Date)>=(Case When RD.ID is null then R.Day_1 else RD.Day_1 end) and (V.Payment_CC+V.Payment_OC)<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14 Then '14 ' else '' end+   
Case When V.Installment>=15 and datediff(day, V.DueDate_15, @P_Date)>=(Case When RD.ID is null then R.Day_1 else RD.Day_1 end) and (V.Payment_CC+V.Payment_OC)<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15 Then '15 ' else '' end+   
Case When V.Installment>=16 and datediff(day, V.DueDate_16, @P_Date)>=(Case When RD.ID is null then R.Day_1 else RD.Day_1 end) and (V.Payment_CC+V.Payment_OC)<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16 Then '16 ' else '' end+   
Case When V.Installment>=17 and datediff(day, V.DueDate_17, @P_Date)>=(Case When RD.ID is null then R.Day_1 else RD.Day_1 end) and (V.Payment_CC+V.Payment_OC)<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16+V.AmountDue_17 Then '17 ' else '' end+   
Case When V.Installment>=18 and datediff(day, V.DueDate_18, @P_Date)>=(Case When RD.ID is null then R.Day_1 else RD.Day_1 end) and (V.Payment_CC+V.Payment_OC)<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16+V.AmountDue_17+V.AmountDue_18 Then '18 ' else '' end+   
Case When V.Installment>=19 and datediff(day, V.DueDate_19, @P_Date)>=(Case When RD.ID is null then R.Day_1 else RD.Day_1 end) and (V.Payment_CC+V.Payment_OC)<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16+V.AmountDue_17+V.AmountDue_18+V.AmountDue_19 Then '19 ' else '' end+   
Case When V.Installment>=20 and datediff(day, V.DueDate_20, @P_Date)>=(Case When RD.ID is null then R.Day_1 else RD.Day_1 end) and (V.Payment_CC+V.Payment_OC)<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16+V.AmountDue_17+V.AmountDue_18+V.AmountDue_19+V.AmountDue_20 Then '20 ' else '' end+   
Case When V.Installment>=21 and datediff(day, V.DueDate_21, @P_Date)>=(Case When RD.ID is null then R.Day_1 else RD.Day_1 end) and (V.Payment_CC+V.Payment_OC)<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16+V.AmountDue_17+V.AmountDue_18+V.AmountDue_19+V.AmountDue_20+V.AmountDue_21 Then '21 ' else '' end+   
Case When V.Installment>=22 and datediff(day, V.DueDate_22, @P_Date)>=(Case When RD.ID is null then R.Day_1 else RD.Day_1 end) and (V.Payment_CC+V.Payment_OC)<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16+V.AmountDue_17+V.AmountDue_18+V.AmountDue_19+V.AmountDue_20+V.AmountDue_21+V.AmountDue_22 Then '22 ' else '' end+   
Case When V.Installment>=23 and datediff(day, V.DueDate_23, @P_Date)>=(Case When RD.ID is null then R.Day_1 else RD.Day_1 end) and (V.Payment_CC+V.Payment_OC)<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16+V.AmountDue_17+V.AmountDue_18+V.AmountDue_19+V.AmountDue_20+V.AmountDue_21+V.AmountDue_22+V.AmountDue_23 Then '23 ' else '' end+   
Case When V.Installment>=24 and datediff(day, V.DueDate_24, @P_Date)>=(Case When RD.ID is null then R.Day_1 else RD.Day_1 end) and (V.Payment_CC+V.Payment_OC)<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16+V.AmountDue_17+V.AmountDue_18+V.AmountDue_19+V.AmountDue_20+V.AmountDue_21+V.AmountDue_22+V.AmountDue_23+V.AmountDue_24 Then '24 ' else '' end+   
Case When V.Installment<>0 then 'of '+cast(V.Installment as varchar(255)) else '' end) as sInstallment   
   
from nVoucher V 
Cross Apply (Select Top 1 A.Source, A.ISType from Admlink A Where A.Voucher=V.Voucher) A
inner join Reminder R on (R.Reminder=@P_Reminder) 
Left Join ReminderD RD on (R.Reminder=RD.Reminder and RD.ID=A.Source and RD.ISType=A.ISType)      
Where V.Date<=@P_Date  
and ((V.Nominal_CC-V.Diff_CC-(V.Payment_CC+V.Payment_OC))<>0 or V.PDate>@P_Date)      
and datediff(day,
Case When V.Installment=0 then V.DueDate   
When (V.Payment_CC+V.Payment_OC)<V.AmountDue_1 then V.DueDate_1   
When (V.Payment_CC+V.Payment_OC)<V.AmountDue_1+V.AmountDue_2 then V.DueDate_2   
When (V.Payment_CC+V.Payment_OC)<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3 then V.DueDate_3   
When (V.Payment_CC+V.Payment_OC)<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4 then V.DueDate_4   
When (V.Payment_CC+V.Payment_OC)<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5 then V.DueDate_5   
When (V.Payment_CC+V.Payment_OC)<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6 then V.DueDate_6   
When (V.Payment_CC+V.Payment_OC)<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7 then V.DueDate_7   
When (V.Payment_CC+V.Payment_OC)<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8 then V.DueDate_8   
When (V.Payment_CC+V.Payment_OC)<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9 then V.DueDate_9   
When (V.Payment_CC+V.Payment_OC)<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10 then V.DueDate_10   
When (V.Payment_CC+V.Payment_OC)<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11 then V.DueDate_11   
When (V.Payment_CC+V.Payment_OC)<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12 then V.DueDate_12   
When (V.Payment_CC+V.Payment_OC)<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13 then V.DueDate_13   
When (V.Payment_CC+V.Payment_OC)<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14 then V.DueDate_14   
When (V.Payment_CC+V.Payment_OC)<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15 then V.DueDate_15   
When (V.Payment_CC+V.Payment_OC)<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16 then V.DueDate_16   
When (V.Payment_CC+V.Payment_OC)<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16+V.AmountDue_17 then V.DueDate_17   
When (V.Payment_CC+V.Payment_OC)<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16+V.AmountDue_17+V.AmountDue_18 then V.DueDate_18   
When (V.Payment_CC+V.Payment_OC)<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16+V.AmountDue_17+V.AmountDue_18+V.AmountDue_19 then V.DueDate_19   
When (V.Payment_CC+V.Payment_OC)<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16+V.AmountDue_17+V.AmountDue_18+V.AmountDue_19+V.AmountDue_20 then V.DueDate_20   
When (V.Payment_CC+V.Payment_OC)<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16+V.AmountDue_17+V.AmountDue_18+V.AmountDue_19+V.AmountDue_20+V.AmountDue_21 then V.DueDate_21   
When (V.Payment_CC+V.Payment_OC)<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16+V.AmountDue_17+V.AmountDue_18+V.AmountDue_19+V.AmountDue_20+V.AmountDue_21+V.AmountDue_22 then V.DueDate_22   
When (V.Payment_CC+V.Payment_OC)<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16+V.AmountDue_17+V.AmountDue_18+V.AmountDue_19+V.AmountDue_20+V.AmountDue_21+V.AmountDue_22+V.AmountDue_23 then V.DueDate_23   Else V.DueDate_24   end, @P_Date) Between (Case When RD.ID is null then R.Day_1 else RD.Day_1 end) and (Case When RD.ID is null then R.Day_2 else RD.Day_2 end)      
)      



GO


DROP function VOUCHER_AMOUNTDUE_BY_BRANCH
GO
Create function VOUCHER_AMOUNTDUE_BY_BRANCH(@P_Date as smalldatetime,@P_Branch as varchar(10))    
RETURNS Table   
AS RETURN   
(   
Select V.Voucher, V.Branch, V.ProAcc, V.RefNo, V.DocNo, V.Currency, V.Installment, (V.Payment_CC+V.Payment_OC) as Payment_CC, cast(0 as Float) as Payment_OC,  V.DebtorF, V.CreditorF, V.StatID, V.ActionBy, V.ActionDate,  V.AcceptedBy, V.AcceptedDate,   
(Case When V.Installment=0 and V.DueDate <=@P_Date Then V.Nominal_CC-V.Diff_CC else 0 end+   
Case When V.Installment>=1 and V.DueDate_1 <=@P_Date Then V.AmountDue_1 else 0 end+   
Case When V.Installment>=2 and V.DueDate_2 <=@P_Date Then V.AmountDue_2 else 0 end+   
Case When V.Installment>=3 and V.DueDate_3 <=@P_Date Then V.AmountDue_3 else 0 end+   
Case When V.Installment>=4 and V.DueDate_4 <=@P_Date Then V.AmountDue_4 else 0 end+   
Case When V.Installment>=5 and V.DueDate_5 <=@P_Date Then V.AmountDue_5 else 0 end+   
Case When V.Installment>=6 and V.DueDate_6 <=@P_Date Then V.AmountDue_6 else 0 end+   
Case When V.Installment>=7 and V.DueDate_7 <=@P_Date Then V.AmountDue_7 else 0 end+   
Case When V.Installment>=8 and V.DueDate_8 <=@P_Date Then V.AmountDue_8 else 0 end+   
Case When V.Installment>=9 and V.DueDate_9 <=@P_Date Then V.AmountDue_9 else 0 end+   
Case When V.Installment>=10 and V.DueDate_10 <=@P_Date Then V.AmountDue_10 else 0 end+   
Case When V.Installment>=11 and V.DueDate_11 <=@P_Date Then V.AmountDue_11 else 0 end+   
Case When V.Installment>=12 and V.DueDate_12 <=@P_Date Then V.AmountDue_12 else 0 end+   
Case When V.Installment>=13 and V.DueDate_13 <=@P_Date Then V.AmountDue_13 else 0 end+   
Case When V.Installment>=14 and V.DueDate_14 <=@P_Date Then V.AmountDue_14 else 0 end+   
Case When V.Installment>=15 and V.DueDate_15 <=@P_Date Then V.AmountDue_15 else 0 end+   
Case When V.Installment>=16 and V.DueDate_16 <=@P_Date Then V.AmountDue_16 else 0 end+   
Case When V.Installment>=17 and V.DueDate_17 <=@P_Date Then V.AmountDue_17 else 0 end+   
Case When V.Installment>=18 and V.DueDate_18 <=@P_Date Then V.AmountDue_18 else 0 end+   
Case When V.Installment>=19 and V.DueDate_19 <=@P_Date Then V.AmountDue_19 else 0 end+   
Case When V.Installment>=20 and V.DueDate_20 <=@P_Date Then V.AmountDue_20 else 0 end+   
Case When V.Installment>=21 and V.DueDate_21 <=@P_Date Then V.AmountDue_21 else 0 end+   
Case When V.Installment>=22 and V.DueDate_22 <=@P_Date Then V.AmountDue_22 else 0 end+   
Case When V.Installment>=23 and V.DueDate_23 <=@P_Date Then V.AmountDue_23 else 0 end+   
Case When V.Installment>=24 and V.DueDate_24 <=@P_Date Then V.AmountDue_24 else 0 end) as AmountDue,   
   
Case When V.Installment=0 then V.DueDate   
When (V.Payment_CC+V.Payment_OC)<V.AmountDue_1 then V.DueDate_1   
When (V.Payment_CC+V.Payment_OC)<V.AmountDue_1+V.AmountDue_2 then V.DueDate_2   
When (V.Payment_CC+V.Payment_OC)<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3 then V.DueDate_3   
When (V.Payment_CC+V.Payment_OC)<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4 then V.DueDate_4   
When (V.Payment_CC+V.Payment_OC)<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5 then V.DueDate_5   
When (V.Payment_CC+V.Payment_OC)<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6 then V.DueDate_6   
When (V.Payment_CC+V.Payment_OC)<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7 then V.DueDate_7   
When (V.Payment_CC+V.Payment_OC)<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8 then V.DueDate_8   
When (V.Payment_CC+V.Payment_OC)<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9 then V.DueDate_9   
When (V.Payment_CC+V.Payment_OC)<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10 then V.DueDate_10   
When (V.Payment_CC+V.Payment_OC)<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11 then V.DueDate_11   
When (V.Payment_CC+V.Payment_OC)<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12 then V.DueDate_12   
When (V.Payment_CC+V.Payment_OC)<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13 then V.DueDate_13   
When (V.Payment_CC+V.Payment_OC)<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14 then V.DueDate_14   
When (V.Payment_CC+V.Payment_OC)<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15 then V.DueDate_15   
When (V.Payment_CC+V.Payment_OC)<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16 then V.DueDate_16   
When (V.Payment_CC+V.Payment_OC)<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16+V.AmountDue_17 then V.DueDate_17   
When (V.Payment_CC+V.Payment_OC)<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16+V.AmountDue_17+V.AmountDue_18 then V.DueDate_18   
When (V.Payment_CC+V.Payment_OC)<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16+V.AmountDue_17+V.AmountDue_18+V.AmountDue_19 then V.DueDate_19   
When (V.Payment_CC+V.Payment_OC)<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16+V.AmountDue_17+V.AmountDue_18+V.AmountDue_19+V.AmountDue_20 then V.DueDate_20   
When (V.Payment_CC+V.Payment_OC)<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16+V.AmountDue_17+V.AmountDue_18+V.AmountDue_19+V.AmountDue_20+V.AmountDue_21 then V.DueDate_21   
When (V.Payment_CC+V.Payment_OC)<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16+V.AmountDue_17+V.AmountDue_18+V.AmountDue_19+V.AmountDue_20+V.AmountDue_21+V.AmountDue_22 then V.DueDate_22   
When (V.Payment_CC+V.Payment_OC)<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16+V.AmountDue_17+V.AmountDue_18+V.AmountDue_19+V.AmountDue_20+V.AmountDue_21+V.AmountDue_22+V.AmountDue_23 then V.DueDate_23   
Else V.DueDate_24   
end as DueDate,   
(Case When V.Installment<>0 then ' Installment No. ' else '' end+   
Case When V.Installment>=1 and V.DueDate_1 <=@P_Date and (V.Payment_CC+V.Payment_OC)<V.AmountDue_1 Then '1 ' else '' end+   
Case When V.Installment>=2 and V.DueDate_2 <=@P_Date and (V.Payment_CC+V.Payment_OC)<V.AmountDue_1+V.AmountDue_2 Then '2 ' else '' end+   
Case When V.Installment>=3 and V.DueDate_3 <=@P_Date and (V.Payment_CC+V.Payment_OC)<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3 Then '3 ' else '' end+   
Case When V.Installment>=4 and V.DueDate_4 <=@P_Date and (V.Payment_CC+V.Payment_OC)<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4 Then '4 ' else '' end+   
Case When V.Installment>=5 and V.DueDate_5 <=@P_Date and (V.Payment_CC+V.Payment_OC)<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5 Then '5 ' else '' end+   
Case When V.Installment>=6 and V.DueDate_6 <=@P_Date and (V.Payment_CC+V.Payment_OC)<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6 Then '6 ' else '' end+   
Case When V.Installment>=7 and V.DueDate_7 <=@P_Date and (V.Payment_CC+V.Payment_OC)<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7 Then '7 ' else '' end+   
Case When V.Installment>=8 and V.DueDate_8 <=@P_Date and (V.Payment_CC+V.Payment_OC)<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8 Then '8 ' else '' end+   
Case When V.Installment>=9 and V.DueDate_9 <=@P_Date and (V.Payment_CC+V.Payment_OC)<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9 Then '9 ' else '' end+   
Case When V.Installment>=10 and V.DueDate_10 <=@P_Date and (V.Payment_CC+V.Payment_OC)<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10  Then '10 ' else '' end+   
Case When V.Installment>=11 and V.DueDate_11 <=@P_Date and (V.Payment_CC+V.Payment_OC)<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11 Then '11 ' else '' end+   
Case When V.Installment>=12 and V.DueDate_12 <=@P_Date and (V.Payment_CC+V.Payment_OC)<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12 Then '12 ' else '' end+   
Case When V.Installment>=13 and V.DueDate_13 <=@P_Date and (V.Payment_CC+V.Payment_OC)<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13 Then '13 ' else '' end+   
Case When V.Installment>=14 and V.DueDate_14 <=@P_Date and (V.Payment_CC+V.Payment_OC)<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14 Then '14 ' else '' end+   
Case When V.Installment>=15 and V.DueDate_15 <=@P_Date and (V.Payment_CC+V.Payment_OC)<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15 Then '15 ' else '' end+   
Case When V.Installment>=16 and V.DueDate_16 <=@P_Date and (V.Payment_CC+V.Payment_OC)<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16 Then '16 ' else '' end+   
Case When V.Installment>=17 and V.DueDate_17 <=@P_Date and (V.Payment_CC+V.Payment_OC)<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16+V.AmountDue_17 Then '17 ' else '' end+   
Case When V.Installment>=18 and V.DueDate_18 <=@P_Date and (V.Payment_CC+V.Payment_OC)<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16+V.AmountDue_17+V.AmountDue_18 Then '18 ' else '' end+   
Case When V.Installment>=19 and V.DueDate_19 <=@P_Date and (V.Payment_CC+V.Payment_OC)<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16+V.AmountDue_17+V.AmountDue_18+V.AmountDue_19 Then '19 ' else '' end+   
Case When V.Installment>=20 and V.DueDate_20 <=@P_Date and (V.Payment_CC+V.Payment_OC)<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16+V.AmountDue_17+V.AmountDue_18+V.AmountDue_19+V.AmountDue_20 Then '20 ' else '' end+   
Case When V.Installment>=21 and V.DueDate_21 <=@P_Date and (V.Payment_CC+V.Payment_OC)<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16+V.AmountDue_17+V.AmountDue_18+V.AmountDue_19+V.AmountDue_20+V.AmountDue_21 Then '21 ' else '' end+   
Case When V.Installment>=22 and V.DueDate_22 <=@P_Date and (V.Payment_CC+V.Payment_OC)<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16+V.AmountDue_17+V.AmountDue_18+V.AmountDue_19+V.AmountDue_20+V.AmountDue_21+V.AmountDue_22 Then '22 ' else '' end+   
Case When V.Installment>=23 and V.DueDate_23 <=@P_Date and (V.Payment_CC+V.Payment_OC)<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16+V.AmountDue_17+V.AmountDue_18+V.AmountDue_19+V.AmountDue_20+V.AmountDue_21+V.AmountDue_22+V.AmountDue_23 Then '23 ' else '' end+   
Case When V.Installment>=24 and V.DueDate_24 <=@P_Date and (V.Payment_CC+V.Payment_OC)<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16+V.AmountDue_17+V.AmountDue_18+V.AmountDue_19+V.AmountDue_20+V.AmountDue_21+V.AmountDue_22+V.AmountDue_23+V.AmountDue_24 Then '24 ' else '' end+   
Case When V.Installment<>0 then 'of '+cast(V.Installment as varchar(255)) else '' end) as sInstallment   
from nVoucher V   
Where V.Date<=@P_Date and ((V.Nominal_CC-V.Diff_CC-(V.Payment_CC+V.Payment_OC))<>0 or V.PDate>@P_Date)   
and V.Branch Like @P_BRANCH+'%'
)   

GO

DROP function VOUCHER_AMOUNTDUE_BY_VOUCHER
GO
Create function VOUCHER_AMOUNTDUE_BY_VOUCHER(@P_Date as smalldatetime,@P_VOUCHER as varchar(10))    
RETURNS Table   
AS RETURN   
(   
Select V.Voucher, V.Branch, V.ProAcc, V.RefNo, V.DocNo, V.Currency, V.Installment, (V.Payment_CC+V.Payment_OC) as Payment_CC, cast(0 as Float) as Payment_OC,  V.DebtorF, V.CreditorF, V.StatID, V.ActionBy, V.ActionDate,  V.AcceptedBy, V.AcceptedDate,   
(Case When V.Installment=0 and V.DueDate <=@P_Date Then V.Nominal_CC-V.Diff_CC else 0 end+   
Case When V.Installment>=1 and V.DueDate_1 <=@P_Date Then V.AmountDue_1 else 0 end+   
Case When V.Installment>=2 and V.DueDate_2 <=@P_Date Then V.AmountDue_2 else 0 end+   
Case When V.Installment>=3 and V.DueDate_3 <=@P_Date Then V.AmountDue_3 else 0 end+   
Case When V.Installment>=4 and V.DueDate_4 <=@P_Date Then V.AmountDue_4 else 0 end+   
Case When V.Installment>=5 and V.DueDate_5 <=@P_Date Then V.AmountDue_5 else 0 end+   
Case When V.Installment>=6 and V.DueDate_6 <=@P_Date Then V.AmountDue_6 else 0 end+   
Case When V.Installment>=7 and V.DueDate_7 <=@P_Date Then V.AmountDue_7 else 0 end+   
Case When V.Installment>=8 and V.DueDate_8 <=@P_Date Then V.AmountDue_8 else 0 end+   
Case When V.Installment>=9 and V.DueDate_9 <=@P_Date Then V.AmountDue_9 else 0 end+   
Case When V.Installment>=10 and V.DueDate_10 <=@P_Date Then V.AmountDue_10 else 0 end+   
Case When V.Installment>=11 and V.DueDate_11 <=@P_Date Then V.AmountDue_11 else 0 end+   
Case When V.Installment>=12 and V.DueDate_12 <=@P_Date Then V.AmountDue_12 else 0 end+   
Case When V.Installment>=13 and V.DueDate_13 <=@P_Date Then V.AmountDue_13 else 0 end+   
Case When V.Installment>=14 and V.DueDate_14 <=@P_Date Then V.AmountDue_14 else 0 end+   
Case When V.Installment>=15 and V.DueDate_15 <=@P_Date Then V.AmountDue_15 else 0 end+   
Case When V.Installment>=16 and V.DueDate_16 <=@P_Date Then V.AmountDue_16 else 0 end+   
Case When V.Installment>=17 and V.DueDate_17 <=@P_Date Then V.AmountDue_17 else 0 end+   
Case When V.Installment>=18 and V.DueDate_18 <=@P_Date Then V.AmountDue_18 else 0 end+   
Case When V.Installment>=19 and V.DueDate_19 <=@P_Date Then V.AmountDue_19 else 0 end+   
Case When V.Installment>=20 and V.DueDate_20 <=@P_Date Then V.AmountDue_20 else 0 end+   
Case When V.Installment>=21 and V.DueDate_21 <=@P_Date Then V.AmountDue_21 else 0 end+   
Case When V.Installment>=22 and V.DueDate_22 <=@P_Date Then V.AmountDue_22 else 0 end+   
Case When V.Installment>=23 and V.DueDate_23 <=@P_Date Then V.AmountDue_23 else 0 end+   
Case When V.Installment>=24 and V.DueDate_24 <=@P_Date Then V.AmountDue_24 else 0 end) as AmountDue,   
   
Case When V.Installment=0 then V.DueDate   
When (V.Payment_CC+V.Payment_OC)<V.AmountDue_1 then V.DueDate_1   
When (V.Payment_CC+V.Payment_OC)<V.AmountDue_1+V.AmountDue_2 then V.DueDate_2   
When (V.Payment_CC+V.Payment_OC)<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3 then V.DueDate_3   
When (V.Payment_CC+V.Payment_OC)<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4 then V.DueDate_4   
When (V.Payment_CC+V.Payment_OC)<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5 then V.DueDate_5   
When (V.Payment_CC+V.Payment_OC)<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6 then V.DueDate_6   
When (V.Payment_CC+V.Payment_OC)<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7 then V.DueDate_7   
When (V.Payment_CC+V.Payment_OC)<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8 then V.DueDate_8   
When (V.Payment_CC+V.Payment_OC)<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9 then V.DueDate_9   
When (V.Payment_CC+V.Payment_OC)<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10 then V.DueDate_10   
When (V.Payment_CC+V.Payment_OC)<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11 then V.DueDate_11   
When (V.Payment_CC+V.Payment_OC)<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12 then V.DueDate_12   
When (V.Payment_CC+V.Payment_OC)<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13 then V.DueDate_13   
When (V.Payment_CC+V.Payment_OC)<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14 then V.DueDate_14   
When (V.Payment_CC+V.Payment_OC)<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15 then V.DueDate_15   
When (V.Payment_CC+V.Payment_OC)<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16 then V.DueDate_16   
When (V.Payment_CC+V.Payment_OC)<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16+V.AmountDue_17 then V.DueDate_17   
When (V.Payment_CC+V.Payment_OC)<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16+V.AmountDue_17+V.AmountDue_18 then V.DueDate_18   
When (V.Payment_CC+V.Payment_OC)<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16+V.AmountDue_17+V.AmountDue_18+V.AmountDue_19 then V.DueDate_19   
When (V.Payment_CC+V.Payment_OC)<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16+V.AmountDue_17+V.AmountDue_18+V.AmountDue_19+V.AmountDue_20 then V.DueDate_20   
When (V.Payment_CC+V.Payment_OC)<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16+V.AmountDue_17+V.AmountDue_18+V.AmountDue_19+V.AmountDue_20+V.AmountDue_21 then V.DueDate_21   
When (V.Payment_CC+V.Payment_OC)<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16+V.AmountDue_17+V.AmountDue_18+V.AmountDue_19+V.AmountDue_20+V.AmountDue_21+V.AmountDue_22 then V.DueDate_22   
When (V.Payment_CC+V.Payment_OC)<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16+V.AmountDue_17+V.AmountDue_18+V.AmountDue_19+V.AmountDue_20+V.AmountDue_21+V.AmountDue_22+V.AmountDue_23 then V.DueDate_23   
Else V.DueDate_24   
end as DueDate,   
(Case When V.Installment<>0 then ' Installment No. ' else '' end+   
Case When V.Installment>=1 and V.DueDate_1 <=@P_Date and (V.Payment_CC+V.Payment_OC)<V.AmountDue_1 Then '1 ' else '' end+   
Case When V.Installment>=2 and V.DueDate_2 <=@P_Date and (V.Payment_CC+V.Payment_OC)<V.AmountDue_1+V.AmountDue_2 Then '2 ' else '' end+   
Case When V.Installment>=3 and V.DueDate_3 <=@P_Date and (V.Payment_CC+V.Payment_OC)<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3 Then '3 ' else '' end+   
Case When V.Installment>=4 and V.DueDate_4 <=@P_Date and (V.Payment_CC+V.Payment_OC)<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4 Then '4 ' else '' end+   
Case When V.Installment>=5 and V.DueDate_5 <=@P_Date and (V.Payment_CC+V.Payment_OC)<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5 Then '5 ' else '' end+   
Case When V.Installment>=6 and V.DueDate_6 <=@P_Date and (V.Payment_CC+V.Payment_OC)<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6 Then '6 ' else '' end+   
Case When V.Installment>=7 and V.DueDate_7 <=@P_Date and (V.Payment_CC+V.Payment_OC)<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7 Then '7 ' else '' end+   
Case When V.Installment>=8 and V.DueDate_8 <=@P_Date and (V.Payment_CC+V.Payment_OC)<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8 Then '8 ' else '' end+   
Case When V.Installment>=9 and V.DueDate_9 <=@P_Date and (V.Payment_CC+V.Payment_OC)<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9 Then '9 ' else '' end+   
Case When V.Installment>=10 and V.DueDate_10 <=@P_Date and (V.Payment_CC+V.Payment_OC)<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10  Then '10 ' else '' end+   
Case When V.Installment>=11 and V.DueDate_11 <=@P_Date and (V.Payment_CC+V.Payment_OC)<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11 Then '11 ' else '' end+   
Case When V.Installment>=12 and V.DueDate_12 <=@P_Date and (V.Payment_CC+V.Payment_OC)<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12 Then '12 ' else '' end+   
Case When V.Installment>=13 and V.DueDate_13 <=@P_Date and (V.Payment_CC+V.Payment_OC)<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13 Then '13 ' else '' end+   
Case When V.Installment>=14 and V.DueDate_14 <=@P_Date and (V.Payment_CC+V.Payment_OC)<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14 Then '14 ' else '' end+   
Case When V.Installment>=15 and V.DueDate_15 <=@P_Date and (V.Payment_CC+V.Payment_OC)<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15 Then '15 ' else '' end+   
Case When V.Installment>=16 and V.DueDate_16 <=@P_Date and (V.Payment_CC+V.Payment_OC)<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16 Then '16 ' else '' end+   
Case When V.Installment>=17 and V.DueDate_17 <=@P_Date and (V.Payment_CC+V.Payment_OC)<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16+V.AmountDue_17 Then '17 ' else '' end+   
Case When V.Installment>=18 and V.DueDate_18 <=@P_Date and (V.Payment_CC+V.Payment_OC)<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16+V.AmountDue_17+V.AmountDue_18 Then '18 ' else '' end+   
Case When V.Installment>=19 and V.DueDate_19 <=@P_Date and (V.Payment_CC+V.Payment_OC)<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16+V.AmountDue_17+V.AmountDue_18+V.AmountDue_19 Then '19 ' else '' end+   
Case When V.Installment>=20 and V.DueDate_20 <=@P_Date and (V.Payment_CC+V.Payment_OC)<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16+V.AmountDue_17+V.AmountDue_18+V.AmountDue_19+V.AmountDue_20 Then '20 ' else '' end+   
Case When V.Installment>=21 and V.DueDate_21 <=@P_Date and (V.Payment_CC+V.Payment_OC)<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16+V.AmountDue_17+V.AmountDue_18+V.AmountDue_19+V.AmountDue_20+V.AmountDue_21 Then '21 ' else '' end+   
Case When V.Installment>=22 and V.DueDate_22 <=@P_Date and (V.Payment_CC+V.Payment_OC)<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16+V.AmountDue_17+V.AmountDue_18+V.AmountDue_19+V.AmountDue_20+V.AmountDue_21+V.AmountDue_22 Then '22 ' else '' end+   
Case When V.Installment>=23 and V.DueDate_23 <=@P_Date and (V.Payment_CC+V.Payment_OC)<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16+V.AmountDue_17+V.AmountDue_18+V.AmountDue_19+V.AmountDue_20+V.AmountDue_21+V.AmountDue_22+V.AmountDue_23 Then '23 ' else '' end+   
Case When V.Installment>=24 and V.DueDate_24 <=@P_Date and (V.Payment_CC+V.Payment_OC)<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16+V.AmountDue_17+V.AmountDue_18+V.AmountDue_19+V.AmountDue_20+V.AmountDue_21+V.AmountDue_22+V.AmountDue_23+V.AmountDue_24 Then '24 ' else '' end+   
Case When V.Installment<>0 then 'of '+cast(V.Installment as varchar(255)) else '' end) as sInstallment   
from nVoucher V   
Where V.Date<=@P_Date and ((V.Nominal_CC-V.Diff_CC-(V.Payment_CC+V.Payment_OC))<>0 or V.PDate>@P_Date)   
and V.VOUCHER=@P_VOUCHER
)   

GO

DROP function VOUCHER_AMOUNTDUE_EXTAX
GO
CREATE function VOUCHER_AMOUNTDUE_EXTAX(@P_Date as smalldatetime) 

RETURNS Table 
AS RETURN 
( 
Select V.Voucher, V.Remarks, V.CollNo, V.Branch, V.ProAcc, V.RefNo, V.DocNo, V.Currency, V.Installment, (V.Payment_CC+V.Payment_OC) as Payment_CC, cast(0 as Float) as Payment_OC,  V.DebtorF, V.CreditorF, V.StatID, V.ActionBy, V.ActionDate,  V.AcceptedBy, V.AcceptedDate, 
(Case When V.Installment=0 and V.DueDate <=@P_Date Then V.Nominal_CC-V.Diff_CC else 0 end+ 
Case When V.Installment>=1 and V.DueDate_1 <=@P_Date Then V.AmountDue_1 else 0 end+ 
Case When V.Installment>=2 and V.DueDate_2 <=@P_Date Then V.AmountDue_2 else 0 end+ 
Case When V.Installment>=3 and V.DueDate_3 <=@P_Date Then V.AmountDue_3 else 0 end+ 
Case When V.Installment>=4 and V.DueDate_4 <=@P_Date Then V.AmountDue_4 else 0 end+ 
Case When V.Installment>=5 and V.DueDate_5 <=@P_Date Then V.AmountDue_5 else 0 end+ 
Case When V.Installment>=6 and V.DueDate_6 <=@P_Date Then V.AmountDue_6 else 0 end+ 
Case When V.Installment>=7 and V.DueDate_7 <=@P_Date Then V.AmountDue_7 else 0 end+ 
Case When V.Installment>=8 and V.DueDate_8 <=@P_Date Then V.AmountDue_8 else 0 end+ 
Case When V.Installment>=9 and V.DueDate_9 <=@P_Date Then V.AmountDue_9 else 0 end+ 
Case When V.Installment>=10 and V.DueDate_10 <=@P_Date Then V.AmountDue_10 else 0 end+ 
Case When V.Installment>=11 and V.DueDate_11 <=@P_Date Then V.AmountDue_11 else 0 end+ 
Case When V.Installment>=12 and V.DueDate_12 <=@P_Date Then V.AmountDue_12 else 0 end+ 
Case When V.Installment>=13 and V.DueDate_13 <=@P_Date Then V.AmountDue_13 else 0 end+ 
Case When V.Installment>=14 and V.DueDate_14 <=@P_Date Then V.AmountDue_14 else 0 end+ 
Case When V.Installment>=15 and V.DueDate_15 <=@P_Date Then V.AmountDue_15 else 0 end+ 
Case When V.Installment>=16 and V.DueDate_16 <=@P_Date Then V.AmountDue_16 else 0 end+ 
Case When V.Installment>=17 and V.DueDate_17 <=@P_Date Then V.AmountDue_17 else 0 end+ 
Case When V.Installment>=18 and V.DueDate_18 <=@P_Date Then V.AmountDue_18 else 0 end+ 
Case When V.Installment>=19 and V.DueDate_19 <=@P_Date Then V.AmountDue_19 else 0 end+ 
Case When V.Installment>=20 and V.DueDate_20 <=@P_Date Then V.AmountDue_20 else 0 end+ 
Case When V.Installment>=21 and V.DueDate_21 <=@P_Date Then V.AmountDue_21 else 0 end+ 
Case When V.Installment>=22 and V.DueDate_22 <=@P_Date Then V.AmountDue_22 else 0 end+ 
Case When V.Installment>=23 and V.DueDate_23 <=@P_Date Then V.AmountDue_23 else 0 end+ 
Case When V.Installment>=24 and V.DueDate_24 <=@P_Date Then V.AmountDue_24 else 0 end) as AmountDue, 

Case When V.Installment=0 then 0
When (V.Payment_CC+V.Payment_OC)<(V.AmountDue_1) then (V.AmountDue_1)-(V.Payment_CC+V.Payment_OC)
When (V.Payment_CC+V.Payment_OC)<(V.AmountDue_1+V.AmountDue_2) then (V.AmountDue_1+V.AmountDue_2)-(V.Payment_CC+V.Payment_OC)
When (V.Payment_CC+V.Payment_OC)<(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3) then (V.AmountDue_1+V.AmountDue_2+V.AmountDue_3)-(V.Payment_CC+V.Payment_OC)
When (V.Payment_CC+V.Payment_OC)<(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4) then (V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4)-(V.Payment_CC+V.Payment_OC)
When (V.Payment_CC+V.Payment_OC)<(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5) then (V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5)-(V.Payment_CC+V.Payment_OC)
When (V.Payment_CC+V.Payment_OC)<(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6) then (V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6)-(V.Payment_CC+V.Payment_OC)
When (V.Payment_CC+V.Payment_OC)<(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7) then (V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7)-(V.Payment_CC+V.Payment_OC)
When (V.Payment_CC+V.Payment_OC)<(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8) then (V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8)-(V.Payment_CC+V.Payment_OC)
When (V.Payment_CC+V.Payment_OC)<(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9) then (V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9)-(V.Payment_CC+V.Payment_OC)
When (V.Payment_CC+V.Payment_OC)<(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10) then (V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10)-(V.Payment_CC+V.Payment_OC)
When (V.Payment_CC+V.Payment_OC)<(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11) then (V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11)-(V.Payment_CC+V.Payment_OC)
When (V.Payment_CC+V.Payment_OC)<(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12) then (V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12)-(V.Payment_CC+V.Payment_OC)
When (V.Payment_CC+V.Payment_OC)<(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13) then (V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13)-(V.Payment_CC+V.Payment_OC)
When (V.Payment_CC+V.Payment_OC)<(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14) then (V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14)-(V.Payment_CC+V.Payment_OC)
When (V.Payment_CC+V.Payment_OC)<(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15) then (V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15)-(V.Payment_CC+V.Payment_OC)
When (V.Payment_CC+V.Payment_OC)<(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16) then (V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16)-(V.Payment_CC+V.Payment_OC)
When (V.Payment_CC+V.Payment_OC)<(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16+V.AmountDue_17) then (V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16+V.AmountDue_17)-(V.Payment_CC+V.Payment_OC)
When (V.Payment_CC+V.Payment_OC)<(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16+V.AmountDue_17+V.AmountDue_18) then (V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16+V.AmountDue_17+V.AmountDue_18)-(V.Payment_CC+V.Payment_OC)
When (V.Payment_CC+V.Payment_OC)<(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16+V.AmountDue_17+V.AmountDue_18+V.AmountDue_19) then (V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16+V.AmountDue_17+V.AmountDue_18+V.AmountDue_19)-(V.Payment_CC+V.Payment_OC)
When (V.Payment_CC+V.Payment_OC)<(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16+V.AmountDue_17+V.AmountDue_18+V.AmountDue_19+V.AmountDue_20) then (V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16+V.AmountDue_17+V.AmountDue_18+V.AmountDue_19+V.AmountDue_20)-(V.Payment_CC+V.Payment_OC)
When (V.Payment_CC+V.Payment_OC)<(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16+V.AmountDue_17+V.AmountDue_18+V.AmountDue_19+V.AmountDue_20+V.AmountDue_21) then (V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16+V.AmountDue_17+V.AmountDue_18+V.AmountDue_19+V.AmountDue_20+V.AmountDue_21)-(V.Payment_CC+V.Payment_OC)
When (V.Payment_CC+V.Payment_OC)<(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16+V.AmountDue_17+V.AmountDue_18+V.AmountDue_19+V.AmountDue_20+V.AmountDue_21+V.AmountDue_22) then (V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16+V.AmountDue_17+V.AmountDue_18+V.AmountDue_19+V.AmountDue_20+V.AmountDue_21+V.AmountDue_22)-(V.Payment_CC+V.Payment_OC)
When (V.Payment_CC+V.Payment_OC)<(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16+V.AmountDue_17+V.AmountDue_18+V.AmountDue_19+V.AmountDue_20+V.AmountDue_21+V.AmountDue_22+V.AmountDue_23) then (V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16+V.AmountDue_17+V.AmountDue_18+V.AmountDue_19+V.AmountDue_20+V.AmountDue_21+V.AmountDue_22+V.AmountDue_23)-(V.Payment_CC+V.Payment_OC)
Else 0
end as AmountNextDue, 

Case When V.Installment=0 then V.DueDate 
When (V.Payment_CC+V.Payment_OC)<(V.AmountDue_1) then V.DueDate_1 
When (V.Payment_CC+V.Payment_OC)<(V.AmountDue_1+V.AmountDue_2) then V.DueDate_2 
When (V.Payment_CC+V.Payment_OC)<(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3) then V.DueDate_3 
When (V.Payment_CC+V.Payment_OC)<(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4) then V.DueDate_4 
When (V.Payment_CC+V.Payment_OC)<(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5) then V.DueDate_5 
When (V.Payment_CC+V.Payment_OC)<(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6) then V.DueDate_6 
When (V.Payment_CC+V.Payment_OC)<(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7) then V.DueDate_7 
When (V.Payment_CC+V.Payment_OC)<(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8) then V.DueDate_8 
When (V.Payment_CC+V.Payment_OC)<(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9) then V.DueDate_9 
When (V.Payment_CC+V.Payment_OC)<(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10) then V.DueDate_10 
When (V.Payment_CC+V.Payment_OC)<(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11) then V.DueDate_11 
When (V.Payment_CC+V.Payment_OC)<(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12) then V.DueDate_12 
When (V.Payment_CC+V.Payment_OC)<(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13) then V.DueDate_13 
When (V.Payment_CC+V.Payment_OC)<(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14) then V.DueDate_14 
When (V.Payment_CC+V.Payment_OC)<(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15) then V.DueDate_15 
When (V.Payment_CC+V.Payment_OC)<(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16) then V.DueDate_16 
When (V.Payment_CC+V.Payment_OC)<(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16+V.AmountDue_17) then V.DueDate_17 
When (V.Payment_CC+V.Payment_OC)<(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16+V.AmountDue_17+V.AmountDue_18) then V.DueDate_18 
When (V.Payment_CC+V.Payment_OC)<(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16+V.AmountDue_17+V.AmountDue_18+V.AmountDue_19) then V.DueDate_19 
When (V.Payment_CC+V.Payment_OC)<(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16+V.AmountDue_17+V.AmountDue_18+V.AmountDue_19+V.AmountDue_20) then V.DueDate_20 
When (V.Payment_CC+V.Payment_OC)<(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16+V.AmountDue_17+V.AmountDue_18+V.AmountDue_19+V.AmountDue_20+V.AmountDue_21) then V.DueDate_21 
When (V.Payment_CC+V.Payment_OC)<(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16+V.AmountDue_17+V.AmountDue_18+V.AmountDue_19+V.AmountDue_20+V.AmountDue_21+V.AmountDue_22) then V.DueDate_22 
When (V.Payment_CC+V.Payment_OC)<(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16+V.AmountDue_17+V.AmountDue_18+V.AmountDue_19+V.AmountDue_20+V.AmountDue_21+V.AmountDue_22+V.AmountDue_23) then V.DueDate_23 
Else V.DueDate_24 
end as DueDate, 

Case When V.INSTALLMENT=0 Then (V.Nominal_CC-V.Diff_CC)-(V.Payment_CC+V.Payment_OC) else 0 end*(V.Nominal_CC-V.Diff_CC-V.Tax_CC)/(V.Nominal_CC-V.Diff_CC) as Outstanding_0,

(Case 
When V.AmountDue_1<(V.Payment_CC+V.Payment_OC) Then 0
else V.AmountDue_1-(V.Payment_CC+V.Payment_OC) end 
+
Case WHen V.Installment=1 and (V.Payment_CC+V.Payment_OC)>(V.Nominal_CC-V.Diff_CC) Then (V.Nominal_CC-V.Diff_CC)-(V.Payment_CC+V.Payment_OC) else 0 end
)*(V.Nominal_CC-V.Diff_CC-V.Tax_CC)/(V.Nominal_CC-V.Diff_CC) as Outstanding_1,

(Case 
When V.AmountDue_2<((V.Payment_CC+V.Payment_OC)-V.AmountDue_1) Then 0
When ((V.Payment_CC+V.Payment_OC)-V.AmountDue_1)<0 then V.AmountDue_2
else V.AmountDue_2-((V.Payment_CC+V.Payment_OC)-V.AmountDue_1) end 
+
Case WHen V.Installment=2 and (V.Payment_CC+V.Payment_OC)>(V.Nominal_CC-V.Diff_CC) Then (V.Nominal_CC-V.Diff_CC)-(V.Payment_CC+V.Payment_OC) else 0 end
)*(V.Nominal_CC-V.Diff_CC-V.Tax_CC)/(V.Nominal_CC-V.Diff_CC) as Outstanding_2,

(Case 
When V.AmountDue_3<((V.Payment_CC+V.Payment_OC)-(V.AmountDue_1+V.AmountDue_2)) Then 0
When ((V.Payment_CC+V.Payment_OC)-(V.AmountDue_1+V.AmountDue_2))<0 then V.AmountDue_3
else V.AmountDue_3-((V.Payment_CC+V.Payment_OC)-(V.AmountDue_1+V.AmountDue_2)) end 
+
Case WHen V.Installment=3 and (V.Payment_CC+V.Payment_OC)>(V.Nominal_CC-V.Diff_CC) Then (V.Nominal_CC-V.Diff_CC)-(V.Payment_CC+V.Payment_OC) else 0 end
)*(V.Nominal_CC-V.Diff_CC-V.Tax_CC)/(V.Nominal_CC-V.Diff_CC) as Outstanding_3,

(Case 
When V.AmountDue_4<((V.Payment_CC+V.Payment_OC)-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3)) Then 0
When ((V.Payment_CC+V.Payment_OC)-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3))<0 then V.AmountDue_4
else V.AmountDue_4-((V.Payment_CC+V.Payment_OC)-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3)) end 
+
Case WHen V.Installment=4 and (V.Payment_CC+V.Payment_OC)>(V.Nominal_CC-V.Diff_CC) Then (V.Nominal_CC-V.Diff_CC)-(V.Payment_CC+V.Payment_OC) else 0 end
)*(V.Nominal_CC-V.Diff_CC-V.Tax_CC)/(V.Nominal_CC-V.Diff_CC) as Outstanding_4,

(Case 
When V.AmountDue_5<((V.Payment_CC+V.Payment_OC)-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4)) Then 0
When ((V.Payment_CC+V.Payment_OC)-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4))<0 then V.AmountDue_5
else V.AmountDue_5-((V.Payment_CC+V.Payment_OC)-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4)) end 
+
Case WHen V.Installment=5 and (V.Payment_CC+V.Payment_OC)>(V.Nominal_CC-V.Diff_CC) Then (V.Nominal_CC-V.Diff_CC)-(V.Payment_CC+V.Payment_OC) else 0 end
)*(V.Nominal_CC-V.Diff_CC-V.Tax_CC)/(V.Nominal_CC-V.Diff_CC) as Outstanding_5,

(Case 
When V.AmountDue_6<((V.Payment_CC+V.Payment_OC)-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5)) Then 0
When ((V.Payment_CC+V.Payment_OC)-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5))<0 then V.AmountDue_6
else V.AmountDue_6-((V.Payment_CC+V.Payment_OC)-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5)) end 
+
Case WHen V.Installment=6 and (V.Payment_CC+V.Payment_OC)>(V.Nominal_CC-V.Diff_CC) Then (V.Nominal_CC-V.Diff_CC)-(V.Payment_CC+V.Payment_OC) else 0 end
)*(V.Nominal_CC-V.Diff_CC-V.Tax_CC)/(V.Nominal_CC-V.Diff_CC) as Outstanding_6,

(Case 
When V.AmountDue_7<((V.Payment_CC+V.Payment_OC)-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6)) Then 0
When ((V.Payment_CC+V.Payment_OC)-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6))<0 then V.AmountDue_7
else V.AmountDue_7-((V.Payment_CC+V.Payment_OC)-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6)) end 
+
Case WHen V.Installment=7 and (V.Payment_CC+V.Payment_OC)>(V.Nominal_CC-V.Diff_CC) Then (V.Nominal_CC-V.Diff_CC)-(V.Payment_CC+V.Payment_OC) else 0 end
)*(V.Nominal_CC-V.Diff_CC-V.Tax_CC)/(V.Nominal_CC-V.Diff_CC) as Outstanding_7,

(Case 
When V.AmountDue_8<((V.Payment_CC+V.Payment_OC)-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7)) Then 0
When ((V.Payment_CC+V.Payment_OC)-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7))<0 then V.AmountDue_8
else V.AmountDue_8-((V.Payment_CC+V.Payment_OC)-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7)) end 
+
Case WHen V.Installment=8 and (V.Payment_CC+V.Payment_OC)>(V.Nominal_CC-V.Diff_CC) Then (V.Nominal_CC-V.Diff_CC)-(V.Payment_CC+V.Payment_OC) else 0 end
)*(V.Nominal_CC-V.Diff_CC-V.Tax_CC)/(V.Nominal_CC-V.Diff_CC) as Outstanding_8,

(Case 
When V.AmountDue_9<((V.Payment_CC+V.Payment_OC)-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8)) Then 0
When ((V.Payment_CC+V.Payment_OC)-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8))<0 then V.AmountDue_9
else V.AmountDue_9-((V.Payment_CC+V.Payment_OC)-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8)) end 
+
Case WHen V.Installment=9 and (V.Payment_CC+V.Payment_OC)>(V.Nominal_CC-V.Diff_CC) Then (V.Nominal_CC-V.Diff_CC)-(V.Payment_CC+V.Payment_OC) else 0 end
)*(V.Nominal_CC-V.Diff_CC-V.Tax_CC)/(V.Nominal_CC-V.Diff_CC) as Outstanding_9,

(Case 
When V.AmountDue_10<((V.Payment_CC+V.Payment_OC)-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9)) Then 0
When ((V.Payment_CC+V.Payment_OC)-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9))<0 then V.AmountDue_10
else V.AmountDue_10-((V.Payment_CC+V.Payment_OC)-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9)) end 
+
Case WHen V.Installment=10 and (V.Payment_CC+V.Payment_OC)>(V.Nominal_CC-V.Diff_CC) Then (V.Nominal_CC-V.Diff_CC)-(V.Payment_CC+V.Payment_OC) else 0 end
)*(V.Nominal_CC-V.Diff_CC-V.Tax_CC)/(V.Nominal_CC-V.Diff_CC) as Outstanding_10,

(Case 
When V.AmountDue_11<((V.Payment_CC+V.Payment_OC)-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10)) Then 0
When ((V.Payment_CC+V.Payment_OC)-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10))<0 then V.AmountDue_11
else V.AmountDue_11-((V.Payment_CC+V.Payment_OC)-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10)) end 
+
Case WHen V.Installment=11 and (V.Payment_CC+V.Payment_OC)>(V.Nominal_CC-V.Diff_CC) Then (V.Nominal_CC-V.Diff_CC)-(V.Payment_CC+V.Payment_OC) else 0 end
)*(V.Nominal_CC-V.Diff_CC-V.Tax_CC)/(V.Nominal_CC-V.Diff_CC) as Outstanding_11,
  
(Case 
When V.AmountDue_12<((V.Payment_CC+V.Payment_OC)-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11)) Then 0
When ((V.Payment_CC+V.Payment_OC)-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11))<0 then V.AmountDue_12
else V.AmountDue_12-((V.Payment_CC+V.Payment_OC)-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11)) end 
+
Case WHen V.Installment=12 and (V.Payment_CC+V.Payment_OC)>(V.Nominal_CC-V.Diff_CC) Then (V.Nominal_CC-V.Diff_CC)-(V.Payment_CC+V.Payment_OC) else 0 end
)*(V.Nominal_CC-V.Diff_CC-V.Tax_CC)/(V.Nominal_CC-V.Diff_CC) as Outstanding_12,

(Case 
When V.AmountDue_13<((V.Payment_CC+V.Payment_OC)-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12)) Then 0
When ((V.Payment_CC+V.Payment_OC)-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12))<0 then V.AmountDue_13
else V.AmountDue_13-((V.Payment_CC+V.Payment_OC)-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12)) end 
+
Case WHen V.Installment=13 and (V.Payment_CC+V.Payment_OC)>(V.Nominal_CC-V.Diff_CC) Then (V.Nominal_CC-V.Diff_CC)-(V.Payment_CC+V.Payment_OC) else 0 end
)*(V.Nominal_CC-V.Diff_CC-V.Tax_CC)/(V.Nominal_CC-V.Diff_CC) as Outstanding_13,

(Case 
When V.AmountDue_14<((V.Payment_CC+V.Payment_OC)-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13)) Then 0
When ((V.Payment_CC+V.Payment_OC)-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13))<0 then V.AmountDue_14
else V.AmountDue_14-((V.Payment_CC+V.Payment_OC)-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13)) end 
+
Case WHen V.Installment=14 and (V.Payment_CC+V.Payment_OC)>(V.Nominal_CC-V.Diff_CC) Then (V.Nominal_CC-V.Diff_CC)-(V.Payment_CC+V.Payment_OC) else 0 end
)*(V.Nominal_CC-V.Diff_CC-V.Tax_CC)/(V.Nominal_CC-V.Diff_CC) as Outstanding_14, 
 
(Case 
When V.AmountDue_15<((V.Payment_CC+V.Payment_OC)-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14)) Then 0
When ((V.Payment_CC+V.Payment_OC)-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14))<0 then V.AmountDue_15
else V.AmountDue_15-((V.Payment_CC+V.Payment_OC)-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14)) end 
+
Case WHen V.Installment=15 and (V.Payment_CC+V.Payment_OC)>(V.Nominal_CC-V.Diff_CC) Then (V.Nominal_CC-V.Diff_CC)-(V.Payment_CC+V.Payment_OC) else 0 end
)*(V.Nominal_CC-V.Diff_CC-V.Tax_CC)/(V.Nominal_CC-V.Diff_CC) as Outstanding_15, 
 
(Case 
When V.AmountDue_16<((V.Payment_CC+V.Payment_OC)-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15)) Then 0
When ((V.Payment_CC+V.Payment_OC)-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15))<0 then V.AmountDue_16
else V.AmountDue_16-((V.Payment_CC+V.Payment_OC)-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15)) end 
+
Case WHen V.Installment=16 and (V.Payment_CC+V.Payment_OC)>(V.Nominal_CC-V.Diff_CC) Then (V.Nominal_CC-V.Diff_CC)-(V.Payment_CC+V.Payment_OC) else 0 end
)*(V.Nominal_CC-V.Diff_CC-V.Tax_CC)/(V.Nominal_CC-V.Diff_CC) as Outstanding_16, 

(Case 
When V.AmountDue_17<((V.Payment_CC+V.Payment_OC)-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16)) Then 0
When ((V.Payment_CC+V.Payment_OC)-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16))<0 then V.AmountDue_17
else V.AmountDue_17-((V.Payment_CC+V.Payment_OC)-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16)) end 
+
Case WHen V.Installment=17 and (V.Payment_CC+V.Payment_OC)>(V.Nominal_CC-V.Diff_CC) Then (V.Nominal_CC-V.Diff_CC)-(V.Payment_CC+V.Payment_OC) else 0 end
)*(V.Nominal_CC-V.Diff_CC-V.Tax_CC)/(V.Nominal_CC-V.Diff_CC) as Outstanding_17, 

(Case 
When V.AmountDue_18<((V.Payment_CC+V.Payment_OC)-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16+V.AmountDue_17)) Then 0
When ((V.Payment_CC+V.Payment_OC)-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16+V.AmountDue_17))<0 then V.AmountDue_18
else V.AmountDue_18-((V.Payment_CC+V.Payment_OC)-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16+V.AmountDue_17)) end 
+
Case WHen V.Installment=18 and (V.Payment_CC+V.Payment_OC)>(V.Nominal_CC-V.Diff_CC) Then (V.Nominal_CC-V.Diff_CC)-(V.Payment_CC+V.Payment_OC) else 0 end
)*(V.Nominal_CC-V.Diff_CC-V.Tax_CC)/(V.Nominal_CC-V.Diff_CC) as Outstanding_18, 

(Case 
When V.AmountDue_19<((V.Payment_CC+V.Payment_OC)-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16+V.AmountDue_17+V.AmountDue_18)) Then 0
When ((V.Payment_CC+V.Payment_OC)-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16+V.AmountDue_17+V.AmountDue_18))<0 then V.AmountDue_19
else V.AmountDue_19-((V.Payment_CC+V.Payment_OC)-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16+V.AmountDue_17+V.AmountDue_18)) end 
+
Case WHen V.Installment=19 and (V.Payment_CC+V.Payment_OC)>(V.Nominal_CC-V.Diff_CC) Then (V.Nominal_CC-V.Diff_CC)-(V.Payment_CC+V.Payment_OC) else 0 end
)*(V.Nominal_CC-V.Diff_CC-V.Tax_CC)/(V.Nominal_CC-V.Diff_CC) as Outstanding_19, 

(Case 
When V.AmountDue_20<((V.Payment_CC+V.Payment_OC)-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16+V.AmountDue_17+V.AmountDue_18+V.AmountDue_19)) Then 0
When ((V.Payment_CC+V.Payment_OC)-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16+V.AmountDue_17+V.AmountDue_18+V.AmountDue_19))<0 then V.AmountDue_20
else V.AmountDue_20-((V.Payment_CC+V.Payment_OC)-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16+V.AmountDue_17+V.AmountDue_18+V.AmountDue_19)) end 
+
Case WHen V.Installment=20 and (V.Payment_CC+V.Payment_OC)>(V.Nominal_CC-V.Diff_CC) Then (V.Nominal_CC-V.Diff_CC)-(V.Payment_CC+V.Payment_OC) else 0 end
)*(V.Nominal_CC-V.Diff_CC-V.Tax_CC)/(V.Nominal_CC-V.Diff_CC) as Outstanding_20, 
  
(Case 
When V.AmountDue_21<((V.Payment_CC+V.Payment_OC)-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16+V.AmountDue_17+V.AmountDue_18+V.AmountDue_19+V.AmountDue_20)) Then 0
When ((V.Payment_CC+V.Payment_OC)-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16+V.AmountDue_17+V.AmountDue_18+V.AmountDue_19+V.AmountDue_20))<0 then V.AmountDue_21
else V.AmountDue_21-((V.Payment_CC+V.Payment_OC)-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16+V.AmountDue_17+V.AmountDue_18+V.AmountDue_19+V.AmountDue_20)) end 
+
Case WHen V.Installment=21 and (V.Payment_CC+V.Payment_OC)>(V.Nominal_CC-V.Diff_CC) Then (V.Nominal_CC-V.Diff_CC)-(V.Payment_CC+V.Payment_OC) else 0 end
)*(V.Nominal_CC-V.Diff_CC-V.Tax_CC)/(V.Nominal_CC-V.Diff_CC) as Outstanding_21, 

(Case 
When V.AmountDue_22<((V.Payment_CC+V.Payment_OC)-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16+V.AmountDue_17+V.AmountDue_18+V.AmountDue_19+V.AmountDue_20+V.AmountDue_21)) Then 0
When ((V.Payment_CC+V.Payment_OC)-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16+V.AmountDue_17+V.AmountDue_18+V.AmountDue_19+V.AmountDue_20+V.AmountDue_21))<0 then V.AmountDue_22
else V.AmountDue_22-((V.Payment_CC+V.Payment_OC)-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16+V.AmountDue_17+V.AmountDue_18+V.AmountDue_19+V.AmountDue_20+V.AmountDue_21)) end 
+
Case WHen V.Installment=22 and (V.Payment_CC+V.Payment_OC)>(V.Nominal_CC-V.Diff_CC) Then (V.Nominal_CC-V.Diff_CC)-(V.Payment_CC+V.Payment_OC) else 0 end
)*(V.Nominal_CC-V.Diff_CC-V.Tax_CC)/(V.Nominal_CC-V.Diff_CC) as Outstanding_22, 

(Case 
When V.AmountDue_23<((V.Payment_CC+V.Payment_OC)-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16+V.AmountDue_17+V.AmountDue_18+V.AmountDue_19+V.AmountDue_20+V.AmountDue_21+V.AmountDue_22)) Then 0
When ((V.Payment_CC+V.Payment_OC)-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16+V.AmountDue_17+V.AmountDue_18+V.AmountDue_19+V.AmountDue_20+V.AmountDue_21+V.AmountDue_22))<0 then V.AmountDue_23
else V.AmountDue_23-((V.Payment_CC+V.Payment_OC)-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16+V.AmountDue_17+V.AmountDue_18+V.AmountDue_19+V.AmountDue_20+V.AmountDue_21+V.AmountDue_22)) end 
+
Case WHen V.Installment=23 and (V.Payment_CC+V.Payment_OC)>(V.Nominal_CC-V.Diff_CC) Then (V.Nominal_CC-V.Diff_CC)-(V.Payment_CC+V.Payment_OC) else 0 end
)*(V.Nominal_CC-V.Diff_CC-V.Tax_CC)/(V.Nominal_CC-V.Diff_CC) as Outstanding_23, 
 
(Case 
When V.AmountDue_24<((V.Payment_CC+V.Payment_OC)-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16+V.AmountDue_17+V.AmountDue_18+V.AmountDue_19+V.AmountDue_20+V.AmountDue_21+V.AmountDue_22+V.AmountDue_23)) Then 0
When ((V.Payment_CC+V.Payment_OC)-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16+V.AmountDue_17+V.AmountDue_18+V.AmountDue_19+V.AmountDue_20+V.AmountDue_21+V.AmountDue_22+V.AmountDue_23))<0 then V.AmountDue_24
else V.AmountDue_24-((V.Payment_CC+V.Payment_OC)-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16+V.AmountDue_17+V.AmountDue_18+V.AmountDue_19+V.AmountDue_20+V.AmountDue_21+V.AmountDue_22+V.AmountDue_23)) End
+
Case WHen V.Installment=24 and (V.Payment_CC+V.Payment_OC)>(V.Nominal_CC-V.Diff_CC) Then (V.Nominal_CC-V.Diff_CC)-(V.Payment_CC+V.Payment_OC) else 0 end
)*(V.Nominal_CC-V.Diff_CC-V.Tax_CC)/(V.Nominal_CC-V.Diff_CC) as Outstanding_24,

(Case When V.Installment<>0 then ' Installment No. ' else '' end+ 
Case When V.Installment>=1 and V.DueDate_1 <=@P_Date and (V.Payment_CC+V.Payment_OC)<(V.AmountDue_1) Then '1 ' else '' end+ 
Case When V.Installment>=2 and V.DueDate_2 <=@P_Date and (V.Payment_CC+V.Payment_OC)<(V.AmountDue_1+V.AmountDue_2) Then '2 ' else '' end+ 
Case When V.Installment>=3 and V.DueDate_3 <=@P_Date and (V.Payment_CC+V.Payment_OC)<(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3) Then '3 ' else '' end+ 
Case When V.Installment>=4 and V.DueDate_4 <=@P_Date and (V.Payment_CC+V.Payment_OC)<(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4) Then '4 ' else '' end+ 
Case When V.Installment>=5 and V.DueDate_5 <=@P_Date and (V.Payment_CC+V.Payment_OC)<(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5) Then '5 ' else '' end+ 
Case When V.Installment>=6 and V.DueDate_6 <=@P_Date and (V.Payment_CC+V.Payment_OC)<(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6) Then '6 ' else '' end+ 
Case When V.Installment>=7 and V.DueDate_7 <=@P_Date and (V.Payment_CC+V.Payment_OC)<(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7) Then '7 ' else '' end+ 
Case When V.Installment>=8 and V.DueDate_8 <=@P_Date and (V.Payment_CC+V.Payment_OC)<(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8) Then '8 ' else '' end+ 
Case When V.Installment>=9 and V.DueDate_9 <=@P_Date and (V.Payment_CC+V.Payment_OC)<(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9) Then '9 ' else '' end+ 
Case When V.Installment>=10 and V.DueDate_10 <=@P_Date and (V.Payment_CC+V.Payment_OC)<(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10)  Then '10 ' else '' end+ 
Case When V.Installment>=11 and V.DueDate_11 <=@P_Date and (V.Payment_CC+V.Payment_OC)<(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11) Then '11 ' else '' end+ 
Case When V.Installment>=12 and V.DueDate_12 <=@P_Date and (V.Payment_CC+V.Payment_OC)<(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12) Then '12 ' else '' end+ 
Case When V.Installment>=13 and V.DueDate_13 <=@P_Date and (V.Payment_CC+V.Payment_OC)<(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13) Then '13 ' else '' end+ 
Case When V.Installment>=14 and V.DueDate_14 <=@P_Date and (V.Payment_CC+V.Payment_OC)<(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14) Then '14 ' else '' end+ 
Case When V.Installment>=15 and V.DueDate_15 <=@P_Date and (V.Payment_CC+V.Payment_OC)<(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15) Then '15 ' else '' end+ 
Case When V.Installment>=16 and V.DueDate_16 <=@P_Date and (V.Payment_CC+V.Payment_OC)<(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16) Then '16 ' else '' end+ 
Case When V.Installment>=17 and V.DueDate_17 <=@P_Date and (V.Payment_CC+V.Payment_OC)<(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16+V.AmountDue_17) Then '17 ' else '' end+ 
Case When V.Installment>=18 and V.DueDate_18 <=@P_Date and (V.Payment_CC+V.Payment_OC)<(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16+V.AmountDue_17+V.AmountDue_18) Then '18 ' else '' end+ 
Case When V.Installment>=19 and V.DueDate_19 <=@P_Date and (V.Payment_CC+V.Payment_OC)<(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16+V.AmountDue_17+V.AmountDue_18+V.AmountDue_19) Then '19 ' else '' end+ 
Case When V.Installment>=20 and V.DueDate_20 <=@P_Date and (V.Payment_CC+V.Payment_OC)<(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16+V.AmountDue_17+V.AmountDue_18+V.AmountDue_19+V.AmountDue_20) Then '20 ' else '' end+ 
Case When V.Installment>=21 and V.DueDate_21 <=@P_Date and (V.Payment_CC+V.Payment_OC)<(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16+V.AmountDue_17+V.AmountDue_18+V.AmountDue_19+V.AmountDue_20+V.AmountDue_21) Then '21 ' else '' end+ 
Case When V.Installment>=22 and V.DueDate_22 <=@P_Date and (V.Payment_CC+V.Payment_OC)<(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16+V.AmountDue_17+V.AmountDue_18+V.AmountDue_19+V.AmountDue_20+V.AmountDue_21+V.AmountDue_22) Then '22 ' else '' end+ 
Case When V.Installment>=23 and V.DueDate_23 <=@P_Date and (V.Payment_CC+V.Payment_OC)<(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16+V.AmountDue_17+V.AmountDue_18+V.AmountDue_19+V.AmountDue_20+V.AmountDue_21+V.AmountDue_22+V.AmountDue_23) Then '23 ' else '' end+ 
Case When V.Installment>=24 and V.DueDate_24 <=@P_Date and (V.Payment_CC+V.Payment_OC)<(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16+V.AmountDue_17+V.AmountDue_18+V.AmountDue_19+V.AmountDue_20+V.AmountDue_21+V.AmountDue_22+V.AmountDue_23+V.AmountDue_24) Then '24 ' else '' end+ 
Case When V.Installment<>0 then 'of '+cast(V.Installment as varchar(255)) else '' end) as sInstallment,

(
Case When V.Installment>=1 and V.DueDate_1 <=@P_Date and (V.Payment_CC+V.Payment_OC)<(V.AmountDue_1) 
	Then ' Installment 1 : ' + 
	convert(varchar(50), cast((
	Case 
	When V.AmountDue_1<(V.Payment_CC+V.Payment_OC) Then 0
	else V.AmountDue_1-(V.Payment_CC+V.Payment_OC) end 
	+
	Case WHen V.Installment=1 and (V.Payment_CC+V.Payment_OC)>(V.Nominal_CC-V.Diff_CC) Then (V.Nominal_CC-V.Diff_CC)-(V.Payment_CC+V.Payment_OC) else 0 end
	)*(V.Nominal_CC-V.Diff_CC-V.Tax_CC)/(V.Nominal_CC-V.Diff_CC) as Money),1)+char(13)+char(10)
	else '' end+ 

Case When V.Installment>=2 and V.DueDate_2 <=@P_Date and (V.Payment_CC+V.Payment_OC)<(V.AmountDue_1+V.AmountDue_2) 
	Then ' Installment 2 : ' + 
	convert(varchar(50), cast((
	Case 
	When V.AmountDue_2<((V.Payment_CC+V.Payment_OC)-V.AmountDue_1) Then 0
	When ((V.Payment_CC+V.Payment_OC)-V.AmountDue_1)<0 then V.AmountDue_2
	else V.AmountDue_2-((V.Payment_CC+V.Payment_OC)-V.AmountDue_1) end 
	+
	Case WHen V.Installment=2 and (V.Payment_CC+V.Payment_OC)>(V.Nominal_CC-V.Diff_CC) Then (V.Nominal_CC-V.Diff_CC)-(V.Payment_CC+V.Payment_OC) else 0 end
	)*(V.Nominal_CC-V.Diff_CC-V.Tax_CC)/(V.Nominal_CC-V.Diff_CC) as Money),1)+char(13)+char(10)
	else '' end+ 

Case When V.Installment>=3 and V.DueDate_3 <=@P_Date and (V.Payment_CC+V.Payment_OC)<(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3) 
	Then ' Installment 3 : ' + 
	convert(varchar(50), cast((
	Case 
	When V.AmountDue_3<((V.Payment_CC+V.Payment_OC)-(V.AmountDue_1+V.AmountDue_2)) Then 0
	When ((V.Payment_CC+V.Payment_OC)-(V.AmountDue_1+V.AmountDue_2))<0 then V.AmountDue_3
	else V.AmountDue_3-((V.Payment_CC+V.Payment_OC)-(V.AmountDue_1+V.AmountDue_2)) end 
	+
	Case WHen V.Installment=3 and (V.Payment_CC+V.Payment_OC)>(V.Nominal_CC-V.Diff_CC) Then (V.Nominal_CC-V.Diff_CC)-(V.Payment_CC+V.Payment_OC) else 0 end
	)*(V.Nominal_CC-V.Diff_CC-V.Tax_CC)/(V.Nominal_CC-V.Diff_CC) as Money),1)+char(13)+char(10)
	else '' end+ 

Case When V.Installment>=4 and V.DueDate_4 <=@P_Date and (V.Payment_CC+V.Payment_OC)<(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4) 
	Then ' Installment 4 : ' + 
	convert(varchar(50), cast((
	Case 
	When V.AmountDue_4<((V.Payment_CC+V.Payment_OC)-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3)) Then 0
	When ((V.Payment_CC+V.Payment_OC)-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3))<0 then V.AmountDue_4
	else V.AmountDue_4-((V.Payment_CC+V.Payment_OC)-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3)) end 
	+
	Case WHen V.Installment=4 and (V.Payment_CC+V.Payment_OC)>(V.Nominal_CC-V.Diff_CC) Then (V.Nominal_CC-V.Diff_CC)-(V.Payment_CC+V.Payment_OC) else 0 end
	)*(V.Nominal_CC-V.Diff_CC-V.Tax_CC)/(V.Nominal_CC-V.Diff_CC) as Money),1)+char(13)+char(10)
	else '' end+ 

Case When V.Installment>=5 and V.DueDate_5 <=@P_Date and (V.Payment_CC+V.Payment_OC)<(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5) 
	Then ' Installment 5 : ' + 
	convert(varchar(50), cast((
	Case 
	When V.AmountDue_5<((V.Payment_CC+V.Payment_OC)-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4)) Then 0
	When ((V.Payment_CC+V.Payment_OC)-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4))<0 then V.AmountDue_5
	else V.AmountDue_5-((V.Payment_CC+V.Payment_OC)-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4)) end 
	+
	Case WHen V.Installment=5 and (V.Payment_CC+V.Payment_OC)>(V.Nominal_CC-V.Diff_CC) Then (V.Nominal_CC-V.Diff_CC)-(V.Payment_CC+V.Payment_OC) else 0 end
	)*(V.Nominal_CC-V.Diff_CC-V.Tax_CC)/(V.Nominal_CC-V.Diff_CC) as Money),1)+char(13)+char(10)
	else '' end+ 

Case When V.Installment>=6 and V.DueDate_6 <=@P_Date and (V.Payment_CC+V.Payment_OC)<(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6) 
	Then ' Installment 6 : ' + 
	convert(varchar(50), cast((
	Case 
	When V.AmountDue_6<((V.Payment_CC+V.Payment_OC)-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5)) Then 0
	When ((V.Payment_CC+V.Payment_OC)-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5))<0 then V.AmountDue_6
	else V.AmountDue_6-((V.Payment_CC+V.Payment_OC)-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5)) end 
	+
	Case WHen V.Installment=6 and (V.Payment_CC+V.Payment_OC)>(V.Nominal_CC-V.Diff_CC) Then (V.Nominal_CC-V.Diff_CC)-(V.Payment_CC+V.Payment_OC) else 0 end
	)*(V.Nominal_CC-V.Diff_CC-V.Tax_CC)/(V.Nominal_CC-V.Diff_CC) as Money),1)+char(13)+char(10)
	else '' end+ 

Case When V.Installment>=7 and V.DueDate_7 <=@P_Date and (V.Payment_CC+V.Payment_OC)<(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7) 
	Then ' Installment 7 : ' + 
	convert(varchar(50), cast((
	Case 
	When V.AmountDue_7<((V.Payment_CC+V.Payment_OC)-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6)) Then 0
	When ((V.Payment_CC+V.Payment_OC)-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6))<0 then V.AmountDue_7
	else V.AmountDue_7-((V.Payment_CC+V.Payment_OC)-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6)) end 
	+
	Case WHen V.Installment=7 and (V.Payment_CC+V.Payment_OC)>(V.Nominal_CC-V.Diff_CC) Then (V.Nominal_CC-V.Diff_CC)-(V.Payment_CC+V.Payment_OC) else 0 end
	)*(V.Nominal_CC-V.Diff_CC-V.Tax_CC)/(V.Nominal_CC-V.Diff_CC) as Money),1)+char(13)+char(10)
	else '' end+ 

Case When V.Installment>=8 and V.DueDate_8 <=@P_Date and (V.Payment_CC+V.Payment_OC)<(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8) 
	Then ' Installment 8 : ' + 
	convert(varchar(50), cast((
	Case 
	When V.AmountDue_8<((V.Payment_CC+V.Payment_OC)-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7)) Then 0
	When ((V.Payment_CC+V.Payment_OC)-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7))<0 then V.AmountDue_8
	else V.AmountDue_8-((V.Payment_CC+V.Payment_OC)-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7)) end 
	+
	Case WHen V.Installment=8 and (V.Payment_CC+V.Payment_OC)>(V.Nominal_CC-V.Diff_CC) Then (V.Nominal_CC-V.Diff_CC)-(V.Payment_CC+V.Payment_OC) else 0 end
	)*(V.Nominal_CC-V.Diff_CC-V.Tax_CC)/(V.Nominal_CC-V.Diff_CC) as Money),1)+char(13)+char(10)
	else '' end+ 

Case When V.Installment>=9 and V.DueDate_9 <=@P_Date and (V.Payment_CC+V.Payment_OC)<(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9) 
	Then ' Installment 2 : ' + 
	convert(varchar(50), cast((
	Case 
	When V.AmountDue_9<((V.Payment_CC+V.Payment_OC)-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8)) Then 0
	When ((V.Payment_CC+V.Payment_OC)-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8))<0 then V.AmountDue_9
	else V.AmountDue_9-((V.Payment_CC+V.Payment_OC)-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8)) end 
	+
	Case WHen V.Installment=9 and (V.Payment_CC+V.Payment_OC)>(V.Nominal_CC-V.Diff_CC) Then (V.Nominal_CC-V.Diff_CC)-(V.Payment_CC+V.Payment_OC) else 0 end
	)*(V.Nominal_CC-V.Diff_CC-V.Tax_CC)/(V.Nominal_CC-V.Diff_CC) as Money),1)+char(13)+char(10)
	else '' end+ 

Case When V.Installment>=10 and V.DueDate_10 <=@P_Date and (V.Payment_CC+V.Payment_OC)<(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10)  
	Then ' Installment 10 : ' + 
	convert(varchar(50), cast((
	Case 
	When V.AmountDue_10<((V.Payment_CC+V.Payment_OC)-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9)) Then 0
	When ((V.Payment_CC+V.Payment_OC)-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9))<0 then V.AmountDue_10
	else V.AmountDue_10-((V.Payment_CC+V.Payment_OC)-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9)) end 
	+
	Case WHen V.Installment=10 and (V.Payment_CC+V.Payment_OC)>(V.Nominal_CC-V.Diff_CC) Then (V.Nominal_CC-V.Diff_CC)-(V.Payment_CC+V.Payment_OC) else 0 end
	)*(V.Nominal_CC-V.Diff_CC-V.Tax_CC)/(V.Nominal_CC-V.Diff_CC) as Money),1)+char(13)+char(10)
	else '' end+ 

Case When V.Installment>=11 and V.DueDate_11 <=@P_Date and (V.Payment_CC+V.Payment_OC)<(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11) 
	Then ' Installment 11 : ' + 
	convert(varchar(50), cast((
	Case 
	When V.AmountDue_11<((V.Payment_CC+V.Payment_OC)-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10)) Then 0
	When ((V.Payment_CC+V.Payment_OC)-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10))<0 then V.AmountDue_11
	else V.AmountDue_11-((V.Payment_CC+V.Payment_OC)-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10)) end 
	+
	Case WHen V.Installment=11 and (V.Payment_CC+V.Payment_OC)>(V.Nominal_CC-V.Diff_CC) Then (V.Nominal_CC-V.Diff_CC)-(V.Payment_CC+V.Payment_OC) else 0 end
	)*(V.Nominal_CC-V.Diff_CC-V.Tax_CC)/(V.Nominal_CC-V.Diff_CC) as Money),1)+char(13)+char(10)
	else '' end+ 

Case When V.Installment>=12 and V.DueDate_12 <=@P_Date and (V.Payment_CC+V.Payment_OC)<(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12) 
	Then ' Installment 12 : ' + 
	convert(varchar(50), cast((
	Case 
	When V.AmountDue_12<((V.Payment_CC+V.Payment_OC)-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11)) Then 0
	When ((V.Payment_CC+V.Payment_OC)-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11))<0 then V.AmountDue_12
	else V.AmountDue_12-((V.Payment_CC+V.Payment_OC)-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11)) end 
	+
	Case WHen V.Installment=12 and (V.Payment_CC+V.Payment_OC)>(V.Nominal_CC-V.Diff_CC) Then (V.Nominal_CC-V.Diff_CC)-(V.Payment_CC+V.Payment_OC) else 0 end
	)*(V.Nominal_CC-V.Diff_CC-V.Tax_CC)/(V.Nominal_CC-V.Diff_CC) as Money),1)+char(13)+char(10)
	else '' end+ 

Case When V.Installment>=13 and V.DueDate_13 <=@P_Date and (V.Payment_CC+V.Payment_OC)<(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13) 
	Then ' Installment 13 : ' + 
	convert(varchar(50), cast((
	Case 
	When V.AmountDue_14<((V.Payment_CC+V.Payment_OC)-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13)) Then 0
	When ((V.Payment_CC+V.Payment_OC)-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13))<0 then V.AmountDue_14
	else V.AmountDue_14-((V.Payment_CC+V.Payment_OC)-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13)) end 
	+
	Case WHen V.Installment=13 and (V.Payment_CC+V.Payment_OC)>(V.Nominal_CC-V.Diff_CC) Then (V.Nominal_CC-V.Diff_CC)-(V.Payment_CC+V.Payment_OC) else 0 end
	)*(V.Nominal_CC-V.Diff_CC-V.Tax_CC)/(V.Nominal_CC-V.Diff_CC) as Money),1)+char(13)+char(10)
	else '' end+ 

Case When V.Installment>=14 and V.DueDate_14 <=@P_Date and (V.Payment_CC+V.Payment_OC)<(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14 )
	Then ' Installment 14 : ' + 
	convert(varchar(50), cast((
	Case 
	When V.AmountDue_2<((V.Payment_CC+V.Payment_OC)-V.AmountDue_1) Then 0
	When ((V.Payment_CC+V.Payment_OC)-V.AmountDue_1)<0 then V.AmountDue_2
	else V.AmountDue_2-((V.Payment_CC+V.Payment_OC)-V.AmountDue_1) end 
	+
	Case WHen V.Installment=2 and (V.Payment_CC+V.Payment_OC)>(V.Nominal_CC-V.Diff_CC) Then (V.Nominal_CC-V.Diff_CC)-(V.Payment_CC+V.Payment_OC) else 0 end
	)*(V.Nominal_CC-V.Diff_CC-V.Tax_CC)/(V.Nominal_CC-V.Diff_CC) as Money),1)+char(13)+char(10)
	else '' end+ 

Case When V.Installment>=15 and V.DueDate_15 <=@P_Date and (V.Payment_CC+V.Payment_OC)<(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15) 
	Then ' Installment 15 : ' + 
	convert(varchar(50), cast((
	Case 
	When V.AmountDue_15<((V.Payment_CC+V.Payment_OC)-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14)) Then 0
	When ((V.Payment_CC+V.Payment_OC)-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14))<0 then V.AmountDue_15
	else V.AmountDue_15-((V.Payment_CC+V.Payment_OC)-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14)) end 
	+
	Case WHen V.Installment=15 and (V.Payment_CC+V.Payment_OC)>(V.Nominal_CC-V.Diff_CC) Then (V.Nominal_CC-V.Diff_CC)-(V.Payment_CC+V.Payment_OC) else 0 end
	)*(V.Nominal_CC-V.Diff_CC-V.Tax_CC)/(V.Nominal_CC-V.Diff_CC) as Money),1)+char(13)+char(10)
	else '' end+ 

Case When V.Installment>=16 and V.DueDate_16 <=@P_Date and (V.Payment_CC+V.Payment_OC)<(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16) 
	Then ' Installment 16 : ' + 
	convert(varchar(50), cast((
	Case 
	When V.AmountDue_16<((V.Payment_CC+V.Payment_OC)-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15)) Then 0
	When ((V.Payment_CC+V.Payment_OC)-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15))<0 then V.AmountDue_16
	else V.AmountDue_16-((V.Payment_CC+V.Payment_OC)-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15)) end 
	+
	Case WHen V.Installment=16 and (V.Payment_CC+V.Payment_OC)>(V.Nominal_CC-V.Diff_CC) Then (V.Nominal_CC-V.Diff_CC)-(V.Payment_CC+V.Payment_OC) else 0 end
	)*(V.Nominal_CC-V.Diff_CC-V.Tax_CC)/(V.Nominal_CC-V.Diff_CC) as Money),1)+char(13)+char(10)
	else '' end+ 

Case When V.Installment>=17 and V.DueDate_17 <=@P_Date and (V.Payment_CC+V.Payment_OC)<(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16+V.AmountDue_17) 
	Then ' Installment 17 : ' + 
	convert(varchar(50), cast((
	Case 
	When V.AmountDue_17<((V.Payment_CC+V.Payment_OC)-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16)) Then 0
	When ((V.Payment_CC+V.Payment_OC)-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16))<0 then V.AmountDue_17
	else V.AmountDue_17-((V.Payment_CC+V.Payment_OC)-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16)) end 
	+
	Case WHen V.Installment=17 and (V.Payment_CC+V.Payment_OC)>(V.Nominal_CC-V.Diff_CC) Then (V.Nominal_CC-V.Diff_CC)-(V.Payment_CC+V.Payment_OC) else 0 end
	)*(V.Nominal_CC-V.Diff_CC-V.Tax_CC)/(V.Nominal_CC-V.Diff_CC) as Money),1)+char(13)+char(10)
	else '' end+ 

Case When V.Installment>=18 and V.DueDate_18 <=@P_Date and (V.Payment_CC+V.Payment_OC)<(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16+V.AmountDue_17+V.AmountDue_18) 
	Then ' Installment 18 : ' + 
	convert(varchar(50), cast((
	Case 
	When V.AmountDue_18<((V.Payment_CC+V.Payment_OC)-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16+V.AmountDue_17)) Then 0
	When ((V.Payment_CC+V.Payment_OC)-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16+V.AmountDue_17))<0 then V.AmountDue_18
	else V.AmountDue_18-((V.Payment_CC+V.Payment_OC)-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16+V.AmountDue_17)) end 
	+
	Case WHen V.Installment=18 and (V.Payment_CC+V.Payment_OC)>(V.Nominal_CC-V.Diff_CC) Then (V.Nominal_CC-V.Diff_CC)-(V.Payment_CC+V.Payment_OC) else 0 end
	)*(V.Nominal_CC-V.Diff_CC-V.Tax_CC)/(V.Nominal_CC-V.Diff_CC) as Money),1)+char(13)+char(10)
	else '' end+ 

Case When V.Installment>=19 and V.DueDate_19 <=@P_Date and (V.Payment_CC+V.Payment_OC)<(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16+V.AmountDue_17+V.AmountDue_18+V.AmountDue_19) 
	Then ' Installment 19 : ' + 
	convert(varchar(50), cast((
	Case 
	When V.AmountDue_19<((V.Payment_CC+V.Payment_OC)-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16+V.AmountDue_17+V.AmountDue_18)) Then 0
	When ((V.Payment_CC+V.Payment_OC)-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16+V.AmountDue_17+V.AmountDue_18))<0 then V.AmountDue_19
	else V.AmountDue_19-((V.Payment_CC+V.Payment_OC)-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16+V.AmountDue_17+V.AmountDue_18)) end 
	+
	Case WHen V.Installment=19 and (V.Payment_CC+V.Payment_OC)>(V.Nominal_CC-V.Diff_CC) Then (V.Nominal_CC-V.Diff_CC)-(V.Payment_CC+V.Payment_OC) else 0 end
	)*(V.Nominal_CC-V.Diff_CC-V.Tax_CC)/(V.Nominal_CC-V.Diff_CC) as Money),1)+char(13)+char(10)
	else '' end+ 

Case When V.Installment>=20 and V.DueDate_20 <=@P_Date and (V.Payment_CC+V.Payment_OC)<(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16+V.AmountDue_17+V.AmountDue_18+V.AmountDue_19+V.AmountDue_20) 
	Then ' Installment 20 : ' + 
	convert(varchar(50), cast((
	Case 
	When V.AmountDue_20<((V.Payment_CC+V.Payment_OC)-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16+V.AmountDue_17+V.AmountDue_18+V.AmountDue_19)) Then 0
	When ((V.Payment_CC+V.Payment_OC)-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16+V.AmountDue_17+V.AmountDue_18+V.AmountDue_19))<0 then V.AmountDue_20
	else V.AmountDue_20-((V.Payment_CC+V.Payment_OC)-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16+V.AmountDue_17+V.AmountDue_18+V.AmountDue_19)) end 
	+
	Case WHen V.Installment=20 and (V.Payment_CC+V.Payment_OC)>(V.Nominal_CC-V.Diff_CC) Then (V.Nominal_CC-V.Diff_CC)-(V.Payment_CC+V.Payment_OC) else 0 end
	)*(V.Nominal_CC-V.Diff_CC-V.Tax_CC)/(V.Nominal_CC-V.Diff_CC) as Money),1)+char(13)+char(10)
	else '' end+ 

Case When V.Installment>=21 and V.DueDate_21 <=@P_Date and (V.Payment_CC+V.Payment_OC)<(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16+V.AmountDue_17+V.AmountDue_18+V.AmountDue_19+V.AmountDue_20+V.AmountDue_21) 
	Then ' Installment 21 : ' + 
	convert(varchar(50), cast((
	Case 
	When V.AmountDue_21<((V.Payment_CC+V.Payment_OC)-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16+V.AmountDue_17+V.AmountDue_18+V.AmountDue_19+V.AmountDue_20)) Then 0
	When ((V.Payment_CC+V.Payment_OC)-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16+V.AmountDue_17+V.AmountDue_18+V.AmountDue_19+V.AmountDue_20))<0 then V.AmountDue_21
	else V.AmountDue_21-((V.Payment_CC+V.Payment_OC)-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16+V.AmountDue_17+V.AmountDue_18+V.AmountDue_19+V.AmountDue_20)) end 
	+
	Case WHen V.Installment=21 and (V.Payment_CC+V.Payment_OC)>(V.Nominal_CC-V.Diff_CC) Then (V.Nominal_CC-V.Diff_CC)-(V.Payment_CC+V.Payment_OC) else 0 end
	)*(V.Nominal_CC-V.Diff_CC-V.Tax_CC)/(V.Nominal_CC-V.Diff_CC) as Money),1)+char(13)+char(10)
	else '' end+ 

Case When V.Installment>=22 and V.DueDate_22 <=@P_Date and (V.Payment_CC+V.Payment_OC)<(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16+V.AmountDue_17+V.AmountDue_18+V.AmountDue_19+V.AmountDue_20+V.AmountDue_21+V.AmountDue_22) 
	Then ' Installment 22 : ' + 
	convert(varchar(50), cast((
	Case 
	When V.AmountDue_22<((V.Payment_CC+V.Payment_OC)-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16+V.AmountDue_17+V.AmountDue_18+V.AmountDue_19+V.AmountDue_20+V.AmountDue_21)) Then 0
	When ((V.Payment_CC+V.Payment_OC)-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16+V.AmountDue_17+V.AmountDue_18+V.AmountDue_19+V.AmountDue_20+V.AmountDue_21))<0 then V.AmountDue_22
	else V.AmountDue_22-((V.Payment_CC+V.Payment_OC)-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16+V.AmountDue_17+V.AmountDue_18+V.AmountDue_19+V.AmountDue_20+V.AmountDue_21)) end 
	+
	Case WHen V.Installment=22 and (V.Payment_CC+V.Payment_OC)>(V.Nominal_CC-V.Diff_CC) Then (V.Nominal_CC-V.Diff_CC)-(V.Payment_CC+V.Payment_OC) else 0 end
	)*(V.Nominal_CC-V.Diff_CC-V.Tax_CC)/(V.Nominal_CC-V.Diff_CC) as Money),1)+char(13)+char(10)
	else '' end+ 

Case When V.Installment>=23 and V.DueDate_23 <=@P_Date and (V.Payment_CC+V.Payment_OC)<(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16+V.AmountDue_17+V.AmountDue_18+V.AmountDue_19+V.AmountDue_20+V.AmountDue_21+V.AmountDue_22+V.AmountDue_23) 
	Then ' Installment 23 : ' + 
	convert(varchar(50), cast((
	Case 
	When V.AmountDue_23<((V.Payment_CC+V.Payment_OC)-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16+V.AmountDue_17+V.AmountDue_18+V.AmountDue_19+V.AmountDue_20+V.AmountDue_21+V.AmountDue_22)) Then 0
	When ((V.Payment_CC+V.Payment_OC)-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16+V.AmountDue_17+V.AmountDue_18+V.AmountDue_19+V.AmountDue_20+V.AmountDue_21+V.AmountDue_22))<0 then V.AmountDue_23
	else V.AmountDue_23-((V.Payment_CC+V.Payment_OC)-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16+V.AmountDue_17+V.AmountDue_18+V.AmountDue_19+V.AmountDue_20+V.AmountDue_21+V.AmountDue_22)) end 
	+
	Case WHen V.Installment=23 and (V.Payment_CC+V.Payment_OC)>(V.Nominal_CC-V.Diff_CC) Then (V.Nominal_CC-V.Diff_CC)-(V.Payment_CC+V.Payment_OC) else 0 end
	)*(V.Nominal_CC-V.Diff_CC-V.Tax_CC)/(V.Nominal_CC-V.Diff_CC) as Money),1)+char(13)+char(10)
	else '' end+ 

Case When V.Installment>=24 and V.DueDate_24 <=@P_Date and (V.Payment_CC+V.Payment_OC)<(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16+V.AmountDue_17+V.AmountDue_18+V.AmountDue_19+V.AmountDue_20+V.AmountDue_21+V.AmountDue_22+V.AmountDue_23+V.AmountDue_24) 
	Then ' Installment 24 : ' + 
	convert(varchar(50), cast((
	Case 
	When V.AmountDue_24<((V.Payment_CC+V.Payment_OC)-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16+V.AmountDue_17+V.AmountDue_18+V.AmountDue_19+V.AmountDue_20+V.AmountDue_21+V.AmountDue_22+V.AmountDue_23)) Then 0
	When ((V.Payment_CC+V.Payment_OC)-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16+V.AmountDue_17+V.AmountDue_18+V.AmountDue_19+V.AmountDue_20+V.AmountDue_21+V.AmountDue_22+V.AmountDue_23))<0 then V.AmountDue_24
	else V.AmountDue_24-((V.Payment_CC+V.Payment_OC)-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16+V.AmountDue_17+V.AmountDue_18+V.AmountDue_19+V.AmountDue_20+V.AmountDue_21+V.AmountDue_22+V.AmountDue_23)) End
	+
	Case WHen V.Installment=24 and (V.Payment_CC+V.Payment_OC)>(V.Nominal_CC-V.Diff_CC) Then (V.Nominal_CC-V.Diff_CC)-(V.Payment_CC+V.Payment_OC) else 0 end
	)*(V.Nominal_CC-V.Diff_CC-V.Tax_CC)/(V.Nominal_CC-V.Diff_CC) as Money),1)+char(13)+char(10)
	else '' end 

) as sInstallment_Ext
from nVoucher V 
Where (Round(V.Nominal_CC-V.Diff_CC-(V.Payment_CC+V.Payment_OC),4)<>0 or V.PDate>@P_Date) 
) 

GO

DROP function VOUCHER_AMOUNTNEXTDUE
GO
CREATE function VOUCHER_AMOUNTNEXTDUE(@P_Date as smalldatetime) 
RETURNS Table 
AS RETURN 
( 
Select V.Voucher, V.CollNo, V.Branch, V.ProAcc, V.RefNo, V.DocNo, V.Currency, V.Installment, (V.Payment_CC+V.Payment_OC) as Payment_CC, cast(0 as Float) as Payment_OC,  V.DebtorF, V.CreditorF, V.StatID, V.ActionBy, V.ActionDate,  V.AcceptedBy, V.AcceptedDate, 
(Case 
When V.Installment=0 Then V.Nominal_CC-V.Diff_CC 
When V.Installment>=1 and @P_Date<=V.DueDate_1 Then V.AmountDue_1 
When V.Installment>=2 and @P_Date<=V.DueDate_2 Then V.AmountDue_1+V.AmountDue_2 
When V.Installment>=3 and @P_Date<=V.DueDate_3 Then V.AmountDue_1+V.AmountDue_2+V.AmountDue_3 
When V.Installment>=4 and @P_Date<=V.DueDate_4 Then V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4 
When V.Installment>=5 and @P_Date<=V.DueDate_5 Then V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5 
When V.Installment>=6 and @P_Date<=V.DueDate_6 Then V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6 
When V.Installment>=7 and @P_Date<=V.DueDate_7 Then V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7 
When V.Installment>=8 and @P_Date<=V.DueDate_8 Then V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8 
When V.Installment>=9 and @P_Date<=V.DueDate_9 Then V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9 
When V.Installment>=10 and @P_Date<=V.DueDate_10 Then V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10 
When V.Installment>=11 and @P_Date<=V.DueDate_11 Then V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11 
When V.Installment>=12 and @P_Date<=V.DueDate_12 Then V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12 
When V.Installment>=13 and @P_Date<=V.DueDate_13 Then V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13 
When V.Installment>=14 and @P_Date<=V.DueDate_14 Then V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14 
When V.Installment>=15 and @P_Date<=V.DueDate_15 Then V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15 
When V.Installment>=16 and @P_Date<=V.DueDate_16 Then V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16 
When V.Installment>=17 and @P_Date<=V.DueDate_17 Then V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16+V.AmountDue_17 
When V.Installment>=18 and @P_Date<=V.DueDate_18 Then V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16+V.AmountDue_17+V.AmountDue_18 
When V.Installment>=19 and @P_Date<=V.DueDate_19 Then V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16+V.AmountDue_17+V.AmountDue_18+V.AmountDue_19 
When V.Installment>=20 and @P_Date<=V.DueDate_20 Then V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16+V.AmountDue_17+V.AmountDue_18+V.AmountDue_19+V.AmountDue_20 
When V.Installment>=21 and @P_Date<=V.DueDate_21 Then V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16+V.AmountDue_17+V.AmountDue_18+V.AmountDue_19+V.AmountDue_20+V.AmountDue_21 
When V.Installment>=22 and @P_Date<=V.DueDate_22 Then V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16+V.AmountDue_17+V.AmountDue_18+V.AmountDue_19+V.AmountDue_20+V.AmountDue_21+V.AmountDue_22 
When V.Installment>=23 and @P_Date<=V.DueDate_23 Then V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16+V.AmountDue_17+V.AmountDue_18+V.AmountDue_19+V.AmountDue_20+V.AmountDue_21+V.AmountDue_22+V.AmountDue_23 
When V.Installment>=24 and @P_Date<=V.DueDate_24 Then V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16+V.AmountDue_17+V.AmountDue_18+V.AmountDue_19+V.AmountDue_20+V.AmountDue_21+V.AmountDue_22+V.AmountDue_23+V.AmountDue_24 
else V.Nominal_CC-V.Diff_CC end) as AmountDue
from nVoucher V 
Where ((V.Nominal_CC-V.Diff_CC-(V.Payment_CC+V.Payment_OC))<>0 or V.PDate>@P_Date) 
) 


go


 insert into PatchVersioning	
select '704 Update Script - Patch 2023 (72)',GETDATE()
go





Declare @PrevScript varchar(100)
Declare @CurrScript varchar(1004)

Select @PrevScript=''
Select @CurrSCript='704 Update Script - Patch 2023 (72)'


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



