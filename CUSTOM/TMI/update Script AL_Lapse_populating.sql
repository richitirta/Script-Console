DROP Procedure AL_Lapse_Populating
GO
CREATE Procedure AL_Lapse_Populating(@P_PDate as smalldatetime)                                      
as                                      
Select A.A_PolicyNo, Max(A.Remarks) as Insured, Max(A_SDate) as A_SDate, Max(A_EDate) as A_EDate, Max(A.Code) as TOC, Max(A.Branch) as Branch, 
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

from SysTab, nVoucher V2 Left Join VOUCHER_AMOUNTWPCDUE(@P_PDate) V1 on (V1.Voucher=V2.Voucher), Admlink A, ALRule                                    
Where V2.Date<=@P_PDate and A.Voucher=V2.Voucher and A.Subject='Premium'     
and (A.Extra_1='' or A.Extra_1 is null)     --Not Data Upload                         
and A.Type in ('DI','IC','IR','CF','JP','BB','BA','BO') 
and A.ISType in ('I','L','C') --Policy Direct Only    
and A.ISType in ('I') -- Direct Business Only
and A.Installment=0  -- No Installmenet    

and ALRule.TOC=A.Code and ALRule.Branch=A.Branch and ALRule.Segment=A.Segment 
and not Exists (Select Top 1 AdmNo from Admlink Where Admlink.Subject='Premium' and Admlink.A_PolicyNo=A.A_PolicyNO and Admlink.AdmNo>A.AdmNo and Extra_4 in ('Cancellation'))  --After Cancellation

--Sum Insured Amount Less or Equal Than 5 M    
--and Exists (Select Top 1 A1.AdmNo from AccAss A1, RArrHeader R Where A1.AdmNo=A.AdmNo and R.ANO=A1.ANO and R.TAmount-R.MAmount<=5000000000)   
   
--Do not Have Facultative Placing
--and Exists (Select Top 1 A1.AdmNo from AccAss A1, RArrHeader R Where A1.AdmNo=A.AdmNo and R.ANO=A1.ANO and R.FAmount=0)      

--and A.Extra_4 in ('New','Endorsement')                            
--and A.Voucher not in (Select SL.Doc_No from SL_Request SL, Request Where Request.Request=SL.Request and Request.Status<>'C' and Request.Voucher='' and SL.PaymentF=1)                        
--and A.Voucher not in (Select C2.Voucher from CollectionH C1, CollectionV C2 Where C1.CollNo=C2.CollNo and C1.CollStatus<>'C')

Group By A.A_PolicyNo                                    
Having                                     
--New Populating (Not In Bucket Yet)                
(not Exists (Select A_PolicyNo from ALBucket Where ALBucket.A_PolicyNo=A.A_PolicyNo and Status not in ('C','P'))                      
and abs(sum(Case When A.Type in ('DI','IC','IR') then 1 else 0 end*Case When V2.DebtorF=1 Then coalesce(V1.AmountDue,V2.Nominal_CC-V2.Diff_CC)-V2.Payment_CC else -coalesce(V1.AmountDue,V2.Nominal_CC-V2.Diff_CC)+V2.Payment_CC end *V2.Rate))>Max(case When V2.Currency=SysTab.Currency Then 1000 else 1 end)      
and Datediff(day,Min(Case When A.Type in ('DI','IC','IR') then coalesce(V1.DueDate,@P_PDate) else @P_PDate end),@P_PDate)>=Min(ALRule.DaysAutoLapse) and Min(ALRule.DaysAutoLapse)<>0                     

--Not Any Paid (Commented if Full Paid)
and sum(Case When A.Type in ('DI','IC','IR') then (Case When V2.DebtorF=1 Then V2.Payment_CC else -V2.Payment_CC end *V2.Rate) else 0 end)=0
)              
or                                    
--Re Populating                                    
Exists (Select A_PolicyNo from ALBucket Where ALBucket.A_PolicyNo=A.A_PolicyNo and Status not in ('C','P'))                                    
    

GO