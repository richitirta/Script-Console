IF EXISTS ( SELECT * FROM   sysobjects WHERE  id = object_id(N'Get_GLCash_Production') and OBJECTPROPERTY(id, N'IsProcedure') = 1 )
BEGIN
DROP Procedure Get_GLCash_Production
END
GO
Create Procedure Get_GLCash_Production(@P_Branch varchar(10), @P_Month as Int, @P_Year as int)
--Declare @P_Branch as varchar(10)
--Declare @P_Month as int
--Declare @P_Year as int
--Select @P_Branch='10'
--Select @P_Month=10
--Select @P_Year=2022
as 
	Declare @P_SDate as smalldatetime
	Declare @P_Edate as smalldatetime

	Select @P_Sdate=cast(@P_Month as varchar(2))+'/01/'+cast(@P_Year as varchar(4))
	Select @P_EDate = dateadd(day,-1,dateadd(month,1,@P_SDate))


	Declare @TempPayment table (pVoucher varchar(30), nVoucher varchar(30), Subject varchar(10), A_SDate smalldatetime, A_EDate smalldatetime, PDate SmallDatetime, UWYear Int, SDate smalldatetime, EDate smalldatetime)

	--Current Payment
	insert into @TempPayment
	Select 
	pVoucher.Voucher as pVoucher, 
	nVoucher.Voucher as nVoucher, 
	Admlink.Subject, 
	coalesce(Admlink.A_SDate,'01/01/1900') as A_Sdate,
	coalesce(Admlink.A_EDate,'01/01/1900') as A_Edate,
	dateadd(day,-1,dateadd(month, 1, dateadd(day,-day(pVoucher.Date)+1,pVoucher.Date))) as PDate,
	dbo.fn_Get_UWYear(coalesce(Admlink.A_SDate,'01/01/1900'),coalesce(Admlink.A_EDate,'01/01/1900'),dateadd(day,-1,dateadd(month, 1, dateadd(day,-day(pVoucher.Date)+1,pVoucher.Date)))) as UWYear,
	dbo.fn_Get_PolicySDate(coalesce(Admlink.A_SDate,'01/01/1900'),coalesce(Admlink.A_SDate,'01/01/1900'),coalesce(Admlink.A_EDate,'01/01/1900'),dbo.fn_Get_UWYear(coalesce(Admlink.A_SDate,'01/01/1900'),coalesce(Admlink.A_EDate,'01/01/1900'),dateadd(day,-1,dateadd(month, 1, dateadd(day,-day(pVoucher.Date)+1,pVoucher.Date))))) as SDate,
	coalesce(Admlink.A_EDate,'01/01/1900') as Edate
	from pVoucher
	Inner Join pSL on (pSL.Voucher=pVoucher.Voucher)
	Inner join nVoucher on (nVoucher.Voucher=pSL.Doc_No and pSL.PaymentF=1 and nVoucher.Nominal_CC-nVoucher.Diff_CC<>0)
	Inner Join Admlink on (Admlink.Voucher=nVoucher.Voucher)
	Where pVoucher.Branch=@P_Branch and (pVoucher.Date between @P_SDate and @P_EDate)

	--Previous unrealized Payment (Premium)
	insert into @TempPayment
	Select 
	pVoucher.Voucher as pVoucher, 
	nVoucher.Voucher as nVoucher, 
	Admlink.Subject, 
	coalesce(Admlink.A_SDate,'01/01/1900') as A_Sdate,
	coalesce(Admlink.A_EDate,'01/01/1900') as A_Edate,
	dateadd(day,-1,dateadd(month, 1, dateadd(day,-day(pVoucher.Date)+1,pVoucher.Date))) as PDate,
	dbo.fn_Get_UWYear(coalesce(Admlink.A_SDate,'01/01/1900'),coalesce(Admlink.A_EDate,'01/01/1900'),dateadd(day,-1,dateadd(month, 1, dateadd(day,-day(pVoucher.Date)+1,pVoucher.Date)))) as UWYear,
	dbo.fn_Get_PolicySDate(coalesce(Admlink.A_SDate,'01/01/1900'),coalesce(Admlink.A_SDate,'01/01/1900'),coalesce(Admlink.A_EDate,'01/01/1900'),dbo.fn_Get_UWYear(coalesce(Admlink.A_SDate,'01/01/1900'),coalesce(Admlink.A_EDate,'01/01/1900'),dateadd(day,-1,dateadd(month, 1, dateadd(day,-day(pVoucher.Date)+1,pVoucher.Date))))) as SDate,
	coalesce(Admlink.A_EDate,'01/01/1900') as Edate
	from pVoucher
	Inner Join pSL on (pSL.Voucher=pVoucher.Voucher)
	Inner join nVoucher on (nVoucher.Voucher=pSL.Doc_No and pSL.PaymentF=1 and nVoucher.Nominal_CC-nVoucher.Diff_CC<>0)
	Inner Join Admlink on (Admlink.Voucher=nVoucher.Voucher and Admlink.Subject='PREMIUM')
	Where pVoucher.Branch=@P_Branch and (pVoucher.Date<@P_Sdate and coalesce(Admlink.A_EDate,'01/01/1900')>@P_EDate)

	Select *
	from
	(
		Select 
		Payment.*,
		dbo.fn_Get_PolicyEDate(Payment.SDate,Payment.SDate,Payment.Edate,dbo.fn_Get_UWYear(Payment.SDate,Payment.Edate,datediff(day,-1,@P_SDate))) as pPolicyDate,
		dbo.fn_Get_PolicyEDate(Payment.SDate,Payment.SDate,Payment.Edate,dbo.fn_Get_UWYear(Payment.SDate,Payment.Edate,@P_Edate)) as PolicyDate,
		case 
		when Subject<>'Premium' then 100
		when (A_Sdate='01/01/1900' or A_EDate='01/01/1900') Then
			Case 
				When pDate Between @P_SDate and @P_EDate then 100
			Else 
				0
			End
		When datediff(day,SDate, Edate)=0 then 100	
		Else
			cast(datediff(day,sdate, dbo.fn_Get_PolicyEDate(Payment.SDate,Payment.SDate,Payment.Edate,dbo.fn_Get_UWYear(Payment.SDate,Payment.Edate,@P_Edate))) as Float)/cast(datediff(day,SDate, Edate) as Float)*100		
			-
			Case When pDate<@P_Sdate then
				cast(datediff(day,sdate, dbo.fn_Get_PolicyEDate(Payment.SDate,Payment.SDate,Payment.Edate,dbo.fn_Get_UWYear(Payment.SDate,Payment.Edate,datediff(day,-1,@P_SDate)))) as Float)/cast(datediff(day,SDate, Edate) as Float)*100			
			Else
				0
			End 
		End
		as Prorata
		from 
		(Select Distinct * from @TempPayment) Payment
	) P
	Where P.Prorata<>0

