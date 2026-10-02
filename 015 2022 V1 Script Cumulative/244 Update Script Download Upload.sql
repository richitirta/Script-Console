
if exists (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'DISPLAY_PERIODPREMI') AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) )
BEGIN  
DROP FUNCTION DISPLAY_PERIODPREMI
end
go
CREATE FUNCTION DISPLAY_PERIODPREMI(@P_ANO int, @P_YEAR int)      
Returns VARCHAR(max)              
As      
BEGIN    
DECLARE @val AS varchar(Max)
declare @DispCoverage Table (Coverage varchar(Max))

insert into @DispCoverage
Select Cast(Ratetab.description +' : '+ D1.Currency +   ' ' +  
convert(varchar(255),D1.Calculation) as varchar(Max)) +   ' (' +  
 CONVERT(VARCHAR(255), D1.Sdate, 103) +   ' - ' +  CONVERT(VARCHAR(255), D1.edate, 103) +' )'   
     As Coverage 
From Acceptance 
INNER JOIN DISPLAY_CALCULATION(@P_ANO) D1 on(acceptance.ano=D1.ano)
inner join ratetab ON (ratetab.code=D1.code)
where Acceptance.ano=@P_ANO
AND D1.SDATE=DATEADD(YEAR,@P_YEAR,Acceptance.SDATE)
Group By 
Cast(Ratetab.description +' : '+ D1.Currency +   ' ' +  
convert(varchar(255),D1.Calculation) as varchar(Max)) +   ' (' +  
 CONVERT(VARCHAR(255), D1.Sdate, 103) +   ' - ' +  CONVERT(VARCHAR(255), D1.edate, 103) +' )'   

Select @val=coalesce(@val +' ; '+ CHAR(13) +coverage,Coverage) from @DispCoverage


  Return(@val)
END  
go

if exists (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'DISPLAY_COVERAGE') AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) )
BEGIN  
DROP FUNCTION DISPLAY_COVERAGE
end
go
CREATE FUNCTION DISPLAY_COVERAGE(@P_ANO int, @P_YEAR int)      
Returns VARCHAR(max)              
As      
BEGIN    
DECLARE @val AS varchar(Max)
declare @DispCoverage Table (Coverage varchar(Max))

insert into @DispCoverage
Select Cast(Ratetab.description +' : '+ ICalc.Currency +   ' ' +   convert(varchar(25),Cast(ICalc.TSI as Money),1) as varchar(Max)) 
As Coverage 
From Acceptance 
inner Join ICalc  on(acceptance.ano=icalc.ano)
inner join ratetab ON (ratetab.code=icalc.code)
inner Join RCOVER  on(acceptance.ano=icalc.ano)
where icalc.ano=@P_ANO
AND ICALC.SDATE=DATEADD(YEAR,@P_YEAR,Acceptance.SDATE)
Group By 
Cast(Ratetab.description +' : '+ ICalc.Currency +   ' ' +   convert(varchar(25),Cast(ICalc.TSI as Money),1) as varchar(Max)) 
 
Select @val=coalesce(@val +' ; '+ CHAR(13) +coverage,Coverage) from @DispCoverage


  Return(@val)
END  
go

if exists (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'getPeriod') AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) )
BEGIN  
drop function [dbo].[getPeriod]
end
go
CREATE function [dbo].[getPeriod](@ano as int,@recno as int,@flag as int,@year as int=0)              
returns Varchar(Max) as              
begin              
declare @result as Varchar(Max)              
declare @period as Varchar(Max)              
declare @counter as int  

set @result=''              
set @counter=1              
if @flag =1              
begin              
declare csr cursor for select CONVERT(VARCHAR(255), Sdate, 103)  from rcover where ano=@ano              
end
              
else if @flag=2         
begin        
declare csr cursor for select CONVERT(VARCHAR(255),edate,103) from rcover where ano=@ano                   
end
 
else if @flag=3         
begin        
declare csr cursor for select d.Voucher from accass a,admlink d where a.admno=d.admno and a.ano=@ano and d.type='DI'                   
end    

else if @flag=4         
begin        
declare csr cursor for select CASE WHEN SHORTDESC<>'' THEN SHORTDESC+';'+ CHAR(13) ELSE '' END from ACCCLA where ano=@ano               
end        
  
else if @flag=5         
begin        
declare csr cursor for select d.Voucher from accass a,admlink d where a.admno=d.admno and a.ano=@ano and d.TYPE In ('BB','BA','BO','BC','BP','BD')                   
end 

else if @flag=6         
begin        
declare csr cursor for select DBO.DISPLAY_COVERAGE(@ano,@year-1)  as Coverage               
end 


