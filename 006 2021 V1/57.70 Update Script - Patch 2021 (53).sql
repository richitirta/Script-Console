IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Get_Payment_Percentage]') AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) ) 
begin
DROP FUNCTION Get_Payment_Percentage 
end
GO
CREATE Function Get_Payment_Percentage(@P_A_PolicyNo varchar(50), @P_Type varchar(10), @P_DocNO varchar(50), @P_Date smalldatetime, @P_Currency varchar(10))
RETURNS Float AS        
  
BEGIN       
Declare @PCT as Float

Declare @Admlink Table(AdmNo int, DocNo varchar(50), Date SmallDatetime, Voucher varchar(50), Amount Float, LAmount Float)

insert into @Admlink(AdmNo, DocNo, Date, Voucher, Amount, LAmount)
Select A.AdmNo, A.DocNo, A.Date, A.Voucher, A.Amount, A.LAmount
from Admlink A
Inner Join nVoucher V on (V.Voucher=A.Voucher)
Where A.Date<=@P_Date and A.A_PolicyNo=@P_A_PolicyNo and A.Currency=@P_Currency and A.Subject='Premium' and A.Type in ('DI','IC','IR')
and (substring(A.DocNo,1,50)+space(50-len(A.DocNo))+convert(varchar(50), A.Date,102))<=(substring(@P_DocNo,1,50)+space(50-len(@P_DocNo))+convert(varchar(50), @P_Date,102)) 

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
       When @P_TYPE in ('PI','PL') Then Max(V.Payment_CC*V.Rate)
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
       from @Admlink A
	   Inner Join nVoucher V on (V.Voucher=A.Voucher)
		Where (substring(A.DocNo,1,50)+space(50-len(A.DocNo))+convert(varchar(50), A.Date,102))>
		coalesce(
		(
		Select Top 1 (substring(B.DocNo,1,50)+space(50-len(B.DocNo))+convert(varchar(50), B.Date,102)) 
		from Admlink B
		Inner Join @Admlink C on (C.DocNo=B.DocNo and C.Date=B.Date)
		Where B.Date<=@P_Date and B.A_PolicyNo=@P_A_PolicyNo and B.Currency=@P_Currency and B.Subject='Premium' and B.Type=@P_Type 
		and (substring(B.DocNo,1,50)+space(50-len(B.DocNo))+convert(varchar(50), B.Date,102))<(substring(@P_DocNo,1,50)+space(50-len(@P_DocNo))+convert(varchar(50), @P_Date,102))  
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

go






