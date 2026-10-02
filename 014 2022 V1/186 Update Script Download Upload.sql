if exists (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'getPeriod') AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) )
begin
drop function [dbo].[getPeriod]
end
go
CREATE function [dbo].[getPeriod](@ano as int,@recno as int,@flag as int)              
returns Varchar(255) as              
begin              
declare @result as Varchar(255)              
declare @period as Varchar(255)              
declare @counter as int              
set @result=''              
set @counter=1              
if @flag =1              
begin              
declare csr cursor for select Sdate from rcover where ano=@ano              
end
              
else if @flag=2         
begin        
declare csr cursor for select edate from rcover where ano=@ano                   
end
 
else if @flag=3         
begin        
declare csr cursor for select d.Voucher from accass a,admlink d where a.admno=d.admno and a.ano=@ano and d.type='DI'                   
end       
else        
begin        
declare csr cursor for select SHORTDESC from ACCCLA where ano=@ano               
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

drop function [dbo].[getRate]
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
begin
Drop Procedure qDownload_Feedback
end
go
CREATE Procedure qDownload_Feedback(@Batchno varchar(30))                                      
as                                      
select SysBatchOri.batchno,SysBatchOri.[LOCATION] as [BRANCH],SysBatchOri.[CONTRACTNO] as [CONTRACTNO], isnull(a.PolicyNo,'') as PolicyNo, isnull(a.Certificateno,'') as CertificateNo, SysBatchOri.[INCEPTION] as [INCEPTION],SysBatchOri.[EXPIRY] as [EXPIRY], 
SUM(dbo.getrate(a.ano,1,2)+dbo.getrate(a.ano,2,2)+dbo.getrate(a.ano,3,2)+dbo.getrate(a.ano,4,2)+dbo.getrate(a.ano,5,2)) as Premium ,
SUM(CASE WHEN A2.code='C' And A2.TYPE In ('BA','BB') THEN A2.Amount ELSE 0 END) As Commision,
SUM(CASE WHEN A2.code='O' And A2.TYPE In ('DI') THEN A2.Amount ELSE 0 END) As Discount,
SUM(CASE WHEN coalesce((A3.Amount-A3.Amount_11-A3.Amount_12-(A3.Amount_13+A3.Amount_17+A3.Amount_18)-A3.Amount_14),0)<>0 THEN (A3.Amount_13)*A2.amount/(A3.Amount-A3.Amount_11-A3.Amount_12-(A3.Amount_13+A3.Amount_17+A3.Amount_18)-A3.Amount_14) ELSE 0 END) As VAT, 
SUM(CASE WHEN coalesce((A3.Amount-A3.Amount_11-A3.Amount_12-(A3.Amount_13+A3.Amount_17+A3.Amount_18)-A3.Amount_14),0)<>0 THEN A3.Amount_14*A2.amount/(A3.Amount-A3.Amount_11-A3.Amount_12-(A3.Amount_13+A3.Amount_17+A3.Amount_18)-A3.Amount_14) ELSE 0 END) As TAX, 
isnull(SUM(AccFd.amount),0) as BiayaAdmin,
(SUM(dbo.getrate(a.ano,1,2)+dbo.getrate(a.ano,2,2)+dbo.getrate(a.ano,3,2)+dbo.getrate(a.ano,4,2)+dbo.getrate(a.ano,5,2)) +
SUM(CASE WHEN A2.code='C' And A2.TYPE In ('BA','BB') THEN A2.Amount ELSE 0 END) -
SUM(CASE WHEN A2.code='O' And A2.TYPE In ('DI') THEN A2.Amount ELSE 0 END) +
SUM(CASE WHEN coalesce((A3.Amount-A3.Amount_11-A3.Amount_12-(A3.Amount_13+A3.Amount_17+A3.Amount_18)-A3.Amount_14),0)<>0 THEN (A3.Amount_13)*A2.amount/(A3.Amount-A3.Amount_11-A3.Amount_12-
(A3.Amount_13+A3.Amount_17+A3.Amount_18)-A3.Amount_14) ELSE 0 END) +
SUM(CASE WHEN coalesce((A3.Amount-A3.Amount_11-A3.Amount_12-(A3.Amount_13+A3.Amount_17+A3.Amount_18)-A3.Amount_14),0)<>0 THEN A3.Amount_14*A2.amount/(A3.Amount-A3.Amount_11-A3.Amount_12-
(A3.Amount_13+A3.Amount_17+A3.Amount_18)-A3.Amount_14) ELSE 0 END) +
isnull(SUM(AccFd.amount), 0)) as [Nett Premi],
A.CDate as EntryDate,A.ADate as ApprovalDate,case when(SysBatch.status = 'N') then 'Failed' when(SysBatch.status = 'C') then 'Success' when(SysBatch.status = 'W') then 'Not yet process' else 'Failed' end as 'Status',SysBatchOri.errmsg, SysBatchOri.BID 
,c.insured, p.address_1, P.address_2, p.address_3, a.aname as [QQ_1], S.TSI
,Max(dbo.getPeriod(a.ano,1,3)) as [Premium Note],a3.BILLDATE,
S.VALUEDESC1, S.VALUEDESC2, S.VALUEDESC3, S.VALUEDESC4, S.VALUEDESC5, S.VALUEDESC6, S.VALUEDESC7, S.VALUEDESC8, S.VALUEDESC9, S.VALUEDESC10, S.VALUEDESC11, S.VALUEDESC12, S.VALUEDESC13, S.VALUEDESC14, S.VALUEDESC15
,s.valuedesc16,s.valuedesc17, s.valuedesc18, s.location
,Cast('-'+dbo.getPeriod(a.ano,1,4) +'-'+ dbo.getPeriod(a.ano,2,4)+'-'+ dbo.getPeriod(a.ano,3,4)+'-'+ dbo.getPeriod(a.ano,4,4) +'-'+ dbo.getPeriod(a.ano,5,4)+'-'+ dbo.getPeriod(a.ano,6,4)+'-'+ dbo.getPeriod(a.ano,7,4)+'-'+ dbo.getPeriod(a.ano,8,4)+'-'+ dbo.getPeriod(a.ano,9,4)+'-'+ dbo.getPeriod(a.ano,10,4)  as varchar(8000)) as klausula
,s.coverage_1, s.coverage_2, s.coverage_3, s.coverage_4, s.coverage_5
,s.Interest_1,s.Interest_2,s.Interest_3,s.Interest_4,s.Interest_5
,Cast(dbo.getPeriod(a.ano,1,1) +'-'+ dbo.getPeriod(a.ano,1,2) as varchar(255)) as [Period Pertama]
,Cast(dbo.getPeriod(a.ano,2,1) +'-'+ dbo.getPeriod(a.ano,2,2) as varchar(255)) as [Period Kedua]
,Cast(dbo.getPeriod(a.ano,3,1) +'-'+ dbo.getPeriod(a.ano,3,2) as varchar(255)) as [Period Ketiga]
,Cast(dbo.getPeriod(a.ano,4,1) +'-'+ dbo.getPeriod(a.ano,4,2) as varchar(255)) as [Period Keempat]
,Cast(dbo.getPeriod(a.ano,5,1) +'-'+ dbo.getPeriod(a.ano,5,2) as varchar(255)) as [Period Kelima]
,MAX(dbo.getrate(a.ano,1,7)*dbo.getrate(a.ano,1,6)/100) as TSI_1
,MAX(dbo.getrate(a.ano,2,7)*dbo.getrate(a.ano,1,6)/100) as TSI_2
,MAX(dbo.getrate(a.ano,3,7)*dbo.getrate(a.ano,1,6)/100) as TSI_3
,MAX(dbo.getrate(a.ano,4,7)*dbo.getrate(a.ano,1,6)/100) as TSI_4
,MAX(dbo.getrate(a.ano,5,7)*dbo.getrate(a.ano,1,6)/100) as TSI_5
,MAX(dbo.getrate(a.ano,1,1)) as Rate_1,MAX(dbo.getrate(a.ano,2,1)) as Rate_2,MAX(dbo.getrate(a.ano,3,1)) as Rate_3,MAX(dbo.getrate(a.ano,4,1)) as Rate_4, MAX(dbo.getrate(a.ano,5,1)) as Rate_5 

