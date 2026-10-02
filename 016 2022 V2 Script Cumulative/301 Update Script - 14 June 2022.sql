IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'PRATEPCT' AND Object_ID = Object_ID(N'RCOVER'))
BEGIN
ALTER TABLE dbo.RCOVER ADD
	PRATEPCT float(53) NULL
DECLARE @v sql_variant 
SET @v = N'Pure Rate Percentage'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'RCOVER', N'COLUMN', N'PRATEPCT'
end
GO


IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'PRATEPCT' AND Object_ID = Object_ID(N'RATETAB'))
BEGIN
ALTER TABLE dbo.RATETAB ADD
	PRATEPCT float(53) NULL
DECLARE @v sql_variant 
SET @v = N'Pure Rate Percentage'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'RATETAB', N'COLUMN', N'PRATEPCT'
end
GO



DROP Function FL_RateCode
GO
CREATE Function FL_RateCode(@P_ANO as integer, @P_Code as varchar(10),@P_AllowedF as bit=0, @P_TSI as float=0, @P_TOPF as bit=0)   
RETURNS @RateCon TABLE (Code varchar(10), AllowedF Bit, NoRefundF Bit, SIBasedID Int, Description varchar(255), PRatePCT Float, Unit varchar(10), Category varchar(10), Rate Float, MinRate Float, MaxRate Float, PML Float, Portion Float, Loading Float, TExcess Float)
AS
BEGIN
Declare @Temp Table (Code varchar(20), Rate Float, MinRate Float, MaxRate Float, PML Float, TExcess Int, Loading Float, AllowedF bit)  

Select @P_TSI = case When @P_TSI=0 Then 1 else @P_TSI end

Declare RateCode_Cursor Cursor For 
	Select RateTab.Code, Acceptance.SDate
	FROM  Acceptance               
	Inner join RateTab on ((RateTab.TOC=substring(Acceptance.TOC,1,len(RateTab.TOC))) and RateTab.Effective<=Acceptance.SDate and (@P_Code='%' or RateTab.Code Like @P_Code OR RateTab.Description Like @P_Code) And (RateTab.AllowedF=@P_AllowedF or @P_AllowedF=0))            
	Where Acceptance.ANO=@P_ANO  

Open RateCode_Cursor

Declare @P_Code_Temp as varchar(20)
Declare @P_SDate as smalldatetime

FETCH FROM RateCode_Cursor into @P_Code_Temp, @P_SDate
WHILE @@FETCH_STATUS = 0  
BEGIN  
	insert into @TEMP(Code, Rate, MinRate, MaxRate, PML, TExcess, Loading, AllowedF)
	Select Top 1 Code, Rate, MinRate, MaxRate, PML, TExcess, Loading, AllowedF 
	from fn_RateCon(@P_ANO,@P_Code_Temp,@P_TSI,@P_SDate) F
	FETCH Next FROM RateCode_Cursor into @P_Code_Temp, @P_SDate
End  
Close RateCode_Cursor  
Deallocate RateCode_Cursor

insert into @RateCon
SELECT  RateTab.Code, RateTab.AllowedF, RateTab.NoRefundF,  RateTab.SIBasedID,            
 max(RateTab.Description) as Description,          
 max(RateTab.PRatePCT) as PRatePCT,    
 max(RateTab.Unit) as Unit,              
 max(RClass.Category) AS Category,           
 sum(    
 case     
 When coalesce(Case When RateTab.Unit='F' then (Case When @P_TSI<>0 then F.Rate*@P_TSI/100 else 0 end) When RateTab.Unit='M' then F.Rate*10 else F.Rate end,0)<>0 then    
       Case When RateTab.Unit='F' then (Case When @P_TSI<>0 then F.Rate*@P_TSI/100 else 0 end) When RateTab.Unit='M' then F.Rate*10 else F.Rate end    
 else     
       RateTab.Rate    
 end*RateCov.Portion/100) as Rate,     
 Max(F.MinRate) as MinRate,
 Max(F.MaxRate) as MaxRate,
  --in Percentage          
 max(F.PML) as PML,              
 sum(RateCov.Portion) AS Portion,              
 MAX(Case When coalesce(F.Loading,0)=0 Then 1 else F.Loading/100 end) As Loading,    
 Max(F.TExcess) as TExcess    
