DROP Procedure AL_Lapse_Populating
GO
CREATE Procedure AL_Lapse_Populating(@P_PDate as smalldatetime)                                        
as                                  

Declare @Admlink Table (A_PolicyNO varchar(50), DueDate Smalldatetime, DaysAutoLapse SmallInt, MinAdmNo Int, MaxAdmNo int)

insert into @Admlink

Select top 100 A.A_PolicyNo, 
Min(case When V.Installment<>0 Then V.DueDate_1 else dateadd(day,A.WPC, V.DueDate) end) as DueDate,
Min(ALRule.DaysAutoLapse) as DaysAutoLapse, min(A.AdmNo) as MinAdmNo, Max(A.AdmNo) as MaxAdmNo
From Admlink A
Inner Join nVoucher V on (V.Voucher=a.Voucher)
Inner join sysTab on (1=1)
Left Join Admlink A1 on (A1.A_PolicyNo=A.A_PolicyNo and A1.Currency=A.Currency and A1.Subject=A.Subject and A1.Type=A.Type and A1.AdmNo>A.AdmNo and A1.Extra_4 in ('Cancel All','Cancellation'))  
Left Join ALBucket on (ALBucket.A_PolicyNo=A.A_PolicyNo and ALBucket.Status not in ('C','P'))  
Inner join ALRule on (ALRule.TOC=A.Code and (ALRule.Branch='<All>' or (ALRule.Branch=A.Branch)) and (ALRule.Segment='<All>' or (ALRule.Segment=A.Segment)) and (ALRule.Source='<All>' or (ALRule.Source=A.Source)))
Where A.A_SDate>='01/01/2017' and A.Date<=@P_PDate  
and A.Subject='Premium' and A.Extra_1=''    --Not Data Upload                           
and A.Type in ('DI','IC','IR')   
and A.ISType in ('I') -- Direct Business Only  

-- No Installment (Commented if include Policy with Installment)  
-- and A.Installment<=1    
  
and A.Extra_4 not in ('Cancel All','Cancellation')
  
and A1.A_PolicyNo is null --Not Before Cancellation  
  
--Sum Insured Amount Less or Equal Than 5 M      
--and Exists (Select Top 1 A1.AdmNo from AccAss A1, RArrHeader R Where A1.AdmNo=A.AdmNo and R.ANO=A1.ANO and R.TAmount-R.MAmount<=5000000000)     
     
--Do not Have Facultative Placing  
and Exists (Select Top 1 A1.AdmNo from AccAss A1, RArrHeader R Where A1.AdmNo=A.AdmNo and R.ANO=A1.ANO and R.FAmount=0)        
  
--and A.Extra_4 in ('New','Endorsement')                              
--and A.Voucher not in (Select SL.Doc_No from SL_Request SL, Request Where Request.Request=SL.Request and Request.Status<>'C' and Request.Voucher='' and SL.PaymentF=1)                          
--and A.Voucher not in (Select C2.Voucher from CollectionH C1, CollectionV C2 Where C1.CollNo=C2.CollNo and C1.CollStatus<>'C')    