from SysBatchOriginalSC SysBatchOri left join SysBatchSC SysBatch on SysBatch.BID = SysBatchOri.BID  left join Scheme_Transaction s on s.BatchNo=SysBatch.BatchNo and s.PolicyNo=SysBatch.PolicyNo  and s.ContractNo=SysBatch.ContractNo left join ACCEPTANCE a on a.ANO=s.ANO 
left join cover c on a.cNO=c.cNO 
left join PAYOR p on a.ANO=p.ano Left Join ACCFD on AccFd.ANO = A.ANO Left Join ACCASS A2 On A2.ANO = a.ANO Left Join AdmLink A3 on A3.ADMNO = A2.ADMNO 
where SysBatchOri.batchno = @Batchno and SysBatch.status = 'C'

Group By SysBatchOri.batchno,SysBatchOri.[LOCATION],SysBatchOri.[CONTRACTNO] , isnull(a.PolicyNo,'') , isnull(a.Certificateno,'') , SysBatchOri.[INCEPTION] ,SysBatchOri.[EXPIRY] ,A.CDate ,A.ADate ,case when(SysBatch.status = 'N') then 'Failed' when(SysBatch.status = 'C') then 'Success' when(SysBatch.status = 'W') then 'Not yet process' else 'Failed' end ,SysBatchOri.errmsg, SysBatchOri.BID 