FROM  Acceptance          
Inner join Cover on (Cover.CNO=Acceptance.CNO)          
Inner join RateTab on ((RateTab.TOC=substring(Acceptance.TOC,1,len(RateTab.TOC))) and RateTab.Effective<=Acceptance.SDate and (@P_Code='%' or RateTab.Code Like @P_Code OR RateTab.Description Like @P_Code) And (RateTab.AllowedF=@P_AllowedF or @P_AllowedF=0))            
Inner join RateCov on (RateCov.Code=RateTab.Code)          
Inner join RClass on (RClass.TOC=Acceptance.TOC And RClass.TOR=RateCov.TOR)          
Left Join @Temp F on (F.Code=RateTab.Code)        
WHERE  Acceptance.ANO=@P_ANO
and (@P_TOPF=0 or Acceptance.TOPRO=coalesce((SELECT TOP 1 TOP_RATE.TOPRO FROM TOP_RATE WHERE TOP_RATE.TOPRO=Acceptance.TOPRO and (TOP_Rate.Code=RateTab.Code or TOP_Rate.Code=RateTab.PCode) and RateTab.effective<=Acceptance.pDate),''))
GROUP BY RateTab.Code, RateTab.AllowedF, RateTab.NoRefundF  , RateTab.SIBasedID  

RETURN
END


GO

DROP PROCEDURE QRateCode  
GO
CREATE PROCEDURE QRateCode (@P_ANO as integer, @P_Code as varchar(20),@P_AllowedF as bit=0, @P_TSI as float=0)              
AS              
Declare @Temp Table (Code varchar(20), Rate Float, MinRate Float, MaxRate Float, PML Float, TExcess Int, Loading Float, AllowedF bit)  

Select @P_TSI = case When @P_TSI=0 Then 1 else @P_TSI end

Declare RateCode_Cursor Cursor For 
	Select RateTab.Code, Acceptance.SDate
	FROM  Acceptance               
	Inner join RateTab on ((RateTab.TOC=substring(Acceptance.TOC,1,len(RateTab.TOC))) and RateTab.Effective<=Acceptance.SDate and (@P_Code='%' or RateTab.Code Like @P_Code OR RateTab.Description Like @P_Code) And (RateTab.AllowedF=@P_AllowedF or @P_AllowedF=0))            
	Where Acceptance.ANO=@P_ANO  

Open RateCode_Cursor

Declare @P_Code_Temp as varchar(20)
Declare @P_SDate as smalldatetime

FETCH FROM RateCode_Cursor into @P_Code_Temp, @P_SDate
WHILE @@FETCH_STATUS = 0  
BEGIN  
	insert into @TEMP(Code, Rate, MinRate, MaxRate, PML, TExcess, Loading, AllowedF)
	Select Top 1 Code, Rate, MinRate, MaxRate, PML, TExcess, Loading, AllowedF 
	from fn_RateCon(@P_ANO,@P_Code_Temp,@P_TSI,@P_SDate) F
	FETCH Next FROM RateCode_Cursor into @P_Code_Temp, @P_SDate
End  
Close RateCode_Cursor  
Deallocate RateCode_Cursor


SELECT  RateTab.Code, RateTab.AllowedF, RateTab.NoRefundF,  RateTab.SIBasedID,            
 max(RateTab.Description) as Description,         
 max(RateTab.PRatePCT) as PRatePCT,     
 max(RateTab.Unit) as Unit,              
 max(RClass.Category) AS Category,           
 sum(    
 case     
 When coalesce(Case When RateTab.Unit='F' then (Case When @P_TSI<>0 then F.Rate*@P_TSI/100 else 0 end) When RateTab.Unit='M' then F.Rate*10 else F.Rate end,0)<>0 then    
       Case When RateTab.Unit='F' then (Case When @P_TSI<>0 then F.Rate*@P_TSI/100 else 0 end) When RateTab.Unit='M' then F.Rate*10 else F.Rate end    
 else     
       RateTab.Rate    
 end*RateCov.Portion/100) as Rate,     
 Max(F.MinRate) as MinRate,
 Max(F.MaxRate) as MaxRate,
  --in Percentage          
 max(F.PML) as PML,              
 sum(RateCov.Portion) AS Portion,              
 MAX(Case When coalesce(F.Loading,0)=0 Then 1 else F.Loading/100 end) As Loading,    
 Max(F.TExcess) as TExcess    
