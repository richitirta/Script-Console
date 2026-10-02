
insert into PatchVersioning
select '56.12  Update Patch - Patch 2020 (66)',GETDATE()
go

Declare @PrevScript varchar(100)
Declare @CurrScript varchar(100)

Select @PrevScript='56.11 Update Patch - Patch 2020 (63)'
Select @CurrSCript='56.12  Update Patch - Patch 2020 (66)'


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
			DROP Function Get_Payment_Percentage
       END TRY  
       BEGIN CATCH  
       END CATCH;


       Update SysTab Set ExecScript=@CurrScript, ExecScriptStatus='DONE'         
End


GO
CREATE Function Get_Payment_Percentage(@P_A_PolicyNo varchar(50), @P_Type varchar(10), @P_DocNO varchar(50), @P_Date smalldatetime, @P_Currency varchar(10))
RETURNS Float AS        
  
BEGIN       
Declare @PCT as Float

Select 
@PCT=
sum(case When V.DebtorF=1 Then (V.Payment_CC) Else -(V.Payment_CC) end)/sum(case When V.DebtorF=1 Then (V.Nominal_CC) Else -(V.Nominal_CC) end)*100

from (

       Select V.Voucher, 
       cast(Max(Cast(V.DebtorF as Int)) as Bit) as DebtorF,
       Case 
       When @P_TYPE in ('PI','PL') Then Max(V.Payment_CC)
       When Max(V.Payment_CC*V.Rate)<sum((case When V.DebtorF=1 Then 1 else -1 end)*(A.LAmount)*V.Rate) Then 0
       Else Max(V.Payment_CC*V.Rate)-sum((case When V.DebtorF=1 Then 1 else -1 end)*(A.LAmount)*V.Rate)
       End as Payment_CC,

       sum(
              (case When V.DebtorF=1 Then 1 else -1 end)*
              Case
              When @P_Type in ('PI','PL') then (A.Amount)
              Else (A.Amount-A.LAmount)
              End*V.Rate
       ) as Nominal_CC
       from nVoucher V, Admlink A
		Where A.Voucher=V.Voucher
		and A.Date<=@P_Date and A.A_PolicyNo=@P_A_PolicyNo and A.Currency=@P_Currency
		and A.Subject='Premium' and A.Type in ('DI','IC','IR')
		and (substring(A.DocNo,1,50)+space(50-len(A.DocNo))+convert(varchar(50), A.Date,102))<=(substring(@P_DocNo,1,50)+space(50-len(@P_DocNo))+convert(varchar(50), @P_Date,102)) 

		and (substring(A.DocNo,1,50)+space(50-len(A.DocNo))+convert(varchar(50), A.Date,102))>
		coalesce(
		(
		Select Top 1 (substring(B.DocNo,1,50)+space(50-len(B.DocNo))+convert(varchar(50), B.Date,102)) 
		from Admlink B, Admlink C
		Where B.Date<=@P_Date and B.A_PolicyNo=@P_A_PolicyNo and B.Currency=@P_Currency
		and (substring(B.DocNo,1,50)+space(50-len(B.DocNo))+convert(varchar(50), B.Date,102))<(substring(@P_DocNo,1,50)+space(50-len(@P_DocNo))+convert(varchar(50), @P_Date,102))  
		and B.Subject='Premium' and B.Type=@P_Type 
		and C.Subject='Premium' and C.Type in ('DI','IC','IR') and C.A_PolicyNo=B.A_PolicyNo and C.DocNo=B.DocNO and C.Date=B.Date
		order by B.AdmNo Desc
		),'')
       Group By V.Voucher
) V

Having sum(case When V.DebtorF=1 Then (V.Nominal_CC) Else -(V.Nominal_CC) end)<>0

if @PCT IS NULL 
       SELECT @PCT=100

if @PCT<0
       SELECT @PCT=0

if @PCT>100
       SELECT @PCT=100

Return @PCT
End