else if @flag=7         
begin        
declare csr cursor for select CASE WHEN Remarks<>'' THEN Remarks+';'+ CHAR(13) ELSE '' END from ACCDED where ano=@ano               
end        
     
else if @flag=8         
begin        
declare csr cursor for select DBO.DISPLAY_PERIODPREMI(@ano,@year-1)  as Coverage               
end 
  open csr              
          
fetch next from csr into @period     
 while @@fetch_status=0       
  begin            
  if @counter=@recno    
   begin          
    set @result=@period     
    break;       
   end             
  set @counter=@counter+1    
  fetch next from csr into @period   
  end              
close csr    
deallocate csr     
return @result      
end

go

if exists (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'getRate') AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) )
BEGIN  
drop function [dbo].[getRate]
end
go
CREATE function [dbo].[getRate](@ano as int,@recno as int,@flag as int)              
returns float as              
begin              
declare @result as float              
declare @rate as float              
declare @counter as int              
set @result=0              
set @counter=1              
if @flag =1              
 begin              
 declare csr cursor for select rate from rcover where ano=@ano              
 end              
else              
 begin              
 if @flag=2         
  begin        
  declare csr cursor for select CAmount from accass where ano=@ano and type='DI' and code='P'              
  end        
 else        
  begin        
  if @flag=3        
   begin        
   declare csr cursor for select CAmount from accass where ano=@ano and type='DI' and code='O'              
   end    
 else        
  begin        
  if @flag=4        
   begin        
   declare csr cursor for select Amount from accass where ano=@ano and type='DI' and code='P'              
   end       
   else    
   begin      
  if @flag=5       
   begin        
   declare csr cursor for select Amount from accass where ano=@ano and type='DI' and code='O'              
   end  
     else    
   begin      
  if @flag=6       
   begin        
   declare csr cursor for select Amount from icover where ano=@ano             
   end    
   else    
   begin      
  if @flag=7       
   begin        
   declare csr cursor for select pctloss from rcover where ano=@ano             
   end      
  else        
     begin        
     declare csr cursor for select CAmount from accass where ano=@ano and type='DI' and code='F'              
     end        
  end        
 end        
 end   
 end  
end
end
open csr              
          
fetch next from csr into @rate     
 while @@fetch_status=0       
  begin            
  if @counter=@recno    
   begin          
    set @result=@rate     
    break;       
   end             
  set @counter=@counter+1    
  fetch next from csr into @rate   
  end              
close csr    
deallocate csr     
return @result      
end

go