FROM  Acceptance          
Inner join Cover on (Cover.CNO=Acceptance.CNO)          
Inner join RateTab on ((RateTab.TOC=substring(Acceptance.TOC,1,len(RateTab.TOC))) and RateTab.Effective<=Acceptance.SDate and (@P_Code='%' or RateTab.Code Like @P_Code OR RateTab.Description Like @P_Code) And (RateTab.AllowedF=@P_AllowedF or @P_AllowedF=0))            
Inner join RateCov on (RateCov.Code=RateTab.Code)          
Inner join RClass on (RClass.TOC=Acceptance.TOC And RClass.TOR=RateCov.TOR)          
Left Join @Temp F on (F.Code=RateTab.Code)          
WHERE  Acceptance.ANO=@P_ANO
GROUP BY RateTab.Code, RateTab.AllowedF, RateTab.NoRefundF  , RateTab.SIBasedID  

GO
DROP Procedure QScheme_Verify_2
GO
CREATE Procedure QScheme_Verify_2 
@p_Coverage as varchar (255), 
@p_SchemeNo as varchar (10), 
@p_Description as varchar (255) 
as 
 
Declare @p_ClassNo int 
Select Top 1 @p_ClassNo=S.ClassNo 
from 
Scheme_Class S
Inner Join Scheme_Coverage S1 on (S1.ClassNo=S.ClassNo and S1.Coverage=@p_Coverage)
Where S.SchemeNo=@P_SchemeNo and @P_Description like S.Description 
Order by S.Priority Desc 
 
Select 
S1.ClassNo, 
S1.Coverage, 
S1.Code, 
S1.Rate, 
S1.GrossUpF, 
S1.Unit, 
S1.Category, 
S1.Portion, 
S1.RateLoadingF, 
S1.InclAddInterestF,
RateTab.Description,
RateTab.PRatePCT
from 
Scheme_Coverage S1 
Inner Join RateTab on (RateTab.Code=S1.Code)
Where (S1.ClassNo=@p_ClassNo and S1.Coverage=@p_Coverage) 

GO

DROP Procedure QScheme_Verify_6
GO
CREATE Procedure QScheme_Verify_6 
@p_Coverage as varchar (255), 
@p_Interest as varchar (20), 
@p_TSI as float, 
@P_NOfYears as float, 
@p_SchemeNo as varchar (10), 
@p_Description as varchar (255) 
as 

Declare @p_ClassNo int 
Select Top 1 @p_ClassNo=S.ClassNo 
from 
Scheme_Class S
Inner Join Scheme_Coverage S1 on (S1.ClassNo=S.ClassNo and S1.Coverage=@p_Coverage)
Where S.SchemeNo=@P_SchemeNo and @P_Description like S.Description 
Order by S.Priority Desc

