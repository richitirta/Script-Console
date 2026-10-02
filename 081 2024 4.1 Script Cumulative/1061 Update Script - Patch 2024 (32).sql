
DROP function fn_SL_CTBudget
GO
Create function fn_SL_CTBudget(@P_Voucher as varchar(30))   
RETURNS TABLE   
AS RETURN   
(   
Select   
Budget.Branch,   
Budget.CT,
YEAR(Budget.Date) as Year,   
Budget.Account,   
MAX(Budget.Budget) as Budget,   
MAX(Budget.Actual)   
+ coalesce(sum(Case When SL.Status<>'P' Then (Case When SL.DebtorF=1 Then -SL.Nominal*SL.Rate else SL.Nominal*SL.Rate end) else 0 end),0)   
- Case When MAX(Budget.Status)='P' then MAX(Budget.Nominal) else 0 end   
- coalesce(sum(Case When SL.Status='P' Then (Case When SL.DebtorF=1 Then -SL.Nominal*SL.Rate else SL.Nominal*SL.Rate end) else 0 end),0)   
as Actual,   
MAX(Budget.Nominal) as Nominal   
from   
(   
	Select pSL.Branch, 
	(case When pSL.CT<>'' Then pSL.CT else pVoucher.CT end) as CT,
	pVoucher.Date, pSL.Account,   
	Max(pVoucher.Voucher) as Voucher,   
	max(pVoucher.Status) as Status,   
	Max(Case   
	When Month(pVoucher.Date)=1 Then coalesce(Budget.Month_1+Budget.Month_2+Budget.Month_3+Budget.Month_4+Budget.Month_5+Budget.Month_6+Budget.Month_7+Budget.Month_8+Budget.Month_9+Budget.Month_10+Budget.Month_11+Budget.Month_12, 0)   
	When Month(pVoucher.Date)=2 Then coalesce(Budget.Month_1+Budget.Month_2+Budget.Month_3+Budget.Month_4+Budget.Month_5+Budget.Month_6+Budget.Month_7+Budget.Month_8+Budget.Month_9+Budget.Month_10+Budget.Month_11+Budget.Month_12, 0)   
	When Month(pVoucher.Date)=3 Then coalesce(Budget.Month_1+Budget.Month_2+Budget.Month_3+Budget.Month_4+Budget.Month_5+Budget.Month_6+Budget.Month_7+Budget.Month_8+Budget.Month_9+Budget.Month_10+Budget.Month_11+Budget.Month_12, 0)   
	When Month(pVoucher.Date)=4 Then coalesce(Budget.Month_1+Budget.Month_2+Budget.Month_3+Budget.Month_4+Budget.Month_5+Budget.Month_6+Budget.Month_7+Budget.Month_8+Budget.Month_9+Budget.Month_10+Budget.Month_11+Budget.Month_12, 0)   
	When Month(pVoucher.Date)=5 Then coalesce(Budget.Month_1+Budget.Month_2+Budget.Month_3+Budget.Month_4+Budget.Month_5+Budget.Month_6+Budget.Month_7+Budget.Month_8+Budget.Month_9+Budget.Month_10+Budget.Month_11+Budget.Month_12, 0)   
	When Month(pVoucher.Date)=6 Then coalesce(Budget.Month_1+Budget.Month_2+Budget.Month_3+Budget.Month_4+Budget.Month_5+Budget.Month_6+Budget.Month_7+Budget.Month_8+Budget.Month_9+Budget.Month_10+Budget.Month_11+Budget.Month_12, 0)   
	When Month(pVoucher.Date)=7 Then coalesce(Budget.Month_1+Budget.Month_2+Budget.Month_3+Budget.Month_4+Budget.Month_5+Budget.Month_6+Budget.Month_7+Budget.Month_8+Budget.Month_9+Budget.Month_10+Budget.Month_11+Budget.Month_12, 0)   
	When Month(pVoucher.Date)=8 Then coalesce(Budget.Month_1+Budget.Month_2+Budget.Month_3+Budget.Month_4+Budget.Month_5+Budget.Month_6+Budget.Month_7+Budget.Month_8+Budget.Month_9+Budget.Month_10+Budget.Month_11+Budget.Month_12, 0)   
	When Month(pVoucher.Date)=9 Then coalesce(Budget.Month_1+Budget.Month_2+Budget.Month_3+Budget.Month_4+Budget.Month_5+Budget.Month_6+Budget.Month_7+Budget.Month_8+Budget.Month_9+Budget.Month_10+Budget.Month_11+Budget.Month_12, 0)   
	When Month(pVoucher.Date)=10 Then coalesce(Budget.Month_1+Budget.Month_2+Budget.Month_3+Budget.Month_4+Budget.Month_5+Budget.Month_6+Budget.Month_7+Budget.Month_8+Budget.Month_9+Budget.Month_10+Budget.Month_11+Budget.Month_12, 0)   
	When Month(pVoucher.Date)=11 Then coalesce(Budget.Month_1+Budget.Month_2+Budget.Month_3+Budget.Month_4+Budget.Month_5+Budget.Month_6+Budget.Month_7+Budget.Month_8+Budget.Month_9+Budget.Month_10+Budget.Month_11+Budget.Month_12, 0)   
	When Month(pVoucher.Date)=12 Then coalesce(Budget.Month_1+Budget.Month_2+Budget.Month_3+Budget.Month_4+Budget.Month_5+Budget.Month_6+Budget.Month_7+Budget.Month_8+Budget.Month_9+Budget.Month_10+Budget.Month_11+Budget.Month_12, 0)   
	end) as Budget,   
	Max(Case   
	When Month(pVoucher.Date)=1 Then coalesce(Budget.Actual_1, 0)   
	When Month(pVoucher.Date)=2 Then coalesce(Budget.Actual_1+Budget.Actual_2, 0)   
	When Month(pVoucher.Date)=3 Then coalesce(Budget.Actual_1+Budget.Actual_2+Budget.Actual_3, 0)   
	When Month(pVoucher.Date)=4 Then coalesce(Budget.Actual_1+Budget.Actual_2+Budget.Actual_3+Budget.Actual_4, 0)   
	When Month(pVoucher.Date)=5 Then coalesce(Budget.Actual_1+Budget.Actual_2+Budget.Actual_3+Budget.Actual_4+Budget.Actual_5, 0)   
	When Month(pVoucher.Date)=6 Then coalesce(Budget.Actual_1+Budget.Actual_2+Budget.Actual_3+Budget.Actual_4+Budget.Actual_5+Budget.Actual_6, 0)   
	When Month(pVoucher.Date)=7 Then coalesce(Budget.Actual_1+Budget.Actual_2+Budget.Actual_3+Budget.Actual_4+Budget.Actual_5+Budget.Actual_6+Budget.Actual_7, 0)   
	When Month(pVoucher.Date)=8 Then coalesce(Budget.Actual_1+Budget.Actual_2+Budget.Actual_3+Budget.Actual_4+Budget.Actual_5+Budget.Actual_6+Budget.Actual_7+Budget.Actual_8, 0)   
	When Month(pVoucher.Date)=9 Then coalesce(Budget.Actual_1+Budget.Actual_2+Budget.Actual_3+Budget.Actual_4+Budget.Actual_5+Budget.Actual_6+Budget.Actual_7+Budget.Actual_8+Budget.Actual_9, 0)   
	When Month(pVoucher.Date)=10 Then coalesce(Budget.Actual_1+Budget.Actual_2+Budget.Actual_3+Budget.Actual_4+Budget.Actual_5+Budget.Actual_6+Budget.Actual_7+Budget.Actual_8+Budget.Actual_9+Budget.Actual_10, 0)   
	When Month(pVoucher.Date)=11 Then coalesce(Budget.Actual_1+Budget.Actual_2+Budget.Actual_3+Budget.Actual_4+Budget.Actual_5+Budget.Actual_6+Budget.Actual_7+Budget.Actual_8+Budget.Actual_9+Budget.Actual_10+Budget.Actual_11, 0)   
	When Month(pVoucher.Date)=12 Then coalesce(Budget.Actual_1+Budget.Actual_2+Budget.Actual_3+Budget.Actual_4+Budget.Actual_5+Budget.Actual_6+Budget.Actual_7+Budget.Actual_8+Budget.Actual_9+Budget.Actual_10+Budget.Actual_11+Budget.Actual_12, 0)   
	end) as Actual,   
	sum(Case When pVoucher.DebtorF=1 Then -pSL.Nominal*pVoucher.Rate else pSL.Nominal*pVoucher.Rate end) as Nominal   
	from pVoucher   
	inner join oSL(@P_Voucher) pSL on (pSL.Voucher=pVoucher.Voucher)   
	inner join Account on (Account.Account=pSL.Account)   
	inner join Type on (Type.Type=Account.Type and Type.PL_Flag=1)   
	left join CTBudget Budget on (Budget.Branch=pSL.Branch and Budget.CT=(case When pSL.CT<>'' Then pSL.CT else pVoucher.CT end) and Budget.Year=Year(pVoucher.Date) and Budget.Account=pSL.Account)   
	Where pVoucher.Voucher=@P_Voucher   
	Group by pSL.Branch, case When pSL.CT<>'' Then pSL.CT else pVoucher.CT end, pVoucher.Date, pSL.Account   
) Budget   
Outer Apply    
--Part Of OSL Functions   
(   
	Select pVoucher.Status, pVoucher.Rate as Rate, pVoucher.DebtorF, pSL.Nominal, 
	Case When OSL.Account is null then pSL.Account else OSL.Account end as Account, 
	Case When OSL.Branch is null then pVoucher.Branch else OSL.Branch end as Branch,
	case When pSL.CT<>'' Then pSL.CT else pVoucher.CT end as CT
	From dbo.pVoucher 
	Inner Join dbo.VType on (VType.VType=pVoucher.VType)
	Inner Join dbo.pSL on (pSL.Voucher=pVoucher.Voucher) 
	Left Join dbo.Branch OBranch on (OBranch.IO_Account=pSL.Account)
	Outer Apply
	(
		Select OVoucher.Branch, OSL.PaymentF, OSL.Account
		from pVoucher OVoucher, pSL OSL
		Where OSL.Voucher=OVoucher.Voucher and OSL.Doc_No=pSL.Doc_No and OSL.Nominal=pSL.Nominal and (oSL.SortNo=0 or oSL.SortNo=pSL.SortNo)
		and OVoucher.RefNo=pSL.Voucher and OVoucher.Branch=OBranch.Branch and OVoucher.SL_Cat='B' and OVoucher.RefType='INTEROFFICE'
	) OSL
	Where pVoucher.Voucher<>@P_Voucher and pVoucher.SL_Cat='P' 
	and YEAR(pVoucher.Date)=YEAR(Budget.Date) and Month(pVoucher.Date)<=Month(Budget.Date) and ((pVoucher.Status<>'P' and pVoucher.Date<Budget.Date) or ((pVoucher.Status='P' and pVoucher.Date>=Budget.Date))) 
	and Case When OSL.Account is null then pSL.Account else OSL.Account end=Budget.Account 
	and Case When OSL.Branch is null then pVoucher.Branch else OSL.Branch end=Budget.Branch
	and case When pSL.CT<>'' Then pSL.CT else pVoucher.CT end=Budget.CT
) SL 

--Not using Budget Group
Outer Apply (Select Top 1 B.GID from Budget_Entry B Where B.Year=Year(Budget.Date) and B.Branch=Budget.Branch and B.CT=Budget.CT and B.Status='P') BG
Where coalesce(BG.GID,'')=''

Group By Budget.Branch, Budget.CT, YEAR(Budget.Date), Budget.Account         
)   


