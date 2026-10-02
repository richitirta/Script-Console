DROP FUNCTION Deferred_Reserved_Data
GO
CREATE function Deferred_Reserved_Data(@PPDate as smalldatetime, @PDate as smalldatetime)                         
RETURNS TABLE                        
AS RETURN (                        
Select                          
A3.Date,                        
A3.Branch,                        
A1.SDate as PSDate, 
A1.EDate as PEDate,
Case when A1.PDate<A2.SDate then A2.SDate else A1.PDate end as SDate,                        
Case when A1.EDate<A2.EDate then A1.EDate else A2.EDate end as EDate,                        
Case When Datediff(Month, A1.SDate, A1.EDate)<=T.DPremium Then            
 (Case When @PDate<(Case when A1.PDate<A2.SDate then A2.SDate else A1.PDate end) Then (Case when A1.PDate<A2.SDate then A2.SDate else A1.PDate end) else (Case when A1.EDate<A2.EDate then A1.EDate else A2.EDate end) end)            
else            
 (case When Dateadd(Month,(datediff(Month,A1.SDate,@PDate)/(Case When T.PTerm=0 Then 12 else T.PTerm end)+1)*(Case When T.PTerm=0 Then 12 else T.PTerm end),A1.SDate)<(Case when A1.PDate<A2.SDate then A2.SDate else A1.PDate end) then (Case when A1.PDate<A2.SDate then A2.SDate else A1.PDate end) Else (Case When Dateadd(Month,(datediff(Month,A1.SDate,@PDate)/(Case When T.PTerm=0 Then 12 else T.PTerm end)+1)*(Case When T.PTerm=0 Then 12 else T.PTerm end),A1.SDate)>(Case when A1.EDate<A2.EDate then A1.EDate else A2.EDate end) then (Case when A1.EDate<A2.EDate then A1.EDate else A2.EDate end) else Dateadd(Month,(datediff(Month,A1.SDate,@PDate)/(Case When T.PTerm=0 Then 12 else T.PTerm end)+1)*(Case When T.PTerm=0 Then 12 else T.PTerm end),A1.SDate) end) end)   
end as PolicyDate,            
Case When Datediff(Month, A1.SDate, A1.EDate)<=T.DPremium Then            
 (Case When @PPDate<(Case when A1.PDate<A2.SDate then A2.SDate else A1.PDate end) Then (Case when A1.PDate<A2.SDate then A2.SDate else A1.PDate end) else (Case when A1.EDate<A2.EDate then A1.EDate else A2.EDate end) end)            
else            
 (case When Dateadd(Month,(datediff(Month,A1.SDate,@PPDate)/(Case When T.PTerm=0 Then 12 else T.PTerm end)+1)*(Case When T.PTerm=0 Then 12 else T.PTerm end),A1.SDate)<(Case when A1.PDate<A2.SDate then A2.SDate else A1.PDate end) then (Case when A1.PDate<A2.SDate then A2.SDate else A1.PDate end) Else (Case When Dateadd(Month,(datediff(Month,A1.SDate,@PPDate)/(Case When T.PTerm=0 Then 12 else T.PTerm end)+1)*(Case When T.PTerm=0 Then 12 else T.PTerm end),A1.SDate)>(Case when A1.EDate<A2.EDate then A1.EDate 
else A2.EDate end) then (Case when A1.EDate<A2.EDate then A1.EDate else A2.EDate end) else Dateadd(Month,(datediff(Month,A1.SDate,@PPDate)/(Case When T.PTerm=0 Then 12 else T.PTerm end)+1)*(Case When T.PTerm=0 Then 12 else T.PTerm end),A1.SDate) end) end)
end as PPolicyDate,            
A2.Amount+(Case When A2.Code='C' and A3.Amount_2<>0 then A3.Amount_13/A3.Amount_2*A2.Amount else 0 end) as Amount,                  
(Case When A2.Code='C' and A3.Amount_2<>0 then A3.Amount_13/A3.Amount_2*A2.Amount else 0 end) as VATAmount,                  
A2.AdmNo,                        
A2.TOC,                        
A2.Type,                        
A2.Code,              
A2.Currency,                        
case When A1.LANO=-1 or (A1.LANO<>-1 and C1.OpenFlag=0)  or (A1.LANO=A1.ANO) then A1.PolicyNo Else A1.PolicyNo+'-'+A1.CertificateNo End as PolicyNo,                        
A1.CertificateNo,                        
A2.Remarks,                        
A2.ANO,                         
A2.RCode,                         
A2.ID,              
A2.BizMapID,                   
A3.RefNo,                       
A3.Source,                      
T.RPremium,                      
nVoucher.Rate                      
From Acceptance A1, AccAss A2, Admlink A3, Cover C1, TOC T, nVoucher, Branch          
Where A1.ANO=A2.ANO and A2.CAmount<>0    
and C1.CNO=A1.CNO and nVoucher.Voucher=A3.Voucher and Branch.Branch=A3.Branch and A3.Date>=Branch.Start_Date          
and A3.AdmNo=A2.AdmNo      
and (@PDate between A3.Date and A1.EDate or @PPDate between A3.Date and A1.EDate or (A3.Date>@PPDate and A3.Date<=@PDate))                        
and (Case when A1.PDate<A2.SDate then A2.SDate else A1.PDate end)<>(Case when A1.EDate<A2.EDate then A1.EDate else A2.EDate end)                        
and (A2.Code in ('P','O','C','U') or (A2.Type not in ('DI') and A2.Code in ('F')))             
and T.TOC=C1.TOC                      
Union All    
Select    
A3.Date,                        
A3.Branch,                   
A1.SDate as PSDate, 
A1.EDate as PEDate,     
Case when A4.PDate<A2.SDate then A2.SDate else A4.PDate end as SDate,                        
Case when A1.EDate<A2.EDate then A1.EDate else A2.EDate end as EDate,                        
Case When Datediff(Month, A1.SDate, A1.EDate)<=T.DPremium Then            
 (Case When @PDate<(Case when A4.PDate<A2.SDate then A2.SDate else A4.PDate end) Then (Case when A4.PDate<A2.SDate then A2.SDate else A4.PDate end) else (Case when A1.EDate<A2.EDate then A1.EDate else A2.EDate end) end)            
else            
 (case When Dateadd(Month,(datediff(Month,A1.SDate,@PDate)/(Case When T.PTerm=0 Then 12 else T.PTerm end)+1)*(Case When T.PTerm=0 Then 12 else T.PTerm end),A1.SDate)<(Case when A4.PDate<A2.SDate then A2.SDate else A4.PDate end) then (Case when A4.PDate<A2.SDate then A2.SDate else A4.PDate end) Else (Case When Dateadd(Month,(datediff(Month,A1.SDate,@PDate)/(Case When T.PTerm=0 Then 12 else T.PTerm end)+1)*(Case When T.PTerm=0 Then 12 else T.PTerm end),A1.SDate)>(Case when A1.EDate<A2.EDate then A1.EDate else A2.EDate end) then (Case when A1.EDate<A2.EDate then A1.EDate else A2.EDate end) else Dateadd(Month,(datediff(Month,A1.SDate,@PDate)/(Case When T.PTerm=0 Then 12 else T.PTerm end)+1)*(Case When T.PTerm=0 Then 12 else T.PTerm end),A1.SDate) end) end)   
end as PolicyDate,            
Case When Datediff(Month, A1.SDate, A1.EDate)<=T.DPremium Then            
 (Case When @PPDate<(Case when A4.PDate<A2.SDate then A2.SDate else A4.PDate end) Then (Case when A4.PDate<A2.SDate then A2.SDate else A4.PDate end) else (Case when A1.EDate<A2.EDate then A1.EDate else A2.EDate end) end)            
else            
 (case When Dateadd(Month,(datediff(Month,A1.SDate,@PPDate)/(Case When T.PTerm=0 Then 12 else T.PTerm end)+1)*(Case When T.PTerm=0 Then 12 else T.PTerm end),A1.SDate)<(Case when A4.PDate<A2.SDate then A2.SDate else A4.PDate end) then (Case when A4.PDate<A2.SDate then A2.SDate else A4.PDate end) Else (Case When Dateadd(Month,(datediff(Month,A1.SDate,@PPDate)/(Case When T.PTerm=0 Then 12 else T.PTerm end)+1)*(Case When T.PTerm=0 Then 12 else T.PTerm end),A1.SDate)>(Case when A1.EDate<A2.EDate then A1.EDate 
else A2.EDate end) then (Case when A1.EDate<A2.EDate then A1.EDate else A2.EDate end) else Dateadd(Month,(datediff(Month,A1.SDate,@PPDate)/(Case When T.PTerm=0 Then 12 else T.PTerm end)+1)*(Case When T.PTerm=0 Then 12 else T.PTerm end),A1.SDate) end) end)
end as PPolicyDate,            
A2.Amount+(Case When A2.Code='C' and A3.Amount_2<>0 then A3.Amount_13/A3.Amount_2*A2.Amount else 0 end) as Amount,                  
(Case When A2.Code='C' and A3.Amount_2<>0 then A3.Amount_13/A3.Amount_2*A2.Amount else 0 end) as VATAmount,                  
A2.AdmNo,                        
A2.TOC,                        
A2.Type,                        
A2.Code,
A2.Currency,                        
case When A1.LANO=-1 or (A1.LANO<>-1 and C1.OpenFlag=0)  or (A1.LANO=A1.ANO) then A1.PolicyNo Else A1.PolicyNo+'-'+A1.CertificateNo End as PolicyNo,                        
A1.CertificateNo,                        
A2.Remarks,                        
A2.ANO,                         
A2.RCode,                         
A2.ID,              
A2.BizMapID,                   
A3.RefNo,                       
A3.Source,                      
T.RPremium,                      
nVoucher.Rate                      
From Acceptance A1, AccAss A2, Admlink A3, Acceptance A4, Cover C1, TOC T, nVoucher, Branch          
Where A4.ANO=A2.ANO     
and A1.ANO=A4.PANO and A2.CAmount=0    
and C1.CNO=A1.CNO and nVoucher.Voucher=A3.Voucher and Branch.Branch=A3.Branch and A3.Date>=Branch.Start_Date          
and A3.AdmNo=A2.AdmNo                         
and (@PDate between A3.Date and A1.EDate or @PPDate between A3.Date and A1.EDate or (A3.Date>@PPDate and A3.Date<=@PDate))                        
and (Case when A4.PDate<A2.SDate then A2.SDate else A4.PDate end)<>(Case when A1.EDate<A2.EDate then A1.EDate else A2.EDate end)                        
and (A2.Code in ('P','O','C','U') or (A2.Type not in ('DI') and A2.Code in ('F')))             
and T.TOC=C1.TOC                      
)                      
GO

