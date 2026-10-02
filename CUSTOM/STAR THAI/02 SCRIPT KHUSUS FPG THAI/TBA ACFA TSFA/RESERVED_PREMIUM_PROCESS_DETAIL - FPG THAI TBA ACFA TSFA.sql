
DROP FUNCTION RESERVED_PREMIUM_PROCESS_DETAIL
GO
CREATE FUNCTION RESERVED_PREMIUM_PROCESS_DETAIL(@P_Type varchar(2),@P_Date smalldatetime, @P_PEDate smalldatetime,@P_EDate smalldatetime)                    
RETURNS TABLE                    
AS RETURN(                    
Select Admlink.AdmNo, Acceptance.PolicyNo, Admlink.Branch, Admlink.Voucher, AccAss.SDate as A_SDate, AccAss.EDate as A_EDate, AccAss.PolicyDate, Acceptance.SDate as PSDate, Acceptance.EDate as PEDate, Admlink.ID, Admlink.Source, Admlink.DocNo, Admlink.RefNo, Admlink.Date as Date, Admlink.Code, Admlink.Type, Admlink.Currency, 'JOURNAL' as Subject, Admlink.Remarks, AccAss.Rate,                    
 'Amount_1'  = sum(case When (AccAss.Type in ('DI','IC') and Accass.Code in ('P')) or (AccAss.Type in ('CF','JP') and AccAss.Code in ('P','U')) or (Accass.Type in ('IR','IT','IX') and Accass.Code in ('P','O','U')) then-- Reserved. Gross Premium          
      Case When @P_Type='PB' then cast(-ACCASS.PREVIOUS_RESERVED as float)          
           When @P_Type='PC' then cast(ACCASS.CURRENT_RESERVED as float)          
           else cast(ACCASS.CURRENT_RESERVED-ACCASS.PREVIOUS_RESERVED as float) end                   
     else          
      cast(0 as float)          
     end),           
 'Amount_2'  = sum(case when ((AccAss.type in ('DI','IC','CF','JP') and AccAss.code in ('O')) or AccAss.Type in ('BO')) then -- Reserved. Gross Disc          
      Case When @P_Type='PB' then cast(-ACCASS.PREVIOUS_RESERVED as float)          
           When @P_Type='PC' then cast(ACCASS.CURRENT_RESERVED as float)          
           else cast(ACCASS.CURRENT_RESERVED-ACCASS.PREVIOUS_RESERVED as float) end                   
     else          
      cast(0 as float)          
     end),               
 'Amount_3'  = sum(case when AccAss.type in ('CP','DC','QS','QP', 'S1','S2','S3','AF','XP','FO') and AccAss.code in ('P','O','U') then -- Reserved. Rein Premium          
      Case When @P_Type='PB' then cast(-ACCASS.PREVIOUS_RESERVED as float)          
           When @P_Type='PC' then cast(ACCASS.CURRENT_RESERVED as float)          
           else cast(ACCASS.CURRENT_RESERVED-ACCASS.PREVIOUS_RESERVED as float) end                   
     else          
      cast(0 as float)          
     end),          
 'Amount_4'  = 0,          
 'Amount_5'  = 0,          
 'Amount_6'  = 0,     
 'Amount'  = 
	 sum(case When (AccAss.Type in ('DI','IC') and Accass.Code in ('P')) or (AccAss.Type in ('CF','JP') and AccAss.Code in ('P','U')) or (Accass.Type in ('IR','IT','IX') and Accass.Code in ('P','O','U')) then-- Reserved. Gross Premium          
      Case When @P_Type='PB' then cast(-ACCASS.PREVIOUS_RESERVED as float)          
           When @P_Type='PC' then cast(ACCASS.CURRENT_RESERVED as float)          
           else cast(ACCASS.CURRENT_RESERVED-ACCASS.PREVIOUS_RESERVED as float) end                   
     else          
      cast(0 as float)          
     end)+
     sum(case when ((AccAss.type in ('DI','IC','CF','JP') and AccAss.code in ('O')) or AccAss.Type in ('BO')) then -- Reserved. Gross Disc          
      Case When @P_Type='PB' then cast(-ACCASS.PREVIOUS_RESERVED as float)          
           When @P_Type='PC' then cast(ACCASS.CURRENT_RESERVED as float)          
           else cast(ACCASS.CURRENT_RESERVED-ACCASS.PREVIOUS_RESERVED as float) end                   
     else          
      cast(0 as float)          
     end)+ 
     sum(case when AccAss.type in ('CP','DC','QS','QP', 'S1','S2','S3','AF','XP','FO') and AccAss.code in ('P','O','U') then -- Reserved. Rein Premium          
      Case When @P_Type='PB' then cast(-ACCASS.PREVIOUS_RESERVED as float)          
           When @P_Type='PC' then cast(ACCASS.CURRENT_RESERVED as float)          
           else cast(ACCASS.CURRENT_RESERVED-ACCASS.PREVIOUS_RESERVED as float) end                   
     else          
      cast(0 as float)          
     end),
 'GROSS_PREMIUM'  = sum(case When (AccAss.Type in ('DI','IC') and Accass.Code in ('P')) or (AccAss.Type in ('CF','JP') and AccAss.Code in ('P','U')) or (Accass.Type in ('IR','IT','IX') and Accass.Code in ('P','O','U')) then-- Gross Premium
	  cast(AccAss.Amount as Float)
     else          
      cast(0 as float)          
     end),           
 'PREMIUM_DISCOUNT'  = sum(case when ((AccAss.type in ('DI','IC','CF','JP') and AccAss.code in ('O')) or AccAss.Type in ('BO')) then -- Reserved. Gross Disc          
		cast(AccAss.Amount as Float)
     else          
      cast(0 as float)          
     end),               
 'REINSURANCE_PREMIUM'  = sum(case when AccAss.type in ('CP','DC','QS','QP', 'S1','S2','S3','AF','XP','FO') and AccAss.code in ('P','O','U') then -- Reserved. Rein Premium          
		cast(AccAss.Amount as Float)
     else          
      cast(0 as float)          
     end)
from R_PREMIUM_DEFERRED_RESERVE(@P_PEDate,@P_EDate) as AccAss, Acceptance, Admlink, MParam, SysTab, TOC      
where Admlink.AdmNo=AccAss.AdmNo and Acceptance.ANO=AccAss.ANO and MParam.Type=@P_Type and TOC.TOC=Admlink.Code
and not(AccAss.Type in ('DI') and AccAss.Code in ('F','D')) --Exclude Fee and Duty    
GROUP BY Admlink.AdmNo, Acceptance.PolicyNo, Admlink.Branch, Admlink.Voucher, AccAss.SDate, AccAss.EDate, AccAss.PolicyDate, Acceptance.SDate, Acceptance.EDate, Admlink.ID, Admlink.Source, Admlink.DocNo, Admlink.RefNo, Admlink.Date, Admlink.Code, Admlink.
Type, Admlink.Currency, Admlink.Remarks, AccAss.Rate    
Union All
--Data Upload  
Select Admlink.AdmNo, Admlink.A_PolicyNo as PolicyNo, Admlink.Branch, Admlink.Voucher, Admlink.A_SDate, Admlink.A_EDate, Admlink.A_EDate as PolicyDate, Admlink.A_SDate as PSDate, Admlink.A_EDate as PEDate, Admlink.ID, Admlink.Source, Admlink.DocNo, Admlink.RefNo, Admlink.Date as Date, Admlink.Code, Admlink.Type, Admlink.Currency, 'UPLOAD' as Subject, Admlink.Remarks, nVoucher.Rate,                 
 'Amount_1'  =  sum(cast(datediff(Day, @P_EDate, Admlink.A_EDate) as float)/cast(datediff(Day, Admlink.A_SDate, Admlink.A_EDate) as float)*    
  (Case When Admlink.Type in ('DI','IC') then (Admlink.Amount_1+Admlink.Amount_11) When Admlink.Type in ('CF','JP') then (Admlink.Amount_1+Admlink.Amount_11+Admlink.Amount_20) When Admlink.Type in ('IT','IX','IR') then (Admlink.Amount_1+Admlink.Amount_5+Admlink.Amount_11+Admlink.Amount_20) else 0 end)),                          
 'Amount_2'  =  sum(cast(datediff(Day, @P_EDate, Admlink.A_EDate) as float)/cast(datediff(Day, Admlink.A_SDate, Admlink.A_EDate) as float)*               
  (Case When Admlink.Type in ('DI','IC','CF','JP') then (Admlink.Amount_5) When Admlink.Type in ('BO') then (Admlink.Amount-Admlink.Amount_14) else 0 end)),          
 'Amount_3'  =  sum(cast(datediff(Day, @P_EDate, Admlink.A_EDate) as float)/cast(datediff(Day, Admlink.A_SDate, Admlink.A_EDate) as float)*    
  (Case When Admlink.Type in ('CP','DC','QS','QP','S1','S2','S3','AF','XP','FO') then (Admlink.Amount_1+Admlink.Amount_5+Admlink.Amount_11+Admlink.Amount_20) else 0 end)),                          
 'Amount_4'  =  0,                                    
 'Amount_5'  =  0,                                      
 'Amount_6'  =  0,    
 'Amount'   =  sum(cast(datediff(Day, @P_EDate, Admlink.A_EDate) as float)/cast(datediff(Day, Admlink.A_SDate, Admlink.A_EDate) as float)*    
  (                  
  (Case When Admlink.Type in ('DI','IC') then (Admlink.Amount_1+Admlink.Amount_11) When Admlink.Type in ('CF','JP') then (Admlink.Amount_1+Admlink.Amount_11+Admlink.Amount_20) When Admlink.Type in ('IT','IX','IR') then (Admlink.Amount_1+Admlink.Amount_5+Admlink.Amount_11+Admlink.Amount_20) else 0 end)+                  
  (Case When Admlink.Type in ('DI','IC','CF','JP') then (Admlink.Amount_5) When Admlink.Type in ('BO') then (Admlink.Amount-Admlink.Amount_14) else 0 end)+    
  (Case When Admlink.Type in ('CP','DC','QS','QP','S1','S2','S3','AF','XP','FO') then (Admlink.Amount_1+Admlink.Amount_5+Admlink.Amount_11+Admlink.Amount_20) else 0 end)
  )),
 'GROSS_PREMIUM'  =  sum((Case When Admlink.Type in ('DI','IC') then (Admlink.Amount_1+Admlink.Amount_11) When Admlink.Type in ('CF','JP') then (Admlink.Amount_1+Admlink.Amount_11+Admlink.Amount_20) When Admlink.Type in ('IT','IX','IR') then (Admlink.Amount_1+Admlink.Amount_5+Admlink.Amount_11+Admlink.Amount_20) else 0 end)),                          
 'PREMIUM_DISCOUNT'  =  sum((Case When Admlink.Type in ('DI','IC','CF','JP') then (Admlink.Amount_5) When Admlink.Type in ('BO') then (Admlink.Amount-Admlink.Amount_14) else 0 end)),          
 'REINSURANCE_PREMIUM'  =  sum((Case When Admlink.Type in ('CP','DC','QS','QP','S1','S2','S3','AF','XP','FO') then (Admlink.Amount_1+Admlink.Amount_5+Admlink.Amount_11+Admlink.Amount_20) else 0 end))
from Admlink, TOC, nVoucher, Branch, SysTab, MParam                  
Where Branch.Branch=Admlink.Branch and Admlink.Date>=Branch.Start_Date    
and Admlink.Subject='Premium' and Admlink.Type in ('DI','IC','CF','IR','IT','JP','IX','CP','DC','QS','QP','S1','S2','S3','AF','XP','FO','BB','BA','BO','RP','AP')                                              
and TOC.TOC=Admlink.Code and nVoucher.Voucher=Admlink.Voucher                 
and MParam.Type=@P_Type          
and Admlink.Extra_1<>'' 
and Admlink.Date<=@P_EDate    
and (@P_EDate between Admlink.A_SDate and Admlink.A_EDate) and cast(datediff(Day, Admlink.A_SDate, Admlink.A_EDate) as float)>0    
Group By Admlink.AdmNo, Admlink.A_PolicyNo, Admlink.Branch, Admlink.Voucher, Admlink.A_SDate, Admlink.A_EDate, Admlink.ID, Admlink.Source, Admlink.DocNo, Admlink.RefNo, Admlink.Date, Admlink.Code, Admlink.Type, Admlink.Currency, Admlink.Remarks, nVoucher.
Rate    
union all  
select Cast(0 as Int) as AdmNo, '' as PolicyNo, Acclink.Branch, AccLink.Voucher, Acclink.Date as A_SDate, dateadd(day,1,Reinsurance.EDate) as A_EDate, dateadd(day,1,Reinsurance.EDate) as PolicyDate, Acclink.Date as PSDate, dateadd(day,1,Reinsurance.EDate) as PEDate, RPart.ID, RPart.ID as Source, AccLink.DocNo, AccLink.RefNo, AccLink.Date as date, AccLink.Code, 'X1' as Type, AccLink.Currency, 'JOURNAL' as Subject, MParam.Remarks, Voucher.Rate,      
Amount_1=0,            
Amount_2=0,                  
Amount_3=sum(-AccLink.Amount*coalesce(RPart.Share/100,1)*cast(datediff(day,@P_EDate,dateadd(day,1,Reinsurance.EDate)) as Float)/cast(datediff(day,Acclink.Date,dateadd(day,1,Reinsurance.EDate)) as Float)),                                
Amount_4=0,          
Amount_5=0,                  
Amount_6=0,                  
Amount=sum(-AccLink.Amount*coalesce(RPart.Share/100,1)*cast(datediff(day,@P_EDate,dateadd(day,1,Reinsurance.EDate)) as Float)/cast(datediff(day,Acclink.Date,dateadd(day,1,Reinsurance.EDate)) as Float)),
GROSS_PREMIUM=0,
PREMIUM_DISCOUNT=0,
REINSURANCE_PREMIUM=0
from AccLink inner Join Reinsurance on (Reinsurance.DocNo=AccLink.RefNo) Left Join RPart On (RPart.RNO=Reinsurance.RNO), mVoucher Voucher, MParam, SysTab, TOC        
Where Acclink.Type in ('XA')                  
and Voucher.Voucher=AccLink.Voucher and MParam.Type=@P_Type                  
and TOC.TOC=Acclink.Code           
and (@P_EDate between Acclink.Date and dateadd(day,1,Reinsurance.EDate))            
and cast(datediff(day,Acclink.Date,dateadd(day,1,Reinsurance.EDate)) as Float)>0      
Group By AccLink.Branch, AccLink.Voucher, Acclink.Date, dateadd(day,1,Reinsurance.EDate), RPart.ID, RPart.ID, AccLink.DocNo, AccLink.RefNo, AccLink.Date, Acclink.Code, AccLink.Currency, MParam.Remarks, Voucher.Rate      
)                    
GO