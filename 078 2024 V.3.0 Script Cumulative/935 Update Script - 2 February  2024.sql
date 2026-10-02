IF NOT EXISTS(SELECT * FROM SYSFORM WHERE FNAME='FORCECHECKMAXOUTGO')
BEGIN
insert into Sysform(FName, Description, FCode, RequestF)
Select 'FORCECHECKMAXOUTGO','Force Check Max Out Go','ACTIVITIES',0
end
GO
IF NOT EXISTS(SELECT * FROM SYSFORM WHERE FNAME='EXCEEDINGOBJECTREGISTERLIMIT')
BEGIN
insert into Sysform(FName, Description, FCode, RequestF)
Select 'EXCEEDINGOBJECTREGISTERLIMIT','Exceeding Object Register Limit (CL)','ACTIVITIES',0
end
go


DROP Procedure QCheckMaxOutGo
GO
CREATE Procedure QCheckMaxOutGo(@P_ANO as integer, @ForceCheckMaxOutGo as Bit=0)   
as   
Declare @Temp_Code Table(ANO Int, Code varchar(10))   
  
Declare @Temp_Comm Table(ANO Int, Code varchar(10), BSType varchar(10), Comm Float)   
Declare @Temp_PrevComm Table(ANO Int, Code varchar(10), BSType varchar(10), Comm Float)   
  
Declare @Temp_Other Table(ANO Int, Code varchar(10), Disc Float, PrevDisc Float, Inward Float, PrevInward Float, UpFee Float, PrevUpFee Float)   
  
Declare @Temp Table(ANO Int, Code varchar(10), PrevOutGo Float, PrevCommA Float, PrevCommB Float, PrevCommI Float, OutGo Float, CommA Float, CommB Float, CommI Float)   
  
Declare @P_PANO Int  
Declare @P_ISType varchar(1)  
  
Insert Into  @Temp_Code(ANO, Code)  
Select Distinct R.ANO, R.Code  
from RCover R  
Where R.ANO=@P_ANO  
  
Select @P_PANO=A.PANO, @P_ISType=C.ISType from Acceptance A, Cover C Where C.CNO=A.CNO and A.ANO=@P_ANO  
   
insert into @Temp_Comm(ANO, Code, BSType, Comm)  
Select R.ANO, R.Code, O1.BSType, O1.Commission  
from @Temp_Code R  
Cross Apply (Select * from Premium_Commission_Table(R.ANO, R.Code,0,0)) O1  
  
if @P_PANO<>-1   
 insert into @Temp_PrevComm(ANO, Code, BSType, Comm)  
 Select R.ANO, R.Code, O1.BSType, O1.Commission  
 from @Temp_Code R  
 Cross Apply (Select * from Premium_Commission_Table(@P_PANO, R.Code,0,0)) O1  
  
insert into @Temp_Other(ANO, Code, Disc, PrevDisc, Inward, PrevInward, UpFee, PrevUpFee)  
Select R.ANO, R.Code,   
dbo.premium_discount(R.ANO, R.Code,0) as Disc,   
Case When @P_PANO<>-1 Then dbo.premium_discount(@P_PANO, R.Code,0) else 0 end as PrevDisc,  
Case When @P_ISType in ('C','R','T') Then dbo.Premium_HandlingFee(R.ANO, R.Code,0) Else 0 end as Inward,   
Case When @P_ISType in ('C','R','T') and @P_PANO<>-1 Then dbo.Premium_HandlingFee(@P_PANO, R.Code,0) else 0 end as PrevInward,  
dbo.Premium_Commission_UpFee(R.ANO, R.Code,0,0) as UpFee,   
Case When @P_PANO<>-1 Then dbo.Premium_Commission_UpFee(@P_PANO, R.Code,0,0) else 0 end as PrevUpFee  
from @Temp_Code R  
  