Select Top 1 *
from 
(
	Select Top 1 
	S1.Code, 
	cast(0 as Bit) as ProgressiveF,
	(Case When @p_TSI=0 then (Case When S1.IncludeF=1 Then S1.SI else 0 end) else @P_TSI end) as SI, 
	Case       
	When S1.Unit='F' then Case When (Case When @p_TSI=0 then (Case When S1.IncludeF=1 Then S1.SI else 0 end) else @P_TSI end)<>0 Then S1.Rate/(Case When @p_TSI=0 then (Case When S1.IncludeF=1 Then S1.SI else 0 end) else @P_TSI end)*100 else 0 end
	When S1.Unit='M' then S1.Rate/10
	else S1.Rate end
	as Rate,
	S1.Unit, S1.Category, S1.Portion, S1.TOI, S1.NOTDECRF, S1.RateBasedID, 
	TOI.Description as TOIDesc, 
	TOI.Adjustable, 
	RateTab.Description as RateDesc,
	RateTab.PRatePCT,
	S1.Upper,
	S1.HoldF
	from 
	Scheme_Additional S1
	Inner Join RateTab on (RateTab.Code=S1.Code)
	Inner Join TOI on (TOI.TOI=S1.TOI)
	Where 
	S1.ClassNo=@P_ClassNo and (S1.Coverage='' or S1.Coverage=@P_Coverage) 
	and S1.Interest=@p_Interest 
	and (S1.Lower<=(Case When @p_TSI=0 then (Case When S1.IncludeF=1 Then S1.SI else 0 end) else @P_TSI end) or S1.Lower=0) 
	and (S1.Upper>=(Case When @p_TSI=0 then (Case When S1.IncludeF=1 Then S1.SI else 0 end) else @P_TSI end) or S1.Upper=0) 
	and (S1.NOfYearsL<=@p_NOfYears or S1.NOfYearsL=0) 
	and (S1.NOfYearsU>=@p_NOfYears or S1.NOfYearsU=0) 
	and S1.ProgressiveF=0

	Union All

	Select Top 1 
	S1.Code, 
	cast(1 as Bit) as ProgressiveF,
	Max((Case When @p_TSI=0 then (Case When S1.IncludeF=1 Then S1.SI else 0 end) else @P_TSI end)) as SI, 
	sum(Case       
	When S1.Unit='F' then Case When (Case When @p_TSI=0 then (Case When S1.IncludeF=1 Then S1.SI else 0 end) else @P_TSI end)<>0 Then S1.Rate/
	(Case When @p_TSI=0 then (Case When S1.IncludeF=1 Then S1.SI else 0 end) else @P_TSI end)*100 else 0 end
	When S1.Unit='M' then 
		Case When (Case When @p_TSI=0 then (Case When S1.IncludeF=1 Then S1.SI else 0 end) else @P_TSI end)>=S1.Upper Then S1.Upper-S1.Lower+1 Else (Case When @p_TSI=0 then (Case When S1.IncludeF=1 Then S1.SI else 0 end) else @P_TSI end)-S1.Lower+1 end*S1.Rate/10/(Case When @p_TSI=0 then (Case When S1.IncludeF=1 Then S1.SI else 0 end) else @P_TSI end)
	else 
	    Case When (Case When @p_TSI=0 then (Case When S1.IncludeF=1 Then S1.SI else 0 end) else @P_TSI end)>=S1.Upper Then S1.Upper-S1.Lower+1 Else (Case When @p_TSI=0 then (Case When S1.IncludeF=1 Then S1.SI else 0 end) else @P_TSI end)-S1.Lower+1 end*S1.Rate/(Case When @p_TSI=0 then (Case When S1.IncludeF=1 Then S1.SI else 0 end) else @P_TSI end) end 
	) as Rate,
	Max(S1.Unit) as Unit, Max(S1.Category) as Category, Max(S1.Portion) as Portion, 
	Max(S1.TOI) as TOI, 
	cast(Max(Cast(S1.NOTDECRF as Int)) as Bit) as NOTDECRF, 
	Max(S1.RateBasedID) as RateBasedID, 
	Max(TOI.Description) as TOIDesc, 
	cast(Max(Cast(TOI.Adjustable as Int)) as Bit) as Adjustable, 
	Max(RateTab.Description) as RateDesc,
	Max(RateTab.PRatePCT) as PRatePCT,
	Max(S1.Upper) as Upper,
	Cast(Max(cast(S1.HoldF as Int)) as Bit) as HoldF
	from Scheme_Additional S1
	Inner Join RateTab on (RateTab.Code=S1.Code)
	Inner Join TOI on (TOI.TOI=S1.TOI)
	Where S1.ClassNo=@p_ClassNo 	
	and (S1.Coverage='' or S1.Coverage=@P_Coverage) 
	and S1.Interest=@p_Interest 
	and ((Case When @p_TSI=0 then (Case When S1.IncludeF=1 Then S1.SI else 0 end) else @P_TSI end) Between S1.Lower and S1.Upper or (Case When @p_TSI=0 then (Case When S1.IncludeF=1 Then S1.SI else 0 end) else @P_TSI end)>=S1.Upper)
	and (S1.NOfYearsL<=@p_NOfYears or S1.NOfYearsL=0) 
	and (S1.NOfYearsU>=@p_NOfYears or S1.NOfYearsU=0) 
	and S1.ProgressiveF=1 and (Case When @p_TSI=0 then (Case When S1.IncludeF=1 Then S1.SI else 0 end) else @P_TSI end)<>0
	Group BY S1.Code
) R














go



 insert into PatchVersioning
select '301 Update Script - 14 June 2022',GETDATE()
go


Declare @PrevScript varchar(100)
Declare @CurrScript varchar(100)

Select @PrevScript=''
Select @CurrSCript='301 Update Script - 14 June 2022'


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