IF EXISTS ( SELECT * FROM   sysobjects WHERE  id = object_id(N'qDownload_Feedback') and OBJECTPROPERTY(id, N'IsProcedure') = 1 )
BEGIN
Drop Procedure qDownload_Feedback
end
go
CREATE Procedure qDownload_Feedback(@Batchno varchar(30))                                      
as    
select Max(a.ano) as ANO,Max(a3.REFNO) as Refno,SysBatchOri.batchno,SysBatchOri.[LOCATION] as [BRANCH],SysBatchOri.[CONTRACTNO] as [CONTRACTNO], isnull(a.PolicyNo,'') as PolicyNo, isnull(a.Certificateno,'') as CertificateNo, SysBatchOri.[INCEPTION] as [INCEPTION],SysBatchOri.[EXPIRY] as [EXPIRY], 
--SUM(dbo.getrate(a.ano,1,2)+dbo.getrate(a.ano,2,2)+dbo.getrate(a.ano,3,2)+dbo.getrate(a.ano,4,2)+dbo.getrate(a.ano,5,2)) as Premium ,
MAX(CASE WHEN A3.TYPE In ('DI','IC') THEN A3.amount_1 ELSE 0 END) As Premium,
MAX(CASE WHEN A3.TYPE In ('BB','BA','BO','BC','BP','BD') THEN abs(A3.amount_2+A3.amount_11) ELSE 0 END) As Commision,
MAX(CASE WHEN A3.TYPE In ('BB','BA','BO','BC','BP','BD') THEN abs(A3.amount_2+A3.amount_11)+abs(A3.AMOUNT_13)-A3.AMOUNT_14 ELSE 0 END) As NetCommision,
SUM(CASE WHEN A2.code='O' And A2.TYPE In ('DI') THEN A2.Amount ELSE 0 END) As Discount,
SUM(CASE WHEN coalesce((A3.Amount-A3.Amount_11-A3.Amount_12-(A3.Amount_13+A3.Amount_17+A3.Amount_18)-A3.Amount_14),0)<>0 THEN (A3.Amount_13)*A2.amount/(A3.Amount-A3.Amount_11-A3.Amount_12-(A3.Amount_13+A3.Amount_17+A3.Amount_18)-A3.Amount_14) ELSE 0 END) As VAT, 
SUM(CASE WHEN coalesce((A3.Amount-A3.Amount_11-A3.Amount_12-(A3.Amount_13+A3.Amount_17+A3.Amount_18)-A3.Amount_14),0)<>0 THEN A3.Amount_14*A2.amount/(A3.Amount-A3.Amount_11-A3.Amount_12-(A3.Amount_13+A3.Amount_17+A3.Amount_18)-A3.Amount_14) ELSE 0 END) As TAX, 
Max(A3.AMOUNT_3+A3.amount_4) as BiayaAdmin,
--(SUM(dbo.getrate(a.ano,1,2)+dbo.getrate(a.ano,2,2)+dbo.getrate(a.ano,3,2)+dbo.getrate(a.ano,4,2)+dbo.getrate(a.ano,5,2)) +
--SUM(CASE WHEN A2.code='C' And A2.TYPE In ('BA','BB') THEN A2.Amount ELSE 0 END) -
--SUM(CASE WHEN A2.code='O' And A2.TYPE In ('DI') THEN A2.Amount ELSE 0 END) +
--SUM(CASE WHEN coalesce((A3.Amount-A3.Amount_11-A3.Amount_12-(A3.Amount_13+A3.Amount_17+A3.Amount_18)-A3.Amount_14),0)<>0 THEN (A3.Amount_13)*A2.amount/(A3.Amount-A3.Amount_11-A3.Amount_12-
--(A3.Amount_13+A3.Amount_17+A3.Amount_18)-A3.Amount_14) ELSE 0 END) +
--SUM(CASE WHEN coalesce((A3.Amount-A3.Amount_11-A3.Amount_12-(A3.Amount_13+A3.Amount_17+A3.Amount_18)-A3.Amount_14),0)<>0 THEN A3.Amount_14*A2.amount/(A3.Amount-A3.Amount_11-A3.Amount_12-
--(A3.Amount_13+A3.Amount_17+A3.Amount_18)-A3.Amount_14) ELSE 0 END) +
--isnull(SUM(AccFd.amount), 0)) as [Nett Premi],
MAX(A3.amount) as [Nett Premi],
A.CDate as EntryDate,A.ADate as ApprovalDate,case when(SysBatch.status = 'N') then 'Failed' when(SysBatch.status = 'C') then 'Success' when(SysBatch.status = 'W') then 'Not yet process' else 'Failed' end as 'Status',SysBatchOri.errmsg, SysBatchOri.BID 
,c.insured, p.address_1, P.address_2, p.address_3, a.aname as [QQ_1], S.TSI
,Max(dbo.getPeriod(a.ano,1,3,0)) as [Premium Note],Max(dbo.getPeriod(a.ano,1,5,0)) as [Commission Note],a3.BILLDATE,a3.Date as DateInvoice,
S.VALUEDESC1, S.VALUEDESC2, S.VALUEDESC3, S.VALUEDESC4, S.VALUEDESC5, S.VALUEDESC6, S.VALUEDESC7, S.VALUEDESC8, S.VALUEDESC9, S.VALUEDESC10, S.VALUEDESC11, S.VALUEDESC12, S.VALUEDESC13, S.VALUEDESC14, S.VALUEDESC15
,s.valuedesc16,s.valuedesc17, s.valuedesc18, s.location
,Cast(left(dbo.getPeriod(a.ano,1,4,0) + dbo.getPeriod(a.ano,2,4,0)+ dbo.getPeriod(a.ano,3,4,0)+dbo.getPeriod(a.ano,4,4,0) + dbo.getPeriod(a.ano,5,4,0)+ dbo.getPeriod(a.ano,6,4,0)+ dbo.getPeriod(a.ano,7,4,0)+ dbo.getPeriod(a.ano,8,4,0)+ dbo.getPeriod(a.ano,9,4,0)+dbo.getPeriod(a.ano,10,4,0),len(dbo.getPeriod(a.ano,1,4,0) + dbo.getPeriod(a.ano,2,4,0)+ dbo.getPeriod(a.ano,3,4,0)+dbo.getPeriod(a.ano,4,4,0) + dbo.getPeriod(a.ano,5,4,0)+ dbo.getPeriod(a.ano,6,4,0)+ dbo.getPeriod(a.ano,7,4,0)+ dbo.getPeriod(a.ano,8,4,0)+ dbo.getPeriod(a.ano,9,4,0)+dbo.getPeriod(a.ano,10,4,0))-2)  as varchar(8000)) as klausula
--,s.coverage_1, s.coverage_2, s.coverage_3, s.coverage_4, s.coverage_5
,Cast(dbo.getPeriod(a.ano,1,6,1) as varchar(MAX)) as coverage_1
,Cast(dbo.getPeriod(a.ano,1,6,2) as varchar(MAX)) as coverage_2
,Cast(dbo.getPeriod(a.ano,1,6,3) as varchar(MAX)) as coverage_3
,Cast(dbo.getPeriod(a.ano,1,6,4) as varchar(MAX)) as coverage_4
,Cast(dbo.getPeriod(a.ano,1,6,5) as varchar(MAX)) as coverage_5
,s.Interest_1,s.Interest_2,s.Interest_3,s.Interest_4,s.Interest_5
,Cast(left(dbo.getPeriod(a.ano,1,7,0) + dbo.getPeriod(a.ano,2,7,0)+ dbo.getPeriod(a.ano,3,7,0)+dbo.getPeriod(a.ano,4,7,0) + dbo.getPeriod(a.ano,5,7,0)+ dbo.getPeriod(a.ano,6,7,0)+ dbo.getPeriod(a.ano,7,7,0)+ dbo.getPeriod(a.ano,8,7,0)+ dbo.getPeriod(a.ano,9,7,0)+dbo.getPeriod(a.ano,10,7,0),len(dbo.getPeriod(a.ano,1,7,0) + dbo.getPeriod(a.ano,2,7,0)+ dbo.getPeriod(a.ano,3,7,0)+dbo.getPeriod(a.ano,4,7,0) + dbo.getPeriod(a.ano,5,7,0)+ dbo.getPeriod(a.ano,6,7,0)+ dbo.getPeriod(a.ano,7,7,0)+ dbo.getPeriod(a.ano,8,7,0)+ dbo.getPeriod(a.ano,9,7,0)+dbo.getPeriod(a.ano,10,7,0))-2)  as varchar(8000)) as [Resiko Sendiri]
,Cast(dbo.getPeriod(a.ano,1,1,0) +'-'+ dbo.getPeriod(a.ano,1,2,0) as varchar(255)) as [Period Pertama]
,Cast(dbo.getPeriod(a.ano,2,1,0) +'-'+ dbo.getPeriod(a.ano,2,2,0) as varchar(255)) as [Period Kedua]
,Cast(dbo.getPeriod(a.ano,3,1,0) +'-'+ dbo.getPeriod(a.ano,3,2,0) as varchar(255)) as [Period Ketiga]
,Cast(dbo.getPeriod(a.ano,4,1,0) +'-'+ dbo.getPeriod(a.ano,4,2,0) as varchar(255)) as [Period Keempat]
,Cast(dbo.getPeriod(a.ano,5,1,0) +'-'+ dbo.getPeriod(a.ano,5,2,0) as varchar(255)) as [Period Kelima]
,MAX(dbo.getrate(a.ano,1,7)*dbo.getrate(a.ano,1,6)/100) as TSI_1
,MAX(dbo.getrate(a.ano,2,7)*dbo.getrate(a.ano,1,6)/100) as TSI_2
,MAX(dbo.getrate(a.ano,3,7)*dbo.getrate(a.ano,1,6)/100) as TSI_3
,MAX(dbo.getrate(a.ano,4,7)*dbo.getrate(a.ano,1,6)/100) as TSI_4
,MAX(dbo.getrate(a.ano,5,7)*dbo.getrate(a.ano,1,6)/100) as TSI_5
--,cast(s.coverage_1+' = '+cast(cast(Max(dbo.getrate(a.ano,1,7)*dbo.getrate(a.ano,1,6)/100) as money) as varchar(255))+';'+ CHAR(13)+ 
--s.coverage_2+' = '+cast(cast(MAX(dbo.getrate(a.ano,2,7)*dbo.getrate(a.ano,1,6)/100) as money) as varchar(255))+';'+ CHAR(13)+
--s.coverage_3+' = '+cast(cast(MAX(dbo.getrate(a.ano,3,7)*dbo.getrate(a.ano,1,6)/100) as money) as varchar(255))+';'+ CHAR(13)+
--s.coverage_4+' = '+cast(cast(MAX(dbo.getrate(a.ano,4,7)*dbo.getrate(a.ano,1,6)/100) as money) as varchar(255))+';'+ CHAR(13)+
--s.coverage_5+' = '+cast(cast(MAX(dbo.getrate(a.ano,5,7)*dbo.getrate(a.ano,1,6)/100) as money) as varchar(255)) as varchar(8000)) as [Detail Coverage]
,MAX(dbo.getrate(a.ano,1,1)) as Rate_1,MAX(dbo.getrate(a.ano,2,1)) as Rate_2,MAX(dbo.getrate(a.ano,3,1)) as Rate_3,MAX(dbo.getrate(a.ano,4,1)) as Rate_4, MAX(dbo.getrate(a.ano,5,1)) as Rate_5 