Group By A.A_PolicyNo                                      
Having                                                       
(  
Max(ALBucket.A_PolicyNo) is null --New Populating (Not In Bucket Yet)  

and abs(sum(Case When V.DebtorF=1 Then (case When V.Installment<>0 Then V.AmountDue_1 else V.Nominal_CC-V.Payment_CC end-V.Payment_CC) else -(case When V.Installment<>0 Then V.AmountDue_1 else V.Nominal_CC-V.Payment_CC end-V.Payment_CC) End*V.Rate))>Max(case When V.Currency=SysTab.Currency Then 1000 else 1 end)
and Datediff(day,Min(case When V.Installment<>0 Then V.DueDate_1 else dateadd(day,A.WPC, V.DueDate) end),@P_PDate)>=Min(ALRule.DaysAutoLapse) and Min(ALRule.DaysAutoLapse)<>0                       
  
--Not Any Paid (Commented if Full Paid)  
and sum(Case When V.DebtorF=1 Then V.Payment_CC else -V.Payment_CC end*V.Rate)=0  
)                
or                                      
--Re Populating                                      
Max(ALBucket.A_PolicyNo) is not null
      
      
Select A.A_PolicyNo, Max(A.DocNo) as DocNo, Max(A.Type) as Type, Max(A.Currency) as Currency, Max(A.Remarks) as Insured, Max(A.A_SDate) as A_SDate, Max(A.A_EDate) as A_EDate, Max(A.Code) as TOC, Max(A.Branch) as Branch, Max(A.Source) as Source,  
Max(A.Segment) as Segment, Min(Case When A.Type in ('DI','IC','IR') then coalesce(Admlink.DueDate,@P_PDate) else @P_PDate end) as DueDate,                                   
Datediff(day,Min(Case When A.Type in ('DI','IC','IR') then coalesce(Admlink.DueDate,@P_PDate) else @P_PDate end),@P_PDate) as Lapse, Max(A.AdmNo) as AdmNo,                                       
Min(Admlink.DaysAutoLapse) as DaysAutoLapse,                        
sum(Case When A.Type in ('DI','IC','IR','CF','JP') Then (A.Amount_1+A.Amount_11) else 0 end*V2.Rate) as Premium,                                       
sum(Case When A.Type in ('DI','IC','IR','CF','JP') Then (A.Amount_5) When A.Type in ('BO') Then A.Amount else 0 end*V2.Rate) as Discount,                                    
sum(Case When A.Type in ('IC','IR','CF','JP') Then (A.Amount_2+A.Amount_3) When A.Type in ('BB','BA','BC','BP','BD') Then A.Amount else 0 end*V2.Rate) as Commission,                                    
Case When Max(A.AdmNo) in (Select AdmNo from Admlink Where AdmNo=Max(A.AdmNo) and Extra_4 in ('Cancel All','Cancellation')) Then 1 else 0 end as Cancellation,      
sum(Case When A.Type in ('DI') Then (A.Amount_3) else 0 end*V2.Rate) as Fee,                                    
sum(Case When A.Type in ('DI') Then (A.Amount_4) else 0 end*V2.Rate) as Duty,                                    
sum(Case When V2.DebtorF=1 Then V2.Payment_CC else -V2.Payment_CC end *V2.Rate) as Payment_CC,        
  
--Full Paid (Commented if Any Paid)  
--Case When abs(sum(Case When A.Type in ('DI','IC','IR') then 1 else 0 end*Case When V2.DebtorF=1 Then coalesce(V1.AmountDue,V2.Nominal_CC-V2.Diff_CC)-V2.Payment_CC else -coalesce(V1.AmountDue,V2.Nominal_CC-V2.Diff_CC)+V2.Payment_CC end *V2.Rate))>Max(case When V2.Currency=SysTab.Currency Then 1000 else 1 end) Then 0 else 1 end Payment_Flag,  
  
--Any Payment (Commented if Full Paid)  
Case When sum(Case When A.Type in ('DI','IC','IR') then (Case When V2.DebtorF=1 Then V2.Payment_CC else -V2.Payment_CC end *V2.Rate) else 0 end)<>0 Then 1 else 0 end as Payment_Flag,  
  
--Cancellation by Prorate  
--0 as CPCT,  
  
--if Prorate Cancellation Percentage   
--1 as CPCT,  
'N' as Status  
from @Admlink Admlink
Inner Join Admlink A on (A.A_PolicyNo=Admlink.A_PolicyNo and A.A_SDate>='01/01/2017' and A.Date<=@P_PDate and A.Subject='Premium' and A.Extra_1='' and A.Type in ('DI','IC','IR','CF','JP','BB','BA','BC','BP','BD','BO'))  
Inner join nVoucher V2 on (V2.Voucher=A.Voucher)  
Group By A.A_PolicyNo                                      
go


 insert into PatchVersioning	
select '566 Update Script - AutoLapse (Tuning Version)',GETDATE()
go





Declare @PrevScript varchar(100)
Declare @CurrScript varchar(100)

Select @PrevScript=''
Select @CurrSCript='566 Update Script - AutoLapse (Tuning Version)'


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