GO
IF EXISTS ( SELECT * FROM   sysobjects WHERE  id = object_id(N'Get_GLCash') and OBJECTPROPERTY(id, N'IsProcedure') = 1 )
BEGIN
DROP Procedure Get_GLCash
END
GO
Create Procedure Get_GLCash(@P_Branch varchar(10), @P_Month as Int, @P_Year as int)
--Declare @P_Branch as varchar(10)
--Declare @P_Month as int
--Declare @P_Year as int
--Select @P_Branch='10'
--Select @P_Month=10
--Select @P_Year=2022
as 
	Declare @P_SDate as smalldatetime
	Declare @P_Edate as smalldatetime

	Select @P_Sdate=cast(@P_Month as varchar(2))+'/01/'+cast(@P_Year as varchar(4))
	Select @P_EDate = dateadd(day,-1,dateadd(month,1,@P_SDate))


	Declare @Payment table (pVoucher varchar(30), nVoucher varchar(30), Subject varchar(10), A_SDate smalldatetime, A_EDate smalldatetime, PDate SmallDatetime, UWYear Int, SDate smalldatetime, EDate smalldatetime, pPolicyDate smalldatetime, PolicyDate smalldatetime, Prorata Float)

	Insert into @Payment exec Get_GLCash_Production @P_Branch, @P_Month, @P_year

	Select @P_Branch as Branch, @P_Month as Month, @P_Year as Year, Journal.Account, Journal.Description, Journal.Currency,
	Case When sum(journal.Debit-Journal.Credit)>0 then sum(journal.Debit-Journal.Credit) else 0 end as Debit,
	Case When sum(journal.Debit-Journal.Credit)<0 then -sum(journal.Debit-Journal.Credit) else 0 end as Credit
	from
	(
		Select nVoucher.Voucher, 
		njournal.Account, 
		Account.Description, 
		nJournal.Currency,
		njournal.debit*nVoucher.PaymentPCT/100 as Debit,
		njournal.Credit*nVoucher.PaymentPCT/100 as Credit
		from 
		(
			Select 
			nVoucher.Voucher,
			sum(Case When nVoucher.DebtorF=1 then 1 else -1 end*dbo.fn_SL_Payment_Nominal(pSL.Nominal_OC, pVoucher.SL_Cat, pVoucher.DebtorF, nVoucher.DebtorF)*Payment.Prorata/100)
			/
			Max(nVoucher.Nominal_CC-nVoucher.Diff_CC)
			*100 as PaymentPCT
			from @Payment Payment
			Inner Join pSL on (pSL.Voucher=Payment.pVoucher and pSL.Doc_No=Payment.nVoucher and pSL.PaymentF=1) 
			Inner Join pVoucher on (pVoucher.Voucher=Payment.pVoucher)
			Inner Join nVoucher on (nVoucher.Voucher=Payment.nVoucher)
			Group by nVoucher.Voucher
		) nVoucher
		Inner Join nJournal on (nJournal.Voucher=nVoucher.Voucher)
		Inner join Account on (Account.Account=nJournal.Account and Account.AccGroup='N') 
		Inner Join Type on (Type.Type=Account.Type and Type.PL_Flag=1)

		union all

		Select pVoucher.Voucher, 
		pJournal.Account, 
		Account.Description, 
		pJournal.Currency,
		pJournal.debit as Debit,
		pJournal.Credit as Credit
		from 
		pVoucher 
		Inner Join pJournal on (pJournal.Voucher=pVoucher.Voucher)
		Inner join Account on (Account.Account=pJournal.Account and Account.AccGroup='N') 
		Inner Join Type on (Type.Type=Account.Type and Type.PL_Flag=1)
		Where pVoucher.Branch=@P_Branch and (pVoucher.Date between @P_SDate and @P_EDate)
	) Journal
	Group By Journal.Account, Journal.Description, Journal.Currency
	

--Examples
--Get_GLCash '10',10,2022
GO



 insert into PatchVersioning
select '486 Update Script - 29 November 2022 (2)',GETDATE()
go


Declare @PrevScript varchar(100)
Declare @CurrScript varchar(100)

Select @PrevScript=''
Select @CurrSCript='486 Update Script - 29 November 2022 (2)'


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