from SysBatchOriginalSC SysBatchOri left join SysBatchSC SysBatch on SysBatch.BID = SysBatchOri.BID  left join Scheme_Transaction s on s.BatchNo=SysBatch.BatchNo and s.PolicyNo=SysBatch.PolicyNo  and s.ContractNo=SysBatch.ContractNo left join ACCEPTANCE a on a.ANO=s.ANO 
left join cover c on a.cNO=c.cNO 
left join PAYOR p on a.ANO=p.ano 
Left Join ACCFD on AccFd.ANO = A.ANO 
Left Join ACCASS A2 On A2.ANO = a.ANO 
Left Join AdmLink A3 on A3.ADMNO = A2.ADMNO 
where SysBatchOri.batchno = @Batchno and SysBatch.status = 'C'

Group By SysBatchOri.batchno,SysBatchOri.[LOCATION],SysBatchOri.[CONTRACTNO] , isnull(a.PolicyNo,'') , isnull(a.Certificateno,'') , SysBatchOri.[INCEPTION] ,SysBatchOri.[EXPIRY] ,A.CDate ,A.ADate ,case when(SysBatch.status = 'N') then 'Failed' when(SysBatch.status = 'C') then 'Success' when(SysBatch.status = 'W') then 'Not yet process' else 'Failed' end ,SysBatchOri.errmsg, SysBatchOri.BID 

