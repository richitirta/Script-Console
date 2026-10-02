DROP Procedure AL_Lapse_Populating
GO
CREATE Procedure AL_Lapse_Populating(@P_PDate as smalldatetime)                                      
as                                      
Select A.A_PolicyNo, Max(A.Remarks) as Insured, Max(A.A_SDate) as A_SDate, Max(A.A_EDate) as A_EDate, Max(A.Code) as TOC, Max(A.Branch) as Branch, 
Max(A.Segment) as Segment, Min(Case When A.Type in ('DI','IC','IR') then coalesce(V1.DueDate,@P_PDate) else @P_PDate end) as DueDate,                                 
Datediff(day,Min(Case When A.Type in ('DI','IC','IR') then coalesce(V1.DueDate,@P_PDate) else @P_PDate end),@P_PDate) as Lapse, Max(A.AdmNo) as AdmNo,                                     
Min(ALRule.DaysAutoLapse) as DaysAutoLapse,                      
sum(Case When A.Type in ('DI','IC','IR','CF','JP') Then (A.Amount_1+A.Amount_11) else 0 end*V2.Rate) as Premium,                                     
sum(Case When A.Type in ('DI','IC','IR','CF','JP') Then (A.Amount_5) When A.Type in ('BO') Then A.Amount else 0 end*V2.Rate) as Discount,                                  
sum(Case When A.Type in ('IC','IR','CF','JP') Then (A.Amount_2+A.Amount_3) When A.Type in ('BB','BA') Then A.Amount else 0 end*V2.Rate) as Commission,                                  
Case When Max(A.AdmNo) in (Select AdmNo from Admlink Where AdmNo=Max(A.AdmNo) and Extra_4 in ('Cancellation')) Then 1 else 0 end as Cancellation,    
sum(Case When A.Type in ('DI') Then (A.Amount_3) else 0 end*V2.Rate) as Fee,                                  
sum(Case When A.Type in ('DI') Then (A.Amount_4) else 0 end*V2.Rate) as Duty,                                  
sum(Case When V2.DebtorF=1 Then coalesce(V1.AmountDue,V2.Nominal_CC-V2.Diff_CC) else -coalesce(V1.AmountDue,V2.Nominal_CC-V2.Diff_CC) end *V2.Rate) as AmountDue_CC,      
sum(Case When V2.DebtorF=1 Then V2.Payment_CC else -V2.Payment_CC end *V2.Rate) as Payment_CC,      

--Full Paid (Commented if Any Paid)
Case When abs(sum(Case When A.Type in ('DI','IC','IR') then 1 else 0 end*Case When V2.DebtorF=1 Then coalesce(V1.AmountDue,V2.Nominal_CC-V2.Diff_CC)-V2.Payment_CC else -coalesce(V1.AmountDue,V2.Nominal_CC-V2.Diff_CC)+V2.Payment_CC end *V2.Rate))>Max(case When V2.Currency=SysTab.Currency Then 1000 else 1 end) Then 0 else 1 end Payment_Flag      

--Any Payment (Commented if Full Paid)
--Case When sum(Case When A.Type in ('DI','IC','IR') then (Case When V2.DebtorF=1 Then V2.Payment_CC else -V2.Payment_CC end *V2.Rate) else 0 end)<>0 Then 1 else 0 end as Payment_Flag 

from Voucher V2 
Left Join VOUCHER_AMOUNTWPCDUE(@P_PDate) V1 on (V1.Voucher=V2.Voucher)
Inner Join Admlink A on (A.Voucher=V2.Voucher)
Inner Join ALRule on (ALRule.TOC=A.Code and ALRule.Branch=A.Branch and ALRule.Segment=A.Segment) 
Inner Join SysTab on (1=1)
Left Join Admlink A1 on (A1.Subject='Premium' and A1.A_PolicyNo=A.A_PolicyNO and A1.AdmNo>A.AdmNo and A1.Extra_4 in ('Cancellation'))
Left Join ALBucket on (ALBucket.A_PolicyNo=A.A_PolicyNo and ALBucket.Status not in ('C'))
Where V2.Date<=@P_PDate 
and A.Subject='Premium' and (A.Extra_1='' or A.Extra_1 is null)     --Not Data Upload                         
and A.Type in ('DI','IC','IR','CF','JP','BB','BA','BO') 
and A.ISType in ('I','L','C') --Policy Direct Only    
and A.ISType in ('I') -- Direct Business Only

-- No Installment (Commented if include Policy with Installment)
-- and A.Installment<=1  

and A.Extra_4<>'Cancellation'

and A1.A_PolicyNo is null --Not Before Cancellation


--Sum Insured Amount Less or Equal Than 5 M    
--and Exists (Select Top 1 A1.AdmNo from AccAss A1, RArrHeader R Where A1.AdmNo=A.AdmNo and R.ANO=A1.ANO and R.TAmount-R.MAmount<=5000000000)   
   
--Do not Have Facultative Placing
--and Exists (Select Top 1 A1.AdmNo from AccAss A1, RArrHeader R Where A1.AdmNo=A.AdmNo and R.ANO=A1.ANO and R.FAmount=0)      

--and A.Extra_4 in ('New','Endorsement')                            
--and A.Voucher not in (Select SL.Doc_No from SL_Request SL, Request Where Request.Request=SL.Request and Request.Status<>'C' and Request.Voucher='' and SL.PaymentF=1)                        
--and A.Voucher not in (Select C2.Voucher from CollectionH C1, CollectionV C2 Where C1.CollNo=C2.CollNo and C1.CollStatus<>'C')

