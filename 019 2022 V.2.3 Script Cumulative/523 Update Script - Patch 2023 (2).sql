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
		   When @P_TYPE in ('PI','PL') Then Max((V.Payment_CC)*V.Rate)
		   When Max((V.Payment_CC)*V.Rate)<sum((case When V.DebtorF=1 Then 1 else -1 end)*(A.LAmount)*V.Rate) Then 0
		   Else Max((V.Payment_CC)*V.Rate)-sum((case When V.DebtorF=1 Then 1 else -1 end)*(A.LAmount)*V.Rate)
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
		   When @P_TYPE in ('PI','PL') Then Max((V.Payment_CC)*V.Rate)
		   When Max((V.Payment_CC)*V.Rate)<sum((case When V.DebtorF=1 Then 1 else -1 end)*(A.LAmount)*V.Rate) Then 0
		   Else Max((V.Payment_CC)*V.Rate)-sum((case When V.DebtorF=1 Then 1 else -1 end)*(A.LAmount)*V.Rate)
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


go




 insert into PatchVersioning
select '523 Update Script - Patch 2023 (2)',GETDATE()
go





Declare @PrevScript varchar(100)
Declare @CurrScript varchar(100)

Select @PrevScript=''
Select @CurrSCript='523 Update Script - Patch 2023 (2)'


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




