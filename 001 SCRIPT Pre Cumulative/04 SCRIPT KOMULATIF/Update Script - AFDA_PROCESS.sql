DROP FUNCTION AFDA_PROCESS
GO
CREATE FUNCTION AFDA_PROCESS(@P_Type varchar(2),@P_Date smalldatetime, @P_PEDate smalldatetime,@P_EDate smalldatetime)                            
RETURNS @ACCLINK TABLE (Branch varchar(10), DocNo varchar(50), RefNo varchar(50), Date smalldatetime, Code varchar(10), Type varchar(50), Currency varchar(10), Subject varchar(10), Remarks varchar(Max), Amount_1 Float, Amount_2 Float, Amount_3 Float, Amount_4 Float, Amount_5 FLoat, Amount Float, Rate Float, Rate_RC Float)

BEGIN  
     

Declare @P_Lapse int

Select @P_Lapse=12	-- in Months

declare @Voucher table(Voucher varchar(20), DebtorF Bit)
insert into @Voucher(Voucher, DebtorF)
Select Voucher.Voucher, Voucher.DebtorF as DebtorF
from Admlink Left Join Profile on (Profile.ID=Admlink.A_ID), nVoucher Voucher, VOUCHER_AMOUNTDUE(@P_Date) V
Where Voucher.Voucher=Admlink.Voucher and Voucher.Date<=@P_Date and ((Voucher.Nominal_CC-Voucher.Diff_CC-Voucher.Payment_CC-Voucher.Payment_OC)<>0 or Voucher.PDate>=@P_Date)
and V.Voucher=Voucher.Voucher
--Add Filter here
and datediff(Month,V.DueDate,@P_Date)>@P_Lapse
and Admlink.Type in ('DI','IC','CF','JP','IR','IT','IX')
and Admlink.Subject='Premium'
and coalesce(Profile.CGroup,'') not in ('PERTAMINA')

declare @Payment table(Voucher varchar(20), Payment_CC Float)
insert into @Payment(Voucher, Payment_CC)
Select pSL.Doc_No as Voucher, Sum(dbo.fn_SL_Payment_Nominal(pSL.Nominal_OC, pVoucher.SL_Cat, pVoucher.DebtorF, V.DebtorF)) as Payment_CC 
from pSL, pVoucher, @Voucher V 
Where pSL.PaymentF=1 and V.Voucher=pSL.Doc_No and pVoucher.Voucher=pSL.Voucher and pVoucher.Date<=@P_Date
Group By pSL.Doc_No