,c.insured, p.address_1, P.address_2, p.address_3, a.aname,S.Tsi,a3.BILLDATE,a3.Date,
S.VALUEDESC1, S.VALUEDESC2, S.VALUEDESC3, S.VALUEDESC4, S.VALUEDESC5, S.VALUEDESC6, S.VALUEDESC7, S.VALUEDESC8, S.VALUEDESC9, S.VALUEDESC10, S.VALUEDESC11, S.VALUEDESC12, S.VALUEDESC13, S.VALUEDESC14, S.VALUEDESC15
,s.valuedesc16,s.valuedesc17, s.valuedesc18, s.location
,Cast(left(dbo.getPeriod(a.ano,1,4,0) + dbo.getPeriod(a.ano,2,4,0)+ dbo.getPeriod(a.ano,3,4,0)+dbo.getPeriod(a.ano,4,4,0) + dbo.getPeriod(a.ano,5,4,0)+ dbo.getPeriod(a.ano,6,4,0)+ dbo.getPeriod(a.ano,7,4,0)+ dbo.getPeriod(a.ano,8,4,0)+ dbo.getPeriod(a.ano,9,4,0)+dbo.getPeriod(a.ano,10,4,0),len(dbo.getPeriod(a.ano,1,4,0) + dbo.getPeriod(a.ano,2,4,0)+ dbo.getPeriod(a.ano,3,4,0)+dbo.getPeriod(a.ano,4,4,0) + dbo.getPeriod(a.ano,5,4,0)+ dbo.getPeriod(a.ano,6,4,0)+ dbo.getPeriod(a.ano,7,4,0)+ dbo.getPeriod(a.ano,8,4,0)+ dbo.getPeriod(a.ano,9,4,0)+dbo.getPeriod(a.ano,10,4,0))-2)  as varchar(8000))
--,s.coverage_1, s.coverage_2, s.coverage_3, s.coverage_4, s.coverage_5
,Cast(dbo.getPeriod(a.ano,1,6,1) as varchar(MAX)) 
,Cast(dbo.getPeriod(a.ano,1,6,2) as varchar(MAX)) 
,Cast(dbo.getPeriod(a.ano,1,6,3) as varchar(MAX))
,Cast(dbo.getPeriod(a.ano,1,6,4) as varchar(MAX))
,Cast(dbo.getPeriod(a.ano,1,6,5) as varchar(MAX)) 
,s.Interest_1,s.Interest_2,s.Interest_3,s.Interest_4,s.Interest_5
,Cast(left(dbo.getPeriod(a.ano,1,7,0) + dbo.getPeriod(a.ano,2,7,0)+ dbo.getPeriod(a.ano,3,7,0)+dbo.getPeriod(a.ano,4,7,0) + dbo.getPeriod(a.ano,5,7,0)+ dbo.getPeriod(a.ano,6,7,0)+ dbo.getPeriod(a.ano,7,7,0)+ dbo.getPeriod(a.ano,8,7,0)+ dbo.getPeriod(a.ano,9,7,0)+dbo.getPeriod(a.ano,10,7,0),len(dbo.getPeriod(a.ano,1,7,0) + dbo.getPeriod(a.ano,2,7,0)+ dbo.getPeriod(a.ano,3,7,0)+dbo.getPeriod(a.ano,4,7,0) + dbo.getPeriod(a.ano,5,7,0)+ dbo.getPeriod(a.ano,6,7,0)+ dbo.getPeriod(a.ano,7,7,0)+ dbo.getPeriod(a.ano,8,7,0)+ dbo.getPeriod(a.ano,9,7,0)+dbo.getPeriod(a.ano,10,7,0))-2)  as varchar(8000)) 
,Cast(dbo.getPeriod(a.ano,1,1,0) +'-'+ dbo.getPeriod(a.ano,1,2,0) as varchar(255))
,Cast(dbo.getPeriod(a.ano,2,1,0) +'-'+ dbo.getPeriod(a.ano,2,2,0) as varchar(255))
,Cast(dbo.getPeriod(a.ano,3,1,0) +'-'+ dbo.getPeriod(a.ano,3,2,0) as varchar(255)) 
,Cast(dbo.getPeriod(a.ano,4,1,0) +'-'+ dbo.getPeriod(a.ano,4,2,0) as varchar(255)) 
,Cast(dbo.getPeriod(a.ano,5,1,0) +'-'+ dbo.getPeriod(a.ano,5,2,0) as varchar(255)) 
Order By SysBatchOri.BID
go


