DROP function fn_SL_Request_BudgetEntry
GO
Create function fn_SL_Request_BudgetEntry(@P_Request as varchar(20))   
RETURNS TABLE   
AS RETURN   
(   
Select   
Budget.Branch,   
Budget.CT,
Budget.Year,   
Budget.GID, 
Budget.ID, 
Budget.Account,   
MAX(Budget.Budget) as Budget,   
MAX(Budget.Actual)   
+ coalesce(sum(Case When SL.Status in ('R','V','P') Then (Case When SL.DebtorF=1 Then -SL.Nominal*SL.Rate else SL.Nominal*SL.Rate end) else 0 end),0)   
- Case When MAX(Budget.Status) in ('U','P') then MAX(Budget.Nominal) else 0 end   
as Actual,   
MAX(Budget.Nominal) as Nominal   
from   
(   
	Select 
	(Case When pSL.Branch<>'' Then pSL.Branch else Request.Branch end) as Branch, 
	(Case When pSL.CT<>'' Then pSL.CT else Request.CT end) as CT,
	Year(Request.Date) as Year, 
	B.GID, B.ID, pSL.Account,   
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
	--inner join Type on (Type.Type=Account.Type and Type.PL_Flag=1)   
	--also Balance Sheet Account
	inner join Type on (Type.Type=Account.Type)   
	Left Join pVoucher on (pVoucher.Voucher=Request.Voucher and YEAR(pVoucher.Date)=YEAR(Request.Date) and Month(pVoucher.Date)>=Month(Request.Date))
	Inner Join Budget_AccountDetail B on (B.GID=pSL.GID and (B.Account_DR=pSL.Account or B.Account_Cr=pSL.Account))   
	Inner join Budget_Entry Budget on (Budget.Branch=(Case When pSL.Branch<>'' Then pSL.Branch else Request.Branch end) and Budget.CT=(Case When pSL.CT<>'' Then pSL.CT else Request.CT end) and Budget.Year=Year(Request.Date) and Budget.GID=B.GID and Budget.ID=B.ID and Budget.Status='P')   
	Where Request.Request=@P_Request   
	Group by (Case When pSL.Branch<>'' Then pSL.Branch else Request.Branch end), (Case When pSL.CT<>'' Then pSL.CT else Request.CT end), Year(Request.Date), B.GID, B.ID, pSL.Account   
) Budget   
Left join   
(   
	Select Request.Status, Request.Rate, Request.DebtorF, pSL.Nominal, 
	(Case When pSL.Branch<>'' Then pSL.Branch else Request.Branch end) as Branch,
	(Case When pSL.CT<>'' Then pSL.CT else Request.CT end) as CT,
	Year(Request.Date) as Year, 
	B.GID, B.ID, pSL.Account
	From Request
	inner join SL_Request pSL on (pSL.Request=Request.Request)   
	Inner Join Request Budget_Request on (Budget_Request.Request=@P_Request)
	Left Join pVoucher on (pVoucher.Voucher=Request.Voucher and YEAR(pVoucher.Date)=YEAR(Request.Date) and Month(pVoucher.Date)>=Month(Request.Date))
	Inner Join Budget_AccountDetail B on (B.GID=pSL.GID and (B.Account_DR=pSL.Account or B.Account_Cr=pSL.Account))   
	Inner join Budget_Entry Budget on (Budget.Branch=(Case When pSL.Branch<>'' Then pSL.Branch else Request.Branch end) and Budget.CT=(Case When pSL.CT<>'' Then pSL.CT else Request.CT end) and Budget.Year=Year(Request.Date) and Budget.GID=B.GID and Budget.ID=B.ID and Budget.Status='P')   
	Where Request.request<>Budget_Request.request and Request.SL_Cat='P' 
	and coalesce(pVoucher.Status,'') not in ('U','P')
	and YEAR(Request.Date)=YEAR(Budget_Request.Date) and Month(Request.Date)<=Month(Budget_Request.Date) 
) SL on (SL.Branch=Budget.Branch and SL.CT=Budget.CT and SL.Year=Budget.Year and SL.GID=Budget.GID and SL.ID=Budget.ID and SL.Account=Budget.Account)   
Group By Budget.Branch, Budget.CT, Budget.Year, Budget.GID, Budget.ID, Budget.Account 
)   
go




 insert into PatchVersioning	
select '561 Update Script - Patch 2023 (13)',GETDATE()
go





Declare @PrevScript varchar(100)
Declare @CurrScript varchar(100)

Select @PrevScript=''
Select @CurrSCript='561 Update Script - Patch 2023 (13)'


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