insert into @Acclink
select V.Branch, V.Voucher as DocNo, V.RefNo, @P_Date as Date, V.Code as Code, @P_Type as Type, SysTab.Currency, 'JOURNAL' as Subject, V.Remarks as Remarks,  
'Amount_1'= Case When V.ISType in ('I','L','C') and V.AmountDue-V.Payment_CC>0 then V.AmountDue-V.Payment_CC Else 0 end*(Case When V.DebtorF=1 Then 1 Else -1 end)*(Case When Currency.VRate=0 Then Currency.Rate Else Currency.VRate End),
'Amount_2'= Case When V.ISType Not In ('I','L','C') and V.AmountDue-V.Payment_CC>0 then V.AmountDue-V.Payment_CC Else 0 end*(Case When V.DebtorF=1 Then 1 Else -1 end)*(Case When Currency.VRate=0 Then Currency.Rate Else Currency.VRate End),
'Amount_3'=0,
'Amount_4'=0,
'Amount_5'=0,
'Amount'= Case When V.AmountDue-V.Payment_CC>0 then V.AmountDue-V.Payment_CC Else 0 end*(Case When V.DebtorF=1 Then 1 Else -1 end)*(Case When Currency.VRate=0 Then Currency.Rate Else Currency.VRate End),
0 as Rate,
0 as Rate_RC
from 
(
	Select
	V.Voucher, 
	V.DebtorF,
	A.Branch,
	A.RefNo, 
	A.Code,
	A.Remarks,
	A.ISType,
	A.Currency,
	(
	Case When Voucher.Installment=0 and datediff(Month,Voucher.DueDate,@P_Date)>@P_Lapse Then A.AMOUNT Else 0 End
	+ Case When Voucher.INSTALLMENT=1 and datediff(Month,Voucher.DueDate_1,@P_Date)>@P_Lapse Then A.AMOUNTDUE_1 Else 0 End
	+ Case When Voucher.INSTALLMENT=2 and datediff(Month,Voucher.DueDate_2,@P_Date)>@P_Lapse Then A.AMOUNTDUE_2 Else 0 End 
	+ Case When Voucher.INSTALLMENT=3 and datediff(Month,Voucher.DueDate_3,@P_Date)>@P_Lapse Then A.AMOUNTDUE_3 Else 0 End 
	+ Case When Voucher.INSTALLMENT=4 and datediff(Month,Voucher.DueDate_4,@P_Date)>@P_Lapse Then A.AMOUNTDUE_4 Else 0 End 
	+ Case When Voucher.INSTALLMENT=5 and datediff(Month,Voucher.DueDate_5,@P_Date)>@P_Lapse Then A.AMOUNTDUE_5 Else 0 End 
	+ Case When Voucher.INSTALLMENT=6 and datediff(Month,Voucher.DueDate_6,@P_Date)>@P_Lapse Then A.AMOUNTDUE_6 Else 0 End 
	+ Case When Voucher.INSTALLMENT=7 and datediff(Month,Voucher.DueDate_7,@P_Date)>@P_Lapse Then A.AMOUNTDUE_7 Else 0 End 
	+ Case When Voucher.INSTALLMENT=8 and datediff(Month,Voucher.DueDate_8,@P_Date)>@P_Lapse Then A.AMOUNTDUE_8 Else 0 End 
	+ Case When Voucher.INSTALLMENT=9 and datediff(Month,Voucher.DueDate_9,@P_Date)>@P_Lapse Then A.AMOUNTDUE_9 Else 0 End 
	+ Case When Voucher.INSTALLMENT=10 and datediff(Month,Voucher.DueDate_10,@P_Date)>@P_Lapse Then A.AMOUNTDUE_10 Else 0 End 
	+ Case When Voucher.INSTALLMENT=11 and datediff(Month,Voucher.DueDate_11,@P_Date)>@P_Lapse Then A.AMOUNTDUE_11 Else 0 End 
	+ Case When Voucher.INSTALLMENT=12 and datediff(Month,Voucher.DueDate_12,@P_Date)>@P_Lapse Then A.AMOUNTDUE_12 Else 0 End 
	+ Case When Voucher.INSTALLMENT=13 and datediff(Month,Voucher.DueDate_13,@P_Date)>@P_Lapse Then A.AMOUNTDUE_13 Else 0 End 
	+ Case When Voucher.INSTALLMENT=14 and datediff(Month,Voucher.DueDate_14,@P_Date)>@P_Lapse Then A.AMOUNTDUE_14 Else 0 End 
	+ Case When Voucher.INSTALLMENT=15 and datediff(Month,Voucher.DueDate_15,@P_Date)>@P_Lapse Then A.AMOUNTDUE_15 Else 0 End 
	+ Case When Voucher.INSTALLMENT=16 and datediff(Month,Voucher.DueDate_16,@P_Date)>@P_Lapse Then A.AMOUNTDUE_16 Else 0 End 
	+ Case When Voucher.INSTALLMENT=17 and datediff(Month,Voucher.DueDate_17,@P_Date)>@P_Lapse Then A.AMOUNTDUE_17 Else 0 End 
	+ Case When Voucher.INSTALLMENT=18 and datediff(Month,Voucher.DueDate_18,@P_Date)>@P_Lapse Then A.AMOUNTDUE_18 Else 0 End 
	+ Case When Voucher.INSTALLMENT=19 and datediff(Month,Voucher.DueDate_19,@P_Date)>@P_Lapse Then A.AMOUNTDUE_19 Else 0 End 
	+ Case When Voucher.INSTALLMENT=20 and datediff(Month,Voucher.DueDate_20,@P_Date)>@P_Lapse Then A.AMOUNTDUE_20 Else 0 End 
	+ Case When Voucher.INSTALLMENT=21 and datediff(Month,Voucher.DueDate_21,@P_Date)>@P_Lapse Then A.AMOUNTDUE_21 Else 0 End 
	+ Case When Voucher.INSTALLMENT=22 and datediff(Month,Voucher.DueDate_22,@P_Date)>@P_Lapse Then A.AMOUNTDUE_22 Else 0 End 
	+ Case When Voucher.INSTALLMENT=23 and datediff(Month,Voucher.DueDate_23,@P_Date)>@P_Lapse Then A.AMOUNTDUE_23 Else 0 End 
	+ Case When Voucher.INSTALLMENT=24 and datediff(Month,Voucher.DueDate_24,@P_Date)>@P_Lapse Then A.AMOUNTDUE_24 Else 0 End 	
	)*(Case When V.DebtorF=1 Then 1 else -1 end)
	as AmountDue,
	P.Payment_CC*(Case When V.DebtorF=1 Then 1 else -1 end) as Payment_CC 
	from @Voucher V
	Left Join @Payment P on (P.Voucher=V.Voucher)
	Inner Join nVoucher Voucher on (Voucher.Voucher=V.Voucher)
	Inner Join Admlink A on (A.Voucher=V.Voucher)
) V, fn_Exchange(dateadd(day,1,@P_Date)) Currency, SysTab
Where Currency.Currency=V.Currency
and Case When V.AmountDue-V.Payment_CC>0 then V.AmountDue-V.Payment_CC Else 0 end>0

insert into @Acclink
select A.Branch, A.DocNo, A.RefNo, @P_Date as Date, A.Code, @P_Type as Type, A.Currency, 'REVERSAL' as Subject, A.Remarks,            
 -Amount_1 as Amount_1,            
 -Amount_2 as Amount_2,            
 -Amount_3 as Amount_3,            
 -Amount_4 as Amount_4,            
 -Amount_5 as Amount_5,            
 -Amount as Amount,  
 mVoucher.Rate,
 mVoucher.Rate_RC      
from AccLink A, mVoucher          
Where A.Type='AD' and Month(A.Date)=Month(@P_PEDate) and Year(A.Date)=Year(@P_PEDate) and mVoucher.Voucher=A.Voucher       
and A.Subject<>'REVERSAL' 

Return
END

GO