,c.insured, p.address_1, P.address_2, p.address_3, a.aname,S.Tsi,a3.BILLDATE,
S.VALUEDESC1, S.VALUEDESC2, S.VALUEDESC3, S.VALUEDESC4, S.VALUEDESC5, S.VALUEDESC6, S.VALUEDESC7, S.VALUEDESC8, S.VALUEDESC9, S.VALUEDESC10, S.VALUEDESC11, S.VALUEDESC12, S.VALUEDESC13, S.VALUEDESC14, S.VALUEDESC15
,s.valuedesc16,s.valuedesc17, s.valuedesc18, s.location
,Cast('-'+dbo.getPeriod(a.ano,1,4) +'-'+ dbo.getPeriod(a.ano,2,4)+'-'+ dbo.getPeriod(a.ano,3,4)+'-'+ dbo.getPeriod(a.ano,4,4) +'-'+ dbo.getPeriod(a.ano,5,4)+'-'+ dbo.getPeriod(a.ano,6,4)+'-'+ dbo.getPeriod(a.ano,7,4)+'-'+ dbo.getPeriod(a.ano,8,4)+'-'+ dbo.getPeriod(a.ano,9,4)+'-'+ dbo.getPeriod(a.ano,10,4)  as varchar(8000))
,s.coverage_1, s.coverage_2, s.coverage_3, s.coverage_4, s.coverage_5
,s.Interest_1,s.Interest_2,s.Interest_3,s.Interest_4,s.Interest_5
,Cast(dbo.getPeriod(a.ano,1,1) +'-'+ dbo.getPeriod(a.ano,1,2) as varchar(255)) 
,Cast(dbo.getPeriod(a.ano,2,1) +'-'+ dbo.getPeriod(a.ano,2,2) as varchar(255)) 
,Cast(dbo.getPeriod(a.ano,3,1) +'-'+ dbo.getPeriod(a.ano,3,2) as varchar(255)) 
,Cast(dbo.getPeriod(a.ano,4,1) +'-'+ dbo.getPeriod(a.ano,4,2) as varchar(255)) 
,Cast(dbo.getPeriod(a.ano,5,1) +'-'+ dbo.getPeriod(a.ano,5,2) as varchar(255)) 
Order By SysBatchOri.BID
go



 insert into PatchVersioning
select '186 Update Script Download Upload',GETDATE()
go


Declare @PrevScript varchar(100)
Declare @CurrScript varchar(100)

Select @PrevScript=''
Select @CurrSCript='186 Update Script Download Upload'


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