Group By A.A_PolicyNo                                    
Having                                                     
(
Max(ALBucket.A_PolicyNo) is null --New Populating (Not In Bucket Yet)
and abs(sum(Case When A.Type in ('DI','IC','IR') then 1 else 0 end*Case When V2.DebtorF=1 Then coalesce(V1.AmountDue,V2.Nominal_CC-V2.Diff_CC)-V2.Payment_CC else -coalesce(V1.AmountDue,V2.Nominal_CC-V2.Diff_CC)+V2.Payment_CC end *V2.Rate))>Max(case When V2.Currency=SysTab.Currency Then 1000 else 1 end)      
and Datediff(day,Min(Case When A.Type in ('DI','IC','IR') then coalesce(V1.DueDate,@P_PDate) else @P_PDate end),@P_PDate)>=Min(ALRule.DaysAutoLapse) and Min(ALRule.DaysAutoLapse)<>0                     

--Not Any Paid (Commented if Full Paid)
--and sum(Case When A.Type in ('DI','IC','IR') then (Case When V2.DebtorF=1 Then V2.Payment_CC else -V2.Payment_CC end *V2.Rate) else 0 end)=0
)              
or                                    
--Re Populating                                    
Max(ALBucket.A_PolicyNo) is not null 
    

GO
DROP Procedure AL_Lapse_Cancellation
GO
CREATE Procedure AL_Lapse_Cancellation(@P_PDate as smalldatetime)                  
as                  
Select A.PID, A.A_PolicyNo, Max(A2.ANO) as ANO, Max(A2.CANO) as CANO         
from ALBucket A, ALRule, AccAss, Acceptance A1, Acceptance A2          
Where ALRule.TOC=A.TOC and ALRule.Branch=A.Branch and ALRule.Segment=A.Segment                 
and AccAss.AdmNo=A.AdmNo and A1.ANO=AccAss.ANO and A2.OANO=A1.OANO          
and (A.Status='N' or (A.Status='H' and datediff(day,A.PDate,@P_PDate)>=ALRule.DaysHoldLapse and ALRule.DaysHoldLapse<>0))                
Group By A.PID, A.A_PolicyNo          
Order by CANO Desc, ANO

GO
DROP Procedure AL_Lapse_Compensation
GO
CREATE Procedure AL_Lapse_Compensation(@P_PDate as smalldatetime)                  
as                  
Select ALBucket.A_PolicyNo, nVoucher.*                 
from Admlink, nVoucher, ALBucket                 
Where ALBucket.A_PolicyNo=Admlink.A_PolicyNo and nVoucher.Voucher=Admlink.Voucher and Admlink.Type in ('DI','IC','IR','CF','JP','BB','BA','BO') and Admlink.Subject='Premium'                
and ALBucket.Status in ('P')
and not Exists (Select A_PolicyNo from Admlink A Where A.A_PolicyNo=Admlink.A_PolicyNo and A.Type in ('DI','IC','IR','CF','JP','BB','BA','BO') and A.Subject='Premium' and A.Date>@P_PDate)            
Order by nVoucher.Branch, ALBucket.A_PolicyNo   
GO

DROP Procedure AL_Lapse_Compensation_In_Request
GO
CREATE Procedure AL_Lapse_Compensation_In_Request(@P_PDate as smalldatetime, @P_A_PolicyNo as varchar(50))            
as            
Select Top 1 Request.Request, Admlink.Voucher        
from Admlink, ALBucket, Request, SL_Request        
Where ALBucket.A_PolicyNo=@P_A_PolicyNo and ALBucket.A_PolicyNo=Admlink.A_PolicyNo and Admlink.Type in ('DI','IC','IR','CF','JP','BB','BA','BO') and Admlink.Subject='Premium'          
and ALBucket.Status in ('P')
and Request.Request=SL_Request.Request and Request.Status<>'C' and Request.Voucher = '' and SL_Request.Doc_No=Admlink.Voucher and SL_Request.PaymentF=1        
GO

DROP Procedure AL_Lapse_Compensation_In_Collection
GO
CREATE Procedure AL_Lapse_Compensation_In_Collection(@P_PDate as smalldatetime, @P_A_PolicyNo as varchar(50))                      
as                
Select Top 1 CollectionH.CollNo, Admlink.Voucher            
from Admlink, ALBucket, CollectionV, CollectionH            
Where ALBucket.A_PolicyNo=@P_A_PolicyNo and ALBucket.A_PolicyNo=Admlink.A_PolicyNo and Admlink.Type in ('DI','IC','IR','CF','JP','BB','BA','BO') and Admlink.Subject='Premium'              
and ALBucket.Status in ('P')
and CollectionV.CollNo=CollectionH.CollNo and CollectionH.CollStatus<>'C' and CollectionV.Voucher=Admlink.Voucher 
GO

DROP Procedure AL_Lapse_Compensation_In_Paid
GO
CREATE Procedure AL_Lapse_Compensation_In_Paid(@P_PDate as smalldatetime, @P_A_PolicyNo as varchar(50))                
as                
Select Top 1 pVoucher.Voucher as pVoucher, Admlink.Voucher            
from Admlink, ALBucket, pVoucher, pSL        
Where ALBucket.A_PolicyNo=@P_A_PolicyNo and ALBucket.A_PolicyNo=Admlink.A_PolicyNo and Admlink.Type in ('DI','IC','IR','CF','JP','BB','BA','BO') and Admlink.Subject='Premium'              
and ALBucket.Status in ('P')
and pVoucher.Voucher=pSL.Voucher and pSL.Doc_No=Admlink.Voucher and pSL.PaymentF=1        
and pVoucher.Date>=ALBucket.PDate        