insert into @Temp(ANO, Code, PrevOutGo, PrevCommA, PrevCommB, PrevCommI, OutGo, CommA, CommB, CommI)   
Select T1.ANO, T1.Code,  
Max(T2.PrevDisc)+sum(coalesce(pT3.Comm,0))+Max(T2.PrevInward)-Max(T2.PrevUpFee) as PrevOutGo,  
sum(case When T3.BSType='A' Then coalesce(pT3.Comm,0) Else 0 end) as PrevCommA,  
sum(case When T3.BSType='B' Then coalesce(pT3.Comm,0) Else 0 end) as PrevCommB,  
Case When @P_ISType in ('C','R','T') Then sum(coalesce(pT3.Comm,0))+Max(T2.PrevInward) Else 0 end as PrevCommI,  
Max(T2.Disc)+sum(coalesce(T3.Comm,0))+Max(T2.Inward)-Max(T2.UpFee) as OutGo,  
sum(case When T3.BSType='A' Then coalesce(T3.Comm,0) Else 0 end) as CommA,  
sum(case When T3.BSType='B' Then coalesce(T3.Comm,0) Else 0 end) as CommB,  
Case When @P_ISType in ('C','R','T') Then sum(coalesce(T3.Comm,0))+Max(T2.Inward) Else 0 end as CommI  
from @Temp_Code T1  
Inner Join @Temp_Other T2 on (T2.ANO=T1.ANO and T2.Code=T1.Code)  
Left Join @Temp_Comm T3 on (T3.ANO=T1.ANO and T3.Code=T1.Code)  
Left Join @Temp_PrevComm pT3 on (pT3.ANO=T3.ANO and pT3.Code=T3.Code and pT3.BSType=T3.BSType)  
Group By T1.ANO, T1.Code  
  
   
Select R1.ANO,   
Case   
When (R1.PrevOutGo<R1.OutGo or @ForceCheckMaxOutGo=1) and R1.OutGo>R2.MaxOutGo+0.0000000001 and R2.MaxOutGo<>0 Then 'Rate Code ('+R1.Code+') Exceeding Maximum Out Go !' + char(13)+char(10)  
else ''  
End  
+  
Case   
When (R1.PrevOutGo<R1.OutGo or @ForceCheckMaxOutGo=1) and R1.OutGo>BS.MaxOutGo+0.0000000001 and BS.MaxOutGo<>0 Then 'Business Source ('+BS.ID+') Exceeding Maximum Out Go !' + char(13)+char(10)  
else ''  
End  
+  
Case   
When (R1.PrevOutGo<R1.OutGo or @ForceCheckMaxOutGo=1) and R1.OutGo>BR.MaxOutGo+0.0000000001 and BR.MaxOutGo<>0 Then 'Business Rule ('+BR.BizMapID+') Exceeding Maximum Out Go !' + char(13)+char(10)  
else ''  
End  
+  
Case   
When (R1.PrevCommA<R1.CommA or @ForceCheckMaxOutGo=1) and R1.CommA>R2.MaxCommA+0.0000000001 and R2.MaxCommA<>0 Then 'Rate Code ('+R1.Code+') Exceeding Maximum Commission Agent !' + char(13)+char(10)  
else ''  
End  
+  
Case   
When (R1.PrevCommB<R1.CommB or @ForceCheckMaxOutGo=1) and R1.CommB>R2.MaxCommB+0.0000000001 and R2.MaxCommB<>0 Then 'Rate Code ('+R1.Code+') Exceeding Maximum Commission Broker !' + char(13)+char(10)  
else ''  
End  
+  
Case   
When (R1.PrevCommI<R1.CommI or @ForceCheckMaxOutGo=1) and R1.CommI>R2.MaxCommI+0.0000000001 and R2.MaxCommI<>0 Then 'Rate Code ('+R1.Code+') Exceeding Maximum Commission Inward !' + char(13)+char(10)  
else ''  
End as ErrDesc   
from @Temp R1  
Inner Join Acceptance A on (A.ANO=R1.ANO)  
Inner Join RArrHeader R on (R.ANO=A.ANO)   
Inner Join Cover C on (C.CNO=A.CNO)   
Inner join Profile BS on (BS.ID=A.Source)   
Inner join RateTab R2 on (R2.Code=R1.Code)   
Left Join BRRule BR on (BR.TOC=A.TOC and (BR.Branch='<All>' or BR.Branch=A.Branch) and (BR.BizmapID='<All>' or BR.BizMapID=A.BizMapID) and (BR.FacOpt=0 or (BR.FacOpt=1 and R.FAmount<>0) or (BR.FacOpt=2 and R.FAmount=0)))   
Where   
(  
(R1.PrevOutGo<R1.OutGo or @ForceCheckMaxOutGo=1)  
and ((R2.MaxOutGo<>0 and R1.OutGo>R2.MaxOutGo+0.0000000001) Or (BS.MaxOutGo<>0 and R1.OutGo>BS.MaxOutGo+0.0000000001) Or (BR.MaxOutGo<>0 and R1.OutGo>BR.MaxOutGo+0.0000000001))   
)  
or  
(  
(R1.PrevCommA<R1.CommA or @ForceCheckMaxOutGo=1)   
and ((R2.MaxCommA<>0 and R1.CommA>R2.MaxCommA+0.0000000001))    
)  
or  
(  
(R1.PrevCommB<R1.CommB or @ForceCheckMaxOutGo=1)
and ((R2.MaxCommB<>0 and R1.CommB>R2.MaxCommB+0.0000000001))    
)  
or  
(  
(R1.PrevCommI<R1.CommI or @ForceCheckMaxOutGo=1)
and ((R2.MaxCommI<>0 and R1.CommI>R2.MaxCommI+0.0000000001))    
)  
  

go




insert into PatchVersioning
select '935 Update Script - 2 February  2024',GETDATE()
go


Declare @PrevScript varchar(100)
Declare @CurrScript varchar(100)

Select @PrevScript=''
Select @CurrSCript='935 Update Script - 2 February  2024'


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

 
  
  
  