IF EXISTS ( SELECT * FROM   sysobjects WHERE  id = object_id(N'qDownload_DetFeedback') and OBJECTPROPERTY(id, N'IsProcedure') = 1 )
BEGIN
Drop Procedure qDownload_DetFeedback
end
go
CREATE Procedure qDownload_DetFeedback(@Batchno varchar(30))                                      
as    
select Max(a.ano) as ANO,Max(a3.REFNO) as Refno,SysBatchOri.batchno,SysBatchOri.[LOCATION] as [BRANCH],SysBatchOri.[CONTRACTNO] as [CONTRACTNO], isnull(a.PolicyNo,'') as PolicyNo, isnull(a.Certificateno,'') as CertificateNo, SysBatchOri.[INCEPTION] as [INCEPTION],SysBatchOri.[EXPIRY] as [EXPIRY], 
--SUM(dbo.getrate(a.ano,1,2)+dbo.getrate(a.ano,2,2)+dbo.getrate(a.ano,3,2)+dbo.getrate(a.ano,4,2)+dbo.getrate(a.ano,5,2)) as Premium ,
MAX(CASE WHEN A3.TYPE In ('DI','IC') THEN A3.amount_1 ELSE 0 END) As Premium,
MAX(CASE WHEN A3.TYPE In ('BB','BA','BO','BC','BP','BD') THEN abs(A3.amount_2+A3.amount_11) ELSE 0 END) As Commision,
MAX(CASE WHEN A3.TYPE In ('BB','BA','BO','BC','BP','BD') THEN abs(A3.amount_2+A3.amount_11)+abs(A3.AMOUNT_13)-A3.AMOUNT_14 ELSE 0 END) As NetCommision,
SUM(CASE WHEN A2.code='O' And A2.TYPE In ('DI') THEN A2.Amount ELSE 0 END) As Discount,
SUM(CASE WHEN coalesce((A3.Amount-A3.Amount_11-A3.Amount_12-(A3.Amount_13+A3.Amount_17+A3.Amount_18)-A3.Amount_14),0)<>0 THEN (A3.Amount_13)*A2.amount/(A3.Amount-A3.Amount_11-A3.Amount_12-(A3.Amount_13+A3.Amount_17+A3.Amount_18)-A3.Amount_14) ELSE 0 END) As VAT, 
SUM(CASE WHEN coalesce((A3.Amount-A3.Amount_11-A3.Amount_12-(A3.Amount_13+A3.Amount_17+A3.Amount_18)-A3.Amount_14),0)<>0 THEN A3.Amount_14*A2.amount/(A3.Amount-A3.Amount_11-A3.Amount_12-(A3.Amount_13+A3.Amount_17+A3.Amount_18)-A3.Amount_14) ELSE 0 END) As TAX, 
Max(A3.AMOUNT_3+A3.amount_4) as BiayaAdmin,
MAX(A3.amount) as [Nett Premi],
A.CDate as EntryDate,A.ADate as ApprovalDate,case when(SysBatch.status = 'N') then 'Failed' when(SysBatch.status = 'C') then 'Success' when(SysBatch.status = 'W') then 'Not yet process' else 'Failed' end as 'Status',SysBatchOri.errmsg, SysBatchOri.BID 
,c.insured, p.address_1, P.address_2, p.address_3, a.aname as [QQ_1], S.TSI
,Max(dbo.getPeriod(a.ano,1,3,0)) as [Premium Note],Max(dbo.getPeriod(a.ano,1,5,0)) as [Commission Note],a3.BILLDATE,a3.Date as DateInvoice,
S.VALUEDESC1, S.VALUEDESC2, S.VALUEDESC3, S.VALUEDESC4, S.VALUEDESC5, S.VALUEDESC6, S.VALUEDESC7, S.VALUEDESC8, S.VALUEDESC9, S.VALUEDESC10, S.VALUEDESC11, S.VALUEDESC12, S.VALUEDESC13, S.VALUEDESC14, S.VALUEDESC15
,s.valuedesc16,s.valuedesc17, s.valuedesc18, s.location
,Cast(left(dbo.getPeriod(a.ano,1,4,0) + dbo.getPeriod(a.ano,2,4,0)+ dbo.getPeriod(a.ano,3,4,0)+dbo.getPeriod(a.ano,4,4,0) + dbo.getPeriod(a.ano,5,4,0)+ dbo.getPeriod(a.ano,6,4,0)+ dbo.getPeriod(a.ano,7,4,0)+ dbo.getPeriod(a.ano,8,4,0)+ dbo.getPeriod(a.ano,9,4,0)+dbo.getPeriod(a.ano,10,4,0),len(dbo.getPeriod(a.ano,1,4,0) + dbo.getPeriod(a.ano,2,4,0)+ dbo.getPeriod(a.ano,3,4,0)+dbo.getPeriod(a.ano,4,4,0) + dbo.getPeriod(a.ano,5,4,0)+ dbo.getPeriod(a.ano,6,4,0)+ dbo.getPeriod(a.ano,7,4,0)+ dbo.getPeriod(a.ano,8,4,0)+ dbo.getPeriod(a.ano,9,4,0)+dbo.getPeriod(a.ano,10,4,0))-2)  as varchar(8000)) as klausula
,Cast(dbo.getPeriod(a.ano,1,8,1) as varchar(MAX)) as Period_1
,Cast(dbo.getPeriod(a.ano,1,8,2) as varchar(MAX)) as Period_2
,Cast(dbo.getPeriod(a.ano,1,8,3) as varchar(MAX)) as Period_3
,Cast(dbo.getPeriod(a.ano,1,8,4) as varchar(MAX)) as Period_4
,Cast(dbo.getPeriod(a.ano,1,8,5) as varchar(MAX)) as Period_5
,Cast(left(dbo.getPeriod(a.ano,1,7,0) + dbo.getPeriod(a.ano,2,7,0)+ dbo.getPeriod(a.ano,3,7,0)+dbo.getPeriod(a.ano,4,7,0) + dbo.getPeriod(a.ano,5,7,0)+ dbo.getPeriod(a.ano,6,7,0)+ dbo.getPeriod(a.ano,7,7,0)+ dbo.getPeriod(a.ano,8,7,0)+ dbo.getPeriod(a.ano,9,7,0)+dbo.getPeriod(a.ano,10,7,0),len(dbo.getPeriod(a.ano,1,7,0) + dbo.getPeriod(a.ano,2,7,0)+ dbo.getPeriod(a.ano,3,7,0)+dbo.getPeriod(a.ano,4,7,0) + dbo.getPeriod(a.ano,5,7,0)+ dbo.getPeriod(a.ano,6,7,0)+ dbo.getPeriod(a.ano,7,7,0)+ dbo.getPeriod(a.ano,8,7,0)+ dbo.getPeriod(a.ano,9,7,0)+dbo.getPeriod(a.ano,10,7,0))-2)  as varchar(8000)) as [Resiko Sendiri]
from SysBatchOriginalSC SysBatchOri left join SysBatchSC SysBatch on SysBatch.BID = SysBatchOri.BID  left join Scheme_Transaction s on s.BatchNo=SysBatch.BatchNo and s.PolicyNo=SysBatch.PolicyNo  and s.ContractNo=SysBatch.ContractNo left join ACCEPTANCE a on a.ANO=s.ANO 
left join cover c on a.cNO=c.cNO 
left join PAYOR p on a.ANO=p.ano 
Left Join ACCFD on AccFd.ANO = A.ANO 
Left Join ACCASS A2 On A2.ANO = a.ANO 
Left Join AdmLink A3 on A3.ADMNO = A2.ADMNO 
where SysBatchOri.batchno = @Batchno and SysBatch.status = 'C'

