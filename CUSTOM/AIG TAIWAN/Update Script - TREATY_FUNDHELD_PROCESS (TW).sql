DROP FUNCTION TREATY_FUNDHELD_PROCESS
GO
CREATE FUNCTION TREATY_FUNDHELD_PROCESS(@P_Type varchar(2),@P_Date smalldatetime, @P_PEDate smalldatetime,@P_EDate smalldatetime, @IRate as Float)            
RETURNS TABLE            
AS RETURN(            
--- replacing A.A_SDate --> (A.Date)
--- replacing A.A_EDate --> (dateadd(year,1,A.Date))

Select A.AdmNo, A.DocNo, A.RefNo, A.Branch, A.CT, A.Remarks, A.ID, A.A_ID, A.Source, A.ISType, A.Segment, 
A.Type, A.Code, A.Currency, A.A_PolicyNo, A.A_MO, A.RefType, A.AccountNo, A.BankAccount, A.BankName,
A.Bank, A.BankBranch, (A.Date) as A_SDate, (dateadd(year,1,A.Date)) as A_EDate, A.Statement, A.ASource, A.MSCode, A.BizMapID , A.TaxType,

case 
--Fund Held
when ((A.Date)>@P_PEDate and (A.Date)<=@P_EDate) then -A.Amount_1* Reinsurance.FundHeldPCT/100
--Fund Release
when ((dateadd(year,1,A.Date))>@P_PEDate and (dateadd(year,1,A.Date))<=@P_EDate) then A.Amount_1* Reinsurance.FundHeldPCT/100
else 0
end as Amount_4,

--Withholding Tax
-dbo.roundccy(
case 
--Fund Held
when ((A.Date)>@P_PEDate and (A.Date)<=@P_EDate) then -A.Amount_1* Reinsurance.FundHeldPCT/100
--Fund Release
when ((dateadd(year,1,A.Date))>@P_PEDate and (dateadd(year,1,A.Date))<=@P_EDate) then A.Amount_1* Reinsurance.FundHeldPCT/100
else 0
end*taxType.TaxRate/100, A.Currency) as Amount_14,

cast(0 as Float) as Amount_15,

case 
--Fund Held
when ((A.Date)>@P_PEDate and (A.Date)<=@P_EDate) then -A.Amount_1* Reinsurance.FundHeldPCT/100
--Fund Release
when ((dateadd(year,1,A.Date))>@P_PEDate and (dateadd(year,1,A.Date))<=@P_EDate) then A.Amount_1* Reinsurance.FundHeldPCT/100
else 0
end as PNominal_Tax,

cast(0 as Float) as IRate

from Admlink A
Inner Join Profile on (Profile.ID=A.ID)
Inner Join SysTab on (1=1)
Inner Join TaxType on (TaxType.TaxType=Profile.TaxType)
inner join RPart on (RPart.DocNo=A.RefNo and RPart.ID=A.ID)
Inner Join Reinsurance on (Reinsurance.RNO=RPart.RNO and Reinsurance.FundHeldF=1 and Reinsurance.FundHeldPCT<>0)
Where A.Type in ('AF','QS','QP','S1','S2','S3') and A.Subject='Premium' and A.EXTRA_1<>'Fund Held' and A.AMOUNT_1<>0
and A.Date<=@P_EDate
and 
(
((A.Date)>@P_PEDate and (A.Date)<=@P_EDate) or
((dateadd(year,1,A.Date))>@P_PEDate and (dateadd(year,1,A.Date))<=@P_EDate)
)

Union All


Select A.AdmNo, A.DocNo, A.RefNo, A.Branch, A.CT, A.Remarks, A.ID, A.A_ID, A.Source, A.ISType, A.Segment, 
A.Type, A.Code, A.Currency, A.A_PolicyNo, A.A_MO, A.RefType, A.AccountNo, A.BankAccount, A.BankName,
A.Bank, A.BankBranch, (A.Date) as A_SDate, (dateadd(year,1,A.Date)) as A_EDate, A.Statement, A.ASource, A.MSCode, A.BizMapID , A.TaxType,

cast(0 as Float) as Amount_4,

--Withholding Tax for Fund Held Interest
-dbo.roundccy(
case 
--Fund Held
when ((A.Date)>@P_PEDate and (A.Date)<=@P_EDate) then A.Amount_1* Reinsurance.FundHeldPCT/100*@IRate/100
--Fund Release
when ((dateadd(year,1,A.Date))>@P_PEDate and (dateadd(year,1,A.Date))<=@P_EDate) then 0
else 0
end*taxType.TaxRate/100, A.Currency) as Amount_14,

--Fund Held Interest
case 
--Fund Held
when ((A.Date)>@P_PEDate and (A.Date)<=@P_EDate) then A.Amount_1* Reinsurance.FundHeldPCT/100*@IRate/100
--Fund Release
when ((dateadd(year,1,A.Date))>@P_PEDate and (dateadd(year,1,A.Date))<=@P_EDate) then 0
else 0
end as Amount_15,

case 
--Fund Held
when ((A.Date)>@P_PEDate and (A.Date)<=@P_EDate) then A.Amount_1* Reinsurance.FundHeldPCT/100*@IRate/100
--Fund Release
when ((dateadd(year,1,A.Date))>@P_PEDate and (dateadd(year,1,A.Date))<=@P_EDate) then 0
else 0
end as PNominal_Tax,

@IRate as IRate

from Admlink A
Inner Join SysTab on (1=1)
Inner Join TaxType on (TaxType.TaxType=SysTab.TaxTypeFH)
inner join RPart on (RPart.DocNo=A.RefNo and RPart.ID=A.ID)
Inner Join Reinsurance on (Reinsurance.RNO=RPart.RNO and Reinsurance.FundHeldF=1 and Reinsurance.FundHeldPCT<>0)
Where A.Type in ('AF','QS','QP','S1','S2','S3') and A.Subject='Premium' and A.EXTRA_1<>'Fund Held' and A.AMOUNT_1<>0
and A.Date<=@P_EDate
and 
(
((A.Date)>@P_PEDate and (A.Date)<=@P_EDate)
)
)            