GO

DROP function fn_SL_Budget
GO
Create function fn_SL_Budget(@P_Voucher as varchar(30))   
RETURNS TABLE   
AS RETURN   
(   
Select   
Budget.Branch,   
YEAR(Budget.Date) as Year,   
Budget.Account,   
MAX(Budget.Budget) as Budget,   
MAX(Budget.Actual)   
+ coalesce(sum(Case When SL.Status<>'P' Then (Case When SL.DebtorF=1 Then -SL.Nominal*SL.Rate else SL.Nominal*SL.Rate end) else 0 end),0)   
- Case When MAX(Budget.Status)='P' then MAX(Budget.Nominal) else 0 end   
- coalesce(sum(Case When SL.Status='P' Then (Case When SL.DebtorF=1 Then -SL.Nominal*SL.Rate else SL.Nominal*SL.Rate end) else 0 end),0)   
as Actual,   
MAX(Budget.Nominal) as Nominal   
from   
(   
	Select pSL.Branch, pVoucher.Date, pSL.Account,   
	Max(pVoucher.Voucher) as Voucher,   
	max(pVoucher.Status) as Status,   
	Max(Case   
	When Month(pVoucher.Date)=1 Then coalesce(Budget.Month_1+Budget.Month_2+Budget.Month_3+Budget.Month_4+Budget.Month_5+Budget.Month_6+Budget.Month_7+Budget.Month_8+Budget.Month_9+Budget.Month_10+Budget.Month_11+Budget.Month_12, 0)   
	When Month(pVoucher.Date)=2 Then coalesce(Budget.Month_1+Budget.Month_2+Budget.Month_3+Budget.Month_4+Budget.Month_5+Budget.Month_6+Budget.Month_7+Budget.Month_8+Budget.Month_9+Budget.Month_10+Budget.Month_11+Budget.Month_12, 0)   
	When Month(pVoucher.Date)=3 Then coalesce(Budget.Month_1+Budget.Month_2+Budget.Month_3+Budget.Month_4+Budget.Month_5+Budget.Month_6+Budget.Month_7+Budget.Month_8+Budget.Month_9+Budget.Month_10+Budget.Month_11+Budget.Month_12, 0)   
	When Month(pVoucher.Date)=4 Then coalesce(Budget.Month_1+Budget.Month_2+Budget.Month_3+Budget.Month_4+Budget.Month_5+Budget.Month_6+Budget.Month_7+Budget.Month_8+Budget.Month_9+Budget.Month_10+Budget.Month_11+Budget.Month_12, 0)   
	When Month(pVoucher.Date)=5 Then coalesce(Budget.Month_1+Budget.Month_2+Budget.Month_3+Budget.Month_4+Budget.Month_5+Budget.Month_6+Budget.Month_7+Budget.Month_8+Budget.Month_9+Budget.Month_10+Budget.Month_11+Budget.Month_12, 0)   
	When Month(pVoucher.Date)=6 Then coalesce(Budget.Month_1+Budget.Month_2+Budget.Month_3+Budget.Month_4+Budget.Month_5+Budget.Month_6+Budget.Month_7+Budget.Month_8+Budget.Month_9+Budget.Month_10+Budget.Month_11+Budget.Month_12, 0)   
	When Month(pVoucher.Date)=7 Then coalesce(Budget.Month_1+Budget.Month_2+Budget.Month_3+Budget.Month_4+Budget.Month_5+Budget.Month_6+Budget.Month_7+Budget.Month_8+Budget.Month_9+Budget.Month_10+Budget.Month_11+Budget.Month_12, 0)   
	When Month(pVoucher.Date)=8 Then coalesce(Budget.Month_1+Budget.Month_2+Budget.Month_3+Budget.Month_4+Budget.Month_5+Budget.Month_6+Budget.Month_7+Budget.Month_8+Budget.Month_9+Budget.Month_10+Budget.Month_11+Budget.Month_12, 0)   
	When Month(pVoucher.Date)=9 Then coalesce(Budget.Month_1+Budget.Month_2+Budget.Month_3+Budget.Month_4+Budget.Month_5+Budget.Month_6+Budget.Month_7+Budget.Month_8+Budget.Month_9+Budget.Month_10+Budget.Month_11+Budget.Month_12, 0)   
	When Month(pVoucher.Date)=10 Then coalesce(Budget.Month_1+Budget.Month_2+Budget.Month_3+Budget.Month_4+Budget.Month_5+Budget.Month_6+Budget.Month_7+Budget.Month_8+Budget.Month_9+Budget.Month_10+Budget.Month_11+Budget.Month_12, 0)   
	When Month(pVoucher.Date)=11 Then coalesce(Budget.Month_1+Budget.Month_2+Budget.Month_3+Budget.Month_4+Budget.Month_5+Budget.Month_6+Budget.Month_7+Budget.Month_8+Budget.Month_9+Budget.Month_10+Budget.Month_11+Budget.Month_12, 0)   
	When Month(pVoucher.Date)=12 Then coalesce(Budget.Month_1+Budget.Month_2+Budget.Month_3+Budget.Month_4+Budget.Month_5+Budget.Month_6+Budget.Month_7+Budget.Month_8+Budget.Month_9+Budget.Month_10+Budget.Month_11+Budget.Month_12, 0)   
	end) as Budget,   
	Max(Case   
	When Month(pVoucher.Date)=1 Then coalesce(Budget.Actual_1, 0)   
	When Month(pVoucher.Date)=2 Then coalesce(Budget.Actual_1+Budget.Actual_2, 0)   
	When Month(pVoucher.Date)=3 Then coalesce(Budget.Actual_1+Budget.Actual_2+Budget.Actual_3, 0)   
	When Month(pVoucher.Date)=4 Then coalesce(Budget.Actual_1+Budget.Actual_2+Budget.Actual_3+Budget.Actual_4, 0)   
	When Month(pVoucher.Date)=5 Then coalesce(Budget.Actual_1+Budget.Actual_2+Budget.Actual_3+Budget.Actual_4+Budget.Actual_5, 0)   
	When Month(pVoucher.Date)=6 Then coalesce(Budget.Actual_1+Budget.Actual_2+Budget.Actual_3+Budget.Actual_4+Budget.Actual_5+Budget.Actual_6, 0)   
	When Month(pVoucher.Date)=7 Then coalesce(Budget.Actual_1+Budget.Actual_2+Budget.Actual_3+Budget.Actual_4+Budget.Actual_5+Budget.Actual_6+Budget.Actual_7, 0)   
	When Month(pVoucher.Date)=8 Then coalesce(Budget.Actual_1+Budget.Actual_2+Budget.Actual_3+Budget.Actual_4+Budget.Actual_5+Budget.Actual_6+Budget.Actual_7+Budget.Actual_8, 0)   
	When Month(pVoucher.Date)=9 Then coalesce(Budget.Actual_1+Budget.Actual_2+Budget.Actual_3+Budget.Actual_4+Budget.Actual_5+Budget.Actual_6+Budget.Actual_7+Budget.Actual_8+Budget.Actual_9, 0)   
	When Month(pVoucher.Date)=10 Then coalesce(Budget.Actual_1+Budget.Actual_2+Budget.Actual_3+Budget.Actual_4+Budget.Actual_5+Budget.Actual_6+Budget.Actual_7+Budget.Actual_8+Budget.Actual_9+Budget.Actual_10, 0)   
	When Month(pVoucher.Date)=11 Then coalesce(Budget.Actual_1+Budget.Actual_2+Budget.Actual_3+Budget.Actual_4+Budget.Actual_5+Budget.Actual_6+Budget.Actual_7+Budget.Actual_8+Budget.Actual_9+Budget.Actual_10+Budget.Actual_11, 0)   
	When Month(pVoucher.Date)=12 Then coalesce(Budget.Actual_1+Budget.Actual_2+Budget.Actual_3+Budget.Actual_4+Budget.Actual_5+Budget.Actual_6+Budget.Actual_7+Budget.Actual_8+Budget.Actual_9+Budget.Actual_10+Budget.Actual_11+Budget.Actual_12, 0)   
	end) as Actual,   
	sum(Case When pVoucher.DebtorF=1 Then -pSL.Nominal*pVoucher.Rate else pSL.Nominal*pVoucher.Rate end) as Nominal   
	from pVoucher   
	inner join oSL(@P_Voucher) pSL on (pSL.Voucher=pVoucher.Voucher)   
	inner join Account on (Account.Account=pSL.Account)   
	inner join Type on (Type.Type=Account.Type and Type.PL_Flag=1)   
	left join Budget on (Budget.Branch=pSL.Branch and Budget.Year=Year(pVoucher.Date) and Budget.Account=pSL.Account)   
	Where pVoucher.Voucher=@P_Voucher   
	Group by pSL.Branch, pVoucher.Date, pSL.Account   
) Budget   
Outer Apply 
--Part Of OSL Functions   
(   
	Select pVoucher.Status, pVoucher.Rate as Rate, pVoucher.DebtorF, pSL.Nominal, 
	Case When OSL.Account is null then pSL.Account else OSL.Account end as Account, 
	Case When OSL.Branch is null then pVoucher.Branch else OSL.Branch end as Branch
	From dbo.pVoucher 
	Inner Join dbo.VType on (VType.VType=pVoucher.VType)
	Inner Join dbo.pSL on (pSL.Voucher=pVoucher.Voucher) 
	Left Join dbo.Branch OBranch on (OBranch.IO_Account=pSL.Account)
	Outer Apply
	(
		Select OVoucher.Branch, OSL.PaymentF, OSL.Account
		from pVoucher OVoucher, pSL OSL
		Where OSL.Voucher=OVoucher.Voucher and OSL.Doc_No=pSL.Doc_No and OSL.Nominal=pSL.Nominal and (oSL.SortNo=0 or oSL.SortNo=pSL.SortNo)
		and OVoucher.RefNo=pSL.Voucher and OVoucher.Branch=OBranch.Branch and OVoucher.SL_Cat='B' and OVoucher.RefType='INTEROFFICE'
	) OSL
	Where pVoucher.Voucher<>@P_Voucher and pVoucher.SL_Cat='P' 
	and YEAR(pVoucher.Date)=YEAR(Budget.Date) and Month(pVoucher.Date)<=Month(Budget.Date) and ((pVoucher.Status<>'P' and pVoucher.Date<Budget.Date) or ((pVoucher.Status='P' and pVoucher.Date>=Budget.Date))) 
	and Case When OSL.Account is null then pSL.Account else OSL.Account end=Budget.Account 
	and Case When OSL.Branch is null then pVoucher.Branch else OSL.Branch end=Budget.Branch
) SL 

--Not using Budget Group
Outer Apply (Select Top 1 B.GID from Budget_Entry B Where B.Year=Year(Budget.Date) and B.Branch=Budget.Branch and B.Status='P') BG
Where coalesce(BG.GID,'')=''

Group By Budget.Branch, YEAR(Budget.Date), Budget.Account        
)   
   