DROP FUNCTION R_PREMIUM_DEFERRED_RESERVE
GO
CREATE Function R_PREMIUM_DEFERRED_RESERVE( @P_PEDATE as smalldatetime, @P_EDate as  smalldatetime)        
RETURNS Table        
AS RETURN (        
Select d.AdmNo, d.ANO, d.Branch, d.TOC, d.PolicyNo, d.Remarks, d.Date, d.SDate, d.EDate, d.PolicyDate, d.pPolicyDate, d.Type, d.Code, d.RCode, d.ID, d.RefNo, d.Source, d.BizMapID, d.Currency            
, Max(Rate) as Rate          
, SUM(Amount) as Amount          
, SUM(VATAmount) as VATAmount     
, SUM(Previous_Deferred) as Previous_Deferred, SUM(Previous_Realized) as Previous_Realized, SUM(Previous_Reserved) as Previous_Reserved          
, SUM(Current_Deferred) as Current_Deferred, SUM(Current_Realized) as Current_Realized, SUM(Current_Reserved) as Current_Reserved          
from (
	--Before 01 July 2018
	--For Non(TA and MC) Business and TA for more than 180 days
	Select AdmNo, ANO, Branch, d.TOC, PolicyNo, Remarks, Date, SDate,EDate, PolicyDate, pPolicyDate, Type, Code, RCode, Currency, ID, RefNo, Source, BizMapID, Amount, VATAmount, Rate,            
	0 as Previous_Deferred,        
	Case 
	When @P_PEDate >=d.Date then   
	 Amount  
	else 0 
	end as Previous_Realized,            
	Case   
	When @P_PEDate >=d.Date then   
	 cast(datediff(day,Case When @P_PEDate<SDate Then SDate else (Case When @P_PEDate>EDate Then EDate else @P_PEDate end) end, edate) as float)/cast(datediff(day,sdate,edate) as float)*Amount  
	else 0 
	end as Previous_Reserved,        
	0 as Current_Deferred,        
	Case   
	When @P_EDate >=d.Date then   
	 Amount  
	else 0 
	end as Current_Realized,                 
	Case   
	When @P_EDate >=d.Date then   
	 cast(datediff(day,Case When @P_EDate<SDate Then SDate else (Case When @P_EDate>EDate Then EDate else @P_EDate end) end, edate) as float)/cast(datediff(day,sdate,edate) as float)*Amount  
	else 0 end as Current_Reserved  
	from deferred_Reserved_Data(@P_PEDATE, @P_EDATE) d, TOC
	Where d.TOC=TOC.TOC and datediff(Month,SDate,EDate)>0 and (TOC.COB not in (22, 45) or (TOC.COB=45 and datediff(day,SDate,EDate)>180))
		and @P_EDate<'07/01/2018'
	UNION ALL
	--For MC Business and TA for less than 180 days 
	Select AdmNo, ANO, Branch, d.TOC, PolicyNo, Remarks, Date, SDate,EDate, PolicyDate, pPolicyDate, Type, Code, RCode, Currency, ID, RefNo, Source, BizMapID, Amount, VATAmount, Rate,            
	0 as Previous_Deferred,        
	Case 
	When @P_PEDate >=d.Date then   
	 Amount  
	else 0 
	end as Previous_Realized,            
	Case   
	When @P_PEDate >=d.Date and Year(@P_PEDate)*12+Month(@P_PEDate)<Year(EDate)*12+Month(EDate) then   
	 Amount  
	else 0 
	end as Previous_Reserved,        
	0 as Current_Deferred,        
	Case   
	When @P_EDate >=d.Date then   
	 Amount  
	else 0 
	end as Current_Realized,                 
	Case   
	When @P_EDate >=d.Date and Year(@P_EDate)*12+Month(@P_EDate)<Year(EDate)*12+Month(EDate) then   
	 Amount  
	else 0 end as Current_Reserved  
	from deferred_Reserved_Data(@P_PEDATE, @P_EDATE) d, TOC
	Where d.TOC=TOC.TOC and datediff(Month,SDate,EDate)>0 and not (TOC.COB not in (22, 45) or (TOC.COB=45 and datediff(day,SDate,EDate)>180))
		and @P_EDate<'07/01/2018'
	UNION ALL
	--After 01 July 2018
	--For Non(TA and MC) Business and (TA or MC) that more than 180 days
	Select AdmNo, ANO, Branch, d.TOC, PolicyNo, Remarks, Date, SDate,EDate, PolicyDate, pPolicyDate, Type, Code, RCode, Currency, ID, RefNo, Source, BizMapID, Amount, VATAmount, Rate,            
	0 as Previous_Deferred,        
	Case 
	When @P_PEDate >=d.Date then   
	 Amount  
	else 0 
	end as Previous_Realized,            
	Case   
	When @P_PEDate >=d.Date then   
	 cast(datediff(day,Case When @P_PEDate<SDate Then SDate else (Case When @P_PEDate>EDate Then EDate else @P_PEDate end) end, edate) as float)/cast(datediff(day,sdate,edate) as float)*Amount  
	else 0 
	end as Previous_Reserved,        
	0 as Current_Deferred,        
	Case   
	When @P_EDate >=d.Date then   
	 Amount  
	else 0 
	end as Current_Realized,                 
	Case   
	When @P_EDate >=d.Date then   
	 cast(datediff(day,Case When @P_EDate<SDate Then SDate else (Case When @P_EDate>EDate Then EDate else @P_EDate end) end, edate) as float)/cast(datediff(day,sdate,edate) as float)*Amount  
	else 0 end as Current_Reserved  
	from deferred_Reserved_Data(@P_PEDATE, @P_EDATE) d, TOC
	Where d.TOC=TOC.TOC and datediff(Month,SDate,EDate)>0 and (TOC.COB not in (22, 45) or (datediff(day,SDate,EDate)>180))
		and @P_EDate>='07/01/2018'
	UNION ALL
	--For MC Business and TA that less than or equal to 180 days 
	Select AdmNo, ANO, Branch, d.TOC, PolicyNo, Remarks, Date, SDate,EDate, PolicyDate, pPolicyDate, Type, Code, RCode, Currency, ID, RefNo, Source, BizMapID, Amount, VATAmount, Rate,            
	0 as Previous_Deferred,        
	Case 
	When @P_PEDate >=d.Date then   
	 Amount  
	else 0 
	end as Previous_Realized,            
	Case   
	When @P_PEDate >=d.Date and Year(@P_PEDate)*12+Month(@P_PEDate)<Year(EDate)*12+Month(EDate) then   
	 Amount  
	else 0 
	end as Previous_Reserved,        
	0 as Current_Deferred,        
	Case   
	When @P_EDate >=d.Date then   
	 Amount  
	else 0 
	end as Current_Realized,                 
	Case   
	When @P_EDate >=d.Date and Year(@P_EDate)*12+Month(@P_EDate)<Year(EDate)*12+Month(EDate) then   
	 Amount  
	else 0 end as Current_Reserved  
	from deferred_Reserved_Data(@P_PEDATE, @P_EDATE) d, TOC
	Where d.TOC=TOC.TOC and datediff(Month,SDate,EDate)>0 and not (TOC.COB not in (22, 45) or (datediff(day,SDate,EDate)>180))
		and @P_EDate>='07/01/2018'
) d          
Group by d.AdmNo, d.ANO, d.Branch, d.TOC, d.PolicyNo, d.Remarks, d.Date, d.SDate, d.EDate, d.PolicyDate, d.pPolicyDate, d.Type, d.Code, d.RCode, d.ID, d.RefNo, d.Source, d.BizMapID, d.Currency         
)
GO