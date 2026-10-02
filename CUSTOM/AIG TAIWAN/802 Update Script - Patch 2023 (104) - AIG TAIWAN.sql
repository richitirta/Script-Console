DROP Function FN_Get_Payment_Percentage
GO
CREATE Function FN_Get_Payment_Percentage(@P_A_PolicyNo varchar(50), @P_Subject varchar(10), @P_Type varchar(10), @P_DocNO varchar(50), @P_Date smalldatetime, @P_Currency varchar(10), @P_DebtorF Bit)
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
	@PCT=sum(case When V.DebtorF=1 Then (V.Payment_CC) Else -(V.Payment_CC) end)/sum(case When V.DebtorF=1 Then (V.Nominal_CC) Else -(V.Nominal_CC) end)*100,
	@PDate=Max(V.PDate)
	from (

		   Select V.Voucher, 
		   cast(Max(Cast(V.DebtorF as Int)) as Bit) as DebtorF,
		   Max(V.PDate) as Pdate,
		   Case 
		   When @P_TYPE in ('PI','PL') Then Max((V.Payment_CC-coalesce(S.Payment_CC,0))*V.Rate)
		   When Max((V.Payment_CC-coalesce(S.Payment_CC,0))*V.Rate)<sum((case When V.DebtorF=1 Then 1 else -1 end)*(A.LAmount)*V.Rate) Then 0
		   Else Max((V.Payment_CC-coalesce(S.Payment_CC,0))*V.Rate)-sum((case When V.DebtorF=1 Then 1 else -1 end)*(A.LAmount)*V.Rate)
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
		   Outer Apply (
				Select sum(Case When nVoucher.DebtorF=1 then 1 else -1 end*dbo.fn_SL_Payment_Nominal(pSL.Nominal_OC, pVoucher.SL_Cat, pVoucher.DebtorF, nVoucher.DebtorF)) as Payment_CC
				from 
				( 
					-- OSL Function
					Select pSL.Voucher, pSL.Doc_No, pSL.Nominal_OC, 
					Case When OSL.PaymentF is null then pSL.PaymentF else OSL.PaymentF end as PaymentF, 
					Case When OSL.Account is null then pSL.Account else OSL.Account end as Account, 
					Case When OVoucher.Branch is null then pVoucher.Branch else OVoucher.Branch end as Branch, pSL.Nominator, pSL.Denominator, pSL.Rate, pSL.SortNo, pSL.pVoucher, pSL.LockedF, pSL.FundingF
					From dbo.pVoucher 
					Inner Join dbo.VType on (VType.VType=pVoucher.VType)
					Inner Join dbo.pSL on (pSL.Voucher=pVoucher.Voucher) 
					Left Join dbo.Branch OBranch on (OBranch.IO_Account=pSL.Account)
					Left Join dbo.pVoucher OVoucher on (OVoucher.RefNo=pSL.Voucher and OVoucher.Branch=OBranch.Branch and OVoucher.SL_Cat='B' and OVoucher.RefType='INTEROFFICE') 
					Left join dbo.pSL OSL on (OSL.Voucher=OVoucher.Voucher and OSL.Doc_No=pSL.Doc_No and OSL.Nominal=pSL.Nominal and (oSL.SortNo=0 or oSL.SortNo=pSL.SortNo)) 
					Where pSL.Doc_No=V.Voucher
				) pSL
				Inner Join pVoucher on (pVoucher.Voucher=pSL.Voucher)
				Inner Join VType on (VType.VType=pVoucher.VType and VType.SL_Cat='P' and VType.Code='MATCHING')
				Inner Join nVoucher on (nVoucher.Voucher=pSL.Doc_No and pSL.PaymentF=1)
				Where --Suspend Outstanding
				exists (Select Top 1 Voucher from OS_Voucher_P('') O Where O.Voucher=pVoucher.Voucher and O.Outstanding<>0)
		   ) S 
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
	Select A.AdmNo, A.DocNo, A.Date, A.Voucher, A.Amount*coalesce(V.AmountDue/(V.Nominal_CC-V.Diff_CC),1) as Amount, A.LAmount
	from Admlink A
	Left Join VOUCHER_AMOUNTDUE(@LossDate) V on (V.Voucher=A.Voucher)
	Where A.Date<=@P_Date and A.A_PolicyNo=@P_A_PolicyNo and A.Currency=@P_Currency and A.Subject='Premium' and A.Type in ('DI','IC','IR')
	and (substring(A.A_PolicyNo,1,50)+space(50-len(A.A_PolicyNo))+convert(varchar(50), A.Date,102))<=(substring(@P_A_PolicyNo,1,50)+space(50-len(@P_A_PolicyNo))+convert(varchar(50), @P_Date,102)) 
	and Round(V.Nominal_CC-V.Diff_CC,4)>0
	and coalesce(V.AmountDue, A.Amount)<>0

	Select 
	@PCT=sum(case When V.DebtorF=1 Then (V.Payment_CC) Else -(V.Payment_CC) end)/sum(case When V.DebtorF=1 Then (V.Nominal_CC) Else -(V.Nominal_CC) end)*100,
	@PDate=Max(V.PDate)
	from (

		   Select V.Voucher, 
		   cast(Max(Cast(V.DebtorF as Int)) as Bit) as DebtorF,
		   Max(V.PDate) as PDate,
		   Case 
		   When @P_TYPE in ('PI','PL') Then Max((V.Payment_CC-coalesce(S.Payment_CC,0))*V.Rate)
		   When Max((V.Payment_CC-coalesce(S.Payment_CC,0))*V.Rate)<sum((case When V.DebtorF=1 Then 1 else -1 end)*(A.LAmount)*V.Rate) Then 0
		   Else Max((V.Payment_CC-coalesce(S.Payment_CC,0))*V.Rate)-sum((case When V.DebtorF=1 Then 1 else -1 end)*(A.LAmount)*V.Rate)
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
		   Outer Apply (
				Select sum(Case When nVoucher.DebtorF=1 then 1 else -1 end*dbo.fn_SL_Payment_Nominal(pSL.Nominal_OC, pVoucher.SL_Cat, pVoucher.DebtorF, nVoucher.DebtorF)) as Payment_CC
				from 
				( 
					-- OSL Function
					Select pSL.Voucher, pSL.Doc_No, pSL.Nominal_OC, 
					Case When OSL.PaymentF is null then pSL.PaymentF else OSL.PaymentF end as PaymentF, 
					Case When OSL.Account is null then pSL.Account else OSL.Account end as Account, 
					Case When OVoucher.Branch is null then pVoucher.Branch else OVoucher.Branch end as Branch, pSL.Nominator, pSL.Denominator, pSL.Rate, pSL.SortNo, pSL.pVoucher, pSL.LockedF, pSL.FundingF
					From dbo.pVoucher 
					Inner Join dbo.VType on (VType.VType=pVoucher.VType)
					Inner Join dbo.pSL on (pSL.Voucher=pVoucher.Voucher) 
					Left Join dbo.Branch OBranch on (OBranch.IO_Account=pSL.Account)
					Left Join dbo.pVoucher OVoucher on (OVoucher.RefNo=pSL.Voucher and OVoucher.Branch=OBranch.Branch and OVoucher.SL_Cat='B' and OVoucher.RefType='INTEROFFICE') 
					Left join dbo.pSL OSL on (OSL.Voucher=OVoucher.Voucher and OSL.Doc_No=pSL.Doc_No and OSL.Nominal=pSL.Nominal and (oSL.SortNo=0 or oSL.SortNo=pSL.SortNo)) 
					Where pSL.Doc_No=V.Voucher
				) pSL
				Inner Join pVoucher on (pVoucher.Voucher=pSL.Voucher)
				Inner Join VType on (VType.VType=pVoucher.VType and VType.SL_Cat='P' and VType.Code='MATCHING')
				Inner Join nVoucher on (nVoucher.Voucher=pSL.Doc_No and pSL.PaymentF=1)
				Where --Suspend Outstanding
				exists (Select Top 1 Voucher from OS_Voucher_P('') O Where O.Voucher=pVoucher.Voucher and O.Outstanding<>0)
		   ) S 
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



DROP Function Get_Payment_Percentage
GO
CREATE Function Get_Payment_Percentage(@P_A_PolicyNo varchar(50), @P_Subject varchar(10), @P_Type varchar(10), @P_DocNO varchar(50), @P_Date smalldatetime, @P_Currency varchar(10), @P_DebtorF Bit)
RETURNS Float AS        
  
BEGIN       
Declare @PCT as Float

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
	@PCT=
	sum(case When V.DebtorF=1 Then (V.Payment_CC) Else -(V.Payment_CC) end)/sum(case When V.DebtorF=1 Then (V.Nominal_CC) Else -(V.Nominal_CC) end)*100

	from (

		   Select V.Voucher, 
		   cast(Max(Cast(V.DebtorF as Int)) as Bit) as DebtorF,
		   Case 
		   When @P_TYPE in ('PI','PL') Then Max((V.Payment_CC-coalesce(S.Payment_CC,0))*V.Rate)
		   When Max((V.Payment_CC-coalesce(S.Payment_CC,0))*V.Rate)<sum((case When V.DebtorF=1 Then 1 else -1 end)*(A.LAmount)*V.Rate) Then 0
		   Else Max((V.Payment_CC-coalesce(S.Payment_CC,0))*V.Rate)-sum((case When V.DebtorF=1 Then 1 else -1 end)*(A.LAmount)*V.Rate)
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
		   Outer Apply (
				Select sum(Case When nVoucher.DebtorF=1 then 1 else -1 end*dbo.fn_SL_Payment_Nominal(pSL.Nominal_OC, pVoucher.SL_Cat, pVoucher.DebtorF, nVoucher.DebtorF)) as Payment_CC
				from 
				( 
					-- OSL Function
					Select pSL.Voucher, pSL.Doc_No, pSL.Nominal_OC, 
					Case When OSL.PaymentF is null then pSL.PaymentF else OSL.PaymentF end as PaymentF, 
					Case When OSL.Account is null then pSL.Account else OSL.Account end as Account, 
					Case When OVoucher.Branch is null then pVoucher.Branch else OVoucher.Branch end as Branch, pSL.Nominator, pSL.Denominator, pSL.Rate, pSL.SortNo, pSL.pVoucher, pSL.LockedF, pSL.FundingF
					From dbo.pVoucher 
					Inner Join dbo.VType on (VType.VType=pVoucher.VType)
					Inner Join dbo.pSL on (pSL.Voucher=pVoucher.Voucher) 
					Left Join dbo.Branch OBranch on (OBranch.IO_Account=pSL.Account)
					Left Join dbo.pVoucher OVoucher on (OVoucher.RefNo=pSL.Voucher and OVoucher.Branch=OBranch.Branch and OVoucher.SL_Cat='B' and OVoucher.RefType='INTEROFFICE') 
					Left join dbo.pSL OSL on (OSL.Voucher=OVoucher.Voucher and OSL.Doc_No=pSL.Doc_No and OSL.Nominal=pSL.Nominal and (oSL.SortNo=0 or oSL.SortNo=pSL.SortNo)) 
					Where pSL.Doc_No=V.Voucher
				) pSL
				Inner Join pVoucher on (pVoucher.Voucher=pSL.Voucher)
				Inner Join VType on (VType.VType=pVoucher.VType and VType.SL_Cat='P' and VType.Code='MATCHING')
				Inner Join nVoucher on (nVoucher.Voucher=pSL.Doc_No and pSL.PaymentF=1)
				Where --Suspend Outstanding
				exists (Select Top 1 Voucher from OS_Voucher_P('') O Where O.Voucher=pVoucher.Voucher and O.Outstanding<>0)
		   ) S 
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
	Select A.AdmNo, A.DocNo, A.Date, A.Voucher, A.Amount*coalesce(V.AmountDue/(V.Nominal_CC-V.Diff_CC),1) as Amount, A.LAmount
	from Admlink A
	Left Join VOUCHER_AMOUNTDUE(@LossDate) V on (V.Voucher=A.Voucher)
	Where A.Date<=@P_Date and A.A_PolicyNo=@P_A_PolicyNo and A.Currency=@P_Currency and A.Subject='Premium' and A.Type in ('DI','IC','IR')
	and (substring(A.A_PolicyNo,1,50)+space(50-len(A.A_PolicyNo))+convert(varchar(50), A.Date,102))<=(substring(@P_A_PolicyNo,1,50)+space(50-len(@P_A_PolicyNo))+convert(varchar(50), @P_Date,102)) 
	and Round(V.Nominal_CC-V.Diff_CC,4)>0
	and coalesce(V.AmountDue, A.Amount)<>0

	Select 
	@PCT=
	sum(case When V.DebtorF=1 Then (V.Payment_CC) Else -(V.Payment_CC) end)/sum(case When V.DebtorF=1 Then (V.Nominal_CC) Else -(V.Nominal_CC) end)*100

	from (

		   Select V.Voucher, 
		   cast(Max(Cast(V.DebtorF as Int)) as Bit) as DebtorF,
		   Case 
		   When @P_TYPE in ('PI','PL') Then Max((V.Payment_CC-coalesce(S.Payment_CC,0))*V.Rate)
		   When Max((V.Payment_CC-coalesce(S.Payment_CC,0))*V.Rate)<sum((case When V.DebtorF=1 Then 1 else -1 end)*(A.LAmount)*V.Rate) Then 0
		   Else Max((V.Payment_CC-coalesce(S.Payment_CC,0))*V.Rate)-sum((case When V.DebtorF=1 Then 1 else -1 end)*(A.LAmount)*V.Rate)
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
		   Outer Apply (
				Select sum(Case When nVoucher.DebtorF=1 then 1 else -1 end*dbo.fn_SL_Payment_Nominal(pSL.Nominal_OC, pVoucher.SL_Cat, pVoucher.DebtorF, nVoucher.DebtorF)) as Payment_CC
				from 
				( 
					-- OSL Function
					Select pSL.Voucher, pSL.Doc_No, pSL.Nominal_OC, 
					Case When OSL.PaymentF is null then pSL.PaymentF else OSL.PaymentF end as PaymentF, 
					Case When OSL.Account is null then pSL.Account else OSL.Account end as Account, 
					Case When OVoucher.Branch is null then pVoucher.Branch else OVoucher.Branch end as Branch, pSL.Nominator, pSL.Denominator, pSL.Rate, pSL.SortNo, pSL.pVoucher, pSL.LockedF, pSL.FundingF
					From dbo.pVoucher 
					Inner Join dbo.VType on (VType.VType=pVoucher.VType)
					Inner Join dbo.pSL on (pSL.Voucher=pVoucher.Voucher) 
					Left Join dbo.Branch OBranch on (OBranch.IO_Account=pSL.Account)
					Left Join dbo.pVoucher OVoucher on (OVoucher.RefNo=pSL.Voucher and OVoucher.Branch=OBranch.Branch and OVoucher.SL_Cat='B' and OVoucher.RefType='INTEROFFICE') 
					Left join dbo.pSL OSL on (OSL.Voucher=OVoucher.Voucher and OSL.Doc_No=pSL.Doc_No and OSL.Nominal=pSL.Nominal and (oSL.SortNo=0 or oSL.SortNo=pSL.SortNo)) 
					Where pSL.Doc_No=V.Voucher
				) pSL
				Inner Join pVoucher on (pVoucher.Voucher=pSL.Voucher)
				Inner Join VType on (VType.VType=pVoucher.VType and VType.SL_Cat='P' and VType.Code='MATCHING')
				Inner Join nVoucher on (nVoucher.Voucher=pSL.Doc_No and pSL.PaymentF=1)
				Where --Suspend Outstanding
				exists (Select Top 1 Voucher from OS_Voucher_P('') O Where O.Voucher=pVoucher.Voucher and O.Outstanding<>0)
		   ) S 
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
select '802 Update Script - Patch 2023 (104) - AIG TAIWAN',GETDATE()
go


Declare @PrevScript varchar(100)
Declare @CurrScript varchar(100)

Select @PrevScript=''
Select @CurrSCript='802 Update Script - Patch 2023 (104) - AIG TAIWAN'


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