GO

DROP function fn_SL_Request_CTBudget
GO
Create function fn_SL_Request_CTBudget(@P_Request as varchar(20))   
RETURNS TABLE   
AS RETURN   
(   
Select   
Budget.Branch,   
Budget.CT,
YEAR(Budget.Date) as Year,   
Budget.Account,   
MAX(Budget.Budget) as Budget,   
MAX(Budget.Actual)   
+ coalesce(sum(Case When Voucher.Status<>'P' Then (Case When Voucher.DebtorF=1 Then -SL.Nominal*Voucher.Rate else SL.Nominal*Voucher.Rate end) else 0 end),0)   
- Case When MAX(Budget.Status)='P' then MAX(Budget.Nominal) else 0 end   
- coalesce(sum(Case When Voucher.Status='P' Then (Case When Voucher.DebtorF=1 Then -SL.Nominal*Voucher.Rate else SL.Nominal*Voucher.Rate end) else 0 end),0)   
as Actual,   
MAX(Budget.Nominal) as Nominal   
from   
(   
	Select 
	(Case When pSL.Branch<>'' Then pSL.Branch else Request.Branch end) as Branch, 
	(Case When pSL.CT<>'' Then pSL.CT else Request.CT end) as CT,
	Request.Request, Request.Date, pSL.Account,   
	Max(coalesce(pVoucher.Voucher,'')) as Voucher,   
	Max(coalesce(pVoucher.Status,'')) as Status,   
	Max(Case   
	When Month(Request.Date)=1 Then coalesce(Budget.Month_1+Budget.Month_2+Budget.Month_3+Budget.Month_4+Budget.Month_5+Budget.Month_6+Budget.Month_7+Budget.Month_8+Budget.Month_9+Budget.Month_10+Budget.Month_11+Budget.Month_12, 0)   
	When Month(Request.Date)=2 Then coalesce(Budget.Month_1+Budget.Month_2+Budget.Month_3+Budget.Month_4+Budget.Month_5+Budget.Month_6+Budget.Month_7+Budget.Month_8+Budget.Month_9+Budget.Month_10+Budget.Month_11+Budget.Month_12, 0)   
	When Month(Request.Date)=3 Then coalesce(Budget.Month_1+Budget.Month_2+Budget.Month_3+Budget.Month_4+Budget.Month_5+Budget.Month_6+Budget.Month_7+Budget.Month_8+Budget.Month_9+Budget.Month_10+Budget.Month_11+Budget.Month_12, 0)   
	When Month(Request.Date)=4 Then coalesce(Budget.Month_1+Budget.Month_2+Budget.Month_3+Budget.Month_4+Budget.Month_5+Budget.Month_6+Budget.Month_7+Budget.Month_8+Budget.Month_9+Budget.Month_10+Budget.Month_11+Budget.Month_12, 0)   
	When Month(Request.Date)=5 Then coalesce(Budget.Month_1+Budget.Month_2+Budget.Month_3+Budget.Month_4+Budget.Month_5+Budget.Month_6+Budget.Month_7+Budget.Month_8+Budget.Month_9+Budget.Month_10+Budget.Month_11+Budget.Month_12, 0)   
	When Month(Request.Date)=6 Then coalesce(Budget.Month_1+Budget.Month_2+Budget.Month_3+Budget.Month_4+Budget.Month_5+Budget.Month_6+Budget.Month_7+Budget.Month_8+Budget.Month_9+Budget.Month_10+Budget.Month_11+Budget.Month_12, 0)   
	When Month(Request.Date)=7 Then coalesce(Budget.Month_1+Budget.Month_2+Budget.Month_3+Budget.Month_4+Budget.Month_5+Budget.Month_6+Budget.Month_7+Budget.Month_8+Budget.Month_9+Budget.Month_10+Budget.Month_11+Budget.Month_12, 0)   
	When Month(Request.Date)=8 Then coalesce(Budget.Month_1+Budget.Month_2+Budget.Month_3+Budget.Month_4+Budget.Month_5+Budget.Month_6+Budget.Month_7+Budget.Month_8+Budget.Month_9+Budget.Month_10+Budget.Month_11+Budget.Month_12, 0)   
	When Month(Request.Date)=9 Then coalesce(Budget.Month_1+Budget.Month_2+Budget.Month_3+Budget.Month_4+Budget.Month_5+Budget.Month_6+Budget.Month_7+Budget.Month_8+Budget.Month_9+Budget.Month_10+Budget.Month_11+Budget.Month_12, 0)   
	When Month(Request.Date)=10 Then coalesce(Budget.Month_1+Budget.Month_2+Budget.Month_3+Budget.Month_4+Budget.Month_5+Budget.Month_6+Budget.Month_7+Budget.Month_8+Budget.Month_9+Budget.Month_10+Budget.Month_11+Budget.Month_12, 0)   
	When Month(Request.Date)=11 Then coalesce(Budget.Month_1+Budget.Month_2+Budget.Month_3+Budget.Month_4+Budget.Month_5+Budget.Month_6+Budget.Month_7+Budget.Month_8+Budget.Month_9+Budget.Month_10+Budget.Month_11+Budget.Month_12, 0)   
	When Month(Request.Date)=12 Then coalesce(Budget.Month_1+Budget.Month_2+Budget.Month_3+Budget.Month_4+Budget.Month_5+Budget.Month_6+Budget.Month_7+Budget.Month_8+Budget.Month_9+Budget.Month_10+Budget.Month_11+Budget.Month_12, 0)   
	end) as Budget,   
	Max(Case   
	When Month(Request.Date)=1 Then coalesce(Budget.Actual_1, 0)   
	When Month(Request.Date)=2 Then coalesce(Budget.Actual_1+Budget.Actual_2, 0)   
	When Month(Request.Date)=3 Then coalesce(Budget.Actual_1+Budget.Actual_2+Budget.Actual_3, 0)   
	When Month(Request.Date)=4 Then coalesce(Budget.Actual_1+Budget.Actual_2+Budget.Actual_3+Budget.Actual_4, 0)   
	When Month(Request.Date)=5 Then coalesce(Budget.Actual_1+Budget.Actual_2+Budget.Actual_3+Budget.Actual_4+Budget.Actual_5, 0)   
	When Month(Request.Date)=6 Then coalesce(Budget.Actual_1+Budget.Actual_2+Budget.Actual_3+Budget.Actual_4+Budget.Actual_5+Budget.Actual_6, 0)   
	When Month(Request.Date)=7 Then coalesce(Budget.Actual_1+Budget.Actual_2+Budget.Actual_3+Budget.Actual_4+Budget.Actual_5+Budget.Actual_6+Budget.Actual_7, 0)   
	When Month(Request.Date)=8 Then coalesce(Budget.Actual_1+Budget.Actual_2+Budget.Actual_3+Budget.Actual_4+Budget.Actual_5+Budget.Actual_6+Budget.Actual_7+Budget.Actual_8, 0)   
	When Month(Request.Date)=9 Then coalesce(Budget.Actual_1+Budget.Actual_2+Budget.Actual_3+Budget.Actual_4+Budget.Actual_5+Budget.Actual_6+Budget.Actual_7+Budget.Actual_8+Budget.Actual_9, 0)   
	When Month(Request.Date)=10 Then coalesce(Budget.Actual_1+Budget.Actual_2+Budget.Actual_3+Budget.Actual_4+Budget.Actual_5+Budget.Actual_6+Budget.Actual_7+Budget.Actual_8+Budget.Actual_9+Budget.Actual_10, 0)   
	When Month(Request.Date)=11 Then coalesce(Budget.Actual_1+Budget.Actual_2+Budget.Actual_3+Budget.Actual_4+Budget.Actual_5+Budget.Actual_6+Budget.Actual_7+Budget.Actual_8+Budget.Actual_9+Budget.Actual_10+Budget.Actual_11, 0)   
	When Month(Request.Date)=12 Then coalesce(Budget.Actual_1+Budget.Actual_2+Budget.Actual_3+Budget.Actual_4+Budget.Actual_5+Budget.Actual_6+Budget.Actual_7+Budget.Actual_8+Budget.Actual_9+Budget.Actual_10+Budget.Actual_11+Budget.Actual_12, 0)   
	end) as Actual,   
	sum(Case When Request.DebtorF=1 Then -pSL.Nominal*Request.Rate else pSL.Nominal*Request.Rate end) as Nominal   
	from Request   
	inner join SL_Request pSL on (pSL.Request=Request.Request)   
	inner join Account on (Account.Account=pSL.Account)   
	inner join Type on (Type.Type=Account.Type and Type.PL_Flag=1)   
	Left Join pVoucher on (pVoucher.Voucher=Request.Voucher)   
	left join CTBudget Budget on (Budget.Branch=(Case When pSL.Branch<>'' Then pSL.Branch else Request.Branch end) and Budget.CT=(Case When pSL.CT<>'' Then pSL.CT else Request.CT end) and Budget.Year=Year(Request.Date) and Budget.Account=pSL.Account)   
	Where Request.Request=@P_Request   
	Group by (Case When pSL.Branch<>'' Then pSL.Branch else Request.Branch end), (Case When pSL.CT<>'' Then pSL.CT else Request.CT end), Request.Request, Request.Date, pSL.Account   
) Budget   
Left join pVoucher Voucher on (Voucher.Voucher<>Budget.Voucher and Voucher.SL_Cat='P' and YEAR(Voucher.Date)=YEAR(Budget.Date) and Month(Voucher.Date)<=Month(Budget.Date) and ((Voucher.Status<>'P' and Voucher.Date<Budget.Date) or ((Voucher.Status='P' and Voucher.Date>=Budget.Date))))   
Outer Apply
--Part Of OSL Functions   
(   
 Select pVoucher.Voucher, 
 case When pSL.CT<>'' Then pSL.CT else pVoucher.CT end as CT, 
 Case When OSL.Account is null then pSL.Account else OSL.Account end as Account,   
 Case When OSL.Branch is null then pVoucher.Branch else OSL.Branch end as Branch,
 Case When OSL.PaymentF is null then pSL.PaymentF else OSL.PaymentF end as PaymentF,   
 pSL.Doc_No, pSL.Doc_Date, pSL.Doc_CCY, pSL.Nominal_OC, pSL.Nominal, pSL.Remarks, pSL.Hint,  pSL.Nominator, pSL.Denominator, pSL.Rate, pSL.SortNo, pSL.pVoucher     
 From dbo.pSL   
 Inner Join dbo.pVoucher on (pVoucher.Voucher=pSL.Voucher)   
 Left join dbo.Branch OBranch on (OBranch.IO_Account=pSL.Account)   
 Outer Apply
 (
	Select OVoucher.Branch, OSL.PaymentF, OSL.Account
	from pVoucher OVoucher, pSL OSL
	Where OSL.Voucher=OVoucher.Voucher and OSL.Doc_No=pSL.Doc_No and OSL.Nominal=pSL.Nominal and (oSL.SortNo=0 or oSL.SortNo=pSL.SortNo)
	and OVoucher.RefNo=pSL.Voucher and OVoucher.Branch=OBranch.Branch and OVoucher.SL_Cat='B' and OVoucher.RefType='INTEROFFICE'
 ) OSL
 Where pVoucher.Voucher=Voucher.Voucher
 and Case When OSL.Account is null then pSL.Account else OSL.Account end=Budget.Account 
 and Case When OSL.Branch is null then pVoucher.Branch else OSL.Branch end=Budget.Branch
 and case When pSL.CT<>'' Then pSL.CT else pVoucher.CT end=Budget.CT
) SL 

--Not using Budget Group
Outer Apply (Select Top 1 B.GID from Budget_Entry B Where B.Year=Year(Budget.Date) and B.Branch=Budget.Branch and B.CT=Budget.CT and B.Status='P') BG
Where coalesce(BG.GID,'')=''

Group By Budget.Branch, Budget.CT, YEAR(Budget.Date), Budget.Account   
)   
   