Group By SysBatchOri.batchno,SysBatchOri.[LOCATION],SysBatchOri.[CONTRACTNO] , isnull(a.PolicyNo,'') , isnull(a.Certificateno,'') , SysBatchOri.[INCEPTION] ,SysBatchOri.[EXPIRY] ,A.CDate ,A.ADate ,case when(SysBatch.status = 'N') then 'Failed' when(SysBatch.status = 'C') then 'Success' when(SysBatch.status = 'W') then 'Not yet process' else 'Failed' end ,SysBatchOri.errmsg, SysBatchOri.BID 

,c.insured, p.address_1, P.address_2, p.address_3, a.aname,S.Tsi,a3.BILLDATE,a3.Date,
S.VALUEDESC1, S.VALUEDESC2, S.VALUEDESC3, S.VALUEDESC4, S.VALUEDESC5, S.VALUEDESC6, S.VALUEDESC7, S.VALUEDESC8, S.VALUEDESC9, S.VALUEDESC10, S.VALUEDESC11, S.VALUEDESC12, S.VALUEDESC13, S.VALUEDESC14, S.VALUEDESC15
,s.valuedesc16,s.valuedesc17, s.valuedesc18, s.location
,Cast(left(dbo.getPeriod(a.ano,1,4,0) + dbo.getPeriod(a.ano,2,4,0)+ dbo.getPeriod(a.ano,3,4,0)+dbo.getPeriod(a.ano,4,4,0) + dbo.getPeriod(a.ano,5,4,0)+ dbo.getPeriod(a.ano,6,4,0)+ dbo.getPeriod(a.ano,7,4,0)+ dbo.getPeriod(a.ano,8,4,0)+ dbo.getPeriod(a.ano,9,4,0)+dbo.getPeriod(a.ano,10,4,0),len(dbo.getPeriod(a.ano,1,4,0) + dbo.getPeriod(a.ano,2,4,0)+ dbo.getPeriod(a.ano,3,4,0)+dbo.getPeriod(a.ano,4,4,0) + dbo.getPeriod(a.ano,5,4,0)+ dbo.getPeriod(a.ano,6,4,0)+ dbo.getPeriod(a.ano,7,4,0)+ dbo.getPeriod(a.ano,8,4,0)+ dbo.getPeriod(a.ano,9,4,0)+dbo.getPeriod(a.ano,10,4,0))-2)  as varchar(8000))
,Cast(dbo.getPeriod(a.ano,1,8,1) as varchar(MAX))
,Cast(dbo.getPeriod(a.ano,1,8,2) as varchar(MAX))
,Cast(dbo.getPeriod(a.ano,1,8,3) as varchar(MAX)) 
,Cast(dbo.getPeriod(a.ano,1,8,4) as varchar(MAX))
,Cast(dbo.getPeriod(a.ano,1,8,5) as varchar(MAX))
,Cast(left(dbo.getPeriod(a.ano,1,7,0) + dbo.getPeriod(a.ano,2,7,0)+ dbo.getPeriod(a.ano,3,7,0)+dbo.getPeriod(a.ano,4,7,0) + dbo.getPeriod(a.ano,5,7,0)+ dbo.getPeriod(a.ano,6,7,0)+ dbo.getPeriod(a.ano,7,7,0)+ dbo.getPeriod(a.ano,8,7,0)+ dbo.getPeriod(a.ano,9,7,0)+dbo.getPeriod(a.ano,10,7,0),len(dbo.getPeriod(a.ano,1,7,0) + dbo.getPeriod(a.ano,2,7,0)+ dbo.getPeriod(a.ano,3,7,0)+dbo.getPeriod(a.ano,4,7,0) + dbo.getPeriod(a.ano,5,7,0)+ dbo.getPeriod(a.ano,6,7,0)+ dbo.getPeriod(a.ano,7,7,0)+ dbo.getPeriod(a.ano,8,7,0)+ dbo.getPeriod(a.ano,9,7,0)+dbo.getPeriod(a.ano,10,7,0))-2)  as varchar(8000)) 

Order By SysBatchOri.BID
go



 insert into PatchVersioning
select '244 Update Script Download Upload',GETDATE()
go


Declare @PrevScript varchar(100)
Declare @CurrScript varchar(100)

Select @PrevScript=''
Select @CurrSCript='244 Update Script Download Upload'


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