GO

DROP function fn_SL_Request_Budget
GO
Create function fn_SL_Request_Budget(@P_Request as varchar(20))   
RETURNS TABLE   
AS RETURN   
(   
Select   
Budget.Branch,   
YEAR(Budget.Date) as Year,   
Budget.Account,   
MAX(Budget.Budget) as Budget,   
MAX(Budget.Actual)   
+ coalesce(sum(Case When Voucher.Status<>'P' Then (Case When Voucher.DebtorF=1 Then -SL.Nominal*Voucher.Rate else SL.Nominal*Voucher.Rate end) else 0 end),0)   
- Case When MAX(Budget.Status)='P' then MAX(Budget.Nominal) else 0 end   
- coalesce(sum(Case When Voucher.Status='P' Then (Case When Voucher.DebtorF=1 Then -SL.Nominal*Voucher.Rate else SL.Nominal*Voucher.Rate end) else 0 end),0)   
as Actual,   
MAX(Budget.Nominal) as Nominal   
from   
(   
Select (Case When pSL.Branch<>'' Then pSL.Branch else Request.Branch end) as Branch, Request.Request, Request.Date, pSL.Account,   
Max(coalesce(pVoucher.Voucher,'')) as Voucher,   
Max(coalesce(pVoucher.Status,'')) as Status,   
Max(Case   
When Month(Request.Date)=1 Then coalesce(Budget.Month_1+Budget.Month_2+Budget.Month_3+Budget.Month_4+Budget.Month_5+Budget.Month_6+Budget.Month_7+Budget.Month_8+Budget.Month_9+Budget.Month_10+Budget.Month_11+Budget.Month_12, 0)   
When Month(Request.Date)=2 Then coalesce(Budget.Month_1+Budget.Month_2+Budget.Month_3+Budget.Month_4+Budget.Month_5+Budget.Month_6+Budget.Month_7+Budget.Month_8+Budget.Month_9+Budget.Month_10+Budget.Month_11+Budget.Month_12, 0)   
When Month(Request.Date)=3 Then coalesce(Budget.Month_1+Budget.Month_2+Budget.Month_3+Budget.Month_4+Budget.Month_5+Budget.Month_6+Budget.Month_7+Budget.Month_8+Budget.Month_9+Budget.Month_10+Budget.Month_11+Budget.Month_12, 0)   
When Month(Request.Date)=4 Then coalesce(Budget.Month_1+Budget.Month_2+Budget.Month_3+Budget.Month_4+Budget.Month_5+Budget.Month_6+Budget.Month_7+Budget.Month_8+Budget.Month_9+Budget.Month_10+Budget.Month_11+Budget.Month_12, 0)   
When Month(Request.Date)=5 Then coalesce(Budget.Month_1+Budget.Month_2+Budget.Month_3+Budget.Month_4+Budget.Month_5+Budget.Month_6+Budget.Month_7+Budget.Month_8+Budget.Month_9+Budget.Month_10+Budget.Month_11+Budget.Month_12, 0)   
When Month(Request.Date)=6 Then coalesce(Budget.Month_1+Budget.Month_2+Budget.Month_3+Budget.Month_4+Budget.Month_5+Budget.Month_6+Budget.Month_7+Budget.Month_8+Budget.Month_9+Budget.Month_10+Budget.Month_11+Budget.Month_12, 0)   
When Month(Request.Date)=7 Then coalesce(Budget.Month_1+Budget.Month_2+Budget.Month_3+Budget.Month_4+Budget.Month_5+Budget.Month_6+Budget.Month_7+Budget.Month_8+Budget.Month_9+Budget.Month_10+Budget.Month_11+Budget.Month_12, 0)   
When Month(Request.Date)=8 Then coalesce(Budget.Month_1+Budget.Month_2+Budget.Month_3+Budget.Month_4+Budget.Month_5+Budget.Month_6+Budget.Month_7+Budget.Month_8+Budget.Month_9+Budget.Month_10+Budget.Month_11+Budget.Month_12, 0)   
When Month(Request.Date)=9 Then coalesce(Budget.Month_1+Budget.Month_2+Budget.Month_3+Budget.Month_4+Budget.Month_5+Budget.Month_6+Budget.Month_7+Budget.Month_8+Budget.Month_9+Budget.Month_10+Budget.Month_11+Budget.Month_12, 0)   
When Month(Request.Date)=10 Then coalesce(Budget.Month_1+Budget.Month_2+Budget.Month_3+Budget.Month_4+Budget.Month_5+Budget.Month_6+Budget.Month_7+Budget.Month_8+Budget.Month_9+Budget.Month_10+Budget.Month_11+Budget.Month_12, 0)   
When Month(Request.Date)=11 Then coalesce(Budget.Month_1+Budget.Month_2+Budget.Month_3+Budget.Month_4+Budget.Month_5+Budget.Month_6+Budget.Month_7+Budget.Month_8+Budget.Month_9+Budget.Month_10+Budget.Month_11+Budget.Month_12, 0)   
When Month(Request.Date)=12 Then coalesce(Budget.Month_1+Budget.Month_2+Budget.Month_3+Budget.Month_4+Budget.Month_5+Budget.Month_6+Budget.Month_7+Budget.Month_8+Budget.Month_9+Budget.Month_10+Budget.Month_11+Budget.Month_12, 0)   
end) as Budget,   
Max(Case   
When Month(Request.Date)=1 Then coalesce(Budget.Actual_1, 0)   
When Month(Request.Date)=2 Then coalesce(Budget.Actual_1+Budget.Actual_2, 0)   
When Month(Request.Date)=3 Then coalesce(Budget.Actual_1+Budget.Actual_2+Budget.Actual_3, 0)   
When Month(Request.Date)=4 Then coalesce(Budget.Actual_1+Budget.Actual_2+Budget.Actual_3+Budget.Actual_4, 0)   
When Month(Request.Date)=5 Then coalesce(Budget.Actual_1+Budget.Actual_2+Budget.Actual_3+Budget.Actual_4+Budget.Actual_5, 0)   
When Month(Request.Date)=6 Then coalesce(Budget.Actual_1+Budget.Actual_2+Budget.Actual_3+Budget.Actual_4+Budget.Actual_5+Budget.Actual_6, 0)   
When Month(Request.Date)=7 Then coalesce(Budget.Actual_1+Budget.Actual_2+Budget.Actual_3+Budget.Actual_4+Budget.Actual_5+Budget.Actual_6+Budget.Actual_7, 0)   
When Month(Request.Date)=8 Then coalesce(Budget.Actual_1+Budget.Actual_2+Budget.Actual_3+Budget.Actual_4+Budget.Actual_5+Budget.Actual_6+Budget.Actual_7+Budget.Actual_8, 0)   
When Month(Request.Date)=9 Then coalesce(Budget.Actual_1+Budget.Actual_2+Budget.Actual_3+Budget.Actual_4+Budget.Actual_5+Budget.Actual_6+Budget.Actual_7+Budget.Actual_8+Budget.Actual_9, 0)   
When Month(Request.Date)=10 Then coalesce(Budget.Actual_1+Budget.Actual_2+Budget.Actual_3+Budget.Actual_4+Budget.Actual_5+Budget.Actual_6+Budget.Actual_7+Budget.Actual_8+Budget.Actual_9+Budget.Actual_10, 0)   
When Month(Request.Date)=11 Then coalesce(Budget.Actual_1+Budget.Actual_2+Budget.Actual_3+Budget.Actual_4+Budget.Actual_5+Budget.Actual_6+Budget.Actual_7+Budget.Actual_8+Budget.Actual_9+Budget.Actual_10+Budget.Actual_11, 0)   
When Month(Request.Date)=12 Then coalesce(Budget.Actual_1+Budget.Actual_2+Budget.Actual_3+Budget.Actual_4+Budget.Actual_5+Budget.Actual_6+Budget.Actual_7+Budget.Actual_8+Budget.Actual_9+Budget.Actual_10+Budget.Actual_11+Budget.Actual_12, 0)   
end) as Actual,   
sum(Case When Request.DebtorF=1 Then -pSL.Nominal*Request.Rate else pSL.Nominal*Request.Rate end) as Nominal   
from Request   
inner join SL_Request pSL on (pSL.Request=Request.Request)   
inner join Account on (Account.Account=pSL.Account)   
inner join Type on (Type.Type=Account.Type and Type.PL_Flag=1)   
Left Join pVoucher on (pVoucher.Voucher=Request.Voucher)   
left join Budget on (Budget.Branch=(Case When pSL.Branch<>'' Then pSL.Branch else Request.Branch end) and Budget.Year=Year(Request.Date) and Budget.Account=pSL.Account)   
Where Request.Request=@P_Request   
Group by (Case When pSL.Branch<>'' Then pSL.Branch else Request.Branch end), Request.Request, Request.Date, pSL.Account   
) Budget   
Left join pVoucher Voucher on (Voucher.Voucher<>Budget.Voucher and Voucher.SL_Cat='P' and YEAR(Voucher.Date)=YEAR(Budget.Date) and Month(Voucher.Date)<=Month(Budget.Date) and ((Voucher.Status<>'P' and Voucher.Date<Budget.Date) or ((Voucher.Status='P' and Voucher.Date>=Budget.Date))))   
Outer Apply
--Part Of OSL Functions   
(   

 Select pVoucher.Voucher, 
 case When pSL.CT<>'' Then pSL.CT else pVoucher.CT end as CT, 
 Case When OSL.Account is null then pSL.Account else OSL.Account end as Account,   
 Case When OSL.Branch is null then pVoucher.Branch else OSL.Branch end as Branch,
 Case When OSL.PaymentF is null then pSL.PaymentF else OSL.PaymentF end as PaymentF,   
 pSL.Doc_No, pSL.Doc_Date, pSL.Doc_CCY, pSL.Nominal_OC, pSL.Nominal, pSL.Remarks, pSL.Hint,  pSL.Nominator, pSL.Denominator, pSL.Rate, pSL.SortNo, pSL.pVoucher     
 From dbo.pSL   
 Inner Join dbo.pVoucher on (pVoucher.Voucher=pSL.Voucher)   
 Left join dbo.Branch OBranch on (OBranch.IO_Account=pSL.Account)   
 Outer Apply
 (
	Select OVoucher.Branch, OSL.PaymentF, OSL.Account
	from pVoucher OVoucher, pSL OSL
	Where OSL.Voucher=OVoucher.Voucher and OSL.Doc_No=pSL.Doc_No and OSL.Nominal=pSL.Nominal and (oSL.SortNo=0 or oSL.SortNo=pSL.SortNo)
	and OVoucher.RefNo=pSL.Voucher and OVoucher.Branch=OBranch.Branch and OVoucher.SL_Cat='B' and OVoucher.RefType='INTEROFFICE'
 ) OSL
 Where pVoucher.Voucher=Voucher.Voucher
 and Case When OSL.Account is null then pSL.Account else OSL.Account end=Budget.Account 
 and Case When OSL.Branch is null then pVoucher.Branch else OSL.Branch end=Budget.Branch
) SL 

--Not using Budget Group
Outer Apply (Select Top 1 B.GID from Budget_Entry B Where B.Year=Year(Budget.Date) and B.Branch=Budget.Branch and B.Status='P') BG
Where coalesce(BG.GID,'')=''

Group By Budget.Branch, YEAR(Budget.Date), Budget.Account   
)   
GO


insert into PatchVersioning
select '1061 Update Script - Patch 2024 (32)',GETDATE()
go
	

Declare @PrevScript varchar(100)
Declare @CurrScript varchar(100)

Select @PrevScript=''
Select @CurrSCript='1061 Update Script - Patch 2024 (32)'


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
